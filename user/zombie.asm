
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	2ae000ef          	jal	ra,2b6 <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    pause(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2ac000ef          	jal	ra,2be <exit>
    pause(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	336000ef          	jal	ra,34e <pause>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	ra,0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	292000ef          	jal	ra,2be <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e422                	sd	s0,8(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0x8>
    ;
  return os;
}
  46:	6422                	ld	s0,8(sp)
  48:	0141                	addi	sp,sp,16
  4a:	8082                	ret

000000000000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e422                	sd	s0,8(sp)
  50:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  52:	00054783          	lbu	a5,0(a0)
  56:	cb91                	beqz	a5,6a <strcmp+0x1e>
  58:	0005c703          	lbu	a4,0(a1)
  5c:	00f71763          	bne	a4,a5,6a <strcmp+0x1e>
    p++, q++;
  60:	0505                	addi	a0,a0,1
  62:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	fbe5                	bnez	a5,58 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  6a:	0005c503          	lbu	a0,0(a1)
}
  6e:	40a7853b          	subw	a0,a5,a0
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strlen>:

uint
strlen(const char *s)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7e:	00054783          	lbu	a5,0(a0)
  82:	cf91                	beqz	a5,9e <strlen+0x26>
  84:	0505                	addi	a0,a0,1
  86:	87aa                	mv	a5,a0
  88:	4685                	li	a3,1
  8a:	9e89                	subw	a3,a3,a0
  8c:	00f6853b          	addw	a0,a3,a5
  90:	0785                	addi	a5,a5,1
  92:	fff7c703          	lbu	a4,-1(a5)
  96:	fb7d                	bnez	a4,8c <strlen+0x14>
    ;
  return n;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret
  for(n = 0; s[n]; n++)
  9e:	4501                	li	a0,0
  a0:	bfe5                	j	98 <strlen+0x20>

00000000000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a8:	ce09                	beqz	a2,c2 <memset+0x20>
  aa:	87aa                	mv	a5,a0
  ac:	fff6071b          	addiw	a4,a2,-1
  b0:	1702                	slli	a4,a4,0x20
  b2:	9301                	srli	a4,a4,0x20
  b4:	0705                	addi	a4,a4,1
  b6:	972a                	add	a4,a4,a0
    cdst[i] = c;
  b8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  bc:	0785                	addi	a5,a5,1
  be:	fee79de3          	bne	a5,a4,b8 <memset+0x16>
  }
  return dst;
}
  c2:	6422                	ld	s0,8(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret

00000000000000c8 <strchr>:

char*
strchr(const char *s, char c)
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e422                	sd	s0,8(sp)
  cc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cb99                	beqz	a5,e8 <strchr+0x20>
    if(*s == c)
  d4:	00f58763          	beq	a1,a5,e2 <strchr+0x1a>
  for(; *s; s++)
  d8:	0505                	addi	a0,a0,1
  da:	00054783          	lbu	a5,0(a0)
  de:	fbfd                	bnez	a5,d4 <strchr+0xc>
      return (char*)s;
  return 0;
  e0:	4501                	li	a0,0
}
  e2:	6422                	ld	s0,8(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret
  return 0;
  e8:	4501                	li	a0,0
  ea:	bfe5                	j	e2 <strchr+0x1a>

00000000000000ec <gets>:

char*
gets(char *buf, int max)
{
  ec:	711d                	addi	sp,sp,-96
  ee:	ec86                	sd	ra,88(sp)
  f0:	e8a2                	sd	s0,80(sp)
  f2:	e4a6                	sd	s1,72(sp)
  f4:	e0ca                	sd	s2,64(sp)
  f6:	fc4e                	sd	s3,56(sp)
  f8:	f852                	sd	s4,48(sp)
  fa:	f456                	sd	s5,40(sp)
  fc:	f05a                	sd	s6,32(sp)
  fe:	ec5e                	sd	s7,24(sp)
 100:	1080                	addi	s0,sp,96
 102:	8baa                	mv	s7,a0
 104:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 106:	892a                	mv	s2,a0
 108:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 10a:	4aa9                	li	s5,10
 10c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10e:	89a6                	mv	s3,s1
 110:	2485                	addiw	s1,s1,1
 112:	0344d663          	bge	s1,s4,13e <gets+0x52>
    cc = read(0, &c, 1);
 116:	4605                	li	a2,1
 118:	faf40593          	addi	a1,s0,-81
 11c:	4501                	li	a0,0
 11e:	1b8000ef          	jal	ra,2d6 <read>
    if(cc < 1)
 122:	00a05e63          	blez	a0,13e <gets+0x52>
    buf[i++] = c;
 126:	faf44783          	lbu	a5,-81(s0)
 12a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12e:	01578763          	beq	a5,s5,13c <gets+0x50>
 132:	0905                	addi	s2,s2,1
 134:	fd679de3          	bne	a5,s6,10e <gets+0x22>
  for(i=0; i+1 < max; ){
 138:	89a6                	mv	s3,s1
 13a:	a011                	j	13e <gets+0x52>
 13c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13e:	99de                	add	s3,s3,s7
 140:	00098023          	sb	zero,0(s3)
  return buf;
}
 144:	855e                	mv	a0,s7
 146:	60e6                	ld	ra,88(sp)
 148:	6446                	ld	s0,80(sp)
 14a:	64a6                	ld	s1,72(sp)
 14c:	6906                	ld	s2,64(sp)
 14e:	79e2                	ld	s3,56(sp)
 150:	7a42                	ld	s4,48(sp)
 152:	7aa2                	ld	s5,40(sp)
 154:	7b02                	ld	s6,32(sp)
 156:	6be2                	ld	s7,24(sp)
 158:	6125                	addi	sp,sp,96
 15a:	8082                	ret

000000000000015c <stat>:

int
stat(const char *n, struct stat *st)
{
 15c:	1101                	addi	sp,sp,-32
 15e:	ec06                	sd	ra,24(sp)
 160:	e822                	sd	s0,16(sp)
 162:	e426                	sd	s1,8(sp)
 164:	e04a                	sd	s2,0(sp)
 166:	1000                	addi	s0,sp,32
 168:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16a:	4581                	li	a1,0
 16c:	192000ef          	jal	ra,2fe <open>
  if(fd < 0)
 170:	02054163          	bltz	a0,192 <stat+0x36>
 174:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 176:	85ca                	mv	a1,s2
 178:	19e000ef          	jal	ra,316 <fstat>
 17c:	892a                	mv	s2,a0
  close(fd);
 17e:	8526                	mv	a0,s1
 180:	166000ef          	jal	ra,2e6 <close>
  return r;
}
 184:	854a                	mv	a0,s2
 186:	60e2                	ld	ra,24(sp)
 188:	6442                	ld	s0,16(sp)
 18a:	64a2                	ld	s1,8(sp)
 18c:	6902                	ld	s2,0(sp)
 18e:	6105                	addi	sp,sp,32
 190:	8082                	ret
    return -1;
 192:	597d                	li	s2,-1
 194:	bfc5                	j	184 <stat+0x28>

0000000000000196 <atoi>:

int
atoi(const char *s)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 19c:	00054603          	lbu	a2,0(a0)
 1a0:	fd06079b          	addiw	a5,a2,-48
 1a4:	0ff7f793          	andi	a5,a5,255
 1a8:	4725                	li	a4,9
 1aa:	02f76963          	bltu	a4,a5,1dc <atoi+0x46>
 1ae:	86aa                	mv	a3,a0
  n = 0;
 1b0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1b2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1b4:	0685                	addi	a3,a3,1
 1b6:	0025179b          	slliw	a5,a0,0x2
 1ba:	9fa9                	addw	a5,a5,a0
 1bc:	0017979b          	slliw	a5,a5,0x1
 1c0:	9fb1                	addw	a5,a5,a2
 1c2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c6:	0006c603          	lbu	a2,0(a3)
 1ca:	fd06071b          	addiw	a4,a2,-48
 1ce:	0ff77713          	andi	a4,a4,255
 1d2:	fee5f1e3          	bgeu	a1,a4,1b4 <atoi+0x1e>
  return n;
}
 1d6:	6422                	ld	s0,8(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret
  n = 0;
 1dc:	4501                	li	a0,0
 1de:	bfe5                	j	1d6 <atoi+0x40>

00000000000001e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e422                	sd	s0,8(sp)
 1e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e6:	02b57663          	bgeu	a0,a1,212 <memmove+0x32>
    while(n-- > 0)
 1ea:	02c05163          	blez	a2,20c <memmove+0x2c>
 1ee:	fff6079b          	addiw	a5,a2,-1
 1f2:	1782                	slli	a5,a5,0x20
 1f4:	9381                	srli	a5,a5,0x20
 1f6:	0785                	addi	a5,a5,1
 1f8:	97aa                	add	a5,a5,a0
  dst = vdst;
 1fa:	872a                	mv	a4,a0
      *dst++ = *src++;
 1fc:	0585                	addi	a1,a1,1
 1fe:	0705                	addi	a4,a4,1
 200:	fff5c683          	lbu	a3,-1(a1)
 204:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 208:	fee79ae3          	bne	a5,a4,1fc <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret
    dst += n;
 212:	00c50733          	add	a4,a0,a2
    src += n;
 216:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 218:	fec05ae3          	blez	a2,20c <memmove+0x2c>
 21c:	fff6079b          	addiw	a5,a2,-1
 220:	1782                	slli	a5,a5,0x20
 222:	9381                	srli	a5,a5,0x20
 224:	fff7c793          	not	a5,a5
 228:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 22a:	15fd                	addi	a1,a1,-1
 22c:	177d                	addi	a4,a4,-1
 22e:	0005c683          	lbu	a3,0(a1)
 232:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 236:	fee79ae3          	bne	a5,a4,22a <memmove+0x4a>
 23a:	bfc9                	j	20c <memmove+0x2c>

000000000000023c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 242:	ca05                	beqz	a2,272 <memcmp+0x36>
 244:	fff6069b          	addiw	a3,a2,-1
 248:	1682                	slli	a3,a3,0x20
 24a:	9281                	srli	a3,a3,0x20
 24c:	0685                	addi	a3,a3,1
 24e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 250:	00054783          	lbu	a5,0(a0)
 254:	0005c703          	lbu	a4,0(a1)
 258:	00e79863          	bne	a5,a4,268 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 25c:	0505                	addi	a0,a0,1
    p2++;
 25e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 260:	fed518e3          	bne	a0,a3,250 <memcmp+0x14>
  }
  return 0;
 264:	4501                	li	a0,0
 266:	a019                	j	26c <memcmp+0x30>
      return *p1 - *p2;
 268:	40e7853b          	subw	a0,a5,a4
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  return 0;
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <memcmp+0x30>

0000000000000276 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 276:	1141                	addi	sp,sp,-16
 278:	e406                	sd	ra,8(sp)
 27a:	e022                	sd	s0,0(sp)
 27c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 27e:	f63ff0ef          	jal	ra,1e0 <memmove>
}
 282:	60a2                	ld	ra,8(sp)
 284:	6402                	ld	s0,0(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

000000000000028a <sbrk>:

char *
sbrk(int n) {
 28a:	1141                	addi	sp,sp,-16
 28c:	e406                	sd	ra,8(sp)
 28e:	e022                	sd	s0,0(sp)
 290:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 292:	4585                	li	a1,1
 294:	0b2000ef          	jal	ra,346 <sys_sbrk>
}
 298:	60a2                	ld	ra,8(sp)
 29a:	6402                	ld	s0,0(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret

00000000000002a0 <sbrklazy>:

char *
sbrklazy(int n) {
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2a8:	4589                	li	a1,2
 2aa:	09c000ef          	jal	ra,346 <sys_sbrk>
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b6:	4885                	li	a7,1
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <exit>:
.global exit
exit:
 li a7, SYS_exit
 2be:	4889                	li	a7,2
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c6:	488d                	li	a7,3
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ce:	4891                	li	a7,4
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <read>:
.global read
read:
 li a7, SYS_read
 2d6:	4895                	li	a7,5
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <write>:
.global write
write:
 li a7, SYS_write
 2de:	48c1                	li	a7,16
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <close>:
.global close
close:
 li a7, SYS_close
 2e6:	48d5                	li	a7,21
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ee:	4899                	li	a7,6
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f6:	489d                	li	a7,7
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <open>:
.global open
open:
 li a7, SYS_open
 2fe:	48bd                	li	a7,15
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 306:	48c5                	li	a7,17
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30e:	48c9                	li	a7,18
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 316:	48a1                	li	a7,8
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <link>:
.global link
link:
 li a7, SYS_link
 31e:	48cd                	li	a7,19
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 326:	48d1                	li	a7,20
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32e:	48a5                	li	a7,9
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <dup>:
.global dup
dup:
 li a7, SYS_dup
 336:	48a9                	li	a7,10
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33e:	48ad                	li	a7,11
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 346:	48b1                	li	a7,12
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <pause>:
.global pause
pause:
 li a7, SYS_pause
 34e:	48b5                	li	a7,13
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 356:	48b9                	li	a7,14
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <getproctree>:
.global getproctree
getproctree:
 li a7, SYS_getproctree
 35e:	48d9                	li	a7,22
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 366:	1101                	addi	sp,sp,-32
 368:	ec06                	sd	ra,24(sp)
 36a:	e822                	sd	s0,16(sp)
 36c:	1000                	addi	s0,sp,32
 36e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 372:	4605                	li	a2,1
 374:	fef40593          	addi	a1,s0,-17
 378:	f67ff0ef          	jal	ra,2de <write>
}
 37c:	60e2                	ld	ra,24(sp)
 37e:	6442                	ld	s0,16(sp)
 380:	6105                	addi	sp,sp,32
 382:	8082                	ret

0000000000000384 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 384:	715d                	addi	sp,sp,-80
 386:	e486                	sd	ra,72(sp)
 388:	e0a2                	sd	s0,64(sp)
 38a:	fc26                	sd	s1,56(sp)
 38c:	f84a                	sd	s2,48(sp)
 38e:	f44e                	sd	s3,40(sp)
 390:	0880                	addi	s0,sp,80
 392:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 394:	c299                	beqz	a3,39a <printint+0x16>
 396:	0805c663          	bltz	a1,422 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 39a:	2581                	sext.w	a1,a1
  neg = 0;
 39c:	4881                	li	a7,0
 39e:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3a2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a4:	2601                	sext.w	a2,a2
 3a6:	00000517          	auipc	a0,0x0
 3aa:	4f250513          	addi	a0,a0,1266 # 898 <digits>
 3ae:	883a                	mv	a6,a4
 3b0:	2705                	addiw	a4,a4,1
 3b2:	02c5f7bb          	remuw	a5,a1,a2
 3b6:	1782                	slli	a5,a5,0x20
 3b8:	9381                	srli	a5,a5,0x20
 3ba:	97aa                	add	a5,a5,a0
 3bc:	0007c783          	lbu	a5,0(a5)
 3c0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c4:	0005879b          	sext.w	a5,a1
 3c8:	02c5d5bb          	divuw	a1,a1,a2
 3cc:	0685                	addi	a3,a3,1
 3ce:	fec7f0e3          	bgeu	a5,a2,3ae <printint+0x2a>
  if(neg)
 3d2:	00088b63          	beqz	a7,3e8 <printint+0x64>
    buf[i++] = '-';
 3d6:	fd040793          	addi	a5,s0,-48
 3da:	973e                	add	a4,a4,a5
 3dc:	02d00793          	li	a5,45
 3e0:	fef70423          	sb	a5,-24(a4)
 3e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3e8:	02e05663          	blez	a4,414 <printint+0x90>
 3ec:	fb840793          	addi	a5,s0,-72
 3f0:	00e78933          	add	s2,a5,a4
 3f4:	fff78993          	addi	s3,a5,-1
 3f8:	99ba                	add	s3,s3,a4
 3fa:	377d                	addiw	a4,a4,-1
 3fc:	1702                	slli	a4,a4,0x20
 3fe:	9301                	srli	a4,a4,0x20
 400:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 404:	fff94583          	lbu	a1,-1(s2)
 408:	8526                	mv	a0,s1
 40a:	f5dff0ef          	jal	ra,366 <putc>
  while(--i >= 0)
 40e:	197d                	addi	s2,s2,-1
 410:	ff391ae3          	bne	s2,s3,404 <printint+0x80>
}
 414:	60a6                	ld	ra,72(sp)
 416:	6406                	ld	s0,64(sp)
 418:	74e2                	ld	s1,56(sp)
 41a:	7942                	ld	s2,48(sp)
 41c:	79a2                	ld	s3,40(sp)
 41e:	6161                	addi	sp,sp,80
 420:	8082                	ret
    x = -xx;
 422:	40b005bb          	negw	a1,a1
    neg = 1;
 426:	4885                	li	a7,1
    x = -xx;
 428:	bf9d                	j	39e <printint+0x1a>

000000000000042a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 42a:	7119                	addi	sp,sp,-128
 42c:	fc86                	sd	ra,120(sp)
 42e:	f8a2                	sd	s0,112(sp)
 430:	f4a6                	sd	s1,104(sp)
 432:	f0ca                	sd	s2,96(sp)
 434:	ecce                	sd	s3,88(sp)
 436:	e8d2                	sd	s4,80(sp)
 438:	e4d6                	sd	s5,72(sp)
 43a:	e0da                	sd	s6,64(sp)
 43c:	fc5e                	sd	s7,56(sp)
 43e:	f862                	sd	s8,48(sp)
 440:	f466                	sd	s9,40(sp)
 442:	f06a                	sd	s10,32(sp)
 444:	ec6e                	sd	s11,24(sp)
 446:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 448:	0005c903          	lbu	s2,0(a1)
 44c:	24090c63          	beqz	s2,6a4 <vprintf+0x27a>
 450:	8b2a                	mv	s6,a0
 452:	8a2e                	mv	s4,a1
 454:	8bb2                	mv	s7,a2
  state = 0;
 456:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 458:	4481                	li	s1,0
 45a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 45c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 460:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 464:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 468:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 46c:	00000c97          	auipc	s9,0x0
 470:	42cc8c93          	addi	s9,s9,1068 # 898 <digits>
 474:	a005                	j	494 <vprintf+0x6a>
        putc(fd, c0);
 476:	85ca                	mv	a1,s2
 478:	855a                	mv	a0,s6
 47a:	eedff0ef          	jal	ra,366 <putc>
 47e:	a019                	j	484 <vprintf+0x5a>
    } else if(state == '%'){
 480:	03598263          	beq	s3,s5,4a4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 484:	2485                	addiw	s1,s1,1
 486:	8726                	mv	a4,s1
 488:	009a07b3          	add	a5,s4,s1
 48c:	0007c903          	lbu	s2,0(a5)
 490:	20090a63          	beqz	s2,6a4 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 494:	0009079b          	sext.w	a5,s2
    if(state == 0){
 498:	fe0994e3          	bnez	s3,480 <vprintf+0x56>
      if(c0 == '%'){
 49c:	fd579de3          	bne	a5,s5,476 <vprintf+0x4c>
        state = '%';
 4a0:	89be                	mv	s3,a5
 4a2:	b7cd                	j	484 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4a4:	c3c1                	beqz	a5,524 <vprintf+0xfa>
 4a6:	00ea06b3          	add	a3,s4,a4
 4aa:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4ae:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4b0:	c681                	beqz	a3,4b8 <vprintf+0x8e>
 4b2:	9752                	add	a4,a4,s4
 4b4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4b8:	03878e63          	beq	a5,s8,4f4 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 4bc:	05a78863          	beq	a5,s10,50c <vprintf+0xe2>
      } else if(c0 == 'u'){
 4c0:	0db78b63          	beq	a5,s11,596 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4c4:	07800713          	li	a4,120
 4c8:	10e78d63          	beq	a5,a4,5e2 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4cc:	07000713          	li	a4,112
 4d0:	14e78263          	beq	a5,a4,614 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 4d4:	06300713          	li	a4,99
 4d8:	16e78f63          	beq	a5,a4,656 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 4dc:	07300713          	li	a4,115
 4e0:	18e78563          	beq	a5,a4,66a <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4e4:	05579063          	bne	a5,s5,524 <vprintf+0xfa>
        putc(fd, '%');
 4e8:	85d6                	mv	a1,s5
 4ea:	855a                	mv	a0,s6
 4ec:	e7bff0ef          	jal	ra,366 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4f0:	4981                	li	s3,0
 4f2:	bf49                	j	484 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 4f4:	008b8913          	addi	s2,s7,8
 4f8:	4685                	li	a3,1
 4fa:	4629                	li	a2,10
 4fc:	000ba583          	lw	a1,0(s7)
 500:	855a                	mv	a0,s6
 502:	e83ff0ef          	jal	ra,384 <printint>
 506:	8bca                	mv	s7,s2
      state = 0;
 508:	4981                	li	s3,0
 50a:	bfad                	j	484 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 50c:	03868663          	beq	a3,s8,538 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 510:	05a68163          	beq	a3,s10,552 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 514:	09b68d63          	beq	a3,s11,5ae <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 518:	03a68f63          	beq	a3,s10,556 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 51c:	07800793          	li	a5,120
 520:	0cf68d63          	beq	a3,a5,5fa <vprintf+0x1d0>
        putc(fd, '%');
 524:	85d6                	mv	a1,s5
 526:	855a                	mv	a0,s6
 528:	e3fff0ef          	jal	ra,366 <putc>
        putc(fd, c0);
 52c:	85ca                	mv	a1,s2
 52e:	855a                	mv	a0,s6
 530:	e37ff0ef          	jal	ra,366 <putc>
      state = 0;
 534:	4981                	li	s3,0
 536:	b7b9                	j	484 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 538:	008b8913          	addi	s2,s7,8
 53c:	4685                	li	a3,1
 53e:	4629                	li	a2,10
 540:	000bb583          	ld	a1,0(s7)
 544:	855a                	mv	a0,s6
 546:	e3fff0ef          	jal	ra,384 <printint>
        i += 1;
 54a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 54c:	8bca                	mv	s7,s2
      state = 0;
 54e:	4981                	li	s3,0
        i += 1;
 550:	bf15                	j	484 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 552:	03860563          	beq	a2,s8,57c <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 556:	07b60963          	beq	a2,s11,5c8 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 55a:	07800793          	li	a5,120
 55e:	fcf613e3          	bne	a2,a5,524 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 562:	008b8913          	addi	s2,s7,8
 566:	4681                	li	a3,0
 568:	4641                	li	a2,16
 56a:	000bb583          	ld	a1,0(s7)
 56e:	855a                	mv	a0,s6
 570:	e15ff0ef          	jal	ra,384 <printint>
        i += 2;
 574:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 576:	8bca                	mv	s7,s2
      state = 0;
 578:	4981                	li	s3,0
        i += 2;
 57a:	b729                	j	484 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 57c:	008b8913          	addi	s2,s7,8
 580:	4685                	li	a3,1
 582:	4629                	li	a2,10
 584:	000bb583          	ld	a1,0(s7)
 588:	855a                	mv	a0,s6
 58a:	dfbff0ef          	jal	ra,384 <printint>
        i += 2;
 58e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 590:	8bca                	mv	s7,s2
      state = 0;
 592:	4981                	li	s3,0
        i += 2;
 594:	bdc5                	j	484 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 596:	008b8913          	addi	s2,s7,8
 59a:	4681                	li	a3,0
 59c:	4629                	li	a2,10
 59e:	000be583          	lwu	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	de1ff0ef          	jal	ra,384 <printint>
 5a8:	8bca                	mv	s7,s2
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bde1                	j	484 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ae:	008b8913          	addi	s2,s7,8
 5b2:	4681                	li	a3,0
 5b4:	4629                	li	a2,10
 5b6:	000bb583          	ld	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	dc9ff0ef          	jal	ra,384 <printint>
        i += 1;
 5c0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
        i += 1;
 5c6:	bd7d                	j	484 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c8:	008b8913          	addi	s2,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4629                	li	a2,10
 5d0:	000bb583          	ld	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	dafff0ef          	jal	ra,384 <printint>
        i += 2;
 5da:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	8bca                	mv	s7,s2
      state = 0;
 5de:	4981                	li	s3,0
        i += 2;
 5e0:	b555                	j	484 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5e2:	008b8913          	addi	s2,s7,8
 5e6:	4681                	li	a3,0
 5e8:	4641                	li	a2,16
 5ea:	000be583          	lwu	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	d95ff0ef          	jal	ra,384 <printint>
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b571                	j	484 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fa:	008b8913          	addi	s2,s7,8
 5fe:	4681                	li	a3,0
 600:	4641                	li	a2,16
 602:	000bb583          	ld	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	d7dff0ef          	jal	ra,384 <printint>
        i += 1;
 60c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
        i += 1;
 612:	bd8d                	j	484 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 614:	008b8793          	addi	a5,s7,8
 618:	f8f43423          	sd	a5,-120(s0)
 61c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 620:	03000593          	li	a1,48
 624:	855a                	mv	a0,s6
 626:	d41ff0ef          	jal	ra,366 <putc>
  putc(fd, 'x');
 62a:	07800593          	li	a1,120
 62e:	855a                	mv	a0,s6
 630:	d37ff0ef          	jal	ra,366 <putc>
 634:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 636:	03c9d793          	srli	a5,s3,0x3c
 63a:	97e6                	add	a5,a5,s9
 63c:	0007c583          	lbu	a1,0(a5)
 640:	855a                	mv	a0,s6
 642:	d25ff0ef          	jal	ra,366 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 646:	0992                	slli	s3,s3,0x4
 648:	397d                	addiw	s2,s2,-1
 64a:	fe0916e3          	bnez	s2,636 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 64e:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 652:	4981                	li	s3,0
 654:	bd05                	j	484 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 656:	008b8913          	addi	s2,s7,8
 65a:	000bc583          	lbu	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	d07ff0ef          	jal	ra,366 <putc>
 664:	8bca                	mv	s7,s2
      state = 0;
 666:	4981                	li	s3,0
 668:	bd31                	j	484 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 66a:	008b8993          	addi	s3,s7,8
 66e:	000bb903          	ld	s2,0(s7)
 672:	00090f63          	beqz	s2,690 <vprintf+0x266>
        for(; *s; s++)
 676:	00094583          	lbu	a1,0(s2)
 67a:	c195                	beqz	a1,69e <vprintf+0x274>
          putc(fd, *s);
 67c:	855a                	mv	a0,s6
 67e:	ce9ff0ef          	jal	ra,366 <putc>
        for(; *s; s++)
 682:	0905                	addi	s2,s2,1
 684:	00094583          	lbu	a1,0(s2)
 688:	f9f5                	bnez	a1,67c <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 68a:	8bce                	mv	s7,s3
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bbdd                	j	484 <vprintf+0x5a>
          s = "(null)";
 690:	00000917          	auipc	s2,0x0
 694:	20090913          	addi	s2,s2,512 # 890 <malloc+0xea>
        for(; *s; s++)
 698:	02800593          	li	a1,40
 69c:	b7c5                	j	67c <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 69e:	8bce                	mv	s7,s3
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	b3cd                	j	484 <vprintf+0x5a>
    }
  }
}
 6a4:	70e6                	ld	ra,120(sp)
 6a6:	7446                	ld	s0,112(sp)
 6a8:	74a6                	ld	s1,104(sp)
 6aa:	7906                	ld	s2,96(sp)
 6ac:	69e6                	ld	s3,88(sp)
 6ae:	6a46                	ld	s4,80(sp)
 6b0:	6aa6                	ld	s5,72(sp)
 6b2:	6b06                	ld	s6,64(sp)
 6b4:	7be2                	ld	s7,56(sp)
 6b6:	7c42                	ld	s8,48(sp)
 6b8:	7ca2                	ld	s9,40(sp)
 6ba:	7d02                	ld	s10,32(sp)
 6bc:	6de2                	ld	s11,24(sp)
 6be:	6109                	addi	sp,sp,128
 6c0:	8082                	ret

00000000000006c2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c2:	715d                	addi	sp,sp,-80
 6c4:	ec06                	sd	ra,24(sp)
 6c6:	e822                	sd	s0,16(sp)
 6c8:	1000                	addi	s0,sp,32
 6ca:	e010                	sd	a2,0(s0)
 6cc:	e414                	sd	a3,8(s0)
 6ce:	e818                	sd	a4,16(s0)
 6d0:	ec1c                	sd	a5,24(s0)
 6d2:	03043023          	sd	a6,32(s0)
 6d6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6da:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6de:	8622                	mv	a2,s0
 6e0:	d4bff0ef          	jal	ra,42a <vprintf>
}
 6e4:	60e2                	ld	ra,24(sp)
 6e6:	6442                	ld	s0,16(sp)
 6e8:	6161                	addi	sp,sp,80
 6ea:	8082                	ret

00000000000006ec <printf>:

void
printf(const char *fmt, ...)
{
 6ec:	711d                	addi	sp,sp,-96
 6ee:	ec06                	sd	ra,24(sp)
 6f0:	e822                	sd	s0,16(sp)
 6f2:	1000                	addi	s0,sp,32
 6f4:	e40c                	sd	a1,8(s0)
 6f6:	e810                	sd	a2,16(s0)
 6f8:	ec14                	sd	a3,24(s0)
 6fa:	f018                	sd	a4,32(s0)
 6fc:	f41c                	sd	a5,40(s0)
 6fe:	03043823          	sd	a6,48(s0)
 702:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 706:	00840613          	addi	a2,s0,8
 70a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 70e:	85aa                	mv	a1,a0
 710:	4505                	li	a0,1
 712:	d19ff0ef          	jal	ra,42a <vprintf>
}
 716:	60e2                	ld	ra,24(sp)
 718:	6442                	ld	s0,16(sp)
 71a:	6125                	addi	sp,sp,96
 71c:	8082                	ret

000000000000071e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71e:	1141                	addi	sp,sp,-16
 720:	e422                	sd	s0,8(sp)
 722:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 724:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 728:	00001797          	auipc	a5,0x1
 72c:	8d87b783          	ld	a5,-1832(a5) # 1000 <freep>
 730:	a805                	j	760 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 732:	4618                	lw	a4,8(a2)
 734:	9db9                	addw	a1,a1,a4
 736:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 73a:	6398                	ld	a4,0(a5)
 73c:	6318                	ld	a4,0(a4)
 73e:	fee53823          	sd	a4,-16(a0)
 742:	a091                	j	786 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 744:	ff852703          	lw	a4,-8(a0)
 748:	9e39                	addw	a2,a2,a4
 74a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 74c:	ff053703          	ld	a4,-16(a0)
 750:	e398                	sd	a4,0(a5)
 752:	a099                	j	798 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 754:	6398                	ld	a4,0(a5)
 756:	00e7e463          	bltu	a5,a4,75e <free+0x40>
 75a:	00e6ea63          	bltu	a3,a4,76e <free+0x50>
{
 75e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 760:	fed7fae3          	bgeu	a5,a3,754 <free+0x36>
 764:	6398                	ld	a4,0(a5)
 766:	00e6e463          	bltu	a3,a4,76e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76a:	fee7eae3          	bltu	a5,a4,75e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 76e:	ff852583          	lw	a1,-8(a0)
 772:	6390                	ld	a2,0(a5)
 774:	02059713          	slli	a4,a1,0x20
 778:	9301                	srli	a4,a4,0x20
 77a:	0712                	slli	a4,a4,0x4
 77c:	9736                	add	a4,a4,a3
 77e:	fae60ae3          	beq	a2,a4,732 <free+0x14>
    bp->s.ptr = p->s.ptr;
 782:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 786:	4790                	lw	a2,8(a5)
 788:	02061713          	slli	a4,a2,0x20
 78c:	9301                	srli	a4,a4,0x20
 78e:	0712                	slli	a4,a4,0x4
 790:	973e                	add	a4,a4,a5
 792:	fae689e3          	beq	a3,a4,744 <free+0x26>
  } else
    p->s.ptr = bp;
 796:	e394                	sd	a3,0(a5)
  freep = p;
 798:	00001717          	auipc	a4,0x1
 79c:	86f73423          	sd	a5,-1944(a4) # 1000 <freep>
}
 7a0:	6422                	ld	s0,8(sp)
 7a2:	0141                	addi	sp,sp,16
 7a4:	8082                	ret

00000000000007a6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a6:	7139                	addi	sp,sp,-64
 7a8:	fc06                	sd	ra,56(sp)
 7aa:	f822                	sd	s0,48(sp)
 7ac:	f426                	sd	s1,40(sp)
 7ae:	f04a                	sd	s2,32(sp)
 7b0:	ec4e                	sd	s3,24(sp)
 7b2:	e852                	sd	s4,16(sp)
 7b4:	e456                	sd	s5,8(sp)
 7b6:	e05a                	sd	s6,0(sp)
 7b8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ba:	02051493          	slli	s1,a0,0x20
 7be:	9081                	srli	s1,s1,0x20
 7c0:	04bd                	addi	s1,s1,15
 7c2:	8091                	srli	s1,s1,0x4
 7c4:	0014899b          	addiw	s3,s1,1
 7c8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7ca:	00001517          	auipc	a0,0x1
 7ce:	83653503          	ld	a0,-1994(a0) # 1000 <freep>
 7d2:	c515                	beqz	a0,7fe <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d6:	4798                	lw	a4,8(a5)
 7d8:	02977f63          	bgeu	a4,s1,816 <malloc+0x70>
 7dc:	8a4e                	mv	s4,s3
 7de:	0009871b          	sext.w	a4,s3
 7e2:	6685                	lui	a3,0x1
 7e4:	00d77363          	bgeu	a4,a3,7ea <malloc+0x44>
 7e8:	6a05                	lui	s4,0x1
 7ea:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ee:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f2:	00001917          	auipc	s2,0x1
 7f6:	80e90913          	addi	s2,s2,-2034 # 1000 <freep>
  if(p == SBRK_ERROR)
 7fa:	5afd                	li	s5,-1
 7fc:	a0bd                	j	86a <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 7fe:	00001797          	auipc	a5,0x1
 802:	81278793          	addi	a5,a5,-2030 # 1010 <base>
 806:	00000717          	auipc	a4,0x0
 80a:	7ef73d23          	sd	a5,2042(a4) # 1000 <freep>
 80e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 810:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 814:	b7e1                	j	7dc <malloc+0x36>
      if(p->s.size == nunits)
 816:	02e48b63          	beq	s1,a4,84c <malloc+0xa6>
        p->s.size -= nunits;
 81a:	4137073b          	subw	a4,a4,s3
 81e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 820:	1702                	slli	a4,a4,0x20
 822:	9301                	srli	a4,a4,0x20
 824:	0712                	slli	a4,a4,0x4
 826:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 828:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 82c:	00000717          	auipc	a4,0x0
 830:	7ca73a23          	sd	a0,2004(a4) # 1000 <freep>
      return (void*)(p + 1);
 834:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 838:	70e2                	ld	ra,56(sp)
 83a:	7442                	ld	s0,48(sp)
 83c:	74a2                	ld	s1,40(sp)
 83e:	7902                	ld	s2,32(sp)
 840:	69e2                	ld	s3,24(sp)
 842:	6a42                	ld	s4,16(sp)
 844:	6aa2                	ld	s5,8(sp)
 846:	6b02                	ld	s6,0(sp)
 848:	6121                	addi	sp,sp,64
 84a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 84c:	6398                	ld	a4,0(a5)
 84e:	e118                	sd	a4,0(a0)
 850:	bff1                	j	82c <malloc+0x86>
  hp->s.size = nu;
 852:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 856:	0541                	addi	a0,a0,16
 858:	ec7ff0ef          	jal	ra,71e <free>
  return freep;
 85c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 860:	dd61                	beqz	a0,838 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 862:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 864:	4798                	lw	a4,8(a5)
 866:	fa9778e3          	bgeu	a4,s1,816 <malloc+0x70>
    if(p == freep)
 86a:	00093703          	ld	a4,0(s2)
 86e:	853e                	mv	a0,a5
 870:	fef719e3          	bne	a4,a5,862 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 874:	8552                	mv	a0,s4
 876:	a15ff0ef          	jal	ra,28a <sbrk>
  if(p == SBRK_ERROR)
 87a:	fd551ce3          	bne	a0,s5,852 <malloc+0xac>
        return 0;
 87e:	4501                	li	a0,0
 880:	bf65                	j	838 <malloc+0x92>
