
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
   c:	12c000ef          	jal	ra,138 <strlen>
  10:	0005061b          	sext.w	a2,a0
  14:	85a6                	mv	a1,s1
  16:	4505                	li	a0,1
  18:	386000ef          	jal	ra,39e <write>
}
  1c:	60e2                	ld	ra,24(sp)
  1e:	6442                	ld	s0,16(sp)
  20:	64a2                	ld	s1,8(sp)
  22:	6105                	addi	sp,sp,32
  24:	8082                	ret

0000000000000026 <forktest>:

void
forktest(void)
{
  26:	1101                	addi	sp,sp,-32
  28:	ec06                	sd	ra,24(sp)
  2a:	e822                	sd	s0,16(sp)
  2c:	e426                	sd	s1,8(sp)
  2e:	e04a                	sd	s2,0(sp)
  30:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  32:	00001517          	auipc	a0,0x1
  36:	91e50513          	addi	a0,a0,-1762 # 950 <malloc+0xea>
  3a:	fc7ff0ef          	jal	ra,0 <print>

  for(n=0; n<N; n++){
  3e:	4481                	li	s1,0
  40:	3e800913          	li	s2,1000
    pid = fork();
  44:	332000ef          	jal	ra,376 <fork>
    if(pid < 0)
  48:	02054163          	bltz	a0,6a <forktest+0x44>
      break;
    if(pid == 0)
  4c:	cd09                	beqz	a0,66 <forktest+0x40>
  for(n=0; n<N; n++){
  4e:	2485                	addiw	s1,s1,1
  50:	ff249ae3          	bne	s1,s2,44 <forktest+0x1e>
      exit(0);
  }

  if(n == N){
    print("fork claimed to work N times!\n");
  54:	00001517          	auipc	a0,0x1
  58:	90c50513          	addi	a0,a0,-1780 # 960 <malloc+0xfa>
  5c:	fa5ff0ef          	jal	ra,0 <print>
    exit(1);
  60:	4505                	li	a0,1
  62:	31c000ef          	jal	ra,37e <exit>
      exit(0);
  66:	318000ef          	jal	ra,37e <exit>
  if(n == N){
  6a:	3e800793          	li	a5,1000
  6e:	fef483e3          	beq	s1,a5,54 <forktest+0x2e>
  }

  for(; n > 0; n--){
  72:	00905963          	blez	s1,84 <forktest+0x5e>
    if(wait(0) < 0){
  76:	4501                	li	a0,0
  78:	30e000ef          	jal	ra,386 <wait>
  7c:	02054663          	bltz	a0,a8 <forktest+0x82>
  for(; n > 0; n--){
  80:	34fd                	addiw	s1,s1,-1
  82:	f8f5                	bnez	s1,76 <forktest+0x50>
      print("wait stopped early\n");
      exit(1);
    }
  }

  if(wait(0) != -1){
  84:	4501                	li	a0,0
  86:	300000ef          	jal	ra,386 <wait>
  8a:	57fd                	li	a5,-1
  8c:	02f51763          	bne	a0,a5,ba <forktest+0x94>
    print("wait got too many\n");
    exit(1);
  }

  print("fork test OK\n");
  90:	00001517          	auipc	a0,0x1
  94:	92050513          	addi	a0,a0,-1760 # 9b0 <malloc+0x14a>
  98:	f69ff0ef          	jal	ra,0 <print>
}
  9c:	60e2                	ld	ra,24(sp)
  9e:	6442                	ld	s0,16(sp)
  a0:	64a2                	ld	s1,8(sp)
  a2:	6902                	ld	s2,0(sp)
  a4:	6105                	addi	sp,sp,32
  a6:	8082                	ret
      print("wait stopped early\n");
  a8:	00001517          	auipc	a0,0x1
  ac:	8d850513          	addi	a0,a0,-1832 # 980 <malloc+0x11a>
  b0:	f51ff0ef          	jal	ra,0 <print>
      exit(1);
  b4:	4505                	li	a0,1
  b6:	2c8000ef          	jal	ra,37e <exit>
    print("wait got too many\n");
  ba:	00001517          	auipc	a0,0x1
  be:	8de50513          	addi	a0,a0,-1826 # 998 <malloc+0x132>
  c2:	f3fff0ef          	jal	ra,0 <print>
    exit(1);
  c6:	4505                	li	a0,1
  c8:	2b6000ef          	jal	ra,37e <exit>

00000000000000cc <main>:

int
main(void)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  forktest();
  d4:	f53ff0ef          	jal	ra,26 <forktest>
  exit(0);
  d8:	4501                	li	a0,0
  da:	2a4000ef          	jal	ra,37e <exit>

00000000000000de <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  de:	1141                	addi	sp,sp,-16
  e0:	e406                	sd	ra,8(sp)
  e2:	e022                	sd	s0,0(sp)
  e4:	0800                	addi	s0,sp,16
  extern int main();
  main();
  e6:	fe7ff0ef          	jal	ra,cc <main>
  exit(0);
  ea:	4501                	li	a0,0
  ec:	292000ef          	jal	ra,37e <exit>

00000000000000f0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f0:	1141                	addi	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f6:	87aa                	mv	a5,a0
  f8:	0585                	addi	a1,a1,1
  fa:	0785                	addi	a5,a5,1
  fc:	fff5c703          	lbu	a4,-1(a1)
 100:	fee78fa3          	sb	a4,-1(a5)
 104:	fb75                	bnez	a4,f8 <strcpy+0x8>
    ;
  return os;
}
 106:	6422                	ld	s0,8(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret

000000000000010c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 112:	00054783          	lbu	a5,0(a0)
 116:	cb91                	beqz	a5,12a <strcmp+0x1e>
 118:	0005c703          	lbu	a4,0(a1)
 11c:	00f71763          	bne	a4,a5,12a <strcmp+0x1e>
    p++, q++;
 120:	0505                	addi	a0,a0,1
 122:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 124:	00054783          	lbu	a5,0(a0)
 128:	fbe5                	bnez	a5,118 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 12a:	0005c503          	lbu	a0,0(a1)
}
 12e:	40a7853b          	subw	a0,a5,a0
 132:	6422                	ld	s0,8(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret

0000000000000138 <strlen>:

uint
strlen(const char *s)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e422                	sd	s0,8(sp)
 13c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 13e:	00054783          	lbu	a5,0(a0)
 142:	cf91                	beqz	a5,15e <strlen+0x26>
 144:	0505                	addi	a0,a0,1
 146:	87aa                	mv	a5,a0
 148:	4685                	li	a3,1
 14a:	9e89                	subw	a3,a3,a0
 14c:	00f6853b          	addw	a0,a3,a5
 150:	0785                	addi	a5,a5,1
 152:	fff7c703          	lbu	a4,-1(a5)
 156:	fb7d                	bnez	a4,14c <strlen+0x14>
    ;
  return n;
}
 158:	6422                	ld	s0,8(sp)
 15a:	0141                	addi	sp,sp,16
 15c:	8082                	ret
  for(n = 0; s[n]; n++)
 15e:	4501                	li	a0,0
 160:	bfe5                	j	158 <strlen+0x20>

0000000000000162 <memset>:

void*
memset(void *dst, int c, uint n)
{
 162:	1141                	addi	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 168:	ce09                	beqz	a2,182 <memset+0x20>
 16a:	87aa                	mv	a5,a0
 16c:	fff6071b          	addiw	a4,a2,-1
 170:	1702                	slli	a4,a4,0x20
 172:	9301                	srli	a4,a4,0x20
 174:	0705                	addi	a4,a4,1
 176:	972a                	add	a4,a4,a0
    cdst[i] = c;
 178:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 17c:	0785                	addi	a5,a5,1
 17e:	fee79de3          	bne	a5,a4,178 <memset+0x16>
  }
  return dst;
}
 182:	6422                	ld	s0,8(sp)
 184:	0141                	addi	sp,sp,16
 186:	8082                	ret

0000000000000188 <strchr>:

char*
strchr(const char *s, char c)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e422                	sd	s0,8(sp)
 18c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 18e:	00054783          	lbu	a5,0(a0)
 192:	cb99                	beqz	a5,1a8 <strchr+0x20>
    if(*s == c)
 194:	00f58763          	beq	a1,a5,1a2 <strchr+0x1a>
  for(; *s; s++)
 198:	0505                	addi	a0,a0,1
 19a:	00054783          	lbu	a5,0(a0)
 19e:	fbfd                	bnez	a5,194 <strchr+0xc>
      return (char*)s;
  return 0;
 1a0:	4501                	li	a0,0
}
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret
  return 0;
 1a8:	4501                	li	a0,0
 1aa:	bfe5                	j	1a2 <strchr+0x1a>

00000000000001ac <gets>:

char*
gets(char *buf, int max)
{
 1ac:	711d                	addi	sp,sp,-96
 1ae:	ec86                	sd	ra,88(sp)
 1b0:	e8a2                	sd	s0,80(sp)
 1b2:	e4a6                	sd	s1,72(sp)
 1b4:	e0ca                	sd	s2,64(sp)
 1b6:	fc4e                	sd	s3,56(sp)
 1b8:	f852                	sd	s4,48(sp)
 1ba:	f456                	sd	s5,40(sp)
 1bc:	f05a                	sd	s6,32(sp)
 1be:	ec5e                	sd	s7,24(sp)
 1c0:	1080                	addi	s0,sp,96
 1c2:	8baa                	mv	s7,a0
 1c4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c6:	892a                	mv	s2,a0
 1c8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ca:	4aa9                	li	s5,10
 1cc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ce:	89a6                	mv	s3,s1
 1d0:	2485                	addiw	s1,s1,1
 1d2:	0344d663          	bge	s1,s4,1fe <gets+0x52>
    cc = read(0, &c, 1);
 1d6:	4605                	li	a2,1
 1d8:	faf40593          	addi	a1,s0,-81
 1dc:	4501                	li	a0,0
 1de:	1b8000ef          	jal	ra,396 <read>
    if(cc < 1)
 1e2:	00a05e63          	blez	a0,1fe <gets+0x52>
    buf[i++] = c;
 1e6:	faf44783          	lbu	a5,-81(s0)
 1ea:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ee:	01578763          	beq	a5,s5,1fc <gets+0x50>
 1f2:	0905                	addi	s2,s2,1
 1f4:	fd679de3          	bne	a5,s6,1ce <gets+0x22>
  for(i=0; i+1 < max; ){
 1f8:	89a6                	mv	s3,s1
 1fa:	a011                	j	1fe <gets+0x52>
 1fc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1fe:	99de                	add	s3,s3,s7
 200:	00098023          	sb	zero,0(s3)
  return buf;
}
 204:	855e                	mv	a0,s7
 206:	60e6                	ld	ra,88(sp)
 208:	6446                	ld	s0,80(sp)
 20a:	64a6                	ld	s1,72(sp)
 20c:	6906                	ld	s2,64(sp)
 20e:	79e2                	ld	s3,56(sp)
 210:	7a42                	ld	s4,48(sp)
 212:	7aa2                	ld	s5,40(sp)
 214:	7b02                	ld	s6,32(sp)
 216:	6be2                	ld	s7,24(sp)
 218:	6125                	addi	sp,sp,96
 21a:	8082                	ret

000000000000021c <stat>:

int
stat(const char *n, struct stat *st)
{
 21c:	1101                	addi	sp,sp,-32
 21e:	ec06                	sd	ra,24(sp)
 220:	e822                	sd	s0,16(sp)
 222:	e426                	sd	s1,8(sp)
 224:	e04a                	sd	s2,0(sp)
 226:	1000                	addi	s0,sp,32
 228:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22a:	4581                	li	a1,0
 22c:	192000ef          	jal	ra,3be <open>
  if(fd < 0)
 230:	02054163          	bltz	a0,252 <stat+0x36>
 234:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 236:	85ca                	mv	a1,s2
 238:	19e000ef          	jal	ra,3d6 <fstat>
 23c:	892a                	mv	s2,a0
  close(fd);
 23e:	8526                	mv	a0,s1
 240:	166000ef          	jal	ra,3a6 <close>
  return r;
}
 244:	854a                	mv	a0,s2
 246:	60e2                	ld	ra,24(sp)
 248:	6442                	ld	s0,16(sp)
 24a:	64a2                	ld	s1,8(sp)
 24c:	6902                	ld	s2,0(sp)
 24e:	6105                	addi	sp,sp,32
 250:	8082                	ret
    return -1;
 252:	597d                	li	s2,-1
 254:	bfc5                	j	244 <stat+0x28>

0000000000000256 <atoi>:

int
atoi(const char *s)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25c:	00054603          	lbu	a2,0(a0)
 260:	fd06079b          	addiw	a5,a2,-48
 264:	0ff7f793          	andi	a5,a5,255
 268:	4725                	li	a4,9
 26a:	02f76963          	bltu	a4,a5,29c <atoi+0x46>
 26e:	86aa                	mv	a3,a0
  n = 0;
 270:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 272:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 274:	0685                	addi	a3,a3,1
 276:	0025179b          	slliw	a5,a0,0x2
 27a:	9fa9                	addw	a5,a5,a0
 27c:	0017979b          	slliw	a5,a5,0x1
 280:	9fb1                	addw	a5,a5,a2
 282:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 286:	0006c603          	lbu	a2,0(a3)
 28a:	fd06071b          	addiw	a4,a2,-48
 28e:	0ff77713          	andi	a4,a4,255
 292:	fee5f1e3          	bgeu	a1,a4,274 <atoi+0x1e>
  return n;
}
 296:	6422                	ld	s0,8(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
  n = 0;
 29c:	4501                	li	a0,0
 29e:	bfe5                	j	296 <atoi+0x40>

00000000000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e422                	sd	s0,8(sp)
 2a4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a6:	02b57663          	bgeu	a0,a1,2d2 <memmove+0x32>
    while(n-- > 0)
 2aa:	02c05163          	blez	a2,2cc <memmove+0x2c>
 2ae:	fff6079b          	addiw	a5,a2,-1
 2b2:	1782                	slli	a5,a5,0x20
 2b4:	9381                	srli	a5,a5,0x20
 2b6:	0785                	addi	a5,a5,1
 2b8:	97aa                	add	a5,a5,a0
  dst = vdst;
 2ba:	872a                	mv	a4,a0
      *dst++ = *src++;
 2bc:	0585                	addi	a1,a1,1
 2be:	0705                	addi	a4,a4,1
 2c0:	fff5c683          	lbu	a3,-1(a1)
 2c4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c8:	fee79ae3          	bne	a5,a4,2bc <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
    dst += n;
 2d2:	00c50733          	add	a4,a0,a2
    src += n;
 2d6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2d8:	fec05ae3          	blez	a2,2cc <memmove+0x2c>
 2dc:	fff6079b          	addiw	a5,a2,-1
 2e0:	1782                	slli	a5,a5,0x20
 2e2:	9381                	srli	a5,a5,0x20
 2e4:	fff7c793          	not	a5,a5
 2e8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ea:	15fd                	addi	a1,a1,-1
 2ec:	177d                	addi	a4,a4,-1
 2ee:	0005c683          	lbu	a3,0(a1)
 2f2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f6:	fee79ae3          	bne	a5,a4,2ea <memmove+0x4a>
 2fa:	bfc9                	j	2cc <memmove+0x2c>

00000000000002fc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e422                	sd	s0,8(sp)
 300:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 302:	ca05                	beqz	a2,332 <memcmp+0x36>
 304:	fff6069b          	addiw	a3,a2,-1
 308:	1682                	slli	a3,a3,0x20
 30a:	9281                	srli	a3,a3,0x20
 30c:	0685                	addi	a3,a3,1
 30e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 310:	00054783          	lbu	a5,0(a0)
 314:	0005c703          	lbu	a4,0(a1)
 318:	00e79863          	bne	a5,a4,328 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 31c:	0505                	addi	a0,a0,1
    p2++;
 31e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 320:	fed518e3          	bne	a0,a3,310 <memcmp+0x14>
  }
  return 0;
 324:	4501                	li	a0,0
 326:	a019                	j	32c <memcmp+0x30>
      return *p1 - *p2;
 328:	40e7853b          	subw	a0,a5,a4
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  return 0;
 332:	4501                	li	a0,0
 334:	bfe5                	j	32c <memcmp+0x30>

0000000000000336 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 33e:	f63ff0ef          	jal	ra,2a0 <memmove>
}
 342:	60a2                	ld	ra,8(sp)
 344:	6402                	ld	s0,0(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret

000000000000034a <sbrk>:

char *
sbrk(int n) {
 34a:	1141                	addi	sp,sp,-16
 34c:	e406                	sd	ra,8(sp)
 34e:	e022                	sd	s0,0(sp)
 350:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 352:	4585                	li	a1,1
 354:	0b2000ef          	jal	ra,406 <sys_sbrk>
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <sbrklazy>:

char *
sbrklazy(int n) {
 360:	1141                	addi	sp,sp,-16
 362:	e406                	sd	ra,8(sp)
 364:	e022                	sd	s0,0(sp)
 366:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 368:	4589                	li	a1,2
 36a:	09c000ef          	jal	ra,406 <sys_sbrk>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 376:	4885                	li	a7,1
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <exit>:
.global exit
exit:
 li a7, SYS_exit
 37e:	4889                	li	a7,2
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <wait>:
.global wait
wait:
 li a7, SYS_wait
 386:	488d                	li	a7,3
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38e:	4891                	li	a7,4
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <read>:
.global read
read:
 li a7, SYS_read
 396:	4895                	li	a7,5
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <write>:
.global write
write:
 li a7, SYS_write
 39e:	48c1                	li	a7,16
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <close>:
.global close
close:
 li a7, SYS_close
 3a6:	48d5                	li	a7,21
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ae:	4899                	li	a7,6
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b6:	489d                	li	a7,7
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <open>:
.global open
open:
 li a7, SYS_open
 3be:	48bd                	li	a7,15
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c6:	48c5                	li	a7,17
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ce:	48c9                	li	a7,18
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d6:	48a1                	li	a7,8
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <link>:
.global link
link:
 li a7, SYS_link
 3de:	48cd                	li	a7,19
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e6:	48d1                	li	a7,20
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ee:	48a5                	li	a7,9
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f6:	48a9                	li	a7,10
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fe:	48ad                	li	a7,11
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 406:	48b1                	li	a7,12
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <pause>:
.global pause
pause:
 li a7, SYS_pause
 40e:	48b5                	li	a7,13
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 416:	48b9                	li	a7,14
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <getproctree>:
.global getproctree
getproctree:
 li a7, SYS_getproctree
 41e:	48d9                	li	a7,22
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 426:	1101                	addi	sp,sp,-32
 428:	ec06                	sd	ra,24(sp)
 42a:	e822                	sd	s0,16(sp)
 42c:	1000                	addi	s0,sp,32
 42e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 432:	4605                	li	a2,1
 434:	fef40593          	addi	a1,s0,-17
 438:	f67ff0ef          	jal	ra,39e <write>
}
 43c:	60e2                	ld	ra,24(sp)
 43e:	6442                	ld	s0,16(sp)
 440:	6105                	addi	sp,sp,32
 442:	8082                	ret

0000000000000444 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 444:	715d                	addi	sp,sp,-80
 446:	e486                	sd	ra,72(sp)
 448:	e0a2                	sd	s0,64(sp)
 44a:	fc26                	sd	s1,56(sp)
 44c:	f84a                	sd	s2,48(sp)
 44e:	f44e                	sd	s3,40(sp)
 450:	0880                	addi	s0,sp,80
 452:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 454:	c299                	beqz	a3,45a <printint+0x16>
 456:	0805c663          	bltz	a1,4e2 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 45a:	2581                	sext.w	a1,a1
  neg = 0;
 45c:	4881                	li	a7,0
 45e:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 462:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 464:	2601                	sext.w	a2,a2
 466:	00000517          	auipc	a0,0x0
 46a:	56250513          	addi	a0,a0,1378 # 9c8 <digits>
 46e:	883a                	mv	a6,a4
 470:	2705                	addiw	a4,a4,1
 472:	02c5f7bb          	remuw	a5,a1,a2
 476:	1782                	slli	a5,a5,0x20
 478:	9381                	srli	a5,a5,0x20
 47a:	97aa                	add	a5,a5,a0
 47c:	0007c783          	lbu	a5,0(a5)
 480:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 484:	0005879b          	sext.w	a5,a1
 488:	02c5d5bb          	divuw	a1,a1,a2
 48c:	0685                	addi	a3,a3,1
 48e:	fec7f0e3          	bgeu	a5,a2,46e <printint+0x2a>
  if(neg)
 492:	00088b63          	beqz	a7,4a8 <printint+0x64>
    buf[i++] = '-';
 496:	fd040793          	addi	a5,s0,-48
 49a:	973e                	add	a4,a4,a5
 49c:	02d00793          	li	a5,45
 4a0:	fef70423          	sb	a5,-24(a4)
 4a4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4a8:	02e05663          	blez	a4,4d4 <printint+0x90>
 4ac:	fb840793          	addi	a5,s0,-72
 4b0:	00e78933          	add	s2,a5,a4
 4b4:	fff78993          	addi	s3,a5,-1
 4b8:	99ba                	add	s3,s3,a4
 4ba:	377d                	addiw	a4,a4,-1
 4bc:	1702                	slli	a4,a4,0x20
 4be:	9301                	srli	a4,a4,0x20
 4c0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4c4:	fff94583          	lbu	a1,-1(s2)
 4c8:	8526                	mv	a0,s1
 4ca:	f5dff0ef          	jal	ra,426 <putc>
  while(--i >= 0)
 4ce:	197d                	addi	s2,s2,-1
 4d0:	ff391ae3          	bne	s2,s3,4c4 <printint+0x80>
}
 4d4:	60a6                	ld	ra,72(sp)
 4d6:	6406                	ld	s0,64(sp)
 4d8:	74e2                	ld	s1,56(sp)
 4da:	7942                	ld	s2,48(sp)
 4dc:	79a2                	ld	s3,40(sp)
 4de:	6161                	addi	sp,sp,80
 4e0:	8082                	ret
    x = -xx;
 4e2:	40b005bb          	negw	a1,a1
    neg = 1;
 4e6:	4885                	li	a7,1
    x = -xx;
 4e8:	bf9d                	j	45e <printint+0x1a>

00000000000004ea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ea:	7119                	addi	sp,sp,-128
 4ec:	fc86                	sd	ra,120(sp)
 4ee:	f8a2                	sd	s0,112(sp)
 4f0:	f4a6                	sd	s1,104(sp)
 4f2:	f0ca                	sd	s2,96(sp)
 4f4:	ecce                	sd	s3,88(sp)
 4f6:	e8d2                	sd	s4,80(sp)
 4f8:	e4d6                	sd	s5,72(sp)
 4fa:	e0da                	sd	s6,64(sp)
 4fc:	fc5e                	sd	s7,56(sp)
 4fe:	f862                	sd	s8,48(sp)
 500:	f466                	sd	s9,40(sp)
 502:	f06a                	sd	s10,32(sp)
 504:	ec6e                	sd	s11,24(sp)
 506:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 508:	0005c903          	lbu	s2,0(a1)
 50c:	24090c63          	beqz	s2,764 <vprintf+0x27a>
 510:	8b2a                	mv	s6,a0
 512:	8a2e                	mv	s4,a1
 514:	8bb2                	mv	s7,a2
  state = 0;
 516:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 518:	4481                	li	s1,0
 51a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 51c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 520:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 524:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 528:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 52c:	00000c97          	auipc	s9,0x0
 530:	49cc8c93          	addi	s9,s9,1180 # 9c8 <digits>
 534:	a005                	j	554 <vprintf+0x6a>
        putc(fd, c0);
 536:	85ca                	mv	a1,s2
 538:	855a                	mv	a0,s6
 53a:	eedff0ef          	jal	ra,426 <putc>
 53e:	a019                	j	544 <vprintf+0x5a>
    } else if(state == '%'){
 540:	03598263          	beq	s3,s5,564 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 544:	2485                	addiw	s1,s1,1
 546:	8726                	mv	a4,s1
 548:	009a07b3          	add	a5,s4,s1
 54c:	0007c903          	lbu	s2,0(a5)
 550:	20090a63          	beqz	s2,764 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 554:	0009079b          	sext.w	a5,s2
    if(state == 0){
 558:	fe0994e3          	bnez	s3,540 <vprintf+0x56>
      if(c0 == '%'){
 55c:	fd579de3          	bne	a5,s5,536 <vprintf+0x4c>
        state = '%';
 560:	89be                	mv	s3,a5
 562:	b7cd                	j	544 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 564:	c3c1                	beqz	a5,5e4 <vprintf+0xfa>
 566:	00ea06b3          	add	a3,s4,a4
 56a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 56e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 570:	c681                	beqz	a3,578 <vprintf+0x8e>
 572:	9752                	add	a4,a4,s4
 574:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 578:	03878e63          	beq	a5,s8,5b4 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 57c:	05a78863          	beq	a5,s10,5cc <vprintf+0xe2>
      } else if(c0 == 'u'){
 580:	0db78b63          	beq	a5,s11,656 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 584:	07800713          	li	a4,120
 588:	10e78d63          	beq	a5,a4,6a2 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 58c:	07000713          	li	a4,112
 590:	14e78263          	beq	a5,a4,6d4 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 594:	06300713          	li	a4,99
 598:	16e78f63          	beq	a5,a4,716 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 59c:	07300713          	li	a4,115
 5a0:	18e78563          	beq	a5,a4,72a <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5a4:	05579063          	bne	a5,s5,5e4 <vprintf+0xfa>
        putc(fd, '%');
 5a8:	85d6                	mv	a1,s5
 5aa:	855a                	mv	a0,s6
 5ac:	e7bff0ef          	jal	ra,426 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	bf49                	j	544 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 5b4:	008b8913          	addi	s2,s7,8
 5b8:	4685                	li	a3,1
 5ba:	4629                	li	a2,10
 5bc:	000ba583          	lw	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	e83ff0ef          	jal	ra,444 <printint>
 5c6:	8bca                	mv	s7,s2
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	bfad                	j	544 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 5cc:	03868663          	beq	a3,s8,5f8 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d0:	05a68163          	beq	a3,s10,612 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 5d4:	09b68d63          	beq	a3,s11,66e <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5d8:	03a68f63          	beq	a3,s10,616 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 5dc:	07800793          	li	a5,120
 5e0:	0cf68d63          	beq	a3,a5,6ba <vprintf+0x1d0>
        putc(fd, '%');
 5e4:	85d6                	mv	a1,s5
 5e6:	855a                	mv	a0,s6
 5e8:	e3fff0ef          	jal	ra,426 <putc>
        putc(fd, c0);
 5ec:	85ca                	mv	a1,s2
 5ee:	855a                	mv	a0,s6
 5f0:	e37ff0ef          	jal	ra,426 <putc>
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b7b9                	j	544 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f8:	008b8913          	addi	s2,s7,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000bb583          	ld	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	e3fff0ef          	jal	ra,444 <printint>
        i += 1;
 60a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	8bca                	mv	s7,s2
      state = 0;
 60e:	4981                	li	s3,0
        i += 1;
 610:	bf15                	j	544 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 612:	03860563          	beq	a2,s8,63c <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 616:	07b60963          	beq	a2,s11,688 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 61a:	07800793          	li	a5,120
 61e:	fcf613e3          	bne	a2,a5,5e4 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 622:	008b8913          	addi	s2,s7,8
 626:	4681                	li	a3,0
 628:	4641                	li	a2,16
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	e15ff0ef          	jal	ra,444 <printint>
        i += 2;
 634:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
        i += 2;
 63a:	b729                	j	544 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63c:	008b8913          	addi	s2,s7,8
 640:	4685                	li	a3,1
 642:	4629                	li	a2,10
 644:	000bb583          	ld	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	dfbff0ef          	jal	ra,444 <printint>
        i += 2;
 64e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 650:	8bca                	mv	s7,s2
      state = 0;
 652:	4981                	li	s3,0
        i += 2;
 654:	bdc5                	j	544 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 656:	008b8913          	addi	s2,s7,8
 65a:	4681                	li	a3,0
 65c:	4629                	li	a2,10
 65e:	000be583          	lwu	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	de1ff0ef          	jal	ra,444 <printint>
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bde1                	j	544 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 66e:	008b8913          	addi	s2,s7,8
 672:	4681                	li	a3,0
 674:	4629                	li	a2,10
 676:	000bb583          	ld	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	dc9ff0ef          	jal	ra,444 <printint>
        i += 1;
 680:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
        i += 1;
 686:	bd7d                	j	544 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	008b8913          	addi	s2,s7,8
 68c:	4681                	li	a3,0
 68e:	4629                	li	a2,10
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	dafff0ef          	jal	ra,444 <printint>
        i += 2;
 69a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 69c:	8bca                	mv	s7,s2
      state = 0;
 69e:	4981                	li	s3,0
        i += 2;
 6a0:	b555                	j	544 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6a2:	008b8913          	addi	s2,s7,8
 6a6:	4681                	li	a3,0
 6a8:	4641                	li	a2,16
 6aa:	000be583          	lwu	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	d95ff0ef          	jal	ra,444 <printint>
 6b4:	8bca                	mv	s7,s2
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b571                	j	544 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ba:	008b8913          	addi	s2,s7,8
 6be:	4681                	li	a3,0
 6c0:	4641                	li	a2,16
 6c2:	000bb583          	ld	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	d7dff0ef          	jal	ra,444 <printint>
        i += 1;
 6cc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ce:	8bca                	mv	s7,s2
      state = 0;
 6d0:	4981                	li	s3,0
        i += 1;
 6d2:	bd8d                	j	544 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 6d4:	008b8793          	addi	a5,s7,8
 6d8:	f8f43423          	sd	a5,-120(s0)
 6dc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e0:	03000593          	li	a1,48
 6e4:	855a                	mv	a0,s6
 6e6:	d41ff0ef          	jal	ra,426 <putc>
  putc(fd, 'x');
 6ea:	07800593          	li	a1,120
 6ee:	855a                	mv	a0,s6
 6f0:	d37ff0ef          	jal	ra,426 <putc>
 6f4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f6:	03c9d793          	srli	a5,s3,0x3c
 6fa:	97e6                	add	a5,a5,s9
 6fc:	0007c583          	lbu	a1,0(a5)
 700:	855a                	mv	a0,s6
 702:	d25ff0ef          	jal	ra,426 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 706:	0992                	slli	s3,s3,0x4
 708:	397d                	addiw	s2,s2,-1
 70a:	fe0916e3          	bnez	s2,6f6 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 70e:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 712:	4981                	li	s3,0
 714:	bd05                	j	544 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 716:	008b8913          	addi	s2,s7,8
 71a:	000bc583          	lbu	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	d07ff0ef          	jal	ra,426 <putc>
 724:	8bca                	mv	s7,s2
      state = 0;
 726:	4981                	li	s3,0
 728:	bd31                	j	544 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 72a:	008b8993          	addi	s3,s7,8
 72e:	000bb903          	ld	s2,0(s7)
 732:	00090f63          	beqz	s2,750 <vprintf+0x266>
        for(; *s; s++)
 736:	00094583          	lbu	a1,0(s2)
 73a:	c195                	beqz	a1,75e <vprintf+0x274>
          putc(fd, *s);
 73c:	855a                	mv	a0,s6
 73e:	ce9ff0ef          	jal	ra,426 <putc>
        for(; *s; s++)
 742:	0905                	addi	s2,s2,1
 744:	00094583          	lbu	a1,0(s2)
 748:	f9f5                	bnez	a1,73c <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 74a:	8bce                	mv	s7,s3
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bbdd                	j	544 <vprintf+0x5a>
          s = "(null)";
 750:	00000917          	auipc	s2,0x0
 754:	27090913          	addi	s2,s2,624 # 9c0 <malloc+0x15a>
        for(; *s; s++)
 758:	02800593          	li	a1,40
 75c:	b7c5                	j	73c <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 75e:	8bce                	mv	s7,s3
      state = 0;
 760:	4981                	li	s3,0
 762:	b3cd                	j	544 <vprintf+0x5a>
    }
  }
}
 764:	70e6                	ld	ra,120(sp)
 766:	7446                	ld	s0,112(sp)
 768:	74a6                	ld	s1,104(sp)
 76a:	7906                	ld	s2,96(sp)
 76c:	69e6                	ld	s3,88(sp)
 76e:	6a46                	ld	s4,80(sp)
 770:	6aa6                	ld	s5,72(sp)
 772:	6b06                	ld	s6,64(sp)
 774:	7be2                	ld	s7,56(sp)
 776:	7c42                	ld	s8,48(sp)
 778:	7ca2                	ld	s9,40(sp)
 77a:	7d02                	ld	s10,32(sp)
 77c:	6de2                	ld	s11,24(sp)
 77e:	6109                	addi	sp,sp,128
 780:	8082                	ret

0000000000000782 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 782:	715d                	addi	sp,sp,-80
 784:	ec06                	sd	ra,24(sp)
 786:	e822                	sd	s0,16(sp)
 788:	1000                	addi	s0,sp,32
 78a:	e010                	sd	a2,0(s0)
 78c:	e414                	sd	a3,8(s0)
 78e:	e818                	sd	a4,16(s0)
 790:	ec1c                	sd	a5,24(s0)
 792:	03043023          	sd	a6,32(s0)
 796:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79e:	8622                	mv	a2,s0
 7a0:	d4bff0ef          	jal	ra,4ea <vprintf>
}
 7a4:	60e2                	ld	ra,24(sp)
 7a6:	6442                	ld	s0,16(sp)
 7a8:	6161                	addi	sp,sp,80
 7aa:	8082                	ret

00000000000007ac <printf>:

void
printf(const char *fmt, ...)
{
 7ac:	711d                	addi	sp,sp,-96
 7ae:	ec06                	sd	ra,24(sp)
 7b0:	e822                	sd	s0,16(sp)
 7b2:	1000                	addi	s0,sp,32
 7b4:	e40c                	sd	a1,8(s0)
 7b6:	e810                	sd	a2,16(s0)
 7b8:	ec14                	sd	a3,24(s0)
 7ba:	f018                	sd	a4,32(s0)
 7bc:	f41c                	sd	a5,40(s0)
 7be:	03043823          	sd	a6,48(s0)
 7c2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c6:	00840613          	addi	a2,s0,8
 7ca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ce:	85aa                	mv	a1,a0
 7d0:	4505                	li	a0,1
 7d2:	d19ff0ef          	jal	ra,4ea <vprintf>
}
 7d6:	60e2                	ld	ra,24(sp)
 7d8:	6442                	ld	s0,16(sp)
 7da:	6125                	addi	sp,sp,96
 7dc:	8082                	ret

00000000000007de <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7de:	1141                	addi	sp,sp,-16
 7e0:	e422                	sd	s0,8(sp)
 7e2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e8:	00001797          	auipc	a5,0x1
 7ec:	8187b783          	ld	a5,-2024(a5) # 1000 <freep>
 7f0:	a805                	j	820 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7f2:	4618                	lw	a4,8(a2)
 7f4:	9db9                	addw	a1,a1,a4
 7f6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fa:	6398                	ld	a4,0(a5)
 7fc:	6318                	ld	a4,0(a4)
 7fe:	fee53823          	sd	a4,-16(a0)
 802:	a091                	j	846 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 804:	ff852703          	lw	a4,-8(a0)
 808:	9e39                	addw	a2,a2,a4
 80a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 80c:	ff053703          	ld	a4,-16(a0)
 810:	e398                	sd	a4,0(a5)
 812:	a099                	j	858 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 814:	6398                	ld	a4,0(a5)
 816:	00e7e463          	bltu	a5,a4,81e <free+0x40>
 81a:	00e6ea63          	bltu	a3,a4,82e <free+0x50>
{
 81e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 820:	fed7fae3          	bgeu	a5,a3,814 <free+0x36>
 824:	6398                	ld	a4,0(a5)
 826:	00e6e463          	bltu	a3,a4,82e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82a:	fee7eae3          	bltu	a5,a4,81e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 82e:	ff852583          	lw	a1,-8(a0)
 832:	6390                	ld	a2,0(a5)
 834:	02059713          	slli	a4,a1,0x20
 838:	9301                	srli	a4,a4,0x20
 83a:	0712                	slli	a4,a4,0x4
 83c:	9736                	add	a4,a4,a3
 83e:	fae60ae3          	beq	a2,a4,7f2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 842:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 846:	4790                	lw	a2,8(a5)
 848:	02061713          	slli	a4,a2,0x20
 84c:	9301                	srli	a4,a4,0x20
 84e:	0712                	slli	a4,a4,0x4
 850:	973e                	add	a4,a4,a5
 852:	fae689e3          	beq	a3,a4,804 <free+0x26>
  } else
    p->s.ptr = bp;
 856:	e394                	sd	a3,0(a5)
  freep = p;
 858:	00000717          	auipc	a4,0x0
 85c:	7af73423          	sd	a5,1960(a4) # 1000 <freep>
}
 860:	6422                	ld	s0,8(sp)
 862:	0141                	addi	sp,sp,16
 864:	8082                	ret

0000000000000866 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 866:	7139                	addi	sp,sp,-64
 868:	fc06                	sd	ra,56(sp)
 86a:	f822                	sd	s0,48(sp)
 86c:	f426                	sd	s1,40(sp)
 86e:	f04a                	sd	s2,32(sp)
 870:	ec4e                	sd	s3,24(sp)
 872:	e852                	sd	s4,16(sp)
 874:	e456                	sd	s5,8(sp)
 876:	e05a                	sd	s6,0(sp)
 878:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87a:	02051493          	slli	s1,a0,0x20
 87e:	9081                	srli	s1,s1,0x20
 880:	04bd                	addi	s1,s1,15
 882:	8091                	srli	s1,s1,0x4
 884:	0014899b          	addiw	s3,s1,1
 888:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 88a:	00000517          	auipc	a0,0x0
 88e:	77653503          	ld	a0,1910(a0) # 1000 <freep>
 892:	c515                	beqz	a0,8be <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 894:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 896:	4798                	lw	a4,8(a5)
 898:	02977f63          	bgeu	a4,s1,8d6 <malloc+0x70>
 89c:	8a4e                	mv	s4,s3
 89e:	0009871b          	sext.w	a4,s3
 8a2:	6685                	lui	a3,0x1
 8a4:	00d77363          	bgeu	a4,a3,8aa <malloc+0x44>
 8a8:	6a05                	lui	s4,0x1
 8aa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b2:	00000917          	auipc	s2,0x0
 8b6:	74e90913          	addi	s2,s2,1870 # 1000 <freep>
  if(p == SBRK_ERROR)
 8ba:	5afd                	li	s5,-1
 8bc:	a0bd                	j	92a <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 8be:	00000797          	auipc	a5,0x0
 8c2:	75278793          	addi	a5,a5,1874 # 1010 <base>
 8c6:	00000717          	auipc	a4,0x0
 8ca:	72f73d23          	sd	a5,1850(a4) # 1000 <freep>
 8ce:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8d4:	b7e1                	j	89c <malloc+0x36>
      if(p->s.size == nunits)
 8d6:	02e48b63          	beq	s1,a4,90c <malloc+0xa6>
        p->s.size -= nunits;
 8da:	4137073b          	subw	a4,a4,s3
 8de:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e0:	1702                	slli	a4,a4,0x20
 8e2:	9301                	srli	a4,a4,0x20
 8e4:	0712                	slli	a4,a4,0x4
 8e6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ec:	00000717          	auipc	a4,0x0
 8f0:	70a73a23          	sd	a0,1812(a4) # 1000 <freep>
      return (void*)(p + 1);
 8f4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8f8:	70e2                	ld	ra,56(sp)
 8fa:	7442                	ld	s0,48(sp)
 8fc:	74a2                	ld	s1,40(sp)
 8fe:	7902                	ld	s2,32(sp)
 900:	69e2                	ld	s3,24(sp)
 902:	6a42                	ld	s4,16(sp)
 904:	6aa2                	ld	s5,8(sp)
 906:	6b02                	ld	s6,0(sp)
 908:	6121                	addi	sp,sp,64
 90a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 90c:	6398                	ld	a4,0(a5)
 90e:	e118                	sd	a4,0(a0)
 910:	bff1                	j	8ec <malloc+0x86>
  hp->s.size = nu;
 912:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 916:	0541                	addi	a0,a0,16
 918:	ec7ff0ef          	jal	ra,7de <free>
  return freep;
 91c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 920:	dd61                	beqz	a0,8f8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 922:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 924:	4798                	lw	a4,8(a5)
 926:	fa9778e3          	bgeu	a4,s1,8d6 <malloc+0x70>
    if(p == freep)
 92a:	00093703          	ld	a4,0(s2)
 92e:	853e                	mv	a0,a5
 930:	fef719e3          	bne	a4,a5,922 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 934:	8552                	mv	a0,s4
 936:	a15ff0ef          	jal	ra,34a <sbrk>
  if(p == SBRK_ERROR)
 93a:	fd551ce3          	bne	a0,s5,912 <malloc+0xac>
        return 0;
 93e:	4501                	li	a0,0
 940:	bf65                	j	8f8 <malloc+0x92>
