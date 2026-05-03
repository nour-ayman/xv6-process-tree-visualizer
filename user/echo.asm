
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i;

  for(i = 1; i < argc; i++){
  10:	4785                	li	a5,1
  12:	04a7dc63          	bge	a5,a0,6a <main+0x6a>
  16:	00858493          	addi	s1,a1,8
  1a:	ffe5099b          	addiw	s3,a0,-2
  1e:	1982                	slli	s3,s3,0x20
  20:	0209d993          	srli	s3,s3,0x20
  24:	098e                	slli	s3,s3,0x3
  26:	05c1                	addi	a1,a1,16
  28:	99ae                	add	s3,s3,a1
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  2a:	00001a17          	auipc	s4,0x1
  2e:	8a6a0a13          	addi	s4,s4,-1882 # 8d0 <malloc+0xe0>
    write(1, argv[i], strlen(argv[i]));
  32:	0004b903          	ld	s2,0(s1)
  36:	854a                	mv	a0,s2
  38:	092000ef          	jal	ra,ca <strlen>
  3c:	0005061b          	sext.w	a2,a0
  40:	85ca                	mv	a1,s2
  42:	4505                	li	a0,1
  44:	2ec000ef          	jal	ra,330 <write>
    if(i + 1 < argc){
  48:	04a1                	addi	s1,s1,8
  4a:	01348863          	beq	s1,s3,5a <main+0x5a>
      write(1, " ", 1);
  4e:	4605                	li	a2,1
  50:	85d2                	mv	a1,s4
  52:	4505                	li	a0,1
  54:	2dc000ef          	jal	ra,330 <write>
  for(i = 1; i < argc; i++){
  58:	bfe9                	j	32 <main+0x32>
    } else {
      write(1, "\n", 1);
  5a:	4605                	li	a2,1
  5c:	00001597          	auipc	a1,0x1
  60:	87c58593          	addi	a1,a1,-1924 # 8d8 <malloc+0xe8>
  64:	4505                	li	a0,1
  66:	2ca000ef          	jal	ra,330 <write>
    }
  }
  exit(0);
  6a:	4501                	li	a0,0
  6c:	2a4000ef          	jal	ra,310 <exit>

0000000000000070 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  70:	1141                	addi	sp,sp,-16
  72:	e406                	sd	ra,8(sp)
  74:	e022                	sd	s0,0(sp)
  76:	0800                	addi	s0,sp,16
  extern int main();
  main();
  78:	f89ff0ef          	jal	ra,0 <main>
  exit(0);
  7c:	4501                	li	a0,0
  7e:	292000ef          	jal	ra,310 <exit>

0000000000000082 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  82:	1141                	addi	sp,sp,-16
  84:	e422                	sd	s0,8(sp)
  86:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  88:	87aa                	mv	a5,a0
  8a:	0585                	addi	a1,a1,1
  8c:	0785                	addi	a5,a5,1
  8e:	fff5c703          	lbu	a4,-1(a1)
  92:	fee78fa3          	sb	a4,-1(a5)
  96:	fb75                	bnez	a4,8a <strcpy+0x8>
    ;
  return os;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret

000000000000009e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e422                	sd	s0,8(sp)
  a2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a4:	00054783          	lbu	a5,0(a0)
  a8:	cb91                	beqz	a5,bc <strcmp+0x1e>
  aa:	0005c703          	lbu	a4,0(a1)
  ae:	00f71763          	bne	a4,a5,bc <strcmp+0x1e>
    p++, q++;
  b2:	0505                	addi	a0,a0,1
  b4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	fbe5                	bnez	a5,aa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  bc:	0005c503          	lbu	a0,0(a1)
}
  c0:	40a7853b          	subw	a0,a5,a0
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strlen>:

uint
strlen(const char *s)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cf91                	beqz	a5,f0 <strlen+0x26>
  d6:	0505                	addi	a0,a0,1
  d8:	87aa                	mv	a5,a0
  da:	4685                	li	a3,1
  dc:	9e89                	subw	a3,a3,a0
  de:	00f6853b          	addw	a0,a3,a5
  e2:	0785                	addi	a5,a5,1
  e4:	fff7c703          	lbu	a4,-1(a5)
  e8:	fb7d                	bnez	a4,de <strlen+0x14>
    ;
  return n;
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  for(n = 0; s[n]; n++)
  f0:	4501                	li	a0,0
  f2:	bfe5                	j	ea <strlen+0x20>

00000000000000f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fa:	ce09                	beqz	a2,114 <memset+0x20>
  fc:	87aa                	mv	a5,a0
  fe:	fff6071b          	addiw	a4,a2,-1
 102:	1702                	slli	a4,a4,0x20
 104:	9301                	srli	a4,a4,0x20
 106:	0705                	addi	a4,a4,1
 108:	972a                	add	a4,a4,a0
    cdst[i] = c;
 10a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10e:	0785                	addi	a5,a5,1
 110:	fee79de3          	bne	a5,a4,10a <memset+0x16>
  }
  return dst;
}
 114:	6422                	ld	s0,8(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <strchr>:

char*
strchr(const char *s, char c)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e422                	sd	s0,8(sp)
 11e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 120:	00054783          	lbu	a5,0(a0)
 124:	cb99                	beqz	a5,13a <strchr+0x20>
    if(*s == c)
 126:	00f58763          	beq	a1,a5,134 <strchr+0x1a>
  for(; *s; s++)
 12a:	0505                	addi	a0,a0,1
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbfd                	bnez	a5,126 <strchr+0xc>
      return (char*)s;
  return 0;
 132:	4501                	li	a0,0
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret
  return 0;
 13a:	4501                	li	a0,0
 13c:	bfe5                	j	134 <strchr+0x1a>

000000000000013e <gets>:

char*
gets(char *buf, int max)
{
 13e:	711d                	addi	sp,sp,-96
 140:	ec86                	sd	ra,88(sp)
 142:	e8a2                	sd	s0,80(sp)
 144:	e4a6                	sd	s1,72(sp)
 146:	e0ca                	sd	s2,64(sp)
 148:	fc4e                	sd	s3,56(sp)
 14a:	f852                	sd	s4,48(sp)
 14c:	f456                	sd	s5,40(sp)
 14e:	f05a                	sd	s6,32(sp)
 150:	ec5e                	sd	s7,24(sp)
 152:	1080                	addi	s0,sp,96
 154:	8baa                	mv	s7,a0
 156:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 158:	892a                	mv	s2,a0
 15a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 15c:	4aa9                	li	s5,10
 15e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 160:	89a6                	mv	s3,s1
 162:	2485                	addiw	s1,s1,1
 164:	0344d663          	bge	s1,s4,190 <gets+0x52>
    cc = read(0, &c, 1);
 168:	4605                	li	a2,1
 16a:	faf40593          	addi	a1,s0,-81
 16e:	4501                	li	a0,0
 170:	1b8000ef          	jal	ra,328 <read>
    if(cc < 1)
 174:	00a05e63          	blez	a0,190 <gets+0x52>
    buf[i++] = c;
 178:	faf44783          	lbu	a5,-81(s0)
 17c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 180:	01578763          	beq	a5,s5,18e <gets+0x50>
 184:	0905                	addi	s2,s2,1
 186:	fd679de3          	bne	a5,s6,160 <gets+0x22>
  for(i=0; i+1 < max; ){
 18a:	89a6                	mv	s3,s1
 18c:	a011                	j	190 <gets+0x52>
 18e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 190:	99de                	add	s3,s3,s7
 192:	00098023          	sb	zero,0(s3)
  return buf;
}
 196:	855e                	mv	a0,s7
 198:	60e6                	ld	ra,88(sp)
 19a:	6446                	ld	s0,80(sp)
 19c:	64a6                	ld	s1,72(sp)
 19e:	6906                	ld	s2,64(sp)
 1a0:	79e2                	ld	s3,56(sp)
 1a2:	7a42                	ld	s4,48(sp)
 1a4:	7aa2                	ld	s5,40(sp)
 1a6:	7b02                	ld	s6,32(sp)
 1a8:	6be2                	ld	s7,24(sp)
 1aa:	6125                	addi	sp,sp,96
 1ac:	8082                	ret

00000000000001ae <stat>:

int
stat(const char *n, struct stat *st)
{
 1ae:	1101                	addi	sp,sp,-32
 1b0:	ec06                	sd	ra,24(sp)
 1b2:	e822                	sd	s0,16(sp)
 1b4:	e426                	sd	s1,8(sp)
 1b6:	e04a                	sd	s2,0(sp)
 1b8:	1000                	addi	s0,sp,32
 1ba:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1bc:	4581                	li	a1,0
 1be:	192000ef          	jal	ra,350 <open>
  if(fd < 0)
 1c2:	02054163          	bltz	a0,1e4 <stat+0x36>
 1c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c8:	85ca                	mv	a1,s2
 1ca:	19e000ef          	jal	ra,368 <fstat>
 1ce:	892a                	mv	s2,a0
  close(fd);
 1d0:	8526                	mv	a0,s1
 1d2:	166000ef          	jal	ra,338 <close>
  return r;
}
 1d6:	854a                	mv	a0,s2
 1d8:	60e2                	ld	ra,24(sp)
 1da:	6442                	ld	s0,16(sp)
 1dc:	64a2                	ld	s1,8(sp)
 1de:	6902                	ld	s2,0(sp)
 1e0:	6105                	addi	sp,sp,32
 1e2:	8082                	ret
    return -1;
 1e4:	597d                	li	s2,-1
 1e6:	bfc5                	j	1d6 <stat+0x28>

00000000000001e8 <atoi>:

int
atoi(const char *s)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ee:	00054603          	lbu	a2,0(a0)
 1f2:	fd06079b          	addiw	a5,a2,-48
 1f6:	0ff7f793          	andi	a5,a5,255
 1fa:	4725                	li	a4,9
 1fc:	02f76963          	bltu	a4,a5,22e <atoi+0x46>
 200:	86aa                	mv	a3,a0
  n = 0;
 202:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 204:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 206:	0685                	addi	a3,a3,1
 208:	0025179b          	slliw	a5,a0,0x2
 20c:	9fa9                	addw	a5,a5,a0
 20e:	0017979b          	slliw	a5,a5,0x1
 212:	9fb1                	addw	a5,a5,a2
 214:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 218:	0006c603          	lbu	a2,0(a3)
 21c:	fd06071b          	addiw	a4,a2,-48
 220:	0ff77713          	andi	a4,a4,255
 224:	fee5f1e3          	bgeu	a1,a4,206 <atoi+0x1e>
  return n;
}
 228:	6422                	ld	s0,8(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret
  n = 0;
 22e:	4501                	li	a0,0
 230:	bfe5                	j	228 <atoi+0x40>

0000000000000232 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 238:	02b57663          	bgeu	a0,a1,264 <memmove+0x32>
    while(n-- > 0)
 23c:	02c05163          	blez	a2,25e <memmove+0x2c>
 240:	fff6079b          	addiw	a5,a2,-1
 244:	1782                	slli	a5,a5,0x20
 246:	9381                	srli	a5,a5,0x20
 248:	0785                	addi	a5,a5,1
 24a:	97aa                	add	a5,a5,a0
  dst = vdst;
 24c:	872a                	mv	a4,a0
      *dst++ = *src++;
 24e:	0585                	addi	a1,a1,1
 250:	0705                	addi	a4,a4,1
 252:	fff5c683          	lbu	a3,-1(a1)
 256:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25a:	fee79ae3          	bne	a5,a4,24e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
    dst += n;
 264:	00c50733          	add	a4,a0,a2
    src += n;
 268:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 26a:	fec05ae3          	blez	a2,25e <memmove+0x2c>
 26e:	fff6079b          	addiw	a5,a2,-1
 272:	1782                	slli	a5,a5,0x20
 274:	9381                	srli	a5,a5,0x20
 276:	fff7c793          	not	a5,a5
 27a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27c:	15fd                	addi	a1,a1,-1
 27e:	177d                	addi	a4,a4,-1
 280:	0005c683          	lbu	a3,0(a1)
 284:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 288:	fee79ae3          	bne	a5,a4,27c <memmove+0x4a>
 28c:	bfc9                	j	25e <memmove+0x2c>

000000000000028e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 294:	ca05                	beqz	a2,2c4 <memcmp+0x36>
 296:	fff6069b          	addiw	a3,a2,-1
 29a:	1682                	slli	a3,a3,0x20
 29c:	9281                	srli	a3,a3,0x20
 29e:	0685                	addi	a3,a3,1
 2a0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	0005c703          	lbu	a4,0(a1)
 2aa:	00e79863          	bne	a5,a4,2ba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ae:	0505                	addi	a0,a0,1
    p2++;
 2b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b2:	fed518e3          	bne	a0,a3,2a2 <memcmp+0x14>
  }
  return 0;
 2b6:	4501                	li	a0,0
 2b8:	a019                	j	2be <memcmp+0x30>
      return *p1 - *p2;
 2ba:	40e7853b          	subw	a0,a5,a4
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  return 0;
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <memcmp+0x30>

00000000000002c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d0:	f63ff0ef          	jal	ra,232 <memmove>
}
 2d4:	60a2                	ld	ra,8(sp)
 2d6:	6402                	ld	s0,0(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret

00000000000002dc <sbrk>:

char *
sbrk(int n) {
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2e4:	4585                	li	a1,1
 2e6:	0b2000ef          	jal	ra,398 <sys_sbrk>
}
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret

00000000000002f2 <sbrklazy>:

char *
sbrklazy(int n) {
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e406                	sd	ra,8(sp)
 2f6:	e022                	sd	s0,0(sp)
 2f8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2fa:	4589                	li	a1,2
 2fc:	09c000ef          	jal	ra,398 <sys_sbrk>
}
 300:	60a2                	ld	ra,8(sp)
 302:	6402                	ld	s0,0(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 308:	4885                	li	a7,1
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <exit>:
.global exit
exit:
 li a7, SYS_exit
 310:	4889                	li	a7,2
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <wait>:
.global wait
wait:
 li a7, SYS_wait
 318:	488d                	li	a7,3
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 320:	4891                	li	a7,4
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <read>:
.global read
read:
 li a7, SYS_read
 328:	4895                	li	a7,5
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <write>:
.global write
write:
 li a7, SYS_write
 330:	48c1                	li	a7,16
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <close>:
.global close
close:
 li a7, SYS_close
 338:	48d5                	li	a7,21
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <kill>:
.global kill
kill:
 li a7, SYS_kill
 340:	4899                	li	a7,6
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <exec>:
.global exec
exec:
 li a7, SYS_exec
 348:	489d                	li	a7,7
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <open>:
.global open
open:
 li a7, SYS_open
 350:	48bd                	li	a7,15
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 358:	48c5                	li	a7,17
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 360:	48c9                	li	a7,18
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 368:	48a1                	li	a7,8
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <link>:
.global link
link:
 li a7, SYS_link
 370:	48cd                	li	a7,19
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 378:	48d1                	li	a7,20
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 380:	48a5                	li	a7,9
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <dup>:
.global dup
dup:
 li a7, SYS_dup
 388:	48a9                	li	a7,10
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 390:	48ad                	li	a7,11
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 398:	48b1                	li	a7,12
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3a0:	48b5                	li	a7,13
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a8:	48b9                	li	a7,14
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b0:	1101                	addi	sp,sp,-32
 3b2:	ec06                	sd	ra,24(sp)
 3b4:	e822                	sd	s0,16(sp)
 3b6:	1000                	addi	s0,sp,32
 3b8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3bc:	4605                	li	a2,1
 3be:	fef40593          	addi	a1,s0,-17
 3c2:	f6fff0ef          	jal	ra,330 <write>
}
 3c6:	60e2                	ld	ra,24(sp)
 3c8:	6442                	ld	s0,16(sp)
 3ca:	6105                	addi	sp,sp,32
 3cc:	8082                	ret

00000000000003ce <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ce:	715d                	addi	sp,sp,-80
 3d0:	e486                	sd	ra,72(sp)
 3d2:	e0a2                	sd	s0,64(sp)
 3d4:	fc26                	sd	s1,56(sp)
 3d6:	f84a                	sd	s2,48(sp)
 3d8:	f44e                	sd	s3,40(sp)
 3da:	0880                	addi	s0,sp,80
 3dc:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3de:	c299                	beqz	a3,3e4 <printint+0x16>
 3e0:	0805c663          	bltz	a1,46c <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e4:	2581                	sext.w	a1,a1
  neg = 0;
 3e6:	4881                	li	a7,0
 3e8:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3ec:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ee:	2601                	sext.w	a2,a2
 3f0:	00000517          	auipc	a0,0x0
 3f4:	4f850513          	addi	a0,a0,1272 # 8e8 <digits>
 3f8:	883a                	mv	a6,a4
 3fa:	2705                	addiw	a4,a4,1
 3fc:	02c5f7bb          	remuw	a5,a1,a2
 400:	1782                	slli	a5,a5,0x20
 402:	9381                	srli	a5,a5,0x20
 404:	97aa                	add	a5,a5,a0
 406:	0007c783          	lbu	a5,0(a5)
 40a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 40e:	0005879b          	sext.w	a5,a1
 412:	02c5d5bb          	divuw	a1,a1,a2
 416:	0685                	addi	a3,a3,1
 418:	fec7f0e3          	bgeu	a5,a2,3f8 <printint+0x2a>
  if(neg)
 41c:	00088b63          	beqz	a7,432 <printint+0x64>
    buf[i++] = '-';
 420:	fd040793          	addi	a5,s0,-48
 424:	973e                	add	a4,a4,a5
 426:	02d00793          	li	a5,45
 42a:	fef70423          	sb	a5,-24(a4)
 42e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 432:	02e05663          	blez	a4,45e <printint+0x90>
 436:	fb840793          	addi	a5,s0,-72
 43a:	00e78933          	add	s2,a5,a4
 43e:	fff78993          	addi	s3,a5,-1
 442:	99ba                	add	s3,s3,a4
 444:	377d                	addiw	a4,a4,-1
 446:	1702                	slli	a4,a4,0x20
 448:	9301                	srli	a4,a4,0x20
 44a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 44e:	fff94583          	lbu	a1,-1(s2)
 452:	8526                	mv	a0,s1
 454:	f5dff0ef          	jal	ra,3b0 <putc>
  while(--i >= 0)
 458:	197d                	addi	s2,s2,-1
 45a:	ff391ae3          	bne	s2,s3,44e <printint+0x80>
}
 45e:	60a6                	ld	ra,72(sp)
 460:	6406                	ld	s0,64(sp)
 462:	74e2                	ld	s1,56(sp)
 464:	7942                	ld	s2,48(sp)
 466:	79a2                	ld	s3,40(sp)
 468:	6161                	addi	sp,sp,80
 46a:	8082                	ret
    x = -xx;
 46c:	40b005bb          	negw	a1,a1
    neg = 1;
 470:	4885                	li	a7,1
    x = -xx;
 472:	bf9d                	j	3e8 <printint+0x1a>

0000000000000474 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 474:	7119                	addi	sp,sp,-128
 476:	fc86                	sd	ra,120(sp)
 478:	f8a2                	sd	s0,112(sp)
 47a:	f4a6                	sd	s1,104(sp)
 47c:	f0ca                	sd	s2,96(sp)
 47e:	ecce                	sd	s3,88(sp)
 480:	e8d2                	sd	s4,80(sp)
 482:	e4d6                	sd	s5,72(sp)
 484:	e0da                	sd	s6,64(sp)
 486:	fc5e                	sd	s7,56(sp)
 488:	f862                	sd	s8,48(sp)
 48a:	f466                	sd	s9,40(sp)
 48c:	f06a                	sd	s10,32(sp)
 48e:	ec6e                	sd	s11,24(sp)
 490:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 492:	0005c903          	lbu	s2,0(a1)
 496:	24090c63          	beqz	s2,6ee <vprintf+0x27a>
 49a:	8b2a                	mv	s6,a0
 49c:	8a2e                	mv	s4,a1
 49e:	8bb2                	mv	s7,a2
  state = 0;
 4a0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4a2:	4481                	li	s1,0
 4a4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4a6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4aa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ae:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4b2:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4b6:	00000c97          	auipc	s9,0x0
 4ba:	432c8c93          	addi	s9,s9,1074 # 8e8 <digits>
 4be:	a005                	j	4de <vprintf+0x6a>
        putc(fd, c0);
 4c0:	85ca                	mv	a1,s2
 4c2:	855a                	mv	a0,s6
 4c4:	eedff0ef          	jal	ra,3b0 <putc>
 4c8:	a019                	j	4ce <vprintf+0x5a>
    } else if(state == '%'){
 4ca:	03598263          	beq	s3,s5,4ee <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4ce:	2485                	addiw	s1,s1,1
 4d0:	8726                	mv	a4,s1
 4d2:	009a07b3          	add	a5,s4,s1
 4d6:	0007c903          	lbu	s2,0(a5)
 4da:	20090a63          	beqz	s2,6ee <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 4de:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4e2:	fe0994e3          	bnez	s3,4ca <vprintf+0x56>
      if(c0 == '%'){
 4e6:	fd579de3          	bne	a5,s5,4c0 <vprintf+0x4c>
        state = '%';
 4ea:	89be                	mv	s3,a5
 4ec:	b7cd                	j	4ce <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ee:	c3c1                	beqz	a5,56e <vprintf+0xfa>
 4f0:	00ea06b3          	add	a3,s4,a4
 4f4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4f8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4fa:	c681                	beqz	a3,502 <vprintf+0x8e>
 4fc:	9752                	add	a4,a4,s4
 4fe:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 502:	03878e63          	beq	a5,s8,53e <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 506:	05a78863          	beq	a5,s10,556 <vprintf+0xe2>
      } else if(c0 == 'u'){
 50a:	0db78b63          	beq	a5,s11,5e0 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 50e:	07800713          	li	a4,120
 512:	10e78d63          	beq	a5,a4,62c <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 516:	07000713          	li	a4,112
 51a:	14e78263          	beq	a5,a4,65e <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 51e:	06300713          	li	a4,99
 522:	16e78f63          	beq	a5,a4,6a0 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 526:	07300713          	li	a4,115
 52a:	18e78563          	beq	a5,a4,6b4 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 52e:	05579063          	bne	a5,s5,56e <vprintf+0xfa>
        putc(fd, '%');
 532:	85d6                	mv	a1,s5
 534:	855a                	mv	a0,s6
 536:	e7bff0ef          	jal	ra,3b0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 53a:	4981                	li	s3,0
 53c:	bf49                	j	4ce <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 53e:	008b8913          	addi	s2,s7,8
 542:	4685                	li	a3,1
 544:	4629                	li	a2,10
 546:	000ba583          	lw	a1,0(s7)
 54a:	855a                	mv	a0,s6
 54c:	e83ff0ef          	jal	ra,3ce <printint>
 550:	8bca                	mv	s7,s2
      state = 0;
 552:	4981                	li	s3,0
 554:	bfad                	j	4ce <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 556:	03868663          	beq	a3,s8,582 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 55a:	05a68163          	beq	a3,s10,59c <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 55e:	09b68d63          	beq	a3,s11,5f8 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 562:	03a68f63          	beq	a3,s10,5a0 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 566:	07800793          	li	a5,120
 56a:	0cf68d63          	beq	a3,a5,644 <vprintf+0x1d0>
        putc(fd, '%');
 56e:	85d6                	mv	a1,s5
 570:	855a                	mv	a0,s6
 572:	e3fff0ef          	jal	ra,3b0 <putc>
        putc(fd, c0);
 576:	85ca                	mv	a1,s2
 578:	855a                	mv	a0,s6
 57a:	e37ff0ef          	jal	ra,3b0 <putc>
      state = 0;
 57e:	4981                	li	s3,0
 580:	b7b9                	j	4ce <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 582:	008b8913          	addi	s2,s7,8
 586:	4685                	li	a3,1
 588:	4629                	li	a2,10
 58a:	000bb583          	ld	a1,0(s7)
 58e:	855a                	mv	a0,s6
 590:	e3fff0ef          	jal	ra,3ce <printint>
        i += 1;
 594:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 596:	8bca                	mv	s7,s2
      state = 0;
 598:	4981                	li	s3,0
        i += 1;
 59a:	bf15                	j	4ce <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 59c:	03860563          	beq	a2,s8,5c6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5a0:	07b60963          	beq	a2,s11,612 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5a4:	07800793          	li	a5,120
 5a8:	fcf613e3          	bne	a2,a5,56e <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ac:	008b8913          	addi	s2,s7,8
 5b0:	4681                	li	a3,0
 5b2:	4641                	li	a2,16
 5b4:	000bb583          	ld	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	e15ff0ef          	jal	ra,3ce <printint>
        i += 2;
 5be:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c0:	8bca                	mv	s7,s2
      state = 0;
 5c2:	4981                	li	s3,0
        i += 2;
 5c4:	b729                	j	4ce <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c6:	008b8913          	addi	s2,s7,8
 5ca:	4685                	li	a3,1
 5cc:	4629                	li	a2,10
 5ce:	000bb583          	ld	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	dfbff0ef          	jal	ra,3ce <printint>
        i += 2;
 5d8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5da:	8bca                	mv	s7,s2
      state = 0;
 5dc:	4981                	li	s3,0
        i += 2;
 5de:	bdc5                	j	4ce <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5e0:	008b8913          	addi	s2,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4629                	li	a2,10
 5e8:	000be583          	lwu	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	de1ff0ef          	jal	ra,3ce <printint>
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	bde1                	j	4ce <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f8:	008b8913          	addi	s2,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4629                	li	a2,10
 600:	000bb583          	ld	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	dc9ff0ef          	jal	ra,3ce <printint>
        i += 1;
 60a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 60c:	8bca                	mv	s7,s2
      state = 0;
 60e:	4981                	li	s3,0
        i += 1;
 610:	bd7d                	j	4ce <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 612:	008b8913          	addi	s2,s7,8
 616:	4681                	li	a3,0
 618:	4629                	li	a2,10
 61a:	000bb583          	ld	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	dafff0ef          	jal	ra,3ce <printint>
        i += 2;
 624:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 626:	8bca                	mv	s7,s2
      state = 0;
 628:	4981                	li	s3,0
        i += 2;
 62a:	b555                	j	4ce <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 62c:	008b8913          	addi	s2,s7,8
 630:	4681                	li	a3,0
 632:	4641                	li	a2,16
 634:	000be583          	lwu	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	d95ff0ef          	jal	ra,3ce <printint>
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
 642:	b571                	j	4ce <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 644:	008b8913          	addi	s2,s7,8
 648:	4681                	li	a3,0
 64a:	4641                	li	a2,16
 64c:	000bb583          	ld	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	d7dff0ef          	jal	ra,3ce <printint>
        i += 1;
 656:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 658:	8bca                	mv	s7,s2
      state = 0;
 65a:	4981                	li	s3,0
        i += 1;
 65c:	bd8d                	j	4ce <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 65e:	008b8793          	addi	a5,s7,8
 662:	f8f43423          	sd	a5,-120(s0)
 666:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 66a:	03000593          	li	a1,48
 66e:	855a                	mv	a0,s6
 670:	d41ff0ef          	jal	ra,3b0 <putc>
  putc(fd, 'x');
 674:	07800593          	li	a1,120
 678:	855a                	mv	a0,s6
 67a:	d37ff0ef          	jal	ra,3b0 <putc>
 67e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 680:	03c9d793          	srli	a5,s3,0x3c
 684:	97e6                	add	a5,a5,s9
 686:	0007c583          	lbu	a1,0(a5)
 68a:	855a                	mv	a0,s6
 68c:	d25ff0ef          	jal	ra,3b0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 690:	0992                	slli	s3,s3,0x4
 692:	397d                	addiw	s2,s2,-1
 694:	fe0916e3          	bnez	s2,680 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 698:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 69c:	4981                	li	s3,0
 69e:	bd05                	j	4ce <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 6a0:	008b8913          	addi	s2,s7,8
 6a4:	000bc583          	lbu	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	d07ff0ef          	jal	ra,3b0 <putc>
 6ae:	8bca                	mv	s7,s2
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	bd31                	j	4ce <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 6b4:	008b8993          	addi	s3,s7,8
 6b8:	000bb903          	ld	s2,0(s7)
 6bc:	00090f63          	beqz	s2,6da <vprintf+0x266>
        for(; *s; s++)
 6c0:	00094583          	lbu	a1,0(s2)
 6c4:	c195                	beqz	a1,6e8 <vprintf+0x274>
          putc(fd, *s);
 6c6:	855a                	mv	a0,s6
 6c8:	ce9ff0ef          	jal	ra,3b0 <putc>
        for(; *s; s++)
 6cc:	0905                	addi	s2,s2,1
 6ce:	00094583          	lbu	a1,0(s2)
 6d2:	f9f5                	bnez	a1,6c6 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6d4:	8bce                	mv	s7,s3
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	bbdd                	j	4ce <vprintf+0x5a>
          s = "(null)";
 6da:	00000917          	auipc	s2,0x0
 6de:	20690913          	addi	s2,s2,518 # 8e0 <malloc+0xf0>
        for(; *s; s++)
 6e2:	02800593          	li	a1,40
 6e6:	b7c5                	j	6c6 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6e8:	8bce                	mv	s7,s3
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	b3cd                	j	4ce <vprintf+0x5a>
    }
  }
}
 6ee:	70e6                	ld	ra,120(sp)
 6f0:	7446                	ld	s0,112(sp)
 6f2:	74a6                	ld	s1,104(sp)
 6f4:	7906                	ld	s2,96(sp)
 6f6:	69e6                	ld	s3,88(sp)
 6f8:	6a46                	ld	s4,80(sp)
 6fa:	6aa6                	ld	s5,72(sp)
 6fc:	6b06                	ld	s6,64(sp)
 6fe:	7be2                	ld	s7,56(sp)
 700:	7c42                	ld	s8,48(sp)
 702:	7ca2                	ld	s9,40(sp)
 704:	7d02                	ld	s10,32(sp)
 706:	6de2                	ld	s11,24(sp)
 708:	6109                	addi	sp,sp,128
 70a:	8082                	ret

000000000000070c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 70c:	715d                	addi	sp,sp,-80
 70e:	ec06                	sd	ra,24(sp)
 710:	e822                	sd	s0,16(sp)
 712:	1000                	addi	s0,sp,32
 714:	e010                	sd	a2,0(s0)
 716:	e414                	sd	a3,8(s0)
 718:	e818                	sd	a4,16(s0)
 71a:	ec1c                	sd	a5,24(s0)
 71c:	03043023          	sd	a6,32(s0)
 720:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 724:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 728:	8622                	mv	a2,s0
 72a:	d4bff0ef          	jal	ra,474 <vprintf>
}
 72e:	60e2                	ld	ra,24(sp)
 730:	6442                	ld	s0,16(sp)
 732:	6161                	addi	sp,sp,80
 734:	8082                	ret

0000000000000736 <printf>:

void
printf(const char *fmt, ...)
{
 736:	711d                	addi	sp,sp,-96
 738:	ec06                	sd	ra,24(sp)
 73a:	e822                	sd	s0,16(sp)
 73c:	1000                	addi	s0,sp,32
 73e:	e40c                	sd	a1,8(s0)
 740:	e810                	sd	a2,16(s0)
 742:	ec14                	sd	a3,24(s0)
 744:	f018                	sd	a4,32(s0)
 746:	f41c                	sd	a5,40(s0)
 748:	03043823          	sd	a6,48(s0)
 74c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 750:	00840613          	addi	a2,s0,8
 754:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 758:	85aa                	mv	a1,a0
 75a:	4505                	li	a0,1
 75c:	d19ff0ef          	jal	ra,474 <vprintf>
}
 760:	60e2                	ld	ra,24(sp)
 762:	6442                	ld	s0,16(sp)
 764:	6125                	addi	sp,sp,96
 766:	8082                	ret

0000000000000768 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 768:	1141                	addi	sp,sp,-16
 76a:	e422                	sd	s0,8(sp)
 76c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 76e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 772:	00001797          	auipc	a5,0x1
 776:	88e7b783          	ld	a5,-1906(a5) # 1000 <freep>
 77a:	a805                	j	7aa <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 77c:	4618                	lw	a4,8(a2)
 77e:	9db9                	addw	a1,a1,a4
 780:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 784:	6398                	ld	a4,0(a5)
 786:	6318                	ld	a4,0(a4)
 788:	fee53823          	sd	a4,-16(a0)
 78c:	a091                	j	7d0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 78e:	ff852703          	lw	a4,-8(a0)
 792:	9e39                	addw	a2,a2,a4
 794:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 796:	ff053703          	ld	a4,-16(a0)
 79a:	e398                	sd	a4,0(a5)
 79c:	a099                	j	7e2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79e:	6398                	ld	a4,0(a5)
 7a0:	00e7e463          	bltu	a5,a4,7a8 <free+0x40>
 7a4:	00e6ea63          	bltu	a3,a4,7b8 <free+0x50>
{
 7a8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	fed7fae3          	bgeu	a5,a3,79e <free+0x36>
 7ae:	6398                	ld	a4,0(a5)
 7b0:	00e6e463          	bltu	a3,a4,7b8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	fee7eae3          	bltu	a5,a4,7a8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7b8:	ff852583          	lw	a1,-8(a0)
 7bc:	6390                	ld	a2,0(a5)
 7be:	02059713          	slli	a4,a1,0x20
 7c2:	9301                	srli	a4,a4,0x20
 7c4:	0712                	slli	a4,a4,0x4
 7c6:	9736                	add	a4,a4,a3
 7c8:	fae60ae3          	beq	a2,a4,77c <free+0x14>
    bp->s.ptr = p->s.ptr;
 7cc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7d0:	4790                	lw	a2,8(a5)
 7d2:	02061713          	slli	a4,a2,0x20
 7d6:	9301                	srli	a4,a4,0x20
 7d8:	0712                	slli	a4,a4,0x4
 7da:	973e                	add	a4,a4,a5
 7dc:	fae689e3          	beq	a3,a4,78e <free+0x26>
  } else
    p->s.ptr = bp;
 7e0:	e394                	sd	a3,0(a5)
  freep = p;
 7e2:	00001717          	auipc	a4,0x1
 7e6:	80f73f23          	sd	a5,-2018(a4) # 1000 <freep>
}
 7ea:	6422                	ld	s0,8(sp)
 7ec:	0141                	addi	sp,sp,16
 7ee:	8082                	ret

00000000000007f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f0:	7139                	addi	sp,sp,-64
 7f2:	fc06                	sd	ra,56(sp)
 7f4:	f822                	sd	s0,48(sp)
 7f6:	f426                	sd	s1,40(sp)
 7f8:	f04a                	sd	s2,32(sp)
 7fa:	ec4e                	sd	s3,24(sp)
 7fc:	e852                	sd	s4,16(sp)
 7fe:	e456                	sd	s5,8(sp)
 800:	e05a                	sd	s6,0(sp)
 802:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 804:	02051493          	slli	s1,a0,0x20
 808:	9081                	srli	s1,s1,0x20
 80a:	04bd                	addi	s1,s1,15
 80c:	8091                	srli	s1,s1,0x4
 80e:	0014899b          	addiw	s3,s1,1
 812:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 814:	00000517          	auipc	a0,0x0
 818:	7ec53503          	ld	a0,2028(a0) # 1000 <freep>
 81c:	c515                	beqz	a0,848 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 820:	4798                	lw	a4,8(a5)
 822:	02977f63          	bgeu	a4,s1,860 <malloc+0x70>
 826:	8a4e                	mv	s4,s3
 828:	0009871b          	sext.w	a4,s3
 82c:	6685                	lui	a3,0x1
 82e:	00d77363          	bgeu	a4,a3,834 <malloc+0x44>
 832:	6a05                	lui	s4,0x1
 834:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 838:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83c:	00000917          	auipc	s2,0x0
 840:	7c490913          	addi	s2,s2,1988 # 1000 <freep>
  if(p == SBRK_ERROR)
 844:	5afd                	li	s5,-1
 846:	a0bd                	j	8b4 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 848:	00000797          	auipc	a5,0x0
 84c:	7c878793          	addi	a5,a5,1992 # 1010 <base>
 850:	00000717          	auipc	a4,0x0
 854:	7af73823          	sd	a5,1968(a4) # 1000 <freep>
 858:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 85a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 85e:	b7e1                	j	826 <malloc+0x36>
      if(p->s.size == nunits)
 860:	02e48b63          	beq	s1,a4,896 <malloc+0xa6>
        p->s.size -= nunits;
 864:	4137073b          	subw	a4,a4,s3
 868:	c798                	sw	a4,8(a5)
        p += p->s.size;
 86a:	1702                	slli	a4,a4,0x20
 86c:	9301                	srli	a4,a4,0x20
 86e:	0712                	slli	a4,a4,0x4
 870:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 872:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 876:	00000717          	auipc	a4,0x0
 87a:	78a73523          	sd	a0,1930(a4) # 1000 <freep>
      return (void*)(p + 1);
 87e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 882:	70e2                	ld	ra,56(sp)
 884:	7442                	ld	s0,48(sp)
 886:	74a2                	ld	s1,40(sp)
 888:	7902                	ld	s2,32(sp)
 88a:	69e2                	ld	s3,24(sp)
 88c:	6a42                	ld	s4,16(sp)
 88e:	6aa2                	ld	s5,8(sp)
 890:	6b02                	ld	s6,0(sp)
 892:	6121                	addi	sp,sp,64
 894:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 896:	6398                	ld	a4,0(a5)
 898:	e118                	sd	a4,0(a0)
 89a:	bff1                	j	876 <malloc+0x86>
  hp->s.size = nu;
 89c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a0:	0541                	addi	a0,a0,16
 8a2:	ec7ff0ef          	jal	ra,768 <free>
  return freep;
 8a6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8aa:	dd61                	beqz	a0,882 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ae:	4798                	lw	a4,8(a5)
 8b0:	fa9778e3          	bgeu	a4,s1,860 <malloc+0x70>
    if(p == freep)
 8b4:	00093703          	ld	a4,0(s2)
 8b8:	853e                	mv	a0,a5
 8ba:	fef719e3          	bne	a4,a5,8ac <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 8be:	8552                	mv	a0,s4
 8c0:	a1dff0ef          	jal	ra,2dc <sbrk>
  if(p == SBRK_ERROR)
 8c4:	fd551ce3          	bne	a0,s5,89c <malloc+0xac>
        return 0;
 8c8:	4501                	li	a0,0
 8ca:	bf65                	j	882 <malloc+0x92>
