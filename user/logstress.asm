
user/_logstress:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
main(int argc, char **argv)
{
  int fd, n;
  enum { N = 250, SZ=2000 };
  
  for (int i = 1; i < argc; i++){
   0:	4785                	li	a5,1
   2:	0ea7de63          	bge	a5,a0,fe <main+0xfe>
{
   6:	7139                	addi	sp,sp,-64
   8:	fc06                	sd	ra,56(sp)
   a:	f822                	sd	s0,48(sp)
   c:	f426                	sd	s1,40(sp)
   e:	f04a                	sd	s2,32(sp)
  10:	ec4e                	sd	s3,24(sp)
  12:	e852                	sd	s4,16(sp)
  14:	0080                	addi	s0,sp,64
  16:	892a                	mv	s2,a0
  18:	89ae                	mv	s3,a1
  for (int i = 1; i < argc; i++){
  1a:	4485                	li	s1,1
  1c:	a011                	j	20 <main+0x20>
  1e:	84be                	mv	s1,a5
    int pid1 = fork();
  20:	37a000ef          	jal	ra,39a <fork>
    if(pid1 < 0){
  24:	00054963          	bltz	a0,36 <main+0x36>
      printf("%s: fork failed\n", argv[0]);
      exit(1);
    }
    if(pid1 == 0) {
  28:	c115                	beqz	a0,4c <main+0x4c>
  for (int i = 1; i < argc; i++){
  2a:	0014879b          	addiw	a5,s1,1
  2e:	fef918e3          	bne	s2,a5,1e <main+0x1e>
  32:	4905                	li	s2,1
  34:	a879                	j	d2 <main+0xd2>
      printf("%s: fork failed\n", argv[0]);
  36:	0009b583          	ld	a1,0(s3)
  3a:	00001517          	auipc	a0,0x1
  3e:	92650513          	addi	a0,a0,-1754 # 960 <malloc+0xde>
  42:	786000ef          	jal	ra,7c8 <printf>
      exit(1);
  46:	4505                	li	a0,1
  48:	35a000ef          	jal	ra,3a2 <exit>
      fd = open(argv[i], O_CREATE | O_RDWR);
  4c:	00349a13          	slli	s4,s1,0x3
  50:	9a4e                	add	s4,s4,s3
  52:	20200593          	li	a1,514
  56:	000a3503          	ld	a0,0(s4)
  5a:	388000ef          	jal	ra,3e2 <open>
  5e:	892a                	mv	s2,a0
      if(fd < 0){
  60:	04054163          	bltz	a0,a2 <main+0xa2>
        printf("%s: create %s failed\n", argv[0], argv[i]);
        exit(1);
      }
      memset(buf, '0'+i, SZ);
  64:	7d000613          	li	a2,2000
  68:	0304859b          	addiw	a1,s1,48
  6c:	00001517          	auipc	a0,0x1
  70:	fa450513          	addi	a0,a0,-92 # 1010 <buf>
  74:	112000ef          	jal	ra,186 <memset>
  78:	0fa00493          	li	s1,250
      for(i = 0; i < N; i++){
        if((n = write(fd, buf, SZ)) != SZ){
  7c:	00001997          	auipc	s3,0x1
  80:	f9498993          	addi	s3,s3,-108 # 1010 <buf>
  84:	7d000613          	li	a2,2000
  88:	85ce                	mv	a1,s3
  8a:	854a                	mv	a0,s2
  8c:	336000ef          	jal	ra,3c2 <write>
  90:	7d000793          	li	a5,2000
  94:	02f51463          	bne	a0,a5,bc <main+0xbc>
      for(i = 0; i < N; i++){
  98:	34fd                	addiw	s1,s1,-1
  9a:	f4ed                	bnez	s1,84 <main+0x84>
          printf("write failed %d\n", n);
          exit(1);
        }
      }
      exit(0);
  9c:	4501                	li	a0,0
  9e:	304000ef          	jal	ra,3a2 <exit>
        printf("%s: create %s failed\n", argv[0], argv[i]);
  a2:	000a3603          	ld	a2,0(s4)
  a6:	0009b583          	ld	a1,0(s3)
  aa:	00001517          	auipc	a0,0x1
  ae:	8ce50513          	addi	a0,a0,-1842 # 978 <malloc+0xf6>
  b2:	716000ef          	jal	ra,7c8 <printf>
        exit(1);
  b6:	4505                	li	a0,1
  b8:	2ea000ef          	jal	ra,3a2 <exit>
          printf("write failed %d\n", n);
  bc:	85aa                	mv	a1,a0
  be:	00001517          	auipc	a0,0x1
  c2:	8d250513          	addi	a0,a0,-1838 # 990 <malloc+0x10e>
  c6:	702000ef          	jal	ra,7c8 <printf>
          exit(1);
  ca:	4505                	li	a0,1
  cc:	2d6000ef          	jal	ra,3a2 <exit>
    }
  }
  int xstatus;
  for(int i = 1; i < argc; i++){
  d0:	893e                	mv	s2,a5
    wait(&xstatus);
  d2:	fcc40513          	addi	a0,s0,-52
  d6:	2d4000ef          	jal	ra,3aa <wait>
    if(xstatus != 0)
  da:	fcc42503          	lw	a0,-52(s0)
  de:	ed11                	bnez	a0,fa <main+0xfa>
  for(int i = 1; i < argc; i++){
  e0:	0019079b          	addiw	a5,s2,1
  e4:	ff2496e3          	bne	s1,s2,d0 <main+0xd0>
      exit(xstatus);
  }
  return 0;
}
  e8:	4501                	li	a0,0
  ea:	70e2                	ld	ra,56(sp)
  ec:	7442                	ld	s0,48(sp)
  ee:	74a2                	ld	s1,40(sp)
  f0:	7902                	ld	s2,32(sp)
  f2:	69e2                	ld	s3,24(sp)
  f4:	6a42                	ld	s4,16(sp)
  f6:	6121                	addi	sp,sp,64
  f8:	8082                	ret
      exit(xstatus);
  fa:	2a8000ef          	jal	ra,3a2 <exit>
}
  fe:	4501                	li	a0,0
 100:	8082                	ret

0000000000000102 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  extern int main();
  main();
 10a:	ef7ff0ef          	jal	ra,0 <main>
  exit(0);
 10e:	4501                	li	a0,0
 110:	292000ef          	jal	ra,3a2 <exit>

0000000000000114 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11a:	87aa                	mv	a5,a0
 11c:	0585                	addi	a1,a1,1
 11e:	0785                	addi	a5,a5,1
 120:	fff5c703          	lbu	a4,-1(a1)
 124:	fee78fa3          	sb	a4,-1(a5)
 128:	fb75                	bnez	a4,11c <strcpy+0x8>
    ;
  return os;
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cb91                	beqz	a5,14e <strcmp+0x1e>
 13c:	0005c703          	lbu	a4,0(a1)
 140:	00f71763          	bne	a4,a5,14e <strcmp+0x1e>
    p++, q++;
 144:	0505                	addi	a0,a0,1
 146:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 148:	00054783          	lbu	a5,0(a0)
 14c:	fbe5                	bnez	a5,13c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14e:	0005c503          	lbu	a0,0(a1)
}
 152:	40a7853b          	subw	a0,a5,a0
 156:	6422                	ld	s0,8(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret

000000000000015c <strlen>:

uint
strlen(const char *s)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 162:	00054783          	lbu	a5,0(a0)
 166:	cf91                	beqz	a5,182 <strlen+0x26>
 168:	0505                	addi	a0,a0,1
 16a:	87aa                	mv	a5,a0
 16c:	4685                	li	a3,1
 16e:	9e89                	subw	a3,a3,a0
 170:	00f6853b          	addw	a0,a3,a5
 174:	0785                	addi	a5,a5,1
 176:	fff7c703          	lbu	a4,-1(a5)
 17a:	fb7d                	bnez	a4,170 <strlen+0x14>
    ;
  return n;
}
 17c:	6422                	ld	s0,8(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret
  for(n = 0; s[n]; n++)
 182:	4501                	li	a0,0
 184:	bfe5                	j	17c <strlen+0x20>

0000000000000186 <memset>:

void*
memset(void *dst, int c, uint n)
{
 186:	1141                	addi	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18c:	ce09                	beqz	a2,1a6 <memset+0x20>
 18e:	87aa                	mv	a5,a0
 190:	fff6071b          	addiw	a4,a2,-1
 194:	1702                	slli	a4,a4,0x20
 196:	9301                	srli	a4,a4,0x20
 198:	0705                	addi	a4,a4,1
 19a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 19c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a0:	0785                	addi	a5,a5,1
 1a2:	fee79de3          	bne	a5,a4,19c <memset+0x16>
  }
  return dst;
}
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret

00000000000001ac <strchr>:

char*
strchr(const char *s, char c)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e422                	sd	s0,8(sp)
 1b0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	cb99                	beqz	a5,1cc <strchr+0x20>
    if(*s == c)
 1b8:	00f58763          	beq	a1,a5,1c6 <strchr+0x1a>
  for(; *s; s++)
 1bc:	0505                	addi	a0,a0,1
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	fbfd                	bnez	a5,1b8 <strchr+0xc>
      return (char*)s;
  return 0;
 1c4:	4501                	li	a0,0
}
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret
  return 0;
 1cc:	4501                	li	a0,0
 1ce:	bfe5                	j	1c6 <strchr+0x1a>

00000000000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	711d                	addi	sp,sp,-96
 1d2:	ec86                	sd	ra,88(sp)
 1d4:	e8a2                	sd	s0,80(sp)
 1d6:	e4a6                	sd	s1,72(sp)
 1d8:	e0ca                	sd	s2,64(sp)
 1da:	fc4e                	sd	s3,56(sp)
 1dc:	f852                	sd	s4,48(sp)
 1de:	f456                	sd	s5,40(sp)
 1e0:	f05a                	sd	s6,32(sp)
 1e2:	ec5e                	sd	s7,24(sp)
 1e4:	1080                	addi	s0,sp,96
 1e6:	8baa                	mv	s7,a0
 1e8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ea:	892a                	mv	s2,a0
 1ec:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ee:	4aa9                	li	s5,10
 1f0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f2:	89a6                	mv	s3,s1
 1f4:	2485                	addiw	s1,s1,1
 1f6:	0344d663          	bge	s1,s4,222 <gets+0x52>
    cc = read(0, &c, 1);
 1fa:	4605                	li	a2,1
 1fc:	faf40593          	addi	a1,s0,-81
 200:	4501                	li	a0,0
 202:	1b8000ef          	jal	ra,3ba <read>
    if(cc < 1)
 206:	00a05e63          	blez	a0,222 <gets+0x52>
    buf[i++] = c;
 20a:	faf44783          	lbu	a5,-81(s0)
 20e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 212:	01578763          	beq	a5,s5,220 <gets+0x50>
 216:	0905                	addi	s2,s2,1
 218:	fd679de3          	bne	a5,s6,1f2 <gets+0x22>
  for(i=0; i+1 < max; ){
 21c:	89a6                	mv	s3,s1
 21e:	a011                	j	222 <gets+0x52>
 220:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 222:	99de                	add	s3,s3,s7
 224:	00098023          	sb	zero,0(s3)
  return buf;
}
 228:	855e                	mv	a0,s7
 22a:	60e6                	ld	ra,88(sp)
 22c:	6446                	ld	s0,80(sp)
 22e:	64a6                	ld	s1,72(sp)
 230:	6906                	ld	s2,64(sp)
 232:	79e2                	ld	s3,56(sp)
 234:	7a42                	ld	s4,48(sp)
 236:	7aa2                	ld	s5,40(sp)
 238:	7b02                	ld	s6,32(sp)
 23a:	6be2                	ld	s7,24(sp)
 23c:	6125                	addi	sp,sp,96
 23e:	8082                	ret

0000000000000240 <stat>:

int
stat(const char *n, struct stat *st)
{
 240:	1101                	addi	sp,sp,-32
 242:	ec06                	sd	ra,24(sp)
 244:	e822                	sd	s0,16(sp)
 246:	e426                	sd	s1,8(sp)
 248:	e04a                	sd	s2,0(sp)
 24a:	1000                	addi	s0,sp,32
 24c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24e:	4581                	li	a1,0
 250:	192000ef          	jal	ra,3e2 <open>
  if(fd < 0)
 254:	02054163          	bltz	a0,276 <stat+0x36>
 258:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25a:	85ca                	mv	a1,s2
 25c:	19e000ef          	jal	ra,3fa <fstat>
 260:	892a                	mv	s2,a0
  close(fd);
 262:	8526                	mv	a0,s1
 264:	166000ef          	jal	ra,3ca <close>
  return r;
}
 268:	854a                	mv	a0,s2
 26a:	60e2                	ld	ra,24(sp)
 26c:	6442                	ld	s0,16(sp)
 26e:	64a2                	ld	s1,8(sp)
 270:	6902                	ld	s2,0(sp)
 272:	6105                	addi	sp,sp,32
 274:	8082                	ret
    return -1;
 276:	597d                	li	s2,-1
 278:	bfc5                	j	268 <stat+0x28>

000000000000027a <atoi>:

int
atoi(const char *s)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 280:	00054603          	lbu	a2,0(a0)
 284:	fd06079b          	addiw	a5,a2,-48
 288:	0ff7f793          	andi	a5,a5,255
 28c:	4725                	li	a4,9
 28e:	02f76963          	bltu	a4,a5,2c0 <atoi+0x46>
 292:	86aa                	mv	a3,a0
  n = 0;
 294:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 296:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 298:	0685                	addi	a3,a3,1
 29a:	0025179b          	slliw	a5,a0,0x2
 29e:	9fa9                	addw	a5,a5,a0
 2a0:	0017979b          	slliw	a5,a5,0x1
 2a4:	9fb1                	addw	a5,a5,a2
 2a6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2aa:	0006c603          	lbu	a2,0(a3)
 2ae:	fd06071b          	addiw	a4,a2,-48
 2b2:	0ff77713          	andi	a4,a4,255
 2b6:	fee5f1e3          	bgeu	a1,a4,298 <atoi+0x1e>
  return n;
}
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret
  n = 0;
 2c0:	4501                	li	a0,0
 2c2:	bfe5                	j	2ba <atoi+0x40>

00000000000002c4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ca:	02b57663          	bgeu	a0,a1,2f6 <memmove+0x32>
    while(n-- > 0)
 2ce:	02c05163          	blez	a2,2f0 <memmove+0x2c>
 2d2:	fff6079b          	addiw	a5,a2,-1
 2d6:	1782                	slli	a5,a5,0x20
 2d8:	9381                	srli	a5,a5,0x20
 2da:	0785                	addi	a5,a5,1
 2dc:	97aa                	add	a5,a5,a0
  dst = vdst;
 2de:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e0:	0585                	addi	a1,a1,1
 2e2:	0705                	addi	a4,a4,1
 2e4:	fff5c683          	lbu	a3,-1(a1)
 2e8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ec:	fee79ae3          	bne	a5,a4,2e0 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
    dst += n;
 2f6:	00c50733          	add	a4,a0,a2
    src += n;
 2fa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2fc:	fec05ae3          	blez	a2,2f0 <memmove+0x2c>
 300:	fff6079b          	addiw	a5,a2,-1
 304:	1782                	slli	a5,a5,0x20
 306:	9381                	srli	a5,a5,0x20
 308:	fff7c793          	not	a5,a5
 30c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30e:	15fd                	addi	a1,a1,-1
 310:	177d                	addi	a4,a4,-1
 312:	0005c683          	lbu	a3,0(a1)
 316:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 31a:	fee79ae3          	bne	a5,a4,30e <memmove+0x4a>
 31e:	bfc9                	j	2f0 <memmove+0x2c>

0000000000000320 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 326:	ca05                	beqz	a2,356 <memcmp+0x36>
 328:	fff6069b          	addiw	a3,a2,-1
 32c:	1682                	slli	a3,a3,0x20
 32e:	9281                	srli	a3,a3,0x20
 330:	0685                	addi	a3,a3,1
 332:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 334:	00054783          	lbu	a5,0(a0)
 338:	0005c703          	lbu	a4,0(a1)
 33c:	00e79863          	bne	a5,a4,34c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 340:	0505                	addi	a0,a0,1
    p2++;
 342:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 344:	fed518e3          	bne	a0,a3,334 <memcmp+0x14>
  }
  return 0;
 348:	4501                	li	a0,0
 34a:	a019                	j	350 <memcmp+0x30>
      return *p1 - *p2;
 34c:	40e7853b          	subw	a0,a5,a4
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  return 0;
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <memcmp+0x30>

000000000000035a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 362:	f63ff0ef          	jal	ra,2c4 <memmove>
}
 366:	60a2                	ld	ra,8(sp)
 368:	6402                	ld	s0,0(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret

000000000000036e <sbrk>:

char *
sbrk(int n) {
 36e:	1141                	addi	sp,sp,-16
 370:	e406                	sd	ra,8(sp)
 372:	e022                	sd	s0,0(sp)
 374:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 376:	4585                	li	a1,1
 378:	0b2000ef          	jal	ra,42a <sys_sbrk>
}
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <sbrklazy>:

char *
sbrklazy(int n) {
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 38c:	4589                	li	a1,2
 38e:	09c000ef          	jal	ra,42a <sys_sbrk>
}
 392:	60a2                	ld	ra,8(sp)
 394:	6402                	ld	s0,0(sp)
 396:	0141                	addi	sp,sp,16
 398:	8082                	ret

000000000000039a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 39a:	4885                	li	a7,1
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a2:	4889                	li	a7,2
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <wait>:
.global wait
wait:
 li a7, SYS_wait
 3aa:	488d                	li	a7,3
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b2:	4891                	li	a7,4
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <read>:
.global read
read:
 li a7, SYS_read
 3ba:	4895                	li	a7,5
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <write>:
.global write
write:
 li a7, SYS_write
 3c2:	48c1                	li	a7,16
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <close>:
.global close
close:
 li a7, SYS_close
 3ca:	48d5                	li	a7,21
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d2:	4899                	li	a7,6
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <exec>:
.global exec
exec:
 li a7, SYS_exec
 3da:	489d                	li	a7,7
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <open>:
.global open
open:
 li a7, SYS_open
 3e2:	48bd                	li	a7,15
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ea:	48c5                	li	a7,17
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f2:	48c9                	li	a7,18
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3fa:	48a1                	li	a7,8
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <link>:
.global link
link:
 li a7, SYS_link
 402:	48cd                	li	a7,19
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 40a:	48d1                	li	a7,20
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 412:	48a5                	li	a7,9
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <dup>:
.global dup
dup:
 li a7, SYS_dup
 41a:	48a9                	li	a7,10
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 422:	48ad                	li	a7,11
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 42a:	48b1                	li	a7,12
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <pause>:
.global pause
pause:
 li a7, SYS_pause
 432:	48b5                	li	a7,13
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 43a:	48b9                	li	a7,14
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 442:	1101                	addi	sp,sp,-32
 444:	ec06                	sd	ra,24(sp)
 446:	e822                	sd	s0,16(sp)
 448:	1000                	addi	s0,sp,32
 44a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44e:	4605                	li	a2,1
 450:	fef40593          	addi	a1,s0,-17
 454:	f6fff0ef          	jal	ra,3c2 <write>
}
 458:	60e2                	ld	ra,24(sp)
 45a:	6442                	ld	s0,16(sp)
 45c:	6105                	addi	sp,sp,32
 45e:	8082                	ret

0000000000000460 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 460:	715d                	addi	sp,sp,-80
 462:	e486                	sd	ra,72(sp)
 464:	e0a2                	sd	s0,64(sp)
 466:	fc26                	sd	s1,56(sp)
 468:	f84a                	sd	s2,48(sp)
 46a:	f44e                	sd	s3,40(sp)
 46c:	0880                	addi	s0,sp,80
 46e:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 470:	c299                	beqz	a3,476 <printint+0x16>
 472:	0805c663          	bltz	a1,4fe <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 476:	2581                	sext.w	a1,a1
  neg = 0;
 478:	4881                	li	a7,0
 47a:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 47e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 480:	2601                	sext.w	a2,a2
 482:	00000517          	auipc	a0,0x0
 486:	52e50513          	addi	a0,a0,1326 # 9b0 <digits>
 48a:	883a                	mv	a6,a4
 48c:	2705                	addiw	a4,a4,1
 48e:	02c5f7bb          	remuw	a5,a1,a2
 492:	1782                	slli	a5,a5,0x20
 494:	9381                	srli	a5,a5,0x20
 496:	97aa                	add	a5,a5,a0
 498:	0007c783          	lbu	a5,0(a5)
 49c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a0:	0005879b          	sext.w	a5,a1
 4a4:	02c5d5bb          	divuw	a1,a1,a2
 4a8:	0685                	addi	a3,a3,1
 4aa:	fec7f0e3          	bgeu	a5,a2,48a <printint+0x2a>
  if(neg)
 4ae:	00088b63          	beqz	a7,4c4 <printint+0x64>
    buf[i++] = '-';
 4b2:	fd040793          	addi	a5,s0,-48
 4b6:	973e                	add	a4,a4,a5
 4b8:	02d00793          	li	a5,45
 4bc:	fef70423          	sb	a5,-24(a4)
 4c0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4c4:	02e05663          	blez	a4,4f0 <printint+0x90>
 4c8:	fb840793          	addi	a5,s0,-72
 4cc:	00e78933          	add	s2,a5,a4
 4d0:	fff78993          	addi	s3,a5,-1
 4d4:	99ba                	add	s3,s3,a4
 4d6:	377d                	addiw	a4,a4,-1
 4d8:	1702                	slli	a4,a4,0x20
 4da:	9301                	srli	a4,a4,0x20
 4dc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e0:	fff94583          	lbu	a1,-1(s2)
 4e4:	8526                	mv	a0,s1
 4e6:	f5dff0ef          	jal	ra,442 <putc>
  while(--i >= 0)
 4ea:	197d                	addi	s2,s2,-1
 4ec:	ff391ae3          	bne	s2,s3,4e0 <printint+0x80>
}
 4f0:	60a6                	ld	ra,72(sp)
 4f2:	6406                	ld	s0,64(sp)
 4f4:	74e2                	ld	s1,56(sp)
 4f6:	7942                	ld	s2,48(sp)
 4f8:	79a2                	ld	s3,40(sp)
 4fa:	6161                	addi	sp,sp,80
 4fc:	8082                	ret
    x = -xx;
 4fe:	40b005bb          	negw	a1,a1
    neg = 1;
 502:	4885                	li	a7,1
    x = -xx;
 504:	bf9d                	j	47a <printint+0x1a>

0000000000000506 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 506:	7119                	addi	sp,sp,-128
 508:	fc86                	sd	ra,120(sp)
 50a:	f8a2                	sd	s0,112(sp)
 50c:	f4a6                	sd	s1,104(sp)
 50e:	f0ca                	sd	s2,96(sp)
 510:	ecce                	sd	s3,88(sp)
 512:	e8d2                	sd	s4,80(sp)
 514:	e4d6                	sd	s5,72(sp)
 516:	e0da                	sd	s6,64(sp)
 518:	fc5e                	sd	s7,56(sp)
 51a:	f862                	sd	s8,48(sp)
 51c:	f466                	sd	s9,40(sp)
 51e:	f06a                	sd	s10,32(sp)
 520:	ec6e                	sd	s11,24(sp)
 522:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 524:	0005c903          	lbu	s2,0(a1)
 528:	24090c63          	beqz	s2,780 <vprintf+0x27a>
 52c:	8b2a                	mv	s6,a0
 52e:	8a2e                	mv	s4,a1
 530:	8bb2                	mv	s7,a2
  state = 0;
 532:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 534:	4481                	li	s1,0
 536:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 538:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 53c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 540:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 544:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 548:	00000c97          	auipc	s9,0x0
 54c:	468c8c93          	addi	s9,s9,1128 # 9b0 <digits>
 550:	a005                	j	570 <vprintf+0x6a>
        putc(fd, c0);
 552:	85ca                	mv	a1,s2
 554:	855a                	mv	a0,s6
 556:	eedff0ef          	jal	ra,442 <putc>
 55a:	a019                	j	560 <vprintf+0x5a>
    } else if(state == '%'){
 55c:	03598263          	beq	s3,s5,580 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 560:	2485                	addiw	s1,s1,1
 562:	8726                	mv	a4,s1
 564:	009a07b3          	add	a5,s4,s1
 568:	0007c903          	lbu	s2,0(a5)
 56c:	20090a63          	beqz	s2,780 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 570:	0009079b          	sext.w	a5,s2
    if(state == 0){
 574:	fe0994e3          	bnez	s3,55c <vprintf+0x56>
      if(c0 == '%'){
 578:	fd579de3          	bne	a5,s5,552 <vprintf+0x4c>
        state = '%';
 57c:	89be                	mv	s3,a5
 57e:	b7cd                	j	560 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 580:	c3c1                	beqz	a5,600 <vprintf+0xfa>
 582:	00ea06b3          	add	a3,s4,a4
 586:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 58a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 58c:	c681                	beqz	a3,594 <vprintf+0x8e>
 58e:	9752                	add	a4,a4,s4
 590:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 594:	03878e63          	beq	a5,s8,5d0 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 598:	05a78863          	beq	a5,s10,5e8 <vprintf+0xe2>
      } else if(c0 == 'u'){
 59c:	0db78b63          	beq	a5,s11,672 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5a0:	07800713          	li	a4,120
 5a4:	10e78d63          	beq	a5,a4,6be <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5a8:	07000713          	li	a4,112
 5ac:	14e78263          	beq	a5,a4,6f0 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5b0:	06300713          	li	a4,99
 5b4:	16e78f63          	beq	a5,a4,732 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5b8:	07300713          	li	a4,115
 5bc:	18e78563          	beq	a5,a4,746 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5c0:	05579063          	bne	a5,s5,600 <vprintf+0xfa>
        putc(fd, '%');
 5c4:	85d6                	mv	a1,s5
 5c6:	855a                	mv	a0,s6
 5c8:	e7bff0ef          	jal	ra,442 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	bf49                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 5d0:	008b8913          	addi	s2,s7,8
 5d4:	4685                	li	a3,1
 5d6:	4629                	li	a2,10
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	e83ff0ef          	jal	ra,460 <printint>
 5e2:	8bca                	mv	s7,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bfad                	j	560 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 5e8:	03868663          	beq	a3,s8,614 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ec:	05a68163          	beq	a3,s10,62e <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 5f0:	09b68d63          	beq	a3,s11,68a <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5f4:	03a68f63          	beq	a3,s10,632 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 5f8:	07800793          	li	a5,120
 5fc:	0cf68d63          	beq	a3,a5,6d6 <vprintf+0x1d0>
        putc(fd, '%');
 600:	85d6                	mv	a1,s5
 602:	855a                	mv	a0,s6
 604:	e3fff0ef          	jal	ra,442 <putc>
        putc(fd, c0);
 608:	85ca                	mv	a1,s2
 60a:	855a                	mv	a0,s6
 60c:	e37ff0ef          	jal	ra,442 <putc>
      state = 0;
 610:	4981                	li	s3,0
 612:	b7b9                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 614:	008b8913          	addi	s2,s7,8
 618:	4685                	li	a3,1
 61a:	4629                	li	a2,10
 61c:	000bb583          	ld	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	e3fff0ef          	jal	ra,460 <printint>
        i += 1;
 626:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 628:	8bca                	mv	s7,s2
      state = 0;
 62a:	4981                	li	s3,0
        i += 1;
 62c:	bf15                	j	560 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 62e:	03860563          	beq	a2,s8,658 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 632:	07b60963          	beq	a2,s11,6a4 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 636:	07800793          	li	a5,120
 63a:	fcf613e3          	bne	a2,a5,600 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63e:	008b8913          	addi	s2,s7,8
 642:	4681                	li	a3,0
 644:	4641                	li	a2,16
 646:	000bb583          	ld	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	e15ff0ef          	jal	ra,460 <printint>
        i += 2;
 650:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
        i += 2;
 656:	b729                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 658:	008b8913          	addi	s2,s7,8
 65c:	4685                	li	a3,1
 65e:	4629                	li	a2,10
 660:	000bb583          	ld	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	dfbff0ef          	jal	ra,460 <printint>
        i += 2;
 66a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 66c:	8bca                	mv	s7,s2
      state = 0;
 66e:	4981                	li	s3,0
        i += 2;
 670:	bdc5                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 672:	008b8913          	addi	s2,s7,8
 676:	4681                	li	a3,0
 678:	4629                	li	a2,10
 67a:	000be583          	lwu	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	de1ff0ef          	jal	ra,460 <printint>
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
 688:	bde1                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68a:	008b8913          	addi	s2,s7,8
 68e:	4681                	li	a3,0
 690:	4629                	li	a2,10
 692:	000bb583          	ld	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	dc9ff0ef          	jal	ra,460 <printint>
        i += 1;
 69c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 69e:	8bca                	mv	s7,s2
      state = 0;
 6a0:	4981                	li	s3,0
        i += 1;
 6a2:	bd7d                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a4:	008b8913          	addi	s2,s7,8
 6a8:	4681                	li	a3,0
 6aa:	4629                	li	a2,10
 6ac:	000bb583          	ld	a1,0(s7)
 6b0:	855a                	mv	a0,s6
 6b2:	dafff0ef          	jal	ra,460 <printint>
        i += 2;
 6b6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b8:	8bca                	mv	s7,s2
      state = 0;
 6ba:	4981                	li	s3,0
        i += 2;
 6bc:	b555                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6be:	008b8913          	addi	s2,s7,8
 6c2:	4681                	li	a3,0
 6c4:	4641                	li	a2,16
 6c6:	000be583          	lwu	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	d95ff0ef          	jal	ra,460 <printint>
 6d0:	8bca                	mv	s7,s2
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b571                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d6:	008b8913          	addi	s2,s7,8
 6da:	4681                	li	a3,0
 6dc:	4641                	li	a2,16
 6de:	000bb583          	ld	a1,0(s7)
 6e2:	855a                	mv	a0,s6
 6e4:	d7dff0ef          	jal	ra,460 <printint>
        i += 1;
 6e8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ea:	8bca                	mv	s7,s2
      state = 0;
 6ec:	4981                	li	s3,0
        i += 1;
 6ee:	bd8d                	j	560 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 6f0:	008b8793          	addi	a5,s7,8
 6f4:	f8f43423          	sd	a5,-120(s0)
 6f8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6fc:	03000593          	li	a1,48
 700:	855a                	mv	a0,s6
 702:	d41ff0ef          	jal	ra,442 <putc>
  putc(fd, 'x');
 706:	07800593          	li	a1,120
 70a:	855a                	mv	a0,s6
 70c:	d37ff0ef          	jal	ra,442 <putc>
 710:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 712:	03c9d793          	srli	a5,s3,0x3c
 716:	97e6                	add	a5,a5,s9
 718:	0007c583          	lbu	a1,0(a5)
 71c:	855a                	mv	a0,s6
 71e:	d25ff0ef          	jal	ra,442 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 722:	0992                	slli	s3,s3,0x4
 724:	397d                	addiw	s2,s2,-1
 726:	fe0916e3          	bnez	s2,712 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 72a:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 72e:	4981                	li	s3,0
 730:	bd05                	j	560 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 732:	008b8913          	addi	s2,s7,8
 736:	000bc583          	lbu	a1,0(s7)
 73a:	855a                	mv	a0,s6
 73c:	d07ff0ef          	jal	ra,442 <putc>
 740:	8bca                	mv	s7,s2
      state = 0;
 742:	4981                	li	s3,0
 744:	bd31                	j	560 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 746:	008b8993          	addi	s3,s7,8
 74a:	000bb903          	ld	s2,0(s7)
 74e:	00090f63          	beqz	s2,76c <vprintf+0x266>
        for(; *s; s++)
 752:	00094583          	lbu	a1,0(s2)
 756:	c195                	beqz	a1,77a <vprintf+0x274>
          putc(fd, *s);
 758:	855a                	mv	a0,s6
 75a:	ce9ff0ef          	jal	ra,442 <putc>
        for(; *s; s++)
 75e:	0905                	addi	s2,s2,1
 760:	00094583          	lbu	a1,0(s2)
 764:	f9f5                	bnez	a1,758 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 766:	8bce                	mv	s7,s3
      state = 0;
 768:	4981                	li	s3,0
 76a:	bbdd                	j	560 <vprintf+0x5a>
          s = "(null)";
 76c:	00000917          	auipc	s2,0x0
 770:	23c90913          	addi	s2,s2,572 # 9a8 <malloc+0x126>
        for(; *s; s++)
 774:	02800593          	li	a1,40
 778:	b7c5                	j	758 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 77a:	8bce                	mv	s7,s3
      state = 0;
 77c:	4981                	li	s3,0
 77e:	b3cd                	j	560 <vprintf+0x5a>
    }
  }
}
 780:	70e6                	ld	ra,120(sp)
 782:	7446                	ld	s0,112(sp)
 784:	74a6                	ld	s1,104(sp)
 786:	7906                	ld	s2,96(sp)
 788:	69e6                	ld	s3,88(sp)
 78a:	6a46                	ld	s4,80(sp)
 78c:	6aa6                	ld	s5,72(sp)
 78e:	6b06                	ld	s6,64(sp)
 790:	7be2                	ld	s7,56(sp)
 792:	7c42                	ld	s8,48(sp)
 794:	7ca2                	ld	s9,40(sp)
 796:	7d02                	ld	s10,32(sp)
 798:	6de2                	ld	s11,24(sp)
 79a:	6109                	addi	sp,sp,128
 79c:	8082                	ret

000000000000079e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 79e:	715d                	addi	sp,sp,-80
 7a0:	ec06                	sd	ra,24(sp)
 7a2:	e822                	sd	s0,16(sp)
 7a4:	1000                	addi	s0,sp,32
 7a6:	e010                	sd	a2,0(s0)
 7a8:	e414                	sd	a3,8(s0)
 7aa:	e818                	sd	a4,16(s0)
 7ac:	ec1c                	sd	a5,24(s0)
 7ae:	03043023          	sd	a6,32(s0)
 7b2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ba:	8622                	mv	a2,s0
 7bc:	d4bff0ef          	jal	ra,506 <vprintf>
}
 7c0:	60e2                	ld	ra,24(sp)
 7c2:	6442                	ld	s0,16(sp)
 7c4:	6161                	addi	sp,sp,80
 7c6:	8082                	ret

00000000000007c8 <printf>:

void
printf(const char *fmt, ...)
{
 7c8:	711d                	addi	sp,sp,-96
 7ca:	ec06                	sd	ra,24(sp)
 7cc:	e822                	sd	s0,16(sp)
 7ce:	1000                	addi	s0,sp,32
 7d0:	e40c                	sd	a1,8(s0)
 7d2:	e810                	sd	a2,16(s0)
 7d4:	ec14                	sd	a3,24(s0)
 7d6:	f018                	sd	a4,32(s0)
 7d8:	f41c                	sd	a5,40(s0)
 7da:	03043823          	sd	a6,48(s0)
 7de:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e2:	00840613          	addi	a2,s0,8
 7e6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ea:	85aa                	mv	a1,a0
 7ec:	4505                	li	a0,1
 7ee:	d19ff0ef          	jal	ra,506 <vprintf>
}
 7f2:	60e2                	ld	ra,24(sp)
 7f4:	6442                	ld	s0,16(sp)
 7f6:	6125                	addi	sp,sp,96
 7f8:	8082                	ret

00000000000007fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fa:	1141                	addi	sp,sp,-16
 7fc:	e422                	sd	s0,8(sp)
 7fe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 800:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 804:	00000797          	auipc	a5,0x0
 808:	7fc7b783          	ld	a5,2044(a5) # 1000 <freep>
 80c:	a805                	j	83c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 80e:	4618                	lw	a4,8(a2)
 810:	9db9                	addw	a1,a1,a4
 812:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 816:	6398                	ld	a4,0(a5)
 818:	6318                	ld	a4,0(a4)
 81a:	fee53823          	sd	a4,-16(a0)
 81e:	a091                	j	862 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 820:	ff852703          	lw	a4,-8(a0)
 824:	9e39                	addw	a2,a2,a4
 826:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 828:	ff053703          	ld	a4,-16(a0)
 82c:	e398                	sd	a4,0(a5)
 82e:	a099                	j	874 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	6398                	ld	a4,0(a5)
 832:	00e7e463          	bltu	a5,a4,83a <free+0x40>
 836:	00e6ea63          	bltu	a3,a4,84a <free+0x50>
{
 83a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83c:	fed7fae3          	bgeu	a5,a3,830 <free+0x36>
 840:	6398                	ld	a4,0(a5)
 842:	00e6e463          	bltu	a3,a4,84a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 846:	fee7eae3          	bltu	a5,a4,83a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 84a:	ff852583          	lw	a1,-8(a0)
 84e:	6390                	ld	a2,0(a5)
 850:	02059713          	slli	a4,a1,0x20
 854:	9301                	srli	a4,a4,0x20
 856:	0712                	slli	a4,a4,0x4
 858:	9736                	add	a4,a4,a3
 85a:	fae60ae3          	beq	a2,a4,80e <free+0x14>
    bp->s.ptr = p->s.ptr;
 85e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 862:	4790                	lw	a2,8(a5)
 864:	02061713          	slli	a4,a2,0x20
 868:	9301                	srli	a4,a4,0x20
 86a:	0712                	slli	a4,a4,0x4
 86c:	973e                	add	a4,a4,a5
 86e:	fae689e3          	beq	a3,a4,820 <free+0x26>
  } else
    p->s.ptr = bp;
 872:	e394                	sd	a3,0(a5)
  freep = p;
 874:	00000717          	auipc	a4,0x0
 878:	78f73623          	sd	a5,1932(a4) # 1000 <freep>
}
 87c:	6422                	ld	s0,8(sp)
 87e:	0141                	addi	sp,sp,16
 880:	8082                	ret

0000000000000882 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 882:	7139                	addi	sp,sp,-64
 884:	fc06                	sd	ra,56(sp)
 886:	f822                	sd	s0,48(sp)
 888:	f426                	sd	s1,40(sp)
 88a:	f04a                	sd	s2,32(sp)
 88c:	ec4e                	sd	s3,24(sp)
 88e:	e852                	sd	s4,16(sp)
 890:	e456                	sd	s5,8(sp)
 892:	e05a                	sd	s6,0(sp)
 894:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 896:	02051493          	slli	s1,a0,0x20
 89a:	9081                	srli	s1,s1,0x20
 89c:	04bd                	addi	s1,s1,15
 89e:	8091                	srli	s1,s1,0x4
 8a0:	0014899b          	addiw	s3,s1,1
 8a4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8a6:	00000517          	auipc	a0,0x0
 8aa:	75a53503          	ld	a0,1882(a0) # 1000 <freep>
 8ae:	c515                	beqz	a0,8da <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b2:	4798                	lw	a4,8(a5)
 8b4:	02977f63          	bgeu	a4,s1,8f2 <malloc+0x70>
 8b8:	8a4e                	mv	s4,s3
 8ba:	0009871b          	sext.w	a4,s3
 8be:	6685                	lui	a3,0x1
 8c0:	00d77363          	bgeu	a4,a3,8c6 <malloc+0x44>
 8c4:	6a05                	lui	s4,0x1
 8c6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ca:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ce:	00000917          	auipc	s2,0x0
 8d2:	73290913          	addi	s2,s2,1842 # 1000 <freep>
  if(p == SBRK_ERROR)
 8d6:	5afd                	li	s5,-1
 8d8:	a0bd                	j	946 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 8da:	00001797          	auipc	a5,0x1
 8de:	92e78793          	addi	a5,a5,-1746 # 1208 <base>
 8e2:	00000717          	auipc	a4,0x0
 8e6:	70f73f23          	sd	a5,1822(a4) # 1000 <freep>
 8ea:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ec:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8f0:	b7e1                	j	8b8 <malloc+0x36>
      if(p->s.size == nunits)
 8f2:	02e48b63          	beq	s1,a4,928 <malloc+0xa6>
        p->s.size -= nunits;
 8f6:	4137073b          	subw	a4,a4,s3
 8fa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8fc:	1702                	slli	a4,a4,0x20
 8fe:	9301                	srli	a4,a4,0x20
 900:	0712                	slli	a4,a4,0x4
 902:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 904:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 908:	00000717          	auipc	a4,0x0
 90c:	6ea73c23          	sd	a0,1784(a4) # 1000 <freep>
      return (void*)(p + 1);
 910:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 914:	70e2                	ld	ra,56(sp)
 916:	7442                	ld	s0,48(sp)
 918:	74a2                	ld	s1,40(sp)
 91a:	7902                	ld	s2,32(sp)
 91c:	69e2                	ld	s3,24(sp)
 91e:	6a42                	ld	s4,16(sp)
 920:	6aa2                	ld	s5,8(sp)
 922:	6b02                	ld	s6,0(sp)
 924:	6121                	addi	sp,sp,64
 926:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 928:	6398                	ld	a4,0(a5)
 92a:	e118                	sd	a4,0(a0)
 92c:	bff1                	j	908 <malloc+0x86>
  hp->s.size = nu;
 92e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 932:	0541                	addi	a0,a0,16
 934:	ec7ff0ef          	jal	ra,7fa <free>
  return freep;
 938:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 93c:	dd61                	beqz	a0,914 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 940:	4798                	lw	a4,8(a5)
 942:	fa9778e3          	bgeu	a4,s1,8f2 <malloc+0x70>
    if(p == freep)
 946:	00093703          	ld	a4,0(s2)
 94a:	853e                	mv	a0,a5
 94c:	fef719e3          	bne	a4,a5,93e <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 950:	8552                	mv	a0,s4
 952:	a1dff0ef          	jal	ra,36e <sbrk>
  if(p == SBRK_ERROR)
 956:	fd551ce3          	bne	a0,s5,92e <malloc+0xac>
        return 0;
 95a:	4501                	li	a0,0
 95c:	bf65                	j	914 <malloc+0x92>
