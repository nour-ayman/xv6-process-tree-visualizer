
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
    80000016:	4d1040ef          	jal	ra,80004ce6 <start>

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
    8000002c:	e3a9                	bnez	a5,8000006e <kfree+0x52>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00021797          	auipc	a5,0x21
    80000034:	b7878793          	addi	a5,a5,-1160 # 80020ba8 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	00008917          	auipc	s2,0x8
    80000048:	85c90913          	addi	s2,s2,-1956 # 800078a0 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	682050ef          	jal	ra,800056d0 <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	70a050ef          	jal	ra,80005768 <release>
}
    80000062:	60e2                	ld	ra,24(sp)
    80000064:	6442                	ld	s0,16(sp)
    80000066:	64a2                	ld	s1,8(sp)
    80000068:	6902                	ld	s2,0(sp)
    8000006a:	6105                	addi	sp,sp,32
    8000006c:	8082                	ret
    panic("kfree");
    8000006e:	00007517          	auipc	a0,0x7
    80000072:	fa250513          	addi	a0,a0,-94 # 80007010 <etext+0x10>
    80000076:	3a0050ef          	jal	ra,80005416 <panic>

000000008000007a <freerange>:
{
    8000007a:	7179                	addi	sp,sp,-48
    8000007c:	f406                	sd	ra,40(sp)
    8000007e:	f022                	sd	s0,32(sp)
    80000080:	ec26                	sd	s1,24(sp)
    80000082:	e84a                	sd	s2,16(sp)
    80000084:	e44e                	sd	s3,8(sp)
    80000086:	e052                	sd	s4,0(sp)
    80000088:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008a:	6785                	lui	a5,0x1
    8000008c:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000090:	94aa                	add	s1,s1,a0
    80000092:	757d                	lui	a0,0xfffff
    80000094:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000096:	94be                	add	s1,s1,a5
    80000098:	0095ec63          	bltu	a1,s1,800000b0 <freerange+0x36>
    8000009c:	892e                	mv	s2,a1
    kfree(p);
    8000009e:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000a0:	6985                	lui	s3,0x1
    kfree(p);
    800000a2:	01448533          	add	a0,s1,s4
    800000a6:	f77ff0ef          	jal	ra,8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000aa:	94ce                	add	s1,s1,s3
    800000ac:	fe997be3          	bgeu	s2,s1,800000a2 <freerange+0x28>
}
    800000b0:	70a2                	ld	ra,40(sp)
    800000b2:	7402                	ld	s0,32(sp)
    800000b4:	64e2                	ld	s1,24(sp)
    800000b6:	6942                	ld	s2,16(sp)
    800000b8:	69a2                	ld	s3,8(sp)
    800000ba:	6a02                	ld	s4,0(sp)
    800000bc:	6145                	addi	sp,sp,48
    800000be:	8082                	ret

00000000800000c0 <kinit>:
{
    800000c0:	1141                	addi	sp,sp,-16
    800000c2:	e406                	sd	ra,8(sp)
    800000c4:	e022                	sd	s0,0(sp)
    800000c6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000c8:	00007597          	auipc	a1,0x7
    800000cc:	f5058593          	addi	a1,a1,-176 # 80007018 <etext+0x18>
    800000d0:	00007517          	auipc	a0,0x7
    800000d4:	7d050513          	addi	a0,a0,2000 # 800078a0 <kmem>
    800000d8:	578050ef          	jal	ra,80005650 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000dc:	45c5                	li	a1,17
    800000de:	05ee                	slli	a1,a1,0x1b
    800000e0:	00021517          	auipc	a0,0x21
    800000e4:	ac850513          	addi	a0,a0,-1336 # 80020ba8 <end>
    800000e8:	f93ff0ef          	jal	ra,8000007a <freerange>
}
    800000ec:	60a2                	ld	ra,8(sp)
    800000ee:	6402                	ld	s0,0(sp)
    800000f0:	0141                	addi	sp,sp,16
    800000f2:	8082                	ret

00000000800000f4 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000f4:	1101                	addi	sp,sp,-32
    800000f6:	ec06                	sd	ra,24(sp)
    800000f8:	e822                	sd	s0,16(sp)
    800000fa:	e426                	sd	s1,8(sp)
    800000fc:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800000fe:	00007497          	auipc	s1,0x7
    80000102:	7a248493          	addi	s1,s1,1954 # 800078a0 <kmem>
    80000106:	8526                	mv	a0,s1
    80000108:	5c8050ef          	jal	ra,800056d0 <acquire>
  r = kmem.freelist;
    8000010c:	6c84                	ld	s1,24(s1)
  if(r) {
    8000010e:	c491                	beqz	s1,8000011a <kalloc+0x26>
    kmem.freelist = r->next;
    80000110:	609c                	ld	a5,0(s1)
    80000112:	00007717          	auipc	a4,0x7
    80000116:	7af73323          	sd	a5,1958(a4) # 800078b8 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011a:	00007517          	auipc	a0,0x7
    8000011e:	78650513          	addi	a0,a0,1926 # 800078a0 <kmem>
    80000122:	646050ef          	jal	ra,80005768 <release>
#ifndef LAB_SYSCALL
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
#endif
  return (void*)r;
}
    80000126:	8526                	mv	a0,s1
    80000128:	60e2                	ld	ra,24(sp)
    8000012a:	6442                	ld	s0,16(sp)
    8000012c:	64a2                	ld	s1,8(sp)
    8000012e:	6105                	addi	sp,sp,32
    80000130:	8082                	ret

0000000080000132 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000132:	1141                	addi	sp,sp,-16
    80000134:	e422                	sd	s0,8(sp)
    80000136:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000138:	ce09                	beqz	a2,80000152 <memset+0x20>
    8000013a:	87aa                	mv	a5,a0
    8000013c:	fff6071b          	addiw	a4,a2,-1
    80000140:	1702                	slli	a4,a4,0x20
    80000142:	9301                	srli	a4,a4,0x20
    80000144:	0705                	addi	a4,a4,1
    80000146:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000148:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000014c:	0785                	addi	a5,a5,1
    8000014e:	fee79de3          	bne	a5,a4,80000148 <memset+0x16>
  }
  return dst;
}
    80000152:	6422                	ld	s0,8(sp)
    80000154:	0141                	addi	sp,sp,16
    80000156:	8082                	ret

0000000080000158 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000158:	1141                	addi	sp,sp,-16
    8000015a:	e422                	sd	s0,8(sp)
    8000015c:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000015e:	ca05                	beqz	a2,8000018e <memcmp+0x36>
    80000160:	fff6069b          	addiw	a3,a2,-1
    80000164:	1682                	slli	a3,a3,0x20
    80000166:	9281                	srli	a3,a3,0x20
    80000168:	0685                	addi	a3,a3,1
    8000016a:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000016c:	00054783          	lbu	a5,0(a0)
    80000170:	0005c703          	lbu	a4,0(a1)
    80000174:	00e79863          	bne	a5,a4,80000184 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000178:	0505                	addi	a0,a0,1
    8000017a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000017c:	fed518e3          	bne	a0,a3,8000016c <memcmp+0x14>
  }

  return 0;
    80000180:	4501                	li	a0,0
    80000182:	a019                	j	80000188 <memcmp+0x30>
      return *s1 - *s2;
    80000184:	40e7853b          	subw	a0,a5,a4
}
    80000188:	6422                	ld	s0,8(sp)
    8000018a:	0141                	addi	sp,sp,16
    8000018c:	8082                	ret
  return 0;
    8000018e:	4501                	li	a0,0
    80000190:	bfe5                	j	80000188 <memcmp+0x30>

0000000080000192 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000192:	1141                	addi	sp,sp,-16
    80000194:	e422                	sd	s0,8(sp)
    80000196:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000198:	ca0d                	beqz	a2,800001ca <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000019a:	00a5f963          	bgeu	a1,a0,800001ac <memmove+0x1a>
    8000019e:	02061693          	slli	a3,a2,0x20
    800001a2:	9281                	srli	a3,a3,0x20
    800001a4:	00d58733          	add	a4,a1,a3
    800001a8:	02e56463          	bltu	a0,a4,800001d0 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001ac:	fff6079b          	addiw	a5,a2,-1
    800001b0:	1782                	slli	a5,a5,0x20
    800001b2:	9381                	srli	a5,a5,0x20
    800001b4:	0785                	addi	a5,a5,1
    800001b6:	97ae                	add	a5,a5,a1
    800001b8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ba:	0585                	addi	a1,a1,1
    800001bc:	0705                	addi	a4,a4,1
    800001be:	fff5c683          	lbu	a3,-1(a1)
    800001c2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001c6:	fef59ae3          	bne	a1,a5,800001ba <memmove+0x28>

  return dst;
}
    800001ca:	6422                	ld	s0,8(sp)
    800001cc:	0141                	addi	sp,sp,16
    800001ce:	8082                	ret
    d += n;
    800001d0:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001d2:	fff6079b          	addiw	a5,a2,-1
    800001d6:	1782                	slli	a5,a5,0x20
    800001d8:	9381                	srli	a5,a5,0x20
    800001da:	fff7c793          	not	a5,a5
    800001de:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001e0:	177d                	addi	a4,a4,-1
    800001e2:	16fd                	addi	a3,a3,-1
    800001e4:	00074603          	lbu	a2,0(a4)
    800001e8:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800001ec:	fef71ae3          	bne	a4,a5,800001e0 <memmove+0x4e>
    800001f0:	bfe9                	j	800001ca <memmove+0x38>

00000000800001f2 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800001f2:	1141                	addi	sp,sp,-16
    800001f4:	e406                	sd	ra,8(sp)
    800001f6:	e022                	sd	s0,0(sp)
    800001f8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800001fa:	f99ff0ef          	jal	ra,80000192 <memmove>
}
    800001fe:	60a2                	ld	ra,8(sp)
    80000200:	6402                	ld	s0,0(sp)
    80000202:	0141                	addi	sp,sp,16
    80000204:	8082                	ret

0000000080000206 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e422                	sd	s0,8(sp)
    8000020a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000020c:	ce11                	beqz	a2,80000228 <strncmp+0x22>
    8000020e:	00054783          	lbu	a5,0(a0)
    80000212:	cf89                	beqz	a5,8000022c <strncmp+0x26>
    80000214:	0005c703          	lbu	a4,0(a1)
    80000218:	00f71a63          	bne	a4,a5,8000022c <strncmp+0x26>
    n--, p++, q++;
    8000021c:	367d                	addiw	a2,a2,-1
    8000021e:	0505                	addi	a0,a0,1
    80000220:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000222:	f675                	bnez	a2,8000020e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000224:	4501                	li	a0,0
    80000226:	a809                	j	80000238 <strncmp+0x32>
    80000228:	4501                	li	a0,0
    8000022a:	a039                	j	80000238 <strncmp+0x32>
  if(n == 0)
    8000022c:	ca09                	beqz	a2,8000023e <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000022e:	00054503          	lbu	a0,0(a0)
    80000232:	0005c783          	lbu	a5,0(a1)
    80000236:	9d1d                	subw	a0,a0,a5
}
    80000238:	6422                	ld	s0,8(sp)
    8000023a:	0141                	addi	sp,sp,16
    8000023c:	8082                	ret
    return 0;
    8000023e:	4501                	li	a0,0
    80000240:	bfe5                	j	80000238 <strncmp+0x32>

0000000080000242 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000242:	1141                	addi	sp,sp,-16
    80000244:	e422                	sd	s0,8(sp)
    80000246:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000248:	872a                	mv	a4,a0
    8000024a:	8832                	mv	a6,a2
    8000024c:	367d                	addiw	a2,a2,-1
    8000024e:	01005963          	blez	a6,80000260 <strncpy+0x1e>
    80000252:	0705                	addi	a4,a4,1
    80000254:	0005c783          	lbu	a5,0(a1)
    80000258:	fef70fa3          	sb	a5,-1(a4)
    8000025c:	0585                	addi	a1,a1,1
    8000025e:	f7f5                	bnez	a5,8000024a <strncpy+0x8>
    ;
  while(n-- > 0)
    80000260:	00c05d63          	blez	a2,8000027a <strncpy+0x38>
    80000264:	86ba                	mv	a3,a4
    *s++ = 0;
    80000266:	0685                	addi	a3,a3,1
    80000268:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    8000026c:	fff6c793          	not	a5,a3
    80000270:	9fb9                	addw	a5,a5,a4
    80000272:	010787bb          	addw	a5,a5,a6
    80000276:	fef048e3          	bgtz	a5,80000266 <strncpy+0x24>
  return os;
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret

0000000080000280 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000280:	1141                	addi	sp,sp,-16
    80000282:	e422                	sd	s0,8(sp)
    80000284:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000286:	02c05363          	blez	a2,800002ac <safestrcpy+0x2c>
    8000028a:	fff6069b          	addiw	a3,a2,-1
    8000028e:	1682                	slli	a3,a3,0x20
    80000290:	9281                	srli	a3,a3,0x20
    80000292:	96ae                	add	a3,a3,a1
    80000294:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000296:	00d58963          	beq	a1,a3,800002a8 <safestrcpy+0x28>
    8000029a:	0585                	addi	a1,a1,1
    8000029c:	0785                	addi	a5,a5,1
    8000029e:	fff5c703          	lbu	a4,-1(a1)
    800002a2:	fee78fa3          	sb	a4,-1(a5)
    800002a6:	fb65                	bnez	a4,80000296 <safestrcpy+0x16>
    ;
  *s = 0;
    800002a8:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ac:	6422                	ld	s0,8(sp)
    800002ae:	0141                	addi	sp,sp,16
    800002b0:	8082                	ret

00000000800002b2 <strlen>:

int
strlen(const char *s)
{
    800002b2:	1141                	addi	sp,sp,-16
    800002b4:	e422                	sd	s0,8(sp)
    800002b6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002b8:	00054783          	lbu	a5,0(a0)
    800002bc:	cf91                	beqz	a5,800002d8 <strlen+0x26>
    800002be:	0505                	addi	a0,a0,1
    800002c0:	87aa                	mv	a5,a0
    800002c2:	4685                	li	a3,1
    800002c4:	9e89                	subw	a3,a3,a0
    800002c6:	00f6853b          	addw	a0,a3,a5
    800002ca:	0785                	addi	a5,a5,1
    800002cc:	fff7c703          	lbu	a4,-1(a5)
    800002d0:	fb7d                	bnez	a4,800002c6 <strlen+0x14>
    ;
  return n;
}
    800002d2:	6422                	ld	s0,8(sp)
    800002d4:	0141                	addi	sp,sp,16
    800002d6:	8082                	ret
  for(n = 0; s[n]; n++)
    800002d8:	4501                	li	a0,0
    800002da:	bfe5                	j	800002d2 <strlen+0x20>

00000000800002dc <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002dc:	1141                	addi	sp,sp,-16
    800002de:	e406                	sd	ra,8(sp)
    800002e0:	e022                	sd	s0,0(sp)
    800002e2:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002e4:	207000ef          	jal	ra,80000cea <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002e8:	00007717          	auipc	a4,0x7
    800002ec:	58870713          	addi	a4,a4,1416 # 80007870 <started>
  if(cpuid() == 0){
    800002f0:	c51d                	beqz	a0,8000031e <main+0x42>
    while(started == 0)
    800002f2:	431c                	lw	a5,0(a4)
    800002f4:	2781                	sext.w	a5,a5
    800002f6:	dff5                	beqz	a5,800002f2 <main+0x16>
      ;
    __sync_synchronize();
    800002f8:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800002fc:	1ef000ef          	jal	ra,80000cea <cpuid>
    80000300:	85aa                	mv	a1,a0
    80000302:	00007517          	auipc	a0,0x7
    80000306:	d3650513          	addi	a0,a0,-714 # 80007038 <etext+0x38>
    8000030a:	647040ef          	jal	ra,80005150 <printf>
    kvminithart();    // turn on paging
    8000030e:	080000ef          	jal	ra,8000038e <kvminithart>
    trapinithart();   // install kernel trap vector
    80000312:	516010ef          	jal	ra,80001828 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000316:	3ce040ef          	jal	ra,800046e4 <plicinithart>
  }

  scheduler();        
    8000031a:	657000ef          	jal	ra,80001170 <scheduler>
    consoleinit();
    8000031e:	55b040ef          	jal	ra,80005078 <consoleinit>
    printfinit();
    80000322:	130050ef          	jal	ra,80005452 <printfinit>
    printf("\n");
    80000326:	00007517          	auipc	a0,0x7
    8000032a:	d2250513          	addi	a0,a0,-734 # 80007048 <etext+0x48>
    8000032e:	623040ef          	jal	ra,80005150 <printf>
    printf("xv6 kernel is booting\n");
    80000332:	00007517          	auipc	a0,0x7
    80000336:	cee50513          	addi	a0,a0,-786 # 80007020 <etext+0x20>
    8000033a:	617040ef          	jal	ra,80005150 <printf>
    printf("\n");
    8000033e:	00007517          	auipc	a0,0x7
    80000342:	d0a50513          	addi	a0,a0,-758 # 80007048 <etext+0x48>
    80000346:	60b040ef          	jal	ra,80005150 <printf>
    kinit();         // physical page allocator
    8000034a:	d77ff0ef          	jal	ra,800000c0 <kinit>
    kvminit();       // create kernel page table
    8000034e:	2ca000ef          	jal	ra,80000618 <kvminit>
    kvminithart();   // turn on paging
    80000352:	03c000ef          	jal	ra,8000038e <kvminithart>
    procinit();      // process table
    80000356:	0ed000ef          	jal	ra,80000c42 <procinit>
    trapinit();      // trap vectors
    8000035a:	4aa010ef          	jal	ra,80001804 <trapinit>
    trapinithart();  // install kernel trap vector
    8000035e:	4ca010ef          	jal	ra,80001828 <trapinithart>
    plicinit();      // set up interrupt controller
    80000362:	36c040ef          	jal	ra,800046ce <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000366:	37e040ef          	jal	ra,800046e4 <plicinithart>
    binit();         // buffer cache
    8000036a:	33d010ef          	jal	ra,80001ea6 <binit>
    iinit();         // inode table
    8000036e:	0b0020ef          	jal	ra,8000241e <iinit>
    fileinit();      // file table
    80000372:	791020ef          	jal	ra,80003302 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000376:	45e040ef          	jal	ra,800047d4 <virtio_disk_init>
    userinit();      // first user process
    8000037a:	463000ef          	jal	ra,80000fdc <userinit>
    __sync_synchronize();
    8000037e:	0ff0000f          	fence
    started = 1;
    80000382:	4785                	li	a5,1
    80000384:	00007717          	auipc	a4,0x7
    80000388:	4ef72623          	sw	a5,1260(a4) # 80007870 <started>
    8000038c:	b779                	j	8000031a <main+0x3e>

000000008000038e <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    8000038e:	1141                	addi	sp,sp,-16
    80000390:	e422                	sd	s0,8(sp)
    80000392:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000394:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000398:	00007797          	auipc	a5,0x7
    8000039c:	4e07b783          	ld	a5,1248(a5) # 80007878 <kernel_pagetable>
    800003a0:	83b1                	srli	a5,a5,0xc
    800003a2:	577d                	li	a4,-1
    800003a4:	177e                	slli	a4,a4,0x3f
    800003a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003a8:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003ac:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003b0:	6422                	ld	s0,8(sp)
    800003b2:	0141                	addi	sp,sp,16
    800003b4:	8082                	ret

00000000800003b6 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003b6:	7139                	addi	sp,sp,-64
    800003b8:	fc06                	sd	ra,56(sp)
    800003ba:	f822                	sd	s0,48(sp)
    800003bc:	f426                	sd	s1,40(sp)
    800003be:	f04a                	sd	s2,32(sp)
    800003c0:	ec4e                	sd	s3,24(sp)
    800003c2:	e852                	sd	s4,16(sp)
    800003c4:	e456                	sd	s5,8(sp)
    800003c6:	e05a                	sd	s6,0(sp)
    800003c8:	0080                	addi	s0,sp,64
    800003ca:	84aa                	mv	s1,a0
    800003cc:	89ae                	mv	s3,a1
    800003ce:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003d0:	57fd                	li	a5,-1
    800003d2:	83e9                	srli	a5,a5,0x1a
    800003d4:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003d6:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003d8:	02b7fc63          	bgeu	a5,a1,80000410 <walk+0x5a>
    panic("walk");
    800003dc:	00007517          	auipc	a0,0x7
    800003e0:	c7450513          	addi	a0,a0,-908 # 80007050 <etext+0x50>
    800003e4:	032050ef          	jal	ra,80005416 <panic>
      if(PTE_LEAF(*pte)) {
        return pte;
      }
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003e8:	060a8263          	beqz	s5,8000044c <walk+0x96>
    800003ec:	d09ff0ef          	jal	ra,800000f4 <kalloc>
    800003f0:	84aa                	mv	s1,a0
    800003f2:	c139                	beqz	a0,80000438 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800003f4:	6605                	lui	a2,0x1
    800003f6:	4581                	li	a1,0
    800003f8:	d3bff0ef          	jal	ra,80000132 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800003fc:	00c4d793          	srli	a5,s1,0xc
    80000400:	07aa                	slli	a5,a5,0xa
    80000402:	0017e793          	ori	a5,a5,1
    80000406:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000040a:	3a5d                	addiw	s4,s4,-9
    8000040c:	036a0063          	beq	s4,s6,8000042c <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000410:	0149d933          	srl	s2,s3,s4
    80000414:	1ff97913          	andi	s2,s2,511
    80000418:	090e                	slli	s2,s2,0x3
    8000041a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000041c:	00093483          	ld	s1,0(s2)
    80000420:	0014f793          	andi	a5,s1,1
    80000424:	d3f1                	beqz	a5,800003e8 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000426:	80a9                	srli	s1,s1,0xa
    80000428:	04b2                	slli	s1,s1,0xc
    8000042a:	b7c5                	j	8000040a <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    8000042c:	00c9d513          	srli	a0,s3,0xc
    80000430:	1ff57513          	andi	a0,a0,511
    80000434:	050e                	slli	a0,a0,0x3
    80000436:	9526                	add	a0,a0,s1
}
    80000438:	70e2                	ld	ra,56(sp)
    8000043a:	7442                	ld	s0,48(sp)
    8000043c:	74a2                	ld	s1,40(sp)
    8000043e:	7902                	ld	s2,32(sp)
    80000440:	69e2                	ld	s3,24(sp)
    80000442:	6a42                	ld	s4,16(sp)
    80000444:	6aa2                	ld	s5,8(sp)
    80000446:	6b02                	ld	s6,0(sp)
    80000448:	6121                	addi	sp,sp,64
    8000044a:	8082                	ret
        return 0;
    8000044c:	4501                	li	a0,0
    8000044e:	b7ed                	j	80000438 <walk+0x82>

0000000080000450 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000450:	57fd                	li	a5,-1
    80000452:	83e9                	srli	a5,a5,0x1a
    80000454:	00b7f463          	bgeu	a5,a1,8000045c <walkaddr+0xc>
    return 0;
    80000458:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000045a:	8082                	ret
{
    8000045c:	1141                	addi	sp,sp,-16
    8000045e:	e406                	sd	ra,8(sp)
    80000460:	e022                	sd	s0,0(sp)
    80000462:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000464:	4601                	li	a2,0
    80000466:	f51ff0ef          	jal	ra,800003b6 <walk>
  if(pte == 0)
    8000046a:	c105                	beqz	a0,8000048a <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    8000046c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000046e:	0117f693          	andi	a3,a5,17
    80000472:	4745                	li	a4,17
    return 0;
    80000474:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000476:	00e68663          	beq	a3,a4,80000482 <walkaddr+0x32>
}
    8000047a:	60a2                	ld	ra,8(sp)
    8000047c:	6402                	ld	s0,0(sp)
    8000047e:	0141                	addi	sp,sp,16
    80000480:	8082                	ret
  pa = PTE2PA(*pte);
    80000482:	00a7d513          	srli	a0,a5,0xa
    80000486:	0532                	slli	a0,a0,0xc
  return pa;
    80000488:	bfcd                	j	8000047a <walkaddr+0x2a>
    return 0;
    8000048a:	4501                	li	a0,0
    8000048c:	b7fd                	j	8000047a <walkaddr+0x2a>

000000008000048e <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000048e:	715d                	addi	sp,sp,-80
    80000490:	e486                	sd	ra,72(sp)
    80000492:	e0a2                	sd	s0,64(sp)
    80000494:	fc26                	sd	s1,56(sp)
    80000496:	f84a                	sd	s2,48(sp)
    80000498:	f44e                	sd	s3,40(sp)
    8000049a:	f052                	sd	s4,32(sp)
    8000049c:	ec56                	sd	s5,24(sp)
    8000049e:	e85a                	sd	s6,16(sp)
    800004a0:	e45e                	sd	s7,8(sp)
    800004a2:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004a4:	03459793          	slli	a5,a1,0x34
    800004a8:	e385                	bnez	a5,800004c8 <mappages+0x3a>
    800004aa:	8aaa                	mv	s5,a0
    800004ac:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004ae:	03461793          	slli	a5,a2,0x34
    800004b2:	e38d                	bnez	a5,800004d4 <mappages+0x46>
    panic("mappages: size not aligned");

  if(size == 0)
    800004b4:	c615                	beqz	a2,800004e0 <mappages+0x52>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004b6:	79fd                	lui	s3,0xfffff
    800004b8:	964e                	add	a2,a2,s3
    800004ba:	00b609b3          	add	s3,a2,a1
  a = va;
    800004be:	892e                	mv	s2,a1
    800004c0:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004c4:	6b85                	lui	s7,0x1
    800004c6:	a815                	j	800004fa <mappages+0x6c>
    panic("mappages: va not aligned");
    800004c8:	00007517          	auipc	a0,0x7
    800004cc:	b9050513          	addi	a0,a0,-1136 # 80007058 <etext+0x58>
    800004d0:	747040ef          	jal	ra,80005416 <panic>
    panic("mappages: size not aligned");
    800004d4:	00007517          	auipc	a0,0x7
    800004d8:	ba450513          	addi	a0,a0,-1116 # 80007078 <etext+0x78>
    800004dc:	73b040ef          	jal	ra,80005416 <panic>
    panic("mappages: size");
    800004e0:	00007517          	auipc	a0,0x7
    800004e4:	bb850513          	addi	a0,a0,-1096 # 80007098 <etext+0x98>
    800004e8:	72f040ef          	jal	ra,80005416 <panic>
      panic("mappages: remap");
    800004ec:	00007517          	auipc	a0,0x7
    800004f0:	bbc50513          	addi	a0,a0,-1092 # 800070a8 <etext+0xa8>
    800004f4:	723040ef          	jal	ra,80005416 <panic>
    a += PGSIZE;
    800004f8:	995e                	add	s2,s2,s7
  for(;;){
    800004fa:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fe:	4605                	li	a2,1
    80000500:	85ca                	mv	a1,s2
    80000502:	8556                	mv	a0,s5
    80000504:	eb3ff0ef          	jal	ra,800003b6 <walk>
    80000508:	cd19                	beqz	a0,80000526 <mappages+0x98>
    if(*pte & PTE_V)
    8000050a:	611c                	ld	a5,0(a0)
    8000050c:	8b85                	andi	a5,a5,1
    8000050e:	fff9                	bnez	a5,800004ec <mappages+0x5e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000510:	80b1                	srli	s1,s1,0xc
    80000512:	04aa                	slli	s1,s1,0xa
    80000514:	0164e4b3          	or	s1,s1,s6
    80000518:	0014e493          	ori	s1,s1,1
    8000051c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000051e:	fd391de3          	bne	s2,s3,800004f8 <mappages+0x6a>
    pa += PGSIZE;
  }
  return 0;
    80000522:	4501                	li	a0,0
    80000524:	a011                	j	80000528 <mappages+0x9a>
      return -1;
    80000526:	557d                	li	a0,-1
}
    80000528:	60a6                	ld	ra,72(sp)
    8000052a:	6406                	ld	s0,64(sp)
    8000052c:	74e2                	ld	s1,56(sp)
    8000052e:	7942                	ld	s2,48(sp)
    80000530:	79a2                	ld	s3,40(sp)
    80000532:	7a02                	ld	s4,32(sp)
    80000534:	6ae2                	ld	s5,24(sp)
    80000536:	6b42                	ld	s6,16(sp)
    80000538:	6ba2                	ld	s7,8(sp)
    8000053a:	6161                	addi	sp,sp,80
    8000053c:	8082                	ret

000000008000053e <kvmmap>:
{
    8000053e:	1141                	addi	sp,sp,-16
    80000540:	e406                	sd	ra,8(sp)
    80000542:	e022                	sd	s0,0(sp)
    80000544:	0800                	addi	s0,sp,16
    80000546:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000548:	86b2                	mv	a3,a2
    8000054a:	863e                	mv	a2,a5
    8000054c:	f43ff0ef          	jal	ra,8000048e <mappages>
    80000550:	e509                	bnez	a0,8000055a <kvmmap+0x1c>
}
    80000552:	60a2                	ld	ra,8(sp)
    80000554:	6402                	ld	s0,0(sp)
    80000556:	0141                	addi	sp,sp,16
    80000558:	8082                	ret
    panic("kvmmap");
    8000055a:	00007517          	auipc	a0,0x7
    8000055e:	b5e50513          	addi	a0,a0,-1186 # 800070b8 <etext+0xb8>
    80000562:	6b5040ef          	jal	ra,80005416 <panic>

0000000080000566 <kvmmake>:
{
    80000566:	1101                	addi	sp,sp,-32
    80000568:	ec06                	sd	ra,24(sp)
    8000056a:	e822                	sd	s0,16(sp)
    8000056c:	e426                	sd	s1,8(sp)
    8000056e:	e04a                	sd	s2,0(sp)
    80000570:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000572:	b83ff0ef          	jal	ra,800000f4 <kalloc>
    80000576:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000578:	6605                	lui	a2,0x1
    8000057a:	4581                	li	a1,0
    8000057c:	bb7ff0ef          	jal	ra,80000132 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000580:	4719                	li	a4,6
    80000582:	6685                	lui	a3,0x1
    80000584:	10000637          	lui	a2,0x10000
    80000588:	100005b7          	lui	a1,0x10000
    8000058c:	8526                	mv	a0,s1
    8000058e:	fb1ff0ef          	jal	ra,8000053e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000592:	4719                	li	a4,6
    80000594:	6685                	lui	a3,0x1
    80000596:	10001637          	lui	a2,0x10001
    8000059a:	100015b7          	lui	a1,0x10001
    8000059e:	8526                	mv	a0,s1
    800005a0:	f9fff0ef          	jal	ra,8000053e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005a4:	4719                	li	a4,6
    800005a6:	040006b7          	lui	a3,0x4000
    800005aa:	0c000637          	lui	a2,0xc000
    800005ae:	0c0005b7          	lui	a1,0xc000
    800005b2:	8526                	mv	a0,s1
    800005b4:	f8bff0ef          	jal	ra,8000053e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005b8:	00007917          	auipc	s2,0x7
    800005bc:	a4890913          	addi	s2,s2,-1464 # 80007000 <etext>
    800005c0:	4729                	li	a4,10
    800005c2:	80007697          	auipc	a3,0x80007
    800005c6:	a3e68693          	addi	a3,a3,-1474 # 7000 <_entry-0x7fff9000>
    800005ca:	4605                	li	a2,1
    800005cc:	067e                	slli	a2,a2,0x1f
    800005ce:	85b2                	mv	a1,a2
    800005d0:	8526                	mv	a0,s1
    800005d2:	f6dff0ef          	jal	ra,8000053e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005d6:	4719                	li	a4,6
    800005d8:	46c5                	li	a3,17
    800005da:	06ee                	slli	a3,a3,0x1b
    800005dc:	412686b3          	sub	a3,a3,s2
    800005e0:	864a                	mv	a2,s2
    800005e2:	85ca                	mv	a1,s2
    800005e4:	8526                	mv	a0,s1
    800005e6:	f59ff0ef          	jal	ra,8000053e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005ea:	4729                	li	a4,10
    800005ec:	6685                	lui	a3,0x1
    800005ee:	00006617          	auipc	a2,0x6
    800005f2:	a1260613          	addi	a2,a2,-1518 # 80006000 <_trampoline>
    800005f6:	040005b7          	lui	a1,0x4000
    800005fa:	15fd                	addi	a1,a1,-1
    800005fc:	05b2                	slli	a1,a1,0xc
    800005fe:	8526                	mv	a0,s1
    80000600:	f3fff0ef          	jal	ra,8000053e <kvmmap>
  proc_mapstacks(kpgtbl);
    80000604:	8526                	mv	a0,s1
    80000606:	5b2000ef          	jal	ra,80000bb8 <proc_mapstacks>
}
    8000060a:	8526                	mv	a0,s1
    8000060c:	60e2                	ld	ra,24(sp)
    8000060e:	6442                	ld	s0,16(sp)
    80000610:	64a2                	ld	s1,8(sp)
    80000612:	6902                	ld	s2,0(sp)
    80000614:	6105                	addi	sp,sp,32
    80000616:	8082                	ret

0000000080000618 <kvminit>:
{
    80000618:	1141                	addi	sp,sp,-16
    8000061a:	e406                	sd	ra,8(sp)
    8000061c:	e022                	sd	s0,0(sp)
    8000061e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000620:	f47ff0ef          	jal	ra,80000566 <kvmmake>
    80000624:	00007797          	auipc	a5,0x7
    80000628:	24a7ba23          	sd	a0,596(a5) # 80007878 <kernel_pagetable>
}
    8000062c:	60a2                	ld	ra,8(sp)
    8000062e:	6402                	ld	s0,0(sp)
    80000630:	0141                	addi	sp,sp,16
    80000632:	8082                	ret

0000000080000634 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000634:	1101                	addi	sp,sp,-32
    80000636:	ec06                	sd	ra,24(sp)
    80000638:	e822                	sd	s0,16(sp)
    8000063a:	e426                	sd	s1,8(sp)
    8000063c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000063e:	ab7ff0ef          	jal	ra,800000f4 <kalloc>
    80000642:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000644:	c509                	beqz	a0,8000064e <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000646:	6605                	lui	a2,0x1
    80000648:	4581                	li	a1,0
    8000064a:	ae9ff0ef          	jal	ra,80000132 <memset>
  return pagetable;
}
    8000064e:	8526                	mv	a0,s1
    80000650:	60e2                	ld	ra,24(sp)
    80000652:	6442                	ld	s0,16(sp)
    80000654:	64a2                	ld	s1,8(sp)
    80000656:	6105                	addi	sp,sp,32
    80000658:	8082                	ret

000000008000065a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000065a:	715d                	addi	sp,sp,-80
    8000065c:	e486                	sd	ra,72(sp)
    8000065e:	e0a2                	sd	s0,64(sp)
    80000660:	fc26                	sd	s1,56(sp)
    80000662:	f84a                	sd	s2,48(sp)
    80000664:	f44e                	sd	s3,40(sp)
    80000666:	f052                	sd	s4,32(sp)
    80000668:	ec56                	sd	s5,24(sp)
    8000066a:	e85a                	sd	s6,16(sp)
    8000066c:	e45e                	sd	s7,8(sp)
    8000066e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz = PGSIZE;

  if((va % PGSIZE) != 0)
    80000670:	03459793          	slli	a5,a1,0x34
    80000674:	e795                	bnez	a5,800006a0 <uvmunmap+0x46>
    80000676:	8a2a                	mv	s4,a0
    80000678:	892e                	mv	s2,a1
    8000067a:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000067c:	0632                	slli	a2,a2,0xc
    8000067e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
      continue;
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
      continue;
    sz = PGSIZE;
    if(PTE_FLAGS(*pte) == PTE_V)
    80000682:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000684:	6a85                	lui	s5,0x1
    80000686:	0535e363          	bltu	a1,s3,800006cc <uvmunmap+0x72>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000068a:	60a6                	ld	ra,72(sp)
    8000068c:	6406                	ld	s0,64(sp)
    8000068e:	74e2                	ld	s1,56(sp)
    80000690:	7942                	ld	s2,48(sp)
    80000692:	79a2                	ld	s3,40(sp)
    80000694:	7a02                	ld	s4,32(sp)
    80000696:	6ae2                	ld	s5,24(sp)
    80000698:	6b42                	ld	s6,16(sp)
    8000069a:	6ba2                	ld	s7,8(sp)
    8000069c:	6161                	addi	sp,sp,80
    8000069e:	8082                	ret
    panic("uvmunmap: not aligned");
    800006a0:	00007517          	auipc	a0,0x7
    800006a4:	a2050513          	addi	a0,a0,-1504 # 800070c0 <etext+0xc0>
    800006a8:	56f040ef          	jal	ra,80005416 <panic>
      panic("uvmunmap: not a leaf");
    800006ac:	00007517          	auipc	a0,0x7
    800006b0:	a2c50513          	addi	a0,a0,-1492 # 800070d8 <etext+0xd8>
    800006b4:	563040ef          	jal	ra,80005416 <panic>
      uint64 pa = PTE2PA(*pte);
    800006b8:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800006ba:	00c79513          	slli	a0,a5,0xc
    800006be:	95fff0ef          	jal	ra,8000001c <kfree>
    *pte = 0;
    800006c2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006c6:	9956                	add	s2,s2,s5
    800006c8:	fd3971e3          	bgeu	s2,s3,8000068a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800006cc:	4601                	li	a2,0
    800006ce:	85ca                	mv	a1,s2
    800006d0:	8552                	mv	a0,s4
    800006d2:	ce5ff0ef          	jal	ra,800003b6 <walk>
    800006d6:	84aa                	mv	s1,a0
    800006d8:	d57d                	beqz	a0,800006c6 <uvmunmap+0x6c>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    800006da:	611c                	ld	a5,0(a0)
    800006dc:	0017f713          	andi	a4,a5,1
    800006e0:	d37d                	beqz	a4,800006c6 <uvmunmap+0x6c>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006e2:	3ff7f713          	andi	a4,a5,1023
    800006e6:	fd7703e3          	beq	a4,s7,800006ac <uvmunmap+0x52>
    if(do_free){
    800006ea:	fc0b0ce3          	beqz	s6,800006c2 <uvmunmap+0x68>
    800006ee:	b7e9                	j	800006b8 <uvmunmap+0x5e>

00000000800006f0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800006f0:	1101                	addi	sp,sp,-32
    800006f2:	ec06                	sd	ra,24(sp)
    800006f4:	e822                	sd	s0,16(sp)
    800006f6:	e426                	sd	s1,8(sp)
    800006f8:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800006fa:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800006fc:	00b67d63          	bgeu	a2,a1,80000716 <uvmdealloc+0x26>
    80000700:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000702:	6785                	lui	a5,0x1
    80000704:	17fd                	addi	a5,a5,-1
    80000706:	00f60733          	add	a4,a2,a5
    8000070a:	767d                	lui	a2,0xfffff
    8000070c:	8f71                	and	a4,a4,a2
    8000070e:	97ae                	add	a5,a5,a1
    80000710:	8ff1                	and	a5,a5,a2
    80000712:	00f76863          	bltu	a4,a5,80000722 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000716:	8526                	mv	a0,s1
    80000718:	60e2                	ld	ra,24(sp)
    8000071a:	6442                	ld	s0,16(sp)
    8000071c:	64a2                	ld	s1,8(sp)
    8000071e:	6105                	addi	sp,sp,32
    80000720:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000722:	8f99                	sub	a5,a5,a4
    80000724:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000726:	4685                	li	a3,1
    80000728:	0007861b          	sext.w	a2,a5
    8000072c:	85ba                	mv	a1,a4
    8000072e:	f2dff0ef          	jal	ra,8000065a <uvmunmap>
    80000732:	b7d5                	j	80000716 <uvmdealloc+0x26>

0000000080000734 <uvmalloc>:
  if(newsz < oldsz)
    80000734:	08b66563          	bltu	a2,a1,800007be <uvmalloc+0x8a>
{
    80000738:	7139                	addi	sp,sp,-64
    8000073a:	fc06                	sd	ra,56(sp)
    8000073c:	f822                	sd	s0,48(sp)
    8000073e:	f426                	sd	s1,40(sp)
    80000740:	f04a                	sd	s2,32(sp)
    80000742:	ec4e                	sd	s3,24(sp)
    80000744:	e852                	sd	s4,16(sp)
    80000746:	e456                	sd	s5,8(sp)
    80000748:	e05a                	sd	s6,0(sp)
    8000074a:	0080                	addi	s0,sp,64
    8000074c:	8aaa                	mv	s5,a0
    8000074e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000750:	6985                	lui	s3,0x1
    80000752:	19fd                	addi	s3,s3,-1
    80000754:	95ce                	add	a1,a1,s3
    80000756:	79fd                	lui	s3,0xfffff
    80000758:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += sz){
    8000075c:	06c9f363          	bgeu	s3,a2,800007c2 <uvmalloc+0x8e>
    80000760:	894e                	mv	s2,s3
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000762:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000766:	98fff0ef          	jal	ra,800000f4 <kalloc>
    8000076a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000076c:	cd19                	beqz	a0,8000078a <uvmalloc+0x56>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000076e:	875a                	mv	a4,s6
    80000770:	86aa                	mv	a3,a0
    80000772:	6605                	lui	a2,0x1
    80000774:	85ca                	mv	a1,s2
    80000776:	8556                	mv	a0,s5
    80000778:	d17ff0ef          	jal	ra,8000048e <mappages>
    8000077c:	e51d                	bnez	a0,800007aa <uvmalloc+0x76>
  for(a = oldsz; a < newsz; a += sz){
    8000077e:	6785                	lui	a5,0x1
    80000780:	993e                	add	s2,s2,a5
    80000782:	ff4962e3          	bltu	s2,s4,80000766 <uvmalloc+0x32>
  return newsz;
    80000786:	8552                	mv	a0,s4
    80000788:	a039                	j	80000796 <uvmalloc+0x62>
      uvmdealloc(pagetable, a, oldsz);
    8000078a:	864e                	mv	a2,s3
    8000078c:	85ca                	mv	a1,s2
    8000078e:	8556                	mv	a0,s5
    80000790:	f61ff0ef          	jal	ra,800006f0 <uvmdealloc>
      return 0;
    80000794:	4501                	li	a0,0
}
    80000796:	70e2                	ld	ra,56(sp)
    80000798:	7442                	ld	s0,48(sp)
    8000079a:	74a2                	ld	s1,40(sp)
    8000079c:	7902                	ld	s2,32(sp)
    8000079e:	69e2                	ld	s3,24(sp)
    800007a0:	6a42                	ld	s4,16(sp)
    800007a2:	6aa2                	ld	s5,8(sp)
    800007a4:	6b02                	ld	s6,0(sp)
    800007a6:	6121                	addi	sp,sp,64
    800007a8:	8082                	ret
      kfree(mem);
    800007aa:	8526                	mv	a0,s1
    800007ac:	871ff0ef          	jal	ra,8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800007b0:	864e                	mv	a2,s3
    800007b2:	85ca                	mv	a1,s2
    800007b4:	8556                	mv	a0,s5
    800007b6:	f3bff0ef          	jal	ra,800006f0 <uvmdealloc>
      return 0;
    800007ba:	4501                	li	a0,0
    800007bc:	bfe9                	j	80000796 <uvmalloc+0x62>
    return oldsz;
    800007be:	852e                	mv	a0,a1
}
    800007c0:	8082                	ret
  return newsz;
    800007c2:	8532                	mv	a0,a2
    800007c4:	bfc9                	j	80000796 <uvmalloc+0x62>

00000000800007c6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800007c6:	7179                	addi	sp,sp,-48
    800007c8:	f406                	sd	ra,40(sp)
    800007ca:	f022                	sd	s0,32(sp)
    800007cc:	ec26                	sd	s1,24(sp)
    800007ce:	e84a                	sd	s2,16(sp)
    800007d0:	e44e                	sd	s3,8(sp)
    800007d2:	e052                	sd	s4,0(sp)
    800007d4:	1800                	addi	s0,sp,48
    800007d6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800007d8:	84aa                	mv	s1,a0
    800007da:	6905                	lui	s2,0x1
    800007dc:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800007de:	4985                	li	s3,1
    800007e0:	a811                	j	800007f4 <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800007e2:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800007e4:	0532                	slli	a0,a0,0xc
    800007e6:	fe1ff0ef          	jal	ra,800007c6 <freewalk>
      pagetable[i] = 0;
    800007ea:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800007ee:	04a1                	addi	s1,s1,8
    800007f0:	01248f63          	beq	s1,s2,8000080e <freewalk+0x48>
    pte_t pte = pagetable[i];
    800007f4:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800007f6:	00f57793          	andi	a5,a0,15
    800007fa:	ff3784e3          	beq	a5,s3,800007e2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800007fe:	8905                	andi	a0,a0,1
    80000800:	d57d                	beqz	a0,800007ee <freewalk+0x28>
      // backtrace();
      panic("freewalk: leaf");
    80000802:	00007517          	auipc	a0,0x7
    80000806:	8ee50513          	addi	a0,a0,-1810 # 800070f0 <etext+0xf0>
    8000080a:	40d040ef          	jal	ra,80005416 <panic>
    }
  }
  kfree((void*)pagetable);
    8000080e:	8552                	mv	a0,s4
    80000810:	80dff0ef          	jal	ra,8000001c <kfree>
}
    80000814:	70a2                	ld	ra,40(sp)
    80000816:	7402                	ld	s0,32(sp)
    80000818:	64e2                	ld	s1,24(sp)
    8000081a:	6942                	ld	s2,16(sp)
    8000081c:	69a2                	ld	s3,8(sp)
    8000081e:	6a02                	ld	s4,0(sp)
    80000820:	6145                	addi	sp,sp,48
    80000822:	8082                	ret

0000000080000824 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000824:	1101                	addi	sp,sp,-32
    80000826:	ec06                	sd	ra,24(sp)
    80000828:	e822                	sd	s0,16(sp)
    8000082a:	e426                	sd	s1,8(sp)
    8000082c:	1000                	addi	s0,sp,32
    8000082e:	84aa                	mv	s1,a0
  if(sz > 0)
    80000830:	e989                	bnez	a1,80000842 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000832:	8526                	mv	a0,s1
    80000834:	f93ff0ef          	jal	ra,800007c6 <freewalk>
}
    80000838:	60e2                	ld	ra,24(sp)
    8000083a:	6442                	ld	s0,16(sp)
    8000083c:	64a2                	ld	s1,8(sp)
    8000083e:	6105                	addi	sp,sp,32
    80000840:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000842:	6605                	lui	a2,0x1
    80000844:	167d                	addi	a2,a2,-1
    80000846:	962e                	add	a2,a2,a1
    80000848:	4685                	li	a3,1
    8000084a:	8231                	srli	a2,a2,0xc
    8000084c:	4581                	li	a1,0
    8000084e:	e0dff0ef          	jal	ra,8000065a <uvmunmap>
    80000852:	b7c5                	j	80000832 <uvmfree+0xe>

0000000080000854 <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc = PGSIZE;

  for(i = 0; i < sz; i += szinc){
    80000854:	ce49                	beqz	a2,800008ee <uvmcopy+0x9a>
{
    80000856:	715d                	addi	sp,sp,-80
    80000858:	e486                	sd	ra,72(sp)
    8000085a:	e0a2                	sd	s0,64(sp)
    8000085c:	fc26                	sd	s1,56(sp)
    8000085e:	f84a                	sd	s2,48(sp)
    80000860:	f44e                	sd	s3,40(sp)
    80000862:	f052                	sd	s4,32(sp)
    80000864:	ec56                	sd	s5,24(sp)
    80000866:	e85a                	sd	s6,16(sp)
    80000868:	e45e                	sd	s7,8(sp)
    8000086a:	0880                	addi	s0,sp,80
    8000086c:	8aaa                	mv	s5,a0
    8000086e:	8b2e                	mv	s6,a1
    80000870:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += szinc){
    80000872:	4481                	li	s1,0
    80000874:	a029                	j	8000087e <uvmcopy+0x2a>
    80000876:	6785                	lui	a5,0x1
    80000878:	94be                	add	s1,s1,a5
    8000087a:	0544fe63          	bgeu	s1,s4,800008d6 <uvmcopy+0x82>
    if((pte = walk(old, i, 0)) == 0)
    8000087e:	4601                	li	a2,0
    80000880:	85a6                	mv	a1,s1
    80000882:	8556                	mv	a0,s5
    80000884:	b33ff0ef          	jal	ra,800003b6 <walk>
    80000888:	d57d                	beqz	a0,80000876 <uvmcopy+0x22>
      continue;
    if((*pte & PTE_V) == 0) {
    8000088a:	6118                	ld	a4,0(a0)
    8000088c:	00177793          	andi	a5,a4,1
    80000890:	d3fd                	beqz	a5,80000876 <uvmcopy+0x22>
      continue;
    }
    szinc = PGSIZE;
    pa = PTE2PA(*pte);
    80000892:	00a75593          	srli	a1,a4,0xa
    80000896:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000089a:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    8000089e:	857ff0ef          	jal	ra,800000f4 <kalloc>
    800008a2:	89aa                	mv	s3,a0
    800008a4:	c105                	beqz	a0,800008c4 <uvmcopy+0x70>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800008a6:	6605                	lui	a2,0x1
    800008a8:	85de                	mv	a1,s7
    800008aa:	8e9ff0ef          	jal	ra,80000192 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800008ae:	874a                	mv	a4,s2
    800008b0:	86ce                	mv	a3,s3
    800008b2:	6605                	lui	a2,0x1
    800008b4:	85a6                	mv	a1,s1
    800008b6:	855a                	mv	a0,s6
    800008b8:	bd7ff0ef          	jal	ra,8000048e <mappages>
    800008bc:	dd4d                	beqz	a0,80000876 <uvmcopy+0x22>
      kfree(mem);
    800008be:	854e                	mv	a0,s3
    800008c0:	f5cff0ef          	jal	ra,8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800008c4:	4685                	li	a3,1
    800008c6:	00c4d613          	srli	a2,s1,0xc
    800008ca:	4581                	li	a1,0
    800008cc:	855a                	mv	a0,s6
    800008ce:	d8dff0ef          	jal	ra,8000065a <uvmunmap>
  return -1;
    800008d2:	557d                	li	a0,-1
    800008d4:	a011                	j	800008d8 <uvmcopy+0x84>
  return 0;
    800008d6:	4501                	li	a0,0
}
    800008d8:	60a6                	ld	ra,72(sp)
    800008da:	6406                	ld	s0,64(sp)
    800008dc:	74e2                	ld	s1,56(sp)
    800008de:	7942                	ld	s2,48(sp)
    800008e0:	79a2                	ld	s3,40(sp)
    800008e2:	7a02                	ld	s4,32(sp)
    800008e4:	6ae2                	ld	s5,24(sp)
    800008e6:	6b42                	ld	s6,16(sp)
    800008e8:	6ba2                	ld	s7,8(sp)
    800008ea:	6161                	addi	sp,sp,80
    800008ec:	8082                	ret
  return 0;
    800008ee:	4501                	li	a0,0
}
    800008f0:	8082                	ret

00000000800008f2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800008f2:	1141                	addi	sp,sp,-16
    800008f4:	e406                	sd	ra,8(sp)
    800008f6:	e022                	sd	s0,0(sp)
    800008f8:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800008fa:	4601                	li	a2,0
    800008fc:	abbff0ef          	jal	ra,800003b6 <walk>
  if(pte == 0)
    80000900:	c901                	beqz	a0,80000910 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000902:	611c                	ld	a5,0(a0)
    80000904:	9bbd                	andi	a5,a5,-17
    80000906:	e11c                	sd	a5,0(a0)
}
    80000908:	60a2                	ld	ra,8(sp)
    8000090a:	6402                	ld	s0,0(sp)
    8000090c:	0141                	addi	sp,sp,16
    8000090e:	8082                	ret
    panic("uvmclear");
    80000910:	00006517          	auipc	a0,0x6
    80000914:	7f050513          	addi	a0,a0,2032 # 80007100 <etext+0x100>
    80000918:	2ff040ef          	jal	ra,80005416 <panic>

000000008000091c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000091c:	c2d5                	beqz	a3,800009c0 <copyinstr+0xa4>
{
    8000091e:	715d                	addi	sp,sp,-80
    80000920:	e486                	sd	ra,72(sp)
    80000922:	e0a2                	sd	s0,64(sp)
    80000924:	fc26                	sd	s1,56(sp)
    80000926:	f84a                	sd	s2,48(sp)
    80000928:	f44e                	sd	s3,40(sp)
    8000092a:	f052                	sd	s4,32(sp)
    8000092c:	ec56                	sd	s5,24(sp)
    8000092e:	e85a                	sd	s6,16(sp)
    80000930:	e45e                	sd	s7,8(sp)
    80000932:	0880                	addi	s0,sp,80
    80000934:	8a2a                	mv	s4,a0
    80000936:	8b2e                	mv	s6,a1
    80000938:	8bb2                	mv	s7,a2
    8000093a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000093c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000093e:	6985                	lui	s3,0x1
    80000940:	a035                	j	8000096c <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000942:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000946:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000948:	0017b793          	seqz	a5,a5
    8000094c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000950:	60a6                	ld	ra,72(sp)
    80000952:	6406                	ld	s0,64(sp)
    80000954:	74e2                	ld	s1,56(sp)
    80000956:	7942                	ld	s2,48(sp)
    80000958:	79a2                	ld	s3,40(sp)
    8000095a:	7a02                	ld	s4,32(sp)
    8000095c:	6ae2                	ld	s5,24(sp)
    8000095e:	6b42                	ld	s6,16(sp)
    80000960:	6ba2                	ld	s7,8(sp)
    80000962:	6161                	addi	sp,sp,80
    80000964:	8082                	ret
    srcva = va0 + PGSIZE;
    80000966:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    8000096a:	c4b9                	beqz	s1,800009b8 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    8000096c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000970:	85ca                	mv	a1,s2
    80000972:	8552                	mv	a0,s4
    80000974:	addff0ef          	jal	ra,80000450 <walkaddr>
    if(pa0 == 0)
    80000978:	c131                	beqz	a0,800009bc <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    8000097a:	41790833          	sub	a6,s2,s7
    8000097e:	984e                	add	a6,a6,s3
    if(n > max)
    80000980:	0104f363          	bgeu	s1,a6,80000986 <copyinstr+0x6a>
    80000984:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000986:	955e                	add	a0,a0,s7
    80000988:	41250533          	sub	a0,a0,s2
    while(n > 0){
    8000098c:	fc080de3          	beqz	a6,80000966 <copyinstr+0x4a>
    80000990:	985a                	add	a6,a6,s6
    80000992:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000994:	41650633          	sub	a2,a0,s6
    80000998:	14fd                	addi	s1,s1,-1
    8000099a:	9b26                	add	s6,s6,s1
    8000099c:	00f60733          	add	a4,a2,a5
    800009a0:	00074703          	lbu	a4,0(a4)
    800009a4:	df59                	beqz	a4,80000942 <copyinstr+0x26>
        *dst = *p;
    800009a6:	00e78023          	sb	a4,0(a5)
      --max;
    800009aa:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800009ae:	0785                	addi	a5,a5,1
    while(n > 0){
    800009b0:	ff0796e3          	bne	a5,a6,8000099c <copyinstr+0x80>
      dst++;
    800009b4:	8b42                	mv	s6,a6
    800009b6:	bf45                	j	80000966 <copyinstr+0x4a>
    800009b8:	4781                	li	a5,0
    800009ba:	b779                	j	80000948 <copyinstr+0x2c>
      return -1;
    800009bc:	557d                	li	a0,-1
    800009be:	bf49                	j	80000950 <copyinstr+0x34>
  int got_null = 0;
    800009c0:	4781                	li	a5,0
  if(got_null){
    800009c2:	0017b793          	seqz	a5,a5
    800009c6:	40f00533          	neg	a0,a5
}
    800009ca:	8082                	ret

00000000800009cc <ismapped>:
  }
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va) {
    800009cc:	1141                	addi	sp,sp,-16
    800009ce:	e406                	sd	ra,8(sp)
    800009d0:	e022                	sd	s0,0(sp)
    800009d2:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800009d4:	4601                	li	a2,0
    800009d6:	9e1ff0ef          	jal	ra,800003b6 <walk>
  if (pte == 0) {
    800009da:	c519                	beqz	a0,800009e8 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    800009dc:	6108                	ld	a0,0(a0)
    return 0;
    800009de:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800009e0:	60a2                	ld	ra,8(sp)
    800009e2:	6402                	ld	s0,0(sp)
    800009e4:	0141                	addi	sp,sp,16
    800009e6:	8082                	ret
    return 0;
    800009e8:	4501                	li	a0,0
    800009ea:	bfdd                	j	800009e0 <ismapped+0x14>

00000000800009ec <vmfault>:
{
    800009ec:	7179                	addi	sp,sp,-48
    800009ee:	f406                	sd	ra,40(sp)
    800009f0:	f022                	sd	s0,32(sp)
    800009f2:	ec26                	sd	s1,24(sp)
    800009f4:	e84a                	sd	s2,16(sp)
    800009f6:	e44e                	sd	s3,8(sp)
    800009f8:	e052                	sd	s4,0(sp)
    800009fa:	1800                	addi	s0,sp,48
    800009fc:	89aa                	mv	s3,a0
    800009fe:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80000a00:	316000ef          	jal	ra,80000d16 <myproc>
  if (va >= p->sz)
    80000a04:	653c                	ld	a5,72(a0)
    80000a06:	00f4ec63          	bltu	s1,a5,80000a1e <vmfault+0x32>
    return 0;
    80000a0a:	4981                	li	s3,0
}
    80000a0c:	854e                	mv	a0,s3
    80000a0e:	70a2                	ld	ra,40(sp)
    80000a10:	7402                	ld	s0,32(sp)
    80000a12:	64e2                	ld	s1,24(sp)
    80000a14:	6942                	ld	s2,16(sp)
    80000a16:	69a2                	ld	s3,8(sp)
    80000a18:	6a02                	ld	s4,0(sp)
    80000a1a:	6145                	addi	sp,sp,48
    80000a1c:	8082                	ret
    80000a1e:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    80000a20:	75fd                	lui	a1,0xfffff
    80000a22:	8ced                	and	s1,s1,a1
  if(ismapped(pagetable, va)) {
    80000a24:	85a6                	mv	a1,s1
    80000a26:	854e                	mv	a0,s3
    80000a28:	fa5ff0ef          	jal	ra,800009cc <ismapped>
    return 0;
    80000a2c:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80000a2e:	fd79                	bnez	a0,80000a0c <vmfault+0x20>
  mem = (uint64) kalloc();
    80000a30:	ec4ff0ef          	jal	ra,800000f4 <kalloc>
    80000a34:	8a2a                	mv	s4,a0
  if(mem == 0)
    80000a36:	d979                	beqz	a0,80000a0c <vmfault+0x20>
  mem = (uint64) kalloc();
    80000a38:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80000a3a:	6605                	lui	a2,0x1
    80000a3c:	4581                	li	a1,0
    80000a3e:	ef4ff0ef          	jal	ra,80000132 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000a42:	4759                	li	a4,22
    80000a44:	86d2                	mv	a3,s4
    80000a46:	6605                	lui	a2,0x1
    80000a48:	85a6                	mv	a1,s1
    80000a4a:	05093503          	ld	a0,80(s2) # 1050 <_entry-0x7fffefb0>
    80000a4e:	a41ff0ef          	jal	ra,8000048e <mappages>
    80000a52:	dd4d                	beqz	a0,80000a0c <vmfault+0x20>
    kfree((void *)mem);
    80000a54:	8552                	mv	a0,s4
    80000a56:	dc6ff0ef          	jal	ra,8000001c <kfree>
    return 0;
    80000a5a:	4981                	li	s3,0
    80000a5c:	bf45                	j	80000a0c <vmfault+0x20>

0000000080000a5e <copyout>:
  while(len > 0){
    80000a5e:	cec9                	beqz	a3,80000af8 <copyout+0x9a>
{
    80000a60:	711d                	addi	sp,sp,-96
    80000a62:	ec86                	sd	ra,88(sp)
    80000a64:	e8a2                	sd	s0,80(sp)
    80000a66:	e4a6                	sd	s1,72(sp)
    80000a68:	e0ca                	sd	s2,64(sp)
    80000a6a:	fc4e                	sd	s3,56(sp)
    80000a6c:	f852                	sd	s4,48(sp)
    80000a6e:	f456                	sd	s5,40(sp)
    80000a70:	f05a                	sd	s6,32(sp)
    80000a72:	ec5e                	sd	s7,24(sp)
    80000a74:	e862                	sd	s8,16(sp)
    80000a76:	e466                	sd	s9,8(sp)
    80000a78:	e06a                	sd	s10,0(sp)
    80000a7a:	1080                	addi	s0,sp,96
    80000a7c:	8baa                	mv	s7,a0
    80000a7e:	8aae                	mv	s5,a1
    80000a80:	8b32                	mv	s6,a2
    80000a82:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000a84:	74fd                	lui	s1,0xfffff
    80000a86:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000a88:	57fd                	li	a5,-1
    80000a8a:	83e9                	srli	a5,a5,0x1a
    80000a8c:	0697e863          	bltu	a5,s1,80000afc <copyout+0x9e>
    80000a90:	6c85                	lui	s9,0x1
    80000a92:	8c3e                	mv	s8,a5
    80000a94:	a015                	j	80000ab8 <copyout+0x5a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a96:	409a8533          	sub	a0,s5,s1
    80000a9a:	0009861b          	sext.w	a2,s3
    80000a9e:	85da                	mv	a1,s6
    80000aa0:	954a                	add	a0,a0,s2
    80000aa2:	ef0ff0ef          	jal	ra,80000192 <memmove>
    len -= n;
    80000aa6:	413a0a33          	sub	s4,s4,s3
    src += n;
    80000aaa:	9b4e                	add	s6,s6,s3
  while(len > 0){
    80000aac:	040a0463          	beqz	s4,80000af4 <copyout+0x96>
    if (va0 >= MAXVA)
    80000ab0:	05ac6863          	bltu	s8,s10,80000b00 <copyout+0xa2>
    va0 = PGROUNDDOWN(dstva);
    80000ab4:	84ea                	mv	s1,s10
    dstva = va0 + PGSIZE;
    80000ab6:	8aea                	mv	s5,s10
    pa0 = walkaddr(pagetable, va0);
    80000ab8:	85a6                	mv	a1,s1
    80000aba:	855e                	mv	a0,s7
    80000abc:	995ff0ef          	jal	ra,80000450 <walkaddr>
    80000ac0:	892a                	mv	s2,a0
    if(pa0 == 0) {
    80000ac2:	e901                	bnez	a0,80000ad2 <copyout+0x74>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000ac4:	4601                	li	a2,0
    80000ac6:	85a6                	mv	a1,s1
    80000ac8:	855e                	mv	a0,s7
    80000aca:	f23ff0ef          	jal	ra,800009ec <vmfault>
    80000ace:	892a                	mv	s2,a0
    80000ad0:	c915                	beqz	a0,80000b04 <copyout+0xa6>
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000ad2:	4601                	li	a2,0
    80000ad4:	85a6                	mv	a1,s1
    80000ad6:	855e                	mv	a0,s7
    80000ad8:	8dfff0ef          	jal	ra,800003b6 <walk>
    80000adc:	c515                	beqz	a0,80000b08 <copyout+0xaa>
    if((*pte & PTE_W) == 0)
    80000ade:	611c                	ld	a5,0(a0)
    80000ae0:	8b91                	andi	a5,a5,4
    80000ae2:	c3b1                	beqz	a5,80000b26 <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    80000ae4:	01948d33          	add	s10,s1,s9
    80000ae8:	415d09b3          	sub	s3,s10,s5
    if(n > len)
    80000aec:	fb3a75e3          	bgeu	s4,s3,80000a96 <copyout+0x38>
    80000af0:	89d2                	mv	s3,s4
    80000af2:	b755                	j	80000a96 <copyout+0x38>
  return 0;
    80000af4:	4501                	li	a0,0
    80000af6:	a811                	j	80000b0a <copyout+0xac>
    80000af8:	4501                	li	a0,0
}
    80000afa:	8082                	ret
      return -1;
    80000afc:	557d                	li	a0,-1
    80000afe:	a031                	j	80000b0a <copyout+0xac>
    80000b00:	557d                	li	a0,-1
    80000b02:	a021                	j	80000b0a <copyout+0xac>
        return -1;
    80000b04:	557d                	li	a0,-1
    80000b06:	a011                	j	80000b0a <copyout+0xac>
      return -1;
    80000b08:	557d                	li	a0,-1
}
    80000b0a:	60e6                	ld	ra,88(sp)
    80000b0c:	6446                	ld	s0,80(sp)
    80000b0e:	64a6                	ld	s1,72(sp)
    80000b10:	6906                	ld	s2,64(sp)
    80000b12:	79e2                	ld	s3,56(sp)
    80000b14:	7a42                	ld	s4,48(sp)
    80000b16:	7aa2                	ld	s5,40(sp)
    80000b18:	7b02                	ld	s6,32(sp)
    80000b1a:	6be2                	ld	s7,24(sp)
    80000b1c:	6c42                	ld	s8,16(sp)
    80000b1e:	6ca2                	ld	s9,8(sp)
    80000b20:	6d02                	ld	s10,0(sp)
    80000b22:	6125                	addi	sp,sp,96
    80000b24:	8082                	ret
      return -1;
    80000b26:	557d                	li	a0,-1
    80000b28:	b7cd                	j	80000b0a <copyout+0xac>

0000000080000b2a <copyin>:
  while(len > 0){
    80000b2a:	c6c9                	beqz	a3,80000bb4 <copyin+0x8a>
{
    80000b2c:	715d                	addi	sp,sp,-80
    80000b2e:	e486                	sd	ra,72(sp)
    80000b30:	e0a2                	sd	s0,64(sp)
    80000b32:	fc26                	sd	s1,56(sp)
    80000b34:	f84a                	sd	s2,48(sp)
    80000b36:	f44e                	sd	s3,40(sp)
    80000b38:	f052                	sd	s4,32(sp)
    80000b3a:	ec56                	sd	s5,24(sp)
    80000b3c:	e85a                	sd	s6,16(sp)
    80000b3e:	e45e                	sd	s7,8(sp)
    80000b40:	e062                	sd	s8,0(sp)
    80000b42:	0880                	addi	s0,sp,80
    80000b44:	8baa                	mv	s7,a0
    80000b46:	8aae                	mv	s5,a1
    80000b48:	8932                	mv	s2,a2
    80000b4a:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000b4c:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000b4e:	6b05                	lui	s6,0x1
    80000b50:	a035                	j	80000b7c <copyin+0x52>
    80000b52:	412984b3          	sub	s1,s3,s2
    80000b56:	94da                	add	s1,s1,s6
    if(n > len)
    80000b58:	009a7363          	bgeu	s4,s1,80000b5e <copyin+0x34>
    80000b5c:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b5e:	413905b3          	sub	a1,s2,s3
    80000b62:	0004861b          	sext.w	a2,s1
    80000b66:	95aa                	add	a1,a1,a0
    80000b68:	8556                	mv	a0,s5
    80000b6a:	e28ff0ef          	jal	ra,80000192 <memmove>
    len -= n;
    80000b6e:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000b72:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000b74:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000b78:	020a0163          	beqz	s4,80000b9a <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000b7c:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000b80:	85ce                	mv	a1,s3
    80000b82:	855e                	mv	a0,s7
    80000b84:	8cdff0ef          	jal	ra,80000450 <walkaddr>
    if(pa0 == 0) {
    80000b88:	f569                	bnez	a0,80000b52 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000b8a:	4601                	li	a2,0
    80000b8c:	85ce                	mv	a1,s3
    80000b8e:	855e                	mv	a0,s7
    80000b90:	e5dff0ef          	jal	ra,800009ec <vmfault>
    80000b94:	fd5d                	bnez	a0,80000b52 <copyin+0x28>
        return -1;
    80000b96:	557d                	li	a0,-1
    80000b98:	a011                	j	80000b9c <copyin+0x72>
  return 0;
    80000b9a:	4501                	li	a0,0
}
    80000b9c:	60a6                	ld	ra,72(sp)
    80000b9e:	6406                	ld	s0,64(sp)
    80000ba0:	74e2                	ld	s1,56(sp)
    80000ba2:	7942                	ld	s2,48(sp)
    80000ba4:	79a2                	ld	s3,40(sp)
    80000ba6:	7a02                	ld	s4,32(sp)
    80000ba8:	6ae2                	ld	s5,24(sp)
    80000baa:	6b42                	ld	s6,16(sp)
    80000bac:	6ba2                	ld	s7,8(sp)
    80000bae:	6c02                	ld	s8,0(sp)
    80000bb0:	6161                	addi	sp,sp,80
    80000bb2:	8082                	ret
  return 0;
    80000bb4:	4501                	li	a0,0
}
    80000bb6:	8082                	ret

0000000080000bb8 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bb8:	7139                	addi	sp,sp,-64
    80000bba:	fc06                	sd	ra,56(sp)
    80000bbc:	f822                	sd	s0,48(sp)
    80000bbe:	f426                	sd	s1,40(sp)
    80000bc0:	f04a                	sd	s2,32(sp)
    80000bc2:	ec4e                	sd	s3,24(sp)
    80000bc4:	e852                	sd	s4,16(sp)
    80000bc6:	e456                	sd	s5,8(sp)
    80000bc8:	e05a                	sd	s6,0(sp)
    80000bca:	0080                	addi	s0,sp,64
    80000bcc:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000bce:	00007497          	auipc	s1,0x7
    80000bd2:	12248493          	addi	s1,s1,290 # 80007cf0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bd6:	8b26                	mv	s6,s1
    80000bd8:	00006a97          	auipc	s5,0x6
    80000bdc:	428a8a93          	addi	s5,s5,1064 # 80007000 <etext>
    80000be0:	04000937          	lui	s2,0x4000
    80000be4:	197d                	addi	s2,s2,-1
    80000be6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000be8:	0000da17          	auipc	s4,0xd
    80000bec:	b08a0a13          	addi	s4,s4,-1272 # 8000d6f0 <tickslock>
    char *pa = kalloc();
    80000bf0:	d04ff0ef          	jal	ra,800000f4 <kalloc>
    80000bf4:	862a                	mv	a2,a0
    if(pa == 0)
    80000bf6:	c121                	beqz	a0,80000c36 <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    80000bf8:	416485b3          	sub	a1,s1,s6
    80000bfc:	858d                	srai	a1,a1,0x3
    80000bfe:	000ab783          	ld	a5,0(s5)
    80000c02:	02f585b3          	mul	a1,a1,a5
    80000c06:	2585                	addiw	a1,a1,1
    80000c08:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c0c:	4719                	li	a4,6
    80000c0e:	6685                	lui	a3,0x1
    80000c10:	40b905b3          	sub	a1,s2,a1
    80000c14:	854e                	mv	a0,s3
    80000c16:	929ff0ef          	jal	ra,8000053e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c1a:	16848493          	addi	s1,s1,360
    80000c1e:	fd4499e3          	bne	s1,s4,80000bf0 <proc_mapstacks+0x38>
  }
}
    80000c22:	70e2                	ld	ra,56(sp)
    80000c24:	7442                	ld	s0,48(sp)
    80000c26:	74a2                	ld	s1,40(sp)
    80000c28:	7902                	ld	s2,32(sp)
    80000c2a:	69e2                	ld	s3,24(sp)
    80000c2c:	6a42                	ld	s4,16(sp)
    80000c2e:	6aa2                	ld	s5,8(sp)
    80000c30:	6b02                	ld	s6,0(sp)
    80000c32:	6121                	addi	sp,sp,64
    80000c34:	8082                	ret
      panic("kalloc");
    80000c36:	00006517          	auipc	a0,0x6
    80000c3a:	4da50513          	addi	a0,a0,1242 # 80007110 <etext+0x110>
    80000c3e:	7d8040ef          	jal	ra,80005416 <panic>

0000000080000c42 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c42:	7139                	addi	sp,sp,-64
    80000c44:	fc06                	sd	ra,56(sp)
    80000c46:	f822                	sd	s0,48(sp)
    80000c48:	f426                	sd	s1,40(sp)
    80000c4a:	f04a                	sd	s2,32(sp)
    80000c4c:	ec4e                	sd	s3,24(sp)
    80000c4e:	e852                	sd	s4,16(sp)
    80000c50:	e456                	sd	s5,8(sp)
    80000c52:	e05a                	sd	s6,0(sp)
    80000c54:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c56:	00006597          	auipc	a1,0x6
    80000c5a:	4c258593          	addi	a1,a1,1218 # 80007118 <etext+0x118>
    80000c5e:	00007517          	auipc	a0,0x7
    80000c62:	c6250513          	addi	a0,a0,-926 # 800078c0 <pid_lock>
    80000c66:	1eb040ef          	jal	ra,80005650 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c6a:	00006597          	auipc	a1,0x6
    80000c6e:	4b658593          	addi	a1,a1,1206 # 80007120 <etext+0x120>
    80000c72:	00007517          	auipc	a0,0x7
    80000c76:	c6650513          	addi	a0,a0,-922 # 800078d8 <wait_lock>
    80000c7a:	1d7040ef          	jal	ra,80005650 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c7e:	00007497          	auipc	s1,0x7
    80000c82:	07248493          	addi	s1,s1,114 # 80007cf0 <proc>
      initlock(&p->lock, "proc");
    80000c86:	00006b17          	auipc	s6,0x6
    80000c8a:	4aab0b13          	addi	s6,s6,1194 # 80007130 <etext+0x130>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000c8e:	8aa6                	mv	s5,s1
    80000c90:	00006a17          	auipc	s4,0x6
    80000c94:	370a0a13          	addi	s4,s4,880 # 80007000 <etext>
    80000c98:	04000937          	lui	s2,0x4000
    80000c9c:	197d                	addi	s2,s2,-1
    80000c9e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ca0:	0000d997          	auipc	s3,0xd
    80000ca4:	a5098993          	addi	s3,s3,-1456 # 8000d6f0 <tickslock>
      initlock(&p->lock, "proc");
    80000ca8:	85da                	mv	a1,s6
    80000caa:	8526                	mv	a0,s1
    80000cac:	1a5040ef          	jal	ra,80005650 <initlock>
      p->state = UNUSED;
    80000cb0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000cb4:	415487b3          	sub	a5,s1,s5
    80000cb8:	878d                	srai	a5,a5,0x3
    80000cba:	000a3703          	ld	a4,0(s4)
    80000cbe:	02e787b3          	mul	a5,a5,a4
    80000cc2:	2785                	addiw	a5,a5,1
    80000cc4:	00d7979b          	slliw	a5,a5,0xd
    80000cc8:	40f907b3          	sub	a5,s2,a5
    80000ccc:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cce:	16848493          	addi	s1,s1,360
    80000cd2:	fd349be3          	bne	s1,s3,80000ca8 <procinit+0x66>
  }
}
    80000cd6:	70e2                	ld	ra,56(sp)
    80000cd8:	7442                	ld	s0,48(sp)
    80000cda:	74a2                	ld	s1,40(sp)
    80000cdc:	7902                	ld	s2,32(sp)
    80000cde:	69e2                	ld	s3,24(sp)
    80000ce0:	6a42                	ld	s4,16(sp)
    80000ce2:	6aa2                	ld	s5,8(sp)
    80000ce4:	6b02                	ld	s6,0(sp)
    80000ce6:	6121                	addi	sp,sp,64
    80000ce8:	8082                	ret

0000000080000cea <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000cea:	1141                	addi	sp,sp,-16
    80000cec:	e422                	sd	s0,8(sp)
    80000cee:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000cf0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000cf2:	2501                	sext.w	a0,a0
    80000cf4:	6422                	ld	s0,8(sp)
    80000cf6:	0141                	addi	sp,sp,16
    80000cf8:	8082                	ret

0000000080000cfa <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000cfa:	1141                	addi	sp,sp,-16
    80000cfc:	e422                	sd	s0,8(sp)
    80000cfe:	0800                	addi	s0,sp,16
    80000d00:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d02:	2781                	sext.w	a5,a5
    80000d04:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d06:	00007517          	auipc	a0,0x7
    80000d0a:	bea50513          	addi	a0,a0,-1046 # 800078f0 <cpus>
    80000d0e:	953e                	add	a0,a0,a5
    80000d10:	6422                	ld	s0,8(sp)
    80000d12:	0141                	addi	sp,sp,16
    80000d14:	8082                	ret

0000000080000d16 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d16:	1101                	addi	sp,sp,-32
    80000d18:	ec06                	sd	ra,24(sp)
    80000d1a:	e822                	sd	s0,16(sp)
    80000d1c:	e426                	sd	s1,8(sp)
    80000d1e:	1000                	addi	s0,sp,32
  push_off();
    80000d20:	171040ef          	jal	ra,80005690 <push_off>
    80000d24:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d26:	2781                	sext.w	a5,a5
    80000d28:	079e                	slli	a5,a5,0x7
    80000d2a:	00007717          	auipc	a4,0x7
    80000d2e:	b9670713          	addi	a4,a4,-1130 # 800078c0 <pid_lock>
    80000d32:	97ba                	add	a5,a5,a4
    80000d34:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d36:	1df040ef          	jal	ra,80005714 <pop_off>
  return p;
}
    80000d3a:	8526                	mv	a0,s1
    80000d3c:	60e2                	ld	ra,24(sp)
    80000d3e:	6442                	ld	s0,16(sp)
    80000d40:	64a2                	ld	s1,8(sp)
    80000d42:	6105                	addi	sp,sp,32
    80000d44:	8082                	ret

0000000080000d46 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d46:	7179                	addi	sp,sp,-48
    80000d48:	f406                	sd	ra,40(sp)
    80000d4a:	f022                	sd	s0,32(sp)
    80000d4c:	ec26                	sd	s1,24(sp)
    80000d4e:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000d50:	fc7ff0ef          	jal	ra,80000d16 <myproc>
    80000d54:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000d56:	213040ef          	jal	ra,80005768 <release>

  if (first) {
    80000d5a:	00007797          	auipc	a5,0x7
    80000d5e:	ae67a783          	lw	a5,-1306(a5) # 80007840 <first.1683>
    80000d62:	cf8d                	beqz	a5,80000d9c <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000d64:	4505                	li	a0,1
    80000d66:	369010ef          	jal	ra,800028ce <fsinit>

    first = 0;
    80000d6a:	00007797          	auipc	a5,0x7
    80000d6e:	ac07ab23          	sw	zero,-1322(a5) # 80007840 <first.1683>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000d72:	0ff0000f          	fence

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000d76:	00006517          	auipc	a0,0x6
    80000d7a:	3c250513          	addi	a0,a0,962 # 80007138 <etext+0x138>
    80000d7e:	fca43823          	sd	a0,-48(s0)
    80000d82:	fc043c23          	sd	zero,-40(s0)
    80000d86:	fd040593          	addi	a1,s0,-48
    80000d8a:	3f1020ef          	jal	ra,8000397a <kexec>
    80000d8e:	6cbc                	ld	a5,88(s1)
    80000d90:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000d92:	6cbc                	ld	a5,88(s1)
    80000d94:	7bb8                	ld	a4,112(a5)
    80000d96:	57fd                	li	a5,-1
    80000d98:	02f70d63          	beq	a4,a5,80000dd2 <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000d9c:	2a5000ef          	jal	ra,80001840 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000da0:	68a8                	ld	a0,80(s1)
    80000da2:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000da4:	04000737          	lui	a4,0x4000
    80000da8:	00005797          	auipc	a5,0x5
    80000dac:	2f478793          	addi	a5,a5,756 # 8000609c <userret>
    80000db0:	00005697          	auipc	a3,0x5
    80000db4:	25068693          	addi	a3,a3,592 # 80006000 <_trampoline>
    80000db8:	8f95                	sub	a5,a5,a3
    80000dba:	177d                	addi	a4,a4,-1
    80000dbc:	0732                	slli	a4,a4,0xc
    80000dbe:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000dc0:	577d                	li	a4,-1
    80000dc2:	177e                	slli	a4,a4,0x3f
    80000dc4:	8d59                	or	a0,a0,a4
    80000dc6:	9782                	jalr	a5
}
    80000dc8:	70a2                	ld	ra,40(sp)
    80000dca:	7402                	ld	s0,32(sp)
    80000dcc:	64e2                	ld	s1,24(sp)
    80000dce:	6145                	addi	sp,sp,48
    80000dd0:	8082                	ret
      panic("exec");
    80000dd2:	00006517          	auipc	a0,0x6
    80000dd6:	36e50513          	addi	a0,a0,878 # 80007140 <etext+0x140>
    80000dda:	63c040ef          	jal	ra,80005416 <panic>

0000000080000dde <allocpid>:
{
    80000dde:	1101                	addi	sp,sp,-32
    80000de0:	ec06                	sd	ra,24(sp)
    80000de2:	e822                	sd	s0,16(sp)
    80000de4:	e426                	sd	s1,8(sp)
    80000de6:	e04a                	sd	s2,0(sp)
    80000de8:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000dea:	00007917          	auipc	s2,0x7
    80000dee:	ad690913          	addi	s2,s2,-1322 # 800078c0 <pid_lock>
    80000df2:	854a                	mv	a0,s2
    80000df4:	0dd040ef          	jal	ra,800056d0 <acquire>
  pid = nextpid;
    80000df8:	00007797          	auipc	a5,0x7
    80000dfc:	a4c78793          	addi	a5,a5,-1460 # 80007844 <nextpid>
    80000e00:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e02:	0014871b          	addiw	a4,s1,1
    80000e06:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e08:	854a                	mv	a0,s2
    80000e0a:	15f040ef          	jal	ra,80005768 <release>
}
    80000e0e:	8526                	mv	a0,s1
    80000e10:	60e2                	ld	ra,24(sp)
    80000e12:	6442                	ld	s0,16(sp)
    80000e14:	64a2                	ld	s1,8(sp)
    80000e16:	6902                	ld	s2,0(sp)
    80000e18:	6105                	addi	sp,sp,32
    80000e1a:	8082                	ret

0000000080000e1c <proc_pagetable>:
{
    80000e1c:	1101                	addi	sp,sp,-32
    80000e1e:	ec06                	sd	ra,24(sp)
    80000e20:	e822                	sd	s0,16(sp)
    80000e22:	e426                	sd	s1,8(sp)
    80000e24:	e04a                	sd	s2,0(sp)
    80000e26:	1000                	addi	s0,sp,32
    80000e28:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e2a:	80bff0ef          	jal	ra,80000634 <uvmcreate>
    80000e2e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e30:	cd05                	beqz	a0,80000e68 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e32:	4729                	li	a4,10
    80000e34:	00005697          	auipc	a3,0x5
    80000e38:	1cc68693          	addi	a3,a3,460 # 80006000 <_trampoline>
    80000e3c:	6605                	lui	a2,0x1
    80000e3e:	040005b7          	lui	a1,0x4000
    80000e42:	15fd                	addi	a1,a1,-1
    80000e44:	05b2                	slli	a1,a1,0xc
    80000e46:	e48ff0ef          	jal	ra,8000048e <mappages>
    80000e4a:	02054663          	bltz	a0,80000e76 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e4e:	4719                	li	a4,6
    80000e50:	05893683          	ld	a3,88(s2)
    80000e54:	6605                	lui	a2,0x1
    80000e56:	020005b7          	lui	a1,0x2000
    80000e5a:	15fd                	addi	a1,a1,-1
    80000e5c:	05b6                	slli	a1,a1,0xd
    80000e5e:	8526                	mv	a0,s1
    80000e60:	e2eff0ef          	jal	ra,8000048e <mappages>
    80000e64:	00054f63          	bltz	a0,80000e82 <proc_pagetable+0x66>
}
    80000e68:	8526                	mv	a0,s1
    80000e6a:	60e2                	ld	ra,24(sp)
    80000e6c:	6442                	ld	s0,16(sp)
    80000e6e:	64a2                	ld	s1,8(sp)
    80000e70:	6902                	ld	s2,0(sp)
    80000e72:	6105                	addi	sp,sp,32
    80000e74:	8082                	ret
    uvmfree(pagetable, 0);
    80000e76:	4581                	li	a1,0
    80000e78:	8526                	mv	a0,s1
    80000e7a:	9abff0ef          	jal	ra,80000824 <uvmfree>
    return 0;
    80000e7e:	4481                	li	s1,0
    80000e80:	b7e5                	j	80000e68 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e82:	4681                	li	a3,0
    80000e84:	4605                	li	a2,1
    80000e86:	040005b7          	lui	a1,0x4000
    80000e8a:	15fd                	addi	a1,a1,-1
    80000e8c:	05b2                	slli	a1,a1,0xc
    80000e8e:	8526                	mv	a0,s1
    80000e90:	fcaff0ef          	jal	ra,8000065a <uvmunmap>
    uvmfree(pagetable, 0);
    80000e94:	4581                	li	a1,0
    80000e96:	8526                	mv	a0,s1
    80000e98:	98dff0ef          	jal	ra,80000824 <uvmfree>
    return 0;
    80000e9c:	4481                	li	s1,0
    80000e9e:	b7e9                	j	80000e68 <proc_pagetable+0x4c>

0000000080000ea0 <proc_freepagetable>:
{
    80000ea0:	1101                	addi	sp,sp,-32
    80000ea2:	ec06                	sd	ra,24(sp)
    80000ea4:	e822                	sd	s0,16(sp)
    80000ea6:	e426                	sd	s1,8(sp)
    80000ea8:	e04a                	sd	s2,0(sp)
    80000eaa:	1000                	addi	s0,sp,32
    80000eac:	84aa                	mv	s1,a0
    80000eae:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000eb0:	4681                	li	a3,0
    80000eb2:	4605                	li	a2,1
    80000eb4:	040005b7          	lui	a1,0x4000
    80000eb8:	15fd                	addi	a1,a1,-1
    80000eba:	05b2                	slli	a1,a1,0xc
    80000ebc:	f9eff0ef          	jal	ra,8000065a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ec0:	4681                	li	a3,0
    80000ec2:	4605                	li	a2,1
    80000ec4:	020005b7          	lui	a1,0x2000
    80000ec8:	15fd                	addi	a1,a1,-1
    80000eca:	05b6                	slli	a1,a1,0xd
    80000ecc:	8526                	mv	a0,s1
    80000ece:	f8cff0ef          	jal	ra,8000065a <uvmunmap>
  uvmfree(pagetable, sz);
    80000ed2:	85ca                	mv	a1,s2
    80000ed4:	8526                	mv	a0,s1
    80000ed6:	94fff0ef          	jal	ra,80000824 <uvmfree>
}
    80000eda:	60e2                	ld	ra,24(sp)
    80000edc:	6442                	ld	s0,16(sp)
    80000ede:	64a2                	ld	s1,8(sp)
    80000ee0:	6902                	ld	s2,0(sp)
    80000ee2:	6105                	addi	sp,sp,32
    80000ee4:	8082                	ret

0000000080000ee6 <freeproc>:
{
    80000ee6:	1101                	addi	sp,sp,-32
    80000ee8:	ec06                	sd	ra,24(sp)
    80000eea:	e822                	sd	s0,16(sp)
    80000eec:	e426                	sd	s1,8(sp)
    80000eee:	1000                	addi	s0,sp,32
    80000ef0:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000ef2:	6d28                	ld	a0,88(a0)
    80000ef4:	c119                	beqz	a0,80000efa <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000ef6:	926ff0ef          	jal	ra,8000001c <kfree>
  p->trapframe = 0;
    80000efa:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000efe:	68a8                	ld	a0,80(s1)
    80000f00:	c501                	beqz	a0,80000f08 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f02:	64ac                	ld	a1,72(s1)
    80000f04:	f9dff0ef          	jal	ra,80000ea0 <proc_freepagetable>
  p->pagetable = 0;
    80000f08:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f0c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f10:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f14:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f18:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f1c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f20:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f24:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f28:	0004ac23          	sw	zero,24(s1)
}
    80000f2c:	60e2                	ld	ra,24(sp)
    80000f2e:	6442                	ld	s0,16(sp)
    80000f30:	64a2                	ld	s1,8(sp)
    80000f32:	6105                	addi	sp,sp,32
    80000f34:	8082                	ret

0000000080000f36 <allocproc>:
{
    80000f36:	1101                	addi	sp,sp,-32
    80000f38:	ec06                	sd	ra,24(sp)
    80000f3a:	e822                	sd	s0,16(sp)
    80000f3c:	e426                	sd	s1,8(sp)
    80000f3e:	e04a                	sd	s2,0(sp)
    80000f40:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f42:	00007497          	auipc	s1,0x7
    80000f46:	dae48493          	addi	s1,s1,-594 # 80007cf0 <proc>
    80000f4a:	0000c917          	auipc	s2,0xc
    80000f4e:	7a690913          	addi	s2,s2,1958 # 8000d6f0 <tickslock>
    acquire(&p->lock);
    80000f52:	8526                	mv	a0,s1
    80000f54:	77c040ef          	jal	ra,800056d0 <acquire>
    if(p->state == UNUSED) {
    80000f58:	4c9c                	lw	a5,24(s1)
    80000f5a:	cb91                	beqz	a5,80000f6e <allocproc+0x38>
      release(&p->lock);
    80000f5c:	8526                	mv	a0,s1
    80000f5e:	00b040ef          	jal	ra,80005768 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f62:	16848493          	addi	s1,s1,360
    80000f66:	ff2496e3          	bne	s1,s2,80000f52 <allocproc+0x1c>
  return 0;
    80000f6a:	4481                	li	s1,0
    80000f6c:	a089                	j	80000fae <allocproc+0x78>
  p->pid = allocpid();
    80000f6e:	e71ff0ef          	jal	ra,80000dde <allocpid>
    80000f72:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f74:	4785                	li	a5,1
    80000f76:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f78:	97cff0ef          	jal	ra,800000f4 <kalloc>
    80000f7c:	892a                	mv	s2,a0
    80000f7e:	eca8                	sd	a0,88(s1)
    80000f80:	cd15                	beqz	a0,80000fbc <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000f82:	8526                	mv	a0,s1
    80000f84:	e99ff0ef          	jal	ra,80000e1c <proc_pagetable>
    80000f88:	892a                	mv	s2,a0
    80000f8a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f8c:	c121                	beqz	a0,80000fcc <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000f8e:	07000613          	li	a2,112
    80000f92:	4581                	li	a1,0
    80000f94:	06048513          	addi	a0,s1,96
    80000f98:	99aff0ef          	jal	ra,80000132 <memset>
  p->context.ra = (uint64)forkret;
    80000f9c:	00000797          	auipc	a5,0x0
    80000fa0:	daa78793          	addi	a5,a5,-598 # 80000d46 <forkret>
    80000fa4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000fa6:	60bc                	ld	a5,64(s1)
    80000fa8:	6705                	lui	a4,0x1
    80000faa:	97ba                	add	a5,a5,a4
    80000fac:	f4bc                	sd	a5,104(s1)
}
    80000fae:	8526                	mv	a0,s1
    80000fb0:	60e2                	ld	ra,24(sp)
    80000fb2:	6442                	ld	s0,16(sp)
    80000fb4:	64a2                	ld	s1,8(sp)
    80000fb6:	6902                	ld	s2,0(sp)
    80000fb8:	6105                	addi	sp,sp,32
    80000fba:	8082                	ret
    freeproc(p);
    80000fbc:	8526                	mv	a0,s1
    80000fbe:	f29ff0ef          	jal	ra,80000ee6 <freeproc>
    release(&p->lock);
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	7a4040ef          	jal	ra,80005768 <release>
    return 0;
    80000fc8:	84ca                	mv	s1,s2
    80000fca:	b7d5                	j	80000fae <allocproc+0x78>
    freeproc(p);
    80000fcc:	8526                	mv	a0,s1
    80000fce:	f19ff0ef          	jal	ra,80000ee6 <freeproc>
    release(&p->lock);
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	794040ef          	jal	ra,80005768 <release>
    return 0;
    80000fd8:	84ca                	mv	s1,s2
    80000fda:	bfd1                	j	80000fae <allocproc+0x78>

0000000080000fdc <userinit>:
{
    80000fdc:	1101                	addi	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fe6:	f51ff0ef          	jal	ra,80000f36 <allocproc>
    80000fea:	84aa                	mv	s1,a0
  initproc = p;
    80000fec:	00007797          	auipc	a5,0x7
    80000ff0:	88a7ba23          	sd	a0,-1900(a5) # 80007880 <initproc>
  p->cwd = namei("/");
    80000ff4:	00006517          	auipc	a0,0x6
    80000ff8:	15450513          	addi	a0,a0,340 # 80007148 <etext+0x148>
    80000ffc:	5d1010ef          	jal	ra,80002dcc <namei>
    80001000:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001004:	478d                	li	a5,3
    80001006:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001008:	8526                	mv	a0,s1
    8000100a:	75e040ef          	jal	ra,80005768 <release>
}
    8000100e:	60e2                	ld	ra,24(sp)
    80001010:	6442                	ld	s0,16(sp)
    80001012:	64a2                	ld	s1,8(sp)
    80001014:	6105                	addi	sp,sp,32
    80001016:	8082                	ret

0000000080001018 <growproc>:
{
    80001018:	1101                	addi	sp,sp,-32
    8000101a:	ec06                	sd	ra,24(sp)
    8000101c:	e822                	sd	s0,16(sp)
    8000101e:	e426                	sd	s1,8(sp)
    80001020:	e04a                	sd	s2,0(sp)
    80001022:	1000                	addi	s0,sp,32
    80001024:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001026:	cf1ff0ef          	jal	ra,80000d16 <myproc>
    8000102a:	84aa                	mv	s1,a0
  sz = p->sz;
    8000102c:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000102e:	01204c63          	bgtz	s2,80001046 <growproc+0x2e>
  } else if(n < 0){
    80001032:	02094463          	bltz	s2,8000105a <growproc+0x42>
  p->sz = sz;
    80001036:	e4ac                	sd	a1,72(s1)
  return 0;
    80001038:	4501                	li	a0,0
}
    8000103a:	60e2                	ld	ra,24(sp)
    8000103c:	6442                	ld	s0,16(sp)
    8000103e:	64a2                	ld	s1,8(sp)
    80001040:	6902                	ld	s2,0(sp)
    80001042:	6105                	addi	sp,sp,32
    80001044:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001046:	4691                	li	a3,4
    80001048:	00b90633          	add	a2,s2,a1
    8000104c:	6928                	ld	a0,80(a0)
    8000104e:	ee6ff0ef          	jal	ra,80000734 <uvmalloc>
    80001052:	85aa                	mv	a1,a0
    80001054:	f16d                	bnez	a0,80001036 <growproc+0x1e>
      return -1;
    80001056:	557d                	li	a0,-1
    80001058:	b7cd                	j	8000103a <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000105a:	00b90633          	add	a2,s2,a1
    8000105e:	6928                	ld	a0,80(a0)
    80001060:	e90ff0ef          	jal	ra,800006f0 <uvmdealloc>
    80001064:	85aa                	mv	a1,a0
    80001066:	bfc1                	j	80001036 <growproc+0x1e>

0000000080001068 <kfork>:
{
    80001068:	7179                	addi	sp,sp,-48
    8000106a:	f406                	sd	ra,40(sp)
    8000106c:	f022                	sd	s0,32(sp)
    8000106e:	ec26                	sd	s1,24(sp)
    80001070:	e84a                	sd	s2,16(sp)
    80001072:	e44e                	sd	s3,8(sp)
    80001074:	e052                	sd	s4,0(sp)
    80001076:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001078:	c9fff0ef          	jal	ra,80000d16 <myproc>
    8000107c:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000107e:	eb9ff0ef          	jal	ra,80000f36 <allocproc>
    80001082:	0e050563          	beqz	a0,8000116c <kfork+0x104>
    80001086:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001088:	04893603          	ld	a2,72(s2)
    8000108c:	692c                	ld	a1,80(a0)
    8000108e:	05093503          	ld	a0,80(s2)
    80001092:	fc2ff0ef          	jal	ra,80000854 <uvmcopy>
    80001096:	04054663          	bltz	a0,800010e2 <kfork+0x7a>
  np->sz = p->sz;
    8000109a:	04893783          	ld	a5,72(s2)
    8000109e:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800010a2:	05893683          	ld	a3,88(s2)
    800010a6:	87b6                	mv	a5,a3
    800010a8:	0589b703          	ld	a4,88(s3)
    800010ac:	12068693          	addi	a3,a3,288
    800010b0:	0007b803          	ld	a6,0(a5)
    800010b4:	6788                	ld	a0,8(a5)
    800010b6:	6b8c                	ld	a1,16(a5)
    800010b8:	6f90                	ld	a2,24(a5)
    800010ba:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    800010be:	e708                	sd	a0,8(a4)
    800010c0:	eb0c                	sd	a1,16(a4)
    800010c2:	ef10                	sd	a2,24(a4)
    800010c4:	02078793          	addi	a5,a5,32
    800010c8:	02070713          	addi	a4,a4,32
    800010cc:	fed792e3          	bne	a5,a3,800010b0 <kfork+0x48>
  np->trapframe->a0 = 0;
    800010d0:	0589b783          	ld	a5,88(s3)
    800010d4:	0607b823          	sd	zero,112(a5)
    800010d8:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800010dc:	15000a13          	li	s4,336
    800010e0:	a00d                	j	80001102 <kfork+0x9a>
    freeproc(np);
    800010e2:	854e                	mv	a0,s3
    800010e4:	e03ff0ef          	jal	ra,80000ee6 <freeproc>
    release(&np->lock);
    800010e8:	854e                	mv	a0,s3
    800010ea:	67e040ef          	jal	ra,80005768 <release>
    return -1;
    800010ee:	5a7d                	li	s4,-1
    800010f0:	a0ad                	j	8000115a <kfork+0xf2>
      np->ofile[i] = filedup(p->ofile[i]);
    800010f2:	292020ef          	jal	ra,80003384 <filedup>
    800010f6:	009987b3          	add	a5,s3,s1
    800010fa:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800010fc:	04a1                	addi	s1,s1,8
    800010fe:	01448763          	beq	s1,s4,8000110c <kfork+0xa4>
    if(p->ofile[i])
    80001102:	009907b3          	add	a5,s2,s1
    80001106:	6388                	ld	a0,0(a5)
    80001108:	f56d                	bnez	a0,800010f2 <kfork+0x8a>
    8000110a:	bfcd                	j	800010fc <kfork+0x94>
  np->cwd = idup(p->cwd);
    8000110c:	15093503          	ld	a0,336(s2)
    80001110:	498010ef          	jal	ra,800025a8 <idup>
    80001114:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001118:	4641                	li	a2,16
    8000111a:	15890593          	addi	a1,s2,344
    8000111e:	15898513          	addi	a0,s3,344
    80001122:	95eff0ef          	jal	ra,80000280 <safestrcpy>
  pid = np->pid;
    80001126:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000112a:	854e                	mv	a0,s3
    8000112c:	63c040ef          	jal	ra,80005768 <release>
  acquire(&wait_lock);
    80001130:	00006497          	auipc	s1,0x6
    80001134:	7a848493          	addi	s1,s1,1960 # 800078d8 <wait_lock>
    80001138:	8526                	mv	a0,s1
    8000113a:	596040ef          	jal	ra,800056d0 <acquire>
  np->parent = p;
    8000113e:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001142:	8526                	mv	a0,s1
    80001144:	624040ef          	jal	ra,80005768 <release>
  acquire(&np->lock);
    80001148:	854e                	mv	a0,s3
    8000114a:	586040ef          	jal	ra,800056d0 <acquire>
  np->state = RUNNABLE;
    8000114e:	478d                	li	a5,3
    80001150:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001154:	854e                	mv	a0,s3
    80001156:	612040ef          	jal	ra,80005768 <release>
}
    8000115a:	8552                	mv	a0,s4
    8000115c:	70a2                	ld	ra,40(sp)
    8000115e:	7402                	ld	s0,32(sp)
    80001160:	64e2                	ld	s1,24(sp)
    80001162:	6942                	ld	s2,16(sp)
    80001164:	69a2                	ld	s3,8(sp)
    80001166:	6a02                	ld	s4,0(sp)
    80001168:	6145                	addi	sp,sp,48
    8000116a:	8082                	ret
    return -1;
    8000116c:	5a7d                	li	s4,-1
    8000116e:	b7f5                	j	8000115a <kfork+0xf2>

0000000080001170 <scheduler>:
{
    80001170:	715d                	addi	sp,sp,-80
    80001172:	e486                	sd	ra,72(sp)
    80001174:	e0a2                	sd	s0,64(sp)
    80001176:	fc26                	sd	s1,56(sp)
    80001178:	f84a                	sd	s2,48(sp)
    8000117a:	f44e                	sd	s3,40(sp)
    8000117c:	f052                	sd	s4,32(sp)
    8000117e:	ec56                	sd	s5,24(sp)
    80001180:	e85a                	sd	s6,16(sp)
    80001182:	e45e                	sd	s7,8(sp)
    80001184:	e062                	sd	s8,0(sp)
    80001186:	0880                	addi	s0,sp,80
    80001188:	8792                	mv	a5,tp
  int id = r_tp();
    8000118a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000118c:	00779b13          	slli	s6,a5,0x7
    80001190:	00006717          	auipc	a4,0x6
    80001194:	73070713          	addi	a4,a4,1840 # 800078c0 <pid_lock>
    80001198:	975a                	add	a4,a4,s6
    8000119a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000119e:	00006717          	auipc	a4,0x6
    800011a2:	75a70713          	addi	a4,a4,1882 # 800078f8 <cpus+0x8>
    800011a6:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011a8:	4c11                	li	s8,4
        c->proc = p;
    800011aa:	079e                	slli	a5,a5,0x7
    800011ac:	00006a17          	auipc	s4,0x6
    800011b0:	714a0a13          	addi	s4,s4,1812 # 800078c0 <pid_lock>
    800011b4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800011b6:	0000c997          	auipc	s3,0xc
    800011ba:	53a98993          	addi	s3,s3,1338 # 8000d6f0 <tickslock>
        found = 1;
    800011be:	4b85                	li	s7,1
    800011c0:	a83d                	j	800011fe <scheduler+0x8e>
        p->state = RUNNING;
    800011c2:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800011c6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800011ca:	06048593          	addi	a1,s1,96
    800011ce:	855a                	mv	a0,s6
    800011d0:	5ca000ef          	jal	ra,8000179a <swtch>
        c->proc = 0;
    800011d4:	020a3823          	sd	zero,48(s4)
        found = 1;
    800011d8:	8ade                	mv	s5,s7
      release(&p->lock);
    800011da:	8526                	mv	a0,s1
    800011dc:	58c040ef          	jal	ra,80005768 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011e0:	16848493          	addi	s1,s1,360
    800011e4:	01348963          	beq	s1,s3,800011f6 <scheduler+0x86>
      acquire(&p->lock);
    800011e8:	8526                	mv	a0,s1
    800011ea:	4e6040ef          	jal	ra,800056d0 <acquire>
      if(p->state == RUNNABLE) {
    800011ee:	4c9c                	lw	a5,24(s1)
    800011f0:	ff2795e3          	bne	a5,s2,800011da <scheduler+0x6a>
    800011f4:	b7f9                	j	800011c2 <scheduler+0x52>
    if(found == 0) {
    800011f6:	000a9463          	bnez	s5,800011fe <scheduler+0x8e>
      asm volatile("wfi");
    800011fa:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800011fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001202:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001206:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000120a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000120e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001210:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001214:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001216:	00007497          	auipc	s1,0x7
    8000121a:	ada48493          	addi	s1,s1,-1318 # 80007cf0 <proc>
      if(p->state == RUNNABLE) {
    8000121e:	490d                	li	s2,3
    80001220:	b7e1                	j	800011e8 <scheduler+0x78>

0000000080001222 <sched>:
{
    80001222:	7179                	addi	sp,sp,-48
    80001224:	f406                	sd	ra,40(sp)
    80001226:	f022                	sd	s0,32(sp)
    80001228:	ec26                	sd	s1,24(sp)
    8000122a:	e84a                	sd	s2,16(sp)
    8000122c:	e44e                	sd	s3,8(sp)
    8000122e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001230:	ae7ff0ef          	jal	ra,80000d16 <myproc>
    80001234:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001236:	430040ef          	jal	ra,80005666 <holding>
    8000123a:	c92d                	beqz	a0,800012ac <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000123c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000123e:	2781                	sext.w	a5,a5
    80001240:	079e                	slli	a5,a5,0x7
    80001242:	00006717          	auipc	a4,0x6
    80001246:	67e70713          	addi	a4,a4,1662 # 800078c0 <pid_lock>
    8000124a:	97ba                	add	a5,a5,a4
    8000124c:	0a87a703          	lw	a4,168(a5)
    80001250:	4785                	li	a5,1
    80001252:	06f71363          	bne	a4,a5,800012b8 <sched+0x96>
  if(p->state == RUNNING)
    80001256:	4c98                	lw	a4,24(s1)
    80001258:	4791                	li	a5,4
    8000125a:	06f70563          	beq	a4,a5,800012c4 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000125e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001262:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001264:	e7b5                	bnez	a5,800012d0 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001266:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001268:	00006917          	auipc	s2,0x6
    8000126c:	65890913          	addi	s2,s2,1624 # 800078c0 <pid_lock>
    80001270:	2781                	sext.w	a5,a5
    80001272:	079e                	slli	a5,a5,0x7
    80001274:	97ca                	add	a5,a5,s2
    80001276:	0ac7a983          	lw	s3,172(a5)
    8000127a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000127c:	2781                	sext.w	a5,a5
    8000127e:	079e                	slli	a5,a5,0x7
    80001280:	00006597          	auipc	a1,0x6
    80001284:	67858593          	addi	a1,a1,1656 # 800078f8 <cpus+0x8>
    80001288:	95be                	add	a1,a1,a5
    8000128a:	06048513          	addi	a0,s1,96
    8000128e:	50c000ef          	jal	ra,8000179a <swtch>
    80001292:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001294:	2781                	sext.w	a5,a5
    80001296:	079e                	slli	a5,a5,0x7
    80001298:	97ca                	add	a5,a5,s2
    8000129a:	0b37a623          	sw	s3,172(a5)
}
    8000129e:	70a2                	ld	ra,40(sp)
    800012a0:	7402                	ld	s0,32(sp)
    800012a2:	64e2                	ld	s1,24(sp)
    800012a4:	6942                	ld	s2,16(sp)
    800012a6:	69a2                	ld	s3,8(sp)
    800012a8:	6145                	addi	sp,sp,48
    800012aa:	8082                	ret
    panic("sched p->lock");
    800012ac:	00006517          	auipc	a0,0x6
    800012b0:	ea450513          	addi	a0,a0,-348 # 80007150 <etext+0x150>
    800012b4:	162040ef          	jal	ra,80005416 <panic>
    panic("sched locks");
    800012b8:	00006517          	auipc	a0,0x6
    800012bc:	ea850513          	addi	a0,a0,-344 # 80007160 <etext+0x160>
    800012c0:	156040ef          	jal	ra,80005416 <panic>
    panic("sched RUNNING");
    800012c4:	00006517          	auipc	a0,0x6
    800012c8:	eac50513          	addi	a0,a0,-340 # 80007170 <etext+0x170>
    800012cc:	14a040ef          	jal	ra,80005416 <panic>
    panic("sched interruptible");
    800012d0:	00006517          	auipc	a0,0x6
    800012d4:	eb050513          	addi	a0,a0,-336 # 80007180 <etext+0x180>
    800012d8:	13e040ef          	jal	ra,80005416 <panic>

00000000800012dc <yield>:
{
    800012dc:	1101                	addi	sp,sp,-32
    800012de:	ec06                	sd	ra,24(sp)
    800012e0:	e822                	sd	s0,16(sp)
    800012e2:	e426                	sd	s1,8(sp)
    800012e4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800012e6:	a31ff0ef          	jal	ra,80000d16 <myproc>
    800012ea:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800012ec:	3e4040ef          	jal	ra,800056d0 <acquire>
  p->state = RUNNABLE;
    800012f0:	478d                	li	a5,3
    800012f2:	cc9c                	sw	a5,24(s1)
  sched();
    800012f4:	f2fff0ef          	jal	ra,80001222 <sched>
  release(&p->lock);
    800012f8:	8526                	mv	a0,s1
    800012fa:	46e040ef          	jal	ra,80005768 <release>
}
    800012fe:	60e2                	ld	ra,24(sp)
    80001300:	6442                	ld	s0,16(sp)
    80001302:	64a2                	ld	s1,8(sp)
    80001304:	6105                	addi	sp,sp,32
    80001306:	8082                	ret

0000000080001308 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001308:	7179                	addi	sp,sp,-48
    8000130a:	f406                	sd	ra,40(sp)
    8000130c:	f022                	sd	s0,32(sp)
    8000130e:	ec26                	sd	s1,24(sp)
    80001310:	e84a                	sd	s2,16(sp)
    80001312:	e44e                	sd	s3,8(sp)
    80001314:	1800                	addi	s0,sp,48
    80001316:	89aa                	mv	s3,a0
    80001318:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000131a:	9fdff0ef          	jal	ra,80000d16 <myproc>
    8000131e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001320:	3b0040ef          	jal	ra,800056d0 <acquire>
  release(lk);
    80001324:	854a                	mv	a0,s2
    80001326:	442040ef          	jal	ra,80005768 <release>

  // Go to sleep.
  p->chan = chan;
    8000132a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000132e:	4789                	li	a5,2
    80001330:	cc9c                	sw	a5,24(s1)

  sched();
    80001332:	ef1ff0ef          	jal	ra,80001222 <sched>

  // Tidy up.
  p->chan = 0;
    80001336:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000133a:	8526                	mv	a0,s1
    8000133c:	42c040ef          	jal	ra,80005768 <release>
  acquire(lk);
    80001340:	854a                	mv	a0,s2
    80001342:	38e040ef          	jal	ra,800056d0 <acquire>
}
    80001346:	70a2                	ld	ra,40(sp)
    80001348:	7402                	ld	s0,32(sp)
    8000134a:	64e2                	ld	s1,24(sp)
    8000134c:	6942                	ld	s2,16(sp)
    8000134e:	69a2                	ld	s3,8(sp)
    80001350:	6145                	addi	sp,sp,48
    80001352:	8082                	ret

0000000080001354 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001354:	7139                	addi	sp,sp,-64
    80001356:	fc06                	sd	ra,56(sp)
    80001358:	f822                	sd	s0,48(sp)
    8000135a:	f426                	sd	s1,40(sp)
    8000135c:	f04a                	sd	s2,32(sp)
    8000135e:	ec4e                	sd	s3,24(sp)
    80001360:	e852                	sd	s4,16(sp)
    80001362:	e456                	sd	s5,8(sp)
    80001364:	0080                	addi	s0,sp,64
    80001366:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001368:	00007497          	auipc	s1,0x7
    8000136c:	98848493          	addi	s1,s1,-1656 # 80007cf0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001370:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001372:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001374:	0000c917          	auipc	s2,0xc
    80001378:	37c90913          	addi	s2,s2,892 # 8000d6f0 <tickslock>
    8000137c:	a811                	j	80001390 <wakeup+0x3c>
        p->state = RUNNABLE;
    8000137e:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001382:	8526                	mv	a0,s1
    80001384:	3e4040ef          	jal	ra,80005768 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001388:	16848493          	addi	s1,s1,360
    8000138c:	03248063          	beq	s1,s2,800013ac <wakeup+0x58>
    if(p != myproc()){
    80001390:	987ff0ef          	jal	ra,80000d16 <myproc>
    80001394:	fea48ae3          	beq	s1,a0,80001388 <wakeup+0x34>
      acquire(&p->lock);
    80001398:	8526                	mv	a0,s1
    8000139a:	336040ef          	jal	ra,800056d0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000139e:	4c9c                	lw	a5,24(s1)
    800013a0:	ff3791e3          	bne	a5,s3,80001382 <wakeup+0x2e>
    800013a4:	709c                	ld	a5,32(s1)
    800013a6:	fd479ee3          	bne	a5,s4,80001382 <wakeup+0x2e>
    800013aa:	bfd1                	j	8000137e <wakeup+0x2a>
    }
  }
}
    800013ac:	70e2                	ld	ra,56(sp)
    800013ae:	7442                	ld	s0,48(sp)
    800013b0:	74a2                	ld	s1,40(sp)
    800013b2:	7902                	ld	s2,32(sp)
    800013b4:	69e2                	ld	s3,24(sp)
    800013b6:	6a42                	ld	s4,16(sp)
    800013b8:	6aa2                	ld	s5,8(sp)
    800013ba:	6121                	addi	sp,sp,64
    800013bc:	8082                	ret

00000000800013be <reparent>:
{
    800013be:	7179                	addi	sp,sp,-48
    800013c0:	f406                	sd	ra,40(sp)
    800013c2:	f022                	sd	s0,32(sp)
    800013c4:	ec26                	sd	s1,24(sp)
    800013c6:	e84a                	sd	s2,16(sp)
    800013c8:	e44e                	sd	s3,8(sp)
    800013ca:	e052                	sd	s4,0(sp)
    800013cc:	1800                	addi	s0,sp,48
    800013ce:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013d0:	00007497          	auipc	s1,0x7
    800013d4:	92048493          	addi	s1,s1,-1760 # 80007cf0 <proc>
      pp->parent = initproc;
    800013d8:	00006a17          	auipc	s4,0x6
    800013dc:	4a8a0a13          	addi	s4,s4,1192 # 80007880 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013e0:	0000c997          	auipc	s3,0xc
    800013e4:	31098993          	addi	s3,s3,784 # 8000d6f0 <tickslock>
    800013e8:	a029                	j	800013f2 <reparent+0x34>
    800013ea:	16848493          	addi	s1,s1,360
    800013ee:	01348b63          	beq	s1,s3,80001404 <reparent+0x46>
    if(pp->parent == p){
    800013f2:	7c9c                	ld	a5,56(s1)
    800013f4:	ff279be3          	bne	a5,s2,800013ea <reparent+0x2c>
      pp->parent = initproc;
    800013f8:	000a3503          	ld	a0,0(s4)
    800013fc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800013fe:	f57ff0ef          	jal	ra,80001354 <wakeup>
    80001402:	b7e5                	j	800013ea <reparent+0x2c>
}
    80001404:	70a2                	ld	ra,40(sp)
    80001406:	7402                	ld	s0,32(sp)
    80001408:	64e2                	ld	s1,24(sp)
    8000140a:	6942                	ld	s2,16(sp)
    8000140c:	69a2                	ld	s3,8(sp)
    8000140e:	6a02                	ld	s4,0(sp)
    80001410:	6145                	addi	sp,sp,48
    80001412:	8082                	ret

0000000080001414 <kexit>:
{
    80001414:	7179                	addi	sp,sp,-48
    80001416:	f406                	sd	ra,40(sp)
    80001418:	f022                	sd	s0,32(sp)
    8000141a:	ec26                	sd	s1,24(sp)
    8000141c:	e84a                	sd	s2,16(sp)
    8000141e:	e44e                	sd	s3,8(sp)
    80001420:	e052                	sd	s4,0(sp)
    80001422:	1800                	addi	s0,sp,48
    80001424:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001426:	8f1ff0ef          	jal	ra,80000d16 <myproc>
    8000142a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000142c:	00006797          	auipc	a5,0x6
    80001430:	4547b783          	ld	a5,1108(a5) # 80007880 <initproc>
    80001434:	0d050493          	addi	s1,a0,208
    80001438:	15050913          	addi	s2,a0,336
    8000143c:	00a79f63          	bne	a5,a0,8000145a <kexit+0x46>
    panic("init exiting");
    80001440:	00006517          	auipc	a0,0x6
    80001444:	d5850513          	addi	a0,a0,-680 # 80007198 <etext+0x198>
    80001448:	7cf030ef          	jal	ra,80005416 <panic>
      fileclose(f);
    8000144c:	77f010ef          	jal	ra,800033ca <fileclose>
      p->ofile[fd] = 0;
    80001450:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001454:	04a1                	addi	s1,s1,8
    80001456:	01248563          	beq	s1,s2,80001460 <kexit+0x4c>
    if(p->ofile[fd]){
    8000145a:	6088                	ld	a0,0(s1)
    8000145c:	f965                	bnez	a0,8000144c <kexit+0x38>
    8000145e:	bfdd                	j	80001454 <kexit+0x40>
  begin_op();
    80001460:	35d010ef          	jal	ra,80002fbc <begin_op>
  iput(p->cwd);
    80001464:	1509b503          	ld	a0,336(s3)
    80001468:	2f4010ef          	jal	ra,8000275c <iput>
  end_op();
    8000146c:	3c1010ef          	jal	ra,8000302c <end_op>
  p->cwd = 0;
    80001470:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001474:	00006497          	auipc	s1,0x6
    80001478:	46448493          	addi	s1,s1,1124 # 800078d8 <wait_lock>
    8000147c:	8526                	mv	a0,s1
    8000147e:	252040ef          	jal	ra,800056d0 <acquire>
  reparent(p);
    80001482:	854e                	mv	a0,s3
    80001484:	f3bff0ef          	jal	ra,800013be <reparent>
  wakeup(p->parent);
    80001488:	0389b503          	ld	a0,56(s3)
    8000148c:	ec9ff0ef          	jal	ra,80001354 <wakeup>
  acquire(&p->lock);
    80001490:	854e                	mv	a0,s3
    80001492:	23e040ef          	jal	ra,800056d0 <acquire>
  p->xstate = status;
    80001496:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000149a:	4795                	li	a5,5
    8000149c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014a0:	8526                	mv	a0,s1
    800014a2:	2c6040ef          	jal	ra,80005768 <release>
  sched();
    800014a6:	d7dff0ef          	jal	ra,80001222 <sched>
  panic("zombie exit");
    800014aa:	00006517          	auipc	a0,0x6
    800014ae:	cfe50513          	addi	a0,a0,-770 # 800071a8 <etext+0x1a8>
    800014b2:	765030ef          	jal	ra,80005416 <panic>

00000000800014b6 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800014b6:	7179                	addi	sp,sp,-48
    800014b8:	f406                	sd	ra,40(sp)
    800014ba:	f022                	sd	s0,32(sp)
    800014bc:	ec26                	sd	s1,24(sp)
    800014be:	e84a                	sd	s2,16(sp)
    800014c0:	e44e                	sd	s3,8(sp)
    800014c2:	1800                	addi	s0,sp,48
    800014c4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014c6:	00007497          	auipc	s1,0x7
    800014ca:	82a48493          	addi	s1,s1,-2006 # 80007cf0 <proc>
    800014ce:	0000c997          	auipc	s3,0xc
    800014d2:	22298993          	addi	s3,s3,546 # 8000d6f0 <tickslock>
    acquire(&p->lock);
    800014d6:	8526                	mv	a0,s1
    800014d8:	1f8040ef          	jal	ra,800056d0 <acquire>
    if(p->pid == pid){
    800014dc:	589c                	lw	a5,48(s1)
    800014de:	01278b63          	beq	a5,s2,800014f4 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800014e2:	8526                	mv	a0,s1
    800014e4:	284040ef          	jal	ra,80005768 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800014e8:	16848493          	addi	s1,s1,360
    800014ec:	ff3495e3          	bne	s1,s3,800014d6 <kkill+0x20>
  }
  return -1;
    800014f0:	557d                	li	a0,-1
    800014f2:	a819                	j	80001508 <kkill+0x52>
      p->killed = 1;
    800014f4:	4785                	li	a5,1
    800014f6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800014f8:	4c98                	lw	a4,24(s1)
    800014fa:	4789                	li	a5,2
    800014fc:	00f70d63          	beq	a4,a5,80001516 <kkill+0x60>
      release(&p->lock);
    80001500:	8526                	mv	a0,s1
    80001502:	266040ef          	jal	ra,80005768 <release>
      return 0;
    80001506:	4501                	li	a0,0
}
    80001508:	70a2                	ld	ra,40(sp)
    8000150a:	7402                	ld	s0,32(sp)
    8000150c:	64e2                	ld	s1,24(sp)
    8000150e:	6942                	ld	s2,16(sp)
    80001510:	69a2                	ld	s3,8(sp)
    80001512:	6145                	addi	sp,sp,48
    80001514:	8082                	ret
        p->state = RUNNABLE;
    80001516:	478d                	li	a5,3
    80001518:	cc9c                	sw	a5,24(s1)
    8000151a:	b7dd                	j	80001500 <kkill+0x4a>

000000008000151c <setkilled>:

void
setkilled(struct proc *p)
{
    8000151c:	1101                	addi	sp,sp,-32
    8000151e:	ec06                	sd	ra,24(sp)
    80001520:	e822                	sd	s0,16(sp)
    80001522:	e426                	sd	s1,8(sp)
    80001524:	1000                	addi	s0,sp,32
    80001526:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001528:	1a8040ef          	jal	ra,800056d0 <acquire>
  p->killed = 1;
    8000152c:	4785                	li	a5,1
    8000152e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001530:	8526                	mv	a0,s1
    80001532:	236040ef          	jal	ra,80005768 <release>
}
    80001536:	60e2                	ld	ra,24(sp)
    80001538:	6442                	ld	s0,16(sp)
    8000153a:	64a2                	ld	s1,8(sp)
    8000153c:	6105                	addi	sp,sp,32
    8000153e:	8082                	ret

0000000080001540 <killed>:

int
killed(struct proc *p)
{
    80001540:	1101                	addi	sp,sp,-32
    80001542:	ec06                	sd	ra,24(sp)
    80001544:	e822                	sd	s0,16(sp)
    80001546:	e426                	sd	s1,8(sp)
    80001548:	e04a                	sd	s2,0(sp)
    8000154a:	1000                	addi	s0,sp,32
    8000154c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000154e:	182040ef          	jal	ra,800056d0 <acquire>
  k = p->killed;
    80001552:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001556:	8526                	mv	a0,s1
    80001558:	210040ef          	jal	ra,80005768 <release>
  return k;
}
    8000155c:	854a                	mv	a0,s2
    8000155e:	60e2                	ld	ra,24(sp)
    80001560:	6442                	ld	s0,16(sp)
    80001562:	64a2                	ld	s1,8(sp)
    80001564:	6902                	ld	s2,0(sp)
    80001566:	6105                	addi	sp,sp,32
    80001568:	8082                	ret

000000008000156a <kwait>:
{
    8000156a:	715d                	addi	sp,sp,-80
    8000156c:	e486                	sd	ra,72(sp)
    8000156e:	e0a2                	sd	s0,64(sp)
    80001570:	fc26                	sd	s1,56(sp)
    80001572:	f84a                	sd	s2,48(sp)
    80001574:	f44e                	sd	s3,40(sp)
    80001576:	f052                	sd	s4,32(sp)
    80001578:	ec56                	sd	s5,24(sp)
    8000157a:	e85a                	sd	s6,16(sp)
    8000157c:	e45e                	sd	s7,8(sp)
    8000157e:	e062                	sd	s8,0(sp)
    80001580:	0880                	addi	s0,sp,80
    80001582:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001584:	f92ff0ef          	jal	ra,80000d16 <myproc>
    80001588:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000158a:	00006517          	auipc	a0,0x6
    8000158e:	34e50513          	addi	a0,a0,846 # 800078d8 <wait_lock>
    80001592:	13e040ef          	jal	ra,800056d0 <acquire>
    havekids = 0;
    80001596:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001598:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000159a:	0000c997          	auipc	s3,0xc
    8000159e:	15698993          	addi	s3,s3,342 # 8000d6f0 <tickslock>
        havekids = 1;
    800015a2:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015a4:	00006c17          	auipc	s8,0x6
    800015a8:	334c0c13          	addi	s8,s8,820 # 800078d8 <wait_lock>
    havekids = 0;
    800015ac:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015ae:	00006497          	auipc	s1,0x6
    800015b2:	74248493          	addi	s1,s1,1858 # 80007cf0 <proc>
    800015b6:	a899                	j	8000160c <kwait+0xa2>
          pid = pp->pid;
    800015b8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015bc:	000b0c63          	beqz	s6,800015d4 <kwait+0x6a>
    800015c0:	4691                	li	a3,4
    800015c2:	02c48613          	addi	a2,s1,44
    800015c6:	85da                	mv	a1,s6
    800015c8:	05093503          	ld	a0,80(s2)
    800015cc:	c92ff0ef          	jal	ra,80000a5e <copyout>
    800015d0:	00054f63          	bltz	a0,800015ee <kwait+0x84>
          freeproc(pp);
    800015d4:	8526                	mv	a0,s1
    800015d6:	911ff0ef          	jal	ra,80000ee6 <freeproc>
          release(&pp->lock);
    800015da:	8526                	mv	a0,s1
    800015dc:	18c040ef          	jal	ra,80005768 <release>
          release(&wait_lock);
    800015e0:	00006517          	auipc	a0,0x6
    800015e4:	2f850513          	addi	a0,a0,760 # 800078d8 <wait_lock>
    800015e8:	180040ef          	jal	ra,80005768 <release>
          return pid;
    800015ec:	a891                	j	80001640 <kwait+0xd6>
            release(&pp->lock);
    800015ee:	8526                	mv	a0,s1
    800015f0:	178040ef          	jal	ra,80005768 <release>
            release(&wait_lock);
    800015f4:	00006517          	auipc	a0,0x6
    800015f8:	2e450513          	addi	a0,a0,740 # 800078d8 <wait_lock>
    800015fc:	16c040ef          	jal	ra,80005768 <release>
            return -1;
    80001600:	59fd                	li	s3,-1
    80001602:	a83d                	j	80001640 <kwait+0xd6>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001604:	16848493          	addi	s1,s1,360
    80001608:	03348063          	beq	s1,s3,80001628 <kwait+0xbe>
      if(pp->parent == p){
    8000160c:	7c9c                	ld	a5,56(s1)
    8000160e:	ff279be3          	bne	a5,s2,80001604 <kwait+0x9a>
        acquire(&pp->lock);
    80001612:	8526                	mv	a0,s1
    80001614:	0bc040ef          	jal	ra,800056d0 <acquire>
        if(pp->state == ZOMBIE){
    80001618:	4c9c                	lw	a5,24(s1)
    8000161a:	f9478fe3          	beq	a5,s4,800015b8 <kwait+0x4e>
        release(&pp->lock);
    8000161e:	8526                	mv	a0,s1
    80001620:	148040ef          	jal	ra,80005768 <release>
        havekids = 1;
    80001624:	8756                	mv	a4,s5
    80001626:	bff9                	j	80001604 <kwait+0x9a>
    if(!havekids || killed(p)){
    80001628:	c709                	beqz	a4,80001632 <kwait+0xc8>
    8000162a:	854a                	mv	a0,s2
    8000162c:	f15ff0ef          	jal	ra,80001540 <killed>
    80001630:	c50d                	beqz	a0,8000165a <kwait+0xf0>
      release(&wait_lock);
    80001632:	00006517          	auipc	a0,0x6
    80001636:	2a650513          	addi	a0,a0,678 # 800078d8 <wait_lock>
    8000163a:	12e040ef          	jal	ra,80005768 <release>
      return -1;
    8000163e:	59fd                	li	s3,-1
}
    80001640:	854e                	mv	a0,s3
    80001642:	60a6                	ld	ra,72(sp)
    80001644:	6406                	ld	s0,64(sp)
    80001646:	74e2                	ld	s1,56(sp)
    80001648:	7942                	ld	s2,48(sp)
    8000164a:	79a2                	ld	s3,40(sp)
    8000164c:	7a02                	ld	s4,32(sp)
    8000164e:	6ae2                	ld	s5,24(sp)
    80001650:	6b42                	ld	s6,16(sp)
    80001652:	6ba2                	ld	s7,8(sp)
    80001654:	6c02                	ld	s8,0(sp)
    80001656:	6161                	addi	sp,sp,80
    80001658:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000165a:	85e2                	mv	a1,s8
    8000165c:	854a                	mv	a0,s2
    8000165e:	cabff0ef          	jal	ra,80001308 <sleep>
    havekids = 0;
    80001662:	b7a9                	j	800015ac <kwait+0x42>

0000000080001664 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001664:	7179                	addi	sp,sp,-48
    80001666:	f406                	sd	ra,40(sp)
    80001668:	f022                	sd	s0,32(sp)
    8000166a:	ec26                	sd	s1,24(sp)
    8000166c:	e84a                	sd	s2,16(sp)
    8000166e:	e44e                	sd	s3,8(sp)
    80001670:	e052                	sd	s4,0(sp)
    80001672:	1800                	addi	s0,sp,48
    80001674:	84aa                	mv	s1,a0
    80001676:	892e                	mv	s2,a1
    80001678:	89b2                	mv	s3,a2
    8000167a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000167c:	e9aff0ef          	jal	ra,80000d16 <myproc>
  if(user_dst){
    80001680:	cc99                	beqz	s1,8000169e <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001682:	86d2                	mv	a3,s4
    80001684:	864e                	mv	a2,s3
    80001686:	85ca                	mv	a1,s2
    80001688:	6928                	ld	a0,80(a0)
    8000168a:	bd4ff0ef          	jal	ra,80000a5e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000168e:	70a2                	ld	ra,40(sp)
    80001690:	7402                	ld	s0,32(sp)
    80001692:	64e2                	ld	s1,24(sp)
    80001694:	6942                	ld	s2,16(sp)
    80001696:	69a2                	ld	s3,8(sp)
    80001698:	6a02                	ld	s4,0(sp)
    8000169a:	6145                	addi	sp,sp,48
    8000169c:	8082                	ret
    memmove((char *)dst, src, len);
    8000169e:	000a061b          	sext.w	a2,s4
    800016a2:	85ce                	mv	a1,s3
    800016a4:	854a                	mv	a0,s2
    800016a6:	aedfe0ef          	jal	ra,80000192 <memmove>
    return 0;
    800016aa:	8526                	mv	a0,s1
    800016ac:	b7cd                	j	8000168e <either_copyout+0x2a>

00000000800016ae <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016ae:	7179                	addi	sp,sp,-48
    800016b0:	f406                	sd	ra,40(sp)
    800016b2:	f022                	sd	s0,32(sp)
    800016b4:	ec26                	sd	s1,24(sp)
    800016b6:	e84a                	sd	s2,16(sp)
    800016b8:	e44e                	sd	s3,8(sp)
    800016ba:	e052                	sd	s4,0(sp)
    800016bc:	1800                	addi	s0,sp,48
    800016be:	892a                	mv	s2,a0
    800016c0:	84ae                	mv	s1,a1
    800016c2:	89b2                	mv	s3,a2
    800016c4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016c6:	e50ff0ef          	jal	ra,80000d16 <myproc>
  if(user_src){
    800016ca:	cc99                	beqz	s1,800016e8 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800016cc:	86d2                	mv	a3,s4
    800016ce:	864e                	mv	a2,s3
    800016d0:	85ca                	mv	a1,s2
    800016d2:	6928                	ld	a0,80(a0)
    800016d4:	c56ff0ef          	jal	ra,80000b2a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800016d8:	70a2                	ld	ra,40(sp)
    800016da:	7402                	ld	s0,32(sp)
    800016dc:	64e2                	ld	s1,24(sp)
    800016de:	6942                	ld	s2,16(sp)
    800016e0:	69a2                	ld	s3,8(sp)
    800016e2:	6a02                	ld	s4,0(sp)
    800016e4:	6145                	addi	sp,sp,48
    800016e6:	8082                	ret
    memmove(dst, (char*)src, len);
    800016e8:	000a061b          	sext.w	a2,s4
    800016ec:	85ce                	mv	a1,s3
    800016ee:	854a                	mv	a0,s2
    800016f0:	aa3fe0ef          	jal	ra,80000192 <memmove>
    return 0;
    800016f4:	8526                	mv	a0,s1
    800016f6:	b7cd                	j	800016d8 <either_copyin+0x2a>

00000000800016f8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800016f8:	715d                	addi	sp,sp,-80
    800016fa:	e486                	sd	ra,72(sp)
    800016fc:	e0a2                	sd	s0,64(sp)
    800016fe:	fc26                	sd	s1,56(sp)
    80001700:	f84a                	sd	s2,48(sp)
    80001702:	f44e                	sd	s3,40(sp)
    80001704:	f052                	sd	s4,32(sp)
    80001706:	ec56                	sd	s5,24(sp)
    80001708:	e85a                	sd	s6,16(sp)
    8000170a:	e45e                	sd	s7,8(sp)
    8000170c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000170e:	00006517          	auipc	a0,0x6
    80001712:	93a50513          	addi	a0,a0,-1734 # 80007048 <etext+0x48>
    80001716:	23b030ef          	jal	ra,80005150 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000171a:	00006497          	auipc	s1,0x6
    8000171e:	72e48493          	addi	s1,s1,1838 # 80007e48 <proc+0x158>
    80001722:	0000c917          	auipc	s2,0xc
    80001726:	12690913          	addi	s2,s2,294 # 8000d848 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000172a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000172c:	00006997          	auipc	s3,0x6
    80001730:	a8c98993          	addi	s3,s3,-1396 # 800071b8 <etext+0x1b8>
    printf("%d %s %s", p->pid, state, p->name);
    80001734:	00006a97          	auipc	s5,0x6
    80001738:	a8ca8a93          	addi	s5,s5,-1396 # 800071c0 <etext+0x1c0>
    printf("\n");
    8000173c:	00006a17          	auipc	s4,0x6
    80001740:	90ca0a13          	addi	s4,s4,-1780 # 80007048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001744:	00006b97          	auipc	s7,0x6
    80001748:	abcb8b93          	addi	s7,s7,-1348 # 80007200 <states.1733>
    8000174c:	a829                	j	80001766 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000174e:	ed86a583          	lw	a1,-296(a3)
    80001752:	8556                	mv	a0,s5
    80001754:	1fd030ef          	jal	ra,80005150 <printf>
    printf("\n");
    80001758:	8552                	mv	a0,s4
    8000175a:	1f7030ef          	jal	ra,80005150 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000175e:	16848493          	addi	s1,s1,360
    80001762:	03248163          	beq	s1,s2,80001784 <procdump+0x8c>
    if(p->state == UNUSED)
    80001766:	86a6                	mv	a3,s1
    80001768:	ec04a783          	lw	a5,-320(s1)
    8000176c:	dbed                	beqz	a5,8000175e <procdump+0x66>
      state = "???";
    8000176e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001770:	fcfb6fe3          	bltu	s6,a5,8000174e <procdump+0x56>
    80001774:	1782                	slli	a5,a5,0x20
    80001776:	9381                	srli	a5,a5,0x20
    80001778:	078e                	slli	a5,a5,0x3
    8000177a:	97de                	add	a5,a5,s7
    8000177c:	6390                	ld	a2,0(a5)
    8000177e:	fa61                	bnez	a2,8000174e <procdump+0x56>
      state = "???";
    80001780:	864e                	mv	a2,s3
    80001782:	b7f1                	j	8000174e <procdump+0x56>
  }
}
    80001784:	60a6                	ld	ra,72(sp)
    80001786:	6406                	ld	s0,64(sp)
    80001788:	74e2                	ld	s1,56(sp)
    8000178a:	7942                	ld	s2,48(sp)
    8000178c:	79a2                	ld	s3,40(sp)
    8000178e:	7a02                	ld	s4,32(sp)
    80001790:	6ae2                	ld	s5,24(sp)
    80001792:	6b42                	ld	s6,16(sp)
    80001794:	6ba2                	ld	s7,8(sp)
    80001796:	6161                	addi	sp,sp,80
    80001798:	8082                	ret

000000008000179a <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    8000179a:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    8000179e:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800017a2:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800017a4:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800017a6:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800017aa:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800017ae:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800017b2:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800017b6:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800017ba:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800017be:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800017c2:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800017c6:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800017ca:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800017ce:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800017d2:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800017d6:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800017d8:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800017da:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    800017de:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    800017e2:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    800017e6:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    800017ea:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    800017ee:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    800017f2:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    800017f6:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    800017fa:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800017fe:	0685bd83          	ld	s11,104(a1)
        
        ret
    80001802:	8082                	ret

0000000080001804 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001804:	1141                	addi	sp,sp,-16
    80001806:	e406                	sd	ra,8(sp)
    80001808:	e022                	sd	s0,0(sp)
    8000180a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000180c:	00006597          	auipc	a1,0x6
    80001810:	a2458593          	addi	a1,a1,-1500 # 80007230 <states.1733+0x30>
    80001814:	0000c517          	auipc	a0,0xc
    80001818:	edc50513          	addi	a0,a0,-292 # 8000d6f0 <tickslock>
    8000181c:	635030ef          	jal	ra,80005650 <initlock>
}
    80001820:	60a2                	ld	ra,8(sp)
    80001822:	6402                	ld	s0,0(sp)
    80001824:	0141                	addi	sp,sp,16
    80001826:	8082                	ret

0000000080001828 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001828:	1141                	addi	sp,sp,-16
    8000182a:	e422                	sd	s0,8(sp)
    8000182c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000182e:	00003797          	auipc	a5,0x3
    80001832:	e4278793          	addi	a5,a5,-446 # 80004670 <kernelvec>
    80001836:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000183a:	6422                	ld	s0,8(sp)
    8000183c:	0141                	addi	sp,sp,16
    8000183e:	8082                	ret

0000000080001840 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80001840:	1141                	addi	sp,sp,-16
    80001842:	e406                	sd	ra,8(sp)
    80001844:	e022                	sd	s0,0(sp)
    80001846:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001848:	cceff0ef          	jal	ra,80000d16 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000184c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001850:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001852:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001856:	04000737          	lui	a4,0x4000
    8000185a:	00004797          	auipc	a5,0x4
    8000185e:	7a678793          	addi	a5,a5,1958 # 80006000 <_trampoline>
    80001862:	00004697          	auipc	a3,0x4
    80001866:	79e68693          	addi	a3,a3,1950 # 80006000 <_trampoline>
    8000186a:	8f95                	sub	a5,a5,a3
    8000186c:	177d                	addi	a4,a4,-1
    8000186e:	0732                	slli	a4,a4,0xc
    80001870:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001872:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001876:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001878:	18002773          	csrr	a4,satp
    8000187c:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000187e:	6d38                	ld	a4,88(a0)
    80001880:	613c                	ld	a5,64(a0)
    80001882:	6685                	lui	a3,0x1
    80001884:	97b6                	add	a5,a5,a3
    80001886:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001888:	6d3c                	ld	a5,88(a0)
    8000188a:	00000717          	auipc	a4,0x0
    8000188e:	0f470713          	addi	a4,a4,244 # 8000197e <usertrap>
    80001892:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001894:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001896:	8712                	mv	a4,tp
    80001898:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000189a:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000189e:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800018a2:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018a6:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800018aa:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800018ac:	6f9c                	ld	a5,24(a5)
    800018ae:	14179073          	csrw	sepc,a5
}
    800018b2:	60a2                	ld	ra,8(sp)
    800018b4:	6402                	ld	s0,0(sp)
    800018b6:	0141                	addi	sp,sp,16
    800018b8:	8082                	ret

00000000800018ba <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800018ba:	1101                	addi	sp,sp,-32
    800018bc:	ec06                	sd	ra,24(sp)
    800018be:	e822                	sd	s0,16(sp)
    800018c0:	e426                	sd	s1,8(sp)
    800018c2:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800018c4:	c26ff0ef          	jal	ra,80000cea <cpuid>
    800018c8:	cd19                	beqz	a0,800018e6 <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    800018ca:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800018ce:	000f4737          	lui	a4,0xf4
    800018d2:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800018d6:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800018d8:	14d79073          	csrw	0x14d,a5
}
    800018dc:	60e2                	ld	ra,24(sp)
    800018de:	6442                	ld	s0,16(sp)
    800018e0:	64a2                	ld	s1,8(sp)
    800018e2:	6105                	addi	sp,sp,32
    800018e4:	8082                	ret
    acquire(&tickslock);
    800018e6:	0000c497          	auipc	s1,0xc
    800018ea:	e0a48493          	addi	s1,s1,-502 # 8000d6f0 <tickslock>
    800018ee:	8526                	mv	a0,s1
    800018f0:	5e1030ef          	jal	ra,800056d0 <acquire>
    ticks++;
    800018f4:	00006517          	auipc	a0,0x6
    800018f8:	f9450513          	addi	a0,a0,-108 # 80007888 <ticks>
    800018fc:	411c                	lw	a5,0(a0)
    800018fe:	2785                	addiw	a5,a5,1
    80001900:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001902:	a53ff0ef          	jal	ra,80001354 <wakeup>
    release(&tickslock);
    80001906:	8526                	mv	a0,s1
    80001908:	661030ef          	jal	ra,80005768 <release>
    8000190c:	bf7d                	j	800018ca <clockintr+0x10>

000000008000190e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000190e:	1101                	addi	sp,sp,-32
    80001910:	ec06                	sd	ra,24(sp)
    80001912:	e822                	sd	s0,16(sp)
    80001914:	e426                	sd	s1,8(sp)
    80001916:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001918:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000191c:	57fd                	li	a5,-1
    8000191e:	17fe                	slli	a5,a5,0x3f
    80001920:	07a5                	addi	a5,a5,9
    80001922:	00f70d63          	beq	a4,a5,8000193c <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001926:	57fd                	li	a5,-1
    80001928:	17fe                	slli	a5,a5,0x3f
    8000192a:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000192c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000192e:	04f70463          	beq	a4,a5,80001976 <devintr+0x68>
  }
}
    80001932:	60e2                	ld	ra,24(sp)
    80001934:	6442                	ld	s0,16(sp)
    80001936:	64a2                	ld	s1,8(sp)
    80001938:	6105                	addi	sp,sp,32
    8000193a:	8082                	ret
    int irq = plic_claim();
    8000193c:	5dd020ef          	jal	ra,80004718 <plic_claim>
    80001940:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001942:	47a9                	li	a5,10
    80001944:	02f50363          	beq	a0,a5,8000196a <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    80001948:	4785                	li	a5,1
    8000194a:	02f50363          	beq	a0,a5,80001970 <devintr+0x62>
    return 1;
    8000194e:	4505                	li	a0,1
    } else if(irq){
    80001950:	d0ed                	beqz	s1,80001932 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80001952:	85a6                	mv	a1,s1
    80001954:	00006517          	auipc	a0,0x6
    80001958:	8e450513          	addi	a0,a0,-1820 # 80007238 <states.1733+0x38>
    8000195c:	7f4030ef          	jal	ra,80005150 <printf>
      plic_complete(irq);
    80001960:	8526                	mv	a0,s1
    80001962:	5d7020ef          	jal	ra,80004738 <plic_complete>
    return 1;
    80001966:	4505                	li	a0,1
    80001968:	b7e9                	j	80001932 <devintr+0x24>
      uartintr();
    8000196a:	47f030ef          	jal	ra,800055e8 <uartintr>
    8000196e:	bfcd                	j	80001960 <devintr+0x52>
      virtio_disk_intr();
    80001970:	28e030ef          	jal	ra,80004bfe <virtio_disk_intr>
    80001974:	b7f5                	j	80001960 <devintr+0x52>
    clockintr();
    80001976:	f45ff0ef          	jal	ra,800018ba <clockintr>
    return 2;
    8000197a:	4509                	li	a0,2
    8000197c:	bf5d                	j	80001932 <devintr+0x24>

000000008000197e <usertrap>:
{
    8000197e:	1101                	addi	sp,sp,-32
    80001980:	ec06                	sd	ra,24(sp)
    80001982:	e822                	sd	s0,16(sp)
    80001984:	e426                	sd	s1,8(sp)
    80001986:	e04a                	sd	s2,0(sp)
    80001988:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000198a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000198e:	1007f793          	andi	a5,a5,256
    80001992:	eba5                	bnez	a5,80001a02 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001994:	00003797          	auipc	a5,0x3
    80001998:	cdc78793          	addi	a5,a5,-804 # 80004670 <kernelvec>
    8000199c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800019a0:	b76ff0ef          	jal	ra,80000d16 <myproc>
    800019a4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800019a6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800019a8:	14102773          	csrr	a4,sepc
    800019ac:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019ae:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800019b2:	47a1                	li	a5,8
    800019b4:	04f70d63          	beq	a4,a5,80001a0e <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    800019b8:	f57ff0ef          	jal	ra,8000190e <devintr>
    800019bc:	892a                	mv	s2,a0
    800019be:	e945                	bnez	a0,80001a6e <usertrap+0xf0>
    800019c0:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    800019c4:	47bd                	li	a5,15
    800019c6:	08f70863          	beq	a4,a5,80001a56 <usertrap+0xd8>
    800019ca:	14202773          	csrr	a4,scause
    800019ce:	47b5                	li	a5,13
    800019d0:	08f70363          	beq	a4,a5,80001a56 <usertrap+0xd8>
    800019d4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800019d8:	5890                	lw	a2,48(s1)
    800019da:	00006517          	auipc	a0,0x6
    800019de:	89e50513          	addi	a0,a0,-1890 # 80007278 <states.1733+0x78>
    800019e2:	76e030ef          	jal	ra,80005150 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800019e6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800019ea:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800019ee:	00006517          	auipc	a0,0x6
    800019f2:	8ba50513          	addi	a0,a0,-1862 # 800072a8 <states.1733+0xa8>
    800019f6:	75a030ef          	jal	ra,80005150 <printf>
    setkilled(p);
    800019fa:	8526                	mv	a0,s1
    800019fc:	b21ff0ef          	jal	ra,8000151c <setkilled>
    80001a00:	a035                	j	80001a2c <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001a02:	00006517          	auipc	a0,0x6
    80001a06:	85650513          	addi	a0,a0,-1962 # 80007258 <states.1733+0x58>
    80001a0a:	20d030ef          	jal	ra,80005416 <panic>
    if(killed(p))
    80001a0e:	b33ff0ef          	jal	ra,80001540 <killed>
    80001a12:	ed15                	bnez	a0,80001a4e <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001a14:	6cb8                	ld	a4,88(s1)
    80001a16:	6f1c                	ld	a5,24(a4)
    80001a18:	0791                	addi	a5,a5,4
    80001a1a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a1c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a20:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a24:	10079073          	csrw	sstatus,a5
    syscall();
    80001a28:	246000ef          	jal	ra,80001c6e <syscall>
  if(killed(p))
    80001a2c:	8526                	mv	a0,s1
    80001a2e:	b13ff0ef          	jal	ra,80001540 <killed>
    80001a32:	e139                	bnez	a0,80001a78 <usertrap+0xfa>
  prepare_return();
    80001a34:	e0dff0ef          	jal	ra,80001840 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001a38:	68a8                	ld	a0,80(s1)
    80001a3a:	8131                	srli	a0,a0,0xc
    80001a3c:	57fd                	li	a5,-1
    80001a3e:	17fe                	slli	a5,a5,0x3f
    80001a40:	8d5d                	or	a0,a0,a5
}
    80001a42:	60e2                	ld	ra,24(sp)
    80001a44:	6442                	ld	s0,16(sp)
    80001a46:	64a2                	ld	s1,8(sp)
    80001a48:	6902                	ld	s2,0(sp)
    80001a4a:	6105                	addi	sp,sp,32
    80001a4c:	8082                	ret
      kexit(-1);
    80001a4e:	557d                	li	a0,-1
    80001a50:	9c5ff0ef          	jal	ra,80001414 <kexit>
    80001a54:	b7c1                	j	80001a14 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a56:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a5a:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001a5e:	164d                	addi	a2,a2,-13
    80001a60:	00163613          	seqz	a2,a2
    80001a64:	68a8                	ld	a0,80(s1)
    80001a66:	f87fe0ef          	jal	ra,800009ec <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001a6a:	f169                	bnez	a0,80001a2c <usertrap+0xae>
    80001a6c:	b7a5                	j	800019d4 <usertrap+0x56>
  if(killed(p))
    80001a6e:	8526                	mv	a0,s1
    80001a70:	ad1ff0ef          	jal	ra,80001540 <killed>
    80001a74:	c511                	beqz	a0,80001a80 <usertrap+0x102>
    80001a76:	a011                	j	80001a7a <usertrap+0xfc>
    80001a78:	4901                	li	s2,0
    kexit(-1);
    80001a7a:	557d                	li	a0,-1
    80001a7c:	999ff0ef          	jal	ra,80001414 <kexit>
  if(which_dev == 2)
    80001a80:	4789                	li	a5,2
    80001a82:	faf919e3          	bne	s2,a5,80001a34 <usertrap+0xb6>
    yield();
    80001a86:	857ff0ef          	jal	ra,800012dc <yield>
    80001a8a:	b76d                	j	80001a34 <usertrap+0xb6>

0000000080001a8c <kerneltrap>:
{
    80001a8c:	7179                	addi	sp,sp,-48
    80001a8e:	f406                	sd	ra,40(sp)
    80001a90:	f022                	sd	s0,32(sp)
    80001a92:	ec26                	sd	s1,24(sp)
    80001a94:	e84a                	sd	s2,16(sp)
    80001a96:	e44e                	sd	s3,8(sp)
    80001a98:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a9a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a9e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aa2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001aa6:	1004f793          	andi	a5,s1,256
    80001aaa:	c795                	beqz	a5,80001ad6 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aac:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ab0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ab2:	eb85                	bnez	a5,80001ae2 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001ab4:	e5bff0ef          	jal	ra,8000190e <devintr>
    80001ab8:	c91d                	beqz	a0,80001aee <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001aba:	4789                	li	a5,2
    80001abc:	04f50a63          	beq	a0,a5,80001b10 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ac0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac4:	10049073          	csrw	sstatus,s1
}
    80001ac8:	70a2                	ld	ra,40(sp)
    80001aca:	7402                	ld	s0,32(sp)
    80001acc:	64e2                	ld	s1,24(sp)
    80001ace:	6942                	ld	s2,16(sp)
    80001ad0:	69a2                	ld	s3,8(sp)
    80001ad2:	6145                	addi	sp,sp,48
    80001ad4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ad6:	00005517          	auipc	a0,0x5
    80001ada:	7fa50513          	addi	a0,a0,2042 # 800072d0 <states.1733+0xd0>
    80001ade:	139030ef          	jal	ra,80005416 <panic>
    panic("kerneltrap: interrupts enabled");
    80001ae2:	00006517          	auipc	a0,0x6
    80001ae6:	81650513          	addi	a0,a0,-2026 # 800072f8 <states.1733+0xf8>
    80001aea:	12d030ef          	jal	ra,80005416 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001aee:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001af2:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001af6:	85ce                	mv	a1,s3
    80001af8:	00006517          	auipc	a0,0x6
    80001afc:	82050513          	addi	a0,a0,-2016 # 80007318 <states.1733+0x118>
    80001b00:	650030ef          	jal	ra,80005150 <printf>
    panic("kerneltrap");
    80001b04:	00006517          	auipc	a0,0x6
    80001b08:	83c50513          	addi	a0,a0,-1988 # 80007340 <states.1733+0x140>
    80001b0c:	10b030ef          	jal	ra,80005416 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b10:	a06ff0ef          	jal	ra,80000d16 <myproc>
    80001b14:	d555                	beqz	a0,80001ac0 <kerneltrap+0x34>
    yield();
    80001b16:	fc6ff0ef          	jal	ra,800012dc <yield>
    80001b1a:	b75d                	j	80001ac0 <kerneltrap+0x34>

0000000080001b1c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b1c:	1101                	addi	sp,sp,-32
    80001b1e:	ec06                	sd	ra,24(sp)
    80001b20:	e822                	sd	s0,16(sp)
    80001b22:	e426                	sd	s1,8(sp)
    80001b24:	1000                	addi	s0,sp,32
    80001b26:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b28:	9eeff0ef          	jal	ra,80000d16 <myproc>
  switch (n) {
    80001b2c:	4795                	li	a5,5
    80001b2e:	0497e163          	bltu	a5,s1,80001b70 <argraw+0x54>
    80001b32:	048a                	slli	s1,s1,0x2
    80001b34:	00006717          	auipc	a4,0x6
    80001b38:	84470713          	addi	a4,a4,-1980 # 80007378 <states.1733+0x178>
    80001b3c:	94ba                	add	s1,s1,a4
    80001b3e:	409c                	lw	a5,0(s1)
    80001b40:	97ba                	add	a5,a5,a4
    80001b42:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001b44:	6d3c                	ld	a5,88(a0)
    80001b46:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001b48:	60e2                	ld	ra,24(sp)
    80001b4a:	6442                	ld	s0,16(sp)
    80001b4c:	64a2                	ld	s1,8(sp)
    80001b4e:	6105                	addi	sp,sp,32
    80001b50:	8082                	ret
    return p->trapframe->a1;
    80001b52:	6d3c                	ld	a5,88(a0)
    80001b54:	7fa8                	ld	a0,120(a5)
    80001b56:	bfcd                	j	80001b48 <argraw+0x2c>
    return p->trapframe->a2;
    80001b58:	6d3c                	ld	a5,88(a0)
    80001b5a:	63c8                	ld	a0,128(a5)
    80001b5c:	b7f5                	j	80001b48 <argraw+0x2c>
    return p->trapframe->a3;
    80001b5e:	6d3c                	ld	a5,88(a0)
    80001b60:	67c8                	ld	a0,136(a5)
    80001b62:	b7dd                	j	80001b48 <argraw+0x2c>
    return p->trapframe->a4;
    80001b64:	6d3c                	ld	a5,88(a0)
    80001b66:	6bc8                	ld	a0,144(a5)
    80001b68:	b7c5                	j	80001b48 <argraw+0x2c>
    return p->trapframe->a5;
    80001b6a:	6d3c                	ld	a5,88(a0)
    80001b6c:	6fc8                	ld	a0,152(a5)
    80001b6e:	bfe9                	j	80001b48 <argraw+0x2c>
  panic("argraw");
    80001b70:	00005517          	auipc	a0,0x5
    80001b74:	7e050513          	addi	a0,a0,2016 # 80007350 <states.1733+0x150>
    80001b78:	09f030ef          	jal	ra,80005416 <panic>

0000000080001b7c <fetchaddr>:
{
    80001b7c:	1101                	addi	sp,sp,-32
    80001b7e:	ec06                	sd	ra,24(sp)
    80001b80:	e822                	sd	s0,16(sp)
    80001b82:	e426                	sd	s1,8(sp)
    80001b84:	e04a                	sd	s2,0(sp)
    80001b86:	1000                	addi	s0,sp,32
    80001b88:	84aa                	mv	s1,a0
    80001b8a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001b8c:	98aff0ef          	jal	ra,80000d16 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001b90:	653c                	ld	a5,72(a0)
    80001b92:	02f4f663          	bgeu	s1,a5,80001bbe <fetchaddr+0x42>
    80001b96:	00848713          	addi	a4,s1,8
    80001b9a:	02e7e463          	bltu	a5,a4,80001bc2 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001b9e:	46a1                	li	a3,8
    80001ba0:	8626                	mv	a2,s1
    80001ba2:	85ca                	mv	a1,s2
    80001ba4:	6928                	ld	a0,80(a0)
    80001ba6:	f85fe0ef          	jal	ra,80000b2a <copyin>
    80001baa:	00a03533          	snez	a0,a0
    80001bae:	40a00533          	neg	a0,a0
}
    80001bb2:	60e2                	ld	ra,24(sp)
    80001bb4:	6442                	ld	s0,16(sp)
    80001bb6:	64a2                	ld	s1,8(sp)
    80001bb8:	6902                	ld	s2,0(sp)
    80001bba:	6105                	addi	sp,sp,32
    80001bbc:	8082                	ret
    return -1;
    80001bbe:	557d                	li	a0,-1
    80001bc0:	bfcd                	j	80001bb2 <fetchaddr+0x36>
    80001bc2:	557d                	li	a0,-1
    80001bc4:	b7fd                	j	80001bb2 <fetchaddr+0x36>

0000000080001bc6 <fetchstr>:
{
    80001bc6:	7179                	addi	sp,sp,-48
    80001bc8:	f406                	sd	ra,40(sp)
    80001bca:	f022                	sd	s0,32(sp)
    80001bcc:	ec26                	sd	s1,24(sp)
    80001bce:	e84a                	sd	s2,16(sp)
    80001bd0:	e44e                	sd	s3,8(sp)
    80001bd2:	1800                	addi	s0,sp,48
    80001bd4:	892a                	mv	s2,a0
    80001bd6:	84ae                	mv	s1,a1
    80001bd8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001bda:	93cff0ef          	jal	ra,80000d16 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001bde:	86ce                	mv	a3,s3
    80001be0:	864a                	mv	a2,s2
    80001be2:	85a6                	mv	a1,s1
    80001be4:	6928                	ld	a0,80(a0)
    80001be6:	d37fe0ef          	jal	ra,8000091c <copyinstr>
    80001bea:	00054c63          	bltz	a0,80001c02 <fetchstr+0x3c>
  return strlen(buf);
    80001bee:	8526                	mv	a0,s1
    80001bf0:	ec2fe0ef          	jal	ra,800002b2 <strlen>
}
    80001bf4:	70a2                	ld	ra,40(sp)
    80001bf6:	7402                	ld	s0,32(sp)
    80001bf8:	64e2                	ld	s1,24(sp)
    80001bfa:	6942                	ld	s2,16(sp)
    80001bfc:	69a2                	ld	s3,8(sp)
    80001bfe:	6145                	addi	sp,sp,48
    80001c00:	8082                	ret
    return -1;
    80001c02:	557d                	li	a0,-1
    80001c04:	bfc5                	j	80001bf4 <fetchstr+0x2e>

0000000080001c06 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c06:	1101                	addi	sp,sp,-32
    80001c08:	ec06                	sd	ra,24(sp)
    80001c0a:	e822                	sd	s0,16(sp)
    80001c0c:	e426                	sd	s1,8(sp)
    80001c0e:	1000                	addi	s0,sp,32
    80001c10:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c12:	f0bff0ef          	jal	ra,80001b1c <argraw>
    80001c16:	c088                	sw	a0,0(s1)
}
    80001c18:	60e2                	ld	ra,24(sp)
    80001c1a:	6442                	ld	s0,16(sp)
    80001c1c:	64a2                	ld	s1,8(sp)
    80001c1e:	6105                	addi	sp,sp,32
    80001c20:	8082                	ret

0000000080001c22 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c22:	1101                	addi	sp,sp,-32
    80001c24:	ec06                	sd	ra,24(sp)
    80001c26:	e822                	sd	s0,16(sp)
    80001c28:	e426                	sd	s1,8(sp)
    80001c2a:	1000                	addi	s0,sp,32
    80001c2c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c2e:	eefff0ef          	jal	ra,80001b1c <argraw>
    80001c32:	e088                	sd	a0,0(s1)
}
    80001c34:	60e2                	ld	ra,24(sp)
    80001c36:	6442                	ld	s0,16(sp)
    80001c38:	64a2                	ld	s1,8(sp)
    80001c3a:	6105                	addi	sp,sp,32
    80001c3c:	8082                	ret

0000000080001c3e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001c3e:	7179                	addi	sp,sp,-48
    80001c40:	f406                	sd	ra,40(sp)
    80001c42:	f022                	sd	s0,32(sp)
    80001c44:	ec26                	sd	s1,24(sp)
    80001c46:	e84a                	sd	s2,16(sp)
    80001c48:	1800                	addi	s0,sp,48
    80001c4a:	84ae                	mv	s1,a1
    80001c4c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001c4e:	fd840593          	addi	a1,s0,-40
    80001c52:	fd1ff0ef          	jal	ra,80001c22 <argaddr>
  return fetchstr(addr, buf, max);
    80001c56:	864a                	mv	a2,s2
    80001c58:	85a6                	mv	a1,s1
    80001c5a:	fd843503          	ld	a0,-40(s0)
    80001c5e:	f69ff0ef          	jal	ra,80001bc6 <fetchstr>
}
    80001c62:	70a2                	ld	ra,40(sp)
    80001c64:	7402                	ld	s0,32(sp)
    80001c66:	64e2                	ld	s1,24(sp)
    80001c68:	6942                	ld	s2,16(sp)
    80001c6a:	6145                	addi	sp,sp,48
    80001c6c:	8082                	ret

0000000080001c6e <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001c6e:	1101                	addi	sp,sp,-32
    80001c70:	ec06                	sd	ra,24(sp)
    80001c72:	e822                	sd	s0,16(sp)
    80001c74:	e426                	sd	s1,8(sp)
    80001c76:	e04a                	sd	s2,0(sp)
    80001c78:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001c7a:	89cff0ef          	jal	ra,80000d16 <myproc>
    80001c7e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001c80:	05853903          	ld	s2,88(a0)
    80001c84:	0a893783          	ld	a5,168(s2)
    80001c88:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001c8c:	37fd                	addiw	a5,a5,-1
    80001c8e:	4751                	li	a4,20
    80001c90:	00f76f63          	bltu	a4,a5,80001cae <syscall+0x40>
    80001c94:	00369713          	slli	a4,a3,0x3
    80001c98:	00005797          	auipc	a5,0x5
    80001c9c:	6f878793          	addi	a5,a5,1784 # 80007390 <syscalls>
    80001ca0:	97ba                	add	a5,a5,a4
    80001ca2:	639c                	ld	a5,0(a5)
    80001ca4:	c789                	beqz	a5,80001cae <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001ca6:	9782                	jalr	a5
    80001ca8:	06a93823          	sd	a0,112(s2)
    80001cac:	a829                	j	80001cc6 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001cae:	15848613          	addi	a2,s1,344
    80001cb2:	588c                	lw	a1,48(s1)
    80001cb4:	00005517          	auipc	a0,0x5
    80001cb8:	6a450513          	addi	a0,a0,1700 # 80007358 <states.1733+0x158>
    80001cbc:	494030ef          	jal	ra,80005150 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001cc0:	6cbc                	ld	a5,88(s1)
    80001cc2:	577d                	li	a4,-1
    80001cc4:	fbb8                	sd	a4,112(a5)
  }
}
    80001cc6:	60e2                	ld	ra,24(sp)
    80001cc8:	6442                	ld	s0,16(sp)
    80001cca:	64a2                	ld	s1,8(sp)
    80001ccc:	6902                	ld	s2,0(sp)
    80001cce:	6105                	addi	sp,sp,32
    80001cd0:	8082                	ret

0000000080001cd2 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80001cd2:	1101                	addi	sp,sp,-32
    80001cd4:	ec06                	sd	ra,24(sp)
    80001cd6:	e822                	sd	s0,16(sp)
    80001cd8:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001cda:	fec40593          	addi	a1,s0,-20
    80001cde:	4501                	li	a0,0
    80001ce0:	f27ff0ef          	jal	ra,80001c06 <argint>
  kexit(n);
    80001ce4:	fec42503          	lw	a0,-20(s0)
    80001ce8:	f2cff0ef          	jal	ra,80001414 <kexit>
  return 0;  // not reached
}
    80001cec:	4501                	li	a0,0
    80001cee:	60e2                	ld	ra,24(sp)
    80001cf0:	6442                	ld	s0,16(sp)
    80001cf2:	6105                	addi	sp,sp,32
    80001cf4:	8082                	ret

0000000080001cf6 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001cf6:	1141                	addi	sp,sp,-16
    80001cf8:	e406                	sd	ra,8(sp)
    80001cfa:	e022                	sd	s0,0(sp)
    80001cfc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001cfe:	818ff0ef          	jal	ra,80000d16 <myproc>
}
    80001d02:	5908                	lw	a0,48(a0)
    80001d04:	60a2                	ld	ra,8(sp)
    80001d06:	6402                	ld	s0,0(sp)
    80001d08:	0141                	addi	sp,sp,16
    80001d0a:	8082                	ret

0000000080001d0c <sys_fork>:

uint64
sys_fork(void)
{
    80001d0c:	1141                	addi	sp,sp,-16
    80001d0e:	e406                	sd	ra,8(sp)
    80001d10:	e022                	sd	s0,0(sp)
    80001d12:	0800                	addi	s0,sp,16
  return kfork();
    80001d14:	b54ff0ef          	jal	ra,80001068 <kfork>
}
    80001d18:	60a2                	ld	ra,8(sp)
    80001d1a:	6402                	ld	s0,0(sp)
    80001d1c:	0141                	addi	sp,sp,16
    80001d1e:	8082                	ret

0000000080001d20 <sys_wait>:

uint64
sys_wait(void)
{
    80001d20:	1101                	addi	sp,sp,-32
    80001d22:	ec06                	sd	ra,24(sp)
    80001d24:	e822                	sd	s0,16(sp)
    80001d26:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d28:	fe840593          	addi	a1,s0,-24
    80001d2c:	4501                	li	a0,0
    80001d2e:	ef5ff0ef          	jal	ra,80001c22 <argaddr>
  return kwait(p);
    80001d32:	fe843503          	ld	a0,-24(s0)
    80001d36:	835ff0ef          	jal	ra,8000156a <kwait>
}
    80001d3a:	60e2                	ld	ra,24(sp)
    80001d3c:	6442                	ld	s0,16(sp)
    80001d3e:	6105                	addi	sp,sp,32
    80001d40:	8082                	ret

0000000080001d42 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001d42:	7179                	addi	sp,sp,-48
    80001d44:	f406                	sd	ra,40(sp)
    80001d46:	f022                	sd	s0,32(sp)
    80001d48:	ec26                	sd	s1,24(sp)
    80001d4a:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001d4c:	fd840593          	addi	a1,s0,-40
    80001d50:	4501                	li	a0,0
    80001d52:	eb5ff0ef          	jal	ra,80001c06 <argint>
  argint(1, &t);
    80001d56:	fdc40593          	addi	a1,s0,-36
    80001d5a:	4505                	li	a0,1
    80001d5c:	eabff0ef          	jal	ra,80001c06 <argint>
  addr = myproc()->sz;
    80001d60:	fb7fe0ef          	jal	ra,80000d16 <myproc>
    80001d64:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80001d66:	fdc42703          	lw	a4,-36(s0)
    80001d6a:	4785                	li	a5,1
    80001d6c:	02f70163          	beq	a4,a5,80001d8e <sys_sbrk+0x4c>
    80001d70:	fd842783          	lw	a5,-40(s0)
    80001d74:	0007cd63          	bltz	a5,80001d8e <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80001d78:	97a6                	add	a5,a5,s1
    80001d7a:	0297e863          	bltu	a5,s1,80001daa <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001d7e:	f99fe0ef          	jal	ra,80000d16 <myproc>
    80001d82:	fd842703          	lw	a4,-40(s0)
    80001d86:	653c                	ld	a5,72(a0)
    80001d88:	97ba                	add	a5,a5,a4
    80001d8a:	e53c                	sd	a5,72(a0)
    80001d8c:	a039                	j	80001d9a <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80001d8e:	fd842503          	lw	a0,-40(s0)
    80001d92:	a86ff0ef          	jal	ra,80001018 <growproc>
    80001d96:	00054863          	bltz	a0,80001da6 <sys_sbrk+0x64>
  }
  return addr;
}
    80001d9a:	8526                	mv	a0,s1
    80001d9c:	70a2                	ld	ra,40(sp)
    80001d9e:	7402                	ld	s0,32(sp)
    80001da0:	64e2                	ld	s1,24(sp)
    80001da2:	6145                	addi	sp,sp,48
    80001da4:	8082                	ret
      return -1;
    80001da6:	54fd                	li	s1,-1
    80001da8:	bfcd                	j	80001d9a <sys_sbrk+0x58>
      return -1;
    80001daa:	54fd                	li	s1,-1
    80001dac:	b7fd                	j	80001d9a <sys_sbrk+0x58>

0000000080001dae <sys_pause>:

uint64
sys_pause(void)
{
    80001dae:	7139                	addi	sp,sp,-64
    80001db0:	fc06                	sd	ra,56(sp)
    80001db2:	f822                	sd	s0,48(sp)
    80001db4:	f426                	sd	s1,40(sp)
    80001db6:	f04a                	sd	s2,32(sp)
    80001db8:	ec4e                	sd	s3,24(sp)
    80001dba:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001dbc:	fcc40593          	addi	a1,s0,-52
    80001dc0:	4501                	li	a0,0
    80001dc2:	e45ff0ef          	jal	ra,80001c06 <argint>
  if(n < 0)
    80001dc6:	fcc42783          	lw	a5,-52(s0)
    80001dca:	0607c563          	bltz	a5,80001e34 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80001dce:	0000c517          	auipc	a0,0xc
    80001dd2:	92250513          	addi	a0,a0,-1758 # 8000d6f0 <tickslock>
    80001dd6:	0fb030ef          	jal	ra,800056d0 <acquire>
  ticks0 = ticks;
    80001dda:	00006917          	auipc	s2,0x6
    80001dde:	aae92903          	lw	s2,-1362(s2) # 80007888 <ticks>
  while(ticks - ticks0 < n){
    80001de2:	fcc42783          	lw	a5,-52(s0)
    80001de6:	cb8d                	beqz	a5,80001e18 <sys_pause+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001de8:	0000c997          	auipc	s3,0xc
    80001dec:	90898993          	addi	s3,s3,-1784 # 8000d6f0 <tickslock>
    80001df0:	00006497          	auipc	s1,0x6
    80001df4:	a9848493          	addi	s1,s1,-1384 # 80007888 <ticks>
    if(killed(myproc())){
    80001df8:	f1ffe0ef          	jal	ra,80000d16 <myproc>
    80001dfc:	f44ff0ef          	jal	ra,80001540 <killed>
    80001e00:	ed0d                	bnez	a0,80001e3a <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80001e02:	85ce                	mv	a1,s3
    80001e04:	8526                	mv	a0,s1
    80001e06:	d02ff0ef          	jal	ra,80001308 <sleep>
  while(ticks - ticks0 < n){
    80001e0a:	409c                	lw	a5,0(s1)
    80001e0c:	412787bb          	subw	a5,a5,s2
    80001e10:	fcc42703          	lw	a4,-52(s0)
    80001e14:	fee7e2e3          	bltu	a5,a4,80001df8 <sys_pause+0x4a>
  }
  release(&tickslock);
    80001e18:	0000c517          	auipc	a0,0xc
    80001e1c:	8d850513          	addi	a0,a0,-1832 # 8000d6f0 <tickslock>
    80001e20:	149030ef          	jal	ra,80005768 <release>
  return 0;
    80001e24:	4501                	li	a0,0
}
    80001e26:	70e2                	ld	ra,56(sp)
    80001e28:	7442                	ld	s0,48(sp)
    80001e2a:	74a2                	ld	s1,40(sp)
    80001e2c:	7902                	ld	s2,32(sp)
    80001e2e:	69e2                	ld	s3,24(sp)
    80001e30:	6121                	addi	sp,sp,64
    80001e32:	8082                	ret
    n = 0;
    80001e34:	fc042623          	sw	zero,-52(s0)
    80001e38:	bf59                	j	80001dce <sys_pause+0x20>
      release(&tickslock);
    80001e3a:	0000c517          	auipc	a0,0xc
    80001e3e:	8b650513          	addi	a0,a0,-1866 # 8000d6f0 <tickslock>
    80001e42:	127030ef          	jal	ra,80005768 <release>
      return -1;
    80001e46:	557d                	li	a0,-1
    80001e48:	bff9                	j	80001e26 <sys_pause+0x78>

0000000080001e4a <sys_kill>:

uint64
sys_kill(void)
{
    80001e4a:	1101                	addi	sp,sp,-32
    80001e4c:	ec06                	sd	ra,24(sp)
    80001e4e:	e822                	sd	s0,16(sp)
    80001e50:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001e52:	fec40593          	addi	a1,s0,-20
    80001e56:	4501                	li	a0,0
    80001e58:	dafff0ef          	jal	ra,80001c06 <argint>
  return kkill(pid);
    80001e5c:	fec42503          	lw	a0,-20(s0)
    80001e60:	e56ff0ef          	jal	ra,800014b6 <kkill>
}
    80001e64:	60e2                	ld	ra,24(sp)
    80001e66:	6442                	ld	s0,16(sp)
    80001e68:	6105                	addi	sp,sp,32
    80001e6a:	8082                	ret

0000000080001e6c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001e6c:	1101                	addi	sp,sp,-32
    80001e6e:	ec06                	sd	ra,24(sp)
    80001e70:	e822                	sd	s0,16(sp)
    80001e72:	e426                	sd	s1,8(sp)
    80001e74:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001e76:	0000c517          	auipc	a0,0xc
    80001e7a:	87a50513          	addi	a0,a0,-1926 # 8000d6f0 <tickslock>
    80001e7e:	053030ef          	jal	ra,800056d0 <acquire>
  xticks = ticks;
    80001e82:	00006497          	auipc	s1,0x6
    80001e86:	a064a483          	lw	s1,-1530(s1) # 80007888 <ticks>
  release(&tickslock);
    80001e8a:	0000c517          	auipc	a0,0xc
    80001e8e:	86650513          	addi	a0,a0,-1946 # 8000d6f0 <tickslock>
    80001e92:	0d7030ef          	jal	ra,80005768 <release>
  return xticks;
}
    80001e96:	02049513          	slli	a0,s1,0x20
    80001e9a:	9101                	srli	a0,a0,0x20
    80001e9c:	60e2                	ld	ra,24(sp)
    80001e9e:	6442                	ld	s0,16(sp)
    80001ea0:	64a2                	ld	s1,8(sp)
    80001ea2:	6105                	addi	sp,sp,32
    80001ea4:	8082                	ret

0000000080001ea6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001ea6:	7179                	addi	sp,sp,-48
    80001ea8:	f406                	sd	ra,40(sp)
    80001eaa:	f022                	sd	s0,32(sp)
    80001eac:	ec26                	sd	s1,24(sp)
    80001eae:	e84a                	sd	s2,16(sp)
    80001eb0:	e44e                	sd	s3,8(sp)
    80001eb2:	e052                	sd	s4,0(sp)
    80001eb4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001eb6:	00005597          	auipc	a1,0x5
    80001eba:	58a58593          	addi	a1,a1,1418 # 80007440 <syscalls+0xb0>
    80001ebe:	0000c517          	auipc	a0,0xc
    80001ec2:	84a50513          	addi	a0,a0,-1974 # 8000d708 <bcache>
    80001ec6:	78a030ef          	jal	ra,80005650 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001eca:	00014797          	auipc	a5,0x14
    80001ece:	83e78793          	addi	a5,a5,-1986 # 80015708 <bcache+0x8000>
    80001ed2:	00014717          	auipc	a4,0x14
    80001ed6:	a9e70713          	addi	a4,a4,-1378 # 80015970 <bcache+0x8268>
    80001eda:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001ede:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ee2:	0000c497          	auipc	s1,0xc
    80001ee6:	83e48493          	addi	s1,s1,-1986 # 8000d720 <bcache+0x18>
    b->next = bcache.head.next;
    80001eea:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001eec:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001eee:	00005a17          	auipc	s4,0x5
    80001ef2:	55aa0a13          	addi	s4,s4,1370 # 80007448 <syscalls+0xb8>
    b->next = bcache.head.next;
    80001ef6:	2b893783          	ld	a5,696(s2)
    80001efa:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001efc:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001f00:	85d2                	mv	a1,s4
    80001f02:	01048513          	addi	a0,s1,16
    80001f06:	2fe010ef          	jal	ra,80003204 <initsleeplock>
    bcache.head.next->prev = b;
    80001f0a:	2b893783          	ld	a5,696(s2)
    80001f0e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001f10:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f14:	45848493          	addi	s1,s1,1112
    80001f18:	fd349fe3          	bne	s1,s3,80001ef6 <binit+0x50>
  }
}
    80001f1c:	70a2                	ld	ra,40(sp)
    80001f1e:	7402                	ld	s0,32(sp)
    80001f20:	64e2                	ld	s1,24(sp)
    80001f22:	6942                	ld	s2,16(sp)
    80001f24:	69a2                	ld	s3,8(sp)
    80001f26:	6a02                	ld	s4,0(sp)
    80001f28:	6145                	addi	sp,sp,48
    80001f2a:	8082                	ret

0000000080001f2c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001f2c:	7179                	addi	sp,sp,-48
    80001f2e:	f406                	sd	ra,40(sp)
    80001f30:	f022                	sd	s0,32(sp)
    80001f32:	ec26                	sd	s1,24(sp)
    80001f34:	e84a                	sd	s2,16(sp)
    80001f36:	e44e                	sd	s3,8(sp)
    80001f38:	1800                	addi	s0,sp,48
    80001f3a:	89aa                	mv	s3,a0
    80001f3c:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80001f3e:	0000b517          	auipc	a0,0xb
    80001f42:	7ca50513          	addi	a0,a0,1994 # 8000d708 <bcache>
    80001f46:	78a030ef          	jal	ra,800056d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001f4a:	00014497          	auipc	s1,0x14
    80001f4e:	a764b483          	ld	s1,-1418(s1) # 800159c0 <bcache+0x82b8>
    80001f52:	00014797          	auipc	a5,0x14
    80001f56:	a1e78793          	addi	a5,a5,-1506 # 80015970 <bcache+0x8268>
    80001f5a:	02f48b63          	beq	s1,a5,80001f90 <bread+0x64>
    80001f5e:	873e                	mv	a4,a5
    80001f60:	a021                	j	80001f68 <bread+0x3c>
    80001f62:	68a4                	ld	s1,80(s1)
    80001f64:	02e48663          	beq	s1,a4,80001f90 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001f68:	449c                	lw	a5,8(s1)
    80001f6a:	ff379ce3          	bne	a5,s3,80001f62 <bread+0x36>
    80001f6e:	44dc                	lw	a5,12(s1)
    80001f70:	ff2799e3          	bne	a5,s2,80001f62 <bread+0x36>
      b->refcnt++;
    80001f74:	40bc                	lw	a5,64(s1)
    80001f76:	2785                	addiw	a5,a5,1
    80001f78:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f7a:	0000b517          	auipc	a0,0xb
    80001f7e:	78e50513          	addi	a0,a0,1934 # 8000d708 <bcache>
    80001f82:	7e6030ef          	jal	ra,80005768 <release>
      acquiresleep(&b->lock);
    80001f86:	01048513          	addi	a0,s1,16
    80001f8a:	2b0010ef          	jal	ra,8000323a <acquiresleep>
      return b;
    80001f8e:	a889                	j	80001fe0 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f90:	00014497          	auipc	s1,0x14
    80001f94:	a284b483          	ld	s1,-1496(s1) # 800159b8 <bcache+0x82b0>
    80001f98:	00014797          	auipc	a5,0x14
    80001f9c:	9d878793          	addi	a5,a5,-1576 # 80015970 <bcache+0x8268>
    80001fa0:	00f48863          	beq	s1,a5,80001fb0 <bread+0x84>
    80001fa4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80001fa6:	40bc                	lw	a5,64(s1)
    80001fa8:	cb91                	beqz	a5,80001fbc <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001faa:	64a4                	ld	s1,72(s1)
    80001fac:	fee49de3          	bne	s1,a4,80001fa6 <bread+0x7a>
  panic("bget: no buffers");
    80001fb0:	00005517          	auipc	a0,0x5
    80001fb4:	4a050513          	addi	a0,a0,1184 # 80007450 <syscalls+0xc0>
    80001fb8:	45e030ef          	jal	ra,80005416 <panic>
      b->dev = dev;
    80001fbc:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80001fc0:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80001fc4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80001fc8:	4785                	li	a5,1
    80001fca:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001fcc:	0000b517          	auipc	a0,0xb
    80001fd0:	73c50513          	addi	a0,a0,1852 # 8000d708 <bcache>
    80001fd4:	794030ef          	jal	ra,80005768 <release>
      acquiresleep(&b->lock);
    80001fd8:	01048513          	addi	a0,s1,16
    80001fdc:	25e010ef          	jal	ra,8000323a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80001fe0:	409c                	lw	a5,0(s1)
    80001fe2:	cb89                	beqz	a5,80001ff4 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80001fe4:	8526                	mv	a0,s1
    80001fe6:	70a2                	ld	ra,40(sp)
    80001fe8:	7402                	ld	s0,32(sp)
    80001fea:	64e2                	ld	s1,24(sp)
    80001fec:	6942                	ld	s2,16(sp)
    80001fee:	69a2                	ld	s3,8(sp)
    80001ff0:	6145                	addi	sp,sp,48
    80001ff2:	8082                	ret
    virtio_disk_rw(b, 0);
    80001ff4:	4581                	li	a1,0
    80001ff6:	8526                	mv	a0,s1
    80001ff8:	199020ef          	jal	ra,80004990 <virtio_disk_rw>
    b->valid = 1;
    80001ffc:	4785                	li	a5,1
    80001ffe:	c09c                	sw	a5,0(s1)
  return b;
    80002000:	b7d5                	j	80001fe4 <bread+0xb8>

0000000080002002 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002002:	1101                	addi	sp,sp,-32
    80002004:	ec06                	sd	ra,24(sp)
    80002006:	e822                	sd	s0,16(sp)
    80002008:	e426                	sd	s1,8(sp)
    8000200a:	1000                	addi	s0,sp,32
    8000200c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000200e:	0541                	addi	a0,a0,16
    80002010:	2a8010ef          	jal	ra,800032b8 <holdingsleep>
    80002014:	c911                	beqz	a0,80002028 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002016:	4585                	li	a1,1
    80002018:	8526                	mv	a0,s1
    8000201a:	177020ef          	jal	ra,80004990 <virtio_disk_rw>
}
    8000201e:	60e2                	ld	ra,24(sp)
    80002020:	6442                	ld	s0,16(sp)
    80002022:	64a2                	ld	s1,8(sp)
    80002024:	6105                	addi	sp,sp,32
    80002026:	8082                	ret
    panic("bwrite");
    80002028:	00005517          	auipc	a0,0x5
    8000202c:	44050513          	addi	a0,a0,1088 # 80007468 <syscalls+0xd8>
    80002030:	3e6030ef          	jal	ra,80005416 <panic>

0000000080002034 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002034:	1101                	addi	sp,sp,-32
    80002036:	ec06                	sd	ra,24(sp)
    80002038:	e822                	sd	s0,16(sp)
    8000203a:	e426                	sd	s1,8(sp)
    8000203c:	e04a                	sd	s2,0(sp)
    8000203e:	1000                	addi	s0,sp,32
    80002040:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002042:	01050913          	addi	s2,a0,16
    80002046:	854a                	mv	a0,s2
    80002048:	270010ef          	jal	ra,800032b8 <holdingsleep>
    8000204c:	c13d                	beqz	a0,800020b2 <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    8000204e:	854a                	mv	a0,s2
    80002050:	230010ef          	jal	ra,80003280 <releasesleep>

  acquire(&bcache.lock);
    80002054:	0000b517          	auipc	a0,0xb
    80002058:	6b450513          	addi	a0,a0,1716 # 8000d708 <bcache>
    8000205c:	674030ef          	jal	ra,800056d0 <acquire>
  b->refcnt--;
    80002060:	40bc                	lw	a5,64(s1)
    80002062:	37fd                	addiw	a5,a5,-1
    80002064:	0007871b          	sext.w	a4,a5
    80002068:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000206a:	eb05                	bnez	a4,8000209a <brelse+0x66>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000206c:	68bc                	ld	a5,80(s1)
    8000206e:	64b8                	ld	a4,72(s1)
    80002070:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002072:	64bc                	ld	a5,72(s1)
    80002074:	68b8                	ld	a4,80(s1)
    80002076:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002078:	00013797          	auipc	a5,0x13
    8000207c:	69078793          	addi	a5,a5,1680 # 80015708 <bcache+0x8000>
    80002080:	2b87b703          	ld	a4,696(a5)
    80002084:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002086:	00014717          	auipc	a4,0x14
    8000208a:	8ea70713          	addi	a4,a4,-1814 # 80015970 <bcache+0x8268>
    8000208e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002090:	2b87b703          	ld	a4,696(a5)
    80002094:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002096:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000209a:	0000b517          	auipc	a0,0xb
    8000209e:	66e50513          	addi	a0,a0,1646 # 8000d708 <bcache>
    800020a2:	6c6030ef          	jal	ra,80005768 <release>
}
    800020a6:	60e2                	ld	ra,24(sp)
    800020a8:	6442                	ld	s0,16(sp)
    800020aa:	64a2                	ld	s1,8(sp)
    800020ac:	6902                	ld	s2,0(sp)
    800020ae:	6105                	addi	sp,sp,32
    800020b0:	8082                	ret
    panic("brelse");
    800020b2:	00005517          	auipc	a0,0x5
    800020b6:	3be50513          	addi	a0,a0,958 # 80007470 <syscalls+0xe0>
    800020ba:	35c030ef          	jal	ra,80005416 <panic>

00000000800020be <bpin>:

void
bpin(struct buf *b) {
    800020be:	1101                	addi	sp,sp,-32
    800020c0:	ec06                	sd	ra,24(sp)
    800020c2:	e822                	sd	s0,16(sp)
    800020c4:	e426                	sd	s1,8(sp)
    800020c6:	1000                	addi	s0,sp,32
    800020c8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800020ca:	0000b517          	auipc	a0,0xb
    800020ce:	63e50513          	addi	a0,a0,1598 # 8000d708 <bcache>
    800020d2:	5fe030ef          	jal	ra,800056d0 <acquire>
  b->refcnt++;
    800020d6:	40bc                	lw	a5,64(s1)
    800020d8:	2785                	addiw	a5,a5,1
    800020da:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800020dc:	0000b517          	auipc	a0,0xb
    800020e0:	62c50513          	addi	a0,a0,1580 # 8000d708 <bcache>
    800020e4:	684030ef          	jal	ra,80005768 <release>
}
    800020e8:	60e2                	ld	ra,24(sp)
    800020ea:	6442                	ld	s0,16(sp)
    800020ec:	64a2                	ld	s1,8(sp)
    800020ee:	6105                	addi	sp,sp,32
    800020f0:	8082                	ret

00000000800020f2 <bunpin>:

void
bunpin(struct buf *b) {
    800020f2:	1101                	addi	sp,sp,-32
    800020f4:	ec06                	sd	ra,24(sp)
    800020f6:	e822                	sd	s0,16(sp)
    800020f8:	e426                	sd	s1,8(sp)
    800020fa:	1000                	addi	s0,sp,32
    800020fc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800020fe:	0000b517          	auipc	a0,0xb
    80002102:	60a50513          	addi	a0,a0,1546 # 8000d708 <bcache>
    80002106:	5ca030ef          	jal	ra,800056d0 <acquire>
  b->refcnt--;
    8000210a:	40bc                	lw	a5,64(s1)
    8000210c:	37fd                	addiw	a5,a5,-1
    8000210e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002110:	0000b517          	auipc	a0,0xb
    80002114:	5f850513          	addi	a0,a0,1528 # 8000d708 <bcache>
    80002118:	650030ef          	jal	ra,80005768 <release>
}
    8000211c:	60e2                	ld	ra,24(sp)
    8000211e:	6442                	ld	s0,16(sp)
    80002120:	64a2                	ld	s1,8(sp)
    80002122:	6105                	addi	sp,sp,32
    80002124:	8082                	ret

0000000080002126 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002126:	1101                	addi	sp,sp,-32
    80002128:	ec06                	sd	ra,24(sp)
    8000212a:	e822                	sd	s0,16(sp)
    8000212c:	e426                	sd	s1,8(sp)
    8000212e:	e04a                	sd	s2,0(sp)
    80002130:	1000                	addi	s0,sp,32
    80002132:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002134:	00d5d59b          	srliw	a1,a1,0xd
    80002138:	00014797          	auipc	a5,0x14
    8000213c:	cac7a783          	lw	a5,-852(a5) # 80015de4 <sb+0x1c>
    80002140:	9dbd                	addw	a1,a1,a5
    80002142:	debff0ef          	jal	ra,80001f2c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002146:	0074f713          	andi	a4,s1,7
    8000214a:	4785                	li	a5,1
    8000214c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002150:	14ce                	slli	s1,s1,0x33
    80002152:	90d9                	srli	s1,s1,0x36
    80002154:	00950733          	add	a4,a0,s1
    80002158:	05874703          	lbu	a4,88(a4)
    8000215c:	00e7f6b3          	and	a3,a5,a4
    80002160:	c29d                	beqz	a3,80002186 <bfree+0x60>
    80002162:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002164:	94aa                	add	s1,s1,a0
    80002166:	fff7c793          	not	a5,a5
    8000216a:	8ff9                	and	a5,a5,a4
    8000216c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002170:	7d1000ef          	jal	ra,80003140 <log_write>
  brelse(bp);
    80002174:	854a                	mv	a0,s2
    80002176:	ebfff0ef          	jal	ra,80002034 <brelse>
}
    8000217a:	60e2                	ld	ra,24(sp)
    8000217c:	6442                	ld	s0,16(sp)
    8000217e:	64a2                	ld	s1,8(sp)
    80002180:	6902                	ld	s2,0(sp)
    80002182:	6105                	addi	sp,sp,32
    80002184:	8082                	ret
    panic("freeing free block");
    80002186:	00005517          	auipc	a0,0x5
    8000218a:	2f250513          	addi	a0,a0,754 # 80007478 <syscalls+0xe8>
    8000218e:	288030ef          	jal	ra,80005416 <panic>

0000000080002192 <balloc>:
{
    80002192:	711d                	addi	sp,sp,-96
    80002194:	ec86                	sd	ra,88(sp)
    80002196:	e8a2                	sd	s0,80(sp)
    80002198:	e4a6                	sd	s1,72(sp)
    8000219a:	e0ca                	sd	s2,64(sp)
    8000219c:	fc4e                	sd	s3,56(sp)
    8000219e:	f852                	sd	s4,48(sp)
    800021a0:	f456                	sd	s5,40(sp)
    800021a2:	f05a                	sd	s6,32(sp)
    800021a4:	ec5e                	sd	s7,24(sp)
    800021a6:	e862                	sd	s8,16(sp)
    800021a8:	e466                	sd	s9,8(sp)
    800021aa:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800021ac:	00014797          	auipc	a5,0x14
    800021b0:	c207a783          	lw	a5,-992(a5) # 80015dcc <sb+0x4>
    800021b4:	0e078163          	beqz	a5,80002296 <balloc+0x104>
    800021b8:	8baa                	mv	s7,a0
    800021ba:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800021bc:	00014b17          	auipc	s6,0x14
    800021c0:	c0cb0b13          	addi	s6,s6,-1012 # 80015dc8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800021c4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800021c6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800021c8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800021ca:	6c89                	lui	s9,0x2
    800021cc:	a0b5                	j	80002238 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800021ce:	974a                	add	a4,a4,s2
    800021d0:	8fd5                	or	a5,a5,a3
    800021d2:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800021d6:	854a                	mv	a0,s2
    800021d8:	769000ef          	jal	ra,80003140 <log_write>
        brelse(bp);
    800021dc:	854a                	mv	a0,s2
    800021de:	e57ff0ef          	jal	ra,80002034 <brelse>
  bp = bread(dev, bno);
    800021e2:	85a6                	mv	a1,s1
    800021e4:	855e                	mv	a0,s7
    800021e6:	d47ff0ef          	jal	ra,80001f2c <bread>
    800021ea:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800021ec:	40000613          	li	a2,1024
    800021f0:	4581                	li	a1,0
    800021f2:	05850513          	addi	a0,a0,88
    800021f6:	f3dfd0ef          	jal	ra,80000132 <memset>
  log_write(bp);
    800021fa:	854a                	mv	a0,s2
    800021fc:	745000ef          	jal	ra,80003140 <log_write>
  brelse(bp);
    80002200:	854a                	mv	a0,s2
    80002202:	e33ff0ef          	jal	ra,80002034 <brelse>
}
    80002206:	8526                	mv	a0,s1
    80002208:	60e6                	ld	ra,88(sp)
    8000220a:	6446                	ld	s0,80(sp)
    8000220c:	64a6                	ld	s1,72(sp)
    8000220e:	6906                	ld	s2,64(sp)
    80002210:	79e2                	ld	s3,56(sp)
    80002212:	7a42                	ld	s4,48(sp)
    80002214:	7aa2                	ld	s5,40(sp)
    80002216:	7b02                	ld	s6,32(sp)
    80002218:	6be2                	ld	s7,24(sp)
    8000221a:	6c42                	ld	s8,16(sp)
    8000221c:	6ca2                	ld	s9,8(sp)
    8000221e:	6125                	addi	sp,sp,96
    80002220:	8082                	ret
    brelse(bp);
    80002222:	854a                	mv	a0,s2
    80002224:	e11ff0ef          	jal	ra,80002034 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002228:	015c87bb          	addw	a5,s9,s5
    8000222c:	00078a9b          	sext.w	s5,a5
    80002230:	004b2703          	lw	a4,4(s6)
    80002234:	06eaf163          	bgeu	s5,a4,80002296 <balloc+0x104>
    bp = bread(dev, BBLOCK(b, sb));
    80002238:	41fad79b          	sraiw	a5,s5,0x1f
    8000223c:	0137d79b          	srliw	a5,a5,0x13
    80002240:	015787bb          	addw	a5,a5,s5
    80002244:	40d7d79b          	sraiw	a5,a5,0xd
    80002248:	01cb2583          	lw	a1,28(s6)
    8000224c:	9dbd                	addw	a1,a1,a5
    8000224e:	855e                	mv	a0,s7
    80002250:	cddff0ef          	jal	ra,80001f2c <bread>
    80002254:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002256:	004b2503          	lw	a0,4(s6)
    8000225a:	000a849b          	sext.w	s1,s5
    8000225e:	8662                	mv	a2,s8
    80002260:	fca4f1e3          	bgeu	s1,a0,80002222 <balloc+0x90>
      m = 1 << (bi % 8);
    80002264:	41f6579b          	sraiw	a5,a2,0x1f
    80002268:	01d7d69b          	srliw	a3,a5,0x1d
    8000226c:	00c6873b          	addw	a4,a3,a2
    80002270:	00777793          	andi	a5,a4,7
    80002274:	9f95                	subw	a5,a5,a3
    80002276:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000227a:	4037571b          	sraiw	a4,a4,0x3
    8000227e:	00e906b3          	add	a3,s2,a4
    80002282:	0586c683          	lbu	a3,88(a3) # 1058 <_entry-0x7fffefa8>
    80002286:	00d7f5b3          	and	a1,a5,a3
    8000228a:	d1b1                	beqz	a1,800021ce <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000228c:	2605                	addiw	a2,a2,1
    8000228e:	2485                	addiw	s1,s1,1
    80002290:	fd4618e3          	bne	a2,s4,80002260 <balloc+0xce>
    80002294:	b779                	j	80002222 <balloc+0x90>
  printf("balloc: out of blocks\n");
    80002296:	00005517          	auipc	a0,0x5
    8000229a:	1fa50513          	addi	a0,a0,506 # 80007490 <syscalls+0x100>
    8000229e:	6b3020ef          	jal	ra,80005150 <printf>
  return 0;
    800022a2:	4481                	li	s1,0
    800022a4:	b78d                	j	80002206 <balloc+0x74>

00000000800022a6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800022a6:	7179                	addi	sp,sp,-48
    800022a8:	f406                	sd	ra,40(sp)
    800022aa:	f022                	sd	s0,32(sp)
    800022ac:	ec26                	sd	s1,24(sp)
    800022ae:	e84a                	sd	s2,16(sp)
    800022b0:	e44e                	sd	s3,8(sp)
    800022b2:	e052                	sd	s4,0(sp)
    800022b4:	1800                	addi	s0,sp,48
    800022b6:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800022b8:	47ad                	li	a5,11
    800022ba:	02b7e563          	bltu	a5,a1,800022e4 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800022be:	02059493          	slli	s1,a1,0x20
    800022c2:	9081                	srli	s1,s1,0x20
    800022c4:	048a                	slli	s1,s1,0x2
    800022c6:	94aa                	add	s1,s1,a0
    800022c8:	0504a903          	lw	s2,80(s1)
    800022cc:	06091663          	bnez	s2,80002338 <bmap+0x92>
      addr = balloc(ip->dev);
    800022d0:	4108                	lw	a0,0(a0)
    800022d2:	ec1ff0ef          	jal	ra,80002192 <balloc>
    800022d6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800022da:	04090f63          	beqz	s2,80002338 <bmap+0x92>
        return 0;
      ip->addrs[bn] = addr;
    800022de:	0524a823          	sw	s2,80(s1)
    800022e2:	a899                	j	80002338 <bmap+0x92>
    }
    return addr;
  }
  bn -= NDIRECT;
    800022e4:	ff45849b          	addiw	s1,a1,-12
    800022e8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800022ec:	0ff00793          	li	a5,255
    800022f0:	06e7eb63          	bltu	a5,a4,80002366 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800022f4:	08052903          	lw	s2,128(a0)
    800022f8:	00091b63          	bnez	s2,8000230e <bmap+0x68>
      addr = balloc(ip->dev);
    800022fc:	4108                	lw	a0,0(a0)
    800022fe:	e95ff0ef          	jal	ra,80002192 <balloc>
    80002302:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002306:	02090963          	beqz	s2,80002338 <bmap+0x92>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000230a:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000230e:	85ca                	mv	a1,s2
    80002310:	0009a503          	lw	a0,0(s3)
    80002314:	c19ff0ef          	jal	ra,80001f2c <bread>
    80002318:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000231a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000231e:	02049593          	slli	a1,s1,0x20
    80002322:	9181                	srli	a1,a1,0x20
    80002324:	058a                	slli	a1,a1,0x2
    80002326:	00b784b3          	add	s1,a5,a1
    8000232a:	0004a903          	lw	s2,0(s1)
    8000232e:	00090e63          	beqz	s2,8000234a <bmap+0xa4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002332:	8552                	mv	a0,s4
    80002334:	d01ff0ef          	jal	ra,80002034 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002338:	854a                	mv	a0,s2
    8000233a:	70a2                	ld	ra,40(sp)
    8000233c:	7402                	ld	s0,32(sp)
    8000233e:	64e2                	ld	s1,24(sp)
    80002340:	6942                	ld	s2,16(sp)
    80002342:	69a2                	ld	s3,8(sp)
    80002344:	6a02                	ld	s4,0(sp)
    80002346:	6145                	addi	sp,sp,48
    80002348:	8082                	ret
      addr = balloc(ip->dev);
    8000234a:	0009a503          	lw	a0,0(s3)
    8000234e:	e45ff0ef          	jal	ra,80002192 <balloc>
    80002352:	0005091b          	sext.w	s2,a0
      if(addr){
    80002356:	fc090ee3          	beqz	s2,80002332 <bmap+0x8c>
        a[bn] = addr;
    8000235a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000235e:	8552                	mv	a0,s4
    80002360:	5e1000ef          	jal	ra,80003140 <log_write>
    80002364:	b7f9                	j	80002332 <bmap+0x8c>
  panic("bmap: out of range");
    80002366:	00005517          	auipc	a0,0x5
    8000236a:	14250513          	addi	a0,a0,322 # 800074a8 <syscalls+0x118>
    8000236e:	0a8030ef          	jal	ra,80005416 <panic>

0000000080002372 <iget>:
{
    80002372:	7179                	addi	sp,sp,-48
    80002374:	f406                	sd	ra,40(sp)
    80002376:	f022                	sd	s0,32(sp)
    80002378:	ec26                	sd	s1,24(sp)
    8000237a:	e84a                	sd	s2,16(sp)
    8000237c:	e44e                	sd	s3,8(sp)
    8000237e:	e052                	sd	s4,0(sp)
    80002380:	1800                	addi	s0,sp,48
    80002382:	89aa                	mv	s3,a0
    80002384:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002386:	00014517          	auipc	a0,0x14
    8000238a:	a6250513          	addi	a0,a0,-1438 # 80015de8 <itable>
    8000238e:	342030ef          	jal	ra,800056d0 <acquire>
  empty = 0;
    80002392:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002394:	00014497          	auipc	s1,0x14
    80002398:	a6c48493          	addi	s1,s1,-1428 # 80015e00 <itable+0x18>
    8000239c:	00015697          	auipc	a3,0x15
    800023a0:	4f468693          	addi	a3,a3,1268 # 80017890 <log>
    800023a4:	a039                	j	800023b2 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800023a6:	02090963          	beqz	s2,800023d8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800023aa:	08848493          	addi	s1,s1,136
    800023ae:	02d48863          	beq	s1,a3,800023de <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800023b2:	449c                	lw	a5,8(s1)
    800023b4:	fef059e3          	blez	a5,800023a6 <iget+0x34>
    800023b8:	4098                	lw	a4,0(s1)
    800023ba:	ff3716e3          	bne	a4,s3,800023a6 <iget+0x34>
    800023be:	40d8                	lw	a4,4(s1)
    800023c0:	ff4713e3          	bne	a4,s4,800023a6 <iget+0x34>
      ip->ref++;
    800023c4:	2785                	addiw	a5,a5,1
    800023c6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800023c8:	00014517          	auipc	a0,0x14
    800023cc:	a2050513          	addi	a0,a0,-1504 # 80015de8 <itable>
    800023d0:	398030ef          	jal	ra,80005768 <release>
      return ip;
    800023d4:	8926                	mv	s2,s1
    800023d6:	a02d                	j	80002400 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800023d8:	fbe9                	bnez	a5,800023aa <iget+0x38>
    800023da:	8926                	mv	s2,s1
    800023dc:	b7f9                	j	800023aa <iget+0x38>
  if(empty == 0)
    800023de:	02090a63          	beqz	s2,80002412 <iget+0xa0>
  ip->dev = dev;
    800023e2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800023e6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800023ea:	4785                	li	a5,1
    800023ec:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800023f0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800023f4:	00014517          	auipc	a0,0x14
    800023f8:	9f450513          	addi	a0,a0,-1548 # 80015de8 <itable>
    800023fc:	36c030ef          	jal	ra,80005768 <release>
}
    80002400:	854a                	mv	a0,s2
    80002402:	70a2                	ld	ra,40(sp)
    80002404:	7402                	ld	s0,32(sp)
    80002406:	64e2                	ld	s1,24(sp)
    80002408:	6942                	ld	s2,16(sp)
    8000240a:	69a2                	ld	s3,8(sp)
    8000240c:	6a02                	ld	s4,0(sp)
    8000240e:	6145                	addi	sp,sp,48
    80002410:	8082                	ret
    panic("iget: no inodes");
    80002412:	00005517          	auipc	a0,0x5
    80002416:	0ae50513          	addi	a0,a0,174 # 800074c0 <syscalls+0x130>
    8000241a:	7fd020ef          	jal	ra,80005416 <panic>

000000008000241e <iinit>:
{
    8000241e:	7179                	addi	sp,sp,-48
    80002420:	f406                	sd	ra,40(sp)
    80002422:	f022                	sd	s0,32(sp)
    80002424:	ec26                	sd	s1,24(sp)
    80002426:	e84a                	sd	s2,16(sp)
    80002428:	e44e                	sd	s3,8(sp)
    8000242a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000242c:	00005597          	auipc	a1,0x5
    80002430:	0a458593          	addi	a1,a1,164 # 800074d0 <syscalls+0x140>
    80002434:	00014517          	auipc	a0,0x14
    80002438:	9b450513          	addi	a0,a0,-1612 # 80015de8 <itable>
    8000243c:	214030ef          	jal	ra,80005650 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002440:	00014497          	auipc	s1,0x14
    80002444:	9d048493          	addi	s1,s1,-1584 # 80015e10 <itable+0x28>
    80002448:	00015997          	auipc	s3,0x15
    8000244c:	45898993          	addi	s3,s3,1112 # 800178a0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002450:	00005917          	auipc	s2,0x5
    80002454:	08890913          	addi	s2,s2,136 # 800074d8 <syscalls+0x148>
    80002458:	85ca                	mv	a1,s2
    8000245a:	8526                	mv	a0,s1
    8000245c:	5a9000ef          	jal	ra,80003204 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002460:	08848493          	addi	s1,s1,136
    80002464:	ff349ae3          	bne	s1,s3,80002458 <iinit+0x3a>
}
    80002468:	70a2                	ld	ra,40(sp)
    8000246a:	7402                	ld	s0,32(sp)
    8000246c:	64e2                	ld	s1,24(sp)
    8000246e:	6942                	ld	s2,16(sp)
    80002470:	69a2                	ld	s3,8(sp)
    80002472:	6145                	addi	sp,sp,48
    80002474:	8082                	ret

0000000080002476 <ialloc>:
{
    80002476:	715d                	addi	sp,sp,-80
    80002478:	e486                	sd	ra,72(sp)
    8000247a:	e0a2                	sd	s0,64(sp)
    8000247c:	fc26                	sd	s1,56(sp)
    8000247e:	f84a                	sd	s2,48(sp)
    80002480:	f44e                	sd	s3,40(sp)
    80002482:	f052                	sd	s4,32(sp)
    80002484:	ec56                	sd	s5,24(sp)
    80002486:	e85a                	sd	s6,16(sp)
    80002488:	e45e                	sd	s7,8(sp)
    8000248a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000248c:	00014717          	auipc	a4,0x14
    80002490:	94872703          	lw	a4,-1720(a4) # 80015dd4 <sb+0xc>
    80002494:	4785                	li	a5,1
    80002496:	04e7f663          	bgeu	a5,a4,800024e2 <ialloc+0x6c>
    8000249a:	8aaa                	mv	s5,a0
    8000249c:	8bae                	mv	s7,a1
    8000249e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800024a0:	00014a17          	auipc	s4,0x14
    800024a4:	928a0a13          	addi	s4,s4,-1752 # 80015dc8 <sb>
    800024a8:	00048b1b          	sext.w	s6,s1
    800024ac:	0044d593          	srli	a1,s1,0x4
    800024b0:	018a2783          	lw	a5,24(s4)
    800024b4:	9dbd                	addw	a1,a1,a5
    800024b6:	8556                	mv	a0,s5
    800024b8:	a75ff0ef          	jal	ra,80001f2c <bread>
    800024bc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800024be:	05850993          	addi	s3,a0,88
    800024c2:	00f4f793          	andi	a5,s1,15
    800024c6:	079a                	slli	a5,a5,0x6
    800024c8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800024ca:	00099783          	lh	a5,0(s3)
    800024ce:	cf85                	beqz	a5,80002506 <ialloc+0x90>
    brelse(bp);
    800024d0:	b65ff0ef          	jal	ra,80002034 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800024d4:	0485                	addi	s1,s1,1
    800024d6:	00ca2703          	lw	a4,12(s4)
    800024da:	0004879b          	sext.w	a5,s1
    800024de:	fce7e5e3          	bltu	a5,a4,800024a8 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800024e2:	00005517          	auipc	a0,0x5
    800024e6:	ffe50513          	addi	a0,a0,-2 # 800074e0 <syscalls+0x150>
    800024ea:	467020ef          	jal	ra,80005150 <printf>
  return 0;
    800024ee:	4501                	li	a0,0
}
    800024f0:	60a6                	ld	ra,72(sp)
    800024f2:	6406                	ld	s0,64(sp)
    800024f4:	74e2                	ld	s1,56(sp)
    800024f6:	7942                	ld	s2,48(sp)
    800024f8:	79a2                	ld	s3,40(sp)
    800024fa:	7a02                	ld	s4,32(sp)
    800024fc:	6ae2                	ld	s5,24(sp)
    800024fe:	6b42                	ld	s6,16(sp)
    80002500:	6ba2                	ld	s7,8(sp)
    80002502:	6161                	addi	sp,sp,80
    80002504:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002506:	04000613          	li	a2,64
    8000250a:	4581                	li	a1,0
    8000250c:	854e                	mv	a0,s3
    8000250e:	c25fd0ef          	jal	ra,80000132 <memset>
      dip->type = type;
    80002512:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002516:	854a                	mv	a0,s2
    80002518:	429000ef          	jal	ra,80003140 <log_write>
      brelse(bp);
    8000251c:	854a                	mv	a0,s2
    8000251e:	b17ff0ef          	jal	ra,80002034 <brelse>
      return iget(dev, inum);
    80002522:	85da                	mv	a1,s6
    80002524:	8556                	mv	a0,s5
    80002526:	e4dff0ef          	jal	ra,80002372 <iget>
    8000252a:	b7d9                	j	800024f0 <ialloc+0x7a>

000000008000252c <iupdate>:
{
    8000252c:	1101                	addi	sp,sp,-32
    8000252e:	ec06                	sd	ra,24(sp)
    80002530:	e822                	sd	s0,16(sp)
    80002532:	e426                	sd	s1,8(sp)
    80002534:	e04a                	sd	s2,0(sp)
    80002536:	1000                	addi	s0,sp,32
    80002538:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000253a:	415c                	lw	a5,4(a0)
    8000253c:	0047d79b          	srliw	a5,a5,0x4
    80002540:	00014597          	auipc	a1,0x14
    80002544:	8a05a583          	lw	a1,-1888(a1) # 80015de0 <sb+0x18>
    80002548:	9dbd                	addw	a1,a1,a5
    8000254a:	4108                	lw	a0,0(a0)
    8000254c:	9e1ff0ef          	jal	ra,80001f2c <bread>
    80002550:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002552:	05850793          	addi	a5,a0,88
    80002556:	40c8                	lw	a0,4(s1)
    80002558:	893d                	andi	a0,a0,15
    8000255a:	051a                	slli	a0,a0,0x6
    8000255c:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    8000255e:	04449703          	lh	a4,68(s1)
    80002562:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002566:	04649703          	lh	a4,70(s1)
    8000256a:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    8000256e:	04849703          	lh	a4,72(s1)
    80002572:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002576:	04a49703          	lh	a4,74(s1)
    8000257a:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    8000257e:	44f8                	lw	a4,76(s1)
    80002580:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002582:	03400613          	li	a2,52
    80002586:	05048593          	addi	a1,s1,80
    8000258a:	0531                	addi	a0,a0,12
    8000258c:	c07fd0ef          	jal	ra,80000192 <memmove>
  log_write(bp);
    80002590:	854a                	mv	a0,s2
    80002592:	3af000ef          	jal	ra,80003140 <log_write>
  brelse(bp);
    80002596:	854a                	mv	a0,s2
    80002598:	a9dff0ef          	jal	ra,80002034 <brelse>
}
    8000259c:	60e2                	ld	ra,24(sp)
    8000259e:	6442                	ld	s0,16(sp)
    800025a0:	64a2                	ld	s1,8(sp)
    800025a2:	6902                	ld	s2,0(sp)
    800025a4:	6105                	addi	sp,sp,32
    800025a6:	8082                	ret

00000000800025a8 <idup>:
{
    800025a8:	1101                	addi	sp,sp,-32
    800025aa:	ec06                	sd	ra,24(sp)
    800025ac:	e822                	sd	s0,16(sp)
    800025ae:	e426                	sd	s1,8(sp)
    800025b0:	1000                	addi	s0,sp,32
    800025b2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800025b4:	00014517          	auipc	a0,0x14
    800025b8:	83450513          	addi	a0,a0,-1996 # 80015de8 <itable>
    800025bc:	114030ef          	jal	ra,800056d0 <acquire>
  ip->ref++;
    800025c0:	449c                	lw	a5,8(s1)
    800025c2:	2785                	addiw	a5,a5,1
    800025c4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800025c6:	00014517          	auipc	a0,0x14
    800025ca:	82250513          	addi	a0,a0,-2014 # 80015de8 <itable>
    800025ce:	19a030ef          	jal	ra,80005768 <release>
}
    800025d2:	8526                	mv	a0,s1
    800025d4:	60e2                	ld	ra,24(sp)
    800025d6:	6442                	ld	s0,16(sp)
    800025d8:	64a2                	ld	s1,8(sp)
    800025da:	6105                	addi	sp,sp,32
    800025dc:	8082                	ret

00000000800025de <ilock>:
{
    800025de:	1101                	addi	sp,sp,-32
    800025e0:	ec06                	sd	ra,24(sp)
    800025e2:	e822                	sd	s0,16(sp)
    800025e4:	e426                	sd	s1,8(sp)
    800025e6:	e04a                	sd	s2,0(sp)
    800025e8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800025ea:	c105                	beqz	a0,8000260a <ilock+0x2c>
    800025ec:	84aa                	mv	s1,a0
    800025ee:	451c                	lw	a5,8(a0)
    800025f0:	00f05d63          	blez	a5,8000260a <ilock+0x2c>
  acquiresleep(&ip->lock);
    800025f4:	0541                	addi	a0,a0,16
    800025f6:	445000ef          	jal	ra,8000323a <acquiresleep>
  if(ip->valid == 0){
    800025fa:	40bc                	lw	a5,64(s1)
    800025fc:	cf89                	beqz	a5,80002616 <ilock+0x38>
}
    800025fe:	60e2                	ld	ra,24(sp)
    80002600:	6442                	ld	s0,16(sp)
    80002602:	64a2                	ld	s1,8(sp)
    80002604:	6902                	ld	s2,0(sp)
    80002606:	6105                	addi	sp,sp,32
    80002608:	8082                	ret
    panic("ilock");
    8000260a:	00005517          	auipc	a0,0x5
    8000260e:	eee50513          	addi	a0,a0,-274 # 800074f8 <syscalls+0x168>
    80002612:	605020ef          	jal	ra,80005416 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002616:	40dc                	lw	a5,4(s1)
    80002618:	0047d79b          	srliw	a5,a5,0x4
    8000261c:	00013597          	auipc	a1,0x13
    80002620:	7c45a583          	lw	a1,1988(a1) # 80015de0 <sb+0x18>
    80002624:	9dbd                	addw	a1,a1,a5
    80002626:	4088                	lw	a0,0(s1)
    80002628:	905ff0ef          	jal	ra,80001f2c <bread>
    8000262c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000262e:	05850593          	addi	a1,a0,88
    80002632:	40dc                	lw	a5,4(s1)
    80002634:	8bbd                	andi	a5,a5,15
    80002636:	079a                	slli	a5,a5,0x6
    80002638:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000263a:	00059783          	lh	a5,0(a1)
    8000263e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002642:	00259783          	lh	a5,2(a1)
    80002646:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000264a:	00459783          	lh	a5,4(a1)
    8000264e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002652:	00659783          	lh	a5,6(a1)
    80002656:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000265a:	459c                	lw	a5,8(a1)
    8000265c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000265e:	03400613          	li	a2,52
    80002662:	05b1                	addi	a1,a1,12
    80002664:	05048513          	addi	a0,s1,80
    80002668:	b2bfd0ef          	jal	ra,80000192 <memmove>
    brelse(bp);
    8000266c:	854a                	mv	a0,s2
    8000266e:	9c7ff0ef          	jal	ra,80002034 <brelse>
    ip->valid = 1;
    80002672:	4785                	li	a5,1
    80002674:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002676:	04449783          	lh	a5,68(s1)
    8000267a:	f3d1                	bnez	a5,800025fe <ilock+0x20>
      panic("ilock: no type");
    8000267c:	00005517          	auipc	a0,0x5
    80002680:	e8450513          	addi	a0,a0,-380 # 80007500 <syscalls+0x170>
    80002684:	593020ef          	jal	ra,80005416 <panic>

0000000080002688 <iunlock>:
{
    80002688:	1101                	addi	sp,sp,-32
    8000268a:	ec06                	sd	ra,24(sp)
    8000268c:	e822                	sd	s0,16(sp)
    8000268e:	e426                	sd	s1,8(sp)
    80002690:	e04a                	sd	s2,0(sp)
    80002692:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002694:	c505                	beqz	a0,800026bc <iunlock+0x34>
    80002696:	84aa                	mv	s1,a0
    80002698:	01050913          	addi	s2,a0,16
    8000269c:	854a                	mv	a0,s2
    8000269e:	41b000ef          	jal	ra,800032b8 <holdingsleep>
    800026a2:	cd09                	beqz	a0,800026bc <iunlock+0x34>
    800026a4:	449c                	lw	a5,8(s1)
    800026a6:	00f05b63          	blez	a5,800026bc <iunlock+0x34>
  releasesleep(&ip->lock);
    800026aa:	854a                	mv	a0,s2
    800026ac:	3d5000ef          	jal	ra,80003280 <releasesleep>
}
    800026b0:	60e2                	ld	ra,24(sp)
    800026b2:	6442                	ld	s0,16(sp)
    800026b4:	64a2                	ld	s1,8(sp)
    800026b6:	6902                	ld	s2,0(sp)
    800026b8:	6105                	addi	sp,sp,32
    800026ba:	8082                	ret
    panic("iunlock");
    800026bc:	00005517          	auipc	a0,0x5
    800026c0:	e5450513          	addi	a0,a0,-428 # 80007510 <syscalls+0x180>
    800026c4:	553020ef          	jal	ra,80005416 <panic>

00000000800026c8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800026c8:	7179                	addi	sp,sp,-48
    800026ca:	f406                	sd	ra,40(sp)
    800026cc:	f022                	sd	s0,32(sp)
    800026ce:	ec26                	sd	s1,24(sp)
    800026d0:	e84a                	sd	s2,16(sp)
    800026d2:	e44e                	sd	s3,8(sp)
    800026d4:	e052                	sd	s4,0(sp)
    800026d6:	1800                	addi	s0,sp,48
    800026d8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800026da:	05050493          	addi	s1,a0,80
    800026de:	08050913          	addi	s2,a0,128
    800026e2:	a021                	j	800026ea <itrunc+0x22>
    800026e4:	0491                	addi	s1,s1,4
    800026e6:	01248b63          	beq	s1,s2,800026fc <itrunc+0x34>
    if(ip->addrs[i]){
    800026ea:	408c                	lw	a1,0(s1)
    800026ec:	dde5                	beqz	a1,800026e4 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800026ee:	0009a503          	lw	a0,0(s3)
    800026f2:	a35ff0ef          	jal	ra,80002126 <bfree>
      ip->addrs[i] = 0;
    800026f6:	0004a023          	sw	zero,0(s1)
    800026fa:	b7ed                	j	800026e4 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800026fc:	0809a583          	lw	a1,128(s3)
    80002700:	ed91                	bnez	a1,8000271c <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002702:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002706:	854e                	mv	a0,s3
    80002708:	e25ff0ef          	jal	ra,8000252c <iupdate>
}
    8000270c:	70a2                	ld	ra,40(sp)
    8000270e:	7402                	ld	s0,32(sp)
    80002710:	64e2                	ld	s1,24(sp)
    80002712:	6942                	ld	s2,16(sp)
    80002714:	69a2                	ld	s3,8(sp)
    80002716:	6a02                	ld	s4,0(sp)
    80002718:	6145                	addi	sp,sp,48
    8000271a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000271c:	0009a503          	lw	a0,0(s3)
    80002720:	80dff0ef          	jal	ra,80001f2c <bread>
    80002724:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002726:	05850493          	addi	s1,a0,88
    8000272a:	45850913          	addi	s2,a0,1112
    8000272e:	a801                	j	8000273e <itrunc+0x76>
        bfree(ip->dev, a[j]);
    80002730:	0009a503          	lw	a0,0(s3)
    80002734:	9f3ff0ef          	jal	ra,80002126 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002738:	0491                	addi	s1,s1,4
    8000273a:	01248563          	beq	s1,s2,80002744 <itrunc+0x7c>
      if(a[j])
    8000273e:	408c                	lw	a1,0(s1)
    80002740:	dde5                	beqz	a1,80002738 <itrunc+0x70>
    80002742:	b7fd                	j	80002730 <itrunc+0x68>
    brelse(bp);
    80002744:	8552                	mv	a0,s4
    80002746:	8efff0ef          	jal	ra,80002034 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000274a:	0809a583          	lw	a1,128(s3)
    8000274e:	0009a503          	lw	a0,0(s3)
    80002752:	9d5ff0ef          	jal	ra,80002126 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002756:	0809a023          	sw	zero,128(s3)
    8000275a:	b765                	j	80002702 <itrunc+0x3a>

000000008000275c <iput>:
{
    8000275c:	1101                	addi	sp,sp,-32
    8000275e:	ec06                	sd	ra,24(sp)
    80002760:	e822                	sd	s0,16(sp)
    80002762:	e426                	sd	s1,8(sp)
    80002764:	e04a                	sd	s2,0(sp)
    80002766:	1000                	addi	s0,sp,32
    80002768:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000276a:	00013517          	auipc	a0,0x13
    8000276e:	67e50513          	addi	a0,a0,1662 # 80015de8 <itable>
    80002772:	75f020ef          	jal	ra,800056d0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002776:	4498                	lw	a4,8(s1)
    80002778:	4785                	li	a5,1
    8000277a:	02f70163          	beq	a4,a5,8000279c <iput+0x40>
  ip->ref--;
    8000277e:	449c                	lw	a5,8(s1)
    80002780:	37fd                	addiw	a5,a5,-1
    80002782:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002784:	00013517          	auipc	a0,0x13
    80002788:	66450513          	addi	a0,a0,1636 # 80015de8 <itable>
    8000278c:	7dd020ef          	jal	ra,80005768 <release>
}
    80002790:	60e2                	ld	ra,24(sp)
    80002792:	6442                	ld	s0,16(sp)
    80002794:	64a2                	ld	s1,8(sp)
    80002796:	6902                	ld	s2,0(sp)
    80002798:	6105                	addi	sp,sp,32
    8000279a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000279c:	40bc                	lw	a5,64(s1)
    8000279e:	d3e5                	beqz	a5,8000277e <iput+0x22>
    800027a0:	04a49783          	lh	a5,74(s1)
    800027a4:	ffe9                	bnez	a5,8000277e <iput+0x22>
    acquiresleep(&ip->lock);
    800027a6:	01048913          	addi	s2,s1,16
    800027aa:	854a                	mv	a0,s2
    800027ac:	28f000ef          	jal	ra,8000323a <acquiresleep>
    release(&itable.lock);
    800027b0:	00013517          	auipc	a0,0x13
    800027b4:	63850513          	addi	a0,a0,1592 # 80015de8 <itable>
    800027b8:	7b1020ef          	jal	ra,80005768 <release>
    itrunc(ip);
    800027bc:	8526                	mv	a0,s1
    800027be:	f0bff0ef          	jal	ra,800026c8 <itrunc>
    ip->type = 0;
    800027c2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800027c6:	8526                	mv	a0,s1
    800027c8:	d65ff0ef          	jal	ra,8000252c <iupdate>
    ip->valid = 0;
    800027cc:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800027d0:	854a                	mv	a0,s2
    800027d2:	2af000ef          	jal	ra,80003280 <releasesleep>
    acquire(&itable.lock);
    800027d6:	00013517          	auipc	a0,0x13
    800027da:	61250513          	addi	a0,a0,1554 # 80015de8 <itable>
    800027de:	6f3020ef          	jal	ra,800056d0 <acquire>
    800027e2:	bf71                	j	8000277e <iput+0x22>

00000000800027e4 <iunlockput>:
{
    800027e4:	1101                	addi	sp,sp,-32
    800027e6:	ec06                	sd	ra,24(sp)
    800027e8:	e822                	sd	s0,16(sp)
    800027ea:	e426                	sd	s1,8(sp)
    800027ec:	1000                	addi	s0,sp,32
    800027ee:	84aa                	mv	s1,a0
  iunlock(ip);
    800027f0:	e99ff0ef          	jal	ra,80002688 <iunlock>
  iput(ip);
    800027f4:	8526                	mv	a0,s1
    800027f6:	f67ff0ef          	jal	ra,8000275c <iput>
}
    800027fa:	60e2                	ld	ra,24(sp)
    800027fc:	6442                	ld	s0,16(sp)
    800027fe:	64a2                	ld	s1,8(sp)
    80002800:	6105                	addi	sp,sp,32
    80002802:	8082                	ret

0000000080002804 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002804:	00013717          	auipc	a4,0x13
    80002808:	5d072703          	lw	a4,1488(a4) # 80015dd4 <sb+0xc>
    8000280c:	4785                	li	a5,1
    8000280e:	0ae7ff63          	bgeu	a5,a4,800028cc <ireclaim+0xc8>
{
    80002812:	7139                	addi	sp,sp,-64
    80002814:	fc06                	sd	ra,56(sp)
    80002816:	f822                	sd	s0,48(sp)
    80002818:	f426                	sd	s1,40(sp)
    8000281a:	f04a                	sd	s2,32(sp)
    8000281c:	ec4e                	sd	s3,24(sp)
    8000281e:	e852                	sd	s4,16(sp)
    80002820:	e456                	sd	s5,8(sp)
    80002822:	e05a                	sd	s6,0(sp)
    80002824:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002826:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002828:	00050a1b          	sext.w	s4,a0
    8000282c:	00013a97          	auipc	s5,0x13
    80002830:	59ca8a93          	addi	s5,s5,1436 # 80015dc8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80002834:	00005b17          	auipc	s6,0x5
    80002838:	ce4b0b13          	addi	s6,s6,-796 # 80007518 <syscalls+0x188>
    8000283c:	a099                	j	80002882 <ireclaim+0x7e>
    8000283e:	85ce                	mv	a1,s3
    80002840:	855a                	mv	a0,s6
    80002842:	10f020ef          	jal	ra,80005150 <printf>
      ip = iget(dev, inum);
    80002846:	85ce                	mv	a1,s3
    80002848:	8552                	mv	a0,s4
    8000284a:	b29ff0ef          	jal	ra,80002372 <iget>
    8000284e:	89aa                	mv	s3,a0
    brelse(bp);
    80002850:	854a                	mv	a0,s2
    80002852:	fe2ff0ef          	jal	ra,80002034 <brelse>
    if (ip) {
    80002856:	00098f63          	beqz	s3,80002874 <ireclaim+0x70>
      begin_op();
    8000285a:	762000ef          	jal	ra,80002fbc <begin_op>
      ilock(ip);
    8000285e:	854e                	mv	a0,s3
    80002860:	d7fff0ef          	jal	ra,800025de <ilock>
      iunlock(ip);
    80002864:	854e                	mv	a0,s3
    80002866:	e23ff0ef          	jal	ra,80002688 <iunlock>
      iput(ip);
    8000286a:	854e                	mv	a0,s3
    8000286c:	ef1ff0ef          	jal	ra,8000275c <iput>
      end_op();
    80002870:	7bc000ef          	jal	ra,8000302c <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002874:	0485                	addi	s1,s1,1
    80002876:	00caa703          	lw	a4,12(s5)
    8000287a:	0004879b          	sext.w	a5,s1
    8000287e:	02e7fd63          	bgeu	a5,a4,800028b8 <ireclaim+0xb4>
    80002882:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002886:	0044d593          	srli	a1,s1,0x4
    8000288a:	018aa783          	lw	a5,24(s5)
    8000288e:	9dbd                	addw	a1,a1,a5
    80002890:	8552                	mv	a0,s4
    80002892:	e9aff0ef          	jal	ra,80001f2c <bread>
    80002896:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002898:	05850793          	addi	a5,a0,88
    8000289c:	00f9f713          	andi	a4,s3,15
    800028a0:	071a                	slli	a4,a4,0x6
    800028a2:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800028a4:	00079703          	lh	a4,0(a5)
    800028a8:	c701                	beqz	a4,800028b0 <ireclaim+0xac>
    800028aa:	00679783          	lh	a5,6(a5)
    800028ae:	dbc1                	beqz	a5,8000283e <ireclaim+0x3a>
    brelse(bp);
    800028b0:	854a                	mv	a0,s2
    800028b2:	f82ff0ef          	jal	ra,80002034 <brelse>
    if (ip) {
    800028b6:	bf7d                	j	80002874 <ireclaim+0x70>
}
    800028b8:	70e2                	ld	ra,56(sp)
    800028ba:	7442                	ld	s0,48(sp)
    800028bc:	74a2                	ld	s1,40(sp)
    800028be:	7902                	ld	s2,32(sp)
    800028c0:	69e2                	ld	s3,24(sp)
    800028c2:	6a42                	ld	s4,16(sp)
    800028c4:	6aa2                	ld	s5,8(sp)
    800028c6:	6b02                	ld	s6,0(sp)
    800028c8:	6121                	addi	sp,sp,64
    800028ca:	8082                	ret
    800028cc:	8082                	ret

00000000800028ce <fsinit>:
fsinit(int dev) {
    800028ce:	7179                	addi	sp,sp,-48
    800028d0:	f406                	sd	ra,40(sp)
    800028d2:	f022                	sd	s0,32(sp)
    800028d4:	ec26                	sd	s1,24(sp)
    800028d6:	e84a                	sd	s2,16(sp)
    800028d8:	e44e                	sd	s3,8(sp)
    800028da:	1800                	addi	s0,sp,48
    800028dc:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    800028de:	4585                	li	a1,1
    800028e0:	e4cff0ef          	jal	ra,80001f2c <bread>
    800028e4:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028e6:	00013997          	auipc	s3,0x13
    800028ea:	4e298993          	addi	s3,s3,1250 # 80015dc8 <sb>
    800028ee:	02000613          	li	a2,32
    800028f2:	05850593          	addi	a1,a0,88
    800028f6:	854e                	mv	a0,s3
    800028f8:	89bfd0ef          	jal	ra,80000192 <memmove>
  brelse(bp);
    800028fc:	854a                	mv	a0,s2
    800028fe:	f36ff0ef          	jal	ra,80002034 <brelse>
  if(sb.magic != FSMAGIC)
    80002902:	0009a703          	lw	a4,0(s3)
    80002906:	102037b7          	lui	a5,0x10203
    8000290a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000290e:	02f71363          	bne	a4,a5,80002934 <fsinit+0x66>
  initlog(dev, &sb);
    80002912:	00013597          	auipc	a1,0x13
    80002916:	4b658593          	addi	a1,a1,1206 # 80015dc8 <sb>
    8000291a:	8526                	mv	a0,s1
    8000291c:	616000ef          	jal	ra,80002f32 <initlog>
  ireclaim(dev);
    80002920:	8526                	mv	a0,s1
    80002922:	ee3ff0ef          	jal	ra,80002804 <ireclaim>
}
    80002926:	70a2                	ld	ra,40(sp)
    80002928:	7402                	ld	s0,32(sp)
    8000292a:	64e2                	ld	s1,24(sp)
    8000292c:	6942                	ld	s2,16(sp)
    8000292e:	69a2                	ld	s3,8(sp)
    80002930:	6145                	addi	sp,sp,48
    80002932:	8082                	ret
    panic("invalid file system");
    80002934:	00005517          	auipc	a0,0x5
    80002938:	c0450513          	addi	a0,a0,-1020 # 80007538 <syscalls+0x1a8>
    8000293c:	2db020ef          	jal	ra,80005416 <panic>

0000000080002940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002940:	1141                	addi	sp,sp,-16
    80002942:	e422                	sd	s0,8(sp)
    80002944:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002946:	411c                	lw	a5,0(a0)
    80002948:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000294a:	415c                	lw	a5,4(a0)
    8000294c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000294e:	04451783          	lh	a5,68(a0)
    80002952:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002956:	04a51783          	lh	a5,74(a0)
    8000295a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000295e:	04c56783          	lwu	a5,76(a0)
    80002962:	e99c                	sd	a5,16(a1)
}
    80002964:	6422                	ld	s0,8(sp)
    80002966:	0141                	addi	sp,sp,16
    80002968:	8082                	ret

000000008000296a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000296a:	457c                	lw	a5,76(a0)
    8000296c:	0cd7ef63          	bltu	a5,a3,80002a4a <readi+0xe0>
{
    80002970:	7159                	addi	sp,sp,-112
    80002972:	f486                	sd	ra,104(sp)
    80002974:	f0a2                	sd	s0,96(sp)
    80002976:	eca6                	sd	s1,88(sp)
    80002978:	e8ca                	sd	s2,80(sp)
    8000297a:	e4ce                	sd	s3,72(sp)
    8000297c:	e0d2                	sd	s4,64(sp)
    8000297e:	fc56                	sd	s5,56(sp)
    80002980:	f85a                	sd	s6,48(sp)
    80002982:	f45e                	sd	s7,40(sp)
    80002984:	f062                	sd	s8,32(sp)
    80002986:	ec66                	sd	s9,24(sp)
    80002988:	e86a                	sd	s10,16(sp)
    8000298a:	e46e                	sd	s11,8(sp)
    8000298c:	1880                	addi	s0,sp,112
    8000298e:	8b2a                	mv	s6,a0
    80002990:	8bae                	mv	s7,a1
    80002992:	8a32                	mv	s4,a2
    80002994:	84b6                	mv	s1,a3
    80002996:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002998:	9f35                	addw	a4,a4,a3
    return 0;
    8000299a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000299c:	08d76663          	bltu	a4,a3,80002a28 <readi+0xbe>
  if(off + n > ip->size)
    800029a0:	00e7f463          	bgeu	a5,a4,800029a8 <readi+0x3e>
    n = ip->size - off;
    800029a4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029a8:	080a8f63          	beqz	s5,80002a46 <readi+0xdc>
    800029ac:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800029ae:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800029b2:	5c7d                	li	s8,-1
    800029b4:	a80d                	j	800029e6 <readi+0x7c>
    800029b6:	020d1d93          	slli	s11,s10,0x20
    800029ba:	020ddd93          	srli	s11,s11,0x20
    800029be:	05890613          	addi	a2,s2,88
    800029c2:	86ee                	mv	a3,s11
    800029c4:	963a                	add	a2,a2,a4
    800029c6:	85d2                	mv	a1,s4
    800029c8:	855e                	mv	a0,s7
    800029ca:	c9bfe0ef          	jal	ra,80001664 <either_copyout>
    800029ce:	05850763          	beq	a0,s8,80002a1c <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800029d2:	854a                	mv	a0,s2
    800029d4:	e60ff0ef          	jal	ra,80002034 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029d8:	013d09bb          	addw	s3,s10,s3
    800029dc:	009d04bb          	addw	s1,s10,s1
    800029e0:	9a6e                	add	s4,s4,s11
    800029e2:	0559f163          	bgeu	s3,s5,80002a24 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    800029e6:	00a4d59b          	srliw	a1,s1,0xa
    800029ea:	855a                	mv	a0,s6
    800029ec:	8bbff0ef          	jal	ra,800022a6 <bmap>
    800029f0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800029f4:	c985                	beqz	a1,80002a24 <readi+0xba>
    bp = bread(ip->dev, addr);
    800029f6:	000b2503          	lw	a0,0(s6)
    800029fa:	d32ff0ef          	jal	ra,80001f2c <bread>
    800029fe:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a00:	3ff4f713          	andi	a4,s1,1023
    80002a04:	40ec87bb          	subw	a5,s9,a4
    80002a08:	413a86bb          	subw	a3,s5,s3
    80002a0c:	8d3e                	mv	s10,a5
    80002a0e:	2781                	sext.w	a5,a5
    80002a10:	0006861b          	sext.w	a2,a3
    80002a14:	faf671e3          	bgeu	a2,a5,800029b6 <readi+0x4c>
    80002a18:	8d36                	mv	s10,a3
    80002a1a:	bf71                	j	800029b6 <readi+0x4c>
      brelse(bp);
    80002a1c:	854a                	mv	a0,s2
    80002a1e:	e16ff0ef          	jal	ra,80002034 <brelse>
      tot = -1;
    80002a22:	59fd                	li	s3,-1
  }
  return tot;
    80002a24:	0009851b          	sext.w	a0,s3
}
    80002a28:	70a6                	ld	ra,104(sp)
    80002a2a:	7406                	ld	s0,96(sp)
    80002a2c:	64e6                	ld	s1,88(sp)
    80002a2e:	6946                	ld	s2,80(sp)
    80002a30:	69a6                	ld	s3,72(sp)
    80002a32:	6a06                	ld	s4,64(sp)
    80002a34:	7ae2                	ld	s5,56(sp)
    80002a36:	7b42                	ld	s6,48(sp)
    80002a38:	7ba2                	ld	s7,40(sp)
    80002a3a:	7c02                	ld	s8,32(sp)
    80002a3c:	6ce2                	ld	s9,24(sp)
    80002a3e:	6d42                	ld	s10,16(sp)
    80002a40:	6da2                	ld	s11,8(sp)
    80002a42:	6165                	addi	sp,sp,112
    80002a44:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a46:	89d6                	mv	s3,s5
    80002a48:	bff1                	j	80002a24 <readi+0xba>
    return 0;
    80002a4a:	4501                	li	a0,0
}
    80002a4c:	8082                	ret

0000000080002a4e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a4e:	457c                	lw	a5,76(a0)
    80002a50:	0ed7ea63          	bltu	a5,a3,80002b44 <writei+0xf6>
{
    80002a54:	7159                	addi	sp,sp,-112
    80002a56:	f486                	sd	ra,104(sp)
    80002a58:	f0a2                	sd	s0,96(sp)
    80002a5a:	eca6                	sd	s1,88(sp)
    80002a5c:	e8ca                	sd	s2,80(sp)
    80002a5e:	e4ce                	sd	s3,72(sp)
    80002a60:	e0d2                	sd	s4,64(sp)
    80002a62:	fc56                	sd	s5,56(sp)
    80002a64:	f85a                	sd	s6,48(sp)
    80002a66:	f45e                	sd	s7,40(sp)
    80002a68:	f062                	sd	s8,32(sp)
    80002a6a:	ec66                	sd	s9,24(sp)
    80002a6c:	e86a                	sd	s10,16(sp)
    80002a6e:	e46e                	sd	s11,8(sp)
    80002a70:	1880                	addi	s0,sp,112
    80002a72:	8aaa                	mv	s5,a0
    80002a74:	8bae                	mv	s7,a1
    80002a76:	8a32                	mv	s4,a2
    80002a78:	8936                	mv	s2,a3
    80002a7a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002a7c:	00e687bb          	addw	a5,a3,a4
    80002a80:	0cd7e463          	bltu	a5,a3,80002b48 <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002a84:	00043737          	lui	a4,0x43
    80002a88:	0cf76263          	bltu	a4,a5,80002b4c <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a8c:	0a0b0a63          	beqz	s6,80002b40 <writei+0xf2>
    80002a90:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a92:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002a96:	5c7d                	li	s8,-1
    80002a98:	a825                	j	80002ad0 <writei+0x82>
    80002a9a:	020d1d93          	slli	s11,s10,0x20
    80002a9e:	020ddd93          	srli	s11,s11,0x20
    80002aa2:	05848513          	addi	a0,s1,88
    80002aa6:	86ee                	mv	a3,s11
    80002aa8:	8652                	mv	a2,s4
    80002aaa:	85de                	mv	a1,s7
    80002aac:	953a                	add	a0,a0,a4
    80002aae:	c01fe0ef          	jal	ra,800016ae <either_copyin>
    80002ab2:	05850a63          	beq	a0,s8,80002b06 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ab6:	8526                	mv	a0,s1
    80002ab8:	688000ef          	jal	ra,80003140 <log_write>
    brelse(bp);
    80002abc:	8526                	mv	a0,s1
    80002abe:	d76ff0ef          	jal	ra,80002034 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ac2:	013d09bb          	addw	s3,s10,s3
    80002ac6:	012d093b          	addw	s2,s10,s2
    80002aca:	9a6e                	add	s4,s4,s11
    80002acc:	0569f063          	bgeu	s3,s6,80002b0c <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002ad0:	00a9559b          	srliw	a1,s2,0xa
    80002ad4:	8556                	mv	a0,s5
    80002ad6:	fd0ff0ef          	jal	ra,800022a6 <bmap>
    80002ada:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002ade:	c59d                	beqz	a1,80002b0c <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002ae0:	000aa503          	lw	a0,0(s5)
    80002ae4:	c48ff0ef          	jal	ra,80001f2c <bread>
    80002ae8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002aea:	3ff97713          	andi	a4,s2,1023
    80002aee:	40ec87bb          	subw	a5,s9,a4
    80002af2:	413b06bb          	subw	a3,s6,s3
    80002af6:	8d3e                	mv	s10,a5
    80002af8:	2781                	sext.w	a5,a5
    80002afa:	0006861b          	sext.w	a2,a3
    80002afe:	f8f67ee3          	bgeu	a2,a5,80002a9a <writei+0x4c>
    80002b02:	8d36                	mv	s10,a3
    80002b04:	bf59                	j	80002a9a <writei+0x4c>
      brelse(bp);
    80002b06:	8526                	mv	a0,s1
    80002b08:	d2cff0ef          	jal	ra,80002034 <brelse>
  }

  if(off > ip->size)
    80002b0c:	04caa783          	lw	a5,76(s5)
    80002b10:	0127f463          	bgeu	a5,s2,80002b18 <writei+0xca>
    ip->size = off;
    80002b14:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b18:	8556                	mv	a0,s5
    80002b1a:	a13ff0ef          	jal	ra,8000252c <iupdate>

  return tot;
    80002b1e:	0009851b          	sext.w	a0,s3
}
    80002b22:	70a6                	ld	ra,104(sp)
    80002b24:	7406                	ld	s0,96(sp)
    80002b26:	64e6                	ld	s1,88(sp)
    80002b28:	6946                	ld	s2,80(sp)
    80002b2a:	69a6                	ld	s3,72(sp)
    80002b2c:	6a06                	ld	s4,64(sp)
    80002b2e:	7ae2                	ld	s5,56(sp)
    80002b30:	7b42                	ld	s6,48(sp)
    80002b32:	7ba2                	ld	s7,40(sp)
    80002b34:	7c02                	ld	s8,32(sp)
    80002b36:	6ce2                	ld	s9,24(sp)
    80002b38:	6d42                	ld	s10,16(sp)
    80002b3a:	6da2                	ld	s11,8(sp)
    80002b3c:	6165                	addi	sp,sp,112
    80002b3e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b40:	89da                	mv	s3,s6
    80002b42:	bfd9                	j	80002b18 <writei+0xca>
    return -1;
    80002b44:	557d                	li	a0,-1
}
    80002b46:	8082                	ret
    return -1;
    80002b48:	557d                	li	a0,-1
    80002b4a:	bfe1                	j	80002b22 <writei+0xd4>
    return -1;
    80002b4c:	557d                	li	a0,-1
    80002b4e:	bfd1                	j	80002b22 <writei+0xd4>

0000000080002b50 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002b50:	1141                	addi	sp,sp,-16
    80002b52:	e406                	sd	ra,8(sp)
    80002b54:	e022                	sd	s0,0(sp)
    80002b56:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002b58:	4639                	li	a2,14
    80002b5a:	eacfd0ef          	jal	ra,80000206 <strncmp>
}
    80002b5e:	60a2                	ld	ra,8(sp)
    80002b60:	6402                	ld	s0,0(sp)
    80002b62:	0141                	addi	sp,sp,16
    80002b64:	8082                	ret

0000000080002b66 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002b66:	7139                	addi	sp,sp,-64
    80002b68:	fc06                	sd	ra,56(sp)
    80002b6a:	f822                	sd	s0,48(sp)
    80002b6c:	f426                	sd	s1,40(sp)
    80002b6e:	f04a                	sd	s2,32(sp)
    80002b70:	ec4e                	sd	s3,24(sp)
    80002b72:	e852                	sd	s4,16(sp)
    80002b74:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002b76:	04451703          	lh	a4,68(a0)
    80002b7a:	4785                	li	a5,1
    80002b7c:	00f71a63          	bne	a4,a5,80002b90 <dirlookup+0x2a>
    80002b80:	892a                	mv	s2,a0
    80002b82:	89ae                	mv	s3,a1
    80002b84:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002b86:	457c                	lw	a5,76(a0)
    80002b88:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002b8a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002b8c:	e39d                	bnez	a5,80002bb2 <dirlookup+0x4c>
    80002b8e:	a095                	j	80002bf2 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002b90:	00005517          	auipc	a0,0x5
    80002b94:	9c050513          	addi	a0,a0,-1600 # 80007550 <syscalls+0x1c0>
    80002b98:	07f020ef          	jal	ra,80005416 <panic>
      panic("dirlookup read");
    80002b9c:	00005517          	auipc	a0,0x5
    80002ba0:	9cc50513          	addi	a0,a0,-1588 # 80007568 <syscalls+0x1d8>
    80002ba4:	073020ef          	jal	ra,80005416 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ba8:	24c1                	addiw	s1,s1,16
    80002baa:	04c92783          	lw	a5,76(s2)
    80002bae:	04f4f163          	bgeu	s1,a5,80002bf0 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002bb2:	4741                	li	a4,16
    80002bb4:	86a6                	mv	a3,s1
    80002bb6:	fc040613          	addi	a2,s0,-64
    80002bba:	4581                	li	a1,0
    80002bbc:	854a                	mv	a0,s2
    80002bbe:	dadff0ef          	jal	ra,8000296a <readi>
    80002bc2:	47c1                	li	a5,16
    80002bc4:	fcf51ce3          	bne	a0,a5,80002b9c <dirlookup+0x36>
    if(de.inum == 0)
    80002bc8:	fc045783          	lhu	a5,-64(s0)
    80002bcc:	dff1                	beqz	a5,80002ba8 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002bce:	fc240593          	addi	a1,s0,-62
    80002bd2:	854e                	mv	a0,s3
    80002bd4:	f7dff0ef          	jal	ra,80002b50 <namecmp>
    80002bd8:	f961                	bnez	a0,80002ba8 <dirlookup+0x42>
      if(poff)
    80002bda:	000a0463          	beqz	s4,80002be2 <dirlookup+0x7c>
        *poff = off;
    80002bde:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002be2:	fc045583          	lhu	a1,-64(s0)
    80002be6:	00092503          	lw	a0,0(s2)
    80002bea:	f88ff0ef          	jal	ra,80002372 <iget>
    80002bee:	a011                	j	80002bf2 <dirlookup+0x8c>
  return 0;
    80002bf0:	4501                	li	a0,0
}
    80002bf2:	70e2                	ld	ra,56(sp)
    80002bf4:	7442                	ld	s0,48(sp)
    80002bf6:	74a2                	ld	s1,40(sp)
    80002bf8:	7902                	ld	s2,32(sp)
    80002bfa:	69e2                	ld	s3,24(sp)
    80002bfc:	6a42                	ld	s4,16(sp)
    80002bfe:	6121                	addi	sp,sp,64
    80002c00:	8082                	ret

0000000080002c02 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002c02:	711d                	addi	sp,sp,-96
    80002c04:	ec86                	sd	ra,88(sp)
    80002c06:	e8a2                	sd	s0,80(sp)
    80002c08:	e4a6                	sd	s1,72(sp)
    80002c0a:	e0ca                	sd	s2,64(sp)
    80002c0c:	fc4e                	sd	s3,56(sp)
    80002c0e:	f852                	sd	s4,48(sp)
    80002c10:	f456                	sd	s5,40(sp)
    80002c12:	f05a                	sd	s6,32(sp)
    80002c14:	ec5e                	sd	s7,24(sp)
    80002c16:	e862                	sd	s8,16(sp)
    80002c18:	e466                	sd	s9,8(sp)
    80002c1a:	1080                	addi	s0,sp,96
    80002c1c:	84aa                	mv	s1,a0
    80002c1e:	8b2e                	mv	s6,a1
    80002c20:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002c22:	00054703          	lbu	a4,0(a0)
    80002c26:	02f00793          	li	a5,47
    80002c2a:	00f70f63          	beq	a4,a5,80002c48 <namex+0x46>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002c2e:	8e8fe0ef          	jal	ra,80000d16 <myproc>
    80002c32:	15053503          	ld	a0,336(a0)
    80002c36:	973ff0ef          	jal	ra,800025a8 <idup>
    80002c3a:	89aa                	mv	s3,a0
  while(*path == '/')
    80002c3c:	02f00913          	li	s2,47
  len = path - s;
    80002c40:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80002c42:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002c44:	4c05                	li	s8,1
    80002c46:	a861                	j	80002cde <namex+0xdc>
    ip = iget(ROOTDEV, ROOTINO);
    80002c48:	4585                	li	a1,1
    80002c4a:	4505                	li	a0,1
    80002c4c:	f26ff0ef          	jal	ra,80002372 <iget>
    80002c50:	89aa                	mv	s3,a0
    80002c52:	b7ed                	j	80002c3c <namex+0x3a>
      iunlockput(ip);
    80002c54:	854e                	mv	a0,s3
    80002c56:	b8fff0ef          	jal	ra,800027e4 <iunlockput>
      return 0;
    80002c5a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002c5c:	854e                	mv	a0,s3
    80002c5e:	60e6                	ld	ra,88(sp)
    80002c60:	6446                	ld	s0,80(sp)
    80002c62:	64a6                	ld	s1,72(sp)
    80002c64:	6906                	ld	s2,64(sp)
    80002c66:	79e2                	ld	s3,56(sp)
    80002c68:	7a42                	ld	s4,48(sp)
    80002c6a:	7aa2                	ld	s5,40(sp)
    80002c6c:	7b02                	ld	s6,32(sp)
    80002c6e:	6be2                	ld	s7,24(sp)
    80002c70:	6c42                	ld	s8,16(sp)
    80002c72:	6ca2                	ld	s9,8(sp)
    80002c74:	6125                	addi	sp,sp,96
    80002c76:	8082                	ret
      iunlock(ip);
    80002c78:	854e                	mv	a0,s3
    80002c7a:	a0fff0ef          	jal	ra,80002688 <iunlock>
      return ip;
    80002c7e:	bff9                	j	80002c5c <namex+0x5a>
      iunlockput(ip);
    80002c80:	854e                	mv	a0,s3
    80002c82:	b63ff0ef          	jal	ra,800027e4 <iunlockput>
      return 0;
    80002c86:	89d2                	mv	s3,s4
    80002c88:	bfd1                	j	80002c5c <namex+0x5a>
  len = path - s;
    80002c8a:	40b48633          	sub	a2,s1,a1
    80002c8e:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80002c92:	074cdc63          	bge	s9,s4,80002d0a <namex+0x108>
    memmove(name, s, DIRSIZ);
    80002c96:	4639                	li	a2,14
    80002c98:	8556                	mv	a0,s5
    80002c9a:	cf8fd0ef          	jal	ra,80000192 <memmove>
  while(*path == '/')
    80002c9e:	0004c783          	lbu	a5,0(s1)
    80002ca2:	01279763          	bne	a5,s2,80002cb0 <namex+0xae>
    path++;
    80002ca6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002ca8:	0004c783          	lbu	a5,0(s1)
    80002cac:	ff278de3          	beq	a5,s2,80002ca6 <namex+0xa4>
    ilock(ip);
    80002cb0:	854e                	mv	a0,s3
    80002cb2:	92dff0ef          	jal	ra,800025de <ilock>
    if(ip->type != T_DIR){
    80002cb6:	04499783          	lh	a5,68(s3)
    80002cba:	f9879de3          	bne	a5,s8,80002c54 <namex+0x52>
    if(nameiparent && *path == '\0'){
    80002cbe:	000b0563          	beqz	s6,80002cc8 <namex+0xc6>
    80002cc2:	0004c783          	lbu	a5,0(s1)
    80002cc6:	dbcd                	beqz	a5,80002c78 <namex+0x76>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002cc8:	865e                	mv	a2,s7
    80002cca:	85d6                	mv	a1,s5
    80002ccc:	854e                	mv	a0,s3
    80002cce:	e99ff0ef          	jal	ra,80002b66 <dirlookup>
    80002cd2:	8a2a                	mv	s4,a0
    80002cd4:	d555                	beqz	a0,80002c80 <namex+0x7e>
    iunlockput(ip);
    80002cd6:	854e                	mv	a0,s3
    80002cd8:	b0dff0ef          	jal	ra,800027e4 <iunlockput>
    ip = next;
    80002cdc:	89d2                	mv	s3,s4
  while(*path == '/')
    80002cde:	0004c783          	lbu	a5,0(s1)
    80002ce2:	05279363          	bne	a5,s2,80002d28 <namex+0x126>
    path++;
    80002ce6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002ce8:	0004c783          	lbu	a5,0(s1)
    80002cec:	ff278de3          	beq	a5,s2,80002ce6 <namex+0xe4>
  if(*path == 0)
    80002cf0:	c78d                	beqz	a5,80002d1a <namex+0x118>
    path++;
    80002cf2:	85a6                	mv	a1,s1
  len = path - s;
    80002cf4:	8a5e                	mv	s4,s7
    80002cf6:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80002cf8:	01278963          	beq	a5,s2,80002d0a <namex+0x108>
    80002cfc:	d7d9                	beqz	a5,80002c8a <namex+0x88>
    path++;
    80002cfe:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80002d00:	0004c783          	lbu	a5,0(s1)
    80002d04:	ff279ce3          	bne	a5,s2,80002cfc <namex+0xfa>
    80002d08:	b749                	j	80002c8a <namex+0x88>
    memmove(name, s, len);
    80002d0a:	2601                	sext.w	a2,a2
    80002d0c:	8556                	mv	a0,s5
    80002d0e:	c84fd0ef          	jal	ra,80000192 <memmove>
    name[len] = 0;
    80002d12:	9a56                	add	s4,s4,s5
    80002d14:	000a0023          	sb	zero,0(s4)
    80002d18:	b759                	j	80002c9e <namex+0x9c>
  if(nameiparent){
    80002d1a:	f40b01e3          	beqz	s6,80002c5c <namex+0x5a>
    iput(ip);
    80002d1e:	854e                	mv	a0,s3
    80002d20:	a3dff0ef          	jal	ra,8000275c <iput>
    return 0;
    80002d24:	4981                	li	s3,0
    80002d26:	bf1d                	j	80002c5c <namex+0x5a>
  if(*path == 0)
    80002d28:	dbed                	beqz	a5,80002d1a <namex+0x118>
  while(*path != '/' && *path != 0)
    80002d2a:	0004c783          	lbu	a5,0(s1)
    80002d2e:	85a6                	mv	a1,s1
    80002d30:	b7f1                	j	80002cfc <namex+0xfa>

0000000080002d32 <dirlink>:
{
    80002d32:	7139                	addi	sp,sp,-64
    80002d34:	fc06                	sd	ra,56(sp)
    80002d36:	f822                	sd	s0,48(sp)
    80002d38:	f426                	sd	s1,40(sp)
    80002d3a:	f04a                	sd	s2,32(sp)
    80002d3c:	ec4e                	sd	s3,24(sp)
    80002d3e:	e852                	sd	s4,16(sp)
    80002d40:	0080                	addi	s0,sp,64
    80002d42:	892a                	mv	s2,a0
    80002d44:	8a2e                	mv	s4,a1
    80002d46:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002d48:	4601                	li	a2,0
    80002d4a:	e1dff0ef          	jal	ra,80002b66 <dirlookup>
    80002d4e:	e52d                	bnez	a0,80002db8 <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d50:	04c92483          	lw	s1,76(s2)
    80002d54:	c48d                	beqz	s1,80002d7e <dirlink+0x4c>
    80002d56:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d58:	4741                	li	a4,16
    80002d5a:	86a6                	mv	a3,s1
    80002d5c:	fc040613          	addi	a2,s0,-64
    80002d60:	4581                	li	a1,0
    80002d62:	854a                	mv	a0,s2
    80002d64:	c07ff0ef          	jal	ra,8000296a <readi>
    80002d68:	47c1                	li	a5,16
    80002d6a:	04f51b63          	bne	a0,a5,80002dc0 <dirlink+0x8e>
    if(de.inum == 0)
    80002d6e:	fc045783          	lhu	a5,-64(s0)
    80002d72:	c791                	beqz	a5,80002d7e <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d74:	24c1                	addiw	s1,s1,16
    80002d76:	04c92783          	lw	a5,76(s2)
    80002d7a:	fcf4efe3          	bltu	s1,a5,80002d58 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002d7e:	4639                	li	a2,14
    80002d80:	85d2                	mv	a1,s4
    80002d82:	fc240513          	addi	a0,s0,-62
    80002d86:	cbcfd0ef          	jal	ra,80000242 <strncpy>
  de.inum = inum;
    80002d8a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d8e:	4741                	li	a4,16
    80002d90:	86a6                	mv	a3,s1
    80002d92:	fc040613          	addi	a2,s0,-64
    80002d96:	4581                	li	a1,0
    80002d98:	854a                	mv	a0,s2
    80002d9a:	cb5ff0ef          	jal	ra,80002a4e <writei>
    80002d9e:	1541                	addi	a0,a0,-16
    80002da0:	00a03533          	snez	a0,a0
    80002da4:	40a00533          	neg	a0,a0
}
    80002da8:	70e2                	ld	ra,56(sp)
    80002daa:	7442                	ld	s0,48(sp)
    80002dac:	74a2                	ld	s1,40(sp)
    80002dae:	7902                	ld	s2,32(sp)
    80002db0:	69e2                	ld	s3,24(sp)
    80002db2:	6a42                	ld	s4,16(sp)
    80002db4:	6121                	addi	sp,sp,64
    80002db6:	8082                	ret
    iput(ip);
    80002db8:	9a5ff0ef          	jal	ra,8000275c <iput>
    return -1;
    80002dbc:	557d                	li	a0,-1
    80002dbe:	b7ed                	j	80002da8 <dirlink+0x76>
      panic("dirlink read");
    80002dc0:	00004517          	auipc	a0,0x4
    80002dc4:	7b850513          	addi	a0,a0,1976 # 80007578 <syscalls+0x1e8>
    80002dc8:	64e020ef          	jal	ra,80005416 <panic>

0000000080002dcc <namei>:

struct inode*
namei(char *path)
{
    80002dcc:	1101                	addi	sp,sp,-32
    80002dce:	ec06                	sd	ra,24(sp)
    80002dd0:	e822                	sd	s0,16(sp)
    80002dd2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002dd4:	fe040613          	addi	a2,s0,-32
    80002dd8:	4581                	li	a1,0
    80002dda:	e29ff0ef          	jal	ra,80002c02 <namex>
}
    80002dde:	60e2                	ld	ra,24(sp)
    80002de0:	6442                	ld	s0,16(sp)
    80002de2:	6105                	addi	sp,sp,32
    80002de4:	8082                	ret

0000000080002de6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002de6:	1141                	addi	sp,sp,-16
    80002de8:	e406                	sd	ra,8(sp)
    80002dea:	e022                	sd	s0,0(sp)
    80002dec:	0800                	addi	s0,sp,16
    80002dee:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002df0:	4585                	li	a1,1
    80002df2:	e11ff0ef          	jal	ra,80002c02 <namex>
}
    80002df6:	60a2                	ld	ra,8(sp)
    80002df8:	6402                	ld	s0,0(sp)
    80002dfa:	0141                	addi	sp,sp,16
    80002dfc:	8082                	ret

0000000080002dfe <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002dfe:	1101                	addi	sp,sp,-32
    80002e00:	ec06                	sd	ra,24(sp)
    80002e02:	e822                	sd	s0,16(sp)
    80002e04:	e426                	sd	s1,8(sp)
    80002e06:	e04a                	sd	s2,0(sp)
    80002e08:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e0a:	00015917          	auipc	s2,0x15
    80002e0e:	a8690913          	addi	s2,s2,-1402 # 80017890 <log>
    80002e12:	01892583          	lw	a1,24(s2)
    80002e16:	02492503          	lw	a0,36(s2)
    80002e1a:	912ff0ef          	jal	ra,80001f2c <bread>
    80002e1e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002e20:	02892683          	lw	a3,40(s2)
    80002e24:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002e26:	02d05763          	blez	a3,80002e54 <write_head+0x56>
    80002e2a:	00015797          	auipc	a5,0x15
    80002e2e:	a9278793          	addi	a5,a5,-1390 # 800178bc <log+0x2c>
    80002e32:	05c50713          	addi	a4,a0,92
    80002e36:	36fd                	addiw	a3,a3,-1
    80002e38:	1682                	slli	a3,a3,0x20
    80002e3a:	9281                	srli	a3,a3,0x20
    80002e3c:	068a                	slli	a3,a3,0x2
    80002e3e:	00015617          	auipc	a2,0x15
    80002e42:	a8260613          	addi	a2,a2,-1406 # 800178c0 <log+0x30>
    80002e46:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80002e48:	4390                	lw	a2,0(a5)
    80002e4a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002e4c:	0791                	addi	a5,a5,4
    80002e4e:	0711                	addi	a4,a4,4
    80002e50:	fed79ce3          	bne	a5,a3,80002e48 <write_head+0x4a>
  }
  bwrite(buf);
    80002e54:	8526                	mv	a0,s1
    80002e56:	9acff0ef          	jal	ra,80002002 <bwrite>
  brelse(buf);
    80002e5a:	8526                	mv	a0,s1
    80002e5c:	9d8ff0ef          	jal	ra,80002034 <brelse>
}
    80002e60:	60e2                	ld	ra,24(sp)
    80002e62:	6442                	ld	s0,16(sp)
    80002e64:	64a2                	ld	s1,8(sp)
    80002e66:	6902                	ld	s2,0(sp)
    80002e68:	6105                	addi	sp,sp,32
    80002e6a:	8082                	ret

0000000080002e6c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e6c:	00015797          	auipc	a5,0x15
    80002e70:	a4c7a783          	lw	a5,-1460(a5) # 800178b8 <log+0x28>
    80002e74:	0af05e63          	blez	a5,80002f30 <install_trans+0xc4>
{
    80002e78:	715d                	addi	sp,sp,-80
    80002e7a:	e486                	sd	ra,72(sp)
    80002e7c:	e0a2                	sd	s0,64(sp)
    80002e7e:	fc26                	sd	s1,56(sp)
    80002e80:	f84a                	sd	s2,48(sp)
    80002e82:	f44e                	sd	s3,40(sp)
    80002e84:	f052                	sd	s4,32(sp)
    80002e86:	ec56                	sd	s5,24(sp)
    80002e88:	e85a                	sd	s6,16(sp)
    80002e8a:	e45e                	sd	s7,8(sp)
    80002e8c:	0880                	addi	s0,sp,80
    80002e8e:	8b2a                	mv	s6,a0
    80002e90:	00015a97          	auipc	s5,0x15
    80002e94:	a2ca8a93          	addi	s5,s5,-1492 # 800178bc <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e98:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002e9a:	00004b97          	auipc	s7,0x4
    80002e9e:	6eeb8b93          	addi	s7,s7,1774 # 80007588 <syscalls+0x1f8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ea2:	00015a17          	auipc	s4,0x15
    80002ea6:	9eea0a13          	addi	s4,s4,-1554 # 80017890 <log>
    80002eaa:	a03d                	j	80002ed8 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002eac:	000aa603          	lw	a2,0(s5)
    80002eb0:	85ce                	mv	a1,s3
    80002eb2:	855e                	mv	a0,s7
    80002eb4:	29c020ef          	jal	ra,80005150 <printf>
    80002eb8:	a015                	j	80002edc <install_trans+0x70>
      bunpin(dbuf);
    80002eba:	8526                	mv	a0,s1
    80002ebc:	a36ff0ef          	jal	ra,800020f2 <bunpin>
    brelse(lbuf);
    80002ec0:	854a                	mv	a0,s2
    80002ec2:	972ff0ef          	jal	ra,80002034 <brelse>
    brelse(dbuf);
    80002ec6:	8526                	mv	a0,s1
    80002ec8:	96cff0ef          	jal	ra,80002034 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ecc:	2985                	addiw	s3,s3,1
    80002ece:	0a91                	addi	s5,s5,4
    80002ed0:	028a2783          	lw	a5,40(s4)
    80002ed4:	04f9d363          	bge	s3,a5,80002f1a <install_trans+0xae>
    if(recovering) {
    80002ed8:	fc0b1ae3          	bnez	s6,80002eac <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002edc:	018a2583          	lw	a1,24(s4)
    80002ee0:	013585bb          	addw	a1,a1,s3
    80002ee4:	2585                	addiw	a1,a1,1
    80002ee6:	024a2503          	lw	a0,36(s4)
    80002eea:	842ff0ef          	jal	ra,80001f2c <bread>
    80002eee:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002ef0:	000aa583          	lw	a1,0(s5)
    80002ef4:	024a2503          	lw	a0,36(s4)
    80002ef8:	834ff0ef          	jal	ra,80001f2c <bread>
    80002efc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002efe:	40000613          	li	a2,1024
    80002f02:	05890593          	addi	a1,s2,88
    80002f06:	05850513          	addi	a0,a0,88
    80002f0a:	a88fd0ef          	jal	ra,80000192 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002f0e:	8526                	mv	a0,s1
    80002f10:	8f2ff0ef          	jal	ra,80002002 <bwrite>
    if(recovering == 0)
    80002f14:	fa0b16e3          	bnez	s6,80002ec0 <install_trans+0x54>
    80002f18:	b74d                	j	80002eba <install_trans+0x4e>
}
    80002f1a:	60a6                	ld	ra,72(sp)
    80002f1c:	6406                	ld	s0,64(sp)
    80002f1e:	74e2                	ld	s1,56(sp)
    80002f20:	7942                	ld	s2,48(sp)
    80002f22:	79a2                	ld	s3,40(sp)
    80002f24:	7a02                	ld	s4,32(sp)
    80002f26:	6ae2                	ld	s5,24(sp)
    80002f28:	6b42                	ld	s6,16(sp)
    80002f2a:	6ba2                	ld	s7,8(sp)
    80002f2c:	6161                	addi	sp,sp,80
    80002f2e:	8082                	ret
    80002f30:	8082                	ret

0000000080002f32 <initlog>:
{
    80002f32:	7179                	addi	sp,sp,-48
    80002f34:	f406                	sd	ra,40(sp)
    80002f36:	f022                	sd	s0,32(sp)
    80002f38:	ec26                	sd	s1,24(sp)
    80002f3a:	e84a                	sd	s2,16(sp)
    80002f3c:	e44e                	sd	s3,8(sp)
    80002f3e:	1800                	addi	s0,sp,48
    80002f40:	892a                	mv	s2,a0
    80002f42:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002f44:	00015497          	auipc	s1,0x15
    80002f48:	94c48493          	addi	s1,s1,-1716 # 80017890 <log>
    80002f4c:	00004597          	auipc	a1,0x4
    80002f50:	65c58593          	addi	a1,a1,1628 # 800075a8 <syscalls+0x218>
    80002f54:	8526                	mv	a0,s1
    80002f56:	6fa020ef          	jal	ra,80005650 <initlock>
  log.start = sb->logstart;
    80002f5a:	0149a583          	lw	a1,20(s3)
    80002f5e:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80002f60:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002f64:	854a                	mv	a0,s2
    80002f66:	fc7fe0ef          	jal	ra,80001f2c <bread>
  log.lh.n = lh->n;
    80002f6a:	4d3c                	lw	a5,88(a0)
    80002f6c:	d49c                	sw	a5,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002f6e:	02f05563          	blez	a5,80002f98 <initlog+0x66>
    80002f72:	05c50713          	addi	a4,a0,92
    80002f76:	00015697          	auipc	a3,0x15
    80002f7a:	94668693          	addi	a3,a3,-1722 # 800178bc <log+0x2c>
    80002f7e:	37fd                	addiw	a5,a5,-1
    80002f80:	1782                	slli	a5,a5,0x20
    80002f82:	9381                	srli	a5,a5,0x20
    80002f84:	078a                	slli	a5,a5,0x2
    80002f86:	06050613          	addi	a2,a0,96
    80002f8a:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80002f8c:	4310                	lw	a2,0(a4)
    80002f8e:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80002f90:	0711                	addi	a4,a4,4
    80002f92:	0691                	addi	a3,a3,4
    80002f94:	fef71ce3          	bne	a4,a5,80002f8c <initlog+0x5a>
  brelse(buf);
    80002f98:	89cff0ef          	jal	ra,80002034 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002f9c:	4505                	li	a0,1
    80002f9e:	ecfff0ef          	jal	ra,80002e6c <install_trans>
  log.lh.n = 0;
    80002fa2:	00015797          	auipc	a5,0x15
    80002fa6:	9007ab23          	sw	zero,-1770(a5) # 800178b8 <log+0x28>
  write_head(); // clear the log
    80002faa:	e55ff0ef          	jal	ra,80002dfe <write_head>
}
    80002fae:	70a2                	ld	ra,40(sp)
    80002fb0:	7402                	ld	s0,32(sp)
    80002fb2:	64e2                	ld	s1,24(sp)
    80002fb4:	6942                	ld	s2,16(sp)
    80002fb6:	69a2                	ld	s3,8(sp)
    80002fb8:	6145                	addi	sp,sp,48
    80002fba:	8082                	ret

0000000080002fbc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002fbc:	1101                	addi	sp,sp,-32
    80002fbe:	ec06                	sd	ra,24(sp)
    80002fc0:	e822                	sd	s0,16(sp)
    80002fc2:	e426                	sd	s1,8(sp)
    80002fc4:	e04a                	sd	s2,0(sp)
    80002fc6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002fc8:	00015517          	auipc	a0,0x15
    80002fcc:	8c850513          	addi	a0,a0,-1848 # 80017890 <log>
    80002fd0:	700020ef          	jal	ra,800056d0 <acquire>
  while(1){
    if(log.committing){
    80002fd4:	00015497          	auipc	s1,0x15
    80002fd8:	8bc48493          	addi	s1,s1,-1860 # 80017890 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80002fdc:	4979                	li	s2,30
    80002fde:	a029                	j	80002fe8 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80002fe0:	85a6                	mv	a1,s1
    80002fe2:	8526                	mv	a0,s1
    80002fe4:	b24fe0ef          	jal	ra,80001308 <sleep>
    if(log.committing){
    80002fe8:	509c                	lw	a5,32(s1)
    80002fea:	fbfd                	bnez	a5,80002fe0 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80002fec:	4cdc                	lw	a5,28(s1)
    80002fee:	0017871b          	addiw	a4,a5,1
    80002ff2:	0007069b          	sext.w	a3,a4
    80002ff6:	0027179b          	slliw	a5,a4,0x2
    80002ffa:	9fb9                	addw	a5,a5,a4
    80002ffc:	0017979b          	slliw	a5,a5,0x1
    80003000:	5498                	lw	a4,40(s1)
    80003002:	9fb9                	addw	a5,a5,a4
    80003004:	00f95763          	bge	s2,a5,80003012 <begin_op+0x56>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003008:	85a6                	mv	a1,s1
    8000300a:	8526                	mv	a0,s1
    8000300c:	afcfe0ef          	jal	ra,80001308 <sleep>
    80003010:	bfe1                	j	80002fe8 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003012:	00015517          	auipc	a0,0x15
    80003016:	87e50513          	addi	a0,a0,-1922 # 80017890 <log>
    8000301a:	cd54                	sw	a3,28(a0)
      release(&log.lock);
    8000301c:	74c020ef          	jal	ra,80005768 <release>
      break;
    }
  }
}
    80003020:	60e2                	ld	ra,24(sp)
    80003022:	6442                	ld	s0,16(sp)
    80003024:	64a2                	ld	s1,8(sp)
    80003026:	6902                	ld	s2,0(sp)
    80003028:	6105                	addi	sp,sp,32
    8000302a:	8082                	ret

000000008000302c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000302c:	7139                	addi	sp,sp,-64
    8000302e:	fc06                	sd	ra,56(sp)
    80003030:	f822                	sd	s0,48(sp)
    80003032:	f426                	sd	s1,40(sp)
    80003034:	f04a                	sd	s2,32(sp)
    80003036:	ec4e                	sd	s3,24(sp)
    80003038:	e852                	sd	s4,16(sp)
    8000303a:	e456                	sd	s5,8(sp)
    8000303c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000303e:	00015497          	auipc	s1,0x15
    80003042:	85248493          	addi	s1,s1,-1966 # 80017890 <log>
    80003046:	8526                	mv	a0,s1
    80003048:	688020ef          	jal	ra,800056d0 <acquire>
  log.outstanding -= 1;
    8000304c:	4cdc                	lw	a5,28(s1)
    8000304e:	37fd                	addiw	a5,a5,-1
    80003050:	0007891b          	sext.w	s2,a5
    80003054:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003056:	509c                	lw	a5,32(s1)
    80003058:	e7b9                	bnez	a5,800030a6 <end_op+0x7a>
    panic("log.committing");
  if(log.outstanding == 0){
    8000305a:	04091c63          	bnez	s2,800030b2 <end_op+0x86>
    do_commit = 1;
    log.committing = 1;
    8000305e:	00015497          	auipc	s1,0x15
    80003062:	83248493          	addi	s1,s1,-1998 # 80017890 <log>
    80003066:	4785                	li	a5,1
    80003068:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000306a:	8526                	mv	a0,s1
    8000306c:	6fc020ef          	jal	ra,80005768 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003070:	549c                	lw	a5,40(s1)
    80003072:	04f04b63          	bgtz	a5,800030c8 <end_op+0x9c>
    acquire(&log.lock);
    80003076:	00015497          	auipc	s1,0x15
    8000307a:	81a48493          	addi	s1,s1,-2022 # 80017890 <log>
    8000307e:	8526                	mv	a0,s1
    80003080:	650020ef          	jal	ra,800056d0 <acquire>
    log.committing = 0;
    80003084:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003088:	8526                	mv	a0,s1
    8000308a:	acafe0ef          	jal	ra,80001354 <wakeup>
    release(&log.lock);
    8000308e:	8526                	mv	a0,s1
    80003090:	6d8020ef          	jal	ra,80005768 <release>
}
    80003094:	70e2                	ld	ra,56(sp)
    80003096:	7442                	ld	s0,48(sp)
    80003098:	74a2                	ld	s1,40(sp)
    8000309a:	7902                	ld	s2,32(sp)
    8000309c:	69e2                	ld	s3,24(sp)
    8000309e:	6a42                	ld	s4,16(sp)
    800030a0:	6aa2                	ld	s5,8(sp)
    800030a2:	6121                	addi	sp,sp,64
    800030a4:	8082                	ret
    panic("log.committing");
    800030a6:	00004517          	auipc	a0,0x4
    800030aa:	50a50513          	addi	a0,a0,1290 # 800075b0 <syscalls+0x220>
    800030ae:	368020ef          	jal	ra,80005416 <panic>
    wakeup(&log);
    800030b2:	00014497          	auipc	s1,0x14
    800030b6:	7de48493          	addi	s1,s1,2014 # 80017890 <log>
    800030ba:	8526                	mv	a0,s1
    800030bc:	a98fe0ef          	jal	ra,80001354 <wakeup>
  release(&log.lock);
    800030c0:	8526                	mv	a0,s1
    800030c2:	6a6020ef          	jal	ra,80005768 <release>
  if(do_commit){
    800030c6:	b7f9                	j	80003094 <end_op+0x68>
  for (tail = 0; tail < log.lh.n; tail++) {
    800030c8:	00014a97          	auipc	s5,0x14
    800030cc:	7f4a8a93          	addi	s5,s5,2036 # 800178bc <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800030d0:	00014a17          	auipc	s4,0x14
    800030d4:	7c0a0a13          	addi	s4,s4,1984 # 80017890 <log>
    800030d8:	018a2583          	lw	a1,24(s4)
    800030dc:	012585bb          	addw	a1,a1,s2
    800030e0:	2585                	addiw	a1,a1,1
    800030e2:	024a2503          	lw	a0,36(s4)
    800030e6:	e47fe0ef          	jal	ra,80001f2c <bread>
    800030ea:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800030ec:	000aa583          	lw	a1,0(s5)
    800030f0:	024a2503          	lw	a0,36(s4)
    800030f4:	e39fe0ef          	jal	ra,80001f2c <bread>
    800030f8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800030fa:	40000613          	li	a2,1024
    800030fe:	05850593          	addi	a1,a0,88
    80003102:	05848513          	addi	a0,s1,88
    80003106:	88cfd0ef          	jal	ra,80000192 <memmove>
    bwrite(to);  // write the log
    8000310a:	8526                	mv	a0,s1
    8000310c:	ef7fe0ef          	jal	ra,80002002 <bwrite>
    brelse(from);
    80003110:	854e                	mv	a0,s3
    80003112:	f23fe0ef          	jal	ra,80002034 <brelse>
    brelse(to);
    80003116:	8526                	mv	a0,s1
    80003118:	f1dfe0ef          	jal	ra,80002034 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000311c:	2905                	addiw	s2,s2,1
    8000311e:	0a91                	addi	s5,s5,4
    80003120:	028a2783          	lw	a5,40(s4)
    80003124:	faf94ae3          	blt	s2,a5,800030d8 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003128:	cd7ff0ef          	jal	ra,80002dfe <write_head>
    install_trans(0); // Now install writes to home locations
    8000312c:	4501                	li	a0,0
    8000312e:	d3fff0ef          	jal	ra,80002e6c <install_trans>
    log.lh.n = 0;
    80003132:	00014797          	auipc	a5,0x14
    80003136:	7807a323          	sw	zero,1926(a5) # 800178b8 <log+0x28>
    write_head();    // Erase the transaction from the log
    8000313a:	cc5ff0ef          	jal	ra,80002dfe <write_head>
    8000313e:	bf25                	j	80003076 <end_op+0x4a>

0000000080003140 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003140:	1101                	addi	sp,sp,-32
    80003142:	ec06                	sd	ra,24(sp)
    80003144:	e822                	sd	s0,16(sp)
    80003146:	e426                	sd	s1,8(sp)
    80003148:	e04a                	sd	s2,0(sp)
    8000314a:	1000                	addi	s0,sp,32
    8000314c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000314e:	00014917          	auipc	s2,0x14
    80003152:	74290913          	addi	s2,s2,1858 # 80017890 <log>
    80003156:	854a                	mv	a0,s2
    80003158:	578020ef          	jal	ra,800056d0 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    8000315c:	02892603          	lw	a2,40(s2)
    80003160:	47f5                	li	a5,29
    80003162:	04c7cc63          	blt	a5,a2,800031ba <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003166:	00014797          	auipc	a5,0x14
    8000316a:	7467a783          	lw	a5,1862(a5) # 800178ac <log+0x1c>
    8000316e:	04f05c63          	blez	a5,800031c6 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003172:	4781                	li	a5,0
    80003174:	04c05f63          	blez	a2,800031d2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003178:	44cc                	lw	a1,12(s1)
    8000317a:	00014717          	auipc	a4,0x14
    8000317e:	74270713          	addi	a4,a4,1858 # 800178bc <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003182:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003184:	4314                	lw	a3,0(a4)
    80003186:	04b68663          	beq	a3,a1,800031d2 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    8000318a:	2785                	addiw	a5,a5,1
    8000318c:	0711                	addi	a4,a4,4
    8000318e:	fef61be3          	bne	a2,a5,80003184 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003192:	0621                	addi	a2,a2,8
    80003194:	060a                	slli	a2,a2,0x2
    80003196:	00014797          	auipc	a5,0x14
    8000319a:	6fa78793          	addi	a5,a5,1786 # 80017890 <log>
    8000319e:	963e                	add	a2,a2,a5
    800031a0:	44dc                	lw	a5,12(s1)
    800031a2:	c65c                	sw	a5,12(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800031a4:	8526                	mv	a0,s1
    800031a6:	f19fe0ef          	jal	ra,800020be <bpin>
    log.lh.n++;
    800031aa:	00014717          	auipc	a4,0x14
    800031ae:	6e670713          	addi	a4,a4,1766 # 80017890 <log>
    800031b2:	571c                	lw	a5,40(a4)
    800031b4:	2785                	addiw	a5,a5,1
    800031b6:	d71c                	sw	a5,40(a4)
    800031b8:	a815                	j	800031ec <log_write+0xac>
    panic("too big a transaction");
    800031ba:	00004517          	auipc	a0,0x4
    800031be:	40650513          	addi	a0,a0,1030 # 800075c0 <syscalls+0x230>
    800031c2:	254020ef          	jal	ra,80005416 <panic>
    panic("log_write outside of trans");
    800031c6:	00004517          	auipc	a0,0x4
    800031ca:	41250513          	addi	a0,a0,1042 # 800075d8 <syscalls+0x248>
    800031ce:	248020ef          	jal	ra,80005416 <panic>
  log.lh.block[i] = b->blockno;
    800031d2:	00878713          	addi	a4,a5,8
    800031d6:	00271693          	slli	a3,a4,0x2
    800031da:	00014717          	auipc	a4,0x14
    800031de:	6b670713          	addi	a4,a4,1718 # 80017890 <log>
    800031e2:	9736                	add	a4,a4,a3
    800031e4:	44d4                	lw	a3,12(s1)
    800031e6:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800031e8:	faf60ee3          	beq	a2,a5,800031a4 <log_write+0x64>
  }
  release(&log.lock);
    800031ec:	00014517          	auipc	a0,0x14
    800031f0:	6a450513          	addi	a0,a0,1700 # 80017890 <log>
    800031f4:	574020ef          	jal	ra,80005768 <release>
}
    800031f8:	60e2                	ld	ra,24(sp)
    800031fa:	6442                	ld	s0,16(sp)
    800031fc:	64a2                	ld	s1,8(sp)
    800031fe:	6902                	ld	s2,0(sp)
    80003200:	6105                	addi	sp,sp,32
    80003202:	8082                	ret

0000000080003204 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003204:	1101                	addi	sp,sp,-32
    80003206:	ec06                	sd	ra,24(sp)
    80003208:	e822                	sd	s0,16(sp)
    8000320a:	e426                	sd	s1,8(sp)
    8000320c:	e04a                	sd	s2,0(sp)
    8000320e:	1000                	addi	s0,sp,32
    80003210:	84aa                	mv	s1,a0
    80003212:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003214:	00004597          	auipc	a1,0x4
    80003218:	3e458593          	addi	a1,a1,996 # 800075f8 <syscalls+0x268>
    8000321c:	0521                	addi	a0,a0,8
    8000321e:	432020ef          	jal	ra,80005650 <initlock>
  lk->name = name;
    80003222:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003226:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000322a:	0204a423          	sw	zero,40(s1)
}
    8000322e:	60e2                	ld	ra,24(sp)
    80003230:	6442                	ld	s0,16(sp)
    80003232:	64a2                	ld	s1,8(sp)
    80003234:	6902                	ld	s2,0(sp)
    80003236:	6105                	addi	sp,sp,32
    80003238:	8082                	ret

000000008000323a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000323a:	1101                	addi	sp,sp,-32
    8000323c:	ec06                	sd	ra,24(sp)
    8000323e:	e822                	sd	s0,16(sp)
    80003240:	e426                	sd	s1,8(sp)
    80003242:	e04a                	sd	s2,0(sp)
    80003244:	1000                	addi	s0,sp,32
    80003246:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003248:	00850913          	addi	s2,a0,8
    8000324c:	854a                	mv	a0,s2
    8000324e:	482020ef          	jal	ra,800056d0 <acquire>
  while (lk->locked) {
    80003252:	409c                	lw	a5,0(s1)
    80003254:	c799                	beqz	a5,80003262 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003256:	85ca                	mv	a1,s2
    80003258:	8526                	mv	a0,s1
    8000325a:	8aefe0ef          	jal	ra,80001308 <sleep>
  while (lk->locked) {
    8000325e:	409c                	lw	a5,0(s1)
    80003260:	fbfd                	bnez	a5,80003256 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003262:	4785                	li	a5,1
    80003264:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003266:	ab1fd0ef          	jal	ra,80000d16 <myproc>
    8000326a:	591c                	lw	a5,48(a0)
    8000326c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000326e:	854a                	mv	a0,s2
    80003270:	4f8020ef          	jal	ra,80005768 <release>
}
    80003274:	60e2                	ld	ra,24(sp)
    80003276:	6442                	ld	s0,16(sp)
    80003278:	64a2                	ld	s1,8(sp)
    8000327a:	6902                	ld	s2,0(sp)
    8000327c:	6105                	addi	sp,sp,32
    8000327e:	8082                	ret

0000000080003280 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003280:	1101                	addi	sp,sp,-32
    80003282:	ec06                	sd	ra,24(sp)
    80003284:	e822                	sd	s0,16(sp)
    80003286:	e426                	sd	s1,8(sp)
    80003288:	e04a                	sd	s2,0(sp)
    8000328a:	1000                	addi	s0,sp,32
    8000328c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000328e:	00850913          	addi	s2,a0,8
    80003292:	854a                	mv	a0,s2
    80003294:	43c020ef          	jal	ra,800056d0 <acquire>
  lk->locked = 0;
    80003298:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000329c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800032a0:	8526                	mv	a0,s1
    800032a2:	8b2fe0ef          	jal	ra,80001354 <wakeup>
  release(&lk->lk);
    800032a6:	854a                	mv	a0,s2
    800032a8:	4c0020ef          	jal	ra,80005768 <release>
}
    800032ac:	60e2                	ld	ra,24(sp)
    800032ae:	6442                	ld	s0,16(sp)
    800032b0:	64a2                	ld	s1,8(sp)
    800032b2:	6902                	ld	s2,0(sp)
    800032b4:	6105                	addi	sp,sp,32
    800032b6:	8082                	ret

00000000800032b8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800032b8:	7179                	addi	sp,sp,-48
    800032ba:	f406                	sd	ra,40(sp)
    800032bc:	f022                	sd	s0,32(sp)
    800032be:	ec26                	sd	s1,24(sp)
    800032c0:	e84a                	sd	s2,16(sp)
    800032c2:	e44e                	sd	s3,8(sp)
    800032c4:	1800                	addi	s0,sp,48
    800032c6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800032c8:	00850913          	addi	s2,a0,8
    800032cc:	854a                	mv	a0,s2
    800032ce:	402020ef          	jal	ra,800056d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800032d2:	409c                	lw	a5,0(s1)
    800032d4:	ef89                	bnez	a5,800032ee <holdingsleep+0x36>
    800032d6:	4481                	li	s1,0
  release(&lk->lk);
    800032d8:	854a                	mv	a0,s2
    800032da:	48e020ef          	jal	ra,80005768 <release>
  return r;
}
    800032de:	8526                	mv	a0,s1
    800032e0:	70a2                	ld	ra,40(sp)
    800032e2:	7402                	ld	s0,32(sp)
    800032e4:	64e2                	ld	s1,24(sp)
    800032e6:	6942                	ld	s2,16(sp)
    800032e8:	69a2                	ld	s3,8(sp)
    800032ea:	6145                	addi	sp,sp,48
    800032ec:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800032ee:	0284a983          	lw	s3,40(s1)
    800032f2:	a25fd0ef          	jal	ra,80000d16 <myproc>
    800032f6:	5904                	lw	s1,48(a0)
    800032f8:	413484b3          	sub	s1,s1,s3
    800032fc:	0014b493          	seqz	s1,s1
    80003300:	bfe1                	j	800032d8 <holdingsleep+0x20>

0000000080003302 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003302:	1141                	addi	sp,sp,-16
    80003304:	e406                	sd	ra,8(sp)
    80003306:	e022                	sd	s0,0(sp)
    80003308:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000330a:	00004597          	auipc	a1,0x4
    8000330e:	2fe58593          	addi	a1,a1,766 # 80007608 <syscalls+0x278>
    80003312:	00014517          	auipc	a0,0x14
    80003316:	6c650513          	addi	a0,a0,1734 # 800179d8 <ftable>
    8000331a:	336020ef          	jal	ra,80005650 <initlock>
}
    8000331e:	60a2                	ld	ra,8(sp)
    80003320:	6402                	ld	s0,0(sp)
    80003322:	0141                	addi	sp,sp,16
    80003324:	8082                	ret

0000000080003326 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003326:	1101                	addi	sp,sp,-32
    80003328:	ec06                	sd	ra,24(sp)
    8000332a:	e822                	sd	s0,16(sp)
    8000332c:	e426                	sd	s1,8(sp)
    8000332e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003330:	00014517          	auipc	a0,0x14
    80003334:	6a850513          	addi	a0,a0,1704 # 800179d8 <ftable>
    80003338:	398020ef          	jal	ra,800056d0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000333c:	00014497          	auipc	s1,0x14
    80003340:	6b448493          	addi	s1,s1,1716 # 800179f0 <ftable+0x18>
    80003344:	00015717          	auipc	a4,0x15
    80003348:	64c70713          	addi	a4,a4,1612 # 80018990 <disk>
    if(f->ref == 0){
    8000334c:	40dc                	lw	a5,4(s1)
    8000334e:	cf89                	beqz	a5,80003368 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003350:	02848493          	addi	s1,s1,40
    80003354:	fee49ce3          	bne	s1,a4,8000334c <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003358:	00014517          	auipc	a0,0x14
    8000335c:	68050513          	addi	a0,a0,1664 # 800179d8 <ftable>
    80003360:	408020ef          	jal	ra,80005768 <release>
  return 0;
    80003364:	4481                	li	s1,0
    80003366:	a809                	j	80003378 <filealloc+0x52>
      f->ref = 1;
    80003368:	4785                	li	a5,1
    8000336a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000336c:	00014517          	auipc	a0,0x14
    80003370:	66c50513          	addi	a0,a0,1644 # 800179d8 <ftable>
    80003374:	3f4020ef          	jal	ra,80005768 <release>
}
    80003378:	8526                	mv	a0,s1
    8000337a:	60e2                	ld	ra,24(sp)
    8000337c:	6442                	ld	s0,16(sp)
    8000337e:	64a2                	ld	s1,8(sp)
    80003380:	6105                	addi	sp,sp,32
    80003382:	8082                	ret

0000000080003384 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003384:	1101                	addi	sp,sp,-32
    80003386:	ec06                	sd	ra,24(sp)
    80003388:	e822                	sd	s0,16(sp)
    8000338a:	e426                	sd	s1,8(sp)
    8000338c:	1000                	addi	s0,sp,32
    8000338e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003390:	00014517          	auipc	a0,0x14
    80003394:	64850513          	addi	a0,a0,1608 # 800179d8 <ftable>
    80003398:	338020ef          	jal	ra,800056d0 <acquire>
  if(f->ref < 1)
    8000339c:	40dc                	lw	a5,4(s1)
    8000339e:	02f05063          	blez	a5,800033be <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800033a2:	2785                	addiw	a5,a5,1
    800033a4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800033a6:	00014517          	auipc	a0,0x14
    800033aa:	63250513          	addi	a0,a0,1586 # 800179d8 <ftable>
    800033ae:	3ba020ef          	jal	ra,80005768 <release>
  return f;
}
    800033b2:	8526                	mv	a0,s1
    800033b4:	60e2                	ld	ra,24(sp)
    800033b6:	6442                	ld	s0,16(sp)
    800033b8:	64a2                	ld	s1,8(sp)
    800033ba:	6105                	addi	sp,sp,32
    800033bc:	8082                	ret
    panic("filedup");
    800033be:	00004517          	auipc	a0,0x4
    800033c2:	25250513          	addi	a0,a0,594 # 80007610 <syscalls+0x280>
    800033c6:	050020ef          	jal	ra,80005416 <panic>

00000000800033ca <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800033ca:	7139                	addi	sp,sp,-64
    800033cc:	fc06                	sd	ra,56(sp)
    800033ce:	f822                	sd	s0,48(sp)
    800033d0:	f426                	sd	s1,40(sp)
    800033d2:	f04a                	sd	s2,32(sp)
    800033d4:	ec4e                	sd	s3,24(sp)
    800033d6:	e852                	sd	s4,16(sp)
    800033d8:	e456                	sd	s5,8(sp)
    800033da:	0080                	addi	s0,sp,64
    800033dc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800033de:	00014517          	auipc	a0,0x14
    800033e2:	5fa50513          	addi	a0,a0,1530 # 800179d8 <ftable>
    800033e6:	2ea020ef          	jal	ra,800056d0 <acquire>
  if(f->ref < 1)
    800033ea:	40dc                	lw	a5,4(s1)
    800033ec:	04f05963          	blez	a5,8000343e <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    800033f0:	37fd                	addiw	a5,a5,-1
    800033f2:	0007871b          	sext.w	a4,a5
    800033f6:	c0dc                	sw	a5,4(s1)
    800033f8:	04e04963          	bgtz	a4,8000344a <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800033fc:	0004a903          	lw	s2,0(s1)
    80003400:	0094ca83          	lbu	s5,9(s1)
    80003404:	0104ba03          	ld	s4,16(s1)
    80003408:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000340c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003410:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003414:	00014517          	auipc	a0,0x14
    80003418:	5c450513          	addi	a0,a0,1476 # 800179d8 <ftable>
    8000341c:	34c020ef          	jal	ra,80005768 <release>

  if(ff.type == FD_PIPE){
    80003420:	4785                	li	a5,1
    80003422:	04f90363          	beq	s2,a5,80003468 <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003426:	3979                	addiw	s2,s2,-2
    80003428:	4785                	li	a5,1
    8000342a:	0327e663          	bltu	a5,s2,80003456 <fileclose+0x8c>
    begin_op();
    8000342e:	b8fff0ef          	jal	ra,80002fbc <begin_op>
    iput(ff.ip);
    80003432:	854e                	mv	a0,s3
    80003434:	b28ff0ef          	jal	ra,8000275c <iput>
    end_op();
    80003438:	bf5ff0ef          	jal	ra,8000302c <end_op>
    8000343c:	a829                	j	80003456 <fileclose+0x8c>
    panic("fileclose");
    8000343e:	00004517          	auipc	a0,0x4
    80003442:	1da50513          	addi	a0,a0,474 # 80007618 <syscalls+0x288>
    80003446:	7d1010ef          	jal	ra,80005416 <panic>
    release(&ftable.lock);
    8000344a:	00014517          	auipc	a0,0x14
    8000344e:	58e50513          	addi	a0,a0,1422 # 800179d8 <ftable>
    80003452:	316020ef          	jal	ra,80005768 <release>
  }
}
    80003456:	70e2                	ld	ra,56(sp)
    80003458:	7442                	ld	s0,48(sp)
    8000345a:	74a2                	ld	s1,40(sp)
    8000345c:	7902                	ld	s2,32(sp)
    8000345e:	69e2                	ld	s3,24(sp)
    80003460:	6a42                	ld	s4,16(sp)
    80003462:	6aa2                	ld	s5,8(sp)
    80003464:	6121                	addi	sp,sp,64
    80003466:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003468:	85d6                	mv	a1,s5
    8000346a:	8552                	mv	a0,s4
    8000346c:	2ec000ef          	jal	ra,80003758 <pipeclose>
    80003470:	b7dd                	j	80003456 <fileclose+0x8c>

0000000080003472 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003472:	715d                	addi	sp,sp,-80
    80003474:	e486                	sd	ra,72(sp)
    80003476:	e0a2                	sd	s0,64(sp)
    80003478:	fc26                	sd	s1,56(sp)
    8000347a:	f84a                	sd	s2,48(sp)
    8000347c:	f44e                	sd	s3,40(sp)
    8000347e:	0880                	addi	s0,sp,80
    80003480:	84aa                	mv	s1,a0
    80003482:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003484:	893fd0ef          	jal	ra,80000d16 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003488:	409c                	lw	a5,0(s1)
    8000348a:	37f9                	addiw	a5,a5,-2
    8000348c:	4705                	li	a4,1
    8000348e:	02f76f63          	bltu	a4,a5,800034cc <filestat+0x5a>
    80003492:	892a                	mv	s2,a0
    ilock(f->ip);
    80003494:	6c88                	ld	a0,24(s1)
    80003496:	948ff0ef          	jal	ra,800025de <ilock>
    stati(f->ip, &st);
    8000349a:	fb840593          	addi	a1,s0,-72
    8000349e:	6c88                	ld	a0,24(s1)
    800034a0:	ca0ff0ef          	jal	ra,80002940 <stati>
    iunlock(f->ip);
    800034a4:	6c88                	ld	a0,24(s1)
    800034a6:	9e2ff0ef          	jal	ra,80002688 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800034aa:	46e1                	li	a3,24
    800034ac:	fb840613          	addi	a2,s0,-72
    800034b0:	85ce                	mv	a1,s3
    800034b2:	05093503          	ld	a0,80(s2)
    800034b6:	da8fd0ef          	jal	ra,80000a5e <copyout>
    800034ba:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800034be:	60a6                	ld	ra,72(sp)
    800034c0:	6406                	ld	s0,64(sp)
    800034c2:	74e2                	ld	s1,56(sp)
    800034c4:	7942                	ld	s2,48(sp)
    800034c6:	79a2                	ld	s3,40(sp)
    800034c8:	6161                	addi	sp,sp,80
    800034ca:	8082                	ret
  return -1;
    800034cc:	557d                	li	a0,-1
    800034ce:	bfc5                	j	800034be <filestat+0x4c>

00000000800034d0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800034d0:	7179                	addi	sp,sp,-48
    800034d2:	f406                	sd	ra,40(sp)
    800034d4:	f022                	sd	s0,32(sp)
    800034d6:	ec26                	sd	s1,24(sp)
    800034d8:	e84a                	sd	s2,16(sp)
    800034da:	e44e                	sd	s3,8(sp)
    800034dc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800034de:	00854783          	lbu	a5,8(a0)
    800034e2:	cbc1                	beqz	a5,80003572 <fileread+0xa2>
    800034e4:	84aa                	mv	s1,a0
    800034e6:	89ae                	mv	s3,a1
    800034e8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800034ea:	411c                	lw	a5,0(a0)
    800034ec:	4705                	li	a4,1
    800034ee:	04e78363          	beq	a5,a4,80003534 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800034f2:	470d                	li	a4,3
    800034f4:	04e78563          	beq	a5,a4,8000353e <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800034f8:	4709                	li	a4,2
    800034fa:	06e79663          	bne	a5,a4,80003566 <fileread+0x96>
    ilock(f->ip);
    800034fe:	6d08                	ld	a0,24(a0)
    80003500:	8deff0ef          	jal	ra,800025de <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003504:	874a                	mv	a4,s2
    80003506:	5094                	lw	a3,32(s1)
    80003508:	864e                	mv	a2,s3
    8000350a:	4585                	li	a1,1
    8000350c:	6c88                	ld	a0,24(s1)
    8000350e:	c5cff0ef          	jal	ra,8000296a <readi>
    80003512:	892a                	mv	s2,a0
    80003514:	00a05563          	blez	a0,8000351e <fileread+0x4e>
      f->off += r;
    80003518:	509c                	lw	a5,32(s1)
    8000351a:	9fa9                	addw	a5,a5,a0
    8000351c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000351e:	6c88                	ld	a0,24(s1)
    80003520:	968ff0ef          	jal	ra,80002688 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003524:	854a                	mv	a0,s2
    80003526:	70a2                	ld	ra,40(sp)
    80003528:	7402                	ld	s0,32(sp)
    8000352a:	64e2                	ld	s1,24(sp)
    8000352c:	6942                	ld	s2,16(sp)
    8000352e:	69a2                	ld	s3,8(sp)
    80003530:	6145                	addi	sp,sp,48
    80003532:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003534:	6908                	ld	a0,16(a0)
    80003536:	356000ef          	jal	ra,8000388c <piperead>
    8000353a:	892a                	mv	s2,a0
    8000353c:	b7e5                	j	80003524 <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000353e:	02451783          	lh	a5,36(a0)
    80003542:	03079693          	slli	a3,a5,0x30
    80003546:	92c1                	srli	a3,a3,0x30
    80003548:	4725                	li	a4,9
    8000354a:	02d76663          	bltu	a4,a3,80003576 <fileread+0xa6>
    8000354e:	0792                	slli	a5,a5,0x4
    80003550:	00014717          	auipc	a4,0x14
    80003554:	3e870713          	addi	a4,a4,1000 # 80017938 <devsw>
    80003558:	97ba                	add	a5,a5,a4
    8000355a:	639c                	ld	a5,0(a5)
    8000355c:	cf99                	beqz	a5,8000357a <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    8000355e:	4505                	li	a0,1
    80003560:	9782                	jalr	a5
    80003562:	892a                	mv	s2,a0
    80003564:	b7c1                	j	80003524 <fileread+0x54>
    panic("fileread");
    80003566:	00004517          	auipc	a0,0x4
    8000356a:	0c250513          	addi	a0,a0,194 # 80007628 <syscalls+0x298>
    8000356e:	6a9010ef          	jal	ra,80005416 <panic>
    return -1;
    80003572:	597d                	li	s2,-1
    80003574:	bf45                	j	80003524 <fileread+0x54>
      return -1;
    80003576:	597d                	li	s2,-1
    80003578:	b775                	j	80003524 <fileread+0x54>
    8000357a:	597d                	li	s2,-1
    8000357c:	b765                	j	80003524 <fileread+0x54>

000000008000357e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    8000357e:	715d                	addi	sp,sp,-80
    80003580:	e486                	sd	ra,72(sp)
    80003582:	e0a2                	sd	s0,64(sp)
    80003584:	fc26                	sd	s1,56(sp)
    80003586:	f84a                	sd	s2,48(sp)
    80003588:	f44e                	sd	s3,40(sp)
    8000358a:	f052                	sd	s4,32(sp)
    8000358c:	ec56                	sd	s5,24(sp)
    8000358e:	e85a                	sd	s6,16(sp)
    80003590:	e45e                	sd	s7,8(sp)
    80003592:	e062                	sd	s8,0(sp)
    80003594:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003596:	00954783          	lbu	a5,9(a0)
    8000359a:	0e078863          	beqz	a5,8000368a <filewrite+0x10c>
    8000359e:	892a                	mv	s2,a0
    800035a0:	8aae                	mv	s5,a1
    800035a2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800035a4:	411c                	lw	a5,0(a0)
    800035a6:	4705                	li	a4,1
    800035a8:	02e78263          	beq	a5,a4,800035cc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035ac:	470d                	li	a4,3
    800035ae:	02e78463          	beq	a5,a4,800035d6 <filewrite+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800035b2:	4709                	li	a4,2
    800035b4:	0ce79563          	bne	a5,a4,8000367e <filewrite+0x100>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800035b8:	0ac05163          	blez	a2,8000365a <filewrite+0xdc>
    int i = 0;
    800035bc:	4981                	li	s3,0
    800035be:	6b05                	lui	s6,0x1
    800035c0:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800035c4:	6b85                	lui	s7,0x1
    800035c6:	c00b8b9b          	addiw	s7,s7,-1024
    800035ca:	a041                	j	8000364a <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800035cc:	6908                	ld	a0,16(a0)
    800035ce:	1e2000ef          	jal	ra,800037b0 <pipewrite>
    800035d2:	8a2a                	mv	s4,a0
    800035d4:	a071                	j	80003660 <filewrite+0xe2>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800035d6:	02451783          	lh	a5,36(a0)
    800035da:	03079693          	slli	a3,a5,0x30
    800035de:	92c1                	srli	a3,a3,0x30
    800035e0:	4725                	li	a4,9
    800035e2:	0ad76663          	bltu	a4,a3,8000368e <filewrite+0x110>
    800035e6:	0792                	slli	a5,a5,0x4
    800035e8:	00014717          	auipc	a4,0x14
    800035ec:	35070713          	addi	a4,a4,848 # 80017938 <devsw>
    800035f0:	97ba                	add	a5,a5,a4
    800035f2:	679c                	ld	a5,8(a5)
    800035f4:	cfd9                	beqz	a5,80003692 <filewrite+0x114>
    ret = devsw[f->major].write(1, addr, n);
    800035f6:	4505                	li	a0,1
    800035f8:	9782                	jalr	a5
    800035fa:	8a2a                	mv	s4,a0
    800035fc:	a095                	j	80003660 <filewrite+0xe2>
    800035fe:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003602:	9bbff0ef          	jal	ra,80002fbc <begin_op>
      ilock(f->ip);
    80003606:	01893503          	ld	a0,24(s2)
    8000360a:	fd5fe0ef          	jal	ra,800025de <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000360e:	8762                	mv	a4,s8
    80003610:	02092683          	lw	a3,32(s2)
    80003614:	01598633          	add	a2,s3,s5
    80003618:	4585                	li	a1,1
    8000361a:	01893503          	ld	a0,24(s2)
    8000361e:	c30ff0ef          	jal	ra,80002a4e <writei>
    80003622:	84aa                	mv	s1,a0
    80003624:	00a05763          	blez	a0,80003632 <filewrite+0xb4>
        f->off += r;
    80003628:	02092783          	lw	a5,32(s2)
    8000362c:	9fa9                	addw	a5,a5,a0
    8000362e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003632:	01893503          	ld	a0,24(s2)
    80003636:	852ff0ef          	jal	ra,80002688 <iunlock>
      end_op();
    8000363a:	9f3ff0ef          	jal	ra,8000302c <end_op>

      if(r != n1){
    8000363e:	009c1f63          	bne	s8,s1,8000365c <filewrite+0xde>
        // error from writei
        break;
      }
      i += r;
    80003642:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003646:	0149db63          	bge	s3,s4,8000365c <filewrite+0xde>
      int n1 = n - i;
    8000364a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    8000364e:	84be                	mv	s1,a5
    80003650:	2781                	sext.w	a5,a5
    80003652:	fafb56e3          	bge	s6,a5,800035fe <filewrite+0x80>
    80003656:	84de                	mv	s1,s7
    80003658:	b75d                	j	800035fe <filewrite+0x80>
    int i = 0;
    8000365a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    8000365c:	013a1f63          	bne	s4,s3,8000367a <filewrite+0xfc>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003660:	8552                	mv	a0,s4
    80003662:	60a6                	ld	ra,72(sp)
    80003664:	6406                	ld	s0,64(sp)
    80003666:	74e2                	ld	s1,56(sp)
    80003668:	7942                	ld	s2,48(sp)
    8000366a:	79a2                	ld	s3,40(sp)
    8000366c:	7a02                	ld	s4,32(sp)
    8000366e:	6ae2                	ld	s5,24(sp)
    80003670:	6b42                	ld	s6,16(sp)
    80003672:	6ba2                	ld	s7,8(sp)
    80003674:	6c02                	ld	s8,0(sp)
    80003676:	6161                	addi	sp,sp,80
    80003678:	8082                	ret
    ret = (i == n ? n : -1);
    8000367a:	5a7d                	li	s4,-1
    8000367c:	b7d5                	j	80003660 <filewrite+0xe2>
    panic("filewrite");
    8000367e:	00004517          	auipc	a0,0x4
    80003682:	fba50513          	addi	a0,a0,-70 # 80007638 <syscalls+0x2a8>
    80003686:	591010ef          	jal	ra,80005416 <panic>
    return -1;
    8000368a:	5a7d                	li	s4,-1
    8000368c:	bfd1                	j	80003660 <filewrite+0xe2>
      return -1;
    8000368e:	5a7d                	li	s4,-1
    80003690:	bfc1                	j	80003660 <filewrite+0xe2>
    80003692:	5a7d                	li	s4,-1
    80003694:	b7f1                	j	80003660 <filewrite+0xe2>

0000000080003696 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003696:	7179                	addi	sp,sp,-48
    80003698:	f406                	sd	ra,40(sp)
    8000369a:	f022                	sd	s0,32(sp)
    8000369c:	ec26                	sd	s1,24(sp)
    8000369e:	e84a                	sd	s2,16(sp)
    800036a0:	e44e                	sd	s3,8(sp)
    800036a2:	e052                	sd	s4,0(sp)
    800036a4:	1800                	addi	s0,sp,48
    800036a6:	84aa                	mv	s1,a0
    800036a8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800036aa:	0005b023          	sd	zero,0(a1)
    800036ae:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800036b2:	c75ff0ef          	jal	ra,80003326 <filealloc>
    800036b6:	e088                	sd	a0,0(s1)
    800036b8:	cd35                	beqz	a0,80003734 <pipealloc+0x9e>
    800036ba:	c6dff0ef          	jal	ra,80003326 <filealloc>
    800036be:	00aa3023          	sd	a0,0(s4)
    800036c2:	c52d                	beqz	a0,8000372c <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800036c4:	a31fc0ef          	jal	ra,800000f4 <kalloc>
    800036c8:	892a                	mv	s2,a0
    800036ca:	cd31                	beqz	a0,80003726 <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    800036cc:	4985                	li	s3,1
    800036ce:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800036d2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800036d6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800036da:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800036de:	00004597          	auipc	a1,0x4
    800036e2:	f6a58593          	addi	a1,a1,-150 # 80007648 <syscalls+0x2b8>
    800036e6:	76b010ef          	jal	ra,80005650 <initlock>
  (*f0)->type = FD_PIPE;
    800036ea:	609c                	ld	a5,0(s1)
    800036ec:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800036f0:	609c                	ld	a5,0(s1)
    800036f2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800036f6:	609c                	ld	a5,0(s1)
    800036f8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800036fc:	609c                	ld	a5,0(s1)
    800036fe:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003702:	000a3783          	ld	a5,0(s4)
    80003706:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000370a:	000a3783          	ld	a5,0(s4)
    8000370e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003712:	000a3783          	ld	a5,0(s4)
    80003716:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000371a:	000a3783          	ld	a5,0(s4)
    8000371e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003722:	4501                	li	a0,0
    80003724:	a005                	j	80003744 <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003726:	6088                	ld	a0,0(s1)
    80003728:	e501                	bnez	a0,80003730 <pipealloc+0x9a>
    8000372a:	a029                	j	80003734 <pipealloc+0x9e>
    8000372c:	6088                	ld	a0,0(s1)
    8000372e:	c11d                	beqz	a0,80003754 <pipealloc+0xbe>
    fileclose(*f0);
    80003730:	c9bff0ef          	jal	ra,800033ca <fileclose>
  if(*f1)
    80003734:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003738:	557d                	li	a0,-1
  if(*f1)
    8000373a:	c789                	beqz	a5,80003744 <pipealloc+0xae>
    fileclose(*f1);
    8000373c:	853e                	mv	a0,a5
    8000373e:	c8dff0ef          	jal	ra,800033ca <fileclose>
  return -1;
    80003742:	557d                	li	a0,-1
}
    80003744:	70a2                	ld	ra,40(sp)
    80003746:	7402                	ld	s0,32(sp)
    80003748:	64e2                	ld	s1,24(sp)
    8000374a:	6942                	ld	s2,16(sp)
    8000374c:	69a2                	ld	s3,8(sp)
    8000374e:	6a02                	ld	s4,0(sp)
    80003750:	6145                	addi	sp,sp,48
    80003752:	8082                	ret
  return -1;
    80003754:	557d                	li	a0,-1
    80003756:	b7fd                	j	80003744 <pipealloc+0xae>

0000000080003758 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003758:	1101                	addi	sp,sp,-32
    8000375a:	ec06                	sd	ra,24(sp)
    8000375c:	e822                	sd	s0,16(sp)
    8000375e:	e426                	sd	s1,8(sp)
    80003760:	e04a                	sd	s2,0(sp)
    80003762:	1000                	addi	s0,sp,32
    80003764:	84aa                	mv	s1,a0
    80003766:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003768:	769010ef          	jal	ra,800056d0 <acquire>
  if(writable){
    8000376c:	02090763          	beqz	s2,8000379a <pipeclose+0x42>
    pi->writeopen = 0;
    80003770:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003774:	21848513          	addi	a0,s1,536
    80003778:	bddfd0ef          	jal	ra,80001354 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000377c:	2204b783          	ld	a5,544(s1)
    80003780:	e785                	bnez	a5,800037a8 <pipeclose+0x50>
    release(&pi->lock);
    80003782:	8526                	mv	a0,s1
    80003784:	7e5010ef          	jal	ra,80005768 <release>
    kfree((char*)pi);
    80003788:	8526                	mv	a0,s1
    8000378a:	893fc0ef          	jal	ra,8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000378e:	60e2                	ld	ra,24(sp)
    80003790:	6442                	ld	s0,16(sp)
    80003792:	64a2                	ld	s1,8(sp)
    80003794:	6902                	ld	s2,0(sp)
    80003796:	6105                	addi	sp,sp,32
    80003798:	8082                	ret
    pi->readopen = 0;
    8000379a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000379e:	21c48513          	addi	a0,s1,540
    800037a2:	bb3fd0ef          	jal	ra,80001354 <wakeup>
    800037a6:	bfd9                	j	8000377c <pipeclose+0x24>
    release(&pi->lock);
    800037a8:	8526                	mv	a0,s1
    800037aa:	7bf010ef          	jal	ra,80005768 <release>
}
    800037ae:	b7c5                	j	8000378e <pipeclose+0x36>

00000000800037b0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800037b0:	7159                	addi	sp,sp,-112
    800037b2:	f486                	sd	ra,104(sp)
    800037b4:	f0a2                	sd	s0,96(sp)
    800037b6:	eca6                	sd	s1,88(sp)
    800037b8:	e8ca                	sd	s2,80(sp)
    800037ba:	e4ce                	sd	s3,72(sp)
    800037bc:	e0d2                	sd	s4,64(sp)
    800037be:	fc56                	sd	s5,56(sp)
    800037c0:	f85a                	sd	s6,48(sp)
    800037c2:	f45e                	sd	s7,40(sp)
    800037c4:	f062                	sd	s8,32(sp)
    800037c6:	ec66                	sd	s9,24(sp)
    800037c8:	1880                	addi	s0,sp,112
    800037ca:	84aa                	mv	s1,a0
    800037cc:	8aae                	mv	s5,a1
    800037ce:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800037d0:	d46fd0ef          	jal	ra,80000d16 <myproc>
    800037d4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800037d6:	8526                	mv	a0,s1
    800037d8:	6f9010ef          	jal	ra,800056d0 <acquire>
  while(i < n){
    800037dc:	0b405663          	blez	s4,80003888 <pipewrite+0xd8>
    800037e0:	8ba6                	mv	s7,s1
  int i = 0;
    800037e2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800037e4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800037e6:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800037ea:	21c48c13          	addi	s8,s1,540
    800037ee:	a899                	j	80003844 <pipewrite+0x94>
      release(&pi->lock);
    800037f0:	8526                	mv	a0,s1
    800037f2:	777010ef          	jal	ra,80005768 <release>
      return -1;
    800037f6:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800037f8:	854a                	mv	a0,s2
    800037fa:	70a6                	ld	ra,104(sp)
    800037fc:	7406                	ld	s0,96(sp)
    800037fe:	64e6                	ld	s1,88(sp)
    80003800:	6946                	ld	s2,80(sp)
    80003802:	69a6                	ld	s3,72(sp)
    80003804:	6a06                	ld	s4,64(sp)
    80003806:	7ae2                	ld	s5,56(sp)
    80003808:	7b42                	ld	s6,48(sp)
    8000380a:	7ba2                	ld	s7,40(sp)
    8000380c:	7c02                	ld	s8,32(sp)
    8000380e:	6ce2                	ld	s9,24(sp)
    80003810:	6165                	addi	sp,sp,112
    80003812:	8082                	ret
      wakeup(&pi->nread);
    80003814:	8566                	mv	a0,s9
    80003816:	b3ffd0ef          	jal	ra,80001354 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000381a:	85de                	mv	a1,s7
    8000381c:	8562                	mv	a0,s8
    8000381e:	aebfd0ef          	jal	ra,80001308 <sleep>
    80003822:	a839                	j	80003840 <pipewrite+0x90>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003824:	21c4a783          	lw	a5,540(s1)
    80003828:	0017871b          	addiw	a4,a5,1
    8000382c:	20e4ae23          	sw	a4,540(s1)
    80003830:	1ff7f793          	andi	a5,a5,511
    80003834:	97a6                	add	a5,a5,s1
    80003836:	f9f44703          	lbu	a4,-97(s0)
    8000383a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000383e:	2905                	addiw	s2,s2,1
  while(i < n){
    80003840:	03495c63          	bge	s2,s4,80003878 <pipewrite+0xc8>
    if(pi->readopen == 0 || killed(pr)){
    80003844:	2204a783          	lw	a5,544(s1)
    80003848:	d7c5                	beqz	a5,800037f0 <pipewrite+0x40>
    8000384a:	854e                	mv	a0,s3
    8000384c:	cf5fd0ef          	jal	ra,80001540 <killed>
    80003850:	f145                	bnez	a0,800037f0 <pipewrite+0x40>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003852:	2184a783          	lw	a5,536(s1)
    80003856:	21c4a703          	lw	a4,540(s1)
    8000385a:	2007879b          	addiw	a5,a5,512
    8000385e:	faf70be3          	beq	a4,a5,80003814 <pipewrite+0x64>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003862:	4685                	li	a3,1
    80003864:	01590633          	add	a2,s2,s5
    80003868:	f9f40593          	addi	a1,s0,-97
    8000386c:	0509b503          	ld	a0,80(s3)
    80003870:	abafd0ef          	jal	ra,80000b2a <copyin>
    80003874:	fb6518e3          	bne	a0,s6,80003824 <pipewrite+0x74>
  wakeup(&pi->nread);
    80003878:	21848513          	addi	a0,s1,536
    8000387c:	ad9fd0ef          	jal	ra,80001354 <wakeup>
  release(&pi->lock);
    80003880:	8526                	mv	a0,s1
    80003882:	6e7010ef          	jal	ra,80005768 <release>
  return i;
    80003886:	bf8d                	j	800037f8 <pipewrite+0x48>
  int i = 0;
    80003888:	4901                	li	s2,0
    8000388a:	b7fd                	j	80003878 <pipewrite+0xc8>

000000008000388c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000388c:	715d                	addi	sp,sp,-80
    8000388e:	e486                	sd	ra,72(sp)
    80003890:	e0a2                	sd	s0,64(sp)
    80003892:	fc26                	sd	s1,56(sp)
    80003894:	f84a                	sd	s2,48(sp)
    80003896:	f44e                	sd	s3,40(sp)
    80003898:	f052                	sd	s4,32(sp)
    8000389a:	ec56                	sd	s5,24(sp)
    8000389c:	e85a                	sd	s6,16(sp)
    8000389e:	0880                	addi	s0,sp,80
    800038a0:	84aa                	mv	s1,a0
    800038a2:	892e                	mv	s2,a1
    800038a4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800038a6:	c70fd0ef          	jal	ra,80000d16 <myproc>
    800038aa:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800038ac:	8b26                	mv	s6,s1
    800038ae:	8526                	mv	a0,s1
    800038b0:	621010ef          	jal	ra,800056d0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038b4:	2184a703          	lw	a4,536(s1)
    800038b8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800038bc:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038c0:	02f71363          	bne	a4,a5,800038e6 <piperead+0x5a>
    800038c4:	2244a783          	lw	a5,548(s1)
    800038c8:	cf99                	beqz	a5,800038e6 <piperead+0x5a>
    if(killed(pr)){
    800038ca:	8552                	mv	a0,s4
    800038cc:	c75fd0ef          	jal	ra,80001540 <killed>
    800038d0:	e141                	bnez	a0,80003950 <piperead+0xc4>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800038d2:	85da                	mv	a1,s6
    800038d4:	854e                	mv	a0,s3
    800038d6:	a33fd0ef          	jal	ra,80001308 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038da:	2184a703          	lw	a4,536(s1)
    800038de:	21c4a783          	lw	a5,540(s1)
    800038e2:	fef701e3          	beq	a4,a5,800038c4 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800038e6:	07505a63          	blez	s5,8000395a <piperead+0xce>
    800038ea:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800038ec:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800038ee:	2184a783          	lw	a5,536(s1)
    800038f2:	21c4a703          	lw	a4,540(s1)
    800038f6:	02f70b63          	beq	a4,a5,8000392c <piperead+0xa0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800038fa:	0017871b          	addiw	a4,a5,1
    800038fe:	20e4ac23          	sw	a4,536(s1)
    80003902:	1ff7f793          	andi	a5,a5,511
    80003906:	97a6                	add	a5,a5,s1
    80003908:	0187c783          	lbu	a5,24(a5)
    8000390c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003910:	4685                	li	a3,1
    80003912:	fbf40613          	addi	a2,s0,-65
    80003916:	85ca                	mv	a1,s2
    80003918:	050a3503          	ld	a0,80(s4)
    8000391c:	942fd0ef          	jal	ra,80000a5e <copyout>
    80003920:	01650663          	beq	a0,s6,8000392c <piperead+0xa0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003924:	2985                	addiw	s3,s3,1
    80003926:	0905                	addi	s2,s2,1
    80003928:	fd3a93e3          	bne	s5,s3,800038ee <piperead+0x62>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000392c:	21c48513          	addi	a0,s1,540
    80003930:	a25fd0ef          	jal	ra,80001354 <wakeup>
  release(&pi->lock);
    80003934:	8526                	mv	a0,s1
    80003936:	633010ef          	jal	ra,80005768 <release>
  return i;
}
    8000393a:	854e                	mv	a0,s3
    8000393c:	60a6                	ld	ra,72(sp)
    8000393e:	6406                	ld	s0,64(sp)
    80003940:	74e2                	ld	s1,56(sp)
    80003942:	7942                	ld	s2,48(sp)
    80003944:	79a2                	ld	s3,40(sp)
    80003946:	7a02                	ld	s4,32(sp)
    80003948:	6ae2                	ld	s5,24(sp)
    8000394a:	6b42                	ld	s6,16(sp)
    8000394c:	6161                	addi	sp,sp,80
    8000394e:	8082                	ret
      release(&pi->lock);
    80003950:	8526                	mv	a0,s1
    80003952:	617010ef          	jal	ra,80005768 <release>
      return -1;
    80003956:	59fd                	li	s3,-1
    80003958:	b7cd                	j	8000393a <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000395a:	4981                	li	s3,0
    8000395c:	bfc1                	j	8000392c <piperead+0xa0>

000000008000395e <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    8000395e:	1141                	addi	sp,sp,-16
    80003960:	e422                	sd	s0,8(sp)
    80003962:	0800                	addi	s0,sp,16
    80003964:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003966:	8905                	andi	a0,a0,1
    80003968:	c111                	beqz	a0,8000396c <flags2perm+0xe>
      perm = PTE_X;
    8000396a:	4521                	li	a0,8
    if(flags & 0x2)
    8000396c:	8b89                	andi	a5,a5,2
    8000396e:	c399                	beqz	a5,80003974 <flags2perm+0x16>
      perm |= PTE_W;
    80003970:	00456513          	ori	a0,a0,4
    return perm;
}
    80003974:	6422                	ld	s0,8(sp)
    80003976:	0141                	addi	sp,sp,16
    80003978:	8082                	ret

000000008000397a <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    8000397a:	df010113          	addi	sp,sp,-528
    8000397e:	20113423          	sd	ra,520(sp)
    80003982:	20813023          	sd	s0,512(sp)
    80003986:	ffa6                	sd	s1,504(sp)
    80003988:	fbca                	sd	s2,496(sp)
    8000398a:	f7ce                	sd	s3,488(sp)
    8000398c:	f3d2                	sd	s4,480(sp)
    8000398e:	efd6                	sd	s5,472(sp)
    80003990:	ebda                	sd	s6,464(sp)
    80003992:	e7de                	sd	s7,456(sp)
    80003994:	e3e2                	sd	s8,448(sp)
    80003996:	ff66                	sd	s9,440(sp)
    80003998:	fb6a                	sd	s10,432(sp)
    8000399a:	f76e                	sd	s11,424(sp)
    8000399c:	0c00                	addi	s0,sp,528
    8000399e:	84aa                	mv	s1,a0
    800039a0:	dea43c23          	sd	a0,-520(s0)
    800039a4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800039a8:	b6efd0ef          	jal	ra,80000d16 <myproc>
    800039ac:	892a                	mv	s2,a0

  begin_op();
    800039ae:	e0eff0ef          	jal	ra,80002fbc <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    800039b2:	8526                	mv	a0,s1
    800039b4:	c18ff0ef          	jal	ra,80002dcc <namei>
    800039b8:	c12d                	beqz	a0,80003a1a <kexec+0xa0>
    800039ba:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800039bc:	c23fe0ef          	jal	ra,800025de <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800039c0:	04000713          	li	a4,64
    800039c4:	4681                	li	a3,0
    800039c6:	e5040613          	addi	a2,s0,-432
    800039ca:	4581                	li	a1,0
    800039cc:	8526                	mv	a0,s1
    800039ce:	f9dfe0ef          	jal	ra,8000296a <readi>
    800039d2:	04000793          	li	a5,64
    800039d6:	00f51a63          	bne	a0,a5,800039ea <kexec+0x70>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    800039da:	e5042703          	lw	a4,-432(s0)
    800039de:	464c47b7          	lui	a5,0x464c4
    800039e2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800039e6:	02f70e63          	beq	a4,a5,80003a22 <kexec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800039ea:	8526                	mv	a0,s1
    800039ec:	df9fe0ef          	jal	ra,800027e4 <iunlockput>
    end_op();
    800039f0:	e3cff0ef          	jal	ra,8000302c <end_op>
  }
  return -1;
    800039f4:	557d                	li	a0,-1
}
    800039f6:	20813083          	ld	ra,520(sp)
    800039fa:	20013403          	ld	s0,512(sp)
    800039fe:	74fe                	ld	s1,504(sp)
    80003a00:	795e                	ld	s2,496(sp)
    80003a02:	79be                	ld	s3,488(sp)
    80003a04:	7a1e                	ld	s4,480(sp)
    80003a06:	6afe                	ld	s5,472(sp)
    80003a08:	6b5e                	ld	s6,464(sp)
    80003a0a:	6bbe                	ld	s7,456(sp)
    80003a0c:	6c1e                	ld	s8,448(sp)
    80003a0e:	7cfa                	ld	s9,440(sp)
    80003a10:	7d5a                	ld	s10,432(sp)
    80003a12:	7dba                	ld	s11,424(sp)
    80003a14:	21010113          	addi	sp,sp,528
    80003a18:	8082                	ret
    end_op();
    80003a1a:	e12ff0ef          	jal	ra,8000302c <end_op>
    return -1;
    80003a1e:	557d                	li	a0,-1
    80003a20:	bfd9                	j	800039f6 <kexec+0x7c>
  if((pagetable = proc_pagetable(p)) == 0)
    80003a22:	854a                	mv	a0,s2
    80003a24:	bf8fd0ef          	jal	ra,80000e1c <proc_pagetable>
    80003a28:	8baa                	mv	s7,a0
    80003a2a:	d161                	beqz	a0,800039ea <kexec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a2c:	e7042983          	lw	s3,-400(s0)
    80003a30:	e8845783          	lhu	a5,-376(s0)
    80003a34:	cfb9                	beqz	a5,80003a92 <kexec+0x118>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003a36:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a38:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80003a3a:	6c85                	lui	s9,0x1
    80003a3c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003a40:	def43823          	sd	a5,-528(s0)
    80003a44:	aadd                	j	80003c3a <kexec+0x2c0>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80003a46:	00004517          	auipc	a0,0x4
    80003a4a:	c0a50513          	addi	a0,a0,-1014 # 80007650 <syscalls+0x2c0>
    80003a4e:	1c9010ef          	jal	ra,80005416 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003a52:	8756                	mv	a4,s5
    80003a54:	012d86bb          	addw	a3,s11,s2
    80003a58:	4581                	li	a1,0
    80003a5a:	8526                	mv	a0,s1
    80003a5c:	f0ffe0ef          	jal	ra,8000296a <readi>
    80003a60:	2501                	sext.w	a0,a0
    80003a62:	18aa9263          	bne	s5,a0,80003be6 <kexec+0x26c>
  for(i = 0; i < sz; i += PGSIZE){
    80003a66:	6785                	lui	a5,0x1
    80003a68:	0127893b          	addw	s2,a5,s2
    80003a6c:	77fd                	lui	a5,0xfffff
    80003a6e:	01478a3b          	addw	s4,a5,s4
    80003a72:	1b897b63          	bgeu	s2,s8,80003c28 <kexec+0x2ae>
    pa = walkaddr(pagetable, va + i);
    80003a76:	02091593          	slli	a1,s2,0x20
    80003a7a:	9181                	srli	a1,a1,0x20
    80003a7c:	95ea                	add	a1,a1,s10
    80003a7e:	855e                	mv	a0,s7
    80003a80:	9d1fc0ef          	jal	ra,80000450 <walkaddr>
    80003a84:	862a                	mv	a2,a0
    if(pa == 0)
    80003a86:	d161                	beqz	a0,80003a46 <kexec+0xcc>
      n = PGSIZE;
    80003a88:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80003a8a:	fd9a74e3          	bgeu	s4,s9,80003a52 <kexec+0xd8>
      n = sz - i;
    80003a8e:	8ad2                	mv	s5,s4
    80003a90:	b7c9                	j	80003a52 <kexec+0xd8>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003a92:	4a01                	li	s4,0
  iunlockput(ip);
    80003a94:	8526                	mv	a0,s1
    80003a96:	d4ffe0ef          	jal	ra,800027e4 <iunlockput>
  end_op();
    80003a9a:	d92ff0ef          	jal	ra,8000302c <end_op>
  p = myproc();
    80003a9e:	a78fd0ef          	jal	ra,80000d16 <myproc>
    80003aa2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003aa4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003aa8:	6785                	lui	a5,0x1
    80003aaa:	17fd                	addi	a5,a5,-1
    80003aac:	9a3e                	add	s4,s4,a5
    80003aae:	757d                	lui	a0,0xfffff
    80003ab0:	00aa77b3          	and	a5,s4,a0
    80003ab4:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003ab8:	4691                	li	a3,4
    80003aba:	6609                	lui	a2,0x2
    80003abc:	963e                	add	a2,a2,a5
    80003abe:	85be                	mv	a1,a5
    80003ac0:	855e                	mv	a0,s7
    80003ac2:	c73fc0ef          	jal	ra,80000734 <uvmalloc>
    80003ac6:	8b2a                	mv	s6,a0
  ip = 0;
    80003ac8:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003aca:	10050e63          	beqz	a0,80003be6 <kexec+0x26c>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003ace:	75f9                	lui	a1,0xffffe
    80003ad0:	95aa                	add	a1,a1,a0
    80003ad2:	855e                	mv	a0,s7
    80003ad4:	e1ffc0ef          	jal	ra,800008f2 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003ad8:	7c7d                	lui	s8,0xfffff
    80003ada:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80003adc:	e0043783          	ld	a5,-512(s0)
    80003ae0:	6388                	ld	a0,0(a5)
    80003ae2:	c125                	beqz	a0,80003b42 <kexec+0x1c8>
    80003ae4:	e9040993          	addi	s3,s0,-368
    80003ae8:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80003aec:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80003aee:	fc4fc0ef          	jal	ra,800002b2 <strlen>
    80003af2:	2505                	addiw	a0,a0,1
    80003af4:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003af8:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80003afc:	11896a63          	bltu	s2,s8,80003c10 <kexec+0x296>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003b00:	e0043d83          	ld	s11,-512(s0)
    80003b04:	000dba03          	ld	s4,0(s11)
    80003b08:	8552                	mv	a0,s4
    80003b0a:	fa8fc0ef          	jal	ra,800002b2 <strlen>
    80003b0e:	0015069b          	addiw	a3,a0,1
    80003b12:	8652                	mv	a2,s4
    80003b14:	85ca                	mv	a1,s2
    80003b16:	855e                	mv	a0,s7
    80003b18:	f47fc0ef          	jal	ra,80000a5e <copyout>
    80003b1c:	0e054e63          	bltz	a0,80003c18 <kexec+0x29e>
    ustack[argc] = sp;
    80003b20:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003b24:	0485                	addi	s1,s1,1
    80003b26:	008d8793          	addi	a5,s11,8
    80003b2a:	e0f43023          	sd	a5,-512(s0)
    80003b2e:	008db503          	ld	a0,8(s11)
    80003b32:	c911                	beqz	a0,80003b46 <kexec+0x1cc>
    if(argc >= MAXARG)
    80003b34:	09a1                	addi	s3,s3,8
    80003b36:	fb3c9ce3          	bne	s9,s3,80003aee <kexec+0x174>
  sz = sz1;
    80003b3a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80003b3e:	4481                	li	s1,0
    80003b40:	a05d                	j	80003be6 <kexec+0x26c>
  sp = sz;
    80003b42:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80003b44:	4481                	li	s1,0
  ustack[argc] = 0;
    80003b46:	00349793          	slli	a5,s1,0x3
    80003b4a:	f9040713          	addi	a4,s0,-112
    80003b4e:	97ba                	add	a5,a5,a4
    80003b50:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80003b54:	00148693          	addi	a3,s1,1
    80003b58:	068e                	slli	a3,a3,0x3
    80003b5a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003b5e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80003b62:	01897663          	bgeu	s2,s8,80003b6e <kexec+0x1f4>
  sz = sz1;
    80003b66:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80003b6a:	4481                	li	s1,0
    80003b6c:	a8ad                	j	80003be6 <kexec+0x26c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003b6e:	e9040613          	addi	a2,s0,-368
    80003b72:	85ca                	mv	a1,s2
    80003b74:	855e                	mv	a0,s7
    80003b76:	ee9fc0ef          	jal	ra,80000a5e <copyout>
    80003b7a:	0a054363          	bltz	a0,80003c20 <kexec+0x2a6>
  p->trapframe->a1 = sp;
    80003b7e:	058ab783          	ld	a5,88(s5)
    80003b82:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003b86:	df843783          	ld	a5,-520(s0)
    80003b8a:	0007c703          	lbu	a4,0(a5)
    80003b8e:	cf11                	beqz	a4,80003baa <kexec+0x230>
    80003b90:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003b92:	02f00693          	li	a3,47
    80003b96:	a039                	j	80003ba4 <kexec+0x22a>
      last = s+1;
    80003b98:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003b9c:	0785                	addi	a5,a5,1
    80003b9e:	fff7c703          	lbu	a4,-1(a5)
    80003ba2:	c701                	beqz	a4,80003baa <kexec+0x230>
    if(*s == '/')
    80003ba4:	fed71ce3          	bne	a4,a3,80003b9c <kexec+0x222>
    80003ba8:	bfc5                	j	80003b98 <kexec+0x21e>
  safestrcpy(p->name, last, sizeof(p->name));
    80003baa:	4641                	li	a2,16
    80003bac:	df843583          	ld	a1,-520(s0)
    80003bb0:	158a8513          	addi	a0,s5,344
    80003bb4:	eccfc0ef          	jal	ra,80000280 <safestrcpy>
  oldpagetable = p->pagetable;
    80003bb8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003bbc:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80003bc0:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003bc4:	058ab783          	ld	a5,88(s5)
    80003bc8:	e6843703          	ld	a4,-408(s0)
    80003bcc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003bce:	058ab783          	ld	a5,88(s5)
    80003bd2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003bd6:	85ea                	mv	a1,s10
    80003bd8:	ac8fd0ef          	jal	ra,80000ea0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003bdc:	0004851b          	sext.w	a0,s1
    80003be0:	bd19                	j	800039f6 <kexec+0x7c>
    80003be2:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80003be6:	e0843583          	ld	a1,-504(s0)
    80003bea:	855e                	mv	a0,s7
    80003bec:	ab4fd0ef          	jal	ra,80000ea0 <proc_freepagetable>
  if(ip){
    80003bf0:	de049de3          	bnez	s1,800039ea <kexec+0x70>
  return -1;
    80003bf4:	557d                	li	a0,-1
    80003bf6:	b501                	j	800039f6 <kexec+0x7c>
    80003bf8:	e1443423          	sd	s4,-504(s0)
    80003bfc:	b7ed                	j	80003be6 <kexec+0x26c>
    80003bfe:	e1443423          	sd	s4,-504(s0)
    80003c02:	b7d5                	j	80003be6 <kexec+0x26c>
    80003c04:	e1443423          	sd	s4,-504(s0)
    80003c08:	bff9                	j	80003be6 <kexec+0x26c>
    80003c0a:	e1443423          	sd	s4,-504(s0)
    80003c0e:	bfe1                	j	80003be6 <kexec+0x26c>
  sz = sz1;
    80003c10:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80003c14:	4481                	li	s1,0
    80003c16:	bfc1                	j	80003be6 <kexec+0x26c>
  sz = sz1;
    80003c18:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80003c1c:	4481                	li	s1,0
    80003c1e:	b7e1                	j	80003be6 <kexec+0x26c>
  sz = sz1;
    80003c20:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80003c24:	4481                	li	s1,0
    80003c26:	b7c1                	j	80003be6 <kexec+0x26c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c28:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c2c:	2b05                	addiw	s6,s6,1
    80003c2e:	0389899b          	addiw	s3,s3,56
    80003c32:	e8845783          	lhu	a5,-376(s0)
    80003c36:	e4fb5fe3          	bge	s6,a5,80003a94 <kexec+0x11a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003c3a:	2981                	sext.w	s3,s3
    80003c3c:	03800713          	li	a4,56
    80003c40:	86ce                	mv	a3,s3
    80003c42:	e1840613          	addi	a2,s0,-488
    80003c46:	4581                	li	a1,0
    80003c48:	8526                	mv	a0,s1
    80003c4a:	d21fe0ef          	jal	ra,8000296a <readi>
    80003c4e:	03800793          	li	a5,56
    80003c52:	f8f518e3          	bne	a0,a5,80003be2 <kexec+0x268>
    if(ph.type != ELF_PROG_LOAD)
    80003c56:	e1842783          	lw	a5,-488(s0)
    80003c5a:	4705                	li	a4,1
    80003c5c:	fce798e3          	bne	a5,a4,80003c2c <kexec+0x2b2>
    if(ph.memsz < ph.filesz)
    80003c60:	e4043903          	ld	s2,-448(s0)
    80003c64:	e3843783          	ld	a5,-456(s0)
    80003c68:	f8f968e3          	bltu	s2,a5,80003bf8 <kexec+0x27e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003c6c:	e2843783          	ld	a5,-472(s0)
    80003c70:	993e                	add	s2,s2,a5
    80003c72:	f8f966e3          	bltu	s2,a5,80003bfe <kexec+0x284>
    if(ph.vaddr % PGSIZE != 0)
    80003c76:	df043703          	ld	a4,-528(s0)
    80003c7a:	8ff9                	and	a5,a5,a4
    80003c7c:	f7c1                	bnez	a5,80003c04 <kexec+0x28a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c7e:	e1c42503          	lw	a0,-484(s0)
    80003c82:	cddff0ef          	jal	ra,8000395e <flags2perm>
    80003c86:	86aa                	mv	a3,a0
    80003c88:	864a                	mv	a2,s2
    80003c8a:	85d2                	mv	a1,s4
    80003c8c:	855e                	mv	a0,s7
    80003c8e:	aa7fc0ef          	jal	ra,80000734 <uvmalloc>
    80003c92:	e0a43423          	sd	a0,-504(s0)
    80003c96:	d935                	beqz	a0,80003c0a <kexec+0x290>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003c98:	e2843d03          	ld	s10,-472(s0)
    80003c9c:	e2042d83          	lw	s11,-480(s0)
    80003ca0:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003ca4:	f80c02e3          	beqz	s8,80003c28 <kexec+0x2ae>
    80003ca8:	8a62                	mv	s4,s8
    80003caa:	4901                	li	s2,0
    80003cac:	b3e9                	j	80003a76 <kexec+0xfc>

0000000080003cae <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003cae:	7179                	addi	sp,sp,-48
    80003cb0:	f406                	sd	ra,40(sp)
    80003cb2:	f022                	sd	s0,32(sp)
    80003cb4:	ec26                	sd	s1,24(sp)
    80003cb6:	e84a                	sd	s2,16(sp)
    80003cb8:	1800                	addi	s0,sp,48
    80003cba:	892e                	mv	s2,a1
    80003cbc:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003cbe:	fdc40593          	addi	a1,s0,-36
    80003cc2:	f45fd0ef          	jal	ra,80001c06 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003cc6:	fdc42703          	lw	a4,-36(s0)
    80003cca:	47bd                	li	a5,15
    80003ccc:	02e7e963          	bltu	a5,a4,80003cfe <argfd+0x50>
    80003cd0:	846fd0ef          	jal	ra,80000d16 <myproc>
    80003cd4:	fdc42703          	lw	a4,-36(s0)
    80003cd8:	01a70793          	addi	a5,a4,26
    80003cdc:	078e                	slli	a5,a5,0x3
    80003cde:	953e                	add	a0,a0,a5
    80003ce0:	611c                	ld	a5,0(a0)
    80003ce2:	c385                	beqz	a5,80003d02 <argfd+0x54>
    return -1;
  if(pfd)
    80003ce4:	00090463          	beqz	s2,80003cec <argfd+0x3e>
    *pfd = fd;
    80003ce8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003cec:	4501                	li	a0,0
  if(pf)
    80003cee:	c091                	beqz	s1,80003cf2 <argfd+0x44>
    *pf = f;
    80003cf0:	e09c                	sd	a5,0(s1)
}
    80003cf2:	70a2                	ld	ra,40(sp)
    80003cf4:	7402                	ld	s0,32(sp)
    80003cf6:	64e2                	ld	s1,24(sp)
    80003cf8:	6942                	ld	s2,16(sp)
    80003cfa:	6145                	addi	sp,sp,48
    80003cfc:	8082                	ret
    return -1;
    80003cfe:	557d                	li	a0,-1
    80003d00:	bfcd                	j	80003cf2 <argfd+0x44>
    80003d02:	557d                	li	a0,-1
    80003d04:	b7fd                	j	80003cf2 <argfd+0x44>

0000000080003d06 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003d06:	1101                	addi	sp,sp,-32
    80003d08:	ec06                	sd	ra,24(sp)
    80003d0a:	e822                	sd	s0,16(sp)
    80003d0c:	e426                	sd	s1,8(sp)
    80003d0e:	1000                	addi	s0,sp,32
    80003d10:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003d12:	804fd0ef          	jal	ra,80000d16 <myproc>
    80003d16:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003d18:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffde528>
    80003d1c:	4501                	li	a0,0
    80003d1e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003d20:	6398                	ld	a4,0(a5)
    80003d22:	cb19                	beqz	a4,80003d38 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003d24:	2505                	addiw	a0,a0,1
    80003d26:	07a1                	addi	a5,a5,8
    80003d28:	fed51ce3          	bne	a0,a3,80003d20 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003d2c:	557d                	li	a0,-1
}
    80003d2e:	60e2                	ld	ra,24(sp)
    80003d30:	6442                	ld	s0,16(sp)
    80003d32:	64a2                	ld	s1,8(sp)
    80003d34:	6105                	addi	sp,sp,32
    80003d36:	8082                	ret
      p->ofile[fd] = f;
    80003d38:	01a50793          	addi	a5,a0,26
    80003d3c:	078e                	slli	a5,a5,0x3
    80003d3e:	963e                	add	a2,a2,a5
    80003d40:	e204                	sd	s1,0(a2)
      return fd;
    80003d42:	b7f5                	j	80003d2e <fdalloc+0x28>

0000000080003d44 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003d44:	715d                	addi	sp,sp,-80
    80003d46:	e486                	sd	ra,72(sp)
    80003d48:	e0a2                	sd	s0,64(sp)
    80003d4a:	fc26                	sd	s1,56(sp)
    80003d4c:	f84a                	sd	s2,48(sp)
    80003d4e:	f44e                	sd	s3,40(sp)
    80003d50:	f052                	sd	s4,32(sp)
    80003d52:	ec56                	sd	s5,24(sp)
    80003d54:	e85a                	sd	s6,16(sp)
    80003d56:	0880                	addi	s0,sp,80
    80003d58:	8b2e                	mv	s6,a1
    80003d5a:	89b2                	mv	s3,a2
    80003d5c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003d5e:	fb040593          	addi	a1,s0,-80
    80003d62:	884ff0ef          	jal	ra,80002de6 <nameiparent>
    80003d66:	84aa                	mv	s1,a0
    80003d68:	10050c63          	beqz	a0,80003e80 <create+0x13c>
    return 0;

  ilock(dp);
    80003d6c:	873fe0ef          	jal	ra,800025de <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003d70:	4601                	li	a2,0
    80003d72:	fb040593          	addi	a1,s0,-80
    80003d76:	8526                	mv	a0,s1
    80003d78:	deffe0ef          	jal	ra,80002b66 <dirlookup>
    80003d7c:	8aaa                	mv	s5,a0
    80003d7e:	c521                	beqz	a0,80003dc6 <create+0x82>
    iunlockput(dp);
    80003d80:	8526                	mv	a0,s1
    80003d82:	a63fe0ef          	jal	ra,800027e4 <iunlockput>
    ilock(ip);
    80003d86:	8556                	mv	a0,s5
    80003d88:	857fe0ef          	jal	ra,800025de <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003d8c:	000b059b          	sext.w	a1,s6
    80003d90:	4789                	li	a5,2
    80003d92:	02f59563          	bne	a1,a5,80003dbc <create+0x78>
    80003d96:	044ad783          	lhu	a5,68(s5)
    80003d9a:	37f9                	addiw	a5,a5,-2
    80003d9c:	17c2                	slli	a5,a5,0x30
    80003d9e:	93c1                	srli	a5,a5,0x30
    80003da0:	4705                	li	a4,1
    80003da2:	00f76d63          	bltu	a4,a5,80003dbc <create+0x78>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003da6:	8556                	mv	a0,s5
    80003da8:	60a6                	ld	ra,72(sp)
    80003daa:	6406                	ld	s0,64(sp)
    80003dac:	74e2                	ld	s1,56(sp)
    80003dae:	7942                	ld	s2,48(sp)
    80003db0:	79a2                	ld	s3,40(sp)
    80003db2:	7a02                	ld	s4,32(sp)
    80003db4:	6ae2                	ld	s5,24(sp)
    80003db6:	6b42                	ld	s6,16(sp)
    80003db8:	6161                	addi	sp,sp,80
    80003dba:	8082                	ret
    iunlockput(ip);
    80003dbc:	8556                	mv	a0,s5
    80003dbe:	a27fe0ef          	jal	ra,800027e4 <iunlockput>
    return 0;
    80003dc2:	4a81                	li	s5,0
    80003dc4:	b7cd                	j	80003da6 <create+0x62>
  if((ip = ialloc(dp->dev, type)) == 0){
    80003dc6:	85da                	mv	a1,s6
    80003dc8:	4088                	lw	a0,0(s1)
    80003dca:	eacfe0ef          	jal	ra,80002476 <ialloc>
    80003dce:	8a2a                	mv	s4,a0
    80003dd0:	c121                	beqz	a0,80003e10 <create+0xcc>
  ilock(ip);
    80003dd2:	80dfe0ef          	jal	ra,800025de <ilock>
  ip->major = major;
    80003dd6:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003dda:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003dde:	4785                	li	a5,1
    80003de0:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80003de4:	8552                	mv	a0,s4
    80003de6:	f46fe0ef          	jal	ra,8000252c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003dea:	000b059b          	sext.w	a1,s6
    80003dee:	4785                	li	a5,1
    80003df0:	02f58563          	beq	a1,a5,80003e1a <create+0xd6>
  if(dirlink(dp, name, ip->inum) < 0)
    80003df4:	004a2603          	lw	a2,4(s4)
    80003df8:	fb040593          	addi	a1,s0,-80
    80003dfc:	8526                	mv	a0,s1
    80003dfe:	f35fe0ef          	jal	ra,80002d32 <dirlink>
    80003e02:	06054363          	bltz	a0,80003e68 <create+0x124>
  iunlockput(dp);
    80003e06:	8526                	mv	a0,s1
    80003e08:	9ddfe0ef          	jal	ra,800027e4 <iunlockput>
  return ip;
    80003e0c:	8ad2                	mv	s5,s4
    80003e0e:	bf61                	j	80003da6 <create+0x62>
    iunlockput(dp);
    80003e10:	8526                	mv	a0,s1
    80003e12:	9d3fe0ef          	jal	ra,800027e4 <iunlockput>
    return 0;
    80003e16:	8ad2                	mv	s5,s4
    80003e18:	b779                	j	80003da6 <create+0x62>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003e1a:	004a2603          	lw	a2,4(s4)
    80003e1e:	00004597          	auipc	a1,0x4
    80003e22:	85258593          	addi	a1,a1,-1966 # 80007670 <syscalls+0x2e0>
    80003e26:	8552                	mv	a0,s4
    80003e28:	f0bfe0ef          	jal	ra,80002d32 <dirlink>
    80003e2c:	02054e63          	bltz	a0,80003e68 <create+0x124>
    80003e30:	40d0                	lw	a2,4(s1)
    80003e32:	00004597          	auipc	a1,0x4
    80003e36:	84658593          	addi	a1,a1,-1978 # 80007678 <syscalls+0x2e8>
    80003e3a:	8552                	mv	a0,s4
    80003e3c:	ef7fe0ef          	jal	ra,80002d32 <dirlink>
    80003e40:	02054463          	bltz	a0,80003e68 <create+0x124>
  if(dirlink(dp, name, ip->inum) < 0)
    80003e44:	004a2603          	lw	a2,4(s4)
    80003e48:	fb040593          	addi	a1,s0,-80
    80003e4c:	8526                	mv	a0,s1
    80003e4e:	ee5fe0ef          	jal	ra,80002d32 <dirlink>
    80003e52:	00054b63          	bltz	a0,80003e68 <create+0x124>
    dp->nlink++;  // for ".."
    80003e56:	04a4d783          	lhu	a5,74(s1)
    80003e5a:	2785                	addiw	a5,a5,1
    80003e5c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003e60:	8526                	mv	a0,s1
    80003e62:	ecafe0ef          	jal	ra,8000252c <iupdate>
    80003e66:	b745                	j	80003e06 <create+0xc2>
  ip->nlink = 0;
    80003e68:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003e6c:	8552                	mv	a0,s4
    80003e6e:	ebefe0ef          	jal	ra,8000252c <iupdate>
  iunlockput(ip);
    80003e72:	8552                	mv	a0,s4
    80003e74:	971fe0ef          	jal	ra,800027e4 <iunlockput>
  iunlockput(dp);
    80003e78:	8526                	mv	a0,s1
    80003e7a:	96bfe0ef          	jal	ra,800027e4 <iunlockput>
  return 0;
    80003e7e:	b725                	j	80003da6 <create+0x62>
    return 0;
    80003e80:	8aaa                	mv	s5,a0
    80003e82:	b715                	j	80003da6 <create+0x62>

0000000080003e84 <sys_dup>:
{
    80003e84:	7179                	addi	sp,sp,-48
    80003e86:	f406                	sd	ra,40(sp)
    80003e88:	f022                	sd	s0,32(sp)
    80003e8a:	ec26                	sd	s1,24(sp)
    80003e8c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003e8e:	fd840613          	addi	a2,s0,-40
    80003e92:	4581                	li	a1,0
    80003e94:	4501                	li	a0,0
    80003e96:	e19ff0ef          	jal	ra,80003cae <argfd>
    return -1;
    80003e9a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003e9c:	00054f63          	bltz	a0,80003eba <sys_dup+0x36>
  if((fd=fdalloc(f)) < 0)
    80003ea0:	fd843503          	ld	a0,-40(s0)
    80003ea4:	e63ff0ef          	jal	ra,80003d06 <fdalloc>
    80003ea8:	84aa                	mv	s1,a0
    return -1;
    80003eaa:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003eac:	00054763          	bltz	a0,80003eba <sys_dup+0x36>
  filedup(f);
    80003eb0:	fd843503          	ld	a0,-40(s0)
    80003eb4:	cd0ff0ef          	jal	ra,80003384 <filedup>
  return fd;
    80003eb8:	87a6                	mv	a5,s1
}
    80003eba:	853e                	mv	a0,a5
    80003ebc:	70a2                	ld	ra,40(sp)
    80003ebe:	7402                	ld	s0,32(sp)
    80003ec0:	64e2                	ld	s1,24(sp)
    80003ec2:	6145                	addi	sp,sp,48
    80003ec4:	8082                	ret

0000000080003ec6 <sys_read>:
{
    80003ec6:	7179                	addi	sp,sp,-48
    80003ec8:	f406                	sd	ra,40(sp)
    80003eca:	f022                	sd	s0,32(sp)
    80003ecc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003ece:	fd840593          	addi	a1,s0,-40
    80003ed2:	4505                	li	a0,1
    80003ed4:	d4ffd0ef          	jal	ra,80001c22 <argaddr>
  argint(2, &n);
    80003ed8:	fe440593          	addi	a1,s0,-28
    80003edc:	4509                	li	a0,2
    80003ede:	d29fd0ef          	jal	ra,80001c06 <argint>
  if(argfd(0, 0, &f) < 0)
    80003ee2:	fe840613          	addi	a2,s0,-24
    80003ee6:	4581                	li	a1,0
    80003ee8:	4501                	li	a0,0
    80003eea:	dc5ff0ef          	jal	ra,80003cae <argfd>
    80003eee:	87aa                	mv	a5,a0
    return -1;
    80003ef0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003ef2:	0007ca63          	bltz	a5,80003f06 <sys_read+0x40>
  return fileread(f, p, n);
    80003ef6:	fe442603          	lw	a2,-28(s0)
    80003efa:	fd843583          	ld	a1,-40(s0)
    80003efe:	fe843503          	ld	a0,-24(s0)
    80003f02:	dceff0ef          	jal	ra,800034d0 <fileread>
}
    80003f06:	70a2                	ld	ra,40(sp)
    80003f08:	7402                	ld	s0,32(sp)
    80003f0a:	6145                	addi	sp,sp,48
    80003f0c:	8082                	ret

0000000080003f0e <sys_write>:
{
    80003f0e:	7179                	addi	sp,sp,-48
    80003f10:	f406                	sd	ra,40(sp)
    80003f12:	f022                	sd	s0,32(sp)
    80003f14:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003f16:	fd840593          	addi	a1,s0,-40
    80003f1a:	4505                	li	a0,1
    80003f1c:	d07fd0ef          	jal	ra,80001c22 <argaddr>
  argint(2, &n);
    80003f20:	fe440593          	addi	a1,s0,-28
    80003f24:	4509                	li	a0,2
    80003f26:	ce1fd0ef          	jal	ra,80001c06 <argint>
  if(argfd(0, 0, &f) < 0)
    80003f2a:	fe840613          	addi	a2,s0,-24
    80003f2e:	4581                	li	a1,0
    80003f30:	4501                	li	a0,0
    80003f32:	d7dff0ef          	jal	ra,80003cae <argfd>
    80003f36:	87aa                	mv	a5,a0
    return -1;
    80003f38:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f3a:	0007ca63          	bltz	a5,80003f4e <sys_write+0x40>
  return filewrite(f, p, n);
    80003f3e:	fe442603          	lw	a2,-28(s0)
    80003f42:	fd843583          	ld	a1,-40(s0)
    80003f46:	fe843503          	ld	a0,-24(s0)
    80003f4a:	e34ff0ef          	jal	ra,8000357e <filewrite>
}
    80003f4e:	70a2                	ld	ra,40(sp)
    80003f50:	7402                	ld	s0,32(sp)
    80003f52:	6145                	addi	sp,sp,48
    80003f54:	8082                	ret

0000000080003f56 <sys_close>:
{
    80003f56:	1101                	addi	sp,sp,-32
    80003f58:	ec06                	sd	ra,24(sp)
    80003f5a:	e822                	sd	s0,16(sp)
    80003f5c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003f5e:	fe040613          	addi	a2,s0,-32
    80003f62:	fec40593          	addi	a1,s0,-20
    80003f66:	4501                	li	a0,0
    80003f68:	d47ff0ef          	jal	ra,80003cae <argfd>
    return -1;
    80003f6c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003f6e:	02054063          	bltz	a0,80003f8e <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003f72:	da5fc0ef          	jal	ra,80000d16 <myproc>
    80003f76:	fec42783          	lw	a5,-20(s0)
    80003f7a:	07e9                	addi	a5,a5,26
    80003f7c:	078e                	slli	a5,a5,0x3
    80003f7e:	97aa                	add	a5,a5,a0
    80003f80:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80003f84:	fe043503          	ld	a0,-32(s0)
    80003f88:	c42ff0ef          	jal	ra,800033ca <fileclose>
  return 0;
    80003f8c:	4781                	li	a5,0
}
    80003f8e:	853e                	mv	a0,a5
    80003f90:	60e2                	ld	ra,24(sp)
    80003f92:	6442                	ld	s0,16(sp)
    80003f94:	6105                	addi	sp,sp,32
    80003f96:	8082                	ret

0000000080003f98 <sys_fstat>:
{
    80003f98:	1101                	addi	sp,sp,-32
    80003f9a:	ec06                	sd	ra,24(sp)
    80003f9c:	e822                	sd	s0,16(sp)
    80003f9e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80003fa0:	fe040593          	addi	a1,s0,-32
    80003fa4:	4505                	li	a0,1
    80003fa6:	c7dfd0ef          	jal	ra,80001c22 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80003faa:	fe840613          	addi	a2,s0,-24
    80003fae:	4581                	li	a1,0
    80003fb0:	4501                	li	a0,0
    80003fb2:	cfdff0ef          	jal	ra,80003cae <argfd>
    80003fb6:	87aa                	mv	a5,a0
    return -1;
    80003fb8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003fba:	0007c863          	bltz	a5,80003fca <sys_fstat+0x32>
  return filestat(f, st);
    80003fbe:	fe043583          	ld	a1,-32(s0)
    80003fc2:	fe843503          	ld	a0,-24(s0)
    80003fc6:	cacff0ef          	jal	ra,80003472 <filestat>
}
    80003fca:	60e2                	ld	ra,24(sp)
    80003fcc:	6442                	ld	s0,16(sp)
    80003fce:	6105                	addi	sp,sp,32
    80003fd0:	8082                	ret

0000000080003fd2 <sys_link>:
{
    80003fd2:	7169                	addi	sp,sp,-304
    80003fd4:	f606                	sd	ra,296(sp)
    80003fd6:	f222                	sd	s0,288(sp)
    80003fd8:	ee26                	sd	s1,280(sp)
    80003fda:	ea4a                	sd	s2,272(sp)
    80003fdc:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003fde:	08000613          	li	a2,128
    80003fe2:	ed040593          	addi	a1,s0,-304
    80003fe6:	4501                	li	a0,0
    80003fe8:	c57fd0ef          	jal	ra,80001c3e <argstr>
    return -1;
    80003fec:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003fee:	0c054663          	bltz	a0,800040ba <sys_link+0xe8>
    80003ff2:	08000613          	li	a2,128
    80003ff6:	f5040593          	addi	a1,s0,-176
    80003ffa:	4505                	li	a0,1
    80003ffc:	c43fd0ef          	jal	ra,80001c3e <argstr>
    return -1;
    80004000:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004002:	0a054c63          	bltz	a0,800040ba <sys_link+0xe8>
  begin_op();
    80004006:	fb7fe0ef          	jal	ra,80002fbc <begin_op>
  if((ip = namei(old)) == 0){
    8000400a:	ed040513          	addi	a0,s0,-304
    8000400e:	dbffe0ef          	jal	ra,80002dcc <namei>
    80004012:	84aa                	mv	s1,a0
    80004014:	c525                	beqz	a0,8000407c <sys_link+0xaa>
  ilock(ip);
    80004016:	dc8fe0ef          	jal	ra,800025de <ilock>
  if(ip->type == T_DIR){
    8000401a:	04449703          	lh	a4,68(s1)
    8000401e:	4785                	li	a5,1
    80004020:	06f70263          	beq	a4,a5,80004084 <sys_link+0xb2>
  ip->nlink++;
    80004024:	04a4d783          	lhu	a5,74(s1)
    80004028:	2785                	addiw	a5,a5,1
    8000402a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000402e:	8526                	mv	a0,s1
    80004030:	cfcfe0ef          	jal	ra,8000252c <iupdate>
  iunlock(ip);
    80004034:	8526                	mv	a0,s1
    80004036:	e52fe0ef          	jal	ra,80002688 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000403a:	fd040593          	addi	a1,s0,-48
    8000403e:	f5040513          	addi	a0,s0,-176
    80004042:	da5fe0ef          	jal	ra,80002de6 <nameiparent>
    80004046:	892a                	mv	s2,a0
    80004048:	c921                	beqz	a0,80004098 <sys_link+0xc6>
  ilock(dp);
    8000404a:	d94fe0ef          	jal	ra,800025de <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000404e:	00092703          	lw	a4,0(s2)
    80004052:	409c                	lw	a5,0(s1)
    80004054:	02f71f63          	bne	a4,a5,80004092 <sys_link+0xc0>
    80004058:	40d0                	lw	a2,4(s1)
    8000405a:	fd040593          	addi	a1,s0,-48
    8000405e:	854a                	mv	a0,s2
    80004060:	cd3fe0ef          	jal	ra,80002d32 <dirlink>
    80004064:	02054763          	bltz	a0,80004092 <sys_link+0xc0>
  iunlockput(dp);
    80004068:	854a                	mv	a0,s2
    8000406a:	f7afe0ef          	jal	ra,800027e4 <iunlockput>
  iput(ip);
    8000406e:	8526                	mv	a0,s1
    80004070:	eecfe0ef          	jal	ra,8000275c <iput>
  end_op();
    80004074:	fb9fe0ef          	jal	ra,8000302c <end_op>
  return 0;
    80004078:	4781                	li	a5,0
    8000407a:	a081                	j	800040ba <sys_link+0xe8>
    end_op();
    8000407c:	fb1fe0ef          	jal	ra,8000302c <end_op>
    return -1;
    80004080:	57fd                	li	a5,-1
    80004082:	a825                	j	800040ba <sys_link+0xe8>
    iunlockput(ip);
    80004084:	8526                	mv	a0,s1
    80004086:	f5efe0ef          	jal	ra,800027e4 <iunlockput>
    end_op();
    8000408a:	fa3fe0ef          	jal	ra,8000302c <end_op>
    return -1;
    8000408e:	57fd                	li	a5,-1
    80004090:	a02d                	j	800040ba <sys_link+0xe8>
    iunlockput(dp);
    80004092:	854a                	mv	a0,s2
    80004094:	f50fe0ef          	jal	ra,800027e4 <iunlockput>
  ilock(ip);
    80004098:	8526                	mv	a0,s1
    8000409a:	d44fe0ef          	jal	ra,800025de <ilock>
  ip->nlink--;
    8000409e:	04a4d783          	lhu	a5,74(s1)
    800040a2:	37fd                	addiw	a5,a5,-1
    800040a4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800040a8:	8526                	mv	a0,s1
    800040aa:	c82fe0ef          	jal	ra,8000252c <iupdate>
  iunlockput(ip);
    800040ae:	8526                	mv	a0,s1
    800040b0:	f34fe0ef          	jal	ra,800027e4 <iunlockput>
  end_op();
    800040b4:	f79fe0ef          	jal	ra,8000302c <end_op>
  return -1;
    800040b8:	57fd                	li	a5,-1
}
    800040ba:	853e                	mv	a0,a5
    800040bc:	70b2                	ld	ra,296(sp)
    800040be:	7412                	ld	s0,288(sp)
    800040c0:	64f2                	ld	s1,280(sp)
    800040c2:	6952                	ld	s2,272(sp)
    800040c4:	6155                	addi	sp,sp,304
    800040c6:	8082                	ret

00000000800040c8 <sys_unlink>:
{
    800040c8:	7151                	addi	sp,sp,-240
    800040ca:	f586                	sd	ra,232(sp)
    800040cc:	f1a2                	sd	s0,224(sp)
    800040ce:	eda6                	sd	s1,216(sp)
    800040d0:	e9ca                	sd	s2,208(sp)
    800040d2:	e5ce                	sd	s3,200(sp)
    800040d4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800040d6:	08000613          	li	a2,128
    800040da:	f3040593          	addi	a1,s0,-208
    800040de:	4501                	li	a0,0
    800040e0:	b5ffd0ef          	jal	ra,80001c3e <argstr>
    800040e4:	12054b63          	bltz	a0,8000421a <sys_unlink+0x152>
  begin_op();
    800040e8:	ed5fe0ef          	jal	ra,80002fbc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800040ec:	fb040593          	addi	a1,s0,-80
    800040f0:	f3040513          	addi	a0,s0,-208
    800040f4:	cf3fe0ef          	jal	ra,80002de6 <nameiparent>
    800040f8:	84aa                	mv	s1,a0
    800040fa:	c54d                	beqz	a0,800041a4 <sys_unlink+0xdc>
  ilock(dp);
    800040fc:	ce2fe0ef          	jal	ra,800025de <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004100:	00003597          	auipc	a1,0x3
    80004104:	57058593          	addi	a1,a1,1392 # 80007670 <syscalls+0x2e0>
    80004108:	fb040513          	addi	a0,s0,-80
    8000410c:	a45fe0ef          	jal	ra,80002b50 <namecmp>
    80004110:	10050a63          	beqz	a0,80004224 <sys_unlink+0x15c>
    80004114:	00003597          	auipc	a1,0x3
    80004118:	56458593          	addi	a1,a1,1380 # 80007678 <syscalls+0x2e8>
    8000411c:	fb040513          	addi	a0,s0,-80
    80004120:	a31fe0ef          	jal	ra,80002b50 <namecmp>
    80004124:	10050063          	beqz	a0,80004224 <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004128:	f2c40613          	addi	a2,s0,-212
    8000412c:	fb040593          	addi	a1,s0,-80
    80004130:	8526                	mv	a0,s1
    80004132:	a35fe0ef          	jal	ra,80002b66 <dirlookup>
    80004136:	892a                	mv	s2,a0
    80004138:	0e050663          	beqz	a0,80004224 <sys_unlink+0x15c>
  ilock(ip);
    8000413c:	ca2fe0ef          	jal	ra,800025de <ilock>
  if(ip->nlink < 1)
    80004140:	04a91783          	lh	a5,74(s2)
    80004144:	06f05463          	blez	a5,800041ac <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004148:	04491703          	lh	a4,68(s2)
    8000414c:	4785                	li	a5,1
    8000414e:	06f70563          	beq	a4,a5,800041b8 <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004152:	4641                	li	a2,16
    80004154:	4581                	li	a1,0
    80004156:	fc040513          	addi	a0,s0,-64
    8000415a:	fd9fb0ef          	jal	ra,80000132 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000415e:	4741                	li	a4,16
    80004160:	f2c42683          	lw	a3,-212(s0)
    80004164:	fc040613          	addi	a2,s0,-64
    80004168:	4581                	li	a1,0
    8000416a:	8526                	mv	a0,s1
    8000416c:	8e3fe0ef          	jal	ra,80002a4e <writei>
    80004170:	47c1                	li	a5,16
    80004172:	08f51563          	bne	a0,a5,800041fc <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004176:	04491703          	lh	a4,68(s2)
    8000417a:	4785                	li	a5,1
    8000417c:	08f70663          	beq	a4,a5,80004208 <sys_unlink+0x140>
  iunlockput(dp);
    80004180:	8526                	mv	a0,s1
    80004182:	e62fe0ef          	jal	ra,800027e4 <iunlockput>
  ip->nlink--;
    80004186:	04a95783          	lhu	a5,74(s2)
    8000418a:	37fd                	addiw	a5,a5,-1
    8000418c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004190:	854a                	mv	a0,s2
    80004192:	b9afe0ef          	jal	ra,8000252c <iupdate>
  iunlockput(ip);
    80004196:	854a                	mv	a0,s2
    80004198:	e4cfe0ef          	jal	ra,800027e4 <iunlockput>
  end_op();
    8000419c:	e91fe0ef          	jal	ra,8000302c <end_op>
  return 0;
    800041a0:	4501                	li	a0,0
    800041a2:	a079                	j	80004230 <sys_unlink+0x168>
    end_op();
    800041a4:	e89fe0ef          	jal	ra,8000302c <end_op>
    return -1;
    800041a8:	557d                	li	a0,-1
    800041aa:	a059                	j	80004230 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    800041ac:	00003517          	auipc	a0,0x3
    800041b0:	4d450513          	addi	a0,a0,1236 # 80007680 <syscalls+0x2f0>
    800041b4:	262010ef          	jal	ra,80005416 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800041b8:	04c92703          	lw	a4,76(s2)
    800041bc:	02000793          	li	a5,32
    800041c0:	f8e7f9e3          	bgeu	a5,a4,80004152 <sys_unlink+0x8a>
    800041c4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041c8:	4741                	li	a4,16
    800041ca:	86ce                	mv	a3,s3
    800041cc:	f1840613          	addi	a2,s0,-232
    800041d0:	4581                	li	a1,0
    800041d2:	854a                	mv	a0,s2
    800041d4:	f96fe0ef          	jal	ra,8000296a <readi>
    800041d8:	47c1                	li	a5,16
    800041da:	00f51b63          	bne	a0,a5,800041f0 <sys_unlink+0x128>
    if(de.inum != 0)
    800041de:	f1845783          	lhu	a5,-232(s0)
    800041e2:	ef95                	bnez	a5,8000421e <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800041e4:	29c1                	addiw	s3,s3,16
    800041e6:	04c92783          	lw	a5,76(s2)
    800041ea:	fcf9efe3          	bltu	s3,a5,800041c8 <sys_unlink+0x100>
    800041ee:	b795                	j	80004152 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800041f0:	00003517          	auipc	a0,0x3
    800041f4:	4a850513          	addi	a0,a0,1192 # 80007698 <syscalls+0x308>
    800041f8:	21e010ef          	jal	ra,80005416 <panic>
    panic("unlink: writei");
    800041fc:	00003517          	auipc	a0,0x3
    80004200:	4b450513          	addi	a0,a0,1204 # 800076b0 <syscalls+0x320>
    80004204:	212010ef          	jal	ra,80005416 <panic>
    dp->nlink--;
    80004208:	04a4d783          	lhu	a5,74(s1)
    8000420c:	37fd                	addiw	a5,a5,-1
    8000420e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004212:	8526                	mv	a0,s1
    80004214:	b18fe0ef          	jal	ra,8000252c <iupdate>
    80004218:	b7a5                	j	80004180 <sys_unlink+0xb8>
    return -1;
    8000421a:	557d                	li	a0,-1
    8000421c:	a811                	j	80004230 <sys_unlink+0x168>
    iunlockput(ip);
    8000421e:	854a                	mv	a0,s2
    80004220:	dc4fe0ef          	jal	ra,800027e4 <iunlockput>
  iunlockput(dp);
    80004224:	8526                	mv	a0,s1
    80004226:	dbefe0ef          	jal	ra,800027e4 <iunlockput>
  end_op();
    8000422a:	e03fe0ef          	jal	ra,8000302c <end_op>
  return -1;
    8000422e:	557d                	li	a0,-1
}
    80004230:	70ae                	ld	ra,232(sp)
    80004232:	740e                	ld	s0,224(sp)
    80004234:	64ee                	ld	s1,216(sp)
    80004236:	694e                	ld	s2,208(sp)
    80004238:	69ae                	ld	s3,200(sp)
    8000423a:	616d                	addi	sp,sp,240
    8000423c:	8082                	ret

000000008000423e <sys_open>:

uint64
sys_open(void)
{
    8000423e:	7131                	addi	sp,sp,-192
    80004240:	fd06                	sd	ra,184(sp)
    80004242:	f922                	sd	s0,176(sp)
    80004244:	f526                	sd	s1,168(sp)
    80004246:	f14a                	sd	s2,160(sp)
    80004248:	ed4e                	sd	s3,152(sp)
    8000424a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000424c:	f4c40593          	addi	a1,s0,-180
    80004250:	4505                	li	a0,1
    80004252:	9b5fd0ef          	jal	ra,80001c06 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004256:	08000613          	li	a2,128
    8000425a:	f5040593          	addi	a1,s0,-176
    8000425e:	4501                	li	a0,0
    80004260:	9dffd0ef          	jal	ra,80001c3e <argstr>
    80004264:	87aa                	mv	a5,a0
    return -1;
    80004266:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004268:	0807cd63          	bltz	a5,80004302 <sys_open+0xc4>

  begin_op();
    8000426c:	d51fe0ef          	jal	ra,80002fbc <begin_op>

  if(omode & O_CREATE){
    80004270:	f4c42783          	lw	a5,-180(s0)
    80004274:	2007f793          	andi	a5,a5,512
    80004278:	c3c5                	beqz	a5,80004318 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000427a:	4681                	li	a3,0
    8000427c:	4601                	li	a2,0
    8000427e:	4589                	li	a1,2
    80004280:	f5040513          	addi	a0,s0,-176
    80004284:	ac1ff0ef          	jal	ra,80003d44 <create>
    80004288:	84aa                	mv	s1,a0
    if(ip == 0){
    8000428a:	c159                	beqz	a0,80004310 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000428c:	04449703          	lh	a4,68(s1)
    80004290:	478d                	li	a5,3
    80004292:	00f71763          	bne	a4,a5,800042a0 <sys_open+0x62>
    80004296:	0464d703          	lhu	a4,70(s1)
    8000429a:	47a5                	li	a5,9
    8000429c:	0ae7e963          	bltu	a5,a4,8000434e <sys_open+0x110>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800042a0:	886ff0ef          	jal	ra,80003326 <filealloc>
    800042a4:	89aa                	mv	s3,a0
    800042a6:	0c050963          	beqz	a0,80004378 <sys_open+0x13a>
    800042aa:	a5dff0ef          	jal	ra,80003d06 <fdalloc>
    800042ae:	892a                	mv	s2,a0
    800042b0:	0c054163          	bltz	a0,80004372 <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800042b4:	04449703          	lh	a4,68(s1)
    800042b8:	478d                	li	a5,3
    800042ba:	0af70163          	beq	a4,a5,8000435c <sys_open+0x11e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800042be:	4789                	li	a5,2
    800042c0:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800042c4:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800042c8:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    800042cc:	f4c42783          	lw	a5,-180(s0)
    800042d0:	0017c713          	xori	a4,a5,1
    800042d4:	8b05                	andi	a4,a4,1
    800042d6:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800042da:	0037f713          	andi	a4,a5,3
    800042de:	00e03733          	snez	a4,a4
    800042e2:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800042e6:	4007f793          	andi	a5,a5,1024
    800042ea:	c791                	beqz	a5,800042f6 <sys_open+0xb8>
    800042ec:	04449703          	lh	a4,68(s1)
    800042f0:	4789                	li	a5,2
    800042f2:	06f70c63          	beq	a4,a5,8000436a <sys_open+0x12c>
    itrunc(ip);
  }

  iunlock(ip);
    800042f6:	8526                	mv	a0,s1
    800042f8:	b90fe0ef          	jal	ra,80002688 <iunlock>
  end_op();
    800042fc:	d31fe0ef          	jal	ra,8000302c <end_op>

  return fd;
    80004300:	854a                	mv	a0,s2
}
    80004302:	70ea                	ld	ra,184(sp)
    80004304:	744a                	ld	s0,176(sp)
    80004306:	74aa                	ld	s1,168(sp)
    80004308:	790a                	ld	s2,160(sp)
    8000430a:	69ea                	ld	s3,152(sp)
    8000430c:	6129                	addi	sp,sp,192
    8000430e:	8082                	ret
      end_op();
    80004310:	d1dfe0ef          	jal	ra,8000302c <end_op>
      return -1;
    80004314:	557d                	li	a0,-1
    80004316:	b7f5                	j	80004302 <sys_open+0xc4>
    if((ip = namei(path)) == 0){
    80004318:	f5040513          	addi	a0,s0,-176
    8000431c:	ab1fe0ef          	jal	ra,80002dcc <namei>
    80004320:	84aa                	mv	s1,a0
    80004322:	c115                	beqz	a0,80004346 <sys_open+0x108>
    ilock(ip);
    80004324:	abafe0ef          	jal	ra,800025de <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004328:	04449703          	lh	a4,68(s1)
    8000432c:	4785                	li	a5,1
    8000432e:	f4f71fe3          	bne	a4,a5,8000428c <sys_open+0x4e>
    80004332:	f4c42783          	lw	a5,-180(s0)
    80004336:	d7ad                	beqz	a5,800042a0 <sys_open+0x62>
      iunlockput(ip);
    80004338:	8526                	mv	a0,s1
    8000433a:	caafe0ef          	jal	ra,800027e4 <iunlockput>
      end_op();
    8000433e:	ceffe0ef          	jal	ra,8000302c <end_op>
      return -1;
    80004342:	557d                	li	a0,-1
    80004344:	bf7d                	j	80004302 <sys_open+0xc4>
      end_op();
    80004346:	ce7fe0ef          	jal	ra,8000302c <end_op>
      return -1;
    8000434a:	557d                	li	a0,-1
    8000434c:	bf5d                	j	80004302 <sys_open+0xc4>
    iunlockput(ip);
    8000434e:	8526                	mv	a0,s1
    80004350:	c94fe0ef          	jal	ra,800027e4 <iunlockput>
    end_op();
    80004354:	cd9fe0ef          	jal	ra,8000302c <end_op>
    return -1;
    80004358:	557d                	li	a0,-1
    8000435a:	b765                	j	80004302 <sys_open+0xc4>
    f->type = FD_DEVICE;
    8000435c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004360:	04649783          	lh	a5,70(s1)
    80004364:	02f99223          	sh	a5,36(s3)
    80004368:	b785                	j	800042c8 <sys_open+0x8a>
    itrunc(ip);
    8000436a:	8526                	mv	a0,s1
    8000436c:	b5cfe0ef          	jal	ra,800026c8 <itrunc>
    80004370:	b759                	j	800042f6 <sys_open+0xb8>
      fileclose(f);
    80004372:	854e                	mv	a0,s3
    80004374:	856ff0ef          	jal	ra,800033ca <fileclose>
    iunlockput(ip);
    80004378:	8526                	mv	a0,s1
    8000437a:	c6afe0ef          	jal	ra,800027e4 <iunlockput>
    end_op();
    8000437e:	caffe0ef          	jal	ra,8000302c <end_op>
    return -1;
    80004382:	557d                	li	a0,-1
    80004384:	bfbd                	j	80004302 <sys_open+0xc4>

0000000080004386 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004386:	7175                	addi	sp,sp,-144
    80004388:	e506                	sd	ra,136(sp)
    8000438a:	e122                	sd	s0,128(sp)
    8000438c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000438e:	c2ffe0ef          	jal	ra,80002fbc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004392:	08000613          	li	a2,128
    80004396:	f7040593          	addi	a1,s0,-144
    8000439a:	4501                	li	a0,0
    8000439c:	8a3fd0ef          	jal	ra,80001c3e <argstr>
    800043a0:	02054363          	bltz	a0,800043c6 <sys_mkdir+0x40>
    800043a4:	4681                	li	a3,0
    800043a6:	4601                	li	a2,0
    800043a8:	4585                	li	a1,1
    800043aa:	f7040513          	addi	a0,s0,-144
    800043ae:	997ff0ef          	jal	ra,80003d44 <create>
    800043b2:	c911                	beqz	a0,800043c6 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800043b4:	c30fe0ef          	jal	ra,800027e4 <iunlockput>
  end_op();
    800043b8:	c75fe0ef          	jal	ra,8000302c <end_op>
  return 0;
    800043bc:	4501                	li	a0,0
}
    800043be:	60aa                	ld	ra,136(sp)
    800043c0:	640a                	ld	s0,128(sp)
    800043c2:	6149                	addi	sp,sp,144
    800043c4:	8082                	ret
    end_op();
    800043c6:	c67fe0ef          	jal	ra,8000302c <end_op>
    return -1;
    800043ca:	557d                	li	a0,-1
    800043cc:	bfcd                	j	800043be <sys_mkdir+0x38>

00000000800043ce <sys_mknod>:

uint64
sys_mknod(void)
{
    800043ce:	7135                	addi	sp,sp,-160
    800043d0:	ed06                	sd	ra,152(sp)
    800043d2:	e922                	sd	s0,144(sp)
    800043d4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800043d6:	be7fe0ef          	jal	ra,80002fbc <begin_op>
  argint(1, &major);
    800043da:	f6c40593          	addi	a1,s0,-148
    800043de:	4505                	li	a0,1
    800043e0:	827fd0ef          	jal	ra,80001c06 <argint>
  argint(2, &minor);
    800043e4:	f6840593          	addi	a1,s0,-152
    800043e8:	4509                	li	a0,2
    800043ea:	81dfd0ef          	jal	ra,80001c06 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800043ee:	08000613          	li	a2,128
    800043f2:	f7040593          	addi	a1,s0,-144
    800043f6:	4501                	li	a0,0
    800043f8:	847fd0ef          	jal	ra,80001c3e <argstr>
    800043fc:	02054563          	bltz	a0,80004426 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004400:	f6841683          	lh	a3,-152(s0)
    80004404:	f6c41603          	lh	a2,-148(s0)
    80004408:	458d                	li	a1,3
    8000440a:	f7040513          	addi	a0,s0,-144
    8000440e:	937ff0ef          	jal	ra,80003d44 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004412:	c911                	beqz	a0,80004426 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004414:	bd0fe0ef          	jal	ra,800027e4 <iunlockput>
  end_op();
    80004418:	c15fe0ef          	jal	ra,8000302c <end_op>
  return 0;
    8000441c:	4501                	li	a0,0
}
    8000441e:	60ea                	ld	ra,152(sp)
    80004420:	644a                	ld	s0,144(sp)
    80004422:	610d                	addi	sp,sp,160
    80004424:	8082                	ret
    end_op();
    80004426:	c07fe0ef          	jal	ra,8000302c <end_op>
    return -1;
    8000442a:	557d                	li	a0,-1
    8000442c:	bfcd                	j	8000441e <sys_mknod+0x50>

000000008000442e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000442e:	7135                	addi	sp,sp,-160
    80004430:	ed06                	sd	ra,152(sp)
    80004432:	e922                	sd	s0,144(sp)
    80004434:	e526                	sd	s1,136(sp)
    80004436:	e14a                	sd	s2,128(sp)
    80004438:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000443a:	8ddfc0ef          	jal	ra,80000d16 <myproc>
    8000443e:	892a                	mv	s2,a0
  
  begin_op();
    80004440:	b7dfe0ef          	jal	ra,80002fbc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004444:	08000613          	li	a2,128
    80004448:	f6040593          	addi	a1,s0,-160
    8000444c:	4501                	li	a0,0
    8000444e:	ff0fd0ef          	jal	ra,80001c3e <argstr>
    80004452:	04054163          	bltz	a0,80004494 <sys_chdir+0x66>
    80004456:	f6040513          	addi	a0,s0,-160
    8000445a:	973fe0ef          	jal	ra,80002dcc <namei>
    8000445e:	84aa                	mv	s1,a0
    80004460:	c915                	beqz	a0,80004494 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004462:	97cfe0ef          	jal	ra,800025de <ilock>
  if(ip->type != T_DIR){
    80004466:	04449703          	lh	a4,68(s1)
    8000446a:	4785                	li	a5,1
    8000446c:	02f71863          	bne	a4,a5,8000449c <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004470:	8526                	mv	a0,s1
    80004472:	a16fe0ef          	jal	ra,80002688 <iunlock>
  iput(p->cwd);
    80004476:	15093503          	ld	a0,336(s2)
    8000447a:	ae2fe0ef          	jal	ra,8000275c <iput>
  end_op();
    8000447e:	baffe0ef          	jal	ra,8000302c <end_op>
  p->cwd = ip;
    80004482:	14993823          	sd	s1,336(s2)
  return 0;
    80004486:	4501                	li	a0,0
}
    80004488:	60ea                	ld	ra,152(sp)
    8000448a:	644a                	ld	s0,144(sp)
    8000448c:	64aa                	ld	s1,136(sp)
    8000448e:	690a                	ld	s2,128(sp)
    80004490:	610d                	addi	sp,sp,160
    80004492:	8082                	ret
    end_op();
    80004494:	b99fe0ef          	jal	ra,8000302c <end_op>
    return -1;
    80004498:	557d                	li	a0,-1
    8000449a:	b7fd                	j	80004488 <sys_chdir+0x5a>
    iunlockput(ip);
    8000449c:	8526                	mv	a0,s1
    8000449e:	b46fe0ef          	jal	ra,800027e4 <iunlockput>
    end_op();
    800044a2:	b8bfe0ef          	jal	ra,8000302c <end_op>
    return -1;
    800044a6:	557d                	li	a0,-1
    800044a8:	b7c5                	j	80004488 <sys_chdir+0x5a>

00000000800044aa <sys_exec>:

uint64
sys_exec(void)
{
    800044aa:	7145                	addi	sp,sp,-464
    800044ac:	e786                	sd	ra,456(sp)
    800044ae:	e3a2                	sd	s0,448(sp)
    800044b0:	ff26                	sd	s1,440(sp)
    800044b2:	fb4a                	sd	s2,432(sp)
    800044b4:	f74e                	sd	s3,424(sp)
    800044b6:	f352                	sd	s4,416(sp)
    800044b8:	ef56                	sd	s5,408(sp)
    800044ba:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800044bc:	e3840593          	addi	a1,s0,-456
    800044c0:	4505                	li	a0,1
    800044c2:	f60fd0ef          	jal	ra,80001c22 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800044c6:	08000613          	li	a2,128
    800044ca:	f4040593          	addi	a1,s0,-192
    800044ce:	4501                	li	a0,0
    800044d0:	f6efd0ef          	jal	ra,80001c3e <argstr>
    800044d4:	87aa                	mv	a5,a0
    return -1;
    800044d6:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800044d8:	0a07c463          	bltz	a5,80004580 <sys_exec+0xd6>
  }
  memset(argv, 0, sizeof(argv));
    800044dc:	10000613          	li	a2,256
    800044e0:	4581                	li	a1,0
    800044e2:	e4040513          	addi	a0,s0,-448
    800044e6:	c4dfb0ef          	jal	ra,80000132 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800044ea:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800044ee:	89a6                	mv	s3,s1
    800044f0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800044f2:	02000a13          	li	s4,32
    800044f6:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800044fa:	00391513          	slli	a0,s2,0x3
    800044fe:	e3040593          	addi	a1,s0,-464
    80004502:	e3843783          	ld	a5,-456(s0)
    80004506:	953e                	add	a0,a0,a5
    80004508:	e74fd0ef          	jal	ra,80001b7c <fetchaddr>
    8000450c:	02054663          	bltz	a0,80004538 <sys_exec+0x8e>
      goto bad;
    }
    if(uarg == 0){
    80004510:	e3043783          	ld	a5,-464(s0)
    80004514:	cf8d                	beqz	a5,8000454e <sys_exec+0xa4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004516:	bdffb0ef          	jal	ra,800000f4 <kalloc>
    8000451a:	85aa                	mv	a1,a0
    8000451c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004520:	cd01                	beqz	a0,80004538 <sys_exec+0x8e>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004522:	6605                	lui	a2,0x1
    80004524:	e3043503          	ld	a0,-464(s0)
    80004528:	e9efd0ef          	jal	ra,80001bc6 <fetchstr>
    8000452c:	00054663          	bltz	a0,80004538 <sys_exec+0x8e>
    if(i >= NELEM(argv)){
    80004530:	0905                	addi	s2,s2,1
    80004532:	09a1                	addi	s3,s3,8
    80004534:	fd4911e3          	bne	s2,s4,800044f6 <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004538:	10048913          	addi	s2,s1,256
    8000453c:	6088                	ld	a0,0(s1)
    8000453e:	c121                	beqz	a0,8000457e <sys_exec+0xd4>
    kfree(argv[i]);
    80004540:	addfb0ef          	jal	ra,8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004544:	04a1                	addi	s1,s1,8
    80004546:	ff249be3          	bne	s1,s2,8000453c <sys_exec+0x92>
  return -1;
    8000454a:	557d                	li	a0,-1
    8000454c:	a815                	j	80004580 <sys_exec+0xd6>
      argv[i] = 0;
    8000454e:	0a8e                	slli	s5,s5,0x3
    80004550:	fc040793          	addi	a5,s0,-64
    80004554:	9abe                	add	s5,s5,a5
    80004556:	e80ab023          	sd	zero,-384(s5)
  int ret = kexec(path, argv);
    8000455a:	e4040593          	addi	a1,s0,-448
    8000455e:	f4040513          	addi	a0,s0,-192
    80004562:	c18ff0ef          	jal	ra,8000397a <kexec>
    80004566:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004568:	10048993          	addi	s3,s1,256
    8000456c:	6088                	ld	a0,0(s1)
    8000456e:	c511                	beqz	a0,8000457a <sys_exec+0xd0>
    kfree(argv[i]);
    80004570:	aadfb0ef          	jal	ra,8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004574:	04a1                	addi	s1,s1,8
    80004576:	ff349be3          	bne	s1,s3,8000456c <sys_exec+0xc2>
  return ret;
    8000457a:	854a                	mv	a0,s2
    8000457c:	a011                	j	80004580 <sys_exec+0xd6>
  return -1;
    8000457e:	557d                	li	a0,-1
}
    80004580:	60be                	ld	ra,456(sp)
    80004582:	641e                	ld	s0,448(sp)
    80004584:	74fa                	ld	s1,440(sp)
    80004586:	795a                	ld	s2,432(sp)
    80004588:	79ba                	ld	s3,424(sp)
    8000458a:	7a1a                	ld	s4,416(sp)
    8000458c:	6afa                	ld	s5,408(sp)
    8000458e:	6179                	addi	sp,sp,464
    80004590:	8082                	ret

0000000080004592 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004592:	7139                	addi	sp,sp,-64
    80004594:	fc06                	sd	ra,56(sp)
    80004596:	f822                	sd	s0,48(sp)
    80004598:	f426                	sd	s1,40(sp)
    8000459a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000459c:	f7afc0ef          	jal	ra,80000d16 <myproc>
    800045a0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800045a2:	fd840593          	addi	a1,s0,-40
    800045a6:	4501                	li	a0,0
    800045a8:	e7afd0ef          	jal	ra,80001c22 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800045ac:	fc840593          	addi	a1,s0,-56
    800045b0:	fd040513          	addi	a0,s0,-48
    800045b4:	8e2ff0ef          	jal	ra,80003696 <pipealloc>
    return -1;
    800045b8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800045ba:	0a054463          	bltz	a0,80004662 <sys_pipe+0xd0>
  fd0 = -1;
    800045be:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800045c2:	fd043503          	ld	a0,-48(s0)
    800045c6:	f40ff0ef          	jal	ra,80003d06 <fdalloc>
    800045ca:	fca42223          	sw	a0,-60(s0)
    800045ce:	08054163          	bltz	a0,80004650 <sys_pipe+0xbe>
    800045d2:	fc843503          	ld	a0,-56(s0)
    800045d6:	f30ff0ef          	jal	ra,80003d06 <fdalloc>
    800045da:	fca42023          	sw	a0,-64(s0)
    800045de:	06054063          	bltz	a0,8000463e <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800045e2:	4691                	li	a3,4
    800045e4:	fc440613          	addi	a2,s0,-60
    800045e8:	fd843583          	ld	a1,-40(s0)
    800045ec:	68a8                	ld	a0,80(s1)
    800045ee:	c70fc0ef          	jal	ra,80000a5e <copyout>
    800045f2:	00054e63          	bltz	a0,8000460e <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800045f6:	4691                	li	a3,4
    800045f8:	fc040613          	addi	a2,s0,-64
    800045fc:	fd843583          	ld	a1,-40(s0)
    80004600:	0591                	addi	a1,a1,4
    80004602:	68a8                	ld	a0,80(s1)
    80004604:	c5afc0ef          	jal	ra,80000a5e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004608:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000460a:	04055c63          	bgez	a0,80004662 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000460e:	fc442783          	lw	a5,-60(s0)
    80004612:	07e9                	addi	a5,a5,26
    80004614:	078e                	slli	a5,a5,0x3
    80004616:	97a6                	add	a5,a5,s1
    80004618:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000461c:	fc042503          	lw	a0,-64(s0)
    80004620:	0569                	addi	a0,a0,26
    80004622:	050e                	slli	a0,a0,0x3
    80004624:	94aa                	add	s1,s1,a0
    80004626:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000462a:	fd043503          	ld	a0,-48(s0)
    8000462e:	d9dfe0ef          	jal	ra,800033ca <fileclose>
    fileclose(wf);
    80004632:	fc843503          	ld	a0,-56(s0)
    80004636:	d95fe0ef          	jal	ra,800033ca <fileclose>
    return -1;
    8000463a:	57fd                	li	a5,-1
    8000463c:	a01d                	j	80004662 <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000463e:	fc442783          	lw	a5,-60(s0)
    80004642:	0007c763          	bltz	a5,80004650 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004646:	07e9                	addi	a5,a5,26
    80004648:	078e                	slli	a5,a5,0x3
    8000464a:	94be                	add	s1,s1,a5
    8000464c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004650:	fd043503          	ld	a0,-48(s0)
    80004654:	d77fe0ef          	jal	ra,800033ca <fileclose>
    fileclose(wf);
    80004658:	fc843503          	ld	a0,-56(s0)
    8000465c:	d6ffe0ef          	jal	ra,800033ca <fileclose>
    return -1;
    80004660:	57fd                	li	a5,-1
}
    80004662:	853e                	mv	a0,a5
    80004664:	70e2                	ld	ra,56(sp)
    80004666:	7442                	ld	s0,48(sp)
    80004668:	74a2                	ld	s1,40(sp)
    8000466a:	6121                	addi	sp,sp,64
    8000466c:	8082                	ret
	...

0000000080004670 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004670:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004672:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004674:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004676:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004678:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000467a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000467c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000467e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004680:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004682:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004684:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004686:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004688:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000468a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000468c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000468e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004690:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004692:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004694:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004696:	bf6fd0ef          	jal	ra,80001a8c <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000469a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000469c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000469e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    800046a0:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    800046a2:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    800046a4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    800046a6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    800046a8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    800046aa:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    800046ac:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    800046ae:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    800046b0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    800046b2:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    800046b4:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    800046b6:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    800046b8:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    800046ba:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    800046bc:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    800046be:	10200073          	sret
	...

00000000800046ce <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800046ce:	1141                	addi	sp,sp,-16
    800046d0:	e422                	sd	s0,8(sp)
    800046d2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800046d4:	0c0007b7          	lui	a5,0xc000
    800046d8:	4705                	li	a4,1
    800046da:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800046dc:	c3d8                	sw	a4,4(a5)
}
    800046de:	6422                	ld	s0,8(sp)
    800046e0:	0141                	addi	sp,sp,16
    800046e2:	8082                	ret

00000000800046e4 <plicinithart>:

void
plicinithart(void)
{
    800046e4:	1141                	addi	sp,sp,-16
    800046e6:	e406                	sd	ra,8(sp)
    800046e8:	e022                	sd	s0,0(sp)
    800046ea:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800046ec:	dfefc0ef          	jal	ra,80000cea <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800046f0:	0085171b          	slliw	a4,a0,0x8
    800046f4:	0c0027b7          	lui	a5,0xc002
    800046f8:	97ba                	add	a5,a5,a4
    800046fa:	40200713          	li	a4,1026
    800046fe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004702:	00d5151b          	slliw	a0,a0,0xd
    80004706:	0c2017b7          	lui	a5,0xc201
    8000470a:	953e                	add	a0,a0,a5
    8000470c:	00052023          	sw	zero,0(a0)
}
    80004710:	60a2                	ld	ra,8(sp)
    80004712:	6402                	ld	s0,0(sp)
    80004714:	0141                	addi	sp,sp,16
    80004716:	8082                	ret

0000000080004718 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004718:	1141                	addi	sp,sp,-16
    8000471a:	e406                	sd	ra,8(sp)
    8000471c:	e022                	sd	s0,0(sp)
    8000471e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004720:	dcafc0ef          	jal	ra,80000cea <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004724:	00d5179b          	slliw	a5,a0,0xd
    80004728:	0c201537          	lui	a0,0xc201
    8000472c:	953e                	add	a0,a0,a5
  return irq;
}
    8000472e:	4148                	lw	a0,4(a0)
    80004730:	60a2                	ld	ra,8(sp)
    80004732:	6402                	ld	s0,0(sp)
    80004734:	0141                	addi	sp,sp,16
    80004736:	8082                	ret

0000000080004738 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004738:	1101                	addi	sp,sp,-32
    8000473a:	ec06                	sd	ra,24(sp)
    8000473c:	e822                	sd	s0,16(sp)
    8000473e:	e426                	sd	s1,8(sp)
    80004740:	1000                	addi	s0,sp,32
    80004742:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004744:	da6fc0ef          	jal	ra,80000cea <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004748:	00d5151b          	slliw	a0,a0,0xd
    8000474c:	0c2017b7          	lui	a5,0xc201
    80004750:	97aa                	add	a5,a5,a0
    80004752:	c3c4                	sw	s1,4(a5)
}
    80004754:	60e2                	ld	ra,24(sp)
    80004756:	6442                	ld	s0,16(sp)
    80004758:	64a2                	ld	s1,8(sp)
    8000475a:	6105                	addi	sp,sp,32
    8000475c:	8082                	ret

000000008000475e <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000475e:	1141                	addi	sp,sp,-16
    80004760:	e406                	sd	ra,8(sp)
    80004762:	e022                	sd	s0,0(sp)
    80004764:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004766:	479d                	li	a5,7
    80004768:	04a7ca63          	blt	a5,a0,800047bc <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    8000476c:	00014797          	auipc	a5,0x14
    80004770:	22478793          	addi	a5,a5,548 # 80018990 <disk>
    80004774:	97aa                	add	a5,a5,a0
    80004776:	0187c783          	lbu	a5,24(a5)
    8000477a:	e7b9                	bnez	a5,800047c8 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000477c:	00451613          	slli	a2,a0,0x4
    80004780:	00014797          	auipc	a5,0x14
    80004784:	21078793          	addi	a5,a5,528 # 80018990 <disk>
    80004788:	6394                	ld	a3,0(a5)
    8000478a:	96b2                	add	a3,a3,a2
    8000478c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80004790:	6398                	ld	a4,0(a5)
    80004792:	9732                	add	a4,a4,a2
    80004794:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004798:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000479c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800047a0:	953e                	add	a0,a0,a5
    800047a2:	4785                	li	a5,1
    800047a4:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800047a8:	00014517          	auipc	a0,0x14
    800047ac:	20050513          	addi	a0,a0,512 # 800189a8 <disk+0x18>
    800047b0:	ba5fc0ef          	jal	ra,80001354 <wakeup>
}
    800047b4:	60a2                	ld	ra,8(sp)
    800047b6:	6402                	ld	s0,0(sp)
    800047b8:	0141                	addi	sp,sp,16
    800047ba:	8082                	ret
    panic("free_desc 1");
    800047bc:	00003517          	auipc	a0,0x3
    800047c0:	f0450513          	addi	a0,a0,-252 # 800076c0 <syscalls+0x330>
    800047c4:	453000ef          	jal	ra,80005416 <panic>
    panic("free_desc 2");
    800047c8:	00003517          	auipc	a0,0x3
    800047cc:	f0850513          	addi	a0,a0,-248 # 800076d0 <syscalls+0x340>
    800047d0:	447000ef          	jal	ra,80005416 <panic>

00000000800047d4 <virtio_disk_init>:
{
    800047d4:	1101                	addi	sp,sp,-32
    800047d6:	ec06                	sd	ra,24(sp)
    800047d8:	e822                	sd	s0,16(sp)
    800047da:	e426                	sd	s1,8(sp)
    800047dc:	e04a                	sd	s2,0(sp)
    800047de:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800047e0:	00003597          	auipc	a1,0x3
    800047e4:	f0058593          	addi	a1,a1,-256 # 800076e0 <syscalls+0x350>
    800047e8:	00014517          	auipc	a0,0x14
    800047ec:	2d050513          	addi	a0,a0,720 # 80018ab8 <disk+0x128>
    800047f0:	661000ef          	jal	ra,80005650 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800047f4:	100017b7          	lui	a5,0x10001
    800047f8:	4398                	lw	a4,0(a5)
    800047fa:	2701                	sext.w	a4,a4
    800047fc:	747277b7          	lui	a5,0x74727
    80004800:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004804:	14f71263          	bne	a4,a5,80004948 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004808:	100017b7          	lui	a5,0x10001
    8000480c:	43dc                	lw	a5,4(a5)
    8000480e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004810:	4709                	li	a4,2
    80004812:	12e79b63          	bne	a5,a4,80004948 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004816:	100017b7          	lui	a5,0x10001
    8000481a:	479c                	lw	a5,8(a5)
    8000481c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000481e:	12e79563          	bne	a5,a4,80004948 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004822:	100017b7          	lui	a5,0x10001
    80004826:	47d8                	lw	a4,12(a5)
    80004828:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000482a:	554d47b7          	lui	a5,0x554d4
    8000482e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004832:	10f71b63          	bne	a4,a5,80004948 <virtio_disk_init+0x174>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004836:	100017b7          	lui	a5,0x10001
    8000483a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000483e:	4705                	li	a4,1
    80004840:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004842:	470d                	li	a4,3
    80004844:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004846:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004848:	c7ffe737          	lui	a4,0xc7ffe
    8000484c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fddbb7>
    80004850:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004852:	2701                	sext.w	a4,a4
    80004854:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004856:	472d                	li	a4,11
    80004858:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    8000485a:	0707a903          	lw	s2,112(a5)
    8000485e:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004860:	00897793          	andi	a5,s2,8
    80004864:	0e078863          	beqz	a5,80004954 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004868:	100017b7          	lui	a5,0x10001
    8000486c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004870:	43fc                	lw	a5,68(a5)
    80004872:	2781                	sext.w	a5,a5
    80004874:	0e079663          	bnez	a5,80004960 <virtio_disk_init+0x18c>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004878:	100017b7          	lui	a5,0x10001
    8000487c:	5bdc                	lw	a5,52(a5)
    8000487e:	2781                	sext.w	a5,a5
  if(max == 0)
    80004880:	0e078663          	beqz	a5,8000496c <virtio_disk_init+0x198>
  if(max < NUM)
    80004884:	471d                	li	a4,7
    80004886:	0ef77963          	bgeu	a4,a5,80004978 <virtio_disk_init+0x1a4>
  disk.desc = kalloc();
    8000488a:	86bfb0ef          	jal	ra,800000f4 <kalloc>
    8000488e:	00014497          	auipc	s1,0x14
    80004892:	10248493          	addi	s1,s1,258 # 80018990 <disk>
    80004896:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004898:	85dfb0ef          	jal	ra,800000f4 <kalloc>
    8000489c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000489e:	857fb0ef          	jal	ra,800000f4 <kalloc>
    800048a2:	87aa                	mv	a5,a0
    800048a4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800048a6:	6088                	ld	a0,0(s1)
    800048a8:	cd71                	beqz	a0,80004984 <virtio_disk_init+0x1b0>
    800048aa:	00014717          	auipc	a4,0x14
    800048ae:	0ee73703          	ld	a4,238(a4) # 80018998 <disk+0x8>
    800048b2:	cb69                	beqz	a4,80004984 <virtio_disk_init+0x1b0>
    800048b4:	cbe1                	beqz	a5,80004984 <virtio_disk_init+0x1b0>
  memset(disk.desc, 0, PGSIZE);
    800048b6:	6605                	lui	a2,0x1
    800048b8:	4581                	li	a1,0
    800048ba:	879fb0ef          	jal	ra,80000132 <memset>
  memset(disk.avail, 0, PGSIZE);
    800048be:	00014497          	auipc	s1,0x14
    800048c2:	0d248493          	addi	s1,s1,210 # 80018990 <disk>
    800048c6:	6605                	lui	a2,0x1
    800048c8:	4581                	li	a1,0
    800048ca:	6488                	ld	a0,8(s1)
    800048cc:	867fb0ef          	jal	ra,80000132 <memset>
  memset(disk.used, 0, PGSIZE);
    800048d0:	6605                	lui	a2,0x1
    800048d2:	4581                	li	a1,0
    800048d4:	6888                	ld	a0,16(s1)
    800048d6:	85dfb0ef          	jal	ra,80000132 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800048da:	100017b7          	lui	a5,0x10001
    800048de:	4721                	li	a4,8
    800048e0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800048e2:	4098                	lw	a4,0(s1)
    800048e4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800048e8:	40d8                	lw	a4,4(s1)
    800048ea:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800048ee:	6498                	ld	a4,8(s1)
    800048f0:	0007069b          	sext.w	a3,a4
    800048f4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800048f8:	9701                	srai	a4,a4,0x20
    800048fa:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800048fe:	6898                	ld	a4,16(s1)
    80004900:	0007069b          	sext.w	a3,a4
    80004904:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004908:	9701                	srai	a4,a4,0x20
    8000490a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000490e:	4685                	li	a3,1
    80004910:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80004912:	4705                	li	a4,1
    80004914:	00d48c23          	sb	a3,24(s1)
    80004918:	00e48ca3          	sb	a4,25(s1)
    8000491c:	00e48d23          	sb	a4,26(s1)
    80004920:	00e48da3          	sb	a4,27(s1)
    80004924:	00e48e23          	sb	a4,28(s1)
    80004928:	00e48ea3          	sb	a4,29(s1)
    8000492c:	00e48f23          	sb	a4,30(s1)
    80004930:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004934:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004938:	0727a823          	sw	s2,112(a5)
}
    8000493c:	60e2                	ld	ra,24(sp)
    8000493e:	6442                	ld	s0,16(sp)
    80004940:	64a2                	ld	s1,8(sp)
    80004942:	6902                	ld	s2,0(sp)
    80004944:	6105                	addi	sp,sp,32
    80004946:	8082                	ret
    panic("could not find virtio disk");
    80004948:	00003517          	auipc	a0,0x3
    8000494c:	da850513          	addi	a0,a0,-600 # 800076f0 <syscalls+0x360>
    80004950:	2c7000ef          	jal	ra,80005416 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004954:	00003517          	auipc	a0,0x3
    80004958:	dbc50513          	addi	a0,a0,-580 # 80007710 <syscalls+0x380>
    8000495c:	2bb000ef          	jal	ra,80005416 <panic>
    panic("virtio disk should not be ready");
    80004960:	00003517          	auipc	a0,0x3
    80004964:	dd050513          	addi	a0,a0,-560 # 80007730 <syscalls+0x3a0>
    80004968:	2af000ef          	jal	ra,80005416 <panic>
    panic("virtio disk has no queue 0");
    8000496c:	00003517          	auipc	a0,0x3
    80004970:	de450513          	addi	a0,a0,-540 # 80007750 <syscalls+0x3c0>
    80004974:	2a3000ef          	jal	ra,80005416 <panic>
    panic("virtio disk max queue too short");
    80004978:	00003517          	auipc	a0,0x3
    8000497c:	df850513          	addi	a0,a0,-520 # 80007770 <syscalls+0x3e0>
    80004980:	297000ef          	jal	ra,80005416 <panic>
    panic("virtio disk kalloc");
    80004984:	00003517          	auipc	a0,0x3
    80004988:	e0c50513          	addi	a0,a0,-500 # 80007790 <syscalls+0x400>
    8000498c:	28b000ef          	jal	ra,80005416 <panic>

0000000080004990 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004990:	7159                	addi	sp,sp,-112
    80004992:	f486                	sd	ra,104(sp)
    80004994:	f0a2                	sd	s0,96(sp)
    80004996:	eca6                	sd	s1,88(sp)
    80004998:	e8ca                	sd	s2,80(sp)
    8000499a:	e4ce                	sd	s3,72(sp)
    8000499c:	e0d2                	sd	s4,64(sp)
    8000499e:	fc56                	sd	s5,56(sp)
    800049a0:	f85a                	sd	s6,48(sp)
    800049a2:	f45e                	sd	s7,40(sp)
    800049a4:	f062                	sd	s8,32(sp)
    800049a6:	ec66                	sd	s9,24(sp)
    800049a8:	e86a                	sd	s10,16(sp)
    800049aa:	1880                	addi	s0,sp,112
    800049ac:	892a                	mv	s2,a0
    800049ae:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800049b0:	00c52c83          	lw	s9,12(a0)
    800049b4:	001c9c9b          	slliw	s9,s9,0x1
    800049b8:	1c82                	slli	s9,s9,0x20
    800049ba:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800049be:	00014517          	auipc	a0,0x14
    800049c2:	0fa50513          	addi	a0,a0,250 # 80018ab8 <disk+0x128>
    800049c6:	50b000ef          	jal	ra,800056d0 <acquire>
  for(int i = 0; i < 3; i++){
    800049ca:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800049cc:	4ba1                	li	s7,8
      disk.free[i] = 0;
    800049ce:	00014b17          	auipc	s6,0x14
    800049d2:	fc2b0b13          	addi	s6,s6,-62 # 80018990 <disk>
  for(int i = 0; i < 3; i++){
    800049d6:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800049d8:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800049da:	00014c17          	auipc	s8,0x14
    800049de:	0dec0c13          	addi	s8,s8,222 # 80018ab8 <disk+0x128>
    800049e2:	a0b5                	j	80004a4e <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    800049e4:	00fb06b3          	add	a3,s6,a5
    800049e8:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800049ec:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800049ee:	0207c563          	bltz	a5,80004a18 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800049f2:	2485                	addiw	s1,s1,1
    800049f4:	0711                	addi	a4,a4,4
    800049f6:	1d548c63          	beq	s1,s5,80004bce <virtio_disk_rw+0x23e>
    idx[i] = alloc_desc();
    800049fa:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800049fc:	00014697          	auipc	a3,0x14
    80004a00:	f9468693          	addi	a3,a3,-108 # 80018990 <disk>
    80004a04:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80004a06:	0186c583          	lbu	a1,24(a3)
    80004a0a:	fde9                	bnez	a1,800049e4 <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80004a0c:	2785                	addiw	a5,a5,1
    80004a0e:	0685                	addi	a3,a3,1
    80004a10:	ff779be3          	bne	a5,s7,80004a06 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80004a14:	57fd                	li	a5,-1
    80004a16:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80004a18:	02905463          	blez	s1,80004a40 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    80004a1c:	f9042503          	lw	a0,-112(s0)
    80004a20:	d3fff0ef          	jal	ra,8000475e <free_desc>
      for(int j = 0; j < i; j++)
    80004a24:	4785                	li	a5,1
    80004a26:	0097dd63          	bge	a5,s1,80004a40 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    80004a2a:	f9442503          	lw	a0,-108(s0)
    80004a2e:	d31ff0ef          	jal	ra,8000475e <free_desc>
      for(int j = 0; j < i; j++)
    80004a32:	4789                	li	a5,2
    80004a34:	0097d663          	bge	a5,s1,80004a40 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    80004a38:	f9842503          	lw	a0,-104(s0)
    80004a3c:	d23ff0ef          	jal	ra,8000475e <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004a40:	85e2                	mv	a1,s8
    80004a42:	00014517          	auipc	a0,0x14
    80004a46:	f6650513          	addi	a0,a0,-154 # 800189a8 <disk+0x18>
    80004a4a:	8bffc0ef          	jal	ra,80001308 <sleep>
  for(int i = 0; i < 3; i++){
    80004a4e:	f9040713          	addi	a4,s0,-112
    80004a52:	84ce                	mv	s1,s3
    80004a54:	b75d                	j	800049fa <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80004a56:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80004a5a:	00479693          	slli	a3,a5,0x4
    80004a5e:	00014797          	auipc	a5,0x14
    80004a62:	f3278793          	addi	a5,a5,-206 # 80018990 <disk>
    80004a66:	97b6                	add	a5,a5,a3
    80004a68:	4685                	li	a3,1
    80004a6a:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004a6c:	00014597          	auipc	a1,0x14
    80004a70:	f2458593          	addi	a1,a1,-220 # 80018990 <disk>
    80004a74:	00a60793          	addi	a5,a2,10
    80004a78:	0792                	slli	a5,a5,0x4
    80004a7a:	97ae                	add	a5,a5,a1
    80004a7c:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    80004a80:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004a84:	f6070693          	addi	a3,a4,-160
    80004a88:	619c                	ld	a5,0(a1)
    80004a8a:	97b6                	add	a5,a5,a3
    80004a8c:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004a8e:	6188                	ld	a0,0(a1)
    80004a90:	96aa                	add	a3,a3,a0
    80004a92:	47c1                	li	a5,16
    80004a94:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004a96:	4785                	li	a5,1
    80004a98:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80004a9c:	f9442783          	lw	a5,-108(s0)
    80004aa0:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004aa4:	0792                	slli	a5,a5,0x4
    80004aa6:	953e                	add	a0,a0,a5
    80004aa8:	05890693          	addi	a3,s2,88
    80004aac:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    80004aae:	6188                	ld	a0,0(a1)
    80004ab0:	97aa                	add	a5,a5,a0
    80004ab2:	40000693          	li	a3,1024
    80004ab6:	c794                	sw	a3,8(a5)
  if(write)
    80004ab8:	100d0763          	beqz	s10,80004bc6 <virtio_disk_rw+0x236>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80004abc:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004ac0:	00c7d683          	lhu	a3,12(a5)
    80004ac4:	0016e693          	ori	a3,a3,1
    80004ac8:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80004acc:	f9842583          	lw	a1,-104(s0)
    80004ad0:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004ad4:	00014697          	auipc	a3,0x14
    80004ad8:	ebc68693          	addi	a3,a3,-324 # 80018990 <disk>
    80004adc:	00260793          	addi	a5,a2,2
    80004ae0:	0792                	slli	a5,a5,0x4
    80004ae2:	97b6                	add	a5,a5,a3
    80004ae4:	587d                	li	a6,-1
    80004ae6:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004aea:	0592                	slli	a1,a1,0x4
    80004aec:	952e                	add	a0,a0,a1
    80004aee:	f9070713          	addi	a4,a4,-112
    80004af2:	9736                	add	a4,a4,a3
    80004af4:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80004af6:	6298                	ld	a4,0(a3)
    80004af8:	972e                	add	a4,a4,a1
    80004afa:	4585                	li	a1,1
    80004afc:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004afe:	4509                	li	a0,2
    80004b00:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80004b04:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004b08:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80004b0c:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004b10:	6698                	ld	a4,8(a3)
    80004b12:	00275783          	lhu	a5,2(a4)
    80004b16:	8b9d                	andi	a5,a5,7
    80004b18:	0786                	slli	a5,a5,0x1
    80004b1a:	97ba                	add	a5,a5,a4
    80004b1c:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    80004b20:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004b24:	6698                	ld	a4,8(a3)
    80004b26:	00275783          	lhu	a5,2(a4)
    80004b2a:	2785                	addiw	a5,a5,1
    80004b2c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004b30:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004b34:	100017b7          	lui	a5,0x10001
    80004b38:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004b3c:	00492703          	lw	a4,4(s2)
    80004b40:	4785                	li	a5,1
    80004b42:	00f71f63          	bne	a4,a5,80004b60 <virtio_disk_rw+0x1d0>
    sleep(b, &disk.vdisk_lock);
    80004b46:	00014997          	auipc	s3,0x14
    80004b4a:	f7298993          	addi	s3,s3,-142 # 80018ab8 <disk+0x128>
  while(b->disk == 1) {
    80004b4e:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80004b50:	85ce                	mv	a1,s3
    80004b52:	854a                	mv	a0,s2
    80004b54:	fb4fc0ef          	jal	ra,80001308 <sleep>
  while(b->disk == 1) {
    80004b58:	00492783          	lw	a5,4(s2)
    80004b5c:	fe978ae3          	beq	a5,s1,80004b50 <virtio_disk_rw+0x1c0>
  }

  disk.info[idx[0]].b = 0;
    80004b60:	f9042903          	lw	s2,-112(s0)
    80004b64:	00290793          	addi	a5,s2,2
    80004b68:	00479713          	slli	a4,a5,0x4
    80004b6c:	00014797          	auipc	a5,0x14
    80004b70:	e2478793          	addi	a5,a5,-476 # 80018990 <disk>
    80004b74:	97ba                	add	a5,a5,a4
    80004b76:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004b7a:	00014997          	auipc	s3,0x14
    80004b7e:	e1698993          	addi	s3,s3,-490 # 80018990 <disk>
    80004b82:	00491713          	slli	a4,s2,0x4
    80004b86:	0009b783          	ld	a5,0(s3)
    80004b8a:	97ba                	add	a5,a5,a4
    80004b8c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004b90:	854a                	mv	a0,s2
    80004b92:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004b96:	bc9ff0ef          	jal	ra,8000475e <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004b9a:	8885                	andi	s1,s1,1
    80004b9c:	f0fd                	bnez	s1,80004b82 <virtio_disk_rw+0x1f2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004b9e:	00014517          	auipc	a0,0x14
    80004ba2:	f1a50513          	addi	a0,a0,-230 # 80018ab8 <disk+0x128>
    80004ba6:	3c3000ef          	jal	ra,80005768 <release>
}
    80004baa:	70a6                	ld	ra,104(sp)
    80004bac:	7406                	ld	s0,96(sp)
    80004bae:	64e6                	ld	s1,88(sp)
    80004bb0:	6946                	ld	s2,80(sp)
    80004bb2:	69a6                	ld	s3,72(sp)
    80004bb4:	6a06                	ld	s4,64(sp)
    80004bb6:	7ae2                	ld	s5,56(sp)
    80004bb8:	7b42                	ld	s6,48(sp)
    80004bba:	7ba2                	ld	s7,40(sp)
    80004bbc:	7c02                	ld	s8,32(sp)
    80004bbe:	6ce2                	ld	s9,24(sp)
    80004bc0:	6d42                	ld	s10,16(sp)
    80004bc2:	6165                	addi	sp,sp,112
    80004bc4:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80004bc6:	4689                	li	a3,2
    80004bc8:	00d79623          	sh	a3,12(a5)
    80004bcc:	bdd5                	j	80004ac0 <virtio_disk_rw+0x130>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004bce:	f9042603          	lw	a2,-112(s0)
    80004bd2:	00a60713          	addi	a4,a2,10
    80004bd6:	0712                	slli	a4,a4,0x4
    80004bd8:	00014517          	auipc	a0,0x14
    80004bdc:	dc050513          	addi	a0,a0,-576 # 80018998 <disk+0x8>
    80004be0:	953a                	add	a0,a0,a4
  if(write)
    80004be2:	e60d1ae3          	bnez	s10,80004a56 <virtio_disk_rw+0xc6>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80004be6:	00a60793          	addi	a5,a2,10
    80004bea:	00479693          	slli	a3,a5,0x4
    80004bee:	00014797          	auipc	a5,0x14
    80004bf2:	da278793          	addi	a5,a5,-606 # 80018990 <disk>
    80004bf6:	97b6                	add	a5,a5,a3
    80004bf8:	0007a423          	sw	zero,8(a5)
    80004bfc:	bd85                	j	80004a6c <virtio_disk_rw+0xdc>

0000000080004bfe <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004bfe:	1101                	addi	sp,sp,-32
    80004c00:	ec06                	sd	ra,24(sp)
    80004c02:	e822                	sd	s0,16(sp)
    80004c04:	e426                	sd	s1,8(sp)
    80004c06:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004c08:	00014497          	auipc	s1,0x14
    80004c0c:	d8848493          	addi	s1,s1,-632 # 80018990 <disk>
    80004c10:	00014517          	auipc	a0,0x14
    80004c14:	ea850513          	addi	a0,a0,-344 # 80018ab8 <disk+0x128>
    80004c18:	2b9000ef          	jal	ra,800056d0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004c1c:	10001737          	lui	a4,0x10001
    80004c20:	533c                	lw	a5,96(a4)
    80004c22:	8b8d                	andi	a5,a5,3
    80004c24:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004c26:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004c2a:	689c                	ld	a5,16(s1)
    80004c2c:	0204d703          	lhu	a4,32(s1)
    80004c30:	0027d783          	lhu	a5,2(a5)
    80004c34:	04f70663          	beq	a4,a5,80004c80 <virtio_disk_intr+0x82>
    __sync_synchronize();
    80004c38:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004c3c:	6898                	ld	a4,16(s1)
    80004c3e:	0204d783          	lhu	a5,32(s1)
    80004c42:	8b9d                	andi	a5,a5,7
    80004c44:	078e                	slli	a5,a5,0x3
    80004c46:	97ba                	add	a5,a5,a4
    80004c48:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004c4a:	00278713          	addi	a4,a5,2
    80004c4e:	0712                	slli	a4,a4,0x4
    80004c50:	9726                	add	a4,a4,s1
    80004c52:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004c56:	e321                	bnez	a4,80004c96 <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004c58:	0789                	addi	a5,a5,2
    80004c5a:	0792                	slli	a5,a5,0x4
    80004c5c:	97a6                	add	a5,a5,s1
    80004c5e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004c60:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004c64:	ef0fc0ef          	jal	ra,80001354 <wakeup>

    disk.used_idx += 1;
    80004c68:	0204d783          	lhu	a5,32(s1)
    80004c6c:	2785                	addiw	a5,a5,1
    80004c6e:	17c2                	slli	a5,a5,0x30
    80004c70:	93c1                	srli	a5,a5,0x30
    80004c72:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004c76:	6898                	ld	a4,16(s1)
    80004c78:	00275703          	lhu	a4,2(a4)
    80004c7c:	faf71ee3          	bne	a4,a5,80004c38 <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    80004c80:	00014517          	auipc	a0,0x14
    80004c84:	e3850513          	addi	a0,a0,-456 # 80018ab8 <disk+0x128>
    80004c88:	2e1000ef          	jal	ra,80005768 <release>
}
    80004c8c:	60e2                	ld	ra,24(sp)
    80004c8e:	6442                	ld	s0,16(sp)
    80004c90:	64a2                	ld	s1,8(sp)
    80004c92:	6105                	addi	sp,sp,32
    80004c94:	8082                	ret
      panic("virtio_disk_intr status");
    80004c96:	00003517          	auipc	a0,0x3
    80004c9a:	b1250513          	addi	a0,a0,-1262 # 800077a8 <syscalls+0x418>
    80004c9e:	778000ef          	jal	ra,80005416 <panic>

0000000080004ca2 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004ca2:	1141                	addi	sp,sp,-16
    80004ca4:	e422                	sd	s0,8(sp)
    80004ca6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004ca8:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004cac:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004cb0:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004cb4:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004cb8:	577d                	li	a4,-1
    80004cba:	177e                	slli	a4,a4,0x3f
    80004cbc:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004cbe:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004cc2:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004cc6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004cca:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004cce:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004cd2:	000f4737          	lui	a4,0xf4
    80004cd6:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004cda:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004cdc:	14d79073          	csrw	0x14d,a5
}
    80004ce0:	6422                	ld	s0,8(sp)
    80004ce2:	0141                	addi	sp,sp,16
    80004ce4:	8082                	ret

0000000080004ce6 <start>:
{
    80004ce6:	1141                	addi	sp,sp,-16
    80004ce8:	e406                	sd	ra,8(sp)
    80004cea:	e022                	sd	s0,0(sp)
    80004cec:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004cee:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004cf2:	7779                	lui	a4,0xffffe
    80004cf4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddc57>
    80004cf8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004cfa:	6705                	lui	a4,0x1
    80004cfc:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004d00:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004d02:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004d06:	ffffb797          	auipc	a5,0xffffb
    80004d0a:	5d678793          	addi	a5,a5,1494 # 800002dc <main>
    80004d0e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004d12:	4781                	li	a5,0
    80004d14:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004d18:	67c1                	lui	a5,0x10
    80004d1a:	17fd                	addi	a5,a5,-1
    80004d1c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004d20:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004d24:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80004d28:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80004d2c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004d30:	57fd                	li	a5,-1
    80004d32:	83a9                	srli	a5,a5,0xa
    80004d34:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004d38:	47bd                	li	a5,15
    80004d3a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004d3e:	f65ff0ef          	jal	ra,80004ca2 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004d42:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004d46:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004d48:	823e                	mv	tp,a5
  asm volatile("mret");
    80004d4a:	30200073          	mret
}
    80004d4e:	60a2                	ld	ra,8(sp)
    80004d50:	6402                	ld	s0,0(sp)
    80004d52:	0141                	addi	sp,sp,16
    80004d54:	8082                	ret

0000000080004d56 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004d56:	7159                	addi	sp,sp,-112
    80004d58:	f486                	sd	ra,104(sp)
    80004d5a:	f0a2                	sd	s0,96(sp)
    80004d5c:	eca6                	sd	s1,88(sp)
    80004d5e:	e8ca                	sd	s2,80(sp)
    80004d60:	e4ce                	sd	s3,72(sp)
    80004d62:	e0d2                	sd	s4,64(sp)
    80004d64:	fc56                	sd	s5,56(sp)
    80004d66:	f85a                	sd	s6,48(sp)
    80004d68:	f45e                	sd	s7,40(sp)
    80004d6a:	f062                	sd	s8,32(sp)
    80004d6c:	1880                	addi	s0,sp,112
  char buf[32];
  int i = 0;

  while(i < n){
    80004d6e:	04c05463          	blez	a2,80004db6 <consolewrite+0x60>
    80004d72:	8a2a                	mv	s4,a0
    80004d74:	8aae                	mv	s5,a1
    80004d76:	89b2                	mv	s3,a2
  int i = 0;
    80004d78:	4901                	li	s2,0
    int nn = sizeof(buf);
    if(nn > n - i)
    80004d7a:	4bfd                	li	s7,31
    int nn = sizeof(buf);
    80004d7c:	02000c13          	li	s8,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80004d80:	5b7d                	li	s6,-1
    80004d82:	a025                	j	80004daa <consolewrite+0x54>
    80004d84:	86a6                	mv	a3,s1
    80004d86:	01590633          	add	a2,s2,s5
    80004d8a:	85d2                	mv	a1,s4
    80004d8c:	f9040513          	addi	a0,s0,-112
    80004d90:	91ffc0ef          	jal	ra,800016ae <either_copyin>
    80004d94:	03650263          	beq	a0,s6,80004db8 <consolewrite+0x62>
      break;
    uartwrite(buf, nn);
    80004d98:	85a6                	mv	a1,s1
    80004d9a:	f9040513          	addi	a0,s0,-112
    80004d9e:	724000ef          	jal	ra,800054c2 <uartwrite>
    i += nn;
    80004da2:	0124893b          	addw	s2,s1,s2
  while(i < n){
    80004da6:	01395963          	bge	s2,s3,80004db8 <consolewrite+0x62>
    if(nn > n - i)
    80004daa:	412984bb          	subw	s1,s3,s2
    80004dae:	fc9bdbe3          	bge	s7,s1,80004d84 <consolewrite+0x2e>
    int nn = sizeof(buf);
    80004db2:	84e2                	mv	s1,s8
    80004db4:	bfc1                	j	80004d84 <consolewrite+0x2e>
  int i = 0;
    80004db6:	4901                	li	s2,0
  }

  return i;
}
    80004db8:	854a                	mv	a0,s2
    80004dba:	70a6                	ld	ra,104(sp)
    80004dbc:	7406                	ld	s0,96(sp)
    80004dbe:	64e6                	ld	s1,88(sp)
    80004dc0:	6946                	ld	s2,80(sp)
    80004dc2:	69a6                	ld	s3,72(sp)
    80004dc4:	6a06                	ld	s4,64(sp)
    80004dc6:	7ae2                	ld	s5,56(sp)
    80004dc8:	7b42                	ld	s6,48(sp)
    80004dca:	7ba2                	ld	s7,40(sp)
    80004dcc:	7c02                	ld	s8,32(sp)
    80004dce:	6165                	addi	sp,sp,112
    80004dd0:	8082                	ret

0000000080004dd2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004dd2:	7119                	addi	sp,sp,-128
    80004dd4:	fc86                	sd	ra,120(sp)
    80004dd6:	f8a2                	sd	s0,112(sp)
    80004dd8:	f4a6                	sd	s1,104(sp)
    80004dda:	f0ca                	sd	s2,96(sp)
    80004ddc:	ecce                	sd	s3,88(sp)
    80004dde:	e8d2                	sd	s4,80(sp)
    80004de0:	e4d6                	sd	s5,72(sp)
    80004de2:	e0da                	sd	s6,64(sp)
    80004de4:	fc5e                	sd	s7,56(sp)
    80004de6:	f862                	sd	s8,48(sp)
    80004de8:	f466                	sd	s9,40(sp)
    80004dea:	f06a                	sd	s10,32(sp)
    80004dec:	ec6e                	sd	s11,24(sp)
    80004dee:	0100                	addi	s0,sp,128
    80004df0:	8b2a                	mv	s6,a0
    80004df2:	8aae                	mv	s5,a1
    80004df4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004df6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80004dfa:	0001c517          	auipc	a0,0x1c
    80004dfe:	cd650513          	addi	a0,a0,-810 # 80020ad0 <cons>
    80004e02:	0cf000ef          	jal	ra,800056d0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004e06:	0001c497          	auipc	s1,0x1c
    80004e0a:	cca48493          	addi	s1,s1,-822 # 80020ad0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004e0e:	89a6                	mv	s3,s1
    80004e10:	0001c917          	auipc	s2,0x1c
    80004e14:	d5890913          	addi	s2,s2,-680 # 80020b68 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80004e18:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004e1a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80004e1c:	4da9                	li	s11,10
  while(n > 0){
    80004e1e:	07405363          	blez	s4,80004e84 <consoleread+0xb2>
    while(cons.r == cons.w){
    80004e22:	0984a783          	lw	a5,152(s1)
    80004e26:	09c4a703          	lw	a4,156(s1)
    80004e2a:	02f71163          	bne	a4,a5,80004e4c <consoleread+0x7a>
      if(killed(myproc())){
    80004e2e:	ee9fb0ef          	jal	ra,80000d16 <myproc>
    80004e32:	f0efc0ef          	jal	ra,80001540 <killed>
    80004e36:	e125                	bnez	a0,80004e96 <consoleread+0xc4>
      sleep(&cons.r, &cons.lock);
    80004e38:	85ce                	mv	a1,s3
    80004e3a:	854a                	mv	a0,s2
    80004e3c:	cccfc0ef          	jal	ra,80001308 <sleep>
    while(cons.r == cons.w){
    80004e40:	0984a783          	lw	a5,152(s1)
    80004e44:	09c4a703          	lw	a4,156(s1)
    80004e48:	fef703e3          	beq	a4,a5,80004e2e <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004e4c:	0017871b          	addiw	a4,a5,1
    80004e50:	08e4ac23          	sw	a4,152(s1)
    80004e54:	07f7f713          	andi	a4,a5,127
    80004e58:	9726                	add	a4,a4,s1
    80004e5a:	01874703          	lbu	a4,24(a4)
    80004e5e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80004e62:	079c0063          	beq	s8,s9,80004ec2 <consoleread+0xf0>
    cbuf = c;
    80004e66:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004e6a:	4685                	li	a3,1
    80004e6c:	f8f40613          	addi	a2,s0,-113
    80004e70:	85d6                	mv	a1,s5
    80004e72:	855a                	mv	a0,s6
    80004e74:	ff0fc0ef          	jal	ra,80001664 <either_copyout>
    80004e78:	01a50663          	beq	a0,s10,80004e84 <consoleread+0xb2>
    dst++;
    80004e7c:	0a85                	addi	s5,s5,1
    --n;
    80004e7e:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80004e80:	f9bc1fe3          	bne	s8,s11,80004e1e <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80004e84:	0001c517          	auipc	a0,0x1c
    80004e88:	c4c50513          	addi	a0,a0,-948 # 80020ad0 <cons>
    80004e8c:	0dd000ef          	jal	ra,80005768 <release>

  return target - n;
    80004e90:	414b853b          	subw	a0,s7,s4
    80004e94:	a801                	j	80004ea4 <consoleread+0xd2>
        release(&cons.lock);
    80004e96:	0001c517          	auipc	a0,0x1c
    80004e9a:	c3a50513          	addi	a0,a0,-966 # 80020ad0 <cons>
    80004e9e:	0cb000ef          	jal	ra,80005768 <release>
        return -1;
    80004ea2:	557d                	li	a0,-1
}
    80004ea4:	70e6                	ld	ra,120(sp)
    80004ea6:	7446                	ld	s0,112(sp)
    80004ea8:	74a6                	ld	s1,104(sp)
    80004eaa:	7906                	ld	s2,96(sp)
    80004eac:	69e6                	ld	s3,88(sp)
    80004eae:	6a46                	ld	s4,80(sp)
    80004eb0:	6aa6                	ld	s5,72(sp)
    80004eb2:	6b06                	ld	s6,64(sp)
    80004eb4:	7be2                	ld	s7,56(sp)
    80004eb6:	7c42                	ld	s8,48(sp)
    80004eb8:	7ca2                	ld	s9,40(sp)
    80004eba:	7d02                	ld	s10,32(sp)
    80004ebc:	6de2                	ld	s11,24(sp)
    80004ebe:	6109                	addi	sp,sp,128
    80004ec0:	8082                	ret
      if(n < target){
    80004ec2:	000a071b          	sext.w	a4,s4
    80004ec6:	fb777fe3          	bgeu	a4,s7,80004e84 <consoleread+0xb2>
        cons.r--;
    80004eca:	0001c717          	auipc	a4,0x1c
    80004ece:	c8f72f23          	sw	a5,-866(a4) # 80020b68 <cons+0x98>
    80004ed2:	bf4d                	j	80004e84 <consoleread+0xb2>

0000000080004ed4 <consputc>:
{
    80004ed4:	1141                	addi	sp,sp,-16
    80004ed6:	e406                	sd	ra,8(sp)
    80004ed8:	e022                	sd	s0,0(sp)
    80004eda:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004edc:	10000793          	li	a5,256
    80004ee0:	00f50863          	beq	a0,a5,80004ef0 <consputc+0x1c>
    uartputc_sync(c);
    80004ee4:	67c000ef          	jal	ra,80005560 <uartputc_sync>
}
    80004ee8:	60a2                	ld	ra,8(sp)
    80004eea:	6402                	ld	s0,0(sp)
    80004eec:	0141                	addi	sp,sp,16
    80004eee:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004ef0:	4521                	li	a0,8
    80004ef2:	66e000ef          	jal	ra,80005560 <uartputc_sync>
    80004ef6:	02000513          	li	a0,32
    80004efa:	666000ef          	jal	ra,80005560 <uartputc_sync>
    80004efe:	4521                	li	a0,8
    80004f00:	660000ef          	jal	ra,80005560 <uartputc_sync>
    80004f04:	b7d5                	j	80004ee8 <consputc+0x14>

0000000080004f06 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004f06:	1101                	addi	sp,sp,-32
    80004f08:	ec06                	sd	ra,24(sp)
    80004f0a:	e822                	sd	s0,16(sp)
    80004f0c:	e426                	sd	s1,8(sp)
    80004f0e:	e04a                	sd	s2,0(sp)
    80004f10:	1000                	addi	s0,sp,32
    80004f12:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004f14:	0001c517          	auipc	a0,0x1c
    80004f18:	bbc50513          	addi	a0,a0,-1092 # 80020ad0 <cons>
    80004f1c:	7b4000ef          	jal	ra,800056d0 <acquire>

  switch(c){
    80004f20:	47d5                	li	a5,21
    80004f22:	0af48063          	beq	s1,a5,80004fc2 <consoleintr+0xbc>
    80004f26:	0297c663          	blt	a5,s1,80004f52 <consoleintr+0x4c>
    80004f2a:	47a1                	li	a5,8
    80004f2c:	0cf48f63          	beq	s1,a5,8000500a <consoleintr+0x104>
    80004f30:	47c1                	li	a5,16
    80004f32:	10f49063          	bne	s1,a5,80005032 <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    80004f36:	fc2fc0ef          	jal	ra,800016f8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004f3a:	0001c517          	auipc	a0,0x1c
    80004f3e:	b9650513          	addi	a0,a0,-1130 # 80020ad0 <cons>
    80004f42:	027000ef          	jal	ra,80005768 <release>
}
    80004f46:	60e2                	ld	ra,24(sp)
    80004f48:	6442                	ld	s0,16(sp)
    80004f4a:	64a2                	ld	s1,8(sp)
    80004f4c:	6902                	ld	s2,0(sp)
    80004f4e:	6105                	addi	sp,sp,32
    80004f50:	8082                	ret
  switch(c){
    80004f52:	07f00793          	li	a5,127
    80004f56:	0af48a63          	beq	s1,a5,8000500a <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004f5a:	0001c717          	auipc	a4,0x1c
    80004f5e:	b7670713          	addi	a4,a4,-1162 # 80020ad0 <cons>
    80004f62:	0a072783          	lw	a5,160(a4)
    80004f66:	09872703          	lw	a4,152(a4)
    80004f6a:	9f99                	subw	a5,a5,a4
    80004f6c:	07f00713          	li	a4,127
    80004f70:	fcf765e3          	bltu	a4,a5,80004f3a <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    80004f74:	47b5                	li	a5,13
    80004f76:	0cf48163          	beq	s1,a5,80005038 <consoleintr+0x132>
      consputc(c);
    80004f7a:	8526                	mv	a0,s1
    80004f7c:	f59ff0ef          	jal	ra,80004ed4 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004f80:	0001c797          	auipc	a5,0x1c
    80004f84:	b5078793          	addi	a5,a5,-1200 # 80020ad0 <cons>
    80004f88:	0a07a683          	lw	a3,160(a5)
    80004f8c:	0016871b          	addiw	a4,a3,1
    80004f90:	0007061b          	sext.w	a2,a4
    80004f94:	0ae7a023          	sw	a4,160(a5)
    80004f98:	07f6f693          	andi	a3,a3,127
    80004f9c:	97b6                	add	a5,a5,a3
    80004f9e:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80004fa2:	47a9                	li	a5,10
    80004fa4:	0af48f63          	beq	s1,a5,80005062 <consoleintr+0x15c>
    80004fa8:	4791                	li	a5,4
    80004faa:	0af48c63          	beq	s1,a5,80005062 <consoleintr+0x15c>
    80004fae:	0001c797          	auipc	a5,0x1c
    80004fb2:	bba7a783          	lw	a5,-1094(a5) # 80020b68 <cons+0x98>
    80004fb6:	9f1d                	subw	a4,a4,a5
    80004fb8:	08000793          	li	a5,128
    80004fbc:	f6f71fe3          	bne	a4,a5,80004f3a <consoleintr+0x34>
    80004fc0:	a04d                	j	80005062 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80004fc2:	0001c717          	auipc	a4,0x1c
    80004fc6:	b0e70713          	addi	a4,a4,-1266 # 80020ad0 <cons>
    80004fca:	0a072783          	lw	a5,160(a4)
    80004fce:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004fd2:	0001c497          	auipc	s1,0x1c
    80004fd6:	afe48493          	addi	s1,s1,-1282 # 80020ad0 <cons>
    while(cons.e != cons.w &&
    80004fda:	4929                	li	s2,10
    80004fdc:	f4f70fe3          	beq	a4,a5,80004f3a <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004fe0:	37fd                	addiw	a5,a5,-1
    80004fe2:	07f7f713          	andi	a4,a5,127
    80004fe6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80004fe8:	01874703          	lbu	a4,24(a4)
    80004fec:	f52707e3          	beq	a4,s2,80004f3a <consoleintr+0x34>
      cons.e--;
    80004ff0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80004ff4:	10000513          	li	a0,256
    80004ff8:	eddff0ef          	jal	ra,80004ed4 <consputc>
    while(cons.e != cons.w &&
    80004ffc:	0a04a783          	lw	a5,160(s1)
    80005000:	09c4a703          	lw	a4,156(s1)
    80005004:	fcf71ee3          	bne	a4,a5,80004fe0 <consoleintr+0xda>
    80005008:	bf0d                	j	80004f3a <consoleintr+0x34>
    if(cons.e != cons.w){
    8000500a:	0001c717          	auipc	a4,0x1c
    8000500e:	ac670713          	addi	a4,a4,-1338 # 80020ad0 <cons>
    80005012:	0a072783          	lw	a5,160(a4)
    80005016:	09c72703          	lw	a4,156(a4)
    8000501a:	f2f700e3          	beq	a4,a5,80004f3a <consoleintr+0x34>
      cons.e--;
    8000501e:	37fd                	addiw	a5,a5,-1
    80005020:	0001c717          	auipc	a4,0x1c
    80005024:	b4f72823          	sw	a5,-1200(a4) # 80020b70 <cons+0xa0>
      consputc(BACKSPACE);
    80005028:	10000513          	li	a0,256
    8000502c:	ea9ff0ef          	jal	ra,80004ed4 <consputc>
    80005030:	b729                	j	80004f3a <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005032:	f00484e3          	beqz	s1,80004f3a <consoleintr+0x34>
    80005036:	b715                	j	80004f5a <consoleintr+0x54>
      consputc(c);
    80005038:	4529                	li	a0,10
    8000503a:	e9bff0ef          	jal	ra,80004ed4 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000503e:	0001c797          	auipc	a5,0x1c
    80005042:	a9278793          	addi	a5,a5,-1390 # 80020ad0 <cons>
    80005046:	0a07a703          	lw	a4,160(a5)
    8000504a:	0017069b          	addiw	a3,a4,1
    8000504e:	0006861b          	sext.w	a2,a3
    80005052:	0ad7a023          	sw	a3,160(a5)
    80005056:	07f77713          	andi	a4,a4,127
    8000505a:	97ba                	add	a5,a5,a4
    8000505c:	4729                	li	a4,10
    8000505e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005062:	0001c797          	auipc	a5,0x1c
    80005066:	b0c7a523          	sw	a2,-1270(a5) # 80020b6c <cons+0x9c>
        wakeup(&cons.r);
    8000506a:	0001c517          	auipc	a0,0x1c
    8000506e:	afe50513          	addi	a0,a0,-1282 # 80020b68 <cons+0x98>
    80005072:	ae2fc0ef          	jal	ra,80001354 <wakeup>
    80005076:	b5d1                	j	80004f3a <consoleintr+0x34>

0000000080005078 <consoleinit>:

void
consoleinit(void)
{
    80005078:	1141                	addi	sp,sp,-16
    8000507a:	e406                	sd	ra,8(sp)
    8000507c:	e022                	sd	s0,0(sp)
    8000507e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005080:	00002597          	auipc	a1,0x2
    80005084:	74058593          	addi	a1,a1,1856 # 800077c0 <syscalls+0x430>
    80005088:	0001c517          	auipc	a0,0x1c
    8000508c:	a4850513          	addi	a0,a0,-1464 # 80020ad0 <cons>
    80005090:	5c0000ef          	jal	ra,80005650 <initlock>

  uartinit();
    80005094:	3e2000ef          	jal	ra,80005476 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005098:	00013797          	auipc	a5,0x13
    8000509c:	8a078793          	addi	a5,a5,-1888 # 80017938 <devsw>
    800050a0:	00000717          	auipc	a4,0x0
    800050a4:	d3270713          	addi	a4,a4,-718 # 80004dd2 <consoleread>
    800050a8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800050aa:	00000717          	auipc	a4,0x0
    800050ae:	cac70713          	addi	a4,a4,-852 # 80004d56 <consolewrite>
    800050b2:	ef98                	sd	a4,24(a5)
}
    800050b4:	60a2                	ld	ra,8(sp)
    800050b6:	6402                	ld	s0,0(sp)
    800050b8:	0141                	addi	sp,sp,16
    800050ba:	8082                	ret

00000000800050bc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800050bc:	7139                	addi	sp,sp,-64
    800050be:	fc06                	sd	ra,56(sp)
    800050c0:	f822                	sd	s0,48(sp)
    800050c2:	f426                	sd	s1,40(sp)
    800050c4:	f04a                	sd	s2,32(sp)
    800050c6:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800050c8:	c219                	beqz	a2,800050ce <printint+0x12>
    800050ca:	06054f63          	bltz	a0,80005148 <printint+0x8c>
    x = -xx;
  else
    x = xx;
    800050ce:	4881                	li	a7,0
    800050d0:	fc840693          	addi	a3,s0,-56

  i = 0;
    800050d4:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800050d6:	00002617          	auipc	a2,0x2
    800050da:	71260613          	addi	a2,a2,1810 # 800077e8 <digits>
    800050de:	883e                	mv	a6,a5
    800050e0:	2785                	addiw	a5,a5,1
    800050e2:	02b57733          	remu	a4,a0,a1
    800050e6:	9732                	add	a4,a4,a2
    800050e8:	00074703          	lbu	a4,0(a4)
    800050ec:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800050f0:	872a                	mv	a4,a0
    800050f2:	02b55533          	divu	a0,a0,a1
    800050f6:	0685                	addi	a3,a3,1
    800050f8:	feb773e3          	bgeu	a4,a1,800050de <printint+0x22>

  if(sign)
    800050fc:	00088b63          	beqz	a7,80005112 <printint+0x56>
    buf[i++] = '-';
    80005100:	fe040713          	addi	a4,s0,-32
    80005104:	97ba                	add	a5,a5,a4
    80005106:	02d00713          	li	a4,45
    8000510a:	fee78423          	sb	a4,-24(a5)
    8000510e:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80005112:	02f05563          	blez	a5,8000513c <printint+0x80>
    80005116:	fc840713          	addi	a4,s0,-56
    8000511a:	00f704b3          	add	s1,a4,a5
    8000511e:	fff70913          	addi	s2,a4,-1
    80005122:	993e                	add	s2,s2,a5
    80005124:	37fd                	addiw	a5,a5,-1
    80005126:	1782                	slli	a5,a5,0x20
    80005128:	9381                	srli	a5,a5,0x20
    8000512a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000512e:	fff4c503          	lbu	a0,-1(s1)
    80005132:	da3ff0ef          	jal	ra,80004ed4 <consputc>
  while(--i >= 0)
    80005136:	14fd                	addi	s1,s1,-1
    80005138:	ff249be3          	bne	s1,s2,8000512e <printint+0x72>
}
    8000513c:	70e2                	ld	ra,56(sp)
    8000513e:	7442                	ld	s0,48(sp)
    80005140:	74a2                	ld	s1,40(sp)
    80005142:	7902                	ld	s2,32(sp)
    80005144:	6121                	addi	sp,sp,64
    80005146:	8082                	ret
    x = -xx;
    80005148:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000514c:	4885                	li	a7,1
    x = -xx;
    8000514e:	b749                	j	800050d0 <printint+0x14>

0000000080005150 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005150:	7131                	addi	sp,sp,-192
    80005152:	fc86                	sd	ra,120(sp)
    80005154:	f8a2                	sd	s0,112(sp)
    80005156:	f4a6                	sd	s1,104(sp)
    80005158:	f0ca                	sd	s2,96(sp)
    8000515a:	ecce                	sd	s3,88(sp)
    8000515c:	e8d2                	sd	s4,80(sp)
    8000515e:	e4d6                	sd	s5,72(sp)
    80005160:	e0da                	sd	s6,64(sp)
    80005162:	fc5e                	sd	s7,56(sp)
    80005164:	f862                	sd	s8,48(sp)
    80005166:	f466                	sd	s9,40(sp)
    80005168:	f06a                	sd	s10,32(sp)
    8000516a:	ec6e                	sd	s11,24(sp)
    8000516c:	0100                	addi	s0,sp,128
    8000516e:	8a2a                	mv	s4,a0
    80005170:	e40c                	sd	a1,8(s0)
    80005172:	e810                	sd	a2,16(s0)
    80005174:	ec14                	sd	a3,24(s0)
    80005176:	f018                	sd	a4,32(s0)
    80005178:	f41c                	sd	a5,40(s0)
    8000517a:	03043823          	sd	a6,48(s0)
    8000517e:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80005182:	00002797          	auipc	a5,0x2
    80005186:	70e7a783          	lw	a5,1806(a5) # 80007890 <panicking>
    8000518a:	cb9d                	beqz	a5,800051c0 <printf+0x70>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000518c:	00840793          	addi	a5,s0,8
    80005190:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005194:	000a4503          	lbu	a0,0(s4)
    80005198:	24050363          	beqz	a0,800053de <printf+0x28e>
    8000519c:	4981                	li	s3,0
    if(cx != '%'){
    8000519e:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800051a2:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800051a6:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800051aa:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800051ae:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800051b2:	07000d93          	li	s11,112
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800051b6:	00002b97          	auipc	s7,0x2
    800051ba:	632b8b93          	addi	s7,s7,1586 # 800077e8 <digits>
    800051be:	a01d                	j	800051e4 <printf+0x94>
    acquire(&pr.lock);
    800051c0:	0001c517          	auipc	a0,0x1c
    800051c4:	9b850513          	addi	a0,a0,-1608 # 80020b78 <pr>
    800051c8:	508000ef          	jal	ra,800056d0 <acquire>
    800051cc:	b7c1                	j	8000518c <printf+0x3c>
      consputc(cx);
    800051ce:	d07ff0ef          	jal	ra,80004ed4 <consputc>
      continue;
    800051d2:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800051d4:	0014899b          	addiw	s3,s1,1
    800051d8:	013a07b3          	add	a5,s4,s3
    800051dc:	0007c503          	lbu	a0,0(a5)
    800051e0:	1e050f63          	beqz	a0,800053de <printf+0x28e>
    if(cx != '%'){
    800051e4:	ff5515e3          	bne	a0,s5,800051ce <printf+0x7e>
    i++;
    800051e8:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800051ec:	009a07b3          	add	a5,s4,s1
    800051f0:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800051f4:	1e090563          	beqz	s2,800053de <printf+0x28e>
    800051f8:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800051fc:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800051fe:	c789                	beqz	a5,80005208 <printf+0xb8>
    80005200:	009a0733          	add	a4,s4,s1
    80005204:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005208:	03690863          	beq	s2,s6,80005238 <printf+0xe8>
    } else if(c0 == 'l' && c1 == 'd'){
    8000520c:	05890263          	beq	s2,s8,80005250 <printf+0x100>
    } else if(c0 == 'u'){
    80005210:	0d990163          	beq	s2,s9,800052d2 <printf+0x182>
    } else if(c0 == 'x'){
    80005214:	11a90863          	beq	s2,s10,80005324 <printf+0x1d4>
    } else if(c0 == 'p'){
    80005218:	15b90163          	beq	s2,s11,8000535a <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    8000521c:	06300793          	li	a5,99
    80005220:	16f90963          	beq	s2,a5,80005392 <printf+0x242>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    80005224:	07300793          	li	a5,115
    80005228:	16f90f63          	beq	s2,a5,800053a6 <printf+0x256>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000522c:	03591c63          	bne	s2,s5,80005264 <printf+0x114>
      consputc('%');
    80005230:	8556                	mv	a0,s5
    80005232:	ca3ff0ef          	jal	ra,80004ed4 <consputc>
    80005236:	bf79                	j	800051d4 <printf+0x84>
      printint(va_arg(ap, int), 10, 1);
    80005238:	f8843783          	ld	a5,-120(s0)
    8000523c:	00878713          	addi	a4,a5,8
    80005240:	f8e43423          	sd	a4,-120(s0)
    80005244:	4605                	li	a2,1
    80005246:	45a9                	li	a1,10
    80005248:	4388                	lw	a0,0(a5)
    8000524a:	e73ff0ef          	jal	ra,800050bc <printint>
    8000524e:	b759                	j	800051d4 <printf+0x84>
    } else if(c0 == 'l' && c1 == 'd'){
    80005250:	03678163          	beq	a5,s6,80005272 <printf+0x122>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005254:	03878d63          	beq	a5,s8,8000528e <printf+0x13e>
    } else if(c0 == 'l' && c1 == 'u'){
    80005258:	09978a63          	beq	a5,s9,800052ec <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000525c:	03878b63          	beq	a5,s8,80005292 <printf+0x142>
    } else if(c0 == 'l' && c1 == 'x'){
    80005260:	0da78f63          	beq	a5,s10,8000533e <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005264:	8556                	mv	a0,s5
    80005266:	c6fff0ef          	jal	ra,80004ed4 <consputc>
      consputc(c0);
    8000526a:	854a                	mv	a0,s2
    8000526c:	c69ff0ef          	jal	ra,80004ed4 <consputc>
    80005270:	b795                	j	800051d4 <printf+0x84>
      printint(va_arg(ap, uint64), 10, 1);
    80005272:	f8843783          	ld	a5,-120(s0)
    80005276:	00878713          	addi	a4,a5,8
    8000527a:	f8e43423          	sd	a4,-120(s0)
    8000527e:	4605                	li	a2,1
    80005280:	45a9                	li	a1,10
    80005282:	6388                	ld	a0,0(a5)
    80005284:	e39ff0ef          	jal	ra,800050bc <printint>
      i += 1;
    80005288:	0029849b          	addiw	s1,s3,2
    8000528c:	b7a1                	j	800051d4 <printf+0x84>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000528e:	03668463          	beq	a3,s6,800052b6 <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005292:	07968b63          	beq	a3,s9,80005308 <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005296:	fda697e3          	bne	a3,s10,80005264 <printf+0x114>
      printint(va_arg(ap, uint64), 16, 0);
    8000529a:	f8843783          	ld	a5,-120(s0)
    8000529e:	00878713          	addi	a4,a5,8
    800052a2:	f8e43423          	sd	a4,-120(s0)
    800052a6:	4601                	li	a2,0
    800052a8:	45c1                	li	a1,16
    800052aa:	6388                	ld	a0,0(a5)
    800052ac:	e11ff0ef          	jal	ra,800050bc <printint>
      i += 2;
    800052b0:	0039849b          	addiw	s1,s3,3
    800052b4:	b705                	j	800051d4 <printf+0x84>
      printint(va_arg(ap, uint64), 10, 1);
    800052b6:	f8843783          	ld	a5,-120(s0)
    800052ba:	00878713          	addi	a4,a5,8
    800052be:	f8e43423          	sd	a4,-120(s0)
    800052c2:	4605                	li	a2,1
    800052c4:	45a9                	li	a1,10
    800052c6:	6388                	ld	a0,0(a5)
    800052c8:	df5ff0ef          	jal	ra,800050bc <printint>
      i += 2;
    800052cc:	0039849b          	addiw	s1,s3,3
    800052d0:	b711                	j	800051d4 <printf+0x84>
      printint(va_arg(ap, uint32), 10, 0);
    800052d2:	f8843783          	ld	a5,-120(s0)
    800052d6:	00878713          	addi	a4,a5,8
    800052da:	f8e43423          	sd	a4,-120(s0)
    800052de:	4601                	li	a2,0
    800052e0:	45a9                	li	a1,10
    800052e2:	0007e503          	lwu	a0,0(a5)
    800052e6:	dd7ff0ef          	jal	ra,800050bc <printint>
    800052ea:	b5ed                	j	800051d4 <printf+0x84>
      printint(va_arg(ap, uint64), 10, 0);
    800052ec:	f8843783          	ld	a5,-120(s0)
    800052f0:	00878713          	addi	a4,a5,8
    800052f4:	f8e43423          	sd	a4,-120(s0)
    800052f8:	4601                	li	a2,0
    800052fa:	45a9                	li	a1,10
    800052fc:	6388                	ld	a0,0(a5)
    800052fe:	dbfff0ef          	jal	ra,800050bc <printint>
      i += 1;
    80005302:	0029849b          	addiw	s1,s3,2
    80005306:	b5f9                	j	800051d4 <printf+0x84>
      printint(va_arg(ap, uint64), 10, 0);
    80005308:	f8843783          	ld	a5,-120(s0)
    8000530c:	00878713          	addi	a4,a5,8
    80005310:	f8e43423          	sd	a4,-120(s0)
    80005314:	4601                	li	a2,0
    80005316:	45a9                	li	a1,10
    80005318:	6388                	ld	a0,0(a5)
    8000531a:	da3ff0ef          	jal	ra,800050bc <printint>
      i += 2;
    8000531e:	0039849b          	addiw	s1,s3,3
    80005322:	bd4d                	j	800051d4 <printf+0x84>
      printint(va_arg(ap, uint32), 16, 0);
    80005324:	f8843783          	ld	a5,-120(s0)
    80005328:	00878713          	addi	a4,a5,8
    8000532c:	f8e43423          	sd	a4,-120(s0)
    80005330:	4601                	li	a2,0
    80005332:	45c1                	li	a1,16
    80005334:	0007e503          	lwu	a0,0(a5)
    80005338:	d85ff0ef          	jal	ra,800050bc <printint>
    8000533c:	bd61                	j	800051d4 <printf+0x84>
      printint(va_arg(ap, uint64), 16, 0);
    8000533e:	f8843783          	ld	a5,-120(s0)
    80005342:	00878713          	addi	a4,a5,8
    80005346:	f8e43423          	sd	a4,-120(s0)
    8000534a:	4601                	li	a2,0
    8000534c:	45c1                	li	a1,16
    8000534e:	6388                	ld	a0,0(a5)
    80005350:	d6dff0ef          	jal	ra,800050bc <printint>
      i += 1;
    80005354:	0029849b          	addiw	s1,s3,2
    80005358:	bdb5                	j	800051d4 <printf+0x84>
      printptr(va_arg(ap, uint64));
    8000535a:	f8843783          	ld	a5,-120(s0)
    8000535e:	00878713          	addi	a4,a5,8
    80005362:	f8e43423          	sd	a4,-120(s0)
    80005366:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000536a:	03000513          	li	a0,48
    8000536e:	b67ff0ef          	jal	ra,80004ed4 <consputc>
  consputc('x');
    80005372:	856a                	mv	a0,s10
    80005374:	b61ff0ef          	jal	ra,80004ed4 <consputc>
    80005378:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000537a:	03c9d793          	srli	a5,s3,0x3c
    8000537e:	97de                	add	a5,a5,s7
    80005380:	0007c503          	lbu	a0,0(a5)
    80005384:	b51ff0ef          	jal	ra,80004ed4 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005388:	0992                	slli	s3,s3,0x4
    8000538a:	397d                	addiw	s2,s2,-1
    8000538c:	fe0917e3          	bnez	s2,8000537a <printf+0x22a>
    80005390:	b591                	j	800051d4 <printf+0x84>
      consputc(va_arg(ap, uint));
    80005392:	f8843783          	ld	a5,-120(s0)
    80005396:	00878713          	addi	a4,a5,8
    8000539a:	f8e43423          	sd	a4,-120(s0)
    8000539e:	4388                	lw	a0,0(a5)
    800053a0:	b35ff0ef          	jal	ra,80004ed4 <consputc>
    800053a4:	bd05                	j	800051d4 <printf+0x84>
      if((s = va_arg(ap, char*)) == 0)
    800053a6:	f8843783          	ld	a5,-120(s0)
    800053aa:	00878713          	addi	a4,a5,8
    800053ae:	f8e43423          	sd	a4,-120(s0)
    800053b2:	0007b903          	ld	s2,0(a5)
    800053b6:	00090d63          	beqz	s2,800053d0 <printf+0x280>
      for(; *s; s++)
    800053ba:	00094503          	lbu	a0,0(s2)
    800053be:	e0050be3          	beqz	a0,800051d4 <printf+0x84>
        consputc(*s);
    800053c2:	b13ff0ef          	jal	ra,80004ed4 <consputc>
      for(; *s; s++)
    800053c6:	0905                	addi	s2,s2,1
    800053c8:	00094503          	lbu	a0,0(s2)
    800053cc:	f97d                	bnez	a0,800053c2 <printf+0x272>
    800053ce:	b519                	j	800051d4 <printf+0x84>
        s = "(null)";
    800053d0:	00002917          	auipc	s2,0x2
    800053d4:	3f890913          	addi	s2,s2,1016 # 800077c8 <syscalls+0x438>
      for(; *s; s++)
    800053d8:	02800513          	li	a0,40
    800053dc:	b7dd                	j	800053c2 <printf+0x272>
    }

  }
  va_end(ap);

  if(panicking == 0)
    800053de:	00002797          	auipc	a5,0x2
    800053e2:	4b27a783          	lw	a5,1202(a5) # 80007890 <panicking>
    800053e6:	c38d                	beqz	a5,80005408 <printf+0x2b8>
    release(&pr.lock);

  return 0;
}
    800053e8:	4501                	li	a0,0
    800053ea:	70e6                	ld	ra,120(sp)
    800053ec:	7446                	ld	s0,112(sp)
    800053ee:	74a6                	ld	s1,104(sp)
    800053f0:	7906                	ld	s2,96(sp)
    800053f2:	69e6                	ld	s3,88(sp)
    800053f4:	6a46                	ld	s4,80(sp)
    800053f6:	6aa6                	ld	s5,72(sp)
    800053f8:	6b06                	ld	s6,64(sp)
    800053fa:	7be2                	ld	s7,56(sp)
    800053fc:	7c42                	ld	s8,48(sp)
    800053fe:	7ca2                	ld	s9,40(sp)
    80005400:	7d02                	ld	s10,32(sp)
    80005402:	6de2                	ld	s11,24(sp)
    80005404:	6129                	addi	sp,sp,192
    80005406:	8082                	ret
    release(&pr.lock);
    80005408:	0001b517          	auipc	a0,0x1b
    8000540c:	77050513          	addi	a0,a0,1904 # 80020b78 <pr>
    80005410:	358000ef          	jal	ra,80005768 <release>
  return 0;
    80005414:	bfd1                	j	800053e8 <printf+0x298>

0000000080005416 <panic>:

void
panic(char *s)
{
    80005416:	1101                	addi	sp,sp,-32
    80005418:	ec06                	sd	ra,24(sp)
    8000541a:	e822                	sd	s0,16(sp)
    8000541c:	e426                	sd	s1,8(sp)
    8000541e:	e04a                	sd	s2,0(sp)
    80005420:	1000                	addi	s0,sp,32
    80005422:	892a                	mv	s2,a0
  panicking = 1;
    80005424:	4485                	li	s1,1
    80005426:	00002797          	auipc	a5,0x2
    8000542a:	4697a523          	sw	s1,1130(a5) # 80007890 <panicking>
  printf("panic: ");
    8000542e:	00002517          	auipc	a0,0x2
    80005432:	3a250513          	addi	a0,a0,930 # 800077d0 <syscalls+0x440>
    80005436:	d1bff0ef          	jal	ra,80005150 <printf>
  printf("%s\n", s);
    8000543a:	85ca                	mv	a1,s2
    8000543c:	00002517          	auipc	a0,0x2
    80005440:	39c50513          	addi	a0,a0,924 # 800077d8 <syscalls+0x448>
    80005444:	d0dff0ef          	jal	ra,80005150 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005448:	00002797          	auipc	a5,0x2
    8000544c:	4497a223          	sw	s1,1092(a5) # 8000788c <panicked>
  for(;;)
    80005450:	a001                	j	80005450 <panic+0x3a>

0000000080005452 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005452:	1141                	addi	sp,sp,-16
    80005454:	e406                	sd	ra,8(sp)
    80005456:	e022                	sd	s0,0(sp)
    80005458:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    8000545a:	00002597          	auipc	a1,0x2
    8000545e:	38658593          	addi	a1,a1,902 # 800077e0 <syscalls+0x450>
    80005462:	0001b517          	auipc	a0,0x1b
    80005466:	71650513          	addi	a0,a0,1814 # 80020b78 <pr>
    8000546a:	1e6000ef          	jal	ra,80005650 <initlock>
}
    8000546e:	60a2                	ld	ra,8(sp)
    80005470:	6402                	ld	s0,0(sp)
    80005472:	0141                	addi	sp,sp,16
    80005474:	8082                	ret

0000000080005476 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80005476:	1141                	addi	sp,sp,-16
    80005478:	e406                	sd	ra,8(sp)
    8000547a:	e022                	sd	s0,0(sp)
    8000547c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000547e:	100007b7          	lui	a5,0x10000
    80005482:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005486:	f8000713          	li	a4,-128
    8000548a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000548e:	470d                	li	a4,3
    80005490:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005494:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005498:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000549c:	469d                	li	a3,7
    8000549e:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800054a2:	00e780a3          	sb	a4,1(a5)

  initlock(&tx_lock, "uart");
    800054a6:	00002597          	auipc	a1,0x2
    800054aa:	35a58593          	addi	a1,a1,858 # 80007800 <digits+0x18>
    800054ae:	0001b517          	auipc	a0,0x1b
    800054b2:	6e250513          	addi	a0,a0,1762 # 80020b90 <tx_lock>
    800054b6:	19a000ef          	jal	ra,80005650 <initlock>
}
    800054ba:	60a2                	ld	ra,8(sp)
    800054bc:	6402                	ld	s0,0(sp)
    800054be:	0141                	addi	sp,sp,16
    800054c0:	8082                	ret

00000000800054c2 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800054c2:	715d                	addi	sp,sp,-80
    800054c4:	e486                	sd	ra,72(sp)
    800054c6:	e0a2                	sd	s0,64(sp)
    800054c8:	fc26                	sd	s1,56(sp)
    800054ca:	f84a                	sd	s2,48(sp)
    800054cc:	f44e                	sd	s3,40(sp)
    800054ce:	f052                	sd	s4,32(sp)
    800054d0:	ec56                	sd	s5,24(sp)
    800054d2:	e85a                	sd	s6,16(sp)
    800054d4:	e45e                	sd	s7,8(sp)
    800054d6:	0880                	addi	s0,sp,80
    800054d8:	84aa                	mv	s1,a0
    800054da:	8aae                	mv	s5,a1
  acquire(&tx_lock);
    800054dc:	0001b517          	auipc	a0,0x1b
    800054e0:	6b450513          	addi	a0,a0,1716 # 80020b90 <tx_lock>
    800054e4:	1ec000ef          	jal	ra,800056d0 <acquire>

  int i = 0;
  while(i < n){ 
    800054e8:	05505b63          	blez	s5,8000553e <uartwrite+0x7c>
    800054ec:	8a26                	mv	s4,s1
    800054ee:	0485                	addi	s1,s1,1
    800054f0:	3afd                	addiw	s5,s5,-1
    800054f2:	1a82                	slli	s5,s5,0x20
    800054f4:	020ada93          	srli	s5,s5,0x20
    800054f8:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    800054fa:	00002497          	auipc	s1,0x2
    800054fe:	39e48493          	addi	s1,s1,926 # 80007898 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005502:	0001b997          	auipc	s3,0x1b
    80005506:	68e98993          	addi	s3,s3,1678 # 80020b90 <tx_lock>
    8000550a:	00002917          	auipc	s2,0x2
    8000550e:	38a90913          	addi	s2,s2,906 # 80007894 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005512:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005516:	4b05                	li	s6,1
    80005518:	a005                	j	80005538 <uartwrite+0x76>
      sleep(&tx_chan, &tx_lock);
    8000551a:	85ce                	mv	a1,s3
    8000551c:	854a                	mv	a0,s2
    8000551e:	debfb0ef          	jal	ra,80001308 <sleep>
    while(tx_busy != 0){
    80005522:	409c                	lw	a5,0(s1)
    80005524:	fbfd                	bnez	a5,8000551a <uartwrite+0x58>
    WriteReg(THR, buf[i]);
    80005526:	000a4783          	lbu	a5,0(s4)
    8000552a:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    8000552e:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005532:	0a05                	addi	s4,s4,1
    80005534:	015a0563          	beq	s4,s5,8000553e <uartwrite+0x7c>
    while(tx_busy != 0){
    80005538:	409c                	lw	a5,0(s1)
    8000553a:	f3e5                	bnez	a5,8000551a <uartwrite+0x58>
    8000553c:	b7ed                	j	80005526 <uartwrite+0x64>
  }

  release(&tx_lock);
    8000553e:	0001b517          	auipc	a0,0x1b
    80005542:	65250513          	addi	a0,a0,1618 # 80020b90 <tx_lock>
    80005546:	222000ef          	jal	ra,80005768 <release>
}
    8000554a:	60a6                	ld	ra,72(sp)
    8000554c:	6406                	ld	s0,64(sp)
    8000554e:	74e2                	ld	s1,56(sp)
    80005550:	7942                	ld	s2,48(sp)
    80005552:	79a2                	ld	s3,40(sp)
    80005554:	7a02                	ld	s4,32(sp)
    80005556:	6ae2                	ld	s5,24(sp)
    80005558:	6b42                	ld	s6,16(sp)
    8000555a:	6ba2                	ld	s7,8(sp)
    8000555c:	6161                	addi	sp,sp,80
    8000555e:	8082                	ret

0000000080005560 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005560:	1101                	addi	sp,sp,-32
    80005562:	ec06                	sd	ra,24(sp)
    80005564:	e822                	sd	s0,16(sp)
    80005566:	e426                	sd	s1,8(sp)
    80005568:	1000                	addi	s0,sp,32
    8000556a:	84aa                	mv	s1,a0
  if(panicking == 0)
    8000556c:	00002797          	auipc	a5,0x2
    80005570:	3247a783          	lw	a5,804(a5) # 80007890 <panicking>
    80005574:	cb89                	beqz	a5,80005586 <uartputc_sync+0x26>
    push_off();

  if(panicked){
    80005576:	00002797          	auipc	a5,0x2
    8000557a:	3167a783          	lw	a5,790(a5) # 8000788c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000557e:	10000737          	lui	a4,0x10000
  if(panicked){
    80005582:	c789                	beqz	a5,8000558c <uartputc_sync+0x2c>
    for(;;)
    80005584:	a001                	j	80005584 <uartputc_sync+0x24>
    push_off();
    80005586:	10a000ef          	jal	ra,80005690 <push_off>
    8000558a:	b7f5                	j	80005576 <uartputc_sync+0x16>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000558c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005590:	0ff7f793          	andi	a5,a5,255
    80005594:	0207f793          	andi	a5,a5,32
    80005598:	dbf5                	beqz	a5,8000558c <uartputc_sync+0x2c>
    ;
  WriteReg(THR, c);
    8000559a:	0ff4f793          	andi	a5,s1,255
    8000559e:	10000737          	lui	a4,0x10000
    800055a2:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    800055a6:	00002797          	auipc	a5,0x2
    800055aa:	2ea7a783          	lw	a5,746(a5) # 80007890 <panicking>
    800055ae:	c791                	beqz	a5,800055ba <uartputc_sync+0x5a>
    pop_off();
}
    800055b0:	60e2                	ld	ra,24(sp)
    800055b2:	6442                	ld	s0,16(sp)
    800055b4:	64a2                	ld	s1,8(sp)
    800055b6:	6105                	addi	sp,sp,32
    800055b8:	8082                	ret
    pop_off();
    800055ba:	15a000ef          	jal	ra,80005714 <pop_off>
}
    800055be:	bfcd                	j	800055b0 <uartputc_sync+0x50>

00000000800055c0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800055c0:	1141                	addi	sp,sp,-16
    800055c2:	e422                	sd	s0,8(sp)
    800055c4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800055c6:	100007b7          	lui	a5,0x10000
    800055ca:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800055ce:	8b85                	andi	a5,a5,1
    800055d0:	cb91                	beqz	a5,800055e4 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800055d2:	100007b7          	lui	a5,0x10000
    800055d6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800055da:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800055de:	6422                	ld	s0,8(sp)
    800055e0:	0141                	addi	sp,sp,16
    800055e2:	8082                	ret
    return -1;
    800055e4:	557d                	li	a0,-1
    800055e6:	bfe5                	j	800055de <uartgetc+0x1e>

00000000800055e8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800055e8:	1101                	addi	sp,sp,-32
    800055ea:	ec06                	sd	ra,24(sp)
    800055ec:	e822                	sd	s0,16(sp)
    800055ee:	e426                	sd	s1,8(sp)
    800055f0:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800055f2:	100004b7          	lui	s1,0x10000
    800055f6:	0024c783          	lbu	a5,2(s1) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    800055fa:	0001b517          	auipc	a0,0x1b
    800055fe:	59650513          	addi	a0,a0,1430 # 80020b90 <tx_lock>
    80005602:	0ce000ef          	jal	ra,800056d0 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005606:	0054c783          	lbu	a5,5(s1)
    8000560a:	0ff7f793          	andi	a5,a5,255
    8000560e:	0207f793          	andi	a5,a5,32
    80005612:	ef99                	bnez	a5,80005630 <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005614:	0001b517          	auipc	a0,0x1b
    80005618:	57c50513          	addi	a0,a0,1404 # 80020b90 <tx_lock>
    8000561c:	14c000ef          	jal	ra,80005768 <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005620:	54fd                	li	s1,-1
    int c = uartgetc();
    80005622:	f9fff0ef          	jal	ra,800055c0 <uartgetc>
    if(c == -1)
    80005626:	02950063          	beq	a0,s1,80005646 <uartintr+0x5e>
      break;
    consoleintr(c);
    8000562a:	8ddff0ef          	jal	ra,80004f06 <consoleintr>
  while(1){
    8000562e:	bfd5                	j	80005622 <uartintr+0x3a>
    tx_busy = 0;
    80005630:	00002797          	auipc	a5,0x2
    80005634:	2607a423          	sw	zero,616(a5) # 80007898 <tx_busy>
    wakeup(&tx_chan);
    80005638:	00002517          	auipc	a0,0x2
    8000563c:	25c50513          	addi	a0,a0,604 # 80007894 <tx_chan>
    80005640:	d15fb0ef          	jal	ra,80001354 <wakeup>
    80005644:	bfc1                	j	80005614 <uartintr+0x2c>
  }
}
    80005646:	60e2                	ld	ra,24(sp)
    80005648:	6442                	ld	s0,16(sp)
    8000564a:	64a2                	ld	s1,8(sp)
    8000564c:	6105                	addi	sp,sp,32
    8000564e:	8082                	ret

0000000080005650 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005650:	1141                	addi	sp,sp,-16
    80005652:	e422                	sd	s0,8(sp)
    80005654:	0800                	addi	s0,sp,16
  lk->name = name;
    80005656:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005658:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000565c:	00053823          	sd	zero,16(a0)
}
    80005660:	6422                	ld	s0,8(sp)
    80005662:	0141                	addi	sp,sp,16
    80005664:	8082                	ret

0000000080005666 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005666:	411c                	lw	a5,0(a0)
    80005668:	e399                	bnez	a5,8000566e <holding+0x8>
    8000566a:	4501                	li	a0,0
  return r;
}
    8000566c:	8082                	ret
{
    8000566e:	1101                	addi	sp,sp,-32
    80005670:	ec06                	sd	ra,24(sp)
    80005672:	e822                	sd	s0,16(sp)
    80005674:	e426                	sd	s1,8(sp)
    80005676:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005678:	6904                	ld	s1,16(a0)
    8000567a:	e80fb0ef          	jal	ra,80000cfa <mycpu>
    8000567e:	40a48533          	sub	a0,s1,a0
    80005682:	00153513          	seqz	a0,a0
}
    80005686:	60e2                	ld	ra,24(sp)
    80005688:	6442                	ld	s0,16(sp)
    8000568a:	64a2                	ld	s1,8(sp)
    8000568c:	6105                	addi	sp,sp,32
    8000568e:	8082                	ret

0000000080005690 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005690:	1101                	addi	sp,sp,-32
    80005692:	ec06                	sd	ra,24(sp)
    80005694:	e822                	sd	s0,16(sp)
    80005696:	e426                	sd	s1,8(sp)
    80005698:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000569a:	100024f3          	csrr	s1,sstatus
    8000569e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800056a2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800056a4:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    800056a8:	e52fb0ef          	jal	ra,80000cfa <mycpu>
    800056ac:	5d3c                	lw	a5,120(a0)
    800056ae:	cb99                	beqz	a5,800056c4 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800056b0:	e4afb0ef          	jal	ra,80000cfa <mycpu>
    800056b4:	5d3c                	lw	a5,120(a0)
    800056b6:	2785                	addiw	a5,a5,1
    800056b8:	dd3c                	sw	a5,120(a0)
}
    800056ba:	60e2                	ld	ra,24(sp)
    800056bc:	6442                	ld	s0,16(sp)
    800056be:	64a2                	ld	s1,8(sp)
    800056c0:	6105                	addi	sp,sp,32
    800056c2:	8082                	ret
    mycpu()->intena = old;
    800056c4:	e36fb0ef          	jal	ra,80000cfa <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800056c8:	8085                	srli	s1,s1,0x1
    800056ca:	8885                	andi	s1,s1,1
    800056cc:	dd64                	sw	s1,124(a0)
    800056ce:	b7cd                	j	800056b0 <push_off+0x20>

00000000800056d0 <acquire>:
{
    800056d0:	1101                	addi	sp,sp,-32
    800056d2:	ec06                	sd	ra,24(sp)
    800056d4:	e822                	sd	s0,16(sp)
    800056d6:	e426                	sd	s1,8(sp)
    800056d8:	1000                	addi	s0,sp,32
    800056da:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800056dc:	fb5ff0ef          	jal	ra,80005690 <push_off>
  if(holding(lk))
    800056e0:	8526                	mv	a0,s1
    800056e2:	f85ff0ef          	jal	ra,80005666 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800056e6:	4705                	li	a4,1
  if(holding(lk))
    800056e8:	e105                	bnez	a0,80005708 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800056ea:	87ba                	mv	a5,a4
    800056ec:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800056f0:	2781                	sext.w	a5,a5
    800056f2:	ffe5                	bnez	a5,800056ea <acquire+0x1a>
  __sync_synchronize();
    800056f4:	0ff0000f          	fence
  lk->cpu = mycpu();
    800056f8:	e02fb0ef          	jal	ra,80000cfa <mycpu>
    800056fc:	e888                	sd	a0,16(s1)
}
    800056fe:	60e2                	ld	ra,24(sp)
    80005700:	6442                	ld	s0,16(sp)
    80005702:	64a2                	ld	s1,8(sp)
    80005704:	6105                	addi	sp,sp,32
    80005706:	8082                	ret
    panic("acquire");
    80005708:	00002517          	auipc	a0,0x2
    8000570c:	10050513          	addi	a0,a0,256 # 80007808 <digits+0x20>
    80005710:	d07ff0ef          	jal	ra,80005416 <panic>

0000000080005714 <pop_off>:

void
pop_off(void)
{
    80005714:	1141                	addi	sp,sp,-16
    80005716:	e406                	sd	ra,8(sp)
    80005718:	e022                	sd	s0,0(sp)
    8000571a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000571c:	ddefb0ef          	jal	ra,80000cfa <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005720:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005724:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005726:	e78d                	bnez	a5,80005750 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005728:	5d3c                	lw	a5,120(a0)
    8000572a:	02f05963          	blez	a5,8000575c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000572e:	37fd                	addiw	a5,a5,-1
    80005730:	0007871b          	sext.w	a4,a5
    80005734:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005736:	eb09                	bnez	a4,80005748 <pop_off+0x34>
    80005738:	5d7c                	lw	a5,124(a0)
    8000573a:	c799                	beqz	a5,80005748 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000573c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005740:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005744:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005748:	60a2                	ld	ra,8(sp)
    8000574a:	6402                	ld	s0,0(sp)
    8000574c:	0141                	addi	sp,sp,16
    8000574e:	8082                	ret
    panic("pop_off - interruptible");
    80005750:	00002517          	auipc	a0,0x2
    80005754:	0c050513          	addi	a0,a0,192 # 80007810 <digits+0x28>
    80005758:	cbfff0ef          	jal	ra,80005416 <panic>
    panic("pop_off");
    8000575c:	00002517          	auipc	a0,0x2
    80005760:	0cc50513          	addi	a0,a0,204 # 80007828 <digits+0x40>
    80005764:	cb3ff0ef          	jal	ra,80005416 <panic>

0000000080005768 <release>:
{
    80005768:	1101                	addi	sp,sp,-32
    8000576a:	ec06                	sd	ra,24(sp)
    8000576c:	e822                	sd	s0,16(sp)
    8000576e:	e426                	sd	s1,8(sp)
    80005770:	1000                	addi	s0,sp,32
    80005772:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005774:	ef3ff0ef          	jal	ra,80005666 <holding>
    80005778:	c105                	beqz	a0,80005798 <release+0x30>
  lk->cpu = 0;
    8000577a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000577e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80005782:	0f50000f          	fence	iorw,ow
    80005786:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000578a:	f8bff0ef          	jal	ra,80005714 <pop_off>
}
    8000578e:	60e2                	ld	ra,24(sp)
    80005790:	6442                	ld	s0,16(sp)
    80005792:	64a2                	ld	s1,8(sp)
    80005794:	6105                	addi	sp,sp,32
    80005796:	8082                	ret
    panic("release");
    80005798:	00002517          	auipc	a0,0x2
    8000579c:	09850513          	addi	a0,a0,152 # 80007830 <digits+0x48>
    800057a0:	c77ff0ef          	jal	ra,80005416 <panic>
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
