// Buffer cache.

// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.

// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"


extern uint ticks;

struct {
  struct spinlock lock[NBUCKET + 1]; // the last lock for lock race
  struct buf buf[NBUF];

  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head[NBUCKET];
  struct buf tail[NBUCKET];
} bcache;

inline int hash (int blockno) {
  return blockno % NBUCKET;
}


void pop(struct buf *b) {
  if (b->blockno != MAGIC_NUM && !holding(&bcache.lock[hash(b->blockno)]))
    panic("pop: not holding lock");
  b->next->prev = b->prev;
  b->prev->next = b->next;
}

void insert(struct buf *b, int id) {
  if (b->blockno != MAGIC_NUM && !holding(&bcache.lock[hash(b->blockno)]) && !holding(&bcache.lock[id]))
    panic("insert: not holding lock");
  b->prev = &bcache.head[id];
  b->next = bcache.head[id].next;
  bcache.head[id].next->prev = b;
  bcache.head[id].next = b;
}

void
binit(void)
{
  struct buf *b;
  int i;

  // Create linked list of buffers
  for (i = 0; i < NBUCKET; i++) {
    initlock(&bcache.lock[i], "bcache");
    bcache.head[i].prev = 0;
    bcache.tail[i].next = 0;
    bcache.head[i].next = &bcache.tail[i];
    bcache.tail[i].prev = &bcache.head[i];
  }

  for(i = 0, b = bcache.buf; b < bcache.buf+NBUF; b++, i = (i+1) % NBUCKET) {
    b->blockno = MAGIC_NUM;
    initsleeplock(&b->lock, "buffer");
    insert(b, i);
  }
  printf("binit finished!\n");
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;
  int id = hash(blockno);
  // if (holding(&bcache.lock[id])) 
  //   panic("bget: already hold lock");
  acquire(&bcache.lock[id]);
  // printf("bget in! hold lock %d\n",id);

  // Is the block already cached?
  for (b = bcache.head[id].next; b != &bcache.tail[id]; b = b->next) {
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.lock[id]);
      acquiresleep(&b->lock);
      // printf("bget out! release lock %d\n",id);
      return b;
    }
  }

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.
  // for (b = bcache.head[id].next; b != &bcache.tail[id]; b = b->next) {
  for (b = bcache.tail[id].prev; b != &bcache.head[id]; b = b->prev) {
    if(b->refcnt == 0) {
      b->dev = dev;
      b->blockno = blockno;
      b->valid = 0;
      b->refcnt = 1;
      release(&bcache.lock[id]);
      acquiresleep(&b->lock);
      // printf("bget out! release lock %d\n",id);
      return b;
    }
  }


  // avoid deadlock
  release(&bcache.lock[id]);

  // if (holding(&bcache.lock[id])) 
  //   panic("bget: already hold lock");
  
  // if (holding(&bcache.lock[NBUCKET]))
  //   panic("bget: already hold locklock");

  acquire(&bcache.lock[NBUCKET]);
  acquire(&bcache.lock[id]);

  // borrow pages
  for (int i = 0; i < NBUCKET; i++) {
    if (i == id) continue;
    // printf("i = %d\n",i);
    acquire(&bcache.lock[i]); // maybe deadlock
    // printf("%d : %p %p\n",i, bcache.head[i].prev,&bcache.head[i]);
    // for (b = bcache.head[i].next; b != &bcache.tail[i]; b = b->next) {
    for (b = bcache.tail[i].prev; b != &bcache.head[i]; b = b->prev) {
      if (b->refcnt == 0) {

        pop(b);
        insert(b, id);

        b->dev = dev;
        b->blockno = blockno;
        b->valid = 0;
        b->refcnt = 1;

        release(&bcache.lock[i]);
        release(&bcache.lock[id]);
        release(&bcache.lock[NBUCKET]);

        acquiresleep(&b->lock);
        // printf("bget out! release lock %d\n",id);
        return b;
      }
    }
    release(&bcache.lock[i]);
  }

  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  int id = hash(b->blockno);
  // if (b->blockno == MAGIC_NUM) {
  //   panic("brelse: magic number");
  // }

  acquire(&bcache.lock[id]);
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    pop(b);
    insert(b, id);
  }
  
  release(&bcache.lock[id]);
}

void
bpin(struct buf *b) {
  int id = hash(b->blockno);

  acquire(&bcache.lock[id]);
  b->refcnt++;
  release(&bcache.lock[id]);
}

void
bunpin(struct buf *b) {
  int id = hash(b->blockno);

  acquire(&bcache.lock[id]);
  b->refcnt--;
  release(&bcache.lock[id]);
}


