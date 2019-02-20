
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 90 11 40       	mov    $0x40119000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 90 11 00       	mov    %eax,0x119000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 80 11 00       	mov    $0x118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	53                   	push   %ebx
  10003a:	83 ec 14             	sub    $0x14,%esp
  10003d:	e8 74 02 00 00       	call   1002b6 <__x86.get_pc_thunk.bx>
  100042:	81 c3 be af 01 00    	add    $0x1afbe,%ebx
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100048:	c7 c0 28 c1 11 00    	mov    $0x11c128,%eax
  10004e:	89 c2                	mov    %eax,%edx
  100050:	c7 c0 50 89 11 00    	mov    $0x118950,%eax
  100056:	29 c2                	sub    %eax,%edx
  100058:	89 d0                	mov    %edx,%eax
  10005a:	83 ec 04             	sub    $0x4,%esp
  10005d:	50                   	push   %eax
  10005e:	6a 00                	push   $0x0
  100060:	c7 c0 50 89 11 00    	mov    $0x118950,%eax
  100066:	50                   	push   %eax
  100067:	e8 48 5e 00 00       	call   105eb4 <memset>
  10006c:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  10006f:	e8 96 18 00 00       	call   10190a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100074:	8d 83 e0 b6 fe ff    	lea    -0x14920(%ebx),%eax
  10007a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10007d:	83 ec 08             	sub    $0x8,%esp
  100080:	ff 75 f4             	pushl  -0xc(%ebp)
  100083:	8d 83 fc b6 fe ff    	lea    -0x14904(%ebx),%eax
  100089:	50                   	push   %eax
  10008a:	e8 9a 02 00 00       	call   100329 <cprintf>
  10008f:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100092:	e8 d1 09 00 00       	call   100a68 <print_kerninfo>

    grade_backtrace();
  100097:	e8 98 00 00 00       	call   100134 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10009c:	e8 14 38 00 00       	call   1038b5 <pmm_init>

    pic_init();                 // init interrupt controller
  1000a1:	e8 21 1a 00 00       	call   101ac7 <pic_init>
    idt_init();                 // init interrupt descriptor table
  1000a6:	e8 b3 1b 00 00       	call   101c5e <idt_init>

    clock_init();               // init clock interrupt
  1000ab:	e8 f5 0e 00 00       	call   100fa5 <clock_init>
    intr_enable();              // enable irq interrupt
  1000b0:	e8 5a 1b 00 00       	call   101c0f <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000b5:	eb fe                	jmp    1000b5 <kern_init+0x7f>

001000b7 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000b7:	55                   	push   %ebp
  1000b8:	89 e5                	mov    %esp,%ebp
  1000ba:	53                   	push   %ebx
  1000bb:	83 ec 04             	sub    $0x4,%esp
  1000be:	e8 ef 01 00 00       	call   1002b2 <__x86.get_pc_thunk.ax>
  1000c3:	05 3d af 01 00       	add    $0x1af3d,%eax
    mon_backtrace(0, NULL, NULL);
  1000c8:	83 ec 04             	sub    $0x4,%esp
  1000cb:	6a 00                	push   $0x0
  1000cd:	6a 00                	push   $0x0
  1000cf:	6a 00                	push   $0x0
  1000d1:	89 c3                	mov    %eax,%ebx
  1000d3:	e8 aa 0e 00 00       	call   100f82 <mon_backtrace>
  1000d8:	83 c4 10             	add    $0x10,%esp
}
  1000db:	90                   	nop
  1000dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000df:	c9                   	leave  
  1000e0:	c3                   	ret    

001000e1 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000e1:	55                   	push   %ebp
  1000e2:	89 e5                	mov    %esp,%ebp
  1000e4:	53                   	push   %ebx
  1000e5:	83 ec 04             	sub    $0x4,%esp
  1000e8:	e8 c5 01 00 00       	call   1002b2 <__x86.get_pc_thunk.ax>
  1000ed:	05 13 af 01 00       	add    $0x1af13,%eax
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000f2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000f8:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fe:	51                   	push   %ecx
  1000ff:	52                   	push   %edx
  100100:	53                   	push   %ebx
  100101:	50                   	push   %eax
  100102:	e8 b0 ff ff ff       	call   1000b7 <grade_backtrace2>
  100107:	83 c4 10             	add    $0x10,%esp
}
  10010a:	90                   	nop
  10010b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10010e:	c9                   	leave  
  10010f:	c3                   	ret    

00100110 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  100110:	55                   	push   %ebp
  100111:	89 e5                	mov    %esp,%ebp
  100113:	83 ec 08             	sub    $0x8,%esp
  100116:	e8 97 01 00 00       	call   1002b2 <__x86.get_pc_thunk.ax>
  10011b:	05 e5 ae 01 00       	add    $0x1aee5,%eax
    grade_backtrace1(arg0, arg2);
  100120:	83 ec 08             	sub    $0x8,%esp
  100123:	ff 75 10             	pushl  0x10(%ebp)
  100126:	ff 75 08             	pushl  0x8(%ebp)
  100129:	e8 b3 ff ff ff       	call   1000e1 <grade_backtrace1>
  10012e:	83 c4 10             	add    $0x10,%esp
}
  100131:	90                   	nop
  100132:	c9                   	leave  
  100133:	c3                   	ret    

00100134 <grade_backtrace>:

void
grade_backtrace(void) {
  100134:	55                   	push   %ebp
  100135:	89 e5                	mov    %esp,%ebp
  100137:	83 ec 08             	sub    $0x8,%esp
  10013a:	e8 73 01 00 00       	call   1002b2 <__x86.get_pc_thunk.ax>
  10013f:	05 c1 ae 01 00       	add    $0x1aec1,%eax
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100144:	8d 80 36 50 fe ff    	lea    -0x1afca(%eax),%eax
  10014a:	83 ec 04             	sub    $0x4,%esp
  10014d:	68 00 00 ff ff       	push   $0xffff0000
  100152:	50                   	push   %eax
  100153:	6a 00                	push   $0x0
  100155:	e8 b6 ff ff ff       	call   100110 <grade_backtrace0>
  10015a:	83 c4 10             	add    $0x10,%esp
}
  10015d:	90                   	nop
  10015e:	c9                   	leave  
  10015f:	c3                   	ret    

00100160 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100160:	55                   	push   %ebp
  100161:	89 e5                	mov    %esp,%ebp
  100163:	53                   	push   %ebx
  100164:	83 ec 14             	sub    $0x14,%esp
  100167:	e8 4a 01 00 00       	call   1002b6 <__x86.get_pc_thunk.bx>
  10016c:	81 c3 94 ae 01 00    	add    $0x1ae94,%ebx
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100172:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100175:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100178:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10017b:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10017e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100182:	0f b7 c0             	movzwl %ax,%eax
  100185:	83 e0 03             	and    $0x3,%eax
  100188:	89 c2                	mov    %eax,%edx
  10018a:	8b 83 a0 01 00 00    	mov    0x1a0(%ebx),%eax
  100190:	83 ec 04             	sub    $0x4,%esp
  100193:	52                   	push   %edx
  100194:	50                   	push   %eax
  100195:	8d 83 01 b7 fe ff    	lea    -0x148ff(%ebx),%eax
  10019b:	50                   	push   %eax
  10019c:	e8 88 01 00 00       	call   100329 <cprintf>
  1001a1:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  1001a4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1001a8:	0f b7 d0             	movzwl %ax,%edx
  1001ab:	8b 83 a0 01 00 00    	mov    0x1a0(%ebx),%eax
  1001b1:	83 ec 04             	sub    $0x4,%esp
  1001b4:	52                   	push   %edx
  1001b5:	50                   	push   %eax
  1001b6:	8d 83 0f b7 fe ff    	lea    -0x148f1(%ebx),%eax
  1001bc:	50                   	push   %eax
  1001bd:	e8 67 01 00 00       	call   100329 <cprintf>
  1001c2:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  1001c5:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001c9:	0f b7 d0             	movzwl %ax,%edx
  1001cc:	8b 83 a0 01 00 00    	mov    0x1a0(%ebx),%eax
  1001d2:	83 ec 04             	sub    $0x4,%esp
  1001d5:	52                   	push   %edx
  1001d6:	50                   	push   %eax
  1001d7:	8d 83 1d b7 fe ff    	lea    -0x148e3(%ebx),%eax
  1001dd:	50                   	push   %eax
  1001de:	e8 46 01 00 00       	call   100329 <cprintf>
  1001e3:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  1001e6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001ea:	0f b7 d0             	movzwl %ax,%edx
  1001ed:	8b 83 a0 01 00 00    	mov    0x1a0(%ebx),%eax
  1001f3:	83 ec 04             	sub    $0x4,%esp
  1001f6:	52                   	push   %edx
  1001f7:	50                   	push   %eax
  1001f8:	8d 83 2b b7 fe ff    	lea    -0x148d5(%ebx),%eax
  1001fe:	50                   	push   %eax
  1001ff:	e8 25 01 00 00       	call   100329 <cprintf>
  100204:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100207:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10020b:	0f b7 d0             	movzwl %ax,%edx
  10020e:	8b 83 a0 01 00 00    	mov    0x1a0(%ebx),%eax
  100214:	83 ec 04             	sub    $0x4,%esp
  100217:	52                   	push   %edx
  100218:	50                   	push   %eax
  100219:	8d 83 39 b7 fe ff    	lea    -0x148c7(%ebx),%eax
  10021f:	50                   	push   %eax
  100220:	e8 04 01 00 00       	call   100329 <cprintf>
  100225:	83 c4 10             	add    $0x10,%esp
    round ++;
  100228:	8b 83 a0 01 00 00    	mov    0x1a0(%ebx),%eax
  10022e:	83 c0 01             	add    $0x1,%eax
  100231:	89 83 a0 01 00 00    	mov    %eax,0x1a0(%ebx)
}
  100237:	90                   	nop
  100238:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10023b:	c9                   	leave  
  10023c:	c3                   	ret    

0010023d <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  10023d:	55                   	push   %ebp
  10023e:	89 e5                	mov    %esp,%ebp
  100240:	e8 6d 00 00 00       	call   1002b2 <__x86.get_pc_thunk.ax>
  100245:	05 bb ad 01 00       	add    $0x1adbb,%eax
    //LAB1 CHALLENGE 1 : TODO
}
  10024a:	90                   	nop
  10024b:	5d                   	pop    %ebp
  10024c:	c3                   	ret    

0010024d <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  10024d:	55                   	push   %ebp
  10024e:	89 e5                	mov    %esp,%ebp
  100250:	e8 5d 00 00 00       	call   1002b2 <__x86.get_pc_thunk.ax>
  100255:	05 ab ad 01 00       	add    $0x1adab,%eax
    //LAB1 CHALLENGE 1 :  TODO
}
  10025a:	90                   	nop
  10025b:	5d                   	pop    %ebp
  10025c:	c3                   	ret    

0010025d <lab1_switch_test>:

static void
lab1_switch_test(void) {
  10025d:	55                   	push   %ebp
  10025e:	89 e5                	mov    %esp,%ebp
  100260:	53                   	push   %ebx
  100261:	83 ec 04             	sub    $0x4,%esp
  100264:	e8 4d 00 00 00       	call   1002b6 <__x86.get_pc_thunk.bx>
  100269:	81 c3 97 ad 01 00    	add    $0x1ad97,%ebx
    lab1_print_cur_status();
  10026f:	e8 ec fe ff ff       	call   100160 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100274:	83 ec 0c             	sub    $0xc,%esp
  100277:	8d 83 48 b7 fe ff    	lea    -0x148b8(%ebx),%eax
  10027d:	50                   	push   %eax
  10027e:	e8 a6 00 00 00       	call   100329 <cprintf>
  100283:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  100286:	e8 b2 ff ff ff       	call   10023d <lab1_switch_to_user>
    lab1_print_cur_status();
  10028b:	e8 d0 fe ff ff       	call   100160 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100290:	83 ec 0c             	sub    $0xc,%esp
  100293:	8d 83 68 b7 fe ff    	lea    -0x14898(%ebx),%eax
  100299:	50                   	push   %eax
  10029a:	e8 8a 00 00 00       	call   100329 <cprintf>
  10029f:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1002a2:	e8 a6 ff ff ff       	call   10024d <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1002a7:	e8 b4 fe ff ff       	call   100160 <lab1_print_cur_status>
}
  1002ac:	90                   	nop
  1002ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1002b0:	c9                   	leave  
  1002b1:	c3                   	ret    

001002b2 <__x86.get_pc_thunk.ax>:
  1002b2:	8b 04 24             	mov    (%esp),%eax
  1002b5:	c3                   	ret    

001002b6 <__x86.get_pc_thunk.bx>:
  1002b6:	8b 1c 24             	mov    (%esp),%ebx
  1002b9:	c3                   	ret    

001002ba <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002ba:	55                   	push   %ebp
  1002bb:	89 e5                	mov    %esp,%ebp
  1002bd:	53                   	push   %ebx
  1002be:	83 ec 04             	sub    $0x4,%esp
  1002c1:	e8 ec ff ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1002c6:	05 3a ad 01 00       	add    $0x1ad3a,%eax
    cons_putc(c);
  1002cb:	83 ec 0c             	sub    $0xc,%esp
  1002ce:	ff 75 08             	pushl  0x8(%ebp)
  1002d1:	89 c3                	mov    %eax,%ebx
  1002d3:	e8 75 16 00 00       	call   10194d <cons_putc>
  1002d8:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  1002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002de:	8b 00                	mov    (%eax),%eax
  1002e0:	8d 50 01             	lea    0x1(%eax),%edx
  1002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e6:	89 10                	mov    %edx,(%eax)
}
  1002e8:	90                   	nop
  1002e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1002ec:	c9                   	leave  
  1002ed:	c3                   	ret    

001002ee <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002ee:	55                   	push   %ebp
  1002ef:	89 e5                	mov    %esp,%ebp
  1002f1:	53                   	push   %ebx
  1002f2:	83 ec 14             	sub    $0x14,%esp
  1002f5:	e8 b8 ff ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1002fa:	05 06 ad 01 00       	add    $0x1ad06,%eax
    int cnt = 0;
  1002ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100306:	ff 75 0c             	pushl  0xc(%ebp)
  100309:	ff 75 08             	pushl  0x8(%ebp)
  10030c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10030f:	52                   	push   %edx
  100310:	8d 90 ba 52 fe ff    	lea    -0x1ad46(%eax),%edx
  100316:	52                   	push   %edx
  100317:	89 c3                	mov    %eax,%ebx
  100319:	e8 24 5f 00 00       	call   106242 <vprintfmt>
  10031e:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100321:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100324:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100327:	c9                   	leave  
  100328:	c3                   	ret    

00100329 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100329:	55                   	push   %ebp
  10032a:	89 e5                	mov    %esp,%ebp
  10032c:	83 ec 18             	sub    $0x18,%esp
  10032f:	e8 7e ff ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  100334:	05 cc ac 01 00       	add    $0x1accc,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100339:	8d 45 0c             	lea    0xc(%ebp),%eax
  10033c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10033f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100342:	83 ec 08             	sub    $0x8,%esp
  100345:	50                   	push   %eax
  100346:	ff 75 08             	pushl  0x8(%ebp)
  100349:	e8 a0 ff ff ff       	call   1002ee <vcprintf>
  10034e:	83 c4 10             	add    $0x10,%esp
  100351:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100354:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100357:	c9                   	leave  
  100358:	c3                   	ret    

00100359 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100359:	55                   	push   %ebp
  10035a:	89 e5                	mov    %esp,%ebp
  10035c:	53                   	push   %ebx
  10035d:	83 ec 04             	sub    $0x4,%esp
  100360:	e8 4d ff ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  100365:	05 9b ac 01 00       	add    $0x1ac9b,%eax
    cons_putc(c);
  10036a:	83 ec 0c             	sub    $0xc,%esp
  10036d:	ff 75 08             	pushl  0x8(%ebp)
  100370:	89 c3                	mov    %eax,%ebx
  100372:	e8 d6 15 00 00       	call   10194d <cons_putc>
  100377:	83 c4 10             	add    $0x10,%esp
}
  10037a:	90                   	nop
  10037b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10037e:	c9                   	leave  
  10037f:	c3                   	ret    

00100380 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100380:	55                   	push   %ebp
  100381:	89 e5                	mov    %esp,%ebp
  100383:	83 ec 18             	sub    $0x18,%esp
  100386:	e8 27 ff ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  10038b:	05 75 ac 01 00       	add    $0x1ac75,%eax
    int cnt = 0;
  100390:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100397:	eb 14                	jmp    1003ad <cputs+0x2d>
        cputch(c, &cnt);
  100399:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10039d:	83 ec 08             	sub    $0x8,%esp
  1003a0:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1003a3:	52                   	push   %edx
  1003a4:	50                   	push   %eax
  1003a5:	e8 10 ff ff ff       	call   1002ba <cputch>
  1003aa:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  1003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1003b0:	8d 50 01             	lea    0x1(%eax),%edx
  1003b3:	89 55 08             	mov    %edx,0x8(%ebp)
  1003b6:	0f b6 00             	movzbl (%eax),%eax
  1003b9:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003bc:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003c0:	75 d7                	jne    100399 <cputs+0x19>
    }
    cputch('\n', &cnt);
  1003c2:	83 ec 08             	sub    $0x8,%esp
  1003c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003c8:	50                   	push   %eax
  1003c9:	6a 0a                	push   $0xa
  1003cb:	e8 ea fe ff ff       	call   1002ba <cputch>
  1003d0:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1003d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003d6:	c9                   	leave  
  1003d7:	c3                   	ret    

001003d8 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003d8:	55                   	push   %ebp
  1003d9:	89 e5                	mov    %esp,%ebp
  1003db:	53                   	push   %ebx
  1003dc:	83 ec 14             	sub    $0x14,%esp
  1003df:	e8 d2 fe ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  1003e4:	81 c3 1c ac 01 00    	add    $0x1ac1c,%ebx
    int c;
    while ((c = cons_getc()) == 0)
  1003ea:	e8 b1 15 00 00       	call   1019a0 <cons_getc>
  1003ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003f6:	74 f2                	je     1003ea <getchar+0x12>
        /* do nothing */;
    return c;
  1003f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003fb:	83 c4 14             	add    $0x14,%esp
  1003fe:	5b                   	pop    %ebx
  1003ff:	5d                   	pop    %ebp
  100400:	c3                   	ret    

00100401 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100401:	55                   	push   %ebp
  100402:	89 e5                	mov    %esp,%ebp
  100404:	53                   	push   %ebx
  100405:	83 ec 14             	sub    $0x14,%esp
  100408:	e8 a9 fe ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  10040d:	81 c3 f3 ab 01 00    	add    $0x1abf3,%ebx
    if (prompt != NULL) {
  100413:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100417:	74 15                	je     10042e <readline+0x2d>
        cprintf("%s", prompt);
  100419:	83 ec 08             	sub    $0x8,%esp
  10041c:	ff 75 08             	pushl  0x8(%ebp)
  10041f:	8d 83 87 b7 fe ff    	lea    -0x14879(%ebx),%eax
  100425:	50                   	push   %eax
  100426:	e8 fe fe ff ff       	call   100329 <cprintf>
  10042b:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10042e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100435:	e8 9e ff ff ff       	call   1003d8 <getchar>
  10043a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10043d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100441:	79 0a                	jns    10044d <readline+0x4c>
            return NULL;
  100443:	b8 00 00 00 00       	mov    $0x0,%eax
  100448:	e9 87 00 00 00       	jmp    1004d4 <readline+0xd3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10044d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100451:	7e 2c                	jle    10047f <readline+0x7e>
  100453:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10045a:	7f 23                	jg     10047f <readline+0x7e>
            cputchar(c);
  10045c:	83 ec 0c             	sub    $0xc,%esp
  10045f:	ff 75 f0             	pushl  -0x10(%ebp)
  100462:	e8 f2 fe ff ff       	call   100359 <cputchar>
  100467:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10046a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10046d:	8d 50 01             	lea    0x1(%eax),%edx
  100470:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100473:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100476:	88 94 03 c0 01 00 00 	mov    %dl,0x1c0(%ebx,%eax,1)
  10047d:	eb 50                	jmp    1004cf <readline+0xce>
        }
        else if (c == '\b' && i > 0) {
  10047f:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100483:	75 1a                	jne    10049f <readline+0x9e>
  100485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100489:	7e 14                	jle    10049f <readline+0x9e>
            cputchar(c);
  10048b:	83 ec 0c             	sub    $0xc,%esp
  10048e:	ff 75 f0             	pushl  -0x10(%ebp)
  100491:	e8 c3 fe ff ff       	call   100359 <cputchar>
  100496:	83 c4 10             	add    $0x10,%esp
            i --;
  100499:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10049d:	eb 30                	jmp    1004cf <readline+0xce>
        }
        else if (c == '\n' || c == '\r') {
  10049f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1004a3:	74 06                	je     1004ab <readline+0xaa>
  1004a5:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1004a9:	75 8a                	jne    100435 <readline+0x34>
            cputchar(c);
  1004ab:	83 ec 0c             	sub    $0xc,%esp
  1004ae:	ff 75 f0             	pushl  -0x10(%ebp)
  1004b1:	e8 a3 fe ff ff       	call   100359 <cputchar>
  1004b6:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1004b9:	8d 93 c0 01 00 00    	lea    0x1c0(%ebx),%edx
  1004bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004c2:	01 d0                	add    %edx,%eax
  1004c4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1004c7:	8d 83 c0 01 00 00    	lea    0x1c0(%ebx),%eax
  1004cd:	eb 05                	jmp    1004d4 <readline+0xd3>
        c = getchar();
  1004cf:	e9 61 ff ff ff       	jmp    100435 <readline+0x34>
        }
    }
}
  1004d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1004d7:	c9                   	leave  
  1004d8:	c3                   	ret    

001004d9 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1004d9:	55                   	push   %ebp
  1004da:	89 e5                	mov    %esp,%ebp
  1004dc:	53                   	push   %ebx
  1004dd:	83 ec 14             	sub    $0x14,%esp
  1004e0:	e8 d1 fd ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  1004e5:	81 c3 1b ab 01 00    	add    $0x1ab1b,%ebx
    if (is_panic) {
  1004eb:	8b 83 c0 05 00 00    	mov    0x5c0(%ebx),%eax
  1004f1:	85 c0                	test   %eax,%eax
  1004f3:	75 65                	jne    10055a <__panic+0x81>
        goto panic_dead;
    }
    is_panic = 1;
  1004f5:	c7 83 c0 05 00 00 01 	movl   $0x1,0x5c0(%ebx)
  1004fc:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1004ff:	8d 45 14             	lea    0x14(%ebp),%eax
  100502:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100505:	83 ec 04             	sub    $0x4,%esp
  100508:	ff 75 0c             	pushl  0xc(%ebp)
  10050b:	ff 75 08             	pushl  0x8(%ebp)
  10050e:	8d 83 8a b7 fe ff    	lea    -0x14876(%ebx),%eax
  100514:	50                   	push   %eax
  100515:	e8 0f fe ff ff       	call   100329 <cprintf>
  10051a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10051d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100520:	83 ec 08             	sub    $0x8,%esp
  100523:	50                   	push   %eax
  100524:	ff 75 10             	pushl  0x10(%ebp)
  100527:	e8 c2 fd ff ff       	call   1002ee <vcprintf>
  10052c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10052f:	83 ec 0c             	sub    $0xc,%esp
  100532:	8d 83 a6 b7 fe ff    	lea    -0x1485a(%ebx),%eax
  100538:	50                   	push   %eax
  100539:	e8 eb fd ff ff       	call   100329 <cprintf>
  10053e:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
  100541:	83 ec 0c             	sub    $0xc,%esp
  100544:	8d 83 a8 b7 fe ff    	lea    -0x14858(%ebx),%eax
  10054a:	50                   	push   %eax
  10054b:	e8 d9 fd ff ff       	call   100329 <cprintf>
  100550:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
  100553:	e8 9f 06 00 00       	call   100bf7 <print_stackframe>
  100558:	eb 01                	jmp    10055b <__panic+0x82>
        goto panic_dead;
  10055a:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10055b:	e8 c0 16 00 00       	call   101c20 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100560:	83 ec 0c             	sub    $0xc,%esp
  100563:	6a 00                	push   $0x0
  100565:	e8 fe 08 00 00       	call   100e68 <kmonitor>
  10056a:	83 c4 10             	add    $0x10,%esp
  10056d:	eb f1                	jmp    100560 <__panic+0x87>

0010056f <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10056f:	55                   	push   %ebp
  100570:	89 e5                	mov    %esp,%ebp
  100572:	53                   	push   %ebx
  100573:	83 ec 14             	sub    $0x14,%esp
  100576:	e8 3b fd ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  10057b:	81 c3 85 aa 01 00    	add    $0x1aa85,%ebx
    va_list ap;
    va_start(ap, fmt);
  100581:	8d 45 14             	lea    0x14(%ebp),%eax
  100584:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100587:	83 ec 04             	sub    $0x4,%esp
  10058a:	ff 75 0c             	pushl  0xc(%ebp)
  10058d:	ff 75 08             	pushl  0x8(%ebp)
  100590:	8d 83 ba b7 fe ff    	lea    -0x14846(%ebx),%eax
  100596:	50                   	push   %eax
  100597:	e8 8d fd ff ff       	call   100329 <cprintf>
  10059c:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10059f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005a2:	83 ec 08             	sub    $0x8,%esp
  1005a5:	50                   	push   %eax
  1005a6:	ff 75 10             	pushl  0x10(%ebp)
  1005a9:	e8 40 fd ff ff       	call   1002ee <vcprintf>
  1005ae:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1005b1:	83 ec 0c             	sub    $0xc,%esp
  1005b4:	8d 83 a6 b7 fe ff    	lea    -0x1485a(%ebx),%eax
  1005ba:	50                   	push   %eax
  1005bb:	e8 69 fd ff ff       	call   100329 <cprintf>
  1005c0:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1005c3:	90                   	nop
  1005c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1005c7:	c9                   	leave  
  1005c8:	c3                   	ret    

001005c9 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1005c9:	55                   	push   %ebp
  1005ca:	89 e5                	mov    %esp,%ebp
  1005cc:	e8 e1 fc ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1005d1:	05 2f aa 01 00       	add    $0x1aa2f,%eax
    return is_panic;
  1005d6:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
}
  1005dc:	5d                   	pop    %ebp
  1005dd:	c3                   	ret    

001005de <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1005de:	55                   	push   %ebp
  1005df:	89 e5                	mov    %esp,%ebp
  1005e1:	83 ec 20             	sub    $0x20,%esp
  1005e4:	e8 c9 fc ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1005e9:	05 17 aa 01 00       	add    $0x1aa17,%eax
    int l = *region_left, r = *region_right, any_matches = 0;
  1005ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f1:	8b 00                	mov    (%eax),%eax
  1005f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1005f9:	8b 00                	mov    (%eax),%eax
  1005fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100605:	e9 d2 00 00 00       	jmp    1006dc <stab_binsearch+0xfe>
        int true_m = (l + r) / 2, m = true_m;
  10060a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10060d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100610:	01 d0                	add    %edx,%eax
  100612:	89 c2                	mov    %eax,%edx
  100614:	c1 ea 1f             	shr    $0x1f,%edx
  100617:	01 d0                	add    %edx,%eax
  100619:	d1 f8                	sar    %eax
  10061b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10061e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100621:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100624:	eb 04                	jmp    10062a <stab_binsearch+0x4c>
            m --;
  100626:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10062a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10062d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100630:	7c 1f                	jl     100651 <stab_binsearch+0x73>
  100632:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100635:	89 d0                	mov    %edx,%eax
  100637:	01 c0                	add    %eax,%eax
  100639:	01 d0                	add    %edx,%eax
  10063b:	c1 e0 02             	shl    $0x2,%eax
  10063e:	89 c2                	mov    %eax,%edx
  100640:	8b 45 08             	mov    0x8(%ebp),%eax
  100643:	01 d0                	add    %edx,%eax
  100645:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100649:	0f b6 c0             	movzbl %al,%eax
  10064c:	39 45 14             	cmp    %eax,0x14(%ebp)
  10064f:	75 d5                	jne    100626 <stab_binsearch+0x48>
        }
        if (m < l) {    // no match in [l, m]
  100651:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100654:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100657:	7d 0b                	jge    100664 <stab_binsearch+0x86>
            l = true_m + 1;
  100659:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065c:	83 c0 01             	add    $0x1,%eax
  10065f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100662:	eb 78                	jmp    1006dc <stab_binsearch+0xfe>
        }

        // actual binary search
        any_matches = 1;
  100664:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10066b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10066e:	89 d0                	mov    %edx,%eax
  100670:	01 c0                	add    %eax,%eax
  100672:	01 d0                	add    %edx,%eax
  100674:	c1 e0 02             	shl    $0x2,%eax
  100677:	89 c2                	mov    %eax,%edx
  100679:	8b 45 08             	mov    0x8(%ebp),%eax
  10067c:	01 d0                	add    %edx,%eax
  10067e:	8b 40 08             	mov    0x8(%eax),%eax
  100681:	39 45 18             	cmp    %eax,0x18(%ebp)
  100684:	76 13                	jbe    100699 <stab_binsearch+0xbb>
            *region_left = m;
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10068c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10068e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100691:	83 c0 01             	add    $0x1,%eax
  100694:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100697:	eb 43                	jmp    1006dc <stab_binsearch+0xfe>
        } else if (stabs[m].n_value > addr) {
  100699:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10069c:	89 d0                	mov    %edx,%eax
  10069e:	01 c0                	add    %eax,%eax
  1006a0:	01 d0                	add    %edx,%eax
  1006a2:	c1 e0 02             	shl    $0x2,%eax
  1006a5:	89 c2                	mov    %eax,%edx
  1006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1006aa:	01 d0                	add    %edx,%eax
  1006ac:	8b 40 08             	mov    0x8(%eax),%eax
  1006af:	39 45 18             	cmp    %eax,0x18(%ebp)
  1006b2:	73 16                	jae    1006ca <stab_binsearch+0xec>
            *region_right = m - 1;
  1006b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1006ba:	8b 45 10             	mov    0x10(%ebp),%eax
  1006bd:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1006bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006c2:	83 e8 01             	sub    $0x1,%eax
  1006c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1006c8:	eb 12                	jmp    1006dc <stab_binsearch+0xfe>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1006ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1006d0:	89 10                	mov    %edx,(%eax)
            l = m;
  1006d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1006d8:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  1006dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1006df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1006e2:	0f 8e 22 ff ff ff    	jle    10060a <stab_binsearch+0x2c>
        }
    }

    if (!any_matches) {
  1006e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1006ec:	75 0f                	jne    1006fd <stab_binsearch+0x11f>
        *region_right = *region_left - 1;
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 00                	mov    (%eax),%eax
  1006f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1006f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1006f9:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1006fb:	eb 3f                	jmp    10073c <stab_binsearch+0x15e>
        l = *region_right;
  1006fd:	8b 45 10             	mov    0x10(%ebp),%eax
  100700:	8b 00                	mov    (%eax),%eax
  100702:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100705:	eb 04                	jmp    10070b <stab_binsearch+0x12d>
  100707:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10070b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10070e:	8b 00                	mov    (%eax),%eax
  100710:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100713:	7e 1f                	jle    100734 <stab_binsearch+0x156>
  100715:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100718:	89 d0                	mov    %edx,%eax
  10071a:	01 c0                	add    %eax,%eax
  10071c:	01 d0                	add    %edx,%eax
  10071e:	c1 e0 02             	shl    $0x2,%eax
  100721:	89 c2                	mov    %eax,%edx
  100723:	8b 45 08             	mov    0x8(%ebp),%eax
  100726:	01 d0                	add    %edx,%eax
  100728:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10072c:	0f b6 c0             	movzbl %al,%eax
  10072f:	39 45 14             	cmp    %eax,0x14(%ebp)
  100732:	75 d3                	jne    100707 <stab_binsearch+0x129>
        *region_left = l;
  100734:	8b 45 0c             	mov    0xc(%ebp),%eax
  100737:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10073a:	89 10                	mov    %edx,(%eax)
}
  10073c:	90                   	nop
  10073d:	c9                   	leave  
  10073e:	c3                   	ret    

0010073f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10073f:	55                   	push   %ebp
  100740:	89 e5                	mov    %esp,%ebp
  100742:	53                   	push   %ebx
  100743:	83 ec 34             	sub    $0x34,%esp
  100746:	e8 6b fb ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  10074b:	81 c3 b5 a8 01 00    	add    $0x1a8b5,%ebx
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100751:	8b 45 0c             	mov    0xc(%ebp),%eax
  100754:	8d 93 d8 b7 fe ff    	lea    -0x14828(%ebx),%edx
  10075a:	89 10                	mov    %edx,(%eax)
    info->eip_line = 0;
  10075c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100766:	8b 45 0c             	mov    0xc(%ebp),%eax
  100769:	8d 93 d8 b7 fe ff    	lea    -0x14828(%ebx),%edx
  10076f:	89 50 08             	mov    %edx,0x8(%eax)
    info->eip_fn_namelen = 9;
  100772:	8b 45 0c             	mov    0xc(%ebp),%eax
  100775:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10077c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077f:	8b 55 08             	mov    0x8(%ebp),%edx
  100782:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100785:	8b 45 0c             	mov    0xc(%ebp),%eax
  100788:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10078f:	c7 c0 3c 79 10 00    	mov    $0x10793c,%eax
  100795:	89 45 f4             	mov    %eax,-0xc(%ebp)
    stab_end = __STAB_END__;
  100798:	c7 c0 e0 2b 11 00    	mov    $0x112be0,%eax
  10079e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1007a1:	c7 c0 e1 2b 11 00    	mov    $0x112be1,%eax
  1007a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1007aa:	c7 c0 02 57 11 00    	mov    $0x115702,%eax
  1007b0:	89 45 e8             	mov    %eax,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1007b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1007b9:	76 0d                	jbe    1007c8 <debuginfo_eip+0x89>
  1007bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007be:	83 e8 01             	sub    $0x1,%eax
  1007c1:	0f b6 00             	movzbl (%eax),%eax
  1007c4:	84 c0                	test   %al,%al
  1007c6:	74 0a                	je     1007d2 <debuginfo_eip+0x93>
        return -1;
  1007c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007cd:	e9 91 02 00 00       	jmp    100a63 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1007d2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1007d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1007dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007df:	29 c2                	sub    %eax,%edx
  1007e1:	89 d0                	mov    %edx,%eax
  1007e3:	c1 f8 02             	sar    $0x2,%eax
  1007e6:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1007ec:	83 e8 01             	sub    $0x1,%eax
  1007ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1007f2:	ff 75 08             	pushl  0x8(%ebp)
  1007f5:	6a 64                	push   $0x64
  1007f7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1007fa:	50                   	push   %eax
  1007fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1007fe:	50                   	push   %eax
  1007ff:	ff 75 f4             	pushl  -0xc(%ebp)
  100802:	e8 d7 fd ff ff       	call   1005de <stab_binsearch>
  100807:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  10080a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10080d:	85 c0                	test   %eax,%eax
  10080f:	75 0a                	jne    10081b <debuginfo_eip+0xdc>
        return -1;
  100811:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100816:	e9 48 02 00 00       	jmp    100a63 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10081b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10081e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100821:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100824:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100827:	ff 75 08             	pushl  0x8(%ebp)
  10082a:	6a 24                	push   $0x24
  10082c:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10082f:	50                   	push   %eax
  100830:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100833:	50                   	push   %eax
  100834:	ff 75 f4             	pushl  -0xc(%ebp)
  100837:	e8 a2 fd ff ff       	call   1005de <stab_binsearch>
  10083c:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  10083f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100842:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100845:	39 c2                	cmp    %eax,%edx
  100847:	7f 7c                	jg     1008c5 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100849:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10084c:	89 c2                	mov    %eax,%edx
  10084e:	89 d0                	mov    %edx,%eax
  100850:	01 c0                	add    %eax,%eax
  100852:	01 d0                	add    %edx,%eax
  100854:	c1 e0 02             	shl    $0x2,%eax
  100857:	89 c2                	mov    %eax,%edx
  100859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085c:	01 d0                	add    %edx,%eax
  10085e:	8b 00                	mov    (%eax),%eax
  100860:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100863:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100866:	29 d1                	sub    %edx,%ecx
  100868:	89 ca                	mov    %ecx,%edx
  10086a:	39 d0                	cmp    %edx,%eax
  10086c:	73 22                	jae    100890 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10086e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100871:	89 c2                	mov    %eax,%edx
  100873:	89 d0                	mov    %edx,%eax
  100875:	01 c0                	add    %eax,%eax
  100877:	01 d0                	add    %edx,%eax
  100879:	c1 e0 02             	shl    $0x2,%eax
  10087c:	89 c2                	mov    %eax,%edx
  10087e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100881:	01 d0                	add    %edx,%eax
  100883:	8b 10                	mov    (%eax),%edx
  100885:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100888:	01 c2                	add    %eax,%edx
  10088a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10088d:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100890:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100893:	89 c2                	mov    %eax,%edx
  100895:	89 d0                	mov    %edx,%eax
  100897:	01 c0                	add    %eax,%eax
  100899:	01 d0                	add    %edx,%eax
  10089b:	c1 e0 02             	shl    $0x2,%eax
  10089e:	89 c2                	mov    %eax,%edx
  1008a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a3:	01 d0                	add    %edx,%eax
  1008a5:	8b 50 08             	mov    0x8(%eax),%edx
  1008a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ab:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1008ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b1:	8b 40 10             	mov    0x10(%eax),%eax
  1008b4:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1008b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1008bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1008c3:	eb 15                	jmp    1008da <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1008c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008c8:	8b 55 08             	mov    0x8(%ebp),%edx
  1008cb:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1008ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1008d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1008d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1008da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008dd:	8b 40 08             	mov    0x8(%eax),%eax
  1008e0:	83 ec 08             	sub    $0x8,%esp
  1008e3:	6a 3a                	push   $0x3a
  1008e5:	50                   	push   %eax
  1008e6:	e8 29 54 00 00       	call   105d14 <strfind>
  1008eb:	83 c4 10             	add    $0x10,%esp
  1008ee:	89 c2                	mov    %eax,%edx
  1008f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f3:	8b 40 08             	mov    0x8(%eax),%eax
  1008f6:	29 c2                	sub    %eax,%edx
  1008f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008fb:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1008fe:	83 ec 0c             	sub    $0xc,%esp
  100901:	ff 75 08             	pushl  0x8(%ebp)
  100904:	6a 44                	push   $0x44
  100906:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100909:	50                   	push   %eax
  10090a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10090d:	50                   	push   %eax
  10090e:	ff 75 f4             	pushl  -0xc(%ebp)
  100911:	e8 c8 fc ff ff       	call   1005de <stab_binsearch>
  100916:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  100919:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10091c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10091f:	39 c2                	cmp    %eax,%edx
  100921:	7f 24                	jg     100947 <debuginfo_eip+0x208>
        info->eip_line = stabs[rline].n_desc;
  100923:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100926:	89 c2                	mov    %eax,%edx
  100928:	89 d0                	mov    %edx,%eax
  10092a:	01 c0                	add    %eax,%eax
  10092c:	01 d0                	add    %edx,%eax
  10092e:	c1 e0 02             	shl    $0x2,%eax
  100931:	89 c2                	mov    %eax,%edx
  100933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100936:	01 d0                	add    %edx,%eax
  100938:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10093c:	0f b7 d0             	movzwl %ax,%edx
  10093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100942:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100945:	eb 13                	jmp    10095a <debuginfo_eip+0x21b>
        return -1;
  100947:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10094c:	e9 12 01 00 00       	jmp    100a63 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100951:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100954:	83 e8 01             	sub    $0x1,%eax
  100957:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10095a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10095d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100960:	39 c2                	cmp    %eax,%edx
  100962:	7c 56                	jl     1009ba <debuginfo_eip+0x27b>
           && stabs[lline].n_type != N_SOL
  100964:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100967:	89 c2                	mov    %eax,%edx
  100969:	89 d0                	mov    %edx,%eax
  10096b:	01 c0                	add    %eax,%eax
  10096d:	01 d0                	add    %edx,%eax
  10096f:	c1 e0 02             	shl    $0x2,%eax
  100972:	89 c2                	mov    %eax,%edx
  100974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100977:	01 d0                	add    %edx,%eax
  100979:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10097d:	3c 84                	cmp    $0x84,%al
  10097f:	74 39                	je     1009ba <debuginfo_eip+0x27b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100981:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100984:	89 c2                	mov    %eax,%edx
  100986:	89 d0                	mov    %edx,%eax
  100988:	01 c0                	add    %eax,%eax
  10098a:	01 d0                	add    %edx,%eax
  10098c:	c1 e0 02             	shl    $0x2,%eax
  10098f:	89 c2                	mov    %eax,%edx
  100991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100994:	01 d0                	add    %edx,%eax
  100996:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10099a:	3c 64                	cmp    $0x64,%al
  10099c:	75 b3                	jne    100951 <debuginfo_eip+0x212>
  10099e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1009a1:	89 c2                	mov    %eax,%edx
  1009a3:	89 d0                	mov    %edx,%eax
  1009a5:	01 c0                	add    %eax,%eax
  1009a7:	01 d0                	add    %edx,%eax
  1009a9:	c1 e0 02             	shl    $0x2,%eax
  1009ac:	89 c2                	mov    %eax,%edx
  1009ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009b1:	01 d0                	add    %edx,%eax
  1009b3:	8b 40 08             	mov    0x8(%eax),%eax
  1009b6:	85 c0                	test   %eax,%eax
  1009b8:	74 97                	je     100951 <debuginfo_eip+0x212>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1009ba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1009bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009c0:	39 c2                	cmp    %eax,%edx
  1009c2:	7c 46                	jl     100a0a <debuginfo_eip+0x2cb>
  1009c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1009c7:	89 c2                	mov    %eax,%edx
  1009c9:	89 d0                	mov    %edx,%eax
  1009cb:	01 c0                	add    %eax,%eax
  1009cd:	01 d0                	add    %edx,%eax
  1009cf:	c1 e0 02             	shl    $0x2,%eax
  1009d2:	89 c2                	mov    %eax,%edx
  1009d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d7:	01 d0                	add    %edx,%eax
  1009d9:	8b 00                	mov    (%eax),%eax
  1009db:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1009de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1009e1:	29 d1                	sub    %edx,%ecx
  1009e3:	89 ca                	mov    %ecx,%edx
  1009e5:	39 d0                	cmp    %edx,%eax
  1009e7:	73 21                	jae    100a0a <debuginfo_eip+0x2cb>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1009e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1009ec:	89 c2                	mov    %eax,%edx
  1009ee:	89 d0                	mov    %edx,%eax
  1009f0:	01 c0                	add    %eax,%eax
  1009f2:	01 d0                	add    %edx,%eax
  1009f4:	c1 e0 02             	shl    $0x2,%eax
  1009f7:	89 c2                	mov    %eax,%edx
  1009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fc:	01 d0                	add    %edx,%eax
  1009fe:	8b 10                	mov    (%eax),%edx
  100a00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a03:	01 c2                	add    %eax,%edx
  100a05:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a08:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100a0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100a0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100a10:	39 c2                	cmp    %eax,%edx
  100a12:	7d 4a                	jge    100a5e <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  100a14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a17:	83 c0 01             	add    $0x1,%eax
  100a1a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100a1d:	eb 18                	jmp    100a37 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a22:	8b 40 14             	mov    0x14(%eax),%eax
  100a25:	8d 50 01             	lea    0x1(%eax),%edx
  100a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a2b:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100a2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a31:	83 c0 01             	add    $0x1,%eax
  100a34:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100a37:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100a3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100a3d:	39 c2                	cmp    %eax,%edx
  100a3f:	7d 1d                	jge    100a5e <debuginfo_eip+0x31f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100a41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a44:	89 c2                	mov    %eax,%edx
  100a46:	89 d0                	mov    %edx,%eax
  100a48:	01 c0                	add    %eax,%eax
  100a4a:	01 d0                	add    %edx,%eax
  100a4c:	c1 e0 02             	shl    $0x2,%eax
  100a4f:	89 c2                	mov    %eax,%edx
  100a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a54:	01 d0                	add    %edx,%eax
  100a56:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100a5a:	3c a0                	cmp    $0xa0,%al
  100a5c:	74 c1                	je     100a1f <debuginfo_eip+0x2e0>
        }
    }
    return 0;
  100a5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100a63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100a66:	c9                   	leave  
  100a67:	c3                   	ret    

00100a68 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100a68:	55                   	push   %ebp
  100a69:	89 e5                	mov    %esp,%ebp
  100a6b:	53                   	push   %ebx
  100a6c:	83 ec 04             	sub    $0x4,%esp
  100a6f:	e8 42 f8 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  100a74:	81 c3 8c a5 01 00    	add    $0x1a58c,%ebx
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100a7a:	83 ec 0c             	sub    $0xc,%esp
  100a7d:	8d 83 e2 b7 fe ff    	lea    -0x1481e(%ebx),%eax
  100a83:	50                   	push   %eax
  100a84:	e8 a0 f8 ff ff       	call   100329 <cprintf>
  100a89:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100a8c:	83 ec 08             	sub    $0x8,%esp
  100a8f:	c7 c0 36 00 10 00    	mov    $0x100036,%eax
  100a95:	50                   	push   %eax
  100a96:	8d 83 fb b7 fe ff    	lea    -0x14805(%ebx),%eax
  100a9c:	50                   	push   %eax
  100a9d:	e8 87 f8 ff ff       	call   100329 <cprintf>
  100aa2:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100aa5:	83 ec 08             	sub    $0x8,%esp
  100aa8:	c7 c0 e0 66 10 00    	mov    $0x1066e0,%eax
  100aae:	50                   	push   %eax
  100aaf:	8d 83 13 b8 fe ff    	lea    -0x147ed(%ebx),%eax
  100ab5:	50                   	push   %eax
  100ab6:	e8 6e f8 ff ff       	call   100329 <cprintf>
  100abb:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100abe:	83 ec 08             	sub    $0x8,%esp
  100ac1:	c7 c0 50 89 11 00    	mov    $0x118950,%eax
  100ac7:	50                   	push   %eax
  100ac8:	8d 83 2b b8 fe ff    	lea    -0x147d5(%ebx),%eax
  100ace:	50                   	push   %eax
  100acf:	e8 55 f8 ff ff       	call   100329 <cprintf>
  100ad4:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100ad7:	83 ec 08             	sub    $0x8,%esp
  100ada:	c7 c0 28 c1 11 00    	mov    $0x11c128,%eax
  100ae0:	50                   	push   %eax
  100ae1:	8d 83 43 b8 fe ff    	lea    -0x147bd(%ebx),%eax
  100ae7:	50                   	push   %eax
  100ae8:	e8 3c f8 ff ff       	call   100329 <cprintf>
  100aed:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100af0:	c7 c0 28 c1 11 00    	mov    $0x11c128,%eax
  100af6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100afc:	c7 c0 36 00 10 00    	mov    $0x100036,%eax
  100b02:	29 c2                	sub    %eax,%edx
  100b04:	89 d0                	mov    %edx,%eax
  100b06:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100b0c:	85 c0                	test   %eax,%eax
  100b0e:	0f 48 c2             	cmovs  %edx,%eax
  100b11:	c1 f8 0a             	sar    $0xa,%eax
  100b14:	83 ec 08             	sub    $0x8,%esp
  100b17:	50                   	push   %eax
  100b18:	8d 83 5c b8 fe ff    	lea    -0x147a4(%ebx),%eax
  100b1e:	50                   	push   %eax
  100b1f:	e8 05 f8 ff ff       	call   100329 <cprintf>
  100b24:	83 c4 10             	add    $0x10,%esp
}
  100b27:	90                   	nop
  100b28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100b2b:	c9                   	leave  
  100b2c:	c3                   	ret    

00100b2d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100b2d:	55                   	push   %ebp
  100b2e:	89 e5                	mov    %esp,%ebp
  100b30:	53                   	push   %ebx
  100b31:	81 ec 24 01 00 00    	sub    $0x124,%esp
  100b37:	e8 7a f7 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  100b3c:	81 c3 c4 a4 01 00    	add    $0x1a4c4,%ebx
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100b42:	83 ec 08             	sub    $0x8,%esp
  100b45:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100b48:	50                   	push   %eax
  100b49:	ff 75 08             	pushl  0x8(%ebp)
  100b4c:	e8 ee fb ff ff       	call   10073f <debuginfo_eip>
  100b51:	83 c4 10             	add    $0x10,%esp
  100b54:	85 c0                	test   %eax,%eax
  100b56:	74 17                	je     100b6f <print_debuginfo+0x42>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100b58:	83 ec 08             	sub    $0x8,%esp
  100b5b:	ff 75 08             	pushl  0x8(%ebp)
  100b5e:	8d 83 86 b8 fe ff    	lea    -0x1477a(%ebx),%eax
  100b64:	50                   	push   %eax
  100b65:	e8 bf f7 ff ff       	call   100329 <cprintf>
  100b6a:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100b6d:	eb 67                	jmp    100bd6 <print_debuginfo+0xa9>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100b6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b76:	eb 1c                	jmp    100b94 <print_debuginfo+0x67>
            fnname[j] = info.eip_fn_name[j];
  100b78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b7e:	01 d0                	add    %edx,%eax
  100b80:	0f b6 00             	movzbl (%eax),%eax
  100b83:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b8c:	01 ca                	add    %ecx,%edx
  100b8e:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100b90:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b97:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100b9a:	7c dc                	jl     100b78 <print_debuginfo+0x4b>
        fnname[j] = '\0';
  100b9c:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ba5:	01 d0                	add    %edx,%eax
  100ba7:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100bad:	8b 55 08             	mov    0x8(%ebp),%edx
  100bb0:	89 d1                	mov    %edx,%ecx
  100bb2:	29 c1                	sub    %eax,%ecx
  100bb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100bb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100bba:	83 ec 0c             	sub    $0xc,%esp
  100bbd:	51                   	push   %ecx
  100bbe:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100bc4:	51                   	push   %ecx
  100bc5:	52                   	push   %edx
  100bc6:	50                   	push   %eax
  100bc7:	8d 83 a2 b8 fe ff    	lea    -0x1475e(%ebx),%eax
  100bcd:	50                   	push   %eax
  100bce:	e8 56 f7 ff ff       	call   100329 <cprintf>
  100bd3:	83 c4 20             	add    $0x20,%esp
}
  100bd6:	90                   	nop
  100bd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100bda:	c9                   	leave  
  100bdb:	c3                   	ret    

00100bdc <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100bdc:	55                   	push   %ebp
  100bdd:	89 e5                	mov    %esp,%ebp
  100bdf:	83 ec 10             	sub    $0x10,%esp
  100be2:	e8 cb f6 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  100be7:	05 19 a4 01 00       	add    $0x1a419,%eax
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100bec:	8b 45 04             	mov    0x4(%ebp),%eax
  100bef:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100bf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100bf5:	c9                   	leave  
  100bf6:	c3                   	ret    

00100bf7 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100bf7:	55                   	push   %ebp
  100bf8:	89 e5                	mov    %esp,%ebp
  100bfa:	53                   	push   %ebx
  100bfb:	83 ec 24             	sub    $0x24,%esp
  100bfe:	e8 b3 f6 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  100c03:	81 c3 fd a3 01 00    	add    $0x1a3fd,%ebx
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100c09:	89 e8                	mov    %ebp,%eax
  100c0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100c0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c14:	e8 c3 ff ff ff       	call   100bdc <read_eip>
  100c19:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100c1c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100c23:	e9 93 00 00 00       	jmp    100cbb <print_stackframe+0xc4>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100c28:	83 ec 04             	sub    $0x4,%esp
  100c2b:	ff 75 f0             	pushl  -0x10(%ebp)
  100c2e:	ff 75 f4             	pushl  -0xc(%ebp)
  100c31:	8d 83 b4 b8 fe ff    	lea    -0x1474c(%ebx),%eax
  100c37:	50                   	push   %eax
  100c38:	e8 ec f6 ff ff       	call   100329 <cprintf>
  100c3d:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
  100c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c43:	83 c0 08             	add    $0x8,%eax
  100c46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100c49:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100c50:	eb 28                	jmp    100c7a <print_stackframe+0x83>
            cprintf("0x%08x ", args[j]);
  100c52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100c55:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100c5f:	01 d0                	add    %edx,%eax
  100c61:	8b 00                	mov    (%eax),%eax
  100c63:	83 ec 08             	sub    $0x8,%esp
  100c66:	50                   	push   %eax
  100c67:	8d 83 d0 b8 fe ff    	lea    -0x14730(%ebx),%eax
  100c6d:	50                   	push   %eax
  100c6e:	e8 b6 f6 ff ff       	call   100329 <cprintf>
  100c73:	83 c4 10             	add    $0x10,%esp
        for (j = 0; j < 4; j ++) {
  100c76:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100c7a:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100c7e:	7e d2                	jle    100c52 <print_stackframe+0x5b>
        }
        cprintf("\n");
  100c80:	83 ec 0c             	sub    $0xc,%esp
  100c83:	8d 83 d8 b8 fe ff    	lea    -0x14728(%ebx),%eax
  100c89:	50                   	push   %eax
  100c8a:	e8 9a f6 ff ff       	call   100329 <cprintf>
  100c8f:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
  100c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100c95:	83 e8 01             	sub    $0x1,%eax
  100c98:	83 ec 0c             	sub    $0xc,%esp
  100c9b:	50                   	push   %eax
  100c9c:	e8 8c fe ff ff       	call   100b2d <print_debuginfo>
  100ca1:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
  100ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca7:	83 c0 04             	add    $0x4,%eax
  100caa:	8b 00                	mov    (%eax),%eax
  100cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cb2:	8b 00                	mov    (%eax),%eax
  100cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100cb7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100cbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cbf:	74 0a                	je     100ccb <print_stackframe+0xd4>
  100cc1:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100cc5:	0f 8e 5d ff ff ff    	jle    100c28 <print_stackframe+0x31>
    }
}
  100ccb:	90                   	nop
  100ccc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100ccf:	c9                   	leave  
  100cd0:	c3                   	ret    

00100cd1 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100cd1:	55                   	push   %ebp
  100cd2:	89 e5                	mov    %esp,%ebp
  100cd4:	53                   	push   %ebx
  100cd5:	83 ec 14             	sub    $0x14,%esp
  100cd8:	e8 d9 f5 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  100cdd:	81 c3 23 a3 01 00    	add    $0x1a323,%ebx
    int argc = 0;
  100ce3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100cea:	eb 0c                	jmp    100cf8 <parse+0x27>
            *buf ++ = '\0';
  100cec:	8b 45 08             	mov    0x8(%ebp),%eax
  100cef:	8d 50 01             	lea    0x1(%eax),%edx
  100cf2:	89 55 08             	mov    %edx,0x8(%ebp)
  100cf5:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  100cfb:	0f b6 00             	movzbl (%eax),%eax
  100cfe:	84 c0                	test   %al,%al
  100d00:	74 20                	je     100d22 <parse+0x51>
  100d02:	8b 45 08             	mov    0x8(%ebp),%eax
  100d05:	0f b6 00             	movzbl (%eax),%eax
  100d08:	0f be c0             	movsbl %al,%eax
  100d0b:	83 ec 08             	sub    $0x8,%esp
  100d0e:	50                   	push   %eax
  100d0f:	8d 83 5c b9 fe ff    	lea    -0x146a4(%ebx),%eax
  100d15:	50                   	push   %eax
  100d16:	e8 bc 4f 00 00       	call   105cd7 <strchr>
  100d1b:	83 c4 10             	add    $0x10,%esp
  100d1e:	85 c0                	test   %eax,%eax
  100d20:	75 ca                	jne    100cec <parse+0x1b>
        }
        if (*buf == '\0') {
  100d22:	8b 45 08             	mov    0x8(%ebp),%eax
  100d25:	0f b6 00             	movzbl (%eax),%eax
  100d28:	84 c0                	test   %al,%al
  100d2a:	74 69                	je     100d95 <parse+0xc4>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100d2c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100d30:	75 14                	jne    100d46 <parse+0x75>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100d32:	83 ec 08             	sub    $0x8,%esp
  100d35:	6a 10                	push   $0x10
  100d37:	8d 83 61 b9 fe ff    	lea    -0x1469f(%ebx),%eax
  100d3d:	50                   	push   %eax
  100d3e:	e8 e6 f5 ff ff       	call   100329 <cprintf>
  100d43:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d49:	8d 50 01             	lea    0x1(%eax),%edx
  100d4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100d4f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d59:	01 c2                	add    %eax,%edx
  100d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d5e:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100d60:	eb 04                	jmp    100d66 <parse+0x95>
            buf ++;
  100d62:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100d66:	8b 45 08             	mov    0x8(%ebp),%eax
  100d69:	0f b6 00             	movzbl (%eax),%eax
  100d6c:	84 c0                	test   %al,%al
  100d6e:	74 88                	je     100cf8 <parse+0x27>
  100d70:	8b 45 08             	mov    0x8(%ebp),%eax
  100d73:	0f b6 00             	movzbl (%eax),%eax
  100d76:	0f be c0             	movsbl %al,%eax
  100d79:	83 ec 08             	sub    $0x8,%esp
  100d7c:	50                   	push   %eax
  100d7d:	8d 83 5c b9 fe ff    	lea    -0x146a4(%ebx),%eax
  100d83:	50                   	push   %eax
  100d84:	e8 4e 4f 00 00       	call   105cd7 <strchr>
  100d89:	83 c4 10             	add    $0x10,%esp
  100d8c:	85 c0                	test   %eax,%eax
  100d8e:	74 d2                	je     100d62 <parse+0x91>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100d90:	e9 63 ff ff ff       	jmp    100cf8 <parse+0x27>
            break;
  100d95:	90                   	nop
        }
    }
    return argc;
  100d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100d99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100d9c:	c9                   	leave  
  100d9d:	c3                   	ret    

00100d9e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100d9e:	55                   	push   %ebp
  100d9f:	89 e5                	mov    %esp,%ebp
  100da1:	56                   	push   %esi
  100da2:	53                   	push   %ebx
  100da3:	83 ec 50             	sub    $0x50,%esp
  100da6:	e8 0b f5 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  100dab:	81 c3 55 a2 01 00    	add    $0x1a255,%ebx
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100db1:	83 ec 08             	sub    $0x8,%esp
  100db4:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100db7:	50                   	push   %eax
  100db8:	ff 75 08             	pushl  0x8(%ebp)
  100dbb:	e8 11 ff ff ff       	call   100cd1 <parse>
  100dc0:	83 c4 10             	add    $0x10,%esp
  100dc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100dc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100dca:	75 0a                	jne    100dd6 <runcmd+0x38>
        return 0;
  100dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  100dd1:	e9 8b 00 00 00       	jmp    100e61 <runcmd+0xc3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100dd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ddd:	eb 5f                	jmp    100e3e <runcmd+0xa0>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100ddf:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100de2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100de5:	8d b3 20 00 00 00    	lea    0x20(%ebx),%esi
  100deb:	89 d0                	mov    %edx,%eax
  100ded:	01 c0                	add    %eax,%eax
  100def:	01 d0                	add    %edx,%eax
  100df1:	c1 e0 02             	shl    $0x2,%eax
  100df4:	01 f0                	add    %esi,%eax
  100df6:	8b 00                	mov    (%eax),%eax
  100df8:	83 ec 08             	sub    $0x8,%esp
  100dfb:	51                   	push   %ecx
  100dfc:	50                   	push   %eax
  100dfd:	e8 21 4e 00 00       	call   105c23 <strcmp>
  100e02:	83 c4 10             	add    $0x10,%esp
  100e05:	85 c0                	test   %eax,%eax
  100e07:	75 31                	jne    100e3a <runcmd+0x9c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100e0c:	8d 8b 28 00 00 00    	lea    0x28(%ebx),%ecx
  100e12:	89 d0                	mov    %edx,%eax
  100e14:	01 c0                	add    %eax,%eax
  100e16:	01 d0                	add    %edx,%eax
  100e18:	c1 e0 02             	shl    $0x2,%eax
  100e1b:	01 c8                	add    %ecx,%eax
  100e1d:	8b 10                	mov    (%eax),%edx
  100e1f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100e22:	83 c0 04             	add    $0x4,%eax
  100e25:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100e28:	83 e9 01             	sub    $0x1,%ecx
  100e2b:	83 ec 04             	sub    $0x4,%esp
  100e2e:	ff 75 0c             	pushl  0xc(%ebp)
  100e31:	50                   	push   %eax
  100e32:	51                   	push   %ecx
  100e33:	ff d2                	call   *%edx
  100e35:	83 c4 10             	add    $0x10,%esp
  100e38:	eb 27                	jmp    100e61 <runcmd+0xc3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100e3a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e41:	83 f8 02             	cmp    $0x2,%eax
  100e44:	76 99                	jbe    100ddf <runcmd+0x41>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100e46:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100e49:	83 ec 08             	sub    $0x8,%esp
  100e4c:	50                   	push   %eax
  100e4d:	8d 83 7f b9 fe ff    	lea    -0x14681(%ebx),%eax
  100e53:	50                   	push   %eax
  100e54:	e8 d0 f4 ff ff       	call   100329 <cprintf>
  100e59:	83 c4 10             	add    $0x10,%esp
    return 0;
  100e5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  100e64:	5b                   	pop    %ebx
  100e65:	5e                   	pop    %esi
  100e66:	5d                   	pop    %ebp
  100e67:	c3                   	ret    

00100e68 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100e68:	55                   	push   %ebp
  100e69:	89 e5                	mov    %esp,%ebp
  100e6b:	53                   	push   %ebx
  100e6c:	83 ec 14             	sub    $0x14,%esp
  100e6f:	e8 42 f4 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  100e74:	81 c3 8c a1 01 00    	add    $0x1a18c,%ebx
    cprintf("Welcome to the kernel debug monitor!!\n");
  100e7a:	83 ec 0c             	sub    $0xc,%esp
  100e7d:	8d 83 98 b9 fe ff    	lea    -0x14668(%ebx),%eax
  100e83:	50                   	push   %eax
  100e84:	e8 a0 f4 ff ff       	call   100329 <cprintf>
  100e89:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100e8c:	83 ec 0c             	sub    $0xc,%esp
  100e8f:	8d 83 c0 b9 fe ff    	lea    -0x14640(%ebx),%eax
  100e95:	50                   	push   %eax
  100e96:	e8 8e f4 ff ff       	call   100329 <cprintf>
  100e9b:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100e9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ea2:	74 0e                	je     100eb2 <kmonitor+0x4a>
        print_trapframe(tf);
  100ea4:	83 ec 0c             	sub    $0xc,%esp
  100ea7:	ff 75 08             	pushl  0x8(%ebp)
  100eaa:	e8 a5 0f 00 00       	call   101e54 <print_trapframe>
  100eaf:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100eb2:	83 ec 0c             	sub    $0xc,%esp
  100eb5:	8d 83 e5 b9 fe ff    	lea    -0x1461b(%ebx),%eax
  100ebb:	50                   	push   %eax
  100ebc:	e8 40 f5 ff ff       	call   100401 <readline>
  100ec1:	83 c4 10             	add    $0x10,%esp
  100ec4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ec7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ecb:	74 e5                	je     100eb2 <kmonitor+0x4a>
            if (runcmd(buf, tf) < 0) {
  100ecd:	83 ec 08             	sub    $0x8,%esp
  100ed0:	ff 75 08             	pushl  0x8(%ebp)
  100ed3:	ff 75 f4             	pushl  -0xc(%ebp)
  100ed6:	e8 c3 fe ff ff       	call   100d9e <runcmd>
  100edb:	83 c4 10             	add    $0x10,%esp
  100ede:	85 c0                	test   %eax,%eax
  100ee0:	78 02                	js     100ee4 <kmonitor+0x7c>
        if ((buf = readline("K> ")) != NULL) {
  100ee2:	eb ce                	jmp    100eb2 <kmonitor+0x4a>
                break;
  100ee4:	90                   	nop
            }
        }
    }
}
  100ee5:	90                   	nop
  100ee6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100ee9:	c9                   	leave  
  100eea:	c3                   	ret    

00100eeb <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100eeb:	55                   	push   %ebp
  100eec:	89 e5                	mov    %esp,%ebp
  100eee:	56                   	push   %esi
  100eef:	53                   	push   %ebx
  100ef0:	83 ec 10             	sub    $0x10,%esp
  100ef3:	e8 be f3 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  100ef8:	81 c3 08 a1 01 00    	add    $0x1a108,%ebx
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100efe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100f05:	eb 44                	jmp    100f4b <mon_help+0x60>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100f0a:	8d 8b 24 00 00 00    	lea    0x24(%ebx),%ecx
  100f10:	89 d0                	mov    %edx,%eax
  100f12:	01 c0                	add    %eax,%eax
  100f14:	01 d0                	add    %edx,%eax
  100f16:	c1 e0 02             	shl    $0x2,%eax
  100f19:	01 c8                	add    %ecx,%eax
  100f1b:	8b 08                	mov    (%eax),%ecx
  100f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100f20:	8d b3 20 00 00 00    	lea    0x20(%ebx),%esi
  100f26:	89 d0                	mov    %edx,%eax
  100f28:	01 c0                	add    %eax,%eax
  100f2a:	01 d0                	add    %edx,%eax
  100f2c:	c1 e0 02             	shl    $0x2,%eax
  100f2f:	01 f0                	add    %esi,%eax
  100f31:	8b 00                	mov    (%eax),%eax
  100f33:	83 ec 04             	sub    $0x4,%esp
  100f36:	51                   	push   %ecx
  100f37:	50                   	push   %eax
  100f38:	8d 83 e9 b9 fe ff    	lea    -0x14617(%ebx),%eax
  100f3e:	50                   	push   %eax
  100f3f:	e8 e5 f3 ff ff       	call   100329 <cprintf>
  100f44:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100f47:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f4e:	83 f8 02             	cmp    $0x2,%eax
  100f51:	76 b4                	jbe    100f07 <mon_help+0x1c>
    }
    return 0;
  100f53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100f58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  100f5b:	5b                   	pop    %ebx
  100f5c:	5e                   	pop    %esi
  100f5d:	5d                   	pop    %ebp
  100f5e:	c3                   	ret    

00100f5f <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100f5f:	55                   	push   %ebp
  100f60:	89 e5                	mov    %esp,%ebp
  100f62:	53                   	push   %ebx
  100f63:	83 ec 04             	sub    $0x4,%esp
  100f66:	e8 47 f3 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  100f6b:	05 95 a0 01 00       	add    $0x1a095,%eax
    print_kerninfo();
  100f70:	89 c3                	mov    %eax,%ebx
  100f72:	e8 f1 fa ff ff       	call   100a68 <print_kerninfo>
    return 0;
  100f77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100f7c:	83 c4 04             	add    $0x4,%esp
  100f7f:	5b                   	pop    %ebx
  100f80:	5d                   	pop    %ebp
  100f81:	c3                   	ret    

00100f82 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100f82:	55                   	push   %ebp
  100f83:	89 e5                	mov    %esp,%ebp
  100f85:	53                   	push   %ebx
  100f86:	83 ec 04             	sub    $0x4,%esp
  100f89:	e8 24 f3 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  100f8e:	05 72 a0 01 00       	add    $0x1a072,%eax
    print_stackframe();
  100f93:	89 c3                	mov    %eax,%ebx
  100f95:	e8 5d fc ff ff       	call   100bf7 <print_stackframe>
    return 0;
  100f9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100f9f:	83 c4 04             	add    $0x4,%esp
  100fa2:	5b                   	pop    %ebx
  100fa3:	5d                   	pop    %ebp
  100fa4:	c3                   	ret    

00100fa5 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100fa5:	55                   	push   %ebp
  100fa6:	89 e5                	mov    %esp,%ebp
  100fa8:	53                   	push   %ebx
  100fa9:	83 ec 14             	sub    $0x14,%esp
  100fac:	e8 05 f3 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  100fb1:	81 c3 4f a0 01 00    	add    $0x1a04f,%ebx
  100fb7:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100fbd:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fc1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100fc5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fc9:	ee                   	out    %al,(%dx)
  100fca:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100fd0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100fd4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fd8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100fdc:	ee                   	out    %al,(%dx)
  100fdd:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100fe3:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100fe7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100feb:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100fef:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100ff0:	c7 c0 ac c0 11 00    	mov    $0x11c0ac,%eax
  100ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("++ setup timer interrupts\n");
  100ffc:	83 ec 0c             	sub    $0xc,%esp
  100fff:	8d 83 f2 b9 fe ff    	lea    -0x1460e(%ebx),%eax
  101005:	50                   	push   %eax
  101006:	e8 1e f3 ff ff       	call   100329 <cprintf>
  10100b:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  10100e:	83 ec 0c             	sub    $0xc,%esp
  101011:	6a 00                	push   $0x0
  101013:	e8 76 0a 00 00       	call   101a8e <pic_enable>
  101018:	83 c4 10             	add    $0x10,%esp
}
  10101b:	90                   	nop
  10101c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10101f:	c9                   	leave  
  101020:	c3                   	ret    

00101021 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  101021:	55                   	push   %ebp
  101022:	89 e5                	mov    %esp,%ebp
  101024:	53                   	push   %ebx
  101025:	83 ec 14             	sub    $0x14,%esp
  101028:	e8 85 f2 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  10102d:	05 d3 9f 01 00       	add    $0x19fd3,%eax
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  101032:	9c                   	pushf  
  101033:	5a                   	pop    %edx
  101034:	89 55 f4             	mov    %edx,-0xc(%ebp)
    return eflags;
  101037:	8b 55 f4             	mov    -0xc(%ebp),%edx
    if (read_eflags() & FL_IF) {
  10103a:	81 e2 00 02 00 00    	and    $0x200,%edx
  101040:	85 d2                	test   %edx,%edx
  101042:	74 0e                	je     101052 <__intr_save+0x31>
        intr_disable();
  101044:	89 c3                	mov    %eax,%ebx
  101046:	e8 d5 0b 00 00       	call   101c20 <intr_disable>
        return 1;
  10104b:	b8 01 00 00 00       	mov    $0x1,%eax
  101050:	eb 05                	jmp    101057 <__intr_save+0x36>
    }
    return 0;
  101052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101057:	83 c4 14             	add    $0x14,%esp
  10105a:	5b                   	pop    %ebx
  10105b:	5d                   	pop    %ebp
  10105c:	c3                   	ret    

0010105d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  10105d:	55                   	push   %ebp
  10105e:	89 e5                	mov    %esp,%ebp
  101060:	53                   	push   %ebx
  101061:	83 ec 04             	sub    $0x4,%esp
  101064:	e8 49 f2 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  101069:	05 97 9f 01 00       	add    $0x19f97,%eax
    if (flag) {
  10106e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  101072:	74 07                	je     10107b <__intr_restore+0x1e>
        intr_enable();
  101074:	89 c3                	mov    %eax,%ebx
  101076:	e8 94 0b 00 00       	call   101c0f <intr_enable>
    }
}
  10107b:	90                   	nop
  10107c:	83 c4 04             	add    $0x4,%esp
  10107f:	5b                   	pop    %ebx
  101080:	5d                   	pop    %ebp
  101081:	c3                   	ret    

00101082 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  101082:	55                   	push   %ebp
  101083:	89 e5                	mov    %esp,%ebp
  101085:	83 ec 10             	sub    $0x10,%esp
  101088:	e8 25 f2 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  10108d:	05 73 9f 01 00       	add    $0x19f73,%eax
  101092:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101098:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10109c:	89 c2                	mov    %eax,%edx
  10109e:	ec                   	in     (%dx),%al
  10109f:	88 45 f1             	mov    %al,-0xf(%ebp)
  1010a2:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  1010a8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1010ac:	89 c2                	mov    %eax,%edx
  1010ae:	ec                   	in     (%dx),%al
  1010af:	88 45 f5             	mov    %al,-0xb(%ebp)
  1010b2:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  1010b8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010bc:	89 c2                	mov    %eax,%edx
  1010be:	ec                   	in     (%dx),%al
  1010bf:	88 45 f9             	mov    %al,-0x7(%ebp)
  1010c2:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  1010c8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1010cc:	89 c2                	mov    %eax,%edx
  1010ce:	ec                   	in     (%dx),%al
  1010cf:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  1010d2:	90                   	nop
  1010d3:	c9                   	leave  
  1010d4:	c3                   	ret    

001010d5 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  1010d5:	55                   	push   %ebp
  1010d6:	89 e5                	mov    %esp,%ebp
  1010d8:	83 ec 20             	sub    $0x20,%esp
  1010db:	e8 45 09 00 00       	call   101a25 <__x86.get_pc_thunk.cx>
  1010e0:	81 c1 20 9f 01 00    	add    $0x19f20,%ecx
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  1010e6:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  1010ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1010f0:	0f b7 00             	movzwl (%eax),%eax
  1010f3:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  1010f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1010fa:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  1010ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101102:	0f b7 00             	movzwl (%eax),%eax
  101105:	66 3d 5a a5          	cmp    $0xa55a,%ax
  101109:	74 12                	je     10111d <cga_init+0x48>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  10110b:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  101112:	66 c7 81 e6 05 00 00 	movw   $0x3b4,0x5e6(%ecx)
  101119:	b4 03 
  10111b:	eb 13                	jmp    101130 <cga_init+0x5b>
    } else {
        *cp = was;
  10111d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101120:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101124:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  101127:	66 c7 81 e6 05 00 00 	movw   $0x3d4,0x5e6(%ecx)
  10112e:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  101130:	0f b7 81 e6 05 00 00 	movzwl 0x5e6(%ecx),%eax
  101137:	0f b7 c0             	movzwl %ax,%eax
  10113a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10113e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101142:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101146:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10114a:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  10114b:	0f b7 81 e6 05 00 00 	movzwl 0x5e6(%ecx),%eax
  101152:	83 c0 01             	add    $0x1,%eax
  101155:	0f b7 c0             	movzwl %ax,%eax
  101158:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10115c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  101160:	89 c2                	mov    %eax,%edx
  101162:	ec                   	in     (%dx),%al
  101163:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  101166:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10116a:	0f b6 c0             	movzbl %al,%eax
  10116d:	c1 e0 08             	shl    $0x8,%eax
  101170:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  101173:	0f b7 81 e6 05 00 00 	movzwl 0x5e6(%ecx),%eax
  10117a:	0f b7 c0             	movzwl %ax,%eax
  10117d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101181:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101185:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101189:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10118d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  10118e:	0f b7 81 e6 05 00 00 	movzwl 0x5e6(%ecx),%eax
  101195:	83 c0 01             	add    $0x1,%eax
  101198:	0f b7 c0             	movzwl %ax,%eax
  10119b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10119f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1011a3:	89 c2                	mov    %eax,%edx
  1011a5:	ec                   	in     (%dx),%al
  1011a6:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  1011a9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011ad:	0f b6 c0             	movzbl %al,%eax
  1011b0:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  1011b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1011b6:	89 81 e0 05 00 00    	mov    %eax,0x5e0(%ecx)
    crt_pos = pos;
  1011bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1011bf:	66 89 81 e4 05 00 00 	mov    %ax,0x5e4(%ecx)
}
  1011c6:	90                   	nop
  1011c7:	c9                   	leave  
  1011c8:	c3                   	ret    

001011c9 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  1011c9:	55                   	push   %ebp
  1011ca:	89 e5                	mov    %esp,%ebp
  1011cc:	53                   	push   %ebx
  1011cd:	83 ec 34             	sub    $0x34,%esp
  1011d0:	e8 50 08 00 00       	call   101a25 <__x86.get_pc_thunk.cx>
  1011d5:	81 c1 2b 9e 01 00    	add    $0x19e2b,%ecx
  1011db:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  1011e1:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1011e5:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1011e9:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1011ed:	ee                   	out    %al,(%dx)
  1011ee:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  1011f4:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  1011f8:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1011fc:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101200:	ee                   	out    %al,(%dx)
  101201:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  101207:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  10120b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10120f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101213:	ee                   	out    %al,(%dx)
  101214:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  10121a:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  10121e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101222:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101226:	ee                   	out    %al,(%dx)
  101227:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  10122d:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  101231:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101235:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101239:	ee                   	out    %al,(%dx)
  10123a:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101240:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  101244:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101248:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10124c:	ee                   	out    %al,(%dx)
  10124d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101253:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  101257:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10125b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10125f:	ee                   	out    %al,(%dx)
  101260:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101266:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10126a:	89 c2                	mov    %eax,%edx
  10126c:	ec                   	in     (%dx),%al
  10126d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101270:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101274:	3c ff                	cmp    $0xff,%al
  101276:	0f 95 c0             	setne  %al
  101279:	0f b6 c0             	movzbl %al,%eax
  10127c:	89 81 e8 05 00 00    	mov    %eax,0x5e8(%ecx)
  101282:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101288:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10128c:	89 c2                	mov    %eax,%edx
  10128e:	ec                   	in     (%dx),%al
  10128f:	88 45 f1             	mov    %al,-0xf(%ebp)
  101292:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101298:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10129c:	89 c2                	mov    %eax,%edx
  10129e:	ec                   	in     (%dx),%al
  10129f:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  1012a2:	8b 81 e8 05 00 00    	mov    0x5e8(%ecx),%eax
  1012a8:	85 c0                	test   %eax,%eax
  1012aa:	74 0f                	je     1012bb <serial_init+0xf2>
        pic_enable(IRQ_COM1);
  1012ac:	83 ec 0c             	sub    $0xc,%esp
  1012af:	6a 04                	push   $0x4
  1012b1:	89 cb                	mov    %ecx,%ebx
  1012b3:	e8 d6 07 00 00       	call   101a8e <pic_enable>
  1012b8:	83 c4 10             	add    $0x10,%esp
    }
}
  1012bb:	90                   	nop
  1012bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1012bf:	c9                   	leave  
  1012c0:	c3                   	ret    

001012c1 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1012c1:	55                   	push   %ebp
  1012c2:	89 e5                	mov    %esp,%ebp
  1012c4:	83 ec 20             	sub    $0x20,%esp
  1012c7:	e8 e6 ef ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1012cc:	05 34 9d 01 00       	add    $0x19d34,%eax
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1012d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d8:	eb 09                	jmp    1012e3 <lpt_putc_sub+0x22>
        delay();
  1012da:	e8 a3 fd ff ff       	call   101082 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1012df:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012e3:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1012e9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012ed:	89 c2                	mov    %eax,%edx
  1012ef:	ec                   	in     (%dx),%al
  1012f0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012f3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012f7:	84 c0                	test   %al,%al
  1012f9:	78 09                	js     101304 <lpt_putc_sub+0x43>
  1012fb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101302:	7e d6                	jle    1012da <lpt_putc_sub+0x19>
    }
    outb(LPTPORT + 0, c);
  101304:	8b 45 08             	mov    0x8(%ebp),%eax
  101307:	0f b6 c0             	movzbl %al,%eax
  10130a:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101310:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101313:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101317:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10131b:	ee                   	out    %al,(%dx)
  10131c:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101322:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101326:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10132a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10132e:	ee                   	out    %al,(%dx)
  10132f:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101335:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  101339:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10133d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101341:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101342:	90                   	nop
  101343:	c9                   	leave  
  101344:	c3                   	ret    

00101345 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101345:	55                   	push   %ebp
  101346:	89 e5                	mov    %esp,%ebp
  101348:	e8 65 ef ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  10134d:	05 b3 9c 01 00       	add    $0x19cb3,%eax
    if (c != '\b') {
  101352:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101356:	74 0d                	je     101365 <lpt_putc+0x20>
        lpt_putc_sub(c);
  101358:	ff 75 08             	pushl  0x8(%ebp)
  10135b:	e8 61 ff ff ff       	call   1012c1 <lpt_putc_sub>
  101360:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101363:	eb 1e                	jmp    101383 <lpt_putc+0x3e>
        lpt_putc_sub('\b');
  101365:	6a 08                	push   $0x8
  101367:	e8 55 ff ff ff       	call   1012c1 <lpt_putc_sub>
  10136c:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  10136f:	6a 20                	push   $0x20
  101371:	e8 4b ff ff ff       	call   1012c1 <lpt_putc_sub>
  101376:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101379:	6a 08                	push   $0x8
  10137b:	e8 41 ff ff ff       	call   1012c1 <lpt_putc_sub>
  101380:	83 c4 04             	add    $0x4,%esp
}
  101383:	90                   	nop
  101384:	c9                   	leave  
  101385:	c3                   	ret    

00101386 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101386:	55                   	push   %ebp
  101387:	89 e5                	mov    %esp,%ebp
  101389:	56                   	push   %esi
  10138a:	53                   	push   %ebx
  10138b:	83 ec 20             	sub    $0x20,%esp
  10138e:	e8 23 ef ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  101393:	81 c3 6d 9c 01 00    	add    $0x19c6d,%ebx
    // set black on white
    if (!(c & ~0xFF)) {
  101399:	8b 45 08             	mov    0x8(%ebp),%eax
  10139c:	b0 00                	mov    $0x0,%al
  10139e:	85 c0                	test   %eax,%eax
  1013a0:	75 07                	jne    1013a9 <cga_putc+0x23>
        c |= 0x0700;
  1013a2:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1013ac:	0f b6 c0             	movzbl %al,%eax
  1013af:	83 f8 0a             	cmp    $0xa,%eax
  1013b2:	74 54                	je     101408 <cga_putc+0x82>
  1013b4:	83 f8 0d             	cmp    $0xd,%eax
  1013b7:	74 60                	je     101419 <cga_putc+0x93>
  1013b9:	83 f8 08             	cmp    $0x8,%eax
  1013bc:	0f 85 92 00 00 00    	jne    101454 <cga_putc+0xce>
    case '\b':
        if (crt_pos > 0) {
  1013c2:	0f b7 83 e4 05 00 00 	movzwl 0x5e4(%ebx),%eax
  1013c9:	66 85 c0             	test   %ax,%ax
  1013cc:	0f 84 a8 00 00 00    	je     10147a <cga_putc+0xf4>
            crt_pos --;
  1013d2:	0f b7 83 e4 05 00 00 	movzwl 0x5e4(%ebx),%eax
  1013d9:	83 e8 01             	sub    $0x1,%eax
  1013dc:	66 89 83 e4 05 00 00 	mov    %ax,0x5e4(%ebx)
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1013e6:	b0 00                	mov    $0x0,%al
  1013e8:	83 c8 20             	or     $0x20,%eax
  1013eb:	89 c1                	mov    %eax,%ecx
  1013ed:	8b 83 e0 05 00 00    	mov    0x5e0(%ebx),%eax
  1013f3:	0f b7 93 e4 05 00 00 	movzwl 0x5e4(%ebx),%edx
  1013fa:	0f b7 d2             	movzwl %dx,%edx
  1013fd:	01 d2                	add    %edx,%edx
  1013ff:	01 d0                	add    %edx,%eax
  101401:	89 ca                	mov    %ecx,%edx
  101403:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  101406:	eb 72                	jmp    10147a <cga_putc+0xf4>
    case '\n':
        crt_pos += CRT_COLS;
  101408:	0f b7 83 e4 05 00 00 	movzwl 0x5e4(%ebx),%eax
  10140f:	83 c0 50             	add    $0x50,%eax
  101412:	66 89 83 e4 05 00 00 	mov    %ax,0x5e4(%ebx)
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101419:	0f b7 b3 e4 05 00 00 	movzwl 0x5e4(%ebx),%esi
  101420:	0f b7 8b e4 05 00 00 	movzwl 0x5e4(%ebx),%ecx
  101427:	0f b7 c1             	movzwl %cx,%eax
  10142a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101430:	c1 e8 10             	shr    $0x10,%eax
  101433:	89 c2                	mov    %eax,%edx
  101435:	66 c1 ea 06          	shr    $0x6,%dx
  101439:	89 d0                	mov    %edx,%eax
  10143b:	c1 e0 02             	shl    $0x2,%eax
  10143e:	01 d0                	add    %edx,%eax
  101440:	c1 e0 04             	shl    $0x4,%eax
  101443:	29 c1                	sub    %eax,%ecx
  101445:	89 ca                	mov    %ecx,%edx
  101447:	89 f0                	mov    %esi,%eax
  101449:	29 d0                	sub    %edx,%eax
  10144b:	66 89 83 e4 05 00 00 	mov    %ax,0x5e4(%ebx)
        break;
  101452:	eb 27                	jmp    10147b <cga_putc+0xf5>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101454:	8b 8b e0 05 00 00    	mov    0x5e0(%ebx),%ecx
  10145a:	0f b7 83 e4 05 00 00 	movzwl 0x5e4(%ebx),%eax
  101461:	8d 50 01             	lea    0x1(%eax),%edx
  101464:	66 89 93 e4 05 00 00 	mov    %dx,0x5e4(%ebx)
  10146b:	0f b7 c0             	movzwl %ax,%eax
  10146e:	01 c0                	add    %eax,%eax
  101470:	01 c8                	add    %ecx,%eax
  101472:	8b 55 08             	mov    0x8(%ebp),%edx
  101475:	66 89 10             	mov    %dx,(%eax)
        break;
  101478:	eb 01                	jmp    10147b <cga_putc+0xf5>
        break;
  10147a:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10147b:	0f b7 83 e4 05 00 00 	movzwl 0x5e4(%ebx),%eax
  101482:	66 3d cf 07          	cmp    $0x7cf,%ax
  101486:	76 5d                	jbe    1014e5 <cga_putc+0x15f>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101488:	8b 83 e0 05 00 00    	mov    0x5e0(%ebx),%eax
  10148e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101494:	8b 83 e0 05 00 00    	mov    0x5e0(%ebx),%eax
  10149a:	83 ec 04             	sub    $0x4,%esp
  10149d:	68 00 0f 00 00       	push   $0xf00
  1014a2:	52                   	push   %edx
  1014a3:	50                   	push   %eax
  1014a4:	e8 55 4a 00 00       	call   105efe <memmove>
  1014a9:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1014ac:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1014b3:	eb 16                	jmp    1014cb <cga_putc+0x145>
            crt_buf[i] = 0x0700 | ' ';
  1014b5:	8b 83 e0 05 00 00    	mov    0x5e0(%ebx),%eax
  1014bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1014be:	01 d2                	add    %edx,%edx
  1014c0:	01 d0                	add    %edx,%eax
  1014c2:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1014c7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1014cb:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1014d2:	7e e1                	jle    1014b5 <cga_putc+0x12f>
        }
        crt_pos -= CRT_COLS;
  1014d4:	0f b7 83 e4 05 00 00 	movzwl 0x5e4(%ebx),%eax
  1014db:	83 e8 50             	sub    $0x50,%eax
  1014de:	66 89 83 e4 05 00 00 	mov    %ax,0x5e4(%ebx)
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1014e5:	0f b7 83 e6 05 00 00 	movzwl 0x5e6(%ebx),%eax
  1014ec:	0f b7 c0             	movzwl %ax,%eax
  1014ef:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1014f3:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  1014f7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1014fb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1014ff:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101500:	0f b7 83 e4 05 00 00 	movzwl 0x5e4(%ebx),%eax
  101507:	66 c1 e8 08          	shr    $0x8,%ax
  10150b:	0f b6 c0             	movzbl %al,%eax
  10150e:	0f b7 93 e6 05 00 00 	movzwl 0x5e6(%ebx),%edx
  101515:	83 c2 01             	add    $0x1,%edx
  101518:	0f b7 d2             	movzwl %dx,%edx
  10151b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10151f:	88 45 e9             	mov    %al,-0x17(%ebp)
  101522:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101526:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10152a:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10152b:	0f b7 83 e6 05 00 00 	movzwl 0x5e6(%ebx),%eax
  101532:	0f b7 c0             	movzwl %ax,%eax
  101535:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101539:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  10153d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101541:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101545:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101546:	0f b7 83 e4 05 00 00 	movzwl 0x5e4(%ebx),%eax
  10154d:	0f b6 c0             	movzbl %al,%eax
  101550:	0f b7 93 e6 05 00 00 	movzwl 0x5e6(%ebx),%edx
  101557:	83 c2 01             	add    $0x1,%edx
  10155a:	0f b7 d2             	movzwl %dx,%edx
  10155d:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101561:	88 45 f1             	mov    %al,-0xf(%ebp)
  101564:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101568:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10156c:	ee                   	out    %al,(%dx)
}
  10156d:	90                   	nop
  10156e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  101571:	5b                   	pop    %ebx
  101572:	5e                   	pop    %esi
  101573:	5d                   	pop    %ebp
  101574:	c3                   	ret    

00101575 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101575:	55                   	push   %ebp
  101576:	89 e5                	mov    %esp,%ebp
  101578:	83 ec 10             	sub    $0x10,%esp
  10157b:	e8 32 ed ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  101580:	05 80 9a 01 00       	add    $0x19a80,%eax
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101585:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10158c:	eb 09                	jmp    101597 <serial_putc_sub+0x22>
        delay();
  10158e:	e8 ef fa ff ff       	call   101082 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101593:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101597:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10159d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1015a1:	89 c2                	mov    %eax,%edx
  1015a3:	ec                   	in     (%dx),%al
  1015a4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1015a7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1015ab:	0f b6 c0             	movzbl %al,%eax
  1015ae:	83 e0 20             	and    $0x20,%eax
  1015b1:	85 c0                	test   %eax,%eax
  1015b3:	75 09                	jne    1015be <serial_putc_sub+0x49>
  1015b5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1015bc:	7e d0                	jle    10158e <serial_putc_sub+0x19>
    }
    outb(COM1 + COM_TX, c);
  1015be:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c1:	0f b6 c0             	movzbl %al,%eax
  1015c4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1015ca:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015cd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1015d1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1015d5:	ee                   	out    %al,(%dx)
}
  1015d6:	90                   	nop
  1015d7:	c9                   	leave  
  1015d8:	c3                   	ret    

001015d9 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1015d9:	55                   	push   %ebp
  1015da:	89 e5                	mov    %esp,%ebp
  1015dc:	e8 d1 ec ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1015e1:	05 1f 9a 01 00       	add    $0x19a1f,%eax
    if (c != '\b') {
  1015e6:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1015ea:	74 0d                	je     1015f9 <serial_putc+0x20>
        serial_putc_sub(c);
  1015ec:	ff 75 08             	pushl  0x8(%ebp)
  1015ef:	e8 81 ff ff ff       	call   101575 <serial_putc_sub>
  1015f4:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1015f7:	eb 1e                	jmp    101617 <serial_putc+0x3e>
        serial_putc_sub('\b');
  1015f9:	6a 08                	push   $0x8
  1015fb:	e8 75 ff ff ff       	call   101575 <serial_putc_sub>
  101600:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101603:	6a 20                	push   $0x20
  101605:	e8 6b ff ff ff       	call   101575 <serial_putc_sub>
  10160a:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  10160d:	6a 08                	push   $0x8
  10160f:	e8 61 ff ff ff       	call   101575 <serial_putc_sub>
  101614:	83 c4 04             	add    $0x4,%esp
}
  101617:	90                   	nop
  101618:	c9                   	leave  
  101619:	c3                   	ret    

0010161a <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10161a:	55                   	push   %ebp
  10161b:	89 e5                	mov    %esp,%ebp
  10161d:	53                   	push   %ebx
  10161e:	83 ec 14             	sub    $0x14,%esp
  101621:	e8 90 ec ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  101626:	81 c3 da 99 01 00    	add    $0x199da,%ebx
    int c;
    while ((c = (*proc)()) != -1) {
  10162c:	eb 36                	jmp    101664 <cons_intr+0x4a>
        if (c != 0) {
  10162e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101632:	74 30                	je     101664 <cons_intr+0x4a>
            cons.buf[cons.wpos ++] = c;
  101634:	8b 83 04 08 00 00    	mov    0x804(%ebx),%eax
  10163a:	8d 50 01             	lea    0x1(%eax),%edx
  10163d:	89 93 04 08 00 00    	mov    %edx,0x804(%ebx)
  101643:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101646:	88 94 03 00 06 00 00 	mov    %dl,0x600(%ebx,%eax,1)
            if (cons.wpos == CONSBUFSIZE) {
  10164d:	8b 83 04 08 00 00    	mov    0x804(%ebx),%eax
  101653:	3d 00 02 00 00       	cmp    $0x200,%eax
  101658:	75 0a                	jne    101664 <cons_intr+0x4a>
                cons.wpos = 0;
  10165a:	c7 83 04 08 00 00 00 	movl   $0x0,0x804(%ebx)
  101661:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101664:	8b 45 08             	mov    0x8(%ebp),%eax
  101667:	ff d0                	call   *%eax
  101669:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10166c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101670:	75 bc                	jne    10162e <cons_intr+0x14>
            }
        }
    }
}
  101672:	90                   	nop
  101673:	83 c4 14             	add    $0x14,%esp
  101676:	5b                   	pop    %ebx
  101677:	5d                   	pop    %ebp
  101678:	c3                   	ret    

00101679 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101679:	55                   	push   %ebp
  10167a:	89 e5                	mov    %esp,%ebp
  10167c:	83 ec 10             	sub    $0x10,%esp
  10167f:	e8 2e ec ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  101684:	05 7c 99 01 00       	add    $0x1997c,%eax
  101689:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10168f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101693:	89 c2                	mov    %eax,%edx
  101695:	ec                   	in     (%dx),%al
  101696:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101699:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10169d:	0f b6 c0             	movzbl %al,%eax
  1016a0:	83 e0 01             	and    $0x1,%eax
  1016a3:	85 c0                	test   %eax,%eax
  1016a5:	75 07                	jne    1016ae <serial_proc_data+0x35>
        return -1;
  1016a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1016ac:	eb 2a                	jmp    1016d8 <serial_proc_data+0x5f>
  1016ae:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1016b4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1016b8:	89 c2                	mov    %eax,%edx
  1016ba:	ec                   	in     (%dx),%al
  1016bb:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1016be:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1016c2:	0f b6 c0             	movzbl %al,%eax
  1016c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1016c8:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1016cc:	75 07                	jne    1016d5 <serial_proc_data+0x5c>
        c = '\b';
  1016ce:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1016d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1016d8:	c9                   	leave  
  1016d9:	c3                   	ret    

001016da <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1016da:	55                   	push   %ebp
  1016db:	89 e5                	mov    %esp,%ebp
  1016dd:	83 ec 08             	sub    $0x8,%esp
  1016e0:	e8 cd eb ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1016e5:	05 1b 99 01 00       	add    $0x1991b,%eax
    if (serial_exists) {
  1016ea:	8b 90 e8 05 00 00    	mov    0x5e8(%eax),%edx
  1016f0:	85 d2                	test   %edx,%edx
  1016f2:	74 12                	je     101706 <serial_intr+0x2c>
        cons_intr(serial_proc_data);
  1016f4:	83 ec 0c             	sub    $0xc,%esp
  1016f7:	8d 80 79 66 fe ff    	lea    -0x19987(%eax),%eax
  1016fd:	50                   	push   %eax
  1016fe:	e8 17 ff ff ff       	call   10161a <cons_intr>
  101703:	83 c4 10             	add    $0x10,%esp
    }
}
  101706:	90                   	nop
  101707:	c9                   	leave  
  101708:	c3                   	ret    

00101709 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101709:	55                   	push   %ebp
  10170a:	89 e5                	mov    %esp,%ebp
  10170c:	53                   	push   %ebx
  10170d:	83 ec 24             	sub    $0x24,%esp
  101710:	e8 10 03 00 00       	call   101a25 <__x86.get_pc_thunk.cx>
  101715:	81 c1 eb 98 01 00    	add    $0x198eb,%ecx
  10171b:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101721:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101725:	89 c2                	mov    %eax,%edx
  101727:	ec                   	in     (%dx),%al
  101728:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10172b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10172f:	0f b6 c0             	movzbl %al,%eax
  101732:	83 e0 01             	and    $0x1,%eax
  101735:	85 c0                	test   %eax,%eax
  101737:	75 0a                	jne    101743 <kbd_proc_data+0x3a>
        return -1;
  101739:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10173e:	e9 73 01 00 00       	jmp    1018b6 <kbd_proc_data+0x1ad>
  101743:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101749:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10174d:	89 c2                	mov    %eax,%edx
  10174f:	ec                   	in     (%dx),%al
  101750:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101753:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101757:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10175a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10175e:	75 19                	jne    101779 <kbd_proc_data+0x70>
        // E0 escape character
        shift |= E0ESC;
  101760:	8b 81 08 08 00 00    	mov    0x808(%ecx),%eax
  101766:	83 c8 40             	or     $0x40,%eax
  101769:	89 81 08 08 00 00    	mov    %eax,0x808(%ecx)
        return 0;
  10176f:	b8 00 00 00 00       	mov    $0x0,%eax
  101774:	e9 3d 01 00 00       	jmp    1018b6 <kbd_proc_data+0x1ad>
    } else if (data & 0x80) {
  101779:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10177d:	84 c0                	test   %al,%al
  10177f:	79 4b                	jns    1017cc <kbd_proc_data+0xc3>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101781:	8b 81 08 08 00 00    	mov    0x808(%ecx),%eax
  101787:	83 e0 40             	and    $0x40,%eax
  10178a:	85 c0                	test   %eax,%eax
  10178c:	75 09                	jne    101797 <kbd_proc_data+0x8e>
  10178e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101792:	83 e0 7f             	and    $0x7f,%eax
  101795:	eb 04                	jmp    10179b <kbd_proc_data+0x92>
  101797:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10179b:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10179e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1017a2:	0f b6 84 01 00 d0 ff 	movzbl -0x3000(%ecx,%eax,1),%eax
  1017a9:	ff 
  1017aa:	83 c8 40             	or     $0x40,%eax
  1017ad:	0f b6 c0             	movzbl %al,%eax
  1017b0:	f7 d0                	not    %eax
  1017b2:	89 c2                	mov    %eax,%edx
  1017b4:	8b 81 08 08 00 00    	mov    0x808(%ecx),%eax
  1017ba:	21 d0                	and    %edx,%eax
  1017bc:	89 81 08 08 00 00    	mov    %eax,0x808(%ecx)
        return 0;
  1017c2:	b8 00 00 00 00       	mov    $0x0,%eax
  1017c7:	e9 ea 00 00 00       	jmp    1018b6 <kbd_proc_data+0x1ad>
    } else if (shift & E0ESC) {
  1017cc:	8b 81 08 08 00 00    	mov    0x808(%ecx),%eax
  1017d2:	83 e0 40             	and    $0x40,%eax
  1017d5:	85 c0                	test   %eax,%eax
  1017d7:	74 13                	je     1017ec <kbd_proc_data+0xe3>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1017d9:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1017dd:	8b 81 08 08 00 00    	mov    0x808(%ecx),%eax
  1017e3:	83 e0 bf             	and    $0xffffffbf,%eax
  1017e6:	89 81 08 08 00 00    	mov    %eax,0x808(%ecx)
    }

    shift |= shiftcode[data];
  1017ec:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1017f0:	0f b6 84 01 00 d0 ff 	movzbl -0x3000(%ecx,%eax,1),%eax
  1017f7:	ff 
  1017f8:	0f b6 d0             	movzbl %al,%edx
  1017fb:	8b 81 08 08 00 00    	mov    0x808(%ecx),%eax
  101801:	09 d0                	or     %edx,%eax
  101803:	89 81 08 08 00 00    	mov    %eax,0x808(%ecx)
    shift ^= togglecode[data];
  101809:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10180d:	0f b6 84 01 00 d1 ff 	movzbl -0x2f00(%ecx,%eax,1),%eax
  101814:	ff 
  101815:	0f b6 d0             	movzbl %al,%edx
  101818:	8b 81 08 08 00 00    	mov    0x808(%ecx),%eax
  10181e:	31 d0                	xor    %edx,%eax
  101820:	89 81 08 08 00 00    	mov    %eax,0x808(%ecx)

    c = charcode[shift & (CTL | SHIFT)][data];
  101826:	8b 81 08 08 00 00    	mov    0x808(%ecx),%eax
  10182c:	83 e0 03             	and    $0x3,%eax
  10182f:	8b 94 81 44 00 00 00 	mov    0x44(%ecx,%eax,4),%edx
  101836:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10183a:	01 d0                	add    %edx,%eax
  10183c:	0f b6 00             	movzbl (%eax),%eax
  10183f:	0f b6 c0             	movzbl %al,%eax
  101842:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101845:	8b 81 08 08 00 00    	mov    0x808(%ecx),%eax
  10184b:	83 e0 08             	and    $0x8,%eax
  10184e:	85 c0                	test   %eax,%eax
  101850:	74 22                	je     101874 <kbd_proc_data+0x16b>
        if ('a' <= c && c <= 'z')
  101852:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101856:	7e 0c                	jle    101864 <kbd_proc_data+0x15b>
  101858:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10185c:	7f 06                	jg     101864 <kbd_proc_data+0x15b>
            c += 'A' - 'a';
  10185e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101862:	eb 10                	jmp    101874 <kbd_proc_data+0x16b>
        else if ('A' <= c && c <= 'Z')
  101864:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101868:	7e 0a                	jle    101874 <kbd_proc_data+0x16b>
  10186a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10186e:	7f 04                	jg     101874 <kbd_proc_data+0x16b>
            c += 'a' - 'A';
  101870:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101874:	8b 81 08 08 00 00    	mov    0x808(%ecx),%eax
  10187a:	f7 d0                	not    %eax
  10187c:	83 e0 06             	and    $0x6,%eax
  10187f:	85 c0                	test   %eax,%eax
  101881:	75 30                	jne    1018b3 <kbd_proc_data+0x1aa>
  101883:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10188a:	75 27                	jne    1018b3 <kbd_proc_data+0x1aa>
        cprintf("Rebooting!\n");
  10188c:	83 ec 0c             	sub    $0xc,%esp
  10188f:	8d 81 0d ba fe ff    	lea    -0x145f3(%ecx),%eax
  101895:	50                   	push   %eax
  101896:	89 cb                	mov    %ecx,%ebx
  101898:	e8 8c ea ff ff       	call   100329 <cprintf>
  10189d:	83 c4 10             	add    $0x10,%esp
  1018a0:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1018a6:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018aa:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1018ae:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1018b2:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1018b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1018b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1018b9:	c9                   	leave  
  1018ba:	c3                   	ret    

001018bb <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1018bb:	55                   	push   %ebp
  1018bc:	89 e5                	mov    %esp,%ebp
  1018be:	83 ec 08             	sub    $0x8,%esp
  1018c1:	e8 ec e9 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1018c6:	05 3a 97 01 00       	add    $0x1973a,%eax
    cons_intr(kbd_proc_data);
  1018cb:	83 ec 0c             	sub    $0xc,%esp
  1018ce:	8d 80 09 67 fe ff    	lea    -0x198f7(%eax),%eax
  1018d4:	50                   	push   %eax
  1018d5:	e8 40 fd ff ff       	call   10161a <cons_intr>
  1018da:	83 c4 10             	add    $0x10,%esp
}
  1018dd:	90                   	nop
  1018de:	c9                   	leave  
  1018df:	c3                   	ret    

001018e0 <kbd_init>:

static void
kbd_init(void) {
  1018e0:	55                   	push   %ebp
  1018e1:	89 e5                	mov    %esp,%ebp
  1018e3:	53                   	push   %ebx
  1018e4:	83 ec 04             	sub    $0x4,%esp
  1018e7:	e8 ca e9 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  1018ec:	81 c3 14 97 01 00    	add    $0x19714,%ebx
    // drain the kbd buffer
    kbd_intr();
  1018f2:	e8 c4 ff ff ff       	call   1018bb <kbd_intr>
    pic_enable(IRQ_KBD);
  1018f7:	83 ec 0c             	sub    $0xc,%esp
  1018fa:	6a 01                	push   $0x1
  1018fc:	e8 8d 01 00 00       	call   101a8e <pic_enable>
  101901:	83 c4 10             	add    $0x10,%esp
}
  101904:	90                   	nop
  101905:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101908:	c9                   	leave  
  101909:	c3                   	ret    

0010190a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10190a:	55                   	push   %ebp
  10190b:	89 e5                	mov    %esp,%ebp
  10190d:	53                   	push   %ebx
  10190e:	83 ec 04             	sub    $0x4,%esp
  101911:	e8 a0 e9 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  101916:	81 c3 ea 96 01 00    	add    $0x196ea,%ebx
    cga_init();
  10191c:	e8 b4 f7 ff ff       	call   1010d5 <cga_init>
    serial_init();
  101921:	e8 a3 f8 ff ff       	call   1011c9 <serial_init>
    kbd_init();
  101926:	e8 b5 ff ff ff       	call   1018e0 <kbd_init>
    if (!serial_exists) {
  10192b:	8b 83 e8 05 00 00    	mov    0x5e8(%ebx),%eax
  101931:	85 c0                	test   %eax,%eax
  101933:	75 12                	jne    101947 <cons_init+0x3d>
        cprintf("serial port does not exist!!\n");
  101935:	83 ec 0c             	sub    $0xc,%esp
  101938:	8d 83 19 ba fe ff    	lea    -0x145e7(%ebx),%eax
  10193e:	50                   	push   %eax
  10193f:	e8 e5 e9 ff ff       	call   100329 <cprintf>
  101944:	83 c4 10             	add    $0x10,%esp
    }
}
  101947:	90                   	nop
  101948:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10194b:	c9                   	leave  
  10194c:	c3                   	ret    

0010194d <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10194d:	55                   	push   %ebp
  10194e:	89 e5                	mov    %esp,%ebp
  101950:	83 ec 18             	sub    $0x18,%esp
  101953:	e8 5a e9 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  101958:	05 a8 96 01 00       	add    $0x196a8,%eax
    bool intr_flag;
    local_intr_save(intr_flag);
  10195d:	e8 bf f6 ff ff       	call   101021 <__intr_save>
  101962:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101965:	83 ec 0c             	sub    $0xc,%esp
  101968:	ff 75 08             	pushl  0x8(%ebp)
  10196b:	e8 d5 f9 ff ff       	call   101345 <lpt_putc>
  101970:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
  101973:	83 ec 0c             	sub    $0xc,%esp
  101976:	ff 75 08             	pushl  0x8(%ebp)
  101979:	e8 08 fa ff ff       	call   101386 <cga_putc>
  10197e:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
  101981:	83 ec 0c             	sub    $0xc,%esp
  101984:	ff 75 08             	pushl  0x8(%ebp)
  101987:	e8 4d fc ff ff       	call   1015d9 <serial_putc>
  10198c:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  10198f:	83 ec 0c             	sub    $0xc,%esp
  101992:	ff 75 f4             	pushl  -0xc(%ebp)
  101995:	e8 c3 f6 ff ff       	call   10105d <__intr_restore>
  10199a:	83 c4 10             	add    $0x10,%esp
}
  10199d:	90                   	nop
  10199e:	c9                   	leave  
  10199f:	c3                   	ret    

001019a0 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1019a0:	55                   	push   %ebp
  1019a1:	89 e5                	mov    %esp,%ebp
  1019a3:	53                   	push   %ebx
  1019a4:	83 ec 14             	sub    $0x14,%esp
  1019a7:	e8 0a e9 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  1019ac:	81 c3 54 96 01 00    	add    $0x19654,%ebx
    int c = 0;
  1019b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1019b9:	e8 63 f6 ff ff       	call   101021 <__intr_save>
  1019be:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  1019c1:	e8 14 fd ff ff       	call   1016da <serial_intr>
        kbd_intr();
  1019c6:	e8 f0 fe ff ff       	call   1018bb <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  1019cb:	8b 93 00 08 00 00    	mov    0x800(%ebx),%edx
  1019d1:	8b 83 04 08 00 00    	mov    0x804(%ebx),%eax
  1019d7:	39 c2                	cmp    %eax,%edx
  1019d9:	74 34                	je     101a0f <cons_getc+0x6f>
            c = cons.buf[cons.rpos ++];
  1019db:	8b 83 00 08 00 00    	mov    0x800(%ebx),%eax
  1019e1:	8d 50 01             	lea    0x1(%eax),%edx
  1019e4:	89 93 00 08 00 00    	mov    %edx,0x800(%ebx)
  1019ea:	0f b6 84 03 00 06 00 	movzbl 0x600(%ebx,%eax,1),%eax
  1019f1:	00 
  1019f2:	0f b6 c0             	movzbl %al,%eax
  1019f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  1019f8:	8b 83 00 08 00 00    	mov    0x800(%ebx),%eax
  1019fe:	3d 00 02 00 00       	cmp    $0x200,%eax
  101a03:	75 0a                	jne    101a0f <cons_getc+0x6f>
                cons.rpos = 0;
  101a05:	c7 83 00 08 00 00 00 	movl   $0x0,0x800(%ebx)
  101a0c:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101a0f:	83 ec 0c             	sub    $0xc,%esp
  101a12:	ff 75 f0             	pushl  -0x10(%ebp)
  101a15:	e8 43 f6 ff ff       	call   10105d <__intr_restore>
  101a1a:	83 c4 10             	add    $0x10,%esp
    return c;
  101a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101a20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101a23:	c9                   	leave  
  101a24:	c3                   	ret    

00101a25 <__x86.get_pc_thunk.cx>:
  101a25:	8b 0c 24             	mov    (%esp),%ecx
  101a28:	c3                   	ret    

00101a29 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101a29:	55                   	push   %ebp
  101a2a:	89 e5                	mov    %esp,%ebp
  101a2c:	83 ec 14             	sub    $0x14,%esp
  101a2f:	e8 7e e8 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  101a34:	05 cc 95 01 00       	add    $0x195cc,%eax
  101a39:	8b 55 08             	mov    0x8(%ebp),%edx
  101a3c:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
    irq_mask = mask;
  101a40:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101a44:	66 89 90 00 d5 ff ff 	mov    %dx,-0x2b00(%eax)
    if (did_init) {
  101a4b:	8b 80 0c 08 00 00    	mov    0x80c(%eax),%eax
  101a51:	85 c0                	test   %eax,%eax
  101a53:	74 36                	je     101a8b <pic_setmask+0x62>
        outb(IO_PIC1 + 1, mask);
  101a55:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101a59:	0f b6 c0             	movzbl %al,%eax
  101a5c:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101a62:	88 45 f9             	mov    %al,-0x7(%ebp)
  101a65:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101a69:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101a6d:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101a6e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101a72:	66 c1 e8 08          	shr    $0x8,%ax
  101a76:	0f b6 c0             	movzbl %al,%eax
  101a79:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101a7f:	88 45 fd             	mov    %al,-0x3(%ebp)
  101a82:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101a86:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101a8a:	ee                   	out    %al,(%dx)
    }
}
  101a8b:	90                   	nop
  101a8c:	c9                   	leave  
  101a8d:	c3                   	ret    

00101a8e <pic_enable>:

void
pic_enable(unsigned int irq) {
  101a8e:	55                   	push   %ebp
  101a8f:	89 e5                	mov    %esp,%ebp
  101a91:	53                   	push   %ebx
  101a92:	e8 1b e8 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  101a97:	05 69 95 01 00       	add    $0x19569,%eax
    pic_setmask(irq_mask & ~(1 << irq));
  101a9c:	8b 55 08             	mov    0x8(%ebp),%edx
  101a9f:	bb 01 00 00 00       	mov    $0x1,%ebx
  101aa4:	89 d1                	mov    %edx,%ecx
  101aa6:	d3 e3                	shl    %cl,%ebx
  101aa8:	89 da                	mov    %ebx,%edx
  101aaa:	f7 d2                	not    %edx
  101aac:	0f b7 80 00 d5 ff ff 	movzwl -0x2b00(%eax),%eax
  101ab3:	21 d0                	and    %edx,%eax
  101ab5:	0f b7 c0             	movzwl %ax,%eax
  101ab8:	50                   	push   %eax
  101ab9:	e8 6b ff ff ff       	call   101a29 <pic_setmask>
  101abe:	83 c4 04             	add    $0x4,%esp
}
  101ac1:	90                   	nop
  101ac2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101ac5:	c9                   	leave  
  101ac6:	c3                   	ret    

00101ac7 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101ac7:	55                   	push   %ebp
  101ac8:	89 e5                	mov    %esp,%ebp
  101aca:	83 ec 40             	sub    $0x40,%esp
  101acd:	e8 53 ff ff ff       	call   101a25 <__x86.get_pc_thunk.cx>
  101ad2:	81 c1 2e 95 01 00    	add    $0x1952e,%ecx
    did_init = 1;
  101ad8:	c7 81 0c 08 00 00 01 	movl   $0x1,0x80c(%ecx)
  101adf:	00 00 00 
  101ae2:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101ae8:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  101aec:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101af0:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101af4:	ee                   	out    %al,(%dx)
  101af5:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101afb:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  101aff:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101b03:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101b07:	ee                   	out    %al,(%dx)
  101b08:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101b0e:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  101b12:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101b16:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101b1a:	ee                   	out    %al,(%dx)
  101b1b:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101b21:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101b25:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101b29:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101b2d:	ee                   	out    %al,(%dx)
  101b2e:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101b34:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101b38:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101b3c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101b40:	ee                   	out    %al,(%dx)
  101b41:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101b47:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  101b4b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101b4f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101b53:	ee                   	out    %al,(%dx)
  101b54:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101b5a:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  101b5e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101b62:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101b66:	ee                   	out    %al,(%dx)
  101b67:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101b6d:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  101b71:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101b75:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101b79:	ee                   	out    %al,(%dx)
  101b7a:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101b80:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101b84:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101b88:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101b8c:	ee                   	out    %al,(%dx)
  101b8d:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101b93:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101b97:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101b9b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101b9f:	ee                   	out    %al,(%dx)
  101ba0:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101ba6:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  101baa:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101bae:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101bb2:	ee                   	out    %al,(%dx)
  101bb3:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101bb9:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  101bbd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101bc1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101bc5:	ee                   	out    %al,(%dx)
  101bc6:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101bcc:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  101bd0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101bd4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101bd8:	ee                   	out    %al,(%dx)
  101bd9:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101bdf:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  101be3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101be7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101beb:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101bec:	0f b7 81 00 d5 ff ff 	movzwl -0x2b00(%ecx),%eax
  101bf3:	66 83 f8 ff          	cmp    $0xffff,%ax
  101bf7:	74 13                	je     101c0c <pic_init+0x145>
        pic_setmask(irq_mask);
  101bf9:	0f b7 81 00 d5 ff ff 	movzwl -0x2b00(%ecx),%eax
  101c00:	0f b7 c0             	movzwl %ax,%eax
  101c03:	50                   	push   %eax
  101c04:	e8 20 fe ff ff       	call   101a29 <pic_setmask>
  101c09:	83 c4 04             	add    $0x4,%esp
    }
}
  101c0c:	90                   	nop
  101c0d:	c9                   	leave  
  101c0e:	c3                   	ret    

00101c0f <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101c0f:	55                   	push   %ebp
  101c10:	89 e5                	mov    %esp,%ebp
  101c12:	e8 9b e6 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  101c17:	05 e9 93 01 00       	add    $0x193e9,%eax
    asm volatile ("sti");
  101c1c:	fb                   	sti    
    sti();
}
  101c1d:	90                   	nop
  101c1e:	5d                   	pop    %ebp
  101c1f:	c3                   	ret    

00101c20 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101c20:	55                   	push   %ebp
  101c21:	89 e5                	mov    %esp,%ebp
  101c23:	e8 8a e6 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  101c28:	05 d8 93 01 00       	add    $0x193d8,%eax
    asm volatile ("cli" ::: "memory");
  101c2d:	fa                   	cli    
    cli();
}
  101c2e:	90                   	nop
  101c2f:	5d                   	pop    %ebp
  101c30:	c3                   	ret    

00101c31 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  101c31:	55                   	push   %ebp
  101c32:	89 e5                	mov    %esp,%ebp
  101c34:	53                   	push   %ebx
  101c35:	83 ec 04             	sub    $0x4,%esp
  101c38:	e8 75 e6 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  101c3d:	05 c3 93 01 00       	add    $0x193c3,%eax
    cprintf("%d ticks\n",TICK_NUM);
  101c42:	83 ec 08             	sub    $0x8,%esp
  101c45:	6a 64                	push   $0x64
  101c47:	8d 90 37 ba fe ff    	lea    -0x145c9(%eax),%edx
  101c4d:	52                   	push   %edx
  101c4e:	89 c3                	mov    %eax,%ebx
  101c50:	e8 d4 e6 ff ff       	call   100329 <cprintf>
  101c55:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101c58:	90                   	nop
  101c59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101c5c:	c9                   	leave  
  101c5d:	c3                   	ret    

00101c5e <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101c5e:	55                   	push   %ebp
  101c5f:	89 e5                	mov    %esp,%ebp
  101c61:	83 ec 10             	sub    $0x10,%esp
  101c64:	e8 49 e6 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  101c69:	05 97 93 01 00       	add    $0x19397,%eax
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101c6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101c75:	e9 c7 00 00 00       	jmp    101d41 <idt_init+0xe3>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101c7a:	c7 c2 02 85 11 00    	mov    $0x118502,%edx
  101c80:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  101c83:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
  101c86:	89 d1                	mov    %edx,%ecx
  101c88:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101c8b:	66 89 8c d0 20 08 00 	mov    %cx,0x820(%eax,%edx,8)
  101c92:	00 
  101c93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101c96:	66 c7 84 d0 22 08 00 	movw   $0x8,0x822(%eax,%edx,8)
  101c9d:	00 08 00 
  101ca0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101ca3:	0f b6 8c d0 24 08 00 	movzbl 0x824(%eax,%edx,8),%ecx
  101caa:	00 
  101cab:	83 e1 e0             	and    $0xffffffe0,%ecx
  101cae:	88 8c d0 24 08 00 00 	mov    %cl,0x824(%eax,%edx,8)
  101cb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101cb8:	0f b6 8c d0 24 08 00 	movzbl 0x824(%eax,%edx,8),%ecx
  101cbf:	00 
  101cc0:	83 e1 1f             	and    $0x1f,%ecx
  101cc3:	88 8c d0 24 08 00 00 	mov    %cl,0x824(%eax,%edx,8)
  101cca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101ccd:	0f b6 8c d0 25 08 00 	movzbl 0x825(%eax,%edx,8),%ecx
  101cd4:	00 
  101cd5:	83 e1 f0             	and    $0xfffffff0,%ecx
  101cd8:	83 c9 0e             	or     $0xe,%ecx
  101cdb:	88 8c d0 25 08 00 00 	mov    %cl,0x825(%eax,%edx,8)
  101ce2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101ce5:	0f b6 8c d0 25 08 00 	movzbl 0x825(%eax,%edx,8),%ecx
  101cec:	00 
  101ced:	83 e1 ef             	and    $0xffffffef,%ecx
  101cf0:	88 8c d0 25 08 00 00 	mov    %cl,0x825(%eax,%edx,8)
  101cf7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101cfa:	0f b6 8c d0 25 08 00 	movzbl 0x825(%eax,%edx,8),%ecx
  101d01:	00 
  101d02:	83 e1 9f             	and    $0xffffff9f,%ecx
  101d05:	88 8c d0 25 08 00 00 	mov    %cl,0x825(%eax,%edx,8)
  101d0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101d0f:	0f b6 8c d0 25 08 00 	movzbl 0x825(%eax,%edx,8),%ecx
  101d16:	00 
  101d17:	83 c9 80             	or     $0xffffff80,%ecx
  101d1a:	88 8c d0 25 08 00 00 	mov    %cl,0x825(%eax,%edx,8)
  101d21:	c7 c2 02 85 11 00    	mov    $0x118502,%edx
  101d27:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  101d2a:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
  101d2d:	c1 ea 10             	shr    $0x10,%edx
  101d30:	89 d1                	mov    %edx,%ecx
  101d32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101d35:	66 89 8c d0 26 08 00 	mov    %cx,0x826(%eax,%edx,8)
  101d3c:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101d3d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101d41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101d44:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  101d4a:	0f 86 2a ff ff ff    	jbe    101c7a <idt_init+0x1c>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101d50:	c7 c2 02 85 11 00    	mov    $0x118502,%edx
  101d56:	8b 92 e4 01 00 00    	mov    0x1e4(%edx),%edx
  101d5c:	66 89 90 e8 0b 00 00 	mov    %dx,0xbe8(%eax)
  101d63:	66 c7 80 ea 0b 00 00 	movw   $0x8,0xbea(%eax)
  101d6a:	08 00 
  101d6c:	0f b6 90 ec 0b 00 00 	movzbl 0xbec(%eax),%edx
  101d73:	83 e2 e0             	and    $0xffffffe0,%edx
  101d76:	88 90 ec 0b 00 00    	mov    %dl,0xbec(%eax)
  101d7c:	0f b6 90 ec 0b 00 00 	movzbl 0xbec(%eax),%edx
  101d83:	83 e2 1f             	and    $0x1f,%edx
  101d86:	88 90 ec 0b 00 00    	mov    %dl,0xbec(%eax)
  101d8c:	0f b6 90 ed 0b 00 00 	movzbl 0xbed(%eax),%edx
  101d93:	83 e2 f0             	and    $0xfffffff0,%edx
  101d96:	83 ca 0e             	or     $0xe,%edx
  101d99:	88 90 ed 0b 00 00    	mov    %dl,0xbed(%eax)
  101d9f:	0f b6 90 ed 0b 00 00 	movzbl 0xbed(%eax),%edx
  101da6:	83 e2 ef             	and    $0xffffffef,%edx
  101da9:	88 90 ed 0b 00 00    	mov    %dl,0xbed(%eax)
  101daf:	0f b6 90 ed 0b 00 00 	movzbl 0xbed(%eax),%edx
  101db6:	83 ca 60             	or     $0x60,%edx
  101db9:	88 90 ed 0b 00 00    	mov    %dl,0xbed(%eax)
  101dbf:	0f b6 90 ed 0b 00 00 	movzbl 0xbed(%eax),%edx
  101dc6:	83 ca 80             	or     $0xffffff80,%edx
  101dc9:	88 90 ed 0b 00 00    	mov    %dl,0xbed(%eax)
  101dcf:	c7 c2 02 85 11 00    	mov    $0x118502,%edx
  101dd5:	8b 92 e4 01 00 00    	mov    0x1e4(%edx),%edx
  101ddb:	c1 ea 10             	shr    $0x10,%edx
  101dde:	66 89 90 ee 0b 00 00 	mov    %dx,0xbee(%eax)
  101de5:	8d 80 60 00 00 00    	lea    0x60(%eax),%eax
  101deb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101dee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101df1:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  101df4:	90                   	nop
  101df5:	c9                   	leave  
  101df6:	c3                   	ret    

00101df7 <trapname>:

static const char *
trapname(int trapno) {
  101df7:	55                   	push   %ebp
  101df8:	89 e5                	mov    %esp,%ebp
  101dfa:	e8 b3 e4 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  101dff:	05 01 92 01 00       	add    $0x19201,%eax
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101e04:	8b 55 08             	mov    0x8(%ebp),%edx
  101e07:	83 fa 13             	cmp    $0x13,%edx
  101e0a:	77 0c                	ja     101e18 <trapname+0x21>
        return excnames[trapno];
  101e0c:	8b 55 08             	mov    0x8(%ebp),%edx
  101e0f:	8b 84 90 00 01 00 00 	mov    0x100(%eax,%edx,4),%eax
  101e16:	eb 1a                	jmp    101e32 <trapname+0x3b>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101e18:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101e1c:	7e 0e                	jle    101e2c <trapname+0x35>
  101e1e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101e22:	7f 08                	jg     101e2c <trapname+0x35>
        return "Hardware Interrupt";
  101e24:	8d 80 41 ba fe ff    	lea    -0x145bf(%eax),%eax
  101e2a:	eb 06                	jmp    101e32 <trapname+0x3b>
    }
    return "(unknown trap)";
  101e2c:	8d 80 54 ba fe ff    	lea    -0x145ac(%eax),%eax
}
  101e32:	5d                   	pop    %ebp
  101e33:	c3                   	ret    

00101e34 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101e34:	55                   	push   %ebp
  101e35:	89 e5                	mov    %esp,%ebp
  101e37:	e8 76 e4 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  101e3c:	05 c4 91 01 00       	add    $0x191c4,%eax
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101e41:	8b 45 08             	mov    0x8(%ebp),%eax
  101e44:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e48:	66 83 f8 08          	cmp    $0x8,%ax
  101e4c:	0f 94 c0             	sete   %al
  101e4f:	0f b6 c0             	movzbl %al,%eax
}
  101e52:	5d                   	pop    %ebp
  101e53:	c3                   	ret    

00101e54 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101e54:	55                   	push   %ebp
  101e55:	89 e5                	mov    %esp,%ebp
  101e57:	53                   	push   %ebx
  101e58:	83 ec 14             	sub    $0x14,%esp
  101e5b:	e8 56 e4 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  101e60:	81 c3 a0 91 01 00    	add    $0x191a0,%ebx
    cprintf("trapframe at %p\n", tf);
  101e66:	83 ec 08             	sub    $0x8,%esp
  101e69:	ff 75 08             	pushl  0x8(%ebp)
  101e6c:	8d 83 95 ba fe ff    	lea    -0x1456b(%ebx),%eax
  101e72:	50                   	push   %eax
  101e73:	e8 b1 e4 ff ff       	call   100329 <cprintf>
  101e78:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7e:	83 ec 0c             	sub    $0xc,%esp
  101e81:	50                   	push   %eax
  101e82:	e8 d3 01 00 00       	call   10205a <print_regs>
  101e87:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101e91:	0f b7 c0             	movzwl %ax,%eax
  101e94:	83 ec 08             	sub    $0x8,%esp
  101e97:	50                   	push   %eax
  101e98:	8d 83 a6 ba fe ff    	lea    -0x1455a(%ebx),%eax
  101e9e:	50                   	push   %eax
  101e9f:	e8 85 e4 ff ff       	call   100329 <cprintf>
  101ea4:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  101eaa:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101eae:	0f b7 c0             	movzwl %ax,%eax
  101eb1:	83 ec 08             	sub    $0x8,%esp
  101eb4:	50                   	push   %eax
  101eb5:	8d 83 b9 ba fe ff    	lea    -0x14547(%ebx),%eax
  101ebb:	50                   	push   %eax
  101ebc:	e8 68 e4 ff ff       	call   100329 <cprintf>
  101ec1:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec7:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ecb:	0f b7 c0             	movzwl %ax,%eax
  101ece:	83 ec 08             	sub    $0x8,%esp
  101ed1:	50                   	push   %eax
  101ed2:	8d 83 cc ba fe ff    	lea    -0x14534(%ebx),%eax
  101ed8:	50                   	push   %eax
  101ed9:	e8 4b e4 ff ff       	call   100329 <cprintf>
  101ede:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee4:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ee8:	0f b7 c0             	movzwl %ax,%eax
  101eeb:	83 ec 08             	sub    $0x8,%esp
  101eee:	50                   	push   %eax
  101eef:	8d 83 df ba fe ff    	lea    -0x14521(%ebx),%eax
  101ef5:	50                   	push   %eax
  101ef6:	e8 2e e4 ff ff       	call   100329 <cprintf>
  101efb:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101efe:	8b 45 08             	mov    0x8(%ebp),%eax
  101f01:	8b 40 30             	mov    0x30(%eax),%eax
  101f04:	83 ec 0c             	sub    $0xc,%esp
  101f07:	50                   	push   %eax
  101f08:	e8 ea fe ff ff       	call   101df7 <trapname>
  101f0d:	83 c4 10             	add    $0x10,%esp
  101f10:	89 c2                	mov    %eax,%edx
  101f12:	8b 45 08             	mov    0x8(%ebp),%eax
  101f15:	8b 40 30             	mov    0x30(%eax),%eax
  101f18:	83 ec 04             	sub    $0x4,%esp
  101f1b:	52                   	push   %edx
  101f1c:	50                   	push   %eax
  101f1d:	8d 83 f2 ba fe ff    	lea    -0x1450e(%ebx),%eax
  101f23:	50                   	push   %eax
  101f24:	e8 00 e4 ff ff       	call   100329 <cprintf>
  101f29:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2f:	8b 40 34             	mov    0x34(%eax),%eax
  101f32:	83 ec 08             	sub    $0x8,%esp
  101f35:	50                   	push   %eax
  101f36:	8d 83 04 bb fe ff    	lea    -0x144fc(%ebx),%eax
  101f3c:	50                   	push   %eax
  101f3d:	e8 e7 e3 ff ff       	call   100329 <cprintf>
  101f42:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101f45:	8b 45 08             	mov    0x8(%ebp),%eax
  101f48:	8b 40 38             	mov    0x38(%eax),%eax
  101f4b:	83 ec 08             	sub    $0x8,%esp
  101f4e:	50                   	push   %eax
  101f4f:	8d 83 13 bb fe ff    	lea    -0x144ed(%ebx),%eax
  101f55:	50                   	push   %eax
  101f56:	e8 ce e3 ff ff       	call   100329 <cprintf>
  101f5b:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f61:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f65:	0f b7 c0             	movzwl %ax,%eax
  101f68:	83 ec 08             	sub    $0x8,%esp
  101f6b:	50                   	push   %eax
  101f6c:	8d 83 22 bb fe ff    	lea    -0x144de(%ebx),%eax
  101f72:	50                   	push   %eax
  101f73:	e8 b1 e3 ff ff       	call   100329 <cprintf>
  101f78:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f7e:	8b 40 40             	mov    0x40(%eax),%eax
  101f81:	83 ec 08             	sub    $0x8,%esp
  101f84:	50                   	push   %eax
  101f85:	8d 83 35 bb fe ff    	lea    -0x144cb(%ebx),%eax
  101f8b:	50                   	push   %eax
  101f8c:	e8 98 e3 ff ff       	call   100329 <cprintf>
  101f91:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101f94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101f9b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101fa2:	eb 41                	jmp    101fe5 <print_trapframe+0x191>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa7:	8b 50 40             	mov    0x40(%eax),%edx
  101faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101fad:	21 d0                	and    %edx,%eax
  101faf:	85 c0                	test   %eax,%eax
  101fb1:	74 2b                	je     101fde <print_trapframe+0x18a>
  101fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fb6:	8b 84 83 80 00 00 00 	mov    0x80(%ebx,%eax,4),%eax
  101fbd:	85 c0                	test   %eax,%eax
  101fbf:	74 1d                	je     101fde <print_trapframe+0x18a>
            cprintf("%s,", IA32flags[i]);
  101fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fc4:	8b 84 83 80 00 00 00 	mov    0x80(%ebx,%eax,4),%eax
  101fcb:	83 ec 08             	sub    $0x8,%esp
  101fce:	50                   	push   %eax
  101fcf:	8d 83 44 bb fe ff    	lea    -0x144bc(%ebx),%eax
  101fd5:	50                   	push   %eax
  101fd6:	e8 4e e3 ff ff       	call   100329 <cprintf>
  101fdb:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101fde:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101fe2:	d1 65 f0             	shll   -0x10(%ebp)
  101fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fe8:	83 f8 17             	cmp    $0x17,%eax
  101feb:	76 b7                	jbe    101fa4 <print_trapframe+0x150>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101fed:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff0:	8b 40 40             	mov    0x40(%eax),%eax
  101ff3:	c1 e8 0c             	shr    $0xc,%eax
  101ff6:	83 e0 03             	and    $0x3,%eax
  101ff9:	83 ec 08             	sub    $0x8,%esp
  101ffc:	50                   	push   %eax
  101ffd:	8d 83 48 bb fe ff    	lea    -0x144b8(%ebx),%eax
  102003:	50                   	push   %eax
  102004:	e8 20 e3 ff ff       	call   100329 <cprintf>
  102009:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  10200c:	83 ec 0c             	sub    $0xc,%esp
  10200f:	ff 75 08             	pushl  0x8(%ebp)
  102012:	e8 1d fe ff ff       	call   101e34 <trap_in_kernel>
  102017:	83 c4 10             	add    $0x10,%esp
  10201a:	85 c0                	test   %eax,%eax
  10201c:	75 36                	jne    102054 <print_trapframe+0x200>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  10201e:	8b 45 08             	mov    0x8(%ebp),%eax
  102021:	8b 40 44             	mov    0x44(%eax),%eax
  102024:	83 ec 08             	sub    $0x8,%esp
  102027:	50                   	push   %eax
  102028:	8d 83 51 bb fe ff    	lea    -0x144af(%ebx),%eax
  10202e:	50                   	push   %eax
  10202f:	e8 f5 e2 ff ff       	call   100329 <cprintf>
  102034:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  102037:	8b 45 08             	mov    0x8(%ebp),%eax
  10203a:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  10203e:	0f b7 c0             	movzwl %ax,%eax
  102041:	83 ec 08             	sub    $0x8,%esp
  102044:	50                   	push   %eax
  102045:	8d 83 60 bb fe ff    	lea    -0x144a0(%ebx),%eax
  10204b:	50                   	push   %eax
  10204c:	e8 d8 e2 ff ff       	call   100329 <cprintf>
  102051:	83 c4 10             	add    $0x10,%esp
    }
}
  102054:	90                   	nop
  102055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102058:	c9                   	leave  
  102059:	c3                   	ret    

0010205a <print_regs>:

void
print_regs(struct pushregs *regs) {
  10205a:	55                   	push   %ebp
  10205b:	89 e5                	mov    %esp,%ebp
  10205d:	53                   	push   %ebx
  10205e:	83 ec 04             	sub    $0x4,%esp
  102061:	e8 50 e2 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  102066:	81 c3 9a 8f 01 00    	add    $0x18f9a,%ebx
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  10206c:	8b 45 08             	mov    0x8(%ebp),%eax
  10206f:	8b 00                	mov    (%eax),%eax
  102071:	83 ec 08             	sub    $0x8,%esp
  102074:	50                   	push   %eax
  102075:	8d 83 73 bb fe ff    	lea    -0x1448d(%ebx),%eax
  10207b:	50                   	push   %eax
  10207c:	e8 a8 e2 ff ff       	call   100329 <cprintf>
  102081:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  102084:	8b 45 08             	mov    0x8(%ebp),%eax
  102087:	8b 40 04             	mov    0x4(%eax),%eax
  10208a:	83 ec 08             	sub    $0x8,%esp
  10208d:	50                   	push   %eax
  10208e:	8d 83 82 bb fe ff    	lea    -0x1447e(%ebx),%eax
  102094:	50                   	push   %eax
  102095:	e8 8f e2 ff ff       	call   100329 <cprintf>
  10209a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  10209d:	8b 45 08             	mov    0x8(%ebp),%eax
  1020a0:	8b 40 08             	mov    0x8(%eax),%eax
  1020a3:	83 ec 08             	sub    $0x8,%esp
  1020a6:	50                   	push   %eax
  1020a7:	8d 83 91 bb fe ff    	lea    -0x1446f(%ebx),%eax
  1020ad:	50                   	push   %eax
  1020ae:	e8 76 e2 ff ff       	call   100329 <cprintf>
  1020b3:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  1020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1020b9:	8b 40 0c             	mov    0xc(%eax),%eax
  1020bc:	83 ec 08             	sub    $0x8,%esp
  1020bf:	50                   	push   %eax
  1020c0:	8d 83 a0 bb fe ff    	lea    -0x14460(%ebx),%eax
  1020c6:	50                   	push   %eax
  1020c7:	e8 5d e2 ff ff       	call   100329 <cprintf>
  1020cc:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  1020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1020d2:	8b 40 10             	mov    0x10(%eax),%eax
  1020d5:	83 ec 08             	sub    $0x8,%esp
  1020d8:	50                   	push   %eax
  1020d9:	8d 83 af bb fe ff    	lea    -0x14451(%ebx),%eax
  1020df:	50                   	push   %eax
  1020e0:	e8 44 e2 ff ff       	call   100329 <cprintf>
  1020e5:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  1020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1020eb:	8b 40 14             	mov    0x14(%eax),%eax
  1020ee:	83 ec 08             	sub    $0x8,%esp
  1020f1:	50                   	push   %eax
  1020f2:	8d 83 be bb fe ff    	lea    -0x14442(%ebx),%eax
  1020f8:	50                   	push   %eax
  1020f9:	e8 2b e2 ff ff       	call   100329 <cprintf>
  1020fe:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  102101:	8b 45 08             	mov    0x8(%ebp),%eax
  102104:	8b 40 18             	mov    0x18(%eax),%eax
  102107:	83 ec 08             	sub    $0x8,%esp
  10210a:	50                   	push   %eax
  10210b:	8d 83 cd bb fe ff    	lea    -0x14433(%ebx),%eax
  102111:	50                   	push   %eax
  102112:	e8 12 e2 ff ff       	call   100329 <cprintf>
  102117:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  10211a:	8b 45 08             	mov    0x8(%ebp),%eax
  10211d:	8b 40 1c             	mov    0x1c(%eax),%eax
  102120:	83 ec 08             	sub    $0x8,%esp
  102123:	50                   	push   %eax
  102124:	8d 83 dc bb fe ff    	lea    -0x14424(%ebx),%eax
  10212a:	50                   	push   %eax
  10212b:	e8 f9 e1 ff ff       	call   100329 <cprintf>
  102130:	83 c4 10             	add    $0x10,%esp
}
  102133:	90                   	nop
  102134:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102137:	c9                   	leave  
  102138:	c3                   	ret    

00102139 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  102139:	55                   	push   %ebp
  10213a:	89 e5                	mov    %esp,%ebp
  10213c:	57                   	push   %edi
  10213d:	56                   	push   %esi
  10213e:	53                   	push   %ebx
  10213f:	83 ec 1c             	sub    $0x1c,%esp
  102142:	e8 6f e1 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  102147:	81 c3 b9 8e 01 00    	add    $0x18eb9,%ebx
    char c;

    switch (tf->tf_trapno) {
  10214d:	8b 45 08             	mov    0x8(%ebp),%eax
  102150:	8b 40 30             	mov    0x30(%eax),%eax
  102153:	83 f8 2f             	cmp    $0x2f,%eax
  102156:	77 21                	ja     102179 <trap_dispatch+0x40>
  102158:	83 f8 2e             	cmp    $0x2e,%eax
  10215b:	0f 83 3b 02 00 00    	jae    10239c <trap_dispatch+0x263>
  102161:	83 f8 21             	cmp    $0x21,%eax
  102164:	0f 84 91 00 00 00    	je     1021fb <trap_dispatch+0xc2>
  10216a:	83 f8 24             	cmp    $0x24,%eax
  10216d:	74 63                	je     1021d2 <trap_dispatch+0x99>
  10216f:	83 f8 20             	cmp    $0x20,%eax
  102172:	74 1c                	je     102190 <trap_dispatch+0x57>
  102174:	e9 e9 01 00 00       	jmp    102362 <trap_dispatch+0x229>
  102179:	83 f8 78             	cmp    $0x78,%eax
  10217c:	0f 84 a2 00 00 00    	je     102224 <trap_dispatch+0xeb>
  102182:	83 f8 79             	cmp    $0x79,%eax
  102185:	0f 84 57 01 00 00    	je     1022e2 <trap_dispatch+0x1a9>
  10218b:	e9 d2 01 00 00       	jmp    102362 <trap_dispatch+0x229>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  102190:	c7 c0 ac c0 11 00    	mov    $0x11c0ac,%eax
  102196:	8b 00                	mov    (%eax),%eax
  102198:	8d 50 01             	lea    0x1(%eax),%edx
  10219b:	c7 c0 ac c0 11 00    	mov    $0x11c0ac,%eax
  1021a1:	89 10                	mov    %edx,(%eax)
        if (ticks % TICK_NUM == 0) {
  1021a3:	c7 c0 ac c0 11 00    	mov    $0x11c0ac,%eax
  1021a9:	8b 08                	mov    (%eax),%ecx
  1021ab:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  1021b0:	89 c8                	mov    %ecx,%eax
  1021b2:	f7 e2                	mul    %edx
  1021b4:	89 d0                	mov    %edx,%eax
  1021b6:	c1 e8 05             	shr    $0x5,%eax
  1021b9:	6b c0 64             	imul   $0x64,%eax,%eax
  1021bc:	29 c1                	sub    %eax,%ecx
  1021be:	89 c8                	mov    %ecx,%eax
  1021c0:	85 c0                	test   %eax,%eax
  1021c2:	0f 85 d7 01 00 00    	jne    10239f <trap_dispatch+0x266>
            print_ticks();
  1021c8:	e8 64 fa ff ff       	call   101c31 <print_ticks>
        }
        break;
  1021cd:	e9 cd 01 00 00       	jmp    10239f <trap_dispatch+0x266>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  1021d2:	e8 c9 f7 ff ff       	call   1019a0 <cons_getc>
  1021d7:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  1021da:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  1021de:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  1021e2:	83 ec 04             	sub    $0x4,%esp
  1021e5:	52                   	push   %edx
  1021e6:	50                   	push   %eax
  1021e7:	8d 83 eb bb fe ff    	lea    -0x14415(%ebx),%eax
  1021ed:	50                   	push   %eax
  1021ee:	e8 36 e1 ff ff       	call   100329 <cprintf>
  1021f3:	83 c4 10             	add    $0x10,%esp
        break;
  1021f6:	e9 ab 01 00 00       	jmp    1023a6 <trap_dispatch+0x26d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  1021fb:	e8 a0 f7 ff ff       	call   1019a0 <cons_getc>
  102200:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  102203:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  102207:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  10220b:	83 ec 04             	sub    $0x4,%esp
  10220e:	52                   	push   %edx
  10220f:	50                   	push   %eax
  102210:	8d 83 fd bb fe ff    	lea    -0x14403(%ebx),%eax
  102216:	50                   	push   %eax
  102217:	e8 0d e1 ff ff       	call   100329 <cprintf>
  10221c:	83 c4 10             	add    $0x10,%esp
        break;
  10221f:	e9 82 01 00 00       	jmp    1023a6 <trap_dispatch+0x26d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  102224:	8b 45 08             	mov    0x8(%ebp),%eax
  102227:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10222b:	66 83 f8 1b          	cmp    $0x1b,%ax
  10222f:	0f 84 6d 01 00 00    	je     1023a2 <trap_dispatch+0x269>
            switchk2u = *tf;
  102235:	c7 c0 c0 c0 11 00    	mov    $0x11c0c0,%eax
  10223b:	8b 55 08             	mov    0x8(%ebp),%edx
  10223e:	89 d6                	mov    %edx,%esi
  102240:	ba 4c 00 00 00       	mov    $0x4c,%edx
  102245:	8b 0e                	mov    (%esi),%ecx
  102247:	89 08                	mov    %ecx,(%eax)
  102249:	8b 4c 16 fc          	mov    -0x4(%esi,%edx,1),%ecx
  10224d:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  102251:	8d 78 04             	lea    0x4(%eax),%edi
  102254:	83 e7 fc             	and    $0xfffffffc,%edi
  102257:	29 f8                	sub    %edi,%eax
  102259:	29 c6                	sub    %eax,%esi
  10225b:	01 c2                	add    %eax,%edx
  10225d:	83 e2 fc             	and    $0xfffffffc,%edx
  102260:	89 d0                	mov    %edx,%eax
  102262:	c1 e8 02             	shr    $0x2,%eax
  102265:	89 c1                	mov    %eax,%ecx
  102267:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  102269:	c7 c0 c0 c0 11 00    	mov    $0x11c0c0,%eax
  10226f:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  102275:	c7 c0 c0 c0 11 00    	mov    $0x11c0c0,%eax
  10227b:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  102281:	c7 c0 c0 c0 11 00    	mov    $0x11c0c0,%eax
  102287:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  10228b:	c7 c0 c0 c0 11 00    	mov    $0x11c0c0,%eax
  102291:	66 89 50 28          	mov    %dx,0x28(%eax)
  102295:	c7 c0 c0 c0 11 00    	mov    $0x11c0c0,%eax
  10229b:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  10229f:	c7 c0 c0 c0 11 00    	mov    $0x11c0c0,%eax
  1022a5:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  1022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1022ac:	8d 50 44             	lea    0x44(%eax),%edx
  1022af:	c7 c0 c0 c0 11 00    	mov    $0x11c0c0,%eax
  1022b5:	89 50 44             	mov    %edx,0x44(%eax)
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  1022b8:	c7 c0 c0 c0 11 00    	mov    $0x11c0c0,%eax
  1022be:	8b 40 40             	mov    0x40(%eax),%eax
  1022c1:	80 cc 30             	or     $0x30,%ah
  1022c4:	89 c2                	mov    %eax,%edx
  1022c6:	c7 c0 c0 c0 11 00    	mov    $0x11c0c0,%eax
  1022cc:	89 50 40             	mov    %edx,0x40(%eax)
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  1022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1022d2:	83 e8 04             	sub    $0x4,%eax
  1022d5:	c7 c2 c0 c0 11 00    	mov    $0x11c0c0,%edx
  1022db:	89 10                	mov    %edx,(%eax)
        }
        break;
  1022dd:	e9 c0 00 00 00       	jmp    1023a2 <trap_dispatch+0x269>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  1022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1022e5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1022e9:	66 83 f8 08          	cmp    $0x8,%ax
  1022ed:	0f 84 b2 00 00 00    	je     1023a5 <trap_dispatch+0x26c>
            tf->tf_cs = KERNEL_CS;
  1022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1022f6:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  1022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1022ff:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  102305:	8b 45 08             	mov    0x8(%ebp),%eax
  102308:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  10230c:	8b 45 08             	mov    0x8(%ebp),%eax
  10230f:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  102313:	8b 45 08             	mov    0x8(%ebp),%eax
  102316:	8b 40 40             	mov    0x40(%eax),%eax
  102319:	80 e4 cf             	and    $0xcf,%ah
  10231c:	89 c2                	mov    %eax,%edx
  10231e:	8b 45 08             	mov    0x8(%ebp),%eax
  102321:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  102324:	8b 45 08             	mov    0x8(%ebp),%eax
  102327:	8b 40 44             	mov    0x44(%eax),%eax
  10232a:	83 e8 44             	sub    $0x44,%eax
  10232d:	89 c2                	mov    %eax,%edx
  10232f:	c7 c0 0c c1 11 00    	mov    $0x11c10c,%eax
  102335:	89 10                	mov    %edx,(%eax)
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  102337:	c7 c0 0c c1 11 00    	mov    $0x11c10c,%eax
  10233d:	8b 00                	mov    (%eax),%eax
  10233f:	83 ec 04             	sub    $0x4,%esp
  102342:	6a 44                	push   $0x44
  102344:	ff 75 08             	pushl  0x8(%ebp)
  102347:	50                   	push   %eax
  102348:	e8 b1 3b 00 00       	call   105efe <memmove>
  10234d:	83 c4 10             	add    $0x10,%esp
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  102350:	c7 c0 0c c1 11 00    	mov    $0x11c10c,%eax
  102356:	8b 10                	mov    (%eax),%edx
  102358:	8b 45 08             	mov    0x8(%ebp),%eax
  10235b:	83 e8 04             	sub    $0x4,%eax
  10235e:	89 10                	mov    %edx,(%eax)
        }
        break;
  102360:	eb 43                	jmp    1023a5 <trap_dispatch+0x26c>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  102362:	8b 45 08             	mov    0x8(%ebp),%eax
  102365:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102369:	0f b7 c0             	movzwl %ax,%eax
  10236c:	83 e0 03             	and    $0x3,%eax
  10236f:	85 c0                	test   %eax,%eax
  102371:	75 33                	jne    1023a6 <trap_dispatch+0x26d>
            print_trapframe(tf);
  102373:	83 ec 0c             	sub    $0xc,%esp
  102376:	ff 75 08             	pushl  0x8(%ebp)
  102379:	e8 d6 fa ff ff       	call   101e54 <print_trapframe>
  10237e:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  102381:	83 ec 04             	sub    $0x4,%esp
  102384:	8d 83 0c bc fe ff    	lea    -0x143f4(%ebx),%eax
  10238a:	50                   	push   %eax
  10238b:	68 d2 00 00 00       	push   $0xd2
  102390:	8d 83 28 bc fe ff    	lea    -0x143d8(%ebx),%eax
  102396:	50                   	push   %eax
  102397:	e8 3d e1 ff ff       	call   1004d9 <__panic>
        break;
  10239c:	90                   	nop
  10239d:	eb 07                	jmp    1023a6 <trap_dispatch+0x26d>
        break;
  10239f:	90                   	nop
  1023a0:	eb 04                	jmp    1023a6 <trap_dispatch+0x26d>
        break;
  1023a2:	90                   	nop
  1023a3:	eb 01                	jmp    1023a6 <trap_dispatch+0x26d>
        break;
  1023a5:	90                   	nop
        }
    }
}
  1023a6:	90                   	nop
  1023a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1023aa:	5b                   	pop    %ebx
  1023ab:	5e                   	pop    %esi
  1023ac:	5f                   	pop    %edi
  1023ad:	5d                   	pop    %ebp
  1023ae:	c3                   	ret    

001023af <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  1023af:	55                   	push   %ebp
  1023b0:	89 e5                	mov    %esp,%ebp
  1023b2:	83 ec 08             	sub    $0x8,%esp
  1023b5:	e8 f8 de ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1023ba:	05 46 8c 01 00       	add    $0x18c46,%eax
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  1023bf:	83 ec 0c             	sub    $0xc,%esp
  1023c2:	ff 75 08             	pushl  0x8(%ebp)
  1023c5:	e8 6f fd ff ff       	call   102139 <trap_dispatch>
  1023ca:	83 c4 10             	add    $0x10,%esp
}
  1023cd:	90                   	nop
  1023ce:	c9                   	leave  
  1023cf:	c3                   	ret    

001023d0 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $0
  1023d2:	6a 00                	push   $0x0
  jmp __alltraps
  1023d4:	e9 69 0a 00 00       	jmp    102e42 <__alltraps>

001023d9 <vector1>:
.globl vector1
vector1:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $1
  1023db:	6a 01                	push   $0x1
  jmp __alltraps
  1023dd:	e9 60 0a 00 00       	jmp    102e42 <__alltraps>

001023e2 <vector2>:
.globl vector2
vector2:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $2
  1023e4:	6a 02                	push   $0x2
  jmp __alltraps
  1023e6:	e9 57 0a 00 00       	jmp    102e42 <__alltraps>

001023eb <vector3>:
.globl vector3
vector3:
  pushl $0
  1023eb:	6a 00                	push   $0x0
  pushl $3
  1023ed:	6a 03                	push   $0x3
  jmp __alltraps
  1023ef:	e9 4e 0a 00 00       	jmp    102e42 <__alltraps>

001023f4 <vector4>:
.globl vector4
vector4:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $4
  1023f6:	6a 04                	push   $0x4
  jmp __alltraps
  1023f8:	e9 45 0a 00 00       	jmp    102e42 <__alltraps>

001023fd <vector5>:
.globl vector5
vector5:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $5
  1023ff:	6a 05                	push   $0x5
  jmp __alltraps
  102401:	e9 3c 0a 00 00       	jmp    102e42 <__alltraps>

00102406 <vector6>:
.globl vector6
vector6:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $6
  102408:	6a 06                	push   $0x6
  jmp __alltraps
  10240a:	e9 33 0a 00 00       	jmp    102e42 <__alltraps>

0010240f <vector7>:
.globl vector7
vector7:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $7
  102411:	6a 07                	push   $0x7
  jmp __alltraps
  102413:	e9 2a 0a 00 00       	jmp    102e42 <__alltraps>

00102418 <vector8>:
.globl vector8
vector8:
  pushl $8
  102418:	6a 08                	push   $0x8
  jmp __alltraps
  10241a:	e9 23 0a 00 00       	jmp    102e42 <__alltraps>

0010241f <vector9>:
.globl vector9
vector9:
  pushl $0
  10241f:	6a 00                	push   $0x0
  pushl $9
  102421:	6a 09                	push   $0x9
  jmp __alltraps
  102423:	e9 1a 0a 00 00       	jmp    102e42 <__alltraps>

00102428 <vector10>:
.globl vector10
vector10:
  pushl $10
  102428:	6a 0a                	push   $0xa
  jmp __alltraps
  10242a:	e9 13 0a 00 00       	jmp    102e42 <__alltraps>

0010242f <vector11>:
.globl vector11
vector11:
  pushl $11
  10242f:	6a 0b                	push   $0xb
  jmp __alltraps
  102431:	e9 0c 0a 00 00       	jmp    102e42 <__alltraps>

00102436 <vector12>:
.globl vector12
vector12:
  pushl $12
  102436:	6a 0c                	push   $0xc
  jmp __alltraps
  102438:	e9 05 0a 00 00       	jmp    102e42 <__alltraps>

0010243d <vector13>:
.globl vector13
vector13:
  pushl $13
  10243d:	6a 0d                	push   $0xd
  jmp __alltraps
  10243f:	e9 fe 09 00 00       	jmp    102e42 <__alltraps>

00102444 <vector14>:
.globl vector14
vector14:
  pushl $14
  102444:	6a 0e                	push   $0xe
  jmp __alltraps
  102446:	e9 f7 09 00 00       	jmp    102e42 <__alltraps>

0010244b <vector15>:
.globl vector15
vector15:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $15
  10244d:	6a 0f                	push   $0xf
  jmp __alltraps
  10244f:	e9 ee 09 00 00       	jmp    102e42 <__alltraps>

00102454 <vector16>:
.globl vector16
vector16:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $16
  102456:	6a 10                	push   $0x10
  jmp __alltraps
  102458:	e9 e5 09 00 00       	jmp    102e42 <__alltraps>

0010245d <vector17>:
.globl vector17
vector17:
  pushl $17
  10245d:	6a 11                	push   $0x11
  jmp __alltraps
  10245f:	e9 de 09 00 00       	jmp    102e42 <__alltraps>

00102464 <vector18>:
.globl vector18
vector18:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $18
  102466:	6a 12                	push   $0x12
  jmp __alltraps
  102468:	e9 d5 09 00 00       	jmp    102e42 <__alltraps>

0010246d <vector19>:
.globl vector19
vector19:
  pushl $0
  10246d:	6a 00                	push   $0x0
  pushl $19
  10246f:	6a 13                	push   $0x13
  jmp __alltraps
  102471:	e9 cc 09 00 00       	jmp    102e42 <__alltraps>

00102476 <vector20>:
.globl vector20
vector20:
  pushl $0
  102476:	6a 00                	push   $0x0
  pushl $20
  102478:	6a 14                	push   $0x14
  jmp __alltraps
  10247a:	e9 c3 09 00 00       	jmp    102e42 <__alltraps>

0010247f <vector21>:
.globl vector21
vector21:
  pushl $0
  10247f:	6a 00                	push   $0x0
  pushl $21
  102481:	6a 15                	push   $0x15
  jmp __alltraps
  102483:	e9 ba 09 00 00       	jmp    102e42 <__alltraps>

00102488 <vector22>:
.globl vector22
vector22:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $22
  10248a:	6a 16                	push   $0x16
  jmp __alltraps
  10248c:	e9 b1 09 00 00       	jmp    102e42 <__alltraps>

00102491 <vector23>:
.globl vector23
vector23:
  pushl $0
  102491:	6a 00                	push   $0x0
  pushl $23
  102493:	6a 17                	push   $0x17
  jmp __alltraps
  102495:	e9 a8 09 00 00       	jmp    102e42 <__alltraps>

0010249a <vector24>:
.globl vector24
vector24:
  pushl $0
  10249a:	6a 00                	push   $0x0
  pushl $24
  10249c:	6a 18                	push   $0x18
  jmp __alltraps
  10249e:	e9 9f 09 00 00       	jmp    102e42 <__alltraps>

001024a3 <vector25>:
.globl vector25
vector25:
  pushl $0
  1024a3:	6a 00                	push   $0x0
  pushl $25
  1024a5:	6a 19                	push   $0x19
  jmp __alltraps
  1024a7:	e9 96 09 00 00       	jmp    102e42 <__alltraps>

001024ac <vector26>:
.globl vector26
vector26:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $26
  1024ae:	6a 1a                	push   $0x1a
  jmp __alltraps
  1024b0:	e9 8d 09 00 00       	jmp    102e42 <__alltraps>

001024b5 <vector27>:
.globl vector27
vector27:
  pushl $0
  1024b5:	6a 00                	push   $0x0
  pushl $27
  1024b7:	6a 1b                	push   $0x1b
  jmp __alltraps
  1024b9:	e9 84 09 00 00       	jmp    102e42 <__alltraps>

001024be <vector28>:
.globl vector28
vector28:
  pushl $0
  1024be:	6a 00                	push   $0x0
  pushl $28
  1024c0:	6a 1c                	push   $0x1c
  jmp __alltraps
  1024c2:	e9 7b 09 00 00       	jmp    102e42 <__alltraps>

001024c7 <vector29>:
.globl vector29
vector29:
  pushl $0
  1024c7:	6a 00                	push   $0x0
  pushl $29
  1024c9:	6a 1d                	push   $0x1d
  jmp __alltraps
  1024cb:	e9 72 09 00 00       	jmp    102e42 <__alltraps>

001024d0 <vector30>:
.globl vector30
vector30:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $30
  1024d2:	6a 1e                	push   $0x1e
  jmp __alltraps
  1024d4:	e9 69 09 00 00       	jmp    102e42 <__alltraps>

001024d9 <vector31>:
.globl vector31
vector31:
  pushl $0
  1024d9:	6a 00                	push   $0x0
  pushl $31
  1024db:	6a 1f                	push   $0x1f
  jmp __alltraps
  1024dd:	e9 60 09 00 00       	jmp    102e42 <__alltraps>

001024e2 <vector32>:
.globl vector32
vector32:
  pushl $0
  1024e2:	6a 00                	push   $0x0
  pushl $32
  1024e4:	6a 20                	push   $0x20
  jmp __alltraps
  1024e6:	e9 57 09 00 00       	jmp    102e42 <__alltraps>

001024eb <vector33>:
.globl vector33
vector33:
  pushl $0
  1024eb:	6a 00                	push   $0x0
  pushl $33
  1024ed:	6a 21                	push   $0x21
  jmp __alltraps
  1024ef:	e9 4e 09 00 00       	jmp    102e42 <__alltraps>

001024f4 <vector34>:
.globl vector34
vector34:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $34
  1024f6:	6a 22                	push   $0x22
  jmp __alltraps
  1024f8:	e9 45 09 00 00       	jmp    102e42 <__alltraps>

001024fd <vector35>:
.globl vector35
vector35:
  pushl $0
  1024fd:	6a 00                	push   $0x0
  pushl $35
  1024ff:	6a 23                	push   $0x23
  jmp __alltraps
  102501:	e9 3c 09 00 00       	jmp    102e42 <__alltraps>

00102506 <vector36>:
.globl vector36
vector36:
  pushl $0
  102506:	6a 00                	push   $0x0
  pushl $36
  102508:	6a 24                	push   $0x24
  jmp __alltraps
  10250a:	e9 33 09 00 00       	jmp    102e42 <__alltraps>

0010250f <vector37>:
.globl vector37
vector37:
  pushl $0
  10250f:	6a 00                	push   $0x0
  pushl $37
  102511:	6a 25                	push   $0x25
  jmp __alltraps
  102513:	e9 2a 09 00 00       	jmp    102e42 <__alltraps>

00102518 <vector38>:
.globl vector38
vector38:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $38
  10251a:	6a 26                	push   $0x26
  jmp __alltraps
  10251c:	e9 21 09 00 00       	jmp    102e42 <__alltraps>

00102521 <vector39>:
.globl vector39
vector39:
  pushl $0
  102521:	6a 00                	push   $0x0
  pushl $39
  102523:	6a 27                	push   $0x27
  jmp __alltraps
  102525:	e9 18 09 00 00       	jmp    102e42 <__alltraps>

0010252a <vector40>:
.globl vector40
vector40:
  pushl $0
  10252a:	6a 00                	push   $0x0
  pushl $40
  10252c:	6a 28                	push   $0x28
  jmp __alltraps
  10252e:	e9 0f 09 00 00       	jmp    102e42 <__alltraps>

00102533 <vector41>:
.globl vector41
vector41:
  pushl $0
  102533:	6a 00                	push   $0x0
  pushl $41
  102535:	6a 29                	push   $0x29
  jmp __alltraps
  102537:	e9 06 09 00 00       	jmp    102e42 <__alltraps>

0010253c <vector42>:
.globl vector42
vector42:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $42
  10253e:	6a 2a                	push   $0x2a
  jmp __alltraps
  102540:	e9 fd 08 00 00       	jmp    102e42 <__alltraps>

00102545 <vector43>:
.globl vector43
vector43:
  pushl $0
  102545:	6a 00                	push   $0x0
  pushl $43
  102547:	6a 2b                	push   $0x2b
  jmp __alltraps
  102549:	e9 f4 08 00 00       	jmp    102e42 <__alltraps>

0010254e <vector44>:
.globl vector44
vector44:
  pushl $0
  10254e:	6a 00                	push   $0x0
  pushl $44
  102550:	6a 2c                	push   $0x2c
  jmp __alltraps
  102552:	e9 eb 08 00 00       	jmp    102e42 <__alltraps>

00102557 <vector45>:
.globl vector45
vector45:
  pushl $0
  102557:	6a 00                	push   $0x0
  pushl $45
  102559:	6a 2d                	push   $0x2d
  jmp __alltraps
  10255b:	e9 e2 08 00 00       	jmp    102e42 <__alltraps>

00102560 <vector46>:
.globl vector46
vector46:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $46
  102562:	6a 2e                	push   $0x2e
  jmp __alltraps
  102564:	e9 d9 08 00 00       	jmp    102e42 <__alltraps>

00102569 <vector47>:
.globl vector47
vector47:
  pushl $0
  102569:	6a 00                	push   $0x0
  pushl $47
  10256b:	6a 2f                	push   $0x2f
  jmp __alltraps
  10256d:	e9 d0 08 00 00       	jmp    102e42 <__alltraps>

00102572 <vector48>:
.globl vector48
vector48:
  pushl $0
  102572:	6a 00                	push   $0x0
  pushl $48
  102574:	6a 30                	push   $0x30
  jmp __alltraps
  102576:	e9 c7 08 00 00       	jmp    102e42 <__alltraps>

0010257b <vector49>:
.globl vector49
vector49:
  pushl $0
  10257b:	6a 00                	push   $0x0
  pushl $49
  10257d:	6a 31                	push   $0x31
  jmp __alltraps
  10257f:	e9 be 08 00 00       	jmp    102e42 <__alltraps>

00102584 <vector50>:
.globl vector50
vector50:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $50
  102586:	6a 32                	push   $0x32
  jmp __alltraps
  102588:	e9 b5 08 00 00       	jmp    102e42 <__alltraps>

0010258d <vector51>:
.globl vector51
vector51:
  pushl $0
  10258d:	6a 00                	push   $0x0
  pushl $51
  10258f:	6a 33                	push   $0x33
  jmp __alltraps
  102591:	e9 ac 08 00 00       	jmp    102e42 <__alltraps>

00102596 <vector52>:
.globl vector52
vector52:
  pushl $0
  102596:	6a 00                	push   $0x0
  pushl $52
  102598:	6a 34                	push   $0x34
  jmp __alltraps
  10259a:	e9 a3 08 00 00       	jmp    102e42 <__alltraps>

0010259f <vector53>:
.globl vector53
vector53:
  pushl $0
  10259f:	6a 00                	push   $0x0
  pushl $53
  1025a1:	6a 35                	push   $0x35
  jmp __alltraps
  1025a3:	e9 9a 08 00 00       	jmp    102e42 <__alltraps>

001025a8 <vector54>:
.globl vector54
vector54:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $54
  1025aa:	6a 36                	push   $0x36
  jmp __alltraps
  1025ac:	e9 91 08 00 00       	jmp    102e42 <__alltraps>

001025b1 <vector55>:
.globl vector55
vector55:
  pushl $0
  1025b1:	6a 00                	push   $0x0
  pushl $55
  1025b3:	6a 37                	push   $0x37
  jmp __alltraps
  1025b5:	e9 88 08 00 00       	jmp    102e42 <__alltraps>

001025ba <vector56>:
.globl vector56
vector56:
  pushl $0
  1025ba:	6a 00                	push   $0x0
  pushl $56
  1025bc:	6a 38                	push   $0x38
  jmp __alltraps
  1025be:	e9 7f 08 00 00       	jmp    102e42 <__alltraps>

001025c3 <vector57>:
.globl vector57
vector57:
  pushl $0
  1025c3:	6a 00                	push   $0x0
  pushl $57
  1025c5:	6a 39                	push   $0x39
  jmp __alltraps
  1025c7:	e9 76 08 00 00       	jmp    102e42 <__alltraps>

001025cc <vector58>:
.globl vector58
vector58:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $58
  1025ce:	6a 3a                	push   $0x3a
  jmp __alltraps
  1025d0:	e9 6d 08 00 00       	jmp    102e42 <__alltraps>

001025d5 <vector59>:
.globl vector59
vector59:
  pushl $0
  1025d5:	6a 00                	push   $0x0
  pushl $59
  1025d7:	6a 3b                	push   $0x3b
  jmp __alltraps
  1025d9:	e9 64 08 00 00       	jmp    102e42 <__alltraps>

001025de <vector60>:
.globl vector60
vector60:
  pushl $0
  1025de:	6a 00                	push   $0x0
  pushl $60
  1025e0:	6a 3c                	push   $0x3c
  jmp __alltraps
  1025e2:	e9 5b 08 00 00       	jmp    102e42 <__alltraps>

001025e7 <vector61>:
.globl vector61
vector61:
  pushl $0
  1025e7:	6a 00                	push   $0x0
  pushl $61
  1025e9:	6a 3d                	push   $0x3d
  jmp __alltraps
  1025eb:	e9 52 08 00 00       	jmp    102e42 <__alltraps>

001025f0 <vector62>:
.globl vector62
vector62:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $62
  1025f2:	6a 3e                	push   $0x3e
  jmp __alltraps
  1025f4:	e9 49 08 00 00       	jmp    102e42 <__alltraps>

001025f9 <vector63>:
.globl vector63
vector63:
  pushl $0
  1025f9:	6a 00                	push   $0x0
  pushl $63
  1025fb:	6a 3f                	push   $0x3f
  jmp __alltraps
  1025fd:	e9 40 08 00 00       	jmp    102e42 <__alltraps>

00102602 <vector64>:
.globl vector64
vector64:
  pushl $0
  102602:	6a 00                	push   $0x0
  pushl $64
  102604:	6a 40                	push   $0x40
  jmp __alltraps
  102606:	e9 37 08 00 00       	jmp    102e42 <__alltraps>

0010260b <vector65>:
.globl vector65
vector65:
  pushl $0
  10260b:	6a 00                	push   $0x0
  pushl $65
  10260d:	6a 41                	push   $0x41
  jmp __alltraps
  10260f:	e9 2e 08 00 00       	jmp    102e42 <__alltraps>

00102614 <vector66>:
.globl vector66
vector66:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $66
  102616:	6a 42                	push   $0x42
  jmp __alltraps
  102618:	e9 25 08 00 00       	jmp    102e42 <__alltraps>

0010261d <vector67>:
.globl vector67
vector67:
  pushl $0
  10261d:	6a 00                	push   $0x0
  pushl $67
  10261f:	6a 43                	push   $0x43
  jmp __alltraps
  102621:	e9 1c 08 00 00       	jmp    102e42 <__alltraps>

00102626 <vector68>:
.globl vector68
vector68:
  pushl $0
  102626:	6a 00                	push   $0x0
  pushl $68
  102628:	6a 44                	push   $0x44
  jmp __alltraps
  10262a:	e9 13 08 00 00       	jmp    102e42 <__alltraps>

0010262f <vector69>:
.globl vector69
vector69:
  pushl $0
  10262f:	6a 00                	push   $0x0
  pushl $69
  102631:	6a 45                	push   $0x45
  jmp __alltraps
  102633:	e9 0a 08 00 00       	jmp    102e42 <__alltraps>

00102638 <vector70>:
.globl vector70
vector70:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $70
  10263a:	6a 46                	push   $0x46
  jmp __alltraps
  10263c:	e9 01 08 00 00       	jmp    102e42 <__alltraps>

00102641 <vector71>:
.globl vector71
vector71:
  pushl $0
  102641:	6a 00                	push   $0x0
  pushl $71
  102643:	6a 47                	push   $0x47
  jmp __alltraps
  102645:	e9 f8 07 00 00       	jmp    102e42 <__alltraps>

0010264a <vector72>:
.globl vector72
vector72:
  pushl $0
  10264a:	6a 00                	push   $0x0
  pushl $72
  10264c:	6a 48                	push   $0x48
  jmp __alltraps
  10264e:	e9 ef 07 00 00       	jmp    102e42 <__alltraps>

00102653 <vector73>:
.globl vector73
vector73:
  pushl $0
  102653:	6a 00                	push   $0x0
  pushl $73
  102655:	6a 49                	push   $0x49
  jmp __alltraps
  102657:	e9 e6 07 00 00       	jmp    102e42 <__alltraps>

0010265c <vector74>:
.globl vector74
vector74:
  pushl $0
  10265c:	6a 00                	push   $0x0
  pushl $74
  10265e:	6a 4a                	push   $0x4a
  jmp __alltraps
  102660:	e9 dd 07 00 00       	jmp    102e42 <__alltraps>

00102665 <vector75>:
.globl vector75
vector75:
  pushl $0
  102665:	6a 00                	push   $0x0
  pushl $75
  102667:	6a 4b                	push   $0x4b
  jmp __alltraps
  102669:	e9 d4 07 00 00       	jmp    102e42 <__alltraps>

0010266e <vector76>:
.globl vector76
vector76:
  pushl $0
  10266e:	6a 00                	push   $0x0
  pushl $76
  102670:	6a 4c                	push   $0x4c
  jmp __alltraps
  102672:	e9 cb 07 00 00       	jmp    102e42 <__alltraps>

00102677 <vector77>:
.globl vector77
vector77:
  pushl $0
  102677:	6a 00                	push   $0x0
  pushl $77
  102679:	6a 4d                	push   $0x4d
  jmp __alltraps
  10267b:	e9 c2 07 00 00       	jmp    102e42 <__alltraps>

00102680 <vector78>:
.globl vector78
vector78:
  pushl $0
  102680:	6a 00                	push   $0x0
  pushl $78
  102682:	6a 4e                	push   $0x4e
  jmp __alltraps
  102684:	e9 b9 07 00 00       	jmp    102e42 <__alltraps>

00102689 <vector79>:
.globl vector79
vector79:
  pushl $0
  102689:	6a 00                	push   $0x0
  pushl $79
  10268b:	6a 4f                	push   $0x4f
  jmp __alltraps
  10268d:	e9 b0 07 00 00       	jmp    102e42 <__alltraps>

00102692 <vector80>:
.globl vector80
vector80:
  pushl $0
  102692:	6a 00                	push   $0x0
  pushl $80
  102694:	6a 50                	push   $0x50
  jmp __alltraps
  102696:	e9 a7 07 00 00       	jmp    102e42 <__alltraps>

0010269b <vector81>:
.globl vector81
vector81:
  pushl $0
  10269b:	6a 00                	push   $0x0
  pushl $81
  10269d:	6a 51                	push   $0x51
  jmp __alltraps
  10269f:	e9 9e 07 00 00       	jmp    102e42 <__alltraps>

001026a4 <vector82>:
.globl vector82
vector82:
  pushl $0
  1026a4:	6a 00                	push   $0x0
  pushl $82
  1026a6:	6a 52                	push   $0x52
  jmp __alltraps
  1026a8:	e9 95 07 00 00       	jmp    102e42 <__alltraps>

001026ad <vector83>:
.globl vector83
vector83:
  pushl $0
  1026ad:	6a 00                	push   $0x0
  pushl $83
  1026af:	6a 53                	push   $0x53
  jmp __alltraps
  1026b1:	e9 8c 07 00 00       	jmp    102e42 <__alltraps>

001026b6 <vector84>:
.globl vector84
vector84:
  pushl $0
  1026b6:	6a 00                	push   $0x0
  pushl $84
  1026b8:	6a 54                	push   $0x54
  jmp __alltraps
  1026ba:	e9 83 07 00 00       	jmp    102e42 <__alltraps>

001026bf <vector85>:
.globl vector85
vector85:
  pushl $0
  1026bf:	6a 00                	push   $0x0
  pushl $85
  1026c1:	6a 55                	push   $0x55
  jmp __alltraps
  1026c3:	e9 7a 07 00 00       	jmp    102e42 <__alltraps>

001026c8 <vector86>:
.globl vector86
vector86:
  pushl $0
  1026c8:	6a 00                	push   $0x0
  pushl $86
  1026ca:	6a 56                	push   $0x56
  jmp __alltraps
  1026cc:	e9 71 07 00 00       	jmp    102e42 <__alltraps>

001026d1 <vector87>:
.globl vector87
vector87:
  pushl $0
  1026d1:	6a 00                	push   $0x0
  pushl $87
  1026d3:	6a 57                	push   $0x57
  jmp __alltraps
  1026d5:	e9 68 07 00 00       	jmp    102e42 <__alltraps>

001026da <vector88>:
.globl vector88
vector88:
  pushl $0
  1026da:	6a 00                	push   $0x0
  pushl $88
  1026dc:	6a 58                	push   $0x58
  jmp __alltraps
  1026de:	e9 5f 07 00 00       	jmp    102e42 <__alltraps>

001026e3 <vector89>:
.globl vector89
vector89:
  pushl $0
  1026e3:	6a 00                	push   $0x0
  pushl $89
  1026e5:	6a 59                	push   $0x59
  jmp __alltraps
  1026e7:	e9 56 07 00 00       	jmp    102e42 <__alltraps>

001026ec <vector90>:
.globl vector90
vector90:
  pushl $0
  1026ec:	6a 00                	push   $0x0
  pushl $90
  1026ee:	6a 5a                	push   $0x5a
  jmp __alltraps
  1026f0:	e9 4d 07 00 00       	jmp    102e42 <__alltraps>

001026f5 <vector91>:
.globl vector91
vector91:
  pushl $0
  1026f5:	6a 00                	push   $0x0
  pushl $91
  1026f7:	6a 5b                	push   $0x5b
  jmp __alltraps
  1026f9:	e9 44 07 00 00       	jmp    102e42 <__alltraps>

001026fe <vector92>:
.globl vector92
vector92:
  pushl $0
  1026fe:	6a 00                	push   $0x0
  pushl $92
  102700:	6a 5c                	push   $0x5c
  jmp __alltraps
  102702:	e9 3b 07 00 00       	jmp    102e42 <__alltraps>

00102707 <vector93>:
.globl vector93
vector93:
  pushl $0
  102707:	6a 00                	push   $0x0
  pushl $93
  102709:	6a 5d                	push   $0x5d
  jmp __alltraps
  10270b:	e9 32 07 00 00       	jmp    102e42 <__alltraps>

00102710 <vector94>:
.globl vector94
vector94:
  pushl $0
  102710:	6a 00                	push   $0x0
  pushl $94
  102712:	6a 5e                	push   $0x5e
  jmp __alltraps
  102714:	e9 29 07 00 00       	jmp    102e42 <__alltraps>

00102719 <vector95>:
.globl vector95
vector95:
  pushl $0
  102719:	6a 00                	push   $0x0
  pushl $95
  10271b:	6a 5f                	push   $0x5f
  jmp __alltraps
  10271d:	e9 20 07 00 00       	jmp    102e42 <__alltraps>

00102722 <vector96>:
.globl vector96
vector96:
  pushl $0
  102722:	6a 00                	push   $0x0
  pushl $96
  102724:	6a 60                	push   $0x60
  jmp __alltraps
  102726:	e9 17 07 00 00       	jmp    102e42 <__alltraps>

0010272b <vector97>:
.globl vector97
vector97:
  pushl $0
  10272b:	6a 00                	push   $0x0
  pushl $97
  10272d:	6a 61                	push   $0x61
  jmp __alltraps
  10272f:	e9 0e 07 00 00       	jmp    102e42 <__alltraps>

00102734 <vector98>:
.globl vector98
vector98:
  pushl $0
  102734:	6a 00                	push   $0x0
  pushl $98
  102736:	6a 62                	push   $0x62
  jmp __alltraps
  102738:	e9 05 07 00 00       	jmp    102e42 <__alltraps>

0010273d <vector99>:
.globl vector99
vector99:
  pushl $0
  10273d:	6a 00                	push   $0x0
  pushl $99
  10273f:	6a 63                	push   $0x63
  jmp __alltraps
  102741:	e9 fc 06 00 00       	jmp    102e42 <__alltraps>

00102746 <vector100>:
.globl vector100
vector100:
  pushl $0
  102746:	6a 00                	push   $0x0
  pushl $100
  102748:	6a 64                	push   $0x64
  jmp __alltraps
  10274a:	e9 f3 06 00 00       	jmp    102e42 <__alltraps>

0010274f <vector101>:
.globl vector101
vector101:
  pushl $0
  10274f:	6a 00                	push   $0x0
  pushl $101
  102751:	6a 65                	push   $0x65
  jmp __alltraps
  102753:	e9 ea 06 00 00       	jmp    102e42 <__alltraps>

00102758 <vector102>:
.globl vector102
vector102:
  pushl $0
  102758:	6a 00                	push   $0x0
  pushl $102
  10275a:	6a 66                	push   $0x66
  jmp __alltraps
  10275c:	e9 e1 06 00 00       	jmp    102e42 <__alltraps>

00102761 <vector103>:
.globl vector103
vector103:
  pushl $0
  102761:	6a 00                	push   $0x0
  pushl $103
  102763:	6a 67                	push   $0x67
  jmp __alltraps
  102765:	e9 d8 06 00 00       	jmp    102e42 <__alltraps>

0010276a <vector104>:
.globl vector104
vector104:
  pushl $0
  10276a:	6a 00                	push   $0x0
  pushl $104
  10276c:	6a 68                	push   $0x68
  jmp __alltraps
  10276e:	e9 cf 06 00 00       	jmp    102e42 <__alltraps>

00102773 <vector105>:
.globl vector105
vector105:
  pushl $0
  102773:	6a 00                	push   $0x0
  pushl $105
  102775:	6a 69                	push   $0x69
  jmp __alltraps
  102777:	e9 c6 06 00 00       	jmp    102e42 <__alltraps>

0010277c <vector106>:
.globl vector106
vector106:
  pushl $0
  10277c:	6a 00                	push   $0x0
  pushl $106
  10277e:	6a 6a                	push   $0x6a
  jmp __alltraps
  102780:	e9 bd 06 00 00       	jmp    102e42 <__alltraps>

00102785 <vector107>:
.globl vector107
vector107:
  pushl $0
  102785:	6a 00                	push   $0x0
  pushl $107
  102787:	6a 6b                	push   $0x6b
  jmp __alltraps
  102789:	e9 b4 06 00 00       	jmp    102e42 <__alltraps>

0010278e <vector108>:
.globl vector108
vector108:
  pushl $0
  10278e:	6a 00                	push   $0x0
  pushl $108
  102790:	6a 6c                	push   $0x6c
  jmp __alltraps
  102792:	e9 ab 06 00 00       	jmp    102e42 <__alltraps>

00102797 <vector109>:
.globl vector109
vector109:
  pushl $0
  102797:	6a 00                	push   $0x0
  pushl $109
  102799:	6a 6d                	push   $0x6d
  jmp __alltraps
  10279b:	e9 a2 06 00 00       	jmp    102e42 <__alltraps>

001027a0 <vector110>:
.globl vector110
vector110:
  pushl $0
  1027a0:	6a 00                	push   $0x0
  pushl $110
  1027a2:	6a 6e                	push   $0x6e
  jmp __alltraps
  1027a4:	e9 99 06 00 00       	jmp    102e42 <__alltraps>

001027a9 <vector111>:
.globl vector111
vector111:
  pushl $0
  1027a9:	6a 00                	push   $0x0
  pushl $111
  1027ab:	6a 6f                	push   $0x6f
  jmp __alltraps
  1027ad:	e9 90 06 00 00       	jmp    102e42 <__alltraps>

001027b2 <vector112>:
.globl vector112
vector112:
  pushl $0
  1027b2:	6a 00                	push   $0x0
  pushl $112
  1027b4:	6a 70                	push   $0x70
  jmp __alltraps
  1027b6:	e9 87 06 00 00       	jmp    102e42 <__alltraps>

001027bb <vector113>:
.globl vector113
vector113:
  pushl $0
  1027bb:	6a 00                	push   $0x0
  pushl $113
  1027bd:	6a 71                	push   $0x71
  jmp __alltraps
  1027bf:	e9 7e 06 00 00       	jmp    102e42 <__alltraps>

001027c4 <vector114>:
.globl vector114
vector114:
  pushl $0
  1027c4:	6a 00                	push   $0x0
  pushl $114
  1027c6:	6a 72                	push   $0x72
  jmp __alltraps
  1027c8:	e9 75 06 00 00       	jmp    102e42 <__alltraps>

001027cd <vector115>:
.globl vector115
vector115:
  pushl $0
  1027cd:	6a 00                	push   $0x0
  pushl $115
  1027cf:	6a 73                	push   $0x73
  jmp __alltraps
  1027d1:	e9 6c 06 00 00       	jmp    102e42 <__alltraps>

001027d6 <vector116>:
.globl vector116
vector116:
  pushl $0
  1027d6:	6a 00                	push   $0x0
  pushl $116
  1027d8:	6a 74                	push   $0x74
  jmp __alltraps
  1027da:	e9 63 06 00 00       	jmp    102e42 <__alltraps>

001027df <vector117>:
.globl vector117
vector117:
  pushl $0
  1027df:	6a 00                	push   $0x0
  pushl $117
  1027e1:	6a 75                	push   $0x75
  jmp __alltraps
  1027e3:	e9 5a 06 00 00       	jmp    102e42 <__alltraps>

001027e8 <vector118>:
.globl vector118
vector118:
  pushl $0
  1027e8:	6a 00                	push   $0x0
  pushl $118
  1027ea:	6a 76                	push   $0x76
  jmp __alltraps
  1027ec:	e9 51 06 00 00       	jmp    102e42 <__alltraps>

001027f1 <vector119>:
.globl vector119
vector119:
  pushl $0
  1027f1:	6a 00                	push   $0x0
  pushl $119
  1027f3:	6a 77                	push   $0x77
  jmp __alltraps
  1027f5:	e9 48 06 00 00       	jmp    102e42 <__alltraps>

001027fa <vector120>:
.globl vector120
vector120:
  pushl $0
  1027fa:	6a 00                	push   $0x0
  pushl $120
  1027fc:	6a 78                	push   $0x78
  jmp __alltraps
  1027fe:	e9 3f 06 00 00       	jmp    102e42 <__alltraps>

00102803 <vector121>:
.globl vector121
vector121:
  pushl $0
  102803:	6a 00                	push   $0x0
  pushl $121
  102805:	6a 79                	push   $0x79
  jmp __alltraps
  102807:	e9 36 06 00 00       	jmp    102e42 <__alltraps>

0010280c <vector122>:
.globl vector122
vector122:
  pushl $0
  10280c:	6a 00                	push   $0x0
  pushl $122
  10280e:	6a 7a                	push   $0x7a
  jmp __alltraps
  102810:	e9 2d 06 00 00       	jmp    102e42 <__alltraps>

00102815 <vector123>:
.globl vector123
vector123:
  pushl $0
  102815:	6a 00                	push   $0x0
  pushl $123
  102817:	6a 7b                	push   $0x7b
  jmp __alltraps
  102819:	e9 24 06 00 00       	jmp    102e42 <__alltraps>

0010281e <vector124>:
.globl vector124
vector124:
  pushl $0
  10281e:	6a 00                	push   $0x0
  pushl $124
  102820:	6a 7c                	push   $0x7c
  jmp __alltraps
  102822:	e9 1b 06 00 00       	jmp    102e42 <__alltraps>

00102827 <vector125>:
.globl vector125
vector125:
  pushl $0
  102827:	6a 00                	push   $0x0
  pushl $125
  102829:	6a 7d                	push   $0x7d
  jmp __alltraps
  10282b:	e9 12 06 00 00       	jmp    102e42 <__alltraps>

00102830 <vector126>:
.globl vector126
vector126:
  pushl $0
  102830:	6a 00                	push   $0x0
  pushl $126
  102832:	6a 7e                	push   $0x7e
  jmp __alltraps
  102834:	e9 09 06 00 00       	jmp    102e42 <__alltraps>

00102839 <vector127>:
.globl vector127
vector127:
  pushl $0
  102839:	6a 00                	push   $0x0
  pushl $127
  10283b:	6a 7f                	push   $0x7f
  jmp __alltraps
  10283d:	e9 00 06 00 00       	jmp    102e42 <__alltraps>

00102842 <vector128>:
.globl vector128
vector128:
  pushl $0
  102842:	6a 00                	push   $0x0
  pushl $128
  102844:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102849:	e9 f4 05 00 00       	jmp    102e42 <__alltraps>

0010284e <vector129>:
.globl vector129
vector129:
  pushl $0
  10284e:	6a 00                	push   $0x0
  pushl $129
  102850:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102855:	e9 e8 05 00 00       	jmp    102e42 <__alltraps>

0010285a <vector130>:
.globl vector130
vector130:
  pushl $0
  10285a:	6a 00                	push   $0x0
  pushl $130
  10285c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102861:	e9 dc 05 00 00       	jmp    102e42 <__alltraps>

00102866 <vector131>:
.globl vector131
vector131:
  pushl $0
  102866:	6a 00                	push   $0x0
  pushl $131
  102868:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10286d:	e9 d0 05 00 00       	jmp    102e42 <__alltraps>

00102872 <vector132>:
.globl vector132
vector132:
  pushl $0
  102872:	6a 00                	push   $0x0
  pushl $132
  102874:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102879:	e9 c4 05 00 00       	jmp    102e42 <__alltraps>

0010287e <vector133>:
.globl vector133
vector133:
  pushl $0
  10287e:	6a 00                	push   $0x0
  pushl $133
  102880:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102885:	e9 b8 05 00 00       	jmp    102e42 <__alltraps>

0010288a <vector134>:
.globl vector134
vector134:
  pushl $0
  10288a:	6a 00                	push   $0x0
  pushl $134
  10288c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102891:	e9 ac 05 00 00       	jmp    102e42 <__alltraps>

00102896 <vector135>:
.globl vector135
vector135:
  pushl $0
  102896:	6a 00                	push   $0x0
  pushl $135
  102898:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10289d:	e9 a0 05 00 00       	jmp    102e42 <__alltraps>

001028a2 <vector136>:
.globl vector136
vector136:
  pushl $0
  1028a2:	6a 00                	push   $0x0
  pushl $136
  1028a4:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1028a9:	e9 94 05 00 00       	jmp    102e42 <__alltraps>

001028ae <vector137>:
.globl vector137
vector137:
  pushl $0
  1028ae:	6a 00                	push   $0x0
  pushl $137
  1028b0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1028b5:	e9 88 05 00 00       	jmp    102e42 <__alltraps>

001028ba <vector138>:
.globl vector138
vector138:
  pushl $0
  1028ba:	6a 00                	push   $0x0
  pushl $138
  1028bc:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1028c1:	e9 7c 05 00 00       	jmp    102e42 <__alltraps>

001028c6 <vector139>:
.globl vector139
vector139:
  pushl $0
  1028c6:	6a 00                	push   $0x0
  pushl $139
  1028c8:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1028cd:	e9 70 05 00 00       	jmp    102e42 <__alltraps>

001028d2 <vector140>:
.globl vector140
vector140:
  pushl $0
  1028d2:	6a 00                	push   $0x0
  pushl $140
  1028d4:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1028d9:	e9 64 05 00 00       	jmp    102e42 <__alltraps>

001028de <vector141>:
.globl vector141
vector141:
  pushl $0
  1028de:	6a 00                	push   $0x0
  pushl $141
  1028e0:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1028e5:	e9 58 05 00 00       	jmp    102e42 <__alltraps>

001028ea <vector142>:
.globl vector142
vector142:
  pushl $0
  1028ea:	6a 00                	push   $0x0
  pushl $142
  1028ec:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1028f1:	e9 4c 05 00 00       	jmp    102e42 <__alltraps>

001028f6 <vector143>:
.globl vector143
vector143:
  pushl $0
  1028f6:	6a 00                	push   $0x0
  pushl $143
  1028f8:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1028fd:	e9 40 05 00 00       	jmp    102e42 <__alltraps>

00102902 <vector144>:
.globl vector144
vector144:
  pushl $0
  102902:	6a 00                	push   $0x0
  pushl $144
  102904:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102909:	e9 34 05 00 00       	jmp    102e42 <__alltraps>

0010290e <vector145>:
.globl vector145
vector145:
  pushl $0
  10290e:	6a 00                	push   $0x0
  pushl $145
  102910:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102915:	e9 28 05 00 00       	jmp    102e42 <__alltraps>

0010291a <vector146>:
.globl vector146
vector146:
  pushl $0
  10291a:	6a 00                	push   $0x0
  pushl $146
  10291c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102921:	e9 1c 05 00 00       	jmp    102e42 <__alltraps>

00102926 <vector147>:
.globl vector147
vector147:
  pushl $0
  102926:	6a 00                	push   $0x0
  pushl $147
  102928:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10292d:	e9 10 05 00 00       	jmp    102e42 <__alltraps>

00102932 <vector148>:
.globl vector148
vector148:
  pushl $0
  102932:	6a 00                	push   $0x0
  pushl $148
  102934:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102939:	e9 04 05 00 00       	jmp    102e42 <__alltraps>

0010293e <vector149>:
.globl vector149
vector149:
  pushl $0
  10293e:	6a 00                	push   $0x0
  pushl $149
  102940:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102945:	e9 f8 04 00 00       	jmp    102e42 <__alltraps>

0010294a <vector150>:
.globl vector150
vector150:
  pushl $0
  10294a:	6a 00                	push   $0x0
  pushl $150
  10294c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102951:	e9 ec 04 00 00       	jmp    102e42 <__alltraps>

00102956 <vector151>:
.globl vector151
vector151:
  pushl $0
  102956:	6a 00                	push   $0x0
  pushl $151
  102958:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10295d:	e9 e0 04 00 00       	jmp    102e42 <__alltraps>

00102962 <vector152>:
.globl vector152
vector152:
  pushl $0
  102962:	6a 00                	push   $0x0
  pushl $152
  102964:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102969:	e9 d4 04 00 00       	jmp    102e42 <__alltraps>

0010296e <vector153>:
.globl vector153
vector153:
  pushl $0
  10296e:	6a 00                	push   $0x0
  pushl $153
  102970:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102975:	e9 c8 04 00 00       	jmp    102e42 <__alltraps>

0010297a <vector154>:
.globl vector154
vector154:
  pushl $0
  10297a:	6a 00                	push   $0x0
  pushl $154
  10297c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102981:	e9 bc 04 00 00       	jmp    102e42 <__alltraps>

00102986 <vector155>:
.globl vector155
vector155:
  pushl $0
  102986:	6a 00                	push   $0x0
  pushl $155
  102988:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10298d:	e9 b0 04 00 00       	jmp    102e42 <__alltraps>

00102992 <vector156>:
.globl vector156
vector156:
  pushl $0
  102992:	6a 00                	push   $0x0
  pushl $156
  102994:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102999:	e9 a4 04 00 00       	jmp    102e42 <__alltraps>

0010299e <vector157>:
.globl vector157
vector157:
  pushl $0
  10299e:	6a 00                	push   $0x0
  pushl $157
  1029a0:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1029a5:	e9 98 04 00 00       	jmp    102e42 <__alltraps>

001029aa <vector158>:
.globl vector158
vector158:
  pushl $0
  1029aa:	6a 00                	push   $0x0
  pushl $158
  1029ac:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1029b1:	e9 8c 04 00 00       	jmp    102e42 <__alltraps>

001029b6 <vector159>:
.globl vector159
vector159:
  pushl $0
  1029b6:	6a 00                	push   $0x0
  pushl $159
  1029b8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1029bd:	e9 80 04 00 00       	jmp    102e42 <__alltraps>

001029c2 <vector160>:
.globl vector160
vector160:
  pushl $0
  1029c2:	6a 00                	push   $0x0
  pushl $160
  1029c4:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1029c9:	e9 74 04 00 00       	jmp    102e42 <__alltraps>

001029ce <vector161>:
.globl vector161
vector161:
  pushl $0
  1029ce:	6a 00                	push   $0x0
  pushl $161
  1029d0:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1029d5:	e9 68 04 00 00       	jmp    102e42 <__alltraps>

001029da <vector162>:
.globl vector162
vector162:
  pushl $0
  1029da:	6a 00                	push   $0x0
  pushl $162
  1029dc:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1029e1:	e9 5c 04 00 00       	jmp    102e42 <__alltraps>

001029e6 <vector163>:
.globl vector163
vector163:
  pushl $0
  1029e6:	6a 00                	push   $0x0
  pushl $163
  1029e8:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1029ed:	e9 50 04 00 00       	jmp    102e42 <__alltraps>

001029f2 <vector164>:
.globl vector164
vector164:
  pushl $0
  1029f2:	6a 00                	push   $0x0
  pushl $164
  1029f4:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1029f9:	e9 44 04 00 00       	jmp    102e42 <__alltraps>

001029fe <vector165>:
.globl vector165
vector165:
  pushl $0
  1029fe:	6a 00                	push   $0x0
  pushl $165
  102a00:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102a05:	e9 38 04 00 00       	jmp    102e42 <__alltraps>

00102a0a <vector166>:
.globl vector166
vector166:
  pushl $0
  102a0a:	6a 00                	push   $0x0
  pushl $166
  102a0c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102a11:	e9 2c 04 00 00       	jmp    102e42 <__alltraps>

00102a16 <vector167>:
.globl vector167
vector167:
  pushl $0
  102a16:	6a 00                	push   $0x0
  pushl $167
  102a18:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102a1d:	e9 20 04 00 00       	jmp    102e42 <__alltraps>

00102a22 <vector168>:
.globl vector168
vector168:
  pushl $0
  102a22:	6a 00                	push   $0x0
  pushl $168
  102a24:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102a29:	e9 14 04 00 00       	jmp    102e42 <__alltraps>

00102a2e <vector169>:
.globl vector169
vector169:
  pushl $0
  102a2e:	6a 00                	push   $0x0
  pushl $169
  102a30:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102a35:	e9 08 04 00 00       	jmp    102e42 <__alltraps>

00102a3a <vector170>:
.globl vector170
vector170:
  pushl $0
  102a3a:	6a 00                	push   $0x0
  pushl $170
  102a3c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102a41:	e9 fc 03 00 00       	jmp    102e42 <__alltraps>

00102a46 <vector171>:
.globl vector171
vector171:
  pushl $0
  102a46:	6a 00                	push   $0x0
  pushl $171
  102a48:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102a4d:	e9 f0 03 00 00       	jmp    102e42 <__alltraps>

00102a52 <vector172>:
.globl vector172
vector172:
  pushl $0
  102a52:	6a 00                	push   $0x0
  pushl $172
  102a54:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102a59:	e9 e4 03 00 00       	jmp    102e42 <__alltraps>

00102a5e <vector173>:
.globl vector173
vector173:
  pushl $0
  102a5e:	6a 00                	push   $0x0
  pushl $173
  102a60:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102a65:	e9 d8 03 00 00       	jmp    102e42 <__alltraps>

00102a6a <vector174>:
.globl vector174
vector174:
  pushl $0
  102a6a:	6a 00                	push   $0x0
  pushl $174
  102a6c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102a71:	e9 cc 03 00 00       	jmp    102e42 <__alltraps>

00102a76 <vector175>:
.globl vector175
vector175:
  pushl $0
  102a76:	6a 00                	push   $0x0
  pushl $175
  102a78:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102a7d:	e9 c0 03 00 00       	jmp    102e42 <__alltraps>

00102a82 <vector176>:
.globl vector176
vector176:
  pushl $0
  102a82:	6a 00                	push   $0x0
  pushl $176
  102a84:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102a89:	e9 b4 03 00 00       	jmp    102e42 <__alltraps>

00102a8e <vector177>:
.globl vector177
vector177:
  pushl $0
  102a8e:	6a 00                	push   $0x0
  pushl $177
  102a90:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102a95:	e9 a8 03 00 00       	jmp    102e42 <__alltraps>

00102a9a <vector178>:
.globl vector178
vector178:
  pushl $0
  102a9a:	6a 00                	push   $0x0
  pushl $178
  102a9c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102aa1:	e9 9c 03 00 00       	jmp    102e42 <__alltraps>

00102aa6 <vector179>:
.globl vector179
vector179:
  pushl $0
  102aa6:	6a 00                	push   $0x0
  pushl $179
  102aa8:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102aad:	e9 90 03 00 00       	jmp    102e42 <__alltraps>

00102ab2 <vector180>:
.globl vector180
vector180:
  pushl $0
  102ab2:	6a 00                	push   $0x0
  pushl $180
  102ab4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102ab9:	e9 84 03 00 00       	jmp    102e42 <__alltraps>

00102abe <vector181>:
.globl vector181
vector181:
  pushl $0
  102abe:	6a 00                	push   $0x0
  pushl $181
  102ac0:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102ac5:	e9 78 03 00 00       	jmp    102e42 <__alltraps>

00102aca <vector182>:
.globl vector182
vector182:
  pushl $0
  102aca:	6a 00                	push   $0x0
  pushl $182
  102acc:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102ad1:	e9 6c 03 00 00       	jmp    102e42 <__alltraps>

00102ad6 <vector183>:
.globl vector183
vector183:
  pushl $0
  102ad6:	6a 00                	push   $0x0
  pushl $183
  102ad8:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102add:	e9 60 03 00 00       	jmp    102e42 <__alltraps>

00102ae2 <vector184>:
.globl vector184
vector184:
  pushl $0
  102ae2:	6a 00                	push   $0x0
  pushl $184
  102ae4:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102ae9:	e9 54 03 00 00       	jmp    102e42 <__alltraps>

00102aee <vector185>:
.globl vector185
vector185:
  pushl $0
  102aee:	6a 00                	push   $0x0
  pushl $185
  102af0:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102af5:	e9 48 03 00 00       	jmp    102e42 <__alltraps>

00102afa <vector186>:
.globl vector186
vector186:
  pushl $0
  102afa:	6a 00                	push   $0x0
  pushl $186
  102afc:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102b01:	e9 3c 03 00 00       	jmp    102e42 <__alltraps>

00102b06 <vector187>:
.globl vector187
vector187:
  pushl $0
  102b06:	6a 00                	push   $0x0
  pushl $187
  102b08:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102b0d:	e9 30 03 00 00       	jmp    102e42 <__alltraps>

00102b12 <vector188>:
.globl vector188
vector188:
  pushl $0
  102b12:	6a 00                	push   $0x0
  pushl $188
  102b14:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102b19:	e9 24 03 00 00       	jmp    102e42 <__alltraps>

00102b1e <vector189>:
.globl vector189
vector189:
  pushl $0
  102b1e:	6a 00                	push   $0x0
  pushl $189
  102b20:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102b25:	e9 18 03 00 00       	jmp    102e42 <__alltraps>

00102b2a <vector190>:
.globl vector190
vector190:
  pushl $0
  102b2a:	6a 00                	push   $0x0
  pushl $190
  102b2c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102b31:	e9 0c 03 00 00       	jmp    102e42 <__alltraps>

00102b36 <vector191>:
.globl vector191
vector191:
  pushl $0
  102b36:	6a 00                	push   $0x0
  pushl $191
  102b38:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102b3d:	e9 00 03 00 00       	jmp    102e42 <__alltraps>

00102b42 <vector192>:
.globl vector192
vector192:
  pushl $0
  102b42:	6a 00                	push   $0x0
  pushl $192
  102b44:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102b49:	e9 f4 02 00 00       	jmp    102e42 <__alltraps>

00102b4e <vector193>:
.globl vector193
vector193:
  pushl $0
  102b4e:	6a 00                	push   $0x0
  pushl $193
  102b50:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102b55:	e9 e8 02 00 00       	jmp    102e42 <__alltraps>

00102b5a <vector194>:
.globl vector194
vector194:
  pushl $0
  102b5a:	6a 00                	push   $0x0
  pushl $194
  102b5c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102b61:	e9 dc 02 00 00       	jmp    102e42 <__alltraps>

00102b66 <vector195>:
.globl vector195
vector195:
  pushl $0
  102b66:	6a 00                	push   $0x0
  pushl $195
  102b68:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102b6d:	e9 d0 02 00 00       	jmp    102e42 <__alltraps>

00102b72 <vector196>:
.globl vector196
vector196:
  pushl $0
  102b72:	6a 00                	push   $0x0
  pushl $196
  102b74:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102b79:	e9 c4 02 00 00       	jmp    102e42 <__alltraps>

00102b7e <vector197>:
.globl vector197
vector197:
  pushl $0
  102b7e:	6a 00                	push   $0x0
  pushl $197
  102b80:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102b85:	e9 b8 02 00 00       	jmp    102e42 <__alltraps>

00102b8a <vector198>:
.globl vector198
vector198:
  pushl $0
  102b8a:	6a 00                	push   $0x0
  pushl $198
  102b8c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102b91:	e9 ac 02 00 00       	jmp    102e42 <__alltraps>

00102b96 <vector199>:
.globl vector199
vector199:
  pushl $0
  102b96:	6a 00                	push   $0x0
  pushl $199
  102b98:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102b9d:	e9 a0 02 00 00       	jmp    102e42 <__alltraps>

00102ba2 <vector200>:
.globl vector200
vector200:
  pushl $0
  102ba2:	6a 00                	push   $0x0
  pushl $200
  102ba4:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102ba9:	e9 94 02 00 00       	jmp    102e42 <__alltraps>

00102bae <vector201>:
.globl vector201
vector201:
  pushl $0
  102bae:	6a 00                	push   $0x0
  pushl $201
  102bb0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102bb5:	e9 88 02 00 00       	jmp    102e42 <__alltraps>

00102bba <vector202>:
.globl vector202
vector202:
  pushl $0
  102bba:	6a 00                	push   $0x0
  pushl $202
  102bbc:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102bc1:	e9 7c 02 00 00       	jmp    102e42 <__alltraps>

00102bc6 <vector203>:
.globl vector203
vector203:
  pushl $0
  102bc6:	6a 00                	push   $0x0
  pushl $203
  102bc8:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102bcd:	e9 70 02 00 00       	jmp    102e42 <__alltraps>

00102bd2 <vector204>:
.globl vector204
vector204:
  pushl $0
  102bd2:	6a 00                	push   $0x0
  pushl $204
  102bd4:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102bd9:	e9 64 02 00 00       	jmp    102e42 <__alltraps>

00102bde <vector205>:
.globl vector205
vector205:
  pushl $0
  102bde:	6a 00                	push   $0x0
  pushl $205
  102be0:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102be5:	e9 58 02 00 00       	jmp    102e42 <__alltraps>

00102bea <vector206>:
.globl vector206
vector206:
  pushl $0
  102bea:	6a 00                	push   $0x0
  pushl $206
  102bec:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102bf1:	e9 4c 02 00 00       	jmp    102e42 <__alltraps>

00102bf6 <vector207>:
.globl vector207
vector207:
  pushl $0
  102bf6:	6a 00                	push   $0x0
  pushl $207
  102bf8:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102bfd:	e9 40 02 00 00       	jmp    102e42 <__alltraps>

00102c02 <vector208>:
.globl vector208
vector208:
  pushl $0
  102c02:	6a 00                	push   $0x0
  pushl $208
  102c04:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102c09:	e9 34 02 00 00       	jmp    102e42 <__alltraps>

00102c0e <vector209>:
.globl vector209
vector209:
  pushl $0
  102c0e:	6a 00                	push   $0x0
  pushl $209
  102c10:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102c15:	e9 28 02 00 00       	jmp    102e42 <__alltraps>

00102c1a <vector210>:
.globl vector210
vector210:
  pushl $0
  102c1a:	6a 00                	push   $0x0
  pushl $210
  102c1c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102c21:	e9 1c 02 00 00       	jmp    102e42 <__alltraps>

00102c26 <vector211>:
.globl vector211
vector211:
  pushl $0
  102c26:	6a 00                	push   $0x0
  pushl $211
  102c28:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102c2d:	e9 10 02 00 00       	jmp    102e42 <__alltraps>

00102c32 <vector212>:
.globl vector212
vector212:
  pushl $0
  102c32:	6a 00                	push   $0x0
  pushl $212
  102c34:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102c39:	e9 04 02 00 00       	jmp    102e42 <__alltraps>

00102c3e <vector213>:
.globl vector213
vector213:
  pushl $0
  102c3e:	6a 00                	push   $0x0
  pushl $213
  102c40:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102c45:	e9 f8 01 00 00       	jmp    102e42 <__alltraps>

00102c4a <vector214>:
.globl vector214
vector214:
  pushl $0
  102c4a:	6a 00                	push   $0x0
  pushl $214
  102c4c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102c51:	e9 ec 01 00 00       	jmp    102e42 <__alltraps>

00102c56 <vector215>:
.globl vector215
vector215:
  pushl $0
  102c56:	6a 00                	push   $0x0
  pushl $215
  102c58:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102c5d:	e9 e0 01 00 00       	jmp    102e42 <__alltraps>

00102c62 <vector216>:
.globl vector216
vector216:
  pushl $0
  102c62:	6a 00                	push   $0x0
  pushl $216
  102c64:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102c69:	e9 d4 01 00 00       	jmp    102e42 <__alltraps>

00102c6e <vector217>:
.globl vector217
vector217:
  pushl $0
  102c6e:	6a 00                	push   $0x0
  pushl $217
  102c70:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102c75:	e9 c8 01 00 00       	jmp    102e42 <__alltraps>

00102c7a <vector218>:
.globl vector218
vector218:
  pushl $0
  102c7a:	6a 00                	push   $0x0
  pushl $218
  102c7c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102c81:	e9 bc 01 00 00       	jmp    102e42 <__alltraps>

00102c86 <vector219>:
.globl vector219
vector219:
  pushl $0
  102c86:	6a 00                	push   $0x0
  pushl $219
  102c88:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102c8d:	e9 b0 01 00 00       	jmp    102e42 <__alltraps>

00102c92 <vector220>:
.globl vector220
vector220:
  pushl $0
  102c92:	6a 00                	push   $0x0
  pushl $220
  102c94:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102c99:	e9 a4 01 00 00       	jmp    102e42 <__alltraps>

00102c9e <vector221>:
.globl vector221
vector221:
  pushl $0
  102c9e:	6a 00                	push   $0x0
  pushl $221
  102ca0:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102ca5:	e9 98 01 00 00       	jmp    102e42 <__alltraps>

00102caa <vector222>:
.globl vector222
vector222:
  pushl $0
  102caa:	6a 00                	push   $0x0
  pushl $222
  102cac:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102cb1:	e9 8c 01 00 00       	jmp    102e42 <__alltraps>

00102cb6 <vector223>:
.globl vector223
vector223:
  pushl $0
  102cb6:	6a 00                	push   $0x0
  pushl $223
  102cb8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102cbd:	e9 80 01 00 00       	jmp    102e42 <__alltraps>

00102cc2 <vector224>:
.globl vector224
vector224:
  pushl $0
  102cc2:	6a 00                	push   $0x0
  pushl $224
  102cc4:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102cc9:	e9 74 01 00 00       	jmp    102e42 <__alltraps>

00102cce <vector225>:
.globl vector225
vector225:
  pushl $0
  102cce:	6a 00                	push   $0x0
  pushl $225
  102cd0:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102cd5:	e9 68 01 00 00       	jmp    102e42 <__alltraps>

00102cda <vector226>:
.globl vector226
vector226:
  pushl $0
  102cda:	6a 00                	push   $0x0
  pushl $226
  102cdc:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102ce1:	e9 5c 01 00 00       	jmp    102e42 <__alltraps>

00102ce6 <vector227>:
.globl vector227
vector227:
  pushl $0
  102ce6:	6a 00                	push   $0x0
  pushl $227
  102ce8:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102ced:	e9 50 01 00 00       	jmp    102e42 <__alltraps>

00102cf2 <vector228>:
.globl vector228
vector228:
  pushl $0
  102cf2:	6a 00                	push   $0x0
  pushl $228
  102cf4:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102cf9:	e9 44 01 00 00       	jmp    102e42 <__alltraps>

00102cfe <vector229>:
.globl vector229
vector229:
  pushl $0
  102cfe:	6a 00                	push   $0x0
  pushl $229
  102d00:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102d05:	e9 38 01 00 00       	jmp    102e42 <__alltraps>

00102d0a <vector230>:
.globl vector230
vector230:
  pushl $0
  102d0a:	6a 00                	push   $0x0
  pushl $230
  102d0c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102d11:	e9 2c 01 00 00       	jmp    102e42 <__alltraps>

00102d16 <vector231>:
.globl vector231
vector231:
  pushl $0
  102d16:	6a 00                	push   $0x0
  pushl $231
  102d18:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102d1d:	e9 20 01 00 00       	jmp    102e42 <__alltraps>

00102d22 <vector232>:
.globl vector232
vector232:
  pushl $0
  102d22:	6a 00                	push   $0x0
  pushl $232
  102d24:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102d29:	e9 14 01 00 00       	jmp    102e42 <__alltraps>

00102d2e <vector233>:
.globl vector233
vector233:
  pushl $0
  102d2e:	6a 00                	push   $0x0
  pushl $233
  102d30:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102d35:	e9 08 01 00 00       	jmp    102e42 <__alltraps>

00102d3a <vector234>:
.globl vector234
vector234:
  pushl $0
  102d3a:	6a 00                	push   $0x0
  pushl $234
  102d3c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102d41:	e9 fc 00 00 00       	jmp    102e42 <__alltraps>

00102d46 <vector235>:
.globl vector235
vector235:
  pushl $0
  102d46:	6a 00                	push   $0x0
  pushl $235
  102d48:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102d4d:	e9 f0 00 00 00       	jmp    102e42 <__alltraps>

00102d52 <vector236>:
.globl vector236
vector236:
  pushl $0
  102d52:	6a 00                	push   $0x0
  pushl $236
  102d54:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102d59:	e9 e4 00 00 00       	jmp    102e42 <__alltraps>

00102d5e <vector237>:
.globl vector237
vector237:
  pushl $0
  102d5e:	6a 00                	push   $0x0
  pushl $237
  102d60:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102d65:	e9 d8 00 00 00       	jmp    102e42 <__alltraps>

00102d6a <vector238>:
.globl vector238
vector238:
  pushl $0
  102d6a:	6a 00                	push   $0x0
  pushl $238
  102d6c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102d71:	e9 cc 00 00 00       	jmp    102e42 <__alltraps>

00102d76 <vector239>:
.globl vector239
vector239:
  pushl $0
  102d76:	6a 00                	push   $0x0
  pushl $239
  102d78:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102d7d:	e9 c0 00 00 00       	jmp    102e42 <__alltraps>

00102d82 <vector240>:
.globl vector240
vector240:
  pushl $0
  102d82:	6a 00                	push   $0x0
  pushl $240
  102d84:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102d89:	e9 b4 00 00 00       	jmp    102e42 <__alltraps>

00102d8e <vector241>:
.globl vector241
vector241:
  pushl $0
  102d8e:	6a 00                	push   $0x0
  pushl $241
  102d90:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102d95:	e9 a8 00 00 00       	jmp    102e42 <__alltraps>

00102d9a <vector242>:
.globl vector242
vector242:
  pushl $0
  102d9a:	6a 00                	push   $0x0
  pushl $242
  102d9c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102da1:	e9 9c 00 00 00       	jmp    102e42 <__alltraps>

00102da6 <vector243>:
.globl vector243
vector243:
  pushl $0
  102da6:	6a 00                	push   $0x0
  pushl $243
  102da8:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102dad:	e9 90 00 00 00       	jmp    102e42 <__alltraps>

00102db2 <vector244>:
.globl vector244
vector244:
  pushl $0
  102db2:	6a 00                	push   $0x0
  pushl $244
  102db4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102db9:	e9 84 00 00 00       	jmp    102e42 <__alltraps>

00102dbe <vector245>:
.globl vector245
vector245:
  pushl $0
  102dbe:	6a 00                	push   $0x0
  pushl $245
  102dc0:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102dc5:	e9 78 00 00 00       	jmp    102e42 <__alltraps>

00102dca <vector246>:
.globl vector246
vector246:
  pushl $0
  102dca:	6a 00                	push   $0x0
  pushl $246
  102dcc:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102dd1:	e9 6c 00 00 00       	jmp    102e42 <__alltraps>

00102dd6 <vector247>:
.globl vector247
vector247:
  pushl $0
  102dd6:	6a 00                	push   $0x0
  pushl $247
  102dd8:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102ddd:	e9 60 00 00 00       	jmp    102e42 <__alltraps>

00102de2 <vector248>:
.globl vector248
vector248:
  pushl $0
  102de2:	6a 00                	push   $0x0
  pushl $248
  102de4:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102de9:	e9 54 00 00 00       	jmp    102e42 <__alltraps>

00102dee <vector249>:
.globl vector249
vector249:
  pushl $0
  102dee:	6a 00                	push   $0x0
  pushl $249
  102df0:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102df5:	e9 48 00 00 00       	jmp    102e42 <__alltraps>

00102dfa <vector250>:
.globl vector250
vector250:
  pushl $0
  102dfa:	6a 00                	push   $0x0
  pushl $250
  102dfc:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102e01:	e9 3c 00 00 00       	jmp    102e42 <__alltraps>

00102e06 <vector251>:
.globl vector251
vector251:
  pushl $0
  102e06:	6a 00                	push   $0x0
  pushl $251
  102e08:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102e0d:	e9 30 00 00 00       	jmp    102e42 <__alltraps>

00102e12 <vector252>:
.globl vector252
vector252:
  pushl $0
  102e12:	6a 00                	push   $0x0
  pushl $252
  102e14:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102e19:	e9 24 00 00 00       	jmp    102e42 <__alltraps>

00102e1e <vector253>:
.globl vector253
vector253:
  pushl $0
  102e1e:	6a 00                	push   $0x0
  pushl $253
  102e20:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102e25:	e9 18 00 00 00       	jmp    102e42 <__alltraps>

00102e2a <vector254>:
.globl vector254
vector254:
  pushl $0
  102e2a:	6a 00                	push   $0x0
  pushl $254
  102e2c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102e31:	e9 0c 00 00 00       	jmp    102e42 <__alltraps>

00102e36 <vector255>:
.globl vector255
vector255:
  pushl $0
  102e36:	6a 00                	push   $0x0
  pushl $255
  102e38:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102e3d:	e9 00 00 00 00       	jmp    102e42 <__alltraps>

00102e42 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102e42:	1e                   	push   %ds
    pushl %es
  102e43:	06                   	push   %es
    pushl %fs
  102e44:	0f a0                	push   %fs
    pushl %gs
  102e46:	0f a8                	push   %gs
    pushal
  102e48:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102e49:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102e4e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102e50:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102e52:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102e53:	e8 57 f5 ff ff       	call   1023af <trap>

    # pop the pushed stack pointer
    popl %esp
  102e58:	5c                   	pop    %esp

00102e59 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102e59:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102e5a:	0f a9                	pop    %gs
    popl %fs
  102e5c:	0f a1                	pop    %fs
    popl %es
  102e5e:	07                   	pop    %es
    popl %ds
  102e5f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102e60:	83 c4 08             	add    $0x8,%esp
    iret
  102e63:	cf                   	iret   

00102e64 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102e64:	55                   	push   %ebp
  102e65:	89 e5                	mov    %esp,%ebp
  102e67:	e8 46 d4 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  102e6c:	05 94 81 01 00       	add    $0x18194,%eax
    return page - pages;
  102e71:	8b 55 08             	mov    0x8(%ebp),%edx
  102e74:	c7 c0 18 c1 11 00    	mov    $0x11c118,%eax
  102e7a:	8b 00                	mov    (%eax),%eax
  102e7c:	29 c2                	sub    %eax,%edx
  102e7e:	89 d0                	mov    %edx,%eax
  102e80:	c1 f8 02             	sar    $0x2,%eax
  102e83:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102e89:	5d                   	pop    %ebp
  102e8a:	c3                   	ret    

00102e8b <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102e8b:	55                   	push   %ebp
  102e8c:	89 e5                	mov    %esp,%ebp
  102e8e:	e8 1f d4 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  102e93:	05 6d 81 01 00       	add    $0x1816d,%eax
    return page2ppn(page) << PGSHIFT;
  102e98:	ff 75 08             	pushl  0x8(%ebp)
  102e9b:	e8 c4 ff ff ff       	call   102e64 <page2ppn>
  102ea0:	83 c4 04             	add    $0x4,%esp
  102ea3:	c1 e0 0c             	shl    $0xc,%eax
}
  102ea6:	c9                   	leave  
  102ea7:	c3                   	ret    

00102ea8 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102ea8:	55                   	push   %ebp
  102ea9:	89 e5                	mov    %esp,%ebp
  102eab:	53                   	push   %ebx
  102eac:	83 ec 04             	sub    $0x4,%esp
  102eaf:	e8 fe d3 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  102eb4:	05 4c 81 01 00       	add    $0x1814c,%eax
    if (PPN(pa) >= npage) {
  102eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  102ebc:	89 d1                	mov    %edx,%ecx
  102ebe:	c1 e9 0c             	shr    $0xc,%ecx
  102ec1:	8b 90 20 10 00 00    	mov    0x1020(%eax),%edx
  102ec7:	39 d1                	cmp    %edx,%ecx
  102ec9:	72 1a                	jb     102ee5 <pa2page+0x3d>
        panic("pa2page called with invalid pa");
  102ecb:	83 ec 04             	sub    $0x4,%esp
  102ece:	8d 90 7c bd fe ff    	lea    -0x14284(%eax),%edx
  102ed4:	52                   	push   %edx
  102ed5:	6a 5a                	push   $0x5a
  102ed7:	8d 90 9b bd fe ff    	lea    -0x14265(%eax),%edx
  102edd:	52                   	push   %edx
  102ede:	89 c3                	mov    %eax,%ebx
  102ee0:	e8 f4 d5 ff ff       	call   1004d9 <__panic>
    }
    return &pages[PPN(pa)];
  102ee5:	c7 c0 18 c1 11 00    	mov    $0x11c118,%eax
  102eeb:	8b 08                	mov    (%eax),%ecx
  102eed:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef0:	c1 e8 0c             	shr    $0xc,%eax
  102ef3:	89 c2                	mov    %eax,%edx
  102ef5:	89 d0                	mov    %edx,%eax
  102ef7:	c1 e0 02             	shl    $0x2,%eax
  102efa:	01 d0                	add    %edx,%eax
  102efc:	c1 e0 02             	shl    $0x2,%eax
  102eff:	01 c8                	add    %ecx,%eax
}
  102f01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102f04:	c9                   	leave  
  102f05:	c3                   	ret    

00102f06 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102f06:	55                   	push   %ebp
  102f07:	89 e5                	mov    %esp,%ebp
  102f09:	53                   	push   %ebx
  102f0a:	83 ec 14             	sub    $0x14,%esp
  102f0d:	e8 a4 d3 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  102f12:	81 c3 ee 80 01 00    	add    $0x180ee,%ebx
    return KADDR(page2pa(page));
  102f18:	ff 75 08             	pushl  0x8(%ebp)
  102f1b:	e8 6b ff ff ff       	call   102e8b <page2pa>
  102f20:	83 c4 04             	add    $0x4,%esp
  102f23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f29:	c1 e8 0c             	shr    $0xc,%eax
  102f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f2f:	8b 83 20 10 00 00    	mov    0x1020(%ebx),%eax
  102f35:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102f38:	72 18                	jb     102f52 <page2kva+0x4c>
  102f3a:	ff 75 f4             	pushl  -0xc(%ebp)
  102f3d:	8d 83 ac bd fe ff    	lea    -0x14254(%ebx),%eax
  102f43:	50                   	push   %eax
  102f44:	6a 61                	push   $0x61
  102f46:	8d 83 9b bd fe ff    	lea    -0x14265(%ebx),%eax
  102f4c:	50                   	push   %eax
  102f4d:	e8 87 d5 ff ff       	call   1004d9 <__panic>
  102f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f55:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102f5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102f5d:	c9                   	leave  
  102f5e:	c3                   	ret    

00102f5f <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102f5f:	55                   	push   %ebp
  102f60:	89 e5                	mov    %esp,%ebp
  102f62:	53                   	push   %ebx
  102f63:	83 ec 04             	sub    $0x4,%esp
  102f66:	e8 47 d3 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  102f6b:	05 95 80 01 00       	add    $0x18095,%eax
    if (!(pte & PTE_P)) {
  102f70:	8b 55 08             	mov    0x8(%ebp),%edx
  102f73:	83 e2 01             	and    $0x1,%edx
  102f76:	85 d2                	test   %edx,%edx
  102f78:	75 1a                	jne    102f94 <pte2page+0x35>
        panic("pte2page called with invalid pte");
  102f7a:	83 ec 04             	sub    $0x4,%esp
  102f7d:	8d 90 d0 bd fe ff    	lea    -0x14230(%eax),%edx
  102f83:	52                   	push   %edx
  102f84:	6a 6c                	push   $0x6c
  102f86:	8d 90 9b bd fe ff    	lea    -0x14265(%eax),%edx
  102f8c:	52                   	push   %edx
  102f8d:	89 c3                	mov    %eax,%ebx
  102f8f:	e8 45 d5 ff ff       	call   1004d9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102f94:	8b 45 08             	mov    0x8(%ebp),%eax
  102f97:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102f9c:	83 ec 0c             	sub    $0xc,%esp
  102f9f:	50                   	push   %eax
  102fa0:	e8 03 ff ff ff       	call   102ea8 <pa2page>
  102fa5:	83 c4 10             	add    $0x10,%esp
}
  102fa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102fab:	c9                   	leave  
  102fac:	c3                   	ret    

00102fad <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102fad:	55                   	push   %ebp
  102fae:	89 e5                	mov    %esp,%ebp
  102fb0:	83 ec 08             	sub    $0x8,%esp
  102fb3:	e8 fa d2 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  102fb8:	05 48 80 01 00       	add    $0x18048,%eax
    return pa2page(PDE_ADDR(pde));
  102fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102fc5:	83 ec 0c             	sub    $0xc,%esp
  102fc8:	50                   	push   %eax
  102fc9:	e8 da fe ff ff       	call   102ea8 <pa2page>
  102fce:	83 c4 10             	add    $0x10,%esp
}
  102fd1:	c9                   	leave  
  102fd2:	c3                   	ret    

00102fd3 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102fd3:	55                   	push   %ebp
  102fd4:	89 e5                	mov    %esp,%ebp
  102fd6:	e8 d7 d2 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  102fdb:	05 25 80 01 00       	add    $0x18025,%eax
    return page->ref;
  102fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe3:	8b 00                	mov    (%eax),%eax
}
  102fe5:	5d                   	pop    %ebp
  102fe6:	c3                   	ret    

00102fe7 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102fe7:	55                   	push   %ebp
  102fe8:	89 e5                	mov    %esp,%ebp
  102fea:	e8 c3 d2 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  102fef:	05 11 80 01 00       	add    $0x18011,%eax
    page->ref = val;
  102ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff7:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ffa:	89 10                	mov    %edx,(%eax)
}
  102ffc:	90                   	nop
  102ffd:	5d                   	pop    %ebp
  102ffe:	c3                   	ret    

00102fff <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102fff:	55                   	push   %ebp
  103000:	89 e5                	mov    %esp,%ebp
  103002:	e8 ab d2 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  103007:	05 f9 7f 01 00       	add    $0x17ff9,%eax
    page->ref += 1;
  10300c:	8b 45 08             	mov    0x8(%ebp),%eax
  10300f:	8b 00                	mov    (%eax),%eax
  103011:	8d 50 01             	lea    0x1(%eax),%edx
  103014:	8b 45 08             	mov    0x8(%ebp),%eax
  103017:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103019:	8b 45 08             	mov    0x8(%ebp),%eax
  10301c:	8b 00                	mov    (%eax),%eax
}
  10301e:	5d                   	pop    %ebp
  10301f:	c3                   	ret    

00103020 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103020:	55                   	push   %ebp
  103021:	89 e5                	mov    %esp,%ebp
  103023:	e8 8a d2 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  103028:	05 d8 7f 01 00       	add    $0x17fd8,%eax
    page->ref -= 1;
  10302d:	8b 45 08             	mov    0x8(%ebp),%eax
  103030:	8b 00                	mov    (%eax),%eax
  103032:	8d 50 ff             	lea    -0x1(%eax),%edx
  103035:	8b 45 08             	mov    0x8(%ebp),%eax
  103038:	89 10                	mov    %edx,(%eax)
    return page->ref;
  10303a:	8b 45 08             	mov    0x8(%ebp),%eax
  10303d:	8b 00                	mov    (%eax),%eax
}
  10303f:	5d                   	pop    %ebp
  103040:	c3                   	ret    

00103041 <__intr_save>:
__intr_save(void) {
  103041:	55                   	push   %ebp
  103042:	89 e5                	mov    %esp,%ebp
  103044:	53                   	push   %ebx
  103045:	83 ec 14             	sub    $0x14,%esp
  103048:	e8 65 d2 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  10304d:	05 b3 7f 01 00       	add    $0x17fb3,%eax
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103052:	9c                   	pushf  
  103053:	5a                   	pop    %edx
  103054:	89 55 f4             	mov    %edx,-0xc(%ebp)
    return eflags;
  103057:	8b 55 f4             	mov    -0xc(%ebp),%edx
    if (read_eflags() & FL_IF) {
  10305a:	81 e2 00 02 00 00    	and    $0x200,%edx
  103060:	85 d2                	test   %edx,%edx
  103062:	74 0e                	je     103072 <__intr_save+0x31>
        intr_disable();
  103064:	89 c3                	mov    %eax,%ebx
  103066:	e8 b5 eb ff ff       	call   101c20 <intr_disable>
        return 1;
  10306b:	b8 01 00 00 00       	mov    $0x1,%eax
  103070:	eb 05                	jmp    103077 <__intr_save+0x36>
    return 0;
  103072:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103077:	83 c4 14             	add    $0x14,%esp
  10307a:	5b                   	pop    %ebx
  10307b:	5d                   	pop    %ebp
  10307c:	c3                   	ret    

0010307d <__intr_restore>:
__intr_restore(bool flag) {
  10307d:	55                   	push   %ebp
  10307e:	89 e5                	mov    %esp,%ebp
  103080:	53                   	push   %ebx
  103081:	83 ec 04             	sub    $0x4,%esp
  103084:	e8 29 d2 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  103089:	05 77 7f 01 00       	add    $0x17f77,%eax
    if (flag) {
  10308e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103092:	74 07                	je     10309b <__intr_restore+0x1e>
        intr_enable();
  103094:	89 c3                	mov    %eax,%ebx
  103096:	e8 74 eb ff ff       	call   101c0f <intr_enable>
}
  10309b:	90                   	nop
  10309c:	83 c4 04             	add    $0x4,%esp
  10309f:	5b                   	pop    %ebx
  1030a0:	5d                   	pop    %ebp
  1030a1:	c3                   	ret    

001030a2 <lgdt>:
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd)
{
  1030a2:	55                   	push   %ebp
  1030a3:	89 e5                	mov    %esp,%ebp
  1030a5:	e8 08 d2 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1030aa:	05 56 7f 01 00       	add    $0x17f56,%eax
    asm volatile("lgdt (%0)" ::"r"(pd));
  1030af:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b2:	0f 01 10             	lgdtl  (%eax)
    asm volatile("movw %%ax, %%gs" ::"a"(USER_DS));
  1030b5:	b8 23 00 00 00       	mov    $0x23,%eax
  1030ba:	8e e8                	mov    %eax,%gs
    asm volatile("movw %%ax, %%fs" ::"a"(USER_DS));
  1030bc:	b8 23 00 00 00       	mov    $0x23,%eax
  1030c1:	8e e0                	mov    %eax,%fs
    asm volatile("movw %%ax, %%es" ::"a"(KERNEL_DS));
  1030c3:	b8 10 00 00 00       	mov    $0x10,%eax
  1030c8:	8e c0                	mov    %eax,%es
    asm volatile("movw %%ax, %%ds" ::"a"(KERNEL_DS));
  1030ca:	b8 10 00 00 00       	mov    $0x10,%eax
  1030cf:	8e d8                	mov    %eax,%ds
    asm volatile("movw %%ax, %%ss" ::"a"(KERNEL_DS));
  1030d1:	b8 10 00 00 00       	mov    $0x10,%eax
  1030d6:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile("ljmp %0, $1f\n 1:\n" ::"i"(KERNEL_CS));
  1030d8:	ea df 30 10 00 08 00 	ljmp   $0x8,$0x1030df
}
  1030df:	90                   	nop
  1030e0:	5d                   	pop    %ebp
  1030e1:	c3                   	ret    

001030e2 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void load_esp0(uintptr_t esp0)
{
  1030e2:	55                   	push   %ebp
  1030e3:	89 e5                	mov    %esp,%ebp
  1030e5:	e8 c8 d1 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1030ea:	05 16 7f 01 00       	add    $0x17f16,%eax
    ts.ts_esp0 = esp0;
  1030ef:	8b 55 08             	mov    0x8(%ebp),%edx
  1030f2:	89 90 44 10 00 00    	mov    %edx,0x1044(%eax)
}
  1030f8:	90                   	nop
  1030f9:	5d                   	pop    %ebp
  1030fa:	c3                   	ret    

001030fb <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void)
{
  1030fb:	55                   	push   %ebp
  1030fc:	89 e5                	mov    %esp,%ebp
  1030fe:	53                   	push   %ebx
  1030ff:	83 ec 10             	sub    $0x10,%esp
  103102:	e8 af d1 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  103107:	81 c3 f9 7e 01 00    	add    $0x17ef9,%ebx
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  10310d:	c7 c0 00 80 11 00    	mov    $0x118000,%eax
  103113:	50                   	push   %eax
  103114:	e8 c9 ff ff ff       	call   1030e2 <load_esp0>
  103119:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
  10311c:	66 c7 83 48 10 00 00 	movw   $0x10,0x1048(%ebx)
  103123:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103125:	66 c7 83 48 d9 ff ff 	movw   $0x68,-0x26b8(%ebx)
  10312c:	68 00 
  10312e:	8d 83 40 10 00 00    	lea    0x1040(%ebx),%eax
  103134:	66 89 83 4a d9 ff ff 	mov    %ax,-0x26b6(%ebx)
  10313b:	8d 83 40 10 00 00    	lea    0x1040(%ebx),%eax
  103141:	c1 e8 10             	shr    $0x10,%eax
  103144:	88 83 4c d9 ff ff    	mov    %al,-0x26b4(%ebx)
  10314a:	0f b6 83 4d d9 ff ff 	movzbl -0x26b3(%ebx),%eax
  103151:	83 e0 f0             	and    $0xfffffff0,%eax
  103154:	83 c8 09             	or     $0x9,%eax
  103157:	88 83 4d d9 ff ff    	mov    %al,-0x26b3(%ebx)
  10315d:	0f b6 83 4d d9 ff ff 	movzbl -0x26b3(%ebx),%eax
  103164:	83 e0 ef             	and    $0xffffffef,%eax
  103167:	88 83 4d d9 ff ff    	mov    %al,-0x26b3(%ebx)
  10316d:	0f b6 83 4d d9 ff ff 	movzbl -0x26b3(%ebx),%eax
  103174:	83 e0 9f             	and    $0xffffff9f,%eax
  103177:	88 83 4d d9 ff ff    	mov    %al,-0x26b3(%ebx)
  10317d:	0f b6 83 4d d9 ff ff 	movzbl -0x26b3(%ebx),%eax
  103184:	83 c8 80             	or     $0xffffff80,%eax
  103187:	88 83 4d d9 ff ff    	mov    %al,-0x26b3(%ebx)
  10318d:	0f b6 83 4e d9 ff ff 	movzbl -0x26b2(%ebx),%eax
  103194:	83 e0 f0             	and    $0xfffffff0,%eax
  103197:	88 83 4e d9 ff ff    	mov    %al,-0x26b2(%ebx)
  10319d:	0f b6 83 4e d9 ff ff 	movzbl -0x26b2(%ebx),%eax
  1031a4:	83 e0 ef             	and    $0xffffffef,%eax
  1031a7:	88 83 4e d9 ff ff    	mov    %al,-0x26b2(%ebx)
  1031ad:	0f b6 83 4e d9 ff ff 	movzbl -0x26b2(%ebx),%eax
  1031b4:	83 e0 df             	and    $0xffffffdf,%eax
  1031b7:	88 83 4e d9 ff ff    	mov    %al,-0x26b2(%ebx)
  1031bd:	0f b6 83 4e d9 ff ff 	movzbl -0x26b2(%ebx),%eax
  1031c4:	83 c8 40             	or     $0x40,%eax
  1031c7:	88 83 4e d9 ff ff    	mov    %al,-0x26b2(%ebx)
  1031cd:	0f b6 83 4e d9 ff ff 	movzbl -0x26b2(%ebx),%eax
  1031d4:	83 e0 7f             	and    $0x7f,%eax
  1031d7:	88 83 4e d9 ff ff    	mov    %al,-0x26b2(%ebx)
  1031dd:	8d 83 40 10 00 00    	lea    0x1040(%ebx),%eax
  1031e3:	c1 e8 18             	shr    $0x18,%eax
  1031e6:	88 83 4f d9 ff ff    	mov    %al,-0x26b1(%ebx)

    // reload all segment registers
    lgdt(&gdt_pd);
  1031ec:	8d 83 e0 00 00 00    	lea    0xe0(%ebx),%eax
  1031f2:	50                   	push   %eax
  1031f3:	e8 aa fe ff ff       	call   1030a2 <lgdt>
  1031f8:	83 c4 04             	add    $0x4,%esp
  1031fb:	66 c7 45 fa 28 00    	movw   $0x28,-0x6(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103201:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  103205:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103208:	90                   	nop
  103209:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10320c:	c9                   	leave  
  10320d:	c3                   	ret    

0010320e <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void)
{
  10320e:	55                   	push   %ebp
  10320f:	89 e5                	mov    %esp,%ebp
  103211:	53                   	push   %ebx
  103212:	83 ec 04             	sub    $0x4,%esp
  103215:	e8 9c d0 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  10321a:	81 c3 e6 7d 01 00    	add    $0x17de6,%ebx
    pmm_manager = &default_pmm_manager;
  103220:	c7 c0 10 c1 11 00    	mov    $0x11c110,%eax
  103226:	c7 c2 50 b1 11 00    	mov    $0x11b150,%edx
  10322c:	89 10                	mov    %edx,(%eax)
    cprintf("memory management: %s\n", pmm_manager->name);
  10322e:	c7 c0 10 c1 11 00    	mov    $0x11c110,%eax
  103234:	8b 00                	mov    (%eax),%eax
  103236:	8b 00                	mov    (%eax),%eax
  103238:	83 ec 08             	sub    $0x8,%esp
  10323b:	50                   	push   %eax
  10323c:	8d 83 fc bd fe ff    	lea    -0x14204(%ebx),%eax
  103242:	50                   	push   %eax
  103243:	e8 e1 d0 ff ff       	call   100329 <cprintf>
  103248:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
  10324b:	c7 c0 10 c1 11 00    	mov    $0x11c110,%eax
  103251:	8b 00                	mov    (%eax),%eax
  103253:	8b 40 04             	mov    0x4(%eax),%eax
  103256:	ff d0                	call   *%eax
}
  103258:	90                   	nop
  103259:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10325c:	c9                   	leave  
  10325d:	c3                   	ret    

0010325e <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory
static void
init_memmap(struct Page *base, size_t n)
{
  10325e:	55                   	push   %ebp
  10325f:	89 e5                	mov    %esp,%ebp
  103261:	83 ec 08             	sub    $0x8,%esp
  103264:	e8 49 d0 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  103269:	05 97 7d 01 00       	add    $0x17d97,%eax
    pmm_manager->init_memmap(base, n);
  10326e:	c7 c0 10 c1 11 00    	mov    $0x11c110,%eax
  103274:	8b 00                	mov    (%eax),%eax
  103276:	8b 40 08             	mov    0x8(%eax),%eax
  103279:	83 ec 08             	sub    $0x8,%esp
  10327c:	ff 75 0c             	pushl  0xc(%ebp)
  10327f:	ff 75 08             	pushl  0x8(%ebp)
  103282:	ff d0                	call   *%eax
  103284:	83 c4 10             	add    $0x10,%esp
}
  103287:	90                   	nop
  103288:	c9                   	leave  
  103289:	c3                   	ret    

0010328a <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory
struct Page *
alloc_pages(size_t n)
{
  10328a:	55                   	push   %ebp
  10328b:	89 e5                	mov    %esp,%ebp
  10328d:	53                   	push   %ebx
  10328e:	83 ec 14             	sub    $0x14,%esp
  103291:	e8 20 d0 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  103296:	81 c3 6a 7d 01 00    	add    $0x17d6a,%ebx
    struct Page *page = NULL;
  10329c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1032a3:	e8 99 fd ff ff       	call   103041 <__intr_save>
  1032a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  1032ab:	c7 c0 10 c1 11 00    	mov    $0x11c110,%eax
  1032b1:	8b 00                	mov    (%eax),%eax
  1032b3:	8b 40 0c             	mov    0xc(%eax),%eax
  1032b6:	83 ec 0c             	sub    $0xc,%esp
  1032b9:	ff 75 08             	pushl  0x8(%ebp)
  1032bc:	ff d0                	call   *%eax
  1032be:	83 c4 10             	add    $0x10,%esp
  1032c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  1032c4:	83 ec 0c             	sub    $0xc,%esp
  1032c7:	ff 75 f0             	pushl  -0x10(%ebp)
  1032ca:	e8 ae fd ff ff       	call   10307d <__intr_restore>
  1032cf:	83 c4 10             	add    $0x10,%esp
    return page;
  1032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1032d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1032d8:	c9                   	leave  
  1032d9:	c3                   	ret    

001032da <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n)
{
  1032da:	55                   	push   %ebp
  1032db:	89 e5                	mov    %esp,%ebp
  1032dd:	53                   	push   %ebx
  1032de:	83 ec 14             	sub    $0x14,%esp
  1032e1:	e8 d0 cf ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  1032e6:	81 c3 1a 7d 01 00    	add    $0x17d1a,%ebx
    bool intr_flag;
    local_intr_save(intr_flag);
  1032ec:	e8 50 fd ff ff       	call   103041 <__intr_save>
  1032f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  1032f4:	c7 c0 10 c1 11 00    	mov    $0x11c110,%eax
  1032fa:	8b 00                	mov    (%eax),%eax
  1032fc:	8b 40 10             	mov    0x10(%eax),%eax
  1032ff:	83 ec 08             	sub    $0x8,%esp
  103302:	ff 75 0c             	pushl  0xc(%ebp)
  103305:	ff 75 08             	pushl  0x8(%ebp)
  103308:	ff d0                	call   *%eax
  10330a:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  10330d:	83 ec 0c             	sub    $0xc,%esp
  103310:	ff 75 f4             	pushl  -0xc(%ebp)
  103313:	e8 65 fd ff ff       	call   10307d <__intr_restore>
  103318:	83 c4 10             	add    $0x10,%esp
}
  10331b:	90                   	nop
  10331c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10331f:	c9                   	leave  
  103320:	c3                   	ret    

00103321 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
//of current free memory
size_t
nr_free_pages(void)
{
  103321:	55                   	push   %ebp
  103322:	89 e5                	mov    %esp,%ebp
  103324:	53                   	push   %ebx
  103325:	83 ec 14             	sub    $0x14,%esp
  103328:	e8 89 cf ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  10332d:	81 c3 d3 7c 01 00    	add    $0x17cd3,%ebx
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103333:	e8 09 fd ff ff       	call   103041 <__intr_save>
  103338:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  10333b:	c7 c0 10 c1 11 00    	mov    $0x11c110,%eax
  103341:	8b 00                	mov    (%eax),%eax
  103343:	8b 40 14             	mov    0x14(%eax),%eax
  103346:	ff d0                	call   *%eax
  103348:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  10334b:	83 ec 0c             	sub    $0xc,%esp
  10334e:	ff 75 f4             	pushl  -0xc(%ebp)
  103351:	e8 27 fd ff ff       	call   10307d <__intr_restore>
  103356:	83 c4 10             	add    $0x10,%esp
    return ret;
  103359:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10335c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10335f:	c9                   	leave  
  103360:	c3                   	ret    

00103361 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void)
{
  103361:	55                   	push   %ebp
  103362:	89 e5                	mov    %esp,%ebp
  103364:	57                   	push   %edi
  103365:	56                   	push   %esi
  103366:	53                   	push   %ebx
  103367:	83 ec 7c             	sub    $0x7c,%esp
  10336a:	e8 cf 15 00 00       	call   10493e <__x86.get_pc_thunk.si>
  10336f:	81 c6 91 7c 01 00    	add    $0x17c91,%esi
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103375:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  10337c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103383:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  10338a:	83 ec 0c             	sub    $0xc,%esp
  10338d:	8d 86 13 be fe ff    	lea    -0x141ed(%esi),%eax
  103393:	50                   	push   %eax
  103394:	89 f3                	mov    %esi,%ebx
  103396:	e8 8e cf ff ff       	call   100329 <cprintf>
  10339b:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i++)
  10339e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1033a5:	e9 02 01 00 00       	jmp    1034ac <page_init+0x14b>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1033aa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1033ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1033b0:	89 d0                	mov    %edx,%eax
  1033b2:	c1 e0 02             	shl    $0x2,%eax
  1033b5:	01 d0                	add    %edx,%eax
  1033b7:	c1 e0 02             	shl    $0x2,%eax
  1033ba:	01 c8                	add    %ecx,%eax
  1033bc:	8b 50 08             	mov    0x8(%eax),%edx
  1033bf:	8b 40 04             	mov    0x4(%eax),%eax
  1033c2:	89 45 a0             	mov    %eax,-0x60(%ebp)
  1033c5:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  1033c8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1033cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1033ce:	89 d0                	mov    %edx,%eax
  1033d0:	c1 e0 02             	shl    $0x2,%eax
  1033d3:	01 d0                	add    %edx,%eax
  1033d5:	c1 e0 02             	shl    $0x2,%eax
  1033d8:	01 c8                	add    %ecx,%eax
  1033da:	8b 48 0c             	mov    0xc(%eax),%ecx
  1033dd:	8b 58 10             	mov    0x10(%eax),%ebx
  1033e0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1033e3:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1033e6:	01 c8                	add    %ecx,%eax
  1033e8:	11 da                	adc    %ebx,%edx
  1033ea:	89 45 98             	mov    %eax,-0x68(%ebp)
  1033ed:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  1033f0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1033f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1033f6:	89 d0                	mov    %edx,%eax
  1033f8:	c1 e0 02             	shl    $0x2,%eax
  1033fb:	01 d0                	add    %edx,%eax
  1033fd:	c1 e0 02             	shl    $0x2,%eax
  103400:	01 c8                	add    %ecx,%eax
  103402:	83 c0 14             	add    $0x14,%eax
  103405:	8b 00                	mov    (%eax),%eax
  103407:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  10340d:	8b 45 98             	mov    -0x68(%ebp),%eax
  103410:	8b 55 9c             	mov    -0x64(%ebp),%edx
  103413:	83 c0 ff             	add    $0xffffffff,%eax
  103416:	83 d2 ff             	adc    $0xffffffff,%edx
  103419:	89 c1                	mov    %eax,%ecx
  10341b:	89 d3                	mov    %edx,%ebx
  10341d:	8b 7d c4             	mov    -0x3c(%ebp),%edi
  103420:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103423:	89 d0                	mov    %edx,%eax
  103425:	c1 e0 02             	shl    $0x2,%eax
  103428:	01 d0                	add    %edx,%eax
  10342a:	c1 e0 02             	shl    $0x2,%eax
  10342d:	01 f8                	add    %edi,%eax
  10342f:	8b 50 10             	mov    0x10(%eax),%edx
  103432:	8b 40 0c             	mov    0xc(%eax),%eax
  103435:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  10343b:	53                   	push   %ebx
  10343c:	51                   	push   %ecx
  10343d:	ff 75 a4             	pushl  -0x5c(%ebp)
  103440:	ff 75 a0             	pushl  -0x60(%ebp)
  103443:	52                   	push   %edx
  103444:	50                   	push   %eax
  103445:	8d 86 20 be fe ff    	lea    -0x141e0(%esi),%eax
  10344b:	50                   	push   %eax
  10344c:	89 f3                	mov    %esi,%ebx
  10344e:	e8 d6 ce ff ff       	call   100329 <cprintf>
  103453:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM)
  103456:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103459:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10345c:	89 d0                	mov    %edx,%eax
  10345e:	c1 e0 02             	shl    $0x2,%eax
  103461:	01 d0                	add    %edx,%eax
  103463:	c1 e0 02             	shl    $0x2,%eax
  103466:	01 c8                	add    %ecx,%eax
  103468:	83 c0 14             	add    $0x14,%eax
  10346b:	8b 00                	mov    (%eax),%eax
  10346d:	83 f8 01             	cmp    $0x1,%eax
  103470:	75 36                	jne    1034a8 <page_init+0x147>
        {
            if (maxpa < end && begin < KMEMSIZE)
  103472:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103475:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103478:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  10347b:	77 2b                	ja     1034a8 <page_init+0x147>
  10347d:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  103480:	72 05                	jb     103487 <page_init+0x126>
  103482:	3b 45 98             	cmp    -0x68(%ebp),%eax
  103485:	73 21                	jae    1034a8 <page_init+0x147>
  103487:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10348b:	77 1b                	ja     1034a8 <page_init+0x147>
  10348d:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103491:	72 09                	jb     10349c <page_init+0x13b>
  103493:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
  10349a:	77 0c                	ja     1034a8 <page_init+0x147>
            {
                maxpa = end;
  10349c:	8b 45 98             	mov    -0x68(%ebp),%eax
  10349f:	8b 55 9c             	mov    -0x64(%ebp),%edx
  1034a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1034a5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i++)
  1034a8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1034ac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1034af:	8b 00                	mov    (%eax),%eax
  1034b1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1034b4:	0f 8c f0 fe ff ff    	jl     1033aa <page_init+0x49>
            }
        }
    }
    if (maxpa > KMEMSIZE)
  1034ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034be:	72 1d                	jb     1034dd <page_init+0x17c>
  1034c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034c4:	77 09                	ja     1034cf <page_init+0x16e>
  1034c6:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  1034cd:	76 0e                	jbe    1034dd <page_init+0x17c>
    {
        maxpa = KMEMSIZE;
  1034cf:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  1034d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  1034dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1034e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1034e3:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1034e7:	c1 ea 0c             	shr    $0xc,%edx
  1034ea:	89 c1                	mov    %eax,%ecx
  1034ec:	89 d3                	mov    %edx,%ebx
  1034ee:	89 c8                	mov    %ecx,%eax
  1034f0:	89 86 20 10 00 00    	mov    %eax,0x1020(%esi)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  1034f6:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  1034fd:	c7 c0 28 c1 11 00    	mov    $0x11c128,%eax
  103503:	8d 50 ff             	lea    -0x1(%eax),%edx
  103506:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103509:	01 d0                	add    %edx,%eax
  10350b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  10350e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103511:	ba 00 00 00 00       	mov    $0x0,%edx
  103516:	f7 75 c0             	divl   -0x40(%ebp)
  103519:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10351c:	29 d0                	sub    %edx,%eax
  10351e:	89 c2                	mov    %eax,%edx
  103520:	c7 c0 18 c1 11 00    	mov    $0x11c118,%eax
  103526:	89 10                	mov    %edx,(%eax)

    for (i = 0; i < npage; i++)
  103528:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10352f:	eb 31                	jmp    103562 <page_init+0x201>
    {
        SetPageReserved(pages + i);
  103531:	c7 c0 18 c1 11 00    	mov    $0x11c118,%eax
  103537:	8b 08                	mov    (%eax),%ecx
  103539:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10353c:	89 d0                	mov    %edx,%eax
  10353e:	c1 e0 02             	shl    $0x2,%eax
  103541:	01 d0                	add    %edx,%eax
  103543:	c1 e0 02             	shl    $0x2,%eax
  103546:	01 c8                	add    %ecx,%eax
  103548:	83 c0 04             	add    $0x4,%eax
  10354b:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  103552:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103555:	8b 45 90             	mov    -0x70(%ebp),%eax
  103558:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10355b:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i++)
  10355e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103562:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103565:	8b 86 20 10 00 00    	mov    0x1020(%esi),%eax
  10356b:	39 c2                	cmp    %eax,%edx
  10356d:	72 c2                	jb     103531 <page_init+0x1d0>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  10356f:	8b 96 20 10 00 00    	mov    0x1020(%esi),%edx
  103575:	89 d0                	mov    %edx,%eax
  103577:	c1 e0 02             	shl    $0x2,%eax
  10357a:	01 d0                	add    %edx,%eax
  10357c:	c1 e0 02             	shl    $0x2,%eax
  10357f:	89 c2                	mov    %eax,%edx
  103581:	c7 c0 18 c1 11 00    	mov    $0x11c118,%eax
  103587:	8b 00                	mov    (%eax),%eax
  103589:	01 d0                	add    %edx,%eax
  10358b:	89 45 b8             	mov    %eax,-0x48(%ebp)
  10358e:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  103595:	77 1d                	ja     1035b4 <page_init+0x253>
  103597:	ff 75 b8             	pushl  -0x48(%ebp)
  10359a:	8d 86 50 be fe ff    	lea    -0x141b0(%esi),%eax
  1035a0:	50                   	push   %eax
  1035a1:	68 e7 00 00 00       	push   $0xe7
  1035a6:	8d 86 74 be fe ff    	lea    -0x1418c(%esi),%eax
  1035ac:	50                   	push   %eax
  1035ad:	89 f3                	mov    %esi,%ebx
  1035af:	e8 25 cf ff ff       	call   1004d9 <__panic>
  1035b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1035b7:	05 00 00 00 40       	add    $0x40000000,%eax
  1035bc:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i++)
  1035bf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1035c6:	e9 79 01 00 00       	jmp    103744 <page_init+0x3e3>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1035cb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1035ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1035d1:	89 d0                	mov    %edx,%eax
  1035d3:	c1 e0 02             	shl    $0x2,%eax
  1035d6:	01 d0                	add    %edx,%eax
  1035d8:	c1 e0 02             	shl    $0x2,%eax
  1035db:	01 c8                	add    %ecx,%eax
  1035dd:	8b 50 08             	mov    0x8(%eax),%edx
  1035e0:	8b 40 04             	mov    0x4(%eax),%eax
  1035e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1035e6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1035e9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1035ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1035ef:	89 d0                	mov    %edx,%eax
  1035f1:	c1 e0 02             	shl    $0x2,%eax
  1035f4:	01 d0                	add    %edx,%eax
  1035f6:	c1 e0 02             	shl    $0x2,%eax
  1035f9:	01 c8                	add    %ecx,%eax
  1035fb:	8b 48 0c             	mov    0xc(%eax),%ecx
  1035fe:	8b 58 10             	mov    0x10(%eax),%ebx
  103601:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103604:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103607:	01 c8                	add    %ecx,%eax
  103609:	11 da                	adc    %ebx,%edx
  10360b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10360e:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM)
  103611:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103614:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103617:	89 d0                	mov    %edx,%eax
  103619:	c1 e0 02             	shl    $0x2,%eax
  10361c:	01 d0                	add    %edx,%eax
  10361e:	c1 e0 02             	shl    $0x2,%eax
  103621:	01 c8                	add    %ecx,%eax
  103623:	83 c0 14             	add    $0x14,%eax
  103626:	8b 00                	mov    (%eax),%eax
  103628:	83 f8 01             	cmp    $0x1,%eax
  10362b:	0f 85 0f 01 00 00    	jne    103740 <page_init+0x3df>
        {
            if (begin < freemem)
  103631:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103634:	ba 00 00 00 00       	mov    $0x0,%edx
  103639:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  10363c:	77 17                	ja     103655 <page_init+0x2f4>
  10363e:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  103641:	72 05                	jb     103648 <page_init+0x2e7>
  103643:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103646:	73 0d                	jae    103655 <page_init+0x2f4>
            {
                begin = freemem;
  103648:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10364b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10364e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE)
  103655:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103659:	72 1d                	jb     103678 <page_init+0x317>
  10365b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10365f:	77 09                	ja     10366a <page_init+0x309>
  103661:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  103668:	76 0e                	jbe    103678 <page_init+0x317>
            {
                end = KMEMSIZE;
  10366a:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103671:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end)
  103678:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10367b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10367e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103681:	0f 87 b9 00 00 00    	ja     103740 <page_init+0x3df>
  103687:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10368a:	72 09                	jb     103695 <page_init+0x334>
  10368c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10368f:	0f 83 ab 00 00 00    	jae    103740 <page_init+0x3df>
            {
                begin = ROUNDUP(begin, PGSIZE);
  103695:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  10369c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10369f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1036a2:	01 d0                	add    %edx,%eax
  1036a4:	83 e8 01             	sub    $0x1,%eax
  1036a7:	89 45 ac             	mov    %eax,-0x54(%ebp)
  1036aa:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1036ad:	ba 00 00 00 00       	mov    $0x0,%edx
  1036b2:	f7 75 b0             	divl   -0x50(%ebp)
  1036b5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1036b8:	29 d0                	sub    %edx,%eax
  1036ba:	ba 00 00 00 00       	mov    $0x0,%edx
  1036bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1036c2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1036c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1036c8:	89 45 a8             	mov    %eax,-0x58(%ebp)
  1036cb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1036ce:	ba 00 00 00 00       	mov    $0x0,%edx
  1036d3:	89 c7                	mov    %eax,%edi
  1036d5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1036db:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1036de:	89 d0                	mov    %edx,%eax
  1036e0:	83 e0 00             	and    $0x0,%eax
  1036e3:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1036e6:	8b 45 80             	mov    -0x80(%ebp),%eax
  1036e9:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1036ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1036ef:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end)
  1036f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1036f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1036f8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1036fb:	77 43                	ja     103740 <page_init+0x3df>
  1036fd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103700:	72 05                	jb     103707 <page_init+0x3a6>
  103702:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103705:	73 39                	jae    103740 <page_init+0x3df>
                {
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  103707:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10370a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10370d:	2b 45 d0             	sub    -0x30(%ebp),%eax
  103710:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  103713:	89 c3                	mov    %eax,%ebx
  103715:	89 d6                	mov    %edx,%esi
  103717:	89 d8                	mov    %ebx,%eax
  103719:	89 f2                	mov    %esi,%edx
  10371b:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10371f:	c1 ea 0c             	shr    $0xc,%edx
  103722:	89 c3                	mov    %eax,%ebx
  103724:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103727:	83 ec 0c             	sub    $0xc,%esp
  10372a:	50                   	push   %eax
  10372b:	e8 78 f7 ff ff       	call   102ea8 <pa2page>
  103730:	83 c4 10             	add    $0x10,%esp
  103733:	83 ec 08             	sub    $0x8,%esp
  103736:	53                   	push   %ebx
  103737:	50                   	push   %eax
  103738:	e8 21 fb ff ff       	call   10325e <init_memmap>
  10373d:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i++)
  103740:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103744:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103747:	8b 00                	mov    (%eax),%eax
  103749:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10374c:	0f 8c 79 fe ff ff    	jl     1035cb <page_init+0x26a>
                }
            }
        }
    }
}
  103752:	90                   	nop
  103753:	8d 65 f4             	lea    -0xc(%ebp),%esp
  103756:	5b                   	pop    %ebx
  103757:	5e                   	pop    %esi
  103758:	5f                   	pop    %edi
  103759:	5d                   	pop    %ebp
  10375a:	c3                   	ret    

0010375b <boot_map_segment>:
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm)
{
  10375b:	55                   	push   %ebp
  10375c:	89 e5                	mov    %esp,%ebp
  10375e:	53                   	push   %ebx
  10375f:	83 ec 24             	sub    $0x24,%esp
  103762:	e8 4f cb ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  103767:	81 c3 99 78 01 00    	add    $0x17899,%ebx
    assert(PGOFF(la) == PGOFF(pa));
  10376d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103770:	33 45 14             	xor    0x14(%ebp),%eax
  103773:	25 ff 0f 00 00       	and    $0xfff,%eax
  103778:	85 c0                	test   %eax,%eax
  10377a:	74 1f                	je     10379b <boot_map_segment+0x40>
  10377c:	8d 83 82 be fe ff    	lea    -0x1417e(%ebx),%eax
  103782:	50                   	push   %eax
  103783:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  103789:	50                   	push   %eax
  10378a:	68 0c 01 00 00       	push   $0x10c
  10378f:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103795:	50                   	push   %eax
  103796:	e8 3e cd ff ff       	call   1004d9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10379b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1037a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037a5:	25 ff 0f 00 00       	and    $0xfff,%eax
  1037aa:	89 c2                	mov    %eax,%edx
  1037ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1037af:	01 c2                	add    %eax,%edx
  1037b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037b4:	01 d0                	add    %edx,%eax
  1037b6:	83 e8 01             	sub    $0x1,%eax
  1037b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1037bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037bf:	ba 00 00 00 00       	mov    $0x0,%edx
  1037c4:	f7 75 f0             	divl   -0x10(%ebp)
  1037c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037ca:	29 d0                	sub    %edx,%eax
  1037cc:	c1 e8 0c             	shr    $0xc,%eax
  1037cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1037d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1037d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1037e0:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1037e3:	8b 45 14             	mov    0x14(%ebp),%eax
  1037e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1037f1:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
  1037f4:	eb 5d                	jmp    103853 <boot_map_segment+0xf8>
    {
        pte_t *ptep = get_pte(pgdir, la, 1);
  1037f6:	83 ec 04             	sub    $0x4,%esp
  1037f9:	6a 01                	push   $0x1
  1037fb:	ff 75 0c             	pushl  0xc(%ebp)
  1037fe:	ff 75 08             	pushl  0x8(%ebp)
  103801:	e8 8e 01 00 00       	call   103994 <get_pte>
  103806:	83 c4 10             	add    $0x10,%esp
  103809:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10380c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103810:	75 1f                	jne    103831 <boot_map_segment+0xd6>
  103812:	8d 83 ae be fe ff    	lea    -0x14152(%ebx),%eax
  103818:	50                   	push   %eax
  103819:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  10381f:	50                   	push   %eax
  103820:	68 13 01 00 00       	push   $0x113
  103825:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  10382b:	50                   	push   %eax
  10382c:	e8 a8 cc ff ff       	call   1004d9 <__panic>
        *ptep = pa | PTE_P | perm;
  103831:	8b 45 14             	mov    0x14(%ebp),%eax
  103834:	0b 45 18             	or     0x18(%ebp),%eax
  103837:	83 c8 01             	or     $0x1,%eax
  10383a:	89 c2                	mov    %eax,%edx
  10383c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10383f:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
  103841:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103845:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10384c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103853:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103857:	75 9d                	jne    1037f6 <boot_map_segment+0x9b>
    }
}
  103859:	90                   	nop
  10385a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10385d:	c9                   	leave  
  10385e:	c3                   	ret    

0010385f <boot_alloc_page>:
//boot_alloc_page - allocate one page using pmm->alloc_pages(1)
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void)
{
  10385f:	55                   	push   %ebp
  103860:	89 e5                	mov    %esp,%ebp
  103862:	53                   	push   %ebx
  103863:	83 ec 14             	sub    $0x14,%esp
  103866:	e8 4b ca ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  10386b:	81 c3 95 77 01 00    	add    $0x17795,%ebx
    struct Page *p = alloc_page();
  103871:	83 ec 0c             	sub    $0xc,%esp
  103874:	6a 01                	push   $0x1
  103876:	e8 0f fa ff ff       	call   10328a <alloc_pages>
  10387b:	83 c4 10             	add    $0x10,%esp
  10387e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL)
  103881:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103885:	75 1b                	jne    1038a2 <boot_alloc_page+0x43>
    {
        panic("boot_alloc_page failed.\n");
  103887:	83 ec 04             	sub    $0x4,%esp
  10388a:	8d 83 bb be fe ff    	lea    -0x14145(%ebx),%eax
  103890:	50                   	push   %eax
  103891:	68 21 01 00 00       	push   $0x121
  103896:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  10389c:	50                   	push   %eax
  10389d:	e8 37 cc ff ff       	call   1004d9 <__panic>
    }
    return page2kva(p);
  1038a2:	83 ec 0c             	sub    $0xc,%esp
  1038a5:	ff 75 f4             	pushl  -0xc(%ebp)
  1038a8:	e8 59 f6 ff ff       	call   102f06 <page2kva>
  1038ad:	83 c4 10             	add    $0x10,%esp
}
  1038b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1038b3:	c9                   	leave  
  1038b4:	c3                   	ret    

001038b5 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void pmm_init(void)
{
  1038b5:	55                   	push   %ebp
  1038b6:	89 e5                	mov    %esp,%ebp
  1038b8:	53                   	push   %ebx
  1038b9:	83 ec 14             	sub    $0x14,%esp
  1038bc:	e8 f5 c9 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  1038c1:	81 c3 3f 77 01 00    	add    $0x1773f,%ebx
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1038c7:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  1038cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1038d0:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1038d7:	77 1b                	ja     1038f4 <pmm_init+0x3f>
  1038d9:	ff 75 f4             	pushl  -0xc(%ebp)
  1038dc:	8d 83 50 be fe ff    	lea    -0x141b0(%ebx),%eax
  1038e2:	50                   	push   %eax
  1038e3:	68 2b 01 00 00       	push   $0x12b
  1038e8:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  1038ee:	50                   	push   %eax
  1038ef:	e8 e5 cb ff ff       	call   1004d9 <__panic>
  1038f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038f7:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  1038fd:	c7 c0 14 c1 11 00    	mov    $0x11c114,%eax
  103903:	89 10                	mov    %edx,(%eax)
    //We need to alloc/free the physical memory (granularity is 4KB or other size).
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory.
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103905:	e8 04 f9 ff ff       	call   10320e <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10390a:	e8 52 fa ff ff       	call   103361 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10390f:	e8 ef 03 00 00       	call   103d03 <check_alloc_page>

    check_pgdir();
  103914:	e8 21 04 00 00       	call   103d3a <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103919:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  10391f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103922:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103929:	77 1b                	ja     103946 <pmm_init+0x91>
  10392b:	ff 75 f0             	pushl  -0x10(%ebp)
  10392e:	8d 83 50 be fe ff    	lea    -0x141b0(%ebx),%eax
  103934:	50                   	push   %eax
  103935:	68 41 01 00 00       	push   $0x141
  10393a:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103940:	50                   	push   %eax
  103941:	e8 93 cb ff ff       	call   1004d9 <__panic>
  103946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103949:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  10394f:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  103955:	05 ac 0f 00 00       	add    $0xfac,%eax
  10395a:	83 ca 03             	or     $0x3,%edx
  10395d:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10395f:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  103965:	83 ec 0c             	sub    $0xc,%esp
  103968:	6a 02                	push   $0x2
  10396a:	6a 00                	push   $0x0
  10396c:	68 00 00 00 38       	push   $0x38000000
  103971:	68 00 00 00 c0       	push   $0xc0000000
  103976:	50                   	push   %eax
  103977:	e8 df fd ff ff       	call   10375b <boot_map_segment>
  10397c:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10397f:	e8 77 f7 ff ff       	call   1030fb <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  103984:	e8 d5 09 00 00       	call   10435e <check_boot_pgdir>

    print_pgdir();
  103989:	e8 43 0e 00 00       	call   1047d1 <print_pgdir>
}
  10398e:	90                   	nop
  10398f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  103992:	c9                   	leave  
  103993:	c3                   	ret    

00103994 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
  103994:	55                   	push   %ebp
  103995:	89 e5                	mov    %esp,%ebp
  103997:	53                   	push   %ebx
  103998:	83 ec 24             	sub    $0x24,%esp
  10399b:	e8 16 c9 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  1039a0:	81 c3 60 76 01 00    	add    $0x17660,%ebx
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
*/
    pde_t *pdep = &pgdir[PDX(la)];
  1039a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1039a9:	c1 e8 16             	shr    $0x16,%eax
  1039ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1039b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1039b6:	01 d0                	add    %edx,%eax
  1039b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //获取页表的地址不成功
    if (!(*pdep & PTE_P))
  1039bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039be:	8b 00                	mov    (%eax),%eax
  1039c0:	83 e0 01             	and    $0x1,%eax
  1039c3:	85 c0                	test   %eax,%eax
  1039c5:	0f 85 a4 00 00 00    	jne    103a6f <get_pte+0xdb>
    {
        struct Page *page;
        //申请一页
        if (!create || (page = alloc_page()) == NULL)
  1039cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1039cf:	74 16                	je     1039e7 <get_pte+0x53>
  1039d1:	83 ec 0c             	sub    $0xc,%esp
  1039d4:	6a 01                	push   $0x1
  1039d6:	e8 af f8 ff ff       	call   10328a <alloc_pages>
  1039db:	83 c4 10             	add    $0x10,%esp
  1039de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039e5:	75 0a                	jne    1039f1 <get_pte+0x5d>
        {
            return NULL;
  1039e7:	b8 00 00 00 00       	mov    $0x0,%eax
  1039ec:	e9 d4 00 00 00       	jmp    103ac5 <get_pte+0x131>
        }
        set_page_ref(page, 1);        //引用加1
  1039f1:	83 ec 08             	sub    $0x8,%esp
  1039f4:	6a 01                	push   $0x1
  1039f6:	ff 75 f0             	pushl  -0x10(%ebp)
  1039f9:	e8 e9 f5 ff ff       	call   102fe7 <set_page_ref>
  1039fe:	83 c4 10             	add    $0x10,%esp
        uintptr_t pa = page2pa(page); //获取地址
  103a01:	83 ec 0c             	sub    $0xc,%esp
  103a04:	ff 75 f0             	pushl  -0x10(%ebp)
  103a07:	e8 7f f4 ff ff       	call   102e8b <page2pa>
  103a0c:	83 c4 10             	add    $0x10,%esp
  103a0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
  103a12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a15:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a1b:	c1 e8 0c             	shr    $0xc,%eax
  103a1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103a21:	8b 83 20 10 00 00    	mov    0x1020(%ebx),%eax
  103a27:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103a2a:	72 1b                	jb     103a47 <get_pte+0xb3>
  103a2c:	ff 75 e8             	pushl  -0x18(%ebp)
  103a2f:	8d 83 ac bd fe ff    	lea    -0x14254(%ebx),%eax
  103a35:	50                   	push   %eax
  103a36:	68 8d 01 00 00       	push   $0x18d
  103a3b:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103a41:	50                   	push   %eax
  103a42:	e8 92 ca ff ff       	call   1004d9 <__panic>
  103a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a4a:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103a4f:	83 ec 04             	sub    $0x4,%esp
  103a52:	68 00 10 00 00       	push   $0x1000
  103a57:	6a 00                	push   $0x0
  103a59:	50                   	push   %eax
  103a5a:	e8 55 24 00 00       	call   105eb4 <memset>
  103a5f:	83 c4 10             	add    $0x10,%esp
        *pdep = pa | PTE_U | PTE_W | PTE_P; //设置权限
  103a62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a65:	83 c8 07             	or     $0x7,%eax
  103a68:	89 c2                	mov    %eax,%edx
  103a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a6d:	89 10                	mov    %edx,(%eax)
    }
    //返回页表的地址
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  103a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a72:	8b 00                	mov    (%eax),%eax
  103a74:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103a79:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103a7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103a7f:	c1 e8 0c             	shr    $0xc,%eax
  103a82:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103a85:	8b 83 20 10 00 00    	mov    0x1020(%ebx),%eax
  103a8b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103a8e:	72 1b                	jb     103aab <get_pte+0x117>
  103a90:	ff 75 e0             	pushl  -0x20(%ebp)
  103a93:	8d 83 ac bd fe ff    	lea    -0x14254(%ebx),%eax
  103a99:	50                   	push   %eax
  103a9a:	68 91 01 00 00       	push   $0x191
  103a9f:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103aa5:	50                   	push   %eax
  103aa6:	e8 2e ca ff ff       	call   1004d9 <__panic>
  103aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103aae:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103ab3:	89 c2                	mov    %eax,%edx
  103ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  103ab8:	c1 e8 0c             	shr    $0xc,%eax
  103abb:	25 ff 03 00 00       	and    $0x3ff,%eax
  103ac0:	c1 e0 02             	shl    $0x2,%eax
  103ac3:	01 d0                	add    %edx,%eax
}
  103ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  103ac8:	c9                   	leave  
  103ac9:	c3                   	ret    

00103aca <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
  103aca:	55                   	push   %ebp
  103acb:	89 e5                	mov    %esp,%ebp
  103acd:	83 ec 18             	sub    $0x18,%esp
  103ad0:	e8 dd c7 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  103ad5:	05 2b 75 01 00       	add    $0x1752b,%eax
    pte_t *ptep = get_pte(pgdir, la, 0);
  103ada:	83 ec 04             	sub    $0x4,%esp
  103add:	6a 00                	push   $0x0
  103adf:	ff 75 0c             	pushl  0xc(%ebp)
  103ae2:	ff 75 08             	pushl  0x8(%ebp)
  103ae5:	e8 aa fe ff ff       	call   103994 <get_pte>
  103aea:	83 c4 10             	add    $0x10,%esp
  103aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL)
  103af0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103af4:	74 08                	je     103afe <get_page+0x34>
    {
        *ptep_store = ptep;
  103af6:	8b 45 10             	mov    0x10(%ebp),%eax
  103af9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103afc:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P)
  103afe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103b02:	74 1f                	je     103b23 <get_page+0x59>
  103b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b07:	8b 00                	mov    (%eax),%eax
  103b09:	83 e0 01             	and    $0x1,%eax
  103b0c:	85 c0                	test   %eax,%eax
  103b0e:	74 13                	je     103b23 <get_page+0x59>
    {
        return pte2page(*ptep);
  103b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b13:	8b 00                	mov    (%eax),%eax
  103b15:	83 ec 0c             	sub    $0xc,%esp
  103b18:	50                   	push   %eax
  103b19:	e8 41 f4 ff ff       	call   102f5f <pte2page>
  103b1e:	83 c4 10             	add    $0x10,%esp
  103b21:	eb 05                	jmp    103b28 <get_page+0x5e>
    }
    return NULL;
  103b23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b28:	c9                   	leave  
  103b29:	c3                   	ret    

00103b2a <page_remove_pte>:
//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep)
{
  103b2a:	55                   	push   %ebp
  103b2b:	89 e5                	mov    %esp,%ebp
  103b2d:	83 ec 18             	sub    $0x18,%esp
  103b30:	e8 7d c7 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  103b35:	05 cb 74 01 00       	add    $0x174cb,%eax
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
*/
    if (*ptep & PTE_P)
  103b3a:	8b 45 10             	mov    0x10(%ebp),%eax
  103b3d:	8b 00                	mov    (%eax),%eax
  103b3f:	83 e0 01             	and    $0x1,%eax
  103b42:	85 c0                	test   %eax,%eax
  103b44:	74 50                	je     103b96 <page_remove_pte+0x6c>
    {
        struct Page *page = pte2page(*ptep);
  103b46:	8b 45 10             	mov    0x10(%ebp),%eax
  103b49:	8b 00                	mov    (%eax),%eax
  103b4b:	83 ec 0c             	sub    $0xc,%esp
  103b4e:	50                   	push   %eax
  103b4f:	e8 0b f4 ff ff       	call   102f5f <pte2page>
  103b54:	83 c4 10             	add    $0x10,%esp
  103b57:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0)
  103b5a:	83 ec 0c             	sub    $0xc,%esp
  103b5d:	ff 75 f4             	pushl  -0xc(%ebp)
  103b60:	e8 bb f4 ff ff       	call   103020 <page_ref_dec>
  103b65:	83 c4 10             	add    $0x10,%esp
  103b68:	85 c0                	test   %eax,%eax
  103b6a:	75 10                	jne    103b7c <page_remove_pte+0x52>
        {
            free_page(page); //仅引用1次则释放
  103b6c:	83 ec 08             	sub    $0x8,%esp
  103b6f:	6a 01                	push   $0x1
  103b71:	ff 75 f4             	pushl  -0xc(%ebp)
  103b74:	e8 61 f7 ff ff       	call   1032da <free_pages>
  103b79:	83 c4 10             	add    $0x10,%esp
        }
        *ptep = 0;
  103b7c:	8b 45 10             	mov    0x10(%ebp),%eax
  103b7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la); //引用多次则释放pte
  103b85:	83 ec 08             	sub    $0x8,%esp
  103b88:	ff 75 0c             	pushl  0xc(%ebp)
  103b8b:	ff 75 08             	pushl  0x8(%ebp)
  103b8e:	e8 0c 01 00 00       	call   103c9f <tlb_invalidate>
  103b93:	83 c4 10             	add    $0x10,%esp
    }
}
  103b96:	90                   	nop
  103b97:	c9                   	leave  
  103b98:	c3                   	ret    

00103b99 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
  103b99:	55                   	push   %ebp
  103b9a:	89 e5                	mov    %esp,%ebp
  103b9c:	83 ec 18             	sub    $0x18,%esp
  103b9f:	e8 0e c7 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  103ba4:	05 5c 74 01 00       	add    $0x1745c,%eax
    pte_t *ptep = get_pte(pgdir, la, 0);
  103ba9:	83 ec 04             	sub    $0x4,%esp
  103bac:	6a 00                	push   $0x0
  103bae:	ff 75 0c             	pushl  0xc(%ebp)
  103bb1:	ff 75 08             	pushl  0x8(%ebp)
  103bb4:	e8 db fd ff ff       	call   103994 <get_pte>
  103bb9:	83 c4 10             	add    $0x10,%esp
  103bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL)
  103bbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103bc3:	74 14                	je     103bd9 <page_remove+0x40>
    {
        page_remove_pte(pgdir, la, ptep);
  103bc5:	83 ec 04             	sub    $0x4,%esp
  103bc8:	ff 75 f4             	pushl  -0xc(%ebp)
  103bcb:	ff 75 0c             	pushl  0xc(%ebp)
  103bce:	ff 75 08             	pushl  0x8(%ebp)
  103bd1:	e8 54 ff ff ff       	call   103b2a <page_remove_pte>
  103bd6:	83 c4 10             	add    $0x10,%esp
    }
}
  103bd9:	90                   	nop
  103bda:	c9                   	leave  
  103bdb:	c3                   	ret    

00103bdc <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm)
{
  103bdc:	55                   	push   %ebp
  103bdd:	89 e5                	mov    %esp,%ebp
  103bdf:	83 ec 18             	sub    $0x18,%esp
  103be2:	e8 cb c6 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  103be7:	05 19 74 01 00       	add    $0x17419,%eax
    pte_t *ptep = get_pte(pgdir, la, 1);
  103bec:	83 ec 04             	sub    $0x4,%esp
  103bef:	6a 01                	push   $0x1
  103bf1:	ff 75 10             	pushl  0x10(%ebp)
  103bf4:	ff 75 08             	pushl  0x8(%ebp)
  103bf7:	e8 98 fd ff ff       	call   103994 <get_pte>
  103bfc:	83 c4 10             	add    $0x10,%esp
  103bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL)
  103c02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103c06:	75 0a                	jne    103c12 <page_insert+0x36>
    {
        return -E_NO_MEM;
  103c08:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  103c0d:	e9 8b 00 00 00       	jmp    103c9d <page_insert+0xc1>
    }
    page_ref_inc(page);
  103c12:	83 ec 0c             	sub    $0xc,%esp
  103c15:	ff 75 0c             	pushl  0xc(%ebp)
  103c18:	e8 e2 f3 ff ff       	call   102fff <page_ref_inc>
  103c1d:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P)
  103c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c23:	8b 00                	mov    (%eax),%eax
  103c25:	83 e0 01             	and    $0x1,%eax
  103c28:	85 c0                	test   %eax,%eax
  103c2a:	74 40                	je     103c6c <page_insert+0x90>
    {
        struct Page *p = pte2page(*ptep);
  103c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c2f:	8b 00                	mov    (%eax),%eax
  103c31:	83 ec 0c             	sub    $0xc,%esp
  103c34:	50                   	push   %eax
  103c35:	e8 25 f3 ff ff       	call   102f5f <pte2page>
  103c3a:	83 c4 10             	add    $0x10,%esp
  103c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page)
  103c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c43:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103c46:	75 10                	jne    103c58 <page_insert+0x7c>
        {
            page_ref_dec(page);
  103c48:	83 ec 0c             	sub    $0xc,%esp
  103c4b:	ff 75 0c             	pushl  0xc(%ebp)
  103c4e:	e8 cd f3 ff ff       	call   103020 <page_ref_dec>
  103c53:	83 c4 10             	add    $0x10,%esp
  103c56:	eb 14                	jmp    103c6c <page_insert+0x90>
        }
        else
        {
            page_remove_pte(pgdir, la, ptep);
  103c58:	83 ec 04             	sub    $0x4,%esp
  103c5b:	ff 75 f4             	pushl  -0xc(%ebp)
  103c5e:	ff 75 10             	pushl  0x10(%ebp)
  103c61:	ff 75 08             	pushl  0x8(%ebp)
  103c64:	e8 c1 fe ff ff       	call   103b2a <page_remove_pte>
  103c69:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103c6c:	83 ec 0c             	sub    $0xc,%esp
  103c6f:	ff 75 0c             	pushl  0xc(%ebp)
  103c72:	e8 14 f2 ff ff       	call   102e8b <page2pa>
  103c77:	83 c4 10             	add    $0x10,%esp
  103c7a:	0b 45 14             	or     0x14(%ebp),%eax
  103c7d:	83 c8 01             	or     $0x1,%eax
  103c80:	89 c2                	mov    %eax,%edx
  103c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c85:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103c87:	83 ec 08             	sub    $0x8,%esp
  103c8a:	ff 75 10             	pushl  0x10(%ebp)
  103c8d:	ff 75 08             	pushl  0x8(%ebp)
  103c90:	e8 0a 00 00 00       	call   103c9f <tlb_invalidate>
  103c95:	83 c4 10             	add    $0x10,%esp
    return 0;
  103c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103c9d:	c9                   	leave  
  103c9e:	c3                   	ret    

00103c9f <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
  103c9f:	55                   	push   %ebp
  103ca0:	89 e5                	mov    %esp,%ebp
  103ca2:	53                   	push   %ebx
  103ca3:	83 ec 14             	sub    $0x14,%esp
  103ca6:	e8 07 c6 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  103cab:	05 55 73 01 00       	add    $0x17355,%eax
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103cb0:	0f 20 da             	mov    %cr3,%edx
  103cb3:	89 55 f0             	mov    %edx,-0x10(%ebp)
    return cr3;
  103cb6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    if (rcr3() == PADDR(pgdir))
  103cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  103cbc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  103cbf:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103cc6:	77 1d                	ja     103ce5 <tlb_invalidate+0x46>
  103cc8:	ff 75 f4             	pushl  -0xc(%ebp)
  103ccb:	8d 90 50 be fe ff    	lea    -0x141b0(%eax),%edx
  103cd1:	52                   	push   %edx
  103cd2:	68 00 02 00 00       	push   $0x200
  103cd7:	8d 90 74 be fe ff    	lea    -0x1418c(%eax),%edx
  103cdd:	52                   	push   %edx
  103cde:	89 c3                	mov    %eax,%ebx
  103ce0:	e8 f4 c7 ff ff       	call   1004d9 <__panic>
  103ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ce8:	05 00 00 00 40       	add    $0x40000000,%eax
  103ced:	39 c8                	cmp    %ecx,%eax
  103cef:	75 0c                	jne    103cfd <tlb_invalidate+0x5e>
    {
        invlpg((void *)la);
  103cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  103cf4:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103cf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103cfa:	0f 01 38             	invlpg (%eax)
    }
}
  103cfd:	90                   	nop
  103cfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  103d01:	c9                   	leave  
  103d02:	c3                   	ret    

00103d03 <check_alloc_page>:

static void
check_alloc_page(void)
{
  103d03:	55                   	push   %ebp
  103d04:	89 e5                	mov    %esp,%ebp
  103d06:	53                   	push   %ebx
  103d07:	83 ec 04             	sub    $0x4,%esp
  103d0a:	e8 a7 c5 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  103d0f:	81 c3 f1 72 01 00    	add    $0x172f1,%ebx
    pmm_manager->check();
  103d15:	c7 c0 10 c1 11 00    	mov    $0x11c110,%eax
  103d1b:	8b 00                	mov    (%eax),%eax
  103d1d:	8b 40 18             	mov    0x18(%eax),%eax
  103d20:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103d22:	83 ec 0c             	sub    $0xc,%esp
  103d25:	8d 83 d4 be fe ff    	lea    -0x1412c(%ebx),%eax
  103d2b:	50                   	push   %eax
  103d2c:	e8 f8 c5 ff ff       	call   100329 <cprintf>
  103d31:	83 c4 10             	add    $0x10,%esp
}
  103d34:	90                   	nop
  103d35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  103d38:	c9                   	leave  
  103d39:	c3                   	ret    

00103d3a <check_pgdir>:

static void
check_pgdir(void)
{
  103d3a:	55                   	push   %ebp
  103d3b:	89 e5                	mov    %esp,%ebp
  103d3d:	53                   	push   %ebx
  103d3e:	83 ec 24             	sub    $0x24,%esp
  103d41:	e8 70 c5 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  103d46:	81 c3 ba 72 01 00    	add    $0x172ba,%ebx
    assert(npage <= KMEMSIZE / PGSIZE);
  103d4c:	8b 83 20 10 00 00    	mov    0x1020(%ebx),%eax
  103d52:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103d57:	76 1f                	jbe    103d78 <check_pgdir+0x3e>
  103d59:	8d 83 f3 be fe ff    	lea    -0x1410d(%ebx),%eax
  103d5f:	50                   	push   %eax
  103d60:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  103d66:	50                   	push   %eax
  103d67:	68 10 02 00 00       	push   $0x210
  103d6c:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103d72:	50                   	push   %eax
  103d73:	e8 61 c7 ff ff       	call   1004d9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103d78:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  103d7e:	85 c0                	test   %eax,%eax
  103d80:	74 0f                	je     103d91 <check_pgdir+0x57>
  103d82:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  103d88:	25 ff 0f 00 00       	and    $0xfff,%eax
  103d8d:	85 c0                	test   %eax,%eax
  103d8f:	74 1f                	je     103db0 <check_pgdir+0x76>
  103d91:	8d 83 10 bf fe ff    	lea    -0x140f0(%ebx),%eax
  103d97:	50                   	push   %eax
  103d98:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  103d9e:	50                   	push   %eax
  103d9f:	68 11 02 00 00       	push   $0x211
  103da4:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103daa:	50                   	push   %eax
  103dab:	e8 29 c7 ff ff       	call   1004d9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103db0:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  103db6:	83 ec 04             	sub    $0x4,%esp
  103db9:	6a 00                	push   $0x0
  103dbb:	6a 00                	push   $0x0
  103dbd:	50                   	push   %eax
  103dbe:	e8 07 fd ff ff       	call   103aca <get_page>
  103dc3:	83 c4 10             	add    $0x10,%esp
  103dc6:	85 c0                	test   %eax,%eax
  103dc8:	74 1f                	je     103de9 <check_pgdir+0xaf>
  103dca:	8d 83 48 bf fe ff    	lea    -0x140b8(%ebx),%eax
  103dd0:	50                   	push   %eax
  103dd1:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  103dd7:	50                   	push   %eax
  103dd8:	68 12 02 00 00       	push   $0x212
  103ddd:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103de3:	50                   	push   %eax
  103de4:	e8 f0 c6 ff ff       	call   1004d9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103de9:	83 ec 0c             	sub    $0xc,%esp
  103dec:	6a 01                	push   $0x1
  103dee:	e8 97 f4 ff ff       	call   10328a <alloc_pages>
  103df3:	83 c4 10             	add    $0x10,%esp
  103df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103df9:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  103dff:	6a 00                	push   $0x0
  103e01:	6a 00                	push   $0x0
  103e03:	ff 75 f4             	pushl  -0xc(%ebp)
  103e06:	50                   	push   %eax
  103e07:	e8 d0 fd ff ff       	call   103bdc <page_insert>
  103e0c:	83 c4 10             	add    $0x10,%esp
  103e0f:	85 c0                	test   %eax,%eax
  103e11:	74 1f                	je     103e32 <check_pgdir+0xf8>
  103e13:	8d 83 70 bf fe ff    	lea    -0x14090(%ebx),%eax
  103e19:	50                   	push   %eax
  103e1a:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  103e20:	50                   	push   %eax
  103e21:	68 16 02 00 00       	push   $0x216
  103e26:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103e2c:	50                   	push   %eax
  103e2d:	e8 a7 c6 ff ff       	call   1004d9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103e32:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  103e38:	83 ec 04             	sub    $0x4,%esp
  103e3b:	6a 00                	push   $0x0
  103e3d:	6a 00                	push   $0x0
  103e3f:	50                   	push   %eax
  103e40:	e8 4f fb ff ff       	call   103994 <get_pte>
  103e45:	83 c4 10             	add    $0x10,%esp
  103e48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103e4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103e4f:	75 1f                	jne    103e70 <check_pgdir+0x136>
  103e51:	8d 83 9c bf fe ff    	lea    -0x14064(%ebx),%eax
  103e57:	50                   	push   %eax
  103e58:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  103e5e:	50                   	push   %eax
  103e5f:	68 19 02 00 00       	push   $0x219
  103e64:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103e6a:	50                   	push   %eax
  103e6b:	e8 69 c6 ff ff       	call   1004d9 <__panic>
    assert(pte2page(*ptep) == p1);
  103e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e73:	8b 00                	mov    (%eax),%eax
  103e75:	83 ec 0c             	sub    $0xc,%esp
  103e78:	50                   	push   %eax
  103e79:	e8 e1 f0 ff ff       	call   102f5f <pte2page>
  103e7e:	83 c4 10             	add    $0x10,%esp
  103e81:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103e84:	74 1f                	je     103ea5 <check_pgdir+0x16b>
  103e86:	8d 83 c9 bf fe ff    	lea    -0x14037(%ebx),%eax
  103e8c:	50                   	push   %eax
  103e8d:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  103e93:	50                   	push   %eax
  103e94:	68 1a 02 00 00       	push   $0x21a
  103e99:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103e9f:	50                   	push   %eax
  103ea0:	e8 34 c6 ff ff       	call   1004d9 <__panic>
    assert(page_ref(p1) == 1);
  103ea5:	83 ec 0c             	sub    $0xc,%esp
  103ea8:	ff 75 f4             	pushl  -0xc(%ebp)
  103eab:	e8 23 f1 ff ff       	call   102fd3 <page_ref>
  103eb0:	83 c4 10             	add    $0x10,%esp
  103eb3:	83 f8 01             	cmp    $0x1,%eax
  103eb6:	74 1f                	je     103ed7 <check_pgdir+0x19d>
  103eb8:	8d 83 df bf fe ff    	lea    -0x14021(%ebx),%eax
  103ebe:	50                   	push   %eax
  103ebf:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  103ec5:	50                   	push   %eax
  103ec6:	68 1b 02 00 00       	push   $0x21b
  103ecb:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103ed1:	50                   	push   %eax
  103ed2:	e8 02 c6 ff ff       	call   1004d9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103ed7:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  103edd:	8b 00                	mov    (%eax),%eax
  103edf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103ee4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103eea:	c1 e8 0c             	shr    $0xc,%eax
  103eed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103ef0:	8b 83 20 10 00 00    	mov    0x1020(%ebx),%eax
  103ef6:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103ef9:	72 1b                	jb     103f16 <check_pgdir+0x1dc>
  103efb:	ff 75 ec             	pushl  -0x14(%ebp)
  103efe:	8d 83 ac bd fe ff    	lea    -0x14254(%ebx),%eax
  103f04:	50                   	push   %eax
  103f05:	68 1d 02 00 00       	push   $0x21d
  103f0a:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103f10:	50                   	push   %eax
  103f11:	e8 c3 c5 ff ff       	call   1004d9 <__panic>
  103f16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f19:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103f1e:	83 c0 04             	add    $0x4,%eax
  103f21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103f24:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  103f2a:	83 ec 04             	sub    $0x4,%esp
  103f2d:	6a 00                	push   $0x0
  103f2f:	68 00 10 00 00       	push   $0x1000
  103f34:	50                   	push   %eax
  103f35:	e8 5a fa ff ff       	call   103994 <get_pte>
  103f3a:	83 c4 10             	add    $0x10,%esp
  103f3d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103f40:	74 1f                	je     103f61 <check_pgdir+0x227>
  103f42:	8d 83 f4 bf fe ff    	lea    -0x1400c(%ebx),%eax
  103f48:	50                   	push   %eax
  103f49:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  103f4f:	50                   	push   %eax
  103f50:	68 1e 02 00 00       	push   $0x21e
  103f55:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103f5b:	50                   	push   %eax
  103f5c:	e8 78 c5 ff ff       	call   1004d9 <__panic>

    p2 = alloc_page();
  103f61:	83 ec 0c             	sub    $0xc,%esp
  103f64:	6a 01                	push   $0x1
  103f66:	e8 1f f3 ff ff       	call   10328a <alloc_pages>
  103f6b:	83 c4 10             	add    $0x10,%esp
  103f6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103f71:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  103f77:	6a 06                	push   $0x6
  103f79:	68 00 10 00 00       	push   $0x1000
  103f7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  103f81:	50                   	push   %eax
  103f82:	e8 55 fc ff ff       	call   103bdc <page_insert>
  103f87:	83 c4 10             	add    $0x10,%esp
  103f8a:	85 c0                	test   %eax,%eax
  103f8c:	74 1f                	je     103fad <check_pgdir+0x273>
  103f8e:	8d 83 1c c0 fe ff    	lea    -0x13fe4(%ebx),%eax
  103f94:	50                   	push   %eax
  103f95:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  103f9b:	50                   	push   %eax
  103f9c:	68 21 02 00 00       	push   $0x221
  103fa1:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103fa7:	50                   	push   %eax
  103fa8:	e8 2c c5 ff ff       	call   1004d9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103fad:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  103fb3:	83 ec 04             	sub    $0x4,%esp
  103fb6:	6a 00                	push   $0x0
  103fb8:	68 00 10 00 00       	push   $0x1000
  103fbd:	50                   	push   %eax
  103fbe:	e8 d1 f9 ff ff       	call   103994 <get_pte>
  103fc3:	83 c4 10             	add    $0x10,%esp
  103fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103fc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103fcd:	75 1f                	jne    103fee <check_pgdir+0x2b4>
  103fcf:	8d 83 54 c0 fe ff    	lea    -0x13fac(%ebx),%eax
  103fd5:	50                   	push   %eax
  103fd6:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  103fdc:	50                   	push   %eax
  103fdd:	68 22 02 00 00       	push   $0x222
  103fe2:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  103fe8:	50                   	push   %eax
  103fe9:	e8 eb c4 ff ff       	call   1004d9 <__panic>
    assert(*ptep & PTE_U);
  103fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ff1:	8b 00                	mov    (%eax),%eax
  103ff3:	83 e0 04             	and    $0x4,%eax
  103ff6:	85 c0                	test   %eax,%eax
  103ff8:	75 1f                	jne    104019 <check_pgdir+0x2df>
  103ffa:	8d 83 84 c0 fe ff    	lea    -0x13f7c(%ebx),%eax
  104000:	50                   	push   %eax
  104001:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104007:	50                   	push   %eax
  104008:	68 23 02 00 00       	push   $0x223
  10400d:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  104013:	50                   	push   %eax
  104014:	e8 c0 c4 ff ff       	call   1004d9 <__panic>
    assert(*ptep & PTE_W);
  104019:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10401c:	8b 00                	mov    (%eax),%eax
  10401e:	83 e0 02             	and    $0x2,%eax
  104021:	85 c0                	test   %eax,%eax
  104023:	75 1f                	jne    104044 <check_pgdir+0x30a>
  104025:	8d 83 92 c0 fe ff    	lea    -0x13f6e(%ebx),%eax
  10402b:	50                   	push   %eax
  10402c:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104032:	50                   	push   %eax
  104033:	68 24 02 00 00       	push   $0x224
  104038:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  10403e:	50                   	push   %eax
  10403f:	e8 95 c4 ff ff       	call   1004d9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104044:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  10404a:	8b 00                	mov    (%eax),%eax
  10404c:	83 e0 04             	and    $0x4,%eax
  10404f:	85 c0                	test   %eax,%eax
  104051:	75 1f                	jne    104072 <check_pgdir+0x338>
  104053:	8d 83 a0 c0 fe ff    	lea    -0x13f60(%ebx),%eax
  104059:	50                   	push   %eax
  10405a:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104060:	50                   	push   %eax
  104061:	68 25 02 00 00       	push   $0x225
  104066:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  10406c:	50                   	push   %eax
  10406d:	e8 67 c4 ff ff       	call   1004d9 <__panic>
    assert(page_ref(p2) == 1);
  104072:	83 ec 0c             	sub    $0xc,%esp
  104075:	ff 75 e4             	pushl  -0x1c(%ebp)
  104078:	e8 56 ef ff ff       	call   102fd3 <page_ref>
  10407d:	83 c4 10             	add    $0x10,%esp
  104080:	83 f8 01             	cmp    $0x1,%eax
  104083:	74 1f                	je     1040a4 <check_pgdir+0x36a>
  104085:	8d 83 b6 c0 fe ff    	lea    -0x13f4a(%ebx),%eax
  10408b:	50                   	push   %eax
  10408c:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104092:	50                   	push   %eax
  104093:	68 26 02 00 00       	push   $0x226
  104098:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  10409e:	50                   	push   %eax
  10409f:	e8 35 c4 ff ff       	call   1004d9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  1040a4:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  1040aa:	6a 00                	push   $0x0
  1040ac:	68 00 10 00 00       	push   $0x1000
  1040b1:	ff 75 f4             	pushl  -0xc(%ebp)
  1040b4:	50                   	push   %eax
  1040b5:	e8 22 fb ff ff       	call   103bdc <page_insert>
  1040ba:	83 c4 10             	add    $0x10,%esp
  1040bd:	85 c0                	test   %eax,%eax
  1040bf:	74 1f                	je     1040e0 <check_pgdir+0x3a6>
  1040c1:	8d 83 c8 c0 fe ff    	lea    -0x13f38(%ebx),%eax
  1040c7:	50                   	push   %eax
  1040c8:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  1040ce:	50                   	push   %eax
  1040cf:	68 28 02 00 00       	push   $0x228
  1040d4:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  1040da:	50                   	push   %eax
  1040db:	e8 f9 c3 ff ff       	call   1004d9 <__panic>
    assert(page_ref(p1) == 2);
  1040e0:	83 ec 0c             	sub    $0xc,%esp
  1040e3:	ff 75 f4             	pushl  -0xc(%ebp)
  1040e6:	e8 e8 ee ff ff       	call   102fd3 <page_ref>
  1040eb:	83 c4 10             	add    $0x10,%esp
  1040ee:	83 f8 02             	cmp    $0x2,%eax
  1040f1:	74 1f                	je     104112 <check_pgdir+0x3d8>
  1040f3:	8d 83 f4 c0 fe ff    	lea    -0x13f0c(%ebx),%eax
  1040f9:	50                   	push   %eax
  1040fa:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104100:	50                   	push   %eax
  104101:	68 29 02 00 00       	push   $0x229
  104106:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  10410c:	50                   	push   %eax
  10410d:	e8 c7 c3 ff ff       	call   1004d9 <__panic>
    assert(page_ref(p2) == 0);
  104112:	83 ec 0c             	sub    $0xc,%esp
  104115:	ff 75 e4             	pushl  -0x1c(%ebp)
  104118:	e8 b6 ee ff ff       	call   102fd3 <page_ref>
  10411d:	83 c4 10             	add    $0x10,%esp
  104120:	85 c0                	test   %eax,%eax
  104122:	74 1f                	je     104143 <check_pgdir+0x409>
  104124:	8d 83 06 c1 fe ff    	lea    -0x13efa(%ebx),%eax
  10412a:	50                   	push   %eax
  10412b:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104131:	50                   	push   %eax
  104132:	68 2a 02 00 00       	push   $0x22a
  104137:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  10413d:	50                   	push   %eax
  10413e:	e8 96 c3 ff ff       	call   1004d9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104143:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  104149:	83 ec 04             	sub    $0x4,%esp
  10414c:	6a 00                	push   $0x0
  10414e:	68 00 10 00 00       	push   $0x1000
  104153:	50                   	push   %eax
  104154:	e8 3b f8 ff ff       	call   103994 <get_pte>
  104159:	83 c4 10             	add    $0x10,%esp
  10415c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10415f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104163:	75 1f                	jne    104184 <check_pgdir+0x44a>
  104165:	8d 83 54 c0 fe ff    	lea    -0x13fac(%ebx),%eax
  10416b:	50                   	push   %eax
  10416c:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104172:	50                   	push   %eax
  104173:	68 2b 02 00 00       	push   $0x22b
  104178:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  10417e:	50                   	push   %eax
  10417f:	e8 55 c3 ff ff       	call   1004d9 <__panic>
    assert(pte2page(*ptep) == p1);
  104184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104187:	8b 00                	mov    (%eax),%eax
  104189:	83 ec 0c             	sub    $0xc,%esp
  10418c:	50                   	push   %eax
  10418d:	e8 cd ed ff ff       	call   102f5f <pte2page>
  104192:	83 c4 10             	add    $0x10,%esp
  104195:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104198:	74 1f                	je     1041b9 <check_pgdir+0x47f>
  10419a:	8d 83 c9 bf fe ff    	lea    -0x14037(%ebx),%eax
  1041a0:	50                   	push   %eax
  1041a1:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  1041a7:	50                   	push   %eax
  1041a8:	68 2c 02 00 00       	push   $0x22c
  1041ad:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  1041b3:	50                   	push   %eax
  1041b4:	e8 20 c3 ff ff       	call   1004d9 <__panic>
    assert((*ptep & PTE_U) == 0);
  1041b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041bc:	8b 00                	mov    (%eax),%eax
  1041be:	83 e0 04             	and    $0x4,%eax
  1041c1:	85 c0                	test   %eax,%eax
  1041c3:	74 1f                	je     1041e4 <check_pgdir+0x4aa>
  1041c5:	8d 83 18 c1 fe ff    	lea    -0x13ee8(%ebx),%eax
  1041cb:	50                   	push   %eax
  1041cc:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  1041d2:	50                   	push   %eax
  1041d3:	68 2d 02 00 00       	push   $0x22d
  1041d8:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  1041de:	50                   	push   %eax
  1041df:	e8 f5 c2 ff ff       	call   1004d9 <__panic>

    page_remove(boot_pgdir, 0x0);
  1041e4:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  1041ea:	83 ec 08             	sub    $0x8,%esp
  1041ed:	6a 00                	push   $0x0
  1041ef:	50                   	push   %eax
  1041f0:	e8 a4 f9 ff ff       	call   103b99 <page_remove>
  1041f5:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
  1041f8:	83 ec 0c             	sub    $0xc,%esp
  1041fb:	ff 75 f4             	pushl  -0xc(%ebp)
  1041fe:	e8 d0 ed ff ff       	call   102fd3 <page_ref>
  104203:	83 c4 10             	add    $0x10,%esp
  104206:	83 f8 01             	cmp    $0x1,%eax
  104209:	74 1f                	je     10422a <check_pgdir+0x4f0>
  10420b:	8d 83 df bf fe ff    	lea    -0x14021(%ebx),%eax
  104211:	50                   	push   %eax
  104212:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104218:	50                   	push   %eax
  104219:	68 30 02 00 00       	push   $0x230
  10421e:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  104224:	50                   	push   %eax
  104225:	e8 af c2 ff ff       	call   1004d9 <__panic>
    assert(page_ref(p2) == 0);
  10422a:	83 ec 0c             	sub    $0xc,%esp
  10422d:	ff 75 e4             	pushl  -0x1c(%ebp)
  104230:	e8 9e ed ff ff       	call   102fd3 <page_ref>
  104235:	83 c4 10             	add    $0x10,%esp
  104238:	85 c0                	test   %eax,%eax
  10423a:	74 1f                	je     10425b <check_pgdir+0x521>
  10423c:	8d 83 06 c1 fe ff    	lea    -0x13efa(%ebx),%eax
  104242:	50                   	push   %eax
  104243:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104249:	50                   	push   %eax
  10424a:	68 31 02 00 00       	push   $0x231
  10424f:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  104255:	50                   	push   %eax
  104256:	e8 7e c2 ff ff       	call   1004d9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  10425b:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  104261:	83 ec 08             	sub    $0x8,%esp
  104264:	68 00 10 00 00       	push   $0x1000
  104269:	50                   	push   %eax
  10426a:	e8 2a f9 ff ff       	call   103b99 <page_remove>
  10426f:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
  104272:	83 ec 0c             	sub    $0xc,%esp
  104275:	ff 75 f4             	pushl  -0xc(%ebp)
  104278:	e8 56 ed ff ff       	call   102fd3 <page_ref>
  10427d:	83 c4 10             	add    $0x10,%esp
  104280:	85 c0                	test   %eax,%eax
  104282:	74 1f                	je     1042a3 <check_pgdir+0x569>
  104284:	8d 83 2d c1 fe ff    	lea    -0x13ed3(%ebx),%eax
  10428a:	50                   	push   %eax
  10428b:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104291:	50                   	push   %eax
  104292:	68 34 02 00 00       	push   $0x234
  104297:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  10429d:	50                   	push   %eax
  10429e:	e8 36 c2 ff ff       	call   1004d9 <__panic>
    assert(page_ref(p2) == 0);
  1042a3:	83 ec 0c             	sub    $0xc,%esp
  1042a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  1042a9:	e8 25 ed ff ff       	call   102fd3 <page_ref>
  1042ae:	83 c4 10             	add    $0x10,%esp
  1042b1:	85 c0                	test   %eax,%eax
  1042b3:	74 1f                	je     1042d4 <check_pgdir+0x59a>
  1042b5:	8d 83 06 c1 fe ff    	lea    -0x13efa(%ebx),%eax
  1042bb:	50                   	push   %eax
  1042bc:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  1042c2:	50                   	push   %eax
  1042c3:	68 35 02 00 00       	push   $0x235
  1042c8:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  1042ce:	50                   	push   %eax
  1042cf:	e8 05 c2 ff ff       	call   1004d9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  1042d4:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  1042da:	8b 00                	mov    (%eax),%eax
  1042dc:	83 ec 0c             	sub    $0xc,%esp
  1042df:	50                   	push   %eax
  1042e0:	e8 c8 ec ff ff       	call   102fad <pde2page>
  1042e5:	83 c4 10             	add    $0x10,%esp
  1042e8:	83 ec 0c             	sub    $0xc,%esp
  1042eb:	50                   	push   %eax
  1042ec:	e8 e2 ec ff ff       	call   102fd3 <page_ref>
  1042f1:	83 c4 10             	add    $0x10,%esp
  1042f4:	83 f8 01             	cmp    $0x1,%eax
  1042f7:	74 1f                	je     104318 <check_pgdir+0x5de>
  1042f9:	8d 83 40 c1 fe ff    	lea    -0x13ec0(%ebx),%eax
  1042ff:	50                   	push   %eax
  104300:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104306:	50                   	push   %eax
  104307:	68 37 02 00 00       	push   $0x237
  10430c:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  104312:	50                   	push   %eax
  104313:	e8 c1 c1 ff ff       	call   1004d9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104318:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  10431e:	8b 00                	mov    (%eax),%eax
  104320:	83 ec 0c             	sub    $0xc,%esp
  104323:	50                   	push   %eax
  104324:	e8 84 ec ff ff       	call   102fad <pde2page>
  104329:	83 c4 10             	add    $0x10,%esp
  10432c:	83 ec 08             	sub    $0x8,%esp
  10432f:	6a 01                	push   $0x1
  104331:	50                   	push   %eax
  104332:	e8 a3 ef ff ff       	call   1032da <free_pages>
  104337:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  10433a:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  104340:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104346:	83 ec 0c             	sub    $0xc,%esp
  104349:	8d 83 67 c1 fe ff    	lea    -0x13e99(%ebx),%eax
  10434f:	50                   	push   %eax
  104350:	e8 d4 bf ff ff       	call   100329 <cprintf>
  104355:	83 c4 10             	add    $0x10,%esp
}
  104358:	90                   	nop
  104359:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10435c:	c9                   	leave  
  10435d:	c3                   	ret    

0010435e <check_boot_pgdir>:

static void
check_boot_pgdir(void)
{
  10435e:	55                   	push   %ebp
  10435f:	89 e5                	mov    %esp,%ebp
  104361:	53                   	push   %ebx
  104362:	83 ec 24             	sub    $0x24,%esp
  104365:	e8 4c bf ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  10436a:	81 c3 96 6c 01 00    	add    $0x16c96,%ebx
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE)
  104370:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104377:	e9 b5 00 00 00       	jmp    104431 <check_boot_pgdir+0xd3>
    {
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  10437c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10437f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104382:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104385:	c1 e8 0c             	shr    $0xc,%eax
  104388:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10438b:	8b 83 20 10 00 00    	mov    0x1020(%ebx),%eax
  104391:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104394:	72 1b                	jb     1043b1 <check_boot_pgdir+0x53>
  104396:	ff 75 e4             	pushl  -0x1c(%ebp)
  104399:	8d 83 ac bd fe ff    	lea    -0x14254(%ebx),%eax
  10439f:	50                   	push   %eax
  1043a0:	68 45 02 00 00       	push   $0x245
  1043a5:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  1043ab:	50                   	push   %eax
  1043ac:	e8 28 c1 ff ff       	call   1004d9 <__panic>
  1043b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1043b4:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1043b9:	89 c2                	mov    %eax,%edx
  1043bb:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  1043c1:	83 ec 04             	sub    $0x4,%esp
  1043c4:	6a 00                	push   $0x0
  1043c6:	52                   	push   %edx
  1043c7:	50                   	push   %eax
  1043c8:	e8 c7 f5 ff ff       	call   103994 <get_pte>
  1043cd:	83 c4 10             	add    $0x10,%esp
  1043d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1043d3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1043d7:	75 1f                	jne    1043f8 <check_boot_pgdir+0x9a>
  1043d9:	8d 83 84 c1 fe ff    	lea    -0x13e7c(%ebx),%eax
  1043df:	50                   	push   %eax
  1043e0:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  1043e6:	50                   	push   %eax
  1043e7:	68 45 02 00 00       	push   $0x245
  1043ec:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  1043f2:	50                   	push   %eax
  1043f3:	e8 e1 c0 ff ff       	call   1004d9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  1043f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1043fb:	8b 00                	mov    (%eax),%eax
  1043fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104402:	89 c2                	mov    %eax,%edx
  104404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104407:	39 c2                	cmp    %eax,%edx
  104409:	74 1f                	je     10442a <check_boot_pgdir+0xcc>
  10440b:	8d 83 c1 c1 fe ff    	lea    -0x13e3f(%ebx),%eax
  104411:	50                   	push   %eax
  104412:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104418:	50                   	push   %eax
  104419:	68 46 02 00 00       	push   $0x246
  10441e:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  104424:	50                   	push   %eax
  104425:	e8 af c0 ff ff       	call   1004d9 <__panic>
    for (i = 0; i < npage; i += PGSIZE)
  10442a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104431:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104434:	8b 83 20 10 00 00    	mov    0x1020(%ebx),%eax
  10443a:	39 c2                	cmp    %eax,%edx
  10443c:	0f 82 3a ff ff ff    	jb     10437c <check_boot_pgdir+0x1e>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104442:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  104448:	05 ac 0f 00 00       	add    $0xfac,%eax
  10444d:	8b 00                	mov    (%eax),%eax
  10444f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104454:	89 c2                	mov    %eax,%edx
  104456:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  10445c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10445f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104466:	77 1b                	ja     104483 <check_boot_pgdir+0x125>
  104468:	ff 75 f0             	pushl  -0x10(%ebp)
  10446b:	8d 83 50 be fe ff    	lea    -0x141b0(%ebx),%eax
  104471:	50                   	push   %eax
  104472:	68 49 02 00 00       	push   $0x249
  104477:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  10447d:	50                   	push   %eax
  10447e:	e8 56 c0 ff ff       	call   1004d9 <__panic>
  104483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104486:	05 00 00 00 40       	add    $0x40000000,%eax
  10448b:	39 d0                	cmp    %edx,%eax
  10448d:	74 1f                	je     1044ae <check_boot_pgdir+0x150>
  10448f:	8d 83 d8 c1 fe ff    	lea    -0x13e28(%ebx),%eax
  104495:	50                   	push   %eax
  104496:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  10449c:	50                   	push   %eax
  10449d:	68 49 02 00 00       	push   $0x249
  1044a2:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  1044a8:	50                   	push   %eax
  1044a9:	e8 2b c0 ff ff       	call   1004d9 <__panic>

    assert(boot_pgdir[0] == 0);
  1044ae:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  1044b4:	8b 00                	mov    (%eax),%eax
  1044b6:	85 c0                	test   %eax,%eax
  1044b8:	74 1f                	je     1044d9 <check_boot_pgdir+0x17b>
  1044ba:	8d 83 0c c2 fe ff    	lea    -0x13df4(%ebx),%eax
  1044c0:	50                   	push   %eax
  1044c1:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  1044c7:	50                   	push   %eax
  1044c8:	68 4b 02 00 00       	push   $0x24b
  1044cd:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  1044d3:	50                   	push   %eax
  1044d4:	e8 00 c0 ff ff       	call   1004d9 <__panic>

    struct Page *p;
    p = alloc_page();
  1044d9:	83 ec 0c             	sub    $0xc,%esp
  1044dc:	6a 01                	push   $0x1
  1044de:	e8 a7 ed ff ff       	call   10328a <alloc_pages>
  1044e3:	83 c4 10             	add    $0x10,%esp
  1044e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  1044e9:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  1044ef:	6a 02                	push   $0x2
  1044f1:	68 00 01 00 00       	push   $0x100
  1044f6:	ff 75 ec             	pushl  -0x14(%ebp)
  1044f9:	50                   	push   %eax
  1044fa:	e8 dd f6 ff ff       	call   103bdc <page_insert>
  1044ff:	83 c4 10             	add    $0x10,%esp
  104502:	85 c0                	test   %eax,%eax
  104504:	74 1f                	je     104525 <check_boot_pgdir+0x1c7>
  104506:	8d 83 20 c2 fe ff    	lea    -0x13de0(%ebx),%eax
  10450c:	50                   	push   %eax
  10450d:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104513:	50                   	push   %eax
  104514:	68 4f 02 00 00       	push   $0x24f
  104519:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  10451f:	50                   	push   %eax
  104520:	e8 b4 bf ff ff       	call   1004d9 <__panic>
    assert(page_ref(p) == 1);
  104525:	83 ec 0c             	sub    $0xc,%esp
  104528:	ff 75 ec             	pushl  -0x14(%ebp)
  10452b:	e8 a3 ea ff ff       	call   102fd3 <page_ref>
  104530:	83 c4 10             	add    $0x10,%esp
  104533:	83 f8 01             	cmp    $0x1,%eax
  104536:	74 1f                	je     104557 <check_boot_pgdir+0x1f9>
  104538:	8d 83 4e c2 fe ff    	lea    -0x13db2(%ebx),%eax
  10453e:	50                   	push   %eax
  10453f:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104545:	50                   	push   %eax
  104546:	68 50 02 00 00       	push   $0x250
  10454b:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  104551:	50                   	push   %eax
  104552:	e8 82 bf ff ff       	call   1004d9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104557:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  10455d:	6a 02                	push   $0x2
  10455f:	68 00 11 00 00       	push   $0x1100
  104564:	ff 75 ec             	pushl  -0x14(%ebp)
  104567:	50                   	push   %eax
  104568:	e8 6f f6 ff ff       	call   103bdc <page_insert>
  10456d:	83 c4 10             	add    $0x10,%esp
  104570:	85 c0                	test   %eax,%eax
  104572:	74 1f                	je     104593 <check_boot_pgdir+0x235>
  104574:	8d 83 60 c2 fe ff    	lea    -0x13da0(%ebx),%eax
  10457a:	50                   	push   %eax
  10457b:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104581:	50                   	push   %eax
  104582:	68 51 02 00 00       	push   $0x251
  104587:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  10458d:	50                   	push   %eax
  10458e:	e8 46 bf ff ff       	call   1004d9 <__panic>
    assert(page_ref(p) == 2);
  104593:	83 ec 0c             	sub    $0xc,%esp
  104596:	ff 75 ec             	pushl  -0x14(%ebp)
  104599:	e8 35 ea ff ff       	call   102fd3 <page_ref>
  10459e:	83 c4 10             	add    $0x10,%esp
  1045a1:	83 f8 02             	cmp    $0x2,%eax
  1045a4:	74 1f                	je     1045c5 <check_boot_pgdir+0x267>
  1045a6:	8d 83 97 c2 fe ff    	lea    -0x13d69(%ebx),%eax
  1045ac:	50                   	push   %eax
  1045ad:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  1045b3:	50                   	push   %eax
  1045b4:	68 52 02 00 00       	push   $0x252
  1045b9:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  1045bf:	50                   	push   %eax
  1045c0:	e8 14 bf ff ff       	call   1004d9 <__panic>

    const char *str = "ucore: Hello world!!";
  1045c5:	8d 83 a8 c2 fe ff    	lea    -0x13d58(%ebx),%eax
  1045cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    strcpy((void *)0x100, str);
  1045ce:	83 ec 08             	sub    $0x8,%esp
  1045d1:	ff 75 e8             	pushl  -0x18(%ebp)
  1045d4:	68 00 01 00 00       	push   $0x100
  1045d9:	e8 b7 15 00 00       	call   105b95 <strcpy>
  1045de:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1045e1:	83 ec 08             	sub    $0x8,%esp
  1045e4:	68 00 11 00 00       	push   $0x1100
  1045e9:	68 00 01 00 00       	push   $0x100
  1045ee:	e8 30 16 00 00       	call   105c23 <strcmp>
  1045f3:	83 c4 10             	add    $0x10,%esp
  1045f6:	85 c0                	test   %eax,%eax
  1045f8:	74 1f                	je     104619 <check_boot_pgdir+0x2bb>
  1045fa:	8d 83 c0 c2 fe ff    	lea    -0x13d40(%ebx),%eax
  104600:	50                   	push   %eax
  104601:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104607:	50                   	push   %eax
  104608:	68 56 02 00 00       	push   $0x256
  10460d:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  104613:	50                   	push   %eax
  104614:	e8 c0 be ff ff       	call   1004d9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104619:	83 ec 0c             	sub    $0xc,%esp
  10461c:	ff 75 ec             	pushl  -0x14(%ebp)
  10461f:	e8 e2 e8 ff ff       	call   102f06 <page2kva>
  104624:	83 c4 10             	add    $0x10,%esp
  104627:	05 00 01 00 00       	add    $0x100,%eax
  10462c:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  10462f:	83 ec 0c             	sub    $0xc,%esp
  104632:	68 00 01 00 00       	push   $0x100
  104637:	e8 ed 14 00 00       	call   105b29 <strlen>
  10463c:	83 c4 10             	add    $0x10,%esp
  10463f:	85 c0                	test   %eax,%eax
  104641:	74 1f                	je     104662 <check_boot_pgdir+0x304>
  104643:	8d 83 f8 c2 fe ff    	lea    -0x13d08(%ebx),%eax
  104649:	50                   	push   %eax
  10464a:	8d 83 99 be fe ff    	lea    -0x14167(%ebx),%eax
  104650:	50                   	push   %eax
  104651:	68 59 02 00 00       	push   $0x259
  104656:	8d 83 74 be fe ff    	lea    -0x1418c(%ebx),%eax
  10465c:	50                   	push   %eax
  10465d:	e8 77 be ff ff       	call   1004d9 <__panic>

    free_page(p);
  104662:	83 ec 08             	sub    $0x8,%esp
  104665:	6a 01                	push   $0x1
  104667:	ff 75 ec             	pushl  -0x14(%ebp)
  10466a:	e8 6b ec ff ff       	call   1032da <free_pages>
  10466f:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
  104672:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  104678:	8b 00                	mov    (%eax),%eax
  10467a:	83 ec 0c             	sub    $0xc,%esp
  10467d:	50                   	push   %eax
  10467e:	e8 2a e9 ff ff       	call   102fad <pde2page>
  104683:	83 c4 10             	add    $0x10,%esp
  104686:	83 ec 08             	sub    $0x8,%esp
  104689:	6a 01                	push   $0x1
  10468b:	50                   	push   %eax
  10468c:	e8 49 ec ff ff       	call   1032da <free_pages>
  104691:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  104694:	8b 83 88 01 00 00    	mov    0x188(%ebx),%eax
  10469a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1046a0:	83 ec 0c             	sub    $0xc,%esp
  1046a3:	8d 83 1c c3 fe ff    	lea    -0x13ce4(%ebx),%eax
  1046a9:	50                   	push   %eax
  1046aa:	e8 7a bc ff ff       	call   100329 <cprintf>
  1046af:	83 c4 10             	add    $0x10,%esp
}
  1046b2:	90                   	nop
  1046b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1046b6:	c9                   	leave  
  1046b7:	c3                   	ret    

001046b8 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm)
{
  1046b8:	55                   	push   %ebp
  1046b9:	89 e5                	mov    %esp,%ebp
  1046bb:	e8 f2 bb ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1046c0:	05 40 69 01 00       	add    $0x16940,%eax
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1046c5:	8b 55 08             	mov    0x8(%ebp),%edx
  1046c8:	83 e2 04             	and    $0x4,%edx
  1046cb:	85 d2                	test   %edx,%edx
  1046cd:	74 07                	je     1046d6 <perm2str+0x1e>
  1046cf:	ba 75 00 00 00       	mov    $0x75,%edx
  1046d4:	eb 05                	jmp    1046db <perm2str+0x23>
  1046d6:	ba 2d 00 00 00       	mov    $0x2d,%edx
  1046db:	88 90 a8 10 00 00    	mov    %dl,0x10a8(%eax)
    str[1] = 'r';
  1046e1:	c6 80 a9 10 00 00 72 	movb   $0x72,0x10a9(%eax)
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1046e8:	8b 55 08             	mov    0x8(%ebp),%edx
  1046eb:	83 e2 02             	and    $0x2,%edx
  1046ee:	85 d2                	test   %edx,%edx
  1046f0:	74 07                	je     1046f9 <perm2str+0x41>
  1046f2:	ba 77 00 00 00       	mov    $0x77,%edx
  1046f7:	eb 05                	jmp    1046fe <perm2str+0x46>
  1046f9:	ba 2d 00 00 00       	mov    $0x2d,%edx
  1046fe:	88 90 aa 10 00 00    	mov    %dl,0x10aa(%eax)
    str[3] = '\0';
  104704:	c6 80 ab 10 00 00 00 	movb   $0x0,0x10ab(%eax)
    return str;
  10470b:	8d 80 a8 10 00 00    	lea    0x10a8(%eax),%eax
}
  104711:	5d                   	pop    %ebp
  104712:	c3                   	ret    

00104713 <get_pgtable_items>:
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store)
{
  104713:	55                   	push   %ebp
  104714:	89 e5                	mov    %esp,%ebp
  104716:	83 ec 10             	sub    $0x10,%esp
  104719:	e8 94 bb ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  10471e:	05 e2 68 01 00       	add    $0x168e2,%eax
    if (start >= right)
  104723:	8b 45 10             	mov    0x10(%ebp),%eax
  104726:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104729:	72 0e                	jb     104739 <get_pgtable_items+0x26>
    {
        return 0;
  10472b:	b8 00 00 00 00       	mov    $0x0,%eax
  104730:	e9 9a 00 00 00       	jmp    1047cf <get_pgtable_items+0xbc>
    }
    while (start < right && !(table[start] & PTE_P))
    {
        start++;
  104735:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P))
  104739:	8b 45 10             	mov    0x10(%ebp),%eax
  10473c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10473f:	73 18                	jae    104759 <get_pgtable_items+0x46>
  104741:	8b 45 10             	mov    0x10(%ebp),%eax
  104744:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10474b:	8b 45 14             	mov    0x14(%ebp),%eax
  10474e:	01 d0                	add    %edx,%eax
  104750:	8b 00                	mov    (%eax),%eax
  104752:	83 e0 01             	and    $0x1,%eax
  104755:	85 c0                	test   %eax,%eax
  104757:	74 dc                	je     104735 <get_pgtable_items+0x22>
    }
    if (start < right)
  104759:	8b 45 10             	mov    0x10(%ebp),%eax
  10475c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10475f:	73 69                	jae    1047ca <get_pgtable_items+0xb7>
    {
        if (left_store != NULL)
  104761:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  104765:	74 08                	je     10476f <get_pgtable_items+0x5c>
        {
            *left_store = start;
  104767:	8b 45 18             	mov    0x18(%ebp),%eax
  10476a:	8b 55 10             	mov    0x10(%ebp),%edx
  10476d:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start++] & PTE_USER);
  10476f:	8b 45 10             	mov    0x10(%ebp),%eax
  104772:	8d 50 01             	lea    0x1(%eax),%edx
  104775:	89 55 10             	mov    %edx,0x10(%ebp)
  104778:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10477f:	8b 45 14             	mov    0x14(%ebp),%eax
  104782:	01 d0                	add    %edx,%eax
  104784:	8b 00                	mov    (%eax),%eax
  104786:	83 e0 07             	and    $0x7,%eax
  104789:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
  10478c:	eb 04                	jmp    104792 <get_pgtable_items+0x7f>
        {
            start++;
  10478e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
  104792:	8b 45 10             	mov    0x10(%ebp),%eax
  104795:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104798:	73 1d                	jae    1047b7 <get_pgtable_items+0xa4>
  10479a:	8b 45 10             	mov    0x10(%ebp),%eax
  10479d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1047a4:	8b 45 14             	mov    0x14(%ebp),%eax
  1047a7:	01 d0                	add    %edx,%eax
  1047a9:	8b 00                	mov    (%eax),%eax
  1047ab:	83 e0 07             	and    $0x7,%eax
  1047ae:	89 c2                	mov    %eax,%edx
  1047b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1047b3:	39 c2                	cmp    %eax,%edx
  1047b5:	74 d7                	je     10478e <get_pgtable_items+0x7b>
        }
        if (right_store != NULL)
  1047b7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1047bb:	74 08                	je     1047c5 <get_pgtable_items+0xb2>
        {
            *right_store = start;
  1047bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1047c0:	8b 55 10             	mov    0x10(%ebp),%edx
  1047c3:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1047c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1047c8:	eb 05                	jmp    1047cf <get_pgtable_items+0xbc>
    }
    return 0;
  1047ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1047cf:	c9                   	leave  
  1047d0:	c3                   	ret    

001047d1 <print_pgdir>:

//print_pgdir - print the PDT&PT
void print_pgdir(void)
{
  1047d1:	55                   	push   %ebp
  1047d2:	89 e5                	mov    %esp,%ebp
  1047d4:	57                   	push   %edi
  1047d5:	56                   	push   %esi
  1047d6:	53                   	push   %ebx
  1047d7:	83 ec 3c             	sub    $0x3c,%esp
  1047da:	e8 d7 ba ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  1047df:	81 c3 21 68 01 00    	add    $0x16821,%ebx
    cprintf("-------------------- BEGIN --------------------\n");
  1047e5:	83 ec 0c             	sub    $0xc,%esp
  1047e8:	8d 83 3c c3 fe ff    	lea    -0x13cc4(%ebx),%eax
  1047ee:	50                   	push   %eax
  1047ef:	e8 35 bb ff ff       	call   100329 <cprintf>
  1047f4:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
  1047f7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
  1047fe:	e9 ef 00 00 00       	jmp    1048f2 <print_pgdir+0x121>
    {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104806:	83 ec 0c             	sub    $0xc,%esp
  104809:	50                   	push   %eax
  10480a:	e8 a9 fe ff ff       	call   1046b8 <perm2str>
  10480f:	83 c4 10             	add    $0x10,%esp
  104812:	89 45 c4             	mov    %eax,-0x3c(%ebp)
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104818:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10481b:	29 c2                	sub    %eax,%edx
  10481d:	89 d0                	mov    %edx,%eax
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10481f:	89 c6                	mov    %eax,%esi
  104821:	c1 e6 16             	shl    $0x16,%esi
  104824:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104827:	89 c1                	mov    %eax,%ecx
  104829:	c1 e1 16             	shl    $0x16,%ecx
  10482c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10482f:	89 c2                	mov    %eax,%edx
  104831:	c1 e2 16             	shl    $0x16,%edx
  104834:	8b 7d dc             	mov    -0x24(%ebp),%edi
  104837:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10483a:	29 c7                	sub    %eax,%edi
  10483c:	89 f8                	mov    %edi,%eax
  10483e:	83 ec 08             	sub    $0x8,%esp
  104841:	ff 75 c4             	pushl  -0x3c(%ebp)
  104844:	56                   	push   %esi
  104845:	51                   	push   %ecx
  104846:	52                   	push   %edx
  104847:	50                   	push   %eax
  104848:	8d 83 6d c3 fe ff    	lea    -0x13c93(%ebx),%eax
  10484e:	50                   	push   %eax
  10484f:	e8 d5 ba ff ff       	call   100329 <cprintf>
  104854:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
  104857:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10485a:	c1 e0 0a             	shl    $0xa,%eax
  10485d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
  104860:	eb 54                	jmp    1048b6 <print_pgdir+0xe5>
        {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104865:	83 ec 0c             	sub    $0xc,%esp
  104868:	50                   	push   %eax
  104869:	e8 4a fe ff ff       	call   1046b8 <perm2str>
  10486e:	83 c4 10             	add    $0x10,%esp
  104871:	89 45 c4             	mov    %eax,-0x3c(%ebp)
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104874:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104877:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10487a:	29 c2                	sub    %eax,%edx
  10487c:	89 d0                	mov    %edx,%eax
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10487e:	89 c6                	mov    %eax,%esi
  104880:	c1 e6 0c             	shl    $0xc,%esi
  104883:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104886:	89 c1                	mov    %eax,%ecx
  104888:	c1 e1 0c             	shl    $0xc,%ecx
  10488b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10488e:	89 c2                	mov    %eax,%edx
  104890:	c1 e2 0c             	shl    $0xc,%edx
  104893:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  104896:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104899:	29 c7                	sub    %eax,%edi
  10489b:	89 f8                	mov    %edi,%eax
  10489d:	83 ec 08             	sub    $0x8,%esp
  1048a0:	ff 75 c4             	pushl  -0x3c(%ebp)
  1048a3:	56                   	push   %esi
  1048a4:	51                   	push   %ecx
  1048a5:	52                   	push   %edx
  1048a6:	50                   	push   %eax
  1048a7:	8d 83 8c c3 fe ff    	lea    -0x13c74(%ebx),%eax
  1048ad:	50                   	push   %eax
  1048ae:	e8 76 ba ff ff       	call   100329 <cprintf>
  1048b3:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
  1048b6:	bf 00 00 c0 fa       	mov    $0xfac00000,%edi
  1048bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1048be:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1048c1:	89 d6                	mov    %edx,%esi
  1048c3:	c1 e6 0a             	shl    $0xa,%esi
  1048c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1048c9:	89 d1                	mov    %edx,%ecx
  1048cb:	c1 e1 0a             	shl    $0xa,%ecx
  1048ce:	83 ec 08             	sub    $0x8,%esp
  1048d1:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1048d4:	52                   	push   %edx
  1048d5:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1048d8:	52                   	push   %edx
  1048d9:	57                   	push   %edi
  1048da:	50                   	push   %eax
  1048db:	56                   	push   %esi
  1048dc:	51                   	push   %ecx
  1048dd:	e8 31 fe ff ff       	call   104713 <get_pgtable_items>
  1048e2:	83 c4 20             	add    $0x20,%esp
  1048e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1048e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1048ec:	0f 85 70 ff ff ff    	jne    104862 <print_pgdir+0x91>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
  1048f2:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  1048f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1048fa:	83 ec 08             	sub    $0x8,%esp
  1048fd:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104900:	52                   	push   %edx
  104901:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104904:	52                   	push   %edx
  104905:	51                   	push   %ecx
  104906:	50                   	push   %eax
  104907:	68 00 04 00 00       	push   $0x400
  10490c:	6a 00                	push   $0x0
  10490e:	e8 00 fe ff ff       	call   104713 <get_pgtable_items>
  104913:	83 c4 20             	add    $0x20,%esp
  104916:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104919:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10491d:	0f 85 e0 fe ff ff    	jne    104803 <print_pgdir+0x32>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  104923:	83 ec 0c             	sub    $0xc,%esp
  104926:	8d 83 b0 c3 fe ff    	lea    -0x13c50(%ebx),%eax
  10492c:	50                   	push   %eax
  10492d:	e8 f7 b9 ff ff       	call   100329 <cprintf>
  104932:	83 c4 10             	add    $0x10,%esp
}
  104935:	90                   	nop
  104936:	8d 65 f4             	lea    -0xc(%ebp),%esp
  104939:	5b                   	pop    %ebx
  10493a:	5e                   	pop    %esi
  10493b:	5f                   	pop    %edi
  10493c:	5d                   	pop    %ebp
  10493d:	c3                   	ret    

0010493e <__x86.get_pc_thunk.si>:
  10493e:	8b 34 24             	mov    (%esp),%esi
  104941:	c3                   	ret    

00104942 <page2ppn>:
page2ppn(struct Page *page) {
  104942:	55                   	push   %ebp
  104943:	89 e5                	mov    %esp,%ebp
  104945:	e8 68 b9 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  10494a:	05 b6 66 01 00       	add    $0x166b6,%eax
    return page - pages;
  10494f:	8b 55 08             	mov    0x8(%ebp),%edx
  104952:	c7 c0 18 c1 11 00    	mov    $0x11c118,%eax
  104958:	8b 00                	mov    (%eax),%eax
  10495a:	29 c2                	sub    %eax,%edx
  10495c:	89 d0                	mov    %edx,%eax
  10495e:	c1 f8 02             	sar    $0x2,%eax
  104961:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  104967:	5d                   	pop    %ebp
  104968:	c3                   	ret    

00104969 <page2pa>:
page2pa(struct Page *page) {
  104969:	55                   	push   %ebp
  10496a:	89 e5                	mov    %esp,%ebp
  10496c:	e8 41 b9 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  104971:	05 8f 66 01 00       	add    $0x1668f,%eax
    return page2ppn(page) << PGSHIFT;
  104976:	ff 75 08             	pushl  0x8(%ebp)
  104979:	e8 c4 ff ff ff       	call   104942 <page2ppn>
  10497e:	83 c4 04             	add    $0x4,%esp
  104981:	c1 e0 0c             	shl    $0xc,%eax
}
  104984:	c9                   	leave  
  104985:	c3                   	ret    

00104986 <page_ref>:
page_ref(struct Page *page) {
  104986:	55                   	push   %ebp
  104987:	89 e5                	mov    %esp,%ebp
  104989:	e8 24 b9 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  10498e:	05 72 66 01 00       	add    $0x16672,%eax
    return page->ref;
  104993:	8b 45 08             	mov    0x8(%ebp),%eax
  104996:	8b 00                	mov    (%eax),%eax
}
  104998:	5d                   	pop    %ebp
  104999:	c3                   	ret    

0010499a <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  10499a:	55                   	push   %ebp
  10499b:	89 e5                	mov    %esp,%ebp
  10499d:	e8 10 b9 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1049a2:	05 5e 66 01 00       	add    $0x1665e,%eax
    page->ref = val;
  1049a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1049aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  1049ad:	89 10                	mov    %edx,(%eax)
}
  1049af:	90                   	nop
  1049b0:	5d                   	pop    %ebp
  1049b1:	c3                   	ret    

001049b2 <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void)
{
  1049b2:	55                   	push   %ebp
  1049b3:	89 e5                	mov    %esp,%ebp
  1049b5:	83 ec 10             	sub    $0x10,%esp
  1049b8:	e8 f5 b8 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1049bd:	05 43 66 01 00       	add    $0x16643,%eax
  1049c2:	c7 c2 1c c1 11 00    	mov    $0x11c11c,%edx
  1049c8:	89 55 fc             	mov    %edx,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1049cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1049ce:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  1049d1:	89 4a 04             	mov    %ecx,0x4(%edx)
  1049d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1049d7:	8b 4a 04             	mov    0x4(%edx),%ecx
  1049da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1049dd:	89 0a                	mov    %ecx,(%edx)
    list_init(&free_list);
    nr_free = 0;
  1049df:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  1049e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
  1049ec:	90                   	nop
  1049ed:	c9                   	leave  
  1049ee:	c3                   	ret    

001049ef <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n)
{
  1049ef:	55                   	push   %ebp
  1049f0:	89 e5                	mov    %esp,%ebp
  1049f2:	53                   	push   %ebx
  1049f3:	83 ec 34             	sub    $0x34,%esp
  1049f6:	e8 bb b8 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  1049fb:	81 c3 05 66 01 00    	add    $0x16605,%ebx
    assert(n > 0);
  104a01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104a05:	75 1c                	jne    104a23 <default_init_memmap+0x34>
  104a07:	8d 83 e4 c3 fe ff    	lea    -0x13c1c(%ebx),%eax
  104a0d:	50                   	push   %eax
  104a0e:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  104a14:	50                   	push   %eax
  104a15:	6a 6f                	push   $0x6f
  104a17:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  104a1d:	50                   	push   %eax
  104a1e:	e8 b6 ba ff ff       	call   1004d9 <__panic>
    struct Page *p = base;
  104a23:	8b 45 08             	mov    0x8(%ebp),%eax
  104a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
  104a29:	eb 72                	jmp    104a9d <default_init_memmap+0xae>
    {
        assert(PageReserved(p)); // 看看这个页是不是被内核保留的
  104a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a2e:	83 c0 04             	add    $0x4,%eax
  104a31:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104a38:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104a41:	0f a3 10             	bt     %edx,(%eax)
  104a44:	19 c0                	sbb    %eax,%eax
  104a46:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  104a49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104a4d:	0f 95 c0             	setne  %al
  104a50:	0f b6 c0             	movzbl %al,%eax
  104a53:	85 c0                	test   %eax,%eax
  104a55:	75 1c                	jne    104a73 <default_init_memmap+0x84>
  104a57:	8d 83 15 c4 fe ff    	lea    -0x13beb(%ebx),%eax
  104a5d:	50                   	push   %eax
  104a5e:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  104a64:	50                   	push   %eax
  104a65:	6a 73                	push   $0x73
  104a67:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  104a6d:	50                   	push   %eax
  104a6e:	e8 66 ba ff ff       	call   1004d9 <__panic>
        p->flags = p->property = 0;
  104a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  104a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a80:	8b 50 08             	mov    0x8(%eax),%edx
  104a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a86:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  104a89:	83 ec 08             	sub    $0x8,%esp
  104a8c:	6a 00                	push   $0x0
  104a8e:	ff 75 f4             	pushl  -0xc(%ebp)
  104a91:	e8 04 ff ff ff       	call   10499a <set_page_ref>
  104a96:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p++)
  104a99:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  104aa0:	89 d0                	mov    %edx,%eax
  104aa2:	c1 e0 02             	shl    $0x2,%eax
  104aa5:	01 d0                	add    %edx,%eax
  104aa7:	c1 e0 02             	shl    $0x2,%eax
  104aaa:	89 c2                	mov    %eax,%edx
  104aac:	8b 45 08             	mov    0x8(%ebp),%eax
  104aaf:	01 d0                	add    %edx,%eax
  104ab1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104ab4:	0f 85 71 ff ff ff    	jne    104a2b <default_init_memmap+0x3c>
    }
    base->property = n; // 头一个空闲页 要设置数量
  104aba:	8b 45 08             	mov    0x8(%ebp),%eax
  104abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  104ac0:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  104ac6:	83 c0 04             	add    $0x4,%eax
  104ac9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104ad0:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104ad3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104ad6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104ad9:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  104adc:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  104ae2:	8b 50 08             	mov    0x8(%eax),%edx
  104ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  104ae8:	01 c2                	add    %eax,%edx
  104aea:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  104af0:	89 50 08             	mov    %edx,0x8(%eax)
    // 初始化玩每个空闲页后 将其要插入到链表每次都插入到节点前面 因为是按地址排序
    list_add_before(&free_list, &(base->page_link));
  104af3:	8b 45 08             	mov    0x8(%ebp),%eax
  104af6:	83 c0 0c             	add    $0xc,%eax
  104af9:	c7 c2 1c c1 11 00    	mov    $0x11c11c,%edx
  104aff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  104b02:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104b05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b08:	8b 00                	mov    (%eax),%eax
  104b0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104b0d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  104b10:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104b13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104b19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104b1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104b1f:	89 10                	mov    %edx,(%eax)
  104b21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104b24:	8b 10                	mov    (%eax),%edx
  104b26:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104b29:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104b2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b2f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104b32:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104b35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b38:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104b3b:	89 10                	mov    %edx,(%eax)
}
  104b3d:	90                   	nop
  104b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  104b41:	c9                   	leave  
  104b42:	c3                   	ret    

00104b43 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
  104b43:	55                   	push   %ebp
  104b44:	89 e5                	mov    %esp,%ebp
  104b46:	53                   	push   %ebx
  104b47:	83 ec 54             	sub    $0x54,%esp
  104b4a:	e8 63 b7 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  104b4f:	05 b1 64 01 00       	add    $0x164b1,%eax
    assert(n > 0);
  104b54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104b58:	75 21                	jne    104b7b <default_alloc_pages+0x38>
  104b5a:	8d 90 e4 c3 fe ff    	lea    -0x13c1c(%eax),%edx
  104b60:	52                   	push   %edx
  104b61:	8d 90 ea c3 fe ff    	lea    -0x13c16(%eax),%edx
  104b67:	52                   	push   %edx
  104b68:	68 81 00 00 00       	push   $0x81
  104b6d:	8d 90 ff c3 fe ff    	lea    -0x13c01(%eax),%edx
  104b73:	52                   	push   %edx
  104b74:	89 c3                	mov    %eax,%ebx
  104b76:	e8 5e b9 ff ff       	call   1004d9 <__panic>
    if (n > nr_free)
  104b7b:	c7 c2 1c c1 11 00    	mov    $0x11c11c,%edx
  104b81:	8b 52 08             	mov    0x8(%edx),%edx
  104b84:	39 55 08             	cmp    %edx,0x8(%ebp)
  104b87:	76 0a                	jbe    104b93 <default_alloc_pages+0x50>
    {
        return NULL;
  104b89:	b8 00 00 00 00       	mov    $0x0,%eax
  104b8e:	e9 55 01 00 00       	jmp    104ce8 <default_alloc_pages+0x1a5>
    }
    struct Page *page = NULL;
  104b93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  104b9a:	c7 c2 1c c1 11 00    	mov    $0x11c11c,%edx
  104ba0:	89 55 f0             	mov    %edx,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
  104ba3:	eb 1c                	jmp    104bc1 <default_alloc_pages+0x7e>
    {
        struct Page *p = le2page(le, page_link);
  104ba5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104ba8:	83 ea 0c             	sub    $0xc,%edx
  104bab:	89 55 ec             	mov    %edx,-0x14(%ebp)
        if (p->property >= n)
  104bae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104bb1:	8b 52 08             	mov    0x8(%edx),%edx
  104bb4:	39 55 08             	cmp    %edx,0x8(%ebp)
  104bb7:	77 08                	ja     104bc1 <default_alloc_pages+0x7e>
        {
            page = p;
  104bb9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104bbc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            break;
  104bbf:	eb 1a                	jmp    104bdb <default_alloc_pages+0x98>
  104bc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104bc4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return listelm->next;
  104bc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104bca:	8b 52 04             	mov    0x4(%edx),%edx
    while ((le = list_next(le)) != &free_list)
  104bcd:	89 55 f0             	mov    %edx,-0x10(%ebp)
  104bd0:	c7 c2 1c c1 11 00    	mov    $0x11c11c,%edx
  104bd6:	39 55 f0             	cmp    %edx,-0x10(%ebp)
  104bd9:	75 ca                	jne    104ba5 <default_alloc_pages+0x62>
        }
    }
    if (page != NULL)
  104bdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104bdf:	0f 84 00 01 00 00    	je     104ce5 <default_alloc_pages+0x1a2>
    {
        if (page->property > n)
  104be5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104be8:	8b 52 08             	mov    0x8(%edx),%edx
  104beb:	39 55 08             	cmp    %edx,0x8(%ebp)
  104bee:	0f 83 98 00 00 00    	jae    104c8c <default_alloc_pages+0x149>
        {
            struct Page *p = page + n;
  104bf4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  104bf7:	89 ca                	mov    %ecx,%edx
  104bf9:	c1 e2 02             	shl    $0x2,%edx
  104bfc:	01 ca                	add    %ecx,%edx
  104bfe:	c1 e2 02             	shl    $0x2,%edx
  104c01:	89 d1                	mov    %edx,%ecx
  104c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104c06:	01 ca                	add    %ecx,%edx
  104c08:	89 55 e8             	mov    %edx,-0x18(%ebp)
            p->property = page->property - n;
  104c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104c0e:	8b 52 08             	mov    0x8(%edx),%edx
  104c11:	89 d1                	mov    %edx,%ecx
  104c13:	2b 4d 08             	sub    0x8(%ebp),%ecx
  104c16:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104c19:	89 4a 08             	mov    %ecx,0x8(%edx)
            SetPageProperty(p);
  104c1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104c1f:	83 c2 04             	add    $0x4,%edx
  104c22:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  104c29:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104c2c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104c2f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104c32:	0f ab 0a             	bts    %ecx,(%edx)
            list_add(&page->page_link, &(p->page_link));
  104c35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104c38:	83 c2 0c             	add    $0xc,%edx
  104c3b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  104c3e:	83 c1 0c             	add    $0xc,%ecx
  104c41:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  104c44:	89 55 dc             	mov    %edx,-0x24(%ebp)
  104c47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104c4a:	89 55 d8             	mov    %edx,-0x28(%ebp)
  104c4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104c50:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
  104c53:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104c56:	8b 52 04             	mov    0x4(%edx),%edx
  104c59:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104c5c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  104c5f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  104c62:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  104c65:	89 55 c8             	mov    %edx,-0x38(%ebp)
    prev->next = next->prev = elm;
  104c68:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104c6b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  104c6e:	89 0a                	mov    %ecx,(%edx)
  104c70:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104c73:	8b 0a                	mov    (%edx),%ecx
  104c75:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104c78:	89 4a 04             	mov    %ecx,0x4(%edx)
    elm->next = next;
  104c7b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104c7e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  104c81:	89 4a 04             	mov    %ecx,0x4(%edx)
    elm->prev = prev;
  104c84:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104c87:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  104c8a:	89 0a                	mov    %ecx,(%edx)
        }
        list_del(&(page->page_link));
  104c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104c8f:	83 c2 0c             	add    $0xc,%edx
  104c92:	89 55 b4             	mov    %edx,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104c95:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104c98:	8b 52 04             	mov    0x4(%edx),%edx
  104c9b:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
  104c9e:	8b 09                	mov    (%ecx),%ecx
  104ca0:	89 4d b0             	mov    %ecx,-0x50(%ebp)
  104ca3:	89 55 ac             	mov    %edx,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104ca6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104ca9:	8b 4d ac             	mov    -0x54(%ebp),%ecx
  104cac:	89 4a 04             	mov    %ecx,0x4(%edx)
    next->prev = prev;
  104caf:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104cb2:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  104cb5:	89 0a                	mov    %ecx,(%edx)
        nr_free -= n;
  104cb7:	c7 c2 1c c1 11 00    	mov    $0x11c11c,%edx
  104cbd:	8b 52 08             	mov    0x8(%edx),%edx
  104cc0:	2b 55 08             	sub    0x8(%ebp),%edx
  104cc3:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  104cc9:	89 50 08             	mov    %edx,0x8(%eax)
        ClearPageProperty(page);
  104ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ccf:	83 c0 04             	add    $0x4,%eax
  104cd2:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  104cd9:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104cdc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104cdf:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104ce2:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  104ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104ce8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  104ceb:	c9                   	leave  
  104cec:	c3                   	ret    

00104ced <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
  104ced:	55                   	push   %ebp
  104cee:	89 e5                	mov    %esp,%ebp
  104cf0:	53                   	push   %ebx
  104cf1:	81 ec 84 00 00 00    	sub    $0x84,%esp
  104cf7:	e8 ba b5 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  104cfc:	81 c3 04 63 01 00    	add    $0x16304,%ebx
    assert(n > 0);
  104d02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104d06:	75 1f                	jne    104d27 <default_free_pages+0x3a>
  104d08:	8d 83 e4 c3 fe ff    	lea    -0x13c1c(%ebx),%eax
  104d0e:	50                   	push   %eax
  104d0f:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  104d15:	50                   	push   %eax
  104d16:	68 a4 00 00 00       	push   $0xa4
  104d1b:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  104d21:	50                   	push   %eax
  104d22:	e8 b2 b7 ff ff       	call   1004d9 <__panic>
    struct Page *p = base;
  104d27:	8b 45 08             	mov    0x8(%ebp),%eax
  104d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
  104d2d:	e9 95 00 00 00       	jmp    104dc7 <default_free_pages+0xda>
    {
        assert(!PageReserved(p) && !PageProperty(p));
  104d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d35:	83 c0 04             	add    $0x4,%eax
  104d38:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104d3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104d42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104d45:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104d48:	0f a3 10             	bt     %edx,(%eax)
  104d4b:	19 c0                	sbb    %eax,%eax
  104d4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  104d50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104d54:	0f 95 c0             	setne  %al
  104d57:	0f b6 c0             	movzbl %al,%eax
  104d5a:	85 c0                	test   %eax,%eax
  104d5c:	75 2c                	jne    104d8a <default_free_pages+0x9d>
  104d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d61:	83 c0 04             	add    $0x4,%eax
  104d64:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  104d6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104d6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104d74:	0f a3 10             	bt     %edx,(%eax)
  104d77:	19 c0                	sbb    %eax,%eax
  104d79:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  104d7c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  104d80:	0f 95 c0             	setne  %al
  104d83:	0f b6 c0             	movzbl %al,%eax
  104d86:	85 c0                	test   %eax,%eax
  104d88:	74 1f                	je     104da9 <default_free_pages+0xbc>
  104d8a:	8d 83 28 c4 fe ff    	lea    -0x13bd8(%ebx),%eax
  104d90:	50                   	push   %eax
  104d91:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  104d97:	50                   	push   %eax
  104d98:	68 a8 00 00 00       	push   $0xa8
  104d9d:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  104da3:	50                   	push   %eax
  104da4:	e8 30 b7 ff ff       	call   1004d9 <__panic>
        p->flags = 0;
  104da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  104db3:	83 ec 08             	sub    $0x8,%esp
  104db6:	6a 00                	push   $0x0
  104db8:	ff 75 f4             	pushl  -0xc(%ebp)
  104dbb:	e8 da fb ff ff       	call   10499a <set_page_ref>
  104dc0:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p++)
  104dc3:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  104dca:	89 d0                	mov    %edx,%eax
  104dcc:	c1 e0 02             	shl    $0x2,%eax
  104dcf:	01 d0                	add    %edx,%eax
  104dd1:	c1 e0 02             	shl    $0x2,%eax
  104dd4:	89 c2                	mov    %eax,%edx
  104dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  104dd9:	01 d0                	add    %edx,%eax
  104ddb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104dde:	0f 85 4e ff ff ff    	jne    104d32 <default_free_pages+0x45>
    }
    base->property = n;
  104de4:	8b 45 08             	mov    0x8(%ebp),%eax
  104de7:	8b 55 0c             	mov    0xc(%ebp),%edx
  104dea:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104ded:	8b 45 08             	mov    0x8(%ebp),%eax
  104df0:	83 c0 04             	add    $0x4,%eax
  104df3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104dfa:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104dfd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104e00:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104e03:	0f ab 10             	bts    %edx,(%eax)
  104e06:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  104e0c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return listelm->next;
  104e0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104e12:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  104e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 遍历freelist，合并页块
    while (le != &free_list)
  104e18:	e9 08 01 00 00       	jmp    104f25 <default_free_pages+0x238>
    {
        p = le2page(le, page_link);
  104e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e20:	83 e8 0c             	sub    $0xc,%eax
  104e23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e29:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104e2c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104e2f:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  104e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p)
  104e35:	8b 45 08             	mov    0x8(%ebp),%eax
  104e38:	8b 50 08             	mov    0x8(%eax),%edx
  104e3b:	89 d0                	mov    %edx,%eax
  104e3d:	c1 e0 02             	shl    $0x2,%eax
  104e40:	01 d0                	add    %edx,%eax
  104e42:	c1 e0 02             	shl    $0x2,%eax
  104e45:	89 c2                	mov    %eax,%edx
  104e47:	8b 45 08             	mov    0x8(%ebp),%eax
  104e4a:	01 d0                	add    %edx,%eax
  104e4c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104e4f:	75 5a                	jne    104eab <default_free_pages+0x1be>
        {
            base->property += p->property;
  104e51:	8b 45 08             	mov    0x8(%ebp),%eax
  104e54:	8b 50 08             	mov    0x8(%eax),%edx
  104e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e5a:	8b 40 08             	mov    0x8(%eax),%eax
  104e5d:	01 c2                	add    %eax,%edx
  104e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  104e62:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  104e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e68:	83 c0 04             	add    $0x4,%eax
  104e6b:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  104e72:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104e75:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104e78:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104e7b:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  104e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e81:	83 c0 0c             	add    $0xc,%eax
  104e84:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104e87:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104e8a:	8b 40 04             	mov    0x4(%eax),%eax
  104e8d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104e90:	8b 12                	mov    (%edx),%edx
  104e92:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104e95:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  104e98:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104e9b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104e9e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104ea1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104ea4:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104ea7:	89 10                	mov    %edx,(%eax)
  104ea9:	eb 7a                	jmp    104f25 <default_free_pages+0x238>
        }
        else if (p + p->property == base)
  104eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104eae:	8b 50 08             	mov    0x8(%eax),%edx
  104eb1:	89 d0                	mov    %edx,%eax
  104eb3:	c1 e0 02             	shl    $0x2,%eax
  104eb6:	01 d0                	add    %edx,%eax
  104eb8:	c1 e0 02             	shl    $0x2,%eax
  104ebb:	89 c2                	mov    %eax,%edx
  104ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ec0:	01 d0                	add    %edx,%eax
  104ec2:	39 45 08             	cmp    %eax,0x8(%ebp)
  104ec5:	75 5e                	jne    104f25 <default_free_pages+0x238>
        {
            p->property += base->property;
  104ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104eca:	8b 50 08             	mov    0x8(%eax),%edx
  104ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  104ed0:	8b 40 08             	mov    0x8(%eax),%eax
  104ed3:	01 c2                	add    %eax,%edx
  104ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ed8:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  104edb:	8b 45 08             	mov    0x8(%ebp),%eax
  104ede:	83 c0 04             	add    $0x4,%eax
  104ee1:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  104ee8:	89 45 a0             	mov    %eax,-0x60(%ebp)
  104eeb:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104eee:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104ef1:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  104ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ef7:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  104efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104efd:	83 c0 0c             	add    $0xc,%eax
  104f00:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  104f03:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104f06:	8b 40 04             	mov    0x4(%eax),%eax
  104f09:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104f0c:	8b 12                	mov    (%edx),%edx
  104f0e:	89 55 ac             	mov    %edx,-0x54(%ebp)
  104f11:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  104f14:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104f17:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104f1a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104f1d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104f20:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104f23:	89 10                	mov    %edx,(%eax)
    while (le != &free_list)
  104f25:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  104f2b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104f2e:	0f 85 e9 fe ff ff    	jne    104e1d <default_free_pages+0x130>
        }
    }
    nr_free += n;
  104f34:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  104f3a:	8b 50 08             	mov    0x8(%eax),%edx
  104f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  104f40:	01 c2                	add    %eax,%edx
  104f42:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  104f48:	89 50 08             	mov    %edx,0x8(%eax)
  104f4b:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  104f51:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
  104f54:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104f57:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
  104f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 将合并好的合适的页块添加回空闲页块链表
    while (le != &free_list)
  104f5d:	eb 34                	jmp    104f93 <default_free_pages+0x2a6>
    {
        p = le2page(le, page_link);
  104f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f62:	83 e8 0c             	sub    $0xc,%eax
  104f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p)
  104f68:	8b 45 08             	mov    0x8(%ebp),%eax
  104f6b:	8b 50 08             	mov    0x8(%eax),%edx
  104f6e:	89 d0                	mov    %edx,%eax
  104f70:	c1 e0 02             	shl    $0x2,%eax
  104f73:	01 d0                	add    %edx,%eax
  104f75:	c1 e0 02             	shl    $0x2,%eax
  104f78:	89 c2                	mov    %eax,%edx
  104f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  104f7d:	01 d0                	add    %edx,%eax
  104f7f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104f82:	73 1c                	jae    104fa0 <default_free_pages+0x2b3>
  104f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f87:	89 45 98             	mov    %eax,-0x68(%ebp)
  104f8a:	8b 45 98             	mov    -0x68(%ebp),%eax
  104f8d:	8b 40 04             	mov    0x4(%eax),%eax
        {
            break;
        }
        le = list_next(le);
  104f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list)
  104f93:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  104f99:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104f9c:	75 c1                	jne    104f5f <default_free_pages+0x272>
  104f9e:	eb 01                	jmp    104fa1 <default_free_pages+0x2b4>
            break;
  104fa0:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
  104fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  104fa4:	8d 50 0c             	lea    0xc(%eax),%edx
  104fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104faa:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104fad:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  104fb0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104fb3:	8b 00                	mov    (%eax),%eax
  104fb5:	8b 55 90             	mov    -0x70(%ebp),%edx
  104fb8:	89 55 8c             	mov    %edx,-0x74(%ebp)
  104fbb:	89 45 88             	mov    %eax,-0x78(%ebp)
  104fbe:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104fc1:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  104fc4:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104fc7:	8b 55 8c             	mov    -0x74(%ebp),%edx
  104fca:	89 10                	mov    %edx,(%eax)
  104fcc:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104fcf:	8b 10                	mov    (%eax),%edx
  104fd1:	8b 45 88             	mov    -0x78(%ebp),%eax
  104fd4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104fd7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104fda:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104fdd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104fe0:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104fe3:	8b 55 88             	mov    -0x78(%ebp),%edx
  104fe6:	89 10                	mov    %edx,(%eax)
}
  104fe8:	90                   	nop
  104fe9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  104fec:	c9                   	leave  
  104fed:	c3                   	ret    

00104fee <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
  104fee:	55                   	push   %ebp
  104fef:	89 e5                	mov    %esp,%ebp
  104ff1:	e8 bc b2 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  104ff6:	05 0a 60 01 00       	add    $0x1600a,%eax
    return nr_free;
  104ffb:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  105001:	8b 40 08             	mov    0x8(%eax),%eax
}
  105004:	5d                   	pop    %ebp
  105005:	c3                   	ret    

00105006 <basic_check>:

static void
basic_check(void)
{
  105006:	55                   	push   %ebp
  105007:	89 e5                	mov    %esp,%ebp
  105009:	53                   	push   %ebx
  10500a:	83 ec 34             	sub    $0x34,%esp
  10500d:	e8 a4 b2 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  105012:	81 c3 ee 5f 01 00    	add    $0x15fee,%ebx
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  105018:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10501f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105022:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105028:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  10502b:	83 ec 0c             	sub    $0xc,%esp
  10502e:	6a 01                	push   $0x1
  105030:	e8 55 e2 ff ff       	call   10328a <alloc_pages>
  105035:	83 c4 10             	add    $0x10,%esp
  105038:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10503b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10503f:	75 1f                	jne    105060 <basic_check+0x5a>
  105041:	8d 83 4d c4 fe ff    	lea    -0x13bb3(%ebx),%eax
  105047:	50                   	push   %eax
  105048:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  10504e:	50                   	push   %eax
  10504f:	68 dc 00 00 00       	push   $0xdc
  105054:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  10505a:	50                   	push   %eax
  10505b:	e8 79 b4 ff ff       	call   1004d9 <__panic>
    assert((p1 = alloc_page()) != NULL);
  105060:	83 ec 0c             	sub    $0xc,%esp
  105063:	6a 01                	push   $0x1
  105065:	e8 20 e2 ff ff       	call   10328a <alloc_pages>
  10506a:	83 c4 10             	add    $0x10,%esp
  10506d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105070:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105074:	75 1f                	jne    105095 <basic_check+0x8f>
  105076:	8d 83 69 c4 fe ff    	lea    -0x13b97(%ebx),%eax
  10507c:	50                   	push   %eax
  10507d:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105083:	50                   	push   %eax
  105084:	68 dd 00 00 00       	push   $0xdd
  105089:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  10508f:	50                   	push   %eax
  105090:	e8 44 b4 ff ff       	call   1004d9 <__panic>
    assert((p2 = alloc_page()) != NULL);
  105095:	83 ec 0c             	sub    $0xc,%esp
  105098:	6a 01                	push   $0x1
  10509a:	e8 eb e1 ff ff       	call   10328a <alloc_pages>
  10509f:	83 c4 10             	add    $0x10,%esp
  1050a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1050a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1050a9:	75 1f                	jne    1050ca <basic_check+0xc4>
  1050ab:	8d 83 85 c4 fe ff    	lea    -0x13b7b(%ebx),%eax
  1050b1:	50                   	push   %eax
  1050b2:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1050b8:	50                   	push   %eax
  1050b9:	68 de 00 00 00       	push   $0xde
  1050be:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  1050c4:	50                   	push   %eax
  1050c5:	e8 0f b4 ff ff       	call   1004d9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  1050ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1050cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1050d0:	74 10                	je     1050e2 <basic_check+0xdc>
  1050d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1050d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1050d8:	74 08                	je     1050e2 <basic_check+0xdc>
  1050da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1050e0:	75 1f                	jne    105101 <basic_check+0xfb>
  1050e2:	8d 83 a4 c4 fe ff    	lea    -0x13b5c(%ebx),%eax
  1050e8:	50                   	push   %eax
  1050e9:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1050ef:	50                   	push   %eax
  1050f0:	68 e0 00 00 00       	push   $0xe0
  1050f5:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  1050fb:	50                   	push   %eax
  1050fc:	e8 d8 b3 ff ff       	call   1004d9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  105101:	83 ec 0c             	sub    $0xc,%esp
  105104:	ff 75 ec             	pushl  -0x14(%ebp)
  105107:	e8 7a f8 ff ff       	call   104986 <page_ref>
  10510c:	83 c4 10             	add    $0x10,%esp
  10510f:	85 c0                	test   %eax,%eax
  105111:	75 24                	jne    105137 <basic_check+0x131>
  105113:	83 ec 0c             	sub    $0xc,%esp
  105116:	ff 75 f0             	pushl  -0x10(%ebp)
  105119:	e8 68 f8 ff ff       	call   104986 <page_ref>
  10511e:	83 c4 10             	add    $0x10,%esp
  105121:	85 c0                	test   %eax,%eax
  105123:	75 12                	jne    105137 <basic_check+0x131>
  105125:	83 ec 0c             	sub    $0xc,%esp
  105128:	ff 75 f4             	pushl  -0xc(%ebp)
  10512b:	e8 56 f8 ff ff       	call   104986 <page_ref>
  105130:	83 c4 10             	add    $0x10,%esp
  105133:	85 c0                	test   %eax,%eax
  105135:	74 1f                	je     105156 <basic_check+0x150>
  105137:	8d 83 c8 c4 fe ff    	lea    -0x13b38(%ebx),%eax
  10513d:	50                   	push   %eax
  10513e:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105144:	50                   	push   %eax
  105145:	68 e1 00 00 00       	push   $0xe1
  10514a:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105150:	50                   	push   %eax
  105151:	e8 83 b3 ff ff       	call   1004d9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  105156:	83 ec 0c             	sub    $0xc,%esp
  105159:	ff 75 ec             	pushl  -0x14(%ebp)
  10515c:	e8 08 f8 ff ff       	call   104969 <page2pa>
  105161:	83 c4 10             	add    $0x10,%esp
  105164:	89 c2                	mov    %eax,%edx
  105166:	c7 c0 20 c0 11 00    	mov    $0x11c020,%eax
  10516c:	8b 00                	mov    (%eax),%eax
  10516e:	c1 e0 0c             	shl    $0xc,%eax
  105171:	39 c2                	cmp    %eax,%edx
  105173:	72 1f                	jb     105194 <basic_check+0x18e>
  105175:	8d 83 04 c5 fe ff    	lea    -0x13afc(%ebx),%eax
  10517b:	50                   	push   %eax
  10517c:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105182:	50                   	push   %eax
  105183:	68 e3 00 00 00       	push   $0xe3
  105188:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  10518e:	50                   	push   %eax
  10518f:	e8 45 b3 ff ff       	call   1004d9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  105194:	83 ec 0c             	sub    $0xc,%esp
  105197:	ff 75 f0             	pushl  -0x10(%ebp)
  10519a:	e8 ca f7 ff ff       	call   104969 <page2pa>
  10519f:	83 c4 10             	add    $0x10,%esp
  1051a2:	89 c2                	mov    %eax,%edx
  1051a4:	c7 c0 20 c0 11 00    	mov    $0x11c020,%eax
  1051aa:	8b 00                	mov    (%eax),%eax
  1051ac:	c1 e0 0c             	shl    $0xc,%eax
  1051af:	39 c2                	cmp    %eax,%edx
  1051b1:	72 1f                	jb     1051d2 <basic_check+0x1cc>
  1051b3:	8d 83 21 c5 fe ff    	lea    -0x13adf(%ebx),%eax
  1051b9:	50                   	push   %eax
  1051ba:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1051c0:	50                   	push   %eax
  1051c1:	68 e4 00 00 00       	push   $0xe4
  1051c6:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  1051cc:	50                   	push   %eax
  1051cd:	e8 07 b3 ff ff       	call   1004d9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1051d2:	83 ec 0c             	sub    $0xc,%esp
  1051d5:	ff 75 f4             	pushl  -0xc(%ebp)
  1051d8:	e8 8c f7 ff ff       	call   104969 <page2pa>
  1051dd:	83 c4 10             	add    $0x10,%esp
  1051e0:	89 c2                	mov    %eax,%edx
  1051e2:	c7 c0 20 c0 11 00    	mov    $0x11c020,%eax
  1051e8:	8b 00                	mov    (%eax),%eax
  1051ea:	c1 e0 0c             	shl    $0xc,%eax
  1051ed:	39 c2                	cmp    %eax,%edx
  1051ef:	72 1f                	jb     105210 <basic_check+0x20a>
  1051f1:	8d 83 3e c5 fe ff    	lea    -0x13ac2(%ebx),%eax
  1051f7:	50                   	push   %eax
  1051f8:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1051fe:	50                   	push   %eax
  1051ff:	68 e5 00 00 00       	push   $0xe5
  105204:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  10520a:	50                   	push   %eax
  10520b:	e8 c9 b2 ff ff       	call   1004d9 <__panic>

    list_entry_t free_list_store = free_list;
  105210:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  105216:	8b 50 04             	mov    0x4(%eax),%edx
  105219:	8b 00                	mov    (%eax),%eax
  10521b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10521e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105221:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  105227:	89 45 dc             	mov    %eax,-0x24(%ebp)
    elm->prev = elm->next = elm;
  10522a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10522d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105230:	89 50 04             	mov    %edx,0x4(%eax)
  105233:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105236:	8b 50 04             	mov    0x4(%eax),%edx
  105239:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10523c:	89 10                	mov    %edx,(%eax)
  10523e:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  105244:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return list->next == list;
  105247:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10524a:	8b 40 04             	mov    0x4(%eax),%eax
  10524d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105250:	0f 94 c0             	sete   %al
  105253:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  105256:	85 c0                	test   %eax,%eax
  105258:	75 1f                	jne    105279 <basic_check+0x273>
  10525a:	8d 83 5b c5 fe ff    	lea    -0x13aa5(%ebx),%eax
  105260:	50                   	push   %eax
  105261:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105267:	50                   	push   %eax
  105268:	68 e9 00 00 00       	push   $0xe9
  10526d:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105273:	50                   	push   %eax
  105274:	e8 60 b2 ff ff       	call   1004d9 <__panic>

    unsigned int nr_free_store = nr_free;
  105279:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  10527f:	8b 40 08             	mov    0x8(%eax),%eax
  105282:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  105285:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  10528b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

    assert(alloc_page() == NULL);
  105292:	83 ec 0c             	sub    $0xc,%esp
  105295:	6a 01                	push   $0x1
  105297:	e8 ee df ff ff       	call   10328a <alloc_pages>
  10529c:	83 c4 10             	add    $0x10,%esp
  10529f:	85 c0                	test   %eax,%eax
  1052a1:	74 1f                	je     1052c2 <basic_check+0x2bc>
  1052a3:	8d 83 72 c5 fe ff    	lea    -0x13a8e(%ebx),%eax
  1052a9:	50                   	push   %eax
  1052aa:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1052b0:	50                   	push   %eax
  1052b1:	68 ee 00 00 00       	push   $0xee
  1052b6:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  1052bc:	50                   	push   %eax
  1052bd:	e8 17 b2 ff ff       	call   1004d9 <__panic>

    free_page(p0);
  1052c2:	83 ec 08             	sub    $0x8,%esp
  1052c5:	6a 01                	push   $0x1
  1052c7:	ff 75 ec             	pushl  -0x14(%ebp)
  1052ca:	e8 0b e0 ff ff       	call   1032da <free_pages>
  1052cf:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  1052d2:	83 ec 08             	sub    $0x8,%esp
  1052d5:	6a 01                	push   $0x1
  1052d7:	ff 75 f0             	pushl  -0x10(%ebp)
  1052da:	e8 fb df ff ff       	call   1032da <free_pages>
  1052df:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  1052e2:	83 ec 08             	sub    $0x8,%esp
  1052e5:	6a 01                	push   $0x1
  1052e7:	ff 75 f4             	pushl  -0xc(%ebp)
  1052ea:	e8 eb df ff ff       	call   1032da <free_pages>
  1052ef:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
  1052f2:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  1052f8:	8b 40 08             	mov    0x8(%eax),%eax
  1052fb:	83 f8 03             	cmp    $0x3,%eax
  1052fe:	74 1f                	je     10531f <basic_check+0x319>
  105300:	8d 83 87 c5 fe ff    	lea    -0x13a79(%ebx),%eax
  105306:	50                   	push   %eax
  105307:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  10530d:	50                   	push   %eax
  10530e:	68 f3 00 00 00       	push   $0xf3
  105313:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105319:	50                   	push   %eax
  10531a:	e8 ba b1 ff ff       	call   1004d9 <__panic>

    assert((p0 = alloc_page()) != NULL);
  10531f:	83 ec 0c             	sub    $0xc,%esp
  105322:	6a 01                	push   $0x1
  105324:	e8 61 df ff ff       	call   10328a <alloc_pages>
  105329:	83 c4 10             	add    $0x10,%esp
  10532c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10532f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  105333:	75 1f                	jne    105354 <basic_check+0x34e>
  105335:	8d 83 4d c4 fe ff    	lea    -0x13bb3(%ebx),%eax
  10533b:	50                   	push   %eax
  10533c:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105342:	50                   	push   %eax
  105343:	68 f5 00 00 00       	push   $0xf5
  105348:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  10534e:	50                   	push   %eax
  10534f:	e8 85 b1 ff ff       	call   1004d9 <__panic>
    assert((p1 = alloc_page()) != NULL);
  105354:	83 ec 0c             	sub    $0xc,%esp
  105357:	6a 01                	push   $0x1
  105359:	e8 2c df ff ff       	call   10328a <alloc_pages>
  10535e:	83 c4 10             	add    $0x10,%esp
  105361:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105364:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105368:	75 1f                	jne    105389 <basic_check+0x383>
  10536a:	8d 83 69 c4 fe ff    	lea    -0x13b97(%ebx),%eax
  105370:	50                   	push   %eax
  105371:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105377:	50                   	push   %eax
  105378:	68 f6 00 00 00       	push   $0xf6
  10537d:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105383:	50                   	push   %eax
  105384:	e8 50 b1 ff ff       	call   1004d9 <__panic>
    assert((p2 = alloc_page()) != NULL);
  105389:	83 ec 0c             	sub    $0xc,%esp
  10538c:	6a 01                	push   $0x1
  10538e:	e8 f7 de ff ff       	call   10328a <alloc_pages>
  105393:	83 c4 10             	add    $0x10,%esp
  105396:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10539d:	75 1f                	jne    1053be <basic_check+0x3b8>
  10539f:	8d 83 85 c4 fe ff    	lea    -0x13b7b(%ebx),%eax
  1053a5:	50                   	push   %eax
  1053a6:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1053ac:	50                   	push   %eax
  1053ad:	68 f7 00 00 00       	push   $0xf7
  1053b2:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  1053b8:	50                   	push   %eax
  1053b9:	e8 1b b1 ff ff       	call   1004d9 <__panic>

    assert(alloc_page() == NULL);
  1053be:	83 ec 0c             	sub    $0xc,%esp
  1053c1:	6a 01                	push   $0x1
  1053c3:	e8 c2 de ff ff       	call   10328a <alloc_pages>
  1053c8:	83 c4 10             	add    $0x10,%esp
  1053cb:	85 c0                	test   %eax,%eax
  1053cd:	74 1f                	je     1053ee <basic_check+0x3e8>
  1053cf:	8d 83 72 c5 fe ff    	lea    -0x13a8e(%ebx),%eax
  1053d5:	50                   	push   %eax
  1053d6:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1053dc:	50                   	push   %eax
  1053dd:	68 f9 00 00 00       	push   $0xf9
  1053e2:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  1053e8:	50                   	push   %eax
  1053e9:	e8 eb b0 ff ff       	call   1004d9 <__panic>

    free_page(p0);
  1053ee:	83 ec 08             	sub    $0x8,%esp
  1053f1:	6a 01                	push   $0x1
  1053f3:	ff 75 ec             	pushl  -0x14(%ebp)
  1053f6:	e8 df de ff ff       	call   1032da <free_pages>
  1053fb:	83 c4 10             	add    $0x10,%esp
  1053fe:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  105404:	89 45 d8             	mov    %eax,-0x28(%ebp)
  105407:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10540a:	8b 40 04             	mov    0x4(%eax),%eax
  10540d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  105410:	0f 94 c0             	sete   %al
  105413:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  105416:	85 c0                	test   %eax,%eax
  105418:	74 1f                	je     105439 <basic_check+0x433>
  10541a:	8d 83 94 c5 fe ff    	lea    -0x13a6c(%ebx),%eax
  105420:	50                   	push   %eax
  105421:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105427:	50                   	push   %eax
  105428:	68 fc 00 00 00       	push   $0xfc
  10542d:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105433:	50                   	push   %eax
  105434:	e8 a0 b0 ff ff       	call   1004d9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  105439:	83 ec 0c             	sub    $0xc,%esp
  10543c:	6a 01                	push   $0x1
  10543e:	e8 47 de ff ff       	call   10328a <alloc_pages>
  105443:	83 c4 10             	add    $0x10,%esp
  105446:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10544c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10544f:	74 1f                	je     105470 <basic_check+0x46a>
  105451:	8d 83 ac c5 fe ff    	lea    -0x13a54(%ebx),%eax
  105457:	50                   	push   %eax
  105458:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  10545e:	50                   	push   %eax
  10545f:	68 ff 00 00 00       	push   $0xff
  105464:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  10546a:	50                   	push   %eax
  10546b:	e8 69 b0 ff ff       	call   1004d9 <__panic>
    assert(alloc_page() == NULL);
  105470:	83 ec 0c             	sub    $0xc,%esp
  105473:	6a 01                	push   $0x1
  105475:	e8 10 de ff ff       	call   10328a <alloc_pages>
  10547a:	83 c4 10             	add    $0x10,%esp
  10547d:	85 c0                	test   %eax,%eax
  10547f:	74 1f                	je     1054a0 <basic_check+0x49a>
  105481:	8d 83 72 c5 fe ff    	lea    -0x13a8e(%ebx),%eax
  105487:	50                   	push   %eax
  105488:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  10548e:	50                   	push   %eax
  10548f:	68 00 01 00 00       	push   $0x100
  105494:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  10549a:	50                   	push   %eax
  10549b:	e8 39 b0 ff ff       	call   1004d9 <__panic>

    assert(nr_free == 0);
  1054a0:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  1054a6:	8b 40 08             	mov    0x8(%eax),%eax
  1054a9:	85 c0                	test   %eax,%eax
  1054ab:	74 1f                	je     1054cc <basic_check+0x4c6>
  1054ad:	8d 83 c5 c5 fe ff    	lea    -0x13a3b(%ebx),%eax
  1054b3:	50                   	push   %eax
  1054b4:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1054ba:	50                   	push   %eax
  1054bb:	68 02 01 00 00       	push   $0x102
  1054c0:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  1054c6:	50                   	push   %eax
  1054c7:	e8 0d b0 ff ff       	call   1004d9 <__panic>
    free_list = free_list_store;
  1054cc:	c7 c1 1c c1 11 00    	mov    $0x11c11c,%ecx
  1054d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1054d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1054d8:	89 01                	mov    %eax,(%ecx)
  1054da:	89 51 04             	mov    %edx,0x4(%ecx)
    nr_free = nr_free_store;
  1054dd:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  1054e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1054e6:	89 50 08             	mov    %edx,0x8(%eax)

    free_page(p);
  1054e9:	83 ec 08             	sub    $0x8,%esp
  1054ec:	6a 01                	push   $0x1
  1054ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  1054f1:	e8 e4 dd ff ff       	call   1032da <free_pages>
  1054f6:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  1054f9:	83 ec 08             	sub    $0x8,%esp
  1054fc:	6a 01                	push   $0x1
  1054fe:	ff 75 f0             	pushl  -0x10(%ebp)
  105501:	e8 d4 dd ff ff       	call   1032da <free_pages>
  105506:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  105509:	83 ec 08             	sub    $0x8,%esp
  10550c:	6a 01                	push   $0x1
  10550e:	ff 75 f4             	pushl  -0xc(%ebp)
  105511:	e8 c4 dd ff ff       	call   1032da <free_pages>
  105516:	83 c4 10             	add    $0x10,%esp
}
  105519:	90                   	nop
  10551a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10551d:	c9                   	leave  
  10551e:	c3                   	ret    

0010551f <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
  10551f:	55                   	push   %ebp
  105520:	89 e5                	mov    %esp,%ebp
  105522:	53                   	push   %ebx
  105523:	81 ec 84 00 00 00    	sub    $0x84,%esp
  105529:	e8 88 ad ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  10552e:	81 c3 d2 5a 01 00    	add    $0x15ad2,%ebx
    int count = 0, total = 0;
  105534:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10553b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  105542:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  105548:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
  10554b:	eb 66                	jmp    1055b3 <default_check+0x94>
    {
        struct Page *p = le2page(le, page_link);
  10554d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105550:	83 e8 0c             	sub    $0xc,%eax
  105553:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  105556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105559:	83 c0 04             	add    $0x4,%eax
  10555c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  105563:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105566:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105569:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10556c:	0f a3 10             	bt     %edx,(%eax)
  10556f:	19 c0                	sbb    %eax,%eax
  105571:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  105574:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  105578:	0f 95 c0             	setne  %al
  10557b:	0f b6 c0             	movzbl %al,%eax
  10557e:	85 c0                	test   %eax,%eax
  105580:	75 1f                	jne    1055a1 <default_check+0x82>
  105582:	8d 83 d2 c5 fe ff    	lea    -0x13a2e(%ebx),%eax
  105588:	50                   	push   %eax
  105589:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  10558f:	50                   	push   %eax
  105590:	68 15 01 00 00       	push   $0x115
  105595:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  10559b:	50                   	push   %eax
  10559c:	e8 38 af ff ff       	call   1004d9 <__panic>
        count++, total += p->property;
  1055a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1055a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1055a8:	8b 50 08             	mov    0x8(%eax),%edx
  1055ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055ae:	01 d0                	add    %edx,%eax
  1055b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1055b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1055b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  1055b9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1055bc:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  1055bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1055c2:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  1055c8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1055cb:	75 80                	jne    10554d <default_check+0x2e>
    }
    assert(total == nr_free_pages());
  1055cd:	e8 4f dd ff ff       	call   103321 <nr_free_pages>
  1055d2:	89 c2                	mov    %eax,%edx
  1055d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055d7:	39 c2                	cmp    %eax,%edx
  1055d9:	74 1f                	je     1055fa <default_check+0xdb>
  1055db:	8d 83 e2 c5 fe ff    	lea    -0x13a1e(%ebx),%eax
  1055e1:	50                   	push   %eax
  1055e2:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1055e8:	50                   	push   %eax
  1055e9:	68 18 01 00 00       	push   $0x118
  1055ee:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  1055f4:	50                   	push   %eax
  1055f5:	e8 df ae ff ff       	call   1004d9 <__panic>

    basic_check();
  1055fa:	e8 07 fa ff ff       	call   105006 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1055ff:	83 ec 0c             	sub    $0xc,%esp
  105602:	6a 05                	push   $0x5
  105604:	e8 81 dc ff ff       	call   10328a <alloc_pages>
  105609:	83 c4 10             	add    $0x10,%esp
  10560c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  10560f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105613:	75 1f                	jne    105634 <default_check+0x115>
  105615:	8d 83 fb c5 fe ff    	lea    -0x13a05(%ebx),%eax
  10561b:	50                   	push   %eax
  10561c:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105622:	50                   	push   %eax
  105623:	68 1d 01 00 00       	push   $0x11d
  105628:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  10562e:	50                   	push   %eax
  10562f:	e8 a5 ae ff ff       	call   1004d9 <__panic>
    assert(!PageProperty(p0));
  105634:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105637:	83 c0 04             	add    $0x4,%eax
  10563a:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  105641:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105644:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105647:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10564a:	0f a3 10             	bt     %edx,(%eax)
  10564d:	19 c0                	sbb    %eax,%eax
  10564f:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  105652:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  105656:	0f 95 c0             	setne  %al
  105659:	0f b6 c0             	movzbl %al,%eax
  10565c:	85 c0                	test   %eax,%eax
  10565e:	74 1f                	je     10567f <default_check+0x160>
  105660:	8d 83 06 c6 fe ff    	lea    -0x139fa(%ebx),%eax
  105666:	50                   	push   %eax
  105667:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  10566d:	50                   	push   %eax
  10566e:	68 1e 01 00 00       	push   $0x11e
  105673:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105679:	50                   	push   %eax
  10567a:	e8 5a ae ff ff       	call   1004d9 <__panic>

    list_entry_t free_list_store = free_list;
  10567f:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  105685:	8b 50 04             	mov    0x4(%eax),%edx
  105688:	8b 00                	mov    (%eax),%eax
  10568a:	89 45 80             	mov    %eax,-0x80(%ebp)
  10568d:	89 55 84             	mov    %edx,-0x7c(%ebp)
  105690:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  105696:	89 45 b0             	mov    %eax,-0x50(%ebp)
    elm->prev = elm->next = elm;
  105699:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10569c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10569f:	89 50 04             	mov    %edx,0x4(%eax)
  1056a2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1056a5:	8b 50 04             	mov    0x4(%eax),%edx
  1056a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1056ab:	89 10                	mov    %edx,(%eax)
  1056ad:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  1056b3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return list->next == list;
  1056b6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1056b9:	8b 40 04             	mov    0x4(%eax),%eax
  1056bc:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  1056bf:	0f 94 c0             	sete   %al
  1056c2:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1056c5:	85 c0                	test   %eax,%eax
  1056c7:	75 1f                	jne    1056e8 <default_check+0x1c9>
  1056c9:	8d 83 5b c5 fe ff    	lea    -0x13aa5(%ebx),%eax
  1056cf:	50                   	push   %eax
  1056d0:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1056d6:	50                   	push   %eax
  1056d7:	68 22 01 00 00       	push   $0x122
  1056dc:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  1056e2:	50                   	push   %eax
  1056e3:	e8 f1 ad ff ff       	call   1004d9 <__panic>
    assert(alloc_page() == NULL);
  1056e8:	83 ec 0c             	sub    $0xc,%esp
  1056eb:	6a 01                	push   $0x1
  1056ed:	e8 98 db ff ff       	call   10328a <alloc_pages>
  1056f2:	83 c4 10             	add    $0x10,%esp
  1056f5:	85 c0                	test   %eax,%eax
  1056f7:	74 1f                	je     105718 <default_check+0x1f9>
  1056f9:	8d 83 72 c5 fe ff    	lea    -0x13a8e(%ebx),%eax
  1056ff:	50                   	push   %eax
  105700:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105706:	50                   	push   %eax
  105707:	68 23 01 00 00       	push   $0x123
  10570c:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105712:	50                   	push   %eax
  105713:	e8 c1 ad ff ff       	call   1004d9 <__panic>

    unsigned int nr_free_store = nr_free;
  105718:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  10571e:	8b 40 08             	mov    0x8(%eax),%eax
  105721:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  105724:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  10572a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

    free_pages(p0 + 2, 3);
  105731:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105734:	83 c0 28             	add    $0x28,%eax
  105737:	83 ec 08             	sub    $0x8,%esp
  10573a:	6a 03                	push   $0x3
  10573c:	50                   	push   %eax
  10573d:	e8 98 db ff ff       	call   1032da <free_pages>
  105742:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
  105745:	83 ec 0c             	sub    $0xc,%esp
  105748:	6a 04                	push   $0x4
  10574a:	e8 3b db ff ff       	call   10328a <alloc_pages>
  10574f:	83 c4 10             	add    $0x10,%esp
  105752:	85 c0                	test   %eax,%eax
  105754:	74 1f                	je     105775 <default_check+0x256>
  105756:	8d 83 18 c6 fe ff    	lea    -0x139e8(%ebx),%eax
  10575c:	50                   	push   %eax
  10575d:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105763:	50                   	push   %eax
  105764:	68 29 01 00 00       	push   $0x129
  105769:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  10576f:	50                   	push   %eax
  105770:	e8 64 ad ff ff       	call   1004d9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  105775:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105778:	83 c0 28             	add    $0x28,%eax
  10577b:	83 c0 04             	add    $0x4,%eax
  10577e:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  105785:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105788:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10578b:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10578e:	0f a3 10             	bt     %edx,(%eax)
  105791:	19 c0                	sbb    %eax,%eax
  105793:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  105796:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10579a:	0f 95 c0             	setne  %al
  10579d:	0f b6 c0             	movzbl %al,%eax
  1057a0:	85 c0                	test   %eax,%eax
  1057a2:	74 0e                	je     1057b2 <default_check+0x293>
  1057a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057a7:	83 c0 28             	add    $0x28,%eax
  1057aa:	8b 40 08             	mov    0x8(%eax),%eax
  1057ad:	83 f8 03             	cmp    $0x3,%eax
  1057b0:	74 1f                	je     1057d1 <default_check+0x2b2>
  1057b2:	8d 83 30 c6 fe ff    	lea    -0x139d0(%ebx),%eax
  1057b8:	50                   	push   %eax
  1057b9:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1057bf:	50                   	push   %eax
  1057c0:	68 2a 01 00 00       	push   $0x12a
  1057c5:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  1057cb:	50                   	push   %eax
  1057cc:	e8 08 ad ff ff       	call   1004d9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1057d1:	83 ec 0c             	sub    $0xc,%esp
  1057d4:	6a 03                	push   $0x3
  1057d6:	e8 af da ff ff       	call   10328a <alloc_pages>
  1057db:	83 c4 10             	add    $0x10,%esp
  1057de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1057e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1057e5:	75 1f                	jne    105806 <default_check+0x2e7>
  1057e7:	8d 83 5c c6 fe ff    	lea    -0x139a4(%ebx),%eax
  1057ed:	50                   	push   %eax
  1057ee:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1057f4:	50                   	push   %eax
  1057f5:	68 2b 01 00 00       	push   $0x12b
  1057fa:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105800:	50                   	push   %eax
  105801:	e8 d3 ac ff ff       	call   1004d9 <__panic>
    assert(alloc_page() == NULL);
  105806:	83 ec 0c             	sub    $0xc,%esp
  105809:	6a 01                	push   $0x1
  10580b:	e8 7a da ff ff       	call   10328a <alloc_pages>
  105810:	83 c4 10             	add    $0x10,%esp
  105813:	85 c0                	test   %eax,%eax
  105815:	74 1f                	je     105836 <default_check+0x317>
  105817:	8d 83 72 c5 fe ff    	lea    -0x13a8e(%ebx),%eax
  10581d:	50                   	push   %eax
  10581e:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105824:	50                   	push   %eax
  105825:	68 2c 01 00 00       	push   $0x12c
  10582a:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105830:	50                   	push   %eax
  105831:	e8 a3 ac ff ff       	call   1004d9 <__panic>
    assert(p0 + 2 == p1);
  105836:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105839:	83 c0 28             	add    $0x28,%eax
  10583c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  10583f:	74 1f                	je     105860 <default_check+0x341>
  105841:	8d 83 7a c6 fe ff    	lea    -0x13986(%ebx),%eax
  105847:	50                   	push   %eax
  105848:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  10584e:	50                   	push   %eax
  10584f:	68 2d 01 00 00       	push   $0x12d
  105854:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  10585a:	50                   	push   %eax
  10585b:	e8 79 ac ff ff       	call   1004d9 <__panic>

    p2 = p0 + 1;
  105860:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105863:	83 c0 14             	add    $0x14,%eax
  105866:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  105869:	83 ec 08             	sub    $0x8,%esp
  10586c:	6a 01                	push   $0x1
  10586e:	ff 75 e8             	pushl  -0x18(%ebp)
  105871:	e8 64 da ff ff       	call   1032da <free_pages>
  105876:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
  105879:	83 ec 08             	sub    $0x8,%esp
  10587c:	6a 03                	push   $0x3
  10587e:	ff 75 e0             	pushl  -0x20(%ebp)
  105881:	e8 54 da ff ff       	call   1032da <free_pages>
  105886:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
  105889:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10588c:	83 c0 04             	add    $0x4,%eax
  10588f:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  105896:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105899:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10589c:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10589f:	0f a3 10             	bt     %edx,(%eax)
  1058a2:	19 c0                	sbb    %eax,%eax
  1058a4:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1058a7:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1058ab:	0f 95 c0             	setne  %al
  1058ae:	0f b6 c0             	movzbl %al,%eax
  1058b1:	85 c0                	test   %eax,%eax
  1058b3:	74 0b                	je     1058c0 <default_check+0x3a1>
  1058b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1058b8:	8b 40 08             	mov    0x8(%eax),%eax
  1058bb:	83 f8 01             	cmp    $0x1,%eax
  1058be:	74 1f                	je     1058df <default_check+0x3c0>
  1058c0:	8d 83 88 c6 fe ff    	lea    -0x13978(%ebx),%eax
  1058c6:	50                   	push   %eax
  1058c7:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1058cd:	50                   	push   %eax
  1058ce:	68 32 01 00 00       	push   $0x132
  1058d3:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  1058d9:	50                   	push   %eax
  1058da:	e8 fa ab ff ff       	call   1004d9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1058df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058e2:	83 c0 04             	add    $0x4,%eax
  1058e5:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1058ec:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1058ef:	8b 45 90             	mov    -0x70(%ebp),%eax
  1058f2:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1058f5:	0f a3 10             	bt     %edx,(%eax)
  1058f8:	19 c0                	sbb    %eax,%eax
  1058fa:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1058fd:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  105901:	0f 95 c0             	setne  %al
  105904:	0f b6 c0             	movzbl %al,%eax
  105907:	85 c0                	test   %eax,%eax
  105909:	74 0b                	je     105916 <default_check+0x3f7>
  10590b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10590e:	8b 40 08             	mov    0x8(%eax),%eax
  105911:	83 f8 03             	cmp    $0x3,%eax
  105914:	74 1f                	je     105935 <default_check+0x416>
  105916:	8d 83 b0 c6 fe ff    	lea    -0x13950(%ebx),%eax
  10591c:	50                   	push   %eax
  10591d:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105923:	50                   	push   %eax
  105924:	68 33 01 00 00       	push   $0x133
  105929:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  10592f:	50                   	push   %eax
  105930:	e8 a4 ab ff ff       	call   1004d9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  105935:	83 ec 0c             	sub    $0xc,%esp
  105938:	6a 01                	push   $0x1
  10593a:	e8 4b d9 ff ff       	call   10328a <alloc_pages>
  10593f:	83 c4 10             	add    $0x10,%esp
  105942:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105945:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105948:	83 e8 14             	sub    $0x14,%eax
  10594b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10594e:	74 1f                	je     10596f <default_check+0x450>
  105950:	8d 83 d6 c6 fe ff    	lea    -0x1392a(%ebx),%eax
  105956:	50                   	push   %eax
  105957:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  10595d:	50                   	push   %eax
  10595e:	68 35 01 00 00       	push   $0x135
  105963:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105969:	50                   	push   %eax
  10596a:	e8 6a ab ff ff       	call   1004d9 <__panic>
    free_page(p0);
  10596f:	83 ec 08             	sub    $0x8,%esp
  105972:	6a 01                	push   $0x1
  105974:	ff 75 e8             	pushl  -0x18(%ebp)
  105977:	e8 5e d9 ff ff       	call   1032da <free_pages>
  10597c:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10597f:	83 ec 0c             	sub    $0xc,%esp
  105982:	6a 02                	push   $0x2
  105984:	e8 01 d9 ff ff       	call   10328a <alloc_pages>
  105989:	83 c4 10             	add    $0x10,%esp
  10598c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10598f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105992:	83 c0 14             	add    $0x14,%eax
  105995:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105998:	74 1f                	je     1059b9 <default_check+0x49a>
  10599a:	8d 83 f4 c6 fe ff    	lea    -0x1390c(%ebx),%eax
  1059a0:	50                   	push   %eax
  1059a1:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1059a7:	50                   	push   %eax
  1059a8:	68 37 01 00 00       	push   $0x137
  1059ad:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  1059b3:	50                   	push   %eax
  1059b4:	e8 20 ab ff ff       	call   1004d9 <__panic>

    free_pages(p0, 2);
  1059b9:	83 ec 08             	sub    $0x8,%esp
  1059bc:	6a 02                	push   $0x2
  1059be:	ff 75 e8             	pushl  -0x18(%ebp)
  1059c1:	e8 14 d9 ff ff       	call   1032da <free_pages>
  1059c6:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  1059c9:	83 ec 08             	sub    $0x8,%esp
  1059cc:	6a 01                	push   $0x1
  1059ce:	ff 75 dc             	pushl  -0x24(%ebp)
  1059d1:	e8 04 d9 ff ff       	call   1032da <free_pages>
  1059d6:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
  1059d9:	83 ec 0c             	sub    $0xc,%esp
  1059dc:	6a 05                	push   $0x5
  1059de:	e8 a7 d8 ff ff       	call   10328a <alloc_pages>
  1059e3:	83 c4 10             	add    $0x10,%esp
  1059e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1059e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1059ed:	75 1f                	jne    105a0e <default_check+0x4ef>
  1059ef:	8d 83 14 c7 fe ff    	lea    -0x138ec(%ebx),%eax
  1059f5:	50                   	push   %eax
  1059f6:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  1059fc:	50                   	push   %eax
  1059fd:	68 3c 01 00 00       	push   $0x13c
  105a02:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105a08:	50                   	push   %eax
  105a09:	e8 cb aa ff ff       	call   1004d9 <__panic>
    assert(alloc_page() == NULL);
  105a0e:	83 ec 0c             	sub    $0xc,%esp
  105a11:	6a 01                	push   $0x1
  105a13:	e8 72 d8 ff ff       	call   10328a <alloc_pages>
  105a18:	83 c4 10             	add    $0x10,%esp
  105a1b:	85 c0                	test   %eax,%eax
  105a1d:	74 1f                	je     105a3e <default_check+0x51f>
  105a1f:	8d 83 72 c5 fe ff    	lea    -0x13a8e(%ebx),%eax
  105a25:	50                   	push   %eax
  105a26:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105a2c:	50                   	push   %eax
  105a2d:	68 3d 01 00 00       	push   $0x13d
  105a32:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105a38:	50                   	push   %eax
  105a39:	e8 9b aa ff ff       	call   1004d9 <__panic>

    assert(nr_free == 0);
  105a3e:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  105a44:	8b 40 08             	mov    0x8(%eax),%eax
  105a47:	85 c0                	test   %eax,%eax
  105a49:	74 1f                	je     105a6a <default_check+0x54b>
  105a4b:	8d 83 c5 c5 fe ff    	lea    -0x13a3b(%ebx),%eax
  105a51:	50                   	push   %eax
  105a52:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105a58:	50                   	push   %eax
  105a59:	68 3f 01 00 00       	push   $0x13f
  105a5e:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105a64:	50                   	push   %eax
  105a65:	e8 6f aa ff ff       	call   1004d9 <__panic>
    nr_free = nr_free_store;
  105a6a:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  105a70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105a73:	89 50 08             	mov    %edx,0x8(%eax)

    free_list = free_list_store;
  105a76:	c7 c1 1c c1 11 00    	mov    $0x11c11c,%ecx
  105a7c:	8b 45 80             	mov    -0x80(%ebp),%eax
  105a7f:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105a82:	89 01                	mov    %eax,(%ecx)
  105a84:	89 51 04             	mov    %edx,0x4(%ecx)
    free_pages(p0, 5);
  105a87:	83 ec 08             	sub    $0x8,%esp
  105a8a:	6a 05                	push   $0x5
  105a8c:	ff 75 e8             	pushl  -0x18(%ebp)
  105a8f:	e8 46 d8 ff ff       	call   1032da <free_pages>
  105a94:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
  105a97:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  105a9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
  105aa0:	eb 1d                	jmp    105abf <default_check+0x5a0>
    {
        struct Page *p = le2page(le, page_link);
  105aa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105aa5:	83 e8 0c             	sub    $0xc,%eax
  105aa8:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
  105aab:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  105aaf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105ab2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105ab5:	8b 40 08             	mov    0x8(%eax),%eax
  105ab8:	29 c2                	sub    %eax,%edx
  105aba:	89 d0                	mov    %edx,%eax
  105abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ac2:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  105ac5:	8b 45 88             	mov    -0x78(%ebp),%eax
  105ac8:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  105acb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ace:	c7 c0 1c c1 11 00    	mov    $0x11c11c,%eax
  105ad4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105ad7:	75 c9                	jne    105aa2 <default_check+0x583>
    }
    assert(count == 0);
  105ad9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105add:	74 1f                	je     105afe <default_check+0x5df>
  105adf:	8d 83 32 c7 fe ff    	lea    -0x138ce(%ebx),%eax
  105ae5:	50                   	push   %eax
  105ae6:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105aec:	50                   	push   %eax
  105aed:	68 4b 01 00 00       	push   $0x14b
  105af2:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105af8:	50                   	push   %eax
  105af9:	e8 db a9 ff ff       	call   1004d9 <__panic>
    assert(total == 0);
  105afe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105b02:	74 1f                	je     105b23 <default_check+0x604>
  105b04:	8d 83 3d c7 fe ff    	lea    -0x138c3(%ebx),%eax
  105b0a:	50                   	push   %eax
  105b0b:	8d 83 ea c3 fe ff    	lea    -0x13c16(%ebx),%eax
  105b11:	50                   	push   %eax
  105b12:	68 4c 01 00 00       	push   $0x14c
  105b17:	8d 83 ff c3 fe ff    	lea    -0x13c01(%ebx),%eax
  105b1d:	50                   	push   %eax
  105b1e:	e8 b6 a9 ff ff       	call   1004d9 <__panic>
}
  105b23:	90                   	nop
  105b24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  105b27:	c9                   	leave  
  105b28:	c3                   	ret    

00105b29 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105b29:	55                   	push   %ebp
  105b2a:	89 e5                	mov    %esp,%ebp
  105b2c:	83 ec 10             	sub    $0x10,%esp
  105b2f:	e8 7e a7 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  105b34:	05 cc 54 01 00       	add    $0x154cc,%eax
    size_t cnt = 0;
  105b39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105b40:	eb 04                	jmp    105b46 <strlen+0x1d>
        cnt ++;
  105b42:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  105b46:	8b 45 08             	mov    0x8(%ebp),%eax
  105b49:	8d 50 01             	lea    0x1(%eax),%edx
  105b4c:	89 55 08             	mov    %edx,0x8(%ebp)
  105b4f:	0f b6 00             	movzbl (%eax),%eax
  105b52:	84 c0                	test   %al,%al
  105b54:	75 ec                	jne    105b42 <strlen+0x19>
    }
    return cnt;
  105b56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b59:	c9                   	leave  
  105b5a:	c3                   	ret    

00105b5b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105b5b:	55                   	push   %ebp
  105b5c:	89 e5                	mov    %esp,%ebp
  105b5e:	83 ec 10             	sub    $0x10,%esp
  105b61:	e8 4c a7 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  105b66:	05 9a 54 01 00       	add    $0x1549a,%eax
    size_t cnt = 0;
  105b6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b72:	eb 04                	jmp    105b78 <strnlen+0x1d>
        cnt ++;
  105b74:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b7b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105b7e:	73 10                	jae    105b90 <strnlen+0x35>
  105b80:	8b 45 08             	mov    0x8(%ebp),%eax
  105b83:	8d 50 01             	lea    0x1(%eax),%edx
  105b86:	89 55 08             	mov    %edx,0x8(%ebp)
  105b89:	0f b6 00             	movzbl (%eax),%eax
  105b8c:	84 c0                	test   %al,%al
  105b8e:	75 e4                	jne    105b74 <strnlen+0x19>
    }
    return cnt;
  105b90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b93:	c9                   	leave  
  105b94:	c3                   	ret    

00105b95 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105b95:	55                   	push   %ebp
  105b96:	89 e5                	mov    %esp,%ebp
  105b98:	57                   	push   %edi
  105b99:	56                   	push   %esi
  105b9a:	83 ec 20             	sub    $0x20,%esp
  105b9d:	e8 10 a7 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  105ba2:	05 5e 54 01 00       	add    $0x1545e,%eax
  105ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  105baa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bad:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105bb3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bb9:	89 d1                	mov    %edx,%ecx
  105bbb:	89 c2                	mov    %eax,%edx
  105bbd:	89 ce                	mov    %ecx,%esi
  105bbf:	89 d7                	mov    %edx,%edi
  105bc1:	ac                   	lods   %ds:(%esi),%al
  105bc2:	aa                   	stos   %al,%es:(%edi)
  105bc3:	84 c0                	test   %al,%al
  105bc5:	75 fa                	jne    105bc1 <strcpy+0x2c>
  105bc7:	89 fa                	mov    %edi,%edx
  105bc9:	89 f1                	mov    %esi,%ecx
  105bcb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105bce:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105bd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  105bd7:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105bd8:	83 c4 20             	add    $0x20,%esp
  105bdb:	5e                   	pop    %esi
  105bdc:	5f                   	pop    %edi
  105bdd:	5d                   	pop    %ebp
  105bde:	c3                   	ret    

00105bdf <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105bdf:	55                   	push   %ebp
  105be0:	89 e5                	mov    %esp,%ebp
  105be2:	83 ec 10             	sub    $0x10,%esp
  105be5:	e8 c8 a6 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  105bea:	05 16 54 01 00       	add    $0x15416,%eax
    char *p = dst;
  105bef:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105bf5:	eb 21                	jmp    105c18 <strncpy+0x39>
        if ((*p = *src) != '\0') {
  105bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bfa:	0f b6 10             	movzbl (%eax),%edx
  105bfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c00:	88 10                	mov    %dl,(%eax)
  105c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c05:	0f b6 00             	movzbl (%eax),%eax
  105c08:	84 c0                	test   %al,%al
  105c0a:	74 04                	je     105c10 <strncpy+0x31>
            src ++;
  105c0c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105c10:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105c14:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  105c18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c1c:	75 d9                	jne    105bf7 <strncpy+0x18>
    }
    return dst;
  105c1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105c21:	c9                   	leave  
  105c22:	c3                   	ret    

00105c23 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105c23:	55                   	push   %ebp
  105c24:	89 e5                	mov    %esp,%ebp
  105c26:	57                   	push   %edi
  105c27:	56                   	push   %esi
  105c28:	83 ec 20             	sub    $0x20,%esp
  105c2b:	e8 82 a6 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  105c30:	05 d0 53 01 00       	add    $0x153d0,%eax
  105c35:	8b 45 08             	mov    0x8(%ebp),%eax
  105c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c47:	89 d1                	mov    %edx,%ecx
  105c49:	89 c2                	mov    %eax,%edx
  105c4b:	89 ce                	mov    %ecx,%esi
  105c4d:	89 d7                	mov    %edx,%edi
  105c4f:	ac                   	lods   %ds:(%esi),%al
  105c50:	ae                   	scas   %es:(%edi),%al
  105c51:	75 08                	jne    105c5b <strcmp+0x38>
  105c53:	84 c0                	test   %al,%al
  105c55:	75 f8                	jne    105c4f <strcmp+0x2c>
  105c57:	31 c0                	xor    %eax,%eax
  105c59:	eb 04                	jmp    105c5f <strcmp+0x3c>
  105c5b:	19 c0                	sbb    %eax,%eax
  105c5d:	0c 01                	or     $0x1,%al
  105c5f:	89 fa                	mov    %edi,%edx
  105c61:	89 f1                	mov    %esi,%ecx
  105c63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c66:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105c69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  105c6f:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105c70:	83 c4 20             	add    $0x20,%esp
  105c73:	5e                   	pop    %esi
  105c74:	5f                   	pop    %edi
  105c75:	5d                   	pop    %ebp
  105c76:	c3                   	ret    

00105c77 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105c77:	55                   	push   %ebp
  105c78:	89 e5                	mov    %esp,%ebp
  105c7a:	e8 33 a6 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  105c7f:	05 81 53 01 00       	add    $0x15381,%eax
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105c84:	eb 0c                	jmp    105c92 <strncmp+0x1b>
        n --, s1 ++, s2 ++;
  105c86:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105c8a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c8e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105c92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c96:	74 1a                	je     105cb2 <strncmp+0x3b>
  105c98:	8b 45 08             	mov    0x8(%ebp),%eax
  105c9b:	0f b6 00             	movzbl (%eax),%eax
  105c9e:	84 c0                	test   %al,%al
  105ca0:	74 10                	je     105cb2 <strncmp+0x3b>
  105ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca5:	0f b6 10             	movzbl (%eax),%edx
  105ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cab:	0f b6 00             	movzbl (%eax),%eax
  105cae:	38 c2                	cmp    %al,%dl
  105cb0:	74 d4                	je     105c86 <strncmp+0xf>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105cb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cb6:	74 18                	je     105cd0 <strncmp+0x59>
  105cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  105cbb:	0f b6 00             	movzbl (%eax),%eax
  105cbe:	0f b6 d0             	movzbl %al,%edx
  105cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cc4:	0f b6 00             	movzbl (%eax),%eax
  105cc7:	0f b6 c0             	movzbl %al,%eax
  105cca:	29 c2                	sub    %eax,%edx
  105ccc:	89 d0                	mov    %edx,%eax
  105cce:	eb 05                	jmp    105cd5 <strncmp+0x5e>
  105cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105cd5:	5d                   	pop    %ebp
  105cd6:	c3                   	ret    

00105cd7 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105cd7:	55                   	push   %ebp
  105cd8:	89 e5                	mov    %esp,%ebp
  105cda:	83 ec 04             	sub    $0x4,%esp
  105cdd:	e8 d0 a5 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  105ce2:	05 1e 53 01 00       	add    $0x1531e,%eax
  105ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cea:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105ced:	eb 14                	jmp    105d03 <strchr+0x2c>
        if (*s == c) {
  105cef:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf2:	0f b6 00             	movzbl (%eax),%eax
  105cf5:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105cf8:	75 05                	jne    105cff <strchr+0x28>
            return (char *)s;
  105cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  105cfd:	eb 13                	jmp    105d12 <strchr+0x3b>
        }
        s ++;
  105cff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  105d03:	8b 45 08             	mov    0x8(%ebp),%eax
  105d06:	0f b6 00             	movzbl (%eax),%eax
  105d09:	84 c0                	test   %al,%al
  105d0b:	75 e2                	jne    105cef <strchr+0x18>
    }
    return NULL;
  105d0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105d12:	c9                   	leave  
  105d13:	c3                   	ret    

00105d14 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105d14:	55                   	push   %ebp
  105d15:	89 e5                	mov    %esp,%ebp
  105d17:	83 ec 04             	sub    $0x4,%esp
  105d1a:	e8 93 a5 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  105d1f:	05 e1 52 01 00       	add    $0x152e1,%eax
  105d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d27:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105d2a:	eb 0f                	jmp    105d3b <strfind+0x27>
        if (*s == c) {
  105d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d2f:	0f b6 00             	movzbl (%eax),%eax
  105d32:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105d35:	74 10                	je     105d47 <strfind+0x33>
            break;
        }
        s ++;
  105d37:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  105d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d3e:	0f b6 00             	movzbl (%eax),%eax
  105d41:	84 c0                	test   %al,%al
  105d43:	75 e7                	jne    105d2c <strfind+0x18>
  105d45:	eb 01                	jmp    105d48 <strfind+0x34>
            break;
  105d47:	90                   	nop
    }
    return (char *)s;
  105d48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105d4b:	c9                   	leave  
  105d4c:	c3                   	ret    

00105d4d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105d4d:	55                   	push   %ebp
  105d4e:	89 e5                	mov    %esp,%ebp
  105d50:	83 ec 10             	sub    $0x10,%esp
  105d53:	e8 5a a5 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  105d58:	05 a8 52 01 00       	add    $0x152a8,%eax
    int neg = 0;
  105d5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105d64:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105d6b:	eb 04                	jmp    105d71 <strtol+0x24>
        s ++;
  105d6d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105d71:	8b 45 08             	mov    0x8(%ebp),%eax
  105d74:	0f b6 00             	movzbl (%eax),%eax
  105d77:	3c 20                	cmp    $0x20,%al
  105d79:	74 f2                	je     105d6d <strtol+0x20>
  105d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d7e:	0f b6 00             	movzbl (%eax),%eax
  105d81:	3c 09                	cmp    $0x9,%al
  105d83:	74 e8                	je     105d6d <strtol+0x20>
    }

    // plus/minus sign
    if (*s == '+') {
  105d85:	8b 45 08             	mov    0x8(%ebp),%eax
  105d88:	0f b6 00             	movzbl (%eax),%eax
  105d8b:	3c 2b                	cmp    $0x2b,%al
  105d8d:	75 06                	jne    105d95 <strtol+0x48>
        s ++;
  105d8f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d93:	eb 15                	jmp    105daa <strtol+0x5d>
    }
    else if (*s == '-') {
  105d95:	8b 45 08             	mov    0x8(%ebp),%eax
  105d98:	0f b6 00             	movzbl (%eax),%eax
  105d9b:	3c 2d                	cmp    $0x2d,%al
  105d9d:	75 0b                	jne    105daa <strtol+0x5d>
        s ++, neg = 1;
  105d9f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105da3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105daa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105dae:	74 06                	je     105db6 <strtol+0x69>
  105db0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105db4:	75 24                	jne    105dda <strtol+0x8d>
  105db6:	8b 45 08             	mov    0x8(%ebp),%eax
  105db9:	0f b6 00             	movzbl (%eax),%eax
  105dbc:	3c 30                	cmp    $0x30,%al
  105dbe:	75 1a                	jne    105dda <strtol+0x8d>
  105dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc3:	83 c0 01             	add    $0x1,%eax
  105dc6:	0f b6 00             	movzbl (%eax),%eax
  105dc9:	3c 78                	cmp    $0x78,%al
  105dcb:	75 0d                	jne    105dda <strtol+0x8d>
        s += 2, base = 16;
  105dcd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105dd1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105dd8:	eb 2a                	jmp    105e04 <strtol+0xb7>
    }
    else if (base == 0 && s[0] == '0') {
  105dda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105dde:	75 17                	jne    105df7 <strtol+0xaa>
  105de0:	8b 45 08             	mov    0x8(%ebp),%eax
  105de3:	0f b6 00             	movzbl (%eax),%eax
  105de6:	3c 30                	cmp    $0x30,%al
  105de8:	75 0d                	jne    105df7 <strtol+0xaa>
        s ++, base = 8;
  105dea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105dee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105df5:	eb 0d                	jmp    105e04 <strtol+0xb7>
    }
    else if (base == 0) {
  105df7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105dfb:	75 07                	jne    105e04 <strtol+0xb7>
        base = 10;
  105dfd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105e04:	8b 45 08             	mov    0x8(%ebp),%eax
  105e07:	0f b6 00             	movzbl (%eax),%eax
  105e0a:	3c 2f                	cmp    $0x2f,%al
  105e0c:	7e 1b                	jle    105e29 <strtol+0xdc>
  105e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  105e11:	0f b6 00             	movzbl (%eax),%eax
  105e14:	3c 39                	cmp    $0x39,%al
  105e16:	7f 11                	jg     105e29 <strtol+0xdc>
            dig = *s - '0';
  105e18:	8b 45 08             	mov    0x8(%ebp),%eax
  105e1b:	0f b6 00             	movzbl (%eax),%eax
  105e1e:	0f be c0             	movsbl %al,%eax
  105e21:	83 e8 30             	sub    $0x30,%eax
  105e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e27:	eb 48                	jmp    105e71 <strtol+0x124>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105e29:	8b 45 08             	mov    0x8(%ebp),%eax
  105e2c:	0f b6 00             	movzbl (%eax),%eax
  105e2f:	3c 60                	cmp    $0x60,%al
  105e31:	7e 1b                	jle    105e4e <strtol+0x101>
  105e33:	8b 45 08             	mov    0x8(%ebp),%eax
  105e36:	0f b6 00             	movzbl (%eax),%eax
  105e39:	3c 7a                	cmp    $0x7a,%al
  105e3b:	7f 11                	jg     105e4e <strtol+0x101>
            dig = *s - 'a' + 10;
  105e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  105e40:	0f b6 00             	movzbl (%eax),%eax
  105e43:	0f be c0             	movsbl %al,%eax
  105e46:	83 e8 57             	sub    $0x57,%eax
  105e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e4c:	eb 23                	jmp    105e71 <strtol+0x124>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  105e51:	0f b6 00             	movzbl (%eax),%eax
  105e54:	3c 40                	cmp    $0x40,%al
  105e56:	7e 3c                	jle    105e94 <strtol+0x147>
  105e58:	8b 45 08             	mov    0x8(%ebp),%eax
  105e5b:	0f b6 00             	movzbl (%eax),%eax
  105e5e:	3c 5a                	cmp    $0x5a,%al
  105e60:	7f 32                	jg     105e94 <strtol+0x147>
            dig = *s - 'A' + 10;
  105e62:	8b 45 08             	mov    0x8(%ebp),%eax
  105e65:	0f b6 00             	movzbl (%eax),%eax
  105e68:	0f be c0             	movsbl %al,%eax
  105e6b:	83 e8 37             	sub    $0x37,%eax
  105e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e74:	3b 45 10             	cmp    0x10(%ebp),%eax
  105e77:	7d 1a                	jge    105e93 <strtol+0x146>
            break;
        }
        s ++, val = (val * base) + dig;
  105e79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105e7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e80:	0f af 45 10          	imul   0x10(%ebp),%eax
  105e84:	89 c2                	mov    %eax,%edx
  105e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e89:	01 d0                	add    %edx,%eax
  105e8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105e8e:	e9 71 ff ff ff       	jmp    105e04 <strtol+0xb7>
            break;
  105e93:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105e94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105e98:	74 08                	je     105ea2 <strtol+0x155>
        *endptr = (char *) s;
  105e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  105ea0:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105ea2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105ea6:	74 07                	je     105eaf <strtol+0x162>
  105ea8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105eab:	f7 d8                	neg    %eax
  105ead:	eb 03                	jmp    105eb2 <strtol+0x165>
  105eaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105eb2:	c9                   	leave  
  105eb3:	c3                   	ret    

00105eb4 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105eb4:	55                   	push   %ebp
  105eb5:	89 e5                	mov    %esp,%ebp
  105eb7:	57                   	push   %edi
  105eb8:	83 ec 24             	sub    $0x24,%esp
  105ebb:	e8 f2 a3 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  105ec0:	05 40 51 01 00       	add    $0x15140,%eax
  105ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ec8:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105ecb:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  105ed2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105ed5:	88 45 f7             	mov    %al,-0x9(%ebp)
  105ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  105edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105ede:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105ee1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105ee5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105ee8:	89 d7                	mov    %edx,%edi
  105eea:	f3 aa                	rep stos %al,%es:(%edi)
  105eec:	89 fa                	mov    %edi,%edx
  105eee:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105ef1:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105ef4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105ef7:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105ef8:	83 c4 24             	add    $0x24,%esp
  105efb:	5f                   	pop    %edi
  105efc:	5d                   	pop    %ebp
  105efd:	c3                   	ret    

00105efe <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105efe:	55                   	push   %ebp
  105eff:	89 e5                	mov    %esp,%ebp
  105f01:	57                   	push   %edi
  105f02:	56                   	push   %esi
  105f03:	53                   	push   %ebx
  105f04:	83 ec 30             	sub    $0x30,%esp
  105f07:	e8 a6 a3 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  105f0c:	05 f4 50 01 00       	add    $0x150f4,%eax
  105f11:	8b 45 08             	mov    0x8(%ebp),%eax
  105f14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  105f20:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f26:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105f29:	73 42                	jae    105f6d <memmove+0x6f>
  105f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f34:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105f37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f3a:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105f3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105f40:	c1 e8 02             	shr    $0x2,%eax
  105f43:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105f45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f4b:	89 d7                	mov    %edx,%edi
  105f4d:	89 c6                	mov    %eax,%esi
  105f4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f51:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105f54:	83 e1 03             	and    $0x3,%ecx
  105f57:	74 02                	je     105f5b <memmove+0x5d>
  105f59:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f5b:	89 f0                	mov    %esi,%eax
  105f5d:	89 fa                	mov    %edi,%edx
  105f5f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105f62:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105f65:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105f68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  105f6b:	eb 36                	jmp    105fa3 <memmove+0xa5>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105f6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f70:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f76:	01 c2                	add    %eax,%edx
  105f78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f7b:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f81:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105f84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f87:	89 c1                	mov    %eax,%ecx
  105f89:	89 d8                	mov    %ebx,%eax
  105f8b:	89 d6                	mov    %edx,%esi
  105f8d:	89 c7                	mov    %eax,%edi
  105f8f:	fd                   	std    
  105f90:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f92:	fc                   	cld    
  105f93:	89 f8                	mov    %edi,%eax
  105f95:	89 f2                	mov    %esi,%edx
  105f97:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105f9a:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105f9d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105fa3:	83 c4 30             	add    $0x30,%esp
  105fa6:	5b                   	pop    %ebx
  105fa7:	5e                   	pop    %esi
  105fa8:	5f                   	pop    %edi
  105fa9:	5d                   	pop    %ebp
  105faa:	c3                   	ret    

00105fab <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105fab:	55                   	push   %ebp
  105fac:	89 e5                	mov    %esp,%ebp
  105fae:	57                   	push   %edi
  105faf:	56                   	push   %esi
  105fb0:	83 ec 20             	sub    $0x20,%esp
  105fb3:	e8 fa a2 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  105fb8:	05 48 50 01 00       	add    $0x15048,%eax
  105fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  105fc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  105fcc:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105fcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105fd2:	c1 e8 02             	shr    $0x2,%eax
  105fd5:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105fd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fdd:	89 d7                	mov    %edx,%edi
  105fdf:	89 c6                	mov    %eax,%esi
  105fe1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105fe3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105fe6:	83 e1 03             	and    $0x3,%ecx
  105fe9:	74 02                	je     105fed <memcpy+0x42>
  105feb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105fed:	89 f0                	mov    %esi,%eax
  105fef:	89 fa                	mov    %edi,%edx
  105ff1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105ff4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105ff7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  105ffd:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105ffe:	83 c4 20             	add    $0x20,%esp
  106001:	5e                   	pop    %esi
  106002:	5f                   	pop    %edi
  106003:	5d                   	pop    %ebp
  106004:	c3                   	ret    

00106005 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  106005:	55                   	push   %ebp
  106006:	89 e5                	mov    %esp,%ebp
  106008:	83 ec 10             	sub    $0x10,%esp
  10600b:	e8 a2 a2 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  106010:	05 f0 4f 01 00       	add    $0x14ff0,%eax
    const char *s1 = (const char *)v1;
  106015:	8b 45 08             	mov    0x8(%ebp),%eax
  106018:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10601b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10601e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  106021:	eb 30                	jmp    106053 <memcmp+0x4e>
        if (*s1 != *s2) {
  106023:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106026:	0f b6 10             	movzbl (%eax),%edx
  106029:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10602c:	0f b6 00             	movzbl (%eax),%eax
  10602f:	38 c2                	cmp    %al,%dl
  106031:	74 18                	je     10604b <memcmp+0x46>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  106033:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106036:	0f b6 00             	movzbl (%eax),%eax
  106039:	0f b6 d0             	movzbl %al,%edx
  10603c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10603f:	0f b6 00             	movzbl (%eax),%eax
  106042:	0f b6 c0             	movzbl %al,%eax
  106045:	29 c2                	sub    %eax,%edx
  106047:	89 d0                	mov    %edx,%eax
  106049:	eb 1a                	jmp    106065 <memcmp+0x60>
        }
        s1 ++, s2 ++;
  10604b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10604f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  106053:	8b 45 10             	mov    0x10(%ebp),%eax
  106056:	8d 50 ff             	lea    -0x1(%eax),%edx
  106059:	89 55 10             	mov    %edx,0x10(%ebp)
  10605c:	85 c0                	test   %eax,%eax
  10605e:	75 c3                	jne    106023 <memcmp+0x1e>
    }
    return 0;
  106060:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106065:	c9                   	leave  
  106066:	c3                   	ret    

00106067 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  106067:	55                   	push   %ebp
  106068:	89 e5                	mov    %esp,%ebp
  10606a:	53                   	push   %ebx
  10606b:	83 ec 34             	sub    $0x34,%esp
  10606e:	e8 43 a2 ff ff       	call   1002b6 <__x86.get_pc_thunk.bx>
  106073:	81 c3 8d 4f 01 00    	add    $0x14f8d,%ebx
  106079:	8b 45 10             	mov    0x10(%ebp),%eax
  10607c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10607f:	8b 45 14             	mov    0x14(%ebp),%eax
  106082:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  106085:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106088:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10608b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10608e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  106091:	8b 45 18             	mov    0x18(%ebp),%eax
  106094:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106097:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10609a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10609d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1060a0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1060a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1060a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1060ad:	74 1c                	je     1060cb <printnum+0x64>
  1060af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060b2:	ba 00 00 00 00       	mov    $0x0,%edx
  1060b7:	f7 75 e4             	divl   -0x1c(%ebp)
  1060ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1060bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060c0:	ba 00 00 00 00       	mov    $0x0,%edx
  1060c5:	f7 75 e4             	divl   -0x1c(%ebp)
  1060c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1060cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1060ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1060d1:	f7 75 e4             	divl   -0x1c(%ebp)
  1060d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1060d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1060da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1060dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1060e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1060e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1060e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1060e9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1060ec:	8b 45 18             	mov    0x18(%ebp),%eax
  1060ef:	ba 00 00 00 00       	mov    $0x0,%edx
  1060f4:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  1060f7:	72 41                	jb     10613a <printnum+0xd3>
  1060f9:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  1060fc:	77 05                	ja     106103 <printnum+0x9c>
  1060fe:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  106101:	72 37                	jb     10613a <printnum+0xd3>
        printnum(putch, putdat, result, base, width - 1, padc);
  106103:	8b 45 1c             	mov    0x1c(%ebp),%eax
  106106:	83 e8 01             	sub    $0x1,%eax
  106109:	83 ec 04             	sub    $0x4,%esp
  10610c:	ff 75 20             	pushl  0x20(%ebp)
  10610f:	50                   	push   %eax
  106110:	ff 75 18             	pushl  0x18(%ebp)
  106113:	ff 75 ec             	pushl  -0x14(%ebp)
  106116:	ff 75 e8             	pushl  -0x18(%ebp)
  106119:	ff 75 0c             	pushl  0xc(%ebp)
  10611c:	ff 75 08             	pushl  0x8(%ebp)
  10611f:	e8 43 ff ff ff       	call   106067 <printnum>
  106124:	83 c4 20             	add    $0x20,%esp
  106127:	eb 1b                	jmp    106144 <printnum+0xdd>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  106129:	83 ec 08             	sub    $0x8,%esp
  10612c:	ff 75 0c             	pushl  0xc(%ebp)
  10612f:	ff 75 20             	pushl  0x20(%ebp)
  106132:	8b 45 08             	mov    0x8(%ebp),%eax
  106135:	ff d0                	call   *%eax
  106137:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  10613a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10613e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  106142:	7f e5                	jg     106129 <printnum+0xc2>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  106144:	8d 93 be c7 fe ff    	lea    -0x13842(%ebx),%edx
  10614a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10614d:	01 d0                	add    %edx,%eax
  10614f:	0f b6 00             	movzbl (%eax),%eax
  106152:	0f be c0             	movsbl %al,%eax
  106155:	83 ec 08             	sub    $0x8,%esp
  106158:	ff 75 0c             	pushl  0xc(%ebp)
  10615b:	50                   	push   %eax
  10615c:	8b 45 08             	mov    0x8(%ebp),%eax
  10615f:	ff d0                	call   *%eax
  106161:	83 c4 10             	add    $0x10,%esp
}
  106164:	90                   	nop
  106165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  106168:	c9                   	leave  
  106169:	c3                   	ret    

0010616a <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10616a:	55                   	push   %ebp
  10616b:	89 e5                	mov    %esp,%ebp
  10616d:	e8 40 a1 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  106172:	05 8e 4e 01 00       	add    $0x14e8e,%eax
    if (lflag >= 2) {
  106177:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10617b:	7e 14                	jle    106191 <getuint+0x27>
        return va_arg(*ap, unsigned long long);
  10617d:	8b 45 08             	mov    0x8(%ebp),%eax
  106180:	8b 00                	mov    (%eax),%eax
  106182:	8d 48 08             	lea    0x8(%eax),%ecx
  106185:	8b 55 08             	mov    0x8(%ebp),%edx
  106188:	89 0a                	mov    %ecx,(%edx)
  10618a:	8b 50 04             	mov    0x4(%eax),%edx
  10618d:	8b 00                	mov    (%eax),%eax
  10618f:	eb 30                	jmp    1061c1 <getuint+0x57>
    }
    else if (lflag) {
  106191:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106195:	74 16                	je     1061ad <getuint+0x43>
        return va_arg(*ap, unsigned long);
  106197:	8b 45 08             	mov    0x8(%ebp),%eax
  10619a:	8b 00                	mov    (%eax),%eax
  10619c:	8d 48 04             	lea    0x4(%eax),%ecx
  10619f:	8b 55 08             	mov    0x8(%ebp),%edx
  1061a2:	89 0a                	mov    %ecx,(%edx)
  1061a4:	8b 00                	mov    (%eax),%eax
  1061a6:	ba 00 00 00 00       	mov    $0x0,%edx
  1061ab:	eb 14                	jmp    1061c1 <getuint+0x57>
    }
    else {
        return va_arg(*ap, unsigned int);
  1061ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1061b0:	8b 00                	mov    (%eax),%eax
  1061b2:	8d 48 04             	lea    0x4(%eax),%ecx
  1061b5:	8b 55 08             	mov    0x8(%ebp),%edx
  1061b8:	89 0a                	mov    %ecx,(%edx)
  1061ba:	8b 00                	mov    (%eax),%eax
  1061bc:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1061c1:	5d                   	pop    %ebp
  1061c2:	c3                   	ret    

001061c3 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1061c3:	55                   	push   %ebp
  1061c4:	89 e5                	mov    %esp,%ebp
  1061c6:	e8 e7 a0 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  1061cb:	05 35 4e 01 00       	add    $0x14e35,%eax
    if (lflag >= 2) {
  1061d0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1061d4:	7e 14                	jle    1061ea <getint+0x27>
        return va_arg(*ap, long long);
  1061d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1061d9:	8b 00                	mov    (%eax),%eax
  1061db:	8d 48 08             	lea    0x8(%eax),%ecx
  1061de:	8b 55 08             	mov    0x8(%ebp),%edx
  1061e1:	89 0a                	mov    %ecx,(%edx)
  1061e3:	8b 50 04             	mov    0x4(%eax),%edx
  1061e6:	8b 00                	mov    (%eax),%eax
  1061e8:	eb 28                	jmp    106212 <getint+0x4f>
    }
    else if (lflag) {
  1061ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1061ee:	74 12                	je     106202 <getint+0x3f>
        return va_arg(*ap, long);
  1061f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1061f3:	8b 00                	mov    (%eax),%eax
  1061f5:	8d 48 04             	lea    0x4(%eax),%ecx
  1061f8:	8b 55 08             	mov    0x8(%ebp),%edx
  1061fb:	89 0a                	mov    %ecx,(%edx)
  1061fd:	8b 00                	mov    (%eax),%eax
  1061ff:	99                   	cltd   
  106200:	eb 10                	jmp    106212 <getint+0x4f>
    }
    else {
        return va_arg(*ap, int);
  106202:	8b 45 08             	mov    0x8(%ebp),%eax
  106205:	8b 00                	mov    (%eax),%eax
  106207:	8d 48 04             	lea    0x4(%eax),%ecx
  10620a:	8b 55 08             	mov    0x8(%ebp),%edx
  10620d:	89 0a                	mov    %ecx,(%edx)
  10620f:	8b 00                	mov    (%eax),%eax
  106211:	99                   	cltd   
    }
}
  106212:	5d                   	pop    %ebp
  106213:	c3                   	ret    

00106214 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  106214:	55                   	push   %ebp
  106215:	89 e5                	mov    %esp,%ebp
  106217:	83 ec 18             	sub    $0x18,%esp
  10621a:	e8 93 a0 ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  10621f:	05 e1 4d 01 00       	add    $0x14de1,%eax
    va_list ap;

    va_start(ap, fmt);
  106224:	8d 45 14             	lea    0x14(%ebp),%eax
  106227:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10622a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10622d:	50                   	push   %eax
  10622e:	ff 75 10             	pushl  0x10(%ebp)
  106231:	ff 75 0c             	pushl  0xc(%ebp)
  106234:	ff 75 08             	pushl  0x8(%ebp)
  106237:	e8 06 00 00 00       	call   106242 <vprintfmt>
  10623c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10623f:	90                   	nop
  106240:	c9                   	leave  
  106241:	c3                   	ret    

00106242 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  106242:	55                   	push   %ebp
  106243:	89 e5                	mov    %esp,%ebp
  106245:	57                   	push   %edi
  106246:	56                   	push   %esi
  106247:	53                   	push   %ebx
  106248:	83 ec 2c             	sub    $0x2c,%esp
  10624b:	e8 8c 04 00 00       	call   1066dc <__x86.get_pc_thunk.di>
  106250:	81 c7 b0 4d 01 00    	add    $0x14db0,%edi
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  106256:	eb 17                	jmp    10626f <vprintfmt+0x2d>
            if (ch == '\0') {
  106258:	85 db                	test   %ebx,%ebx
  10625a:	0f 84 9a 03 00 00    	je     1065fa <.L24+0x2d>
                return;
            }
            putch(ch, putdat);
  106260:	83 ec 08             	sub    $0x8,%esp
  106263:	ff 75 0c             	pushl  0xc(%ebp)
  106266:	53                   	push   %ebx
  106267:	8b 45 08             	mov    0x8(%ebp),%eax
  10626a:	ff d0                	call   *%eax
  10626c:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10626f:	8b 45 10             	mov    0x10(%ebp),%eax
  106272:	8d 50 01             	lea    0x1(%eax),%edx
  106275:	89 55 10             	mov    %edx,0x10(%ebp)
  106278:	0f b6 00             	movzbl (%eax),%eax
  10627b:	0f b6 d8             	movzbl %al,%ebx
  10627e:	83 fb 25             	cmp    $0x25,%ebx
  106281:	75 d5                	jne    106258 <vprintfmt+0x16>
        }

        // Process a %-escape sequence
        char padc = ' ';
  106283:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
        width = precision = -1;
  106287:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  10628e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  106291:	89 45 d8             	mov    %eax,-0x28(%ebp)
        lflag = altflag = 0;
  106294:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  10629b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10629e:	89 45 d0             	mov    %eax,-0x30(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1062a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1062a4:	8d 50 01             	lea    0x1(%eax),%edx
  1062a7:	89 55 10             	mov    %edx,0x10(%ebp)
  1062aa:	0f b6 00             	movzbl (%eax),%eax
  1062ad:	0f b6 d8             	movzbl %al,%ebx
  1062b0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1062b3:	83 f8 55             	cmp    $0x55,%eax
  1062b6:	0f 87 11 03 00 00    	ja     1065cd <.L24>
  1062bc:	c1 e0 02             	shl    $0x2,%eax
  1062bf:	8b 84 38 e4 c7 fe ff 	mov    -0x1381c(%eax,%edi,1),%eax
  1062c6:	01 f8                	add    %edi,%eax
  1062c8:	ff e0                	jmp    *%eax

001062ca <.L29>:

        // flag to pad on the right
        case '-':
            padc = '-';
  1062ca:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
            goto reswitch;
  1062ce:	eb d1                	jmp    1062a1 <vprintfmt+0x5f>

001062d0 <.L31>:

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1062d0:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
            goto reswitch;
  1062d4:	eb cb                	jmp    1062a1 <vprintfmt+0x5f>

001062d6 <.L32>:

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1062d6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
                precision = precision * 10 + ch - '0';
  1062dd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1062e0:	89 d0                	mov    %edx,%eax
  1062e2:	c1 e0 02             	shl    $0x2,%eax
  1062e5:	01 d0                	add    %edx,%eax
  1062e7:	01 c0                	add    %eax,%eax
  1062e9:	01 d8                	add    %ebx,%eax
  1062eb:	83 e8 30             	sub    $0x30,%eax
  1062ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
                ch = *fmt;
  1062f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1062f4:	0f b6 00             	movzbl (%eax),%eax
  1062f7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1062fa:	83 fb 2f             	cmp    $0x2f,%ebx
  1062fd:	7e 39                	jle    106338 <.L25+0xc>
  1062ff:	83 fb 39             	cmp    $0x39,%ebx
  106302:	7f 34                	jg     106338 <.L25+0xc>
            for (precision = 0; ; ++ fmt) {
  106304:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
  106308:	eb d3                	jmp    1062dd <.L32+0x7>

0010630a <.L28>:
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10630a:	8b 45 14             	mov    0x14(%ebp),%eax
  10630d:	8d 50 04             	lea    0x4(%eax),%edx
  106310:	89 55 14             	mov    %edx,0x14(%ebp)
  106313:	8b 00                	mov    (%eax),%eax
  106315:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            goto process_precision;
  106318:	eb 1f                	jmp    106339 <.L25+0xd>

0010631a <.L30>:

        case '.':
            if (width < 0)
  10631a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  10631e:	79 81                	jns    1062a1 <vprintfmt+0x5f>
                width = 0;
  106320:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
            goto reswitch;
  106327:	e9 75 ff ff ff       	jmp    1062a1 <vprintfmt+0x5f>

0010632c <.L25>:

        case '#':
            altflag = 1;
  10632c:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
            goto reswitch;
  106333:	e9 69 ff ff ff       	jmp    1062a1 <vprintfmt+0x5f>
            goto process_precision;
  106338:	90                   	nop

        process_precision:
            if (width < 0)
  106339:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  10633d:	0f 89 5e ff ff ff    	jns    1062a1 <vprintfmt+0x5f>
                width = precision, precision = -1;
  106343:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  106346:	89 45 d8             	mov    %eax,-0x28(%ebp)
  106349:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
            goto reswitch;
  106350:	e9 4c ff ff ff       	jmp    1062a1 <vprintfmt+0x5f>

00106355 <.L36>:

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  106355:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
            goto reswitch;
  106359:	e9 43 ff ff ff       	jmp    1062a1 <vprintfmt+0x5f>

0010635e <.L33>:

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10635e:	8b 45 14             	mov    0x14(%ebp),%eax
  106361:	8d 50 04             	lea    0x4(%eax),%edx
  106364:	89 55 14             	mov    %edx,0x14(%ebp)
  106367:	8b 00                	mov    (%eax),%eax
  106369:	83 ec 08             	sub    $0x8,%esp
  10636c:	ff 75 0c             	pushl  0xc(%ebp)
  10636f:	50                   	push   %eax
  106370:	8b 45 08             	mov    0x8(%ebp),%eax
  106373:	ff d0                	call   *%eax
  106375:	83 c4 10             	add    $0x10,%esp
            break;
  106378:	e9 78 02 00 00       	jmp    1065f5 <.L24+0x28>

0010637d <.L35>:

        // error message
        case 'e':
            err = va_arg(ap, int);
  10637d:	8b 45 14             	mov    0x14(%ebp),%eax
  106380:	8d 50 04             	lea    0x4(%eax),%edx
  106383:	89 55 14             	mov    %edx,0x14(%ebp)
  106386:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  106388:	85 db                	test   %ebx,%ebx
  10638a:	79 02                	jns    10638e <.L35+0x11>
                err = -err;
  10638c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10638e:	83 fb 06             	cmp    $0x6,%ebx
  106391:	7f 0b                	jg     10639e <.L35+0x21>
  106393:	8b b4 9f 6c 01 00 00 	mov    0x16c(%edi,%ebx,4),%esi
  10639a:	85 f6                	test   %esi,%esi
  10639c:	75 1b                	jne    1063b9 <.L35+0x3c>
                printfmt(putch, putdat, "error %d", err);
  10639e:	53                   	push   %ebx
  10639f:	8d 87 cf c7 fe ff    	lea    -0x13831(%edi),%eax
  1063a5:	50                   	push   %eax
  1063a6:	ff 75 0c             	pushl  0xc(%ebp)
  1063a9:	ff 75 08             	pushl  0x8(%ebp)
  1063ac:	e8 63 fe ff ff       	call   106214 <printfmt>
  1063b1:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1063b4:	e9 3c 02 00 00       	jmp    1065f5 <.L24+0x28>
                printfmt(putch, putdat, "%s", p);
  1063b9:	56                   	push   %esi
  1063ba:	8d 87 d8 c7 fe ff    	lea    -0x13828(%edi),%eax
  1063c0:	50                   	push   %eax
  1063c1:	ff 75 0c             	pushl  0xc(%ebp)
  1063c4:	ff 75 08             	pushl  0x8(%ebp)
  1063c7:	e8 48 fe ff ff       	call   106214 <printfmt>
  1063cc:	83 c4 10             	add    $0x10,%esp
            break;
  1063cf:	e9 21 02 00 00       	jmp    1065f5 <.L24+0x28>

001063d4 <.L39>:

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1063d4:	8b 45 14             	mov    0x14(%ebp),%eax
  1063d7:	8d 50 04             	lea    0x4(%eax),%edx
  1063da:	89 55 14             	mov    %edx,0x14(%ebp)
  1063dd:	8b 30                	mov    (%eax),%esi
  1063df:	85 f6                	test   %esi,%esi
  1063e1:	75 06                	jne    1063e9 <.L39+0x15>
                p = "(null)";
  1063e3:	8d b7 db c7 fe ff    	lea    -0x13825(%edi),%esi
            }
            if (width > 0 && padc != '-') {
  1063e9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1063ed:	7e 78                	jle    106467 <.L39+0x93>
  1063ef:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  1063f3:	74 72                	je     106467 <.L39+0x93>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1063f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1063f8:	83 ec 08             	sub    $0x8,%esp
  1063fb:	50                   	push   %eax
  1063fc:	56                   	push   %esi
  1063fd:	89 fb                	mov    %edi,%ebx
  1063ff:	e8 57 f7 ff ff       	call   105b5b <strnlen>
  106404:	83 c4 10             	add    $0x10,%esp
  106407:	89 c2                	mov    %eax,%edx
  106409:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10640c:	29 d0                	sub    %edx,%eax
  10640e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  106411:	eb 17                	jmp    10642a <.L39+0x56>
                    putch(padc, putdat);
  106413:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  106417:	83 ec 08             	sub    $0x8,%esp
  10641a:	ff 75 0c             	pushl  0xc(%ebp)
  10641d:	50                   	push   %eax
  10641e:	8b 45 08             	mov    0x8(%ebp),%eax
  106421:	ff d0                	call   *%eax
  106423:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  106426:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  10642a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  10642e:	7f e3                	jg     106413 <.L39+0x3f>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106430:	eb 35                	jmp    106467 <.L39+0x93>
                if (altflag && (ch < ' ' || ch > '~')) {
  106432:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  106436:	74 1c                	je     106454 <.L39+0x80>
  106438:	83 fb 1f             	cmp    $0x1f,%ebx
  10643b:	7e 05                	jle    106442 <.L39+0x6e>
  10643d:	83 fb 7e             	cmp    $0x7e,%ebx
  106440:	7e 12                	jle    106454 <.L39+0x80>
                    putch('?', putdat);
  106442:	83 ec 08             	sub    $0x8,%esp
  106445:	ff 75 0c             	pushl  0xc(%ebp)
  106448:	6a 3f                	push   $0x3f
  10644a:	8b 45 08             	mov    0x8(%ebp),%eax
  10644d:	ff d0                	call   *%eax
  10644f:	83 c4 10             	add    $0x10,%esp
  106452:	eb 0f                	jmp    106463 <.L39+0x8f>
                }
                else {
                    putch(ch, putdat);
  106454:	83 ec 08             	sub    $0x8,%esp
  106457:	ff 75 0c             	pushl  0xc(%ebp)
  10645a:	53                   	push   %ebx
  10645b:	8b 45 08             	mov    0x8(%ebp),%eax
  10645e:	ff d0                	call   *%eax
  106460:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106463:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  106467:	89 f0                	mov    %esi,%eax
  106469:	8d 70 01             	lea    0x1(%eax),%esi
  10646c:	0f b6 00             	movzbl (%eax),%eax
  10646f:	0f be d8             	movsbl %al,%ebx
  106472:	85 db                	test   %ebx,%ebx
  106474:	74 26                	je     10649c <.L39+0xc8>
  106476:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  10647a:	78 b6                	js     106432 <.L39+0x5e>
  10647c:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  106480:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  106484:	79 ac                	jns    106432 <.L39+0x5e>
                }
            }
            for (; width > 0; width --) {
  106486:	eb 14                	jmp    10649c <.L39+0xc8>
                putch(' ', putdat);
  106488:	83 ec 08             	sub    $0x8,%esp
  10648b:	ff 75 0c             	pushl  0xc(%ebp)
  10648e:	6a 20                	push   $0x20
  106490:	8b 45 08             	mov    0x8(%ebp),%eax
  106493:	ff d0                	call   *%eax
  106495:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  106498:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  10649c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1064a0:	7f e6                	jg     106488 <.L39+0xb4>
            }
            break;
  1064a2:	e9 4e 01 00 00       	jmp    1065f5 <.L24+0x28>

001064a7 <.L34>:

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1064a7:	83 ec 08             	sub    $0x8,%esp
  1064aa:	ff 75 d0             	pushl  -0x30(%ebp)
  1064ad:	8d 45 14             	lea    0x14(%ebp),%eax
  1064b0:	50                   	push   %eax
  1064b1:	e8 0d fd ff ff       	call   1061c3 <getint>
  1064b6:	83 c4 10             	add    $0x10,%esp
  1064b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1064bc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            if ((long long)num < 0) {
  1064bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1064c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1064c5:	85 d2                	test   %edx,%edx
  1064c7:	79 23                	jns    1064ec <.L34+0x45>
                putch('-', putdat);
  1064c9:	83 ec 08             	sub    $0x8,%esp
  1064cc:	ff 75 0c             	pushl  0xc(%ebp)
  1064cf:	6a 2d                	push   $0x2d
  1064d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1064d4:	ff d0                	call   *%eax
  1064d6:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  1064d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1064dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1064df:	f7 d8                	neg    %eax
  1064e1:	83 d2 00             	adc    $0x0,%edx
  1064e4:	f7 da                	neg    %edx
  1064e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1064e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            }
            base = 10;
  1064ec:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
  1064f3:	e9 9f 00 00 00       	jmp    106597 <.L41+0x1f>

001064f8 <.L40>:

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1064f8:	83 ec 08             	sub    $0x8,%esp
  1064fb:	ff 75 d0             	pushl  -0x30(%ebp)
  1064fe:	8d 45 14             	lea    0x14(%ebp),%eax
  106501:	50                   	push   %eax
  106502:	e8 63 fc ff ff       	call   10616a <getuint>
  106507:	83 c4 10             	add    $0x10,%esp
  10650a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10650d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 10;
  106510:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
  106517:	eb 7e                	jmp    106597 <.L41+0x1f>

00106519 <.L37>:

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  106519:	83 ec 08             	sub    $0x8,%esp
  10651c:	ff 75 d0             	pushl  -0x30(%ebp)
  10651f:	8d 45 14             	lea    0x14(%ebp),%eax
  106522:	50                   	push   %eax
  106523:	e8 42 fc ff ff       	call   10616a <getuint>
  106528:	83 c4 10             	add    $0x10,%esp
  10652b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10652e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 8;
  106531:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
            goto number;
  106538:	eb 5d                	jmp    106597 <.L41+0x1f>

0010653a <.L38>:

        // pointer
        case 'p':
            putch('0', putdat);
  10653a:	83 ec 08             	sub    $0x8,%esp
  10653d:	ff 75 0c             	pushl  0xc(%ebp)
  106540:	6a 30                	push   $0x30
  106542:	8b 45 08             	mov    0x8(%ebp),%eax
  106545:	ff d0                	call   *%eax
  106547:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  10654a:	83 ec 08             	sub    $0x8,%esp
  10654d:	ff 75 0c             	pushl  0xc(%ebp)
  106550:	6a 78                	push   $0x78
  106552:	8b 45 08             	mov    0x8(%ebp),%eax
  106555:	ff d0                	call   *%eax
  106557:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10655a:	8b 45 14             	mov    0x14(%ebp),%eax
  10655d:	8d 50 04             	lea    0x4(%eax),%edx
  106560:	89 55 14             	mov    %edx,0x14(%ebp)
  106563:	8b 00                	mov    (%eax),%eax
  106565:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106568:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            base = 16;
  10656f:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
            goto number;
  106576:	eb 1f                	jmp    106597 <.L41+0x1f>

00106578 <.L41>:

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  106578:	83 ec 08             	sub    $0x8,%esp
  10657b:	ff 75 d0             	pushl  -0x30(%ebp)
  10657e:	8d 45 14             	lea    0x14(%ebp),%eax
  106581:	50                   	push   %eax
  106582:	e8 e3 fb ff ff       	call   10616a <getuint>
  106587:	83 c4 10             	add    $0x10,%esp
  10658a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10658d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 16;
  106590:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  106597:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  10659b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10659e:	83 ec 04             	sub    $0x4,%esp
  1065a1:	52                   	push   %edx
  1065a2:	ff 75 d8             	pushl  -0x28(%ebp)
  1065a5:	50                   	push   %eax
  1065a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  1065a9:	ff 75 e0             	pushl  -0x20(%ebp)
  1065ac:	ff 75 0c             	pushl  0xc(%ebp)
  1065af:	ff 75 08             	pushl  0x8(%ebp)
  1065b2:	e8 b0 fa ff ff       	call   106067 <printnum>
  1065b7:	83 c4 20             	add    $0x20,%esp
            break;
  1065ba:	eb 39                	jmp    1065f5 <.L24+0x28>

001065bc <.L27>:

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1065bc:	83 ec 08             	sub    $0x8,%esp
  1065bf:	ff 75 0c             	pushl  0xc(%ebp)
  1065c2:	53                   	push   %ebx
  1065c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1065c6:	ff d0                	call   *%eax
  1065c8:	83 c4 10             	add    $0x10,%esp
            break;
  1065cb:	eb 28                	jmp    1065f5 <.L24+0x28>

001065cd <.L24>:

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1065cd:	83 ec 08             	sub    $0x8,%esp
  1065d0:	ff 75 0c             	pushl  0xc(%ebp)
  1065d3:	6a 25                	push   $0x25
  1065d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1065d8:	ff d0                	call   *%eax
  1065da:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  1065dd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1065e1:	eb 04                	jmp    1065e7 <.L24+0x1a>
  1065e3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1065e7:	8b 45 10             	mov    0x10(%ebp),%eax
  1065ea:	83 e8 01             	sub    $0x1,%eax
  1065ed:	0f b6 00             	movzbl (%eax),%eax
  1065f0:	3c 25                	cmp    $0x25,%al
  1065f2:	75 ef                	jne    1065e3 <.L24+0x16>
                /* do nothing */;
            break;
  1065f4:	90                   	nop
    while (1) {
  1065f5:	e9 5c fc ff ff       	jmp    106256 <vprintfmt+0x14>
                return;
  1065fa:	90                   	nop
        }
    }
}
  1065fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1065fe:	5b                   	pop    %ebx
  1065ff:	5e                   	pop    %esi
  106600:	5f                   	pop    %edi
  106601:	5d                   	pop    %ebp
  106602:	c3                   	ret    

00106603 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  106603:	55                   	push   %ebp
  106604:	89 e5                	mov    %esp,%ebp
  106606:	e8 a7 9c ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  10660b:	05 f5 49 01 00       	add    $0x149f5,%eax
    b->cnt ++;
  106610:	8b 45 0c             	mov    0xc(%ebp),%eax
  106613:	8b 40 08             	mov    0x8(%eax),%eax
  106616:	8d 50 01             	lea    0x1(%eax),%edx
  106619:	8b 45 0c             	mov    0xc(%ebp),%eax
  10661c:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10661f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106622:	8b 10                	mov    (%eax),%edx
  106624:	8b 45 0c             	mov    0xc(%ebp),%eax
  106627:	8b 40 04             	mov    0x4(%eax),%eax
  10662a:	39 c2                	cmp    %eax,%edx
  10662c:	73 12                	jae    106640 <sprintputch+0x3d>
        *b->buf ++ = ch;
  10662e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106631:	8b 00                	mov    (%eax),%eax
  106633:	8d 48 01             	lea    0x1(%eax),%ecx
  106636:	8b 55 0c             	mov    0xc(%ebp),%edx
  106639:	89 0a                	mov    %ecx,(%edx)
  10663b:	8b 55 08             	mov    0x8(%ebp),%edx
  10663e:	88 10                	mov    %dl,(%eax)
    }
}
  106640:	90                   	nop
  106641:	5d                   	pop    %ebp
  106642:	c3                   	ret    

00106643 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  106643:	55                   	push   %ebp
  106644:	89 e5                	mov    %esp,%ebp
  106646:	83 ec 18             	sub    $0x18,%esp
  106649:	e8 64 9c ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  10664e:	05 b2 49 01 00       	add    $0x149b2,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  106653:	8d 45 14             	lea    0x14(%ebp),%eax
  106656:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  106659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10665c:	50                   	push   %eax
  10665d:	ff 75 10             	pushl  0x10(%ebp)
  106660:	ff 75 0c             	pushl  0xc(%ebp)
  106663:	ff 75 08             	pushl  0x8(%ebp)
  106666:	e8 0b 00 00 00       	call   106676 <vsnprintf>
  10666b:	83 c4 10             	add    $0x10,%esp
  10666e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  106671:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106674:	c9                   	leave  
  106675:	c3                   	ret    

00106676 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  106676:	55                   	push   %ebp
  106677:	89 e5                	mov    %esp,%ebp
  106679:	83 ec 18             	sub    $0x18,%esp
  10667c:	e8 31 9c ff ff       	call   1002b2 <__x86.get_pc_thunk.ax>
  106681:	05 7f 49 01 00       	add    $0x1497f,%eax
    struct sprintbuf b = {str, str + size - 1, 0};
  106686:	8b 55 08             	mov    0x8(%ebp),%edx
  106689:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10668c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10668f:	8d 4a ff             	lea    -0x1(%edx),%ecx
  106692:	8b 55 08             	mov    0x8(%ebp),%edx
  106695:	01 ca                	add    %ecx,%edx
  106697:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10669a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1066a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1066a5:	74 0a                	je     1066b1 <vsnprintf+0x3b>
  1066a7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1066aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1066ad:	39 d1                	cmp    %edx,%ecx
  1066af:	76 07                	jbe    1066b8 <vsnprintf+0x42>
        return -E_INVAL;
  1066b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1066b6:	eb 22                	jmp    1066da <vsnprintf+0x64>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1066b8:	ff 75 14             	pushl  0x14(%ebp)
  1066bb:	ff 75 10             	pushl  0x10(%ebp)
  1066be:	8d 55 ec             	lea    -0x14(%ebp),%edx
  1066c1:	52                   	push   %edx
  1066c2:	8d 80 03 b6 fe ff    	lea    -0x149fd(%eax),%eax
  1066c8:	50                   	push   %eax
  1066c9:	e8 74 fb ff ff       	call   106242 <vprintfmt>
  1066ce:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  1066d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1066d4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1066d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1066da:	c9                   	leave  
  1066db:	c3                   	ret    

001066dc <__x86.get_pc_thunk.di>:
  1066dc:	8b 3c 24             	mov    (%esp),%edi
  1066df:	c3                   	ret    
