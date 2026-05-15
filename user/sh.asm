
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	1ee58593          	addi	a1,a1,494 # 1200 <malloc+0xea>
      1a:	4509                	li	a0,2
      1c:	433000ef          	jal	ra,c4e <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	1ed000ef          	jal	ra,a12 <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	22f000ef          	jal	ra,a5c <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a00533          	neg	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	1b458593          	addi	a1,a1,436 # 1208 <malloc+0xf2>
      5c:	4509                	li	a0,2
      5e:	7d5000ef          	jal	ra,1032 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	3cb000ef          	jal	ra,c2e <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	3b7000ef          	jal	ra,c26 <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	18e50513          	addi	a0,a0,398 # 1210 <malloc+0xfa>
      8a:	fc1ff0ef          	jal	ra,4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	addi	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	ec26                	sd	s1,24(sp)
      96:	1800                	addi	s0,sp,48
  if(cmd == 0)
      98:	c10d                	beqz	a0,ba <runcmd+0x2c>
      9a:	84aa                	mv	s1,a0
  switch(cmd->type){
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e063          	bltu	a5,a4,c0 <runcmd+0x32>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	slli	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	26670713          	addi	a4,a4,614 # 1310 <malloc+0x1fa>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
    exit(1);
      ba:	4505                	li	a0,1
      bc:	373000ef          	jal	ra,c2e <exit>
    panic("runcmd");
      c0:	00001517          	auipc	a0,0x1
      c4:	15850513          	addi	a0,a0,344 # 1218 <malloc+0x102>
      c8:	f83ff0ef          	jal	ra,4a <panic>
    if(ecmd->argv[0] == 0)
      cc:	6508                	ld	a0,8(a0)
      ce:	c105                	beqz	a0,ee <runcmd+0x60>
    exec(ecmd->argv[0], ecmd->argv);
      d0:	00848593          	addi	a1,s1,8
      d4:	393000ef          	jal	ra,c66 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      d8:	6490                	ld	a2,8(s1)
      da:	00001597          	auipc	a1,0x1
      de:	14658593          	addi	a1,a1,326 # 1220 <malloc+0x10a>
      e2:	4509                	li	a0,2
      e4:	74f000ef          	jal	ra,1032 <fprintf>
  exit(0);
      e8:	4501                	li	a0,0
      ea:	345000ef          	jal	ra,c2e <exit>
      exit(1);
      ee:	4505                	li	a0,1
      f0:	33f000ef          	jal	ra,c2e <exit>
    close(rcmd->fd);
      f4:	5148                	lw	a0,36(a0)
      f6:	361000ef          	jal	ra,c56 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fa:	508c                	lw	a1,32(s1)
      fc:	6888                	ld	a0,16(s1)
      fe:	371000ef          	jal	ra,c6e <open>
     102:	00054563          	bltz	a0,10c <runcmd+0x7e>
    runcmd(rcmd->cmd);
     106:	6488                	ld	a0,8(s1)
     108:	f87ff0ef          	jal	ra,8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10c:	6890                	ld	a2,16(s1)
     10e:	00001597          	auipc	a1,0x1
     112:	12258593          	addi	a1,a1,290 # 1230 <malloc+0x11a>
     116:	4509                	li	a0,2
     118:	71b000ef          	jal	ra,1032 <fprintf>
      exit(1);
     11c:	4505                	li	a0,1
     11e:	311000ef          	jal	ra,c2e <exit>
    if(fork1() == 0)
     122:	f47ff0ef          	jal	ra,68 <fork1>
     126:	e501                	bnez	a0,12e <runcmd+0xa0>
      runcmd(lcmd->left);
     128:	6488                	ld	a0,8(s1)
     12a:	f65ff0ef          	jal	ra,8e <runcmd>
    wait(0);
     12e:	4501                	li	a0,0
     130:	307000ef          	jal	ra,c36 <wait>
    runcmd(lcmd->right);
     134:	6888                	ld	a0,16(s1)
     136:	f59ff0ef          	jal	ra,8e <runcmd>
    if(pipe(p) < 0)
     13a:	fd840513          	addi	a0,s0,-40
     13e:	301000ef          	jal	ra,c3e <pipe>
     142:	02054763          	bltz	a0,170 <runcmd+0xe2>
    if(fork1() == 0){
     146:	f23ff0ef          	jal	ra,68 <fork1>
     14a:	e90d                	bnez	a0,17c <runcmd+0xee>
      close(1);
     14c:	4505                	li	a0,1
     14e:	309000ef          	jal	ra,c56 <close>
      dup(p[1]);
     152:	fdc42503          	lw	a0,-36(s0)
     156:	351000ef          	jal	ra,ca6 <dup>
      close(p[0]);
     15a:	fd842503          	lw	a0,-40(s0)
     15e:	2f9000ef          	jal	ra,c56 <close>
      close(p[1]);
     162:	fdc42503          	lw	a0,-36(s0)
     166:	2f1000ef          	jal	ra,c56 <close>
      runcmd(pcmd->left);
     16a:	6488                	ld	a0,8(s1)
     16c:	f23ff0ef          	jal	ra,8e <runcmd>
      panic("pipe");
     170:	00001517          	auipc	a0,0x1
     174:	0d050513          	addi	a0,a0,208 # 1240 <malloc+0x12a>
     178:	ed3ff0ef          	jal	ra,4a <panic>
    if(fork1() == 0){
     17c:	eedff0ef          	jal	ra,68 <fork1>
     180:	e115                	bnez	a0,1a4 <runcmd+0x116>
      close(0);
     182:	2d5000ef          	jal	ra,c56 <close>
      dup(p[0]);
     186:	fd842503          	lw	a0,-40(s0)
     18a:	31d000ef          	jal	ra,ca6 <dup>
      close(p[0]);
     18e:	fd842503          	lw	a0,-40(s0)
     192:	2c5000ef          	jal	ra,c56 <close>
      close(p[1]);
     196:	fdc42503          	lw	a0,-36(s0)
     19a:	2bd000ef          	jal	ra,c56 <close>
      runcmd(pcmd->right);
     19e:	6888                	ld	a0,16(s1)
     1a0:	eefff0ef          	jal	ra,8e <runcmd>
    close(p[0]);
     1a4:	fd842503          	lw	a0,-40(s0)
     1a8:	2af000ef          	jal	ra,c56 <close>
    close(p[1]);
     1ac:	fdc42503          	lw	a0,-36(s0)
     1b0:	2a7000ef          	jal	ra,c56 <close>
    wait(0);
     1b4:	4501                	li	a0,0
     1b6:	281000ef          	jal	ra,c36 <wait>
    wait(0);
     1ba:	4501                	li	a0,0
     1bc:	27b000ef          	jal	ra,c36 <wait>
    break;
     1c0:	b725                	j	e8 <runcmd+0x5a>
    if(fork1() == 0)
     1c2:	ea7ff0ef          	jal	ra,68 <fork1>
     1c6:	f20511e3          	bnez	a0,e8 <runcmd+0x5a>
      runcmd(bcmd->cmd);
     1ca:	6488                	ld	a0,8(s1)
     1cc:	ec3ff0ef          	jal	ra,8e <runcmd>

00000000000001d0 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d0:	1101                	addi	sp,sp,-32
     1d2:	ec06                	sd	ra,24(sp)
     1d4:	e822                	sd	s0,16(sp)
     1d6:	e426                	sd	s1,8(sp)
     1d8:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1da:	0a800513          	li	a0,168
     1de:	739000ef          	jal	ra,1116 <malloc>
     1e2:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e4:	0a800613          	li	a2,168
     1e8:	4581                	li	a1,0
     1ea:	029000ef          	jal	ra,a12 <memset>
  cmd->type = EXEC;
     1ee:	4785                	li	a5,1
     1f0:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f2:	8526                	mv	a0,s1
     1f4:	60e2                	ld	ra,24(sp)
     1f6:	6442                	ld	s0,16(sp)
     1f8:	64a2                	ld	s1,8(sp)
     1fa:	6105                	addi	sp,sp,32
     1fc:	8082                	ret

00000000000001fe <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     1fe:	7139                	addi	sp,sp,-64
     200:	fc06                	sd	ra,56(sp)
     202:	f822                	sd	s0,48(sp)
     204:	f426                	sd	s1,40(sp)
     206:	f04a                	sd	s2,32(sp)
     208:	ec4e                	sd	s3,24(sp)
     20a:	e852                	sd	s4,16(sp)
     20c:	e456                	sd	s5,8(sp)
     20e:	e05a                	sd	s6,0(sp)
     210:	0080                	addi	s0,sp,64
     212:	8b2a                	mv	s6,a0
     214:	8aae                	mv	s5,a1
     216:	8a32                	mv	s4,a2
     218:	89b6                	mv	s3,a3
     21a:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21c:	02800513          	li	a0,40
     220:	6f7000ef          	jal	ra,1116 <malloc>
     224:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     226:	02800613          	li	a2,40
     22a:	4581                	li	a1,0
     22c:	7e6000ef          	jal	ra,a12 <memset>
  cmd->type = REDIR;
     230:	4789                	li	a5,2
     232:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     234:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     238:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     23c:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     240:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     244:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     248:	8526                	mv	a0,s1
     24a:	70e2                	ld	ra,56(sp)
     24c:	7442                	ld	s0,48(sp)
     24e:	74a2                	ld	s1,40(sp)
     250:	7902                	ld	s2,32(sp)
     252:	69e2                	ld	s3,24(sp)
     254:	6a42                	ld	s4,16(sp)
     256:	6aa2                	ld	s5,8(sp)
     258:	6b02                	ld	s6,0(sp)
     25a:	6121                	addi	sp,sp,64
     25c:	8082                	ret

000000000000025e <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     25e:	7179                	addi	sp,sp,-48
     260:	f406                	sd	ra,40(sp)
     262:	f022                	sd	s0,32(sp)
     264:	ec26                	sd	s1,24(sp)
     266:	e84a                	sd	s2,16(sp)
     268:	e44e                	sd	s3,8(sp)
     26a:	1800                	addi	s0,sp,48
     26c:	89aa                	mv	s3,a0
     26e:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     270:	4561                	li	a0,24
     272:	6a5000ef          	jal	ra,1116 <malloc>
     276:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     278:	4661                	li	a2,24
     27a:	4581                	li	a1,0
     27c:	796000ef          	jal	ra,a12 <memset>
  cmd->type = PIPE;
     280:	478d                	li	a5,3
     282:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     284:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     288:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     28c:	8526                	mv	a0,s1
     28e:	70a2                	ld	ra,40(sp)
     290:	7402                	ld	s0,32(sp)
     292:	64e2                	ld	s1,24(sp)
     294:	6942                	ld	s2,16(sp)
     296:	69a2                	ld	s3,8(sp)
     298:	6145                	addi	sp,sp,48
     29a:	8082                	ret

000000000000029c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     29c:	7179                	addi	sp,sp,-48
     29e:	f406                	sd	ra,40(sp)
     2a0:	f022                	sd	s0,32(sp)
     2a2:	ec26                	sd	s1,24(sp)
     2a4:	e84a                	sd	s2,16(sp)
     2a6:	e44e                	sd	s3,8(sp)
     2a8:	1800                	addi	s0,sp,48
     2aa:	89aa                	mv	s3,a0
     2ac:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ae:	4561                	li	a0,24
     2b0:	667000ef          	jal	ra,1116 <malloc>
     2b4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b6:	4661                	li	a2,24
     2b8:	4581                	li	a1,0
     2ba:	758000ef          	jal	ra,a12 <memset>
  cmd->type = LIST;
     2be:	4791                	li	a5,4
     2c0:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c2:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     2c6:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     2ca:	8526                	mv	a0,s1
     2cc:	70a2                	ld	ra,40(sp)
     2ce:	7402                	ld	s0,32(sp)
     2d0:	64e2                	ld	s1,24(sp)
     2d2:	6942                	ld	s2,16(sp)
     2d4:	69a2                	ld	s3,8(sp)
     2d6:	6145                	addi	sp,sp,48
     2d8:	8082                	ret

00000000000002da <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2da:	1101                	addi	sp,sp,-32
     2dc:	ec06                	sd	ra,24(sp)
     2de:	e822                	sd	s0,16(sp)
     2e0:	e426                	sd	s1,8(sp)
     2e2:	e04a                	sd	s2,0(sp)
     2e4:	1000                	addi	s0,sp,32
     2e6:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2e8:	4541                	li	a0,16
     2ea:	62d000ef          	jal	ra,1116 <malloc>
     2ee:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f0:	4641                	li	a2,16
     2f2:	4581                	li	a1,0
     2f4:	71e000ef          	jal	ra,a12 <memset>
  cmd->type = BACK;
     2f8:	4795                	li	a5,5
     2fa:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fc:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     300:	8526                	mv	a0,s1
     302:	60e2                	ld	ra,24(sp)
     304:	6442                	ld	s0,16(sp)
     306:	64a2                	ld	s1,8(sp)
     308:	6902                	ld	s2,0(sp)
     30a:	6105                	addi	sp,sp,32
     30c:	8082                	ret

000000000000030e <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     30e:	7139                	addi	sp,sp,-64
     310:	fc06                	sd	ra,56(sp)
     312:	f822                	sd	s0,48(sp)
     314:	f426                	sd	s1,40(sp)
     316:	f04a                	sd	s2,32(sp)
     318:	ec4e                	sd	s3,24(sp)
     31a:	e852                	sd	s4,16(sp)
     31c:	e456                	sd	s5,8(sp)
     31e:	e05a                	sd	s6,0(sp)
     320:	0080                	addi	s0,sp,64
     322:	8a2a                	mv	s4,a0
     324:	892e                	mv	s2,a1
     326:	8ab2                	mv	s5,a2
     328:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32a:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32c:	00002997          	auipc	s3,0x2
     330:	cdc98993          	addi	s3,s3,-804 # 2008 <whitespace>
     334:	00b4fb63          	bgeu	s1,a1,34a <gettoken+0x3c>
     338:	0004c583          	lbu	a1,0(s1)
     33c:	854e                	mv	a0,s3
     33e:	6fa000ef          	jal	ra,a38 <strchr>
     342:	c501                	beqz	a0,34a <gettoken+0x3c>
    s++;
     344:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     346:	fe9919e3          	bne	s2,s1,338 <gettoken+0x2a>
  if(q)
     34a:	000a8463          	beqz	s5,352 <gettoken+0x44>
    *q = s;
     34e:	009ab023          	sd	s1,0(s5)
  ret = *s;
     352:	0004c783          	lbu	a5,0(s1)
     356:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35a:	03c00713          	li	a4,60
     35e:	06f76363          	bltu	a4,a5,3c4 <gettoken+0xb6>
     362:	03a00713          	li	a4,58
     366:	00f76e63          	bltu	a4,a5,382 <gettoken+0x74>
     36a:	cf89                	beqz	a5,384 <gettoken+0x76>
     36c:	02600713          	li	a4,38
     370:	00e78963          	beq	a5,a4,382 <gettoken+0x74>
     374:	fd87879b          	addiw	a5,a5,-40
     378:	0ff7f793          	andi	a5,a5,255
     37c:	4705                	li	a4,1
     37e:	06f76a63          	bltu	a4,a5,3f2 <gettoken+0xe4>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     382:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     384:	000b0463          	beqz	s6,38c <gettoken+0x7e>
    *eq = s;
     388:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     38c:	00002997          	auipc	s3,0x2
     390:	c7c98993          	addi	s3,s3,-900 # 2008 <whitespace>
     394:	0124fb63          	bgeu	s1,s2,3aa <gettoken+0x9c>
     398:	0004c583          	lbu	a1,0(s1)
     39c:	854e                	mv	a0,s3
     39e:	69a000ef          	jal	ra,a38 <strchr>
     3a2:	c501                	beqz	a0,3aa <gettoken+0x9c>
    s++;
     3a4:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3a6:	fe9919e3          	bne	s2,s1,398 <gettoken+0x8a>
  *ps = s;
     3aa:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3ae:	8556                	mv	a0,s5
     3b0:	70e2                	ld	ra,56(sp)
     3b2:	7442                	ld	s0,48(sp)
     3b4:	74a2                	ld	s1,40(sp)
     3b6:	7902                	ld	s2,32(sp)
     3b8:	69e2                	ld	s3,24(sp)
     3ba:	6a42                	ld	s4,16(sp)
     3bc:	6aa2                	ld	s5,8(sp)
     3be:	6b02                	ld	s6,0(sp)
     3c0:	6121                	addi	sp,sp,64
     3c2:	8082                	ret
  switch(*s){
     3c4:	03e00713          	li	a4,62
     3c8:	02e79163          	bne	a5,a4,3ea <gettoken+0xdc>
    s++;
     3cc:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     3d0:	0014c703          	lbu	a4,1(s1)
     3d4:	03e00793          	li	a5,62
      s++;
     3d8:	0489                	addi	s1,s1,2
      ret = '+';
     3da:	02b00a93          	li	s5,43
    if(*s == '>'){
     3de:	faf703e3          	beq	a4,a5,384 <gettoken+0x76>
    s++;
     3e2:	84b6                	mv	s1,a3
  ret = *s;
     3e4:	03e00a93          	li	s5,62
     3e8:	bf71                	j	384 <gettoken+0x76>
  switch(*s){
     3ea:	07c00713          	li	a4,124
     3ee:	f8e78ae3          	beq	a5,a4,382 <gettoken+0x74>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3f2:	00002997          	auipc	s3,0x2
     3f6:	c1698993          	addi	s3,s3,-1002 # 2008 <whitespace>
     3fa:	00002a97          	auipc	s5,0x2
     3fe:	c06a8a93          	addi	s5,s5,-1018 # 2000 <symbols>
     402:	0324f163          	bgeu	s1,s2,424 <gettoken+0x116>
     406:	0004c583          	lbu	a1,0(s1)
     40a:	854e                	mv	a0,s3
     40c:	62c000ef          	jal	ra,a38 <strchr>
     410:	e115                	bnez	a0,434 <gettoken+0x126>
     412:	0004c583          	lbu	a1,0(s1)
     416:	8556                	mv	a0,s5
     418:	620000ef          	jal	ra,a38 <strchr>
     41c:	e909                	bnez	a0,42e <gettoken+0x120>
      s++;
     41e:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     420:	fe9913e3          	bne	s2,s1,406 <gettoken+0xf8>
  if(eq)
     424:	06100a93          	li	s5,97
     428:	f60b10e3          	bnez	s6,388 <gettoken+0x7a>
     42c:	bfbd                	j	3aa <gettoken+0x9c>
    ret = 'a';
     42e:	06100a93          	li	s5,97
     432:	bf89                	j	384 <gettoken+0x76>
     434:	06100a93          	li	s5,97
     438:	b7b1                	j	384 <gettoken+0x76>

000000000000043a <peek>:

int
peek(char **ps, char *es, char *toks)
{
     43a:	7139                	addi	sp,sp,-64
     43c:	fc06                	sd	ra,56(sp)
     43e:	f822                	sd	s0,48(sp)
     440:	f426                	sd	s1,40(sp)
     442:	f04a                	sd	s2,32(sp)
     444:	ec4e                	sd	s3,24(sp)
     446:	e852                	sd	s4,16(sp)
     448:	e456                	sd	s5,8(sp)
     44a:	0080                	addi	s0,sp,64
     44c:	8a2a                	mv	s4,a0
     44e:	892e                	mv	s2,a1
     450:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     452:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     454:	00002997          	auipc	s3,0x2
     458:	bb498993          	addi	s3,s3,-1100 # 2008 <whitespace>
     45c:	00b4fb63          	bgeu	s1,a1,472 <peek+0x38>
     460:	0004c583          	lbu	a1,0(s1)
     464:	854e                	mv	a0,s3
     466:	5d2000ef          	jal	ra,a38 <strchr>
     46a:	c501                	beqz	a0,472 <peek+0x38>
    s++;
     46c:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     46e:	fe9919e3          	bne	s2,s1,460 <peek+0x26>
  *ps = s;
     472:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     476:	0004c583          	lbu	a1,0(s1)
     47a:	4501                	li	a0,0
     47c:	e991                	bnez	a1,490 <peek+0x56>
}
     47e:	70e2                	ld	ra,56(sp)
     480:	7442                	ld	s0,48(sp)
     482:	74a2                	ld	s1,40(sp)
     484:	7902                	ld	s2,32(sp)
     486:	69e2                	ld	s3,24(sp)
     488:	6a42                	ld	s4,16(sp)
     48a:	6aa2                	ld	s5,8(sp)
     48c:	6121                	addi	sp,sp,64
     48e:	8082                	ret
  return *s && strchr(toks, *s);
     490:	8556                	mv	a0,s5
     492:	5a6000ef          	jal	ra,a38 <strchr>
     496:	00a03533          	snez	a0,a0
     49a:	b7d5                	j	47e <peek+0x44>

000000000000049c <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     49c:	7159                	addi	sp,sp,-112
     49e:	f486                	sd	ra,104(sp)
     4a0:	f0a2                	sd	s0,96(sp)
     4a2:	eca6                	sd	s1,88(sp)
     4a4:	e8ca                	sd	s2,80(sp)
     4a6:	e4ce                	sd	s3,72(sp)
     4a8:	e0d2                	sd	s4,64(sp)
     4aa:	fc56                	sd	s5,56(sp)
     4ac:	f85a                	sd	s6,48(sp)
     4ae:	f45e                	sd	s7,40(sp)
     4b0:	f062                	sd	s8,32(sp)
     4b2:	ec66                	sd	s9,24(sp)
     4b4:	1880                	addi	s0,sp,112
     4b6:	8a2a                	mv	s4,a0
     4b8:	89ae                	mv	s3,a1
     4ba:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4bc:	00001b97          	auipc	s7,0x1
     4c0:	dacb8b93          	addi	s7,s7,-596 # 1268 <malloc+0x152>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4c4:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     4c8:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     4cc:	a00d                	j	4ee <parseredirs+0x52>
      panic("missing file for redirection");
     4ce:	00001517          	auipc	a0,0x1
     4d2:	d7a50513          	addi	a0,a0,-646 # 1248 <malloc+0x132>
     4d6:	b75ff0ef          	jal	ra,4a <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4da:	4701                	li	a4,0
     4dc:	4681                	li	a3,0
     4de:	f9043603          	ld	a2,-112(s0)
     4e2:	f9843583          	ld	a1,-104(s0)
     4e6:	8552                	mv	a0,s4
     4e8:	d17ff0ef          	jal	ra,1fe <redircmd>
     4ec:	8a2a                	mv	s4,a0
    switch(tok){
     4ee:	03e00b13          	li	s6,62
     4f2:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     4f6:	865e                	mv	a2,s7
     4f8:	85ca                	mv	a1,s2
     4fa:	854e                	mv	a0,s3
     4fc:	f3fff0ef          	jal	ra,43a <peek>
     500:	c125                	beqz	a0,560 <parseredirs+0xc4>
    tok = gettoken(ps, es, 0, 0);
     502:	4681                	li	a3,0
     504:	4601                	li	a2,0
     506:	85ca                	mv	a1,s2
     508:	854e                	mv	a0,s3
     50a:	e05ff0ef          	jal	ra,30e <gettoken>
     50e:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     510:	f9040693          	addi	a3,s0,-112
     514:	f9840613          	addi	a2,s0,-104
     518:	85ca                	mv	a1,s2
     51a:	854e                	mv	a0,s3
     51c:	df3ff0ef          	jal	ra,30e <gettoken>
     520:	fb8517e3          	bne	a0,s8,4ce <parseredirs+0x32>
    switch(tok){
     524:	fb948be3          	beq	s1,s9,4da <parseredirs+0x3e>
     528:	03648063          	beq	s1,s6,548 <parseredirs+0xac>
     52c:	fd5495e3          	bne	s1,s5,4f6 <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     530:	4705                	li	a4,1
     532:	20100693          	li	a3,513
     536:	f9043603          	ld	a2,-112(s0)
     53a:	f9843583          	ld	a1,-104(s0)
     53e:	8552                	mv	a0,s4
     540:	cbfff0ef          	jal	ra,1fe <redircmd>
     544:	8a2a                	mv	s4,a0
      break;
     546:	b765                	j	4ee <parseredirs+0x52>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     548:	4705                	li	a4,1
     54a:	60100693          	li	a3,1537
     54e:	f9043603          	ld	a2,-112(s0)
     552:	f9843583          	ld	a1,-104(s0)
     556:	8552                	mv	a0,s4
     558:	ca7ff0ef          	jal	ra,1fe <redircmd>
     55c:	8a2a                	mv	s4,a0
      break;
     55e:	bf41                	j	4ee <parseredirs+0x52>
    }
  }
  return cmd;
}
     560:	8552                	mv	a0,s4
     562:	70a6                	ld	ra,104(sp)
     564:	7406                	ld	s0,96(sp)
     566:	64e6                	ld	s1,88(sp)
     568:	6946                	ld	s2,80(sp)
     56a:	69a6                	ld	s3,72(sp)
     56c:	6a06                	ld	s4,64(sp)
     56e:	7ae2                	ld	s5,56(sp)
     570:	7b42                	ld	s6,48(sp)
     572:	7ba2                	ld	s7,40(sp)
     574:	7c02                	ld	s8,32(sp)
     576:	6ce2                	ld	s9,24(sp)
     578:	6165                	addi	sp,sp,112
     57a:	8082                	ret

000000000000057c <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     57c:	7159                	addi	sp,sp,-112
     57e:	f486                	sd	ra,104(sp)
     580:	f0a2                	sd	s0,96(sp)
     582:	eca6                	sd	s1,88(sp)
     584:	e8ca                	sd	s2,80(sp)
     586:	e4ce                	sd	s3,72(sp)
     588:	e0d2                	sd	s4,64(sp)
     58a:	fc56                	sd	s5,56(sp)
     58c:	f85a                	sd	s6,48(sp)
     58e:	f45e                	sd	s7,40(sp)
     590:	f062                	sd	s8,32(sp)
     592:	ec66                	sd	s9,24(sp)
     594:	1880                	addi	s0,sp,112
     596:	8a2a                	mv	s4,a0
     598:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     59a:	00001617          	auipc	a2,0x1
     59e:	cd660613          	addi	a2,a2,-810 # 1270 <malloc+0x15a>
     5a2:	e99ff0ef          	jal	ra,43a <peek>
     5a6:	e505                	bnez	a0,5ce <parseexec+0x52>
     5a8:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     5aa:	c27ff0ef          	jal	ra,1d0 <execcmd>
     5ae:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5b0:	8656                	mv	a2,s5
     5b2:	85d2                	mv	a1,s4
     5b4:	ee9ff0ef          	jal	ra,49c <parseredirs>
     5b8:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5ba:	008c0913          	addi	s2,s8,8
     5be:	00001b17          	auipc	s6,0x1
     5c2:	cd2b0b13          	addi	s6,s6,-814 # 1290 <malloc+0x17a>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     5c6:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5ca:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     5cc:	a081                	j	60c <parseexec+0x90>
    return parseblock(ps, es);
     5ce:	85d6                	mv	a1,s5
     5d0:	8552                	mv	a0,s4
     5d2:	170000ef          	jal	ra,742 <parseblock>
     5d6:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5d8:	8526                	mv	a0,s1
     5da:	70a6                	ld	ra,104(sp)
     5dc:	7406                	ld	s0,96(sp)
     5de:	64e6                	ld	s1,88(sp)
     5e0:	6946                	ld	s2,80(sp)
     5e2:	69a6                	ld	s3,72(sp)
     5e4:	6a06                	ld	s4,64(sp)
     5e6:	7ae2                	ld	s5,56(sp)
     5e8:	7b42                	ld	s6,48(sp)
     5ea:	7ba2                	ld	s7,40(sp)
     5ec:	7c02                	ld	s8,32(sp)
     5ee:	6ce2                	ld	s9,24(sp)
     5f0:	6165                	addi	sp,sp,112
     5f2:	8082                	ret
      panic("syntax");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	c8450513          	addi	a0,a0,-892 # 1278 <malloc+0x162>
     5fc:	a4fff0ef          	jal	ra,4a <panic>
    ret = parseredirs(ret, ps, es);
     600:	8656                	mv	a2,s5
     602:	85d2                	mv	a1,s4
     604:	8526                	mv	a0,s1
     606:	e97ff0ef          	jal	ra,49c <parseredirs>
     60a:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     60c:	865a                	mv	a2,s6
     60e:	85d6                	mv	a1,s5
     610:	8552                	mv	a0,s4
     612:	e29ff0ef          	jal	ra,43a <peek>
     616:	ed15                	bnez	a0,652 <parseexec+0xd6>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     618:	f9040693          	addi	a3,s0,-112
     61c:	f9840613          	addi	a2,s0,-104
     620:	85d6                	mv	a1,s5
     622:	8552                	mv	a0,s4
     624:	cebff0ef          	jal	ra,30e <gettoken>
     628:	c50d                	beqz	a0,652 <parseexec+0xd6>
    if(tok != 'a')
     62a:	fd9515e3          	bne	a0,s9,5f4 <parseexec+0x78>
    cmd->argv[argc] = q;
     62e:	f9843783          	ld	a5,-104(s0)
     632:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     636:	f9043783          	ld	a5,-112(s0)
     63a:	04f93823          	sd	a5,80(s2)
    argc++;
     63e:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     640:	0921                	addi	s2,s2,8
     642:	fb799fe3          	bne	s3,s7,600 <parseexec+0x84>
      panic("too many args");
     646:	00001517          	auipc	a0,0x1
     64a:	c3a50513          	addi	a0,a0,-966 # 1280 <malloc+0x16a>
     64e:	9fdff0ef          	jal	ra,4a <panic>
  cmd->argv[argc] = 0;
     652:	098e                	slli	s3,s3,0x3
     654:	99e2                	add	s3,s3,s8
     656:	0009b423          	sd	zero,8(s3)
  cmd->eargv[argc] = 0;
     65a:	0409bc23          	sd	zero,88(s3)
  return ret;
     65e:	bfad                	j	5d8 <parseexec+0x5c>

0000000000000660 <parsepipe>:
{
     660:	7179                	addi	sp,sp,-48
     662:	f406                	sd	ra,40(sp)
     664:	f022                	sd	s0,32(sp)
     666:	ec26                	sd	s1,24(sp)
     668:	e84a                	sd	s2,16(sp)
     66a:	e44e                	sd	s3,8(sp)
     66c:	1800                	addi	s0,sp,48
     66e:	892a                	mv	s2,a0
     670:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     672:	f0bff0ef          	jal	ra,57c <parseexec>
     676:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     678:	00001617          	auipc	a2,0x1
     67c:	c2060613          	addi	a2,a2,-992 # 1298 <malloc+0x182>
     680:	85ce                	mv	a1,s3
     682:	854a                	mv	a0,s2
     684:	db7ff0ef          	jal	ra,43a <peek>
     688:	e909                	bnez	a0,69a <parsepipe+0x3a>
}
     68a:	8526                	mv	a0,s1
     68c:	70a2                	ld	ra,40(sp)
     68e:	7402                	ld	s0,32(sp)
     690:	64e2                	ld	s1,24(sp)
     692:	6942                	ld	s2,16(sp)
     694:	69a2                	ld	s3,8(sp)
     696:	6145                	addi	sp,sp,48
     698:	8082                	ret
    gettoken(ps, es, 0, 0);
     69a:	4681                	li	a3,0
     69c:	4601                	li	a2,0
     69e:	85ce                	mv	a1,s3
     6a0:	854a                	mv	a0,s2
     6a2:	c6dff0ef          	jal	ra,30e <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6a6:	85ce                	mv	a1,s3
     6a8:	854a                	mv	a0,s2
     6aa:	fb7ff0ef          	jal	ra,660 <parsepipe>
     6ae:	85aa                	mv	a1,a0
     6b0:	8526                	mv	a0,s1
     6b2:	badff0ef          	jal	ra,25e <pipecmd>
     6b6:	84aa                	mv	s1,a0
  return cmd;
     6b8:	bfc9                	j	68a <parsepipe+0x2a>

00000000000006ba <parseline>:
{
     6ba:	7179                	addi	sp,sp,-48
     6bc:	f406                	sd	ra,40(sp)
     6be:	f022                	sd	s0,32(sp)
     6c0:	ec26                	sd	s1,24(sp)
     6c2:	e84a                	sd	s2,16(sp)
     6c4:	e44e                	sd	s3,8(sp)
     6c6:	e052                	sd	s4,0(sp)
     6c8:	1800                	addi	s0,sp,48
     6ca:	892a                	mv	s2,a0
     6cc:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6ce:	f93ff0ef          	jal	ra,660 <parsepipe>
     6d2:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6d4:	00001a17          	auipc	s4,0x1
     6d8:	bcca0a13          	addi	s4,s4,-1076 # 12a0 <malloc+0x18a>
     6dc:	8652                	mv	a2,s4
     6de:	85ce                	mv	a1,s3
     6e0:	854a                	mv	a0,s2
     6e2:	d59ff0ef          	jal	ra,43a <peek>
     6e6:	cd01                	beqz	a0,6fe <parseline+0x44>
    gettoken(ps, es, 0, 0);
     6e8:	4681                	li	a3,0
     6ea:	4601                	li	a2,0
     6ec:	85ce                	mv	a1,s3
     6ee:	854a                	mv	a0,s2
     6f0:	c1fff0ef          	jal	ra,30e <gettoken>
    cmd = backcmd(cmd);
     6f4:	8526                	mv	a0,s1
     6f6:	be5ff0ef          	jal	ra,2da <backcmd>
     6fa:	84aa                	mv	s1,a0
     6fc:	b7c5                	j	6dc <parseline+0x22>
  if(peek(ps, es, ";")){
     6fe:	00001617          	auipc	a2,0x1
     702:	baa60613          	addi	a2,a2,-1110 # 12a8 <malloc+0x192>
     706:	85ce                	mv	a1,s3
     708:	854a                	mv	a0,s2
     70a:	d31ff0ef          	jal	ra,43a <peek>
     70e:	e911                	bnez	a0,722 <parseline+0x68>
}
     710:	8526                	mv	a0,s1
     712:	70a2                	ld	ra,40(sp)
     714:	7402                	ld	s0,32(sp)
     716:	64e2                	ld	s1,24(sp)
     718:	6942                	ld	s2,16(sp)
     71a:	69a2                	ld	s3,8(sp)
     71c:	6a02                	ld	s4,0(sp)
     71e:	6145                	addi	sp,sp,48
     720:	8082                	ret
    gettoken(ps, es, 0, 0);
     722:	4681                	li	a3,0
     724:	4601                	li	a2,0
     726:	85ce                	mv	a1,s3
     728:	854a                	mv	a0,s2
     72a:	be5ff0ef          	jal	ra,30e <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     72e:	85ce                	mv	a1,s3
     730:	854a                	mv	a0,s2
     732:	f89ff0ef          	jal	ra,6ba <parseline>
     736:	85aa                	mv	a1,a0
     738:	8526                	mv	a0,s1
     73a:	b63ff0ef          	jal	ra,29c <listcmd>
     73e:	84aa                	mv	s1,a0
  return cmd;
     740:	bfc1                	j	710 <parseline+0x56>

0000000000000742 <parseblock>:
{
     742:	7179                	addi	sp,sp,-48
     744:	f406                	sd	ra,40(sp)
     746:	f022                	sd	s0,32(sp)
     748:	ec26                	sd	s1,24(sp)
     74a:	e84a                	sd	s2,16(sp)
     74c:	e44e                	sd	s3,8(sp)
     74e:	1800                	addi	s0,sp,48
     750:	84aa                	mv	s1,a0
     752:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     754:	00001617          	auipc	a2,0x1
     758:	b1c60613          	addi	a2,a2,-1252 # 1270 <malloc+0x15a>
     75c:	cdfff0ef          	jal	ra,43a <peek>
     760:	c539                	beqz	a0,7ae <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     762:	4681                	li	a3,0
     764:	4601                	li	a2,0
     766:	85ca                	mv	a1,s2
     768:	8526                	mv	a0,s1
     76a:	ba5ff0ef          	jal	ra,30e <gettoken>
  cmd = parseline(ps, es);
     76e:	85ca                	mv	a1,s2
     770:	8526                	mv	a0,s1
     772:	f49ff0ef          	jal	ra,6ba <parseline>
     776:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     778:	00001617          	auipc	a2,0x1
     77c:	b4860613          	addi	a2,a2,-1208 # 12c0 <malloc+0x1aa>
     780:	85ca                	mv	a1,s2
     782:	8526                	mv	a0,s1
     784:	cb7ff0ef          	jal	ra,43a <peek>
     788:	c90d                	beqz	a0,7ba <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     78a:	4681                	li	a3,0
     78c:	4601                	li	a2,0
     78e:	85ca                	mv	a1,s2
     790:	8526                	mv	a0,s1
     792:	b7dff0ef          	jal	ra,30e <gettoken>
  cmd = parseredirs(cmd, ps, es);
     796:	864a                	mv	a2,s2
     798:	85a6                	mv	a1,s1
     79a:	854e                	mv	a0,s3
     79c:	d01ff0ef          	jal	ra,49c <parseredirs>
}
     7a0:	70a2                	ld	ra,40(sp)
     7a2:	7402                	ld	s0,32(sp)
     7a4:	64e2                	ld	s1,24(sp)
     7a6:	6942                	ld	s2,16(sp)
     7a8:	69a2                	ld	s3,8(sp)
     7aa:	6145                	addi	sp,sp,48
     7ac:	8082                	ret
    panic("parseblock");
     7ae:	00001517          	auipc	a0,0x1
     7b2:	b0250513          	addi	a0,a0,-1278 # 12b0 <malloc+0x19a>
     7b6:	895ff0ef          	jal	ra,4a <panic>
    panic("syntax - missing )");
     7ba:	00001517          	auipc	a0,0x1
     7be:	b0e50513          	addi	a0,a0,-1266 # 12c8 <malloc+0x1b2>
     7c2:	889ff0ef          	jal	ra,4a <panic>

00000000000007c6 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7c6:	1101                	addi	sp,sp,-32
     7c8:	ec06                	sd	ra,24(sp)
     7ca:	e822                	sd	s0,16(sp)
     7cc:	e426                	sd	s1,8(sp)
     7ce:	1000                	addi	s0,sp,32
     7d0:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7d2:	c131                	beqz	a0,816 <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7d4:	4118                	lw	a4,0(a0)
     7d6:	4795                	li	a5,5
     7d8:	02e7ef63          	bltu	a5,a4,816 <nulterminate+0x50>
     7dc:	00056783          	lwu	a5,0(a0)
     7e0:	078a                	slli	a5,a5,0x2
     7e2:	00001717          	auipc	a4,0x1
     7e6:	b4670713          	addi	a4,a4,-1210 # 1328 <malloc+0x212>
     7ea:	97ba                	add	a5,a5,a4
     7ec:	439c                	lw	a5,0(a5)
     7ee:	97ba                	add	a5,a5,a4
     7f0:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     7f2:	651c                	ld	a5,8(a0)
     7f4:	c38d                	beqz	a5,816 <nulterminate+0x50>
     7f6:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     7fa:	67b8                	ld	a4,72(a5)
     7fc:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     800:	07a1                	addi	a5,a5,8
     802:	ff87b703          	ld	a4,-8(a5)
     806:	fb75                	bnez	a4,7fa <nulterminate+0x34>
     808:	a039                	j	816 <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     80a:	6508                	ld	a0,8(a0)
     80c:	fbbff0ef          	jal	ra,7c6 <nulterminate>
    *rcmd->efile = 0;
     810:	6c9c                	ld	a5,24(s1)
     812:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     816:	8526                	mv	a0,s1
     818:	60e2                	ld	ra,24(sp)
     81a:	6442                	ld	s0,16(sp)
     81c:	64a2                	ld	s1,8(sp)
     81e:	6105                	addi	sp,sp,32
     820:	8082                	ret
    nulterminate(pcmd->left);
     822:	6508                	ld	a0,8(a0)
     824:	fa3ff0ef          	jal	ra,7c6 <nulterminate>
    nulterminate(pcmd->right);
     828:	6888                	ld	a0,16(s1)
     82a:	f9dff0ef          	jal	ra,7c6 <nulterminate>
    break;
     82e:	b7e5                	j	816 <nulterminate+0x50>
    nulterminate(lcmd->left);
     830:	6508                	ld	a0,8(a0)
     832:	f95ff0ef          	jal	ra,7c6 <nulterminate>
    nulterminate(lcmd->right);
     836:	6888                	ld	a0,16(s1)
     838:	f8fff0ef          	jal	ra,7c6 <nulterminate>
    break;
     83c:	bfe9                	j	816 <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     83e:	6508                	ld	a0,8(a0)
     840:	f87ff0ef          	jal	ra,7c6 <nulterminate>
    break;
     844:	bfc9                	j	816 <nulterminate+0x50>

0000000000000846 <parsecmd>:
{
     846:	7179                	addi	sp,sp,-48
     848:	f406                	sd	ra,40(sp)
     84a:	f022                	sd	s0,32(sp)
     84c:	ec26                	sd	s1,24(sp)
     84e:	e84a                	sd	s2,16(sp)
     850:	1800                	addi	s0,sp,48
     852:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     856:	84aa                	mv	s1,a0
     858:	190000ef          	jal	ra,9e8 <strlen>
     85c:	1502                	slli	a0,a0,0x20
     85e:	9101                	srli	a0,a0,0x20
     860:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     862:	85a6                	mv	a1,s1
     864:	fd840513          	addi	a0,s0,-40
     868:	e53ff0ef          	jal	ra,6ba <parseline>
     86c:	892a                	mv	s2,a0
  peek(&s, es, "");
     86e:	00001617          	auipc	a2,0x1
     872:	a7260613          	addi	a2,a2,-1422 # 12e0 <malloc+0x1ca>
     876:	85a6                	mv	a1,s1
     878:	fd840513          	addi	a0,s0,-40
     87c:	bbfff0ef          	jal	ra,43a <peek>
  if(s != es){
     880:	fd843603          	ld	a2,-40(s0)
     884:	00961c63          	bne	a2,s1,89c <parsecmd+0x56>
  nulterminate(cmd);
     888:	854a                	mv	a0,s2
     88a:	f3dff0ef          	jal	ra,7c6 <nulterminate>
}
     88e:	854a                	mv	a0,s2
     890:	70a2                	ld	ra,40(sp)
     892:	7402                	ld	s0,32(sp)
     894:	64e2                	ld	s1,24(sp)
     896:	6942                	ld	s2,16(sp)
     898:	6145                	addi	sp,sp,48
     89a:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     89c:	00001597          	auipc	a1,0x1
     8a0:	a4c58593          	addi	a1,a1,-1460 # 12e8 <malloc+0x1d2>
     8a4:	4509                	li	a0,2
     8a6:	78c000ef          	jal	ra,1032 <fprintf>
    panic("syntax");
     8aa:	00001517          	auipc	a0,0x1
     8ae:	9ce50513          	addi	a0,a0,-1586 # 1278 <malloc+0x162>
     8b2:	f98ff0ef          	jal	ra,4a <panic>

00000000000008b6 <main>:
{
     8b6:	7139                	addi	sp,sp,-64
     8b8:	fc06                	sd	ra,56(sp)
     8ba:	f822                	sd	s0,48(sp)
     8bc:	f426                	sd	s1,40(sp)
     8be:	f04a                	sd	s2,32(sp)
     8c0:	ec4e                	sd	s3,24(sp)
     8c2:	e852                	sd	s4,16(sp)
     8c4:	e456                	sd	s5,8(sp)
     8c6:	e05a                	sd	s6,0(sp)
     8c8:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     8ca:	00001497          	auipc	s1,0x1
     8ce:	a2e48493          	addi	s1,s1,-1490 # 12f8 <malloc+0x1e2>
     8d2:	4589                	li	a1,2
     8d4:	8526                	mv	a0,s1
     8d6:	398000ef          	jal	ra,c6e <open>
     8da:	00054763          	bltz	a0,8e8 <main+0x32>
    if(fd >= 3){
     8de:	4789                	li	a5,2
     8e0:	fea7d9e3          	bge	a5,a0,8d2 <main+0x1c>
      close(fd);
     8e4:	372000ef          	jal	ra,c56 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     8e8:	00001a17          	auipc	s4,0x1
     8ec:	738a0a13          	addi	s4,s4,1848 # 2020 <buf.1142>
    while (*cmd == ' ' || *cmd == '\t')
     8f0:	02000913          	li	s2,32
     8f4:	49a5                	li	s3,9
    if (*cmd == '\n') // is a blank command
     8f6:	4aa9                	li	s5,10
    if(cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' '){
     8f8:	06300b13          	li	s6,99
     8fc:	a805                	j	92c <main+0x76>
      cmd++;
     8fe:	0485                	addi	s1,s1,1
    while (*cmd == ' ' || *cmd == '\t')
     900:	0004c783          	lbu	a5,0(s1)
     904:	ff278de3          	beq	a5,s2,8fe <main+0x48>
     908:	ff378be3          	beq	a5,s3,8fe <main+0x48>
    if (*cmd == '\n') // is a blank command
     90c:	03578063          	beq	a5,s5,92c <main+0x76>
    if(cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' '){
     910:	01679863          	bne	a5,s6,920 <main+0x6a>
     914:	0014c703          	lbu	a4,1(s1)
     918:	06400793          	li	a5,100
     91c:	02f70463          	beq	a4,a5,944 <main+0x8e>
      if(fork1() == 0)
     920:	f48ff0ef          	jal	ra,68 <fork1>
     924:	cd29                	beqz	a0,97e <main+0xc8>
      wait(0);
     926:	4501                	li	a0,0
     928:	30e000ef          	jal	ra,c36 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     92c:	06400593          	li	a1,100
     930:	8552                	mv	a0,s4
     932:	eceff0ef          	jal	ra,0 <getcmd>
     936:	04054963          	bltz	a0,988 <main+0xd2>
    char *cmd = buf;
     93a:	00001497          	auipc	s1,0x1
     93e:	6e648493          	addi	s1,s1,1766 # 2020 <buf.1142>
     942:	bf7d                	j	900 <main+0x4a>
    if(cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' '){
     944:	0024c783          	lbu	a5,2(s1)
     948:	fd279ce3          	bne	a5,s2,920 <main+0x6a>
      cmd[strlen(cmd)-1] = 0;  // chop \n
     94c:	8526                	mv	a0,s1
     94e:	09a000ef          	jal	ra,9e8 <strlen>
     952:	fff5079b          	addiw	a5,a0,-1
     956:	1782                	slli	a5,a5,0x20
     958:	9381                	srli	a5,a5,0x20
     95a:	97a6                	add	a5,a5,s1
     95c:	00078023          	sb	zero,0(a5)
      if(chdir(cmd+3) < 0)
     960:	048d                	addi	s1,s1,3
     962:	8526                	mv	a0,s1
     964:	33a000ef          	jal	ra,c9e <chdir>
     968:	fc0552e3          	bgez	a0,92c <main+0x76>
        fprintf(2, "cannot cd %s\n", cmd+3);
     96c:	8626                	mv	a2,s1
     96e:	00001597          	auipc	a1,0x1
     972:	99258593          	addi	a1,a1,-1646 # 1300 <malloc+0x1ea>
     976:	4509                	li	a0,2
     978:	6ba000ef          	jal	ra,1032 <fprintf>
     97c:	bf45                	j	92c <main+0x76>
        runcmd(parsecmd(cmd));
     97e:	8526                	mv	a0,s1
     980:	ec7ff0ef          	jal	ra,846 <parsecmd>
     984:	f0aff0ef          	jal	ra,8e <runcmd>
  exit(0);
     988:	4501                	li	a0,0
     98a:	2a4000ef          	jal	ra,c2e <exit>

000000000000098e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     98e:	1141                	addi	sp,sp,-16
     990:	e406                	sd	ra,8(sp)
     992:	e022                	sd	s0,0(sp)
     994:	0800                	addi	s0,sp,16
  extern int main();
  main();
     996:	f21ff0ef          	jal	ra,8b6 <main>
  exit(0);
     99a:	4501                	li	a0,0
     99c:	292000ef          	jal	ra,c2e <exit>

00000000000009a0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9a0:	1141                	addi	sp,sp,-16
     9a2:	e422                	sd	s0,8(sp)
     9a4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9a6:	87aa                	mv	a5,a0
     9a8:	0585                	addi	a1,a1,1
     9aa:	0785                	addi	a5,a5,1
     9ac:	fff5c703          	lbu	a4,-1(a1)
     9b0:	fee78fa3          	sb	a4,-1(a5)
     9b4:	fb75                	bnez	a4,9a8 <strcpy+0x8>
    ;
  return os;
}
     9b6:	6422                	ld	s0,8(sp)
     9b8:	0141                	addi	sp,sp,16
     9ba:	8082                	ret

00000000000009bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9bc:	1141                	addi	sp,sp,-16
     9be:	e422                	sd	s0,8(sp)
     9c0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9c2:	00054783          	lbu	a5,0(a0)
     9c6:	cb91                	beqz	a5,9da <strcmp+0x1e>
     9c8:	0005c703          	lbu	a4,0(a1)
     9cc:	00f71763          	bne	a4,a5,9da <strcmp+0x1e>
    p++, q++;
     9d0:	0505                	addi	a0,a0,1
     9d2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9d4:	00054783          	lbu	a5,0(a0)
     9d8:	fbe5                	bnez	a5,9c8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     9da:	0005c503          	lbu	a0,0(a1)
}
     9de:	40a7853b          	subw	a0,a5,a0
     9e2:	6422                	ld	s0,8(sp)
     9e4:	0141                	addi	sp,sp,16
     9e6:	8082                	ret

00000000000009e8 <strlen>:

uint
strlen(const char *s)
{
     9e8:	1141                	addi	sp,sp,-16
     9ea:	e422                	sd	s0,8(sp)
     9ec:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9ee:	00054783          	lbu	a5,0(a0)
     9f2:	cf91                	beqz	a5,a0e <strlen+0x26>
     9f4:	0505                	addi	a0,a0,1
     9f6:	87aa                	mv	a5,a0
     9f8:	4685                	li	a3,1
     9fa:	9e89                	subw	a3,a3,a0
     9fc:	00f6853b          	addw	a0,a3,a5
     a00:	0785                	addi	a5,a5,1
     a02:	fff7c703          	lbu	a4,-1(a5)
     a06:	fb7d                	bnez	a4,9fc <strlen+0x14>
    ;
  return n;
}
     a08:	6422                	ld	s0,8(sp)
     a0a:	0141                	addi	sp,sp,16
     a0c:	8082                	ret
  for(n = 0; s[n]; n++)
     a0e:	4501                	li	a0,0
     a10:	bfe5                	j	a08 <strlen+0x20>

0000000000000a12 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a12:	1141                	addi	sp,sp,-16
     a14:	e422                	sd	s0,8(sp)
     a16:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a18:	ce09                	beqz	a2,a32 <memset+0x20>
     a1a:	87aa                	mv	a5,a0
     a1c:	fff6071b          	addiw	a4,a2,-1
     a20:	1702                	slli	a4,a4,0x20
     a22:	9301                	srli	a4,a4,0x20
     a24:	0705                	addi	a4,a4,1
     a26:	972a                	add	a4,a4,a0
    cdst[i] = c;
     a28:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a2c:	0785                	addi	a5,a5,1
     a2e:	fee79de3          	bne	a5,a4,a28 <memset+0x16>
  }
  return dst;
}
     a32:	6422                	ld	s0,8(sp)
     a34:	0141                	addi	sp,sp,16
     a36:	8082                	ret

0000000000000a38 <strchr>:

char*
strchr(const char *s, char c)
{
     a38:	1141                	addi	sp,sp,-16
     a3a:	e422                	sd	s0,8(sp)
     a3c:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a3e:	00054783          	lbu	a5,0(a0)
     a42:	cb99                	beqz	a5,a58 <strchr+0x20>
    if(*s == c)
     a44:	00f58763          	beq	a1,a5,a52 <strchr+0x1a>
  for(; *s; s++)
     a48:	0505                	addi	a0,a0,1
     a4a:	00054783          	lbu	a5,0(a0)
     a4e:	fbfd                	bnez	a5,a44 <strchr+0xc>
      return (char*)s;
  return 0;
     a50:	4501                	li	a0,0
}
     a52:	6422                	ld	s0,8(sp)
     a54:	0141                	addi	sp,sp,16
     a56:	8082                	ret
  return 0;
     a58:	4501                	li	a0,0
     a5a:	bfe5                	j	a52 <strchr+0x1a>

0000000000000a5c <gets>:

char*
gets(char *buf, int max)
{
     a5c:	711d                	addi	sp,sp,-96
     a5e:	ec86                	sd	ra,88(sp)
     a60:	e8a2                	sd	s0,80(sp)
     a62:	e4a6                	sd	s1,72(sp)
     a64:	e0ca                	sd	s2,64(sp)
     a66:	fc4e                	sd	s3,56(sp)
     a68:	f852                	sd	s4,48(sp)
     a6a:	f456                	sd	s5,40(sp)
     a6c:	f05a                	sd	s6,32(sp)
     a6e:	ec5e                	sd	s7,24(sp)
     a70:	1080                	addi	s0,sp,96
     a72:	8baa                	mv	s7,a0
     a74:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a76:	892a                	mv	s2,a0
     a78:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a7a:	4aa9                	li	s5,10
     a7c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a7e:	89a6                	mv	s3,s1
     a80:	2485                	addiw	s1,s1,1
     a82:	0344d663          	bge	s1,s4,aae <gets+0x52>
    cc = read(0, &c, 1);
     a86:	4605                	li	a2,1
     a88:	faf40593          	addi	a1,s0,-81
     a8c:	4501                	li	a0,0
     a8e:	1b8000ef          	jal	ra,c46 <read>
    if(cc < 1)
     a92:	00a05e63          	blez	a0,aae <gets+0x52>
    buf[i++] = c;
     a96:	faf44783          	lbu	a5,-81(s0)
     a9a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a9e:	01578763          	beq	a5,s5,aac <gets+0x50>
     aa2:	0905                	addi	s2,s2,1
     aa4:	fd679de3          	bne	a5,s6,a7e <gets+0x22>
  for(i=0; i+1 < max; ){
     aa8:	89a6                	mv	s3,s1
     aaa:	a011                	j	aae <gets+0x52>
     aac:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     aae:	99de                	add	s3,s3,s7
     ab0:	00098023          	sb	zero,0(s3)
  return buf;
}
     ab4:	855e                	mv	a0,s7
     ab6:	60e6                	ld	ra,88(sp)
     ab8:	6446                	ld	s0,80(sp)
     aba:	64a6                	ld	s1,72(sp)
     abc:	6906                	ld	s2,64(sp)
     abe:	79e2                	ld	s3,56(sp)
     ac0:	7a42                	ld	s4,48(sp)
     ac2:	7aa2                	ld	s5,40(sp)
     ac4:	7b02                	ld	s6,32(sp)
     ac6:	6be2                	ld	s7,24(sp)
     ac8:	6125                	addi	sp,sp,96
     aca:	8082                	ret

0000000000000acc <stat>:

int
stat(const char *n, struct stat *st)
{
     acc:	1101                	addi	sp,sp,-32
     ace:	ec06                	sd	ra,24(sp)
     ad0:	e822                	sd	s0,16(sp)
     ad2:	e426                	sd	s1,8(sp)
     ad4:	e04a                	sd	s2,0(sp)
     ad6:	1000                	addi	s0,sp,32
     ad8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ada:	4581                	li	a1,0
     adc:	192000ef          	jal	ra,c6e <open>
  if(fd < 0)
     ae0:	02054163          	bltz	a0,b02 <stat+0x36>
     ae4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     ae6:	85ca                	mv	a1,s2
     ae8:	19e000ef          	jal	ra,c86 <fstat>
     aec:	892a                	mv	s2,a0
  close(fd);
     aee:	8526                	mv	a0,s1
     af0:	166000ef          	jal	ra,c56 <close>
  return r;
}
     af4:	854a                	mv	a0,s2
     af6:	60e2                	ld	ra,24(sp)
     af8:	6442                	ld	s0,16(sp)
     afa:	64a2                	ld	s1,8(sp)
     afc:	6902                	ld	s2,0(sp)
     afe:	6105                	addi	sp,sp,32
     b00:	8082                	ret
    return -1;
     b02:	597d                	li	s2,-1
     b04:	bfc5                	j	af4 <stat+0x28>

0000000000000b06 <atoi>:

int
atoi(const char *s)
{
     b06:	1141                	addi	sp,sp,-16
     b08:	e422                	sd	s0,8(sp)
     b0a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b0c:	00054603          	lbu	a2,0(a0)
     b10:	fd06079b          	addiw	a5,a2,-48
     b14:	0ff7f793          	andi	a5,a5,255
     b18:	4725                	li	a4,9
     b1a:	02f76963          	bltu	a4,a5,b4c <atoi+0x46>
     b1e:	86aa                	mv	a3,a0
  n = 0;
     b20:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     b22:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     b24:	0685                	addi	a3,a3,1
     b26:	0025179b          	slliw	a5,a0,0x2
     b2a:	9fa9                	addw	a5,a5,a0
     b2c:	0017979b          	slliw	a5,a5,0x1
     b30:	9fb1                	addw	a5,a5,a2
     b32:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b36:	0006c603          	lbu	a2,0(a3)
     b3a:	fd06071b          	addiw	a4,a2,-48
     b3e:	0ff77713          	andi	a4,a4,255
     b42:	fee5f1e3          	bgeu	a1,a4,b24 <atoi+0x1e>
  return n;
}
     b46:	6422                	ld	s0,8(sp)
     b48:	0141                	addi	sp,sp,16
     b4a:	8082                	ret
  n = 0;
     b4c:	4501                	li	a0,0
     b4e:	bfe5                	j	b46 <atoi+0x40>

0000000000000b50 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b50:	1141                	addi	sp,sp,-16
     b52:	e422                	sd	s0,8(sp)
     b54:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b56:	02b57663          	bgeu	a0,a1,b82 <memmove+0x32>
    while(n-- > 0)
     b5a:	02c05163          	blez	a2,b7c <memmove+0x2c>
     b5e:	fff6079b          	addiw	a5,a2,-1
     b62:	1782                	slli	a5,a5,0x20
     b64:	9381                	srli	a5,a5,0x20
     b66:	0785                	addi	a5,a5,1
     b68:	97aa                	add	a5,a5,a0
  dst = vdst;
     b6a:	872a                	mv	a4,a0
      *dst++ = *src++;
     b6c:	0585                	addi	a1,a1,1
     b6e:	0705                	addi	a4,a4,1
     b70:	fff5c683          	lbu	a3,-1(a1)
     b74:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b78:	fee79ae3          	bne	a5,a4,b6c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b7c:	6422                	ld	s0,8(sp)
     b7e:	0141                	addi	sp,sp,16
     b80:	8082                	ret
    dst += n;
     b82:	00c50733          	add	a4,a0,a2
    src += n;
     b86:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b88:	fec05ae3          	blez	a2,b7c <memmove+0x2c>
     b8c:	fff6079b          	addiw	a5,a2,-1
     b90:	1782                	slli	a5,a5,0x20
     b92:	9381                	srli	a5,a5,0x20
     b94:	fff7c793          	not	a5,a5
     b98:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b9a:	15fd                	addi	a1,a1,-1
     b9c:	177d                	addi	a4,a4,-1
     b9e:	0005c683          	lbu	a3,0(a1)
     ba2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     ba6:	fee79ae3          	bne	a5,a4,b9a <memmove+0x4a>
     baa:	bfc9                	j	b7c <memmove+0x2c>

0000000000000bac <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bac:	1141                	addi	sp,sp,-16
     bae:	e422                	sd	s0,8(sp)
     bb0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bb2:	ca05                	beqz	a2,be2 <memcmp+0x36>
     bb4:	fff6069b          	addiw	a3,a2,-1
     bb8:	1682                	slli	a3,a3,0x20
     bba:	9281                	srli	a3,a3,0x20
     bbc:	0685                	addi	a3,a3,1
     bbe:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     bc0:	00054783          	lbu	a5,0(a0)
     bc4:	0005c703          	lbu	a4,0(a1)
     bc8:	00e79863          	bne	a5,a4,bd8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     bcc:	0505                	addi	a0,a0,1
    p2++;
     bce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     bd0:	fed518e3          	bne	a0,a3,bc0 <memcmp+0x14>
  }
  return 0;
     bd4:	4501                	li	a0,0
     bd6:	a019                	j	bdc <memcmp+0x30>
      return *p1 - *p2;
     bd8:	40e7853b          	subw	a0,a5,a4
}
     bdc:	6422                	ld	s0,8(sp)
     bde:	0141                	addi	sp,sp,16
     be0:	8082                	ret
  return 0;
     be2:	4501                	li	a0,0
     be4:	bfe5                	j	bdc <memcmp+0x30>

0000000000000be6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     be6:	1141                	addi	sp,sp,-16
     be8:	e406                	sd	ra,8(sp)
     bea:	e022                	sd	s0,0(sp)
     bec:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     bee:	f63ff0ef          	jal	ra,b50 <memmove>
}
     bf2:	60a2                	ld	ra,8(sp)
     bf4:	6402                	ld	s0,0(sp)
     bf6:	0141                	addi	sp,sp,16
     bf8:	8082                	ret

0000000000000bfa <sbrk>:

char *
sbrk(int n) {
     bfa:	1141                	addi	sp,sp,-16
     bfc:	e406                	sd	ra,8(sp)
     bfe:	e022                	sd	s0,0(sp)
     c00:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     c02:	4585                	li	a1,1
     c04:	0b2000ef          	jal	ra,cb6 <sys_sbrk>
}
     c08:	60a2                	ld	ra,8(sp)
     c0a:	6402                	ld	s0,0(sp)
     c0c:	0141                	addi	sp,sp,16
     c0e:	8082                	ret

0000000000000c10 <sbrklazy>:

char *
sbrklazy(int n) {
     c10:	1141                	addi	sp,sp,-16
     c12:	e406                	sd	ra,8(sp)
     c14:	e022                	sd	s0,0(sp)
     c16:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c18:	4589                	li	a1,2
     c1a:	09c000ef          	jal	ra,cb6 <sys_sbrk>
}
     c1e:	60a2                	ld	ra,8(sp)
     c20:	6402                	ld	s0,0(sp)
     c22:	0141                	addi	sp,sp,16
     c24:	8082                	ret

0000000000000c26 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c26:	4885                	li	a7,1
 ecall
     c28:	00000073          	ecall
 ret
     c2c:	8082                	ret

0000000000000c2e <exit>:
.global exit
exit:
 li a7, SYS_exit
     c2e:	4889                	li	a7,2
 ecall
     c30:	00000073          	ecall
 ret
     c34:	8082                	ret

0000000000000c36 <wait>:
.global wait
wait:
 li a7, SYS_wait
     c36:	488d                	li	a7,3
 ecall
     c38:	00000073          	ecall
 ret
     c3c:	8082                	ret

0000000000000c3e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c3e:	4891                	li	a7,4
 ecall
     c40:	00000073          	ecall
 ret
     c44:	8082                	ret

0000000000000c46 <read>:
.global read
read:
 li a7, SYS_read
     c46:	4895                	li	a7,5
 ecall
     c48:	00000073          	ecall
 ret
     c4c:	8082                	ret

0000000000000c4e <write>:
.global write
write:
 li a7, SYS_write
     c4e:	48c1                	li	a7,16
 ecall
     c50:	00000073          	ecall
 ret
     c54:	8082                	ret

0000000000000c56 <close>:
.global close
close:
 li a7, SYS_close
     c56:	48d5                	li	a7,21
 ecall
     c58:	00000073          	ecall
 ret
     c5c:	8082                	ret

0000000000000c5e <kill>:
.global kill
kill:
 li a7, SYS_kill
     c5e:	4899                	li	a7,6
 ecall
     c60:	00000073          	ecall
 ret
     c64:	8082                	ret

0000000000000c66 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c66:	489d                	li	a7,7
 ecall
     c68:	00000073          	ecall
 ret
     c6c:	8082                	ret

0000000000000c6e <open>:
.global open
open:
 li a7, SYS_open
     c6e:	48bd                	li	a7,15
 ecall
     c70:	00000073          	ecall
 ret
     c74:	8082                	ret

0000000000000c76 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c76:	48c5                	li	a7,17
 ecall
     c78:	00000073          	ecall
 ret
     c7c:	8082                	ret

0000000000000c7e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c7e:	48c9                	li	a7,18
 ecall
     c80:	00000073          	ecall
 ret
     c84:	8082                	ret

0000000000000c86 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c86:	48a1                	li	a7,8
 ecall
     c88:	00000073          	ecall
 ret
     c8c:	8082                	ret

0000000000000c8e <link>:
.global link
link:
 li a7, SYS_link
     c8e:	48cd                	li	a7,19
 ecall
     c90:	00000073          	ecall
 ret
     c94:	8082                	ret

0000000000000c96 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c96:	48d1                	li	a7,20
 ecall
     c98:	00000073          	ecall
 ret
     c9c:	8082                	ret

0000000000000c9e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c9e:	48a5                	li	a7,9
 ecall
     ca0:	00000073          	ecall
 ret
     ca4:	8082                	ret

0000000000000ca6 <dup>:
.global dup
dup:
 li a7, SYS_dup
     ca6:	48a9                	li	a7,10
 ecall
     ca8:	00000073          	ecall
 ret
     cac:	8082                	ret

0000000000000cae <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     cae:	48ad                	li	a7,11
 ecall
     cb0:	00000073          	ecall
 ret
     cb4:	8082                	ret

0000000000000cb6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     cb6:	48b1                	li	a7,12
 ecall
     cb8:	00000073          	ecall
 ret
     cbc:	8082                	ret

0000000000000cbe <pause>:
.global pause
pause:
 li a7, SYS_pause
     cbe:	48b5                	li	a7,13
 ecall
     cc0:	00000073          	ecall
 ret
     cc4:	8082                	ret

0000000000000cc6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     cc6:	48b9                	li	a7,14
 ecall
     cc8:	00000073          	ecall
 ret
     ccc:	8082                	ret

0000000000000cce <getproctree>:
.global getproctree
getproctree:
 li a7, SYS_getproctree
     cce:	48d9                	li	a7,22
 ecall
     cd0:	00000073          	ecall
 ret
     cd4:	8082                	ret

0000000000000cd6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     cd6:	1101                	addi	sp,sp,-32
     cd8:	ec06                	sd	ra,24(sp)
     cda:	e822                	sd	s0,16(sp)
     cdc:	1000                	addi	s0,sp,32
     cde:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ce2:	4605                	li	a2,1
     ce4:	fef40593          	addi	a1,s0,-17
     ce8:	f67ff0ef          	jal	ra,c4e <write>
}
     cec:	60e2                	ld	ra,24(sp)
     cee:	6442                	ld	s0,16(sp)
     cf0:	6105                	addi	sp,sp,32
     cf2:	8082                	ret

0000000000000cf4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     cf4:	715d                	addi	sp,sp,-80
     cf6:	e486                	sd	ra,72(sp)
     cf8:	e0a2                	sd	s0,64(sp)
     cfa:	fc26                	sd	s1,56(sp)
     cfc:	f84a                	sd	s2,48(sp)
     cfe:	f44e                	sd	s3,40(sp)
     d00:	0880                	addi	s0,sp,80
     d02:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d04:	c299                	beqz	a3,d0a <printint+0x16>
     d06:	0805c663          	bltz	a1,d92 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     d0a:	2581                	sext.w	a1,a1
  neg = 0;
     d0c:	4881                	li	a7,0
     d0e:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
     d12:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d14:	2601                	sext.w	a2,a2
     d16:	00000517          	auipc	a0,0x0
     d1a:	63250513          	addi	a0,a0,1586 # 1348 <digits>
     d1e:	883a                	mv	a6,a4
     d20:	2705                	addiw	a4,a4,1
     d22:	02c5f7bb          	remuw	a5,a1,a2
     d26:	1782                	slli	a5,a5,0x20
     d28:	9381                	srli	a5,a5,0x20
     d2a:	97aa                	add	a5,a5,a0
     d2c:	0007c783          	lbu	a5,0(a5)
     d30:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d34:	0005879b          	sext.w	a5,a1
     d38:	02c5d5bb          	divuw	a1,a1,a2
     d3c:	0685                	addi	a3,a3,1
     d3e:	fec7f0e3          	bgeu	a5,a2,d1e <printint+0x2a>
  if(neg)
     d42:	00088b63          	beqz	a7,d58 <printint+0x64>
    buf[i++] = '-';
     d46:	fd040793          	addi	a5,s0,-48
     d4a:	973e                	add	a4,a4,a5
     d4c:	02d00793          	li	a5,45
     d50:	fef70423          	sb	a5,-24(a4)
     d54:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     d58:	02e05663          	blez	a4,d84 <printint+0x90>
     d5c:	fb840793          	addi	a5,s0,-72
     d60:	00e78933          	add	s2,a5,a4
     d64:	fff78993          	addi	s3,a5,-1
     d68:	99ba                	add	s3,s3,a4
     d6a:	377d                	addiw	a4,a4,-1
     d6c:	1702                	slli	a4,a4,0x20
     d6e:	9301                	srli	a4,a4,0x20
     d70:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d74:	fff94583          	lbu	a1,-1(s2)
     d78:	8526                	mv	a0,s1
     d7a:	f5dff0ef          	jal	ra,cd6 <putc>
  while(--i >= 0)
     d7e:	197d                	addi	s2,s2,-1
     d80:	ff391ae3          	bne	s2,s3,d74 <printint+0x80>
}
     d84:	60a6                	ld	ra,72(sp)
     d86:	6406                	ld	s0,64(sp)
     d88:	74e2                	ld	s1,56(sp)
     d8a:	7942                	ld	s2,48(sp)
     d8c:	79a2                	ld	s3,40(sp)
     d8e:	6161                	addi	sp,sp,80
     d90:	8082                	ret
    x = -xx;
     d92:	40b005bb          	negw	a1,a1
    neg = 1;
     d96:	4885                	li	a7,1
    x = -xx;
     d98:	bf9d                	j	d0e <printint+0x1a>

0000000000000d9a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d9a:	7119                	addi	sp,sp,-128
     d9c:	fc86                	sd	ra,120(sp)
     d9e:	f8a2                	sd	s0,112(sp)
     da0:	f4a6                	sd	s1,104(sp)
     da2:	f0ca                	sd	s2,96(sp)
     da4:	ecce                	sd	s3,88(sp)
     da6:	e8d2                	sd	s4,80(sp)
     da8:	e4d6                	sd	s5,72(sp)
     daa:	e0da                	sd	s6,64(sp)
     dac:	fc5e                	sd	s7,56(sp)
     dae:	f862                	sd	s8,48(sp)
     db0:	f466                	sd	s9,40(sp)
     db2:	f06a                	sd	s10,32(sp)
     db4:	ec6e                	sd	s11,24(sp)
     db6:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     db8:	0005c903          	lbu	s2,0(a1)
     dbc:	24090c63          	beqz	s2,1014 <vprintf+0x27a>
     dc0:	8b2a                	mv	s6,a0
     dc2:	8a2e                	mv	s4,a1
     dc4:	8bb2                	mv	s7,a2
  state = 0;
     dc6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     dc8:	4481                	li	s1,0
     dca:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     dcc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     dd0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     dd4:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     dd8:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     ddc:	00000c97          	auipc	s9,0x0
     de0:	56cc8c93          	addi	s9,s9,1388 # 1348 <digits>
     de4:	a005                	j	e04 <vprintf+0x6a>
        putc(fd, c0);
     de6:	85ca                	mv	a1,s2
     de8:	855a                	mv	a0,s6
     dea:	eedff0ef          	jal	ra,cd6 <putc>
     dee:	a019                	j	df4 <vprintf+0x5a>
    } else if(state == '%'){
     df0:	03598263          	beq	s3,s5,e14 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     df4:	2485                	addiw	s1,s1,1
     df6:	8726                	mv	a4,s1
     df8:	009a07b3          	add	a5,s4,s1
     dfc:	0007c903          	lbu	s2,0(a5)
     e00:	20090a63          	beqz	s2,1014 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
     e04:	0009079b          	sext.w	a5,s2
    if(state == 0){
     e08:	fe0994e3          	bnez	s3,df0 <vprintf+0x56>
      if(c0 == '%'){
     e0c:	fd579de3          	bne	a5,s5,de6 <vprintf+0x4c>
        state = '%';
     e10:	89be                	mv	s3,a5
     e12:	b7cd                	j	df4 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
     e14:	c3c1                	beqz	a5,e94 <vprintf+0xfa>
     e16:	00ea06b3          	add	a3,s4,a4
     e1a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     e1e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     e20:	c681                	beqz	a3,e28 <vprintf+0x8e>
     e22:	9752                	add	a4,a4,s4
     e24:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     e28:	03878e63          	beq	a5,s8,e64 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
     e2c:	05a78863          	beq	a5,s10,e7c <vprintf+0xe2>
      } else if(c0 == 'u'){
     e30:	0db78b63          	beq	a5,s11,f06 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     e34:	07800713          	li	a4,120
     e38:	10e78d63          	beq	a5,a4,f52 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     e3c:	07000713          	li	a4,112
     e40:	14e78263          	beq	a5,a4,f84 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
     e44:	06300713          	li	a4,99
     e48:	16e78f63          	beq	a5,a4,fc6 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
     e4c:	07300713          	li	a4,115
     e50:	18e78563          	beq	a5,a4,fda <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e54:	05579063          	bne	a5,s5,e94 <vprintf+0xfa>
        putc(fd, '%');
     e58:	85d6                	mv	a1,s5
     e5a:	855a                	mv	a0,s6
     e5c:	e7bff0ef          	jal	ra,cd6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     e60:	4981                	li	s3,0
     e62:	bf49                	j	df4 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
     e64:	008b8913          	addi	s2,s7,8
     e68:	4685                	li	a3,1
     e6a:	4629                	li	a2,10
     e6c:	000ba583          	lw	a1,0(s7)
     e70:	855a                	mv	a0,s6
     e72:	e83ff0ef          	jal	ra,cf4 <printint>
     e76:	8bca                	mv	s7,s2
      state = 0;
     e78:	4981                	li	s3,0
     e7a:	bfad                	j	df4 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
     e7c:	03868663          	beq	a3,s8,ea8 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e80:	05a68163          	beq	a3,s10,ec2 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
     e84:	09b68d63          	beq	a3,s11,f1e <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e88:	03a68f63          	beq	a3,s10,ec6 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
     e8c:	07800793          	li	a5,120
     e90:	0cf68d63          	beq	a3,a5,f6a <vprintf+0x1d0>
        putc(fd, '%');
     e94:	85d6                	mv	a1,s5
     e96:	855a                	mv	a0,s6
     e98:	e3fff0ef          	jal	ra,cd6 <putc>
        putc(fd, c0);
     e9c:	85ca                	mv	a1,s2
     e9e:	855a                	mv	a0,s6
     ea0:	e37ff0ef          	jal	ra,cd6 <putc>
      state = 0;
     ea4:	4981                	li	s3,0
     ea6:	b7b9                	j	df4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ea8:	008b8913          	addi	s2,s7,8
     eac:	4685                	li	a3,1
     eae:	4629                	li	a2,10
     eb0:	000bb583          	ld	a1,0(s7)
     eb4:	855a                	mv	a0,s6
     eb6:	e3fff0ef          	jal	ra,cf4 <printint>
        i += 1;
     eba:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     ebc:	8bca                	mv	s7,s2
      state = 0;
     ebe:	4981                	li	s3,0
        i += 1;
     ec0:	bf15                	j	df4 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     ec2:	03860563          	beq	a2,s8,eec <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     ec6:	07b60963          	beq	a2,s11,f38 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     eca:	07800793          	li	a5,120
     ece:	fcf613e3          	bne	a2,a5,e94 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
     ed2:	008b8913          	addi	s2,s7,8
     ed6:	4681                	li	a3,0
     ed8:	4641                	li	a2,16
     eda:	000bb583          	ld	a1,0(s7)
     ede:	855a                	mv	a0,s6
     ee0:	e15ff0ef          	jal	ra,cf4 <printint>
        i += 2;
     ee4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     ee6:	8bca                	mv	s7,s2
      state = 0;
     ee8:	4981                	li	s3,0
        i += 2;
     eea:	b729                	j	df4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     eec:	008b8913          	addi	s2,s7,8
     ef0:	4685                	li	a3,1
     ef2:	4629                	li	a2,10
     ef4:	000bb583          	ld	a1,0(s7)
     ef8:	855a                	mv	a0,s6
     efa:	dfbff0ef          	jal	ra,cf4 <printint>
        i += 2;
     efe:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f00:	8bca                	mv	s7,s2
      state = 0;
     f02:	4981                	li	s3,0
        i += 2;
     f04:	bdc5                	j	df4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
     f06:	008b8913          	addi	s2,s7,8
     f0a:	4681                	li	a3,0
     f0c:	4629                	li	a2,10
     f0e:	000be583          	lwu	a1,0(s7)
     f12:	855a                	mv	a0,s6
     f14:	de1ff0ef          	jal	ra,cf4 <printint>
     f18:	8bca                	mv	s7,s2
      state = 0;
     f1a:	4981                	li	s3,0
     f1c:	bde1                	j	df4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f1e:	008b8913          	addi	s2,s7,8
     f22:	4681                	li	a3,0
     f24:	4629                	li	a2,10
     f26:	000bb583          	ld	a1,0(s7)
     f2a:	855a                	mv	a0,s6
     f2c:	dc9ff0ef          	jal	ra,cf4 <printint>
        i += 1;
     f30:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f32:	8bca                	mv	s7,s2
      state = 0;
     f34:	4981                	li	s3,0
        i += 1;
     f36:	bd7d                	j	df4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f38:	008b8913          	addi	s2,s7,8
     f3c:	4681                	li	a3,0
     f3e:	4629                	li	a2,10
     f40:	000bb583          	ld	a1,0(s7)
     f44:	855a                	mv	a0,s6
     f46:	dafff0ef          	jal	ra,cf4 <printint>
        i += 2;
     f4a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f4c:	8bca                	mv	s7,s2
      state = 0;
     f4e:	4981                	li	s3,0
        i += 2;
     f50:	b555                	j	df4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
     f52:	008b8913          	addi	s2,s7,8
     f56:	4681                	li	a3,0
     f58:	4641                	li	a2,16
     f5a:	000be583          	lwu	a1,0(s7)
     f5e:	855a                	mv	a0,s6
     f60:	d95ff0ef          	jal	ra,cf4 <printint>
     f64:	8bca                	mv	s7,s2
      state = 0;
     f66:	4981                	li	s3,0
     f68:	b571                	j	df4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f6a:	008b8913          	addi	s2,s7,8
     f6e:	4681                	li	a3,0
     f70:	4641                	li	a2,16
     f72:	000bb583          	ld	a1,0(s7)
     f76:	855a                	mv	a0,s6
     f78:	d7dff0ef          	jal	ra,cf4 <printint>
        i += 1;
     f7c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f7e:	8bca                	mv	s7,s2
      state = 0;
     f80:	4981                	li	s3,0
        i += 1;
     f82:	bd8d                	j	df4 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
     f84:	008b8793          	addi	a5,s7,8
     f88:	f8f43423          	sd	a5,-120(s0)
     f8c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f90:	03000593          	li	a1,48
     f94:	855a                	mv	a0,s6
     f96:	d41ff0ef          	jal	ra,cd6 <putc>
  putc(fd, 'x');
     f9a:	07800593          	li	a1,120
     f9e:	855a                	mv	a0,s6
     fa0:	d37ff0ef          	jal	ra,cd6 <putc>
     fa4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fa6:	03c9d793          	srli	a5,s3,0x3c
     faa:	97e6                	add	a5,a5,s9
     fac:	0007c583          	lbu	a1,0(a5)
     fb0:	855a                	mv	a0,s6
     fb2:	d25ff0ef          	jal	ra,cd6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     fb6:	0992                	slli	s3,s3,0x4
     fb8:	397d                	addiw	s2,s2,-1
     fba:	fe0916e3          	bnez	s2,fa6 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
     fbe:	f8843b83          	ld	s7,-120(s0)
      state = 0;
     fc2:	4981                	li	s3,0
     fc4:	bd05                	j	df4 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
     fc6:	008b8913          	addi	s2,s7,8
     fca:	000bc583          	lbu	a1,0(s7)
     fce:	855a                	mv	a0,s6
     fd0:	d07ff0ef          	jal	ra,cd6 <putc>
     fd4:	8bca                	mv	s7,s2
      state = 0;
     fd6:	4981                	li	s3,0
     fd8:	bd31                	j	df4 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
     fda:	008b8993          	addi	s3,s7,8
     fde:	000bb903          	ld	s2,0(s7)
     fe2:	00090f63          	beqz	s2,1000 <vprintf+0x266>
        for(; *s; s++)
     fe6:	00094583          	lbu	a1,0(s2)
     fea:	c195                	beqz	a1,100e <vprintf+0x274>
          putc(fd, *s);
     fec:	855a                	mv	a0,s6
     fee:	ce9ff0ef          	jal	ra,cd6 <putc>
        for(; *s; s++)
     ff2:	0905                	addi	s2,s2,1
     ff4:	00094583          	lbu	a1,0(s2)
     ff8:	f9f5                	bnez	a1,fec <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
     ffa:	8bce                	mv	s7,s3
      state = 0;
     ffc:	4981                	li	s3,0
     ffe:	bbdd                	j	df4 <vprintf+0x5a>
          s = "(null)";
    1000:	00000917          	auipc	s2,0x0
    1004:	34090913          	addi	s2,s2,832 # 1340 <malloc+0x22a>
        for(; *s; s++)
    1008:	02800593          	li	a1,40
    100c:	b7c5                	j	fec <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
    100e:	8bce                	mv	s7,s3
      state = 0;
    1010:	4981                	li	s3,0
    1012:	b3cd                	j	df4 <vprintf+0x5a>
    }
  }
}
    1014:	70e6                	ld	ra,120(sp)
    1016:	7446                	ld	s0,112(sp)
    1018:	74a6                	ld	s1,104(sp)
    101a:	7906                	ld	s2,96(sp)
    101c:	69e6                	ld	s3,88(sp)
    101e:	6a46                	ld	s4,80(sp)
    1020:	6aa6                	ld	s5,72(sp)
    1022:	6b06                	ld	s6,64(sp)
    1024:	7be2                	ld	s7,56(sp)
    1026:	7c42                	ld	s8,48(sp)
    1028:	7ca2                	ld	s9,40(sp)
    102a:	7d02                	ld	s10,32(sp)
    102c:	6de2                	ld	s11,24(sp)
    102e:	6109                	addi	sp,sp,128
    1030:	8082                	ret

0000000000001032 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1032:	715d                	addi	sp,sp,-80
    1034:	ec06                	sd	ra,24(sp)
    1036:	e822                	sd	s0,16(sp)
    1038:	1000                	addi	s0,sp,32
    103a:	e010                	sd	a2,0(s0)
    103c:	e414                	sd	a3,8(s0)
    103e:	e818                	sd	a4,16(s0)
    1040:	ec1c                	sd	a5,24(s0)
    1042:	03043023          	sd	a6,32(s0)
    1046:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    104a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    104e:	8622                	mv	a2,s0
    1050:	d4bff0ef          	jal	ra,d9a <vprintf>
}
    1054:	60e2                	ld	ra,24(sp)
    1056:	6442                	ld	s0,16(sp)
    1058:	6161                	addi	sp,sp,80
    105a:	8082                	ret

000000000000105c <printf>:

void
printf(const char *fmt, ...)
{
    105c:	711d                	addi	sp,sp,-96
    105e:	ec06                	sd	ra,24(sp)
    1060:	e822                	sd	s0,16(sp)
    1062:	1000                	addi	s0,sp,32
    1064:	e40c                	sd	a1,8(s0)
    1066:	e810                	sd	a2,16(s0)
    1068:	ec14                	sd	a3,24(s0)
    106a:	f018                	sd	a4,32(s0)
    106c:	f41c                	sd	a5,40(s0)
    106e:	03043823          	sd	a6,48(s0)
    1072:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1076:	00840613          	addi	a2,s0,8
    107a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    107e:	85aa                	mv	a1,a0
    1080:	4505                	li	a0,1
    1082:	d19ff0ef          	jal	ra,d9a <vprintf>
}
    1086:	60e2                	ld	ra,24(sp)
    1088:	6442                	ld	s0,16(sp)
    108a:	6125                	addi	sp,sp,96
    108c:	8082                	ret

000000000000108e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    108e:	1141                	addi	sp,sp,-16
    1090:	e422                	sd	s0,8(sp)
    1092:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1094:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1098:	00001797          	auipc	a5,0x1
    109c:	f787b783          	ld	a5,-136(a5) # 2010 <freep>
    10a0:	a805                	j	10d0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    10a2:	4618                	lw	a4,8(a2)
    10a4:	9db9                	addw	a1,a1,a4
    10a6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10aa:	6398                	ld	a4,0(a5)
    10ac:	6318                	ld	a4,0(a4)
    10ae:	fee53823          	sd	a4,-16(a0)
    10b2:	a091                	j	10f6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    10b4:	ff852703          	lw	a4,-8(a0)
    10b8:	9e39                	addw	a2,a2,a4
    10ba:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    10bc:	ff053703          	ld	a4,-16(a0)
    10c0:	e398                	sd	a4,0(a5)
    10c2:	a099                	j	1108 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10c4:	6398                	ld	a4,0(a5)
    10c6:	00e7e463          	bltu	a5,a4,10ce <free+0x40>
    10ca:	00e6ea63          	bltu	a3,a4,10de <free+0x50>
{
    10ce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10d0:	fed7fae3          	bgeu	a5,a3,10c4 <free+0x36>
    10d4:	6398                	ld	a4,0(a5)
    10d6:	00e6e463          	bltu	a3,a4,10de <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10da:	fee7eae3          	bltu	a5,a4,10ce <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    10de:	ff852583          	lw	a1,-8(a0)
    10e2:	6390                	ld	a2,0(a5)
    10e4:	02059713          	slli	a4,a1,0x20
    10e8:	9301                	srli	a4,a4,0x20
    10ea:	0712                	slli	a4,a4,0x4
    10ec:	9736                	add	a4,a4,a3
    10ee:	fae60ae3          	beq	a2,a4,10a2 <free+0x14>
    bp->s.ptr = p->s.ptr;
    10f2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    10f6:	4790                	lw	a2,8(a5)
    10f8:	02061713          	slli	a4,a2,0x20
    10fc:	9301                	srli	a4,a4,0x20
    10fe:	0712                	slli	a4,a4,0x4
    1100:	973e                	add	a4,a4,a5
    1102:	fae689e3          	beq	a3,a4,10b4 <free+0x26>
  } else
    p->s.ptr = bp;
    1106:	e394                	sd	a3,0(a5)
  freep = p;
    1108:	00001717          	auipc	a4,0x1
    110c:	f0f73423          	sd	a5,-248(a4) # 2010 <freep>
}
    1110:	6422                	ld	s0,8(sp)
    1112:	0141                	addi	sp,sp,16
    1114:	8082                	ret

0000000000001116 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1116:	7139                	addi	sp,sp,-64
    1118:	fc06                	sd	ra,56(sp)
    111a:	f822                	sd	s0,48(sp)
    111c:	f426                	sd	s1,40(sp)
    111e:	f04a                	sd	s2,32(sp)
    1120:	ec4e                	sd	s3,24(sp)
    1122:	e852                	sd	s4,16(sp)
    1124:	e456                	sd	s5,8(sp)
    1126:	e05a                	sd	s6,0(sp)
    1128:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    112a:	02051493          	slli	s1,a0,0x20
    112e:	9081                	srli	s1,s1,0x20
    1130:	04bd                	addi	s1,s1,15
    1132:	8091                	srli	s1,s1,0x4
    1134:	0014899b          	addiw	s3,s1,1
    1138:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    113a:	00001517          	auipc	a0,0x1
    113e:	ed653503          	ld	a0,-298(a0) # 2010 <freep>
    1142:	c515                	beqz	a0,116e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1144:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1146:	4798                	lw	a4,8(a5)
    1148:	02977f63          	bgeu	a4,s1,1186 <malloc+0x70>
    114c:	8a4e                	mv	s4,s3
    114e:	0009871b          	sext.w	a4,s3
    1152:	6685                	lui	a3,0x1
    1154:	00d77363          	bgeu	a4,a3,115a <malloc+0x44>
    1158:	6a05                	lui	s4,0x1
    115a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    115e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1162:	00001917          	auipc	s2,0x1
    1166:	eae90913          	addi	s2,s2,-338 # 2010 <freep>
  if(p == SBRK_ERROR)
    116a:	5afd                	li	s5,-1
    116c:	a0bd                	j	11da <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    116e:	00001797          	auipc	a5,0x1
    1172:	f1a78793          	addi	a5,a5,-230 # 2088 <base>
    1176:	00001717          	auipc	a4,0x1
    117a:	e8f73d23          	sd	a5,-358(a4) # 2010 <freep>
    117e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1180:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1184:	b7e1                	j	114c <malloc+0x36>
      if(p->s.size == nunits)
    1186:	02e48b63          	beq	s1,a4,11bc <malloc+0xa6>
        p->s.size -= nunits;
    118a:	4137073b          	subw	a4,a4,s3
    118e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1190:	1702                	slli	a4,a4,0x20
    1192:	9301                	srli	a4,a4,0x20
    1194:	0712                	slli	a4,a4,0x4
    1196:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1198:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    119c:	00001717          	auipc	a4,0x1
    11a0:	e6a73a23          	sd	a0,-396(a4) # 2010 <freep>
      return (void*)(p + 1);
    11a4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    11a8:	70e2                	ld	ra,56(sp)
    11aa:	7442                	ld	s0,48(sp)
    11ac:	74a2                	ld	s1,40(sp)
    11ae:	7902                	ld	s2,32(sp)
    11b0:	69e2                	ld	s3,24(sp)
    11b2:	6a42                	ld	s4,16(sp)
    11b4:	6aa2                	ld	s5,8(sp)
    11b6:	6b02                	ld	s6,0(sp)
    11b8:	6121                	addi	sp,sp,64
    11ba:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    11bc:	6398                	ld	a4,0(a5)
    11be:	e118                	sd	a4,0(a0)
    11c0:	bff1                	j	119c <malloc+0x86>
  hp->s.size = nu;
    11c2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11c6:	0541                	addi	a0,a0,16
    11c8:	ec7ff0ef          	jal	ra,108e <free>
  return freep;
    11cc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    11d0:	dd61                	beqz	a0,11a8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11d4:	4798                	lw	a4,8(a5)
    11d6:	fa9778e3          	bgeu	a4,s1,1186 <malloc+0x70>
    if(p == freep)
    11da:	00093703          	ld	a4,0(s2)
    11de:	853e                	mv	a0,a5
    11e0:	fef719e3          	bne	a4,a5,11d2 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
    11e4:	8552                	mv	a0,s4
    11e6:	a15ff0ef          	jal	ra,bfa <sbrk>
  if(p == SBRK_ERROR)
    11ea:	fd551ce3          	bne	a0,s5,11c2 <malloc+0xac>
        return 0;
    11ee:	4501                	li	a0,0
    11f0:	bf65                	j	11a8 <malloc+0x92>
