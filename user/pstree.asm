
user/_pstree:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_tree>:
#define MAX_PROC 64


// Function to print the tree using recursion
void print_tree(struct proc_info *procs, int num_procs, int parent_pid, int depth) {
    for (int i = 0; i < num_procs; i++) {
   0:	0cb05463          	blez	a1,c8 <print_tree+0xc8>
void print_tree(struct proc_info *procs, int num_procs, int parent_pid, int depth) {
   4:	7159                	addi	sp,sp,-112
   6:	f486                	sd	ra,104(sp)
   8:	f0a2                	sd	s0,96(sp)
   a:	eca6                	sd	s1,88(sp)
   c:	e8ca                	sd	s2,80(sp)
   e:	e4ce                	sd	s3,72(sp)
  10:	e0d2                	sd	s4,64(sp)
  12:	fc56                	sd	s5,56(sp)
  14:	f85a                	sd	s6,48(sp)
  16:	f45e                	sd	s7,40(sp)
  18:	f062                	sd	s8,32(sp)
  1a:	ec66                	sd	s9,24(sp)
  1c:	e86a                	sd	s10,16(sp)
  1e:	e46e                	sd	s11,8(sp)
  20:	1880                	addi	s0,sp,112
  22:	8c2a                	mv	s8,a0
  24:	8bae                	mv	s7,a1
  26:	8ab2                	mv	s5,a2
  28:	8a36                	mv	s4,a3
  2a:	84aa                	mv	s1,a0
  2c:	fff5899b          	addiw	s3,a1,-1
  30:	02099793          	slli	a5,s3,0x20
  34:	9381                	srli	a5,a5,0x20
  36:	00179993          	slli	s3,a5,0x1
  3a:	99be                	add	s3,s3,a5
  3c:	098e                	slli	s3,s3,0x3
  3e:	01850793          	addi	a5,a0,24
  42:	99be                	add	s3,s3,a5
            } else {
                printf("└── %s (%d)\n", procs[i].name, procs[i].pid);
            }

            // Look for children of this process
            print_tree(procs, num_procs, procs[i].pid, depth + 1);
  44:	00168d1b          	addiw	s10,a3,1
                printf("|    ");
  48:	00001b17          	auipc	s6,0x1
  4c:	928b0b13          	addi	s6,s6,-1752 # 970 <malloc+0xdc>
                printf("├──  %s (%d)\n", procs[i].name, procs[i].pid);
  50:	00001d97          	auipc	s11,0x1
  54:	928d8d93          	addi	s11,s11,-1752 # 978 <malloc+0xe4>
        if (procs[i].ppid == parent_pid) {
  58:	8ca6                	mv	s9,s1
  5a:	40dc                	lw	a5,4(s1)
  5c:	03578463          	beq	a5,s5,84 <print_tree+0x84>
    for (int i = 0; i < num_procs; i++) {
  60:	04e1                	addi	s1,s1,24
  62:	ff349be3          	bne	s1,s3,58 <print_tree+0x58>
        }
    }
}
  66:	70a6                	ld	ra,104(sp)
  68:	7406                	ld	s0,96(sp)
  6a:	64e6                	ld	s1,88(sp)
  6c:	6946                	ld	s2,80(sp)
  6e:	69a6                	ld	s3,72(sp)
  70:	6a06                	ld	s4,64(sp)
  72:	7ae2                	ld	s5,56(sp)
  74:	7b42                	ld	s6,48(sp)
  76:	7ba2                	ld	s7,40(sp)
  78:	7c02                	ld	s8,32(sp)
  7a:	6ce2                	ld	s9,24(sp)
  7c:	6d42                	ld	s10,16(sp)
  7e:	6da2                	ld	s11,8(sp)
  80:	6165                	addi	sp,sp,112
  82:	8082                	ret
            for (int j = 0; j < depth; j++) {
  84:	03405863          	blez	s4,b4 <print_tree+0xb4>
  88:	4901                	li	s2,0
                printf("|    ");
  8a:	855a                	mv	a0,s6
  8c:	74e000ef          	jal	ra,7da <printf>
            for (int j = 0; j < depth; j++) {
  90:	2905                	addiw	s2,s2,1
  92:	ff2a1ce3          	bne	s4,s2,8a <print_tree+0x8a>
                printf("├──  %s (%d)\n", procs[i].name, procs[i].pid);
  96:	000ca603          	lw	a2,0(s9)
  9a:	00848593          	addi	a1,s1,8
  9e:	856e                	mv	a0,s11
  a0:	73a000ef          	jal	ra,7da <printf>
            print_tree(procs, num_procs, procs[i].pid, depth + 1);
  a4:	86ea                	mv	a3,s10
  a6:	000ca603          	lw	a2,0(s9)
  aa:	85de                	mv	a1,s7
  ac:	8562                	mv	a0,s8
  ae:	f53ff0ef          	jal	ra,0 <print_tree>
  b2:	b77d                	j	60 <print_tree+0x60>
                printf("└── %s (%d)\n", procs[i].name, procs[i].pid);
  b4:	4090                	lw	a2,0(s1)
  b6:	00848593          	addi	a1,s1,8
  ba:	00001517          	auipc	a0,0x1
  be:	8d650513          	addi	a0,a0,-1834 # 990 <malloc+0xfc>
  c2:	718000ef          	jal	ra,7da <printf>
  c6:	bff9                	j	a4 <print_tree+0xa4>
  c8:	8082                	ret

00000000000000ca <main>:


int main(int argc, char *argv[]) {
  ca:	9f010113          	addi	sp,sp,-1552
  ce:	60113423          	sd	ra,1544(sp)
  d2:	60813023          	sd	s0,1536(sp)
  d6:	61010413          	addi	s0,sp,1552
    struct proc_info procs[MAX_PROC];
    int n;

    // TODO: Replace this block with the real syscall later
     n = getproctree(procs); 
  da:	9f040513          	addi	a0,s0,-1552
  de:	36e000ef          	jal	ra,44c <getproctree>
    procs[2] = (struct proc_info){3, 1, "other"};
    procs[3] = (struct proc_info){4, 2, "pstree"};
    procs[4] = (struct proc_info){5, 2, "grep"};
*/

    if (n < 0) {
  e2:	00054c63          	bltz	a0,fa <main+0x30>
  e6:	85aa                	mv	a1,a0
        printf("Error getting process data\n");
        exit(1);
    }

    // Start printing from the top of the tree
    print_tree(procs, n, 0, 0);
  e8:	4681                	li	a3,0
  ea:	4601                	li	a2,0
  ec:	9f040513          	addi	a0,s0,-1552
  f0:	f11ff0ef          	jal	ra,0 <print_tree>

    exit(0);
  f4:	4501                	li	a0,0
  f6:	2b6000ef          	jal	ra,3ac <exit>
        printf("Error getting process data\n");
  fa:	00001517          	auipc	a0,0x1
  fe:	8ae50513          	addi	a0,a0,-1874 # 9a8 <malloc+0x114>
 102:	6d8000ef          	jal	ra,7da <printf>
        exit(1);
 106:	4505                	li	a0,1
 108:	2a4000ef          	jal	ra,3ac <exit>

000000000000010c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  extern int main();
  main();
 114:	fb7ff0ef          	jal	ra,ca <main>
  exit(0);
 118:	4501                	li	a0,0
 11a:	292000ef          	jal	ra,3ac <exit>

000000000000011e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 124:	87aa                	mv	a5,a0
 126:	0585                	addi	a1,a1,1
 128:	0785                	addi	a5,a5,1
 12a:	fff5c703          	lbu	a4,-1(a1)
 12e:	fee78fa3          	sb	a4,-1(a5)
 132:	fb75                	bnez	a4,126 <strcpy+0x8>
    ;
  return os;
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret

000000000000013a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	cb91                	beqz	a5,158 <strcmp+0x1e>
 146:	0005c703          	lbu	a4,0(a1)
 14a:	00f71763          	bne	a4,a5,158 <strcmp+0x1e>
    p++, q++;
 14e:	0505                	addi	a0,a0,1
 150:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 152:	00054783          	lbu	a5,0(a0)
 156:	fbe5                	bnez	a5,146 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 158:	0005c503          	lbu	a0,0(a1)
}
 15c:	40a7853b          	subw	a0,a5,a0
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strlen>:

uint
strlen(const char *s)
{
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf91                	beqz	a5,18c <strlen+0x26>
 172:	0505                	addi	a0,a0,1
 174:	87aa                	mv	a5,a0
 176:	4685                	li	a3,1
 178:	9e89                	subw	a3,a3,a0
 17a:	00f6853b          	addw	a0,a3,a5
 17e:	0785                	addi	a5,a5,1
 180:	fff7c703          	lbu	a4,-1(a5)
 184:	fb7d                	bnez	a4,17a <strlen+0x14>
    ;
  return n;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  for(n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfe5                	j	186 <strlen+0x20>

0000000000000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 196:	ce09                	beqz	a2,1b0 <memset+0x20>
 198:	87aa                	mv	a5,a0
 19a:	fff6071b          	addiw	a4,a2,-1
 19e:	1702                	slli	a4,a4,0x20
 1a0:	9301                	srli	a4,a4,0x20
 1a2:	0705                	addi	a4,a4,1
 1a4:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1a6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1aa:	0785                	addi	a5,a5,1
 1ac:	fee79de3          	bne	a5,a4,1a6 <memset+0x16>
  }
  return dst;
}
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strchr>:

char*
strchr(const char *s, char c)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cb99                	beqz	a5,1d6 <strchr+0x20>
    if(*s == c)
 1c2:	00f58763          	beq	a1,a5,1d0 <strchr+0x1a>
  for(; *s; s++)
 1c6:	0505                	addi	a0,a0,1
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	fbfd                	bnez	a5,1c2 <strchr+0xc>
      return (char*)s;
  return 0;
 1ce:	4501                	li	a0,0
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret
  return 0;
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <strchr+0x1a>

00000000000001da <gets>:

char*
gets(char *buf, int max)
{
 1da:	711d                	addi	sp,sp,-96
 1dc:	ec86                	sd	ra,88(sp)
 1de:	e8a2                	sd	s0,80(sp)
 1e0:	e4a6                	sd	s1,72(sp)
 1e2:	e0ca                	sd	s2,64(sp)
 1e4:	fc4e                	sd	s3,56(sp)
 1e6:	f852                	sd	s4,48(sp)
 1e8:	f456                	sd	s5,40(sp)
 1ea:	f05a                	sd	s6,32(sp)
 1ec:	ec5e                	sd	s7,24(sp)
 1ee:	1080                	addi	s0,sp,96
 1f0:	8baa                	mv	s7,a0
 1f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f4:	892a                	mv	s2,a0
 1f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f8:	4aa9                	li	s5,10
 1fa:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1fc:	89a6                	mv	s3,s1
 1fe:	2485                	addiw	s1,s1,1
 200:	0344d663          	bge	s1,s4,22c <gets+0x52>
    cc = read(0, &c, 1);
 204:	4605                	li	a2,1
 206:	faf40593          	addi	a1,s0,-81
 20a:	4501                	li	a0,0
 20c:	1b8000ef          	jal	ra,3c4 <read>
    if(cc < 1)
 210:	00a05e63          	blez	a0,22c <gets+0x52>
    buf[i++] = c;
 214:	faf44783          	lbu	a5,-81(s0)
 218:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21c:	01578763          	beq	a5,s5,22a <gets+0x50>
 220:	0905                	addi	s2,s2,1
 222:	fd679de3          	bne	a5,s6,1fc <gets+0x22>
  for(i=0; i+1 < max; ){
 226:	89a6                	mv	s3,s1
 228:	a011                	j	22c <gets+0x52>
 22a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 22c:	99de                	add	s3,s3,s7
 22e:	00098023          	sb	zero,0(s3)
  return buf;
}
 232:	855e                	mv	a0,s7
 234:	60e6                	ld	ra,88(sp)
 236:	6446                	ld	s0,80(sp)
 238:	64a6                	ld	s1,72(sp)
 23a:	6906                	ld	s2,64(sp)
 23c:	79e2                	ld	s3,56(sp)
 23e:	7a42                	ld	s4,48(sp)
 240:	7aa2                	ld	s5,40(sp)
 242:	7b02                	ld	s6,32(sp)
 244:	6be2                	ld	s7,24(sp)
 246:	6125                	addi	sp,sp,96
 248:	8082                	ret

000000000000024a <stat>:

int
stat(const char *n, struct stat *st)
{
 24a:	1101                	addi	sp,sp,-32
 24c:	ec06                	sd	ra,24(sp)
 24e:	e822                	sd	s0,16(sp)
 250:	e426                	sd	s1,8(sp)
 252:	e04a                	sd	s2,0(sp)
 254:	1000                	addi	s0,sp,32
 256:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 258:	4581                	li	a1,0
 25a:	192000ef          	jal	ra,3ec <open>
  if(fd < 0)
 25e:	02054163          	bltz	a0,280 <stat+0x36>
 262:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 264:	85ca                	mv	a1,s2
 266:	19e000ef          	jal	ra,404 <fstat>
 26a:	892a                	mv	s2,a0
  close(fd);
 26c:	8526                	mv	a0,s1
 26e:	166000ef          	jal	ra,3d4 <close>
  return r;
}
 272:	854a                	mv	a0,s2
 274:	60e2                	ld	ra,24(sp)
 276:	6442                	ld	s0,16(sp)
 278:	64a2                	ld	s1,8(sp)
 27a:	6902                	ld	s2,0(sp)
 27c:	6105                	addi	sp,sp,32
 27e:	8082                	ret
    return -1;
 280:	597d                	li	s2,-1
 282:	bfc5                	j	272 <stat+0x28>

0000000000000284 <atoi>:

int
atoi(const char *s)
{
 284:	1141                	addi	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28a:	00054603          	lbu	a2,0(a0)
 28e:	fd06079b          	addiw	a5,a2,-48
 292:	0ff7f793          	andi	a5,a5,255
 296:	4725                	li	a4,9
 298:	02f76963          	bltu	a4,a5,2ca <atoi+0x46>
 29c:	86aa                	mv	a3,a0
  n = 0;
 29e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2a0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2a2:	0685                	addi	a3,a3,1
 2a4:	0025179b          	slliw	a5,a0,0x2
 2a8:	9fa9                	addw	a5,a5,a0
 2aa:	0017979b          	slliw	a5,a5,0x1
 2ae:	9fb1                	addw	a5,a5,a2
 2b0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b4:	0006c603          	lbu	a2,0(a3)
 2b8:	fd06071b          	addiw	a4,a2,-48
 2bc:	0ff77713          	andi	a4,a4,255
 2c0:	fee5f1e3          	bgeu	a1,a4,2a2 <atoi+0x1e>
  return n;
}
 2c4:	6422                	ld	s0,8(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  n = 0;
 2ca:	4501                	li	a0,0
 2cc:	bfe5                	j	2c4 <atoi+0x40>

00000000000002ce <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d4:	02b57663          	bgeu	a0,a1,300 <memmove+0x32>
    while(n-- > 0)
 2d8:	02c05163          	blez	a2,2fa <memmove+0x2c>
 2dc:	fff6079b          	addiw	a5,a2,-1
 2e0:	1782                	slli	a5,a5,0x20
 2e2:	9381                	srli	a5,a5,0x20
 2e4:	0785                	addi	a5,a5,1
 2e6:	97aa                	add	a5,a5,a0
  dst = vdst;
 2e8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ea:	0585                	addi	a1,a1,1
 2ec:	0705                	addi	a4,a4,1
 2ee:	fff5c683          	lbu	a3,-1(a1)
 2f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f6:	fee79ae3          	bne	a5,a4,2ea <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2fa:	6422                	ld	s0,8(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret
    dst += n;
 300:	00c50733          	add	a4,a0,a2
    src += n;
 304:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 306:	fec05ae3          	blez	a2,2fa <memmove+0x2c>
 30a:	fff6079b          	addiw	a5,a2,-1
 30e:	1782                	slli	a5,a5,0x20
 310:	9381                	srli	a5,a5,0x20
 312:	fff7c793          	not	a5,a5
 316:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 318:	15fd                	addi	a1,a1,-1
 31a:	177d                	addi	a4,a4,-1
 31c:	0005c683          	lbu	a3,0(a1)
 320:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 324:	fee79ae3          	bne	a5,a4,318 <memmove+0x4a>
 328:	bfc9                	j	2fa <memmove+0x2c>

000000000000032a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e422                	sd	s0,8(sp)
 32e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 330:	ca05                	beqz	a2,360 <memcmp+0x36>
 332:	fff6069b          	addiw	a3,a2,-1
 336:	1682                	slli	a3,a3,0x20
 338:	9281                	srli	a3,a3,0x20
 33a:	0685                	addi	a3,a3,1
 33c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 33e:	00054783          	lbu	a5,0(a0)
 342:	0005c703          	lbu	a4,0(a1)
 346:	00e79863          	bne	a5,a4,356 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 34a:	0505                	addi	a0,a0,1
    p2++;
 34c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 34e:	fed518e3          	bne	a0,a3,33e <memcmp+0x14>
  }
  return 0;
 352:	4501                	li	a0,0
 354:	a019                	j	35a <memcmp+0x30>
      return *p1 - *p2;
 356:	40e7853b          	subw	a0,a5,a4
}
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
  return 0;
 360:	4501                	li	a0,0
 362:	bfe5                	j	35a <memcmp+0x30>

0000000000000364 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e406                	sd	ra,8(sp)
 368:	e022                	sd	s0,0(sp)
 36a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 36c:	f63ff0ef          	jal	ra,2ce <memmove>
}
 370:	60a2                	ld	ra,8(sp)
 372:	6402                	ld	s0,0(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret

0000000000000378 <sbrk>:

char *
sbrk(int n) {
 378:	1141                	addi	sp,sp,-16
 37a:	e406                	sd	ra,8(sp)
 37c:	e022                	sd	s0,0(sp)
 37e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 380:	4585                	li	a1,1
 382:	0b2000ef          	jal	ra,434 <sys_sbrk>
}
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret

000000000000038e <sbrklazy>:

char *
sbrklazy(int n) {
 38e:	1141                	addi	sp,sp,-16
 390:	e406                	sd	ra,8(sp)
 392:	e022                	sd	s0,0(sp)
 394:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 396:	4589                	li	a1,2
 398:	09c000ef          	jal	ra,434 <sys_sbrk>
}
 39c:	60a2                	ld	ra,8(sp)
 39e:	6402                	ld	s0,0(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret

00000000000003a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a4:	4885                	li	a7,1
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ac:	4889                	li	a7,2
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b4:	488d                	li	a7,3
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3bc:	4891                	li	a7,4
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <read>:
.global read
read:
 li a7, SYS_read
 3c4:	4895                	li	a7,5
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <write>:
.global write
write:
 li a7, SYS_write
 3cc:	48c1                	li	a7,16
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <close>:
.global close
close:
 li a7, SYS_close
 3d4:	48d5                	li	a7,21
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3dc:	4899                	li	a7,6
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e4:	489d                	li	a7,7
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <open>:
.global open
open:
 li a7, SYS_open
 3ec:	48bd                	li	a7,15
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f4:	48c5                	li	a7,17
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fc:	48c9                	li	a7,18
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 404:	48a1                	li	a7,8
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <link>:
.global link
link:
 li a7, SYS_link
 40c:	48cd                	li	a7,19
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 414:	48d1                	li	a7,20
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41c:	48a5                	li	a7,9
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <dup>:
.global dup
dup:
 li a7, SYS_dup
 424:	48a9                	li	a7,10
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42c:	48ad                	li	a7,11
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 434:	48b1                	li	a7,12
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <pause>:
.global pause
pause:
 li a7, SYS_pause
 43c:	48b5                	li	a7,13
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 444:	48b9                	li	a7,14
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <getproctree>:
.global getproctree
getproctree:
 li a7, SYS_getproctree
 44c:	48d9                	li	a7,22
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 454:	1101                	addi	sp,sp,-32
 456:	ec06                	sd	ra,24(sp)
 458:	e822                	sd	s0,16(sp)
 45a:	1000                	addi	s0,sp,32
 45c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 460:	4605                	li	a2,1
 462:	fef40593          	addi	a1,s0,-17
 466:	f67ff0ef          	jal	ra,3cc <write>
}
 46a:	60e2                	ld	ra,24(sp)
 46c:	6442                	ld	s0,16(sp)
 46e:	6105                	addi	sp,sp,32
 470:	8082                	ret

0000000000000472 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 472:	715d                	addi	sp,sp,-80
 474:	e486                	sd	ra,72(sp)
 476:	e0a2                	sd	s0,64(sp)
 478:	fc26                	sd	s1,56(sp)
 47a:	f84a                	sd	s2,48(sp)
 47c:	f44e                	sd	s3,40(sp)
 47e:	0880                	addi	s0,sp,80
 480:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 482:	c299                	beqz	a3,488 <printint+0x16>
 484:	0805c663          	bltz	a1,510 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 488:	2581                	sext.w	a1,a1
  neg = 0;
 48a:	4881                	li	a7,0
 48c:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 490:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 492:	2601                	sext.w	a2,a2
 494:	00000517          	auipc	a0,0x0
 498:	53c50513          	addi	a0,a0,1340 # 9d0 <digits>
 49c:	883a                	mv	a6,a4
 49e:	2705                	addiw	a4,a4,1
 4a0:	02c5f7bb          	remuw	a5,a1,a2
 4a4:	1782                	slli	a5,a5,0x20
 4a6:	9381                	srli	a5,a5,0x20
 4a8:	97aa                	add	a5,a5,a0
 4aa:	0007c783          	lbu	a5,0(a5)
 4ae:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b2:	0005879b          	sext.w	a5,a1
 4b6:	02c5d5bb          	divuw	a1,a1,a2
 4ba:	0685                	addi	a3,a3,1
 4bc:	fec7f0e3          	bgeu	a5,a2,49c <printint+0x2a>
  if(neg)
 4c0:	00088b63          	beqz	a7,4d6 <printint+0x64>
    buf[i++] = '-';
 4c4:	fd040793          	addi	a5,s0,-48
 4c8:	973e                	add	a4,a4,a5
 4ca:	02d00793          	li	a5,45
 4ce:	fef70423          	sb	a5,-24(a4)
 4d2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4d6:	02e05663          	blez	a4,502 <printint+0x90>
 4da:	fb840793          	addi	a5,s0,-72
 4de:	00e78933          	add	s2,a5,a4
 4e2:	fff78993          	addi	s3,a5,-1
 4e6:	99ba                	add	s3,s3,a4
 4e8:	377d                	addiw	a4,a4,-1
 4ea:	1702                	slli	a4,a4,0x20
 4ec:	9301                	srli	a4,a4,0x20
 4ee:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f2:	fff94583          	lbu	a1,-1(s2)
 4f6:	8526                	mv	a0,s1
 4f8:	f5dff0ef          	jal	ra,454 <putc>
  while(--i >= 0)
 4fc:	197d                	addi	s2,s2,-1
 4fe:	ff391ae3          	bne	s2,s3,4f2 <printint+0x80>
}
 502:	60a6                	ld	ra,72(sp)
 504:	6406                	ld	s0,64(sp)
 506:	74e2                	ld	s1,56(sp)
 508:	7942                	ld	s2,48(sp)
 50a:	79a2                	ld	s3,40(sp)
 50c:	6161                	addi	sp,sp,80
 50e:	8082                	ret
    x = -xx;
 510:	40b005bb          	negw	a1,a1
    neg = 1;
 514:	4885                	li	a7,1
    x = -xx;
 516:	bf9d                	j	48c <printint+0x1a>

0000000000000518 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 518:	7119                	addi	sp,sp,-128
 51a:	fc86                	sd	ra,120(sp)
 51c:	f8a2                	sd	s0,112(sp)
 51e:	f4a6                	sd	s1,104(sp)
 520:	f0ca                	sd	s2,96(sp)
 522:	ecce                	sd	s3,88(sp)
 524:	e8d2                	sd	s4,80(sp)
 526:	e4d6                	sd	s5,72(sp)
 528:	e0da                	sd	s6,64(sp)
 52a:	fc5e                	sd	s7,56(sp)
 52c:	f862                	sd	s8,48(sp)
 52e:	f466                	sd	s9,40(sp)
 530:	f06a                	sd	s10,32(sp)
 532:	ec6e                	sd	s11,24(sp)
 534:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 536:	0005c903          	lbu	s2,0(a1)
 53a:	24090c63          	beqz	s2,792 <vprintf+0x27a>
 53e:	8b2a                	mv	s6,a0
 540:	8a2e                	mv	s4,a1
 542:	8bb2                	mv	s7,a2
  state = 0;
 544:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 546:	4481                	li	s1,0
 548:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 54a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 54e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 552:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 556:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 55a:	00000c97          	auipc	s9,0x0
 55e:	476c8c93          	addi	s9,s9,1142 # 9d0 <digits>
 562:	a005                	j	582 <vprintf+0x6a>
        putc(fd, c0);
 564:	85ca                	mv	a1,s2
 566:	855a                	mv	a0,s6
 568:	eedff0ef          	jal	ra,454 <putc>
 56c:	a019                	j	572 <vprintf+0x5a>
    } else if(state == '%'){
 56e:	03598263          	beq	s3,s5,592 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 572:	2485                	addiw	s1,s1,1
 574:	8726                	mv	a4,s1
 576:	009a07b3          	add	a5,s4,s1
 57a:	0007c903          	lbu	s2,0(a5)
 57e:	20090a63          	beqz	s2,792 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 582:	0009079b          	sext.w	a5,s2
    if(state == 0){
 586:	fe0994e3          	bnez	s3,56e <vprintf+0x56>
      if(c0 == '%'){
 58a:	fd579de3          	bne	a5,s5,564 <vprintf+0x4c>
        state = '%';
 58e:	89be                	mv	s3,a5
 590:	b7cd                	j	572 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 592:	c3c1                	beqz	a5,612 <vprintf+0xfa>
 594:	00ea06b3          	add	a3,s4,a4
 598:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 59c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 59e:	c681                	beqz	a3,5a6 <vprintf+0x8e>
 5a0:	9752                	add	a4,a4,s4
 5a2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5a6:	03878e63          	beq	a5,s8,5e2 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 5aa:	05a78863          	beq	a5,s10,5fa <vprintf+0xe2>
      } else if(c0 == 'u'){
 5ae:	0db78b63          	beq	a5,s11,684 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5b2:	07800713          	li	a4,120
 5b6:	10e78d63          	beq	a5,a4,6d0 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5ba:	07000713          	li	a4,112
 5be:	14e78263          	beq	a5,a4,702 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5c2:	06300713          	li	a4,99
 5c6:	16e78f63          	beq	a5,a4,744 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5ca:	07300713          	li	a4,115
 5ce:	18e78563          	beq	a5,a4,758 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5d2:	05579063          	bne	a5,s5,612 <vprintf+0xfa>
        putc(fd, '%');
 5d6:	85d6                	mv	a1,s5
 5d8:	855a                	mv	a0,s6
 5da:	e7bff0ef          	jal	ra,454 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5de:	4981                	li	s3,0
 5e0:	bf49                	j	572 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 5e2:	008b8913          	addi	s2,s7,8
 5e6:	4685                	li	a3,1
 5e8:	4629                	li	a2,10
 5ea:	000ba583          	lw	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	e83ff0ef          	jal	ra,472 <printint>
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	bfad                	j	572 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 5fa:	03868663          	beq	a3,s8,626 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5fe:	05a68163          	beq	a3,s10,640 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 602:	09b68d63          	beq	a3,s11,69c <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 606:	03a68f63          	beq	a3,s10,644 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 60a:	07800793          	li	a5,120
 60e:	0cf68d63          	beq	a3,a5,6e8 <vprintf+0x1d0>
        putc(fd, '%');
 612:	85d6                	mv	a1,s5
 614:	855a                	mv	a0,s6
 616:	e3fff0ef          	jal	ra,454 <putc>
        putc(fd, c0);
 61a:	85ca                	mv	a1,s2
 61c:	855a                	mv	a0,s6
 61e:	e37ff0ef          	jal	ra,454 <putc>
      state = 0;
 622:	4981                	li	s3,0
 624:	b7b9                	j	572 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 626:	008b8913          	addi	s2,s7,8
 62a:	4685                	li	a3,1
 62c:	4629                	li	a2,10
 62e:	000bb583          	ld	a1,0(s7)
 632:	855a                	mv	a0,s6
 634:	e3fff0ef          	jal	ra,472 <printint>
        i += 1;
 638:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 63a:	8bca                	mv	s7,s2
      state = 0;
 63c:	4981                	li	s3,0
        i += 1;
 63e:	bf15                	j	572 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 640:	03860563          	beq	a2,s8,66a <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 644:	07b60963          	beq	a2,s11,6b6 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 648:	07800793          	li	a5,120
 64c:	fcf613e3          	bne	a2,a5,612 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 650:	008b8913          	addi	s2,s7,8
 654:	4681                	li	a3,0
 656:	4641                	li	a2,16
 658:	000bb583          	ld	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	e15ff0ef          	jal	ra,472 <printint>
        i += 2;
 662:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 664:	8bca                	mv	s7,s2
      state = 0;
 666:	4981                	li	s3,0
        i += 2;
 668:	b729                	j	572 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 66a:	008b8913          	addi	s2,s7,8
 66e:	4685                	li	a3,1
 670:	4629                	li	a2,10
 672:	000bb583          	ld	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	dfbff0ef          	jal	ra,472 <printint>
        i += 2;
 67c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 67e:	8bca                	mv	s7,s2
      state = 0;
 680:	4981                	li	s3,0
        i += 2;
 682:	bdc5                	j	572 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 684:	008b8913          	addi	s2,s7,8
 688:	4681                	li	a3,0
 68a:	4629                	li	a2,10
 68c:	000be583          	lwu	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	de1ff0ef          	jal	ra,472 <printint>
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
 69a:	bde1                	j	572 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69c:	008b8913          	addi	s2,s7,8
 6a0:	4681                	li	a3,0
 6a2:	4629                	li	a2,10
 6a4:	000bb583          	ld	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	dc9ff0ef          	jal	ra,472 <printint>
        i += 1;
 6ae:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b0:	8bca                	mv	s7,s2
      state = 0;
 6b2:	4981                	li	s3,0
        i += 1;
 6b4:	bd7d                	j	572 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b6:	008b8913          	addi	s2,s7,8
 6ba:	4681                	li	a3,0
 6bc:	4629                	li	a2,10
 6be:	000bb583          	ld	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	dafff0ef          	jal	ra,472 <printint>
        i += 2;
 6c8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ca:	8bca                	mv	s7,s2
      state = 0;
 6cc:	4981                	li	s3,0
        i += 2;
 6ce:	b555                	j	572 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6d0:	008b8913          	addi	s2,s7,8
 6d4:	4681                	li	a3,0
 6d6:	4641                	li	a2,16
 6d8:	000be583          	lwu	a1,0(s7)
 6dc:	855a                	mv	a0,s6
 6de:	d95ff0ef          	jal	ra,472 <printint>
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	b571                	j	572 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e8:	008b8913          	addi	s2,s7,8
 6ec:	4681                	li	a3,0
 6ee:	4641                	li	a2,16
 6f0:	000bb583          	ld	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	d7dff0ef          	jal	ra,472 <printint>
        i += 1;
 6fa:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fc:	8bca                	mv	s7,s2
      state = 0;
 6fe:	4981                	li	s3,0
        i += 1;
 700:	bd8d                	j	572 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 702:	008b8793          	addi	a5,s7,8
 706:	f8f43423          	sd	a5,-120(s0)
 70a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 70e:	03000593          	li	a1,48
 712:	855a                	mv	a0,s6
 714:	d41ff0ef          	jal	ra,454 <putc>
  putc(fd, 'x');
 718:	07800593          	li	a1,120
 71c:	855a                	mv	a0,s6
 71e:	d37ff0ef          	jal	ra,454 <putc>
 722:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 724:	03c9d793          	srli	a5,s3,0x3c
 728:	97e6                	add	a5,a5,s9
 72a:	0007c583          	lbu	a1,0(a5)
 72e:	855a                	mv	a0,s6
 730:	d25ff0ef          	jal	ra,454 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 734:	0992                	slli	s3,s3,0x4
 736:	397d                	addiw	s2,s2,-1
 738:	fe0916e3          	bnez	s2,724 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 73c:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 740:	4981                	li	s3,0
 742:	bd05                	j	572 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 744:	008b8913          	addi	s2,s7,8
 748:	000bc583          	lbu	a1,0(s7)
 74c:	855a                	mv	a0,s6
 74e:	d07ff0ef          	jal	ra,454 <putc>
 752:	8bca                	mv	s7,s2
      state = 0;
 754:	4981                	li	s3,0
 756:	bd31                	j	572 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 758:	008b8993          	addi	s3,s7,8
 75c:	000bb903          	ld	s2,0(s7)
 760:	00090f63          	beqz	s2,77e <vprintf+0x266>
        for(; *s; s++)
 764:	00094583          	lbu	a1,0(s2)
 768:	c195                	beqz	a1,78c <vprintf+0x274>
          putc(fd, *s);
 76a:	855a                	mv	a0,s6
 76c:	ce9ff0ef          	jal	ra,454 <putc>
        for(; *s; s++)
 770:	0905                	addi	s2,s2,1
 772:	00094583          	lbu	a1,0(s2)
 776:	f9f5                	bnez	a1,76a <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 778:	8bce                	mv	s7,s3
      state = 0;
 77a:	4981                	li	s3,0
 77c:	bbdd                	j	572 <vprintf+0x5a>
          s = "(null)";
 77e:	00000917          	auipc	s2,0x0
 782:	24a90913          	addi	s2,s2,586 # 9c8 <malloc+0x134>
        for(; *s; s++)
 786:	02800593          	li	a1,40
 78a:	b7c5                	j	76a <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 78c:	8bce                	mv	s7,s3
      state = 0;
 78e:	4981                	li	s3,0
 790:	b3cd                	j	572 <vprintf+0x5a>
    }
  }
}
 792:	70e6                	ld	ra,120(sp)
 794:	7446                	ld	s0,112(sp)
 796:	74a6                	ld	s1,104(sp)
 798:	7906                	ld	s2,96(sp)
 79a:	69e6                	ld	s3,88(sp)
 79c:	6a46                	ld	s4,80(sp)
 79e:	6aa6                	ld	s5,72(sp)
 7a0:	6b06                	ld	s6,64(sp)
 7a2:	7be2                	ld	s7,56(sp)
 7a4:	7c42                	ld	s8,48(sp)
 7a6:	7ca2                	ld	s9,40(sp)
 7a8:	7d02                	ld	s10,32(sp)
 7aa:	6de2                	ld	s11,24(sp)
 7ac:	6109                	addi	sp,sp,128
 7ae:	8082                	ret

00000000000007b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b0:	715d                	addi	sp,sp,-80
 7b2:	ec06                	sd	ra,24(sp)
 7b4:	e822                	sd	s0,16(sp)
 7b6:	1000                	addi	s0,sp,32
 7b8:	e010                	sd	a2,0(s0)
 7ba:	e414                	sd	a3,8(s0)
 7bc:	e818                	sd	a4,16(s0)
 7be:	ec1c                	sd	a5,24(s0)
 7c0:	03043023          	sd	a6,32(s0)
 7c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7cc:	8622                	mv	a2,s0
 7ce:	d4bff0ef          	jal	ra,518 <vprintf>
}
 7d2:	60e2                	ld	ra,24(sp)
 7d4:	6442                	ld	s0,16(sp)
 7d6:	6161                	addi	sp,sp,80
 7d8:	8082                	ret

00000000000007da <printf>:

void
printf(const char *fmt, ...)
{
 7da:	711d                	addi	sp,sp,-96
 7dc:	ec06                	sd	ra,24(sp)
 7de:	e822                	sd	s0,16(sp)
 7e0:	1000                	addi	s0,sp,32
 7e2:	e40c                	sd	a1,8(s0)
 7e4:	e810                	sd	a2,16(s0)
 7e6:	ec14                	sd	a3,24(s0)
 7e8:	f018                	sd	a4,32(s0)
 7ea:	f41c                	sd	a5,40(s0)
 7ec:	03043823          	sd	a6,48(s0)
 7f0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f4:	00840613          	addi	a2,s0,8
 7f8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7fc:	85aa                	mv	a1,a0
 7fe:	4505                	li	a0,1
 800:	d19ff0ef          	jal	ra,518 <vprintf>
}
 804:	60e2                	ld	ra,24(sp)
 806:	6442                	ld	s0,16(sp)
 808:	6125                	addi	sp,sp,96
 80a:	8082                	ret

000000000000080c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 80c:	1141                	addi	sp,sp,-16
 80e:	e422                	sd	s0,8(sp)
 810:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 812:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 816:	00000797          	auipc	a5,0x0
 81a:	7ea7b783          	ld	a5,2026(a5) # 1000 <freep>
 81e:	a805                	j	84e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 820:	4618                	lw	a4,8(a2)
 822:	9db9                	addw	a1,a1,a4
 824:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 828:	6398                	ld	a4,0(a5)
 82a:	6318                	ld	a4,0(a4)
 82c:	fee53823          	sd	a4,-16(a0)
 830:	a091                	j	874 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 832:	ff852703          	lw	a4,-8(a0)
 836:	9e39                	addw	a2,a2,a4
 838:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 83a:	ff053703          	ld	a4,-16(a0)
 83e:	e398                	sd	a4,0(a5)
 840:	a099                	j	886 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 842:	6398                	ld	a4,0(a5)
 844:	00e7e463          	bltu	a5,a4,84c <free+0x40>
 848:	00e6ea63          	bltu	a3,a4,85c <free+0x50>
{
 84c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84e:	fed7fae3          	bgeu	a5,a3,842 <free+0x36>
 852:	6398                	ld	a4,0(a5)
 854:	00e6e463          	bltu	a3,a4,85c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 858:	fee7eae3          	bltu	a5,a4,84c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 85c:	ff852583          	lw	a1,-8(a0)
 860:	6390                	ld	a2,0(a5)
 862:	02059713          	slli	a4,a1,0x20
 866:	9301                	srli	a4,a4,0x20
 868:	0712                	slli	a4,a4,0x4
 86a:	9736                	add	a4,a4,a3
 86c:	fae60ae3          	beq	a2,a4,820 <free+0x14>
    bp->s.ptr = p->s.ptr;
 870:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 874:	4790                	lw	a2,8(a5)
 876:	02061713          	slli	a4,a2,0x20
 87a:	9301                	srli	a4,a4,0x20
 87c:	0712                	slli	a4,a4,0x4
 87e:	973e                	add	a4,a4,a5
 880:	fae689e3          	beq	a3,a4,832 <free+0x26>
  } else
    p->s.ptr = bp;
 884:	e394                	sd	a3,0(a5)
  freep = p;
 886:	00000717          	auipc	a4,0x0
 88a:	76f73d23          	sd	a5,1914(a4) # 1000 <freep>
}
 88e:	6422                	ld	s0,8(sp)
 890:	0141                	addi	sp,sp,16
 892:	8082                	ret

0000000000000894 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 894:	7139                	addi	sp,sp,-64
 896:	fc06                	sd	ra,56(sp)
 898:	f822                	sd	s0,48(sp)
 89a:	f426                	sd	s1,40(sp)
 89c:	f04a                	sd	s2,32(sp)
 89e:	ec4e                	sd	s3,24(sp)
 8a0:	e852                	sd	s4,16(sp)
 8a2:	e456                	sd	s5,8(sp)
 8a4:	e05a                	sd	s6,0(sp)
 8a6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a8:	02051493          	slli	s1,a0,0x20
 8ac:	9081                	srli	s1,s1,0x20
 8ae:	04bd                	addi	s1,s1,15
 8b0:	8091                	srli	s1,s1,0x4
 8b2:	0014899b          	addiw	s3,s1,1
 8b6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8b8:	00000517          	auipc	a0,0x0
 8bc:	74853503          	ld	a0,1864(a0) # 1000 <freep>
 8c0:	c515                	beqz	a0,8ec <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c4:	4798                	lw	a4,8(a5)
 8c6:	02977f63          	bgeu	a4,s1,904 <malloc+0x70>
 8ca:	8a4e                	mv	s4,s3
 8cc:	0009871b          	sext.w	a4,s3
 8d0:	6685                	lui	a3,0x1
 8d2:	00d77363          	bgeu	a4,a3,8d8 <malloc+0x44>
 8d6:	6a05                	lui	s4,0x1
 8d8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8dc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e0:	00000917          	auipc	s2,0x0
 8e4:	72090913          	addi	s2,s2,1824 # 1000 <freep>
  if(p == SBRK_ERROR)
 8e8:	5afd                	li	s5,-1
 8ea:	a0bd                	j	958 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 8ec:	00000797          	auipc	a5,0x0
 8f0:	72478793          	addi	a5,a5,1828 # 1010 <base>
 8f4:	00000717          	auipc	a4,0x0
 8f8:	70f73623          	sd	a5,1804(a4) # 1000 <freep>
 8fc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8fe:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 902:	b7e1                	j	8ca <malloc+0x36>
      if(p->s.size == nunits)
 904:	02e48b63          	beq	s1,a4,93a <malloc+0xa6>
        p->s.size -= nunits;
 908:	4137073b          	subw	a4,a4,s3
 90c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 90e:	1702                	slli	a4,a4,0x20
 910:	9301                	srli	a4,a4,0x20
 912:	0712                	slli	a4,a4,0x4
 914:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 916:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 91a:	00000717          	auipc	a4,0x0
 91e:	6ea73323          	sd	a0,1766(a4) # 1000 <freep>
      return (void*)(p + 1);
 922:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 926:	70e2                	ld	ra,56(sp)
 928:	7442                	ld	s0,48(sp)
 92a:	74a2                	ld	s1,40(sp)
 92c:	7902                	ld	s2,32(sp)
 92e:	69e2                	ld	s3,24(sp)
 930:	6a42                	ld	s4,16(sp)
 932:	6aa2                	ld	s5,8(sp)
 934:	6b02                	ld	s6,0(sp)
 936:	6121                	addi	sp,sp,64
 938:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 93a:	6398                	ld	a4,0(a5)
 93c:	e118                	sd	a4,0(a0)
 93e:	bff1                	j	91a <malloc+0x86>
  hp->s.size = nu;
 940:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 944:	0541                	addi	a0,a0,16
 946:	ec7ff0ef          	jal	ra,80c <free>
  return freep;
 94a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 94e:	dd61                	beqz	a0,926 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 950:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 952:	4798                	lw	a4,8(a5)
 954:	fa9778e3          	bgeu	a4,s1,904 <malloc+0x70>
    if(p == freep)
 958:	00093703          	ld	a4,0(s2)
 95c:	853e                	mv	a0,a5
 95e:	fef719e3          	bne	a4,a5,950 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 962:	8552                	mv	a0,s4
 964:	a15ff0ef          	jal	ra,378 <sbrk>
  if(p == SBRK_ERROR)
 968:	fd551ce3          	bne	a0,s5,940 <malloc+0xac>
        return 0;
 96c:	4501                	li	a0,0
 96e:	bf65                	j	926 <malloc+0x92>
