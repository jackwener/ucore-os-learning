
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	53                   	push   %ebx
  100004:	83 ec 14             	sub    $0x14,%esp
  100007:	e8 74 02 00 00       	call   100280 <__x86.get_pc_thunk.bx>
  10000c:	81 c3 44 e9 00 00    	add    $0xe944,%ebx
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100012:	c7 c0 c0 fd 10 00    	mov    $0x10fdc0,%eax
  100018:	89 c2                	mov    %eax,%edx
  10001a:	c7 c0 50 e9 10 00    	mov    $0x10e950,%eax
  100020:	29 c2                	sub    %eax,%edx
  100022:	89 d0                	mov    %edx,%eax
  100024:	83 ec 04             	sub    $0x4,%esp
  100027:	50                   	push   %eax
  100028:	6a 00                	push   $0x0
  10002a:	c7 c0 50 e9 10 00    	mov    $0x10e950,%eax
  100030:	50                   	push   %eax
  100031:	e8 5b 2f 00 00       	call   102f91 <memset>
  100036:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100039:	e8 35 18 00 00       	call   101873 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10003e:	8d 83 70 4e ff ff    	lea    -0xb190(%ebx),%eax
  100044:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100047:	83 ec 08             	sub    $0x8,%esp
  10004a:	ff 75 f4             	pushl  -0xc(%ebp)
  10004d:	8d 83 8c 4e ff ff    	lea    -0xb174(%ebx),%eax
  100053:	50                   	push   %eax
  100054:	e8 9a 02 00 00       	call   1002f3 <cprintf>
  100059:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  10005c:	e8 d1 09 00 00       	call   100a32 <print_kerninfo>

    grade_backtrace();
  100061:	e8 98 00 00 00       	call   1000fe <grade_backtrace>

    pmm_init();                 // init physical memory management
  100066:	e8 86 2b 00 00       	call   102bf1 <pmm_init>

    pic_init();                 // init interrupt controller
  10006b:	e8 92 19 00 00       	call   101a02 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100070:	e8 24 1b 00 00       	call   101b99 <idt_init>

    clock_init();               // init clock interrupt
  100075:	e8 f5 0e 00 00       	call   100f6f <clock_init>
    intr_enable();              // enable irq interrupt
  10007a:	e8 cb 1a 00 00       	call   101b4a <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10007f:	eb fe                	jmp    10007f <kern_init+0x7f>

00100081 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100081:	55                   	push   %ebp
  100082:	89 e5                	mov    %esp,%ebp
  100084:	53                   	push   %ebx
  100085:	83 ec 04             	sub    $0x4,%esp
  100088:	e8 ef 01 00 00       	call   10027c <__x86.get_pc_thunk.ax>
  10008d:	05 c3 e8 00 00       	add    $0xe8c3,%eax
    mon_backtrace(0, NULL, NULL);
  100092:	83 ec 04             	sub    $0x4,%esp
  100095:	6a 00                	push   $0x0
  100097:	6a 00                	push   $0x0
  100099:	6a 00                	push   $0x0
  10009b:	89 c3                	mov    %eax,%ebx
  10009d:	e8 aa 0e 00 00       	call   100f4c <mon_backtrace>
  1000a2:	83 c4 10             	add    $0x10,%esp
}
  1000a5:	90                   	nop
  1000a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000a9:	c9                   	leave  
  1000aa:	c3                   	ret    

001000ab <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000ab:	55                   	push   %ebp
  1000ac:	89 e5                	mov    %esp,%ebp
  1000ae:	53                   	push   %ebx
  1000af:	83 ec 04             	sub    $0x4,%esp
  1000b2:	e8 c5 01 00 00       	call   10027c <__x86.get_pc_thunk.ax>
  1000b7:	05 99 e8 00 00       	add    $0xe899,%eax
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000bc:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000c2:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000c8:	51                   	push   %ecx
  1000c9:	52                   	push   %edx
  1000ca:	53                   	push   %ebx
  1000cb:	50                   	push   %eax
  1000cc:	e8 b0 ff ff ff       	call   100081 <grade_backtrace2>
  1000d1:	83 c4 10             	add    $0x10,%esp
}
  1000d4:	90                   	nop
  1000d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000d8:	c9                   	leave  
  1000d9:	c3                   	ret    

001000da <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000da:	55                   	push   %ebp
  1000db:	89 e5                	mov    %esp,%ebp
  1000dd:	83 ec 08             	sub    $0x8,%esp
  1000e0:	e8 97 01 00 00       	call   10027c <__x86.get_pc_thunk.ax>
  1000e5:	05 6b e8 00 00       	add    $0xe86b,%eax
    grade_backtrace1(arg0, arg2);
  1000ea:	83 ec 08             	sub    $0x8,%esp
  1000ed:	ff 75 10             	pushl  0x10(%ebp)
  1000f0:	ff 75 08             	pushl  0x8(%ebp)
  1000f3:	e8 b3 ff ff ff       	call   1000ab <grade_backtrace1>
  1000f8:	83 c4 10             	add    $0x10,%esp
}
  1000fb:	90                   	nop
  1000fc:	c9                   	leave  
  1000fd:	c3                   	ret    

001000fe <grade_backtrace>:

void
grade_backtrace(void) {
  1000fe:	55                   	push   %ebp
  1000ff:	89 e5                	mov    %esp,%ebp
  100101:	83 ec 08             	sub    $0x8,%esp
  100104:	e8 73 01 00 00       	call   10027c <__x86.get_pc_thunk.ax>
  100109:	05 47 e8 00 00       	add    $0xe847,%eax
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010e:	8d 80 b0 16 ff ff    	lea    -0xe950(%eax),%eax
  100114:	83 ec 04             	sub    $0x4,%esp
  100117:	68 00 00 ff ff       	push   $0xffff0000
  10011c:	50                   	push   %eax
  10011d:	6a 00                	push   $0x0
  10011f:	e8 b6 ff ff ff       	call   1000da <grade_backtrace0>
  100124:	83 c4 10             	add    $0x10,%esp
}
  100127:	90                   	nop
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	53                   	push   %ebx
  10012e:	83 ec 14             	sub    $0x14,%esp
  100131:	e8 4a 01 00 00       	call   100280 <__x86.get_pc_thunk.bx>
  100136:	81 c3 1a e8 00 00    	add    $0xe81a,%ebx
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10014c:	0f b7 c0             	movzwl %ax,%eax
  10014f:	83 e0 03             	and    $0x3,%eax
  100152:	89 c2                	mov    %eax,%edx
  100154:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  10015a:	83 ec 04             	sub    $0x4,%esp
  10015d:	52                   	push   %edx
  10015e:	50                   	push   %eax
  10015f:	8d 83 91 4e ff ff    	lea    -0xb16f(%ebx),%eax
  100165:	50                   	push   %eax
  100166:	e8 88 01 00 00       	call   1002f3 <cprintf>
  10016b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10016e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100172:	0f b7 d0             	movzwl %ax,%edx
  100175:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  10017b:	83 ec 04             	sub    $0x4,%esp
  10017e:	52                   	push   %edx
  10017f:	50                   	push   %eax
  100180:	8d 83 9f 4e ff ff    	lea    -0xb161(%ebx),%eax
  100186:	50                   	push   %eax
  100187:	e8 67 01 00 00       	call   1002f3 <cprintf>
  10018c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  10018f:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100193:	0f b7 d0             	movzwl %ax,%edx
  100196:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  10019c:	83 ec 04             	sub    $0x4,%esp
  10019f:	52                   	push   %edx
  1001a0:	50                   	push   %eax
  1001a1:	8d 83 ad 4e ff ff    	lea    -0xb153(%ebx),%eax
  1001a7:	50                   	push   %eax
  1001a8:	e8 46 01 00 00       	call   1002f3 <cprintf>
  1001ad:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  1001b0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b4:	0f b7 d0             	movzwl %ax,%edx
  1001b7:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  1001bd:	83 ec 04             	sub    $0x4,%esp
  1001c0:	52                   	push   %edx
  1001c1:	50                   	push   %eax
  1001c2:	8d 83 bb 4e ff ff    	lea    -0xb145(%ebx),%eax
  1001c8:	50                   	push   %eax
  1001c9:	e8 25 01 00 00       	call   1002f3 <cprintf>
  1001ce:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d5:	0f b7 d0             	movzwl %ax,%edx
  1001d8:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  1001de:	83 ec 04             	sub    $0x4,%esp
  1001e1:	52                   	push   %edx
  1001e2:	50                   	push   %eax
  1001e3:	8d 83 c9 4e ff ff    	lea    -0xb137(%ebx),%eax
  1001e9:	50                   	push   %eax
  1001ea:	e8 04 01 00 00       	call   1002f3 <cprintf>
  1001ef:	83 c4 10             	add    $0x10,%esp
    round ++;
  1001f2:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  1001f8:	83 c0 01             	add    $0x1,%eax
  1001fb:	89 83 70 01 00 00    	mov    %eax,0x170(%ebx)
}
  100201:	90                   	nop
  100202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100205:	c9                   	leave  
  100206:	c3                   	ret    

00100207 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  100207:	55                   	push   %ebp
  100208:	89 e5                	mov    %esp,%ebp
  10020a:	e8 6d 00 00 00       	call   10027c <__x86.get_pc_thunk.ax>
  10020f:	05 41 e7 00 00       	add    $0xe741,%eax
    //LAB1 CHALLENGE 1 : TODO
}
  100214:	90                   	nop
  100215:	5d                   	pop    %ebp
  100216:	c3                   	ret    

00100217 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100217:	55                   	push   %ebp
  100218:	89 e5                	mov    %esp,%ebp
  10021a:	e8 5d 00 00 00       	call   10027c <__x86.get_pc_thunk.ax>
  10021f:	05 31 e7 00 00       	add    $0xe731,%eax
    //LAB1 CHALLENGE 1 :  TODO
}
  100224:	90                   	nop
  100225:	5d                   	pop    %ebp
  100226:	c3                   	ret    

00100227 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100227:	55                   	push   %ebp
  100228:	89 e5                	mov    %esp,%ebp
  10022a:	53                   	push   %ebx
  10022b:	83 ec 04             	sub    $0x4,%esp
  10022e:	e8 4d 00 00 00       	call   100280 <__x86.get_pc_thunk.bx>
  100233:	81 c3 1d e7 00 00    	add    $0xe71d,%ebx
    lab1_print_cur_status();
  100239:	e8 ec fe ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10023e:	83 ec 0c             	sub    $0xc,%esp
  100241:	8d 83 d8 4e ff ff    	lea    -0xb128(%ebx),%eax
  100247:	50                   	push   %eax
  100248:	e8 a6 00 00 00       	call   1002f3 <cprintf>
  10024d:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  100250:	e8 b2 ff ff ff       	call   100207 <lab1_switch_to_user>
    lab1_print_cur_status();
  100255:	e8 d0 fe ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10025a:	83 ec 0c             	sub    $0xc,%esp
  10025d:	8d 83 f8 4e ff ff    	lea    -0xb108(%ebx),%eax
  100263:	50                   	push   %eax
  100264:	e8 8a 00 00 00       	call   1002f3 <cprintf>
  100269:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  10026c:	e8 a6 ff ff ff       	call   100217 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100271:	e8 b4 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100276:	90                   	nop
  100277:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10027a:	c9                   	leave  
  10027b:	c3                   	ret    

0010027c <__x86.get_pc_thunk.ax>:
  10027c:	8b 04 24             	mov    (%esp),%eax
  10027f:	c3                   	ret    

00100280 <__x86.get_pc_thunk.bx>:
  100280:	8b 1c 24             	mov    (%esp),%ebx
  100283:	c3                   	ret    

00100284 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100284:	55                   	push   %ebp
  100285:	89 e5                	mov    %esp,%ebp
  100287:	53                   	push   %ebx
  100288:	83 ec 04             	sub    $0x4,%esp
  10028b:	e8 ec ff ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  100290:	05 c0 e6 00 00       	add    $0xe6c0,%eax
    cons_putc(c);
  100295:	83 ec 0c             	sub    $0xc,%esp
  100298:	ff 75 08             	pushl  0x8(%ebp)
  10029b:	89 c3                	mov    %eax,%ebx
  10029d:	e8 14 16 00 00       	call   1018b6 <cons_putc>
  1002a2:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  1002a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002a8:	8b 00                	mov    (%eax),%eax
  1002aa:	8d 50 01             	lea    0x1(%eax),%edx
  1002ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002b0:	89 10                	mov    %edx,(%eax)
}
  1002b2:	90                   	nop
  1002b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1002b6:	c9                   	leave  
  1002b7:	c3                   	ret    

001002b8 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002b8:	55                   	push   %ebp
  1002b9:	89 e5                	mov    %esp,%ebp
  1002bb:	53                   	push   %ebx
  1002bc:	83 ec 14             	sub    $0x14,%esp
  1002bf:	e8 b8 ff ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1002c4:	05 8c e6 00 00       	add    $0xe68c,%eax
    int cnt = 0;
  1002c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002d0:	ff 75 0c             	pushl  0xc(%ebp)
  1002d3:	ff 75 08             	pushl  0x8(%ebp)
  1002d6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1002d9:	52                   	push   %edx
  1002da:	8d 90 34 19 ff ff    	lea    -0xe6cc(%eax),%edx
  1002e0:	52                   	push   %edx
  1002e1:	89 c3                	mov    %eax,%ebx
  1002e3:	e8 37 30 00 00       	call   10331f <vprintfmt>
  1002e8:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1002f1:	c9                   	leave  
  1002f2:	c3                   	ret    

001002f3 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002f3:	55                   	push   %ebp
  1002f4:	89 e5                	mov    %esp,%ebp
  1002f6:	83 ec 18             	sub    $0x18,%esp
  1002f9:	e8 7e ff ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1002fe:	05 52 e6 00 00       	add    $0xe652,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100303:	8d 45 0c             	lea    0xc(%ebp),%eax
  100306:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10030c:	83 ec 08             	sub    $0x8,%esp
  10030f:	50                   	push   %eax
  100310:	ff 75 08             	pushl  0x8(%ebp)
  100313:	e8 a0 ff ff ff       	call   1002b8 <vcprintf>
  100318:	83 c4 10             	add    $0x10,%esp
  10031b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10031e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100321:	c9                   	leave  
  100322:	c3                   	ret    

00100323 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100323:	55                   	push   %ebp
  100324:	89 e5                	mov    %esp,%ebp
  100326:	53                   	push   %ebx
  100327:	83 ec 04             	sub    $0x4,%esp
  10032a:	e8 4d ff ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10032f:	05 21 e6 00 00       	add    $0xe621,%eax
    cons_putc(c);
  100334:	83 ec 0c             	sub    $0xc,%esp
  100337:	ff 75 08             	pushl  0x8(%ebp)
  10033a:	89 c3                	mov    %eax,%ebx
  10033c:	e8 75 15 00 00       	call   1018b6 <cons_putc>
  100341:	83 c4 10             	add    $0x10,%esp
}
  100344:	90                   	nop
  100345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100348:	c9                   	leave  
  100349:	c3                   	ret    

0010034a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034a:	55                   	push   %ebp
  10034b:	89 e5                	mov    %esp,%ebp
  10034d:	83 ec 18             	sub    $0x18,%esp
  100350:	e8 27 ff ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  100355:	05 fb e5 00 00       	add    $0xe5fb,%eax
    int cnt = 0;
  10035a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100361:	eb 14                	jmp    100377 <cputs+0x2d>
        cputch(c, &cnt);
  100363:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100367:	83 ec 08             	sub    $0x8,%esp
  10036a:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10036d:	52                   	push   %edx
  10036e:	50                   	push   %eax
  10036f:	e8 10 ff ff ff       	call   100284 <cputch>
  100374:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  100377:	8b 45 08             	mov    0x8(%ebp),%eax
  10037a:	8d 50 01             	lea    0x1(%eax),%edx
  10037d:	89 55 08             	mov    %edx,0x8(%ebp)
  100380:	0f b6 00             	movzbl (%eax),%eax
  100383:	88 45 f7             	mov    %al,-0x9(%ebp)
  100386:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10038a:	75 d7                	jne    100363 <cputs+0x19>
    }
    cputch('\n', &cnt);
  10038c:	83 ec 08             	sub    $0x8,%esp
  10038f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100392:	50                   	push   %eax
  100393:	6a 0a                	push   $0xa
  100395:	e8 ea fe ff ff       	call   100284 <cputch>
  10039a:	83 c4 10             	add    $0x10,%esp
    return cnt;
  10039d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003a0:	c9                   	leave  
  1003a1:	c3                   	ret    

001003a2 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003a2:	55                   	push   %ebp
  1003a3:	89 e5                	mov    %esp,%ebp
  1003a5:	53                   	push   %ebx
  1003a6:	83 ec 14             	sub    $0x14,%esp
  1003a9:	e8 d2 fe ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  1003ae:	81 c3 a2 e5 00 00    	add    $0xe5a2,%ebx
    int c;
    while ((c = cons_getc()) == 0)
  1003b4:	e8 37 15 00 00       	call   1018f0 <cons_getc>
  1003b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003c0:	74 f2                	je     1003b4 <getchar+0x12>
        /* do nothing */;
    return c;
  1003c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003c5:	83 c4 14             	add    $0x14,%esp
  1003c8:	5b                   	pop    %ebx
  1003c9:	5d                   	pop    %ebp
  1003ca:	c3                   	ret    

001003cb <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1003cb:	55                   	push   %ebp
  1003cc:	89 e5                	mov    %esp,%ebp
  1003ce:	53                   	push   %ebx
  1003cf:	83 ec 14             	sub    $0x14,%esp
  1003d2:	e8 a9 fe ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  1003d7:	81 c3 79 e5 00 00    	add    $0xe579,%ebx
    if (prompt != NULL) {
  1003dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1003e1:	74 15                	je     1003f8 <readline+0x2d>
        cprintf("%s", prompt);
  1003e3:	83 ec 08             	sub    $0x8,%esp
  1003e6:	ff 75 08             	pushl  0x8(%ebp)
  1003e9:	8d 83 17 4f ff ff    	lea    -0xb0e9(%ebx),%eax
  1003ef:	50                   	push   %eax
  1003f0:	e8 fe fe ff ff       	call   1002f3 <cprintf>
  1003f5:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  1003f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  1003ff:	e8 9e ff ff ff       	call   1003a2 <getchar>
  100404:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100407:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10040b:	79 0a                	jns    100417 <readline+0x4c>
            return NULL;
  10040d:	b8 00 00 00 00       	mov    $0x0,%eax
  100412:	e9 87 00 00 00       	jmp    10049e <readline+0xd3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100417:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10041b:	7e 2c                	jle    100449 <readline+0x7e>
  10041d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100424:	7f 23                	jg     100449 <readline+0x7e>
            cputchar(c);
  100426:	83 ec 0c             	sub    $0xc,%esp
  100429:	ff 75 f0             	pushl  -0x10(%ebp)
  10042c:	e8 f2 fe ff ff       	call   100323 <cputchar>
  100431:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100437:	8d 50 01             	lea    0x1(%eax),%edx
  10043a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10043d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100440:	88 94 03 90 01 00 00 	mov    %dl,0x190(%ebx,%eax,1)
  100447:	eb 50                	jmp    100499 <readline+0xce>
        }
        else if (c == '\b' && i > 0) {
  100449:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10044d:	75 1a                	jne    100469 <readline+0x9e>
  10044f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100453:	7e 14                	jle    100469 <readline+0x9e>
            cputchar(c);
  100455:	83 ec 0c             	sub    $0xc,%esp
  100458:	ff 75 f0             	pushl  -0x10(%ebp)
  10045b:	e8 c3 fe ff ff       	call   100323 <cputchar>
  100460:	83 c4 10             	add    $0x10,%esp
            i --;
  100463:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100467:	eb 30                	jmp    100499 <readline+0xce>
        }
        else if (c == '\n' || c == '\r') {
  100469:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10046d:	74 06                	je     100475 <readline+0xaa>
  10046f:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100473:	75 8a                	jne    1003ff <readline+0x34>
            cputchar(c);
  100475:	83 ec 0c             	sub    $0xc,%esp
  100478:	ff 75 f0             	pushl  -0x10(%ebp)
  10047b:	e8 a3 fe ff ff       	call   100323 <cputchar>
  100480:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  100483:	8d 93 90 01 00 00    	lea    0x190(%ebx),%edx
  100489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10048c:	01 d0                	add    %edx,%eax
  10048e:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100491:	8d 83 90 01 00 00    	lea    0x190(%ebx),%eax
  100497:	eb 05                	jmp    10049e <readline+0xd3>
        c = getchar();
  100499:	e9 61 ff ff ff       	jmp    1003ff <readline+0x34>
        }
    }
}
  10049e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1004a1:	c9                   	leave  
  1004a2:	c3                   	ret    

001004a3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1004a3:	55                   	push   %ebp
  1004a4:	89 e5                	mov    %esp,%ebp
  1004a6:	53                   	push   %ebx
  1004a7:	83 ec 14             	sub    $0x14,%esp
  1004aa:	e8 d1 fd ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  1004af:	81 c3 a1 e4 00 00    	add    $0xe4a1,%ebx
    if (is_panic) {
  1004b5:	8b 83 90 05 00 00    	mov    0x590(%ebx),%eax
  1004bb:	85 c0                	test   %eax,%eax
  1004bd:	75 65                	jne    100524 <__panic+0x81>
        goto panic_dead;
    }
    is_panic = 1;
  1004bf:	c7 83 90 05 00 00 01 	movl   $0x1,0x590(%ebx)
  1004c6:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1004c9:	8d 45 14             	lea    0x14(%ebp),%eax
  1004cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1004cf:	83 ec 04             	sub    $0x4,%esp
  1004d2:	ff 75 0c             	pushl  0xc(%ebp)
  1004d5:	ff 75 08             	pushl  0x8(%ebp)
  1004d8:	8d 83 1a 4f ff ff    	lea    -0xb0e6(%ebx),%eax
  1004de:	50                   	push   %eax
  1004df:	e8 0f fe ff ff       	call   1002f3 <cprintf>
  1004e4:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1004e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004ea:	83 ec 08             	sub    $0x8,%esp
  1004ed:	50                   	push   %eax
  1004ee:	ff 75 10             	pushl  0x10(%ebp)
  1004f1:	e8 c2 fd ff ff       	call   1002b8 <vcprintf>
  1004f6:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1004f9:	83 ec 0c             	sub    $0xc,%esp
  1004fc:	8d 83 36 4f ff ff    	lea    -0xb0ca(%ebx),%eax
  100502:	50                   	push   %eax
  100503:	e8 eb fd ff ff       	call   1002f3 <cprintf>
  100508:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
  10050b:	83 ec 0c             	sub    $0xc,%esp
  10050e:	8d 83 38 4f ff ff    	lea    -0xb0c8(%ebx),%eax
  100514:	50                   	push   %eax
  100515:	e8 d9 fd ff ff       	call   1002f3 <cprintf>
  10051a:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
  10051d:	e8 9f 06 00 00       	call   100bc1 <print_stackframe>
  100522:	eb 01                	jmp    100525 <__panic+0x82>
        goto panic_dead;
  100524:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100525:	e8 31 16 00 00       	call   101b5b <intr_disable>
    while (1) {
        kmonitor(NULL);
  10052a:	83 ec 0c             	sub    $0xc,%esp
  10052d:	6a 00                	push   $0x0
  10052f:	e8 fe 08 00 00       	call   100e32 <kmonitor>
  100534:	83 c4 10             	add    $0x10,%esp
  100537:	eb f1                	jmp    10052a <__panic+0x87>

00100539 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100539:	55                   	push   %ebp
  10053a:	89 e5                	mov    %esp,%ebp
  10053c:	53                   	push   %ebx
  10053d:	83 ec 14             	sub    $0x14,%esp
  100540:	e8 3b fd ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100545:	81 c3 0b e4 00 00    	add    $0xe40b,%ebx
    va_list ap;
    va_start(ap, fmt);
  10054b:	8d 45 14             	lea    0x14(%ebp),%eax
  10054e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100551:	83 ec 04             	sub    $0x4,%esp
  100554:	ff 75 0c             	pushl  0xc(%ebp)
  100557:	ff 75 08             	pushl  0x8(%ebp)
  10055a:	8d 83 4a 4f ff ff    	lea    -0xb0b6(%ebx),%eax
  100560:	50                   	push   %eax
  100561:	e8 8d fd ff ff       	call   1002f3 <cprintf>
  100566:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10056c:	83 ec 08             	sub    $0x8,%esp
  10056f:	50                   	push   %eax
  100570:	ff 75 10             	pushl  0x10(%ebp)
  100573:	e8 40 fd ff ff       	call   1002b8 <vcprintf>
  100578:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10057b:	83 ec 0c             	sub    $0xc,%esp
  10057e:	8d 83 36 4f ff ff    	lea    -0xb0ca(%ebx),%eax
  100584:	50                   	push   %eax
  100585:	e8 69 fd ff ff       	call   1002f3 <cprintf>
  10058a:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10058d:	90                   	nop
  10058e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100591:	c9                   	leave  
  100592:	c3                   	ret    

00100593 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100593:	55                   	push   %ebp
  100594:	89 e5                	mov    %esp,%ebp
  100596:	e8 e1 fc ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10059b:	05 b5 e3 00 00       	add    $0xe3b5,%eax
    return is_panic;
  1005a0:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
}
  1005a6:	5d                   	pop    %ebp
  1005a7:	c3                   	ret    

001005a8 <stab_binsearch>:
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
               int type, uintptr_t addr)
{
  1005a8:	55                   	push   %ebp
  1005a9:	89 e5                	mov    %esp,%ebp
  1005ab:	83 ec 20             	sub    $0x20,%esp
  1005ae:	e8 c9 fc ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1005b3:	05 9d e3 00 00       	add    $0xe39d,%eax
    int l = *region_left, r = *region_right, any_matches = 0;
  1005b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005bb:	8b 00                	mov    (%eax),%eax
  1005bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005c0:	8b 45 10             	mov    0x10(%ebp),%eax
  1005c3:	8b 00                	mov    (%eax),%eax
  1005c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r)
  1005cf:	e9 d2 00 00 00       	jmp    1006a6 <stab_binsearch+0xfe>
    {
        int true_m = (l + r) / 2, m = true_m;
  1005d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1005da:	01 d0                	add    %edx,%eax
  1005dc:	89 c2                	mov    %eax,%edx
  1005de:	c1 ea 1f             	shr    $0x1f,%edx
  1005e1:	01 d0                	add    %edx,%eax
  1005e3:	d1 f8                	sar    %eax
  1005e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1005e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1005eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type)
  1005ee:	eb 04                	jmp    1005f4 <stab_binsearch+0x4c>
        {
            m--;
  1005f0:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type)
  1005f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005f7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005fa:	7c 1f                	jl     10061b <stab_binsearch+0x73>
  1005fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005ff:	89 d0                	mov    %edx,%eax
  100601:	01 c0                	add    %eax,%eax
  100603:	01 d0                	add    %edx,%eax
  100605:	c1 e0 02             	shl    $0x2,%eax
  100608:	89 c2                	mov    %eax,%edx
  10060a:	8b 45 08             	mov    0x8(%ebp),%eax
  10060d:	01 d0                	add    %edx,%eax
  10060f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100613:	0f b6 c0             	movzbl %al,%eax
  100616:	39 45 14             	cmp    %eax,0x14(%ebp)
  100619:	75 d5                	jne    1005f0 <stab_binsearch+0x48>
        }
        if (m < l)
  10061b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10061e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100621:	7d 0b                	jge    10062e <stab_binsearch+0x86>
        { // no match in [l, m]
            l = true_m + 1;
  100623:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100626:	83 c0 01             	add    $0x1,%eax
  100629:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10062c:	eb 78                	jmp    1006a6 <stab_binsearch+0xfe>
        }

        // actual binary search
        any_matches = 1;
  10062e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr)
  100635:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100638:	89 d0                	mov    %edx,%eax
  10063a:	01 c0                	add    %eax,%eax
  10063c:	01 d0                	add    %edx,%eax
  10063e:	c1 e0 02             	shl    $0x2,%eax
  100641:	89 c2                	mov    %eax,%edx
  100643:	8b 45 08             	mov    0x8(%ebp),%eax
  100646:	01 d0                	add    %edx,%eax
  100648:	8b 40 08             	mov    0x8(%eax),%eax
  10064b:	39 45 18             	cmp    %eax,0x18(%ebp)
  10064e:	76 13                	jbe    100663 <stab_binsearch+0xbb>
        {
            *region_left = m;
  100650:	8b 45 0c             	mov    0xc(%ebp),%eax
  100653:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100656:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100658:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065b:	83 c0 01             	add    $0x1,%eax
  10065e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100661:	eb 43                	jmp    1006a6 <stab_binsearch+0xfe>
        }
        else if (stabs[m].n_value > addr)
  100663:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100666:	89 d0                	mov    %edx,%eax
  100668:	01 c0                	add    %eax,%eax
  10066a:	01 d0                	add    %edx,%eax
  10066c:	c1 e0 02             	shl    $0x2,%eax
  10066f:	89 c2                	mov    %eax,%edx
  100671:	8b 45 08             	mov    0x8(%ebp),%eax
  100674:	01 d0                	add    %edx,%eax
  100676:	8b 40 08             	mov    0x8(%eax),%eax
  100679:	39 45 18             	cmp    %eax,0x18(%ebp)
  10067c:	73 16                	jae    100694 <stab_binsearch+0xec>
        {
            *region_right = m - 1;
  10067e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100681:	8d 50 ff             	lea    -0x1(%eax),%edx
  100684:	8b 45 10             	mov    0x10(%ebp),%eax
  100687:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100689:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10068c:	83 e8 01             	sub    $0x1,%eax
  10068f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100692:	eb 12                	jmp    1006a6 <stab_binsearch+0xfe>
        }
        else
        {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100694:	8b 45 0c             	mov    0xc(%ebp),%eax
  100697:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10069a:	89 10                	mov    %edx,(%eax)
            l = m;
  10069c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10069f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr++;
  1006a2:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r)
  1006a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1006a9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1006ac:	0f 8e 22 ff ff ff    	jle    1005d4 <stab_binsearch+0x2c>
        }
    }

    if (!any_matches)
  1006b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1006b6:	75 0f                	jne    1006c7 <stab_binsearch+0x11f>
    {
        *region_right = *region_left - 1;
  1006b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006bb:	8b 00                	mov    (%eax),%eax
  1006bd:	8d 50 ff             	lea    -0x1(%eax),%edx
  1006c0:	8b 45 10             	mov    0x10(%ebp),%eax
  1006c3:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l--)
            /* do nothing */;
        *region_left = l;
    }
}
  1006c5:	eb 3f                	jmp    100706 <stab_binsearch+0x15e>
        l = *region_right;
  1006c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1006ca:	8b 00                	mov    (%eax),%eax
  1006cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l--)
  1006cf:	eb 04                	jmp    1006d5 <stab_binsearch+0x12d>
  1006d1:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d8:	8b 00                	mov    (%eax),%eax
  1006da:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1006dd:	7e 1f                	jle    1006fe <stab_binsearch+0x156>
  1006df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1006e2:	89 d0                	mov    %edx,%eax
  1006e4:	01 c0                	add    %eax,%eax
  1006e6:	01 d0                	add    %edx,%eax
  1006e8:	c1 e0 02             	shl    $0x2,%eax
  1006eb:	89 c2                	mov    %eax,%edx
  1006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1006f0:	01 d0                	add    %edx,%eax
  1006f2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1006f6:	0f b6 c0             	movzbl %al,%eax
  1006f9:	39 45 14             	cmp    %eax,0x14(%ebp)
  1006fc:	75 d3                	jne    1006d1 <stab_binsearch+0x129>
        *region_left = l;
  1006fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  100701:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100704:	89 10                	mov    %edx,(%eax)
}
  100706:	90                   	nop
  100707:	c9                   	leave  
  100708:	c3                   	ret    

00100709 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info)
{
  100709:	55                   	push   %ebp
  10070a:	89 e5                	mov    %esp,%ebp
  10070c:	53                   	push   %ebx
  10070d:	83 ec 34             	sub    $0x34,%esp
  100710:	e8 6b fb ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100715:	81 c3 3b e2 00 00    	add    $0xe23b,%ebx
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10071b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10071e:	8d 93 68 4f ff ff    	lea    -0xb098(%ebx),%edx
  100724:	89 10                	mov    %edx,(%eax)
    info->eip_line = 0;
  100726:	8b 45 0c             	mov    0xc(%ebp),%eax
  100729:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100730:	8b 45 0c             	mov    0xc(%ebp),%eax
  100733:	8d 93 68 4f ff ff    	lea    -0xb098(%ebx),%edx
  100739:	89 50 08             	mov    %edx,0x8(%eax)
    info->eip_fn_namelen = 9;
  10073c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100746:	8b 45 0c             	mov    0xc(%ebp),%eax
  100749:	8b 55 08             	mov    0x8(%ebp),%edx
  10074c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10074f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100752:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100759:	c7 c0 4c 40 10 00    	mov    $0x10404c,%eax
  10075f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    stab_end = __STAB_END__;
  100762:	c7 c0 90 bc 10 00    	mov    $0x10bc90,%eax
  100768:	89 45 f0             	mov    %eax,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10076b:	c7 c0 91 bc 10 00    	mov    $0x10bc91,%eax
  100771:	89 45 ec             	mov    %eax,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100774:	c7 c0 60 dd 10 00    	mov    $0x10dd60,%eax
  10077a:	89 45 e8             	mov    %eax,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
  10077d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100780:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100783:	76 0d                	jbe    100792 <debuginfo_eip+0x89>
  100785:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100788:	83 e8 01             	sub    $0x1,%eax
  10078b:	0f b6 00             	movzbl (%eax),%eax
  10078e:	84 c0                	test   %al,%al
  100790:	74 0a                	je     10079c <debuginfo_eip+0x93>
    {
        return -1;
  100792:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100797:	e9 91 02 00 00       	jmp    100a2d <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10079c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1007a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1007a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a9:	29 c2                	sub    %eax,%edx
  1007ab:	89 d0                	mov    %edx,%eax
  1007ad:	c1 f8 02             	sar    $0x2,%eax
  1007b0:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1007b6:	83 e8 01             	sub    $0x1,%eax
  1007b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1007bc:	ff 75 08             	pushl  0x8(%ebp)
  1007bf:	6a 64                	push   $0x64
  1007c1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1007c4:	50                   	push   %eax
  1007c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1007c8:	50                   	push   %eax
  1007c9:	ff 75 f4             	pushl  -0xc(%ebp)
  1007cc:	e8 d7 fd ff ff       	call   1005a8 <stab_binsearch>
  1007d1:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  1007d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d7:	85 c0                	test   %eax,%eax
  1007d9:	75 0a                	jne    1007e5 <debuginfo_eip+0xdc>
        return -1;
  1007db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007e0:	e9 48 02 00 00       	jmp    100a2d <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1007e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1007eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1007f1:	ff 75 08             	pushl  0x8(%ebp)
  1007f4:	6a 24                	push   $0x24
  1007f6:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1007f9:	50                   	push   %eax
  1007fa:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1007fd:	50                   	push   %eax
  1007fe:	ff 75 f4             	pushl  -0xc(%ebp)
  100801:	e8 a2 fd ff ff       	call   1005a8 <stab_binsearch>
  100806:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun)
  100809:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10080c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10080f:	39 c2                	cmp    %eax,%edx
  100811:	7f 7c                	jg     10088f <debuginfo_eip+0x186>
    {
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr)
  100813:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100816:	89 c2                	mov    %eax,%edx
  100818:	89 d0                	mov    %edx,%eax
  10081a:	01 c0                	add    %eax,%eax
  10081c:	01 d0                	add    %edx,%eax
  10081e:	c1 e0 02             	shl    $0x2,%eax
  100821:	89 c2                	mov    %eax,%edx
  100823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100826:	01 d0                	add    %edx,%eax
  100828:	8b 00                	mov    (%eax),%eax
  10082a:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10082d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100830:	29 d1                	sub    %edx,%ecx
  100832:	89 ca                	mov    %ecx,%edx
  100834:	39 d0                	cmp    %edx,%eax
  100836:	73 22                	jae    10085a <debuginfo_eip+0x151>
        {
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100838:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10083b:	89 c2                	mov    %eax,%edx
  10083d:	89 d0                	mov    %edx,%eax
  10083f:	01 c0                	add    %eax,%eax
  100841:	01 d0                	add    %edx,%eax
  100843:	c1 e0 02             	shl    $0x2,%eax
  100846:	89 c2                	mov    %eax,%edx
  100848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10084b:	01 d0                	add    %edx,%eax
  10084d:	8b 10                	mov    (%eax),%edx
  10084f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100852:	01 c2                	add    %eax,%edx
  100854:	8b 45 0c             	mov    0xc(%ebp),%eax
  100857:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10085a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10085d:	89 c2                	mov    %eax,%edx
  10085f:	89 d0                	mov    %edx,%eax
  100861:	01 c0                	add    %eax,%eax
  100863:	01 d0                	add    %edx,%eax
  100865:	c1 e0 02             	shl    $0x2,%eax
  100868:	89 c2                	mov    %eax,%edx
  10086a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086d:	01 d0                	add    %edx,%eax
  10086f:	8b 50 08             	mov    0x8(%eax),%edx
  100872:	8b 45 0c             	mov    0xc(%ebp),%eax
  100875:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100878:	8b 45 0c             	mov    0xc(%ebp),%eax
  10087b:	8b 40 10             	mov    0x10(%eax),%eax
  10087e:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100881:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100884:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100887:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10088a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10088d:	eb 15                	jmp    1008a4 <debuginfo_eip+0x19b>
    }
    else
    {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10088f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100892:	8b 55 08             	mov    0x8(%ebp),%edx
  100895:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10089b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  10089e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1008a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1008a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008a7:	8b 40 08             	mov    0x8(%eax),%eax
  1008aa:	83 ec 08             	sub    $0x8,%esp
  1008ad:	6a 3a                	push   $0x3a
  1008af:	50                   	push   %eax
  1008b0:	e8 3c 25 00 00       	call   102df1 <strfind>
  1008b5:	83 c4 10             	add    $0x10,%esp
  1008b8:	89 c2                	mov    %eax,%edx
  1008ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008bd:	8b 40 08             	mov    0x8(%eax),%eax
  1008c0:	29 c2                	sub    %eax,%edx
  1008c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008c5:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1008c8:	83 ec 0c             	sub    $0xc,%esp
  1008cb:	ff 75 08             	pushl  0x8(%ebp)
  1008ce:	6a 44                	push   $0x44
  1008d0:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1008d3:	50                   	push   %eax
  1008d4:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1008d7:	50                   	push   %eax
  1008d8:	ff 75 f4             	pushl  -0xc(%ebp)
  1008db:	e8 c8 fc ff ff       	call   1005a8 <stab_binsearch>
  1008e0:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline)
  1008e3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1008e9:	39 c2                	cmp    %eax,%edx
  1008eb:	7f 24                	jg     100911 <debuginfo_eip+0x208>
    {
        info->eip_line = stabs[rline].n_desc;
  1008ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1008f0:	89 c2                	mov    %eax,%edx
  1008f2:	89 d0                	mov    %edx,%eax
  1008f4:	01 c0                	add    %eax,%eax
  1008f6:	01 d0                	add    %edx,%eax
  1008f8:	c1 e0 02             	shl    $0x2,%eax
  1008fb:	89 c2                	mov    %eax,%edx
  1008fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100900:	01 d0                	add    %edx,%eax
  100902:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100906:	0f b7 d0             	movzwl %ax,%edx
  100909:	8b 45 0c             	mov    0xc(%ebp),%eax
  10090c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile && stabs[lline].n_type != N_SOL && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
  10090f:	eb 13                	jmp    100924 <debuginfo_eip+0x21b>
        return -1;
  100911:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100916:	e9 12 01 00 00       	jmp    100a2d <debuginfo_eip+0x324>
    {
        lline--;
  10091b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10091e:	83 e8 01             	sub    $0x1,%eax
  100921:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile && stabs[lline].n_type != N_SOL && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
  100924:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100927:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10092a:	39 c2                	cmp    %eax,%edx
  10092c:	7c 56                	jl     100984 <debuginfo_eip+0x27b>
  10092e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100931:	89 c2                	mov    %eax,%edx
  100933:	89 d0                	mov    %edx,%eax
  100935:	01 c0                	add    %eax,%eax
  100937:	01 d0                	add    %edx,%eax
  100939:	c1 e0 02             	shl    $0x2,%eax
  10093c:	89 c2                	mov    %eax,%edx
  10093e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100941:	01 d0                	add    %edx,%eax
  100943:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100947:	3c 84                	cmp    $0x84,%al
  100949:	74 39                	je     100984 <debuginfo_eip+0x27b>
  10094b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10094e:	89 c2                	mov    %eax,%edx
  100950:	89 d0                	mov    %edx,%eax
  100952:	01 c0                	add    %eax,%eax
  100954:	01 d0                	add    %edx,%eax
  100956:	c1 e0 02             	shl    $0x2,%eax
  100959:	89 c2                	mov    %eax,%edx
  10095b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10095e:	01 d0                	add    %edx,%eax
  100960:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100964:	3c 64                	cmp    $0x64,%al
  100966:	75 b3                	jne    10091b <debuginfo_eip+0x212>
  100968:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10096b:	89 c2                	mov    %eax,%edx
  10096d:	89 d0                	mov    %edx,%eax
  10096f:	01 c0                	add    %eax,%eax
  100971:	01 d0                	add    %edx,%eax
  100973:	c1 e0 02             	shl    $0x2,%eax
  100976:	89 c2                	mov    %eax,%edx
  100978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10097b:	01 d0                	add    %edx,%eax
  10097d:	8b 40 08             	mov    0x8(%eax),%eax
  100980:	85 c0                	test   %eax,%eax
  100982:	74 97                	je     10091b <debuginfo_eip+0x212>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
  100984:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10098a:	39 c2                	cmp    %eax,%edx
  10098c:	7c 46                	jl     1009d4 <debuginfo_eip+0x2cb>
  10098e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100991:	89 c2                	mov    %eax,%edx
  100993:	89 d0                	mov    %edx,%eax
  100995:	01 c0                	add    %eax,%eax
  100997:	01 d0                	add    %edx,%eax
  100999:	c1 e0 02             	shl    $0x2,%eax
  10099c:	89 c2                	mov    %eax,%edx
  10099e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009a1:	01 d0                	add    %edx,%eax
  1009a3:	8b 00                	mov    (%eax),%eax
  1009a5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1009a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1009ab:	29 d1                	sub    %edx,%ecx
  1009ad:	89 ca                	mov    %ecx,%edx
  1009af:	39 d0                	cmp    %edx,%eax
  1009b1:	73 21                	jae    1009d4 <debuginfo_eip+0x2cb>
    {
        info->eip_file = stabstr + stabs[lline].n_strx;
  1009b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1009b6:	89 c2                	mov    %eax,%edx
  1009b8:	89 d0                	mov    %edx,%eax
  1009ba:	01 c0                	add    %eax,%eax
  1009bc:	01 d0                	add    %edx,%eax
  1009be:	c1 e0 02             	shl    $0x2,%eax
  1009c1:	89 c2                	mov    %eax,%edx
  1009c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009c6:	01 d0                	add    %edx,%eax
  1009c8:	8b 10                	mov    (%eax),%edx
  1009ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1009cd:	01 c2                	add    %eax,%edx
  1009cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1009d2:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun)
  1009d4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1009d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1009da:	39 c2                	cmp    %eax,%edx
  1009dc:	7d 4a                	jge    100a28 <debuginfo_eip+0x31f>
    {
        for (lline = lfun + 1;
  1009de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009e1:	83 c0 01             	add    $0x1,%eax
  1009e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1009e7:	eb 18                	jmp    100a01 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline++)
        {
            info->eip_fn_narg++;
  1009e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1009ec:	8b 40 14             	mov    0x14(%eax),%eax
  1009ef:	8d 50 01             	lea    0x1(%eax),%edx
  1009f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1009f5:	89 50 14             	mov    %edx,0x14(%eax)
             lline++)
  1009f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1009fb:	83 c0 01             	add    $0x1,%eax
  1009fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100a01:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100a04:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100a07:	39 c2                	cmp    %eax,%edx
  100a09:	7d 1d                	jge    100a28 <debuginfo_eip+0x31f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100a0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a0e:	89 c2                	mov    %eax,%edx
  100a10:	89 d0                	mov    %edx,%eax
  100a12:	01 c0                	add    %eax,%eax
  100a14:	01 d0                	add    %edx,%eax
  100a16:	c1 e0 02             	shl    $0x2,%eax
  100a19:	89 c2                	mov    %eax,%edx
  100a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a1e:	01 d0                	add    %edx,%eax
  100a20:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100a24:	3c a0                	cmp    $0xa0,%al
  100a26:	74 c1                	je     1009e9 <debuginfo_eip+0x2e0>
        }
    }
    return 0;
  100a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100a2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100a30:	c9                   	leave  
  100a31:	c3                   	ret    

00100a32 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
  100a32:	55                   	push   %ebp
  100a33:	89 e5                	mov    %esp,%ebp
  100a35:	53                   	push   %ebx
  100a36:	83 ec 04             	sub    $0x4,%esp
  100a39:	e8 42 f8 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100a3e:	81 c3 12 df 00 00    	add    $0xdf12,%ebx
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100a44:	83 ec 0c             	sub    $0xc,%esp
  100a47:	8d 83 72 4f ff ff    	lea    -0xb08e(%ebx),%eax
  100a4d:	50                   	push   %eax
  100a4e:	e8 a0 f8 ff ff       	call   1002f3 <cprintf>
  100a53:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100a56:	83 ec 08             	sub    $0x8,%esp
  100a59:	c7 c0 00 00 10 00    	mov    $0x100000,%eax
  100a5f:	50                   	push   %eax
  100a60:	8d 83 8b 4f ff ff    	lea    -0xb075(%ebx),%eax
  100a66:	50                   	push   %eax
  100a67:	e8 87 f8 ff ff       	call   1002f3 <cprintf>
  100a6c:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100a6f:	83 ec 08             	sub    $0x8,%esp
  100a72:	c7 c0 bd 37 10 00    	mov    $0x1037bd,%eax
  100a78:	50                   	push   %eax
  100a79:	8d 83 a3 4f ff ff    	lea    -0xb05d(%ebx),%eax
  100a7f:	50                   	push   %eax
  100a80:	e8 6e f8 ff ff       	call   1002f3 <cprintf>
  100a85:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100a88:	83 ec 08             	sub    $0x8,%esp
  100a8b:	c7 c0 50 e9 10 00    	mov    $0x10e950,%eax
  100a91:	50                   	push   %eax
  100a92:	8d 83 bb 4f ff ff    	lea    -0xb045(%ebx),%eax
  100a98:	50                   	push   %eax
  100a99:	e8 55 f8 ff ff       	call   1002f3 <cprintf>
  100a9e:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100aa1:	83 ec 08             	sub    $0x8,%esp
  100aa4:	c7 c0 c0 fd 10 00    	mov    $0x10fdc0,%eax
  100aaa:	50                   	push   %eax
  100aab:	8d 83 d3 4f ff ff    	lea    -0xb02d(%ebx),%eax
  100ab1:	50                   	push   %eax
  100ab2:	e8 3c f8 ff ff       	call   1002f3 <cprintf>
  100ab7:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023) / 1024);
  100aba:	c7 c0 c0 fd 10 00    	mov    $0x10fdc0,%eax
  100ac0:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100ac6:	c7 c0 00 00 10 00    	mov    $0x100000,%eax
  100acc:	29 c2                	sub    %eax,%edx
  100ace:	89 d0                	mov    %edx,%eax
  100ad0:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100ad6:	85 c0                	test   %eax,%eax
  100ad8:	0f 48 c2             	cmovs  %edx,%eax
  100adb:	c1 f8 0a             	sar    $0xa,%eax
  100ade:	83 ec 08             	sub    $0x8,%esp
  100ae1:	50                   	push   %eax
  100ae2:	8d 83 ec 4f ff ff    	lea    -0xb014(%ebx),%eax
  100ae8:	50                   	push   %eax
  100ae9:	e8 05 f8 ff ff       	call   1002f3 <cprintf>
  100aee:	83 c4 10             	add    $0x10,%esp
}
  100af1:	90                   	nop
  100af2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100af5:	c9                   	leave  
  100af6:	c3                   	ret    

00100af7 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void print_debuginfo(uintptr_t eip)
{
  100af7:	55                   	push   %ebp
  100af8:	89 e5                	mov    %esp,%ebp
  100afa:	53                   	push   %ebx
  100afb:	81 ec 24 01 00 00    	sub    $0x124,%esp
  100b01:	e8 7a f7 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100b06:	81 c3 4a de 00 00    	add    $0xde4a,%ebx
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0)
  100b0c:	83 ec 08             	sub    $0x8,%esp
  100b0f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100b12:	50                   	push   %eax
  100b13:	ff 75 08             	pushl  0x8(%ebp)
  100b16:	e8 ee fb ff ff       	call   100709 <debuginfo_eip>
  100b1b:	83 c4 10             	add    $0x10,%esp
  100b1e:	85 c0                	test   %eax,%eax
  100b20:	74 17                	je     100b39 <print_debuginfo+0x42>
    {
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100b22:	83 ec 08             	sub    $0x8,%esp
  100b25:	ff 75 08             	pushl  0x8(%ebp)
  100b28:	8d 83 16 50 ff ff    	lea    -0xafea(%ebx),%eax
  100b2e:	50                   	push   %eax
  100b2f:	e8 bf f7 ff ff       	call   1002f3 <cprintf>
  100b34:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100b37:	eb 67                	jmp    100ba0 <print_debuginfo+0xa9>
        for (j = 0; j < info.eip_fn_namelen; j++)
  100b39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b40:	eb 1c                	jmp    100b5e <print_debuginfo+0x67>
            fnname[j] = info.eip_fn_name[j];
  100b42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b48:	01 d0                	add    %edx,%eax
  100b4a:	0f b6 00             	movzbl (%eax),%eax
  100b4d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100b53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b56:	01 ca                	add    %ecx,%edx
  100b58:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j++)
  100b5a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b61:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100b64:	7c dc                	jl     100b42 <print_debuginfo+0x4b>
        fnname[j] = '\0';
  100b66:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b6f:	01 d0                	add    %edx,%eax
  100b71:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100b77:	8b 55 08             	mov    0x8(%ebp),%edx
  100b7a:	89 d1                	mov    %edx,%ecx
  100b7c:	29 c1                	sub    %eax,%ecx
  100b7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100b81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100b84:	83 ec 0c             	sub    $0xc,%esp
  100b87:	51                   	push   %ecx
  100b88:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100b8e:	51                   	push   %ecx
  100b8f:	52                   	push   %edx
  100b90:	50                   	push   %eax
  100b91:	8d 83 32 50 ff ff    	lea    -0xafce(%ebx),%eax
  100b97:	50                   	push   %eax
  100b98:	e8 56 f7 ff ff       	call   1002f3 <cprintf>
  100b9d:	83 c4 20             	add    $0x20,%esp
}
  100ba0:	90                   	nop
  100ba1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100ba4:	c9                   	leave  
  100ba5:	c3                   	ret    

00100ba6 <read_eip>:

static __noinline uint32_t
read_eip(void)
{
  100ba6:	55                   	push   %ebp
  100ba7:	89 e5                	mov    %esp,%ebp
  100ba9:	83 ec 10             	sub    $0x10,%esp
  100bac:	e8 cb f6 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  100bb1:	05 9f dd 00 00       	add    $0xdd9f,%eax
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0"
  100bb6:	8b 45 04             	mov    0x4(%ebp),%eax
  100bb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
                 : "=r"(eip));
    return eip;
  100bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100bbf:	c9                   	leave  
  100bc0:	c3                   	ret    

00100bc1 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void print_stackframe(void)
{
  100bc1:	55                   	push   %ebp
  100bc2:	89 e5                	mov    %esp,%ebp
  100bc4:	53                   	push   %ebx
  100bc5:	83 ec 24             	sub    $0x24,%esp
  100bc8:	e8 b3 f6 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100bcd:	81 c3 83 dd 00 00    	add    $0xdd83,%ebx
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100bd3:	89 e8                	mov    %ebp,%eax
  100bd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100bd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp();
  100bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
  100bde:	e8 c3 ff ff ff       	call   100ba6 <read_eip>
  100be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (int i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  100be6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100bed:	e9 93 00 00 00       	jmp    100c85 <print_stackframe+0xc4>
    {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100bf2:	83 ec 04             	sub    $0x4,%esp
  100bf5:	ff 75 f0             	pushl  -0x10(%ebp)
  100bf8:	ff 75 f4             	pushl  -0xc(%ebp)
  100bfb:	8d 83 44 50 ff ff    	lea    -0xafbc(%ebx),%eax
  100c01:	50                   	push   %eax
  100c02:	e8 ec f6 ff ff       	call   1002f3 <cprintf>
  100c07:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
  100c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c0d:	83 c0 08             	add    $0x8,%eax
  100c10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (int j = 0; j < 4; j++)
  100c13:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100c1a:	eb 28                	jmp    100c44 <print_stackframe+0x83>
        {
            cprintf("0x%08x ", args[j]);
  100c1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100c1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100c29:	01 d0                	add    %edx,%eax
  100c2b:	8b 00                	mov    (%eax),%eax
  100c2d:	83 ec 08             	sub    $0x8,%esp
  100c30:	50                   	push   %eax
  100c31:	8d 83 60 50 ff ff    	lea    -0xafa0(%ebx),%eax
  100c37:	50                   	push   %eax
  100c38:	e8 b6 f6 ff ff       	call   1002f3 <cprintf>
  100c3d:	83 c4 10             	add    $0x10,%esp
        for (int j = 0; j < 4; j++)
  100c40:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100c44:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100c48:	7e d2                	jle    100c1c <print_stackframe+0x5b>
        }
        cprintf("\n");
  100c4a:	83 ec 0c             	sub    $0xc,%esp
  100c4d:	8d 83 68 50 ff ff    	lea    -0xaf98(%ebx),%eax
  100c53:	50                   	push   %eax
  100c54:	e8 9a f6 ff ff       	call   1002f3 <cprintf>
  100c59:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
  100c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100c5f:	83 e8 01             	sub    $0x1,%eax
  100c62:	83 ec 0c             	sub    $0xc,%esp
  100c65:	50                   	push   %eax
  100c66:	e8 8c fe ff ff       	call   100af7 <print_debuginfo>
  100c6b:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
  100c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c71:	83 c0 04             	add    $0x4,%eax
  100c74:	8b 00                	mov    (%eax),%eax
  100c76:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c7c:	8b 00                	mov    (%eax),%eax
  100c7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  100c81:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100c85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c89:	74 0a                	je     100c95 <print_stackframe+0xd4>
  100c8b:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100c8f:	0f 8e 5d ff ff ff    	jle    100bf2 <print_stackframe+0x31>
    }
}
  100c95:	90                   	nop
  100c96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100c99:	c9                   	leave  
  100c9a:	c3                   	ret    

00100c9b <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100c9b:	55                   	push   %ebp
  100c9c:	89 e5                	mov    %esp,%ebp
  100c9e:	53                   	push   %ebx
  100c9f:	83 ec 14             	sub    $0x14,%esp
  100ca2:	e8 d9 f5 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100ca7:	81 c3 a9 dc 00 00    	add    $0xdca9,%ebx
    int argc = 0;
  100cad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100cb4:	eb 0c                	jmp    100cc2 <parse+0x27>
            *buf ++ = '\0';
  100cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  100cb9:	8d 50 01             	lea    0x1(%eax),%edx
  100cbc:	89 55 08             	mov    %edx,0x8(%ebp)
  100cbf:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  100cc5:	0f b6 00             	movzbl (%eax),%eax
  100cc8:	84 c0                	test   %al,%al
  100cca:	74 20                	je     100cec <parse+0x51>
  100ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  100ccf:	0f b6 00             	movzbl (%eax),%eax
  100cd2:	0f be c0             	movsbl %al,%eax
  100cd5:	83 ec 08             	sub    $0x8,%esp
  100cd8:	50                   	push   %eax
  100cd9:	8d 83 ec 50 ff ff    	lea    -0xaf14(%ebx),%eax
  100cdf:	50                   	push   %eax
  100ce0:	e8 cf 20 00 00       	call   102db4 <strchr>
  100ce5:	83 c4 10             	add    $0x10,%esp
  100ce8:	85 c0                	test   %eax,%eax
  100cea:	75 ca                	jne    100cb6 <parse+0x1b>
        }
        if (*buf == '\0') {
  100cec:	8b 45 08             	mov    0x8(%ebp),%eax
  100cef:	0f b6 00             	movzbl (%eax),%eax
  100cf2:	84 c0                	test   %al,%al
  100cf4:	74 69                	je     100d5f <parse+0xc4>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100cf6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100cfa:	75 14                	jne    100d10 <parse+0x75>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100cfc:	83 ec 08             	sub    $0x8,%esp
  100cff:	6a 10                	push   $0x10
  100d01:	8d 83 f1 50 ff ff    	lea    -0xaf0f(%ebx),%eax
  100d07:	50                   	push   %eax
  100d08:	e8 e6 f5 ff ff       	call   1002f3 <cprintf>
  100d0d:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d13:	8d 50 01             	lea    0x1(%eax),%edx
  100d16:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100d19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d23:	01 c2                	add    %eax,%edx
  100d25:	8b 45 08             	mov    0x8(%ebp),%eax
  100d28:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100d2a:	eb 04                	jmp    100d30 <parse+0x95>
            buf ++;
  100d2c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100d30:	8b 45 08             	mov    0x8(%ebp),%eax
  100d33:	0f b6 00             	movzbl (%eax),%eax
  100d36:	84 c0                	test   %al,%al
  100d38:	74 88                	je     100cc2 <parse+0x27>
  100d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  100d3d:	0f b6 00             	movzbl (%eax),%eax
  100d40:	0f be c0             	movsbl %al,%eax
  100d43:	83 ec 08             	sub    $0x8,%esp
  100d46:	50                   	push   %eax
  100d47:	8d 83 ec 50 ff ff    	lea    -0xaf14(%ebx),%eax
  100d4d:	50                   	push   %eax
  100d4e:	e8 61 20 00 00       	call   102db4 <strchr>
  100d53:	83 c4 10             	add    $0x10,%esp
  100d56:	85 c0                	test   %eax,%eax
  100d58:	74 d2                	je     100d2c <parse+0x91>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100d5a:	e9 63 ff ff ff       	jmp    100cc2 <parse+0x27>
            break;
  100d5f:	90                   	nop
        }
    }
    return argc;
  100d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100d63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100d66:	c9                   	leave  
  100d67:	c3                   	ret    

00100d68 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100d68:	55                   	push   %ebp
  100d69:	89 e5                	mov    %esp,%ebp
  100d6b:	56                   	push   %esi
  100d6c:	53                   	push   %ebx
  100d6d:	83 ec 50             	sub    $0x50,%esp
  100d70:	e8 0b f5 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100d75:	81 c3 db db 00 00    	add    $0xdbdb,%ebx
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100d7b:	83 ec 08             	sub    $0x8,%esp
  100d7e:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100d81:	50                   	push   %eax
  100d82:	ff 75 08             	pushl  0x8(%ebp)
  100d85:	e8 11 ff ff ff       	call   100c9b <parse>
  100d8a:	83 c4 10             	add    $0x10,%esp
  100d8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100d90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100d94:	75 0a                	jne    100da0 <runcmd+0x38>
        return 0;
  100d96:	b8 00 00 00 00       	mov    $0x0,%eax
  100d9b:	e9 8b 00 00 00       	jmp    100e2b <runcmd+0xc3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100da0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100da7:	eb 5f                	jmp    100e08 <runcmd+0xa0>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100da9:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100dac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100daf:	8d b3 10 00 00 00    	lea    0x10(%ebx),%esi
  100db5:	89 d0                	mov    %edx,%eax
  100db7:	01 c0                	add    %eax,%eax
  100db9:	01 d0                	add    %edx,%eax
  100dbb:	c1 e0 02             	shl    $0x2,%eax
  100dbe:	01 f0                	add    %esi,%eax
  100dc0:	8b 00                	mov    (%eax),%eax
  100dc2:	83 ec 08             	sub    $0x8,%esp
  100dc5:	51                   	push   %ecx
  100dc6:	50                   	push   %eax
  100dc7:	e8 34 1f 00 00       	call   102d00 <strcmp>
  100dcc:	83 c4 10             	add    $0x10,%esp
  100dcf:	85 c0                	test   %eax,%eax
  100dd1:	75 31                	jne    100e04 <runcmd+0x9c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100dd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100dd6:	8d 8b 18 00 00 00    	lea    0x18(%ebx),%ecx
  100ddc:	89 d0                	mov    %edx,%eax
  100dde:	01 c0                	add    %eax,%eax
  100de0:	01 d0                	add    %edx,%eax
  100de2:	c1 e0 02             	shl    $0x2,%eax
  100de5:	01 c8                	add    %ecx,%eax
  100de7:	8b 10                	mov    (%eax),%edx
  100de9:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100dec:	83 c0 04             	add    $0x4,%eax
  100def:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100df2:	83 e9 01             	sub    $0x1,%ecx
  100df5:	83 ec 04             	sub    $0x4,%esp
  100df8:	ff 75 0c             	pushl  0xc(%ebp)
  100dfb:	50                   	push   %eax
  100dfc:	51                   	push   %ecx
  100dfd:	ff d2                	call   *%edx
  100dff:	83 c4 10             	add    $0x10,%esp
  100e02:	eb 27                	jmp    100e2b <runcmd+0xc3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100e04:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e0b:	83 f8 02             	cmp    $0x2,%eax
  100e0e:	76 99                	jbe    100da9 <runcmd+0x41>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100e10:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100e13:	83 ec 08             	sub    $0x8,%esp
  100e16:	50                   	push   %eax
  100e17:	8d 83 0f 51 ff ff    	lea    -0xaef1(%ebx),%eax
  100e1d:	50                   	push   %eax
  100e1e:	e8 d0 f4 ff ff       	call   1002f3 <cprintf>
  100e23:	83 c4 10             	add    $0x10,%esp
    return 0;
  100e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  100e2e:	5b                   	pop    %ebx
  100e2f:	5e                   	pop    %esi
  100e30:	5d                   	pop    %ebp
  100e31:	c3                   	ret    

00100e32 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100e32:	55                   	push   %ebp
  100e33:	89 e5                	mov    %esp,%ebp
  100e35:	53                   	push   %ebx
  100e36:	83 ec 14             	sub    $0x14,%esp
  100e39:	e8 42 f4 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100e3e:	81 c3 12 db 00 00    	add    $0xdb12,%ebx
    cprintf("Welcome to the kernel debug monitor!!\n");
  100e44:	83 ec 0c             	sub    $0xc,%esp
  100e47:	8d 83 28 51 ff ff    	lea    -0xaed8(%ebx),%eax
  100e4d:	50                   	push   %eax
  100e4e:	e8 a0 f4 ff ff       	call   1002f3 <cprintf>
  100e53:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100e56:	83 ec 0c             	sub    $0xc,%esp
  100e59:	8d 83 50 51 ff ff    	lea    -0xaeb0(%ebx),%eax
  100e5f:	50                   	push   %eax
  100e60:	e8 8e f4 ff ff       	call   1002f3 <cprintf>
  100e65:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100e68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e6c:	74 0e                	je     100e7c <kmonitor+0x4a>
        print_trapframe(tf);
  100e6e:	83 ec 0c             	sub    $0xc,%esp
  100e71:	ff 75 08             	pushl  0x8(%ebp)
  100e74:	e8 8d 0d 00 00       	call   101c06 <print_trapframe>
  100e79:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100e7c:	83 ec 0c             	sub    $0xc,%esp
  100e7f:	8d 83 75 51 ff ff    	lea    -0xae8b(%ebx),%eax
  100e85:	50                   	push   %eax
  100e86:	e8 40 f5 ff ff       	call   1003cb <readline>
  100e8b:	83 c4 10             	add    $0x10,%esp
  100e8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100e91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100e95:	74 e5                	je     100e7c <kmonitor+0x4a>
            if (runcmd(buf, tf) < 0) {
  100e97:	83 ec 08             	sub    $0x8,%esp
  100e9a:	ff 75 08             	pushl  0x8(%ebp)
  100e9d:	ff 75 f4             	pushl  -0xc(%ebp)
  100ea0:	e8 c3 fe ff ff       	call   100d68 <runcmd>
  100ea5:	83 c4 10             	add    $0x10,%esp
  100ea8:	85 c0                	test   %eax,%eax
  100eaa:	78 02                	js     100eae <kmonitor+0x7c>
        if ((buf = readline("K> ")) != NULL) {
  100eac:	eb ce                	jmp    100e7c <kmonitor+0x4a>
                break;
  100eae:	90                   	nop
            }
        }
    }
}
  100eaf:	90                   	nop
  100eb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100eb3:	c9                   	leave  
  100eb4:	c3                   	ret    

00100eb5 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100eb5:	55                   	push   %ebp
  100eb6:	89 e5                	mov    %esp,%ebp
  100eb8:	56                   	push   %esi
  100eb9:	53                   	push   %ebx
  100eba:	83 ec 10             	sub    $0x10,%esp
  100ebd:	e8 be f3 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100ec2:	81 c3 8e da 00 00    	add    $0xda8e,%ebx
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ec8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ecf:	eb 44                	jmp    100f15 <mon_help+0x60>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100ed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ed4:	8d 8b 14 00 00 00    	lea    0x14(%ebx),%ecx
  100eda:	89 d0                	mov    %edx,%eax
  100edc:	01 c0                	add    %eax,%eax
  100ede:	01 d0                	add    %edx,%eax
  100ee0:	c1 e0 02             	shl    $0x2,%eax
  100ee3:	01 c8                	add    %ecx,%eax
  100ee5:	8b 08                	mov    (%eax),%ecx
  100ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100eea:	8d b3 10 00 00 00    	lea    0x10(%ebx),%esi
  100ef0:	89 d0                	mov    %edx,%eax
  100ef2:	01 c0                	add    %eax,%eax
  100ef4:	01 d0                	add    %edx,%eax
  100ef6:	c1 e0 02             	shl    $0x2,%eax
  100ef9:	01 f0                	add    %esi,%eax
  100efb:	8b 00                	mov    (%eax),%eax
  100efd:	83 ec 04             	sub    $0x4,%esp
  100f00:	51                   	push   %ecx
  100f01:	50                   	push   %eax
  100f02:	8d 83 79 51 ff ff    	lea    -0xae87(%ebx),%eax
  100f08:	50                   	push   %eax
  100f09:	e8 e5 f3 ff ff       	call   1002f3 <cprintf>
  100f0e:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100f11:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f18:	83 f8 02             	cmp    $0x2,%eax
  100f1b:	76 b4                	jbe    100ed1 <mon_help+0x1c>
    }
    return 0;
  100f1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100f22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  100f25:	5b                   	pop    %ebx
  100f26:	5e                   	pop    %esi
  100f27:	5d                   	pop    %ebp
  100f28:	c3                   	ret    

00100f29 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100f29:	55                   	push   %ebp
  100f2a:	89 e5                	mov    %esp,%ebp
  100f2c:	53                   	push   %ebx
  100f2d:	83 ec 04             	sub    $0x4,%esp
  100f30:	e8 47 f3 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  100f35:	05 1b da 00 00       	add    $0xda1b,%eax
    print_kerninfo();
  100f3a:	89 c3                	mov    %eax,%ebx
  100f3c:	e8 f1 fa ff ff       	call   100a32 <print_kerninfo>
    return 0;
  100f41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100f46:	83 c4 04             	add    $0x4,%esp
  100f49:	5b                   	pop    %ebx
  100f4a:	5d                   	pop    %ebp
  100f4b:	c3                   	ret    

00100f4c <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100f4c:	55                   	push   %ebp
  100f4d:	89 e5                	mov    %esp,%ebp
  100f4f:	53                   	push   %ebx
  100f50:	83 ec 04             	sub    $0x4,%esp
  100f53:	e8 24 f3 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  100f58:	05 f8 d9 00 00       	add    $0xd9f8,%eax
    print_stackframe();
  100f5d:	89 c3                	mov    %eax,%ebx
  100f5f:	e8 5d fc ff ff       	call   100bc1 <print_stackframe>
    return 0;
  100f64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100f69:	83 c4 04             	add    $0x4,%esp
  100f6c:	5b                   	pop    %ebx
  100f6d:	5d                   	pop    %ebp
  100f6e:	c3                   	ret    

00100f6f <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100f6f:	55                   	push   %ebp
  100f70:	89 e5                	mov    %esp,%ebp
  100f72:	53                   	push   %ebx
  100f73:	83 ec 14             	sub    $0x14,%esp
  100f76:	e8 05 f3 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100f7b:	81 c3 d5 d9 00 00    	add    $0xd9d5,%ebx
  100f81:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100f87:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f8b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f8f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f93:	ee                   	out    %al,(%dx)
  100f94:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100f9a:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100f9e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fa2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100fa6:	ee                   	out    %al,(%dx)
  100fa7:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100fad:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100fb1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100fb5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100fb9:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100fba:	c7 c0 a8 f9 10 00    	mov    $0x10f9a8,%eax
  100fc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("++ setup timer interrupts\n");
  100fc6:	83 ec 0c             	sub    $0xc,%esp
  100fc9:	8d 83 82 51 ff ff    	lea    -0xae7e(%ebx),%eax
  100fcf:	50                   	push   %eax
  100fd0:	e8 1e f3 ff ff       	call   1002f3 <cprintf>
  100fd5:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100fd8:	83 ec 0c             	sub    $0xc,%esp
  100fdb:	6a 00                	push   $0x0
  100fdd:	e8 e7 09 00 00       	call   1019c9 <pic_enable>
  100fe2:	83 c4 10             	add    $0x10,%esp
}
  100fe5:	90                   	nop
  100fe6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100fe9:	c9                   	leave  
  100fea:	c3                   	ret    

00100feb <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100feb:	55                   	push   %ebp
  100fec:	89 e5                	mov    %esp,%ebp
  100fee:	83 ec 10             	sub    $0x10,%esp
  100ff1:	e8 86 f2 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  100ff6:	05 5a d9 00 00       	add    $0xd95a,%eax
  100ffb:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101001:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101005:	89 c2                	mov    %eax,%edx
  101007:	ec                   	in     (%dx),%al
  101008:	88 45 f1             	mov    %al,-0xf(%ebp)
  10100b:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  101011:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101015:	89 c2                	mov    %eax,%edx
  101017:	ec                   	in     (%dx),%al
  101018:	88 45 f5             	mov    %al,-0xb(%ebp)
  10101b:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  101021:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101025:	89 c2                	mov    %eax,%edx
  101027:	ec                   	in     (%dx),%al
  101028:	88 45 f9             	mov    %al,-0x7(%ebp)
  10102b:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  101031:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  101035:	89 c2                	mov    %eax,%edx
  101037:	ec                   	in     (%dx),%al
  101038:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  10103b:	90                   	nop
  10103c:	c9                   	leave  
  10103d:	c3                   	ret    

0010103e <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  10103e:	55                   	push   %ebp
  10103f:	89 e5                	mov    %esp,%ebp
  101041:	83 ec 20             	sub    $0x20,%esp
  101044:	e8 17 09 00 00       	call   101960 <__x86.get_pc_thunk.cx>
  101049:	81 c1 07 d9 00 00    	add    $0xd907,%ecx
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  10104f:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  101056:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101059:	0f b7 00             	movzwl (%eax),%eax
  10105c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  101060:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101063:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  101068:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10106b:	0f b7 00             	movzwl (%eax),%eax
  10106e:	66 3d 5a a5          	cmp    $0xa55a,%ax
  101072:	74 12                	je     101086 <cga_init+0x48>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  101074:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  10107b:	66 c7 81 b6 05 00 00 	movw   $0x3b4,0x5b6(%ecx)
  101082:	b4 03 
  101084:	eb 13                	jmp    101099 <cga_init+0x5b>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  101086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101089:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10108d:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  101090:	66 c7 81 b6 05 00 00 	movw   $0x3d4,0x5b6(%ecx)
  101097:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  101099:	0f b7 81 b6 05 00 00 	movzwl 0x5b6(%ecx),%eax
  1010a0:	0f b7 c0             	movzwl %ax,%eax
  1010a3:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1010a7:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010ab:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1010af:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1010b3:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  1010b4:	0f b7 81 b6 05 00 00 	movzwl 0x5b6(%ecx),%eax
  1010bb:	83 c0 01             	add    $0x1,%eax
  1010be:	0f b7 c0             	movzwl %ax,%eax
  1010c1:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1010c5:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  1010c9:	89 c2                	mov    %eax,%edx
  1010cb:	ec                   	in     (%dx),%al
  1010cc:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  1010cf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1010d3:	0f b6 c0             	movzbl %al,%eax
  1010d6:	c1 e0 08             	shl    $0x8,%eax
  1010d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  1010dc:	0f b7 81 b6 05 00 00 	movzwl 0x5b6(%ecx),%eax
  1010e3:	0f b7 c0             	movzwl %ax,%eax
  1010e6:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1010ea:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010ee:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010f2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010f6:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  1010f7:	0f b7 81 b6 05 00 00 	movzwl 0x5b6(%ecx),%eax
  1010fe:	83 c0 01             	add    $0x1,%eax
  101101:	0f b7 c0             	movzwl %ax,%eax
  101104:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101108:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10110c:	89 c2                	mov    %eax,%edx
  10110e:	ec                   	in     (%dx),%al
  10110f:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  101112:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101116:	0f b6 c0             	movzbl %al,%eax
  101119:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  10111c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10111f:	89 81 b0 05 00 00    	mov    %eax,0x5b0(%ecx)
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  101125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101128:	66 89 81 b4 05 00 00 	mov    %ax,0x5b4(%ecx)
}
  10112f:	90                   	nop
  101130:	c9                   	leave  
  101131:	c3                   	ret    

00101132 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  101132:	55                   	push   %ebp
  101133:	89 e5                	mov    %esp,%ebp
  101135:	53                   	push   %ebx
  101136:	83 ec 34             	sub    $0x34,%esp
  101139:	e8 22 08 00 00       	call   101960 <__x86.get_pc_thunk.cx>
  10113e:	81 c1 12 d8 00 00    	add    $0xd812,%ecx
  101144:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  10114a:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10114e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101152:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101156:	ee                   	out    %al,(%dx)
  101157:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  10115d:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  101161:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101165:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101169:	ee                   	out    %al,(%dx)
  10116a:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  101170:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  101174:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101178:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10117c:	ee                   	out    %al,(%dx)
  10117d:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  101183:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  101187:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10118b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10118f:	ee                   	out    %al,(%dx)
  101190:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  101196:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  10119a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10119e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1011a2:	ee                   	out    %al,(%dx)
  1011a3:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  1011a9:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  1011ad:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011b1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011b5:	ee                   	out    %al,(%dx)
  1011b6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  1011bc:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  1011c0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011c4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1011c8:	ee                   	out    %al,(%dx)
  1011c9:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1011cf:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  1011d3:	89 c2                	mov    %eax,%edx
  1011d5:	ec                   	in     (%dx),%al
  1011d6:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  1011d9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  1011dd:	3c ff                	cmp    $0xff,%al
  1011df:	0f 95 c0             	setne  %al
  1011e2:	0f b6 c0             	movzbl %al,%eax
  1011e5:	89 81 b8 05 00 00    	mov    %eax,0x5b8(%ecx)
  1011eb:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1011f1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1011f5:	89 c2                	mov    %eax,%edx
  1011f7:	ec                   	in     (%dx),%al
  1011f8:	88 45 f1             	mov    %al,-0xf(%ebp)
  1011fb:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101201:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101205:	89 c2                	mov    %eax,%edx
  101207:	ec                   	in     (%dx),%al
  101208:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10120b:	8b 81 b8 05 00 00    	mov    0x5b8(%ecx),%eax
  101211:	85 c0                	test   %eax,%eax
  101213:	74 0f                	je     101224 <serial_init+0xf2>
        pic_enable(IRQ_COM1);
  101215:	83 ec 0c             	sub    $0xc,%esp
  101218:	6a 04                	push   $0x4
  10121a:	89 cb                	mov    %ecx,%ebx
  10121c:	e8 a8 07 00 00       	call   1019c9 <pic_enable>
  101221:	83 c4 10             	add    $0x10,%esp
    }
}
  101224:	90                   	nop
  101225:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101228:	c9                   	leave  
  101229:	c3                   	ret    

0010122a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10122a:	55                   	push   %ebp
  10122b:	89 e5                	mov    %esp,%ebp
  10122d:	83 ec 20             	sub    $0x20,%esp
  101230:	e8 47 f0 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101235:	05 1b d7 00 00       	add    $0xd71b,%eax
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10123a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101241:	eb 09                	jmp    10124c <lpt_putc_sub+0x22>
        delay();
  101243:	e8 a3 fd ff ff       	call   100feb <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101248:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10124c:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101252:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101256:	89 c2                	mov    %eax,%edx
  101258:	ec                   	in     (%dx),%al
  101259:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10125c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101260:	84 c0                	test   %al,%al
  101262:	78 09                	js     10126d <lpt_putc_sub+0x43>
  101264:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10126b:	7e d6                	jle    101243 <lpt_putc_sub+0x19>
    }
    outb(LPTPORT + 0, c);
  10126d:	8b 45 08             	mov    0x8(%ebp),%eax
  101270:	0f b6 c0             	movzbl %al,%eax
  101273:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101279:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10127c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101280:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101284:	ee                   	out    %al,(%dx)
  101285:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10128b:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10128f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101293:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101297:	ee                   	out    %al,(%dx)
  101298:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10129e:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  1012a2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012a6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012aa:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1012ab:	90                   	nop
  1012ac:	c9                   	leave  
  1012ad:	c3                   	ret    

001012ae <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1012ae:	55                   	push   %ebp
  1012af:	89 e5                	mov    %esp,%ebp
  1012b1:	e8 c6 ef ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1012b6:	05 9a d6 00 00       	add    $0xd69a,%eax
    if (c != '\b') {
  1012bb:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012bf:	74 0d                	je     1012ce <lpt_putc+0x20>
        lpt_putc_sub(c);
  1012c1:	ff 75 08             	pushl  0x8(%ebp)
  1012c4:	e8 61 ff ff ff       	call   10122a <lpt_putc_sub>
  1012c9:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1012cc:	eb 1e                	jmp    1012ec <lpt_putc+0x3e>
        lpt_putc_sub('\b');
  1012ce:	6a 08                	push   $0x8
  1012d0:	e8 55 ff ff ff       	call   10122a <lpt_putc_sub>
  1012d5:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  1012d8:	6a 20                	push   $0x20
  1012da:	e8 4b ff ff ff       	call   10122a <lpt_putc_sub>
  1012df:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  1012e2:	6a 08                	push   $0x8
  1012e4:	e8 41 ff ff ff       	call   10122a <lpt_putc_sub>
  1012e9:	83 c4 04             	add    $0x4,%esp
}
  1012ec:	90                   	nop
  1012ed:	c9                   	leave  
  1012ee:	c3                   	ret    

001012ef <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1012ef:	55                   	push   %ebp
  1012f0:	89 e5                	mov    %esp,%ebp
  1012f2:	56                   	push   %esi
  1012f3:	53                   	push   %ebx
  1012f4:	83 ec 20             	sub    $0x20,%esp
  1012f7:	e8 84 ef ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  1012fc:	81 c3 54 d6 00 00    	add    $0xd654,%ebx
    // set black on white
    if (!(c & ~0xFF)) {
  101302:	8b 45 08             	mov    0x8(%ebp),%eax
  101305:	b0 00                	mov    $0x0,%al
  101307:	85 c0                	test   %eax,%eax
  101309:	75 07                	jne    101312 <cga_putc+0x23>
        c |= 0x0700;
  10130b:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101312:	8b 45 08             	mov    0x8(%ebp),%eax
  101315:	0f b6 c0             	movzbl %al,%eax
  101318:	83 f8 0a             	cmp    $0xa,%eax
  10131b:	74 54                	je     101371 <cga_putc+0x82>
  10131d:	83 f8 0d             	cmp    $0xd,%eax
  101320:	74 60                	je     101382 <cga_putc+0x93>
  101322:	83 f8 08             	cmp    $0x8,%eax
  101325:	0f 85 92 00 00 00    	jne    1013bd <cga_putc+0xce>
    case '\b':
        if (crt_pos > 0) {
  10132b:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  101332:	66 85 c0             	test   %ax,%ax
  101335:	0f 84 a8 00 00 00    	je     1013e3 <cga_putc+0xf4>
            crt_pos --;
  10133b:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  101342:	83 e8 01             	sub    $0x1,%eax
  101345:	66 89 83 b4 05 00 00 	mov    %ax,0x5b4(%ebx)
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10134c:	8b 45 08             	mov    0x8(%ebp),%eax
  10134f:	b0 00                	mov    $0x0,%al
  101351:	83 c8 20             	or     $0x20,%eax
  101354:	89 c1                	mov    %eax,%ecx
  101356:	8b 83 b0 05 00 00    	mov    0x5b0(%ebx),%eax
  10135c:	0f b7 93 b4 05 00 00 	movzwl 0x5b4(%ebx),%edx
  101363:	0f b7 d2             	movzwl %dx,%edx
  101366:	01 d2                	add    %edx,%edx
  101368:	01 d0                	add    %edx,%eax
  10136a:	89 ca                	mov    %ecx,%edx
  10136c:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  10136f:	eb 72                	jmp    1013e3 <cga_putc+0xf4>
    case '\n':
        crt_pos += CRT_COLS;
  101371:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  101378:	83 c0 50             	add    $0x50,%eax
  10137b:	66 89 83 b4 05 00 00 	mov    %ax,0x5b4(%ebx)
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101382:	0f b7 b3 b4 05 00 00 	movzwl 0x5b4(%ebx),%esi
  101389:	0f b7 8b b4 05 00 00 	movzwl 0x5b4(%ebx),%ecx
  101390:	0f b7 c1             	movzwl %cx,%eax
  101393:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101399:	c1 e8 10             	shr    $0x10,%eax
  10139c:	89 c2                	mov    %eax,%edx
  10139e:	66 c1 ea 06          	shr    $0x6,%dx
  1013a2:	89 d0                	mov    %edx,%eax
  1013a4:	c1 e0 02             	shl    $0x2,%eax
  1013a7:	01 d0                	add    %edx,%eax
  1013a9:	c1 e0 04             	shl    $0x4,%eax
  1013ac:	29 c1                	sub    %eax,%ecx
  1013ae:	89 ca                	mov    %ecx,%edx
  1013b0:	89 f0                	mov    %esi,%eax
  1013b2:	29 d0                	sub    %edx,%eax
  1013b4:	66 89 83 b4 05 00 00 	mov    %ax,0x5b4(%ebx)
        break;
  1013bb:	eb 27                	jmp    1013e4 <cga_putc+0xf5>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1013bd:	8b 8b b0 05 00 00    	mov    0x5b0(%ebx),%ecx
  1013c3:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  1013ca:	8d 50 01             	lea    0x1(%eax),%edx
  1013cd:	66 89 93 b4 05 00 00 	mov    %dx,0x5b4(%ebx)
  1013d4:	0f b7 c0             	movzwl %ax,%eax
  1013d7:	01 c0                	add    %eax,%eax
  1013d9:	01 c8                	add    %ecx,%eax
  1013db:	8b 55 08             	mov    0x8(%ebp),%edx
  1013de:	66 89 10             	mov    %dx,(%eax)
        break;
  1013e1:	eb 01                	jmp    1013e4 <cga_putc+0xf5>
        break;
  1013e3:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1013e4:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  1013eb:	66 3d cf 07          	cmp    $0x7cf,%ax
  1013ef:	76 5d                	jbe    10144e <cga_putc+0x15f>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1013f1:	8b 83 b0 05 00 00    	mov    0x5b0(%ebx),%eax
  1013f7:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1013fd:	8b 83 b0 05 00 00    	mov    0x5b0(%ebx),%eax
  101403:	83 ec 04             	sub    $0x4,%esp
  101406:	68 00 0f 00 00       	push   $0xf00
  10140b:	52                   	push   %edx
  10140c:	50                   	push   %eax
  10140d:	e8 c9 1b 00 00       	call   102fdb <memmove>
  101412:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101415:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10141c:	eb 16                	jmp    101434 <cga_putc+0x145>
            crt_buf[i] = 0x0700 | ' ';
  10141e:	8b 83 b0 05 00 00    	mov    0x5b0(%ebx),%eax
  101424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101427:	01 d2                	add    %edx,%edx
  101429:	01 d0                	add    %edx,%eax
  10142b:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101430:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101434:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10143b:	7e e1                	jle    10141e <cga_putc+0x12f>
        }
        crt_pos -= CRT_COLS;
  10143d:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  101444:	83 e8 50             	sub    $0x50,%eax
  101447:	66 89 83 b4 05 00 00 	mov    %ax,0x5b4(%ebx)
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10144e:	0f b7 83 b6 05 00 00 	movzwl 0x5b6(%ebx),%eax
  101455:	0f b7 c0             	movzwl %ax,%eax
  101458:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10145c:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  101460:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101464:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101468:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101469:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  101470:	66 c1 e8 08          	shr    $0x8,%ax
  101474:	0f b6 c0             	movzbl %al,%eax
  101477:	0f b7 93 b6 05 00 00 	movzwl 0x5b6(%ebx),%edx
  10147e:	83 c2 01             	add    $0x1,%edx
  101481:	0f b7 d2             	movzwl %dx,%edx
  101484:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101488:	88 45 e9             	mov    %al,-0x17(%ebp)
  10148b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10148f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101493:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101494:	0f b7 83 b6 05 00 00 	movzwl 0x5b6(%ebx),%eax
  10149b:	0f b7 c0             	movzwl %ax,%eax
  10149e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1014a2:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  1014a6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1014aa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1014ae:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1014af:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  1014b6:	0f b6 c0             	movzbl %al,%eax
  1014b9:	0f b7 93 b6 05 00 00 	movzwl 0x5b6(%ebx),%edx
  1014c0:	83 c2 01             	add    $0x1,%edx
  1014c3:	0f b7 d2             	movzwl %dx,%edx
  1014c6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1014ca:	88 45 f1             	mov    %al,-0xf(%ebp)
  1014cd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1014d1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1014d5:	ee                   	out    %al,(%dx)
}
  1014d6:	90                   	nop
  1014d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1014da:	5b                   	pop    %ebx
  1014db:	5e                   	pop    %esi
  1014dc:	5d                   	pop    %ebp
  1014dd:	c3                   	ret    

001014de <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1014de:	55                   	push   %ebp
  1014df:	89 e5                	mov    %esp,%ebp
  1014e1:	83 ec 10             	sub    $0x10,%esp
  1014e4:	e8 93 ed ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1014e9:	05 67 d4 00 00       	add    $0xd467,%eax
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1014ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1014f5:	eb 09                	jmp    101500 <serial_putc_sub+0x22>
        delay();
  1014f7:	e8 ef fa ff ff       	call   100feb <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1014fc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101500:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101506:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10150a:	89 c2                	mov    %eax,%edx
  10150c:	ec                   	in     (%dx),%al
  10150d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101510:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101514:	0f b6 c0             	movzbl %al,%eax
  101517:	83 e0 20             	and    $0x20,%eax
  10151a:	85 c0                	test   %eax,%eax
  10151c:	75 09                	jne    101527 <serial_putc_sub+0x49>
  10151e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101525:	7e d0                	jle    1014f7 <serial_putc_sub+0x19>
    }
    outb(COM1 + COM_TX, c);
  101527:	8b 45 08             	mov    0x8(%ebp),%eax
  10152a:	0f b6 c0             	movzbl %al,%eax
  10152d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101533:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101536:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10153a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10153e:	ee                   	out    %al,(%dx)
}
  10153f:	90                   	nop
  101540:	c9                   	leave  
  101541:	c3                   	ret    

00101542 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101542:	55                   	push   %ebp
  101543:	89 e5                	mov    %esp,%ebp
  101545:	e8 32 ed ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10154a:	05 06 d4 00 00       	add    $0xd406,%eax
    if (c != '\b') {
  10154f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101553:	74 0d                	je     101562 <serial_putc+0x20>
        serial_putc_sub(c);
  101555:	ff 75 08             	pushl  0x8(%ebp)
  101558:	e8 81 ff ff ff       	call   1014de <serial_putc_sub>
  10155d:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101560:	eb 1e                	jmp    101580 <serial_putc+0x3e>
        serial_putc_sub('\b');
  101562:	6a 08                	push   $0x8
  101564:	e8 75 ff ff ff       	call   1014de <serial_putc_sub>
  101569:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  10156c:	6a 20                	push   $0x20
  10156e:	e8 6b ff ff ff       	call   1014de <serial_putc_sub>
  101573:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  101576:	6a 08                	push   $0x8
  101578:	e8 61 ff ff ff       	call   1014de <serial_putc_sub>
  10157d:	83 c4 04             	add    $0x4,%esp
}
  101580:	90                   	nop
  101581:	c9                   	leave  
  101582:	c3                   	ret    

00101583 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101583:	55                   	push   %ebp
  101584:	89 e5                	mov    %esp,%ebp
  101586:	53                   	push   %ebx
  101587:	83 ec 14             	sub    $0x14,%esp
  10158a:	e8 f1 ec ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  10158f:	81 c3 c1 d3 00 00    	add    $0xd3c1,%ebx
    int c;
    while ((c = (*proc)()) != -1) {
  101595:	eb 36                	jmp    1015cd <cons_intr+0x4a>
        if (c != 0) {
  101597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10159b:	74 30                	je     1015cd <cons_intr+0x4a>
            cons.buf[cons.wpos ++] = c;
  10159d:	8b 83 d4 07 00 00    	mov    0x7d4(%ebx),%eax
  1015a3:	8d 50 01             	lea    0x1(%eax),%edx
  1015a6:	89 93 d4 07 00 00    	mov    %edx,0x7d4(%ebx)
  1015ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1015af:	88 94 03 d0 05 00 00 	mov    %dl,0x5d0(%ebx,%eax,1)
            if (cons.wpos == CONSBUFSIZE) {
  1015b6:	8b 83 d4 07 00 00    	mov    0x7d4(%ebx),%eax
  1015bc:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015c1:	75 0a                	jne    1015cd <cons_intr+0x4a>
                cons.wpos = 0;
  1015c3:	c7 83 d4 07 00 00 00 	movl   $0x0,0x7d4(%ebx)
  1015ca:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1015d0:	ff d0                	call   *%eax
  1015d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1015d5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1015d9:	75 bc                	jne    101597 <cons_intr+0x14>
            }
        }
    }
}
  1015db:	90                   	nop
  1015dc:	83 c4 14             	add    $0x14,%esp
  1015df:	5b                   	pop    %ebx
  1015e0:	5d                   	pop    %ebp
  1015e1:	c3                   	ret    

001015e2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1015e2:	55                   	push   %ebp
  1015e3:	89 e5                	mov    %esp,%ebp
  1015e5:	83 ec 10             	sub    $0x10,%esp
  1015e8:	e8 8f ec ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1015ed:	05 63 d3 00 00       	add    $0xd363,%eax
  1015f2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1015f8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1015fc:	89 c2                	mov    %eax,%edx
  1015fe:	ec                   	in     (%dx),%al
  1015ff:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101602:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101606:	0f b6 c0             	movzbl %al,%eax
  101609:	83 e0 01             	and    $0x1,%eax
  10160c:	85 c0                	test   %eax,%eax
  10160e:	75 07                	jne    101617 <serial_proc_data+0x35>
        return -1;
  101610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101615:	eb 2a                	jmp    101641 <serial_proc_data+0x5f>
  101617:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10161d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101621:	89 c2                	mov    %eax,%edx
  101623:	ec                   	in     (%dx),%al
  101624:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101627:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10162b:	0f b6 c0             	movzbl %al,%eax
  10162e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101631:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101635:	75 07                	jne    10163e <serial_proc_data+0x5c>
        c = '\b';
  101637:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10163e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101641:	c9                   	leave  
  101642:	c3                   	ret    

00101643 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101643:	55                   	push   %ebp
  101644:	89 e5                	mov    %esp,%ebp
  101646:	83 ec 08             	sub    $0x8,%esp
  101649:	e8 2e ec ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10164e:	05 02 d3 00 00       	add    $0xd302,%eax
    if (serial_exists) {
  101653:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  101659:	85 d2                	test   %edx,%edx
  10165b:	74 12                	je     10166f <serial_intr+0x2c>
        cons_intr(serial_proc_data);
  10165d:	83 ec 0c             	sub    $0xc,%esp
  101660:	8d 80 92 2c ff ff    	lea    -0xd36e(%eax),%eax
  101666:	50                   	push   %eax
  101667:	e8 17 ff ff ff       	call   101583 <cons_intr>
  10166c:	83 c4 10             	add    $0x10,%esp
    }
}
  10166f:	90                   	nop
  101670:	c9                   	leave  
  101671:	c3                   	ret    

00101672 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101672:	55                   	push   %ebp
  101673:	89 e5                	mov    %esp,%ebp
  101675:	53                   	push   %ebx
  101676:	83 ec 24             	sub    $0x24,%esp
  101679:	e8 e2 02 00 00       	call   101960 <__x86.get_pc_thunk.cx>
  10167e:	81 c1 d2 d2 00 00    	add    $0xd2d2,%ecx
  101684:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10168a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10168e:	89 c2                	mov    %eax,%edx
  101690:	ec                   	in     (%dx),%al
  101691:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101694:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101698:	0f b6 c0             	movzbl %al,%eax
  10169b:	83 e0 01             	and    $0x1,%eax
  10169e:	85 c0                	test   %eax,%eax
  1016a0:	75 0a                	jne    1016ac <kbd_proc_data+0x3a>
        return -1;
  1016a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1016a7:	e9 73 01 00 00       	jmp    10181f <kbd_proc_data+0x1ad>
  1016ac:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1016b2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016b6:	89 c2                	mov    %eax,%edx
  1016b8:	ec                   	in     (%dx),%al
  1016b9:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1016bc:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1016c0:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1016c3:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1016c7:	75 19                	jne    1016e2 <kbd_proc_data+0x70>
        // E0 escape character
        shift |= E0ESC;
  1016c9:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  1016cf:	83 c8 40             	or     $0x40,%eax
  1016d2:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)
        return 0;
  1016d8:	b8 00 00 00 00       	mov    $0x0,%eax
  1016dd:	e9 3d 01 00 00       	jmp    10181f <kbd_proc_data+0x1ad>
    } else if (data & 0x80) {
  1016e2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1016e6:	84 c0                	test   %al,%al
  1016e8:	79 4b                	jns    101735 <kbd_proc_data+0xc3>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1016ea:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  1016f0:	83 e0 40             	and    $0x40,%eax
  1016f3:	85 c0                	test   %eax,%eax
  1016f5:	75 09                	jne    101700 <kbd_proc_data+0x8e>
  1016f7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1016fb:	83 e0 7f             	and    $0x7f,%eax
  1016fe:	eb 04                	jmp    101704 <kbd_proc_data+0x92>
  101700:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101704:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101707:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10170b:	0f b6 84 01 b0 f6 ff 	movzbl -0x950(%ecx,%eax,1),%eax
  101712:	ff 
  101713:	83 c8 40             	or     $0x40,%eax
  101716:	0f b6 c0             	movzbl %al,%eax
  101719:	f7 d0                	not    %eax
  10171b:	89 c2                	mov    %eax,%edx
  10171d:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  101723:	21 d0                	and    %edx,%eax
  101725:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)
        return 0;
  10172b:	b8 00 00 00 00       	mov    $0x0,%eax
  101730:	e9 ea 00 00 00       	jmp    10181f <kbd_proc_data+0x1ad>
    } else if (shift & E0ESC) {
  101735:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  10173b:	83 e0 40             	and    $0x40,%eax
  10173e:	85 c0                	test   %eax,%eax
  101740:	74 13                	je     101755 <kbd_proc_data+0xe3>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101742:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101746:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  10174c:	83 e0 bf             	and    $0xffffffbf,%eax
  10174f:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)
    }

    shift |= shiftcode[data];
  101755:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101759:	0f b6 84 01 b0 f6 ff 	movzbl -0x950(%ecx,%eax,1),%eax
  101760:	ff 
  101761:	0f b6 d0             	movzbl %al,%edx
  101764:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  10176a:	09 d0                	or     %edx,%eax
  10176c:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)
    shift ^= togglecode[data];
  101772:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101776:	0f b6 84 01 b0 f7 ff 	movzbl -0x850(%ecx,%eax,1),%eax
  10177d:	ff 
  10177e:	0f b6 d0             	movzbl %al,%edx
  101781:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  101787:	31 d0                	xor    %edx,%eax
  101789:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)

    c = charcode[shift & (CTL | SHIFT)][data];
  10178f:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  101795:	83 e0 03             	and    $0x3,%eax
  101798:	8b 94 81 34 00 00 00 	mov    0x34(%ecx,%eax,4),%edx
  10179f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1017a3:	01 d0                	add    %edx,%eax
  1017a5:	0f b6 00             	movzbl (%eax),%eax
  1017a8:	0f b6 c0             	movzbl %al,%eax
  1017ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1017ae:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  1017b4:	83 e0 08             	and    $0x8,%eax
  1017b7:	85 c0                	test   %eax,%eax
  1017b9:	74 22                	je     1017dd <kbd_proc_data+0x16b>
        if ('a' <= c && c <= 'z')
  1017bb:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1017bf:	7e 0c                	jle    1017cd <kbd_proc_data+0x15b>
  1017c1:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1017c5:	7f 06                	jg     1017cd <kbd_proc_data+0x15b>
            c += 'A' - 'a';
  1017c7:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1017cb:	eb 10                	jmp    1017dd <kbd_proc_data+0x16b>
        else if ('A' <= c && c <= 'Z')
  1017cd:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1017d1:	7e 0a                	jle    1017dd <kbd_proc_data+0x16b>
  1017d3:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1017d7:	7f 04                	jg     1017dd <kbd_proc_data+0x16b>
            c += 'a' - 'A';
  1017d9:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1017dd:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  1017e3:	f7 d0                	not    %eax
  1017e5:	83 e0 06             	and    $0x6,%eax
  1017e8:	85 c0                	test   %eax,%eax
  1017ea:	75 30                	jne    10181c <kbd_proc_data+0x1aa>
  1017ec:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1017f3:	75 27                	jne    10181c <kbd_proc_data+0x1aa>
        cprintf("Rebooting!\n");
  1017f5:	83 ec 0c             	sub    $0xc,%esp
  1017f8:	8d 81 9d 51 ff ff    	lea    -0xae63(%ecx),%eax
  1017fe:	50                   	push   %eax
  1017ff:	89 cb                	mov    %ecx,%ebx
  101801:	e8 ed ea ff ff       	call   1002f3 <cprintf>
  101806:	83 c4 10             	add    $0x10,%esp
  101809:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10180f:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101813:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101817:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10181b:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10181f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101822:	c9                   	leave  
  101823:	c3                   	ret    

00101824 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101824:	55                   	push   %ebp
  101825:	89 e5                	mov    %esp,%ebp
  101827:	83 ec 08             	sub    $0x8,%esp
  10182a:	e8 4d ea ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10182f:	05 21 d1 00 00       	add    $0xd121,%eax
    cons_intr(kbd_proc_data);
  101834:	83 ec 0c             	sub    $0xc,%esp
  101837:	8d 80 22 2d ff ff    	lea    -0xd2de(%eax),%eax
  10183d:	50                   	push   %eax
  10183e:	e8 40 fd ff ff       	call   101583 <cons_intr>
  101843:	83 c4 10             	add    $0x10,%esp
}
  101846:	90                   	nop
  101847:	c9                   	leave  
  101848:	c3                   	ret    

00101849 <kbd_init>:

static void
kbd_init(void) {
  101849:	55                   	push   %ebp
  10184a:	89 e5                	mov    %esp,%ebp
  10184c:	53                   	push   %ebx
  10184d:	83 ec 04             	sub    $0x4,%esp
  101850:	e8 2b ea ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  101855:	81 c3 fb d0 00 00    	add    $0xd0fb,%ebx
    // drain the kbd buffer
    kbd_intr();
  10185b:	e8 c4 ff ff ff       	call   101824 <kbd_intr>
    pic_enable(IRQ_KBD);
  101860:	83 ec 0c             	sub    $0xc,%esp
  101863:	6a 01                	push   $0x1
  101865:	e8 5f 01 00 00       	call   1019c9 <pic_enable>
  10186a:	83 c4 10             	add    $0x10,%esp
}
  10186d:	90                   	nop
  10186e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101871:	c9                   	leave  
  101872:	c3                   	ret    

00101873 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101873:	55                   	push   %ebp
  101874:	89 e5                	mov    %esp,%ebp
  101876:	53                   	push   %ebx
  101877:	83 ec 04             	sub    $0x4,%esp
  10187a:	e8 01 ea ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  10187f:	81 c3 d1 d0 00 00    	add    $0xd0d1,%ebx
    cga_init();
  101885:	e8 b4 f7 ff ff       	call   10103e <cga_init>
    serial_init();
  10188a:	e8 a3 f8 ff ff       	call   101132 <serial_init>
    kbd_init();
  10188f:	e8 b5 ff ff ff       	call   101849 <kbd_init>
    if (!serial_exists) {
  101894:	8b 83 b8 05 00 00    	mov    0x5b8(%ebx),%eax
  10189a:	85 c0                	test   %eax,%eax
  10189c:	75 12                	jne    1018b0 <cons_init+0x3d>
        cprintf("serial port does not exist!!\n");
  10189e:	83 ec 0c             	sub    $0xc,%esp
  1018a1:	8d 83 a9 51 ff ff    	lea    -0xae57(%ebx),%eax
  1018a7:	50                   	push   %eax
  1018a8:	e8 46 ea ff ff       	call   1002f3 <cprintf>
  1018ad:	83 c4 10             	add    $0x10,%esp
    }
}
  1018b0:	90                   	nop
  1018b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1018b4:	c9                   	leave  
  1018b5:	c3                   	ret    

001018b6 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1018b6:	55                   	push   %ebp
  1018b7:	89 e5                	mov    %esp,%ebp
  1018b9:	83 ec 08             	sub    $0x8,%esp
  1018bc:	e8 bb e9 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1018c1:	05 8f d0 00 00       	add    $0xd08f,%eax
    lpt_putc(c);
  1018c6:	ff 75 08             	pushl  0x8(%ebp)
  1018c9:	e8 e0 f9 ff ff       	call   1012ae <lpt_putc>
  1018ce:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1018d1:	83 ec 0c             	sub    $0xc,%esp
  1018d4:	ff 75 08             	pushl  0x8(%ebp)
  1018d7:	e8 13 fa ff ff       	call   1012ef <cga_putc>
  1018dc:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1018df:	83 ec 0c             	sub    $0xc,%esp
  1018e2:	ff 75 08             	pushl  0x8(%ebp)
  1018e5:	e8 58 fc ff ff       	call   101542 <serial_putc>
  1018ea:	83 c4 10             	add    $0x10,%esp
}
  1018ed:	90                   	nop
  1018ee:	c9                   	leave  
  1018ef:	c3                   	ret    

001018f0 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1018f0:	55                   	push   %ebp
  1018f1:	89 e5                	mov    %esp,%ebp
  1018f3:	53                   	push   %ebx
  1018f4:	83 ec 14             	sub    $0x14,%esp
  1018f7:	e8 84 e9 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  1018fc:	81 c3 54 d0 00 00    	add    $0xd054,%ebx
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101902:	e8 3c fd ff ff       	call   101643 <serial_intr>
    kbd_intr();
  101907:	e8 18 ff ff ff       	call   101824 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  10190c:	8b 93 d0 07 00 00    	mov    0x7d0(%ebx),%edx
  101912:	8b 83 d4 07 00 00    	mov    0x7d4(%ebx),%eax
  101918:	39 c2                	cmp    %eax,%edx
  10191a:	74 39                	je     101955 <cons_getc+0x65>
        c = cons.buf[cons.rpos ++];
  10191c:	8b 83 d0 07 00 00    	mov    0x7d0(%ebx),%eax
  101922:	8d 50 01             	lea    0x1(%eax),%edx
  101925:	89 93 d0 07 00 00    	mov    %edx,0x7d0(%ebx)
  10192b:	0f b6 84 03 d0 05 00 	movzbl 0x5d0(%ebx,%eax,1),%eax
  101932:	00 
  101933:	0f b6 c0             	movzbl %al,%eax
  101936:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101939:	8b 83 d0 07 00 00    	mov    0x7d0(%ebx),%eax
  10193f:	3d 00 02 00 00       	cmp    $0x200,%eax
  101944:	75 0a                	jne    101950 <cons_getc+0x60>
            cons.rpos = 0;
  101946:	c7 83 d0 07 00 00 00 	movl   $0x0,0x7d0(%ebx)
  10194d:	00 00 00 
        }
        return c;
  101950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101953:	eb 05                	jmp    10195a <cons_getc+0x6a>
    }
    return 0;
  101955:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10195a:	83 c4 14             	add    $0x14,%esp
  10195d:	5b                   	pop    %ebx
  10195e:	5d                   	pop    %ebp
  10195f:	c3                   	ret    

00101960 <__x86.get_pc_thunk.cx>:
  101960:	8b 0c 24             	mov    (%esp),%ecx
  101963:	c3                   	ret    

00101964 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101964:	55                   	push   %ebp
  101965:	89 e5                	mov    %esp,%ebp
  101967:	83 ec 14             	sub    $0x14,%esp
  10196a:	e8 0d e9 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10196f:	05 e1 cf 00 00       	add    $0xcfe1,%eax
  101974:	8b 55 08             	mov    0x8(%ebp),%edx
  101977:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
    irq_mask = mask;
  10197b:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10197f:	66 89 90 b0 fb ff ff 	mov    %dx,-0x450(%eax)
    if (did_init) {
  101986:	8b 80 dc 07 00 00    	mov    0x7dc(%eax),%eax
  10198c:	85 c0                	test   %eax,%eax
  10198e:	74 36                	je     1019c6 <pic_setmask+0x62>
        outb(IO_PIC1 + 1, mask);
  101990:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101994:	0f b6 c0             	movzbl %al,%eax
  101997:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  10199d:	88 45 f9             	mov    %al,-0x7(%ebp)
  1019a0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1019a4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1019a8:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1019a9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1019ad:	66 c1 e8 08          	shr    $0x8,%ax
  1019b1:	0f b6 c0             	movzbl %al,%eax
  1019b4:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1019ba:	88 45 fd             	mov    %al,-0x3(%ebp)
  1019bd:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1019c1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1019c5:	ee                   	out    %al,(%dx)
    }
}
  1019c6:	90                   	nop
  1019c7:	c9                   	leave  
  1019c8:	c3                   	ret    

001019c9 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1019c9:	55                   	push   %ebp
  1019ca:	89 e5                	mov    %esp,%ebp
  1019cc:	53                   	push   %ebx
  1019cd:	e8 aa e8 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1019d2:	05 7e cf 00 00       	add    $0xcf7e,%eax
    pic_setmask(irq_mask & ~(1 << irq));
  1019d7:	8b 55 08             	mov    0x8(%ebp),%edx
  1019da:	bb 01 00 00 00       	mov    $0x1,%ebx
  1019df:	89 d1                	mov    %edx,%ecx
  1019e1:	d3 e3                	shl    %cl,%ebx
  1019e3:	89 da                	mov    %ebx,%edx
  1019e5:	f7 d2                	not    %edx
  1019e7:	0f b7 80 b0 fb ff ff 	movzwl -0x450(%eax),%eax
  1019ee:	21 d0                	and    %edx,%eax
  1019f0:	0f b7 c0             	movzwl %ax,%eax
  1019f3:	50                   	push   %eax
  1019f4:	e8 6b ff ff ff       	call   101964 <pic_setmask>
  1019f9:	83 c4 04             	add    $0x4,%esp
}
  1019fc:	90                   	nop
  1019fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101a00:	c9                   	leave  
  101a01:	c3                   	ret    

00101a02 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101a02:	55                   	push   %ebp
  101a03:	89 e5                	mov    %esp,%ebp
  101a05:	83 ec 40             	sub    $0x40,%esp
  101a08:	e8 53 ff ff ff       	call   101960 <__x86.get_pc_thunk.cx>
  101a0d:	81 c1 43 cf 00 00    	add    $0xcf43,%ecx
    did_init = 1;
  101a13:	c7 81 dc 07 00 00 01 	movl   $0x1,0x7dc(%ecx)
  101a1a:	00 00 00 
  101a1d:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101a23:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  101a27:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101a2b:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101a2f:	ee                   	out    %al,(%dx)
  101a30:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101a36:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  101a3a:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101a3e:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101a42:	ee                   	out    %al,(%dx)
  101a43:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101a49:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  101a4d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101a51:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101a55:	ee                   	out    %al,(%dx)
  101a56:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101a5c:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101a60:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101a64:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101a68:	ee                   	out    %al,(%dx)
  101a69:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101a6f:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101a73:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101a77:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101a7b:	ee                   	out    %al,(%dx)
  101a7c:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101a82:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  101a86:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101a8a:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101a8e:	ee                   	out    %al,(%dx)
  101a8f:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101a95:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  101a99:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101a9d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101aa1:	ee                   	out    %al,(%dx)
  101aa2:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101aa8:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  101aac:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101ab0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101ab4:	ee                   	out    %al,(%dx)
  101ab5:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101abb:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101abf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101ac3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101ac7:	ee                   	out    %al,(%dx)
  101ac8:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101ace:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101ad2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101ad6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101ada:	ee                   	out    %al,(%dx)
  101adb:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101ae1:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  101ae5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101ae9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101aed:	ee                   	out    %al,(%dx)
  101aee:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101af4:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  101af8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101afc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101b00:	ee                   	out    %al,(%dx)
  101b01:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101b07:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  101b0b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101b0f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101b13:	ee                   	out    %al,(%dx)
  101b14:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101b1a:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  101b1e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101b22:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101b26:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101b27:	0f b7 81 b0 fb ff ff 	movzwl -0x450(%ecx),%eax
  101b2e:	66 83 f8 ff          	cmp    $0xffff,%ax
  101b32:	74 13                	je     101b47 <pic_init+0x145>
        pic_setmask(irq_mask);
  101b34:	0f b7 81 b0 fb ff ff 	movzwl -0x450(%ecx),%eax
  101b3b:	0f b7 c0             	movzwl %ax,%eax
  101b3e:	50                   	push   %eax
  101b3f:	e8 20 fe ff ff       	call   101964 <pic_setmask>
  101b44:	83 c4 04             	add    $0x4,%esp
    }
}
  101b47:	90                   	nop
  101b48:	c9                   	leave  
  101b49:	c3                   	ret    

00101b4a <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101b4a:	55                   	push   %ebp
  101b4b:	89 e5                	mov    %esp,%ebp
  101b4d:	e8 2a e7 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101b52:	05 fe cd 00 00       	add    $0xcdfe,%eax
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101b57:	fb                   	sti    
    sti();
}
  101b58:	90                   	nop
  101b59:	5d                   	pop    %ebp
  101b5a:	c3                   	ret    

00101b5b <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101b5b:	55                   	push   %ebp
  101b5c:	89 e5                	mov    %esp,%ebp
  101b5e:	e8 19 e7 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101b63:	05 ed cd 00 00       	add    $0xcded,%eax
}

static inline void
cli(void) {
    asm volatile ("cli");
  101b68:	fa                   	cli    
    cli();
}
  101b69:	90                   	nop
  101b6a:	5d                   	pop    %ebp
  101b6b:	c3                   	ret    

00101b6c <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101b6c:	55                   	push   %ebp
  101b6d:	89 e5                	mov    %esp,%ebp
  101b6f:	53                   	push   %ebx
  101b70:	83 ec 04             	sub    $0x4,%esp
  101b73:	e8 04 e7 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101b78:	05 d8 cd 00 00       	add    $0xcdd8,%eax
    cprintf("%d ticks\n",TICK_NUM);
  101b7d:	83 ec 08             	sub    $0x8,%esp
  101b80:	6a 64                	push   $0x64
  101b82:	8d 90 c7 51 ff ff    	lea    -0xae39(%eax),%edx
  101b88:	52                   	push   %edx
  101b89:	89 c3                	mov    %eax,%ebx
  101b8b:	e8 63 e7 ff ff       	call   1002f3 <cprintf>
  101b90:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101b93:	90                   	nop
  101b94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101b97:	c9                   	leave  
  101b98:	c3                   	ret    

00101b99 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101b99:	55                   	push   %ebp
  101b9a:	89 e5                	mov    %esp,%ebp
  101b9c:	e8 db e6 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101ba1:	05 af cd 00 00       	add    $0xcdaf,%eax
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  101ba6:	90                   	nop
  101ba7:	5d                   	pop    %ebp
  101ba8:	c3                   	ret    

00101ba9 <trapname>:

static const char *
trapname(int trapno) {
  101ba9:	55                   	push   %ebp
  101baa:	89 e5                	mov    %esp,%ebp
  101bac:	e8 cb e6 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101bb1:	05 9f cd 00 00       	add    $0xcd9f,%eax
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  101bb9:	83 fa 13             	cmp    $0x13,%edx
  101bbc:	77 0c                	ja     101bca <trapname+0x21>
        return excnames[trapno];
  101bbe:	8b 55 08             	mov    0x8(%ebp),%edx
  101bc1:	8b 84 90 f0 00 00 00 	mov    0xf0(%eax,%edx,4),%eax
  101bc8:	eb 1a                	jmp    101be4 <trapname+0x3b>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101bca:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101bce:	7e 0e                	jle    101bde <trapname+0x35>
  101bd0:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101bd4:	7f 08                	jg     101bde <trapname+0x35>
        return "Hardware Interrupt";
  101bd6:	8d 80 d1 51 ff ff    	lea    -0xae2f(%eax),%eax
  101bdc:	eb 06                	jmp    101be4 <trapname+0x3b>
    }
    return "(unknown trap)";
  101bde:	8d 80 e4 51 ff ff    	lea    -0xae1c(%eax),%eax
}
  101be4:	5d                   	pop    %ebp
  101be5:	c3                   	ret    

00101be6 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101be6:	55                   	push   %ebp
  101be7:	89 e5                	mov    %esp,%ebp
  101be9:	e8 8e e6 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101bee:	05 62 cd 00 00       	add    $0xcd62,%eax
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bfa:	66 83 f8 08          	cmp    $0x8,%ax
  101bfe:	0f 94 c0             	sete   %al
  101c01:	0f b6 c0             	movzbl %al,%eax
}
  101c04:	5d                   	pop    %ebp
  101c05:	c3                   	ret    

00101c06 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101c06:	55                   	push   %ebp
  101c07:	89 e5                	mov    %esp,%ebp
  101c09:	53                   	push   %ebx
  101c0a:	83 ec 14             	sub    $0x14,%esp
  101c0d:	e8 6e e6 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  101c12:	81 c3 3e cd 00 00    	add    $0xcd3e,%ebx
    cprintf("trapframe at %p\n", tf);
  101c18:	83 ec 08             	sub    $0x8,%esp
  101c1b:	ff 75 08             	pushl  0x8(%ebp)
  101c1e:	8d 83 25 52 ff ff    	lea    -0xaddb(%ebx),%eax
  101c24:	50                   	push   %eax
  101c25:	e8 c9 e6 ff ff       	call   1002f3 <cprintf>
  101c2a:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c30:	83 ec 0c             	sub    $0xc,%esp
  101c33:	50                   	push   %eax
  101c34:	e8 d3 01 00 00       	call   101e0c <print_regs>
  101c39:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101c43:	0f b7 c0             	movzwl %ax,%eax
  101c46:	83 ec 08             	sub    $0x8,%esp
  101c49:	50                   	push   %eax
  101c4a:	8d 83 36 52 ff ff    	lea    -0xadca(%ebx),%eax
  101c50:	50                   	push   %eax
  101c51:	e8 9d e6 ff ff       	call   1002f3 <cprintf>
  101c56:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101c59:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101c60:	0f b7 c0             	movzwl %ax,%eax
  101c63:	83 ec 08             	sub    $0x8,%esp
  101c66:	50                   	push   %eax
  101c67:	8d 83 49 52 ff ff    	lea    -0xadb7(%ebx),%eax
  101c6d:	50                   	push   %eax
  101c6e:	e8 80 e6 ff ff       	call   1002f3 <cprintf>
  101c73:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101c76:	8b 45 08             	mov    0x8(%ebp),%eax
  101c79:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101c7d:	0f b7 c0             	movzwl %ax,%eax
  101c80:	83 ec 08             	sub    $0x8,%esp
  101c83:	50                   	push   %eax
  101c84:	8d 83 5c 52 ff ff    	lea    -0xada4(%ebx),%eax
  101c8a:	50                   	push   %eax
  101c8b:	e8 63 e6 ff ff       	call   1002f3 <cprintf>
  101c90:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101c93:	8b 45 08             	mov    0x8(%ebp),%eax
  101c96:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c9a:	0f b7 c0             	movzwl %ax,%eax
  101c9d:	83 ec 08             	sub    $0x8,%esp
  101ca0:	50                   	push   %eax
  101ca1:	8d 83 6f 52 ff ff    	lea    -0xad91(%ebx),%eax
  101ca7:	50                   	push   %eax
  101ca8:	e8 46 e6 ff ff       	call   1002f3 <cprintf>
  101cad:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb3:	8b 40 30             	mov    0x30(%eax),%eax
  101cb6:	83 ec 0c             	sub    $0xc,%esp
  101cb9:	50                   	push   %eax
  101cba:	e8 ea fe ff ff       	call   101ba9 <trapname>
  101cbf:	83 c4 10             	add    $0x10,%esp
  101cc2:	89 c2                	mov    %eax,%edx
  101cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc7:	8b 40 30             	mov    0x30(%eax),%eax
  101cca:	83 ec 04             	sub    $0x4,%esp
  101ccd:	52                   	push   %edx
  101cce:	50                   	push   %eax
  101ccf:	8d 83 82 52 ff ff    	lea    -0xad7e(%ebx),%eax
  101cd5:	50                   	push   %eax
  101cd6:	e8 18 e6 ff ff       	call   1002f3 <cprintf>
  101cdb:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101cde:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce1:	8b 40 34             	mov    0x34(%eax),%eax
  101ce4:	83 ec 08             	sub    $0x8,%esp
  101ce7:	50                   	push   %eax
  101ce8:	8d 83 94 52 ff ff    	lea    -0xad6c(%ebx),%eax
  101cee:	50                   	push   %eax
  101cef:	e8 ff e5 ff ff       	call   1002f3 <cprintf>
  101cf4:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfa:	8b 40 38             	mov    0x38(%eax),%eax
  101cfd:	83 ec 08             	sub    $0x8,%esp
  101d00:	50                   	push   %eax
  101d01:	8d 83 a3 52 ff ff    	lea    -0xad5d(%ebx),%eax
  101d07:	50                   	push   %eax
  101d08:	e8 e6 e5 ff ff       	call   1002f3 <cprintf>
  101d0d:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101d10:	8b 45 08             	mov    0x8(%ebp),%eax
  101d13:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d17:	0f b7 c0             	movzwl %ax,%eax
  101d1a:	83 ec 08             	sub    $0x8,%esp
  101d1d:	50                   	push   %eax
  101d1e:	8d 83 b2 52 ff ff    	lea    -0xad4e(%ebx),%eax
  101d24:	50                   	push   %eax
  101d25:	e8 c9 e5 ff ff       	call   1002f3 <cprintf>
  101d2a:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d30:	8b 40 40             	mov    0x40(%eax),%eax
  101d33:	83 ec 08             	sub    $0x8,%esp
  101d36:	50                   	push   %eax
  101d37:	8d 83 c5 52 ff ff    	lea    -0xad3b(%ebx),%eax
  101d3d:	50                   	push   %eax
  101d3e:	e8 b0 e5 ff ff       	call   1002f3 <cprintf>
  101d43:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101d46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101d4d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101d54:	eb 41                	jmp    101d97 <print_trapframe+0x191>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101d56:	8b 45 08             	mov    0x8(%ebp),%eax
  101d59:	8b 50 40             	mov    0x40(%eax),%edx
  101d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101d5f:	21 d0                	and    %edx,%eax
  101d61:	85 c0                	test   %eax,%eax
  101d63:	74 2b                	je     101d90 <print_trapframe+0x18a>
  101d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d68:	8b 84 83 70 00 00 00 	mov    0x70(%ebx,%eax,4),%eax
  101d6f:	85 c0                	test   %eax,%eax
  101d71:	74 1d                	je     101d90 <print_trapframe+0x18a>
            cprintf("%s,", IA32flags[i]);
  101d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d76:	8b 84 83 70 00 00 00 	mov    0x70(%ebx,%eax,4),%eax
  101d7d:	83 ec 08             	sub    $0x8,%esp
  101d80:	50                   	push   %eax
  101d81:	8d 83 d4 52 ff ff    	lea    -0xad2c(%ebx),%eax
  101d87:	50                   	push   %eax
  101d88:	e8 66 e5 ff ff       	call   1002f3 <cprintf>
  101d8d:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101d90:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101d94:	d1 65 f0             	shll   -0x10(%ebp)
  101d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d9a:	83 f8 17             	cmp    $0x17,%eax
  101d9d:	76 b7                	jbe    101d56 <print_trapframe+0x150>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101da2:	8b 40 40             	mov    0x40(%eax),%eax
  101da5:	c1 e8 0c             	shr    $0xc,%eax
  101da8:	83 e0 03             	and    $0x3,%eax
  101dab:	83 ec 08             	sub    $0x8,%esp
  101dae:	50                   	push   %eax
  101daf:	8d 83 d8 52 ff ff    	lea    -0xad28(%ebx),%eax
  101db5:	50                   	push   %eax
  101db6:	e8 38 e5 ff ff       	call   1002f3 <cprintf>
  101dbb:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101dbe:	83 ec 0c             	sub    $0xc,%esp
  101dc1:	ff 75 08             	pushl  0x8(%ebp)
  101dc4:	e8 1d fe ff ff       	call   101be6 <trap_in_kernel>
  101dc9:	83 c4 10             	add    $0x10,%esp
  101dcc:	85 c0                	test   %eax,%eax
  101dce:	75 36                	jne    101e06 <print_trapframe+0x200>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd3:	8b 40 44             	mov    0x44(%eax),%eax
  101dd6:	83 ec 08             	sub    $0x8,%esp
  101dd9:	50                   	push   %eax
  101dda:	8d 83 e1 52 ff ff    	lea    -0xad1f(%ebx),%eax
  101de0:	50                   	push   %eax
  101de1:	e8 0d e5 ff ff       	call   1002f3 <cprintf>
  101de6:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101de9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dec:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101df0:	0f b7 c0             	movzwl %ax,%eax
  101df3:	83 ec 08             	sub    $0x8,%esp
  101df6:	50                   	push   %eax
  101df7:	8d 83 f0 52 ff ff    	lea    -0xad10(%ebx),%eax
  101dfd:	50                   	push   %eax
  101dfe:	e8 f0 e4 ff ff       	call   1002f3 <cprintf>
  101e03:	83 c4 10             	add    $0x10,%esp
    }
}
  101e06:	90                   	nop
  101e07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101e0a:	c9                   	leave  
  101e0b:	c3                   	ret    

00101e0c <print_regs>:

void
print_regs(struct pushregs *regs) {
  101e0c:	55                   	push   %ebp
  101e0d:	89 e5                	mov    %esp,%ebp
  101e0f:	53                   	push   %ebx
  101e10:	83 ec 04             	sub    $0x4,%esp
  101e13:	e8 68 e4 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  101e18:	81 c3 38 cb 00 00    	add    $0xcb38,%ebx
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e21:	8b 00                	mov    (%eax),%eax
  101e23:	83 ec 08             	sub    $0x8,%esp
  101e26:	50                   	push   %eax
  101e27:	8d 83 03 53 ff ff    	lea    -0xacfd(%ebx),%eax
  101e2d:	50                   	push   %eax
  101e2e:	e8 c0 e4 ff ff       	call   1002f3 <cprintf>
  101e33:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101e36:	8b 45 08             	mov    0x8(%ebp),%eax
  101e39:	8b 40 04             	mov    0x4(%eax),%eax
  101e3c:	83 ec 08             	sub    $0x8,%esp
  101e3f:	50                   	push   %eax
  101e40:	8d 83 12 53 ff ff    	lea    -0xacee(%ebx),%eax
  101e46:	50                   	push   %eax
  101e47:	e8 a7 e4 ff ff       	call   1002f3 <cprintf>
  101e4c:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e52:	8b 40 08             	mov    0x8(%eax),%eax
  101e55:	83 ec 08             	sub    $0x8,%esp
  101e58:	50                   	push   %eax
  101e59:	8d 83 21 53 ff ff    	lea    -0xacdf(%ebx),%eax
  101e5f:	50                   	push   %eax
  101e60:	e8 8e e4 ff ff       	call   1002f3 <cprintf>
  101e65:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101e68:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6b:	8b 40 0c             	mov    0xc(%eax),%eax
  101e6e:	83 ec 08             	sub    $0x8,%esp
  101e71:	50                   	push   %eax
  101e72:	8d 83 30 53 ff ff    	lea    -0xacd0(%ebx),%eax
  101e78:	50                   	push   %eax
  101e79:	e8 75 e4 ff ff       	call   1002f3 <cprintf>
  101e7e:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101e81:	8b 45 08             	mov    0x8(%ebp),%eax
  101e84:	8b 40 10             	mov    0x10(%eax),%eax
  101e87:	83 ec 08             	sub    $0x8,%esp
  101e8a:	50                   	push   %eax
  101e8b:	8d 83 3f 53 ff ff    	lea    -0xacc1(%ebx),%eax
  101e91:	50                   	push   %eax
  101e92:	e8 5c e4 ff ff       	call   1002f3 <cprintf>
  101e97:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9d:	8b 40 14             	mov    0x14(%eax),%eax
  101ea0:	83 ec 08             	sub    $0x8,%esp
  101ea3:	50                   	push   %eax
  101ea4:	8d 83 4e 53 ff ff    	lea    -0xacb2(%ebx),%eax
  101eaa:	50                   	push   %eax
  101eab:	e8 43 e4 ff ff       	call   1002f3 <cprintf>
  101eb0:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb6:	8b 40 18             	mov    0x18(%eax),%eax
  101eb9:	83 ec 08             	sub    $0x8,%esp
  101ebc:	50                   	push   %eax
  101ebd:	8d 83 5d 53 ff ff    	lea    -0xaca3(%ebx),%eax
  101ec3:	50                   	push   %eax
  101ec4:	e8 2a e4 ff ff       	call   1002f3 <cprintf>
  101ec9:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  101ecf:	8b 40 1c             	mov    0x1c(%eax),%eax
  101ed2:	83 ec 08             	sub    $0x8,%esp
  101ed5:	50                   	push   %eax
  101ed6:	8d 83 6c 53 ff ff    	lea    -0xac94(%ebx),%eax
  101edc:	50                   	push   %eax
  101edd:	e8 11 e4 ff ff       	call   1002f3 <cprintf>
  101ee2:	83 c4 10             	add    $0x10,%esp
}
  101ee5:	90                   	nop
  101ee6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101ee9:	c9                   	leave  
  101eea:	c3                   	ret    

00101eeb <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101eeb:	55                   	push   %ebp
  101eec:	89 e5                	mov    %esp,%ebp
  101eee:	53                   	push   %ebx
  101eef:	83 ec 14             	sub    $0x14,%esp
  101ef2:	e8 89 e3 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  101ef7:	81 c3 59 ca 00 00    	add    $0xca59,%ebx
    char c;

    switch (tf->tf_trapno) {
  101efd:	8b 45 08             	mov    0x8(%ebp),%eax
  101f00:	8b 40 30             	mov    0x30(%eax),%eax
  101f03:	83 f8 2f             	cmp    $0x2f,%eax
  101f06:	77 1e                	ja     101f26 <trap_dispatch+0x3b>
  101f08:	83 f8 2e             	cmp    $0x2e,%eax
  101f0b:	0f 83 c0 00 00 00    	jae    101fd1 <trap_dispatch+0xe6>
  101f11:	83 f8 21             	cmp    $0x21,%eax
  101f14:	74 40                	je     101f56 <trap_dispatch+0x6b>
  101f16:	83 f8 24             	cmp    $0x24,%eax
  101f19:	74 15                	je     101f30 <trap_dispatch+0x45>
  101f1b:	83 f8 20             	cmp    $0x20,%eax
  101f1e:	0f 84 b0 00 00 00    	je     101fd4 <trap_dispatch+0xe9>
  101f24:	eb 71                	jmp    101f97 <trap_dispatch+0xac>
  101f26:	83 e8 78             	sub    $0x78,%eax
  101f29:	83 f8 01             	cmp    $0x1,%eax
  101f2c:	77 69                	ja     101f97 <trap_dispatch+0xac>
  101f2e:	eb 4c                	jmp    101f7c <trap_dispatch+0x91>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101f30:	e8 bb f9 ff ff       	call   1018f0 <cons_getc>
  101f35:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101f38:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101f3c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101f40:	83 ec 04             	sub    $0x4,%esp
  101f43:	52                   	push   %edx
  101f44:	50                   	push   %eax
  101f45:	8d 83 7b 53 ff ff    	lea    -0xac85(%ebx),%eax
  101f4b:	50                   	push   %eax
  101f4c:	e8 a2 e3 ff ff       	call   1002f3 <cprintf>
  101f51:	83 c4 10             	add    $0x10,%esp
        break;
  101f54:	eb 7f                	jmp    101fd5 <trap_dispatch+0xea>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101f56:	e8 95 f9 ff ff       	call   1018f0 <cons_getc>
  101f5b:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101f5e:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101f62:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101f66:	83 ec 04             	sub    $0x4,%esp
  101f69:	52                   	push   %edx
  101f6a:	50                   	push   %eax
  101f6b:	8d 83 8d 53 ff ff    	lea    -0xac73(%ebx),%eax
  101f71:	50                   	push   %eax
  101f72:	e8 7c e3 ff ff       	call   1002f3 <cprintf>
  101f77:	83 c4 10             	add    $0x10,%esp
        break;
  101f7a:	eb 59                	jmp    101fd5 <trap_dispatch+0xea>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101f7c:	83 ec 04             	sub    $0x4,%esp
  101f7f:	8d 83 9c 53 ff ff    	lea    -0xac64(%ebx),%eax
  101f85:	50                   	push   %eax
  101f86:	68 a2 00 00 00       	push   $0xa2
  101f8b:	8d 83 ac 53 ff ff    	lea    -0xac54(%ebx),%eax
  101f91:	50                   	push   %eax
  101f92:	e8 0c e5 ff ff       	call   1004a3 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101f97:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f9e:	0f b7 c0             	movzwl %ax,%eax
  101fa1:	83 e0 03             	and    $0x3,%eax
  101fa4:	85 c0                	test   %eax,%eax
  101fa6:	75 2d                	jne    101fd5 <trap_dispatch+0xea>
            print_trapframe(tf);
  101fa8:	83 ec 0c             	sub    $0xc,%esp
  101fab:	ff 75 08             	pushl  0x8(%ebp)
  101fae:	e8 53 fc ff ff       	call   101c06 <print_trapframe>
  101fb3:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101fb6:	83 ec 04             	sub    $0x4,%esp
  101fb9:	8d 83 bd 53 ff ff    	lea    -0xac43(%ebx),%eax
  101fbf:	50                   	push   %eax
  101fc0:	68 ac 00 00 00       	push   $0xac
  101fc5:	8d 83 ac 53 ff ff    	lea    -0xac54(%ebx),%eax
  101fcb:	50                   	push   %eax
  101fcc:	e8 d2 e4 ff ff       	call   1004a3 <__panic>
        break;
  101fd1:	90                   	nop
  101fd2:	eb 01                	jmp    101fd5 <trap_dispatch+0xea>
        break;
  101fd4:	90                   	nop
        }
    }
}
  101fd5:	90                   	nop
  101fd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101fd9:	c9                   	leave  
  101fda:	c3                   	ret    

00101fdb <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101fdb:	55                   	push   %ebp
  101fdc:	89 e5                	mov    %esp,%ebp
  101fde:	83 ec 08             	sub    $0x8,%esp
  101fe1:	e8 96 e2 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101fe6:	05 6a c9 00 00       	add    $0xc96a,%eax
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101feb:	83 ec 0c             	sub    $0xc,%esp
  101fee:	ff 75 08             	pushl  0x8(%ebp)
  101ff1:	e8 f5 fe ff ff       	call   101eeb <trap_dispatch>
  101ff6:	83 c4 10             	add    $0x10,%esp
}
  101ff9:	90                   	nop
  101ffa:	c9                   	leave  
  101ffb:	c3                   	ret    

00101ffc <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $0
  101ffe:	6a 00                	push   $0x0
  jmp __alltraps
  102000:	e9 69 0a 00 00       	jmp    102a6e <__alltraps>

00102005 <vector1>:
.globl vector1
vector1:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $1
  102007:	6a 01                	push   $0x1
  jmp __alltraps
  102009:	e9 60 0a 00 00       	jmp    102a6e <__alltraps>

0010200e <vector2>:
.globl vector2
vector2:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $2
  102010:	6a 02                	push   $0x2
  jmp __alltraps
  102012:	e9 57 0a 00 00       	jmp    102a6e <__alltraps>

00102017 <vector3>:
.globl vector3
vector3:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $3
  102019:	6a 03                	push   $0x3
  jmp __alltraps
  10201b:	e9 4e 0a 00 00       	jmp    102a6e <__alltraps>

00102020 <vector4>:
.globl vector4
vector4:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $4
  102022:	6a 04                	push   $0x4
  jmp __alltraps
  102024:	e9 45 0a 00 00       	jmp    102a6e <__alltraps>

00102029 <vector5>:
.globl vector5
vector5:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $5
  10202b:	6a 05                	push   $0x5
  jmp __alltraps
  10202d:	e9 3c 0a 00 00       	jmp    102a6e <__alltraps>

00102032 <vector6>:
.globl vector6
vector6:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $6
  102034:	6a 06                	push   $0x6
  jmp __alltraps
  102036:	e9 33 0a 00 00       	jmp    102a6e <__alltraps>

0010203b <vector7>:
.globl vector7
vector7:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $7
  10203d:	6a 07                	push   $0x7
  jmp __alltraps
  10203f:	e9 2a 0a 00 00       	jmp    102a6e <__alltraps>

00102044 <vector8>:
.globl vector8
vector8:
  pushl $8
  102044:	6a 08                	push   $0x8
  jmp __alltraps
  102046:	e9 23 0a 00 00       	jmp    102a6e <__alltraps>

0010204b <vector9>:
.globl vector9
vector9:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $9
  10204d:	6a 09                	push   $0x9
  jmp __alltraps
  10204f:	e9 1a 0a 00 00       	jmp    102a6e <__alltraps>

00102054 <vector10>:
.globl vector10
vector10:
  pushl $10
  102054:	6a 0a                	push   $0xa
  jmp __alltraps
  102056:	e9 13 0a 00 00       	jmp    102a6e <__alltraps>

0010205b <vector11>:
.globl vector11
vector11:
  pushl $11
  10205b:	6a 0b                	push   $0xb
  jmp __alltraps
  10205d:	e9 0c 0a 00 00       	jmp    102a6e <__alltraps>

00102062 <vector12>:
.globl vector12
vector12:
  pushl $12
  102062:	6a 0c                	push   $0xc
  jmp __alltraps
  102064:	e9 05 0a 00 00       	jmp    102a6e <__alltraps>

00102069 <vector13>:
.globl vector13
vector13:
  pushl $13
  102069:	6a 0d                	push   $0xd
  jmp __alltraps
  10206b:	e9 fe 09 00 00       	jmp    102a6e <__alltraps>

00102070 <vector14>:
.globl vector14
vector14:
  pushl $14
  102070:	6a 0e                	push   $0xe
  jmp __alltraps
  102072:	e9 f7 09 00 00       	jmp    102a6e <__alltraps>

00102077 <vector15>:
.globl vector15
vector15:
  pushl $0
  102077:	6a 00                	push   $0x0
  pushl $15
  102079:	6a 0f                	push   $0xf
  jmp __alltraps
  10207b:	e9 ee 09 00 00       	jmp    102a6e <__alltraps>

00102080 <vector16>:
.globl vector16
vector16:
  pushl $0
  102080:	6a 00                	push   $0x0
  pushl $16
  102082:	6a 10                	push   $0x10
  jmp __alltraps
  102084:	e9 e5 09 00 00       	jmp    102a6e <__alltraps>

00102089 <vector17>:
.globl vector17
vector17:
  pushl $17
  102089:	6a 11                	push   $0x11
  jmp __alltraps
  10208b:	e9 de 09 00 00       	jmp    102a6e <__alltraps>

00102090 <vector18>:
.globl vector18
vector18:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $18
  102092:	6a 12                	push   $0x12
  jmp __alltraps
  102094:	e9 d5 09 00 00       	jmp    102a6e <__alltraps>

00102099 <vector19>:
.globl vector19
vector19:
  pushl $0
  102099:	6a 00                	push   $0x0
  pushl $19
  10209b:	6a 13                	push   $0x13
  jmp __alltraps
  10209d:	e9 cc 09 00 00       	jmp    102a6e <__alltraps>

001020a2 <vector20>:
.globl vector20
vector20:
  pushl $0
  1020a2:	6a 00                	push   $0x0
  pushl $20
  1020a4:	6a 14                	push   $0x14
  jmp __alltraps
  1020a6:	e9 c3 09 00 00       	jmp    102a6e <__alltraps>

001020ab <vector21>:
.globl vector21
vector21:
  pushl $0
  1020ab:	6a 00                	push   $0x0
  pushl $21
  1020ad:	6a 15                	push   $0x15
  jmp __alltraps
  1020af:	e9 ba 09 00 00       	jmp    102a6e <__alltraps>

001020b4 <vector22>:
.globl vector22
vector22:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $22
  1020b6:	6a 16                	push   $0x16
  jmp __alltraps
  1020b8:	e9 b1 09 00 00       	jmp    102a6e <__alltraps>

001020bd <vector23>:
.globl vector23
vector23:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $23
  1020bf:	6a 17                	push   $0x17
  jmp __alltraps
  1020c1:	e9 a8 09 00 00       	jmp    102a6e <__alltraps>

001020c6 <vector24>:
.globl vector24
vector24:
  pushl $0
  1020c6:	6a 00                	push   $0x0
  pushl $24
  1020c8:	6a 18                	push   $0x18
  jmp __alltraps
  1020ca:	e9 9f 09 00 00       	jmp    102a6e <__alltraps>

001020cf <vector25>:
.globl vector25
vector25:
  pushl $0
  1020cf:	6a 00                	push   $0x0
  pushl $25
  1020d1:	6a 19                	push   $0x19
  jmp __alltraps
  1020d3:	e9 96 09 00 00       	jmp    102a6e <__alltraps>

001020d8 <vector26>:
.globl vector26
vector26:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $26
  1020da:	6a 1a                	push   $0x1a
  jmp __alltraps
  1020dc:	e9 8d 09 00 00       	jmp    102a6e <__alltraps>

001020e1 <vector27>:
.globl vector27
vector27:
  pushl $0
  1020e1:	6a 00                	push   $0x0
  pushl $27
  1020e3:	6a 1b                	push   $0x1b
  jmp __alltraps
  1020e5:	e9 84 09 00 00       	jmp    102a6e <__alltraps>

001020ea <vector28>:
.globl vector28
vector28:
  pushl $0
  1020ea:	6a 00                	push   $0x0
  pushl $28
  1020ec:	6a 1c                	push   $0x1c
  jmp __alltraps
  1020ee:	e9 7b 09 00 00       	jmp    102a6e <__alltraps>

001020f3 <vector29>:
.globl vector29
vector29:
  pushl $0
  1020f3:	6a 00                	push   $0x0
  pushl $29
  1020f5:	6a 1d                	push   $0x1d
  jmp __alltraps
  1020f7:	e9 72 09 00 00       	jmp    102a6e <__alltraps>

001020fc <vector30>:
.globl vector30
vector30:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $30
  1020fe:	6a 1e                	push   $0x1e
  jmp __alltraps
  102100:	e9 69 09 00 00       	jmp    102a6e <__alltraps>

00102105 <vector31>:
.globl vector31
vector31:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $31
  102107:	6a 1f                	push   $0x1f
  jmp __alltraps
  102109:	e9 60 09 00 00       	jmp    102a6e <__alltraps>

0010210e <vector32>:
.globl vector32
vector32:
  pushl $0
  10210e:	6a 00                	push   $0x0
  pushl $32
  102110:	6a 20                	push   $0x20
  jmp __alltraps
  102112:	e9 57 09 00 00       	jmp    102a6e <__alltraps>

00102117 <vector33>:
.globl vector33
vector33:
  pushl $0
  102117:	6a 00                	push   $0x0
  pushl $33
  102119:	6a 21                	push   $0x21
  jmp __alltraps
  10211b:	e9 4e 09 00 00       	jmp    102a6e <__alltraps>

00102120 <vector34>:
.globl vector34
vector34:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $34
  102122:	6a 22                	push   $0x22
  jmp __alltraps
  102124:	e9 45 09 00 00       	jmp    102a6e <__alltraps>

00102129 <vector35>:
.globl vector35
vector35:
  pushl $0
  102129:	6a 00                	push   $0x0
  pushl $35
  10212b:	6a 23                	push   $0x23
  jmp __alltraps
  10212d:	e9 3c 09 00 00       	jmp    102a6e <__alltraps>

00102132 <vector36>:
.globl vector36
vector36:
  pushl $0
  102132:	6a 00                	push   $0x0
  pushl $36
  102134:	6a 24                	push   $0x24
  jmp __alltraps
  102136:	e9 33 09 00 00       	jmp    102a6e <__alltraps>

0010213b <vector37>:
.globl vector37
vector37:
  pushl $0
  10213b:	6a 00                	push   $0x0
  pushl $37
  10213d:	6a 25                	push   $0x25
  jmp __alltraps
  10213f:	e9 2a 09 00 00       	jmp    102a6e <__alltraps>

00102144 <vector38>:
.globl vector38
vector38:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $38
  102146:	6a 26                	push   $0x26
  jmp __alltraps
  102148:	e9 21 09 00 00       	jmp    102a6e <__alltraps>

0010214d <vector39>:
.globl vector39
vector39:
  pushl $0
  10214d:	6a 00                	push   $0x0
  pushl $39
  10214f:	6a 27                	push   $0x27
  jmp __alltraps
  102151:	e9 18 09 00 00       	jmp    102a6e <__alltraps>

00102156 <vector40>:
.globl vector40
vector40:
  pushl $0
  102156:	6a 00                	push   $0x0
  pushl $40
  102158:	6a 28                	push   $0x28
  jmp __alltraps
  10215a:	e9 0f 09 00 00       	jmp    102a6e <__alltraps>

0010215f <vector41>:
.globl vector41
vector41:
  pushl $0
  10215f:	6a 00                	push   $0x0
  pushl $41
  102161:	6a 29                	push   $0x29
  jmp __alltraps
  102163:	e9 06 09 00 00       	jmp    102a6e <__alltraps>

00102168 <vector42>:
.globl vector42
vector42:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $42
  10216a:	6a 2a                	push   $0x2a
  jmp __alltraps
  10216c:	e9 fd 08 00 00       	jmp    102a6e <__alltraps>

00102171 <vector43>:
.globl vector43
vector43:
  pushl $0
  102171:	6a 00                	push   $0x0
  pushl $43
  102173:	6a 2b                	push   $0x2b
  jmp __alltraps
  102175:	e9 f4 08 00 00       	jmp    102a6e <__alltraps>

0010217a <vector44>:
.globl vector44
vector44:
  pushl $0
  10217a:	6a 00                	push   $0x0
  pushl $44
  10217c:	6a 2c                	push   $0x2c
  jmp __alltraps
  10217e:	e9 eb 08 00 00       	jmp    102a6e <__alltraps>

00102183 <vector45>:
.globl vector45
vector45:
  pushl $0
  102183:	6a 00                	push   $0x0
  pushl $45
  102185:	6a 2d                	push   $0x2d
  jmp __alltraps
  102187:	e9 e2 08 00 00       	jmp    102a6e <__alltraps>

0010218c <vector46>:
.globl vector46
vector46:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $46
  10218e:	6a 2e                	push   $0x2e
  jmp __alltraps
  102190:	e9 d9 08 00 00       	jmp    102a6e <__alltraps>

00102195 <vector47>:
.globl vector47
vector47:
  pushl $0
  102195:	6a 00                	push   $0x0
  pushl $47
  102197:	6a 2f                	push   $0x2f
  jmp __alltraps
  102199:	e9 d0 08 00 00       	jmp    102a6e <__alltraps>

0010219e <vector48>:
.globl vector48
vector48:
  pushl $0
  10219e:	6a 00                	push   $0x0
  pushl $48
  1021a0:	6a 30                	push   $0x30
  jmp __alltraps
  1021a2:	e9 c7 08 00 00       	jmp    102a6e <__alltraps>

001021a7 <vector49>:
.globl vector49
vector49:
  pushl $0
  1021a7:	6a 00                	push   $0x0
  pushl $49
  1021a9:	6a 31                	push   $0x31
  jmp __alltraps
  1021ab:	e9 be 08 00 00       	jmp    102a6e <__alltraps>

001021b0 <vector50>:
.globl vector50
vector50:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $50
  1021b2:	6a 32                	push   $0x32
  jmp __alltraps
  1021b4:	e9 b5 08 00 00       	jmp    102a6e <__alltraps>

001021b9 <vector51>:
.globl vector51
vector51:
  pushl $0
  1021b9:	6a 00                	push   $0x0
  pushl $51
  1021bb:	6a 33                	push   $0x33
  jmp __alltraps
  1021bd:	e9 ac 08 00 00       	jmp    102a6e <__alltraps>

001021c2 <vector52>:
.globl vector52
vector52:
  pushl $0
  1021c2:	6a 00                	push   $0x0
  pushl $52
  1021c4:	6a 34                	push   $0x34
  jmp __alltraps
  1021c6:	e9 a3 08 00 00       	jmp    102a6e <__alltraps>

001021cb <vector53>:
.globl vector53
vector53:
  pushl $0
  1021cb:	6a 00                	push   $0x0
  pushl $53
  1021cd:	6a 35                	push   $0x35
  jmp __alltraps
  1021cf:	e9 9a 08 00 00       	jmp    102a6e <__alltraps>

001021d4 <vector54>:
.globl vector54
vector54:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $54
  1021d6:	6a 36                	push   $0x36
  jmp __alltraps
  1021d8:	e9 91 08 00 00       	jmp    102a6e <__alltraps>

001021dd <vector55>:
.globl vector55
vector55:
  pushl $0
  1021dd:	6a 00                	push   $0x0
  pushl $55
  1021df:	6a 37                	push   $0x37
  jmp __alltraps
  1021e1:	e9 88 08 00 00       	jmp    102a6e <__alltraps>

001021e6 <vector56>:
.globl vector56
vector56:
  pushl $0
  1021e6:	6a 00                	push   $0x0
  pushl $56
  1021e8:	6a 38                	push   $0x38
  jmp __alltraps
  1021ea:	e9 7f 08 00 00       	jmp    102a6e <__alltraps>

001021ef <vector57>:
.globl vector57
vector57:
  pushl $0
  1021ef:	6a 00                	push   $0x0
  pushl $57
  1021f1:	6a 39                	push   $0x39
  jmp __alltraps
  1021f3:	e9 76 08 00 00       	jmp    102a6e <__alltraps>

001021f8 <vector58>:
.globl vector58
vector58:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $58
  1021fa:	6a 3a                	push   $0x3a
  jmp __alltraps
  1021fc:	e9 6d 08 00 00       	jmp    102a6e <__alltraps>

00102201 <vector59>:
.globl vector59
vector59:
  pushl $0
  102201:	6a 00                	push   $0x0
  pushl $59
  102203:	6a 3b                	push   $0x3b
  jmp __alltraps
  102205:	e9 64 08 00 00       	jmp    102a6e <__alltraps>

0010220a <vector60>:
.globl vector60
vector60:
  pushl $0
  10220a:	6a 00                	push   $0x0
  pushl $60
  10220c:	6a 3c                	push   $0x3c
  jmp __alltraps
  10220e:	e9 5b 08 00 00       	jmp    102a6e <__alltraps>

00102213 <vector61>:
.globl vector61
vector61:
  pushl $0
  102213:	6a 00                	push   $0x0
  pushl $61
  102215:	6a 3d                	push   $0x3d
  jmp __alltraps
  102217:	e9 52 08 00 00       	jmp    102a6e <__alltraps>

0010221c <vector62>:
.globl vector62
vector62:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $62
  10221e:	6a 3e                	push   $0x3e
  jmp __alltraps
  102220:	e9 49 08 00 00       	jmp    102a6e <__alltraps>

00102225 <vector63>:
.globl vector63
vector63:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $63
  102227:	6a 3f                	push   $0x3f
  jmp __alltraps
  102229:	e9 40 08 00 00       	jmp    102a6e <__alltraps>

0010222e <vector64>:
.globl vector64
vector64:
  pushl $0
  10222e:	6a 00                	push   $0x0
  pushl $64
  102230:	6a 40                	push   $0x40
  jmp __alltraps
  102232:	e9 37 08 00 00       	jmp    102a6e <__alltraps>

00102237 <vector65>:
.globl vector65
vector65:
  pushl $0
  102237:	6a 00                	push   $0x0
  pushl $65
  102239:	6a 41                	push   $0x41
  jmp __alltraps
  10223b:	e9 2e 08 00 00       	jmp    102a6e <__alltraps>

00102240 <vector66>:
.globl vector66
vector66:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $66
  102242:	6a 42                	push   $0x42
  jmp __alltraps
  102244:	e9 25 08 00 00       	jmp    102a6e <__alltraps>

00102249 <vector67>:
.globl vector67
vector67:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $67
  10224b:	6a 43                	push   $0x43
  jmp __alltraps
  10224d:	e9 1c 08 00 00       	jmp    102a6e <__alltraps>

00102252 <vector68>:
.globl vector68
vector68:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $68
  102254:	6a 44                	push   $0x44
  jmp __alltraps
  102256:	e9 13 08 00 00       	jmp    102a6e <__alltraps>

0010225b <vector69>:
.globl vector69
vector69:
  pushl $0
  10225b:	6a 00                	push   $0x0
  pushl $69
  10225d:	6a 45                	push   $0x45
  jmp __alltraps
  10225f:	e9 0a 08 00 00       	jmp    102a6e <__alltraps>

00102264 <vector70>:
.globl vector70
vector70:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $70
  102266:	6a 46                	push   $0x46
  jmp __alltraps
  102268:	e9 01 08 00 00       	jmp    102a6e <__alltraps>

0010226d <vector71>:
.globl vector71
vector71:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $71
  10226f:	6a 47                	push   $0x47
  jmp __alltraps
  102271:	e9 f8 07 00 00       	jmp    102a6e <__alltraps>

00102276 <vector72>:
.globl vector72
vector72:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $72
  102278:	6a 48                	push   $0x48
  jmp __alltraps
  10227a:	e9 ef 07 00 00       	jmp    102a6e <__alltraps>

0010227f <vector73>:
.globl vector73
vector73:
  pushl $0
  10227f:	6a 00                	push   $0x0
  pushl $73
  102281:	6a 49                	push   $0x49
  jmp __alltraps
  102283:	e9 e6 07 00 00       	jmp    102a6e <__alltraps>

00102288 <vector74>:
.globl vector74
vector74:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $74
  10228a:	6a 4a                	push   $0x4a
  jmp __alltraps
  10228c:	e9 dd 07 00 00       	jmp    102a6e <__alltraps>

00102291 <vector75>:
.globl vector75
vector75:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $75
  102293:	6a 4b                	push   $0x4b
  jmp __alltraps
  102295:	e9 d4 07 00 00       	jmp    102a6e <__alltraps>

0010229a <vector76>:
.globl vector76
vector76:
  pushl $0
  10229a:	6a 00                	push   $0x0
  pushl $76
  10229c:	6a 4c                	push   $0x4c
  jmp __alltraps
  10229e:	e9 cb 07 00 00       	jmp    102a6e <__alltraps>

001022a3 <vector77>:
.globl vector77
vector77:
  pushl $0
  1022a3:	6a 00                	push   $0x0
  pushl $77
  1022a5:	6a 4d                	push   $0x4d
  jmp __alltraps
  1022a7:	e9 c2 07 00 00       	jmp    102a6e <__alltraps>

001022ac <vector78>:
.globl vector78
vector78:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $78
  1022ae:	6a 4e                	push   $0x4e
  jmp __alltraps
  1022b0:	e9 b9 07 00 00       	jmp    102a6e <__alltraps>

001022b5 <vector79>:
.globl vector79
vector79:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $79
  1022b7:	6a 4f                	push   $0x4f
  jmp __alltraps
  1022b9:	e9 b0 07 00 00       	jmp    102a6e <__alltraps>

001022be <vector80>:
.globl vector80
vector80:
  pushl $0
  1022be:	6a 00                	push   $0x0
  pushl $80
  1022c0:	6a 50                	push   $0x50
  jmp __alltraps
  1022c2:	e9 a7 07 00 00       	jmp    102a6e <__alltraps>

001022c7 <vector81>:
.globl vector81
vector81:
  pushl $0
  1022c7:	6a 00                	push   $0x0
  pushl $81
  1022c9:	6a 51                	push   $0x51
  jmp __alltraps
  1022cb:	e9 9e 07 00 00       	jmp    102a6e <__alltraps>

001022d0 <vector82>:
.globl vector82
vector82:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $82
  1022d2:	6a 52                	push   $0x52
  jmp __alltraps
  1022d4:	e9 95 07 00 00       	jmp    102a6e <__alltraps>

001022d9 <vector83>:
.globl vector83
vector83:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $83
  1022db:	6a 53                	push   $0x53
  jmp __alltraps
  1022dd:	e9 8c 07 00 00       	jmp    102a6e <__alltraps>

001022e2 <vector84>:
.globl vector84
vector84:
  pushl $0
  1022e2:	6a 00                	push   $0x0
  pushl $84
  1022e4:	6a 54                	push   $0x54
  jmp __alltraps
  1022e6:	e9 83 07 00 00       	jmp    102a6e <__alltraps>

001022eb <vector85>:
.globl vector85
vector85:
  pushl $0
  1022eb:	6a 00                	push   $0x0
  pushl $85
  1022ed:	6a 55                	push   $0x55
  jmp __alltraps
  1022ef:	e9 7a 07 00 00       	jmp    102a6e <__alltraps>

001022f4 <vector86>:
.globl vector86
vector86:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $86
  1022f6:	6a 56                	push   $0x56
  jmp __alltraps
  1022f8:	e9 71 07 00 00       	jmp    102a6e <__alltraps>

001022fd <vector87>:
.globl vector87
vector87:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $87
  1022ff:	6a 57                	push   $0x57
  jmp __alltraps
  102301:	e9 68 07 00 00       	jmp    102a6e <__alltraps>

00102306 <vector88>:
.globl vector88
vector88:
  pushl $0
  102306:	6a 00                	push   $0x0
  pushl $88
  102308:	6a 58                	push   $0x58
  jmp __alltraps
  10230a:	e9 5f 07 00 00       	jmp    102a6e <__alltraps>

0010230f <vector89>:
.globl vector89
vector89:
  pushl $0
  10230f:	6a 00                	push   $0x0
  pushl $89
  102311:	6a 59                	push   $0x59
  jmp __alltraps
  102313:	e9 56 07 00 00       	jmp    102a6e <__alltraps>

00102318 <vector90>:
.globl vector90
vector90:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $90
  10231a:	6a 5a                	push   $0x5a
  jmp __alltraps
  10231c:	e9 4d 07 00 00       	jmp    102a6e <__alltraps>

00102321 <vector91>:
.globl vector91
vector91:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $91
  102323:	6a 5b                	push   $0x5b
  jmp __alltraps
  102325:	e9 44 07 00 00       	jmp    102a6e <__alltraps>

0010232a <vector92>:
.globl vector92
vector92:
  pushl $0
  10232a:	6a 00                	push   $0x0
  pushl $92
  10232c:	6a 5c                	push   $0x5c
  jmp __alltraps
  10232e:	e9 3b 07 00 00       	jmp    102a6e <__alltraps>

00102333 <vector93>:
.globl vector93
vector93:
  pushl $0
  102333:	6a 00                	push   $0x0
  pushl $93
  102335:	6a 5d                	push   $0x5d
  jmp __alltraps
  102337:	e9 32 07 00 00       	jmp    102a6e <__alltraps>

0010233c <vector94>:
.globl vector94
vector94:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $94
  10233e:	6a 5e                	push   $0x5e
  jmp __alltraps
  102340:	e9 29 07 00 00       	jmp    102a6e <__alltraps>

00102345 <vector95>:
.globl vector95
vector95:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $95
  102347:	6a 5f                	push   $0x5f
  jmp __alltraps
  102349:	e9 20 07 00 00       	jmp    102a6e <__alltraps>

0010234e <vector96>:
.globl vector96
vector96:
  pushl $0
  10234e:	6a 00                	push   $0x0
  pushl $96
  102350:	6a 60                	push   $0x60
  jmp __alltraps
  102352:	e9 17 07 00 00       	jmp    102a6e <__alltraps>

00102357 <vector97>:
.globl vector97
vector97:
  pushl $0
  102357:	6a 00                	push   $0x0
  pushl $97
  102359:	6a 61                	push   $0x61
  jmp __alltraps
  10235b:	e9 0e 07 00 00       	jmp    102a6e <__alltraps>

00102360 <vector98>:
.globl vector98
vector98:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $98
  102362:	6a 62                	push   $0x62
  jmp __alltraps
  102364:	e9 05 07 00 00       	jmp    102a6e <__alltraps>

00102369 <vector99>:
.globl vector99
vector99:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $99
  10236b:	6a 63                	push   $0x63
  jmp __alltraps
  10236d:	e9 fc 06 00 00       	jmp    102a6e <__alltraps>

00102372 <vector100>:
.globl vector100
vector100:
  pushl $0
  102372:	6a 00                	push   $0x0
  pushl $100
  102374:	6a 64                	push   $0x64
  jmp __alltraps
  102376:	e9 f3 06 00 00       	jmp    102a6e <__alltraps>

0010237b <vector101>:
.globl vector101
vector101:
  pushl $0
  10237b:	6a 00                	push   $0x0
  pushl $101
  10237d:	6a 65                	push   $0x65
  jmp __alltraps
  10237f:	e9 ea 06 00 00       	jmp    102a6e <__alltraps>

00102384 <vector102>:
.globl vector102
vector102:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $102
  102386:	6a 66                	push   $0x66
  jmp __alltraps
  102388:	e9 e1 06 00 00       	jmp    102a6e <__alltraps>

0010238d <vector103>:
.globl vector103
vector103:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $103
  10238f:	6a 67                	push   $0x67
  jmp __alltraps
  102391:	e9 d8 06 00 00       	jmp    102a6e <__alltraps>

00102396 <vector104>:
.globl vector104
vector104:
  pushl $0
  102396:	6a 00                	push   $0x0
  pushl $104
  102398:	6a 68                	push   $0x68
  jmp __alltraps
  10239a:	e9 cf 06 00 00       	jmp    102a6e <__alltraps>

0010239f <vector105>:
.globl vector105
vector105:
  pushl $0
  10239f:	6a 00                	push   $0x0
  pushl $105
  1023a1:	6a 69                	push   $0x69
  jmp __alltraps
  1023a3:	e9 c6 06 00 00       	jmp    102a6e <__alltraps>

001023a8 <vector106>:
.globl vector106
vector106:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $106
  1023aa:	6a 6a                	push   $0x6a
  jmp __alltraps
  1023ac:	e9 bd 06 00 00       	jmp    102a6e <__alltraps>

001023b1 <vector107>:
.globl vector107
vector107:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $107
  1023b3:	6a 6b                	push   $0x6b
  jmp __alltraps
  1023b5:	e9 b4 06 00 00       	jmp    102a6e <__alltraps>

001023ba <vector108>:
.globl vector108
vector108:
  pushl $0
  1023ba:	6a 00                	push   $0x0
  pushl $108
  1023bc:	6a 6c                	push   $0x6c
  jmp __alltraps
  1023be:	e9 ab 06 00 00       	jmp    102a6e <__alltraps>

001023c3 <vector109>:
.globl vector109
vector109:
  pushl $0
  1023c3:	6a 00                	push   $0x0
  pushl $109
  1023c5:	6a 6d                	push   $0x6d
  jmp __alltraps
  1023c7:	e9 a2 06 00 00       	jmp    102a6e <__alltraps>

001023cc <vector110>:
.globl vector110
vector110:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $110
  1023ce:	6a 6e                	push   $0x6e
  jmp __alltraps
  1023d0:	e9 99 06 00 00       	jmp    102a6e <__alltraps>

001023d5 <vector111>:
.globl vector111
vector111:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $111
  1023d7:	6a 6f                	push   $0x6f
  jmp __alltraps
  1023d9:	e9 90 06 00 00       	jmp    102a6e <__alltraps>

001023de <vector112>:
.globl vector112
vector112:
  pushl $0
  1023de:	6a 00                	push   $0x0
  pushl $112
  1023e0:	6a 70                	push   $0x70
  jmp __alltraps
  1023e2:	e9 87 06 00 00       	jmp    102a6e <__alltraps>

001023e7 <vector113>:
.globl vector113
vector113:
  pushl $0
  1023e7:	6a 00                	push   $0x0
  pushl $113
  1023e9:	6a 71                	push   $0x71
  jmp __alltraps
  1023eb:	e9 7e 06 00 00       	jmp    102a6e <__alltraps>

001023f0 <vector114>:
.globl vector114
vector114:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $114
  1023f2:	6a 72                	push   $0x72
  jmp __alltraps
  1023f4:	e9 75 06 00 00       	jmp    102a6e <__alltraps>

001023f9 <vector115>:
.globl vector115
vector115:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $115
  1023fb:	6a 73                	push   $0x73
  jmp __alltraps
  1023fd:	e9 6c 06 00 00       	jmp    102a6e <__alltraps>

00102402 <vector116>:
.globl vector116
vector116:
  pushl $0
  102402:	6a 00                	push   $0x0
  pushl $116
  102404:	6a 74                	push   $0x74
  jmp __alltraps
  102406:	e9 63 06 00 00       	jmp    102a6e <__alltraps>

0010240b <vector117>:
.globl vector117
vector117:
  pushl $0
  10240b:	6a 00                	push   $0x0
  pushl $117
  10240d:	6a 75                	push   $0x75
  jmp __alltraps
  10240f:	e9 5a 06 00 00       	jmp    102a6e <__alltraps>

00102414 <vector118>:
.globl vector118
vector118:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $118
  102416:	6a 76                	push   $0x76
  jmp __alltraps
  102418:	e9 51 06 00 00       	jmp    102a6e <__alltraps>

0010241d <vector119>:
.globl vector119
vector119:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $119
  10241f:	6a 77                	push   $0x77
  jmp __alltraps
  102421:	e9 48 06 00 00       	jmp    102a6e <__alltraps>

00102426 <vector120>:
.globl vector120
vector120:
  pushl $0
  102426:	6a 00                	push   $0x0
  pushl $120
  102428:	6a 78                	push   $0x78
  jmp __alltraps
  10242a:	e9 3f 06 00 00       	jmp    102a6e <__alltraps>

0010242f <vector121>:
.globl vector121
vector121:
  pushl $0
  10242f:	6a 00                	push   $0x0
  pushl $121
  102431:	6a 79                	push   $0x79
  jmp __alltraps
  102433:	e9 36 06 00 00       	jmp    102a6e <__alltraps>

00102438 <vector122>:
.globl vector122
vector122:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $122
  10243a:	6a 7a                	push   $0x7a
  jmp __alltraps
  10243c:	e9 2d 06 00 00       	jmp    102a6e <__alltraps>

00102441 <vector123>:
.globl vector123
vector123:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $123
  102443:	6a 7b                	push   $0x7b
  jmp __alltraps
  102445:	e9 24 06 00 00       	jmp    102a6e <__alltraps>

0010244a <vector124>:
.globl vector124
vector124:
  pushl $0
  10244a:	6a 00                	push   $0x0
  pushl $124
  10244c:	6a 7c                	push   $0x7c
  jmp __alltraps
  10244e:	e9 1b 06 00 00       	jmp    102a6e <__alltraps>

00102453 <vector125>:
.globl vector125
vector125:
  pushl $0
  102453:	6a 00                	push   $0x0
  pushl $125
  102455:	6a 7d                	push   $0x7d
  jmp __alltraps
  102457:	e9 12 06 00 00       	jmp    102a6e <__alltraps>

0010245c <vector126>:
.globl vector126
vector126:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $126
  10245e:	6a 7e                	push   $0x7e
  jmp __alltraps
  102460:	e9 09 06 00 00       	jmp    102a6e <__alltraps>

00102465 <vector127>:
.globl vector127
vector127:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $127
  102467:	6a 7f                	push   $0x7f
  jmp __alltraps
  102469:	e9 00 06 00 00       	jmp    102a6e <__alltraps>

0010246e <vector128>:
.globl vector128
vector128:
  pushl $0
  10246e:	6a 00                	push   $0x0
  pushl $128
  102470:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102475:	e9 f4 05 00 00       	jmp    102a6e <__alltraps>

0010247a <vector129>:
.globl vector129
vector129:
  pushl $0
  10247a:	6a 00                	push   $0x0
  pushl $129
  10247c:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102481:	e9 e8 05 00 00       	jmp    102a6e <__alltraps>

00102486 <vector130>:
.globl vector130
vector130:
  pushl $0
  102486:	6a 00                	push   $0x0
  pushl $130
  102488:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10248d:	e9 dc 05 00 00       	jmp    102a6e <__alltraps>

00102492 <vector131>:
.globl vector131
vector131:
  pushl $0
  102492:	6a 00                	push   $0x0
  pushl $131
  102494:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102499:	e9 d0 05 00 00       	jmp    102a6e <__alltraps>

0010249e <vector132>:
.globl vector132
vector132:
  pushl $0
  10249e:	6a 00                	push   $0x0
  pushl $132
  1024a0:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1024a5:	e9 c4 05 00 00       	jmp    102a6e <__alltraps>

001024aa <vector133>:
.globl vector133
vector133:
  pushl $0
  1024aa:	6a 00                	push   $0x0
  pushl $133
  1024ac:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1024b1:	e9 b8 05 00 00       	jmp    102a6e <__alltraps>

001024b6 <vector134>:
.globl vector134
vector134:
  pushl $0
  1024b6:	6a 00                	push   $0x0
  pushl $134
  1024b8:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1024bd:	e9 ac 05 00 00       	jmp    102a6e <__alltraps>

001024c2 <vector135>:
.globl vector135
vector135:
  pushl $0
  1024c2:	6a 00                	push   $0x0
  pushl $135
  1024c4:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1024c9:	e9 a0 05 00 00       	jmp    102a6e <__alltraps>

001024ce <vector136>:
.globl vector136
vector136:
  pushl $0
  1024ce:	6a 00                	push   $0x0
  pushl $136
  1024d0:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1024d5:	e9 94 05 00 00       	jmp    102a6e <__alltraps>

001024da <vector137>:
.globl vector137
vector137:
  pushl $0
  1024da:	6a 00                	push   $0x0
  pushl $137
  1024dc:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1024e1:	e9 88 05 00 00       	jmp    102a6e <__alltraps>

001024e6 <vector138>:
.globl vector138
vector138:
  pushl $0
  1024e6:	6a 00                	push   $0x0
  pushl $138
  1024e8:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1024ed:	e9 7c 05 00 00       	jmp    102a6e <__alltraps>

001024f2 <vector139>:
.globl vector139
vector139:
  pushl $0
  1024f2:	6a 00                	push   $0x0
  pushl $139
  1024f4:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1024f9:	e9 70 05 00 00       	jmp    102a6e <__alltraps>

001024fe <vector140>:
.globl vector140
vector140:
  pushl $0
  1024fe:	6a 00                	push   $0x0
  pushl $140
  102500:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102505:	e9 64 05 00 00       	jmp    102a6e <__alltraps>

0010250a <vector141>:
.globl vector141
vector141:
  pushl $0
  10250a:	6a 00                	push   $0x0
  pushl $141
  10250c:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102511:	e9 58 05 00 00       	jmp    102a6e <__alltraps>

00102516 <vector142>:
.globl vector142
vector142:
  pushl $0
  102516:	6a 00                	push   $0x0
  pushl $142
  102518:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10251d:	e9 4c 05 00 00       	jmp    102a6e <__alltraps>

00102522 <vector143>:
.globl vector143
vector143:
  pushl $0
  102522:	6a 00                	push   $0x0
  pushl $143
  102524:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102529:	e9 40 05 00 00       	jmp    102a6e <__alltraps>

0010252e <vector144>:
.globl vector144
vector144:
  pushl $0
  10252e:	6a 00                	push   $0x0
  pushl $144
  102530:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102535:	e9 34 05 00 00       	jmp    102a6e <__alltraps>

0010253a <vector145>:
.globl vector145
vector145:
  pushl $0
  10253a:	6a 00                	push   $0x0
  pushl $145
  10253c:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102541:	e9 28 05 00 00       	jmp    102a6e <__alltraps>

00102546 <vector146>:
.globl vector146
vector146:
  pushl $0
  102546:	6a 00                	push   $0x0
  pushl $146
  102548:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10254d:	e9 1c 05 00 00       	jmp    102a6e <__alltraps>

00102552 <vector147>:
.globl vector147
vector147:
  pushl $0
  102552:	6a 00                	push   $0x0
  pushl $147
  102554:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102559:	e9 10 05 00 00       	jmp    102a6e <__alltraps>

0010255e <vector148>:
.globl vector148
vector148:
  pushl $0
  10255e:	6a 00                	push   $0x0
  pushl $148
  102560:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102565:	e9 04 05 00 00       	jmp    102a6e <__alltraps>

0010256a <vector149>:
.globl vector149
vector149:
  pushl $0
  10256a:	6a 00                	push   $0x0
  pushl $149
  10256c:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102571:	e9 f8 04 00 00       	jmp    102a6e <__alltraps>

00102576 <vector150>:
.globl vector150
vector150:
  pushl $0
  102576:	6a 00                	push   $0x0
  pushl $150
  102578:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10257d:	e9 ec 04 00 00       	jmp    102a6e <__alltraps>

00102582 <vector151>:
.globl vector151
vector151:
  pushl $0
  102582:	6a 00                	push   $0x0
  pushl $151
  102584:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102589:	e9 e0 04 00 00       	jmp    102a6e <__alltraps>

0010258e <vector152>:
.globl vector152
vector152:
  pushl $0
  10258e:	6a 00                	push   $0x0
  pushl $152
  102590:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102595:	e9 d4 04 00 00       	jmp    102a6e <__alltraps>

0010259a <vector153>:
.globl vector153
vector153:
  pushl $0
  10259a:	6a 00                	push   $0x0
  pushl $153
  10259c:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1025a1:	e9 c8 04 00 00       	jmp    102a6e <__alltraps>

001025a6 <vector154>:
.globl vector154
vector154:
  pushl $0
  1025a6:	6a 00                	push   $0x0
  pushl $154
  1025a8:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1025ad:	e9 bc 04 00 00       	jmp    102a6e <__alltraps>

001025b2 <vector155>:
.globl vector155
vector155:
  pushl $0
  1025b2:	6a 00                	push   $0x0
  pushl $155
  1025b4:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1025b9:	e9 b0 04 00 00       	jmp    102a6e <__alltraps>

001025be <vector156>:
.globl vector156
vector156:
  pushl $0
  1025be:	6a 00                	push   $0x0
  pushl $156
  1025c0:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1025c5:	e9 a4 04 00 00       	jmp    102a6e <__alltraps>

001025ca <vector157>:
.globl vector157
vector157:
  pushl $0
  1025ca:	6a 00                	push   $0x0
  pushl $157
  1025cc:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1025d1:	e9 98 04 00 00       	jmp    102a6e <__alltraps>

001025d6 <vector158>:
.globl vector158
vector158:
  pushl $0
  1025d6:	6a 00                	push   $0x0
  pushl $158
  1025d8:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1025dd:	e9 8c 04 00 00       	jmp    102a6e <__alltraps>

001025e2 <vector159>:
.globl vector159
vector159:
  pushl $0
  1025e2:	6a 00                	push   $0x0
  pushl $159
  1025e4:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1025e9:	e9 80 04 00 00       	jmp    102a6e <__alltraps>

001025ee <vector160>:
.globl vector160
vector160:
  pushl $0
  1025ee:	6a 00                	push   $0x0
  pushl $160
  1025f0:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1025f5:	e9 74 04 00 00       	jmp    102a6e <__alltraps>

001025fa <vector161>:
.globl vector161
vector161:
  pushl $0
  1025fa:	6a 00                	push   $0x0
  pushl $161
  1025fc:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102601:	e9 68 04 00 00       	jmp    102a6e <__alltraps>

00102606 <vector162>:
.globl vector162
vector162:
  pushl $0
  102606:	6a 00                	push   $0x0
  pushl $162
  102608:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10260d:	e9 5c 04 00 00       	jmp    102a6e <__alltraps>

00102612 <vector163>:
.globl vector163
vector163:
  pushl $0
  102612:	6a 00                	push   $0x0
  pushl $163
  102614:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102619:	e9 50 04 00 00       	jmp    102a6e <__alltraps>

0010261e <vector164>:
.globl vector164
vector164:
  pushl $0
  10261e:	6a 00                	push   $0x0
  pushl $164
  102620:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102625:	e9 44 04 00 00       	jmp    102a6e <__alltraps>

0010262a <vector165>:
.globl vector165
vector165:
  pushl $0
  10262a:	6a 00                	push   $0x0
  pushl $165
  10262c:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102631:	e9 38 04 00 00       	jmp    102a6e <__alltraps>

00102636 <vector166>:
.globl vector166
vector166:
  pushl $0
  102636:	6a 00                	push   $0x0
  pushl $166
  102638:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10263d:	e9 2c 04 00 00       	jmp    102a6e <__alltraps>

00102642 <vector167>:
.globl vector167
vector167:
  pushl $0
  102642:	6a 00                	push   $0x0
  pushl $167
  102644:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102649:	e9 20 04 00 00       	jmp    102a6e <__alltraps>

0010264e <vector168>:
.globl vector168
vector168:
  pushl $0
  10264e:	6a 00                	push   $0x0
  pushl $168
  102650:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102655:	e9 14 04 00 00       	jmp    102a6e <__alltraps>

0010265a <vector169>:
.globl vector169
vector169:
  pushl $0
  10265a:	6a 00                	push   $0x0
  pushl $169
  10265c:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102661:	e9 08 04 00 00       	jmp    102a6e <__alltraps>

00102666 <vector170>:
.globl vector170
vector170:
  pushl $0
  102666:	6a 00                	push   $0x0
  pushl $170
  102668:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10266d:	e9 fc 03 00 00       	jmp    102a6e <__alltraps>

00102672 <vector171>:
.globl vector171
vector171:
  pushl $0
  102672:	6a 00                	push   $0x0
  pushl $171
  102674:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102679:	e9 f0 03 00 00       	jmp    102a6e <__alltraps>

0010267e <vector172>:
.globl vector172
vector172:
  pushl $0
  10267e:	6a 00                	push   $0x0
  pushl $172
  102680:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102685:	e9 e4 03 00 00       	jmp    102a6e <__alltraps>

0010268a <vector173>:
.globl vector173
vector173:
  pushl $0
  10268a:	6a 00                	push   $0x0
  pushl $173
  10268c:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102691:	e9 d8 03 00 00       	jmp    102a6e <__alltraps>

00102696 <vector174>:
.globl vector174
vector174:
  pushl $0
  102696:	6a 00                	push   $0x0
  pushl $174
  102698:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10269d:	e9 cc 03 00 00       	jmp    102a6e <__alltraps>

001026a2 <vector175>:
.globl vector175
vector175:
  pushl $0
  1026a2:	6a 00                	push   $0x0
  pushl $175
  1026a4:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1026a9:	e9 c0 03 00 00       	jmp    102a6e <__alltraps>

001026ae <vector176>:
.globl vector176
vector176:
  pushl $0
  1026ae:	6a 00                	push   $0x0
  pushl $176
  1026b0:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1026b5:	e9 b4 03 00 00       	jmp    102a6e <__alltraps>

001026ba <vector177>:
.globl vector177
vector177:
  pushl $0
  1026ba:	6a 00                	push   $0x0
  pushl $177
  1026bc:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1026c1:	e9 a8 03 00 00       	jmp    102a6e <__alltraps>

001026c6 <vector178>:
.globl vector178
vector178:
  pushl $0
  1026c6:	6a 00                	push   $0x0
  pushl $178
  1026c8:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1026cd:	e9 9c 03 00 00       	jmp    102a6e <__alltraps>

001026d2 <vector179>:
.globl vector179
vector179:
  pushl $0
  1026d2:	6a 00                	push   $0x0
  pushl $179
  1026d4:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1026d9:	e9 90 03 00 00       	jmp    102a6e <__alltraps>

001026de <vector180>:
.globl vector180
vector180:
  pushl $0
  1026de:	6a 00                	push   $0x0
  pushl $180
  1026e0:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1026e5:	e9 84 03 00 00       	jmp    102a6e <__alltraps>

001026ea <vector181>:
.globl vector181
vector181:
  pushl $0
  1026ea:	6a 00                	push   $0x0
  pushl $181
  1026ec:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1026f1:	e9 78 03 00 00       	jmp    102a6e <__alltraps>

001026f6 <vector182>:
.globl vector182
vector182:
  pushl $0
  1026f6:	6a 00                	push   $0x0
  pushl $182
  1026f8:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1026fd:	e9 6c 03 00 00       	jmp    102a6e <__alltraps>

00102702 <vector183>:
.globl vector183
vector183:
  pushl $0
  102702:	6a 00                	push   $0x0
  pushl $183
  102704:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102709:	e9 60 03 00 00       	jmp    102a6e <__alltraps>

0010270e <vector184>:
.globl vector184
vector184:
  pushl $0
  10270e:	6a 00                	push   $0x0
  pushl $184
  102710:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102715:	e9 54 03 00 00       	jmp    102a6e <__alltraps>

0010271a <vector185>:
.globl vector185
vector185:
  pushl $0
  10271a:	6a 00                	push   $0x0
  pushl $185
  10271c:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102721:	e9 48 03 00 00       	jmp    102a6e <__alltraps>

00102726 <vector186>:
.globl vector186
vector186:
  pushl $0
  102726:	6a 00                	push   $0x0
  pushl $186
  102728:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10272d:	e9 3c 03 00 00       	jmp    102a6e <__alltraps>

00102732 <vector187>:
.globl vector187
vector187:
  pushl $0
  102732:	6a 00                	push   $0x0
  pushl $187
  102734:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102739:	e9 30 03 00 00       	jmp    102a6e <__alltraps>

0010273e <vector188>:
.globl vector188
vector188:
  pushl $0
  10273e:	6a 00                	push   $0x0
  pushl $188
  102740:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102745:	e9 24 03 00 00       	jmp    102a6e <__alltraps>

0010274a <vector189>:
.globl vector189
vector189:
  pushl $0
  10274a:	6a 00                	push   $0x0
  pushl $189
  10274c:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102751:	e9 18 03 00 00       	jmp    102a6e <__alltraps>

00102756 <vector190>:
.globl vector190
vector190:
  pushl $0
  102756:	6a 00                	push   $0x0
  pushl $190
  102758:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10275d:	e9 0c 03 00 00       	jmp    102a6e <__alltraps>

00102762 <vector191>:
.globl vector191
vector191:
  pushl $0
  102762:	6a 00                	push   $0x0
  pushl $191
  102764:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102769:	e9 00 03 00 00       	jmp    102a6e <__alltraps>

0010276e <vector192>:
.globl vector192
vector192:
  pushl $0
  10276e:	6a 00                	push   $0x0
  pushl $192
  102770:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102775:	e9 f4 02 00 00       	jmp    102a6e <__alltraps>

0010277a <vector193>:
.globl vector193
vector193:
  pushl $0
  10277a:	6a 00                	push   $0x0
  pushl $193
  10277c:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102781:	e9 e8 02 00 00       	jmp    102a6e <__alltraps>

00102786 <vector194>:
.globl vector194
vector194:
  pushl $0
  102786:	6a 00                	push   $0x0
  pushl $194
  102788:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10278d:	e9 dc 02 00 00       	jmp    102a6e <__alltraps>

00102792 <vector195>:
.globl vector195
vector195:
  pushl $0
  102792:	6a 00                	push   $0x0
  pushl $195
  102794:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102799:	e9 d0 02 00 00       	jmp    102a6e <__alltraps>

0010279e <vector196>:
.globl vector196
vector196:
  pushl $0
  10279e:	6a 00                	push   $0x0
  pushl $196
  1027a0:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1027a5:	e9 c4 02 00 00       	jmp    102a6e <__alltraps>

001027aa <vector197>:
.globl vector197
vector197:
  pushl $0
  1027aa:	6a 00                	push   $0x0
  pushl $197
  1027ac:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1027b1:	e9 b8 02 00 00       	jmp    102a6e <__alltraps>

001027b6 <vector198>:
.globl vector198
vector198:
  pushl $0
  1027b6:	6a 00                	push   $0x0
  pushl $198
  1027b8:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1027bd:	e9 ac 02 00 00       	jmp    102a6e <__alltraps>

001027c2 <vector199>:
.globl vector199
vector199:
  pushl $0
  1027c2:	6a 00                	push   $0x0
  pushl $199
  1027c4:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1027c9:	e9 a0 02 00 00       	jmp    102a6e <__alltraps>

001027ce <vector200>:
.globl vector200
vector200:
  pushl $0
  1027ce:	6a 00                	push   $0x0
  pushl $200
  1027d0:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1027d5:	e9 94 02 00 00       	jmp    102a6e <__alltraps>

001027da <vector201>:
.globl vector201
vector201:
  pushl $0
  1027da:	6a 00                	push   $0x0
  pushl $201
  1027dc:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1027e1:	e9 88 02 00 00       	jmp    102a6e <__alltraps>

001027e6 <vector202>:
.globl vector202
vector202:
  pushl $0
  1027e6:	6a 00                	push   $0x0
  pushl $202
  1027e8:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1027ed:	e9 7c 02 00 00       	jmp    102a6e <__alltraps>

001027f2 <vector203>:
.globl vector203
vector203:
  pushl $0
  1027f2:	6a 00                	push   $0x0
  pushl $203
  1027f4:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1027f9:	e9 70 02 00 00       	jmp    102a6e <__alltraps>

001027fe <vector204>:
.globl vector204
vector204:
  pushl $0
  1027fe:	6a 00                	push   $0x0
  pushl $204
  102800:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102805:	e9 64 02 00 00       	jmp    102a6e <__alltraps>

0010280a <vector205>:
.globl vector205
vector205:
  pushl $0
  10280a:	6a 00                	push   $0x0
  pushl $205
  10280c:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102811:	e9 58 02 00 00       	jmp    102a6e <__alltraps>

00102816 <vector206>:
.globl vector206
vector206:
  pushl $0
  102816:	6a 00                	push   $0x0
  pushl $206
  102818:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10281d:	e9 4c 02 00 00       	jmp    102a6e <__alltraps>

00102822 <vector207>:
.globl vector207
vector207:
  pushl $0
  102822:	6a 00                	push   $0x0
  pushl $207
  102824:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102829:	e9 40 02 00 00       	jmp    102a6e <__alltraps>

0010282e <vector208>:
.globl vector208
vector208:
  pushl $0
  10282e:	6a 00                	push   $0x0
  pushl $208
  102830:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102835:	e9 34 02 00 00       	jmp    102a6e <__alltraps>

0010283a <vector209>:
.globl vector209
vector209:
  pushl $0
  10283a:	6a 00                	push   $0x0
  pushl $209
  10283c:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102841:	e9 28 02 00 00       	jmp    102a6e <__alltraps>

00102846 <vector210>:
.globl vector210
vector210:
  pushl $0
  102846:	6a 00                	push   $0x0
  pushl $210
  102848:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10284d:	e9 1c 02 00 00       	jmp    102a6e <__alltraps>

00102852 <vector211>:
.globl vector211
vector211:
  pushl $0
  102852:	6a 00                	push   $0x0
  pushl $211
  102854:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102859:	e9 10 02 00 00       	jmp    102a6e <__alltraps>

0010285e <vector212>:
.globl vector212
vector212:
  pushl $0
  10285e:	6a 00                	push   $0x0
  pushl $212
  102860:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102865:	e9 04 02 00 00       	jmp    102a6e <__alltraps>

0010286a <vector213>:
.globl vector213
vector213:
  pushl $0
  10286a:	6a 00                	push   $0x0
  pushl $213
  10286c:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102871:	e9 f8 01 00 00       	jmp    102a6e <__alltraps>

00102876 <vector214>:
.globl vector214
vector214:
  pushl $0
  102876:	6a 00                	push   $0x0
  pushl $214
  102878:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10287d:	e9 ec 01 00 00       	jmp    102a6e <__alltraps>

00102882 <vector215>:
.globl vector215
vector215:
  pushl $0
  102882:	6a 00                	push   $0x0
  pushl $215
  102884:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102889:	e9 e0 01 00 00       	jmp    102a6e <__alltraps>

0010288e <vector216>:
.globl vector216
vector216:
  pushl $0
  10288e:	6a 00                	push   $0x0
  pushl $216
  102890:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102895:	e9 d4 01 00 00       	jmp    102a6e <__alltraps>

0010289a <vector217>:
.globl vector217
vector217:
  pushl $0
  10289a:	6a 00                	push   $0x0
  pushl $217
  10289c:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1028a1:	e9 c8 01 00 00       	jmp    102a6e <__alltraps>

001028a6 <vector218>:
.globl vector218
vector218:
  pushl $0
  1028a6:	6a 00                	push   $0x0
  pushl $218
  1028a8:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1028ad:	e9 bc 01 00 00       	jmp    102a6e <__alltraps>

001028b2 <vector219>:
.globl vector219
vector219:
  pushl $0
  1028b2:	6a 00                	push   $0x0
  pushl $219
  1028b4:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1028b9:	e9 b0 01 00 00       	jmp    102a6e <__alltraps>

001028be <vector220>:
.globl vector220
vector220:
  pushl $0
  1028be:	6a 00                	push   $0x0
  pushl $220
  1028c0:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1028c5:	e9 a4 01 00 00       	jmp    102a6e <__alltraps>

001028ca <vector221>:
.globl vector221
vector221:
  pushl $0
  1028ca:	6a 00                	push   $0x0
  pushl $221
  1028cc:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1028d1:	e9 98 01 00 00       	jmp    102a6e <__alltraps>

001028d6 <vector222>:
.globl vector222
vector222:
  pushl $0
  1028d6:	6a 00                	push   $0x0
  pushl $222
  1028d8:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1028dd:	e9 8c 01 00 00       	jmp    102a6e <__alltraps>

001028e2 <vector223>:
.globl vector223
vector223:
  pushl $0
  1028e2:	6a 00                	push   $0x0
  pushl $223
  1028e4:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1028e9:	e9 80 01 00 00       	jmp    102a6e <__alltraps>

001028ee <vector224>:
.globl vector224
vector224:
  pushl $0
  1028ee:	6a 00                	push   $0x0
  pushl $224
  1028f0:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1028f5:	e9 74 01 00 00       	jmp    102a6e <__alltraps>

001028fa <vector225>:
.globl vector225
vector225:
  pushl $0
  1028fa:	6a 00                	push   $0x0
  pushl $225
  1028fc:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102901:	e9 68 01 00 00       	jmp    102a6e <__alltraps>

00102906 <vector226>:
.globl vector226
vector226:
  pushl $0
  102906:	6a 00                	push   $0x0
  pushl $226
  102908:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10290d:	e9 5c 01 00 00       	jmp    102a6e <__alltraps>

00102912 <vector227>:
.globl vector227
vector227:
  pushl $0
  102912:	6a 00                	push   $0x0
  pushl $227
  102914:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102919:	e9 50 01 00 00       	jmp    102a6e <__alltraps>

0010291e <vector228>:
.globl vector228
vector228:
  pushl $0
  10291e:	6a 00                	push   $0x0
  pushl $228
  102920:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102925:	e9 44 01 00 00       	jmp    102a6e <__alltraps>

0010292a <vector229>:
.globl vector229
vector229:
  pushl $0
  10292a:	6a 00                	push   $0x0
  pushl $229
  10292c:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102931:	e9 38 01 00 00       	jmp    102a6e <__alltraps>

00102936 <vector230>:
.globl vector230
vector230:
  pushl $0
  102936:	6a 00                	push   $0x0
  pushl $230
  102938:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10293d:	e9 2c 01 00 00       	jmp    102a6e <__alltraps>

00102942 <vector231>:
.globl vector231
vector231:
  pushl $0
  102942:	6a 00                	push   $0x0
  pushl $231
  102944:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102949:	e9 20 01 00 00       	jmp    102a6e <__alltraps>

0010294e <vector232>:
.globl vector232
vector232:
  pushl $0
  10294e:	6a 00                	push   $0x0
  pushl $232
  102950:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102955:	e9 14 01 00 00       	jmp    102a6e <__alltraps>

0010295a <vector233>:
.globl vector233
vector233:
  pushl $0
  10295a:	6a 00                	push   $0x0
  pushl $233
  10295c:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102961:	e9 08 01 00 00       	jmp    102a6e <__alltraps>

00102966 <vector234>:
.globl vector234
vector234:
  pushl $0
  102966:	6a 00                	push   $0x0
  pushl $234
  102968:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10296d:	e9 fc 00 00 00       	jmp    102a6e <__alltraps>

00102972 <vector235>:
.globl vector235
vector235:
  pushl $0
  102972:	6a 00                	push   $0x0
  pushl $235
  102974:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102979:	e9 f0 00 00 00       	jmp    102a6e <__alltraps>

0010297e <vector236>:
.globl vector236
vector236:
  pushl $0
  10297e:	6a 00                	push   $0x0
  pushl $236
  102980:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102985:	e9 e4 00 00 00       	jmp    102a6e <__alltraps>

0010298a <vector237>:
.globl vector237
vector237:
  pushl $0
  10298a:	6a 00                	push   $0x0
  pushl $237
  10298c:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102991:	e9 d8 00 00 00       	jmp    102a6e <__alltraps>

00102996 <vector238>:
.globl vector238
vector238:
  pushl $0
  102996:	6a 00                	push   $0x0
  pushl $238
  102998:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10299d:	e9 cc 00 00 00       	jmp    102a6e <__alltraps>

001029a2 <vector239>:
.globl vector239
vector239:
  pushl $0
  1029a2:	6a 00                	push   $0x0
  pushl $239
  1029a4:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1029a9:	e9 c0 00 00 00       	jmp    102a6e <__alltraps>

001029ae <vector240>:
.globl vector240
vector240:
  pushl $0
  1029ae:	6a 00                	push   $0x0
  pushl $240
  1029b0:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1029b5:	e9 b4 00 00 00       	jmp    102a6e <__alltraps>

001029ba <vector241>:
.globl vector241
vector241:
  pushl $0
  1029ba:	6a 00                	push   $0x0
  pushl $241
  1029bc:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1029c1:	e9 a8 00 00 00       	jmp    102a6e <__alltraps>

001029c6 <vector242>:
.globl vector242
vector242:
  pushl $0
  1029c6:	6a 00                	push   $0x0
  pushl $242
  1029c8:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1029cd:	e9 9c 00 00 00       	jmp    102a6e <__alltraps>

001029d2 <vector243>:
.globl vector243
vector243:
  pushl $0
  1029d2:	6a 00                	push   $0x0
  pushl $243
  1029d4:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1029d9:	e9 90 00 00 00       	jmp    102a6e <__alltraps>

001029de <vector244>:
.globl vector244
vector244:
  pushl $0
  1029de:	6a 00                	push   $0x0
  pushl $244
  1029e0:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1029e5:	e9 84 00 00 00       	jmp    102a6e <__alltraps>

001029ea <vector245>:
.globl vector245
vector245:
  pushl $0
  1029ea:	6a 00                	push   $0x0
  pushl $245
  1029ec:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1029f1:	e9 78 00 00 00       	jmp    102a6e <__alltraps>

001029f6 <vector246>:
.globl vector246
vector246:
  pushl $0
  1029f6:	6a 00                	push   $0x0
  pushl $246
  1029f8:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1029fd:	e9 6c 00 00 00       	jmp    102a6e <__alltraps>

00102a02 <vector247>:
.globl vector247
vector247:
  pushl $0
  102a02:	6a 00                	push   $0x0
  pushl $247
  102a04:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102a09:	e9 60 00 00 00       	jmp    102a6e <__alltraps>

00102a0e <vector248>:
.globl vector248
vector248:
  pushl $0
  102a0e:	6a 00                	push   $0x0
  pushl $248
  102a10:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102a15:	e9 54 00 00 00       	jmp    102a6e <__alltraps>

00102a1a <vector249>:
.globl vector249
vector249:
  pushl $0
  102a1a:	6a 00                	push   $0x0
  pushl $249
  102a1c:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102a21:	e9 48 00 00 00       	jmp    102a6e <__alltraps>

00102a26 <vector250>:
.globl vector250
vector250:
  pushl $0
  102a26:	6a 00                	push   $0x0
  pushl $250
  102a28:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a2d:	e9 3c 00 00 00       	jmp    102a6e <__alltraps>

00102a32 <vector251>:
.globl vector251
vector251:
  pushl $0
  102a32:	6a 00                	push   $0x0
  pushl $251
  102a34:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102a39:	e9 30 00 00 00       	jmp    102a6e <__alltraps>

00102a3e <vector252>:
.globl vector252
vector252:
  pushl $0
  102a3e:	6a 00                	push   $0x0
  pushl $252
  102a40:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a45:	e9 24 00 00 00       	jmp    102a6e <__alltraps>

00102a4a <vector253>:
.globl vector253
vector253:
  pushl $0
  102a4a:	6a 00                	push   $0x0
  pushl $253
  102a4c:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102a51:	e9 18 00 00 00       	jmp    102a6e <__alltraps>

00102a56 <vector254>:
.globl vector254
vector254:
  pushl $0
  102a56:	6a 00                	push   $0x0
  pushl $254
  102a58:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a5d:	e9 0c 00 00 00       	jmp    102a6e <__alltraps>

00102a62 <vector255>:
.globl vector255
vector255:
  pushl $0
  102a62:	6a 00                	push   $0x0
  pushl $255
  102a64:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a69:	e9 00 00 00 00       	jmp    102a6e <__alltraps>

00102a6e <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102a6e:	1e                   	push   %ds
    pushl %es
  102a6f:	06                   	push   %es
    pushl %fs
  102a70:	0f a0                	push   %fs
    pushl %gs
  102a72:	0f a8                	push   %gs
    pushal
  102a74:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102a75:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102a7a:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102a7c:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102a7e:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102a7f:	e8 57 f5 ff ff       	call   101fdb <trap>

    # pop the pushed stack pointer
    popl %esp
  102a84:	5c                   	pop    %esp

00102a85 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102a85:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102a86:	0f a9                	pop    %gs
    popl %fs
  102a88:	0f a1                	pop    %fs
    popl %es
  102a8a:	07                   	pop    %es
    popl %ds
  102a8b:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102a8c:	83 c4 08             	add    $0x8,%esp
    iret
  102a8f:	cf                   	iret   

00102a90 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102a90:	55                   	push   %ebp
  102a91:	89 e5                	mov    %esp,%ebp
  102a93:	e8 e4 d7 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102a98:	05 b8 be 00 00       	add    $0xbeb8,%eax
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102aa3:	b8 23 00 00 00       	mov    $0x23,%eax
  102aa8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102aaa:	b8 23 00 00 00       	mov    $0x23,%eax
  102aaf:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102ab1:	b8 10 00 00 00       	mov    $0x10,%eax
  102ab6:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102ab8:	b8 10 00 00 00       	mov    $0x10,%eax
  102abd:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102abf:	b8 10 00 00 00       	mov    $0x10,%eax
  102ac4:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102ac6:	ea cd 2a 10 00 08 00 	ljmp   $0x8,$0x102acd
}
  102acd:	90                   	nop
  102ace:	5d                   	pop    %ebp
  102acf:	c3                   	ret    

00102ad0 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102ad0:	55                   	push   %ebp
  102ad1:	89 e5                	mov    %esp,%ebp
  102ad3:	83 ec 10             	sub    $0x10,%esp
  102ad6:	e8 a1 d7 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102adb:	05 75 be 00 00       	add    $0xbe75,%eax
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102ae0:	c7 c2 c0 f9 10 00    	mov    $0x10f9c0,%edx
  102ae6:	81 c2 00 04 00 00    	add    $0x400,%edx
  102aec:	89 90 f4 0f 00 00    	mov    %edx,0xff4(%eax)
    ts.ts_ss0 = KERNEL_DS;
  102af2:	66 c7 80 f8 0f 00 00 	movw   $0x10,0xff8(%eax)
  102af9:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102afb:	66 c7 80 f8 ff ff ff 	movw   $0x68,-0x8(%eax)
  102b02:	68 00 
  102b04:	8d 90 f0 0f 00 00    	lea    0xff0(%eax),%edx
  102b0a:	66 89 90 fa ff ff ff 	mov    %dx,-0x6(%eax)
  102b11:	8d 90 f0 0f 00 00    	lea    0xff0(%eax),%edx
  102b17:	c1 ea 10             	shr    $0x10,%edx
  102b1a:	88 90 fc ff ff ff    	mov    %dl,-0x4(%eax)
  102b20:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  102b27:	83 e2 f0             	and    $0xfffffff0,%edx
  102b2a:	83 ca 09             	or     $0x9,%edx
  102b2d:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)
  102b33:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  102b3a:	83 ca 10             	or     $0x10,%edx
  102b3d:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)
  102b43:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  102b4a:	83 e2 9f             	and    $0xffffff9f,%edx
  102b4d:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)
  102b53:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  102b5a:	83 ca 80             	or     $0xffffff80,%edx
  102b5d:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)
  102b63:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102b6a:	83 e2 f0             	and    $0xfffffff0,%edx
  102b6d:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102b73:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102b7a:	83 e2 ef             	and    $0xffffffef,%edx
  102b7d:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102b83:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102b8a:	83 e2 df             	and    $0xffffffdf,%edx
  102b8d:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102b93:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102b9a:	83 ca 40             	or     $0x40,%edx
  102b9d:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102ba3:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102baa:	83 e2 7f             	and    $0x7f,%edx
  102bad:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102bb3:	8d 90 f0 0f 00 00    	lea    0xff0(%eax),%edx
  102bb9:	c1 ea 18             	shr    $0x18,%edx
  102bbc:	88 90 ff ff ff ff    	mov    %dl,-0x1(%eax)
    gdt[SEG_TSS].sd_s = 0;
  102bc2:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  102bc9:	83 e2 ef             	and    $0xffffffef,%edx
  102bcc:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)

    // reload all segment registers
    lgdt(&gdt_pd);
  102bd2:	8d 80 d0 00 00 00    	lea    0xd0(%eax),%eax
  102bd8:	50                   	push   %eax
  102bd9:	e8 b2 fe ff ff       	call   102a90 <lgdt>
  102bde:	83 c4 04             	add    $0x4,%esp
  102be1:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102be7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102beb:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102bee:	90                   	nop
  102bef:	c9                   	leave  
  102bf0:	c3                   	ret    

00102bf1 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102bf1:	55                   	push   %ebp
  102bf2:	89 e5                	mov    %esp,%ebp
  102bf4:	e8 83 d6 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102bf9:	05 57 bd 00 00       	add    $0xbd57,%eax
    gdt_init();
  102bfe:	e8 cd fe ff ff       	call   102ad0 <gdt_init>
}
  102c03:	90                   	nop
  102c04:	5d                   	pop    %ebp
  102c05:	c3                   	ret    

00102c06 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102c06:	55                   	push   %ebp
  102c07:	89 e5                	mov    %esp,%ebp
  102c09:	83 ec 10             	sub    $0x10,%esp
  102c0c:	e8 6b d6 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102c11:	05 3f bd 00 00       	add    $0xbd3f,%eax
    size_t cnt = 0;
  102c16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102c1d:	eb 04                	jmp    102c23 <strlen+0x1d>
        cnt ++;
  102c1f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  102c23:	8b 45 08             	mov    0x8(%ebp),%eax
  102c26:	8d 50 01             	lea    0x1(%eax),%edx
  102c29:	89 55 08             	mov    %edx,0x8(%ebp)
  102c2c:	0f b6 00             	movzbl (%eax),%eax
  102c2f:	84 c0                	test   %al,%al
  102c31:	75 ec                	jne    102c1f <strlen+0x19>
    }
    return cnt;
  102c33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c36:	c9                   	leave  
  102c37:	c3                   	ret    

00102c38 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102c38:	55                   	push   %ebp
  102c39:	89 e5                	mov    %esp,%ebp
  102c3b:	83 ec 10             	sub    $0x10,%esp
  102c3e:	e8 39 d6 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102c43:	05 0d bd 00 00       	add    $0xbd0d,%eax
    size_t cnt = 0;
  102c48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c4f:	eb 04                	jmp    102c55 <strnlen+0x1d>
        cnt ++;
  102c51:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c58:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102c5b:	73 10                	jae    102c6d <strnlen+0x35>
  102c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c60:	8d 50 01             	lea    0x1(%eax),%edx
  102c63:	89 55 08             	mov    %edx,0x8(%ebp)
  102c66:	0f b6 00             	movzbl (%eax),%eax
  102c69:	84 c0                	test   %al,%al
  102c6b:	75 e4                	jne    102c51 <strnlen+0x19>
    }
    return cnt;
  102c6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c70:	c9                   	leave  
  102c71:	c3                   	ret    

00102c72 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102c72:	55                   	push   %ebp
  102c73:	89 e5                	mov    %esp,%ebp
  102c75:	57                   	push   %edi
  102c76:	56                   	push   %esi
  102c77:	83 ec 20             	sub    $0x20,%esp
  102c7a:	e8 fd d5 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102c7f:	05 d1 bc 00 00       	add    $0xbcd1,%eax
  102c84:	8b 45 08             	mov    0x8(%ebp),%eax
  102c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102c90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c96:	89 d1                	mov    %edx,%ecx
  102c98:	89 c2                	mov    %eax,%edx
  102c9a:	89 ce                	mov    %ecx,%esi
  102c9c:	89 d7                	mov    %edx,%edi
  102c9e:	ac                   	lods   %ds:(%esi),%al
  102c9f:	aa                   	stos   %al,%es:(%edi)
  102ca0:	84 c0                	test   %al,%al
  102ca2:	75 fa                	jne    102c9e <strcpy+0x2c>
  102ca4:	89 fa                	mov    %edi,%edx
  102ca6:	89 f1                	mov    %esi,%ecx
  102ca8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102cab:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102cae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102cb4:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102cb5:	83 c4 20             	add    $0x20,%esp
  102cb8:	5e                   	pop    %esi
  102cb9:	5f                   	pop    %edi
  102cba:	5d                   	pop    %ebp
  102cbb:	c3                   	ret    

00102cbc <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102cbc:	55                   	push   %ebp
  102cbd:	89 e5                	mov    %esp,%ebp
  102cbf:	83 ec 10             	sub    $0x10,%esp
  102cc2:	e8 b5 d5 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102cc7:	05 89 bc 00 00       	add    $0xbc89,%eax
    char *p = dst;
  102ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  102ccf:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102cd2:	eb 21                	jmp    102cf5 <strncpy+0x39>
        if ((*p = *src) != '\0') {
  102cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cd7:	0f b6 10             	movzbl (%eax),%edx
  102cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cdd:	88 10                	mov    %dl,(%eax)
  102cdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ce2:	0f b6 00             	movzbl (%eax),%eax
  102ce5:	84 c0                	test   %al,%al
  102ce7:	74 04                	je     102ced <strncpy+0x31>
            src ++;
  102ce9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102ced:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102cf1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  102cf5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cf9:	75 d9                	jne    102cd4 <strncpy+0x18>
    }
    return dst;
  102cfb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102cfe:	c9                   	leave  
  102cff:	c3                   	ret    

00102d00 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102d00:	55                   	push   %ebp
  102d01:	89 e5                	mov    %esp,%ebp
  102d03:	57                   	push   %edi
  102d04:	56                   	push   %esi
  102d05:	83 ec 20             	sub    $0x20,%esp
  102d08:	e8 6f d5 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102d0d:	05 43 bc 00 00       	add    $0xbc43,%eax
  102d12:	8b 45 08             	mov    0x8(%ebp),%eax
  102d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102d1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d24:	89 d1                	mov    %edx,%ecx
  102d26:	89 c2                	mov    %eax,%edx
  102d28:	89 ce                	mov    %ecx,%esi
  102d2a:	89 d7                	mov    %edx,%edi
  102d2c:	ac                   	lods   %ds:(%esi),%al
  102d2d:	ae                   	scas   %es:(%edi),%al
  102d2e:	75 08                	jne    102d38 <strcmp+0x38>
  102d30:	84 c0                	test   %al,%al
  102d32:	75 f8                	jne    102d2c <strcmp+0x2c>
  102d34:	31 c0                	xor    %eax,%eax
  102d36:	eb 04                	jmp    102d3c <strcmp+0x3c>
  102d38:	19 c0                	sbb    %eax,%eax
  102d3a:	0c 01                	or     $0x1,%al
  102d3c:	89 fa                	mov    %edi,%edx
  102d3e:	89 f1                	mov    %esi,%ecx
  102d40:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d43:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d46:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102d4c:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102d4d:	83 c4 20             	add    $0x20,%esp
  102d50:	5e                   	pop    %esi
  102d51:	5f                   	pop    %edi
  102d52:	5d                   	pop    %ebp
  102d53:	c3                   	ret    

00102d54 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102d54:	55                   	push   %ebp
  102d55:	89 e5                	mov    %esp,%ebp
  102d57:	e8 20 d5 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102d5c:	05 f4 bb 00 00       	add    $0xbbf4,%eax
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d61:	eb 0c                	jmp    102d6f <strncmp+0x1b>
        n --, s1 ++, s2 ++;
  102d63:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102d67:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d6b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d73:	74 1a                	je     102d8f <strncmp+0x3b>
  102d75:	8b 45 08             	mov    0x8(%ebp),%eax
  102d78:	0f b6 00             	movzbl (%eax),%eax
  102d7b:	84 c0                	test   %al,%al
  102d7d:	74 10                	je     102d8f <strncmp+0x3b>
  102d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d82:	0f b6 10             	movzbl (%eax),%edx
  102d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d88:	0f b6 00             	movzbl (%eax),%eax
  102d8b:	38 c2                	cmp    %al,%dl
  102d8d:	74 d4                	je     102d63 <strncmp+0xf>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d93:	74 18                	je     102dad <strncmp+0x59>
  102d95:	8b 45 08             	mov    0x8(%ebp),%eax
  102d98:	0f b6 00             	movzbl (%eax),%eax
  102d9b:	0f b6 d0             	movzbl %al,%edx
  102d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102da1:	0f b6 00             	movzbl (%eax),%eax
  102da4:	0f b6 c0             	movzbl %al,%eax
  102da7:	29 c2                	sub    %eax,%edx
  102da9:	89 d0                	mov    %edx,%eax
  102dab:	eb 05                	jmp    102db2 <strncmp+0x5e>
  102dad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102db2:	5d                   	pop    %ebp
  102db3:	c3                   	ret    

00102db4 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102db4:	55                   	push   %ebp
  102db5:	89 e5                	mov    %esp,%ebp
  102db7:	83 ec 04             	sub    $0x4,%esp
  102dba:	e8 bd d4 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102dbf:	05 91 bb 00 00       	add    $0xbb91,%eax
  102dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dc7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102dca:	eb 14                	jmp    102de0 <strchr+0x2c>
        if (*s == c) {
  102dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcf:	0f b6 00             	movzbl (%eax),%eax
  102dd2:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102dd5:	75 05                	jne    102ddc <strchr+0x28>
            return (char *)s;
  102dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dda:	eb 13                	jmp    102def <strchr+0x3b>
        }
        s ++;
  102ddc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102de0:	8b 45 08             	mov    0x8(%ebp),%eax
  102de3:	0f b6 00             	movzbl (%eax),%eax
  102de6:	84 c0                	test   %al,%al
  102de8:	75 e2                	jne    102dcc <strchr+0x18>
    }
    return NULL;
  102dea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102def:	c9                   	leave  
  102df0:	c3                   	ret    

00102df1 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102df1:	55                   	push   %ebp
  102df2:	89 e5                	mov    %esp,%ebp
  102df4:	83 ec 04             	sub    $0x4,%esp
  102df7:	e8 80 d4 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102dfc:	05 54 bb 00 00       	add    $0xbb54,%eax
  102e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e04:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102e07:	eb 0f                	jmp    102e18 <strfind+0x27>
        if (*s == c) {
  102e09:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0c:	0f b6 00             	movzbl (%eax),%eax
  102e0f:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102e12:	74 10                	je     102e24 <strfind+0x33>
            break;
        }
        s ++;
  102e14:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102e18:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1b:	0f b6 00             	movzbl (%eax),%eax
  102e1e:	84 c0                	test   %al,%al
  102e20:	75 e7                	jne    102e09 <strfind+0x18>
  102e22:	eb 01                	jmp    102e25 <strfind+0x34>
            break;
  102e24:	90                   	nop
    }
    return (char *)s;
  102e25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102e28:	c9                   	leave  
  102e29:	c3                   	ret    

00102e2a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102e2a:	55                   	push   %ebp
  102e2b:	89 e5                	mov    %esp,%ebp
  102e2d:	83 ec 10             	sub    $0x10,%esp
  102e30:	e8 47 d4 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102e35:	05 1b bb 00 00       	add    $0xbb1b,%eax
    int neg = 0;
  102e3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102e41:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102e48:	eb 04                	jmp    102e4e <strtol+0x24>
        s ++;
  102e4a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e51:	0f b6 00             	movzbl (%eax),%eax
  102e54:	3c 20                	cmp    $0x20,%al
  102e56:	74 f2                	je     102e4a <strtol+0x20>
  102e58:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5b:	0f b6 00             	movzbl (%eax),%eax
  102e5e:	3c 09                	cmp    $0x9,%al
  102e60:	74 e8                	je     102e4a <strtol+0x20>
    }

    // plus/minus sign
    if (*s == '+') {
  102e62:	8b 45 08             	mov    0x8(%ebp),%eax
  102e65:	0f b6 00             	movzbl (%eax),%eax
  102e68:	3c 2b                	cmp    $0x2b,%al
  102e6a:	75 06                	jne    102e72 <strtol+0x48>
        s ++;
  102e6c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102e70:	eb 15                	jmp    102e87 <strtol+0x5d>
    }
    else if (*s == '-') {
  102e72:	8b 45 08             	mov    0x8(%ebp),%eax
  102e75:	0f b6 00             	movzbl (%eax),%eax
  102e78:	3c 2d                	cmp    $0x2d,%al
  102e7a:	75 0b                	jne    102e87 <strtol+0x5d>
        s ++, neg = 1;
  102e7c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102e80:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102e87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e8b:	74 06                	je     102e93 <strtol+0x69>
  102e8d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102e91:	75 24                	jne    102eb7 <strtol+0x8d>
  102e93:	8b 45 08             	mov    0x8(%ebp),%eax
  102e96:	0f b6 00             	movzbl (%eax),%eax
  102e99:	3c 30                	cmp    $0x30,%al
  102e9b:	75 1a                	jne    102eb7 <strtol+0x8d>
  102e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea0:	83 c0 01             	add    $0x1,%eax
  102ea3:	0f b6 00             	movzbl (%eax),%eax
  102ea6:	3c 78                	cmp    $0x78,%al
  102ea8:	75 0d                	jne    102eb7 <strtol+0x8d>
        s += 2, base = 16;
  102eaa:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102eae:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102eb5:	eb 2a                	jmp    102ee1 <strtol+0xb7>
    }
    else if (base == 0 && s[0] == '0') {
  102eb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ebb:	75 17                	jne    102ed4 <strtol+0xaa>
  102ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec0:	0f b6 00             	movzbl (%eax),%eax
  102ec3:	3c 30                	cmp    $0x30,%al
  102ec5:	75 0d                	jne    102ed4 <strtol+0xaa>
        s ++, base = 8;
  102ec7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ecb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102ed2:	eb 0d                	jmp    102ee1 <strtol+0xb7>
    }
    else if (base == 0) {
  102ed4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ed8:	75 07                	jne    102ee1 <strtol+0xb7>
        base = 10;
  102eda:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee4:	0f b6 00             	movzbl (%eax),%eax
  102ee7:	3c 2f                	cmp    $0x2f,%al
  102ee9:	7e 1b                	jle    102f06 <strtol+0xdc>
  102eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  102eee:	0f b6 00             	movzbl (%eax),%eax
  102ef1:	3c 39                	cmp    $0x39,%al
  102ef3:	7f 11                	jg     102f06 <strtol+0xdc>
            dig = *s - '0';
  102ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef8:	0f b6 00             	movzbl (%eax),%eax
  102efb:	0f be c0             	movsbl %al,%eax
  102efe:	83 e8 30             	sub    $0x30,%eax
  102f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f04:	eb 48                	jmp    102f4e <strtol+0x124>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102f06:	8b 45 08             	mov    0x8(%ebp),%eax
  102f09:	0f b6 00             	movzbl (%eax),%eax
  102f0c:	3c 60                	cmp    $0x60,%al
  102f0e:	7e 1b                	jle    102f2b <strtol+0x101>
  102f10:	8b 45 08             	mov    0x8(%ebp),%eax
  102f13:	0f b6 00             	movzbl (%eax),%eax
  102f16:	3c 7a                	cmp    $0x7a,%al
  102f18:	7f 11                	jg     102f2b <strtol+0x101>
            dig = *s - 'a' + 10;
  102f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f1d:	0f b6 00             	movzbl (%eax),%eax
  102f20:	0f be c0             	movsbl %al,%eax
  102f23:	83 e8 57             	sub    $0x57,%eax
  102f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f29:	eb 23                	jmp    102f4e <strtol+0x124>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f2e:	0f b6 00             	movzbl (%eax),%eax
  102f31:	3c 40                	cmp    $0x40,%al
  102f33:	7e 3c                	jle    102f71 <strtol+0x147>
  102f35:	8b 45 08             	mov    0x8(%ebp),%eax
  102f38:	0f b6 00             	movzbl (%eax),%eax
  102f3b:	3c 5a                	cmp    $0x5a,%al
  102f3d:	7f 32                	jg     102f71 <strtol+0x147>
            dig = *s - 'A' + 10;
  102f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f42:	0f b6 00             	movzbl (%eax),%eax
  102f45:	0f be c0             	movsbl %al,%eax
  102f48:	83 e8 37             	sub    $0x37,%eax
  102f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f51:	3b 45 10             	cmp    0x10(%ebp),%eax
  102f54:	7d 1a                	jge    102f70 <strtol+0x146>
            break;
        }
        s ++, val = (val * base) + dig;
  102f56:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f5d:	0f af 45 10          	imul   0x10(%ebp),%eax
  102f61:	89 c2                	mov    %eax,%edx
  102f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f66:	01 d0                	add    %edx,%eax
  102f68:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102f6b:	e9 71 ff ff ff       	jmp    102ee1 <strtol+0xb7>
            break;
  102f70:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102f71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f75:	74 08                	je     102f7f <strtol+0x155>
        *endptr = (char *) s;
  102f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f7a:	8b 55 08             	mov    0x8(%ebp),%edx
  102f7d:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102f7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102f83:	74 07                	je     102f8c <strtol+0x162>
  102f85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f88:	f7 d8                	neg    %eax
  102f8a:	eb 03                	jmp    102f8f <strtol+0x165>
  102f8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102f8f:	c9                   	leave  
  102f90:	c3                   	ret    

00102f91 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102f91:	55                   	push   %ebp
  102f92:	89 e5                	mov    %esp,%ebp
  102f94:	57                   	push   %edi
  102f95:	83 ec 24             	sub    $0x24,%esp
  102f98:	e8 df d2 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102f9d:	05 b3 b9 00 00       	add    $0xb9b3,%eax
  102fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fa5:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102fa8:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102fac:	8b 55 08             	mov    0x8(%ebp),%edx
  102faf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102fb2:	88 45 f7             	mov    %al,-0x9(%ebp)
  102fb5:	8b 45 10             	mov    0x10(%ebp),%eax
  102fb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102fbb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102fbe:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102fc2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102fc5:	89 d7                	mov    %edx,%edi
  102fc7:	f3 aa                	rep stos %al,%es:(%edi)
  102fc9:	89 fa                	mov    %edi,%edx
  102fcb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102fce:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102fd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102fd4:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102fd5:	83 c4 24             	add    $0x24,%esp
  102fd8:	5f                   	pop    %edi
  102fd9:	5d                   	pop    %ebp
  102fda:	c3                   	ret    

00102fdb <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102fdb:	55                   	push   %ebp
  102fdc:	89 e5                	mov    %esp,%ebp
  102fde:	57                   	push   %edi
  102fdf:	56                   	push   %esi
  102fe0:	53                   	push   %ebx
  102fe1:	83 ec 30             	sub    $0x30,%esp
  102fe4:	e8 93 d2 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102fe9:	05 67 b9 00 00       	add    $0xb967,%eax
  102fee:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ff7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  102ffd:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103000:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103003:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103006:	73 42                	jae    10304a <memmove+0x6f>
  103008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10300b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10300e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103011:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103014:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103017:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10301a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10301d:	c1 e8 02             	shr    $0x2,%eax
  103020:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103022:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103025:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103028:	89 d7                	mov    %edx,%edi
  10302a:	89 c6                	mov    %eax,%esi
  10302c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10302e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103031:	83 e1 03             	and    $0x3,%ecx
  103034:	74 02                	je     103038 <memmove+0x5d>
  103036:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103038:	89 f0                	mov    %esi,%eax
  10303a:	89 fa                	mov    %edi,%edx
  10303c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10303f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103042:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  103045:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  103048:	eb 36                	jmp    103080 <memmove+0xa5>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10304a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10304d:	8d 50 ff             	lea    -0x1(%eax),%edx
  103050:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103053:	01 c2                	add    %eax,%edx
  103055:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103058:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10305b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10305e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  103061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103064:	89 c1                	mov    %eax,%ecx
  103066:	89 d8                	mov    %ebx,%eax
  103068:	89 d6                	mov    %edx,%esi
  10306a:	89 c7                	mov    %eax,%edi
  10306c:	fd                   	std    
  10306d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10306f:	fc                   	cld    
  103070:	89 f8                	mov    %edi,%eax
  103072:	89 f2                	mov    %esi,%edx
  103074:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103077:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10307a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10307d:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103080:	83 c4 30             	add    $0x30,%esp
  103083:	5b                   	pop    %ebx
  103084:	5e                   	pop    %esi
  103085:	5f                   	pop    %edi
  103086:	5d                   	pop    %ebp
  103087:	c3                   	ret    

00103088 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103088:	55                   	push   %ebp
  103089:	89 e5                	mov    %esp,%ebp
  10308b:	57                   	push   %edi
  10308c:	56                   	push   %esi
  10308d:	83 ec 20             	sub    $0x20,%esp
  103090:	e8 e7 d1 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  103095:	05 bb b8 00 00       	add    $0xb8bb,%eax
  10309a:	8b 45 08             	mov    0x8(%ebp),%eax
  10309d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1030a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1030ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030af:	c1 e8 02             	shr    $0x2,%eax
  1030b2:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1030b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030ba:	89 d7                	mov    %edx,%edi
  1030bc:	89 c6                	mov    %eax,%esi
  1030be:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1030c0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1030c3:	83 e1 03             	and    $0x3,%ecx
  1030c6:	74 02                	je     1030ca <memcpy+0x42>
  1030c8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1030ca:	89 f0                	mov    %esi,%eax
  1030cc:	89 fa                	mov    %edi,%edx
  1030ce:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030d1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1030d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1030d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  1030da:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1030db:	83 c4 20             	add    $0x20,%esp
  1030de:	5e                   	pop    %esi
  1030df:	5f                   	pop    %edi
  1030e0:	5d                   	pop    %ebp
  1030e1:	c3                   	ret    

001030e2 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1030e2:	55                   	push   %ebp
  1030e3:	89 e5                	mov    %esp,%ebp
  1030e5:	83 ec 10             	sub    $0x10,%esp
  1030e8:	e8 8f d1 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1030ed:	05 63 b8 00 00       	add    $0xb863,%eax
    const char *s1 = (const char *)v1;
  1030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1030f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1030fe:	eb 30                	jmp    103130 <memcmp+0x4e>
        if (*s1 != *s2) {
  103100:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103103:	0f b6 10             	movzbl (%eax),%edx
  103106:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103109:	0f b6 00             	movzbl (%eax),%eax
  10310c:	38 c2                	cmp    %al,%dl
  10310e:	74 18                	je     103128 <memcmp+0x46>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103110:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103113:	0f b6 00             	movzbl (%eax),%eax
  103116:	0f b6 d0             	movzbl %al,%edx
  103119:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10311c:	0f b6 00             	movzbl (%eax),%eax
  10311f:	0f b6 c0             	movzbl %al,%eax
  103122:	29 c2                	sub    %eax,%edx
  103124:	89 d0                	mov    %edx,%eax
  103126:	eb 1a                	jmp    103142 <memcmp+0x60>
        }
        s1 ++, s2 ++;
  103128:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10312c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  103130:	8b 45 10             	mov    0x10(%ebp),%eax
  103133:	8d 50 ff             	lea    -0x1(%eax),%edx
  103136:	89 55 10             	mov    %edx,0x10(%ebp)
  103139:	85 c0                	test   %eax,%eax
  10313b:	75 c3                	jne    103100 <memcmp+0x1e>
    }
    return 0;
  10313d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103142:	c9                   	leave  
  103143:	c3                   	ret    

00103144 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  103144:	55                   	push   %ebp
  103145:	89 e5                	mov    %esp,%ebp
  103147:	53                   	push   %ebx
  103148:	83 ec 34             	sub    $0x34,%esp
  10314b:	e8 30 d1 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  103150:	81 c3 00 b8 00 00    	add    $0xb800,%ebx
  103156:	8b 45 10             	mov    0x10(%ebp),%eax
  103159:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10315c:	8b 45 14             	mov    0x14(%ebp),%eax
  10315f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  103162:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103165:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103168:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10316b:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10316e:	8b 45 18             	mov    0x18(%ebp),%eax
  103171:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103174:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103177:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10317a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10317d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103186:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10318a:	74 1c                	je     1031a8 <printnum+0x64>
  10318c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10318f:	ba 00 00 00 00       	mov    $0x0,%edx
  103194:	f7 75 e4             	divl   -0x1c(%ebp)
  103197:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10319a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10319d:	ba 00 00 00 00       	mov    $0x0,%edx
  1031a2:	f7 75 e4             	divl   -0x1c(%ebp)
  1031a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031ae:	f7 75 e4             	divl   -0x1c(%ebp)
  1031b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1031b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1031b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1031bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031c0:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1031c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1031c6:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1031c9:	8b 45 18             	mov    0x18(%ebp),%eax
  1031cc:	ba 00 00 00 00       	mov    $0x0,%edx
  1031d1:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  1031d4:	72 41                	jb     103217 <printnum+0xd3>
  1031d6:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  1031d9:	77 05                	ja     1031e0 <printnum+0x9c>
  1031db:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1031de:	72 37                	jb     103217 <printnum+0xd3>
        printnum(putch, putdat, result, base, width - 1, padc);
  1031e0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1031e3:	83 e8 01             	sub    $0x1,%eax
  1031e6:	83 ec 04             	sub    $0x4,%esp
  1031e9:	ff 75 20             	pushl  0x20(%ebp)
  1031ec:	50                   	push   %eax
  1031ed:	ff 75 18             	pushl  0x18(%ebp)
  1031f0:	ff 75 ec             	pushl  -0x14(%ebp)
  1031f3:	ff 75 e8             	pushl  -0x18(%ebp)
  1031f6:	ff 75 0c             	pushl  0xc(%ebp)
  1031f9:	ff 75 08             	pushl  0x8(%ebp)
  1031fc:	e8 43 ff ff ff       	call   103144 <printnum>
  103201:	83 c4 20             	add    $0x20,%esp
  103204:	eb 1b                	jmp    103221 <printnum+0xdd>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  103206:	83 ec 08             	sub    $0x8,%esp
  103209:	ff 75 0c             	pushl  0xc(%ebp)
  10320c:	ff 75 20             	pushl  0x20(%ebp)
  10320f:	8b 45 08             	mov    0x8(%ebp),%eax
  103212:	ff d0                	call   *%eax
  103214:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  103217:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10321b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10321f:	7f e5                	jg     103206 <printnum+0xc2>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103221:	8d 93 7e 55 ff ff    	lea    -0xaa82(%ebx),%edx
  103227:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10322a:	01 d0                	add    %edx,%eax
  10322c:	0f b6 00             	movzbl (%eax),%eax
  10322f:	0f be c0             	movsbl %al,%eax
  103232:	83 ec 08             	sub    $0x8,%esp
  103235:	ff 75 0c             	pushl  0xc(%ebp)
  103238:	50                   	push   %eax
  103239:	8b 45 08             	mov    0x8(%ebp),%eax
  10323c:	ff d0                	call   *%eax
  10323e:	83 c4 10             	add    $0x10,%esp
}
  103241:	90                   	nop
  103242:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  103245:	c9                   	leave  
  103246:	c3                   	ret    

00103247 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103247:	55                   	push   %ebp
  103248:	89 e5                	mov    %esp,%ebp
  10324a:	e8 2d d0 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10324f:	05 01 b7 00 00       	add    $0xb701,%eax
    if (lflag >= 2) {
  103254:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103258:	7e 14                	jle    10326e <getuint+0x27>
        return va_arg(*ap, unsigned long long);
  10325a:	8b 45 08             	mov    0x8(%ebp),%eax
  10325d:	8b 00                	mov    (%eax),%eax
  10325f:	8d 48 08             	lea    0x8(%eax),%ecx
  103262:	8b 55 08             	mov    0x8(%ebp),%edx
  103265:	89 0a                	mov    %ecx,(%edx)
  103267:	8b 50 04             	mov    0x4(%eax),%edx
  10326a:	8b 00                	mov    (%eax),%eax
  10326c:	eb 30                	jmp    10329e <getuint+0x57>
    }
    else if (lflag) {
  10326e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103272:	74 16                	je     10328a <getuint+0x43>
        return va_arg(*ap, unsigned long);
  103274:	8b 45 08             	mov    0x8(%ebp),%eax
  103277:	8b 00                	mov    (%eax),%eax
  103279:	8d 48 04             	lea    0x4(%eax),%ecx
  10327c:	8b 55 08             	mov    0x8(%ebp),%edx
  10327f:	89 0a                	mov    %ecx,(%edx)
  103281:	8b 00                	mov    (%eax),%eax
  103283:	ba 00 00 00 00       	mov    $0x0,%edx
  103288:	eb 14                	jmp    10329e <getuint+0x57>
    }
    else {
        return va_arg(*ap, unsigned int);
  10328a:	8b 45 08             	mov    0x8(%ebp),%eax
  10328d:	8b 00                	mov    (%eax),%eax
  10328f:	8d 48 04             	lea    0x4(%eax),%ecx
  103292:	8b 55 08             	mov    0x8(%ebp),%edx
  103295:	89 0a                	mov    %ecx,(%edx)
  103297:	8b 00                	mov    (%eax),%eax
  103299:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10329e:	5d                   	pop    %ebp
  10329f:	c3                   	ret    

001032a0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1032a0:	55                   	push   %ebp
  1032a1:	89 e5                	mov    %esp,%ebp
  1032a3:	e8 d4 cf ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1032a8:	05 a8 b6 00 00       	add    $0xb6a8,%eax
    if (lflag >= 2) {
  1032ad:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1032b1:	7e 14                	jle    1032c7 <getint+0x27>
        return va_arg(*ap, long long);
  1032b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b6:	8b 00                	mov    (%eax),%eax
  1032b8:	8d 48 08             	lea    0x8(%eax),%ecx
  1032bb:	8b 55 08             	mov    0x8(%ebp),%edx
  1032be:	89 0a                	mov    %ecx,(%edx)
  1032c0:	8b 50 04             	mov    0x4(%eax),%edx
  1032c3:	8b 00                	mov    (%eax),%eax
  1032c5:	eb 28                	jmp    1032ef <getint+0x4f>
    }
    else if (lflag) {
  1032c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032cb:	74 12                	je     1032df <getint+0x3f>
        return va_arg(*ap, long);
  1032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d0:	8b 00                	mov    (%eax),%eax
  1032d2:	8d 48 04             	lea    0x4(%eax),%ecx
  1032d5:	8b 55 08             	mov    0x8(%ebp),%edx
  1032d8:	89 0a                	mov    %ecx,(%edx)
  1032da:	8b 00                	mov    (%eax),%eax
  1032dc:	99                   	cltd   
  1032dd:	eb 10                	jmp    1032ef <getint+0x4f>
    }
    else {
        return va_arg(*ap, int);
  1032df:	8b 45 08             	mov    0x8(%ebp),%eax
  1032e2:	8b 00                	mov    (%eax),%eax
  1032e4:	8d 48 04             	lea    0x4(%eax),%ecx
  1032e7:	8b 55 08             	mov    0x8(%ebp),%edx
  1032ea:	89 0a                	mov    %ecx,(%edx)
  1032ec:	8b 00                	mov    (%eax),%eax
  1032ee:	99                   	cltd   
    }
}
  1032ef:	5d                   	pop    %ebp
  1032f0:	c3                   	ret    

001032f1 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1032f1:	55                   	push   %ebp
  1032f2:	89 e5                	mov    %esp,%ebp
  1032f4:	83 ec 18             	sub    $0x18,%esp
  1032f7:	e8 80 cf ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1032fc:	05 54 b6 00 00       	add    $0xb654,%eax
    va_list ap;

    va_start(ap, fmt);
  103301:	8d 45 14             	lea    0x14(%ebp),%eax
  103304:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  103307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10330a:	50                   	push   %eax
  10330b:	ff 75 10             	pushl  0x10(%ebp)
  10330e:	ff 75 0c             	pushl  0xc(%ebp)
  103311:	ff 75 08             	pushl  0x8(%ebp)
  103314:	e8 06 00 00 00       	call   10331f <vprintfmt>
  103319:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10331c:	90                   	nop
  10331d:	c9                   	leave  
  10331e:	c3                   	ret    

0010331f <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10331f:	55                   	push   %ebp
  103320:	89 e5                	mov    %esp,%ebp
  103322:	57                   	push   %edi
  103323:	56                   	push   %esi
  103324:	53                   	push   %ebx
  103325:	83 ec 2c             	sub    $0x2c,%esp
  103328:	e8 8c 04 00 00       	call   1037b9 <__x86.get_pc_thunk.di>
  10332d:	81 c7 23 b6 00 00    	add    $0xb623,%edi
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103333:	eb 17                	jmp    10334c <vprintfmt+0x2d>
            if (ch == '\0') {
  103335:	85 db                	test   %ebx,%ebx
  103337:	0f 84 9a 03 00 00    	je     1036d7 <.L24+0x2d>
                return;
            }
            putch(ch, putdat);
  10333d:	83 ec 08             	sub    $0x8,%esp
  103340:	ff 75 0c             	pushl  0xc(%ebp)
  103343:	53                   	push   %ebx
  103344:	8b 45 08             	mov    0x8(%ebp),%eax
  103347:	ff d0                	call   *%eax
  103349:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10334c:	8b 45 10             	mov    0x10(%ebp),%eax
  10334f:	8d 50 01             	lea    0x1(%eax),%edx
  103352:	89 55 10             	mov    %edx,0x10(%ebp)
  103355:	0f b6 00             	movzbl (%eax),%eax
  103358:	0f b6 d8             	movzbl %al,%ebx
  10335b:	83 fb 25             	cmp    $0x25,%ebx
  10335e:	75 d5                	jne    103335 <vprintfmt+0x16>
        }

        // Process a %-escape sequence
        char padc = ' ';
  103360:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
        width = precision = -1;
  103364:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  10336b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10336e:	89 45 d8             	mov    %eax,-0x28(%ebp)
        lflag = altflag = 0;
  103371:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  103378:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10337b:	89 45 d0             	mov    %eax,-0x30(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10337e:	8b 45 10             	mov    0x10(%ebp),%eax
  103381:	8d 50 01             	lea    0x1(%eax),%edx
  103384:	89 55 10             	mov    %edx,0x10(%ebp)
  103387:	0f b6 00             	movzbl (%eax),%eax
  10338a:	0f b6 d8             	movzbl %al,%ebx
  10338d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103390:	83 f8 55             	cmp    $0x55,%eax
  103393:	0f 87 11 03 00 00    	ja     1036aa <.L24>
  103399:	c1 e0 02             	shl    $0x2,%eax
  10339c:	8b 84 38 a4 55 ff ff 	mov    -0xaa5c(%eax,%edi,1),%eax
  1033a3:	01 f8                	add    %edi,%eax
  1033a5:	ff e0                	jmp    *%eax

001033a7 <.L29>:

        // flag to pad on the right
        case '-':
            padc = '-';
  1033a7:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
            goto reswitch;
  1033ab:	eb d1                	jmp    10337e <vprintfmt+0x5f>

001033ad <.L31>:

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1033ad:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
            goto reswitch;
  1033b1:	eb cb                	jmp    10337e <vprintfmt+0x5f>

001033b3 <.L32>:

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1033b3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
                precision = precision * 10 + ch - '0';
  1033ba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1033bd:	89 d0                	mov    %edx,%eax
  1033bf:	c1 e0 02             	shl    $0x2,%eax
  1033c2:	01 d0                	add    %edx,%eax
  1033c4:	01 c0                	add    %eax,%eax
  1033c6:	01 d8                	add    %ebx,%eax
  1033c8:	83 e8 30             	sub    $0x30,%eax
  1033cb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
                ch = *fmt;
  1033ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1033d1:	0f b6 00             	movzbl (%eax),%eax
  1033d4:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1033d7:	83 fb 2f             	cmp    $0x2f,%ebx
  1033da:	7e 39                	jle    103415 <.L25+0xc>
  1033dc:	83 fb 39             	cmp    $0x39,%ebx
  1033df:	7f 34                	jg     103415 <.L25+0xc>
            for (precision = 0; ; ++ fmt) {
  1033e1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1033e5:	eb d3                	jmp    1033ba <.L32+0x7>

001033e7 <.L28>:
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1033e7:	8b 45 14             	mov    0x14(%ebp),%eax
  1033ea:	8d 50 04             	lea    0x4(%eax),%edx
  1033ed:	89 55 14             	mov    %edx,0x14(%ebp)
  1033f0:	8b 00                	mov    (%eax),%eax
  1033f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            goto process_precision;
  1033f5:	eb 1f                	jmp    103416 <.L25+0xd>

001033f7 <.L30>:

        case '.':
            if (width < 0)
  1033f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1033fb:	79 81                	jns    10337e <vprintfmt+0x5f>
                width = 0;
  1033fd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
            goto reswitch;
  103404:	e9 75 ff ff ff       	jmp    10337e <vprintfmt+0x5f>

00103409 <.L25>:

        case '#':
            altflag = 1;
  103409:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
            goto reswitch;
  103410:	e9 69 ff ff ff       	jmp    10337e <vprintfmt+0x5f>
            goto process_precision;
  103415:	90                   	nop

        process_precision:
            if (width < 0)
  103416:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  10341a:	0f 89 5e ff ff ff    	jns    10337e <vprintfmt+0x5f>
                width = precision, precision = -1;
  103420:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103423:	89 45 d8             	mov    %eax,-0x28(%ebp)
  103426:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
            goto reswitch;
  10342d:	e9 4c ff ff ff       	jmp    10337e <vprintfmt+0x5f>

00103432 <.L36>:

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  103432:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
            goto reswitch;
  103436:	e9 43 ff ff ff       	jmp    10337e <vprintfmt+0x5f>

0010343b <.L33>:

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10343b:	8b 45 14             	mov    0x14(%ebp),%eax
  10343e:	8d 50 04             	lea    0x4(%eax),%edx
  103441:	89 55 14             	mov    %edx,0x14(%ebp)
  103444:	8b 00                	mov    (%eax),%eax
  103446:	83 ec 08             	sub    $0x8,%esp
  103449:	ff 75 0c             	pushl  0xc(%ebp)
  10344c:	50                   	push   %eax
  10344d:	8b 45 08             	mov    0x8(%ebp),%eax
  103450:	ff d0                	call   *%eax
  103452:	83 c4 10             	add    $0x10,%esp
            break;
  103455:	e9 78 02 00 00       	jmp    1036d2 <.L24+0x28>

0010345a <.L35>:

        // error message
        case 'e':
            err = va_arg(ap, int);
  10345a:	8b 45 14             	mov    0x14(%ebp),%eax
  10345d:	8d 50 04             	lea    0x4(%eax),%edx
  103460:	89 55 14             	mov    %edx,0x14(%ebp)
  103463:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103465:	85 db                	test   %ebx,%ebx
  103467:	79 02                	jns    10346b <.L35+0x11>
                err = -err;
  103469:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10346b:	83 fb 06             	cmp    $0x6,%ebx
  10346e:	7f 0b                	jg     10347b <.L35+0x21>
  103470:	8b b4 9f 40 01 00 00 	mov    0x140(%edi,%ebx,4),%esi
  103477:	85 f6                	test   %esi,%esi
  103479:	75 1b                	jne    103496 <.L35+0x3c>
                printfmt(putch, putdat, "error %d", err);
  10347b:	53                   	push   %ebx
  10347c:	8d 87 8f 55 ff ff    	lea    -0xaa71(%edi),%eax
  103482:	50                   	push   %eax
  103483:	ff 75 0c             	pushl  0xc(%ebp)
  103486:	ff 75 08             	pushl  0x8(%ebp)
  103489:	e8 63 fe ff ff       	call   1032f1 <printfmt>
  10348e:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103491:	e9 3c 02 00 00       	jmp    1036d2 <.L24+0x28>
                printfmt(putch, putdat, "%s", p);
  103496:	56                   	push   %esi
  103497:	8d 87 98 55 ff ff    	lea    -0xaa68(%edi),%eax
  10349d:	50                   	push   %eax
  10349e:	ff 75 0c             	pushl  0xc(%ebp)
  1034a1:	ff 75 08             	pushl  0x8(%ebp)
  1034a4:	e8 48 fe ff ff       	call   1032f1 <printfmt>
  1034a9:	83 c4 10             	add    $0x10,%esp
            break;
  1034ac:	e9 21 02 00 00       	jmp    1036d2 <.L24+0x28>

001034b1 <.L39>:

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1034b1:	8b 45 14             	mov    0x14(%ebp),%eax
  1034b4:	8d 50 04             	lea    0x4(%eax),%edx
  1034b7:	89 55 14             	mov    %edx,0x14(%ebp)
  1034ba:	8b 30                	mov    (%eax),%esi
  1034bc:	85 f6                	test   %esi,%esi
  1034be:	75 06                	jne    1034c6 <.L39+0x15>
                p = "(null)";
  1034c0:	8d b7 9b 55 ff ff    	lea    -0xaa65(%edi),%esi
            }
            if (width > 0 && padc != '-') {
  1034c6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1034ca:	7e 78                	jle    103544 <.L39+0x93>
  1034cc:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  1034d0:	74 72                	je     103544 <.L39+0x93>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1034d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1034d5:	83 ec 08             	sub    $0x8,%esp
  1034d8:	50                   	push   %eax
  1034d9:	56                   	push   %esi
  1034da:	89 fb                	mov    %edi,%ebx
  1034dc:	e8 57 f7 ff ff       	call   102c38 <strnlen>
  1034e1:	83 c4 10             	add    $0x10,%esp
  1034e4:	89 c2                	mov    %eax,%edx
  1034e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1034e9:	29 d0                	sub    %edx,%eax
  1034eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1034ee:	eb 17                	jmp    103507 <.L39+0x56>
                    putch(padc, putdat);
  1034f0:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  1034f4:	83 ec 08             	sub    $0x8,%esp
  1034f7:	ff 75 0c             	pushl  0xc(%ebp)
  1034fa:	50                   	push   %eax
  1034fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1034fe:	ff d0                	call   *%eax
  103500:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  103503:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  103507:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  10350b:	7f e3                	jg     1034f0 <.L39+0x3f>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10350d:	eb 35                	jmp    103544 <.L39+0x93>
                if (altflag && (ch < ' ' || ch > '~')) {
  10350f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103513:	74 1c                	je     103531 <.L39+0x80>
  103515:	83 fb 1f             	cmp    $0x1f,%ebx
  103518:	7e 05                	jle    10351f <.L39+0x6e>
  10351a:	83 fb 7e             	cmp    $0x7e,%ebx
  10351d:	7e 12                	jle    103531 <.L39+0x80>
                    putch('?', putdat);
  10351f:	83 ec 08             	sub    $0x8,%esp
  103522:	ff 75 0c             	pushl  0xc(%ebp)
  103525:	6a 3f                	push   $0x3f
  103527:	8b 45 08             	mov    0x8(%ebp),%eax
  10352a:	ff d0                	call   *%eax
  10352c:	83 c4 10             	add    $0x10,%esp
  10352f:	eb 0f                	jmp    103540 <.L39+0x8f>
                }
                else {
                    putch(ch, putdat);
  103531:	83 ec 08             	sub    $0x8,%esp
  103534:	ff 75 0c             	pushl  0xc(%ebp)
  103537:	53                   	push   %ebx
  103538:	8b 45 08             	mov    0x8(%ebp),%eax
  10353b:	ff d0                	call   *%eax
  10353d:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103540:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  103544:	89 f0                	mov    %esi,%eax
  103546:	8d 70 01             	lea    0x1(%eax),%esi
  103549:	0f b6 00             	movzbl (%eax),%eax
  10354c:	0f be d8             	movsbl %al,%ebx
  10354f:	85 db                	test   %ebx,%ebx
  103551:	74 26                	je     103579 <.L39+0xc8>
  103553:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  103557:	78 b6                	js     10350f <.L39+0x5e>
  103559:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  10355d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  103561:	79 ac                	jns    10350f <.L39+0x5e>
                }
            }
            for (; width > 0; width --) {
  103563:	eb 14                	jmp    103579 <.L39+0xc8>
                putch(' ', putdat);
  103565:	83 ec 08             	sub    $0x8,%esp
  103568:	ff 75 0c             	pushl  0xc(%ebp)
  10356b:	6a 20                	push   $0x20
  10356d:	8b 45 08             	mov    0x8(%ebp),%eax
  103570:	ff d0                	call   *%eax
  103572:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  103575:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  103579:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  10357d:	7f e6                	jg     103565 <.L39+0xb4>
            }
            break;
  10357f:	e9 4e 01 00 00       	jmp    1036d2 <.L24+0x28>

00103584 <.L34>:

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103584:	83 ec 08             	sub    $0x8,%esp
  103587:	ff 75 d0             	pushl  -0x30(%ebp)
  10358a:	8d 45 14             	lea    0x14(%ebp),%eax
  10358d:	50                   	push   %eax
  10358e:	e8 0d fd ff ff       	call   1032a0 <getint>
  103593:	83 c4 10             	add    $0x10,%esp
  103596:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103599:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            if ((long long)num < 0) {
  10359c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10359f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1035a2:	85 d2                	test   %edx,%edx
  1035a4:	79 23                	jns    1035c9 <.L34+0x45>
                putch('-', putdat);
  1035a6:	83 ec 08             	sub    $0x8,%esp
  1035a9:	ff 75 0c             	pushl  0xc(%ebp)
  1035ac:	6a 2d                	push   $0x2d
  1035ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1035b1:	ff d0                	call   *%eax
  1035b3:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  1035b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1035bc:	f7 d8                	neg    %eax
  1035be:	83 d2 00             	adc    $0x0,%edx
  1035c1:	f7 da                	neg    %edx
  1035c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1035c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            }
            base = 10;
  1035c9:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
  1035d0:	e9 9f 00 00 00       	jmp    103674 <.L41+0x1f>

001035d5 <.L40>:

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1035d5:	83 ec 08             	sub    $0x8,%esp
  1035d8:	ff 75 d0             	pushl  -0x30(%ebp)
  1035db:	8d 45 14             	lea    0x14(%ebp),%eax
  1035de:	50                   	push   %eax
  1035df:	e8 63 fc ff ff       	call   103247 <getuint>
  1035e4:	83 c4 10             	add    $0x10,%esp
  1035e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1035ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 10;
  1035ed:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
  1035f4:	eb 7e                	jmp    103674 <.L41+0x1f>

001035f6 <.L37>:

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1035f6:	83 ec 08             	sub    $0x8,%esp
  1035f9:	ff 75 d0             	pushl  -0x30(%ebp)
  1035fc:	8d 45 14             	lea    0x14(%ebp),%eax
  1035ff:	50                   	push   %eax
  103600:	e8 42 fc ff ff       	call   103247 <getuint>
  103605:	83 c4 10             	add    $0x10,%esp
  103608:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10360b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 8;
  10360e:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
            goto number;
  103615:	eb 5d                	jmp    103674 <.L41+0x1f>

00103617 <.L38>:

        // pointer
        case 'p':
            putch('0', putdat);
  103617:	83 ec 08             	sub    $0x8,%esp
  10361a:	ff 75 0c             	pushl  0xc(%ebp)
  10361d:	6a 30                	push   $0x30
  10361f:	8b 45 08             	mov    0x8(%ebp),%eax
  103622:	ff d0                	call   *%eax
  103624:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  103627:	83 ec 08             	sub    $0x8,%esp
  10362a:	ff 75 0c             	pushl  0xc(%ebp)
  10362d:	6a 78                	push   $0x78
  10362f:	8b 45 08             	mov    0x8(%ebp),%eax
  103632:	ff d0                	call   *%eax
  103634:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  103637:	8b 45 14             	mov    0x14(%ebp),%eax
  10363a:	8d 50 04             	lea    0x4(%eax),%edx
  10363d:	89 55 14             	mov    %edx,0x14(%ebp)
  103640:	8b 00                	mov    (%eax),%eax
  103642:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103645:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            base = 16;
  10364c:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
            goto number;
  103653:	eb 1f                	jmp    103674 <.L41+0x1f>

00103655 <.L41>:

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103655:	83 ec 08             	sub    $0x8,%esp
  103658:	ff 75 d0             	pushl  -0x30(%ebp)
  10365b:	8d 45 14             	lea    0x14(%ebp),%eax
  10365e:	50                   	push   %eax
  10365f:	e8 e3 fb ff ff       	call   103247 <getuint>
  103664:	83 c4 10             	add    $0x10,%esp
  103667:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10366a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 16;
  10366d:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103674:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  103678:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10367b:	83 ec 04             	sub    $0x4,%esp
  10367e:	52                   	push   %edx
  10367f:	ff 75 d8             	pushl  -0x28(%ebp)
  103682:	50                   	push   %eax
  103683:	ff 75 e4             	pushl  -0x1c(%ebp)
  103686:	ff 75 e0             	pushl  -0x20(%ebp)
  103689:	ff 75 0c             	pushl  0xc(%ebp)
  10368c:	ff 75 08             	pushl  0x8(%ebp)
  10368f:	e8 b0 fa ff ff       	call   103144 <printnum>
  103694:	83 c4 20             	add    $0x20,%esp
            break;
  103697:	eb 39                	jmp    1036d2 <.L24+0x28>

00103699 <.L27>:

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103699:	83 ec 08             	sub    $0x8,%esp
  10369c:	ff 75 0c             	pushl  0xc(%ebp)
  10369f:	53                   	push   %ebx
  1036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1036a3:	ff d0                	call   *%eax
  1036a5:	83 c4 10             	add    $0x10,%esp
            break;
  1036a8:	eb 28                	jmp    1036d2 <.L24+0x28>

001036aa <.L24>:

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1036aa:	83 ec 08             	sub    $0x8,%esp
  1036ad:	ff 75 0c             	pushl  0xc(%ebp)
  1036b0:	6a 25                	push   $0x25
  1036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1036b5:	ff d0                	call   *%eax
  1036b7:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  1036ba:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1036be:	eb 04                	jmp    1036c4 <.L24+0x1a>
  1036c0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1036c4:	8b 45 10             	mov    0x10(%ebp),%eax
  1036c7:	83 e8 01             	sub    $0x1,%eax
  1036ca:	0f b6 00             	movzbl (%eax),%eax
  1036cd:	3c 25                	cmp    $0x25,%al
  1036cf:	75 ef                	jne    1036c0 <.L24+0x16>
                /* do nothing */;
            break;
  1036d1:	90                   	nop
    while (1) {
  1036d2:	e9 5c fc ff ff       	jmp    103333 <vprintfmt+0x14>
                return;
  1036d7:	90                   	nop
        }
    }
}
  1036d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1036db:	5b                   	pop    %ebx
  1036dc:	5e                   	pop    %esi
  1036dd:	5f                   	pop    %edi
  1036de:	5d                   	pop    %ebp
  1036df:	c3                   	ret    

001036e0 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1036e0:	55                   	push   %ebp
  1036e1:	89 e5                	mov    %esp,%ebp
  1036e3:	e8 94 cb ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1036e8:	05 68 b2 00 00       	add    $0xb268,%eax
    b->cnt ++;
  1036ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036f0:	8b 40 08             	mov    0x8(%eax),%eax
  1036f3:	8d 50 01             	lea    0x1(%eax),%edx
  1036f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036f9:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1036fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036ff:	8b 10                	mov    (%eax),%edx
  103701:	8b 45 0c             	mov    0xc(%ebp),%eax
  103704:	8b 40 04             	mov    0x4(%eax),%eax
  103707:	39 c2                	cmp    %eax,%edx
  103709:	73 12                	jae    10371d <sprintputch+0x3d>
        *b->buf ++ = ch;
  10370b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10370e:	8b 00                	mov    (%eax),%eax
  103710:	8d 48 01             	lea    0x1(%eax),%ecx
  103713:	8b 55 0c             	mov    0xc(%ebp),%edx
  103716:	89 0a                	mov    %ecx,(%edx)
  103718:	8b 55 08             	mov    0x8(%ebp),%edx
  10371b:	88 10                	mov    %dl,(%eax)
    }
}
  10371d:	90                   	nop
  10371e:	5d                   	pop    %ebp
  10371f:	c3                   	ret    

00103720 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103720:	55                   	push   %ebp
  103721:	89 e5                	mov    %esp,%ebp
  103723:	83 ec 18             	sub    $0x18,%esp
  103726:	e8 51 cb ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10372b:	05 25 b2 00 00       	add    $0xb225,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103730:	8d 45 14             	lea    0x14(%ebp),%eax
  103733:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103739:	50                   	push   %eax
  10373a:	ff 75 10             	pushl  0x10(%ebp)
  10373d:	ff 75 0c             	pushl  0xc(%ebp)
  103740:	ff 75 08             	pushl  0x8(%ebp)
  103743:	e8 0b 00 00 00       	call   103753 <vsnprintf>
  103748:	83 c4 10             	add    $0x10,%esp
  10374b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10374e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103751:	c9                   	leave  
  103752:	c3                   	ret    

00103753 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103753:	55                   	push   %ebp
  103754:	89 e5                	mov    %esp,%ebp
  103756:	83 ec 18             	sub    $0x18,%esp
  103759:	e8 1e cb ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10375e:	05 f2 b1 00 00       	add    $0xb1f2,%eax
    struct sprintbuf b = {str, str + size - 1, 0};
  103763:	8b 55 08             	mov    0x8(%ebp),%edx
  103766:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103769:	8b 55 0c             	mov    0xc(%ebp),%edx
  10376c:	8d 4a ff             	lea    -0x1(%edx),%ecx
  10376f:	8b 55 08             	mov    0x8(%ebp),%edx
  103772:	01 ca                	add    %ecx,%edx
  103774:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10377e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103782:	74 0a                	je     10378e <vsnprintf+0x3b>
  103784:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103787:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10378a:	39 d1                	cmp    %edx,%ecx
  10378c:	76 07                	jbe    103795 <vsnprintf+0x42>
        return -E_INVAL;
  10378e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103793:	eb 22                	jmp    1037b7 <vsnprintf+0x64>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103795:	ff 75 14             	pushl  0x14(%ebp)
  103798:	ff 75 10             	pushl  0x10(%ebp)
  10379b:	8d 55 ec             	lea    -0x14(%ebp),%edx
  10379e:	52                   	push   %edx
  10379f:	8d 80 90 4d ff ff    	lea    -0xb270(%eax),%eax
  1037a5:	50                   	push   %eax
  1037a6:	e8 74 fb ff ff       	call   10331f <vprintfmt>
  1037ab:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  1037ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037b1:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1037b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1037b7:	c9                   	leave  
  1037b8:	c3                   	ret    

001037b9 <__x86.get_pc_thunk.di>:
  1037b9:	8b 3c 24             	mov    (%esp),%edi
  1037bc:	c3                   	ret    
