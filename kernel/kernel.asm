
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00008117          	auipc	sp,0x8
    80000004:	85813103          	ld	sp,-1960(sp) # 80007858 <_GLOBAL_OFFSET_TABLE_+0x8>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	5e1040ef          	jal	ra,80004df6 <start>

000000008000001a <spin>:
spin:
        j spin
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
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00021797          	auipc	a5,0x21
    80000034:	b7878793          	addi	a5,a5,-1160 # 80020ba8 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");


#ifndef LAB_SYSCALL
  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	104000ef          	jal	ra,8000014c <memset>
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	00008917          	auipc	s2,0x8
    80000050:	85490913          	addi	s2,s2,-1964 # 800078a0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	78a050ef          	jal	ra,800057e0 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	013050ef          	jal	ra,80005878 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f9a50513          	addi	a0,a0,-102 # 80007010 <etext+0x10>
    8000007e:	4a8050ef          	jal	ra,80005526 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	e84a                	sd	s2,16(sp)
    8000008c:	e44e                	sd	s3,8(sp)
    8000008e:	e052                	sd	s4,0(sp)
    80000090:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000092:	6785                	lui	a5,0x1
    80000094:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000098:	94aa                	add	s1,s1,a0
    8000009a:	757d                	lui	a0,0xfffff
    8000009c:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8000009e:	94be                	add	s1,s1,a5
    800000a0:	0095ec63          	bltu	a1,s1,800000b8 <freerange+0x36>
    800000a4:	892e                	mv	s2,a1
    kfree(p);
    800000a6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000a8:	6985                	lui	s3,0x1
    kfree(p);
    800000aa:	01448533          	add	a0,s1,s4
    800000ae:	f6fff0ef          	jal	ra,8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000b2:	94ce                	add	s1,s1,s3
    800000b4:	fe997be3          	bgeu	s2,s1,800000aa <freerange+0x28>
}
    800000b8:	70a2                	ld	ra,40(sp)
    800000ba:	7402                	ld	s0,32(sp)
    800000bc:	64e2                	ld	s1,24(sp)
    800000be:	6942                	ld	s2,16(sp)
    800000c0:	69a2                	ld	s3,8(sp)
    800000c2:	6a02                	ld	s4,0(sp)
    800000c4:	6145                	addi	sp,sp,48
    800000c6:	8082                	ret

00000000800000c8 <kinit>:
{
    800000c8:	1141                	addi	sp,sp,-16
    800000ca:	e406                	sd	ra,8(sp)
    800000cc:	e022                	sd	s0,0(sp)
    800000ce:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d0:	00007597          	auipc	a1,0x7
    800000d4:	f4858593          	addi	a1,a1,-184 # 80007018 <etext+0x18>
    800000d8:	00007517          	auipc	a0,0x7
    800000dc:	7c850513          	addi	a0,a0,1992 # 800078a0 <kmem>
    800000e0:	680050ef          	jal	ra,80005760 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e4:	45c5                	li	a1,17
    800000e6:	05ee                	slli	a1,a1,0x1b
    800000e8:	00021517          	auipc	a0,0x21
    800000ec:	ac050513          	addi	a0,a0,-1344 # 80020ba8 <end>
    800000f0:	f93ff0ef          	jal	ra,80000082 <freerange>
}
    800000f4:	60a2                	ld	ra,8(sp)
    800000f6:	6402                	ld	s0,0(sp)
    800000f8:	0141                	addi	sp,sp,16
    800000fa:	8082                	ret

00000000800000fc <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fc:	1101                	addi	sp,sp,-32
    800000fe:	ec06                	sd	ra,24(sp)
    80000100:	e822                	sd	s0,16(sp)
    80000102:	e426                	sd	s1,8(sp)
    80000104:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000106:	00007497          	auipc	s1,0x7
    8000010a:	79a48493          	addi	s1,s1,1946 # 800078a0 <kmem>
    8000010e:	8526                	mv	a0,s1
    80000110:	6d0050ef          	jal	ra,800057e0 <acquire>
  r = kmem.freelist;
    80000114:	6c84                	ld	s1,24(s1)
  if(r) {
    80000116:	c485                	beqz	s1,8000013e <kalloc+0x42>
    kmem.freelist = r->next;
    80000118:	609c                	ld	a5,0(s1)
    8000011a:	00007517          	auipc	a0,0x7
    8000011e:	78650513          	addi	a0,a0,1926 # 800078a0 <kmem>
    80000122:	ed1c                	sd	a5,24(a0)
  }
  release(&kmem.lock);
    80000124:	754050ef          	jal	ra,80005878 <release>
#ifndef LAB_SYSCALL
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000128:	6605                	lui	a2,0x1
    8000012a:	4595                	li	a1,5
    8000012c:	8526                	mv	a0,s1
    8000012e:	01e000ef          	jal	ra,8000014c <memset>
#endif
  return (void*)r;
}
    80000132:	8526                	mv	a0,s1
    80000134:	60e2                	ld	ra,24(sp)
    80000136:	6442                	ld	s0,16(sp)
    80000138:	64a2                	ld	s1,8(sp)
    8000013a:	6105                	addi	sp,sp,32
    8000013c:	8082                	ret
  release(&kmem.lock);
    8000013e:	00007517          	auipc	a0,0x7
    80000142:	76250513          	addi	a0,a0,1890 # 800078a0 <kmem>
    80000146:	732050ef          	jal	ra,80005878 <release>
  if(r)
    8000014a:	b7e5                	j	80000132 <kalloc+0x36>

000000008000014c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014c:	1141                	addi	sp,sp,-16
    8000014e:	e422                	sd	s0,8(sp)
    80000150:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000152:	ce09                	beqz	a2,8000016c <memset+0x20>
    80000154:	87aa                	mv	a5,a0
    80000156:	fff6071b          	addiw	a4,a2,-1
    8000015a:	1702                	slli	a4,a4,0x20
    8000015c:	9301                	srli	a4,a4,0x20
    8000015e:	0705                	addi	a4,a4,1
    80000160:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000162:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000166:	0785                	addi	a5,a5,1
    80000168:	fee79de3          	bne	a5,a4,80000162 <memset+0x16>
  }
  return dst;
}
    8000016c:	6422                	ld	s0,8(sp)
    8000016e:	0141                	addi	sp,sp,16
    80000170:	8082                	ret

0000000080000172 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000172:	1141                	addi	sp,sp,-16
    80000174:	e422                	sd	s0,8(sp)
    80000176:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000178:	ca05                	beqz	a2,800001a8 <memcmp+0x36>
    8000017a:	fff6069b          	addiw	a3,a2,-1
    8000017e:	1682                	slli	a3,a3,0x20
    80000180:	9281                	srli	a3,a3,0x20
    80000182:	0685                	addi	a3,a3,1
    80000184:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000186:	00054783          	lbu	a5,0(a0)
    8000018a:	0005c703          	lbu	a4,0(a1)
    8000018e:	00e79863          	bne	a5,a4,8000019e <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000192:	0505                	addi	a0,a0,1
    80000194:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000196:	fed518e3          	bne	a0,a3,80000186 <memcmp+0x14>
  }

  return 0;
    8000019a:	4501                	li	a0,0
    8000019c:	a019                	j	800001a2 <memcmp+0x30>
      return *s1 - *s2;
    8000019e:	40e7853b          	subw	a0,a5,a4
}
    800001a2:	6422                	ld	s0,8(sp)
    800001a4:	0141                	addi	sp,sp,16
    800001a6:	8082                	ret
  return 0;
    800001a8:	4501                	li	a0,0
    800001aa:	bfe5                	j	800001a2 <memcmp+0x30>

00000000800001ac <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001ac:	1141                	addi	sp,sp,-16
    800001ae:	e422                	sd	s0,8(sp)
    800001b0:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b2:	ca0d                	beqz	a2,800001e4 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b4:	00a5f963          	bgeu	a1,a0,800001c6 <memmove+0x1a>
    800001b8:	02061693          	slli	a3,a2,0x20
    800001bc:	9281                	srli	a3,a3,0x20
    800001be:	00d58733          	add	a4,a1,a3
    800001c2:	02e56463          	bltu	a0,a4,800001ea <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001c6:	fff6079b          	addiw	a5,a2,-1
    800001ca:	1782                	slli	a5,a5,0x20
    800001cc:	9381                	srli	a5,a5,0x20
    800001ce:	0785                	addi	a5,a5,1
    800001d0:	97ae                	add	a5,a5,a1
    800001d2:	872a                	mv	a4,a0
      *d++ = *s++;
    800001d4:	0585                	addi	a1,a1,1
    800001d6:	0705                	addi	a4,a4,1
    800001d8:	fff5c683          	lbu	a3,-1(a1)
    800001dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001e0:	fef59ae3          	bne	a1,a5,800001d4 <memmove+0x28>

  return dst;
}
    800001e4:	6422                	ld	s0,8(sp)
    800001e6:	0141                	addi	sp,sp,16
    800001e8:	8082                	ret
    d += n;
    800001ea:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001ec:	fff6079b          	addiw	a5,a2,-1
    800001f0:	1782                	slli	a5,a5,0x20
    800001f2:	9381                	srli	a5,a5,0x20
    800001f4:	fff7c793          	not	a5,a5
    800001f8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001fa:	177d                	addi	a4,a4,-1
    800001fc:	16fd                	addi	a3,a3,-1
    800001fe:	00074603          	lbu	a2,0(a4)
    80000202:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000206:	fef71ae3          	bne	a4,a5,800001fa <memmove+0x4e>
    8000020a:	bfe9                	j	800001e4 <memmove+0x38>

000000008000020c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000020c:	1141                	addi	sp,sp,-16
    8000020e:	e406                	sd	ra,8(sp)
    80000210:	e022                	sd	s0,0(sp)
    80000212:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000214:	f99ff0ef          	jal	ra,800001ac <memmove>
}
    80000218:	60a2                	ld	ra,8(sp)
    8000021a:	6402                	ld	s0,0(sp)
    8000021c:	0141                	addi	sp,sp,16
    8000021e:	8082                	ret

0000000080000220 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000220:	1141                	addi	sp,sp,-16
    80000222:	e422                	sd	s0,8(sp)
    80000224:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000226:	ce11                	beqz	a2,80000242 <strncmp+0x22>
    80000228:	00054783          	lbu	a5,0(a0)
    8000022c:	cf89                	beqz	a5,80000246 <strncmp+0x26>
    8000022e:	0005c703          	lbu	a4,0(a1)
    80000232:	00f71a63          	bne	a4,a5,80000246 <strncmp+0x26>
    n--, p++, q++;
    80000236:	367d                	addiw	a2,a2,-1
    80000238:	0505                	addi	a0,a0,1
    8000023a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000023c:	f675                	bnez	a2,80000228 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000023e:	4501                	li	a0,0
    80000240:	a809                	j	80000252 <strncmp+0x32>
    80000242:	4501                	li	a0,0
    80000244:	a039                	j	80000252 <strncmp+0x32>
  if(n == 0)
    80000246:	ca09                	beqz	a2,80000258 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000248:	00054503          	lbu	a0,0(a0)
    8000024c:	0005c783          	lbu	a5,0(a1)
    80000250:	9d1d                	subw	a0,a0,a5
}
    80000252:	6422                	ld	s0,8(sp)
    80000254:	0141                	addi	sp,sp,16
    80000256:	8082                	ret
    return 0;
    80000258:	4501                	li	a0,0
    8000025a:	bfe5                	j	80000252 <strncmp+0x32>

000000008000025c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000025c:	1141                	addi	sp,sp,-16
    8000025e:	e422                	sd	s0,8(sp)
    80000260:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000262:	872a                	mv	a4,a0
    80000264:	8832                	mv	a6,a2
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	01005963          	blez	a6,8000027a <strncpy+0x1e>
    8000026c:	0705                	addi	a4,a4,1
    8000026e:	0005c783          	lbu	a5,0(a1)
    80000272:	fef70fa3          	sb	a5,-1(a4)
    80000276:	0585                	addi	a1,a1,1
    80000278:	f7f5                	bnez	a5,80000264 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000027a:	00c05d63          	blez	a2,80000294 <strncpy+0x38>
    8000027e:	86ba                	mv	a3,a4
    *s++ = 0;
    80000280:	0685                	addi	a3,a3,1
    80000282:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000286:	fff6c793          	not	a5,a3
    8000028a:	9fb9                	addw	a5,a5,a4
    8000028c:	010787bb          	addw	a5,a5,a6
    80000290:	fef048e3          	bgtz	a5,80000280 <strncpy+0x24>
  return os;
}
    80000294:	6422                	ld	s0,8(sp)
    80000296:	0141                	addi	sp,sp,16
    80000298:	8082                	ret

000000008000029a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000029a:	1141                	addi	sp,sp,-16
    8000029c:	e422                	sd	s0,8(sp)
    8000029e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002a0:	02c05363          	blez	a2,800002c6 <safestrcpy+0x2c>
    800002a4:	fff6069b          	addiw	a3,a2,-1
    800002a8:	1682                	slli	a3,a3,0x20
    800002aa:	9281                	srli	a3,a3,0x20
    800002ac:	96ae                	add	a3,a3,a1
    800002ae:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002b0:	00d58963          	beq	a1,a3,800002c2 <safestrcpy+0x28>
    800002b4:	0585                	addi	a1,a1,1
    800002b6:	0785                	addi	a5,a5,1
    800002b8:	fff5c703          	lbu	a4,-1(a1)
    800002bc:	fee78fa3          	sb	a4,-1(a5)
    800002c0:	fb65                	bnez	a4,800002b0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002c2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002c6:	6422                	ld	s0,8(sp)
    800002c8:	0141                	addi	sp,sp,16
    800002ca:	8082                	ret

00000000800002cc <strlen>:

int
strlen(const char *s)
{
    800002cc:	1141                	addi	sp,sp,-16
    800002ce:	e422                	sd	s0,8(sp)
    800002d0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002d2:	00054783          	lbu	a5,0(a0)
    800002d6:	cf91                	beqz	a5,800002f2 <strlen+0x26>
    800002d8:	0505                	addi	a0,a0,1
    800002da:	87aa                	mv	a5,a0
    800002dc:	4685                	li	a3,1
    800002de:	9e89                	subw	a3,a3,a0
    800002e0:	00f6853b          	addw	a0,a3,a5
    800002e4:	0785                	addi	a5,a5,1
    800002e6:	fff7c703          	lbu	a4,-1(a5)
    800002ea:	fb7d                	bnez	a4,800002e0 <strlen+0x14>
    ;
  return n;
}
    800002ec:	6422                	ld	s0,8(sp)
    800002ee:	0141                	addi	sp,sp,16
    800002f0:	8082                	ret
  for(n = 0; s[n]; n++)
    800002f2:	4501                	li	a0,0
    800002f4:	bfe5                	j	800002ec <strlen+0x20>

00000000800002f6 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e406                	sd	ra,8(sp)
    800002fa:	e022                	sd	s0,0(sp)
    800002fc:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002fe:	20f000ef          	jal	ra,80000d0c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000302:	00007717          	auipc	a4,0x7
    80000306:	56e70713          	addi	a4,a4,1390 # 80007870 <started>
  if(cpuid() == 0){
    8000030a:	c51d                	beqz	a0,80000338 <main+0x42>
    while(started == 0)
    8000030c:	431c                	lw	a5,0(a4)
    8000030e:	2781                	sext.w	a5,a5
    80000310:	dff5                	beqz	a5,8000030c <main+0x16>
      ;
    __sync_synchronize();
    80000312:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000316:	1f7000ef          	jal	ra,80000d0c <cpuid>
    8000031a:	85aa                	mv	a1,a0
    8000031c:	00007517          	auipc	a0,0x7
    80000320:	d1c50513          	addi	a0,a0,-740 # 80007038 <etext+0x38>
    80000324:	73d040ef          	jal	ra,80005260 <printf>
    kvminithart();    // turn on paging
    80000328:	080000ef          	jal	ra,800003a8 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000032c:	59e010ef          	jal	ra,800018ca <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000330:	4c4040ef          	jal	ra,800047f4 <plicinithart>
  }

  scheduler();        
    80000334:	65f000ef          	jal	ra,80001192 <scheduler>
    consoleinit();
    80000338:	651040ef          	jal	ra,80005188 <consoleinit>
    printfinit();
    8000033c:	226050ef          	jal	ra,80005562 <printfinit>
    printf("\n");
    80000340:	00007517          	auipc	a0,0x7
    80000344:	d0850513          	addi	a0,a0,-760 # 80007048 <etext+0x48>
    80000348:	719040ef          	jal	ra,80005260 <printf>
    printf("xv6 kernel is booting\n");
    8000034c:	00007517          	auipc	a0,0x7
    80000350:	cd450513          	addi	a0,a0,-812 # 80007020 <etext+0x20>
    80000354:	70d040ef          	jal	ra,80005260 <printf>
    printf("\n");
    80000358:	00007517          	auipc	a0,0x7
    8000035c:	cf050513          	addi	a0,a0,-784 # 80007048 <etext+0x48>
    80000360:	701040ef          	jal	ra,80005260 <printf>
    kinit();         // physical page allocator
    80000364:	d65ff0ef          	jal	ra,800000c8 <kinit>
    kvminit();       // create kernel page table
    80000368:	2ca000ef          	jal	ra,80000632 <kvminit>
    kvminithart();   // turn on paging
    8000036c:	03c000ef          	jal	ra,800003a8 <kvminithart>
    procinit();      // process table
    80000370:	0f5000ef          	jal	ra,80000c64 <procinit>
    trapinit();      // trap vectors
    80000374:	532010ef          	jal	ra,800018a6 <trapinit>
    trapinithart();  // install kernel trap vector
    80000378:	552010ef          	jal	ra,800018ca <trapinithart>
    plicinit();      // set up interrupt controller
    8000037c:	462040ef          	jal	ra,800047de <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000380:	474040ef          	jal	ra,800047f4 <plicinithart>
    binit();         // buffer cache
    80000384:	42d010ef          	jal	ra,80001fb0 <binit>
    iinit();         // inode table
    80000388:	1a0020ef          	jal	ra,80002528 <iinit>
    fileinit();      // file table
    8000038c:	080030ef          	jal	ra,8000340c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000390:	554040ef          	jal	ra,800048e4 <virtio_disk_init>
    userinit();      // first user process
    80000394:	46b000ef          	jal	ra,80000ffe <userinit>
    __sync_synchronize();
    80000398:	0ff0000f          	fence
    started = 1;
    8000039c:	4785                	li	a5,1
    8000039e:	00007717          	auipc	a4,0x7
    800003a2:	4cf72923          	sw	a5,1234(a4) # 80007870 <started>
    800003a6:	b779                	j	80000334 <main+0x3e>

00000000800003a8 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    800003a8:	1141                	addi	sp,sp,-16
    800003aa:	e422                	sd	s0,8(sp)
    800003ac:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003ae:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003b2:	00007797          	auipc	a5,0x7
    800003b6:	4c67b783          	ld	a5,1222(a5) # 80007878 <kernel_pagetable>
    800003ba:	83b1                	srli	a5,a5,0xc
    800003bc:	577d                	li	a4,-1
    800003be:	177e                	slli	a4,a4,0x3f
    800003c0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003c2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003c6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003ca:	6422                	ld	s0,8(sp)
    800003cc:	0141                	addi	sp,sp,16
    800003ce:	8082                	ret

00000000800003d0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003d0:	7139                	addi	sp,sp,-64
    800003d2:	fc06                	sd	ra,56(sp)
    800003d4:	f822                	sd	s0,48(sp)
    800003d6:	f426                	sd	s1,40(sp)
    800003d8:	f04a                	sd	s2,32(sp)
    800003da:	ec4e                	sd	s3,24(sp)
    800003dc:	e852                	sd	s4,16(sp)
    800003de:	e456                	sd	s5,8(sp)
    800003e0:	e05a                	sd	s6,0(sp)
    800003e2:	0080                	addi	s0,sp,64
    800003e4:	84aa                	mv	s1,a0
    800003e6:	89ae                	mv	s3,a1
    800003e8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003ea:	57fd                	li	a5,-1
    800003ec:	83e9                	srli	a5,a5,0x1a
    800003ee:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003f0:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003f2:	02b7fc63          	bgeu	a5,a1,8000042a <walk+0x5a>
    panic("walk");
    800003f6:	00007517          	auipc	a0,0x7
    800003fa:	c5a50513          	addi	a0,a0,-934 # 80007050 <etext+0x50>
    800003fe:	128050ef          	jal	ra,80005526 <panic>
      if(PTE_LEAF(*pte)) {
        return pte;
      }
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000402:	060a8263          	beqz	s5,80000466 <walk+0x96>
    80000406:	cf7ff0ef          	jal	ra,800000fc <kalloc>
    8000040a:	84aa                	mv	s1,a0
    8000040c:	c139                	beqz	a0,80000452 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000040e:	6605                	lui	a2,0x1
    80000410:	4581                	li	a1,0
    80000412:	d3bff0ef          	jal	ra,8000014c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000416:	00c4d793          	srli	a5,s1,0xc
    8000041a:	07aa                	slli	a5,a5,0xa
    8000041c:	0017e793          	ori	a5,a5,1
    80000420:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000424:	3a5d                	addiw	s4,s4,-9
    80000426:	036a0063          	beq	s4,s6,80000446 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000042a:	0149d933          	srl	s2,s3,s4
    8000042e:	1ff97913          	andi	s2,s2,511
    80000432:	090e                	slli	s2,s2,0x3
    80000434:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000436:	00093483          	ld	s1,0(s2)
    8000043a:	0014f793          	andi	a5,s1,1
    8000043e:	d3f1                	beqz	a5,80000402 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000440:	80a9                	srli	s1,s1,0xa
    80000442:	04b2                	slli	s1,s1,0xc
    80000444:	b7c5                	j	80000424 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000446:	00c9d513          	srli	a0,s3,0xc
    8000044a:	1ff57513          	andi	a0,a0,511
    8000044e:	050e                	slli	a0,a0,0x3
    80000450:	9526                	add	a0,a0,s1
}
    80000452:	70e2                	ld	ra,56(sp)
    80000454:	7442                	ld	s0,48(sp)
    80000456:	74a2                	ld	s1,40(sp)
    80000458:	7902                	ld	s2,32(sp)
    8000045a:	69e2                	ld	s3,24(sp)
    8000045c:	6a42                	ld	s4,16(sp)
    8000045e:	6aa2                	ld	s5,8(sp)
    80000460:	6b02                	ld	s6,0(sp)
    80000462:	6121                	addi	sp,sp,64
    80000464:	8082                	ret
        return 0;
    80000466:	4501                	li	a0,0
    80000468:	b7ed                	j	80000452 <walk+0x82>

000000008000046a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000046a:	57fd                	li	a5,-1
    8000046c:	83e9                	srli	a5,a5,0x1a
    8000046e:	00b7f463          	bgeu	a5,a1,80000476 <walkaddr+0xc>
    return 0;
    80000472:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000474:	8082                	ret
{
    80000476:	1141                	addi	sp,sp,-16
    80000478:	e406                	sd	ra,8(sp)
    8000047a:	e022                	sd	s0,0(sp)
    8000047c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000047e:	4601                	li	a2,0
    80000480:	f51ff0ef          	jal	ra,800003d0 <walk>
  if(pte == 0)
    80000484:	c105                	beqz	a0,800004a4 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000486:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000488:	0117f693          	andi	a3,a5,17
    8000048c:	4745                	li	a4,17
    return 0;
    8000048e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000490:	00e68663          	beq	a3,a4,8000049c <walkaddr+0x32>
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret
  pa = PTE2PA(*pte);
    8000049c:	00a7d513          	srli	a0,a5,0xa
    800004a0:	0532                	slli	a0,a0,0xc
  return pa;
    800004a2:	bfcd                	j	80000494 <walkaddr+0x2a>
    return 0;
    800004a4:	4501                	li	a0,0
    800004a6:	b7fd                	j	80000494 <walkaddr+0x2a>

00000000800004a8 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004a8:	715d                	addi	sp,sp,-80
    800004aa:	e486                	sd	ra,72(sp)
    800004ac:	e0a2                	sd	s0,64(sp)
    800004ae:	fc26                	sd	s1,56(sp)
    800004b0:	f84a                	sd	s2,48(sp)
    800004b2:	f44e                	sd	s3,40(sp)
    800004b4:	f052                	sd	s4,32(sp)
    800004b6:	ec56                	sd	s5,24(sp)
    800004b8:	e85a                	sd	s6,16(sp)
    800004ba:	e45e                	sd	s7,8(sp)
    800004bc:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004be:	03459793          	slli	a5,a1,0x34
    800004c2:	e385                	bnez	a5,800004e2 <mappages+0x3a>
    800004c4:	8aaa                	mv	s5,a0
    800004c6:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004c8:	03461793          	slli	a5,a2,0x34
    800004cc:	e38d                	bnez	a5,800004ee <mappages+0x46>
    panic("mappages: size not aligned");

  if(size == 0)
    800004ce:	c615                	beqz	a2,800004fa <mappages+0x52>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004d0:	79fd                	lui	s3,0xfffff
    800004d2:	964e                	add	a2,a2,s3
    800004d4:	00b609b3          	add	s3,a2,a1
  a = va;
    800004d8:	892e                	mv	s2,a1
    800004da:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004de:	6b85                	lui	s7,0x1
    800004e0:	a815                	j	80000514 <mappages+0x6c>
    panic("mappages: va not aligned");
    800004e2:	00007517          	auipc	a0,0x7
    800004e6:	b7650513          	addi	a0,a0,-1162 # 80007058 <etext+0x58>
    800004ea:	03c050ef          	jal	ra,80005526 <panic>
    panic("mappages: size not aligned");
    800004ee:	00007517          	auipc	a0,0x7
    800004f2:	b8a50513          	addi	a0,a0,-1142 # 80007078 <etext+0x78>
    800004f6:	030050ef          	jal	ra,80005526 <panic>
    panic("mappages: size");
    800004fa:	00007517          	auipc	a0,0x7
    800004fe:	b9e50513          	addi	a0,a0,-1122 # 80007098 <etext+0x98>
    80000502:	024050ef          	jal	ra,80005526 <panic>
      panic("mappages: remap");
    80000506:	00007517          	auipc	a0,0x7
    8000050a:	ba250513          	addi	a0,a0,-1118 # 800070a8 <etext+0xa8>
    8000050e:	018050ef          	jal	ra,80005526 <panic>
    a += PGSIZE;
    80000512:	995e                	add	s2,s2,s7
  for(;;){
    80000514:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000518:	4605                	li	a2,1
    8000051a:	85ca                	mv	a1,s2
    8000051c:	8556                	mv	a0,s5
    8000051e:	eb3ff0ef          	jal	ra,800003d0 <walk>
    80000522:	cd19                	beqz	a0,80000540 <mappages+0x98>
    if(*pte & PTE_V)
    80000524:	611c                	ld	a5,0(a0)
    80000526:	8b85                	andi	a5,a5,1
    80000528:	fff9                	bnez	a5,80000506 <mappages+0x5e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000052a:	80b1                	srli	s1,s1,0xc
    8000052c:	04aa                	slli	s1,s1,0xa
    8000052e:	0164e4b3          	or	s1,s1,s6
    80000532:	0014e493          	ori	s1,s1,1
    80000536:	e104                	sd	s1,0(a0)
    if(a == last)
    80000538:	fd391de3          	bne	s2,s3,80000512 <mappages+0x6a>
    pa += PGSIZE;
  }
  return 0;
    8000053c:	4501                	li	a0,0
    8000053e:	a011                	j	80000542 <mappages+0x9a>
      return -1;
    80000540:	557d                	li	a0,-1
}
    80000542:	60a6                	ld	ra,72(sp)
    80000544:	6406                	ld	s0,64(sp)
    80000546:	74e2                	ld	s1,56(sp)
    80000548:	7942                	ld	s2,48(sp)
    8000054a:	79a2                	ld	s3,40(sp)
    8000054c:	7a02                	ld	s4,32(sp)
    8000054e:	6ae2                	ld	s5,24(sp)
    80000550:	6b42                	ld	s6,16(sp)
    80000552:	6ba2                	ld	s7,8(sp)
    80000554:	6161                	addi	sp,sp,80
    80000556:	8082                	ret

0000000080000558 <kvmmap>:
{
    80000558:	1141                	addi	sp,sp,-16
    8000055a:	e406                	sd	ra,8(sp)
    8000055c:	e022                	sd	s0,0(sp)
    8000055e:	0800                	addi	s0,sp,16
    80000560:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000562:	86b2                	mv	a3,a2
    80000564:	863e                	mv	a2,a5
    80000566:	f43ff0ef          	jal	ra,800004a8 <mappages>
    8000056a:	e509                	bnez	a0,80000574 <kvmmap+0x1c>
}
    8000056c:	60a2                	ld	ra,8(sp)
    8000056e:	6402                	ld	s0,0(sp)
    80000570:	0141                	addi	sp,sp,16
    80000572:	8082                	ret
    panic("kvmmap");
    80000574:	00007517          	auipc	a0,0x7
    80000578:	b4450513          	addi	a0,a0,-1212 # 800070b8 <etext+0xb8>
    8000057c:	7ab040ef          	jal	ra,80005526 <panic>

0000000080000580 <kvmmake>:
{
    80000580:	1101                	addi	sp,sp,-32
    80000582:	ec06                	sd	ra,24(sp)
    80000584:	e822                	sd	s0,16(sp)
    80000586:	e426                	sd	s1,8(sp)
    80000588:	e04a                	sd	s2,0(sp)
    8000058a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000058c:	b71ff0ef          	jal	ra,800000fc <kalloc>
    80000590:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000592:	6605                	lui	a2,0x1
    80000594:	4581                	li	a1,0
    80000596:	bb7ff0ef          	jal	ra,8000014c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000059a:	4719                	li	a4,6
    8000059c:	6685                	lui	a3,0x1
    8000059e:	10000637          	lui	a2,0x10000
    800005a2:	100005b7          	lui	a1,0x10000
    800005a6:	8526                	mv	a0,s1
    800005a8:	fb1ff0ef          	jal	ra,80000558 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005ac:	4719                	li	a4,6
    800005ae:	6685                	lui	a3,0x1
    800005b0:	10001637          	lui	a2,0x10001
    800005b4:	100015b7          	lui	a1,0x10001
    800005b8:	8526                	mv	a0,s1
    800005ba:	f9fff0ef          	jal	ra,80000558 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005be:	4719                	li	a4,6
    800005c0:	040006b7          	lui	a3,0x4000
    800005c4:	0c000637          	lui	a2,0xc000
    800005c8:	0c0005b7          	lui	a1,0xc000
    800005cc:	8526                	mv	a0,s1
    800005ce:	f8bff0ef          	jal	ra,80000558 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005d2:	00007917          	auipc	s2,0x7
    800005d6:	a2e90913          	addi	s2,s2,-1490 # 80007000 <etext>
    800005da:	4729                	li	a4,10
    800005dc:	80007697          	auipc	a3,0x80007
    800005e0:	a2468693          	addi	a3,a3,-1500 # 7000 <_entry-0x7fff9000>
    800005e4:	4605                	li	a2,1
    800005e6:	067e                	slli	a2,a2,0x1f
    800005e8:	85b2                	mv	a1,a2
    800005ea:	8526                	mv	a0,s1
    800005ec:	f6dff0ef          	jal	ra,80000558 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005f0:	4719                	li	a4,6
    800005f2:	46c5                	li	a3,17
    800005f4:	06ee                	slli	a3,a3,0x1b
    800005f6:	412686b3          	sub	a3,a3,s2
    800005fa:	864a                	mv	a2,s2
    800005fc:	85ca                	mv	a1,s2
    800005fe:	8526                	mv	a0,s1
    80000600:	f59ff0ef          	jal	ra,80000558 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000604:	4729                	li	a4,10
    80000606:	6685                	lui	a3,0x1
    80000608:	00006617          	auipc	a2,0x6
    8000060c:	9f860613          	addi	a2,a2,-1544 # 80006000 <_trampoline>
    80000610:	040005b7          	lui	a1,0x4000
    80000614:	15fd                	addi	a1,a1,-1
    80000616:	05b2                	slli	a1,a1,0xc
    80000618:	8526                	mv	a0,s1
    8000061a:	f3fff0ef          	jal	ra,80000558 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000061e:	8526                	mv	a0,s1
    80000620:	5ba000ef          	jal	ra,80000bda <proc_mapstacks>
}
    80000624:	8526                	mv	a0,s1
    80000626:	60e2                	ld	ra,24(sp)
    80000628:	6442                	ld	s0,16(sp)
    8000062a:	64a2                	ld	s1,8(sp)
    8000062c:	6902                	ld	s2,0(sp)
    8000062e:	6105                	addi	sp,sp,32
    80000630:	8082                	ret

0000000080000632 <kvminit>:
{
    80000632:	1141                	addi	sp,sp,-16
    80000634:	e406                	sd	ra,8(sp)
    80000636:	e022                	sd	s0,0(sp)
    80000638:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000063a:	f47ff0ef          	jal	ra,80000580 <kvmmake>
    8000063e:	00007797          	auipc	a5,0x7
    80000642:	22a7bd23          	sd	a0,570(a5) # 80007878 <kernel_pagetable>
}
    80000646:	60a2                	ld	ra,8(sp)
    80000648:	6402                	ld	s0,0(sp)
    8000064a:	0141                	addi	sp,sp,16
    8000064c:	8082                	ret

000000008000064e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000064e:	1101                	addi	sp,sp,-32
    80000650:	ec06                	sd	ra,24(sp)
    80000652:	e822                	sd	s0,16(sp)
    80000654:	e426                	sd	s1,8(sp)
    80000656:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000658:	aa5ff0ef          	jal	ra,800000fc <kalloc>
    8000065c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000065e:	c509                	beqz	a0,80000668 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000660:	6605                	lui	a2,0x1
    80000662:	4581                	li	a1,0
    80000664:	ae9ff0ef          	jal	ra,8000014c <memset>
  return pagetable;
}
    80000668:	8526                	mv	a0,s1
    8000066a:	60e2                	ld	ra,24(sp)
    8000066c:	6442                	ld	s0,16(sp)
    8000066e:	64a2                	ld	s1,8(sp)
    80000670:	6105                	addi	sp,sp,32
    80000672:	8082                	ret

0000000080000674 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000674:	715d                	addi	sp,sp,-80
    80000676:	e486                	sd	ra,72(sp)
    80000678:	e0a2                	sd	s0,64(sp)
    8000067a:	fc26                	sd	s1,56(sp)
    8000067c:	f84a                	sd	s2,48(sp)
    8000067e:	f44e                	sd	s3,40(sp)
    80000680:	f052                	sd	s4,32(sp)
    80000682:	ec56                	sd	s5,24(sp)
    80000684:	e85a                	sd	s6,16(sp)
    80000686:	e45e                	sd	s7,8(sp)
    80000688:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz = PGSIZE;

  if((va % PGSIZE) != 0)
    8000068a:	03459793          	slli	a5,a1,0x34
    8000068e:	e795                	bnez	a5,800006ba <uvmunmap+0x46>
    80000690:	8a2a                	mv	s4,a0
    80000692:	892e                	mv	s2,a1
    80000694:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000696:	0632                	slli	a2,a2,0xc
    80000698:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
      continue;
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
      continue;
    sz = PGSIZE;
    if(PTE_FLAGS(*pte) == PTE_V)
    8000069c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000069e:	6a85                	lui	s5,0x1
    800006a0:	0535e363          	bltu	a1,s3,800006e6 <uvmunmap+0x72>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800006a4:	60a6                	ld	ra,72(sp)
    800006a6:	6406                	ld	s0,64(sp)
    800006a8:	74e2                	ld	s1,56(sp)
    800006aa:	7942                	ld	s2,48(sp)
    800006ac:	79a2                	ld	s3,40(sp)
    800006ae:	7a02                	ld	s4,32(sp)
    800006b0:	6ae2                	ld	s5,24(sp)
    800006b2:	6b42                	ld	s6,16(sp)
    800006b4:	6ba2                	ld	s7,8(sp)
    800006b6:	6161                	addi	sp,sp,80
    800006b8:	8082                	ret
    panic("uvmunmap: not aligned");
    800006ba:	00007517          	auipc	a0,0x7
    800006be:	a0650513          	addi	a0,a0,-1530 # 800070c0 <etext+0xc0>
    800006c2:	665040ef          	jal	ra,80005526 <panic>
      panic("uvmunmap: not a leaf");
    800006c6:	00007517          	auipc	a0,0x7
    800006ca:	a1250513          	addi	a0,a0,-1518 # 800070d8 <etext+0xd8>
    800006ce:	659040ef          	jal	ra,80005526 <panic>
      uint64 pa = PTE2PA(*pte);
    800006d2:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800006d4:	00c79513          	slli	a0,a5,0xc
    800006d8:	945ff0ef          	jal	ra,8000001c <kfree>
    *pte = 0;
    800006dc:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006e0:	9956                	add	s2,s2,s5
    800006e2:	fd3971e3          	bgeu	s2,s3,800006a4 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800006e6:	4601                	li	a2,0
    800006e8:	85ca                	mv	a1,s2
    800006ea:	8552                	mv	a0,s4
    800006ec:	ce5ff0ef          	jal	ra,800003d0 <walk>
    800006f0:	84aa                	mv	s1,a0
    800006f2:	d57d                	beqz	a0,800006e0 <uvmunmap+0x6c>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    800006f4:	611c                	ld	a5,0(a0)
    800006f6:	0017f713          	andi	a4,a5,1
    800006fa:	d37d                	beqz	a4,800006e0 <uvmunmap+0x6c>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006fc:	3ff7f713          	andi	a4,a5,1023
    80000700:	fd7703e3          	beq	a4,s7,800006c6 <uvmunmap+0x52>
    if(do_free){
    80000704:	fc0b0ce3          	beqz	s6,800006dc <uvmunmap+0x68>
    80000708:	b7e9                	j	800006d2 <uvmunmap+0x5e>

000000008000070a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000070a:	1101                	addi	sp,sp,-32
    8000070c:	ec06                	sd	ra,24(sp)
    8000070e:	e822                	sd	s0,16(sp)
    80000710:	e426                	sd	s1,8(sp)
    80000712:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000714:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000716:	00b67d63          	bgeu	a2,a1,80000730 <uvmdealloc+0x26>
    8000071a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000071c:	6785                	lui	a5,0x1
    8000071e:	17fd                	addi	a5,a5,-1
    80000720:	00f60733          	add	a4,a2,a5
    80000724:	767d                	lui	a2,0xfffff
    80000726:	8f71                	and	a4,a4,a2
    80000728:	97ae                	add	a5,a5,a1
    8000072a:	8ff1                	and	a5,a5,a2
    8000072c:	00f76863          	bltu	a4,a5,8000073c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000730:	8526                	mv	a0,s1
    80000732:	60e2                	ld	ra,24(sp)
    80000734:	6442                	ld	s0,16(sp)
    80000736:	64a2                	ld	s1,8(sp)
    80000738:	6105                	addi	sp,sp,32
    8000073a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000073c:	8f99                	sub	a5,a5,a4
    8000073e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000740:	4685                	li	a3,1
    80000742:	0007861b          	sext.w	a2,a5
    80000746:	85ba                	mv	a1,a4
    80000748:	f2dff0ef          	jal	ra,80000674 <uvmunmap>
    8000074c:	b7d5                	j	80000730 <uvmdealloc+0x26>

000000008000074e <uvmalloc>:
  if(newsz < oldsz)
    8000074e:	08b66963          	bltu	a2,a1,800007e0 <uvmalloc+0x92>
{
    80000752:	7139                	addi	sp,sp,-64
    80000754:	fc06                	sd	ra,56(sp)
    80000756:	f822                	sd	s0,48(sp)
    80000758:	f426                	sd	s1,40(sp)
    8000075a:	f04a                	sd	s2,32(sp)
    8000075c:	ec4e                	sd	s3,24(sp)
    8000075e:	e852                	sd	s4,16(sp)
    80000760:	e456                	sd	s5,8(sp)
    80000762:	e05a                	sd	s6,0(sp)
    80000764:	0080                	addi	s0,sp,64
    80000766:	8aaa                	mv	s5,a0
    80000768:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000076a:	6985                	lui	s3,0x1
    8000076c:	19fd                	addi	s3,s3,-1
    8000076e:	95ce                	add	a1,a1,s3
    80000770:	79fd                	lui	s3,0xfffff
    80000772:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += sz){
    80000776:	06c9f763          	bgeu	s3,a2,800007e4 <uvmalloc+0x96>
    8000077a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000077c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000780:	97dff0ef          	jal	ra,800000fc <kalloc>
    80000784:	84aa                	mv	s1,a0
    if(mem == 0){
    80000786:	c11d                	beqz	a0,800007ac <uvmalloc+0x5e>
    memset(mem, 0, sz);
    80000788:	6605                	lui	a2,0x1
    8000078a:	4581                	li	a1,0
    8000078c:	9c1ff0ef          	jal	ra,8000014c <memset>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000790:	875a                	mv	a4,s6
    80000792:	86a6                	mv	a3,s1
    80000794:	6605                	lui	a2,0x1
    80000796:	85ca                	mv	a1,s2
    80000798:	8556                	mv	a0,s5
    8000079a:	d0fff0ef          	jal	ra,800004a8 <mappages>
    8000079e:	e51d                	bnez	a0,800007cc <uvmalloc+0x7e>
  for(a = oldsz; a < newsz; a += sz){
    800007a0:	6785                	lui	a5,0x1
    800007a2:	993e                	add	s2,s2,a5
    800007a4:	fd496ee3          	bltu	s2,s4,80000780 <uvmalloc+0x32>
  return newsz;
    800007a8:	8552                	mv	a0,s4
    800007aa:	a039                	j	800007b8 <uvmalloc+0x6a>
      uvmdealloc(pagetable, a, oldsz);
    800007ac:	864e                	mv	a2,s3
    800007ae:	85ca                	mv	a1,s2
    800007b0:	8556                	mv	a0,s5
    800007b2:	f59ff0ef          	jal	ra,8000070a <uvmdealloc>
      return 0;
    800007b6:	4501                	li	a0,0
}
    800007b8:	70e2                	ld	ra,56(sp)
    800007ba:	7442                	ld	s0,48(sp)
    800007bc:	74a2                	ld	s1,40(sp)
    800007be:	7902                	ld	s2,32(sp)
    800007c0:	69e2                	ld	s3,24(sp)
    800007c2:	6a42                	ld	s4,16(sp)
    800007c4:	6aa2                	ld	s5,8(sp)
    800007c6:	6b02                	ld	s6,0(sp)
    800007c8:	6121                	addi	sp,sp,64
    800007ca:	8082                	ret
      kfree(mem);
    800007cc:	8526                	mv	a0,s1
    800007ce:	84fff0ef          	jal	ra,8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800007d2:	864e                	mv	a2,s3
    800007d4:	85ca                	mv	a1,s2
    800007d6:	8556                	mv	a0,s5
    800007d8:	f33ff0ef          	jal	ra,8000070a <uvmdealloc>
      return 0;
    800007dc:	4501                	li	a0,0
    800007de:	bfe9                	j	800007b8 <uvmalloc+0x6a>
    return oldsz;
    800007e0:	852e                	mv	a0,a1
}
    800007e2:	8082                	ret
  return newsz;
    800007e4:	8532                	mv	a0,a2
    800007e6:	bfc9                	j	800007b8 <uvmalloc+0x6a>

00000000800007e8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800007e8:	7179                	addi	sp,sp,-48
    800007ea:	f406                	sd	ra,40(sp)
    800007ec:	f022                	sd	s0,32(sp)
    800007ee:	ec26                	sd	s1,24(sp)
    800007f0:	e84a                	sd	s2,16(sp)
    800007f2:	e44e                	sd	s3,8(sp)
    800007f4:	e052                	sd	s4,0(sp)
    800007f6:	1800                	addi	s0,sp,48
    800007f8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800007fa:	84aa                	mv	s1,a0
    800007fc:	6905                	lui	s2,0x1
    800007fe:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000800:	4985                	li	s3,1
    80000802:	a811                	j	80000816 <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000804:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000806:	0532                	slli	a0,a0,0xc
    80000808:	fe1ff0ef          	jal	ra,800007e8 <freewalk>
      pagetable[i] = 0;
    8000080c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000810:	04a1                	addi	s1,s1,8
    80000812:	01248f63          	beq	s1,s2,80000830 <freewalk+0x48>
    pte_t pte = pagetable[i];
    80000816:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000818:	00f57793          	andi	a5,a0,15
    8000081c:	ff3784e3          	beq	a5,s3,80000804 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000820:	8905                	andi	a0,a0,1
    80000822:	d57d                	beqz	a0,80000810 <freewalk+0x28>
      // backtrace();
      panic("freewalk: leaf");
    80000824:	00007517          	auipc	a0,0x7
    80000828:	8cc50513          	addi	a0,a0,-1844 # 800070f0 <etext+0xf0>
    8000082c:	4fb040ef          	jal	ra,80005526 <panic>
    }
  }
  kfree((void*)pagetable);
    80000830:	8552                	mv	a0,s4
    80000832:	feaff0ef          	jal	ra,8000001c <kfree>
}
    80000836:	70a2                	ld	ra,40(sp)
    80000838:	7402                	ld	s0,32(sp)
    8000083a:	64e2                	ld	s1,24(sp)
    8000083c:	6942                	ld	s2,16(sp)
    8000083e:	69a2                	ld	s3,8(sp)
    80000840:	6a02                	ld	s4,0(sp)
    80000842:	6145                	addi	sp,sp,48
    80000844:	8082                	ret

0000000080000846 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000846:	1101                	addi	sp,sp,-32
    80000848:	ec06                	sd	ra,24(sp)
    8000084a:	e822                	sd	s0,16(sp)
    8000084c:	e426                	sd	s1,8(sp)
    8000084e:	1000                	addi	s0,sp,32
    80000850:	84aa                	mv	s1,a0
  if(sz > 0)
    80000852:	e989                	bnez	a1,80000864 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000854:	8526                	mv	a0,s1
    80000856:	f93ff0ef          	jal	ra,800007e8 <freewalk>
}
    8000085a:	60e2                	ld	ra,24(sp)
    8000085c:	6442                	ld	s0,16(sp)
    8000085e:	64a2                	ld	s1,8(sp)
    80000860:	6105                	addi	sp,sp,32
    80000862:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000864:	6605                	lui	a2,0x1
    80000866:	167d                	addi	a2,a2,-1
    80000868:	962e                	add	a2,a2,a1
    8000086a:	4685                	li	a3,1
    8000086c:	8231                	srli	a2,a2,0xc
    8000086e:	4581                	li	a1,0
    80000870:	e05ff0ef          	jal	ra,80000674 <uvmunmap>
    80000874:	b7c5                	j	80000854 <uvmfree+0xe>

0000000080000876 <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc = PGSIZE;

  for(i = 0; i < sz; i += szinc){
    80000876:	ce49                	beqz	a2,80000910 <uvmcopy+0x9a>
{
    80000878:	715d                	addi	sp,sp,-80
    8000087a:	e486                	sd	ra,72(sp)
    8000087c:	e0a2                	sd	s0,64(sp)
    8000087e:	fc26                	sd	s1,56(sp)
    80000880:	f84a                	sd	s2,48(sp)
    80000882:	f44e                	sd	s3,40(sp)
    80000884:	f052                	sd	s4,32(sp)
    80000886:	ec56                	sd	s5,24(sp)
    80000888:	e85a                	sd	s6,16(sp)
    8000088a:	e45e                	sd	s7,8(sp)
    8000088c:	0880                	addi	s0,sp,80
    8000088e:	8aaa                	mv	s5,a0
    80000890:	8b2e                	mv	s6,a1
    80000892:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += szinc){
    80000894:	4481                	li	s1,0
    80000896:	a029                	j	800008a0 <uvmcopy+0x2a>
    80000898:	6785                	lui	a5,0x1
    8000089a:	94be                	add	s1,s1,a5
    8000089c:	0544fe63          	bgeu	s1,s4,800008f8 <uvmcopy+0x82>
    if((pte = walk(old, i, 0)) == 0)
    800008a0:	4601                	li	a2,0
    800008a2:	85a6                	mv	a1,s1
    800008a4:	8556                	mv	a0,s5
    800008a6:	b2bff0ef          	jal	ra,800003d0 <walk>
    800008aa:	d57d                	beqz	a0,80000898 <uvmcopy+0x22>
      continue;
    if((*pte & PTE_V) == 0) {
    800008ac:	6118                	ld	a4,0(a0)
    800008ae:	00177793          	andi	a5,a4,1
    800008b2:	d3fd                	beqz	a5,80000898 <uvmcopy+0x22>
      continue;
    }
    szinc = PGSIZE;
    pa = PTE2PA(*pte);
    800008b4:	00a75593          	srli	a1,a4,0xa
    800008b8:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800008bc:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    800008c0:	83dff0ef          	jal	ra,800000fc <kalloc>
    800008c4:	89aa                	mv	s3,a0
    800008c6:	c105                	beqz	a0,800008e6 <uvmcopy+0x70>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800008c8:	6605                	lui	a2,0x1
    800008ca:	85de                	mv	a1,s7
    800008cc:	8e1ff0ef          	jal	ra,800001ac <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800008d0:	874a                	mv	a4,s2
    800008d2:	86ce                	mv	a3,s3
    800008d4:	6605                	lui	a2,0x1
    800008d6:	85a6                	mv	a1,s1
    800008d8:	855a                	mv	a0,s6
    800008da:	bcfff0ef          	jal	ra,800004a8 <mappages>
    800008de:	dd4d                	beqz	a0,80000898 <uvmcopy+0x22>
      kfree(mem);
    800008e0:	854e                	mv	a0,s3
    800008e2:	f3aff0ef          	jal	ra,8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800008e6:	4685                	li	a3,1
    800008e8:	00c4d613          	srli	a2,s1,0xc
    800008ec:	4581                	li	a1,0
    800008ee:	855a                	mv	a0,s6
    800008f0:	d85ff0ef          	jal	ra,80000674 <uvmunmap>
  return -1;
    800008f4:	557d                	li	a0,-1
    800008f6:	a011                	j	800008fa <uvmcopy+0x84>
  return 0;
    800008f8:	4501                	li	a0,0
}
    800008fa:	60a6                	ld	ra,72(sp)
    800008fc:	6406                	ld	s0,64(sp)
    800008fe:	74e2                	ld	s1,56(sp)
    80000900:	7942                	ld	s2,48(sp)
    80000902:	79a2                	ld	s3,40(sp)
    80000904:	7a02                	ld	s4,32(sp)
    80000906:	6ae2                	ld	s5,24(sp)
    80000908:	6b42                	ld	s6,16(sp)
    8000090a:	6ba2                	ld	s7,8(sp)
    8000090c:	6161                	addi	sp,sp,80
    8000090e:	8082                	ret
  return 0;
    80000910:	4501                	li	a0,0
}
    80000912:	8082                	ret

0000000080000914 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000914:	1141                	addi	sp,sp,-16
    80000916:	e406                	sd	ra,8(sp)
    80000918:	e022                	sd	s0,0(sp)
    8000091a:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000091c:	4601                	li	a2,0
    8000091e:	ab3ff0ef          	jal	ra,800003d0 <walk>
  if(pte == 0)
    80000922:	c901                	beqz	a0,80000932 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000924:	611c                	ld	a5,0(a0)
    80000926:	9bbd                	andi	a5,a5,-17
    80000928:	e11c                	sd	a5,0(a0)
}
    8000092a:	60a2                	ld	ra,8(sp)
    8000092c:	6402                	ld	s0,0(sp)
    8000092e:	0141                	addi	sp,sp,16
    80000930:	8082                	ret
    panic("uvmclear");
    80000932:	00006517          	auipc	a0,0x6
    80000936:	7ce50513          	addi	a0,a0,1998 # 80007100 <etext+0x100>
    8000093a:	3ed040ef          	jal	ra,80005526 <panic>

000000008000093e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000093e:	c2d5                	beqz	a3,800009e2 <copyinstr+0xa4>
{
    80000940:	715d                	addi	sp,sp,-80
    80000942:	e486                	sd	ra,72(sp)
    80000944:	e0a2                	sd	s0,64(sp)
    80000946:	fc26                	sd	s1,56(sp)
    80000948:	f84a                	sd	s2,48(sp)
    8000094a:	f44e                	sd	s3,40(sp)
    8000094c:	f052                	sd	s4,32(sp)
    8000094e:	ec56                	sd	s5,24(sp)
    80000950:	e85a                	sd	s6,16(sp)
    80000952:	e45e                	sd	s7,8(sp)
    80000954:	0880                	addi	s0,sp,80
    80000956:	8a2a                	mv	s4,a0
    80000958:	8b2e                	mv	s6,a1
    8000095a:	8bb2                	mv	s7,a2
    8000095c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000095e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000960:	6985                	lui	s3,0x1
    80000962:	a035                	j	8000098e <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000964:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000968:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000096a:	0017b793          	seqz	a5,a5
    8000096e:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000972:	60a6                	ld	ra,72(sp)
    80000974:	6406                	ld	s0,64(sp)
    80000976:	74e2                	ld	s1,56(sp)
    80000978:	7942                	ld	s2,48(sp)
    8000097a:	79a2                	ld	s3,40(sp)
    8000097c:	7a02                	ld	s4,32(sp)
    8000097e:	6ae2                	ld	s5,24(sp)
    80000980:	6b42                	ld	s6,16(sp)
    80000982:	6ba2                	ld	s7,8(sp)
    80000984:	6161                	addi	sp,sp,80
    80000986:	8082                	ret
    srcva = va0 + PGSIZE;
    80000988:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    8000098c:	c4b9                	beqz	s1,800009da <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    8000098e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000992:	85ca                	mv	a1,s2
    80000994:	8552                	mv	a0,s4
    80000996:	ad5ff0ef          	jal	ra,8000046a <walkaddr>
    if(pa0 == 0)
    8000099a:	c131                	beqz	a0,800009de <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    8000099c:	41790833          	sub	a6,s2,s7
    800009a0:	984e                	add	a6,a6,s3
    if(n > max)
    800009a2:	0104f363          	bgeu	s1,a6,800009a8 <copyinstr+0x6a>
    800009a6:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800009a8:	955e                	add	a0,a0,s7
    800009aa:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800009ae:	fc080de3          	beqz	a6,80000988 <copyinstr+0x4a>
    800009b2:	985a                	add	a6,a6,s6
    800009b4:	87da                	mv	a5,s6
      if(*p == '\0'){
    800009b6:	41650633          	sub	a2,a0,s6
    800009ba:	14fd                	addi	s1,s1,-1
    800009bc:	9b26                	add	s6,s6,s1
    800009be:	00f60733          	add	a4,a2,a5
    800009c2:	00074703          	lbu	a4,0(a4)
    800009c6:	df59                	beqz	a4,80000964 <copyinstr+0x26>
        *dst = *p;
    800009c8:	00e78023          	sb	a4,0(a5)
      --max;
    800009cc:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800009d0:	0785                	addi	a5,a5,1
    while(n > 0){
    800009d2:	ff0796e3          	bne	a5,a6,800009be <copyinstr+0x80>
      dst++;
    800009d6:	8b42                	mv	s6,a6
    800009d8:	bf45                	j	80000988 <copyinstr+0x4a>
    800009da:	4781                	li	a5,0
    800009dc:	b779                	j	8000096a <copyinstr+0x2c>
      return -1;
    800009de:	557d                	li	a0,-1
    800009e0:	bf49                	j	80000972 <copyinstr+0x34>
  int got_null = 0;
    800009e2:	4781                	li	a5,0
  if(got_null){
    800009e4:	0017b793          	seqz	a5,a5
    800009e8:	40f00533          	neg	a0,a5
}
    800009ec:	8082                	ret

00000000800009ee <ismapped>:
  }
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va) {
    800009ee:	1141                	addi	sp,sp,-16
    800009f0:	e406                	sd	ra,8(sp)
    800009f2:	e022                	sd	s0,0(sp)
    800009f4:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800009f6:	4601                	li	a2,0
    800009f8:	9d9ff0ef          	jal	ra,800003d0 <walk>
  if (pte == 0) {
    800009fc:	c519                	beqz	a0,80000a0a <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    800009fe:	6108                	ld	a0,0(a0)
    return 0;
    80000a00:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000a02:	60a2                	ld	ra,8(sp)
    80000a04:	6402                	ld	s0,0(sp)
    80000a06:	0141                	addi	sp,sp,16
    80000a08:	8082                	ret
    return 0;
    80000a0a:	4501                	li	a0,0
    80000a0c:	bfdd                	j	80000a02 <ismapped+0x14>

0000000080000a0e <vmfault>:
{
    80000a0e:	7179                	addi	sp,sp,-48
    80000a10:	f406                	sd	ra,40(sp)
    80000a12:	f022                	sd	s0,32(sp)
    80000a14:	ec26                	sd	s1,24(sp)
    80000a16:	e84a                	sd	s2,16(sp)
    80000a18:	e44e                	sd	s3,8(sp)
    80000a1a:	e052                	sd	s4,0(sp)
    80000a1c:	1800                	addi	s0,sp,48
    80000a1e:	89aa                	mv	s3,a0
    80000a20:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80000a22:	316000ef          	jal	ra,80000d38 <myproc>
  if (va >= p->sz)
    80000a26:	653c                	ld	a5,72(a0)
    80000a28:	00f4ec63          	bltu	s1,a5,80000a40 <vmfault+0x32>
    return 0;
    80000a2c:	4981                	li	s3,0
}
    80000a2e:	854e                	mv	a0,s3
    80000a30:	70a2                	ld	ra,40(sp)
    80000a32:	7402                	ld	s0,32(sp)
    80000a34:	64e2                	ld	s1,24(sp)
    80000a36:	6942                	ld	s2,16(sp)
    80000a38:	69a2                	ld	s3,8(sp)
    80000a3a:	6a02                	ld	s4,0(sp)
    80000a3c:	6145                	addi	sp,sp,48
    80000a3e:	8082                	ret
    80000a40:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    80000a42:	75fd                	lui	a1,0xfffff
    80000a44:	8ced                	and	s1,s1,a1
  if(ismapped(pagetable, va)) {
    80000a46:	85a6                	mv	a1,s1
    80000a48:	854e                	mv	a0,s3
    80000a4a:	fa5ff0ef          	jal	ra,800009ee <ismapped>
    return 0;
    80000a4e:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80000a50:	fd79                	bnez	a0,80000a2e <vmfault+0x20>
  mem = (uint64) kalloc();
    80000a52:	eaaff0ef          	jal	ra,800000fc <kalloc>
    80000a56:	8a2a                	mv	s4,a0
  if(mem == 0)
    80000a58:	d979                	beqz	a0,80000a2e <vmfault+0x20>
  mem = (uint64) kalloc();
    80000a5a:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80000a5c:	6605                	lui	a2,0x1
    80000a5e:	4581                	li	a1,0
    80000a60:	eecff0ef          	jal	ra,8000014c <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000a64:	4759                	li	a4,22
    80000a66:	86d2                	mv	a3,s4
    80000a68:	6605                	lui	a2,0x1
    80000a6a:	85a6                	mv	a1,s1
    80000a6c:	05093503          	ld	a0,80(s2) # 1050 <_entry-0x7fffefb0>
    80000a70:	a39ff0ef          	jal	ra,800004a8 <mappages>
    80000a74:	dd4d                	beqz	a0,80000a2e <vmfault+0x20>
    kfree((void *)mem);
    80000a76:	8552                	mv	a0,s4
    80000a78:	da4ff0ef          	jal	ra,8000001c <kfree>
    return 0;
    80000a7c:	4981                	li	s3,0
    80000a7e:	bf45                	j	80000a2e <vmfault+0x20>

0000000080000a80 <copyout>:
  while(len > 0){
    80000a80:	cec9                	beqz	a3,80000b1a <copyout+0x9a>
{
    80000a82:	711d                	addi	sp,sp,-96
    80000a84:	ec86                	sd	ra,88(sp)
    80000a86:	e8a2                	sd	s0,80(sp)
    80000a88:	e4a6                	sd	s1,72(sp)
    80000a8a:	e0ca                	sd	s2,64(sp)
    80000a8c:	fc4e                	sd	s3,56(sp)
    80000a8e:	f852                	sd	s4,48(sp)
    80000a90:	f456                	sd	s5,40(sp)
    80000a92:	f05a                	sd	s6,32(sp)
    80000a94:	ec5e                	sd	s7,24(sp)
    80000a96:	e862                	sd	s8,16(sp)
    80000a98:	e466                	sd	s9,8(sp)
    80000a9a:	e06a                	sd	s10,0(sp)
    80000a9c:	1080                	addi	s0,sp,96
    80000a9e:	8baa                	mv	s7,a0
    80000aa0:	8aae                	mv	s5,a1
    80000aa2:	8b32                	mv	s6,a2
    80000aa4:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000aa6:	74fd                	lui	s1,0xfffff
    80000aa8:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000aaa:	57fd                	li	a5,-1
    80000aac:	83e9                	srli	a5,a5,0x1a
    80000aae:	0697e863          	bltu	a5,s1,80000b1e <copyout+0x9e>
    80000ab2:	6c85                	lui	s9,0x1
    80000ab4:	8c3e                	mv	s8,a5
    80000ab6:	a015                	j	80000ada <copyout+0x5a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000ab8:	409a8533          	sub	a0,s5,s1
    80000abc:	0009861b          	sext.w	a2,s3
    80000ac0:	85da                	mv	a1,s6
    80000ac2:	954a                	add	a0,a0,s2
    80000ac4:	ee8ff0ef          	jal	ra,800001ac <memmove>
    len -= n;
    80000ac8:	413a0a33          	sub	s4,s4,s3
    src += n;
    80000acc:	9b4e                	add	s6,s6,s3
  while(len > 0){
    80000ace:	040a0463          	beqz	s4,80000b16 <copyout+0x96>
    if (va0 >= MAXVA)
    80000ad2:	05ac6863          	bltu	s8,s10,80000b22 <copyout+0xa2>
    va0 = PGROUNDDOWN(dstva);
    80000ad6:	84ea                	mv	s1,s10
    dstva = va0 + PGSIZE;
    80000ad8:	8aea                	mv	s5,s10
    pa0 = walkaddr(pagetable, va0);
    80000ada:	85a6                	mv	a1,s1
    80000adc:	855e                	mv	a0,s7
    80000ade:	98dff0ef          	jal	ra,8000046a <walkaddr>
    80000ae2:	892a                	mv	s2,a0
    if(pa0 == 0) {
    80000ae4:	e901                	bnez	a0,80000af4 <copyout+0x74>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000ae6:	4601                	li	a2,0
    80000ae8:	85a6                	mv	a1,s1
    80000aea:	855e                	mv	a0,s7
    80000aec:	f23ff0ef          	jal	ra,80000a0e <vmfault>
    80000af0:	892a                	mv	s2,a0
    80000af2:	c915                	beqz	a0,80000b26 <copyout+0xa6>
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000af4:	4601                	li	a2,0
    80000af6:	85a6                	mv	a1,s1
    80000af8:	855e                	mv	a0,s7
    80000afa:	8d7ff0ef          	jal	ra,800003d0 <walk>
    80000afe:	c515                	beqz	a0,80000b2a <copyout+0xaa>
    if((*pte & PTE_W) == 0)
    80000b00:	611c                	ld	a5,0(a0)
    80000b02:	8b91                	andi	a5,a5,4
    80000b04:	c3b1                	beqz	a5,80000b48 <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    80000b06:	01948d33          	add	s10,s1,s9
    80000b0a:	415d09b3          	sub	s3,s10,s5
    if(n > len)
    80000b0e:	fb3a75e3          	bgeu	s4,s3,80000ab8 <copyout+0x38>
    80000b12:	89d2                	mv	s3,s4
    80000b14:	b755                	j	80000ab8 <copyout+0x38>
  return 0;
    80000b16:	4501                	li	a0,0
    80000b18:	a811                	j	80000b2c <copyout+0xac>
    80000b1a:	4501                	li	a0,0
}
    80000b1c:	8082                	ret
      return -1;
    80000b1e:	557d                	li	a0,-1
    80000b20:	a031                	j	80000b2c <copyout+0xac>
    80000b22:	557d                	li	a0,-1
    80000b24:	a021                	j	80000b2c <copyout+0xac>
        return -1;
    80000b26:	557d                	li	a0,-1
    80000b28:	a011                	j	80000b2c <copyout+0xac>
      return -1;
    80000b2a:	557d                	li	a0,-1
}
    80000b2c:	60e6                	ld	ra,88(sp)
    80000b2e:	6446                	ld	s0,80(sp)
    80000b30:	64a6                	ld	s1,72(sp)
    80000b32:	6906                	ld	s2,64(sp)
    80000b34:	79e2                	ld	s3,56(sp)
    80000b36:	7a42                	ld	s4,48(sp)
    80000b38:	7aa2                	ld	s5,40(sp)
    80000b3a:	7b02                	ld	s6,32(sp)
    80000b3c:	6be2                	ld	s7,24(sp)
    80000b3e:	6c42                	ld	s8,16(sp)
    80000b40:	6ca2                	ld	s9,8(sp)
    80000b42:	6d02                	ld	s10,0(sp)
    80000b44:	6125                	addi	sp,sp,96
    80000b46:	8082                	ret
      return -1;
    80000b48:	557d                	li	a0,-1
    80000b4a:	b7cd                	j	80000b2c <copyout+0xac>

0000000080000b4c <copyin>:
  while(len > 0){
    80000b4c:	c6c9                	beqz	a3,80000bd6 <copyin+0x8a>
{
    80000b4e:	715d                	addi	sp,sp,-80
    80000b50:	e486                	sd	ra,72(sp)
    80000b52:	e0a2                	sd	s0,64(sp)
    80000b54:	fc26                	sd	s1,56(sp)
    80000b56:	f84a                	sd	s2,48(sp)
    80000b58:	f44e                	sd	s3,40(sp)
    80000b5a:	f052                	sd	s4,32(sp)
    80000b5c:	ec56                	sd	s5,24(sp)
    80000b5e:	e85a                	sd	s6,16(sp)
    80000b60:	e45e                	sd	s7,8(sp)
    80000b62:	e062                	sd	s8,0(sp)
    80000b64:	0880                	addi	s0,sp,80
    80000b66:	8baa                	mv	s7,a0
    80000b68:	8aae                	mv	s5,a1
    80000b6a:	8932                	mv	s2,a2
    80000b6c:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000b6e:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000b70:	6b05                	lui	s6,0x1
    80000b72:	a035                	j	80000b9e <copyin+0x52>
    80000b74:	412984b3          	sub	s1,s3,s2
    80000b78:	94da                	add	s1,s1,s6
    if(n > len)
    80000b7a:	009a7363          	bgeu	s4,s1,80000b80 <copyin+0x34>
    80000b7e:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b80:	413905b3          	sub	a1,s2,s3
    80000b84:	0004861b          	sext.w	a2,s1
    80000b88:	95aa                	add	a1,a1,a0
    80000b8a:	8556                	mv	a0,s5
    80000b8c:	e20ff0ef          	jal	ra,800001ac <memmove>
    len -= n;
    80000b90:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000b94:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000b96:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000b9a:	020a0163          	beqz	s4,80000bbc <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000b9e:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000ba2:	85ce                	mv	a1,s3
    80000ba4:	855e                	mv	a0,s7
    80000ba6:	8c5ff0ef          	jal	ra,8000046a <walkaddr>
    if(pa0 == 0) {
    80000baa:	f569                	bnez	a0,80000b74 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000bac:	4601                	li	a2,0
    80000bae:	85ce                	mv	a1,s3
    80000bb0:	855e                	mv	a0,s7
    80000bb2:	e5dff0ef          	jal	ra,80000a0e <vmfault>
    80000bb6:	fd5d                	bnez	a0,80000b74 <copyin+0x28>
        return -1;
    80000bb8:	557d                	li	a0,-1
    80000bba:	a011                	j	80000bbe <copyin+0x72>
  return 0;
    80000bbc:	4501                	li	a0,0
}
    80000bbe:	60a6                	ld	ra,72(sp)
    80000bc0:	6406                	ld	s0,64(sp)
    80000bc2:	74e2                	ld	s1,56(sp)
    80000bc4:	7942                	ld	s2,48(sp)
    80000bc6:	79a2                	ld	s3,40(sp)
    80000bc8:	7a02                	ld	s4,32(sp)
    80000bca:	6ae2                	ld	s5,24(sp)
    80000bcc:	6b42                	ld	s6,16(sp)
    80000bce:	6ba2                	ld	s7,8(sp)
    80000bd0:	6c02                	ld	s8,0(sp)
    80000bd2:	6161                	addi	sp,sp,80
    80000bd4:	8082                	ret
  return 0;
    80000bd6:	4501                	li	a0,0
}
    80000bd8:	8082                	ret

0000000080000bda <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bda:	7139                	addi	sp,sp,-64
    80000bdc:	fc06                	sd	ra,56(sp)
    80000bde:	f822                	sd	s0,48(sp)
    80000be0:	f426                	sd	s1,40(sp)
    80000be2:	f04a                	sd	s2,32(sp)
    80000be4:	ec4e                	sd	s3,24(sp)
    80000be6:	e852                	sd	s4,16(sp)
    80000be8:	e456                	sd	s5,8(sp)
    80000bea:	e05a                	sd	s6,0(sp)
    80000bec:	0080                	addi	s0,sp,64
    80000bee:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000bf0:	00007497          	auipc	s1,0x7
    80000bf4:	10048493          	addi	s1,s1,256 # 80007cf0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bf8:	8b26                	mv	s6,s1
    80000bfa:	00006a97          	auipc	s5,0x6
    80000bfe:	406a8a93          	addi	s5,s5,1030 # 80007000 <etext>
    80000c02:	04000937          	lui	s2,0x4000
    80000c06:	197d                	addi	s2,s2,-1
    80000c08:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c0a:	0000da17          	auipc	s4,0xd
    80000c0e:	ae6a0a13          	addi	s4,s4,-1306 # 8000d6f0 <tickslock>
    char *pa = kalloc();
    80000c12:	ceaff0ef          	jal	ra,800000fc <kalloc>
    80000c16:	862a                	mv	a2,a0
    if(pa == 0)
    80000c18:	c121                	beqz	a0,80000c58 <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    80000c1a:	416485b3          	sub	a1,s1,s6
    80000c1e:	858d                	srai	a1,a1,0x3
    80000c20:	000ab783          	ld	a5,0(s5)
    80000c24:	02f585b3          	mul	a1,a1,a5
    80000c28:	2585                	addiw	a1,a1,1
    80000c2a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c2e:	4719                	li	a4,6
    80000c30:	6685                	lui	a3,0x1
    80000c32:	40b905b3          	sub	a1,s2,a1
    80000c36:	854e                	mv	a0,s3
    80000c38:	921ff0ef          	jal	ra,80000558 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c3c:	16848493          	addi	s1,s1,360
    80000c40:	fd4499e3          	bne	s1,s4,80000c12 <proc_mapstacks+0x38>
  }
}
    80000c44:	70e2                	ld	ra,56(sp)
    80000c46:	7442                	ld	s0,48(sp)
    80000c48:	74a2                	ld	s1,40(sp)
    80000c4a:	7902                	ld	s2,32(sp)
    80000c4c:	69e2                	ld	s3,24(sp)
    80000c4e:	6a42                	ld	s4,16(sp)
    80000c50:	6aa2                	ld	s5,8(sp)
    80000c52:	6b02                	ld	s6,0(sp)
    80000c54:	6121                	addi	sp,sp,64
    80000c56:	8082                	ret
      panic("kalloc");
    80000c58:	00006517          	auipc	a0,0x6
    80000c5c:	4b850513          	addi	a0,a0,1208 # 80007110 <etext+0x110>
    80000c60:	0c7040ef          	jal	ra,80005526 <panic>

0000000080000c64 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c64:	7139                	addi	sp,sp,-64
    80000c66:	fc06                	sd	ra,56(sp)
    80000c68:	f822                	sd	s0,48(sp)
    80000c6a:	f426                	sd	s1,40(sp)
    80000c6c:	f04a                	sd	s2,32(sp)
    80000c6e:	ec4e                	sd	s3,24(sp)
    80000c70:	e852                	sd	s4,16(sp)
    80000c72:	e456                	sd	s5,8(sp)
    80000c74:	e05a                	sd	s6,0(sp)
    80000c76:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c78:	00006597          	auipc	a1,0x6
    80000c7c:	4a058593          	addi	a1,a1,1184 # 80007118 <etext+0x118>
    80000c80:	00007517          	auipc	a0,0x7
    80000c84:	c4050513          	addi	a0,a0,-960 # 800078c0 <pid_lock>
    80000c88:	2d9040ef          	jal	ra,80005760 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c8c:	00006597          	auipc	a1,0x6
    80000c90:	49458593          	addi	a1,a1,1172 # 80007120 <etext+0x120>
    80000c94:	00007517          	auipc	a0,0x7
    80000c98:	c4450513          	addi	a0,a0,-956 # 800078d8 <wait_lock>
    80000c9c:	2c5040ef          	jal	ra,80005760 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ca0:	00007497          	auipc	s1,0x7
    80000ca4:	05048493          	addi	s1,s1,80 # 80007cf0 <proc>
      initlock(&p->lock, "proc");
    80000ca8:	00006b17          	auipc	s6,0x6
    80000cac:	488b0b13          	addi	s6,s6,1160 # 80007130 <etext+0x130>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cb0:	8aa6                	mv	s5,s1
    80000cb2:	00006a17          	auipc	s4,0x6
    80000cb6:	34ea0a13          	addi	s4,s4,846 # 80007000 <etext>
    80000cba:	04000937          	lui	s2,0x4000
    80000cbe:	197d                	addi	s2,s2,-1
    80000cc0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cc2:	0000d997          	auipc	s3,0xd
    80000cc6:	a2e98993          	addi	s3,s3,-1490 # 8000d6f0 <tickslock>
      initlock(&p->lock, "proc");
    80000cca:	85da                	mv	a1,s6
    80000ccc:	8526                	mv	a0,s1
    80000cce:	293040ef          	jal	ra,80005760 <initlock>
      p->state = UNUSED;
    80000cd2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000cd6:	415487b3          	sub	a5,s1,s5
    80000cda:	878d                	srai	a5,a5,0x3
    80000cdc:	000a3703          	ld	a4,0(s4)
    80000ce0:	02e787b3          	mul	a5,a5,a4
    80000ce4:	2785                	addiw	a5,a5,1
    80000ce6:	00d7979b          	slliw	a5,a5,0xd
    80000cea:	40f907b3          	sub	a5,s2,a5
    80000cee:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf0:	16848493          	addi	s1,s1,360
    80000cf4:	fd349be3          	bne	s1,s3,80000cca <procinit+0x66>
  }
}
    80000cf8:	70e2                	ld	ra,56(sp)
    80000cfa:	7442                	ld	s0,48(sp)
    80000cfc:	74a2                	ld	s1,40(sp)
    80000cfe:	7902                	ld	s2,32(sp)
    80000d00:	69e2                	ld	s3,24(sp)
    80000d02:	6a42                	ld	s4,16(sp)
    80000d04:	6aa2                	ld	s5,8(sp)
    80000d06:	6b02                	ld	s6,0(sp)
    80000d08:	6121                	addi	sp,sp,64
    80000d0a:	8082                	ret

0000000080000d0c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d0c:	1141                	addi	sp,sp,-16
    80000d0e:	e422                	sd	s0,8(sp)
    80000d10:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d12:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d14:	2501                	sext.w	a0,a0
    80000d16:	6422                	ld	s0,8(sp)
    80000d18:	0141                	addi	sp,sp,16
    80000d1a:	8082                	ret

0000000080000d1c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d1c:	1141                	addi	sp,sp,-16
    80000d1e:	e422                	sd	s0,8(sp)
    80000d20:	0800                	addi	s0,sp,16
    80000d22:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d24:	2781                	sext.w	a5,a5
    80000d26:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d28:	00007517          	auipc	a0,0x7
    80000d2c:	bc850513          	addi	a0,a0,-1080 # 800078f0 <cpus>
    80000d30:	953e                	add	a0,a0,a5
    80000d32:	6422                	ld	s0,8(sp)
    80000d34:	0141                	addi	sp,sp,16
    80000d36:	8082                	ret

0000000080000d38 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d38:	1101                	addi	sp,sp,-32
    80000d3a:	ec06                	sd	ra,24(sp)
    80000d3c:	e822                	sd	s0,16(sp)
    80000d3e:	e426                	sd	s1,8(sp)
    80000d40:	1000                	addi	s0,sp,32
  push_off();
    80000d42:	25f040ef          	jal	ra,800057a0 <push_off>
    80000d46:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d48:	2781                	sext.w	a5,a5
    80000d4a:	079e                	slli	a5,a5,0x7
    80000d4c:	00007717          	auipc	a4,0x7
    80000d50:	b7470713          	addi	a4,a4,-1164 # 800078c0 <pid_lock>
    80000d54:	97ba                	add	a5,a5,a4
    80000d56:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d58:	2cd040ef          	jal	ra,80005824 <pop_off>
  return p;
}
    80000d5c:	8526                	mv	a0,s1
    80000d5e:	60e2                	ld	ra,24(sp)
    80000d60:	6442                	ld	s0,16(sp)
    80000d62:	64a2                	ld	s1,8(sp)
    80000d64:	6105                	addi	sp,sp,32
    80000d66:	8082                	ret

0000000080000d68 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d68:	7179                	addi	sp,sp,-48
    80000d6a:	f406                	sd	ra,40(sp)
    80000d6c:	f022                	sd	s0,32(sp)
    80000d6e:	ec26                	sd	s1,24(sp)
    80000d70:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000d72:	fc7ff0ef          	jal	ra,80000d38 <myproc>
    80000d76:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000d78:	301040ef          	jal	ra,80005878 <release>

  if (first) {
    80000d7c:	00007797          	auipc	a5,0x7
    80000d80:	ac47a783          	lw	a5,-1340(a5) # 80007840 <first.1689>
    80000d84:	cf8d                	beqz	a5,80000dbe <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000d86:	4505                	li	a0,1
    80000d88:	451010ef          	jal	ra,800029d8 <fsinit>

    first = 0;
    80000d8c:	00007797          	auipc	a5,0x7
    80000d90:	aa07aa23          	sw	zero,-1356(a5) # 80007840 <first.1689>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000d94:	0ff0000f          	fence

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000d98:	00006517          	auipc	a0,0x6
    80000d9c:	3a050513          	addi	a0,a0,928 # 80007138 <etext+0x138>
    80000da0:	fca43823          	sd	a0,-48(s0)
    80000da4:	fc043c23          	sd	zero,-40(s0)
    80000da8:	fd040593          	addi	a1,s0,-48
    80000dac:	4d9020ef          	jal	ra,80003a84 <kexec>
    80000db0:	6cbc                	ld	a5,88(s1)
    80000db2:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000db4:	6cbc                	ld	a5,88(s1)
    80000db6:	7bb8                	ld	a4,112(a5)
    80000db8:	57fd                	li	a5,-1
    80000dba:	02f70d63          	beq	a4,a5,80000df4 <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000dbe:	325000ef          	jal	ra,800018e2 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000dc2:	68a8                	ld	a0,80(s1)
    80000dc4:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000dc6:	04000737          	lui	a4,0x4000
    80000dca:	00005797          	auipc	a5,0x5
    80000dce:	2d278793          	addi	a5,a5,722 # 8000609c <userret>
    80000dd2:	00005697          	auipc	a3,0x5
    80000dd6:	22e68693          	addi	a3,a3,558 # 80006000 <_trampoline>
    80000dda:	8f95                	sub	a5,a5,a3
    80000ddc:	177d                	addi	a4,a4,-1
    80000dde:	0732                	slli	a4,a4,0xc
    80000de0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000de2:	577d                	li	a4,-1
    80000de4:	177e                	slli	a4,a4,0x3f
    80000de6:	8d59                	or	a0,a0,a4
    80000de8:	9782                	jalr	a5
}
    80000dea:	70a2                	ld	ra,40(sp)
    80000dec:	7402                	ld	s0,32(sp)
    80000dee:	64e2                	ld	s1,24(sp)
    80000df0:	6145                	addi	sp,sp,48
    80000df2:	8082                	ret
      panic("exec");
    80000df4:	00006517          	auipc	a0,0x6
    80000df8:	34c50513          	addi	a0,a0,844 # 80007140 <etext+0x140>
    80000dfc:	72a040ef          	jal	ra,80005526 <panic>

0000000080000e00 <allocpid>:
{
    80000e00:	1101                	addi	sp,sp,-32
    80000e02:	ec06                	sd	ra,24(sp)
    80000e04:	e822                	sd	s0,16(sp)
    80000e06:	e426                	sd	s1,8(sp)
    80000e08:	e04a                	sd	s2,0(sp)
    80000e0a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e0c:	00007917          	auipc	s2,0x7
    80000e10:	ab490913          	addi	s2,s2,-1356 # 800078c0 <pid_lock>
    80000e14:	854a                	mv	a0,s2
    80000e16:	1cb040ef          	jal	ra,800057e0 <acquire>
  pid = nextpid;
    80000e1a:	00007797          	auipc	a5,0x7
    80000e1e:	a2a78793          	addi	a5,a5,-1494 # 80007844 <nextpid>
    80000e22:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e24:	0014871b          	addiw	a4,s1,1
    80000e28:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e2a:	854a                	mv	a0,s2
    80000e2c:	24d040ef          	jal	ra,80005878 <release>
}
    80000e30:	8526                	mv	a0,s1
    80000e32:	60e2                	ld	ra,24(sp)
    80000e34:	6442                	ld	s0,16(sp)
    80000e36:	64a2                	ld	s1,8(sp)
    80000e38:	6902                	ld	s2,0(sp)
    80000e3a:	6105                	addi	sp,sp,32
    80000e3c:	8082                	ret

0000000080000e3e <proc_pagetable>:
{
    80000e3e:	1101                	addi	sp,sp,-32
    80000e40:	ec06                	sd	ra,24(sp)
    80000e42:	e822                	sd	s0,16(sp)
    80000e44:	e426                	sd	s1,8(sp)
    80000e46:	e04a                	sd	s2,0(sp)
    80000e48:	1000                	addi	s0,sp,32
    80000e4a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e4c:	803ff0ef          	jal	ra,8000064e <uvmcreate>
    80000e50:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e52:	cd05                	beqz	a0,80000e8a <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e54:	4729                	li	a4,10
    80000e56:	00005697          	auipc	a3,0x5
    80000e5a:	1aa68693          	addi	a3,a3,426 # 80006000 <_trampoline>
    80000e5e:	6605                	lui	a2,0x1
    80000e60:	040005b7          	lui	a1,0x4000
    80000e64:	15fd                	addi	a1,a1,-1
    80000e66:	05b2                	slli	a1,a1,0xc
    80000e68:	e40ff0ef          	jal	ra,800004a8 <mappages>
    80000e6c:	02054663          	bltz	a0,80000e98 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e70:	4719                	li	a4,6
    80000e72:	05893683          	ld	a3,88(s2)
    80000e76:	6605                	lui	a2,0x1
    80000e78:	020005b7          	lui	a1,0x2000
    80000e7c:	15fd                	addi	a1,a1,-1
    80000e7e:	05b6                	slli	a1,a1,0xd
    80000e80:	8526                	mv	a0,s1
    80000e82:	e26ff0ef          	jal	ra,800004a8 <mappages>
    80000e86:	00054f63          	bltz	a0,80000ea4 <proc_pagetable+0x66>
}
    80000e8a:	8526                	mv	a0,s1
    80000e8c:	60e2                	ld	ra,24(sp)
    80000e8e:	6442                	ld	s0,16(sp)
    80000e90:	64a2                	ld	s1,8(sp)
    80000e92:	6902                	ld	s2,0(sp)
    80000e94:	6105                	addi	sp,sp,32
    80000e96:	8082                	ret
    uvmfree(pagetable, 0);
    80000e98:	4581                	li	a1,0
    80000e9a:	8526                	mv	a0,s1
    80000e9c:	9abff0ef          	jal	ra,80000846 <uvmfree>
    return 0;
    80000ea0:	4481                	li	s1,0
    80000ea2:	b7e5                	j	80000e8a <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ea4:	4681                	li	a3,0
    80000ea6:	4605                	li	a2,1
    80000ea8:	040005b7          	lui	a1,0x4000
    80000eac:	15fd                	addi	a1,a1,-1
    80000eae:	05b2                	slli	a1,a1,0xc
    80000eb0:	8526                	mv	a0,s1
    80000eb2:	fc2ff0ef          	jal	ra,80000674 <uvmunmap>
    uvmfree(pagetable, 0);
    80000eb6:	4581                	li	a1,0
    80000eb8:	8526                	mv	a0,s1
    80000eba:	98dff0ef          	jal	ra,80000846 <uvmfree>
    return 0;
    80000ebe:	4481                	li	s1,0
    80000ec0:	b7e9                	j	80000e8a <proc_pagetable+0x4c>

0000000080000ec2 <proc_freepagetable>:
{
    80000ec2:	1101                	addi	sp,sp,-32
    80000ec4:	ec06                	sd	ra,24(sp)
    80000ec6:	e822                	sd	s0,16(sp)
    80000ec8:	e426                	sd	s1,8(sp)
    80000eca:	e04a                	sd	s2,0(sp)
    80000ecc:	1000                	addi	s0,sp,32
    80000ece:	84aa                	mv	s1,a0
    80000ed0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ed2:	4681                	li	a3,0
    80000ed4:	4605                	li	a2,1
    80000ed6:	040005b7          	lui	a1,0x4000
    80000eda:	15fd                	addi	a1,a1,-1
    80000edc:	05b2                	slli	a1,a1,0xc
    80000ede:	f96ff0ef          	jal	ra,80000674 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ee2:	4681                	li	a3,0
    80000ee4:	4605                	li	a2,1
    80000ee6:	020005b7          	lui	a1,0x2000
    80000eea:	15fd                	addi	a1,a1,-1
    80000eec:	05b6                	slli	a1,a1,0xd
    80000eee:	8526                	mv	a0,s1
    80000ef0:	f84ff0ef          	jal	ra,80000674 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ef4:	85ca                	mv	a1,s2
    80000ef6:	8526                	mv	a0,s1
    80000ef8:	94fff0ef          	jal	ra,80000846 <uvmfree>
}
    80000efc:	60e2                	ld	ra,24(sp)
    80000efe:	6442                	ld	s0,16(sp)
    80000f00:	64a2                	ld	s1,8(sp)
    80000f02:	6902                	ld	s2,0(sp)
    80000f04:	6105                	addi	sp,sp,32
    80000f06:	8082                	ret

0000000080000f08 <freeproc>:
{
    80000f08:	1101                	addi	sp,sp,-32
    80000f0a:	ec06                	sd	ra,24(sp)
    80000f0c:	e822                	sd	s0,16(sp)
    80000f0e:	e426                	sd	s1,8(sp)
    80000f10:	1000                	addi	s0,sp,32
    80000f12:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f14:	6d28                	ld	a0,88(a0)
    80000f16:	c119                	beqz	a0,80000f1c <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f18:	904ff0ef          	jal	ra,8000001c <kfree>
  p->trapframe = 0;
    80000f1c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f20:	68a8                	ld	a0,80(s1)
    80000f22:	c501                	beqz	a0,80000f2a <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f24:	64ac                	ld	a1,72(s1)
    80000f26:	f9dff0ef          	jal	ra,80000ec2 <proc_freepagetable>
  p->pagetable = 0;
    80000f2a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f2e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f32:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f36:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f3a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f3e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f42:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f46:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f4a:	0004ac23          	sw	zero,24(s1)
}
    80000f4e:	60e2                	ld	ra,24(sp)
    80000f50:	6442                	ld	s0,16(sp)
    80000f52:	64a2                	ld	s1,8(sp)
    80000f54:	6105                	addi	sp,sp,32
    80000f56:	8082                	ret

0000000080000f58 <allocproc>:
{
    80000f58:	1101                	addi	sp,sp,-32
    80000f5a:	ec06                	sd	ra,24(sp)
    80000f5c:	e822                	sd	s0,16(sp)
    80000f5e:	e426                	sd	s1,8(sp)
    80000f60:	e04a                	sd	s2,0(sp)
    80000f62:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f64:	00007497          	auipc	s1,0x7
    80000f68:	d8c48493          	addi	s1,s1,-628 # 80007cf0 <proc>
    80000f6c:	0000c917          	auipc	s2,0xc
    80000f70:	78490913          	addi	s2,s2,1924 # 8000d6f0 <tickslock>
    acquire(&p->lock);
    80000f74:	8526                	mv	a0,s1
    80000f76:	06b040ef          	jal	ra,800057e0 <acquire>
    if(p->state == UNUSED) {
    80000f7a:	4c9c                	lw	a5,24(s1)
    80000f7c:	cb91                	beqz	a5,80000f90 <allocproc+0x38>
      release(&p->lock);
    80000f7e:	8526                	mv	a0,s1
    80000f80:	0f9040ef          	jal	ra,80005878 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f84:	16848493          	addi	s1,s1,360
    80000f88:	ff2496e3          	bne	s1,s2,80000f74 <allocproc+0x1c>
  return 0;
    80000f8c:	4481                	li	s1,0
    80000f8e:	a089                	j	80000fd0 <allocproc+0x78>
  p->pid = allocpid();
    80000f90:	e71ff0ef          	jal	ra,80000e00 <allocpid>
    80000f94:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f96:	4785                	li	a5,1
    80000f98:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f9a:	962ff0ef          	jal	ra,800000fc <kalloc>
    80000f9e:	892a                	mv	s2,a0
    80000fa0:	eca8                	sd	a0,88(s1)
    80000fa2:	cd15                	beqz	a0,80000fde <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	e99ff0ef          	jal	ra,80000e3e <proc_pagetable>
    80000faa:	892a                	mv	s2,a0
    80000fac:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000fae:	c121                	beqz	a0,80000fee <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000fb0:	07000613          	li	a2,112
    80000fb4:	4581                	li	a1,0
    80000fb6:	06048513          	addi	a0,s1,96
    80000fba:	992ff0ef          	jal	ra,8000014c <memset>
  p->context.ra = (uint64)forkret;
    80000fbe:	00000797          	auipc	a5,0x0
    80000fc2:	daa78793          	addi	a5,a5,-598 # 80000d68 <forkret>
    80000fc6:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000fc8:	60bc                	ld	a5,64(s1)
    80000fca:	6705                	lui	a4,0x1
    80000fcc:	97ba                	add	a5,a5,a4
    80000fce:	f4bc                	sd	a5,104(s1)
}
    80000fd0:	8526                	mv	a0,s1
    80000fd2:	60e2                	ld	ra,24(sp)
    80000fd4:	6442                	ld	s0,16(sp)
    80000fd6:	64a2                	ld	s1,8(sp)
    80000fd8:	6902                	ld	s2,0(sp)
    80000fda:	6105                	addi	sp,sp,32
    80000fdc:	8082                	ret
    freeproc(p);
    80000fde:	8526                	mv	a0,s1
    80000fe0:	f29ff0ef          	jal	ra,80000f08 <freeproc>
    release(&p->lock);
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	093040ef          	jal	ra,80005878 <release>
    return 0;
    80000fea:	84ca                	mv	s1,s2
    80000fec:	b7d5                	j	80000fd0 <allocproc+0x78>
    freeproc(p);
    80000fee:	8526                	mv	a0,s1
    80000ff0:	f19ff0ef          	jal	ra,80000f08 <freeproc>
    release(&p->lock);
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	083040ef          	jal	ra,80005878 <release>
    return 0;
    80000ffa:	84ca                	mv	s1,s2
    80000ffc:	bfd1                	j	80000fd0 <allocproc+0x78>

0000000080000ffe <userinit>:
{
    80000ffe:	1101                	addi	sp,sp,-32
    80001000:	ec06                	sd	ra,24(sp)
    80001002:	e822                	sd	s0,16(sp)
    80001004:	e426                	sd	s1,8(sp)
    80001006:	1000                	addi	s0,sp,32
  p = allocproc();
    80001008:	f51ff0ef          	jal	ra,80000f58 <allocproc>
    8000100c:	84aa                	mv	s1,a0
  initproc = p;
    8000100e:	00007797          	auipc	a5,0x7
    80001012:	86a7b923          	sd	a0,-1934(a5) # 80007880 <initproc>
  p->cwd = namei("/");
    80001016:	00006517          	auipc	a0,0x6
    8000101a:	13250513          	addi	a0,a0,306 # 80007148 <etext+0x148>
    8000101e:	6b9010ef          	jal	ra,80002ed6 <namei>
    80001022:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001026:	478d                	li	a5,3
    80001028:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000102a:	8526                	mv	a0,s1
    8000102c:	04d040ef          	jal	ra,80005878 <release>
}
    80001030:	60e2                	ld	ra,24(sp)
    80001032:	6442                	ld	s0,16(sp)
    80001034:	64a2                	ld	s1,8(sp)
    80001036:	6105                	addi	sp,sp,32
    80001038:	8082                	ret

000000008000103a <growproc>:
{
    8000103a:	1101                	addi	sp,sp,-32
    8000103c:	ec06                	sd	ra,24(sp)
    8000103e:	e822                	sd	s0,16(sp)
    80001040:	e426                	sd	s1,8(sp)
    80001042:	e04a                	sd	s2,0(sp)
    80001044:	1000                	addi	s0,sp,32
    80001046:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001048:	cf1ff0ef          	jal	ra,80000d38 <myproc>
    8000104c:	84aa                	mv	s1,a0
  sz = p->sz;
    8000104e:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001050:	01204c63          	bgtz	s2,80001068 <growproc+0x2e>
  } else if(n < 0){
    80001054:	02094463          	bltz	s2,8000107c <growproc+0x42>
  p->sz = sz;
    80001058:	e4ac                	sd	a1,72(s1)
  return 0;
    8000105a:	4501                	li	a0,0
}
    8000105c:	60e2                	ld	ra,24(sp)
    8000105e:	6442                	ld	s0,16(sp)
    80001060:	64a2                	ld	s1,8(sp)
    80001062:	6902                	ld	s2,0(sp)
    80001064:	6105                	addi	sp,sp,32
    80001066:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001068:	4691                	li	a3,4
    8000106a:	00b90633          	add	a2,s2,a1
    8000106e:	6928                	ld	a0,80(a0)
    80001070:	edeff0ef          	jal	ra,8000074e <uvmalloc>
    80001074:	85aa                	mv	a1,a0
    80001076:	f16d                	bnez	a0,80001058 <growproc+0x1e>
      return -1;
    80001078:	557d                	li	a0,-1
    8000107a:	b7cd                	j	8000105c <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000107c:	00b90633          	add	a2,s2,a1
    80001080:	6928                	ld	a0,80(a0)
    80001082:	e88ff0ef          	jal	ra,8000070a <uvmdealloc>
    80001086:	85aa                	mv	a1,a0
    80001088:	bfc1                	j	80001058 <growproc+0x1e>

000000008000108a <kfork>:
{
    8000108a:	7179                	addi	sp,sp,-48
    8000108c:	f406                	sd	ra,40(sp)
    8000108e:	f022                	sd	s0,32(sp)
    80001090:	ec26                	sd	s1,24(sp)
    80001092:	e84a                	sd	s2,16(sp)
    80001094:	e44e                	sd	s3,8(sp)
    80001096:	e052                	sd	s4,0(sp)
    80001098:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000109a:	c9fff0ef          	jal	ra,80000d38 <myproc>
    8000109e:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800010a0:	eb9ff0ef          	jal	ra,80000f58 <allocproc>
    800010a4:	0e050563          	beqz	a0,8000118e <kfork+0x104>
    800010a8:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010aa:	04893603          	ld	a2,72(s2)
    800010ae:	692c                	ld	a1,80(a0)
    800010b0:	05093503          	ld	a0,80(s2)
    800010b4:	fc2ff0ef          	jal	ra,80000876 <uvmcopy>
    800010b8:	04054663          	bltz	a0,80001104 <kfork+0x7a>
  np->sz = p->sz;
    800010bc:	04893783          	ld	a5,72(s2)
    800010c0:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800010c4:	05893683          	ld	a3,88(s2)
    800010c8:	87b6                	mv	a5,a3
    800010ca:	0589b703          	ld	a4,88(s3)
    800010ce:	12068693          	addi	a3,a3,288
    800010d2:	0007b803          	ld	a6,0(a5)
    800010d6:	6788                	ld	a0,8(a5)
    800010d8:	6b8c                	ld	a1,16(a5)
    800010da:	6f90                	ld	a2,24(a5)
    800010dc:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    800010e0:	e708                	sd	a0,8(a4)
    800010e2:	eb0c                	sd	a1,16(a4)
    800010e4:	ef10                	sd	a2,24(a4)
    800010e6:	02078793          	addi	a5,a5,32
    800010ea:	02070713          	addi	a4,a4,32
    800010ee:	fed792e3          	bne	a5,a3,800010d2 <kfork+0x48>
  np->trapframe->a0 = 0;
    800010f2:	0589b783          	ld	a5,88(s3)
    800010f6:	0607b823          	sd	zero,112(a5)
    800010fa:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800010fe:	15000a13          	li	s4,336
    80001102:	a00d                	j	80001124 <kfork+0x9a>
    freeproc(np);
    80001104:	854e                	mv	a0,s3
    80001106:	e03ff0ef          	jal	ra,80000f08 <freeproc>
    release(&np->lock);
    8000110a:	854e                	mv	a0,s3
    8000110c:	76c040ef          	jal	ra,80005878 <release>
    return -1;
    80001110:	5a7d                	li	s4,-1
    80001112:	a0ad                	j	8000117c <kfork+0xf2>
      np->ofile[i] = filedup(p->ofile[i]);
    80001114:	37a020ef          	jal	ra,8000348e <filedup>
    80001118:	009987b3          	add	a5,s3,s1
    8000111c:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000111e:	04a1                	addi	s1,s1,8
    80001120:	01448763          	beq	s1,s4,8000112e <kfork+0xa4>
    if(p->ofile[i])
    80001124:	009907b3          	add	a5,s2,s1
    80001128:	6388                	ld	a0,0(a5)
    8000112a:	f56d                	bnez	a0,80001114 <kfork+0x8a>
    8000112c:	bfcd                	j	8000111e <kfork+0x94>
  np->cwd = idup(p->cwd);
    8000112e:	15093503          	ld	a0,336(s2)
    80001132:	580010ef          	jal	ra,800026b2 <idup>
    80001136:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000113a:	4641                	li	a2,16
    8000113c:	15890593          	addi	a1,s2,344
    80001140:	15898513          	addi	a0,s3,344
    80001144:	956ff0ef          	jal	ra,8000029a <safestrcpy>
  pid = np->pid;
    80001148:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000114c:	854e                	mv	a0,s3
    8000114e:	72a040ef          	jal	ra,80005878 <release>
  acquire(&wait_lock);
    80001152:	00006497          	auipc	s1,0x6
    80001156:	78648493          	addi	s1,s1,1926 # 800078d8 <wait_lock>
    8000115a:	8526                	mv	a0,s1
    8000115c:	684040ef          	jal	ra,800057e0 <acquire>
  np->parent = p;
    80001160:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001164:	8526                	mv	a0,s1
    80001166:	712040ef          	jal	ra,80005878 <release>
  acquire(&np->lock);
    8000116a:	854e                	mv	a0,s3
    8000116c:	674040ef          	jal	ra,800057e0 <acquire>
  np->state = RUNNABLE;
    80001170:	478d                	li	a5,3
    80001172:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001176:	854e                	mv	a0,s3
    80001178:	700040ef          	jal	ra,80005878 <release>
}
    8000117c:	8552                	mv	a0,s4
    8000117e:	70a2                	ld	ra,40(sp)
    80001180:	7402                	ld	s0,32(sp)
    80001182:	64e2                	ld	s1,24(sp)
    80001184:	6942                	ld	s2,16(sp)
    80001186:	69a2                	ld	s3,8(sp)
    80001188:	6a02                	ld	s4,0(sp)
    8000118a:	6145                	addi	sp,sp,48
    8000118c:	8082                	ret
    return -1;
    8000118e:	5a7d                	li	s4,-1
    80001190:	b7f5                	j	8000117c <kfork+0xf2>

0000000080001192 <scheduler>:
{
    80001192:	715d                	addi	sp,sp,-80
    80001194:	e486                	sd	ra,72(sp)
    80001196:	e0a2                	sd	s0,64(sp)
    80001198:	fc26                	sd	s1,56(sp)
    8000119a:	f84a                	sd	s2,48(sp)
    8000119c:	f44e                	sd	s3,40(sp)
    8000119e:	f052                	sd	s4,32(sp)
    800011a0:	ec56                	sd	s5,24(sp)
    800011a2:	e85a                	sd	s6,16(sp)
    800011a4:	e45e                	sd	s7,8(sp)
    800011a6:	e062                	sd	s8,0(sp)
    800011a8:	0880                	addi	s0,sp,80
    800011aa:	8792                	mv	a5,tp
  int id = r_tp();
    800011ac:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011ae:	00779b13          	slli	s6,a5,0x7
    800011b2:	00006717          	auipc	a4,0x6
    800011b6:	70e70713          	addi	a4,a4,1806 # 800078c0 <pid_lock>
    800011ba:	975a                	add	a4,a4,s6
    800011bc:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011c0:	00006717          	auipc	a4,0x6
    800011c4:	73870713          	addi	a4,a4,1848 # 800078f8 <cpus+0x8>
    800011c8:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011ca:	4c11                	li	s8,4
        c->proc = p;
    800011cc:	079e                	slli	a5,a5,0x7
    800011ce:	00006a17          	auipc	s4,0x6
    800011d2:	6f2a0a13          	addi	s4,s4,1778 # 800078c0 <pid_lock>
    800011d6:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800011d8:	0000c997          	auipc	s3,0xc
    800011dc:	51898993          	addi	s3,s3,1304 # 8000d6f0 <tickslock>
        found = 1;
    800011e0:	4b85                	li	s7,1
    800011e2:	a83d                	j	80001220 <scheduler+0x8e>
        p->state = RUNNING;
    800011e4:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800011e8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800011ec:	06048593          	addi	a1,s1,96
    800011f0:	855a                	mv	a0,s6
    800011f2:	64a000ef          	jal	ra,8000183c <swtch>
        c->proc = 0;
    800011f6:	020a3823          	sd	zero,48(s4)
        found = 1;
    800011fa:	8ade                	mv	s5,s7
      release(&p->lock);
    800011fc:	8526                	mv	a0,s1
    800011fe:	67a040ef          	jal	ra,80005878 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001202:	16848493          	addi	s1,s1,360
    80001206:	01348963          	beq	s1,s3,80001218 <scheduler+0x86>
      acquire(&p->lock);
    8000120a:	8526                	mv	a0,s1
    8000120c:	5d4040ef          	jal	ra,800057e0 <acquire>
      if(p->state == RUNNABLE) {
    80001210:	4c9c                	lw	a5,24(s1)
    80001212:	ff2795e3          	bne	a5,s2,800011fc <scheduler+0x6a>
    80001216:	b7f9                	j	800011e4 <scheduler+0x52>
    if(found == 0) {
    80001218:	000a9463          	bnez	s5,80001220 <scheduler+0x8e>
      asm volatile("wfi");
    8000121c:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001220:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001224:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001228:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000122c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001230:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001232:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001236:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001238:	00007497          	auipc	s1,0x7
    8000123c:	ab848493          	addi	s1,s1,-1352 # 80007cf0 <proc>
      if(p->state == RUNNABLE) {
    80001240:	490d                	li	s2,3
    80001242:	b7e1                	j	8000120a <scheduler+0x78>

0000000080001244 <sched>:
{
    80001244:	7179                	addi	sp,sp,-48
    80001246:	f406                	sd	ra,40(sp)
    80001248:	f022                	sd	s0,32(sp)
    8000124a:	ec26                	sd	s1,24(sp)
    8000124c:	e84a                	sd	s2,16(sp)
    8000124e:	e44e                	sd	s3,8(sp)
    80001250:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001252:	ae7ff0ef          	jal	ra,80000d38 <myproc>
    80001256:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001258:	51e040ef          	jal	ra,80005776 <holding>
    8000125c:	c92d                	beqz	a0,800012ce <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000125e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001260:	2781                	sext.w	a5,a5
    80001262:	079e                	slli	a5,a5,0x7
    80001264:	00006717          	auipc	a4,0x6
    80001268:	65c70713          	addi	a4,a4,1628 # 800078c0 <pid_lock>
    8000126c:	97ba                	add	a5,a5,a4
    8000126e:	0a87a703          	lw	a4,168(a5)
    80001272:	4785                	li	a5,1
    80001274:	06f71363          	bne	a4,a5,800012da <sched+0x96>
  if(p->state == RUNNING)
    80001278:	4c98                	lw	a4,24(s1)
    8000127a:	4791                	li	a5,4
    8000127c:	06f70563          	beq	a4,a5,800012e6 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001280:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001284:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001286:	e7b5                	bnez	a5,800012f2 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001288:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000128a:	00006917          	auipc	s2,0x6
    8000128e:	63690913          	addi	s2,s2,1590 # 800078c0 <pid_lock>
    80001292:	2781                	sext.w	a5,a5
    80001294:	079e                	slli	a5,a5,0x7
    80001296:	97ca                	add	a5,a5,s2
    80001298:	0ac7a983          	lw	s3,172(a5)
    8000129c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000129e:	2781                	sext.w	a5,a5
    800012a0:	079e                	slli	a5,a5,0x7
    800012a2:	00006597          	auipc	a1,0x6
    800012a6:	65658593          	addi	a1,a1,1622 # 800078f8 <cpus+0x8>
    800012aa:	95be                	add	a1,a1,a5
    800012ac:	06048513          	addi	a0,s1,96
    800012b0:	58c000ef          	jal	ra,8000183c <swtch>
    800012b4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012b6:	2781                	sext.w	a5,a5
    800012b8:	079e                	slli	a5,a5,0x7
    800012ba:	97ca                	add	a5,a5,s2
    800012bc:	0b37a623          	sw	s3,172(a5)
}
    800012c0:	70a2                	ld	ra,40(sp)
    800012c2:	7402                	ld	s0,32(sp)
    800012c4:	64e2                	ld	s1,24(sp)
    800012c6:	6942                	ld	s2,16(sp)
    800012c8:	69a2                	ld	s3,8(sp)
    800012ca:	6145                	addi	sp,sp,48
    800012cc:	8082                	ret
    panic("sched p->lock");
    800012ce:	00006517          	auipc	a0,0x6
    800012d2:	e8250513          	addi	a0,a0,-382 # 80007150 <etext+0x150>
    800012d6:	250040ef          	jal	ra,80005526 <panic>
    panic("sched locks");
    800012da:	00006517          	auipc	a0,0x6
    800012de:	e8650513          	addi	a0,a0,-378 # 80007160 <etext+0x160>
    800012e2:	244040ef          	jal	ra,80005526 <panic>
    panic("sched RUNNING");
    800012e6:	00006517          	auipc	a0,0x6
    800012ea:	e8a50513          	addi	a0,a0,-374 # 80007170 <etext+0x170>
    800012ee:	238040ef          	jal	ra,80005526 <panic>
    panic("sched interruptible");
    800012f2:	00006517          	auipc	a0,0x6
    800012f6:	e8e50513          	addi	a0,a0,-370 # 80007180 <etext+0x180>
    800012fa:	22c040ef          	jal	ra,80005526 <panic>

00000000800012fe <yield>:
{
    800012fe:	1101                	addi	sp,sp,-32
    80001300:	ec06                	sd	ra,24(sp)
    80001302:	e822                	sd	s0,16(sp)
    80001304:	e426                	sd	s1,8(sp)
    80001306:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001308:	a31ff0ef          	jal	ra,80000d38 <myproc>
    8000130c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000130e:	4d2040ef          	jal	ra,800057e0 <acquire>
  p->state = RUNNABLE;
    80001312:	478d                	li	a5,3
    80001314:	cc9c                	sw	a5,24(s1)
  sched();
    80001316:	f2fff0ef          	jal	ra,80001244 <sched>
  release(&p->lock);
    8000131a:	8526                	mv	a0,s1
    8000131c:	55c040ef          	jal	ra,80005878 <release>
}
    80001320:	60e2                	ld	ra,24(sp)
    80001322:	6442                	ld	s0,16(sp)
    80001324:	64a2                	ld	s1,8(sp)
    80001326:	6105                	addi	sp,sp,32
    80001328:	8082                	ret

000000008000132a <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000132a:	7179                	addi	sp,sp,-48
    8000132c:	f406                	sd	ra,40(sp)
    8000132e:	f022                	sd	s0,32(sp)
    80001330:	ec26                	sd	s1,24(sp)
    80001332:	e84a                	sd	s2,16(sp)
    80001334:	e44e                	sd	s3,8(sp)
    80001336:	1800                	addi	s0,sp,48
    80001338:	89aa                	mv	s3,a0
    8000133a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000133c:	9fdff0ef          	jal	ra,80000d38 <myproc>
    80001340:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001342:	49e040ef          	jal	ra,800057e0 <acquire>
  release(lk);
    80001346:	854a                	mv	a0,s2
    80001348:	530040ef          	jal	ra,80005878 <release>

  // Go to sleep.
  p->chan = chan;
    8000134c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001350:	4789                	li	a5,2
    80001352:	cc9c                	sw	a5,24(s1)

  sched();
    80001354:	ef1ff0ef          	jal	ra,80001244 <sched>

  // Tidy up.
  p->chan = 0;
    80001358:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000135c:	8526                	mv	a0,s1
    8000135e:	51a040ef          	jal	ra,80005878 <release>
  acquire(lk);
    80001362:	854a                	mv	a0,s2
    80001364:	47c040ef          	jal	ra,800057e0 <acquire>
}
    80001368:	70a2                	ld	ra,40(sp)
    8000136a:	7402                	ld	s0,32(sp)
    8000136c:	64e2                	ld	s1,24(sp)
    8000136e:	6942                	ld	s2,16(sp)
    80001370:	69a2                	ld	s3,8(sp)
    80001372:	6145                	addi	sp,sp,48
    80001374:	8082                	ret

0000000080001376 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001376:	7139                	addi	sp,sp,-64
    80001378:	fc06                	sd	ra,56(sp)
    8000137a:	f822                	sd	s0,48(sp)
    8000137c:	f426                	sd	s1,40(sp)
    8000137e:	f04a                	sd	s2,32(sp)
    80001380:	ec4e                	sd	s3,24(sp)
    80001382:	e852                	sd	s4,16(sp)
    80001384:	e456                	sd	s5,8(sp)
    80001386:	0080                	addi	s0,sp,64
    80001388:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000138a:	00007497          	auipc	s1,0x7
    8000138e:	96648493          	addi	s1,s1,-1690 # 80007cf0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001392:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001394:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001396:	0000c917          	auipc	s2,0xc
    8000139a:	35a90913          	addi	s2,s2,858 # 8000d6f0 <tickslock>
    8000139e:	a811                	j	800013b2 <wakeup+0x3c>
        p->state = RUNNABLE;
    800013a0:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800013a4:	8526                	mv	a0,s1
    800013a6:	4d2040ef          	jal	ra,80005878 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013aa:	16848493          	addi	s1,s1,360
    800013ae:	03248063          	beq	s1,s2,800013ce <wakeup+0x58>
    if(p != myproc()){
    800013b2:	987ff0ef          	jal	ra,80000d38 <myproc>
    800013b6:	fea48ae3          	beq	s1,a0,800013aa <wakeup+0x34>
      acquire(&p->lock);
    800013ba:	8526                	mv	a0,s1
    800013bc:	424040ef          	jal	ra,800057e0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013c0:	4c9c                	lw	a5,24(s1)
    800013c2:	ff3791e3          	bne	a5,s3,800013a4 <wakeup+0x2e>
    800013c6:	709c                	ld	a5,32(s1)
    800013c8:	fd479ee3          	bne	a5,s4,800013a4 <wakeup+0x2e>
    800013cc:	bfd1                	j	800013a0 <wakeup+0x2a>
    }
  }
}
    800013ce:	70e2                	ld	ra,56(sp)
    800013d0:	7442                	ld	s0,48(sp)
    800013d2:	74a2                	ld	s1,40(sp)
    800013d4:	7902                	ld	s2,32(sp)
    800013d6:	69e2                	ld	s3,24(sp)
    800013d8:	6a42                	ld	s4,16(sp)
    800013da:	6aa2                	ld	s5,8(sp)
    800013dc:	6121                	addi	sp,sp,64
    800013de:	8082                	ret

00000000800013e0 <reparent>:
{
    800013e0:	7179                	addi	sp,sp,-48
    800013e2:	f406                	sd	ra,40(sp)
    800013e4:	f022                	sd	s0,32(sp)
    800013e6:	ec26                	sd	s1,24(sp)
    800013e8:	e84a                	sd	s2,16(sp)
    800013ea:	e44e                	sd	s3,8(sp)
    800013ec:	e052                	sd	s4,0(sp)
    800013ee:	1800                	addi	s0,sp,48
    800013f0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013f2:	00007497          	auipc	s1,0x7
    800013f6:	8fe48493          	addi	s1,s1,-1794 # 80007cf0 <proc>
      pp->parent = initproc;
    800013fa:	00006a17          	auipc	s4,0x6
    800013fe:	486a0a13          	addi	s4,s4,1158 # 80007880 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001402:	0000c997          	auipc	s3,0xc
    80001406:	2ee98993          	addi	s3,s3,750 # 8000d6f0 <tickslock>
    8000140a:	a029                	j	80001414 <reparent+0x34>
    8000140c:	16848493          	addi	s1,s1,360
    80001410:	01348b63          	beq	s1,s3,80001426 <reparent+0x46>
    if(pp->parent == p){
    80001414:	7c9c                	ld	a5,56(s1)
    80001416:	ff279be3          	bne	a5,s2,8000140c <reparent+0x2c>
      pp->parent = initproc;
    8000141a:	000a3503          	ld	a0,0(s4)
    8000141e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001420:	f57ff0ef          	jal	ra,80001376 <wakeup>
    80001424:	b7e5                	j	8000140c <reparent+0x2c>
}
    80001426:	70a2                	ld	ra,40(sp)
    80001428:	7402                	ld	s0,32(sp)
    8000142a:	64e2                	ld	s1,24(sp)
    8000142c:	6942                	ld	s2,16(sp)
    8000142e:	69a2                	ld	s3,8(sp)
    80001430:	6a02                	ld	s4,0(sp)
    80001432:	6145                	addi	sp,sp,48
    80001434:	8082                	ret

0000000080001436 <kexit>:
{
    80001436:	7179                	addi	sp,sp,-48
    80001438:	f406                	sd	ra,40(sp)
    8000143a:	f022                	sd	s0,32(sp)
    8000143c:	ec26                	sd	s1,24(sp)
    8000143e:	e84a                	sd	s2,16(sp)
    80001440:	e44e                	sd	s3,8(sp)
    80001442:	e052                	sd	s4,0(sp)
    80001444:	1800                	addi	s0,sp,48
    80001446:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001448:	8f1ff0ef          	jal	ra,80000d38 <myproc>
    8000144c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000144e:	00006797          	auipc	a5,0x6
    80001452:	4327b783          	ld	a5,1074(a5) # 80007880 <initproc>
    80001456:	0d050493          	addi	s1,a0,208
    8000145a:	15050913          	addi	s2,a0,336
    8000145e:	00a79f63          	bne	a5,a0,8000147c <kexit+0x46>
    panic("init exiting");
    80001462:	00006517          	auipc	a0,0x6
    80001466:	d3650513          	addi	a0,a0,-714 # 80007198 <etext+0x198>
    8000146a:	0bc040ef          	jal	ra,80005526 <panic>
      fileclose(f);
    8000146e:	066020ef          	jal	ra,800034d4 <fileclose>
      p->ofile[fd] = 0;
    80001472:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001476:	04a1                	addi	s1,s1,8
    80001478:	01248563          	beq	s1,s2,80001482 <kexit+0x4c>
    if(p->ofile[fd]){
    8000147c:	6088                	ld	a0,0(s1)
    8000147e:	f965                	bnez	a0,8000146e <kexit+0x38>
    80001480:	bfdd                	j	80001476 <kexit+0x40>
  begin_op();
    80001482:	445010ef          	jal	ra,800030c6 <begin_op>
  iput(p->cwd);
    80001486:	1509b503          	ld	a0,336(s3)
    8000148a:	3dc010ef          	jal	ra,80002866 <iput>
  end_op();
    8000148e:	4a9010ef          	jal	ra,80003136 <end_op>
  p->cwd = 0;
    80001492:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001496:	00006497          	auipc	s1,0x6
    8000149a:	44248493          	addi	s1,s1,1090 # 800078d8 <wait_lock>
    8000149e:	8526                	mv	a0,s1
    800014a0:	340040ef          	jal	ra,800057e0 <acquire>
  reparent(p);
    800014a4:	854e                	mv	a0,s3
    800014a6:	f3bff0ef          	jal	ra,800013e0 <reparent>
  wakeup(p->parent);
    800014aa:	0389b503          	ld	a0,56(s3)
    800014ae:	ec9ff0ef          	jal	ra,80001376 <wakeup>
  acquire(&p->lock);
    800014b2:	854e                	mv	a0,s3
    800014b4:	32c040ef          	jal	ra,800057e0 <acquire>
  p->xstate = status;
    800014b8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014bc:	4795                	li	a5,5
    800014be:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014c2:	8526                	mv	a0,s1
    800014c4:	3b4040ef          	jal	ra,80005878 <release>
  sched();
    800014c8:	d7dff0ef          	jal	ra,80001244 <sched>
  panic("zombie exit");
    800014cc:	00006517          	auipc	a0,0x6
    800014d0:	cdc50513          	addi	a0,a0,-804 # 800071a8 <etext+0x1a8>
    800014d4:	052040ef          	jal	ra,80005526 <panic>

00000000800014d8 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800014d8:	7179                	addi	sp,sp,-48
    800014da:	f406                	sd	ra,40(sp)
    800014dc:	f022                	sd	s0,32(sp)
    800014de:	ec26                	sd	s1,24(sp)
    800014e0:	e84a                	sd	s2,16(sp)
    800014e2:	e44e                	sd	s3,8(sp)
    800014e4:	1800                	addi	s0,sp,48
    800014e6:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014e8:	00007497          	auipc	s1,0x7
    800014ec:	80848493          	addi	s1,s1,-2040 # 80007cf0 <proc>
    800014f0:	0000c997          	auipc	s3,0xc
    800014f4:	20098993          	addi	s3,s3,512 # 8000d6f0 <tickslock>
    acquire(&p->lock);
    800014f8:	8526                	mv	a0,s1
    800014fa:	2e6040ef          	jal	ra,800057e0 <acquire>
    if(p->pid == pid){
    800014fe:	589c                	lw	a5,48(s1)
    80001500:	01278b63          	beq	a5,s2,80001516 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001504:	8526                	mv	a0,s1
    80001506:	372040ef          	jal	ra,80005878 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000150a:	16848493          	addi	s1,s1,360
    8000150e:	ff3495e3          	bne	s1,s3,800014f8 <kkill+0x20>
  }
  return -1;
    80001512:	557d                	li	a0,-1
    80001514:	a819                	j	8000152a <kkill+0x52>
      p->killed = 1;
    80001516:	4785                	li	a5,1
    80001518:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000151a:	4c98                	lw	a4,24(s1)
    8000151c:	4789                	li	a5,2
    8000151e:	00f70d63          	beq	a4,a5,80001538 <kkill+0x60>
      release(&p->lock);
    80001522:	8526                	mv	a0,s1
    80001524:	354040ef          	jal	ra,80005878 <release>
      return 0;
    80001528:	4501                	li	a0,0
}
    8000152a:	70a2                	ld	ra,40(sp)
    8000152c:	7402                	ld	s0,32(sp)
    8000152e:	64e2                	ld	s1,24(sp)
    80001530:	6942                	ld	s2,16(sp)
    80001532:	69a2                	ld	s3,8(sp)
    80001534:	6145                	addi	sp,sp,48
    80001536:	8082                	ret
        p->state = RUNNABLE;
    80001538:	478d                	li	a5,3
    8000153a:	cc9c                	sw	a5,24(s1)
    8000153c:	b7dd                	j	80001522 <kkill+0x4a>

000000008000153e <setkilled>:

void
setkilled(struct proc *p)
{
    8000153e:	1101                	addi	sp,sp,-32
    80001540:	ec06                	sd	ra,24(sp)
    80001542:	e822                	sd	s0,16(sp)
    80001544:	e426                	sd	s1,8(sp)
    80001546:	1000                	addi	s0,sp,32
    80001548:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000154a:	296040ef          	jal	ra,800057e0 <acquire>
  p->killed = 1;
    8000154e:	4785                	li	a5,1
    80001550:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001552:	8526                	mv	a0,s1
    80001554:	324040ef          	jal	ra,80005878 <release>
}
    80001558:	60e2                	ld	ra,24(sp)
    8000155a:	6442                	ld	s0,16(sp)
    8000155c:	64a2                	ld	s1,8(sp)
    8000155e:	6105                	addi	sp,sp,32
    80001560:	8082                	ret

0000000080001562 <killed>:

int
killed(struct proc *p)
{
    80001562:	1101                	addi	sp,sp,-32
    80001564:	ec06                	sd	ra,24(sp)
    80001566:	e822                	sd	s0,16(sp)
    80001568:	e426                	sd	s1,8(sp)
    8000156a:	e04a                	sd	s2,0(sp)
    8000156c:	1000                	addi	s0,sp,32
    8000156e:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001570:	270040ef          	jal	ra,800057e0 <acquire>
  k = p->killed;
    80001574:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001578:	8526                	mv	a0,s1
    8000157a:	2fe040ef          	jal	ra,80005878 <release>
  return k;
}
    8000157e:	854a                	mv	a0,s2
    80001580:	60e2                	ld	ra,24(sp)
    80001582:	6442                	ld	s0,16(sp)
    80001584:	64a2                	ld	s1,8(sp)
    80001586:	6902                	ld	s2,0(sp)
    80001588:	6105                	addi	sp,sp,32
    8000158a:	8082                	ret

000000008000158c <kwait>:
{
    8000158c:	715d                	addi	sp,sp,-80
    8000158e:	e486                	sd	ra,72(sp)
    80001590:	e0a2                	sd	s0,64(sp)
    80001592:	fc26                	sd	s1,56(sp)
    80001594:	f84a                	sd	s2,48(sp)
    80001596:	f44e                	sd	s3,40(sp)
    80001598:	f052                	sd	s4,32(sp)
    8000159a:	ec56                	sd	s5,24(sp)
    8000159c:	e85a                	sd	s6,16(sp)
    8000159e:	e45e                	sd	s7,8(sp)
    800015a0:	e062                	sd	s8,0(sp)
    800015a2:	0880                	addi	s0,sp,80
    800015a4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015a6:	f92ff0ef          	jal	ra,80000d38 <myproc>
    800015aa:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015ac:	00006517          	auipc	a0,0x6
    800015b0:	32c50513          	addi	a0,a0,812 # 800078d8 <wait_lock>
    800015b4:	22c040ef          	jal	ra,800057e0 <acquire>
    havekids = 0;
    800015b8:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800015ba:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015bc:	0000c997          	auipc	s3,0xc
    800015c0:	13498993          	addi	s3,s3,308 # 8000d6f0 <tickslock>
        havekids = 1;
    800015c4:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015c6:	00006c17          	auipc	s8,0x6
    800015ca:	312c0c13          	addi	s8,s8,786 # 800078d8 <wait_lock>
    havekids = 0;
    800015ce:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015d0:	00006497          	auipc	s1,0x6
    800015d4:	72048493          	addi	s1,s1,1824 # 80007cf0 <proc>
    800015d8:	a899                	j	8000162e <kwait+0xa2>
          pid = pp->pid;
    800015da:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015de:	000b0c63          	beqz	s6,800015f6 <kwait+0x6a>
    800015e2:	4691                	li	a3,4
    800015e4:	02c48613          	addi	a2,s1,44
    800015e8:	85da                	mv	a1,s6
    800015ea:	05093503          	ld	a0,80(s2)
    800015ee:	c92ff0ef          	jal	ra,80000a80 <copyout>
    800015f2:	00054f63          	bltz	a0,80001610 <kwait+0x84>
          freeproc(pp);
    800015f6:	8526                	mv	a0,s1
    800015f8:	911ff0ef          	jal	ra,80000f08 <freeproc>
          release(&pp->lock);
    800015fc:	8526                	mv	a0,s1
    800015fe:	27a040ef          	jal	ra,80005878 <release>
          release(&wait_lock);
    80001602:	00006517          	auipc	a0,0x6
    80001606:	2d650513          	addi	a0,a0,726 # 800078d8 <wait_lock>
    8000160a:	26e040ef          	jal	ra,80005878 <release>
          return pid;
    8000160e:	a891                	j	80001662 <kwait+0xd6>
            release(&pp->lock);
    80001610:	8526                	mv	a0,s1
    80001612:	266040ef          	jal	ra,80005878 <release>
            release(&wait_lock);
    80001616:	00006517          	auipc	a0,0x6
    8000161a:	2c250513          	addi	a0,a0,706 # 800078d8 <wait_lock>
    8000161e:	25a040ef          	jal	ra,80005878 <release>
            return -1;
    80001622:	59fd                	li	s3,-1
    80001624:	a83d                	j	80001662 <kwait+0xd6>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001626:	16848493          	addi	s1,s1,360
    8000162a:	03348063          	beq	s1,s3,8000164a <kwait+0xbe>
      if(pp->parent == p){
    8000162e:	7c9c                	ld	a5,56(s1)
    80001630:	ff279be3          	bne	a5,s2,80001626 <kwait+0x9a>
        acquire(&pp->lock);
    80001634:	8526                	mv	a0,s1
    80001636:	1aa040ef          	jal	ra,800057e0 <acquire>
        if(pp->state == ZOMBIE){
    8000163a:	4c9c                	lw	a5,24(s1)
    8000163c:	f9478fe3          	beq	a5,s4,800015da <kwait+0x4e>
        release(&pp->lock);
    80001640:	8526                	mv	a0,s1
    80001642:	236040ef          	jal	ra,80005878 <release>
        havekids = 1;
    80001646:	8756                	mv	a4,s5
    80001648:	bff9                	j	80001626 <kwait+0x9a>
    if(!havekids || killed(p)){
    8000164a:	c709                	beqz	a4,80001654 <kwait+0xc8>
    8000164c:	854a                	mv	a0,s2
    8000164e:	f15ff0ef          	jal	ra,80001562 <killed>
    80001652:	c50d                	beqz	a0,8000167c <kwait+0xf0>
      release(&wait_lock);
    80001654:	00006517          	auipc	a0,0x6
    80001658:	28450513          	addi	a0,a0,644 # 800078d8 <wait_lock>
    8000165c:	21c040ef          	jal	ra,80005878 <release>
      return -1;
    80001660:	59fd                	li	s3,-1
}
    80001662:	854e                	mv	a0,s3
    80001664:	60a6                	ld	ra,72(sp)
    80001666:	6406                	ld	s0,64(sp)
    80001668:	74e2                	ld	s1,56(sp)
    8000166a:	7942                	ld	s2,48(sp)
    8000166c:	79a2                	ld	s3,40(sp)
    8000166e:	7a02                	ld	s4,32(sp)
    80001670:	6ae2                	ld	s5,24(sp)
    80001672:	6b42                	ld	s6,16(sp)
    80001674:	6ba2                	ld	s7,8(sp)
    80001676:	6c02                	ld	s8,0(sp)
    80001678:	6161                	addi	sp,sp,80
    8000167a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000167c:	85e2                	mv	a1,s8
    8000167e:	854a                	mv	a0,s2
    80001680:	cabff0ef          	jal	ra,8000132a <sleep>
    havekids = 0;
    80001684:	b7a9                	j	800015ce <kwait+0x42>

0000000080001686 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001686:	7179                	addi	sp,sp,-48
    80001688:	f406                	sd	ra,40(sp)
    8000168a:	f022                	sd	s0,32(sp)
    8000168c:	ec26                	sd	s1,24(sp)
    8000168e:	e84a                	sd	s2,16(sp)
    80001690:	e44e                	sd	s3,8(sp)
    80001692:	e052                	sd	s4,0(sp)
    80001694:	1800                	addi	s0,sp,48
    80001696:	84aa                	mv	s1,a0
    80001698:	892e                	mv	s2,a1
    8000169a:	89b2                	mv	s3,a2
    8000169c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000169e:	e9aff0ef          	jal	ra,80000d38 <myproc>
  if(user_dst){
    800016a2:	cc99                	beqz	s1,800016c0 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016a4:	86d2                	mv	a3,s4
    800016a6:	864e                	mv	a2,s3
    800016a8:	85ca                	mv	a1,s2
    800016aa:	6928                	ld	a0,80(a0)
    800016ac:	bd4ff0ef          	jal	ra,80000a80 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016b0:	70a2                	ld	ra,40(sp)
    800016b2:	7402                	ld	s0,32(sp)
    800016b4:	64e2                	ld	s1,24(sp)
    800016b6:	6942                	ld	s2,16(sp)
    800016b8:	69a2                	ld	s3,8(sp)
    800016ba:	6a02                	ld	s4,0(sp)
    800016bc:	6145                	addi	sp,sp,48
    800016be:	8082                	ret
    memmove((char *)dst, src, len);
    800016c0:	000a061b          	sext.w	a2,s4
    800016c4:	85ce                	mv	a1,s3
    800016c6:	854a                	mv	a0,s2
    800016c8:	ae5fe0ef          	jal	ra,800001ac <memmove>
    return 0;
    800016cc:	8526                	mv	a0,s1
    800016ce:	b7cd                	j	800016b0 <either_copyout+0x2a>

00000000800016d0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016d0:	7179                	addi	sp,sp,-48
    800016d2:	f406                	sd	ra,40(sp)
    800016d4:	f022                	sd	s0,32(sp)
    800016d6:	ec26                	sd	s1,24(sp)
    800016d8:	e84a                	sd	s2,16(sp)
    800016da:	e44e                	sd	s3,8(sp)
    800016dc:	e052                	sd	s4,0(sp)
    800016de:	1800                	addi	s0,sp,48
    800016e0:	892a                	mv	s2,a0
    800016e2:	84ae                	mv	s1,a1
    800016e4:	89b2                	mv	s3,a2
    800016e6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016e8:	e50ff0ef          	jal	ra,80000d38 <myproc>
  if(user_src){
    800016ec:	cc99                	beqz	s1,8000170a <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800016ee:	86d2                	mv	a3,s4
    800016f0:	864e                	mv	a2,s3
    800016f2:	85ca                	mv	a1,s2
    800016f4:	6928                	ld	a0,80(a0)
    800016f6:	c56ff0ef          	jal	ra,80000b4c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800016fa:	70a2                	ld	ra,40(sp)
    800016fc:	7402                	ld	s0,32(sp)
    800016fe:	64e2                	ld	s1,24(sp)
    80001700:	6942                	ld	s2,16(sp)
    80001702:	69a2                	ld	s3,8(sp)
    80001704:	6a02                	ld	s4,0(sp)
    80001706:	6145                	addi	sp,sp,48
    80001708:	8082                	ret
    memmove(dst, (char*)src, len);
    8000170a:	000a061b          	sext.w	a2,s4
    8000170e:	85ce                	mv	a1,s3
    80001710:	854a                	mv	a0,s2
    80001712:	a9bfe0ef          	jal	ra,800001ac <memmove>
    return 0;
    80001716:	8526                	mv	a0,s1
    80001718:	b7cd                	j	800016fa <either_copyin+0x2a>

000000008000171a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000171a:	715d                	addi	sp,sp,-80
    8000171c:	e486                	sd	ra,72(sp)
    8000171e:	e0a2                	sd	s0,64(sp)
    80001720:	fc26                	sd	s1,56(sp)
    80001722:	f84a                	sd	s2,48(sp)
    80001724:	f44e                	sd	s3,40(sp)
    80001726:	f052                	sd	s4,32(sp)
    80001728:	ec56                	sd	s5,24(sp)
    8000172a:	e85a                	sd	s6,16(sp)
    8000172c:	e45e                	sd	s7,8(sp)
    8000172e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001730:	00006517          	auipc	a0,0x6
    80001734:	91850513          	addi	a0,a0,-1768 # 80007048 <etext+0x48>
    80001738:	329030ef          	jal	ra,80005260 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000173c:	00006497          	auipc	s1,0x6
    80001740:	70c48493          	addi	s1,s1,1804 # 80007e48 <proc+0x158>
    80001744:	0000c917          	auipc	s2,0xc
    80001748:	10490913          	addi	s2,s2,260 # 8000d848 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000174c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000174e:	00006997          	auipc	s3,0x6
    80001752:	a6a98993          	addi	s3,s3,-1430 # 800071b8 <etext+0x1b8>
    printf("%d %s %s", p->pid, state, p->name);
    80001756:	00006a97          	auipc	s5,0x6
    8000175a:	a6aa8a93          	addi	s5,s5,-1430 # 800071c0 <etext+0x1c0>
    printf("\n");
    8000175e:	00006a17          	auipc	s4,0x6
    80001762:	8eaa0a13          	addi	s4,s4,-1814 # 80007048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001766:	00006b97          	auipc	s7,0x6
    8000176a:	a9ab8b93          	addi	s7,s7,-1382 # 80007200 <states.1739>
    8000176e:	a829                	j	80001788 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001770:	ed86a583          	lw	a1,-296(a3)
    80001774:	8556                	mv	a0,s5
    80001776:	2eb030ef          	jal	ra,80005260 <printf>
    printf("\n");
    8000177a:	8552                	mv	a0,s4
    8000177c:	2e5030ef          	jal	ra,80005260 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001780:	16848493          	addi	s1,s1,360
    80001784:	03248163          	beq	s1,s2,800017a6 <procdump+0x8c>
    if(p->state == UNUSED)
    80001788:	86a6                	mv	a3,s1
    8000178a:	ec04a783          	lw	a5,-320(s1)
    8000178e:	dbed                	beqz	a5,80001780 <procdump+0x66>
      state = "???";
    80001790:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001792:	fcfb6fe3          	bltu	s6,a5,80001770 <procdump+0x56>
    80001796:	1782                	slli	a5,a5,0x20
    80001798:	9381                	srli	a5,a5,0x20
    8000179a:	078e                	slli	a5,a5,0x3
    8000179c:	97de                	add	a5,a5,s7
    8000179e:	6390                	ld	a2,0(a5)
    800017a0:	fa61                	bnez	a2,80001770 <procdump+0x56>
      state = "???";
    800017a2:	864e                	mv	a2,s3
    800017a4:	b7f1                	j	80001770 <procdump+0x56>
  }
}
    800017a6:	60a6                	ld	ra,72(sp)
    800017a8:	6406                	ld	s0,64(sp)
    800017aa:	74e2                	ld	s1,56(sp)
    800017ac:	7942                	ld	s2,48(sp)
    800017ae:	79a2                	ld	s3,40(sp)
    800017b0:	7a02                	ld	s4,32(sp)
    800017b2:	6ae2                	ld	s5,24(sp)
    800017b4:	6b42                	ld	s6,16(sp)
    800017b6:	6ba2                	ld	s7,8(sp)
    800017b8:	6161                	addi	sp,sp,80
    800017ba:	8082                	ret

00000000800017bc <get_proc_tree_data>:

// Helper function for the pstree system call to collect active processes data
int
get_proc_tree_data(struct proc_info *info_array) {
    800017bc:	7139                	addi	sp,sp,-64
    800017be:	fc06                	sd	ra,56(sp)
    800017c0:	f822                	sd	s0,48(sp)
    800017c2:	f426                	sd	s1,40(sp)
    800017c4:	f04a                	sd	s2,32(sp)
    800017c6:	ec4e                	sd	s3,24(sp)
    800017c8:	e852                	sd	s4,16(sp)
    800017ca:	e456                	sd	s5,8(sp)
    800017cc:	0080                	addi	s0,sp,64
    800017ce:	8aaa                	mv	s5,a0
  struct proc *p;
  int count = 0;
    800017d0:	4901                	li	s2,0

  // Loop through the process table defined in kernel
  for(p = proc; p < &proc[NPROC]; p++) {
    800017d2:	00006497          	auipc	s1,0x6
    800017d6:	51e48493          	addi	s1,s1,1310 # 80007cf0 <proc>
    800017da:	0000ca17          	auipc	s4,0xc
    800017de:	f16a0a13          	addi	s4,s4,-234 # 8000d6f0 <tickslock>
    800017e2:	a00d                	j	80001804 <get_proc_tree_data+0x48>
      
      // Check if process has a parent to get its PID
      if(p->parent) {
        info_array[count].ppid = p->parent->pid;
      } else {
        info_array[count].ppid = 0; // Root process (init)
    800017e4:	00052223          	sw	zero,4(a0)
      }
      
      // Copy process name safely
      safestrcpy(info_array[count].name, p->name, sizeof(p->name));
    800017e8:	4641                	li	a2,16
    800017ea:	15898593          	addi	a1,s3,344
    800017ee:	0521                	addi	a0,a0,8
    800017f0:	aabfe0ef          	jal	ra,8000029a <safestrcpy>
      count++;
    800017f4:	2905                	addiw	s2,s2,1
    }
    release(&p->lock);
    800017f6:	8526                	mv	a0,s1
    800017f8:	080040ef          	jal	ra,80005878 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017fc:	16848493          	addi	s1,s1,360
    80001800:	03448463          	beq	s1,s4,80001828 <get_proc_tree_data+0x6c>
    acquire(&p->lock);
    80001804:	89a6                	mv	s3,s1
    80001806:	8526                	mv	a0,s1
    80001808:	7d9030ef          	jal	ra,800057e0 <acquire>
    if(p->state != UNUSED) {
    8000180c:	4c9c                	lw	a5,24(s1)
    8000180e:	d7e5                	beqz	a5,800017f6 <get_proc_tree_data+0x3a>
      info_array[count].pid = p->pid;
    80001810:	00191513          	slli	a0,s2,0x1
    80001814:	954a                	add	a0,a0,s2
    80001816:	050e                	slli	a0,a0,0x3
    80001818:	9556                	add	a0,a0,s5
    8000181a:	589c                	lw	a5,48(s1)
    8000181c:	c11c                	sw	a5,0(a0)
      if(p->parent) {
    8000181e:	7c9c                	ld	a5,56(s1)
    80001820:	d3f1                	beqz	a5,800017e4 <get_proc_tree_data+0x28>
        info_array[count].ppid = p->parent->pid;
    80001822:	5b9c                	lw	a5,48(a5)
    80001824:	c15c                	sw	a5,4(a0)
    80001826:	b7c9                	j	800017e8 <get_proc_tree_data+0x2c>
  }
  return count; // Return total number of active processes found
}
    80001828:	854a                	mv	a0,s2
    8000182a:	70e2                	ld	ra,56(sp)
    8000182c:	7442                	ld	s0,48(sp)
    8000182e:	74a2                	ld	s1,40(sp)
    80001830:	7902                	ld	s2,32(sp)
    80001832:	69e2                	ld	s3,24(sp)
    80001834:	6a42                	ld	s4,16(sp)
    80001836:	6aa2                	ld	s5,8(sp)
    80001838:	6121                	addi	sp,sp,64
    8000183a:	8082                	ret

000000008000183c <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    8000183c:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001840:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80001844:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001846:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001848:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    8000184c:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001850:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80001854:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001858:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    8000185c:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001860:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80001864:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001868:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8000186c:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001870:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80001874:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001878:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8000187a:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000187c:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001880:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80001884:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001888:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000188c:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001890:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80001894:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001898:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000189c:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800018a0:	0685bd83          	ld	s11,104(a1)
        
        ret
    800018a4:	8082                	ret

00000000800018a6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018a6:	1141                	addi	sp,sp,-16
    800018a8:	e406                	sd	ra,8(sp)
    800018aa:	e022                	sd	s0,0(sp)
    800018ac:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018ae:	00006597          	auipc	a1,0x6
    800018b2:	98258593          	addi	a1,a1,-1662 # 80007230 <states.1739+0x30>
    800018b6:	0000c517          	auipc	a0,0xc
    800018ba:	e3a50513          	addi	a0,a0,-454 # 8000d6f0 <tickslock>
    800018be:	6a3030ef          	jal	ra,80005760 <initlock>
}
    800018c2:	60a2                	ld	ra,8(sp)
    800018c4:	6402                	ld	s0,0(sp)
    800018c6:	0141                	addi	sp,sp,16
    800018c8:	8082                	ret

00000000800018ca <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018ca:	1141                	addi	sp,sp,-16
    800018cc:	e422                	sd	s0,8(sp)
    800018ce:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018d0:	00003797          	auipc	a5,0x3
    800018d4:	eb078793          	addi	a5,a5,-336 # 80004780 <kernelvec>
    800018d8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018dc:	6422                	ld	s0,8(sp)
    800018de:	0141                	addi	sp,sp,16
    800018e0:	8082                	ret

00000000800018e2 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800018e2:	1141                	addi	sp,sp,-16
    800018e4:	e406                	sd	ra,8(sp)
    800018e6:	e022                	sd	s0,0(sp)
    800018e8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018ea:	c4eff0ef          	jal	ra,80000d38 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018f2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018f4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018f8:	04000737          	lui	a4,0x4000
    800018fc:	00004797          	auipc	a5,0x4
    80001900:	70478793          	addi	a5,a5,1796 # 80006000 <_trampoline>
    80001904:	00004697          	auipc	a3,0x4
    80001908:	6fc68693          	addi	a3,a3,1788 # 80006000 <_trampoline>
    8000190c:	8f95                	sub	a5,a5,a3
    8000190e:	177d                	addi	a4,a4,-1
    80001910:	0732                	slli	a4,a4,0xc
    80001912:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001914:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001918:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000191a:	18002773          	csrr	a4,satp
    8000191e:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001920:	6d38                	ld	a4,88(a0)
    80001922:	613c                	ld	a5,64(a0)
    80001924:	6685                	lui	a3,0x1
    80001926:	97b6                	add	a5,a5,a3
    80001928:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000192a:	6d3c                	ld	a5,88(a0)
    8000192c:	00000717          	auipc	a4,0x0
    80001930:	0f470713          	addi	a4,a4,244 # 80001a20 <usertrap>
    80001934:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001936:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001938:	8712                	mv	a4,tp
    8000193a:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000193c:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001940:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001944:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001948:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000194c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000194e:	6f9c                	ld	a5,24(a5)
    80001950:	14179073          	csrw	sepc,a5
}
    80001954:	60a2                	ld	ra,8(sp)
    80001956:	6402                	ld	s0,0(sp)
    80001958:	0141                	addi	sp,sp,16
    8000195a:	8082                	ret

000000008000195c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000195c:	1101                	addi	sp,sp,-32
    8000195e:	ec06                	sd	ra,24(sp)
    80001960:	e822                	sd	s0,16(sp)
    80001962:	e426                	sd	s1,8(sp)
    80001964:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001966:	ba6ff0ef          	jal	ra,80000d0c <cpuid>
    8000196a:	cd19                	beqz	a0,80001988 <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000196c:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001970:	000f4737          	lui	a4,0xf4
    80001974:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001978:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000197a:	14d79073          	csrw	0x14d,a5
}
    8000197e:	60e2                	ld	ra,24(sp)
    80001980:	6442                	ld	s0,16(sp)
    80001982:	64a2                	ld	s1,8(sp)
    80001984:	6105                	addi	sp,sp,32
    80001986:	8082                	ret
    acquire(&tickslock);
    80001988:	0000c497          	auipc	s1,0xc
    8000198c:	d6848493          	addi	s1,s1,-664 # 8000d6f0 <tickslock>
    80001990:	8526                	mv	a0,s1
    80001992:	64f030ef          	jal	ra,800057e0 <acquire>
    ticks++;
    80001996:	00006517          	auipc	a0,0x6
    8000199a:	ef250513          	addi	a0,a0,-270 # 80007888 <ticks>
    8000199e:	411c                	lw	a5,0(a0)
    800019a0:	2785                	addiw	a5,a5,1
    800019a2:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800019a4:	9d3ff0ef          	jal	ra,80001376 <wakeup>
    release(&tickslock);
    800019a8:	8526                	mv	a0,s1
    800019aa:	6cf030ef          	jal	ra,80005878 <release>
    800019ae:	bf7d                	j	8000196c <clockintr+0x10>

00000000800019b0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019b0:	1101                	addi	sp,sp,-32
    800019b2:	ec06                	sd	ra,24(sp)
    800019b4:	e822                	sd	s0,16(sp)
    800019b6:	e426                	sd	s1,8(sp)
    800019b8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019ba:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019be:	57fd                	li	a5,-1
    800019c0:	17fe                	slli	a5,a5,0x3f
    800019c2:	07a5                	addi	a5,a5,9
    800019c4:	00f70d63          	beq	a4,a5,800019de <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019c8:	57fd                	li	a5,-1
    800019ca:	17fe                	slli	a5,a5,0x3f
    800019cc:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019ce:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019d0:	04f70463          	beq	a4,a5,80001a18 <devintr+0x68>
  }
}
    800019d4:	60e2                	ld	ra,24(sp)
    800019d6:	6442                	ld	s0,16(sp)
    800019d8:	64a2                	ld	s1,8(sp)
    800019da:	6105                	addi	sp,sp,32
    800019dc:	8082                	ret
    int irq = plic_claim();
    800019de:	64b020ef          	jal	ra,80004828 <plic_claim>
    800019e2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019e4:	47a9                	li	a5,10
    800019e6:	02f50363          	beq	a0,a5,80001a0c <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    800019ea:	4785                	li	a5,1
    800019ec:	02f50363          	beq	a0,a5,80001a12 <devintr+0x62>
    return 1;
    800019f0:	4505                	li	a0,1
    } else if(irq){
    800019f2:	d0ed                	beqz	s1,800019d4 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    800019f4:	85a6                	mv	a1,s1
    800019f6:	00006517          	auipc	a0,0x6
    800019fa:	84250513          	addi	a0,a0,-1982 # 80007238 <states.1739+0x38>
    800019fe:	063030ef          	jal	ra,80005260 <printf>
      plic_complete(irq);
    80001a02:	8526                	mv	a0,s1
    80001a04:	645020ef          	jal	ra,80004848 <plic_complete>
    return 1;
    80001a08:	4505                	li	a0,1
    80001a0a:	b7e9                	j	800019d4 <devintr+0x24>
      uartintr();
    80001a0c:	4ed030ef          	jal	ra,800056f8 <uartintr>
    80001a10:	bfcd                	j	80001a02 <devintr+0x52>
      virtio_disk_intr();
    80001a12:	2fc030ef          	jal	ra,80004d0e <virtio_disk_intr>
    80001a16:	b7f5                	j	80001a02 <devintr+0x52>
    clockintr();
    80001a18:	f45ff0ef          	jal	ra,8000195c <clockintr>
    return 2;
    80001a1c:	4509                	li	a0,2
    80001a1e:	bf5d                	j	800019d4 <devintr+0x24>

0000000080001a20 <usertrap>:
{
    80001a20:	1101                	addi	sp,sp,-32
    80001a22:	ec06                	sd	ra,24(sp)
    80001a24:	e822                	sd	s0,16(sp)
    80001a26:	e426                	sd	s1,8(sp)
    80001a28:	e04a                	sd	s2,0(sp)
    80001a2a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a2c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a30:	1007f793          	andi	a5,a5,256
    80001a34:	eba5                	bnez	a5,80001aa4 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a36:	00003797          	auipc	a5,0x3
    80001a3a:	d4a78793          	addi	a5,a5,-694 # 80004780 <kernelvec>
    80001a3e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a42:	af6ff0ef          	jal	ra,80000d38 <myproc>
    80001a46:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a48:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a4a:	14102773          	csrr	a4,sepc
    80001a4e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a50:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a54:	47a1                	li	a5,8
    80001a56:	04f70d63          	beq	a4,a5,80001ab0 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001a5a:	f57ff0ef          	jal	ra,800019b0 <devintr>
    80001a5e:	892a                	mv	s2,a0
    80001a60:	e945                	bnez	a0,80001b10 <usertrap+0xf0>
    80001a62:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001a66:	47bd                	li	a5,15
    80001a68:	08f70863          	beq	a4,a5,80001af8 <usertrap+0xd8>
    80001a6c:	14202773          	csrr	a4,scause
    80001a70:	47b5                	li	a5,13
    80001a72:	08f70363          	beq	a4,a5,80001af8 <usertrap+0xd8>
    80001a76:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a7a:	5890                	lw	a2,48(s1)
    80001a7c:	00005517          	auipc	a0,0x5
    80001a80:	7fc50513          	addi	a0,a0,2044 # 80007278 <states.1739+0x78>
    80001a84:	7dc030ef          	jal	ra,80005260 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a88:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a8c:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a90:	00006517          	auipc	a0,0x6
    80001a94:	81850513          	addi	a0,a0,-2024 # 800072a8 <states.1739+0xa8>
    80001a98:	7c8030ef          	jal	ra,80005260 <printf>
    setkilled(p);
    80001a9c:	8526                	mv	a0,s1
    80001a9e:	aa1ff0ef          	jal	ra,8000153e <setkilled>
    80001aa2:	a035                	j	80001ace <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001aa4:	00005517          	auipc	a0,0x5
    80001aa8:	7b450513          	addi	a0,a0,1972 # 80007258 <states.1739+0x58>
    80001aac:	27b030ef          	jal	ra,80005526 <panic>
    if(killed(p))
    80001ab0:	ab3ff0ef          	jal	ra,80001562 <killed>
    80001ab4:	ed15                	bnez	a0,80001af0 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001ab6:	6cb8                	ld	a4,88(s1)
    80001ab8:	6f1c                	ld	a5,24(a4)
    80001aba:	0791                	addi	a5,a5,4
    80001abc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001abe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ac2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac6:	10079073          	csrw	sstatus,a5
    syscall();
    80001aca:	246000ef          	jal	ra,80001d10 <syscall>
  if(killed(p))
    80001ace:	8526                	mv	a0,s1
    80001ad0:	a93ff0ef          	jal	ra,80001562 <killed>
    80001ad4:	e139                	bnez	a0,80001b1a <usertrap+0xfa>
  prepare_return();
    80001ad6:	e0dff0ef          	jal	ra,800018e2 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ada:	68a8                	ld	a0,80(s1)
    80001adc:	8131                	srli	a0,a0,0xc
    80001ade:	57fd                	li	a5,-1
    80001ae0:	17fe                	slli	a5,a5,0x3f
    80001ae2:	8d5d                	or	a0,a0,a5
}
    80001ae4:	60e2                	ld	ra,24(sp)
    80001ae6:	6442                	ld	s0,16(sp)
    80001ae8:	64a2                	ld	s1,8(sp)
    80001aea:	6902                	ld	s2,0(sp)
    80001aec:	6105                	addi	sp,sp,32
    80001aee:	8082                	ret
      kexit(-1);
    80001af0:	557d                	li	a0,-1
    80001af2:	945ff0ef          	jal	ra,80001436 <kexit>
    80001af6:	b7c1                	j	80001ab6 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001af8:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001afc:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001b00:	164d                	addi	a2,a2,-13
    80001b02:	00163613          	seqz	a2,a2
    80001b06:	68a8                	ld	a0,80(s1)
    80001b08:	f07fe0ef          	jal	ra,80000a0e <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b0c:	f169                	bnez	a0,80001ace <usertrap+0xae>
    80001b0e:	b7a5                	j	80001a76 <usertrap+0x56>
  if(killed(p))
    80001b10:	8526                	mv	a0,s1
    80001b12:	a51ff0ef          	jal	ra,80001562 <killed>
    80001b16:	c511                	beqz	a0,80001b22 <usertrap+0x102>
    80001b18:	a011                	j	80001b1c <usertrap+0xfc>
    80001b1a:	4901                	li	s2,0
    kexit(-1);
    80001b1c:	557d                	li	a0,-1
    80001b1e:	919ff0ef          	jal	ra,80001436 <kexit>
  if(which_dev == 2)
    80001b22:	4789                	li	a5,2
    80001b24:	faf919e3          	bne	s2,a5,80001ad6 <usertrap+0xb6>
    yield();
    80001b28:	fd6ff0ef          	jal	ra,800012fe <yield>
    80001b2c:	b76d                	j	80001ad6 <usertrap+0xb6>

0000000080001b2e <kerneltrap>:
{
    80001b2e:	7179                	addi	sp,sp,-48
    80001b30:	f406                	sd	ra,40(sp)
    80001b32:	f022                	sd	s0,32(sp)
    80001b34:	ec26                	sd	s1,24(sp)
    80001b36:	e84a                	sd	s2,16(sp)
    80001b38:	e44e                	sd	s3,8(sp)
    80001b3a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b3c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b40:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b44:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b48:	1004f793          	andi	a5,s1,256
    80001b4c:	c795                	beqz	a5,80001b78 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b52:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b54:	eb85                	bnez	a5,80001b84 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b56:	e5bff0ef          	jal	ra,800019b0 <devintr>
    80001b5a:	c91d                	beqz	a0,80001b90 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b5c:	4789                	li	a5,2
    80001b5e:	04f50a63          	beq	a0,a5,80001bb2 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b62:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b66:	10049073          	csrw	sstatus,s1
}
    80001b6a:	70a2                	ld	ra,40(sp)
    80001b6c:	7402                	ld	s0,32(sp)
    80001b6e:	64e2                	ld	s1,24(sp)
    80001b70:	6942                	ld	s2,16(sp)
    80001b72:	69a2                	ld	s3,8(sp)
    80001b74:	6145                	addi	sp,sp,48
    80001b76:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b78:	00005517          	auipc	a0,0x5
    80001b7c:	75850513          	addi	a0,a0,1880 # 800072d0 <states.1739+0xd0>
    80001b80:	1a7030ef          	jal	ra,80005526 <panic>
    panic("kerneltrap: interrupts enabled");
    80001b84:	00005517          	auipc	a0,0x5
    80001b88:	77450513          	addi	a0,a0,1908 # 800072f8 <states.1739+0xf8>
    80001b8c:	19b030ef          	jal	ra,80005526 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b90:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b94:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b98:	85ce                	mv	a1,s3
    80001b9a:	00005517          	auipc	a0,0x5
    80001b9e:	77e50513          	addi	a0,a0,1918 # 80007318 <states.1739+0x118>
    80001ba2:	6be030ef          	jal	ra,80005260 <printf>
    panic("kerneltrap");
    80001ba6:	00005517          	auipc	a0,0x5
    80001baa:	79a50513          	addi	a0,a0,1946 # 80007340 <states.1739+0x140>
    80001bae:	179030ef          	jal	ra,80005526 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001bb2:	986ff0ef          	jal	ra,80000d38 <myproc>
    80001bb6:	d555                	beqz	a0,80001b62 <kerneltrap+0x34>
    yield();
    80001bb8:	f46ff0ef          	jal	ra,800012fe <yield>
    80001bbc:	b75d                	j	80001b62 <kerneltrap+0x34>

0000000080001bbe <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001bbe:	1101                	addi	sp,sp,-32
    80001bc0:	ec06                	sd	ra,24(sp)
    80001bc2:	e822                	sd	s0,16(sp)
    80001bc4:	e426                	sd	s1,8(sp)
    80001bc6:	1000                	addi	s0,sp,32
    80001bc8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bca:	96eff0ef          	jal	ra,80000d38 <myproc>
  switch (n) {
    80001bce:	4795                	li	a5,5
    80001bd0:	0497e163          	bltu	a5,s1,80001c12 <argraw+0x54>
    80001bd4:	048a                	slli	s1,s1,0x2
    80001bd6:	00005717          	auipc	a4,0x5
    80001bda:	7a270713          	addi	a4,a4,1954 # 80007378 <states.1739+0x178>
    80001bde:	94ba                	add	s1,s1,a4
    80001be0:	409c                	lw	a5,0(s1)
    80001be2:	97ba                	add	a5,a5,a4
    80001be4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001be6:	6d3c                	ld	a5,88(a0)
    80001be8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001bea:	60e2                	ld	ra,24(sp)
    80001bec:	6442                	ld	s0,16(sp)
    80001bee:	64a2                	ld	s1,8(sp)
    80001bf0:	6105                	addi	sp,sp,32
    80001bf2:	8082                	ret
    return p->trapframe->a1;
    80001bf4:	6d3c                	ld	a5,88(a0)
    80001bf6:	7fa8                	ld	a0,120(a5)
    80001bf8:	bfcd                	j	80001bea <argraw+0x2c>
    return p->trapframe->a2;
    80001bfa:	6d3c                	ld	a5,88(a0)
    80001bfc:	63c8                	ld	a0,128(a5)
    80001bfe:	b7f5                	j	80001bea <argraw+0x2c>
    return p->trapframe->a3;
    80001c00:	6d3c                	ld	a5,88(a0)
    80001c02:	67c8                	ld	a0,136(a5)
    80001c04:	b7dd                	j	80001bea <argraw+0x2c>
    return p->trapframe->a4;
    80001c06:	6d3c                	ld	a5,88(a0)
    80001c08:	6bc8                	ld	a0,144(a5)
    80001c0a:	b7c5                	j	80001bea <argraw+0x2c>
    return p->trapframe->a5;
    80001c0c:	6d3c                	ld	a5,88(a0)
    80001c0e:	6fc8                	ld	a0,152(a5)
    80001c10:	bfe9                	j	80001bea <argraw+0x2c>
  panic("argraw");
    80001c12:	00005517          	auipc	a0,0x5
    80001c16:	73e50513          	addi	a0,a0,1854 # 80007350 <states.1739+0x150>
    80001c1a:	10d030ef          	jal	ra,80005526 <panic>

0000000080001c1e <fetchaddr>:
{
    80001c1e:	1101                	addi	sp,sp,-32
    80001c20:	ec06                	sd	ra,24(sp)
    80001c22:	e822                	sd	s0,16(sp)
    80001c24:	e426                	sd	s1,8(sp)
    80001c26:	e04a                	sd	s2,0(sp)
    80001c28:	1000                	addi	s0,sp,32
    80001c2a:	84aa                	mv	s1,a0
    80001c2c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c2e:	90aff0ef          	jal	ra,80000d38 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c32:	653c                	ld	a5,72(a0)
    80001c34:	02f4f663          	bgeu	s1,a5,80001c60 <fetchaddr+0x42>
    80001c38:	00848713          	addi	a4,s1,8
    80001c3c:	02e7e463          	bltu	a5,a4,80001c64 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c40:	46a1                	li	a3,8
    80001c42:	8626                	mv	a2,s1
    80001c44:	85ca                	mv	a1,s2
    80001c46:	6928                	ld	a0,80(a0)
    80001c48:	f05fe0ef          	jal	ra,80000b4c <copyin>
    80001c4c:	00a03533          	snez	a0,a0
    80001c50:	40a00533          	neg	a0,a0
}
    80001c54:	60e2                	ld	ra,24(sp)
    80001c56:	6442                	ld	s0,16(sp)
    80001c58:	64a2                	ld	s1,8(sp)
    80001c5a:	6902                	ld	s2,0(sp)
    80001c5c:	6105                	addi	sp,sp,32
    80001c5e:	8082                	ret
    return -1;
    80001c60:	557d                	li	a0,-1
    80001c62:	bfcd                	j	80001c54 <fetchaddr+0x36>
    80001c64:	557d                	li	a0,-1
    80001c66:	b7fd                	j	80001c54 <fetchaddr+0x36>

0000000080001c68 <fetchstr>:
{
    80001c68:	7179                	addi	sp,sp,-48
    80001c6a:	f406                	sd	ra,40(sp)
    80001c6c:	f022                	sd	s0,32(sp)
    80001c6e:	ec26                	sd	s1,24(sp)
    80001c70:	e84a                	sd	s2,16(sp)
    80001c72:	e44e                	sd	s3,8(sp)
    80001c74:	1800                	addi	s0,sp,48
    80001c76:	892a                	mv	s2,a0
    80001c78:	84ae                	mv	s1,a1
    80001c7a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c7c:	8bcff0ef          	jal	ra,80000d38 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c80:	86ce                	mv	a3,s3
    80001c82:	864a                	mv	a2,s2
    80001c84:	85a6                	mv	a1,s1
    80001c86:	6928                	ld	a0,80(a0)
    80001c88:	cb7fe0ef          	jal	ra,8000093e <copyinstr>
    80001c8c:	00054c63          	bltz	a0,80001ca4 <fetchstr+0x3c>
  return strlen(buf);
    80001c90:	8526                	mv	a0,s1
    80001c92:	e3afe0ef          	jal	ra,800002cc <strlen>
}
    80001c96:	70a2                	ld	ra,40(sp)
    80001c98:	7402                	ld	s0,32(sp)
    80001c9a:	64e2                	ld	s1,24(sp)
    80001c9c:	6942                	ld	s2,16(sp)
    80001c9e:	69a2                	ld	s3,8(sp)
    80001ca0:	6145                	addi	sp,sp,48
    80001ca2:	8082                	ret
    return -1;
    80001ca4:	557d                	li	a0,-1
    80001ca6:	bfc5                	j	80001c96 <fetchstr+0x2e>

0000000080001ca8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001ca8:	1101                	addi	sp,sp,-32
    80001caa:	ec06                	sd	ra,24(sp)
    80001cac:	e822                	sd	s0,16(sp)
    80001cae:	e426                	sd	s1,8(sp)
    80001cb0:	1000                	addi	s0,sp,32
    80001cb2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cb4:	f0bff0ef          	jal	ra,80001bbe <argraw>
    80001cb8:	c088                	sw	a0,0(s1)
}
    80001cba:	60e2                	ld	ra,24(sp)
    80001cbc:	6442                	ld	s0,16(sp)
    80001cbe:	64a2                	ld	s1,8(sp)
    80001cc0:	6105                	addi	sp,sp,32
    80001cc2:	8082                	ret

0000000080001cc4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cc4:	1101                	addi	sp,sp,-32
    80001cc6:	ec06                	sd	ra,24(sp)
    80001cc8:	e822                	sd	s0,16(sp)
    80001cca:	e426                	sd	s1,8(sp)
    80001ccc:	1000                	addi	s0,sp,32
    80001cce:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cd0:	eefff0ef          	jal	ra,80001bbe <argraw>
    80001cd4:	e088                	sd	a0,0(s1)
}
    80001cd6:	60e2                	ld	ra,24(sp)
    80001cd8:	6442                	ld	s0,16(sp)
    80001cda:	64a2                	ld	s1,8(sp)
    80001cdc:	6105                	addi	sp,sp,32
    80001cde:	8082                	ret

0000000080001ce0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001ce0:	7179                	addi	sp,sp,-48
    80001ce2:	f406                	sd	ra,40(sp)
    80001ce4:	f022                	sd	s0,32(sp)
    80001ce6:	ec26                	sd	s1,24(sp)
    80001ce8:	e84a                	sd	s2,16(sp)
    80001cea:	1800                	addi	s0,sp,48
    80001cec:	84ae                	mv	s1,a1
    80001cee:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001cf0:	fd840593          	addi	a1,s0,-40
    80001cf4:	fd1ff0ef          	jal	ra,80001cc4 <argaddr>
  return fetchstr(addr, buf, max);
    80001cf8:	864a                	mv	a2,s2
    80001cfa:	85a6                	mv	a1,s1
    80001cfc:	fd843503          	ld	a0,-40(s0)
    80001d00:	f69ff0ef          	jal	ra,80001c68 <fetchstr>
}
    80001d04:	70a2                	ld	ra,40(sp)
    80001d06:	7402                	ld	s0,32(sp)
    80001d08:	64e2                	ld	s1,24(sp)
    80001d0a:	6942                	ld	s2,16(sp)
    80001d0c:	6145                	addi	sp,sp,48
    80001d0e:	8082                	ret

0000000080001d10 <syscall>:
[SYS_getproctree]   sys_getproctree,
};

void
syscall(void)
{
    80001d10:	1101                	addi	sp,sp,-32
    80001d12:	ec06                	sd	ra,24(sp)
    80001d14:	e822                	sd	s0,16(sp)
    80001d16:	e426                	sd	s1,8(sp)
    80001d18:	e04a                	sd	s2,0(sp)
    80001d1a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001d1c:	81cff0ef          	jal	ra,80000d38 <myproc>
    80001d20:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d22:	05853903          	ld	s2,88(a0)
    80001d26:	0a893783          	ld	a5,168(s2)
    80001d2a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d2e:	37fd                	addiw	a5,a5,-1
    80001d30:	4755                	li	a4,21
    80001d32:	00f76f63          	bltu	a4,a5,80001d50 <syscall+0x40>
    80001d36:	00369713          	slli	a4,a3,0x3
    80001d3a:	00005797          	auipc	a5,0x5
    80001d3e:	65678793          	addi	a5,a5,1622 # 80007390 <syscalls>
    80001d42:	97ba                	add	a5,a5,a4
    80001d44:	639c                	ld	a5,0(a5)
    80001d46:	c789                	beqz	a5,80001d50 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d48:	9782                	jalr	a5
    80001d4a:	06a93823          	sd	a0,112(s2)
    80001d4e:	a829                	j	80001d68 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d50:	15848613          	addi	a2,s1,344
    80001d54:	588c                	lw	a1,48(s1)
    80001d56:	00005517          	auipc	a0,0x5
    80001d5a:	60250513          	addi	a0,a0,1538 # 80007358 <states.1739+0x158>
    80001d5e:	502030ef          	jal	ra,80005260 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d62:	6cbc                	ld	a5,88(s1)
    80001d64:	577d                	li	a4,-1
    80001d66:	fbb8                	sd	a4,112(a5)
  }
}
    80001d68:	60e2                	ld	ra,24(sp)
    80001d6a:	6442                	ld	s0,16(sp)
    80001d6c:	64a2                	ld	s1,8(sp)
    80001d6e:	6902                	ld	s2,0(sp)
    80001d70:	6105                	addi	sp,sp,32
    80001d72:	8082                	ret

0000000080001d74 <sys_exit>:
#include "vm.h"
#include "user/proc_info.h"

uint64
sys_exit(void)
{
    80001d74:	1101                	addi	sp,sp,-32
    80001d76:	ec06                	sd	ra,24(sp)
    80001d78:	e822                	sd	s0,16(sp)
    80001d7a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d7c:	fec40593          	addi	a1,s0,-20
    80001d80:	4501                	li	a0,0
    80001d82:	f27ff0ef          	jal	ra,80001ca8 <argint>
  kexit(n);
    80001d86:	fec42503          	lw	a0,-20(s0)
    80001d8a:	eacff0ef          	jal	ra,80001436 <kexit>
  return 0;  // not reached
}
    80001d8e:	4501                	li	a0,0
    80001d90:	60e2                	ld	ra,24(sp)
    80001d92:	6442                	ld	s0,16(sp)
    80001d94:	6105                	addi	sp,sp,32
    80001d96:	8082                	ret

0000000080001d98 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d98:	1141                	addi	sp,sp,-16
    80001d9a:	e406                	sd	ra,8(sp)
    80001d9c:	e022                	sd	s0,0(sp)
    80001d9e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001da0:	f99fe0ef          	jal	ra,80000d38 <myproc>
}
    80001da4:	5908                	lw	a0,48(a0)
    80001da6:	60a2                	ld	ra,8(sp)
    80001da8:	6402                	ld	s0,0(sp)
    80001daa:	0141                	addi	sp,sp,16
    80001dac:	8082                	ret

0000000080001dae <sys_fork>:

uint64
sys_fork(void)
{
    80001dae:	1141                	addi	sp,sp,-16
    80001db0:	e406                	sd	ra,8(sp)
    80001db2:	e022                	sd	s0,0(sp)
    80001db4:	0800                	addi	s0,sp,16
  return kfork();
    80001db6:	ad4ff0ef          	jal	ra,8000108a <kfork>
}
    80001dba:	60a2                	ld	ra,8(sp)
    80001dbc:	6402                	ld	s0,0(sp)
    80001dbe:	0141                	addi	sp,sp,16
    80001dc0:	8082                	ret

0000000080001dc2 <sys_wait>:

uint64
sys_wait(void)
{
    80001dc2:	1101                	addi	sp,sp,-32
    80001dc4:	ec06                	sd	ra,24(sp)
    80001dc6:	e822                	sd	s0,16(sp)
    80001dc8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001dca:	fe840593          	addi	a1,s0,-24
    80001dce:	4501                	li	a0,0
    80001dd0:	ef5ff0ef          	jal	ra,80001cc4 <argaddr>
  return kwait(p);
    80001dd4:	fe843503          	ld	a0,-24(s0)
    80001dd8:	fb4ff0ef          	jal	ra,8000158c <kwait>
}
    80001ddc:	60e2                	ld	ra,24(sp)
    80001dde:	6442                	ld	s0,16(sp)
    80001de0:	6105                	addi	sp,sp,32
    80001de2:	8082                	ret

0000000080001de4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001de4:	7179                	addi	sp,sp,-48
    80001de6:	f406                	sd	ra,40(sp)
    80001de8:	f022                	sd	s0,32(sp)
    80001dea:	ec26                	sd	s1,24(sp)
    80001dec:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001dee:	fd840593          	addi	a1,s0,-40
    80001df2:	4501                	li	a0,0
    80001df4:	eb5ff0ef          	jal	ra,80001ca8 <argint>
  argint(1, &t);
    80001df8:	fdc40593          	addi	a1,s0,-36
    80001dfc:	4505                	li	a0,1
    80001dfe:	eabff0ef          	jal	ra,80001ca8 <argint>
  addr = myproc()->sz;
    80001e02:	f37fe0ef          	jal	ra,80000d38 <myproc>
    80001e06:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80001e08:	fdc42703          	lw	a4,-36(s0)
    80001e0c:	4785                	li	a5,1
    80001e0e:	02f70163          	beq	a4,a5,80001e30 <sys_sbrk+0x4c>
    80001e12:	fd842783          	lw	a5,-40(s0)
    80001e16:	0007cd63          	bltz	a5,80001e30 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80001e1a:	97a6                	add	a5,a5,s1
    80001e1c:	0297e863          	bltu	a5,s1,80001e4c <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001e20:	f19fe0ef          	jal	ra,80000d38 <myproc>
    80001e24:	fd842703          	lw	a4,-40(s0)
    80001e28:	653c                	ld	a5,72(a0)
    80001e2a:	97ba                	add	a5,a5,a4
    80001e2c:	e53c                	sd	a5,72(a0)
    80001e2e:	a039                	j	80001e3c <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80001e30:	fd842503          	lw	a0,-40(s0)
    80001e34:	a06ff0ef          	jal	ra,8000103a <growproc>
    80001e38:	00054863          	bltz	a0,80001e48 <sys_sbrk+0x64>
  }
  return addr;
}
    80001e3c:	8526                	mv	a0,s1
    80001e3e:	70a2                	ld	ra,40(sp)
    80001e40:	7402                	ld	s0,32(sp)
    80001e42:	64e2                	ld	s1,24(sp)
    80001e44:	6145                	addi	sp,sp,48
    80001e46:	8082                	ret
      return -1;
    80001e48:	54fd                	li	s1,-1
    80001e4a:	bfcd                	j	80001e3c <sys_sbrk+0x58>
      return -1;
    80001e4c:	54fd                	li	s1,-1
    80001e4e:	b7fd                	j	80001e3c <sys_sbrk+0x58>

0000000080001e50 <sys_pause>:

uint64
sys_pause(void)
{
    80001e50:	7139                	addi	sp,sp,-64
    80001e52:	fc06                	sd	ra,56(sp)
    80001e54:	f822                	sd	s0,48(sp)
    80001e56:	f426                	sd	s1,40(sp)
    80001e58:	f04a                	sd	s2,32(sp)
    80001e5a:	ec4e                	sd	s3,24(sp)
    80001e5c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e5e:	fcc40593          	addi	a1,s0,-52
    80001e62:	4501                	li	a0,0
    80001e64:	e45ff0ef          	jal	ra,80001ca8 <argint>
  if(n < 0)
    80001e68:	fcc42783          	lw	a5,-52(s0)
    80001e6c:	0607c563          	bltz	a5,80001ed6 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80001e70:	0000c517          	auipc	a0,0xc
    80001e74:	88050513          	addi	a0,a0,-1920 # 8000d6f0 <tickslock>
    80001e78:	169030ef          	jal	ra,800057e0 <acquire>
  ticks0 = ticks;
    80001e7c:	00006917          	auipc	s2,0x6
    80001e80:	a0c92903          	lw	s2,-1524(s2) # 80007888 <ticks>
  while(ticks - ticks0 < n){
    80001e84:	fcc42783          	lw	a5,-52(s0)
    80001e88:	cb8d                	beqz	a5,80001eba <sys_pause+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e8a:	0000c997          	auipc	s3,0xc
    80001e8e:	86698993          	addi	s3,s3,-1946 # 8000d6f0 <tickslock>
    80001e92:	00006497          	auipc	s1,0x6
    80001e96:	9f648493          	addi	s1,s1,-1546 # 80007888 <ticks>
    if(killed(myproc())){
    80001e9a:	e9ffe0ef          	jal	ra,80000d38 <myproc>
    80001e9e:	ec4ff0ef          	jal	ra,80001562 <killed>
    80001ea2:	ed0d                	bnez	a0,80001edc <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80001ea4:	85ce                	mv	a1,s3
    80001ea6:	8526                	mv	a0,s1
    80001ea8:	c82ff0ef          	jal	ra,8000132a <sleep>
  while(ticks - ticks0 < n){
    80001eac:	409c                	lw	a5,0(s1)
    80001eae:	412787bb          	subw	a5,a5,s2
    80001eb2:	fcc42703          	lw	a4,-52(s0)
    80001eb6:	fee7e2e3          	bltu	a5,a4,80001e9a <sys_pause+0x4a>
  }
  release(&tickslock);
    80001eba:	0000c517          	auipc	a0,0xc
    80001ebe:	83650513          	addi	a0,a0,-1994 # 8000d6f0 <tickslock>
    80001ec2:	1b7030ef          	jal	ra,80005878 <release>
  return 0;
    80001ec6:	4501                	li	a0,0
}
    80001ec8:	70e2                	ld	ra,56(sp)
    80001eca:	7442                	ld	s0,48(sp)
    80001ecc:	74a2                	ld	s1,40(sp)
    80001ece:	7902                	ld	s2,32(sp)
    80001ed0:	69e2                	ld	s3,24(sp)
    80001ed2:	6121                	addi	sp,sp,64
    80001ed4:	8082                	ret
    n = 0;
    80001ed6:	fc042623          	sw	zero,-52(s0)
    80001eda:	bf59                	j	80001e70 <sys_pause+0x20>
      release(&tickslock);
    80001edc:	0000c517          	auipc	a0,0xc
    80001ee0:	81450513          	addi	a0,a0,-2028 # 8000d6f0 <tickslock>
    80001ee4:	195030ef          	jal	ra,80005878 <release>
      return -1;
    80001ee8:	557d                	li	a0,-1
    80001eea:	bff9                	j	80001ec8 <sys_pause+0x78>

0000000080001eec <sys_kill>:

uint64
sys_kill(void)
{
    80001eec:	1101                	addi	sp,sp,-32
    80001eee:	ec06                	sd	ra,24(sp)
    80001ef0:	e822                	sd	s0,16(sp)
    80001ef2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001ef4:	fec40593          	addi	a1,s0,-20
    80001ef8:	4501                	li	a0,0
    80001efa:	dafff0ef          	jal	ra,80001ca8 <argint>
  return kkill(pid);
    80001efe:	fec42503          	lw	a0,-20(s0)
    80001f02:	dd6ff0ef          	jal	ra,800014d8 <kkill>
}
    80001f06:	60e2                	ld	ra,24(sp)
    80001f08:	6442                	ld	s0,16(sp)
    80001f0a:	6105                	addi	sp,sp,32
    80001f0c:	8082                	ret

0000000080001f0e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f0e:	1101                	addi	sp,sp,-32
    80001f10:	ec06                	sd	ra,24(sp)
    80001f12:	e822                	sd	s0,16(sp)
    80001f14:	e426                	sd	s1,8(sp)
    80001f16:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f18:	0000b517          	auipc	a0,0xb
    80001f1c:	7d850513          	addi	a0,a0,2008 # 8000d6f0 <tickslock>
    80001f20:	0c1030ef          	jal	ra,800057e0 <acquire>
  xticks = ticks;
    80001f24:	00006497          	auipc	s1,0x6
    80001f28:	9644a483          	lw	s1,-1692(s1) # 80007888 <ticks>
  release(&tickslock);
    80001f2c:	0000b517          	auipc	a0,0xb
    80001f30:	7c450513          	addi	a0,a0,1988 # 8000d6f0 <tickslock>
    80001f34:	145030ef          	jal	ra,80005878 <release>
  return xticks;
}
    80001f38:	02049513          	slli	a0,s1,0x20
    80001f3c:	9101                	srli	a0,a0,0x20
    80001f3e:	60e2                	ld	ra,24(sp)
    80001f40:	6442                	ld	s0,16(sp)
    80001f42:	64a2                	ld	s1,8(sp)
    80001f44:	6105                	addi	sp,sp,32
    80001f46:	8082                	ret

0000000080001f48 <sys_getproctree>:

// Inside kernel/sysproc.c (The System Call Wrapper)
uint64
sys_getproctree(void)
{
    80001f48:	9d010113          	addi	sp,sp,-1584
    80001f4c:	62113423          	sd	ra,1576(sp)
    80001f50:	62813023          	sd	s0,1568(sp)
    80001f54:	60913c23          	sd	s1,1560(sp)
    80001f58:	61213823          	sd	s2,1552(sp)
    80001f5c:	63010413          	addi	s0,sp,1584
  uint64 u_array; // User-space address
  struct proc_info k_array[NPROC]; // Temporary kernel buffer

  // Get the pointer passed from User Space
  argaddr(0, &u_array);
    80001f60:	fd840593          	addi	a1,s0,-40
    80001f64:	4501                	li	a0,0
    80001f66:	d5fff0ef          	jal	ra,80001cc4 <argaddr>

  // Call the helper function to fill k_array
  int count = get_proc_tree_data(k_array);
    80001f6a:	9d840513          	addi	a0,s0,-1576
    80001f6e:	84fff0ef          	jal	ra,800017bc <get_proc_tree_data>
    80001f72:	84aa                	mv	s1,a0

  // Safely copy the WHOLE array back to User Space
  if(copyout(myproc()->pagetable, u_array, (char *)k_array, count * sizeof(struct proc_info)) < 0)
    80001f74:	dc5fe0ef          	jal	ra,80000d38 <myproc>
    80001f78:	8926                	mv	s2,s1
    80001f7a:	00149693          	slli	a3,s1,0x1
    80001f7e:	96a6                	add	a3,a3,s1
    80001f80:	068e                	slli	a3,a3,0x3
    80001f82:	9d840613          	addi	a2,s0,-1576
    80001f86:	fd843583          	ld	a1,-40(s0)
    80001f8a:	6928                	ld	a0,80(a0)
    80001f8c:	af5fe0ef          	jal	ra,80000a80 <copyout>
    80001f90:	00054e63          	bltz	a0,80001fac <sys_getproctree+0x64>
    return -1;

  return count;
}
    80001f94:	854a                	mv	a0,s2
    80001f96:	62813083          	ld	ra,1576(sp)
    80001f9a:	62013403          	ld	s0,1568(sp)
    80001f9e:	61813483          	ld	s1,1560(sp)
    80001fa2:	61013903          	ld	s2,1552(sp)
    80001fa6:	63010113          	addi	sp,sp,1584
    80001faa:	8082                	ret
    return -1;
    80001fac:	597d                	li	s2,-1
    80001fae:	b7dd                	j	80001f94 <sys_getproctree+0x4c>

0000000080001fb0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001fb0:	7179                	addi	sp,sp,-48
    80001fb2:	f406                	sd	ra,40(sp)
    80001fb4:	f022                	sd	s0,32(sp)
    80001fb6:	ec26                	sd	s1,24(sp)
    80001fb8:	e84a                	sd	s2,16(sp)
    80001fba:	e44e                	sd	s3,8(sp)
    80001fbc:	e052                	sd	s4,0(sp)
    80001fbe:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001fc0:	00005597          	auipc	a1,0x5
    80001fc4:	48858593          	addi	a1,a1,1160 # 80007448 <syscalls+0xb8>
    80001fc8:	0000b517          	auipc	a0,0xb
    80001fcc:	74050513          	addi	a0,a0,1856 # 8000d708 <bcache>
    80001fd0:	790030ef          	jal	ra,80005760 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001fd4:	00013797          	auipc	a5,0x13
    80001fd8:	73478793          	addi	a5,a5,1844 # 80015708 <bcache+0x8000>
    80001fdc:	00014717          	auipc	a4,0x14
    80001fe0:	99470713          	addi	a4,a4,-1644 # 80015970 <bcache+0x8268>
    80001fe4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001fe8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fec:	0000b497          	auipc	s1,0xb
    80001ff0:	73448493          	addi	s1,s1,1844 # 8000d720 <bcache+0x18>
    b->next = bcache.head.next;
    80001ff4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001ff6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001ff8:	00005a17          	auipc	s4,0x5
    80001ffc:	458a0a13          	addi	s4,s4,1112 # 80007450 <syscalls+0xc0>
    b->next = bcache.head.next;
    80002000:	2b893783          	ld	a5,696(s2)
    80002004:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002006:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000200a:	85d2                	mv	a1,s4
    8000200c:	01048513          	addi	a0,s1,16
    80002010:	2fe010ef          	jal	ra,8000330e <initsleeplock>
    bcache.head.next->prev = b;
    80002014:	2b893783          	ld	a5,696(s2)
    80002018:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000201a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000201e:	45848493          	addi	s1,s1,1112
    80002022:	fd349fe3          	bne	s1,s3,80002000 <binit+0x50>
  }
}
    80002026:	70a2                	ld	ra,40(sp)
    80002028:	7402                	ld	s0,32(sp)
    8000202a:	64e2                	ld	s1,24(sp)
    8000202c:	6942                	ld	s2,16(sp)
    8000202e:	69a2                	ld	s3,8(sp)
    80002030:	6a02                	ld	s4,0(sp)
    80002032:	6145                	addi	sp,sp,48
    80002034:	8082                	ret

0000000080002036 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002036:	7179                	addi	sp,sp,-48
    80002038:	f406                	sd	ra,40(sp)
    8000203a:	f022                	sd	s0,32(sp)
    8000203c:	ec26                	sd	s1,24(sp)
    8000203e:	e84a                	sd	s2,16(sp)
    80002040:	e44e                	sd	s3,8(sp)
    80002042:	1800                	addi	s0,sp,48
    80002044:	89aa                	mv	s3,a0
    80002046:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002048:	0000b517          	auipc	a0,0xb
    8000204c:	6c050513          	addi	a0,a0,1728 # 8000d708 <bcache>
    80002050:	790030ef          	jal	ra,800057e0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002054:	00014497          	auipc	s1,0x14
    80002058:	96c4b483          	ld	s1,-1684(s1) # 800159c0 <bcache+0x82b8>
    8000205c:	00014797          	auipc	a5,0x14
    80002060:	91478793          	addi	a5,a5,-1772 # 80015970 <bcache+0x8268>
    80002064:	02f48b63          	beq	s1,a5,8000209a <bread+0x64>
    80002068:	873e                	mv	a4,a5
    8000206a:	a021                	j	80002072 <bread+0x3c>
    8000206c:	68a4                	ld	s1,80(s1)
    8000206e:	02e48663          	beq	s1,a4,8000209a <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002072:	449c                	lw	a5,8(s1)
    80002074:	ff379ce3          	bne	a5,s3,8000206c <bread+0x36>
    80002078:	44dc                	lw	a5,12(s1)
    8000207a:	ff2799e3          	bne	a5,s2,8000206c <bread+0x36>
      b->refcnt++;
    8000207e:	40bc                	lw	a5,64(s1)
    80002080:	2785                	addiw	a5,a5,1
    80002082:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002084:	0000b517          	auipc	a0,0xb
    80002088:	68450513          	addi	a0,a0,1668 # 8000d708 <bcache>
    8000208c:	7ec030ef          	jal	ra,80005878 <release>
      acquiresleep(&b->lock);
    80002090:	01048513          	addi	a0,s1,16
    80002094:	2b0010ef          	jal	ra,80003344 <acquiresleep>
      return b;
    80002098:	a889                	j	800020ea <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000209a:	00014497          	auipc	s1,0x14
    8000209e:	91e4b483          	ld	s1,-1762(s1) # 800159b8 <bcache+0x82b0>
    800020a2:	00014797          	auipc	a5,0x14
    800020a6:	8ce78793          	addi	a5,a5,-1842 # 80015970 <bcache+0x8268>
    800020aa:	00f48863          	beq	s1,a5,800020ba <bread+0x84>
    800020ae:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800020b0:	40bc                	lw	a5,64(s1)
    800020b2:	cb91                	beqz	a5,800020c6 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020b4:	64a4                	ld	s1,72(s1)
    800020b6:	fee49de3          	bne	s1,a4,800020b0 <bread+0x7a>
  panic("bget: no buffers");
    800020ba:	00005517          	auipc	a0,0x5
    800020be:	39e50513          	addi	a0,a0,926 # 80007458 <syscalls+0xc8>
    800020c2:	464030ef          	jal	ra,80005526 <panic>
      b->dev = dev;
    800020c6:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800020ca:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800020ce:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800020d2:	4785                	li	a5,1
    800020d4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020d6:	0000b517          	auipc	a0,0xb
    800020da:	63250513          	addi	a0,a0,1586 # 8000d708 <bcache>
    800020de:	79a030ef          	jal	ra,80005878 <release>
      acquiresleep(&b->lock);
    800020e2:	01048513          	addi	a0,s1,16
    800020e6:	25e010ef          	jal	ra,80003344 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800020ea:	409c                	lw	a5,0(s1)
    800020ec:	cb89                	beqz	a5,800020fe <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800020ee:	8526                	mv	a0,s1
    800020f0:	70a2                	ld	ra,40(sp)
    800020f2:	7402                	ld	s0,32(sp)
    800020f4:	64e2                	ld	s1,24(sp)
    800020f6:	6942                	ld	s2,16(sp)
    800020f8:	69a2                	ld	s3,8(sp)
    800020fa:	6145                	addi	sp,sp,48
    800020fc:	8082                	ret
    virtio_disk_rw(b, 0);
    800020fe:	4581                	li	a1,0
    80002100:	8526                	mv	a0,s1
    80002102:	19f020ef          	jal	ra,80004aa0 <virtio_disk_rw>
    b->valid = 1;
    80002106:	4785                	li	a5,1
    80002108:	c09c                	sw	a5,0(s1)
  return b;
    8000210a:	b7d5                	j	800020ee <bread+0xb8>

000000008000210c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000210c:	1101                	addi	sp,sp,-32
    8000210e:	ec06                	sd	ra,24(sp)
    80002110:	e822                	sd	s0,16(sp)
    80002112:	e426                	sd	s1,8(sp)
    80002114:	1000                	addi	s0,sp,32
    80002116:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002118:	0541                	addi	a0,a0,16
    8000211a:	2a8010ef          	jal	ra,800033c2 <holdingsleep>
    8000211e:	c911                	beqz	a0,80002132 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002120:	4585                	li	a1,1
    80002122:	8526                	mv	a0,s1
    80002124:	17d020ef          	jal	ra,80004aa0 <virtio_disk_rw>
}
    80002128:	60e2                	ld	ra,24(sp)
    8000212a:	6442                	ld	s0,16(sp)
    8000212c:	64a2                	ld	s1,8(sp)
    8000212e:	6105                	addi	sp,sp,32
    80002130:	8082                	ret
    panic("bwrite");
    80002132:	00005517          	auipc	a0,0x5
    80002136:	33e50513          	addi	a0,a0,830 # 80007470 <syscalls+0xe0>
    8000213a:	3ec030ef          	jal	ra,80005526 <panic>

000000008000213e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000213e:	1101                	addi	sp,sp,-32
    80002140:	ec06                	sd	ra,24(sp)
    80002142:	e822                	sd	s0,16(sp)
    80002144:	e426                	sd	s1,8(sp)
    80002146:	e04a                	sd	s2,0(sp)
    80002148:	1000                	addi	s0,sp,32
    8000214a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000214c:	01050913          	addi	s2,a0,16
    80002150:	854a                	mv	a0,s2
    80002152:	270010ef          	jal	ra,800033c2 <holdingsleep>
    80002156:	c13d                	beqz	a0,800021bc <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    80002158:	854a                	mv	a0,s2
    8000215a:	230010ef          	jal	ra,8000338a <releasesleep>

  acquire(&bcache.lock);
    8000215e:	0000b517          	auipc	a0,0xb
    80002162:	5aa50513          	addi	a0,a0,1450 # 8000d708 <bcache>
    80002166:	67a030ef          	jal	ra,800057e0 <acquire>
  b->refcnt--;
    8000216a:	40bc                	lw	a5,64(s1)
    8000216c:	37fd                	addiw	a5,a5,-1
    8000216e:	0007871b          	sext.w	a4,a5
    80002172:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002174:	eb05                	bnez	a4,800021a4 <brelse+0x66>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002176:	68bc                	ld	a5,80(s1)
    80002178:	64b8                	ld	a4,72(s1)
    8000217a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000217c:	64bc                	ld	a5,72(s1)
    8000217e:	68b8                	ld	a4,80(s1)
    80002180:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002182:	00013797          	auipc	a5,0x13
    80002186:	58678793          	addi	a5,a5,1414 # 80015708 <bcache+0x8000>
    8000218a:	2b87b703          	ld	a4,696(a5)
    8000218e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002190:	00013717          	auipc	a4,0x13
    80002194:	7e070713          	addi	a4,a4,2016 # 80015970 <bcache+0x8268>
    80002198:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000219a:	2b87b703          	ld	a4,696(a5)
    8000219e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800021a0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800021a4:	0000b517          	auipc	a0,0xb
    800021a8:	56450513          	addi	a0,a0,1380 # 8000d708 <bcache>
    800021ac:	6cc030ef          	jal	ra,80005878 <release>
}
    800021b0:	60e2                	ld	ra,24(sp)
    800021b2:	6442                	ld	s0,16(sp)
    800021b4:	64a2                	ld	s1,8(sp)
    800021b6:	6902                	ld	s2,0(sp)
    800021b8:	6105                	addi	sp,sp,32
    800021ba:	8082                	ret
    panic("brelse");
    800021bc:	00005517          	auipc	a0,0x5
    800021c0:	2bc50513          	addi	a0,a0,700 # 80007478 <syscalls+0xe8>
    800021c4:	362030ef          	jal	ra,80005526 <panic>

00000000800021c8 <bpin>:

void
bpin(struct buf *b) {
    800021c8:	1101                	addi	sp,sp,-32
    800021ca:	ec06                	sd	ra,24(sp)
    800021cc:	e822                	sd	s0,16(sp)
    800021ce:	e426                	sd	s1,8(sp)
    800021d0:	1000                	addi	s0,sp,32
    800021d2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021d4:	0000b517          	auipc	a0,0xb
    800021d8:	53450513          	addi	a0,a0,1332 # 8000d708 <bcache>
    800021dc:	604030ef          	jal	ra,800057e0 <acquire>
  b->refcnt++;
    800021e0:	40bc                	lw	a5,64(s1)
    800021e2:	2785                	addiw	a5,a5,1
    800021e4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021e6:	0000b517          	auipc	a0,0xb
    800021ea:	52250513          	addi	a0,a0,1314 # 8000d708 <bcache>
    800021ee:	68a030ef          	jal	ra,80005878 <release>
}
    800021f2:	60e2                	ld	ra,24(sp)
    800021f4:	6442                	ld	s0,16(sp)
    800021f6:	64a2                	ld	s1,8(sp)
    800021f8:	6105                	addi	sp,sp,32
    800021fa:	8082                	ret

00000000800021fc <bunpin>:

void
bunpin(struct buf *b) {
    800021fc:	1101                	addi	sp,sp,-32
    800021fe:	ec06                	sd	ra,24(sp)
    80002200:	e822                	sd	s0,16(sp)
    80002202:	e426                	sd	s1,8(sp)
    80002204:	1000                	addi	s0,sp,32
    80002206:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002208:	0000b517          	auipc	a0,0xb
    8000220c:	50050513          	addi	a0,a0,1280 # 8000d708 <bcache>
    80002210:	5d0030ef          	jal	ra,800057e0 <acquire>
  b->refcnt--;
    80002214:	40bc                	lw	a5,64(s1)
    80002216:	37fd                	addiw	a5,a5,-1
    80002218:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000221a:	0000b517          	auipc	a0,0xb
    8000221e:	4ee50513          	addi	a0,a0,1262 # 8000d708 <bcache>
    80002222:	656030ef          	jal	ra,80005878 <release>
}
    80002226:	60e2                	ld	ra,24(sp)
    80002228:	6442                	ld	s0,16(sp)
    8000222a:	64a2                	ld	s1,8(sp)
    8000222c:	6105                	addi	sp,sp,32
    8000222e:	8082                	ret

0000000080002230 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002230:	1101                	addi	sp,sp,-32
    80002232:	ec06                	sd	ra,24(sp)
    80002234:	e822                	sd	s0,16(sp)
    80002236:	e426                	sd	s1,8(sp)
    80002238:	e04a                	sd	s2,0(sp)
    8000223a:	1000                	addi	s0,sp,32
    8000223c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000223e:	00d5d59b          	srliw	a1,a1,0xd
    80002242:	00014797          	auipc	a5,0x14
    80002246:	ba27a783          	lw	a5,-1118(a5) # 80015de4 <sb+0x1c>
    8000224a:	9dbd                	addw	a1,a1,a5
    8000224c:	debff0ef          	jal	ra,80002036 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002250:	0074f713          	andi	a4,s1,7
    80002254:	4785                	li	a5,1
    80002256:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000225a:	14ce                	slli	s1,s1,0x33
    8000225c:	90d9                	srli	s1,s1,0x36
    8000225e:	00950733          	add	a4,a0,s1
    80002262:	05874703          	lbu	a4,88(a4)
    80002266:	00e7f6b3          	and	a3,a5,a4
    8000226a:	c29d                	beqz	a3,80002290 <bfree+0x60>
    8000226c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000226e:	94aa                	add	s1,s1,a0
    80002270:	fff7c793          	not	a5,a5
    80002274:	8ff9                	and	a5,a5,a4
    80002276:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000227a:	7d1000ef          	jal	ra,8000324a <log_write>
  brelse(bp);
    8000227e:	854a                	mv	a0,s2
    80002280:	ebfff0ef          	jal	ra,8000213e <brelse>
}
    80002284:	60e2                	ld	ra,24(sp)
    80002286:	6442                	ld	s0,16(sp)
    80002288:	64a2                	ld	s1,8(sp)
    8000228a:	6902                	ld	s2,0(sp)
    8000228c:	6105                	addi	sp,sp,32
    8000228e:	8082                	ret
    panic("freeing free block");
    80002290:	00005517          	auipc	a0,0x5
    80002294:	1f050513          	addi	a0,a0,496 # 80007480 <syscalls+0xf0>
    80002298:	28e030ef          	jal	ra,80005526 <panic>

000000008000229c <balloc>:
{
    8000229c:	711d                	addi	sp,sp,-96
    8000229e:	ec86                	sd	ra,88(sp)
    800022a0:	e8a2                	sd	s0,80(sp)
    800022a2:	e4a6                	sd	s1,72(sp)
    800022a4:	e0ca                	sd	s2,64(sp)
    800022a6:	fc4e                	sd	s3,56(sp)
    800022a8:	f852                	sd	s4,48(sp)
    800022aa:	f456                	sd	s5,40(sp)
    800022ac:	f05a                	sd	s6,32(sp)
    800022ae:	ec5e                	sd	s7,24(sp)
    800022b0:	e862                	sd	s8,16(sp)
    800022b2:	e466                	sd	s9,8(sp)
    800022b4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800022b6:	00014797          	auipc	a5,0x14
    800022ba:	b167a783          	lw	a5,-1258(a5) # 80015dcc <sb+0x4>
    800022be:	0e078163          	beqz	a5,800023a0 <balloc+0x104>
    800022c2:	8baa                	mv	s7,a0
    800022c4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800022c6:	00014b17          	auipc	s6,0x14
    800022ca:	b02b0b13          	addi	s6,s6,-1278 # 80015dc8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022ce:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800022d0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022d2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800022d4:	6c89                	lui	s9,0x2
    800022d6:	a0b5                	j	80002342 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800022d8:	974a                	add	a4,a4,s2
    800022da:	8fd5                	or	a5,a5,a3
    800022dc:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800022e0:	854a                	mv	a0,s2
    800022e2:	769000ef          	jal	ra,8000324a <log_write>
        brelse(bp);
    800022e6:	854a                	mv	a0,s2
    800022e8:	e57ff0ef          	jal	ra,8000213e <brelse>
  bp = bread(dev, bno);
    800022ec:	85a6                	mv	a1,s1
    800022ee:	855e                	mv	a0,s7
    800022f0:	d47ff0ef          	jal	ra,80002036 <bread>
    800022f4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800022f6:	40000613          	li	a2,1024
    800022fa:	4581                	li	a1,0
    800022fc:	05850513          	addi	a0,a0,88
    80002300:	e4dfd0ef          	jal	ra,8000014c <memset>
  log_write(bp);
    80002304:	854a                	mv	a0,s2
    80002306:	745000ef          	jal	ra,8000324a <log_write>
  brelse(bp);
    8000230a:	854a                	mv	a0,s2
    8000230c:	e33ff0ef          	jal	ra,8000213e <brelse>
}
    80002310:	8526                	mv	a0,s1
    80002312:	60e6                	ld	ra,88(sp)
    80002314:	6446                	ld	s0,80(sp)
    80002316:	64a6                	ld	s1,72(sp)
    80002318:	6906                	ld	s2,64(sp)
    8000231a:	79e2                	ld	s3,56(sp)
    8000231c:	7a42                	ld	s4,48(sp)
    8000231e:	7aa2                	ld	s5,40(sp)
    80002320:	7b02                	ld	s6,32(sp)
    80002322:	6be2                	ld	s7,24(sp)
    80002324:	6c42                	ld	s8,16(sp)
    80002326:	6ca2                	ld	s9,8(sp)
    80002328:	6125                	addi	sp,sp,96
    8000232a:	8082                	ret
    brelse(bp);
    8000232c:	854a                	mv	a0,s2
    8000232e:	e11ff0ef          	jal	ra,8000213e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002332:	015c87bb          	addw	a5,s9,s5
    80002336:	00078a9b          	sext.w	s5,a5
    8000233a:	004b2703          	lw	a4,4(s6)
    8000233e:	06eaf163          	bgeu	s5,a4,800023a0 <balloc+0x104>
    bp = bread(dev, BBLOCK(b, sb));
    80002342:	41fad79b          	sraiw	a5,s5,0x1f
    80002346:	0137d79b          	srliw	a5,a5,0x13
    8000234a:	015787bb          	addw	a5,a5,s5
    8000234e:	40d7d79b          	sraiw	a5,a5,0xd
    80002352:	01cb2583          	lw	a1,28(s6)
    80002356:	9dbd                	addw	a1,a1,a5
    80002358:	855e                	mv	a0,s7
    8000235a:	cddff0ef          	jal	ra,80002036 <bread>
    8000235e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002360:	004b2503          	lw	a0,4(s6)
    80002364:	000a849b          	sext.w	s1,s5
    80002368:	8662                	mv	a2,s8
    8000236a:	fca4f1e3          	bgeu	s1,a0,8000232c <balloc+0x90>
      m = 1 << (bi % 8);
    8000236e:	41f6579b          	sraiw	a5,a2,0x1f
    80002372:	01d7d69b          	srliw	a3,a5,0x1d
    80002376:	00c6873b          	addw	a4,a3,a2
    8000237a:	00777793          	andi	a5,a4,7
    8000237e:	9f95                	subw	a5,a5,a3
    80002380:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002384:	4037571b          	sraiw	a4,a4,0x3
    80002388:	00e906b3          	add	a3,s2,a4
    8000238c:	0586c683          	lbu	a3,88(a3) # 1058 <_entry-0x7fffefa8>
    80002390:	00d7f5b3          	and	a1,a5,a3
    80002394:	d1b1                	beqz	a1,800022d8 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002396:	2605                	addiw	a2,a2,1
    80002398:	2485                	addiw	s1,s1,1
    8000239a:	fd4618e3          	bne	a2,s4,8000236a <balloc+0xce>
    8000239e:	b779                	j	8000232c <balloc+0x90>
  printf("balloc: out of blocks\n");
    800023a0:	00005517          	auipc	a0,0x5
    800023a4:	0f850513          	addi	a0,a0,248 # 80007498 <syscalls+0x108>
    800023a8:	6b9020ef          	jal	ra,80005260 <printf>
  return 0;
    800023ac:	4481                	li	s1,0
    800023ae:	b78d                	j	80002310 <balloc+0x74>

00000000800023b0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800023b0:	7179                	addi	sp,sp,-48
    800023b2:	f406                	sd	ra,40(sp)
    800023b4:	f022                	sd	s0,32(sp)
    800023b6:	ec26                	sd	s1,24(sp)
    800023b8:	e84a                	sd	s2,16(sp)
    800023ba:	e44e                	sd	s3,8(sp)
    800023bc:	e052                	sd	s4,0(sp)
    800023be:	1800                	addi	s0,sp,48
    800023c0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800023c2:	47ad                	li	a5,11
    800023c4:	02b7e563          	bltu	a5,a1,800023ee <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800023c8:	02059493          	slli	s1,a1,0x20
    800023cc:	9081                	srli	s1,s1,0x20
    800023ce:	048a                	slli	s1,s1,0x2
    800023d0:	94aa                	add	s1,s1,a0
    800023d2:	0504a903          	lw	s2,80(s1)
    800023d6:	06091663          	bnez	s2,80002442 <bmap+0x92>
      addr = balloc(ip->dev);
    800023da:	4108                	lw	a0,0(a0)
    800023dc:	ec1ff0ef          	jal	ra,8000229c <balloc>
    800023e0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023e4:	04090f63          	beqz	s2,80002442 <bmap+0x92>
        return 0;
      ip->addrs[bn] = addr;
    800023e8:	0524a823          	sw	s2,80(s1)
    800023ec:	a899                	j	80002442 <bmap+0x92>
    }
    return addr;
  }
  bn -= NDIRECT;
    800023ee:	ff45849b          	addiw	s1,a1,-12
    800023f2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800023f6:	0ff00793          	li	a5,255
    800023fa:	06e7eb63          	bltu	a5,a4,80002470 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800023fe:	08052903          	lw	s2,128(a0)
    80002402:	00091b63          	bnez	s2,80002418 <bmap+0x68>
      addr = balloc(ip->dev);
    80002406:	4108                	lw	a0,0(a0)
    80002408:	e95ff0ef          	jal	ra,8000229c <balloc>
    8000240c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002410:	02090963          	beqz	s2,80002442 <bmap+0x92>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002414:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002418:	85ca                	mv	a1,s2
    8000241a:	0009a503          	lw	a0,0(s3)
    8000241e:	c19ff0ef          	jal	ra,80002036 <bread>
    80002422:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002424:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002428:	02049593          	slli	a1,s1,0x20
    8000242c:	9181                	srli	a1,a1,0x20
    8000242e:	058a                	slli	a1,a1,0x2
    80002430:	00b784b3          	add	s1,a5,a1
    80002434:	0004a903          	lw	s2,0(s1)
    80002438:	00090e63          	beqz	s2,80002454 <bmap+0xa4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000243c:	8552                	mv	a0,s4
    8000243e:	d01ff0ef          	jal	ra,8000213e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002442:	854a                	mv	a0,s2
    80002444:	70a2                	ld	ra,40(sp)
    80002446:	7402                	ld	s0,32(sp)
    80002448:	64e2                	ld	s1,24(sp)
    8000244a:	6942                	ld	s2,16(sp)
    8000244c:	69a2                	ld	s3,8(sp)
    8000244e:	6a02                	ld	s4,0(sp)
    80002450:	6145                	addi	sp,sp,48
    80002452:	8082                	ret
      addr = balloc(ip->dev);
    80002454:	0009a503          	lw	a0,0(s3)
    80002458:	e45ff0ef          	jal	ra,8000229c <balloc>
    8000245c:	0005091b          	sext.w	s2,a0
      if(addr){
    80002460:	fc090ee3          	beqz	s2,8000243c <bmap+0x8c>
        a[bn] = addr;
    80002464:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002468:	8552                	mv	a0,s4
    8000246a:	5e1000ef          	jal	ra,8000324a <log_write>
    8000246e:	b7f9                	j	8000243c <bmap+0x8c>
  panic("bmap: out of range");
    80002470:	00005517          	auipc	a0,0x5
    80002474:	04050513          	addi	a0,a0,64 # 800074b0 <syscalls+0x120>
    80002478:	0ae030ef          	jal	ra,80005526 <panic>

000000008000247c <iget>:
{
    8000247c:	7179                	addi	sp,sp,-48
    8000247e:	f406                	sd	ra,40(sp)
    80002480:	f022                	sd	s0,32(sp)
    80002482:	ec26                	sd	s1,24(sp)
    80002484:	e84a                	sd	s2,16(sp)
    80002486:	e44e                	sd	s3,8(sp)
    80002488:	e052                	sd	s4,0(sp)
    8000248a:	1800                	addi	s0,sp,48
    8000248c:	89aa                	mv	s3,a0
    8000248e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002490:	00014517          	auipc	a0,0x14
    80002494:	95850513          	addi	a0,a0,-1704 # 80015de8 <itable>
    80002498:	348030ef          	jal	ra,800057e0 <acquire>
  empty = 0;
    8000249c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000249e:	00014497          	auipc	s1,0x14
    800024a2:	96248493          	addi	s1,s1,-1694 # 80015e00 <itable+0x18>
    800024a6:	00015697          	auipc	a3,0x15
    800024aa:	3ea68693          	addi	a3,a3,1002 # 80017890 <log>
    800024ae:	a039                	j	800024bc <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024b0:	02090963          	beqz	s2,800024e2 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024b4:	08848493          	addi	s1,s1,136
    800024b8:	02d48863          	beq	s1,a3,800024e8 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800024bc:	449c                	lw	a5,8(s1)
    800024be:	fef059e3          	blez	a5,800024b0 <iget+0x34>
    800024c2:	4098                	lw	a4,0(s1)
    800024c4:	ff3716e3          	bne	a4,s3,800024b0 <iget+0x34>
    800024c8:	40d8                	lw	a4,4(s1)
    800024ca:	ff4713e3          	bne	a4,s4,800024b0 <iget+0x34>
      ip->ref++;
    800024ce:	2785                	addiw	a5,a5,1
    800024d0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024d2:	00014517          	auipc	a0,0x14
    800024d6:	91650513          	addi	a0,a0,-1770 # 80015de8 <itable>
    800024da:	39e030ef          	jal	ra,80005878 <release>
      return ip;
    800024de:	8926                	mv	s2,s1
    800024e0:	a02d                	j	8000250a <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024e2:	fbe9                	bnez	a5,800024b4 <iget+0x38>
    800024e4:	8926                	mv	s2,s1
    800024e6:	b7f9                	j	800024b4 <iget+0x38>
  if(empty == 0)
    800024e8:	02090a63          	beqz	s2,8000251c <iget+0xa0>
  ip->dev = dev;
    800024ec:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800024f0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800024f4:	4785                	li	a5,1
    800024f6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800024fa:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800024fe:	00014517          	auipc	a0,0x14
    80002502:	8ea50513          	addi	a0,a0,-1814 # 80015de8 <itable>
    80002506:	372030ef          	jal	ra,80005878 <release>
}
    8000250a:	854a                	mv	a0,s2
    8000250c:	70a2                	ld	ra,40(sp)
    8000250e:	7402                	ld	s0,32(sp)
    80002510:	64e2                	ld	s1,24(sp)
    80002512:	6942                	ld	s2,16(sp)
    80002514:	69a2                	ld	s3,8(sp)
    80002516:	6a02                	ld	s4,0(sp)
    80002518:	6145                	addi	sp,sp,48
    8000251a:	8082                	ret
    panic("iget: no inodes");
    8000251c:	00005517          	auipc	a0,0x5
    80002520:	fac50513          	addi	a0,a0,-84 # 800074c8 <syscalls+0x138>
    80002524:	002030ef          	jal	ra,80005526 <panic>

0000000080002528 <iinit>:
{
    80002528:	7179                	addi	sp,sp,-48
    8000252a:	f406                	sd	ra,40(sp)
    8000252c:	f022                	sd	s0,32(sp)
    8000252e:	ec26                	sd	s1,24(sp)
    80002530:	e84a                	sd	s2,16(sp)
    80002532:	e44e                	sd	s3,8(sp)
    80002534:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002536:	00005597          	auipc	a1,0x5
    8000253a:	fa258593          	addi	a1,a1,-94 # 800074d8 <syscalls+0x148>
    8000253e:	00014517          	auipc	a0,0x14
    80002542:	8aa50513          	addi	a0,a0,-1878 # 80015de8 <itable>
    80002546:	21a030ef          	jal	ra,80005760 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000254a:	00014497          	auipc	s1,0x14
    8000254e:	8c648493          	addi	s1,s1,-1850 # 80015e10 <itable+0x28>
    80002552:	00015997          	auipc	s3,0x15
    80002556:	34e98993          	addi	s3,s3,846 # 800178a0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000255a:	00005917          	auipc	s2,0x5
    8000255e:	f8690913          	addi	s2,s2,-122 # 800074e0 <syscalls+0x150>
    80002562:	85ca                	mv	a1,s2
    80002564:	8526                	mv	a0,s1
    80002566:	5a9000ef          	jal	ra,8000330e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000256a:	08848493          	addi	s1,s1,136
    8000256e:	ff349ae3          	bne	s1,s3,80002562 <iinit+0x3a>
}
    80002572:	70a2                	ld	ra,40(sp)
    80002574:	7402                	ld	s0,32(sp)
    80002576:	64e2                	ld	s1,24(sp)
    80002578:	6942                	ld	s2,16(sp)
    8000257a:	69a2                	ld	s3,8(sp)
    8000257c:	6145                	addi	sp,sp,48
    8000257e:	8082                	ret

0000000080002580 <ialloc>:
{
    80002580:	715d                	addi	sp,sp,-80
    80002582:	e486                	sd	ra,72(sp)
    80002584:	e0a2                	sd	s0,64(sp)
    80002586:	fc26                	sd	s1,56(sp)
    80002588:	f84a                	sd	s2,48(sp)
    8000258a:	f44e                	sd	s3,40(sp)
    8000258c:	f052                	sd	s4,32(sp)
    8000258e:	ec56                	sd	s5,24(sp)
    80002590:	e85a                	sd	s6,16(sp)
    80002592:	e45e                	sd	s7,8(sp)
    80002594:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002596:	00014717          	auipc	a4,0x14
    8000259a:	83e72703          	lw	a4,-1986(a4) # 80015dd4 <sb+0xc>
    8000259e:	4785                	li	a5,1
    800025a0:	04e7f663          	bgeu	a5,a4,800025ec <ialloc+0x6c>
    800025a4:	8aaa                	mv	s5,a0
    800025a6:	8bae                	mv	s7,a1
    800025a8:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800025aa:	00014a17          	auipc	s4,0x14
    800025ae:	81ea0a13          	addi	s4,s4,-2018 # 80015dc8 <sb>
    800025b2:	00048b1b          	sext.w	s6,s1
    800025b6:	0044d593          	srli	a1,s1,0x4
    800025ba:	018a2783          	lw	a5,24(s4)
    800025be:	9dbd                	addw	a1,a1,a5
    800025c0:	8556                	mv	a0,s5
    800025c2:	a75ff0ef          	jal	ra,80002036 <bread>
    800025c6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800025c8:	05850993          	addi	s3,a0,88
    800025cc:	00f4f793          	andi	a5,s1,15
    800025d0:	079a                	slli	a5,a5,0x6
    800025d2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800025d4:	00099783          	lh	a5,0(s3)
    800025d8:	cf85                	beqz	a5,80002610 <ialloc+0x90>
    brelse(bp);
    800025da:	b65ff0ef          	jal	ra,8000213e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800025de:	0485                	addi	s1,s1,1
    800025e0:	00ca2703          	lw	a4,12(s4)
    800025e4:	0004879b          	sext.w	a5,s1
    800025e8:	fce7e5e3          	bltu	a5,a4,800025b2 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800025ec:	00005517          	auipc	a0,0x5
    800025f0:	efc50513          	addi	a0,a0,-260 # 800074e8 <syscalls+0x158>
    800025f4:	46d020ef          	jal	ra,80005260 <printf>
  return 0;
    800025f8:	4501                	li	a0,0
}
    800025fa:	60a6                	ld	ra,72(sp)
    800025fc:	6406                	ld	s0,64(sp)
    800025fe:	74e2                	ld	s1,56(sp)
    80002600:	7942                	ld	s2,48(sp)
    80002602:	79a2                	ld	s3,40(sp)
    80002604:	7a02                	ld	s4,32(sp)
    80002606:	6ae2                	ld	s5,24(sp)
    80002608:	6b42                	ld	s6,16(sp)
    8000260a:	6ba2                	ld	s7,8(sp)
    8000260c:	6161                	addi	sp,sp,80
    8000260e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002610:	04000613          	li	a2,64
    80002614:	4581                	li	a1,0
    80002616:	854e                	mv	a0,s3
    80002618:	b35fd0ef          	jal	ra,8000014c <memset>
      dip->type = type;
    8000261c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002620:	854a                	mv	a0,s2
    80002622:	429000ef          	jal	ra,8000324a <log_write>
      brelse(bp);
    80002626:	854a                	mv	a0,s2
    80002628:	b17ff0ef          	jal	ra,8000213e <brelse>
      return iget(dev, inum);
    8000262c:	85da                	mv	a1,s6
    8000262e:	8556                	mv	a0,s5
    80002630:	e4dff0ef          	jal	ra,8000247c <iget>
    80002634:	b7d9                	j	800025fa <ialloc+0x7a>

0000000080002636 <iupdate>:
{
    80002636:	1101                	addi	sp,sp,-32
    80002638:	ec06                	sd	ra,24(sp)
    8000263a:	e822                	sd	s0,16(sp)
    8000263c:	e426                	sd	s1,8(sp)
    8000263e:	e04a                	sd	s2,0(sp)
    80002640:	1000                	addi	s0,sp,32
    80002642:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002644:	415c                	lw	a5,4(a0)
    80002646:	0047d79b          	srliw	a5,a5,0x4
    8000264a:	00013597          	auipc	a1,0x13
    8000264e:	7965a583          	lw	a1,1942(a1) # 80015de0 <sb+0x18>
    80002652:	9dbd                	addw	a1,a1,a5
    80002654:	4108                	lw	a0,0(a0)
    80002656:	9e1ff0ef          	jal	ra,80002036 <bread>
    8000265a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000265c:	05850793          	addi	a5,a0,88
    80002660:	40c8                	lw	a0,4(s1)
    80002662:	893d                	andi	a0,a0,15
    80002664:	051a                	slli	a0,a0,0x6
    80002666:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002668:	04449703          	lh	a4,68(s1)
    8000266c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002670:	04649703          	lh	a4,70(s1)
    80002674:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002678:	04849703          	lh	a4,72(s1)
    8000267c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002680:	04a49703          	lh	a4,74(s1)
    80002684:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002688:	44f8                	lw	a4,76(s1)
    8000268a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000268c:	03400613          	li	a2,52
    80002690:	05048593          	addi	a1,s1,80
    80002694:	0531                	addi	a0,a0,12
    80002696:	b17fd0ef          	jal	ra,800001ac <memmove>
  log_write(bp);
    8000269a:	854a                	mv	a0,s2
    8000269c:	3af000ef          	jal	ra,8000324a <log_write>
  brelse(bp);
    800026a0:	854a                	mv	a0,s2
    800026a2:	a9dff0ef          	jal	ra,8000213e <brelse>
}
    800026a6:	60e2                	ld	ra,24(sp)
    800026a8:	6442                	ld	s0,16(sp)
    800026aa:	64a2                	ld	s1,8(sp)
    800026ac:	6902                	ld	s2,0(sp)
    800026ae:	6105                	addi	sp,sp,32
    800026b0:	8082                	ret

00000000800026b2 <idup>:
{
    800026b2:	1101                	addi	sp,sp,-32
    800026b4:	ec06                	sd	ra,24(sp)
    800026b6:	e822                	sd	s0,16(sp)
    800026b8:	e426                	sd	s1,8(sp)
    800026ba:	1000                	addi	s0,sp,32
    800026bc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800026be:	00013517          	auipc	a0,0x13
    800026c2:	72a50513          	addi	a0,a0,1834 # 80015de8 <itable>
    800026c6:	11a030ef          	jal	ra,800057e0 <acquire>
  ip->ref++;
    800026ca:	449c                	lw	a5,8(s1)
    800026cc:	2785                	addiw	a5,a5,1
    800026ce:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800026d0:	00013517          	auipc	a0,0x13
    800026d4:	71850513          	addi	a0,a0,1816 # 80015de8 <itable>
    800026d8:	1a0030ef          	jal	ra,80005878 <release>
}
    800026dc:	8526                	mv	a0,s1
    800026de:	60e2                	ld	ra,24(sp)
    800026e0:	6442                	ld	s0,16(sp)
    800026e2:	64a2                	ld	s1,8(sp)
    800026e4:	6105                	addi	sp,sp,32
    800026e6:	8082                	ret

00000000800026e8 <ilock>:
{
    800026e8:	1101                	addi	sp,sp,-32
    800026ea:	ec06                	sd	ra,24(sp)
    800026ec:	e822                	sd	s0,16(sp)
    800026ee:	e426                	sd	s1,8(sp)
    800026f0:	e04a                	sd	s2,0(sp)
    800026f2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800026f4:	c105                	beqz	a0,80002714 <ilock+0x2c>
    800026f6:	84aa                	mv	s1,a0
    800026f8:	451c                	lw	a5,8(a0)
    800026fa:	00f05d63          	blez	a5,80002714 <ilock+0x2c>
  acquiresleep(&ip->lock);
    800026fe:	0541                	addi	a0,a0,16
    80002700:	445000ef          	jal	ra,80003344 <acquiresleep>
  if(ip->valid == 0){
    80002704:	40bc                	lw	a5,64(s1)
    80002706:	cf89                	beqz	a5,80002720 <ilock+0x38>
}
    80002708:	60e2                	ld	ra,24(sp)
    8000270a:	6442                	ld	s0,16(sp)
    8000270c:	64a2                	ld	s1,8(sp)
    8000270e:	6902                	ld	s2,0(sp)
    80002710:	6105                	addi	sp,sp,32
    80002712:	8082                	ret
    panic("ilock");
    80002714:	00005517          	auipc	a0,0x5
    80002718:	dec50513          	addi	a0,a0,-532 # 80007500 <syscalls+0x170>
    8000271c:	60b020ef          	jal	ra,80005526 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002720:	40dc                	lw	a5,4(s1)
    80002722:	0047d79b          	srliw	a5,a5,0x4
    80002726:	00013597          	auipc	a1,0x13
    8000272a:	6ba5a583          	lw	a1,1722(a1) # 80015de0 <sb+0x18>
    8000272e:	9dbd                	addw	a1,a1,a5
    80002730:	4088                	lw	a0,0(s1)
    80002732:	905ff0ef          	jal	ra,80002036 <bread>
    80002736:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002738:	05850593          	addi	a1,a0,88
    8000273c:	40dc                	lw	a5,4(s1)
    8000273e:	8bbd                	andi	a5,a5,15
    80002740:	079a                	slli	a5,a5,0x6
    80002742:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002744:	00059783          	lh	a5,0(a1)
    80002748:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000274c:	00259783          	lh	a5,2(a1)
    80002750:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002754:	00459783          	lh	a5,4(a1)
    80002758:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000275c:	00659783          	lh	a5,6(a1)
    80002760:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002764:	459c                	lw	a5,8(a1)
    80002766:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002768:	03400613          	li	a2,52
    8000276c:	05b1                	addi	a1,a1,12
    8000276e:	05048513          	addi	a0,s1,80
    80002772:	a3bfd0ef          	jal	ra,800001ac <memmove>
    brelse(bp);
    80002776:	854a                	mv	a0,s2
    80002778:	9c7ff0ef          	jal	ra,8000213e <brelse>
    ip->valid = 1;
    8000277c:	4785                	li	a5,1
    8000277e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002780:	04449783          	lh	a5,68(s1)
    80002784:	f3d1                	bnez	a5,80002708 <ilock+0x20>
      panic("ilock: no type");
    80002786:	00005517          	auipc	a0,0x5
    8000278a:	d8250513          	addi	a0,a0,-638 # 80007508 <syscalls+0x178>
    8000278e:	599020ef          	jal	ra,80005526 <panic>

0000000080002792 <iunlock>:
{
    80002792:	1101                	addi	sp,sp,-32
    80002794:	ec06                	sd	ra,24(sp)
    80002796:	e822                	sd	s0,16(sp)
    80002798:	e426                	sd	s1,8(sp)
    8000279a:	e04a                	sd	s2,0(sp)
    8000279c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000279e:	c505                	beqz	a0,800027c6 <iunlock+0x34>
    800027a0:	84aa                	mv	s1,a0
    800027a2:	01050913          	addi	s2,a0,16
    800027a6:	854a                	mv	a0,s2
    800027a8:	41b000ef          	jal	ra,800033c2 <holdingsleep>
    800027ac:	cd09                	beqz	a0,800027c6 <iunlock+0x34>
    800027ae:	449c                	lw	a5,8(s1)
    800027b0:	00f05b63          	blez	a5,800027c6 <iunlock+0x34>
  releasesleep(&ip->lock);
    800027b4:	854a                	mv	a0,s2
    800027b6:	3d5000ef          	jal	ra,8000338a <releasesleep>
}
    800027ba:	60e2                	ld	ra,24(sp)
    800027bc:	6442                	ld	s0,16(sp)
    800027be:	64a2                	ld	s1,8(sp)
    800027c0:	6902                	ld	s2,0(sp)
    800027c2:	6105                	addi	sp,sp,32
    800027c4:	8082                	ret
    panic("iunlock");
    800027c6:	00005517          	auipc	a0,0x5
    800027ca:	d5250513          	addi	a0,a0,-686 # 80007518 <syscalls+0x188>
    800027ce:	559020ef          	jal	ra,80005526 <panic>

00000000800027d2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800027d2:	7179                	addi	sp,sp,-48
    800027d4:	f406                	sd	ra,40(sp)
    800027d6:	f022                	sd	s0,32(sp)
    800027d8:	ec26                	sd	s1,24(sp)
    800027da:	e84a                	sd	s2,16(sp)
    800027dc:	e44e                	sd	s3,8(sp)
    800027de:	e052                	sd	s4,0(sp)
    800027e0:	1800                	addi	s0,sp,48
    800027e2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800027e4:	05050493          	addi	s1,a0,80
    800027e8:	08050913          	addi	s2,a0,128
    800027ec:	a021                	j	800027f4 <itrunc+0x22>
    800027ee:	0491                	addi	s1,s1,4
    800027f0:	01248b63          	beq	s1,s2,80002806 <itrunc+0x34>
    if(ip->addrs[i]){
    800027f4:	408c                	lw	a1,0(s1)
    800027f6:	dde5                	beqz	a1,800027ee <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800027f8:	0009a503          	lw	a0,0(s3)
    800027fc:	a35ff0ef          	jal	ra,80002230 <bfree>
      ip->addrs[i] = 0;
    80002800:	0004a023          	sw	zero,0(s1)
    80002804:	b7ed                	j	800027ee <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002806:	0809a583          	lw	a1,128(s3)
    8000280a:	ed91                	bnez	a1,80002826 <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000280c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002810:	854e                	mv	a0,s3
    80002812:	e25ff0ef          	jal	ra,80002636 <iupdate>
}
    80002816:	70a2                	ld	ra,40(sp)
    80002818:	7402                	ld	s0,32(sp)
    8000281a:	64e2                	ld	s1,24(sp)
    8000281c:	6942                	ld	s2,16(sp)
    8000281e:	69a2                	ld	s3,8(sp)
    80002820:	6a02                	ld	s4,0(sp)
    80002822:	6145                	addi	sp,sp,48
    80002824:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002826:	0009a503          	lw	a0,0(s3)
    8000282a:	80dff0ef          	jal	ra,80002036 <bread>
    8000282e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002830:	05850493          	addi	s1,a0,88
    80002834:	45850913          	addi	s2,a0,1112
    80002838:	a801                	j	80002848 <itrunc+0x76>
        bfree(ip->dev, a[j]);
    8000283a:	0009a503          	lw	a0,0(s3)
    8000283e:	9f3ff0ef          	jal	ra,80002230 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002842:	0491                	addi	s1,s1,4
    80002844:	01248563          	beq	s1,s2,8000284e <itrunc+0x7c>
      if(a[j])
    80002848:	408c                	lw	a1,0(s1)
    8000284a:	dde5                	beqz	a1,80002842 <itrunc+0x70>
    8000284c:	b7fd                	j	8000283a <itrunc+0x68>
    brelse(bp);
    8000284e:	8552                	mv	a0,s4
    80002850:	8efff0ef          	jal	ra,8000213e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002854:	0809a583          	lw	a1,128(s3)
    80002858:	0009a503          	lw	a0,0(s3)
    8000285c:	9d5ff0ef          	jal	ra,80002230 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002860:	0809a023          	sw	zero,128(s3)
    80002864:	b765                	j	8000280c <itrunc+0x3a>

0000000080002866 <iput>:
{
    80002866:	1101                	addi	sp,sp,-32
    80002868:	ec06                	sd	ra,24(sp)
    8000286a:	e822                	sd	s0,16(sp)
    8000286c:	e426                	sd	s1,8(sp)
    8000286e:	e04a                	sd	s2,0(sp)
    80002870:	1000                	addi	s0,sp,32
    80002872:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002874:	00013517          	auipc	a0,0x13
    80002878:	57450513          	addi	a0,a0,1396 # 80015de8 <itable>
    8000287c:	765020ef          	jal	ra,800057e0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002880:	4498                	lw	a4,8(s1)
    80002882:	4785                	li	a5,1
    80002884:	02f70163          	beq	a4,a5,800028a6 <iput+0x40>
  ip->ref--;
    80002888:	449c                	lw	a5,8(s1)
    8000288a:	37fd                	addiw	a5,a5,-1
    8000288c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000288e:	00013517          	auipc	a0,0x13
    80002892:	55a50513          	addi	a0,a0,1370 # 80015de8 <itable>
    80002896:	7e3020ef          	jal	ra,80005878 <release>
}
    8000289a:	60e2                	ld	ra,24(sp)
    8000289c:	6442                	ld	s0,16(sp)
    8000289e:	64a2                	ld	s1,8(sp)
    800028a0:	6902                	ld	s2,0(sp)
    800028a2:	6105                	addi	sp,sp,32
    800028a4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028a6:	40bc                	lw	a5,64(s1)
    800028a8:	d3e5                	beqz	a5,80002888 <iput+0x22>
    800028aa:	04a49783          	lh	a5,74(s1)
    800028ae:	ffe9                	bnez	a5,80002888 <iput+0x22>
    acquiresleep(&ip->lock);
    800028b0:	01048913          	addi	s2,s1,16
    800028b4:	854a                	mv	a0,s2
    800028b6:	28f000ef          	jal	ra,80003344 <acquiresleep>
    release(&itable.lock);
    800028ba:	00013517          	auipc	a0,0x13
    800028be:	52e50513          	addi	a0,a0,1326 # 80015de8 <itable>
    800028c2:	7b7020ef          	jal	ra,80005878 <release>
    itrunc(ip);
    800028c6:	8526                	mv	a0,s1
    800028c8:	f0bff0ef          	jal	ra,800027d2 <itrunc>
    ip->type = 0;
    800028cc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800028d0:	8526                	mv	a0,s1
    800028d2:	d65ff0ef          	jal	ra,80002636 <iupdate>
    ip->valid = 0;
    800028d6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800028da:	854a                	mv	a0,s2
    800028dc:	2af000ef          	jal	ra,8000338a <releasesleep>
    acquire(&itable.lock);
    800028e0:	00013517          	auipc	a0,0x13
    800028e4:	50850513          	addi	a0,a0,1288 # 80015de8 <itable>
    800028e8:	6f9020ef          	jal	ra,800057e0 <acquire>
    800028ec:	bf71                	j	80002888 <iput+0x22>

00000000800028ee <iunlockput>:
{
    800028ee:	1101                	addi	sp,sp,-32
    800028f0:	ec06                	sd	ra,24(sp)
    800028f2:	e822                	sd	s0,16(sp)
    800028f4:	e426                	sd	s1,8(sp)
    800028f6:	1000                	addi	s0,sp,32
    800028f8:	84aa                	mv	s1,a0
  iunlock(ip);
    800028fa:	e99ff0ef          	jal	ra,80002792 <iunlock>
  iput(ip);
    800028fe:	8526                	mv	a0,s1
    80002900:	f67ff0ef          	jal	ra,80002866 <iput>
}
    80002904:	60e2                	ld	ra,24(sp)
    80002906:	6442                	ld	s0,16(sp)
    80002908:	64a2                	ld	s1,8(sp)
    8000290a:	6105                	addi	sp,sp,32
    8000290c:	8082                	ret

000000008000290e <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000290e:	00013717          	auipc	a4,0x13
    80002912:	4c672703          	lw	a4,1222(a4) # 80015dd4 <sb+0xc>
    80002916:	4785                	li	a5,1
    80002918:	0ae7ff63          	bgeu	a5,a4,800029d6 <ireclaim+0xc8>
{
    8000291c:	7139                	addi	sp,sp,-64
    8000291e:	fc06                	sd	ra,56(sp)
    80002920:	f822                	sd	s0,48(sp)
    80002922:	f426                	sd	s1,40(sp)
    80002924:	f04a                	sd	s2,32(sp)
    80002926:	ec4e                	sd	s3,24(sp)
    80002928:	e852                	sd	s4,16(sp)
    8000292a:	e456                	sd	s5,8(sp)
    8000292c:	e05a                	sd	s6,0(sp)
    8000292e:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002930:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002932:	00050a1b          	sext.w	s4,a0
    80002936:	00013a97          	auipc	s5,0x13
    8000293a:	492a8a93          	addi	s5,s5,1170 # 80015dc8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    8000293e:	00005b17          	auipc	s6,0x5
    80002942:	be2b0b13          	addi	s6,s6,-1054 # 80007520 <syscalls+0x190>
    80002946:	a099                	j	8000298c <ireclaim+0x7e>
    80002948:	85ce                	mv	a1,s3
    8000294a:	855a                	mv	a0,s6
    8000294c:	115020ef          	jal	ra,80005260 <printf>
      ip = iget(dev, inum);
    80002950:	85ce                	mv	a1,s3
    80002952:	8552                	mv	a0,s4
    80002954:	b29ff0ef          	jal	ra,8000247c <iget>
    80002958:	89aa                	mv	s3,a0
    brelse(bp);
    8000295a:	854a                	mv	a0,s2
    8000295c:	fe2ff0ef          	jal	ra,8000213e <brelse>
    if (ip) {
    80002960:	00098f63          	beqz	s3,8000297e <ireclaim+0x70>
      begin_op();
    80002964:	762000ef          	jal	ra,800030c6 <begin_op>
      ilock(ip);
    80002968:	854e                	mv	a0,s3
    8000296a:	d7fff0ef          	jal	ra,800026e8 <ilock>
      iunlock(ip);
    8000296e:	854e                	mv	a0,s3
    80002970:	e23ff0ef          	jal	ra,80002792 <iunlock>
      iput(ip);
    80002974:	854e                	mv	a0,s3
    80002976:	ef1ff0ef          	jal	ra,80002866 <iput>
      end_op();
    8000297a:	7bc000ef          	jal	ra,80003136 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000297e:	0485                	addi	s1,s1,1
    80002980:	00caa703          	lw	a4,12(s5)
    80002984:	0004879b          	sext.w	a5,s1
    80002988:	02e7fd63          	bgeu	a5,a4,800029c2 <ireclaim+0xb4>
    8000298c:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002990:	0044d593          	srli	a1,s1,0x4
    80002994:	018aa783          	lw	a5,24(s5)
    80002998:	9dbd                	addw	a1,a1,a5
    8000299a:	8552                	mv	a0,s4
    8000299c:	e9aff0ef          	jal	ra,80002036 <bread>
    800029a0:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800029a2:	05850793          	addi	a5,a0,88
    800029a6:	00f9f713          	andi	a4,s3,15
    800029aa:	071a                	slli	a4,a4,0x6
    800029ac:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800029ae:	00079703          	lh	a4,0(a5)
    800029b2:	c701                	beqz	a4,800029ba <ireclaim+0xac>
    800029b4:	00679783          	lh	a5,6(a5)
    800029b8:	dbc1                	beqz	a5,80002948 <ireclaim+0x3a>
    brelse(bp);
    800029ba:	854a                	mv	a0,s2
    800029bc:	f82ff0ef          	jal	ra,8000213e <brelse>
    if (ip) {
    800029c0:	bf7d                	j	8000297e <ireclaim+0x70>
}
    800029c2:	70e2                	ld	ra,56(sp)
    800029c4:	7442                	ld	s0,48(sp)
    800029c6:	74a2                	ld	s1,40(sp)
    800029c8:	7902                	ld	s2,32(sp)
    800029ca:	69e2                	ld	s3,24(sp)
    800029cc:	6a42                	ld	s4,16(sp)
    800029ce:	6aa2                	ld	s5,8(sp)
    800029d0:	6b02                	ld	s6,0(sp)
    800029d2:	6121                	addi	sp,sp,64
    800029d4:	8082                	ret
    800029d6:	8082                	ret

00000000800029d8 <fsinit>:
fsinit(int dev) {
    800029d8:	7179                	addi	sp,sp,-48
    800029da:	f406                	sd	ra,40(sp)
    800029dc:	f022                	sd	s0,32(sp)
    800029de:	ec26                	sd	s1,24(sp)
    800029e0:	e84a                	sd	s2,16(sp)
    800029e2:	e44e                	sd	s3,8(sp)
    800029e4:	1800                	addi	s0,sp,48
    800029e6:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    800029e8:	4585                	li	a1,1
    800029ea:	e4cff0ef          	jal	ra,80002036 <bread>
    800029ee:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029f0:	00013997          	auipc	s3,0x13
    800029f4:	3d898993          	addi	s3,s3,984 # 80015dc8 <sb>
    800029f8:	02000613          	li	a2,32
    800029fc:	05850593          	addi	a1,a0,88
    80002a00:	854e                	mv	a0,s3
    80002a02:	faafd0ef          	jal	ra,800001ac <memmove>
  brelse(bp);
    80002a06:	854a                	mv	a0,s2
    80002a08:	f36ff0ef          	jal	ra,8000213e <brelse>
  if(sb.magic != FSMAGIC)
    80002a0c:	0009a703          	lw	a4,0(s3)
    80002a10:	102037b7          	lui	a5,0x10203
    80002a14:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a18:	02f71363          	bne	a4,a5,80002a3e <fsinit+0x66>
  initlog(dev, &sb);
    80002a1c:	00013597          	auipc	a1,0x13
    80002a20:	3ac58593          	addi	a1,a1,940 # 80015dc8 <sb>
    80002a24:	8526                	mv	a0,s1
    80002a26:	616000ef          	jal	ra,8000303c <initlog>
  ireclaim(dev);
    80002a2a:	8526                	mv	a0,s1
    80002a2c:	ee3ff0ef          	jal	ra,8000290e <ireclaim>
}
    80002a30:	70a2                	ld	ra,40(sp)
    80002a32:	7402                	ld	s0,32(sp)
    80002a34:	64e2                	ld	s1,24(sp)
    80002a36:	6942                	ld	s2,16(sp)
    80002a38:	69a2                	ld	s3,8(sp)
    80002a3a:	6145                	addi	sp,sp,48
    80002a3c:	8082                	ret
    panic("invalid file system");
    80002a3e:	00005517          	auipc	a0,0x5
    80002a42:	b0250513          	addi	a0,a0,-1278 # 80007540 <syscalls+0x1b0>
    80002a46:	2e1020ef          	jal	ra,80005526 <panic>

0000000080002a4a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002a4a:	1141                	addi	sp,sp,-16
    80002a4c:	e422                	sd	s0,8(sp)
    80002a4e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a50:	411c                	lw	a5,0(a0)
    80002a52:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a54:	415c                	lw	a5,4(a0)
    80002a56:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a58:	04451783          	lh	a5,68(a0)
    80002a5c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a60:	04a51783          	lh	a5,74(a0)
    80002a64:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a68:	04c56783          	lwu	a5,76(a0)
    80002a6c:	e99c                	sd	a5,16(a1)
}
    80002a6e:	6422                	ld	s0,8(sp)
    80002a70:	0141                	addi	sp,sp,16
    80002a72:	8082                	ret

0000000080002a74 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a74:	457c                	lw	a5,76(a0)
    80002a76:	0cd7ef63          	bltu	a5,a3,80002b54 <readi+0xe0>
{
    80002a7a:	7159                	addi	sp,sp,-112
    80002a7c:	f486                	sd	ra,104(sp)
    80002a7e:	f0a2                	sd	s0,96(sp)
    80002a80:	eca6                	sd	s1,88(sp)
    80002a82:	e8ca                	sd	s2,80(sp)
    80002a84:	e4ce                	sd	s3,72(sp)
    80002a86:	e0d2                	sd	s4,64(sp)
    80002a88:	fc56                	sd	s5,56(sp)
    80002a8a:	f85a                	sd	s6,48(sp)
    80002a8c:	f45e                	sd	s7,40(sp)
    80002a8e:	f062                	sd	s8,32(sp)
    80002a90:	ec66                	sd	s9,24(sp)
    80002a92:	e86a                	sd	s10,16(sp)
    80002a94:	e46e                	sd	s11,8(sp)
    80002a96:	1880                	addi	s0,sp,112
    80002a98:	8b2a                	mv	s6,a0
    80002a9a:	8bae                	mv	s7,a1
    80002a9c:	8a32                	mv	s4,a2
    80002a9e:	84b6                	mv	s1,a3
    80002aa0:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002aa2:	9f35                	addw	a4,a4,a3
    return 0;
    80002aa4:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002aa6:	08d76663          	bltu	a4,a3,80002b32 <readi+0xbe>
  if(off + n > ip->size)
    80002aaa:	00e7f463          	bgeu	a5,a4,80002ab2 <readi+0x3e>
    n = ip->size - off;
    80002aae:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ab2:	080a8f63          	beqz	s5,80002b50 <readi+0xdc>
    80002ab6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ab8:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002abc:	5c7d                	li	s8,-1
    80002abe:	a80d                	j	80002af0 <readi+0x7c>
    80002ac0:	020d1d93          	slli	s11,s10,0x20
    80002ac4:	020ddd93          	srli	s11,s11,0x20
    80002ac8:	05890613          	addi	a2,s2,88
    80002acc:	86ee                	mv	a3,s11
    80002ace:	963a                	add	a2,a2,a4
    80002ad0:	85d2                	mv	a1,s4
    80002ad2:	855e                	mv	a0,s7
    80002ad4:	bb3fe0ef          	jal	ra,80001686 <either_copyout>
    80002ad8:	05850763          	beq	a0,s8,80002b26 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002adc:	854a                	mv	a0,s2
    80002ade:	e60ff0ef          	jal	ra,8000213e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ae2:	013d09bb          	addw	s3,s10,s3
    80002ae6:	009d04bb          	addw	s1,s10,s1
    80002aea:	9a6e                	add	s4,s4,s11
    80002aec:	0559f163          	bgeu	s3,s5,80002b2e <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    80002af0:	00a4d59b          	srliw	a1,s1,0xa
    80002af4:	855a                	mv	a0,s6
    80002af6:	8bbff0ef          	jal	ra,800023b0 <bmap>
    80002afa:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002afe:	c985                	beqz	a1,80002b2e <readi+0xba>
    bp = bread(ip->dev, addr);
    80002b00:	000b2503          	lw	a0,0(s6)
    80002b04:	d32ff0ef          	jal	ra,80002036 <bread>
    80002b08:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b0a:	3ff4f713          	andi	a4,s1,1023
    80002b0e:	40ec87bb          	subw	a5,s9,a4
    80002b12:	413a86bb          	subw	a3,s5,s3
    80002b16:	8d3e                	mv	s10,a5
    80002b18:	2781                	sext.w	a5,a5
    80002b1a:	0006861b          	sext.w	a2,a3
    80002b1e:	faf671e3          	bgeu	a2,a5,80002ac0 <readi+0x4c>
    80002b22:	8d36                	mv	s10,a3
    80002b24:	bf71                	j	80002ac0 <readi+0x4c>
      brelse(bp);
    80002b26:	854a                	mv	a0,s2
    80002b28:	e16ff0ef          	jal	ra,8000213e <brelse>
      tot = -1;
    80002b2c:	59fd                	li	s3,-1
  }
  return tot;
    80002b2e:	0009851b          	sext.w	a0,s3
}
    80002b32:	70a6                	ld	ra,104(sp)
    80002b34:	7406                	ld	s0,96(sp)
    80002b36:	64e6                	ld	s1,88(sp)
    80002b38:	6946                	ld	s2,80(sp)
    80002b3a:	69a6                	ld	s3,72(sp)
    80002b3c:	6a06                	ld	s4,64(sp)
    80002b3e:	7ae2                	ld	s5,56(sp)
    80002b40:	7b42                	ld	s6,48(sp)
    80002b42:	7ba2                	ld	s7,40(sp)
    80002b44:	7c02                	ld	s8,32(sp)
    80002b46:	6ce2                	ld	s9,24(sp)
    80002b48:	6d42                	ld	s10,16(sp)
    80002b4a:	6da2                	ld	s11,8(sp)
    80002b4c:	6165                	addi	sp,sp,112
    80002b4e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b50:	89d6                	mv	s3,s5
    80002b52:	bff1                	j	80002b2e <readi+0xba>
    return 0;
    80002b54:	4501                	li	a0,0
}
    80002b56:	8082                	ret

0000000080002b58 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b58:	457c                	lw	a5,76(a0)
    80002b5a:	0ed7ea63          	bltu	a5,a3,80002c4e <writei+0xf6>
{
    80002b5e:	7159                	addi	sp,sp,-112
    80002b60:	f486                	sd	ra,104(sp)
    80002b62:	f0a2                	sd	s0,96(sp)
    80002b64:	eca6                	sd	s1,88(sp)
    80002b66:	e8ca                	sd	s2,80(sp)
    80002b68:	e4ce                	sd	s3,72(sp)
    80002b6a:	e0d2                	sd	s4,64(sp)
    80002b6c:	fc56                	sd	s5,56(sp)
    80002b6e:	f85a                	sd	s6,48(sp)
    80002b70:	f45e                	sd	s7,40(sp)
    80002b72:	f062                	sd	s8,32(sp)
    80002b74:	ec66                	sd	s9,24(sp)
    80002b76:	e86a                	sd	s10,16(sp)
    80002b78:	e46e                	sd	s11,8(sp)
    80002b7a:	1880                	addi	s0,sp,112
    80002b7c:	8aaa                	mv	s5,a0
    80002b7e:	8bae                	mv	s7,a1
    80002b80:	8a32                	mv	s4,a2
    80002b82:	8936                	mv	s2,a3
    80002b84:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b86:	00e687bb          	addw	a5,a3,a4
    80002b8a:	0cd7e463          	bltu	a5,a3,80002c52 <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b8e:	00043737          	lui	a4,0x43
    80002b92:	0cf76263          	bltu	a4,a5,80002c56 <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b96:	0a0b0a63          	beqz	s6,80002c4a <writei+0xf2>
    80002b9a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b9c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ba0:	5c7d                	li	s8,-1
    80002ba2:	a825                	j	80002bda <writei+0x82>
    80002ba4:	020d1d93          	slli	s11,s10,0x20
    80002ba8:	020ddd93          	srli	s11,s11,0x20
    80002bac:	05848513          	addi	a0,s1,88
    80002bb0:	86ee                	mv	a3,s11
    80002bb2:	8652                	mv	a2,s4
    80002bb4:	85de                	mv	a1,s7
    80002bb6:	953a                	add	a0,a0,a4
    80002bb8:	b19fe0ef          	jal	ra,800016d0 <either_copyin>
    80002bbc:	05850a63          	beq	a0,s8,80002c10 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002bc0:	8526                	mv	a0,s1
    80002bc2:	688000ef          	jal	ra,8000324a <log_write>
    brelse(bp);
    80002bc6:	8526                	mv	a0,s1
    80002bc8:	d76ff0ef          	jal	ra,8000213e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bcc:	013d09bb          	addw	s3,s10,s3
    80002bd0:	012d093b          	addw	s2,s10,s2
    80002bd4:	9a6e                	add	s4,s4,s11
    80002bd6:	0569f063          	bgeu	s3,s6,80002c16 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002bda:	00a9559b          	srliw	a1,s2,0xa
    80002bde:	8556                	mv	a0,s5
    80002be0:	fd0ff0ef          	jal	ra,800023b0 <bmap>
    80002be4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002be8:	c59d                	beqz	a1,80002c16 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002bea:	000aa503          	lw	a0,0(s5)
    80002bee:	c48ff0ef          	jal	ra,80002036 <bread>
    80002bf2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bf4:	3ff97713          	andi	a4,s2,1023
    80002bf8:	40ec87bb          	subw	a5,s9,a4
    80002bfc:	413b06bb          	subw	a3,s6,s3
    80002c00:	8d3e                	mv	s10,a5
    80002c02:	2781                	sext.w	a5,a5
    80002c04:	0006861b          	sext.w	a2,a3
    80002c08:	f8f67ee3          	bgeu	a2,a5,80002ba4 <writei+0x4c>
    80002c0c:	8d36                	mv	s10,a3
    80002c0e:	bf59                	j	80002ba4 <writei+0x4c>
      brelse(bp);
    80002c10:	8526                	mv	a0,s1
    80002c12:	d2cff0ef          	jal	ra,8000213e <brelse>
  }

  if(off > ip->size)
    80002c16:	04caa783          	lw	a5,76(s5)
    80002c1a:	0127f463          	bgeu	a5,s2,80002c22 <writei+0xca>
    ip->size = off;
    80002c1e:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002c22:	8556                	mv	a0,s5
    80002c24:	a13ff0ef          	jal	ra,80002636 <iupdate>

  return tot;
    80002c28:	0009851b          	sext.w	a0,s3
}
    80002c2c:	70a6                	ld	ra,104(sp)
    80002c2e:	7406                	ld	s0,96(sp)
    80002c30:	64e6                	ld	s1,88(sp)
    80002c32:	6946                	ld	s2,80(sp)
    80002c34:	69a6                	ld	s3,72(sp)
    80002c36:	6a06                	ld	s4,64(sp)
    80002c38:	7ae2                	ld	s5,56(sp)
    80002c3a:	7b42                	ld	s6,48(sp)
    80002c3c:	7ba2                	ld	s7,40(sp)
    80002c3e:	7c02                	ld	s8,32(sp)
    80002c40:	6ce2                	ld	s9,24(sp)
    80002c42:	6d42                	ld	s10,16(sp)
    80002c44:	6da2                	ld	s11,8(sp)
    80002c46:	6165                	addi	sp,sp,112
    80002c48:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c4a:	89da                	mv	s3,s6
    80002c4c:	bfd9                	j	80002c22 <writei+0xca>
    return -1;
    80002c4e:	557d                	li	a0,-1
}
    80002c50:	8082                	ret
    return -1;
    80002c52:	557d                	li	a0,-1
    80002c54:	bfe1                	j	80002c2c <writei+0xd4>
    return -1;
    80002c56:	557d                	li	a0,-1
    80002c58:	bfd1                	j	80002c2c <writei+0xd4>

0000000080002c5a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c5a:	1141                	addi	sp,sp,-16
    80002c5c:	e406                	sd	ra,8(sp)
    80002c5e:	e022                	sd	s0,0(sp)
    80002c60:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c62:	4639                	li	a2,14
    80002c64:	dbcfd0ef          	jal	ra,80000220 <strncmp>
}
    80002c68:	60a2                	ld	ra,8(sp)
    80002c6a:	6402                	ld	s0,0(sp)
    80002c6c:	0141                	addi	sp,sp,16
    80002c6e:	8082                	ret

0000000080002c70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c70:	7139                	addi	sp,sp,-64
    80002c72:	fc06                	sd	ra,56(sp)
    80002c74:	f822                	sd	s0,48(sp)
    80002c76:	f426                	sd	s1,40(sp)
    80002c78:	f04a                	sd	s2,32(sp)
    80002c7a:	ec4e                	sd	s3,24(sp)
    80002c7c:	e852                	sd	s4,16(sp)
    80002c7e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c80:	04451703          	lh	a4,68(a0)
    80002c84:	4785                	li	a5,1
    80002c86:	00f71a63          	bne	a4,a5,80002c9a <dirlookup+0x2a>
    80002c8a:	892a                	mv	s2,a0
    80002c8c:	89ae                	mv	s3,a1
    80002c8e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c90:	457c                	lw	a5,76(a0)
    80002c92:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c94:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c96:	e39d                	bnez	a5,80002cbc <dirlookup+0x4c>
    80002c98:	a095                	j	80002cfc <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002c9a:	00005517          	auipc	a0,0x5
    80002c9e:	8be50513          	addi	a0,a0,-1858 # 80007558 <syscalls+0x1c8>
    80002ca2:	085020ef          	jal	ra,80005526 <panic>
      panic("dirlookup read");
    80002ca6:	00005517          	auipc	a0,0x5
    80002caa:	8ca50513          	addi	a0,a0,-1846 # 80007570 <syscalls+0x1e0>
    80002cae:	079020ef          	jal	ra,80005526 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cb2:	24c1                	addiw	s1,s1,16
    80002cb4:	04c92783          	lw	a5,76(s2)
    80002cb8:	04f4f163          	bgeu	s1,a5,80002cfa <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cbc:	4741                	li	a4,16
    80002cbe:	86a6                	mv	a3,s1
    80002cc0:	fc040613          	addi	a2,s0,-64
    80002cc4:	4581                	li	a1,0
    80002cc6:	854a                	mv	a0,s2
    80002cc8:	dadff0ef          	jal	ra,80002a74 <readi>
    80002ccc:	47c1                	li	a5,16
    80002cce:	fcf51ce3          	bne	a0,a5,80002ca6 <dirlookup+0x36>
    if(de.inum == 0)
    80002cd2:	fc045783          	lhu	a5,-64(s0)
    80002cd6:	dff1                	beqz	a5,80002cb2 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002cd8:	fc240593          	addi	a1,s0,-62
    80002cdc:	854e                	mv	a0,s3
    80002cde:	f7dff0ef          	jal	ra,80002c5a <namecmp>
    80002ce2:	f961                	bnez	a0,80002cb2 <dirlookup+0x42>
      if(poff)
    80002ce4:	000a0463          	beqz	s4,80002cec <dirlookup+0x7c>
        *poff = off;
    80002ce8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002cec:	fc045583          	lhu	a1,-64(s0)
    80002cf0:	00092503          	lw	a0,0(s2)
    80002cf4:	f88ff0ef          	jal	ra,8000247c <iget>
    80002cf8:	a011                	j	80002cfc <dirlookup+0x8c>
  return 0;
    80002cfa:	4501                	li	a0,0
}
    80002cfc:	70e2                	ld	ra,56(sp)
    80002cfe:	7442                	ld	s0,48(sp)
    80002d00:	74a2                	ld	s1,40(sp)
    80002d02:	7902                	ld	s2,32(sp)
    80002d04:	69e2                	ld	s3,24(sp)
    80002d06:	6a42                	ld	s4,16(sp)
    80002d08:	6121                	addi	sp,sp,64
    80002d0a:	8082                	ret

0000000080002d0c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002d0c:	711d                	addi	sp,sp,-96
    80002d0e:	ec86                	sd	ra,88(sp)
    80002d10:	e8a2                	sd	s0,80(sp)
    80002d12:	e4a6                	sd	s1,72(sp)
    80002d14:	e0ca                	sd	s2,64(sp)
    80002d16:	fc4e                	sd	s3,56(sp)
    80002d18:	f852                	sd	s4,48(sp)
    80002d1a:	f456                	sd	s5,40(sp)
    80002d1c:	f05a                	sd	s6,32(sp)
    80002d1e:	ec5e                	sd	s7,24(sp)
    80002d20:	e862                	sd	s8,16(sp)
    80002d22:	e466                	sd	s9,8(sp)
    80002d24:	1080                	addi	s0,sp,96
    80002d26:	84aa                	mv	s1,a0
    80002d28:	8b2e                	mv	s6,a1
    80002d2a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d2c:	00054703          	lbu	a4,0(a0)
    80002d30:	02f00793          	li	a5,47
    80002d34:	00f70f63          	beq	a4,a5,80002d52 <namex+0x46>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d38:	800fe0ef          	jal	ra,80000d38 <myproc>
    80002d3c:	15053503          	ld	a0,336(a0)
    80002d40:	973ff0ef          	jal	ra,800026b2 <idup>
    80002d44:	89aa                	mv	s3,a0
  while(*path == '/')
    80002d46:	02f00913          	li	s2,47
  len = path - s;
    80002d4a:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80002d4c:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d4e:	4c05                	li	s8,1
    80002d50:	a861                	j	80002de8 <namex+0xdc>
    ip = iget(ROOTDEV, ROOTINO);
    80002d52:	4585                	li	a1,1
    80002d54:	4505                	li	a0,1
    80002d56:	f26ff0ef          	jal	ra,8000247c <iget>
    80002d5a:	89aa                	mv	s3,a0
    80002d5c:	b7ed                	j	80002d46 <namex+0x3a>
      iunlockput(ip);
    80002d5e:	854e                	mv	a0,s3
    80002d60:	b8fff0ef          	jal	ra,800028ee <iunlockput>
      return 0;
    80002d64:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d66:	854e                	mv	a0,s3
    80002d68:	60e6                	ld	ra,88(sp)
    80002d6a:	6446                	ld	s0,80(sp)
    80002d6c:	64a6                	ld	s1,72(sp)
    80002d6e:	6906                	ld	s2,64(sp)
    80002d70:	79e2                	ld	s3,56(sp)
    80002d72:	7a42                	ld	s4,48(sp)
    80002d74:	7aa2                	ld	s5,40(sp)
    80002d76:	7b02                	ld	s6,32(sp)
    80002d78:	6be2                	ld	s7,24(sp)
    80002d7a:	6c42                	ld	s8,16(sp)
    80002d7c:	6ca2                	ld	s9,8(sp)
    80002d7e:	6125                	addi	sp,sp,96
    80002d80:	8082                	ret
      iunlock(ip);
    80002d82:	854e                	mv	a0,s3
    80002d84:	a0fff0ef          	jal	ra,80002792 <iunlock>
      return ip;
    80002d88:	bff9                	j	80002d66 <namex+0x5a>
      iunlockput(ip);
    80002d8a:	854e                	mv	a0,s3
    80002d8c:	b63ff0ef          	jal	ra,800028ee <iunlockput>
      return 0;
    80002d90:	89d2                	mv	s3,s4
    80002d92:	bfd1                	j	80002d66 <namex+0x5a>
  len = path - s;
    80002d94:	40b48633          	sub	a2,s1,a1
    80002d98:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80002d9c:	074cdc63          	bge	s9,s4,80002e14 <namex+0x108>
    memmove(name, s, DIRSIZ);
    80002da0:	4639                	li	a2,14
    80002da2:	8556                	mv	a0,s5
    80002da4:	c08fd0ef          	jal	ra,800001ac <memmove>
  while(*path == '/')
    80002da8:	0004c783          	lbu	a5,0(s1)
    80002dac:	01279763          	bne	a5,s2,80002dba <namex+0xae>
    path++;
    80002db0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002db2:	0004c783          	lbu	a5,0(s1)
    80002db6:	ff278de3          	beq	a5,s2,80002db0 <namex+0xa4>
    ilock(ip);
    80002dba:	854e                	mv	a0,s3
    80002dbc:	92dff0ef          	jal	ra,800026e8 <ilock>
    if(ip->type != T_DIR){
    80002dc0:	04499783          	lh	a5,68(s3)
    80002dc4:	f9879de3          	bne	a5,s8,80002d5e <namex+0x52>
    if(nameiparent && *path == '\0'){
    80002dc8:	000b0563          	beqz	s6,80002dd2 <namex+0xc6>
    80002dcc:	0004c783          	lbu	a5,0(s1)
    80002dd0:	dbcd                	beqz	a5,80002d82 <namex+0x76>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002dd2:	865e                	mv	a2,s7
    80002dd4:	85d6                	mv	a1,s5
    80002dd6:	854e                	mv	a0,s3
    80002dd8:	e99ff0ef          	jal	ra,80002c70 <dirlookup>
    80002ddc:	8a2a                	mv	s4,a0
    80002dde:	d555                	beqz	a0,80002d8a <namex+0x7e>
    iunlockput(ip);
    80002de0:	854e                	mv	a0,s3
    80002de2:	b0dff0ef          	jal	ra,800028ee <iunlockput>
    ip = next;
    80002de6:	89d2                	mv	s3,s4
  while(*path == '/')
    80002de8:	0004c783          	lbu	a5,0(s1)
    80002dec:	05279363          	bne	a5,s2,80002e32 <namex+0x126>
    path++;
    80002df0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002df2:	0004c783          	lbu	a5,0(s1)
    80002df6:	ff278de3          	beq	a5,s2,80002df0 <namex+0xe4>
  if(*path == 0)
    80002dfa:	c78d                	beqz	a5,80002e24 <namex+0x118>
    path++;
    80002dfc:	85a6                	mv	a1,s1
  len = path - s;
    80002dfe:	8a5e                	mv	s4,s7
    80002e00:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80002e02:	01278963          	beq	a5,s2,80002e14 <namex+0x108>
    80002e06:	d7d9                	beqz	a5,80002d94 <namex+0x88>
    path++;
    80002e08:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80002e0a:	0004c783          	lbu	a5,0(s1)
    80002e0e:	ff279ce3          	bne	a5,s2,80002e06 <namex+0xfa>
    80002e12:	b749                	j	80002d94 <namex+0x88>
    memmove(name, s, len);
    80002e14:	2601                	sext.w	a2,a2
    80002e16:	8556                	mv	a0,s5
    80002e18:	b94fd0ef          	jal	ra,800001ac <memmove>
    name[len] = 0;
    80002e1c:	9a56                	add	s4,s4,s5
    80002e1e:	000a0023          	sb	zero,0(s4)
    80002e22:	b759                	j	80002da8 <namex+0x9c>
  if(nameiparent){
    80002e24:	f40b01e3          	beqz	s6,80002d66 <namex+0x5a>
    iput(ip);
    80002e28:	854e                	mv	a0,s3
    80002e2a:	a3dff0ef          	jal	ra,80002866 <iput>
    return 0;
    80002e2e:	4981                	li	s3,0
    80002e30:	bf1d                	j	80002d66 <namex+0x5a>
  if(*path == 0)
    80002e32:	dbed                	beqz	a5,80002e24 <namex+0x118>
  while(*path != '/' && *path != 0)
    80002e34:	0004c783          	lbu	a5,0(s1)
    80002e38:	85a6                	mv	a1,s1
    80002e3a:	b7f1                	j	80002e06 <namex+0xfa>

0000000080002e3c <dirlink>:
{
    80002e3c:	7139                	addi	sp,sp,-64
    80002e3e:	fc06                	sd	ra,56(sp)
    80002e40:	f822                	sd	s0,48(sp)
    80002e42:	f426                	sd	s1,40(sp)
    80002e44:	f04a                	sd	s2,32(sp)
    80002e46:	ec4e                	sd	s3,24(sp)
    80002e48:	e852                	sd	s4,16(sp)
    80002e4a:	0080                	addi	s0,sp,64
    80002e4c:	892a                	mv	s2,a0
    80002e4e:	8a2e                	mv	s4,a1
    80002e50:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e52:	4601                	li	a2,0
    80002e54:	e1dff0ef          	jal	ra,80002c70 <dirlookup>
    80002e58:	e52d                	bnez	a0,80002ec2 <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e5a:	04c92483          	lw	s1,76(s2)
    80002e5e:	c48d                	beqz	s1,80002e88 <dirlink+0x4c>
    80002e60:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e62:	4741                	li	a4,16
    80002e64:	86a6                	mv	a3,s1
    80002e66:	fc040613          	addi	a2,s0,-64
    80002e6a:	4581                	li	a1,0
    80002e6c:	854a                	mv	a0,s2
    80002e6e:	c07ff0ef          	jal	ra,80002a74 <readi>
    80002e72:	47c1                	li	a5,16
    80002e74:	04f51b63          	bne	a0,a5,80002eca <dirlink+0x8e>
    if(de.inum == 0)
    80002e78:	fc045783          	lhu	a5,-64(s0)
    80002e7c:	c791                	beqz	a5,80002e88 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e7e:	24c1                	addiw	s1,s1,16
    80002e80:	04c92783          	lw	a5,76(s2)
    80002e84:	fcf4efe3          	bltu	s1,a5,80002e62 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002e88:	4639                	li	a2,14
    80002e8a:	85d2                	mv	a1,s4
    80002e8c:	fc240513          	addi	a0,s0,-62
    80002e90:	bccfd0ef          	jal	ra,8000025c <strncpy>
  de.inum = inum;
    80002e94:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e98:	4741                	li	a4,16
    80002e9a:	86a6                	mv	a3,s1
    80002e9c:	fc040613          	addi	a2,s0,-64
    80002ea0:	4581                	li	a1,0
    80002ea2:	854a                	mv	a0,s2
    80002ea4:	cb5ff0ef          	jal	ra,80002b58 <writei>
    80002ea8:	1541                	addi	a0,a0,-16
    80002eaa:	00a03533          	snez	a0,a0
    80002eae:	40a00533          	neg	a0,a0
}
    80002eb2:	70e2                	ld	ra,56(sp)
    80002eb4:	7442                	ld	s0,48(sp)
    80002eb6:	74a2                	ld	s1,40(sp)
    80002eb8:	7902                	ld	s2,32(sp)
    80002eba:	69e2                	ld	s3,24(sp)
    80002ebc:	6a42                	ld	s4,16(sp)
    80002ebe:	6121                	addi	sp,sp,64
    80002ec0:	8082                	ret
    iput(ip);
    80002ec2:	9a5ff0ef          	jal	ra,80002866 <iput>
    return -1;
    80002ec6:	557d                	li	a0,-1
    80002ec8:	b7ed                	j	80002eb2 <dirlink+0x76>
      panic("dirlink read");
    80002eca:	00004517          	auipc	a0,0x4
    80002ece:	6b650513          	addi	a0,a0,1718 # 80007580 <syscalls+0x1f0>
    80002ed2:	654020ef          	jal	ra,80005526 <panic>

0000000080002ed6 <namei>:

struct inode*
namei(char *path)
{
    80002ed6:	1101                	addi	sp,sp,-32
    80002ed8:	ec06                	sd	ra,24(sp)
    80002eda:	e822                	sd	s0,16(sp)
    80002edc:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002ede:	fe040613          	addi	a2,s0,-32
    80002ee2:	4581                	li	a1,0
    80002ee4:	e29ff0ef          	jal	ra,80002d0c <namex>
}
    80002ee8:	60e2                	ld	ra,24(sp)
    80002eea:	6442                	ld	s0,16(sp)
    80002eec:	6105                	addi	sp,sp,32
    80002eee:	8082                	ret

0000000080002ef0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002ef0:	1141                	addi	sp,sp,-16
    80002ef2:	e406                	sd	ra,8(sp)
    80002ef4:	e022                	sd	s0,0(sp)
    80002ef6:	0800                	addi	s0,sp,16
    80002ef8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002efa:	4585                	li	a1,1
    80002efc:	e11ff0ef          	jal	ra,80002d0c <namex>
}
    80002f00:	60a2                	ld	ra,8(sp)
    80002f02:	6402                	ld	s0,0(sp)
    80002f04:	0141                	addi	sp,sp,16
    80002f06:	8082                	ret

0000000080002f08 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002f08:	1101                	addi	sp,sp,-32
    80002f0a:	ec06                	sd	ra,24(sp)
    80002f0c:	e822                	sd	s0,16(sp)
    80002f0e:	e426                	sd	s1,8(sp)
    80002f10:	e04a                	sd	s2,0(sp)
    80002f12:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002f14:	00015917          	auipc	s2,0x15
    80002f18:	97c90913          	addi	s2,s2,-1668 # 80017890 <log>
    80002f1c:	01892583          	lw	a1,24(s2)
    80002f20:	02492503          	lw	a0,36(s2)
    80002f24:	912ff0ef          	jal	ra,80002036 <bread>
    80002f28:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f2a:	02892683          	lw	a3,40(s2)
    80002f2e:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f30:	02d05763          	blez	a3,80002f5e <write_head+0x56>
    80002f34:	00015797          	auipc	a5,0x15
    80002f38:	98878793          	addi	a5,a5,-1656 # 800178bc <log+0x2c>
    80002f3c:	05c50713          	addi	a4,a0,92
    80002f40:	36fd                	addiw	a3,a3,-1
    80002f42:	1682                	slli	a3,a3,0x20
    80002f44:	9281                	srli	a3,a3,0x20
    80002f46:	068a                	slli	a3,a3,0x2
    80002f48:	00015617          	auipc	a2,0x15
    80002f4c:	97860613          	addi	a2,a2,-1672 # 800178c0 <log+0x30>
    80002f50:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80002f52:	4390                	lw	a2,0(a5)
    80002f54:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002f56:	0791                	addi	a5,a5,4
    80002f58:	0711                	addi	a4,a4,4
    80002f5a:	fed79ce3          	bne	a5,a3,80002f52 <write_head+0x4a>
  }
  bwrite(buf);
    80002f5e:	8526                	mv	a0,s1
    80002f60:	9acff0ef          	jal	ra,8000210c <bwrite>
  brelse(buf);
    80002f64:	8526                	mv	a0,s1
    80002f66:	9d8ff0ef          	jal	ra,8000213e <brelse>
}
    80002f6a:	60e2                	ld	ra,24(sp)
    80002f6c:	6442                	ld	s0,16(sp)
    80002f6e:	64a2                	ld	s1,8(sp)
    80002f70:	6902                	ld	s2,0(sp)
    80002f72:	6105                	addi	sp,sp,32
    80002f74:	8082                	ret

0000000080002f76 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f76:	00015797          	auipc	a5,0x15
    80002f7a:	9427a783          	lw	a5,-1726(a5) # 800178b8 <log+0x28>
    80002f7e:	0af05e63          	blez	a5,8000303a <install_trans+0xc4>
{
    80002f82:	715d                	addi	sp,sp,-80
    80002f84:	e486                	sd	ra,72(sp)
    80002f86:	e0a2                	sd	s0,64(sp)
    80002f88:	fc26                	sd	s1,56(sp)
    80002f8a:	f84a                	sd	s2,48(sp)
    80002f8c:	f44e                	sd	s3,40(sp)
    80002f8e:	f052                	sd	s4,32(sp)
    80002f90:	ec56                	sd	s5,24(sp)
    80002f92:	e85a                	sd	s6,16(sp)
    80002f94:	e45e                	sd	s7,8(sp)
    80002f96:	0880                	addi	s0,sp,80
    80002f98:	8b2a                	mv	s6,a0
    80002f9a:	00015a97          	auipc	s5,0x15
    80002f9e:	922a8a93          	addi	s5,s5,-1758 # 800178bc <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fa2:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002fa4:	00004b97          	auipc	s7,0x4
    80002fa8:	5ecb8b93          	addi	s7,s7,1516 # 80007590 <syscalls+0x200>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fac:	00015a17          	auipc	s4,0x15
    80002fb0:	8e4a0a13          	addi	s4,s4,-1820 # 80017890 <log>
    80002fb4:	a03d                	j	80002fe2 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002fb6:	000aa603          	lw	a2,0(s5)
    80002fba:	85ce                	mv	a1,s3
    80002fbc:	855e                	mv	a0,s7
    80002fbe:	2a2020ef          	jal	ra,80005260 <printf>
    80002fc2:	a015                	j	80002fe6 <install_trans+0x70>
      bunpin(dbuf);
    80002fc4:	8526                	mv	a0,s1
    80002fc6:	a36ff0ef          	jal	ra,800021fc <bunpin>
    brelse(lbuf);
    80002fca:	854a                	mv	a0,s2
    80002fcc:	972ff0ef          	jal	ra,8000213e <brelse>
    brelse(dbuf);
    80002fd0:	8526                	mv	a0,s1
    80002fd2:	96cff0ef          	jal	ra,8000213e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fd6:	2985                	addiw	s3,s3,1
    80002fd8:	0a91                	addi	s5,s5,4
    80002fda:	028a2783          	lw	a5,40(s4)
    80002fde:	04f9d363          	bge	s3,a5,80003024 <install_trans+0xae>
    if(recovering) {
    80002fe2:	fc0b1ae3          	bnez	s6,80002fb6 <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fe6:	018a2583          	lw	a1,24(s4)
    80002fea:	013585bb          	addw	a1,a1,s3
    80002fee:	2585                	addiw	a1,a1,1
    80002ff0:	024a2503          	lw	a0,36(s4)
    80002ff4:	842ff0ef          	jal	ra,80002036 <bread>
    80002ff8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002ffa:	000aa583          	lw	a1,0(s5)
    80002ffe:	024a2503          	lw	a0,36(s4)
    80003002:	834ff0ef          	jal	ra,80002036 <bread>
    80003006:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003008:	40000613          	li	a2,1024
    8000300c:	05890593          	addi	a1,s2,88
    80003010:	05850513          	addi	a0,a0,88
    80003014:	998fd0ef          	jal	ra,800001ac <memmove>
    bwrite(dbuf);  // write dst to disk
    80003018:	8526                	mv	a0,s1
    8000301a:	8f2ff0ef          	jal	ra,8000210c <bwrite>
    if(recovering == 0)
    8000301e:	fa0b16e3          	bnez	s6,80002fca <install_trans+0x54>
    80003022:	b74d                	j	80002fc4 <install_trans+0x4e>
}
    80003024:	60a6                	ld	ra,72(sp)
    80003026:	6406                	ld	s0,64(sp)
    80003028:	74e2                	ld	s1,56(sp)
    8000302a:	7942                	ld	s2,48(sp)
    8000302c:	79a2                	ld	s3,40(sp)
    8000302e:	7a02                	ld	s4,32(sp)
    80003030:	6ae2                	ld	s5,24(sp)
    80003032:	6b42                	ld	s6,16(sp)
    80003034:	6ba2                	ld	s7,8(sp)
    80003036:	6161                	addi	sp,sp,80
    80003038:	8082                	ret
    8000303a:	8082                	ret

000000008000303c <initlog>:
{
    8000303c:	7179                	addi	sp,sp,-48
    8000303e:	f406                	sd	ra,40(sp)
    80003040:	f022                	sd	s0,32(sp)
    80003042:	ec26                	sd	s1,24(sp)
    80003044:	e84a                	sd	s2,16(sp)
    80003046:	e44e                	sd	s3,8(sp)
    80003048:	1800                	addi	s0,sp,48
    8000304a:	892a                	mv	s2,a0
    8000304c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000304e:	00015497          	auipc	s1,0x15
    80003052:	84248493          	addi	s1,s1,-1982 # 80017890 <log>
    80003056:	00004597          	auipc	a1,0x4
    8000305a:	55a58593          	addi	a1,a1,1370 # 800075b0 <syscalls+0x220>
    8000305e:	8526                	mv	a0,s1
    80003060:	700020ef          	jal	ra,80005760 <initlock>
  log.start = sb->logstart;
    80003064:	0149a583          	lw	a1,20(s3)
    80003068:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    8000306a:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000306e:	854a                	mv	a0,s2
    80003070:	fc7fe0ef          	jal	ra,80002036 <bread>
  log.lh.n = lh->n;
    80003074:	4d3c                	lw	a5,88(a0)
    80003076:	d49c                	sw	a5,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003078:	02f05563          	blez	a5,800030a2 <initlog+0x66>
    8000307c:	05c50713          	addi	a4,a0,92
    80003080:	00015697          	auipc	a3,0x15
    80003084:	83c68693          	addi	a3,a3,-1988 # 800178bc <log+0x2c>
    80003088:	37fd                	addiw	a5,a5,-1
    8000308a:	1782                	slli	a5,a5,0x20
    8000308c:	9381                	srli	a5,a5,0x20
    8000308e:	078a                	slli	a5,a5,0x2
    80003090:	06050613          	addi	a2,a0,96
    80003094:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003096:	4310                	lw	a2,0(a4)
    80003098:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000309a:	0711                	addi	a4,a4,4
    8000309c:	0691                	addi	a3,a3,4
    8000309e:	fef71ce3          	bne	a4,a5,80003096 <initlog+0x5a>
  brelse(buf);
    800030a2:	89cff0ef          	jal	ra,8000213e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800030a6:	4505                	li	a0,1
    800030a8:	ecfff0ef          	jal	ra,80002f76 <install_trans>
  log.lh.n = 0;
    800030ac:	00015797          	auipc	a5,0x15
    800030b0:	8007a623          	sw	zero,-2036(a5) # 800178b8 <log+0x28>
  write_head(); // clear the log
    800030b4:	e55ff0ef          	jal	ra,80002f08 <write_head>
}
    800030b8:	70a2                	ld	ra,40(sp)
    800030ba:	7402                	ld	s0,32(sp)
    800030bc:	64e2                	ld	s1,24(sp)
    800030be:	6942                	ld	s2,16(sp)
    800030c0:	69a2                	ld	s3,8(sp)
    800030c2:	6145                	addi	sp,sp,48
    800030c4:	8082                	ret

00000000800030c6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800030c6:	1101                	addi	sp,sp,-32
    800030c8:	ec06                	sd	ra,24(sp)
    800030ca:	e822                	sd	s0,16(sp)
    800030cc:	e426                	sd	s1,8(sp)
    800030ce:	e04a                	sd	s2,0(sp)
    800030d0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800030d2:	00014517          	auipc	a0,0x14
    800030d6:	7be50513          	addi	a0,a0,1982 # 80017890 <log>
    800030da:	706020ef          	jal	ra,800057e0 <acquire>
  while(1){
    if(log.committing){
    800030de:	00014497          	auipc	s1,0x14
    800030e2:	7b248493          	addi	s1,s1,1970 # 80017890 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800030e6:	4979                	li	s2,30
    800030e8:	a029                	j	800030f2 <begin_op+0x2c>
      sleep(&log, &log.lock);
    800030ea:	85a6                	mv	a1,s1
    800030ec:	8526                	mv	a0,s1
    800030ee:	a3cfe0ef          	jal	ra,8000132a <sleep>
    if(log.committing){
    800030f2:	509c                	lw	a5,32(s1)
    800030f4:	fbfd                	bnez	a5,800030ea <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800030f6:	4cdc                	lw	a5,28(s1)
    800030f8:	0017871b          	addiw	a4,a5,1
    800030fc:	0007069b          	sext.w	a3,a4
    80003100:	0027179b          	slliw	a5,a4,0x2
    80003104:	9fb9                	addw	a5,a5,a4
    80003106:	0017979b          	slliw	a5,a5,0x1
    8000310a:	5498                	lw	a4,40(s1)
    8000310c:	9fb9                	addw	a5,a5,a4
    8000310e:	00f95763          	bge	s2,a5,8000311c <begin_op+0x56>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003112:	85a6                	mv	a1,s1
    80003114:	8526                	mv	a0,s1
    80003116:	a14fe0ef          	jal	ra,8000132a <sleep>
    8000311a:	bfe1                	j	800030f2 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000311c:	00014517          	auipc	a0,0x14
    80003120:	77450513          	addi	a0,a0,1908 # 80017890 <log>
    80003124:	cd54                	sw	a3,28(a0)
      release(&log.lock);
    80003126:	752020ef          	jal	ra,80005878 <release>
      break;
    }
  }
}
    8000312a:	60e2                	ld	ra,24(sp)
    8000312c:	6442                	ld	s0,16(sp)
    8000312e:	64a2                	ld	s1,8(sp)
    80003130:	6902                	ld	s2,0(sp)
    80003132:	6105                	addi	sp,sp,32
    80003134:	8082                	ret

0000000080003136 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003136:	7139                	addi	sp,sp,-64
    80003138:	fc06                	sd	ra,56(sp)
    8000313a:	f822                	sd	s0,48(sp)
    8000313c:	f426                	sd	s1,40(sp)
    8000313e:	f04a                	sd	s2,32(sp)
    80003140:	ec4e                	sd	s3,24(sp)
    80003142:	e852                	sd	s4,16(sp)
    80003144:	e456                	sd	s5,8(sp)
    80003146:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003148:	00014497          	auipc	s1,0x14
    8000314c:	74848493          	addi	s1,s1,1864 # 80017890 <log>
    80003150:	8526                	mv	a0,s1
    80003152:	68e020ef          	jal	ra,800057e0 <acquire>
  log.outstanding -= 1;
    80003156:	4cdc                	lw	a5,28(s1)
    80003158:	37fd                	addiw	a5,a5,-1
    8000315a:	0007891b          	sext.w	s2,a5
    8000315e:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003160:	509c                	lw	a5,32(s1)
    80003162:	e7b9                	bnez	a5,800031b0 <end_op+0x7a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003164:	04091c63          	bnez	s2,800031bc <end_op+0x86>
    do_commit = 1;
    log.committing = 1;
    80003168:	00014497          	auipc	s1,0x14
    8000316c:	72848493          	addi	s1,s1,1832 # 80017890 <log>
    80003170:	4785                	li	a5,1
    80003172:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003174:	8526                	mv	a0,s1
    80003176:	702020ef          	jal	ra,80005878 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000317a:	549c                	lw	a5,40(s1)
    8000317c:	04f04b63          	bgtz	a5,800031d2 <end_op+0x9c>
    acquire(&log.lock);
    80003180:	00014497          	auipc	s1,0x14
    80003184:	71048493          	addi	s1,s1,1808 # 80017890 <log>
    80003188:	8526                	mv	a0,s1
    8000318a:	656020ef          	jal	ra,800057e0 <acquire>
    log.committing = 0;
    8000318e:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003192:	8526                	mv	a0,s1
    80003194:	9e2fe0ef          	jal	ra,80001376 <wakeup>
    release(&log.lock);
    80003198:	8526                	mv	a0,s1
    8000319a:	6de020ef          	jal	ra,80005878 <release>
}
    8000319e:	70e2                	ld	ra,56(sp)
    800031a0:	7442                	ld	s0,48(sp)
    800031a2:	74a2                	ld	s1,40(sp)
    800031a4:	7902                	ld	s2,32(sp)
    800031a6:	69e2                	ld	s3,24(sp)
    800031a8:	6a42                	ld	s4,16(sp)
    800031aa:	6aa2                	ld	s5,8(sp)
    800031ac:	6121                	addi	sp,sp,64
    800031ae:	8082                	ret
    panic("log.committing");
    800031b0:	00004517          	auipc	a0,0x4
    800031b4:	40850513          	addi	a0,a0,1032 # 800075b8 <syscalls+0x228>
    800031b8:	36e020ef          	jal	ra,80005526 <panic>
    wakeup(&log);
    800031bc:	00014497          	auipc	s1,0x14
    800031c0:	6d448493          	addi	s1,s1,1748 # 80017890 <log>
    800031c4:	8526                	mv	a0,s1
    800031c6:	9b0fe0ef          	jal	ra,80001376 <wakeup>
  release(&log.lock);
    800031ca:	8526                	mv	a0,s1
    800031cc:	6ac020ef          	jal	ra,80005878 <release>
  if(do_commit){
    800031d0:	b7f9                	j	8000319e <end_op+0x68>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031d2:	00014a97          	auipc	s5,0x14
    800031d6:	6eaa8a93          	addi	s5,s5,1770 # 800178bc <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800031da:	00014a17          	auipc	s4,0x14
    800031de:	6b6a0a13          	addi	s4,s4,1718 # 80017890 <log>
    800031e2:	018a2583          	lw	a1,24(s4)
    800031e6:	012585bb          	addw	a1,a1,s2
    800031ea:	2585                	addiw	a1,a1,1
    800031ec:	024a2503          	lw	a0,36(s4)
    800031f0:	e47fe0ef          	jal	ra,80002036 <bread>
    800031f4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800031f6:	000aa583          	lw	a1,0(s5)
    800031fa:	024a2503          	lw	a0,36(s4)
    800031fe:	e39fe0ef          	jal	ra,80002036 <bread>
    80003202:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003204:	40000613          	li	a2,1024
    80003208:	05850593          	addi	a1,a0,88
    8000320c:	05848513          	addi	a0,s1,88
    80003210:	f9dfc0ef          	jal	ra,800001ac <memmove>
    bwrite(to);  // write the log
    80003214:	8526                	mv	a0,s1
    80003216:	ef7fe0ef          	jal	ra,8000210c <bwrite>
    brelse(from);
    8000321a:	854e                	mv	a0,s3
    8000321c:	f23fe0ef          	jal	ra,8000213e <brelse>
    brelse(to);
    80003220:	8526                	mv	a0,s1
    80003222:	f1dfe0ef          	jal	ra,8000213e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003226:	2905                	addiw	s2,s2,1
    80003228:	0a91                	addi	s5,s5,4
    8000322a:	028a2783          	lw	a5,40(s4)
    8000322e:	faf94ae3          	blt	s2,a5,800031e2 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003232:	cd7ff0ef          	jal	ra,80002f08 <write_head>
    install_trans(0); // Now install writes to home locations
    80003236:	4501                	li	a0,0
    80003238:	d3fff0ef          	jal	ra,80002f76 <install_trans>
    log.lh.n = 0;
    8000323c:	00014797          	auipc	a5,0x14
    80003240:	6607ae23          	sw	zero,1660(a5) # 800178b8 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003244:	cc5ff0ef          	jal	ra,80002f08 <write_head>
    80003248:	bf25                	j	80003180 <end_op+0x4a>

000000008000324a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000324a:	1101                	addi	sp,sp,-32
    8000324c:	ec06                	sd	ra,24(sp)
    8000324e:	e822                	sd	s0,16(sp)
    80003250:	e426                	sd	s1,8(sp)
    80003252:	e04a                	sd	s2,0(sp)
    80003254:	1000                	addi	s0,sp,32
    80003256:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003258:	00014917          	auipc	s2,0x14
    8000325c:	63890913          	addi	s2,s2,1592 # 80017890 <log>
    80003260:	854a                	mv	a0,s2
    80003262:	57e020ef          	jal	ra,800057e0 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003266:	02892603          	lw	a2,40(s2)
    8000326a:	47f5                	li	a5,29
    8000326c:	04c7cc63          	blt	a5,a2,800032c4 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003270:	00014797          	auipc	a5,0x14
    80003274:	63c7a783          	lw	a5,1596(a5) # 800178ac <log+0x1c>
    80003278:	04f05c63          	blez	a5,800032d0 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000327c:	4781                	li	a5,0
    8000327e:	04c05f63          	blez	a2,800032dc <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003282:	44cc                	lw	a1,12(s1)
    80003284:	00014717          	auipc	a4,0x14
    80003288:	63870713          	addi	a4,a4,1592 # 800178bc <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    8000328c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000328e:	4314                	lw	a3,0(a4)
    80003290:	04b68663          	beq	a3,a1,800032dc <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003294:	2785                	addiw	a5,a5,1
    80003296:	0711                	addi	a4,a4,4
    80003298:	fef61be3          	bne	a2,a5,8000328e <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000329c:	0621                	addi	a2,a2,8
    8000329e:	060a                	slli	a2,a2,0x2
    800032a0:	00014797          	auipc	a5,0x14
    800032a4:	5f078793          	addi	a5,a5,1520 # 80017890 <log>
    800032a8:	963e                	add	a2,a2,a5
    800032aa:	44dc                	lw	a5,12(s1)
    800032ac:	c65c                	sw	a5,12(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800032ae:	8526                	mv	a0,s1
    800032b0:	f19fe0ef          	jal	ra,800021c8 <bpin>
    log.lh.n++;
    800032b4:	00014717          	auipc	a4,0x14
    800032b8:	5dc70713          	addi	a4,a4,1500 # 80017890 <log>
    800032bc:	571c                	lw	a5,40(a4)
    800032be:	2785                	addiw	a5,a5,1
    800032c0:	d71c                	sw	a5,40(a4)
    800032c2:	a815                	j	800032f6 <log_write+0xac>
    panic("too big a transaction");
    800032c4:	00004517          	auipc	a0,0x4
    800032c8:	30450513          	addi	a0,a0,772 # 800075c8 <syscalls+0x238>
    800032cc:	25a020ef          	jal	ra,80005526 <panic>
    panic("log_write outside of trans");
    800032d0:	00004517          	auipc	a0,0x4
    800032d4:	31050513          	addi	a0,a0,784 # 800075e0 <syscalls+0x250>
    800032d8:	24e020ef          	jal	ra,80005526 <panic>
  log.lh.block[i] = b->blockno;
    800032dc:	00878713          	addi	a4,a5,8
    800032e0:	00271693          	slli	a3,a4,0x2
    800032e4:	00014717          	auipc	a4,0x14
    800032e8:	5ac70713          	addi	a4,a4,1452 # 80017890 <log>
    800032ec:	9736                	add	a4,a4,a3
    800032ee:	44d4                	lw	a3,12(s1)
    800032f0:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800032f2:	faf60ee3          	beq	a2,a5,800032ae <log_write+0x64>
  }
  release(&log.lock);
    800032f6:	00014517          	auipc	a0,0x14
    800032fa:	59a50513          	addi	a0,a0,1434 # 80017890 <log>
    800032fe:	57a020ef          	jal	ra,80005878 <release>
}
    80003302:	60e2                	ld	ra,24(sp)
    80003304:	6442                	ld	s0,16(sp)
    80003306:	64a2                	ld	s1,8(sp)
    80003308:	6902                	ld	s2,0(sp)
    8000330a:	6105                	addi	sp,sp,32
    8000330c:	8082                	ret

000000008000330e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000330e:	1101                	addi	sp,sp,-32
    80003310:	ec06                	sd	ra,24(sp)
    80003312:	e822                	sd	s0,16(sp)
    80003314:	e426                	sd	s1,8(sp)
    80003316:	e04a                	sd	s2,0(sp)
    80003318:	1000                	addi	s0,sp,32
    8000331a:	84aa                	mv	s1,a0
    8000331c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000331e:	00004597          	auipc	a1,0x4
    80003322:	2e258593          	addi	a1,a1,738 # 80007600 <syscalls+0x270>
    80003326:	0521                	addi	a0,a0,8
    80003328:	438020ef          	jal	ra,80005760 <initlock>
  lk->name = name;
    8000332c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003330:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003334:	0204a423          	sw	zero,40(s1)
}
    80003338:	60e2                	ld	ra,24(sp)
    8000333a:	6442                	ld	s0,16(sp)
    8000333c:	64a2                	ld	s1,8(sp)
    8000333e:	6902                	ld	s2,0(sp)
    80003340:	6105                	addi	sp,sp,32
    80003342:	8082                	ret

0000000080003344 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003344:	1101                	addi	sp,sp,-32
    80003346:	ec06                	sd	ra,24(sp)
    80003348:	e822                	sd	s0,16(sp)
    8000334a:	e426                	sd	s1,8(sp)
    8000334c:	e04a                	sd	s2,0(sp)
    8000334e:	1000                	addi	s0,sp,32
    80003350:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003352:	00850913          	addi	s2,a0,8
    80003356:	854a                	mv	a0,s2
    80003358:	488020ef          	jal	ra,800057e0 <acquire>
  while (lk->locked) {
    8000335c:	409c                	lw	a5,0(s1)
    8000335e:	c799                	beqz	a5,8000336c <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003360:	85ca                	mv	a1,s2
    80003362:	8526                	mv	a0,s1
    80003364:	fc7fd0ef          	jal	ra,8000132a <sleep>
  while (lk->locked) {
    80003368:	409c                	lw	a5,0(s1)
    8000336a:	fbfd                	bnez	a5,80003360 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000336c:	4785                	li	a5,1
    8000336e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003370:	9c9fd0ef          	jal	ra,80000d38 <myproc>
    80003374:	591c                	lw	a5,48(a0)
    80003376:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003378:	854a                	mv	a0,s2
    8000337a:	4fe020ef          	jal	ra,80005878 <release>
}
    8000337e:	60e2                	ld	ra,24(sp)
    80003380:	6442                	ld	s0,16(sp)
    80003382:	64a2                	ld	s1,8(sp)
    80003384:	6902                	ld	s2,0(sp)
    80003386:	6105                	addi	sp,sp,32
    80003388:	8082                	ret

000000008000338a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000338a:	1101                	addi	sp,sp,-32
    8000338c:	ec06                	sd	ra,24(sp)
    8000338e:	e822                	sd	s0,16(sp)
    80003390:	e426                	sd	s1,8(sp)
    80003392:	e04a                	sd	s2,0(sp)
    80003394:	1000                	addi	s0,sp,32
    80003396:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003398:	00850913          	addi	s2,a0,8
    8000339c:	854a                	mv	a0,s2
    8000339e:	442020ef          	jal	ra,800057e0 <acquire>
  lk->locked = 0;
    800033a2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800033a6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800033aa:	8526                	mv	a0,s1
    800033ac:	fcbfd0ef          	jal	ra,80001376 <wakeup>
  release(&lk->lk);
    800033b0:	854a                	mv	a0,s2
    800033b2:	4c6020ef          	jal	ra,80005878 <release>
}
    800033b6:	60e2                	ld	ra,24(sp)
    800033b8:	6442                	ld	s0,16(sp)
    800033ba:	64a2                	ld	s1,8(sp)
    800033bc:	6902                	ld	s2,0(sp)
    800033be:	6105                	addi	sp,sp,32
    800033c0:	8082                	ret

00000000800033c2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800033c2:	7179                	addi	sp,sp,-48
    800033c4:	f406                	sd	ra,40(sp)
    800033c6:	f022                	sd	s0,32(sp)
    800033c8:	ec26                	sd	s1,24(sp)
    800033ca:	e84a                	sd	s2,16(sp)
    800033cc:	e44e                	sd	s3,8(sp)
    800033ce:	1800                	addi	s0,sp,48
    800033d0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800033d2:	00850913          	addi	s2,a0,8
    800033d6:	854a                	mv	a0,s2
    800033d8:	408020ef          	jal	ra,800057e0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800033dc:	409c                	lw	a5,0(s1)
    800033de:	ef89                	bnez	a5,800033f8 <holdingsleep+0x36>
    800033e0:	4481                	li	s1,0
  release(&lk->lk);
    800033e2:	854a                	mv	a0,s2
    800033e4:	494020ef          	jal	ra,80005878 <release>
  return r;
}
    800033e8:	8526                	mv	a0,s1
    800033ea:	70a2                	ld	ra,40(sp)
    800033ec:	7402                	ld	s0,32(sp)
    800033ee:	64e2                	ld	s1,24(sp)
    800033f0:	6942                	ld	s2,16(sp)
    800033f2:	69a2                	ld	s3,8(sp)
    800033f4:	6145                	addi	sp,sp,48
    800033f6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800033f8:	0284a983          	lw	s3,40(s1)
    800033fc:	93dfd0ef          	jal	ra,80000d38 <myproc>
    80003400:	5904                	lw	s1,48(a0)
    80003402:	413484b3          	sub	s1,s1,s3
    80003406:	0014b493          	seqz	s1,s1
    8000340a:	bfe1                	j	800033e2 <holdingsleep+0x20>

000000008000340c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000340c:	1141                	addi	sp,sp,-16
    8000340e:	e406                	sd	ra,8(sp)
    80003410:	e022                	sd	s0,0(sp)
    80003412:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003414:	00004597          	auipc	a1,0x4
    80003418:	1fc58593          	addi	a1,a1,508 # 80007610 <syscalls+0x280>
    8000341c:	00014517          	auipc	a0,0x14
    80003420:	5bc50513          	addi	a0,a0,1468 # 800179d8 <ftable>
    80003424:	33c020ef          	jal	ra,80005760 <initlock>
}
    80003428:	60a2                	ld	ra,8(sp)
    8000342a:	6402                	ld	s0,0(sp)
    8000342c:	0141                	addi	sp,sp,16
    8000342e:	8082                	ret

0000000080003430 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003430:	1101                	addi	sp,sp,-32
    80003432:	ec06                	sd	ra,24(sp)
    80003434:	e822                	sd	s0,16(sp)
    80003436:	e426                	sd	s1,8(sp)
    80003438:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000343a:	00014517          	auipc	a0,0x14
    8000343e:	59e50513          	addi	a0,a0,1438 # 800179d8 <ftable>
    80003442:	39e020ef          	jal	ra,800057e0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003446:	00014497          	auipc	s1,0x14
    8000344a:	5aa48493          	addi	s1,s1,1450 # 800179f0 <ftable+0x18>
    8000344e:	00015717          	auipc	a4,0x15
    80003452:	54270713          	addi	a4,a4,1346 # 80018990 <disk>
    if(f->ref == 0){
    80003456:	40dc                	lw	a5,4(s1)
    80003458:	cf89                	beqz	a5,80003472 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000345a:	02848493          	addi	s1,s1,40
    8000345e:	fee49ce3          	bne	s1,a4,80003456 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003462:	00014517          	auipc	a0,0x14
    80003466:	57650513          	addi	a0,a0,1398 # 800179d8 <ftable>
    8000346a:	40e020ef          	jal	ra,80005878 <release>
  return 0;
    8000346e:	4481                	li	s1,0
    80003470:	a809                	j	80003482 <filealloc+0x52>
      f->ref = 1;
    80003472:	4785                	li	a5,1
    80003474:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003476:	00014517          	auipc	a0,0x14
    8000347a:	56250513          	addi	a0,a0,1378 # 800179d8 <ftable>
    8000347e:	3fa020ef          	jal	ra,80005878 <release>
}
    80003482:	8526                	mv	a0,s1
    80003484:	60e2                	ld	ra,24(sp)
    80003486:	6442                	ld	s0,16(sp)
    80003488:	64a2                	ld	s1,8(sp)
    8000348a:	6105                	addi	sp,sp,32
    8000348c:	8082                	ret

000000008000348e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000348e:	1101                	addi	sp,sp,-32
    80003490:	ec06                	sd	ra,24(sp)
    80003492:	e822                	sd	s0,16(sp)
    80003494:	e426                	sd	s1,8(sp)
    80003496:	1000                	addi	s0,sp,32
    80003498:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000349a:	00014517          	auipc	a0,0x14
    8000349e:	53e50513          	addi	a0,a0,1342 # 800179d8 <ftable>
    800034a2:	33e020ef          	jal	ra,800057e0 <acquire>
  if(f->ref < 1)
    800034a6:	40dc                	lw	a5,4(s1)
    800034a8:	02f05063          	blez	a5,800034c8 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800034ac:	2785                	addiw	a5,a5,1
    800034ae:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800034b0:	00014517          	auipc	a0,0x14
    800034b4:	52850513          	addi	a0,a0,1320 # 800179d8 <ftable>
    800034b8:	3c0020ef          	jal	ra,80005878 <release>
  return f;
}
    800034bc:	8526                	mv	a0,s1
    800034be:	60e2                	ld	ra,24(sp)
    800034c0:	6442                	ld	s0,16(sp)
    800034c2:	64a2                	ld	s1,8(sp)
    800034c4:	6105                	addi	sp,sp,32
    800034c6:	8082                	ret
    panic("filedup");
    800034c8:	00004517          	auipc	a0,0x4
    800034cc:	15050513          	addi	a0,a0,336 # 80007618 <syscalls+0x288>
    800034d0:	056020ef          	jal	ra,80005526 <panic>

00000000800034d4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800034d4:	7139                	addi	sp,sp,-64
    800034d6:	fc06                	sd	ra,56(sp)
    800034d8:	f822                	sd	s0,48(sp)
    800034da:	f426                	sd	s1,40(sp)
    800034dc:	f04a                	sd	s2,32(sp)
    800034de:	ec4e                	sd	s3,24(sp)
    800034e0:	e852                	sd	s4,16(sp)
    800034e2:	e456                	sd	s5,8(sp)
    800034e4:	0080                	addi	s0,sp,64
    800034e6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800034e8:	00014517          	auipc	a0,0x14
    800034ec:	4f050513          	addi	a0,a0,1264 # 800179d8 <ftable>
    800034f0:	2f0020ef          	jal	ra,800057e0 <acquire>
  if(f->ref < 1)
    800034f4:	40dc                	lw	a5,4(s1)
    800034f6:	04f05963          	blez	a5,80003548 <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    800034fa:	37fd                	addiw	a5,a5,-1
    800034fc:	0007871b          	sext.w	a4,a5
    80003500:	c0dc                	sw	a5,4(s1)
    80003502:	04e04963          	bgtz	a4,80003554 <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003506:	0004a903          	lw	s2,0(s1)
    8000350a:	0094ca83          	lbu	s5,9(s1)
    8000350e:	0104ba03          	ld	s4,16(s1)
    80003512:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003516:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000351a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000351e:	00014517          	auipc	a0,0x14
    80003522:	4ba50513          	addi	a0,a0,1210 # 800179d8 <ftable>
    80003526:	352020ef          	jal	ra,80005878 <release>

  if(ff.type == FD_PIPE){
    8000352a:	4785                	li	a5,1
    8000352c:	04f90363          	beq	s2,a5,80003572 <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003530:	3979                	addiw	s2,s2,-2
    80003532:	4785                	li	a5,1
    80003534:	0327e663          	bltu	a5,s2,80003560 <fileclose+0x8c>
    begin_op();
    80003538:	b8fff0ef          	jal	ra,800030c6 <begin_op>
    iput(ff.ip);
    8000353c:	854e                	mv	a0,s3
    8000353e:	b28ff0ef          	jal	ra,80002866 <iput>
    end_op();
    80003542:	bf5ff0ef          	jal	ra,80003136 <end_op>
    80003546:	a829                	j	80003560 <fileclose+0x8c>
    panic("fileclose");
    80003548:	00004517          	auipc	a0,0x4
    8000354c:	0d850513          	addi	a0,a0,216 # 80007620 <syscalls+0x290>
    80003550:	7d7010ef          	jal	ra,80005526 <panic>
    release(&ftable.lock);
    80003554:	00014517          	auipc	a0,0x14
    80003558:	48450513          	addi	a0,a0,1156 # 800179d8 <ftable>
    8000355c:	31c020ef          	jal	ra,80005878 <release>
  }
}
    80003560:	70e2                	ld	ra,56(sp)
    80003562:	7442                	ld	s0,48(sp)
    80003564:	74a2                	ld	s1,40(sp)
    80003566:	7902                	ld	s2,32(sp)
    80003568:	69e2                	ld	s3,24(sp)
    8000356a:	6a42                	ld	s4,16(sp)
    8000356c:	6aa2                	ld	s5,8(sp)
    8000356e:	6121                	addi	sp,sp,64
    80003570:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003572:	85d6                	mv	a1,s5
    80003574:	8552                	mv	a0,s4
    80003576:	2ec000ef          	jal	ra,80003862 <pipeclose>
    8000357a:	b7dd                	j	80003560 <fileclose+0x8c>

000000008000357c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000357c:	715d                	addi	sp,sp,-80
    8000357e:	e486                	sd	ra,72(sp)
    80003580:	e0a2                	sd	s0,64(sp)
    80003582:	fc26                	sd	s1,56(sp)
    80003584:	f84a                	sd	s2,48(sp)
    80003586:	f44e                	sd	s3,40(sp)
    80003588:	0880                	addi	s0,sp,80
    8000358a:	84aa                	mv	s1,a0
    8000358c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000358e:	faafd0ef          	jal	ra,80000d38 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003592:	409c                	lw	a5,0(s1)
    80003594:	37f9                	addiw	a5,a5,-2
    80003596:	4705                	li	a4,1
    80003598:	02f76f63          	bltu	a4,a5,800035d6 <filestat+0x5a>
    8000359c:	892a                	mv	s2,a0
    ilock(f->ip);
    8000359e:	6c88                	ld	a0,24(s1)
    800035a0:	948ff0ef          	jal	ra,800026e8 <ilock>
    stati(f->ip, &st);
    800035a4:	fb840593          	addi	a1,s0,-72
    800035a8:	6c88                	ld	a0,24(s1)
    800035aa:	ca0ff0ef          	jal	ra,80002a4a <stati>
    iunlock(f->ip);
    800035ae:	6c88                	ld	a0,24(s1)
    800035b0:	9e2ff0ef          	jal	ra,80002792 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800035b4:	46e1                	li	a3,24
    800035b6:	fb840613          	addi	a2,s0,-72
    800035ba:	85ce                	mv	a1,s3
    800035bc:	05093503          	ld	a0,80(s2)
    800035c0:	cc0fd0ef          	jal	ra,80000a80 <copyout>
    800035c4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800035c8:	60a6                	ld	ra,72(sp)
    800035ca:	6406                	ld	s0,64(sp)
    800035cc:	74e2                	ld	s1,56(sp)
    800035ce:	7942                	ld	s2,48(sp)
    800035d0:	79a2                	ld	s3,40(sp)
    800035d2:	6161                	addi	sp,sp,80
    800035d4:	8082                	ret
  return -1;
    800035d6:	557d                	li	a0,-1
    800035d8:	bfc5                	j	800035c8 <filestat+0x4c>

00000000800035da <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800035da:	7179                	addi	sp,sp,-48
    800035dc:	f406                	sd	ra,40(sp)
    800035de:	f022                	sd	s0,32(sp)
    800035e0:	ec26                	sd	s1,24(sp)
    800035e2:	e84a                	sd	s2,16(sp)
    800035e4:	e44e                	sd	s3,8(sp)
    800035e6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800035e8:	00854783          	lbu	a5,8(a0)
    800035ec:	cbc1                	beqz	a5,8000367c <fileread+0xa2>
    800035ee:	84aa                	mv	s1,a0
    800035f0:	89ae                	mv	s3,a1
    800035f2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800035f4:	411c                	lw	a5,0(a0)
    800035f6:	4705                	li	a4,1
    800035f8:	04e78363          	beq	a5,a4,8000363e <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035fc:	470d                	li	a4,3
    800035fe:	04e78563          	beq	a5,a4,80003648 <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003602:	4709                	li	a4,2
    80003604:	06e79663          	bne	a5,a4,80003670 <fileread+0x96>
    ilock(f->ip);
    80003608:	6d08                	ld	a0,24(a0)
    8000360a:	8deff0ef          	jal	ra,800026e8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000360e:	874a                	mv	a4,s2
    80003610:	5094                	lw	a3,32(s1)
    80003612:	864e                	mv	a2,s3
    80003614:	4585                	li	a1,1
    80003616:	6c88                	ld	a0,24(s1)
    80003618:	c5cff0ef          	jal	ra,80002a74 <readi>
    8000361c:	892a                	mv	s2,a0
    8000361e:	00a05563          	blez	a0,80003628 <fileread+0x4e>
      f->off += r;
    80003622:	509c                	lw	a5,32(s1)
    80003624:	9fa9                	addw	a5,a5,a0
    80003626:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003628:	6c88                	ld	a0,24(s1)
    8000362a:	968ff0ef          	jal	ra,80002792 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000362e:	854a                	mv	a0,s2
    80003630:	70a2                	ld	ra,40(sp)
    80003632:	7402                	ld	s0,32(sp)
    80003634:	64e2                	ld	s1,24(sp)
    80003636:	6942                	ld	s2,16(sp)
    80003638:	69a2                	ld	s3,8(sp)
    8000363a:	6145                	addi	sp,sp,48
    8000363c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000363e:	6908                	ld	a0,16(a0)
    80003640:	356000ef          	jal	ra,80003996 <piperead>
    80003644:	892a                	mv	s2,a0
    80003646:	b7e5                	j	8000362e <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003648:	02451783          	lh	a5,36(a0)
    8000364c:	03079693          	slli	a3,a5,0x30
    80003650:	92c1                	srli	a3,a3,0x30
    80003652:	4725                	li	a4,9
    80003654:	02d76663          	bltu	a4,a3,80003680 <fileread+0xa6>
    80003658:	0792                	slli	a5,a5,0x4
    8000365a:	00014717          	auipc	a4,0x14
    8000365e:	2de70713          	addi	a4,a4,734 # 80017938 <devsw>
    80003662:	97ba                	add	a5,a5,a4
    80003664:	639c                	ld	a5,0(a5)
    80003666:	cf99                	beqz	a5,80003684 <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    80003668:	4505                	li	a0,1
    8000366a:	9782                	jalr	a5
    8000366c:	892a                	mv	s2,a0
    8000366e:	b7c1                	j	8000362e <fileread+0x54>
    panic("fileread");
    80003670:	00004517          	auipc	a0,0x4
    80003674:	fc050513          	addi	a0,a0,-64 # 80007630 <syscalls+0x2a0>
    80003678:	6af010ef          	jal	ra,80005526 <panic>
    return -1;
    8000367c:	597d                	li	s2,-1
    8000367e:	bf45                	j	8000362e <fileread+0x54>
      return -1;
    80003680:	597d                	li	s2,-1
    80003682:	b775                	j	8000362e <fileread+0x54>
    80003684:	597d                	li	s2,-1
    80003686:	b765                	j	8000362e <fileread+0x54>

0000000080003688 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003688:	715d                	addi	sp,sp,-80
    8000368a:	e486                	sd	ra,72(sp)
    8000368c:	e0a2                	sd	s0,64(sp)
    8000368e:	fc26                	sd	s1,56(sp)
    80003690:	f84a                	sd	s2,48(sp)
    80003692:	f44e                	sd	s3,40(sp)
    80003694:	f052                	sd	s4,32(sp)
    80003696:	ec56                	sd	s5,24(sp)
    80003698:	e85a                	sd	s6,16(sp)
    8000369a:	e45e                	sd	s7,8(sp)
    8000369c:	e062                	sd	s8,0(sp)
    8000369e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800036a0:	00954783          	lbu	a5,9(a0)
    800036a4:	0e078863          	beqz	a5,80003794 <filewrite+0x10c>
    800036a8:	892a                	mv	s2,a0
    800036aa:	8aae                	mv	s5,a1
    800036ac:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800036ae:	411c                	lw	a5,0(a0)
    800036b0:	4705                	li	a4,1
    800036b2:	02e78263          	beq	a5,a4,800036d6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800036b6:	470d                	li	a4,3
    800036b8:	02e78463          	beq	a5,a4,800036e0 <filewrite+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800036bc:	4709                	li	a4,2
    800036be:	0ce79563          	bne	a5,a4,80003788 <filewrite+0x100>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800036c2:	0ac05163          	blez	a2,80003764 <filewrite+0xdc>
    int i = 0;
    800036c6:	4981                	li	s3,0
    800036c8:	6b05                	lui	s6,0x1
    800036ca:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800036ce:	6b85                	lui	s7,0x1
    800036d0:	c00b8b9b          	addiw	s7,s7,-1024
    800036d4:	a041                	j	80003754 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800036d6:	6908                	ld	a0,16(a0)
    800036d8:	1e2000ef          	jal	ra,800038ba <pipewrite>
    800036dc:	8a2a                	mv	s4,a0
    800036de:	a071                	j	8000376a <filewrite+0xe2>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800036e0:	02451783          	lh	a5,36(a0)
    800036e4:	03079693          	slli	a3,a5,0x30
    800036e8:	92c1                	srli	a3,a3,0x30
    800036ea:	4725                	li	a4,9
    800036ec:	0ad76663          	bltu	a4,a3,80003798 <filewrite+0x110>
    800036f0:	0792                	slli	a5,a5,0x4
    800036f2:	00014717          	auipc	a4,0x14
    800036f6:	24670713          	addi	a4,a4,582 # 80017938 <devsw>
    800036fa:	97ba                	add	a5,a5,a4
    800036fc:	679c                	ld	a5,8(a5)
    800036fe:	cfd9                	beqz	a5,8000379c <filewrite+0x114>
    ret = devsw[f->major].write(1, addr, n);
    80003700:	4505                	li	a0,1
    80003702:	9782                	jalr	a5
    80003704:	8a2a                	mv	s4,a0
    80003706:	a095                	j	8000376a <filewrite+0xe2>
    80003708:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000370c:	9bbff0ef          	jal	ra,800030c6 <begin_op>
      ilock(f->ip);
    80003710:	01893503          	ld	a0,24(s2)
    80003714:	fd5fe0ef          	jal	ra,800026e8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003718:	8762                	mv	a4,s8
    8000371a:	02092683          	lw	a3,32(s2)
    8000371e:	01598633          	add	a2,s3,s5
    80003722:	4585                	li	a1,1
    80003724:	01893503          	ld	a0,24(s2)
    80003728:	c30ff0ef          	jal	ra,80002b58 <writei>
    8000372c:	84aa                	mv	s1,a0
    8000372e:	00a05763          	blez	a0,8000373c <filewrite+0xb4>
        f->off += r;
    80003732:	02092783          	lw	a5,32(s2)
    80003736:	9fa9                	addw	a5,a5,a0
    80003738:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000373c:	01893503          	ld	a0,24(s2)
    80003740:	852ff0ef          	jal	ra,80002792 <iunlock>
      end_op();
    80003744:	9f3ff0ef          	jal	ra,80003136 <end_op>

      if(r != n1){
    80003748:	009c1f63          	bne	s8,s1,80003766 <filewrite+0xde>
        // error from writei
        break;
      }
      i += r;
    8000374c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003750:	0149db63          	bge	s3,s4,80003766 <filewrite+0xde>
      int n1 = n - i;
    80003754:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003758:	84be                	mv	s1,a5
    8000375a:	2781                	sext.w	a5,a5
    8000375c:	fafb56e3          	bge	s6,a5,80003708 <filewrite+0x80>
    80003760:	84de                	mv	s1,s7
    80003762:	b75d                	j	80003708 <filewrite+0x80>
    int i = 0;
    80003764:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003766:	013a1f63          	bne	s4,s3,80003784 <filewrite+0xfc>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000376a:	8552                	mv	a0,s4
    8000376c:	60a6                	ld	ra,72(sp)
    8000376e:	6406                	ld	s0,64(sp)
    80003770:	74e2                	ld	s1,56(sp)
    80003772:	7942                	ld	s2,48(sp)
    80003774:	79a2                	ld	s3,40(sp)
    80003776:	7a02                	ld	s4,32(sp)
    80003778:	6ae2                	ld	s5,24(sp)
    8000377a:	6b42                	ld	s6,16(sp)
    8000377c:	6ba2                	ld	s7,8(sp)
    8000377e:	6c02                	ld	s8,0(sp)
    80003780:	6161                	addi	sp,sp,80
    80003782:	8082                	ret
    ret = (i == n ? n : -1);
    80003784:	5a7d                	li	s4,-1
    80003786:	b7d5                	j	8000376a <filewrite+0xe2>
    panic("filewrite");
    80003788:	00004517          	auipc	a0,0x4
    8000378c:	eb850513          	addi	a0,a0,-328 # 80007640 <syscalls+0x2b0>
    80003790:	597010ef          	jal	ra,80005526 <panic>
    return -1;
    80003794:	5a7d                	li	s4,-1
    80003796:	bfd1                	j	8000376a <filewrite+0xe2>
      return -1;
    80003798:	5a7d                	li	s4,-1
    8000379a:	bfc1                	j	8000376a <filewrite+0xe2>
    8000379c:	5a7d                	li	s4,-1
    8000379e:	b7f1                	j	8000376a <filewrite+0xe2>

00000000800037a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800037a0:	7179                	addi	sp,sp,-48
    800037a2:	f406                	sd	ra,40(sp)
    800037a4:	f022                	sd	s0,32(sp)
    800037a6:	ec26                	sd	s1,24(sp)
    800037a8:	e84a                	sd	s2,16(sp)
    800037aa:	e44e                	sd	s3,8(sp)
    800037ac:	e052                	sd	s4,0(sp)
    800037ae:	1800                	addi	s0,sp,48
    800037b0:	84aa                	mv	s1,a0
    800037b2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800037b4:	0005b023          	sd	zero,0(a1)
    800037b8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800037bc:	c75ff0ef          	jal	ra,80003430 <filealloc>
    800037c0:	e088                	sd	a0,0(s1)
    800037c2:	cd35                	beqz	a0,8000383e <pipealloc+0x9e>
    800037c4:	c6dff0ef          	jal	ra,80003430 <filealloc>
    800037c8:	00aa3023          	sd	a0,0(s4)
    800037cc:	c52d                	beqz	a0,80003836 <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800037ce:	92ffc0ef          	jal	ra,800000fc <kalloc>
    800037d2:	892a                	mv	s2,a0
    800037d4:	cd31                	beqz	a0,80003830 <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    800037d6:	4985                	li	s3,1
    800037d8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800037dc:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800037e0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800037e4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800037e8:	00004597          	auipc	a1,0x4
    800037ec:	e6858593          	addi	a1,a1,-408 # 80007650 <syscalls+0x2c0>
    800037f0:	771010ef          	jal	ra,80005760 <initlock>
  (*f0)->type = FD_PIPE;
    800037f4:	609c                	ld	a5,0(s1)
    800037f6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800037fa:	609c                	ld	a5,0(s1)
    800037fc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003800:	609c                	ld	a5,0(s1)
    80003802:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003806:	609c                	ld	a5,0(s1)
    80003808:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000380c:	000a3783          	ld	a5,0(s4)
    80003810:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003814:	000a3783          	ld	a5,0(s4)
    80003818:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000381c:	000a3783          	ld	a5,0(s4)
    80003820:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003824:	000a3783          	ld	a5,0(s4)
    80003828:	0127b823          	sd	s2,16(a5)
  return 0;
    8000382c:	4501                	li	a0,0
    8000382e:	a005                	j	8000384e <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003830:	6088                	ld	a0,0(s1)
    80003832:	e501                	bnez	a0,8000383a <pipealloc+0x9a>
    80003834:	a029                	j	8000383e <pipealloc+0x9e>
    80003836:	6088                	ld	a0,0(s1)
    80003838:	c11d                	beqz	a0,8000385e <pipealloc+0xbe>
    fileclose(*f0);
    8000383a:	c9bff0ef          	jal	ra,800034d4 <fileclose>
  if(*f1)
    8000383e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003842:	557d                	li	a0,-1
  if(*f1)
    80003844:	c789                	beqz	a5,8000384e <pipealloc+0xae>
    fileclose(*f1);
    80003846:	853e                	mv	a0,a5
    80003848:	c8dff0ef          	jal	ra,800034d4 <fileclose>
  return -1;
    8000384c:	557d                	li	a0,-1
}
    8000384e:	70a2                	ld	ra,40(sp)
    80003850:	7402                	ld	s0,32(sp)
    80003852:	64e2                	ld	s1,24(sp)
    80003854:	6942                	ld	s2,16(sp)
    80003856:	69a2                	ld	s3,8(sp)
    80003858:	6a02                	ld	s4,0(sp)
    8000385a:	6145                	addi	sp,sp,48
    8000385c:	8082                	ret
  return -1;
    8000385e:	557d                	li	a0,-1
    80003860:	b7fd                	j	8000384e <pipealloc+0xae>

0000000080003862 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003862:	1101                	addi	sp,sp,-32
    80003864:	ec06                	sd	ra,24(sp)
    80003866:	e822                	sd	s0,16(sp)
    80003868:	e426                	sd	s1,8(sp)
    8000386a:	e04a                	sd	s2,0(sp)
    8000386c:	1000                	addi	s0,sp,32
    8000386e:	84aa                	mv	s1,a0
    80003870:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003872:	76f010ef          	jal	ra,800057e0 <acquire>
  if(writable){
    80003876:	02090763          	beqz	s2,800038a4 <pipeclose+0x42>
    pi->writeopen = 0;
    8000387a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000387e:	21848513          	addi	a0,s1,536
    80003882:	af5fd0ef          	jal	ra,80001376 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003886:	2204b783          	ld	a5,544(s1)
    8000388a:	e785                	bnez	a5,800038b2 <pipeclose+0x50>
    release(&pi->lock);
    8000388c:	8526                	mv	a0,s1
    8000388e:	7eb010ef          	jal	ra,80005878 <release>
    kfree((char*)pi);
    80003892:	8526                	mv	a0,s1
    80003894:	f88fc0ef          	jal	ra,8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003898:	60e2                	ld	ra,24(sp)
    8000389a:	6442                	ld	s0,16(sp)
    8000389c:	64a2                	ld	s1,8(sp)
    8000389e:	6902                	ld	s2,0(sp)
    800038a0:	6105                	addi	sp,sp,32
    800038a2:	8082                	ret
    pi->readopen = 0;
    800038a4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800038a8:	21c48513          	addi	a0,s1,540
    800038ac:	acbfd0ef          	jal	ra,80001376 <wakeup>
    800038b0:	bfd9                	j	80003886 <pipeclose+0x24>
    release(&pi->lock);
    800038b2:	8526                	mv	a0,s1
    800038b4:	7c5010ef          	jal	ra,80005878 <release>
}
    800038b8:	b7c5                	j	80003898 <pipeclose+0x36>

00000000800038ba <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800038ba:	7159                	addi	sp,sp,-112
    800038bc:	f486                	sd	ra,104(sp)
    800038be:	f0a2                	sd	s0,96(sp)
    800038c0:	eca6                	sd	s1,88(sp)
    800038c2:	e8ca                	sd	s2,80(sp)
    800038c4:	e4ce                	sd	s3,72(sp)
    800038c6:	e0d2                	sd	s4,64(sp)
    800038c8:	fc56                	sd	s5,56(sp)
    800038ca:	f85a                	sd	s6,48(sp)
    800038cc:	f45e                	sd	s7,40(sp)
    800038ce:	f062                	sd	s8,32(sp)
    800038d0:	ec66                	sd	s9,24(sp)
    800038d2:	1880                	addi	s0,sp,112
    800038d4:	84aa                	mv	s1,a0
    800038d6:	8aae                	mv	s5,a1
    800038d8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800038da:	c5efd0ef          	jal	ra,80000d38 <myproc>
    800038de:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800038e0:	8526                	mv	a0,s1
    800038e2:	6ff010ef          	jal	ra,800057e0 <acquire>
  while(i < n){
    800038e6:	0b405663          	blez	s4,80003992 <pipewrite+0xd8>
    800038ea:	8ba6                	mv	s7,s1
  int i = 0;
    800038ec:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038ee:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800038f0:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800038f4:	21c48c13          	addi	s8,s1,540
    800038f8:	a899                	j	8000394e <pipewrite+0x94>
      release(&pi->lock);
    800038fa:	8526                	mv	a0,s1
    800038fc:	77d010ef          	jal	ra,80005878 <release>
      return -1;
    80003900:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003902:	854a                	mv	a0,s2
    80003904:	70a6                	ld	ra,104(sp)
    80003906:	7406                	ld	s0,96(sp)
    80003908:	64e6                	ld	s1,88(sp)
    8000390a:	6946                	ld	s2,80(sp)
    8000390c:	69a6                	ld	s3,72(sp)
    8000390e:	6a06                	ld	s4,64(sp)
    80003910:	7ae2                	ld	s5,56(sp)
    80003912:	7b42                	ld	s6,48(sp)
    80003914:	7ba2                	ld	s7,40(sp)
    80003916:	7c02                	ld	s8,32(sp)
    80003918:	6ce2                	ld	s9,24(sp)
    8000391a:	6165                	addi	sp,sp,112
    8000391c:	8082                	ret
      wakeup(&pi->nread);
    8000391e:	8566                	mv	a0,s9
    80003920:	a57fd0ef          	jal	ra,80001376 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003924:	85de                	mv	a1,s7
    80003926:	8562                	mv	a0,s8
    80003928:	a03fd0ef          	jal	ra,8000132a <sleep>
    8000392c:	a839                	j	8000394a <pipewrite+0x90>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000392e:	21c4a783          	lw	a5,540(s1)
    80003932:	0017871b          	addiw	a4,a5,1
    80003936:	20e4ae23          	sw	a4,540(s1)
    8000393a:	1ff7f793          	andi	a5,a5,511
    8000393e:	97a6                	add	a5,a5,s1
    80003940:	f9f44703          	lbu	a4,-97(s0)
    80003944:	00e78c23          	sb	a4,24(a5)
      i++;
    80003948:	2905                	addiw	s2,s2,1
  while(i < n){
    8000394a:	03495c63          	bge	s2,s4,80003982 <pipewrite+0xc8>
    if(pi->readopen == 0 || killed(pr)){
    8000394e:	2204a783          	lw	a5,544(s1)
    80003952:	d7c5                	beqz	a5,800038fa <pipewrite+0x40>
    80003954:	854e                	mv	a0,s3
    80003956:	c0dfd0ef          	jal	ra,80001562 <killed>
    8000395a:	f145                	bnez	a0,800038fa <pipewrite+0x40>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000395c:	2184a783          	lw	a5,536(s1)
    80003960:	21c4a703          	lw	a4,540(s1)
    80003964:	2007879b          	addiw	a5,a5,512
    80003968:	faf70be3          	beq	a4,a5,8000391e <pipewrite+0x64>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000396c:	4685                	li	a3,1
    8000396e:	01590633          	add	a2,s2,s5
    80003972:	f9f40593          	addi	a1,s0,-97
    80003976:	0509b503          	ld	a0,80(s3)
    8000397a:	9d2fd0ef          	jal	ra,80000b4c <copyin>
    8000397e:	fb6518e3          	bne	a0,s6,8000392e <pipewrite+0x74>
  wakeup(&pi->nread);
    80003982:	21848513          	addi	a0,s1,536
    80003986:	9f1fd0ef          	jal	ra,80001376 <wakeup>
  release(&pi->lock);
    8000398a:	8526                	mv	a0,s1
    8000398c:	6ed010ef          	jal	ra,80005878 <release>
  return i;
    80003990:	bf8d                	j	80003902 <pipewrite+0x48>
  int i = 0;
    80003992:	4901                	li	s2,0
    80003994:	b7fd                	j	80003982 <pipewrite+0xc8>

0000000080003996 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003996:	715d                	addi	sp,sp,-80
    80003998:	e486                	sd	ra,72(sp)
    8000399a:	e0a2                	sd	s0,64(sp)
    8000399c:	fc26                	sd	s1,56(sp)
    8000399e:	f84a                	sd	s2,48(sp)
    800039a0:	f44e                	sd	s3,40(sp)
    800039a2:	f052                	sd	s4,32(sp)
    800039a4:	ec56                	sd	s5,24(sp)
    800039a6:	e85a                	sd	s6,16(sp)
    800039a8:	0880                	addi	s0,sp,80
    800039aa:	84aa                	mv	s1,a0
    800039ac:	892e                	mv	s2,a1
    800039ae:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800039b0:	b88fd0ef          	jal	ra,80000d38 <myproc>
    800039b4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800039b6:	8b26                	mv	s6,s1
    800039b8:	8526                	mv	a0,s1
    800039ba:	627010ef          	jal	ra,800057e0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039be:	2184a703          	lw	a4,536(s1)
    800039c2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039c6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039ca:	02f71363          	bne	a4,a5,800039f0 <piperead+0x5a>
    800039ce:	2244a783          	lw	a5,548(s1)
    800039d2:	cf99                	beqz	a5,800039f0 <piperead+0x5a>
    if(killed(pr)){
    800039d4:	8552                	mv	a0,s4
    800039d6:	b8dfd0ef          	jal	ra,80001562 <killed>
    800039da:	e141                	bnez	a0,80003a5a <piperead+0xc4>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039dc:	85da                	mv	a1,s6
    800039de:	854e                	mv	a0,s3
    800039e0:	94bfd0ef          	jal	ra,8000132a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039e4:	2184a703          	lw	a4,536(s1)
    800039e8:	21c4a783          	lw	a5,540(s1)
    800039ec:	fef701e3          	beq	a4,a5,800039ce <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039f0:	07505a63          	blez	s5,80003a64 <piperead+0xce>
    800039f4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039f6:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800039f8:	2184a783          	lw	a5,536(s1)
    800039fc:	21c4a703          	lw	a4,540(s1)
    80003a00:	02f70b63          	beq	a4,a5,80003a36 <piperead+0xa0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003a04:	0017871b          	addiw	a4,a5,1
    80003a08:	20e4ac23          	sw	a4,536(s1)
    80003a0c:	1ff7f793          	andi	a5,a5,511
    80003a10:	97a6                	add	a5,a5,s1
    80003a12:	0187c783          	lbu	a5,24(a5)
    80003a16:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a1a:	4685                	li	a3,1
    80003a1c:	fbf40613          	addi	a2,s0,-65
    80003a20:	85ca                	mv	a1,s2
    80003a22:	050a3503          	ld	a0,80(s4)
    80003a26:	85afd0ef          	jal	ra,80000a80 <copyout>
    80003a2a:	01650663          	beq	a0,s6,80003a36 <piperead+0xa0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a2e:	2985                	addiw	s3,s3,1
    80003a30:	0905                	addi	s2,s2,1
    80003a32:	fd3a93e3          	bne	s5,s3,800039f8 <piperead+0x62>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a36:	21c48513          	addi	a0,s1,540
    80003a3a:	93dfd0ef          	jal	ra,80001376 <wakeup>
  release(&pi->lock);
    80003a3e:	8526                	mv	a0,s1
    80003a40:	639010ef          	jal	ra,80005878 <release>
  return i;
}
    80003a44:	854e                	mv	a0,s3
    80003a46:	60a6                	ld	ra,72(sp)
    80003a48:	6406                	ld	s0,64(sp)
    80003a4a:	74e2                	ld	s1,56(sp)
    80003a4c:	7942                	ld	s2,48(sp)
    80003a4e:	79a2                	ld	s3,40(sp)
    80003a50:	7a02                	ld	s4,32(sp)
    80003a52:	6ae2                	ld	s5,24(sp)
    80003a54:	6b42                	ld	s6,16(sp)
    80003a56:	6161                	addi	sp,sp,80
    80003a58:	8082                	ret
      release(&pi->lock);
    80003a5a:	8526                	mv	a0,s1
    80003a5c:	61d010ef          	jal	ra,80005878 <release>
      return -1;
    80003a60:	59fd                	li	s3,-1
    80003a62:	b7cd                	j	80003a44 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a64:	4981                	li	s3,0
    80003a66:	bfc1                	j	80003a36 <piperead+0xa0>

0000000080003a68 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003a68:	1141                	addi	sp,sp,-16
    80003a6a:	e422                	sd	s0,8(sp)
    80003a6c:	0800                	addi	s0,sp,16
    80003a6e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a70:	8905                	andi	a0,a0,1
    80003a72:	c111                	beqz	a0,80003a76 <flags2perm+0xe>
      perm = PTE_X;
    80003a74:	4521                	li	a0,8
    if(flags & 0x2)
    80003a76:	8b89                	andi	a5,a5,2
    80003a78:	c399                	beqz	a5,80003a7e <flags2perm+0x16>
      perm |= PTE_W;
    80003a7a:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a7e:	6422                	ld	s0,8(sp)
    80003a80:	0141                	addi	sp,sp,16
    80003a82:	8082                	ret

0000000080003a84 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003a84:	df010113          	addi	sp,sp,-528
    80003a88:	20113423          	sd	ra,520(sp)
    80003a8c:	20813023          	sd	s0,512(sp)
    80003a90:	ffa6                	sd	s1,504(sp)
    80003a92:	fbca                	sd	s2,496(sp)
    80003a94:	f7ce                	sd	s3,488(sp)
    80003a96:	f3d2                	sd	s4,480(sp)
    80003a98:	efd6                	sd	s5,472(sp)
    80003a9a:	ebda                	sd	s6,464(sp)
    80003a9c:	e7de                	sd	s7,456(sp)
    80003a9e:	e3e2                	sd	s8,448(sp)
    80003aa0:	ff66                	sd	s9,440(sp)
    80003aa2:	fb6a                	sd	s10,432(sp)
    80003aa4:	f76e                	sd	s11,424(sp)
    80003aa6:	0c00                	addi	s0,sp,528
    80003aa8:	84aa                	mv	s1,a0
    80003aaa:	dea43c23          	sd	a0,-520(s0)
    80003aae:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003ab2:	a86fd0ef          	jal	ra,80000d38 <myproc>
    80003ab6:	892a                	mv	s2,a0

  begin_op();
    80003ab8:	e0eff0ef          	jal	ra,800030c6 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003abc:	8526                	mv	a0,s1
    80003abe:	c18ff0ef          	jal	ra,80002ed6 <namei>
    80003ac2:	c12d                	beqz	a0,80003b24 <kexec+0xa0>
    80003ac4:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003ac6:	c23fe0ef          	jal	ra,800026e8 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003aca:	04000713          	li	a4,64
    80003ace:	4681                	li	a3,0
    80003ad0:	e5040613          	addi	a2,s0,-432
    80003ad4:	4581                	li	a1,0
    80003ad6:	8526                	mv	a0,s1
    80003ad8:	f9dfe0ef          	jal	ra,80002a74 <readi>
    80003adc:	04000793          	li	a5,64
    80003ae0:	00f51a63          	bne	a0,a5,80003af4 <kexec+0x70>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003ae4:	e5042703          	lw	a4,-432(s0)
    80003ae8:	464c47b7          	lui	a5,0x464c4
    80003aec:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003af0:	02f70e63          	beq	a4,a5,80003b2c <kexec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003af4:	8526                	mv	a0,s1
    80003af6:	df9fe0ef          	jal	ra,800028ee <iunlockput>
    end_op();
    80003afa:	e3cff0ef          	jal	ra,80003136 <end_op>
  }
  return -1;
    80003afe:	557d                	li	a0,-1
}
    80003b00:	20813083          	ld	ra,520(sp)
    80003b04:	20013403          	ld	s0,512(sp)
    80003b08:	74fe                	ld	s1,504(sp)
    80003b0a:	795e                	ld	s2,496(sp)
    80003b0c:	79be                	ld	s3,488(sp)
    80003b0e:	7a1e                	ld	s4,480(sp)
    80003b10:	6afe                	ld	s5,472(sp)
    80003b12:	6b5e                	ld	s6,464(sp)
    80003b14:	6bbe                	ld	s7,456(sp)
    80003b16:	6c1e                	ld	s8,448(sp)
    80003b18:	7cfa                	ld	s9,440(sp)
    80003b1a:	7d5a                	ld	s10,432(sp)
    80003b1c:	7dba                	ld	s11,424(sp)
    80003b1e:	21010113          	addi	sp,sp,528
    80003b22:	8082                	ret
    end_op();
    80003b24:	e12ff0ef          	jal	ra,80003136 <end_op>
    return -1;
    80003b28:	557d                	li	a0,-1
    80003b2a:	bfd9                	j	80003b00 <kexec+0x7c>
  if((pagetable = proc_pagetable(p)) == 0)
    80003b2c:	854a                	mv	a0,s2
    80003b2e:	b10fd0ef          	jal	ra,80000e3e <proc_pagetable>
    80003b32:	8baa                	mv	s7,a0
    80003b34:	d161                	beqz	a0,80003af4 <kexec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b36:	e7042983          	lw	s3,-400(s0)
    80003b3a:	e8845783          	lhu	a5,-376(s0)
    80003b3e:	cfb9                	beqz	a5,80003b9c <kexec+0x118>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b40:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b42:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80003b44:	6c85                	lui	s9,0x1
    80003b46:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b4a:	def43823          	sd	a5,-528(s0)
    80003b4e:	aadd                	j	80003d44 <kexec+0x2c0>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80003b50:	00004517          	auipc	a0,0x4
    80003b54:	b0850513          	addi	a0,a0,-1272 # 80007658 <syscalls+0x2c8>
    80003b58:	1cf010ef          	jal	ra,80005526 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b5c:	8756                	mv	a4,s5
    80003b5e:	012d86bb          	addw	a3,s11,s2
    80003b62:	4581                	li	a1,0
    80003b64:	8526                	mv	a0,s1
    80003b66:	f0ffe0ef          	jal	ra,80002a74 <readi>
    80003b6a:	2501                	sext.w	a0,a0
    80003b6c:	18aa9263          	bne	s5,a0,80003cf0 <kexec+0x26c>
  for(i = 0; i < sz; i += PGSIZE){
    80003b70:	6785                	lui	a5,0x1
    80003b72:	0127893b          	addw	s2,a5,s2
    80003b76:	77fd                	lui	a5,0xfffff
    80003b78:	01478a3b          	addw	s4,a5,s4
    80003b7c:	1b897b63          	bgeu	s2,s8,80003d32 <kexec+0x2ae>
    pa = walkaddr(pagetable, va + i);
    80003b80:	02091593          	slli	a1,s2,0x20
    80003b84:	9181                	srli	a1,a1,0x20
    80003b86:	95ea                	add	a1,a1,s10
    80003b88:	855e                	mv	a0,s7
    80003b8a:	8e1fc0ef          	jal	ra,8000046a <walkaddr>
    80003b8e:	862a                	mv	a2,a0
    if(pa == 0)
    80003b90:	d161                	beqz	a0,80003b50 <kexec+0xcc>
      n = PGSIZE;
    80003b92:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80003b94:	fd9a74e3          	bgeu	s4,s9,80003b5c <kexec+0xd8>
      n = sz - i;
    80003b98:	8ad2                	mv	s5,s4
    80003b9a:	b7c9                	j	80003b5c <kexec+0xd8>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b9c:	4a01                	li	s4,0
  iunlockput(ip);
    80003b9e:	8526                	mv	a0,s1
    80003ba0:	d4ffe0ef          	jal	ra,800028ee <iunlockput>
  end_op();
    80003ba4:	d92ff0ef          	jal	ra,80003136 <end_op>
  p = myproc();
    80003ba8:	990fd0ef          	jal	ra,80000d38 <myproc>
    80003bac:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003bae:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003bb2:	6785                	lui	a5,0x1
    80003bb4:	17fd                	addi	a5,a5,-1
    80003bb6:	9a3e                	add	s4,s4,a5
    80003bb8:	757d                	lui	a0,0xfffff
    80003bba:	00aa77b3          	and	a5,s4,a0
    80003bbe:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003bc2:	4691                	li	a3,4
    80003bc4:	6609                	lui	a2,0x2
    80003bc6:	963e                	add	a2,a2,a5
    80003bc8:	85be                	mv	a1,a5
    80003bca:	855e                	mv	a0,s7
    80003bcc:	b83fc0ef          	jal	ra,8000074e <uvmalloc>
    80003bd0:	8b2a                	mv	s6,a0
  ip = 0;
    80003bd2:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003bd4:	10050e63          	beqz	a0,80003cf0 <kexec+0x26c>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003bd8:	75f9                	lui	a1,0xffffe
    80003bda:	95aa                	add	a1,a1,a0
    80003bdc:	855e                	mv	a0,s7
    80003bde:	d37fc0ef          	jal	ra,80000914 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003be2:	7c7d                	lui	s8,0xfffff
    80003be4:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80003be6:	e0043783          	ld	a5,-512(s0)
    80003bea:	6388                	ld	a0,0(a5)
    80003bec:	c125                	beqz	a0,80003c4c <kexec+0x1c8>
    80003bee:	e9040993          	addi	s3,s0,-368
    80003bf2:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80003bf6:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80003bf8:	ed4fc0ef          	jal	ra,800002cc <strlen>
    80003bfc:	2505                	addiw	a0,a0,1
    80003bfe:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c02:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80003c06:	11896a63          	bltu	s2,s8,80003d1a <kexec+0x296>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003c0a:	e0043d83          	ld	s11,-512(s0)
    80003c0e:	000dba03          	ld	s4,0(s11)
    80003c12:	8552                	mv	a0,s4
    80003c14:	eb8fc0ef          	jal	ra,800002cc <strlen>
    80003c18:	0015069b          	addiw	a3,a0,1
    80003c1c:	8652                	mv	a2,s4
    80003c1e:	85ca                	mv	a1,s2
    80003c20:	855e                	mv	a0,s7
    80003c22:	e5ffc0ef          	jal	ra,80000a80 <copyout>
    80003c26:	0e054e63          	bltz	a0,80003d22 <kexec+0x29e>
    ustack[argc] = sp;
    80003c2a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003c2e:	0485                	addi	s1,s1,1
    80003c30:	008d8793          	addi	a5,s11,8
    80003c34:	e0f43023          	sd	a5,-512(s0)
    80003c38:	008db503          	ld	a0,8(s11)
    80003c3c:	c911                	beqz	a0,80003c50 <kexec+0x1cc>
    if(argc >= MAXARG)
    80003c3e:	09a1                	addi	s3,s3,8
    80003c40:	fb3c9ce3          	bne	s9,s3,80003bf8 <kexec+0x174>
  sz = sz1;
    80003c44:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80003c48:	4481                	li	s1,0
    80003c4a:	a05d                	j	80003cf0 <kexec+0x26c>
  sp = sz;
    80003c4c:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80003c4e:	4481                	li	s1,0
  ustack[argc] = 0;
    80003c50:	00349793          	slli	a5,s1,0x3
    80003c54:	f9040713          	addi	a4,s0,-112
    80003c58:	97ba                	add	a5,a5,a4
    80003c5a:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80003c5e:	00148693          	addi	a3,s1,1
    80003c62:	068e                	slli	a3,a3,0x3
    80003c64:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003c68:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80003c6c:	01897663          	bgeu	s2,s8,80003c78 <kexec+0x1f4>
  sz = sz1;
    80003c70:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80003c74:	4481                	li	s1,0
    80003c76:	a8ad                	j	80003cf0 <kexec+0x26c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003c78:	e9040613          	addi	a2,s0,-368
    80003c7c:	85ca                	mv	a1,s2
    80003c7e:	855e                	mv	a0,s7
    80003c80:	e01fc0ef          	jal	ra,80000a80 <copyout>
    80003c84:	0a054363          	bltz	a0,80003d2a <kexec+0x2a6>
  p->trapframe->a1 = sp;
    80003c88:	058ab783          	ld	a5,88(s5)
    80003c8c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003c90:	df843783          	ld	a5,-520(s0)
    80003c94:	0007c703          	lbu	a4,0(a5)
    80003c98:	cf11                	beqz	a4,80003cb4 <kexec+0x230>
    80003c9a:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003c9c:	02f00693          	li	a3,47
    80003ca0:	a039                	j	80003cae <kexec+0x22a>
      last = s+1;
    80003ca2:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003ca6:	0785                	addi	a5,a5,1
    80003ca8:	fff7c703          	lbu	a4,-1(a5)
    80003cac:	c701                	beqz	a4,80003cb4 <kexec+0x230>
    if(*s == '/')
    80003cae:	fed71ce3          	bne	a4,a3,80003ca6 <kexec+0x222>
    80003cb2:	bfc5                	j	80003ca2 <kexec+0x21e>
  safestrcpy(p->name, last, sizeof(p->name));
    80003cb4:	4641                	li	a2,16
    80003cb6:	df843583          	ld	a1,-520(s0)
    80003cba:	158a8513          	addi	a0,s5,344
    80003cbe:	ddcfc0ef          	jal	ra,8000029a <safestrcpy>
  oldpagetable = p->pagetable;
    80003cc2:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003cc6:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80003cca:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003cce:	058ab783          	ld	a5,88(s5)
    80003cd2:	e6843703          	ld	a4,-408(s0)
    80003cd6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003cd8:	058ab783          	ld	a5,88(s5)
    80003cdc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003ce0:	85ea                	mv	a1,s10
    80003ce2:	9e0fd0ef          	jal	ra,80000ec2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003ce6:	0004851b          	sext.w	a0,s1
    80003cea:	bd19                	j	80003b00 <kexec+0x7c>
    80003cec:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80003cf0:	e0843583          	ld	a1,-504(s0)
    80003cf4:	855e                	mv	a0,s7
    80003cf6:	9ccfd0ef          	jal	ra,80000ec2 <proc_freepagetable>
  if(ip){
    80003cfa:	de049de3          	bnez	s1,80003af4 <kexec+0x70>
  return -1;
    80003cfe:	557d                	li	a0,-1
    80003d00:	b501                	j	80003b00 <kexec+0x7c>
    80003d02:	e1443423          	sd	s4,-504(s0)
    80003d06:	b7ed                	j	80003cf0 <kexec+0x26c>
    80003d08:	e1443423          	sd	s4,-504(s0)
    80003d0c:	b7d5                	j	80003cf0 <kexec+0x26c>
    80003d0e:	e1443423          	sd	s4,-504(s0)
    80003d12:	bff9                	j	80003cf0 <kexec+0x26c>
    80003d14:	e1443423          	sd	s4,-504(s0)
    80003d18:	bfe1                	j	80003cf0 <kexec+0x26c>
  sz = sz1;
    80003d1a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80003d1e:	4481                	li	s1,0
    80003d20:	bfc1                	j	80003cf0 <kexec+0x26c>
  sz = sz1;
    80003d22:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80003d26:	4481                	li	s1,0
    80003d28:	b7e1                	j	80003cf0 <kexec+0x26c>
  sz = sz1;
    80003d2a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80003d2e:	4481                	li	s1,0
    80003d30:	b7c1                	j	80003cf0 <kexec+0x26c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003d32:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d36:	2b05                	addiw	s6,s6,1
    80003d38:	0389899b          	addiw	s3,s3,56
    80003d3c:	e8845783          	lhu	a5,-376(s0)
    80003d40:	e4fb5fe3          	bge	s6,a5,80003b9e <kexec+0x11a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003d44:	2981                	sext.w	s3,s3
    80003d46:	03800713          	li	a4,56
    80003d4a:	86ce                	mv	a3,s3
    80003d4c:	e1840613          	addi	a2,s0,-488
    80003d50:	4581                	li	a1,0
    80003d52:	8526                	mv	a0,s1
    80003d54:	d21fe0ef          	jal	ra,80002a74 <readi>
    80003d58:	03800793          	li	a5,56
    80003d5c:	f8f518e3          	bne	a0,a5,80003cec <kexec+0x268>
    if(ph.type != ELF_PROG_LOAD)
    80003d60:	e1842783          	lw	a5,-488(s0)
    80003d64:	4705                	li	a4,1
    80003d66:	fce798e3          	bne	a5,a4,80003d36 <kexec+0x2b2>
    if(ph.memsz < ph.filesz)
    80003d6a:	e4043903          	ld	s2,-448(s0)
    80003d6e:	e3843783          	ld	a5,-456(s0)
    80003d72:	f8f968e3          	bltu	s2,a5,80003d02 <kexec+0x27e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003d76:	e2843783          	ld	a5,-472(s0)
    80003d7a:	993e                	add	s2,s2,a5
    80003d7c:	f8f966e3          	bltu	s2,a5,80003d08 <kexec+0x284>
    if(ph.vaddr % PGSIZE != 0)
    80003d80:	df043703          	ld	a4,-528(s0)
    80003d84:	8ff9                	and	a5,a5,a4
    80003d86:	f7c1                	bnez	a5,80003d0e <kexec+0x28a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003d88:	e1c42503          	lw	a0,-484(s0)
    80003d8c:	cddff0ef          	jal	ra,80003a68 <flags2perm>
    80003d90:	86aa                	mv	a3,a0
    80003d92:	864a                	mv	a2,s2
    80003d94:	85d2                	mv	a1,s4
    80003d96:	855e                	mv	a0,s7
    80003d98:	9b7fc0ef          	jal	ra,8000074e <uvmalloc>
    80003d9c:	e0a43423          	sd	a0,-504(s0)
    80003da0:	d935                	beqz	a0,80003d14 <kexec+0x290>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003da2:	e2843d03          	ld	s10,-472(s0)
    80003da6:	e2042d83          	lw	s11,-480(s0)
    80003daa:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003dae:	f80c02e3          	beqz	s8,80003d32 <kexec+0x2ae>
    80003db2:	8a62                	mv	s4,s8
    80003db4:	4901                	li	s2,0
    80003db6:	b3e9                	j	80003b80 <kexec+0xfc>

0000000080003db8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003db8:	7179                	addi	sp,sp,-48
    80003dba:	f406                	sd	ra,40(sp)
    80003dbc:	f022                	sd	s0,32(sp)
    80003dbe:	ec26                	sd	s1,24(sp)
    80003dc0:	e84a                	sd	s2,16(sp)
    80003dc2:	1800                	addi	s0,sp,48
    80003dc4:	892e                	mv	s2,a1
    80003dc6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003dc8:	fdc40593          	addi	a1,s0,-36
    80003dcc:	eddfd0ef          	jal	ra,80001ca8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003dd0:	fdc42703          	lw	a4,-36(s0)
    80003dd4:	47bd                	li	a5,15
    80003dd6:	02e7e963          	bltu	a5,a4,80003e08 <argfd+0x50>
    80003dda:	f5ffc0ef          	jal	ra,80000d38 <myproc>
    80003dde:	fdc42703          	lw	a4,-36(s0)
    80003de2:	01a70793          	addi	a5,a4,26
    80003de6:	078e                	slli	a5,a5,0x3
    80003de8:	953e                	add	a0,a0,a5
    80003dea:	611c                	ld	a5,0(a0)
    80003dec:	c385                	beqz	a5,80003e0c <argfd+0x54>
    return -1;
  if(pfd)
    80003dee:	00090463          	beqz	s2,80003df6 <argfd+0x3e>
    *pfd = fd;
    80003df2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003df6:	4501                	li	a0,0
  if(pf)
    80003df8:	c091                	beqz	s1,80003dfc <argfd+0x44>
    *pf = f;
    80003dfa:	e09c                	sd	a5,0(s1)
}
    80003dfc:	70a2                	ld	ra,40(sp)
    80003dfe:	7402                	ld	s0,32(sp)
    80003e00:	64e2                	ld	s1,24(sp)
    80003e02:	6942                	ld	s2,16(sp)
    80003e04:	6145                	addi	sp,sp,48
    80003e06:	8082                	ret
    return -1;
    80003e08:	557d                	li	a0,-1
    80003e0a:	bfcd                	j	80003dfc <argfd+0x44>
    80003e0c:	557d                	li	a0,-1
    80003e0e:	b7fd                	j	80003dfc <argfd+0x44>

0000000080003e10 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e10:	1101                	addi	sp,sp,-32
    80003e12:	ec06                	sd	ra,24(sp)
    80003e14:	e822                	sd	s0,16(sp)
    80003e16:	e426                	sd	s1,8(sp)
    80003e18:	1000                	addi	s0,sp,32
    80003e1a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003e1c:	f1dfc0ef          	jal	ra,80000d38 <myproc>
    80003e20:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003e22:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffde528>
    80003e26:	4501                	li	a0,0
    80003e28:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003e2a:	6398                	ld	a4,0(a5)
    80003e2c:	cb19                	beqz	a4,80003e42 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e2e:	2505                	addiw	a0,a0,1
    80003e30:	07a1                	addi	a5,a5,8
    80003e32:	fed51ce3          	bne	a0,a3,80003e2a <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e36:	557d                	li	a0,-1
}
    80003e38:	60e2                	ld	ra,24(sp)
    80003e3a:	6442                	ld	s0,16(sp)
    80003e3c:	64a2                	ld	s1,8(sp)
    80003e3e:	6105                	addi	sp,sp,32
    80003e40:	8082                	ret
      p->ofile[fd] = f;
    80003e42:	01a50793          	addi	a5,a0,26
    80003e46:	078e                	slli	a5,a5,0x3
    80003e48:	963e                	add	a2,a2,a5
    80003e4a:	e204                	sd	s1,0(a2)
      return fd;
    80003e4c:	b7f5                	j	80003e38 <fdalloc+0x28>

0000000080003e4e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e4e:	715d                	addi	sp,sp,-80
    80003e50:	e486                	sd	ra,72(sp)
    80003e52:	e0a2                	sd	s0,64(sp)
    80003e54:	fc26                	sd	s1,56(sp)
    80003e56:	f84a                	sd	s2,48(sp)
    80003e58:	f44e                	sd	s3,40(sp)
    80003e5a:	f052                	sd	s4,32(sp)
    80003e5c:	ec56                	sd	s5,24(sp)
    80003e5e:	e85a                	sd	s6,16(sp)
    80003e60:	0880                	addi	s0,sp,80
    80003e62:	8b2e                	mv	s6,a1
    80003e64:	89b2                	mv	s3,a2
    80003e66:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003e68:	fb040593          	addi	a1,s0,-80
    80003e6c:	884ff0ef          	jal	ra,80002ef0 <nameiparent>
    80003e70:	84aa                	mv	s1,a0
    80003e72:	10050c63          	beqz	a0,80003f8a <create+0x13c>
    return 0;

  ilock(dp);
    80003e76:	873fe0ef          	jal	ra,800026e8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e7a:	4601                	li	a2,0
    80003e7c:	fb040593          	addi	a1,s0,-80
    80003e80:	8526                	mv	a0,s1
    80003e82:	deffe0ef          	jal	ra,80002c70 <dirlookup>
    80003e86:	8aaa                	mv	s5,a0
    80003e88:	c521                	beqz	a0,80003ed0 <create+0x82>
    iunlockput(dp);
    80003e8a:	8526                	mv	a0,s1
    80003e8c:	a63fe0ef          	jal	ra,800028ee <iunlockput>
    ilock(ip);
    80003e90:	8556                	mv	a0,s5
    80003e92:	857fe0ef          	jal	ra,800026e8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003e96:	000b059b          	sext.w	a1,s6
    80003e9a:	4789                	li	a5,2
    80003e9c:	02f59563          	bne	a1,a5,80003ec6 <create+0x78>
    80003ea0:	044ad783          	lhu	a5,68(s5)
    80003ea4:	37f9                	addiw	a5,a5,-2
    80003ea6:	17c2                	slli	a5,a5,0x30
    80003ea8:	93c1                	srli	a5,a5,0x30
    80003eaa:	4705                	li	a4,1
    80003eac:	00f76d63          	bltu	a4,a5,80003ec6 <create+0x78>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003eb0:	8556                	mv	a0,s5
    80003eb2:	60a6                	ld	ra,72(sp)
    80003eb4:	6406                	ld	s0,64(sp)
    80003eb6:	74e2                	ld	s1,56(sp)
    80003eb8:	7942                	ld	s2,48(sp)
    80003eba:	79a2                	ld	s3,40(sp)
    80003ebc:	7a02                	ld	s4,32(sp)
    80003ebe:	6ae2                	ld	s5,24(sp)
    80003ec0:	6b42                	ld	s6,16(sp)
    80003ec2:	6161                	addi	sp,sp,80
    80003ec4:	8082                	ret
    iunlockput(ip);
    80003ec6:	8556                	mv	a0,s5
    80003ec8:	a27fe0ef          	jal	ra,800028ee <iunlockput>
    return 0;
    80003ecc:	4a81                	li	s5,0
    80003ece:	b7cd                	j	80003eb0 <create+0x62>
  if((ip = ialloc(dp->dev, type)) == 0){
    80003ed0:	85da                	mv	a1,s6
    80003ed2:	4088                	lw	a0,0(s1)
    80003ed4:	eacfe0ef          	jal	ra,80002580 <ialloc>
    80003ed8:	8a2a                	mv	s4,a0
    80003eda:	c121                	beqz	a0,80003f1a <create+0xcc>
  ilock(ip);
    80003edc:	80dfe0ef          	jal	ra,800026e8 <ilock>
  ip->major = major;
    80003ee0:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003ee4:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003ee8:	4785                	li	a5,1
    80003eea:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80003eee:	8552                	mv	a0,s4
    80003ef0:	f46fe0ef          	jal	ra,80002636 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003ef4:	000b059b          	sext.w	a1,s6
    80003ef8:	4785                	li	a5,1
    80003efa:	02f58563          	beq	a1,a5,80003f24 <create+0xd6>
  if(dirlink(dp, name, ip->inum) < 0)
    80003efe:	004a2603          	lw	a2,4(s4)
    80003f02:	fb040593          	addi	a1,s0,-80
    80003f06:	8526                	mv	a0,s1
    80003f08:	f35fe0ef          	jal	ra,80002e3c <dirlink>
    80003f0c:	06054363          	bltz	a0,80003f72 <create+0x124>
  iunlockput(dp);
    80003f10:	8526                	mv	a0,s1
    80003f12:	9ddfe0ef          	jal	ra,800028ee <iunlockput>
  return ip;
    80003f16:	8ad2                	mv	s5,s4
    80003f18:	bf61                	j	80003eb0 <create+0x62>
    iunlockput(dp);
    80003f1a:	8526                	mv	a0,s1
    80003f1c:	9d3fe0ef          	jal	ra,800028ee <iunlockput>
    return 0;
    80003f20:	8ad2                	mv	s5,s4
    80003f22:	b779                	j	80003eb0 <create+0x62>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003f24:	004a2603          	lw	a2,4(s4)
    80003f28:	00003597          	auipc	a1,0x3
    80003f2c:	75058593          	addi	a1,a1,1872 # 80007678 <syscalls+0x2e8>
    80003f30:	8552                	mv	a0,s4
    80003f32:	f0bfe0ef          	jal	ra,80002e3c <dirlink>
    80003f36:	02054e63          	bltz	a0,80003f72 <create+0x124>
    80003f3a:	40d0                	lw	a2,4(s1)
    80003f3c:	00003597          	auipc	a1,0x3
    80003f40:	74458593          	addi	a1,a1,1860 # 80007680 <syscalls+0x2f0>
    80003f44:	8552                	mv	a0,s4
    80003f46:	ef7fe0ef          	jal	ra,80002e3c <dirlink>
    80003f4a:	02054463          	bltz	a0,80003f72 <create+0x124>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f4e:	004a2603          	lw	a2,4(s4)
    80003f52:	fb040593          	addi	a1,s0,-80
    80003f56:	8526                	mv	a0,s1
    80003f58:	ee5fe0ef          	jal	ra,80002e3c <dirlink>
    80003f5c:	00054b63          	bltz	a0,80003f72 <create+0x124>
    dp->nlink++;  // for ".."
    80003f60:	04a4d783          	lhu	a5,74(s1)
    80003f64:	2785                	addiw	a5,a5,1
    80003f66:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003f6a:	8526                	mv	a0,s1
    80003f6c:	ecafe0ef          	jal	ra,80002636 <iupdate>
    80003f70:	b745                	j	80003f10 <create+0xc2>
  ip->nlink = 0;
    80003f72:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003f76:	8552                	mv	a0,s4
    80003f78:	ebefe0ef          	jal	ra,80002636 <iupdate>
  iunlockput(ip);
    80003f7c:	8552                	mv	a0,s4
    80003f7e:	971fe0ef          	jal	ra,800028ee <iunlockput>
  iunlockput(dp);
    80003f82:	8526                	mv	a0,s1
    80003f84:	96bfe0ef          	jal	ra,800028ee <iunlockput>
  return 0;
    80003f88:	b725                	j	80003eb0 <create+0x62>
    return 0;
    80003f8a:	8aaa                	mv	s5,a0
    80003f8c:	b715                	j	80003eb0 <create+0x62>

0000000080003f8e <sys_dup>:
{
    80003f8e:	7179                	addi	sp,sp,-48
    80003f90:	f406                	sd	ra,40(sp)
    80003f92:	f022                	sd	s0,32(sp)
    80003f94:	ec26                	sd	s1,24(sp)
    80003f96:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003f98:	fd840613          	addi	a2,s0,-40
    80003f9c:	4581                	li	a1,0
    80003f9e:	4501                	li	a0,0
    80003fa0:	e19ff0ef          	jal	ra,80003db8 <argfd>
    return -1;
    80003fa4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003fa6:	00054f63          	bltz	a0,80003fc4 <sys_dup+0x36>
  if((fd=fdalloc(f)) < 0)
    80003faa:	fd843503          	ld	a0,-40(s0)
    80003fae:	e63ff0ef          	jal	ra,80003e10 <fdalloc>
    80003fb2:	84aa                	mv	s1,a0
    return -1;
    80003fb4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003fb6:	00054763          	bltz	a0,80003fc4 <sys_dup+0x36>
  filedup(f);
    80003fba:	fd843503          	ld	a0,-40(s0)
    80003fbe:	cd0ff0ef          	jal	ra,8000348e <filedup>
  return fd;
    80003fc2:	87a6                	mv	a5,s1
}
    80003fc4:	853e                	mv	a0,a5
    80003fc6:	70a2                	ld	ra,40(sp)
    80003fc8:	7402                	ld	s0,32(sp)
    80003fca:	64e2                	ld	s1,24(sp)
    80003fcc:	6145                	addi	sp,sp,48
    80003fce:	8082                	ret

0000000080003fd0 <sys_read>:
{
    80003fd0:	7179                	addi	sp,sp,-48
    80003fd2:	f406                	sd	ra,40(sp)
    80003fd4:	f022                	sd	s0,32(sp)
    80003fd6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003fd8:	fd840593          	addi	a1,s0,-40
    80003fdc:	4505                	li	a0,1
    80003fde:	ce7fd0ef          	jal	ra,80001cc4 <argaddr>
  argint(2, &n);
    80003fe2:	fe440593          	addi	a1,s0,-28
    80003fe6:	4509                	li	a0,2
    80003fe8:	cc1fd0ef          	jal	ra,80001ca8 <argint>
  if(argfd(0, 0, &f) < 0)
    80003fec:	fe840613          	addi	a2,s0,-24
    80003ff0:	4581                	li	a1,0
    80003ff2:	4501                	li	a0,0
    80003ff4:	dc5ff0ef          	jal	ra,80003db8 <argfd>
    80003ff8:	87aa                	mv	a5,a0
    return -1;
    80003ffa:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003ffc:	0007ca63          	bltz	a5,80004010 <sys_read+0x40>
  return fileread(f, p, n);
    80004000:	fe442603          	lw	a2,-28(s0)
    80004004:	fd843583          	ld	a1,-40(s0)
    80004008:	fe843503          	ld	a0,-24(s0)
    8000400c:	dceff0ef          	jal	ra,800035da <fileread>
}
    80004010:	70a2                	ld	ra,40(sp)
    80004012:	7402                	ld	s0,32(sp)
    80004014:	6145                	addi	sp,sp,48
    80004016:	8082                	ret

0000000080004018 <sys_write>:
{
    80004018:	7179                	addi	sp,sp,-48
    8000401a:	f406                	sd	ra,40(sp)
    8000401c:	f022                	sd	s0,32(sp)
    8000401e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004020:	fd840593          	addi	a1,s0,-40
    80004024:	4505                	li	a0,1
    80004026:	c9ffd0ef          	jal	ra,80001cc4 <argaddr>
  argint(2, &n);
    8000402a:	fe440593          	addi	a1,s0,-28
    8000402e:	4509                	li	a0,2
    80004030:	c79fd0ef          	jal	ra,80001ca8 <argint>
  if(argfd(0, 0, &f) < 0)
    80004034:	fe840613          	addi	a2,s0,-24
    80004038:	4581                	li	a1,0
    8000403a:	4501                	li	a0,0
    8000403c:	d7dff0ef          	jal	ra,80003db8 <argfd>
    80004040:	87aa                	mv	a5,a0
    return -1;
    80004042:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004044:	0007ca63          	bltz	a5,80004058 <sys_write+0x40>
  return filewrite(f, p, n);
    80004048:	fe442603          	lw	a2,-28(s0)
    8000404c:	fd843583          	ld	a1,-40(s0)
    80004050:	fe843503          	ld	a0,-24(s0)
    80004054:	e34ff0ef          	jal	ra,80003688 <filewrite>
}
    80004058:	70a2                	ld	ra,40(sp)
    8000405a:	7402                	ld	s0,32(sp)
    8000405c:	6145                	addi	sp,sp,48
    8000405e:	8082                	ret

0000000080004060 <sys_close>:
{
    80004060:	1101                	addi	sp,sp,-32
    80004062:	ec06                	sd	ra,24(sp)
    80004064:	e822                	sd	s0,16(sp)
    80004066:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004068:	fe040613          	addi	a2,s0,-32
    8000406c:	fec40593          	addi	a1,s0,-20
    80004070:	4501                	li	a0,0
    80004072:	d47ff0ef          	jal	ra,80003db8 <argfd>
    return -1;
    80004076:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004078:	02054063          	bltz	a0,80004098 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000407c:	cbdfc0ef          	jal	ra,80000d38 <myproc>
    80004080:	fec42783          	lw	a5,-20(s0)
    80004084:	07e9                	addi	a5,a5,26
    80004086:	078e                	slli	a5,a5,0x3
    80004088:	97aa                	add	a5,a5,a0
    8000408a:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000408e:	fe043503          	ld	a0,-32(s0)
    80004092:	c42ff0ef          	jal	ra,800034d4 <fileclose>
  return 0;
    80004096:	4781                	li	a5,0
}
    80004098:	853e                	mv	a0,a5
    8000409a:	60e2                	ld	ra,24(sp)
    8000409c:	6442                	ld	s0,16(sp)
    8000409e:	6105                	addi	sp,sp,32
    800040a0:	8082                	ret

00000000800040a2 <sys_fstat>:
{
    800040a2:	1101                	addi	sp,sp,-32
    800040a4:	ec06                	sd	ra,24(sp)
    800040a6:	e822                	sd	s0,16(sp)
    800040a8:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800040aa:	fe040593          	addi	a1,s0,-32
    800040ae:	4505                	li	a0,1
    800040b0:	c15fd0ef          	jal	ra,80001cc4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800040b4:	fe840613          	addi	a2,s0,-24
    800040b8:	4581                	li	a1,0
    800040ba:	4501                	li	a0,0
    800040bc:	cfdff0ef          	jal	ra,80003db8 <argfd>
    800040c0:	87aa                	mv	a5,a0
    return -1;
    800040c2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040c4:	0007c863          	bltz	a5,800040d4 <sys_fstat+0x32>
  return filestat(f, st);
    800040c8:	fe043583          	ld	a1,-32(s0)
    800040cc:	fe843503          	ld	a0,-24(s0)
    800040d0:	cacff0ef          	jal	ra,8000357c <filestat>
}
    800040d4:	60e2                	ld	ra,24(sp)
    800040d6:	6442                	ld	s0,16(sp)
    800040d8:	6105                	addi	sp,sp,32
    800040da:	8082                	ret

00000000800040dc <sys_link>:
{
    800040dc:	7169                	addi	sp,sp,-304
    800040de:	f606                	sd	ra,296(sp)
    800040e0:	f222                	sd	s0,288(sp)
    800040e2:	ee26                	sd	s1,280(sp)
    800040e4:	ea4a                	sd	s2,272(sp)
    800040e6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040e8:	08000613          	li	a2,128
    800040ec:	ed040593          	addi	a1,s0,-304
    800040f0:	4501                	li	a0,0
    800040f2:	beffd0ef          	jal	ra,80001ce0 <argstr>
    return -1;
    800040f6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040f8:	0c054663          	bltz	a0,800041c4 <sys_link+0xe8>
    800040fc:	08000613          	li	a2,128
    80004100:	f5040593          	addi	a1,s0,-176
    80004104:	4505                	li	a0,1
    80004106:	bdbfd0ef          	jal	ra,80001ce0 <argstr>
    return -1;
    8000410a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000410c:	0a054c63          	bltz	a0,800041c4 <sys_link+0xe8>
  begin_op();
    80004110:	fb7fe0ef          	jal	ra,800030c6 <begin_op>
  if((ip = namei(old)) == 0){
    80004114:	ed040513          	addi	a0,s0,-304
    80004118:	dbffe0ef          	jal	ra,80002ed6 <namei>
    8000411c:	84aa                	mv	s1,a0
    8000411e:	c525                	beqz	a0,80004186 <sys_link+0xaa>
  ilock(ip);
    80004120:	dc8fe0ef          	jal	ra,800026e8 <ilock>
  if(ip->type == T_DIR){
    80004124:	04449703          	lh	a4,68(s1)
    80004128:	4785                	li	a5,1
    8000412a:	06f70263          	beq	a4,a5,8000418e <sys_link+0xb2>
  ip->nlink++;
    8000412e:	04a4d783          	lhu	a5,74(s1)
    80004132:	2785                	addiw	a5,a5,1
    80004134:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004138:	8526                	mv	a0,s1
    8000413a:	cfcfe0ef          	jal	ra,80002636 <iupdate>
  iunlock(ip);
    8000413e:	8526                	mv	a0,s1
    80004140:	e52fe0ef          	jal	ra,80002792 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004144:	fd040593          	addi	a1,s0,-48
    80004148:	f5040513          	addi	a0,s0,-176
    8000414c:	da5fe0ef          	jal	ra,80002ef0 <nameiparent>
    80004150:	892a                	mv	s2,a0
    80004152:	c921                	beqz	a0,800041a2 <sys_link+0xc6>
  ilock(dp);
    80004154:	d94fe0ef          	jal	ra,800026e8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004158:	00092703          	lw	a4,0(s2)
    8000415c:	409c                	lw	a5,0(s1)
    8000415e:	02f71f63          	bne	a4,a5,8000419c <sys_link+0xc0>
    80004162:	40d0                	lw	a2,4(s1)
    80004164:	fd040593          	addi	a1,s0,-48
    80004168:	854a                	mv	a0,s2
    8000416a:	cd3fe0ef          	jal	ra,80002e3c <dirlink>
    8000416e:	02054763          	bltz	a0,8000419c <sys_link+0xc0>
  iunlockput(dp);
    80004172:	854a                	mv	a0,s2
    80004174:	f7afe0ef          	jal	ra,800028ee <iunlockput>
  iput(ip);
    80004178:	8526                	mv	a0,s1
    8000417a:	eecfe0ef          	jal	ra,80002866 <iput>
  end_op();
    8000417e:	fb9fe0ef          	jal	ra,80003136 <end_op>
  return 0;
    80004182:	4781                	li	a5,0
    80004184:	a081                	j	800041c4 <sys_link+0xe8>
    end_op();
    80004186:	fb1fe0ef          	jal	ra,80003136 <end_op>
    return -1;
    8000418a:	57fd                	li	a5,-1
    8000418c:	a825                	j	800041c4 <sys_link+0xe8>
    iunlockput(ip);
    8000418e:	8526                	mv	a0,s1
    80004190:	f5efe0ef          	jal	ra,800028ee <iunlockput>
    end_op();
    80004194:	fa3fe0ef          	jal	ra,80003136 <end_op>
    return -1;
    80004198:	57fd                	li	a5,-1
    8000419a:	a02d                	j	800041c4 <sys_link+0xe8>
    iunlockput(dp);
    8000419c:	854a                	mv	a0,s2
    8000419e:	f50fe0ef          	jal	ra,800028ee <iunlockput>
  ilock(ip);
    800041a2:	8526                	mv	a0,s1
    800041a4:	d44fe0ef          	jal	ra,800026e8 <ilock>
  ip->nlink--;
    800041a8:	04a4d783          	lhu	a5,74(s1)
    800041ac:	37fd                	addiw	a5,a5,-1
    800041ae:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800041b2:	8526                	mv	a0,s1
    800041b4:	c82fe0ef          	jal	ra,80002636 <iupdate>
  iunlockput(ip);
    800041b8:	8526                	mv	a0,s1
    800041ba:	f34fe0ef          	jal	ra,800028ee <iunlockput>
  end_op();
    800041be:	f79fe0ef          	jal	ra,80003136 <end_op>
  return -1;
    800041c2:	57fd                	li	a5,-1
}
    800041c4:	853e                	mv	a0,a5
    800041c6:	70b2                	ld	ra,296(sp)
    800041c8:	7412                	ld	s0,288(sp)
    800041ca:	64f2                	ld	s1,280(sp)
    800041cc:	6952                	ld	s2,272(sp)
    800041ce:	6155                	addi	sp,sp,304
    800041d0:	8082                	ret

00000000800041d2 <sys_unlink>:
{
    800041d2:	7151                	addi	sp,sp,-240
    800041d4:	f586                	sd	ra,232(sp)
    800041d6:	f1a2                	sd	s0,224(sp)
    800041d8:	eda6                	sd	s1,216(sp)
    800041da:	e9ca                	sd	s2,208(sp)
    800041dc:	e5ce                	sd	s3,200(sp)
    800041de:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800041e0:	08000613          	li	a2,128
    800041e4:	f3040593          	addi	a1,s0,-208
    800041e8:	4501                	li	a0,0
    800041ea:	af7fd0ef          	jal	ra,80001ce0 <argstr>
    800041ee:	12054b63          	bltz	a0,80004324 <sys_unlink+0x152>
  begin_op();
    800041f2:	ed5fe0ef          	jal	ra,800030c6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800041f6:	fb040593          	addi	a1,s0,-80
    800041fa:	f3040513          	addi	a0,s0,-208
    800041fe:	cf3fe0ef          	jal	ra,80002ef0 <nameiparent>
    80004202:	84aa                	mv	s1,a0
    80004204:	c54d                	beqz	a0,800042ae <sys_unlink+0xdc>
  ilock(dp);
    80004206:	ce2fe0ef          	jal	ra,800026e8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000420a:	00003597          	auipc	a1,0x3
    8000420e:	46e58593          	addi	a1,a1,1134 # 80007678 <syscalls+0x2e8>
    80004212:	fb040513          	addi	a0,s0,-80
    80004216:	a45fe0ef          	jal	ra,80002c5a <namecmp>
    8000421a:	10050a63          	beqz	a0,8000432e <sys_unlink+0x15c>
    8000421e:	00003597          	auipc	a1,0x3
    80004222:	46258593          	addi	a1,a1,1122 # 80007680 <syscalls+0x2f0>
    80004226:	fb040513          	addi	a0,s0,-80
    8000422a:	a31fe0ef          	jal	ra,80002c5a <namecmp>
    8000422e:	10050063          	beqz	a0,8000432e <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004232:	f2c40613          	addi	a2,s0,-212
    80004236:	fb040593          	addi	a1,s0,-80
    8000423a:	8526                	mv	a0,s1
    8000423c:	a35fe0ef          	jal	ra,80002c70 <dirlookup>
    80004240:	892a                	mv	s2,a0
    80004242:	0e050663          	beqz	a0,8000432e <sys_unlink+0x15c>
  ilock(ip);
    80004246:	ca2fe0ef          	jal	ra,800026e8 <ilock>
  if(ip->nlink < 1)
    8000424a:	04a91783          	lh	a5,74(s2)
    8000424e:	06f05463          	blez	a5,800042b6 <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004252:	04491703          	lh	a4,68(s2)
    80004256:	4785                	li	a5,1
    80004258:	06f70563          	beq	a4,a5,800042c2 <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    8000425c:	4641                	li	a2,16
    8000425e:	4581                	li	a1,0
    80004260:	fc040513          	addi	a0,s0,-64
    80004264:	ee9fb0ef          	jal	ra,8000014c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004268:	4741                	li	a4,16
    8000426a:	f2c42683          	lw	a3,-212(s0)
    8000426e:	fc040613          	addi	a2,s0,-64
    80004272:	4581                	li	a1,0
    80004274:	8526                	mv	a0,s1
    80004276:	8e3fe0ef          	jal	ra,80002b58 <writei>
    8000427a:	47c1                	li	a5,16
    8000427c:	08f51563          	bne	a0,a5,80004306 <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004280:	04491703          	lh	a4,68(s2)
    80004284:	4785                	li	a5,1
    80004286:	08f70663          	beq	a4,a5,80004312 <sys_unlink+0x140>
  iunlockput(dp);
    8000428a:	8526                	mv	a0,s1
    8000428c:	e62fe0ef          	jal	ra,800028ee <iunlockput>
  ip->nlink--;
    80004290:	04a95783          	lhu	a5,74(s2)
    80004294:	37fd                	addiw	a5,a5,-1
    80004296:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000429a:	854a                	mv	a0,s2
    8000429c:	b9afe0ef          	jal	ra,80002636 <iupdate>
  iunlockput(ip);
    800042a0:	854a                	mv	a0,s2
    800042a2:	e4cfe0ef          	jal	ra,800028ee <iunlockput>
  end_op();
    800042a6:	e91fe0ef          	jal	ra,80003136 <end_op>
  return 0;
    800042aa:	4501                	li	a0,0
    800042ac:	a079                	j	8000433a <sys_unlink+0x168>
    end_op();
    800042ae:	e89fe0ef          	jal	ra,80003136 <end_op>
    return -1;
    800042b2:	557d                	li	a0,-1
    800042b4:	a059                	j	8000433a <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    800042b6:	00003517          	auipc	a0,0x3
    800042ba:	3d250513          	addi	a0,a0,978 # 80007688 <syscalls+0x2f8>
    800042be:	268010ef          	jal	ra,80005526 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042c2:	04c92703          	lw	a4,76(s2)
    800042c6:	02000793          	li	a5,32
    800042ca:	f8e7f9e3          	bgeu	a5,a4,8000425c <sys_unlink+0x8a>
    800042ce:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042d2:	4741                	li	a4,16
    800042d4:	86ce                	mv	a3,s3
    800042d6:	f1840613          	addi	a2,s0,-232
    800042da:	4581                	li	a1,0
    800042dc:	854a                	mv	a0,s2
    800042de:	f96fe0ef          	jal	ra,80002a74 <readi>
    800042e2:	47c1                	li	a5,16
    800042e4:	00f51b63          	bne	a0,a5,800042fa <sys_unlink+0x128>
    if(de.inum != 0)
    800042e8:	f1845783          	lhu	a5,-232(s0)
    800042ec:	ef95                	bnez	a5,80004328 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042ee:	29c1                	addiw	s3,s3,16
    800042f0:	04c92783          	lw	a5,76(s2)
    800042f4:	fcf9efe3          	bltu	s3,a5,800042d2 <sys_unlink+0x100>
    800042f8:	b795                	j	8000425c <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800042fa:	00003517          	auipc	a0,0x3
    800042fe:	3a650513          	addi	a0,a0,934 # 800076a0 <syscalls+0x310>
    80004302:	224010ef          	jal	ra,80005526 <panic>
    panic("unlink: writei");
    80004306:	00003517          	auipc	a0,0x3
    8000430a:	3b250513          	addi	a0,a0,946 # 800076b8 <syscalls+0x328>
    8000430e:	218010ef          	jal	ra,80005526 <panic>
    dp->nlink--;
    80004312:	04a4d783          	lhu	a5,74(s1)
    80004316:	37fd                	addiw	a5,a5,-1
    80004318:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000431c:	8526                	mv	a0,s1
    8000431e:	b18fe0ef          	jal	ra,80002636 <iupdate>
    80004322:	b7a5                	j	8000428a <sys_unlink+0xb8>
    return -1;
    80004324:	557d                	li	a0,-1
    80004326:	a811                	j	8000433a <sys_unlink+0x168>
    iunlockput(ip);
    80004328:	854a                	mv	a0,s2
    8000432a:	dc4fe0ef          	jal	ra,800028ee <iunlockput>
  iunlockput(dp);
    8000432e:	8526                	mv	a0,s1
    80004330:	dbefe0ef          	jal	ra,800028ee <iunlockput>
  end_op();
    80004334:	e03fe0ef          	jal	ra,80003136 <end_op>
  return -1;
    80004338:	557d                	li	a0,-1
}
    8000433a:	70ae                	ld	ra,232(sp)
    8000433c:	740e                	ld	s0,224(sp)
    8000433e:	64ee                	ld	s1,216(sp)
    80004340:	694e                	ld	s2,208(sp)
    80004342:	69ae                	ld	s3,200(sp)
    80004344:	616d                	addi	sp,sp,240
    80004346:	8082                	ret

0000000080004348 <sys_open>:

uint64
sys_open(void)
{
    80004348:	7131                	addi	sp,sp,-192
    8000434a:	fd06                	sd	ra,184(sp)
    8000434c:	f922                	sd	s0,176(sp)
    8000434e:	f526                	sd	s1,168(sp)
    80004350:	f14a                	sd	s2,160(sp)
    80004352:	ed4e                	sd	s3,152(sp)
    80004354:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004356:	f4c40593          	addi	a1,s0,-180
    8000435a:	4505                	li	a0,1
    8000435c:	94dfd0ef          	jal	ra,80001ca8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004360:	08000613          	li	a2,128
    80004364:	f5040593          	addi	a1,s0,-176
    80004368:	4501                	li	a0,0
    8000436a:	977fd0ef          	jal	ra,80001ce0 <argstr>
    8000436e:	87aa                	mv	a5,a0
    return -1;
    80004370:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004372:	0807cd63          	bltz	a5,8000440c <sys_open+0xc4>

  begin_op();
    80004376:	d51fe0ef          	jal	ra,800030c6 <begin_op>

  if(omode & O_CREATE){
    8000437a:	f4c42783          	lw	a5,-180(s0)
    8000437e:	2007f793          	andi	a5,a5,512
    80004382:	c3c5                	beqz	a5,80004422 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004384:	4681                	li	a3,0
    80004386:	4601                	li	a2,0
    80004388:	4589                	li	a1,2
    8000438a:	f5040513          	addi	a0,s0,-176
    8000438e:	ac1ff0ef          	jal	ra,80003e4e <create>
    80004392:	84aa                	mv	s1,a0
    if(ip == 0){
    80004394:	c159                	beqz	a0,8000441a <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004396:	04449703          	lh	a4,68(s1)
    8000439a:	478d                	li	a5,3
    8000439c:	00f71763          	bne	a4,a5,800043aa <sys_open+0x62>
    800043a0:	0464d703          	lhu	a4,70(s1)
    800043a4:	47a5                	li	a5,9
    800043a6:	0ae7e963          	bltu	a5,a4,80004458 <sys_open+0x110>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800043aa:	886ff0ef          	jal	ra,80003430 <filealloc>
    800043ae:	89aa                	mv	s3,a0
    800043b0:	0c050963          	beqz	a0,80004482 <sys_open+0x13a>
    800043b4:	a5dff0ef          	jal	ra,80003e10 <fdalloc>
    800043b8:	892a                	mv	s2,a0
    800043ba:	0c054163          	bltz	a0,8000447c <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800043be:	04449703          	lh	a4,68(s1)
    800043c2:	478d                	li	a5,3
    800043c4:	0af70163          	beq	a4,a5,80004466 <sys_open+0x11e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800043c8:	4789                	li	a5,2
    800043ca:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800043ce:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800043d2:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    800043d6:	f4c42783          	lw	a5,-180(s0)
    800043da:	0017c713          	xori	a4,a5,1
    800043de:	8b05                	andi	a4,a4,1
    800043e0:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800043e4:	0037f713          	andi	a4,a5,3
    800043e8:	00e03733          	snez	a4,a4
    800043ec:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800043f0:	4007f793          	andi	a5,a5,1024
    800043f4:	c791                	beqz	a5,80004400 <sys_open+0xb8>
    800043f6:	04449703          	lh	a4,68(s1)
    800043fa:	4789                	li	a5,2
    800043fc:	06f70c63          	beq	a4,a5,80004474 <sys_open+0x12c>
    itrunc(ip);
  }

  iunlock(ip);
    80004400:	8526                	mv	a0,s1
    80004402:	b90fe0ef          	jal	ra,80002792 <iunlock>
  end_op();
    80004406:	d31fe0ef          	jal	ra,80003136 <end_op>

  return fd;
    8000440a:	854a                	mv	a0,s2
}
    8000440c:	70ea                	ld	ra,184(sp)
    8000440e:	744a                	ld	s0,176(sp)
    80004410:	74aa                	ld	s1,168(sp)
    80004412:	790a                	ld	s2,160(sp)
    80004414:	69ea                	ld	s3,152(sp)
    80004416:	6129                	addi	sp,sp,192
    80004418:	8082                	ret
      end_op();
    8000441a:	d1dfe0ef          	jal	ra,80003136 <end_op>
      return -1;
    8000441e:	557d                	li	a0,-1
    80004420:	b7f5                	j	8000440c <sys_open+0xc4>
    if((ip = namei(path)) == 0){
    80004422:	f5040513          	addi	a0,s0,-176
    80004426:	ab1fe0ef          	jal	ra,80002ed6 <namei>
    8000442a:	84aa                	mv	s1,a0
    8000442c:	c115                	beqz	a0,80004450 <sys_open+0x108>
    ilock(ip);
    8000442e:	abafe0ef          	jal	ra,800026e8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004432:	04449703          	lh	a4,68(s1)
    80004436:	4785                	li	a5,1
    80004438:	f4f71fe3          	bne	a4,a5,80004396 <sys_open+0x4e>
    8000443c:	f4c42783          	lw	a5,-180(s0)
    80004440:	d7ad                	beqz	a5,800043aa <sys_open+0x62>
      iunlockput(ip);
    80004442:	8526                	mv	a0,s1
    80004444:	caafe0ef          	jal	ra,800028ee <iunlockput>
      end_op();
    80004448:	ceffe0ef          	jal	ra,80003136 <end_op>
      return -1;
    8000444c:	557d                	li	a0,-1
    8000444e:	bf7d                	j	8000440c <sys_open+0xc4>
      end_op();
    80004450:	ce7fe0ef          	jal	ra,80003136 <end_op>
      return -1;
    80004454:	557d                	li	a0,-1
    80004456:	bf5d                	j	8000440c <sys_open+0xc4>
    iunlockput(ip);
    80004458:	8526                	mv	a0,s1
    8000445a:	c94fe0ef          	jal	ra,800028ee <iunlockput>
    end_op();
    8000445e:	cd9fe0ef          	jal	ra,80003136 <end_op>
    return -1;
    80004462:	557d                	li	a0,-1
    80004464:	b765                	j	8000440c <sys_open+0xc4>
    f->type = FD_DEVICE;
    80004466:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    8000446a:	04649783          	lh	a5,70(s1)
    8000446e:	02f99223          	sh	a5,36(s3)
    80004472:	b785                	j	800043d2 <sys_open+0x8a>
    itrunc(ip);
    80004474:	8526                	mv	a0,s1
    80004476:	b5cfe0ef          	jal	ra,800027d2 <itrunc>
    8000447a:	b759                	j	80004400 <sys_open+0xb8>
      fileclose(f);
    8000447c:	854e                	mv	a0,s3
    8000447e:	856ff0ef          	jal	ra,800034d4 <fileclose>
    iunlockput(ip);
    80004482:	8526                	mv	a0,s1
    80004484:	c6afe0ef          	jal	ra,800028ee <iunlockput>
    end_op();
    80004488:	caffe0ef          	jal	ra,80003136 <end_op>
    return -1;
    8000448c:	557d                	li	a0,-1
    8000448e:	bfbd                	j	8000440c <sys_open+0xc4>

0000000080004490 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004490:	7175                	addi	sp,sp,-144
    80004492:	e506                	sd	ra,136(sp)
    80004494:	e122                	sd	s0,128(sp)
    80004496:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004498:	c2ffe0ef          	jal	ra,800030c6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000449c:	08000613          	li	a2,128
    800044a0:	f7040593          	addi	a1,s0,-144
    800044a4:	4501                	li	a0,0
    800044a6:	83bfd0ef          	jal	ra,80001ce0 <argstr>
    800044aa:	02054363          	bltz	a0,800044d0 <sys_mkdir+0x40>
    800044ae:	4681                	li	a3,0
    800044b0:	4601                	li	a2,0
    800044b2:	4585                	li	a1,1
    800044b4:	f7040513          	addi	a0,s0,-144
    800044b8:	997ff0ef          	jal	ra,80003e4e <create>
    800044bc:	c911                	beqz	a0,800044d0 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800044be:	c30fe0ef          	jal	ra,800028ee <iunlockput>
  end_op();
    800044c2:	c75fe0ef          	jal	ra,80003136 <end_op>
  return 0;
    800044c6:	4501                	li	a0,0
}
    800044c8:	60aa                	ld	ra,136(sp)
    800044ca:	640a                	ld	s0,128(sp)
    800044cc:	6149                	addi	sp,sp,144
    800044ce:	8082                	ret
    end_op();
    800044d0:	c67fe0ef          	jal	ra,80003136 <end_op>
    return -1;
    800044d4:	557d                	li	a0,-1
    800044d6:	bfcd                	j	800044c8 <sys_mkdir+0x38>

00000000800044d8 <sys_mknod>:

uint64
sys_mknod(void)
{
    800044d8:	7135                	addi	sp,sp,-160
    800044da:	ed06                	sd	ra,152(sp)
    800044dc:	e922                	sd	s0,144(sp)
    800044de:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800044e0:	be7fe0ef          	jal	ra,800030c6 <begin_op>
  argint(1, &major);
    800044e4:	f6c40593          	addi	a1,s0,-148
    800044e8:	4505                	li	a0,1
    800044ea:	fbefd0ef          	jal	ra,80001ca8 <argint>
  argint(2, &minor);
    800044ee:	f6840593          	addi	a1,s0,-152
    800044f2:	4509                	li	a0,2
    800044f4:	fb4fd0ef          	jal	ra,80001ca8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800044f8:	08000613          	li	a2,128
    800044fc:	f7040593          	addi	a1,s0,-144
    80004500:	4501                	li	a0,0
    80004502:	fdefd0ef          	jal	ra,80001ce0 <argstr>
    80004506:	02054563          	bltz	a0,80004530 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000450a:	f6841683          	lh	a3,-152(s0)
    8000450e:	f6c41603          	lh	a2,-148(s0)
    80004512:	458d                	li	a1,3
    80004514:	f7040513          	addi	a0,s0,-144
    80004518:	937ff0ef          	jal	ra,80003e4e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000451c:	c911                	beqz	a0,80004530 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000451e:	bd0fe0ef          	jal	ra,800028ee <iunlockput>
  end_op();
    80004522:	c15fe0ef          	jal	ra,80003136 <end_op>
  return 0;
    80004526:	4501                	li	a0,0
}
    80004528:	60ea                	ld	ra,152(sp)
    8000452a:	644a                	ld	s0,144(sp)
    8000452c:	610d                	addi	sp,sp,160
    8000452e:	8082                	ret
    end_op();
    80004530:	c07fe0ef          	jal	ra,80003136 <end_op>
    return -1;
    80004534:	557d                	li	a0,-1
    80004536:	bfcd                	j	80004528 <sys_mknod+0x50>

0000000080004538 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004538:	7135                	addi	sp,sp,-160
    8000453a:	ed06                	sd	ra,152(sp)
    8000453c:	e922                	sd	s0,144(sp)
    8000453e:	e526                	sd	s1,136(sp)
    80004540:	e14a                	sd	s2,128(sp)
    80004542:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004544:	ff4fc0ef          	jal	ra,80000d38 <myproc>
    80004548:	892a                	mv	s2,a0
  
  begin_op();
    8000454a:	b7dfe0ef          	jal	ra,800030c6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000454e:	08000613          	li	a2,128
    80004552:	f6040593          	addi	a1,s0,-160
    80004556:	4501                	li	a0,0
    80004558:	f88fd0ef          	jal	ra,80001ce0 <argstr>
    8000455c:	04054163          	bltz	a0,8000459e <sys_chdir+0x66>
    80004560:	f6040513          	addi	a0,s0,-160
    80004564:	973fe0ef          	jal	ra,80002ed6 <namei>
    80004568:	84aa                	mv	s1,a0
    8000456a:	c915                	beqz	a0,8000459e <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000456c:	97cfe0ef          	jal	ra,800026e8 <ilock>
  if(ip->type != T_DIR){
    80004570:	04449703          	lh	a4,68(s1)
    80004574:	4785                	li	a5,1
    80004576:	02f71863          	bne	a4,a5,800045a6 <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000457a:	8526                	mv	a0,s1
    8000457c:	a16fe0ef          	jal	ra,80002792 <iunlock>
  iput(p->cwd);
    80004580:	15093503          	ld	a0,336(s2)
    80004584:	ae2fe0ef          	jal	ra,80002866 <iput>
  end_op();
    80004588:	baffe0ef          	jal	ra,80003136 <end_op>
  p->cwd = ip;
    8000458c:	14993823          	sd	s1,336(s2)
  return 0;
    80004590:	4501                	li	a0,0
}
    80004592:	60ea                	ld	ra,152(sp)
    80004594:	644a                	ld	s0,144(sp)
    80004596:	64aa                	ld	s1,136(sp)
    80004598:	690a                	ld	s2,128(sp)
    8000459a:	610d                	addi	sp,sp,160
    8000459c:	8082                	ret
    end_op();
    8000459e:	b99fe0ef          	jal	ra,80003136 <end_op>
    return -1;
    800045a2:	557d                	li	a0,-1
    800045a4:	b7fd                	j	80004592 <sys_chdir+0x5a>
    iunlockput(ip);
    800045a6:	8526                	mv	a0,s1
    800045a8:	b46fe0ef          	jal	ra,800028ee <iunlockput>
    end_op();
    800045ac:	b8bfe0ef          	jal	ra,80003136 <end_op>
    return -1;
    800045b0:	557d                	li	a0,-1
    800045b2:	b7c5                	j	80004592 <sys_chdir+0x5a>

00000000800045b4 <sys_exec>:

uint64
sys_exec(void)
{
    800045b4:	7145                	addi	sp,sp,-464
    800045b6:	e786                	sd	ra,456(sp)
    800045b8:	e3a2                	sd	s0,448(sp)
    800045ba:	ff26                	sd	s1,440(sp)
    800045bc:	fb4a                	sd	s2,432(sp)
    800045be:	f74e                	sd	s3,424(sp)
    800045c0:	f352                	sd	s4,416(sp)
    800045c2:	ef56                	sd	s5,408(sp)
    800045c4:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800045c6:	e3840593          	addi	a1,s0,-456
    800045ca:	4505                	li	a0,1
    800045cc:	ef8fd0ef          	jal	ra,80001cc4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800045d0:	08000613          	li	a2,128
    800045d4:	f4040593          	addi	a1,s0,-192
    800045d8:	4501                	li	a0,0
    800045da:	f06fd0ef          	jal	ra,80001ce0 <argstr>
    800045de:	87aa                	mv	a5,a0
    return -1;
    800045e0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800045e2:	0a07c463          	bltz	a5,8000468a <sys_exec+0xd6>
  }
  memset(argv, 0, sizeof(argv));
    800045e6:	10000613          	li	a2,256
    800045ea:	4581                	li	a1,0
    800045ec:	e4040513          	addi	a0,s0,-448
    800045f0:	b5dfb0ef          	jal	ra,8000014c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800045f4:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800045f8:	89a6                	mv	s3,s1
    800045fa:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800045fc:	02000a13          	li	s4,32
    80004600:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004604:	00391513          	slli	a0,s2,0x3
    80004608:	e3040593          	addi	a1,s0,-464
    8000460c:	e3843783          	ld	a5,-456(s0)
    80004610:	953e                	add	a0,a0,a5
    80004612:	e0cfd0ef          	jal	ra,80001c1e <fetchaddr>
    80004616:	02054663          	bltz	a0,80004642 <sys_exec+0x8e>
      goto bad;
    }
    if(uarg == 0){
    8000461a:	e3043783          	ld	a5,-464(s0)
    8000461e:	cf8d                	beqz	a5,80004658 <sys_exec+0xa4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004620:	addfb0ef          	jal	ra,800000fc <kalloc>
    80004624:	85aa                	mv	a1,a0
    80004626:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000462a:	cd01                	beqz	a0,80004642 <sys_exec+0x8e>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000462c:	6605                	lui	a2,0x1
    8000462e:	e3043503          	ld	a0,-464(s0)
    80004632:	e36fd0ef          	jal	ra,80001c68 <fetchstr>
    80004636:	00054663          	bltz	a0,80004642 <sys_exec+0x8e>
    if(i >= NELEM(argv)){
    8000463a:	0905                	addi	s2,s2,1
    8000463c:	09a1                	addi	s3,s3,8
    8000463e:	fd4911e3          	bne	s2,s4,80004600 <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004642:	10048913          	addi	s2,s1,256
    80004646:	6088                	ld	a0,0(s1)
    80004648:	c121                	beqz	a0,80004688 <sys_exec+0xd4>
    kfree(argv[i]);
    8000464a:	9d3fb0ef          	jal	ra,8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000464e:	04a1                	addi	s1,s1,8
    80004650:	ff249be3          	bne	s1,s2,80004646 <sys_exec+0x92>
  return -1;
    80004654:	557d                	li	a0,-1
    80004656:	a815                	j	8000468a <sys_exec+0xd6>
      argv[i] = 0;
    80004658:	0a8e                	slli	s5,s5,0x3
    8000465a:	fc040793          	addi	a5,s0,-64
    8000465e:	9abe                	add	s5,s5,a5
    80004660:	e80ab023          	sd	zero,-384(s5)
  int ret = kexec(path, argv);
    80004664:	e4040593          	addi	a1,s0,-448
    80004668:	f4040513          	addi	a0,s0,-192
    8000466c:	c18ff0ef          	jal	ra,80003a84 <kexec>
    80004670:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004672:	10048993          	addi	s3,s1,256
    80004676:	6088                	ld	a0,0(s1)
    80004678:	c511                	beqz	a0,80004684 <sys_exec+0xd0>
    kfree(argv[i]);
    8000467a:	9a3fb0ef          	jal	ra,8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000467e:	04a1                	addi	s1,s1,8
    80004680:	ff349be3          	bne	s1,s3,80004676 <sys_exec+0xc2>
  return ret;
    80004684:	854a                	mv	a0,s2
    80004686:	a011                	j	8000468a <sys_exec+0xd6>
  return -1;
    80004688:	557d                	li	a0,-1
}
    8000468a:	60be                	ld	ra,456(sp)
    8000468c:	641e                	ld	s0,448(sp)
    8000468e:	74fa                	ld	s1,440(sp)
    80004690:	795a                	ld	s2,432(sp)
    80004692:	79ba                	ld	s3,424(sp)
    80004694:	7a1a                	ld	s4,416(sp)
    80004696:	6afa                	ld	s5,408(sp)
    80004698:	6179                	addi	sp,sp,464
    8000469a:	8082                	ret

000000008000469c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000469c:	7139                	addi	sp,sp,-64
    8000469e:	fc06                	sd	ra,56(sp)
    800046a0:	f822                	sd	s0,48(sp)
    800046a2:	f426                	sd	s1,40(sp)
    800046a4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800046a6:	e92fc0ef          	jal	ra,80000d38 <myproc>
    800046aa:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800046ac:	fd840593          	addi	a1,s0,-40
    800046b0:	4501                	li	a0,0
    800046b2:	e12fd0ef          	jal	ra,80001cc4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800046b6:	fc840593          	addi	a1,s0,-56
    800046ba:	fd040513          	addi	a0,s0,-48
    800046be:	8e2ff0ef          	jal	ra,800037a0 <pipealloc>
    return -1;
    800046c2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800046c4:	0a054463          	bltz	a0,8000476c <sys_pipe+0xd0>
  fd0 = -1;
    800046c8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800046cc:	fd043503          	ld	a0,-48(s0)
    800046d0:	f40ff0ef          	jal	ra,80003e10 <fdalloc>
    800046d4:	fca42223          	sw	a0,-60(s0)
    800046d8:	08054163          	bltz	a0,8000475a <sys_pipe+0xbe>
    800046dc:	fc843503          	ld	a0,-56(s0)
    800046e0:	f30ff0ef          	jal	ra,80003e10 <fdalloc>
    800046e4:	fca42023          	sw	a0,-64(s0)
    800046e8:	06054063          	bltz	a0,80004748 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800046ec:	4691                	li	a3,4
    800046ee:	fc440613          	addi	a2,s0,-60
    800046f2:	fd843583          	ld	a1,-40(s0)
    800046f6:	68a8                	ld	a0,80(s1)
    800046f8:	b88fc0ef          	jal	ra,80000a80 <copyout>
    800046fc:	00054e63          	bltz	a0,80004718 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004700:	4691                	li	a3,4
    80004702:	fc040613          	addi	a2,s0,-64
    80004706:	fd843583          	ld	a1,-40(s0)
    8000470a:	0591                	addi	a1,a1,4
    8000470c:	68a8                	ld	a0,80(s1)
    8000470e:	b72fc0ef          	jal	ra,80000a80 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004712:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004714:	04055c63          	bgez	a0,8000476c <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004718:	fc442783          	lw	a5,-60(s0)
    8000471c:	07e9                	addi	a5,a5,26
    8000471e:	078e                	slli	a5,a5,0x3
    80004720:	97a6                	add	a5,a5,s1
    80004722:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004726:	fc042503          	lw	a0,-64(s0)
    8000472a:	0569                	addi	a0,a0,26
    8000472c:	050e                	slli	a0,a0,0x3
    8000472e:	94aa                	add	s1,s1,a0
    80004730:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004734:	fd043503          	ld	a0,-48(s0)
    80004738:	d9dfe0ef          	jal	ra,800034d4 <fileclose>
    fileclose(wf);
    8000473c:	fc843503          	ld	a0,-56(s0)
    80004740:	d95fe0ef          	jal	ra,800034d4 <fileclose>
    return -1;
    80004744:	57fd                	li	a5,-1
    80004746:	a01d                	j	8000476c <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004748:	fc442783          	lw	a5,-60(s0)
    8000474c:	0007c763          	bltz	a5,8000475a <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004750:	07e9                	addi	a5,a5,26
    80004752:	078e                	slli	a5,a5,0x3
    80004754:	94be                	add	s1,s1,a5
    80004756:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000475a:	fd043503          	ld	a0,-48(s0)
    8000475e:	d77fe0ef          	jal	ra,800034d4 <fileclose>
    fileclose(wf);
    80004762:	fc843503          	ld	a0,-56(s0)
    80004766:	d6ffe0ef          	jal	ra,800034d4 <fileclose>
    return -1;
    8000476a:	57fd                	li	a5,-1
}
    8000476c:	853e                	mv	a0,a5
    8000476e:	70e2                	ld	ra,56(sp)
    80004770:	7442                	ld	s0,48(sp)
    80004772:	74a2                	ld	s1,40(sp)
    80004774:	6121                	addi	sp,sp,64
    80004776:	8082                	ret
	...

0000000080004780 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004780:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004782:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004784:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004786:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004788:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000478a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000478c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000478e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004790:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004792:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004794:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004796:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004798:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000479a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000479c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000479e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    800047a0:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    800047a2:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    800047a4:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    800047a6:	b88fd0ef          	jal	ra,80001b2e <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    800047aa:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    800047ac:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    800047ae:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    800047b0:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    800047b2:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    800047b4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    800047b6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    800047b8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    800047ba:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    800047bc:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    800047be:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    800047c0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    800047c2:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    800047c4:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    800047c6:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    800047c8:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    800047ca:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    800047cc:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    800047ce:	10200073          	sret
	...

00000000800047de <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800047de:	1141                	addi	sp,sp,-16
    800047e0:	e422                	sd	s0,8(sp)
    800047e2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800047e4:	0c0007b7          	lui	a5,0xc000
    800047e8:	4705                	li	a4,1
    800047ea:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800047ec:	c3d8                	sw	a4,4(a5)
}
    800047ee:	6422                	ld	s0,8(sp)
    800047f0:	0141                	addi	sp,sp,16
    800047f2:	8082                	ret

00000000800047f4 <plicinithart>:

void
plicinithart(void)
{
    800047f4:	1141                	addi	sp,sp,-16
    800047f6:	e406                	sd	ra,8(sp)
    800047f8:	e022                	sd	s0,0(sp)
    800047fa:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800047fc:	d10fc0ef          	jal	ra,80000d0c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004800:	0085171b          	slliw	a4,a0,0x8
    80004804:	0c0027b7          	lui	a5,0xc002
    80004808:	97ba                	add	a5,a5,a4
    8000480a:	40200713          	li	a4,1026
    8000480e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004812:	00d5151b          	slliw	a0,a0,0xd
    80004816:	0c2017b7          	lui	a5,0xc201
    8000481a:	953e                	add	a0,a0,a5
    8000481c:	00052023          	sw	zero,0(a0)
}
    80004820:	60a2                	ld	ra,8(sp)
    80004822:	6402                	ld	s0,0(sp)
    80004824:	0141                	addi	sp,sp,16
    80004826:	8082                	ret

0000000080004828 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004828:	1141                	addi	sp,sp,-16
    8000482a:	e406                	sd	ra,8(sp)
    8000482c:	e022                	sd	s0,0(sp)
    8000482e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004830:	cdcfc0ef          	jal	ra,80000d0c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004834:	00d5179b          	slliw	a5,a0,0xd
    80004838:	0c201537          	lui	a0,0xc201
    8000483c:	953e                	add	a0,a0,a5
  return irq;
}
    8000483e:	4148                	lw	a0,4(a0)
    80004840:	60a2                	ld	ra,8(sp)
    80004842:	6402                	ld	s0,0(sp)
    80004844:	0141                	addi	sp,sp,16
    80004846:	8082                	ret

0000000080004848 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004848:	1101                	addi	sp,sp,-32
    8000484a:	ec06                	sd	ra,24(sp)
    8000484c:	e822                	sd	s0,16(sp)
    8000484e:	e426                	sd	s1,8(sp)
    80004850:	1000                	addi	s0,sp,32
    80004852:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004854:	cb8fc0ef          	jal	ra,80000d0c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004858:	00d5151b          	slliw	a0,a0,0xd
    8000485c:	0c2017b7          	lui	a5,0xc201
    80004860:	97aa                	add	a5,a5,a0
    80004862:	c3c4                	sw	s1,4(a5)
}
    80004864:	60e2                	ld	ra,24(sp)
    80004866:	6442                	ld	s0,16(sp)
    80004868:	64a2                	ld	s1,8(sp)
    8000486a:	6105                	addi	sp,sp,32
    8000486c:	8082                	ret

000000008000486e <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000486e:	1141                	addi	sp,sp,-16
    80004870:	e406                	sd	ra,8(sp)
    80004872:	e022                	sd	s0,0(sp)
    80004874:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004876:	479d                	li	a5,7
    80004878:	04a7ca63          	blt	a5,a0,800048cc <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    8000487c:	00014797          	auipc	a5,0x14
    80004880:	11478793          	addi	a5,a5,276 # 80018990 <disk>
    80004884:	97aa                	add	a5,a5,a0
    80004886:	0187c783          	lbu	a5,24(a5)
    8000488a:	e7b9                	bnez	a5,800048d8 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000488c:	00451613          	slli	a2,a0,0x4
    80004890:	00014797          	auipc	a5,0x14
    80004894:	10078793          	addi	a5,a5,256 # 80018990 <disk>
    80004898:	6394                	ld	a3,0(a5)
    8000489a:	96b2                	add	a3,a3,a2
    8000489c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800048a0:	6398                	ld	a4,0(a5)
    800048a2:	9732                	add	a4,a4,a2
    800048a4:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800048a8:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800048ac:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800048b0:	953e                	add	a0,a0,a5
    800048b2:	4785                	li	a5,1
    800048b4:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800048b8:	00014517          	auipc	a0,0x14
    800048bc:	0f050513          	addi	a0,a0,240 # 800189a8 <disk+0x18>
    800048c0:	ab7fc0ef          	jal	ra,80001376 <wakeup>
}
    800048c4:	60a2                	ld	ra,8(sp)
    800048c6:	6402                	ld	s0,0(sp)
    800048c8:	0141                	addi	sp,sp,16
    800048ca:	8082                	ret
    panic("free_desc 1");
    800048cc:	00003517          	auipc	a0,0x3
    800048d0:	dfc50513          	addi	a0,a0,-516 # 800076c8 <syscalls+0x338>
    800048d4:	453000ef          	jal	ra,80005526 <panic>
    panic("free_desc 2");
    800048d8:	00003517          	auipc	a0,0x3
    800048dc:	e0050513          	addi	a0,a0,-512 # 800076d8 <syscalls+0x348>
    800048e0:	447000ef          	jal	ra,80005526 <panic>

00000000800048e4 <virtio_disk_init>:
{
    800048e4:	1101                	addi	sp,sp,-32
    800048e6:	ec06                	sd	ra,24(sp)
    800048e8:	e822                	sd	s0,16(sp)
    800048ea:	e426                	sd	s1,8(sp)
    800048ec:	e04a                	sd	s2,0(sp)
    800048ee:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800048f0:	00003597          	auipc	a1,0x3
    800048f4:	df858593          	addi	a1,a1,-520 # 800076e8 <syscalls+0x358>
    800048f8:	00014517          	auipc	a0,0x14
    800048fc:	1c050513          	addi	a0,a0,448 # 80018ab8 <disk+0x128>
    80004900:	661000ef          	jal	ra,80005760 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004904:	100017b7          	lui	a5,0x10001
    80004908:	4398                	lw	a4,0(a5)
    8000490a:	2701                	sext.w	a4,a4
    8000490c:	747277b7          	lui	a5,0x74727
    80004910:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004914:	14f71263          	bne	a4,a5,80004a58 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004918:	100017b7          	lui	a5,0x10001
    8000491c:	43dc                	lw	a5,4(a5)
    8000491e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004920:	4709                	li	a4,2
    80004922:	12e79b63          	bne	a5,a4,80004a58 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004926:	100017b7          	lui	a5,0x10001
    8000492a:	479c                	lw	a5,8(a5)
    8000492c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000492e:	12e79563          	bne	a5,a4,80004a58 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004932:	100017b7          	lui	a5,0x10001
    80004936:	47d8                	lw	a4,12(a5)
    80004938:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000493a:	554d47b7          	lui	a5,0x554d4
    8000493e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004942:	10f71b63          	bne	a4,a5,80004a58 <virtio_disk_init+0x174>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004946:	100017b7          	lui	a5,0x10001
    8000494a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000494e:	4705                	li	a4,1
    80004950:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004952:	470d                	li	a4,3
    80004954:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004956:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004958:	c7ffe737          	lui	a4,0xc7ffe
    8000495c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fddbb7>
    80004960:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004962:	2701                	sext.w	a4,a4
    80004964:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004966:	472d                	li	a4,11
    80004968:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    8000496a:	0707a903          	lw	s2,112(a5)
    8000496e:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004970:	00897793          	andi	a5,s2,8
    80004974:	0e078863          	beqz	a5,80004a64 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004978:	100017b7          	lui	a5,0x10001
    8000497c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004980:	43fc                	lw	a5,68(a5)
    80004982:	2781                	sext.w	a5,a5
    80004984:	0e079663          	bnez	a5,80004a70 <virtio_disk_init+0x18c>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004988:	100017b7          	lui	a5,0x10001
    8000498c:	5bdc                	lw	a5,52(a5)
    8000498e:	2781                	sext.w	a5,a5
  if(max == 0)
    80004990:	0e078663          	beqz	a5,80004a7c <virtio_disk_init+0x198>
  if(max < NUM)
    80004994:	471d                	li	a4,7
    80004996:	0ef77963          	bgeu	a4,a5,80004a88 <virtio_disk_init+0x1a4>
  disk.desc = kalloc();
    8000499a:	f62fb0ef          	jal	ra,800000fc <kalloc>
    8000499e:	00014497          	auipc	s1,0x14
    800049a2:	ff248493          	addi	s1,s1,-14 # 80018990 <disk>
    800049a6:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800049a8:	f54fb0ef          	jal	ra,800000fc <kalloc>
    800049ac:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800049ae:	f4efb0ef          	jal	ra,800000fc <kalloc>
    800049b2:	87aa                	mv	a5,a0
    800049b4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800049b6:	6088                	ld	a0,0(s1)
    800049b8:	cd71                	beqz	a0,80004a94 <virtio_disk_init+0x1b0>
    800049ba:	00014717          	auipc	a4,0x14
    800049be:	fde73703          	ld	a4,-34(a4) # 80018998 <disk+0x8>
    800049c2:	cb69                	beqz	a4,80004a94 <virtio_disk_init+0x1b0>
    800049c4:	cbe1                	beqz	a5,80004a94 <virtio_disk_init+0x1b0>
  memset(disk.desc, 0, PGSIZE);
    800049c6:	6605                	lui	a2,0x1
    800049c8:	4581                	li	a1,0
    800049ca:	f82fb0ef          	jal	ra,8000014c <memset>
  memset(disk.avail, 0, PGSIZE);
    800049ce:	00014497          	auipc	s1,0x14
    800049d2:	fc248493          	addi	s1,s1,-62 # 80018990 <disk>
    800049d6:	6605                	lui	a2,0x1
    800049d8:	4581                	li	a1,0
    800049da:	6488                	ld	a0,8(s1)
    800049dc:	f70fb0ef          	jal	ra,8000014c <memset>
  memset(disk.used, 0, PGSIZE);
    800049e0:	6605                	lui	a2,0x1
    800049e2:	4581                	li	a1,0
    800049e4:	6888                	ld	a0,16(s1)
    800049e6:	f66fb0ef          	jal	ra,8000014c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800049ea:	100017b7          	lui	a5,0x10001
    800049ee:	4721                	li	a4,8
    800049f0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800049f2:	4098                	lw	a4,0(s1)
    800049f4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800049f8:	40d8                	lw	a4,4(s1)
    800049fa:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800049fe:	6498                	ld	a4,8(s1)
    80004a00:	0007069b          	sext.w	a3,a4
    80004a04:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004a08:	9701                	srai	a4,a4,0x20
    80004a0a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004a0e:	6898                	ld	a4,16(s1)
    80004a10:	0007069b          	sext.w	a3,a4
    80004a14:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004a18:	9701                	srai	a4,a4,0x20
    80004a1a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004a1e:	4685                	li	a3,1
    80004a20:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80004a22:	4705                	li	a4,1
    80004a24:	00d48c23          	sb	a3,24(s1)
    80004a28:	00e48ca3          	sb	a4,25(s1)
    80004a2c:	00e48d23          	sb	a4,26(s1)
    80004a30:	00e48da3          	sb	a4,27(s1)
    80004a34:	00e48e23          	sb	a4,28(s1)
    80004a38:	00e48ea3          	sb	a4,29(s1)
    80004a3c:	00e48f23          	sb	a4,30(s1)
    80004a40:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004a44:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a48:	0727a823          	sw	s2,112(a5)
}
    80004a4c:	60e2                	ld	ra,24(sp)
    80004a4e:	6442                	ld	s0,16(sp)
    80004a50:	64a2                	ld	s1,8(sp)
    80004a52:	6902                	ld	s2,0(sp)
    80004a54:	6105                	addi	sp,sp,32
    80004a56:	8082                	ret
    panic("could not find virtio disk");
    80004a58:	00003517          	auipc	a0,0x3
    80004a5c:	ca050513          	addi	a0,a0,-864 # 800076f8 <syscalls+0x368>
    80004a60:	2c7000ef          	jal	ra,80005526 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004a64:	00003517          	auipc	a0,0x3
    80004a68:	cb450513          	addi	a0,a0,-844 # 80007718 <syscalls+0x388>
    80004a6c:	2bb000ef          	jal	ra,80005526 <panic>
    panic("virtio disk should not be ready");
    80004a70:	00003517          	auipc	a0,0x3
    80004a74:	cc850513          	addi	a0,a0,-824 # 80007738 <syscalls+0x3a8>
    80004a78:	2af000ef          	jal	ra,80005526 <panic>
    panic("virtio disk has no queue 0");
    80004a7c:	00003517          	auipc	a0,0x3
    80004a80:	cdc50513          	addi	a0,a0,-804 # 80007758 <syscalls+0x3c8>
    80004a84:	2a3000ef          	jal	ra,80005526 <panic>
    panic("virtio disk max queue too short");
    80004a88:	00003517          	auipc	a0,0x3
    80004a8c:	cf050513          	addi	a0,a0,-784 # 80007778 <syscalls+0x3e8>
    80004a90:	297000ef          	jal	ra,80005526 <panic>
    panic("virtio disk kalloc");
    80004a94:	00003517          	auipc	a0,0x3
    80004a98:	d0450513          	addi	a0,a0,-764 # 80007798 <syscalls+0x408>
    80004a9c:	28b000ef          	jal	ra,80005526 <panic>

0000000080004aa0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004aa0:	7159                	addi	sp,sp,-112
    80004aa2:	f486                	sd	ra,104(sp)
    80004aa4:	f0a2                	sd	s0,96(sp)
    80004aa6:	eca6                	sd	s1,88(sp)
    80004aa8:	e8ca                	sd	s2,80(sp)
    80004aaa:	e4ce                	sd	s3,72(sp)
    80004aac:	e0d2                	sd	s4,64(sp)
    80004aae:	fc56                	sd	s5,56(sp)
    80004ab0:	f85a                	sd	s6,48(sp)
    80004ab2:	f45e                	sd	s7,40(sp)
    80004ab4:	f062                	sd	s8,32(sp)
    80004ab6:	ec66                	sd	s9,24(sp)
    80004ab8:	e86a                	sd	s10,16(sp)
    80004aba:	1880                	addi	s0,sp,112
    80004abc:	892a                	mv	s2,a0
    80004abe:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004ac0:	00c52c83          	lw	s9,12(a0)
    80004ac4:	001c9c9b          	slliw	s9,s9,0x1
    80004ac8:	1c82                	slli	s9,s9,0x20
    80004aca:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004ace:	00014517          	auipc	a0,0x14
    80004ad2:	fea50513          	addi	a0,a0,-22 # 80018ab8 <disk+0x128>
    80004ad6:	50b000ef          	jal	ra,800057e0 <acquire>
  for(int i = 0; i < 3; i++){
    80004ada:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004adc:	4ba1                	li	s7,8
      disk.free[i] = 0;
    80004ade:	00014b17          	auipc	s6,0x14
    80004ae2:	eb2b0b13          	addi	s6,s6,-334 # 80018990 <disk>
  for(int i = 0; i < 3; i++){
    80004ae6:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80004ae8:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004aea:	00014c17          	auipc	s8,0x14
    80004aee:	fcec0c13          	addi	s8,s8,-50 # 80018ab8 <disk+0x128>
    80004af2:	a0b5                	j	80004b5e <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80004af4:	00fb06b3          	add	a3,s6,a5
    80004af8:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80004afc:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80004afe:	0207c563          	bltz	a5,80004b28 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80004b02:	2485                	addiw	s1,s1,1
    80004b04:	0711                	addi	a4,a4,4
    80004b06:	1d548c63          	beq	s1,s5,80004cde <virtio_disk_rw+0x23e>
    idx[i] = alloc_desc();
    80004b0a:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80004b0c:	00014697          	auipc	a3,0x14
    80004b10:	e8468693          	addi	a3,a3,-380 # 80018990 <disk>
    80004b14:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80004b16:	0186c583          	lbu	a1,24(a3)
    80004b1a:	fde9                	bnez	a1,80004af4 <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80004b1c:	2785                	addiw	a5,a5,1
    80004b1e:	0685                	addi	a3,a3,1
    80004b20:	ff779be3          	bne	a5,s7,80004b16 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80004b24:	57fd                	li	a5,-1
    80004b26:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80004b28:	02905463          	blez	s1,80004b50 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    80004b2c:	f9042503          	lw	a0,-112(s0)
    80004b30:	d3fff0ef          	jal	ra,8000486e <free_desc>
      for(int j = 0; j < i; j++)
    80004b34:	4785                	li	a5,1
    80004b36:	0097dd63          	bge	a5,s1,80004b50 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    80004b3a:	f9442503          	lw	a0,-108(s0)
    80004b3e:	d31ff0ef          	jal	ra,8000486e <free_desc>
      for(int j = 0; j < i; j++)
    80004b42:	4789                	li	a5,2
    80004b44:	0097d663          	bge	a5,s1,80004b50 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    80004b48:	f9842503          	lw	a0,-104(s0)
    80004b4c:	d23ff0ef          	jal	ra,8000486e <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b50:	85e2                	mv	a1,s8
    80004b52:	00014517          	auipc	a0,0x14
    80004b56:	e5650513          	addi	a0,a0,-426 # 800189a8 <disk+0x18>
    80004b5a:	fd0fc0ef          	jal	ra,8000132a <sleep>
  for(int i = 0; i < 3; i++){
    80004b5e:	f9040713          	addi	a4,s0,-112
    80004b62:	84ce                	mv	s1,s3
    80004b64:	b75d                	j	80004b0a <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80004b66:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80004b6a:	00479693          	slli	a3,a5,0x4
    80004b6e:	00014797          	auipc	a5,0x14
    80004b72:	e2278793          	addi	a5,a5,-478 # 80018990 <disk>
    80004b76:	97b6                	add	a5,a5,a3
    80004b78:	4685                	li	a3,1
    80004b7a:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004b7c:	00014597          	auipc	a1,0x14
    80004b80:	e1458593          	addi	a1,a1,-492 # 80018990 <disk>
    80004b84:	00a60793          	addi	a5,a2,10
    80004b88:	0792                	slli	a5,a5,0x4
    80004b8a:	97ae                	add	a5,a5,a1
    80004b8c:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    80004b90:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004b94:	f6070693          	addi	a3,a4,-160
    80004b98:	619c                	ld	a5,0(a1)
    80004b9a:	97b6                	add	a5,a5,a3
    80004b9c:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004b9e:	6188                	ld	a0,0(a1)
    80004ba0:	96aa                	add	a3,a3,a0
    80004ba2:	47c1                	li	a5,16
    80004ba4:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004ba6:	4785                	li	a5,1
    80004ba8:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80004bac:	f9442783          	lw	a5,-108(s0)
    80004bb0:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004bb4:	0792                	slli	a5,a5,0x4
    80004bb6:	953e                	add	a0,a0,a5
    80004bb8:	05890693          	addi	a3,s2,88
    80004bbc:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    80004bbe:	6188                	ld	a0,0(a1)
    80004bc0:	97aa                	add	a5,a5,a0
    80004bc2:	40000693          	li	a3,1024
    80004bc6:	c794                	sw	a3,8(a5)
  if(write)
    80004bc8:	100d0763          	beqz	s10,80004cd6 <virtio_disk_rw+0x236>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80004bcc:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004bd0:	00c7d683          	lhu	a3,12(a5)
    80004bd4:	0016e693          	ori	a3,a3,1
    80004bd8:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80004bdc:	f9842583          	lw	a1,-104(s0)
    80004be0:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004be4:	00014697          	auipc	a3,0x14
    80004be8:	dac68693          	addi	a3,a3,-596 # 80018990 <disk>
    80004bec:	00260793          	addi	a5,a2,2
    80004bf0:	0792                	slli	a5,a5,0x4
    80004bf2:	97b6                	add	a5,a5,a3
    80004bf4:	587d                	li	a6,-1
    80004bf6:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004bfa:	0592                	slli	a1,a1,0x4
    80004bfc:	952e                	add	a0,a0,a1
    80004bfe:	f9070713          	addi	a4,a4,-112
    80004c02:	9736                	add	a4,a4,a3
    80004c04:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80004c06:	6298                	ld	a4,0(a3)
    80004c08:	972e                	add	a4,a4,a1
    80004c0a:	4585                	li	a1,1
    80004c0c:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004c0e:	4509                	li	a0,2
    80004c10:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80004c14:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004c18:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80004c1c:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004c20:	6698                	ld	a4,8(a3)
    80004c22:	00275783          	lhu	a5,2(a4)
    80004c26:	8b9d                	andi	a5,a5,7
    80004c28:	0786                	slli	a5,a5,0x1
    80004c2a:	97ba                	add	a5,a5,a4
    80004c2c:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    80004c30:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004c34:	6698                	ld	a4,8(a3)
    80004c36:	00275783          	lhu	a5,2(a4)
    80004c3a:	2785                	addiw	a5,a5,1
    80004c3c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004c40:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004c44:	100017b7          	lui	a5,0x10001
    80004c48:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004c4c:	00492703          	lw	a4,4(s2)
    80004c50:	4785                	li	a5,1
    80004c52:	00f71f63          	bne	a4,a5,80004c70 <virtio_disk_rw+0x1d0>
    sleep(b, &disk.vdisk_lock);
    80004c56:	00014997          	auipc	s3,0x14
    80004c5a:	e6298993          	addi	s3,s3,-414 # 80018ab8 <disk+0x128>
  while(b->disk == 1) {
    80004c5e:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80004c60:	85ce                	mv	a1,s3
    80004c62:	854a                	mv	a0,s2
    80004c64:	ec6fc0ef          	jal	ra,8000132a <sleep>
  while(b->disk == 1) {
    80004c68:	00492783          	lw	a5,4(s2)
    80004c6c:	fe978ae3          	beq	a5,s1,80004c60 <virtio_disk_rw+0x1c0>
  }

  disk.info[idx[0]].b = 0;
    80004c70:	f9042903          	lw	s2,-112(s0)
    80004c74:	00290793          	addi	a5,s2,2
    80004c78:	00479713          	slli	a4,a5,0x4
    80004c7c:	00014797          	auipc	a5,0x14
    80004c80:	d1478793          	addi	a5,a5,-748 # 80018990 <disk>
    80004c84:	97ba                	add	a5,a5,a4
    80004c86:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004c8a:	00014997          	auipc	s3,0x14
    80004c8e:	d0698993          	addi	s3,s3,-762 # 80018990 <disk>
    80004c92:	00491713          	slli	a4,s2,0x4
    80004c96:	0009b783          	ld	a5,0(s3)
    80004c9a:	97ba                	add	a5,a5,a4
    80004c9c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004ca0:	854a                	mv	a0,s2
    80004ca2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004ca6:	bc9ff0ef          	jal	ra,8000486e <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004caa:	8885                	andi	s1,s1,1
    80004cac:	f0fd                	bnez	s1,80004c92 <virtio_disk_rw+0x1f2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004cae:	00014517          	auipc	a0,0x14
    80004cb2:	e0a50513          	addi	a0,a0,-502 # 80018ab8 <disk+0x128>
    80004cb6:	3c3000ef          	jal	ra,80005878 <release>
}
    80004cba:	70a6                	ld	ra,104(sp)
    80004cbc:	7406                	ld	s0,96(sp)
    80004cbe:	64e6                	ld	s1,88(sp)
    80004cc0:	6946                	ld	s2,80(sp)
    80004cc2:	69a6                	ld	s3,72(sp)
    80004cc4:	6a06                	ld	s4,64(sp)
    80004cc6:	7ae2                	ld	s5,56(sp)
    80004cc8:	7b42                	ld	s6,48(sp)
    80004cca:	7ba2                	ld	s7,40(sp)
    80004ccc:	7c02                	ld	s8,32(sp)
    80004cce:	6ce2                	ld	s9,24(sp)
    80004cd0:	6d42                	ld	s10,16(sp)
    80004cd2:	6165                	addi	sp,sp,112
    80004cd4:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80004cd6:	4689                	li	a3,2
    80004cd8:	00d79623          	sh	a3,12(a5)
    80004cdc:	bdd5                	j	80004bd0 <virtio_disk_rw+0x130>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004cde:	f9042603          	lw	a2,-112(s0)
    80004ce2:	00a60713          	addi	a4,a2,10
    80004ce6:	0712                	slli	a4,a4,0x4
    80004ce8:	00014517          	auipc	a0,0x14
    80004cec:	cb050513          	addi	a0,a0,-848 # 80018998 <disk+0x8>
    80004cf0:	953a                	add	a0,a0,a4
  if(write)
    80004cf2:	e60d1ae3          	bnez	s10,80004b66 <virtio_disk_rw+0xc6>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80004cf6:	00a60793          	addi	a5,a2,10
    80004cfa:	00479693          	slli	a3,a5,0x4
    80004cfe:	00014797          	auipc	a5,0x14
    80004d02:	c9278793          	addi	a5,a5,-878 # 80018990 <disk>
    80004d06:	97b6                	add	a5,a5,a3
    80004d08:	0007a423          	sw	zero,8(a5)
    80004d0c:	bd85                	j	80004b7c <virtio_disk_rw+0xdc>

0000000080004d0e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004d0e:	1101                	addi	sp,sp,-32
    80004d10:	ec06                	sd	ra,24(sp)
    80004d12:	e822                	sd	s0,16(sp)
    80004d14:	e426                	sd	s1,8(sp)
    80004d16:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004d18:	00014497          	auipc	s1,0x14
    80004d1c:	c7848493          	addi	s1,s1,-904 # 80018990 <disk>
    80004d20:	00014517          	auipc	a0,0x14
    80004d24:	d9850513          	addi	a0,a0,-616 # 80018ab8 <disk+0x128>
    80004d28:	2b9000ef          	jal	ra,800057e0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004d2c:	10001737          	lui	a4,0x10001
    80004d30:	533c                	lw	a5,96(a4)
    80004d32:	8b8d                	andi	a5,a5,3
    80004d34:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004d36:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004d3a:	689c                	ld	a5,16(s1)
    80004d3c:	0204d703          	lhu	a4,32(s1)
    80004d40:	0027d783          	lhu	a5,2(a5)
    80004d44:	04f70663          	beq	a4,a5,80004d90 <virtio_disk_intr+0x82>
    __sync_synchronize();
    80004d48:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004d4c:	6898                	ld	a4,16(s1)
    80004d4e:	0204d783          	lhu	a5,32(s1)
    80004d52:	8b9d                	andi	a5,a5,7
    80004d54:	078e                	slli	a5,a5,0x3
    80004d56:	97ba                	add	a5,a5,a4
    80004d58:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004d5a:	00278713          	addi	a4,a5,2
    80004d5e:	0712                	slli	a4,a4,0x4
    80004d60:	9726                	add	a4,a4,s1
    80004d62:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004d66:	e321                	bnez	a4,80004da6 <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004d68:	0789                	addi	a5,a5,2
    80004d6a:	0792                	slli	a5,a5,0x4
    80004d6c:	97a6                	add	a5,a5,s1
    80004d6e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004d70:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004d74:	e02fc0ef          	jal	ra,80001376 <wakeup>

    disk.used_idx += 1;
    80004d78:	0204d783          	lhu	a5,32(s1)
    80004d7c:	2785                	addiw	a5,a5,1
    80004d7e:	17c2                	slli	a5,a5,0x30
    80004d80:	93c1                	srli	a5,a5,0x30
    80004d82:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004d86:	6898                	ld	a4,16(s1)
    80004d88:	00275703          	lhu	a4,2(a4)
    80004d8c:	faf71ee3          	bne	a4,a5,80004d48 <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    80004d90:	00014517          	auipc	a0,0x14
    80004d94:	d2850513          	addi	a0,a0,-728 # 80018ab8 <disk+0x128>
    80004d98:	2e1000ef          	jal	ra,80005878 <release>
}
    80004d9c:	60e2                	ld	ra,24(sp)
    80004d9e:	6442                	ld	s0,16(sp)
    80004da0:	64a2                	ld	s1,8(sp)
    80004da2:	6105                	addi	sp,sp,32
    80004da4:	8082                	ret
      panic("virtio_disk_intr status");
    80004da6:	00003517          	auipc	a0,0x3
    80004daa:	a0a50513          	addi	a0,a0,-1526 # 800077b0 <syscalls+0x420>
    80004dae:	778000ef          	jal	ra,80005526 <panic>

0000000080004db2 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004db2:	1141                	addi	sp,sp,-16
    80004db4:	e422                	sd	s0,8(sp)
    80004db6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004db8:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004dbc:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004dc0:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004dc4:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004dc8:	577d                	li	a4,-1
    80004dca:	177e                	slli	a4,a4,0x3f
    80004dcc:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004dce:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004dd2:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004dd6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004dda:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004dde:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004de2:	000f4737          	lui	a4,0xf4
    80004de6:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004dea:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004dec:	14d79073          	csrw	0x14d,a5
}
    80004df0:	6422                	ld	s0,8(sp)
    80004df2:	0141                	addi	sp,sp,16
    80004df4:	8082                	ret

0000000080004df6 <start>:
{
    80004df6:	1141                	addi	sp,sp,-16
    80004df8:	e406                	sd	ra,8(sp)
    80004dfa:	e022                	sd	s0,0(sp)
    80004dfc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004dfe:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004e02:	7779                	lui	a4,0xffffe
    80004e04:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddc57>
    80004e08:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004e0a:	6705                	lui	a4,0x1
    80004e0c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004e10:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004e12:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004e16:	ffffb797          	auipc	a5,0xffffb
    80004e1a:	4e078793          	addi	a5,a5,1248 # 800002f6 <main>
    80004e1e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004e22:	4781                	li	a5,0
    80004e24:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004e28:	67c1                	lui	a5,0x10
    80004e2a:	17fd                	addi	a5,a5,-1
    80004e2c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004e30:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004e34:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80004e38:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80004e3c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004e40:	57fd                	li	a5,-1
    80004e42:	83a9                	srli	a5,a5,0xa
    80004e44:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004e48:	47bd                	li	a5,15
    80004e4a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004e4e:	f65ff0ef          	jal	ra,80004db2 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004e52:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004e56:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004e58:	823e                	mv	tp,a5
  asm volatile("mret");
    80004e5a:	30200073          	mret
}
    80004e5e:	60a2                	ld	ra,8(sp)
    80004e60:	6402                	ld	s0,0(sp)
    80004e62:	0141                	addi	sp,sp,16
    80004e64:	8082                	ret

0000000080004e66 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004e66:	7159                	addi	sp,sp,-112
    80004e68:	f486                	sd	ra,104(sp)
    80004e6a:	f0a2                	sd	s0,96(sp)
    80004e6c:	eca6                	sd	s1,88(sp)
    80004e6e:	e8ca                	sd	s2,80(sp)
    80004e70:	e4ce                	sd	s3,72(sp)
    80004e72:	e0d2                	sd	s4,64(sp)
    80004e74:	fc56                	sd	s5,56(sp)
    80004e76:	f85a                	sd	s6,48(sp)
    80004e78:	f45e                	sd	s7,40(sp)
    80004e7a:	f062                	sd	s8,32(sp)
    80004e7c:	1880                	addi	s0,sp,112
  char buf[32];
  int i = 0;

  while(i < n){
    80004e7e:	04c05463          	blez	a2,80004ec6 <consolewrite+0x60>
    80004e82:	8a2a                	mv	s4,a0
    80004e84:	8aae                	mv	s5,a1
    80004e86:	89b2                	mv	s3,a2
  int i = 0;
    80004e88:	4901                	li	s2,0
    int nn = sizeof(buf);
    if(nn > n - i)
    80004e8a:	4bfd                	li	s7,31
    int nn = sizeof(buf);
    80004e8c:	02000c13          	li	s8,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80004e90:	5b7d                	li	s6,-1
    80004e92:	a025                	j	80004eba <consolewrite+0x54>
    80004e94:	86a6                	mv	a3,s1
    80004e96:	01590633          	add	a2,s2,s5
    80004e9a:	85d2                	mv	a1,s4
    80004e9c:	f9040513          	addi	a0,s0,-112
    80004ea0:	831fc0ef          	jal	ra,800016d0 <either_copyin>
    80004ea4:	03650263          	beq	a0,s6,80004ec8 <consolewrite+0x62>
      break;
    uartwrite(buf, nn);
    80004ea8:	85a6                	mv	a1,s1
    80004eaa:	f9040513          	addi	a0,s0,-112
    80004eae:	724000ef          	jal	ra,800055d2 <uartwrite>
    i += nn;
    80004eb2:	0124893b          	addw	s2,s1,s2
  while(i < n){
    80004eb6:	01395963          	bge	s2,s3,80004ec8 <consolewrite+0x62>
    if(nn > n - i)
    80004eba:	412984bb          	subw	s1,s3,s2
    80004ebe:	fc9bdbe3          	bge	s7,s1,80004e94 <consolewrite+0x2e>
    int nn = sizeof(buf);
    80004ec2:	84e2                	mv	s1,s8
    80004ec4:	bfc1                	j	80004e94 <consolewrite+0x2e>
  int i = 0;
    80004ec6:	4901                	li	s2,0
  }

  return i;
}
    80004ec8:	854a                	mv	a0,s2
    80004eca:	70a6                	ld	ra,104(sp)
    80004ecc:	7406                	ld	s0,96(sp)
    80004ece:	64e6                	ld	s1,88(sp)
    80004ed0:	6946                	ld	s2,80(sp)
    80004ed2:	69a6                	ld	s3,72(sp)
    80004ed4:	6a06                	ld	s4,64(sp)
    80004ed6:	7ae2                	ld	s5,56(sp)
    80004ed8:	7b42                	ld	s6,48(sp)
    80004eda:	7ba2                	ld	s7,40(sp)
    80004edc:	7c02                	ld	s8,32(sp)
    80004ede:	6165                	addi	sp,sp,112
    80004ee0:	8082                	ret

0000000080004ee2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004ee2:	7119                	addi	sp,sp,-128
    80004ee4:	fc86                	sd	ra,120(sp)
    80004ee6:	f8a2                	sd	s0,112(sp)
    80004ee8:	f4a6                	sd	s1,104(sp)
    80004eea:	f0ca                	sd	s2,96(sp)
    80004eec:	ecce                	sd	s3,88(sp)
    80004eee:	e8d2                	sd	s4,80(sp)
    80004ef0:	e4d6                	sd	s5,72(sp)
    80004ef2:	e0da                	sd	s6,64(sp)
    80004ef4:	fc5e                	sd	s7,56(sp)
    80004ef6:	f862                	sd	s8,48(sp)
    80004ef8:	f466                	sd	s9,40(sp)
    80004efa:	f06a                	sd	s10,32(sp)
    80004efc:	ec6e                	sd	s11,24(sp)
    80004efe:	0100                	addi	s0,sp,128
    80004f00:	8b2a                	mv	s6,a0
    80004f02:	8aae                	mv	s5,a1
    80004f04:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004f06:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80004f0a:	0001c517          	auipc	a0,0x1c
    80004f0e:	bc650513          	addi	a0,a0,-1082 # 80020ad0 <cons>
    80004f12:	0cf000ef          	jal	ra,800057e0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004f16:	0001c497          	auipc	s1,0x1c
    80004f1a:	bba48493          	addi	s1,s1,-1094 # 80020ad0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004f1e:	89a6                	mv	s3,s1
    80004f20:	0001c917          	auipc	s2,0x1c
    80004f24:	c4890913          	addi	s2,s2,-952 # 80020b68 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80004f28:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004f2a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80004f2c:	4da9                	li	s11,10
  while(n > 0){
    80004f2e:	07405363          	blez	s4,80004f94 <consoleread+0xb2>
    while(cons.r == cons.w){
    80004f32:	0984a783          	lw	a5,152(s1)
    80004f36:	09c4a703          	lw	a4,156(s1)
    80004f3a:	02f71163          	bne	a4,a5,80004f5c <consoleread+0x7a>
      if(killed(myproc())){
    80004f3e:	dfbfb0ef          	jal	ra,80000d38 <myproc>
    80004f42:	e20fc0ef          	jal	ra,80001562 <killed>
    80004f46:	e125                	bnez	a0,80004fa6 <consoleread+0xc4>
      sleep(&cons.r, &cons.lock);
    80004f48:	85ce                	mv	a1,s3
    80004f4a:	854a                	mv	a0,s2
    80004f4c:	bdefc0ef          	jal	ra,8000132a <sleep>
    while(cons.r == cons.w){
    80004f50:	0984a783          	lw	a5,152(s1)
    80004f54:	09c4a703          	lw	a4,156(s1)
    80004f58:	fef703e3          	beq	a4,a5,80004f3e <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004f5c:	0017871b          	addiw	a4,a5,1
    80004f60:	08e4ac23          	sw	a4,152(s1)
    80004f64:	07f7f713          	andi	a4,a5,127
    80004f68:	9726                	add	a4,a4,s1
    80004f6a:	01874703          	lbu	a4,24(a4)
    80004f6e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80004f72:	079c0063          	beq	s8,s9,80004fd2 <consoleread+0xf0>
    cbuf = c;
    80004f76:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004f7a:	4685                	li	a3,1
    80004f7c:	f8f40613          	addi	a2,s0,-113
    80004f80:	85d6                	mv	a1,s5
    80004f82:	855a                	mv	a0,s6
    80004f84:	f02fc0ef          	jal	ra,80001686 <either_copyout>
    80004f88:	01a50663          	beq	a0,s10,80004f94 <consoleread+0xb2>
    dst++;
    80004f8c:	0a85                	addi	s5,s5,1
    --n;
    80004f8e:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80004f90:	f9bc1fe3          	bne	s8,s11,80004f2e <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80004f94:	0001c517          	auipc	a0,0x1c
    80004f98:	b3c50513          	addi	a0,a0,-1220 # 80020ad0 <cons>
    80004f9c:	0dd000ef          	jal	ra,80005878 <release>

  return target - n;
    80004fa0:	414b853b          	subw	a0,s7,s4
    80004fa4:	a801                	j	80004fb4 <consoleread+0xd2>
        release(&cons.lock);
    80004fa6:	0001c517          	auipc	a0,0x1c
    80004faa:	b2a50513          	addi	a0,a0,-1238 # 80020ad0 <cons>
    80004fae:	0cb000ef          	jal	ra,80005878 <release>
        return -1;
    80004fb2:	557d                	li	a0,-1
}
    80004fb4:	70e6                	ld	ra,120(sp)
    80004fb6:	7446                	ld	s0,112(sp)
    80004fb8:	74a6                	ld	s1,104(sp)
    80004fba:	7906                	ld	s2,96(sp)
    80004fbc:	69e6                	ld	s3,88(sp)
    80004fbe:	6a46                	ld	s4,80(sp)
    80004fc0:	6aa6                	ld	s5,72(sp)
    80004fc2:	6b06                	ld	s6,64(sp)
    80004fc4:	7be2                	ld	s7,56(sp)
    80004fc6:	7c42                	ld	s8,48(sp)
    80004fc8:	7ca2                	ld	s9,40(sp)
    80004fca:	7d02                	ld	s10,32(sp)
    80004fcc:	6de2                	ld	s11,24(sp)
    80004fce:	6109                	addi	sp,sp,128
    80004fd0:	8082                	ret
      if(n < target){
    80004fd2:	000a071b          	sext.w	a4,s4
    80004fd6:	fb777fe3          	bgeu	a4,s7,80004f94 <consoleread+0xb2>
        cons.r--;
    80004fda:	0001c717          	auipc	a4,0x1c
    80004fde:	b8f72723          	sw	a5,-1138(a4) # 80020b68 <cons+0x98>
    80004fe2:	bf4d                	j	80004f94 <consoleread+0xb2>

0000000080004fe4 <consputc>:
{
    80004fe4:	1141                	addi	sp,sp,-16
    80004fe6:	e406                	sd	ra,8(sp)
    80004fe8:	e022                	sd	s0,0(sp)
    80004fea:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004fec:	10000793          	li	a5,256
    80004ff0:	00f50863          	beq	a0,a5,80005000 <consputc+0x1c>
    uartputc_sync(c);
    80004ff4:	67c000ef          	jal	ra,80005670 <uartputc_sync>
}
    80004ff8:	60a2                	ld	ra,8(sp)
    80004ffa:	6402                	ld	s0,0(sp)
    80004ffc:	0141                	addi	sp,sp,16
    80004ffe:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005000:	4521                	li	a0,8
    80005002:	66e000ef          	jal	ra,80005670 <uartputc_sync>
    80005006:	02000513          	li	a0,32
    8000500a:	666000ef          	jal	ra,80005670 <uartputc_sync>
    8000500e:	4521                	li	a0,8
    80005010:	660000ef          	jal	ra,80005670 <uartputc_sync>
    80005014:	b7d5                	j	80004ff8 <consputc+0x14>

0000000080005016 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005016:	1101                	addi	sp,sp,-32
    80005018:	ec06                	sd	ra,24(sp)
    8000501a:	e822                	sd	s0,16(sp)
    8000501c:	e426                	sd	s1,8(sp)
    8000501e:	e04a                	sd	s2,0(sp)
    80005020:	1000                	addi	s0,sp,32
    80005022:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005024:	0001c517          	auipc	a0,0x1c
    80005028:	aac50513          	addi	a0,a0,-1364 # 80020ad0 <cons>
    8000502c:	7b4000ef          	jal	ra,800057e0 <acquire>

  switch(c){
    80005030:	47d5                	li	a5,21
    80005032:	0af48063          	beq	s1,a5,800050d2 <consoleintr+0xbc>
    80005036:	0297c663          	blt	a5,s1,80005062 <consoleintr+0x4c>
    8000503a:	47a1                	li	a5,8
    8000503c:	0cf48f63          	beq	s1,a5,8000511a <consoleintr+0x104>
    80005040:	47c1                	li	a5,16
    80005042:	10f49063          	bne	s1,a5,80005142 <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    80005046:	ed4fc0ef          	jal	ra,8000171a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000504a:	0001c517          	auipc	a0,0x1c
    8000504e:	a8650513          	addi	a0,a0,-1402 # 80020ad0 <cons>
    80005052:	027000ef          	jal	ra,80005878 <release>
}
    80005056:	60e2                	ld	ra,24(sp)
    80005058:	6442                	ld	s0,16(sp)
    8000505a:	64a2                	ld	s1,8(sp)
    8000505c:	6902                	ld	s2,0(sp)
    8000505e:	6105                	addi	sp,sp,32
    80005060:	8082                	ret
  switch(c){
    80005062:	07f00793          	li	a5,127
    80005066:	0af48a63          	beq	s1,a5,8000511a <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000506a:	0001c717          	auipc	a4,0x1c
    8000506e:	a6670713          	addi	a4,a4,-1434 # 80020ad0 <cons>
    80005072:	0a072783          	lw	a5,160(a4)
    80005076:	09872703          	lw	a4,152(a4)
    8000507a:	9f99                	subw	a5,a5,a4
    8000507c:	07f00713          	li	a4,127
    80005080:	fcf765e3          	bltu	a4,a5,8000504a <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    80005084:	47b5                	li	a5,13
    80005086:	0cf48163          	beq	s1,a5,80005148 <consoleintr+0x132>
      consputc(c);
    8000508a:	8526                	mv	a0,s1
    8000508c:	f59ff0ef          	jal	ra,80004fe4 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005090:	0001c797          	auipc	a5,0x1c
    80005094:	a4078793          	addi	a5,a5,-1472 # 80020ad0 <cons>
    80005098:	0a07a683          	lw	a3,160(a5)
    8000509c:	0016871b          	addiw	a4,a3,1
    800050a0:	0007061b          	sext.w	a2,a4
    800050a4:	0ae7a023          	sw	a4,160(a5)
    800050a8:	07f6f693          	andi	a3,a3,127
    800050ac:	97b6                	add	a5,a5,a3
    800050ae:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800050b2:	47a9                	li	a5,10
    800050b4:	0af48f63          	beq	s1,a5,80005172 <consoleintr+0x15c>
    800050b8:	4791                	li	a5,4
    800050ba:	0af48c63          	beq	s1,a5,80005172 <consoleintr+0x15c>
    800050be:	0001c797          	auipc	a5,0x1c
    800050c2:	aaa7a783          	lw	a5,-1366(a5) # 80020b68 <cons+0x98>
    800050c6:	9f1d                	subw	a4,a4,a5
    800050c8:	08000793          	li	a5,128
    800050cc:	f6f71fe3          	bne	a4,a5,8000504a <consoleintr+0x34>
    800050d0:	a04d                	j	80005172 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    800050d2:	0001c717          	auipc	a4,0x1c
    800050d6:	9fe70713          	addi	a4,a4,-1538 # 80020ad0 <cons>
    800050da:	0a072783          	lw	a5,160(a4)
    800050de:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800050e2:	0001c497          	auipc	s1,0x1c
    800050e6:	9ee48493          	addi	s1,s1,-1554 # 80020ad0 <cons>
    while(cons.e != cons.w &&
    800050ea:	4929                	li	s2,10
    800050ec:	f4f70fe3          	beq	a4,a5,8000504a <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800050f0:	37fd                	addiw	a5,a5,-1
    800050f2:	07f7f713          	andi	a4,a5,127
    800050f6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800050f8:	01874703          	lbu	a4,24(a4)
    800050fc:	f52707e3          	beq	a4,s2,8000504a <consoleintr+0x34>
      cons.e--;
    80005100:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005104:	10000513          	li	a0,256
    80005108:	eddff0ef          	jal	ra,80004fe4 <consputc>
    while(cons.e != cons.w &&
    8000510c:	0a04a783          	lw	a5,160(s1)
    80005110:	09c4a703          	lw	a4,156(s1)
    80005114:	fcf71ee3          	bne	a4,a5,800050f0 <consoleintr+0xda>
    80005118:	bf0d                	j	8000504a <consoleintr+0x34>
    if(cons.e != cons.w){
    8000511a:	0001c717          	auipc	a4,0x1c
    8000511e:	9b670713          	addi	a4,a4,-1610 # 80020ad0 <cons>
    80005122:	0a072783          	lw	a5,160(a4)
    80005126:	09c72703          	lw	a4,156(a4)
    8000512a:	f2f700e3          	beq	a4,a5,8000504a <consoleintr+0x34>
      cons.e--;
    8000512e:	37fd                	addiw	a5,a5,-1
    80005130:	0001c717          	auipc	a4,0x1c
    80005134:	a4f72023          	sw	a5,-1472(a4) # 80020b70 <cons+0xa0>
      consputc(BACKSPACE);
    80005138:	10000513          	li	a0,256
    8000513c:	ea9ff0ef          	jal	ra,80004fe4 <consputc>
    80005140:	b729                	j	8000504a <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005142:	f00484e3          	beqz	s1,8000504a <consoleintr+0x34>
    80005146:	b715                	j	8000506a <consoleintr+0x54>
      consputc(c);
    80005148:	4529                	li	a0,10
    8000514a:	e9bff0ef          	jal	ra,80004fe4 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000514e:	0001c797          	auipc	a5,0x1c
    80005152:	98278793          	addi	a5,a5,-1662 # 80020ad0 <cons>
    80005156:	0a07a703          	lw	a4,160(a5)
    8000515a:	0017069b          	addiw	a3,a4,1
    8000515e:	0006861b          	sext.w	a2,a3
    80005162:	0ad7a023          	sw	a3,160(a5)
    80005166:	07f77713          	andi	a4,a4,127
    8000516a:	97ba                	add	a5,a5,a4
    8000516c:	4729                	li	a4,10
    8000516e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005172:	0001c797          	auipc	a5,0x1c
    80005176:	9ec7ad23          	sw	a2,-1542(a5) # 80020b6c <cons+0x9c>
        wakeup(&cons.r);
    8000517a:	0001c517          	auipc	a0,0x1c
    8000517e:	9ee50513          	addi	a0,a0,-1554 # 80020b68 <cons+0x98>
    80005182:	9f4fc0ef          	jal	ra,80001376 <wakeup>
    80005186:	b5d1                	j	8000504a <consoleintr+0x34>

0000000080005188 <consoleinit>:

void
consoleinit(void)
{
    80005188:	1141                	addi	sp,sp,-16
    8000518a:	e406                	sd	ra,8(sp)
    8000518c:	e022                	sd	s0,0(sp)
    8000518e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005190:	00002597          	auipc	a1,0x2
    80005194:	63858593          	addi	a1,a1,1592 # 800077c8 <syscalls+0x438>
    80005198:	0001c517          	auipc	a0,0x1c
    8000519c:	93850513          	addi	a0,a0,-1736 # 80020ad0 <cons>
    800051a0:	5c0000ef          	jal	ra,80005760 <initlock>

  uartinit();
    800051a4:	3e2000ef          	jal	ra,80005586 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800051a8:	00012797          	auipc	a5,0x12
    800051ac:	79078793          	addi	a5,a5,1936 # 80017938 <devsw>
    800051b0:	00000717          	auipc	a4,0x0
    800051b4:	d3270713          	addi	a4,a4,-718 # 80004ee2 <consoleread>
    800051b8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800051ba:	00000717          	auipc	a4,0x0
    800051be:	cac70713          	addi	a4,a4,-852 # 80004e66 <consolewrite>
    800051c2:	ef98                	sd	a4,24(a5)
}
    800051c4:	60a2                	ld	ra,8(sp)
    800051c6:	6402                	ld	s0,0(sp)
    800051c8:	0141                	addi	sp,sp,16
    800051ca:	8082                	ret

00000000800051cc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800051cc:	7139                	addi	sp,sp,-64
    800051ce:	fc06                	sd	ra,56(sp)
    800051d0:	f822                	sd	s0,48(sp)
    800051d2:	f426                	sd	s1,40(sp)
    800051d4:	f04a                	sd	s2,32(sp)
    800051d6:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800051d8:	c219                	beqz	a2,800051de <printint+0x12>
    800051da:	06054f63          	bltz	a0,80005258 <printint+0x8c>
    x = -xx;
  else
    x = xx;
    800051de:	4881                	li	a7,0
    800051e0:	fc840693          	addi	a3,s0,-56

  i = 0;
    800051e4:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800051e6:	00002617          	auipc	a2,0x2
    800051ea:	60a60613          	addi	a2,a2,1546 # 800077f0 <digits>
    800051ee:	883e                	mv	a6,a5
    800051f0:	2785                	addiw	a5,a5,1
    800051f2:	02b57733          	remu	a4,a0,a1
    800051f6:	9732                	add	a4,a4,a2
    800051f8:	00074703          	lbu	a4,0(a4)
    800051fc:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005200:	872a                	mv	a4,a0
    80005202:	02b55533          	divu	a0,a0,a1
    80005206:	0685                	addi	a3,a3,1
    80005208:	feb773e3          	bgeu	a4,a1,800051ee <printint+0x22>

  if(sign)
    8000520c:	00088b63          	beqz	a7,80005222 <printint+0x56>
    buf[i++] = '-';
    80005210:	fe040713          	addi	a4,s0,-32
    80005214:	97ba                	add	a5,a5,a4
    80005216:	02d00713          	li	a4,45
    8000521a:	fee78423          	sb	a4,-24(a5)
    8000521e:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80005222:	02f05563          	blez	a5,8000524c <printint+0x80>
    80005226:	fc840713          	addi	a4,s0,-56
    8000522a:	00f704b3          	add	s1,a4,a5
    8000522e:	fff70913          	addi	s2,a4,-1
    80005232:	993e                	add	s2,s2,a5
    80005234:	37fd                	addiw	a5,a5,-1
    80005236:	1782                	slli	a5,a5,0x20
    80005238:	9381                	srli	a5,a5,0x20
    8000523a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000523e:	fff4c503          	lbu	a0,-1(s1)
    80005242:	da3ff0ef          	jal	ra,80004fe4 <consputc>
  while(--i >= 0)
    80005246:	14fd                	addi	s1,s1,-1
    80005248:	ff249be3          	bne	s1,s2,8000523e <printint+0x72>
}
    8000524c:	70e2                	ld	ra,56(sp)
    8000524e:	7442                	ld	s0,48(sp)
    80005250:	74a2                	ld	s1,40(sp)
    80005252:	7902                	ld	s2,32(sp)
    80005254:	6121                	addi	sp,sp,64
    80005256:	8082                	ret
    x = -xx;
    80005258:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000525c:	4885                	li	a7,1
    x = -xx;
    8000525e:	b749                	j	800051e0 <printint+0x14>

0000000080005260 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005260:	7131                	addi	sp,sp,-192
    80005262:	fc86                	sd	ra,120(sp)
    80005264:	f8a2                	sd	s0,112(sp)
    80005266:	f4a6                	sd	s1,104(sp)
    80005268:	f0ca                	sd	s2,96(sp)
    8000526a:	ecce                	sd	s3,88(sp)
    8000526c:	e8d2                	sd	s4,80(sp)
    8000526e:	e4d6                	sd	s5,72(sp)
    80005270:	e0da                	sd	s6,64(sp)
    80005272:	fc5e                	sd	s7,56(sp)
    80005274:	f862                	sd	s8,48(sp)
    80005276:	f466                	sd	s9,40(sp)
    80005278:	f06a                	sd	s10,32(sp)
    8000527a:	ec6e                	sd	s11,24(sp)
    8000527c:	0100                	addi	s0,sp,128
    8000527e:	8a2a                	mv	s4,a0
    80005280:	e40c                	sd	a1,8(s0)
    80005282:	e810                	sd	a2,16(s0)
    80005284:	ec14                	sd	a3,24(s0)
    80005286:	f018                	sd	a4,32(s0)
    80005288:	f41c                	sd	a5,40(s0)
    8000528a:	03043823          	sd	a6,48(s0)
    8000528e:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80005292:	00002797          	auipc	a5,0x2
    80005296:	5fe7a783          	lw	a5,1534(a5) # 80007890 <panicking>
    8000529a:	cb9d                	beqz	a5,800052d0 <printf+0x70>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000529c:	00840793          	addi	a5,s0,8
    800052a0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052a4:	000a4503          	lbu	a0,0(s4)
    800052a8:	24050363          	beqz	a0,800054ee <printf+0x28e>
    800052ac:	4981                	li	s3,0
    if(cx != '%'){
    800052ae:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800052b2:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800052b6:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800052ba:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800052be:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800052c2:	07000d93          	li	s11,112
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800052c6:	00002b97          	auipc	s7,0x2
    800052ca:	52ab8b93          	addi	s7,s7,1322 # 800077f0 <digits>
    800052ce:	a01d                	j	800052f4 <printf+0x94>
    acquire(&pr.lock);
    800052d0:	0001c517          	auipc	a0,0x1c
    800052d4:	8a850513          	addi	a0,a0,-1880 # 80020b78 <pr>
    800052d8:	508000ef          	jal	ra,800057e0 <acquire>
    800052dc:	b7c1                	j	8000529c <printf+0x3c>
      consputc(cx);
    800052de:	d07ff0ef          	jal	ra,80004fe4 <consputc>
      continue;
    800052e2:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052e4:	0014899b          	addiw	s3,s1,1
    800052e8:	013a07b3          	add	a5,s4,s3
    800052ec:	0007c503          	lbu	a0,0(a5)
    800052f0:	1e050f63          	beqz	a0,800054ee <printf+0x28e>
    if(cx != '%'){
    800052f4:	ff5515e3          	bne	a0,s5,800052de <printf+0x7e>
    i++;
    800052f8:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800052fc:	009a07b3          	add	a5,s4,s1
    80005300:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005304:	1e090563          	beqz	s2,800054ee <printf+0x28e>
    80005308:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    8000530c:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    8000530e:	c789                	beqz	a5,80005318 <printf+0xb8>
    80005310:	009a0733          	add	a4,s4,s1
    80005314:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005318:	03690863          	beq	s2,s6,80005348 <printf+0xe8>
    } else if(c0 == 'l' && c1 == 'd'){
    8000531c:	05890263          	beq	s2,s8,80005360 <printf+0x100>
    } else if(c0 == 'u'){
    80005320:	0d990163          	beq	s2,s9,800053e2 <printf+0x182>
    } else if(c0 == 'x'){
    80005324:	11a90863          	beq	s2,s10,80005434 <printf+0x1d4>
    } else if(c0 == 'p'){
    80005328:	15b90163          	beq	s2,s11,8000546a <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    8000532c:	06300793          	li	a5,99
    80005330:	16f90963          	beq	s2,a5,800054a2 <printf+0x242>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    80005334:	07300793          	li	a5,115
    80005338:	16f90f63          	beq	s2,a5,800054b6 <printf+0x256>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000533c:	03591c63          	bne	s2,s5,80005374 <printf+0x114>
      consputc('%');
    80005340:	8556                	mv	a0,s5
    80005342:	ca3ff0ef          	jal	ra,80004fe4 <consputc>
    80005346:	bf79                	j	800052e4 <printf+0x84>
      printint(va_arg(ap, int), 10, 1);
    80005348:	f8843783          	ld	a5,-120(s0)
    8000534c:	00878713          	addi	a4,a5,8
    80005350:	f8e43423          	sd	a4,-120(s0)
    80005354:	4605                	li	a2,1
    80005356:	45a9                	li	a1,10
    80005358:	4388                	lw	a0,0(a5)
    8000535a:	e73ff0ef          	jal	ra,800051cc <printint>
    8000535e:	b759                	j	800052e4 <printf+0x84>
    } else if(c0 == 'l' && c1 == 'd'){
    80005360:	03678163          	beq	a5,s6,80005382 <printf+0x122>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005364:	03878d63          	beq	a5,s8,8000539e <printf+0x13e>
    } else if(c0 == 'l' && c1 == 'u'){
    80005368:	09978a63          	beq	a5,s9,800053fc <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000536c:	03878b63          	beq	a5,s8,800053a2 <printf+0x142>
    } else if(c0 == 'l' && c1 == 'x'){
    80005370:	0da78f63          	beq	a5,s10,8000544e <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005374:	8556                	mv	a0,s5
    80005376:	c6fff0ef          	jal	ra,80004fe4 <consputc>
      consputc(c0);
    8000537a:	854a                	mv	a0,s2
    8000537c:	c69ff0ef          	jal	ra,80004fe4 <consputc>
    80005380:	b795                	j	800052e4 <printf+0x84>
      printint(va_arg(ap, uint64), 10, 1);
    80005382:	f8843783          	ld	a5,-120(s0)
    80005386:	00878713          	addi	a4,a5,8
    8000538a:	f8e43423          	sd	a4,-120(s0)
    8000538e:	4605                	li	a2,1
    80005390:	45a9                	li	a1,10
    80005392:	6388                	ld	a0,0(a5)
    80005394:	e39ff0ef          	jal	ra,800051cc <printint>
      i += 1;
    80005398:	0029849b          	addiw	s1,s3,2
    8000539c:	b7a1                	j	800052e4 <printf+0x84>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000539e:	03668463          	beq	a3,s6,800053c6 <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800053a2:	07968b63          	beq	a3,s9,80005418 <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800053a6:	fda697e3          	bne	a3,s10,80005374 <printf+0x114>
      printint(va_arg(ap, uint64), 16, 0);
    800053aa:	f8843783          	ld	a5,-120(s0)
    800053ae:	00878713          	addi	a4,a5,8
    800053b2:	f8e43423          	sd	a4,-120(s0)
    800053b6:	4601                	li	a2,0
    800053b8:	45c1                	li	a1,16
    800053ba:	6388                	ld	a0,0(a5)
    800053bc:	e11ff0ef          	jal	ra,800051cc <printint>
      i += 2;
    800053c0:	0039849b          	addiw	s1,s3,3
    800053c4:	b705                	j	800052e4 <printf+0x84>
      printint(va_arg(ap, uint64), 10, 1);
    800053c6:	f8843783          	ld	a5,-120(s0)
    800053ca:	00878713          	addi	a4,a5,8
    800053ce:	f8e43423          	sd	a4,-120(s0)
    800053d2:	4605                	li	a2,1
    800053d4:	45a9                	li	a1,10
    800053d6:	6388                	ld	a0,0(a5)
    800053d8:	df5ff0ef          	jal	ra,800051cc <printint>
      i += 2;
    800053dc:	0039849b          	addiw	s1,s3,3
    800053e0:	b711                	j	800052e4 <printf+0x84>
      printint(va_arg(ap, uint32), 10, 0);
    800053e2:	f8843783          	ld	a5,-120(s0)
    800053e6:	00878713          	addi	a4,a5,8
    800053ea:	f8e43423          	sd	a4,-120(s0)
    800053ee:	4601                	li	a2,0
    800053f0:	45a9                	li	a1,10
    800053f2:	0007e503          	lwu	a0,0(a5)
    800053f6:	dd7ff0ef          	jal	ra,800051cc <printint>
    800053fa:	b5ed                	j	800052e4 <printf+0x84>
      printint(va_arg(ap, uint64), 10, 0);
    800053fc:	f8843783          	ld	a5,-120(s0)
    80005400:	00878713          	addi	a4,a5,8
    80005404:	f8e43423          	sd	a4,-120(s0)
    80005408:	4601                	li	a2,0
    8000540a:	45a9                	li	a1,10
    8000540c:	6388                	ld	a0,0(a5)
    8000540e:	dbfff0ef          	jal	ra,800051cc <printint>
      i += 1;
    80005412:	0029849b          	addiw	s1,s3,2
    80005416:	b5f9                	j	800052e4 <printf+0x84>
      printint(va_arg(ap, uint64), 10, 0);
    80005418:	f8843783          	ld	a5,-120(s0)
    8000541c:	00878713          	addi	a4,a5,8
    80005420:	f8e43423          	sd	a4,-120(s0)
    80005424:	4601                	li	a2,0
    80005426:	45a9                	li	a1,10
    80005428:	6388                	ld	a0,0(a5)
    8000542a:	da3ff0ef          	jal	ra,800051cc <printint>
      i += 2;
    8000542e:	0039849b          	addiw	s1,s3,3
    80005432:	bd4d                	j	800052e4 <printf+0x84>
      printint(va_arg(ap, uint32), 16, 0);
    80005434:	f8843783          	ld	a5,-120(s0)
    80005438:	00878713          	addi	a4,a5,8
    8000543c:	f8e43423          	sd	a4,-120(s0)
    80005440:	4601                	li	a2,0
    80005442:	45c1                	li	a1,16
    80005444:	0007e503          	lwu	a0,0(a5)
    80005448:	d85ff0ef          	jal	ra,800051cc <printint>
    8000544c:	bd61                	j	800052e4 <printf+0x84>
      printint(va_arg(ap, uint64), 16, 0);
    8000544e:	f8843783          	ld	a5,-120(s0)
    80005452:	00878713          	addi	a4,a5,8
    80005456:	f8e43423          	sd	a4,-120(s0)
    8000545a:	4601                	li	a2,0
    8000545c:	45c1                	li	a1,16
    8000545e:	6388                	ld	a0,0(a5)
    80005460:	d6dff0ef          	jal	ra,800051cc <printint>
      i += 1;
    80005464:	0029849b          	addiw	s1,s3,2
    80005468:	bdb5                	j	800052e4 <printf+0x84>
      printptr(va_arg(ap, uint64));
    8000546a:	f8843783          	ld	a5,-120(s0)
    8000546e:	00878713          	addi	a4,a5,8
    80005472:	f8e43423          	sd	a4,-120(s0)
    80005476:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000547a:	03000513          	li	a0,48
    8000547e:	b67ff0ef          	jal	ra,80004fe4 <consputc>
  consputc('x');
    80005482:	856a                	mv	a0,s10
    80005484:	b61ff0ef          	jal	ra,80004fe4 <consputc>
    80005488:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000548a:	03c9d793          	srli	a5,s3,0x3c
    8000548e:	97de                	add	a5,a5,s7
    80005490:	0007c503          	lbu	a0,0(a5)
    80005494:	b51ff0ef          	jal	ra,80004fe4 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005498:	0992                	slli	s3,s3,0x4
    8000549a:	397d                	addiw	s2,s2,-1
    8000549c:	fe0917e3          	bnez	s2,8000548a <printf+0x22a>
    800054a0:	b591                	j	800052e4 <printf+0x84>
      consputc(va_arg(ap, uint));
    800054a2:	f8843783          	ld	a5,-120(s0)
    800054a6:	00878713          	addi	a4,a5,8
    800054aa:	f8e43423          	sd	a4,-120(s0)
    800054ae:	4388                	lw	a0,0(a5)
    800054b0:	b35ff0ef          	jal	ra,80004fe4 <consputc>
    800054b4:	bd05                	j	800052e4 <printf+0x84>
      if((s = va_arg(ap, char*)) == 0)
    800054b6:	f8843783          	ld	a5,-120(s0)
    800054ba:	00878713          	addi	a4,a5,8
    800054be:	f8e43423          	sd	a4,-120(s0)
    800054c2:	0007b903          	ld	s2,0(a5)
    800054c6:	00090d63          	beqz	s2,800054e0 <printf+0x280>
      for(; *s; s++)
    800054ca:	00094503          	lbu	a0,0(s2)
    800054ce:	e0050be3          	beqz	a0,800052e4 <printf+0x84>
        consputc(*s);
    800054d2:	b13ff0ef          	jal	ra,80004fe4 <consputc>
      for(; *s; s++)
    800054d6:	0905                	addi	s2,s2,1
    800054d8:	00094503          	lbu	a0,0(s2)
    800054dc:	f97d                	bnez	a0,800054d2 <printf+0x272>
    800054de:	b519                	j	800052e4 <printf+0x84>
        s = "(null)";
    800054e0:	00002917          	auipc	s2,0x2
    800054e4:	2f090913          	addi	s2,s2,752 # 800077d0 <syscalls+0x440>
      for(; *s; s++)
    800054e8:	02800513          	li	a0,40
    800054ec:	b7dd                	j	800054d2 <printf+0x272>
    }

  }
  va_end(ap);

  if(panicking == 0)
    800054ee:	00002797          	auipc	a5,0x2
    800054f2:	3a27a783          	lw	a5,930(a5) # 80007890 <panicking>
    800054f6:	c38d                	beqz	a5,80005518 <printf+0x2b8>
    release(&pr.lock);

  return 0;
}
    800054f8:	4501                	li	a0,0
    800054fa:	70e6                	ld	ra,120(sp)
    800054fc:	7446                	ld	s0,112(sp)
    800054fe:	74a6                	ld	s1,104(sp)
    80005500:	7906                	ld	s2,96(sp)
    80005502:	69e6                	ld	s3,88(sp)
    80005504:	6a46                	ld	s4,80(sp)
    80005506:	6aa6                	ld	s5,72(sp)
    80005508:	6b06                	ld	s6,64(sp)
    8000550a:	7be2                	ld	s7,56(sp)
    8000550c:	7c42                	ld	s8,48(sp)
    8000550e:	7ca2                	ld	s9,40(sp)
    80005510:	7d02                	ld	s10,32(sp)
    80005512:	6de2                	ld	s11,24(sp)
    80005514:	6129                	addi	sp,sp,192
    80005516:	8082                	ret
    release(&pr.lock);
    80005518:	0001b517          	auipc	a0,0x1b
    8000551c:	66050513          	addi	a0,a0,1632 # 80020b78 <pr>
    80005520:	358000ef          	jal	ra,80005878 <release>
  return 0;
    80005524:	bfd1                	j	800054f8 <printf+0x298>

0000000080005526 <panic>:

void
panic(char *s)
{
    80005526:	1101                	addi	sp,sp,-32
    80005528:	ec06                	sd	ra,24(sp)
    8000552a:	e822                	sd	s0,16(sp)
    8000552c:	e426                	sd	s1,8(sp)
    8000552e:	e04a                	sd	s2,0(sp)
    80005530:	1000                	addi	s0,sp,32
    80005532:	892a                	mv	s2,a0
  panicking = 1;
    80005534:	4485                	li	s1,1
    80005536:	00002797          	auipc	a5,0x2
    8000553a:	3497ad23          	sw	s1,858(a5) # 80007890 <panicking>
  printf("panic: ");
    8000553e:	00002517          	auipc	a0,0x2
    80005542:	29a50513          	addi	a0,a0,666 # 800077d8 <syscalls+0x448>
    80005546:	d1bff0ef          	jal	ra,80005260 <printf>
  printf("%s\n", s);
    8000554a:	85ca                	mv	a1,s2
    8000554c:	00002517          	auipc	a0,0x2
    80005550:	29450513          	addi	a0,a0,660 # 800077e0 <syscalls+0x450>
    80005554:	d0dff0ef          	jal	ra,80005260 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005558:	00002797          	auipc	a5,0x2
    8000555c:	3297aa23          	sw	s1,820(a5) # 8000788c <panicked>
  for(;;)
    80005560:	a001                	j	80005560 <panic+0x3a>

0000000080005562 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005562:	1141                	addi	sp,sp,-16
    80005564:	e406                	sd	ra,8(sp)
    80005566:	e022                	sd	s0,0(sp)
    80005568:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    8000556a:	00002597          	auipc	a1,0x2
    8000556e:	27e58593          	addi	a1,a1,638 # 800077e8 <syscalls+0x458>
    80005572:	0001b517          	auipc	a0,0x1b
    80005576:	60650513          	addi	a0,a0,1542 # 80020b78 <pr>
    8000557a:	1e6000ef          	jal	ra,80005760 <initlock>
}
    8000557e:	60a2                	ld	ra,8(sp)
    80005580:	6402                	ld	s0,0(sp)
    80005582:	0141                	addi	sp,sp,16
    80005584:	8082                	ret

0000000080005586 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80005586:	1141                	addi	sp,sp,-16
    80005588:	e406                	sd	ra,8(sp)
    8000558a:	e022                	sd	s0,0(sp)
    8000558c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000558e:	100007b7          	lui	a5,0x10000
    80005592:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005596:	f8000713          	li	a4,-128
    8000559a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000559e:	470d                	li	a4,3
    800055a0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800055a4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800055a8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800055ac:	469d                	li	a3,7
    800055ae:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800055b2:	00e780a3          	sb	a4,1(a5)

  initlock(&tx_lock, "uart");
    800055b6:	00002597          	auipc	a1,0x2
    800055ba:	25258593          	addi	a1,a1,594 # 80007808 <digits+0x18>
    800055be:	0001b517          	auipc	a0,0x1b
    800055c2:	5d250513          	addi	a0,a0,1490 # 80020b90 <tx_lock>
    800055c6:	19a000ef          	jal	ra,80005760 <initlock>
}
    800055ca:	60a2                	ld	ra,8(sp)
    800055cc:	6402                	ld	s0,0(sp)
    800055ce:	0141                	addi	sp,sp,16
    800055d0:	8082                	ret

00000000800055d2 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800055d2:	715d                	addi	sp,sp,-80
    800055d4:	e486                	sd	ra,72(sp)
    800055d6:	e0a2                	sd	s0,64(sp)
    800055d8:	fc26                	sd	s1,56(sp)
    800055da:	f84a                	sd	s2,48(sp)
    800055dc:	f44e                	sd	s3,40(sp)
    800055de:	f052                	sd	s4,32(sp)
    800055e0:	ec56                	sd	s5,24(sp)
    800055e2:	e85a                	sd	s6,16(sp)
    800055e4:	e45e                	sd	s7,8(sp)
    800055e6:	0880                	addi	s0,sp,80
    800055e8:	84aa                	mv	s1,a0
    800055ea:	8aae                	mv	s5,a1
  acquire(&tx_lock);
    800055ec:	0001b517          	auipc	a0,0x1b
    800055f0:	5a450513          	addi	a0,a0,1444 # 80020b90 <tx_lock>
    800055f4:	1ec000ef          	jal	ra,800057e0 <acquire>

  int i = 0;
  while(i < n){ 
    800055f8:	05505b63          	blez	s5,8000564e <uartwrite+0x7c>
    800055fc:	8a26                	mv	s4,s1
    800055fe:	0485                	addi	s1,s1,1
    80005600:	3afd                	addiw	s5,s5,-1
    80005602:	1a82                	slli	s5,s5,0x20
    80005604:	020ada93          	srli	s5,s5,0x20
    80005608:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    8000560a:	00002497          	auipc	s1,0x2
    8000560e:	28e48493          	addi	s1,s1,654 # 80007898 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005612:	0001b997          	auipc	s3,0x1b
    80005616:	57e98993          	addi	s3,s3,1406 # 80020b90 <tx_lock>
    8000561a:	00002917          	auipc	s2,0x2
    8000561e:	27a90913          	addi	s2,s2,634 # 80007894 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005622:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005626:	4b05                	li	s6,1
    80005628:	a005                	j	80005648 <uartwrite+0x76>
      sleep(&tx_chan, &tx_lock);
    8000562a:	85ce                	mv	a1,s3
    8000562c:	854a                	mv	a0,s2
    8000562e:	cfdfb0ef          	jal	ra,8000132a <sleep>
    while(tx_busy != 0){
    80005632:	409c                	lw	a5,0(s1)
    80005634:	fbfd                	bnez	a5,8000562a <uartwrite+0x58>
    WriteReg(THR, buf[i]);
    80005636:	000a4783          	lbu	a5,0(s4)
    8000563a:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    8000563e:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005642:	0a05                	addi	s4,s4,1
    80005644:	015a0563          	beq	s4,s5,8000564e <uartwrite+0x7c>
    while(tx_busy != 0){
    80005648:	409c                	lw	a5,0(s1)
    8000564a:	f3e5                	bnez	a5,8000562a <uartwrite+0x58>
    8000564c:	b7ed                	j	80005636 <uartwrite+0x64>
  }

  release(&tx_lock);
    8000564e:	0001b517          	auipc	a0,0x1b
    80005652:	54250513          	addi	a0,a0,1346 # 80020b90 <tx_lock>
    80005656:	222000ef          	jal	ra,80005878 <release>
}
    8000565a:	60a6                	ld	ra,72(sp)
    8000565c:	6406                	ld	s0,64(sp)
    8000565e:	74e2                	ld	s1,56(sp)
    80005660:	7942                	ld	s2,48(sp)
    80005662:	79a2                	ld	s3,40(sp)
    80005664:	7a02                	ld	s4,32(sp)
    80005666:	6ae2                	ld	s5,24(sp)
    80005668:	6b42                	ld	s6,16(sp)
    8000566a:	6ba2                	ld	s7,8(sp)
    8000566c:	6161                	addi	sp,sp,80
    8000566e:	8082                	ret

0000000080005670 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005670:	1101                	addi	sp,sp,-32
    80005672:	ec06                	sd	ra,24(sp)
    80005674:	e822                	sd	s0,16(sp)
    80005676:	e426                	sd	s1,8(sp)
    80005678:	1000                	addi	s0,sp,32
    8000567a:	84aa                	mv	s1,a0
  if(panicking == 0)
    8000567c:	00002797          	auipc	a5,0x2
    80005680:	2147a783          	lw	a5,532(a5) # 80007890 <panicking>
    80005684:	cb89                	beqz	a5,80005696 <uartputc_sync+0x26>
    push_off();

  if(panicked){
    80005686:	00002797          	auipc	a5,0x2
    8000568a:	2067a783          	lw	a5,518(a5) # 8000788c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000568e:	10000737          	lui	a4,0x10000
  if(panicked){
    80005692:	c789                	beqz	a5,8000569c <uartputc_sync+0x2c>
    for(;;)
    80005694:	a001                	j	80005694 <uartputc_sync+0x24>
    push_off();
    80005696:	10a000ef          	jal	ra,800057a0 <push_off>
    8000569a:	b7f5                	j	80005686 <uartputc_sync+0x16>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000569c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800056a0:	0ff7f793          	andi	a5,a5,255
    800056a4:	0207f793          	andi	a5,a5,32
    800056a8:	dbf5                	beqz	a5,8000569c <uartputc_sync+0x2c>
    ;
  WriteReg(THR, c);
    800056aa:	0ff4f793          	andi	a5,s1,255
    800056ae:	10000737          	lui	a4,0x10000
    800056b2:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    800056b6:	00002797          	auipc	a5,0x2
    800056ba:	1da7a783          	lw	a5,474(a5) # 80007890 <panicking>
    800056be:	c791                	beqz	a5,800056ca <uartputc_sync+0x5a>
    pop_off();
}
    800056c0:	60e2                	ld	ra,24(sp)
    800056c2:	6442                	ld	s0,16(sp)
    800056c4:	64a2                	ld	s1,8(sp)
    800056c6:	6105                	addi	sp,sp,32
    800056c8:	8082                	ret
    pop_off();
    800056ca:	15a000ef          	jal	ra,80005824 <pop_off>
}
    800056ce:	bfcd                	j	800056c0 <uartputc_sync+0x50>

00000000800056d0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800056d0:	1141                	addi	sp,sp,-16
    800056d2:	e422                	sd	s0,8(sp)
    800056d4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800056d6:	100007b7          	lui	a5,0x10000
    800056da:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800056de:	8b85                	andi	a5,a5,1
    800056e0:	cb91                	beqz	a5,800056f4 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800056e2:	100007b7          	lui	a5,0x10000
    800056e6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800056ea:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800056ee:	6422                	ld	s0,8(sp)
    800056f0:	0141                	addi	sp,sp,16
    800056f2:	8082                	ret
    return -1;
    800056f4:	557d                	li	a0,-1
    800056f6:	bfe5                	j	800056ee <uartgetc+0x1e>

00000000800056f8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800056f8:	1101                	addi	sp,sp,-32
    800056fa:	ec06                	sd	ra,24(sp)
    800056fc:	e822                	sd	s0,16(sp)
    800056fe:	e426                	sd	s1,8(sp)
    80005700:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005702:	100004b7          	lui	s1,0x10000
    80005706:	0024c783          	lbu	a5,2(s1) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    8000570a:	0001b517          	auipc	a0,0x1b
    8000570e:	48650513          	addi	a0,a0,1158 # 80020b90 <tx_lock>
    80005712:	0ce000ef          	jal	ra,800057e0 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005716:	0054c783          	lbu	a5,5(s1)
    8000571a:	0ff7f793          	andi	a5,a5,255
    8000571e:	0207f793          	andi	a5,a5,32
    80005722:	ef99                	bnez	a5,80005740 <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005724:	0001b517          	auipc	a0,0x1b
    80005728:	46c50513          	addi	a0,a0,1132 # 80020b90 <tx_lock>
    8000572c:	14c000ef          	jal	ra,80005878 <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005730:	54fd                	li	s1,-1
    int c = uartgetc();
    80005732:	f9fff0ef          	jal	ra,800056d0 <uartgetc>
    if(c == -1)
    80005736:	02950063          	beq	a0,s1,80005756 <uartintr+0x5e>
      break;
    consoleintr(c);
    8000573a:	8ddff0ef          	jal	ra,80005016 <consoleintr>
  while(1){
    8000573e:	bfd5                	j	80005732 <uartintr+0x3a>
    tx_busy = 0;
    80005740:	00002797          	auipc	a5,0x2
    80005744:	1407ac23          	sw	zero,344(a5) # 80007898 <tx_busy>
    wakeup(&tx_chan);
    80005748:	00002517          	auipc	a0,0x2
    8000574c:	14c50513          	addi	a0,a0,332 # 80007894 <tx_chan>
    80005750:	c27fb0ef          	jal	ra,80001376 <wakeup>
    80005754:	bfc1                	j	80005724 <uartintr+0x2c>
  }
}
    80005756:	60e2                	ld	ra,24(sp)
    80005758:	6442                	ld	s0,16(sp)
    8000575a:	64a2                	ld	s1,8(sp)
    8000575c:	6105                	addi	sp,sp,32
    8000575e:	8082                	ret

0000000080005760 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005760:	1141                	addi	sp,sp,-16
    80005762:	e422                	sd	s0,8(sp)
    80005764:	0800                	addi	s0,sp,16
  lk->name = name;
    80005766:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005768:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000576c:	00053823          	sd	zero,16(a0)
}
    80005770:	6422                	ld	s0,8(sp)
    80005772:	0141                	addi	sp,sp,16
    80005774:	8082                	ret

0000000080005776 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005776:	411c                	lw	a5,0(a0)
    80005778:	e399                	bnez	a5,8000577e <holding+0x8>
    8000577a:	4501                	li	a0,0
  return r;
}
    8000577c:	8082                	ret
{
    8000577e:	1101                	addi	sp,sp,-32
    80005780:	ec06                	sd	ra,24(sp)
    80005782:	e822                	sd	s0,16(sp)
    80005784:	e426                	sd	s1,8(sp)
    80005786:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005788:	6904                	ld	s1,16(a0)
    8000578a:	d92fb0ef          	jal	ra,80000d1c <mycpu>
    8000578e:	40a48533          	sub	a0,s1,a0
    80005792:	00153513          	seqz	a0,a0
}
    80005796:	60e2                	ld	ra,24(sp)
    80005798:	6442                	ld	s0,16(sp)
    8000579a:	64a2                	ld	s1,8(sp)
    8000579c:	6105                	addi	sp,sp,32
    8000579e:	8082                	ret

00000000800057a0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800057a0:	1101                	addi	sp,sp,-32
    800057a2:	ec06                	sd	ra,24(sp)
    800057a4:	e822                	sd	s0,16(sp)
    800057a6:	e426                	sd	s1,8(sp)
    800057a8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800057aa:	100024f3          	csrr	s1,sstatus
    800057ae:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800057b2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800057b4:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    800057b8:	d64fb0ef          	jal	ra,80000d1c <mycpu>
    800057bc:	5d3c                	lw	a5,120(a0)
    800057be:	cb99                	beqz	a5,800057d4 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800057c0:	d5cfb0ef          	jal	ra,80000d1c <mycpu>
    800057c4:	5d3c                	lw	a5,120(a0)
    800057c6:	2785                	addiw	a5,a5,1
    800057c8:	dd3c                	sw	a5,120(a0)
}
    800057ca:	60e2                	ld	ra,24(sp)
    800057cc:	6442                	ld	s0,16(sp)
    800057ce:	64a2                	ld	s1,8(sp)
    800057d0:	6105                	addi	sp,sp,32
    800057d2:	8082                	ret
    mycpu()->intena = old;
    800057d4:	d48fb0ef          	jal	ra,80000d1c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800057d8:	8085                	srli	s1,s1,0x1
    800057da:	8885                	andi	s1,s1,1
    800057dc:	dd64                	sw	s1,124(a0)
    800057de:	b7cd                	j	800057c0 <push_off+0x20>

00000000800057e0 <acquire>:
{
    800057e0:	1101                	addi	sp,sp,-32
    800057e2:	ec06                	sd	ra,24(sp)
    800057e4:	e822                	sd	s0,16(sp)
    800057e6:	e426                	sd	s1,8(sp)
    800057e8:	1000                	addi	s0,sp,32
    800057ea:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800057ec:	fb5ff0ef          	jal	ra,800057a0 <push_off>
  if(holding(lk))
    800057f0:	8526                	mv	a0,s1
    800057f2:	f85ff0ef          	jal	ra,80005776 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800057f6:	4705                	li	a4,1
  if(holding(lk))
    800057f8:	e105                	bnez	a0,80005818 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800057fa:	87ba                	mv	a5,a4
    800057fc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005800:	2781                	sext.w	a5,a5
    80005802:	ffe5                	bnez	a5,800057fa <acquire+0x1a>
  __sync_synchronize();
    80005804:	0ff0000f          	fence
  lk->cpu = mycpu();
    80005808:	d14fb0ef          	jal	ra,80000d1c <mycpu>
    8000580c:	e888                	sd	a0,16(s1)
}
    8000580e:	60e2                	ld	ra,24(sp)
    80005810:	6442                	ld	s0,16(sp)
    80005812:	64a2                	ld	s1,8(sp)
    80005814:	6105                	addi	sp,sp,32
    80005816:	8082                	ret
    panic("acquire");
    80005818:	00002517          	auipc	a0,0x2
    8000581c:	ff850513          	addi	a0,a0,-8 # 80007810 <digits+0x20>
    80005820:	d07ff0ef          	jal	ra,80005526 <panic>

0000000080005824 <pop_off>:

void
pop_off(void)
{
    80005824:	1141                	addi	sp,sp,-16
    80005826:	e406                	sd	ra,8(sp)
    80005828:	e022                	sd	s0,0(sp)
    8000582a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000582c:	cf0fb0ef          	jal	ra,80000d1c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005830:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005834:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005836:	e78d                	bnez	a5,80005860 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005838:	5d3c                	lw	a5,120(a0)
    8000583a:	02f05963          	blez	a5,8000586c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000583e:	37fd                	addiw	a5,a5,-1
    80005840:	0007871b          	sext.w	a4,a5
    80005844:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005846:	eb09                	bnez	a4,80005858 <pop_off+0x34>
    80005848:	5d7c                	lw	a5,124(a0)
    8000584a:	c799                	beqz	a5,80005858 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000584c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005850:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005854:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005858:	60a2                	ld	ra,8(sp)
    8000585a:	6402                	ld	s0,0(sp)
    8000585c:	0141                	addi	sp,sp,16
    8000585e:	8082                	ret
    panic("pop_off - interruptible");
    80005860:	00002517          	auipc	a0,0x2
    80005864:	fb850513          	addi	a0,a0,-72 # 80007818 <digits+0x28>
    80005868:	cbfff0ef          	jal	ra,80005526 <panic>
    panic("pop_off");
    8000586c:	00002517          	auipc	a0,0x2
    80005870:	fc450513          	addi	a0,a0,-60 # 80007830 <digits+0x40>
    80005874:	cb3ff0ef          	jal	ra,80005526 <panic>

0000000080005878 <release>:
{
    80005878:	1101                	addi	sp,sp,-32
    8000587a:	ec06                	sd	ra,24(sp)
    8000587c:	e822                	sd	s0,16(sp)
    8000587e:	e426                	sd	s1,8(sp)
    80005880:	1000                	addi	s0,sp,32
    80005882:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005884:	ef3ff0ef          	jal	ra,80005776 <holding>
    80005888:	c105                	beqz	a0,800058a8 <release+0x30>
  lk->cpu = 0;
    8000588a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000588e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80005892:	0f50000f          	fence	iorw,ow
    80005896:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000589a:	f8bff0ef          	jal	ra,80005824 <pop_off>
}
    8000589e:	60e2                	ld	ra,24(sp)
    800058a0:	6442                	ld	s0,16(sp)
    800058a2:	64a2                	ld	s1,8(sp)
    800058a4:	6105                	addi	sp,sp,32
    800058a6:	8082                	ret
    panic("release");
    800058a8:	00002517          	auipc	a0,0x2
    800058ac:	f9050513          	addi	a0,a0,-112 # 80007838 <digits+0x48>
    800058b0:	c77ff0ef          	jal	ra,80005526 <panic>
	...

0000000080006000 <_trampoline>:
        # user page table.
        #

        # save user a0 in sscratch so
        # a0 can be used to get at TRAPFRAME.
        csrw sscratch, a0
    80006000:	14051073          	csrw	sscratch,a0

        # each process has a separate p->trapframe memory area,
        # but it's mapped to the same virtual address
        # (TRAPFRAME) in every process's user page table.
        li a0, TRAPFRAME
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1
    8000600a:	0536                	slli	a0,a0,0xd
        
        # save the user registers in TRAPFRAME
        sd ra, 40(a0)
    8000600c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
        sd sp, 48(a0)
    80006010:	02253823          	sd	sp,48(a0)
        sd gp, 56(a0)
    80006014:	02353c23          	sd	gp,56(a0)
        sd tp, 64(a0)
    80006018:	04453023          	sd	tp,64(a0)
        sd t0, 72(a0)
    8000601c:	04553423          	sd	t0,72(a0)
        sd t1, 80(a0)
    80006020:	04653823          	sd	t1,80(a0)
        sd t2, 88(a0)
    80006024:	04753c23          	sd	t2,88(a0)
        sd s0, 96(a0)
    80006028:	f120                	sd	s0,96(a0)
        sd s1, 104(a0)
    8000602a:	f524                	sd	s1,104(a0)
        sd a1, 120(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
        sd a2, 128(a0)
    8000602e:	e150                	sd	a2,128(a0)
        sd a3, 136(a0)
    80006030:	e554                	sd	a3,136(a0)
        sd a4, 144(a0)
    80006032:	e958                	sd	a4,144(a0)
        sd a5, 152(a0)
    80006034:	ed5c                	sd	a5,152(a0)
        sd a6, 160(a0)
    80006036:	0b053023          	sd	a6,160(a0)
        sd a7, 168(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
        sd s2, 176(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
        sd s3, 184(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
        sd s4, 192(a0)
    80006046:	0d453023          	sd	s4,192(a0)
        sd s5, 200(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
        sd s6, 208(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
        sd s7, 216(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
        sd s8, 224(a0)
    80006056:	0f853023          	sd	s8,224(a0)
        sd s9, 232(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
        sd s10, 240(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
        sd s11, 248(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
        sd t3, 256(a0)
    80006066:	11c53023          	sd	t3,256(a0)
        sd t4, 264(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
        sd t5, 272(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
        sd t6, 280(a0)
    80006072:	11f53c23          	sd	t6,280(a0)

	# save the user a0 in p->trapframe->a0
        csrr t0, sscratch
    80006076:	140022f3          	csrr	t0,sscratch
        sd t0, 112(a0)
    8000607a:	06553823          	sd	t0,112(a0)

        # initialize kernel stack pointer, from p->trapframe->kernel_sp
        ld sp, 8(a0)
    8000607e:	00853103          	ld	sp,8(a0)

        # make tp hold the current hartid, from p->trapframe->kernel_hartid
        ld tp, 32(a0)
    80006082:	02053203          	ld	tp,32(a0)

        # load the address of usertrap(), from p->trapframe->kernel_trap
        ld t0, 16(a0)
    80006086:	01053283          	ld	t0,16(a0)

        # fetch the kernel page table address, from p->trapframe->kernel_satp.
        ld t1, 0(a0)
    8000608a:	00053303          	ld	t1,0(a0)

        # wait for any previous memory operations to complete, so that
        # they use the user page table.
        sfence.vma zero, zero
    8000608e:	12000073          	sfence.vma

        # install the kernel page table.
        csrw satp, t1
    80006092:	18031073          	csrw	satp,t1

        # flush now-stale user entries from the TLB.
        sfence.vma zero, zero
    80006096:	12000073          	sfence.vma

        # call usertrap()
        jalr t0
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
userret:
        # usertrap() returns here, with user satp in a0.
        # return from kernel to user.

        # switch to the user page table.
        sfence.vma zero, zero
    8000609c:	12000073          	sfence.vma
        csrw satp, a0
    800060a0:	18051073          	csrw	satp,a0
        sfence.vma zero, zero
    800060a4:	12000073          	sfence.vma

        li a0, TRAPFRAME
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1
    800060ae:	0536                	slli	a0,a0,0xd

        # restore all but a0 from TRAPFRAME
        ld ra, 40(a0)
    800060b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
        ld sp, 48(a0)
    800060b4:	03053103          	ld	sp,48(a0)
        ld gp, 56(a0)
    800060b8:	03853183          	ld	gp,56(a0)
        ld tp, 64(a0)
    800060bc:	04053203          	ld	tp,64(a0)
        ld t0, 72(a0)
    800060c0:	04853283          	ld	t0,72(a0)
        ld t1, 80(a0)
    800060c4:	05053303          	ld	t1,80(a0)
        ld t2, 88(a0)
    800060c8:	05853383          	ld	t2,88(a0)
        ld s0, 96(a0)
    800060cc:	7120                	ld	s0,96(a0)
        ld s1, 104(a0)
    800060ce:	7524                	ld	s1,104(a0)
        ld a1, 120(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
        ld a2, 128(a0)
    800060d2:	6150                	ld	a2,128(a0)
        ld a3, 136(a0)
    800060d4:	6554                	ld	a3,136(a0)
        ld a4, 144(a0)
    800060d6:	6958                	ld	a4,144(a0)
        ld a5, 152(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
        ld a6, 160(a0)
    800060da:	0a053803          	ld	a6,160(a0)
        ld a7, 168(a0)
    800060de:	0a853883          	ld	a7,168(a0)
        ld s2, 176(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
        ld s3, 184(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
        ld s4, 192(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
        ld s5, 200(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
        ld s6, 208(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
        ld s7, 216(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
        ld s8, 224(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
        ld s9, 232(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
        ld s10, 240(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
        ld s11, 248(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
        ld t3, 256(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
        ld t4, 264(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
        ld t5, 272(a0)
    80006112:	11053f03          	ld	t5,272(a0)
        ld t6, 280(a0)
    80006116:	11853f83          	ld	t6,280(a0)

	# restore user a0
        ld a0, 112(a0)
    8000611a:	7928                	ld	a0,112(a0)
        
        # return to user mode and user pc.
        # usertrapret() set up sstatus and sepc.
        sret
    8000611c:	10200073          	sret
	...
