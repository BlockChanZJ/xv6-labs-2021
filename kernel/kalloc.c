// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

int counter[(PHYSTOP - KERNBASE) / PGSIZE];

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  memset(counter, 0, sizeof(counter));
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    pageref_inc(p);
    kfree(p);
  }
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");
  
  // free when counter = 0
  pageref_dec((void*)pa);
  if (get_pageref((void*)pa) > 0)
    return;

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r) {
    memset((char*)r, 5, PGSIZE); // fill with junk
    pageref_inc((void*)r);
  }
  return (void*)r;
}

void 
pageref_inc(void *pa) 
{
  int index = (PGROUNDUP((uint64)pa) - PGROUNDUP((uint64)end)) / PGSIZE;
  counter[index]++;
}

void 
pageref_dec(void *pa) 
{
  int index = (PGROUNDUP((uint64)pa) - PGROUNDUP((uint64)end)) / PGSIZE;
  counter[index]--;
  if (counter[index] < 0) printf("pa: %p, index: %d, counter: %d\n", pa, index, counter[index]);
}

void 
set_pageref(void *pa, int val)
{
  int index = (PGROUNDUP((uint64)pa) - PGROUNDUP((uint64)end)) / PGSIZE;
  counter[index] = val;
}

int 
get_pageref(void *pa) 
{
  int index = (PGROUNDUP((uint64)pa) - PGROUNDUP((uint64)end)) / PGSIZE;
  return counter[index];
}