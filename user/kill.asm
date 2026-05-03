
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7d763          	bge	a5,a0,3c <main+0x3c>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	1902                	slli	s2,s2,0x20
  1c:	02095913          	srli	s2,s2,0x20
  20:	090e                	slli	s2,s2,0x3
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	1a0000ef          	jal	ra,1c8 <atoi>
  2c:	2f4000ef          	jal	ra,320 <kill>
  for(i=1; i<argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	2b8000ef          	jal	ra,2f0 <exit>
    fprintf(2, "usage: kill pid...\n");
  3c:	00001597          	auipc	a1,0x1
  40:	87458593          	addi	a1,a1,-1932 # 8b0 <malloc+0xe0>
  44:	4509                	li	a0,2
  46:	6a6000ef          	jal	ra,6ec <fprintf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	2a4000ef          	jal	ra,2f0 <exit>

0000000000000050 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  extern int main();
  main();
  58:	fa9ff0ef          	jal	ra,0 <main>
  exit(0);
  5c:	4501                	li	a0,0
  5e:	292000ef          	jal	ra,2f0 <exit>

0000000000000062 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  62:	1141                	addi	sp,sp,-16
  64:	e422                	sd	s0,8(sp)
  66:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  68:	87aa                	mv	a5,a0
  6a:	0585                	addi	a1,a1,1
  6c:	0785                	addi	a5,a5,1
  6e:	fff5c703          	lbu	a4,-1(a1)
  72:	fee78fa3          	sb	a4,-1(a5)
  76:	fb75                	bnez	a4,6a <strcpy+0x8>
    ;
  return os;
}
  78:	6422                	ld	s0,8(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e422                	sd	s0,8(sp)
  82:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  84:	00054783          	lbu	a5,0(a0)
  88:	cb91                	beqz	a5,9c <strcmp+0x1e>
  8a:	0005c703          	lbu	a4,0(a1)
  8e:	00f71763          	bne	a4,a5,9c <strcmp+0x1e>
    p++, q++;
  92:	0505                	addi	a0,a0,1
  94:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  96:	00054783          	lbu	a5,0(a0)
  9a:	fbe5                	bnez	a5,8a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9c:	0005c503          	lbu	a0,0(a1)
}
  a0:	40a7853b          	subw	a0,a5,a0
  a4:	6422                	ld	s0,8(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret

00000000000000aa <strlen>:

uint
strlen(const char *s)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e422                	sd	s0,8(sp)
  ae:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	cf91                	beqz	a5,d0 <strlen+0x26>
  b6:	0505                	addi	a0,a0,1
  b8:	87aa                	mv	a5,a0
  ba:	4685                	li	a3,1
  bc:	9e89                	subw	a3,a3,a0
  be:	00f6853b          	addw	a0,a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	fb7d                	bnez	a4,be <strlen+0x14>
    ;
  return n;
}
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret
  for(n = 0; s[n]; n++)
  d0:	4501                	li	a0,0
  d2:	bfe5                	j	ca <strlen+0x20>

00000000000000d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  da:	ce09                	beqz	a2,f4 <memset+0x20>
  dc:	87aa                	mv	a5,a0
  de:	fff6071b          	addiw	a4,a2,-1
  e2:	1702                	slli	a4,a4,0x20
  e4:	9301                	srli	a4,a4,0x20
  e6:	0705                	addi	a4,a4,1
  e8:	972a                	add	a4,a4,a0
    cdst[i] = c;
  ea:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ee:	0785                	addi	a5,a5,1
  f0:	fee79de3          	bne	a5,a4,ea <memset+0x16>
  }
  return dst;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e422                	sd	s0,8(sp)
  fe:	0800                	addi	s0,sp,16
  for(; *s; s++)
 100:	00054783          	lbu	a5,0(a0)
 104:	cb99                	beqz	a5,11a <strchr+0x20>
    if(*s == c)
 106:	00f58763          	beq	a1,a5,114 <strchr+0x1a>
  for(; *s; s++)
 10a:	0505                	addi	a0,a0,1
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbfd                	bnez	a5,106 <strchr+0xc>
      return (char*)s;
  return 0;
 112:	4501                	li	a0,0
}
 114:	6422                	ld	s0,8(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret
  return 0;
 11a:	4501                	li	a0,0
 11c:	bfe5                	j	114 <strchr+0x1a>

000000000000011e <gets>:

char*
gets(char *buf, int max)
{
 11e:	711d                	addi	sp,sp,-96
 120:	ec86                	sd	ra,88(sp)
 122:	e8a2                	sd	s0,80(sp)
 124:	e4a6                	sd	s1,72(sp)
 126:	e0ca                	sd	s2,64(sp)
 128:	fc4e                	sd	s3,56(sp)
 12a:	f852                	sd	s4,48(sp)
 12c:	f456                	sd	s5,40(sp)
 12e:	f05a                	sd	s6,32(sp)
 130:	ec5e                	sd	s7,24(sp)
 132:	1080                	addi	s0,sp,96
 134:	8baa                	mv	s7,a0
 136:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 138:	892a                	mv	s2,a0
 13a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13c:	4aa9                	li	s5,10
 13e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 140:	89a6                	mv	s3,s1
 142:	2485                	addiw	s1,s1,1
 144:	0344d663          	bge	s1,s4,170 <gets+0x52>
    cc = read(0, &c, 1);
 148:	4605                	li	a2,1
 14a:	faf40593          	addi	a1,s0,-81
 14e:	4501                	li	a0,0
 150:	1b8000ef          	jal	ra,308 <read>
    if(cc < 1)
 154:	00a05e63          	blez	a0,170 <gets+0x52>
    buf[i++] = c;
 158:	faf44783          	lbu	a5,-81(s0)
 15c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 160:	01578763          	beq	a5,s5,16e <gets+0x50>
 164:	0905                	addi	s2,s2,1
 166:	fd679de3          	bne	a5,s6,140 <gets+0x22>
  for(i=0; i+1 < max; ){
 16a:	89a6                	mv	s3,s1
 16c:	a011                	j	170 <gets+0x52>
 16e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 170:	99de                	add	s3,s3,s7
 172:	00098023          	sb	zero,0(s3)
  return buf;
}
 176:	855e                	mv	a0,s7
 178:	60e6                	ld	ra,88(sp)
 17a:	6446                	ld	s0,80(sp)
 17c:	64a6                	ld	s1,72(sp)
 17e:	6906                	ld	s2,64(sp)
 180:	79e2                	ld	s3,56(sp)
 182:	7a42                	ld	s4,48(sp)
 184:	7aa2                	ld	s5,40(sp)
 186:	7b02                	ld	s6,32(sp)
 188:	6be2                	ld	s7,24(sp)
 18a:	6125                	addi	sp,sp,96
 18c:	8082                	ret

000000000000018e <stat>:

int
stat(const char *n, struct stat *st)
{
 18e:	1101                	addi	sp,sp,-32
 190:	ec06                	sd	ra,24(sp)
 192:	e822                	sd	s0,16(sp)
 194:	e426                	sd	s1,8(sp)
 196:	e04a                	sd	s2,0(sp)
 198:	1000                	addi	s0,sp,32
 19a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19c:	4581                	li	a1,0
 19e:	192000ef          	jal	ra,330 <open>
  if(fd < 0)
 1a2:	02054163          	bltz	a0,1c4 <stat+0x36>
 1a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a8:	85ca                	mv	a1,s2
 1aa:	19e000ef          	jal	ra,348 <fstat>
 1ae:	892a                	mv	s2,a0
  close(fd);
 1b0:	8526                	mv	a0,s1
 1b2:	166000ef          	jal	ra,318 <close>
  return r;
}
 1b6:	854a                	mv	a0,s2
 1b8:	60e2                	ld	ra,24(sp)
 1ba:	6442                	ld	s0,16(sp)
 1bc:	64a2                	ld	s1,8(sp)
 1be:	6902                	ld	s2,0(sp)
 1c0:	6105                	addi	sp,sp,32
 1c2:	8082                	ret
    return -1;
 1c4:	597d                	li	s2,-1
 1c6:	bfc5                	j	1b6 <stat+0x28>

00000000000001c8 <atoi>:

int
atoi(const char *s)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ce:	00054603          	lbu	a2,0(a0)
 1d2:	fd06079b          	addiw	a5,a2,-48
 1d6:	0ff7f793          	andi	a5,a5,255
 1da:	4725                	li	a4,9
 1dc:	02f76963          	bltu	a4,a5,20e <atoi+0x46>
 1e0:	86aa                	mv	a3,a0
  n = 0;
 1e2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1e4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1e6:	0685                	addi	a3,a3,1
 1e8:	0025179b          	slliw	a5,a0,0x2
 1ec:	9fa9                	addw	a5,a5,a0
 1ee:	0017979b          	slliw	a5,a5,0x1
 1f2:	9fb1                	addw	a5,a5,a2
 1f4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f8:	0006c603          	lbu	a2,0(a3)
 1fc:	fd06071b          	addiw	a4,a2,-48
 200:	0ff77713          	andi	a4,a4,255
 204:	fee5f1e3          	bgeu	a1,a4,1e6 <atoi+0x1e>
  return n;
}
 208:	6422                	ld	s0,8(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret
  n = 0;
 20e:	4501                	li	a0,0
 210:	bfe5                	j	208 <atoi+0x40>

0000000000000212 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 218:	02b57663          	bgeu	a0,a1,244 <memmove+0x32>
    while(n-- > 0)
 21c:	02c05163          	blez	a2,23e <memmove+0x2c>
 220:	fff6079b          	addiw	a5,a2,-1
 224:	1782                	slli	a5,a5,0x20
 226:	9381                	srli	a5,a5,0x20
 228:	0785                	addi	a5,a5,1
 22a:	97aa                	add	a5,a5,a0
  dst = vdst;
 22c:	872a                	mv	a4,a0
      *dst++ = *src++;
 22e:	0585                	addi	a1,a1,1
 230:	0705                	addi	a4,a4,1
 232:	fff5c683          	lbu	a3,-1(a1)
 236:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 23a:	fee79ae3          	bne	a5,a4,22e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret
    dst += n;
 244:	00c50733          	add	a4,a0,a2
    src += n;
 248:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 24a:	fec05ae3          	blez	a2,23e <memmove+0x2c>
 24e:	fff6079b          	addiw	a5,a2,-1
 252:	1782                	slli	a5,a5,0x20
 254:	9381                	srli	a5,a5,0x20
 256:	fff7c793          	not	a5,a5
 25a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 25c:	15fd                	addi	a1,a1,-1
 25e:	177d                	addi	a4,a4,-1
 260:	0005c683          	lbu	a3,0(a1)
 264:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 268:	fee79ae3          	bne	a5,a4,25c <memmove+0x4a>
 26c:	bfc9                	j	23e <memmove+0x2c>

000000000000026e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 274:	ca05                	beqz	a2,2a4 <memcmp+0x36>
 276:	fff6069b          	addiw	a3,a2,-1
 27a:	1682                	slli	a3,a3,0x20
 27c:	9281                	srli	a3,a3,0x20
 27e:	0685                	addi	a3,a3,1
 280:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 282:	00054783          	lbu	a5,0(a0)
 286:	0005c703          	lbu	a4,0(a1)
 28a:	00e79863          	bne	a5,a4,29a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 28e:	0505                	addi	a0,a0,1
    p2++;
 290:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 292:	fed518e3          	bne	a0,a3,282 <memcmp+0x14>
  }
  return 0;
 296:	4501                	li	a0,0
 298:	a019                	j	29e <memcmp+0x30>
      return *p1 - *p2;
 29a:	40e7853b          	subw	a0,a5,a4
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  return 0;
 2a4:	4501                	li	a0,0
 2a6:	bfe5                	j	29e <memcmp+0x30>

00000000000002a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2b0:	f63ff0ef          	jal	ra,212 <memmove>
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <sbrk>:

char *
sbrk(int n) {
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2c4:	4585                	li	a1,1
 2c6:	0b2000ef          	jal	ra,378 <sys_sbrk>
}
 2ca:	60a2                	ld	ra,8(sp)
 2cc:	6402                	ld	s0,0(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret

00000000000002d2 <sbrklazy>:

char *
sbrklazy(int n) {
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2da:	4589                	li	a1,2
 2dc:	09c000ef          	jal	ra,378 <sys_sbrk>
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e8:	4885                	li	a7,1
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2f0:	4889                	li	a7,2
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f8:	488d                	li	a7,3
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 300:	4891                	li	a7,4
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <read>:
.global read
read:
 li a7, SYS_read
 308:	4895                	li	a7,5
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <write>:
.global write
write:
 li a7, SYS_write
 310:	48c1                	li	a7,16
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <close>:
.global close
close:
 li a7, SYS_close
 318:	48d5                	li	a7,21
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <kill>:
.global kill
kill:
 li a7, SYS_kill
 320:	4899                	li	a7,6
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <exec>:
.global exec
exec:
 li a7, SYS_exec
 328:	489d                	li	a7,7
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <open>:
.global open
open:
 li a7, SYS_open
 330:	48bd                	li	a7,15
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 338:	48c5                	li	a7,17
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 340:	48c9                	li	a7,18
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 348:	48a1                	li	a7,8
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <link>:
.global link
link:
 li a7, SYS_link
 350:	48cd                	li	a7,19
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 358:	48d1                	li	a7,20
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 360:	48a5                	li	a7,9
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <dup>:
.global dup
dup:
 li a7, SYS_dup
 368:	48a9                	li	a7,10
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 370:	48ad                	li	a7,11
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 378:	48b1                	li	a7,12
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <pause>:
.global pause
pause:
 li a7, SYS_pause
 380:	48b5                	li	a7,13
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 388:	48b9                	li	a7,14
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 390:	1101                	addi	sp,sp,-32
 392:	ec06                	sd	ra,24(sp)
 394:	e822                	sd	s0,16(sp)
 396:	1000                	addi	s0,sp,32
 398:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 39c:	4605                	li	a2,1
 39e:	fef40593          	addi	a1,s0,-17
 3a2:	f6fff0ef          	jal	ra,310 <write>
}
 3a6:	60e2                	ld	ra,24(sp)
 3a8:	6442                	ld	s0,16(sp)
 3aa:	6105                	addi	sp,sp,32
 3ac:	8082                	ret

00000000000003ae <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ae:	715d                	addi	sp,sp,-80
 3b0:	e486                	sd	ra,72(sp)
 3b2:	e0a2                	sd	s0,64(sp)
 3b4:	fc26                	sd	s1,56(sp)
 3b6:	f84a                	sd	s2,48(sp)
 3b8:	f44e                	sd	s3,40(sp)
 3ba:	0880                	addi	s0,sp,80
 3bc:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3be:	c299                	beqz	a3,3c4 <printint+0x16>
 3c0:	0805c663          	bltz	a1,44c <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c4:	2581                	sext.w	a1,a1
  neg = 0;
 3c6:	4881                	li	a7,0
 3c8:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3cc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ce:	2601                	sext.w	a2,a2
 3d0:	00000517          	auipc	a0,0x0
 3d4:	50050513          	addi	a0,a0,1280 # 8d0 <digits>
 3d8:	883a                	mv	a6,a4
 3da:	2705                	addiw	a4,a4,1
 3dc:	02c5f7bb          	remuw	a5,a1,a2
 3e0:	1782                	slli	a5,a5,0x20
 3e2:	9381                	srli	a5,a5,0x20
 3e4:	97aa                	add	a5,a5,a0
 3e6:	0007c783          	lbu	a5,0(a5)
 3ea:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ee:	0005879b          	sext.w	a5,a1
 3f2:	02c5d5bb          	divuw	a1,a1,a2
 3f6:	0685                	addi	a3,a3,1
 3f8:	fec7f0e3          	bgeu	a5,a2,3d8 <printint+0x2a>
  if(neg)
 3fc:	00088b63          	beqz	a7,412 <printint+0x64>
    buf[i++] = '-';
 400:	fd040793          	addi	a5,s0,-48
 404:	973e                	add	a4,a4,a5
 406:	02d00793          	li	a5,45
 40a:	fef70423          	sb	a5,-24(a4)
 40e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 412:	02e05663          	blez	a4,43e <printint+0x90>
 416:	fb840793          	addi	a5,s0,-72
 41a:	00e78933          	add	s2,a5,a4
 41e:	fff78993          	addi	s3,a5,-1
 422:	99ba                	add	s3,s3,a4
 424:	377d                	addiw	a4,a4,-1
 426:	1702                	slli	a4,a4,0x20
 428:	9301                	srli	a4,a4,0x20
 42a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 42e:	fff94583          	lbu	a1,-1(s2)
 432:	8526                	mv	a0,s1
 434:	f5dff0ef          	jal	ra,390 <putc>
  while(--i >= 0)
 438:	197d                	addi	s2,s2,-1
 43a:	ff391ae3          	bne	s2,s3,42e <printint+0x80>
}
 43e:	60a6                	ld	ra,72(sp)
 440:	6406                	ld	s0,64(sp)
 442:	74e2                	ld	s1,56(sp)
 444:	7942                	ld	s2,48(sp)
 446:	79a2                	ld	s3,40(sp)
 448:	6161                	addi	sp,sp,80
 44a:	8082                	ret
    x = -xx;
 44c:	40b005bb          	negw	a1,a1
    neg = 1;
 450:	4885                	li	a7,1
    x = -xx;
 452:	bf9d                	j	3c8 <printint+0x1a>

0000000000000454 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 454:	7119                	addi	sp,sp,-128
 456:	fc86                	sd	ra,120(sp)
 458:	f8a2                	sd	s0,112(sp)
 45a:	f4a6                	sd	s1,104(sp)
 45c:	f0ca                	sd	s2,96(sp)
 45e:	ecce                	sd	s3,88(sp)
 460:	e8d2                	sd	s4,80(sp)
 462:	e4d6                	sd	s5,72(sp)
 464:	e0da                	sd	s6,64(sp)
 466:	fc5e                	sd	s7,56(sp)
 468:	f862                	sd	s8,48(sp)
 46a:	f466                	sd	s9,40(sp)
 46c:	f06a                	sd	s10,32(sp)
 46e:	ec6e                	sd	s11,24(sp)
 470:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 472:	0005c903          	lbu	s2,0(a1)
 476:	24090c63          	beqz	s2,6ce <vprintf+0x27a>
 47a:	8b2a                	mv	s6,a0
 47c:	8a2e                	mv	s4,a1
 47e:	8bb2                	mv	s7,a2
  state = 0;
 480:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 482:	4481                	li	s1,0
 484:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 486:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 48a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 48e:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 492:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 496:	00000c97          	auipc	s9,0x0
 49a:	43ac8c93          	addi	s9,s9,1082 # 8d0 <digits>
 49e:	a005                	j	4be <vprintf+0x6a>
        putc(fd, c0);
 4a0:	85ca                	mv	a1,s2
 4a2:	855a                	mv	a0,s6
 4a4:	eedff0ef          	jal	ra,390 <putc>
 4a8:	a019                	j	4ae <vprintf+0x5a>
    } else if(state == '%'){
 4aa:	03598263          	beq	s3,s5,4ce <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4ae:	2485                	addiw	s1,s1,1
 4b0:	8726                	mv	a4,s1
 4b2:	009a07b3          	add	a5,s4,s1
 4b6:	0007c903          	lbu	s2,0(a5)
 4ba:	20090a63          	beqz	s2,6ce <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 4be:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4c2:	fe0994e3          	bnez	s3,4aa <vprintf+0x56>
      if(c0 == '%'){
 4c6:	fd579de3          	bne	a5,s5,4a0 <vprintf+0x4c>
        state = '%';
 4ca:	89be                	mv	s3,a5
 4cc:	b7cd                	j	4ae <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ce:	c3c1                	beqz	a5,54e <vprintf+0xfa>
 4d0:	00ea06b3          	add	a3,s4,a4
 4d4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4d8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4da:	c681                	beqz	a3,4e2 <vprintf+0x8e>
 4dc:	9752                	add	a4,a4,s4
 4de:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4e2:	03878e63          	beq	a5,s8,51e <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 4e6:	05a78863          	beq	a5,s10,536 <vprintf+0xe2>
      } else if(c0 == 'u'){
 4ea:	0db78b63          	beq	a5,s11,5c0 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4ee:	07800713          	li	a4,120
 4f2:	10e78d63          	beq	a5,a4,60c <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4f6:	07000713          	li	a4,112
 4fa:	14e78263          	beq	a5,a4,63e <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 4fe:	06300713          	li	a4,99
 502:	16e78f63          	beq	a5,a4,680 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 506:	07300713          	li	a4,115
 50a:	18e78563          	beq	a5,a4,694 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 50e:	05579063          	bne	a5,s5,54e <vprintf+0xfa>
        putc(fd, '%');
 512:	85d6                	mv	a1,s5
 514:	855a                	mv	a0,s6
 516:	e7bff0ef          	jal	ra,390 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 51a:	4981                	li	s3,0
 51c:	bf49                	j	4ae <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 51e:	008b8913          	addi	s2,s7,8
 522:	4685                	li	a3,1
 524:	4629                	li	a2,10
 526:	000ba583          	lw	a1,0(s7)
 52a:	855a                	mv	a0,s6
 52c:	e83ff0ef          	jal	ra,3ae <printint>
 530:	8bca                	mv	s7,s2
      state = 0;
 532:	4981                	li	s3,0
 534:	bfad                	j	4ae <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 536:	03868663          	beq	a3,s8,562 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 53a:	05a68163          	beq	a3,s10,57c <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 53e:	09b68d63          	beq	a3,s11,5d8 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 542:	03a68f63          	beq	a3,s10,580 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 546:	07800793          	li	a5,120
 54a:	0cf68d63          	beq	a3,a5,624 <vprintf+0x1d0>
        putc(fd, '%');
 54e:	85d6                	mv	a1,s5
 550:	855a                	mv	a0,s6
 552:	e3fff0ef          	jal	ra,390 <putc>
        putc(fd, c0);
 556:	85ca                	mv	a1,s2
 558:	855a                	mv	a0,s6
 55a:	e37ff0ef          	jal	ra,390 <putc>
      state = 0;
 55e:	4981                	li	s3,0
 560:	b7b9                	j	4ae <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 562:	008b8913          	addi	s2,s7,8
 566:	4685                	li	a3,1
 568:	4629                	li	a2,10
 56a:	000bb583          	ld	a1,0(s7)
 56e:	855a                	mv	a0,s6
 570:	e3fff0ef          	jal	ra,3ae <printint>
        i += 1;
 574:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 576:	8bca                	mv	s7,s2
      state = 0;
 578:	4981                	li	s3,0
        i += 1;
 57a:	bf15                	j	4ae <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 57c:	03860563          	beq	a2,s8,5a6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 580:	07b60963          	beq	a2,s11,5f2 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 584:	07800793          	li	a5,120
 588:	fcf613e3          	bne	a2,a5,54e <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 58c:	008b8913          	addi	s2,s7,8
 590:	4681                	li	a3,0
 592:	4641                	li	a2,16
 594:	000bb583          	ld	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	e15ff0ef          	jal	ra,3ae <printint>
        i += 2;
 59e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a0:	8bca                	mv	s7,s2
      state = 0;
 5a2:	4981                	li	s3,0
        i += 2;
 5a4:	b729                	j	4ae <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a6:	008b8913          	addi	s2,s7,8
 5aa:	4685                	li	a3,1
 5ac:	4629                	li	a2,10
 5ae:	000bb583          	ld	a1,0(s7)
 5b2:	855a                	mv	a0,s6
 5b4:	dfbff0ef          	jal	ra,3ae <printint>
        i += 2;
 5b8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ba:	8bca                	mv	s7,s2
      state = 0;
 5bc:	4981                	li	s3,0
        i += 2;
 5be:	bdc5                	j	4ae <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5c0:	008b8913          	addi	s2,s7,8
 5c4:	4681                	li	a3,0
 5c6:	4629                	li	a2,10
 5c8:	000be583          	lwu	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	de1ff0ef          	jal	ra,3ae <printint>
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	bde1                	j	4ae <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d8:	008b8913          	addi	s2,s7,8
 5dc:	4681                	li	a3,0
 5de:	4629                	li	a2,10
 5e0:	000bb583          	ld	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	dc9ff0ef          	jal	ra,3ae <printint>
        i += 1;
 5ea:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ec:	8bca                	mv	s7,s2
      state = 0;
 5ee:	4981                	li	s3,0
        i += 1;
 5f0:	bd7d                	j	4ae <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f2:	008b8913          	addi	s2,s7,8
 5f6:	4681                	li	a3,0
 5f8:	4629                	li	a2,10
 5fa:	000bb583          	ld	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	dafff0ef          	jal	ra,3ae <printint>
        i += 2;
 604:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 606:	8bca                	mv	s7,s2
      state = 0;
 608:	4981                	li	s3,0
        i += 2;
 60a:	b555                	j	4ae <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 60c:	008b8913          	addi	s2,s7,8
 610:	4681                	li	a3,0
 612:	4641                	li	a2,16
 614:	000be583          	lwu	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	d95ff0ef          	jal	ra,3ae <printint>
 61e:	8bca                	mv	s7,s2
      state = 0;
 620:	4981                	li	s3,0
 622:	b571                	j	4ae <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 624:	008b8913          	addi	s2,s7,8
 628:	4681                	li	a3,0
 62a:	4641                	li	a2,16
 62c:	000bb583          	ld	a1,0(s7)
 630:	855a                	mv	a0,s6
 632:	d7dff0ef          	jal	ra,3ae <printint>
        i += 1;
 636:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 638:	8bca                	mv	s7,s2
      state = 0;
 63a:	4981                	li	s3,0
        i += 1;
 63c:	bd8d                	j	4ae <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 63e:	008b8793          	addi	a5,s7,8
 642:	f8f43423          	sd	a5,-120(s0)
 646:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 64a:	03000593          	li	a1,48
 64e:	855a                	mv	a0,s6
 650:	d41ff0ef          	jal	ra,390 <putc>
  putc(fd, 'x');
 654:	07800593          	li	a1,120
 658:	855a                	mv	a0,s6
 65a:	d37ff0ef          	jal	ra,390 <putc>
 65e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 660:	03c9d793          	srli	a5,s3,0x3c
 664:	97e6                	add	a5,a5,s9
 666:	0007c583          	lbu	a1,0(a5)
 66a:	855a                	mv	a0,s6
 66c:	d25ff0ef          	jal	ra,390 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 670:	0992                	slli	s3,s3,0x4
 672:	397d                	addiw	s2,s2,-1
 674:	fe0916e3          	bnez	s2,660 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 678:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bd05                	j	4ae <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 680:	008b8913          	addi	s2,s7,8
 684:	000bc583          	lbu	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	d07ff0ef          	jal	ra,390 <putc>
 68e:	8bca                	mv	s7,s2
      state = 0;
 690:	4981                	li	s3,0
 692:	bd31                	j	4ae <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 694:	008b8993          	addi	s3,s7,8
 698:	000bb903          	ld	s2,0(s7)
 69c:	00090f63          	beqz	s2,6ba <vprintf+0x266>
        for(; *s; s++)
 6a0:	00094583          	lbu	a1,0(s2)
 6a4:	c195                	beqz	a1,6c8 <vprintf+0x274>
          putc(fd, *s);
 6a6:	855a                	mv	a0,s6
 6a8:	ce9ff0ef          	jal	ra,390 <putc>
        for(; *s; s++)
 6ac:	0905                	addi	s2,s2,1
 6ae:	00094583          	lbu	a1,0(s2)
 6b2:	f9f5                	bnez	a1,6a6 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6b4:	8bce                	mv	s7,s3
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	bbdd                	j	4ae <vprintf+0x5a>
          s = "(null)";
 6ba:	00000917          	auipc	s2,0x0
 6be:	20e90913          	addi	s2,s2,526 # 8c8 <malloc+0xf8>
        for(; *s; s++)
 6c2:	02800593          	li	a1,40
 6c6:	b7c5                	j	6a6 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6c8:	8bce                	mv	s7,s3
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	b3cd                	j	4ae <vprintf+0x5a>
    }
  }
}
 6ce:	70e6                	ld	ra,120(sp)
 6d0:	7446                	ld	s0,112(sp)
 6d2:	74a6                	ld	s1,104(sp)
 6d4:	7906                	ld	s2,96(sp)
 6d6:	69e6                	ld	s3,88(sp)
 6d8:	6a46                	ld	s4,80(sp)
 6da:	6aa6                	ld	s5,72(sp)
 6dc:	6b06                	ld	s6,64(sp)
 6de:	7be2                	ld	s7,56(sp)
 6e0:	7c42                	ld	s8,48(sp)
 6e2:	7ca2                	ld	s9,40(sp)
 6e4:	7d02                	ld	s10,32(sp)
 6e6:	6de2                	ld	s11,24(sp)
 6e8:	6109                	addi	sp,sp,128
 6ea:	8082                	ret

00000000000006ec <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ec:	715d                	addi	sp,sp,-80
 6ee:	ec06                	sd	ra,24(sp)
 6f0:	e822                	sd	s0,16(sp)
 6f2:	1000                	addi	s0,sp,32
 6f4:	e010                	sd	a2,0(s0)
 6f6:	e414                	sd	a3,8(s0)
 6f8:	e818                	sd	a4,16(s0)
 6fa:	ec1c                	sd	a5,24(s0)
 6fc:	03043023          	sd	a6,32(s0)
 700:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 704:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 708:	8622                	mv	a2,s0
 70a:	d4bff0ef          	jal	ra,454 <vprintf>
}
 70e:	60e2                	ld	ra,24(sp)
 710:	6442                	ld	s0,16(sp)
 712:	6161                	addi	sp,sp,80
 714:	8082                	ret

0000000000000716 <printf>:

void
printf(const char *fmt, ...)
{
 716:	711d                	addi	sp,sp,-96
 718:	ec06                	sd	ra,24(sp)
 71a:	e822                	sd	s0,16(sp)
 71c:	1000                	addi	s0,sp,32
 71e:	e40c                	sd	a1,8(s0)
 720:	e810                	sd	a2,16(s0)
 722:	ec14                	sd	a3,24(s0)
 724:	f018                	sd	a4,32(s0)
 726:	f41c                	sd	a5,40(s0)
 728:	03043823          	sd	a6,48(s0)
 72c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 730:	00840613          	addi	a2,s0,8
 734:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 738:	85aa                	mv	a1,a0
 73a:	4505                	li	a0,1
 73c:	d19ff0ef          	jal	ra,454 <vprintf>
}
 740:	60e2                	ld	ra,24(sp)
 742:	6442                	ld	s0,16(sp)
 744:	6125                	addi	sp,sp,96
 746:	8082                	ret

0000000000000748 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 748:	1141                	addi	sp,sp,-16
 74a:	e422                	sd	s0,8(sp)
 74c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 74e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 752:	00001797          	auipc	a5,0x1
 756:	8ae7b783          	ld	a5,-1874(a5) # 1000 <freep>
 75a:	a805                	j	78a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 75c:	4618                	lw	a4,8(a2)
 75e:	9db9                	addw	a1,a1,a4
 760:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 764:	6398                	ld	a4,0(a5)
 766:	6318                	ld	a4,0(a4)
 768:	fee53823          	sd	a4,-16(a0)
 76c:	a091                	j	7b0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 76e:	ff852703          	lw	a4,-8(a0)
 772:	9e39                	addw	a2,a2,a4
 774:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 776:	ff053703          	ld	a4,-16(a0)
 77a:	e398                	sd	a4,0(a5)
 77c:	a099                	j	7c2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77e:	6398                	ld	a4,0(a5)
 780:	00e7e463          	bltu	a5,a4,788 <free+0x40>
 784:	00e6ea63          	bltu	a3,a4,798 <free+0x50>
{
 788:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78a:	fed7fae3          	bgeu	a5,a3,77e <free+0x36>
 78e:	6398                	ld	a4,0(a5)
 790:	00e6e463          	bltu	a3,a4,798 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 794:	fee7eae3          	bltu	a5,a4,788 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 798:	ff852583          	lw	a1,-8(a0)
 79c:	6390                	ld	a2,0(a5)
 79e:	02059713          	slli	a4,a1,0x20
 7a2:	9301                	srli	a4,a4,0x20
 7a4:	0712                	slli	a4,a4,0x4
 7a6:	9736                	add	a4,a4,a3
 7a8:	fae60ae3          	beq	a2,a4,75c <free+0x14>
    bp->s.ptr = p->s.ptr;
 7ac:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b0:	4790                	lw	a2,8(a5)
 7b2:	02061713          	slli	a4,a2,0x20
 7b6:	9301                	srli	a4,a4,0x20
 7b8:	0712                	slli	a4,a4,0x4
 7ba:	973e                	add	a4,a4,a5
 7bc:	fae689e3          	beq	a3,a4,76e <free+0x26>
  } else
    p->s.ptr = bp;
 7c0:	e394                	sd	a3,0(a5)
  freep = p;
 7c2:	00001717          	auipc	a4,0x1
 7c6:	82f73f23          	sd	a5,-1986(a4) # 1000 <freep>
}
 7ca:	6422                	ld	s0,8(sp)
 7cc:	0141                	addi	sp,sp,16
 7ce:	8082                	ret

00000000000007d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d0:	7139                	addi	sp,sp,-64
 7d2:	fc06                	sd	ra,56(sp)
 7d4:	f822                	sd	s0,48(sp)
 7d6:	f426                	sd	s1,40(sp)
 7d8:	f04a                	sd	s2,32(sp)
 7da:	ec4e                	sd	s3,24(sp)
 7dc:	e852                	sd	s4,16(sp)
 7de:	e456                	sd	s5,8(sp)
 7e0:	e05a                	sd	s6,0(sp)
 7e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e4:	02051493          	slli	s1,a0,0x20
 7e8:	9081                	srli	s1,s1,0x20
 7ea:	04bd                	addi	s1,s1,15
 7ec:	8091                	srli	s1,s1,0x4
 7ee:	0014899b          	addiw	s3,s1,1
 7f2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7f4:	00001517          	auipc	a0,0x1
 7f8:	80c53503          	ld	a0,-2036(a0) # 1000 <freep>
 7fc:	c515                	beqz	a0,828 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 800:	4798                	lw	a4,8(a5)
 802:	02977f63          	bgeu	a4,s1,840 <malloc+0x70>
 806:	8a4e                	mv	s4,s3
 808:	0009871b          	sext.w	a4,s3
 80c:	6685                	lui	a3,0x1
 80e:	00d77363          	bgeu	a4,a3,814 <malloc+0x44>
 812:	6a05                	lui	s4,0x1
 814:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 818:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 81c:	00000917          	auipc	s2,0x0
 820:	7e490913          	addi	s2,s2,2020 # 1000 <freep>
  if(p == SBRK_ERROR)
 824:	5afd                	li	s5,-1
 826:	a0bd                	j	894 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 828:	00000797          	auipc	a5,0x0
 82c:	7e878793          	addi	a5,a5,2024 # 1010 <base>
 830:	00000717          	auipc	a4,0x0
 834:	7cf73823          	sd	a5,2000(a4) # 1000 <freep>
 838:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 83a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 83e:	b7e1                	j	806 <malloc+0x36>
      if(p->s.size == nunits)
 840:	02e48b63          	beq	s1,a4,876 <malloc+0xa6>
        p->s.size -= nunits;
 844:	4137073b          	subw	a4,a4,s3
 848:	c798                	sw	a4,8(a5)
        p += p->s.size;
 84a:	1702                	slli	a4,a4,0x20
 84c:	9301                	srli	a4,a4,0x20
 84e:	0712                	slli	a4,a4,0x4
 850:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 852:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 856:	00000717          	auipc	a4,0x0
 85a:	7aa73523          	sd	a0,1962(a4) # 1000 <freep>
      return (void*)(p + 1);
 85e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 862:	70e2                	ld	ra,56(sp)
 864:	7442                	ld	s0,48(sp)
 866:	74a2                	ld	s1,40(sp)
 868:	7902                	ld	s2,32(sp)
 86a:	69e2                	ld	s3,24(sp)
 86c:	6a42                	ld	s4,16(sp)
 86e:	6aa2                	ld	s5,8(sp)
 870:	6b02                	ld	s6,0(sp)
 872:	6121                	addi	sp,sp,64
 874:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 876:	6398                	ld	a4,0(a5)
 878:	e118                	sd	a4,0(a0)
 87a:	bff1                	j	856 <malloc+0x86>
  hp->s.size = nu;
 87c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 880:	0541                	addi	a0,a0,16
 882:	ec7ff0ef          	jal	ra,748 <free>
  return freep;
 886:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 88a:	dd61                	beqz	a0,862 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 88e:	4798                	lw	a4,8(a5)
 890:	fa9778e3          	bgeu	a4,s1,840 <malloc+0x70>
    if(p == freep)
 894:	00093703          	ld	a4,0(s2)
 898:	853e                	mv	a0,a5
 89a:	fef719e3          	bne	a4,a5,88c <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 89e:	8552                	mv	a0,s4
 8a0:	a1dff0ef          	jal	ra,2bc <sbrk>
  if(p == SBRK_ERROR)
 8a4:	fd551ce3          	bne	a0,s5,87c <malloc+0xac>
        return 0;
 8a8:	4501                	li	a0,0
 8aa:	bf65                	j	862 <malloc+0x92>
