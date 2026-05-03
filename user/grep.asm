
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	02c000ef          	jal	ra,4a <matchhere>
  22:	e919                	bnez	a0,38 <matchstar+0x38>
  }while(*text!='\0' && (*text++==c || c=='.'));
  24:	0004c783          	lbu	a5,0(s1)
  28:	cb89                	beqz	a5,3a <matchstar+0x3a>
  2a:	0485                	addi	s1,s1,1
  2c:	2781                	sext.w	a5,a5
  2e:	ff2786e3          	beq	a5,s2,1a <matchstar+0x1a>
  32:	ff4904e3          	beq	s2,s4,1a <matchstar+0x1a>
  36:	a011                	j	3a <matchstar+0x3a>
      return 1;
  38:	4505                	li	a0,1
  return 0;
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6942                	ld	s2,16(sp)
  42:	69a2                	ld	s3,8(sp)
  44:	6a02                	ld	s4,0(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret

000000000000004a <matchhere>:
  if(re[0] == '\0')
  4a:	00054703          	lbu	a4,0(a0)
  4e:	c73d                	beqz	a4,bc <matchhere+0x72>
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  58:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5a:	00154683          	lbu	a3,1(a0)
  5e:	02a00613          	li	a2,42
  62:	02c68563          	beq	a3,a2,8c <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  66:	02400613          	li	a2,36
  6a:	02c70863          	beq	a4,a2,9a <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  6e:	0005c683          	lbu	a3,0(a1)
  return 0;
  72:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  74:	ca81                	beqz	a3,84 <matchhere+0x3a>
  76:	02e00613          	li	a2,46
  7a:	02c70b63          	beq	a4,a2,b0 <matchhere+0x66>
  return 0;
  7e:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  80:	02d70863          	beq	a4,a3,b0 <matchhere+0x66>
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret
    return matchstar(re[0], re+2, text);
  8c:	862e                	mv	a2,a1
  8e:	00250593          	addi	a1,a0,2
  92:	853a                	mv	a0,a4
  94:	f6dff0ef          	jal	ra,0 <matchstar>
  98:	b7f5                	j	84 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  9a:	c691                	beqz	a3,a6 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  9c:	0005c683          	lbu	a3,0(a1)
  a0:	fef9                	bnez	a3,7e <matchhere+0x34>
  return 0;
  a2:	4501                	li	a0,0
  a4:	b7c5                	j	84 <matchhere+0x3a>
    return *text == '\0';
  a6:	0005c503          	lbu	a0,0(a1)
  aa:	00153513          	seqz	a0,a0
  ae:	bfd9                	j	84 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b0:	0585                	addi	a1,a1,1
  b2:	00178513          	addi	a0,a5,1
  b6:	f95ff0ef          	jal	ra,4a <matchhere>
  ba:	b7e9                	j	84 <matchhere+0x3a>
    return 1;
  bc:	4505                	li	a0,1
}
  be:	8082                	ret

00000000000000c0 <match>:
{
  c0:	1101                	addi	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	e04a                	sd	s2,0(sp)
  ca:	1000                	addi	s0,sp,32
  cc:	892a                	mv	s2,a0
  ce:	84ae                	mv	s1,a1
  if(re[0] == '^')
  d0:	00054703          	lbu	a4,0(a0)
  d4:	05e00793          	li	a5,94
  d8:	00f70c63          	beq	a4,a5,f0 <match+0x30>
    if(matchhere(re, text))
  dc:	85a6                	mv	a1,s1
  de:	854a                	mv	a0,s2
  e0:	f6bff0ef          	jal	ra,4a <matchhere>
  e4:	e911                	bnez	a0,f8 <match+0x38>
  }while(*text++ != '\0');
  e6:	0485                	addi	s1,s1,1
  e8:	fff4c783          	lbu	a5,-1(s1)
  ec:	fbe5                	bnez	a5,dc <match+0x1c>
  ee:	a031                	j	fa <match+0x3a>
    return matchhere(re+1, text);
  f0:	0505                	addi	a0,a0,1
  f2:	f59ff0ef          	jal	ra,4a <matchhere>
  f6:	a011                	j	fa <match+0x3a>
      return 1;
  f8:	4505                	li	a0,1
}
  fa:	60e2                	ld	ra,24(sp)
  fc:	6442                	ld	s0,16(sp)
  fe:	64a2                	ld	s1,8(sp)
 100:	6902                	ld	s2,0(sp)
 102:	6105                	addi	sp,sp,32
 104:	8082                	ret

0000000000000106 <grep>:
{
 106:	711d                	addi	sp,sp,-96
 108:	ec86                	sd	ra,88(sp)
 10a:	e8a2                	sd	s0,80(sp)
 10c:	e4a6                	sd	s1,72(sp)
 10e:	e0ca                	sd	s2,64(sp)
 110:	fc4e                	sd	s3,56(sp)
 112:	f852                	sd	s4,48(sp)
 114:	f456                	sd	s5,40(sp)
 116:	f05a                	sd	s6,32(sp)
 118:	ec5e                	sd	s7,24(sp)
 11a:	e862                	sd	s8,16(sp)
 11c:	e466                	sd	s9,8(sp)
 11e:	e06a                	sd	s10,0(sp)
 120:	1080                	addi	s0,sp,96
 122:	89aa                	mv	s3,a0
 124:	8bae                	mv	s7,a1
  m = 0;
 126:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 128:	3ff00c13          	li	s8,1023
 12c:	00001b17          	auipc	s6,0x1
 130:	ee4b0b13          	addi	s6,s6,-284 # 1010 <buf>
    p = buf;
 134:	8d5a                	mv	s10,s6
        *q = '\n';
 136:	4aa9                	li	s5,10
    p = buf;
 138:	8cda                	mv	s9,s6
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 13a:	a82d                	j	174 <grep+0x6e>
        *q = '\n';
 13c:	01548023          	sb	s5,0(s1)
        write(1, p, q+1 - p);
 140:	00148613          	addi	a2,s1,1
 144:	4126063b          	subw	a2,a2,s2
 148:	85ca                	mv	a1,s2
 14a:	4505                	li	a0,1
 14c:	3d2000ef          	jal	ra,51e <write>
      p = q+1;
 150:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 154:	45a9                	li	a1,10
 156:	854a                	mv	a0,s2
 158:	1b0000ef          	jal	ra,308 <strchr>
 15c:	84aa                	mv	s1,a0
 15e:	c909                	beqz	a0,170 <grep+0x6a>
      *q = 0;
 160:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 164:	85ca                	mv	a1,s2
 166:	854e                	mv	a0,s3
 168:	f59ff0ef          	jal	ra,c0 <match>
 16c:	d175                	beqz	a0,150 <grep+0x4a>
 16e:	b7f9                	j	13c <grep+0x36>
    if(m > 0){
 170:	03404363          	bgtz	s4,196 <grep+0x90>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 174:	414c063b          	subw	a2,s8,s4
 178:	014b05b3          	add	a1,s6,s4
 17c:	855e                	mv	a0,s7
 17e:	398000ef          	jal	ra,516 <read>
 182:	02a05463          	blez	a0,1aa <grep+0xa4>
    m += n;
 186:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 18a:	014b07b3          	add	a5,s6,s4
 18e:	00078023          	sb	zero,0(a5)
    p = buf;
 192:	8966                	mv	s2,s9
    while((q = strchr(p, '\n')) != 0){
 194:	b7c1                	j	154 <grep+0x4e>
      m -= p - buf;
 196:	416907b3          	sub	a5,s2,s6
 19a:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 19e:	8652                	mv	a2,s4
 1a0:	85ca                	mv	a1,s2
 1a2:	856a                	mv	a0,s10
 1a4:	27c000ef          	jal	ra,420 <memmove>
 1a8:	b7f1                	j	174 <grep+0x6e>
}
 1aa:	60e6                	ld	ra,88(sp)
 1ac:	6446                	ld	s0,80(sp)
 1ae:	64a6                	ld	s1,72(sp)
 1b0:	6906                	ld	s2,64(sp)
 1b2:	79e2                	ld	s3,56(sp)
 1b4:	7a42                	ld	s4,48(sp)
 1b6:	7aa2                	ld	s5,40(sp)
 1b8:	7b02                	ld	s6,32(sp)
 1ba:	6be2                	ld	s7,24(sp)
 1bc:	6c42                	ld	s8,16(sp)
 1be:	6ca2                	ld	s9,8(sp)
 1c0:	6d02                	ld	s10,0(sp)
 1c2:	6125                	addi	sp,sp,96
 1c4:	8082                	ret

00000000000001c6 <main>:
{
 1c6:	7139                	addi	sp,sp,-64
 1c8:	fc06                	sd	ra,56(sp)
 1ca:	f822                	sd	s0,48(sp)
 1cc:	f426                	sd	s1,40(sp)
 1ce:	f04a                	sd	s2,32(sp)
 1d0:	ec4e                	sd	s3,24(sp)
 1d2:	e852                	sd	s4,16(sp)
 1d4:	e456                	sd	s5,8(sp)
 1d6:	0080                	addi	s0,sp,64
  if(argc <= 1){
 1d8:	4785                	li	a5,1
 1da:	04a7d663          	bge	a5,a0,226 <main+0x60>
  pattern = argv[1];
 1de:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1e2:	4789                	li	a5,2
 1e4:	04a7db63          	bge	a5,a0,23a <main+0x74>
 1e8:	01058913          	addi	s2,a1,16
 1ec:	ffd5099b          	addiw	s3,a0,-3
 1f0:	1982                	slli	s3,s3,0x20
 1f2:	0209d993          	srli	s3,s3,0x20
 1f6:	098e                	slli	s3,s3,0x3
 1f8:	05e1                	addi	a1,a1,24
 1fa:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 1fc:	4581                	li	a1,0
 1fe:	00093503          	ld	a0,0(s2)
 202:	33c000ef          	jal	ra,53e <open>
 206:	84aa                	mv	s1,a0
 208:	04054063          	bltz	a0,248 <main+0x82>
    grep(pattern, fd);
 20c:	85aa                	mv	a1,a0
 20e:	8552                	mv	a0,s4
 210:	ef7ff0ef          	jal	ra,106 <grep>
    close(fd);
 214:	8526                	mv	a0,s1
 216:	310000ef          	jal	ra,526 <close>
  for(i = 2; i < argc; i++){
 21a:	0921                	addi	s2,s2,8
 21c:	ff3910e3          	bne	s2,s3,1fc <main+0x36>
  exit(0);
 220:	4501                	li	a0,0
 222:	2dc000ef          	jal	ra,4fe <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 226:	00001597          	auipc	a1,0x1
 22a:	89a58593          	addi	a1,a1,-1894 # ac0 <malloc+0xe2>
 22e:	4509                	li	a0,2
 230:	6ca000ef          	jal	ra,8fa <fprintf>
    exit(1);
 234:	4505                	li	a0,1
 236:	2c8000ef          	jal	ra,4fe <exit>
    grep(pattern, 0);
 23a:	4581                	li	a1,0
 23c:	8552                	mv	a0,s4
 23e:	ec9ff0ef          	jal	ra,106 <grep>
    exit(0);
 242:	4501                	li	a0,0
 244:	2ba000ef          	jal	ra,4fe <exit>
      printf("grep: cannot open %s\n", argv[i]);
 248:	00093583          	ld	a1,0(s2)
 24c:	00001517          	auipc	a0,0x1
 250:	89450513          	addi	a0,a0,-1900 # ae0 <malloc+0x102>
 254:	6d0000ef          	jal	ra,924 <printf>
      exit(1);
 258:	4505                	li	a0,1
 25a:	2a4000ef          	jal	ra,4fe <exit>

000000000000025e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 25e:	1141                	addi	sp,sp,-16
 260:	e406                	sd	ra,8(sp)
 262:	e022                	sd	s0,0(sp)
 264:	0800                	addi	s0,sp,16
  extern int main();
  main();
 266:	f61ff0ef          	jal	ra,1c6 <main>
  exit(0);
 26a:	4501                	li	a0,0
 26c:	292000ef          	jal	ra,4fe <exit>

0000000000000270 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 270:	1141                	addi	sp,sp,-16
 272:	e422                	sd	s0,8(sp)
 274:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 276:	87aa                	mv	a5,a0
 278:	0585                	addi	a1,a1,1
 27a:	0785                	addi	a5,a5,1
 27c:	fff5c703          	lbu	a4,-1(a1)
 280:	fee78fa3          	sb	a4,-1(a5)
 284:	fb75                	bnez	a4,278 <strcpy+0x8>
    ;
  return os;
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret

000000000000028c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 292:	00054783          	lbu	a5,0(a0)
 296:	cb91                	beqz	a5,2aa <strcmp+0x1e>
 298:	0005c703          	lbu	a4,0(a1)
 29c:	00f71763          	bne	a4,a5,2aa <strcmp+0x1e>
    p++, q++;
 2a0:	0505                	addi	a0,a0,1
 2a2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	fbe5                	bnez	a5,298 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2aa:	0005c503          	lbu	a0,0(a1)
}
 2ae:	40a7853b          	subw	a0,a5,a0
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret

00000000000002b8 <strlen>:

uint
strlen(const char *s)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2be:	00054783          	lbu	a5,0(a0)
 2c2:	cf91                	beqz	a5,2de <strlen+0x26>
 2c4:	0505                	addi	a0,a0,1
 2c6:	87aa                	mv	a5,a0
 2c8:	4685                	li	a3,1
 2ca:	9e89                	subw	a3,a3,a0
 2cc:	00f6853b          	addw	a0,a3,a5
 2d0:	0785                	addi	a5,a5,1
 2d2:	fff7c703          	lbu	a4,-1(a5)
 2d6:	fb7d                	bnez	a4,2cc <strlen+0x14>
    ;
  return n;
}
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret
  for(n = 0; s[n]; n++)
 2de:	4501                	li	a0,0
 2e0:	bfe5                	j	2d8 <strlen+0x20>

00000000000002e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2e8:	ce09                	beqz	a2,302 <memset+0x20>
 2ea:	87aa                	mv	a5,a0
 2ec:	fff6071b          	addiw	a4,a2,-1
 2f0:	1702                	slli	a4,a4,0x20
 2f2:	9301                	srli	a4,a4,0x20
 2f4:	0705                	addi	a4,a4,1
 2f6:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2fc:	0785                	addi	a5,a5,1
 2fe:	fee79de3          	bne	a5,a4,2f8 <memset+0x16>
  }
  return dst;
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <strchr>:

char*
strchr(const char *s, char c)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 30e:	00054783          	lbu	a5,0(a0)
 312:	cb99                	beqz	a5,328 <strchr+0x20>
    if(*s == c)
 314:	00f58763          	beq	a1,a5,322 <strchr+0x1a>
  for(; *s; s++)
 318:	0505                	addi	a0,a0,1
 31a:	00054783          	lbu	a5,0(a0)
 31e:	fbfd                	bnez	a5,314 <strchr+0xc>
      return (char*)s;
  return 0;
 320:	4501                	li	a0,0
}
 322:	6422                	ld	s0,8(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret
  return 0;
 328:	4501                	li	a0,0
 32a:	bfe5                	j	322 <strchr+0x1a>

000000000000032c <gets>:

char*
gets(char *buf, int max)
{
 32c:	711d                	addi	sp,sp,-96
 32e:	ec86                	sd	ra,88(sp)
 330:	e8a2                	sd	s0,80(sp)
 332:	e4a6                	sd	s1,72(sp)
 334:	e0ca                	sd	s2,64(sp)
 336:	fc4e                	sd	s3,56(sp)
 338:	f852                	sd	s4,48(sp)
 33a:	f456                	sd	s5,40(sp)
 33c:	f05a                	sd	s6,32(sp)
 33e:	ec5e                	sd	s7,24(sp)
 340:	1080                	addi	s0,sp,96
 342:	8baa                	mv	s7,a0
 344:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 346:	892a                	mv	s2,a0
 348:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 34a:	4aa9                	li	s5,10
 34c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 34e:	89a6                	mv	s3,s1
 350:	2485                	addiw	s1,s1,1
 352:	0344d663          	bge	s1,s4,37e <gets+0x52>
    cc = read(0, &c, 1);
 356:	4605                	li	a2,1
 358:	faf40593          	addi	a1,s0,-81
 35c:	4501                	li	a0,0
 35e:	1b8000ef          	jal	ra,516 <read>
    if(cc < 1)
 362:	00a05e63          	blez	a0,37e <gets+0x52>
    buf[i++] = c;
 366:	faf44783          	lbu	a5,-81(s0)
 36a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 36e:	01578763          	beq	a5,s5,37c <gets+0x50>
 372:	0905                	addi	s2,s2,1
 374:	fd679de3          	bne	a5,s6,34e <gets+0x22>
  for(i=0; i+1 < max; ){
 378:	89a6                	mv	s3,s1
 37a:	a011                	j	37e <gets+0x52>
 37c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 37e:	99de                	add	s3,s3,s7
 380:	00098023          	sb	zero,0(s3)
  return buf;
}
 384:	855e                	mv	a0,s7
 386:	60e6                	ld	ra,88(sp)
 388:	6446                	ld	s0,80(sp)
 38a:	64a6                	ld	s1,72(sp)
 38c:	6906                	ld	s2,64(sp)
 38e:	79e2                	ld	s3,56(sp)
 390:	7a42                	ld	s4,48(sp)
 392:	7aa2                	ld	s5,40(sp)
 394:	7b02                	ld	s6,32(sp)
 396:	6be2                	ld	s7,24(sp)
 398:	6125                	addi	sp,sp,96
 39a:	8082                	ret

000000000000039c <stat>:

int
stat(const char *n, struct stat *st)
{
 39c:	1101                	addi	sp,sp,-32
 39e:	ec06                	sd	ra,24(sp)
 3a0:	e822                	sd	s0,16(sp)
 3a2:	e426                	sd	s1,8(sp)
 3a4:	e04a                	sd	s2,0(sp)
 3a6:	1000                	addi	s0,sp,32
 3a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3aa:	4581                	li	a1,0
 3ac:	192000ef          	jal	ra,53e <open>
  if(fd < 0)
 3b0:	02054163          	bltz	a0,3d2 <stat+0x36>
 3b4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3b6:	85ca                	mv	a1,s2
 3b8:	19e000ef          	jal	ra,556 <fstat>
 3bc:	892a                	mv	s2,a0
  close(fd);
 3be:	8526                	mv	a0,s1
 3c0:	166000ef          	jal	ra,526 <close>
  return r;
}
 3c4:	854a                	mv	a0,s2
 3c6:	60e2                	ld	ra,24(sp)
 3c8:	6442                	ld	s0,16(sp)
 3ca:	64a2                	ld	s1,8(sp)
 3cc:	6902                	ld	s2,0(sp)
 3ce:	6105                	addi	sp,sp,32
 3d0:	8082                	ret
    return -1;
 3d2:	597d                	li	s2,-1
 3d4:	bfc5                	j	3c4 <stat+0x28>

00000000000003d6 <atoi>:

int
atoi(const char *s)
{
 3d6:	1141                	addi	sp,sp,-16
 3d8:	e422                	sd	s0,8(sp)
 3da:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3dc:	00054603          	lbu	a2,0(a0)
 3e0:	fd06079b          	addiw	a5,a2,-48
 3e4:	0ff7f793          	andi	a5,a5,255
 3e8:	4725                	li	a4,9
 3ea:	02f76963          	bltu	a4,a5,41c <atoi+0x46>
 3ee:	86aa                	mv	a3,a0
  n = 0;
 3f0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3f2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3f4:	0685                	addi	a3,a3,1
 3f6:	0025179b          	slliw	a5,a0,0x2
 3fa:	9fa9                	addw	a5,a5,a0
 3fc:	0017979b          	slliw	a5,a5,0x1
 400:	9fb1                	addw	a5,a5,a2
 402:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 406:	0006c603          	lbu	a2,0(a3)
 40a:	fd06071b          	addiw	a4,a2,-48
 40e:	0ff77713          	andi	a4,a4,255
 412:	fee5f1e3          	bgeu	a1,a4,3f4 <atoi+0x1e>
  return n;
}
 416:	6422                	ld	s0,8(sp)
 418:	0141                	addi	sp,sp,16
 41a:	8082                	ret
  n = 0;
 41c:	4501                	li	a0,0
 41e:	bfe5                	j	416 <atoi+0x40>

0000000000000420 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 420:	1141                	addi	sp,sp,-16
 422:	e422                	sd	s0,8(sp)
 424:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 426:	02b57663          	bgeu	a0,a1,452 <memmove+0x32>
    while(n-- > 0)
 42a:	02c05163          	blez	a2,44c <memmove+0x2c>
 42e:	fff6079b          	addiw	a5,a2,-1
 432:	1782                	slli	a5,a5,0x20
 434:	9381                	srli	a5,a5,0x20
 436:	0785                	addi	a5,a5,1
 438:	97aa                	add	a5,a5,a0
  dst = vdst;
 43a:	872a                	mv	a4,a0
      *dst++ = *src++;
 43c:	0585                	addi	a1,a1,1
 43e:	0705                	addi	a4,a4,1
 440:	fff5c683          	lbu	a3,-1(a1)
 444:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 448:	fee79ae3          	bne	a5,a4,43c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 44c:	6422                	ld	s0,8(sp)
 44e:	0141                	addi	sp,sp,16
 450:	8082                	ret
    dst += n;
 452:	00c50733          	add	a4,a0,a2
    src += n;
 456:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 458:	fec05ae3          	blez	a2,44c <memmove+0x2c>
 45c:	fff6079b          	addiw	a5,a2,-1
 460:	1782                	slli	a5,a5,0x20
 462:	9381                	srli	a5,a5,0x20
 464:	fff7c793          	not	a5,a5
 468:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 46a:	15fd                	addi	a1,a1,-1
 46c:	177d                	addi	a4,a4,-1
 46e:	0005c683          	lbu	a3,0(a1)
 472:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 476:	fee79ae3          	bne	a5,a4,46a <memmove+0x4a>
 47a:	bfc9                	j	44c <memmove+0x2c>

000000000000047c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 47c:	1141                	addi	sp,sp,-16
 47e:	e422                	sd	s0,8(sp)
 480:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 482:	ca05                	beqz	a2,4b2 <memcmp+0x36>
 484:	fff6069b          	addiw	a3,a2,-1
 488:	1682                	slli	a3,a3,0x20
 48a:	9281                	srli	a3,a3,0x20
 48c:	0685                	addi	a3,a3,1
 48e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 490:	00054783          	lbu	a5,0(a0)
 494:	0005c703          	lbu	a4,0(a1)
 498:	00e79863          	bne	a5,a4,4a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 49c:	0505                	addi	a0,a0,1
    p2++;
 49e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4a0:	fed518e3          	bne	a0,a3,490 <memcmp+0x14>
  }
  return 0;
 4a4:	4501                	li	a0,0
 4a6:	a019                	j	4ac <memcmp+0x30>
      return *p1 - *p2;
 4a8:	40e7853b          	subw	a0,a5,a4
}
 4ac:	6422                	ld	s0,8(sp)
 4ae:	0141                	addi	sp,sp,16
 4b0:	8082                	ret
  return 0;
 4b2:	4501                	li	a0,0
 4b4:	bfe5                	j	4ac <memcmp+0x30>

00000000000004b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b6:	1141                	addi	sp,sp,-16
 4b8:	e406                	sd	ra,8(sp)
 4ba:	e022                	sd	s0,0(sp)
 4bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4be:	f63ff0ef          	jal	ra,420 <memmove>
}
 4c2:	60a2                	ld	ra,8(sp)
 4c4:	6402                	ld	s0,0(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret

00000000000004ca <sbrk>:

char *
sbrk(int n) {
 4ca:	1141                	addi	sp,sp,-16
 4cc:	e406                	sd	ra,8(sp)
 4ce:	e022                	sd	s0,0(sp)
 4d0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4d2:	4585                	li	a1,1
 4d4:	0b2000ef          	jal	ra,586 <sys_sbrk>
}
 4d8:	60a2                	ld	ra,8(sp)
 4da:	6402                	ld	s0,0(sp)
 4dc:	0141                	addi	sp,sp,16
 4de:	8082                	ret

00000000000004e0 <sbrklazy>:

char *
sbrklazy(int n) {
 4e0:	1141                	addi	sp,sp,-16
 4e2:	e406                	sd	ra,8(sp)
 4e4:	e022                	sd	s0,0(sp)
 4e6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4e8:	4589                	li	a1,2
 4ea:	09c000ef          	jal	ra,586 <sys_sbrk>
}
 4ee:	60a2                	ld	ra,8(sp)
 4f0:	6402                	ld	s0,0(sp)
 4f2:	0141                	addi	sp,sp,16
 4f4:	8082                	ret

00000000000004f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4f6:	4885                	li	a7,1
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 4fe:	4889                	li	a7,2
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <wait>:
.global wait
wait:
 li a7, SYS_wait
 506:	488d                	li	a7,3
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 50e:	4891                	li	a7,4
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <read>:
.global read
read:
 li a7, SYS_read
 516:	4895                	li	a7,5
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <write>:
.global write
write:
 li a7, SYS_write
 51e:	48c1                	li	a7,16
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <close>:
.global close
close:
 li a7, SYS_close
 526:	48d5                	li	a7,21
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <kill>:
.global kill
kill:
 li a7, SYS_kill
 52e:	4899                	li	a7,6
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <exec>:
.global exec
exec:
 li a7, SYS_exec
 536:	489d                	li	a7,7
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <open>:
.global open
open:
 li a7, SYS_open
 53e:	48bd                	li	a7,15
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 546:	48c5                	li	a7,17
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 54e:	48c9                	li	a7,18
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 556:	48a1                	li	a7,8
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <link>:
.global link
link:
 li a7, SYS_link
 55e:	48cd                	li	a7,19
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 566:	48d1                	li	a7,20
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 56e:	48a5                	li	a7,9
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <dup>:
.global dup
dup:
 li a7, SYS_dup
 576:	48a9                	li	a7,10
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 57e:	48ad                	li	a7,11
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 586:	48b1                	li	a7,12
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <pause>:
.global pause
pause:
 li a7, SYS_pause
 58e:	48b5                	li	a7,13
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 596:	48b9                	li	a7,14
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 59e:	1101                	addi	sp,sp,-32
 5a0:	ec06                	sd	ra,24(sp)
 5a2:	e822                	sd	s0,16(sp)
 5a4:	1000                	addi	s0,sp,32
 5a6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5aa:	4605                	li	a2,1
 5ac:	fef40593          	addi	a1,s0,-17
 5b0:	f6fff0ef          	jal	ra,51e <write>
}
 5b4:	60e2                	ld	ra,24(sp)
 5b6:	6442                	ld	s0,16(sp)
 5b8:	6105                	addi	sp,sp,32
 5ba:	8082                	ret

00000000000005bc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5bc:	715d                	addi	sp,sp,-80
 5be:	e486                	sd	ra,72(sp)
 5c0:	e0a2                	sd	s0,64(sp)
 5c2:	fc26                	sd	s1,56(sp)
 5c4:	f84a                	sd	s2,48(sp)
 5c6:	f44e                	sd	s3,40(sp)
 5c8:	0880                	addi	s0,sp,80
 5ca:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5cc:	c299                	beqz	a3,5d2 <printint+0x16>
 5ce:	0805c663          	bltz	a1,65a <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5d2:	2581                	sext.w	a1,a1
  neg = 0;
 5d4:	4881                	li	a7,0
 5d6:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 5da:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5dc:	2601                	sext.w	a2,a2
 5de:	00000517          	auipc	a0,0x0
 5e2:	52250513          	addi	a0,a0,1314 # b00 <digits>
 5e6:	883a                	mv	a6,a4
 5e8:	2705                	addiw	a4,a4,1
 5ea:	02c5f7bb          	remuw	a5,a1,a2
 5ee:	1782                	slli	a5,a5,0x20
 5f0:	9381                	srli	a5,a5,0x20
 5f2:	97aa                	add	a5,a5,a0
 5f4:	0007c783          	lbu	a5,0(a5)
 5f8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5fc:	0005879b          	sext.w	a5,a1
 600:	02c5d5bb          	divuw	a1,a1,a2
 604:	0685                	addi	a3,a3,1
 606:	fec7f0e3          	bgeu	a5,a2,5e6 <printint+0x2a>
  if(neg)
 60a:	00088b63          	beqz	a7,620 <printint+0x64>
    buf[i++] = '-';
 60e:	fd040793          	addi	a5,s0,-48
 612:	973e                	add	a4,a4,a5
 614:	02d00793          	li	a5,45
 618:	fef70423          	sb	a5,-24(a4)
 61c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 620:	02e05663          	blez	a4,64c <printint+0x90>
 624:	fb840793          	addi	a5,s0,-72
 628:	00e78933          	add	s2,a5,a4
 62c:	fff78993          	addi	s3,a5,-1
 630:	99ba                	add	s3,s3,a4
 632:	377d                	addiw	a4,a4,-1
 634:	1702                	slli	a4,a4,0x20
 636:	9301                	srli	a4,a4,0x20
 638:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 63c:	fff94583          	lbu	a1,-1(s2)
 640:	8526                	mv	a0,s1
 642:	f5dff0ef          	jal	ra,59e <putc>
  while(--i >= 0)
 646:	197d                	addi	s2,s2,-1
 648:	ff391ae3          	bne	s2,s3,63c <printint+0x80>
}
 64c:	60a6                	ld	ra,72(sp)
 64e:	6406                	ld	s0,64(sp)
 650:	74e2                	ld	s1,56(sp)
 652:	7942                	ld	s2,48(sp)
 654:	79a2                	ld	s3,40(sp)
 656:	6161                	addi	sp,sp,80
 658:	8082                	ret
    x = -xx;
 65a:	40b005bb          	negw	a1,a1
    neg = 1;
 65e:	4885                	li	a7,1
    x = -xx;
 660:	bf9d                	j	5d6 <printint+0x1a>

0000000000000662 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 662:	7119                	addi	sp,sp,-128
 664:	fc86                	sd	ra,120(sp)
 666:	f8a2                	sd	s0,112(sp)
 668:	f4a6                	sd	s1,104(sp)
 66a:	f0ca                	sd	s2,96(sp)
 66c:	ecce                	sd	s3,88(sp)
 66e:	e8d2                	sd	s4,80(sp)
 670:	e4d6                	sd	s5,72(sp)
 672:	e0da                	sd	s6,64(sp)
 674:	fc5e                	sd	s7,56(sp)
 676:	f862                	sd	s8,48(sp)
 678:	f466                	sd	s9,40(sp)
 67a:	f06a                	sd	s10,32(sp)
 67c:	ec6e                	sd	s11,24(sp)
 67e:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 680:	0005c903          	lbu	s2,0(a1)
 684:	24090c63          	beqz	s2,8dc <vprintf+0x27a>
 688:	8b2a                	mv	s6,a0
 68a:	8a2e                	mv	s4,a1
 68c:	8bb2                	mv	s7,a2
  state = 0;
 68e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 690:	4481                	li	s1,0
 692:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 694:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 698:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 69c:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6a0:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a4:	00000c97          	auipc	s9,0x0
 6a8:	45cc8c93          	addi	s9,s9,1116 # b00 <digits>
 6ac:	a005                	j	6cc <vprintf+0x6a>
        putc(fd, c0);
 6ae:	85ca                	mv	a1,s2
 6b0:	855a                	mv	a0,s6
 6b2:	eedff0ef          	jal	ra,59e <putc>
 6b6:	a019                	j	6bc <vprintf+0x5a>
    } else if(state == '%'){
 6b8:	03598263          	beq	s3,s5,6dc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6bc:	2485                	addiw	s1,s1,1
 6be:	8726                	mv	a4,s1
 6c0:	009a07b3          	add	a5,s4,s1
 6c4:	0007c903          	lbu	s2,0(a5)
 6c8:	20090a63          	beqz	s2,8dc <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 6cc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6d0:	fe0994e3          	bnez	s3,6b8 <vprintf+0x56>
      if(c0 == '%'){
 6d4:	fd579de3          	bne	a5,s5,6ae <vprintf+0x4c>
        state = '%';
 6d8:	89be                	mv	s3,a5
 6da:	b7cd                	j	6bc <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6dc:	c3c1                	beqz	a5,75c <vprintf+0xfa>
 6de:	00ea06b3          	add	a3,s4,a4
 6e2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6e6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6e8:	c681                	beqz	a3,6f0 <vprintf+0x8e>
 6ea:	9752                	add	a4,a4,s4
 6ec:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6f0:	03878e63          	beq	a5,s8,72c <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 6f4:	05a78863          	beq	a5,s10,744 <vprintf+0xe2>
      } else if(c0 == 'u'){
 6f8:	0db78b63          	beq	a5,s11,7ce <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6fc:	07800713          	li	a4,120
 700:	10e78d63          	beq	a5,a4,81a <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 704:	07000713          	li	a4,112
 708:	14e78263          	beq	a5,a4,84c <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 70c:	06300713          	li	a4,99
 710:	16e78f63          	beq	a5,a4,88e <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 714:	07300713          	li	a4,115
 718:	18e78563          	beq	a5,a4,8a2 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 71c:	05579063          	bne	a5,s5,75c <vprintf+0xfa>
        putc(fd, '%');
 720:	85d6                	mv	a1,s5
 722:	855a                	mv	a0,s6
 724:	e7bff0ef          	jal	ra,59e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 728:	4981                	li	s3,0
 72a:	bf49                	j	6bc <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 72c:	008b8913          	addi	s2,s7,8
 730:	4685                	li	a3,1
 732:	4629                	li	a2,10
 734:	000ba583          	lw	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	e83ff0ef          	jal	ra,5bc <printint>
 73e:	8bca                	mv	s7,s2
      state = 0;
 740:	4981                	li	s3,0
 742:	bfad                	j	6bc <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 744:	03868663          	beq	a3,s8,770 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 748:	05a68163          	beq	a3,s10,78a <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 74c:	09b68d63          	beq	a3,s11,7e6 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 750:	03a68f63          	beq	a3,s10,78e <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 754:	07800793          	li	a5,120
 758:	0cf68d63          	beq	a3,a5,832 <vprintf+0x1d0>
        putc(fd, '%');
 75c:	85d6                	mv	a1,s5
 75e:	855a                	mv	a0,s6
 760:	e3fff0ef          	jal	ra,59e <putc>
        putc(fd, c0);
 764:	85ca                	mv	a1,s2
 766:	855a                	mv	a0,s6
 768:	e37ff0ef          	jal	ra,59e <putc>
      state = 0;
 76c:	4981                	li	s3,0
 76e:	b7b9                	j	6bc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 770:	008b8913          	addi	s2,s7,8
 774:	4685                	li	a3,1
 776:	4629                	li	a2,10
 778:	000bb583          	ld	a1,0(s7)
 77c:	855a                	mv	a0,s6
 77e:	e3fff0ef          	jal	ra,5bc <printint>
        i += 1;
 782:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 784:	8bca                	mv	s7,s2
      state = 0;
 786:	4981                	li	s3,0
        i += 1;
 788:	bf15                	j	6bc <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 78a:	03860563          	beq	a2,s8,7b4 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 78e:	07b60963          	beq	a2,s11,800 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 792:	07800793          	li	a5,120
 796:	fcf613e3          	bne	a2,a5,75c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 79a:	008b8913          	addi	s2,s7,8
 79e:	4681                	li	a3,0
 7a0:	4641                	li	a2,16
 7a2:	000bb583          	ld	a1,0(s7)
 7a6:	855a                	mv	a0,s6
 7a8:	e15ff0ef          	jal	ra,5bc <printint>
        i += 2;
 7ac:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ae:	8bca                	mv	s7,s2
      state = 0;
 7b0:	4981                	li	s3,0
        i += 2;
 7b2:	b729                	j	6bc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b4:	008b8913          	addi	s2,s7,8
 7b8:	4685                	li	a3,1
 7ba:	4629                	li	a2,10
 7bc:	000bb583          	ld	a1,0(s7)
 7c0:	855a                	mv	a0,s6
 7c2:	dfbff0ef          	jal	ra,5bc <printint>
        i += 2;
 7c6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c8:	8bca                	mv	s7,s2
      state = 0;
 7ca:	4981                	li	s3,0
        i += 2;
 7cc:	bdc5                	j	6bc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7ce:	008b8913          	addi	s2,s7,8
 7d2:	4681                	li	a3,0
 7d4:	4629                	li	a2,10
 7d6:	000be583          	lwu	a1,0(s7)
 7da:	855a                	mv	a0,s6
 7dc:	de1ff0ef          	jal	ra,5bc <printint>
 7e0:	8bca                	mv	s7,s2
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	bde1                	j	6bc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e6:	008b8913          	addi	s2,s7,8
 7ea:	4681                	li	a3,0
 7ec:	4629                	li	a2,10
 7ee:	000bb583          	ld	a1,0(s7)
 7f2:	855a                	mv	a0,s6
 7f4:	dc9ff0ef          	jal	ra,5bc <printint>
        i += 1;
 7f8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fa:	8bca                	mv	s7,s2
      state = 0;
 7fc:	4981                	li	s3,0
        i += 1;
 7fe:	bd7d                	j	6bc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 800:	008b8913          	addi	s2,s7,8
 804:	4681                	li	a3,0
 806:	4629                	li	a2,10
 808:	000bb583          	ld	a1,0(s7)
 80c:	855a                	mv	a0,s6
 80e:	dafff0ef          	jal	ra,5bc <printint>
        i += 2;
 812:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 814:	8bca                	mv	s7,s2
      state = 0;
 816:	4981                	li	s3,0
        i += 2;
 818:	b555                	j	6bc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 81a:	008b8913          	addi	s2,s7,8
 81e:	4681                	li	a3,0
 820:	4641                	li	a2,16
 822:	000be583          	lwu	a1,0(s7)
 826:	855a                	mv	a0,s6
 828:	d95ff0ef          	jal	ra,5bc <printint>
 82c:	8bca                	mv	s7,s2
      state = 0;
 82e:	4981                	li	s3,0
 830:	b571                	j	6bc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 832:	008b8913          	addi	s2,s7,8
 836:	4681                	li	a3,0
 838:	4641                	li	a2,16
 83a:	000bb583          	ld	a1,0(s7)
 83e:	855a                	mv	a0,s6
 840:	d7dff0ef          	jal	ra,5bc <printint>
        i += 1;
 844:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 846:	8bca                	mv	s7,s2
      state = 0;
 848:	4981                	li	s3,0
        i += 1;
 84a:	bd8d                	j	6bc <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 84c:	008b8793          	addi	a5,s7,8
 850:	f8f43423          	sd	a5,-120(s0)
 854:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 858:	03000593          	li	a1,48
 85c:	855a                	mv	a0,s6
 85e:	d41ff0ef          	jal	ra,59e <putc>
  putc(fd, 'x');
 862:	07800593          	li	a1,120
 866:	855a                	mv	a0,s6
 868:	d37ff0ef          	jal	ra,59e <putc>
 86c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 86e:	03c9d793          	srli	a5,s3,0x3c
 872:	97e6                	add	a5,a5,s9
 874:	0007c583          	lbu	a1,0(a5)
 878:	855a                	mv	a0,s6
 87a:	d25ff0ef          	jal	ra,59e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 87e:	0992                	slli	s3,s3,0x4
 880:	397d                	addiw	s2,s2,-1
 882:	fe0916e3          	bnez	s2,86e <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 886:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 88a:	4981                	li	s3,0
 88c:	bd05                	j	6bc <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 88e:	008b8913          	addi	s2,s7,8
 892:	000bc583          	lbu	a1,0(s7)
 896:	855a                	mv	a0,s6
 898:	d07ff0ef          	jal	ra,59e <putc>
 89c:	8bca                	mv	s7,s2
      state = 0;
 89e:	4981                	li	s3,0
 8a0:	bd31                	j	6bc <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 8a2:	008b8993          	addi	s3,s7,8
 8a6:	000bb903          	ld	s2,0(s7)
 8aa:	00090f63          	beqz	s2,8c8 <vprintf+0x266>
        for(; *s; s++)
 8ae:	00094583          	lbu	a1,0(s2)
 8b2:	c195                	beqz	a1,8d6 <vprintf+0x274>
          putc(fd, *s);
 8b4:	855a                	mv	a0,s6
 8b6:	ce9ff0ef          	jal	ra,59e <putc>
        for(; *s; s++)
 8ba:	0905                	addi	s2,s2,1
 8bc:	00094583          	lbu	a1,0(s2)
 8c0:	f9f5                	bnez	a1,8b4 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 8c2:	8bce                	mv	s7,s3
      state = 0;
 8c4:	4981                	li	s3,0
 8c6:	bbdd                	j	6bc <vprintf+0x5a>
          s = "(null)";
 8c8:	00000917          	auipc	s2,0x0
 8cc:	23090913          	addi	s2,s2,560 # af8 <malloc+0x11a>
        for(; *s; s++)
 8d0:	02800593          	li	a1,40
 8d4:	b7c5                	j	8b4 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 8d6:	8bce                	mv	s7,s3
      state = 0;
 8d8:	4981                	li	s3,0
 8da:	b3cd                	j	6bc <vprintf+0x5a>
    }
  }
}
 8dc:	70e6                	ld	ra,120(sp)
 8de:	7446                	ld	s0,112(sp)
 8e0:	74a6                	ld	s1,104(sp)
 8e2:	7906                	ld	s2,96(sp)
 8e4:	69e6                	ld	s3,88(sp)
 8e6:	6a46                	ld	s4,80(sp)
 8e8:	6aa6                	ld	s5,72(sp)
 8ea:	6b06                	ld	s6,64(sp)
 8ec:	7be2                	ld	s7,56(sp)
 8ee:	7c42                	ld	s8,48(sp)
 8f0:	7ca2                	ld	s9,40(sp)
 8f2:	7d02                	ld	s10,32(sp)
 8f4:	6de2                	ld	s11,24(sp)
 8f6:	6109                	addi	sp,sp,128
 8f8:	8082                	ret

00000000000008fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8fa:	715d                	addi	sp,sp,-80
 8fc:	ec06                	sd	ra,24(sp)
 8fe:	e822                	sd	s0,16(sp)
 900:	1000                	addi	s0,sp,32
 902:	e010                	sd	a2,0(s0)
 904:	e414                	sd	a3,8(s0)
 906:	e818                	sd	a4,16(s0)
 908:	ec1c                	sd	a5,24(s0)
 90a:	03043023          	sd	a6,32(s0)
 90e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 912:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 916:	8622                	mv	a2,s0
 918:	d4bff0ef          	jal	ra,662 <vprintf>
}
 91c:	60e2                	ld	ra,24(sp)
 91e:	6442                	ld	s0,16(sp)
 920:	6161                	addi	sp,sp,80
 922:	8082                	ret

0000000000000924 <printf>:

void
printf(const char *fmt, ...)
{
 924:	711d                	addi	sp,sp,-96
 926:	ec06                	sd	ra,24(sp)
 928:	e822                	sd	s0,16(sp)
 92a:	1000                	addi	s0,sp,32
 92c:	e40c                	sd	a1,8(s0)
 92e:	e810                	sd	a2,16(s0)
 930:	ec14                	sd	a3,24(s0)
 932:	f018                	sd	a4,32(s0)
 934:	f41c                	sd	a5,40(s0)
 936:	03043823          	sd	a6,48(s0)
 93a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 93e:	00840613          	addi	a2,s0,8
 942:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 946:	85aa                	mv	a1,a0
 948:	4505                	li	a0,1
 94a:	d19ff0ef          	jal	ra,662 <vprintf>
}
 94e:	60e2                	ld	ra,24(sp)
 950:	6442                	ld	s0,16(sp)
 952:	6125                	addi	sp,sp,96
 954:	8082                	ret

0000000000000956 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 956:	1141                	addi	sp,sp,-16
 958:	e422                	sd	s0,8(sp)
 95a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 95c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 960:	00000797          	auipc	a5,0x0
 964:	6a07b783          	ld	a5,1696(a5) # 1000 <freep>
 968:	a805                	j	998 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 96a:	4618                	lw	a4,8(a2)
 96c:	9db9                	addw	a1,a1,a4
 96e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 972:	6398                	ld	a4,0(a5)
 974:	6318                	ld	a4,0(a4)
 976:	fee53823          	sd	a4,-16(a0)
 97a:	a091                	j	9be <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 97c:	ff852703          	lw	a4,-8(a0)
 980:	9e39                	addw	a2,a2,a4
 982:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 984:	ff053703          	ld	a4,-16(a0)
 988:	e398                	sd	a4,0(a5)
 98a:	a099                	j	9d0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 98c:	6398                	ld	a4,0(a5)
 98e:	00e7e463          	bltu	a5,a4,996 <free+0x40>
 992:	00e6ea63          	bltu	a3,a4,9a6 <free+0x50>
{
 996:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 998:	fed7fae3          	bgeu	a5,a3,98c <free+0x36>
 99c:	6398                	ld	a4,0(a5)
 99e:	00e6e463          	bltu	a3,a4,9a6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a2:	fee7eae3          	bltu	a5,a4,996 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9a6:	ff852583          	lw	a1,-8(a0)
 9aa:	6390                	ld	a2,0(a5)
 9ac:	02059713          	slli	a4,a1,0x20
 9b0:	9301                	srli	a4,a4,0x20
 9b2:	0712                	slli	a4,a4,0x4
 9b4:	9736                	add	a4,a4,a3
 9b6:	fae60ae3          	beq	a2,a4,96a <free+0x14>
    bp->s.ptr = p->s.ptr;
 9ba:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9be:	4790                	lw	a2,8(a5)
 9c0:	02061713          	slli	a4,a2,0x20
 9c4:	9301                	srli	a4,a4,0x20
 9c6:	0712                	slli	a4,a4,0x4
 9c8:	973e                	add	a4,a4,a5
 9ca:	fae689e3          	beq	a3,a4,97c <free+0x26>
  } else
    p->s.ptr = bp;
 9ce:	e394                	sd	a3,0(a5)
  freep = p;
 9d0:	00000717          	auipc	a4,0x0
 9d4:	62f73823          	sd	a5,1584(a4) # 1000 <freep>
}
 9d8:	6422                	ld	s0,8(sp)
 9da:	0141                	addi	sp,sp,16
 9dc:	8082                	ret

00000000000009de <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9de:	7139                	addi	sp,sp,-64
 9e0:	fc06                	sd	ra,56(sp)
 9e2:	f822                	sd	s0,48(sp)
 9e4:	f426                	sd	s1,40(sp)
 9e6:	f04a                	sd	s2,32(sp)
 9e8:	ec4e                	sd	s3,24(sp)
 9ea:	e852                	sd	s4,16(sp)
 9ec:	e456                	sd	s5,8(sp)
 9ee:	e05a                	sd	s6,0(sp)
 9f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f2:	02051493          	slli	s1,a0,0x20
 9f6:	9081                	srli	s1,s1,0x20
 9f8:	04bd                	addi	s1,s1,15
 9fa:	8091                	srli	s1,s1,0x4
 9fc:	0014899b          	addiw	s3,s1,1
 a00:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a02:	00000517          	auipc	a0,0x0
 a06:	5fe53503          	ld	a0,1534(a0) # 1000 <freep>
 a0a:	c515                	beqz	a0,a36 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0e:	4798                	lw	a4,8(a5)
 a10:	02977f63          	bgeu	a4,s1,a4e <malloc+0x70>
 a14:	8a4e                	mv	s4,s3
 a16:	0009871b          	sext.w	a4,s3
 a1a:	6685                	lui	a3,0x1
 a1c:	00d77363          	bgeu	a4,a3,a22 <malloc+0x44>
 a20:	6a05                	lui	s4,0x1
 a22:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a26:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a2a:	00000917          	auipc	s2,0x0
 a2e:	5d690913          	addi	s2,s2,1494 # 1000 <freep>
  if(p == SBRK_ERROR)
 a32:	5afd                	li	s5,-1
 a34:	a0bd                	j	aa2 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 a36:	00001797          	auipc	a5,0x1
 a3a:	9da78793          	addi	a5,a5,-1574 # 1410 <base>
 a3e:	00000717          	auipc	a4,0x0
 a42:	5cf73123          	sd	a5,1474(a4) # 1000 <freep>
 a46:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a48:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a4c:	b7e1                	j	a14 <malloc+0x36>
      if(p->s.size == nunits)
 a4e:	02e48b63          	beq	s1,a4,a84 <malloc+0xa6>
        p->s.size -= nunits;
 a52:	4137073b          	subw	a4,a4,s3
 a56:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a58:	1702                	slli	a4,a4,0x20
 a5a:	9301                	srli	a4,a4,0x20
 a5c:	0712                	slli	a4,a4,0x4
 a5e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a60:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a64:	00000717          	auipc	a4,0x0
 a68:	58a73e23          	sd	a0,1436(a4) # 1000 <freep>
      return (void*)(p + 1);
 a6c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a70:	70e2                	ld	ra,56(sp)
 a72:	7442                	ld	s0,48(sp)
 a74:	74a2                	ld	s1,40(sp)
 a76:	7902                	ld	s2,32(sp)
 a78:	69e2                	ld	s3,24(sp)
 a7a:	6a42                	ld	s4,16(sp)
 a7c:	6aa2                	ld	s5,8(sp)
 a7e:	6b02                	ld	s6,0(sp)
 a80:	6121                	addi	sp,sp,64
 a82:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a84:	6398                	ld	a4,0(a5)
 a86:	e118                	sd	a4,0(a0)
 a88:	bff1                	j	a64 <malloc+0x86>
  hp->s.size = nu;
 a8a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a8e:	0541                	addi	a0,a0,16
 a90:	ec7ff0ef          	jal	ra,956 <free>
  return freep;
 a94:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a98:	dd61                	beqz	a0,a70 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a9c:	4798                	lw	a4,8(a5)
 a9e:	fa9778e3          	bgeu	a4,s1,a4e <malloc+0x70>
    if(p == freep)
 aa2:	00093703          	ld	a4,0(s2)
 aa6:	853e                	mv	a0,a5
 aa8:	fef719e3          	bne	a4,a5,a9a <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 aac:	8552                	mv	a0,s4
 aae:	a1dff0ef          	jal	ra,4ca <sbrk>
  if(p == SBRK_ERROR)
 ab2:	fd551ce3          	bne	a0,s5,a8a <malloc+0xac>
        return 0;
 ab6:	4501                	li	a0,0
 ab8:	bf65                	j	a70 <malloc+0x92>
