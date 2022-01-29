
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	89013103          	ld	sp,-1904(sp) # 80008890 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	103050ef          	jal	ra,80005918 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	0002a797          	auipc	a5,0x2a
    80000034:	21078793          	addi	a5,a5,528 # 8002a240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	324080e7          	jalr	804(ra) # 8000637e <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	3c4080e7          	jalr	964(ra) # 80006432 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	d3e080e7          	jalr	-706(ra) # 80005dc8 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	1fa080e7          	jalr	506(ra) # 800062ee <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	0002a517          	auipc	a0,0x2a
    80000104:	14050513          	addi	a0,a0,320 # 8002a240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	252080e7          	jalr	594(ra) # 8000637e <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	2ee080e7          	jalr	750(ra) # 80006432 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	2c4080e7          	jalr	708(ra) # 80006432 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	aee080e7          	jalr	-1298(ra) # 80000e1c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ad2080e7          	jalr	-1326(ra) # 80000e1c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	ab6080e7          	jalr	-1354(ra) # 80005e12 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	730080e7          	jalr	1840(ra) # 80001a9c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	f2c080e7          	jalr	-212(ra) # 800052a0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fde080e7          	jalr	-34(ra) # 8000135a <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	956080e7          	jalr	-1706(ra) # 80005cda <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	c6c080e7          	jalr	-916(ra) # 80005ff8 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	a76080e7          	jalr	-1418(ra) # 80005e12 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	a66080e7          	jalr	-1434(ra) # 80005e12 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	a56080e7          	jalr	-1450(ra) # 80005e12 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	990080e7          	jalr	-1648(ra) # 80000d6c <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	690080e7          	jalr	1680(ra) # 80001a74 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6b0080e7          	jalr	1712(ra) # 80001a9c <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	e96080e7          	jalr	-362(ra) # 8000528a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	ea4080e7          	jalr	-348(ra) # 800052a0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	07e080e7          	jalr	126(ra) # 80002482 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	70e080e7          	jalr	1806(ra) # 80002b1a <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	6b8080e7          	jalr	1720(ra) # 80003acc <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	fa6080e7          	jalr	-90(ra) # 800053c2 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	cfc080e7          	jalr	-772(ra) # 80001120 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	93a080e7          	jalr	-1734(ra) # 80005dc8 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
{
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	842080e7          	jalr	-1982(ra) # 80005dc8 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	832080e7          	jalr	-1998(ra) # 80005dc8 <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00005097          	auipc	ra,0x5
    80000614:	7b8080e7          	jalr	1976(ra) # 80005dc8 <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	5fe080e7          	jalr	1534(ra) # 80000cd6 <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6b05                	lui	s6,0x1
    8000073a:	0735e863          	bltu	a1,s3,800007aa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00005097          	auipc	ra,0x5
    80000760:	66c080e7          	jalr	1644(ra) # 80005dc8 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	65c080e7          	jalr	1628(ra) # 80005dc8 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	64c080e7          	jalr	1612(ra) # 80005dc8 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	63c080e7          	jalr	1596(ra) # 80005dc8 <panic>
      uint64 pa = PTE2PA(*pte);
    80000794:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000796:	0532                	slli	a0,a0,0xc
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	884080e7          	jalr	-1916(ra) # 8000001c <kfree>
    *pte = 0;
    800007a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a4:	995a                	add	s2,s2,s6
    800007a6:	f9397ce3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007aa:	4601                	li	a2,0
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8552                	mv	a0,s4
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	cb0080e7          	jalr	-848(ra) # 80000460 <walk>
    800007b8:	84aa                	mv	s1,a0
    800007ba:	d54d                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007bc:	6108                	ld	a0,0(a0)
    800007be:	00157793          	andi	a5,a0,1
    800007c2:	dbcd                	beqz	a5,80000774 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c4:	3ff57793          	andi	a5,a0,1023
    800007c8:	fb778ee3          	beq	a5,s7,80000784 <uvmunmap+0x76>
    if(do_free){
    800007cc:	fc0a8ae3          	beqz	s5,800007a0 <uvmunmap+0x92>
    800007d0:	b7d1                	j	80000794 <uvmunmap+0x86>

00000000800007d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d2:	1101                	addi	sp,sp,-32
    800007d4:	ec06                	sd	ra,24(sp)
    800007d6:	e822                	sd	s0,16(sp)
    800007d8:	e426                	sd	s1,8(sp)
    800007da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	93c080e7          	jalr	-1732(ra) # 80000118 <kalloc>
    800007e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e6:	c519                	beqz	a0,800007f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e8:	6605                	lui	a2,0x1
    800007ea:	4581                	li	a1,0
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	98c080e7          	jalr	-1652(ra) # 80000178 <memset>
  return pagetable;
}
    800007f4:	8526                	mv	a0,s1
    800007f6:	60e2                	ld	ra,24(sp)
    800007f8:	6442                	ld	s0,16(sp)
    800007fa:	64a2                	ld	s1,8(sp)
    800007fc:	6105                	addi	sp,sp,32
    800007fe:	8082                	ret

0000000080000800 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000800:	7179                	addi	sp,sp,-48
    80000802:	f406                	sd	ra,40(sp)
    80000804:	f022                	sd	s0,32(sp)
    80000806:	ec26                	sd	s1,24(sp)
    80000808:	e84a                	sd	s2,16(sp)
    8000080a:	e44e                	sd	s3,8(sp)
    8000080c:	e052                	sd	s4,0(sp)
    8000080e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000810:	6785                	lui	a5,0x1
    80000812:	04f67863          	bgeu	a2,a5,80000862 <uvminit+0x62>
    80000816:	8a2a                	mv	s4,a0
    80000818:	89ae                	mv	s3,a1
    8000081a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	8fc080e7          	jalr	-1796(ra) # 80000118 <kalloc>
    80000824:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	94e080e7          	jalr	-1714(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000832:	4779                	li	a4,30
    80000834:	86ca                	mv	a3,s2
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	8552                	mv	a0,s4
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	d0c080e7          	jalr	-756(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000844:	8626                	mv	a2,s1
    80000846:	85ce                	mv	a1,s3
    80000848:	854a                	mv	a0,s2
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	98e080e7          	jalr	-1650(ra) # 800001d8 <memmove>
}
    80000852:	70a2                	ld	ra,40(sp)
    80000854:	7402                	ld	s0,32(sp)
    80000856:	64e2                	ld	s1,24(sp)
    80000858:	6942                	ld	s2,16(sp)
    8000085a:	69a2                	ld	s3,8(sp)
    8000085c:	6a02                	ld	s4,0(sp)
    8000085e:	6145                	addi	sp,sp,48
    80000860:	8082                	ret
    panic("inituvm: more than a page");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	87650513          	addi	a0,a0,-1930 # 800080d8 <etext+0xd8>
    8000086a:	00005097          	auipc	ra,0x5
    8000086e:	55e080e7          	jalr	1374(ra) # 80005dc8 <panic>

0000000080000872 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000872:	1101                	addi	sp,sp,-32
    80000874:	ec06                	sd	ra,24(sp)
    80000876:	e822                	sd	s0,16(sp)
    80000878:	e426                	sd	s1,8(sp)
    8000087a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087e:	00b67d63          	bgeu	a2,a1,80000898 <uvmdealloc+0x26>
    80000882:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000884:	6785                	lui	a5,0x1
    80000886:	17fd                	addi	a5,a5,-1
    80000888:	00f60733          	add	a4,a2,a5
    8000088c:	767d                	lui	a2,0xfffff
    8000088e:	8f71                	and	a4,a4,a2
    80000890:	97ae                	add	a5,a5,a1
    80000892:	8ff1                	and	a5,a5,a2
    80000894:	00f76863          	bltu	a4,a5,800008a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000898:	8526                	mv	a0,s1
    8000089a:	60e2                	ld	ra,24(sp)
    8000089c:	6442                	ld	s0,16(sp)
    8000089e:	64a2                	ld	s1,8(sp)
    800008a0:	6105                	addi	sp,sp,32
    800008a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a4:	8f99                	sub	a5,a5,a4
    800008a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a8:	4685                	li	a3,1
    800008aa:	0007861b          	sext.w	a2,a5
    800008ae:	85ba                	mv	a1,a4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	e5e080e7          	jalr	-418(ra) # 8000070e <uvmunmap>
    800008b8:	b7c5                	j	80000898 <uvmdealloc+0x26>

00000000800008ba <uvmalloc>:
  if(newsz < oldsz)
    800008ba:	0ab66163          	bltu	a2,a1,8000095c <uvmalloc+0xa2>
{
    800008be:	7139                	addi	sp,sp,-64
    800008c0:	fc06                	sd	ra,56(sp)
    800008c2:	f822                	sd	s0,48(sp)
    800008c4:	f426                	sd	s1,40(sp)
    800008c6:	f04a                	sd	s2,32(sp)
    800008c8:	ec4e                	sd	s3,24(sp)
    800008ca:	e852                	sd	s4,16(sp)
    800008cc:	e456                	sd	s5,8(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6985                	lui	s3,0x1
    800008d6:	19fd                	addi	s3,s3,-1
    800008d8:	95ce                	add	a1,a1,s3
    800008da:	79fd                	lui	s3,0xfffff
    800008dc:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f063          	bgeu	s3,a2,80000960 <uvmalloc+0xa6>
    800008e4:	894e                	mv	s2,s3
    mem = kalloc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	832080e7          	jalr	-1998(ra) # 80000118 <kalloc>
    800008ee:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f0:	c51d                	beqz	a0,8000091e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008f2:	6605                	lui	a2,0x1
    800008f4:	4581                	li	a1,0
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	882080e7          	jalr	-1918(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008fe:	4779                	li	a4,30
    80000900:	86a6                	mv	a3,s1
    80000902:	6605                	lui	a2,0x1
    80000904:	85ca                	mv	a1,s2
    80000906:	8556                	mv	a0,s5
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	c40080e7          	jalr	-960(ra) # 80000548 <mappages>
    80000910:	e905                	bnez	a0,80000940 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000912:	6785                	lui	a5,0x1
    80000914:	993e                	add	s2,s2,a5
    80000916:	fd4968e3          	bltu	s2,s4,800008e6 <uvmalloc+0x2c>
  return newsz;
    8000091a:	8552                	mv	a0,s4
    8000091c:	a809                	j	8000092e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000091e:	864e                	mv	a2,s3
    80000920:	85ca                	mv	a1,s2
    80000922:	8556                	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f4e080e7          	jalr	-178(ra) # 80000872 <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
}
    8000092e:	70e2                	ld	ra,56(sp)
    80000930:	7442                	ld	s0,48(sp)
    80000932:	74a2                	ld	s1,40(sp)
    80000934:	7902                	ld	s2,32(sp)
    80000936:	69e2                	ld	s3,24(sp)
    80000938:	6a42                	ld	s4,16(sp)
    8000093a:	6aa2                	ld	s5,8(sp)
    8000093c:	6121                	addi	sp,sp,64
    8000093e:	8082                	ret
      kfree(mem);
    80000940:	8526                	mv	a0,s1
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094a:	864e                	mv	a2,s3
    8000094c:	85ca                	mv	a1,s2
    8000094e:	8556                	mv	a0,s5
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f22080e7          	jalr	-222(ra) # 80000872 <uvmdealloc>
      return 0;
    80000958:	4501                	li	a0,0
    8000095a:	bfd1                	j	8000092e <uvmalloc+0x74>
    return oldsz;
    8000095c:	852e                	mv	a0,a1
}
    8000095e:	8082                	ret
  return newsz;
    80000960:	8532                	mv	a0,a2
    80000962:	b7f1                	j	8000092e <uvmalloc+0x74>

0000000080000964 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000964:	7179                	addi	sp,sp,-48
    80000966:	f406                	sd	ra,40(sp)
    80000968:	f022                	sd	s0,32(sp)
    8000096a:	ec26                	sd	s1,24(sp)
    8000096c:	e84a                	sd	s2,16(sp)
    8000096e:	e44e                	sd	s3,8(sp)
    80000970:	e052                	sd	s4,0(sp)
    80000972:	1800                	addi	s0,sp,48
    80000974:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000976:	84aa                	mv	s1,a0
    80000978:	6905                	lui	s2,0x1
    8000097a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097c:	4985                	li	s3,1
    8000097e:	a821                	j	80000996 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000980:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000982:	0532                	slli	a0,a0,0xc
    80000984:	00000097          	auipc	ra,0x0
    80000988:	fe0080e7          	jalr	-32(ra) # 80000964 <freewalk>
      pagetable[i] = 0;
    8000098c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000990:	04a1                	addi	s1,s1,8
    80000992:	03248163          	beq	s1,s2,800009b4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000996:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000998:	00f57793          	andi	a5,a0,15
    8000099c:	ff3782e3          	beq	a5,s3,80000980 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a0:	8905                	andi	a0,a0,1
    800009a2:	d57d                	beqz	a0,80000990 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a4:	00007517          	auipc	a0,0x7
    800009a8:	75450513          	addi	a0,a0,1876 # 800080f8 <etext+0xf8>
    800009ac:	00005097          	auipc	ra,0x5
    800009b0:	41c080e7          	jalr	1052(ra) # 80005dc8 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b4:	8552                	mv	a0,s4
    800009b6:	fffff097          	auipc	ra,0xfffff
    800009ba:	666080e7          	jalr	1638(ra) # 8000001c <kfree>
}
    800009be:	70a2                	ld	ra,40(sp)
    800009c0:	7402                	ld	s0,32(sp)
    800009c2:	64e2                	ld	s1,24(sp)
    800009c4:	6942                	ld	s2,16(sp)
    800009c6:	69a2                	ld	s3,8(sp)
    800009c8:	6a02                	ld	s4,0(sp)
    800009ca:	6145                	addi	sp,sp,48
    800009cc:	8082                	ret

00000000800009ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	1000                	addi	s0,sp,32
    800009d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009da:	e999                	bnez	a1,800009f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009dc:	8526                	mv	a0,s1
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	f86080e7          	jalr	-122(ra) # 80000964 <freewalk>
}
    800009e6:	60e2                	ld	ra,24(sp)
    800009e8:	6442                	ld	s0,16(sp)
    800009ea:	64a2                	ld	s1,8(sp)
    800009ec:	6105                	addi	sp,sp,32
    800009ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	167d                	addi	a2,a2,-1
    800009f4:	962e                	add	a2,a2,a1
    800009f6:	4685                	li	a3,1
    800009f8:	8231                	srli	a2,a2,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d12080e7          	jalr	-750(ra) # 8000070e <uvmunmap>
    80000a04:	bfe1                	j	800009dc <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c679                	beqz	a2,80000ad4 <uvmcopy+0xce>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8b2a                	mv	s6,a0
    80000a20:	8aae                	mv	s5,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a26:	4601                	li	a2,0
    80000a28:	85ce                	mv	a1,s3
    80000a2a:	855a                	mv	a0,s6
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	a34080e7          	jalr	-1484(ra) # 80000460 <walk>
    80000a34:	c531                	beqz	a0,80000a80 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a36:	6118                	ld	a4,0(a0)
    80000a38:	00177793          	andi	a5,a4,1
    80000a3c:	cbb1                	beqz	a5,80000a90 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3e:	00a75593          	srli	a1,a4,0xa
    80000a42:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a46:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	6ce080e7          	jalr	1742(ra) # 80000118 <kalloc>
    80000a52:	892a                	mv	s2,a0
    80000a54:	c939                	beqz	a0,80000aaa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85de                	mv	a1,s7
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	77e080e7          	jalr	1918(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a62:	8726                	mv	a4,s1
    80000a64:	86ca                	mv	a3,s2
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85ce                	mv	a1,s3
    80000a6a:	8556                	mv	a0,s5
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	adc080e7          	jalr	-1316(ra) # 80000548 <mappages>
    80000a74:	e515                	bnez	a0,80000aa0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	6785                	lui	a5,0x1
    80000a78:	99be                	add	s3,s3,a5
    80000a7a:	fb49e6e3          	bltu	s3,s4,80000a26 <uvmcopy+0x20>
    80000a7e:	a081                	j	80000abe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	68850513          	addi	a0,a0,1672 # 80008108 <etext+0x108>
    80000a88:	00005097          	auipc	ra,0x5
    80000a8c:	340080e7          	jalr	832(ra) # 80005dc8 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	330080e7          	jalr	816(ra) # 80005dc8 <panic>
      kfree(mem);
    80000aa0:	854a                	mv	a0,s2
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	57a080e7          	jalr	1402(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aaa:	4685                	li	a3,1
    80000aac:	00c9d613          	srli	a2,s3,0xc
    80000ab0:	4581                	li	a1,0
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	c5a080e7          	jalr	-934(ra) # 8000070e <uvmunmap>
  return -1;
    80000abc:	557d                	li	a0,-1
}
    80000abe:	60a6                	ld	ra,72(sp)
    80000ac0:	6406                	ld	s0,64(sp)
    80000ac2:	74e2                	ld	s1,56(sp)
    80000ac4:	7942                	ld	s2,48(sp)
    80000ac6:	79a2                	ld	s3,40(sp)
    80000ac8:	7a02                	ld	s4,32(sp)
    80000aca:	6ae2                	ld	s5,24(sp)
    80000acc:	6b42                	ld	s6,16(sp)
    80000ace:	6ba2                	ld	s7,8(sp)
    80000ad0:	6161                	addi	sp,sp,80
    80000ad2:	8082                	ret
  return 0;
    80000ad4:	4501                	li	a0,0
}
    80000ad6:	8082                	ret

0000000080000ad8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad8:	1141                	addi	sp,sp,-16
    80000ada:	e406                	sd	ra,8(sp)
    80000adc:	e022                	sd	s0,0(sp)
    80000ade:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae0:	4601                	li	a2,0
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	97e080e7          	jalr	-1666(ra) # 80000460 <walk>
  if(pte == 0)
    80000aea:	c901                	beqz	a0,80000afa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aec:	611c                	ld	a5,0(a0)
    80000aee:	9bbd                	andi	a5,a5,-17
    80000af0:	e11c                	sd	a5,0(a0)
}
    80000af2:	60a2                	ld	ra,8(sp)
    80000af4:	6402                	ld	s0,0(sp)
    80000af6:	0141                	addi	sp,sp,16
    80000af8:	8082                	ret
    panic("uvmclear");
    80000afa:	00007517          	auipc	a0,0x7
    80000afe:	64e50513          	addi	a0,a0,1614 # 80008148 <etext+0x148>
    80000b02:	00005097          	auipc	ra,0x5
    80000b06:	2c6080e7          	jalr	710(ra) # 80005dc8 <panic>

0000000080000b0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0a:	c6bd                	beqz	a3,80000b78 <copyout+0x6e>
{
    80000b0c:	715d                	addi	sp,sp,-80
    80000b0e:	e486                	sd	ra,72(sp)
    80000b10:	e0a2                	sd	s0,64(sp)
    80000b12:	fc26                	sd	s1,56(sp)
    80000b14:	f84a                	sd	s2,48(sp)
    80000b16:	f44e                	sd	s3,40(sp)
    80000b18:	f052                	sd	s4,32(sp)
    80000b1a:	ec56                	sd	s5,24(sp)
    80000b1c:	e85a                	sd	s6,16(sp)
    80000b1e:	e45e                	sd	s7,8(sp)
    80000b20:	e062                	sd	s8,0(sp)
    80000b22:	0880                	addi	s0,sp,80
    80000b24:	8b2a                	mv	s6,a0
    80000b26:	8c2e                	mv	s8,a1
    80000b28:	8a32                	mv	s4,a2
    80000b2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2e:	6a85                	lui	s5,0x1
    80000b30:	a015                	j	80000b54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b32:	9562                	add	a0,a0,s8
    80000b34:	0004861b          	sext.w	a2,s1
    80000b38:	85d2                	mv	a1,s4
    80000b3a:	41250533          	sub	a0,a0,s2
    80000b3e:	fffff097          	auipc	ra,0xfffff
    80000b42:	69a080e7          	jalr	1690(ra) # 800001d8 <memmove>

    len -= n;
    80000b46:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b50:	02098263          	beqz	s3,80000b74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b58:	85ca                	mv	a1,s2
    80000b5a:	855a                	mv	a0,s6
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	9aa080e7          	jalr	-1622(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b64:	cd01                	beqz	a0,80000b7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b66:	418904b3          	sub	s1,s2,s8
    80000b6a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b6c:	fc99f3e3          	bgeu	s3,s1,80000b32 <copyout+0x28>
    80000b70:	84ce                	mv	s1,s3
    80000b72:	b7c1                	j	80000b32 <copyout+0x28>
  }
  return 0;
    80000b74:	4501                	li	a0,0
    80000b76:	a021                	j	80000b7e <copyout+0x74>
    80000b78:	4501                	li	a0,0
}
    80000b7a:	8082                	ret
      return -1;
    80000b7c:	557d                	li	a0,-1
}
    80000b7e:	60a6                	ld	ra,72(sp)
    80000b80:	6406                	ld	s0,64(sp)
    80000b82:	74e2                	ld	s1,56(sp)
    80000b84:	7942                	ld	s2,48(sp)
    80000b86:	79a2                	ld	s3,40(sp)
    80000b88:	7a02                	ld	s4,32(sp)
    80000b8a:	6ae2                	ld	s5,24(sp)
    80000b8c:	6b42                	ld	s6,16(sp)
    80000b8e:	6ba2                	ld	s7,8(sp)
    80000b90:	6c02                	ld	s8,0(sp)
    80000b92:	6161                	addi	sp,sp,80
    80000b94:	8082                	ret

0000000080000b96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b96:	c6bd                	beqz	a3,80000c04 <copyin+0x6e>
{
    80000b98:	715d                	addi	sp,sp,-80
    80000b9a:	e486                	sd	ra,72(sp)
    80000b9c:	e0a2                	sd	s0,64(sp)
    80000b9e:	fc26                	sd	s1,56(sp)
    80000ba0:	f84a                	sd	s2,48(sp)
    80000ba2:	f44e                	sd	s3,40(sp)
    80000ba4:	f052                	sd	s4,32(sp)
    80000ba6:	ec56                	sd	s5,24(sp)
    80000ba8:	e85a                	sd	s6,16(sp)
    80000baa:	e45e                	sd	s7,8(sp)
    80000bac:	e062                	sd	s8,0(sp)
    80000bae:	0880                	addi	s0,sp,80
    80000bb0:	8b2a                	mv	s6,a0
    80000bb2:	8a2e                	mv	s4,a1
    80000bb4:	8c32                	mv	s8,a2
    80000bb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bba:	6a85                	lui	s5,0x1
    80000bbc:	a015                	j	80000be0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbe:	9562                	add	a0,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412505b3          	sub	a1,a0,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60e080e7          	jalr	1550(ra) # 800001d8 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	91e080e7          	jalr	-1762(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf8:	fc99f3e3          	bgeu	s3,s1,80000bbe <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	b7c1                	j	80000bbe <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x74>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c6c5                	beqz	a3,80000cca <copyinstr+0xa8>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a035                	j	80000c72 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	0017b793          	seqz	a5,a5
    80000c52:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c56:	60a6                	ld	ra,72(sp)
    80000c58:	6406                	ld	s0,64(sp)
    80000c5a:	74e2                	ld	s1,56(sp)
    80000c5c:	7942                	ld	s2,48(sp)
    80000c5e:	79a2                	ld	s3,40(sp)
    80000c60:	7a02                	ld	s4,32(sp)
    80000c62:	6ae2                	ld	s5,24(sp)
    80000c64:	6b42                	ld	s6,16(sp)
    80000c66:	6ba2                	ld	s7,8(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c70:	c8a9                	beqz	s1,80000cc2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85ca                	mv	a1,s2
    80000c78:	8552                	mv	a0,s4
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	88c080e7          	jalr	-1908(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c82:	c131                	beqz	a0,80000cc6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c84:	41790833          	sub	a6,s2,s7
    80000c88:	984e                	add	a6,a6,s3
    if(n > max)
    80000c8a:	0104f363          	bgeu	s1,a6,80000c90 <copyinstr+0x6e>
    80000c8e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c90:	955e                	add	a0,a0,s7
    80000c92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c96:	fc080be3          	beqz	a6,80000c6c <copyinstr+0x4a>
    80000c9a:	985a                	add	a6,a6,s6
    80000c9c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c9e:	41650633          	sub	a2,a0,s6
    80000ca2:	14fd                	addi	s1,s1,-1
    80000ca4:	9b26                	add	s6,s6,s1
    80000ca6:	00f60733          	add	a4,a2,a5
    80000caa:	00074703          	lbu	a4,0(a4)
    80000cae:	df49                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cb0:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cba:	ff0796e3          	bne	a5,a6,80000ca6 <copyinstr+0x84>
      dst++;
    80000cbe:	8b42                	mv	s6,a6
    80000cc0:	b775                	j	80000c6c <copyinstr+0x4a>
    80000cc2:	4781                	li	a5,0
    80000cc4:	b769                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc6:	557d                	li	a0,-1
    80000cc8:	b779                	j	80000c56 <copyinstr+0x34>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	0017b793          	seqz	a5,a5
    80000cd0:	40f00533          	neg	a0,a5
}
    80000cd4:	8082                	ret

0000000080000cd6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd6:	7139                	addi	sp,sp,-64
    80000cd8:	fc06                	sd	ra,56(sp)
    80000cda:	f822                	sd	s0,48(sp)
    80000cdc:	f426                	sd	s1,40(sp)
    80000cde:	f04a                	sd	s2,32(sp)
    80000ce0:	ec4e                	sd	s3,24(sp)
    80000ce2:	e852                	sd	s4,16(sp)
    80000ce4:	e456                	sd	s5,8(sp)
    80000ce6:	e05a                	sd	s6,0(sp)
    80000ce8:	0080                	addi	s0,sp,64
    80000cea:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cec:	00008497          	auipc	s1,0x8
    80000cf0:	79448493          	addi	s1,s1,1940 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf4:	8b26                	mv	s6,s1
    80000cf6:	00007a97          	auipc	s5,0x7
    80000cfa:	30aa8a93          	addi	s5,s5,778 # 80008000 <etext>
    80000cfe:	04000937          	lui	s2,0x4000
    80000d02:	197d                	addi	s2,s2,-1
    80000d04:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d06:	00012a17          	auipc	s4,0x12
    80000d0a:	77aa0a13          	addi	s4,s4,1914 # 80013480 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if(pa == 0)
    80000d18:	c131                	beqz	a0,80000d5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	859d                	srai	a1,a1,0x7
    80000d20:	000ab783          	ld	a5,0(s5)
    80000d24:	02f585b3          	mul	a1,a1,a5
    80000d28:	2585                	addiw	a1,a1,1
    80000d2a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2e:	4719                	li	a4,6
    80000d30:	6685                	lui	a3,0x1
    80000d32:	40b905b3          	sub	a1,s2,a1
    80000d36:	854e                	mv	a0,s3
    80000d38:	00000097          	auipc	ra,0x0
    80000d3c:	8b0080e7          	jalr	-1872(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d40:	28048493          	addi	s1,s1,640
    80000d44:	fd4495e3          	bne	s1,s4,80000d0e <proc_mapstacks+0x38>
  }
}
    80000d48:	70e2                	ld	ra,56(sp)
    80000d4a:	7442                	ld	s0,48(sp)
    80000d4c:	74a2                	ld	s1,40(sp)
    80000d4e:	7902                	ld	s2,32(sp)
    80000d50:	69e2                	ld	s3,24(sp)
    80000d52:	6a42                	ld	s4,16(sp)
    80000d54:	6aa2                	ld	s5,8(sp)
    80000d56:	6b02                	ld	s6,0(sp)
    80000d58:	6121                	addi	sp,sp,64
    80000d5a:	8082                	ret
      panic("kalloc");
    80000d5c:	00007517          	auipc	a0,0x7
    80000d60:	3fc50513          	addi	a0,a0,1020 # 80008158 <etext+0x158>
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	064080e7          	jalr	100(ra) # 80005dc8 <panic>

0000000080000d6c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d6c:	7139                	addi	sp,sp,-64
    80000d6e:	fc06                	sd	ra,56(sp)
    80000d70:	f822                	sd	s0,48(sp)
    80000d72:	f426                	sd	s1,40(sp)
    80000d74:	f04a                	sd	s2,32(sp)
    80000d76:	ec4e                	sd	s3,24(sp)
    80000d78:	e852                	sd	s4,16(sp)
    80000d7a:	e456                	sd	s5,8(sp)
    80000d7c:	e05a                	sd	s6,0(sp)
    80000d7e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d80:	00007597          	auipc	a1,0x7
    80000d84:	3e058593          	addi	a1,a1,992 # 80008160 <etext+0x160>
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	2c850513          	addi	a0,a0,712 # 80009050 <pid_lock>
    80000d90:	00005097          	auipc	ra,0x5
    80000d94:	55e080e7          	jalr	1374(ra) # 800062ee <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	546080e7          	jalr	1350(ra) # 800062ee <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	00008497          	auipc	s1,0x8
    80000db4:	6d048493          	addi	s1,s1,1744 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db8:	00007b17          	auipc	s6,0x7
    80000dbc:	3c0b0b13          	addi	s6,s6,960 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dc0:	8aa6                	mv	s5,s1
    80000dc2:	00007a17          	auipc	s4,0x7
    80000dc6:	23ea0a13          	addi	s4,s4,574 # 80008000 <etext>
    80000dca:	04000937          	lui	s2,0x4000
    80000dce:	197d                	addi	s2,s2,-1
    80000dd0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd2:	00012997          	auipc	s3,0x12
    80000dd6:	6ae98993          	addi	s3,s3,1710 # 80013480 <tickslock>
      initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	510080e7          	jalr	1296(ra) # 800062ee <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	415487b3          	sub	a5,s1,s5
    80000dea:	879d                	srai	a5,a5,0x7
    80000dec:	000a3703          	ld	a4,0(s4)
    80000df0:	02e787b3          	mul	a5,a5,a4
    80000df4:	2785                	addiw	a5,a5,1
    80000df6:	00d7979b          	slliw	a5,a5,0xd
    80000dfa:	40f907b3          	sub	a5,s2,a5
    80000dfe:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	28048493          	addi	s1,s1,640
    80000e04:	fd349be3          	bne	s1,s3,80000dda <procinit+0x6e>
  }
}
    80000e08:	70e2                	ld	ra,56(sp)
    80000e0a:	7442                	ld	s0,48(sp)
    80000e0c:	74a2                	ld	s1,40(sp)
    80000e0e:	7902                	ld	s2,32(sp)
    80000e10:	69e2                	ld	s3,24(sp)
    80000e12:	6a42                	ld	s4,16(sp)
    80000e14:	6aa2                	ld	s5,8(sp)
    80000e16:	6b02                	ld	s6,0(sp)
    80000e18:	6121                	addi	sp,sp,64
    80000e1a:	8082                	ret

0000000080000e1c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e22:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e24:	2501                	sext.w	a0,a0
    80000e26:	6422                	ld	s0,8(sp)
    80000e28:	0141                	addi	sp,sp,16
    80000e2a:	8082                	ret

0000000080000e2c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
    80000e32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e34:	2781                	sext.w	a5,a5
    80000e36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e38:	00008517          	auipc	a0,0x8
    80000e3c:	24850513          	addi	a0,a0,584 # 80009080 <cpus>
    80000e40:	953e                	add	a0,a0,a5
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e48:	1101                	addi	sp,sp,-32
    80000e4a:	ec06                	sd	ra,24(sp)
    80000e4c:	e822                	sd	s0,16(sp)
    80000e4e:	e426                	sd	s1,8(sp)
    80000e50:	1000                	addi	s0,sp,32
  push_off();
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	4e0080e7          	jalr	1248(ra) # 80006332 <push_off>
    80000e5a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e5c:	2781                	sext.w	a5,a5
    80000e5e:	079e                	slli	a5,a5,0x7
    80000e60:	00008717          	auipc	a4,0x8
    80000e64:	1f070713          	addi	a4,a4,496 # 80009050 <pid_lock>
    80000e68:	97ba                	add	a5,a5,a4
    80000e6a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e6c:	00005097          	auipc	ra,0x5
    80000e70:	566080e7          	jalr	1382(ra) # 800063d2 <pop_off>
  return p;
}
    80000e74:	8526                	mv	a0,s1
    80000e76:	60e2                	ld	ra,24(sp)
    80000e78:	6442                	ld	s0,16(sp)
    80000e7a:	64a2                	ld	s1,8(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e406                	sd	ra,8(sp)
    80000e84:	e022                	sd	s0,0(sp)
    80000e86:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e88:	00000097          	auipc	ra,0x0
    80000e8c:	fc0080e7          	jalr	-64(ra) # 80000e48 <myproc>
    80000e90:	00005097          	auipc	ra,0x5
    80000e94:	5a2080e7          	jalr	1442(ra) # 80006432 <release>

  if (first) {
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	9a87a783          	lw	a5,-1624(a5) # 80008840 <first.1713>
    80000ea0:	eb89                	bnez	a5,80000eb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea2:	00001097          	auipc	ra,0x1
    80000ea6:	c12080e7          	jalr	-1006(ra) # 80001ab4 <usertrapret>
}
    80000eaa:	60a2                	ld	ra,8(sp)
    80000eac:	6402                	ld	s0,0(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret
    first = 0;
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	9807a723          	sw	zero,-1650(a5) # 80008840 <first.1713>
    fsinit(ROOTDEV);
    80000eba:	4505                	li	a0,1
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	bde080e7          	jalr	-1058(ra) # 80002a9a <fsinit>
    80000ec4:	bff9                	j	80000ea2 <forkret+0x22>

0000000080000ec6 <allocpid>:
allocpid() {
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	e04a                	sd	s2,0(sp)
    80000ed0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed2:	00008917          	auipc	s2,0x8
    80000ed6:	17e90913          	addi	s2,s2,382 # 80009050 <pid_lock>
    80000eda:	854a                	mv	a0,s2
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	4a2080e7          	jalr	1186(ra) # 8000637e <acquire>
  pid = nextpid;
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	96078793          	addi	a5,a5,-1696 # 80008844 <nextpid>
    80000eec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eee:	0014871b          	addiw	a4,s1,1
    80000ef2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	53c080e7          	jalr	1340(ra) # 80006432 <release>
}
    80000efe:	8526                	mv	a0,s1
    80000f00:	60e2                	ld	ra,24(sp)
    80000f02:	6442                	ld	s0,16(sp)
    80000f04:	64a2                	ld	s1,8(sp)
    80000f06:	6902                	ld	s2,0(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <proc_pagetable>:
{
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
    80000f18:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	8b8080e7          	jalr	-1864(ra) # 800007d2 <uvmcreate>
    80000f22:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f24:	c121                	beqz	a0,80000f64 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f26:	4729                	li	a4,10
    80000f28:	00006697          	auipc	a3,0x6
    80000f2c:	0d868693          	addi	a3,a3,216 # 80007000 <_trampoline>
    80000f30:	6605                	lui	a2,0x1
    80000f32:	040005b7          	lui	a1,0x4000
    80000f36:	15fd                	addi	a1,a1,-1
    80000f38:	05b2                	slli	a1,a1,0xc
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	60e080e7          	jalr	1550(ra) # 80000548 <mappages>
    80000f42:	02054863          	bltz	a0,80000f72 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f46:	4719                	li	a4,6
    80000f48:	05893683          	ld	a3,88(s2)
    80000f4c:	6605                	lui	a2,0x1
    80000f4e:	020005b7          	lui	a1,0x2000
    80000f52:	15fd                	addi	a1,a1,-1
    80000f54:	05b6                	slli	a1,a1,0xd
    80000f56:	8526                	mv	a0,s1
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	5f0080e7          	jalr	1520(ra) # 80000548 <mappages>
    80000f60:	02054163          	bltz	a0,80000f82 <proc_pagetable+0x76>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	addi	sp,sp,32
    80000f70:	8082                	ret
    uvmfree(pagetable, 0);
    80000f72:	4581                	li	a1,0
    80000f74:	8526                	mv	a0,s1
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	a58080e7          	jalr	-1448(ra) # 800009ce <uvmfree>
    return 0;
    80000f7e:	4481                	li	s1,0
    80000f80:	b7d5                	j	80000f64 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f82:	4681                	li	a3,0
    80000f84:	4605                	li	a2,1
    80000f86:	040005b7          	lui	a1,0x4000
    80000f8a:	15fd                	addi	a1,a1,-1
    80000f8c:	05b2                	slli	a1,a1,0xc
    80000f8e:	8526                	mv	a0,s1
    80000f90:	fffff097          	auipc	ra,0xfffff
    80000f94:	77e080e7          	jalr	1918(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f98:	4581                	li	a1,0
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	a32080e7          	jalr	-1486(ra) # 800009ce <uvmfree>
    return 0;
    80000fa4:	4481                	li	s1,0
    80000fa6:	bf7d                	j	80000f64 <proc_pagetable+0x58>

0000000080000fa8 <proc_freepagetable>:
{
    80000fa8:	1101                	addi	sp,sp,-32
    80000faa:	ec06                	sd	ra,24(sp)
    80000fac:	e822                	sd	s0,16(sp)
    80000fae:	e426                	sd	s1,8(sp)
    80000fb0:	e04a                	sd	s2,0(sp)
    80000fb2:	1000                	addi	s0,sp,32
    80000fb4:	84aa                	mv	s1,a0
    80000fb6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb8:	4681                	li	a3,0
    80000fba:	4605                	li	a2,1
    80000fbc:	040005b7          	lui	a1,0x4000
    80000fc0:	15fd                	addi	a1,a1,-1
    80000fc2:	05b2                	slli	a1,a1,0xc
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	74a080e7          	jalr	1866(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	020005b7          	lui	a1,0x2000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b6                	slli	a1,a1,0xd
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	734080e7          	jalr	1844(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe2:	85ca                	mv	a1,s2
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	9e8080e7          	jalr	-1560(ra) # 800009ce <uvmfree>
}
    80000fee:	60e2                	ld	ra,24(sp)
    80000ff0:	6442                	ld	s0,16(sp)
    80000ff2:	64a2                	ld	s1,8(sp)
    80000ff4:	6902                	ld	s2,0(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <freeproc>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	1000                	addi	s0,sp,32
    80001004:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001006:	6d28                	ld	a0,88(a0)
    80001008:	c509                	beqz	a0,80001012 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001012:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001016:	68a8                	ld	a0,80(s1)
    80001018:	c511                	beqz	a0,80001024 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000101a:	64ac                	ld	a1,72(s1)
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	f8c080e7          	jalr	-116(ra) # 80000fa8 <proc_freepagetable>
  p->pagetable = 0;
    80001024:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001028:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000102c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001030:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001034:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001038:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000103c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001040:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001044:	0004ac23          	sw	zero,24(s1)
}
    80001048:	60e2                	ld	ra,24(sp)
    8000104a:	6442                	ld	s0,16(sp)
    8000104c:	64a2                	ld	s1,8(sp)
    8000104e:	6105                	addi	sp,sp,32
    80001050:	8082                	ret

0000000080001052 <allocproc>:
{
    80001052:	1101                	addi	sp,sp,-32
    80001054:	ec06                	sd	ra,24(sp)
    80001056:	e822                	sd	s0,16(sp)
    80001058:	e426                	sd	s1,8(sp)
    8000105a:	e04a                	sd	s2,0(sp)
    8000105c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105e:	00008497          	auipc	s1,0x8
    80001062:	42248493          	addi	s1,s1,1058 # 80009480 <proc>
    80001066:	00012917          	auipc	s2,0x12
    8000106a:	41a90913          	addi	s2,s2,1050 # 80013480 <tickslock>
    acquire(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	00005097          	auipc	ra,0x5
    80001074:	30e080e7          	jalr	782(ra) # 8000637e <acquire>
    if(p->state == UNUSED) {
    80001078:	4c9c                	lw	a5,24(s1)
    8000107a:	cf81                	beqz	a5,80001092 <allocproc+0x40>
      release(&p->lock);
    8000107c:	8526                	mv	a0,s1
    8000107e:	00005097          	auipc	ra,0x5
    80001082:	3b4080e7          	jalr	948(ra) # 80006432 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001086:	28048493          	addi	s1,s1,640
    8000108a:	ff2492e3          	bne	s1,s2,8000106e <allocproc+0x1c>
  return 0;
    8000108e:	4481                	li	s1,0
    80001090:	a889                	j	800010e2 <allocproc+0x90>
  p->pid = allocpid();
    80001092:	00000097          	auipc	ra,0x0
    80001096:	e34080e7          	jalr	-460(ra) # 80000ec6 <allocpid>
    8000109a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000109c:	4785                	li	a5,1
    8000109e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010a0:	fffff097          	auipc	ra,0xfffff
    800010a4:	078080e7          	jalr	120(ra) # 80000118 <kalloc>
    800010a8:	892a                	mv	s2,a0
    800010aa:	eca8                	sd	a0,88(s1)
    800010ac:	c131                	beqz	a0,800010f0 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ae:	8526                	mv	a0,s1
    800010b0:	00000097          	auipc	ra,0x0
    800010b4:	e5c080e7          	jalr	-420(ra) # 80000f0c <proc_pagetable>
    800010b8:	892a                	mv	s2,a0
    800010ba:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010bc:	c531                	beqz	a0,80001108 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010be:	07000613          	li	a2,112
    800010c2:	4581                	li	a1,0
    800010c4:	06048513          	addi	a0,s1,96
    800010c8:	fffff097          	auipc	ra,0xfffff
    800010cc:	0b0080e7          	jalr	176(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010d0:	00000797          	auipc	a5,0x0
    800010d4:	db078793          	addi	a5,a5,-592 # 80000e80 <forkret>
    800010d8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010da:	60bc                	ld	a5,64(s1)
    800010dc:	6705                	lui	a4,0x1
    800010de:	97ba                	add	a5,a5,a4
    800010e0:	f4bc                	sd	a5,104(s1)
}
    800010e2:	8526                	mv	a0,s1
    800010e4:	60e2                	ld	ra,24(sp)
    800010e6:	6442                	ld	s0,16(sp)
    800010e8:	64a2                	ld	s1,8(sp)
    800010ea:	6902                	ld	s2,0(sp)
    800010ec:	6105                	addi	sp,sp,32
    800010ee:	8082                	ret
    freeproc(p);
    800010f0:	8526                	mv	a0,s1
    800010f2:	00000097          	auipc	ra,0x0
    800010f6:	f08080e7          	jalr	-248(ra) # 80000ffa <freeproc>
    release(&p->lock);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00005097          	auipc	ra,0x5
    80001100:	336080e7          	jalr	822(ra) # 80006432 <release>
    return 0;
    80001104:	84ca                	mv	s1,s2
    80001106:	bff1                	j	800010e2 <allocproc+0x90>
    freeproc(p);
    80001108:	8526                	mv	a0,s1
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	ef0080e7          	jalr	-272(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001112:	8526                	mv	a0,s1
    80001114:	00005097          	auipc	ra,0x5
    80001118:	31e080e7          	jalr	798(ra) # 80006432 <release>
    return 0;
    8000111c:	84ca                	mv	s1,s2
    8000111e:	b7d1                	j	800010e2 <allocproc+0x90>

0000000080001120 <userinit>:
{
    80001120:	1101                	addi	sp,sp,-32
    80001122:	ec06                	sd	ra,24(sp)
    80001124:	e822                	sd	s0,16(sp)
    80001126:	e426                	sd	s1,8(sp)
    80001128:	1000                	addi	s0,sp,32
  p = allocproc();
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f28080e7          	jalr	-216(ra) # 80001052 <allocproc>
    80001132:	84aa                	mv	s1,a0
  initproc = p;
    80001134:	00008797          	auipc	a5,0x8
    80001138:	eca7be23          	sd	a0,-292(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000113c:	03400613          	li	a2,52
    80001140:	00007597          	auipc	a1,0x7
    80001144:	71058593          	addi	a1,a1,1808 # 80008850 <initcode>
    80001148:	6928                	ld	a0,80(a0)
    8000114a:	fffff097          	auipc	ra,0xfffff
    8000114e:	6b6080e7          	jalr	1718(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    80001152:	6785                	lui	a5,0x1
    80001154:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001156:	6cb8                	ld	a4,88(s1)
    80001158:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000115c:	6cb8                	ld	a4,88(s1)
    8000115e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001160:	4641                	li	a2,16
    80001162:	00007597          	auipc	a1,0x7
    80001166:	01e58593          	addi	a1,a1,30 # 80008180 <etext+0x180>
    8000116a:	15848513          	addi	a0,s1,344
    8000116e:	fffff097          	auipc	ra,0xfffff
    80001172:	15c080e7          	jalr	348(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001176:	00007517          	auipc	a0,0x7
    8000117a:	01a50513          	addi	a0,a0,26 # 80008190 <etext+0x190>
    8000117e:	00002097          	auipc	ra,0x2
    80001182:	34a080e7          	jalr	842(ra) # 800034c8 <namei>
    80001186:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000118a:	478d                	li	a5,3
    8000118c:	cc9c                	sw	a5,24(s1)
  p->passed_intervals = 0;
    8000118e:	1604aa23          	sw	zero,372(s1)
  p->in_handler = 0;
    80001192:	1604ac23          	sw	zero,376(s1)
  release(&p->lock);
    80001196:	8526                	mv	a0,s1
    80001198:	00005097          	auipc	ra,0x5
    8000119c:	29a080e7          	jalr	666(ra) # 80006432 <release>
}
    800011a0:	60e2                	ld	ra,24(sp)
    800011a2:	6442                	ld	s0,16(sp)
    800011a4:	64a2                	ld	s1,8(sp)
    800011a6:	6105                	addi	sp,sp,32
    800011a8:	8082                	ret

00000000800011aa <growproc>:
{
    800011aa:	1101                	addi	sp,sp,-32
    800011ac:	ec06                	sd	ra,24(sp)
    800011ae:	e822                	sd	s0,16(sp)
    800011b0:	e426                	sd	s1,8(sp)
    800011b2:	e04a                	sd	s2,0(sp)
    800011b4:	1000                	addi	s0,sp,32
    800011b6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011b8:	00000097          	auipc	ra,0x0
    800011bc:	c90080e7          	jalr	-880(ra) # 80000e48 <myproc>
    800011c0:	892a                	mv	s2,a0
  sz = p->sz;
    800011c2:	652c                	ld	a1,72(a0)
    800011c4:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011c8:	00904f63          	bgtz	s1,800011e6 <growproc+0x3c>
  } else if(n < 0){
    800011cc:	0204cc63          	bltz	s1,80001204 <growproc+0x5a>
  p->sz = sz;
    800011d0:	1602                	slli	a2,a2,0x20
    800011d2:	9201                	srli	a2,a2,0x20
    800011d4:	04c93423          	sd	a2,72(s2)
  return 0;
    800011d8:	4501                	li	a0,0
}
    800011da:	60e2                	ld	ra,24(sp)
    800011dc:	6442                	ld	s0,16(sp)
    800011de:	64a2                	ld	s1,8(sp)
    800011e0:	6902                	ld	s2,0(sp)
    800011e2:	6105                	addi	sp,sp,32
    800011e4:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011e6:	9e25                	addw	a2,a2,s1
    800011e8:	1602                	slli	a2,a2,0x20
    800011ea:	9201                	srli	a2,a2,0x20
    800011ec:	1582                	slli	a1,a1,0x20
    800011ee:	9181                	srli	a1,a1,0x20
    800011f0:	6928                	ld	a0,80(a0)
    800011f2:	fffff097          	auipc	ra,0xfffff
    800011f6:	6c8080e7          	jalr	1736(ra) # 800008ba <uvmalloc>
    800011fa:	0005061b          	sext.w	a2,a0
    800011fe:	fa69                	bnez	a2,800011d0 <growproc+0x26>
      return -1;
    80001200:	557d                	li	a0,-1
    80001202:	bfe1                	j	800011da <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001204:	9e25                	addw	a2,a2,s1
    80001206:	1602                	slli	a2,a2,0x20
    80001208:	9201                	srli	a2,a2,0x20
    8000120a:	1582                	slli	a1,a1,0x20
    8000120c:	9181                	srli	a1,a1,0x20
    8000120e:	6928                	ld	a0,80(a0)
    80001210:	fffff097          	auipc	ra,0xfffff
    80001214:	662080e7          	jalr	1634(ra) # 80000872 <uvmdealloc>
    80001218:	0005061b          	sext.w	a2,a0
    8000121c:	bf55                	j	800011d0 <growproc+0x26>

000000008000121e <fork>:
{
    8000121e:	7179                	addi	sp,sp,-48
    80001220:	f406                	sd	ra,40(sp)
    80001222:	f022                	sd	s0,32(sp)
    80001224:	ec26                	sd	s1,24(sp)
    80001226:	e84a                	sd	s2,16(sp)
    80001228:	e44e                	sd	s3,8(sp)
    8000122a:	e052                	sd	s4,0(sp)
    8000122c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	c1a080e7          	jalr	-998(ra) # 80000e48 <myproc>
    80001236:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001238:	00000097          	auipc	ra,0x0
    8000123c:	e1a080e7          	jalr	-486(ra) # 80001052 <allocproc>
    80001240:	10050b63          	beqz	a0,80001356 <fork+0x138>
    80001244:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001246:	04893603          	ld	a2,72(s2)
    8000124a:	692c                	ld	a1,80(a0)
    8000124c:	05093503          	ld	a0,80(s2)
    80001250:	fffff097          	auipc	ra,0xfffff
    80001254:	7b6080e7          	jalr	1974(ra) # 80000a06 <uvmcopy>
    80001258:	04054663          	bltz	a0,800012a4 <fork+0x86>
  np->sz = p->sz;
    8000125c:	04893783          	ld	a5,72(s2)
    80001260:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001264:	05893683          	ld	a3,88(s2)
    80001268:	87b6                	mv	a5,a3
    8000126a:	0589b703          	ld	a4,88(s3)
    8000126e:	12068693          	addi	a3,a3,288
    80001272:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001276:	6788                	ld	a0,8(a5)
    80001278:	6b8c                	ld	a1,16(a5)
    8000127a:	6f90                	ld	a2,24(a5)
    8000127c:	01073023          	sd	a6,0(a4)
    80001280:	e708                	sd	a0,8(a4)
    80001282:	eb0c                	sd	a1,16(a4)
    80001284:	ef10                	sd	a2,24(a4)
    80001286:	02078793          	addi	a5,a5,32
    8000128a:	02070713          	addi	a4,a4,32
    8000128e:	fed792e3          	bne	a5,a3,80001272 <fork+0x54>
  np->trapframe->a0 = 0;
    80001292:	0589b783          	ld	a5,88(s3)
    80001296:	0607b823          	sd	zero,112(a5)
    8000129a:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    8000129e:	15000a13          	li	s4,336
    800012a2:	a03d                	j	800012d0 <fork+0xb2>
    freeproc(np);
    800012a4:	854e                	mv	a0,s3
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	d54080e7          	jalr	-684(ra) # 80000ffa <freeproc>
    release(&np->lock);
    800012ae:	854e                	mv	a0,s3
    800012b0:	00005097          	auipc	ra,0x5
    800012b4:	182080e7          	jalr	386(ra) # 80006432 <release>
    return -1;
    800012b8:	5a7d                	li	s4,-1
    800012ba:	a069                	j	80001344 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012bc:	00003097          	auipc	ra,0x3
    800012c0:	8a2080e7          	jalr	-1886(ra) # 80003b5e <filedup>
    800012c4:	009987b3          	add	a5,s3,s1
    800012c8:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012ca:	04a1                	addi	s1,s1,8
    800012cc:	01448763          	beq	s1,s4,800012da <fork+0xbc>
    if(p->ofile[i])
    800012d0:	009907b3          	add	a5,s2,s1
    800012d4:	6388                	ld	a0,0(a5)
    800012d6:	f17d                	bnez	a0,800012bc <fork+0x9e>
    800012d8:	bfcd                	j	800012ca <fork+0xac>
  np->cwd = idup(p->cwd);
    800012da:	15093503          	ld	a0,336(s2)
    800012de:	00002097          	auipc	ra,0x2
    800012e2:	9f6080e7          	jalr	-1546(ra) # 80002cd4 <idup>
    800012e6:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012ea:	4641                	li	a2,16
    800012ec:	15890593          	addi	a1,s2,344
    800012f0:	15898513          	addi	a0,s3,344
    800012f4:	fffff097          	auipc	ra,0xfffff
    800012f8:	fd6080e7          	jalr	-42(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800012fc:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001300:	854e                	mv	a0,s3
    80001302:	00005097          	auipc	ra,0x5
    80001306:	130080e7          	jalr	304(ra) # 80006432 <release>
  acquire(&wait_lock);
    8000130a:	00008497          	auipc	s1,0x8
    8000130e:	d5e48493          	addi	s1,s1,-674 # 80009068 <wait_lock>
    80001312:	8526                	mv	a0,s1
    80001314:	00005097          	auipc	ra,0x5
    80001318:	06a080e7          	jalr	106(ra) # 8000637e <acquire>
  np->parent = p;
    8000131c:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001320:	8526                	mv	a0,s1
    80001322:	00005097          	auipc	ra,0x5
    80001326:	110080e7          	jalr	272(ra) # 80006432 <release>
  acquire(&np->lock);
    8000132a:	854e                	mv	a0,s3
    8000132c:	00005097          	auipc	ra,0x5
    80001330:	052080e7          	jalr	82(ra) # 8000637e <acquire>
  np->state = RUNNABLE;
    80001334:	478d                	li	a5,3
    80001336:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000133a:	854e                	mv	a0,s3
    8000133c:	00005097          	auipc	ra,0x5
    80001340:	0f6080e7          	jalr	246(ra) # 80006432 <release>
}
    80001344:	8552                	mv	a0,s4
    80001346:	70a2                	ld	ra,40(sp)
    80001348:	7402                	ld	s0,32(sp)
    8000134a:	64e2                	ld	s1,24(sp)
    8000134c:	6942                	ld	s2,16(sp)
    8000134e:	69a2                	ld	s3,8(sp)
    80001350:	6a02                	ld	s4,0(sp)
    80001352:	6145                	addi	sp,sp,48
    80001354:	8082                	ret
    return -1;
    80001356:	5a7d                	li	s4,-1
    80001358:	b7f5                	j	80001344 <fork+0x126>

000000008000135a <scheduler>:
{
    8000135a:	7139                	addi	sp,sp,-64
    8000135c:	fc06                	sd	ra,56(sp)
    8000135e:	f822                	sd	s0,48(sp)
    80001360:	f426                	sd	s1,40(sp)
    80001362:	f04a                	sd	s2,32(sp)
    80001364:	ec4e                	sd	s3,24(sp)
    80001366:	e852                	sd	s4,16(sp)
    80001368:	e456                	sd	s5,8(sp)
    8000136a:	e05a                	sd	s6,0(sp)
    8000136c:	0080                	addi	s0,sp,64
    8000136e:	8792                	mv	a5,tp
  int id = r_tp();
    80001370:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001372:	00779a93          	slli	s5,a5,0x7
    80001376:	00008717          	auipc	a4,0x8
    8000137a:	cda70713          	addi	a4,a4,-806 # 80009050 <pid_lock>
    8000137e:	9756                	add	a4,a4,s5
    80001380:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001384:	00008717          	auipc	a4,0x8
    80001388:	d0470713          	addi	a4,a4,-764 # 80009088 <cpus+0x8>
    8000138c:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000138e:	498d                	li	s3,3
        p->state = RUNNING;
    80001390:	4b11                	li	s6,4
        c->proc = p;
    80001392:	079e                	slli	a5,a5,0x7
    80001394:	00008a17          	auipc	s4,0x8
    80001398:	cbca0a13          	addi	s4,s4,-836 # 80009050 <pid_lock>
    8000139c:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000139e:	00012917          	auipc	s2,0x12
    800013a2:	0e290913          	addi	s2,s2,226 # 80013480 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013a6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013aa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013ae:	10079073          	csrw	sstatus,a5
    800013b2:	00008497          	auipc	s1,0x8
    800013b6:	0ce48493          	addi	s1,s1,206 # 80009480 <proc>
    800013ba:	a03d                	j	800013e8 <scheduler+0x8e>
        p->state = RUNNING;
    800013bc:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013c0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013c4:	06048593          	addi	a1,s1,96
    800013c8:	8556                	mv	a0,s5
    800013ca:	00000097          	auipc	ra,0x0
    800013ce:	640080e7          	jalr	1600(ra) # 80001a0a <swtch>
        c->proc = 0;
    800013d2:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013d6:	8526                	mv	a0,s1
    800013d8:	00005097          	auipc	ra,0x5
    800013dc:	05a080e7          	jalr	90(ra) # 80006432 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e0:	28048493          	addi	s1,s1,640
    800013e4:	fd2481e3          	beq	s1,s2,800013a6 <scheduler+0x4c>
      acquire(&p->lock);
    800013e8:	8526                	mv	a0,s1
    800013ea:	00005097          	auipc	ra,0x5
    800013ee:	f94080e7          	jalr	-108(ra) # 8000637e <acquire>
      if(p->state == RUNNABLE) {
    800013f2:	4c9c                	lw	a5,24(s1)
    800013f4:	ff3791e3          	bne	a5,s3,800013d6 <scheduler+0x7c>
    800013f8:	b7d1                	j	800013bc <scheduler+0x62>

00000000800013fa <sched>:
{
    800013fa:	7179                	addi	sp,sp,-48
    800013fc:	f406                	sd	ra,40(sp)
    800013fe:	f022                	sd	s0,32(sp)
    80001400:	ec26                	sd	s1,24(sp)
    80001402:	e84a                	sd	s2,16(sp)
    80001404:	e44e                	sd	s3,8(sp)
    80001406:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001408:	00000097          	auipc	ra,0x0
    8000140c:	a40080e7          	jalr	-1472(ra) # 80000e48 <myproc>
    80001410:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001412:	00005097          	auipc	ra,0x5
    80001416:	ef2080e7          	jalr	-270(ra) # 80006304 <holding>
    8000141a:	c93d                	beqz	a0,80001490 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000141c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000141e:	2781                	sext.w	a5,a5
    80001420:	079e                	slli	a5,a5,0x7
    80001422:	00008717          	auipc	a4,0x8
    80001426:	c2e70713          	addi	a4,a4,-978 # 80009050 <pid_lock>
    8000142a:	97ba                	add	a5,a5,a4
    8000142c:	0a87a703          	lw	a4,168(a5)
    80001430:	4785                	li	a5,1
    80001432:	06f71763          	bne	a4,a5,800014a0 <sched+0xa6>
  if(p->state == RUNNING)
    80001436:	4c98                	lw	a4,24(s1)
    80001438:	4791                	li	a5,4
    8000143a:	06f70b63          	beq	a4,a5,800014b0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000143e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001442:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001444:	efb5                	bnez	a5,800014c0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001446:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001448:	00008917          	auipc	s2,0x8
    8000144c:	c0890913          	addi	s2,s2,-1016 # 80009050 <pid_lock>
    80001450:	2781                	sext.w	a5,a5
    80001452:	079e                	slli	a5,a5,0x7
    80001454:	97ca                	add	a5,a5,s2
    80001456:	0ac7a983          	lw	s3,172(a5)
    8000145a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000145c:	2781                	sext.w	a5,a5
    8000145e:	079e                	slli	a5,a5,0x7
    80001460:	00008597          	auipc	a1,0x8
    80001464:	c2858593          	addi	a1,a1,-984 # 80009088 <cpus+0x8>
    80001468:	95be                	add	a1,a1,a5
    8000146a:	06048513          	addi	a0,s1,96
    8000146e:	00000097          	auipc	ra,0x0
    80001472:	59c080e7          	jalr	1436(ra) # 80001a0a <swtch>
    80001476:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001478:	2781                	sext.w	a5,a5
    8000147a:	079e                	slli	a5,a5,0x7
    8000147c:	97ca                	add	a5,a5,s2
    8000147e:	0b37a623          	sw	s3,172(a5)
}
    80001482:	70a2                	ld	ra,40(sp)
    80001484:	7402                	ld	s0,32(sp)
    80001486:	64e2                	ld	s1,24(sp)
    80001488:	6942                	ld	s2,16(sp)
    8000148a:	69a2                	ld	s3,8(sp)
    8000148c:	6145                	addi	sp,sp,48
    8000148e:	8082                	ret
    panic("sched p->lock");
    80001490:	00007517          	auipc	a0,0x7
    80001494:	d0850513          	addi	a0,a0,-760 # 80008198 <etext+0x198>
    80001498:	00005097          	auipc	ra,0x5
    8000149c:	930080e7          	jalr	-1744(ra) # 80005dc8 <panic>
    panic("sched locks");
    800014a0:	00007517          	auipc	a0,0x7
    800014a4:	d0850513          	addi	a0,a0,-760 # 800081a8 <etext+0x1a8>
    800014a8:	00005097          	auipc	ra,0x5
    800014ac:	920080e7          	jalr	-1760(ra) # 80005dc8 <panic>
    panic("sched running");
    800014b0:	00007517          	auipc	a0,0x7
    800014b4:	d0850513          	addi	a0,a0,-760 # 800081b8 <etext+0x1b8>
    800014b8:	00005097          	auipc	ra,0x5
    800014bc:	910080e7          	jalr	-1776(ra) # 80005dc8 <panic>
    panic("sched interruptible");
    800014c0:	00007517          	auipc	a0,0x7
    800014c4:	d0850513          	addi	a0,a0,-760 # 800081c8 <etext+0x1c8>
    800014c8:	00005097          	auipc	ra,0x5
    800014cc:	900080e7          	jalr	-1792(ra) # 80005dc8 <panic>

00000000800014d0 <yield>:
{
    800014d0:	1101                	addi	sp,sp,-32
    800014d2:	ec06                	sd	ra,24(sp)
    800014d4:	e822                	sd	s0,16(sp)
    800014d6:	e426                	sd	s1,8(sp)
    800014d8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014da:	00000097          	auipc	ra,0x0
    800014de:	96e080e7          	jalr	-1682(ra) # 80000e48 <myproc>
    800014e2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014e4:	00005097          	auipc	ra,0x5
    800014e8:	e9a080e7          	jalr	-358(ra) # 8000637e <acquire>
  p->state = RUNNABLE;
    800014ec:	478d                	li	a5,3
    800014ee:	cc9c                	sw	a5,24(s1)
  sched();
    800014f0:	00000097          	auipc	ra,0x0
    800014f4:	f0a080e7          	jalr	-246(ra) # 800013fa <sched>
  release(&p->lock);
    800014f8:	8526                	mv	a0,s1
    800014fa:	00005097          	auipc	ra,0x5
    800014fe:	f38080e7          	jalr	-200(ra) # 80006432 <release>
}
    80001502:	60e2                	ld	ra,24(sp)
    80001504:	6442                	ld	s0,16(sp)
    80001506:	64a2                	ld	s1,8(sp)
    80001508:	6105                	addi	sp,sp,32
    8000150a:	8082                	ret

000000008000150c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000150c:	7179                	addi	sp,sp,-48
    8000150e:	f406                	sd	ra,40(sp)
    80001510:	f022                	sd	s0,32(sp)
    80001512:	ec26                	sd	s1,24(sp)
    80001514:	e84a                	sd	s2,16(sp)
    80001516:	e44e                	sd	s3,8(sp)
    80001518:	1800                	addi	s0,sp,48
    8000151a:	89aa                	mv	s3,a0
    8000151c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	92a080e7          	jalr	-1750(ra) # 80000e48 <myproc>
    80001526:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	e56080e7          	jalr	-426(ra) # 8000637e <acquire>
  release(lk);
    80001530:	854a                	mv	a0,s2
    80001532:	00005097          	auipc	ra,0x5
    80001536:	f00080e7          	jalr	-256(ra) # 80006432 <release>

  // Go to sleep.
  p->chan = chan;
    8000153a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000153e:	4789                	li	a5,2
    80001540:	cc9c                	sw	a5,24(s1)

  sched();
    80001542:	00000097          	auipc	ra,0x0
    80001546:	eb8080e7          	jalr	-328(ra) # 800013fa <sched>

  // Tidy up.
  p->chan = 0;
    8000154a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000154e:	8526                	mv	a0,s1
    80001550:	00005097          	auipc	ra,0x5
    80001554:	ee2080e7          	jalr	-286(ra) # 80006432 <release>
  acquire(lk);
    80001558:	854a                	mv	a0,s2
    8000155a:	00005097          	auipc	ra,0x5
    8000155e:	e24080e7          	jalr	-476(ra) # 8000637e <acquire>
}
    80001562:	70a2                	ld	ra,40(sp)
    80001564:	7402                	ld	s0,32(sp)
    80001566:	64e2                	ld	s1,24(sp)
    80001568:	6942                	ld	s2,16(sp)
    8000156a:	69a2                	ld	s3,8(sp)
    8000156c:	6145                	addi	sp,sp,48
    8000156e:	8082                	ret

0000000080001570 <wait>:
{
    80001570:	715d                	addi	sp,sp,-80
    80001572:	e486                	sd	ra,72(sp)
    80001574:	e0a2                	sd	s0,64(sp)
    80001576:	fc26                	sd	s1,56(sp)
    80001578:	f84a                	sd	s2,48(sp)
    8000157a:	f44e                	sd	s3,40(sp)
    8000157c:	f052                	sd	s4,32(sp)
    8000157e:	ec56                	sd	s5,24(sp)
    80001580:	e85a                	sd	s6,16(sp)
    80001582:	e45e                	sd	s7,8(sp)
    80001584:	e062                	sd	s8,0(sp)
    80001586:	0880                	addi	s0,sp,80
    80001588:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	8be080e7          	jalr	-1858(ra) # 80000e48 <myproc>
    80001592:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001594:	00008517          	auipc	a0,0x8
    80001598:	ad450513          	addi	a0,a0,-1324 # 80009068 <wait_lock>
    8000159c:	00005097          	auipc	ra,0x5
    800015a0:	de2080e7          	jalr	-542(ra) # 8000637e <acquire>
    havekids = 0;
    800015a4:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015a6:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015a8:	00012997          	auipc	s3,0x12
    800015ac:	ed898993          	addi	s3,s3,-296 # 80013480 <tickslock>
        havekids = 1;
    800015b0:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015b2:	00008c17          	auipc	s8,0x8
    800015b6:	ab6c0c13          	addi	s8,s8,-1354 # 80009068 <wait_lock>
    havekids = 0;
    800015ba:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015bc:	00008497          	auipc	s1,0x8
    800015c0:	ec448493          	addi	s1,s1,-316 # 80009480 <proc>
    800015c4:	a0bd                	j	80001632 <wait+0xc2>
          pid = np->pid;
    800015c6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015ca:	000b0e63          	beqz	s6,800015e6 <wait+0x76>
    800015ce:	4691                	li	a3,4
    800015d0:	02c48613          	addi	a2,s1,44
    800015d4:	85da                	mv	a1,s6
    800015d6:	05093503          	ld	a0,80(s2)
    800015da:	fffff097          	auipc	ra,0xfffff
    800015de:	530080e7          	jalr	1328(ra) # 80000b0a <copyout>
    800015e2:	02054563          	bltz	a0,8000160c <wait+0x9c>
          freeproc(np);
    800015e6:	8526                	mv	a0,s1
    800015e8:	00000097          	auipc	ra,0x0
    800015ec:	a12080e7          	jalr	-1518(ra) # 80000ffa <freeproc>
          release(&np->lock);
    800015f0:	8526                	mv	a0,s1
    800015f2:	00005097          	auipc	ra,0x5
    800015f6:	e40080e7          	jalr	-448(ra) # 80006432 <release>
          release(&wait_lock);
    800015fa:	00008517          	auipc	a0,0x8
    800015fe:	a6e50513          	addi	a0,a0,-1426 # 80009068 <wait_lock>
    80001602:	00005097          	auipc	ra,0x5
    80001606:	e30080e7          	jalr	-464(ra) # 80006432 <release>
          return pid;
    8000160a:	a09d                	j	80001670 <wait+0x100>
            release(&np->lock);
    8000160c:	8526                	mv	a0,s1
    8000160e:	00005097          	auipc	ra,0x5
    80001612:	e24080e7          	jalr	-476(ra) # 80006432 <release>
            release(&wait_lock);
    80001616:	00008517          	auipc	a0,0x8
    8000161a:	a5250513          	addi	a0,a0,-1454 # 80009068 <wait_lock>
    8000161e:	00005097          	auipc	ra,0x5
    80001622:	e14080e7          	jalr	-492(ra) # 80006432 <release>
            return -1;
    80001626:	59fd                	li	s3,-1
    80001628:	a0a1                	j	80001670 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000162a:	28048493          	addi	s1,s1,640
    8000162e:	03348463          	beq	s1,s3,80001656 <wait+0xe6>
      if(np->parent == p){
    80001632:	7c9c                	ld	a5,56(s1)
    80001634:	ff279be3          	bne	a5,s2,8000162a <wait+0xba>
        acquire(&np->lock);
    80001638:	8526                	mv	a0,s1
    8000163a:	00005097          	auipc	ra,0x5
    8000163e:	d44080e7          	jalr	-700(ra) # 8000637e <acquire>
        if(np->state == ZOMBIE){
    80001642:	4c9c                	lw	a5,24(s1)
    80001644:	f94781e3          	beq	a5,s4,800015c6 <wait+0x56>
        release(&np->lock);
    80001648:	8526                	mv	a0,s1
    8000164a:	00005097          	auipc	ra,0x5
    8000164e:	de8080e7          	jalr	-536(ra) # 80006432 <release>
        havekids = 1;
    80001652:	8756                	mv	a4,s5
    80001654:	bfd9                	j	8000162a <wait+0xba>
    if(!havekids || p->killed){
    80001656:	c701                	beqz	a4,8000165e <wait+0xee>
    80001658:	02892783          	lw	a5,40(s2)
    8000165c:	c79d                	beqz	a5,8000168a <wait+0x11a>
      release(&wait_lock);
    8000165e:	00008517          	auipc	a0,0x8
    80001662:	a0a50513          	addi	a0,a0,-1526 # 80009068 <wait_lock>
    80001666:	00005097          	auipc	ra,0x5
    8000166a:	dcc080e7          	jalr	-564(ra) # 80006432 <release>
      return -1;
    8000166e:	59fd                	li	s3,-1
}
    80001670:	854e                	mv	a0,s3
    80001672:	60a6                	ld	ra,72(sp)
    80001674:	6406                	ld	s0,64(sp)
    80001676:	74e2                	ld	s1,56(sp)
    80001678:	7942                	ld	s2,48(sp)
    8000167a:	79a2                	ld	s3,40(sp)
    8000167c:	7a02                	ld	s4,32(sp)
    8000167e:	6ae2                	ld	s5,24(sp)
    80001680:	6b42                	ld	s6,16(sp)
    80001682:	6ba2                	ld	s7,8(sp)
    80001684:	6c02                	ld	s8,0(sp)
    80001686:	6161                	addi	sp,sp,80
    80001688:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000168a:	85e2                	mv	a1,s8
    8000168c:	854a                	mv	a0,s2
    8000168e:	00000097          	auipc	ra,0x0
    80001692:	e7e080e7          	jalr	-386(ra) # 8000150c <sleep>
    havekids = 0;
    80001696:	b715                	j	800015ba <wait+0x4a>

0000000080001698 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001698:	7139                	addi	sp,sp,-64
    8000169a:	fc06                	sd	ra,56(sp)
    8000169c:	f822                	sd	s0,48(sp)
    8000169e:	f426                	sd	s1,40(sp)
    800016a0:	f04a                	sd	s2,32(sp)
    800016a2:	ec4e                	sd	s3,24(sp)
    800016a4:	e852                	sd	s4,16(sp)
    800016a6:	e456                	sd	s5,8(sp)
    800016a8:	0080                	addi	s0,sp,64
    800016aa:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016ac:	00008497          	auipc	s1,0x8
    800016b0:	dd448493          	addi	s1,s1,-556 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016b4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016b6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016b8:	00012917          	auipc	s2,0x12
    800016bc:	dc890913          	addi	s2,s2,-568 # 80013480 <tickslock>
    800016c0:	a821                	j	800016d8 <wakeup+0x40>
        p->state = RUNNABLE;
    800016c2:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800016c6:	8526                	mv	a0,s1
    800016c8:	00005097          	auipc	ra,0x5
    800016cc:	d6a080e7          	jalr	-662(ra) # 80006432 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d0:	28048493          	addi	s1,s1,640
    800016d4:	03248463          	beq	s1,s2,800016fc <wakeup+0x64>
    if(p != myproc()){
    800016d8:	fffff097          	auipc	ra,0xfffff
    800016dc:	770080e7          	jalr	1904(ra) # 80000e48 <myproc>
    800016e0:	fea488e3          	beq	s1,a0,800016d0 <wakeup+0x38>
      acquire(&p->lock);
    800016e4:	8526                	mv	a0,s1
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	c98080e7          	jalr	-872(ra) # 8000637e <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016ee:	4c9c                	lw	a5,24(s1)
    800016f0:	fd379be3          	bne	a5,s3,800016c6 <wakeup+0x2e>
    800016f4:	709c                	ld	a5,32(s1)
    800016f6:	fd4798e3          	bne	a5,s4,800016c6 <wakeup+0x2e>
    800016fa:	b7e1                	j	800016c2 <wakeup+0x2a>
    }
  }
}
    800016fc:	70e2                	ld	ra,56(sp)
    800016fe:	7442                	ld	s0,48(sp)
    80001700:	74a2                	ld	s1,40(sp)
    80001702:	7902                	ld	s2,32(sp)
    80001704:	69e2                	ld	s3,24(sp)
    80001706:	6a42                	ld	s4,16(sp)
    80001708:	6aa2                	ld	s5,8(sp)
    8000170a:	6121                	addi	sp,sp,64
    8000170c:	8082                	ret

000000008000170e <reparent>:
{
    8000170e:	7179                	addi	sp,sp,-48
    80001710:	f406                	sd	ra,40(sp)
    80001712:	f022                	sd	s0,32(sp)
    80001714:	ec26                	sd	s1,24(sp)
    80001716:	e84a                	sd	s2,16(sp)
    80001718:	e44e                	sd	s3,8(sp)
    8000171a:	e052                	sd	s4,0(sp)
    8000171c:	1800                	addi	s0,sp,48
    8000171e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001720:	00008497          	auipc	s1,0x8
    80001724:	d6048493          	addi	s1,s1,-672 # 80009480 <proc>
      pp->parent = initproc;
    80001728:	00008a17          	auipc	s4,0x8
    8000172c:	8e8a0a13          	addi	s4,s4,-1816 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001730:	00012997          	auipc	s3,0x12
    80001734:	d5098993          	addi	s3,s3,-688 # 80013480 <tickslock>
    80001738:	a029                	j	80001742 <reparent+0x34>
    8000173a:	28048493          	addi	s1,s1,640
    8000173e:	01348d63          	beq	s1,s3,80001758 <reparent+0x4a>
    if(pp->parent == p){
    80001742:	7c9c                	ld	a5,56(s1)
    80001744:	ff279be3          	bne	a5,s2,8000173a <reparent+0x2c>
      pp->parent = initproc;
    80001748:	000a3503          	ld	a0,0(s4)
    8000174c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000174e:	00000097          	auipc	ra,0x0
    80001752:	f4a080e7          	jalr	-182(ra) # 80001698 <wakeup>
    80001756:	b7d5                	j	8000173a <reparent+0x2c>
}
    80001758:	70a2                	ld	ra,40(sp)
    8000175a:	7402                	ld	s0,32(sp)
    8000175c:	64e2                	ld	s1,24(sp)
    8000175e:	6942                	ld	s2,16(sp)
    80001760:	69a2                	ld	s3,8(sp)
    80001762:	6a02                	ld	s4,0(sp)
    80001764:	6145                	addi	sp,sp,48
    80001766:	8082                	ret

0000000080001768 <exit>:
{
    80001768:	7179                	addi	sp,sp,-48
    8000176a:	f406                	sd	ra,40(sp)
    8000176c:	f022                	sd	s0,32(sp)
    8000176e:	ec26                	sd	s1,24(sp)
    80001770:	e84a                	sd	s2,16(sp)
    80001772:	e44e                	sd	s3,8(sp)
    80001774:	e052                	sd	s4,0(sp)
    80001776:	1800                	addi	s0,sp,48
    80001778:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000177a:	fffff097          	auipc	ra,0xfffff
    8000177e:	6ce080e7          	jalr	1742(ra) # 80000e48 <myproc>
    80001782:	89aa                	mv	s3,a0
  if(p == initproc)
    80001784:	00008797          	auipc	a5,0x8
    80001788:	88c7b783          	ld	a5,-1908(a5) # 80009010 <initproc>
    8000178c:	0d050493          	addi	s1,a0,208
    80001790:	15050913          	addi	s2,a0,336
    80001794:	02a79363          	bne	a5,a0,800017ba <exit+0x52>
    panic("init exiting");
    80001798:	00007517          	auipc	a0,0x7
    8000179c:	a4850513          	addi	a0,a0,-1464 # 800081e0 <etext+0x1e0>
    800017a0:	00004097          	auipc	ra,0x4
    800017a4:	628080e7          	jalr	1576(ra) # 80005dc8 <panic>
      fileclose(f);
    800017a8:	00002097          	auipc	ra,0x2
    800017ac:	408080e7          	jalr	1032(ra) # 80003bb0 <fileclose>
      p->ofile[fd] = 0;
    800017b0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017b4:	04a1                	addi	s1,s1,8
    800017b6:	01248563          	beq	s1,s2,800017c0 <exit+0x58>
    if(p->ofile[fd]){
    800017ba:	6088                	ld	a0,0(s1)
    800017bc:	f575                	bnez	a0,800017a8 <exit+0x40>
    800017be:	bfdd                	j	800017b4 <exit+0x4c>
  begin_op();
    800017c0:	00002097          	auipc	ra,0x2
    800017c4:	f24080e7          	jalr	-220(ra) # 800036e4 <begin_op>
  iput(p->cwd);
    800017c8:	1509b503          	ld	a0,336(s3)
    800017cc:	00001097          	auipc	ra,0x1
    800017d0:	700080e7          	jalr	1792(ra) # 80002ecc <iput>
  end_op();
    800017d4:	00002097          	auipc	ra,0x2
    800017d8:	f90080e7          	jalr	-112(ra) # 80003764 <end_op>
  p->cwd = 0;
    800017dc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017e0:	00008497          	auipc	s1,0x8
    800017e4:	88848493          	addi	s1,s1,-1912 # 80009068 <wait_lock>
    800017e8:	8526                	mv	a0,s1
    800017ea:	00005097          	auipc	ra,0x5
    800017ee:	b94080e7          	jalr	-1132(ra) # 8000637e <acquire>
  reparent(p);
    800017f2:	854e                	mv	a0,s3
    800017f4:	00000097          	auipc	ra,0x0
    800017f8:	f1a080e7          	jalr	-230(ra) # 8000170e <reparent>
  wakeup(p->parent);
    800017fc:	0389b503          	ld	a0,56(s3)
    80001800:	00000097          	auipc	ra,0x0
    80001804:	e98080e7          	jalr	-360(ra) # 80001698 <wakeup>
  acquire(&p->lock);
    80001808:	854e                	mv	a0,s3
    8000180a:	00005097          	auipc	ra,0x5
    8000180e:	b74080e7          	jalr	-1164(ra) # 8000637e <acquire>
  p->xstate = status;
    80001812:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001816:	4795                	li	a5,5
    80001818:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000181c:	8526                	mv	a0,s1
    8000181e:	00005097          	auipc	ra,0x5
    80001822:	c14080e7          	jalr	-1004(ra) # 80006432 <release>
  sched();
    80001826:	00000097          	auipc	ra,0x0
    8000182a:	bd4080e7          	jalr	-1068(ra) # 800013fa <sched>
  panic("zombie exit");
    8000182e:	00007517          	auipc	a0,0x7
    80001832:	9c250513          	addi	a0,a0,-1598 # 800081f0 <etext+0x1f0>
    80001836:	00004097          	auipc	ra,0x4
    8000183a:	592080e7          	jalr	1426(ra) # 80005dc8 <panic>

000000008000183e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000183e:	7179                	addi	sp,sp,-48
    80001840:	f406                	sd	ra,40(sp)
    80001842:	f022                	sd	s0,32(sp)
    80001844:	ec26                	sd	s1,24(sp)
    80001846:	e84a                	sd	s2,16(sp)
    80001848:	e44e                	sd	s3,8(sp)
    8000184a:	1800                	addi	s0,sp,48
    8000184c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000184e:	00008497          	auipc	s1,0x8
    80001852:	c3248493          	addi	s1,s1,-974 # 80009480 <proc>
    80001856:	00012997          	auipc	s3,0x12
    8000185a:	c2a98993          	addi	s3,s3,-982 # 80013480 <tickslock>
    acquire(&p->lock);
    8000185e:	8526                	mv	a0,s1
    80001860:	00005097          	auipc	ra,0x5
    80001864:	b1e080e7          	jalr	-1250(ra) # 8000637e <acquire>
    if(p->pid == pid){
    80001868:	589c                	lw	a5,48(s1)
    8000186a:	01278d63          	beq	a5,s2,80001884 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000186e:	8526                	mv	a0,s1
    80001870:	00005097          	auipc	ra,0x5
    80001874:	bc2080e7          	jalr	-1086(ra) # 80006432 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001878:	28048493          	addi	s1,s1,640
    8000187c:	ff3491e3          	bne	s1,s3,8000185e <kill+0x20>
  }
  return -1;
    80001880:	557d                	li	a0,-1
    80001882:	a829                	j	8000189c <kill+0x5e>
      p->killed = 1;
    80001884:	4785                	li	a5,1
    80001886:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001888:	4c98                	lw	a4,24(s1)
    8000188a:	4789                	li	a5,2
    8000188c:	00f70f63          	beq	a4,a5,800018aa <kill+0x6c>
      release(&p->lock);
    80001890:	8526                	mv	a0,s1
    80001892:	00005097          	auipc	ra,0x5
    80001896:	ba0080e7          	jalr	-1120(ra) # 80006432 <release>
      return 0;
    8000189a:	4501                	li	a0,0
}
    8000189c:	70a2                	ld	ra,40(sp)
    8000189e:	7402                	ld	s0,32(sp)
    800018a0:	64e2                	ld	s1,24(sp)
    800018a2:	6942                	ld	s2,16(sp)
    800018a4:	69a2                	ld	s3,8(sp)
    800018a6:	6145                	addi	sp,sp,48
    800018a8:	8082                	ret
        p->state = RUNNABLE;
    800018aa:	478d                	li	a5,3
    800018ac:	cc9c                	sw	a5,24(s1)
    800018ae:	b7cd                	j	80001890 <kill+0x52>

00000000800018b0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018b0:	7179                	addi	sp,sp,-48
    800018b2:	f406                	sd	ra,40(sp)
    800018b4:	f022                	sd	s0,32(sp)
    800018b6:	ec26                	sd	s1,24(sp)
    800018b8:	e84a                	sd	s2,16(sp)
    800018ba:	e44e                	sd	s3,8(sp)
    800018bc:	e052                	sd	s4,0(sp)
    800018be:	1800                	addi	s0,sp,48
    800018c0:	84aa                	mv	s1,a0
    800018c2:	892e                	mv	s2,a1
    800018c4:	89b2                	mv	s3,a2
    800018c6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018c8:	fffff097          	auipc	ra,0xfffff
    800018cc:	580080e7          	jalr	1408(ra) # 80000e48 <myproc>
  if(user_dst){
    800018d0:	c08d                	beqz	s1,800018f2 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018d2:	86d2                	mv	a3,s4
    800018d4:	864e                	mv	a2,s3
    800018d6:	85ca                	mv	a1,s2
    800018d8:	6928                	ld	a0,80(a0)
    800018da:	fffff097          	auipc	ra,0xfffff
    800018de:	230080e7          	jalr	560(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018e2:	70a2                	ld	ra,40(sp)
    800018e4:	7402                	ld	s0,32(sp)
    800018e6:	64e2                	ld	s1,24(sp)
    800018e8:	6942                	ld	s2,16(sp)
    800018ea:	69a2                	ld	s3,8(sp)
    800018ec:	6a02                	ld	s4,0(sp)
    800018ee:	6145                	addi	sp,sp,48
    800018f0:	8082                	ret
    memmove((char *)dst, src, len);
    800018f2:	000a061b          	sext.w	a2,s4
    800018f6:	85ce                	mv	a1,s3
    800018f8:	854a                	mv	a0,s2
    800018fa:	fffff097          	auipc	ra,0xfffff
    800018fe:	8de080e7          	jalr	-1826(ra) # 800001d8 <memmove>
    return 0;
    80001902:	8526                	mv	a0,s1
    80001904:	bff9                	j	800018e2 <either_copyout+0x32>

0000000080001906 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001906:	7179                	addi	sp,sp,-48
    80001908:	f406                	sd	ra,40(sp)
    8000190a:	f022                	sd	s0,32(sp)
    8000190c:	ec26                	sd	s1,24(sp)
    8000190e:	e84a                	sd	s2,16(sp)
    80001910:	e44e                	sd	s3,8(sp)
    80001912:	e052                	sd	s4,0(sp)
    80001914:	1800                	addi	s0,sp,48
    80001916:	892a                	mv	s2,a0
    80001918:	84ae                	mv	s1,a1
    8000191a:	89b2                	mv	s3,a2
    8000191c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191e:	fffff097          	auipc	ra,0xfffff
    80001922:	52a080e7          	jalr	1322(ra) # 80000e48 <myproc>
  if(user_src){
    80001926:	c08d                	beqz	s1,80001948 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001928:	86d2                	mv	a3,s4
    8000192a:	864e                	mv	a2,s3
    8000192c:	85ca                	mv	a1,s2
    8000192e:	6928                	ld	a0,80(a0)
    80001930:	fffff097          	auipc	ra,0xfffff
    80001934:	266080e7          	jalr	614(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001938:	70a2                	ld	ra,40(sp)
    8000193a:	7402                	ld	s0,32(sp)
    8000193c:	64e2                	ld	s1,24(sp)
    8000193e:	6942                	ld	s2,16(sp)
    80001940:	69a2                	ld	s3,8(sp)
    80001942:	6a02                	ld	s4,0(sp)
    80001944:	6145                	addi	sp,sp,48
    80001946:	8082                	ret
    memmove(dst, (char*)src, len);
    80001948:	000a061b          	sext.w	a2,s4
    8000194c:	85ce                	mv	a1,s3
    8000194e:	854a                	mv	a0,s2
    80001950:	fffff097          	auipc	ra,0xfffff
    80001954:	888080e7          	jalr	-1912(ra) # 800001d8 <memmove>
    return 0;
    80001958:	8526                	mv	a0,s1
    8000195a:	bff9                	j	80001938 <either_copyin+0x32>

000000008000195c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000195c:	715d                	addi	sp,sp,-80
    8000195e:	e486                	sd	ra,72(sp)
    80001960:	e0a2                	sd	s0,64(sp)
    80001962:	fc26                	sd	s1,56(sp)
    80001964:	f84a                	sd	s2,48(sp)
    80001966:	f44e                	sd	s3,40(sp)
    80001968:	f052                	sd	s4,32(sp)
    8000196a:	ec56                	sd	s5,24(sp)
    8000196c:	e85a                	sd	s6,16(sp)
    8000196e:	e45e                	sd	s7,8(sp)
    80001970:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001972:	00006517          	auipc	a0,0x6
    80001976:	6d650513          	addi	a0,a0,1750 # 80008048 <etext+0x48>
    8000197a:	00004097          	auipc	ra,0x4
    8000197e:	498080e7          	jalr	1176(ra) # 80005e12 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001982:	00008497          	auipc	s1,0x8
    80001986:	c5648493          	addi	s1,s1,-938 # 800095d8 <proc+0x158>
    8000198a:	00012917          	auipc	s2,0x12
    8000198e:	c4e90913          	addi	s2,s2,-946 # 800135d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001992:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001994:	00007997          	auipc	s3,0x7
    80001998:	86c98993          	addi	s3,s3,-1940 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    8000199c:	00007a97          	auipc	s5,0x7
    800019a0:	86ca8a93          	addi	s5,s5,-1940 # 80008208 <etext+0x208>
    printf("\n");
    800019a4:	00006a17          	auipc	s4,0x6
    800019a8:	6a4a0a13          	addi	s4,s4,1700 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ac:	00007b97          	auipc	s7,0x7
    800019b0:	894b8b93          	addi	s7,s7,-1900 # 80008240 <states.1750>
    800019b4:	a00d                	j	800019d6 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019b6:	ed86a583          	lw	a1,-296(a3)
    800019ba:	8556                	mv	a0,s5
    800019bc:	00004097          	auipc	ra,0x4
    800019c0:	456080e7          	jalr	1110(ra) # 80005e12 <printf>
    printf("\n");
    800019c4:	8552                	mv	a0,s4
    800019c6:	00004097          	auipc	ra,0x4
    800019ca:	44c080e7          	jalr	1100(ra) # 80005e12 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ce:	28048493          	addi	s1,s1,640
    800019d2:	03248163          	beq	s1,s2,800019f4 <procdump+0x98>
    if(p->state == UNUSED)
    800019d6:	86a6                	mv	a3,s1
    800019d8:	ec04a783          	lw	a5,-320(s1)
    800019dc:	dbed                	beqz	a5,800019ce <procdump+0x72>
      state = "???";
    800019de:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e0:	fcfb6be3          	bltu	s6,a5,800019b6 <procdump+0x5a>
    800019e4:	1782                	slli	a5,a5,0x20
    800019e6:	9381                	srli	a5,a5,0x20
    800019e8:	078e                	slli	a5,a5,0x3
    800019ea:	97de                	add	a5,a5,s7
    800019ec:	6390                	ld	a2,0(a5)
    800019ee:	f661                	bnez	a2,800019b6 <procdump+0x5a>
      state = "???";
    800019f0:	864e                	mv	a2,s3
    800019f2:	b7d1                	j	800019b6 <procdump+0x5a>
  }
}
    800019f4:	60a6                	ld	ra,72(sp)
    800019f6:	6406                	ld	s0,64(sp)
    800019f8:	74e2                	ld	s1,56(sp)
    800019fa:	7942                	ld	s2,48(sp)
    800019fc:	79a2                	ld	s3,40(sp)
    800019fe:	7a02                	ld	s4,32(sp)
    80001a00:	6ae2                	ld	s5,24(sp)
    80001a02:	6b42                	ld	s6,16(sp)
    80001a04:	6ba2                	ld	s7,8(sp)
    80001a06:	6161                	addi	sp,sp,80
    80001a08:	8082                	ret

0000000080001a0a <swtch>:
    80001a0a:	00153023          	sd	ra,0(a0)
    80001a0e:	00253423          	sd	sp,8(a0)
    80001a12:	e900                	sd	s0,16(a0)
    80001a14:	ed04                	sd	s1,24(a0)
    80001a16:	03253023          	sd	s2,32(a0)
    80001a1a:	03353423          	sd	s3,40(a0)
    80001a1e:	03453823          	sd	s4,48(a0)
    80001a22:	03553c23          	sd	s5,56(a0)
    80001a26:	05653023          	sd	s6,64(a0)
    80001a2a:	05753423          	sd	s7,72(a0)
    80001a2e:	05853823          	sd	s8,80(a0)
    80001a32:	05953c23          	sd	s9,88(a0)
    80001a36:	07a53023          	sd	s10,96(a0)
    80001a3a:	07b53423          	sd	s11,104(a0)
    80001a3e:	0005b083          	ld	ra,0(a1)
    80001a42:	0085b103          	ld	sp,8(a1)
    80001a46:	6980                	ld	s0,16(a1)
    80001a48:	6d84                	ld	s1,24(a1)
    80001a4a:	0205b903          	ld	s2,32(a1)
    80001a4e:	0285b983          	ld	s3,40(a1)
    80001a52:	0305ba03          	ld	s4,48(a1)
    80001a56:	0385ba83          	ld	s5,56(a1)
    80001a5a:	0405bb03          	ld	s6,64(a1)
    80001a5e:	0485bb83          	ld	s7,72(a1)
    80001a62:	0505bc03          	ld	s8,80(a1)
    80001a66:	0585bc83          	ld	s9,88(a1)
    80001a6a:	0605bd03          	ld	s10,96(a1)
    80001a6e:	0685bd83          	ld	s11,104(a1)
    80001a72:	8082                	ret

0000000080001a74 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a74:	1141                	addi	sp,sp,-16
    80001a76:	e406                	sd	ra,8(sp)
    80001a78:	e022                	sd	s0,0(sp)
    80001a7a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a7c:	00006597          	auipc	a1,0x6
    80001a80:	7f458593          	addi	a1,a1,2036 # 80008270 <states.1750+0x30>
    80001a84:	00012517          	auipc	a0,0x12
    80001a88:	9fc50513          	addi	a0,a0,-1540 # 80013480 <tickslock>
    80001a8c:	00005097          	auipc	ra,0x5
    80001a90:	862080e7          	jalr	-1950(ra) # 800062ee <initlock>
}
    80001a94:	60a2                	ld	ra,8(sp)
    80001a96:	6402                	ld	s0,0(sp)
    80001a98:	0141                	addi	sp,sp,16
    80001a9a:	8082                	ret

0000000080001a9c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a9c:	1141                	addi	sp,sp,-16
    80001a9e:	e422                	sd	s0,8(sp)
    80001aa0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aa2:	00003797          	auipc	a5,0x3
    80001aa6:	72e78793          	addi	a5,a5,1838 # 800051d0 <kernelvec>
    80001aaa:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001aae:	6422                	ld	s0,8(sp)
    80001ab0:	0141                	addi	sp,sp,16
    80001ab2:	8082                	ret

0000000080001ab4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001ab4:	1141                	addi	sp,sp,-16
    80001ab6:	e406                	sd	ra,8(sp)
    80001ab8:	e022                	sd	s0,0(sp)
    80001aba:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001abc:	fffff097          	auipc	ra,0xfffff
    80001ac0:	38c080e7          	jalr	908(ra) # 80000e48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ac4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ac8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001aca:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ace:	00005617          	auipc	a2,0x5
    80001ad2:	53260613          	addi	a2,a2,1330 # 80007000 <_trampoline>
    80001ad6:	00005697          	auipc	a3,0x5
    80001ada:	52a68693          	addi	a3,a3,1322 # 80007000 <_trampoline>
    80001ade:	8e91                	sub	a3,a3,a2
    80001ae0:	040007b7          	lui	a5,0x4000
    80001ae4:	17fd                	addi	a5,a5,-1
    80001ae6:	07b2                	slli	a5,a5,0xc
    80001ae8:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aea:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001aee:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001af0:	180026f3          	csrr	a3,satp
    80001af4:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001af6:	6d38                	ld	a4,88(a0)
    80001af8:	6134                	ld	a3,64(a0)
    80001afa:	6585                	lui	a1,0x1
    80001afc:	96ae                	add	a3,a3,a1
    80001afe:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b00:	6d38                	ld	a4,88(a0)
    80001b02:	00000697          	auipc	a3,0x0
    80001b06:	13868693          	addi	a3,a3,312 # 80001c3a <usertrap>
    80001b0a:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b0c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b0e:	8692                	mv	a3,tp
    80001b10:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b12:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b16:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b1a:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b1e:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b22:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b24:	6f18                	ld	a4,24(a4)
    80001b26:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b2a:	692c                	ld	a1,80(a0)
    80001b2c:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b2e:	00005717          	auipc	a4,0x5
    80001b32:	56270713          	addi	a4,a4,1378 # 80007090 <userret>
    80001b36:	8f11                	sub	a4,a4,a2
    80001b38:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b3a:	577d                	li	a4,-1
    80001b3c:	177e                	slli	a4,a4,0x3f
    80001b3e:	8dd9                	or	a1,a1,a4
    80001b40:	02000537          	lui	a0,0x2000
    80001b44:	157d                	addi	a0,a0,-1
    80001b46:	0536                	slli	a0,a0,0xd
    80001b48:	9782                	jalr	a5
}
    80001b4a:	60a2                	ld	ra,8(sp)
    80001b4c:	6402                	ld	s0,0(sp)
    80001b4e:	0141                	addi	sp,sp,16
    80001b50:	8082                	ret

0000000080001b52 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b52:	1101                	addi	sp,sp,-32
    80001b54:	ec06                	sd	ra,24(sp)
    80001b56:	e822                	sd	s0,16(sp)
    80001b58:	e426                	sd	s1,8(sp)
    80001b5a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b5c:	00012497          	auipc	s1,0x12
    80001b60:	92448493          	addi	s1,s1,-1756 # 80013480 <tickslock>
    80001b64:	8526                	mv	a0,s1
    80001b66:	00005097          	auipc	ra,0x5
    80001b6a:	818080e7          	jalr	-2024(ra) # 8000637e <acquire>
  ticks++;
    80001b6e:	00007517          	auipc	a0,0x7
    80001b72:	4aa50513          	addi	a0,a0,1194 # 80009018 <ticks>
    80001b76:	411c                	lw	a5,0(a0)
    80001b78:	2785                	addiw	a5,a5,1
    80001b7a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b7c:	00000097          	auipc	ra,0x0
    80001b80:	b1c080e7          	jalr	-1252(ra) # 80001698 <wakeup>
  release(&tickslock);
    80001b84:	8526                	mv	a0,s1
    80001b86:	00005097          	auipc	ra,0x5
    80001b8a:	8ac080e7          	jalr	-1876(ra) # 80006432 <release>
}
    80001b8e:	60e2                	ld	ra,24(sp)
    80001b90:	6442                	ld	s0,16(sp)
    80001b92:	64a2                	ld	s1,8(sp)
    80001b94:	6105                	addi	sp,sp,32
    80001b96:	8082                	ret

0000000080001b98 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b98:	1101                	addi	sp,sp,-32
    80001b9a:	ec06                	sd	ra,24(sp)
    80001b9c:	e822                	sd	s0,16(sp)
    80001b9e:	e426                	sd	s1,8(sp)
    80001ba0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ba2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001ba6:	00074d63          	bltz	a4,80001bc0 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001baa:	57fd                	li	a5,-1
    80001bac:	17fe                	slli	a5,a5,0x3f
    80001bae:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bb0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bb2:	06f70363          	beq	a4,a5,80001c18 <devintr+0x80>
  }
}
    80001bb6:	60e2                	ld	ra,24(sp)
    80001bb8:	6442                	ld	s0,16(sp)
    80001bba:	64a2                	ld	s1,8(sp)
    80001bbc:	6105                	addi	sp,sp,32
    80001bbe:	8082                	ret
     (scause & 0xff) == 9){
    80001bc0:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bc4:	46a5                	li	a3,9
    80001bc6:	fed792e3          	bne	a5,a3,80001baa <devintr+0x12>
    int irq = plic_claim();
    80001bca:	00003097          	auipc	ra,0x3
    80001bce:	70e080e7          	jalr	1806(ra) # 800052d8 <plic_claim>
    80001bd2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bd4:	47a9                	li	a5,10
    80001bd6:	02f50763          	beq	a0,a5,80001c04 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001bda:	4785                	li	a5,1
    80001bdc:	02f50963          	beq	a0,a5,80001c0e <devintr+0x76>
    return 1;
    80001be0:	4505                	li	a0,1
    } else if(irq){
    80001be2:	d8f1                	beqz	s1,80001bb6 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001be4:	85a6                	mv	a1,s1
    80001be6:	00006517          	auipc	a0,0x6
    80001bea:	69250513          	addi	a0,a0,1682 # 80008278 <states.1750+0x38>
    80001bee:	00004097          	auipc	ra,0x4
    80001bf2:	224080e7          	jalr	548(ra) # 80005e12 <printf>
      plic_complete(irq);
    80001bf6:	8526                	mv	a0,s1
    80001bf8:	00003097          	auipc	ra,0x3
    80001bfc:	704080e7          	jalr	1796(ra) # 800052fc <plic_complete>
    return 1;
    80001c00:	4505                	li	a0,1
    80001c02:	bf55                	j	80001bb6 <devintr+0x1e>
      uartintr();
    80001c04:	00004097          	auipc	ra,0x4
    80001c08:	69a080e7          	jalr	1690(ra) # 8000629e <uartintr>
    80001c0c:	b7ed                	j	80001bf6 <devintr+0x5e>
      virtio_disk_intr();
    80001c0e:	00004097          	auipc	ra,0x4
    80001c12:	bce080e7          	jalr	-1074(ra) # 800057dc <virtio_disk_intr>
    80001c16:	b7c5                	j	80001bf6 <devintr+0x5e>
    if(cpuid() == 0){
    80001c18:	fffff097          	auipc	ra,0xfffff
    80001c1c:	204080e7          	jalr	516(ra) # 80000e1c <cpuid>
    80001c20:	c901                	beqz	a0,80001c30 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c22:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c26:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c28:	14479073          	csrw	sip,a5
    return 2;
    80001c2c:	4509                	li	a0,2
    80001c2e:	b761                	j	80001bb6 <devintr+0x1e>
      clockintr();
    80001c30:	00000097          	auipc	ra,0x0
    80001c34:	f22080e7          	jalr	-222(ra) # 80001b52 <clockintr>
    80001c38:	b7ed                	j	80001c22 <devintr+0x8a>

0000000080001c3a <usertrap>:
{
    80001c3a:	1101                	addi	sp,sp,-32
    80001c3c:	ec06                	sd	ra,24(sp)
    80001c3e:	e822                	sd	s0,16(sp)
    80001c40:	e426                	sd	s1,8(sp)
    80001c42:	e04a                	sd	s2,0(sp)
    80001c44:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c46:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c4a:	1007f793          	andi	a5,a5,256
    80001c4e:	e3bd                	bnez	a5,80001cb4 <usertrap+0x7a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c50:	00003797          	auipc	a5,0x3
    80001c54:	58078793          	addi	a5,a5,1408 # 800051d0 <kernelvec>
    80001c58:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c5c:	fffff097          	auipc	ra,0xfffff
    80001c60:	1ec080e7          	jalr	492(ra) # 80000e48 <myproc>
    80001c64:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c66:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c68:	14102773          	csrr	a4,sepc
    80001c6c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c6e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c72:	47a1                	li	a5,8
    80001c74:	04f71e63          	bne	a4,a5,80001cd0 <usertrap+0x96>
    if(p->killed)
    80001c78:	551c                	lw	a5,40(a0)
    80001c7a:	e7a9                	bnez	a5,80001cc4 <usertrap+0x8a>
    p->trapframe->epc += 4;
    80001c7c:	6cb8                	ld	a4,88(s1)
    80001c7e:	6f1c                	ld	a5,24(a4)
    80001c80:	0791                	addi	a5,a5,4
    80001c82:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c88:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c8c:	10079073          	csrw	sstatus,a5
    syscall();
    80001c90:	00000097          	auipc	ra,0x0
    80001c94:	3fa080e7          	jalr	1018(ra) # 8000208a <syscall>
  int which_dev = 0;
    80001c98:	4901                	li	s2,0
  if(p->killed)
    80001c9a:	549c                	lw	a5,40(s1)
    80001c9c:	18079963          	bnez	a5,80001e2e <usertrap+0x1f4>
  usertrapret();
    80001ca0:	00000097          	auipc	ra,0x0
    80001ca4:	e14080e7          	jalr	-492(ra) # 80001ab4 <usertrapret>
}
    80001ca8:	60e2                	ld	ra,24(sp)
    80001caa:	6442                	ld	s0,16(sp)
    80001cac:	64a2                	ld	s1,8(sp)
    80001cae:	6902                	ld	s2,0(sp)
    80001cb0:	6105                	addi	sp,sp,32
    80001cb2:	8082                	ret
    panic("usertrap: not from user mode");
    80001cb4:	00006517          	auipc	a0,0x6
    80001cb8:	5e450513          	addi	a0,a0,1508 # 80008298 <states.1750+0x58>
    80001cbc:	00004097          	auipc	ra,0x4
    80001cc0:	10c080e7          	jalr	268(ra) # 80005dc8 <panic>
      exit(-1);
    80001cc4:	557d                	li	a0,-1
    80001cc6:	00000097          	auipc	ra,0x0
    80001cca:	aa2080e7          	jalr	-1374(ra) # 80001768 <exit>
    80001cce:	b77d                	j	80001c7c <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	ec8080e7          	jalr	-312(ra) # 80001b98 <devintr>
    80001cd8:	892a                	mv	s2,a0
    80001cda:	10050b63          	beqz	a0,80001df0 <usertrap+0x1b6>
    if (which_dev == 2 && p->in_handler == 0) {
    80001cde:	4789                	li	a5,2
    80001ce0:	faf51de3          	bne	a0,a5,80001c9a <usertrap+0x60>
    80001ce4:	1784a783          	lw	a5,376(s1)
    80001ce8:	ef81                	bnez	a5,80001d00 <usertrap+0xc6>
      p->passed_intervals++;
    80001cea:	1744a783          	lw	a5,372(s1)
    80001cee:	2785                	addiw	a5,a5,1
    80001cf0:	0007871b          	sext.w	a4,a5
    80001cf4:	16f4aa23          	sw	a5,372(s1)
      if (p->passed_intervals == p->alarm_intervals && p->alarm_intervals != 0) {
    80001cf8:	1704a783          	lw	a5,368(s1)
    80001cfc:	00f70b63          	beq	a4,a5,80001d12 <usertrap+0xd8>
  if(p->killed)
    80001d00:	549c                	lw	a5,40(s1)
    80001d02:	12078e63          	beqz	a5,80001e3e <usertrap+0x204>
    exit(-1);
    80001d06:	557d                	li	a0,-1
    80001d08:	00000097          	auipc	ra,0x0
    80001d0c:	a60080e7          	jalr	-1440(ra) # 80001768 <exit>
  if(which_dev == 2) {
    80001d10:	a23d                	j	80001e3e <usertrap+0x204>
      if (p->passed_intervals == p->alarm_intervals && p->alarm_intervals != 0) {
    80001d12:	d7fd                	beqz	a5,80001d00 <usertrap+0xc6>
        p->in_handler = 1;
    80001d14:	4785                	li	a5,1
    80001d16:	16f4ac23          	sw	a5,376(s1)
        p->passed_intervals = 0;
    80001d1a:	1604aa23          	sw	zero,372(s1)
        p->saved_epc = p->trapframe->epc;           // saved user program counter
    80001d1e:	6cbc                	ld	a5,88(s1)
    80001d20:	6f98                	ld	a4,24(a5)
    80001d22:	18e4b023          	sd	a4,384(s1)
        p->saved_ra = p->trapframe->ra;
    80001d26:	7798                	ld	a4,40(a5)
    80001d28:	18e4b423          	sd	a4,392(s1)
        p->saved_sp = p->trapframe->sp;
    80001d2c:	7b98                	ld	a4,48(a5)
    80001d2e:	18e4b823          	sd	a4,400(s1)
        p->saved_gp = p->trapframe->gp;
    80001d32:	7f98                	ld	a4,56(a5)
    80001d34:	18e4bc23          	sd	a4,408(s1)
        p->saved_tp = p->trapframe->tp;
    80001d38:	63b8                	ld	a4,64(a5)
    80001d3a:	1ae4b023          	sd	a4,416(s1)
        p->saved_t0 = p->trapframe->t0;
    80001d3e:	67b8                	ld	a4,72(a5)
    80001d40:	1ae4b423          	sd	a4,424(s1)
        p->saved_t1 = p->trapframe->t1;
    80001d44:	6bb8                	ld	a4,80(a5)
    80001d46:	1ae4b823          	sd	a4,432(s1)
        p->saved_t2 = p->trapframe->t2;
    80001d4a:	6fb8                	ld	a4,88(a5)
    80001d4c:	1ae4bc23          	sd	a4,440(s1)
        p->saved_s0 = p->trapframe->s0;
    80001d50:	73b8                	ld	a4,96(a5)
    80001d52:	1ce4b023          	sd	a4,448(s1)
        p->saved_s1 = p->trapframe->s1;
    80001d56:	77b8                	ld	a4,104(a5)
    80001d58:	1ce4b423          	sd	a4,456(s1)
        p->saved_a0 = p->trapframe->a0;
    80001d5c:	7bb8                	ld	a4,112(a5)
    80001d5e:	1ce4b823          	sd	a4,464(s1)
        p->saved_a1 = p->trapframe->a1;
    80001d62:	7fb8                	ld	a4,120(a5)
    80001d64:	1ce4bc23          	sd	a4,472(s1)
        p->saved_a2 = p->trapframe->a2;
    80001d68:	63d8                	ld	a4,128(a5)
    80001d6a:	1ee4b023          	sd	a4,480(s1)
        p->saved_a3 = p->trapframe->a3;
    80001d6e:	67d8                	ld	a4,136(a5)
    80001d70:	1ee4b423          	sd	a4,488(s1)
        p->saved_a4 = p->trapframe->a4;
    80001d74:	6bd8                	ld	a4,144(a5)
    80001d76:	1ee4b823          	sd	a4,496(s1)
        p->saved_a5 = p->trapframe->a5;
    80001d7a:	6fd8                	ld	a4,152(a5)
    80001d7c:	1ee4bc23          	sd	a4,504(s1)
        p->saved_a6 = p->trapframe->a6;
    80001d80:	73d8                	ld	a4,160(a5)
    80001d82:	20e4b023          	sd	a4,512(s1)
        p->saved_a7 = p->trapframe->a7;
    80001d86:	77d8                	ld	a4,168(a5)
    80001d88:	20e4b423          	sd	a4,520(s1)
        p->saved_s2 = p->trapframe->s2;
    80001d8c:	7bd8                	ld	a4,176(a5)
    80001d8e:	20e4b823          	sd	a4,528(s1)
        p->saved_s3 = p->trapframe->s3;
    80001d92:	7fd8                	ld	a4,184(a5)
    80001d94:	20e4bc23          	sd	a4,536(s1)
        p->saved_s4 = p->trapframe->s4;
    80001d98:	63f8                	ld	a4,192(a5)
    80001d9a:	22e4b023          	sd	a4,544(s1)
        p->saved_s5 = p->trapframe->s5;
    80001d9e:	67f8                	ld	a4,200(a5)
    80001da0:	22e4b423          	sd	a4,552(s1)
        p->saved_s6 = p->trapframe->s6;
    80001da4:	6bf8                	ld	a4,208(a5)
    80001da6:	22e4b823          	sd	a4,560(s1)
        p->saved_s7 = p->trapframe->s7;
    80001daa:	6ff8                	ld	a4,216(a5)
    80001dac:	22e4bc23          	sd	a4,568(s1)
        p->saved_s8 = p->trapframe->s8;
    80001db0:	73f8                	ld	a4,224(a5)
    80001db2:	24e4b023          	sd	a4,576(s1)
        p->saved_s9 = p->trapframe->s9;
    80001db6:	77f8                	ld	a4,232(a5)
    80001db8:	24e4b423          	sd	a4,584(s1)
        p->saved_s10 = p->trapframe->s10;
    80001dbc:	7bf8                	ld	a4,240(a5)
    80001dbe:	24e4b823          	sd	a4,592(s1)
        p->saved_s11 = p->trapframe->s11;
    80001dc2:	7ff8                	ld	a4,248(a5)
    80001dc4:	24e4bc23          	sd	a4,600(s1)
        p->saved_t3 = p->trapframe->t3;
    80001dc8:	1007b703          	ld	a4,256(a5)
    80001dcc:	26e4b023          	sd	a4,608(s1)
        p->saved_t4 = p->trapframe->t4;
    80001dd0:	1087b703          	ld	a4,264(a5)
    80001dd4:	26e4b423          	sd	a4,616(s1)
        p->saved_t5 = p->trapframe->t5;
    80001dd8:	1107b703          	ld	a4,272(a5)
    80001ddc:	26e4b823          	sd	a4,624(s1)
        p->saved_t6 = p->trapframe->t6;
    80001de0:	1187b703          	ld	a4,280(a5)
    80001de4:	26e4bc23          	sd	a4,632(s1)
        p->trapframe->epc = p->handler_pt;
    80001de8:	1684b703          	ld	a4,360(s1)
    80001dec:	ef98                	sd	a4,24(a5)
    80001dee:	bf09                	j	80001d00 <usertrap+0xc6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001df0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001df4:	5890                	lw	a2,48(s1)
    80001df6:	00006517          	auipc	a0,0x6
    80001dfa:	4c250513          	addi	a0,a0,1218 # 800082b8 <states.1750+0x78>
    80001dfe:	00004097          	auipc	ra,0x4
    80001e02:	014080e7          	jalr	20(ra) # 80005e12 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e06:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e0a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e0e:	00006517          	auipc	a0,0x6
    80001e12:	4da50513          	addi	a0,a0,1242 # 800082e8 <states.1750+0xa8>
    80001e16:	00004097          	auipc	ra,0x4
    80001e1a:	ffc080e7          	jalr	-4(ra) # 80005e12 <printf>
    p->killed = 1;
    80001e1e:	4785                	li	a5,1
    80001e20:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001e22:	557d                	li	a0,-1
    80001e24:	00000097          	auipc	ra,0x0
    80001e28:	944080e7          	jalr	-1724(ra) # 80001768 <exit>
  if(which_dev == 2) {
    80001e2c:	bd95                	j	80001ca0 <usertrap+0x66>
    exit(-1);
    80001e2e:	557d                	li	a0,-1
    80001e30:	00000097          	auipc	ra,0x0
    80001e34:	938080e7          	jalr	-1736(ra) # 80001768 <exit>
  if(which_dev == 2) {
    80001e38:	4789                	li	a5,2
    80001e3a:	e6f913e3          	bne	s2,a5,80001ca0 <usertrap+0x66>
    yield();
    80001e3e:	fffff097          	auipc	ra,0xfffff
    80001e42:	692080e7          	jalr	1682(ra) # 800014d0 <yield>
    80001e46:	bda9                	j	80001ca0 <usertrap+0x66>

0000000080001e48 <kerneltrap>:
{
    80001e48:	7179                	addi	sp,sp,-48
    80001e4a:	f406                	sd	ra,40(sp)
    80001e4c:	f022                	sd	s0,32(sp)
    80001e4e:	ec26                	sd	s1,24(sp)
    80001e50:	e84a                	sd	s2,16(sp)
    80001e52:	e44e                	sd	s3,8(sp)
    80001e54:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e56:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e5a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e5e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e62:	1004f793          	andi	a5,s1,256
    80001e66:	cb85                	beqz	a5,80001e96 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e68:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e6c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e6e:	ef85                	bnez	a5,80001ea6 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e70:	00000097          	auipc	ra,0x0
    80001e74:	d28080e7          	jalr	-728(ra) # 80001b98 <devintr>
    80001e78:	cd1d                	beqz	a0,80001eb6 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e7a:	4789                	li	a5,2
    80001e7c:	06f50a63          	beq	a0,a5,80001ef0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e80:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e84:	10049073          	csrw	sstatus,s1
}
    80001e88:	70a2                	ld	ra,40(sp)
    80001e8a:	7402                	ld	s0,32(sp)
    80001e8c:	64e2                	ld	s1,24(sp)
    80001e8e:	6942                	ld	s2,16(sp)
    80001e90:	69a2                	ld	s3,8(sp)
    80001e92:	6145                	addi	sp,sp,48
    80001e94:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e96:	00006517          	auipc	a0,0x6
    80001e9a:	47250513          	addi	a0,a0,1138 # 80008308 <states.1750+0xc8>
    80001e9e:	00004097          	auipc	ra,0x4
    80001ea2:	f2a080e7          	jalr	-214(ra) # 80005dc8 <panic>
    panic("kerneltrap: interrupts enabled");
    80001ea6:	00006517          	auipc	a0,0x6
    80001eaa:	48a50513          	addi	a0,a0,1162 # 80008330 <states.1750+0xf0>
    80001eae:	00004097          	auipc	ra,0x4
    80001eb2:	f1a080e7          	jalr	-230(ra) # 80005dc8 <panic>
    printf("scause %p\n", scause);
    80001eb6:	85ce                	mv	a1,s3
    80001eb8:	00006517          	auipc	a0,0x6
    80001ebc:	49850513          	addi	a0,a0,1176 # 80008350 <states.1750+0x110>
    80001ec0:	00004097          	auipc	ra,0x4
    80001ec4:	f52080e7          	jalr	-174(ra) # 80005e12 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ecc:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ed0:	00006517          	auipc	a0,0x6
    80001ed4:	49050513          	addi	a0,a0,1168 # 80008360 <states.1750+0x120>
    80001ed8:	00004097          	auipc	ra,0x4
    80001edc:	f3a080e7          	jalr	-198(ra) # 80005e12 <printf>
    panic("kerneltrap");
    80001ee0:	00006517          	auipc	a0,0x6
    80001ee4:	49850513          	addi	a0,a0,1176 # 80008378 <states.1750+0x138>
    80001ee8:	00004097          	auipc	ra,0x4
    80001eec:	ee0080e7          	jalr	-288(ra) # 80005dc8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ef0:	fffff097          	auipc	ra,0xfffff
    80001ef4:	f58080e7          	jalr	-168(ra) # 80000e48 <myproc>
    80001ef8:	d541                	beqz	a0,80001e80 <kerneltrap+0x38>
    80001efa:	fffff097          	auipc	ra,0xfffff
    80001efe:	f4e080e7          	jalr	-178(ra) # 80000e48 <myproc>
    80001f02:	4d18                	lw	a4,24(a0)
    80001f04:	4791                	li	a5,4
    80001f06:	f6f71de3          	bne	a4,a5,80001e80 <kerneltrap+0x38>
    yield();
    80001f0a:	fffff097          	auipc	ra,0xfffff
    80001f0e:	5c6080e7          	jalr	1478(ra) # 800014d0 <yield>
    80001f12:	b7bd                	j	80001e80 <kerneltrap+0x38>

0000000080001f14 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f14:	1101                	addi	sp,sp,-32
    80001f16:	ec06                	sd	ra,24(sp)
    80001f18:	e822                	sd	s0,16(sp)
    80001f1a:	e426                	sd	s1,8(sp)
    80001f1c:	1000                	addi	s0,sp,32
    80001f1e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f20:	fffff097          	auipc	ra,0xfffff
    80001f24:	f28080e7          	jalr	-216(ra) # 80000e48 <myproc>
  switch (n) {
    80001f28:	4795                	li	a5,5
    80001f2a:	0497e163          	bltu	a5,s1,80001f6c <argraw+0x58>
    80001f2e:	048a                	slli	s1,s1,0x2
    80001f30:	00006717          	auipc	a4,0x6
    80001f34:	48070713          	addi	a4,a4,1152 # 800083b0 <states.1750+0x170>
    80001f38:	94ba                	add	s1,s1,a4
    80001f3a:	409c                	lw	a5,0(s1)
    80001f3c:	97ba                	add	a5,a5,a4
    80001f3e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f40:	6d3c                	ld	a5,88(a0)
    80001f42:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f44:	60e2                	ld	ra,24(sp)
    80001f46:	6442                	ld	s0,16(sp)
    80001f48:	64a2                	ld	s1,8(sp)
    80001f4a:	6105                	addi	sp,sp,32
    80001f4c:	8082                	ret
    return p->trapframe->a1;
    80001f4e:	6d3c                	ld	a5,88(a0)
    80001f50:	7fa8                	ld	a0,120(a5)
    80001f52:	bfcd                	j	80001f44 <argraw+0x30>
    return p->trapframe->a2;
    80001f54:	6d3c                	ld	a5,88(a0)
    80001f56:	63c8                	ld	a0,128(a5)
    80001f58:	b7f5                	j	80001f44 <argraw+0x30>
    return p->trapframe->a3;
    80001f5a:	6d3c                	ld	a5,88(a0)
    80001f5c:	67c8                	ld	a0,136(a5)
    80001f5e:	b7dd                	j	80001f44 <argraw+0x30>
    return p->trapframe->a4;
    80001f60:	6d3c                	ld	a5,88(a0)
    80001f62:	6bc8                	ld	a0,144(a5)
    80001f64:	b7c5                	j	80001f44 <argraw+0x30>
    return p->trapframe->a5;
    80001f66:	6d3c                	ld	a5,88(a0)
    80001f68:	6fc8                	ld	a0,152(a5)
    80001f6a:	bfe9                	j	80001f44 <argraw+0x30>
  panic("argraw");
    80001f6c:	00006517          	auipc	a0,0x6
    80001f70:	41c50513          	addi	a0,a0,1052 # 80008388 <states.1750+0x148>
    80001f74:	00004097          	auipc	ra,0x4
    80001f78:	e54080e7          	jalr	-428(ra) # 80005dc8 <panic>

0000000080001f7c <fetchaddr>:
{
    80001f7c:	1101                	addi	sp,sp,-32
    80001f7e:	ec06                	sd	ra,24(sp)
    80001f80:	e822                	sd	s0,16(sp)
    80001f82:	e426                	sd	s1,8(sp)
    80001f84:	e04a                	sd	s2,0(sp)
    80001f86:	1000                	addi	s0,sp,32
    80001f88:	84aa                	mv	s1,a0
    80001f8a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	ebc080e7          	jalr	-324(ra) # 80000e48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f94:	653c                	ld	a5,72(a0)
    80001f96:	02f4f863          	bgeu	s1,a5,80001fc6 <fetchaddr+0x4a>
    80001f9a:	00848713          	addi	a4,s1,8
    80001f9e:	02e7e663          	bltu	a5,a4,80001fca <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fa2:	46a1                	li	a3,8
    80001fa4:	8626                	mv	a2,s1
    80001fa6:	85ca                	mv	a1,s2
    80001fa8:	6928                	ld	a0,80(a0)
    80001faa:	fffff097          	auipc	ra,0xfffff
    80001fae:	bec080e7          	jalr	-1044(ra) # 80000b96 <copyin>
    80001fb2:	00a03533          	snez	a0,a0
    80001fb6:	40a00533          	neg	a0,a0
}
    80001fba:	60e2                	ld	ra,24(sp)
    80001fbc:	6442                	ld	s0,16(sp)
    80001fbe:	64a2                	ld	s1,8(sp)
    80001fc0:	6902                	ld	s2,0(sp)
    80001fc2:	6105                	addi	sp,sp,32
    80001fc4:	8082                	ret
    return -1;
    80001fc6:	557d                	li	a0,-1
    80001fc8:	bfcd                	j	80001fba <fetchaddr+0x3e>
    80001fca:	557d                	li	a0,-1
    80001fcc:	b7fd                	j	80001fba <fetchaddr+0x3e>

0000000080001fce <fetchstr>:
{
    80001fce:	7179                	addi	sp,sp,-48
    80001fd0:	f406                	sd	ra,40(sp)
    80001fd2:	f022                	sd	s0,32(sp)
    80001fd4:	ec26                	sd	s1,24(sp)
    80001fd6:	e84a                	sd	s2,16(sp)
    80001fd8:	e44e                	sd	s3,8(sp)
    80001fda:	1800                	addi	s0,sp,48
    80001fdc:	892a                	mv	s2,a0
    80001fde:	84ae                	mv	s1,a1
    80001fe0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fe2:	fffff097          	auipc	ra,0xfffff
    80001fe6:	e66080e7          	jalr	-410(ra) # 80000e48 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001fea:	86ce                	mv	a3,s3
    80001fec:	864a                	mv	a2,s2
    80001fee:	85a6                	mv	a1,s1
    80001ff0:	6928                	ld	a0,80(a0)
    80001ff2:	fffff097          	auipc	ra,0xfffff
    80001ff6:	c30080e7          	jalr	-976(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001ffa:	00054763          	bltz	a0,80002008 <fetchstr+0x3a>
  return strlen(buf);
    80001ffe:	8526                	mv	a0,s1
    80002000:	ffffe097          	auipc	ra,0xffffe
    80002004:	2fc080e7          	jalr	764(ra) # 800002fc <strlen>
}
    80002008:	70a2                	ld	ra,40(sp)
    8000200a:	7402                	ld	s0,32(sp)
    8000200c:	64e2                	ld	s1,24(sp)
    8000200e:	6942                	ld	s2,16(sp)
    80002010:	69a2                	ld	s3,8(sp)
    80002012:	6145                	addi	sp,sp,48
    80002014:	8082                	ret

0000000080002016 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002016:	1101                	addi	sp,sp,-32
    80002018:	ec06                	sd	ra,24(sp)
    8000201a:	e822                	sd	s0,16(sp)
    8000201c:	e426                	sd	s1,8(sp)
    8000201e:	1000                	addi	s0,sp,32
    80002020:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002022:	00000097          	auipc	ra,0x0
    80002026:	ef2080e7          	jalr	-270(ra) # 80001f14 <argraw>
    8000202a:	c088                	sw	a0,0(s1)
  return 0;
}
    8000202c:	4501                	li	a0,0
    8000202e:	60e2                	ld	ra,24(sp)
    80002030:	6442                	ld	s0,16(sp)
    80002032:	64a2                	ld	s1,8(sp)
    80002034:	6105                	addi	sp,sp,32
    80002036:	8082                	ret

0000000080002038 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002038:	1101                	addi	sp,sp,-32
    8000203a:	ec06                	sd	ra,24(sp)
    8000203c:	e822                	sd	s0,16(sp)
    8000203e:	e426                	sd	s1,8(sp)
    80002040:	1000                	addi	s0,sp,32
    80002042:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002044:	00000097          	auipc	ra,0x0
    80002048:	ed0080e7          	jalr	-304(ra) # 80001f14 <argraw>
    8000204c:	e088                	sd	a0,0(s1)
  return 0;
}
    8000204e:	4501                	li	a0,0
    80002050:	60e2                	ld	ra,24(sp)
    80002052:	6442                	ld	s0,16(sp)
    80002054:	64a2                	ld	s1,8(sp)
    80002056:	6105                	addi	sp,sp,32
    80002058:	8082                	ret

000000008000205a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000205a:	1101                	addi	sp,sp,-32
    8000205c:	ec06                	sd	ra,24(sp)
    8000205e:	e822                	sd	s0,16(sp)
    80002060:	e426                	sd	s1,8(sp)
    80002062:	e04a                	sd	s2,0(sp)
    80002064:	1000                	addi	s0,sp,32
    80002066:	84ae                	mv	s1,a1
    80002068:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000206a:	00000097          	auipc	ra,0x0
    8000206e:	eaa080e7          	jalr	-342(ra) # 80001f14 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002072:	864a                	mv	a2,s2
    80002074:	85a6                	mv	a1,s1
    80002076:	00000097          	auipc	ra,0x0
    8000207a:	f58080e7          	jalr	-168(ra) # 80001fce <fetchstr>
}
    8000207e:	60e2                	ld	ra,24(sp)
    80002080:	6442                	ld	s0,16(sp)
    80002082:	64a2                	ld	s1,8(sp)
    80002084:	6902                	ld	s2,0(sp)
    80002086:	6105                	addi	sp,sp,32
    80002088:	8082                	ret

000000008000208a <syscall>:
[SYS_sigreturn]  sys_sigreturn,
};

void
syscall(void)
{
    8000208a:	1101                	addi	sp,sp,-32
    8000208c:	ec06                	sd	ra,24(sp)
    8000208e:	e822                	sd	s0,16(sp)
    80002090:	e426                	sd	s1,8(sp)
    80002092:	e04a                	sd	s2,0(sp)
    80002094:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	db2080e7          	jalr	-590(ra) # 80000e48 <myproc>
    8000209e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020a0:	05853903          	ld	s2,88(a0)
    800020a4:	0a893783          	ld	a5,168(s2)
    800020a8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020ac:	37fd                	addiw	a5,a5,-1
    800020ae:	4759                	li	a4,22
    800020b0:	00f76f63          	bltu	a4,a5,800020ce <syscall+0x44>
    800020b4:	00369713          	slli	a4,a3,0x3
    800020b8:	00006797          	auipc	a5,0x6
    800020bc:	31078793          	addi	a5,a5,784 # 800083c8 <syscalls>
    800020c0:	97ba                	add	a5,a5,a4
    800020c2:	639c                	ld	a5,0(a5)
    800020c4:	c789                	beqz	a5,800020ce <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800020c6:	9782                	jalr	a5
    800020c8:	06a93823          	sd	a0,112(s2)
    800020cc:	a839                	j	800020ea <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020ce:	15848613          	addi	a2,s1,344
    800020d2:	588c                	lw	a1,48(s1)
    800020d4:	00006517          	auipc	a0,0x6
    800020d8:	2bc50513          	addi	a0,a0,700 # 80008390 <states.1750+0x150>
    800020dc:	00004097          	auipc	ra,0x4
    800020e0:	d36080e7          	jalr	-714(ra) # 80005e12 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020e4:	6cbc                	ld	a5,88(s1)
    800020e6:	577d                	li	a4,-1
    800020e8:	fbb8                	sd	a4,112(a5)
  }
}
    800020ea:	60e2                	ld	ra,24(sp)
    800020ec:	6442                	ld	s0,16(sp)
    800020ee:	64a2                	ld	s1,8(sp)
    800020f0:	6902                	ld	s2,0(sp)
    800020f2:	6105                	addi	sp,sp,32
    800020f4:	8082                	ret

00000000800020f6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020f6:	1101                	addi	sp,sp,-32
    800020f8:	ec06                	sd	ra,24(sp)
    800020fa:	e822                	sd	s0,16(sp)
    800020fc:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020fe:	fec40593          	addi	a1,s0,-20
    80002102:	4501                	li	a0,0
    80002104:	00000097          	auipc	ra,0x0
    80002108:	f12080e7          	jalr	-238(ra) # 80002016 <argint>
    return -1;
    8000210c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000210e:	00054963          	bltz	a0,80002120 <sys_exit+0x2a>
  exit(n);
    80002112:	fec42503          	lw	a0,-20(s0)
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	652080e7          	jalr	1618(ra) # 80001768 <exit>
  return 0;  // not reached
    8000211e:	4781                	li	a5,0
}
    80002120:	853e                	mv	a0,a5
    80002122:	60e2                	ld	ra,24(sp)
    80002124:	6442                	ld	s0,16(sp)
    80002126:	6105                	addi	sp,sp,32
    80002128:	8082                	ret

000000008000212a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000212a:	1141                	addi	sp,sp,-16
    8000212c:	e406                	sd	ra,8(sp)
    8000212e:	e022                	sd	s0,0(sp)
    80002130:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002132:	fffff097          	auipc	ra,0xfffff
    80002136:	d16080e7          	jalr	-746(ra) # 80000e48 <myproc>
}
    8000213a:	5908                	lw	a0,48(a0)
    8000213c:	60a2                	ld	ra,8(sp)
    8000213e:	6402                	ld	s0,0(sp)
    80002140:	0141                	addi	sp,sp,16
    80002142:	8082                	ret

0000000080002144 <sys_fork>:

uint64
sys_fork(void)
{
    80002144:	1141                	addi	sp,sp,-16
    80002146:	e406                	sd	ra,8(sp)
    80002148:	e022                	sd	s0,0(sp)
    8000214a:	0800                	addi	s0,sp,16
  return fork();
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	0d2080e7          	jalr	210(ra) # 8000121e <fork>
}
    80002154:	60a2                	ld	ra,8(sp)
    80002156:	6402                	ld	s0,0(sp)
    80002158:	0141                	addi	sp,sp,16
    8000215a:	8082                	ret

000000008000215c <sys_wait>:

uint64
sys_wait(void)
{
    8000215c:	1101                	addi	sp,sp,-32
    8000215e:	ec06                	sd	ra,24(sp)
    80002160:	e822                	sd	s0,16(sp)
    80002162:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002164:	fe840593          	addi	a1,s0,-24
    80002168:	4501                	li	a0,0
    8000216a:	00000097          	auipc	ra,0x0
    8000216e:	ece080e7          	jalr	-306(ra) # 80002038 <argaddr>
    80002172:	87aa                	mv	a5,a0
    return -1;
    80002174:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002176:	0007c863          	bltz	a5,80002186 <sys_wait+0x2a>
  return wait(p);
    8000217a:	fe843503          	ld	a0,-24(s0)
    8000217e:	fffff097          	auipc	ra,0xfffff
    80002182:	3f2080e7          	jalr	1010(ra) # 80001570 <wait>
}
    80002186:	60e2                	ld	ra,24(sp)
    80002188:	6442                	ld	s0,16(sp)
    8000218a:	6105                	addi	sp,sp,32
    8000218c:	8082                	ret

000000008000218e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000218e:	7179                	addi	sp,sp,-48
    80002190:	f406                	sd	ra,40(sp)
    80002192:	f022                	sd	s0,32(sp)
    80002194:	ec26                	sd	s1,24(sp)
    80002196:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002198:	fdc40593          	addi	a1,s0,-36
    8000219c:	4501                	li	a0,0
    8000219e:	00000097          	auipc	ra,0x0
    800021a2:	e78080e7          	jalr	-392(ra) # 80002016 <argint>
    800021a6:	87aa                	mv	a5,a0
    return -1;
    800021a8:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800021aa:	0207c063          	bltz	a5,800021ca <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	c9a080e7          	jalr	-870(ra) # 80000e48 <myproc>
    800021b6:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800021b8:	fdc42503          	lw	a0,-36(s0)
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	fee080e7          	jalr	-18(ra) # 800011aa <growproc>
    800021c4:	00054863          	bltz	a0,800021d4 <sys_sbrk+0x46>
    return -1;
  return addr;
    800021c8:	8526                	mv	a0,s1
}
    800021ca:	70a2                	ld	ra,40(sp)
    800021cc:	7402                	ld	s0,32(sp)
    800021ce:	64e2                	ld	s1,24(sp)
    800021d0:	6145                	addi	sp,sp,48
    800021d2:	8082                	ret
    return -1;
    800021d4:	557d                	li	a0,-1
    800021d6:	bfd5                	j	800021ca <sys_sbrk+0x3c>

00000000800021d8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021d8:	7139                	addi	sp,sp,-64
    800021da:	fc06                	sd	ra,56(sp)
    800021dc:	f822                	sd	s0,48(sp)
    800021de:	f426                	sd	s1,40(sp)
    800021e0:	f04a                	sd	s2,32(sp)
    800021e2:	ec4e                	sd	s3,24(sp)
    800021e4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021e6:	fcc40593          	addi	a1,s0,-52
    800021ea:	4501                	li	a0,0
    800021ec:	00000097          	auipc	ra,0x0
    800021f0:	e2a080e7          	jalr	-470(ra) # 80002016 <argint>
    return -1;
    800021f4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021f6:	06054963          	bltz	a0,80002268 <sys_sleep+0x90>
  acquire(&tickslock);
    800021fa:	00011517          	auipc	a0,0x11
    800021fe:	28650513          	addi	a0,a0,646 # 80013480 <tickslock>
    80002202:	00004097          	auipc	ra,0x4
    80002206:	17c080e7          	jalr	380(ra) # 8000637e <acquire>
  ticks0 = ticks;
    8000220a:	00007917          	auipc	s2,0x7
    8000220e:	e0e92903          	lw	s2,-498(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002212:	fcc42783          	lw	a5,-52(s0)
    80002216:	cf85                	beqz	a5,8000224e <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002218:	00011997          	auipc	s3,0x11
    8000221c:	26898993          	addi	s3,s3,616 # 80013480 <tickslock>
    80002220:	00007497          	auipc	s1,0x7
    80002224:	df848493          	addi	s1,s1,-520 # 80009018 <ticks>
    if(myproc()->killed){
    80002228:	fffff097          	auipc	ra,0xfffff
    8000222c:	c20080e7          	jalr	-992(ra) # 80000e48 <myproc>
    80002230:	551c                	lw	a5,40(a0)
    80002232:	e3b9                	bnez	a5,80002278 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    80002234:	85ce                	mv	a1,s3
    80002236:	8526                	mv	a0,s1
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	2d4080e7          	jalr	724(ra) # 8000150c <sleep>
  while(ticks - ticks0 < n){
    80002240:	409c                	lw	a5,0(s1)
    80002242:	412787bb          	subw	a5,a5,s2
    80002246:	fcc42703          	lw	a4,-52(s0)
    8000224a:	fce7efe3          	bltu	a5,a4,80002228 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000224e:	00011517          	auipc	a0,0x11
    80002252:	23250513          	addi	a0,a0,562 # 80013480 <tickslock>
    80002256:	00004097          	auipc	ra,0x4
    8000225a:	1dc080e7          	jalr	476(ra) # 80006432 <release>
  backtrace();
    8000225e:	00004097          	auipc	ra,0x4
    80002262:	dcc080e7          	jalr	-564(ra) # 8000602a <backtrace>
  return 0;
    80002266:	4781                	li	a5,0
}
    80002268:	853e                	mv	a0,a5
    8000226a:	70e2                	ld	ra,56(sp)
    8000226c:	7442                	ld	s0,48(sp)
    8000226e:	74a2                	ld	s1,40(sp)
    80002270:	7902                	ld	s2,32(sp)
    80002272:	69e2                	ld	s3,24(sp)
    80002274:	6121                	addi	sp,sp,64
    80002276:	8082                	ret
      release(&tickslock);
    80002278:	00011517          	auipc	a0,0x11
    8000227c:	20850513          	addi	a0,a0,520 # 80013480 <tickslock>
    80002280:	00004097          	auipc	ra,0x4
    80002284:	1b2080e7          	jalr	434(ra) # 80006432 <release>
      return -1;
    80002288:	57fd                	li	a5,-1
    8000228a:	bff9                	j	80002268 <sys_sleep+0x90>

000000008000228c <sys_kill>:

uint64
sys_kill(void)
{
    8000228c:	1101                	addi	sp,sp,-32
    8000228e:	ec06                	sd	ra,24(sp)
    80002290:	e822                	sd	s0,16(sp)
    80002292:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002294:	fec40593          	addi	a1,s0,-20
    80002298:	4501                	li	a0,0
    8000229a:	00000097          	auipc	ra,0x0
    8000229e:	d7c080e7          	jalr	-644(ra) # 80002016 <argint>
    800022a2:	87aa                	mv	a5,a0
    return -1;
    800022a4:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800022a6:	0007c863          	bltz	a5,800022b6 <sys_kill+0x2a>
  return kill(pid);
    800022aa:	fec42503          	lw	a0,-20(s0)
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	590080e7          	jalr	1424(ra) # 8000183e <kill>
}
    800022b6:	60e2                	ld	ra,24(sp)
    800022b8:	6442                	ld	s0,16(sp)
    800022ba:	6105                	addi	sp,sp,32
    800022bc:	8082                	ret

00000000800022be <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022be:	1101                	addi	sp,sp,-32
    800022c0:	ec06                	sd	ra,24(sp)
    800022c2:	e822                	sd	s0,16(sp)
    800022c4:	e426                	sd	s1,8(sp)
    800022c6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022c8:	00011517          	auipc	a0,0x11
    800022cc:	1b850513          	addi	a0,a0,440 # 80013480 <tickslock>
    800022d0:	00004097          	auipc	ra,0x4
    800022d4:	0ae080e7          	jalr	174(ra) # 8000637e <acquire>
  xticks = ticks;
    800022d8:	00007497          	auipc	s1,0x7
    800022dc:	d404a483          	lw	s1,-704(s1) # 80009018 <ticks>
  release(&tickslock);
    800022e0:	00011517          	auipc	a0,0x11
    800022e4:	1a050513          	addi	a0,a0,416 # 80013480 <tickslock>
    800022e8:	00004097          	auipc	ra,0x4
    800022ec:	14a080e7          	jalr	330(ra) # 80006432 <release>
  return xticks;
}
    800022f0:	02049513          	slli	a0,s1,0x20
    800022f4:	9101                	srli	a0,a0,0x20
    800022f6:	60e2                	ld	ra,24(sp)
    800022f8:	6442                	ld	s0,16(sp)
    800022fa:	64a2                	ld	s1,8(sp)
    800022fc:	6105                	addi	sp,sp,32
    800022fe:	8082                	ret

0000000080002300 <sys_sigalarm>:

uint64
sys_sigalarm(void)
{
    80002300:	7179                	addi	sp,sp,-48
    80002302:	f406                	sd	ra,40(sp)
    80002304:	f022                	sd	s0,32(sp)
    80002306:	ec26                	sd	s1,24(sp)
    80002308:	1800                	addi	s0,sp,48
  uint64 handler_pt;
  int alarm_intervals;
  struct proc *p = myproc();
    8000230a:	fffff097          	auipc	ra,0xfffff
    8000230e:	b3e080e7          	jalr	-1218(ra) # 80000e48 <myproc>
    80002312:	84aa                	mv	s1,a0
  if (argint(0, &alarm_intervals) < 0 || argaddr(1, &handler_pt) < 0)
    80002314:	fd440593          	addi	a1,s0,-44
    80002318:	4501                	li	a0,0
    8000231a:	00000097          	auipc	ra,0x0
    8000231e:	cfc080e7          	jalr	-772(ra) # 80002016 <argint>
    return -1;
    80002322:	57fd                	li	a5,-1
  if (argint(0, &alarm_intervals) < 0 || argaddr(1, &handler_pt) < 0)
    80002324:	02054463          	bltz	a0,8000234c <sys_sigalarm+0x4c>
    80002328:	fd840593          	addi	a1,s0,-40
    8000232c:	4505                	li	a0,1
    8000232e:	00000097          	auipc	ra,0x0
    80002332:	d0a080e7          	jalr	-758(ra) # 80002038 <argaddr>
    80002336:	02054163          	bltz	a0,80002358 <sys_sigalarm+0x58>
  p->alarm_intervals = alarm_intervals;
    8000233a:	fd442783          	lw	a5,-44(s0)
    8000233e:	16f4a823          	sw	a5,368(s1)
  p->handler_pt = handler_pt;
    80002342:	fd843783          	ld	a5,-40(s0)
    80002346:	16f4b423          	sd	a5,360(s1)
  // p->trapframe->epc = handler_pt;
  return 0;
    8000234a:	4781                	li	a5,0
}
    8000234c:	853e                	mv	a0,a5
    8000234e:	70a2                	ld	ra,40(sp)
    80002350:	7402                	ld	s0,32(sp)
    80002352:	64e2                	ld	s1,24(sp)
    80002354:	6145                	addi	sp,sp,48
    80002356:	8082                	ret
    return -1;
    80002358:	57fd                	li	a5,-1
    8000235a:	bfcd                	j	8000234c <sys_sigalarm+0x4c>

000000008000235c <sys_sigreturn>:

uint64
sys_sigreturn(void)
{
    8000235c:	1141                	addi	sp,sp,-16
    8000235e:	e406                	sd	ra,8(sp)
    80002360:	e022                	sd	s0,0(sp)
    80002362:	0800                	addi	s0,sp,16
  // return 0;
  struct proc *p = myproc();
    80002364:	fffff097          	auipc	ra,0xfffff
    80002368:	ae4080e7          	jalr	-1308(ra) # 80000e48 <myproc>
  // p->trapframe->kernel_satp = p->saved_kernel_satp;   // kernel page table
  // p->trapframe->kernel_sp = p->saved_kernel_sp;       // top of process's kernel stack
  // p->trapframe->kernel_trap = p->saved_kernel_trap;   // usertrap()
  p->trapframe->epc = p->saved_epc;           // saved user program counter
    8000236c:	6d3c                	ld	a5,88(a0)
    8000236e:	18053703          	ld	a4,384(a0)
    80002372:	ef98                	sd	a4,24(a5)
  // p->trapframe->kernel_hartid = p->saved_kernel_hartid; // saved kernel tp
  p->trapframe->ra = p->saved_ra;
    80002374:	6d3c                	ld	a5,88(a0)
    80002376:	18853703          	ld	a4,392(a0)
    8000237a:	f798                	sd	a4,40(a5)
  p->trapframe->sp = p->saved_sp;
    8000237c:	6d3c                	ld	a5,88(a0)
    8000237e:	19053703          	ld	a4,400(a0)
    80002382:	fb98                	sd	a4,48(a5)
  p->trapframe->gp = p->saved_gp;
    80002384:	6d3c                	ld	a5,88(a0)
    80002386:	19853703          	ld	a4,408(a0)
    8000238a:	ff98                	sd	a4,56(a5)
  p->trapframe->tp = p->saved_tp;
    8000238c:	6d3c                	ld	a5,88(a0)
    8000238e:	1a053703          	ld	a4,416(a0)
    80002392:	e3b8                	sd	a4,64(a5)
  p->trapframe->t0 = p->saved_t0;
    80002394:	6d3c                	ld	a5,88(a0)
    80002396:	1a853703          	ld	a4,424(a0)
    8000239a:	e7b8                	sd	a4,72(a5)
  p->trapframe->t1 = p->saved_t1;
    8000239c:	6d3c                	ld	a5,88(a0)
    8000239e:	1b053703          	ld	a4,432(a0)
    800023a2:	ebb8                	sd	a4,80(a5)
  p->trapframe->t2 = p->saved_t2;
    800023a4:	6d3c                	ld	a5,88(a0)
    800023a6:	1b853703          	ld	a4,440(a0)
    800023aa:	efb8                	sd	a4,88(a5)
  p->trapframe->s0 = p->saved_s0;
    800023ac:	6d3c                	ld	a5,88(a0)
    800023ae:	1c053703          	ld	a4,448(a0)
    800023b2:	f3b8                	sd	a4,96(a5)
  p->trapframe->s1 = p->saved_s1;
    800023b4:	6d3c                	ld	a5,88(a0)
    800023b6:	1c853703          	ld	a4,456(a0)
    800023ba:	f7b8                	sd	a4,104(a5)
  p->trapframe->a0 = p->saved_a0;
    800023bc:	6d3c                	ld	a5,88(a0)
    800023be:	1d053703          	ld	a4,464(a0)
    800023c2:	fbb8                	sd	a4,112(a5)
  p->trapframe->a1 = p->saved_a1;
    800023c4:	6d3c                	ld	a5,88(a0)
    800023c6:	1d853703          	ld	a4,472(a0)
    800023ca:	ffb8                	sd	a4,120(a5)
  p->trapframe->a2 = p->saved_a2;
    800023cc:	6d3c                	ld	a5,88(a0)
    800023ce:	1e053703          	ld	a4,480(a0)
    800023d2:	e3d8                	sd	a4,128(a5)
  p->trapframe->a3 = p->saved_a3;
    800023d4:	6d3c                	ld	a5,88(a0)
    800023d6:	1e853703          	ld	a4,488(a0)
    800023da:	e7d8                	sd	a4,136(a5)
  p->trapframe->a4 = p->saved_a4;
    800023dc:	6d3c                	ld	a5,88(a0)
    800023de:	1f053703          	ld	a4,496(a0)
    800023e2:	ebd8                	sd	a4,144(a5)
  p->trapframe->a5 = p->saved_a5;
    800023e4:	6d3c                	ld	a5,88(a0)
    800023e6:	1f853703          	ld	a4,504(a0)
    800023ea:	efd8                	sd	a4,152(a5)
  p->trapframe->a6 = p->saved_a6;
    800023ec:	6d3c                	ld	a5,88(a0)
    800023ee:	20053703          	ld	a4,512(a0)
    800023f2:	f3d8                	sd	a4,160(a5)
  p->trapframe->a7 = p->saved_a7;
    800023f4:	6d3c                	ld	a5,88(a0)
    800023f6:	20853703          	ld	a4,520(a0)
    800023fa:	f7d8                	sd	a4,168(a5)
  p->trapframe->s2 = p->saved_s2;
    800023fc:	6d3c                	ld	a5,88(a0)
    800023fe:	21053703          	ld	a4,528(a0)
    80002402:	fbd8                	sd	a4,176(a5)
  p->trapframe->s3 = p->saved_s3;
    80002404:	6d3c                	ld	a5,88(a0)
    80002406:	21853703          	ld	a4,536(a0)
    8000240a:	ffd8                	sd	a4,184(a5)
  p->trapframe->s4 = p->saved_s4;
    8000240c:	6d3c                	ld	a5,88(a0)
    8000240e:	22053703          	ld	a4,544(a0)
    80002412:	e3f8                	sd	a4,192(a5)
  p->trapframe->s5 = p->saved_s5;
    80002414:	6d3c                	ld	a5,88(a0)
    80002416:	22853703          	ld	a4,552(a0)
    8000241a:	e7f8                	sd	a4,200(a5)
  p->trapframe->s6 = p->saved_s6;
    8000241c:	6d3c                	ld	a5,88(a0)
    8000241e:	23053703          	ld	a4,560(a0)
    80002422:	ebf8                	sd	a4,208(a5)
  p->trapframe->s7 = p->saved_s7;
    80002424:	6d3c                	ld	a5,88(a0)
    80002426:	23853703          	ld	a4,568(a0)
    8000242a:	eff8                	sd	a4,216(a5)
  p->trapframe->s8 = p->saved_s8;
    8000242c:	6d3c                	ld	a5,88(a0)
    8000242e:	24053703          	ld	a4,576(a0)
    80002432:	f3f8                	sd	a4,224(a5)
  p->trapframe->s9 = p->saved_s9;
    80002434:	6d3c                	ld	a5,88(a0)
    80002436:	24853703          	ld	a4,584(a0)
    8000243a:	f7f8                	sd	a4,232(a5)
  p->trapframe->s10 = p->saved_s10;
    8000243c:	6d3c                	ld	a5,88(a0)
    8000243e:	25053703          	ld	a4,592(a0)
    80002442:	fbf8                	sd	a4,240(a5)
  p->trapframe->s11 = p->saved_s11;
    80002444:	6d3c                	ld	a5,88(a0)
    80002446:	25853703          	ld	a4,600(a0)
    8000244a:	fff8                	sd	a4,248(a5)
  p->trapframe->t3 = p->saved_t3;
    8000244c:	6d3c                	ld	a5,88(a0)
    8000244e:	26053703          	ld	a4,608(a0)
    80002452:	10e7b023          	sd	a4,256(a5)
  p->trapframe->t4 = p->saved_t4;
    80002456:	6d3c                	ld	a5,88(a0)
    80002458:	26853703          	ld	a4,616(a0)
    8000245c:	10e7b423          	sd	a4,264(a5)
  p->trapframe->t5 = p->saved_t5;
    80002460:	6d3c                	ld	a5,88(a0)
    80002462:	27053703          	ld	a4,624(a0)
    80002466:	10e7b823          	sd	a4,272(a5)
  p->trapframe->t6 = p->saved_t6;
    8000246a:	6d3c                	ld	a5,88(a0)
    8000246c:	27853703          	ld	a4,632(a0)
    80002470:	10e7bc23          	sd	a4,280(a5)
  p->in_handler = 0;
    80002474:	16052c23          	sw	zero,376(a0)
  return 0;
    80002478:	4501                	li	a0,0
    8000247a:	60a2                	ld	ra,8(sp)
    8000247c:	6402                	ld	s0,0(sp)
    8000247e:	0141                	addi	sp,sp,16
    80002480:	8082                	ret

0000000080002482 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002482:	7179                	addi	sp,sp,-48
    80002484:	f406                	sd	ra,40(sp)
    80002486:	f022                	sd	s0,32(sp)
    80002488:	ec26                	sd	s1,24(sp)
    8000248a:	e84a                	sd	s2,16(sp)
    8000248c:	e44e                	sd	s3,8(sp)
    8000248e:	e052                	sd	s4,0(sp)
    80002490:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002492:	00006597          	auipc	a1,0x6
    80002496:	ff658593          	addi	a1,a1,-10 # 80008488 <syscalls+0xc0>
    8000249a:	00011517          	auipc	a0,0x11
    8000249e:	ffe50513          	addi	a0,a0,-2 # 80013498 <bcache>
    800024a2:	00004097          	auipc	ra,0x4
    800024a6:	e4c080e7          	jalr	-436(ra) # 800062ee <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024aa:	00019797          	auipc	a5,0x19
    800024ae:	fee78793          	addi	a5,a5,-18 # 8001b498 <bcache+0x8000>
    800024b2:	00019717          	auipc	a4,0x19
    800024b6:	24e70713          	addi	a4,a4,590 # 8001b700 <bcache+0x8268>
    800024ba:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024be:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024c2:	00011497          	auipc	s1,0x11
    800024c6:	fee48493          	addi	s1,s1,-18 # 800134b0 <bcache+0x18>
    b->next = bcache.head.next;
    800024ca:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024cc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024ce:	00006a17          	auipc	s4,0x6
    800024d2:	fc2a0a13          	addi	s4,s4,-62 # 80008490 <syscalls+0xc8>
    b->next = bcache.head.next;
    800024d6:	2b893783          	ld	a5,696(s2)
    800024da:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024dc:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024e0:	85d2                	mv	a1,s4
    800024e2:	01048513          	addi	a0,s1,16
    800024e6:	00001097          	auipc	ra,0x1
    800024ea:	4bc080e7          	jalr	1212(ra) # 800039a2 <initsleeplock>
    bcache.head.next->prev = b;
    800024ee:	2b893783          	ld	a5,696(s2)
    800024f2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024f4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024f8:	45848493          	addi	s1,s1,1112
    800024fc:	fd349de3          	bne	s1,s3,800024d6 <binit+0x54>
  }
}
    80002500:	70a2                	ld	ra,40(sp)
    80002502:	7402                	ld	s0,32(sp)
    80002504:	64e2                	ld	s1,24(sp)
    80002506:	6942                	ld	s2,16(sp)
    80002508:	69a2                	ld	s3,8(sp)
    8000250a:	6a02                	ld	s4,0(sp)
    8000250c:	6145                	addi	sp,sp,48
    8000250e:	8082                	ret

0000000080002510 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002510:	7179                	addi	sp,sp,-48
    80002512:	f406                	sd	ra,40(sp)
    80002514:	f022                	sd	s0,32(sp)
    80002516:	ec26                	sd	s1,24(sp)
    80002518:	e84a                	sd	s2,16(sp)
    8000251a:	e44e                	sd	s3,8(sp)
    8000251c:	1800                	addi	s0,sp,48
    8000251e:	89aa                	mv	s3,a0
    80002520:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002522:	00011517          	auipc	a0,0x11
    80002526:	f7650513          	addi	a0,a0,-138 # 80013498 <bcache>
    8000252a:	00004097          	auipc	ra,0x4
    8000252e:	e54080e7          	jalr	-428(ra) # 8000637e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002532:	00019497          	auipc	s1,0x19
    80002536:	21e4b483          	ld	s1,542(s1) # 8001b750 <bcache+0x82b8>
    8000253a:	00019797          	auipc	a5,0x19
    8000253e:	1c678793          	addi	a5,a5,454 # 8001b700 <bcache+0x8268>
    80002542:	02f48f63          	beq	s1,a5,80002580 <bread+0x70>
    80002546:	873e                	mv	a4,a5
    80002548:	a021                	j	80002550 <bread+0x40>
    8000254a:	68a4                	ld	s1,80(s1)
    8000254c:	02e48a63          	beq	s1,a4,80002580 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002550:	449c                	lw	a5,8(s1)
    80002552:	ff379ce3          	bne	a5,s3,8000254a <bread+0x3a>
    80002556:	44dc                	lw	a5,12(s1)
    80002558:	ff2799e3          	bne	a5,s2,8000254a <bread+0x3a>
      b->refcnt++;
    8000255c:	40bc                	lw	a5,64(s1)
    8000255e:	2785                	addiw	a5,a5,1
    80002560:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002562:	00011517          	auipc	a0,0x11
    80002566:	f3650513          	addi	a0,a0,-202 # 80013498 <bcache>
    8000256a:	00004097          	auipc	ra,0x4
    8000256e:	ec8080e7          	jalr	-312(ra) # 80006432 <release>
      acquiresleep(&b->lock);
    80002572:	01048513          	addi	a0,s1,16
    80002576:	00001097          	auipc	ra,0x1
    8000257a:	466080e7          	jalr	1126(ra) # 800039dc <acquiresleep>
      return b;
    8000257e:	a8b9                	j	800025dc <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002580:	00019497          	auipc	s1,0x19
    80002584:	1c84b483          	ld	s1,456(s1) # 8001b748 <bcache+0x82b0>
    80002588:	00019797          	auipc	a5,0x19
    8000258c:	17878793          	addi	a5,a5,376 # 8001b700 <bcache+0x8268>
    80002590:	00f48863          	beq	s1,a5,800025a0 <bread+0x90>
    80002594:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002596:	40bc                	lw	a5,64(s1)
    80002598:	cf81                	beqz	a5,800025b0 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000259a:	64a4                	ld	s1,72(s1)
    8000259c:	fee49de3          	bne	s1,a4,80002596 <bread+0x86>
  panic("bget: no buffers");
    800025a0:	00006517          	auipc	a0,0x6
    800025a4:	ef850513          	addi	a0,a0,-264 # 80008498 <syscalls+0xd0>
    800025a8:	00004097          	auipc	ra,0x4
    800025ac:	820080e7          	jalr	-2016(ra) # 80005dc8 <panic>
      b->dev = dev;
    800025b0:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800025b4:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800025b8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025bc:	4785                	li	a5,1
    800025be:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025c0:	00011517          	auipc	a0,0x11
    800025c4:	ed850513          	addi	a0,a0,-296 # 80013498 <bcache>
    800025c8:	00004097          	auipc	ra,0x4
    800025cc:	e6a080e7          	jalr	-406(ra) # 80006432 <release>
      acquiresleep(&b->lock);
    800025d0:	01048513          	addi	a0,s1,16
    800025d4:	00001097          	auipc	ra,0x1
    800025d8:	408080e7          	jalr	1032(ra) # 800039dc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025dc:	409c                	lw	a5,0(s1)
    800025de:	cb89                	beqz	a5,800025f0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025e0:	8526                	mv	a0,s1
    800025e2:	70a2                	ld	ra,40(sp)
    800025e4:	7402                	ld	s0,32(sp)
    800025e6:	64e2                	ld	s1,24(sp)
    800025e8:	6942                	ld	s2,16(sp)
    800025ea:	69a2                	ld	s3,8(sp)
    800025ec:	6145                	addi	sp,sp,48
    800025ee:	8082                	ret
    virtio_disk_rw(b, 0);
    800025f0:	4581                	li	a1,0
    800025f2:	8526                	mv	a0,s1
    800025f4:	00003097          	auipc	ra,0x3
    800025f8:	f12080e7          	jalr	-238(ra) # 80005506 <virtio_disk_rw>
    b->valid = 1;
    800025fc:	4785                	li	a5,1
    800025fe:	c09c                	sw	a5,0(s1)
  return b;
    80002600:	b7c5                	j	800025e0 <bread+0xd0>

0000000080002602 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002602:	1101                	addi	sp,sp,-32
    80002604:	ec06                	sd	ra,24(sp)
    80002606:	e822                	sd	s0,16(sp)
    80002608:	e426                	sd	s1,8(sp)
    8000260a:	1000                	addi	s0,sp,32
    8000260c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000260e:	0541                	addi	a0,a0,16
    80002610:	00001097          	auipc	ra,0x1
    80002614:	466080e7          	jalr	1126(ra) # 80003a76 <holdingsleep>
    80002618:	cd01                	beqz	a0,80002630 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000261a:	4585                	li	a1,1
    8000261c:	8526                	mv	a0,s1
    8000261e:	00003097          	auipc	ra,0x3
    80002622:	ee8080e7          	jalr	-280(ra) # 80005506 <virtio_disk_rw>
}
    80002626:	60e2                	ld	ra,24(sp)
    80002628:	6442                	ld	s0,16(sp)
    8000262a:	64a2                	ld	s1,8(sp)
    8000262c:	6105                	addi	sp,sp,32
    8000262e:	8082                	ret
    panic("bwrite");
    80002630:	00006517          	auipc	a0,0x6
    80002634:	e8050513          	addi	a0,a0,-384 # 800084b0 <syscalls+0xe8>
    80002638:	00003097          	auipc	ra,0x3
    8000263c:	790080e7          	jalr	1936(ra) # 80005dc8 <panic>

0000000080002640 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002640:	1101                	addi	sp,sp,-32
    80002642:	ec06                	sd	ra,24(sp)
    80002644:	e822                	sd	s0,16(sp)
    80002646:	e426                	sd	s1,8(sp)
    80002648:	e04a                	sd	s2,0(sp)
    8000264a:	1000                	addi	s0,sp,32
    8000264c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000264e:	01050913          	addi	s2,a0,16
    80002652:	854a                	mv	a0,s2
    80002654:	00001097          	auipc	ra,0x1
    80002658:	422080e7          	jalr	1058(ra) # 80003a76 <holdingsleep>
    8000265c:	c92d                	beqz	a0,800026ce <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000265e:	854a                	mv	a0,s2
    80002660:	00001097          	auipc	ra,0x1
    80002664:	3d2080e7          	jalr	978(ra) # 80003a32 <releasesleep>

  acquire(&bcache.lock);
    80002668:	00011517          	auipc	a0,0x11
    8000266c:	e3050513          	addi	a0,a0,-464 # 80013498 <bcache>
    80002670:	00004097          	auipc	ra,0x4
    80002674:	d0e080e7          	jalr	-754(ra) # 8000637e <acquire>
  b->refcnt--;
    80002678:	40bc                	lw	a5,64(s1)
    8000267a:	37fd                	addiw	a5,a5,-1
    8000267c:	0007871b          	sext.w	a4,a5
    80002680:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002682:	eb05                	bnez	a4,800026b2 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002684:	68bc                	ld	a5,80(s1)
    80002686:	64b8                	ld	a4,72(s1)
    80002688:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000268a:	64bc                	ld	a5,72(s1)
    8000268c:	68b8                	ld	a4,80(s1)
    8000268e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002690:	00019797          	auipc	a5,0x19
    80002694:	e0878793          	addi	a5,a5,-504 # 8001b498 <bcache+0x8000>
    80002698:	2b87b703          	ld	a4,696(a5)
    8000269c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000269e:	00019717          	auipc	a4,0x19
    800026a2:	06270713          	addi	a4,a4,98 # 8001b700 <bcache+0x8268>
    800026a6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026a8:	2b87b703          	ld	a4,696(a5)
    800026ac:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026ae:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026b2:	00011517          	auipc	a0,0x11
    800026b6:	de650513          	addi	a0,a0,-538 # 80013498 <bcache>
    800026ba:	00004097          	auipc	ra,0x4
    800026be:	d78080e7          	jalr	-648(ra) # 80006432 <release>
}
    800026c2:	60e2                	ld	ra,24(sp)
    800026c4:	6442                	ld	s0,16(sp)
    800026c6:	64a2                	ld	s1,8(sp)
    800026c8:	6902                	ld	s2,0(sp)
    800026ca:	6105                	addi	sp,sp,32
    800026cc:	8082                	ret
    panic("brelse");
    800026ce:	00006517          	auipc	a0,0x6
    800026d2:	dea50513          	addi	a0,a0,-534 # 800084b8 <syscalls+0xf0>
    800026d6:	00003097          	auipc	ra,0x3
    800026da:	6f2080e7          	jalr	1778(ra) # 80005dc8 <panic>

00000000800026de <bpin>:

void
bpin(struct buf *b) {
    800026de:	1101                	addi	sp,sp,-32
    800026e0:	ec06                	sd	ra,24(sp)
    800026e2:	e822                	sd	s0,16(sp)
    800026e4:	e426                	sd	s1,8(sp)
    800026e6:	1000                	addi	s0,sp,32
    800026e8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026ea:	00011517          	auipc	a0,0x11
    800026ee:	dae50513          	addi	a0,a0,-594 # 80013498 <bcache>
    800026f2:	00004097          	auipc	ra,0x4
    800026f6:	c8c080e7          	jalr	-884(ra) # 8000637e <acquire>
  b->refcnt++;
    800026fa:	40bc                	lw	a5,64(s1)
    800026fc:	2785                	addiw	a5,a5,1
    800026fe:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002700:	00011517          	auipc	a0,0x11
    80002704:	d9850513          	addi	a0,a0,-616 # 80013498 <bcache>
    80002708:	00004097          	auipc	ra,0x4
    8000270c:	d2a080e7          	jalr	-726(ra) # 80006432 <release>
}
    80002710:	60e2                	ld	ra,24(sp)
    80002712:	6442                	ld	s0,16(sp)
    80002714:	64a2                	ld	s1,8(sp)
    80002716:	6105                	addi	sp,sp,32
    80002718:	8082                	ret

000000008000271a <bunpin>:

void
bunpin(struct buf *b) {
    8000271a:	1101                	addi	sp,sp,-32
    8000271c:	ec06                	sd	ra,24(sp)
    8000271e:	e822                	sd	s0,16(sp)
    80002720:	e426                	sd	s1,8(sp)
    80002722:	1000                	addi	s0,sp,32
    80002724:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002726:	00011517          	auipc	a0,0x11
    8000272a:	d7250513          	addi	a0,a0,-654 # 80013498 <bcache>
    8000272e:	00004097          	auipc	ra,0x4
    80002732:	c50080e7          	jalr	-944(ra) # 8000637e <acquire>
  b->refcnt--;
    80002736:	40bc                	lw	a5,64(s1)
    80002738:	37fd                	addiw	a5,a5,-1
    8000273a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000273c:	00011517          	auipc	a0,0x11
    80002740:	d5c50513          	addi	a0,a0,-676 # 80013498 <bcache>
    80002744:	00004097          	auipc	ra,0x4
    80002748:	cee080e7          	jalr	-786(ra) # 80006432 <release>
}
    8000274c:	60e2                	ld	ra,24(sp)
    8000274e:	6442                	ld	s0,16(sp)
    80002750:	64a2                	ld	s1,8(sp)
    80002752:	6105                	addi	sp,sp,32
    80002754:	8082                	ret

0000000080002756 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002756:	1101                	addi	sp,sp,-32
    80002758:	ec06                	sd	ra,24(sp)
    8000275a:	e822                	sd	s0,16(sp)
    8000275c:	e426                	sd	s1,8(sp)
    8000275e:	e04a                	sd	s2,0(sp)
    80002760:	1000                	addi	s0,sp,32
    80002762:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002764:	00d5d59b          	srliw	a1,a1,0xd
    80002768:	00019797          	auipc	a5,0x19
    8000276c:	40c7a783          	lw	a5,1036(a5) # 8001bb74 <sb+0x1c>
    80002770:	9dbd                	addw	a1,a1,a5
    80002772:	00000097          	auipc	ra,0x0
    80002776:	d9e080e7          	jalr	-610(ra) # 80002510 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000277a:	0074f713          	andi	a4,s1,7
    8000277e:	4785                	li	a5,1
    80002780:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002784:	14ce                	slli	s1,s1,0x33
    80002786:	90d9                	srli	s1,s1,0x36
    80002788:	00950733          	add	a4,a0,s1
    8000278c:	05874703          	lbu	a4,88(a4)
    80002790:	00e7f6b3          	and	a3,a5,a4
    80002794:	c69d                	beqz	a3,800027c2 <bfree+0x6c>
    80002796:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002798:	94aa                	add	s1,s1,a0
    8000279a:	fff7c793          	not	a5,a5
    8000279e:	8ff9                	and	a5,a5,a4
    800027a0:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800027a4:	00001097          	auipc	ra,0x1
    800027a8:	118080e7          	jalr	280(ra) # 800038bc <log_write>
  brelse(bp);
    800027ac:	854a                	mv	a0,s2
    800027ae:	00000097          	auipc	ra,0x0
    800027b2:	e92080e7          	jalr	-366(ra) # 80002640 <brelse>
}
    800027b6:	60e2                	ld	ra,24(sp)
    800027b8:	6442                	ld	s0,16(sp)
    800027ba:	64a2                	ld	s1,8(sp)
    800027bc:	6902                	ld	s2,0(sp)
    800027be:	6105                	addi	sp,sp,32
    800027c0:	8082                	ret
    panic("freeing free block");
    800027c2:	00006517          	auipc	a0,0x6
    800027c6:	cfe50513          	addi	a0,a0,-770 # 800084c0 <syscalls+0xf8>
    800027ca:	00003097          	auipc	ra,0x3
    800027ce:	5fe080e7          	jalr	1534(ra) # 80005dc8 <panic>

00000000800027d2 <balloc>:
{
    800027d2:	711d                	addi	sp,sp,-96
    800027d4:	ec86                	sd	ra,88(sp)
    800027d6:	e8a2                	sd	s0,80(sp)
    800027d8:	e4a6                	sd	s1,72(sp)
    800027da:	e0ca                	sd	s2,64(sp)
    800027dc:	fc4e                	sd	s3,56(sp)
    800027de:	f852                	sd	s4,48(sp)
    800027e0:	f456                	sd	s5,40(sp)
    800027e2:	f05a                	sd	s6,32(sp)
    800027e4:	ec5e                	sd	s7,24(sp)
    800027e6:	e862                	sd	s8,16(sp)
    800027e8:	e466                	sd	s9,8(sp)
    800027ea:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027ec:	00019797          	auipc	a5,0x19
    800027f0:	3707a783          	lw	a5,880(a5) # 8001bb5c <sb+0x4>
    800027f4:	cbd1                	beqz	a5,80002888 <balloc+0xb6>
    800027f6:	8baa                	mv	s7,a0
    800027f8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027fa:	00019b17          	auipc	s6,0x19
    800027fe:	35eb0b13          	addi	s6,s6,862 # 8001bb58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002802:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002804:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002806:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002808:	6c89                	lui	s9,0x2
    8000280a:	a831                	j	80002826 <balloc+0x54>
    brelse(bp);
    8000280c:	854a                	mv	a0,s2
    8000280e:	00000097          	auipc	ra,0x0
    80002812:	e32080e7          	jalr	-462(ra) # 80002640 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002816:	015c87bb          	addw	a5,s9,s5
    8000281a:	00078a9b          	sext.w	s5,a5
    8000281e:	004b2703          	lw	a4,4(s6)
    80002822:	06eaf363          	bgeu	s5,a4,80002888 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002826:	41fad79b          	sraiw	a5,s5,0x1f
    8000282a:	0137d79b          	srliw	a5,a5,0x13
    8000282e:	015787bb          	addw	a5,a5,s5
    80002832:	40d7d79b          	sraiw	a5,a5,0xd
    80002836:	01cb2583          	lw	a1,28(s6)
    8000283a:	9dbd                	addw	a1,a1,a5
    8000283c:	855e                	mv	a0,s7
    8000283e:	00000097          	auipc	ra,0x0
    80002842:	cd2080e7          	jalr	-814(ra) # 80002510 <bread>
    80002846:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002848:	004b2503          	lw	a0,4(s6)
    8000284c:	000a849b          	sext.w	s1,s5
    80002850:	8662                	mv	a2,s8
    80002852:	faa4fde3          	bgeu	s1,a0,8000280c <balloc+0x3a>
      m = 1 << (bi % 8);
    80002856:	41f6579b          	sraiw	a5,a2,0x1f
    8000285a:	01d7d69b          	srliw	a3,a5,0x1d
    8000285e:	00c6873b          	addw	a4,a3,a2
    80002862:	00777793          	andi	a5,a4,7
    80002866:	9f95                	subw	a5,a5,a3
    80002868:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000286c:	4037571b          	sraiw	a4,a4,0x3
    80002870:	00e906b3          	add	a3,s2,a4
    80002874:	0586c683          	lbu	a3,88(a3)
    80002878:	00d7f5b3          	and	a1,a5,a3
    8000287c:	cd91                	beqz	a1,80002898 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000287e:	2605                	addiw	a2,a2,1
    80002880:	2485                	addiw	s1,s1,1
    80002882:	fd4618e3          	bne	a2,s4,80002852 <balloc+0x80>
    80002886:	b759                	j	8000280c <balloc+0x3a>
  panic("balloc: out of blocks");
    80002888:	00006517          	auipc	a0,0x6
    8000288c:	c5050513          	addi	a0,a0,-944 # 800084d8 <syscalls+0x110>
    80002890:	00003097          	auipc	ra,0x3
    80002894:	538080e7          	jalr	1336(ra) # 80005dc8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002898:	974a                	add	a4,a4,s2
    8000289a:	8fd5                	or	a5,a5,a3
    8000289c:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800028a0:	854a                	mv	a0,s2
    800028a2:	00001097          	auipc	ra,0x1
    800028a6:	01a080e7          	jalr	26(ra) # 800038bc <log_write>
        brelse(bp);
    800028aa:	854a                	mv	a0,s2
    800028ac:	00000097          	auipc	ra,0x0
    800028b0:	d94080e7          	jalr	-620(ra) # 80002640 <brelse>
  bp = bread(dev, bno);
    800028b4:	85a6                	mv	a1,s1
    800028b6:	855e                	mv	a0,s7
    800028b8:	00000097          	auipc	ra,0x0
    800028bc:	c58080e7          	jalr	-936(ra) # 80002510 <bread>
    800028c0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028c2:	40000613          	li	a2,1024
    800028c6:	4581                	li	a1,0
    800028c8:	05850513          	addi	a0,a0,88
    800028cc:	ffffe097          	auipc	ra,0xffffe
    800028d0:	8ac080e7          	jalr	-1876(ra) # 80000178 <memset>
  log_write(bp);
    800028d4:	854a                	mv	a0,s2
    800028d6:	00001097          	auipc	ra,0x1
    800028da:	fe6080e7          	jalr	-26(ra) # 800038bc <log_write>
  brelse(bp);
    800028de:	854a                	mv	a0,s2
    800028e0:	00000097          	auipc	ra,0x0
    800028e4:	d60080e7          	jalr	-672(ra) # 80002640 <brelse>
}
    800028e8:	8526                	mv	a0,s1
    800028ea:	60e6                	ld	ra,88(sp)
    800028ec:	6446                	ld	s0,80(sp)
    800028ee:	64a6                	ld	s1,72(sp)
    800028f0:	6906                	ld	s2,64(sp)
    800028f2:	79e2                	ld	s3,56(sp)
    800028f4:	7a42                	ld	s4,48(sp)
    800028f6:	7aa2                	ld	s5,40(sp)
    800028f8:	7b02                	ld	s6,32(sp)
    800028fa:	6be2                	ld	s7,24(sp)
    800028fc:	6c42                	ld	s8,16(sp)
    800028fe:	6ca2                	ld	s9,8(sp)
    80002900:	6125                	addi	sp,sp,96
    80002902:	8082                	ret

0000000080002904 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002904:	7179                	addi	sp,sp,-48
    80002906:	f406                	sd	ra,40(sp)
    80002908:	f022                	sd	s0,32(sp)
    8000290a:	ec26                	sd	s1,24(sp)
    8000290c:	e84a                	sd	s2,16(sp)
    8000290e:	e44e                	sd	s3,8(sp)
    80002910:	e052                	sd	s4,0(sp)
    80002912:	1800                	addi	s0,sp,48
    80002914:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002916:	47ad                	li	a5,11
    80002918:	04b7fe63          	bgeu	a5,a1,80002974 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000291c:	ff45849b          	addiw	s1,a1,-12
    80002920:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002924:	0ff00793          	li	a5,255
    80002928:	0ae7e363          	bltu	a5,a4,800029ce <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000292c:	08052583          	lw	a1,128(a0)
    80002930:	c5ad                	beqz	a1,8000299a <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002932:	00092503          	lw	a0,0(s2)
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	bda080e7          	jalr	-1062(ra) # 80002510 <bread>
    8000293e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002940:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002944:	02049593          	slli	a1,s1,0x20
    80002948:	9181                	srli	a1,a1,0x20
    8000294a:	058a                	slli	a1,a1,0x2
    8000294c:	00b784b3          	add	s1,a5,a1
    80002950:	0004a983          	lw	s3,0(s1)
    80002954:	04098d63          	beqz	s3,800029ae <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002958:	8552                	mv	a0,s4
    8000295a:	00000097          	auipc	ra,0x0
    8000295e:	ce6080e7          	jalr	-794(ra) # 80002640 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002962:	854e                	mv	a0,s3
    80002964:	70a2                	ld	ra,40(sp)
    80002966:	7402                	ld	s0,32(sp)
    80002968:	64e2                	ld	s1,24(sp)
    8000296a:	6942                	ld	s2,16(sp)
    8000296c:	69a2                	ld	s3,8(sp)
    8000296e:	6a02                	ld	s4,0(sp)
    80002970:	6145                	addi	sp,sp,48
    80002972:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002974:	02059493          	slli	s1,a1,0x20
    80002978:	9081                	srli	s1,s1,0x20
    8000297a:	048a                	slli	s1,s1,0x2
    8000297c:	94aa                	add	s1,s1,a0
    8000297e:	0504a983          	lw	s3,80(s1)
    80002982:	fe0990e3          	bnez	s3,80002962 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002986:	4108                	lw	a0,0(a0)
    80002988:	00000097          	auipc	ra,0x0
    8000298c:	e4a080e7          	jalr	-438(ra) # 800027d2 <balloc>
    80002990:	0005099b          	sext.w	s3,a0
    80002994:	0534a823          	sw	s3,80(s1)
    80002998:	b7e9                	j	80002962 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000299a:	4108                	lw	a0,0(a0)
    8000299c:	00000097          	auipc	ra,0x0
    800029a0:	e36080e7          	jalr	-458(ra) # 800027d2 <balloc>
    800029a4:	0005059b          	sext.w	a1,a0
    800029a8:	08b92023          	sw	a1,128(s2)
    800029ac:	b759                	j	80002932 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029ae:	00092503          	lw	a0,0(s2)
    800029b2:	00000097          	auipc	ra,0x0
    800029b6:	e20080e7          	jalr	-480(ra) # 800027d2 <balloc>
    800029ba:	0005099b          	sext.w	s3,a0
    800029be:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029c2:	8552                	mv	a0,s4
    800029c4:	00001097          	auipc	ra,0x1
    800029c8:	ef8080e7          	jalr	-264(ra) # 800038bc <log_write>
    800029cc:	b771                	j	80002958 <bmap+0x54>
  panic("bmap: out of range");
    800029ce:	00006517          	auipc	a0,0x6
    800029d2:	b2250513          	addi	a0,a0,-1246 # 800084f0 <syscalls+0x128>
    800029d6:	00003097          	auipc	ra,0x3
    800029da:	3f2080e7          	jalr	1010(ra) # 80005dc8 <panic>

00000000800029de <iget>:
{
    800029de:	7179                	addi	sp,sp,-48
    800029e0:	f406                	sd	ra,40(sp)
    800029e2:	f022                	sd	s0,32(sp)
    800029e4:	ec26                	sd	s1,24(sp)
    800029e6:	e84a                	sd	s2,16(sp)
    800029e8:	e44e                	sd	s3,8(sp)
    800029ea:	e052                	sd	s4,0(sp)
    800029ec:	1800                	addi	s0,sp,48
    800029ee:	89aa                	mv	s3,a0
    800029f0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029f2:	00019517          	auipc	a0,0x19
    800029f6:	18650513          	addi	a0,a0,390 # 8001bb78 <itable>
    800029fa:	00004097          	auipc	ra,0x4
    800029fe:	984080e7          	jalr	-1660(ra) # 8000637e <acquire>
  empty = 0;
    80002a02:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a04:	00019497          	auipc	s1,0x19
    80002a08:	18c48493          	addi	s1,s1,396 # 8001bb90 <itable+0x18>
    80002a0c:	0001b697          	auipc	a3,0x1b
    80002a10:	c1468693          	addi	a3,a3,-1004 # 8001d620 <log>
    80002a14:	a039                	j	80002a22 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a16:	02090b63          	beqz	s2,80002a4c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a1a:	08848493          	addi	s1,s1,136
    80002a1e:	02d48a63          	beq	s1,a3,80002a52 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a22:	449c                	lw	a5,8(s1)
    80002a24:	fef059e3          	blez	a5,80002a16 <iget+0x38>
    80002a28:	4098                	lw	a4,0(s1)
    80002a2a:	ff3716e3          	bne	a4,s3,80002a16 <iget+0x38>
    80002a2e:	40d8                	lw	a4,4(s1)
    80002a30:	ff4713e3          	bne	a4,s4,80002a16 <iget+0x38>
      ip->ref++;
    80002a34:	2785                	addiw	a5,a5,1
    80002a36:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a38:	00019517          	auipc	a0,0x19
    80002a3c:	14050513          	addi	a0,a0,320 # 8001bb78 <itable>
    80002a40:	00004097          	auipc	ra,0x4
    80002a44:	9f2080e7          	jalr	-1550(ra) # 80006432 <release>
      return ip;
    80002a48:	8926                	mv	s2,s1
    80002a4a:	a03d                	j	80002a78 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a4c:	f7f9                	bnez	a5,80002a1a <iget+0x3c>
    80002a4e:	8926                	mv	s2,s1
    80002a50:	b7e9                	j	80002a1a <iget+0x3c>
  if(empty == 0)
    80002a52:	02090c63          	beqz	s2,80002a8a <iget+0xac>
  ip->dev = dev;
    80002a56:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a5a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a5e:	4785                	li	a5,1
    80002a60:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a64:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a68:	00019517          	auipc	a0,0x19
    80002a6c:	11050513          	addi	a0,a0,272 # 8001bb78 <itable>
    80002a70:	00004097          	auipc	ra,0x4
    80002a74:	9c2080e7          	jalr	-1598(ra) # 80006432 <release>
}
    80002a78:	854a                	mv	a0,s2
    80002a7a:	70a2                	ld	ra,40(sp)
    80002a7c:	7402                	ld	s0,32(sp)
    80002a7e:	64e2                	ld	s1,24(sp)
    80002a80:	6942                	ld	s2,16(sp)
    80002a82:	69a2                	ld	s3,8(sp)
    80002a84:	6a02                	ld	s4,0(sp)
    80002a86:	6145                	addi	sp,sp,48
    80002a88:	8082                	ret
    panic("iget: no inodes");
    80002a8a:	00006517          	auipc	a0,0x6
    80002a8e:	a7e50513          	addi	a0,a0,-1410 # 80008508 <syscalls+0x140>
    80002a92:	00003097          	auipc	ra,0x3
    80002a96:	336080e7          	jalr	822(ra) # 80005dc8 <panic>

0000000080002a9a <fsinit>:
fsinit(int dev) {
    80002a9a:	7179                	addi	sp,sp,-48
    80002a9c:	f406                	sd	ra,40(sp)
    80002a9e:	f022                	sd	s0,32(sp)
    80002aa0:	ec26                	sd	s1,24(sp)
    80002aa2:	e84a                	sd	s2,16(sp)
    80002aa4:	e44e                	sd	s3,8(sp)
    80002aa6:	1800                	addi	s0,sp,48
    80002aa8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002aaa:	4585                	li	a1,1
    80002aac:	00000097          	auipc	ra,0x0
    80002ab0:	a64080e7          	jalr	-1436(ra) # 80002510 <bread>
    80002ab4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002ab6:	00019997          	auipc	s3,0x19
    80002aba:	0a298993          	addi	s3,s3,162 # 8001bb58 <sb>
    80002abe:	02000613          	li	a2,32
    80002ac2:	05850593          	addi	a1,a0,88
    80002ac6:	854e                	mv	a0,s3
    80002ac8:	ffffd097          	auipc	ra,0xffffd
    80002acc:	710080e7          	jalr	1808(ra) # 800001d8 <memmove>
  brelse(bp);
    80002ad0:	8526                	mv	a0,s1
    80002ad2:	00000097          	auipc	ra,0x0
    80002ad6:	b6e080e7          	jalr	-1170(ra) # 80002640 <brelse>
  if(sb.magic != FSMAGIC)
    80002ada:	0009a703          	lw	a4,0(s3)
    80002ade:	102037b7          	lui	a5,0x10203
    80002ae2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ae6:	02f71263          	bne	a4,a5,80002b0a <fsinit+0x70>
  initlog(dev, &sb);
    80002aea:	00019597          	auipc	a1,0x19
    80002aee:	06e58593          	addi	a1,a1,110 # 8001bb58 <sb>
    80002af2:	854a                	mv	a0,s2
    80002af4:	00001097          	auipc	ra,0x1
    80002af8:	b4c080e7          	jalr	-1204(ra) # 80003640 <initlog>
}
    80002afc:	70a2                	ld	ra,40(sp)
    80002afe:	7402                	ld	s0,32(sp)
    80002b00:	64e2                	ld	s1,24(sp)
    80002b02:	6942                	ld	s2,16(sp)
    80002b04:	69a2                	ld	s3,8(sp)
    80002b06:	6145                	addi	sp,sp,48
    80002b08:	8082                	ret
    panic("invalid file system");
    80002b0a:	00006517          	auipc	a0,0x6
    80002b0e:	a0e50513          	addi	a0,a0,-1522 # 80008518 <syscalls+0x150>
    80002b12:	00003097          	auipc	ra,0x3
    80002b16:	2b6080e7          	jalr	694(ra) # 80005dc8 <panic>

0000000080002b1a <iinit>:
{
    80002b1a:	7179                	addi	sp,sp,-48
    80002b1c:	f406                	sd	ra,40(sp)
    80002b1e:	f022                	sd	s0,32(sp)
    80002b20:	ec26                	sd	s1,24(sp)
    80002b22:	e84a                	sd	s2,16(sp)
    80002b24:	e44e                	sd	s3,8(sp)
    80002b26:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b28:	00006597          	auipc	a1,0x6
    80002b2c:	a0858593          	addi	a1,a1,-1528 # 80008530 <syscalls+0x168>
    80002b30:	00019517          	auipc	a0,0x19
    80002b34:	04850513          	addi	a0,a0,72 # 8001bb78 <itable>
    80002b38:	00003097          	auipc	ra,0x3
    80002b3c:	7b6080e7          	jalr	1974(ra) # 800062ee <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b40:	00019497          	auipc	s1,0x19
    80002b44:	06048493          	addi	s1,s1,96 # 8001bba0 <itable+0x28>
    80002b48:	0001b997          	auipc	s3,0x1b
    80002b4c:	ae898993          	addi	s3,s3,-1304 # 8001d630 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b50:	00006917          	auipc	s2,0x6
    80002b54:	9e890913          	addi	s2,s2,-1560 # 80008538 <syscalls+0x170>
    80002b58:	85ca                	mv	a1,s2
    80002b5a:	8526                	mv	a0,s1
    80002b5c:	00001097          	auipc	ra,0x1
    80002b60:	e46080e7          	jalr	-442(ra) # 800039a2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b64:	08848493          	addi	s1,s1,136
    80002b68:	ff3498e3          	bne	s1,s3,80002b58 <iinit+0x3e>
}
    80002b6c:	70a2                	ld	ra,40(sp)
    80002b6e:	7402                	ld	s0,32(sp)
    80002b70:	64e2                	ld	s1,24(sp)
    80002b72:	6942                	ld	s2,16(sp)
    80002b74:	69a2                	ld	s3,8(sp)
    80002b76:	6145                	addi	sp,sp,48
    80002b78:	8082                	ret

0000000080002b7a <ialloc>:
{
    80002b7a:	715d                	addi	sp,sp,-80
    80002b7c:	e486                	sd	ra,72(sp)
    80002b7e:	e0a2                	sd	s0,64(sp)
    80002b80:	fc26                	sd	s1,56(sp)
    80002b82:	f84a                	sd	s2,48(sp)
    80002b84:	f44e                	sd	s3,40(sp)
    80002b86:	f052                	sd	s4,32(sp)
    80002b88:	ec56                	sd	s5,24(sp)
    80002b8a:	e85a                	sd	s6,16(sp)
    80002b8c:	e45e                	sd	s7,8(sp)
    80002b8e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b90:	00019717          	auipc	a4,0x19
    80002b94:	fd472703          	lw	a4,-44(a4) # 8001bb64 <sb+0xc>
    80002b98:	4785                	li	a5,1
    80002b9a:	04e7fa63          	bgeu	a5,a4,80002bee <ialloc+0x74>
    80002b9e:	8aaa                	mv	s5,a0
    80002ba0:	8bae                	mv	s7,a1
    80002ba2:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ba4:	00019a17          	auipc	s4,0x19
    80002ba8:	fb4a0a13          	addi	s4,s4,-76 # 8001bb58 <sb>
    80002bac:	00048b1b          	sext.w	s6,s1
    80002bb0:	0044d593          	srli	a1,s1,0x4
    80002bb4:	018a2783          	lw	a5,24(s4)
    80002bb8:	9dbd                	addw	a1,a1,a5
    80002bba:	8556                	mv	a0,s5
    80002bbc:	00000097          	auipc	ra,0x0
    80002bc0:	954080e7          	jalr	-1708(ra) # 80002510 <bread>
    80002bc4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bc6:	05850993          	addi	s3,a0,88
    80002bca:	00f4f793          	andi	a5,s1,15
    80002bce:	079a                	slli	a5,a5,0x6
    80002bd0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bd2:	00099783          	lh	a5,0(s3)
    80002bd6:	c785                	beqz	a5,80002bfe <ialloc+0x84>
    brelse(bp);
    80002bd8:	00000097          	auipc	ra,0x0
    80002bdc:	a68080e7          	jalr	-1432(ra) # 80002640 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002be0:	0485                	addi	s1,s1,1
    80002be2:	00ca2703          	lw	a4,12(s4)
    80002be6:	0004879b          	sext.w	a5,s1
    80002bea:	fce7e1e3          	bltu	a5,a4,80002bac <ialloc+0x32>
  panic("ialloc: no inodes");
    80002bee:	00006517          	auipc	a0,0x6
    80002bf2:	95250513          	addi	a0,a0,-1710 # 80008540 <syscalls+0x178>
    80002bf6:	00003097          	auipc	ra,0x3
    80002bfa:	1d2080e7          	jalr	466(ra) # 80005dc8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002bfe:	04000613          	li	a2,64
    80002c02:	4581                	li	a1,0
    80002c04:	854e                	mv	a0,s3
    80002c06:	ffffd097          	auipc	ra,0xffffd
    80002c0a:	572080e7          	jalr	1394(ra) # 80000178 <memset>
      dip->type = type;
    80002c0e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c12:	854a                	mv	a0,s2
    80002c14:	00001097          	auipc	ra,0x1
    80002c18:	ca8080e7          	jalr	-856(ra) # 800038bc <log_write>
      brelse(bp);
    80002c1c:	854a                	mv	a0,s2
    80002c1e:	00000097          	auipc	ra,0x0
    80002c22:	a22080e7          	jalr	-1502(ra) # 80002640 <brelse>
      return iget(dev, inum);
    80002c26:	85da                	mv	a1,s6
    80002c28:	8556                	mv	a0,s5
    80002c2a:	00000097          	auipc	ra,0x0
    80002c2e:	db4080e7          	jalr	-588(ra) # 800029de <iget>
}
    80002c32:	60a6                	ld	ra,72(sp)
    80002c34:	6406                	ld	s0,64(sp)
    80002c36:	74e2                	ld	s1,56(sp)
    80002c38:	7942                	ld	s2,48(sp)
    80002c3a:	79a2                	ld	s3,40(sp)
    80002c3c:	7a02                	ld	s4,32(sp)
    80002c3e:	6ae2                	ld	s5,24(sp)
    80002c40:	6b42                	ld	s6,16(sp)
    80002c42:	6ba2                	ld	s7,8(sp)
    80002c44:	6161                	addi	sp,sp,80
    80002c46:	8082                	ret

0000000080002c48 <iupdate>:
{
    80002c48:	1101                	addi	sp,sp,-32
    80002c4a:	ec06                	sd	ra,24(sp)
    80002c4c:	e822                	sd	s0,16(sp)
    80002c4e:	e426                	sd	s1,8(sp)
    80002c50:	e04a                	sd	s2,0(sp)
    80002c52:	1000                	addi	s0,sp,32
    80002c54:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c56:	415c                	lw	a5,4(a0)
    80002c58:	0047d79b          	srliw	a5,a5,0x4
    80002c5c:	00019597          	auipc	a1,0x19
    80002c60:	f145a583          	lw	a1,-236(a1) # 8001bb70 <sb+0x18>
    80002c64:	9dbd                	addw	a1,a1,a5
    80002c66:	4108                	lw	a0,0(a0)
    80002c68:	00000097          	auipc	ra,0x0
    80002c6c:	8a8080e7          	jalr	-1880(ra) # 80002510 <bread>
    80002c70:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c72:	05850793          	addi	a5,a0,88
    80002c76:	40c8                	lw	a0,4(s1)
    80002c78:	893d                	andi	a0,a0,15
    80002c7a:	051a                	slli	a0,a0,0x6
    80002c7c:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c7e:	04449703          	lh	a4,68(s1)
    80002c82:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c86:	04649703          	lh	a4,70(s1)
    80002c8a:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c8e:	04849703          	lh	a4,72(s1)
    80002c92:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c96:	04a49703          	lh	a4,74(s1)
    80002c9a:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c9e:	44f8                	lw	a4,76(s1)
    80002ca0:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ca2:	03400613          	li	a2,52
    80002ca6:	05048593          	addi	a1,s1,80
    80002caa:	0531                	addi	a0,a0,12
    80002cac:	ffffd097          	auipc	ra,0xffffd
    80002cb0:	52c080e7          	jalr	1324(ra) # 800001d8 <memmove>
  log_write(bp);
    80002cb4:	854a                	mv	a0,s2
    80002cb6:	00001097          	auipc	ra,0x1
    80002cba:	c06080e7          	jalr	-1018(ra) # 800038bc <log_write>
  brelse(bp);
    80002cbe:	854a                	mv	a0,s2
    80002cc0:	00000097          	auipc	ra,0x0
    80002cc4:	980080e7          	jalr	-1664(ra) # 80002640 <brelse>
}
    80002cc8:	60e2                	ld	ra,24(sp)
    80002cca:	6442                	ld	s0,16(sp)
    80002ccc:	64a2                	ld	s1,8(sp)
    80002cce:	6902                	ld	s2,0(sp)
    80002cd0:	6105                	addi	sp,sp,32
    80002cd2:	8082                	ret

0000000080002cd4 <idup>:
{
    80002cd4:	1101                	addi	sp,sp,-32
    80002cd6:	ec06                	sd	ra,24(sp)
    80002cd8:	e822                	sd	s0,16(sp)
    80002cda:	e426                	sd	s1,8(sp)
    80002cdc:	1000                	addi	s0,sp,32
    80002cde:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ce0:	00019517          	auipc	a0,0x19
    80002ce4:	e9850513          	addi	a0,a0,-360 # 8001bb78 <itable>
    80002ce8:	00003097          	auipc	ra,0x3
    80002cec:	696080e7          	jalr	1686(ra) # 8000637e <acquire>
  ip->ref++;
    80002cf0:	449c                	lw	a5,8(s1)
    80002cf2:	2785                	addiw	a5,a5,1
    80002cf4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cf6:	00019517          	auipc	a0,0x19
    80002cfa:	e8250513          	addi	a0,a0,-382 # 8001bb78 <itable>
    80002cfe:	00003097          	auipc	ra,0x3
    80002d02:	734080e7          	jalr	1844(ra) # 80006432 <release>
}
    80002d06:	8526                	mv	a0,s1
    80002d08:	60e2                	ld	ra,24(sp)
    80002d0a:	6442                	ld	s0,16(sp)
    80002d0c:	64a2                	ld	s1,8(sp)
    80002d0e:	6105                	addi	sp,sp,32
    80002d10:	8082                	ret

0000000080002d12 <ilock>:
{
    80002d12:	1101                	addi	sp,sp,-32
    80002d14:	ec06                	sd	ra,24(sp)
    80002d16:	e822                	sd	s0,16(sp)
    80002d18:	e426                	sd	s1,8(sp)
    80002d1a:	e04a                	sd	s2,0(sp)
    80002d1c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d1e:	c115                	beqz	a0,80002d42 <ilock+0x30>
    80002d20:	84aa                	mv	s1,a0
    80002d22:	451c                	lw	a5,8(a0)
    80002d24:	00f05f63          	blez	a5,80002d42 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d28:	0541                	addi	a0,a0,16
    80002d2a:	00001097          	auipc	ra,0x1
    80002d2e:	cb2080e7          	jalr	-846(ra) # 800039dc <acquiresleep>
  if(ip->valid == 0){
    80002d32:	40bc                	lw	a5,64(s1)
    80002d34:	cf99                	beqz	a5,80002d52 <ilock+0x40>
}
    80002d36:	60e2                	ld	ra,24(sp)
    80002d38:	6442                	ld	s0,16(sp)
    80002d3a:	64a2                	ld	s1,8(sp)
    80002d3c:	6902                	ld	s2,0(sp)
    80002d3e:	6105                	addi	sp,sp,32
    80002d40:	8082                	ret
    panic("ilock");
    80002d42:	00006517          	auipc	a0,0x6
    80002d46:	81650513          	addi	a0,a0,-2026 # 80008558 <syscalls+0x190>
    80002d4a:	00003097          	auipc	ra,0x3
    80002d4e:	07e080e7          	jalr	126(ra) # 80005dc8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d52:	40dc                	lw	a5,4(s1)
    80002d54:	0047d79b          	srliw	a5,a5,0x4
    80002d58:	00019597          	auipc	a1,0x19
    80002d5c:	e185a583          	lw	a1,-488(a1) # 8001bb70 <sb+0x18>
    80002d60:	9dbd                	addw	a1,a1,a5
    80002d62:	4088                	lw	a0,0(s1)
    80002d64:	fffff097          	auipc	ra,0xfffff
    80002d68:	7ac080e7          	jalr	1964(ra) # 80002510 <bread>
    80002d6c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d6e:	05850593          	addi	a1,a0,88
    80002d72:	40dc                	lw	a5,4(s1)
    80002d74:	8bbd                	andi	a5,a5,15
    80002d76:	079a                	slli	a5,a5,0x6
    80002d78:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d7a:	00059783          	lh	a5,0(a1)
    80002d7e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d82:	00259783          	lh	a5,2(a1)
    80002d86:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d8a:	00459783          	lh	a5,4(a1)
    80002d8e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d92:	00659783          	lh	a5,6(a1)
    80002d96:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d9a:	459c                	lw	a5,8(a1)
    80002d9c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d9e:	03400613          	li	a2,52
    80002da2:	05b1                	addi	a1,a1,12
    80002da4:	05048513          	addi	a0,s1,80
    80002da8:	ffffd097          	auipc	ra,0xffffd
    80002dac:	430080e7          	jalr	1072(ra) # 800001d8 <memmove>
    brelse(bp);
    80002db0:	854a                	mv	a0,s2
    80002db2:	00000097          	auipc	ra,0x0
    80002db6:	88e080e7          	jalr	-1906(ra) # 80002640 <brelse>
    ip->valid = 1;
    80002dba:	4785                	li	a5,1
    80002dbc:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002dbe:	04449783          	lh	a5,68(s1)
    80002dc2:	fbb5                	bnez	a5,80002d36 <ilock+0x24>
      panic("ilock: no type");
    80002dc4:	00005517          	auipc	a0,0x5
    80002dc8:	79c50513          	addi	a0,a0,1948 # 80008560 <syscalls+0x198>
    80002dcc:	00003097          	auipc	ra,0x3
    80002dd0:	ffc080e7          	jalr	-4(ra) # 80005dc8 <panic>

0000000080002dd4 <iunlock>:
{
    80002dd4:	1101                	addi	sp,sp,-32
    80002dd6:	ec06                	sd	ra,24(sp)
    80002dd8:	e822                	sd	s0,16(sp)
    80002dda:	e426                	sd	s1,8(sp)
    80002ddc:	e04a                	sd	s2,0(sp)
    80002dde:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002de0:	c905                	beqz	a0,80002e10 <iunlock+0x3c>
    80002de2:	84aa                	mv	s1,a0
    80002de4:	01050913          	addi	s2,a0,16
    80002de8:	854a                	mv	a0,s2
    80002dea:	00001097          	auipc	ra,0x1
    80002dee:	c8c080e7          	jalr	-884(ra) # 80003a76 <holdingsleep>
    80002df2:	cd19                	beqz	a0,80002e10 <iunlock+0x3c>
    80002df4:	449c                	lw	a5,8(s1)
    80002df6:	00f05d63          	blez	a5,80002e10 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002dfa:	854a                	mv	a0,s2
    80002dfc:	00001097          	auipc	ra,0x1
    80002e00:	c36080e7          	jalr	-970(ra) # 80003a32 <releasesleep>
}
    80002e04:	60e2                	ld	ra,24(sp)
    80002e06:	6442                	ld	s0,16(sp)
    80002e08:	64a2                	ld	s1,8(sp)
    80002e0a:	6902                	ld	s2,0(sp)
    80002e0c:	6105                	addi	sp,sp,32
    80002e0e:	8082                	ret
    panic("iunlock");
    80002e10:	00005517          	auipc	a0,0x5
    80002e14:	76050513          	addi	a0,a0,1888 # 80008570 <syscalls+0x1a8>
    80002e18:	00003097          	auipc	ra,0x3
    80002e1c:	fb0080e7          	jalr	-80(ra) # 80005dc8 <panic>

0000000080002e20 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e20:	7179                	addi	sp,sp,-48
    80002e22:	f406                	sd	ra,40(sp)
    80002e24:	f022                	sd	s0,32(sp)
    80002e26:	ec26                	sd	s1,24(sp)
    80002e28:	e84a                	sd	s2,16(sp)
    80002e2a:	e44e                	sd	s3,8(sp)
    80002e2c:	e052                	sd	s4,0(sp)
    80002e2e:	1800                	addi	s0,sp,48
    80002e30:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e32:	05050493          	addi	s1,a0,80
    80002e36:	08050913          	addi	s2,a0,128
    80002e3a:	a021                	j	80002e42 <itrunc+0x22>
    80002e3c:	0491                	addi	s1,s1,4
    80002e3e:	01248d63          	beq	s1,s2,80002e58 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e42:	408c                	lw	a1,0(s1)
    80002e44:	dde5                	beqz	a1,80002e3c <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e46:	0009a503          	lw	a0,0(s3)
    80002e4a:	00000097          	auipc	ra,0x0
    80002e4e:	90c080e7          	jalr	-1780(ra) # 80002756 <bfree>
      ip->addrs[i] = 0;
    80002e52:	0004a023          	sw	zero,0(s1)
    80002e56:	b7dd                	j	80002e3c <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e58:	0809a583          	lw	a1,128(s3)
    80002e5c:	e185                	bnez	a1,80002e7c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e5e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e62:	854e                	mv	a0,s3
    80002e64:	00000097          	auipc	ra,0x0
    80002e68:	de4080e7          	jalr	-540(ra) # 80002c48 <iupdate>
}
    80002e6c:	70a2                	ld	ra,40(sp)
    80002e6e:	7402                	ld	s0,32(sp)
    80002e70:	64e2                	ld	s1,24(sp)
    80002e72:	6942                	ld	s2,16(sp)
    80002e74:	69a2                	ld	s3,8(sp)
    80002e76:	6a02                	ld	s4,0(sp)
    80002e78:	6145                	addi	sp,sp,48
    80002e7a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e7c:	0009a503          	lw	a0,0(s3)
    80002e80:	fffff097          	auipc	ra,0xfffff
    80002e84:	690080e7          	jalr	1680(ra) # 80002510 <bread>
    80002e88:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e8a:	05850493          	addi	s1,a0,88
    80002e8e:	45850913          	addi	s2,a0,1112
    80002e92:	a811                	j	80002ea6 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e94:	0009a503          	lw	a0,0(s3)
    80002e98:	00000097          	auipc	ra,0x0
    80002e9c:	8be080e7          	jalr	-1858(ra) # 80002756 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002ea0:	0491                	addi	s1,s1,4
    80002ea2:	01248563          	beq	s1,s2,80002eac <itrunc+0x8c>
      if(a[j])
    80002ea6:	408c                	lw	a1,0(s1)
    80002ea8:	dde5                	beqz	a1,80002ea0 <itrunc+0x80>
    80002eaa:	b7ed                	j	80002e94 <itrunc+0x74>
    brelse(bp);
    80002eac:	8552                	mv	a0,s4
    80002eae:	fffff097          	auipc	ra,0xfffff
    80002eb2:	792080e7          	jalr	1938(ra) # 80002640 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002eb6:	0809a583          	lw	a1,128(s3)
    80002eba:	0009a503          	lw	a0,0(s3)
    80002ebe:	00000097          	auipc	ra,0x0
    80002ec2:	898080e7          	jalr	-1896(ra) # 80002756 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ec6:	0809a023          	sw	zero,128(s3)
    80002eca:	bf51                	j	80002e5e <itrunc+0x3e>

0000000080002ecc <iput>:
{
    80002ecc:	1101                	addi	sp,sp,-32
    80002ece:	ec06                	sd	ra,24(sp)
    80002ed0:	e822                	sd	s0,16(sp)
    80002ed2:	e426                	sd	s1,8(sp)
    80002ed4:	e04a                	sd	s2,0(sp)
    80002ed6:	1000                	addi	s0,sp,32
    80002ed8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002eda:	00019517          	auipc	a0,0x19
    80002ede:	c9e50513          	addi	a0,a0,-866 # 8001bb78 <itable>
    80002ee2:	00003097          	auipc	ra,0x3
    80002ee6:	49c080e7          	jalr	1180(ra) # 8000637e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002eea:	4498                	lw	a4,8(s1)
    80002eec:	4785                	li	a5,1
    80002eee:	02f70363          	beq	a4,a5,80002f14 <iput+0x48>
  ip->ref--;
    80002ef2:	449c                	lw	a5,8(s1)
    80002ef4:	37fd                	addiw	a5,a5,-1
    80002ef6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ef8:	00019517          	auipc	a0,0x19
    80002efc:	c8050513          	addi	a0,a0,-896 # 8001bb78 <itable>
    80002f00:	00003097          	auipc	ra,0x3
    80002f04:	532080e7          	jalr	1330(ra) # 80006432 <release>
}
    80002f08:	60e2                	ld	ra,24(sp)
    80002f0a:	6442                	ld	s0,16(sp)
    80002f0c:	64a2                	ld	s1,8(sp)
    80002f0e:	6902                	ld	s2,0(sp)
    80002f10:	6105                	addi	sp,sp,32
    80002f12:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f14:	40bc                	lw	a5,64(s1)
    80002f16:	dff1                	beqz	a5,80002ef2 <iput+0x26>
    80002f18:	04a49783          	lh	a5,74(s1)
    80002f1c:	fbf9                	bnez	a5,80002ef2 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f1e:	01048913          	addi	s2,s1,16
    80002f22:	854a                	mv	a0,s2
    80002f24:	00001097          	auipc	ra,0x1
    80002f28:	ab8080e7          	jalr	-1352(ra) # 800039dc <acquiresleep>
    release(&itable.lock);
    80002f2c:	00019517          	auipc	a0,0x19
    80002f30:	c4c50513          	addi	a0,a0,-948 # 8001bb78 <itable>
    80002f34:	00003097          	auipc	ra,0x3
    80002f38:	4fe080e7          	jalr	1278(ra) # 80006432 <release>
    itrunc(ip);
    80002f3c:	8526                	mv	a0,s1
    80002f3e:	00000097          	auipc	ra,0x0
    80002f42:	ee2080e7          	jalr	-286(ra) # 80002e20 <itrunc>
    ip->type = 0;
    80002f46:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f4a:	8526                	mv	a0,s1
    80002f4c:	00000097          	auipc	ra,0x0
    80002f50:	cfc080e7          	jalr	-772(ra) # 80002c48 <iupdate>
    ip->valid = 0;
    80002f54:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f58:	854a                	mv	a0,s2
    80002f5a:	00001097          	auipc	ra,0x1
    80002f5e:	ad8080e7          	jalr	-1320(ra) # 80003a32 <releasesleep>
    acquire(&itable.lock);
    80002f62:	00019517          	auipc	a0,0x19
    80002f66:	c1650513          	addi	a0,a0,-1002 # 8001bb78 <itable>
    80002f6a:	00003097          	auipc	ra,0x3
    80002f6e:	414080e7          	jalr	1044(ra) # 8000637e <acquire>
    80002f72:	b741                	j	80002ef2 <iput+0x26>

0000000080002f74 <iunlockput>:
{
    80002f74:	1101                	addi	sp,sp,-32
    80002f76:	ec06                	sd	ra,24(sp)
    80002f78:	e822                	sd	s0,16(sp)
    80002f7a:	e426                	sd	s1,8(sp)
    80002f7c:	1000                	addi	s0,sp,32
    80002f7e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f80:	00000097          	auipc	ra,0x0
    80002f84:	e54080e7          	jalr	-428(ra) # 80002dd4 <iunlock>
  iput(ip);
    80002f88:	8526                	mv	a0,s1
    80002f8a:	00000097          	auipc	ra,0x0
    80002f8e:	f42080e7          	jalr	-190(ra) # 80002ecc <iput>
}
    80002f92:	60e2                	ld	ra,24(sp)
    80002f94:	6442                	ld	s0,16(sp)
    80002f96:	64a2                	ld	s1,8(sp)
    80002f98:	6105                	addi	sp,sp,32
    80002f9a:	8082                	ret

0000000080002f9c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f9c:	1141                	addi	sp,sp,-16
    80002f9e:	e422                	sd	s0,8(sp)
    80002fa0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fa2:	411c                	lw	a5,0(a0)
    80002fa4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fa6:	415c                	lw	a5,4(a0)
    80002fa8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002faa:	04451783          	lh	a5,68(a0)
    80002fae:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fb2:	04a51783          	lh	a5,74(a0)
    80002fb6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fba:	04c56783          	lwu	a5,76(a0)
    80002fbe:	e99c                	sd	a5,16(a1)
}
    80002fc0:	6422                	ld	s0,8(sp)
    80002fc2:	0141                	addi	sp,sp,16
    80002fc4:	8082                	ret

0000000080002fc6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fc6:	457c                	lw	a5,76(a0)
    80002fc8:	0ed7e963          	bltu	a5,a3,800030ba <readi+0xf4>
{
    80002fcc:	7159                	addi	sp,sp,-112
    80002fce:	f486                	sd	ra,104(sp)
    80002fd0:	f0a2                	sd	s0,96(sp)
    80002fd2:	eca6                	sd	s1,88(sp)
    80002fd4:	e8ca                	sd	s2,80(sp)
    80002fd6:	e4ce                	sd	s3,72(sp)
    80002fd8:	e0d2                	sd	s4,64(sp)
    80002fda:	fc56                	sd	s5,56(sp)
    80002fdc:	f85a                	sd	s6,48(sp)
    80002fde:	f45e                	sd	s7,40(sp)
    80002fe0:	f062                	sd	s8,32(sp)
    80002fe2:	ec66                	sd	s9,24(sp)
    80002fe4:	e86a                	sd	s10,16(sp)
    80002fe6:	e46e                	sd	s11,8(sp)
    80002fe8:	1880                	addi	s0,sp,112
    80002fea:	8baa                	mv	s7,a0
    80002fec:	8c2e                	mv	s8,a1
    80002fee:	8ab2                	mv	s5,a2
    80002ff0:	84b6                	mv	s1,a3
    80002ff2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ff4:	9f35                	addw	a4,a4,a3
    return 0;
    80002ff6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ff8:	0ad76063          	bltu	a4,a3,80003098 <readi+0xd2>
  if(off + n > ip->size)
    80002ffc:	00e7f463          	bgeu	a5,a4,80003004 <readi+0x3e>
    n = ip->size - off;
    80003000:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003004:	0a0b0963          	beqz	s6,800030b6 <readi+0xf0>
    80003008:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000300a:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000300e:	5cfd                	li	s9,-1
    80003010:	a82d                	j	8000304a <readi+0x84>
    80003012:	020a1d93          	slli	s11,s4,0x20
    80003016:	020ddd93          	srli	s11,s11,0x20
    8000301a:	05890613          	addi	a2,s2,88
    8000301e:	86ee                	mv	a3,s11
    80003020:	963a                	add	a2,a2,a4
    80003022:	85d6                	mv	a1,s5
    80003024:	8562                	mv	a0,s8
    80003026:	fffff097          	auipc	ra,0xfffff
    8000302a:	88a080e7          	jalr	-1910(ra) # 800018b0 <either_copyout>
    8000302e:	05950d63          	beq	a0,s9,80003088 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003032:	854a                	mv	a0,s2
    80003034:	fffff097          	auipc	ra,0xfffff
    80003038:	60c080e7          	jalr	1548(ra) # 80002640 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000303c:	013a09bb          	addw	s3,s4,s3
    80003040:	009a04bb          	addw	s1,s4,s1
    80003044:	9aee                	add	s5,s5,s11
    80003046:	0569f763          	bgeu	s3,s6,80003094 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000304a:	000ba903          	lw	s2,0(s7)
    8000304e:	00a4d59b          	srliw	a1,s1,0xa
    80003052:	855e                	mv	a0,s7
    80003054:	00000097          	auipc	ra,0x0
    80003058:	8b0080e7          	jalr	-1872(ra) # 80002904 <bmap>
    8000305c:	0005059b          	sext.w	a1,a0
    80003060:	854a                	mv	a0,s2
    80003062:	fffff097          	auipc	ra,0xfffff
    80003066:	4ae080e7          	jalr	1198(ra) # 80002510 <bread>
    8000306a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000306c:	3ff4f713          	andi	a4,s1,1023
    80003070:	40ed07bb          	subw	a5,s10,a4
    80003074:	413b06bb          	subw	a3,s6,s3
    80003078:	8a3e                	mv	s4,a5
    8000307a:	2781                	sext.w	a5,a5
    8000307c:	0006861b          	sext.w	a2,a3
    80003080:	f8f679e3          	bgeu	a2,a5,80003012 <readi+0x4c>
    80003084:	8a36                	mv	s4,a3
    80003086:	b771                	j	80003012 <readi+0x4c>
      brelse(bp);
    80003088:	854a                	mv	a0,s2
    8000308a:	fffff097          	auipc	ra,0xfffff
    8000308e:	5b6080e7          	jalr	1462(ra) # 80002640 <brelse>
      tot = -1;
    80003092:	59fd                	li	s3,-1
  }
  return tot;
    80003094:	0009851b          	sext.w	a0,s3
}
    80003098:	70a6                	ld	ra,104(sp)
    8000309a:	7406                	ld	s0,96(sp)
    8000309c:	64e6                	ld	s1,88(sp)
    8000309e:	6946                	ld	s2,80(sp)
    800030a0:	69a6                	ld	s3,72(sp)
    800030a2:	6a06                	ld	s4,64(sp)
    800030a4:	7ae2                	ld	s5,56(sp)
    800030a6:	7b42                	ld	s6,48(sp)
    800030a8:	7ba2                	ld	s7,40(sp)
    800030aa:	7c02                	ld	s8,32(sp)
    800030ac:	6ce2                	ld	s9,24(sp)
    800030ae:	6d42                	ld	s10,16(sp)
    800030b0:	6da2                	ld	s11,8(sp)
    800030b2:	6165                	addi	sp,sp,112
    800030b4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030b6:	89da                	mv	s3,s6
    800030b8:	bff1                	j	80003094 <readi+0xce>
    return 0;
    800030ba:	4501                	li	a0,0
}
    800030bc:	8082                	ret

00000000800030be <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030be:	457c                	lw	a5,76(a0)
    800030c0:	10d7e863          	bltu	a5,a3,800031d0 <writei+0x112>
{
    800030c4:	7159                	addi	sp,sp,-112
    800030c6:	f486                	sd	ra,104(sp)
    800030c8:	f0a2                	sd	s0,96(sp)
    800030ca:	eca6                	sd	s1,88(sp)
    800030cc:	e8ca                	sd	s2,80(sp)
    800030ce:	e4ce                	sd	s3,72(sp)
    800030d0:	e0d2                	sd	s4,64(sp)
    800030d2:	fc56                	sd	s5,56(sp)
    800030d4:	f85a                	sd	s6,48(sp)
    800030d6:	f45e                	sd	s7,40(sp)
    800030d8:	f062                	sd	s8,32(sp)
    800030da:	ec66                	sd	s9,24(sp)
    800030dc:	e86a                	sd	s10,16(sp)
    800030de:	e46e                	sd	s11,8(sp)
    800030e0:	1880                	addi	s0,sp,112
    800030e2:	8b2a                	mv	s6,a0
    800030e4:	8c2e                	mv	s8,a1
    800030e6:	8ab2                	mv	s5,a2
    800030e8:	8936                	mv	s2,a3
    800030ea:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030ec:	00e687bb          	addw	a5,a3,a4
    800030f0:	0ed7e263          	bltu	a5,a3,800031d4 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030f4:	00043737          	lui	a4,0x43
    800030f8:	0ef76063          	bltu	a4,a5,800031d8 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030fc:	0c0b8863          	beqz	s7,800031cc <writei+0x10e>
    80003100:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003102:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003106:	5cfd                	li	s9,-1
    80003108:	a091                	j	8000314c <writei+0x8e>
    8000310a:	02099d93          	slli	s11,s3,0x20
    8000310e:	020ddd93          	srli	s11,s11,0x20
    80003112:	05848513          	addi	a0,s1,88
    80003116:	86ee                	mv	a3,s11
    80003118:	8656                	mv	a2,s5
    8000311a:	85e2                	mv	a1,s8
    8000311c:	953a                	add	a0,a0,a4
    8000311e:	ffffe097          	auipc	ra,0xffffe
    80003122:	7e8080e7          	jalr	2024(ra) # 80001906 <either_copyin>
    80003126:	07950263          	beq	a0,s9,8000318a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000312a:	8526                	mv	a0,s1
    8000312c:	00000097          	auipc	ra,0x0
    80003130:	790080e7          	jalr	1936(ra) # 800038bc <log_write>
    brelse(bp);
    80003134:	8526                	mv	a0,s1
    80003136:	fffff097          	auipc	ra,0xfffff
    8000313a:	50a080e7          	jalr	1290(ra) # 80002640 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000313e:	01498a3b          	addw	s4,s3,s4
    80003142:	0129893b          	addw	s2,s3,s2
    80003146:	9aee                	add	s5,s5,s11
    80003148:	057a7663          	bgeu	s4,s7,80003194 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000314c:	000b2483          	lw	s1,0(s6)
    80003150:	00a9559b          	srliw	a1,s2,0xa
    80003154:	855a                	mv	a0,s6
    80003156:	fffff097          	auipc	ra,0xfffff
    8000315a:	7ae080e7          	jalr	1966(ra) # 80002904 <bmap>
    8000315e:	0005059b          	sext.w	a1,a0
    80003162:	8526                	mv	a0,s1
    80003164:	fffff097          	auipc	ra,0xfffff
    80003168:	3ac080e7          	jalr	940(ra) # 80002510 <bread>
    8000316c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000316e:	3ff97713          	andi	a4,s2,1023
    80003172:	40ed07bb          	subw	a5,s10,a4
    80003176:	414b86bb          	subw	a3,s7,s4
    8000317a:	89be                	mv	s3,a5
    8000317c:	2781                	sext.w	a5,a5
    8000317e:	0006861b          	sext.w	a2,a3
    80003182:	f8f674e3          	bgeu	a2,a5,8000310a <writei+0x4c>
    80003186:	89b6                	mv	s3,a3
    80003188:	b749                	j	8000310a <writei+0x4c>
      brelse(bp);
    8000318a:	8526                	mv	a0,s1
    8000318c:	fffff097          	auipc	ra,0xfffff
    80003190:	4b4080e7          	jalr	1204(ra) # 80002640 <brelse>
  }

  if(off > ip->size)
    80003194:	04cb2783          	lw	a5,76(s6)
    80003198:	0127f463          	bgeu	a5,s2,800031a0 <writei+0xe2>
    ip->size = off;
    8000319c:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031a0:	855a                	mv	a0,s6
    800031a2:	00000097          	auipc	ra,0x0
    800031a6:	aa6080e7          	jalr	-1370(ra) # 80002c48 <iupdate>

  return tot;
    800031aa:	000a051b          	sext.w	a0,s4
}
    800031ae:	70a6                	ld	ra,104(sp)
    800031b0:	7406                	ld	s0,96(sp)
    800031b2:	64e6                	ld	s1,88(sp)
    800031b4:	6946                	ld	s2,80(sp)
    800031b6:	69a6                	ld	s3,72(sp)
    800031b8:	6a06                	ld	s4,64(sp)
    800031ba:	7ae2                	ld	s5,56(sp)
    800031bc:	7b42                	ld	s6,48(sp)
    800031be:	7ba2                	ld	s7,40(sp)
    800031c0:	7c02                	ld	s8,32(sp)
    800031c2:	6ce2                	ld	s9,24(sp)
    800031c4:	6d42                	ld	s10,16(sp)
    800031c6:	6da2                	ld	s11,8(sp)
    800031c8:	6165                	addi	sp,sp,112
    800031ca:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031cc:	8a5e                	mv	s4,s7
    800031ce:	bfc9                	j	800031a0 <writei+0xe2>
    return -1;
    800031d0:	557d                	li	a0,-1
}
    800031d2:	8082                	ret
    return -1;
    800031d4:	557d                	li	a0,-1
    800031d6:	bfe1                	j	800031ae <writei+0xf0>
    return -1;
    800031d8:	557d                	li	a0,-1
    800031da:	bfd1                	j	800031ae <writei+0xf0>

00000000800031dc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031dc:	1141                	addi	sp,sp,-16
    800031de:	e406                	sd	ra,8(sp)
    800031e0:	e022                	sd	s0,0(sp)
    800031e2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031e4:	4639                	li	a2,14
    800031e6:	ffffd097          	auipc	ra,0xffffd
    800031ea:	06a080e7          	jalr	106(ra) # 80000250 <strncmp>
}
    800031ee:	60a2                	ld	ra,8(sp)
    800031f0:	6402                	ld	s0,0(sp)
    800031f2:	0141                	addi	sp,sp,16
    800031f4:	8082                	ret

00000000800031f6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031f6:	7139                	addi	sp,sp,-64
    800031f8:	fc06                	sd	ra,56(sp)
    800031fa:	f822                	sd	s0,48(sp)
    800031fc:	f426                	sd	s1,40(sp)
    800031fe:	f04a                	sd	s2,32(sp)
    80003200:	ec4e                	sd	s3,24(sp)
    80003202:	e852                	sd	s4,16(sp)
    80003204:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003206:	04451703          	lh	a4,68(a0)
    8000320a:	4785                	li	a5,1
    8000320c:	00f71a63          	bne	a4,a5,80003220 <dirlookup+0x2a>
    80003210:	892a                	mv	s2,a0
    80003212:	89ae                	mv	s3,a1
    80003214:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003216:	457c                	lw	a5,76(a0)
    80003218:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000321a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000321c:	e79d                	bnez	a5,8000324a <dirlookup+0x54>
    8000321e:	a8a5                	j	80003296 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003220:	00005517          	auipc	a0,0x5
    80003224:	35850513          	addi	a0,a0,856 # 80008578 <syscalls+0x1b0>
    80003228:	00003097          	auipc	ra,0x3
    8000322c:	ba0080e7          	jalr	-1120(ra) # 80005dc8 <panic>
      panic("dirlookup read");
    80003230:	00005517          	auipc	a0,0x5
    80003234:	36050513          	addi	a0,a0,864 # 80008590 <syscalls+0x1c8>
    80003238:	00003097          	auipc	ra,0x3
    8000323c:	b90080e7          	jalr	-1136(ra) # 80005dc8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003240:	24c1                	addiw	s1,s1,16
    80003242:	04c92783          	lw	a5,76(s2)
    80003246:	04f4f763          	bgeu	s1,a5,80003294 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000324a:	4741                	li	a4,16
    8000324c:	86a6                	mv	a3,s1
    8000324e:	fc040613          	addi	a2,s0,-64
    80003252:	4581                	li	a1,0
    80003254:	854a                	mv	a0,s2
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	d70080e7          	jalr	-656(ra) # 80002fc6 <readi>
    8000325e:	47c1                	li	a5,16
    80003260:	fcf518e3          	bne	a0,a5,80003230 <dirlookup+0x3a>
    if(de.inum == 0)
    80003264:	fc045783          	lhu	a5,-64(s0)
    80003268:	dfe1                	beqz	a5,80003240 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000326a:	fc240593          	addi	a1,s0,-62
    8000326e:	854e                	mv	a0,s3
    80003270:	00000097          	auipc	ra,0x0
    80003274:	f6c080e7          	jalr	-148(ra) # 800031dc <namecmp>
    80003278:	f561                	bnez	a0,80003240 <dirlookup+0x4a>
      if(poff)
    8000327a:	000a0463          	beqz	s4,80003282 <dirlookup+0x8c>
        *poff = off;
    8000327e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003282:	fc045583          	lhu	a1,-64(s0)
    80003286:	00092503          	lw	a0,0(s2)
    8000328a:	fffff097          	auipc	ra,0xfffff
    8000328e:	754080e7          	jalr	1876(ra) # 800029de <iget>
    80003292:	a011                	j	80003296 <dirlookup+0xa0>
  return 0;
    80003294:	4501                	li	a0,0
}
    80003296:	70e2                	ld	ra,56(sp)
    80003298:	7442                	ld	s0,48(sp)
    8000329a:	74a2                	ld	s1,40(sp)
    8000329c:	7902                	ld	s2,32(sp)
    8000329e:	69e2                	ld	s3,24(sp)
    800032a0:	6a42                	ld	s4,16(sp)
    800032a2:	6121                	addi	sp,sp,64
    800032a4:	8082                	ret

00000000800032a6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032a6:	711d                	addi	sp,sp,-96
    800032a8:	ec86                	sd	ra,88(sp)
    800032aa:	e8a2                	sd	s0,80(sp)
    800032ac:	e4a6                	sd	s1,72(sp)
    800032ae:	e0ca                	sd	s2,64(sp)
    800032b0:	fc4e                	sd	s3,56(sp)
    800032b2:	f852                	sd	s4,48(sp)
    800032b4:	f456                	sd	s5,40(sp)
    800032b6:	f05a                	sd	s6,32(sp)
    800032b8:	ec5e                	sd	s7,24(sp)
    800032ba:	e862                	sd	s8,16(sp)
    800032bc:	e466                	sd	s9,8(sp)
    800032be:	1080                	addi	s0,sp,96
    800032c0:	84aa                	mv	s1,a0
    800032c2:	8b2e                	mv	s6,a1
    800032c4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032c6:	00054703          	lbu	a4,0(a0)
    800032ca:	02f00793          	li	a5,47
    800032ce:	02f70363          	beq	a4,a5,800032f4 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032d2:	ffffe097          	auipc	ra,0xffffe
    800032d6:	b76080e7          	jalr	-1162(ra) # 80000e48 <myproc>
    800032da:	15053503          	ld	a0,336(a0)
    800032de:	00000097          	auipc	ra,0x0
    800032e2:	9f6080e7          	jalr	-1546(ra) # 80002cd4 <idup>
    800032e6:	89aa                	mv	s3,a0
  while(*path == '/')
    800032e8:	02f00913          	li	s2,47
  len = path - s;
    800032ec:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800032ee:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032f0:	4c05                	li	s8,1
    800032f2:	a865                	j	800033aa <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800032f4:	4585                	li	a1,1
    800032f6:	4505                	li	a0,1
    800032f8:	fffff097          	auipc	ra,0xfffff
    800032fc:	6e6080e7          	jalr	1766(ra) # 800029de <iget>
    80003300:	89aa                	mv	s3,a0
    80003302:	b7dd                	j	800032e8 <namex+0x42>
      iunlockput(ip);
    80003304:	854e                	mv	a0,s3
    80003306:	00000097          	auipc	ra,0x0
    8000330a:	c6e080e7          	jalr	-914(ra) # 80002f74 <iunlockput>
      return 0;
    8000330e:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003310:	854e                	mv	a0,s3
    80003312:	60e6                	ld	ra,88(sp)
    80003314:	6446                	ld	s0,80(sp)
    80003316:	64a6                	ld	s1,72(sp)
    80003318:	6906                	ld	s2,64(sp)
    8000331a:	79e2                	ld	s3,56(sp)
    8000331c:	7a42                	ld	s4,48(sp)
    8000331e:	7aa2                	ld	s5,40(sp)
    80003320:	7b02                	ld	s6,32(sp)
    80003322:	6be2                	ld	s7,24(sp)
    80003324:	6c42                	ld	s8,16(sp)
    80003326:	6ca2                	ld	s9,8(sp)
    80003328:	6125                	addi	sp,sp,96
    8000332a:	8082                	ret
      iunlock(ip);
    8000332c:	854e                	mv	a0,s3
    8000332e:	00000097          	auipc	ra,0x0
    80003332:	aa6080e7          	jalr	-1370(ra) # 80002dd4 <iunlock>
      return ip;
    80003336:	bfe9                	j	80003310 <namex+0x6a>
      iunlockput(ip);
    80003338:	854e                	mv	a0,s3
    8000333a:	00000097          	auipc	ra,0x0
    8000333e:	c3a080e7          	jalr	-966(ra) # 80002f74 <iunlockput>
      return 0;
    80003342:	89d2                	mv	s3,s4
    80003344:	b7f1                	j	80003310 <namex+0x6a>
  len = path - s;
    80003346:	40b48633          	sub	a2,s1,a1
    8000334a:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000334e:	094cd463          	bge	s9,s4,800033d6 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003352:	4639                	li	a2,14
    80003354:	8556                	mv	a0,s5
    80003356:	ffffd097          	auipc	ra,0xffffd
    8000335a:	e82080e7          	jalr	-382(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000335e:	0004c783          	lbu	a5,0(s1)
    80003362:	01279763          	bne	a5,s2,80003370 <namex+0xca>
    path++;
    80003366:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003368:	0004c783          	lbu	a5,0(s1)
    8000336c:	ff278de3          	beq	a5,s2,80003366 <namex+0xc0>
    ilock(ip);
    80003370:	854e                	mv	a0,s3
    80003372:	00000097          	auipc	ra,0x0
    80003376:	9a0080e7          	jalr	-1632(ra) # 80002d12 <ilock>
    if(ip->type != T_DIR){
    8000337a:	04499783          	lh	a5,68(s3)
    8000337e:	f98793e3          	bne	a5,s8,80003304 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003382:	000b0563          	beqz	s6,8000338c <namex+0xe6>
    80003386:	0004c783          	lbu	a5,0(s1)
    8000338a:	d3cd                	beqz	a5,8000332c <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000338c:	865e                	mv	a2,s7
    8000338e:	85d6                	mv	a1,s5
    80003390:	854e                	mv	a0,s3
    80003392:	00000097          	auipc	ra,0x0
    80003396:	e64080e7          	jalr	-412(ra) # 800031f6 <dirlookup>
    8000339a:	8a2a                	mv	s4,a0
    8000339c:	dd51                	beqz	a0,80003338 <namex+0x92>
    iunlockput(ip);
    8000339e:	854e                	mv	a0,s3
    800033a0:	00000097          	auipc	ra,0x0
    800033a4:	bd4080e7          	jalr	-1068(ra) # 80002f74 <iunlockput>
    ip = next;
    800033a8:	89d2                	mv	s3,s4
  while(*path == '/')
    800033aa:	0004c783          	lbu	a5,0(s1)
    800033ae:	05279763          	bne	a5,s2,800033fc <namex+0x156>
    path++;
    800033b2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033b4:	0004c783          	lbu	a5,0(s1)
    800033b8:	ff278de3          	beq	a5,s2,800033b2 <namex+0x10c>
  if(*path == 0)
    800033bc:	c79d                	beqz	a5,800033ea <namex+0x144>
    path++;
    800033be:	85a6                	mv	a1,s1
  len = path - s;
    800033c0:	8a5e                	mv	s4,s7
    800033c2:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033c4:	01278963          	beq	a5,s2,800033d6 <namex+0x130>
    800033c8:	dfbd                	beqz	a5,80003346 <namex+0xa0>
    path++;
    800033ca:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800033cc:	0004c783          	lbu	a5,0(s1)
    800033d0:	ff279ce3          	bne	a5,s2,800033c8 <namex+0x122>
    800033d4:	bf8d                	j	80003346 <namex+0xa0>
    memmove(name, s, len);
    800033d6:	2601                	sext.w	a2,a2
    800033d8:	8556                	mv	a0,s5
    800033da:	ffffd097          	auipc	ra,0xffffd
    800033de:	dfe080e7          	jalr	-514(ra) # 800001d8 <memmove>
    name[len] = 0;
    800033e2:	9a56                	add	s4,s4,s5
    800033e4:	000a0023          	sb	zero,0(s4)
    800033e8:	bf9d                	j	8000335e <namex+0xb8>
  if(nameiparent){
    800033ea:	f20b03e3          	beqz	s6,80003310 <namex+0x6a>
    iput(ip);
    800033ee:	854e                	mv	a0,s3
    800033f0:	00000097          	auipc	ra,0x0
    800033f4:	adc080e7          	jalr	-1316(ra) # 80002ecc <iput>
    return 0;
    800033f8:	4981                	li	s3,0
    800033fa:	bf19                	j	80003310 <namex+0x6a>
  if(*path == 0)
    800033fc:	d7fd                	beqz	a5,800033ea <namex+0x144>
  while(*path != '/' && *path != 0)
    800033fe:	0004c783          	lbu	a5,0(s1)
    80003402:	85a6                	mv	a1,s1
    80003404:	b7d1                	j	800033c8 <namex+0x122>

0000000080003406 <dirlink>:
{
    80003406:	7139                	addi	sp,sp,-64
    80003408:	fc06                	sd	ra,56(sp)
    8000340a:	f822                	sd	s0,48(sp)
    8000340c:	f426                	sd	s1,40(sp)
    8000340e:	f04a                	sd	s2,32(sp)
    80003410:	ec4e                	sd	s3,24(sp)
    80003412:	e852                	sd	s4,16(sp)
    80003414:	0080                	addi	s0,sp,64
    80003416:	892a                	mv	s2,a0
    80003418:	8a2e                	mv	s4,a1
    8000341a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000341c:	4601                	li	a2,0
    8000341e:	00000097          	auipc	ra,0x0
    80003422:	dd8080e7          	jalr	-552(ra) # 800031f6 <dirlookup>
    80003426:	e93d                	bnez	a0,8000349c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003428:	04c92483          	lw	s1,76(s2)
    8000342c:	c49d                	beqz	s1,8000345a <dirlink+0x54>
    8000342e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003430:	4741                	li	a4,16
    80003432:	86a6                	mv	a3,s1
    80003434:	fc040613          	addi	a2,s0,-64
    80003438:	4581                	li	a1,0
    8000343a:	854a                	mv	a0,s2
    8000343c:	00000097          	auipc	ra,0x0
    80003440:	b8a080e7          	jalr	-1142(ra) # 80002fc6 <readi>
    80003444:	47c1                	li	a5,16
    80003446:	06f51163          	bne	a0,a5,800034a8 <dirlink+0xa2>
    if(de.inum == 0)
    8000344a:	fc045783          	lhu	a5,-64(s0)
    8000344e:	c791                	beqz	a5,8000345a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003450:	24c1                	addiw	s1,s1,16
    80003452:	04c92783          	lw	a5,76(s2)
    80003456:	fcf4ede3          	bltu	s1,a5,80003430 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000345a:	4639                	li	a2,14
    8000345c:	85d2                	mv	a1,s4
    8000345e:	fc240513          	addi	a0,s0,-62
    80003462:	ffffd097          	auipc	ra,0xffffd
    80003466:	e2a080e7          	jalr	-470(ra) # 8000028c <strncpy>
  de.inum = inum;
    8000346a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000346e:	4741                	li	a4,16
    80003470:	86a6                	mv	a3,s1
    80003472:	fc040613          	addi	a2,s0,-64
    80003476:	4581                	li	a1,0
    80003478:	854a                	mv	a0,s2
    8000347a:	00000097          	auipc	ra,0x0
    8000347e:	c44080e7          	jalr	-956(ra) # 800030be <writei>
    80003482:	872a                	mv	a4,a0
    80003484:	47c1                	li	a5,16
  return 0;
    80003486:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003488:	02f71863          	bne	a4,a5,800034b8 <dirlink+0xb2>
}
    8000348c:	70e2                	ld	ra,56(sp)
    8000348e:	7442                	ld	s0,48(sp)
    80003490:	74a2                	ld	s1,40(sp)
    80003492:	7902                	ld	s2,32(sp)
    80003494:	69e2                	ld	s3,24(sp)
    80003496:	6a42                	ld	s4,16(sp)
    80003498:	6121                	addi	sp,sp,64
    8000349a:	8082                	ret
    iput(ip);
    8000349c:	00000097          	auipc	ra,0x0
    800034a0:	a30080e7          	jalr	-1488(ra) # 80002ecc <iput>
    return -1;
    800034a4:	557d                	li	a0,-1
    800034a6:	b7dd                	j	8000348c <dirlink+0x86>
      panic("dirlink read");
    800034a8:	00005517          	auipc	a0,0x5
    800034ac:	0f850513          	addi	a0,a0,248 # 800085a0 <syscalls+0x1d8>
    800034b0:	00003097          	auipc	ra,0x3
    800034b4:	918080e7          	jalr	-1768(ra) # 80005dc8 <panic>
    panic("dirlink");
    800034b8:	00005517          	auipc	a0,0x5
    800034bc:	1f850513          	addi	a0,a0,504 # 800086b0 <syscalls+0x2e8>
    800034c0:	00003097          	auipc	ra,0x3
    800034c4:	908080e7          	jalr	-1784(ra) # 80005dc8 <panic>

00000000800034c8 <namei>:

struct inode*
namei(char *path)
{
    800034c8:	1101                	addi	sp,sp,-32
    800034ca:	ec06                	sd	ra,24(sp)
    800034cc:	e822                	sd	s0,16(sp)
    800034ce:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034d0:	fe040613          	addi	a2,s0,-32
    800034d4:	4581                	li	a1,0
    800034d6:	00000097          	auipc	ra,0x0
    800034da:	dd0080e7          	jalr	-560(ra) # 800032a6 <namex>
}
    800034de:	60e2                	ld	ra,24(sp)
    800034e0:	6442                	ld	s0,16(sp)
    800034e2:	6105                	addi	sp,sp,32
    800034e4:	8082                	ret

00000000800034e6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034e6:	1141                	addi	sp,sp,-16
    800034e8:	e406                	sd	ra,8(sp)
    800034ea:	e022                	sd	s0,0(sp)
    800034ec:	0800                	addi	s0,sp,16
    800034ee:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034f0:	4585                	li	a1,1
    800034f2:	00000097          	auipc	ra,0x0
    800034f6:	db4080e7          	jalr	-588(ra) # 800032a6 <namex>
}
    800034fa:	60a2                	ld	ra,8(sp)
    800034fc:	6402                	ld	s0,0(sp)
    800034fe:	0141                	addi	sp,sp,16
    80003500:	8082                	ret

0000000080003502 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003502:	1101                	addi	sp,sp,-32
    80003504:	ec06                	sd	ra,24(sp)
    80003506:	e822                	sd	s0,16(sp)
    80003508:	e426                	sd	s1,8(sp)
    8000350a:	e04a                	sd	s2,0(sp)
    8000350c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000350e:	0001a917          	auipc	s2,0x1a
    80003512:	11290913          	addi	s2,s2,274 # 8001d620 <log>
    80003516:	01892583          	lw	a1,24(s2)
    8000351a:	02892503          	lw	a0,40(s2)
    8000351e:	fffff097          	auipc	ra,0xfffff
    80003522:	ff2080e7          	jalr	-14(ra) # 80002510 <bread>
    80003526:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003528:	02c92683          	lw	a3,44(s2)
    8000352c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000352e:	02d05763          	blez	a3,8000355c <write_head+0x5a>
    80003532:	0001a797          	auipc	a5,0x1a
    80003536:	11e78793          	addi	a5,a5,286 # 8001d650 <log+0x30>
    8000353a:	05c50713          	addi	a4,a0,92
    8000353e:	36fd                	addiw	a3,a3,-1
    80003540:	1682                	slli	a3,a3,0x20
    80003542:	9281                	srli	a3,a3,0x20
    80003544:	068a                	slli	a3,a3,0x2
    80003546:	0001a617          	auipc	a2,0x1a
    8000354a:	10e60613          	addi	a2,a2,270 # 8001d654 <log+0x34>
    8000354e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003550:	4390                	lw	a2,0(a5)
    80003552:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003554:	0791                	addi	a5,a5,4
    80003556:	0711                	addi	a4,a4,4
    80003558:	fed79ce3          	bne	a5,a3,80003550 <write_head+0x4e>
  }
  bwrite(buf);
    8000355c:	8526                	mv	a0,s1
    8000355e:	fffff097          	auipc	ra,0xfffff
    80003562:	0a4080e7          	jalr	164(ra) # 80002602 <bwrite>
  brelse(buf);
    80003566:	8526                	mv	a0,s1
    80003568:	fffff097          	auipc	ra,0xfffff
    8000356c:	0d8080e7          	jalr	216(ra) # 80002640 <brelse>
}
    80003570:	60e2                	ld	ra,24(sp)
    80003572:	6442                	ld	s0,16(sp)
    80003574:	64a2                	ld	s1,8(sp)
    80003576:	6902                	ld	s2,0(sp)
    80003578:	6105                	addi	sp,sp,32
    8000357a:	8082                	ret

000000008000357c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000357c:	0001a797          	auipc	a5,0x1a
    80003580:	0d07a783          	lw	a5,208(a5) # 8001d64c <log+0x2c>
    80003584:	0af05d63          	blez	a5,8000363e <install_trans+0xc2>
{
    80003588:	7139                	addi	sp,sp,-64
    8000358a:	fc06                	sd	ra,56(sp)
    8000358c:	f822                	sd	s0,48(sp)
    8000358e:	f426                	sd	s1,40(sp)
    80003590:	f04a                	sd	s2,32(sp)
    80003592:	ec4e                	sd	s3,24(sp)
    80003594:	e852                	sd	s4,16(sp)
    80003596:	e456                	sd	s5,8(sp)
    80003598:	e05a                	sd	s6,0(sp)
    8000359a:	0080                	addi	s0,sp,64
    8000359c:	8b2a                	mv	s6,a0
    8000359e:	0001aa97          	auipc	s5,0x1a
    800035a2:	0b2a8a93          	addi	s5,s5,178 # 8001d650 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035a6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035a8:	0001a997          	auipc	s3,0x1a
    800035ac:	07898993          	addi	s3,s3,120 # 8001d620 <log>
    800035b0:	a035                	j	800035dc <install_trans+0x60>
      bunpin(dbuf);
    800035b2:	8526                	mv	a0,s1
    800035b4:	fffff097          	auipc	ra,0xfffff
    800035b8:	166080e7          	jalr	358(ra) # 8000271a <bunpin>
    brelse(lbuf);
    800035bc:	854a                	mv	a0,s2
    800035be:	fffff097          	auipc	ra,0xfffff
    800035c2:	082080e7          	jalr	130(ra) # 80002640 <brelse>
    brelse(dbuf);
    800035c6:	8526                	mv	a0,s1
    800035c8:	fffff097          	auipc	ra,0xfffff
    800035cc:	078080e7          	jalr	120(ra) # 80002640 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035d0:	2a05                	addiw	s4,s4,1
    800035d2:	0a91                	addi	s5,s5,4
    800035d4:	02c9a783          	lw	a5,44(s3)
    800035d8:	04fa5963          	bge	s4,a5,8000362a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035dc:	0189a583          	lw	a1,24(s3)
    800035e0:	014585bb          	addw	a1,a1,s4
    800035e4:	2585                	addiw	a1,a1,1
    800035e6:	0289a503          	lw	a0,40(s3)
    800035ea:	fffff097          	auipc	ra,0xfffff
    800035ee:	f26080e7          	jalr	-218(ra) # 80002510 <bread>
    800035f2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035f4:	000aa583          	lw	a1,0(s5)
    800035f8:	0289a503          	lw	a0,40(s3)
    800035fc:	fffff097          	auipc	ra,0xfffff
    80003600:	f14080e7          	jalr	-236(ra) # 80002510 <bread>
    80003604:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003606:	40000613          	li	a2,1024
    8000360a:	05890593          	addi	a1,s2,88
    8000360e:	05850513          	addi	a0,a0,88
    80003612:	ffffd097          	auipc	ra,0xffffd
    80003616:	bc6080e7          	jalr	-1082(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000361a:	8526                	mv	a0,s1
    8000361c:	fffff097          	auipc	ra,0xfffff
    80003620:	fe6080e7          	jalr	-26(ra) # 80002602 <bwrite>
    if(recovering == 0)
    80003624:	f80b1ce3          	bnez	s6,800035bc <install_trans+0x40>
    80003628:	b769                	j	800035b2 <install_trans+0x36>
}
    8000362a:	70e2                	ld	ra,56(sp)
    8000362c:	7442                	ld	s0,48(sp)
    8000362e:	74a2                	ld	s1,40(sp)
    80003630:	7902                	ld	s2,32(sp)
    80003632:	69e2                	ld	s3,24(sp)
    80003634:	6a42                	ld	s4,16(sp)
    80003636:	6aa2                	ld	s5,8(sp)
    80003638:	6b02                	ld	s6,0(sp)
    8000363a:	6121                	addi	sp,sp,64
    8000363c:	8082                	ret
    8000363e:	8082                	ret

0000000080003640 <initlog>:
{
    80003640:	7179                	addi	sp,sp,-48
    80003642:	f406                	sd	ra,40(sp)
    80003644:	f022                	sd	s0,32(sp)
    80003646:	ec26                	sd	s1,24(sp)
    80003648:	e84a                	sd	s2,16(sp)
    8000364a:	e44e                	sd	s3,8(sp)
    8000364c:	1800                	addi	s0,sp,48
    8000364e:	892a                	mv	s2,a0
    80003650:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003652:	0001a497          	auipc	s1,0x1a
    80003656:	fce48493          	addi	s1,s1,-50 # 8001d620 <log>
    8000365a:	00005597          	auipc	a1,0x5
    8000365e:	f5658593          	addi	a1,a1,-170 # 800085b0 <syscalls+0x1e8>
    80003662:	8526                	mv	a0,s1
    80003664:	00003097          	auipc	ra,0x3
    80003668:	c8a080e7          	jalr	-886(ra) # 800062ee <initlock>
  log.start = sb->logstart;
    8000366c:	0149a583          	lw	a1,20(s3)
    80003670:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003672:	0109a783          	lw	a5,16(s3)
    80003676:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003678:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000367c:	854a                	mv	a0,s2
    8000367e:	fffff097          	auipc	ra,0xfffff
    80003682:	e92080e7          	jalr	-366(ra) # 80002510 <bread>
  log.lh.n = lh->n;
    80003686:	4d3c                	lw	a5,88(a0)
    80003688:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000368a:	02f05563          	blez	a5,800036b4 <initlog+0x74>
    8000368e:	05c50713          	addi	a4,a0,92
    80003692:	0001a697          	auipc	a3,0x1a
    80003696:	fbe68693          	addi	a3,a3,-66 # 8001d650 <log+0x30>
    8000369a:	37fd                	addiw	a5,a5,-1
    8000369c:	1782                	slli	a5,a5,0x20
    8000369e:	9381                	srli	a5,a5,0x20
    800036a0:	078a                	slli	a5,a5,0x2
    800036a2:	06050613          	addi	a2,a0,96
    800036a6:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800036a8:	4310                	lw	a2,0(a4)
    800036aa:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800036ac:	0711                	addi	a4,a4,4
    800036ae:	0691                	addi	a3,a3,4
    800036b0:	fef71ce3          	bne	a4,a5,800036a8 <initlog+0x68>
  brelse(buf);
    800036b4:	fffff097          	auipc	ra,0xfffff
    800036b8:	f8c080e7          	jalr	-116(ra) # 80002640 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036bc:	4505                	li	a0,1
    800036be:	00000097          	auipc	ra,0x0
    800036c2:	ebe080e7          	jalr	-322(ra) # 8000357c <install_trans>
  log.lh.n = 0;
    800036c6:	0001a797          	auipc	a5,0x1a
    800036ca:	f807a323          	sw	zero,-122(a5) # 8001d64c <log+0x2c>
  write_head(); // clear the log
    800036ce:	00000097          	auipc	ra,0x0
    800036d2:	e34080e7          	jalr	-460(ra) # 80003502 <write_head>
}
    800036d6:	70a2                	ld	ra,40(sp)
    800036d8:	7402                	ld	s0,32(sp)
    800036da:	64e2                	ld	s1,24(sp)
    800036dc:	6942                	ld	s2,16(sp)
    800036de:	69a2                	ld	s3,8(sp)
    800036e0:	6145                	addi	sp,sp,48
    800036e2:	8082                	ret

00000000800036e4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036e4:	1101                	addi	sp,sp,-32
    800036e6:	ec06                	sd	ra,24(sp)
    800036e8:	e822                	sd	s0,16(sp)
    800036ea:	e426                	sd	s1,8(sp)
    800036ec:	e04a                	sd	s2,0(sp)
    800036ee:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036f0:	0001a517          	auipc	a0,0x1a
    800036f4:	f3050513          	addi	a0,a0,-208 # 8001d620 <log>
    800036f8:	00003097          	auipc	ra,0x3
    800036fc:	c86080e7          	jalr	-890(ra) # 8000637e <acquire>
  while(1){
    if(log.committing){
    80003700:	0001a497          	auipc	s1,0x1a
    80003704:	f2048493          	addi	s1,s1,-224 # 8001d620 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003708:	4979                	li	s2,30
    8000370a:	a039                	j	80003718 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000370c:	85a6                	mv	a1,s1
    8000370e:	8526                	mv	a0,s1
    80003710:	ffffe097          	auipc	ra,0xffffe
    80003714:	dfc080e7          	jalr	-516(ra) # 8000150c <sleep>
    if(log.committing){
    80003718:	50dc                	lw	a5,36(s1)
    8000371a:	fbed                	bnez	a5,8000370c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000371c:	509c                	lw	a5,32(s1)
    8000371e:	0017871b          	addiw	a4,a5,1
    80003722:	0007069b          	sext.w	a3,a4
    80003726:	0027179b          	slliw	a5,a4,0x2
    8000372a:	9fb9                	addw	a5,a5,a4
    8000372c:	0017979b          	slliw	a5,a5,0x1
    80003730:	54d8                	lw	a4,44(s1)
    80003732:	9fb9                	addw	a5,a5,a4
    80003734:	00f95963          	bge	s2,a5,80003746 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003738:	85a6                	mv	a1,s1
    8000373a:	8526                	mv	a0,s1
    8000373c:	ffffe097          	auipc	ra,0xffffe
    80003740:	dd0080e7          	jalr	-560(ra) # 8000150c <sleep>
    80003744:	bfd1                	j	80003718 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003746:	0001a517          	auipc	a0,0x1a
    8000374a:	eda50513          	addi	a0,a0,-294 # 8001d620 <log>
    8000374e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003750:	00003097          	auipc	ra,0x3
    80003754:	ce2080e7          	jalr	-798(ra) # 80006432 <release>
      break;
    }
  }
}
    80003758:	60e2                	ld	ra,24(sp)
    8000375a:	6442                	ld	s0,16(sp)
    8000375c:	64a2                	ld	s1,8(sp)
    8000375e:	6902                	ld	s2,0(sp)
    80003760:	6105                	addi	sp,sp,32
    80003762:	8082                	ret

0000000080003764 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003764:	7139                	addi	sp,sp,-64
    80003766:	fc06                	sd	ra,56(sp)
    80003768:	f822                	sd	s0,48(sp)
    8000376a:	f426                	sd	s1,40(sp)
    8000376c:	f04a                	sd	s2,32(sp)
    8000376e:	ec4e                	sd	s3,24(sp)
    80003770:	e852                	sd	s4,16(sp)
    80003772:	e456                	sd	s5,8(sp)
    80003774:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003776:	0001a497          	auipc	s1,0x1a
    8000377a:	eaa48493          	addi	s1,s1,-342 # 8001d620 <log>
    8000377e:	8526                	mv	a0,s1
    80003780:	00003097          	auipc	ra,0x3
    80003784:	bfe080e7          	jalr	-1026(ra) # 8000637e <acquire>
  log.outstanding -= 1;
    80003788:	509c                	lw	a5,32(s1)
    8000378a:	37fd                	addiw	a5,a5,-1
    8000378c:	0007891b          	sext.w	s2,a5
    80003790:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003792:	50dc                	lw	a5,36(s1)
    80003794:	efb9                	bnez	a5,800037f2 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003796:	06091663          	bnez	s2,80003802 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000379a:	0001a497          	auipc	s1,0x1a
    8000379e:	e8648493          	addi	s1,s1,-378 # 8001d620 <log>
    800037a2:	4785                	li	a5,1
    800037a4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037a6:	8526                	mv	a0,s1
    800037a8:	00003097          	auipc	ra,0x3
    800037ac:	c8a080e7          	jalr	-886(ra) # 80006432 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037b0:	54dc                	lw	a5,44(s1)
    800037b2:	06f04763          	bgtz	a5,80003820 <end_op+0xbc>
    acquire(&log.lock);
    800037b6:	0001a497          	auipc	s1,0x1a
    800037ba:	e6a48493          	addi	s1,s1,-406 # 8001d620 <log>
    800037be:	8526                	mv	a0,s1
    800037c0:	00003097          	auipc	ra,0x3
    800037c4:	bbe080e7          	jalr	-1090(ra) # 8000637e <acquire>
    log.committing = 0;
    800037c8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037cc:	8526                	mv	a0,s1
    800037ce:	ffffe097          	auipc	ra,0xffffe
    800037d2:	eca080e7          	jalr	-310(ra) # 80001698 <wakeup>
    release(&log.lock);
    800037d6:	8526                	mv	a0,s1
    800037d8:	00003097          	auipc	ra,0x3
    800037dc:	c5a080e7          	jalr	-934(ra) # 80006432 <release>
}
    800037e0:	70e2                	ld	ra,56(sp)
    800037e2:	7442                	ld	s0,48(sp)
    800037e4:	74a2                	ld	s1,40(sp)
    800037e6:	7902                	ld	s2,32(sp)
    800037e8:	69e2                	ld	s3,24(sp)
    800037ea:	6a42                	ld	s4,16(sp)
    800037ec:	6aa2                	ld	s5,8(sp)
    800037ee:	6121                	addi	sp,sp,64
    800037f0:	8082                	ret
    panic("log.committing");
    800037f2:	00005517          	auipc	a0,0x5
    800037f6:	dc650513          	addi	a0,a0,-570 # 800085b8 <syscalls+0x1f0>
    800037fa:	00002097          	auipc	ra,0x2
    800037fe:	5ce080e7          	jalr	1486(ra) # 80005dc8 <panic>
    wakeup(&log);
    80003802:	0001a497          	auipc	s1,0x1a
    80003806:	e1e48493          	addi	s1,s1,-482 # 8001d620 <log>
    8000380a:	8526                	mv	a0,s1
    8000380c:	ffffe097          	auipc	ra,0xffffe
    80003810:	e8c080e7          	jalr	-372(ra) # 80001698 <wakeup>
  release(&log.lock);
    80003814:	8526                	mv	a0,s1
    80003816:	00003097          	auipc	ra,0x3
    8000381a:	c1c080e7          	jalr	-996(ra) # 80006432 <release>
  if(do_commit){
    8000381e:	b7c9                	j	800037e0 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003820:	0001aa97          	auipc	s5,0x1a
    80003824:	e30a8a93          	addi	s5,s5,-464 # 8001d650 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003828:	0001aa17          	auipc	s4,0x1a
    8000382c:	df8a0a13          	addi	s4,s4,-520 # 8001d620 <log>
    80003830:	018a2583          	lw	a1,24(s4)
    80003834:	012585bb          	addw	a1,a1,s2
    80003838:	2585                	addiw	a1,a1,1
    8000383a:	028a2503          	lw	a0,40(s4)
    8000383e:	fffff097          	auipc	ra,0xfffff
    80003842:	cd2080e7          	jalr	-814(ra) # 80002510 <bread>
    80003846:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003848:	000aa583          	lw	a1,0(s5)
    8000384c:	028a2503          	lw	a0,40(s4)
    80003850:	fffff097          	auipc	ra,0xfffff
    80003854:	cc0080e7          	jalr	-832(ra) # 80002510 <bread>
    80003858:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000385a:	40000613          	li	a2,1024
    8000385e:	05850593          	addi	a1,a0,88
    80003862:	05848513          	addi	a0,s1,88
    80003866:	ffffd097          	auipc	ra,0xffffd
    8000386a:	972080e7          	jalr	-1678(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000386e:	8526                	mv	a0,s1
    80003870:	fffff097          	auipc	ra,0xfffff
    80003874:	d92080e7          	jalr	-622(ra) # 80002602 <bwrite>
    brelse(from);
    80003878:	854e                	mv	a0,s3
    8000387a:	fffff097          	auipc	ra,0xfffff
    8000387e:	dc6080e7          	jalr	-570(ra) # 80002640 <brelse>
    brelse(to);
    80003882:	8526                	mv	a0,s1
    80003884:	fffff097          	auipc	ra,0xfffff
    80003888:	dbc080e7          	jalr	-580(ra) # 80002640 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000388c:	2905                	addiw	s2,s2,1
    8000388e:	0a91                	addi	s5,s5,4
    80003890:	02ca2783          	lw	a5,44(s4)
    80003894:	f8f94ee3          	blt	s2,a5,80003830 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003898:	00000097          	auipc	ra,0x0
    8000389c:	c6a080e7          	jalr	-918(ra) # 80003502 <write_head>
    install_trans(0); // Now install writes to home locations
    800038a0:	4501                	li	a0,0
    800038a2:	00000097          	auipc	ra,0x0
    800038a6:	cda080e7          	jalr	-806(ra) # 8000357c <install_trans>
    log.lh.n = 0;
    800038aa:	0001a797          	auipc	a5,0x1a
    800038ae:	da07a123          	sw	zero,-606(a5) # 8001d64c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038b2:	00000097          	auipc	ra,0x0
    800038b6:	c50080e7          	jalr	-944(ra) # 80003502 <write_head>
    800038ba:	bdf5                	j	800037b6 <end_op+0x52>

00000000800038bc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038bc:	1101                	addi	sp,sp,-32
    800038be:	ec06                	sd	ra,24(sp)
    800038c0:	e822                	sd	s0,16(sp)
    800038c2:	e426                	sd	s1,8(sp)
    800038c4:	e04a                	sd	s2,0(sp)
    800038c6:	1000                	addi	s0,sp,32
    800038c8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038ca:	0001a917          	auipc	s2,0x1a
    800038ce:	d5690913          	addi	s2,s2,-682 # 8001d620 <log>
    800038d2:	854a                	mv	a0,s2
    800038d4:	00003097          	auipc	ra,0x3
    800038d8:	aaa080e7          	jalr	-1366(ra) # 8000637e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038dc:	02c92603          	lw	a2,44(s2)
    800038e0:	47f5                	li	a5,29
    800038e2:	06c7c563          	blt	a5,a2,8000394c <log_write+0x90>
    800038e6:	0001a797          	auipc	a5,0x1a
    800038ea:	d567a783          	lw	a5,-682(a5) # 8001d63c <log+0x1c>
    800038ee:	37fd                	addiw	a5,a5,-1
    800038f0:	04f65e63          	bge	a2,a5,8000394c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038f4:	0001a797          	auipc	a5,0x1a
    800038f8:	d4c7a783          	lw	a5,-692(a5) # 8001d640 <log+0x20>
    800038fc:	06f05063          	blez	a5,8000395c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003900:	4781                	li	a5,0
    80003902:	06c05563          	blez	a2,8000396c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003906:	44cc                	lw	a1,12(s1)
    80003908:	0001a717          	auipc	a4,0x1a
    8000390c:	d4870713          	addi	a4,a4,-696 # 8001d650 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003910:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003912:	4314                	lw	a3,0(a4)
    80003914:	04b68c63          	beq	a3,a1,8000396c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003918:	2785                	addiw	a5,a5,1
    8000391a:	0711                	addi	a4,a4,4
    8000391c:	fef61be3          	bne	a2,a5,80003912 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003920:	0621                	addi	a2,a2,8
    80003922:	060a                	slli	a2,a2,0x2
    80003924:	0001a797          	auipc	a5,0x1a
    80003928:	cfc78793          	addi	a5,a5,-772 # 8001d620 <log>
    8000392c:	963e                	add	a2,a2,a5
    8000392e:	44dc                	lw	a5,12(s1)
    80003930:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003932:	8526                	mv	a0,s1
    80003934:	fffff097          	auipc	ra,0xfffff
    80003938:	daa080e7          	jalr	-598(ra) # 800026de <bpin>
    log.lh.n++;
    8000393c:	0001a717          	auipc	a4,0x1a
    80003940:	ce470713          	addi	a4,a4,-796 # 8001d620 <log>
    80003944:	575c                	lw	a5,44(a4)
    80003946:	2785                	addiw	a5,a5,1
    80003948:	d75c                	sw	a5,44(a4)
    8000394a:	a835                	j	80003986 <log_write+0xca>
    panic("too big a transaction");
    8000394c:	00005517          	auipc	a0,0x5
    80003950:	c7c50513          	addi	a0,a0,-900 # 800085c8 <syscalls+0x200>
    80003954:	00002097          	auipc	ra,0x2
    80003958:	474080e7          	jalr	1140(ra) # 80005dc8 <panic>
    panic("log_write outside of trans");
    8000395c:	00005517          	auipc	a0,0x5
    80003960:	c8450513          	addi	a0,a0,-892 # 800085e0 <syscalls+0x218>
    80003964:	00002097          	auipc	ra,0x2
    80003968:	464080e7          	jalr	1124(ra) # 80005dc8 <panic>
  log.lh.block[i] = b->blockno;
    8000396c:	00878713          	addi	a4,a5,8
    80003970:	00271693          	slli	a3,a4,0x2
    80003974:	0001a717          	auipc	a4,0x1a
    80003978:	cac70713          	addi	a4,a4,-852 # 8001d620 <log>
    8000397c:	9736                	add	a4,a4,a3
    8000397e:	44d4                	lw	a3,12(s1)
    80003980:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003982:	faf608e3          	beq	a2,a5,80003932 <log_write+0x76>
  }
  release(&log.lock);
    80003986:	0001a517          	auipc	a0,0x1a
    8000398a:	c9a50513          	addi	a0,a0,-870 # 8001d620 <log>
    8000398e:	00003097          	auipc	ra,0x3
    80003992:	aa4080e7          	jalr	-1372(ra) # 80006432 <release>
}
    80003996:	60e2                	ld	ra,24(sp)
    80003998:	6442                	ld	s0,16(sp)
    8000399a:	64a2                	ld	s1,8(sp)
    8000399c:	6902                	ld	s2,0(sp)
    8000399e:	6105                	addi	sp,sp,32
    800039a0:	8082                	ret

00000000800039a2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039a2:	1101                	addi	sp,sp,-32
    800039a4:	ec06                	sd	ra,24(sp)
    800039a6:	e822                	sd	s0,16(sp)
    800039a8:	e426                	sd	s1,8(sp)
    800039aa:	e04a                	sd	s2,0(sp)
    800039ac:	1000                	addi	s0,sp,32
    800039ae:	84aa                	mv	s1,a0
    800039b0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039b2:	00005597          	auipc	a1,0x5
    800039b6:	c4e58593          	addi	a1,a1,-946 # 80008600 <syscalls+0x238>
    800039ba:	0521                	addi	a0,a0,8
    800039bc:	00003097          	auipc	ra,0x3
    800039c0:	932080e7          	jalr	-1742(ra) # 800062ee <initlock>
  lk->name = name;
    800039c4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039c8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039cc:	0204a423          	sw	zero,40(s1)
}
    800039d0:	60e2                	ld	ra,24(sp)
    800039d2:	6442                	ld	s0,16(sp)
    800039d4:	64a2                	ld	s1,8(sp)
    800039d6:	6902                	ld	s2,0(sp)
    800039d8:	6105                	addi	sp,sp,32
    800039da:	8082                	ret

00000000800039dc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039dc:	1101                	addi	sp,sp,-32
    800039de:	ec06                	sd	ra,24(sp)
    800039e0:	e822                	sd	s0,16(sp)
    800039e2:	e426                	sd	s1,8(sp)
    800039e4:	e04a                	sd	s2,0(sp)
    800039e6:	1000                	addi	s0,sp,32
    800039e8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039ea:	00850913          	addi	s2,a0,8
    800039ee:	854a                	mv	a0,s2
    800039f0:	00003097          	auipc	ra,0x3
    800039f4:	98e080e7          	jalr	-1650(ra) # 8000637e <acquire>
  while (lk->locked) {
    800039f8:	409c                	lw	a5,0(s1)
    800039fa:	cb89                	beqz	a5,80003a0c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039fc:	85ca                	mv	a1,s2
    800039fe:	8526                	mv	a0,s1
    80003a00:	ffffe097          	auipc	ra,0xffffe
    80003a04:	b0c080e7          	jalr	-1268(ra) # 8000150c <sleep>
  while (lk->locked) {
    80003a08:	409c                	lw	a5,0(s1)
    80003a0a:	fbed                	bnez	a5,800039fc <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a0c:	4785                	li	a5,1
    80003a0e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a10:	ffffd097          	auipc	ra,0xffffd
    80003a14:	438080e7          	jalr	1080(ra) # 80000e48 <myproc>
    80003a18:	591c                	lw	a5,48(a0)
    80003a1a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a1c:	854a                	mv	a0,s2
    80003a1e:	00003097          	auipc	ra,0x3
    80003a22:	a14080e7          	jalr	-1516(ra) # 80006432 <release>
}
    80003a26:	60e2                	ld	ra,24(sp)
    80003a28:	6442                	ld	s0,16(sp)
    80003a2a:	64a2                	ld	s1,8(sp)
    80003a2c:	6902                	ld	s2,0(sp)
    80003a2e:	6105                	addi	sp,sp,32
    80003a30:	8082                	ret

0000000080003a32 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a32:	1101                	addi	sp,sp,-32
    80003a34:	ec06                	sd	ra,24(sp)
    80003a36:	e822                	sd	s0,16(sp)
    80003a38:	e426                	sd	s1,8(sp)
    80003a3a:	e04a                	sd	s2,0(sp)
    80003a3c:	1000                	addi	s0,sp,32
    80003a3e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a40:	00850913          	addi	s2,a0,8
    80003a44:	854a                	mv	a0,s2
    80003a46:	00003097          	auipc	ra,0x3
    80003a4a:	938080e7          	jalr	-1736(ra) # 8000637e <acquire>
  lk->locked = 0;
    80003a4e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a52:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a56:	8526                	mv	a0,s1
    80003a58:	ffffe097          	auipc	ra,0xffffe
    80003a5c:	c40080e7          	jalr	-960(ra) # 80001698 <wakeup>
  release(&lk->lk);
    80003a60:	854a                	mv	a0,s2
    80003a62:	00003097          	auipc	ra,0x3
    80003a66:	9d0080e7          	jalr	-1584(ra) # 80006432 <release>
}
    80003a6a:	60e2                	ld	ra,24(sp)
    80003a6c:	6442                	ld	s0,16(sp)
    80003a6e:	64a2                	ld	s1,8(sp)
    80003a70:	6902                	ld	s2,0(sp)
    80003a72:	6105                	addi	sp,sp,32
    80003a74:	8082                	ret

0000000080003a76 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a76:	7179                	addi	sp,sp,-48
    80003a78:	f406                	sd	ra,40(sp)
    80003a7a:	f022                	sd	s0,32(sp)
    80003a7c:	ec26                	sd	s1,24(sp)
    80003a7e:	e84a                	sd	s2,16(sp)
    80003a80:	e44e                	sd	s3,8(sp)
    80003a82:	1800                	addi	s0,sp,48
    80003a84:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a86:	00850913          	addi	s2,a0,8
    80003a8a:	854a                	mv	a0,s2
    80003a8c:	00003097          	auipc	ra,0x3
    80003a90:	8f2080e7          	jalr	-1806(ra) # 8000637e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a94:	409c                	lw	a5,0(s1)
    80003a96:	ef99                	bnez	a5,80003ab4 <holdingsleep+0x3e>
    80003a98:	4481                	li	s1,0
  release(&lk->lk);
    80003a9a:	854a                	mv	a0,s2
    80003a9c:	00003097          	auipc	ra,0x3
    80003aa0:	996080e7          	jalr	-1642(ra) # 80006432 <release>
  return r;
}
    80003aa4:	8526                	mv	a0,s1
    80003aa6:	70a2                	ld	ra,40(sp)
    80003aa8:	7402                	ld	s0,32(sp)
    80003aaa:	64e2                	ld	s1,24(sp)
    80003aac:	6942                	ld	s2,16(sp)
    80003aae:	69a2                	ld	s3,8(sp)
    80003ab0:	6145                	addi	sp,sp,48
    80003ab2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ab4:	0284a983          	lw	s3,40(s1)
    80003ab8:	ffffd097          	auipc	ra,0xffffd
    80003abc:	390080e7          	jalr	912(ra) # 80000e48 <myproc>
    80003ac0:	5904                	lw	s1,48(a0)
    80003ac2:	413484b3          	sub	s1,s1,s3
    80003ac6:	0014b493          	seqz	s1,s1
    80003aca:	bfc1                	j	80003a9a <holdingsleep+0x24>

0000000080003acc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003acc:	1141                	addi	sp,sp,-16
    80003ace:	e406                	sd	ra,8(sp)
    80003ad0:	e022                	sd	s0,0(sp)
    80003ad2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ad4:	00005597          	auipc	a1,0x5
    80003ad8:	b3c58593          	addi	a1,a1,-1220 # 80008610 <syscalls+0x248>
    80003adc:	0001a517          	auipc	a0,0x1a
    80003ae0:	c8c50513          	addi	a0,a0,-884 # 8001d768 <ftable>
    80003ae4:	00003097          	auipc	ra,0x3
    80003ae8:	80a080e7          	jalr	-2038(ra) # 800062ee <initlock>
}
    80003aec:	60a2                	ld	ra,8(sp)
    80003aee:	6402                	ld	s0,0(sp)
    80003af0:	0141                	addi	sp,sp,16
    80003af2:	8082                	ret

0000000080003af4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003af4:	1101                	addi	sp,sp,-32
    80003af6:	ec06                	sd	ra,24(sp)
    80003af8:	e822                	sd	s0,16(sp)
    80003afa:	e426                	sd	s1,8(sp)
    80003afc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003afe:	0001a517          	auipc	a0,0x1a
    80003b02:	c6a50513          	addi	a0,a0,-918 # 8001d768 <ftable>
    80003b06:	00003097          	auipc	ra,0x3
    80003b0a:	878080e7          	jalr	-1928(ra) # 8000637e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b0e:	0001a497          	auipc	s1,0x1a
    80003b12:	c7248493          	addi	s1,s1,-910 # 8001d780 <ftable+0x18>
    80003b16:	0001b717          	auipc	a4,0x1b
    80003b1a:	c0a70713          	addi	a4,a4,-1014 # 8001e720 <ftable+0xfb8>
    if(f->ref == 0){
    80003b1e:	40dc                	lw	a5,4(s1)
    80003b20:	cf99                	beqz	a5,80003b3e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b22:	02848493          	addi	s1,s1,40
    80003b26:	fee49ce3          	bne	s1,a4,80003b1e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b2a:	0001a517          	auipc	a0,0x1a
    80003b2e:	c3e50513          	addi	a0,a0,-962 # 8001d768 <ftable>
    80003b32:	00003097          	auipc	ra,0x3
    80003b36:	900080e7          	jalr	-1792(ra) # 80006432 <release>
  return 0;
    80003b3a:	4481                	li	s1,0
    80003b3c:	a819                	j	80003b52 <filealloc+0x5e>
      f->ref = 1;
    80003b3e:	4785                	li	a5,1
    80003b40:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b42:	0001a517          	auipc	a0,0x1a
    80003b46:	c2650513          	addi	a0,a0,-986 # 8001d768 <ftable>
    80003b4a:	00003097          	auipc	ra,0x3
    80003b4e:	8e8080e7          	jalr	-1816(ra) # 80006432 <release>
}
    80003b52:	8526                	mv	a0,s1
    80003b54:	60e2                	ld	ra,24(sp)
    80003b56:	6442                	ld	s0,16(sp)
    80003b58:	64a2                	ld	s1,8(sp)
    80003b5a:	6105                	addi	sp,sp,32
    80003b5c:	8082                	ret

0000000080003b5e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b5e:	1101                	addi	sp,sp,-32
    80003b60:	ec06                	sd	ra,24(sp)
    80003b62:	e822                	sd	s0,16(sp)
    80003b64:	e426                	sd	s1,8(sp)
    80003b66:	1000                	addi	s0,sp,32
    80003b68:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b6a:	0001a517          	auipc	a0,0x1a
    80003b6e:	bfe50513          	addi	a0,a0,-1026 # 8001d768 <ftable>
    80003b72:	00003097          	auipc	ra,0x3
    80003b76:	80c080e7          	jalr	-2036(ra) # 8000637e <acquire>
  if(f->ref < 1)
    80003b7a:	40dc                	lw	a5,4(s1)
    80003b7c:	02f05263          	blez	a5,80003ba0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b80:	2785                	addiw	a5,a5,1
    80003b82:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b84:	0001a517          	auipc	a0,0x1a
    80003b88:	be450513          	addi	a0,a0,-1052 # 8001d768 <ftable>
    80003b8c:	00003097          	auipc	ra,0x3
    80003b90:	8a6080e7          	jalr	-1882(ra) # 80006432 <release>
  return f;
}
    80003b94:	8526                	mv	a0,s1
    80003b96:	60e2                	ld	ra,24(sp)
    80003b98:	6442                	ld	s0,16(sp)
    80003b9a:	64a2                	ld	s1,8(sp)
    80003b9c:	6105                	addi	sp,sp,32
    80003b9e:	8082                	ret
    panic("filedup");
    80003ba0:	00005517          	auipc	a0,0x5
    80003ba4:	a7850513          	addi	a0,a0,-1416 # 80008618 <syscalls+0x250>
    80003ba8:	00002097          	auipc	ra,0x2
    80003bac:	220080e7          	jalr	544(ra) # 80005dc8 <panic>

0000000080003bb0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bb0:	7139                	addi	sp,sp,-64
    80003bb2:	fc06                	sd	ra,56(sp)
    80003bb4:	f822                	sd	s0,48(sp)
    80003bb6:	f426                	sd	s1,40(sp)
    80003bb8:	f04a                	sd	s2,32(sp)
    80003bba:	ec4e                	sd	s3,24(sp)
    80003bbc:	e852                	sd	s4,16(sp)
    80003bbe:	e456                	sd	s5,8(sp)
    80003bc0:	0080                	addi	s0,sp,64
    80003bc2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bc4:	0001a517          	auipc	a0,0x1a
    80003bc8:	ba450513          	addi	a0,a0,-1116 # 8001d768 <ftable>
    80003bcc:	00002097          	auipc	ra,0x2
    80003bd0:	7b2080e7          	jalr	1970(ra) # 8000637e <acquire>
  if(f->ref < 1)
    80003bd4:	40dc                	lw	a5,4(s1)
    80003bd6:	06f05163          	blez	a5,80003c38 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bda:	37fd                	addiw	a5,a5,-1
    80003bdc:	0007871b          	sext.w	a4,a5
    80003be0:	c0dc                	sw	a5,4(s1)
    80003be2:	06e04363          	bgtz	a4,80003c48 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003be6:	0004a903          	lw	s2,0(s1)
    80003bea:	0094ca83          	lbu	s5,9(s1)
    80003bee:	0104ba03          	ld	s4,16(s1)
    80003bf2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bf6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bfa:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bfe:	0001a517          	auipc	a0,0x1a
    80003c02:	b6a50513          	addi	a0,a0,-1174 # 8001d768 <ftable>
    80003c06:	00003097          	auipc	ra,0x3
    80003c0a:	82c080e7          	jalr	-2004(ra) # 80006432 <release>

  if(ff.type == FD_PIPE){
    80003c0e:	4785                	li	a5,1
    80003c10:	04f90d63          	beq	s2,a5,80003c6a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c14:	3979                	addiw	s2,s2,-2
    80003c16:	4785                	li	a5,1
    80003c18:	0527e063          	bltu	a5,s2,80003c58 <fileclose+0xa8>
    begin_op();
    80003c1c:	00000097          	auipc	ra,0x0
    80003c20:	ac8080e7          	jalr	-1336(ra) # 800036e4 <begin_op>
    iput(ff.ip);
    80003c24:	854e                	mv	a0,s3
    80003c26:	fffff097          	auipc	ra,0xfffff
    80003c2a:	2a6080e7          	jalr	678(ra) # 80002ecc <iput>
    end_op();
    80003c2e:	00000097          	auipc	ra,0x0
    80003c32:	b36080e7          	jalr	-1226(ra) # 80003764 <end_op>
    80003c36:	a00d                	j	80003c58 <fileclose+0xa8>
    panic("fileclose");
    80003c38:	00005517          	auipc	a0,0x5
    80003c3c:	9e850513          	addi	a0,a0,-1560 # 80008620 <syscalls+0x258>
    80003c40:	00002097          	auipc	ra,0x2
    80003c44:	188080e7          	jalr	392(ra) # 80005dc8 <panic>
    release(&ftable.lock);
    80003c48:	0001a517          	auipc	a0,0x1a
    80003c4c:	b2050513          	addi	a0,a0,-1248 # 8001d768 <ftable>
    80003c50:	00002097          	auipc	ra,0x2
    80003c54:	7e2080e7          	jalr	2018(ra) # 80006432 <release>
  }
}
    80003c58:	70e2                	ld	ra,56(sp)
    80003c5a:	7442                	ld	s0,48(sp)
    80003c5c:	74a2                	ld	s1,40(sp)
    80003c5e:	7902                	ld	s2,32(sp)
    80003c60:	69e2                	ld	s3,24(sp)
    80003c62:	6a42                	ld	s4,16(sp)
    80003c64:	6aa2                	ld	s5,8(sp)
    80003c66:	6121                	addi	sp,sp,64
    80003c68:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c6a:	85d6                	mv	a1,s5
    80003c6c:	8552                	mv	a0,s4
    80003c6e:	00000097          	auipc	ra,0x0
    80003c72:	34c080e7          	jalr	844(ra) # 80003fba <pipeclose>
    80003c76:	b7cd                	j	80003c58 <fileclose+0xa8>

0000000080003c78 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c78:	715d                	addi	sp,sp,-80
    80003c7a:	e486                	sd	ra,72(sp)
    80003c7c:	e0a2                	sd	s0,64(sp)
    80003c7e:	fc26                	sd	s1,56(sp)
    80003c80:	f84a                	sd	s2,48(sp)
    80003c82:	f44e                	sd	s3,40(sp)
    80003c84:	0880                	addi	s0,sp,80
    80003c86:	84aa                	mv	s1,a0
    80003c88:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c8a:	ffffd097          	auipc	ra,0xffffd
    80003c8e:	1be080e7          	jalr	446(ra) # 80000e48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c92:	409c                	lw	a5,0(s1)
    80003c94:	37f9                	addiw	a5,a5,-2
    80003c96:	4705                	li	a4,1
    80003c98:	04f76763          	bltu	a4,a5,80003ce6 <filestat+0x6e>
    80003c9c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c9e:	6c88                	ld	a0,24(s1)
    80003ca0:	fffff097          	auipc	ra,0xfffff
    80003ca4:	072080e7          	jalr	114(ra) # 80002d12 <ilock>
    stati(f->ip, &st);
    80003ca8:	fb840593          	addi	a1,s0,-72
    80003cac:	6c88                	ld	a0,24(s1)
    80003cae:	fffff097          	auipc	ra,0xfffff
    80003cb2:	2ee080e7          	jalr	750(ra) # 80002f9c <stati>
    iunlock(f->ip);
    80003cb6:	6c88                	ld	a0,24(s1)
    80003cb8:	fffff097          	auipc	ra,0xfffff
    80003cbc:	11c080e7          	jalr	284(ra) # 80002dd4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cc0:	46e1                	li	a3,24
    80003cc2:	fb840613          	addi	a2,s0,-72
    80003cc6:	85ce                	mv	a1,s3
    80003cc8:	05093503          	ld	a0,80(s2)
    80003ccc:	ffffd097          	auipc	ra,0xffffd
    80003cd0:	e3e080e7          	jalr	-450(ra) # 80000b0a <copyout>
    80003cd4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cd8:	60a6                	ld	ra,72(sp)
    80003cda:	6406                	ld	s0,64(sp)
    80003cdc:	74e2                	ld	s1,56(sp)
    80003cde:	7942                	ld	s2,48(sp)
    80003ce0:	79a2                	ld	s3,40(sp)
    80003ce2:	6161                	addi	sp,sp,80
    80003ce4:	8082                	ret
  return -1;
    80003ce6:	557d                	li	a0,-1
    80003ce8:	bfc5                	j	80003cd8 <filestat+0x60>

0000000080003cea <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cea:	7179                	addi	sp,sp,-48
    80003cec:	f406                	sd	ra,40(sp)
    80003cee:	f022                	sd	s0,32(sp)
    80003cf0:	ec26                	sd	s1,24(sp)
    80003cf2:	e84a                	sd	s2,16(sp)
    80003cf4:	e44e                	sd	s3,8(sp)
    80003cf6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cf8:	00854783          	lbu	a5,8(a0)
    80003cfc:	c3d5                	beqz	a5,80003da0 <fileread+0xb6>
    80003cfe:	84aa                	mv	s1,a0
    80003d00:	89ae                	mv	s3,a1
    80003d02:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d04:	411c                	lw	a5,0(a0)
    80003d06:	4705                	li	a4,1
    80003d08:	04e78963          	beq	a5,a4,80003d5a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d0c:	470d                	li	a4,3
    80003d0e:	04e78d63          	beq	a5,a4,80003d68 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d12:	4709                	li	a4,2
    80003d14:	06e79e63          	bne	a5,a4,80003d90 <fileread+0xa6>
    ilock(f->ip);
    80003d18:	6d08                	ld	a0,24(a0)
    80003d1a:	fffff097          	auipc	ra,0xfffff
    80003d1e:	ff8080e7          	jalr	-8(ra) # 80002d12 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d22:	874a                	mv	a4,s2
    80003d24:	5094                	lw	a3,32(s1)
    80003d26:	864e                	mv	a2,s3
    80003d28:	4585                	li	a1,1
    80003d2a:	6c88                	ld	a0,24(s1)
    80003d2c:	fffff097          	auipc	ra,0xfffff
    80003d30:	29a080e7          	jalr	666(ra) # 80002fc6 <readi>
    80003d34:	892a                	mv	s2,a0
    80003d36:	00a05563          	blez	a0,80003d40 <fileread+0x56>
      f->off += r;
    80003d3a:	509c                	lw	a5,32(s1)
    80003d3c:	9fa9                	addw	a5,a5,a0
    80003d3e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d40:	6c88                	ld	a0,24(s1)
    80003d42:	fffff097          	auipc	ra,0xfffff
    80003d46:	092080e7          	jalr	146(ra) # 80002dd4 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d4a:	854a                	mv	a0,s2
    80003d4c:	70a2                	ld	ra,40(sp)
    80003d4e:	7402                	ld	s0,32(sp)
    80003d50:	64e2                	ld	s1,24(sp)
    80003d52:	6942                	ld	s2,16(sp)
    80003d54:	69a2                	ld	s3,8(sp)
    80003d56:	6145                	addi	sp,sp,48
    80003d58:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d5a:	6908                	ld	a0,16(a0)
    80003d5c:	00000097          	auipc	ra,0x0
    80003d60:	3c8080e7          	jalr	968(ra) # 80004124 <piperead>
    80003d64:	892a                	mv	s2,a0
    80003d66:	b7d5                	j	80003d4a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d68:	02451783          	lh	a5,36(a0)
    80003d6c:	03079693          	slli	a3,a5,0x30
    80003d70:	92c1                	srli	a3,a3,0x30
    80003d72:	4725                	li	a4,9
    80003d74:	02d76863          	bltu	a4,a3,80003da4 <fileread+0xba>
    80003d78:	0792                	slli	a5,a5,0x4
    80003d7a:	0001a717          	auipc	a4,0x1a
    80003d7e:	94e70713          	addi	a4,a4,-1714 # 8001d6c8 <devsw>
    80003d82:	97ba                	add	a5,a5,a4
    80003d84:	639c                	ld	a5,0(a5)
    80003d86:	c38d                	beqz	a5,80003da8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d88:	4505                	li	a0,1
    80003d8a:	9782                	jalr	a5
    80003d8c:	892a                	mv	s2,a0
    80003d8e:	bf75                	j	80003d4a <fileread+0x60>
    panic("fileread");
    80003d90:	00005517          	auipc	a0,0x5
    80003d94:	8a050513          	addi	a0,a0,-1888 # 80008630 <syscalls+0x268>
    80003d98:	00002097          	auipc	ra,0x2
    80003d9c:	030080e7          	jalr	48(ra) # 80005dc8 <panic>
    return -1;
    80003da0:	597d                	li	s2,-1
    80003da2:	b765                	j	80003d4a <fileread+0x60>
      return -1;
    80003da4:	597d                	li	s2,-1
    80003da6:	b755                	j	80003d4a <fileread+0x60>
    80003da8:	597d                	li	s2,-1
    80003daa:	b745                	j	80003d4a <fileread+0x60>

0000000080003dac <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003dac:	715d                	addi	sp,sp,-80
    80003dae:	e486                	sd	ra,72(sp)
    80003db0:	e0a2                	sd	s0,64(sp)
    80003db2:	fc26                	sd	s1,56(sp)
    80003db4:	f84a                	sd	s2,48(sp)
    80003db6:	f44e                	sd	s3,40(sp)
    80003db8:	f052                	sd	s4,32(sp)
    80003dba:	ec56                	sd	s5,24(sp)
    80003dbc:	e85a                	sd	s6,16(sp)
    80003dbe:	e45e                	sd	s7,8(sp)
    80003dc0:	e062                	sd	s8,0(sp)
    80003dc2:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003dc4:	00954783          	lbu	a5,9(a0)
    80003dc8:	10078663          	beqz	a5,80003ed4 <filewrite+0x128>
    80003dcc:	892a                	mv	s2,a0
    80003dce:	8aae                	mv	s5,a1
    80003dd0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dd2:	411c                	lw	a5,0(a0)
    80003dd4:	4705                	li	a4,1
    80003dd6:	02e78263          	beq	a5,a4,80003dfa <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dda:	470d                	li	a4,3
    80003ddc:	02e78663          	beq	a5,a4,80003e08 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003de0:	4709                	li	a4,2
    80003de2:	0ee79163          	bne	a5,a4,80003ec4 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003de6:	0ac05d63          	blez	a2,80003ea0 <filewrite+0xf4>
    int i = 0;
    80003dea:	4981                	li	s3,0
    80003dec:	6b05                	lui	s6,0x1
    80003dee:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003df2:	6b85                	lui	s7,0x1
    80003df4:	c00b8b9b          	addiw	s7,s7,-1024
    80003df8:	a861                	j	80003e90 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003dfa:	6908                	ld	a0,16(a0)
    80003dfc:	00000097          	auipc	ra,0x0
    80003e00:	22e080e7          	jalr	558(ra) # 8000402a <pipewrite>
    80003e04:	8a2a                	mv	s4,a0
    80003e06:	a045                	j	80003ea6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e08:	02451783          	lh	a5,36(a0)
    80003e0c:	03079693          	slli	a3,a5,0x30
    80003e10:	92c1                	srli	a3,a3,0x30
    80003e12:	4725                	li	a4,9
    80003e14:	0cd76263          	bltu	a4,a3,80003ed8 <filewrite+0x12c>
    80003e18:	0792                	slli	a5,a5,0x4
    80003e1a:	0001a717          	auipc	a4,0x1a
    80003e1e:	8ae70713          	addi	a4,a4,-1874 # 8001d6c8 <devsw>
    80003e22:	97ba                	add	a5,a5,a4
    80003e24:	679c                	ld	a5,8(a5)
    80003e26:	cbdd                	beqz	a5,80003edc <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e28:	4505                	li	a0,1
    80003e2a:	9782                	jalr	a5
    80003e2c:	8a2a                	mv	s4,a0
    80003e2e:	a8a5                	j	80003ea6 <filewrite+0xfa>
    80003e30:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e34:	00000097          	auipc	ra,0x0
    80003e38:	8b0080e7          	jalr	-1872(ra) # 800036e4 <begin_op>
      ilock(f->ip);
    80003e3c:	01893503          	ld	a0,24(s2)
    80003e40:	fffff097          	auipc	ra,0xfffff
    80003e44:	ed2080e7          	jalr	-302(ra) # 80002d12 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e48:	8762                	mv	a4,s8
    80003e4a:	02092683          	lw	a3,32(s2)
    80003e4e:	01598633          	add	a2,s3,s5
    80003e52:	4585                	li	a1,1
    80003e54:	01893503          	ld	a0,24(s2)
    80003e58:	fffff097          	auipc	ra,0xfffff
    80003e5c:	266080e7          	jalr	614(ra) # 800030be <writei>
    80003e60:	84aa                	mv	s1,a0
    80003e62:	00a05763          	blez	a0,80003e70 <filewrite+0xc4>
        f->off += r;
    80003e66:	02092783          	lw	a5,32(s2)
    80003e6a:	9fa9                	addw	a5,a5,a0
    80003e6c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e70:	01893503          	ld	a0,24(s2)
    80003e74:	fffff097          	auipc	ra,0xfffff
    80003e78:	f60080e7          	jalr	-160(ra) # 80002dd4 <iunlock>
      end_op();
    80003e7c:	00000097          	auipc	ra,0x0
    80003e80:	8e8080e7          	jalr	-1816(ra) # 80003764 <end_op>

      if(r != n1){
    80003e84:	009c1f63          	bne	s8,s1,80003ea2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e88:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e8c:	0149db63          	bge	s3,s4,80003ea2 <filewrite+0xf6>
      int n1 = n - i;
    80003e90:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e94:	84be                	mv	s1,a5
    80003e96:	2781                	sext.w	a5,a5
    80003e98:	f8fb5ce3          	bge	s6,a5,80003e30 <filewrite+0x84>
    80003e9c:	84de                	mv	s1,s7
    80003e9e:	bf49                	j	80003e30 <filewrite+0x84>
    int i = 0;
    80003ea0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ea2:	013a1f63          	bne	s4,s3,80003ec0 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ea6:	8552                	mv	a0,s4
    80003ea8:	60a6                	ld	ra,72(sp)
    80003eaa:	6406                	ld	s0,64(sp)
    80003eac:	74e2                	ld	s1,56(sp)
    80003eae:	7942                	ld	s2,48(sp)
    80003eb0:	79a2                	ld	s3,40(sp)
    80003eb2:	7a02                	ld	s4,32(sp)
    80003eb4:	6ae2                	ld	s5,24(sp)
    80003eb6:	6b42                	ld	s6,16(sp)
    80003eb8:	6ba2                	ld	s7,8(sp)
    80003eba:	6c02                	ld	s8,0(sp)
    80003ebc:	6161                	addi	sp,sp,80
    80003ebe:	8082                	ret
    ret = (i == n ? n : -1);
    80003ec0:	5a7d                	li	s4,-1
    80003ec2:	b7d5                	j	80003ea6 <filewrite+0xfa>
    panic("filewrite");
    80003ec4:	00004517          	auipc	a0,0x4
    80003ec8:	77c50513          	addi	a0,a0,1916 # 80008640 <syscalls+0x278>
    80003ecc:	00002097          	auipc	ra,0x2
    80003ed0:	efc080e7          	jalr	-260(ra) # 80005dc8 <panic>
    return -1;
    80003ed4:	5a7d                	li	s4,-1
    80003ed6:	bfc1                	j	80003ea6 <filewrite+0xfa>
      return -1;
    80003ed8:	5a7d                	li	s4,-1
    80003eda:	b7f1                	j	80003ea6 <filewrite+0xfa>
    80003edc:	5a7d                	li	s4,-1
    80003ede:	b7e1                	j	80003ea6 <filewrite+0xfa>

0000000080003ee0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ee0:	7179                	addi	sp,sp,-48
    80003ee2:	f406                	sd	ra,40(sp)
    80003ee4:	f022                	sd	s0,32(sp)
    80003ee6:	ec26                	sd	s1,24(sp)
    80003ee8:	e84a                	sd	s2,16(sp)
    80003eea:	e44e                	sd	s3,8(sp)
    80003eec:	e052                	sd	s4,0(sp)
    80003eee:	1800                	addi	s0,sp,48
    80003ef0:	84aa                	mv	s1,a0
    80003ef2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ef4:	0005b023          	sd	zero,0(a1)
    80003ef8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003efc:	00000097          	auipc	ra,0x0
    80003f00:	bf8080e7          	jalr	-1032(ra) # 80003af4 <filealloc>
    80003f04:	e088                	sd	a0,0(s1)
    80003f06:	c551                	beqz	a0,80003f92 <pipealloc+0xb2>
    80003f08:	00000097          	auipc	ra,0x0
    80003f0c:	bec080e7          	jalr	-1044(ra) # 80003af4 <filealloc>
    80003f10:	00aa3023          	sd	a0,0(s4)
    80003f14:	c92d                	beqz	a0,80003f86 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f16:	ffffc097          	auipc	ra,0xffffc
    80003f1a:	202080e7          	jalr	514(ra) # 80000118 <kalloc>
    80003f1e:	892a                	mv	s2,a0
    80003f20:	c125                	beqz	a0,80003f80 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f22:	4985                	li	s3,1
    80003f24:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f28:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f2c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f30:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f34:	00004597          	auipc	a1,0x4
    80003f38:	71c58593          	addi	a1,a1,1820 # 80008650 <syscalls+0x288>
    80003f3c:	00002097          	auipc	ra,0x2
    80003f40:	3b2080e7          	jalr	946(ra) # 800062ee <initlock>
  (*f0)->type = FD_PIPE;
    80003f44:	609c                	ld	a5,0(s1)
    80003f46:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f4a:	609c                	ld	a5,0(s1)
    80003f4c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f50:	609c                	ld	a5,0(s1)
    80003f52:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f56:	609c                	ld	a5,0(s1)
    80003f58:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f5c:	000a3783          	ld	a5,0(s4)
    80003f60:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f64:	000a3783          	ld	a5,0(s4)
    80003f68:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f6c:	000a3783          	ld	a5,0(s4)
    80003f70:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f74:	000a3783          	ld	a5,0(s4)
    80003f78:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f7c:	4501                	li	a0,0
    80003f7e:	a025                	j	80003fa6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f80:	6088                	ld	a0,0(s1)
    80003f82:	e501                	bnez	a0,80003f8a <pipealloc+0xaa>
    80003f84:	a039                	j	80003f92 <pipealloc+0xb2>
    80003f86:	6088                	ld	a0,0(s1)
    80003f88:	c51d                	beqz	a0,80003fb6 <pipealloc+0xd6>
    fileclose(*f0);
    80003f8a:	00000097          	auipc	ra,0x0
    80003f8e:	c26080e7          	jalr	-986(ra) # 80003bb0 <fileclose>
  if(*f1)
    80003f92:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f96:	557d                	li	a0,-1
  if(*f1)
    80003f98:	c799                	beqz	a5,80003fa6 <pipealloc+0xc6>
    fileclose(*f1);
    80003f9a:	853e                	mv	a0,a5
    80003f9c:	00000097          	auipc	ra,0x0
    80003fa0:	c14080e7          	jalr	-1004(ra) # 80003bb0 <fileclose>
  return -1;
    80003fa4:	557d                	li	a0,-1
}
    80003fa6:	70a2                	ld	ra,40(sp)
    80003fa8:	7402                	ld	s0,32(sp)
    80003faa:	64e2                	ld	s1,24(sp)
    80003fac:	6942                	ld	s2,16(sp)
    80003fae:	69a2                	ld	s3,8(sp)
    80003fb0:	6a02                	ld	s4,0(sp)
    80003fb2:	6145                	addi	sp,sp,48
    80003fb4:	8082                	ret
  return -1;
    80003fb6:	557d                	li	a0,-1
    80003fb8:	b7fd                	j	80003fa6 <pipealloc+0xc6>

0000000080003fba <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fba:	1101                	addi	sp,sp,-32
    80003fbc:	ec06                	sd	ra,24(sp)
    80003fbe:	e822                	sd	s0,16(sp)
    80003fc0:	e426                	sd	s1,8(sp)
    80003fc2:	e04a                	sd	s2,0(sp)
    80003fc4:	1000                	addi	s0,sp,32
    80003fc6:	84aa                	mv	s1,a0
    80003fc8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fca:	00002097          	auipc	ra,0x2
    80003fce:	3b4080e7          	jalr	948(ra) # 8000637e <acquire>
  if(writable){
    80003fd2:	02090d63          	beqz	s2,8000400c <pipeclose+0x52>
    pi->writeopen = 0;
    80003fd6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fda:	21848513          	addi	a0,s1,536
    80003fde:	ffffd097          	auipc	ra,0xffffd
    80003fe2:	6ba080e7          	jalr	1722(ra) # 80001698 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fe6:	2204b783          	ld	a5,544(s1)
    80003fea:	eb95                	bnez	a5,8000401e <pipeclose+0x64>
    release(&pi->lock);
    80003fec:	8526                	mv	a0,s1
    80003fee:	00002097          	auipc	ra,0x2
    80003ff2:	444080e7          	jalr	1092(ra) # 80006432 <release>
    kfree((char*)pi);
    80003ff6:	8526                	mv	a0,s1
    80003ff8:	ffffc097          	auipc	ra,0xffffc
    80003ffc:	024080e7          	jalr	36(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004000:	60e2                	ld	ra,24(sp)
    80004002:	6442                	ld	s0,16(sp)
    80004004:	64a2                	ld	s1,8(sp)
    80004006:	6902                	ld	s2,0(sp)
    80004008:	6105                	addi	sp,sp,32
    8000400a:	8082                	ret
    pi->readopen = 0;
    8000400c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004010:	21c48513          	addi	a0,s1,540
    80004014:	ffffd097          	auipc	ra,0xffffd
    80004018:	684080e7          	jalr	1668(ra) # 80001698 <wakeup>
    8000401c:	b7e9                	j	80003fe6 <pipeclose+0x2c>
    release(&pi->lock);
    8000401e:	8526                	mv	a0,s1
    80004020:	00002097          	auipc	ra,0x2
    80004024:	412080e7          	jalr	1042(ra) # 80006432 <release>
}
    80004028:	bfe1                	j	80004000 <pipeclose+0x46>

000000008000402a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000402a:	7159                	addi	sp,sp,-112
    8000402c:	f486                	sd	ra,104(sp)
    8000402e:	f0a2                	sd	s0,96(sp)
    80004030:	eca6                	sd	s1,88(sp)
    80004032:	e8ca                	sd	s2,80(sp)
    80004034:	e4ce                	sd	s3,72(sp)
    80004036:	e0d2                	sd	s4,64(sp)
    80004038:	fc56                	sd	s5,56(sp)
    8000403a:	f85a                	sd	s6,48(sp)
    8000403c:	f45e                	sd	s7,40(sp)
    8000403e:	f062                	sd	s8,32(sp)
    80004040:	ec66                	sd	s9,24(sp)
    80004042:	1880                	addi	s0,sp,112
    80004044:	84aa                	mv	s1,a0
    80004046:	8aae                	mv	s5,a1
    80004048:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000404a:	ffffd097          	auipc	ra,0xffffd
    8000404e:	dfe080e7          	jalr	-514(ra) # 80000e48 <myproc>
    80004052:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004054:	8526                	mv	a0,s1
    80004056:	00002097          	auipc	ra,0x2
    8000405a:	328080e7          	jalr	808(ra) # 8000637e <acquire>
  while(i < n){
    8000405e:	0d405163          	blez	s4,80004120 <pipewrite+0xf6>
    80004062:	8ba6                	mv	s7,s1
  int i = 0;
    80004064:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004066:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004068:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000406c:	21c48c13          	addi	s8,s1,540
    80004070:	a08d                	j	800040d2 <pipewrite+0xa8>
      release(&pi->lock);
    80004072:	8526                	mv	a0,s1
    80004074:	00002097          	auipc	ra,0x2
    80004078:	3be080e7          	jalr	958(ra) # 80006432 <release>
      return -1;
    8000407c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000407e:	854a                	mv	a0,s2
    80004080:	70a6                	ld	ra,104(sp)
    80004082:	7406                	ld	s0,96(sp)
    80004084:	64e6                	ld	s1,88(sp)
    80004086:	6946                	ld	s2,80(sp)
    80004088:	69a6                	ld	s3,72(sp)
    8000408a:	6a06                	ld	s4,64(sp)
    8000408c:	7ae2                	ld	s5,56(sp)
    8000408e:	7b42                	ld	s6,48(sp)
    80004090:	7ba2                	ld	s7,40(sp)
    80004092:	7c02                	ld	s8,32(sp)
    80004094:	6ce2                	ld	s9,24(sp)
    80004096:	6165                	addi	sp,sp,112
    80004098:	8082                	ret
      wakeup(&pi->nread);
    8000409a:	8566                	mv	a0,s9
    8000409c:	ffffd097          	auipc	ra,0xffffd
    800040a0:	5fc080e7          	jalr	1532(ra) # 80001698 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040a4:	85de                	mv	a1,s7
    800040a6:	8562                	mv	a0,s8
    800040a8:	ffffd097          	auipc	ra,0xffffd
    800040ac:	464080e7          	jalr	1124(ra) # 8000150c <sleep>
    800040b0:	a839                	j	800040ce <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040b2:	21c4a783          	lw	a5,540(s1)
    800040b6:	0017871b          	addiw	a4,a5,1
    800040ba:	20e4ae23          	sw	a4,540(s1)
    800040be:	1ff7f793          	andi	a5,a5,511
    800040c2:	97a6                	add	a5,a5,s1
    800040c4:	f9f44703          	lbu	a4,-97(s0)
    800040c8:	00e78c23          	sb	a4,24(a5)
      i++;
    800040cc:	2905                	addiw	s2,s2,1
  while(i < n){
    800040ce:	03495d63          	bge	s2,s4,80004108 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    800040d2:	2204a783          	lw	a5,544(s1)
    800040d6:	dfd1                	beqz	a5,80004072 <pipewrite+0x48>
    800040d8:	0289a783          	lw	a5,40(s3)
    800040dc:	fbd9                	bnez	a5,80004072 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040de:	2184a783          	lw	a5,536(s1)
    800040e2:	21c4a703          	lw	a4,540(s1)
    800040e6:	2007879b          	addiw	a5,a5,512
    800040ea:	faf708e3          	beq	a4,a5,8000409a <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ee:	4685                	li	a3,1
    800040f0:	01590633          	add	a2,s2,s5
    800040f4:	f9f40593          	addi	a1,s0,-97
    800040f8:	0509b503          	ld	a0,80(s3)
    800040fc:	ffffd097          	auipc	ra,0xffffd
    80004100:	a9a080e7          	jalr	-1382(ra) # 80000b96 <copyin>
    80004104:	fb6517e3          	bne	a0,s6,800040b2 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004108:	21848513          	addi	a0,s1,536
    8000410c:	ffffd097          	auipc	ra,0xffffd
    80004110:	58c080e7          	jalr	1420(ra) # 80001698 <wakeup>
  release(&pi->lock);
    80004114:	8526                	mv	a0,s1
    80004116:	00002097          	auipc	ra,0x2
    8000411a:	31c080e7          	jalr	796(ra) # 80006432 <release>
  return i;
    8000411e:	b785                	j	8000407e <pipewrite+0x54>
  int i = 0;
    80004120:	4901                	li	s2,0
    80004122:	b7dd                	j	80004108 <pipewrite+0xde>

0000000080004124 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004124:	715d                	addi	sp,sp,-80
    80004126:	e486                	sd	ra,72(sp)
    80004128:	e0a2                	sd	s0,64(sp)
    8000412a:	fc26                	sd	s1,56(sp)
    8000412c:	f84a                	sd	s2,48(sp)
    8000412e:	f44e                	sd	s3,40(sp)
    80004130:	f052                	sd	s4,32(sp)
    80004132:	ec56                	sd	s5,24(sp)
    80004134:	e85a                	sd	s6,16(sp)
    80004136:	0880                	addi	s0,sp,80
    80004138:	84aa                	mv	s1,a0
    8000413a:	892e                	mv	s2,a1
    8000413c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000413e:	ffffd097          	auipc	ra,0xffffd
    80004142:	d0a080e7          	jalr	-758(ra) # 80000e48 <myproc>
    80004146:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004148:	8b26                	mv	s6,s1
    8000414a:	8526                	mv	a0,s1
    8000414c:	00002097          	auipc	ra,0x2
    80004150:	232080e7          	jalr	562(ra) # 8000637e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004154:	2184a703          	lw	a4,536(s1)
    80004158:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000415c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004160:	02f71463          	bne	a4,a5,80004188 <piperead+0x64>
    80004164:	2244a783          	lw	a5,548(s1)
    80004168:	c385                	beqz	a5,80004188 <piperead+0x64>
    if(pr->killed){
    8000416a:	028a2783          	lw	a5,40(s4)
    8000416e:	ebc1                	bnez	a5,800041fe <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004170:	85da                	mv	a1,s6
    80004172:	854e                	mv	a0,s3
    80004174:	ffffd097          	auipc	ra,0xffffd
    80004178:	398080e7          	jalr	920(ra) # 8000150c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000417c:	2184a703          	lw	a4,536(s1)
    80004180:	21c4a783          	lw	a5,540(s1)
    80004184:	fef700e3          	beq	a4,a5,80004164 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004188:	09505263          	blez	s5,8000420c <piperead+0xe8>
    8000418c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000418e:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004190:	2184a783          	lw	a5,536(s1)
    80004194:	21c4a703          	lw	a4,540(s1)
    80004198:	02f70d63          	beq	a4,a5,800041d2 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000419c:	0017871b          	addiw	a4,a5,1
    800041a0:	20e4ac23          	sw	a4,536(s1)
    800041a4:	1ff7f793          	andi	a5,a5,511
    800041a8:	97a6                	add	a5,a5,s1
    800041aa:	0187c783          	lbu	a5,24(a5)
    800041ae:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041b2:	4685                	li	a3,1
    800041b4:	fbf40613          	addi	a2,s0,-65
    800041b8:	85ca                	mv	a1,s2
    800041ba:	050a3503          	ld	a0,80(s4)
    800041be:	ffffd097          	auipc	ra,0xffffd
    800041c2:	94c080e7          	jalr	-1716(ra) # 80000b0a <copyout>
    800041c6:	01650663          	beq	a0,s6,800041d2 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041ca:	2985                	addiw	s3,s3,1
    800041cc:	0905                	addi	s2,s2,1
    800041ce:	fd3a91e3          	bne	s5,s3,80004190 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041d2:	21c48513          	addi	a0,s1,540
    800041d6:	ffffd097          	auipc	ra,0xffffd
    800041da:	4c2080e7          	jalr	1218(ra) # 80001698 <wakeup>
  release(&pi->lock);
    800041de:	8526                	mv	a0,s1
    800041e0:	00002097          	auipc	ra,0x2
    800041e4:	252080e7          	jalr	594(ra) # 80006432 <release>
  return i;
}
    800041e8:	854e                	mv	a0,s3
    800041ea:	60a6                	ld	ra,72(sp)
    800041ec:	6406                	ld	s0,64(sp)
    800041ee:	74e2                	ld	s1,56(sp)
    800041f0:	7942                	ld	s2,48(sp)
    800041f2:	79a2                	ld	s3,40(sp)
    800041f4:	7a02                	ld	s4,32(sp)
    800041f6:	6ae2                	ld	s5,24(sp)
    800041f8:	6b42                	ld	s6,16(sp)
    800041fa:	6161                	addi	sp,sp,80
    800041fc:	8082                	ret
      release(&pi->lock);
    800041fe:	8526                	mv	a0,s1
    80004200:	00002097          	auipc	ra,0x2
    80004204:	232080e7          	jalr	562(ra) # 80006432 <release>
      return -1;
    80004208:	59fd                	li	s3,-1
    8000420a:	bff9                	j	800041e8 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000420c:	4981                	li	s3,0
    8000420e:	b7d1                	j	800041d2 <piperead+0xae>

0000000080004210 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004210:	df010113          	addi	sp,sp,-528
    80004214:	20113423          	sd	ra,520(sp)
    80004218:	20813023          	sd	s0,512(sp)
    8000421c:	ffa6                	sd	s1,504(sp)
    8000421e:	fbca                	sd	s2,496(sp)
    80004220:	f7ce                	sd	s3,488(sp)
    80004222:	f3d2                	sd	s4,480(sp)
    80004224:	efd6                	sd	s5,472(sp)
    80004226:	ebda                	sd	s6,464(sp)
    80004228:	e7de                	sd	s7,456(sp)
    8000422a:	e3e2                	sd	s8,448(sp)
    8000422c:	ff66                	sd	s9,440(sp)
    8000422e:	fb6a                	sd	s10,432(sp)
    80004230:	f76e                	sd	s11,424(sp)
    80004232:	0c00                	addi	s0,sp,528
    80004234:	84aa                	mv	s1,a0
    80004236:	dea43c23          	sd	a0,-520(s0)
    8000423a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000423e:	ffffd097          	auipc	ra,0xffffd
    80004242:	c0a080e7          	jalr	-1014(ra) # 80000e48 <myproc>
    80004246:	892a                	mv	s2,a0

  begin_op();
    80004248:	fffff097          	auipc	ra,0xfffff
    8000424c:	49c080e7          	jalr	1180(ra) # 800036e4 <begin_op>

  if((ip = namei(path)) == 0){
    80004250:	8526                	mv	a0,s1
    80004252:	fffff097          	auipc	ra,0xfffff
    80004256:	276080e7          	jalr	630(ra) # 800034c8 <namei>
    8000425a:	c92d                	beqz	a0,800042cc <exec+0xbc>
    8000425c:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000425e:	fffff097          	auipc	ra,0xfffff
    80004262:	ab4080e7          	jalr	-1356(ra) # 80002d12 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004266:	04000713          	li	a4,64
    8000426a:	4681                	li	a3,0
    8000426c:	e5040613          	addi	a2,s0,-432
    80004270:	4581                	li	a1,0
    80004272:	8526                	mv	a0,s1
    80004274:	fffff097          	auipc	ra,0xfffff
    80004278:	d52080e7          	jalr	-686(ra) # 80002fc6 <readi>
    8000427c:	04000793          	li	a5,64
    80004280:	00f51a63          	bne	a0,a5,80004294 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004284:	e5042703          	lw	a4,-432(s0)
    80004288:	464c47b7          	lui	a5,0x464c4
    8000428c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004290:	04f70463          	beq	a4,a5,800042d8 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004294:	8526                	mv	a0,s1
    80004296:	fffff097          	auipc	ra,0xfffff
    8000429a:	cde080e7          	jalr	-802(ra) # 80002f74 <iunlockput>
    end_op();
    8000429e:	fffff097          	auipc	ra,0xfffff
    800042a2:	4c6080e7          	jalr	1222(ra) # 80003764 <end_op>
  }
  return -1;
    800042a6:	557d                	li	a0,-1
}
    800042a8:	20813083          	ld	ra,520(sp)
    800042ac:	20013403          	ld	s0,512(sp)
    800042b0:	74fe                	ld	s1,504(sp)
    800042b2:	795e                	ld	s2,496(sp)
    800042b4:	79be                	ld	s3,488(sp)
    800042b6:	7a1e                	ld	s4,480(sp)
    800042b8:	6afe                	ld	s5,472(sp)
    800042ba:	6b5e                	ld	s6,464(sp)
    800042bc:	6bbe                	ld	s7,456(sp)
    800042be:	6c1e                	ld	s8,448(sp)
    800042c0:	7cfa                	ld	s9,440(sp)
    800042c2:	7d5a                	ld	s10,432(sp)
    800042c4:	7dba                	ld	s11,424(sp)
    800042c6:	21010113          	addi	sp,sp,528
    800042ca:	8082                	ret
    end_op();
    800042cc:	fffff097          	auipc	ra,0xfffff
    800042d0:	498080e7          	jalr	1176(ra) # 80003764 <end_op>
    return -1;
    800042d4:	557d                	li	a0,-1
    800042d6:	bfc9                	j	800042a8 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800042d8:	854a                	mv	a0,s2
    800042da:	ffffd097          	auipc	ra,0xffffd
    800042de:	c32080e7          	jalr	-974(ra) # 80000f0c <proc_pagetable>
    800042e2:	8baa                	mv	s7,a0
    800042e4:	d945                	beqz	a0,80004294 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042e6:	e7042983          	lw	s3,-400(s0)
    800042ea:	e8845783          	lhu	a5,-376(s0)
    800042ee:	c7ad                	beqz	a5,80004358 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042f0:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042f2:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800042f4:	6c85                	lui	s9,0x1
    800042f6:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042fa:	def43823          	sd	a5,-528(s0)
    800042fe:	a42d                	j	80004528 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004300:	00004517          	auipc	a0,0x4
    80004304:	35850513          	addi	a0,a0,856 # 80008658 <syscalls+0x290>
    80004308:	00002097          	auipc	ra,0x2
    8000430c:	ac0080e7          	jalr	-1344(ra) # 80005dc8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004310:	8756                	mv	a4,s5
    80004312:	012d86bb          	addw	a3,s11,s2
    80004316:	4581                	li	a1,0
    80004318:	8526                	mv	a0,s1
    8000431a:	fffff097          	auipc	ra,0xfffff
    8000431e:	cac080e7          	jalr	-852(ra) # 80002fc6 <readi>
    80004322:	2501                	sext.w	a0,a0
    80004324:	1aaa9963          	bne	s5,a0,800044d6 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004328:	6785                	lui	a5,0x1
    8000432a:	0127893b          	addw	s2,a5,s2
    8000432e:	77fd                	lui	a5,0xfffff
    80004330:	01478a3b          	addw	s4,a5,s4
    80004334:	1f897163          	bgeu	s2,s8,80004516 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004338:	02091593          	slli	a1,s2,0x20
    8000433c:	9181                	srli	a1,a1,0x20
    8000433e:	95ea                	add	a1,a1,s10
    80004340:	855e                	mv	a0,s7
    80004342:	ffffc097          	auipc	ra,0xffffc
    80004346:	1c4080e7          	jalr	452(ra) # 80000506 <walkaddr>
    8000434a:	862a                	mv	a2,a0
    if(pa == 0)
    8000434c:	d955                	beqz	a0,80004300 <exec+0xf0>
      n = PGSIZE;
    8000434e:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004350:	fd9a70e3          	bgeu	s4,s9,80004310 <exec+0x100>
      n = sz - i;
    80004354:	8ad2                	mv	s5,s4
    80004356:	bf6d                	j	80004310 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004358:	4901                	li	s2,0
  iunlockput(ip);
    8000435a:	8526                	mv	a0,s1
    8000435c:	fffff097          	auipc	ra,0xfffff
    80004360:	c18080e7          	jalr	-1000(ra) # 80002f74 <iunlockput>
  end_op();
    80004364:	fffff097          	auipc	ra,0xfffff
    80004368:	400080e7          	jalr	1024(ra) # 80003764 <end_op>
  p = myproc();
    8000436c:	ffffd097          	auipc	ra,0xffffd
    80004370:	adc080e7          	jalr	-1316(ra) # 80000e48 <myproc>
    80004374:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004376:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000437a:	6785                	lui	a5,0x1
    8000437c:	17fd                	addi	a5,a5,-1
    8000437e:	993e                	add	s2,s2,a5
    80004380:	757d                	lui	a0,0xfffff
    80004382:	00a977b3          	and	a5,s2,a0
    80004386:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000438a:	6609                	lui	a2,0x2
    8000438c:	963e                	add	a2,a2,a5
    8000438e:	85be                	mv	a1,a5
    80004390:	855e                	mv	a0,s7
    80004392:	ffffc097          	auipc	ra,0xffffc
    80004396:	528080e7          	jalr	1320(ra) # 800008ba <uvmalloc>
    8000439a:	8b2a                	mv	s6,a0
  ip = 0;
    8000439c:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000439e:	12050c63          	beqz	a0,800044d6 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043a2:	75f9                	lui	a1,0xffffe
    800043a4:	95aa                	add	a1,a1,a0
    800043a6:	855e                	mv	a0,s7
    800043a8:	ffffc097          	auipc	ra,0xffffc
    800043ac:	730080e7          	jalr	1840(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    800043b0:	7c7d                	lui	s8,0xfffff
    800043b2:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800043b4:	e0043783          	ld	a5,-512(s0)
    800043b8:	6388                	ld	a0,0(a5)
    800043ba:	c535                	beqz	a0,80004426 <exec+0x216>
    800043bc:	e9040993          	addi	s3,s0,-368
    800043c0:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043c4:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800043c6:	ffffc097          	auipc	ra,0xffffc
    800043ca:	f36080e7          	jalr	-202(ra) # 800002fc <strlen>
    800043ce:	2505                	addiw	a0,a0,1
    800043d0:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043d4:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043d8:	13896363          	bltu	s2,s8,800044fe <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043dc:	e0043d83          	ld	s11,-512(s0)
    800043e0:	000dba03          	ld	s4,0(s11)
    800043e4:	8552                	mv	a0,s4
    800043e6:	ffffc097          	auipc	ra,0xffffc
    800043ea:	f16080e7          	jalr	-234(ra) # 800002fc <strlen>
    800043ee:	0015069b          	addiw	a3,a0,1
    800043f2:	8652                	mv	a2,s4
    800043f4:	85ca                	mv	a1,s2
    800043f6:	855e                	mv	a0,s7
    800043f8:	ffffc097          	auipc	ra,0xffffc
    800043fc:	712080e7          	jalr	1810(ra) # 80000b0a <copyout>
    80004400:	10054363          	bltz	a0,80004506 <exec+0x2f6>
    ustack[argc] = sp;
    80004404:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004408:	0485                	addi	s1,s1,1
    8000440a:	008d8793          	addi	a5,s11,8
    8000440e:	e0f43023          	sd	a5,-512(s0)
    80004412:	008db503          	ld	a0,8(s11)
    80004416:	c911                	beqz	a0,8000442a <exec+0x21a>
    if(argc >= MAXARG)
    80004418:	09a1                	addi	s3,s3,8
    8000441a:	fb3c96e3          	bne	s9,s3,800043c6 <exec+0x1b6>
  sz = sz1;
    8000441e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004422:	4481                	li	s1,0
    80004424:	a84d                	j	800044d6 <exec+0x2c6>
  sp = sz;
    80004426:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004428:	4481                	li	s1,0
  ustack[argc] = 0;
    8000442a:	00349793          	slli	a5,s1,0x3
    8000442e:	f9040713          	addi	a4,s0,-112
    80004432:	97ba                	add	a5,a5,a4
    80004434:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004438:	00148693          	addi	a3,s1,1
    8000443c:	068e                	slli	a3,a3,0x3
    8000443e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004442:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004446:	01897663          	bgeu	s2,s8,80004452 <exec+0x242>
  sz = sz1;
    8000444a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000444e:	4481                	li	s1,0
    80004450:	a059                	j	800044d6 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004452:	e9040613          	addi	a2,s0,-368
    80004456:	85ca                	mv	a1,s2
    80004458:	855e                	mv	a0,s7
    8000445a:	ffffc097          	auipc	ra,0xffffc
    8000445e:	6b0080e7          	jalr	1712(ra) # 80000b0a <copyout>
    80004462:	0a054663          	bltz	a0,8000450e <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004466:	058ab783          	ld	a5,88(s5)
    8000446a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000446e:	df843783          	ld	a5,-520(s0)
    80004472:	0007c703          	lbu	a4,0(a5)
    80004476:	cf11                	beqz	a4,80004492 <exec+0x282>
    80004478:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000447a:	02f00693          	li	a3,47
    8000447e:	a039                	j	8000448c <exec+0x27c>
      last = s+1;
    80004480:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004484:	0785                	addi	a5,a5,1
    80004486:	fff7c703          	lbu	a4,-1(a5)
    8000448a:	c701                	beqz	a4,80004492 <exec+0x282>
    if(*s == '/')
    8000448c:	fed71ce3          	bne	a4,a3,80004484 <exec+0x274>
    80004490:	bfc5                	j	80004480 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004492:	4641                	li	a2,16
    80004494:	df843583          	ld	a1,-520(s0)
    80004498:	158a8513          	addi	a0,s5,344
    8000449c:	ffffc097          	auipc	ra,0xffffc
    800044a0:	e2e080e7          	jalr	-466(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800044a4:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800044a8:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800044ac:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044b0:	058ab783          	ld	a5,88(s5)
    800044b4:	e6843703          	ld	a4,-408(s0)
    800044b8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044ba:	058ab783          	ld	a5,88(s5)
    800044be:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044c2:	85ea                	mv	a1,s10
    800044c4:	ffffd097          	auipc	ra,0xffffd
    800044c8:	ae4080e7          	jalr	-1308(ra) # 80000fa8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044cc:	0004851b          	sext.w	a0,s1
    800044d0:	bbe1                	j	800042a8 <exec+0x98>
    800044d2:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800044d6:	e0843583          	ld	a1,-504(s0)
    800044da:	855e                	mv	a0,s7
    800044dc:	ffffd097          	auipc	ra,0xffffd
    800044e0:	acc080e7          	jalr	-1332(ra) # 80000fa8 <proc_freepagetable>
  if(ip){
    800044e4:	da0498e3          	bnez	s1,80004294 <exec+0x84>
  return -1;
    800044e8:	557d                	li	a0,-1
    800044ea:	bb7d                	j	800042a8 <exec+0x98>
    800044ec:	e1243423          	sd	s2,-504(s0)
    800044f0:	b7dd                	j	800044d6 <exec+0x2c6>
    800044f2:	e1243423          	sd	s2,-504(s0)
    800044f6:	b7c5                	j	800044d6 <exec+0x2c6>
    800044f8:	e1243423          	sd	s2,-504(s0)
    800044fc:	bfe9                	j	800044d6 <exec+0x2c6>
  sz = sz1;
    800044fe:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004502:	4481                	li	s1,0
    80004504:	bfc9                	j	800044d6 <exec+0x2c6>
  sz = sz1;
    80004506:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000450a:	4481                	li	s1,0
    8000450c:	b7e9                	j	800044d6 <exec+0x2c6>
  sz = sz1;
    8000450e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004512:	4481                	li	s1,0
    80004514:	b7c9                	j	800044d6 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004516:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000451a:	2b05                	addiw	s6,s6,1
    8000451c:	0389899b          	addiw	s3,s3,56
    80004520:	e8845783          	lhu	a5,-376(s0)
    80004524:	e2fb5be3          	bge	s6,a5,8000435a <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004528:	2981                	sext.w	s3,s3
    8000452a:	03800713          	li	a4,56
    8000452e:	86ce                	mv	a3,s3
    80004530:	e1840613          	addi	a2,s0,-488
    80004534:	4581                	li	a1,0
    80004536:	8526                	mv	a0,s1
    80004538:	fffff097          	auipc	ra,0xfffff
    8000453c:	a8e080e7          	jalr	-1394(ra) # 80002fc6 <readi>
    80004540:	03800793          	li	a5,56
    80004544:	f8f517e3          	bne	a0,a5,800044d2 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004548:	e1842783          	lw	a5,-488(s0)
    8000454c:	4705                	li	a4,1
    8000454e:	fce796e3          	bne	a5,a4,8000451a <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004552:	e4043603          	ld	a2,-448(s0)
    80004556:	e3843783          	ld	a5,-456(s0)
    8000455a:	f8f669e3          	bltu	a2,a5,800044ec <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000455e:	e2843783          	ld	a5,-472(s0)
    80004562:	963e                	add	a2,a2,a5
    80004564:	f8f667e3          	bltu	a2,a5,800044f2 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004568:	85ca                	mv	a1,s2
    8000456a:	855e                	mv	a0,s7
    8000456c:	ffffc097          	auipc	ra,0xffffc
    80004570:	34e080e7          	jalr	846(ra) # 800008ba <uvmalloc>
    80004574:	e0a43423          	sd	a0,-504(s0)
    80004578:	d141                	beqz	a0,800044f8 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000457a:	e2843d03          	ld	s10,-472(s0)
    8000457e:	df043783          	ld	a5,-528(s0)
    80004582:	00fd77b3          	and	a5,s10,a5
    80004586:	fba1                	bnez	a5,800044d6 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004588:	e2042d83          	lw	s11,-480(s0)
    8000458c:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004590:	f80c03e3          	beqz	s8,80004516 <exec+0x306>
    80004594:	8a62                	mv	s4,s8
    80004596:	4901                	li	s2,0
    80004598:	b345                	j	80004338 <exec+0x128>

000000008000459a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000459a:	7179                	addi	sp,sp,-48
    8000459c:	f406                	sd	ra,40(sp)
    8000459e:	f022                	sd	s0,32(sp)
    800045a0:	ec26                	sd	s1,24(sp)
    800045a2:	e84a                	sd	s2,16(sp)
    800045a4:	1800                	addi	s0,sp,48
    800045a6:	892e                	mv	s2,a1
    800045a8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045aa:	fdc40593          	addi	a1,s0,-36
    800045ae:	ffffe097          	auipc	ra,0xffffe
    800045b2:	a68080e7          	jalr	-1432(ra) # 80002016 <argint>
    800045b6:	04054063          	bltz	a0,800045f6 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045ba:	fdc42703          	lw	a4,-36(s0)
    800045be:	47bd                	li	a5,15
    800045c0:	02e7ed63          	bltu	a5,a4,800045fa <argfd+0x60>
    800045c4:	ffffd097          	auipc	ra,0xffffd
    800045c8:	884080e7          	jalr	-1916(ra) # 80000e48 <myproc>
    800045cc:	fdc42703          	lw	a4,-36(s0)
    800045d0:	01a70793          	addi	a5,a4,26
    800045d4:	078e                	slli	a5,a5,0x3
    800045d6:	953e                	add	a0,a0,a5
    800045d8:	611c                	ld	a5,0(a0)
    800045da:	c395                	beqz	a5,800045fe <argfd+0x64>
    return -1;
  if(pfd)
    800045dc:	00090463          	beqz	s2,800045e4 <argfd+0x4a>
    *pfd = fd;
    800045e0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045e4:	4501                	li	a0,0
  if(pf)
    800045e6:	c091                	beqz	s1,800045ea <argfd+0x50>
    *pf = f;
    800045e8:	e09c                	sd	a5,0(s1)
}
    800045ea:	70a2                	ld	ra,40(sp)
    800045ec:	7402                	ld	s0,32(sp)
    800045ee:	64e2                	ld	s1,24(sp)
    800045f0:	6942                	ld	s2,16(sp)
    800045f2:	6145                	addi	sp,sp,48
    800045f4:	8082                	ret
    return -1;
    800045f6:	557d                	li	a0,-1
    800045f8:	bfcd                	j	800045ea <argfd+0x50>
    return -1;
    800045fa:	557d                	li	a0,-1
    800045fc:	b7fd                	j	800045ea <argfd+0x50>
    800045fe:	557d                	li	a0,-1
    80004600:	b7ed                	j	800045ea <argfd+0x50>

0000000080004602 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004602:	1101                	addi	sp,sp,-32
    80004604:	ec06                	sd	ra,24(sp)
    80004606:	e822                	sd	s0,16(sp)
    80004608:	e426                	sd	s1,8(sp)
    8000460a:	1000                	addi	s0,sp,32
    8000460c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000460e:	ffffd097          	auipc	ra,0xffffd
    80004612:	83a080e7          	jalr	-1990(ra) # 80000e48 <myproc>
    80004616:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004618:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd4e90>
    8000461c:	4501                	li	a0,0
    8000461e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004620:	6398                	ld	a4,0(a5)
    80004622:	cb19                	beqz	a4,80004638 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004624:	2505                	addiw	a0,a0,1
    80004626:	07a1                	addi	a5,a5,8
    80004628:	fed51ce3          	bne	a0,a3,80004620 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000462c:	557d                	li	a0,-1
}
    8000462e:	60e2                	ld	ra,24(sp)
    80004630:	6442                	ld	s0,16(sp)
    80004632:	64a2                	ld	s1,8(sp)
    80004634:	6105                	addi	sp,sp,32
    80004636:	8082                	ret
      p->ofile[fd] = f;
    80004638:	01a50793          	addi	a5,a0,26
    8000463c:	078e                	slli	a5,a5,0x3
    8000463e:	963e                	add	a2,a2,a5
    80004640:	e204                	sd	s1,0(a2)
      return fd;
    80004642:	b7f5                	j	8000462e <fdalloc+0x2c>

0000000080004644 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004644:	715d                	addi	sp,sp,-80
    80004646:	e486                	sd	ra,72(sp)
    80004648:	e0a2                	sd	s0,64(sp)
    8000464a:	fc26                	sd	s1,56(sp)
    8000464c:	f84a                	sd	s2,48(sp)
    8000464e:	f44e                	sd	s3,40(sp)
    80004650:	f052                	sd	s4,32(sp)
    80004652:	ec56                	sd	s5,24(sp)
    80004654:	0880                	addi	s0,sp,80
    80004656:	89ae                	mv	s3,a1
    80004658:	8ab2                	mv	s5,a2
    8000465a:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000465c:	fb040593          	addi	a1,s0,-80
    80004660:	fffff097          	auipc	ra,0xfffff
    80004664:	e86080e7          	jalr	-378(ra) # 800034e6 <nameiparent>
    80004668:	892a                	mv	s2,a0
    8000466a:	12050f63          	beqz	a0,800047a8 <create+0x164>
    return 0;

  ilock(dp);
    8000466e:	ffffe097          	auipc	ra,0xffffe
    80004672:	6a4080e7          	jalr	1700(ra) # 80002d12 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004676:	4601                	li	a2,0
    80004678:	fb040593          	addi	a1,s0,-80
    8000467c:	854a                	mv	a0,s2
    8000467e:	fffff097          	auipc	ra,0xfffff
    80004682:	b78080e7          	jalr	-1160(ra) # 800031f6 <dirlookup>
    80004686:	84aa                	mv	s1,a0
    80004688:	c921                	beqz	a0,800046d8 <create+0x94>
    iunlockput(dp);
    8000468a:	854a                	mv	a0,s2
    8000468c:	fffff097          	auipc	ra,0xfffff
    80004690:	8e8080e7          	jalr	-1816(ra) # 80002f74 <iunlockput>
    ilock(ip);
    80004694:	8526                	mv	a0,s1
    80004696:	ffffe097          	auipc	ra,0xffffe
    8000469a:	67c080e7          	jalr	1660(ra) # 80002d12 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000469e:	2981                	sext.w	s3,s3
    800046a0:	4789                	li	a5,2
    800046a2:	02f99463          	bne	s3,a5,800046ca <create+0x86>
    800046a6:	0444d783          	lhu	a5,68(s1)
    800046aa:	37f9                	addiw	a5,a5,-2
    800046ac:	17c2                	slli	a5,a5,0x30
    800046ae:	93c1                	srli	a5,a5,0x30
    800046b0:	4705                	li	a4,1
    800046b2:	00f76c63          	bltu	a4,a5,800046ca <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046b6:	8526                	mv	a0,s1
    800046b8:	60a6                	ld	ra,72(sp)
    800046ba:	6406                	ld	s0,64(sp)
    800046bc:	74e2                	ld	s1,56(sp)
    800046be:	7942                	ld	s2,48(sp)
    800046c0:	79a2                	ld	s3,40(sp)
    800046c2:	7a02                	ld	s4,32(sp)
    800046c4:	6ae2                	ld	s5,24(sp)
    800046c6:	6161                	addi	sp,sp,80
    800046c8:	8082                	ret
    iunlockput(ip);
    800046ca:	8526                	mv	a0,s1
    800046cc:	fffff097          	auipc	ra,0xfffff
    800046d0:	8a8080e7          	jalr	-1880(ra) # 80002f74 <iunlockput>
    return 0;
    800046d4:	4481                	li	s1,0
    800046d6:	b7c5                	j	800046b6 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046d8:	85ce                	mv	a1,s3
    800046da:	00092503          	lw	a0,0(s2)
    800046de:	ffffe097          	auipc	ra,0xffffe
    800046e2:	49c080e7          	jalr	1180(ra) # 80002b7a <ialloc>
    800046e6:	84aa                	mv	s1,a0
    800046e8:	c529                	beqz	a0,80004732 <create+0xee>
  ilock(ip);
    800046ea:	ffffe097          	auipc	ra,0xffffe
    800046ee:	628080e7          	jalr	1576(ra) # 80002d12 <ilock>
  ip->major = major;
    800046f2:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800046f6:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800046fa:	4785                	li	a5,1
    800046fc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004700:	8526                	mv	a0,s1
    80004702:	ffffe097          	auipc	ra,0xffffe
    80004706:	546080e7          	jalr	1350(ra) # 80002c48 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000470a:	2981                	sext.w	s3,s3
    8000470c:	4785                	li	a5,1
    8000470e:	02f98a63          	beq	s3,a5,80004742 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004712:	40d0                	lw	a2,4(s1)
    80004714:	fb040593          	addi	a1,s0,-80
    80004718:	854a                	mv	a0,s2
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	cec080e7          	jalr	-788(ra) # 80003406 <dirlink>
    80004722:	06054b63          	bltz	a0,80004798 <create+0x154>
  iunlockput(dp);
    80004726:	854a                	mv	a0,s2
    80004728:	fffff097          	auipc	ra,0xfffff
    8000472c:	84c080e7          	jalr	-1972(ra) # 80002f74 <iunlockput>
  return ip;
    80004730:	b759                	j	800046b6 <create+0x72>
    panic("create: ialloc");
    80004732:	00004517          	auipc	a0,0x4
    80004736:	f4650513          	addi	a0,a0,-186 # 80008678 <syscalls+0x2b0>
    8000473a:	00001097          	auipc	ra,0x1
    8000473e:	68e080e7          	jalr	1678(ra) # 80005dc8 <panic>
    dp->nlink++;  // for ".."
    80004742:	04a95783          	lhu	a5,74(s2)
    80004746:	2785                	addiw	a5,a5,1
    80004748:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000474c:	854a                	mv	a0,s2
    8000474e:	ffffe097          	auipc	ra,0xffffe
    80004752:	4fa080e7          	jalr	1274(ra) # 80002c48 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004756:	40d0                	lw	a2,4(s1)
    80004758:	00004597          	auipc	a1,0x4
    8000475c:	f3058593          	addi	a1,a1,-208 # 80008688 <syscalls+0x2c0>
    80004760:	8526                	mv	a0,s1
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	ca4080e7          	jalr	-860(ra) # 80003406 <dirlink>
    8000476a:	00054f63          	bltz	a0,80004788 <create+0x144>
    8000476e:	00492603          	lw	a2,4(s2)
    80004772:	00004597          	auipc	a1,0x4
    80004776:	f1e58593          	addi	a1,a1,-226 # 80008690 <syscalls+0x2c8>
    8000477a:	8526                	mv	a0,s1
    8000477c:	fffff097          	auipc	ra,0xfffff
    80004780:	c8a080e7          	jalr	-886(ra) # 80003406 <dirlink>
    80004784:	f80557e3          	bgez	a0,80004712 <create+0xce>
      panic("create dots");
    80004788:	00004517          	auipc	a0,0x4
    8000478c:	f1050513          	addi	a0,a0,-240 # 80008698 <syscalls+0x2d0>
    80004790:	00001097          	auipc	ra,0x1
    80004794:	638080e7          	jalr	1592(ra) # 80005dc8 <panic>
    panic("create: dirlink");
    80004798:	00004517          	auipc	a0,0x4
    8000479c:	f1050513          	addi	a0,a0,-240 # 800086a8 <syscalls+0x2e0>
    800047a0:	00001097          	auipc	ra,0x1
    800047a4:	628080e7          	jalr	1576(ra) # 80005dc8 <panic>
    return 0;
    800047a8:	84aa                	mv	s1,a0
    800047aa:	b731                	j	800046b6 <create+0x72>

00000000800047ac <sys_dup>:
{
    800047ac:	7179                	addi	sp,sp,-48
    800047ae:	f406                	sd	ra,40(sp)
    800047b0:	f022                	sd	s0,32(sp)
    800047b2:	ec26                	sd	s1,24(sp)
    800047b4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047b6:	fd840613          	addi	a2,s0,-40
    800047ba:	4581                	li	a1,0
    800047bc:	4501                	li	a0,0
    800047be:	00000097          	auipc	ra,0x0
    800047c2:	ddc080e7          	jalr	-548(ra) # 8000459a <argfd>
    return -1;
    800047c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047c8:	02054363          	bltz	a0,800047ee <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800047cc:	fd843503          	ld	a0,-40(s0)
    800047d0:	00000097          	auipc	ra,0x0
    800047d4:	e32080e7          	jalr	-462(ra) # 80004602 <fdalloc>
    800047d8:	84aa                	mv	s1,a0
    return -1;
    800047da:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047dc:	00054963          	bltz	a0,800047ee <sys_dup+0x42>
  filedup(f);
    800047e0:	fd843503          	ld	a0,-40(s0)
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	37a080e7          	jalr	890(ra) # 80003b5e <filedup>
  return fd;
    800047ec:	87a6                	mv	a5,s1
}
    800047ee:	853e                	mv	a0,a5
    800047f0:	70a2                	ld	ra,40(sp)
    800047f2:	7402                	ld	s0,32(sp)
    800047f4:	64e2                	ld	s1,24(sp)
    800047f6:	6145                	addi	sp,sp,48
    800047f8:	8082                	ret

00000000800047fa <sys_read>:
{
    800047fa:	7179                	addi	sp,sp,-48
    800047fc:	f406                	sd	ra,40(sp)
    800047fe:	f022                	sd	s0,32(sp)
    80004800:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004802:	fe840613          	addi	a2,s0,-24
    80004806:	4581                	li	a1,0
    80004808:	4501                	li	a0,0
    8000480a:	00000097          	auipc	ra,0x0
    8000480e:	d90080e7          	jalr	-624(ra) # 8000459a <argfd>
    return -1;
    80004812:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004814:	04054163          	bltz	a0,80004856 <sys_read+0x5c>
    80004818:	fe440593          	addi	a1,s0,-28
    8000481c:	4509                	li	a0,2
    8000481e:	ffffd097          	auipc	ra,0xffffd
    80004822:	7f8080e7          	jalr	2040(ra) # 80002016 <argint>
    return -1;
    80004826:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004828:	02054763          	bltz	a0,80004856 <sys_read+0x5c>
    8000482c:	fd840593          	addi	a1,s0,-40
    80004830:	4505                	li	a0,1
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	806080e7          	jalr	-2042(ra) # 80002038 <argaddr>
    return -1;
    8000483a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000483c:	00054d63          	bltz	a0,80004856 <sys_read+0x5c>
  return fileread(f, p, n);
    80004840:	fe442603          	lw	a2,-28(s0)
    80004844:	fd843583          	ld	a1,-40(s0)
    80004848:	fe843503          	ld	a0,-24(s0)
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	49e080e7          	jalr	1182(ra) # 80003cea <fileread>
    80004854:	87aa                	mv	a5,a0
}
    80004856:	853e                	mv	a0,a5
    80004858:	70a2                	ld	ra,40(sp)
    8000485a:	7402                	ld	s0,32(sp)
    8000485c:	6145                	addi	sp,sp,48
    8000485e:	8082                	ret

0000000080004860 <sys_write>:
{
    80004860:	7179                	addi	sp,sp,-48
    80004862:	f406                	sd	ra,40(sp)
    80004864:	f022                	sd	s0,32(sp)
    80004866:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004868:	fe840613          	addi	a2,s0,-24
    8000486c:	4581                	li	a1,0
    8000486e:	4501                	li	a0,0
    80004870:	00000097          	auipc	ra,0x0
    80004874:	d2a080e7          	jalr	-726(ra) # 8000459a <argfd>
    return -1;
    80004878:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000487a:	04054163          	bltz	a0,800048bc <sys_write+0x5c>
    8000487e:	fe440593          	addi	a1,s0,-28
    80004882:	4509                	li	a0,2
    80004884:	ffffd097          	auipc	ra,0xffffd
    80004888:	792080e7          	jalr	1938(ra) # 80002016 <argint>
    return -1;
    8000488c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000488e:	02054763          	bltz	a0,800048bc <sys_write+0x5c>
    80004892:	fd840593          	addi	a1,s0,-40
    80004896:	4505                	li	a0,1
    80004898:	ffffd097          	auipc	ra,0xffffd
    8000489c:	7a0080e7          	jalr	1952(ra) # 80002038 <argaddr>
    return -1;
    800048a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a2:	00054d63          	bltz	a0,800048bc <sys_write+0x5c>
  return filewrite(f, p, n);
    800048a6:	fe442603          	lw	a2,-28(s0)
    800048aa:	fd843583          	ld	a1,-40(s0)
    800048ae:	fe843503          	ld	a0,-24(s0)
    800048b2:	fffff097          	auipc	ra,0xfffff
    800048b6:	4fa080e7          	jalr	1274(ra) # 80003dac <filewrite>
    800048ba:	87aa                	mv	a5,a0
}
    800048bc:	853e                	mv	a0,a5
    800048be:	70a2                	ld	ra,40(sp)
    800048c0:	7402                	ld	s0,32(sp)
    800048c2:	6145                	addi	sp,sp,48
    800048c4:	8082                	ret

00000000800048c6 <sys_close>:
{
    800048c6:	1101                	addi	sp,sp,-32
    800048c8:	ec06                	sd	ra,24(sp)
    800048ca:	e822                	sd	s0,16(sp)
    800048cc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048ce:	fe040613          	addi	a2,s0,-32
    800048d2:	fec40593          	addi	a1,s0,-20
    800048d6:	4501                	li	a0,0
    800048d8:	00000097          	auipc	ra,0x0
    800048dc:	cc2080e7          	jalr	-830(ra) # 8000459a <argfd>
    return -1;
    800048e0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048e2:	02054463          	bltz	a0,8000490a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048e6:	ffffc097          	auipc	ra,0xffffc
    800048ea:	562080e7          	jalr	1378(ra) # 80000e48 <myproc>
    800048ee:	fec42783          	lw	a5,-20(s0)
    800048f2:	07e9                	addi	a5,a5,26
    800048f4:	078e                	slli	a5,a5,0x3
    800048f6:	97aa                	add	a5,a5,a0
    800048f8:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800048fc:	fe043503          	ld	a0,-32(s0)
    80004900:	fffff097          	auipc	ra,0xfffff
    80004904:	2b0080e7          	jalr	688(ra) # 80003bb0 <fileclose>
  return 0;
    80004908:	4781                	li	a5,0
}
    8000490a:	853e                	mv	a0,a5
    8000490c:	60e2                	ld	ra,24(sp)
    8000490e:	6442                	ld	s0,16(sp)
    80004910:	6105                	addi	sp,sp,32
    80004912:	8082                	ret

0000000080004914 <sys_fstat>:
{
    80004914:	1101                	addi	sp,sp,-32
    80004916:	ec06                	sd	ra,24(sp)
    80004918:	e822                	sd	s0,16(sp)
    8000491a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000491c:	fe840613          	addi	a2,s0,-24
    80004920:	4581                	li	a1,0
    80004922:	4501                	li	a0,0
    80004924:	00000097          	auipc	ra,0x0
    80004928:	c76080e7          	jalr	-906(ra) # 8000459a <argfd>
    return -1;
    8000492c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000492e:	02054563          	bltz	a0,80004958 <sys_fstat+0x44>
    80004932:	fe040593          	addi	a1,s0,-32
    80004936:	4505                	li	a0,1
    80004938:	ffffd097          	auipc	ra,0xffffd
    8000493c:	700080e7          	jalr	1792(ra) # 80002038 <argaddr>
    return -1;
    80004940:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004942:	00054b63          	bltz	a0,80004958 <sys_fstat+0x44>
  return filestat(f, st);
    80004946:	fe043583          	ld	a1,-32(s0)
    8000494a:	fe843503          	ld	a0,-24(s0)
    8000494e:	fffff097          	auipc	ra,0xfffff
    80004952:	32a080e7          	jalr	810(ra) # 80003c78 <filestat>
    80004956:	87aa                	mv	a5,a0
}
    80004958:	853e                	mv	a0,a5
    8000495a:	60e2                	ld	ra,24(sp)
    8000495c:	6442                	ld	s0,16(sp)
    8000495e:	6105                	addi	sp,sp,32
    80004960:	8082                	ret

0000000080004962 <sys_link>:
{
    80004962:	7169                	addi	sp,sp,-304
    80004964:	f606                	sd	ra,296(sp)
    80004966:	f222                	sd	s0,288(sp)
    80004968:	ee26                	sd	s1,280(sp)
    8000496a:	ea4a                	sd	s2,272(sp)
    8000496c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000496e:	08000613          	li	a2,128
    80004972:	ed040593          	addi	a1,s0,-304
    80004976:	4501                	li	a0,0
    80004978:	ffffd097          	auipc	ra,0xffffd
    8000497c:	6e2080e7          	jalr	1762(ra) # 8000205a <argstr>
    return -1;
    80004980:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004982:	10054e63          	bltz	a0,80004a9e <sys_link+0x13c>
    80004986:	08000613          	li	a2,128
    8000498a:	f5040593          	addi	a1,s0,-176
    8000498e:	4505                	li	a0,1
    80004990:	ffffd097          	auipc	ra,0xffffd
    80004994:	6ca080e7          	jalr	1738(ra) # 8000205a <argstr>
    return -1;
    80004998:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000499a:	10054263          	bltz	a0,80004a9e <sys_link+0x13c>
  begin_op();
    8000499e:	fffff097          	auipc	ra,0xfffff
    800049a2:	d46080e7          	jalr	-698(ra) # 800036e4 <begin_op>
  if((ip = namei(old)) == 0){
    800049a6:	ed040513          	addi	a0,s0,-304
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	b1e080e7          	jalr	-1250(ra) # 800034c8 <namei>
    800049b2:	84aa                	mv	s1,a0
    800049b4:	c551                	beqz	a0,80004a40 <sys_link+0xde>
  ilock(ip);
    800049b6:	ffffe097          	auipc	ra,0xffffe
    800049ba:	35c080e7          	jalr	860(ra) # 80002d12 <ilock>
  if(ip->type == T_DIR){
    800049be:	04449703          	lh	a4,68(s1)
    800049c2:	4785                	li	a5,1
    800049c4:	08f70463          	beq	a4,a5,80004a4c <sys_link+0xea>
  ip->nlink++;
    800049c8:	04a4d783          	lhu	a5,74(s1)
    800049cc:	2785                	addiw	a5,a5,1
    800049ce:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049d2:	8526                	mv	a0,s1
    800049d4:	ffffe097          	auipc	ra,0xffffe
    800049d8:	274080e7          	jalr	628(ra) # 80002c48 <iupdate>
  iunlock(ip);
    800049dc:	8526                	mv	a0,s1
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	3f6080e7          	jalr	1014(ra) # 80002dd4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049e6:	fd040593          	addi	a1,s0,-48
    800049ea:	f5040513          	addi	a0,s0,-176
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	af8080e7          	jalr	-1288(ra) # 800034e6 <nameiparent>
    800049f6:	892a                	mv	s2,a0
    800049f8:	c935                	beqz	a0,80004a6c <sys_link+0x10a>
  ilock(dp);
    800049fa:	ffffe097          	auipc	ra,0xffffe
    800049fe:	318080e7          	jalr	792(ra) # 80002d12 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a02:	00092703          	lw	a4,0(s2)
    80004a06:	409c                	lw	a5,0(s1)
    80004a08:	04f71d63          	bne	a4,a5,80004a62 <sys_link+0x100>
    80004a0c:	40d0                	lw	a2,4(s1)
    80004a0e:	fd040593          	addi	a1,s0,-48
    80004a12:	854a                	mv	a0,s2
    80004a14:	fffff097          	auipc	ra,0xfffff
    80004a18:	9f2080e7          	jalr	-1550(ra) # 80003406 <dirlink>
    80004a1c:	04054363          	bltz	a0,80004a62 <sys_link+0x100>
  iunlockput(dp);
    80004a20:	854a                	mv	a0,s2
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	552080e7          	jalr	1362(ra) # 80002f74 <iunlockput>
  iput(ip);
    80004a2a:	8526                	mv	a0,s1
    80004a2c:	ffffe097          	auipc	ra,0xffffe
    80004a30:	4a0080e7          	jalr	1184(ra) # 80002ecc <iput>
  end_op();
    80004a34:	fffff097          	auipc	ra,0xfffff
    80004a38:	d30080e7          	jalr	-720(ra) # 80003764 <end_op>
  return 0;
    80004a3c:	4781                	li	a5,0
    80004a3e:	a085                	j	80004a9e <sys_link+0x13c>
    end_op();
    80004a40:	fffff097          	auipc	ra,0xfffff
    80004a44:	d24080e7          	jalr	-732(ra) # 80003764 <end_op>
    return -1;
    80004a48:	57fd                	li	a5,-1
    80004a4a:	a891                	j	80004a9e <sys_link+0x13c>
    iunlockput(ip);
    80004a4c:	8526                	mv	a0,s1
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	526080e7          	jalr	1318(ra) # 80002f74 <iunlockput>
    end_op();
    80004a56:	fffff097          	auipc	ra,0xfffff
    80004a5a:	d0e080e7          	jalr	-754(ra) # 80003764 <end_op>
    return -1;
    80004a5e:	57fd                	li	a5,-1
    80004a60:	a83d                	j	80004a9e <sys_link+0x13c>
    iunlockput(dp);
    80004a62:	854a                	mv	a0,s2
    80004a64:	ffffe097          	auipc	ra,0xffffe
    80004a68:	510080e7          	jalr	1296(ra) # 80002f74 <iunlockput>
  ilock(ip);
    80004a6c:	8526                	mv	a0,s1
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	2a4080e7          	jalr	676(ra) # 80002d12 <ilock>
  ip->nlink--;
    80004a76:	04a4d783          	lhu	a5,74(s1)
    80004a7a:	37fd                	addiw	a5,a5,-1
    80004a7c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a80:	8526                	mv	a0,s1
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	1c6080e7          	jalr	454(ra) # 80002c48 <iupdate>
  iunlockput(ip);
    80004a8a:	8526                	mv	a0,s1
    80004a8c:	ffffe097          	auipc	ra,0xffffe
    80004a90:	4e8080e7          	jalr	1256(ra) # 80002f74 <iunlockput>
  end_op();
    80004a94:	fffff097          	auipc	ra,0xfffff
    80004a98:	cd0080e7          	jalr	-816(ra) # 80003764 <end_op>
  return -1;
    80004a9c:	57fd                	li	a5,-1
}
    80004a9e:	853e                	mv	a0,a5
    80004aa0:	70b2                	ld	ra,296(sp)
    80004aa2:	7412                	ld	s0,288(sp)
    80004aa4:	64f2                	ld	s1,280(sp)
    80004aa6:	6952                	ld	s2,272(sp)
    80004aa8:	6155                	addi	sp,sp,304
    80004aaa:	8082                	ret

0000000080004aac <sys_unlink>:
{
    80004aac:	7151                	addi	sp,sp,-240
    80004aae:	f586                	sd	ra,232(sp)
    80004ab0:	f1a2                	sd	s0,224(sp)
    80004ab2:	eda6                	sd	s1,216(sp)
    80004ab4:	e9ca                	sd	s2,208(sp)
    80004ab6:	e5ce                	sd	s3,200(sp)
    80004ab8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004aba:	08000613          	li	a2,128
    80004abe:	f3040593          	addi	a1,s0,-208
    80004ac2:	4501                	li	a0,0
    80004ac4:	ffffd097          	auipc	ra,0xffffd
    80004ac8:	596080e7          	jalr	1430(ra) # 8000205a <argstr>
    80004acc:	18054163          	bltz	a0,80004c4e <sys_unlink+0x1a2>
  begin_op();
    80004ad0:	fffff097          	auipc	ra,0xfffff
    80004ad4:	c14080e7          	jalr	-1004(ra) # 800036e4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ad8:	fb040593          	addi	a1,s0,-80
    80004adc:	f3040513          	addi	a0,s0,-208
    80004ae0:	fffff097          	auipc	ra,0xfffff
    80004ae4:	a06080e7          	jalr	-1530(ra) # 800034e6 <nameiparent>
    80004ae8:	84aa                	mv	s1,a0
    80004aea:	c979                	beqz	a0,80004bc0 <sys_unlink+0x114>
  ilock(dp);
    80004aec:	ffffe097          	auipc	ra,0xffffe
    80004af0:	226080e7          	jalr	550(ra) # 80002d12 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004af4:	00004597          	auipc	a1,0x4
    80004af8:	b9458593          	addi	a1,a1,-1132 # 80008688 <syscalls+0x2c0>
    80004afc:	fb040513          	addi	a0,s0,-80
    80004b00:	ffffe097          	auipc	ra,0xffffe
    80004b04:	6dc080e7          	jalr	1756(ra) # 800031dc <namecmp>
    80004b08:	14050a63          	beqz	a0,80004c5c <sys_unlink+0x1b0>
    80004b0c:	00004597          	auipc	a1,0x4
    80004b10:	b8458593          	addi	a1,a1,-1148 # 80008690 <syscalls+0x2c8>
    80004b14:	fb040513          	addi	a0,s0,-80
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	6c4080e7          	jalr	1732(ra) # 800031dc <namecmp>
    80004b20:	12050e63          	beqz	a0,80004c5c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b24:	f2c40613          	addi	a2,s0,-212
    80004b28:	fb040593          	addi	a1,s0,-80
    80004b2c:	8526                	mv	a0,s1
    80004b2e:	ffffe097          	auipc	ra,0xffffe
    80004b32:	6c8080e7          	jalr	1736(ra) # 800031f6 <dirlookup>
    80004b36:	892a                	mv	s2,a0
    80004b38:	12050263          	beqz	a0,80004c5c <sys_unlink+0x1b0>
  ilock(ip);
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	1d6080e7          	jalr	470(ra) # 80002d12 <ilock>
  if(ip->nlink < 1)
    80004b44:	04a91783          	lh	a5,74(s2)
    80004b48:	08f05263          	blez	a5,80004bcc <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b4c:	04491703          	lh	a4,68(s2)
    80004b50:	4785                	li	a5,1
    80004b52:	08f70563          	beq	a4,a5,80004bdc <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b56:	4641                	li	a2,16
    80004b58:	4581                	li	a1,0
    80004b5a:	fc040513          	addi	a0,s0,-64
    80004b5e:	ffffb097          	auipc	ra,0xffffb
    80004b62:	61a080e7          	jalr	1562(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b66:	4741                	li	a4,16
    80004b68:	f2c42683          	lw	a3,-212(s0)
    80004b6c:	fc040613          	addi	a2,s0,-64
    80004b70:	4581                	li	a1,0
    80004b72:	8526                	mv	a0,s1
    80004b74:	ffffe097          	auipc	ra,0xffffe
    80004b78:	54a080e7          	jalr	1354(ra) # 800030be <writei>
    80004b7c:	47c1                	li	a5,16
    80004b7e:	0af51563          	bne	a0,a5,80004c28 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b82:	04491703          	lh	a4,68(s2)
    80004b86:	4785                	li	a5,1
    80004b88:	0af70863          	beq	a4,a5,80004c38 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b8c:	8526                	mv	a0,s1
    80004b8e:	ffffe097          	auipc	ra,0xffffe
    80004b92:	3e6080e7          	jalr	998(ra) # 80002f74 <iunlockput>
  ip->nlink--;
    80004b96:	04a95783          	lhu	a5,74(s2)
    80004b9a:	37fd                	addiw	a5,a5,-1
    80004b9c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ba0:	854a                	mv	a0,s2
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	0a6080e7          	jalr	166(ra) # 80002c48 <iupdate>
  iunlockput(ip);
    80004baa:	854a                	mv	a0,s2
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	3c8080e7          	jalr	968(ra) # 80002f74 <iunlockput>
  end_op();
    80004bb4:	fffff097          	auipc	ra,0xfffff
    80004bb8:	bb0080e7          	jalr	-1104(ra) # 80003764 <end_op>
  return 0;
    80004bbc:	4501                	li	a0,0
    80004bbe:	a84d                	j	80004c70 <sys_unlink+0x1c4>
    end_op();
    80004bc0:	fffff097          	auipc	ra,0xfffff
    80004bc4:	ba4080e7          	jalr	-1116(ra) # 80003764 <end_op>
    return -1;
    80004bc8:	557d                	li	a0,-1
    80004bca:	a05d                	j	80004c70 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004bcc:	00004517          	auipc	a0,0x4
    80004bd0:	aec50513          	addi	a0,a0,-1300 # 800086b8 <syscalls+0x2f0>
    80004bd4:	00001097          	auipc	ra,0x1
    80004bd8:	1f4080e7          	jalr	500(ra) # 80005dc8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bdc:	04c92703          	lw	a4,76(s2)
    80004be0:	02000793          	li	a5,32
    80004be4:	f6e7f9e3          	bgeu	a5,a4,80004b56 <sys_unlink+0xaa>
    80004be8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bec:	4741                	li	a4,16
    80004bee:	86ce                	mv	a3,s3
    80004bf0:	f1840613          	addi	a2,s0,-232
    80004bf4:	4581                	li	a1,0
    80004bf6:	854a                	mv	a0,s2
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	3ce080e7          	jalr	974(ra) # 80002fc6 <readi>
    80004c00:	47c1                	li	a5,16
    80004c02:	00f51b63          	bne	a0,a5,80004c18 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c06:	f1845783          	lhu	a5,-232(s0)
    80004c0a:	e7a1                	bnez	a5,80004c52 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c0c:	29c1                	addiw	s3,s3,16
    80004c0e:	04c92783          	lw	a5,76(s2)
    80004c12:	fcf9ede3          	bltu	s3,a5,80004bec <sys_unlink+0x140>
    80004c16:	b781                	j	80004b56 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c18:	00004517          	auipc	a0,0x4
    80004c1c:	ab850513          	addi	a0,a0,-1352 # 800086d0 <syscalls+0x308>
    80004c20:	00001097          	auipc	ra,0x1
    80004c24:	1a8080e7          	jalr	424(ra) # 80005dc8 <panic>
    panic("unlink: writei");
    80004c28:	00004517          	auipc	a0,0x4
    80004c2c:	ac050513          	addi	a0,a0,-1344 # 800086e8 <syscalls+0x320>
    80004c30:	00001097          	auipc	ra,0x1
    80004c34:	198080e7          	jalr	408(ra) # 80005dc8 <panic>
    dp->nlink--;
    80004c38:	04a4d783          	lhu	a5,74(s1)
    80004c3c:	37fd                	addiw	a5,a5,-1
    80004c3e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c42:	8526                	mv	a0,s1
    80004c44:	ffffe097          	auipc	ra,0xffffe
    80004c48:	004080e7          	jalr	4(ra) # 80002c48 <iupdate>
    80004c4c:	b781                	j	80004b8c <sys_unlink+0xe0>
    return -1;
    80004c4e:	557d                	li	a0,-1
    80004c50:	a005                	j	80004c70 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c52:	854a                	mv	a0,s2
    80004c54:	ffffe097          	auipc	ra,0xffffe
    80004c58:	320080e7          	jalr	800(ra) # 80002f74 <iunlockput>
  iunlockput(dp);
    80004c5c:	8526                	mv	a0,s1
    80004c5e:	ffffe097          	auipc	ra,0xffffe
    80004c62:	316080e7          	jalr	790(ra) # 80002f74 <iunlockput>
  end_op();
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	afe080e7          	jalr	-1282(ra) # 80003764 <end_op>
  return -1;
    80004c6e:	557d                	li	a0,-1
}
    80004c70:	70ae                	ld	ra,232(sp)
    80004c72:	740e                	ld	s0,224(sp)
    80004c74:	64ee                	ld	s1,216(sp)
    80004c76:	694e                	ld	s2,208(sp)
    80004c78:	69ae                	ld	s3,200(sp)
    80004c7a:	616d                	addi	sp,sp,240
    80004c7c:	8082                	ret

0000000080004c7e <sys_open>:

uint64
sys_open(void)
{
    80004c7e:	7131                	addi	sp,sp,-192
    80004c80:	fd06                	sd	ra,184(sp)
    80004c82:	f922                	sd	s0,176(sp)
    80004c84:	f526                	sd	s1,168(sp)
    80004c86:	f14a                	sd	s2,160(sp)
    80004c88:	ed4e                	sd	s3,152(sp)
    80004c8a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c8c:	08000613          	li	a2,128
    80004c90:	f5040593          	addi	a1,s0,-176
    80004c94:	4501                	li	a0,0
    80004c96:	ffffd097          	auipc	ra,0xffffd
    80004c9a:	3c4080e7          	jalr	964(ra) # 8000205a <argstr>
    return -1;
    80004c9e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ca0:	0c054163          	bltz	a0,80004d62 <sys_open+0xe4>
    80004ca4:	f4c40593          	addi	a1,s0,-180
    80004ca8:	4505                	li	a0,1
    80004caa:	ffffd097          	auipc	ra,0xffffd
    80004cae:	36c080e7          	jalr	876(ra) # 80002016 <argint>
    80004cb2:	0a054863          	bltz	a0,80004d62 <sys_open+0xe4>

  begin_op();
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	a2e080e7          	jalr	-1490(ra) # 800036e4 <begin_op>

  if(omode & O_CREATE){
    80004cbe:	f4c42783          	lw	a5,-180(s0)
    80004cc2:	2007f793          	andi	a5,a5,512
    80004cc6:	cbdd                	beqz	a5,80004d7c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cc8:	4681                	li	a3,0
    80004cca:	4601                	li	a2,0
    80004ccc:	4589                	li	a1,2
    80004cce:	f5040513          	addi	a0,s0,-176
    80004cd2:	00000097          	auipc	ra,0x0
    80004cd6:	972080e7          	jalr	-1678(ra) # 80004644 <create>
    80004cda:	892a                	mv	s2,a0
    if(ip == 0){
    80004cdc:	c959                	beqz	a0,80004d72 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cde:	04491703          	lh	a4,68(s2)
    80004ce2:	478d                	li	a5,3
    80004ce4:	00f71763          	bne	a4,a5,80004cf2 <sys_open+0x74>
    80004ce8:	04695703          	lhu	a4,70(s2)
    80004cec:	47a5                	li	a5,9
    80004cee:	0ce7ec63          	bltu	a5,a4,80004dc6 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cf2:	fffff097          	auipc	ra,0xfffff
    80004cf6:	e02080e7          	jalr	-510(ra) # 80003af4 <filealloc>
    80004cfa:	89aa                	mv	s3,a0
    80004cfc:	10050263          	beqz	a0,80004e00 <sys_open+0x182>
    80004d00:	00000097          	auipc	ra,0x0
    80004d04:	902080e7          	jalr	-1790(ra) # 80004602 <fdalloc>
    80004d08:	84aa                	mv	s1,a0
    80004d0a:	0e054663          	bltz	a0,80004df6 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d0e:	04491703          	lh	a4,68(s2)
    80004d12:	478d                	li	a5,3
    80004d14:	0cf70463          	beq	a4,a5,80004ddc <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d18:	4789                	li	a5,2
    80004d1a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d1e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d22:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d26:	f4c42783          	lw	a5,-180(s0)
    80004d2a:	0017c713          	xori	a4,a5,1
    80004d2e:	8b05                	andi	a4,a4,1
    80004d30:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d34:	0037f713          	andi	a4,a5,3
    80004d38:	00e03733          	snez	a4,a4
    80004d3c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d40:	4007f793          	andi	a5,a5,1024
    80004d44:	c791                	beqz	a5,80004d50 <sys_open+0xd2>
    80004d46:	04491703          	lh	a4,68(s2)
    80004d4a:	4789                	li	a5,2
    80004d4c:	08f70f63          	beq	a4,a5,80004dea <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d50:	854a                	mv	a0,s2
    80004d52:	ffffe097          	auipc	ra,0xffffe
    80004d56:	082080e7          	jalr	130(ra) # 80002dd4 <iunlock>
  end_op();
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	a0a080e7          	jalr	-1526(ra) # 80003764 <end_op>

  return fd;
}
    80004d62:	8526                	mv	a0,s1
    80004d64:	70ea                	ld	ra,184(sp)
    80004d66:	744a                	ld	s0,176(sp)
    80004d68:	74aa                	ld	s1,168(sp)
    80004d6a:	790a                	ld	s2,160(sp)
    80004d6c:	69ea                	ld	s3,152(sp)
    80004d6e:	6129                	addi	sp,sp,192
    80004d70:	8082                	ret
      end_op();
    80004d72:	fffff097          	auipc	ra,0xfffff
    80004d76:	9f2080e7          	jalr	-1550(ra) # 80003764 <end_op>
      return -1;
    80004d7a:	b7e5                	j	80004d62 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d7c:	f5040513          	addi	a0,s0,-176
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	748080e7          	jalr	1864(ra) # 800034c8 <namei>
    80004d88:	892a                	mv	s2,a0
    80004d8a:	c905                	beqz	a0,80004dba <sys_open+0x13c>
    ilock(ip);
    80004d8c:	ffffe097          	auipc	ra,0xffffe
    80004d90:	f86080e7          	jalr	-122(ra) # 80002d12 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d94:	04491703          	lh	a4,68(s2)
    80004d98:	4785                	li	a5,1
    80004d9a:	f4f712e3          	bne	a4,a5,80004cde <sys_open+0x60>
    80004d9e:	f4c42783          	lw	a5,-180(s0)
    80004da2:	dba1                	beqz	a5,80004cf2 <sys_open+0x74>
      iunlockput(ip);
    80004da4:	854a                	mv	a0,s2
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	1ce080e7          	jalr	462(ra) # 80002f74 <iunlockput>
      end_op();
    80004dae:	fffff097          	auipc	ra,0xfffff
    80004db2:	9b6080e7          	jalr	-1610(ra) # 80003764 <end_op>
      return -1;
    80004db6:	54fd                	li	s1,-1
    80004db8:	b76d                	j	80004d62 <sys_open+0xe4>
      end_op();
    80004dba:	fffff097          	auipc	ra,0xfffff
    80004dbe:	9aa080e7          	jalr	-1622(ra) # 80003764 <end_op>
      return -1;
    80004dc2:	54fd                	li	s1,-1
    80004dc4:	bf79                	j	80004d62 <sys_open+0xe4>
    iunlockput(ip);
    80004dc6:	854a                	mv	a0,s2
    80004dc8:	ffffe097          	auipc	ra,0xffffe
    80004dcc:	1ac080e7          	jalr	428(ra) # 80002f74 <iunlockput>
    end_op();
    80004dd0:	fffff097          	auipc	ra,0xfffff
    80004dd4:	994080e7          	jalr	-1644(ra) # 80003764 <end_op>
    return -1;
    80004dd8:	54fd                	li	s1,-1
    80004dda:	b761                	j	80004d62 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004ddc:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004de0:	04691783          	lh	a5,70(s2)
    80004de4:	02f99223          	sh	a5,36(s3)
    80004de8:	bf2d                	j	80004d22 <sys_open+0xa4>
    itrunc(ip);
    80004dea:	854a                	mv	a0,s2
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	034080e7          	jalr	52(ra) # 80002e20 <itrunc>
    80004df4:	bfb1                	j	80004d50 <sys_open+0xd2>
      fileclose(f);
    80004df6:	854e                	mv	a0,s3
    80004df8:	fffff097          	auipc	ra,0xfffff
    80004dfc:	db8080e7          	jalr	-584(ra) # 80003bb0 <fileclose>
    iunlockput(ip);
    80004e00:	854a                	mv	a0,s2
    80004e02:	ffffe097          	auipc	ra,0xffffe
    80004e06:	172080e7          	jalr	370(ra) # 80002f74 <iunlockput>
    end_op();
    80004e0a:	fffff097          	auipc	ra,0xfffff
    80004e0e:	95a080e7          	jalr	-1702(ra) # 80003764 <end_op>
    return -1;
    80004e12:	54fd                	li	s1,-1
    80004e14:	b7b9                	j	80004d62 <sys_open+0xe4>

0000000080004e16 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e16:	7175                	addi	sp,sp,-144
    80004e18:	e506                	sd	ra,136(sp)
    80004e1a:	e122                	sd	s0,128(sp)
    80004e1c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e1e:	fffff097          	auipc	ra,0xfffff
    80004e22:	8c6080e7          	jalr	-1850(ra) # 800036e4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e26:	08000613          	li	a2,128
    80004e2a:	f7040593          	addi	a1,s0,-144
    80004e2e:	4501                	li	a0,0
    80004e30:	ffffd097          	auipc	ra,0xffffd
    80004e34:	22a080e7          	jalr	554(ra) # 8000205a <argstr>
    80004e38:	02054963          	bltz	a0,80004e6a <sys_mkdir+0x54>
    80004e3c:	4681                	li	a3,0
    80004e3e:	4601                	li	a2,0
    80004e40:	4585                	li	a1,1
    80004e42:	f7040513          	addi	a0,s0,-144
    80004e46:	fffff097          	auipc	ra,0xfffff
    80004e4a:	7fe080e7          	jalr	2046(ra) # 80004644 <create>
    80004e4e:	cd11                	beqz	a0,80004e6a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	124080e7          	jalr	292(ra) # 80002f74 <iunlockput>
  end_op();
    80004e58:	fffff097          	auipc	ra,0xfffff
    80004e5c:	90c080e7          	jalr	-1780(ra) # 80003764 <end_op>
  return 0;
    80004e60:	4501                	li	a0,0
}
    80004e62:	60aa                	ld	ra,136(sp)
    80004e64:	640a                	ld	s0,128(sp)
    80004e66:	6149                	addi	sp,sp,144
    80004e68:	8082                	ret
    end_op();
    80004e6a:	fffff097          	auipc	ra,0xfffff
    80004e6e:	8fa080e7          	jalr	-1798(ra) # 80003764 <end_op>
    return -1;
    80004e72:	557d                	li	a0,-1
    80004e74:	b7fd                	j	80004e62 <sys_mkdir+0x4c>

0000000080004e76 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e76:	7135                	addi	sp,sp,-160
    80004e78:	ed06                	sd	ra,152(sp)
    80004e7a:	e922                	sd	s0,144(sp)
    80004e7c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	866080e7          	jalr	-1946(ra) # 800036e4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e86:	08000613          	li	a2,128
    80004e8a:	f7040593          	addi	a1,s0,-144
    80004e8e:	4501                	li	a0,0
    80004e90:	ffffd097          	auipc	ra,0xffffd
    80004e94:	1ca080e7          	jalr	458(ra) # 8000205a <argstr>
    80004e98:	04054a63          	bltz	a0,80004eec <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e9c:	f6c40593          	addi	a1,s0,-148
    80004ea0:	4505                	li	a0,1
    80004ea2:	ffffd097          	auipc	ra,0xffffd
    80004ea6:	174080e7          	jalr	372(ra) # 80002016 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eaa:	04054163          	bltz	a0,80004eec <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004eae:	f6840593          	addi	a1,s0,-152
    80004eb2:	4509                	li	a0,2
    80004eb4:	ffffd097          	auipc	ra,0xffffd
    80004eb8:	162080e7          	jalr	354(ra) # 80002016 <argint>
     argint(1, &major) < 0 ||
    80004ebc:	02054863          	bltz	a0,80004eec <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ec0:	f6841683          	lh	a3,-152(s0)
    80004ec4:	f6c41603          	lh	a2,-148(s0)
    80004ec8:	458d                	li	a1,3
    80004eca:	f7040513          	addi	a0,s0,-144
    80004ece:	fffff097          	auipc	ra,0xfffff
    80004ed2:	776080e7          	jalr	1910(ra) # 80004644 <create>
     argint(2, &minor) < 0 ||
    80004ed6:	c919                	beqz	a0,80004eec <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	09c080e7          	jalr	156(ra) # 80002f74 <iunlockput>
  end_op();
    80004ee0:	fffff097          	auipc	ra,0xfffff
    80004ee4:	884080e7          	jalr	-1916(ra) # 80003764 <end_op>
  return 0;
    80004ee8:	4501                	li	a0,0
    80004eea:	a031                	j	80004ef6 <sys_mknod+0x80>
    end_op();
    80004eec:	fffff097          	auipc	ra,0xfffff
    80004ef0:	878080e7          	jalr	-1928(ra) # 80003764 <end_op>
    return -1;
    80004ef4:	557d                	li	a0,-1
}
    80004ef6:	60ea                	ld	ra,152(sp)
    80004ef8:	644a                	ld	s0,144(sp)
    80004efa:	610d                	addi	sp,sp,160
    80004efc:	8082                	ret

0000000080004efe <sys_chdir>:

uint64
sys_chdir(void)
{
    80004efe:	7135                	addi	sp,sp,-160
    80004f00:	ed06                	sd	ra,152(sp)
    80004f02:	e922                	sd	s0,144(sp)
    80004f04:	e526                	sd	s1,136(sp)
    80004f06:	e14a                	sd	s2,128(sp)
    80004f08:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f0a:	ffffc097          	auipc	ra,0xffffc
    80004f0e:	f3e080e7          	jalr	-194(ra) # 80000e48 <myproc>
    80004f12:	892a                	mv	s2,a0
  
  begin_op();
    80004f14:	ffffe097          	auipc	ra,0xffffe
    80004f18:	7d0080e7          	jalr	2000(ra) # 800036e4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f1c:	08000613          	li	a2,128
    80004f20:	f6040593          	addi	a1,s0,-160
    80004f24:	4501                	li	a0,0
    80004f26:	ffffd097          	auipc	ra,0xffffd
    80004f2a:	134080e7          	jalr	308(ra) # 8000205a <argstr>
    80004f2e:	04054b63          	bltz	a0,80004f84 <sys_chdir+0x86>
    80004f32:	f6040513          	addi	a0,s0,-160
    80004f36:	ffffe097          	auipc	ra,0xffffe
    80004f3a:	592080e7          	jalr	1426(ra) # 800034c8 <namei>
    80004f3e:	84aa                	mv	s1,a0
    80004f40:	c131                	beqz	a0,80004f84 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f42:	ffffe097          	auipc	ra,0xffffe
    80004f46:	dd0080e7          	jalr	-560(ra) # 80002d12 <ilock>
  if(ip->type != T_DIR){
    80004f4a:	04449703          	lh	a4,68(s1)
    80004f4e:	4785                	li	a5,1
    80004f50:	04f71063          	bne	a4,a5,80004f90 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f54:	8526                	mv	a0,s1
    80004f56:	ffffe097          	auipc	ra,0xffffe
    80004f5a:	e7e080e7          	jalr	-386(ra) # 80002dd4 <iunlock>
  iput(p->cwd);
    80004f5e:	15093503          	ld	a0,336(s2)
    80004f62:	ffffe097          	auipc	ra,0xffffe
    80004f66:	f6a080e7          	jalr	-150(ra) # 80002ecc <iput>
  end_op();
    80004f6a:	ffffe097          	auipc	ra,0xffffe
    80004f6e:	7fa080e7          	jalr	2042(ra) # 80003764 <end_op>
  p->cwd = ip;
    80004f72:	14993823          	sd	s1,336(s2)
  return 0;
    80004f76:	4501                	li	a0,0
}
    80004f78:	60ea                	ld	ra,152(sp)
    80004f7a:	644a                	ld	s0,144(sp)
    80004f7c:	64aa                	ld	s1,136(sp)
    80004f7e:	690a                	ld	s2,128(sp)
    80004f80:	610d                	addi	sp,sp,160
    80004f82:	8082                	ret
    end_op();
    80004f84:	ffffe097          	auipc	ra,0xffffe
    80004f88:	7e0080e7          	jalr	2016(ra) # 80003764 <end_op>
    return -1;
    80004f8c:	557d                	li	a0,-1
    80004f8e:	b7ed                	j	80004f78 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f90:	8526                	mv	a0,s1
    80004f92:	ffffe097          	auipc	ra,0xffffe
    80004f96:	fe2080e7          	jalr	-30(ra) # 80002f74 <iunlockput>
    end_op();
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	7ca080e7          	jalr	1994(ra) # 80003764 <end_op>
    return -1;
    80004fa2:	557d                	li	a0,-1
    80004fa4:	bfd1                	j	80004f78 <sys_chdir+0x7a>

0000000080004fa6 <sys_exec>:

uint64
sys_exec(void)
{
    80004fa6:	7145                	addi	sp,sp,-464
    80004fa8:	e786                	sd	ra,456(sp)
    80004faa:	e3a2                	sd	s0,448(sp)
    80004fac:	ff26                	sd	s1,440(sp)
    80004fae:	fb4a                	sd	s2,432(sp)
    80004fb0:	f74e                	sd	s3,424(sp)
    80004fb2:	f352                	sd	s4,416(sp)
    80004fb4:	ef56                	sd	s5,408(sp)
    80004fb6:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fb8:	08000613          	li	a2,128
    80004fbc:	f4040593          	addi	a1,s0,-192
    80004fc0:	4501                	li	a0,0
    80004fc2:	ffffd097          	auipc	ra,0xffffd
    80004fc6:	098080e7          	jalr	152(ra) # 8000205a <argstr>
    return -1;
    80004fca:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fcc:	0c054a63          	bltz	a0,800050a0 <sys_exec+0xfa>
    80004fd0:	e3840593          	addi	a1,s0,-456
    80004fd4:	4505                	li	a0,1
    80004fd6:	ffffd097          	auipc	ra,0xffffd
    80004fda:	062080e7          	jalr	98(ra) # 80002038 <argaddr>
    80004fde:	0c054163          	bltz	a0,800050a0 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004fe2:	10000613          	li	a2,256
    80004fe6:	4581                	li	a1,0
    80004fe8:	e4040513          	addi	a0,s0,-448
    80004fec:	ffffb097          	auipc	ra,0xffffb
    80004ff0:	18c080e7          	jalr	396(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ff4:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ff8:	89a6                	mv	s3,s1
    80004ffa:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ffc:	02000a13          	li	s4,32
    80005000:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005004:	00391513          	slli	a0,s2,0x3
    80005008:	e3040593          	addi	a1,s0,-464
    8000500c:	e3843783          	ld	a5,-456(s0)
    80005010:	953e                	add	a0,a0,a5
    80005012:	ffffd097          	auipc	ra,0xffffd
    80005016:	f6a080e7          	jalr	-150(ra) # 80001f7c <fetchaddr>
    8000501a:	02054a63          	bltz	a0,8000504e <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000501e:	e3043783          	ld	a5,-464(s0)
    80005022:	c3b9                	beqz	a5,80005068 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005024:	ffffb097          	auipc	ra,0xffffb
    80005028:	0f4080e7          	jalr	244(ra) # 80000118 <kalloc>
    8000502c:	85aa                	mv	a1,a0
    8000502e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005032:	cd11                	beqz	a0,8000504e <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005034:	6605                	lui	a2,0x1
    80005036:	e3043503          	ld	a0,-464(s0)
    8000503a:	ffffd097          	auipc	ra,0xffffd
    8000503e:	f94080e7          	jalr	-108(ra) # 80001fce <fetchstr>
    80005042:	00054663          	bltz	a0,8000504e <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005046:	0905                	addi	s2,s2,1
    80005048:	09a1                	addi	s3,s3,8
    8000504a:	fb491be3          	bne	s2,s4,80005000 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000504e:	10048913          	addi	s2,s1,256
    80005052:	6088                	ld	a0,0(s1)
    80005054:	c529                	beqz	a0,8000509e <sys_exec+0xf8>
    kfree(argv[i]);
    80005056:	ffffb097          	auipc	ra,0xffffb
    8000505a:	fc6080e7          	jalr	-58(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000505e:	04a1                	addi	s1,s1,8
    80005060:	ff2499e3          	bne	s1,s2,80005052 <sys_exec+0xac>
  return -1;
    80005064:	597d                	li	s2,-1
    80005066:	a82d                	j	800050a0 <sys_exec+0xfa>
      argv[i] = 0;
    80005068:	0a8e                	slli	s5,s5,0x3
    8000506a:	fc040793          	addi	a5,s0,-64
    8000506e:	9abe                	add	s5,s5,a5
    80005070:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005074:	e4040593          	addi	a1,s0,-448
    80005078:	f4040513          	addi	a0,s0,-192
    8000507c:	fffff097          	auipc	ra,0xfffff
    80005080:	194080e7          	jalr	404(ra) # 80004210 <exec>
    80005084:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005086:	10048993          	addi	s3,s1,256
    8000508a:	6088                	ld	a0,0(s1)
    8000508c:	c911                	beqz	a0,800050a0 <sys_exec+0xfa>
    kfree(argv[i]);
    8000508e:	ffffb097          	auipc	ra,0xffffb
    80005092:	f8e080e7          	jalr	-114(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005096:	04a1                	addi	s1,s1,8
    80005098:	ff3499e3          	bne	s1,s3,8000508a <sys_exec+0xe4>
    8000509c:	a011                	j	800050a0 <sys_exec+0xfa>
  return -1;
    8000509e:	597d                	li	s2,-1
}
    800050a0:	854a                	mv	a0,s2
    800050a2:	60be                	ld	ra,456(sp)
    800050a4:	641e                	ld	s0,448(sp)
    800050a6:	74fa                	ld	s1,440(sp)
    800050a8:	795a                	ld	s2,432(sp)
    800050aa:	79ba                	ld	s3,424(sp)
    800050ac:	7a1a                	ld	s4,416(sp)
    800050ae:	6afa                	ld	s5,408(sp)
    800050b0:	6179                	addi	sp,sp,464
    800050b2:	8082                	ret

00000000800050b4 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050b4:	7139                	addi	sp,sp,-64
    800050b6:	fc06                	sd	ra,56(sp)
    800050b8:	f822                	sd	s0,48(sp)
    800050ba:	f426                	sd	s1,40(sp)
    800050bc:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050be:	ffffc097          	auipc	ra,0xffffc
    800050c2:	d8a080e7          	jalr	-630(ra) # 80000e48 <myproc>
    800050c6:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050c8:	fd840593          	addi	a1,s0,-40
    800050cc:	4501                	li	a0,0
    800050ce:	ffffd097          	auipc	ra,0xffffd
    800050d2:	f6a080e7          	jalr	-150(ra) # 80002038 <argaddr>
    return -1;
    800050d6:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050d8:	0e054063          	bltz	a0,800051b8 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050dc:	fc840593          	addi	a1,s0,-56
    800050e0:	fd040513          	addi	a0,s0,-48
    800050e4:	fffff097          	auipc	ra,0xfffff
    800050e8:	dfc080e7          	jalr	-516(ra) # 80003ee0 <pipealloc>
    return -1;
    800050ec:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050ee:	0c054563          	bltz	a0,800051b8 <sys_pipe+0x104>
  fd0 = -1;
    800050f2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050f6:	fd043503          	ld	a0,-48(s0)
    800050fa:	fffff097          	auipc	ra,0xfffff
    800050fe:	508080e7          	jalr	1288(ra) # 80004602 <fdalloc>
    80005102:	fca42223          	sw	a0,-60(s0)
    80005106:	08054c63          	bltz	a0,8000519e <sys_pipe+0xea>
    8000510a:	fc843503          	ld	a0,-56(s0)
    8000510e:	fffff097          	auipc	ra,0xfffff
    80005112:	4f4080e7          	jalr	1268(ra) # 80004602 <fdalloc>
    80005116:	fca42023          	sw	a0,-64(s0)
    8000511a:	06054863          	bltz	a0,8000518a <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000511e:	4691                	li	a3,4
    80005120:	fc440613          	addi	a2,s0,-60
    80005124:	fd843583          	ld	a1,-40(s0)
    80005128:	68a8                	ld	a0,80(s1)
    8000512a:	ffffc097          	auipc	ra,0xffffc
    8000512e:	9e0080e7          	jalr	-1568(ra) # 80000b0a <copyout>
    80005132:	02054063          	bltz	a0,80005152 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005136:	4691                	li	a3,4
    80005138:	fc040613          	addi	a2,s0,-64
    8000513c:	fd843583          	ld	a1,-40(s0)
    80005140:	0591                	addi	a1,a1,4
    80005142:	68a8                	ld	a0,80(s1)
    80005144:	ffffc097          	auipc	ra,0xffffc
    80005148:	9c6080e7          	jalr	-1594(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000514c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000514e:	06055563          	bgez	a0,800051b8 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005152:	fc442783          	lw	a5,-60(s0)
    80005156:	07e9                	addi	a5,a5,26
    80005158:	078e                	slli	a5,a5,0x3
    8000515a:	97a6                	add	a5,a5,s1
    8000515c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005160:	fc042503          	lw	a0,-64(s0)
    80005164:	0569                	addi	a0,a0,26
    80005166:	050e                	slli	a0,a0,0x3
    80005168:	9526                	add	a0,a0,s1
    8000516a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000516e:	fd043503          	ld	a0,-48(s0)
    80005172:	fffff097          	auipc	ra,0xfffff
    80005176:	a3e080e7          	jalr	-1474(ra) # 80003bb0 <fileclose>
    fileclose(wf);
    8000517a:	fc843503          	ld	a0,-56(s0)
    8000517e:	fffff097          	auipc	ra,0xfffff
    80005182:	a32080e7          	jalr	-1486(ra) # 80003bb0 <fileclose>
    return -1;
    80005186:	57fd                	li	a5,-1
    80005188:	a805                	j	800051b8 <sys_pipe+0x104>
    if(fd0 >= 0)
    8000518a:	fc442783          	lw	a5,-60(s0)
    8000518e:	0007c863          	bltz	a5,8000519e <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005192:	01a78513          	addi	a0,a5,26
    80005196:	050e                	slli	a0,a0,0x3
    80005198:	9526                	add	a0,a0,s1
    8000519a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000519e:	fd043503          	ld	a0,-48(s0)
    800051a2:	fffff097          	auipc	ra,0xfffff
    800051a6:	a0e080e7          	jalr	-1522(ra) # 80003bb0 <fileclose>
    fileclose(wf);
    800051aa:	fc843503          	ld	a0,-56(s0)
    800051ae:	fffff097          	auipc	ra,0xfffff
    800051b2:	a02080e7          	jalr	-1534(ra) # 80003bb0 <fileclose>
    return -1;
    800051b6:	57fd                	li	a5,-1
}
    800051b8:	853e                	mv	a0,a5
    800051ba:	70e2                	ld	ra,56(sp)
    800051bc:	7442                	ld	s0,48(sp)
    800051be:	74a2                	ld	s1,40(sp)
    800051c0:	6121                	addi	sp,sp,64
    800051c2:	8082                	ret
	...

00000000800051d0 <kernelvec>:
    800051d0:	7111                	addi	sp,sp,-256
    800051d2:	e006                	sd	ra,0(sp)
    800051d4:	e40a                	sd	sp,8(sp)
    800051d6:	e80e                	sd	gp,16(sp)
    800051d8:	ec12                	sd	tp,24(sp)
    800051da:	f016                	sd	t0,32(sp)
    800051dc:	f41a                	sd	t1,40(sp)
    800051de:	f81e                	sd	t2,48(sp)
    800051e0:	fc22                	sd	s0,56(sp)
    800051e2:	e0a6                	sd	s1,64(sp)
    800051e4:	e4aa                	sd	a0,72(sp)
    800051e6:	e8ae                	sd	a1,80(sp)
    800051e8:	ecb2                	sd	a2,88(sp)
    800051ea:	f0b6                	sd	a3,96(sp)
    800051ec:	f4ba                	sd	a4,104(sp)
    800051ee:	f8be                	sd	a5,112(sp)
    800051f0:	fcc2                	sd	a6,120(sp)
    800051f2:	e146                	sd	a7,128(sp)
    800051f4:	e54a                	sd	s2,136(sp)
    800051f6:	e94e                	sd	s3,144(sp)
    800051f8:	ed52                	sd	s4,152(sp)
    800051fa:	f156                	sd	s5,160(sp)
    800051fc:	f55a                	sd	s6,168(sp)
    800051fe:	f95e                	sd	s7,176(sp)
    80005200:	fd62                	sd	s8,184(sp)
    80005202:	e1e6                	sd	s9,192(sp)
    80005204:	e5ea                	sd	s10,200(sp)
    80005206:	e9ee                	sd	s11,208(sp)
    80005208:	edf2                	sd	t3,216(sp)
    8000520a:	f1f6                	sd	t4,224(sp)
    8000520c:	f5fa                	sd	t5,232(sp)
    8000520e:	f9fe                	sd	t6,240(sp)
    80005210:	c39fc0ef          	jal	ra,80001e48 <kerneltrap>
    80005214:	6082                	ld	ra,0(sp)
    80005216:	6122                	ld	sp,8(sp)
    80005218:	61c2                	ld	gp,16(sp)
    8000521a:	7282                	ld	t0,32(sp)
    8000521c:	7322                	ld	t1,40(sp)
    8000521e:	73c2                	ld	t2,48(sp)
    80005220:	7462                	ld	s0,56(sp)
    80005222:	6486                	ld	s1,64(sp)
    80005224:	6526                	ld	a0,72(sp)
    80005226:	65c6                	ld	a1,80(sp)
    80005228:	6666                	ld	a2,88(sp)
    8000522a:	7686                	ld	a3,96(sp)
    8000522c:	7726                	ld	a4,104(sp)
    8000522e:	77c6                	ld	a5,112(sp)
    80005230:	7866                	ld	a6,120(sp)
    80005232:	688a                	ld	a7,128(sp)
    80005234:	692a                	ld	s2,136(sp)
    80005236:	69ca                	ld	s3,144(sp)
    80005238:	6a6a                	ld	s4,152(sp)
    8000523a:	7a8a                	ld	s5,160(sp)
    8000523c:	7b2a                	ld	s6,168(sp)
    8000523e:	7bca                	ld	s7,176(sp)
    80005240:	7c6a                	ld	s8,184(sp)
    80005242:	6c8e                	ld	s9,192(sp)
    80005244:	6d2e                	ld	s10,200(sp)
    80005246:	6dce                	ld	s11,208(sp)
    80005248:	6e6e                	ld	t3,216(sp)
    8000524a:	7e8e                	ld	t4,224(sp)
    8000524c:	7f2e                	ld	t5,232(sp)
    8000524e:	7fce                	ld	t6,240(sp)
    80005250:	6111                	addi	sp,sp,256
    80005252:	10200073          	sret
    80005256:	00000013          	nop
    8000525a:	00000013          	nop
    8000525e:	0001                	nop

0000000080005260 <timervec>:
    80005260:	34051573          	csrrw	a0,mscratch,a0
    80005264:	e10c                	sd	a1,0(a0)
    80005266:	e510                	sd	a2,8(a0)
    80005268:	e914                	sd	a3,16(a0)
    8000526a:	6d0c                	ld	a1,24(a0)
    8000526c:	7110                	ld	a2,32(a0)
    8000526e:	6194                	ld	a3,0(a1)
    80005270:	96b2                	add	a3,a3,a2
    80005272:	e194                	sd	a3,0(a1)
    80005274:	4589                	li	a1,2
    80005276:	14459073          	csrw	sip,a1
    8000527a:	6914                	ld	a3,16(a0)
    8000527c:	6510                	ld	a2,8(a0)
    8000527e:	610c                	ld	a1,0(a0)
    80005280:	34051573          	csrrw	a0,mscratch,a0
    80005284:	30200073          	mret
	...

000000008000528a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000528a:	1141                	addi	sp,sp,-16
    8000528c:	e422                	sd	s0,8(sp)
    8000528e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005290:	0c0007b7          	lui	a5,0xc000
    80005294:	4705                	li	a4,1
    80005296:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005298:	c3d8                	sw	a4,4(a5)
}
    8000529a:	6422                	ld	s0,8(sp)
    8000529c:	0141                	addi	sp,sp,16
    8000529e:	8082                	ret

00000000800052a0 <plicinithart>:

void
plicinithart(void)
{
    800052a0:	1141                	addi	sp,sp,-16
    800052a2:	e406                	sd	ra,8(sp)
    800052a4:	e022                	sd	s0,0(sp)
    800052a6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052a8:	ffffc097          	auipc	ra,0xffffc
    800052ac:	b74080e7          	jalr	-1164(ra) # 80000e1c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052b0:	0085171b          	slliw	a4,a0,0x8
    800052b4:	0c0027b7          	lui	a5,0xc002
    800052b8:	97ba                	add	a5,a5,a4
    800052ba:	40200713          	li	a4,1026
    800052be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052c2:	00d5151b          	slliw	a0,a0,0xd
    800052c6:	0c2017b7          	lui	a5,0xc201
    800052ca:	953e                	add	a0,a0,a5
    800052cc:	00052023          	sw	zero,0(a0)
}
    800052d0:	60a2                	ld	ra,8(sp)
    800052d2:	6402                	ld	s0,0(sp)
    800052d4:	0141                	addi	sp,sp,16
    800052d6:	8082                	ret

00000000800052d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052d8:	1141                	addi	sp,sp,-16
    800052da:	e406                	sd	ra,8(sp)
    800052dc:	e022                	sd	s0,0(sp)
    800052de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052e0:	ffffc097          	auipc	ra,0xffffc
    800052e4:	b3c080e7          	jalr	-1220(ra) # 80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052e8:	00d5179b          	slliw	a5,a0,0xd
    800052ec:	0c201537          	lui	a0,0xc201
    800052f0:	953e                	add	a0,a0,a5
  return irq;
}
    800052f2:	4148                	lw	a0,4(a0)
    800052f4:	60a2                	ld	ra,8(sp)
    800052f6:	6402                	ld	s0,0(sp)
    800052f8:	0141                	addi	sp,sp,16
    800052fa:	8082                	ret

00000000800052fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052fc:	1101                	addi	sp,sp,-32
    800052fe:	ec06                	sd	ra,24(sp)
    80005300:	e822                	sd	s0,16(sp)
    80005302:	e426                	sd	s1,8(sp)
    80005304:	1000                	addi	s0,sp,32
    80005306:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005308:	ffffc097          	auipc	ra,0xffffc
    8000530c:	b14080e7          	jalr	-1260(ra) # 80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005310:	00d5151b          	slliw	a0,a0,0xd
    80005314:	0c2017b7          	lui	a5,0xc201
    80005318:	97aa                	add	a5,a5,a0
    8000531a:	c3c4                	sw	s1,4(a5)
}
    8000531c:	60e2                	ld	ra,24(sp)
    8000531e:	6442                	ld	s0,16(sp)
    80005320:	64a2                	ld	s1,8(sp)
    80005322:	6105                	addi	sp,sp,32
    80005324:	8082                	ret

0000000080005326 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005326:	1141                	addi	sp,sp,-16
    80005328:	e406                	sd	ra,8(sp)
    8000532a:	e022                	sd	s0,0(sp)
    8000532c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000532e:	479d                	li	a5,7
    80005330:	06a7c963          	blt	a5,a0,800053a2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005334:	0001a797          	auipc	a5,0x1a
    80005338:	ccc78793          	addi	a5,a5,-820 # 8001f000 <disk>
    8000533c:	00a78733          	add	a4,a5,a0
    80005340:	6789                	lui	a5,0x2
    80005342:	97ba                	add	a5,a5,a4
    80005344:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005348:	e7ad                	bnez	a5,800053b2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000534a:	00451793          	slli	a5,a0,0x4
    8000534e:	0001c717          	auipc	a4,0x1c
    80005352:	cb270713          	addi	a4,a4,-846 # 80021000 <disk+0x2000>
    80005356:	6314                	ld	a3,0(a4)
    80005358:	96be                	add	a3,a3,a5
    8000535a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000535e:	6314                	ld	a3,0(a4)
    80005360:	96be                	add	a3,a3,a5
    80005362:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005366:	6314                	ld	a3,0(a4)
    80005368:	96be                	add	a3,a3,a5
    8000536a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000536e:	6318                	ld	a4,0(a4)
    80005370:	97ba                	add	a5,a5,a4
    80005372:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005376:	0001a797          	auipc	a5,0x1a
    8000537a:	c8a78793          	addi	a5,a5,-886 # 8001f000 <disk>
    8000537e:	97aa                	add	a5,a5,a0
    80005380:	6509                	lui	a0,0x2
    80005382:	953e                	add	a0,a0,a5
    80005384:	4785                	li	a5,1
    80005386:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000538a:	0001c517          	auipc	a0,0x1c
    8000538e:	c8e50513          	addi	a0,a0,-882 # 80021018 <disk+0x2018>
    80005392:	ffffc097          	auipc	ra,0xffffc
    80005396:	306080e7          	jalr	774(ra) # 80001698 <wakeup>
}
    8000539a:	60a2                	ld	ra,8(sp)
    8000539c:	6402                	ld	s0,0(sp)
    8000539e:	0141                	addi	sp,sp,16
    800053a0:	8082                	ret
    panic("free_desc 1");
    800053a2:	00003517          	auipc	a0,0x3
    800053a6:	35650513          	addi	a0,a0,854 # 800086f8 <syscalls+0x330>
    800053aa:	00001097          	auipc	ra,0x1
    800053ae:	a1e080e7          	jalr	-1506(ra) # 80005dc8 <panic>
    panic("free_desc 2");
    800053b2:	00003517          	auipc	a0,0x3
    800053b6:	35650513          	addi	a0,a0,854 # 80008708 <syscalls+0x340>
    800053ba:	00001097          	auipc	ra,0x1
    800053be:	a0e080e7          	jalr	-1522(ra) # 80005dc8 <panic>

00000000800053c2 <virtio_disk_init>:
{
    800053c2:	1101                	addi	sp,sp,-32
    800053c4:	ec06                	sd	ra,24(sp)
    800053c6:	e822                	sd	s0,16(sp)
    800053c8:	e426                	sd	s1,8(sp)
    800053ca:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053cc:	00003597          	auipc	a1,0x3
    800053d0:	34c58593          	addi	a1,a1,844 # 80008718 <syscalls+0x350>
    800053d4:	0001c517          	auipc	a0,0x1c
    800053d8:	d5450513          	addi	a0,a0,-684 # 80021128 <disk+0x2128>
    800053dc:	00001097          	auipc	ra,0x1
    800053e0:	f12080e7          	jalr	-238(ra) # 800062ee <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053e4:	100017b7          	lui	a5,0x10001
    800053e8:	4398                	lw	a4,0(a5)
    800053ea:	2701                	sext.w	a4,a4
    800053ec:	747277b7          	lui	a5,0x74727
    800053f0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053f4:	0ef71163          	bne	a4,a5,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053f8:	100017b7          	lui	a5,0x10001
    800053fc:	43dc                	lw	a5,4(a5)
    800053fe:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005400:	4705                	li	a4,1
    80005402:	0ce79a63          	bne	a5,a4,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005406:	100017b7          	lui	a5,0x10001
    8000540a:	479c                	lw	a5,8(a5)
    8000540c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000540e:	4709                	li	a4,2
    80005410:	0ce79363          	bne	a5,a4,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005414:	100017b7          	lui	a5,0x10001
    80005418:	47d8                	lw	a4,12(a5)
    8000541a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000541c:	554d47b7          	lui	a5,0x554d4
    80005420:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005424:	0af71963          	bne	a4,a5,800054d6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005428:	100017b7          	lui	a5,0x10001
    8000542c:	4705                	li	a4,1
    8000542e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005430:	470d                	li	a4,3
    80005432:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005434:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005436:	c7ffe737          	lui	a4,0xc7ffe
    8000543a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd451f>
    8000543e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005440:	2701                	sext.w	a4,a4
    80005442:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005444:	472d                	li	a4,11
    80005446:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005448:	473d                	li	a4,15
    8000544a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000544c:	6705                	lui	a4,0x1
    8000544e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005450:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005454:	5bdc                	lw	a5,52(a5)
    80005456:	2781                	sext.w	a5,a5
  if(max == 0)
    80005458:	c7d9                	beqz	a5,800054e6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000545a:	471d                	li	a4,7
    8000545c:	08f77d63          	bgeu	a4,a5,800054f6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005460:	100014b7          	lui	s1,0x10001
    80005464:	47a1                	li	a5,8
    80005466:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005468:	6609                	lui	a2,0x2
    8000546a:	4581                	li	a1,0
    8000546c:	0001a517          	auipc	a0,0x1a
    80005470:	b9450513          	addi	a0,a0,-1132 # 8001f000 <disk>
    80005474:	ffffb097          	auipc	ra,0xffffb
    80005478:	d04080e7          	jalr	-764(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000547c:	0001a717          	auipc	a4,0x1a
    80005480:	b8470713          	addi	a4,a4,-1148 # 8001f000 <disk>
    80005484:	00c75793          	srli	a5,a4,0xc
    80005488:	2781                	sext.w	a5,a5
    8000548a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000548c:	0001c797          	auipc	a5,0x1c
    80005490:	b7478793          	addi	a5,a5,-1164 # 80021000 <disk+0x2000>
    80005494:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005496:	0001a717          	auipc	a4,0x1a
    8000549a:	bea70713          	addi	a4,a4,-1046 # 8001f080 <disk+0x80>
    8000549e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054a0:	0001b717          	auipc	a4,0x1b
    800054a4:	b6070713          	addi	a4,a4,-1184 # 80020000 <disk+0x1000>
    800054a8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054aa:	4705                	li	a4,1
    800054ac:	00e78c23          	sb	a4,24(a5)
    800054b0:	00e78ca3          	sb	a4,25(a5)
    800054b4:	00e78d23          	sb	a4,26(a5)
    800054b8:	00e78da3          	sb	a4,27(a5)
    800054bc:	00e78e23          	sb	a4,28(a5)
    800054c0:	00e78ea3          	sb	a4,29(a5)
    800054c4:	00e78f23          	sb	a4,30(a5)
    800054c8:	00e78fa3          	sb	a4,31(a5)
}
    800054cc:	60e2                	ld	ra,24(sp)
    800054ce:	6442                	ld	s0,16(sp)
    800054d0:	64a2                	ld	s1,8(sp)
    800054d2:	6105                	addi	sp,sp,32
    800054d4:	8082                	ret
    panic("could not find virtio disk");
    800054d6:	00003517          	auipc	a0,0x3
    800054da:	25250513          	addi	a0,a0,594 # 80008728 <syscalls+0x360>
    800054de:	00001097          	auipc	ra,0x1
    800054e2:	8ea080e7          	jalr	-1814(ra) # 80005dc8 <panic>
    panic("virtio disk has no queue 0");
    800054e6:	00003517          	auipc	a0,0x3
    800054ea:	26250513          	addi	a0,a0,610 # 80008748 <syscalls+0x380>
    800054ee:	00001097          	auipc	ra,0x1
    800054f2:	8da080e7          	jalr	-1830(ra) # 80005dc8 <panic>
    panic("virtio disk max queue too short");
    800054f6:	00003517          	auipc	a0,0x3
    800054fa:	27250513          	addi	a0,a0,626 # 80008768 <syscalls+0x3a0>
    800054fe:	00001097          	auipc	ra,0x1
    80005502:	8ca080e7          	jalr	-1846(ra) # 80005dc8 <panic>

0000000080005506 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005506:	7159                	addi	sp,sp,-112
    80005508:	f486                	sd	ra,104(sp)
    8000550a:	f0a2                	sd	s0,96(sp)
    8000550c:	eca6                	sd	s1,88(sp)
    8000550e:	e8ca                	sd	s2,80(sp)
    80005510:	e4ce                	sd	s3,72(sp)
    80005512:	e0d2                	sd	s4,64(sp)
    80005514:	fc56                	sd	s5,56(sp)
    80005516:	f85a                	sd	s6,48(sp)
    80005518:	f45e                	sd	s7,40(sp)
    8000551a:	f062                	sd	s8,32(sp)
    8000551c:	ec66                	sd	s9,24(sp)
    8000551e:	e86a                	sd	s10,16(sp)
    80005520:	1880                	addi	s0,sp,112
    80005522:	892a                	mv	s2,a0
    80005524:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005526:	00c52c83          	lw	s9,12(a0)
    8000552a:	001c9c9b          	slliw	s9,s9,0x1
    8000552e:	1c82                	slli	s9,s9,0x20
    80005530:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005534:	0001c517          	auipc	a0,0x1c
    80005538:	bf450513          	addi	a0,a0,-1036 # 80021128 <disk+0x2128>
    8000553c:	00001097          	auipc	ra,0x1
    80005540:	e42080e7          	jalr	-446(ra) # 8000637e <acquire>
  for(int i = 0; i < 3; i++){
    80005544:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005546:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005548:	0001ab97          	auipc	s7,0x1a
    8000554c:	ab8b8b93          	addi	s7,s7,-1352 # 8001f000 <disk>
    80005550:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005552:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005554:	8a4e                	mv	s4,s3
    80005556:	a051                	j	800055da <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005558:	00fb86b3          	add	a3,s7,a5
    8000555c:	96da                	add	a3,a3,s6
    8000555e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005562:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005564:	0207c563          	bltz	a5,8000558e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005568:	2485                	addiw	s1,s1,1
    8000556a:	0711                	addi	a4,a4,4
    8000556c:	25548063          	beq	s1,s5,800057ac <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005570:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005572:	0001c697          	auipc	a3,0x1c
    80005576:	aa668693          	addi	a3,a3,-1370 # 80021018 <disk+0x2018>
    8000557a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000557c:	0006c583          	lbu	a1,0(a3)
    80005580:	fde1                	bnez	a1,80005558 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005582:	2785                	addiw	a5,a5,1
    80005584:	0685                	addi	a3,a3,1
    80005586:	ff879be3          	bne	a5,s8,8000557c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000558a:	57fd                	li	a5,-1
    8000558c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000558e:	02905a63          	blez	s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005592:	f9042503          	lw	a0,-112(s0)
    80005596:	00000097          	auipc	ra,0x0
    8000559a:	d90080e7          	jalr	-624(ra) # 80005326 <free_desc>
      for(int j = 0; j < i; j++)
    8000559e:	4785                	li	a5,1
    800055a0:	0297d163          	bge	a5,s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055a4:	f9442503          	lw	a0,-108(s0)
    800055a8:	00000097          	auipc	ra,0x0
    800055ac:	d7e080e7          	jalr	-642(ra) # 80005326 <free_desc>
      for(int j = 0; j < i; j++)
    800055b0:	4789                	li	a5,2
    800055b2:	0097d863          	bge	a5,s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055b6:	f9842503          	lw	a0,-104(s0)
    800055ba:	00000097          	auipc	ra,0x0
    800055be:	d6c080e7          	jalr	-660(ra) # 80005326 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055c2:	0001c597          	auipc	a1,0x1c
    800055c6:	b6658593          	addi	a1,a1,-1178 # 80021128 <disk+0x2128>
    800055ca:	0001c517          	auipc	a0,0x1c
    800055ce:	a4e50513          	addi	a0,a0,-1458 # 80021018 <disk+0x2018>
    800055d2:	ffffc097          	auipc	ra,0xffffc
    800055d6:	f3a080e7          	jalr	-198(ra) # 8000150c <sleep>
  for(int i = 0; i < 3; i++){
    800055da:	f9040713          	addi	a4,s0,-112
    800055de:	84ce                	mv	s1,s3
    800055e0:	bf41                	j	80005570 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055e2:	20058713          	addi	a4,a1,512
    800055e6:	00471693          	slli	a3,a4,0x4
    800055ea:	0001a717          	auipc	a4,0x1a
    800055ee:	a1670713          	addi	a4,a4,-1514 # 8001f000 <disk>
    800055f2:	9736                	add	a4,a4,a3
    800055f4:	4685                	li	a3,1
    800055f6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055fa:	20058713          	addi	a4,a1,512
    800055fe:	00471693          	slli	a3,a4,0x4
    80005602:	0001a717          	auipc	a4,0x1a
    80005606:	9fe70713          	addi	a4,a4,-1538 # 8001f000 <disk>
    8000560a:	9736                	add	a4,a4,a3
    8000560c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005610:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005614:	7679                	lui	a2,0xffffe
    80005616:	963e                	add	a2,a2,a5
    80005618:	0001c697          	auipc	a3,0x1c
    8000561c:	9e868693          	addi	a3,a3,-1560 # 80021000 <disk+0x2000>
    80005620:	6298                	ld	a4,0(a3)
    80005622:	9732                	add	a4,a4,a2
    80005624:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005626:	6298                	ld	a4,0(a3)
    80005628:	9732                	add	a4,a4,a2
    8000562a:	4541                	li	a0,16
    8000562c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000562e:	6298                	ld	a4,0(a3)
    80005630:	9732                	add	a4,a4,a2
    80005632:	4505                	li	a0,1
    80005634:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005638:	f9442703          	lw	a4,-108(s0)
    8000563c:	6288                	ld	a0,0(a3)
    8000563e:	962a                	add	a2,a2,a0
    80005640:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd3dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005644:	0712                	slli	a4,a4,0x4
    80005646:	6290                	ld	a2,0(a3)
    80005648:	963a                	add	a2,a2,a4
    8000564a:	05890513          	addi	a0,s2,88
    8000564e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005650:	6294                	ld	a3,0(a3)
    80005652:	96ba                	add	a3,a3,a4
    80005654:	40000613          	li	a2,1024
    80005658:	c690                	sw	a2,8(a3)
  if(write)
    8000565a:	140d0063          	beqz	s10,8000579a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000565e:	0001c697          	auipc	a3,0x1c
    80005662:	9a26b683          	ld	a3,-1630(a3) # 80021000 <disk+0x2000>
    80005666:	96ba                	add	a3,a3,a4
    80005668:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000566c:	0001a817          	auipc	a6,0x1a
    80005670:	99480813          	addi	a6,a6,-1644 # 8001f000 <disk>
    80005674:	0001c517          	auipc	a0,0x1c
    80005678:	98c50513          	addi	a0,a0,-1652 # 80021000 <disk+0x2000>
    8000567c:	6114                	ld	a3,0(a0)
    8000567e:	96ba                	add	a3,a3,a4
    80005680:	00c6d603          	lhu	a2,12(a3)
    80005684:	00166613          	ori	a2,a2,1
    80005688:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000568c:	f9842683          	lw	a3,-104(s0)
    80005690:	6110                	ld	a2,0(a0)
    80005692:	9732                	add	a4,a4,a2
    80005694:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005698:	20058613          	addi	a2,a1,512
    8000569c:	0612                	slli	a2,a2,0x4
    8000569e:	9642                	add	a2,a2,a6
    800056a0:	577d                	li	a4,-1
    800056a2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056a6:	00469713          	slli	a4,a3,0x4
    800056aa:	6114                	ld	a3,0(a0)
    800056ac:	96ba                	add	a3,a3,a4
    800056ae:	03078793          	addi	a5,a5,48
    800056b2:	97c2                	add	a5,a5,a6
    800056b4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800056b6:	611c                	ld	a5,0(a0)
    800056b8:	97ba                	add	a5,a5,a4
    800056ba:	4685                	li	a3,1
    800056bc:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056be:	611c                	ld	a5,0(a0)
    800056c0:	97ba                	add	a5,a5,a4
    800056c2:	4809                	li	a6,2
    800056c4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800056c8:	611c                	ld	a5,0(a0)
    800056ca:	973e                	add	a4,a4,a5
    800056cc:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056d0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800056d4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056d8:	6518                	ld	a4,8(a0)
    800056da:	00275783          	lhu	a5,2(a4)
    800056de:	8b9d                	andi	a5,a5,7
    800056e0:	0786                	slli	a5,a5,0x1
    800056e2:	97ba                	add	a5,a5,a4
    800056e4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800056e8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056ec:	6518                	ld	a4,8(a0)
    800056ee:	00275783          	lhu	a5,2(a4)
    800056f2:	2785                	addiw	a5,a5,1
    800056f4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056f8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056fc:	100017b7          	lui	a5,0x10001
    80005700:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005704:	00492703          	lw	a4,4(s2)
    80005708:	4785                	li	a5,1
    8000570a:	02f71163          	bne	a4,a5,8000572c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000570e:	0001c997          	auipc	s3,0x1c
    80005712:	a1a98993          	addi	s3,s3,-1510 # 80021128 <disk+0x2128>
  while(b->disk == 1) {
    80005716:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005718:	85ce                	mv	a1,s3
    8000571a:	854a                	mv	a0,s2
    8000571c:	ffffc097          	auipc	ra,0xffffc
    80005720:	df0080e7          	jalr	-528(ra) # 8000150c <sleep>
  while(b->disk == 1) {
    80005724:	00492783          	lw	a5,4(s2)
    80005728:	fe9788e3          	beq	a5,s1,80005718 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000572c:	f9042903          	lw	s2,-112(s0)
    80005730:	20090793          	addi	a5,s2,512
    80005734:	00479713          	slli	a4,a5,0x4
    80005738:	0001a797          	auipc	a5,0x1a
    8000573c:	8c878793          	addi	a5,a5,-1848 # 8001f000 <disk>
    80005740:	97ba                	add	a5,a5,a4
    80005742:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005746:	0001c997          	auipc	s3,0x1c
    8000574a:	8ba98993          	addi	s3,s3,-1862 # 80021000 <disk+0x2000>
    8000574e:	00491713          	slli	a4,s2,0x4
    80005752:	0009b783          	ld	a5,0(s3)
    80005756:	97ba                	add	a5,a5,a4
    80005758:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000575c:	854a                	mv	a0,s2
    8000575e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005762:	00000097          	auipc	ra,0x0
    80005766:	bc4080e7          	jalr	-1084(ra) # 80005326 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000576a:	8885                	andi	s1,s1,1
    8000576c:	f0ed                	bnez	s1,8000574e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000576e:	0001c517          	auipc	a0,0x1c
    80005772:	9ba50513          	addi	a0,a0,-1606 # 80021128 <disk+0x2128>
    80005776:	00001097          	auipc	ra,0x1
    8000577a:	cbc080e7          	jalr	-836(ra) # 80006432 <release>
}
    8000577e:	70a6                	ld	ra,104(sp)
    80005780:	7406                	ld	s0,96(sp)
    80005782:	64e6                	ld	s1,88(sp)
    80005784:	6946                	ld	s2,80(sp)
    80005786:	69a6                	ld	s3,72(sp)
    80005788:	6a06                	ld	s4,64(sp)
    8000578a:	7ae2                	ld	s5,56(sp)
    8000578c:	7b42                	ld	s6,48(sp)
    8000578e:	7ba2                	ld	s7,40(sp)
    80005790:	7c02                	ld	s8,32(sp)
    80005792:	6ce2                	ld	s9,24(sp)
    80005794:	6d42                	ld	s10,16(sp)
    80005796:	6165                	addi	sp,sp,112
    80005798:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000579a:	0001c697          	auipc	a3,0x1c
    8000579e:	8666b683          	ld	a3,-1946(a3) # 80021000 <disk+0x2000>
    800057a2:	96ba                	add	a3,a3,a4
    800057a4:	4609                	li	a2,2
    800057a6:	00c69623          	sh	a2,12(a3)
    800057aa:	b5c9                	j	8000566c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057ac:	f9042583          	lw	a1,-112(s0)
    800057b0:	20058793          	addi	a5,a1,512
    800057b4:	0792                	slli	a5,a5,0x4
    800057b6:	0001a517          	auipc	a0,0x1a
    800057ba:	8f250513          	addi	a0,a0,-1806 # 8001f0a8 <disk+0xa8>
    800057be:	953e                	add	a0,a0,a5
  if(write)
    800057c0:	e20d11e3          	bnez	s10,800055e2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800057c4:	20058713          	addi	a4,a1,512
    800057c8:	00471693          	slli	a3,a4,0x4
    800057cc:	0001a717          	auipc	a4,0x1a
    800057d0:	83470713          	addi	a4,a4,-1996 # 8001f000 <disk>
    800057d4:	9736                	add	a4,a4,a3
    800057d6:	0a072423          	sw	zero,168(a4)
    800057da:	b505                	j	800055fa <virtio_disk_rw+0xf4>

00000000800057dc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057dc:	1101                	addi	sp,sp,-32
    800057de:	ec06                	sd	ra,24(sp)
    800057e0:	e822                	sd	s0,16(sp)
    800057e2:	e426                	sd	s1,8(sp)
    800057e4:	e04a                	sd	s2,0(sp)
    800057e6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057e8:	0001c517          	auipc	a0,0x1c
    800057ec:	94050513          	addi	a0,a0,-1728 # 80021128 <disk+0x2128>
    800057f0:	00001097          	auipc	ra,0x1
    800057f4:	b8e080e7          	jalr	-1138(ra) # 8000637e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057f8:	10001737          	lui	a4,0x10001
    800057fc:	533c                	lw	a5,96(a4)
    800057fe:	8b8d                	andi	a5,a5,3
    80005800:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005802:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005806:	0001b797          	auipc	a5,0x1b
    8000580a:	7fa78793          	addi	a5,a5,2042 # 80021000 <disk+0x2000>
    8000580e:	6b94                	ld	a3,16(a5)
    80005810:	0207d703          	lhu	a4,32(a5)
    80005814:	0026d783          	lhu	a5,2(a3)
    80005818:	06f70163          	beq	a4,a5,8000587a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000581c:	00019917          	auipc	s2,0x19
    80005820:	7e490913          	addi	s2,s2,2020 # 8001f000 <disk>
    80005824:	0001b497          	auipc	s1,0x1b
    80005828:	7dc48493          	addi	s1,s1,2012 # 80021000 <disk+0x2000>
    __sync_synchronize();
    8000582c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005830:	6898                	ld	a4,16(s1)
    80005832:	0204d783          	lhu	a5,32(s1)
    80005836:	8b9d                	andi	a5,a5,7
    80005838:	078e                	slli	a5,a5,0x3
    8000583a:	97ba                	add	a5,a5,a4
    8000583c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000583e:	20078713          	addi	a4,a5,512
    80005842:	0712                	slli	a4,a4,0x4
    80005844:	974a                	add	a4,a4,s2
    80005846:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000584a:	e731                	bnez	a4,80005896 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000584c:	20078793          	addi	a5,a5,512
    80005850:	0792                	slli	a5,a5,0x4
    80005852:	97ca                	add	a5,a5,s2
    80005854:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005856:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000585a:	ffffc097          	auipc	ra,0xffffc
    8000585e:	e3e080e7          	jalr	-450(ra) # 80001698 <wakeup>

    disk.used_idx += 1;
    80005862:	0204d783          	lhu	a5,32(s1)
    80005866:	2785                	addiw	a5,a5,1
    80005868:	17c2                	slli	a5,a5,0x30
    8000586a:	93c1                	srli	a5,a5,0x30
    8000586c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005870:	6898                	ld	a4,16(s1)
    80005872:	00275703          	lhu	a4,2(a4)
    80005876:	faf71be3          	bne	a4,a5,8000582c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000587a:	0001c517          	auipc	a0,0x1c
    8000587e:	8ae50513          	addi	a0,a0,-1874 # 80021128 <disk+0x2128>
    80005882:	00001097          	auipc	ra,0x1
    80005886:	bb0080e7          	jalr	-1104(ra) # 80006432 <release>
}
    8000588a:	60e2                	ld	ra,24(sp)
    8000588c:	6442                	ld	s0,16(sp)
    8000588e:	64a2                	ld	s1,8(sp)
    80005890:	6902                	ld	s2,0(sp)
    80005892:	6105                	addi	sp,sp,32
    80005894:	8082                	ret
      panic("virtio_disk_intr status");
    80005896:	00003517          	auipc	a0,0x3
    8000589a:	ef250513          	addi	a0,a0,-270 # 80008788 <syscalls+0x3c0>
    8000589e:	00000097          	auipc	ra,0x0
    800058a2:	52a080e7          	jalr	1322(ra) # 80005dc8 <panic>

00000000800058a6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058a6:	1141                	addi	sp,sp,-16
    800058a8:	e422                	sd	s0,8(sp)
    800058aa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058ac:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058b0:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058b4:	0037979b          	slliw	a5,a5,0x3
    800058b8:	02004737          	lui	a4,0x2004
    800058bc:	97ba                	add	a5,a5,a4
    800058be:	0200c737          	lui	a4,0x200c
    800058c2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058c6:	000f4637          	lui	a2,0xf4
    800058ca:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058ce:	95b2                	add	a1,a1,a2
    800058d0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058d2:	00269713          	slli	a4,a3,0x2
    800058d6:	9736                	add	a4,a4,a3
    800058d8:	00371693          	slli	a3,a4,0x3
    800058dc:	0001c717          	auipc	a4,0x1c
    800058e0:	72470713          	addi	a4,a4,1828 # 80022000 <timer_scratch>
    800058e4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058e6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058e8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058ea:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058ee:	00000797          	auipc	a5,0x0
    800058f2:	97278793          	addi	a5,a5,-1678 # 80005260 <timervec>
    800058f6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058fa:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058fe:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005902:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005906:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000590a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000590e:	30479073          	csrw	mie,a5
}
    80005912:	6422                	ld	s0,8(sp)
    80005914:	0141                	addi	sp,sp,16
    80005916:	8082                	ret

0000000080005918 <start>:
{
    80005918:	1141                	addi	sp,sp,-16
    8000591a:	e406                	sd	ra,8(sp)
    8000591c:	e022                	sd	s0,0(sp)
    8000591e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005920:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005924:	7779                	lui	a4,0xffffe
    80005926:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd45bf>
    8000592a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000592c:	6705                	lui	a4,0x1
    8000592e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005932:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005934:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005938:	ffffb797          	auipc	a5,0xffffb
    8000593c:	9ee78793          	addi	a5,a5,-1554 # 80000326 <main>
    80005940:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005944:	4781                	li	a5,0
    80005946:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000594a:	67c1                	lui	a5,0x10
    8000594c:	17fd                	addi	a5,a5,-1
    8000594e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005952:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005956:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000595a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000595e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005962:	57fd                	li	a5,-1
    80005964:	83a9                	srli	a5,a5,0xa
    80005966:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000596a:	47bd                	li	a5,15
    8000596c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005970:	00000097          	auipc	ra,0x0
    80005974:	f36080e7          	jalr	-202(ra) # 800058a6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005978:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000597c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000597e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005980:	30200073          	mret
}
    80005984:	60a2                	ld	ra,8(sp)
    80005986:	6402                	ld	s0,0(sp)
    80005988:	0141                	addi	sp,sp,16
    8000598a:	8082                	ret

000000008000598c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000598c:	715d                	addi	sp,sp,-80
    8000598e:	e486                	sd	ra,72(sp)
    80005990:	e0a2                	sd	s0,64(sp)
    80005992:	fc26                	sd	s1,56(sp)
    80005994:	f84a                	sd	s2,48(sp)
    80005996:	f44e                	sd	s3,40(sp)
    80005998:	f052                	sd	s4,32(sp)
    8000599a:	ec56                	sd	s5,24(sp)
    8000599c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000599e:	04c05663          	blez	a2,800059ea <consolewrite+0x5e>
    800059a2:	8a2a                	mv	s4,a0
    800059a4:	84ae                	mv	s1,a1
    800059a6:	89b2                	mv	s3,a2
    800059a8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059aa:	5afd                	li	s5,-1
    800059ac:	4685                	li	a3,1
    800059ae:	8626                	mv	a2,s1
    800059b0:	85d2                	mv	a1,s4
    800059b2:	fbf40513          	addi	a0,s0,-65
    800059b6:	ffffc097          	auipc	ra,0xffffc
    800059ba:	f50080e7          	jalr	-176(ra) # 80001906 <either_copyin>
    800059be:	01550c63          	beq	a0,s5,800059d6 <consolewrite+0x4a>
      break;
    uartputc(c);
    800059c2:	fbf44503          	lbu	a0,-65(s0)
    800059c6:	00000097          	auipc	ra,0x0
    800059ca:	7fa080e7          	jalr	2042(ra) # 800061c0 <uartputc>
  for(i = 0; i < n; i++){
    800059ce:	2905                	addiw	s2,s2,1
    800059d0:	0485                	addi	s1,s1,1
    800059d2:	fd299de3          	bne	s3,s2,800059ac <consolewrite+0x20>
  }

  return i;
}
    800059d6:	854a                	mv	a0,s2
    800059d8:	60a6                	ld	ra,72(sp)
    800059da:	6406                	ld	s0,64(sp)
    800059dc:	74e2                	ld	s1,56(sp)
    800059de:	7942                	ld	s2,48(sp)
    800059e0:	79a2                	ld	s3,40(sp)
    800059e2:	7a02                	ld	s4,32(sp)
    800059e4:	6ae2                	ld	s5,24(sp)
    800059e6:	6161                	addi	sp,sp,80
    800059e8:	8082                	ret
  for(i = 0; i < n; i++){
    800059ea:	4901                	li	s2,0
    800059ec:	b7ed                	j	800059d6 <consolewrite+0x4a>

00000000800059ee <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059ee:	7119                	addi	sp,sp,-128
    800059f0:	fc86                	sd	ra,120(sp)
    800059f2:	f8a2                	sd	s0,112(sp)
    800059f4:	f4a6                	sd	s1,104(sp)
    800059f6:	f0ca                	sd	s2,96(sp)
    800059f8:	ecce                	sd	s3,88(sp)
    800059fa:	e8d2                	sd	s4,80(sp)
    800059fc:	e4d6                	sd	s5,72(sp)
    800059fe:	e0da                	sd	s6,64(sp)
    80005a00:	fc5e                	sd	s7,56(sp)
    80005a02:	f862                	sd	s8,48(sp)
    80005a04:	f466                	sd	s9,40(sp)
    80005a06:	f06a                	sd	s10,32(sp)
    80005a08:	ec6e                	sd	s11,24(sp)
    80005a0a:	0100                	addi	s0,sp,128
    80005a0c:	8b2a                	mv	s6,a0
    80005a0e:	8aae                	mv	s5,a1
    80005a10:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a12:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a16:	00024517          	auipc	a0,0x24
    80005a1a:	72a50513          	addi	a0,a0,1834 # 8002a140 <cons>
    80005a1e:	00001097          	auipc	ra,0x1
    80005a22:	960080e7          	jalr	-1696(ra) # 8000637e <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a26:	00024497          	auipc	s1,0x24
    80005a2a:	71a48493          	addi	s1,s1,1818 # 8002a140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a2e:	89a6                	mv	s3,s1
    80005a30:	00024917          	auipc	s2,0x24
    80005a34:	7a890913          	addi	s2,s2,1960 # 8002a1d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a38:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a3a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a3c:	4da9                	li	s11,10
  while(n > 0){
    80005a3e:	07405863          	blez	s4,80005aae <consoleread+0xc0>
    while(cons.r == cons.w){
    80005a42:	0984a783          	lw	a5,152(s1)
    80005a46:	09c4a703          	lw	a4,156(s1)
    80005a4a:	02f71463          	bne	a4,a5,80005a72 <consoleread+0x84>
      if(myproc()->killed){
    80005a4e:	ffffb097          	auipc	ra,0xffffb
    80005a52:	3fa080e7          	jalr	1018(ra) # 80000e48 <myproc>
    80005a56:	551c                	lw	a5,40(a0)
    80005a58:	e7b5                	bnez	a5,80005ac4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005a5a:	85ce                	mv	a1,s3
    80005a5c:	854a                	mv	a0,s2
    80005a5e:	ffffc097          	auipc	ra,0xffffc
    80005a62:	aae080e7          	jalr	-1362(ra) # 8000150c <sleep>
    while(cons.r == cons.w){
    80005a66:	0984a783          	lw	a5,152(s1)
    80005a6a:	09c4a703          	lw	a4,156(s1)
    80005a6e:	fef700e3          	beq	a4,a5,80005a4e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a72:	0017871b          	addiw	a4,a5,1
    80005a76:	08e4ac23          	sw	a4,152(s1)
    80005a7a:	07f7f713          	andi	a4,a5,127
    80005a7e:	9726                	add	a4,a4,s1
    80005a80:	01874703          	lbu	a4,24(a4)
    80005a84:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a88:	079c0663          	beq	s8,s9,80005af4 <consoleread+0x106>
    cbuf = c;
    80005a8c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a90:	4685                	li	a3,1
    80005a92:	f8f40613          	addi	a2,s0,-113
    80005a96:	85d6                	mv	a1,s5
    80005a98:	855a                	mv	a0,s6
    80005a9a:	ffffc097          	auipc	ra,0xffffc
    80005a9e:	e16080e7          	jalr	-490(ra) # 800018b0 <either_copyout>
    80005aa2:	01a50663          	beq	a0,s10,80005aae <consoleread+0xc0>
    dst++;
    80005aa6:	0a85                	addi	s5,s5,1
    --n;
    80005aa8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005aaa:	f9bc1ae3          	bne	s8,s11,80005a3e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005aae:	00024517          	auipc	a0,0x24
    80005ab2:	69250513          	addi	a0,a0,1682 # 8002a140 <cons>
    80005ab6:	00001097          	auipc	ra,0x1
    80005aba:	97c080e7          	jalr	-1668(ra) # 80006432 <release>

  return target - n;
    80005abe:	414b853b          	subw	a0,s7,s4
    80005ac2:	a811                	j	80005ad6 <consoleread+0xe8>
        release(&cons.lock);
    80005ac4:	00024517          	auipc	a0,0x24
    80005ac8:	67c50513          	addi	a0,a0,1660 # 8002a140 <cons>
    80005acc:	00001097          	auipc	ra,0x1
    80005ad0:	966080e7          	jalr	-1690(ra) # 80006432 <release>
        return -1;
    80005ad4:	557d                	li	a0,-1
}
    80005ad6:	70e6                	ld	ra,120(sp)
    80005ad8:	7446                	ld	s0,112(sp)
    80005ada:	74a6                	ld	s1,104(sp)
    80005adc:	7906                	ld	s2,96(sp)
    80005ade:	69e6                	ld	s3,88(sp)
    80005ae0:	6a46                	ld	s4,80(sp)
    80005ae2:	6aa6                	ld	s5,72(sp)
    80005ae4:	6b06                	ld	s6,64(sp)
    80005ae6:	7be2                	ld	s7,56(sp)
    80005ae8:	7c42                	ld	s8,48(sp)
    80005aea:	7ca2                	ld	s9,40(sp)
    80005aec:	7d02                	ld	s10,32(sp)
    80005aee:	6de2                	ld	s11,24(sp)
    80005af0:	6109                	addi	sp,sp,128
    80005af2:	8082                	ret
      if(n < target){
    80005af4:	000a071b          	sext.w	a4,s4
    80005af8:	fb777be3          	bgeu	a4,s7,80005aae <consoleread+0xc0>
        cons.r--;
    80005afc:	00024717          	auipc	a4,0x24
    80005b00:	6cf72e23          	sw	a5,1756(a4) # 8002a1d8 <cons+0x98>
    80005b04:	b76d                	j	80005aae <consoleread+0xc0>

0000000080005b06 <consputc>:
{
    80005b06:	1141                	addi	sp,sp,-16
    80005b08:	e406                	sd	ra,8(sp)
    80005b0a:	e022                	sd	s0,0(sp)
    80005b0c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b0e:	10000793          	li	a5,256
    80005b12:	00f50a63          	beq	a0,a5,80005b26 <consputc+0x20>
    uartputc_sync(c);
    80005b16:	00000097          	auipc	ra,0x0
    80005b1a:	5d0080e7          	jalr	1488(ra) # 800060e6 <uartputc_sync>
}
    80005b1e:	60a2                	ld	ra,8(sp)
    80005b20:	6402                	ld	s0,0(sp)
    80005b22:	0141                	addi	sp,sp,16
    80005b24:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b26:	4521                	li	a0,8
    80005b28:	00000097          	auipc	ra,0x0
    80005b2c:	5be080e7          	jalr	1470(ra) # 800060e6 <uartputc_sync>
    80005b30:	02000513          	li	a0,32
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	5b2080e7          	jalr	1458(ra) # 800060e6 <uartputc_sync>
    80005b3c:	4521                	li	a0,8
    80005b3e:	00000097          	auipc	ra,0x0
    80005b42:	5a8080e7          	jalr	1448(ra) # 800060e6 <uartputc_sync>
    80005b46:	bfe1                	j	80005b1e <consputc+0x18>

0000000080005b48 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b48:	1101                	addi	sp,sp,-32
    80005b4a:	ec06                	sd	ra,24(sp)
    80005b4c:	e822                	sd	s0,16(sp)
    80005b4e:	e426                	sd	s1,8(sp)
    80005b50:	e04a                	sd	s2,0(sp)
    80005b52:	1000                	addi	s0,sp,32
    80005b54:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b56:	00024517          	auipc	a0,0x24
    80005b5a:	5ea50513          	addi	a0,a0,1514 # 8002a140 <cons>
    80005b5e:	00001097          	auipc	ra,0x1
    80005b62:	820080e7          	jalr	-2016(ra) # 8000637e <acquire>

  switch(c){
    80005b66:	47d5                	li	a5,21
    80005b68:	0af48663          	beq	s1,a5,80005c14 <consoleintr+0xcc>
    80005b6c:	0297ca63          	blt	a5,s1,80005ba0 <consoleintr+0x58>
    80005b70:	47a1                	li	a5,8
    80005b72:	0ef48763          	beq	s1,a5,80005c60 <consoleintr+0x118>
    80005b76:	47c1                	li	a5,16
    80005b78:	10f49a63          	bne	s1,a5,80005c8c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b7c:	ffffc097          	auipc	ra,0xffffc
    80005b80:	de0080e7          	jalr	-544(ra) # 8000195c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b84:	00024517          	auipc	a0,0x24
    80005b88:	5bc50513          	addi	a0,a0,1468 # 8002a140 <cons>
    80005b8c:	00001097          	auipc	ra,0x1
    80005b90:	8a6080e7          	jalr	-1882(ra) # 80006432 <release>
}
    80005b94:	60e2                	ld	ra,24(sp)
    80005b96:	6442                	ld	s0,16(sp)
    80005b98:	64a2                	ld	s1,8(sp)
    80005b9a:	6902                	ld	s2,0(sp)
    80005b9c:	6105                	addi	sp,sp,32
    80005b9e:	8082                	ret
  switch(c){
    80005ba0:	07f00793          	li	a5,127
    80005ba4:	0af48e63          	beq	s1,a5,80005c60 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ba8:	00024717          	auipc	a4,0x24
    80005bac:	59870713          	addi	a4,a4,1432 # 8002a140 <cons>
    80005bb0:	0a072783          	lw	a5,160(a4)
    80005bb4:	09872703          	lw	a4,152(a4)
    80005bb8:	9f99                	subw	a5,a5,a4
    80005bba:	07f00713          	li	a4,127
    80005bbe:	fcf763e3          	bltu	a4,a5,80005b84 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bc2:	47b5                	li	a5,13
    80005bc4:	0cf48763          	beq	s1,a5,80005c92 <consoleintr+0x14a>
      consputc(c);
    80005bc8:	8526                	mv	a0,s1
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	f3c080e7          	jalr	-196(ra) # 80005b06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bd2:	00024797          	auipc	a5,0x24
    80005bd6:	56e78793          	addi	a5,a5,1390 # 8002a140 <cons>
    80005bda:	0a07a703          	lw	a4,160(a5)
    80005bde:	0017069b          	addiw	a3,a4,1
    80005be2:	0006861b          	sext.w	a2,a3
    80005be6:	0ad7a023          	sw	a3,160(a5)
    80005bea:	07f77713          	andi	a4,a4,127
    80005bee:	97ba                	add	a5,a5,a4
    80005bf0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bf4:	47a9                	li	a5,10
    80005bf6:	0cf48563          	beq	s1,a5,80005cc0 <consoleintr+0x178>
    80005bfa:	4791                	li	a5,4
    80005bfc:	0cf48263          	beq	s1,a5,80005cc0 <consoleintr+0x178>
    80005c00:	00024797          	auipc	a5,0x24
    80005c04:	5d87a783          	lw	a5,1496(a5) # 8002a1d8 <cons+0x98>
    80005c08:	0807879b          	addiw	a5,a5,128
    80005c0c:	f6f61ce3          	bne	a2,a5,80005b84 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c10:	863e                	mv	a2,a5
    80005c12:	a07d                	j	80005cc0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c14:	00024717          	auipc	a4,0x24
    80005c18:	52c70713          	addi	a4,a4,1324 # 8002a140 <cons>
    80005c1c:	0a072783          	lw	a5,160(a4)
    80005c20:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c24:	00024497          	auipc	s1,0x24
    80005c28:	51c48493          	addi	s1,s1,1308 # 8002a140 <cons>
    while(cons.e != cons.w &&
    80005c2c:	4929                	li	s2,10
    80005c2e:	f4f70be3          	beq	a4,a5,80005b84 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c32:	37fd                	addiw	a5,a5,-1
    80005c34:	07f7f713          	andi	a4,a5,127
    80005c38:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c3a:	01874703          	lbu	a4,24(a4)
    80005c3e:	f52703e3          	beq	a4,s2,80005b84 <consoleintr+0x3c>
      cons.e--;
    80005c42:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c46:	10000513          	li	a0,256
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	ebc080e7          	jalr	-324(ra) # 80005b06 <consputc>
    while(cons.e != cons.w &&
    80005c52:	0a04a783          	lw	a5,160(s1)
    80005c56:	09c4a703          	lw	a4,156(s1)
    80005c5a:	fcf71ce3          	bne	a4,a5,80005c32 <consoleintr+0xea>
    80005c5e:	b71d                	j	80005b84 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c60:	00024717          	auipc	a4,0x24
    80005c64:	4e070713          	addi	a4,a4,1248 # 8002a140 <cons>
    80005c68:	0a072783          	lw	a5,160(a4)
    80005c6c:	09c72703          	lw	a4,156(a4)
    80005c70:	f0f70ae3          	beq	a4,a5,80005b84 <consoleintr+0x3c>
      cons.e--;
    80005c74:	37fd                	addiw	a5,a5,-1
    80005c76:	00024717          	auipc	a4,0x24
    80005c7a:	56f72523          	sw	a5,1386(a4) # 8002a1e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c7e:	10000513          	li	a0,256
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	e84080e7          	jalr	-380(ra) # 80005b06 <consputc>
    80005c8a:	bded                	j	80005b84 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c8c:	ee048ce3          	beqz	s1,80005b84 <consoleintr+0x3c>
    80005c90:	bf21                	j	80005ba8 <consoleintr+0x60>
      consputc(c);
    80005c92:	4529                	li	a0,10
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	e72080e7          	jalr	-398(ra) # 80005b06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c9c:	00024797          	auipc	a5,0x24
    80005ca0:	4a478793          	addi	a5,a5,1188 # 8002a140 <cons>
    80005ca4:	0a07a703          	lw	a4,160(a5)
    80005ca8:	0017069b          	addiw	a3,a4,1
    80005cac:	0006861b          	sext.w	a2,a3
    80005cb0:	0ad7a023          	sw	a3,160(a5)
    80005cb4:	07f77713          	andi	a4,a4,127
    80005cb8:	97ba                	add	a5,a5,a4
    80005cba:	4729                	li	a4,10
    80005cbc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cc0:	00024797          	auipc	a5,0x24
    80005cc4:	50c7ae23          	sw	a2,1308(a5) # 8002a1dc <cons+0x9c>
        wakeup(&cons.r);
    80005cc8:	00024517          	auipc	a0,0x24
    80005ccc:	51050513          	addi	a0,a0,1296 # 8002a1d8 <cons+0x98>
    80005cd0:	ffffc097          	auipc	ra,0xffffc
    80005cd4:	9c8080e7          	jalr	-1592(ra) # 80001698 <wakeup>
    80005cd8:	b575                	j	80005b84 <consoleintr+0x3c>

0000000080005cda <consoleinit>:

void
consoleinit(void)
{
    80005cda:	1141                	addi	sp,sp,-16
    80005cdc:	e406                	sd	ra,8(sp)
    80005cde:	e022                	sd	s0,0(sp)
    80005ce0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ce2:	00003597          	auipc	a1,0x3
    80005ce6:	abe58593          	addi	a1,a1,-1346 # 800087a0 <syscalls+0x3d8>
    80005cea:	00024517          	auipc	a0,0x24
    80005cee:	45650513          	addi	a0,a0,1110 # 8002a140 <cons>
    80005cf2:	00000097          	auipc	ra,0x0
    80005cf6:	5fc080e7          	jalr	1532(ra) # 800062ee <initlock>

  uartinit();
    80005cfa:	00000097          	auipc	ra,0x0
    80005cfe:	39c080e7          	jalr	924(ra) # 80006096 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d02:	00018797          	auipc	a5,0x18
    80005d06:	9c678793          	addi	a5,a5,-1594 # 8001d6c8 <devsw>
    80005d0a:	00000717          	auipc	a4,0x0
    80005d0e:	ce470713          	addi	a4,a4,-796 # 800059ee <consoleread>
    80005d12:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d14:	00000717          	auipc	a4,0x0
    80005d18:	c7870713          	addi	a4,a4,-904 # 8000598c <consolewrite>
    80005d1c:	ef98                	sd	a4,24(a5)
}
    80005d1e:	60a2                	ld	ra,8(sp)
    80005d20:	6402                	ld	s0,0(sp)
    80005d22:	0141                	addi	sp,sp,16
    80005d24:	8082                	ret

0000000080005d26 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d26:	7179                	addi	sp,sp,-48
    80005d28:	f406                	sd	ra,40(sp)
    80005d2a:	f022                	sd	s0,32(sp)
    80005d2c:	ec26                	sd	s1,24(sp)
    80005d2e:	e84a                	sd	s2,16(sp)
    80005d30:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d32:	c219                	beqz	a2,80005d38 <printint+0x12>
    80005d34:	08054663          	bltz	a0,80005dc0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d38:	2501                	sext.w	a0,a0
    80005d3a:	4881                	li	a7,0
    80005d3c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d40:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d42:	2581                	sext.w	a1,a1
    80005d44:	00003617          	auipc	a2,0x3
    80005d48:	aa460613          	addi	a2,a2,-1372 # 800087e8 <digits>
    80005d4c:	883a                	mv	a6,a4
    80005d4e:	2705                	addiw	a4,a4,1
    80005d50:	02b577bb          	remuw	a5,a0,a1
    80005d54:	1782                	slli	a5,a5,0x20
    80005d56:	9381                	srli	a5,a5,0x20
    80005d58:	97b2                	add	a5,a5,a2
    80005d5a:	0007c783          	lbu	a5,0(a5)
    80005d5e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d62:	0005079b          	sext.w	a5,a0
    80005d66:	02b5553b          	divuw	a0,a0,a1
    80005d6a:	0685                	addi	a3,a3,1
    80005d6c:	feb7f0e3          	bgeu	a5,a1,80005d4c <printint+0x26>

  if(sign)
    80005d70:	00088b63          	beqz	a7,80005d86 <printint+0x60>
    buf[i++] = '-';
    80005d74:	fe040793          	addi	a5,s0,-32
    80005d78:	973e                	add	a4,a4,a5
    80005d7a:	02d00793          	li	a5,45
    80005d7e:	fef70823          	sb	a5,-16(a4)
    80005d82:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d86:	02e05763          	blez	a4,80005db4 <printint+0x8e>
    80005d8a:	fd040793          	addi	a5,s0,-48
    80005d8e:	00e784b3          	add	s1,a5,a4
    80005d92:	fff78913          	addi	s2,a5,-1
    80005d96:	993a                	add	s2,s2,a4
    80005d98:	377d                	addiw	a4,a4,-1
    80005d9a:	1702                	slli	a4,a4,0x20
    80005d9c:	9301                	srli	a4,a4,0x20
    80005d9e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005da2:	fff4c503          	lbu	a0,-1(s1)
    80005da6:	00000097          	auipc	ra,0x0
    80005daa:	d60080e7          	jalr	-672(ra) # 80005b06 <consputc>
  while(--i >= 0)
    80005dae:	14fd                	addi	s1,s1,-1
    80005db0:	ff2499e3          	bne	s1,s2,80005da2 <printint+0x7c>
}
    80005db4:	70a2                	ld	ra,40(sp)
    80005db6:	7402                	ld	s0,32(sp)
    80005db8:	64e2                	ld	s1,24(sp)
    80005dba:	6942                	ld	s2,16(sp)
    80005dbc:	6145                	addi	sp,sp,48
    80005dbe:	8082                	ret
    x = -xx;
    80005dc0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005dc4:	4885                	li	a7,1
    x = -xx;
    80005dc6:	bf9d                	j	80005d3c <printint+0x16>

0000000080005dc8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005dc8:	1101                	addi	sp,sp,-32
    80005dca:	ec06                	sd	ra,24(sp)
    80005dcc:	e822                	sd	s0,16(sp)
    80005dce:	e426                	sd	s1,8(sp)
    80005dd0:	1000                	addi	s0,sp,32
    80005dd2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dd4:	00024797          	auipc	a5,0x24
    80005dd8:	4207a623          	sw	zero,1068(a5) # 8002a200 <pr+0x18>
  printf("panic: ");
    80005ddc:	00003517          	auipc	a0,0x3
    80005de0:	9cc50513          	addi	a0,a0,-1588 # 800087a8 <syscalls+0x3e0>
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	02e080e7          	jalr	46(ra) # 80005e12 <printf>
  printf(s);
    80005dec:	8526                	mv	a0,s1
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	024080e7          	jalr	36(ra) # 80005e12 <printf>
  printf("\n");
    80005df6:	00002517          	auipc	a0,0x2
    80005dfa:	25250513          	addi	a0,a0,594 # 80008048 <etext+0x48>
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	014080e7          	jalr	20(ra) # 80005e12 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e06:	4785                	li	a5,1
    80005e08:	00003717          	auipc	a4,0x3
    80005e0c:	20f72a23          	sw	a5,532(a4) # 8000901c <panicked>
  for(;;)
    80005e10:	a001                	j	80005e10 <panic+0x48>

0000000080005e12 <printf>:
{
    80005e12:	7131                	addi	sp,sp,-192
    80005e14:	fc86                	sd	ra,120(sp)
    80005e16:	f8a2                	sd	s0,112(sp)
    80005e18:	f4a6                	sd	s1,104(sp)
    80005e1a:	f0ca                	sd	s2,96(sp)
    80005e1c:	ecce                	sd	s3,88(sp)
    80005e1e:	e8d2                	sd	s4,80(sp)
    80005e20:	e4d6                	sd	s5,72(sp)
    80005e22:	e0da                	sd	s6,64(sp)
    80005e24:	fc5e                	sd	s7,56(sp)
    80005e26:	f862                	sd	s8,48(sp)
    80005e28:	f466                	sd	s9,40(sp)
    80005e2a:	f06a                	sd	s10,32(sp)
    80005e2c:	ec6e                	sd	s11,24(sp)
    80005e2e:	0100                	addi	s0,sp,128
    80005e30:	8a2a                	mv	s4,a0
    80005e32:	e40c                	sd	a1,8(s0)
    80005e34:	e810                	sd	a2,16(s0)
    80005e36:	ec14                	sd	a3,24(s0)
    80005e38:	f018                	sd	a4,32(s0)
    80005e3a:	f41c                	sd	a5,40(s0)
    80005e3c:	03043823          	sd	a6,48(s0)
    80005e40:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e44:	00024d97          	auipc	s11,0x24
    80005e48:	3bcdad83          	lw	s11,956(s11) # 8002a200 <pr+0x18>
  if(locking)
    80005e4c:	020d9b63          	bnez	s11,80005e82 <printf+0x70>
  if (fmt == 0)
    80005e50:	040a0263          	beqz	s4,80005e94 <printf+0x82>
  va_start(ap, fmt);
    80005e54:	00840793          	addi	a5,s0,8
    80005e58:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e5c:	000a4503          	lbu	a0,0(s4)
    80005e60:	16050263          	beqz	a0,80005fc4 <printf+0x1b2>
    80005e64:	4481                	li	s1,0
    if(c != '%'){
    80005e66:	02500a93          	li	s5,37
    switch(c){
    80005e6a:	07000b13          	li	s6,112
  consputc('x');
    80005e6e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e70:	00003b97          	auipc	s7,0x3
    80005e74:	978b8b93          	addi	s7,s7,-1672 # 800087e8 <digits>
    switch(c){
    80005e78:	07300c93          	li	s9,115
    80005e7c:	06400c13          	li	s8,100
    80005e80:	a82d                	j	80005eba <printf+0xa8>
    acquire(&pr.lock);
    80005e82:	00024517          	auipc	a0,0x24
    80005e86:	36650513          	addi	a0,a0,870 # 8002a1e8 <pr>
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	4f4080e7          	jalr	1268(ra) # 8000637e <acquire>
    80005e92:	bf7d                	j	80005e50 <printf+0x3e>
    panic("null fmt");
    80005e94:	00003517          	auipc	a0,0x3
    80005e98:	92450513          	addi	a0,a0,-1756 # 800087b8 <syscalls+0x3f0>
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	f2c080e7          	jalr	-212(ra) # 80005dc8 <panic>
      consputc(c);
    80005ea4:	00000097          	auipc	ra,0x0
    80005ea8:	c62080e7          	jalr	-926(ra) # 80005b06 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005eac:	2485                	addiw	s1,s1,1
    80005eae:	009a07b3          	add	a5,s4,s1
    80005eb2:	0007c503          	lbu	a0,0(a5)
    80005eb6:	10050763          	beqz	a0,80005fc4 <printf+0x1b2>
    if(c != '%'){
    80005eba:	ff5515e3          	bne	a0,s5,80005ea4 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005ebe:	2485                	addiw	s1,s1,1
    80005ec0:	009a07b3          	add	a5,s4,s1
    80005ec4:	0007c783          	lbu	a5,0(a5)
    80005ec8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005ecc:	cfe5                	beqz	a5,80005fc4 <printf+0x1b2>
    switch(c){
    80005ece:	05678a63          	beq	a5,s6,80005f22 <printf+0x110>
    80005ed2:	02fb7663          	bgeu	s6,a5,80005efe <printf+0xec>
    80005ed6:	09978963          	beq	a5,s9,80005f68 <printf+0x156>
    80005eda:	07800713          	li	a4,120
    80005ede:	0ce79863          	bne	a5,a4,80005fae <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005ee2:	f8843783          	ld	a5,-120(s0)
    80005ee6:	00878713          	addi	a4,a5,8
    80005eea:	f8e43423          	sd	a4,-120(s0)
    80005eee:	4605                	li	a2,1
    80005ef0:	85ea                	mv	a1,s10
    80005ef2:	4388                	lw	a0,0(a5)
    80005ef4:	00000097          	auipc	ra,0x0
    80005ef8:	e32080e7          	jalr	-462(ra) # 80005d26 <printint>
      break;
    80005efc:	bf45                	j	80005eac <printf+0x9a>
    switch(c){
    80005efe:	0b578263          	beq	a5,s5,80005fa2 <printf+0x190>
    80005f02:	0b879663          	bne	a5,s8,80005fae <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f06:	f8843783          	ld	a5,-120(s0)
    80005f0a:	00878713          	addi	a4,a5,8
    80005f0e:	f8e43423          	sd	a4,-120(s0)
    80005f12:	4605                	li	a2,1
    80005f14:	45a9                	li	a1,10
    80005f16:	4388                	lw	a0,0(a5)
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	e0e080e7          	jalr	-498(ra) # 80005d26 <printint>
      break;
    80005f20:	b771                	j	80005eac <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f22:	f8843783          	ld	a5,-120(s0)
    80005f26:	00878713          	addi	a4,a5,8
    80005f2a:	f8e43423          	sd	a4,-120(s0)
    80005f2e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f32:	03000513          	li	a0,48
    80005f36:	00000097          	auipc	ra,0x0
    80005f3a:	bd0080e7          	jalr	-1072(ra) # 80005b06 <consputc>
  consputc('x');
    80005f3e:	07800513          	li	a0,120
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	bc4080e7          	jalr	-1084(ra) # 80005b06 <consputc>
    80005f4a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f4c:	03c9d793          	srli	a5,s3,0x3c
    80005f50:	97de                	add	a5,a5,s7
    80005f52:	0007c503          	lbu	a0,0(a5)
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	bb0080e7          	jalr	-1104(ra) # 80005b06 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f5e:	0992                	slli	s3,s3,0x4
    80005f60:	397d                	addiw	s2,s2,-1
    80005f62:	fe0915e3          	bnez	s2,80005f4c <printf+0x13a>
    80005f66:	b799                	j	80005eac <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f68:	f8843783          	ld	a5,-120(s0)
    80005f6c:	00878713          	addi	a4,a5,8
    80005f70:	f8e43423          	sd	a4,-120(s0)
    80005f74:	0007b903          	ld	s2,0(a5)
    80005f78:	00090e63          	beqz	s2,80005f94 <printf+0x182>
      for(; *s; s++)
    80005f7c:	00094503          	lbu	a0,0(s2)
    80005f80:	d515                	beqz	a0,80005eac <printf+0x9a>
        consputc(*s);
    80005f82:	00000097          	auipc	ra,0x0
    80005f86:	b84080e7          	jalr	-1148(ra) # 80005b06 <consputc>
      for(; *s; s++)
    80005f8a:	0905                	addi	s2,s2,1
    80005f8c:	00094503          	lbu	a0,0(s2)
    80005f90:	f96d                	bnez	a0,80005f82 <printf+0x170>
    80005f92:	bf29                	j	80005eac <printf+0x9a>
        s = "(null)";
    80005f94:	00003917          	auipc	s2,0x3
    80005f98:	81c90913          	addi	s2,s2,-2020 # 800087b0 <syscalls+0x3e8>
      for(; *s; s++)
    80005f9c:	02800513          	li	a0,40
    80005fa0:	b7cd                	j	80005f82 <printf+0x170>
      consputc('%');
    80005fa2:	8556                	mv	a0,s5
    80005fa4:	00000097          	auipc	ra,0x0
    80005fa8:	b62080e7          	jalr	-1182(ra) # 80005b06 <consputc>
      break;
    80005fac:	b701                	j	80005eac <printf+0x9a>
      consputc('%');
    80005fae:	8556                	mv	a0,s5
    80005fb0:	00000097          	auipc	ra,0x0
    80005fb4:	b56080e7          	jalr	-1194(ra) # 80005b06 <consputc>
      consputc(c);
    80005fb8:	854a                	mv	a0,s2
    80005fba:	00000097          	auipc	ra,0x0
    80005fbe:	b4c080e7          	jalr	-1204(ra) # 80005b06 <consputc>
      break;
    80005fc2:	b5ed                	j	80005eac <printf+0x9a>
  if(locking)
    80005fc4:	020d9163          	bnez	s11,80005fe6 <printf+0x1d4>
}
    80005fc8:	70e6                	ld	ra,120(sp)
    80005fca:	7446                	ld	s0,112(sp)
    80005fcc:	74a6                	ld	s1,104(sp)
    80005fce:	7906                	ld	s2,96(sp)
    80005fd0:	69e6                	ld	s3,88(sp)
    80005fd2:	6a46                	ld	s4,80(sp)
    80005fd4:	6aa6                	ld	s5,72(sp)
    80005fd6:	6b06                	ld	s6,64(sp)
    80005fd8:	7be2                	ld	s7,56(sp)
    80005fda:	7c42                	ld	s8,48(sp)
    80005fdc:	7ca2                	ld	s9,40(sp)
    80005fde:	7d02                	ld	s10,32(sp)
    80005fe0:	6de2                	ld	s11,24(sp)
    80005fe2:	6129                	addi	sp,sp,192
    80005fe4:	8082                	ret
    release(&pr.lock);
    80005fe6:	00024517          	auipc	a0,0x24
    80005fea:	20250513          	addi	a0,a0,514 # 8002a1e8 <pr>
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	444080e7          	jalr	1092(ra) # 80006432 <release>
}
    80005ff6:	bfc9                	j	80005fc8 <printf+0x1b6>

0000000080005ff8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ff8:	1101                	addi	sp,sp,-32
    80005ffa:	ec06                	sd	ra,24(sp)
    80005ffc:	e822                	sd	s0,16(sp)
    80005ffe:	e426                	sd	s1,8(sp)
    80006000:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006002:	00024497          	auipc	s1,0x24
    80006006:	1e648493          	addi	s1,s1,486 # 8002a1e8 <pr>
    8000600a:	00002597          	auipc	a1,0x2
    8000600e:	7be58593          	addi	a1,a1,1982 # 800087c8 <syscalls+0x400>
    80006012:	8526                	mv	a0,s1
    80006014:	00000097          	auipc	ra,0x0
    80006018:	2da080e7          	jalr	730(ra) # 800062ee <initlock>
  pr.locking = 1;
    8000601c:	4785                	li	a5,1
    8000601e:	cc9c                	sw	a5,24(s1)
}
    80006020:	60e2                	ld	ra,24(sp)
    80006022:	6442                	ld	s0,16(sp)
    80006024:	64a2                	ld	s1,8(sp)
    80006026:	6105                	addi	sp,sp,32
    80006028:	8082                	ret

000000008000602a <backtrace>:

void backtrace() {
    8000602a:	7179                	addi	sp,sp,-48
    8000602c:	f406                	sd	ra,40(sp)
    8000602e:	f022                	sd	s0,32(sp)
    80006030:	ec26                	sd	s1,24(sp)
    80006032:	e84a                	sd	s2,16(sp)
    80006034:	e44e                	sd	s3,8(sp)
    80006036:	e052                	sd	s4,0(sp)
    80006038:	1800                	addi	s0,sp,48
  printf("backtrace\n");
    8000603a:	00002517          	auipc	a0,0x2
    8000603e:	79650513          	addi	a0,a0,1942 # 800087d0 <syscalls+0x408>
    80006042:	00000097          	auipc	ra,0x0
    80006046:	dd0080e7          	jalr	-560(ra) # 80005e12 <printf>
  asm volatile("mv %0, fp" : "=r" (x));
    8000604a:	84a2                	mv	s1,s0
  uint64 fp = r_fp(), top, bottom, ra;
  top = PGROUNDUP(fp);
    8000604c:	6905                	lui	s2,0x1
    8000604e:	197d                	addi	s2,s2,-1
    80006050:	9926                	add	s2,s2,s1
    80006052:	79fd                	lui	s3,0xfffff
    80006054:	01397933          	and	s2,s2,s3
  bottom = PGROUNDDOWN(fp);
    80006058:	0134f9b3          	and	s3,s1,s3
  while (fp < top && fp > bottom) {
    8000605c:	0324f563          	bgeu	s1,s2,80006086 <backtrace+0x5c>
    80006060:	0299f363          	bgeu	s3,s1,80006086 <backtrace+0x5c>
    ra = *(uint64 *) (fp - 8);
    printf("%p\n",ra);
    80006064:	00002a17          	auipc	s4,0x2
    80006068:	77ca0a13          	addi	s4,s4,1916 # 800087e0 <syscalls+0x418>
    8000606c:	ff84b583          	ld	a1,-8(s1)
    80006070:	8552                	mv	a0,s4
    80006072:	00000097          	auipc	ra,0x0
    80006076:	da0080e7          	jalr	-608(ra) # 80005e12 <printf>
    fp = *(uint64 *) (fp - 16);
    8000607a:	ff04b483          	ld	s1,-16(s1)
  while (fp < top && fp > bottom) {
    8000607e:	0124f463          	bgeu	s1,s2,80006086 <backtrace+0x5c>
    80006082:	fe99e5e3          	bltu	s3,s1,8000606c <backtrace+0x42>
  } 
    80006086:	70a2                	ld	ra,40(sp)
    80006088:	7402                	ld	s0,32(sp)
    8000608a:	64e2                	ld	s1,24(sp)
    8000608c:	6942                	ld	s2,16(sp)
    8000608e:	69a2                	ld	s3,8(sp)
    80006090:	6a02                	ld	s4,0(sp)
    80006092:	6145                	addi	sp,sp,48
    80006094:	8082                	ret

0000000080006096 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006096:	1141                	addi	sp,sp,-16
    80006098:	e406                	sd	ra,8(sp)
    8000609a:	e022                	sd	s0,0(sp)
    8000609c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000609e:	100007b7          	lui	a5,0x10000
    800060a2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060a6:	f8000713          	li	a4,-128
    800060aa:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060ae:	470d                	li	a4,3
    800060b0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060b4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060b8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060bc:	469d                	li	a3,7
    800060be:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060c2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060c6:	00002597          	auipc	a1,0x2
    800060ca:	73a58593          	addi	a1,a1,1850 # 80008800 <digits+0x18>
    800060ce:	00024517          	auipc	a0,0x24
    800060d2:	13a50513          	addi	a0,a0,314 # 8002a208 <uart_tx_lock>
    800060d6:	00000097          	auipc	ra,0x0
    800060da:	218080e7          	jalr	536(ra) # 800062ee <initlock>
}
    800060de:	60a2                	ld	ra,8(sp)
    800060e0:	6402                	ld	s0,0(sp)
    800060e2:	0141                	addi	sp,sp,16
    800060e4:	8082                	ret

00000000800060e6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060e6:	1101                	addi	sp,sp,-32
    800060e8:	ec06                	sd	ra,24(sp)
    800060ea:	e822                	sd	s0,16(sp)
    800060ec:	e426                	sd	s1,8(sp)
    800060ee:	1000                	addi	s0,sp,32
    800060f0:	84aa                	mv	s1,a0
  push_off();
    800060f2:	00000097          	auipc	ra,0x0
    800060f6:	240080e7          	jalr	576(ra) # 80006332 <push_off>

  if(panicked){
    800060fa:	00003797          	auipc	a5,0x3
    800060fe:	f227a783          	lw	a5,-222(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006102:	10000737          	lui	a4,0x10000
  if(panicked){
    80006106:	c391                	beqz	a5,8000610a <uartputc_sync+0x24>
    for(;;)
    80006108:	a001                	j	80006108 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000610a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000610e:	0ff7f793          	andi	a5,a5,255
    80006112:	0207f793          	andi	a5,a5,32
    80006116:	dbf5                	beqz	a5,8000610a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006118:	0ff4f793          	andi	a5,s1,255
    8000611c:	10000737          	lui	a4,0x10000
    80006120:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006124:	00000097          	auipc	ra,0x0
    80006128:	2ae080e7          	jalr	686(ra) # 800063d2 <pop_off>
}
    8000612c:	60e2                	ld	ra,24(sp)
    8000612e:	6442                	ld	s0,16(sp)
    80006130:	64a2                	ld	s1,8(sp)
    80006132:	6105                	addi	sp,sp,32
    80006134:	8082                	ret

0000000080006136 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006136:	00003717          	auipc	a4,0x3
    8000613a:	eea73703          	ld	a4,-278(a4) # 80009020 <uart_tx_r>
    8000613e:	00003797          	auipc	a5,0x3
    80006142:	eea7b783          	ld	a5,-278(a5) # 80009028 <uart_tx_w>
    80006146:	06e78c63          	beq	a5,a4,800061be <uartstart+0x88>
{
    8000614a:	7139                	addi	sp,sp,-64
    8000614c:	fc06                	sd	ra,56(sp)
    8000614e:	f822                	sd	s0,48(sp)
    80006150:	f426                	sd	s1,40(sp)
    80006152:	f04a                	sd	s2,32(sp)
    80006154:	ec4e                	sd	s3,24(sp)
    80006156:	e852                	sd	s4,16(sp)
    80006158:	e456                	sd	s5,8(sp)
    8000615a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000615c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006160:	00024a17          	auipc	s4,0x24
    80006164:	0a8a0a13          	addi	s4,s4,168 # 8002a208 <uart_tx_lock>
    uart_tx_r += 1;
    80006168:	00003497          	auipc	s1,0x3
    8000616c:	eb848493          	addi	s1,s1,-328 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006170:	00003997          	auipc	s3,0x3
    80006174:	eb898993          	addi	s3,s3,-328 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006178:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000617c:	0ff7f793          	andi	a5,a5,255
    80006180:	0207f793          	andi	a5,a5,32
    80006184:	c785                	beqz	a5,800061ac <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006186:	01f77793          	andi	a5,a4,31
    8000618a:	97d2                	add	a5,a5,s4
    8000618c:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006190:	0705                	addi	a4,a4,1
    80006192:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006194:	8526                	mv	a0,s1
    80006196:	ffffb097          	auipc	ra,0xffffb
    8000619a:	502080e7          	jalr	1282(ra) # 80001698 <wakeup>
    
    WriteReg(THR, c);
    8000619e:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800061a2:	6098                	ld	a4,0(s1)
    800061a4:	0009b783          	ld	a5,0(s3)
    800061a8:	fce798e3          	bne	a5,a4,80006178 <uartstart+0x42>
  }
}
    800061ac:	70e2                	ld	ra,56(sp)
    800061ae:	7442                	ld	s0,48(sp)
    800061b0:	74a2                	ld	s1,40(sp)
    800061b2:	7902                	ld	s2,32(sp)
    800061b4:	69e2                	ld	s3,24(sp)
    800061b6:	6a42                	ld	s4,16(sp)
    800061b8:	6aa2                	ld	s5,8(sp)
    800061ba:	6121                	addi	sp,sp,64
    800061bc:	8082                	ret
    800061be:	8082                	ret

00000000800061c0 <uartputc>:
{
    800061c0:	7179                	addi	sp,sp,-48
    800061c2:	f406                	sd	ra,40(sp)
    800061c4:	f022                	sd	s0,32(sp)
    800061c6:	ec26                	sd	s1,24(sp)
    800061c8:	e84a                	sd	s2,16(sp)
    800061ca:	e44e                	sd	s3,8(sp)
    800061cc:	e052                	sd	s4,0(sp)
    800061ce:	1800                	addi	s0,sp,48
    800061d0:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800061d2:	00024517          	auipc	a0,0x24
    800061d6:	03650513          	addi	a0,a0,54 # 8002a208 <uart_tx_lock>
    800061da:	00000097          	auipc	ra,0x0
    800061de:	1a4080e7          	jalr	420(ra) # 8000637e <acquire>
  if(panicked){
    800061e2:	00003797          	auipc	a5,0x3
    800061e6:	e3a7a783          	lw	a5,-454(a5) # 8000901c <panicked>
    800061ea:	c391                	beqz	a5,800061ee <uartputc+0x2e>
    for(;;)
    800061ec:	a001                	j	800061ec <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061ee:	00003797          	auipc	a5,0x3
    800061f2:	e3a7b783          	ld	a5,-454(a5) # 80009028 <uart_tx_w>
    800061f6:	00003717          	auipc	a4,0x3
    800061fa:	e2a73703          	ld	a4,-470(a4) # 80009020 <uart_tx_r>
    800061fe:	02070713          	addi	a4,a4,32
    80006202:	02f71b63          	bne	a4,a5,80006238 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006206:	00024a17          	auipc	s4,0x24
    8000620a:	002a0a13          	addi	s4,s4,2 # 8002a208 <uart_tx_lock>
    8000620e:	00003497          	auipc	s1,0x3
    80006212:	e1248493          	addi	s1,s1,-494 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006216:	00003917          	auipc	s2,0x3
    8000621a:	e1290913          	addi	s2,s2,-494 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000621e:	85d2                	mv	a1,s4
    80006220:	8526                	mv	a0,s1
    80006222:	ffffb097          	auipc	ra,0xffffb
    80006226:	2ea080e7          	jalr	746(ra) # 8000150c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000622a:	00093783          	ld	a5,0(s2)
    8000622e:	6098                	ld	a4,0(s1)
    80006230:	02070713          	addi	a4,a4,32
    80006234:	fef705e3          	beq	a4,a5,8000621e <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006238:	00024497          	auipc	s1,0x24
    8000623c:	fd048493          	addi	s1,s1,-48 # 8002a208 <uart_tx_lock>
    80006240:	01f7f713          	andi	a4,a5,31
    80006244:	9726                	add	a4,a4,s1
    80006246:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000624a:	0785                	addi	a5,a5,1
    8000624c:	00003717          	auipc	a4,0x3
    80006250:	dcf73e23          	sd	a5,-548(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006254:	00000097          	auipc	ra,0x0
    80006258:	ee2080e7          	jalr	-286(ra) # 80006136 <uartstart>
      release(&uart_tx_lock);
    8000625c:	8526                	mv	a0,s1
    8000625e:	00000097          	auipc	ra,0x0
    80006262:	1d4080e7          	jalr	468(ra) # 80006432 <release>
}
    80006266:	70a2                	ld	ra,40(sp)
    80006268:	7402                	ld	s0,32(sp)
    8000626a:	64e2                	ld	s1,24(sp)
    8000626c:	6942                	ld	s2,16(sp)
    8000626e:	69a2                	ld	s3,8(sp)
    80006270:	6a02                	ld	s4,0(sp)
    80006272:	6145                	addi	sp,sp,48
    80006274:	8082                	ret

0000000080006276 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006276:	1141                	addi	sp,sp,-16
    80006278:	e422                	sd	s0,8(sp)
    8000627a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000627c:	100007b7          	lui	a5,0x10000
    80006280:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006284:	8b85                	andi	a5,a5,1
    80006286:	cb91                	beqz	a5,8000629a <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006288:	100007b7          	lui	a5,0x10000
    8000628c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006290:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006294:	6422                	ld	s0,8(sp)
    80006296:	0141                	addi	sp,sp,16
    80006298:	8082                	ret
    return -1;
    8000629a:	557d                	li	a0,-1
    8000629c:	bfe5                	j	80006294 <uartgetc+0x1e>

000000008000629e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    8000629e:	1101                	addi	sp,sp,-32
    800062a0:	ec06                	sd	ra,24(sp)
    800062a2:	e822                	sd	s0,16(sp)
    800062a4:	e426                	sd	s1,8(sp)
    800062a6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062a8:	54fd                	li	s1,-1
    int c = uartgetc();
    800062aa:	00000097          	auipc	ra,0x0
    800062ae:	fcc080e7          	jalr	-52(ra) # 80006276 <uartgetc>
    if(c == -1)
    800062b2:	00950763          	beq	a0,s1,800062c0 <uartintr+0x22>
      break;
    consoleintr(c);
    800062b6:	00000097          	auipc	ra,0x0
    800062ba:	892080e7          	jalr	-1902(ra) # 80005b48 <consoleintr>
  while(1){
    800062be:	b7f5                	j	800062aa <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062c0:	00024497          	auipc	s1,0x24
    800062c4:	f4848493          	addi	s1,s1,-184 # 8002a208 <uart_tx_lock>
    800062c8:	8526                	mv	a0,s1
    800062ca:	00000097          	auipc	ra,0x0
    800062ce:	0b4080e7          	jalr	180(ra) # 8000637e <acquire>
  uartstart();
    800062d2:	00000097          	auipc	ra,0x0
    800062d6:	e64080e7          	jalr	-412(ra) # 80006136 <uartstart>
  release(&uart_tx_lock);
    800062da:	8526                	mv	a0,s1
    800062dc:	00000097          	auipc	ra,0x0
    800062e0:	156080e7          	jalr	342(ra) # 80006432 <release>
}
    800062e4:	60e2                	ld	ra,24(sp)
    800062e6:	6442                	ld	s0,16(sp)
    800062e8:	64a2                	ld	s1,8(sp)
    800062ea:	6105                	addi	sp,sp,32
    800062ec:	8082                	ret

00000000800062ee <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062ee:	1141                	addi	sp,sp,-16
    800062f0:	e422                	sd	s0,8(sp)
    800062f2:	0800                	addi	s0,sp,16
  lk->name = name;
    800062f4:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062f6:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800062fa:	00053823          	sd	zero,16(a0)
}
    800062fe:	6422                	ld	s0,8(sp)
    80006300:	0141                	addi	sp,sp,16
    80006302:	8082                	ret

0000000080006304 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006304:	411c                	lw	a5,0(a0)
    80006306:	e399                	bnez	a5,8000630c <holding+0x8>
    80006308:	4501                	li	a0,0
  return r;
}
    8000630a:	8082                	ret
{
    8000630c:	1101                	addi	sp,sp,-32
    8000630e:	ec06                	sd	ra,24(sp)
    80006310:	e822                	sd	s0,16(sp)
    80006312:	e426                	sd	s1,8(sp)
    80006314:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006316:	6904                	ld	s1,16(a0)
    80006318:	ffffb097          	auipc	ra,0xffffb
    8000631c:	b14080e7          	jalr	-1260(ra) # 80000e2c <mycpu>
    80006320:	40a48533          	sub	a0,s1,a0
    80006324:	00153513          	seqz	a0,a0
}
    80006328:	60e2                	ld	ra,24(sp)
    8000632a:	6442                	ld	s0,16(sp)
    8000632c:	64a2                	ld	s1,8(sp)
    8000632e:	6105                	addi	sp,sp,32
    80006330:	8082                	ret

0000000080006332 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006332:	1101                	addi	sp,sp,-32
    80006334:	ec06                	sd	ra,24(sp)
    80006336:	e822                	sd	s0,16(sp)
    80006338:	e426                	sd	s1,8(sp)
    8000633a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000633c:	100024f3          	csrr	s1,sstatus
    80006340:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006344:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006346:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000634a:	ffffb097          	auipc	ra,0xffffb
    8000634e:	ae2080e7          	jalr	-1310(ra) # 80000e2c <mycpu>
    80006352:	5d3c                	lw	a5,120(a0)
    80006354:	cf89                	beqz	a5,8000636e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006356:	ffffb097          	auipc	ra,0xffffb
    8000635a:	ad6080e7          	jalr	-1322(ra) # 80000e2c <mycpu>
    8000635e:	5d3c                	lw	a5,120(a0)
    80006360:	2785                	addiw	a5,a5,1
    80006362:	dd3c                	sw	a5,120(a0)
}
    80006364:	60e2                	ld	ra,24(sp)
    80006366:	6442                	ld	s0,16(sp)
    80006368:	64a2                	ld	s1,8(sp)
    8000636a:	6105                	addi	sp,sp,32
    8000636c:	8082                	ret
    mycpu()->intena = old;
    8000636e:	ffffb097          	auipc	ra,0xffffb
    80006372:	abe080e7          	jalr	-1346(ra) # 80000e2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006376:	8085                	srli	s1,s1,0x1
    80006378:	8885                	andi	s1,s1,1
    8000637a:	dd64                	sw	s1,124(a0)
    8000637c:	bfe9                	j	80006356 <push_off+0x24>

000000008000637e <acquire>:
{
    8000637e:	1101                	addi	sp,sp,-32
    80006380:	ec06                	sd	ra,24(sp)
    80006382:	e822                	sd	s0,16(sp)
    80006384:	e426                	sd	s1,8(sp)
    80006386:	1000                	addi	s0,sp,32
    80006388:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000638a:	00000097          	auipc	ra,0x0
    8000638e:	fa8080e7          	jalr	-88(ra) # 80006332 <push_off>
  if(holding(lk))
    80006392:	8526                	mv	a0,s1
    80006394:	00000097          	auipc	ra,0x0
    80006398:	f70080e7          	jalr	-144(ra) # 80006304 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000639c:	4705                	li	a4,1
  if(holding(lk))
    8000639e:	e115                	bnez	a0,800063c2 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063a0:	87ba                	mv	a5,a4
    800063a2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063a6:	2781                	sext.w	a5,a5
    800063a8:	ffe5                	bnez	a5,800063a0 <acquire+0x22>
  __sync_synchronize();
    800063aa:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063ae:	ffffb097          	auipc	ra,0xffffb
    800063b2:	a7e080e7          	jalr	-1410(ra) # 80000e2c <mycpu>
    800063b6:	e888                	sd	a0,16(s1)
}
    800063b8:	60e2                	ld	ra,24(sp)
    800063ba:	6442                	ld	s0,16(sp)
    800063bc:	64a2                	ld	s1,8(sp)
    800063be:	6105                	addi	sp,sp,32
    800063c0:	8082                	ret
    panic("acquire");
    800063c2:	00002517          	auipc	a0,0x2
    800063c6:	44650513          	addi	a0,a0,1094 # 80008808 <digits+0x20>
    800063ca:	00000097          	auipc	ra,0x0
    800063ce:	9fe080e7          	jalr	-1538(ra) # 80005dc8 <panic>

00000000800063d2 <pop_off>:

void
pop_off(void)
{
    800063d2:	1141                	addi	sp,sp,-16
    800063d4:	e406                	sd	ra,8(sp)
    800063d6:	e022                	sd	s0,0(sp)
    800063d8:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063da:	ffffb097          	auipc	ra,0xffffb
    800063de:	a52080e7          	jalr	-1454(ra) # 80000e2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063e2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063e6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063e8:	e78d                	bnez	a5,80006412 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063ea:	5d3c                	lw	a5,120(a0)
    800063ec:	02f05b63          	blez	a5,80006422 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063f0:	37fd                	addiw	a5,a5,-1
    800063f2:	0007871b          	sext.w	a4,a5
    800063f6:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063f8:	eb09                	bnez	a4,8000640a <pop_off+0x38>
    800063fa:	5d7c                	lw	a5,124(a0)
    800063fc:	c799                	beqz	a5,8000640a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006402:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006406:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000640a:	60a2                	ld	ra,8(sp)
    8000640c:	6402                	ld	s0,0(sp)
    8000640e:	0141                	addi	sp,sp,16
    80006410:	8082                	ret
    panic("pop_off - interruptible");
    80006412:	00002517          	auipc	a0,0x2
    80006416:	3fe50513          	addi	a0,a0,1022 # 80008810 <digits+0x28>
    8000641a:	00000097          	auipc	ra,0x0
    8000641e:	9ae080e7          	jalr	-1618(ra) # 80005dc8 <panic>
    panic("pop_off");
    80006422:	00002517          	auipc	a0,0x2
    80006426:	40650513          	addi	a0,a0,1030 # 80008828 <digits+0x40>
    8000642a:	00000097          	auipc	ra,0x0
    8000642e:	99e080e7          	jalr	-1634(ra) # 80005dc8 <panic>

0000000080006432 <release>:
{
    80006432:	1101                	addi	sp,sp,-32
    80006434:	ec06                	sd	ra,24(sp)
    80006436:	e822                	sd	s0,16(sp)
    80006438:	e426                	sd	s1,8(sp)
    8000643a:	1000                	addi	s0,sp,32
    8000643c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000643e:	00000097          	auipc	ra,0x0
    80006442:	ec6080e7          	jalr	-314(ra) # 80006304 <holding>
    80006446:	c115                	beqz	a0,8000646a <release+0x38>
  lk->cpu = 0;
    80006448:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000644c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006450:	0f50000f          	fence	iorw,ow
    80006454:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006458:	00000097          	auipc	ra,0x0
    8000645c:	f7a080e7          	jalr	-134(ra) # 800063d2 <pop_off>
}
    80006460:	60e2                	ld	ra,24(sp)
    80006462:	6442                	ld	s0,16(sp)
    80006464:	64a2                	ld	s1,8(sp)
    80006466:	6105                	addi	sp,sp,32
    80006468:	8082                	ret
    panic("release");
    8000646a:	00002517          	auipc	a0,0x2
    8000646e:	3c650513          	addi	a0,a0,966 # 80008830 <digits+0x48>
    80006472:	00000097          	auipc	ra,0x0
    80006476:	956080e7          	jalr	-1706(ra) # 80005dc8 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
