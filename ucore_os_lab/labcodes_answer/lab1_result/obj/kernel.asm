
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 80 fe 10 00       	mov    $0x10fe80,%edx
  10000b:	b8 56 ea 10 00       	mov    $0x10ea56,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 56 ea 10 00       	push   $0x10ea56
  10001f:	e8 59 2d 00 00       	call   102d7d <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 1b 15 00 00       	call   101547 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 40 35 10 00 	movl   $0x103540,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 5c 35 10 00       	push   $0x10355c
  10003e:	e8 01 02 00 00       	call   100244 <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 94 08 00 00       	call   1008df <print_kerninfo>

    grade_backtrace();
  10004b:	e8 76 00 00 00       	call   1000c6 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 ed 29 00 00       	call   102a42 <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 2c 16 00 00       	call   101686 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 89 17 00 00       	call   1017e8 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 d9 0c 00 00       	call   100d3d <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 59 17 00 00       	call   1017c2 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100069:	e8 49 01 00 00       	call   1001b7 <lab1_switch_test>

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	83 ec 04             	sub    $0x4,%esp
  100079:	6a 00                	push   $0x0
  10007b:	6a 00                	push   $0x0
  10007d:	6a 00                	push   $0x0
  10007f:	e8 a7 0c 00 00       	call   100d2b <mon_backtrace>
  100084:	83 c4 10             	add    $0x10,%esp
}
  100087:	c9                   	leave  
  100088:	c3                   	ret    

00100089 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100089:	55                   	push   %ebp
  10008a:	89 e5                	mov    %esp,%ebp
  10008c:	53                   	push   %ebx
  10008d:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  100090:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  100093:	8b 55 0c             	mov    0xc(%ebp),%edx
  100096:	8d 5d 08             	lea    0x8(%ebp),%ebx
  100099:	8b 45 08             	mov    0x8(%ebp),%eax
  10009c:	51                   	push   %ecx
  10009d:	52                   	push   %edx
  10009e:	53                   	push   %ebx
  10009f:	50                   	push   %eax
  1000a0:	e8 cb ff ff ff       	call   100070 <grade_backtrace2>
  1000a5:	83 c4 10             	add    $0x10,%esp
}
  1000a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000ab:	c9                   	leave  
  1000ac:	c3                   	ret    

001000ad <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000ad:	55                   	push   %ebp
  1000ae:	89 e5                	mov    %esp,%ebp
  1000b0:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b3:	83 ec 08             	sub    $0x8,%esp
  1000b6:	ff 75 10             	pushl  0x10(%ebp)
  1000b9:	ff 75 08             	pushl  0x8(%ebp)
  1000bc:	e8 c8 ff ff ff       	call   100089 <grade_backtrace1>
  1000c1:	83 c4 10             	add    $0x10,%esp
}
  1000c4:	c9                   	leave  
  1000c5:	c3                   	ret    

001000c6 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c6:	55                   	push   %ebp
  1000c7:	89 e5                	mov    %esp,%ebp
  1000c9:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000cc:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000d1:	83 ec 04             	sub    $0x4,%esp
  1000d4:	68 00 00 ff ff       	push   $0xffff0000
  1000d9:	50                   	push   %eax
  1000da:	6a 00                	push   $0x0
  1000dc:	e8 cc ff ff ff       	call   1000ad <grade_backtrace0>
  1000e1:	83 c4 10             	add    $0x10,%esp
}
  1000e4:	c9                   	leave  
  1000e5:	c3                   	ret    

001000e6 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000e6:	55                   	push   %ebp
  1000e7:	89 e5                	mov    %esp,%ebp
  1000e9:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000ec:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000ef:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f2:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f5:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000f8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1000fc:	0f b7 c0             	movzwl %ax,%eax
  1000ff:	83 e0 03             	and    $0x3,%eax
  100102:	89 c2                	mov    %eax,%edx
  100104:	a1 80 ea 10 00       	mov    0x10ea80,%eax
  100109:	83 ec 04             	sub    $0x4,%esp
  10010c:	52                   	push   %edx
  10010d:	50                   	push   %eax
  10010e:	68 61 35 10 00       	push   $0x103561
  100113:	e8 2c 01 00 00       	call   100244 <cprintf>
  100118:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011f:	0f b7 d0             	movzwl %ax,%edx
  100122:	a1 80 ea 10 00       	mov    0x10ea80,%eax
  100127:	83 ec 04             	sub    $0x4,%esp
  10012a:	52                   	push   %edx
  10012b:	50                   	push   %eax
  10012c:	68 6f 35 10 00       	push   $0x10356f
  100131:	e8 0e 01 00 00       	call   100244 <cprintf>
  100136:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100139:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10013d:	0f b7 d0             	movzwl %ax,%edx
  100140:	a1 80 ea 10 00       	mov    0x10ea80,%eax
  100145:	83 ec 04             	sub    $0x4,%esp
  100148:	52                   	push   %edx
  100149:	50                   	push   %eax
  10014a:	68 7d 35 10 00       	push   $0x10357d
  10014f:	e8 f0 00 00 00       	call   100244 <cprintf>
  100154:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100157:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 80 ea 10 00       	mov    0x10ea80,%eax
  100163:	83 ec 04             	sub    $0x4,%esp
  100166:	52                   	push   %edx
  100167:	50                   	push   %eax
  100168:	68 8b 35 10 00       	push   $0x10358b
  10016d:	e8 d2 00 00 00       	call   100244 <cprintf>
  100172:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100175:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100179:	0f b7 d0             	movzwl %ax,%edx
  10017c:	a1 80 ea 10 00       	mov    0x10ea80,%eax
  100181:	83 ec 04             	sub    $0x4,%esp
  100184:	52                   	push   %edx
  100185:	50                   	push   %eax
  100186:	68 99 35 10 00       	push   $0x103599
  10018b:	e8 b4 00 00 00       	call   100244 <cprintf>
  100190:	83 c4 10             	add    $0x10,%esp
    round ++;
  100193:	a1 80 ea 10 00       	mov    0x10ea80,%eax
  100198:	83 c0 01             	add    $0x1,%eax
  10019b:	a3 80 ea 10 00       	mov    %eax,0x10ea80
}
  1001a0:	c9                   	leave  
  1001a1:	c3                   	ret    

001001a2 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001a2:	55                   	push   %ebp
  1001a3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001a5:	83 ec 08             	sub    $0x8,%esp
  1001a8:	cd 78                	int    $0x78
  1001aa:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001ac:	5d                   	pop    %ebp
  1001ad:	c3                   	ret    

001001ae <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001ae:	55                   	push   %ebp
  1001af:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001b1:	cd 79                	int    $0x79
  1001b3:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001b5:	5d                   	pop    %ebp
  1001b6:	c3                   	ret    

001001b7 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001b7:	55                   	push   %ebp
  1001b8:	89 e5                	mov    %esp,%ebp
  1001ba:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001bd:	e8 24 ff ff ff       	call   1000e6 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001c2:	83 ec 0c             	sub    $0xc,%esp
  1001c5:	68 a8 35 10 00       	push   $0x1035a8
  1001ca:	e8 75 00 00 00       	call   100244 <cprintf>
  1001cf:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001d2:	e8 cb ff ff ff       	call   1001a2 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001d7:	e8 0a ff ff ff       	call   1000e6 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001dc:	83 ec 0c             	sub    $0xc,%esp
  1001df:	68 c8 35 10 00       	push   $0x1035c8
  1001e4:	e8 5b 00 00 00       	call   100244 <cprintf>
  1001e9:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001ec:	e8 bd ff ff ff       	call   1001ae <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001f1:	e8 f0 fe ff ff       	call   1000e6 <lab1_print_cur_status>
}
  1001f6:	c9                   	leave  
  1001f7:	c3                   	ret    

001001f8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1001f8:	55                   	push   %ebp
  1001f9:	89 e5                	mov    %esp,%ebp
  1001fb:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  1001fe:	83 ec 0c             	sub    $0xc,%esp
  100201:	ff 75 08             	pushl  0x8(%ebp)
  100204:	e8 6e 13 00 00       	call   101577 <cons_putc>
  100209:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  10020c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10020f:	8b 00                	mov    (%eax),%eax
  100211:	8d 50 01             	lea    0x1(%eax),%edx
  100214:	8b 45 0c             	mov    0xc(%ebp),%eax
  100217:	89 10                	mov    %edx,(%eax)
}
  100219:	c9                   	leave  
  10021a:	c3                   	ret    

0010021b <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10021b:	55                   	push   %ebp
  10021c:	89 e5                	mov    %esp,%ebp
  10021e:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100221:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100228:	ff 75 0c             	pushl  0xc(%ebp)
  10022b:	ff 75 08             	pushl  0x8(%ebp)
  10022e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100231:	50                   	push   %eax
  100232:	68 f8 01 10 00       	push   $0x1001f8
  100237:	e8 75 2e 00 00       	call   1030b1 <vprintfmt>
  10023c:	83 c4 10             	add    $0x10,%esp
    return cnt;
  10023f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100242:	c9                   	leave  
  100243:	c3                   	ret    

00100244 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100244:	55                   	push   %ebp
  100245:	89 e5                	mov    %esp,%ebp
  100247:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10024a:	8d 45 0c             	lea    0xc(%ebp),%eax
  10024d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100250:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100253:	83 ec 08             	sub    $0x8,%esp
  100256:	50                   	push   %eax
  100257:	ff 75 08             	pushl  0x8(%ebp)
  10025a:	e8 bc ff ff ff       	call   10021b <vcprintf>
  10025f:	83 c4 10             	add    $0x10,%esp
  100262:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100265:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100268:	c9                   	leave  
  100269:	c3                   	ret    

0010026a <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10026a:	55                   	push   %ebp
  10026b:	89 e5                	mov    %esp,%ebp
  10026d:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100270:	83 ec 0c             	sub    $0xc,%esp
  100273:	ff 75 08             	pushl  0x8(%ebp)
  100276:	e8 fc 12 00 00       	call   101577 <cons_putc>
  10027b:	83 c4 10             	add    $0x10,%esp
}
  10027e:	c9                   	leave  
  10027f:	c3                   	ret    

00100280 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100280:	55                   	push   %ebp
  100281:	89 e5                	mov    %esp,%ebp
  100283:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100286:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10028d:	eb 14                	jmp    1002a3 <cputs+0x23>
        cputch(c, &cnt);
  10028f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100293:	83 ec 08             	sub    $0x8,%esp
  100296:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100299:	52                   	push   %edx
  10029a:	50                   	push   %eax
  10029b:	e8 58 ff ff ff       	call   1001f8 <cputch>
  1002a0:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  1002a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a6:	8d 50 01             	lea    0x1(%eax),%edx
  1002a9:	89 55 08             	mov    %edx,0x8(%ebp)
  1002ac:	0f b6 00             	movzbl (%eax),%eax
  1002af:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002b2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002b6:	75 d7                	jne    10028f <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002b8:	83 ec 08             	sub    $0x8,%esp
  1002bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002be:	50                   	push   %eax
  1002bf:	6a 0a                	push   $0xa
  1002c1:	e8 32 ff ff ff       	call   1001f8 <cputch>
  1002c6:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002cc:	c9                   	leave  
  1002cd:	c3                   	ret    

001002ce <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002ce:	55                   	push   %ebp
  1002cf:	89 e5                	mov    %esp,%ebp
  1002d1:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002d4:	e8 cd 12 00 00       	call   1015a6 <cons_getc>
  1002d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002e0:	74 f2                	je     1002d4 <getchar+0x6>
        /* do nothing */;
    return c;
  1002e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002e5:	c9                   	leave  
  1002e6:	c3                   	ret    

001002e7 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002e7:	55                   	push   %ebp
  1002e8:	89 e5                	mov    %esp,%ebp
  1002ea:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  1002ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002f1:	74 13                	je     100306 <readline+0x1f>
        cprintf("%s", prompt);
  1002f3:	83 ec 08             	sub    $0x8,%esp
  1002f6:	ff 75 08             	pushl  0x8(%ebp)
  1002f9:	68 e7 35 10 00       	push   $0x1035e7
  1002fe:	e8 41 ff ff ff       	call   100244 <cprintf>
  100303:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10030d:	e8 bc ff ff ff       	call   1002ce <getchar>
  100312:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100315:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100319:	79 0a                	jns    100325 <readline+0x3e>
            return NULL;
  10031b:	b8 00 00 00 00       	mov    $0x0,%eax
  100320:	e9 82 00 00 00       	jmp    1003a7 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100325:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100329:	7e 2b                	jle    100356 <readline+0x6f>
  10032b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100332:	7f 22                	jg     100356 <readline+0x6f>
            cputchar(c);
  100334:	83 ec 0c             	sub    $0xc,%esp
  100337:	ff 75 f0             	pushl  -0x10(%ebp)
  10033a:	e8 2b ff ff ff       	call   10026a <cputchar>
  10033f:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100345:	8d 50 01             	lea    0x1(%eax),%edx
  100348:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10034b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10034e:	88 90 c0 ea 10 00    	mov    %dl,0x10eac0(%eax)
  100354:	eb 4c                	jmp    1003a2 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  100356:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10035a:	75 1a                	jne    100376 <readline+0x8f>
  10035c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100360:	7e 14                	jle    100376 <readline+0x8f>
            cputchar(c);
  100362:	83 ec 0c             	sub    $0xc,%esp
  100365:	ff 75 f0             	pushl  -0x10(%ebp)
  100368:	e8 fd fe ff ff       	call   10026a <cputchar>
  10036d:	83 c4 10             	add    $0x10,%esp
            i --;
  100370:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100374:	eb 2c                	jmp    1003a2 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  100376:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10037a:	74 06                	je     100382 <readline+0x9b>
  10037c:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100380:	75 20                	jne    1003a2 <readline+0xbb>
            cputchar(c);
  100382:	83 ec 0c             	sub    $0xc,%esp
  100385:	ff 75 f0             	pushl  -0x10(%ebp)
  100388:	e8 dd fe ff ff       	call   10026a <cputchar>
  10038d:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  100390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100393:	05 c0 ea 10 00       	add    $0x10eac0,%eax
  100398:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  10039b:	b8 c0 ea 10 00       	mov    $0x10eac0,%eax
  1003a0:	eb 05                	jmp    1003a7 <readline+0xc0>
        }
    }
  1003a2:	e9 66 ff ff ff       	jmp    10030d <readline+0x26>
}
  1003a7:	c9                   	leave  
  1003a8:	c3                   	ret    

001003a9 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003a9:	55                   	push   %ebp
  1003aa:	89 e5                	mov    %esp,%ebp
  1003ac:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003af:	a1 c0 ee 10 00       	mov    0x10eec0,%eax
  1003b4:	85 c0                	test   %eax,%eax
  1003b6:	74 02                	je     1003ba <__panic+0x11>
        goto panic_dead;
  1003b8:	eb 5d                	jmp    100417 <__panic+0x6e>
    }
    is_panic = 1;
  1003ba:	c7 05 c0 ee 10 00 01 	movl   $0x1,0x10eec0
  1003c1:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003c4:	8d 45 14             	lea    0x14(%ebp),%eax
  1003c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003ca:	83 ec 04             	sub    $0x4,%esp
  1003cd:	ff 75 0c             	pushl  0xc(%ebp)
  1003d0:	ff 75 08             	pushl  0x8(%ebp)
  1003d3:	68 ea 35 10 00       	push   $0x1035ea
  1003d8:	e8 67 fe ff ff       	call   100244 <cprintf>
  1003dd:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1003e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003e3:	83 ec 08             	sub    $0x8,%esp
  1003e6:	50                   	push   %eax
  1003e7:	ff 75 10             	pushl  0x10(%ebp)
  1003ea:	e8 2c fe ff ff       	call   10021b <vcprintf>
  1003ef:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1003f2:	83 ec 0c             	sub    $0xc,%esp
  1003f5:	68 06 36 10 00       	push   $0x103606
  1003fa:	e8 45 fe ff ff       	call   100244 <cprintf>
  1003ff:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
  100402:	83 ec 0c             	sub    $0xc,%esp
  100405:	68 08 36 10 00       	push   $0x103608
  10040a:	e8 35 fe ff ff       	call   100244 <cprintf>
  10040f:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
  100412:	e8 0b 06 00 00       	call   100a22 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100417:	e8 ac 13 00 00       	call   1017c8 <intr_disable>
    while (1) {
        kmonitor(NULL);
  10041c:	83 ec 0c             	sub    $0xc,%esp
  10041f:	6a 00                	push   $0x0
  100421:	e8 2a 08 00 00       	call   100c50 <kmonitor>
  100426:	83 c4 10             	add    $0x10,%esp
    }
  100429:	eb f1                	jmp    10041c <__panic+0x73>

0010042b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10042b:	55                   	push   %ebp
  10042c:	89 e5                	mov    %esp,%ebp
  10042e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100431:	8d 45 14             	lea    0x14(%ebp),%eax
  100434:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100437:	83 ec 04             	sub    $0x4,%esp
  10043a:	ff 75 0c             	pushl  0xc(%ebp)
  10043d:	ff 75 08             	pushl  0x8(%ebp)
  100440:	68 1a 36 10 00       	push   $0x10361a
  100445:	e8 fa fd ff ff       	call   100244 <cprintf>
  10044a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10044d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100450:	83 ec 08             	sub    $0x8,%esp
  100453:	50                   	push   %eax
  100454:	ff 75 10             	pushl  0x10(%ebp)
  100457:	e8 bf fd ff ff       	call   10021b <vcprintf>
  10045c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10045f:	83 ec 0c             	sub    $0xc,%esp
  100462:	68 06 36 10 00       	push   $0x103606
  100467:	e8 d8 fd ff ff       	call   100244 <cprintf>
  10046c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10046f:	c9                   	leave  
  100470:	c3                   	ret    

00100471 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100471:	55                   	push   %ebp
  100472:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100474:	a1 c0 ee 10 00       	mov    0x10eec0,%eax
}
  100479:	5d                   	pop    %ebp
  10047a:	c3                   	ret    

0010047b <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10047b:	55                   	push   %ebp
  10047c:	89 e5                	mov    %esp,%ebp
  10047e:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100481:	8b 45 0c             	mov    0xc(%ebp),%eax
  100484:	8b 00                	mov    (%eax),%eax
  100486:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100489:	8b 45 10             	mov    0x10(%ebp),%eax
  10048c:	8b 00                	mov    (%eax),%eax
  10048e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100491:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100498:	e9 d2 00 00 00       	jmp    10056f <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  10049d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004a3:	01 d0                	add    %edx,%eax
  1004a5:	89 c2                	mov    %eax,%edx
  1004a7:	c1 ea 1f             	shr    $0x1f,%edx
  1004aa:	01 d0                	add    %edx,%eax
  1004ac:	d1 f8                	sar    %eax
  1004ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004b4:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004b7:	eb 04                	jmp    1004bd <stab_binsearch+0x42>
            m --;
  1004b9:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004c3:	7c 1f                	jl     1004e4 <stab_binsearch+0x69>
  1004c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c8:	89 d0                	mov    %edx,%eax
  1004ca:	01 c0                	add    %eax,%eax
  1004cc:	01 d0                	add    %edx,%eax
  1004ce:	c1 e0 02             	shl    $0x2,%eax
  1004d1:	89 c2                	mov    %eax,%edx
  1004d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1004d6:	01 d0                	add    %edx,%eax
  1004d8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004dc:	0f b6 c0             	movzbl %al,%eax
  1004df:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004e2:	75 d5                	jne    1004b9 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  1004e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ea:	7d 0b                	jge    1004f7 <stab_binsearch+0x7c>
            l = true_m + 1;
  1004ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004ef:	83 c0 01             	add    $0x1,%eax
  1004f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004f5:	eb 78                	jmp    10056f <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004f7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  1004fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100501:	89 d0                	mov    %edx,%eax
  100503:	01 c0                	add    %eax,%eax
  100505:	01 d0                	add    %edx,%eax
  100507:	c1 e0 02             	shl    $0x2,%eax
  10050a:	89 c2                	mov    %eax,%edx
  10050c:	8b 45 08             	mov    0x8(%ebp),%eax
  10050f:	01 d0                	add    %edx,%eax
  100511:	8b 40 08             	mov    0x8(%eax),%eax
  100514:	3b 45 18             	cmp    0x18(%ebp),%eax
  100517:	73 13                	jae    10052c <stab_binsearch+0xb1>
            *region_left = m;
  100519:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10051f:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100521:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100524:	83 c0 01             	add    $0x1,%eax
  100527:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10052a:	eb 43                	jmp    10056f <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10052c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10052f:	89 d0                	mov    %edx,%eax
  100531:	01 c0                	add    %eax,%eax
  100533:	01 d0                	add    %edx,%eax
  100535:	c1 e0 02             	shl    $0x2,%eax
  100538:	89 c2                	mov    %eax,%edx
  10053a:	8b 45 08             	mov    0x8(%ebp),%eax
  10053d:	01 d0                	add    %edx,%eax
  10053f:	8b 40 08             	mov    0x8(%eax),%eax
  100542:	3b 45 18             	cmp    0x18(%ebp),%eax
  100545:	76 16                	jbe    10055d <stab_binsearch+0xe2>
            *region_right = m - 1;
  100547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10054d:	8b 45 10             	mov    0x10(%ebp),%eax
  100550:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100555:	83 e8 01             	sub    $0x1,%eax
  100558:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10055b:	eb 12                	jmp    10056f <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100560:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100563:	89 10                	mov    %edx,(%eax)
            l = m;
  100565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100568:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10056b:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  10056f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100572:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100575:	0f 8e 22 ff ff ff    	jle    10049d <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  10057b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10057f:	75 0f                	jne    100590 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100581:	8b 45 0c             	mov    0xc(%ebp),%eax
  100584:	8b 00                	mov    (%eax),%eax
  100586:	8d 50 ff             	lea    -0x1(%eax),%edx
  100589:	8b 45 10             	mov    0x10(%ebp),%eax
  10058c:	89 10                	mov    %edx,(%eax)
  10058e:	eb 3f                	jmp    1005cf <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100590:	8b 45 10             	mov    0x10(%ebp),%eax
  100593:	8b 00                	mov    (%eax),%eax
  100595:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100598:	eb 04                	jmp    10059e <stab_binsearch+0x123>
  10059a:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10059e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a1:	8b 00                	mov    (%eax),%eax
  1005a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005a6:	7d 1f                	jge    1005c7 <stab_binsearch+0x14c>
  1005a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005ab:	89 d0                	mov    %edx,%eax
  1005ad:	01 c0                	add    %eax,%eax
  1005af:	01 d0                	add    %edx,%eax
  1005b1:	c1 e0 02             	shl    $0x2,%eax
  1005b4:	89 c2                	mov    %eax,%edx
  1005b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b9:	01 d0                	add    %edx,%eax
  1005bb:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005bf:	0f b6 c0             	movzbl %al,%eax
  1005c2:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005c5:	75 d3                	jne    10059a <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005cd:	89 10                	mov    %edx,(%eax)
    }
}
  1005cf:	c9                   	leave  
  1005d0:	c3                   	ret    

001005d1 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005d1:	55                   	push   %ebp
  1005d2:	89 e5                	mov    %esp,%ebp
  1005d4:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005da:	c7 00 38 36 10 00    	movl   $0x103638,(%eax)
    info->eip_line = 0;
  1005e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ed:	c7 40 08 38 36 10 00 	movl   $0x103638,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f7:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  100601:	8b 55 08             	mov    0x8(%ebp),%edx
  100604:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100607:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100611:	c7 45 f4 8c 3e 10 00 	movl   $0x103e8c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100618:	c7 45 f0 ec b6 10 00 	movl   $0x10b6ec,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10061f:	c7 45 ec ed b6 10 00 	movl   $0x10b6ed,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100626:	c7 45 e8 fc d6 10 00 	movl   $0x10d6fc,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10062d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100630:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100633:	76 0d                	jbe    100642 <debuginfo_eip+0x71>
  100635:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100638:	83 e8 01             	sub    $0x1,%eax
  10063b:	0f b6 00             	movzbl (%eax),%eax
  10063e:	84 c0                	test   %al,%al
  100640:	74 0a                	je     10064c <debuginfo_eip+0x7b>
        return -1;
  100642:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100647:	e9 91 02 00 00       	jmp    1008dd <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10064c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100653:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100659:	29 c2                	sub    %eax,%edx
  10065b:	89 d0                	mov    %edx,%eax
  10065d:	c1 f8 02             	sar    $0x2,%eax
  100660:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100666:	83 e8 01             	sub    $0x1,%eax
  100669:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10066c:	ff 75 08             	pushl  0x8(%ebp)
  10066f:	6a 64                	push   $0x64
  100671:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100674:	50                   	push   %eax
  100675:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100678:	50                   	push   %eax
  100679:	ff 75 f4             	pushl  -0xc(%ebp)
  10067c:	e8 fa fd ff ff       	call   10047b <stab_binsearch>
  100681:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  100684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100687:	85 c0                	test   %eax,%eax
  100689:	75 0a                	jne    100695 <debuginfo_eip+0xc4>
        return -1;
  10068b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100690:	e9 48 02 00 00       	jmp    1008dd <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100698:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10069b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10069e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006a1:	ff 75 08             	pushl  0x8(%ebp)
  1006a4:	6a 24                	push   $0x24
  1006a6:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006a9:	50                   	push   %eax
  1006aa:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006ad:	50                   	push   %eax
  1006ae:	ff 75 f4             	pushl  -0xc(%ebp)
  1006b1:	e8 c5 fd ff ff       	call   10047b <stab_binsearch>
  1006b6:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bf:	39 c2                	cmp    %eax,%edx
  1006c1:	7f 7c                	jg     10073f <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c6:	89 c2                	mov    %eax,%edx
  1006c8:	89 d0                	mov    %edx,%eax
  1006ca:	01 c0                	add    %eax,%eax
  1006cc:	01 d0                	add    %edx,%eax
  1006ce:	c1 e0 02             	shl    $0x2,%eax
  1006d1:	89 c2                	mov    %eax,%edx
  1006d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006d6:	01 d0                	add    %edx,%eax
  1006d8:	8b 00                	mov    (%eax),%eax
  1006da:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006e0:	29 d1                	sub    %edx,%ecx
  1006e2:	89 ca                	mov    %ecx,%edx
  1006e4:	39 d0                	cmp    %edx,%eax
  1006e6:	73 22                	jae    10070a <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006eb:	89 c2                	mov    %eax,%edx
  1006ed:	89 d0                	mov    %edx,%eax
  1006ef:	01 c0                	add    %eax,%eax
  1006f1:	01 d0                	add    %edx,%eax
  1006f3:	c1 e0 02             	shl    $0x2,%eax
  1006f6:	89 c2                	mov    %eax,%edx
  1006f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006fb:	01 d0                	add    %edx,%eax
  1006fd:	8b 10                	mov    (%eax),%edx
  1006ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100702:	01 c2                	add    %eax,%edx
  100704:	8b 45 0c             	mov    0xc(%ebp),%eax
  100707:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10070a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10070d:	89 c2                	mov    %eax,%edx
  10070f:	89 d0                	mov    %edx,%eax
  100711:	01 c0                	add    %eax,%eax
  100713:	01 d0                	add    %edx,%eax
  100715:	c1 e0 02             	shl    $0x2,%eax
  100718:	89 c2                	mov    %eax,%edx
  10071a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071d:	01 d0                	add    %edx,%eax
  10071f:	8b 50 08             	mov    0x8(%eax),%edx
  100722:	8b 45 0c             	mov    0xc(%ebp),%eax
  100725:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100728:	8b 45 0c             	mov    0xc(%ebp),%eax
  10072b:	8b 40 10             	mov    0x10(%eax),%eax
  10072e:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100731:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100737:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10073a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10073d:	eb 15                	jmp    100754 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10073f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100742:	8b 55 08             	mov    0x8(%ebp),%edx
  100745:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10074b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  10074e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100751:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100754:	8b 45 0c             	mov    0xc(%ebp),%eax
  100757:	8b 40 08             	mov    0x8(%eax),%eax
  10075a:	83 ec 08             	sub    $0x8,%esp
  10075d:	6a 3a                	push   $0x3a
  10075f:	50                   	push   %eax
  100760:	e8 8c 24 00 00       	call   102bf1 <strfind>
  100765:	83 c4 10             	add    $0x10,%esp
  100768:	89 c2                	mov    %eax,%edx
  10076a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076d:	8b 40 08             	mov    0x8(%eax),%eax
  100770:	29 c2                	sub    %eax,%edx
  100772:	8b 45 0c             	mov    0xc(%ebp),%eax
  100775:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100778:	83 ec 0c             	sub    $0xc,%esp
  10077b:	ff 75 08             	pushl  0x8(%ebp)
  10077e:	6a 44                	push   $0x44
  100780:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100783:	50                   	push   %eax
  100784:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100787:	50                   	push   %eax
  100788:	ff 75 f4             	pushl  -0xc(%ebp)
  10078b:	e8 eb fc ff ff       	call   10047b <stab_binsearch>
  100790:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  100793:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100796:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100799:	39 c2                	cmp    %eax,%edx
  10079b:	7f 24                	jg     1007c1 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  10079d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007a0:	89 c2                	mov    %eax,%edx
  1007a2:	89 d0                	mov    %edx,%eax
  1007a4:	01 c0                	add    %eax,%eax
  1007a6:	01 d0                	add    %edx,%eax
  1007a8:	c1 e0 02             	shl    $0x2,%eax
  1007ab:	89 c2                	mov    %eax,%edx
  1007ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b0:	01 d0                	add    %edx,%eax
  1007b2:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007b6:	0f b7 d0             	movzwl %ax,%edx
  1007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007bc:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007bf:	eb 13                	jmp    1007d4 <debuginfo_eip+0x203>
        return -1;
  1007c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007c6:	e9 12 01 00 00       	jmp    1008dd <debuginfo_eip+0x30c>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ce:	83 e8 01             	sub    $0x1,%eax
  1007d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  1007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007da:	39 c2                	cmp    %eax,%edx
  1007dc:	7c 56                	jl     100834 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e1:	89 c2                	mov    %eax,%edx
  1007e3:	89 d0                	mov    %edx,%eax
  1007e5:	01 c0                	add    %eax,%eax
  1007e7:	01 d0                	add    %edx,%eax
  1007e9:	c1 e0 02             	shl    $0x2,%eax
  1007ec:	89 c2                	mov    %eax,%edx
  1007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f1:	01 d0                	add    %edx,%eax
  1007f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007f7:	3c 84                	cmp    $0x84,%al
  1007f9:	74 39                	je     100834 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1007fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007fe:	89 c2                	mov    %eax,%edx
  100800:	89 d0                	mov    %edx,%eax
  100802:	01 c0                	add    %eax,%eax
  100804:	01 d0                	add    %edx,%eax
  100806:	c1 e0 02             	shl    $0x2,%eax
  100809:	89 c2                	mov    %eax,%edx
  10080b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10080e:	01 d0                	add    %edx,%eax
  100810:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100814:	3c 64                	cmp    $0x64,%al
  100816:	75 b3                	jne    1007cb <debuginfo_eip+0x1fa>
  100818:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10081b:	89 c2                	mov    %eax,%edx
  10081d:	89 d0                	mov    %edx,%eax
  10081f:	01 c0                	add    %eax,%eax
  100821:	01 d0                	add    %edx,%eax
  100823:	c1 e0 02             	shl    $0x2,%eax
  100826:	89 c2                	mov    %eax,%edx
  100828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	8b 40 08             	mov    0x8(%eax),%eax
  100830:	85 c0                	test   %eax,%eax
  100832:	74 97                	je     1007cb <debuginfo_eip+0x1fa>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100834:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10083a:	39 c2                	cmp    %eax,%edx
  10083c:	7c 46                	jl     100884 <debuginfo_eip+0x2b3>
  10083e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100841:	89 c2                	mov    %eax,%edx
  100843:	89 d0                	mov    %edx,%eax
  100845:	01 c0                	add    %eax,%eax
  100847:	01 d0                	add    %edx,%eax
  100849:	c1 e0 02             	shl    $0x2,%eax
  10084c:	89 c2                	mov    %eax,%edx
  10084e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100851:	01 d0                	add    %edx,%eax
  100853:	8b 00                	mov    (%eax),%eax
  100855:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100858:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10085b:	29 d1                	sub    %edx,%ecx
  10085d:	89 ca                	mov    %ecx,%edx
  10085f:	39 d0                	cmp    %edx,%eax
  100861:	73 21                	jae    100884 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100863:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100866:	89 c2                	mov    %eax,%edx
  100868:	89 d0                	mov    %edx,%eax
  10086a:	01 c0                	add    %eax,%eax
  10086c:	01 d0                	add    %edx,%eax
  10086e:	c1 e0 02             	shl    $0x2,%eax
  100871:	89 c2                	mov    %eax,%edx
  100873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100876:	01 d0                	add    %edx,%eax
  100878:	8b 10                	mov    (%eax),%edx
  10087a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10087d:	01 c2                	add    %eax,%edx
  10087f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100882:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100884:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100887:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10088a:	39 c2                	cmp    %eax,%edx
  10088c:	7d 4a                	jge    1008d8 <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  10088e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100891:	83 c0 01             	add    $0x1,%eax
  100894:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100897:	eb 18                	jmp    1008b1 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100899:	8b 45 0c             	mov    0xc(%ebp),%eax
  10089c:	8b 40 14             	mov    0x14(%eax),%eax
  10089f:	8d 50 01             	lea    0x1(%eax),%edx
  1008a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008a5:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008ab:	83 c0 01             	add    $0x1,%eax
  1008ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008b7:	39 c2                	cmp    %eax,%edx
  1008b9:	7d 1d                	jge    1008d8 <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008be:	89 c2                	mov    %eax,%edx
  1008c0:	89 d0                	mov    %edx,%eax
  1008c2:	01 c0                	add    %eax,%eax
  1008c4:	01 d0                	add    %edx,%eax
  1008c6:	c1 e0 02             	shl    $0x2,%eax
  1008c9:	89 c2                	mov    %eax,%edx
  1008cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ce:	01 d0                	add    %edx,%eax
  1008d0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008d4:	3c a0                	cmp    $0xa0,%al
  1008d6:	74 c1                	je     100899 <debuginfo_eip+0x2c8>
        }
    }
    return 0;
  1008d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008dd:	c9                   	leave  
  1008de:	c3                   	ret    

001008df <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008df:	55                   	push   %ebp
  1008e0:	89 e5                	mov    %esp,%ebp
  1008e2:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008e5:	83 ec 0c             	sub    $0xc,%esp
  1008e8:	68 42 36 10 00       	push   $0x103642
  1008ed:	e8 52 f9 ff ff       	call   100244 <cprintf>
  1008f2:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008f5:	83 ec 08             	sub    $0x8,%esp
  1008f8:	68 00 00 10 00       	push   $0x100000
  1008fd:	68 5b 36 10 00       	push   $0x10365b
  100902:	e8 3d f9 ff ff       	call   100244 <cprintf>
  100907:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  10090a:	83 ec 08             	sub    $0x8,%esp
  10090d:	68 0e 35 10 00       	push   $0x10350e
  100912:	68 73 36 10 00       	push   $0x103673
  100917:	e8 28 f9 ff ff       	call   100244 <cprintf>
  10091c:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  10091f:	83 ec 08             	sub    $0x8,%esp
  100922:	68 56 ea 10 00       	push   $0x10ea56
  100927:	68 8b 36 10 00       	push   $0x10368b
  10092c:	e8 13 f9 ff ff       	call   100244 <cprintf>
  100931:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100934:	83 ec 08             	sub    $0x8,%esp
  100937:	68 80 fe 10 00       	push   $0x10fe80
  10093c:	68 a3 36 10 00       	push   $0x1036a3
  100941:	e8 fe f8 ff ff       	call   100244 <cprintf>
  100946:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100949:	b8 80 fe 10 00       	mov    $0x10fe80,%eax
  10094e:	05 ff 03 00 00       	add    $0x3ff,%eax
  100953:	ba 00 00 10 00       	mov    $0x100000,%edx
  100958:	29 d0                	sub    %edx,%eax
  10095a:	99                   	cltd   
  10095b:	c1 ea 16             	shr    $0x16,%edx
  10095e:	01 d0                	add    %edx,%eax
  100960:	c1 f8 0a             	sar    $0xa,%eax
  100963:	83 ec 08             	sub    $0x8,%esp
  100966:	50                   	push   %eax
  100967:	68 bc 36 10 00       	push   $0x1036bc
  10096c:	e8 d3 f8 ff ff       	call   100244 <cprintf>
  100971:	83 c4 10             	add    $0x10,%esp
}
  100974:	c9                   	leave  
  100975:	c3                   	ret    

00100976 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100976:	55                   	push   %ebp
  100977:	89 e5                	mov    %esp,%ebp
  100979:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10097f:	83 ec 08             	sub    $0x8,%esp
  100982:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100985:	50                   	push   %eax
  100986:	ff 75 08             	pushl  0x8(%ebp)
  100989:	e8 43 fc ff ff       	call   1005d1 <debuginfo_eip>
  10098e:	83 c4 10             	add    $0x10,%esp
  100991:	85 c0                	test   %eax,%eax
  100993:	74 15                	je     1009aa <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100995:	83 ec 08             	sub    $0x8,%esp
  100998:	ff 75 08             	pushl  0x8(%ebp)
  10099b:	68 e6 36 10 00       	push   $0x1036e6
  1009a0:	e8 9f f8 ff ff       	call   100244 <cprintf>
  1009a5:	83 c4 10             	add    $0x10,%esp
  1009a8:	eb 65                	jmp    100a0f <print_debuginfo+0x99>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009b1:	eb 1c                	jmp    1009cf <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009b9:	01 d0                	add    %edx,%eax
  1009bb:	0f b6 00             	movzbl (%eax),%eax
  1009be:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009c7:	01 ca                	add    %ecx,%edx
  1009c9:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009d5:	7f dc                	jg     1009b3 <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
  1009d7:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e0:	01 d0                	add    %edx,%eax
  1009e2:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  1009e8:	8b 55 08             	mov    0x8(%ebp),%edx
  1009eb:	89 d1                	mov    %edx,%ecx
  1009ed:	29 c1                	sub    %eax,%ecx
  1009ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1009f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009f5:	83 ec 0c             	sub    $0xc,%esp
  1009f8:	51                   	push   %ecx
  1009f9:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009ff:	51                   	push   %ecx
  100a00:	52                   	push   %edx
  100a01:	50                   	push   %eax
  100a02:	68 02 37 10 00       	push   $0x103702
  100a07:	e8 38 f8 ff ff       	call   100244 <cprintf>
  100a0c:	83 c4 20             	add    $0x20,%esp
    }
}
  100a0f:	c9                   	leave  
  100a10:	c3                   	ret    

00100a11 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a11:	55                   	push   %ebp
  100a12:	89 e5                	mov    %esp,%ebp
  100a14:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a17:	8b 45 04             	mov    0x4(%ebp),%eax
  100a1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a20:	c9                   	leave  
  100a21:	c3                   	ret    

00100a22 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a22:	55                   	push   %ebp
  100a23:	89 e5                	mov    %esp,%ebp
  100a25:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a28:	89 e8                	mov    %ebp,%eax
  100a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a33:	e8 d9 ff ff ff       	call   100a11 <read_eip>
  100a38:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a3b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a42:	e9 8d 00 00 00       	jmp    100ad4 <print_stackframe+0xb2>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100a47:	83 ec 04             	sub    $0x4,%esp
  100a4a:	ff 75 f0             	pushl  -0x10(%ebp)
  100a4d:	ff 75 f4             	pushl  -0xc(%ebp)
  100a50:	68 14 37 10 00       	push   $0x103714
  100a55:	e8 ea f7 ff ff       	call   100244 <cprintf>
  100a5a:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
  100a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a60:	83 c0 08             	add    $0x8,%eax
  100a63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100a66:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a6d:	eb 26                	jmp    100a95 <print_stackframe+0x73>
            cprintf("0x%08x ", args[j]);
  100a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a72:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a7c:	01 d0                	add    %edx,%eax
  100a7e:	8b 00                	mov    (%eax),%eax
  100a80:	83 ec 08             	sub    $0x8,%esp
  100a83:	50                   	push   %eax
  100a84:	68 30 37 10 00       	push   $0x103730
  100a89:	e8 b6 f7 ff ff       	call   100244 <cprintf>
  100a8e:	83 c4 10             	add    $0x10,%esp
        for (j = 0; j < 4; j ++) {
  100a91:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a95:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a99:	7e d4                	jle    100a6f <print_stackframe+0x4d>
        }
        cprintf("\n");
  100a9b:	83 ec 0c             	sub    $0xc,%esp
  100a9e:	68 38 37 10 00       	push   $0x103738
  100aa3:	e8 9c f7 ff ff       	call   100244 <cprintf>
  100aa8:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
  100aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aae:	83 e8 01             	sub    $0x1,%eax
  100ab1:	83 ec 0c             	sub    $0xc,%esp
  100ab4:	50                   	push   %eax
  100ab5:	e8 bc fe ff ff       	call   100976 <print_debuginfo>
  100aba:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
  100abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac0:	83 c0 04             	add    $0x4,%eax
  100ac3:	8b 00                	mov    (%eax),%eax
  100ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100acb:	8b 00                	mov    (%eax),%eax
  100acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100ad0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ad4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ad8:	74 0a                	je     100ae4 <print_stackframe+0xc2>
  100ada:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100ade:	0f 8e 63 ff ff ff    	jle    100a47 <print_stackframe+0x25>
    }
}
  100ae4:	c9                   	leave  
  100ae5:	c3                   	ret    

00100ae6 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100ae6:	55                   	push   %ebp
  100ae7:	89 e5                	mov    %esp,%ebp
  100ae9:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100aec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100af3:	eb 0c                	jmp    100b01 <parse+0x1b>
            *buf ++ = '\0';
  100af5:	8b 45 08             	mov    0x8(%ebp),%eax
  100af8:	8d 50 01             	lea    0x1(%eax),%edx
  100afb:	89 55 08             	mov    %edx,0x8(%ebp)
  100afe:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b01:	8b 45 08             	mov    0x8(%ebp),%eax
  100b04:	0f b6 00             	movzbl (%eax),%eax
  100b07:	84 c0                	test   %al,%al
  100b09:	74 1e                	je     100b29 <parse+0x43>
  100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0e:	0f b6 00             	movzbl (%eax),%eax
  100b11:	0f be c0             	movsbl %al,%eax
  100b14:	83 ec 08             	sub    $0x8,%esp
  100b17:	50                   	push   %eax
  100b18:	68 bc 37 10 00       	push   $0x1037bc
  100b1d:	e8 9c 20 00 00       	call   102bbe <strchr>
  100b22:	83 c4 10             	add    $0x10,%esp
  100b25:	85 c0                	test   %eax,%eax
  100b27:	75 cc                	jne    100af5 <parse+0xf>
        }
        if (*buf == '\0') {
  100b29:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2c:	0f b6 00             	movzbl (%eax),%eax
  100b2f:	84 c0                	test   %al,%al
  100b31:	75 02                	jne    100b35 <parse+0x4f>
            break;
  100b33:	eb 65                	jmp    100b9a <parse+0xb4>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b35:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b39:	75 12                	jne    100b4d <parse+0x67>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b3b:	83 ec 08             	sub    $0x8,%esp
  100b3e:	6a 10                	push   $0x10
  100b40:	68 c1 37 10 00       	push   $0x1037c1
  100b45:	e8 fa f6 ff ff       	call   100244 <cprintf>
  100b4a:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b50:	8d 50 01             	lea    0x1(%eax),%edx
  100b53:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b56:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b60:	01 c2                	add    %eax,%edx
  100b62:	8b 45 08             	mov    0x8(%ebp),%eax
  100b65:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b67:	eb 04                	jmp    100b6d <parse+0x87>
            buf ++;
  100b69:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b70:	0f b6 00             	movzbl (%eax),%eax
  100b73:	84 c0                	test   %al,%al
  100b75:	74 1e                	je     100b95 <parse+0xaf>
  100b77:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7a:	0f b6 00             	movzbl (%eax),%eax
  100b7d:	0f be c0             	movsbl %al,%eax
  100b80:	83 ec 08             	sub    $0x8,%esp
  100b83:	50                   	push   %eax
  100b84:	68 bc 37 10 00       	push   $0x1037bc
  100b89:	e8 30 20 00 00       	call   102bbe <strchr>
  100b8e:	83 c4 10             	add    $0x10,%esp
  100b91:	85 c0                	test   %eax,%eax
  100b93:	74 d4                	je     100b69 <parse+0x83>
        }
    }
  100b95:	e9 59 ff ff ff       	jmp    100af3 <parse+0xd>
    return argc;
  100b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b9d:	c9                   	leave  
  100b9e:	c3                   	ret    

00100b9f <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b9f:	55                   	push   %ebp
  100ba0:	89 e5                	mov    %esp,%ebp
  100ba2:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100ba5:	83 ec 08             	sub    $0x8,%esp
  100ba8:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bab:	50                   	push   %eax
  100bac:	ff 75 08             	pushl  0x8(%ebp)
  100baf:	e8 32 ff ff ff       	call   100ae6 <parse>
  100bb4:	83 c4 10             	add    $0x10,%esp
  100bb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bbe:	75 0a                	jne    100bca <runcmd+0x2b>
        return 0;
  100bc0:	b8 00 00 00 00       	mov    $0x0,%eax
  100bc5:	e9 84 00 00 00       	jmp    100c4e <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bd1:	eb 5a                	jmp    100c2d <runcmd+0x8e>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bd3:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bd9:	89 d0                	mov    %edx,%eax
  100bdb:	01 c0                	add    %eax,%eax
  100bdd:	01 d0                	add    %edx,%eax
  100bdf:	c1 e0 02             	shl    $0x2,%eax
  100be2:	05 00 e0 10 00       	add    $0x10e000,%eax
  100be7:	8b 00                	mov    (%eax),%eax
  100be9:	83 ec 08             	sub    $0x8,%esp
  100bec:	51                   	push   %ecx
  100bed:	50                   	push   %eax
  100bee:	e8 2b 1f 00 00       	call   102b1e <strcmp>
  100bf3:	83 c4 10             	add    $0x10,%esp
  100bf6:	85 c0                	test   %eax,%eax
  100bf8:	75 2f                	jne    100c29 <runcmd+0x8a>
            return commands[i].func(argc - 1, argv + 1, tf);
  100bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bfd:	89 d0                	mov    %edx,%eax
  100bff:	01 c0                	add    %eax,%eax
  100c01:	01 d0                	add    %edx,%eax
  100c03:	c1 e0 02             	shl    $0x2,%eax
  100c06:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c0b:	8b 40 08             	mov    0x8(%eax),%eax
  100c0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100c11:	83 ea 01             	sub    $0x1,%edx
  100c14:	83 ec 04             	sub    $0x4,%esp
  100c17:	ff 75 0c             	pushl  0xc(%ebp)
  100c1a:	8d 4d b0             	lea    -0x50(%ebp),%ecx
  100c1d:	83 c1 04             	add    $0x4,%ecx
  100c20:	51                   	push   %ecx
  100c21:	52                   	push   %edx
  100c22:	ff d0                	call   *%eax
  100c24:	83 c4 10             	add    $0x10,%esp
  100c27:	eb 25                	jmp    100c4e <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c29:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c30:	83 f8 02             	cmp    $0x2,%eax
  100c33:	76 9e                	jbe    100bd3 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c35:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c38:	83 ec 08             	sub    $0x8,%esp
  100c3b:	50                   	push   %eax
  100c3c:	68 df 37 10 00       	push   $0x1037df
  100c41:	e8 fe f5 ff ff       	call   100244 <cprintf>
  100c46:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c4e:	c9                   	leave  
  100c4f:	c3                   	ret    

00100c50 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c50:	55                   	push   %ebp
  100c51:	89 e5                	mov    %esp,%ebp
  100c53:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c56:	83 ec 0c             	sub    $0xc,%esp
  100c59:	68 f8 37 10 00       	push   $0x1037f8
  100c5e:	e8 e1 f5 ff ff       	call   100244 <cprintf>
  100c63:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c66:	83 ec 0c             	sub    $0xc,%esp
  100c69:	68 20 38 10 00       	push   $0x103820
  100c6e:	e8 d1 f5 ff ff       	call   100244 <cprintf>
  100c73:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c7a:	74 0e                	je     100c8a <kmonitor+0x3a>
        print_trapframe(tf);
  100c7c:	83 ec 0c             	sub    $0xc,%esp
  100c7f:	ff 75 08             	pushl  0x8(%ebp)
  100c82:	e8 19 0d 00 00       	call   1019a0 <print_trapframe>
  100c87:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c8a:	83 ec 0c             	sub    $0xc,%esp
  100c8d:	68 45 38 10 00       	push   $0x103845
  100c92:	e8 50 f6 ff ff       	call   1002e7 <readline>
  100c97:	83 c4 10             	add    $0x10,%esp
  100c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ca1:	74 17                	je     100cba <kmonitor+0x6a>
            if (runcmd(buf, tf) < 0) {
  100ca3:	83 ec 08             	sub    $0x8,%esp
  100ca6:	ff 75 08             	pushl  0x8(%ebp)
  100ca9:	ff 75 f4             	pushl  -0xc(%ebp)
  100cac:	e8 ee fe ff ff       	call   100b9f <runcmd>
  100cb1:	83 c4 10             	add    $0x10,%esp
  100cb4:	85 c0                	test   %eax,%eax
  100cb6:	79 02                	jns    100cba <kmonitor+0x6a>
                break;
  100cb8:	eb 02                	jmp    100cbc <kmonitor+0x6c>
            }
        }
    }
  100cba:	eb ce                	jmp    100c8a <kmonitor+0x3a>
}
  100cbc:	c9                   	leave  
  100cbd:	c3                   	ret    

00100cbe <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cbe:	55                   	push   %ebp
  100cbf:	89 e5                	mov    %esp,%ebp
  100cc1:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ccb:	eb 3d                	jmp    100d0a <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cd0:	89 d0                	mov    %edx,%eax
  100cd2:	01 c0                	add    %eax,%eax
  100cd4:	01 d0                	add    %edx,%eax
  100cd6:	c1 e0 02             	shl    $0x2,%eax
  100cd9:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cde:	8b 48 04             	mov    0x4(%eax),%ecx
  100ce1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce4:	89 d0                	mov    %edx,%eax
  100ce6:	01 c0                	add    %eax,%eax
  100ce8:	01 d0                	add    %edx,%eax
  100cea:	c1 e0 02             	shl    $0x2,%eax
  100ced:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cf2:	8b 00                	mov    (%eax),%eax
  100cf4:	83 ec 04             	sub    $0x4,%esp
  100cf7:	51                   	push   %ecx
  100cf8:	50                   	push   %eax
  100cf9:	68 49 38 10 00       	push   $0x103849
  100cfe:	e8 41 f5 ff ff       	call   100244 <cprintf>
  100d03:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100d06:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0d:	83 f8 02             	cmp    $0x2,%eax
  100d10:	76 bb                	jbe    100ccd <mon_help+0xf>
    }
    return 0;
  100d12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d17:	c9                   	leave  
  100d18:	c3                   	ret    

00100d19 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d19:	55                   	push   %ebp
  100d1a:	89 e5                	mov    %esp,%ebp
  100d1c:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d1f:	e8 bb fb ff ff       	call   1008df <print_kerninfo>
    return 0;
  100d24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d29:	c9                   	leave  
  100d2a:	c3                   	ret    

00100d2b <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d2b:	55                   	push   %ebp
  100d2c:	89 e5                	mov    %esp,%ebp
  100d2e:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d31:	e8 ec fc ff ff       	call   100a22 <print_stackframe>
    return 0;
  100d36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d3b:	c9                   	leave  
  100d3c:	c3                   	ret    

00100d3d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d3d:	55                   	push   %ebp
  100d3e:	89 e5                	mov    %esp,%ebp
  100d40:	83 ec 18             	sub    $0x18,%esp
  100d43:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d49:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d4d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d51:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d55:	ee                   	out    %al,(%dx)
  100d56:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d5c:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d60:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d64:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d68:	ee                   	out    %al,(%dx)
  100d69:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d6f:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d73:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d77:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d7b:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d7c:	c7 05 e8 f9 10 00 00 	movl   $0x0,0x10f9e8
  100d83:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d86:	83 ec 0c             	sub    $0xc,%esp
  100d89:	68 52 38 10 00       	push   $0x103852
  100d8e:	e8 b1 f4 ff ff       	call   100244 <cprintf>
  100d93:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d96:	83 ec 0c             	sub    $0xc,%esp
  100d99:	6a 00                	push   $0x0
  100d9b:	e8 ba 08 00 00       	call   10165a <pic_enable>
  100da0:	83 c4 10             	add    $0x10,%esp
}
  100da3:	c9                   	leave  
  100da4:	c3                   	ret    

00100da5 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100da5:	55                   	push   %ebp
  100da6:	89 e5                	mov    %esp,%ebp
  100da8:	83 ec 10             	sub    $0x10,%esp
  100dab:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100db1:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100db5:	89 c2                	mov    %eax,%edx
  100db7:	ec                   	in     (%dx),%al
  100db8:	88 45 fd             	mov    %al,-0x3(%ebp)
  100dbb:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dc1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dc5:	89 c2                	mov    %eax,%edx
  100dc7:	ec                   	in     (%dx),%al
  100dc8:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dcb:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dd1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dd5:	89 c2                	mov    %eax,%edx
  100dd7:	ec                   	in     (%dx),%al
  100dd8:	88 45 f5             	mov    %al,-0xb(%ebp)
  100ddb:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100de1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100de5:	89 c2                	mov    %eax,%edx
  100de7:	ec                   	in     (%dx),%al
  100de8:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100deb:	c9                   	leave  
  100dec:	c3                   	ret    

00100ded <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100ded:	55                   	push   %ebp
  100dee:	89 e5                	mov    %esp,%ebp
  100df0:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100df3:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100dfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dfd:	0f b7 00             	movzwl (%eax),%eax
  100e00:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e07:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e0f:	0f b7 00             	movzwl (%eax),%eax
  100e12:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e16:	74 12                	je     100e2a <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e18:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e1f:	66 c7 05 06 ef 10 00 	movw   $0x3b4,0x10ef06
  100e26:	b4 03 
  100e28:	eb 13                	jmp    100e3d <cga_init+0x50>
    } else {
        *cp = was;
  100e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e31:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e34:	66 c7 05 06 ef 10 00 	movw   $0x3d4,0x10ef06
  100e3b:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e3d:	0f b7 05 06 ef 10 00 	movzwl 0x10ef06,%eax
  100e44:	0f b7 c0             	movzwl %ax,%eax
  100e47:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e4b:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e4f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e53:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e57:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e58:	0f b7 05 06 ef 10 00 	movzwl 0x10ef06,%eax
  100e5f:	83 c0 01             	add    $0x1,%eax
  100e62:	0f b7 c0             	movzwl %ax,%eax
  100e65:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e69:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e6d:	89 c2                	mov    %eax,%edx
  100e6f:	ec                   	in     (%dx),%al
  100e70:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e73:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e77:	0f b6 c0             	movzbl %al,%eax
  100e7a:	c1 e0 08             	shl    $0x8,%eax
  100e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e80:	0f b7 05 06 ef 10 00 	movzwl 0x10ef06,%eax
  100e87:	0f b7 c0             	movzwl %ax,%eax
  100e8a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100e8e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e92:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e96:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e9a:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100e9b:	0f b7 05 06 ef 10 00 	movzwl 0x10ef06,%eax
  100ea2:	83 c0 01             	add    $0x1,%eax
  100ea5:	0f b7 c0             	movzwl %ax,%eax
  100ea8:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eac:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100eb0:	89 c2                	mov    %eax,%edx
  100eb2:	ec                   	in     (%dx),%al
  100eb3:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100eb6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eba:	0f b6 c0             	movzbl %al,%eax
  100ebd:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100ec0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec3:	a3 00 ef 10 00       	mov    %eax,0x10ef00
    crt_pos = pos;
  100ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ecb:	66 a3 04 ef 10 00    	mov    %ax,0x10ef04
}
  100ed1:	c9                   	leave  
  100ed2:	c3                   	ret    

00100ed3 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ed3:	55                   	push   %ebp
  100ed4:	89 e5                	mov    %esp,%ebp
  100ed6:	83 ec 38             	sub    $0x38,%esp
  100ed9:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100edf:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ee3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100ee7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100eeb:	ee                   	out    %al,(%dx)
  100eec:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100ef2:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100ef6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100efa:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100efe:	ee                   	out    %al,(%dx)
  100eff:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f05:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f09:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f0d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f11:	ee                   	out    %al,(%dx)
  100f12:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f18:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f1c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f20:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f24:	ee                   	out    %al,(%dx)
  100f25:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f2b:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f2f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f33:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f37:	ee                   	out    %al,(%dx)
  100f38:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f3e:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f42:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f46:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f4a:	ee                   	out    %al,(%dx)
  100f4b:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f51:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f55:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f59:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f5d:	ee                   	out    %al,(%dx)
  100f5e:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f64:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f68:	89 c2                	mov    %eax,%edx
  100f6a:	ec                   	in     (%dx),%al
  100f6b:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f6e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f72:	3c ff                	cmp    $0xff,%al
  100f74:	0f 95 c0             	setne  %al
  100f77:	0f b6 c0             	movzbl %al,%eax
  100f7a:	a3 08 ef 10 00       	mov    %eax,0x10ef08
  100f7f:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f85:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100f89:	89 c2                	mov    %eax,%edx
  100f8b:	ec                   	in     (%dx),%al
  100f8c:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100f8f:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100f95:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100f99:	89 c2                	mov    %eax,%edx
  100f9b:	ec                   	in     (%dx),%al
  100f9c:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f9f:	a1 08 ef 10 00       	mov    0x10ef08,%eax
  100fa4:	85 c0                	test   %eax,%eax
  100fa6:	74 0d                	je     100fb5 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100fa8:	83 ec 0c             	sub    $0xc,%esp
  100fab:	6a 04                	push   $0x4
  100fad:	e8 a8 06 00 00       	call   10165a <pic_enable>
  100fb2:	83 c4 10             	add    $0x10,%esp
    }
}
  100fb5:	c9                   	leave  
  100fb6:	c3                   	ret    

00100fb7 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fb7:	55                   	push   %ebp
  100fb8:	89 e5                	mov    %esp,%ebp
  100fba:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fc4:	eb 09                	jmp    100fcf <lpt_putc_sub+0x18>
        delay();
  100fc6:	e8 da fd ff ff       	call   100da5 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fcb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fcf:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fd5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fd9:	89 c2                	mov    %eax,%edx
  100fdb:	ec                   	in     (%dx),%al
  100fdc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fdf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fe3:	84 c0                	test   %al,%al
  100fe5:	78 09                	js     100ff0 <lpt_putc_sub+0x39>
  100fe7:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fee:	7e d6                	jle    100fc6 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  100ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  100ff3:	0f b6 c0             	movzbl %al,%eax
  100ff6:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  100ffc:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fff:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101003:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101007:	ee                   	out    %al,(%dx)
  101008:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10100e:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101012:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101016:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10101a:	ee                   	out    %al,(%dx)
  10101b:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101021:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101025:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101029:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10102d:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10102e:	c9                   	leave  
  10102f:	c3                   	ret    

00101030 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101030:	55                   	push   %ebp
  101031:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101033:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101037:	74 0d                	je     101046 <lpt_putc+0x16>
        lpt_putc_sub(c);
  101039:	ff 75 08             	pushl  0x8(%ebp)
  10103c:	e8 76 ff ff ff       	call   100fb7 <lpt_putc_sub>
  101041:	83 c4 04             	add    $0x4,%esp
  101044:	eb 1e                	jmp    101064 <lpt_putc+0x34>
    }
    else {
        lpt_putc_sub('\b');
  101046:	6a 08                	push   $0x8
  101048:	e8 6a ff ff ff       	call   100fb7 <lpt_putc_sub>
  10104d:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  101050:	6a 20                	push   $0x20
  101052:	e8 60 ff ff ff       	call   100fb7 <lpt_putc_sub>
  101057:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  10105a:	6a 08                	push   $0x8
  10105c:	e8 56 ff ff ff       	call   100fb7 <lpt_putc_sub>
  101061:	83 c4 04             	add    $0x4,%esp
    }
}
  101064:	c9                   	leave  
  101065:	c3                   	ret    

00101066 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101066:	55                   	push   %ebp
  101067:	89 e5                	mov    %esp,%ebp
  101069:	53                   	push   %ebx
  10106a:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10106d:	8b 45 08             	mov    0x8(%ebp),%eax
  101070:	b0 00                	mov    $0x0,%al
  101072:	85 c0                	test   %eax,%eax
  101074:	75 07                	jne    10107d <cga_putc+0x17>
        c |= 0x0700;
  101076:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10107d:	8b 45 08             	mov    0x8(%ebp),%eax
  101080:	0f b6 c0             	movzbl %al,%eax
  101083:	83 f8 0a             	cmp    $0xa,%eax
  101086:	74 4c                	je     1010d4 <cga_putc+0x6e>
  101088:	83 f8 0d             	cmp    $0xd,%eax
  10108b:	74 57                	je     1010e4 <cga_putc+0x7e>
  10108d:	83 f8 08             	cmp    $0x8,%eax
  101090:	0f 85 88 00 00 00    	jne    10111e <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101096:	0f b7 05 04 ef 10 00 	movzwl 0x10ef04,%eax
  10109d:	66 85 c0             	test   %ax,%ax
  1010a0:	74 30                	je     1010d2 <cga_putc+0x6c>
            crt_pos --;
  1010a2:	0f b7 05 04 ef 10 00 	movzwl 0x10ef04,%eax
  1010a9:	83 e8 01             	sub    $0x1,%eax
  1010ac:	66 a3 04 ef 10 00    	mov    %ax,0x10ef04
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010b2:	a1 00 ef 10 00       	mov    0x10ef00,%eax
  1010b7:	0f b7 15 04 ef 10 00 	movzwl 0x10ef04,%edx
  1010be:	0f b7 d2             	movzwl %dx,%edx
  1010c1:	01 d2                	add    %edx,%edx
  1010c3:	01 d0                	add    %edx,%eax
  1010c5:	8b 55 08             	mov    0x8(%ebp),%edx
  1010c8:	b2 00                	mov    $0x0,%dl
  1010ca:	83 ca 20             	or     $0x20,%edx
  1010cd:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010d0:	eb 71                	jmp    101143 <cga_putc+0xdd>
  1010d2:	eb 6f                	jmp    101143 <cga_putc+0xdd>
    case '\n':
        crt_pos += CRT_COLS;
  1010d4:	0f b7 05 04 ef 10 00 	movzwl 0x10ef04,%eax
  1010db:	83 c0 50             	add    $0x50,%eax
  1010de:	66 a3 04 ef 10 00    	mov    %ax,0x10ef04
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010e4:	0f b7 1d 04 ef 10 00 	movzwl 0x10ef04,%ebx
  1010eb:	0f b7 0d 04 ef 10 00 	movzwl 0x10ef04,%ecx
  1010f2:	0f b7 c1             	movzwl %cx,%eax
  1010f5:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1010fb:	c1 e8 10             	shr    $0x10,%eax
  1010fe:	89 c2                	mov    %eax,%edx
  101100:	66 c1 ea 06          	shr    $0x6,%dx
  101104:	89 d0                	mov    %edx,%eax
  101106:	c1 e0 02             	shl    $0x2,%eax
  101109:	01 d0                	add    %edx,%eax
  10110b:	c1 e0 04             	shl    $0x4,%eax
  10110e:	29 c1                	sub    %eax,%ecx
  101110:	89 ca                	mov    %ecx,%edx
  101112:	89 d8                	mov    %ebx,%eax
  101114:	29 d0                	sub    %edx,%eax
  101116:	66 a3 04 ef 10 00    	mov    %ax,0x10ef04
        break;
  10111c:	eb 25                	jmp    101143 <cga_putc+0xdd>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10111e:	8b 0d 00 ef 10 00    	mov    0x10ef00,%ecx
  101124:	0f b7 05 04 ef 10 00 	movzwl 0x10ef04,%eax
  10112b:	8d 50 01             	lea    0x1(%eax),%edx
  10112e:	66 89 15 04 ef 10 00 	mov    %dx,0x10ef04
  101135:	0f b7 c0             	movzwl %ax,%eax
  101138:	01 c0                	add    %eax,%eax
  10113a:	01 c8                	add    %ecx,%eax
  10113c:	8b 55 08             	mov    0x8(%ebp),%edx
  10113f:	66 89 10             	mov    %dx,(%eax)
        break;
  101142:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101143:	0f b7 05 04 ef 10 00 	movzwl 0x10ef04,%eax
  10114a:	66 3d cf 07          	cmp    $0x7cf,%ax
  10114e:	76 59                	jbe    1011a9 <cga_putc+0x143>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101150:	a1 00 ef 10 00       	mov    0x10ef00,%eax
  101155:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10115b:	a1 00 ef 10 00       	mov    0x10ef00,%eax
  101160:	83 ec 04             	sub    $0x4,%esp
  101163:	68 00 0f 00 00       	push   $0xf00
  101168:	52                   	push   %edx
  101169:	50                   	push   %eax
  10116a:	e8 4e 1c 00 00       	call   102dbd <memmove>
  10116f:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101172:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101179:	eb 15                	jmp    101190 <cga_putc+0x12a>
            crt_buf[i] = 0x0700 | ' ';
  10117b:	a1 00 ef 10 00       	mov    0x10ef00,%eax
  101180:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101183:	01 d2                	add    %edx,%edx
  101185:	01 d0                	add    %edx,%eax
  101187:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10118c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101190:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101197:	7e e2                	jle    10117b <cga_putc+0x115>
        }
        crt_pos -= CRT_COLS;
  101199:	0f b7 05 04 ef 10 00 	movzwl 0x10ef04,%eax
  1011a0:	83 e8 50             	sub    $0x50,%eax
  1011a3:	66 a3 04 ef 10 00    	mov    %ax,0x10ef04
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011a9:	0f b7 05 06 ef 10 00 	movzwl 0x10ef06,%eax
  1011b0:	0f b7 c0             	movzwl %ax,%eax
  1011b3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011b7:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011bb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011bf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011c3:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011c4:	0f b7 05 04 ef 10 00 	movzwl 0x10ef04,%eax
  1011cb:	66 c1 e8 08          	shr    $0x8,%ax
  1011cf:	0f b6 c0             	movzbl %al,%eax
  1011d2:	0f b7 15 06 ef 10 00 	movzwl 0x10ef06,%edx
  1011d9:	83 c2 01             	add    $0x1,%edx
  1011dc:	0f b7 d2             	movzwl %dx,%edx
  1011df:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1011e3:	88 45 ed             	mov    %al,-0x13(%ebp)
  1011e6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1011ea:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1011ee:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011ef:	0f b7 05 06 ef 10 00 	movzwl 0x10ef06,%eax
  1011f6:	0f b7 c0             	movzwl %ax,%eax
  1011f9:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1011fd:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101201:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101205:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101209:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10120a:	0f b7 05 04 ef 10 00 	movzwl 0x10ef04,%eax
  101211:	0f b6 c0             	movzbl %al,%eax
  101214:	0f b7 15 06 ef 10 00 	movzwl 0x10ef06,%edx
  10121b:	83 c2 01             	add    $0x1,%edx
  10121e:	0f b7 d2             	movzwl %dx,%edx
  101221:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101225:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101228:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10122c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101230:	ee                   	out    %al,(%dx)
}
  101231:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101234:	c9                   	leave  
  101235:	c3                   	ret    

00101236 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101236:	55                   	push   %ebp
  101237:	89 e5                	mov    %esp,%ebp
  101239:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10123c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101243:	eb 09                	jmp    10124e <serial_putc_sub+0x18>
        delay();
  101245:	e8 5b fb ff ff       	call   100da5 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10124a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10124e:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101254:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101258:	89 c2                	mov    %eax,%edx
  10125a:	ec                   	in     (%dx),%al
  10125b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10125e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101262:	0f b6 c0             	movzbl %al,%eax
  101265:	83 e0 20             	and    $0x20,%eax
  101268:	85 c0                	test   %eax,%eax
  10126a:	75 09                	jne    101275 <serial_putc_sub+0x3f>
  10126c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101273:	7e d0                	jle    101245 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101275:	8b 45 08             	mov    0x8(%ebp),%eax
  101278:	0f b6 c0             	movzbl %al,%eax
  10127b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101281:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101284:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101288:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10128c:	ee                   	out    %al,(%dx)
}
  10128d:	c9                   	leave  
  10128e:	c3                   	ret    

0010128f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10128f:	55                   	push   %ebp
  101290:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101292:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101296:	74 0d                	je     1012a5 <serial_putc+0x16>
        serial_putc_sub(c);
  101298:	ff 75 08             	pushl  0x8(%ebp)
  10129b:	e8 96 ff ff ff       	call   101236 <serial_putc_sub>
  1012a0:	83 c4 04             	add    $0x4,%esp
  1012a3:	eb 1e                	jmp    1012c3 <serial_putc+0x34>
    }
    else {
        serial_putc_sub('\b');
  1012a5:	6a 08                	push   $0x8
  1012a7:	e8 8a ff ff ff       	call   101236 <serial_putc_sub>
  1012ac:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012af:	6a 20                	push   $0x20
  1012b1:	e8 80 ff ff ff       	call   101236 <serial_putc_sub>
  1012b6:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012b9:	6a 08                	push   $0x8
  1012bb:	e8 76 ff ff ff       	call   101236 <serial_putc_sub>
  1012c0:	83 c4 04             	add    $0x4,%esp
    }
}
  1012c3:	c9                   	leave  
  1012c4:	c3                   	ret    

001012c5 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012c5:	55                   	push   %ebp
  1012c6:	89 e5                	mov    %esp,%ebp
  1012c8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012cb:	eb 33                	jmp    101300 <cons_intr+0x3b>
        if (c != 0) {
  1012cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012d1:	74 2d                	je     101300 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012d3:	a1 44 f1 10 00       	mov    0x10f144,%eax
  1012d8:	8d 50 01             	lea    0x1(%eax),%edx
  1012db:	89 15 44 f1 10 00    	mov    %edx,0x10f144
  1012e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012e4:	88 90 40 ef 10 00    	mov    %dl,0x10ef40(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012ea:	a1 44 f1 10 00       	mov    0x10f144,%eax
  1012ef:	3d 00 02 00 00       	cmp    $0x200,%eax
  1012f4:	75 0a                	jne    101300 <cons_intr+0x3b>
                cons.wpos = 0;
  1012f6:	c7 05 44 f1 10 00 00 	movl   $0x0,0x10f144
  1012fd:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101300:	8b 45 08             	mov    0x8(%ebp),%eax
  101303:	ff d0                	call   *%eax
  101305:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101308:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10130c:	75 bf                	jne    1012cd <cons_intr+0x8>
            }
        }
    }
}
  10130e:	c9                   	leave  
  10130f:	c3                   	ret    

00101310 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101310:	55                   	push   %ebp
  101311:	89 e5                	mov    %esp,%ebp
  101313:	83 ec 10             	sub    $0x10,%esp
  101316:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10131c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101320:	89 c2                	mov    %eax,%edx
  101322:	ec                   	in     (%dx),%al
  101323:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101326:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10132a:	0f b6 c0             	movzbl %al,%eax
  10132d:	83 e0 01             	and    $0x1,%eax
  101330:	85 c0                	test   %eax,%eax
  101332:	75 07                	jne    10133b <serial_proc_data+0x2b>
        return -1;
  101334:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101339:	eb 2a                	jmp    101365 <serial_proc_data+0x55>
  10133b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101341:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101345:	89 c2                	mov    %eax,%edx
  101347:	ec                   	in     (%dx),%al
  101348:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10134b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10134f:	0f b6 c0             	movzbl %al,%eax
  101352:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101355:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101359:	75 07                	jne    101362 <serial_proc_data+0x52>
        c = '\b';
  10135b:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101362:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101365:	c9                   	leave  
  101366:	c3                   	ret    

00101367 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101367:	55                   	push   %ebp
  101368:	89 e5                	mov    %esp,%ebp
  10136a:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  10136d:	a1 08 ef 10 00       	mov    0x10ef08,%eax
  101372:	85 c0                	test   %eax,%eax
  101374:	74 10                	je     101386 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101376:	83 ec 0c             	sub    $0xc,%esp
  101379:	68 10 13 10 00       	push   $0x101310
  10137e:	e8 42 ff ff ff       	call   1012c5 <cons_intr>
  101383:	83 c4 10             	add    $0x10,%esp
    }
}
  101386:	c9                   	leave  
  101387:	c3                   	ret    

00101388 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101388:	55                   	push   %ebp
  101389:	89 e5                	mov    %esp,%ebp
  10138b:	83 ec 28             	sub    $0x28,%esp
  10138e:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101394:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101398:	89 c2                	mov    %eax,%edx
  10139a:	ec                   	in     (%dx),%al
  10139b:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10139e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013a2:	0f b6 c0             	movzbl %al,%eax
  1013a5:	83 e0 01             	and    $0x1,%eax
  1013a8:	85 c0                	test   %eax,%eax
  1013aa:	75 0a                	jne    1013b6 <kbd_proc_data+0x2e>
        return -1;
  1013ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013b1:	e9 5d 01 00 00       	jmp    101513 <kbd_proc_data+0x18b>
  1013b6:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013c0:	89 c2                	mov    %eax,%edx
  1013c2:	ec                   	in     (%dx),%al
  1013c3:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013c6:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013ca:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013cd:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013d1:	75 17                	jne    1013ea <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013d3:	a1 48 f1 10 00       	mov    0x10f148,%eax
  1013d8:	83 c8 40             	or     $0x40,%eax
  1013db:	a3 48 f1 10 00       	mov    %eax,0x10f148
        return 0;
  1013e0:	b8 00 00 00 00       	mov    $0x0,%eax
  1013e5:	e9 29 01 00 00       	jmp    101513 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  1013ea:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013ee:	84 c0                	test   %al,%al
  1013f0:	79 47                	jns    101439 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1013f2:	a1 48 f1 10 00       	mov    0x10f148,%eax
  1013f7:	83 e0 40             	and    $0x40,%eax
  1013fa:	85 c0                	test   %eax,%eax
  1013fc:	75 09                	jne    101407 <kbd_proc_data+0x7f>
  1013fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101402:	83 e0 7f             	and    $0x7f,%eax
  101405:	eb 04                	jmp    10140b <kbd_proc_data+0x83>
  101407:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10140b:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10140e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101412:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101419:	83 c8 40             	or     $0x40,%eax
  10141c:	0f b6 c0             	movzbl %al,%eax
  10141f:	f7 d0                	not    %eax
  101421:	89 c2                	mov    %eax,%edx
  101423:	a1 48 f1 10 00       	mov    0x10f148,%eax
  101428:	21 d0                	and    %edx,%eax
  10142a:	a3 48 f1 10 00       	mov    %eax,0x10f148
        return 0;
  10142f:	b8 00 00 00 00       	mov    $0x0,%eax
  101434:	e9 da 00 00 00       	jmp    101513 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  101439:	a1 48 f1 10 00       	mov    0x10f148,%eax
  10143e:	83 e0 40             	and    $0x40,%eax
  101441:	85 c0                	test   %eax,%eax
  101443:	74 11                	je     101456 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101445:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101449:	a1 48 f1 10 00       	mov    0x10f148,%eax
  10144e:	83 e0 bf             	and    $0xffffffbf,%eax
  101451:	a3 48 f1 10 00       	mov    %eax,0x10f148
    }

    shift |= shiftcode[data];
  101456:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10145a:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101461:	0f b6 d0             	movzbl %al,%edx
  101464:	a1 48 f1 10 00       	mov    0x10f148,%eax
  101469:	09 d0                	or     %edx,%eax
  10146b:	a3 48 f1 10 00       	mov    %eax,0x10f148
    shift ^= togglecode[data];
  101470:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101474:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  10147b:	0f b6 d0             	movzbl %al,%edx
  10147e:	a1 48 f1 10 00       	mov    0x10f148,%eax
  101483:	31 d0                	xor    %edx,%eax
  101485:	a3 48 f1 10 00       	mov    %eax,0x10f148

    c = charcode[shift & (CTL | SHIFT)][data];
  10148a:	a1 48 f1 10 00       	mov    0x10f148,%eax
  10148f:	83 e0 03             	and    $0x3,%eax
  101492:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  101499:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149d:	01 d0                	add    %edx,%eax
  10149f:	0f b6 00             	movzbl (%eax),%eax
  1014a2:	0f b6 c0             	movzbl %al,%eax
  1014a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014a8:	a1 48 f1 10 00       	mov    0x10f148,%eax
  1014ad:	83 e0 08             	and    $0x8,%eax
  1014b0:	85 c0                	test   %eax,%eax
  1014b2:	74 22                	je     1014d6 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014b4:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014b8:	7e 0c                	jle    1014c6 <kbd_proc_data+0x13e>
  1014ba:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014be:	7f 06                	jg     1014c6 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014c0:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014c4:	eb 10                	jmp    1014d6 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014c6:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014ca:	7e 0a                	jle    1014d6 <kbd_proc_data+0x14e>
  1014cc:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014d0:	7f 04                	jg     1014d6 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014d2:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014d6:	a1 48 f1 10 00       	mov    0x10f148,%eax
  1014db:	f7 d0                	not    %eax
  1014dd:	83 e0 06             	and    $0x6,%eax
  1014e0:	85 c0                	test   %eax,%eax
  1014e2:	75 2c                	jne    101510 <kbd_proc_data+0x188>
  1014e4:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014eb:	75 23                	jne    101510 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  1014ed:	83 ec 0c             	sub    $0xc,%esp
  1014f0:	68 6d 38 10 00       	push   $0x10386d
  1014f5:	e8 4a ed ff ff       	call   100244 <cprintf>
  1014fa:	83 c4 10             	add    $0x10,%esp
  1014fd:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101503:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101507:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10150b:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10150f:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101510:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101513:	c9                   	leave  
  101514:	c3                   	ret    

00101515 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101515:	55                   	push   %ebp
  101516:	89 e5                	mov    %esp,%ebp
  101518:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10151b:	83 ec 0c             	sub    $0xc,%esp
  10151e:	68 88 13 10 00       	push   $0x101388
  101523:	e8 9d fd ff ff       	call   1012c5 <cons_intr>
  101528:	83 c4 10             	add    $0x10,%esp
}
  10152b:	c9                   	leave  
  10152c:	c3                   	ret    

0010152d <kbd_init>:

static void
kbd_init(void) {
  10152d:	55                   	push   %ebp
  10152e:	89 e5                	mov    %esp,%ebp
  101530:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101533:	e8 dd ff ff ff       	call   101515 <kbd_intr>
    pic_enable(IRQ_KBD);
  101538:	83 ec 0c             	sub    $0xc,%esp
  10153b:	6a 01                	push   $0x1
  10153d:	e8 18 01 00 00       	call   10165a <pic_enable>
  101542:	83 c4 10             	add    $0x10,%esp
}
  101545:	c9                   	leave  
  101546:	c3                   	ret    

00101547 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101547:	55                   	push   %ebp
  101548:	89 e5                	mov    %esp,%ebp
  10154a:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  10154d:	e8 9b f8 ff ff       	call   100ded <cga_init>
    serial_init();
  101552:	e8 7c f9 ff ff       	call   100ed3 <serial_init>
    kbd_init();
  101557:	e8 d1 ff ff ff       	call   10152d <kbd_init>
    if (!serial_exists) {
  10155c:	a1 08 ef 10 00       	mov    0x10ef08,%eax
  101561:	85 c0                	test   %eax,%eax
  101563:	75 10                	jne    101575 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101565:	83 ec 0c             	sub    $0xc,%esp
  101568:	68 79 38 10 00       	push   $0x103879
  10156d:	e8 d2 ec ff ff       	call   100244 <cprintf>
  101572:	83 c4 10             	add    $0x10,%esp
    }
}
  101575:	c9                   	leave  
  101576:	c3                   	ret    

00101577 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101577:	55                   	push   %ebp
  101578:	89 e5                	mov    %esp,%ebp
  10157a:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  10157d:	ff 75 08             	pushl  0x8(%ebp)
  101580:	e8 ab fa ff ff       	call   101030 <lpt_putc>
  101585:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  101588:	83 ec 0c             	sub    $0xc,%esp
  10158b:	ff 75 08             	pushl  0x8(%ebp)
  10158e:	e8 d3 fa ff ff       	call   101066 <cga_putc>
  101593:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  101596:	83 ec 0c             	sub    $0xc,%esp
  101599:	ff 75 08             	pushl  0x8(%ebp)
  10159c:	e8 ee fc ff ff       	call   10128f <serial_putc>
  1015a1:	83 c4 10             	add    $0x10,%esp
}
  1015a4:	c9                   	leave  
  1015a5:	c3                   	ret    

001015a6 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015a6:	55                   	push   %ebp
  1015a7:	89 e5                	mov    %esp,%ebp
  1015a9:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015ac:	e8 b6 fd ff ff       	call   101367 <serial_intr>
    kbd_intr();
  1015b1:	e8 5f ff ff ff       	call   101515 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015b6:	8b 15 40 f1 10 00    	mov    0x10f140,%edx
  1015bc:	a1 44 f1 10 00       	mov    0x10f144,%eax
  1015c1:	39 c2                	cmp    %eax,%edx
  1015c3:	74 36                	je     1015fb <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015c5:	a1 40 f1 10 00       	mov    0x10f140,%eax
  1015ca:	8d 50 01             	lea    0x1(%eax),%edx
  1015cd:	89 15 40 f1 10 00    	mov    %edx,0x10f140
  1015d3:	0f b6 80 40 ef 10 00 	movzbl 0x10ef40(%eax),%eax
  1015da:	0f b6 c0             	movzbl %al,%eax
  1015dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015e0:	a1 40 f1 10 00       	mov    0x10f140,%eax
  1015e5:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015ea:	75 0a                	jne    1015f6 <cons_getc+0x50>
            cons.rpos = 0;
  1015ec:	c7 05 40 f1 10 00 00 	movl   $0x0,0x10f140
  1015f3:	00 00 00 
        }
        return c;
  1015f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015f9:	eb 05                	jmp    101600 <cons_getc+0x5a>
    }
    return 0;
  1015fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101600:	c9                   	leave  
  101601:	c3                   	ret    

00101602 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101602:	55                   	push   %ebp
  101603:	89 e5                	mov    %esp,%ebp
  101605:	83 ec 14             	sub    $0x14,%esp
  101608:	8b 45 08             	mov    0x8(%ebp),%eax
  10160b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10160f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101613:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101619:	a1 4c f1 10 00       	mov    0x10f14c,%eax
  10161e:	85 c0                	test   %eax,%eax
  101620:	74 36                	je     101658 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101622:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101626:	0f b6 c0             	movzbl %al,%eax
  101629:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10162f:	88 45 fd             	mov    %al,-0x3(%ebp)
  101632:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101636:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10163a:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10163b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163f:	66 c1 e8 08          	shr    $0x8,%ax
  101643:	0f b6 c0             	movzbl %al,%eax
  101646:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10164c:	88 45 f9             	mov    %al,-0x7(%ebp)
  10164f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101653:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101657:	ee                   	out    %al,(%dx)
    }
}
  101658:	c9                   	leave  
  101659:	c3                   	ret    

0010165a <pic_enable>:

void
pic_enable(unsigned int irq) {
  10165a:	55                   	push   %ebp
  10165b:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  10165d:	8b 45 08             	mov    0x8(%ebp),%eax
  101660:	ba 01 00 00 00       	mov    $0x1,%edx
  101665:	89 c1                	mov    %eax,%ecx
  101667:	d3 e2                	shl    %cl,%edx
  101669:	89 d0                	mov    %edx,%eax
  10166b:	f7 d0                	not    %eax
  10166d:	89 c2                	mov    %eax,%edx
  10166f:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101676:	21 d0                	and    %edx,%eax
  101678:	0f b7 c0             	movzwl %ax,%eax
  10167b:	50                   	push   %eax
  10167c:	e8 81 ff ff ff       	call   101602 <pic_setmask>
  101681:	83 c4 04             	add    $0x4,%esp
}
  101684:	c9                   	leave  
  101685:	c3                   	ret    

00101686 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101686:	55                   	push   %ebp
  101687:	89 e5                	mov    %esp,%ebp
  101689:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  10168c:	c7 05 4c f1 10 00 01 	movl   $0x1,0x10f14c
  101693:	00 00 00 
  101696:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10169c:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016a0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016a4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016a8:	ee                   	out    %al,(%dx)
  1016a9:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016af:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016b3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016b7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016bb:	ee                   	out    %al,(%dx)
  1016bc:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016c2:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016c6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016ca:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016ce:	ee                   	out    %al,(%dx)
  1016cf:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016d5:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1016d9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016dd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1016e1:	ee                   	out    %al,(%dx)
  1016e2:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1016e8:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1016ec:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1016f0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1016f4:	ee                   	out    %al,(%dx)
  1016f5:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1016fb:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1016ff:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101703:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101707:	ee                   	out    %al,(%dx)
  101708:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10170e:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101712:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101716:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10171a:	ee                   	out    %al,(%dx)
  10171b:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101721:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101725:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101729:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10172d:	ee                   	out    %al,(%dx)
  10172e:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101734:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101738:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10173c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101740:	ee                   	out    %al,(%dx)
  101741:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101747:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10174b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10174f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101753:	ee                   	out    %al,(%dx)
  101754:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10175a:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10175e:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101762:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101766:	ee                   	out    %al,(%dx)
  101767:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10176d:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101771:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101775:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101779:	ee                   	out    %al,(%dx)
  10177a:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101780:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101784:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101788:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10178c:	ee                   	out    %al,(%dx)
  10178d:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101793:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101797:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10179b:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10179f:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017a0:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017a7:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017ab:	74 13                	je     1017c0 <pic_init+0x13a>
        pic_setmask(irq_mask);
  1017ad:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017b4:	0f b7 c0             	movzwl %ax,%eax
  1017b7:	50                   	push   %eax
  1017b8:	e8 45 fe ff ff       	call   101602 <pic_setmask>
  1017bd:	83 c4 04             	add    $0x4,%esp
    }
}
  1017c0:	c9                   	leave  
  1017c1:	c3                   	ret    

001017c2 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017c2:	55                   	push   %ebp
  1017c3:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017c5:	fb                   	sti    
    sti();
}
  1017c6:	5d                   	pop    %ebp
  1017c7:	c3                   	ret    

001017c8 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017c8:	55                   	push   %ebp
  1017c9:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017cb:	fa                   	cli    
    cli();
}
  1017cc:	5d                   	pop    %ebp
  1017cd:	c3                   	ret    

001017ce <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  1017ce:	55                   	push   %ebp
  1017cf:	89 e5                	mov    %esp,%ebp
  1017d1:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017d4:	83 ec 08             	sub    $0x8,%esp
  1017d7:	6a 64                	push   $0x64
  1017d9:	68 c0 38 10 00       	push   $0x1038c0
  1017de:	e8 61 ea ff ff       	call   100244 <cprintf>
  1017e3:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017e6:	c9                   	leave  
  1017e7:	c3                   	ret    

001017e8 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017e8:	55                   	push   %ebp
  1017e9:	89 e5                	mov    %esp,%ebp
  1017eb:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1017ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1017f5:	e9 c3 00 00 00       	jmp    1018bd <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1017fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017fd:	8b 04 85 20 e6 10 00 	mov    0x10e620(,%eax,4),%eax
  101804:	89 c2                	mov    %eax,%edx
  101806:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101809:	66 89 14 c5 80 f1 10 	mov    %dx,0x10f180(,%eax,8)
  101810:	00 
  101811:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101814:	66 c7 04 c5 82 f1 10 	movw   $0x8,0x10f182(,%eax,8)
  10181b:	00 08 00 
  10181e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101821:	0f b6 14 c5 84 f1 10 	movzbl 0x10f184(,%eax,8),%edx
  101828:	00 
  101829:	83 e2 e0             	and    $0xffffffe0,%edx
  10182c:	88 14 c5 84 f1 10 00 	mov    %dl,0x10f184(,%eax,8)
  101833:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101836:	0f b6 14 c5 84 f1 10 	movzbl 0x10f184(,%eax,8),%edx
  10183d:	00 
  10183e:	83 e2 1f             	and    $0x1f,%edx
  101841:	88 14 c5 84 f1 10 00 	mov    %dl,0x10f184(,%eax,8)
  101848:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184b:	0f b6 14 c5 85 f1 10 	movzbl 0x10f185(,%eax,8),%edx
  101852:	00 
  101853:	83 e2 f0             	and    $0xfffffff0,%edx
  101856:	83 ca 0e             	or     $0xe,%edx
  101859:	88 14 c5 85 f1 10 00 	mov    %dl,0x10f185(,%eax,8)
  101860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101863:	0f b6 14 c5 85 f1 10 	movzbl 0x10f185(,%eax,8),%edx
  10186a:	00 
  10186b:	83 e2 ef             	and    $0xffffffef,%edx
  10186e:	88 14 c5 85 f1 10 00 	mov    %dl,0x10f185(,%eax,8)
  101875:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101878:	0f b6 14 c5 85 f1 10 	movzbl 0x10f185(,%eax,8),%edx
  10187f:	00 
  101880:	83 e2 9f             	and    $0xffffff9f,%edx
  101883:	88 14 c5 85 f1 10 00 	mov    %dl,0x10f185(,%eax,8)
  10188a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188d:	0f b6 14 c5 85 f1 10 	movzbl 0x10f185(,%eax,8),%edx
  101894:	00 
  101895:	83 ca 80             	or     $0xffffff80,%edx
  101898:	88 14 c5 85 f1 10 00 	mov    %dl,0x10f185(,%eax,8)
  10189f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a2:	8b 04 85 20 e6 10 00 	mov    0x10e620(,%eax,4),%eax
  1018a9:	c1 e8 10             	shr    $0x10,%eax
  1018ac:	89 c2                	mov    %eax,%edx
  1018ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b1:	66 89 14 c5 86 f1 10 	mov    %dx,0x10f186(,%eax,8)
  1018b8:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018b9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  1018c5:	0f 86 2f ff ff ff    	jbe    1017fa <idt_init+0x12>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1018cb:	a1 04 e8 10 00       	mov    0x10e804,%eax
  1018d0:	66 a3 48 f5 10 00    	mov    %ax,0x10f548
  1018d6:	66 c7 05 4a f5 10 00 	movw   $0x8,0x10f54a
  1018dd:	08 00 
  1018df:	0f b6 05 4c f5 10 00 	movzbl 0x10f54c,%eax
  1018e6:	83 e0 e0             	and    $0xffffffe0,%eax
  1018e9:	a2 4c f5 10 00       	mov    %al,0x10f54c
  1018ee:	0f b6 05 4c f5 10 00 	movzbl 0x10f54c,%eax
  1018f5:	83 e0 1f             	and    $0x1f,%eax
  1018f8:	a2 4c f5 10 00       	mov    %al,0x10f54c
  1018fd:	0f b6 05 4d f5 10 00 	movzbl 0x10f54d,%eax
  101904:	83 e0 f0             	and    $0xfffffff0,%eax
  101907:	83 c8 0e             	or     $0xe,%eax
  10190a:	a2 4d f5 10 00       	mov    %al,0x10f54d
  10190f:	0f b6 05 4d f5 10 00 	movzbl 0x10f54d,%eax
  101916:	83 e0 ef             	and    $0xffffffef,%eax
  101919:	a2 4d f5 10 00       	mov    %al,0x10f54d
  10191e:	0f b6 05 4d f5 10 00 	movzbl 0x10f54d,%eax
  101925:	83 c8 60             	or     $0x60,%eax
  101928:	a2 4d f5 10 00       	mov    %al,0x10f54d
  10192d:	0f b6 05 4d f5 10 00 	movzbl 0x10f54d,%eax
  101934:	83 c8 80             	or     $0xffffff80,%eax
  101937:	a2 4d f5 10 00       	mov    %al,0x10f54d
  10193c:	a1 04 e8 10 00       	mov    0x10e804,%eax
  101941:	c1 e8 10             	shr    $0x10,%eax
  101944:	66 a3 4e f5 10 00    	mov    %ax,0x10f54e
  10194a:	c7 45 f8 80 e5 10 00 	movl   $0x10e580,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101951:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101954:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  101957:	c9                   	leave  
  101958:	c3                   	ret    

00101959 <trapname>:

static const char *
trapname(int trapno) {
  101959:	55                   	push   %ebp
  10195a:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  10195c:	8b 45 08             	mov    0x8(%ebp),%eax
  10195f:	83 f8 13             	cmp    $0x13,%eax
  101962:	77 0c                	ja     101970 <trapname+0x17>
        return excnames[trapno];
  101964:	8b 45 08             	mov    0x8(%ebp),%eax
  101967:	8b 04 85 40 3c 10 00 	mov    0x103c40(,%eax,4),%eax
  10196e:	eb 18                	jmp    101988 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101970:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101974:	7e 0d                	jle    101983 <trapname+0x2a>
  101976:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10197a:	7f 07                	jg     101983 <trapname+0x2a>
        return "Hardware Interrupt";
  10197c:	b8 ca 38 10 00       	mov    $0x1038ca,%eax
  101981:	eb 05                	jmp    101988 <trapname+0x2f>
    }
    return "(unknown trap)";
  101983:	b8 dd 38 10 00       	mov    $0x1038dd,%eax
}
  101988:	5d                   	pop    %ebp
  101989:	c3                   	ret    

0010198a <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10198a:	55                   	push   %ebp
  10198b:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  10198d:	8b 45 08             	mov    0x8(%ebp),%eax
  101990:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101994:	66 83 f8 08          	cmp    $0x8,%ax
  101998:	0f 94 c0             	sete   %al
  10199b:	0f b6 c0             	movzbl %al,%eax
}
  10199e:	5d                   	pop    %ebp
  10199f:	c3                   	ret    

001019a0 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019a0:	55                   	push   %ebp
  1019a1:	89 e5                	mov    %esp,%ebp
  1019a3:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  1019a6:	83 ec 08             	sub    $0x8,%esp
  1019a9:	ff 75 08             	pushl  0x8(%ebp)
  1019ac:	68 1e 39 10 00       	push   $0x10391e
  1019b1:	e8 8e e8 ff ff       	call   100244 <cprintf>
  1019b6:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  1019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1019bc:	83 ec 0c             	sub    $0xc,%esp
  1019bf:	50                   	push   %eax
  1019c0:	e8 b7 01 00 00       	call   101b7c <print_regs>
  1019c5:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019cb:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019cf:	0f b7 c0             	movzwl %ax,%eax
  1019d2:	83 ec 08             	sub    $0x8,%esp
  1019d5:	50                   	push   %eax
  1019d6:	68 2f 39 10 00       	push   $0x10392f
  1019db:	e8 64 e8 ff ff       	call   100244 <cprintf>
  1019e0:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e6:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1019ea:	0f b7 c0             	movzwl %ax,%eax
  1019ed:	83 ec 08             	sub    $0x8,%esp
  1019f0:	50                   	push   %eax
  1019f1:	68 42 39 10 00       	push   $0x103942
  1019f6:	e8 49 e8 ff ff       	call   100244 <cprintf>
  1019fb:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101a01:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a05:	0f b7 c0             	movzwl %ax,%eax
  101a08:	83 ec 08             	sub    $0x8,%esp
  101a0b:	50                   	push   %eax
  101a0c:	68 55 39 10 00       	push   $0x103955
  101a11:	e8 2e e8 ff ff       	call   100244 <cprintf>
  101a16:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a19:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1c:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a20:	0f b7 c0             	movzwl %ax,%eax
  101a23:	83 ec 08             	sub    $0x8,%esp
  101a26:	50                   	push   %eax
  101a27:	68 68 39 10 00       	push   $0x103968
  101a2c:	e8 13 e8 ff ff       	call   100244 <cprintf>
  101a31:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a34:	8b 45 08             	mov    0x8(%ebp),%eax
  101a37:	8b 40 30             	mov    0x30(%eax),%eax
  101a3a:	83 ec 0c             	sub    $0xc,%esp
  101a3d:	50                   	push   %eax
  101a3e:	e8 16 ff ff ff       	call   101959 <trapname>
  101a43:	83 c4 10             	add    $0x10,%esp
  101a46:	89 c2                	mov    %eax,%edx
  101a48:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4b:	8b 40 30             	mov    0x30(%eax),%eax
  101a4e:	83 ec 04             	sub    $0x4,%esp
  101a51:	52                   	push   %edx
  101a52:	50                   	push   %eax
  101a53:	68 7b 39 10 00       	push   $0x10397b
  101a58:	e8 e7 e7 ff ff       	call   100244 <cprintf>
  101a5d:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a60:	8b 45 08             	mov    0x8(%ebp),%eax
  101a63:	8b 40 34             	mov    0x34(%eax),%eax
  101a66:	83 ec 08             	sub    $0x8,%esp
  101a69:	50                   	push   %eax
  101a6a:	68 8d 39 10 00       	push   $0x10398d
  101a6f:	e8 d0 e7 ff ff       	call   100244 <cprintf>
  101a74:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a77:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7a:	8b 40 38             	mov    0x38(%eax),%eax
  101a7d:	83 ec 08             	sub    $0x8,%esp
  101a80:	50                   	push   %eax
  101a81:	68 9c 39 10 00       	push   $0x10399c
  101a86:	e8 b9 e7 ff ff       	call   100244 <cprintf>
  101a8b:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a91:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a95:	0f b7 c0             	movzwl %ax,%eax
  101a98:	83 ec 08             	sub    $0x8,%esp
  101a9b:	50                   	push   %eax
  101a9c:	68 ab 39 10 00       	push   $0x1039ab
  101aa1:	e8 9e e7 ff ff       	call   100244 <cprintf>
  101aa6:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aac:	8b 40 40             	mov    0x40(%eax),%eax
  101aaf:	83 ec 08             	sub    $0x8,%esp
  101ab2:	50                   	push   %eax
  101ab3:	68 be 39 10 00       	push   $0x1039be
  101ab8:	e8 87 e7 ff ff       	call   100244 <cprintf>
  101abd:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ac0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ac7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ace:	eb 3f                	jmp    101b0f <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad3:	8b 50 40             	mov    0x40(%eax),%edx
  101ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ad9:	21 d0                	and    %edx,%eax
  101adb:	85 c0                	test   %eax,%eax
  101add:	74 29                	je     101b08 <print_trapframe+0x168>
  101adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ae2:	8b 04 85 c0 e5 10 00 	mov    0x10e5c0(,%eax,4),%eax
  101ae9:	85 c0                	test   %eax,%eax
  101aeb:	74 1b                	je     101b08 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101af0:	8b 04 85 c0 e5 10 00 	mov    0x10e5c0(,%eax,4),%eax
  101af7:	83 ec 08             	sub    $0x8,%esp
  101afa:	50                   	push   %eax
  101afb:	68 cd 39 10 00       	push   $0x1039cd
  101b00:	e8 3f e7 ff ff       	call   100244 <cprintf>
  101b05:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b08:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b0c:	d1 65 f0             	shll   -0x10(%ebp)
  101b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b12:	83 f8 17             	cmp    $0x17,%eax
  101b15:	76 b9                	jbe    101ad0 <print_trapframe+0x130>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b17:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1a:	8b 40 40             	mov    0x40(%eax),%eax
  101b1d:	25 00 30 00 00       	and    $0x3000,%eax
  101b22:	c1 e8 0c             	shr    $0xc,%eax
  101b25:	83 ec 08             	sub    $0x8,%esp
  101b28:	50                   	push   %eax
  101b29:	68 d1 39 10 00       	push   $0x1039d1
  101b2e:	e8 11 e7 ff ff       	call   100244 <cprintf>
  101b33:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101b36:	83 ec 0c             	sub    $0xc,%esp
  101b39:	ff 75 08             	pushl  0x8(%ebp)
  101b3c:	e8 49 fe ff ff       	call   10198a <trap_in_kernel>
  101b41:	83 c4 10             	add    $0x10,%esp
  101b44:	85 c0                	test   %eax,%eax
  101b46:	75 32                	jne    101b7a <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b48:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4b:	8b 40 44             	mov    0x44(%eax),%eax
  101b4e:	83 ec 08             	sub    $0x8,%esp
  101b51:	50                   	push   %eax
  101b52:	68 da 39 10 00       	push   $0x1039da
  101b57:	e8 e8 e6 ff ff       	call   100244 <cprintf>
  101b5c:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b62:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b66:	0f b7 c0             	movzwl %ax,%eax
  101b69:	83 ec 08             	sub    $0x8,%esp
  101b6c:	50                   	push   %eax
  101b6d:	68 e9 39 10 00       	push   $0x1039e9
  101b72:	e8 cd e6 ff ff       	call   100244 <cprintf>
  101b77:	83 c4 10             	add    $0x10,%esp
    }
}
  101b7a:	c9                   	leave  
  101b7b:	c3                   	ret    

00101b7c <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b7c:	55                   	push   %ebp
  101b7d:	89 e5                	mov    %esp,%ebp
  101b7f:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b82:	8b 45 08             	mov    0x8(%ebp),%eax
  101b85:	8b 00                	mov    (%eax),%eax
  101b87:	83 ec 08             	sub    $0x8,%esp
  101b8a:	50                   	push   %eax
  101b8b:	68 fc 39 10 00       	push   $0x1039fc
  101b90:	e8 af e6 ff ff       	call   100244 <cprintf>
  101b95:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b98:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9b:	8b 40 04             	mov    0x4(%eax),%eax
  101b9e:	83 ec 08             	sub    $0x8,%esp
  101ba1:	50                   	push   %eax
  101ba2:	68 0b 3a 10 00       	push   $0x103a0b
  101ba7:	e8 98 e6 ff ff       	call   100244 <cprintf>
  101bac:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101baf:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb2:	8b 40 08             	mov    0x8(%eax),%eax
  101bb5:	83 ec 08             	sub    $0x8,%esp
  101bb8:	50                   	push   %eax
  101bb9:	68 1a 3a 10 00       	push   $0x103a1a
  101bbe:	e8 81 e6 ff ff       	call   100244 <cprintf>
  101bc3:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc9:	8b 40 0c             	mov    0xc(%eax),%eax
  101bcc:	83 ec 08             	sub    $0x8,%esp
  101bcf:	50                   	push   %eax
  101bd0:	68 29 3a 10 00       	push   $0x103a29
  101bd5:	e8 6a e6 ff ff       	call   100244 <cprintf>
  101bda:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  101be0:	8b 40 10             	mov    0x10(%eax),%eax
  101be3:	83 ec 08             	sub    $0x8,%esp
  101be6:	50                   	push   %eax
  101be7:	68 38 3a 10 00       	push   $0x103a38
  101bec:	e8 53 e6 ff ff       	call   100244 <cprintf>
  101bf1:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf7:	8b 40 14             	mov    0x14(%eax),%eax
  101bfa:	83 ec 08             	sub    $0x8,%esp
  101bfd:	50                   	push   %eax
  101bfe:	68 47 3a 10 00       	push   $0x103a47
  101c03:	e8 3c e6 ff ff       	call   100244 <cprintf>
  101c08:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0e:	8b 40 18             	mov    0x18(%eax),%eax
  101c11:	83 ec 08             	sub    $0x8,%esp
  101c14:	50                   	push   %eax
  101c15:	68 56 3a 10 00       	push   $0x103a56
  101c1a:	e8 25 e6 ff ff       	call   100244 <cprintf>
  101c1f:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c22:	8b 45 08             	mov    0x8(%ebp),%eax
  101c25:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c28:	83 ec 08             	sub    $0x8,%esp
  101c2b:	50                   	push   %eax
  101c2c:	68 65 3a 10 00       	push   $0x103a65
  101c31:	e8 0e e6 ff ff       	call   100244 <cprintf>
  101c36:	83 c4 10             	add    $0x10,%esp
}
  101c39:	c9                   	leave  
  101c3a:	c3                   	ret    

00101c3b <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c3b:	55                   	push   %ebp
  101c3c:	89 e5                	mov    %esp,%ebp
  101c3e:	57                   	push   %edi
  101c3f:	56                   	push   %esi
  101c40:	53                   	push   %ebx
  101c41:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    switch (tf->tf_trapno) {
  101c44:	8b 45 08             	mov    0x8(%ebp),%eax
  101c47:	8b 40 30             	mov    0x30(%eax),%eax
  101c4a:	83 f8 2f             	cmp    $0x2f,%eax
  101c4d:	77 21                	ja     101c70 <trap_dispatch+0x35>
  101c4f:	83 f8 2e             	cmp    $0x2e,%eax
  101c52:	0f 83 03 02 00 00    	jae    101e5b <trap_dispatch+0x220>
  101c58:	83 f8 21             	cmp    $0x21,%eax
  101c5b:	0f 84 88 00 00 00    	je     101ce9 <trap_dispatch+0xae>
  101c61:	83 f8 24             	cmp    $0x24,%eax
  101c64:	74 5c                	je     101cc2 <trap_dispatch+0x87>
  101c66:	83 f8 20             	cmp    $0x20,%eax
  101c69:	74 1c                	je     101c87 <trap_dispatch+0x4c>
  101c6b:	e9 b5 01 00 00       	jmp    101e25 <trap_dispatch+0x1ea>
  101c70:	83 f8 78             	cmp    $0x78,%eax
  101c73:	0f 84 97 00 00 00    	je     101d10 <trap_dispatch+0xd5>
  101c79:	83 f8 79             	cmp    $0x79,%eax
  101c7c:	0f 84 2f 01 00 00    	je     101db1 <trap_dispatch+0x176>
  101c82:	e9 9e 01 00 00       	jmp    101e25 <trap_dispatch+0x1ea>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101c87:	a1 e8 f9 10 00       	mov    0x10f9e8,%eax
  101c8c:	83 c0 01             	add    $0x1,%eax
  101c8f:	a3 e8 f9 10 00       	mov    %eax,0x10f9e8
        if (ticks % TICK_NUM == 0) {
  101c94:	8b 0d e8 f9 10 00    	mov    0x10f9e8,%ecx
  101c9a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101c9f:	89 c8                	mov    %ecx,%eax
  101ca1:	f7 e2                	mul    %edx
  101ca3:	89 d0                	mov    %edx,%eax
  101ca5:	c1 e8 05             	shr    $0x5,%eax
  101ca8:	6b c0 64             	imul   $0x64,%eax,%eax
  101cab:	29 c1                	sub    %eax,%ecx
  101cad:	89 c8                	mov    %ecx,%eax
  101caf:	85 c0                	test   %eax,%eax
  101cb1:	75 0a                	jne    101cbd <trap_dispatch+0x82>
            print_ticks();
  101cb3:	e8 16 fb ff ff       	call   1017ce <print_ticks>
        }
        break;
  101cb8:	e9 9f 01 00 00       	jmp    101e5c <trap_dispatch+0x221>
  101cbd:	e9 9a 01 00 00       	jmp    101e5c <trap_dispatch+0x221>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cc2:	e8 df f8 ff ff       	call   1015a6 <cons_getc>
  101cc7:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cca:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101cce:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101cd2:	83 ec 04             	sub    $0x4,%esp
  101cd5:	52                   	push   %edx
  101cd6:	50                   	push   %eax
  101cd7:	68 74 3a 10 00       	push   $0x103a74
  101cdc:	e8 63 e5 ff ff       	call   100244 <cprintf>
  101ce1:	83 c4 10             	add    $0x10,%esp
        break;
  101ce4:	e9 73 01 00 00       	jmp    101e5c <trap_dispatch+0x221>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ce9:	e8 b8 f8 ff ff       	call   1015a6 <cons_getc>
  101cee:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101cf1:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101cf5:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101cf9:	83 ec 04             	sub    $0x4,%esp
  101cfc:	52                   	push   %edx
  101cfd:	50                   	push   %eax
  101cfe:	68 86 3a 10 00       	push   $0x103a86
  101d03:	e8 3c e5 ff ff       	call   100244 <cprintf>
  101d08:	83 c4 10             	add    $0x10,%esp
        break;
  101d0b:	e9 4c 01 00 00       	jmp    101e5c <trap_dispatch+0x221>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101d10:	8b 45 08             	mov    0x8(%ebp),%eax
  101d13:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d17:	66 83 f8 1b          	cmp    $0x1b,%ax
  101d1b:	0f 84 8b 00 00 00    	je     101dac <trap_dispatch+0x171>
            switchk2u = *tf;
  101d21:	8b 55 08             	mov    0x8(%ebp),%edx
  101d24:	b8 00 fa 10 00       	mov    $0x10fa00,%eax
  101d29:	89 d3                	mov    %edx,%ebx
  101d2b:	ba 4c 00 00 00       	mov    $0x4c,%edx
  101d30:	8b 0b                	mov    (%ebx),%ecx
  101d32:	89 08                	mov    %ecx,(%eax)
  101d34:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  101d38:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  101d3c:	8d 78 04             	lea    0x4(%eax),%edi
  101d3f:	83 e7 fc             	and    $0xfffffffc,%edi
  101d42:	29 f8                	sub    %edi,%eax
  101d44:	29 c3                	sub    %eax,%ebx
  101d46:	01 c2                	add    %eax,%edx
  101d48:	83 e2 fc             	and    $0xfffffffc,%edx
  101d4b:	89 d0                	mov    %edx,%eax
  101d4d:	c1 e8 02             	shr    $0x2,%eax
  101d50:	89 de                	mov    %ebx,%esi
  101d52:	89 c1                	mov    %eax,%ecx
  101d54:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101d56:	66 c7 05 3c fa 10 00 	movw   $0x1b,0x10fa3c
  101d5d:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101d5f:	66 c7 05 48 fa 10 00 	movw   $0x23,0x10fa48
  101d66:	23 00 
  101d68:	0f b7 05 48 fa 10 00 	movzwl 0x10fa48,%eax
  101d6f:	66 a3 28 fa 10 00    	mov    %ax,0x10fa28
  101d75:	0f b7 05 28 fa 10 00 	movzwl 0x10fa28,%eax
  101d7c:	66 a3 2c fa 10 00    	mov    %ax,0x10fa2c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101d82:	8b 45 08             	mov    0x8(%ebp),%eax
  101d85:	83 c0 44             	add    $0x44,%eax
  101d88:	a3 44 fa 10 00       	mov    %eax,0x10fa44
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101d8d:	a1 40 fa 10 00       	mov    0x10fa40,%eax
  101d92:	80 cc 30             	or     $0x30,%ah
  101d95:	a3 40 fa 10 00       	mov    %eax,0x10fa40
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9d:	83 e8 04             	sub    $0x4,%eax
  101da0:	ba 00 fa 10 00       	mov    $0x10fa00,%edx
  101da5:	89 10                	mov    %edx,(%eax)
        }
        break;
  101da7:	e9 b0 00 00 00       	jmp    101e5c <trap_dispatch+0x221>
  101dac:	e9 ab 00 00 00       	jmp    101e5c <trap_dispatch+0x221>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101db1:	8b 45 08             	mov    0x8(%ebp),%eax
  101db4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101db8:	66 83 f8 08          	cmp    $0x8,%ax
  101dbc:	74 65                	je     101e23 <trap_dispatch+0x1e8>
            tf->tf_cs = KERNEL_CS;
  101dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc1:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dca:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd3:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dda:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101dde:	8b 45 08             	mov    0x8(%ebp),%eax
  101de1:	8b 40 40             	mov    0x40(%eax),%eax
  101de4:	80 e4 cf             	and    $0xcf,%ah
  101de7:	89 c2                	mov    %eax,%edx
  101de9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dec:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101def:	8b 45 08             	mov    0x8(%ebp),%eax
  101df2:	8b 40 44             	mov    0x44(%eax),%eax
  101df5:	83 e8 44             	sub    $0x44,%eax
  101df8:	a3 4c fa 10 00       	mov    %eax,0x10fa4c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101dfd:	a1 4c fa 10 00       	mov    0x10fa4c,%eax
  101e02:	83 ec 04             	sub    $0x4,%esp
  101e05:	6a 44                	push   $0x44
  101e07:	ff 75 08             	pushl  0x8(%ebp)
  101e0a:	50                   	push   %eax
  101e0b:	e8 ad 0f 00 00       	call   102dbd <memmove>
  101e10:	83 c4 10             	add    $0x10,%esp
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101e13:	8b 45 08             	mov    0x8(%ebp),%eax
  101e16:	83 e8 04             	sub    $0x4,%eax
  101e19:	8b 15 4c fa 10 00    	mov    0x10fa4c,%edx
  101e1f:	89 10                	mov    %edx,(%eax)
        }
        break;
  101e21:	eb 39                	jmp    101e5c <trap_dispatch+0x221>
  101e23:	eb 37                	jmp    101e5c <trap_dispatch+0x221>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e25:	8b 45 08             	mov    0x8(%ebp),%eax
  101e28:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e2c:	0f b7 c0             	movzwl %ax,%eax
  101e2f:	83 e0 03             	and    $0x3,%eax
  101e32:	85 c0                	test   %eax,%eax
  101e34:	75 26                	jne    101e5c <trap_dispatch+0x221>
            print_trapframe(tf);
  101e36:	83 ec 0c             	sub    $0xc,%esp
  101e39:	ff 75 08             	pushl  0x8(%ebp)
  101e3c:	e8 5f fb ff ff       	call   1019a0 <print_trapframe>
  101e41:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101e44:	83 ec 04             	sub    $0x4,%esp
  101e47:	68 95 3a 10 00       	push   $0x103a95
  101e4c:	68 d2 00 00 00       	push   $0xd2
  101e51:	68 b1 3a 10 00       	push   $0x103ab1
  101e56:	e8 4e e5 ff ff       	call   1003a9 <__panic>
        break;
  101e5b:	90                   	nop
        }
    }
}
  101e5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  101e5f:	5b                   	pop    %ebx
  101e60:	5e                   	pop    %esi
  101e61:	5f                   	pop    %edi
  101e62:	5d                   	pop    %ebp
  101e63:	c3                   	ret    

00101e64 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e64:	55                   	push   %ebp
  101e65:	89 e5                	mov    %esp,%ebp
  101e67:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e6a:	83 ec 0c             	sub    $0xc,%esp
  101e6d:	ff 75 08             	pushl  0x8(%ebp)
  101e70:	e8 c6 fd ff ff       	call   101c3b <trap_dispatch>
  101e75:	83 c4 10             	add    $0x10,%esp
}
  101e78:	c9                   	leave  
  101e79:	c3                   	ret    

00101e7a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e7a:	6a 00                	push   $0x0
  pushl $0
  101e7c:	6a 00                	push   $0x0
  jmp __alltraps
  101e7e:	e9 67 0a 00 00       	jmp    1028ea <__alltraps>

00101e83 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e83:	6a 00                	push   $0x0
  pushl $1
  101e85:	6a 01                	push   $0x1
  jmp __alltraps
  101e87:	e9 5e 0a 00 00       	jmp    1028ea <__alltraps>

00101e8c <vector2>:
.globl vector2
vector2:
  pushl $0
  101e8c:	6a 00                	push   $0x0
  pushl $2
  101e8e:	6a 02                	push   $0x2
  jmp __alltraps
  101e90:	e9 55 0a 00 00       	jmp    1028ea <__alltraps>

00101e95 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e95:	6a 00                	push   $0x0
  pushl $3
  101e97:	6a 03                	push   $0x3
  jmp __alltraps
  101e99:	e9 4c 0a 00 00       	jmp    1028ea <__alltraps>

00101e9e <vector4>:
.globl vector4
vector4:
  pushl $0
  101e9e:	6a 00                	push   $0x0
  pushl $4
  101ea0:	6a 04                	push   $0x4
  jmp __alltraps
  101ea2:	e9 43 0a 00 00       	jmp    1028ea <__alltraps>

00101ea7 <vector5>:
.globl vector5
vector5:
  pushl $0
  101ea7:	6a 00                	push   $0x0
  pushl $5
  101ea9:	6a 05                	push   $0x5
  jmp __alltraps
  101eab:	e9 3a 0a 00 00       	jmp    1028ea <__alltraps>

00101eb0 <vector6>:
.globl vector6
vector6:
  pushl $0
  101eb0:	6a 00                	push   $0x0
  pushl $6
  101eb2:	6a 06                	push   $0x6
  jmp __alltraps
  101eb4:	e9 31 0a 00 00       	jmp    1028ea <__alltraps>

00101eb9 <vector7>:
.globl vector7
vector7:
  pushl $0
  101eb9:	6a 00                	push   $0x0
  pushl $7
  101ebb:	6a 07                	push   $0x7
  jmp __alltraps
  101ebd:	e9 28 0a 00 00       	jmp    1028ea <__alltraps>

00101ec2 <vector8>:
.globl vector8
vector8:
  pushl $8
  101ec2:	6a 08                	push   $0x8
  jmp __alltraps
  101ec4:	e9 21 0a 00 00       	jmp    1028ea <__alltraps>

00101ec9 <vector9>:
.globl vector9
vector9:
  pushl $9
  101ec9:	6a 09                	push   $0x9
  jmp __alltraps
  101ecb:	e9 1a 0a 00 00       	jmp    1028ea <__alltraps>

00101ed0 <vector10>:
.globl vector10
vector10:
  pushl $10
  101ed0:	6a 0a                	push   $0xa
  jmp __alltraps
  101ed2:	e9 13 0a 00 00       	jmp    1028ea <__alltraps>

00101ed7 <vector11>:
.globl vector11
vector11:
  pushl $11
  101ed7:	6a 0b                	push   $0xb
  jmp __alltraps
  101ed9:	e9 0c 0a 00 00       	jmp    1028ea <__alltraps>

00101ede <vector12>:
.globl vector12
vector12:
  pushl $12
  101ede:	6a 0c                	push   $0xc
  jmp __alltraps
  101ee0:	e9 05 0a 00 00       	jmp    1028ea <__alltraps>

00101ee5 <vector13>:
.globl vector13
vector13:
  pushl $13
  101ee5:	6a 0d                	push   $0xd
  jmp __alltraps
  101ee7:	e9 fe 09 00 00       	jmp    1028ea <__alltraps>

00101eec <vector14>:
.globl vector14
vector14:
  pushl $14
  101eec:	6a 0e                	push   $0xe
  jmp __alltraps
  101eee:	e9 f7 09 00 00       	jmp    1028ea <__alltraps>

00101ef3 <vector15>:
.globl vector15
vector15:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $15
  101ef5:	6a 0f                	push   $0xf
  jmp __alltraps
  101ef7:	e9 ee 09 00 00       	jmp    1028ea <__alltraps>

00101efc <vector16>:
.globl vector16
vector16:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $16
  101efe:	6a 10                	push   $0x10
  jmp __alltraps
  101f00:	e9 e5 09 00 00       	jmp    1028ea <__alltraps>

00101f05 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f05:	6a 11                	push   $0x11
  jmp __alltraps
  101f07:	e9 de 09 00 00       	jmp    1028ea <__alltraps>

00101f0c <vector18>:
.globl vector18
vector18:
  pushl $0
  101f0c:	6a 00                	push   $0x0
  pushl $18
  101f0e:	6a 12                	push   $0x12
  jmp __alltraps
  101f10:	e9 d5 09 00 00       	jmp    1028ea <__alltraps>

00101f15 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f15:	6a 00                	push   $0x0
  pushl $19
  101f17:	6a 13                	push   $0x13
  jmp __alltraps
  101f19:	e9 cc 09 00 00       	jmp    1028ea <__alltraps>

00101f1e <vector20>:
.globl vector20
vector20:
  pushl $0
  101f1e:	6a 00                	push   $0x0
  pushl $20
  101f20:	6a 14                	push   $0x14
  jmp __alltraps
  101f22:	e9 c3 09 00 00       	jmp    1028ea <__alltraps>

00101f27 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f27:	6a 00                	push   $0x0
  pushl $21
  101f29:	6a 15                	push   $0x15
  jmp __alltraps
  101f2b:	e9 ba 09 00 00       	jmp    1028ea <__alltraps>

00101f30 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f30:	6a 00                	push   $0x0
  pushl $22
  101f32:	6a 16                	push   $0x16
  jmp __alltraps
  101f34:	e9 b1 09 00 00       	jmp    1028ea <__alltraps>

00101f39 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f39:	6a 00                	push   $0x0
  pushl $23
  101f3b:	6a 17                	push   $0x17
  jmp __alltraps
  101f3d:	e9 a8 09 00 00       	jmp    1028ea <__alltraps>

00101f42 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f42:	6a 00                	push   $0x0
  pushl $24
  101f44:	6a 18                	push   $0x18
  jmp __alltraps
  101f46:	e9 9f 09 00 00       	jmp    1028ea <__alltraps>

00101f4b <vector25>:
.globl vector25
vector25:
  pushl $0
  101f4b:	6a 00                	push   $0x0
  pushl $25
  101f4d:	6a 19                	push   $0x19
  jmp __alltraps
  101f4f:	e9 96 09 00 00       	jmp    1028ea <__alltraps>

00101f54 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f54:	6a 00                	push   $0x0
  pushl $26
  101f56:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f58:	e9 8d 09 00 00       	jmp    1028ea <__alltraps>

00101f5d <vector27>:
.globl vector27
vector27:
  pushl $0
  101f5d:	6a 00                	push   $0x0
  pushl $27
  101f5f:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f61:	e9 84 09 00 00       	jmp    1028ea <__alltraps>

00101f66 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f66:	6a 00                	push   $0x0
  pushl $28
  101f68:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f6a:	e9 7b 09 00 00       	jmp    1028ea <__alltraps>

00101f6f <vector29>:
.globl vector29
vector29:
  pushl $0
  101f6f:	6a 00                	push   $0x0
  pushl $29
  101f71:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f73:	e9 72 09 00 00       	jmp    1028ea <__alltraps>

00101f78 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f78:	6a 00                	push   $0x0
  pushl $30
  101f7a:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f7c:	e9 69 09 00 00       	jmp    1028ea <__alltraps>

00101f81 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f81:	6a 00                	push   $0x0
  pushl $31
  101f83:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f85:	e9 60 09 00 00       	jmp    1028ea <__alltraps>

00101f8a <vector32>:
.globl vector32
vector32:
  pushl $0
  101f8a:	6a 00                	push   $0x0
  pushl $32
  101f8c:	6a 20                	push   $0x20
  jmp __alltraps
  101f8e:	e9 57 09 00 00       	jmp    1028ea <__alltraps>

00101f93 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f93:	6a 00                	push   $0x0
  pushl $33
  101f95:	6a 21                	push   $0x21
  jmp __alltraps
  101f97:	e9 4e 09 00 00       	jmp    1028ea <__alltraps>

00101f9c <vector34>:
.globl vector34
vector34:
  pushl $0
  101f9c:	6a 00                	push   $0x0
  pushl $34
  101f9e:	6a 22                	push   $0x22
  jmp __alltraps
  101fa0:	e9 45 09 00 00       	jmp    1028ea <__alltraps>

00101fa5 <vector35>:
.globl vector35
vector35:
  pushl $0
  101fa5:	6a 00                	push   $0x0
  pushl $35
  101fa7:	6a 23                	push   $0x23
  jmp __alltraps
  101fa9:	e9 3c 09 00 00       	jmp    1028ea <__alltraps>

00101fae <vector36>:
.globl vector36
vector36:
  pushl $0
  101fae:	6a 00                	push   $0x0
  pushl $36
  101fb0:	6a 24                	push   $0x24
  jmp __alltraps
  101fb2:	e9 33 09 00 00       	jmp    1028ea <__alltraps>

00101fb7 <vector37>:
.globl vector37
vector37:
  pushl $0
  101fb7:	6a 00                	push   $0x0
  pushl $37
  101fb9:	6a 25                	push   $0x25
  jmp __alltraps
  101fbb:	e9 2a 09 00 00       	jmp    1028ea <__alltraps>

00101fc0 <vector38>:
.globl vector38
vector38:
  pushl $0
  101fc0:	6a 00                	push   $0x0
  pushl $38
  101fc2:	6a 26                	push   $0x26
  jmp __alltraps
  101fc4:	e9 21 09 00 00       	jmp    1028ea <__alltraps>

00101fc9 <vector39>:
.globl vector39
vector39:
  pushl $0
  101fc9:	6a 00                	push   $0x0
  pushl $39
  101fcb:	6a 27                	push   $0x27
  jmp __alltraps
  101fcd:	e9 18 09 00 00       	jmp    1028ea <__alltraps>

00101fd2 <vector40>:
.globl vector40
vector40:
  pushl $0
  101fd2:	6a 00                	push   $0x0
  pushl $40
  101fd4:	6a 28                	push   $0x28
  jmp __alltraps
  101fd6:	e9 0f 09 00 00       	jmp    1028ea <__alltraps>

00101fdb <vector41>:
.globl vector41
vector41:
  pushl $0
  101fdb:	6a 00                	push   $0x0
  pushl $41
  101fdd:	6a 29                	push   $0x29
  jmp __alltraps
  101fdf:	e9 06 09 00 00       	jmp    1028ea <__alltraps>

00101fe4 <vector42>:
.globl vector42
vector42:
  pushl $0
  101fe4:	6a 00                	push   $0x0
  pushl $42
  101fe6:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fe8:	e9 fd 08 00 00       	jmp    1028ea <__alltraps>

00101fed <vector43>:
.globl vector43
vector43:
  pushl $0
  101fed:	6a 00                	push   $0x0
  pushl $43
  101fef:	6a 2b                	push   $0x2b
  jmp __alltraps
  101ff1:	e9 f4 08 00 00       	jmp    1028ea <__alltraps>

00101ff6 <vector44>:
.globl vector44
vector44:
  pushl $0
  101ff6:	6a 00                	push   $0x0
  pushl $44
  101ff8:	6a 2c                	push   $0x2c
  jmp __alltraps
  101ffa:	e9 eb 08 00 00       	jmp    1028ea <__alltraps>

00101fff <vector45>:
.globl vector45
vector45:
  pushl $0
  101fff:	6a 00                	push   $0x0
  pushl $45
  102001:	6a 2d                	push   $0x2d
  jmp __alltraps
  102003:	e9 e2 08 00 00       	jmp    1028ea <__alltraps>

00102008 <vector46>:
.globl vector46
vector46:
  pushl $0
  102008:	6a 00                	push   $0x0
  pushl $46
  10200a:	6a 2e                	push   $0x2e
  jmp __alltraps
  10200c:	e9 d9 08 00 00       	jmp    1028ea <__alltraps>

00102011 <vector47>:
.globl vector47
vector47:
  pushl $0
  102011:	6a 00                	push   $0x0
  pushl $47
  102013:	6a 2f                	push   $0x2f
  jmp __alltraps
  102015:	e9 d0 08 00 00       	jmp    1028ea <__alltraps>

0010201a <vector48>:
.globl vector48
vector48:
  pushl $0
  10201a:	6a 00                	push   $0x0
  pushl $48
  10201c:	6a 30                	push   $0x30
  jmp __alltraps
  10201e:	e9 c7 08 00 00       	jmp    1028ea <__alltraps>

00102023 <vector49>:
.globl vector49
vector49:
  pushl $0
  102023:	6a 00                	push   $0x0
  pushl $49
  102025:	6a 31                	push   $0x31
  jmp __alltraps
  102027:	e9 be 08 00 00       	jmp    1028ea <__alltraps>

0010202c <vector50>:
.globl vector50
vector50:
  pushl $0
  10202c:	6a 00                	push   $0x0
  pushl $50
  10202e:	6a 32                	push   $0x32
  jmp __alltraps
  102030:	e9 b5 08 00 00       	jmp    1028ea <__alltraps>

00102035 <vector51>:
.globl vector51
vector51:
  pushl $0
  102035:	6a 00                	push   $0x0
  pushl $51
  102037:	6a 33                	push   $0x33
  jmp __alltraps
  102039:	e9 ac 08 00 00       	jmp    1028ea <__alltraps>

0010203e <vector52>:
.globl vector52
vector52:
  pushl $0
  10203e:	6a 00                	push   $0x0
  pushl $52
  102040:	6a 34                	push   $0x34
  jmp __alltraps
  102042:	e9 a3 08 00 00       	jmp    1028ea <__alltraps>

00102047 <vector53>:
.globl vector53
vector53:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $53
  102049:	6a 35                	push   $0x35
  jmp __alltraps
  10204b:	e9 9a 08 00 00       	jmp    1028ea <__alltraps>

00102050 <vector54>:
.globl vector54
vector54:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $54
  102052:	6a 36                	push   $0x36
  jmp __alltraps
  102054:	e9 91 08 00 00       	jmp    1028ea <__alltraps>

00102059 <vector55>:
.globl vector55
vector55:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $55
  10205b:	6a 37                	push   $0x37
  jmp __alltraps
  10205d:	e9 88 08 00 00       	jmp    1028ea <__alltraps>

00102062 <vector56>:
.globl vector56
vector56:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $56
  102064:	6a 38                	push   $0x38
  jmp __alltraps
  102066:	e9 7f 08 00 00       	jmp    1028ea <__alltraps>

0010206b <vector57>:
.globl vector57
vector57:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $57
  10206d:	6a 39                	push   $0x39
  jmp __alltraps
  10206f:	e9 76 08 00 00       	jmp    1028ea <__alltraps>

00102074 <vector58>:
.globl vector58
vector58:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $58
  102076:	6a 3a                	push   $0x3a
  jmp __alltraps
  102078:	e9 6d 08 00 00       	jmp    1028ea <__alltraps>

0010207d <vector59>:
.globl vector59
vector59:
  pushl $0
  10207d:	6a 00                	push   $0x0
  pushl $59
  10207f:	6a 3b                	push   $0x3b
  jmp __alltraps
  102081:	e9 64 08 00 00       	jmp    1028ea <__alltraps>

00102086 <vector60>:
.globl vector60
vector60:
  pushl $0
  102086:	6a 00                	push   $0x0
  pushl $60
  102088:	6a 3c                	push   $0x3c
  jmp __alltraps
  10208a:	e9 5b 08 00 00       	jmp    1028ea <__alltraps>

0010208f <vector61>:
.globl vector61
vector61:
  pushl $0
  10208f:	6a 00                	push   $0x0
  pushl $61
  102091:	6a 3d                	push   $0x3d
  jmp __alltraps
  102093:	e9 52 08 00 00       	jmp    1028ea <__alltraps>

00102098 <vector62>:
.globl vector62
vector62:
  pushl $0
  102098:	6a 00                	push   $0x0
  pushl $62
  10209a:	6a 3e                	push   $0x3e
  jmp __alltraps
  10209c:	e9 49 08 00 00       	jmp    1028ea <__alltraps>

001020a1 <vector63>:
.globl vector63
vector63:
  pushl $0
  1020a1:	6a 00                	push   $0x0
  pushl $63
  1020a3:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020a5:	e9 40 08 00 00       	jmp    1028ea <__alltraps>

001020aa <vector64>:
.globl vector64
vector64:
  pushl $0
  1020aa:	6a 00                	push   $0x0
  pushl $64
  1020ac:	6a 40                	push   $0x40
  jmp __alltraps
  1020ae:	e9 37 08 00 00       	jmp    1028ea <__alltraps>

001020b3 <vector65>:
.globl vector65
vector65:
  pushl $0
  1020b3:	6a 00                	push   $0x0
  pushl $65
  1020b5:	6a 41                	push   $0x41
  jmp __alltraps
  1020b7:	e9 2e 08 00 00       	jmp    1028ea <__alltraps>

001020bc <vector66>:
.globl vector66
vector66:
  pushl $0
  1020bc:	6a 00                	push   $0x0
  pushl $66
  1020be:	6a 42                	push   $0x42
  jmp __alltraps
  1020c0:	e9 25 08 00 00       	jmp    1028ea <__alltraps>

001020c5 <vector67>:
.globl vector67
vector67:
  pushl $0
  1020c5:	6a 00                	push   $0x0
  pushl $67
  1020c7:	6a 43                	push   $0x43
  jmp __alltraps
  1020c9:	e9 1c 08 00 00       	jmp    1028ea <__alltraps>

001020ce <vector68>:
.globl vector68
vector68:
  pushl $0
  1020ce:	6a 00                	push   $0x0
  pushl $68
  1020d0:	6a 44                	push   $0x44
  jmp __alltraps
  1020d2:	e9 13 08 00 00       	jmp    1028ea <__alltraps>

001020d7 <vector69>:
.globl vector69
vector69:
  pushl $0
  1020d7:	6a 00                	push   $0x0
  pushl $69
  1020d9:	6a 45                	push   $0x45
  jmp __alltraps
  1020db:	e9 0a 08 00 00       	jmp    1028ea <__alltraps>

001020e0 <vector70>:
.globl vector70
vector70:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $70
  1020e2:	6a 46                	push   $0x46
  jmp __alltraps
  1020e4:	e9 01 08 00 00       	jmp    1028ea <__alltraps>

001020e9 <vector71>:
.globl vector71
vector71:
  pushl $0
  1020e9:	6a 00                	push   $0x0
  pushl $71
  1020eb:	6a 47                	push   $0x47
  jmp __alltraps
  1020ed:	e9 f8 07 00 00       	jmp    1028ea <__alltraps>

001020f2 <vector72>:
.globl vector72
vector72:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $72
  1020f4:	6a 48                	push   $0x48
  jmp __alltraps
  1020f6:	e9 ef 07 00 00       	jmp    1028ea <__alltraps>

001020fb <vector73>:
.globl vector73
vector73:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $73
  1020fd:	6a 49                	push   $0x49
  jmp __alltraps
  1020ff:	e9 e6 07 00 00       	jmp    1028ea <__alltraps>

00102104 <vector74>:
.globl vector74
vector74:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $74
  102106:	6a 4a                	push   $0x4a
  jmp __alltraps
  102108:	e9 dd 07 00 00       	jmp    1028ea <__alltraps>

0010210d <vector75>:
.globl vector75
vector75:
  pushl $0
  10210d:	6a 00                	push   $0x0
  pushl $75
  10210f:	6a 4b                	push   $0x4b
  jmp __alltraps
  102111:	e9 d4 07 00 00       	jmp    1028ea <__alltraps>

00102116 <vector76>:
.globl vector76
vector76:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $76
  102118:	6a 4c                	push   $0x4c
  jmp __alltraps
  10211a:	e9 cb 07 00 00       	jmp    1028ea <__alltraps>

0010211f <vector77>:
.globl vector77
vector77:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $77
  102121:	6a 4d                	push   $0x4d
  jmp __alltraps
  102123:	e9 c2 07 00 00       	jmp    1028ea <__alltraps>

00102128 <vector78>:
.globl vector78
vector78:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $78
  10212a:	6a 4e                	push   $0x4e
  jmp __alltraps
  10212c:	e9 b9 07 00 00       	jmp    1028ea <__alltraps>

00102131 <vector79>:
.globl vector79
vector79:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $79
  102133:	6a 4f                	push   $0x4f
  jmp __alltraps
  102135:	e9 b0 07 00 00       	jmp    1028ea <__alltraps>

0010213a <vector80>:
.globl vector80
vector80:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $80
  10213c:	6a 50                	push   $0x50
  jmp __alltraps
  10213e:	e9 a7 07 00 00       	jmp    1028ea <__alltraps>

00102143 <vector81>:
.globl vector81
vector81:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $81
  102145:	6a 51                	push   $0x51
  jmp __alltraps
  102147:	e9 9e 07 00 00       	jmp    1028ea <__alltraps>

0010214c <vector82>:
.globl vector82
vector82:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $82
  10214e:	6a 52                	push   $0x52
  jmp __alltraps
  102150:	e9 95 07 00 00       	jmp    1028ea <__alltraps>

00102155 <vector83>:
.globl vector83
vector83:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $83
  102157:	6a 53                	push   $0x53
  jmp __alltraps
  102159:	e9 8c 07 00 00       	jmp    1028ea <__alltraps>

0010215e <vector84>:
.globl vector84
vector84:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $84
  102160:	6a 54                	push   $0x54
  jmp __alltraps
  102162:	e9 83 07 00 00       	jmp    1028ea <__alltraps>

00102167 <vector85>:
.globl vector85
vector85:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $85
  102169:	6a 55                	push   $0x55
  jmp __alltraps
  10216b:	e9 7a 07 00 00       	jmp    1028ea <__alltraps>

00102170 <vector86>:
.globl vector86
vector86:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $86
  102172:	6a 56                	push   $0x56
  jmp __alltraps
  102174:	e9 71 07 00 00       	jmp    1028ea <__alltraps>

00102179 <vector87>:
.globl vector87
vector87:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $87
  10217b:	6a 57                	push   $0x57
  jmp __alltraps
  10217d:	e9 68 07 00 00       	jmp    1028ea <__alltraps>

00102182 <vector88>:
.globl vector88
vector88:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $88
  102184:	6a 58                	push   $0x58
  jmp __alltraps
  102186:	e9 5f 07 00 00       	jmp    1028ea <__alltraps>

0010218b <vector89>:
.globl vector89
vector89:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $89
  10218d:	6a 59                	push   $0x59
  jmp __alltraps
  10218f:	e9 56 07 00 00       	jmp    1028ea <__alltraps>

00102194 <vector90>:
.globl vector90
vector90:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $90
  102196:	6a 5a                	push   $0x5a
  jmp __alltraps
  102198:	e9 4d 07 00 00       	jmp    1028ea <__alltraps>

0010219d <vector91>:
.globl vector91
vector91:
  pushl $0
  10219d:	6a 00                	push   $0x0
  pushl $91
  10219f:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021a1:	e9 44 07 00 00       	jmp    1028ea <__alltraps>

001021a6 <vector92>:
.globl vector92
vector92:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $92
  1021a8:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021aa:	e9 3b 07 00 00       	jmp    1028ea <__alltraps>

001021af <vector93>:
.globl vector93
vector93:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $93
  1021b1:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021b3:	e9 32 07 00 00       	jmp    1028ea <__alltraps>

001021b8 <vector94>:
.globl vector94
vector94:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $94
  1021ba:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021bc:	e9 29 07 00 00       	jmp    1028ea <__alltraps>

001021c1 <vector95>:
.globl vector95
vector95:
  pushl $0
  1021c1:	6a 00                	push   $0x0
  pushl $95
  1021c3:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021c5:	e9 20 07 00 00       	jmp    1028ea <__alltraps>

001021ca <vector96>:
.globl vector96
vector96:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $96
  1021cc:	6a 60                	push   $0x60
  jmp __alltraps
  1021ce:	e9 17 07 00 00       	jmp    1028ea <__alltraps>

001021d3 <vector97>:
.globl vector97
vector97:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $97
  1021d5:	6a 61                	push   $0x61
  jmp __alltraps
  1021d7:	e9 0e 07 00 00       	jmp    1028ea <__alltraps>

001021dc <vector98>:
.globl vector98
vector98:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $98
  1021de:	6a 62                	push   $0x62
  jmp __alltraps
  1021e0:	e9 05 07 00 00       	jmp    1028ea <__alltraps>

001021e5 <vector99>:
.globl vector99
vector99:
  pushl $0
  1021e5:	6a 00                	push   $0x0
  pushl $99
  1021e7:	6a 63                	push   $0x63
  jmp __alltraps
  1021e9:	e9 fc 06 00 00       	jmp    1028ea <__alltraps>

001021ee <vector100>:
.globl vector100
vector100:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $100
  1021f0:	6a 64                	push   $0x64
  jmp __alltraps
  1021f2:	e9 f3 06 00 00       	jmp    1028ea <__alltraps>

001021f7 <vector101>:
.globl vector101
vector101:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $101
  1021f9:	6a 65                	push   $0x65
  jmp __alltraps
  1021fb:	e9 ea 06 00 00       	jmp    1028ea <__alltraps>

00102200 <vector102>:
.globl vector102
vector102:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $102
  102202:	6a 66                	push   $0x66
  jmp __alltraps
  102204:	e9 e1 06 00 00       	jmp    1028ea <__alltraps>

00102209 <vector103>:
.globl vector103
vector103:
  pushl $0
  102209:	6a 00                	push   $0x0
  pushl $103
  10220b:	6a 67                	push   $0x67
  jmp __alltraps
  10220d:	e9 d8 06 00 00       	jmp    1028ea <__alltraps>

00102212 <vector104>:
.globl vector104
vector104:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $104
  102214:	6a 68                	push   $0x68
  jmp __alltraps
  102216:	e9 cf 06 00 00       	jmp    1028ea <__alltraps>

0010221b <vector105>:
.globl vector105
vector105:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $105
  10221d:	6a 69                	push   $0x69
  jmp __alltraps
  10221f:	e9 c6 06 00 00       	jmp    1028ea <__alltraps>

00102224 <vector106>:
.globl vector106
vector106:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $106
  102226:	6a 6a                	push   $0x6a
  jmp __alltraps
  102228:	e9 bd 06 00 00       	jmp    1028ea <__alltraps>

0010222d <vector107>:
.globl vector107
vector107:
  pushl $0
  10222d:	6a 00                	push   $0x0
  pushl $107
  10222f:	6a 6b                	push   $0x6b
  jmp __alltraps
  102231:	e9 b4 06 00 00       	jmp    1028ea <__alltraps>

00102236 <vector108>:
.globl vector108
vector108:
  pushl $0
  102236:	6a 00                	push   $0x0
  pushl $108
  102238:	6a 6c                	push   $0x6c
  jmp __alltraps
  10223a:	e9 ab 06 00 00       	jmp    1028ea <__alltraps>

0010223f <vector109>:
.globl vector109
vector109:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $109
  102241:	6a 6d                	push   $0x6d
  jmp __alltraps
  102243:	e9 a2 06 00 00       	jmp    1028ea <__alltraps>

00102248 <vector110>:
.globl vector110
vector110:
  pushl $0
  102248:	6a 00                	push   $0x0
  pushl $110
  10224a:	6a 6e                	push   $0x6e
  jmp __alltraps
  10224c:	e9 99 06 00 00       	jmp    1028ea <__alltraps>

00102251 <vector111>:
.globl vector111
vector111:
  pushl $0
  102251:	6a 00                	push   $0x0
  pushl $111
  102253:	6a 6f                	push   $0x6f
  jmp __alltraps
  102255:	e9 90 06 00 00       	jmp    1028ea <__alltraps>

0010225a <vector112>:
.globl vector112
vector112:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $112
  10225c:	6a 70                	push   $0x70
  jmp __alltraps
  10225e:	e9 87 06 00 00       	jmp    1028ea <__alltraps>

00102263 <vector113>:
.globl vector113
vector113:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $113
  102265:	6a 71                	push   $0x71
  jmp __alltraps
  102267:	e9 7e 06 00 00       	jmp    1028ea <__alltraps>

0010226c <vector114>:
.globl vector114
vector114:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $114
  10226e:	6a 72                	push   $0x72
  jmp __alltraps
  102270:	e9 75 06 00 00       	jmp    1028ea <__alltraps>

00102275 <vector115>:
.globl vector115
vector115:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $115
  102277:	6a 73                	push   $0x73
  jmp __alltraps
  102279:	e9 6c 06 00 00       	jmp    1028ea <__alltraps>

0010227e <vector116>:
.globl vector116
vector116:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $116
  102280:	6a 74                	push   $0x74
  jmp __alltraps
  102282:	e9 63 06 00 00       	jmp    1028ea <__alltraps>

00102287 <vector117>:
.globl vector117
vector117:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $117
  102289:	6a 75                	push   $0x75
  jmp __alltraps
  10228b:	e9 5a 06 00 00       	jmp    1028ea <__alltraps>

00102290 <vector118>:
.globl vector118
vector118:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $118
  102292:	6a 76                	push   $0x76
  jmp __alltraps
  102294:	e9 51 06 00 00       	jmp    1028ea <__alltraps>

00102299 <vector119>:
.globl vector119
vector119:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $119
  10229b:	6a 77                	push   $0x77
  jmp __alltraps
  10229d:	e9 48 06 00 00       	jmp    1028ea <__alltraps>

001022a2 <vector120>:
.globl vector120
vector120:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $120
  1022a4:	6a 78                	push   $0x78
  jmp __alltraps
  1022a6:	e9 3f 06 00 00       	jmp    1028ea <__alltraps>

001022ab <vector121>:
.globl vector121
vector121:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $121
  1022ad:	6a 79                	push   $0x79
  jmp __alltraps
  1022af:	e9 36 06 00 00       	jmp    1028ea <__alltraps>

001022b4 <vector122>:
.globl vector122
vector122:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $122
  1022b6:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022b8:	e9 2d 06 00 00       	jmp    1028ea <__alltraps>

001022bd <vector123>:
.globl vector123
vector123:
  pushl $0
  1022bd:	6a 00                	push   $0x0
  pushl $123
  1022bf:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022c1:	e9 24 06 00 00       	jmp    1028ea <__alltraps>

001022c6 <vector124>:
.globl vector124
vector124:
  pushl $0
  1022c6:	6a 00                	push   $0x0
  pushl $124
  1022c8:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022ca:	e9 1b 06 00 00       	jmp    1028ea <__alltraps>

001022cf <vector125>:
.globl vector125
vector125:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $125
  1022d1:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022d3:	e9 12 06 00 00       	jmp    1028ea <__alltraps>

001022d8 <vector126>:
.globl vector126
vector126:
  pushl $0
  1022d8:	6a 00                	push   $0x0
  pushl $126
  1022da:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022dc:	e9 09 06 00 00       	jmp    1028ea <__alltraps>

001022e1 <vector127>:
.globl vector127
vector127:
  pushl $0
  1022e1:	6a 00                	push   $0x0
  pushl $127
  1022e3:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022e5:	e9 00 06 00 00       	jmp    1028ea <__alltraps>

001022ea <vector128>:
.globl vector128
vector128:
  pushl $0
  1022ea:	6a 00                	push   $0x0
  pushl $128
  1022ec:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022f1:	e9 f4 05 00 00       	jmp    1028ea <__alltraps>

001022f6 <vector129>:
.globl vector129
vector129:
  pushl $0
  1022f6:	6a 00                	push   $0x0
  pushl $129
  1022f8:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022fd:	e9 e8 05 00 00       	jmp    1028ea <__alltraps>

00102302 <vector130>:
.globl vector130
vector130:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $130
  102304:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102309:	e9 dc 05 00 00       	jmp    1028ea <__alltraps>

0010230e <vector131>:
.globl vector131
vector131:
  pushl $0
  10230e:	6a 00                	push   $0x0
  pushl $131
  102310:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102315:	e9 d0 05 00 00       	jmp    1028ea <__alltraps>

0010231a <vector132>:
.globl vector132
vector132:
  pushl $0
  10231a:	6a 00                	push   $0x0
  pushl $132
  10231c:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102321:	e9 c4 05 00 00       	jmp    1028ea <__alltraps>

00102326 <vector133>:
.globl vector133
vector133:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $133
  102328:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10232d:	e9 b8 05 00 00       	jmp    1028ea <__alltraps>

00102332 <vector134>:
.globl vector134
vector134:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $134
  102334:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102339:	e9 ac 05 00 00       	jmp    1028ea <__alltraps>

0010233e <vector135>:
.globl vector135
vector135:
  pushl $0
  10233e:	6a 00                	push   $0x0
  pushl $135
  102340:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102345:	e9 a0 05 00 00       	jmp    1028ea <__alltraps>

0010234a <vector136>:
.globl vector136
vector136:
  pushl $0
  10234a:	6a 00                	push   $0x0
  pushl $136
  10234c:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102351:	e9 94 05 00 00       	jmp    1028ea <__alltraps>

00102356 <vector137>:
.globl vector137
vector137:
  pushl $0
  102356:	6a 00                	push   $0x0
  pushl $137
  102358:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10235d:	e9 88 05 00 00       	jmp    1028ea <__alltraps>

00102362 <vector138>:
.globl vector138
vector138:
  pushl $0
  102362:	6a 00                	push   $0x0
  pushl $138
  102364:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102369:	e9 7c 05 00 00       	jmp    1028ea <__alltraps>

0010236e <vector139>:
.globl vector139
vector139:
  pushl $0
  10236e:	6a 00                	push   $0x0
  pushl $139
  102370:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102375:	e9 70 05 00 00       	jmp    1028ea <__alltraps>

0010237a <vector140>:
.globl vector140
vector140:
  pushl $0
  10237a:	6a 00                	push   $0x0
  pushl $140
  10237c:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102381:	e9 64 05 00 00       	jmp    1028ea <__alltraps>

00102386 <vector141>:
.globl vector141
vector141:
  pushl $0
  102386:	6a 00                	push   $0x0
  pushl $141
  102388:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10238d:	e9 58 05 00 00       	jmp    1028ea <__alltraps>

00102392 <vector142>:
.globl vector142
vector142:
  pushl $0
  102392:	6a 00                	push   $0x0
  pushl $142
  102394:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102399:	e9 4c 05 00 00       	jmp    1028ea <__alltraps>

0010239e <vector143>:
.globl vector143
vector143:
  pushl $0
  10239e:	6a 00                	push   $0x0
  pushl $143
  1023a0:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023a5:	e9 40 05 00 00       	jmp    1028ea <__alltraps>

001023aa <vector144>:
.globl vector144
vector144:
  pushl $0
  1023aa:	6a 00                	push   $0x0
  pushl $144
  1023ac:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023b1:	e9 34 05 00 00       	jmp    1028ea <__alltraps>

001023b6 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023b6:	6a 00                	push   $0x0
  pushl $145
  1023b8:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023bd:	e9 28 05 00 00       	jmp    1028ea <__alltraps>

001023c2 <vector146>:
.globl vector146
vector146:
  pushl $0
  1023c2:	6a 00                	push   $0x0
  pushl $146
  1023c4:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023c9:	e9 1c 05 00 00       	jmp    1028ea <__alltraps>

001023ce <vector147>:
.globl vector147
vector147:
  pushl $0
  1023ce:	6a 00                	push   $0x0
  pushl $147
  1023d0:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023d5:	e9 10 05 00 00       	jmp    1028ea <__alltraps>

001023da <vector148>:
.globl vector148
vector148:
  pushl $0
  1023da:	6a 00                	push   $0x0
  pushl $148
  1023dc:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023e1:	e9 04 05 00 00       	jmp    1028ea <__alltraps>

001023e6 <vector149>:
.globl vector149
vector149:
  pushl $0
  1023e6:	6a 00                	push   $0x0
  pushl $149
  1023e8:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023ed:	e9 f8 04 00 00       	jmp    1028ea <__alltraps>

001023f2 <vector150>:
.globl vector150
vector150:
  pushl $0
  1023f2:	6a 00                	push   $0x0
  pushl $150
  1023f4:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023f9:	e9 ec 04 00 00       	jmp    1028ea <__alltraps>

001023fe <vector151>:
.globl vector151
vector151:
  pushl $0
  1023fe:	6a 00                	push   $0x0
  pushl $151
  102400:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102405:	e9 e0 04 00 00       	jmp    1028ea <__alltraps>

0010240a <vector152>:
.globl vector152
vector152:
  pushl $0
  10240a:	6a 00                	push   $0x0
  pushl $152
  10240c:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102411:	e9 d4 04 00 00       	jmp    1028ea <__alltraps>

00102416 <vector153>:
.globl vector153
vector153:
  pushl $0
  102416:	6a 00                	push   $0x0
  pushl $153
  102418:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10241d:	e9 c8 04 00 00       	jmp    1028ea <__alltraps>

00102422 <vector154>:
.globl vector154
vector154:
  pushl $0
  102422:	6a 00                	push   $0x0
  pushl $154
  102424:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102429:	e9 bc 04 00 00       	jmp    1028ea <__alltraps>

0010242e <vector155>:
.globl vector155
vector155:
  pushl $0
  10242e:	6a 00                	push   $0x0
  pushl $155
  102430:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102435:	e9 b0 04 00 00       	jmp    1028ea <__alltraps>

0010243a <vector156>:
.globl vector156
vector156:
  pushl $0
  10243a:	6a 00                	push   $0x0
  pushl $156
  10243c:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102441:	e9 a4 04 00 00       	jmp    1028ea <__alltraps>

00102446 <vector157>:
.globl vector157
vector157:
  pushl $0
  102446:	6a 00                	push   $0x0
  pushl $157
  102448:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10244d:	e9 98 04 00 00       	jmp    1028ea <__alltraps>

00102452 <vector158>:
.globl vector158
vector158:
  pushl $0
  102452:	6a 00                	push   $0x0
  pushl $158
  102454:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102459:	e9 8c 04 00 00       	jmp    1028ea <__alltraps>

0010245e <vector159>:
.globl vector159
vector159:
  pushl $0
  10245e:	6a 00                	push   $0x0
  pushl $159
  102460:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102465:	e9 80 04 00 00       	jmp    1028ea <__alltraps>

0010246a <vector160>:
.globl vector160
vector160:
  pushl $0
  10246a:	6a 00                	push   $0x0
  pushl $160
  10246c:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102471:	e9 74 04 00 00       	jmp    1028ea <__alltraps>

00102476 <vector161>:
.globl vector161
vector161:
  pushl $0
  102476:	6a 00                	push   $0x0
  pushl $161
  102478:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10247d:	e9 68 04 00 00       	jmp    1028ea <__alltraps>

00102482 <vector162>:
.globl vector162
vector162:
  pushl $0
  102482:	6a 00                	push   $0x0
  pushl $162
  102484:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102489:	e9 5c 04 00 00       	jmp    1028ea <__alltraps>

0010248e <vector163>:
.globl vector163
vector163:
  pushl $0
  10248e:	6a 00                	push   $0x0
  pushl $163
  102490:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102495:	e9 50 04 00 00       	jmp    1028ea <__alltraps>

0010249a <vector164>:
.globl vector164
vector164:
  pushl $0
  10249a:	6a 00                	push   $0x0
  pushl $164
  10249c:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024a1:	e9 44 04 00 00       	jmp    1028ea <__alltraps>

001024a6 <vector165>:
.globl vector165
vector165:
  pushl $0
  1024a6:	6a 00                	push   $0x0
  pushl $165
  1024a8:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024ad:	e9 38 04 00 00       	jmp    1028ea <__alltraps>

001024b2 <vector166>:
.globl vector166
vector166:
  pushl $0
  1024b2:	6a 00                	push   $0x0
  pushl $166
  1024b4:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024b9:	e9 2c 04 00 00       	jmp    1028ea <__alltraps>

001024be <vector167>:
.globl vector167
vector167:
  pushl $0
  1024be:	6a 00                	push   $0x0
  pushl $167
  1024c0:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024c5:	e9 20 04 00 00       	jmp    1028ea <__alltraps>

001024ca <vector168>:
.globl vector168
vector168:
  pushl $0
  1024ca:	6a 00                	push   $0x0
  pushl $168
  1024cc:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024d1:	e9 14 04 00 00       	jmp    1028ea <__alltraps>

001024d6 <vector169>:
.globl vector169
vector169:
  pushl $0
  1024d6:	6a 00                	push   $0x0
  pushl $169
  1024d8:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024dd:	e9 08 04 00 00       	jmp    1028ea <__alltraps>

001024e2 <vector170>:
.globl vector170
vector170:
  pushl $0
  1024e2:	6a 00                	push   $0x0
  pushl $170
  1024e4:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024e9:	e9 fc 03 00 00       	jmp    1028ea <__alltraps>

001024ee <vector171>:
.globl vector171
vector171:
  pushl $0
  1024ee:	6a 00                	push   $0x0
  pushl $171
  1024f0:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024f5:	e9 f0 03 00 00       	jmp    1028ea <__alltraps>

001024fa <vector172>:
.globl vector172
vector172:
  pushl $0
  1024fa:	6a 00                	push   $0x0
  pushl $172
  1024fc:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102501:	e9 e4 03 00 00       	jmp    1028ea <__alltraps>

00102506 <vector173>:
.globl vector173
vector173:
  pushl $0
  102506:	6a 00                	push   $0x0
  pushl $173
  102508:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10250d:	e9 d8 03 00 00       	jmp    1028ea <__alltraps>

00102512 <vector174>:
.globl vector174
vector174:
  pushl $0
  102512:	6a 00                	push   $0x0
  pushl $174
  102514:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102519:	e9 cc 03 00 00       	jmp    1028ea <__alltraps>

0010251e <vector175>:
.globl vector175
vector175:
  pushl $0
  10251e:	6a 00                	push   $0x0
  pushl $175
  102520:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102525:	e9 c0 03 00 00       	jmp    1028ea <__alltraps>

0010252a <vector176>:
.globl vector176
vector176:
  pushl $0
  10252a:	6a 00                	push   $0x0
  pushl $176
  10252c:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102531:	e9 b4 03 00 00       	jmp    1028ea <__alltraps>

00102536 <vector177>:
.globl vector177
vector177:
  pushl $0
  102536:	6a 00                	push   $0x0
  pushl $177
  102538:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10253d:	e9 a8 03 00 00       	jmp    1028ea <__alltraps>

00102542 <vector178>:
.globl vector178
vector178:
  pushl $0
  102542:	6a 00                	push   $0x0
  pushl $178
  102544:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102549:	e9 9c 03 00 00       	jmp    1028ea <__alltraps>

0010254e <vector179>:
.globl vector179
vector179:
  pushl $0
  10254e:	6a 00                	push   $0x0
  pushl $179
  102550:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102555:	e9 90 03 00 00       	jmp    1028ea <__alltraps>

0010255a <vector180>:
.globl vector180
vector180:
  pushl $0
  10255a:	6a 00                	push   $0x0
  pushl $180
  10255c:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102561:	e9 84 03 00 00       	jmp    1028ea <__alltraps>

00102566 <vector181>:
.globl vector181
vector181:
  pushl $0
  102566:	6a 00                	push   $0x0
  pushl $181
  102568:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10256d:	e9 78 03 00 00       	jmp    1028ea <__alltraps>

00102572 <vector182>:
.globl vector182
vector182:
  pushl $0
  102572:	6a 00                	push   $0x0
  pushl $182
  102574:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102579:	e9 6c 03 00 00       	jmp    1028ea <__alltraps>

0010257e <vector183>:
.globl vector183
vector183:
  pushl $0
  10257e:	6a 00                	push   $0x0
  pushl $183
  102580:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102585:	e9 60 03 00 00       	jmp    1028ea <__alltraps>

0010258a <vector184>:
.globl vector184
vector184:
  pushl $0
  10258a:	6a 00                	push   $0x0
  pushl $184
  10258c:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102591:	e9 54 03 00 00       	jmp    1028ea <__alltraps>

00102596 <vector185>:
.globl vector185
vector185:
  pushl $0
  102596:	6a 00                	push   $0x0
  pushl $185
  102598:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10259d:	e9 48 03 00 00       	jmp    1028ea <__alltraps>

001025a2 <vector186>:
.globl vector186
vector186:
  pushl $0
  1025a2:	6a 00                	push   $0x0
  pushl $186
  1025a4:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025a9:	e9 3c 03 00 00       	jmp    1028ea <__alltraps>

001025ae <vector187>:
.globl vector187
vector187:
  pushl $0
  1025ae:	6a 00                	push   $0x0
  pushl $187
  1025b0:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025b5:	e9 30 03 00 00       	jmp    1028ea <__alltraps>

001025ba <vector188>:
.globl vector188
vector188:
  pushl $0
  1025ba:	6a 00                	push   $0x0
  pushl $188
  1025bc:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025c1:	e9 24 03 00 00       	jmp    1028ea <__alltraps>

001025c6 <vector189>:
.globl vector189
vector189:
  pushl $0
  1025c6:	6a 00                	push   $0x0
  pushl $189
  1025c8:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025cd:	e9 18 03 00 00       	jmp    1028ea <__alltraps>

001025d2 <vector190>:
.globl vector190
vector190:
  pushl $0
  1025d2:	6a 00                	push   $0x0
  pushl $190
  1025d4:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025d9:	e9 0c 03 00 00       	jmp    1028ea <__alltraps>

001025de <vector191>:
.globl vector191
vector191:
  pushl $0
  1025de:	6a 00                	push   $0x0
  pushl $191
  1025e0:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025e5:	e9 00 03 00 00       	jmp    1028ea <__alltraps>

001025ea <vector192>:
.globl vector192
vector192:
  pushl $0
  1025ea:	6a 00                	push   $0x0
  pushl $192
  1025ec:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025f1:	e9 f4 02 00 00       	jmp    1028ea <__alltraps>

001025f6 <vector193>:
.globl vector193
vector193:
  pushl $0
  1025f6:	6a 00                	push   $0x0
  pushl $193
  1025f8:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025fd:	e9 e8 02 00 00       	jmp    1028ea <__alltraps>

00102602 <vector194>:
.globl vector194
vector194:
  pushl $0
  102602:	6a 00                	push   $0x0
  pushl $194
  102604:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102609:	e9 dc 02 00 00       	jmp    1028ea <__alltraps>

0010260e <vector195>:
.globl vector195
vector195:
  pushl $0
  10260e:	6a 00                	push   $0x0
  pushl $195
  102610:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102615:	e9 d0 02 00 00       	jmp    1028ea <__alltraps>

0010261a <vector196>:
.globl vector196
vector196:
  pushl $0
  10261a:	6a 00                	push   $0x0
  pushl $196
  10261c:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102621:	e9 c4 02 00 00       	jmp    1028ea <__alltraps>

00102626 <vector197>:
.globl vector197
vector197:
  pushl $0
  102626:	6a 00                	push   $0x0
  pushl $197
  102628:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10262d:	e9 b8 02 00 00       	jmp    1028ea <__alltraps>

00102632 <vector198>:
.globl vector198
vector198:
  pushl $0
  102632:	6a 00                	push   $0x0
  pushl $198
  102634:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102639:	e9 ac 02 00 00       	jmp    1028ea <__alltraps>

0010263e <vector199>:
.globl vector199
vector199:
  pushl $0
  10263e:	6a 00                	push   $0x0
  pushl $199
  102640:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102645:	e9 a0 02 00 00       	jmp    1028ea <__alltraps>

0010264a <vector200>:
.globl vector200
vector200:
  pushl $0
  10264a:	6a 00                	push   $0x0
  pushl $200
  10264c:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102651:	e9 94 02 00 00       	jmp    1028ea <__alltraps>

00102656 <vector201>:
.globl vector201
vector201:
  pushl $0
  102656:	6a 00                	push   $0x0
  pushl $201
  102658:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10265d:	e9 88 02 00 00       	jmp    1028ea <__alltraps>

00102662 <vector202>:
.globl vector202
vector202:
  pushl $0
  102662:	6a 00                	push   $0x0
  pushl $202
  102664:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102669:	e9 7c 02 00 00       	jmp    1028ea <__alltraps>

0010266e <vector203>:
.globl vector203
vector203:
  pushl $0
  10266e:	6a 00                	push   $0x0
  pushl $203
  102670:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102675:	e9 70 02 00 00       	jmp    1028ea <__alltraps>

0010267a <vector204>:
.globl vector204
vector204:
  pushl $0
  10267a:	6a 00                	push   $0x0
  pushl $204
  10267c:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102681:	e9 64 02 00 00       	jmp    1028ea <__alltraps>

00102686 <vector205>:
.globl vector205
vector205:
  pushl $0
  102686:	6a 00                	push   $0x0
  pushl $205
  102688:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10268d:	e9 58 02 00 00       	jmp    1028ea <__alltraps>

00102692 <vector206>:
.globl vector206
vector206:
  pushl $0
  102692:	6a 00                	push   $0x0
  pushl $206
  102694:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102699:	e9 4c 02 00 00       	jmp    1028ea <__alltraps>

0010269e <vector207>:
.globl vector207
vector207:
  pushl $0
  10269e:	6a 00                	push   $0x0
  pushl $207
  1026a0:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026a5:	e9 40 02 00 00       	jmp    1028ea <__alltraps>

001026aa <vector208>:
.globl vector208
vector208:
  pushl $0
  1026aa:	6a 00                	push   $0x0
  pushl $208
  1026ac:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026b1:	e9 34 02 00 00       	jmp    1028ea <__alltraps>

001026b6 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026b6:	6a 00                	push   $0x0
  pushl $209
  1026b8:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026bd:	e9 28 02 00 00       	jmp    1028ea <__alltraps>

001026c2 <vector210>:
.globl vector210
vector210:
  pushl $0
  1026c2:	6a 00                	push   $0x0
  pushl $210
  1026c4:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026c9:	e9 1c 02 00 00       	jmp    1028ea <__alltraps>

001026ce <vector211>:
.globl vector211
vector211:
  pushl $0
  1026ce:	6a 00                	push   $0x0
  pushl $211
  1026d0:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026d5:	e9 10 02 00 00       	jmp    1028ea <__alltraps>

001026da <vector212>:
.globl vector212
vector212:
  pushl $0
  1026da:	6a 00                	push   $0x0
  pushl $212
  1026dc:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026e1:	e9 04 02 00 00       	jmp    1028ea <__alltraps>

001026e6 <vector213>:
.globl vector213
vector213:
  pushl $0
  1026e6:	6a 00                	push   $0x0
  pushl $213
  1026e8:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026ed:	e9 f8 01 00 00       	jmp    1028ea <__alltraps>

001026f2 <vector214>:
.globl vector214
vector214:
  pushl $0
  1026f2:	6a 00                	push   $0x0
  pushl $214
  1026f4:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026f9:	e9 ec 01 00 00       	jmp    1028ea <__alltraps>

001026fe <vector215>:
.globl vector215
vector215:
  pushl $0
  1026fe:	6a 00                	push   $0x0
  pushl $215
  102700:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102705:	e9 e0 01 00 00       	jmp    1028ea <__alltraps>

0010270a <vector216>:
.globl vector216
vector216:
  pushl $0
  10270a:	6a 00                	push   $0x0
  pushl $216
  10270c:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102711:	e9 d4 01 00 00       	jmp    1028ea <__alltraps>

00102716 <vector217>:
.globl vector217
vector217:
  pushl $0
  102716:	6a 00                	push   $0x0
  pushl $217
  102718:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10271d:	e9 c8 01 00 00       	jmp    1028ea <__alltraps>

00102722 <vector218>:
.globl vector218
vector218:
  pushl $0
  102722:	6a 00                	push   $0x0
  pushl $218
  102724:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102729:	e9 bc 01 00 00       	jmp    1028ea <__alltraps>

0010272e <vector219>:
.globl vector219
vector219:
  pushl $0
  10272e:	6a 00                	push   $0x0
  pushl $219
  102730:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102735:	e9 b0 01 00 00       	jmp    1028ea <__alltraps>

0010273a <vector220>:
.globl vector220
vector220:
  pushl $0
  10273a:	6a 00                	push   $0x0
  pushl $220
  10273c:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102741:	e9 a4 01 00 00       	jmp    1028ea <__alltraps>

00102746 <vector221>:
.globl vector221
vector221:
  pushl $0
  102746:	6a 00                	push   $0x0
  pushl $221
  102748:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10274d:	e9 98 01 00 00       	jmp    1028ea <__alltraps>

00102752 <vector222>:
.globl vector222
vector222:
  pushl $0
  102752:	6a 00                	push   $0x0
  pushl $222
  102754:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102759:	e9 8c 01 00 00       	jmp    1028ea <__alltraps>

0010275e <vector223>:
.globl vector223
vector223:
  pushl $0
  10275e:	6a 00                	push   $0x0
  pushl $223
  102760:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102765:	e9 80 01 00 00       	jmp    1028ea <__alltraps>

0010276a <vector224>:
.globl vector224
vector224:
  pushl $0
  10276a:	6a 00                	push   $0x0
  pushl $224
  10276c:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102771:	e9 74 01 00 00       	jmp    1028ea <__alltraps>

00102776 <vector225>:
.globl vector225
vector225:
  pushl $0
  102776:	6a 00                	push   $0x0
  pushl $225
  102778:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10277d:	e9 68 01 00 00       	jmp    1028ea <__alltraps>

00102782 <vector226>:
.globl vector226
vector226:
  pushl $0
  102782:	6a 00                	push   $0x0
  pushl $226
  102784:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102789:	e9 5c 01 00 00       	jmp    1028ea <__alltraps>

0010278e <vector227>:
.globl vector227
vector227:
  pushl $0
  10278e:	6a 00                	push   $0x0
  pushl $227
  102790:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102795:	e9 50 01 00 00       	jmp    1028ea <__alltraps>

0010279a <vector228>:
.globl vector228
vector228:
  pushl $0
  10279a:	6a 00                	push   $0x0
  pushl $228
  10279c:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027a1:	e9 44 01 00 00       	jmp    1028ea <__alltraps>

001027a6 <vector229>:
.globl vector229
vector229:
  pushl $0
  1027a6:	6a 00                	push   $0x0
  pushl $229
  1027a8:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027ad:	e9 38 01 00 00       	jmp    1028ea <__alltraps>

001027b2 <vector230>:
.globl vector230
vector230:
  pushl $0
  1027b2:	6a 00                	push   $0x0
  pushl $230
  1027b4:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027b9:	e9 2c 01 00 00       	jmp    1028ea <__alltraps>

001027be <vector231>:
.globl vector231
vector231:
  pushl $0
  1027be:	6a 00                	push   $0x0
  pushl $231
  1027c0:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027c5:	e9 20 01 00 00       	jmp    1028ea <__alltraps>

001027ca <vector232>:
.globl vector232
vector232:
  pushl $0
  1027ca:	6a 00                	push   $0x0
  pushl $232
  1027cc:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027d1:	e9 14 01 00 00       	jmp    1028ea <__alltraps>

001027d6 <vector233>:
.globl vector233
vector233:
  pushl $0
  1027d6:	6a 00                	push   $0x0
  pushl $233
  1027d8:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027dd:	e9 08 01 00 00       	jmp    1028ea <__alltraps>

001027e2 <vector234>:
.globl vector234
vector234:
  pushl $0
  1027e2:	6a 00                	push   $0x0
  pushl $234
  1027e4:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027e9:	e9 fc 00 00 00       	jmp    1028ea <__alltraps>

001027ee <vector235>:
.globl vector235
vector235:
  pushl $0
  1027ee:	6a 00                	push   $0x0
  pushl $235
  1027f0:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027f5:	e9 f0 00 00 00       	jmp    1028ea <__alltraps>

001027fa <vector236>:
.globl vector236
vector236:
  pushl $0
  1027fa:	6a 00                	push   $0x0
  pushl $236
  1027fc:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102801:	e9 e4 00 00 00       	jmp    1028ea <__alltraps>

00102806 <vector237>:
.globl vector237
vector237:
  pushl $0
  102806:	6a 00                	push   $0x0
  pushl $237
  102808:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10280d:	e9 d8 00 00 00       	jmp    1028ea <__alltraps>

00102812 <vector238>:
.globl vector238
vector238:
  pushl $0
  102812:	6a 00                	push   $0x0
  pushl $238
  102814:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102819:	e9 cc 00 00 00       	jmp    1028ea <__alltraps>

0010281e <vector239>:
.globl vector239
vector239:
  pushl $0
  10281e:	6a 00                	push   $0x0
  pushl $239
  102820:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102825:	e9 c0 00 00 00       	jmp    1028ea <__alltraps>

0010282a <vector240>:
.globl vector240
vector240:
  pushl $0
  10282a:	6a 00                	push   $0x0
  pushl $240
  10282c:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102831:	e9 b4 00 00 00       	jmp    1028ea <__alltraps>

00102836 <vector241>:
.globl vector241
vector241:
  pushl $0
  102836:	6a 00                	push   $0x0
  pushl $241
  102838:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10283d:	e9 a8 00 00 00       	jmp    1028ea <__alltraps>

00102842 <vector242>:
.globl vector242
vector242:
  pushl $0
  102842:	6a 00                	push   $0x0
  pushl $242
  102844:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102849:	e9 9c 00 00 00       	jmp    1028ea <__alltraps>

0010284e <vector243>:
.globl vector243
vector243:
  pushl $0
  10284e:	6a 00                	push   $0x0
  pushl $243
  102850:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102855:	e9 90 00 00 00       	jmp    1028ea <__alltraps>

0010285a <vector244>:
.globl vector244
vector244:
  pushl $0
  10285a:	6a 00                	push   $0x0
  pushl $244
  10285c:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102861:	e9 84 00 00 00       	jmp    1028ea <__alltraps>

00102866 <vector245>:
.globl vector245
vector245:
  pushl $0
  102866:	6a 00                	push   $0x0
  pushl $245
  102868:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10286d:	e9 78 00 00 00       	jmp    1028ea <__alltraps>

00102872 <vector246>:
.globl vector246
vector246:
  pushl $0
  102872:	6a 00                	push   $0x0
  pushl $246
  102874:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102879:	e9 6c 00 00 00       	jmp    1028ea <__alltraps>

0010287e <vector247>:
.globl vector247
vector247:
  pushl $0
  10287e:	6a 00                	push   $0x0
  pushl $247
  102880:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102885:	e9 60 00 00 00       	jmp    1028ea <__alltraps>

0010288a <vector248>:
.globl vector248
vector248:
  pushl $0
  10288a:	6a 00                	push   $0x0
  pushl $248
  10288c:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102891:	e9 54 00 00 00       	jmp    1028ea <__alltraps>

00102896 <vector249>:
.globl vector249
vector249:
  pushl $0
  102896:	6a 00                	push   $0x0
  pushl $249
  102898:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10289d:	e9 48 00 00 00       	jmp    1028ea <__alltraps>

001028a2 <vector250>:
.globl vector250
vector250:
  pushl $0
  1028a2:	6a 00                	push   $0x0
  pushl $250
  1028a4:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028a9:	e9 3c 00 00 00       	jmp    1028ea <__alltraps>

001028ae <vector251>:
.globl vector251
vector251:
  pushl $0
  1028ae:	6a 00                	push   $0x0
  pushl $251
  1028b0:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028b5:	e9 30 00 00 00       	jmp    1028ea <__alltraps>

001028ba <vector252>:
.globl vector252
vector252:
  pushl $0
  1028ba:	6a 00                	push   $0x0
  pushl $252
  1028bc:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028c1:	e9 24 00 00 00       	jmp    1028ea <__alltraps>

001028c6 <vector253>:
.globl vector253
vector253:
  pushl $0
  1028c6:	6a 00                	push   $0x0
  pushl $253
  1028c8:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028cd:	e9 18 00 00 00       	jmp    1028ea <__alltraps>

001028d2 <vector254>:
.globl vector254
vector254:
  pushl $0
  1028d2:	6a 00                	push   $0x0
  pushl $254
  1028d4:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028d9:	e9 0c 00 00 00       	jmp    1028ea <__alltraps>

001028de <vector255>:
.globl vector255
vector255:
  pushl $0
  1028de:	6a 00                	push   $0x0
  pushl $255
  1028e0:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028e5:	e9 00 00 00 00       	jmp    1028ea <__alltraps>

001028ea <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1028ea:	1e                   	push   %ds
    pushl %es
  1028eb:	06                   	push   %es
    pushl %fs
  1028ec:	0f a0                	push   %fs
    pushl %gs
  1028ee:	0f a8                	push   %gs
    pushal
  1028f0:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1028f1:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1028f6:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1028f8:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1028fa:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1028fb:	e8 64 f5 ff ff       	call   101e64 <trap>

    # pop the pushed stack pointer
    popl %esp
  102900:	5c                   	pop    %esp

00102901 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102901:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102902:	0f a9                	pop    %gs
    popl %fs
  102904:	0f a1                	pop    %fs
    popl %es
  102906:	07                   	pop    %es
    popl %ds
  102907:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102908:	83 c4 08             	add    $0x8,%esp
    iret
  10290b:	cf                   	iret   

0010290c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10290c:	55                   	push   %ebp
  10290d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10290f:	8b 45 08             	mov    0x8(%ebp),%eax
  102912:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102915:	b8 23 00 00 00       	mov    $0x23,%eax
  10291a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10291c:	b8 23 00 00 00       	mov    $0x23,%eax
  102921:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102923:	b8 10 00 00 00       	mov    $0x10,%eax
  102928:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10292a:	b8 10 00 00 00       	mov    $0x10,%eax
  10292f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102931:	b8 10 00 00 00       	mov    $0x10,%eax
  102936:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102938:	ea 3f 29 10 00 08 00 	ljmp   $0x8,$0x10293f
}
  10293f:	5d                   	pop    %ebp
  102940:	c3                   	ret    

00102941 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102941:	55                   	push   %ebp
  102942:	89 e5                	mov    %esp,%ebp
  102944:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102947:	b8 80 fa 10 00       	mov    $0x10fa80,%eax
  10294c:	05 00 04 00 00       	add    $0x400,%eax
  102951:	a3 84 f9 10 00       	mov    %eax,0x10f984
    ts.ts_ss0 = KERNEL_DS;
  102956:	66 c7 05 88 f9 10 00 	movw   $0x10,0x10f988
  10295d:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10295f:	66 c7 05 48 ea 10 00 	movw   $0x68,0x10ea48
  102966:	68 00 
  102968:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  10296d:	66 a3 4a ea 10 00    	mov    %ax,0x10ea4a
  102973:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  102978:	c1 e8 10             	shr    $0x10,%eax
  10297b:	a2 4c ea 10 00       	mov    %al,0x10ea4c
  102980:	0f b6 05 4d ea 10 00 	movzbl 0x10ea4d,%eax
  102987:	83 e0 f0             	and    $0xfffffff0,%eax
  10298a:	83 c8 09             	or     $0x9,%eax
  10298d:	a2 4d ea 10 00       	mov    %al,0x10ea4d
  102992:	0f b6 05 4d ea 10 00 	movzbl 0x10ea4d,%eax
  102999:	83 c8 10             	or     $0x10,%eax
  10299c:	a2 4d ea 10 00       	mov    %al,0x10ea4d
  1029a1:	0f b6 05 4d ea 10 00 	movzbl 0x10ea4d,%eax
  1029a8:	83 e0 9f             	and    $0xffffff9f,%eax
  1029ab:	a2 4d ea 10 00       	mov    %al,0x10ea4d
  1029b0:	0f b6 05 4d ea 10 00 	movzbl 0x10ea4d,%eax
  1029b7:	83 c8 80             	or     $0xffffff80,%eax
  1029ba:	a2 4d ea 10 00       	mov    %al,0x10ea4d
  1029bf:	0f b6 05 4e ea 10 00 	movzbl 0x10ea4e,%eax
  1029c6:	83 e0 f0             	and    $0xfffffff0,%eax
  1029c9:	a2 4e ea 10 00       	mov    %al,0x10ea4e
  1029ce:	0f b6 05 4e ea 10 00 	movzbl 0x10ea4e,%eax
  1029d5:	83 e0 ef             	and    $0xffffffef,%eax
  1029d8:	a2 4e ea 10 00       	mov    %al,0x10ea4e
  1029dd:	0f b6 05 4e ea 10 00 	movzbl 0x10ea4e,%eax
  1029e4:	83 e0 df             	and    $0xffffffdf,%eax
  1029e7:	a2 4e ea 10 00       	mov    %al,0x10ea4e
  1029ec:	0f b6 05 4e ea 10 00 	movzbl 0x10ea4e,%eax
  1029f3:	83 c8 40             	or     $0x40,%eax
  1029f6:	a2 4e ea 10 00       	mov    %al,0x10ea4e
  1029fb:	0f b6 05 4e ea 10 00 	movzbl 0x10ea4e,%eax
  102a02:	83 e0 7f             	and    $0x7f,%eax
  102a05:	a2 4e ea 10 00       	mov    %al,0x10ea4e
  102a0a:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  102a0f:	c1 e8 18             	shr    $0x18,%eax
  102a12:	a2 4f ea 10 00       	mov    %al,0x10ea4f
    gdt[SEG_TSS].sd_s = 0;
  102a17:	0f b6 05 4d ea 10 00 	movzbl 0x10ea4d,%eax
  102a1e:	83 e0 ef             	and    $0xffffffef,%eax
  102a21:	a2 4d ea 10 00       	mov    %al,0x10ea4d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a26:	68 50 ea 10 00       	push   $0x10ea50
  102a2b:	e8 dc fe ff ff       	call   10290c <lgdt>
  102a30:	83 c4 04             	add    $0x4,%esp
  102a33:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a39:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a3d:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102a40:	c9                   	leave  
  102a41:	c3                   	ret    

00102a42 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102a42:	55                   	push   %ebp
  102a43:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a45:	e8 f7 fe ff ff       	call   102941 <gdt_init>
}
  102a4a:	5d                   	pop    %ebp
  102a4b:	c3                   	ret    

00102a4c <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102a4c:	55                   	push   %ebp
  102a4d:	89 e5                	mov    %esp,%ebp
  102a4f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102a52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102a59:	eb 04                	jmp    102a5f <strlen+0x13>
        cnt ++;
  102a5b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  102a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a62:	8d 50 01             	lea    0x1(%eax),%edx
  102a65:	89 55 08             	mov    %edx,0x8(%ebp)
  102a68:	0f b6 00             	movzbl (%eax),%eax
  102a6b:	84 c0                	test   %al,%al
  102a6d:	75 ec                	jne    102a5b <strlen+0xf>
    }
    return cnt;
  102a6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102a72:	c9                   	leave  
  102a73:	c3                   	ret    

00102a74 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102a74:	55                   	push   %ebp
  102a75:	89 e5                	mov    %esp,%ebp
  102a77:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102a7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102a81:	eb 04                	jmp    102a87 <strnlen+0x13>
        cnt ++;
  102a83:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102a87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a8a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102a8d:	73 10                	jae    102a9f <strnlen+0x2b>
  102a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a92:	8d 50 01             	lea    0x1(%eax),%edx
  102a95:	89 55 08             	mov    %edx,0x8(%ebp)
  102a98:	0f b6 00             	movzbl (%eax),%eax
  102a9b:	84 c0                	test   %al,%al
  102a9d:	75 e4                	jne    102a83 <strnlen+0xf>
    }
    return cnt;
  102a9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102aa2:	c9                   	leave  
  102aa3:	c3                   	ret    

00102aa4 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102aa4:	55                   	push   %ebp
  102aa5:	89 e5                	mov    %esp,%ebp
  102aa7:	57                   	push   %edi
  102aa8:	56                   	push   %esi
  102aa9:	83 ec 20             	sub    $0x20,%esp
  102aac:	8b 45 08             	mov    0x8(%ebp),%eax
  102aaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102ab8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102abe:	89 d1                	mov    %edx,%ecx
  102ac0:	89 c2                	mov    %eax,%edx
  102ac2:	89 ce                	mov    %ecx,%esi
  102ac4:	89 d7                	mov    %edx,%edi
  102ac6:	ac                   	lods   %ds:(%esi),%al
  102ac7:	aa                   	stos   %al,%es:(%edi)
  102ac8:	84 c0                	test   %al,%al
  102aca:	75 fa                	jne    102ac6 <strcpy+0x22>
  102acc:	89 fa                	mov    %edi,%edx
  102ace:	89 f1                	mov    %esi,%ecx
  102ad0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102ad3:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102ad6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102adc:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102add:	83 c4 20             	add    $0x20,%esp
  102ae0:	5e                   	pop    %esi
  102ae1:	5f                   	pop    %edi
  102ae2:	5d                   	pop    %ebp
  102ae3:	c3                   	ret    

00102ae4 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102ae4:	55                   	push   %ebp
  102ae5:	89 e5                	mov    %esp,%ebp
  102ae7:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102aea:	8b 45 08             	mov    0x8(%ebp),%eax
  102aed:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102af0:	eb 21                	jmp    102b13 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102af5:	0f b6 10             	movzbl (%eax),%edx
  102af8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102afb:	88 10                	mov    %dl,(%eax)
  102afd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b00:	0f b6 00             	movzbl (%eax),%eax
  102b03:	84 c0                	test   %al,%al
  102b05:	74 04                	je     102b0b <strncpy+0x27>
            src ++;
  102b07:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102b0b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102b0f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  102b13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b17:	75 d9                	jne    102af2 <strncpy+0xe>
    }
    return dst;
  102b19:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102b1c:	c9                   	leave  
  102b1d:	c3                   	ret    

00102b1e <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102b1e:	55                   	push   %ebp
  102b1f:	89 e5                	mov    %esp,%ebp
  102b21:	57                   	push   %edi
  102b22:	56                   	push   %esi
  102b23:	83 ec 20             	sub    $0x20,%esp
  102b26:	8b 45 08             	mov    0x8(%ebp),%eax
  102b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b38:	89 d1                	mov    %edx,%ecx
  102b3a:	89 c2                	mov    %eax,%edx
  102b3c:	89 ce                	mov    %ecx,%esi
  102b3e:	89 d7                	mov    %edx,%edi
  102b40:	ac                   	lods   %ds:(%esi),%al
  102b41:	ae                   	scas   %es:(%edi),%al
  102b42:	75 08                	jne    102b4c <strcmp+0x2e>
  102b44:	84 c0                	test   %al,%al
  102b46:	75 f8                	jne    102b40 <strcmp+0x22>
  102b48:	31 c0                	xor    %eax,%eax
  102b4a:	eb 04                	jmp    102b50 <strcmp+0x32>
  102b4c:	19 c0                	sbb    %eax,%eax
  102b4e:	0c 01                	or     $0x1,%al
  102b50:	89 fa                	mov    %edi,%edx
  102b52:	89 f1                	mov    %esi,%ecx
  102b54:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102b57:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102b5a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102b60:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102b61:	83 c4 20             	add    $0x20,%esp
  102b64:	5e                   	pop    %esi
  102b65:	5f                   	pop    %edi
  102b66:	5d                   	pop    %ebp
  102b67:	c3                   	ret    

00102b68 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102b68:	55                   	push   %ebp
  102b69:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102b6b:	eb 0c                	jmp    102b79 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102b6d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102b71:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b75:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102b79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b7d:	74 1a                	je     102b99 <strncmp+0x31>
  102b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b82:	0f b6 00             	movzbl (%eax),%eax
  102b85:	84 c0                	test   %al,%al
  102b87:	74 10                	je     102b99 <strncmp+0x31>
  102b89:	8b 45 08             	mov    0x8(%ebp),%eax
  102b8c:	0f b6 10             	movzbl (%eax),%edx
  102b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b92:	0f b6 00             	movzbl (%eax),%eax
  102b95:	38 c2                	cmp    %al,%dl
  102b97:	74 d4                	je     102b6d <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102b99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b9d:	74 18                	je     102bb7 <strncmp+0x4f>
  102b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba2:	0f b6 00             	movzbl (%eax),%eax
  102ba5:	0f b6 d0             	movzbl %al,%edx
  102ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bab:	0f b6 00             	movzbl (%eax),%eax
  102bae:	0f b6 c0             	movzbl %al,%eax
  102bb1:	29 c2                	sub    %eax,%edx
  102bb3:	89 d0                	mov    %edx,%eax
  102bb5:	eb 05                	jmp    102bbc <strncmp+0x54>
  102bb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102bbc:	5d                   	pop    %ebp
  102bbd:	c3                   	ret    

00102bbe <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102bbe:	55                   	push   %ebp
  102bbf:	89 e5                	mov    %esp,%ebp
  102bc1:	83 ec 04             	sub    $0x4,%esp
  102bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bc7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102bca:	eb 14                	jmp    102be0 <strchr+0x22>
        if (*s == c) {
  102bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  102bcf:	0f b6 00             	movzbl (%eax),%eax
  102bd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102bd5:	75 05                	jne    102bdc <strchr+0x1e>
            return (char *)s;
  102bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  102bda:	eb 13                	jmp    102bef <strchr+0x31>
        }
        s ++;
  102bdc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102be0:	8b 45 08             	mov    0x8(%ebp),%eax
  102be3:	0f b6 00             	movzbl (%eax),%eax
  102be6:	84 c0                	test   %al,%al
  102be8:	75 e2                	jne    102bcc <strchr+0xe>
    }
    return NULL;
  102bea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102bef:	c9                   	leave  
  102bf0:	c3                   	ret    

00102bf1 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102bf1:	55                   	push   %ebp
  102bf2:	89 e5                	mov    %esp,%ebp
  102bf4:	83 ec 04             	sub    $0x4,%esp
  102bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bfa:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102bfd:	eb 11                	jmp    102c10 <strfind+0x1f>
        if (*s == c) {
  102bff:	8b 45 08             	mov    0x8(%ebp),%eax
  102c02:	0f b6 00             	movzbl (%eax),%eax
  102c05:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102c08:	75 02                	jne    102c0c <strfind+0x1b>
            break;
  102c0a:	eb 0e                	jmp    102c1a <strfind+0x29>
        }
        s ++;
  102c0c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102c10:	8b 45 08             	mov    0x8(%ebp),%eax
  102c13:	0f b6 00             	movzbl (%eax),%eax
  102c16:	84 c0                	test   %al,%al
  102c18:	75 e5                	jne    102bff <strfind+0xe>
    }
    return (char *)s;
  102c1a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102c1d:	c9                   	leave  
  102c1e:	c3                   	ret    

00102c1f <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102c1f:	55                   	push   %ebp
  102c20:	89 e5                	mov    %esp,%ebp
  102c22:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102c2c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102c33:	eb 04                	jmp    102c39 <strtol+0x1a>
        s ++;
  102c35:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102c39:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3c:	0f b6 00             	movzbl (%eax),%eax
  102c3f:	3c 20                	cmp    $0x20,%al
  102c41:	74 f2                	je     102c35 <strtol+0x16>
  102c43:	8b 45 08             	mov    0x8(%ebp),%eax
  102c46:	0f b6 00             	movzbl (%eax),%eax
  102c49:	3c 09                	cmp    $0x9,%al
  102c4b:	74 e8                	je     102c35 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c50:	0f b6 00             	movzbl (%eax),%eax
  102c53:	3c 2b                	cmp    $0x2b,%al
  102c55:	75 06                	jne    102c5d <strtol+0x3e>
        s ++;
  102c57:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c5b:	eb 15                	jmp    102c72 <strtol+0x53>
    }
    else if (*s == '-') {
  102c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c60:	0f b6 00             	movzbl (%eax),%eax
  102c63:	3c 2d                	cmp    $0x2d,%al
  102c65:	75 0b                	jne    102c72 <strtol+0x53>
        s ++, neg = 1;
  102c67:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c6b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102c72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c76:	74 06                	je     102c7e <strtol+0x5f>
  102c78:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102c7c:	75 24                	jne    102ca2 <strtol+0x83>
  102c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c81:	0f b6 00             	movzbl (%eax),%eax
  102c84:	3c 30                	cmp    $0x30,%al
  102c86:	75 1a                	jne    102ca2 <strtol+0x83>
  102c88:	8b 45 08             	mov    0x8(%ebp),%eax
  102c8b:	83 c0 01             	add    $0x1,%eax
  102c8e:	0f b6 00             	movzbl (%eax),%eax
  102c91:	3c 78                	cmp    $0x78,%al
  102c93:	75 0d                	jne    102ca2 <strtol+0x83>
        s += 2, base = 16;
  102c95:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102c99:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102ca0:	eb 2a                	jmp    102ccc <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102ca2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ca6:	75 17                	jne    102cbf <strtol+0xa0>
  102ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  102cab:	0f b6 00             	movzbl (%eax),%eax
  102cae:	3c 30                	cmp    $0x30,%al
  102cb0:	75 0d                	jne    102cbf <strtol+0xa0>
        s ++, base = 8;
  102cb2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102cb6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102cbd:	eb 0d                	jmp    102ccc <strtol+0xad>
    }
    else if (base == 0) {
  102cbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cc3:	75 07                	jne    102ccc <strtol+0xad>
        base = 10;
  102cc5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  102ccf:	0f b6 00             	movzbl (%eax),%eax
  102cd2:	3c 2f                	cmp    $0x2f,%al
  102cd4:	7e 1b                	jle    102cf1 <strtol+0xd2>
  102cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd9:	0f b6 00             	movzbl (%eax),%eax
  102cdc:	3c 39                	cmp    $0x39,%al
  102cde:	7f 11                	jg     102cf1 <strtol+0xd2>
            dig = *s - '0';
  102ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce3:	0f b6 00             	movzbl (%eax),%eax
  102ce6:	0f be c0             	movsbl %al,%eax
  102ce9:	83 e8 30             	sub    $0x30,%eax
  102cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cef:	eb 48                	jmp    102d39 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf4:	0f b6 00             	movzbl (%eax),%eax
  102cf7:	3c 60                	cmp    $0x60,%al
  102cf9:	7e 1b                	jle    102d16 <strtol+0xf7>
  102cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfe:	0f b6 00             	movzbl (%eax),%eax
  102d01:	3c 7a                	cmp    $0x7a,%al
  102d03:	7f 11                	jg     102d16 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102d05:	8b 45 08             	mov    0x8(%ebp),%eax
  102d08:	0f b6 00             	movzbl (%eax),%eax
  102d0b:	0f be c0             	movsbl %al,%eax
  102d0e:	83 e8 57             	sub    $0x57,%eax
  102d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d14:	eb 23                	jmp    102d39 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102d16:	8b 45 08             	mov    0x8(%ebp),%eax
  102d19:	0f b6 00             	movzbl (%eax),%eax
  102d1c:	3c 40                	cmp    $0x40,%al
  102d1e:	7e 3d                	jle    102d5d <strtol+0x13e>
  102d20:	8b 45 08             	mov    0x8(%ebp),%eax
  102d23:	0f b6 00             	movzbl (%eax),%eax
  102d26:	3c 5a                	cmp    $0x5a,%al
  102d28:	7f 33                	jg     102d5d <strtol+0x13e>
            dig = *s - 'A' + 10;
  102d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2d:	0f b6 00             	movzbl (%eax),%eax
  102d30:	0f be c0             	movsbl %al,%eax
  102d33:	83 e8 37             	sub    $0x37,%eax
  102d36:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d3c:	3b 45 10             	cmp    0x10(%ebp),%eax
  102d3f:	7c 02                	jl     102d43 <strtol+0x124>
            break;
  102d41:	eb 1a                	jmp    102d5d <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  102d43:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d4a:	0f af 45 10          	imul   0x10(%ebp),%eax
  102d4e:	89 c2                	mov    %eax,%edx
  102d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d53:	01 d0                	add    %edx,%eax
  102d55:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102d58:	e9 6f ff ff ff       	jmp    102ccc <strtol+0xad>

    if (endptr) {
  102d5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102d61:	74 08                	je     102d6b <strtol+0x14c>
        *endptr = (char *) s;
  102d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d66:	8b 55 08             	mov    0x8(%ebp),%edx
  102d69:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102d6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102d6f:	74 07                	je     102d78 <strtol+0x159>
  102d71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d74:	f7 d8                	neg    %eax
  102d76:	eb 03                	jmp    102d7b <strtol+0x15c>
  102d78:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102d7b:	c9                   	leave  
  102d7c:	c3                   	ret    

00102d7d <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102d7d:	55                   	push   %ebp
  102d7e:	89 e5                	mov    %esp,%ebp
  102d80:	57                   	push   %edi
  102d81:	83 ec 24             	sub    $0x24,%esp
  102d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d87:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102d8a:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102d8e:	8b 55 08             	mov    0x8(%ebp),%edx
  102d91:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102d94:	88 45 f7             	mov    %al,-0x9(%ebp)
  102d97:	8b 45 10             	mov    0x10(%ebp),%eax
  102d9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102d9d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102da0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102da4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102da7:	89 d7                	mov    %edx,%edi
  102da9:	f3 aa                	rep stos %al,%es:(%edi)
  102dab:	89 fa                	mov    %edi,%edx
  102dad:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102db0:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102db3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102db6:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102db7:	83 c4 24             	add    $0x24,%esp
  102dba:	5f                   	pop    %edi
  102dbb:	5d                   	pop    %ebp
  102dbc:	c3                   	ret    

00102dbd <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102dbd:	55                   	push   %ebp
  102dbe:	89 e5                	mov    %esp,%ebp
  102dc0:	57                   	push   %edi
  102dc1:	56                   	push   %esi
  102dc2:	53                   	push   %ebx
  102dc3:	83 ec 30             	sub    $0x30,%esp
  102dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102dd2:	8b 45 10             	mov    0x10(%ebp),%eax
  102dd5:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ddb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102dde:	73 42                	jae    102e22 <memmove+0x65>
  102de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102de3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102de6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102de9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102dec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102def:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102df2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102df5:	c1 e8 02             	shr    $0x2,%eax
  102df8:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102dfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102dfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e00:	89 d7                	mov    %edx,%edi
  102e02:	89 c6                	mov    %eax,%esi
  102e04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102e06:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102e09:	83 e1 03             	and    $0x3,%ecx
  102e0c:	74 02                	je     102e10 <memmove+0x53>
  102e0e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e10:	89 f0                	mov    %esi,%eax
  102e12:	89 fa                	mov    %edi,%edx
  102e14:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102e17:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102e1a:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102e20:	eb 36                	jmp    102e58 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e25:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e2b:	01 c2                	add    %eax,%edx
  102e2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e30:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e36:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102e39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e3c:	89 c1                	mov    %eax,%ecx
  102e3e:	89 d8                	mov    %ebx,%eax
  102e40:	89 d6                	mov    %edx,%esi
  102e42:	89 c7                	mov    %eax,%edi
  102e44:	fd                   	std    
  102e45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e47:	fc                   	cld    
  102e48:	89 f8                	mov    %edi,%eax
  102e4a:	89 f2                	mov    %esi,%edx
  102e4c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102e4f:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102e52:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102e58:	83 c4 30             	add    $0x30,%esp
  102e5b:	5b                   	pop    %ebx
  102e5c:	5e                   	pop    %esi
  102e5d:	5f                   	pop    %edi
  102e5e:	5d                   	pop    %ebp
  102e5f:	c3                   	ret    

00102e60 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102e60:	55                   	push   %ebp
  102e61:	89 e5                	mov    %esp,%ebp
  102e63:	57                   	push   %edi
  102e64:	56                   	push   %esi
  102e65:	83 ec 20             	sub    $0x20,%esp
  102e68:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e74:	8b 45 10             	mov    0x10(%ebp),%eax
  102e77:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102e7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e7d:	c1 e8 02             	shr    $0x2,%eax
  102e80:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102e82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e88:	89 d7                	mov    %edx,%edi
  102e8a:	89 c6                	mov    %eax,%esi
  102e8c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102e8e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102e91:	83 e1 03             	and    $0x3,%ecx
  102e94:	74 02                	je     102e98 <memcpy+0x38>
  102e96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e98:	89 f0                	mov    %esi,%eax
  102e9a:	89 fa                	mov    %edi,%edx
  102e9c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102e9f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102ea2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102ea8:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102ea9:	83 c4 20             	add    $0x20,%esp
  102eac:	5e                   	pop    %esi
  102ead:	5f                   	pop    %edi
  102eae:	5d                   	pop    %ebp
  102eaf:	c3                   	ret    

00102eb0 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102eb0:	55                   	push   %ebp
  102eb1:	89 e5                	mov    %esp,%ebp
  102eb3:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ebf:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102ec2:	eb 30                	jmp    102ef4 <memcmp+0x44>
        if (*s1 != *s2) {
  102ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ec7:	0f b6 10             	movzbl (%eax),%edx
  102eca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ecd:	0f b6 00             	movzbl (%eax),%eax
  102ed0:	38 c2                	cmp    %al,%dl
  102ed2:	74 18                	je     102eec <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102ed4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ed7:	0f b6 00             	movzbl (%eax),%eax
  102eda:	0f b6 d0             	movzbl %al,%edx
  102edd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ee0:	0f b6 00             	movzbl (%eax),%eax
  102ee3:	0f b6 c0             	movzbl %al,%eax
  102ee6:	29 c2                	sub    %eax,%edx
  102ee8:	89 d0                	mov    %edx,%eax
  102eea:	eb 1a                	jmp    102f06 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102eec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102ef0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  102ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  102ef7:	8d 50 ff             	lea    -0x1(%eax),%edx
  102efa:	89 55 10             	mov    %edx,0x10(%ebp)
  102efd:	85 c0                	test   %eax,%eax
  102eff:	75 c3                	jne    102ec4 <memcmp+0x14>
    }
    return 0;
  102f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f06:	c9                   	leave  
  102f07:	c3                   	ret    

00102f08 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102f08:	55                   	push   %ebp
  102f09:	89 e5                	mov    %esp,%ebp
  102f0b:	83 ec 38             	sub    $0x38,%esp
  102f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  102f11:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f14:	8b 45 14             	mov    0x14(%ebp),%eax
  102f17:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102f1a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f1d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f20:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f23:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102f26:	8b 45 18             	mov    0x18(%ebp),%eax
  102f29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102f2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f32:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f35:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102f42:	74 1c                	je     102f60 <printnum+0x58>
  102f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f47:	ba 00 00 00 00       	mov    $0x0,%edx
  102f4c:	f7 75 e4             	divl   -0x1c(%ebp)
  102f4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f55:	ba 00 00 00 00       	mov    $0x0,%edx
  102f5a:	f7 75 e4             	divl   -0x1c(%ebp)
  102f5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f66:	f7 75 e4             	divl   -0x1c(%ebp)
  102f69:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f6c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102f6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102f75:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f78:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102f7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f7e:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102f81:	8b 45 18             	mov    0x18(%ebp),%eax
  102f84:	ba 00 00 00 00       	mov    $0x0,%edx
  102f89:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102f8c:	77 41                	ja     102fcf <printnum+0xc7>
  102f8e:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102f91:	72 05                	jb     102f98 <printnum+0x90>
  102f93:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102f96:	77 37                	ja     102fcf <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102f98:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102f9b:	83 e8 01             	sub    $0x1,%eax
  102f9e:	83 ec 04             	sub    $0x4,%esp
  102fa1:	ff 75 20             	pushl  0x20(%ebp)
  102fa4:	50                   	push   %eax
  102fa5:	ff 75 18             	pushl  0x18(%ebp)
  102fa8:	ff 75 ec             	pushl  -0x14(%ebp)
  102fab:	ff 75 e8             	pushl  -0x18(%ebp)
  102fae:	ff 75 0c             	pushl  0xc(%ebp)
  102fb1:	ff 75 08             	pushl  0x8(%ebp)
  102fb4:	e8 4f ff ff ff       	call   102f08 <printnum>
  102fb9:	83 c4 20             	add    $0x20,%esp
  102fbc:	eb 1b                	jmp    102fd9 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102fbe:	83 ec 08             	sub    $0x8,%esp
  102fc1:	ff 75 0c             	pushl  0xc(%ebp)
  102fc4:	ff 75 20             	pushl  0x20(%ebp)
  102fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  102fca:	ff d0                	call   *%eax
  102fcc:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  102fcf:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102fd3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102fd7:	7f e5                	jg     102fbe <printnum+0xb6>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102fd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102fdc:	05 10 3d 10 00       	add    $0x103d10,%eax
  102fe1:	0f b6 00             	movzbl (%eax),%eax
  102fe4:	0f be c0             	movsbl %al,%eax
  102fe7:	83 ec 08             	sub    $0x8,%esp
  102fea:	ff 75 0c             	pushl  0xc(%ebp)
  102fed:	50                   	push   %eax
  102fee:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff1:	ff d0                	call   *%eax
  102ff3:	83 c4 10             	add    $0x10,%esp
}
  102ff6:	c9                   	leave  
  102ff7:	c3                   	ret    

00102ff8 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102ff8:	55                   	push   %ebp
  102ff9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102ffb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102fff:	7e 14                	jle    103015 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  103001:	8b 45 08             	mov    0x8(%ebp),%eax
  103004:	8b 00                	mov    (%eax),%eax
  103006:	8d 48 08             	lea    0x8(%eax),%ecx
  103009:	8b 55 08             	mov    0x8(%ebp),%edx
  10300c:	89 0a                	mov    %ecx,(%edx)
  10300e:	8b 50 04             	mov    0x4(%eax),%edx
  103011:	8b 00                	mov    (%eax),%eax
  103013:	eb 30                	jmp    103045 <getuint+0x4d>
    }
    else if (lflag) {
  103015:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103019:	74 16                	je     103031 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10301b:	8b 45 08             	mov    0x8(%ebp),%eax
  10301e:	8b 00                	mov    (%eax),%eax
  103020:	8d 48 04             	lea    0x4(%eax),%ecx
  103023:	8b 55 08             	mov    0x8(%ebp),%edx
  103026:	89 0a                	mov    %ecx,(%edx)
  103028:	8b 00                	mov    (%eax),%eax
  10302a:	ba 00 00 00 00       	mov    $0x0,%edx
  10302f:	eb 14                	jmp    103045 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  103031:	8b 45 08             	mov    0x8(%ebp),%eax
  103034:	8b 00                	mov    (%eax),%eax
  103036:	8d 48 04             	lea    0x4(%eax),%ecx
  103039:	8b 55 08             	mov    0x8(%ebp),%edx
  10303c:	89 0a                	mov    %ecx,(%edx)
  10303e:	8b 00                	mov    (%eax),%eax
  103040:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  103045:	5d                   	pop    %ebp
  103046:	c3                   	ret    

00103047 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  103047:	55                   	push   %ebp
  103048:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10304a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10304e:	7e 14                	jle    103064 <getint+0x1d>
        return va_arg(*ap, long long);
  103050:	8b 45 08             	mov    0x8(%ebp),%eax
  103053:	8b 00                	mov    (%eax),%eax
  103055:	8d 48 08             	lea    0x8(%eax),%ecx
  103058:	8b 55 08             	mov    0x8(%ebp),%edx
  10305b:	89 0a                	mov    %ecx,(%edx)
  10305d:	8b 50 04             	mov    0x4(%eax),%edx
  103060:	8b 00                	mov    (%eax),%eax
  103062:	eb 28                	jmp    10308c <getint+0x45>
    }
    else if (lflag) {
  103064:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103068:	74 12                	je     10307c <getint+0x35>
        return va_arg(*ap, long);
  10306a:	8b 45 08             	mov    0x8(%ebp),%eax
  10306d:	8b 00                	mov    (%eax),%eax
  10306f:	8d 48 04             	lea    0x4(%eax),%ecx
  103072:	8b 55 08             	mov    0x8(%ebp),%edx
  103075:	89 0a                	mov    %ecx,(%edx)
  103077:	8b 00                	mov    (%eax),%eax
  103079:	99                   	cltd   
  10307a:	eb 10                	jmp    10308c <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10307c:	8b 45 08             	mov    0x8(%ebp),%eax
  10307f:	8b 00                	mov    (%eax),%eax
  103081:	8d 48 04             	lea    0x4(%eax),%ecx
  103084:	8b 55 08             	mov    0x8(%ebp),%edx
  103087:	89 0a                	mov    %ecx,(%edx)
  103089:	8b 00                	mov    (%eax),%eax
  10308b:	99                   	cltd   
    }
}
  10308c:	5d                   	pop    %ebp
  10308d:	c3                   	ret    

0010308e <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10308e:	55                   	push   %ebp
  10308f:	89 e5                	mov    %esp,%ebp
  103091:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  103094:	8d 45 14             	lea    0x14(%ebp),%eax
  103097:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10309d:	50                   	push   %eax
  10309e:	ff 75 10             	pushl  0x10(%ebp)
  1030a1:	ff 75 0c             	pushl  0xc(%ebp)
  1030a4:	ff 75 08             	pushl  0x8(%ebp)
  1030a7:	e8 05 00 00 00       	call   1030b1 <vprintfmt>
  1030ac:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1030af:	c9                   	leave  
  1030b0:	c3                   	ret    

001030b1 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1030b1:	55                   	push   %ebp
  1030b2:	89 e5                	mov    %esp,%ebp
  1030b4:	56                   	push   %esi
  1030b5:	53                   	push   %ebx
  1030b6:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1030b9:	eb 18                	jmp    1030d3 <vprintfmt+0x22>
            if (ch == '\0') {
  1030bb:	85 db                	test   %ebx,%ebx
  1030bd:	75 05                	jne    1030c4 <vprintfmt+0x13>
                return;
  1030bf:	e9 8b 03 00 00       	jmp    10344f <vprintfmt+0x39e>
            }
            putch(ch, putdat);
  1030c4:	83 ec 08             	sub    $0x8,%esp
  1030c7:	ff 75 0c             	pushl  0xc(%ebp)
  1030ca:	53                   	push   %ebx
  1030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ce:	ff d0                	call   *%eax
  1030d0:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1030d3:	8b 45 10             	mov    0x10(%ebp),%eax
  1030d6:	8d 50 01             	lea    0x1(%eax),%edx
  1030d9:	89 55 10             	mov    %edx,0x10(%ebp)
  1030dc:	0f b6 00             	movzbl (%eax),%eax
  1030df:	0f b6 d8             	movzbl %al,%ebx
  1030e2:	83 fb 25             	cmp    $0x25,%ebx
  1030e5:	75 d4                	jne    1030bb <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1030e7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1030eb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1030f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1030f8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1030ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103102:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103105:	8b 45 10             	mov    0x10(%ebp),%eax
  103108:	8d 50 01             	lea    0x1(%eax),%edx
  10310b:	89 55 10             	mov    %edx,0x10(%ebp)
  10310e:	0f b6 00             	movzbl (%eax),%eax
  103111:	0f b6 d8             	movzbl %al,%ebx
  103114:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103117:	83 f8 55             	cmp    $0x55,%eax
  10311a:	0f 87 02 03 00 00    	ja     103422 <vprintfmt+0x371>
  103120:	8b 04 85 34 3d 10 00 	mov    0x103d34(,%eax,4),%eax
  103127:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103129:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10312d:	eb d6                	jmp    103105 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10312f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  103133:	eb d0                	jmp    103105 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103135:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10313c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10313f:	89 d0                	mov    %edx,%eax
  103141:	c1 e0 02             	shl    $0x2,%eax
  103144:	01 d0                	add    %edx,%eax
  103146:	01 c0                	add    %eax,%eax
  103148:	01 d8                	add    %ebx,%eax
  10314a:	83 e8 30             	sub    $0x30,%eax
  10314d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  103150:	8b 45 10             	mov    0x10(%ebp),%eax
  103153:	0f b6 00             	movzbl (%eax),%eax
  103156:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  103159:	83 fb 2f             	cmp    $0x2f,%ebx
  10315c:	7e 0b                	jle    103169 <vprintfmt+0xb8>
  10315e:	83 fb 39             	cmp    $0x39,%ebx
  103161:	7f 06                	jg     103169 <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
  103163:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
  103167:	eb d3                	jmp    10313c <vprintfmt+0x8b>
            goto process_precision;
  103169:	eb 2e                	jmp    103199 <vprintfmt+0xe8>

        case '*':
            precision = va_arg(ap, int);
  10316b:	8b 45 14             	mov    0x14(%ebp),%eax
  10316e:	8d 50 04             	lea    0x4(%eax),%edx
  103171:	89 55 14             	mov    %edx,0x14(%ebp)
  103174:	8b 00                	mov    (%eax),%eax
  103176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103179:	eb 1e                	jmp    103199 <vprintfmt+0xe8>

        case '.':
            if (width < 0)
  10317b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10317f:	79 07                	jns    103188 <vprintfmt+0xd7>
                width = 0;
  103181:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103188:	e9 78 ff ff ff       	jmp    103105 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  10318d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  103194:	e9 6c ff ff ff       	jmp    103105 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  103199:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10319d:	79 0d                	jns    1031ac <vprintfmt+0xfb>
                width = precision, precision = -1;
  10319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031a5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1031ac:	e9 54 ff ff ff       	jmp    103105 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1031b1:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1031b5:	e9 4b ff ff ff       	jmp    103105 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1031ba:	8b 45 14             	mov    0x14(%ebp),%eax
  1031bd:	8d 50 04             	lea    0x4(%eax),%edx
  1031c0:	89 55 14             	mov    %edx,0x14(%ebp)
  1031c3:	8b 00                	mov    (%eax),%eax
  1031c5:	83 ec 08             	sub    $0x8,%esp
  1031c8:	ff 75 0c             	pushl  0xc(%ebp)
  1031cb:	50                   	push   %eax
  1031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1031cf:	ff d0                	call   *%eax
  1031d1:	83 c4 10             	add    $0x10,%esp
            break;
  1031d4:	e9 71 02 00 00       	jmp    10344a <vprintfmt+0x399>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1031d9:	8b 45 14             	mov    0x14(%ebp),%eax
  1031dc:	8d 50 04             	lea    0x4(%eax),%edx
  1031df:	89 55 14             	mov    %edx,0x14(%ebp)
  1031e2:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1031e4:	85 db                	test   %ebx,%ebx
  1031e6:	79 02                	jns    1031ea <vprintfmt+0x139>
                err = -err;
  1031e8:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1031ea:	83 fb 06             	cmp    $0x6,%ebx
  1031ed:	7f 0b                	jg     1031fa <vprintfmt+0x149>
  1031ef:	8b 34 9d f4 3c 10 00 	mov    0x103cf4(,%ebx,4),%esi
  1031f6:	85 f6                	test   %esi,%esi
  1031f8:	75 19                	jne    103213 <vprintfmt+0x162>
                printfmt(putch, putdat, "error %d", err);
  1031fa:	53                   	push   %ebx
  1031fb:	68 21 3d 10 00       	push   $0x103d21
  103200:	ff 75 0c             	pushl  0xc(%ebp)
  103203:	ff 75 08             	pushl  0x8(%ebp)
  103206:	e8 83 fe ff ff       	call   10308e <printfmt>
  10320b:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10320e:	e9 37 02 00 00       	jmp    10344a <vprintfmt+0x399>
                printfmt(putch, putdat, "%s", p);
  103213:	56                   	push   %esi
  103214:	68 2a 3d 10 00       	push   $0x103d2a
  103219:	ff 75 0c             	pushl  0xc(%ebp)
  10321c:	ff 75 08             	pushl  0x8(%ebp)
  10321f:	e8 6a fe ff ff       	call   10308e <printfmt>
  103224:	83 c4 10             	add    $0x10,%esp
            break;
  103227:	e9 1e 02 00 00       	jmp    10344a <vprintfmt+0x399>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10322c:	8b 45 14             	mov    0x14(%ebp),%eax
  10322f:	8d 50 04             	lea    0x4(%eax),%edx
  103232:	89 55 14             	mov    %edx,0x14(%ebp)
  103235:	8b 30                	mov    (%eax),%esi
  103237:	85 f6                	test   %esi,%esi
  103239:	75 05                	jne    103240 <vprintfmt+0x18f>
                p = "(null)";
  10323b:	be 2d 3d 10 00       	mov    $0x103d2d,%esi
            }
            if (width > 0 && padc != '-') {
  103240:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103244:	7e 3f                	jle    103285 <vprintfmt+0x1d4>
  103246:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10324a:	74 39                	je     103285 <vprintfmt+0x1d4>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10324c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10324f:	83 ec 08             	sub    $0x8,%esp
  103252:	50                   	push   %eax
  103253:	56                   	push   %esi
  103254:	e8 1b f8 ff ff       	call   102a74 <strnlen>
  103259:	83 c4 10             	add    $0x10,%esp
  10325c:	89 c2                	mov    %eax,%edx
  10325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103261:	29 d0                	sub    %edx,%eax
  103263:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103266:	eb 17                	jmp    10327f <vprintfmt+0x1ce>
                    putch(padc, putdat);
  103268:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10326c:	83 ec 08             	sub    $0x8,%esp
  10326f:	ff 75 0c             	pushl  0xc(%ebp)
  103272:	50                   	push   %eax
  103273:	8b 45 08             	mov    0x8(%ebp),%eax
  103276:	ff d0                	call   *%eax
  103278:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  10327b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10327f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103283:	7f e3                	jg     103268 <vprintfmt+0x1b7>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103285:	eb 35                	jmp    1032bc <vprintfmt+0x20b>
                if (altflag && (ch < ' ' || ch > '~')) {
  103287:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10328b:	74 1c                	je     1032a9 <vprintfmt+0x1f8>
  10328d:	83 fb 1f             	cmp    $0x1f,%ebx
  103290:	7e 05                	jle    103297 <vprintfmt+0x1e6>
  103292:	83 fb 7e             	cmp    $0x7e,%ebx
  103295:	7e 12                	jle    1032a9 <vprintfmt+0x1f8>
                    putch('?', putdat);
  103297:	83 ec 08             	sub    $0x8,%esp
  10329a:	ff 75 0c             	pushl  0xc(%ebp)
  10329d:	6a 3f                	push   $0x3f
  10329f:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a2:	ff d0                	call   *%eax
  1032a4:	83 c4 10             	add    $0x10,%esp
  1032a7:	eb 0f                	jmp    1032b8 <vprintfmt+0x207>
                }
                else {
                    putch(ch, putdat);
  1032a9:	83 ec 08             	sub    $0x8,%esp
  1032ac:	ff 75 0c             	pushl  0xc(%ebp)
  1032af:	53                   	push   %ebx
  1032b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b3:	ff d0                	call   *%eax
  1032b5:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1032b8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1032bc:	89 f0                	mov    %esi,%eax
  1032be:	8d 70 01             	lea    0x1(%eax),%esi
  1032c1:	0f b6 00             	movzbl (%eax),%eax
  1032c4:	0f be d8             	movsbl %al,%ebx
  1032c7:	85 db                	test   %ebx,%ebx
  1032c9:	74 10                	je     1032db <vprintfmt+0x22a>
  1032cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1032cf:	78 b6                	js     103287 <vprintfmt+0x1d6>
  1032d1:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1032d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1032d9:	79 ac                	jns    103287 <vprintfmt+0x1d6>
                }
            }
            for (; width > 0; width --) {
  1032db:	eb 14                	jmp    1032f1 <vprintfmt+0x240>
                putch(' ', putdat);
  1032dd:	83 ec 08             	sub    $0x8,%esp
  1032e0:	ff 75 0c             	pushl  0xc(%ebp)
  1032e3:	6a 20                	push   $0x20
  1032e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1032e8:	ff d0                	call   *%eax
  1032ea:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  1032ed:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1032f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032f5:	7f e6                	jg     1032dd <vprintfmt+0x22c>
            }
            break;
  1032f7:	e9 4e 01 00 00       	jmp    10344a <vprintfmt+0x399>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1032fc:	83 ec 08             	sub    $0x8,%esp
  1032ff:	ff 75 e0             	pushl  -0x20(%ebp)
  103302:	8d 45 14             	lea    0x14(%ebp),%eax
  103305:	50                   	push   %eax
  103306:	e8 3c fd ff ff       	call   103047 <getint>
  10330b:	83 c4 10             	add    $0x10,%esp
  10330e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103311:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103317:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10331a:	85 d2                	test   %edx,%edx
  10331c:	79 23                	jns    103341 <vprintfmt+0x290>
                putch('-', putdat);
  10331e:	83 ec 08             	sub    $0x8,%esp
  103321:	ff 75 0c             	pushl  0xc(%ebp)
  103324:	6a 2d                	push   $0x2d
  103326:	8b 45 08             	mov    0x8(%ebp),%eax
  103329:	ff d0                	call   *%eax
  10332b:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  10332e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103334:	f7 d8                	neg    %eax
  103336:	83 d2 00             	adc    $0x0,%edx
  103339:	f7 da                	neg    %edx
  10333b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10333e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  103341:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103348:	e9 9f 00 00 00       	jmp    1033ec <vprintfmt+0x33b>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10334d:	83 ec 08             	sub    $0x8,%esp
  103350:	ff 75 e0             	pushl  -0x20(%ebp)
  103353:	8d 45 14             	lea    0x14(%ebp),%eax
  103356:	50                   	push   %eax
  103357:	e8 9c fc ff ff       	call   102ff8 <getuint>
  10335c:	83 c4 10             	add    $0x10,%esp
  10335f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103362:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103365:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10336c:	eb 7e                	jmp    1033ec <vprintfmt+0x33b>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10336e:	83 ec 08             	sub    $0x8,%esp
  103371:	ff 75 e0             	pushl  -0x20(%ebp)
  103374:	8d 45 14             	lea    0x14(%ebp),%eax
  103377:	50                   	push   %eax
  103378:	e8 7b fc ff ff       	call   102ff8 <getuint>
  10337d:	83 c4 10             	add    $0x10,%esp
  103380:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103383:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103386:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10338d:	eb 5d                	jmp    1033ec <vprintfmt+0x33b>

        // pointer
        case 'p':
            putch('0', putdat);
  10338f:	83 ec 08             	sub    $0x8,%esp
  103392:	ff 75 0c             	pushl  0xc(%ebp)
  103395:	6a 30                	push   $0x30
  103397:	8b 45 08             	mov    0x8(%ebp),%eax
  10339a:	ff d0                	call   *%eax
  10339c:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  10339f:	83 ec 08             	sub    $0x8,%esp
  1033a2:	ff 75 0c             	pushl  0xc(%ebp)
  1033a5:	6a 78                	push   $0x78
  1033a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1033aa:	ff d0                	call   *%eax
  1033ac:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1033af:	8b 45 14             	mov    0x14(%ebp),%eax
  1033b2:	8d 50 04             	lea    0x4(%eax),%edx
  1033b5:	89 55 14             	mov    %edx,0x14(%ebp)
  1033b8:	8b 00                	mov    (%eax),%eax
  1033ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1033c4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1033cb:	eb 1f                	jmp    1033ec <vprintfmt+0x33b>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1033cd:	83 ec 08             	sub    $0x8,%esp
  1033d0:	ff 75 e0             	pushl  -0x20(%ebp)
  1033d3:	8d 45 14             	lea    0x14(%ebp),%eax
  1033d6:	50                   	push   %eax
  1033d7:	e8 1c fc ff ff       	call   102ff8 <getuint>
  1033dc:	83 c4 10             	add    $0x10,%esp
  1033df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1033e5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1033ec:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1033f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033f3:	83 ec 04             	sub    $0x4,%esp
  1033f6:	52                   	push   %edx
  1033f7:	ff 75 e8             	pushl  -0x18(%ebp)
  1033fa:	50                   	push   %eax
  1033fb:	ff 75 f4             	pushl  -0xc(%ebp)
  1033fe:	ff 75 f0             	pushl  -0x10(%ebp)
  103401:	ff 75 0c             	pushl  0xc(%ebp)
  103404:	ff 75 08             	pushl  0x8(%ebp)
  103407:	e8 fc fa ff ff       	call   102f08 <printnum>
  10340c:	83 c4 20             	add    $0x20,%esp
            break;
  10340f:	eb 39                	jmp    10344a <vprintfmt+0x399>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103411:	83 ec 08             	sub    $0x8,%esp
  103414:	ff 75 0c             	pushl  0xc(%ebp)
  103417:	53                   	push   %ebx
  103418:	8b 45 08             	mov    0x8(%ebp),%eax
  10341b:	ff d0                	call   *%eax
  10341d:	83 c4 10             	add    $0x10,%esp
            break;
  103420:	eb 28                	jmp    10344a <vprintfmt+0x399>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103422:	83 ec 08             	sub    $0x8,%esp
  103425:	ff 75 0c             	pushl  0xc(%ebp)
  103428:	6a 25                	push   $0x25
  10342a:	8b 45 08             	mov    0x8(%ebp),%eax
  10342d:	ff d0                	call   *%eax
  10342f:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  103432:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103436:	eb 04                	jmp    10343c <vprintfmt+0x38b>
  103438:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10343c:	8b 45 10             	mov    0x10(%ebp),%eax
  10343f:	83 e8 01             	sub    $0x1,%eax
  103442:	0f b6 00             	movzbl (%eax),%eax
  103445:	3c 25                	cmp    $0x25,%al
  103447:	75 ef                	jne    103438 <vprintfmt+0x387>
                /* do nothing */;
            break;
  103449:	90                   	nop
        }
    }
  10344a:	e9 6a fc ff ff       	jmp    1030b9 <vprintfmt+0x8>
}
  10344f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  103452:	5b                   	pop    %ebx
  103453:	5e                   	pop    %esi
  103454:	5d                   	pop    %ebp
  103455:	c3                   	ret    

00103456 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103456:	55                   	push   %ebp
  103457:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103459:	8b 45 0c             	mov    0xc(%ebp),%eax
  10345c:	8b 40 08             	mov    0x8(%eax),%eax
  10345f:	8d 50 01             	lea    0x1(%eax),%edx
  103462:	8b 45 0c             	mov    0xc(%ebp),%eax
  103465:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103468:	8b 45 0c             	mov    0xc(%ebp),%eax
  10346b:	8b 10                	mov    (%eax),%edx
  10346d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103470:	8b 40 04             	mov    0x4(%eax),%eax
  103473:	39 c2                	cmp    %eax,%edx
  103475:	73 12                	jae    103489 <sprintputch+0x33>
        *b->buf ++ = ch;
  103477:	8b 45 0c             	mov    0xc(%ebp),%eax
  10347a:	8b 00                	mov    (%eax),%eax
  10347c:	8d 48 01             	lea    0x1(%eax),%ecx
  10347f:	8b 55 0c             	mov    0xc(%ebp),%edx
  103482:	89 0a                	mov    %ecx,(%edx)
  103484:	8b 55 08             	mov    0x8(%ebp),%edx
  103487:	88 10                	mov    %dl,(%eax)
    }
}
  103489:	5d                   	pop    %ebp
  10348a:	c3                   	ret    

0010348b <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10348b:	55                   	push   %ebp
  10348c:	89 e5                	mov    %esp,%ebp
  10348e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103491:	8d 45 14             	lea    0x14(%ebp),%eax
  103494:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10349a:	50                   	push   %eax
  10349b:	ff 75 10             	pushl  0x10(%ebp)
  10349e:	ff 75 0c             	pushl  0xc(%ebp)
  1034a1:	ff 75 08             	pushl  0x8(%ebp)
  1034a4:	e8 0b 00 00 00       	call   1034b4 <vsnprintf>
  1034a9:	83 c4 10             	add    $0x10,%esp
  1034ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1034af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1034b2:	c9                   	leave  
  1034b3:	c3                   	ret    

001034b4 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1034b4:	55                   	push   %ebp
  1034b5:	89 e5                	mov    %esp,%ebp
  1034b7:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1034ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1034bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1034c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1034c9:	01 d0                	add    %edx,%eax
  1034cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1034d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1034d9:	74 0a                	je     1034e5 <vsnprintf+0x31>
  1034db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1034de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034e1:	39 c2                	cmp    %eax,%edx
  1034e3:	76 07                	jbe    1034ec <vsnprintf+0x38>
        return -E_INVAL;
  1034e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1034ea:	eb 20                	jmp    10350c <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1034ec:	ff 75 14             	pushl  0x14(%ebp)
  1034ef:	ff 75 10             	pushl  0x10(%ebp)
  1034f2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1034f5:	50                   	push   %eax
  1034f6:	68 56 34 10 00       	push   $0x103456
  1034fb:	e8 b1 fb ff ff       	call   1030b1 <vprintfmt>
  103500:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  103503:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103506:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103509:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10350c:	c9                   	leave  
  10350d:	c3                   	ret    
