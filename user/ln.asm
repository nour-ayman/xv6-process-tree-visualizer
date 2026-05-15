
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  if(argc != 3){
   a:	478d                	li	a5,3
   c:	00f50c63          	beq	a0,a5,24 <main+0x24>
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	8a058593          	addi	a1,a1,-1888 # 8b0 <malloc+0xdc>
  18:	4509                	li	a0,2
  1a:	6d6000ef          	jal	ra,6f0 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2cc000ef          	jal	ra,2ec <exit>
  24:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  26:	698c                	ld	a1,16(a1)
  28:	6488                	ld	a0,8(s1)
  2a:	322000ef          	jal	ra,34c <link>
  2e:	00054563          	bltz	a0,38 <main+0x38>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  32:	4501                	li	a0,0
  34:	2b8000ef          	jal	ra,2ec <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  38:	6894                	ld	a3,16(s1)
  3a:	6490                	ld	a2,8(s1)
  3c:	00001597          	auipc	a1,0x1
  40:	88c58593          	addi	a1,a1,-1908 # 8c8 <malloc+0xf4>
  44:	4509                	li	a0,2
  46:	6aa000ef          	jal	ra,6f0 <fprintf>
  4a:	b7e5                	j	32 <main+0x32>

000000000000004c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e406                	sd	ra,8(sp)
  50:	e022                	sd	s0,0(sp)
  52:	0800                	addi	s0,sp,16
  extern int main();
  main();
  54:	fadff0ef          	jal	ra,0 <main>
  exit(0);
  58:	4501                	li	a0,0
  5a:	292000ef          	jal	ra,2ec <exit>

000000000000005e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e422                	sd	s0,8(sp)
  62:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  64:	87aa                	mv	a5,a0
  66:	0585                	addi	a1,a1,1
  68:	0785                	addi	a5,a5,1
  6a:	fff5c703          	lbu	a4,-1(a1)
  6e:	fee78fa3          	sb	a4,-1(a5)
  72:	fb75                	bnez	a4,66 <strcpy+0x8>
    ;
  return os;
}
  74:	6422                	ld	s0,8(sp)
  76:	0141                	addi	sp,sp,16
  78:	8082                	ret

000000000000007a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e422                	sd	s0,8(sp)
  7e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  80:	00054783          	lbu	a5,0(a0)
  84:	cb91                	beqz	a5,98 <strcmp+0x1e>
  86:	0005c703          	lbu	a4,0(a1)
  8a:	00f71763          	bne	a4,a5,98 <strcmp+0x1e>
    p++, q++;
  8e:	0505                	addi	a0,a0,1
  90:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  92:	00054783          	lbu	a5,0(a0)
  96:	fbe5                	bnez	a5,86 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  98:	0005c503          	lbu	a0,0(a1)
}
  9c:	40a7853b          	subw	a0,a5,a0
  a0:	6422                	ld	s0,8(sp)
  a2:	0141                	addi	sp,sp,16
  a4:	8082                	ret

00000000000000a6 <strlen>:

uint
strlen(const char *s)
{
  a6:	1141                	addi	sp,sp,-16
  a8:	e422                	sd	s0,8(sp)
  aa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	cf91                	beqz	a5,cc <strlen+0x26>
  b2:	0505                	addi	a0,a0,1
  b4:	87aa                	mv	a5,a0
  b6:	4685                	li	a3,1
  b8:	9e89                	subw	a3,a3,a0
  ba:	00f6853b          	addw	a0,a3,a5
  be:	0785                	addi	a5,a5,1
  c0:	fff7c703          	lbu	a4,-1(a5)
  c4:	fb7d                	bnez	a4,ba <strlen+0x14>
    ;
  return n;
}
  c6:	6422                	ld	s0,8(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret
  for(n = 0; s[n]; n++)
  cc:	4501                	li	a0,0
  ce:	bfe5                	j	c6 <strlen+0x20>

00000000000000d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e422                	sd	s0,8(sp)
  d4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d6:	ce09                	beqz	a2,f0 <memset+0x20>
  d8:	87aa                	mv	a5,a0
  da:	fff6071b          	addiw	a4,a2,-1
  de:	1702                	slli	a4,a4,0x20
  e0:	9301                	srli	a4,a4,0x20
  e2:	0705                	addi	a4,a4,1
  e4:	972a                	add	a4,a4,a0
    cdst[i] = c;
  e6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ea:	0785                	addi	a5,a5,1
  ec:	fee79de3          	bne	a5,a4,e6 <memset+0x16>
  }
  return dst;
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strchr>:

char*
strchr(const char *s, char c)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  for(; *s; s++)
  fc:	00054783          	lbu	a5,0(a0)
 100:	cb99                	beqz	a5,116 <strchr+0x20>
    if(*s == c)
 102:	00f58763          	beq	a1,a5,110 <strchr+0x1a>
  for(; *s; s++)
 106:	0505                	addi	a0,a0,1
 108:	00054783          	lbu	a5,0(a0)
 10c:	fbfd                	bnez	a5,102 <strchr+0xc>
      return (char*)s;
  return 0;
 10e:	4501                	li	a0,0
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret
  return 0;
 116:	4501                	li	a0,0
 118:	bfe5                	j	110 <strchr+0x1a>

000000000000011a <gets>:

char*
gets(char *buf, int max)
{
 11a:	711d                	addi	sp,sp,-96
 11c:	ec86                	sd	ra,88(sp)
 11e:	e8a2                	sd	s0,80(sp)
 120:	e4a6                	sd	s1,72(sp)
 122:	e0ca                	sd	s2,64(sp)
 124:	fc4e                	sd	s3,56(sp)
 126:	f852                	sd	s4,48(sp)
 128:	f456                	sd	s5,40(sp)
 12a:	f05a                	sd	s6,32(sp)
 12c:	ec5e                	sd	s7,24(sp)
 12e:	1080                	addi	s0,sp,96
 130:	8baa                	mv	s7,a0
 132:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 134:	892a                	mv	s2,a0
 136:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 138:	4aa9                	li	s5,10
 13a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13c:	89a6                	mv	s3,s1
 13e:	2485                	addiw	s1,s1,1
 140:	0344d663          	bge	s1,s4,16c <gets+0x52>
    cc = read(0, &c, 1);
 144:	4605                	li	a2,1
 146:	faf40593          	addi	a1,s0,-81
 14a:	4501                	li	a0,0
 14c:	1b8000ef          	jal	ra,304 <read>
    if(cc < 1)
 150:	00a05e63          	blez	a0,16c <gets+0x52>
    buf[i++] = c;
 154:	faf44783          	lbu	a5,-81(s0)
 158:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15c:	01578763          	beq	a5,s5,16a <gets+0x50>
 160:	0905                	addi	s2,s2,1
 162:	fd679de3          	bne	a5,s6,13c <gets+0x22>
  for(i=0; i+1 < max; ){
 166:	89a6                	mv	s3,s1
 168:	a011                	j	16c <gets+0x52>
 16a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 16c:	99de                	add	s3,s3,s7
 16e:	00098023          	sb	zero,0(s3)
  return buf;
}
 172:	855e                	mv	a0,s7
 174:	60e6                	ld	ra,88(sp)
 176:	6446                	ld	s0,80(sp)
 178:	64a6                	ld	s1,72(sp)
 17a:	6906                	ld	s2,64(sp)
 17c:	79e2                	ld	s3,56(sp)
 17e:	7a42                	ld	s4,48(sp)
 180:	7aa2                	ld	s5,40(sp)
 182:	7b02                	ld	s6,32(sp)
 184:	6be2                	ld	s7,24(sp)
 186:	6125                	addi	sp,sp,96
 188:	8082                	ret

000000000000018a <stat>:

int
stat(const char *n, struct stat *st)
{
 18a:	1101                	addi	sp,sp,-32
 18c:	ec06                	sd	ra,24(sp)
 18e:	e822                	sd	s0,16(sp)
 190:	e426                	sd	s1,8(sp)
 192:	e04a                	sd	s2,0(sp)
 194:	1000                	addi	s0,sp,32
 196:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 198:	4581                	li	a1,0
 19a:	192000ef          	jal	ra,32c <open>
  if(fd < 0)
 19e:	02054163          	bltz	a0,1c0 <stat+0x36>
 1a2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a4:	85ca                	mv	a1,s2
 1a6:	19e000ef          	jal	ra,344 <fstat>
 1aa:	892a                	mv	s2,a0
  close(fd);
 1ac:	8526                	mv	a0,s1
 1ae:	166000ef          	jal	ra,314 <close>
  return r;
}
 1b2:	854a                	mv	a0,s2
 1b4:	60e2                	ld	ra,24(sp)
 1b6:	6442                	ld	s0,16(sp)
 1b8:	64a2                	ld	s1,8(sp)
 1ba:	6902                	ld	s2,0(sp)
 1bc:	6105                	addi	sp,sp,32
 1be:	8082                	ret
    return -1;
 1c0:	597d                	li	s2,-1
 1c2:	bfc5                	j	1b2 <stat+0x28>

00000000000001c4 <atoi>:

int
atoi(const char *s)
{
 1c4:	1141                	addi	sp,sp,-16
 1c6:	e422                	sd	s0,8(sp)
 1c8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ca:	00054603          	lbu	a2,0(a0)
 1ce:	fd06079b          	addiw	a5,a2,-48
 1d2:	0ff7f793          	andi	a5,a5,255
 1d6:	4725                	li	a4,9
 1d8:	02f76963          	bltu	a4,a5,20a <atoi+0x46>
 1dc:	86aa                	mv	a3,a0
  n = 0;
 1de:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1e0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1e2:	0685                	addi	a3,a3,1
 1e4:	0025179b          	slliw	a5,a0,0x2
 1e8:	9fa9                	addw	a5,a5,a0
 1ea:	0017979b          	slliw	a5,a5,0x1
 1ee:	9fb1                	addw	a5,a5,a2
 1f0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f4:	0006c603          	lbu	a2,0(a3)
 1f8:	fd06071b          	addiw	a4,a2,-48
 1fc:	0ff77713          	andi	a4,a4,255
 200:	fee5f1e3          	bgeu	a1,a4,1e2 <atoi+0x1e>
  return n;
}
 204:	6422                	ld	s0,8(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret
  n = 0;
 20a:	4501                	li	a0,0
 20c:	bfe5                	j	204 <atoi+0x40>

000000000000020e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20e:	1141                	addi	sp,sp,-16
 210:	e422                	sd	s0,8(sp)
 212:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 214:	02b57663          	bgeu	a0,a1,240 <memmove+0x32>
    while(n-- > 0)
 218:	02c05163          	blez	a2,23a <memmove+0x2c>
 21c:	fff6079b          	addiw	a5,a2,-1
 220:	1782                	slli	a5,a5,0x20
 222:	9381                	srli	a5,a5,0x20
 224:	0785                	addi	a5,a5,1
 226:	97aa                	add	a5,a5,a0
  dst = vdst;
 228:	872a                	mv	a4,a0
      *dst++ = *src++;
 22a:	0585                	addi	a1,a1,1
 22c:	0705                	addi	a4,a4,1
 22e:	fff5c683          	lbu	a3,-1(a1)
 232:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 236:	fee79ae3          	bne	a5,a4,22a <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 23a:	6422                	ld	s0,8(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret
    dst += n;
 240:	00c50733          	add	a4,a0,a2
    src += n;
 244:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 246:	fec05ae3          	blez	a2,23a <memmove+0x2c>
 24a:	fff6079b          	addiw	a5,a2,-1
 24e:	1782                	slli	a5,a5,0x20
 250:	9381                	srli	a5,a5,0x20
 252:	fff7c793          	not	a5,a5
 256:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 258:	15fd                	addi	a1,a1,-1
 25a:	177d                	addi	a4,a4,-1
 25c:	0005c683          	lbu	a3,0(a1)
 260:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 264:	fee79ae3          	bne	a5,a4,258 <memmove+0x4a>
 268:	bfc9                	j	23a <memmove+0x2c>

000000000000026a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 270:	ca05                	beqz	a2,2a0 <memcmp+0x36>
 272:	fff6069b          	addiw	a3,a2,-1
 276:	1682                	slli	a3,a3,0x20
 278:	9281                	srli	a3,a3,0x20
 27a:	0685                	addi	a3,a3,1
 27c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 27e:	00054783          	lbu	a5,0(a0)
 282:	0005c703          	lbu	a4,0(a1)
 286:	00e79863          	bne	a5,a4,296 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 28a:	0505                	addi	a0,a0,1
    p2++;
 28c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 28e:	fed518e3          	bne	a0,a3,27e <memcmp+0x14>
  }
  return 0;
 292:	4501                	li	a0,0
 294:	a019                	j	29a <memcmp+0x30>
      return *p1 - *p2;
 296:	40e7853b          	subw	a0,a5,a4
}
 29a:	6422                	ld	s0,8(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret
  return 0;
 2a0:	4501                	li	a0,0
 2a2:	bfe5                	j	29a <memcmp+0x30>

00000000000002a4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e406                	sd	ra,8(sp)
 2a8:	e022                	sd	s0,0(sp)
 2aa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ac:	f63ff0ef          	jal	ra,20e <memmove>
}
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret

00000000000002b8 <sbrk>:

char *
sbrk(int n) {
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e406                	sd	ra,8(sp)
 2bc:	e022                	sd	s0,0(sp)
 2be:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2c0:	4585                	li	a1,1
 2c2:	0b2000ef          	jal	ra,374 <sys_sbrk>
}
 2c6:	60a2                	ld	ra,8(sp)
 2c8:	6402                	ld	s0,0(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret

00000000000002ce <sbrklazy>:

char *
sbrklazy(int n) {
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2d6:	4589                	li	a1,2
 2d8:	09c000ef          	jal	ra,374 <sys_sbrk>
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret

00000000000002e4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e4:	4885                	li	a7,1
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ec:	4889                	li	a7,2
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f4:	488d                	li	a7,3
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2fc:	4891                	li	a7,4
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <read>:
.global read
read:
 li a7, SYS_read
 304:	4895                	li	a7,5
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <write>:
.global write
write:
 li a7, SYS_write
 30c:	48c1                	li	a7,16
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <close>:
.global close
close:
 li a7, SYS_close
 314:	48d5                	li	a7,21
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <kill>:
.global kill
kill:
 li a7, SYS_kill
 31c:	4899                	li	a7,6
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <exec>:
.global exec
exec:
 li a7, SYS_exec
 324:	489d                	li	a7,7
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <open>:
.global open
open:
 li a7, SYS_open
 32c:	48bd                	li	a7,15
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 334:	48c5                	li	a7,17
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 33c:	48c9                	li	a7,18
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 344:	48a1                	li	a7,8
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <link>:
.global link
link:
 li a7, SYS_link
 34c:	48cd                	li	a7,19
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 354:	48d1                	li	a7,20
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 35c:	48a5                	li	a7,9
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <dup>:
.global dup
dup:
 li a7, SYS_dup
 364:	48a9                	li	a7,10
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 36c:	48ad                	li	a7,11
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 374:	48b1                	li	a7,12
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <pause>:
.global pause
pause:
 li a7, SYS_pause
 37c:	48b5                	li	a7,13
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 384:	48b9                	li	a7,14
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <getproctree>:
.global getproctree
getproctree:
 li a7, SYS_getproctree
 38c:	48d9                	li	a7,22
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 394:	1101                	addi	sp,sp,-32
 396:	ec06                	sd	ra,24(sp)
 398:	e822                	sd	s0,16(sp)
 39a:	1000                	addi	s0,sp,32
 39c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a0:	4605                	li	a2,1
 3a2:	fef40593          	addi	a1,s0,-17
 3a6:	f67ff0ef          	jal	ra,30c <write>
}
 3aa:	60e2                	ld	ra,24(sp)
 3ac:	6442                	ld	s0,16(sp)
 3ae:	6105                	addi	sp,sp,32
 3b0:	8082                	ret

00000000000003b2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3b2:	715d                	addi	sp,sp,-80
 3b4:	e486                	sd	ra,72(sp)
 3b6:	e0a2                	sd	s0,64(sp)
 3b8:	fc26                	sd	s1,56(sp)
 3ba:	f84a                	sd	s2,48(sp)
 3bc:	f44e                	sd	s3,40(sp)
 3be:	0880                	addi	s0,sp,80
 3c0:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c2:	c299                	beqz	a3,3c8 <printint+0x16>
 3c4:	0805c663          	bltz	a1,450 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c8:	2581                	sext.w	a1,a1
  neg = 0;
 3ca:	4881                	li	a7,0
 3cc:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3d0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d2:	2601                	sext.w	a2,a2
 3d4:	00000517          	auipc	a0,0x0
 3d8:	51450513          	addi	a0,a0,1300 # 8e8 <digits>
 3dc:	883a                	mv	a6,a4
 3de:	2705                	addiw	a4,a4,1
 3e0:	02c5f7bb          	remuw	a5,a1,a2
 3e4:	1782                	slli	a5,a5,0x20
 3e6:	9381                	srli	a5,a5,0x20
 3e8:	97aa                	add	a5,a5,a0
 3ea:	0007c783          	lbu	a5,0(a5)
 3ee:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f2:	0005879b          	sext.w	a5,a1
 3f6:	02c5d5bb          	divuw	a1,a1,a2
 3fa:	0685                	addi	a3,a3,1
 3fc:	fec7f0e3          	bgeu	a5,a2,3dc <printint+0x2a>
  if(neg)
 400:	00088b63          	beqz	a7,416 <printint+0x64>
    buf[i++] = '-';
 404:	fd040793          	addi	a5,s0,-48
 408:	973e                	add	a4,a4,a5
 40a:	02d00793          	li	a5,45
 40e:	fef70423          	sb	a5,-24(a4)
 412:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 416:	02e05663          	blez	a4,442 <printint+0x90>
 41a:	fb840793          	addi	a5,s0,-72
 41e:	00e78933          	add	s2,a5,a4
 422:	fff78993          	addi	s3,a5,-1
 426:	99ba                	add	s3,s3,a4
 428:	377d                	addiw	a4,a4,-1
 42a:	1702                	slli	a4,a4,0x20
 42c:	9301                	srli	a4,a4,0x20
 42e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 432:	fff94583          	lbu	a1,-1(s2)
 436:	8526                	mv	a0,s1
 438:	f5dff0ef          	jal	ra,394 <putc>
  while(--i >= 0)
 43c:	197d                	addi	s2,s2,-1
 43e:	ff391ae3          	bne	s2,s3,432 <printint+0x80>
}
 442:	60a6                	ld	ra,72(sp)
 444:	6406                	ld	s0,64(sp)
 446:	74e2                	ld	s1,56(sp)
 448:	7942                	ld	s2,48(sp)
 44a:	79a2                	ld	s3,40(sp)
 44c:	6161                	addi	sp,sp,80
 44e:	8082                	ret
    x = -xx;
 450:	40b005bb          	negw	a1,a1
    neg = 1;
 454:	4885                	li	a7,1
    x = -xx;
 456:	bf9d                	j	3cc <printint+0x1a>

0000000000000458 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 458:	7119                	addi	sp,sp,-128
 45a:	fc86                	sd	ra,120(sp)
 45c:	f8a2                	sd	s0,112(sp)
 45e:	f4a6                	sd	s1,104(sp)
 460:	f0ca                	sd	s2,96(sp)
 462:	ecce                	sd	s3,88(sp)
 464:	e8d2                	sd	s4,80(sp)
 466:	e4d6                	sd	s5,72(sp)
 468:	e0da                	sd	s6,64(sp)
 46a:	fc5e                	sd	s7,56(sp)
 46c:	f862                	sd	s8,48(sp)
 46e:	f466                	sd	s9,40(sp)
 470:	f06a                	sd	s10,32(sp)
 472:	ec6e                	sd	s11,24(sp)
 474:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 476:	0005c903          	lbu	s2,0(a1)
 47a:	24090c63          	beqz	s2,6d2 <vprintf+0x27a>
 47e:	8b2a                	mv	s6,a0
 480:	8a2e                	mv	s4,a1
 482:	8bb2                	mv	s7,a2
  state = 0;
 484:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 486:	4481                	li	s1,0
 488:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 48a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 48e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 492:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 496:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 49a:	00000c97          	auipc	s9,0x0
 49e:	44ec8c93          	addi	s9,s9,1102 # 8e8 <digits>
 4a2:	a005                	j	4c2 <vprintf+0x6a>
        putc(fd, c0);
 4a4:	85ca                	mv	a1,s2
 4a6:	855a                	mv	a0,s6
 4a8:	eedff0ef          	jal	ra,394 <putc>
 4ac:	a019                	j	4b2 <vprintf+0x5a>
    } else if(state == '%'){
 4ae:	03598263          	beq	s3,s5,4d2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4b2:	2485                	addiw	s1,s1,1
 4b4:	8726                	mv	a4,s1
 4b6:	009a07b3          	add	a5,s4,s1
 4ba:	0007c903          	lbu	s2,0(a5)
 4be:	20090a63          	beqz	s2,6d2 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 4c2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4c6:	fe0994e3          	bnez	s3,4ae <vprintf+0x56>
      if(c0 == '%'){
 4ca:	fd579de3          	bne	a5,s5,4a4 <vprintf+0x4c>
        state = '%';
 4ce:	89be                	mv	s3,a5
 4d0:	b7cd                	j	4b2 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4d2:	c3c1                	beqz	a5,552 <vprintf+0xfa>
 4d4:	00ea06b3          	add	a3,s4,a4
 4d8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4dc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4de:	c681                	beqz	a3,4e6 <vprintf+0x8e>
 4e0:	9752                	add	a4,a4,s4
 4e2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4e6:	03878e63          	beq	a5,s8,522 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 4ea:	05a78863          	beq	a5,s10,53a <vprintf+0xe2>
      } else if(c0 == 'u'){
 4ee:	0db78b63          	beq	a5,s11,5c4 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4f2:	07800713          	li	a4,120
 4f6:	10e78d63          	beq	a5,a4,610 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4fa:	07000713          	li	a4,112
 4fe:	14e78263          	beq	a5,a4,642 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 502:	06300713          	li	a4,99
 506:	16e78f63          	beq	a5,a4,684 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 50a:	07300713          	li	a4,115
 50e:	18e78563          	beq	a5,a4,698 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 512:	05579063          	bne	a5,s5,552 <vprintf+0xfa>
        putc(fd, '%');
 516:	85d6                	mv	a1,s5
 518:	855a                	mv	a0,s6
 51a:	e7bff0ef          	jal	ra,394 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 51e:	4981                	li	s3,0
 520:	bf49                	j	4b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 522:	008b8913          	addi	s2,s7,8
 526:	4685                	li	a3,1
 528:	4629                	li	a2,10
 52a:	000ba583          	lw	a1,0(s7)
 52e:	855a                	mv	a0,s6
 530:	e83ff0ef          	jal	ra,3b2 <printint>
 534:	8bca                	mv	s7,s2
      state = 0;
 536:	4981                	li	s3,0
 538:	bfad                	j	4b2 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 53a:	03868663          	beq	a3,s8,566 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 53e:	05a68163          	beq	a3,s10,580 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 542:	09b68d63          	beq	a3,s11,5dc <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 546:	03a68f63          	beq	a3,s10,584 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 54a:	07800793          	li	a5,120
 54e:	0cf68d63          	beq	a3,a5,628 <vprintf+0x1d0>
        putc(fd, '%');
 552:	85d6                	mv	a1,s5
 554:	855a                	mv	a0,s6
 556:	e3fff0ef          	jal	ra,394 <putc>
        putc(fd, c0);
 55a:	85ca                	mv	a1,s2
 55c:	855a                	mv	a0,s6
 55e:	e37ff0ef          	jal	ra,394 <putc>
      state = 0;
 562:	4981                	li	s3,0
 564:	b7b9                	j	4b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 566:	008b8913          	addi	s2,s7,8
 56a:	4685                	li	a3,1
 56c:	4629                	li	a2,10
 56e:	000bb583          	ld	a1,0(s7)
 572:	855a                	mv	a0,s6
 574:	e3fff0ef          	jal	ra,3b2 <printint>
        i += 1;
 578:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 57a:	8bca                	mv	s7,s2
      state = 0;
 57c:	4981                	li	s3,0
        i += 1;
 57e:	bf15                	j	4b2 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 580:	03860563          	beq	a2,s8,5aa <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 584:	07b60963          	beq	a2,s11,5f6 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 588:	07800793          	li	a5,120
 58c:	fcf613e3          	bne	a2,a5,552 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 590:	008b8913          	addi	s2,s7,8
 594:	4681                	li	a3,0
 596:	4641                	li	a2,16
 598:	000bb583          	ld	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	e15ff0ef          	jal	ra,3b2 <printint>
        i += 2;
 5a2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
        i += 2;
 5a8:	b729                	j	4b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5aa:	008b8913          	addi	s2,s7,8
 5ae:	4685                	li	a3,1
 5b0:	4629                	li	a2,10
 5b2:	000bb583          	ld	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	dfbff0ef          	jal	ra,3b2 <printint>
        i += 2;
 5bc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5be:	8bca                	mv	s7,s2
      state = 0;
 5c0:	4981                	li	s3,0
        i += 2;
 5c2:	bdc5                	j	4b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4629                	li	a2,10
 5cc:	000be583          	lwu	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	de1ff0ef          	jal	ra,3b2 <printint>
 5d6:	8bca                	mv	s7,s2
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	bde1                	j	4b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4629                	li	a2,10
 5e4:	000bb583          	ld	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	dc9ff0ef          	jal	ra,3b2 <printint>
        i += 1;
 5ee:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f0:	8bca                	mv	s7,s2
      state = 0;
 5f2:	4981                	li	s3,0
        i += 1;
 5f4:	bd7d                	j	4b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f6:	008b8913          	addi	s2,s7,8
 5fa:	4681                	li	a3,0
 5fc:	4629                	li	a2,10
 5fe:	000bb583          	ld	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	dafff0ef          	jal	ra,3b2 <printint>
        i += 2;
 608:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
        i += 2;
 60e:	b555                	j	4b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 610:	008b8913          	addi	s2,s7,8
 614:	4681                	li	a3,0
 616:	4641                	li	a2,16
 618:	000be583          	lwu	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	d95ff0ef          	jal	ra,3b2 <printint>
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
 626:	b571                	j	4b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 628:	008b8913          	addi	s2,s7,8
 62c:	4681                	li	a3,0
 62e:	4641                	li	a2,16
 630:	000bb583          	ld	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	d7dff0ef          	jal	ra,3b2 <printint>
        i += 1;
 63a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
        i += 1;
 640:	bd8d                	j	4b2 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 642:	008b8793          	addi	a5,s7,8
 646:	f8f43423          	sd	a5,-120(s0)
 64a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 64e:	03000593          	li	a1,48
 652:	855a                	mv	a0,s6
 654:	d41ff0ef          	jal	ra,394 <putc>
  putc(fd, 'x');
 658:	07800593          	li	a1,120
 65c:	855a                	mv	a0,s6
 65e:	d37ff0ef          	jal	ra,394 <putc>
 662:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 664:	03c9d793          	srli	a5,s3,0x3c
 668:	97e6                	add	a5,a5,s9
 66a:	0007c583          	lbu	a1,0(a5)
 66e:	855a                	mv	a0,s6
 670:	d25ff0ef          	jal	ra,394 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 674:	0992                	slli	s3,s3,0x4
 676:	397d                	addiw	s2,s2,-1
 678:	fe0916e3          	bnez	s2,664 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 67c:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 680:	4981                	li	s3,0
 682:	bd05                	j	4b2 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 684:	008b8913          	addi	s2,s7,8
 688:	000bc583          	lbu	a1,0(s7)
 68c:	855a                	mv	a0,s6
 68e:	d07ff0ef          	jal	ra,394 <putc>
 692:	8bca                	mv	s7,s2
      state = 0;
 694:	4981                	li	s3,0
 696:	bd31                	j	4b2 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 698:	008b8993          	addi	s3,s7,8
 69c:	000bb903          	ld	s2,0(s7)
 6a0:	00090f63          	beqz	s2,6be <vprintf+0x266>
        for(; *s; s++)
 6a4:	00094583          	lbu	a1,0(s2)
 6a8:	c195                	beqz	a1,6cc <vprintf+0x274>
          putc(fd, *s);
 6aa:	855a                	mv	a0,s6
 6ac:	ce9ff0ef          	jal	ra,394 <putc>
        for(; *s; s++)
 6b0:	0905                	addi	s2,s2,1
 6b2:	00094583          	lbu	a1,0(s2)
 6b6:	f9f5                	bnez	a1,6aa <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6b8:	8bce                	mv	s7,s3
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bbdd                	j	4b2 <vprintf+0x5a>
          s = "(null)";
 6be:	00000917          	auipc	s2,0x0
 6c2:	22290913          	addi	s2,s2,546 # 8e0 <malloc+0x10c>
        for(; *s; s++)
 6c6:	02800593          	li	a1,40
 6ca:	b7c5                	j	6aa <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6cc:	8bce                	mv	s7,s3
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	b3cd                	j	4b2 <vprintf+0x5a>
    }
  }
}
 6d2:	70e6                	ld	ra,120(sp)
 6d4:	7446                	ld	s0,112(sp)
 6d6:	74a6                	ld	s1,104(sp)
 6d8:	7906                	ld	s2,96(sp)
 6da:	69e6                	ld	s3,88(sp)
 6dc:	6a46                	ld	s4,80(sp)
 6de:	6aa6                	ld	s5,72(sp)
 6e0:	6b06                	ld	s6,64(sp)
 6e2:	7be2                	ld	s7,56(sp)
 6e4:	7c42                	ld	s8,48(sp)
 6e6:	7ca2                	ld	s9,40(sp)
 6e8:	7d02                	ld	s10,32(sp)
 6ea:	6de2                	ld	s11,24(sp)
 6ec:	6109                	addi	sp,sp,128
 6ee:	8082                	ret

00000000000006f0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f0:	715d                	addi	sp,sp,-80
 6f2:	ec06                	sd	ra,24(sp)
 6f4:	e822                	sd	s0,16(sp)
 6f6:	1000                	addi	s0,sp,32
 6f8:	e010                	sd	a2,0(s0)
 6fa:	e414                	sd	a3,8(s0)
 6fc:	e818                	sd	a4,16(s0)
 6fe:	ec1c                	sd	a5,24(s0)
 700:	03043023          	sd	a6,32(s0)
 704:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 708:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70c:	8622                	mv	a2,s0
 70e:	d4bff0ef          	jal	ra,458 <vprintf>
}
 712:	60e2                	ld	ra,24(sp)
 714:	6442                	ld	s0,16(sp)
 716:	6161                	addi	sp,sp,80
 718:	8082                	ret

000000000000071a <printf>:

void
printf(const char *fmt, ...)
{
 71a:	711d                	addi	sp,sp,-96
 71c:	ec06                	sd	ra,24(sp)
 71e:	e822                	sd	s0,16(sp)
 720:	1000                	addi	s0,sp,32
 722:	e40c                	sd	a1,8(s0)
 724:	e810                	sd	a2,16(s0)
 726:	ec14                	sd	a3,24(s0)
 728:	f018                	sd	a4,32(s0)
 72a:	f41c                	sd	a5,40(s0)
 72c:	03043823          	sd	a6,48(s0)
 730:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 734:	00840613          	addi	a2,s0,8
 738:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 73c:	85aa                	mv	a1,a0
 73e:	4505                	li	a0,1
 740:	d19ff0ef          	jal	ra,458 <vprintf>
}
 744:	60e2                	ld	ra,24(sp)
 746:	6442                	ld	s0,16(sp)
 748:	6125                	addi	sp,sp,96
 74a:	8082                	ret

000000000000074c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74c:	1141                	addi	sp,sp,-16
 74e:	e422                	sd	s0,8(sp)
 750:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 752:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 756:	00001797          	auipc	a5,0x1
 75a:	8aa7b783          	ld	a5,-1878(a5) # 1000 <freep>
 75e:	a805                	j	78e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 760:	4618                	lw	a4,8(a2)
 762:	9db9                	addw	a1,a1,a4
 764:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 768:	6398                	ld	a4,0(a5)
 76a:	6318                	ld	a4,0(a4)
 76c:	fee53823          	sd	a4,-16(a0)
 770:	a091                	j	7b4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 772:	ff852703          	lw	a4,-8(a0)
 776:	9e39                	addw	a2,a2,a4
 778:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 77a:	ff053703          	ld	a4,-16(a0)
 77e:	e398                	sd	a4,0(a5)
 780:	a099                	j	7c6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 782:	6398                	ld	a4,0(a5)
 784:	00e7e463          	bltu	a5,a4,78c <free+0x40>
 788:	00e6ea63          	bltu	a3,a4,79c <free+0x50>
{
 78c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78e:	fed7fae3          	bgeu	a5,a3,782 <free+0x36>
 792:	6398                	ld	a4,0(a5)
 794:	00e6e463          	bltu	a3,a4,79c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 798:	fee7eae3          	bltu	a5,a4,78c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 79c:	ff852583          	lw	a1,-8(a0)
 7a0:	6390                	ld	a2,0(a5)
 7a2:	02059713          	slli	a4,a1,0x20
 7a6:	9301                	srli	a4,a4,0x20
 7a8:	0712                	slli	a4,a4,0x4
 7aa:	9736                	add	a4,a4,a3
 7ac:	fae60ae3          	beq	a2,a4,760 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7b0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b4:	4790                	lw	a2,8(a5)
 7b6:	02061713          	slli	a4,a2,0x20
 7ba:	9301                	srli	a4,a4,0x20
 7bc:	0712                	slli	a4,a4,0x4
 7be:	973e                	add	a4,a4,a5
 7c0:	fae689e3          	beq	a3,a4,772 <free+0x26>
  } else
    p->s.ptr = bp;
 7c4:	e394                	sd	a3,0(a5)
  freep = p;
 7c6:	00001717          	auipc	a4,0x1
 7ca:	82f73d23          	sd	a5,-1990(a4) # 1000 <freep>
}
 7ce:	6422                	ld	s0,8(sp)
 7d0:	0141                	addi	sp,sp,16
 7d2:	8082                	ret

00000000000007d4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d4:	7139                	addi	sp,sp,-64
 7d6:	fc06                	sd	ra,56(sp)
 7d8:	f822                	sd	s0,48(sp)
 7da:	f426                	sd	s1,40(sp)
 7dc:	f04a                	sd	s2,32(sp)
 7de:	ec4e                	sd	s3,24(sp)
 7e0:	e852                	sd	s4,16(sp)
 7e2:	e456                	sd	s5,8(sp)
 7e4:	e05a                	sd	s6,0(sp)
 7e6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e8:	02051493          	slli	s1,a0,0x20
 7ec:	9081                	srli	s1,s1,0x20
 7ee:	04bd                	addi	s1,s1,15
 7f0:	8091                	srli	s1,s1,0x4
 7f2:	0014899b          	addiw	s3,s1,1
 7f6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7f8:	00001517          	auipc	a0,0x1
 7fc:	80853503          	ld	a0,-2040(a0) # 1000 <freep>
 800:	c515                	beqz	a0,82c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 802:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 804:	4798                	lw	a4,8(a5)
 806:	02977f63          	bgeu	a4,s1,844 <malloc+0x70>
 80a:	8a4e                	mv	s4,s3
 80c:	0009871b          	sext.w	a4,s3
 810:	6685                	lui	a3,0x1
 812:	00d77363          	bgeu	a4,a3,818 <malloc+0x44>
 816:	6a05                	lui	s4,0x1
 818:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 81c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 820:	00000917          	auipc	s2,0x0
 824:	7e090913          	addi	s2,s2,2016 # 1000 <freep>
  if(p == SBRK_ERROR)
 828:	5afd                	li	s5,-1
 82a:	a0bd                	j	898 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 82c:	00000797          	auipc	a5,0x0
 830:	7e478793          	addi	a5,a5,2020 # 1010 <base>
 834:	00000717          	auipc	a4,0x0
 838:	7cf73623          	sd	a5,1996(a4) # 1000 <freep>
 83c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 83e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 842:	b7e1                	j	80a <malloc+0x36>
      if(p->s.size == nunits)
 844:	02e48b63          	beq	s1,a4,87a <malloc+0xa6>
        p->s.size -= nunits;
 848:	4137073b          	subw	a4,a4,s3
 84c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 84e:	1702                	slli	a4,a4,0x20
 850:	9301                	srli	a4,a4,0x20
 852:	0712                	slli	a4,a4,0x4
 854:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 856:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 85a:	00000717          	auipc	a4,0x0
 85e:	7aa73323          	sd	a0,1958(a4) # 1000 <freep>
      return (void*)(p + 1);
 862:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 866:	70e2                	ld	ra,56(sp)
 868:	7442                	ld	s0,48(sp)
 86a:	74a2                	ld	s1,40(sp)
 86c:	7902                	ld	s2,32(sp)
 86e:	69e2                	ld	s3,24(sp)
 870:	6a42                	ld	s4,16(sp)
 872:	6aa2                	ld	s5,8(sp)
 874:	6b02                	ld	s6,0(sp)
 876:	6121                	addi	sp,sp,64
 878:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 87a:	6398                	ld	a4,0(a5)
 87c:	e118                	sd	a4,0(a0)
 87e:	bff1                	j	85a <malloc+0x86>
  hp->s.size = nu;
 880:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 884:	0541                	addi	a0,a0,16
 886:	ec7ff0ef          	jal	ra,74c <free>
  return freep;
 88a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 88e:	dd61                	beqz	a0,866 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 890:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 892:	4798                	lw	a4,8(a5)
 894:	fa9778e3          	bgeu	a4,s1,844 <malloc+0x70>
    if(p == freep)
 898:	00093703          	ld	a4,0(s2)
 89c:	853e                	mv	a0,a5
 89e:	fef719e3          	bne	a4,a5,890 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 8a2:	8552                	mv	a0,s4
 8a4:	a15ff0ef          	jal	ra,2b8 <sbrk>
  if(p == SBRK_ERROR)
 8a8:	fd551ce3          	bne	a0,s5,880 <malloc+0xac>
        return 0;
 8ac:	4501                	li	a0,0
 8ae:	bf65                	j	866 <malloc+0x92>
