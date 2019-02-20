
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 90 11 00       	mov    $0x119000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 90 11 c0       	mov    %eax,0xc0119000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 80 11 c0       	mov    $0xc0118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));

static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	53                   	push   %ebx
c010003a:	83 ec 14             	sub    $0x14,%esp
c010003d:	e8 74 02 00 00       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0100042:	81 c3 0e 89 01 00    	add    $0x1890e,%ebx
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100048:	c7 c0 28 bf 11 c0    	mov    $0xc011bf28,%eax
c010004e:	89 c2                	mov    %eax,%edx
c0100050:	c7 c0 00 b0 11 c0    	mov    $0xc011b000,%eax
c0100056:	29 c2                	sub    %eax,%edx
c0100058:	89 d0                	mov    %edx,%eax
c010005a:	83 ec 04             	sub    $0x4,%esp
c010005d:	50                   	push   %eax
c010005e:	6a 00                	push   $0x0
c0100060:	c7 c0 00 b0 11 c0    	mov    $0xc011b000,%eax
c0100066:	50                   	push   %eax
c0100067:	e8 a3 5c 00 00       	call   c0105d0f <memset>
c010006c:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c010006f:	e8 96 18 00 00       	call   c010190a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100074:	8d 83 ec db fe ff    	lea    -0x12414(%ebx),%eax
c010007a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010007d:	83 ec 08             	sub    $0x8,%esp
c0100080:	ff 75 f4             	pushl  -0xc(%ebp)
c0100083:	8d 83 08 dc fe ff    	lea    -0x123f8(%ebx),%eax
c0100089:	50                   	push   %eax
c010008a:	e8 9a 02 00 00       	call   c0100329 <cprintf>
c010008f:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100092:	e8 d1 09 00 00       	call   c0100a68 <print_kerninfo>

    grade_backtrace();
c0100097:	e8 98 00 00 00       	call   c0100134 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010009c:	e8 43 36 00 00       	call   c01036e4 <pmm_init>

    pic_init();                 // init interrupt controller
c01000a1:	e8 21 1a 00 00       	call   c0101ac7 <pic_init>
    idt_init();                 // init interrupt descriptor table
c01000a6:	e8 b3 1b 00 00       	call   c0101c5e <idt_init>

    clock_init();               // init clock interrupt
c01000ab:	e8 f5 0e 00 00       	call   c0100fa5 <clock_init>
    intr_enable();              // enable irq interrupt
c01000b0:	e8 5a 1b 00 00       	call   c0101c0f <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000b5:	eb fe                	jmp    c01000b5 <kern_init+0x7f>

c01000b7 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b7:	55                   	push   %ebp
c01000b8:	89 e5                	mov    %esp,%ebp
c01000ba:	53                   	push   %ebx
c01000bb:	83 ec 04             	sub    $0x4,%esp
c01000be:	e8 ef 01 00 00       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01000c3:	05 8d 88 01 00       	add    $0x1888d,%eax
    mon_backtrace(0, NULL, NULL);
c01000c8:	83 ec 04             	sub    $0x4,%esp
c01000cb:	6a 00                	push   $0x0
c01000cd:	6a 00                	push   $0x0
c01000cf:	6a 00                	push   $0x0
c01000d1:	89 c3                	mov    %eax,%ebx
c01000d3:	e8 aa 0e 00 00       	call   c0100f82 <mon_backtrace>
c01000d8:	83 c4 10             	add    $0x10,%esp
}
c01000db:	90                   	nop
c01000dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000df:	c9                   	leave  
c01000e0:	c3                   	ret    

c01000e1 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000e1:	55                   	push   %ebp
c01000e2:	89 e5                	mov    %esp,%ebp
c01000e4:	53                   	push   %ebx
c01000e5:	83 ec 04             	sub    $0x4,%esp
c01000e8:	e8 c5 01 00 00       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01000ed:	05 63 88 01 00       	add    $0x18863,%eax
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000f2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000f5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000f8:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fe:	51                   	push   %ecx
c01000ff:	52                   	push   %edx
c0100100:	53                   	push   %ebx
c0100101:	50                   	push   %eax
c0100102:	e8 b0 ff ff ff       	call   c01000b7 <grade_backtrace2>
c0100107:	83 c4 10             	add    $0x10,%esp
}
c010010a:	90                   	nop
c010010b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010010e:	c9                   	leave  
c010010f:	c3                   	ret    

c0100110 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100110:	55                   	push   %ebp
c0100111:	89 e5                	mov    %esp,%ebp
c0100113:	83 ec 08             	sub    $0x8,%esp
c0100116:	e8 97 01 00 00       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010011b:	05 35 88 01 00       	add    $0x18835,%eax
    grade_backtrace1(arg0, arg2);
c0100120:	83 ec 08             	sub    $0x8,%esp
c0100123:	ff 75 10             	pushl  0x10(%ebp)
c0100126:	ff 75 08             	pushl  0x8(%ebp)
c0100129:	e8 b3 ff ff ff       	call   c01000e1 <grade_backtrace1>
c010012e:	83 c4 10             	add    $0x10,%esp
}
c0100131:	90                   	nop
c0100132:	c9                   	leave  
c0100133:	c3                   	ret    

c0100134 <grade_backtrace>:

void
grade_backtrace(void) {
c0100134:	55                   	push   %ebp
c0100135:	89 e5                	mov    %esp,%ebp
c0100137:	83 ec 08             	sub    $0x8,%esp
c010013a:	e8 73 01 00 00       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010013f:	05 11 88 01 00       	add    $0x18811,%eax
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100144:	8d 80 e6 76 fe ff    	lea    -0x1891a(%eax),%eax
c010014a:	83 ec 04             	sub    $0x4,%esp
c010014d:	68 00 00 ff ff       	push   $0xffff0000
c0100152:	50                   	push   %eax
c0100153:	6a 00                	push   $0x0
c0100155:	e8 b6 ff ff ff       	call   c0100110 <grade_backtrace0>
c010015a:	83 c4 10             	add    $0x10,%esp
}
c010015d:	90                   	nop
c010015e:	c9                   	leave  
c010015f:	c3                   	ret    

c0100160 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100160:	55                   	push   %ebp
c0100161:	89 e5                	mov    %esp,%ebp
c0100163:	53                   	push   %ebx
c0100164:	83 ec 14             	sub    $0x14,%esp
c0100167:	e8 4a 01 00 00       	call   c01002b6 <__x86.get_pc_thunk.bx>
c010016c:	81 c3 e4 87 01 00    	add    $0x187e4,%ebx
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100172:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100175:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100178:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010017b:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010017e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100182:	0f b7 c0             	movzwl %ax,%eax
c0100185:	83 e0 03             	and    $0x3,%eax
c0100188:	89 c2                	mov    %eax,%edx
c010018a:	8b 83 b0 26 00 00    	mov    0x26b0(%ebx),%eax
c0100190:	83 ec 04             	sub    $0x4,%esp
c0100193:	52                   	push   %edx
c0100194:	50                   	push   %eax
c0100195:	8d 83 0d dc fe ff    	lea    -0x123f3(%ebx),%eax
c010019b:	50                   	push   %eax
c010019c:	e8 88 01 00 00       	call   c0100329 <cprintf>
c01001a1:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c01001a4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01001a8:	0f b7 d0             	movzwl %ax,%edx
c01001ab:	8b 83 b0 26 00 00    	mov    0x26b0(%ebx),%eax
c01001b1:	83 ec 04             	sub    $0x4,%esp
c01001b4:	52                   	push   %edx
c01001b5:	50                   	push   %eax
c01001b6:	8d 83 1b dc fe ff    	lea    -0x123e5(%ebx),%eax
c01001bc:	50                   	push   %eax
c01001bd:	e8 67 01 00 00       	call   c0100329 <cprintf>
c01001c2:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c01001c5:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001c9:	0f b7 d0             	movzwl %ax,%edx
c01001cc:	8b 83 b0 26 00 00    	mov    0x26b0(%ebx),%eax
c01001d2:	83 ec 04             	sub    $0x4,%esp
c01001d5:	52                   	push   %edx
c01001d6:	50                   	push   %eax
c01001d7:	8d 83 29 dc fe ff    	lea    -0x123d7(%ebx),%eax
c01001dd:	50                   	push   %eax
c01001de:	e8 46 01 00 00       	call   c0100329 <cprintf>
c01001e3:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c01001e6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001ea:	0f b7 d0             	movzwl %ax,%edx
c01001ed:	8b 83 b0 26 00 00    	mov    0x26b0(%ebx),%eax
c01001f3:	83 ec 04             	sub    $0x4,%esp
c01001f6:	52                   	push   %edx
c01001f7:	50                   	push   %eax
c01001f8:	8d 83 37 dc fe ff    	lea    -0x123c9(%ebx),%eax
c01001fe:	50                   	push   %eax
c01001ff:	e8 25 01 00 00       	call   c0100329 <cprintf>
c0100204:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c0100207:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010020b:	0f b7 d0             	movzwl %ax,%edx
c010020e:	8b 83 b0 26 00 00    	mov    0x26b0(%ebx),%eax
c0100214:	83 ec 04             	sub    $0x4,%esp
c0100217:	52                   	push   %edx
c0100218:	50                   	push   %eax
c0100219:	8d 83 45 dc fe ff    	lea    -0x123bb(%ebx),%eax
c010021f:	50                   	push   %eax
c0100220:	e8 04 01 00 00       	call   c0100329 <cprintf>
c0100225:	83 c4 10             	add    $0x10,%esp
    round ++;
c0100228:	8b 83 b0 26 00 00    	mov    0x26b0(%ebx),%eax
c010022e:	83 c0 01             	add    $0x1,%eax
c0100231:	89 83 b0 26 00 00    	mov    %eax,0x26b0(%ebx)
}
c0100237:	90                   	nop
c0100238:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010023b:	c9                   	leave  
c010023c:	c3                   	ret    

c010023d <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010023d:	55                   	push   %ebp
c010023e:	89 e5                	mov    %esp,%ebp
c0100240:	e8 6d 00 00 00       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0100245:	05 0b 87 01 00       	add    $0x1870b,%eax
    //LAB1 CHALLENGE 1 : TODO
}
c010024a:	90                   	nop
c010024b:	5d                   	pop    %ebp
c010024c:	c3                   	ret    

c010024d <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010024d:	55                   	push   %ebp
c010024e:	89 e5                	mov    %esp,%ebp
c0100250:	e8 5d 00 00 00       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0100255:	05 fb 86 01 00       	add    $0x186fb,%eax
    //LAB1 CHALLENGE 1 :  TODO
}
c010025a:	90                   	nop
c010025b:	5d                   	pop    %ebp
c010025c:	c3                   	ret    

c010025d <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010025d:	55                   	push   %ebp
c010025e:	89 e5                	mov    %esp,%ebp
c0100260:	53                   	push   %ebx
c0100261:	83 ec 04             	sub    $0x4,%esp
c0100264:	e8 4d 00 00 00       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0100269:	81 c3 e7 86 01 00    	add    $0x186e7,%ebx
    lab1_print_cur_status();
c010026f:	e8 ec fe ff ff       	call   c0100160 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100274:	83 ec 0c             	sub    $0xc,%esp
c0100277:	8d 83 54 dc fe ff    	lea    -0x123ac(%ebx),%eax
c010027d:	50                   	push   %eax
c010027e:	e8 a6 00 00 00       	call   c0100329 <cprintf>
c0100283:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c0100286:	e8 b2 ff ff ff       	call   c010023d <lab1_switch_to_user>
    lab1_print_cur_status();
c010028b:	e8 d0 fe ff ff       	call   c0100160 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100290:	83 ec 0c             	sub    $0xc,%esp
c0100293:	8d 83 74 dc fe ff    	lea    -0x1238c(%ebx),%eax
c0100299:	50                   	push   %eax
c010029a:	e8 8a 00 00 00       	call   c0100329 <cprintf>
c010029f:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c01002a2:	e8 a6 ff ff ff       	call   c010024d <lab1_switch_to_kernel>
    lab1_print_cur_status();
c01002a7:	e8 b4 fe ff ff       	call   c0100160 <lab1_print_cur_status>
}
c01002ac:	90                   	nop
c01002ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01002b0:	c9                   	leave  
c01002b1:	c3                   	ret    

c01002b2 <__x86.get_pc_thunk.ax>:
c01002b2:	8b 04 24             	mov    (%esp),%eax
c01002b5:	c3                   	ret    

c01002b6 <__x86.get_pc_thunk.bx>:
c01002b6:	8b 1c 24             	mov    (%esp),%ebx
c01002b9:	c3                   	ret    

c01002ba <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002ba:	55                   	push   %ebp
c01002bb:	89 e5                	mov    %esp,%ebp
c01002bd:	53                   	push   %ebx
c01002be:	83 ec 04             	sub    $0x4,%esp
c01002c1:	e8 ec ff ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01002c6:	05 8a 86 01 00       	add    $0x1868a,%eax
    cons_putc(c);
c01002cb:	83 ec 0c             	sub    $0xc,%esp
c01002ce:	ff 75 08             	pushl  0x8(%ebp)
c01002d1:	89 c3                	mov    %eax,%ebx
c01002d3:	e8 75 16 00 00       	call   c010194d <cons_putc>
c01002d8:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c01002db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002de:	8b 00                	mov    (%eax),%eax
c01002e0:	8d 50 01             	lea    0x1(%eax),%edx
c01002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002e6:	89 10                	mov    %edx,(%eax)
}
c01002e8:	90                   	nop
c01002e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01002ec:	c9                   	leave  
c01002ed:	c3                   	ret    

c01002ee <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c01002ee:	55                   	push   %ebp
c01002ef:	89 e5                	mov    %esp,%ebp
c01002f1:	53                   	push   %ebx
c01002f2:	83 ec 14             	sub    $0x14,%esp
c01002f5:	e8 b8 ff ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01002fa:	05 56 86 01 00       	add    $0x18656,%eax
    int cnt = 0;
c01002ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100306:	ff 75 0c             	pushl  0xc(%ebp)
c0100309:	ff 75 08             	pushl  0x8(%ebp)
c010030c:	8d 55 f4             	lea    -0xc(%ebp),%edx
c010030f:	52                   	push   %edx
c0100310:	8d 90 6a 79 fe ff    	lea    -0x18696(%eax),%edx
c0100316:	52                   	push   %edx
c0100317:	89 c3                	mov    %eax,%ebx
c0100319:	e8 7f 5d 00 00       	call   c010609d <vprintfmt>
c010031e:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100321:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100324:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100327:	c9                   	leave  
c0100328:	c3                   	ret    

c0100329 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100329:	55                   	push   %ebp
c010032a:	89 e5                	mov    %esp,%ebp
c010032c:	83 ec 18             	sub    $0x18,%esp
c010032f:	e8 7e ff ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0100334:	05 1c 86 01 00       	add    $0x1861c,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100339:	8d 45 0c             	lea    0xc(%ebp),%eax
c010033c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010033f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100342:	83 ec 08             	sub    $0x8,%esp
c0100345:	50                   	push   %eax
c0100346:	ff 75 08             	pushl  0x8(%ebp)
c0100349:	e8 a0 ff ff ff       	call   c01002ee <vcprintf>
c010034e:	83 c4 10             	add    $0x10,%esp
c0100351:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100354:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100357:	c9                   	leave  
c0100358:	c3                   	ret    

c0100359 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100359:	55                   	push   %ebp
c010035a:	89 e5                	mov    %esp,%ebp
c010035c:	53                   	push   %ebx
c010035d:	83 ec 04             	sub    $0x4,%esp
c0100360:	e8 4d ff ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0100365:	05 eb 85 01 00       	add    $0x185eb,%eax
    cons_putc(c);
c010036a:	83 ec 0c             	sub    $0xc,%esp
c010036d:	ff 75 08             	pushl  0x8(%ebp)
c0100370:	89 c3                	mov    %eax,%ebx
c0100372:	e8 d6 15 00 00       	call   c010194d <cons_putc>
c0100377:	83 c4 10             	add    $0x10,%esp
}
c010037a:	90                   	nop
c010037b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010037e:	c9                   	leave  
c010037f:	c3                   	ret    

c0100380 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100380:	55                   	push   %ebp
c0100381:	89 e5                	mov    %esp,%ebp
c0100383:	83 ec 18             	sub    $0x18,%esp
c0100386:	e8 27 ff ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010038b:	05 c5 85 01 00       	add    $0x185c5,%eax
    int cnt = 0;
c0100390:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	eb 14                	jmp    c01003ad <cputs+0x2d>
        cputch(c, &cnt);
c0100399:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010039d:	83 ec 08             	sub    $0x8,%esp
c01003a0:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003a3:	52                   	push   %edx
c01003a4:	50                   	push   %eax
c01003a5:	e8 10 ff ff ff       	call   c01002ba <cputch>
c01003aa:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
c01003ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b0:	8d 50 01             	lea    0x1(%eax),%edx
c01003b3:	89 55 08             	mov    %edx,0x8(%ebp)
c01003b6:	0f b6 00             	movzbl (%eax),%eax
c01003b9:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003bc:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c0:	75 d7                	jne    c0100399 <cputs+0x19>
    }
    cputch('\n', &cnt);
c01003c2:	83 ec 08             	sub    $0x8,%esp
c01003c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003c8:	50                   	push   %eax
c01003c9:	6a 0a                	push   $0xa
c01003cb:	e8 ea fe ff ff       	call   c01002ba <cputch>
c01003d0:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01003d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d6:	c9                   	leave  
c01003d7:	c3                   	ret    

c01003d8 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d8:	55                   	push   %ebp
c01003d9:	89 e5                	mov    %esp,%ebp
c01003db:	53                   	push   %ebx
c01003dc:	83 ec 14             	sub    $0x14,%esp
c01003df:	e8 d2 fe ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c01003e4:	81 c3 6c 85 01 00    	add    $0x1856c,%ebx
    int c;
    while ((c = cons_getc()) == 0)
c01003ea:	e8 b1 15 00 00       	call   c01019a0 <cons_getc>
c01003ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003f6:	74 f2                	je     c01003ea <getchar+0x12>
        /* do nothing */;
    return c;
c01003f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003fb:	83 c4 14             	add    $0x14,%esp
c01003fe:	5b                   	pop    %ebx
c01003ff:	5d                   	pop    %ebp
c0100400:	c3                   	ret    

c0100401 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100401:	55                   	push   %ebp
c0100402:	89 e5                	mov    %esp,%ebp
c0100404:	53                   	push   %ebx
c0100405:	83 ec 14             	sub    $0x14,%esp
c0100408:	e8 a9 fe ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c010040d:	81 c3 43 85 01 00    	add    $0x18543,%ebx
    if (prompt != NULL) {
c0100413:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100417:	74 15                	je     c010042e <readline+0x2d>
        cprintf("%s", prompt);
c0100419:	83 ec 08             	sub    $0x8,%esp
c010041c:	ff 75 08             	pushl  0x8(%ebp)
c010041f:	8d 83 93 dc fe ff    	lea    -0x1236d(%ebx),%eax
c0100425:	50                   	push   %eax
c0100426:	e8 fe fe ff ff       	call   c0100329 <cprintf>
c010042b:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c010042e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100435:	e8 9e ff ff ff       	call   c01003d8 <getchar>
c010043a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010043d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100441:	79 0a                	jns    c010044d <readline+0x4c>
            return NULL;
c0100443:	b8 00 00 00 00       	mov    $0x0,%eax
c0100448:	e9 87 00 00 00       	jmp    c01004d4 <readline+0xd3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010044d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100451:	7e 2c                	jle    c010047f <readline+0x7e>
c0100453:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010045a:	7f 23                	jg     c010047f <readline+0x7e>
            cputchar(c);
c010045c:	83 ec 0c             	sub    $0xc,%esp
c010045f:	ff 75 f0             	pushl  -0x10(%ebp)
c0100462:	e8 f2 fe ff ff       	call   c0100359 <cputchar>
c0100467:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c010046a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010046d:	8d 50 01             	lea    0x1(%eax),%edx
c0100470:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100473:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100476:	88 94 03 d0 26 00 00 	mov    %dl,0x26d0(%ebx,%eax,1)
c010047d:	eb 50                	jmp    c01004cf <readline+0xce>
        }
        else if (c == '\b' && i > 0) {
c010047f:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c0100483:	75 1a                	jne    c010049f <readline+0x9e>
c0100485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100489:	7e 14                	jle    c010049f <readline+0x9e>
            cputchar(c);
c010048b:	83 ec 0c             	sub    $0xc,%esp
c010048e:	ff 75 f0             	pushl  -0x10(%ebp)
c0100491:	e8 c3 fe ff ff       	call   c0100359 <cputchar>
c0100496:	83 c4 10             	add    $0x10,%esp
            i --;
c0100499:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010049d:	eb 30                	jmp    c01004cf <readline+0xce>
        }
        else if (c == '\n' || c == '\r') {
c010049f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01004a3:	74 06                	je     c01004ab <readline+0xaa>
c01004a5:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01004a9:	75 8a                	jne    c0100435 <readline+0x34>
            cputchar(c);
c01004ab:	83 ec 0c             	sub    $0xc,%esp
c01004ae:	ff 75 f0             	pushl  -0x10(%ebp)
c01004b1:	e8 a3 fe ff ff       	call   c0100359 <cputchar>
c01004b6:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01004b9:	8d 93 d0 26 00 00    	lea    0x26d0(%ebx),%edx
c01004bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004c2:	01 d0                	add    %edx,%eax
c01004c4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01004c7:	8d 83 d0 26 00 00    	lea    0x26d0(%ebx),%eax
c01004cd:	eb 05                	jmp    c01004d4 <readline+0xd3>
        c = getchar();
c01004cf:	e9 61 ff ff ff       	jmp    c0100435 <readline+0x34>
        }
    }
}
c01004d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01004d7:	c9                   	leave  
c01004d8:	c3                   	ret    

c01004d9 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01004d9:	55                   	push   %ebp
c01004da:	89 e5                	mov    %esp,%ebp
c01004dc:	53                   	push   %ebx
c01004dd:	83 ec 14             	sub    $0x14,%esp
c01004e0:	e8 d1 fd ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c01004e5:	81 c3 6b 84 01 00    	add    $0x1846b,%ebx
    if (is_panic) {
c01004eb:	8b 83 d0 2a 00 00    	mov    0x2ad0(%ebx),%eax
c01004f1:	85 c0                	test   %eax,%eax
c01004f3:	75 65                	jne    c010055a <__panic+0x81>
        goto panic_dead;
    }
    is_panic = 1;
c01004f5:	c7 83 d0 2a 00 00 01 	movl   $0x1,0x2ad0(%ebx)
c01004fc:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01004ff:	8d 45 14             	lea    0x14(%ebp),%eax
c0100502:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100505:	83 ec 04             	sub    $0x4,%esp
c0100508:	ff 75 0c             	pushl  0xc(%ebp)
c010050b:	ff 75 08             	pushl  0x8(%ebp)
c010050e:	8d 83 96 dc fe ff    	lea    -0x1236a(%ebx),%eax
c0100514:	50                   	push   %eax
c0100515:	e8 0f fe ff ff       	call   c0100329 <cprintf>
c010051a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010051d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100520:	83 ec 08             	sub    $0x8,%esp
c0100523:	50                   	push   %eax
c0100524:	ff 75 10             	pushl  0x10(%ebp)
c0100527:	e8 c2 fd ff ff       	call   c01002ee <vcprintf>
c010052c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c010052f:	83 ec 0c             	sub    $0xc,%esp
c0100532:	8d 83 b2 dc fe ff    	lea    -0x1234e(%ebx),%eax
c0100538:	50                   	push   %eax
c0100539:	e8 eb fd ff ff       	call   c0100329 <cprintf>
c010053e:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
c0100541:	83 ec 0c             	sub    $0xc,%esp
c0100544:	8d 83 b4 dc fe ff    	lea    -0x1234c(%ebx),%eax
c010054a:	50                   	push   %eax
c010054b:	e8 d9 fd ff ff       	call   c0100329 <cprintf>
c0100550:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
c0100553:	e8 9f 06 00 00       	call   c0100bf7 <print_stackframe>
c0100558:	eb 01                	jmp    c010055b <__panic+0x82>
        goto panic_dead;
c010055a:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c010055b:	e8 c0 16 00 00       	call   c0101c20 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100560:	83 ec 0c             	sub    $0xc,%esp
c0100563:	6a 00                	push   $0x0
c0100565:	e8 fe 08 00 00       	call   c0100e68 <kmonitor>
c010056a:	83 c4 10             	add    $0x10,%esp
c010056d:	eb f1                	jmp    c0100560 <__panic+0x87>

c010056f <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010056f:	55                   	push   %ebp
c0100570:	89 e5                	mov    %esp,%ebp
c0100572:	53                   	push   %ebx
c0100573:	83 ec 14             	sub    $0x14,%esp
c0100576:	e8 3b fd ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c010057b:	81 c3 d5 83 01 00    	add    $0x183d5,%ebx
    va_list ap;
    va_start(ap, fmt);
c0100581:	8d 45 14             	lea    0x14(%ebp),%eax
c0100584:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100587:	83 ec 04             	sub    $0x4,%esp
c010058a:	ff 75 0c             	pushl  0xc(%ebp)
c010058d:	ff 75 08             	pushl  0x8(%ebp)
c0100590:	8d 83 c6 dc fe ff    	lea    -0x1233a(%ebx),%eax
c0100596:	50                   	push   %eax
c0100597:	e8 8d fd ff ff       	call   c0100329 <cprintf>
c010059c:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010059f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005a2:	83 ec 08             	sub    $0x8,%esp
c01005a5:	50                   	push   %eax
c01005a6:	ff 75 10             	pushl  0x10(%ebp)
c01005a9:	e8 40 fd ff ff       	call   c01002ee <vcprintf>
c01005ae:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c01005b1:	83 ec 0c             	sub    $0xc,%esp
c01005b4:	8d 83 b2 dc fe ff    	lea    -0x1234e(%ebx),%eax
c01005ba:	50                   	push   %eax
c01005bb:	e8 69 fd ff ff       	call   c0100329 <cprintf>
c01005c0:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01005c3:	90                   	nop
c01005c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01005c7:	c9                   	leave  
c01005c8:	c3                   	ret    

c01005c9 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01005c9:	55                   	push   %ebp
c01005ca:	89 e5                	mov    %esp,%ebp
c01005cc:	e8 e1 fc ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01005d1:	05 7f 83 01 00       	add    $0x1837f,%eax
    return is_panic;
c01005d6:	8b 80 d0 2a 00 00    	mov    0x2ad0(%eax),%eax
}
c01005dc:	5d                   	pop    %ebp
c01005dd:	c3                   	ret    

c01005de <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01005de:	55                   	push   %ebp
c01005df:	89 e5                	mov    %esp,%ebp
c01005e1:	83 ec 20             	sub    $0x20,%esp
c01005e4:	e8 c9 fc ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01005e9:	05 67 83 01 00       	add    $0x18367,%eax
    int l = *region_left, r = *region_right, any_matches = 0;
c01005ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f1:	8b 00                	mov    (%eax),%eax
c01005f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01005f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01005f9:	8b 00                	mov    (%eax),%eax
c01005fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100605:	e9 d2 00 00 00       	jmp    c01006dc <stab_binsearch+0xfe>
        int true_m = (l + r) / 2, m = true_m;
c010060a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010060d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100610:	01 d0                	add    %edx,%eax
c0100612:	89 c2                	mov    %eax,%edx
c0100614:	c1 ea 1f             	shr    $0x1f,%edx
c0100617:	01 d0                	add    %edx,%eax
c0100619:	d1 f8                	sar    %eax
c010061b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010061e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100621:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100624:	eb 04                	jmp    c010062a <stab_binsearch+0x4c>
            m --;
c0100626:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c010062a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010062d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100630:	7c 1f                	jl     c0100651 <stab_binsearch+0x73>
c0100632:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100635:	89 d0                	mov    %edx,%eax
c0100637:	01 c0                	add    %eax,%eax
c0100639:	01 d0                	add    %edx,%eax
c010063b:	c1 e0 02             	shl    $0x2,%eax
c010063e:	89 c2                	mov    %eax,%edx
c0100640:	8b 45 08             	mov    0x8(%ebp),%eax
c0100643:	01 d0                	add    %edx,%eax
c0100645:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100649:	0f b6 c0             	movzbl %al,%eax
c010064c:	39 45 14             	cmp    %eax,0x14(%ebp)
c010064f:	75 d5                	jne    c0100626 <stab_binsearch+0x48>
        }
        if (m < l) {    // no match in [l, m]
c0100651:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100654:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100657:	7d 0b                	jge    c0100664 <stab_binsearch+0x86>
            l = true_m + 1;
c0100659:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010065c:	83 c0 01             	add    $0x1,%eax
c010065f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100662:	eb 78                	jmp    c01006dc <stab_binsearch+0xfe>
        }

        // actual binary search
        any_matches = 1;
c0100664:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010066b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010066e:	89 d0                	mov    %edx,%eax
c0100670:	01 c0                	add    %eax,%eax
c0100672:	01 d0                	add    %edx,%eax
c0100674:	c1 e0 02             	shl    $0x2,%eax
c0100677:	89 c2                	mov    %eax,%edx
c0100679:	8b 45 08             	mov    0x8(%ebp),%eax
c010067c:	01 d0                	add    %edx,%eax
c010067e:	8b 40 08             	mov    0x8(%eax),%eax
c0100681:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100684:	76 13                	jbe    c0100699 <stab_binsearch+0xbb>
            *region_left = m;
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010068c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010068e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100691:	83 c0 01             	add    $0x1,%eax
c0100694:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100697:	eb 43                	jmp    c01006dc <stab_binsearch+0xfe>
        } else if (stabs[m].n_value > addr) {
c0100699:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010069c:	89 d0                	mov    %edx,%eax
c010069e:	01 c0                	add    %eax,%eax
c01006a0:	01 d0                	add    %edx,%eax
c01006a2:	c1 e0 02             	shl    $0x2,%eax
c01006a5:	89 c2                	mov    %eax,%edx
c01006a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01006aa:	01 d0                	add    %edx,%eax
c01006ac:	8b 40 08             	mov    0x8(%eax),%eax
c01006af:	39 45 18             	cmp    %eax,0x18(%ebp)
c01006b2:	73 16                	jae    c01006ca <stab_binsearch+0xec>
            *region_right = m - 1;
c01006b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006b7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01006ba:	8b 45 10             	mov    0x10(%ebp),%eax
c01006bd:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01006bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006c2:	83 e8 01             	sub    $0x1,%eax
c01006c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01006c8:	eb 12                	jmp    c01006dc <stab_binsearch+0xfe>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01006ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006d0:	89 10                	mov    %edx,(%eax)
            l = m;
c01006d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01006d8:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c01006dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01006df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01006e2:	0f 8e 22 ff ff ff    	jle    c010060a <stab_binsearch+0x2c>
        }
    }

    if (!any_matches) {
c01006e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01006ec:	75 0f                	jne    c01006fd <stab_binsearch+0x11f>
        *region_right = *region_left - 1;
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 00                	mov    (%eax),%eax
c01006f3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01006f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01006f9:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01006fb:	eb 3f                	jmp    c010073c <stab_binsearch+0x15e>
        l = *region_right;
c01006fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0100700:	8b 00                	mov    (%eax),%eax
c0100702:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100705:	eb 04                	jmp    c010070b <stab_binsearch+0x12d>
c0100707:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010070b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010070e:	8b 00                	mov    (%eax),%eax
c0100710:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100713:	7e 1f                	jle    c0100734 <stab_binsearch+0x156>
c0100715:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100718:	89 d0                	mov    %edx,%eax
c010071a:	01 c0                	add    %eax,%eax
c010071c:	01 d0                	add    %edx,%eax
c010071e:	c1 e0 02             	shl    $0x2,%eax
c0100721:	89 c2                	mov    %eax,%edx
c0100723:	8b 45 08             	mov    0x8(%ebp),%eax
c0100726:	01 d0                	add    %edx,%eax
c0100728:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010072c:	0f b6 c0             	movzbl %al,%eax
c010072f:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100732:	75 d3                	jne    c0100707 <stab_binsearch+0x129>
        *region_left = l;
c0100734:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100737:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010073a:	89 10                	mov    %edx,(%eax)
}
c010073c:	90                   	nop
c010073d:	c9                   	leave  
c010073e:	c3                   	ret    

c010073f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010073f:	55                   	push   %ebp
c0100740:	89 e5                	mov    %esp,%ebp
c0100742:	53                   	push   %ebx
c0100743:	83 ec 34             	sub    $0x34,%esp
c0100746:	e8 6b fb ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c010074b:	81 c3 05 82 01 00    	add    $0x18205,%ebx
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100751:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100754:	8d 93 e4 dc fe ff    	lea    -0x1231c(%ebx),%edx
c010075a:	89 10                	mov    %edx,(%eax)
    info->eip_line = 0;
c010075c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100766:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100769:	8d 93 e4 dc fe ff    	lea    -0x1231c(%ebx),%edx
c010076f:	89 50 08             	mov    %edx,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100772:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100775:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010077c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010077f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100782:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100785:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100788:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010078f:	c7 c0 c0 77 10 c0    	mov    $0xc01077c0,%eax
c0100795:	89 45 f4             	mov    %eax,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100798:	c7 c0 80 29 11 c0    	mov    $0xc0112980,%eax
c010079e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01007a1:	c7 c0 81 29 11 c0    	mov    $0xc0112981,%eax
c01007a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01007aa:	c7 c0 7f 54 11 c0    	mov    $0xc011547f,%eax
c01007b0:	89 45 e8             	mov    %eax,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01007b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01007b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01007b9:	76 0d                	jbe    c01007c8 <debuginfo_eip+0x89>
c01007bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01007be:	83 e8 01             	sub    $0x1,%eax
c01007c1:	0f b6 00             	movzbl (%eax),%eax
c01007c4:	84 c0                	test   %al,%al
c01007c6:	74 0a                	je     c01007d2 <debuginfo_eip+0x93>
        return -1;
c01007c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007cd:	e9 91 02 00 00       	jmp    c0100a63 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01007d2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01007d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01007dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007df:	29 c2                	sub    %eax,%edx
c01007e1:	89 d0                	mov    %edx,%eax
c01007e3:	c1 f8 02             	sar    $0x2,%eax
c01007e6:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01007ec:	83 e8 01             	sub    $0x1,%eax
c01007ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01007f2:	ff 75 08             	pushl  0x8(%ebp)
c01007f5:	6a 64                	push   $0x64
c01007f7:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01007fa:	50                   	push   %eax
c01007fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01007fe:	50                   	push   %eax
c01007ff:	ff 75 f4             	pushl  -0xc(%ebp)
c0100802:	e8 d7 fd ff ff       	call   c01005de <stab_binsearch>
c0100807:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c010080a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010080d:	85 c0                	test   %eax,%eax
c010080f:	75 0a                	jne    c010081b <debuginfo_eip+0xdc>
        return -1;
c0100811:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100816:	e9 48 02 00 00       	jmp    c0100a63 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010081b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010081e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100821:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100824:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100827:	ff 75 08             	pushl  0x8(%ebp)
c010082a:	6a 24                	push   $0x24
c010082c:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010082f:	50                   	push   %eax
c0100830:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100833:	50                   	push   %eax
c0100834:	ff 75 f4             	pushl  -0xc(%ebp)
c0100837:	e8 a2 fd ff ff       	call   c01005de <stab_binsearch>
c010083c:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c010083f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100842:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100845:	39 c2                	cmp    %eax,%edx
c0100847:	7f 7c                	jg     c01008c5 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100849:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010084c:	89 c2                	mov    %eax,%edx
c010084e:	89 d0                	mov    %edx,%eax
c0100850:	01 c0                	add    %eax,%eax
c0100852:	01 d0                	add    %edx,%eax
c0100854:	c1 e0 02             	shl    $0x2,%eax
c0100857:	89 c2                	mov    %eax,%edx
c0100859:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085c:	01 d0                	add    %edx,%eax
c010085e:	8b 00                	mov    (%eax),%eax
c0100860:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100863:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100866:	29 d1                	sub    %edx,%ecx
c0100868:	89 ca                	mov    %ecx,%edx
c010086a:	39 d0                	cmp    %edx,%eax
c010086c:	73 22                	jae    c0100890 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010086e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100871:	89 c2                	mov    %eax,%edx
c0100873:	89 d0                	mov    %edx,%eax
c0100875:	01 c0                	add    %eax,%eax
c0100877:	01 d0                	add    %edx,%eax
c0100879:	c1 e0 02             	shl    $0x2,%eax
c010087c:	89 c2                	mov    %eax,%edx
c010087e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100881:	01 d0                	add    %edx,%eax
c0100883:	8b 10                	mov    (%eax),%edx
c0100885:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100888:	01 c2                	add    %eax,%edx
c010088a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010088d:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100890:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100893:	89 c2                	mov    %eax,%edx
c0100895:	89 d0                	mov    %edx,%eax
c0100897:	01 c0                	add    %eax,%eax
c0100899:	01 d0                	add    %edx,%eax
c010089b:	c1 e0 02             	shl    $0x2,%eax
c010089e:	89 c2                	mov    %eax,%edx
c01008a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a3:	01 d0                	add    %edx,%eax
c01008a5:	8b 50 08             	mov    0x8(%eax),%edx
c01008a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008ab:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01008ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008b1:	8b 40 10             	mov    0x10(%eax),%eax
c01008b4:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01008b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01008bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01008c3:	eb 15                	jmp    c01008da <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01008c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008c8:	8b 55 08             	mov    0x8(%ebp),%edx
c01008cb:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01008ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01008d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01008d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01008da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008dd:	8b 40 08             	mov    0x8(%eax),%eax
c01008e0:	83 ec 08             	sub    $0x8,%esp
c01008e3:	6a 3a                	push   $0x3a
c01008e5:	50                   	push   %eax
c01008e6:	e8 84 52 00 00       	call   c0105b6f <strfind>
c01008eb:	83 c4 10             	add    $0x10,%esp
c01008ee:	89 c2                	mov    %eax,%edx
c01008f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f3:	8b 40 08             	mov    0x8(%eax),%eax
c01008f6:	29 c2                	sub    %eax,%edx
c01008f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008fb:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01008fe:	83 ec 0c             	sub    $0xc,%esp
c0100901:	ff 75 08             	pushl  0x8(%ebp)
c0100904:	6a 44                	push   $0x44
c0100906:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100909:	50                   	push   %eax
c010090a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010090d:	50                   	push   %eax
c010090e:	ff 75 f4             	pushl  -0xc(%ebp)
c0100911:	e8 c8 fc ff ff       	call   c01005de <stab_binsearch>
c0100916:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c0100919:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010091c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010091f:	39 c2                	cmp    %eax,%edx
c0100921:	7f 24                	jg     c0100947 <debuginfo_eip+0x208>
        info->eip_line = stabs[rline].n_desc;
c0100923:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100926:	89 c2                	mov    %eax,%edx
c0100928:	89 d0                	mov    %edx,%eax
c010092a:	01 c0                	add    %eax,%eax
c010092c:	01 d0                	add    %edx,%eax
c010092e:	c1 e0 02             	shl    $0x2,%eax
c0100931:	89 c2                	mov    %eax,%edx
c0100933:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100936:	01 d0                	add    %edx,%eax
c0100938:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010093c:	0f b7 d0             	movzwl %ax,%edx
c010093f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100942:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100945:	eb 13                	jmp    c010095a <debuginfo_eip+0x21b>
        return -1;
c0100947:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010094c:	e9 12 01 00 00       	jmp    c0100a63 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100951:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100954:	83 e8 01             	sub    $0x1,%eax
c0100957:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c010095a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010095d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100960:	39 c2                	cmp    %eax,%edx
c0100962:	7c 56                	jl     c01009ba <debuginfo_eip+0x27b>
           && stabs[lline].n_type != N_SOL
c0100964:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100967:	89 c2                	mov    %eax,%edx
c0100969:	89 d0                	mov    %edx,%eax
c010096b:	01 c0                	add    %eax,%eax
c010096d:	01 d0                	add    %edx,%eax
c010096f:	c1 e0 02             	shl    $0x2,%eax
c0100972:	89 c2                	mov    %eax,%edx
c0100974:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100977:	01 d0                	add    %edx,%eax
c0100979:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010097d:	3c 84                	cmp    $0x84,%al
c010097f:	74 39                	je     c01009ba <debuginfo_eip+0x27b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100981:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100984:	89 c2                	mov    %eax,%edx
c0100986:	89 d0                	mov    %edx,%eax
c0100988:	01 c0                	add    %eax,%eax
c010098a:	01 d0                	add    %edx,%eax
c010098c:	c1 e0 02             	shl    $0x2,%eax
c010098f:	89 c2                	mov    %eax,%edx
c0100991:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100994:	01 d0                	add    %edx,%eax
c0100996:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010099a:	3c 64                	cmp    $0x64,%al
c010099c:	75 b3                	jne    c0100951 <debuginfo_eip+0x212>
c010099e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01009a1:	89 c2                	mov    %eax,%edx
c01009a3:	89 d0                	mov    %edx,%eax
c01009a5:	01 c0                	add    %eax,%eax
c01009a7:	01 d0                	add    %edx,%eax
c01009a9:	c1 e0 02             	shl    $0x2,%eax
c01009ac:	89 c2                	mov    %eax,%edx
c01009ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009b1:	01 d0                	add    %edx,%eax
c01009b3:	8b 40 08             	mov    0x8(%eax),%eax
c01009b6:	85 c0                	test   %eax,%eax
c01009b8:	74 97                	je     c0100951 <debuginfo_eip+0x212>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01009ba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01009bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01009c0:	39 c2                	cmp    %eax,%edx
c01009c2:	7c 46                	jl     c0100a0a <debuginfo_eip+0x2cb>
c01009c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01009c7:	89 c2                	mov    %eax,%edx
c01009c9:	89 d0                	mov    %edx,%eax
c01009cb:	01 c0                	add    %eax,%eax
c01009cd:	01 d0                	add    %edx,%eax
c01009cf:	c1 e0 02             	shl    $0x2,%eax
c01009d2:	89 c2                	mov    %eax,%edx
c01009d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009d7:	01 d0                	add    %edx,%eax
c01009d9:	8b 00                	mov    (%eax),%eax
c01009db:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01009de:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01009e1:	29 d1                	sub    %edx,%ecx
c01009e3:	89 ca                	mov    %ecx,%edx
c01009e5:	39 d0                	cmp    %edx,%eax
c01009e7:	73 21                	jae    c0100a0a <debuginfo_eip+0x2cb>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01009e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01009ec:	89 c2                	mov    %eax,%edx
c01009ee:	89 d0                	mov    %edx,%eax
c01009f0:	01 c0                	add    %eax,%eax
c01009f2:	01 d0                	add    %edx,%eax
c01009f4:	c1 e0 02             	shl    $0x2,%eax
c01009f7:	89 c2                	mov    %eax,%edx
c01009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fc:	01 d0                	add    %edx,%eax
c01009fe:	8b 10                	mov    (%eax),%edx
c0100a00:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100a03:	01 c2                	add    %eax,%edx
c0100a05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a08:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100a0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100a0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100a10:	39 c2                	cmp    %eax,%edx
c0100a12:	7d 4a                	jge    c0100a5e <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
c0100a14:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a17:	83 c0 01             	add    $0x1,%eax
c0100a1a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100a1d:	eb 18                	jmp    c0100a37 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a22:	8b 40 14             	mov    0x14(%eax),%eax
c0100a25:	8d 50 01             	lea    0x1(%eax),%edx
c0100a28:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a2b:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100a2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100a31:	83 c0 01             	add    $0x1,%eax
c0100a34:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100a37:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100a3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100a3d:	39 c2                	cmp    %eax,%edx
c0100a3f:	7d 1d                	jge    c0100a5e <debuginfo_eip+0x31f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100a41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100a44:	89 c2                	mov    %eax,%edx
c0100a46:	89 d0                	mov    %edx,%eax
c0100a48:	01 c0                	add    %eax,%eax
c0100a4a:	01 d0                	add    %edx,%eax
c0100a4c:	c1 e0 02             	shl    $0x2,%eax
c0100a4f:	89 c2                	mov    %eax,%edx
c0100a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a54:	01 d0                	add    %edx,%eax
c0100a56:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100a5a:	3c a0                	cmp    $0xa0,%al
c0100a5c:	74 c1                	je     c0100a1f <debuginfo_eip+0x2e0>
        }
    }
    return 0;
c0100a5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100a63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100a66:	c9                   	leave  
c0100a67:	c3                   	ret    

c0100a68 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100a68:	55                   	push   %ebp
c0100a69:	89 e5                	mov    %esp,%ebp
c0100a6b:	53                   	push   %ebx
c0100a6c:	83 ec 04             	sub    $0x4,%esp
c0100a6f:	e8 42 f8 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0100a74:	81 c3 dc 7e 01 00    	add    $0x17edc,%ebx
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100a7a:	83 ec 0c             	sub    $0xc,%esp
c0100a7d:	8d 83 ee dc fe ff    	lea    -0x12312(%ebx),%eax
c0100a83:	50                   	push   %eax
c0100a84:	e8 a0 f8 ff ff       	call   c0100329 <cprintf>
c0100a89:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100a8c:	83 ec 08             	sub    $0x8,%esp
c0100a8f:	c7 c0 36 00 10 c0    	mov    $0xc0100036,%eax
c0100a95:	50                   	push   %eax
c0100a96:	8d 83 07 dd fe ff    	lea    -0x122f9(%ebx),%eax
c0100a9c:	50                   	push   %eax
c0100a9d:	e8 87 f8 ff ff       	call   c0100329 <cprintf>
c0100aa2:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100aa5:	83 ec 08             	sub    $0x8,%esp
c0100aa8:	c7 c0 3b 65 10 c0    	mov    $0xc010653b,%eax
c0100aae:	50                   	push   %eax
c0100aaf:	8d 83 1f dd fe ff    	lea    -0x122e1(%ebx),%eax
c0100ab5:	50                   	push   %eax
c0100ab6:	e8 6e f8 ff ff       	call   c0100329 <cprintf>
c0100abb:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100abe:	83 ec 08             	sub    $0x8,%esp
c0100ac1:	c7 c0 00 b0 11 c0    	mov    $0xc011b000,%eax
c0100ac7:	50                   	push   %eax
c0100ac8:	8d 83 37 dd fe ff    	lea    -0x122c9(%ebx),%eax
c0100ace:	50                   	push   %eax
c0100acf:	e8 55 f8 ff ff       	call   c0100329 <cprintf>
c0100ad4:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100ad7:	83 ec 08             	sub    $0x8,%esp
c0100ada:	c7 c0 28 bf 11 c0    	mov    $0xc011bf28,%eax
c0100ae0:	50                   	push   %eax
c0100ae1:	8d 83 4f dd fe ff    	lea    -0x122b1(%ebx),%eax
c0100ae7:	50                   	push   %eax
c0100ae8:	e8 3c f8 ff ff       	call   c0100329 <cprintf>
c0100aed:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c0100af0:	c7 c0 28 bf 11 c0    	mov    $0xc011bf28,%eax
c0100af6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100afc:	c7 c0 36 00 10 c0    	mov    $0xc0100036,%eax
c0100b02:	29 c2                	sub    %eax,%edx
c0100b04:	89 d0                	mov    %edx,%eax
c0100b06:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100b0c:	85 c0                	test   %eax,%eax
c0100b0e:	0f 48 c2             	cmovs  %edx,%eax
c0100b11:	c1 f8 0a             	sar    $0xa,%eax
c0100b14:	83 ec 08             	sub    $0x8,%esp
c0100b17:	50                   	push   %eax
c0100b18:	8d 83 68 dd fe ff    	lea    -0x12298(%ebx),%eax
c0100b1e:	50                   	push   %eax
c0100b1f:	e8 05 f8 ff ff       	call   c0100329 <cprintf>
c0100b24:	83 c4 10             	add    $0x10,%esp
}
c0100b27:	90                   	nop
c0100b28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100b2b:	c9                   	leave  
c0100b2c:	c3                   	ret    

c0100b2d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100b2d:	55                   	push   %ebp
c0100b2e:	89 e5                	mov    %esp,%ebp
c0100b30:	53                   	push   %ebx
c0100b31:	81 ec 24 01 00 00    	sub    $0x124,%esp
c0100b37:	e8 7a f7 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0100b3c:	81 c3 14 7e 01 00    	add    $0x17e14,%ebx
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100b42:	83 ec 08             	sub    $0x8,%esp
c0100b45:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100b48:	50                   	push   %eax
c0100b49:	ff 75 08             	pushl  0x8(%ebp)
c0100b4c:	e8 ee fb ff ff       	call   c010073f <debuginfo_eip>
c0100b51:	83 c4 10             	add    $0x10,%esp
c0100b54:	85 c0                	test   %eax,%eax
c0100b56:	74 17                	je     c0100b6f <print_debuginfo+0x42>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100b58:	83 ec 08             	sub    $0x8,%esp
c0100b5b:	ff 75 08             	pushl  0x8(%ebp)
c0100b5e:	8d 83 92 dd fe ff    	lea    -0x1226e(%ebx),%eax
c0100b64:	50                   	push   %eax
c0100b65:	e8 bf f7 ff ff       	call   c0100329 <cprintf>
c0100b6a:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100b6d:	eb 67                	jmp    c0100bd6 <print_debuginfo+0xa9>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100b6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b76:	eb 1c                	jmp    c0100b94 <print_debuginfo+0x67>
            fnname[j] = info.eip_fn_name[j];
c0100b78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b7e:	01 d0                	add    %edx,%eax
c0100b80:	0f b6 00             	movzbl (%eax),%eax
c0100b83:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b8c:	01 ca                	add    %ecx,%edx
c0100b8e:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100b90:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100b94:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b97:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100b9a:	7c dc                	jl     c0100b78 <print_debuginfo+0x4b>
        fnname[j] = '\0';
c0100b9c:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ba5:	01 d0                	add    %edx,%eax
c0100ba7:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100bad:	8b 55 08             	mov    0x8(%ebp),%edx
c0100bb0:	89 d1                	mov    %edx,%ecx
c0100bb2:	29 c1                	sub    %eax,%ecx
c0100bb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100bb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100bba:	83 ec 0c             	sub    $0xc,%esp
c0100bbd:	51                   	push   %ecx
c0100bbe:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100bc4:	51                   	push   %ecx
c0100bc5:	52                   	push   %edx
c0100bc6:	50                   	push   %eax
c0100bc7:	8d 83 ae dd fe ff    	lea    -0x12252(%ebx),%eax
c0100bcd:	50                   	push   %eax
c0100bce:	e8 56 f7 ff ff       	call   c0100329 <cprintf>
c0100bd3:	83 c4 20             	add    $0x20,%esp
}
c0100bd6:	90                   	nop
c0100bd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100bda:	c9                   	leave  
c0100bdb:	c3                   	ret    

c0100bdc <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100bdc:	55                   	push   %ebp
c0100bdd:	89 e5                	mov    %esp,%ebp
c0100bdf:	83 ec 10             	sub    $0x10,%esp
c0100be2:	e8 cb f6 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0100be7:	05 69 7d 01 00       	add    $0x17d69,%eax
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100bec:	8b 45 04             	mov    0x4(%ebp),%eax
c0100bef:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100bf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100bf5:	c9                   	leave  
c0100bf6:	c3                   	ret    

c0100bf7 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100bf7:	55                   	push   %ebp
c0100bf8:	89 e5                	mov    %esp,%ebp
c0100bfa:	53                   	push   %ebx
c0100bfb:	83 ec 24             	sub    $0x24,%esp
c0100bfe:	e8 b3 f6 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0100c03:	81 c3 4d 7d 01 00    	add    $0x17d4d,%ebx
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100c09:	89 e8                	mov    %ebp,%eax
c0100c0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100c0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c0100c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c14:	e8 c3 ff ff ff       	call   c0100bdc <read_eip>
c0100c19:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100c1c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100c23:	e9 93 00 00 00       	jmp    c0100cbb <print_stackframe+0xc4>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100c28:	83 ec 04             	sub    $0x4,%esp
c0100c2b:	ff 75 f0             	pushl  -0x10(%ebp)
c0100c2e:	ff 75 f4             	pushl  -0xc(%ebp)
c0100c31:	8d 83 c0 dd fe ff    	lea    -0x12240(%ebx),%eax
c0100c37:	50                   	push   %eax
c0100c38:	e8 ec f6 ff ff       	call   c0100329 <cprintf>
c0100c3d:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
c0100c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c43:	83 c0 08             	add    $0x8,%eax
c0100c46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100c49:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100c50:	eb 28                	jmp    c0100c7a <print_stackframe+0x83>
            cprintf("0x%08x ", args[j]);
c0100c52:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100c55:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100c5f:	01 d0                	add    %edx,%eax
c0100c61:	8b 00                	mov    (%eax),%eax
c0100c63:	83 ec 08             	sub    $0x8,%esp
c0100c66:	50                   	push   %eax
c0100c67:	8d 83 dc dd fe ff    	lea    -0x12224(%ebx),%eax
c0100c6d:	50                   	push   %eax
c0100c6e:	e8 b6 f6 ff ff       	call   c0100329 <cprintf>
c0100c73:	83 c4 10             	add    $0x10,%esp
        for (j = 0; j < 4; j ++) {
c0100c76:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100c7a:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100c7e:	7e d2                	jle    c0100c52 <print_stackframe+0x5b>
        }
        cprintf("\n");
c0100c80:	83 ec 0c             	sub    $0xc,%esp
c0100c83:	8d 83 e4 dd fe ff    	lea    -0x1221c(%ebx),%eax
c0100c89:	50                   	push   %eax
c0100c8a:	e8 9a f6 ff ff       	call   c0100329 <cprintf>
c0100c8f:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
c0100c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100c95:	83 e8 01             	sub    $0x1,%eax
c0100c98:	83 ec 0c             	sub    $0xc,%esp
c0100c9b:	50                   	push   %eax
c0100c9c:	e8 8c fe ff ff       	call   c0100b2d <print_debuginfo>
c0100ca1:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
c0100ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca7:	83 c0 04             	add    $0x4,%eax
c0100caa:	8b 00                	mov    (%eax),%eax
c0100cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cb2:	8b 00                	mov    (%eax),%eax
c0100cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100cb7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100cbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cbf:	74 0a                	je     c0100ccb <print_stackframe+0xd4>
c0100cc1:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100cc5:	0f 8e 5d ff ff ff    	jle    c0100c28 <print_stackframe+0x31>
    }
}
c0100ccb:	90                   	nop
c0100ccc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100ccf:	c9                   	leave  
c0100cd0:	c3                   	ret    

c0100cd1 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100cd1:	55                   	push   %ebp
c0100cd2:	89 e5                	mov    %esp,%ebp
c0100cd4:	53                   	push   %ebx
c0100cd5:	83 ec 14             	sub    $0x14,%esp
c0100cd8:	e8 d9 f5 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0100cdd:	81 c3 73 7c 01 00    	add    $0x17c73,%ebx
    int argc = 0;
c0100ce3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100cea:	eb 0c                	jmp    c0100cf8 <parse+0x27>
            *buf ++ = '\0';
c0100cec:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cef:	8d 50 01             	lea    0x1(%eax),%edx
c0100cf2:	89 55 08             	mov    %edx,0x8(%ebp)
c0100cf5:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100cf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cfb:	0f b6 00             	movzbl (%eax),%eax
c0100cfe:	84 c0                	test   %al,%al
c0100d00:	74 20                	je     c0100d22 <parse+0x51>
c0100d02:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d05:	0f b6 00             	movzbl (%eax),%eax
c0100d08:	0f be c0             	movsbl %al,%eax
c0100d0b:	83 ec 08             	sub    $0x8,%esp
c0100d0e:	50                   	push   %eax
c0100d0f:	8d 83 68 de fe ff    	lea    -0x12198(%ebx),%eax
c0100d15:	50                   	push   %eax
c0100d16:	e8 17 4e 00 00       	call   c0105b32 <strchr>
c0100d1b:	83 c4 10             	add    $0x10,%esp
c0100d1e:	85 c0                	test   %eax,%eax
c0100d20:	75 ca                	jne    c0100cec <parse+0x1b>
        }
        if (*buf == '\0') {
c0100d22:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d25:	0f b6 00             	movzbl (%eax),%eax
c0100d28:	84 c0                	test   %al,%al
c0100d2a:	74 69                	je     c0100d95 <parse+0xc4>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100d2c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100d30:	75 14                	jne    c0100d46 <parse+0x75>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100d32:	83 ec 08             	sub    $0x8,%esp
c0100d35:	6a 10                	push   $0x10
c0100d37:	8d 83 6d de fe ff    	lea    -0x12193(%ebx),%eax
c0100d3d:	50                   	push   %eax
c0100d3e:	e8 e6 f5 ff ff       	call   c0100329 <cprintf>
c0100d43:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d49:	8d 50 01             	lea    0x1(%eax),%edx
c0100d4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100d4f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100d56:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d59:	01 c2                	add    %eax,%edx
c0100d5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d5e:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100d60:	eb 04                	jmp    c0100d66 <parse+0x95>
            buf ++;
c0100d62:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100d66:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d69:	0f b6 00             	movzbl (%eax),%eax
c0100d6c:	84 c0                	test   %al,%al
c0100d6e:	74 88                	je     c0100cf8 <parse+0x27>
c0100d70:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d73:	0f b6 00             	movzbl (%eax),%eax
c0100d76:	0f be c0             	movsbl %al,%eax
c0100d79:	83 ec 08             	sub    $0x8,%esp
c0100d7c:	50                   	push   %eax
c0100d7d:	8d 83 68 de fe ff    	lea    -0x12198(%ebx),%eax
c0100d83:	50                   	push   %eax
c0100d84:	e8 a9 4d 00 00       	call   c0105b32 <strchr>
c0100d89:	83 c4 10             	add    $0x10,%esp
c0100d8c:	85 c0                	test   %eax,%eax
c0100d8e:	74 d2                	je     c0100d62 <parse+0x91>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100d90:	e9 63 ff ff ff       	jmp    c0100cf8 <parse+0x27>
            break;
c0100d95:	90                   	nop
        }
    }
    return argc;
c0100d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100d99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100d9c:	c9                   	leave  
c0100d9d:	c3                   	ret    

c0100d9e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100d9e:	55                   	push   %ebp
c0100d9f:	89 e5                	mov    %esp,%ebp
c0100da1:	56                   	push   %esi
c0100da2:	53                   	push   %ebx
c0100da3:	83 ec 50             	sub    $0x50,%esp
c0100da6:	e8 0b f5 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0100dab:	81 c3 a5 7b 01 00    	add    $0x17ba5,%ebx
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100db1:	83 ec 08             	sub    $0x8,%esp
c0100db4:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100db7:	50                   	push   %eax
c0100db8:	ff 75 08             	pushl  0x8(%ebp)
c0100dbb:	e8 11 ff ff ff       	call   c0100cd1 <parse>
c0100dc0:	83 c4 10             	add    $0x10,%esp
c0100dc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100dc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100dca:	75 0a                	jne    c0100dd6 <runcmd+0x38>
        return 0;
c0100dcc:	b8 00 00 00 00       	mov    $0x0,%eax
c0100dd1:	e9 8b 00 00 00       	jmp    c0100e61 <runcmd+0xc3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100dd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100ddd:	eb 5f                	jmp    c0100e3e <runcmd+0xa0>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100ddf:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100de2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100de5:	8d b3 10 00 00 00    	lea    0x10(%ebx),%esi
c0100deb:	89 d0                	mov    %edx,%eax
c0100ded:	01 c0                	add    %eax,%eax
c0100def:	01 d0                	add    %edx,%eax
c0100df1:	c1 e0 02             	shl    $0x2,%eax
c0100df4:	01 f0                	add    %esi,%eax
c0100df6:	8b 00                	mov    (%eax),%eax
c0100df8:	83 ec 08             	sub    $0x8,%esp
c0100dfb:	51                   	push   %ecx
c0100dfc:	50                   	push   %eax
c0100dfd:	e8 7c 4c 00 00       	call   c0105a7e <strcmp>
c0100e02:	83 c4 10             	add    $0x10,%esp
c0100e05:	85 c0                	test   %eax,%eax
c0100e07:	75 31                	jne    c0100e3a <runcmd+0x9c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100e0c:	8d 8b 18 00 00 00    	lea    0x18(%ebx),%ecx
c0100e12:	89 d0                	mov    %edx,%eax
c0100e14:	01 c0                	add    %eax,%eax
c0100e16:	01 d0                	add    %edx,%eax
c0100e18:	c1 e0 02             	shl    $0x2,%eax
c0100e1b:	01 c8                	add    %ecx,%eax
c0100e1d:	8b 10                	mov    (%eax),%edx
c0100e1f:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100e22:	83 c0 04             	add    $0x4,%eax
c0100e25:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100e28:	83 e9 01             	sub    $0x1,%ecx
c0100e2b:	83 ec 04             	sub    $0x4,%esp
c0100e2e:	ff 75 0c             	pushl  0xc(%ebp)
c0100e31:	50                   	push   %eax
c0100e32:	51                   	push   %ecx
c0100e33:	ff d2                	call   *%edx
c0100e35:	83 c4 10             	add    $0x10,%esp
c0100e38:	eb 27                	jmp    c0100e61 <runcmd+0xc3>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100e3a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e41:	83 f8 02             	cmp    $0x2,%eax
c0100e44:	76 99                	jbe    c0100ddf <runcmd+0x41>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100e46:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100e49:	83 ec 08             	sub    $0x8,%esp
c0100e4c:	50                   	push   %eax
c0100e4d:	8d 83 8b de fe ff    	lea    -0x12175(%ebx),%eax
c0100e53:	50                   	push   %eax
c0100e54:	e8 d0 f4 ff ff       	call   c0100329 <cprintf>
c0100e59:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100e5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e61:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0100e64:	5b                   	pop    %ebx
c0100e65:	5e                   	pop    %esi
c0100e66:	5d                   	pop    %ebp
c0100e67:	c3                   	ret    

c0100e68 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100e68:	55                   	push   %ebp
c0100e69:	89 e5                	mov    %esp,%ebp
c0100e6b:	53                   	push   %ebx
c0100e6c:	83 ec 14             	sub    $0x14,%esp
c0100e6f:	e8 42 f4 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0100e74:	81 c3 dc 7a 01 00    	add    $0x17adc,%ebx
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100e7a:	83 ec 0c             	sub    $0xc,%esp
c0100e7d:	8d 83 a4 de fe ff    	lea    -0x1215c(%ebx),%eax
c0100e83:	50                   	push   %eax
c0100e84:	e8 a0 f4 ff ff       	call   c0100329 <cprintf>
c0100e89:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100e8c:	83 ec 0c             	sub    $0xc,%esp
c0100e8f:	8d 83 cc de fe ff    	lea    -0x12134(%ebx),%eax
c0100e95:	50                   	push   %eax
c0100e96:	e8 8e f4 ff ff       	call   c0100329 <cprintf>
c0100e9b:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100e9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100ea2:	74 0e                	je     c0100eb2 <kmonitor+0x4a>
        print_trapframe(tf);
c0100ea4:	83 ec 0c             	sub    $0xc,%esp
c0100ea7:	ff 75 08             	pushl  0x8(%ebp)
c0100eaa:	e8 10 0f 00 00       	call   c0101dbf <print_trapframe>
c0100eaf:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100eb2:	83 ec 0c             	sub    $0xc,%esp
c0100eb5:	8d 83 f1 de fe ff    	lea    -0x1210f(%ebx),%eax
c0100ebb:	50                   	push   %eax
c0100ebc:	e8 40 f5 ff ff       	call   c0100401 <readline>
c0100ec1:	83 c4 10             	add    $0x10,%esp
c0100ec4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100ec7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100ecb:	74 e5                	je     c0100eb2 <kmonitor+0x4a>
            if (runcmd(buf, tf) < 0) {
c0100ecd:	83 ec 08             	sub    $0x8,%esp
c0100ed0:	ff 75 08             	pushl  0x8(%ebp)
c0100ed3:	ff 75 f4             	pushl  -0xc(%ebp)
c0100ed6:	e8 c3 fe ff ff       	call   c0100d9e <runcmd>
c0100edb:	83 c4 10             	add    $0x10,%esp
c0100ede:	85 c0                	test   %eax,%eax
c0100ee0:	78 02                	js     c0100ee4 <kmonitor+0x7c>
        if ((buf = readline("K> ")) != NULL) {
c0100ee2:	eb ce                	jmp    c0100eb2 <kmonitor+0x4a>
                break;
c0100ee4:	90                   	nop
            }
        }
    }
}
c0100ee5:	90                   	nop
c0100ee6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100ee9:	c9                   	leave  
c0100eea:	c3                   	ret    

c0100eeb <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100eeb:	55                   	push   %ebp
c0100eec:	89 e5                	mov    %esp,%ebp
c0100eee:	56                   	push   %esi
c0100eef:	53                   	push   %ebx
c0100ef0:	83 ec 10             	sub    $0x10,%esp
c0100ef3:	e8 be f3 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0100ef8:	81 c3 58 7a 01 00    	add    $0x17a58,%ebx
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100efe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100f05:	eb 44                	jmp    c0100f4b <mon_help+0x60>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100f0a:	8d 8b 14 00 00 00    	lea    0x14(%ebx),%ecx
c0100f10:	89 d0                	mov    %edx,%eax
c0100f12:	01 c0                	add    %eax,%eax
c0100f14:	01 d0                	add    %edx,%eax
c0100f16:	c1 e0 02             	shl    $0x2,%eax
c0100f19:	01 c8                	add    %ecx,%eax
c0100f1b:	8b 08                	mov    (%eax),%ecx
c0100f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100f20:	8d b3 10 00 00 00    	lea    0x10(%ebx),%esi
c0100f26:	89 d0                	mov    %edx,%eax
c0100f28:	01 c0                	add    %eax,%eax
c0100f2a:	01 d0                	add    %edx,%eax
c0100f2c:	c1 e0 02             	shl    $0x2,%eax
c0100f2f:	01 f0                	add    %esi,%eax
c0100f31:	8b 00                	mov    (%eax),%eax
c0100f33:	83 ec 04             	sub    $0x4,%esp
c0100f36:	51                   	push   %ecx
c0100f37:	50                   	push   %eax
c0100f38:	8d 83 f5 de fe ff    	lea    -0x1210b(%ebx),%eax
c0100f3e:	50                   	push   %eax
c0100f3f:	e8 e5 f3 ff ff       	call   c0100329 <cprintf>
c0100f44:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
c0100f47:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f4e:	83 f8 02             	cmp    $0x2,%eax
c0100f51:	76 b4                	jbe    c0100f07 <mon_help+0x1c>
    }
    return 0;
c0100f53:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100f58:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0100f5b:	5b                   	pop    %ebx
c0100f5c:	5e                   	pop    %esi
c0100f5d:	5d                   	pop    %ebp
c0100f5e:	c3                   	ret    

c0100f5f <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100f5f:	55                   	push   %ebp
c0100f60:	89 e5                	mov    %esp,%ebp
c0100f62:	53                   	push   %ebx
c0100f63:	83 ec 04             	sub    $0x4,%esp
c0100f66:	e8 47 f3 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0100f6b:	05 e5 79 01 00       	add    $0x179e5,%eax
    print_kerninfo();
c0100f70:	89 c3                	mov    %eax,%ebx
c0100f72:	e8 f1 fa ff ff       	call   c0100a68 <print_kerninfo>
    return 0;
c0100f77:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100f7c:	83 c4 04             	add    $0x4,%esp
c0100f7f:	5b                   	pop    %ebx
c0100f80:	5d                   	pop    %ebp
c0100f81:	c3                   	ret    

c0100f82 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100f82:	55                   	push   %ebp
c0100f83:	89 e5                	mov    %esp,%ebp
c0100f85:	53                   	push   %ebx
c0100f86:	83 ec 04             	sub    $0x4,%esp
c0100f89:	e8 24 f3 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0100f8e:	05 c2 79 01 00       	add    $0x179c2,%eax
    print_stackframe();
c0100f93:	89 c3                	mov    %eax,%ebx
c0100f95:	e8 5d fc ff ff       	call   c0100bf7 <print_stackframe>
    return 0;
c0100f9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100f9f:	83 c4 04             	add    $0x4,%esp
c0100fa2:	5b                   	pop    %ebx
c0100fa3:	5d                   	pop    %ebp
c0100fa4:	c3                   	ret    

c0100fa5 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100fa5:	55                   	push   %ebp
c0100fa6:	89 e5                	mov    %esp,%ebp
c0100fa8:	53                   	push   %ebx
c0100fa9:	83 ec 14             	sub    $0x14,%esp
c0100fac:	e8 05 f3 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0100fb1:	81 c3 9f 79 01 00    	add    $0x1799f,%ebx
c0100fb7:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100fbd:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fc1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fc5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fc9:	ee                   	out    %al,(%dx)
c0100fca:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100fd0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100fd4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fd8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fdc:	ee                   	out    %al,(%dx)
c0100fdd:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100fe3:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
c0100fe7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100feb:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fef:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100ff0:	c7 c0 0c bf 11 c0    	mov    $0xc011bf0c,%eax
c0100ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("++ setup timer interrupts\n");
c0100ffc:	83 ec 0c             	sub    $0xc,%esp
c0100fff:	8d 83 fe de fe ff    	lea    -0x12102(%ebx),%eax
c0101005:	50                   	push   %eax
c0101006:	e8 1e f3 ff ff       	call   c0100329 <cprintf>
c010100b:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c010100e:	83 ec 0c             	sub    $0xc,%esp
c0101011:	6a 00                	push   $0x0
c0101013:	e8 76 0a 00 00       	call   c0101a8e <pic_enable>
c0101018:	83 c4 10             	add    $0x10,%esp
}
c010101b:	90                   	nop
c010101c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010101f:	c9                   	leave  
c0101020:	c3                   	ret    

c0101021 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0101021:	55                   	push   %ebp
c0101022:	89 e5                	mov    %esp,%ebp
c0101024:	53                   	push   %ebx
c0101025:	83 ec 14             	sub    $0x14,%esp
c0101028:	e8 85 f2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010102d:	05 23 79 01 00       	add    $0x17923,%eax
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0101032:	9c                   	pushf  
c0101033:	5a                   	pop    %edx
c0101034:	89 55 f4             	mov    %edx,-0xc(%ebp)
    return eflags;
c0101037:	8b 55 f4             	mov    -0xc(%ebp),%edx
    if (read_eflags() & FL_IF) {
c010103a:	81 e2 00 02 00 00    	and    $0x200,%edx
c0101040:	85 d2                	test   %edx,%edx
c0101042:	74 0e                	je     c0101052 <__intr_save+0x31>
        intr_disable();
c0101044:	89 c3                	mov    %eax,%ebx
c0101046:	e8 d5 0b 00 00       	call   c0101c20 <intr_disable>
        return 1;
c010104b:	b8 01 00 00 00       	mov    $0x1,%eax
c0101050:	eb 05                	jmp    c0101057 <__intr_save+0x36>
    }
    return 0;
c0101052:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101057:	83 c4 14             	add    $0x14,%esp
c010105a:	5b                   	pop    %ebx
c010105b:	5d                   	pop    %ebp
c010105c:	c3                   	ret    

c010105d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010105d:	55                   	push   %ebp
c010105e:	89 e5                	mov    %esp,%ebp
c0101060:	53                   	push   %ebx
c0101061:	83 ec 04             	sub    $0x4,%esp
c0101064:	e8 49 f2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0101069:	05 e7 78 01 00       	add    $0x178e7,%eax
    if (flag) {
c010106e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0101072:	74 07                	je     c010107b <__intr_restore+0x1e>
        intr_enable();
c0101074:	89 c3                	mov    %eax,%ebx
c0101076:	e8 94 0b 00 00       	call   c0101c0f <intr_enable>
    }
}
c010107b:	90                   	nop
c010107c:	83 c4 04             	add    $0x4,%esp
c010107f:	5b                   	pop    %ebx
c0101080:	5d                   	pop    %ebp
c0101081:	c3                   	ret    

c0101082 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0101082:	55                   	push   %ebp
c0101083:	89 e5                	mov    %esp,%ebp
c0101085:	83 ec 10             	sub    $0x10,%esp
c0101088:	e8 25 f2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010108d:	05 c3 78 01 00       	add    $0x178c3,%eax
c0101092:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101098:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010109c:	89 c2                	mov    %eax,%edx
c010109e:	ec                   	in     (%dx),%al
c010109f:	88 45 f1             	mov    %al,-0xf(%ebp)
c01010a2:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c01010a8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010ac:	89 c2                	mov    %eax,%edx
c01010ae:	ec                   	in     (%dx),%al
c01010af:	88 45 f5             	mov    %al,-0xb(%ebp)
c01010b2:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c01010b8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010bc:	89 c2                	mov    %eax,%edx
c01010be:	ec                   	in     (%dx),%al
c01010bf:	88 45 f9             	mov    %al,-0x7(%ebp)
c01010c2:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c01010c8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01010cc:	89 c2                	mov    %eax,%edx
c01010ce:	ec                   	in     (%dx),%al
c01010cf:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c01010d2:	90                   	nop
c01010d3:	c9                   	leave  
c01010d4:	c3                   	ret    

c01010d5 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c01010d5:	55                   	push   %ebp
c01010d6:	89 e5                	mov    %esp,%ebp
c01010d8:	83 ec 20             	sub    $0x20,%esp
c01010db:	e8 45 09 00 00       	call   c0101a25 <__x86.get_pc_thunk.cx>
c01010e0:	81 c1 70 78 01 00    	add    $0x17870,%ecx
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c01010e6:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c01010ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01010f0:	0f b7 00             	movzwl (%eax),%eax
c01010f3:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c01010f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01010fa:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c01010ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101102:	0f b7 00             	movzwl (%eax),%eax
c0101105:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0101109:	74 12                	je     c010111d <cga_init+0x48>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c010110b:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0101112:	66 c7 81 f6 2a 00 00 	movw   $0x3b4,0x2af6(%ecx)
c0101119:	b4 03 
c010111b:	eb 13                	jmp    c0101130 <cga_init+0x5b>
    } else {
        *cp = was;
c010111d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101120:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101124:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0101127:	66 c7 81 f6 2a 00 00 	movw   $0x3d4,0x2af6(%ecx)
c010112e:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0101130:	0f b7 81 f6 2a 00 00 	movzwl 0x2af6(%ecx),%eax
c0101137:	0f b7 c0             	movzwl %ax,%eax
c010113a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c010113e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101142:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101146:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010114a:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c010114b:	0f b7 81 f6 2a 00 00 	movzwl 0x2af6(%ecx),%eax
c0101152:	83 c0 01             	add    $0x1,%eax
c0101155:	0f b7 c0             	movzwl %ax,%eax
c0101158:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010115c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101160:	89 c2                	mov    %eax,%edx
c0101162:	ec                   	in     (%dx),%al
c0101163:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0101166:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010116a:	0f b6 c0             	movzbl %al,%eax
c010116d:	c1 e0 08             	shl    $0x8,%eax
c0101170:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0101173:	0f b7 81 f6 2a 00 00 	movzwl 0x2af6(%ecx),%eax
c010117a:	0f b7 c0             	movzwl %ax,%eax
c010117d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101181:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101185:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101189:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010118d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c010118e:	0f b7 81 f6 2a 00 00 	movzwl 0x2af6(%ecx),%eax
c0101195:	83 c0 01             	add    $0x1,%eax
c0101198:	0f b7 c0             	movzwl %ax,%eax
c010119b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010119f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01011a3:	89 c2                	mov    %eax,%edx
c01011a5:	ec                   	in     (%dx),%al
c01011a6:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c01011a9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01011ad:	0f b6 c0             	movzbl %al,%eax
c01011b0:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c01011b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01011b6:	89 81 f0 2a 00 00    	mov    %eax,0x2af0(%ecx)
    crt_pos = pos;
c01011bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01011bf:	66 89 81 f4 2a 00 00 	mov    %ax,0x2af4(%ecx)
}
c01011c6:	90                   	nop
c01011c7:	c9                   	leave  
c01011c8:	c3                   	ret    

c01011c9 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c01011c9:	55                   	push   %ebp
c01011ca:	89 e5                	mov    %esp,%ebp
c01011cc:	53                   	push   %ebx
c01011cd:	83 ec 34             	sub    $0x34,%esp
c01011d0:	e8 50 08 00 00       	call   c0101a25 <__x86.get_pc_thunk.cx>
c01011d5:	81 c1 7b 77 01 00    	add    $0x1777b,%ecx
c01011db:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c01011e1:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01011e5:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01011e9:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01011ed:	ee                   	out    %al,(%dx)
c01011ee:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c01011f4:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
c01011f8:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01011fc:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101200:	ee                   	out    %al,(%dx)
c0101201:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0101207:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
c010120b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010120f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101213:	ee                   	out    %al,(%dx)
c0101214:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c010121a:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c010121e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101222:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101226:	ee                   	out    %al,(%dx)
c0101227:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c010122d:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
c0101231:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101235:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101239:	ee                   	out    %al,(%dx)
c010123a:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0101240:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
c0101244:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101248:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010124c:	ee                   	out    %al,(%dx)
c010124d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101253:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
c0101257:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010125b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010125f:	ee                   	out    %al,(%dx)
c0101260:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101266:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c010126a:	89 c2                	mov    %eax,%edx
c010126c:	ec                   	in     (%dx),%al
c010126d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101270:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101274:	3c ff                	cmp    $0xff,%al
c0101276:	0f 95 c0             	setne  %al
c0101279:	0f b6 c0             	movzbl %al,%eax
c010127c:	89 81 f8 2a 00 00    	mov    %eax,0x2af8(%ecx)
c0101282:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101288:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010128c:	89 c2                	mov    %eax,%edx
c010128e:	ec                   	in     (%dx),%al
c010128f:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101292:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101298:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010129c:	89 c2                	mov    %eax,%edx
c010129e:	ec                   	in     (%dx),%al
c010129f:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c01012a2:	8b 81 f8 2a 00 00    	mov    0x2af8(%ecx),%eax
c01012a8:	85 c0                	test   %eax,%eax
c01012aa:	74 0f                	je     c01012bb <serial_init+0xf2>
        pic_enable(IRQ_COM1);
c01012ac:	83 ec 0c             	sub    $0xc,%esp
c01012af:	6a 04                	push   $0x4
c01012b1:	89 cb                	mov    %ecx,%ebx
c01012b3:	e8 d6 07 00 00       	call   c0101a8e <pic_enable>
c01012b8:	83 c4 10             	add    $0x10,%esp
    }
}
c01012bb:	90                   	nop
c01012bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01012bf:	c9                   	leave  
c01012c0:	c3                   	ret    

c01012c1 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01012c1:	55                   	push   %ebp
c01012c2:	89 e5                	mov    %esp,%ebp
c01012c4:	83 ec 20             	sub    $0x20,%esp
c01012c7:	e8 e6 ef ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01012cc:	05 84 76 01 00       	add    $0x17684,%eax
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01012d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d8:	eb 09                	jmp    c01012e3 <lpt_putc_sub+0x22>
        delay();
c01012da:	e8 a3 fd ff ff       	call   c0101082 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01012df:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012e3:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01012e9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012ed:	89 c2                	mov    %eax,%edx
c01012ef:	ec                   	in     (%dx),%al
c01012f0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012f3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f7:	84 c0                	test   %al,%al
c01012f9:	78 09                	js     c0101304 <lpt_putc_sub+0x43>
c01012fb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101302:	7e d6                	jle    c01012da <lpt_putc_sub+0x19>
    }
    outb(LPTPORT + 0, c);
c0101304:	8b 45 08             	mov    0x8(%ebp),%eax
c0101307:	0f b6 c0             	movzbl %al,%eax
c010130a:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101310:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101313:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101317:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010131b:	ee                   	out    %al,(%dx)
c010131c:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101322:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101326:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010132a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010132e:	ee                   	out    %al,(%dx)
c010132f:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101335:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
c0101339:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010133d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101341:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101342:	90                   	nop
c0101343:	c9                   	leave  
c0101344:	c3                   	ret    

c0101345 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101345:	55                   	push   %ebp
c0101346:	89 e5                	mov    %esp,%ebp
c0101348:	e8 65 ef ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010134d:	05 03 76 01 00       	add    $0x17603,%eax
    if (c != '\b') {
c0101352:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101356:	74 0d                	je     c0101365 <lpt_putc+0x20>
        lpt_putc_sub(c);
c0101358:	ff 75 08             	pushl  0x8(%ebp)
c010135b:	e8 61 ff ff ff       	call   c01012c1 <lpt_putc_sub>
c0101360:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101363:	eb 1e                	jmp    c0101383 <lpt_putc+0x3e>
        lpt_putc_sub('\b');
c0101365:	6a 08                	push   $0x8
c0101367:	e8 55 ff ff ff       	call   c01012c1 <lpt_putc_sub>
c010136c:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c010136f:	6a 20                	push   $0x20
c0101371:	e8 4b ff ff ff       	call   c01012c1 <lpt_putc_sub>
c0101376:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c0101379:	6a 08                	push   $0x8
c010137b:	e8 41 ff ff ff       	call   c01012c1 <lpt_putc_sub>
c0101380:	83 c4 04             	add    $0x4,%esp
}
c0101383:	90                   	nop
c0101384:	c9                   	leave  
c0101385:	c3                   	ret    

c0101386 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101386:	55                   	push   %ebp
c0101387:	89 e5                	mov    %esp,%ebp
c0101389:	56                   	push   %esi
c010138a:	53                   	push   %ebx
c010138b:	83 ec 20             	sub    $0x20,%esp
c010138e:	e8 23 ef ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0101393:	81 c3 bd 75 01 00    	add    $0x175bd,%ebx
    // set black on white
    if (!(c & ~0xFF)) {
c0101399:	8b 45 08             	mov    0x8(%ebp),%eax
c010139c:	b0 00                	mov    $0x0,%al
c010139e:	85 c0                	test   %eax,%eax
c01013a0:	75 07                	jne    c01013a9 <cga_putc+0x23>
        c |= 0x0700;
c01013a2:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01013a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ac:	0f b6 c0             	movzbl %al,%eax
c01013af:	83 f8 0a             	cmp    $0xa,%eax
c01013b2:	74 54                	je     c0101408 <cga_putc+0x82>
c01013b4:	83 f8 0d             	cmp    $0xd,%eax
c01013b7:	74 60                	je     c0101419 <cga_putc+0x93>
c01013b9:	83 f8 08             	cmp    $0x8,%eax
c01013bc:	0f 85 92 00 00 00    	jne    c0101454 <cga_putc+0xce>
    case '\b':
        if (crt_pos > 0) {
c01013c2:	0f b7 83 f4 2a 00 00 	movzwl 0x2af4(%ebx),%eax
c01013c9:	66 85 c0             	test   %ax,%ax
c01013cc:	0f 84 a8 00 00 00    	je     c010147a <cga_putc+0xf4>
            crt_pos --;
c01013d2:	0f b7 83 f4 2a 00 00 	movzwl 0x2af4(%ebx),%eax
c01013d9:	83 e8 01             	sub    $0x1,%eax
c01013dc:	66 89 83 f4 2a 00 00 	mov    %ax,0x2af4(%ebx)
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01013e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01013e6:	b0 00                	mov    $0x0,%al
c01013e8:	83 c8 20             	or     $0x20,%eax
c01013eb:	89 c1                	mov    %eax,%ecx
c01013ed:	8b 83 f0 2a 00 00    	mov    0x2af0(%ebx),%eax
c01013f3:	0f b7 93 f4 2a 00 00 	movzwl 0x2af4(%ebx),%edx
c01013fa:	0f b7 d2             	movzwl %dx,%edx
c01013fd:	01 d2                	add    %edx,%edx
c01013ff:	01 d0                	add    %edx,%eax
c0101401:	89 ca                	mov    %ecx,%edx
c0101403:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c0101406:	eb 72                	jmp    c010147a <cga_putc+0xf4>
    case '\n':
        crt_pos += CRT_COLS;
c0101408:	0f b7 83 f4 2a 00 00 	movzwl 0x2af4(%ebx),%eax
c010140f:	83 c0 50             	add    $0x50,%eax
c0101412:	66 89 83 f4 2a 00 00 	mov    %ax,0x2af4(%ebx)
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101419:	0f b7 b3 f4 2a 00 00 	movzwl 0x2af4(%ebx),%esi
c0101420:	0f b7 8b f4 2a 00 00 	movzwl 0x2af4(%ebx),%ecx
c0101427:	0f b7 c1             	movzwl %cx,%eax
c010142a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101430:	c1 e8 10             	shr    $0x10,%eax
c0101433:	89 c2                	mov    %eax,%edx
c0101435:	66 c1 ea 06          	shr    $0x6,%dx
c0101439:	89 d0                	mov    %edx,%eax
c010143b:	c1 e0 02             	shl    $0x2,%eax
c010143e:	01 d0                	add    %edx,%eax
c0101440:	c1 e0 04             	shl    $0x4,%eax
c0101443:	29 c1                	sub    %eax,%ecx
c0101445:	89 ca                	mov    %ecx,%edx
c0101447:	89 f0                	mov    %esi,%eax
c0101449:	29 d0                	sub    %edx,%eax
c010144b:	66 89 83 f4 2a 00 00 	mov    %ax,0x2af4(%ebx)
        break;
c0101452:	eb 27                	jmp    c010147b <cga_putc+0xf5>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101454:	8b 8b f0 2a 00 00    	mov    0x2af0(%ebx),%ecx
c010145a:	0f b7 83 f4 2a 00 00 	movzwl 0x2af4(%ebx),%eax
c0101461:	8d 50 01             	lea    0x1(%eax),%edx
c0101464:	66 89 93 f4 2a 00 00 	mov    %dx,0x2af4(%ebx)
c010146b:	0f b7 c0             	movzwl %ax,%eax
c010146e:	01 c0                	add    %eax,%eax
c0101470:	01 c8                	add    %ecx,%eax
c0101472:	8b 55 08             	mov    0x8(%ebp),%edx
c0101475:	66 89 10             	mov    %dx,(%eax)
        break;
c0101478:	eb 01                	jmp    c010147b <cga_putc+0xf5>
        break;
c010147a:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010147b:	0f b7 83 f4 2a 00 00 	movzwl 0x2af4(%ebx),%eax
c0101482:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101486:	76 5d                	jbe    c01014e5 <cga_putc+0x15f>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101488:	8b 83 f0 2a 00 00    	mov    0x2af0(%ebx),%eax
c010148e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101494:	8b 83 f0 2a 00 00    	mov    0x2af0(%ebx),%eax
c010149a:	83 ec 04             	sub    $0x4,%esp
c010149d:	68 00 0f 00 00       	push   $0xf00
c01014a2:	52                   	push   %edx
c01014a3:	50                   	push   %eax
c01014a4:	e8 b0 48 00 00       	call   c0105d59 <memmove>
c01014a9:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01014ac:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01014b3:	eb 16                	jmp    c01014cb <cga_putc+0x145>
            crt_buf[i] = 0x0700 | ' ';
c01014b5:	8b 83 f0 2a 00 00    	mov    0x2af0(%ebx),%eax
c01014bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01014be:	01 d2                	add    %edx,%edx
c01014c0:	01 d0                	add    %edx,%eax
c01014c2:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01014c7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01014cb:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01014d2:	7e e1                	jle    c01014b5 <cga_putc+0x12f>
        }
        crt_pos -= CRT_COLS;
c01014d4:	0f b7 83 f4 2a 00 00 	movzwl 0x2af4(%ebx),%eax
c01014db:	83 e8 50             	sub    $0x50,%eax
c01014de:	66 89 83 f4 2a 00 00 	mov    %ax,0x2af4(%ebx)
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01014e5:	0f b7 83 f6 2a 00 00 	movzwl 0x2af6(%ebx),%eax
c01014ec:	0f b7 c0             	movzwl %ax,%eax
c01014ef:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01014f3:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c01014f7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01014fb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01014ff:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101500:	0f b7 83 f4 2a 00 00 	movzwl 0x2af4(%ebx),%eax
c0101507:	66 c1 e8 08          	shr    $0x8,%ax
c010150b:	0f b6 c0             	movzbl %al,%eax
c010150e:	0f b7 93 f6 2a 00 00 	movzwl 0x2af6(%ebx),%edx
c0101515:	83 c2 01             	add    $0x1,%edx
c0101518:	0f b7 d2             	movzwl %dx,%edx
c010151b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010151f:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101522:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101526:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010152a:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010152b:	0f b7 83 f6 2a 00 00 	movzwl 0x2af6(%ebx),%eax
c0101532:	0f b7 c0             	movzwl %ax,%eax
c0101535:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101539:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c010153d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101541:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101545:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101546:	0f b7 83 f4 2a 00 00 	movzwl 0x2af4(%ebx),%eax
c010154d:	0f b6 c0             	movzbl %al,%eax
c0101550:	0f b7 93 f6 2a 00 00 	movzwl 0x2af6(%ebx),%edx
c0101557:	83 c2 01             	add    $0x1,%edx
c010155a:	0f b7 d2             	movzwl %dx,%edx
c010155d:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101561:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101564:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101568:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010156c:	ee                   	out    %al,(%dx)
}
c010156d:	90                   	nop
c010156e:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0101571:	5b                   	pop    %ebx
c0101572:	5e                   	pop    %esi
c0101573:	5d                   	pop    %ebp
c0101574:	c3                   	ret    

c0101575 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101575:	55                   	push   %ebp
c0101576:	89 e5                	mov    %esp,%ebp
c0101578:	83 ec 10             	sub    $0x10,%esp
c010157b:	e8 32 ed ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0101580:	05 d0 73 01 00       	add    $0x173d0,%eax
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101585:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010158c:	eb 09                	jmp    c0101597 <serial_putc_sub+0x22>
        delay();
c010158e:	e8 ef fa ff ff       	call   c0101082 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101593:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101597:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010159d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01015a1:	89 c2                	mov    %eax,%edx
c01015a3:	ec                   	in     (%dx),%al
c01015a4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01015a7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01015ab:	0f b6 c0             	movzbl %al,%eax
c01015ae:	83 e0 20             	and    $0x20,%eax
c01015b1:	85 c0                	test   %eax,%eax
c01015b3:	75 09                	jne    c01015be <serial_putc_sub+0x49>
c01015b5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01015bc:	7e d0                	jle    c010158e <serial_putc_sub+0x19>
    }
    outb(COM1 + COM_TX, c);
c01015be:	8b 45 08             	mov    0x8(%ebp),%eax
c01015c1:	0f b6 c0             	movzbl %al,%eax
c01015c4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01015ca:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015cd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01015d1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01015d5:	ee                   	out    %al,(%dx)
}
c01015d6:	90                   	nop
c01015d7:	c9                   	leave  
c01015d8:	c3                   	ret    

c01015d9 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01015d9:	55                   	push   %ebp
c01015da:	89 e5                	mov    %esp,%ebp
c01015dc:	e8 d1 ec ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01015e1:	05 6f 73 01 00       	add    $0x1736f,%eax
    if (c != '\b') {
c01015e6:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01015ea:	74 0d                	je     c01015f9 <serial_putc+0x20>
        serial_putc_sub(c);
c01015ec:	ff 75 08             	pushl  0x8(%ebp)
c01015ef:	e8 81 ff ff ff       	call   c0101575 <serial_putc_sub>
c01015f4:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01015f7:	eb 1e                	jmp    c0101617 <serial_putc+0x3e>
        serial_putc_sub('\b');
c01015f9:	6a 08                	push   $0x8
c01015fb:	e8 75 ff ff ff       	call   c0101575 <serial_putc_sub>
c0101600:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101603:	6a 20                	push   $0x20
c0101605:	e8 6b ff ff ff       	call   c0101575 <serial_putc_sub>
c010160a:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c010160d:	6a 08                	push   $0x8
c010160f:	e8 61 ff ff ff       	call   c0101575 <serial_putc_sub>
c0101614:	83 c4 04             	add    $0x4,%esp
}
c0101617:	90                   	nop
c0101618:	c9                   	leave  
c0101619:	c3                   	ret    

c010161a <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010161a:	55                   	push   %ebp
c010161b:	89 e5                	mov    %esp,%ebp
c010161d:	53                   	push   %ebx
c010161e:	83 ec 14             	sub    $0x14,%esp
c0101621:	e8 90 ec ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0101626:	81 c3 2a 73 01 00    	add    $0x1732a,%ebx
    int c;
    while ((c = (*proc)()) != -1) {
c010162c:	eb 36                	jmp    c0101664 <cons_intr+0x4a>
        if (c != 0) {
c010162e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101632:	74 30                	je     c0101664 <cons_intr+0x4a>
            cons.buf[cons.wpos ++] = c;
c0101634:	8b 83 14 2d 00 00    	mov    0x2d14(%ebx),%eax
c010163a:	8d 50 01             	lea    0x1(%eax),%edx
c010163d:	89 93 14 2d 00 00    	mov    %edx,0x2d14(%ebx)
c0101643:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101646:	88 94 03 10 2b 00 00 	mov    %dl,0x2b10(%ebx,%eax,1)
            if (cons.wpos == CONSBUFSIZE) {
c010164d:	8b 83 14 2d 00 00    	mov    0x2d14(%ebx),%eax
c0101653:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101658:	75 0a                	jne    c0101664 <cons_intr+0x4a>
                cons.wpos = 0;
c010165a:	c7 83 14 2d 00 00 00 	movl   $0x0,0x2d14(%ebx)
c0101661:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101664:	8b 45 08             	mov    0x8(%ebp),%eax
c0101667:	ff d0                	call   *%eax
c0101669:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010166c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101670:	75 bc                	jne    c010162e <cons_intr+0x14>
            }
        }
    }
}
c0101672:	90                   	nop
c0101673:	83 c4 14             	add    $0x14,%esp
c0101676:	5b                   	pop    %ebx
c0101677:	5d                   	pop    %ebp
c0101678:	c3                   	ret    

c0101679 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101679:	55                   	push   %ebp
c010167a:	89 e5                	mov    %esp,%ebp
c010167c:	83 ec 10             	sub    $0x10,%esp
c010167f:	e8 2e ec ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0101684:	05 cc 72 01 00       	add    $0x172cc,%eax
c0101689:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010168f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101693:	89 c2                	mov    %eax,%edx
c0101695:	ec                   	in     (%dx),%al
c0101696:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101699:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c010169d:	0f b6 c0             	movzbl %al,%eax
c01016a0:	83 e0 01             	and    $0x1,%eax
c01016a3:	85 c0                	test   %eax,%eax
c01016a5:	75 07                	jne    c01016ae <serial_proc_data+0x35>
        return -1;
c01016a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01016ac:	eb 2a                	jmp    c01016d8 <serial_proc_data+0x5f>
c01016ae:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016b4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01016b8:	89 c2                	mov    %eax,%edx
c01016ba:	ec                   	in     (%dx),%al
c01016bb:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01016be:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01016c2:	0f b6 c0             	movzbl %al,%eax
c01016c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01016c8:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01016cc:	75 07                	jne    c01016d5 <serial_proc_data+0x5c>
        c = '\b';
c01016ce:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01016d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01016d8:	c9                   	leave  
c01016d9:	c3                   	ret    

c01016da <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01016da:	55                   	push   %ebp
c01016db:	89 e5                	mov    %esp,%ebp
c01016dd:	83 ec 08             	sub    $0x8,%esp
c01016e0:	e8 cd eb ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01016e5:	05 6b 72 01 00       	add    $0x1726b,%eax
    if (serial_exists) {
c01016ea:	8b 90 f8 2a 00 00    	mov    0x2af8(%eax),%edx
c01016f0:	85 d2                	test   %edx,%edx
c01016f2:	74 12                	je     c0101706 <serial_intr+0x2c>
        cons_intr(serial_proc_data);
c01016f4:	83 ec 0c             	sub    $0xc,%esp
c01016f7:	8d 80 29 8d fe ff    	lea    -0x172d7(%eax),%eax
c01016fd:	50                   	push   %eax
c01016fe:	e8 17 ff ff ff       	call   c010161a <cons_intr>
c0101703:	83 c4 10             	add    $0x10,%esp
    }
}
c0101706:	90                   	nop
c0101707:	c9                   	leave  
c0101708:	c3                   	ret    

c0101709 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101709:	55                   	push   %ebp
c010170a:	89 e5                	mov    %esp,%ebp
c010170c:	53                   	push   %ebx
c010170d:	83 ec 24             	sub    $0x24,%esp
c0101710:	e8 10 03 00 00       	call   c0101a25 <__x86.get_pc_thunk.cx>
c0101715:	81 c1 3b 72 01 00    	add    $0x1723b,%ecx
c010171b:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101721:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101725:	89 c2                	mov    %eax,%edx
c0101727:	ec                   	in     (%dx),%al
c0101728:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010172b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010172f:	0f b6 c0             	movzbl %al,%eax
c0101732:	83 e0 01             	and    $0x1,%eax
c0101735:	85 c0                	test   %eax,%eax
c0101737:	75 0a                	jne    c0101743 <kbd_proc_data+0x3a>
        return -1;
c0101739:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010173e:	e9 73 01 00 00       	jmp    c01018b6 <kbd_proc_data+0x1ad>
c0101743:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101749:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010174d:	89 c2                	mov    %eax,%edx
c010174f:	ec                   	in     (%dx),%al
c0101750:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101753:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101757:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010175a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010175e:	75 19                	jne    c0101779 <kbd_proc_data+0x70>
        // E0 escape character
        shift |= E0ESC;
c0101760:	8b 81 18 2d 00 00    	mov    0x2d18(%ecx),%eax
c0101766:	83 c8 40             	or     $0x40,%eax
c0101769:	89 81 18 2d 00 00    	mov    %eax,0x2d18(%ecx)
        return 0;
c010176f:	b8 00 00 00 00       	mov    $0x0,%eax
c0101774:	e9 3d 01 00 00       	jmp    c01018b6 <kbd_proc_data+0x1ad>
    } else if (data & 0x80) {
c0101779:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010177d:	84 c0                	test   %al,%al
c010177f:	79 4b                	jns    c01017cc <kbd_proc_data+0xc3>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101781:	8b 81 18 2d 00 00    	mov    0x2d18(%ecx),%eax
c0101787:	83 e0 40             	and    $0x40,%eax
c010178a:	85 c0                	test   %eax,%eax
c010178c:	75 09                	jne    c0101797 <kbd_proc_data+0x8e>
c010178e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101792:	83 e0 7f             	and    $0x7f,%eax
c0101795:	eb 04                	jmp    c010179b <kbd_proc_data+0x92>
c0101797:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010179b:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010179e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01017a2:	0f b6 84 01 b0 f6 ff 	movzbl -0x950(%ecx,%eax,1),%eax
c01017a9:	ff 
c01017aa:	83 c8 40             	or     $0x40,%eax
c01017ad:	0f b6 c0             	movzbl %al,%eax
c01017b0:	f7 d0                	not    %eax
c01017b2:	89 c2                	mov    %eax,%edx
c01017b4:	8b 81 18 2d 00 00    	mov    0x2d18(%ecx),%eax
c01017ba:	21 d0                	and    %edx,%eax
c01017bc:	89 81 18 2d 00 00    	mov    %eax,0x2d18(%ecx)
        return 0;
c01017c2:	b8 00 00 00 00       	mov    $0x0,%eax
c01017c7:	e9 ea 00 00 00       	jmp    c01018b6 <kbd_proc_data+0x1ad>
    } else if (shift & E0ESC) {
c01017cc:	8b 81 18 2d 00 00    	mov    0x2d18(%ecx),%eax
c01017d2:	83 e0 40             	and    $0x40,%eax
c01017d5:	85 c0                	test   %eax,%eax
c01017d7:	74 13                	je     c01017ec <kbd_proc_data+0xe3>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01017d9:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01017dd:	8b 81 18 2d 00 00    	mov    0x2d18(%ecx),%eax
c01017e3:	83 e0 bf             	and    $0xffffffbf,%eax
c01017e6:	89 81 18 2d 00 00    	mov    %eax,0x2d18(%ecx)
    }

    shift |= shiftcode[data];
c01017ec:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01017f0:	0f b6 84 01 b0 f6 ff 	movzbl -0x950(%ecx,%eax,1),%eax
c01017f7:	ff 
c01017f8:	0f b6 d0             	movzbl %al,%edx
c01017fb:	8b 81 18 2d 00 00    	mov    0x2d18(%ecx),%eax
c0101801:	09 d0                	or     %edx,%eax
c0101803:	89 81 18 2d 00 00    	mov    %eax,0x2d18(%ecx)
    shift ^= togglecode[data];
c0101809:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010180d:	0f b6 84 01 b0 f7 ff 	movzbl -0x850(%ecx,%eax,1),%eax
c0101814:	ff 
c0101815:	0f b6 d0             	movzbl %al,%edx
c0101818:	8b 81 18 2d 00 00    	mov    0x2d18(%ecx),%eax
c010181e:	31 d0                	xor    %edx,%eax
c0101820:	89 81 18 2d 00 00    	mov    %eax,0x2d18(%ecx)

    c = charcode[shift & (CTL | SHIFT)][data];
c0101826:	8b 81 18 2d 00 00    	mov    0x2d18(%ecx),%eax
c010182c:	83 e0 03             	and    $0x3,%eax
c010182f:	8b 94 81 34 00 00 00 	mov    0x34(%ecx,%eax,4),%edx
c0101836:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010183a:	01 d0                	add    %edx,%eax
c010183c:	0f b6 00             	movzbl (%eax),%eax
c010183f:	0f b6 c0             	movzbl %al,%eax
c0101842:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101845:	8b 81 18 2d 00 00    	mov    0x2d18(%ecx),%eax
c010184b:	83 e0 08             	and    $0x8,%eax
c010184e:	85 c0                	test   %eax,%eax
c0101850:	74 22                	je     c0101874 <kbd_proc_data+0x16b>
        if ('a' <= c && c <= 'z')
c0101852:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101856:	7e 0c                	jle    c0101864 <kbd_proc_data+0x15b>
c0101858:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010185c:	7f 06                	jg     c0101864 <kbd_proc_data+0x15b>
            c += 'A' - 'a';
c010185e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101862:	eb 10                	jmp    c0101874 <kbd_proc_data+0x16b>
        else if ('A' <= c && c <= 'Z')
c0101864:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101868:	7e 0a                	jle    c0101874 <kbd_proc_data+0x16b>
c010186a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010186e:	7f 04                	jg     c0101874 <kbd_proc_data+0x16b>
            c += 'a' - 'A';
c0101870:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101874:	8b 81 18 2d 00 00    	mov    0x2d18(%ecx),%eax
c010187a:	f7 d0                	not    %eax
c010187c:	83 e0 06             	and    $0x6,%eax
c010187f:	85 c0                	test   %eax,%eax
c0101881:	75 30                	jne    c01018b3 <kbd_proc_data+0x1aa>
c0101883:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010188a:	75 27                	jne    c01018b3 <kbd_proc_data+0x1aa>
        cprintf("Rebooting!\n");
c010188c:	83 ec 0c             	sub    $0xc,%esp
c010188f:	8d 81 19 df fe ff    	lea    -0x120e7(%ecx),%eax
c0101895:	50                   	push   %eax
c0101896:	89 cb                	mov    %ecx,%ebx
c0101898:	e8 8c ea ff ff       	call   c0100329 <cprintf>
c010189d:	83 c4 10             	add    $0x10,%esp
c01018a0:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01018a6:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018aa:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01018ae:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01018b2:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01018b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01018b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01018b9:	c9                   	leave  
c01018ba:	c3                   	ret    

c01018bb <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01018bb:	55                   	push   %ebp
c01018bc:	89 e5                	mov    %esp,%ebp
c01018be:	83 ec 08             	sub    $0x8,%esp
c01018c1:	e8 ec e9 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01018c6:	05 8a 70 01 00       	add    $0x1708a,%eax
    cons_intr(kbd_proc_data);
c01018cb:	83 ec 0c             	sub    $0xc,%esp
c01018ce:	8d 80 b9 8d fe ff    	lea    -0x17247(%eax),%eax
c01018d4:	50                   	push   %eax
c01018d5:	e8 40 fd ff ff       	call   c010161a <cons_intr>
c01018da:	83 c4 10             	add    $0x10,%esp
}
c01018dd:	90                   	nop
c01018de:	c9                   	leave  
c01018df:	c3                   	ret    

c01018e0 <kbd_init>:

static void
kbd_init(void) {
c01018e0:	55                   	push   %ebp
c01018e1:	89 e5                	mov    %esp,%ebp
c01018e3:	53                   	push   %ebx
c01018e4:	83 ec 04             	sub    $0x4,%esp
c01018e7:	e8 ca e9 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c01018ec:	81 c3 64 70 01 00    	add    $0x17064,%ebx
    // drain the kbd buffer
    kbd_intr();
c01018f2:	e8 c4 ff ff ff       	call   c01018bb <kbd_intr>
    pic_enable(IRQ_KBD);
c01018f7:	83 ec 0c             	sub    $0xc,%esp
c01018fa:	6a 01                	push   $0x1
c01018fc:	e8 8d 01 00 00       	call   c0101a8e <pic_enable>
c0101901:	83 c4 10             	add    $0x10,%esp
}
c0101904:	90                   	nop
c0101905:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101908:	c9                   	leave  
c0101909:	c3                   	ret    

c010190a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c010190a:	55                   	push   %ebp
c010190b:	89 e5                	mov    %esp,%ebp
c010190d:	53                   	push   %ebx
c010190e:	83 ec 04             	sub    $0x4,%esp
c0101911:	e8 a0 e9 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0101916:	81 c3 3a 70 01 00    	add    $0x1703a,%ebx
    cga_init();
c010191c:	e8 b4 f7 ff ff       	call   c01010d5 <cga_init>
    serial_init();
c0101921:	e8 a3 f8 ff ff       	call   c01011c9 <serial_init>
    kbd_init();
c0101926:	e8 b5 ff ff ff       	call   c01018e0 <kbd_init>
    if (!serial_exists) {
c010192b:	8b 83 f8 2a 00 00    	mov    0x2af8(%ebx),%eax
c0101931:	85 c0                	test   %eax,%eax
c0101933:	75 12                	jne    c0101947 <cons_init+0x3d>
        cprintf("serial port does not exist!!\n");
c0101935:	83 ec 0c             	sub    $0xc,%esp
c0101938:	8d 83 25 df fe ff    	lea    -0x120db(%ebx),%eax
c010193e:	50                   	push   %eax
c010193f:	e8 e5 e9 ff ff       	call   c0100329 <cprintf>
c0101944:	83 c4 10             	add    $0x10,%esp
    }
}
c0101947:	90                   	nop
c0101948:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010194b:	c9                   	leave  
c010194c:	c3                   	ret    

c010194d <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010194d:	55                   	push   %ebp
c010194e:	89 e5                	mov    %esp,%ebp
c0101950:	83 ec 18             	sub    $0x18,%esp
c0101953:	e8 5a e9 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0101958:	05 f8 6f 01 00       	add    $0x16ff8,%eax
    bool intr_flag;
    local_intr_save(intr_flag);
c010195d:	e8 bf f6 ff ff       	call   c0101021 <__intr_save>
c0101962:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101965:	83 ec 0c             	sub    $0xc,%esp
c0101968:	ff 75 08             	pushl  0x8(%ebp)
c010196b:	e8 d5 f9 ff ff       	call   c0101345 <lpt_putc>
c0101970:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c0101973:	83 ec 0c             	sub    $0xc,%esp
c0101976:	ff 75 08             	pushl  0x8(%ebp)
c0101979:	e8 08 fa ff ff       	call   c0101386 <cga_putc>
c010197e:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c0101981:	83 ec 0c             	sub    $0xc,%esp
c0101984:	ff 75 08             	pushl  0x8(%ebp)
c0101987:	e8 4d fc ff ff       	call   c01015d9 <serial_putc>
c010198c:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c010198f:	83 ec 0c             	sub    $0xc,%esp
c0101992:	ff 75 f4             	pushl  -0xc(%ebp)
c0101995:	e8 c3 f6 ff ff       	call   c010105d <__intr_restore>
c010199a:	83 c4 10             	add    $0x10,%esp
}
c010199d:	90                   	nop
c010199e:	c9                   	leave  
c010199f:	c3                   	ret    

c01019a0 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01019a0:	55                   	push   %ebp
c01019a1:	89 e5                	mov    %esp,%ebp
c01019a3:	53                   	push   %ebx
c01019a4:	83 ec 14             	sub    $0x14,%esp
c01019a7:	e8 0a e9 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c01019ac:	81 c3 a4 6f 01 00    	add    $0x16fa4,%ebx
    int c = 0;
c01019b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01019b9:	e8 63 f6 ff ff       	call   c0101021 <__intr_save>
c01019be:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01019c1:	e8 14 fd ff ff       	call   c01016da <serial_intr>
        kbd_intr();
c01019c6:	e8 f0 fe ff ff       	call   c01018bb <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01019cb:	8b 93 10 2d 00 00    	mov    0x2d10(%ebx),%edx
c01019d1:	8b 83 14 2d 00 00    	mov    0x2d14(%ebx),%eax
c01019d7:	39 c2                	cmp    %eax,%edx
c01019d9:	74 34                	je     c0101a0f <cons_getc+0x6f>
            c = cons.buf[cons.rpos ++];
c01019db:	8b 83 10 2d 00 00    	mov    0x2d10(%ebx),%eax
c01019e1:	8d 50 01             	lea    0x1(%eax),%edx
c01019e4:	89 93 10 2d 00 00    	mov    %edx,0x2d10(%ebx)
c01019ea:	0f b6 84 03 10 2b 00 	movzbl 0x2b10(%ebx,%eax,1),%eax
c01019f1:	00 
c01019f2:	0f b6 c0             	movzbl %al,%eax
c01019f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01019f8:	8b 83 10 2d 00 00    	mov    0x2d10(%ebx),%eax
c01019fe:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101a03:	75 0a                	jne    c0101a0f <cons_getc+0x6f>
                cons.rpos = 0;
c0101a05:	c7 83 10 2d 00 00 00 	movl   $0x0,0x2d10(%ebx)
c0101a0c:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101a0f:	83 ec 0c             	sub    $0xc,%esp
c0101a12:	ff 75 f0             	pushl  -0x10(%ebp)
c0101a15:	e8 43 f6 ff ff       	call   c010105d <__intr_restore>
c0101a1a:	83 c4 10             	add    $0x10,%esp
    return c;
c0101a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101a20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101a23:	c9                   	leave  
c0101a24:	c3                   	ret    

c0101a25 <__x86.get_pc_thunk.cx>:
c0101a25:	8b 0c 24             	mov    (%esp),%ecx
c0101a28:	c3                   	ret    

c0101a29 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101a29:	55                   	push   %ebp
c0101a2a:	89 e5                	mov    %esp,%ebp
c0101a2c:	83 ec 14             	sub    $0x14,%esp
c0101a2f:	e8 7e e8 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0101a34:	05 1c 6f 01 00       	add    $0x16f1c,%eax
c0101a39:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a3c:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
    irq_mask = mask;
c0101a40:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0101a44:	66 89 90 b0 fb ff ff 	mov    %dx,-0x450(%eax)
    if (did_init) {
c0101a4b:	8b 80 1c 2d 00 00    	mov    0x2d1c(%eax),%eax
c0101a51:	85 c0                	test   %eax,%eax
c0101a53:	74 36                	je     c0101a8b <pic_setmask+0x62>
        outb(IO_PIC1 + 1, mask);
c0101a55:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101a59:	0f b6 c0             	movzbl %al,%eax
c0101a5c:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101a62:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101a65:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101a69:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101a6d:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101a6e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101a72:	66 c1 e8 08          	shr    $0x8,%ax
c0101a76:	0f b6 c0             	movzbl %al,%eax
c0101a79:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101a7f:	88 45 fd             	mov    %al,-0x3(%ebp)
c0101a82:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101a86:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101a8a:	ee                   	out    %al,(%dx)
    }
}
c0101a8b:	90                   	nop
c0101a8c:	c9                   	leave  
c0101a8d:	c3                   	ret    

c0101a8e <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101a8e:	55                   	push   %ebp
c0101a8f:	89 e5                	mov    %esp,%ebp
c0101a91:	53                   	push   %ebx
c0101a92:	e8 1b e8 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0101a97:	05 b9 6e 01 00       	add    $0x16eb9,%eax
    pic_setmask(irq_mask & ~(1 << irq));
c0101a9c:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a9f:	bb 01 00 00 00       	mov    $0x1,%ebx
c0101aa4:	89 d1                	mov    %edx,%ecx
c0101aa6:	d3 e3                	shl    %cl,%ebx
c0101aa8:	89 da                	mov    %ebx,%edx
c0101aaa:	f7 d2                	not    %edx
c0101aac:	0f b7 80 b0 fb ff ff 	movzwl -0x450(%eax),%eax
c0101ab3:	21 d0                	and    %edx,%eax
c0101ab5:	0f b7 c0             	movzwl %ax,%eax
c0101ab8:	50                   	push   %eax
c0101ab9:	e8 6b ff ff ff       	call   c0101a29 <pic_setmask>
c0101abe:	83 c4 04             	add    $0x4,%esp
}
c0101ac1:	90                   	nop
c0101ac2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101ac5:	c9                   	leave  
c0101ac6:	c3                   	ret    

c0101ac7 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101ac7:	55                   	push   %ebp
c0101ac8:	89 e5                	mov    %esp,%ebp
c0101aca:	83 ec 40             	sub    $0x40,%esp
c0101acd:	e8 53 ff ff ff       	call   c0101a25 <__x86.get_pc_thunk.cx>
c0101ad2:	81 c1 7e 6e 01 00    	add    $0x16e7e,%ecx
    did_init = 1;
c0101ad8:	c7 81 1c 2d 00 00 01 	movl   $0x1,0x2d1c(%ecx)
c0101adf:	00 00 00 
c0101ae2:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101ae8:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
c0101aec:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101af0:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101af4:	ee                   	out    %al,(%dx)
c0101af5:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101afb:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
c0101aff:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101b03:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101b07:	ee                   	out    %al,(%dx)
c0101b08:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101b0e:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
c0101b12:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101b16:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101b1a:	ee                   	out    %al,(%dx)
c0101b1b:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101b21:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101b25:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101b29:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101b2d:	ee                   	out    %al,(%dx)
c0101b2e:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101b34:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
c0101b38:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101b3c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101b40:	ee                   	out    %al,(%dx)
c0101b41:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c0101b47:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
c0101b4b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101b4f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101b53:	ee                   	out    %al,(%dx)
c0101b54:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c0101b5a:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
c0101b5e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101b62:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101b66:	ee                   	out    %al,(%dx)
c0101b67:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c0101b6d:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
c0101b71:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101b75:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101b79:	ee                   	out    %al,(%dx)
c0101b7a:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c0101b80:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
c0101b84:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101b88:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101b8c:	ee                   	out    %al,(%dx)
c0101b8d:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0101b93:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
c0101b97:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b9b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101b9f:	ee                   	out    %al,(%dx)
c0101ba0:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101ba6:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
c0101baa:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101bae:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bb2:	ee                   	out    %al,(%dx)
c0101bb3:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101bb9:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
c0101bbd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101bc1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101bc5:	ee                   	out    %al,(%dx)
c0101bc6:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0101bcc:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
c0101bd0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101bd4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101bd8:	ee                   	out    %al,(%dx)
c0101bd9:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101bdf:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
c0101be3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101be7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101beb:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101bec:	0f b7 81 b0 fb ff ff 	movzwl -0x450(%ecx),%eax
c0101bf3:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101bf7:	74 13                	je     c0101c0c <pic_init+0x145>
        pic_setmask(irq_mask);
c0101bf9:	0f b7 81 b0 fb ff ff 	movzwl -0x450(%ecx),%eax
c0101c00:	0f b7 c0             	movzwl %ax,%eax
c0101c03:	50                   	push   %eax
c0101c04:	e8 20 fe ff ff       	call   c0101a29 <pic_setmask>
c0101c09:	83 c4 04             	add    $0x4,%esp
    }
}
c0101c0c:	90                   	nop
c0101c0d:	c9                   	leave  
c0101c0e:	c3                   	ret    

c0101c0f <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101c0f:	55                   	push   %ebp
c0101c10:	89 e5                	mov    %esp,%ebp
c0101c12:	e8 9b e6 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0101c17:	05 39 6d 01 00       	add    $0x16d39,%eax
    asm volatile ("sti");
c0101c1c:	fb                   	sti    
    sti();
}
c0101c1d:	90                   	nop
c0101c1e:	5d                   	pop    %ebp
c0101c1f:	c3                   	ret    

c0101c20 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101c20:	55                   	push   %ebp
c0101c21:	89 e5                	mov    %esp,%ebp
c0101c23:	e8 8a e6 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0101c28:	05 28 6d 01 00       	add    $0x16d28,%eax
    asm volatile ("cli" ::: "memory");
c0101c2d:	fa                   	cli    
    cli();
}
c0101c2e:	90                   	nop
c0101c2f:	5d                   	pop    %ebp
c0101c30:	c3                   	ret    

c0101c31 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101c31:	55                   	push   %ebp
c0101c32:	89 e5                	mov    %esp,%ebp
c0101c34:	53                   	push   %ebx
c0101c35:	83 ec 04             	sub    $0x4,%esp
c0101c38:	e8 75 e6 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0101c3d:	05 13 6d 01 00       	add    $0x16d13,%eax
    cprintf("%d ticks\n",TICK_NUM);
c0101c42:	83 ec 08             	sub    $0x8,%esp
c0101c45:	6a 64                	push   $0x64
c0101c47:	8d 90 43 df fe ff    	lea    -0x120bd(%eax),%edx
c0101c4d:	52                   	push   %edx
c0101c4e:	89 c3                	mov    %eax,%ebx
c0101c50:	e8 d4 e6 ff ff       	call   c0100329 <cprintf>
c0101c55:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101c58:	90                   	nop
c0101c59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101c5c:	c9                   	leave  
c0101c5d:	c3                   	ret    

c0101c5e <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101c5e:	55                   	push   %ebp
c0101c5f:	89 e5                	mov    %esp,%ebp
c0101c61:	83 ec 10             	sub    $0x10,%esp
c0101c64:	e8 49 e6 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0101c69:	05 e7 6c 01 00       	add    $0x16ce7,%eax
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101c6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101c75:	e9 c7 00 00 00       	jmp    c0101d41 <idt_init+0xe3>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0101c7a:	c7 c2 02 85 11 c0    	mov    $0xc0118502,%edx
c0101c80:	8b 4d fc             	mov    -0x4(%ebp),%ecx
c0101c83:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
c0101c86:	89 d1                	mov    %edx,%ecx
c0101c88:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101c8b:	66 89 8c d0 30 2d 00 	mov    %cx,0x2d30(%eax,%edx,8)
c0101c92:	00 
c0101c93:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101c96:	66 c7 84 d0 32 2d 00 	movw   $0x8,0x2d32(%eax,%edx,8)
c0101c9d:	00 08 00 
c0101ca0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101ca3:	0f b6 8c d0 34 2d 00 	movzbl 0x2d34(%eax,%edx,8),%ecx
c0101caa:	00 
c0101cab:	83 e1 e0             	and    $0xffffffe0,%ecx
c0101cae:	88 8c d0 34 2d 00 00 	mov    %cl,0x2d34(%eax,%edx,8)
c0101cb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101cb8:	0f b6 8c d0 34 2d 00 	movzbl 0x2d34(%eax,%edx,8),%ecx
c0101cbf:	00 
c0101cc0:	83 e1 1f             	and    $0x1f,%ecx
c0101cc3:	88 8c d0 34 2d 00 00 	mov    %cl,0x2d34(%eax,%edx,8)
c0101cca:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101ccd:	0f b6 8c d0 35 2d 00 	movzbl 0x2d35(%eax,%edx,8),%ecx
c0101cd4:	00 
c0101cd5:	83 e1 f0             	and    $0xfffffff0,%ecx
c0101cd8:	83 c9 0e             	or     $0xe,%ecx
c0101cdb:	88 8c d0 35 2d 00 00 	mov    %cl,0x2d35(%eax,%edx,8)
c0101ce2:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101ce5:	0f b6 8c d0 35 2d 00 	movzbl 0x2d35(%eax,%edx,8),%ecx
c0101cec:	00 
c0101ced:	83 e1 ef             	and    $0xffffffef,%ecx
c0101cf0:	88 8c d0 35 2d 00 00 	mov    %cl,0x2d35(%eax,%edx,8)
c0101cf7:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101cfa:	0f b6 8c d0 35 2d 00 	movzbl 0x2d35(%eax,%edx,8),%ecx
c0101d01:	00 
c0101d02:	83 e1 9f             	and    $0xffffff9f,%ecx
c0101d05:	88 8c d0 35 2d 00 00 	mov    %cl,0x2d35(%eax,%edx,8)
c0101d0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101d0f:	0f b6 8c d0 35 2d 00 	movzbl 0x2d35(%eax,%edx,8),%ecx
c0101d16:	00 
c0101d17:	83 c9 80             	or     $0xffffff80,%ecx
c0101d1a:	88 8c d0 35 2d 00 00 	mov    %cl,0x2d35(%eax,%edx,8)
c0101d21:	c7 c2 02 85 11 c0    	mov    $0xc0118502,%edx
c0101d27:	8b 4d fc             	mov    -0x4(%ebp),%ecx
c0101d2a:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
c0101d2d:	c1 ea 10             	shr    $0x10,%edx
c0101d30:	89 d1                	mov    %edx,%ecx
c0101d32:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101d35:	66 89 8c d0 36 2d 00 	mov    %cx,0x2d36(%eax,%edx,8)
c0101d3c:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101d3d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101d41:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101d44:	81 fa ff 00 00 00    	cmp    $0xff,%edx
c0101d4a:	0f 86 2a ff ff ff    	jbe    c0101c7a <idt_init+0x1c>
c0101d50:	8d 80 50 00 00 00    	lea    0x50(%eax),%eax
c0101d56:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101d59:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d5c:	0f 01 18             	lidtl  (%eax)
    }
    lidt(&idt_pd);
}
c0101d5f:	90                   	nop
c0101d60:	c9                   	leave  
c0101d61:	c3                   	ret    

c0101d62 <trapname>:

static const char *
trapname(int trapno) {
c0101d62:	55                   	push   %ebp
c0101d63:	89 e5                	mov    %esp,%ebp
c0101d65:	e8 48 e5 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0101d6a:	05 e6 6b 01 00       	add    $0x16be6,%eax
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101d6f:	8b 55 08             	mov    0x8(%ebp),%edx
c0101d72:	83 fa 13             	cmp    $0x13,%edx
c0101d75:	77 0c                	ja     c0101d83 <trapname+0x21>
        return excnames[trapno];
c0101d77:	8b 55 08             	mov    0x8(%ebp),%edx
c0101d7a:	8b 84 90 f0 00 00 00 	mov    0xf0(%eax,%edx,4),%eax
c0101d81:	eb 1a                	jmp    c0101d9d <trapname+0x3b>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101d83:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101d87:	7e 0e                	jle    c0101d97 <trapname+0x35>
c0101d89:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101d8d:	7f 08                	jg     c0101d97 <trapname+0x35>
        return "Hardware Interrupt";
c0101d8f:	8d 80 4d df fe ff    	lea    -0x120b3(%eax),%eax
c0101d95:	eb 06                	jmp    c0101d9d <trapname+0x3b>
    }
    return "(unknown trap)";
c0101d97:	8d 80 60 df fe ff    	lea    -0x120a0(%eax),%eax
}
c0101d9d:	5d                   	pop    %ebp
c0101d9e:	c3                   	ret    

c0101d9f <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101d9f:	55                   	push   %ebp
c0101da0:	89 e5                	mov    %esp,%ebp
c0101da2:	e8 0b e5 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0101da7:	05 a9 6b 01 00       	add    $0x16ba9,%eax
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101dac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101daf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101db3:	66 83 f8 08          	cmp    $0x8,%ax
c0101db7:	0f 94 c0             	sete   %al
c0101dba:	0f b6 c0             	movzbl %al,%eax
}
c0101dbd:	5d                   	pop    %ebp
c0101dbe:	c3                   	ret    

c0101dbf <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101dbf:	55                   	push   %ebp
c0101dc0:	89 e5                	mov    %esp,%ebp
c0101dc2:	53                   	push   %ebx
c0101dc3:	83 ec 14             	sub    $0x14,%esp
c0101dc6:	e8 eb e4 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0101dcb:	81 c3 85 6b 01 00    	add    $0x16b85,%ebx
    cprintf("trapframe at %p\n", tf);
c0101dd1:	83 ec 08             	sub    $0x8,%esp
c0101dd4:	ff 75 08             	pushl  0x8(%ebp)
c0101dd7:	8d 83 a1 df fe ff    	lea    -0x1205f(%ebx),%eax
c0101ddd:	50                   	push   %eax
c0101dde:	e8 46 e5 ff ff       	call   c0100329 <cprintf>
c0101de3:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101de6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de9:	83 ec 0c             	sub    $0xc,%esp
c0101dec:	50                   	push   %eax
c0101ded:	e8 d3 01 00 00       	call   c0101fc5 <print_regs>
c0101df2:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101df5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df8:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101dfc:	0f b7 c0             	movzwl %ax,%eax
c0101dff:	83 ec 08             	sub    $0x8,%esp
c0101e02:	50                   	push   %eax
c0101e03:	8d 83 b2 df fe ff    	lea    -0x1204e(%ebx),%eax
c0101e09:	50                   	push   %eax
c0101e0a:	e8 1a e5 ff ff       	call   c0100329 <cprintf>
c0101e0f:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101e12:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e15:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101e19:	0f b7 c0             	movzwl %ax,%eax
c0101e1c:	83 ec 08             	sub    $0x8,%esp
c0101e1f:	50                   	push   %eax
c0101e20:	8d 83 c5 df fe ff    	lea    -0x1203b(%ebx),%eax
c0101e26:	50                   	push   %eax
c0101e27:	e8 fd e4 ff ff       	call   c0100329 <cprintf>
c0101e2c:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101e2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e32:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101e36:	0f b7 c0             	movzwl %ax,%eax
c0101e39:	83 ec 08             	sub    $0x8,%esp
c0101e3c:	50                   	push   %eax
c0101e3d:	8d 83 d8 df fe ff    	lea    -0x12028(%ebx),%eax
c0101e43:	50                   	push   %eax
c0101e44:	e8 e0 e4 ff ff       	call   c0100329 <cprintf>
c0101e49:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101e4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101e53:	0f b7 c0             	movzwl %ax,%eax
c0101e56:	83 ec 08             	sub    $0x8,%esp
c0101e59:	50                   	push   %eax
c0101e5a:	8d 83 eb df fe ff    	lea    -0x12015(%ebx),%eax
c0101e60:	50                   	push   %eax
c0101e61:	e8 c3 e4 ff ff       	call   c0100329 <cprintf>
c0101e66:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101e69:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e6c:	8b 40 30             	mov    0x30(%eax),%eax
c0101e6f:	83 ec 0c             	sub    $0xc,%esp
c0101e72:	50                   	push   %eax
c0101e73:	e8 ea fe ff ff       	call   c0101d62 <trapname>
c0101e78:	83 c4 10             	add    $0x10,%esp
c0101e7b:	89 c2                	mov    %eax,%edx
c0101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e80:	8b 40 30             	mov    0x30(%eax),%eax
c0101e83:	83 ec 04             	sub    $0x4,%esp
c0101e86:	52                   	push   %edx
c0101e87:	50                   	push   %eax
c0101e88:	8d 83 fe df fe ff    	lea    -0x12002(%ebx),%eax
c0101e8e:	50                   	push   %eax
c0101e8f:	e8 95 e4 ff ff       	call   c0100329 <cprintf>
c0101e94:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101e97:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e9a:	8b 40 34             	mov    0x34(%eax),%eax
c0101e9d:	83 ec 08             	sub    $0x8,%esp
c0101ea0:	50                   	push   %eax
c0101ea1:	8d 83 10 e0 fe ff    	lea    -0x11ff0(%ebx),%eax
c0101ea7:	50                   	push   %eax
c0101ea8:	e8 7c e4 ff ff       	call   c0100329 <cprintf>
c0101ead:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101eb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb3:	8b 40 38             	mov    0x38(%eax),%eax
c0101eb6:	83 ec 08             	sub    $0x8,%esp
c0101eb9:	50                   	push   %eax
c0101eba:	8d 83 1f e0 fe ff    	lea    -0x11fe1(%ebx),%eax
c0101ec0:	50                   	push   %eax
c0101ec1:	e8 63 e4 ff ff       	call   c0100329 <cprintf>
c0101ec6:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101ec9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ecc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ed0:	0f b7 c0             	movzwl %ax,%eax
c0101ed3:	83 ec 08             	sub    $0x8,%esp
c0101ed6:	50                   	push   %eax
c0101ed7:	8d 83 2e e0 fe ff    	lea    -0x11fd2(%ebx),%eax
c0101edd:	50                   	push   %eax
c0101ede:	e8 46 e4 ff ff       	call   c0100329 <cprintf>
c0101ee3:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101ee6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee9:	8b 40 40             	mov    0x40(%eax),%eax
c0101eec:	83 ec 08             	sub    $0x8,%esp
c0101eef:	50                   	push   %eax
c0101ef0:	8d 83 41 e0 fe ff    	lea    -0x11fbf(%ebx),%eax
c0101ef6:	50                   	push   %eax
c0101ef7:	e8 2d e4 ff ff       	call   c0100329 <cprintf>
c0101efc:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101eff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101f06:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101f0d:	eb 41                	jmp    c0101f50 <print_trapframe+0x191>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101f0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f12:	8b 50 40             	mov    0x40(%eax),%edx
c0101f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f18:	21 d0                	and    %edx,%eax
c0101f1a:	85 c0                	test   %eax,%eax
c0101f1c:	74 2b                	je     c0101f49 <print_trapframe+0x18a>
c0101f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f21:	8b 84 83 70 00 00 00 	mov    0x70(%ebx,%eax,4),%eax
c0101f28:	85 c0                	test   %eax,%eax
c0101f2a:	74 1d                	je     c0101f49 <print_trapframe+0x18a>
            cprintf("%s,", IA32flags[i]);
c0101f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f2f:	8b 84 83 70 00 00 00 	mov    0x70(%ebx,%eax,4),%eax
c0101f36:	83 ec 08             	sub    $0x8,%esp
c0101f39:	50                   	push   %eax
c0101f3a:	8d 83 50 e0 fe ff    	lea    -0x11fb0(%ebx),%eax
c0101f40:	50                   	push   %eax
c0101f41:	e8 e3 e3 ff ff       	call   c0100329 <cprintf>
c0101f46:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101f49:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101f4d:	d1 65 f0             	shll   -0x10(%ebp)
c0101f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f53:	83 f8 17             	cmp    $0x17,%eax
c0101f56:	76 b7                	jbe    c0101f0f <print_trapframe+0x150>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101f58:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f5b:	8b 40 40             	mov    0x40(%eax),%eax
c0101f5e:	c1 e8 0c             	shr    $0xc,%eax
c0101f61:	83 e0 03             	and    $0x3,%eax
c0101f64:	83 ec 08             	sub    $0x8,%esp
c0101f67:	50                   	push   %eax
c0101f68:	8d 83 54 e0 fe ff    	lea    -0x11fac(%ebx),%eax
c0101f6e:	50                   	push   %eax
c0101f6f:	e8 b5 e3 ff ff       	call   c0100329 <cprintf>
c0101f74:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101f77:	83 ec 0c             	sub    $0xc,%esp
c0101f7a:	ff 75 08             	pushl  0x8(%ebp)
c0101f7d:	e8 1d fe ff ff       	call   c0101d9f <trap_in_kernel>
c0101f82:	83 c4 10             	add    $0x10,%esp
c0101f85:	85 c0                	test   %eax,%eax
c0101f87:	75 36                	jne    c0101fbf <print_trapframe+0x200>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101f89:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f8c:	8b 40 44             	mov    0x44(%eax),%eax
c0101f8f:	83 ec 08             	sub    $0x8,%esp
c0101f92:	50                   	push   %eax
c0101f93:	8d 83 5d e0 fe ff    	lea    -0x11fa3(%ebx),%eax
c0101f99:	50                   	push   %eax
c0101f9a:	e8 8a e3 ff ff       	call   c0100329 <cprintf>
c0101f9f:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101fa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fa5:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101fa9:	0f b7 c0             	movzwl %ax,%eax
c0101fac:	83 ec 08             	sub    $0x8,%esp
c0101faf:	50                   	push   %eax
c0101fb0:	8d 83 6c e0 fe ff    	lea    -0x11f94(%ebx),%eax
c0101fb6:	50                   	push   %eax
c0101fb7:	e8 6d e3 ff ff       	call   c0100329 <cprintf>
c0101fbc:	83 c4 10             	add    $0x10,%esp
    }
}
c0101fbf:	90                   	nop
c0101fc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101fc3:	c9                   	leave  
c0101fc4:	c3                   	ret    

c0101fc5 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101fc5:	55                   	push   %ebp
c0101fc6:	89 e5                	mov    %esp,%ebp
c0101fc8:	53                   	push   %ebx
c0101fc9:	83 ec 04             	sub    $0x4,%esp
c0101fcc:	e8 e5 e2 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0101fd1:	81 c3 7f 69 01 00    	add    $0x1697f,%ebx
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101fd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fda:	8b 00                	mov    (%eax),%eax
c0101fdc:	83 ec 08             	sub    $0x8,%esp
c0101fdf:	50                   	push   %eax
c0101fe0:	8d 83 7f e0 fe ff    	lea    -0x11f81(%ebx),%eax
c0101fe6:	50                   	push   %eax
c0101fe7:	e8 3d e3 ff ff       	call   c0100329 <cprintf>
c0101fec:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101fef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ff2:	8b 40 04             	mov    0x4(%eax),%eax
c0101ff5:	83 ec 08             	sub    $0x8,%esp
c0101ff8:	50                   	push   %eax
c0101ff9:	8d 83 8e e0 fe ff    	lea    -0x11f72(%ebx),%eax
c0101fff:	50                   	push   %eax
c0102000:	e8 24 e3 ff ff       	call   c0100329 <cprintf>
c0102005:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0102008:	8b 45 08             	mov    0x8(%ebp),%eax
c010200b:	8b 40 08             	mov    0x8(%eax),%eax
c010200e:	83 ec 08             	sub    $0x8,%esp
c0102011:	50                   	push   %eax
c0102012:	8d 83 9d e0 fe ff    	lea    -0x11f63(%ebx),%eax
c0102018:	50                   	push   %eax
c0102019:	e8 0b e3 ff ff       	call   c0100329 <cprintf>
c010201e:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102021:	8b 45 08             	mov    0x8(%ebp),%eax
c0102024:	8b 40 0c             	mov    0xc(%eax),%eax
c0102027:	83 ec 08             	sub    $0x8,%esp
c010202a:	50                   	push   %eax
c010202b:	8d 83 ac e0 fe ff    	lea    -0x11f54(%ebx),%eax
c0102031:	50                   	push   %eax
c0102032:	e8 f2 e2 ff ff       	call   c0100329 <cprintf>
c0102037:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c010203a:	8b 45 08             	mov    0x8(%ebp),%eax
c010203d:	8b 40 10             	mov    0x10(%eax),%eax
c0102040:	83 ec 08             	sub    $0x8,%esp
c0102043:	50                   	push   %eax
c0102044:	8d 83 bb e0 fe ff    	lea    -0x11f45(%ebx),%eax
c010204a:	50                   	push   %eax
c010204b:	e8 d9 e2 ff ff       	call   c0100329 <cprintf>
c0102050:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102053:	8b 45 08             	mov    0x8(%ebp),%eax
c0102056:	8b 40 14             	mov    0x14(%eax),%eax
c0102059:	83 ec 08             	sub    $0x8,%esp
c010205c:	50                   	push   %eax
c010205d:	8d 83 ca e0 fe ff    	lea    -0x11f36(%ebx),%eax
c0102063:	50                   	push   %eax
c0102064:	e8 c0 e2 ff ff       	call   c0100329 <cprintf>
c0102069:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c010206c:	8b 45 08             	mov    0x8(%ebp),%eax
c010206f:	8b 40 18             	mov    0x18(%eax),%eax
c0102072:	83 ec 08             	sub    $0x8,%esp
c0102075:	50                   	push   %eax
c0102076:	8d 83 d9 e0 fe ff    	lea    -0x11f27(%ebx),%eax
c010207c:	50                   	push   %eax
c010207d:	e8 a7 e2 ff ff       	call   c0100329 <cprintf>
c0102082:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102085:	8b 45 08             	mov    0x8(%ebp),%eax
c0102088:	8b 40 1c             	mov    0x1c(%eax),%eax
c010208b:	83 ec 08             	sub    $0x8,%esp
c010208e:	50                   	push   %eax
c010208f:	8d 83 e8 e0 fe ff    	lea    -0x11f18(%ebx),%eax
c0102095:	50                   	push   %eax
c0102096:	e8 8e e2 ff ff       	call   c0100329 <cprintf>
c010209b:	83 c4 10             	add    $0x10,%esp
}
c010209e:	90                   	nop
c010209f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01020a2:	c9                   	leave  
c01020a3:	c3                   	ret    

c01020a4 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c01020a4:	55                   	push   %ebp
c01020a5:	89 e5                	mov    %esp,%ebp
c01020a7:	53                   	push   %ebx
c01020a8:	83 ec 14             	sub    $0x14,%esp
c01020ab:	e8 06 e2 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c01020b0:	81 c3 a0 68 01 00    	add    $0x168a0,%ebx
    char c;

    switch (tf->tf_trapno) {
c01020b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01020b9:	8b 40 30             	mov    0x30(%eax),%eax
c01020bc:	83 f8 2f             	cmp    $0x2f,%eax
c01020bf:	77 21                	ja     c01020e2 <trap_dispatch+0x3e>
c01020c1:	83 f8 2e             	cmp    $0x2e,%eax
c01020c4:	0f 83 0c 01 00 00    	jae    c01021d6 <trap_dispatch+0x132>
c01020ca:	83 f8 21             	cmp    $0x21,%eax
c01020cd:	0f 84 88 00 00 00    	je     c010215b <trap_dispatch+0xb7>
c01020d3:	83 f8 24             	cmp    $0x24,%eax
c01020d6:	74 5d                	je     c0102135 <trap_dispatch+0x91>
c01020d8:	83 f8 20             	cmp    $0x20,%eax
c01020db:	74 16                	je     c01020f3 <trap_dispatch+0x4f>
c01020dd:	e9 ba 00 00 00       	jmp    c010219c <trap_dispatch+0xf8>
c01020e2:	83 e8 78             	sub    $0x78,%eax
c01020e5:	83 f8 01             	cmp    $0x1,%eax
c01020e8:	0f 87 ae 00 00 00    	ja     c010219c <trap_dispatch+0xf8>
c01020ee:	e9 8e 00 00 00       	jmp    c0102181 <trap_dispatch+0xdd>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c01020f3:	c7 c0 0c bf 11 c0    	mov    $0xc011bf0c,%eax
c01020f9:	8b 00                	mov    (%eax),%eax
c01020fb:	8d 50 01             	lea    0x1(%eax),%edx
c01020fe:	c7 c0 0c bf 11 c0    	mov    $0xc011bf0c,%eax
c0102104:	89 10                	mov    %edx,(%eax)
        if (ticks % TICK_NUM == 0) {
c0102106:	c7 c0 0c bf 11 c0    	mov    $0xc011bf0c,%eax
c010210c:	8b 08                	mov    (%eax),%ecx
c010210e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0102113:	89 c8                	mov    %ecx,%eax
c0102115:	f7 e2                	mul    %edx
c0102117:	89 d0                	mov    %edx,%eax
c0102119:	c1 e8 05             	shr    $0x5,%eax
c010211c:	6b c0 64             	imul   $0x64,%eax,%eax
c010211f:	29 c1                	sub    %eax,%ecx
c0102121:	89 c8                	mov    %ecx,%eax
c0102123:	85 c0                	test   %eax,%eax
c0102125:	0f 85 ae 00 00 00    	jne    c01021d9 <trap_dispatch+0x135>
            print_ticks();
c010212b:	e8 01 fb ff ff       	call   c0101c31 <print_ticks>
        }
        break;
c0102130:	e9 a4 00 00 00       	jmp    c01021d9 <trap_dispatch+0x135>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102135:	e8 66 f8 ff ff       	call   c01019a0 <cons_getc>
c010213a:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c010213d:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0102141:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0102145:	83 ec 04             	sub    $0x4,%esp
c0102148:	52                   	push   %edx
c0102149:	50                   	push   %eax
c010214a:	8d 83 f7 e0 fe ff    	lea    -0x11f09(%ebx),%eax
c0102150:	50                   	push   %eax
c0102151:	e8 d3 e1 ff ff       	call   c0100329 <cprintf>
c0102156:	83 c4 10             	add    $0x10,%esp
        break;
c0102159:	eb 7f                	jmp    c01021da <trap_dispatch+0x136>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c010215b:	e8 40 f8 ff ff       	call   c01019a0 <cons_getc>
c0102160:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102163:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0102167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010216b:	83 ec 04             	sub    $0x4,%esp
c010216e:	52                   	push   %edx
c010216f:	50                   	push   %eax
c0102170:	8d 83 09 e1 fe ff    	lea    -0x11ef7(%ebx),%eax
c0102176:	50                   	push   %eax
c0102177:	e8 ad e1 ff ff       	call   c0100329 <cprintf>
c010217c:	83 c4 10             	add    $0x10,%esp
        break;
c010217f:	eb 59                	jmp    c01021da <trap_dispatch+0x136>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102181:	83 ec 04             	sub    $0x4,%esp
c0102184:	8d 83 18 e1 fe ff    	lea    -0x11ee8(%ebx),%eax
c010218a:	50                   	push   %eax
c010218b:	68 ac 00 00 00       	push   $0xac
c0102190:	8d 83 28 e1 fe ff    	lea    -0x11ed8(%ebx),%eax
c0102196:	50                   	push   %eax
c0102197:	e8 3d e3 ff ff       	call   c01004d9 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c010219c:	8b 45 08             	mov    0x8(%ebp),%eax
c010219f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01021a3:	0f b7 c0             	movzwl %ax,%eax
c01021a6:	83 e0 03             	and    $0x3,%eax
c01021a9:	85 c0                	test   %eax,%eax
c01021ab:	75 2d                	jne    c01021da <trap_dispatch+0x136>
            print_trapframe(tf);
c01021ad:	83 ec 0c             	sub    $0xc,%esp
c01021b0:	ff 75 08             	pushl  0x8(%ebp)
c01021b3:	e8 07 fc ff ff       	call   c0101dbf <print_trapframe>
c01021b8:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c01021bb:	83 ec 04             	sub    $0x4,%esp
c01021be:	8d 83 39 e1 fe ff    	lea    -0x11ec7(%ebx),%eax
c01021c4:	50                   	push   %eax
c01021c5:	68 b6 00 00 00       	push   $0xb6
c01021ca:	8d 83 28 e1 fe ff    	lea    -0x11ed8(%ebx),%eax
c01021d0:	50                   	push   %eax
c01021d1:	e8 03 e3 ff ff       	call   c01004d9 <__panic>
        break;
c01021d6:	90                   	nop
c01021d7:	eb 01                	jmp    c01021da <trap_dispatch+0x136>
        break;
c01021d9:	90                   	nop
        }
    }
}
c01021da:	90                   	nop
c01021db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01021de:	c9                   	leave  
c01021df:	c3                   	ret    

c01021e0 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c01021e0:	55                   	push   %ebp
c01021e1:	89 e5                	mov    %esp,%ebp
c01021e3:	83 ec 08             	sub    $0x8,%esp
c01021e6:	e8 c7 e0 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01021eb:	05 65 67 01 00       	add    $0x16765,%eax
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c01021f0:	83 ec 0c             	sub    $0xc,%esp
c01021f3:	ff 75 08             	pushl  0x8(%ebp)
c01021f6:	e8 a9 fe ff ff       	call   c01020a4 <trap_dispatch>
c01021fb:	83 c4 10             	add    $0x10,%esp
}
c01021fe:	90                   	nop
c01021ff:	c9                   	leave  
c0102200:	c3                   	ret    

c0102201 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102201:	6a 00                	push   $0x0
  pushl $0
c0102203:	6a 00                	push   $0x0
  jmp __alltraps
c0102205:	e9 67 0a 00 00       	jmp    c0102c71 <__alltraps>

c010220a <vector1>:
.globl vector1
vector1:
  pushl $0
c010220a:	6a 00                	push   $0x0
  pushl $1
c010220c:	6a 01                	push   $0x1
  jmp __alltraps
c010220e:	e9 5e 0a 00 00       	jmp    c0102c71 <__alltraps>

c0102213 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102213:	6a 00                	push   $0x0
  pushl $2
c0102215:	6a 02                	push   $0x2
  jmp __alltraps
c0102217:	e9 55 0a 00 00       	jmp    c0102c71 <__alltraps>

c010221c <vector3>:
.globl vector3
vector3:
  pushl $0
c010221c:	6a 00                	push   $0x0
  pushl $3
c010221e:	6a 03                	push   $0x3
  jmp __alltraps
c0102220:	e9 4c 0a 00 00       	jmp    c0102c71 <__alltraps>

c0102225 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102225:	6a 00                	push   $0x0
  pushl $4
c0102227:	6a 04                	push   $0x4
  jmp __alltraps
c0102229:	e9 43 0a 00 00       	jmp    c0102c71 <__alltraps>

c010222e <vector5>:
.globl vector5
vector5:
  pushl $0
c010222e:	6a 00                	push   $0x0
  pushl $5
c0102230:	6a 05                	push   $0x5
  jmp __alltraps
c0102232:	e9 3a 0a 00 00       	jmp    c0102c71 <__alltraps>

c0102237 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102237:	6a 00                	push   $0x0
  pushl $6
c0102239:	6a 06                	push   $0x6
  jmp __alltraps
c010223b:	e9 31 0a 00 00       	jmp    c0102c71 <__alltraps>

c0102240 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102240:	6a 00                	push   $0x0
  pushl $7
c0102242:	6a 07                	push   $0x7
  jmp __alltraps
c0102244:	e9 28 0a 00 00       	jmp    c0102c71 <__alltraps>

c0102249 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102249:	6a 08                	push   $0x8
  jmp __alltraps
c010224b:	e9 21 0a 00 00       	jmp    c0102c71 <__alltraps>

c0102250 <vector9>:
.globl vector9
vector9:
  pushl $9
c0102250:	6a 09                	push   $0x9
  jmp __alltraps
c0102252:	e9 1a 0a 00 00       	jmp    c0102c71 <__alltraps>

c0102257 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102257:	6a 0a                	push   $0xa
  jmp __alltraps
c0102259:	e9 13 0a 00 00       	jmp    c0102c71 <__alltraps>

c010225e <vector11>:
.globl vector11
vector11:
  pushl $11
c010225e:	6a 0b                	push   $0xb
  jmp __alltraps
c0102260:	e9 0c 0a 00 00       	jmp    c0102c71 <__alltraps>

c0102265 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102265:	6a 0c                	push   $0xc
  jmp __alltraps
c0102267:	e9 05 0a 00 00       	jmp    c0102c71 <__alltraps>

c010226c <vector13>:
.globl vector13
vector13:
  pushl $13
c010226c:	6a 0d                	push   $0xd
  jmp __alltraps
c010226e:	e9 fe 09 00 00       	jmp    c0102c71 <__alltraps>

c0102273 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102273:	6a 0e                	push   $0xe
  jmp __alltraps
c0102275:	e9 f7 09 00 00       	jmp    c0102c71 <__alltraps>

c010227a <vector15>:
.globl vector15
vector15:
  pushl $0
c010227a:	6a 00                	push   $0x0
  pushl $15
c010227c:	6a 0f                	push   $0xf
  jmp __alltraps
c010227e:	e9 ee 09 00 00       	jmp    c0102c71 <__alltraps>

c0102283 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102283:	6a 00                	push   $0x0
  pushl $16
c0102285:	6a 10                	push   $0x10
  jmp __alltraps
c0102287:	e9 e5 09 00 00       	jmp    c0102c71 <__alltraps>

c010228c <vector17>:
.globl vector17
vector17:
  pushl $17
c010228c:	6a 11                	push   $0x11
  jmp __alltraps
c010228e:	e9 de 09 00 00       	jmp    c0102c71 <__alltraps>

c0102293 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102293:	6a 00                	push   $0x0
  pushl $18
c0102295:	6a 12                	push   $0x12
  jmp __alltraps
c0102297:	e9 d5 09 00 00       	jmp    c0102c71 <__alltraps>

c010229c <vector19>:
.globl vector19
vector19:
  pushl $0
c010229c:	6a 00                	push   $0x0
  pushl $19
c010229e:	6a 13                	push   $0x13
  jmp __alltraps
c01022a0:	e9 cc 09 00 00       	jmp    c0102c71 <__alltraps>

c01022a5 <vector20>:
.globl vector20
vector20:
  pushl $0
c01022a5:	6a 00                	push   $0x0
  pushl $20
c01022a7:	6a 14                	push   $0x14
  jmp __alltraps
c01022a9:	e9 c3 09 00 00       	jmp    c0102c71 <__alltraps>

c01022ae <vector21>:
.globl vector21
vector21:
  pushl $0
c01022ae:	6a 00                	push   $0x0
  pushl $21
c01022b0:	6a 15                	push   $0x15
  jmp __alltraps
c01022b2:	e9 ba 09 00 00       	jmp    c0102c71 <__alltraps>

c01022b7 <vector22>:
.globl vector22
vector22:
  pushl $0
c01022b7:	6a 00                	push   $0x0
  pushl $22
c01022b9:	6a 16                	push   $0x16
  jmp __alltraps
c01022bb:	e9 b1 09 00 00       	jmp    c0102c71 <__alltraps>

c01022c0 <vector23>:
.globl vector23
vector23:
  pushl $0
c01022c0:	6a 00                	push   $0x0
  pushl $23
c01022c2:	6a 17                	push   $0x17
  jmp __alltraps
c01022c4:	e9 a8 09 00 00       	jmp    c0102c71 <__alltraps>

c01022c9 <vector24>:
.globl vector24
vector24:
  pushl $0
c01022c9:	6a 00                	push   $0x0
  pushl $24
c01022cb:	6a 18                	push   $0x18
  jmp __alltraps
c01022cd:	e9 9f 09 00 00       	jmp    c0102c71 <__alltraps>

c01022d2 <vector25>:
.globl vector25
vector25:
  pushl $0
c01022d2:	6a 00                	push   $0x0
  pushl $25
c01022d4:	6a 19                	push   $0x19
  jmp __alltraps
c01022d6:	e9 96 09 00 00       	jmp    c0102c71 <__alltraps>

c01022db <vector26>:
.globl vector26
vector26:
  pushl $0
c01022db:	6a 00                	push   $0x0
  pushl $26
c01022dd:	6a 1a                	push   $0x1a
  jmp __alltraps
c01022df:	e9 8d 09 00 00       	jmp    c0102c71 <__alltraps>

c01022e4 <vector27>:
.globl vector27
vector27:
  pushl $0
c01022e4:	6a 00                	push   $0x0
  pushl $27
c01022e6:	6a 1b                	push   $0x1b
  jmp __alltraps
c01022e8:	e9 84 09 00 00       	jmp    c0102c71 <__alltraps>

c01022ed <vector28>:
.globl vector28
vector28:
  pushl $0
c01022ed:	6a 00                	push   $0x0
  pushl $28
c01022ef:	6a 1c                	push   $0x1c
  jmp __alltraps
c01022f1:	e9 7b 09 00 00       	jmp    c0102c71 <__alltraps>

c01022f6 <vector29>:
.globl vector29
vector29:
  pushl $0
c01022f6:	6a 00                	push   $0x0
  pushl $29
c01022f8:	6a 1d                	push   $0x1d
  jmp __alltraps
c01022fa:	e9 72 09 00 00       	jmp    c0102c71 <__alltraps>

c01022ff <vector30>:
.globl vector30
vector30:
  pushl $0
c01022ff:	6a 00                	push   $0x0
  pushl $30
c0102301:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102303:	e9 69 09 00 00       	jmp    c0102c71 <__alltraps>

c0102308 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102308:	6a 00                	push   $0x0
  pushl $31
c010230a:	6a 1f                	push   $0x1f
  jmp __alltraps
c010230c:	e9 60 09 00 00       	jmp    c0102c71 <__alltraps>

c0102311 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102311:	6a 00                	push   $0x0
  pushl $32
c0102313:	6a 20                	push   $0x20
  jmp __alltraps
c0102315:	e9 57 09 00 00       	jmp    c0102c71 <__alltraps>

c010231a <vector33>:
.globl vector33
vector33:
  pushl $0
c010231a:	6a 00                	push   $0x0
  pushl $33
c010231c:	6a 21                	push   $0x21
  jmp __alltraps
c010231e:	e9 4e 09 00 00       	jmp    c0102c71 <__alltraps>

c0102323 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102323:	6a 00                	push   $0x0
  pushl $34
c0102325:	6a 22                	push   $0x22
  jmp __alltraps
c0102327:	e9 45 09 00 00       	jmp    c0102c71 <__alltraps>

c010232c <vector35>:
.globl vector35
vector35:
  pushl $0
c010232c:	6a 00                	push   $0x0
  pushl $35
c010232e:	6a 23                	push   $0x23
  jmp __alltraps
c0102330:	e9 3c 09 00 00       	jmp    c0102c71 <__alltraps>

c0102335 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102335:	6a 00                	push   $0x0
  pushl $36
c0102337:	6a 24                	push   $0x24
  jmp __alltraps
c0102339:	e9 33 09 00 00       	jmp    c0102c71 <__alltraps>

c010233e <vector37>:
.globl vector37
vector37:
  pushl $0
c010233e:	6a 00                	push   $0x0
  pushl $37
c0102340:	6a 25                	push   $0x25
  jmp __alltraps
c0102342:	e9 2a 09 00 00       	jmp    c0102c71 <__alltraps>

c0102347 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102347:	6a 00                	push   $0x0
  pushl $38
c0102349:	6a 26                	push   $0x26
  jmp __alltraps
c010234b:	e9 21 09 00 00       	jmp    c0102c71 <__alltraps>

c0102350 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102350:	6a 00                	push   $0x0
  pushl $39
c0102352:	6a 27                	push   $0x27
  jmp __alltraps
c0102354:	e9 18 09 00 00       	jmp    c0102c71 <__alltraps>

c0102359 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102359:	6a 00                	push   $0x0
  pushl $40
c010235b:	6a 28                	push   $0x28
  jmp __alltraps
c010235d:	e9 0f 09 00 00       	jmp    c0102c71 <__alltraps>

c0102362 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102362:	6a 00                	push   $0x0
  pushl $41
c0102364:	6a 29                	push   $0x29
  jmp __alltraps
c0102366:	e9 06 09 00 00       	jmp    c0102c71 <__alltraps>

c010236b <vector42>:
.globl vector42
vector42:
  pushl $0
c010236b:	6a 00                	push   $0x0
  pushl $42
c010236d:	6a 2a                	push   $0x2a
  jmp __alltraps
c010236f:	e9 fd 08 00 00       	jmp    c0102c71 <__alltraps>

c0102374 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102374:	6a 00                	push   $0x0
  pushl $43
c0102376:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102378:	e9 f4 08 00 00       	jmp    c0102c71 <__alltraps>

c010237d <vector44>:
.globl vector44
vector44:
  pushl $0
c010237d:	6a 00                	push   $0x0
  pushl $44
c010237f:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102381:	e9 eb 08 00 00       	jmp    c0102c71 <__alltraps>

c0102386 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102386:	6a 00                	push   $0x0
  pushl $45
c0102388:	6a 2d                	push   $0x2d
  jmp __alltraps
c010238a:	e9 e2 08 00 00       	jmp    c0102c71 <__alltraps>

c010238f <vector46>:
.globl vector46
vector46:
  pushl $0
c010238f:	6a 00                	push   $0x0
  pushl $46
c0102391:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102393:	e9 d9 08 00 00       	jmp    c0102c71 <__alltraps>

c0102398 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102398:	6a 00                	push   $0x0
  pushl $47
c010239a:	6a 2f                	push   $0x2f
  jmp __alltraps
c010239c:	e9 d0 08 00 00       	jmp    c0102c71 <__alltraps>

c01023a1 <vector48>:
.globl vector48
vector48:
  pushl $0
c01023a1:	6a 00                	push   $0x0
  pushl $48
c01023a3:	6a 30                	push   $0x30
  jmp __alltraps
c01023a5:	e9 c7 08 00 00       	jmp    c0102c71 <__alltraps>

c01023aa <vector49>:
.globl vector49
vector49:
  pushl $0
c01023aa:	6a 00                	push   $0x0
  pushl $49
c01023ac:	6a 31                	push   $0x31
  jmp __alltraps
c01023ae:	e9 be 08 00 00       	jmp    c0102c71 <__alltraps>

c01023b3 <vector50>:
.globl vector50
vector50:
  pushl $0
c01023b3:	6a 00                	push   $0x0
  pushl $50
c01023b5:	6a 32                	push   $0x32
  jmp __alltraps
c01023b7:	e9 b5 08 00 00       	jmp    c0102c71 <__alltraps>

c01023bc <vector51>:
.globl vector51
vector51:
  pushl $0
c01023bc:	6a 00                	push   $0x0
  pushl $51
c01023be:	6a 33                	push   $0x33
  jmp __alltraps
c01023c0:	e9 ac 08 00 00       	jmp    c0102c71 <__alltraps>

c01023c5 <vector52>:
.globl vector52
vector52:
  pushl $0
c01023c5:	6a 00                	push   $0x0
  pushl $52
c01023c7:	6a 34                	push   $0x34
  jmp __alltraps
c01023c9:	e9 a3 08 00 00       	jmp    c0102c71 <__alltraps>

c01023ce <vector53>:
.globl vector53
vector53:
  pushl $0
c01023ce:	6a 00                	push   $0x0
  pushl $53
c01023d0:	6a 35                	push   $0x35
  jmp __alltraps
c01023d2:	e9 9a 08 00 00       	jmp    c0102c71 <__alltraps>

c01023d7 <vector54>:
.globl vector54
vector54:
  pushl $0
c01023d7:	6a 00                	push   $0x0
  pushl $54
c01023d9:	6a 36                	push   $0x36
  jmp __alltraps
c01023db:	e9 91 08 00 00       	jmp    c0102c71 <__alltraps>

c01023e0 <vector55>:
.globl vector55
vector55:
  pushl $0
c01023e0:	6a 00                	push   $0x0
  pushl $55
c01023e2:	6a 37                	push   $0x37
  jmp __alltraps
c01023e4:	e9 88 08 00 00       	jmp    c0102c71 <__alltraps>

c01023e9 <vector56>:
.globl vector56
vector56:
  pushl $0
c01023e9:	6a 00                	push   $0x0
  pushl $56
c01023eb:	6a 38                	push   $0x38
  jmp __alltraps
c01023ed:	e9 7f 08 00 00       	jmp    c0102c71 <__alltraps>

c01023f2 <vector57>:
.globl vector57
vector57:
  pushl $0
c01023f2:	6a 00                	push   $0x0
  pushl $57
c01023f4:	6a 39                	push   $0x39
  jmp __alltraps
c01023f6:	e9 76 08 00 00       	jmp    c0102c71 <__alltraps>

c01023fb <vector58>:
.globl vector58
vector58:
  pushl $0
c01023fb:	6a 00                	push   $0x0
  pushl $58
c01023fd:	6a 3a                	push   $0x3a
  jmp __alltraps
c01023ff:	e9 6d 08 00 00       	jmp    c0102c71 <__alltraps>

c0102404 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102404:	6a 00                	push   $0x0
  pushl $59
c0102406:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102408:	e9 64 08 00 00       	jmp    c0102c71 <__alltraps>

c010240d <vector60>:
.globl vector60
vector60:
  pushl $0
c010240d:	6a 00                	push   $0x0
  pushl $60
c010240f:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102411:	e9 5b 08 00 00       	jmp    c0102c71 <__alltraps>

c0102416 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102416:	6a 00                	push   $0x0
  pushl $61
c0102418:	6a 3d                	push   $0x3d
  jmp __alltraps
c010241a:	e9 52 08 00 00       	jmp    c0102c71 <__alltraps>

c010241f <vector62>:
.globl vector62
vector62:
  pushl $0
c010241f:	6a 00                	push   $0x0
  pushl $62
c0102421:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102423:	e9 49 08 00 00       	jmp    c0102c71 <__alltraps>

c0102428 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102428:	6a 00                	push   $0x0
  pushl $63
c010242a:	6a 3f                	push   $0x3f
  jmp __alltraps
c010242c:	e9 40 08 00 00       	jmp    c0102c71 <__alltraps>

c0102431 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102431:	6a 00                	push   $0x0
  pushl $64
c0102433:	6a 40                	push   $0x40
  jmp __alltraps
c0102435:	e9 37 08 00 00       	jmp    c0102c71 <__alltraps>

c010243a <vector65>:
.globl vector65
vector65:
  pushl $0
c010243a:	6a 00                	push   $0x0
  pushl $65
c010243c:	6a 41                	push   $0x41
  jmp __alltraps
c010243e:	e9 2e 08 00 00       	jmp    c0102c71 <__alltraps>

c0102443 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102443:	6a 00                	push   $0x0
  pushl $66
c0102445:	6a 42                	push   $0x42
  jmp __alltraps
c0102447:	e9 25 08 00 00       	jmp    c0102c71 <__alltraps>

c010244c <vector67>:
.globl vector67
vector67:
  pushl $0
c010244c:	6a 00                	push   $0x0
  pushl $67
c010244e:	6a 43                	push   $0x43
  jmp __alltraps
c0102450:	e9 1c 08 00 00       	jmp    c0102c71 <__alltraps>

c0102455 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102455:	6a 00                	push   $0x0
  pushl $68
c0102457:	6a 44                	push   $0x44
  jmp __alltraps
c0102459:	e9 13 08 00 00       	jmp    c0102c71 <__alltraps>

c010245e <vector69>:
.globl vector69
vector69:
  pushl $0
c010245e:	6a 00                	push   $0x0
  pushl $69
c0102460:	6a 45                	push   $0x45
  jmp __alltraps
c0102462:	e9 0a 08 00 00       	jmp    c0102c71 <__alltraps>

c0102467 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102467:	6a 00                	push   $0x0
  pushl $70
c0102469:	6a 46                	push   $0x46
  jmp __alltraps
c010246b:	e9 01 08 00 00       	jmp    c0102c71 <__alltraps>

c0102470 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102470:	6a 00                	push   $0x0
  pushl $71
c0102472:	6a 47                	push   $0x47
  jmp __alltraps
c0102474:	e9 f8 07 00 00       	jmp    c0102c71 <__alltraps>

c0102479 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102479:	6a 00                	push   $0x0
  pushl $72
c010247b:	6a 48                	push   $0x48
  jmp __alltraps
c010247d:	e9 ef 07 00 00       	jmp    c0102c71 <__alltraps>

c0102482 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102482:	6a 00                	push   $0x0
  pushl $73
c0102484:	6a 49                	push   $0x49
  jmp __alltraps
c0102486:	e9 e6 07 00 00       	jmp    c0102c71 <__alltraps>

c010248b <vector74>:
.globl vector74
vector74:
  pushl $0
c010248b:	6a 00                	push   $0x0
  pushl $74
c010248d:	6a 4a                	push   $0x4a
  jmp __alltraps
c010248f:	e9 dd 07 00 00       	jmp    c0102c71 <__alltraps>

c0102494 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102494:	6a 00                	push   $0x0
  pushl $75
c0102496:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102498:	e9 d4 07 00 00       	jmp    c0102c71 <__alltraps>

c010249d <vector76>:
.globl vector76
vector76:
  pushl $0
c010249d:	6a 00                	push   $0x0
  pushl $76
c010249f:	6a 4c                	push   $0x4c
  jmp __alltraps
c01024a1:	e9 cb 07 00 00       	jmp    c0102c71 <__alltraps>

c01024a6 <vector77>:
.globl vector77
vector77:
  pushl $0
c01024a6:	6a 00                	push   $0x0
  pushl $77
c01024a8:	6a 4d                	push   $0x4d
  jmp __alltraps
c01024aa:	e9 c2 07 00 00       	jmp    c0102c71 <__alltraps>

c01024af <vector78>:
.globl vector78
vector78:
  pushl $0
c01024af:	6a 00                	push   $0x0
  pushl $78
c01024b1:	6a 4e                	push   $0x4e
  jmp __alltraps
c01024b3:	e9 b9 07 00 00       	jmp    c0102c71 <__alltraps>

c01024b8 <vector79>:
.globl vector79
vector79:
  pushl $0
c01024b8:	6a 00                	push   $0x0
  pushl $79
c01024ba:	6a 4f                	push   $0x4f
  jmp __alltraps
c01024bc:	e9 b0 07 00 00       	jmp    c0102c71 <__alltraps>

c01024c1 <vector80>:
.globl vector80
vector80:
  pushl $0
c01024c1:	6a 00                	push   $0x0
  pushl $80
c01024c3:	6a 50                	push   $0x50
  jmp __alltraps
c01024c5:	e9 a7 07 00 00       	jmp    c0102c71 <__alltraps>

c01024ca <vector81>:
.globl vector81
vector81:
  pushl $0
c01024ca:	6a 00                	push   $0x0
  pushl $81
c01024cc:	6a 51                	push   $0x51
  jmp __alltraps
c01024ce:	e9 9e 07 00 00       	jmp    c0102c71 <__alltraps>

c01024d3 <vector82>:
.globl vector82
vector82:
  pushl $0
c01024d3:	6a 00                	push   $0x0
  pushl $82
c01024d5:	6a 52                	push   $0x52
  jmp __alltraps
c01024d7:	e9 95 07 00 00       	jmp    c0102c71 <__alltraps>

c01024dc <vector83>:
.globl vector83
vector83:
  pushl $0
c01024dc:	6a 00                	push   $0x0
  pushl $83
c01024de:	6a 53                	push   $0x53
  jmp __alltraps
c01024e0:	e9 8c 07 00 00       	jmp    c0102c71 <__alltraps>

c01024e5 <vector84>:
.globl vector84
vector84:
  pushl $0
c01024e5:	6a 00                	push   $0x0
  pushl $84
c01024e7:	6a 54                	push   $0x54
  jmp __alltraps
c01024e9:	e9 83 07 00 00       	jmp    c0102c71 <__alltraps>

c01024ee <vector85>:
.globl vector85
vector85:
  pushl $0
c01024ee:	6a 00                	push   $0x0
  pushl $85
c01024f0:	6a 55                	push   $0x55
  jmp __alltraps
c01024f2:	e9 7a 07 00 00       	jmp    c0102c71 <__alltraps>

c01024f7 <vector86>:
.globl vector86
vector86:
  pushl $0
c01024f7:	6a 00                	push   $0x0
  pushl $86
c01024f9:	6a 56                	push   $0x56
  jmp __alltraps
c01024fb:	e9 71 07 00 00       	jmp    c0102c71 <__alltraps>

c0102500 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102500:	6a 00                	push   $0x0
  pushl $87
c0102502:	6a 57                	push   $0x57
  jmp __alltraps
c0102504:	e9 68 07 00 00       	jmp    c0102c71 <__alltraps>

c0102509 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102509:	6a 00                	push   $0x0
  pushl $88
c010250b:	6a 58                	push   $0x58
  jmp __alltraps
c010250d:	e9 5f 07 00 00       	jmp    c0102c71 <__alltraps>

c0102512 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102512:	6a 00                	push   $0x0
  pushl $89
c0102514:	6a 59                	push   $0x59
  jmp __alltraps
c0102516:	e9 56 07 00 00       	jmp    c0102c71 <__alltraps>

c010251b <vector90>:
.globl vector90
vector90:
  pushl $0
c010251b:	6a 00                	push   $0x0
  pushl $90
c010251d:	6a 5a                	push   $0x5a
  jmp __alltraps
c010251f:	e9 4d 07 00 00       	jmp    c0102c71 <__alltraps>

c0102524 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102524:	6a 00                	push   $0x0
  pushl $91
c0102526:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102528:	e9 44 07 00 00       	jmp    c0102c71 <__alltraps>

c010252d <vector92>:
.globl vector92
vector92:
  pushl $0
c010252d:	6a 00                	push   $0x0
  pushl $92
c010252f:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102531:	e9 3b 07 00 00       	jmp    c0102c71 <__alltraps>

c0102536 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102536:	6a 00                	push   $0x0
  pushl $93
c0102538:	6a 5d                	push   $0x5d
  jmp __alltraps
c010253a:	e9 32 07 00 00       	jmp    c0102c71 <__alltraps>

c010253f <vector94>:
.globl vector94
vector94:
  pushl $0
c010253f:	6a 00                	push   $0x0
  pushl $94
c0102541:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102543:	e9 29 07 00 00       	jmp    c0102c71 <__alltraps>

c0102548 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102548:	6a 00                	push   $0x0
  pushl $95
c010254a:	6a 5f                	push   $0x5f
  jmp __alltraps
c010254c:	e9 20 07 00 00       	jmp    c0102c71 <__alltraps>

c0102551 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102551:	6a 00                	push   $0x0
  pushl $96
c0102553:	6a 60                	push   $0x60
  jmp __alltraps
c0102555:	e9 17 07 00 00       	jmp    c0102c71 <__alltraps>

c010255a <vector97>:
.globl vector97
vector97:
  pushl $0
c010255a:	6a 00                	push   $0x0
  pushl $97
c010255c:	6a 61                	push   $0x61
  jmp __alltraps
c010255e:	e9 0e 07 00 00       	jmp    c0102c71 <__alltraps>

c0102563 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102563:	6a 00                	push   $0x0
  pushl $98
c0102565:	6a 62                	push   $0x62
  jmp __alltraps
c0102567:	e9 05 07 00 00       	jmp    c0102c71 <__alltraps>

c010256c <vector99>:
.globl vector99
vector99:
  pushl $0
c010256c:	6a 00                	push   $0x0
  pushl $99
c010256e:	6a 63                	push   $0x63
  jmp __alltraps
c0102570:	e9 fc 06 00 00       	jmp    c0102c71 <__alltraps>

c0102575 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102575:	6a 00                	push   $0x0
  pushl $100
c0102577:	6a 64                	push   $0x64
  jmp __alltraps
c0102579:	e9 f3 06 00 00       	jmp    c0102c71 <__alltraps>

c010257e <vector101>:
.globl vector101
vector101:
  pushl $0
c010257e:	6a 00                	push   $0x0
  pushl $101
c0102580:	6a 65                	push   $0x65
  jmp __alltraps
c0102582:	e9 ea 06 00 00       	jmp    c0102c71 <__alltraps>

c0102587 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102587:	6a 00                	push   $0x0
  pushl $102
c0102589:	6a 66                	push   $0x66
  jmp __alltraps
c010258b:	e9 e1 06 00 00       	jmp    c0102c71 <__alltraps>

c0102590 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102590:	6a 00                	push   $0x0
  pushl $103
c0102592:	6a 67                	push   $0x67
  jmp __alltraps
c0102594:	e9 d8 06 00 00       	jmp    c0102c71 <__alltraps>

c0102599 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102599:	6a 00                	push   $0x0
  pushl $104
c010259b:	6a 68                	push   $0x68
  jmp __alltraps
c010259d:	e9 cf 06 00 00       	jmp    c0102c71 <__alltraps>

c01025a2 <vector105>:
.globl vector105
vector105:
  pushl $0
c01025a2:	6a 00                	push   $0x0
  pushl $105
c01025a4:	6a 69                	push   $0x69
  jmp __alltraps
c01025a6:	e9 c6 06 00 00       	jmp    c0102c71 <__alltraps>

c01025ab <vector106>:
.globl vector106
vector106:
  pushl $0
c01025ab:	6a 00                	push   $0x0
  pushl $106
c01025ad:	6a 6a                	push   $0x6a
  jmp __alltraps
c01025af:	e9 bd 06 00 00       	jmp    c0102c71 <__alltraps>

c01025b4 <vector107>:
.globl vector107
vector107:
  pushl $0
c01025b4:	6a 00                	push   $0x0
  pushl $107
c01025b6:	6a 6b                	push   $0x6b
  jmp __alltraps
c01025b8:	e9 b4 06 00 00       	jmp    c0102c71 <__alltraps>

c01025bd <vector108>:
.globl vector108
vector108:
  pushl $0
c01025bd:	6a 00                	push   $0x0
  pushl $108
c01025bf:	6a 6c                	push   $0x6c
  jmp __alltraps
c01025c1:	e9 ab 06 00 00       	jmp    c0102c71 <__alltraps>

c01025c6 <vector109>:
.globl vector109
vector109:
  pushl $0
c01025c6:	6a 00                	push   $0x0
  pushl $109
c01025c8:	6a 6d                	push   $0x6d
  jmp __alltraps
c01025ca:	e9 a2 06 00 00       	jmp    c0102c71 <__alltraps>

c01025cf <vector110>:
.globl vector110
vector110:
  pushl $0
c01025cf:	6a 00                	push   $0x0
  pushl $110
c01025d1:	6a 6e                	push   $0x6e
  jmp __alltraps
c01025d3:	e9 99 06 00 00       	jmp    c0102c71 <__alltraps>

c01025d8 <vector111>:
.globl vector111
vector111:
  pushl $0
c01025d8:	6a 00                	push   $0x0
  pushl $111
c01025da:	6a 6f                	push   $0x6f
  jmp __alltraps
c01025dc:	e9 90 06 00 00       	jmp    c0102c71 <__alltraps>

c01025e1 <vector112>:
.globl vector112
vector112:
  pushl $0
c01025e1:	6a 00                	push   $0x0
  pushl $112
c01025e3:	6a 70                	push   $0x70
  jmp __alltraps
c01025e5:	e9 87 06 00 00       	jmp    c0102c71 <__alltraps>

c01025ea <vector113>:
.globl vector113
vector113:
  pushl $0
c01025ea:	6a 00                	push   $0x0
  pushl $113
c01025ec:	6a 71                	push   $0x71
  jmp __alltraps
c01025ee:	e9 7e 06 00 00       	jmp    c0102c71 <__alltraps>

c01025f3 <vector114>:
.globl vector114
vector114:
  pushl $0
c01025f3:	6a 00                	push   $0x0
  pushl $114
c01025f5:	6a 72                	push   $0x72
  jmp __alltraps
c01025f7:	e9 75 06 00 00       	jmp    c0102c71 <__alltraps>

c01025fc <vector115>:
.globl vector115
vector115:
  pushl $0
c01025fc:	6a 00                	push   $0x0
  pushl $115
c01025fe:	6a 73                	push   $0x73
  jmp __alltraps
c0102600:	e9 6c 06 00 00       	jmp    c0102c71 <__alltraps>

c0102605 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102605:	6a 00                	push   $0x0
  pushl $116
c0102607:	6a 74                	push   $0x74
  jmp __alltraps
c0102609:	e9 63 06 00 00       	jmp    c0102c71 <__alltraps>

c010260e <vector117>:
.globl vector117
vector117:
  pushl $0
c010260e:	6a 00                	push   $0x0
  pushl $117
c0102610:	6a 75                	push   $0x75
  jmp __alltraps
c0102612:	e9 5a 06 00 00       	jmp    c0102c71 <__alltraps>

c0102617 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102617:	6a 00                	push   $0x0
  pushl $118
c0102619:	6a 76                	push   $0x76
  jmp __alltraps
c010261b:	e9 51 06 00 00       	jmp    c0102c71 <__alltraps>

c0102620 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102620:	6a 00                	push   $0x0
  pushl $119
c0102622:	6a 77                	push   $0x77
  jmp __alltraps
c0102624:	e9 48 06 00 00       	jmp    c0102c71 <__alltraps>

c0102629 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102629:	6a 00                	push   $0x0
  pushl $120
c010262b:	6a 78                	push   $0x78
  jmp __alltraps
c010262d:	e9 3f 06 00 00       	jmp    c0102c71 <__alltraps>

c0102632 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102632:	6a 00                	push   $0x0
  pushl $121
c0102634:	6a 79                	push   $0x79
  jmp __alltraps
c0102636:	e9 36 06 00 00       	jmp    c0102c71 <__alltraps>

c010263b <vector122>:
.globl vector122
vector122:
  pushl $0
c010263b:	6a 00                	push   $0x0
  pushl $122
c010263d:	6a 7a                	push   $0x7a
  jmp __alltraps
c010263f:	e9 2d 06 00 00       	jmp    c0102c71 <__alltraps>

c0102644 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102644:	6a 00                	push   $0x0
  pushl $123
c0102646:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102648:	e9 24 06 00 00       	jmp    c0102c71 <__alltraps>

c010264d <vector124>:
.globl vector124
vector124:
  pushl $0
c010264d:	6a 00                	push   $0x0
  pushl $124
c010264f:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102651:	e9 1b 06 00 00       	jmp    c0102c71 <__alltraps>

c0102656 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102656:	6a 00                	push   $0x0
  pushl $125
c0102658:	6a 7d                	push   $0x7d
  jmp __alltraps
c010265a:	e9 12 06 00 00       	jmp    c0102c71 <__alltraps>

c010265f <vector126>:
.globl vector126
vector126:
  pushl $0
c010265f:	6a 00                	push   $0x0
  pushl $126
c0102661:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102663:	e9 09 06 00 00       	jmp    c0102c71 <__alltraps>

c0102668 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102668:	6a 00                	push   $0x0
  pushl $127
c010266a:	6a 7f                	push   $0x7f
  jmp __alltraps
c010266c:	e9 00 06 00 00       	jmp    c0102c71 <__alltraps>

c0102671 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102671:	6a 00                	push   $0x0
  pushl $128
c0102673:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102678:	e9 f4 05 00 00       	jmp    c0102c71 <__alltraps>

c010267d <vector129>:
.globl vector129
vector129:
  pushl $0
c010267d:	6a 00                	push   $0x0
  pushl $129
c010267f:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102684:	e9 e8 05 00 00       	jmp    c0102c71 <__alltraps>

c0102689 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102689:	6a 00                	push   $0x0
  pushl $130
c010268b:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102690:	e9 dc 05 00 00       	jmp    c0102c71 <__alltraps>

c0102695 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102695:	6a 00                	push   $0x0
  pushl $131
c0102697:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010269c:	e9 d0 05 00 00       	jmp    c0102c71 <__alltraps>

c01026a1 <vector132>:
.globl vector132
vector132:
  pushl $0
c01026a1:	6a 00                	push   $0x0
  pushl $132
c01026a3:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01026a8:	e9 c4 05 00 00       	jmp    c0102c71 <__alltraps>

c01026ad <vector133>:
.globl vector133
vector133:
  pushl $0
c01026ad:	6a 00                	push   $0x0
  pushl $133
c01026af:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01026b4:	e9 b8 05 00 00       	jmp    c0102c71 <__alltraps>

c01026b9 <vector134>:
.globl vector134
vector134:
  pushl $0
c01026b9:	6a 00                	push   $0x0
  pushl $134
c01026bb:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01026c0:	e9 ac 05 00 00       	jmp    c0102c71 <__alltraps>

c01026c5 <vector135>:
.globl vector135
vector135:
  pushl $0
c01026c5:	6a 00                	push   $0x0
  pushl $135
c01026c7:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01026cc:	e9 a0 05 00 00       	jmp    c0102c71 <__alltraps>

c01026d1 <vector136>:
.globl vector136
vector136:
  pushl $0
c01026d1:	6a 00                	push   $0x0
  pushl $136
c01026d3:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01026d8:	e9 94 05 00 00       	jmp    c0102c71 <__alltraps>

c01026dd <vector137>:
.globl vector137
vector137:
  pushl $0
c01026dd:	6a 00                	push   $0x0
  pushl $137
c01026df:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01026e4:	e9 88 05 00 00       	jmp    c0102c71 <__alltraps>

c01026e9 <vector138>:
.globl vector138
vector138:
  pushl $0
c01026e9:	6a 00                	push   $0x0
  pushl $138
c01026eb:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01026f0:	e9 7c 05 00 00       	jmp    c0102c71 <__alltraps>

c01026f5 <vector139>:
.globl vector139
vector139:
  pushl $0
c01026f5:	6a 00                	push   $0x0
  pushl $139
c01026f7:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01026fc:	e9 70 05 00 00       	jmp    c0102c71 <__alltraps>

c0102701 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102701:	6a 00                	push   $0x0
  pushl $140
c0102703:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102708:	e9 64 05 00 00       	jmp    c0102c71 <__alltraps>

c010270d <vector141>:
.globl vector141
vector141:
  pushl $0
c010270d:	6a 00                	push   $0x0
  pushl $141
c010270f:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102714:	e9 58 05 00 00       	jmp    c0102c71 <__alltraps>

c0102719 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102719:	6a 00                	push   $0x0
  pushl $142
c010271b:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102720:	e9 4c 05 00 00       	jmp    c0102c71 <__alltraps>

c0102725 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102725:	6a 00                	push   $0x0
  pushl $143
c0102727:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010272c:	e9 40 05 00 00       	jmp    c0102c71 <__alltraps>

c0102731 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102731:	6a 00                	push   $0x0
  pushl $144
c0102733:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102738:	e9 34 05 00 00       	jmp    c0102c71 <__alltraps>

c010273d <vector145>:
.globl vector145
vector145:
  pushl $0
c010273d:	6a 00                	push   $0x0
  pushl $145
c010273f:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102744:	e9 28 05 00 00       	jmp    c0102c71 <__alltraps>

c0102749 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102749:	6a 00                	push   $0x0
  pushl $146
c010274b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102750:	e9 1c 05 00 00       	jmp    c0102c71 <__alltraps>

c0102755 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102755:	6a 00                	push   $0x0
  pushl $147
c0102757:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010275c:	e9 10 05 00 00       	jmp    c0102c71 <__alltraps>

c0102761 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102761:	6a 00                	push   $0x0
  pushl $148
c0102763:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102768:	e9 04 05 00 00       	jmp    c0102c71 <__alltraps>

c010276d <vector149>:
.globl vector149
vector149:
  pushl $0
c010276d:	6a 00                	push   $0x0
  pushl $149
c010276f:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102774:	e9 f8 04 00 00       	jmp    c0102c71 <__alltraps>

c0102779 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102779:	6a 00                	push   $0x0
  pushl $150
c010277b:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102780:	e9 ec 04 00 00       	jmp    c0102c71 <__alltraps>

c0102785 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102785:	6a 00                	push   $0x0
  pushl $151
c0102787:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010278c:	e9 e0 04 00 00       	jmp    c0102c71 <__alltraps>

c0102791 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102791:	6a 00                	push   $0x0
  pushl $152
c0102793:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102798:	e9 d4 04 00 00       	jmp    c0102c71 <__alltraps>

c010279d <vector153>:
.globl vector153
vector153:
  pushl $0
c010279d:	6a 00                	push   $0x0
  pushl $153
c010279f:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01027a4:	e9 c8 04 00 00       	jmp    c0102c71 <__alltraps>

c01027a9 <vector154>:
.globl vector154
vector154:
  pushl $0
c01027a9:	6a 00                	push   $0x0
  pushl $154
c01027ab:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01027b0:	e9 bc 04 00 00       	jmp    c0102c71 <__alltraps>

c01027b5 <vector155>:
.globl vector155
vector155:
  pushl $0
c01027b5:	6a 00                	push   $0x0
  pushl $155
c01027b7:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01027bc:	e9 b0 04 00 00       	jmp    c0102c71 <__alltraps>

c01027c1 <vector156>:
.globl vector156
vector156:
  pushl $0
c01027c1:	6a 00                	push   $0x0
  pushl $156
c01027c3:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01027c8:	e9 a4 04 00 00       	jmp    c0102c71 <__alltraps>

c01027cd <vector157>:
.globl vector157
vector157:
  pushl $0
c01027cd:	6a 00                	push   $0x0
  pushl $157
c01027cf:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01027d4:	e9 98 04 00 00       	jmp    c0102c71 <__alltraps>

c01027d9 <vector158>:
.globl vector158
vector158:
  pushl $0
c01027d9:	6a 00                	push   $0x0
  pushl $158
c01027db:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01027e0:	e9 8c 04 00 00       	jmp    c0102c71 <__alltraps>

c01027e5 <vector159>:
.globl vector159
vector159:
  pushl $0
c01027e5:	6a 00                	push   $0x0
  pushl $159
c01027e7:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01027ec:	e9 80 04 00 00       	jmp    c0102c71 <__alltraps>

c01027f1 <vector160>:
.globl vector160
vector160:
  pushl $0
c01027f1:	6a 00                	push   $0x0
  pushl $160
c01027f3:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01027f8:	e9 74 04 00 00       	jmp    c0102c71 <__alltraps>

c01027fd <vector161>:
.globl vector161
vector161:
  pushl $0
c01027fd:	6a 00                	push   $0x0
  pushl $161
c01027ff:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102804:	e9 68 04 00 00       	jmp    c0102c71 <__alltraps>

c0102809 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102809:	6a 00                	push   $0x0
  pushl $162
c010280b:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102810:	e9 5c 04 00 00       	jmp    c0102c71 <__alltraps>

c0102815 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102815:	6a 00                	push   $0x0
  pushl $163
c0102817:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010281c:	e9 50 04 00 00       	jmp    c0102c71 <__alltraps>

c0102821 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102821:	6a 00                	push   $0x0
  pushl $164
c0102823:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102828:	e9 44 04 00 00       	jmp    c0102c71 <__alltraps>

c010282d <vector165>:
.globl vector165
vector165:
  pushl $0
c010282d:	6a 00                	push   $0x0
  pushl $165
c010282f:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102834:	e9 38 04 00 00       	jmp    c0102c71 <__alltraps>

c0102839 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102839:	6a 00                	push   $0x0
  pushl $166
c010283b:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102840:	e9 2c 04 00 00       	jmp    c0102c71 <__alltraps>

c0102845 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102845:	6a 00                	push   $0x0
  pushl $167
c0102847:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010284c:	e9 20 04 00 00       	jmp    c0102c71 <__alltraps>

c0102851 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102851:	6a 00                	push   $0x0
  pushl $168
c0102853:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102858:	e9 14 04 00 00       	jmp    c0102c71 <__alltraps>

c010285d <vector169>:
.globl vector169
vector169:
  pushl $0
c010285d:	6a 00                	push   $0x0
  pushl $169
c010285f:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102864:	e9 08 04 00 00       	jmp    c0102c71 <__alltraps>

c0102869 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102869:	6a 00                	push   $0x0
  pushl $170
c010286b:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102870:	e9 fc 03 00 00       	jmp    c0102c71 <__alltraps>

c0102875 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102875:	6a 00                	push   $0x0
  pushl $171
c0102877:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010287c:	e9 f0 03 00 00       	jmp    c0102c71 <__alltraps>

c0102881 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102881:	6a 00                	push   $0x0
  pushl $172
c0102883:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102888:	e9 e4 03 00 00       	jmp    c0102c71 <__alltraps>

c010288d <vector173>:
.globl vector173
vector173:
  pushl $0
c010288d:	6a 00                	push   $0x0
  pushl $173
c010288f:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102894:	e9 d8 03 00 00       	jmp    c0102c71 <__alltraps>

c0102899 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102899:	6a 00                	push   $0x0
  pushl $174
c010289b:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01028a0:	e9 cc 03 00 00       	jmp    c0102c71 <__alltraps>

c01028a5 <vector175>:
.globl vector175
vector175:
  pushl $0
c01028a5:	6a 00                	push   $0x0
  pushl $175
c01028a7:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01028ac:	e9 c0 03 00 00       	jmp    c0102c71 <__alltraps>

c01028b1 <vector176>:
.globl vector176
vector176:
  pushl $0
c01028b1:	6a 00                	push   $0x0
  pushl $176
c01028b3:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01028b8:	e9 b4 03 00 00       	jmp    c0102c71 <__alltraps>

c01028bd <vector177>:
.globl vector177
vector177:
  pushl $0
c01028bd:	6a 00                	push   $0x0
  pushl $177
c01028bf:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01028c4:	e9 a8 03 00 00       	jmp    c0102c71 <__alltraps>

c01028c9 <vector178>:
.globl vector178
vector178:
  pushl $0
c01028c9:	6a 00                	push   $0x0
  pushl $178
c01028cb:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01028d0:	e9 9c 03 00 00       	jmp    c0102c71 <__alltraps>

c01028d5 <vector179>:
.globl vector179
vector179:
  pushl $0
c01028d5:	6a 00                	push   $0x0
  pushl $179
c01028d7:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01028dc:	e9 90 03 00 00       	jmp    c0102c71 <__alltraps>

c01028e1 <vector180>:
.globl vector180
vector180:
  pushl $0
c01028e1:	6a 00                	push   $0x0
  pushl $180
c01028e3:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01028e8:	e9 84 03 00 00       	jmp    c0102c71 <__alltraps>

c01028ed <vector181>:
.globl vector181
vector181:
  pushl $0
c01028ed:	6a 00                	push   $0x0
  pushl $181
c01028ef:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01028f4:	e9 78 03 00 00       	jmp    c0102c71 <__alltraps>

c01028f9 <vector182>:
.globl vector182
vector182:
  pushl $0
c01028f9:	6a 00                	push   $0x0
  pushl $182
c01028fb:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102900:	e9 6c 03 00 00       	jmp    c0102c71 <__alltraps>

c0102905 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102905:	6a 00                	push   $0x0
  pushl $183
c0102907:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010290c:	e9 60 03 00 00       	jmp    c0102c71 <__alltraps>

c0102911 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102911:	6a 00                	push   $0x0
  pushl $184
c0102913:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102918:	e9 54 03 00 00       	jmp    c0102c71 <__alltraps>

c010291d <vector185>:
.globl vector185
vector185:
  pushl $0
c010291d:	6a 00                	push   $0x0
  pushl $185
c010291f:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102924:	e9 48 03 00 00       	jmp    c0102c71 <__alltraps>

c0102929 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102929:	6a 00                	push   $0x0
  pushl $186
c010292b:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102930:	e9 3c 03 00 00       	jmp    c0102c71 <__alltraps>

c0102935 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102935:	6a 00                	push   $0x0
  pushl $187
c0102937:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010293c:	e9 30 03 00 00       	jmp    c0102c71 <__alltraps>

c0102941 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102941:	6a 00                	push   $0x0
  pushl $188
c0102943:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102948:	e9 24 03 00 00       	jmp    c0102c71 <__alltraps>

c010294d <vector189>:
.globl vector189
vector189:
  pushl $0
c010294d:	6a 00                	push   $0x0
  pushl $189
c010294f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102954:	e9 18 03 00 00       	jmp    c0102c71 <__alltraps>

c0102959 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102959:	6a 00                	push   $0x0
  pushl $190
c010295b:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102960:	e9 0c 03 00 00       	jmp    c0102c71 <__alltraps>

c0102965 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102965:	6a 00                	push   $0x0
  pushl $191
c0102967:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010296c:	e9 00 03 00 00       	jmp    c0102c71 <__alltraps>

c0102971 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102971:	6a 00                	push   $0x0
  pushl $192
c0102973:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102978:	e9 f4 02 00 00       	jmp    c0102c71 <__alltraps>

c010297d <vector193>:
.globl vector193
vector193:
  pushl $0
c010297d:	6a 00                	push   $0x0
  pushl $193
c010297f:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102984:	e9 e8 02 00 00       	jmp    c0102c71 <__alltraps>

c0102989 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102989:	6a 00                	push   $0x0
  pushl $194
c010298b:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102990:	e9 dc 02 00 00       	jmp    c0102c71 <__alltraps>

c0102995 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102995:	6a 00                	push   $0x0
  pushl $195
c0102997:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010299c:	e9 d0 02 00 00       	jmp    c0102c71 <__alltraps>

c01029a1 <vector196>:
.globl vector196
vector196:
  pushl $0
c01029a1:	6a 00                	push   $0x0
  pushl $196
c01029a3:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01029a8:	e9 c4 02 00 00       	jmp    c0102c71 <__alltraps>

c01029ad <vector197>:
.globl vector197
vector197:
  pushl $0
c01029ad:	6a 00                	push   $0x0
  pushl $197
c01029af:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01029b4:	e9 b8 02 00 00       	jmp    c0102c71 <__alltraps>

c01029b9 <vector198>:
.globl vector198
vector198:
  pushl $0
c01029b9:	6a 00                	push   $0x0
  pushl $198
c01029bb:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01029c0:	e9 ac 02 00 00       	jmp    c0102c71 <__alltraps>

c01029c5 <vector199>:
.globl vector199
vector199:
  pushl $0
c01029c5:	6a 00                	push   $0x0
  pushl $199
c01029c7:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01029cc:	e9 a0 02 00 00       	jmp    c0102c71 <__alltraps>

c01029d1 <vector200>:
.globl vector200
vector200:
  pushl $0
c01029d1:	6a 00                	push   $0x0
  pushl $200
c01029d3:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01029d8:	e9 94 02 00 00       	jmp    c0102c71 <__alltraps>

c01029dd <vector201>:
.globl vector201
vector201:
  pushl $0
c01029dd:	6a 00                	push   $0x0
  pushl $201
c01029df:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01029e4:	e9 88 02 00 00       	jmp    c0102c71 <__alltraps>

c01029e9 <vector202>:
.globl vector202
vector202:
  pushl $0
c01029e9:	6a 00                	push   $0x0
  pushl $202
c01029eb:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01029f0:	e9 7c 02 00 00       	jmp    c0102c71 <__alltraps>

c01029f5 <vector203>:
.globl vector203
vector203:
  pushl $0
c01029f5:	6a 00                	push   $0x0
  pushl $203
c01029f7:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01029fc:	e9 70 02 00 00       	jmp    c0102c71 <__alltraps>

c0102a01 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102a01:	6a 00                	push   $0x0
  pushl $204
c0102a03:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102a08:	e9 64 02 00 00       	jmp    c0102c71 <__alltraps>

c0102a0d <vector205>:
.globl vector205
vector205:
  pushl $0
c0102a0d:	6a 00                	push   $0x0
  pushl $205
c0102a0f:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102a14:	e9 58 02 00 00       	jmp    c0102c71 <__alltraps>

c0102a19 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102a19:	6a 00                	push   $0x0
  pushl $206
c0102a1b:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102a20:	e9 4c 02 00 00       	jmp    c0102c71 <__alltraps>

c0102a25 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102a25:	6a 00                	push   $0x0
  pushl $207
c0102a27:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102a2c:	e9 40 02 00 00       	jmp    c0102c71 <__alltraps>

c0102a31 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102a31:	6a 00                	push   $0x0
  pushl $208
c0102a33:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102a38:	e9 34 02 00 00       	jmp    c0102c71 <__alltraps>

c0102a3d <vector209>:
.globl vector209
vector209:
  pushl $0
c0102a3d:	6a 00                	push   $0x0
  pushl $209
c0102a3f:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102a44:	e9 28 02 00 00       	jmp    c0102c71 <__alltraps>

c0102a49 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102a49:	6a 00                	push   $0x0
  pushl $210
c0102a4b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102a50:	e9 1c 02 00 00       	jmp    c0102c71 <__alltraps>

c0102a55 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102a55:	6a 00                	push   $0x0
  pushl $211
c0102a57:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102a5c:	e9 10 02 00 00       	jmp    c0102c71 <__alltraps>

c0102a61 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102a61:	6a 00                	push   $0x0
  pushl $212
c0102a63:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102a68:	e9 04 02 00 00       	jmp    c0102c71 <__alltraps>

c0102a6d <vector213>:
.globl vector213
vector213:
  pushl $0
c0102a6d:	6a 00                	push   $0x0
  pushl $213
c0102a6f:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102a74:	e9 f8 01 00 00       	jmp    c0102c71 <__alltraps>

c0102a79 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102a79:	6a 00                	push   $0x0
  pushl $214
c0102a7b:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102a80:	e9 ec 01 00 00       	jmp    c0102c71 <__alltraps>

c0102a85 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102a85:	6a 00                	push   $0x0
  pushl $215
c0102a87:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102a8c:	e9 e0 01 00 00       	jmp    c0102c71 <__alltraps>

c0102a91 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102a91:	6a 00                	push   $0x0
  pushl $216
c0102a93:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102a98:	e9 d4 01 00 00       	jmp    c0102c71 <__alltraps>

c0102a9d <vector217>:
.globl vector217
vector217:
  pushl $0
c0102a9d:	6a 00                	push   $0x0
  pushl $217
c0102a9f:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102aa4:	e9 c8 01 00 00       	jmp    c0102c71 <__alltraps>

c0102aa9 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102aa9:	6a 00                	push   $0x0
  pushl $218
c0102aab:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102ab0:	e9 bc 01 00 00       	jmp    c0102c71 <__alltraps>

c0102ab5 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102ab5:	6a 00                	push   $0x0
  pushl $219
c0102ab7:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102abc:	e9 b0 01 00 00       	jmp    c0102c71 <__alltraps>

c0102ac1 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102ac1:	6a 00                	push   $0x0
  pushl $220
c0102ac3:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102ac8:	e9 a4 01 00 00       	jmp    c0102c71 <__alltraps>

c0102acd <vector221>:
.globl vector221
vector221:
  pushl $0
c0102acd:	6a 00                	push   $0x0
  pushl $221
c0102acf:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102ad4:	e9 98 01 00 00       	jmp    c0102c71 <__alltraps>

c0102ad9 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102ad9:	6a 00                	push   $0x0
  pushl $222
c0102adb:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102ae0:	e9 8c 01 00 00       	jmp    c0102c71 <__alltraps>

c0102ae5 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102ae5:	6a 00                	push   $0x0
  pushl $223
c0102ae7:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102aec:	e9 80 01 00 00       	jmp    c0102c71 <__alltraps>

c0102af1 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102af1:	6a 00                	push   $0x0
  pushl $224
c0102af3:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102af8:	e9 74 01 00 00       	jmp    c0102c71 <__alltraps>

c0102afd <vector225>:
.globl vector225
vector225:
  pushl $0
c0102afd:	6a 00                	push   $0x0
  pushl $225
c0102aff:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102b04:	e9 68 01 00 00       	jmp    c0102c71 <__alltraps>

c0102b09 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102b09:	6a 00                	push   $0x0
  pushl $226
c0102b0b:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102b10:	e9 5c 01 00 00       	jmp    c0102c71 <__alltraps>

c0102b15 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102b15:	6a 00                	push   $0x0
  pushl $227
c0102b17:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102b1c:	e9 50 01 00 00       	jmp    c0102c71 <__alltraps>

c0102b21 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102b21:	6a 00                	push   $0x0
  pushl $228
c0102b23:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102b28:	e9 44 01 00 00       	jmp    c0102c71 <__alltraps>

c0102b2d <vector229>:
.globl vector229
vector229:
  pushl $0
c0102b2d:	6a 00                	push   $0x0
  pushl $229
c0102b2f:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102b34:	e9 38 01 00 00       	jmp    c0102c71 <__alltraps>

c0102b39 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102b39:	6a 00                	push   $0x0
  pushl $230
c0102b3b:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102b40:	e9 2c 01 00 00       	jmp    c0102c71 <__alltraps>

c0102b45 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102b45:	6a 00                	push   $0x0
  pushl $231
c0102b47:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102b4c:	e9 20 01 00 00       	jmp    c0102c71 <__alltraps>

c0102b51 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102b51:	6a 00                	push   $0x0
  pushl $232
c0102b53:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102b58:	e9 14 01 00 00       	jmp    c0102c71 <__alltraps>

c0102b5d <vector233>:
.globl vector233
vector233:
  pushl $0
c0102b5d:	6a 00                	push   $0x0
  pushl $233
c0102b5f:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102b64:	e9 08 01 00 00       	jmp    c0102c71 <__alltraps>

c0102b69 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102b69:	6a 00                	push   $0x0
  pushl $234
c0102b6b:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102b70:	e9 fc 00 00 00       	jmp    c0102c71 <__alltraps>

c0102b75 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102b75:	6a 00                	push   $0x0
  pushl $235
c0102b77:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102b7c:	e9 f0 00 00 00       	jmp    c0102c71 <__alltraps>

c0102b81 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102b81:	6a 00                	push   $0x0
  pushl $236
c0102b83:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102b88:	e9 e4 00 00 00       	jmp    c0102c71 <__alltraps>

c0102b8d <vector237>:
.globl vector237
vector237:
  pushl $0
c0102b8d:	6a 00                	push   $0x0
  pushl $237
c0102b8f:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102b94:	e9 d8 00 00 00       	jmp    c0102c71 <__alltraps>

c0102b99 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102b99:	6a 00                	push   $0x0
  pushl $238
c0102b9b:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102ba0:	e9 cc 00 00 00       	jmp    c0102c71 <__alltraps>

c0102ba5 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102ba5:	6a 00                	push   $0x0
  pushl $239
c0102ba7:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102bac:	e9 c0 00 00 00       	jmp    c0102c71 <__alltraps>

c0102bb1 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102bb1:	6a 00                	push   $0x0
  pushl $240
c0102bb3:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102bb8:	e9 b4 00 00 00       	jmp    c0102c71 <__alltraps>

c0102bbd <vector241>:
.globl vector241
vector241:
  pushl $0
c0102bbd:	6a 00                	push   $0x0
  pushl $241
c0102bbf:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102bc4:	e9 a8 00 00 00       	jmp    c0102c71 <__alltraps>

c0102bc9 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102bc9:	6a 00                	push   $0x0
  pushl $242
c0102bcb:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102bd0:	e9 9c 00 00 00       	jmp    c0102c71 <__alltraps>

c0102bd5 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102bd5:	6a 00                	push   $0x0
  pushl $243
c0102bd7:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102bdc:	e9 90 00 00 00       	jmp    c0102c71 <__alltraps>

c0102be1 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102be1:	6a 00                	push   $0x0
  pushl $244
c0102be3:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102be8:	e9 84 00 00 00       	jmp    c0102c71 <__alltraps>

c0102bed <vector245>:
.globl vector245
vector245:
  pushl $0
c0102bed:	6a 00                	push   $0x0
  pushl $245
c0102bef:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102bf4:	e9 78 00 00 00       	jmp    c0102c71 <__alltraps>

c0102bf9 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102bf9:	6a 00                	push   $0x0
  pushl $246
c0102bfb:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102c00:	e9 6c 00 00 00       	jmp    c0102c71 <__alltraps>

c0102c05 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102c05:	6a 00                	push   $0x0
  pushl $247
c0102c07:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102c0c:	e9 60 00 00 00       	jmp    c0102c71 <__alltraps>

c0102c11 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102c11:	6a 00                	push   $0x0
  pushl $248
c0102c13:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102c18:	e9 54 00 00 00       	jmp    c0102c71 <__alltraps>

c0102c1d <vector249>:
.globl vector249
vector249:
  pushl $0
c0102c1d:	6a 00                	push   $0x0
  pushl $249
c0102c1f:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102c24:	e9 48 00 00 00       	jmp    c0102c71 <__alltraps>

c0102c29 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102c29:	6a 00                	push   $0x0
  pushl $250
c0102c2b:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102c30:	e9 3c 00 00 00       	jmp    c0102c71 <__alltraps>

c0102c35 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102c35:	6a 00                	push   $0x0
  pushl $251
c0102c37:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102c3c:	e9 30 00 00 00       	jmp    c0102c71 <__alltraps>

c0102c41 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102c41:	6a 00                	push   $0x0
  pushl $252
c0102c43:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102c48:	e9 24 00 00 00       	jmp    c0102c71 <__alltraps>

c0102c4d <vector253>:
.globl vector253
vector253:
  pushl $0
c0102c4d:	6a 00                	push   $0x0
  pushl $253
c0102c4f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102c54:	e9 18 00 00 00       	jmp    c0102c71 <__alltraps>

c0102c59 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102c59:	6a 00                	push   $0x0
  pushl $254
c0102c5b:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102c60:	e9 0c 00 00 00       	jmp    c0102c71 <__alltraps>

c0102c65 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102c65:	6a 00                	push   $0x0
  pushl $255
c0102c67:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102c6c:	e9 00 00 00 00       	jmp    c0102c71 <__alltraps>

c0102c71 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102c71:	1e                   	push   %ds
    pushl %es
c0102c72:	06                   	push   %es
    pushl %fs
c0102c73:	0f a0                	push   %fs
    pushl %gs
c0102c75:	0f a8                	push   %gs
    pushal
c0102c77:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102c78:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102c7d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102c7f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102c81:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102c82:	e8 59 f5 ff ff       	call   c01021e0 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102c87:	5c                   	pop    %esp

c0102c88 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102c88:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102c89:	0f a9                	pop    %gs
    popl %fs
c0102c8b:	0f a1                	pop    %fs
    popl %es
c0102c8d:	07                   	pop    %es
    popl %ds
c0102c8e:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102c8f:	83 c4 08             	add    $0x8,%esp
    iret
c0102c92:	cf                   	iret   

c0102c93 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102c93:	55                   	push   %ebp
c0102c94:	89 e5                	mov    %esp,%ebp
c0102c96:	e8 17 d6 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102c9b:	05 b5 5c 01 00       	add    $0x15cb5,%eax
    return page - pages;
c0102ca0:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ca3:	c7 c0 18 bf 11 c0    	mov    $0xc011bf18,%eax
c0102ca9:	8b 00                	mov    (%eax),%eax
c0102cab:	29 c2                	sub    %eax,%edx
c0102cad:	89 d0                	mov    %edx,%eax
c0102caf:	c1 f8 02             	sar    $0x2,%eax
c0102cb2:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102cb8:	5d                   	pop    %ebp
c0102cb9:	c3                   	ret    

c0102cba <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102cba:	55                   	push   %ebp
c0102cbb:	89 e5                	mov    %esp,%ebp
c0102cbd:	e8 f0 d5 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102cc2:	05 8e 5c 01 00       	add    $0x15c8e,%eax
    return page2ppn(page) << PGSHIFT;
c0102cc7:	ff 75 08             	pushl  0x8(%ebp)
c0102cca:	e8 c4 ff ff ff       	call   c0102c93 <page2ppn>
c0102ccf:	83 c4 04             	add    $0x4,%esp
c0102cd2:	c1 e0 0c             	shl    $0xc,%eax
}
c0102cd5:	c9                   	leave  
c0102cd6:	c3                   	ret    

c0102cd7 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102cd7:	55                   	push   %ebp
c0102cd8:	89 e5                	mov    %esp,%ebp
c0102cda:	53                   	push   %ebx
c0102cdb:	83 ec 04             	sub    $0x4,%esp
c0102cde:	e8 cf d5 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102ce3:	05 6d 5c 01 00       	add    $0x15c6d,%eax
    if (PPN(pa) >= npage) {
c0102ce8:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ceb:	89 d1                	mov    %edx,%ecx
c0102ced:	c1 e9 0c             	shr    $0xc,%ecx
c0102cf0:	8b 90 30 35 00 00    	mov    0x3530(%eax),%edx
c0102cf6:	39 d1                	cmp    %edx,%ecx
c0102cf8:	72 1a                	jb     c0102d14 <pa2page+0x3d>
        panic("pa2page called with invalid pa");
c0102cfa:	83 ec 04             	sub    $0x4,%esp
c0102cfd:	8d 90 98 e2 fe ff    	lea    -0x11d68(%eax),%edx
c0102d03:	52                   	push   %edx
c0102d04:	6a 5a                	push   $0x5a
c0102d06:	8d 90 b7 e2 fe ff    	lea    -0x11d49(%eax),%edx
c0102d0c:	52                   	push   %edx
c0102d0d:	89 c3                	mov    %eax,%ebx
c0102d0f:	e8 c5 d7 ff ff       	call   c01004d9 <__panic>
    }
    return &pages[PPN(pa)];
c0102d14:	c7 c0 18 bf 11 c0    	mov    $0xc011bf18,%eax
c0102d1a:	8b 08                	mov    (%eax),%ecx
c0102d1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d1f:	c1 e8 0c             	shr    $0xc,%eax
c0102d22:	89 c2                	mov    %eax,%edx
c0102d24:	89 d0                	mov    %edx,%eax
c0102d26:	c1 e0 02             	shl    $0x2,%eax
c0102d29:	01 d0                	add    %edx,%eax
c0102d2b:	c1 e0 02             	shl    $0x2,%eax
c0102d2e:	01 c8                	add    %ecx,%eax
}
c0102d30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102d33:	c9                   	leave  
c0102d34:	c3                   	ret    

c0102d35 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102d35:	55                   	push   %ebp
c0102d36:	89 e5                	mov    %esp,%ebp
c0102d38:	53                   	push   %ebx
c0102d39:	83 ec 14             	sub    $0x14,%esp
c0102d3c:	e8 75 d5 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0102d41:	81 c3 0f 5c 01 00    	add    $0x15c0f,%ebx
    return KADDR(page2pa(page));
c0102d47:	ff 75 08             	pushl  0x8(%ebp)
c0102d4a:	e8 6b ff ff ff       	call   c0102cba <page2pa>
c0102d4f:	83 c4 04             	add    $0x4,%esp
c0102d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d58:	c1 e8 0c             	shr    $0xc,%eax
c0102d5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102d5e:	8b 83 30 35 00 00    	mov    0x3530(%ebx),%eax
c0102d64:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102d67:	72 18                	jb     c0102d81 <page2kva+0x4c>
c0102d69:	ff 75 f4             	pushl  -0xc(%ebp)
c0102d6c:	8d 83 c8 e2 fe ff    	lea    -0x11d38(%ebx),%eax
c0102d72:	50                   	push   %eax
c0102d73:	6a 61                	push   $0x61
c0102d75:	8d 83 b7 e2 fe ff    	lea    -0x11d49(%ebx),%eax
c0102d7b:	50                   	push   %eax
c0102d7c:	e8 58 d7 ff ff       	call   c01004d9 <__panic>
c0102d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d84:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102d89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102d8c:	c9                   	leave  
c0102d8d:	c3                   	ret    

c0102d8e <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102d8e:	55                   	push   %ebp
c0102d8f:	89 e5                	mov    %esp,%ebp
c0102d91:	53                   	push   %ebx
c0102d92:	83 ec 04             	sub    $0x4,%esp
c0102d95:	e8 18 d5 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102d9a:	05 b6 5b 01 00       	add    $0x15bb6,%eax
    if (!(pte & PTE_P)) {
c0102d9f:	8b 55 08             	mov    0x8(%ebp),%edx
c0102da2:	83 e2 01             	and    $0x1,%edx
c0102da5:	85 d2                	test   %edx,%edx
c0102da7:	75 1a                	jne    c0102dc3 <pte2page+0x35>
        panic("pte2page called with invalid pte");
c0102da9:	83 ec 04             	sub    $0x4,%esp
c0102dac:	8d 90 ec e2 fe ff    	lea    -0x11d14(%eax),%edx
c0102db2:	52                   	push   %edx
c0102db3:	6a 6c                	push   $0x6c
c0102db5:	8d 90 b7 e2 fe ff    	lea    -0x11d49(%eax),%edx
c0102dbb:	52                   	push   %edx
c0102dbc:	89 c3                	mov    %eax,%ebx
c0102dbe:	e8 16 d7 ff ff       	call   c01004d9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102dc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102dcb:	83 ec 0c             	sub    $0xc,%esp
c0102dce:	50                   	push   %eax
c0102dcf:	e8 03 ff ff ff       	call   c0102cd7 <pa2page>
c0102dd4:	83 c4 10             	add    $0x10,%esp
}
c0102dd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102dda:	c9                   	leave  
c0102ddb:	c3                   	ret    

c0102ddc <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102ddc:	55                   	push   %ebp
c0102ddd:	89 e5                	mov    %esp,%ebp
c0102ddf:	83 ec 08             	sub    $0x8,%esp
c0102de2:	e8 cb d4 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102de7:	05 69 5b 01 00       	add    $0x15b69,%eax
    return pa2page(PDE_ADDR(pde));
c0102dec:	8b 45 08             	mov    0x8(%ebp),%eax
c0102def:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102df4:	83 ec 0c             	sub    $0xc,%esp
c0102df7:	50                   	push   %eax
c0102df8:	e8 da fe ff ff       	call   c0102cd7 <pa2page>
c0102dfd:	83 c4 10             	add    $0x10,%esp
}
c0102e00:	c9                   	leave  
c0102e01:	c3                   	ret    

c0102e02 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102e02:	55                   	push   %ebp
c0102e03:	89 e5                	mov    %esp,%ebp
c0102e05:	e8 a8 d4 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102e0a:	05 46 5b 01 00       	add    $0x15b46,%eax
    return page->ref;
c0102e0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e12:	8b 00                	mov    (%eax),%eax
}
c0102e14:	5d                   	pop    %ebp
c0102e15:	c3                   	ret    

c0102e16 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102e16:	55                   	push   %ebp
c0102e17:	89 e5                	mov    %esp,%ebp
c0102e19:	e8 94 d4 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102e1e:	05 32 5b 01 00       	add    $0x15b32,%eax
    page->ref = val;
c0102e23:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e26:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e29:	89 10                	mov    %edx,(%eax)
}
c0102e2b:	90                   	nop
c0102e2c:	5d                   	pop    %ebp
c0102e2d:	c3                   	ret    

c0102e2e <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102e2e:	55                   	push   %ebp
c0102e2f:	89 e5                	mov    %esp,%ebp
c0102e31:	e8 7c d4 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102e36:	05 1a 5b 01 00       	add    $0x15b1a,%eax
    page->ref += 1;
c0102e3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e3e:	8b 00                	mov    (%eax),%eax
c0102e40:	8d 50 01             	lea    0x1(%eax),%edx
c0102e43:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e46:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102e48:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e4b:	8b 00                	mov    (%eax),%eax
}
c0102e4d:	5d                   	pop    %ebp
c0102e4e:	c3                   	ret    

c0102e4f <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102e4f:	55                   	push   %ebp
c0102e50:	89 e5                	mov    %esp,%ebp
c0102e52:	e8 5b d4 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102e57:	05 f9 5a 01 00       	add    $0x15af9,%eax
    page->ref -= 1;
c0102e5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e5f:	8b 00                	mov    (%eax),%eax
c0102e61:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102e64:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e67:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102e69:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e6c:	8b 00                	mov    (%eax),%eax
}
c0102e6e:	5d                   	pop    %ebp
c0102e6f:	c3                   	ret    

c0102e70 <__intr_save>:
__intr_save(void) {
c0102e70:	55                   	push   %ebp
c0102e71:	89 e5                	mov    %esp,%ebp
c0102e73:	53                   	push   %ebx
c0102e74:	83 ec 14             	sub    $0x14,%esp
c0102e77:	e8 36 d4 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102e7c:	05 d4 5a 01 00       	add    $0x15ad4,%eax
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102e81:	9c                   	pushf  
c0102e82:	5a                   	pop    %edx
c0102e83:	89 55 f4             	mov    %edx,-0xc(%ebp)
    return eflags;
c0102e86:	8b 55 f4             	mov    -0xc(%ebp),%edx
    if (read_eflags() & FL_IF) {
c0102e89:	81 e2 00 02 00 00    	and    $0x200,%edx
c0102e8f:	85 d2                	test   %edx,%edx
c0102e91:	74 0e                	je     c0102ea1 <__intr_save+0x31>
        intr_disable();
c0102e93:	89 c3                	mov    %eax,%ebx
c0102e95:	e8 86 ed ff ff       	call   c0101c20 <intr_disable>
        return 1;
c0102e9a:	b8 01 00 00 00       	mov    $0x1,%eax
c0102e9f:	eb 05                	jmp    c0102ea6 <__intr_save+0x36>
    return 0;
c0102ea1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102ea6:	83 c4 14             	add    $0x14,%esp
c0102ea9:	5b                   	pop    %ebx
c0102eaa:	5d                   	pop    %ebp
c0102eab:	c3                   	ret    

c0102eac <__intr_restore>:
__intr_restore(bool flag) {
c0102eac:	55                   	push   %ebp
c0102ead:	89 e5                	mov    %esp,%ebp
c0102eaf:	53                   	push   %ebx
c0102eb0:	83 ec 04             	sub    $0x4,%esp
c0102eb3:	e8 fa d3 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102eb8:	05 98 5a 01 00       	add    $0x15a98,%eax
    if (flag) {
c0102ebd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102ec1:	74 07                	je     c0102eca <__intr_restore+0x1e>
        intr_enable();
c0102ec3:	89 c3                	mov    %eax,%ebx
c0102ec5:	e8 45 ed ff ff       	call   c0101c0f <intr_enable>
}
c0102eca:	90                   	nop
c0102ecb:	83 c4 04             	add    $0x4,%esp
c0102ece:	5b                   	pop    %ebx
c0102ecf:	5d                   	pop    %ebp
c0102ed0:	c3                   	ret    

c0102ed1 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102ed1:	55                   	push   %ebp
c0102ed2:	89 e5                	mov    %esp,%ebp
c0102ed4:	e8 d9 d3 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102ed9:	05 77 5a 01 00       	add    $0x15a77,%eax
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102ede:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ee1:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102ee4:	b8 23 00 00 00       	mov    $0x23,%eax
c0102ee9:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102eeb:	b8 23 00 00 00       	mov    $0x23,%eax
c0102ef0:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102ef2:	b8 10 00 00 00       	mov    $0x10,%eax
c0102ef7:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102ef9:	b8 10 00 00 00       	mov    $0x10,%eax
c0102efe:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102f00:	b8 10 00 00 00       	mov    $0x10,%eax
c0102f05:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102f07:	ea 0e 2f 10 c0 08 00 	ljmp   $0x8,$0xc0102f0e
}
c0102f0e:	90                   	nop
c0102f0f:	5d                   	pop    %ebp
c0102f10:	c3                   	ret    

c0102f11 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102f11:	55                   	push   %ebp
c0102f12:	89 e5                	mov    %esp,%ebp
c0102f14:	e8 99 d3 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102f19:	05 37 5a 01 00       	add    $0x15a37,%eax
    ts.ts_esp0 = esp0;
c0102f1e:	8b 55 08             	mov    0x8(%ebp),%edx
c0102f21:	89 90 54 35 00 00    	mov    %edx,0x3554(%eax)
}
c0102f27:	90                   	nop
c0102f28:	5d                   	pop    %ebp
c0102f29:	c3                   	ret    

c0102f2a <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102f2a:	55                   	push   %ebp
c0102f2b:	89 e5                	mov    %esp,%ebp
c0102f2d:	53                   	push   %ebx
c0102f2e:	83 ec 10             	sub    $0x10,%esp
c0102f31:	e8 80 d3 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0102f36:	81 c3 1a 5a 01 00    	add    $0x15a1a,%ebx
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102f3c:	c7 c0 00 80 11 c0    	mov    $0xc0118000,%eax
c0102f42:	50                   	push   %eax
c0102f43:	e8 c9 ff ff ff       	call   c0102f11 <load_esp0>
c0102f48:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102f4b:	66 c7 83 58 35 00 00 	movw   $0x10,0x3558(%ebx)
c0102f52:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102f54:	66 c7 83 f8 ff ff ff 	movw   $0x68,-0x8(%ebx)
c0102f5b:	68 00 
c0102f5d:	8d 83 50 35 00 00    	lea    0x3550(%ebx),%eax
c0102f63:	66 89 83 fa ff ff ff 	mov    %ax,-0x6(%ebx)
c0102f6a:	8d 83 50 35 00 00    	lea    0x3550(%ebx),%eax
c0102f70:	c1 e8 10             	shr    $0x10,%eax
c0102f73:	88 83 fc ff ff ff    	mov    %al,-0x4(%ebx)
c0102f79:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
c0102f80:	83 e0 f0             	and    $0xfffffff0,%eax
c0102f83:	83 c8 09             	or     $0x9,%eax
c0102f86:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
c0102f8c:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
c0102f93:	83 e0 ef             	and    $0xffffffef,%eax
c0102f96:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
c0102f9c:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
c0102fa3:	83 e0 9f             	and    $0xffffff9f,%eax
c0102fa6:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
c0102fac:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
c0102fb3:	83 c8 80             	or     $0xffffff80,%eax
c0102fb6:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
c0102fbc:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c0102fc3:	83 e0 f0             	and    $0xfffffff0,%eax
c0102fc6:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c0102fcc:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c0102fd3:	83 e0 ef             	and    $0xffffffef,%eax
c0102fd6:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c0102fdc:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c0102fe3:	83 e0 df             	and    $0xffffffdf,%eax
c0102fe6:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c0102fec:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c0102ff3:	83 c8 40             	or     $0x40,%eax
c0102ff6:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c0102ffc:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c0103003:	83 e0 7f             	and    $0x7f,%eax
c0103006:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c010300c:	8d 83 50 35 00 00    	lea    0x3550(%ebx),%eax
c0103012:	c1 e8 18             	shr    $0x18,%eax
c0103015:	88 83 ff ff ff ff    	mov    %al,-0x1(%ebx)

    // reload all segment registers
    lgdt(&gdt_pd);
c010301b:	8d 83 d0 00 00 00    	lea    0xd0(%ebx),%eax
c0103021:	50                   	push   %eax
c0103022:	e8 aa fe ff ff       	call   c0102ed1 <lgdt>
c0103027:	83 c4 04             	add    $0x4,%esp
c010302a:	66 c7 45 fa 28 00    	movw   $0x28,-0x6(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103030:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0103034:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103037:	90                   	nop
c0103038:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010303b:	c9                   	leave  
c010303c:	c3                   	ret    

c010303d <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c010303d:	55                   	push   %ebp
c010303e:	89 e5                	mov    %esp,%ebp
c0103040:	53                   	push   %ebx
c0103041:	83 ec 04             	sub    $0x4,%esp
c0103044:	e8 6d d2 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0103049:	81 c3 07 59 01 00    	add    $0x15907,%ebx
    pmm_manager = &default_pmm_manager;
c010304f:	c7 c0 10 bf 11 c0    	mov    $0xc011bf10,%eax
c0103055:	c7 c2 90 8a 11 c0    	mov    $0xc0118a90,%edx
c010305b:	89 10                	mov    %edx,(%eax)
    cprintf("memory management: %s\n", pmm_manager->name);
c010305d:	c7 c0 10 bf 11 c0    	mov    $0xc011bf10,%eax
c0103063:	8b 00                	mov    (%eax),%eax
c0103065:	8b 00                	mov    (%eax),%eax
c0103067:	83 ec 08             	sub    $0x8,%esp
c010306a:	50                   	push   %eax
c010306b:	8d 83 18 e3 fe ff    	lea    -0x11ce8(%ebx),%eax
c0103071:	50                   	push   %eax
c0103072:	e8 b2 d2 ff ff       	call   c0100329 <cprintf>
c0103077:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c010307a:	c7 c0 10 bf 11 c0    	mov    $0xc011bf10,%eax
c0103080:	8b 00                	mov    (%eax),%eax
c0103082:	8b 40 04             	mov    0x4(%eax),%eax
c0103085:	ff d0                	call   *%eax
}
c0103087:	90                   	nop
c0103088:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010308b:	c9                   	leave  
c010308c:	c3                   	ret    

c010308d <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c010308d:	55                   	push   %ebp
c010308e:	89 e5                	mov    %esp,%ebp
c0103090:	83 ec 08             	sub    $0x8,%esp
c0103093:	e8 1a d2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0103098:	05 b8 58 01 00       	add    $0x158b8,%eax
    pmm_manager->init_memmap(base, n);
c010309d:	c7 c0 10 bf 11 c0    	mov    $0xc011bf10,%eax
c01030a3:	8b 00                	mov    (%eax),%eax
c01030a5:	8b 40 08             	mov    0x8(%eax),%eax
c01030a8:	83 ec 08             	sub    $0x8,%esp
c01030ab:	ff 75 0c             	pushl  0xc(%ebp)
c01030ae:	ff 75 08             	pushl  0x8(%ebp)
c01030b1:	ff d0                	call   *%eax
c01030b3:	83 c4 10             	add    $0x10,%esp
}
c01030b6:	90                   	nop
c01030b7:	c9                   	leave  
c01030b8:	c3                   	ret    

c01030b9 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c01030b9:	55                   	push   %ebp
c01030ba:	89 e5                	mov    %esp,%ebp
c01030bc:	53                   	push   %ebx
c01030bd:	83 ec 14             	sub    $0x14,%esp
c01030c0:	e8 f1 d1 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c01030c5:	81 c3 8b 58 01 00    	add    $0x1588b,%ebx
    struct Page *page=NULL;
c01030cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01030d2:	e8 99 fd ff ff       	call   c0102e70 <__intr_save>
c01030d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c01030da:	c7 c0 10 bf 11 c0    	mov    $0xc011bf10,%eax
c01030e0:	8b 00                	mov    (%eax),%eax
c01030e2:	8b 40 0c             	mov    0xc(%eax),%eax
c01030e5:	83 ec 0c             	sub    $0xc,%esp
c01030e8:	ff 75 08             	pushl  0x8(%ebp)
c01030eb:	ff d0                	call   *%eax
c01030ed:	83 c4 10             	add    $0x10,%esp
c01030f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c01030f3:	83 ec 0c             	sub    $0xc,%esp
c01030f6:	ff 75 f0             	pushl  -0x10(%ebp)
c01030f9:	e8 ae fd ff ff       	call   c0102eac <__intr_restore>
c01030fe:	83 c4 10             	add    $0x10,%esp
    return page;
c0103101:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103104:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103107:	c9                   	leave  
c0103108:	c3                   	ret    

c0103109 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103109:	55                   	push   %ebp
c010310a:	89 e5                	mov    %esp,%ebp
c010310c:	53                   	push   %ebx
c010310d:	83 ec 14             	sub    $0x14,%esp
c0103110:	e8 a1 d1 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0103115:	81 c3 3b 58 01 00    	add    $0x1583b,%ebx
    bool intr_flag;
    local_intr_save(intr_flag);
c010311b:	e8 50 fd ff ff       	call   c0102e70 <__intr_save>
c0103120:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103123:	c7 c0 10 bf 11 c0    	mov    $0xc011bf10,%eax
c0103129:	8b 00                	mov    (%eax),%eax
c010312b:	8b 40 10             	mov    0x10(%eax),%eax
c010312e:	83 ec 08             	sub    $0x8,%esp
c0103131:	ff 75 0c             	pushl  0xc(%ebp)
c0103134:	ff 75 08             	pushl  0x8(%ebp)
c0103137:	ff d0                	call   *%eax
c0103139:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c010313c:	83 ec 0c             	sub    $0xc,%esp
c010313f:	ff 75 f4             	pushl  -0xc(%ebp)
c0103142:	e8 65 fd ff ff       	call   c0102eac <__intr_restore>
c0103147:	83 c4 10             	add    $0x10,%esp
}
c010314a:	90                   	nop
c010314b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010314e:	c9                   	leave  
c010314f:	c3                   	ret    

c0103150 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103150:	55                   	push   %ebp
c0103151:	89 e5                	mov    %esp,%ebp
c0103153:	53                   	push   %ebx
c0103154:	83 ec 14             	sub    $0x14,%esp
c0103157:	e8 5a d1 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c010315c:	81 c3 f4 57 01 00    	add    $0x157f4,%ebx
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103162:	e8 09 fd ff ff       	call   c0102e70 <__intr_save>
c0103167:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c010316a:	c7 c0 10 bf 11 c0    	mov    $0xc011bf10,%eax
c0103170:	8b 00                	mov    (%eax),%eax
c0103172:	8b 40 14             	mov    0x14(%eax),%eax
c0103175:	ff d0                	call   *%eax
c0103177:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c010317a:	83 ec 0c             	sub    $0xc,%esp
c010317d:	ff 75 f4             	pushl  -0xc(%ebp)
c0103180:	e8 27 fd ff ff       	call   c0102eac <__intr_restore>
c0103185:	83 c4 10             	add    $0x10,%esp
    return ret;
c0103188:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010318b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010318e:	c9                   	leave  
c010318f:	c3                   	ret    

c0103190 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103190:	55                   	push   %ebp
c0103191:	89 e5                	mov    %esp,%ebp
c0103193:	57                   	push   %edi
c0103194:	56                   	push   %esi
c0103195:	53                   	push   %ebx
c0103196:	83 ec 7c             	sub    $0x7c,%esp
c0103199:	e8 cf 15 00 00       	call   c010476d <__x86.get_pc_thunk.si>
c010319e:	81 c6 b2 57 01 00    	add    $0x157b2,%esi
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01031a4:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01031ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01031b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c01031b9:	83 ec 0c             	sub    $0xc,%esp
c01031bc:	8d 86 2f e3 fe ff    	lea    -0x11cd1(%esi),%eax
c01031c2:	50                   	push   %eax
c01031c3:	89 f3                	mov    %esi,%ebx
c01031c5:	e8 5f d1 ff ff       	call   c0100329 <cprintf>
c01031ca:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01031cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01031d4:	e9 02 01 00 00       	jmp    c01032db <page_init+0x14b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01031d9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01031dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031df:	89 d0                	mov    %edx,%eax
c01031e1:	c1 e0 02             	shl    $0x2,%eax
c01031e4:	01 d0                	add    %edx,%eax
c01031e6:	c1 e0 02             	shl    $0x2,%eax
c01031e9:	01 c8                	add    %ecx,%eax
c01031eb:	8b 50 08             	mov    0x8(%eax),%edx
c01031ee:	8b 40 04             	mov    0x4(%eax),%eax
c01031f1:	89 45 a0             	mov    %eax,-0x60(%ebp)
c01031f4:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c01031f7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01031fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031fd:	89 d0                	mov    %edx,%eax
c01031ff:	c1 e0 02             	shl    $0x2,%eax
c0103202:	01 d0                	add    %edx,%eax
c0103204:	c1 e0 02             	shl    $0x2,%eax
c0103207:	01 c8                	add    %ecx,%eax
c0103209:	8b 48 0c             	mov    0xc(%eax),%ecx
c010320c:	8b 58 10             	mov    0x10(%eax),%ebx
c010320f:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103212:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103215:	01 c8                	add    %ecx,%eax
c0103217:	11 da                	adc    %ebx,%edx
c0103219:	89 45 98             	mov    %eax,-0x68(%ebp)
c010321c:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c010321f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103222:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103225:	89 d0                	mov    %edx,%eax
c0103227:	c1 e0 02             	shl    $0x2,%eax
c010322a:	01 d0                	add    %edx,%eax
c010322c:	c1 e0 02             	shl    $0x2,%eax
c010322f:	01 c8                	add    %ecx,%eax
c0103231:	83 c0 14             	add    $0x14,%eax
c0103234:	8b 00                	mov    (%eax),%eax
c0103236:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c010323c:	8b 45 98             	mov    -0x68(%ebp),%eax
c010323f:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103242:	83 c0 ff             	add    $0xffffffff,%eax
c0103245:	83 d2 ff             	adc    $0xffffffff,%edx
c0103248:	89 c1                	mov    %eax,%ecx
c010324a:	89 d3                	mov    %edx,%ebx
c010324c:	8b 7d c4             	mov    -0x3c(%ebp),%edi
c010324f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103252:	89 d0                	mov    %edx,%eax
c0103254:	c1 e0 02             	shl    $0x2,%eax
c0103257:	01 d0                	add    %edx,%eax
c0103259:	c1 e0 02             	shl    $0x2,%eax
c010325c:	01 f8                	add    %edi,%eax
c010325e:	8b 50 10             	mov    0x10(%eax),%edx
c0103261:	8b 40 0c             	mov    0xc(%eax),%eax
c0103264:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
c010326a:	53                   	push   %ebx
c010326b:	51                   	push   %ecx
c010326c:	ff 75 a4             	pushl  -0x5c(%ebp)
c010326f:	ff 75 a0             	pushl  -0x60(%ebp)
c0103272:	52                   	push   %edx
c0103273:	50                   	push   %eax
c0103274:	8d 86 3c e3 fe ff    	lea    -0x11cc4(%esi),%eax
c010327a:	50                   	push   %eax
c010327b:	89 f3                	mov    %esi,%ebx
c010327d:	e8 a7 d0 ff ff       	call   c0100329 <cprintf>
c0103282:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103285:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103288:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010328b:	89 d0                	mov    %edx,%eax
c010328d:	c1 e0 02             	shl    $0x2,%eax
c0103290:	01 d0                	add    %edx,%eax
c0103292:	c1 e0 02             	shl    $0x2,%eax
c0103295:	01 c8                	add    %ecx,%eax
c0103297:	83 c0 14             	add    $0x14,%eax
c010329a:	8b 00                	mov    (%eax),%eax
c010329c:	83 f8 01             	cmp    $0x1,%eax
c010329f:	75 36                	jne    c01032d7 <page_init+0x147>
            if (maxpa < end && begin < KMEMSIZE) {
c01032a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01032a7:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c01032aa:	77 2b                	ja     c01032d7 <page_init+0x147>
c01032ac:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c01032af:	72 05                	jb     c01032b6 <page_init+0x126>
c01032b1:	3b 45 98             	cmp    -0x68(%ebp),%eax
c01032b4:	73 21                	jae    c01032d7 <page_init+0x147>
c01032b6:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01032ba:	77 1b                	ja     c01032d7 <page_init+0x147>
c01032bc:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01032c0:	72 09                	jb     c01032cb <page_init+0x13b>
c01032c2:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
c01032c9:	77 0c                	ja     c01032d7 <page_init+0x147>
                maxpa = end;
c01032cb:	8b 45 98             	mov    -0x68(%ebp),%eax
c01032ce:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01032d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01032d4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c01032d7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01032db:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01032de:	8b 00                	mov    (%eax),%eax
c01032e0:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01032e3:	0f 8c f0 fe ff ff    	jl     c01031d9 <page_init+0x49>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01032e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01032ed:	72 1d                	jb     c010330c <page_init+0x17c>
c01032ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01032f3:	77 09                	ja     c01032fe <page_init+0x16e>
c01032f5:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01032fc:	76 0e                	jbe    c010330c <page_init+0x17c>
        maxpa = KMEMSIZE;
c01032fe:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103305:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c010330c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010330f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103312:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103316:	c1 ea 0c             	shr    $0xc,%edx
c0103319:	89 c1                	mov    %eax,%ecx
c010331b:	89 d3                	mov    %edx,%ebx
c010331d:	89 c8                	mov    %ecx,%eax
c010331f:	89 86 30 35 00 00    	mov    %eax,0x3530(%esi)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103325:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c010332c:	c7 c0 28 bf 11 c0    	mov    $0xc011bf28,%eax
c0103332:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103335:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103338:	01 d0                	add    %edx,%eax
c010333a:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010333d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103340:	ba 00 00 00 00       	mov    $0x0,%edx
c0103345:	f7 75 c0             	divl   -0x40(%ebp)
c0103348:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010334b:	29 d0                	sub    %edx,%eax
c010334d:	89 c2                	mov    %eax,%edx
c010334f:	c7 c0 18 bf 11 c0    	mov    $0xc011bf18,%eax
c0103355:	89 10                	mov    %edx,(%eax)

    for (i = 0; i < npage; i ++) {
c0103357:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010335e:	eb 31                	jmp    c0103391 <page_init+0x201>
        SetPageReserved(pages + i);
c0103360:	c7 c0 18 bf 11 c0    	mov    $0xc011bf18,%eax
c0103366:	8b 08                	mov    (%eax),%ecx
c0103368:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010336b:	89 d0                	mov    %edx,%eax
c010336d:	c1 e0 02             	shl    $0x2,%eax
c0103370:	01 d0                	add    %edx,%eax
c0103372:	c1 e0 02             	shl    $0x2,%eax
c0103375:	01 c8                	add    %ecx,%eax
c0103377:	83 c0 04             	add    $0x4,%eax
c010337a:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0103381:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103384:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103387:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010338a:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c010338d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103391:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103394:	8b 86 30 35 00 00    	mov    0x3530(%esi),%eax
c010339a:	39 c2                	cmp    %eax,%edx
c010339c:	72 c2                	jb     c0103360 <page_init+0x1d0>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c010339e:	8b 96 30 35 00 00    	mov    0x3530(%esi),%edx
c01033a4:	89 d0                	mov    %edx,%eax
c01033a6:	c1 e0 02             	shl    $0x2,%eax
c01033a9:	01 d0                	add    %edx,%eax
c01033ab:	c1 e0 02             	shl    $0x2,%eax
c01033ae:	89 c2                	mov    %eax,%edx
c01033b0:	c7 c0 18 bf 11 c0    	mov    $0xc011bf18,%eax
c01033b6:	8b 00                	mov    (%eax),%eax
c01033b8:	01 d0                	add    %edx,%eax
c01033ba:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01033bd:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c01033c4:	77 1d                	ja     c01033e3 <page_init+0x253>
c01033c6:	ff 75 b8             	pushl  -0x48(%ebp)
c01033c9:	8d 86 6c e3 fe ff    	lea    -0x11c94(%esi),%eax
c01033cf:	50                   	push   %eax
c01033d0:	68 dc 00 00 00       	push   $0xdc
c01033d5:	8d 86 90 e3 fe ff    	lea    -0x11c70(%esi),%eax
c01033db:	50                   	push   %eax
c01033dc:	89 f3                	mov    %esi,%ebx
c01033de:	e8 f6 d0 ff ff       	call   c01004d9 <__panic>
c01033e3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01033e6:	05 00 00 00 40       	add    $0x40000000,%eax
c01033eb:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01033ee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01033f5:	e9 79 01 00 00       	jmp    c0103573 <page_init+0x3e3>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01033fa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01033fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103400:	89 d0                	mov    %edx,%eax
c0103402:	c1 e0 02             	shl    $0x2,%eax
c0103405:	01 d0                	add    %edx,%eax
c0103407:	c1 e0 02             	shl    $0x2,%eax
c010340a:	01 c8                	add    %ecx,%eax
c010340c:	8b 50 08             	mov    0x8(%eax),%edx
c010340f:	8b 40 04             	mov    0x4(%eax),%eax
c0103412:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103415:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103418:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010341b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010341e:	89 d0                	mov    %edx,%eax
c0103420:	c1 e0 02             	shl    $0x2,%eax
c0103423:	01 d0                	add    %edx,%eax
c0103425:	c1 e0 02             	shl    $0x2,%eax
c0103428:	01 c8                	add    %ecx,%eax
c010342a:	8b 48 0c             	mov    0xc(%eax),%ecx
c010342d:	8b 58 10             	mov    0x10(%eax),%ebx
c0103430:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103433:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103436:	01 c8                	add    %ecx,%eax
c0103438:	11 da                	adc    %ebx,%edx
c010343a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010343d:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103440:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103443:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103446:	89 d0                	mov    %edx,%eax
c0103448:	c1 e0 02             	shl    $0x2,%eax
c010344b:	01 d0                	add    %edx,%eax
c010344d:	c1 e0 02             	shl    $0x2,%eax
c0103450:	01 c8                	add    %ecx,%eax
c0103452:	83 c0 14             	add    $0x14,%eax
c0103455:	8b 00                	mov    (%eax),%eax
c0103457:	83 f8 01             	cmp    $0x1,%eax
c010345a:	0f 85 0f 01 00 00    	jne    c010356f <page_init+0x3df>
            if (begin < freemem) {
c0103460:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103463:	ba 00 00 00 00       	mov    $0x0,%edx
c0103468:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c010346b:	77 17                	ja     c0103484 <page_init+0x2f4>
c010346d:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0103470:	72 05                	jb     c0103477 <page_init+0x2e7>
c0103472:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103475:	73 0d                	jae    c0103484 <page_init+0x2f4>
                begin = freemem;
c0103477:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010347a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010347d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103484:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103488:	72 1d                	jb     c01034a7 <page_init+0x317>
c010348a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010348e:	77 09                	ja     c0103499 <page_init+0x309>
c0103490:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0103497:	76 0e                	jbe    c01034a7 <page_init+0x317>
                end = KMEMSIZE;
c0103499:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01034a0:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01034a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01034aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01034ad:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01034b0:	0f 87 b9 00 00 00    	ja     c010356f <page_init+0x3df>
c01034b6:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01034b9:	72 09                	jb     c01034c4 <page_init+0x334>
c01034bb:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01034be:	0f 83 ab 00 00 00    	jae    c010356f <page_init+0x3df>
                begin = ROUNDUP(begin, PGSIZE);
c01034c4:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c01034cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01034ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01034d1:	01 d0                	add    %edx,%eax
c01034d3:	83 e8 01             	sub    $0x1,%eax
c01034d6:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01034d9:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01034dc:	ba 00 00 00 00       	mov    $0x0,%edx
c01034e1:	f7 75 b0             	divl   -0x50(%ebp)
c01034e4:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01034e7:	29 d0                	sub    %edx,%eax
c01034e9:	ba 00 00 00 00       	mov    $0x0,%edx
c01034ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01034f1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01034f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01034f7:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01034fa:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01034fd:	ba 00 00 00 00       	mov    $0x0,%edx
c0103502:	89 c7                	mov    %eax,%edi
c0103504:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010350a:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010350d:	89 d0                	mov    %edx,%eax
c010350f:	83 e0 00             	and    $0x0,%eax
c0103512:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0103515:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103518:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010351b:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010351e:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0103521:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103524:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103527:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010352a:	77 43                	ja     c010356f <page_init+0x3df>
c010352c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010352f:	72 05                	jb     c0103536 <page_init+0x3a6>
c0103531:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103534:	73 39                	jae    c010356f <page_init+0x3df>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103536:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103539:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010353c:	2b 45 d0             	sub    -0x30(%ebp),%eax
c010353f:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0103542:	89 c3                	mov    %eax,%ebx
c0103544:	89 d6                	mov    %edx,%esi
c0103546:	89 d8                	mov    %ebx,%eax
c0103548:	89 f2                	mov    %esi,%edx
c010354a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010354e:	c1 ea 0c             	shr    $0xc,%edx
c0103551:	89 c3                	mov    %eax,%ebx
c0103553:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103556:	83 ec 0c             	sub    $0xc,%esp
c0103559:	50                   	push   %eax
c010355a:	e8 78 f7 ff ff       	call   c0102cd7 <pa2page>
c010355f:	83 c4 10             	add    $0x10,%esp
c0103562:	83 ec 08             	sub    $0x8,%esp
c0103565:	53                   	push   %ebx
c0103566:	50                   	push   %eax
c0103567:	e8 21 fb ff ff       	call   c010308d <init_memmap>
c010356c:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i ++) {
c010356f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103573:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103576:	8b 00                	mov    (%eax),%eax
c0103578:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010357b:	0f 8c 79 fe ff ff    	jl     c01033fa <page_init+0x26a>
                }
            }
        }
    }
}
c0103581:	90                   	nop
c0103582:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103585:	5b                   	pop    %ebx
c0103586:	5e                   	pop    %esi
c0103587:	5f                   	pop    %edi
c0103588:	5d                   	pop    %ebp
c0103589:	c3                   	ret    

c010358a <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010358a:	55                   	push   %ebp
c010358b:	89 e5                	mov    %esp,%ebp
c010358d:	53                   	push   %ebx
c010358e:	83 ec 24             	sub    $0x24,%esp
c0103591:	e8 20 cd ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0103596:	81 c3 ba 53 01 00    	add    $0x153ba,%ebx
    assert(PGOFF(la) == PGOFF(pa));
c010359c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010359f:	33 45 14             	xor    0x14(%ebp),%eax
c01035a2:	25 ff 0f 00 00       	and    $0xfff,%eax
c01035a7:	85 c0                	test   %eax,%eax
c01035a9:	74 1f                	je     c01035ca <boot_map_segment+0x40>
c01035ab:	8d 83 9e e3 fe ff    	lea    -0x11c62(%ebx),%eax
c01035b1:	50                   	push   %eax
c01035b2:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c01035b8:	50                   	push   %eax
c01035b9:	68 fa 00 00 00       	push   $0xfa
c01035be:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c01035c4:	50                   	push   %eax
c01035c5:	e8 0f cf ff ff       	call   c01004d9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01035ca:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01035d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035d4:	25 ff 0f 00 00       	and    $0xfff,%eax
c01035d9:	89 c2                	mov    %eax,%edx
c01035db:	8b 45 10             	mov    0x10(%ebp),%eax
c01035de:	01 c2                	add    %eax,%edx
c01035e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035e3:	01 d0                	add    %edx,%eax
c01035e5:	83 e8 01             	sub    $0x1,%eax
c01035e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01035eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035ee:	ba 00 00 00 00       	mov    $0x0,%edx
c01035f3:	f7 75 f0             	divl   -0x10(%ebp)
c01035f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035f9:	29 d0                	sub    %edx,%eax
c01035fb:	c1 e8 0c             	shr    $0xc,%eax
c01035fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0103601:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103604:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103607:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010360a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010360f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103612:	8b 45 14             	mov    0x14(%ebp),%eax
c0103615:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010361b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103620:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103623:	eb 5d                	jmp    c0103682 <boot_map_segment+0xf8>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103625:	83 ec 04             	sub    $0x4,%esp
c0103628:	6a 01                	push   $0x1
c010362a:	ff 75 0c             	pushl  0xc(%ebp)
c010362d:	ff 75 08             	pushl  0x8(%ebp)
c0103630:	e8 8e 01 00 00       	call   c01037c3 <get_pte>
c0103635:	83 c4 10             	add    $0x10,%esp
c0103638:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010363b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010363f:	75 1f                	jne    c0103660 <boot_map_segment+0xd6>
c0103641:	8d 83 ca e3 fe ff    	lea    -0x11c36(%ebx),%eax
c0103647:	50                   	push   %eax
c0103648:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c010364e:	50                   	push   %eax
c010364f:	68 00 01 00 00       	push   $0x100
c0103654:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c010365a:	50                   	push   %eax
c010365b:	e8 79 ce ff ff       	call   c01004d9 <__panic>
        *ptep = pa | PTE_P | perm;
c0103660:	8b 45 14             	mov    0x14(%ebp),%eax
c0103663:	0b 45 18             	or     0x18(%ebp),%eax
c0103666:	83 c8 01             	or     $0x1,%eax
c0103669:	89 c2                	mov    %eax,%edx
c010366b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010366e:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103670:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103674:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010367b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103686:	75 9d                	jne    c0103625 <boot_map_segment+0x9b>
    }
}
c0103688:	90                   	nop
c0103689:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010368c:	c9                   	leave  
c010368d:	c3                   	ret    

c010368e <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010368e:	55                   	push   %ebp
c010368f:	89 e5                	mov    %esp,%ebp
c0103691:	53                   	push   %ebx
c0103692:	83 ec 14             	sub    $0x14,%esp
c0103695:	e8 1c cc ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c010369a:	81 c3 b6 52 01 00    	add    $0x152b6,%ebx
    struct Page *p = alloc_page();
c01036a0:	83 ec 0c             	sub    $0xc,%esp
c01036a3:	6a 01                	push   $0x1
c01036a5:	e8 0f fa ff ff       	call   c01030b9 <alloc_pages>
c01036aa:	83 c4 10             	add    $0x10,%esp
c01036ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01036b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01036b4:	75 1b                	jne    c01036d1 <boot_alloc_page+0x43>
        panic("boot_alloc_page failed.\n");
c01036b6:	83 ec 04             	sub    $0x4,%esp
c01036b9:	8d 83 d7 e3 fe ff    	lea    -0x11c29(%ebx),%eax
c01036bf:	50                   	push   %eax
c01036c0:	68 0c 01 00 00       	push   $0x10c
c01036c5:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c01036cb:	50                   	push   %eax
c01036cc:	e8 08 ce ff ff       	call   c01004d9 <__panic>
    }
    return page2kva(p);
c01036d1:	83 ec 0c             	sub    $0xc,%esp
c01036d4:	ff 75 f4             	pushl  -0xc(%ebp)
c01036d7:	e8 59 f6 ff ff       	call   c0102d35 <page2kva>
c01036dc:	83 c4 10             	add    $0x10,%esp
}
c01036df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01036e2:	c9                   	leave  
c01036e3:	c3                   	ret    

c01036e4 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01036e4:	55                   	push   %ebp
c01036e5:	89 e5                	mov    %esp,%ebp
c01036e7:	53                   	push   %ebx
c01036e8:	83 ec 14             	sub    $0x14,%esp
c01036eb:	e8 c6 cb ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c01036f0:	81 c3 60 52 01 00    	add    $0x15260,%ebx
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01036f6:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c01036fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01036ff:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103706:	77 1b                	ja     c0103723 <pmm_init+0x3f>
c0103708:	ff 75 f4             	pushl  -0xc(%ebp)
c010370b:	8d 83 6c e3 fe ff    	lea    -0x11c94(%ebx),%eax
c0103711:	50                   	push   %eax
c0103712:	68 16 01 00 00       	push   $0x116
c0103717:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c010371d:	50                   	push   %eax
c010371e:	e8 b6 cd ff ff       	call   c01004d9 <__panic>
c0103723:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103726:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010372c:	c7 c0 14 bf 11 c0    	mov    $0xc011bf14,%eax
c0103732:	89 10                	mov    %edx,(%eax)
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103734:	e8 04 f9 ff ff       	call   c010303d <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103739:	e8 52 fa ff ff       	call   c0103190 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010373e:	e8 ef 03 00 00       	call   c0103b32 <check_alloc_page>

    check_pgdir();
c0103743:	e8 21 04 00 00       	call   c0103b69 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103748:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c010374e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103751:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103758:	77 1b                	ja     c0103775 <pmm_init+0x91>
c010375a:	ff 75 f0             	pushl  -0x10(%ebp)
c010375d:	8d 83 6c e3 fe ff    	lea    -0x11c94(%ebx),%eax
c0103763:	50                   	push   %eax
c0103764:	68 2c 01 00 00       	push   $0x12c
c0103769:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c010376f:	50                   	push   %eax
c0103770:	e8 64 cd ff ff       	call   c01004d9 <__panic>
c0103775:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103778:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010377e:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103784:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103789:	83 ca 03             	or     $0x3,%edx
c010378c:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010378e:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103794:	83 ec 0c             	sub    $0xc,%esp
c0103797:	6a 02                	push   $0x2
c0103799:	6a 00                	push   $0x0
c010379b:	68 00 00 00 38       	push   $0x38000000
c01037a0:	68 00 00 00 c0       	push   $0xc0000000
c01037a5:	50                   	push   %eax
c01037a6:	e8 df fd ff ff       	call   c010358a <boot_map_segment>
c01037ab:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01037ae:	e8 77 f7 ff ff       	call   c0102f2a <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01037b3:	e8 d5 09 00 00       	call   c010418d <check_boot_pgdir>

    print_pgdir();
c01037b8:	e8 43 0e 00 00       	call   c0104600 <print_pgdir>

}
c01037bd:	90                   	nop
c01037be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01037c1:	c9                   	leave  
c01037c2:	c3                   	ret    

c01037c3 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01037c3:	55                   	push   %ebp
c01037c4:	89 e5                	mov    %esp,%ebp
c01037c6:	53                   	push   %ebx
c01037c7:	83 ec 24             	sub    $0x24,%esp
c01037ca:	e8 e7 ca ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c01037cf:	81 c3 81 51 01 00    	add    $0x15181,%ebx
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01037d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037d8:	c1 e8 16             	shr    $0x16,%eax
c01037db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01037e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01037e5:	01 d0                	add    %edx,%eax
c01037e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c01037ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037ed:	8b 00                	mov    (%eax),%eax
c01037ef:	83 e0 01             	and    $0x1,%eax
c01037f2:	85 c0                	test   %eax,%eax
c01037f4:	0f 85 a4 00 00 00    	jne    c010389e <get_pte+0xdb>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c01037fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01037fe:	74 16                	je     c0103816 <get_pte+0x53>
c0103800:	83 ec 0c             	sub    $0xc,%esp
c0103803:	6a 01                	push   $0x1
c0103805:	e8 af f8 ff ff       	call   c01030b9 <alloc_pages>
c010380a:	83 c4 10             	add    $0x10,%esp
c010380d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103810:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103814:	75 0a                	jne    c0103820 <get_pte+0x5d>
            return NULL;
c0103816:	b8 00 00 00 00       	mov    $0x0,%eax
c010381b:	e9 d4 00 00 00       	jmp    c01038f4 <get_pte+0x131>
        }
        set_page_ref(page, 1);
c0103820:	83 ec 08             	sub    $0x8,%esp
c0103823:	6a 01                	push   $0x1
c0103825:	ff 75 f0             	pushl  -0x10(%ebp)
c0103828:	e8 e9 f5 ff ff       	call   c0102e16 <set_page_ref>
c010382d:	83 c4 10             	add    $0x10,%esp
        uintptr_t pa = page2pa(page);
c0103830:	83 ec 0c             	sub    $0xc,%esp
c0103833:	ff 75 f0             	pushl  -0x10(%ebp)
c0103836:	e8 7f f4 ff ff       	call   c0102cba <page2pa>
c010383b:	83 c4 10             	add    $0x10,%esp
c010383e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0103841:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103844:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103847:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010384a:	c1 e8 0c             	shr    $0xc,%eax
c010384d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103850:	8b 83 30 35 00 00    	mov    0x3530(%ebx),%eax
c0103856:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103859:	72 1b                	jb     c0103876 <get_pte+0xb3>
c010385b:	ff 75 e8             	pushl  -0x18(%ebp)
c010385e:	8d 83 c8 e2 fe ff    	lea    -0x11d38(%ebx),%eax
c0103864:	50                   	push   %eax
c0103865:	68 72 01 00 00       	push   $0x172
c010386a:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103870:	50                   	push   %eax
c0103871:	e8 63 cc ff ff       	call   c01004d9 <__panic>
c0103876:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103879:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010387e:	83 ec 04             	sub    $0x4,%esp
c0103881:	68 00 10 00 00       	push   $0x1000
c0103886:	6a 00                	push   $0x0
c0103888:	50                   	push   %eax
c0103889:	e8 81 24 00 00       	call   c0105d0f <memset>
c010388e:	83 c4 10             	add    $0x10,%esp
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0103891:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103894:	83 c8 07             	or     $0x7,%eax
c0103897:	89 c2                	mov    %eax,%edx
c0103899:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010389c:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c010389e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038a1:	8b 00                	mov    (%eax),%eax
c01038a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01038a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01038ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038ae:	c1 e8 0c             	shr    $0xc,%eax
c01038b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01038b4:	8b 83 30 35 00 00    	mov    0x3530(%ebx),%eax
c01038ba:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01038bd:	72 1b                	jb     c01038da <get_pte+0x117>
c01038bf:	ff 75 e0             	pushl  -0x20(%ebp)
c01038c2:	8d 83 c8 e2 fe ff    	lea    -0x11d38(%ebx),%eax
c01038c8:	50                   	push   %eax
c01038c9:	68 75 01 00 00       	push   $0x175
c01038ce:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c01038d4:	50                   	push   %eax
c01038d5:	e8 ff cb ff ff       	call   c01004d9 <__panic>
c01038da:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038dd:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01038e2:	89 c2                	mov    %eax,%edx
c01038e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01038e7:	c1 e8 0c             	shr    $0xc,%eax
c01038ea:	25 ff 03 00 00       	and    $0x3ff,%eax
c01038ef:	c1 e0 02             	shl    $0x2,%eax
c01038f2:	01 d0                	add    %edx,%eax
}
c01038f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01038f7:	c9                   	leave  
c01038f8:	c3                   	ret    

c01038f9 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01038f9:	55                   	push   %ebp
c01038fa:	89 e5                	mov    %esp,%ebp
c01038fc:	83 ec 18             	sub    $0x18,%esp
c01038ff:	e8 ae c9 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0103904:	05 4c 50 01 00       	add    $0x1504c,%eax
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103909:	83 ec 04             	sub    $0x4,%esp
c010390c:	6a 00                	push   $0x0
c010390e:	ff 75 0c             	pushl  0xc(%ebp)
c0103911:	ff 75 08             	pushl  0x8(%ebp)
c0103914:	e8 aa fe ff ff       	call   c01037c3 <get_pte>
c0103919:	83 c4 10             	add    $0x10,%esp
c010391c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010391f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103923:	74 08                	je     c010392d <get_page+0x34>
        *ptep_store = ptep;
c0103925:	8b 45 10             	mov    0x10(%ebp),%eax
c0103928:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010392b:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010392d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103931:	74 1f                	je     c0103952 <get_page+0x59>
c0103933:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103936:	8b 00                	mov    (%eax),%eax
c0103938:	83 e0 01             	and    $0x1,%eax
c010393b:	85 c0                	test   %eax,%eax
c010393d:	74 13                	je     c0103952 <get_page+0x59>
        return pte2page(*ptep);
c010393f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103942:	8b 00                	mov    (%eax),%eax
c0103944:	83 ec 0c             	sub    $0xc,%esp
c0103947:	50                   	push   %eax
c0103948:	e8 41 f4 ff ff       	call   c0102d8e <pte2page>
c010394d:	83 c4 10             	add    $0x10,%esp
c0103950:	eb 05                	jmp    c0103957 <get_page+0x5e>
    }
    return NULL;
c0103952:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103957:	c9                   	leave  
c0103958:	c3                   	ret    

c0103959 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103959:	55                   	push   %ebp
c010395a:	89 e5                	mov    %esp,%ebp
c010395c:	83 ec 18             	sub    $0x18,%esp
c010395f:	e8 4e c9 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0103964:	05 ec 4f 01 00       	add    $0x14fec,%eax
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0103969:	8b 45 10             	mov    0x10(%ebp),%eax
c010396c:	8b 00                	mov    (%eax),%eax
c010396e:	83 e0 01             	and    $0x1,%eax
c0103971:	85 c0                	test   %eax,%eax
c0103973:	74 50                	je     c01039c5 <page_remove_pte+0x6c>
        struct Page *page = pte2page(*ptep);
c0103975:	8b 45 10             	mov    0x10(%ebp),%eax
c0103978:	8b 00                	mov    (%eax),%eax
c010397a:	83 ec 0c             	sub    $0xc,%esp
c010397d:	50                   	push   %eax
c010397e:	e8 0b f4 ff ff       	call   c0102d8e <pte2page>
c0103983:	83 c4 10             	add    $0x10,%esp
c0103986:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c0103989:	83 ec 0c             	sub    $0xc,%esp
c010398c:	ff 75 f4             	pushl  -0xc(%ebp)
c010398f:	e8 bb f4 ff ff       	call   c0102e4f <page_ref_dec>
c0103994:	83 c4 10             	add    $0x10,%esp
c0103997:	85 c0                	test   %eax,%eax
c0103999:	75 10                	jne    c01039ab <page_remove_pte+0x52>
            free_page(page);
c010399b:	83 ec 08             	sub    $0x8,%esp
c010399e:	6a 01                	push   $0x1
c01039a0:	ff 75 f4             	pushl  -0xc(%ebp)
c01039a3:	e8 61 f7 ff ff       	call   c0103109 <free_pages>
c01039a8:	83 c4 10             	add    $0x10,%esp
        }
        *ptep = 0;
c01039ab:	8b 45 10             	mov    0x10(%ebp),%eax
c01039ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c01039b4:	83 ec 08             	sub    $0x8,%esp
c01039b7:	ff 75 0c             	pushl  0xc(%ebp)
c01039ba:	ff 75 08             	pushl  0x8(%ebp)
c01039bd:	e8 0c 01 00 00       	call   c0103ace <tlb_invalidate>
c01039c2:	83 c4 10             	add    $0x10,%esp
    }
}
c01039c5:	90                   	nop
c01039c6:	c9                   	leave  
c01039c7:	c3                   	ret    

c01039c8 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01039c8:	55                   	push   %ebp
c01039c9:	89 e5                	mov    %esp,%ebp
c01039cb:	83 ec 18             	sub    $0x18,%esp
c01039ce:	e8 df c8 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01039d3:	05 7d 4f 01 00       	add    $0x14f7d,%eax
    pte_t *ptep = get_pte(pgdir, la, 0);
c01039d8:	83 ec 04             	sub    $0x4,%esp
c01039db:	6a 00                	push   $0x0
c01039dd:	ff 75 0c             	pushl  0xc(%ebp)
c01039e0:	ff 75 08             	pushl  0x8(%ebp)
c01039e3:	e8 db fd ff ff       	call   c01037c3 <get_pte>
c01039e8:	83 c4 10             	add    $0x10,%esp
c01039eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01039ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01039f2:	74 14                	je     c0103a08 <page_remove+0x40>
        page_remove_pte(pgdir, la, ptep);
c01039f4:	83 ec 04             	sub    $0x4,%esp
c01039f7:	ff 75 f4             	pushl  -0xc(%ebp)
c01039fa:	ff 75 0c             	pushl  0xc(%ebp)
c01039fd:	ff 75 08             	pushl  0x8(%ebp)
c0103a00:	e8 54 ff ff ff       	call   c0103959 <page_remove_pte>
c0103a05:	83 c4 10             	add    $0x10,%esp
    }
}
c0103a08:	90                   	nop
c0103a09:	c9                   	leave  
c0103a0a:	c3                   	ret    

c0103a0b <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103a0b:	55                   	push   %ebp
c0103a0c:	89 e5                	mov    %esp,%ebp
c0103a0e:	83 ec 18             	sub    $0x18,%esp
c0103a11:	e8 9c c8 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0103a16:	05 3a 4f 01 00       	add    $0x14f3a,%eax
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103a1b:	83 ec 04             	sub    $0x4,%esp
c0103a1e:	6a 01                	push   $0x1
c0103a20:	ff 75 10             	pushl  0x10(%ebp)
c0103a23:	ff 75 08             	pushl  0x8(%ebp)
c0103a26:	e8 98 fd ff ff       	call   c01037c3 <get_pte>
c0103a2b:	83 c4 10             	add    $0x10,%esp
c0103a2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103a31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a35:	75 0a                	jne    c0103a41 <page_insert+0x36>
        return -E_NO_MEM;
c0103a37:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103a3c:	e9 8b 00 00 00       	jmp    c0103acc <page_insert+0xc1>
    }
    page_ref_inc(page);
c0103a41:	83 ec 0c             	sub    $0xc,%esp
c0103a44:	ff 75 0c             	pushl  0xc(%ebp)
c0103a47:	e8 e2 f3 ff ff       	call   c0102e2e <page_ref_inc>
c0103a4c:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c0103a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a52:	8b 00                	mov    (%eax),%eax
c0103a54:	83 e0 01             	and    $0x1,%eax
c0103a57:	85 c0                	test   %eax,%eax
c0103a59:	74 40                	je     c0103a9b <page_insert+0x90>
        struct Page *p = pte2page(*ptep);
c0103a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a5e:	8b 00                	mov    (%eax),%eax
c0103a60:	83 ec 0c             	sub    $0xc,%esp
c0103a63:	50                   	push   %eax
c0103a64:	e8 25 f3 ff ff       	call   c0102d8e <pte2page>
c0103a69:	83 c4 10             	add    $0x10,%esp
c0103a6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0103a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a72:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103a75:	75 10                	jne    c0103a87 <page_insert+0x7c>
            page_ref_dec(page);
c0103a77:	83 ec 0c             	sub    $0xc,%esp
c0103a7a:	ff 75 0c             	pushl  0xc(%ebp)
c0103a7d:	e8 cd f3 ff ff       	call   c0102e4f <page_ref_dec>
c0103a82:	83 c4 10             	add    $0x10,%esp
c0103a85:	eb 14                	jmp    c0103a9b <page_insert+0x90>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103a87:	83 ec 04             	sub    $0x4,%esp
c0103a8a:	ff 75 f4             	pushl  -0xc(%ebp)
c0103a8d:	ff 75 10             	pushl  0x10(%ebp)
c0103a90:	ff 75 08             	pushl  0x8(%ebp)
c0103a93:	e8 c1 fe ff ff       	call   c0103959 <page_remove_pte>
c0103a98:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103a9b:	83 ec 0c             	sub    $0xc,%esp
c0103a9e:	ff 75 0c             	pushl  0xc(%ebp)
c0103aa1:	e8 14 f2 ff ff       	call   c0102cba <page2pa>
c0103aa6:	83 c4 10             	add    $0x10,%esp
c0103aa9:	0b 45 14             	or     0x14(%ebp),%eax
c0103aac:	83 c8 01             	or     $0x1,%eax
c0103aaf:	89 c2                	mov    %eax,%edx
c0103ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ab4:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103ab6:	83 ec 08             	sub    $0x8,%esp
c0103ab9:	ff 75 10             	pushl  0x10(%ebp)
c0103abc:	ff 75 08             	pushl  0x8(%ebp)
c0103abf:	e8 0a 00 00 00       	call   c0103ace <tlb_invalidate>
c0103ac4:	83 c4 10             	add    $0x10,%esp
    return 0;
c0103ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103acc:	c9                   	leave  
c0103acd:	c3                   	ret    

c0103ace <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103ace:	55                   	push   %ebp
c0103acf:	89 e5                	mov    %esp,%ebp
c0103ad1:	53                   	push   %ebx
c0103ad2:	83 ec 14             	sub    $0x14,%esp
c0103ad5:	e8 d8 c7 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0103ada:	05 76 4e 01 00       	add    $0x14e76,%eax
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103adf:	0f 20 da             	mov    %cr3,%edx
c0103ae2:	89 55 f0             	mov    %edx,-0x10(%ebp)
    return cr3;
c0103ae5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    if (rcr3() == PADDR(pgdir)) {
c0103ae8:	8b 55 08             	mov    0x8(%ebp),%edx
c0103aeb:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0103aee:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103af5:	77 1d                	ja     c0103b14 <tlb_invalidate+0x46>
c0103af7:	ff 75 f4             	pushl  -0xc(%ebp)
c0103afa:	8d 90 6c e3 fe ff    	lea    -0x11c94(%eax),%edx
c0103b00:	52                   	push   %edx
c0103b01:	68 d7 01 00 00       	push   $0x1d7
c0103b06:	8d 90 90 e3 fe ff    	lea    -0x11c70(%eax),%edx
c0103b0c:	52                   	push   %edx
c0103b0d:	89 c3                	mov    %eax,%ebx
c0103b0f:	e8 c5 c9 ff ff       	call   c01004d9 <__panic>
c0103b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b17:	05 00 00 00 40       	add    $0x40000000,%eax
c0103b1c:	39 c8                	cmp    %ecx,%eax
c0103b1e:	75 0c                	jne    c0103b2c <tlb_invalidate+0x5e>
        invlpg((void *)la);
c0103b20:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b23:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b29:	0f 01 38             	invlpg (%eax)
    }
}
c0103b2c:	90                   	nop
c0103b2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103b30:	c9                   	leave  
c0103b31:	c3                   	ret    

c0103b32 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103b32:	55                   	push   %ebp
c0103b33:	89 e5                	mov    %esp,%ebp
c0103b35:	53                   	push   %ebx
c0103b36:	83 ec 04             	sub    $0x4,%esp
c0103b39:	e8 78 c7 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0103b3e:	81 c3 12 4e 01 00    	add    $0x14e12,%ebx
    pmm_manager->check();
c0103b44:	c7 c0 10 bf 11 c0    	mov    $0xc011bf10,%eax
c0103b4a:	8b 00                	mov    (%eax),%eax
c0103b4c:	8b 40 18             	mov    0x18(%eax),%eax
c0103b4f:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0103b51:	83 ec 0c             	sub    $0xc,%esp
c0103b54:	8d 83 f0 e3 fe ff    	lea    -0x11c10(%ebx),%eax
c0103b5a:	50                   	push   %eax
c0103b5b:	e8 c9 c7 ff ff       	call   c0100329 <cprintf>
c0103b60:	83 c4 10             	add    $0x10,%esp
}
c0103b63:	90                   	nop
c0103b64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103b67:	c9                   	leave  
c0103b68:	c3                   	ret    

c0103b69 <check_pgdir>:

static void
check_pgdir(void) {
c0103b69:	55                   	push   %ebp
c0103b6a:	89 e5                	mov    %esp,%ebp
c0103b6c:	53                   	push   %ebx
c0103b6d:	83 ec 24             	sub    $0x24,%esp
c0103b70:	e8 41 c7 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0103b75:	81 c3 db 4d 01 00    	add    $0x14ddb,%ebx
    assert(npage <= KMEMSIZE / PGSIZE);
c0103b7b:	8b 83 30 35 00 00    	mov    0x3530(%ebx),%eax
c0103b81:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103b86:	76 1f                	jbe    c0103ba7 <check_pgdir+0x3e>
c0103b88:	8d 83 0f e4 fe ff    	lea    -0x11bf1(%ebx),%eax
c0103b8e:	50                   	push   %eax
c0103b8f:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103b95:	50                   	push   %eax
c0103b96:	68 e4 01 00 00       	push   $0x1e4
c0103b9b:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103ba1:	50                   	push   %eax
c0103ba2:	e8 32 c9 ff ff       	call   c01004d9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103ba7:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103bad:	85 c0                	test   %eax,%eax
c0103baf:	74 0f                	je     c0103bc0 <check_pgdir+0x57>
c0103bb1:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103bb7:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103bbc:	85 c0                	test   %eax,%eax
c0103bbe:	74 1f                	je     c0103bdf <check_pgdir+0x76>
c0103bc0:	8d 83 2c e4 fe ff    	lea    -0x11bd4(%ebx),%eax
c0103bc6:	50                   	push   %eax
c0103bc7:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103bcd:	50                   	push   %eax
c0103bce:	68 e5 01 00 00       	push   $0x1e5
c0103bd3:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103bd9:	50                   	push   %eax
c0103bda:	e8 fa c8 ff ff       	call   c01004d9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103bdf:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103be5:	83 ec 04             	sub    $0x4,%esp
c0103be8:	6a 00                	push   $0x0
c0103bea:	6a 00                	push   $0x0
c0103bec:	50                   	push   %eax
c0103bed:	e8 07 fd ff ff       	call   c01038f9 <get_page>
c0103bf2:	83 c4 10             	add    $0x10,%esp
c0103bf5:	85 c0                	test   %eax,%eax
c0103bf7:	74 1f                	je     c0103c18 <check_pgdir+0xaf>
c0103bf9:	8d 83 64 e4 fe ff    	lea    -0x11b9c(%ebx),%eax
c0103bff:	50                   	push   %eax
c0103c00:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103c06:	50                   	push   %eax
c0103c07:	68 e6 01 00 00       	push   $0x1e6
c0103c0c:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103c12:	50                   	push   %eax
c0103c13:	e8 c1 c8 ff ff       	call   c01004d9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103c18:	83 ec 0c             	sub    $0xc,%esp
c0103c1b:	6a 01                	push   $0x1
c0103c1d:	e8 97 f4 ff ff       	call   c01030b9 <alloc_pages>
c0103c22:	83 c4 10             	add    $0x10,%esp
c0103c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103c28:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103c2e:	6a 00                	push   $0x0
c0103c30:	6a 00                	push   $0x0
c0103c32:	ff 75 f4             	pushl  -0xc(%ebp)
c0103c35:	50                   	push   %eax
c0103c36:	e8 d0 fd ff ff       	call   c0103a0b <page_insert>
c0103c3b:	83 c4 10             	add    $0x10,%esp
c0103c3e:	85 c0                	test   %eax,%eax
c0103c40:	74 1f                	je     c0103c61 <check_pgdir+0xf8>
c0103c42:	8d 83 8c e4 fe ff    	lea    -0x11b74(%ebx),%eax
c0103c48:	50                   	push   %eax
c0103c49:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103c4f:	50                   	push   %eax
c0103c50:	68 ea 01 00 00       	push   $0x1ea
c0103c55:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103c5b:	50                   	push   %eax
c0103c5c:	e8 78 c8 ff ff       	call   c01004d9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103c61:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103c67:	83 ec 04             	sub    $0x4,%esp
c0103c6a:	6a 00                	push   $0x0
c0103c6c:	6a 00                	push   $0x0
c0103c6e:	50                   	push   %eax
c0103c6f:	e8 4f fb ff ff       	call   c01037c3 <get_pte>
c0103c74:	83 c4 10             	add    $0x10,%esp
c0103c77:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c7e:	75 1f                	jne    c0103c9f <check_pgdir+0x136>
c0103c80:	8d 83 b8 e4 fe ff    	lea    -0x11b48(%ebx),%eax
c0103c86:	50                   	push   %eax
c0103c87:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103c8d:	50                   	push   %eax
c0103c8e:	68 ed 01 00 00       	push   $0x1ed
c0103c93:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103c99:	50                   	push   %eax
c0103c9a:	e8 3a c8 ff ff       	call   c01004d9 <__panic>
    assert(pte2page(*ptep) == p1);
c0103c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ca2:	8b 00                	mov    (%eax),%eax
c0103ca4:	83 ec 0c             	sub    $0xc,%esp
c0103ca7:	50                   	push   %eax
c0103ca8:	e8 e1 f0 ff ff       	call   c0102d8e <pte2page>
c0103cad:	83 c4 10             	add    $0x10,%esp
c0103cb0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103cb3:	74 1f                	je     c0103cd4 <check_pgdir+0x16b>
c0103cb5:	8d 83 e5 e4 fe ff    	lea    -0x11b1b(%ebx),%eax
c0103cbb:	50                   	push   %eax
c0103cbc:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103cc2:	50                   	push   %eax
c0103cc3:	68 ee 01 00 00       	push   $0x1ee
c0103cc8:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103cce:	50                   	push   %eax
c0103ccf:	e8 05 c8 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p1) == 1);
c0103cd4:	83 ec 0c             	sub    $0xc,%esp
c0103cd7:	ff 75 f4             	pushl  -0xc(%ebp)
c0103cda:	e8 23 f1 ff ff       	call   c0102e02 <page_ref>
c0103cdf:	83 c4 10             	add    $0x10,%esp
c0103ce2:	83 f8 01             	cmp    $0x1,%eax
c0103ce5:	74 1f                	je     c0103d06 <check_pgdir+0x19d>
c0103ce7:	8d 83 fb e4 fe ff    	lea    -0x11b05(%ebx),%eax
c0103ced:	50                   	push   %eax
c0103cee:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103cf4:	50                   	push   %eax
c0103cf5:	68 ef 01 00 00       	push   $0x1ef
c0103cfa:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103d00:	50                   	push   %eax
c0103d01:	e8 d3 c7 ff ff       	call   c01004d9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103d06:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103d0c:	8b 00                	mov    (%eax),%eax
c0103d0e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d13:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103d16:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d19:	c1 e8 0c             	shr    $0xc,%eax
c0103d1c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103d1f:	8b 83 30 35 00 00    	mov    0x3530(%ebx),%eax
c0103d25:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103d28:	72 1b                	jb     c0103d45 <check_pgdir+0x1dc>
c0103d2a:	ff 75 ec             	pushl  -0x14(%ebp)
c0103d2d:	8d 83 c8 e2 fe ff    	lea    -0x11d38(%ebx),%eax
c0103d33:	50                   	push   %eax
c0103d34:	68 f1 01 00 00       	push   $0x1f1
c0103d39:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103d3f:	50                   	push   %eax
c0103d40:	e8 94 c7 ff ff       	call   c01004d9 <__panic>
c0103d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d48:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103d4d:	83 c0 04             	add    $0x4,%eax
c0103d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103d53:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103d59:	83 ec 04             	sub    $0x4,%esp
c0103d5c:	6a 00                	push   $0x0
c0103d5e:	68 00 10 00 00       	push   $0x1000
c0103d63:	50                   	push   %eax
c0103d64:	e8 5a fa ff ff       	call   c01037c3 <get_pte>
c0103d69:	83 c4 10             	add    $0x10,%esp
c0103d6c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103d6f:	74 1f                	je     c0103d90 <check_pgdir+0x227>
c0103d71:	8d 83 10 e5 fe ff    	lea    -0x11af0(%ebx),%eax
c0103d77:	50                   	push   %eax
c0103d78:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103d7e:	50                   	push   %eax
c0103d7f:	68 f2 01 00 00       	push   $0x1f2
c0103d84:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103d8a:	50                   	push   %eax
c0103d8b:	e8 49 c7 ff ff       	call   c01004d9 <__panic>

    p2 = alloc_page();
c0103d90:	83 ec 0c             	sub    $0xc,%esp
c0103d93:	6a 01                	push   $0x1
c0103d95:	e8 1f f3 ff ff       	call   c01030b9 <alloc_pages>
c0103d9a:	83 c4 10             	add    $0x10,%esp
c0103d9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103da0:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103da6:	6a 06                	push   $0x6
c0103da8:	68 00 10 00 00       	push   $0x1000
c0103dad:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103db0:	50                   	push   %eax
c0103db1:	e8 55 fc ff ff       	call   c0103a0b <page_insert>
c0103db6:	83 c4 10             	add    $0x10,%esp
c0103db9:	85 c0                	test   %eax,%eax
c0103dbb:	74 1f                	je     c0103ddc <check_pgdir+0x273>
c0103dbd:	8d 83 38 e5 fe ff    	lea    -0x11ac8(%ebx),%eax
c0103dc3:	50                   	push   %eax
c0103dc4:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103dca:	50                   	push   %eax
c0103dcb:	68 f5 01 00 00       	push   $0x1f5
c0103dd0:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103dd6:	50                   	push   %eax
c0103dd7:	e8 fd c6 ff ff       	call   c01004d9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103ddc:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103de2:	83 ec 04             	sub    $0x4,%esp
c0103de5:	6a 00                	push   $0x0
c0103de7:	68 00 10 00 00       	push   $0x1000
c0103dec:	50                   	push   %eax
c0103ded:	e8 d1 f9 ff ff       	call   c01037c3 <get_pte>
c0103df2:	83 c4 10             	add    $0x10,%esp
c0103df5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103df8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103dfc:	75 1f                	jne    c0103e1d <check_pgdir+0x2b4>
c0103dfe:	8d 83 70 e5 fe ff    	lea    -0x11a90(%ebx),%eax
c0103e04:	50                   	push   %eax
c0103e05:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103e0b:	50                   	push   %eax
c0103e0c:	68 f6 01 00 00       	push   $0x1f6
c0103e11:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103e17:	50                   	push   %eax
c0103e18:	e8 bc c6 ff ff       	call   c01004d9 <__panic>
    assert(*ptep & PTE_U);
c0103e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e20:	8b 00                	mov    (%eax),%eax
c0103e22:	83 e0 04             	and    $0x4,%eax
c0103e25:	85 c0                	test   %eax,%eax
c0103e27:	75 1f                	jne    c0103e48 <check_pgdir+0x2df>
c0103e29:	8d 83 a0 e5 fe ff    	lea    -0x11a60(%ebx),%eax
c0103e2f:	50                   	push   %eax
c0103e30:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103e36:	50                   	push   %eax
c0103e37:	68 f7 01 00 00       	push   $0x1f7
c0103e3c:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103e42:	50                   	push   %eax
c0103e43:	e8 91 c6 ff ff       	call   c01004d9 <__panic>
    assert(*ptep & PTE_W);
c0103e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e4b:	8b 00                	mov    (%eax),%eax
c0103e4d:	83 e0 02             	and    $0x2,%eax
c0103e50:	85 c0                	test   %eax,%eax
c0103e52:	75 1f                	jne    c0103e73 <check_pgdir+0x30a>
c0103e54:	8d 83 ae e5 fe ff    	lea    -0x11a52(%ebx),%eax
c0103e5a:	50                   	push   %eax
c0103e5b:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103e61:	50                   	push   %eax
c0103e62:	68 f8 01 00 00       	push   $0x1f8
c0103e67:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103e6d:	50                   	push   %eax
c0103e6e:	e8 66 c6 ff ff       	call   c01004d9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103e73:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103e79:	8b 00                	mov    (%eax),%eax
c0103e7b:	83 e0 04             	and    $0x4,%eax
c0103e7e:	85 c0                	test   %eax,%eax
c0103e80:	75 1f                	jne    c0103ea1 <check_pgdir+0x338>
c0103e82:	8d 83 bc e5 fe ff    	lea    -0x11a44(%ebx),%eax
c0103e88:	50                   	push   %eax
c0103e89:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103e8f:	50                   	push   %eax
c0103e90:	68 f9 01 00 00       	push   $0x1f9
c0103e95:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103e9b:	50                   	push   %eax
c0103e9c:	e8 38 c6 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p2) == 1);
c0103ea1:	83 ec 0c             	sub    $0xc,%esp
c0103ea4:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103ea7:	e8 56 ef ff ff       	call   c0102e02 <page_ref>
c0103eac:	83 c4 10             	add    $0x10,%esp
c0103eaf:	83 f8 01             	cmp    $0x1,%eax
c0103eb2:	74 1f                	je     c0103ed3 <check_pgdir+0x36a>
c0103eb4:	8d 83 d2 e5 fe ff    	lea    -0x11a2e(%ebx),%eax
c0103eba:	50                   	push   %eax
c0103ebb:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103ec1:	50                   	push   %eax
c0103ec2:	68 fa 01 00 00       	push   $0x1fa
c0103ec7:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103ecd:	50                   	push   %eax
c0103ece:	e8 06 c6 ff ff       	call   c01004d9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103ed3:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103ed9:	6a 00                	push   $0x0
c0103edb:	68 00 10 00 00       	push   $0x1000
c0103ee0:	ff 75 f4             	pushl  -0xc(%ebp)
c0103ee3:	50                   	push   %eax
c0103ee4:	e8 22 fb ff ff       	call   c0103a0b <page_insert>
c0103ee9:	83 c4 10             	add    $0x10,%esp
c0103eec:	85 c0                	test   %eax,%eax
c0103eee:	74 1f                	je     c0103f0f <check_pgdir+0x3a6>
c0103ef0:	8d 83 e4 e5 fe ff    	lea    -0x11a1c(%ebx),%eax
c0103ef6:	50                   	push   %eax
c0103ef7:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103efd:	50                   	push   %eax
c0103efe:	68 fc 01 00 00       	push   $0x1fc
c0103f03:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103f09:	50                   	push   %eax
c0103f0a:	e8 ca c5 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p1) == 2);
c0103f0f:	83 ec 0c             	sub    $0xc,%esp
c0103f12:	ff 75 f4             	pushl  -0xc(%ebp)
c0103f15:	e8 e8 ee ff ff       	call   c0102e02 <page_ref>
c0103f1a:	83 c4 10             	add    $0x10,%esp
c0103f1d:	83 f8 02             	cmp    $0x2,%eax
c0103f20:	74 1f                	je     c0103f41 <check_pgdir+0x3d8>
c0103f22:	8d 83 10 e6 fe ff    	lea    -0x119f0(%ebx),%eax
c0103f28:	50                   	push   %eax
c0103f29:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103f2f:	50                   	push   %eax
c0103f30:	68 fd 01 00 00       	push   $0x1fd
c0103f35:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103f3b:	50                   	push   %eax
c0103f3c:	e8 98 c5 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p2) == 0);
c0103f41:	83 ec 0c             	sub    $0xc,%esp
c0103f44:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103f47:	e8 b6 ee ff ff       	call   c0102e02 <page_ref>
c0103f4c:	83 c4 10             	add    $0x10,%esp
c0103f4f:	85 c0                	test   %eax,%eax
c0103f51:	74 1f                	je     c0103f72 <check_pgdir+0x409>
c0103f53:	8d 83 22 e6 fe ff    	lea    -0x119de(%ebx),%eax
c0103f59:	50                   	push   %eax
c0103f5a:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103f60:	50                   	push   %eax
c0103f61:	68 fe 01 00 00       	push   $0x1fe
c0103f66:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103f6c:	50                   	push   %eax
c0103f6d:	e8 67 c5 ff ff       	call   c01004d9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103f72:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103f78:	83 ec 04             	sub    $0x4,%esp
c0103f7b:	6a 00                	push   $0x0
c0103f7d:	68 00 10 00 00       	push   $0x1000
c0103f82:	50                   	push   %eax
c0103f83:	e8 3b f8 ff ff       	call   c01037c3 <get_pte>
c0103f88:	83 c4 10             	add    $0x10,%esp
c0103f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103f8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103f92:	75 1f                	jne    c0103fb3 <check_pgdir+0x44a>
c0103f94:	8d 83 70 e5 fe ff    	lea    -0x11a90(%ebx),%eax
c0103f9a:	50                   	push   %eax
c0103f9b:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103fa1:	50                   	push   %eax
c0103fa2:	68 ff 01 00 00       	push   $0x1ff
c0103fa7:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103fad:	50                   	push   %eax
c0103fae:	e8 26 c5 ff ff       	call   c01004d9 <__panic>
    assert(pte2page(*ptep) == p1);
c0103fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103fb6:	8b 00                	mov    (%eax),%eax
c0103fb8:	83 ec 0c             	sub    $0xc,%esp
c0103fbb:	50                   	push   %eax
c0103fbc:	e8 cd ed ff ff       	call   c0102d8e <pte2page>
c0103fc1:	83 c4 10             	add    $0x10,%esp
c0103fc4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103fc7:	74 1f                	je     c0103fe8 <check_pgdir+0x47f>
c0103fc9:	8d 83 e5 e4 fe ff    	lea    -0x11b1b(%ebx),%eax
c0103fcf:	50                   	push   %eax
c0103fd0:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0103fd6:	50                   	push   %eax
c0103fd7:	68 00 02 00 00       	push   $0x200
c0103fdc:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0103fe2:	50                   	push   %eax
c0103fe3:	e8 f1 c4 ff ff       	call   c01004d9 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103feb:	8b 00                	mov    (%eax),%eax
c0103fed:	83 e0 04             	and    $0x4,%eax
c0103ff0:	85 c0                	test   %eax,%eax
c0103ff2:	74 1f                	je     c0104013 <check_pgdir+0x4aa>
c0103ff4:	8d 83 34 e6 fe ff    	lea    -0x119cc(%ebx),%eax
c0103ffa:	50                   	push   %eax
c0103ffb:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0104001:	50                   	push   %eax
c0104002:	68 01 02 00 00       	push   $0x201
c0104007:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c010400d:	50                   	push   %eax
c010400e:	e8 c6 c4 ff ff       	call   c01004d9 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104013:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0104019:	83 ec 08             	sub    $0x8,%esp
c010401c:	6a 00                	push   $0x0
c010401e:	50                   	push   %eax
c010401f:	e8 a4 f9 ff ff       	call   c01039c8 <page_remove>
c0104024:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0104027:	83 ec 0c             	sub    $0xc,%esp
c010402a:	ff 75 f4             	pushl  -0xc(%ebp)
c010402d:	e8 d0 ed ff ff       	call   c0102e02 <page_ref>
c0104032:	83 c4 10             	add    $0x10,%esp
c0104035:	83 f8 01             	cmp    $0x1,%eax
c0104038:	74 1f                	je     c0104059 <check_pgdir+0x4f0>
c010403a:	8d 83 fb e4 fe ff    	lea    -0x11b05(%ebx),%eax
c0104040:	50                   	push   %eax
c0104041:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0104047:	50                   	push   %eax
c0104048:	68 04 02 00 00       	push   $0x204
c010404d:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0104053:	50                   	push   %eax
c0104054:	e8 80 c4 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p2) == 0);
c0104059:	83 ec 0c             	sub    $0xc,%esp
c010405c:	ff 75 e4             	pushl  -0x1c(%ebp)
c010405f:	e8 9e ed ff ff       	call   c0102e02 <page_ref>
c0104064:	83 c4 10             	add    $0x10,%esp
c0104067:	85 c0                	test   %eax,%eax
c0104069:	74 1f                	je     c010408a <check_pgdir+0x521>
c010406b:	8d 83 22 e6 fe ff    	lea    -0x119de(%ebx),%eax
c0104071:	50                   	push   %eax
c0104072:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0104078:	50                   	push   %eax
c0104079:	68 05 02 00 00       	push   $0x205
c010407e:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0104084:	50                   	push   %eax
c0104085:	e8 4f c4 ff ff       	call   c01004d9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c010408a:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0104090:	83 ec 08             	sub    $0x8,%esp
c0104093:	68 00 10 00 00       	push   $0x1000
c0104098:	50                   	push   %eax
c0104099:	e8 2a f9 ff ff       	call   c01039c8 <page_remove>
c010409e:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c01040a1:	83 ec 0c             	sub    $0xc,%esp
c01040a4:	ff 75 f4             	pushl  -0xc(%ebp)
c01040a7:	e8 56 ed ff ff       	call   c0102e02 <page_ref>
c01040ac:	83 c4 10             	add    $0x10,%esp
c01040af:	85 c0                	test   %eax,%eax
c01040b1:	74 1f                	je     c01040d2 <check_pgdir+0x569>
c01040b3:	8d 83 49 e6 fe ff    	lea    -0x119b7(%ebx),%eax
c01040b9:	50                   	push   %eax
c01040ba:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c01040c0:	50                   	push   %eax
c01040c1:	68 08 02 00 00       	push   $0x208
c01040c6:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c01040cc:	50                   	push   %eax
c01040cd:	e8 07 c4 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p2) == 0);
c01040d2:	83 ec 0c             	sub    $0xc,%esp
c01040d5:	ff 75 e4             	pushl  -0x1c(%ebp)
c01040d8:	e8 25 ed ff ff       	call   c0102e02 <page_ref>
c01040dd:	83 c4 10             	add    $0x10,%esp
c01040e0:	85 c0                	test   %eax,%eax
c01040e2:	74 1f                	je     c0104103 <check_pgdir+0x59a>
c01040e4:	8d 83 22 e6 fe ff    	lea    -0x119de(%ebx),%eax
c01040ea:	50                   	push   %eax
c01040eb:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c01040f1:	50                   	push   %eax
c01040f2:	68 09 02 00 00       	push   $0x209
c01040f7:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c01040fd:	50                   	push   %eax
c01040fe:	e8 d6 c3 ff ff       	call   c01004d9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104103:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0104109:	8b 00                	mov    (%eax),%eax
c010410b:	83 ec 0c             	sub    $0xc,%esp
c010410e:	50                   	push   %eax
c010410f:	e8 c8 ec ff ff       	call   c0102ddc <pde2page>
c0104114:	83 c4 10             	add    $0x10,%esp
c0104117:	83 ec 0c             	sub    $0xc,%esp
c010411a:	50                   	push   %eax
c010411b:	e8 e2 ec ff ff       	call   c0102e02 <page_ref>
c0104120:	83 c4 10             	add    $0x10,%esp
c0104123:	83 f8 01             	cmp    $0x1,%eax
c0104126:	74 1f                	je     c0104147 <check_pgdir+0x5de>
c0104128:	8d 83 5c e6 fe ff    	lea    -0x119a4(%ebx),%eax
c010412e:	50                   	push   %eax
c010412f:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0104135:	50                   	push   %eax
c0104136:	68 0b 02 00 00       	push   $0x20b
c010413b:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0104141:	50                   	push   %eax
c0104142:	e8 92 c3 ff ff       	call   c01004d9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104147:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c010414d:	8b 00                	mov    (%eax),%eax
c010414f:	83 ec 0c             	sub    $0xc,%esp
c0104152:	50                   	push   %eax
c0104153:	e8 84 ec ff ff       	call   c0102ddc <pde2page>
c0104158:	83 c4 10             	add    $0x10,%esp
c010415b:	83 ec 08             	sub    $0x8,%esp
c010415e:	6a 01                	push   $0x1
c0104160:	50                   	push   %eax
c0104161:	e8 a3 ef ff ff       	call   c0103109 <free_pages>
c0104166:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0104169:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c010416f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104175:	83 ec 0c             	sub    $0xc,%esp
c0104178:	8d 83 83 e6 fe ff    	lea    -0x1197d(%ebx),%eax
c010417e:	50                   	push   %eax
c010417f:	e8 a5 c1 ff ff       	call   c0100329 <cprintf>
c0104184:	83 c4 10             	add    $0x10,%esp
}
c0104187:	90                   	nop
c0104188:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010418b:	c9                   	leave  
c010418c:	c3                   	ret    

c010418d <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c010418d:	55                   	push   %ebp
c010418e:	89 e5                	mov    %esp,%ebp
c0104190:	53                   	push   %ebx
c0104191:	83 ec 24             	sub    $0x24,%esp
c0104194:	e8 1d c1 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0104199:	81 c3 b7 47 01 00    	add    $0x147b7,%ebx
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010419f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01041a6:	e9 b5 00 00 00       	jmp    c0104260 <check_boot_pgdir+0xd3>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01041ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041b4:	c1 e8 0c             	shr    $0xc,%eax
c01041b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01041ba:	8b 83 30 35 00 00    	mov    0x3530(%ebx),%eax
c01041c0:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01041c3:	72 1b                	jb     c01041e0 <check_boot_pgdir+0x53>
c01041c5:	ff 75 e4             	pushl  -0x1c(%ebp)
c01041c8:	8d 83 c8 e2 fe ff    	lea    -0x11d38(%ebx),%eax
c01041ce:	50                   	push   %eax
c01041cf:	68 17 02 00 00       	push   $0x217
c01041d4:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c01041da:	50                   	push   %eax
c01041db:	e8 f9 c2 ff ff       	call   c01004d9 <__panic>
c01041e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041e3:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01041e8:	89 c2                	mov    %eax,%edx
c01041ea:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c01041f0:	83 ec 04             	sub    $0x4,%esp
c01041f3:	6a 00                	push   $0x0
c01041f5:	52                   	push   %edx
c01041f6:	50                   	push   %eax
c01041f7:	e8 c7 f5 ff ff       	call   c01037c3 <get_pte>
c01041fc:	83 c4 10             	add    $0x10,%esp
c01041ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104202:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104206:	75 1f                	jne    c0104227 <check_boot_pgdir+0x9a>
c0104208:	8d 83 a0 e6 fe ff    	lea    -0x11960(%ebx),%eax
c010420e:	50                   	push   %eax
c010420f:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0104215:	50                   	push   %eax
c0104216:	68 17 02 00 00       	push   $0x217
c010421b:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0104221:	50                   	push   %eax
c0104222:	e8 b2 c2 ff ff       	call   c01004d9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104227:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010422a:	8b 00                	mov    (%eax),%eax
c010422c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104231:	89 c2                	mov    %eax,%edx
c0104233:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104236:	39 c2                	cmp    %eax,%edx
c0104238:	74 1f                	je     c0104259 <check_boot_pgdir+0xcc>
c010423a:	8d 83 dd e6 fe ff    	lea    -0x11923(%ebx),%eax
c0104240:	50                   	push   %eax
c0104241:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0104247:	50                   	push   %eax
c0104248:	68 18 02 00 00       	push   $0x218
c010424d:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0104253:	50                   	push   %eax
c0104254:	e8 80 c2 ff ff       	call   c01004d9 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104259:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104260:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104263:	8b 83 30 35 00 00    	mov    0x3530(%ebx),%eax
c0104269:	39 c2                	cmp    %eax,%edx
c010426b:	0f 82 3a ff ff ff    	jb     c01041ab <check_boot_pgdir+0x1e>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104271:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0104277:	05 ac 0f 00 00       	add    $0xfac,%eax
c010427c:	8b 00                	mov    (%eax),%eax
c010427e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104283:	89 c2                	mov    %eax,%edx
c0104285:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c010428b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010428e:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104295:	77 1b                	ja     c01042b2 <check_boot_pgdir+0x125>
c0104297:	ff 75 f0             	pushl  -0x10(%ebp)
c010429a:	8d 83 6c e3 fe ff    	lea    -0x11c94(%ebx),%eax
c01042a0:	50                   	push   %eax
c01042a1:	68 1b 02 00 00       	push   $0x21b
c01042a6:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c01042ac:	50                   	push   %eax
c01042ad:	e8 27 c2 ff ff       	call   c01004d9 <__panic>
c01042b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042b5:	05 00 00 00 40       	add    $0x40000000,%eax
c01042ba:	39 d0                	cmp    %edx,%eax
c01042bc:	74 1f                	je     c01042dd <check_boot_pgdir+0x150>
c01042be:	8d 83 f4 e6 fe ff    	lea    -0x1190c(%ebx),%eax
c01042c4:	50                   	push   %eax
c01042c5:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c01042cb:	50                   	push   %eax
c01042cc:	68 1b 02 00 00       	push   $0x21b
c01042d1:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c01042d7:	50                   	push   %eax
c01042d8:	e8 fc c1 ff ff       	call   c01004d9 <__panic>

    assert(boot_pgdir[0] == 0);
c01042dd:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c01042e3:	8b 00                	mov    (%eax),%eax
c01042e5:	85 c0                	test   %eax,%eax
c01042e7:	74 1f                	je     c0104308 <check_boot_pgdir+0x17b>
c01042e9:	8d 83 28 e7 fe ff    	lea    -0x118d8(%ebx),%eax
c01042ef:	50                   	push   %eax
c01042f0:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c01042f6:	50                   	push   %eax
c01042f7:	68 1d 02 00 00       	push   $0x21d
c01042fc:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0104302:	50                   	push   %eax
c0104303:	e8 d1 c1 ff ff       	call   c01004d9 <__panic>

    struct Page *p;
    p = alloc_page();
c0104308:	83 ec 0c             	sub    $0xc,%esp
c010430b:	6a 01                	push   $0x1
c010430d:	e8 a7 ed ff ff       	call   c01030b9 <alloc_pages>
c0104312:	83 c4 10             	add    $0x10,%esp
c0104315:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104318:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c010431e:	6a 02                	push   $0x2
c0104320:	68 00 01 00 00       	push   $0x100
c0104325:	ff 75 ec             	pushl  -0x14(%ebp)
c0104328:	50                   	push   %eax
c0104329:	e8 dd f6 ff ff       	call   c0103a0b <page_insert>
c010432e:	83 c4 10             	add    $0x10,%esp
c0104331:	85 c0                	test   %eax,%eax
c0104333:	74 1f                	je     c0104354 <check_boot_pgdir+0x1c7>
c0104335:	8d 83 3c e7 fe ff    	lea    -0x118c4(%ebx),%eax
c010433b:	50                   	push   %eax
c010433c:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0104342:	50                   	push   %eax
c0104343:	68 21 02 00 00       	push   $0x221
c0104348:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c010434e:	50                   	push   %eax
c010434f:	e8 85 c1 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p) == 1);
c0104354:	83 ec 0c             	sub    $0xc,%esp
c0104357:	ff 75 ec             	pushl  -0x14(%ebp)
c010435a:	e8 a3 ea ff ff       	call   c0102e02 <page_ref>
c010435f:	83 c4 10             	add    $0x10,%esp
c0104362:	83 f8 01             	cmp    $0x1,%eax
c0104365:	74 1f                	je     c0104386 <check_boot_pgdir+0x1f9>
c0104367:	8d 83 6a e7 fe ff    	lea    -0x11896(%ebx),%eax
c010436d:	50                   	push   %eax
c010436e:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0104374:	50                   	push   %eax
c0104375:	68 22 02 00 00       	push   $0x222
c010437a:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0104380:	50                   	push   %eax
c0104381:	e8 53 c1 ff ff       	call   c01004d9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104386:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c010438c:	6a 02                	push   $0x2
c010438e:	68 00 11 00 00       	push   $0x1100
c0104393:	ff 75 ec             	pushl  -0x14(%ebp)
c0104396:	50                   	push   %eax
c0104397:	e8 6f f6 ff ff       	call   c0103a0b <page_insert>
c010439c:	83 c4 10             	add    $0x10,%esp
c010439f:	85 c0                	test   %eax,%eax
c01043a1:	74 1f                	je     c01043c2 <check_boot_pgdir+0x235>
c01043a3:	8d 83 7c e7 fe ff    	lea    -0x11884(%ebx),%eax
c01043a9:	50                   	push   %eax
c01043aa:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c01043b0:	50                   	push   %eax
c01043b1:	68 23 02 00 00       	push   $0x223
c01043b6:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c01043bc:	50                   	push   %eax
c01043bd:	e8 17 c1 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p) == 2);
c01043c2:	83 ec 0c             	sub    $0xc,%esp
c01043c5:	ff 75 ec             	pushl  -0x14(%ebp)
c01043c8:	e8 35 ea ff ff       	call   c0102e02 <page_ref>
c01043cd:	83 c4 10             	add    $0x10,%esp
c01043d0:	83 f8 02             	cmp    $0x2,%eax
c01043d3:	74 1f                	je     c01043f4 <check_boot_pgdir+0x267>
c01043d5:	8d 83 b3 e7 fe ff    	lea    -0x1184d(%ebx),%eax
c01043db:	50                   	push   %eax
c01043dc:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c01043e2:	50                   	push   %eax
c01043e3:	68 24 02 00 00       	push   $0x224
c01043e8:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c01043ee:	50                   	push   %eax
c01043ef:	e8 e5 c0 ff ff       	call   c01004d9 <__panic>

    const char *str = "ucore: Hello world!!";
c01043f4:	8d 83 c4 e7 fe ff    	lea    -0x1183c(%ebx),%eax
c01043fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    strcpy((void *)0x100, str);
c01043fd:	83 ec 08             	sub    $0x8,%esp
c0104400:	ff 75 e8             	pushl  -0x18(%ebp)
c0104403:	68 00 01 00 00       	push   $0x100
c0104408:	e8 e3 15 00 00       	call   c01059f0 <strcpy>
c010440d:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104410:	83 ec 08             	sub    $0x8,%esp
c0104413:	68 00 11 00 00       	push   $0x1100
c0104418:	68 00 01 00 00       	push   $0x100
c010441d:	e8 5c 16 00 00       	call   c0105a7e <strcmp>
c0104422:	83 c4 10             	add    $0x10,%esp
c0104425:	85 c0                	test   %eax,%eax
c0104427:	74 1f                	je     c0104448 <check_boot_pgdir+0x2bb>
c0104429:	8d 83 dc e7 fe ff    	lea    -0x11824(%ebx),%eax
c010442f:	50                   	push   %eax
c0104430:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c0104436:	50                   	push   %eax
c0104437:	68 28 02 00 00       	push   $0x228
c010443c:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c0104442:	50                   	push   %eax
c0104443:	e8 91 c0 ff ff       	call   c01004d9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104448:	83 ec 0c             	sub    $0xc,%esp
c010444b:	ff 75 ec             	pushl  -0x14(%ebp)
c010444e:	e8 e2 e8 ff ff       	call   c0102d35 <page2kva>
c0104453:	83 c4 10             	add    $0x10,%esp
c0104456:	05 00 01 00 00       	add    $0x100,%eax
c010445b:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010445e:	83 ec 0c             	sub    $0xc,%esp
c0104461:	68 00 01 00 00       	push   $0x100
c0104466:	e8 19 15 00 00       	call   c0105984 <strlen>
c010446b:	83 c4 10             	add    $0x10,%esp
c010446e:	85 c0                	test   %eax,%eax
c0104470:	74 1f                	je     c0104491 <check_boot_pgdir+0x304>
c0104472:	8d 83 14 e8 fe ff    	lea    -0x117ec(%ebx),%eax
c0104478:	50                   	push   %eax
c0104479:	8d 83 b5 e3 fe ff    	lea    -0x11c4b(%ebx),%eax
c010447f:	50                   	push   %eax
c0104480:	68 2b 02 00 00       	push   $0x22b
c0104485:	8d 83 90 e3 fe ff    	lea    -0x11c70(%ebx),%eax
c010448b:	50                   	push   %eax
c010448c:	e8 48 c0 ff ff       	call   c01004d9 <__panic>

    free_page(p);
c0104491:	83 ec 08             	sub    $0x8,%esp
c0104494:	6a 01                	push   $0x1
c0104496:	ff 75 ec             	pushl  -0x14(%ebp)
c0104499:	e8 6b ec ff ff       	call   c0103109 <free_pages>
c010449e:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c01044a1:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c01044a7:	8b 00                	mov    (%eax),%eax
c01044a9:	83 ec 0c             	sub    $0xc,%esp
c01044ac:	50                   	push   %eax
c01044ad:	e8 2a e9 ff ff       	call   c0102ddc <pde2page>
c01044b2:	83 c4 10             	add    $0x10,%esp
c01044b5:	83 ec 08             	sub    $0x8,%esp
c01044b8:	6a 01                	push   $0x1
c01044ba:	50                   	push   %eax
c01044bb:	e8 49 ec ff ff       	call   c0103109 <free_pages>
c01044c0:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c01044c3:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c01044c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01044cf:	83 ec 0c             	sub    $0xc,%esp
c01044d2:	8d 83 38 e8 fe ff    	lea    -0x117c8(%ebx),%eax
c01044d8:	50                   	push   %eax
c01044d9:	e8 4b be ff ff       	call   c0100329 <cprintf>
c01044de:	83 c4 10             	add    $0x10,%esp
}
c01044e1:	90                   	nop
c01044e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01044e5:	c9                   	leave  
c01044e6:	c3                   	ret    

c01044e7 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01044e7:	55                   	push   %ebp
c01044e8:	89 e5                	mov    %esp,%ebp
c01044ea:	e8 c3 bd ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01044ef:	05 61 44 01 00       	add    $0x14461,%eax
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01044f4:	8b 55 08             	mov    0x8(%ebp),%edx
c01044f7:	83 e2 04             	and    $0x4,%edx
c01044fa:	85 d2                	test   %edx,%edx
c01044fc:	74 07                	je     c0104505 <perm2str+0x1e>
c01044fe:	ba 75 00 00 00       	mov    $0x75,%edx
c0104503:	eb 05                	jmp    c010450a <perm2str+0x23>
c0104505:	ba 2d 00 00 00       	mov    $0x2d,%edx
c010450a:	88 90 b8 35 00 00    	mov    %dl,0x35b8(%eax)
    str[1] = 'r';
c0104510:	c6 80 b9 35 00 00 72 	movb   $0x72,0x35b9(%eax)
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104517:	8b 55 08             	mov    0x8(%ebp),%edx
c010451a:	83 e2 02             	and    $0x2,%edx
c010451d:	85 d2                	test   %edx,%edx
c010451f:	74 07                	je     c0104528 <perm2str+0x41>
c0104521:	ba 77 00 00 00       	mov    $0x77,%edx
c0104526:	eb 05                	jmp    c010452d <perm2str+0x46>
c0104528:	ba 2d 00 00 00       	mov    $0x2d,%edx
c010452d:	88 90 ba 35 00 00    	mov    %dl,0x35ba(%eax)
    str[3] = '\0';
c0104533:	c6 80 bb 35 00 00 00 	movb   $0x0,0x35bb(%eax)
    return str;
c010453a:	8d 80 b8 35 00 00    	lea    0x35b8(%eax),%eax
}
c0104540:	5d                   	pop    %ebp
c0104541:	c3                   	ret    

c0104542 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104542:	55                   	push   %ebp
c0104543:	89 e5                	mov    %esp,%ebp
c0104545:	83 ec 10             	sub    $0x10,%esp
c0104548:	e8 65 bd ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010454d:	05 03 44 01 00       	add    $0x14403,%eax
    if (start >= right) {
c0104552:	8b 45 10             	mov    0x10(%ebp),%eax
c0104555:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104558:	72 0e                	jb     c0104568 <get_pgtable_items+0x26>
        return 0;
c010455a:	b8 00 00 00 00       	mov    $0x0,%eax
c010455f:	e9 9a 00 00 00       	jmp    c01045fe <get_pgtable_items+0xbc>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0104564:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104568:	8b 45 10             	mov    0x10(%ebp),%eax
c010456b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010456e:	73 18                	jae    c0104588 <get_pgtable_items+0x46>
c0104570:	8b 45 10             	mov    0x10(%ebp),%eax
c0104573:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010457a:	8b 45 14             	mov    0x14(%ebp),%eax
c010457d:	01 d0                	add    %edx,%eax
c010457f:	8b 00                	mov    (%eax),%eax
c0104581:	83 e0 01             	and    $0x1,%eax
c0104584:	85 c0                	test   %eax,%eax
c0104586:	74 dc                	je     c0104564 <get_pgtable_items+0x22>
    }
    if (start < right) {
c0104588:	8b 45 10             	mov    0x10(%ebp),%eax
c010458b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010458e:	73 69                	jae    c01045f9 <get_pgtable_items+0xb7>
        if (left_store != NULL) {
c0104590:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104594:	74 08                	je     c010459e <get_pgtable_items+0x5c>
            *left_store = start;
c0104596:	8b 45 18             	mov    0x18(%ebp),%eax
c0104599:	8b 55 10             	mov    0x10(%ebp),%edx
c010459c:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010459e:	8b 45 10             	mov    0x10(%ebp),%eax
c01045a1:	8d 50 01             	lea    0x1(%eax),%edx
c01045a4:	89 55 10             	mov    %edx,0x10(%ebp)
c01045a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01045ae:	8b 45 14             	mov    0x14(%ebp),%eax
c01045b1:	01 d0                	add    %edx,%eax
c01045b3:	8b 00                	mov    (%eax),%eax
c01045b5:	83 e0 07             	and    $0x7,%eax
c01045b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01045bb:	eb 04                	jmp    c01045c1 <get_pgtable_items+0x7f>
            start ++;
c01045bd:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01045c1:	8b 45 10             	mov    0x10(%ebp),%eax
c01045c4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01045c7:	73 1d                	jae    c01045e6 <get_pgtable_items+0xa4>
c01045c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01045cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01045d3:	8b 45 14             	mov    0x14(%ebp),%eax
c01045d6:	01 d0                	add    %edx,%eax
c01045d8:	8b 00                	mov    (%eax),%eax
c01045da:	83 e0 07             	and    $0x7,%eax
c01045dd:	89 c2                	mov    %eax,%edx
c01045df:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01045e2:	39 c2                	cmp    %eax,%edx
c01045e4:	74 d7                	je     c01045bd <get_pgtable_items+0x7b>
        }
        if (right_store != NULL) {
c01045e6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01045ea:	74 08                	je     c01045f4 <get_pgtable_items+0xb2>
            *right_store = start;
c01045ec:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01045ef:	8b 55 10             	mov    0x10(%ebp),%edx
c01045f2:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01045f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01045f7:	eb 05                	jmp    c01045fe <get_pgtable_items+0xbc>
    }
    return 0;
c01045f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045fe:	c9                   	leave  
c01045ff:	c3                   	ret    

c0104600 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104600:	55                   	push   %ebp
c0104601:	89 e5                	mov    %esp,%ebp
c0104603:	57                   	push   %edi
c0104604:	56                   	push   %esi
c0104605:	53                   	push   %ebx
c0104606:	83 ec 3c             	sub    $0x3c,%esp
c0104609:	e8 a8 bc ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c010460e:	81 c3 42 43 01 00    	add    $0x14342,%ebx
    cprintf("-------------------- BEGIN --------------------\n");
c0104614:	83 ec 0c             	sub    $0xc,%esp
c0104617:	8d 83 58 e8 fe ff    	lea    -0x117a8(%ebx),%eax
c010461d:	50                   	push   %eax
c010461e:	e8 06 bd ff ff       	call   c0100329 <cprintf>
c0104623:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0104626:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010462d:	e9 ef 00 00 00       	jmp    c0104721 <print_pgdir+0x121>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104635:	83 ec 0c             	sub    $0xc,%esp
c0104638:	50                   	push   %eax
c0104639:	e8 a9 fe ff ff       	call   c01044e7 <perm2str>
c010463e:	83 c4 10             	add    $0x10,%esp
c0104641:	89 45 c4             	mov    %eax,-0x3c(%ebp)
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104644:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104647:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010464a:	29 c2                	sub    %eax,%edx
c010464c:	89 d0                	mov    %edx,%eax
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010464e:	89 c6                	mov    %eax,%esi
c0104650:	c1 e6 16             	shl    $0x16,%esi
c0104653:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104656:	89 c1                	mov    %eax,%ecx
c0104658:	c1 e1 16             	shl    $0x16,%ecx
c010465b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010465e:	89 c2                	mov    %eax,%edx
c0104660:	c1 e2 16             	shl    $0x16,%edx
c0104663:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104666:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104669:	29 c7                	sub    %eax,%edi
c010466b:	89 f8                	mov    %edi,%eax
c010466d:	83 ec 08             	sub    $0x8,%esp
c0104670:	ff 75 c4             	pushl  -0x3c(%ebp)
c0104673:	56                   	push   %esi
c0104674:	51                   	push   %ecx
c0104675:	52                   	push   %edx
c0104676:	50                   	push   %eax
c0104677:	8d 83 89 e8 fe ff    	lea    -0x11777(%ebx),%eax
c010467d:	50                   	push   %eax
c010467e:	e8 a6 bc ff ff       	call   c0100329 <cprintf>
c0104683:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
c0104686:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104689:	c1 e0 0a             	shl    $0xa,%eax
c010468c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010468f:	eb 54                	jmp    c01046e5 <print_pgdir+0xe5>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104691:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104694:	83 ec 0c             	sub    $0xc,%esp
c0104697:	50                   	push   %eax
c0104698:	e8 4a fe ff ff       	call   c01044e7 <perm2str>
c010469d:	83 c4 10             	add    $0x10,%esp
c01046a0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01046a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01046a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01046a9:	29 c2                	sub    %eax,%edx
c01046ab:	89 d0                	mov    %edx,%eax
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01046ad:	89 c6                	mov    %eax,%esi
c01046af:	c1 e6 0c             	shl    $0xc,%esi
c01046b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01046b5:	89 c1                	mov    %eax,%ecx
c01046b7:	c1 e1 0c             	shl    $0xc,%ecx
c01046ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01046bd:	89 c2                	mov    %eax,%edx
c01046bf:	c1 e2 0c             	shl    $0xc,%edx
c01046c2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01046c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01046c8:	29 c7                	sub    %eax,%edi
c01046ca:	89 f8                	mov    %edi,%eax
c01046cc:	83 ec 08             	sub    $0x8,%esp
c01046cf:	ff 75 c4             	pushl  -0x3c(%ebp)
c01046d2:	56                   	push   %esi
c01046d3:	51                   	push   %ecx
c01046d4:	52                   	push   %edx
c01046d5:	50                   	push   %eax
c01046d6:	8d 83 a8 e8 fe ff    	lea    -0x11758(%ebx),%eax
c01046dc:	50                   	push   %eax
c01046dd:	e8 47 bc ff ff       	call   c0100329 <cprintf>
c01046e2:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01046e5:	bf 00 00 c0 fa       	mov    $0xfac00000,%edi
c01046ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01046ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01046f0:	89 d6                	mov    %edx,%esi
c01046f2:	c1 e6 0a             	shl    $0xa,%esi
c01046f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01046f8:	89 d1                	mov    %edx,%ecx
c01046fa:	c1 e1 0a             	shl    $0xa,%ecx
c01046fd:	83 ec 08             	sub    $0x8,%esp
c0104700:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104703:	52                   	push   %edx
c0104704:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0104707:	52                   	push   %edx
c0104708:	57                   	push   %edi
c0104709:	50                   	push   %eax
c010470a:	56                   	push   %esi
c010470b:	51                   	push   %ecx
c010470c:	e8 31 fe ff ff       	call   c0104542 <get_pgtable_items>
c0104711:	83 c4 20             	add    $0x20,%esp
c0104714:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104717:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010471b:	0f 85 70 ff ff ff    	jne    c0104691 <print_pgdir+0x91>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104721:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104726:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104729:	83 ec 08             	sub    $0x8,%esp
c010472c:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010472f:	52                   	push   %edx
c0104730:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104733:	52                   	push   %edx
c0104734:	51                   	push   %ecx
c0104735:	50                   	push   %eax
c0104736:	68 00 04 00 00       	push   $0x400
c010473b:	6a 00                	push   $0x0
c010473d:	e8 00 fe ff ff       	call   c0104542 <get_pgtable_items>
c0104742:	83 c4 20             	add    $0x20,%esp
c0104745:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104748:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010474c:	0f 85 e0 fe ff ff    	jne    c0104632 <print_pgdir+0x32>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104752:	83 ec 0c             	sub    $0xc,%esp
c0104755:	8d 83 cc e8 fe ff    	lea    -0x11734(%ebx),%eax
c010475b:	50                   	push   %eax
c010475c:	e8 c8 bb ff ff       	call   c0100329 <cprintf>
c0104761:	83 c4 10             	add    $0x10,%esp
}
c0104764:	90                   	nop
c0104765:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104768:	5b                   	pop    %ebx
c0104769:	5e                   	pop    %esi
c010476a:	5f                   	pop    %edi
c010476b:	5d                   	pop    %ebp
c010476c:	c3                   	ret    

c010476d <__x86.get_pc_thunk.si>:
c010476d:	8b 34 24             	mov    (%esp),%esi
c0104770:	c3                   	ret    

c0104771 <page2ppn>:
page2ppn(struct Page *page) {
c0104771:	55                   	push   %ebp
c0104772:	89 e5                	mov    %esp,%ebp
c0104774:	e8 39 bb ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0104779:	05 d7 41 01 00       	add    $0x141d7,%eax
    return page - pages;
c010477e:	8b 55 08             	mov    0x8(%ebp),%edx
c0104781:	c7 c0 18 bf 11 c0    	mov    $0xc011bf18,%eax
c0104787:	8b 00                	mov    (%eax),%eax
c0104789:	29 c2                	sub    %eax,%edx
c010478b:	89 d0                	mov    %edx,%eax
c010478d:	c1 f8 02             	sar    $0x2,%eax
c0104790:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0104796:	5d                   	pop    %ebp
c0104797:	c3                   	ret    

c0104798 <page2pa>:
page2pa(struct Page *page) {
c0104798:	55                   	push   %ebp
c0104799:	89 e5                	mov    %esp,%ebp
c010479b:	e8 12 bb ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01047a0:	05 b0 41 01 00       	add    $0x141b0,%eax
    return page2ppn(page) << PGSHIFT;
c01047a5:	ff 75 08             	pushl  0x8(%ebp)
c01047a8:	e8 c4 ff ff ff       	call   c0104771 <page2ppn>
c01047ad:	83 c4 04             	add    $0x4,%esp
c01047b0:	c1 e0 0c             	shl    $0xc,%eax
}
c01047b3:	c9                   	leave  
c01047b4:	c3                   	ret    

c01047b5 <page_ref>:
page_ref(struct Page *page) {
c01047b5:	55                   	push   %ebp
c01047b6:	89 e5                	mov    %esp,%ebp
c01047b8:	e8 f5 ba ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01047bd:	05 93 41 01 00       	add    $0x14193,%eax
    return page->ref;
c01047c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01047c5:	8b 00                	mov    (%eax),%eax
}
c01047c7:	5d                   	pop    %ebp
c01047c8:	c3                   	ret    

c01047c9 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c01047c9:	55                   	push   %ebp
c01047ca:	89 e5                	mov    %esp,%ebp
c01047cc:	e8 e1 ba ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01047d1:	05 7f 41 01 00       	add    $0x1417f,%eax
    page->ref = val;
c01047d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01047d9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047dc:	89 10                	mov    %edx,(%eax)
}
c01047de:	90                   	nop
c01047df:	5d                   	pop    %ebp
c01047e0:	c3                   	ret    

c01047e1 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01047e1:	55                   	push   %ebp
c01047e2:	89 e5                	mov    %esp,%ebp
c01047e4:	83 ec 10             	sub    $0x10,%esp
c01047e7:	e8 c6 ba ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01047ec:	05 64 41 01 00       	add    $0x14164,%eax
c01047f1:	c7 c2 1c bf 11 c0    	mov    $0xc011bf1c,%edx
c01047f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01047fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01047fd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
c0104800:	89 4a 04             	mov    %ecx,0x4(%edx)
c0104803:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104806:	8b 4a 04             	mov    0x4(%edx),%ecx
c0104809:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010480c:	89 0a                	mov    %ecx,(%edx)
    list_init(&free_list);
    nr_free = 0;
c010480e:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0104814:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
c010481b:	90                   	nop
c010481c:	c9                   	leave  
c010481d:	c3                   	ret    

c010481e <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010481e:	55                   	push   %ebp
c010481f:	89 e5                	mov    %esp,%ebp
c0104821:	53                   	push   %ebx
c0104822:	83 ec 34             	sub    $0x34,%esp
c0104825:	e8 8c ba ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c010482a:	81 c3 26 41 01 00    	add    $0x14126,%ebx
    assert(n > 0);
c0104830:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104834:	75 1c                	jne    c0104852 <default_init_memmap+0x34>
c0104836:	8d 83 00 e9 fe ff    	lea    -0x11700(%ebx),%eax
c010483c:	50                   	push   %eax
c010483d:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0104843:	50                   	push   %eax
c0104844:	6a 6d                	push   $0x6d
c0104846:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c010484c:	50                   	push   %eax
c010484d:	e8 87 bc ff ff       	call   c01004d9 <__panic>
    struct Page *p = base;
c0104852:	8b 45 08             	mov    0x8(%ebp),%eax
c0104855:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104858:	eb 72                	jmp    c01048cc <default_init_memmap+0xae>
        assert(PageReserved(p));
c010485a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010485d:	83 c0 04             	add    $0x4,%eax
c0104860:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104867:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010486a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010486d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104870:	0f a3 10             	bt     %edx,(%eax)
c0104873:	19 c0                	sbb    %eax,%eax
c0104875:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0104878:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010487c:	0f 95 c0             	setne  %al
c010487f:	0f b6 c0             	movzbl %al,%eax
c0104882:	85 c0                	test   %eax,%eax
c0104884:	75 1c                	jne    c01048a2 <default_init_memmap+0x84>
c0104886:	8d 83 31 e9 fe ff    	lea    -0x116cf(%ebx),%eax
c010488c:	50                   	push   %eax
c010488d:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0104893:	50                   	push   %eax
c0104894:	6a 70                	push   $0x70
c0104896:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c010489c:	50                   	push   %eax
c010489d:	e8 37 bc ff ff       	call   c01004d9 <__panic>
        p->flags = p->property = 0;
c01048a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01048ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048af:	8b 50 08             	mov    0x8(%eax),%edx
c01048b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048b5:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01048b8:	83 ec 08             	sub    $0x8,%esp
c01048bb:	6a 00                	push   $0x0
c01048bd:	ff 75 f4             	pushl  -0xc(%ebp)
c01048c0:	e8 04 ff ff ff       	call   c01047c9 <set_page_ref>
c01048c5:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c01048c8:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01048cc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01048cf:	89 d0                	mov    %edx,%eax
c01048d1:	c1 e0 02             	shl    $0x2,%eax
c01048d4:	01 d0                	add    %edx,%eax
c01048d6:	c1 e0 02             	shl    $0x2,%eax
c01048d9:	89 c2                	mov    %eax,%edx
c01048db:	8b 45 08             	mov    0x8(%ebp),%eax
c01048de:	01 d0                	add    %edx,%eax
c01048e0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01048e3:	0f 85 71 ff ff ff    	jne    c010485a <default_init_memmap+0x3c>
    }
    base->property = n;
c01048e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01048ec:	8b 55 0c             	mov    0xc(%ebp),%edx
c01048ef:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01048f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01048f5:	83 c0 04             	add    $0x4,%eax
c01048f8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01048ff:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104902:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104905:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104908:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c010490b:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0104911:	8b 50 08             	mov    0x8(%eax),%edx
c0104914:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104917:	01 c2                	add    %eax,%edx
c0104919:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c010491f:	89 50 08             	mov    %edx,0x8(%eax)
    list_add_before(&free_list, &(base->page_link));
c0104922:	8b 45 08             	mov    0x8(%ebp),%eax
c0104925:	83 c0 0c             	add    $0xc,%eax
c0104928:	c7 c2 1c bf 11 c0    	mov    $0xc011bf1c,%edx
c010492e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0104931:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104934:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104937:	8b 00                	mov    (%eax),%eax
c0104939:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010493c:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010493f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104945:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104948:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010494b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010494e:	89 10                	mov    %edx,(%eax)
c0104950:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104953:	8b 10                	mov    (%eax),%edx
c0104955:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104958:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010495b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010495e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104961:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104964:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104967:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010496a:	89 10                	mov    %edx,(%eax)
}
c010496c:	90                   	nop
c010496d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104970:	c9                   	leave  
c0104971:	c3                   	ret    

c0104972 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0104972:	55                   	push   %ebp
c0104973:	89 e5                	mov    %esp,%ebp
c0104975:	53                   	push   %ebx
c0104976:	83 ec 54             	sub    $0x54,%esp
c0104979:	e8 34 b9 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010497e:	05 d2 3f 01 00       	add    $0x13fd2,%eax
    assert(n > 0);
c0104983:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104987:	75 1e                	jne    c01049a7 <default_alloc_pages+0x35>
c0104989:	8d 90 00 e9 fe ff    	lea    -0x11700(%eax),%edx
c010498f:	52                   	push   %edx
c0104990:	8d 90 06 e9 fe ff    	lea    -0x116fa(%eax),%edx
c0104996:	52                   	push   %edx
c0104997:	6a 7c                	push   $0x7c
c0104999:	8d 90 1b e9 fe ff    	lea    -0x116e5(%eax),%edx
c010499f:	52                   	push   %edx
c01049a0:	89 c3                	mov    %eax,%ebx
c01049a2:	e8 32 bb ff ff       	call   c01004d9 <__panic>
    if (n > nr_free) {
c01049a7:	c7 c2 1c bf 11 c0    	mov    $0xc011bf1c,%edx
c01049ad:	8b 52 08             	mov    0x8(%edx),%edx
c01049b0:	39 55 08             	cmp    %edx,0x8(%ebp)
c01049b3:	76 0a                	jbe    c01049bf <default_alloc_pages+0x4d>
        return NULL;
c01049b5:	b8 00 00 00 00       	mov    $0x0,%eax
c01049ba:	e9 49 01 00 00       	jmp    c0104b08 <default_alloc_pages+0x196>
    }
    struct Page *page = NULL;
c01049bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01049c6:	c7 c2 1c bf 11 c0    	mov    $0xc011bf1c,%edx
c01049cc:	89 55 f0             	mov    %edx,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c01049cf:	eb 1c                	jmp    c01049ed <default_alloc_pages+0x7b>
        struct Page *p = le2page(le, page_link);
c01049d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01049d4:	83 ea 0c             	sub    $0xc,%edx
c01049d7:	89 55 ec             	mov    %edx,-0x14(%ebp)
        if (p->property >= n) {
c01049da:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01049dd:	8b 52 08             	mov    0x8(%edx),%edx
c01049e0:	39 55 08             	cmp    %edx,0x8(%ebp)
c01049e3:	77 08                	ja     c01049ed <default_alloc_pages+0x7b>
            page = p;
c01049e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01049e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            break;
c01049eb:	eb 1a                	jmp    c0104a07 <default_alloc_pages+0x95>
c01049ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01049f0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return listelm->next;
c01049f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01049f6:	8b 52 04             	mov    0x4(%edx),%edx
    while ((le = list_next(le)) != &free_list) {
c01049f9:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01049fc:	c7 c2 1c bf 11 c0    	mov    $0xc011bf1c,%edx
c0104a02:	39 55 f0             	cmp    %edx,-0x10(%ebp)
c0104a05:	75 ca                	jne    c01049d1 <default_alloc_pages+0x5f>
        }
    }
    if (page != NULL) {
c0104a07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a0b:	0f 84 f4 00 00 00    	je     c0104b05 <default_alloc_pages+0x193>
        if (page->property > n) {
c0104a11:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a14:	8b 52 08             	mov    0x8(%edx),%edx
c0104a17:	39 55 08             	cmp    %edx,0x8(%ebp)
c0104a1a:	0f 83 8c 00 00 00    	jae    c0104aac <default_alloc_pages+0x13a>
            struct Page *p = page + n;
c0104a20:	8b 4d 08             	mov    0x8(%ebp),%ecx
c0104a23:	89 ca                	mov    %ecx,%edx
c0104a25:	c1 e2 02             	shl    $0x2,%edx
c0104a28:	01 ca                	add    %ecx,%edx
c0104a2a:	c1 e2 02             	shl    $0x2,%edx
c0104a2d:	89 d1                	mov    %edx,%ecx
c0104a2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a32:	01 ca                	add    %ecx,%edx
c0104a34:	89 55 e8             	mov    %edx,-0x18(%ebp)
            p->property = page->property - n;
c0104a37:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a3a:	8b 52 08             	mov    0x8(%edx),%edx
c0104a3d:	89 d1                	mov    %edx,%ecx
c0104a3f:	2b 4d 08             	sub    0x8(%ebp),%ecx
c0104a42:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104a45:	89 4a 08             	mov    %ecx,0x8(%edx)
            SetPageProperty(p);
c0104a48:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104a4b:	83 c2 04             	add    $0x4,%edx
c0104a4e:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0104a55:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0104a58:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104a5b:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0104a5e:	0f ab 0a             	bts    %ecx,(%edx)
            list_add_after(&(page->page_link), &(p->page_link));
c0104a61:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104a64:	83 c2 0c             	add    $0xc,%edx
c0104a67:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0104a6a:	83 c1 0c             	add    $0xc,%ecx
c0104a6d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
c0104a70:	89 55 dc             	mov    %edx,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104a73:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104a76:	8b 52 04             	mov    0x4(%edx),%edx
c0104a79:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104a7c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0104a7f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104a82:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
c0104a85:	89 55 d0             	mov    %edx,-0x30(%ebp)
    prev->next = next->prev = elm;
c0104a88:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104a8b:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0104a8e:	89 0a                	mov    %ecx,(%edx)
c0104a90:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104a93:	8b 0a                	mov    (%edx),%ecx
c0104a95:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104a98:	89 4a 04             	mov    %ecx,0x4(%edx)
    elm->next = next;
c0104a9b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104a9e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104aa1:	89 4a 04             	mov    %ecx,0x4(%edx)
    elm->prev = prev;
c0104aa4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104aa7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104aaa:	89 0a                	mov    %ecx,(%edx)
        }
        list_del(&(page->page_link));
c0104aac:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104aaf:	83 c2 0c             	add    $0xc,%edx
c0104ab2:	89 55 bc             	mov    %edx,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104ab5:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104ab8:	8b 52 04             	mov    0x4(%edx),%edx
c0104abb:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c0104abe:	8b 09                	mov    (%ecx),%ecx
c0104ac0:	89 4d b8             	mov    %ecx,-0x48(%ebp)
c0104ac3:	89 55 b4             	mov    %edx,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104ac6:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104ac9:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
c0104acc:	89 4a 04             	mov    %ecx,0x4(%edx)
    next->prev = prev;
c0104acf:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104ad2:	8b 4d b8             	mov    -0x48(%ebp),%ecx
c0104ad5:	89 0a                	mov    %ecx,(%edx)
        nr_free -= n;
c0104ad7:	c7 c2 1c bf 11 c0    	mov    $0xc011bf1c,%edx
c0104add:	8b 52 08             	mov    0x8(%edx),%edx
c0104ae0:	2b 55 08             	sub    0x8(%ebp),%edx
c0104ae3:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0104ae9:	89 50 08             	mov    %edx,0x8(%eax)
        ClearPageProperty(page);
c0104aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aef:	83 c0 04             	add    $0x4,%eax
c0104af2:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0104af9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104afc:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104aff:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104b02:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0104b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104b08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104b0b:	c9                   	leave  
c0104b0c:	c3                   	ret    

c0104b0d <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104b0d:	55                   	push   %ebp
c0104b0e:	89 e5                	mov    %esp,%ebp
c0104b10:	53                   	push   %ebx
c0104b11:	81 ec 84 00 00 00    	sub    $0x84,%esp
c0104b17:	e8 9a b7 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0104b1c:	81 c3 34 3e 01 00    	add    $0x13e34,%ebx
    assert(n > 0);
c0104b22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104b26:	75 1f                	jne    c0104b47 <default_free_pages+0x3a>
c0104b28:	8d 83 00 e9 fe ff    	lea    -0x11700(%ebx),%eax
c0104b2e:	50                   	push   %eax
c0104b2f:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0104b35:	50                   	push   %eax
c0104b36:	68 9a 00 00 00       	push   $0x9a
c0104b3b:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0104b41:	50                   	push   %eax
c0104b42:	e8 92 b9 ff ff       	call   c01004d9 <__panic>
    struct Page *p = base;
c0104b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104b4d:	e9 95 00 00 00       	jmp    c0104be7 <default_free_pages+0xda>
        assert(!PageReserved(p) && !PageProperty(p));
c0104b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b55:	83 c0 04             	add    $0x4,%eax
c0104b58:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104b5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b62:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b65:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104b68:	0f a3 10             	bt     %edx,(%eax)
c0104b6b:	19 c0                	sbb    %eax,%eax
c0104b6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0104b70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104b74:	0f 95 c0             	setne  %al
c0104b77:	0f b6 c0             	movzbl %al,%eax
c0104b7a:	85 c0                	test   %eax,%eax
c0104b7c:	75 2c                	jne    c0104baa <default_free_pages+0x9d>
c0104b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b81:	83 c0 04             	add    $0x4,%eax
c0104b84:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0104b8b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b91:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104b94:	0f a3 10             	bt     %edx,(%eax)
c0104b97:	19 c0                	sbb    %eax,%eax
c0104b99:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0104b9c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104ba0:	0f 95 c0             	setne  %al
c0104ba3:	0f b6 c0             	movzbl %al,%eax
c0104ba6:	85 c0                	test   %eax,%eax
c0104ba8:	74 1f                	je     c0104bc9 <default_free_pages+0xbc>
c0104baa:	8d 83 44 e9 fe ff    	lea    -0x116bc(%ebx),%eax
c0104bb0:	50                   	push   %eax
c0104bb1:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0104bb7:	50                   	push   %eax
c0104bb8:	68 9d 00 00 00       	push   $0x9d
c0104bbd:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0104bc3:	50                   	push   %eax
c0104bc4:	e8 10 b9 ff ff       	call   c01004d9 <__panic>
        p->flags = 0;
c0104bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0104bd3:	83 ec 08             	sub    $0x8,%esp
c0104bd6:	6a 00                	push   $0x0
c0104bd8:	ff 75 f4             	pushl  -0xc(%ebp)
c0104bdb:	e8 e9 fb ff ff       	call   c01047c9 <set_page_ref>
c0104be0:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c0104be3:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104be7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104bea:	89 d0                	mov    %edx,%eax
c0104bec:	c1 e0 02             	shl    $0x2,%eax
c0104bef:	01 d0                	add    %edx,%eax
c0104bf1:	c1 e0 02             	shl    $0x2,%eax
c0104bf4:	89 c2                	mov    %eax,%edx
c0104bf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bf9:	01 d0                	add    %edx,%eax
c0104bfb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104bfe:	0f 85 4e ff ff ff    	jne    c0104b52 <default_free_pages+0x45>
    }
    base->property = n;
c0104c04:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c07:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104c0a:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104c0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c10:	83 c0 04             	add    $0x4,%eax
c0104c13:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104c1a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104c1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104c20:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104c23:	0f ab 10             	bts    %edx,(%eax)
c0104c26:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0104c2c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return listelm->next;
c0104c2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104c32:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0104c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104c38:	e9 08 01 00 00       	jmp    c0104d45 <default_free_pages+0x238>
        p = le2page(le, page_link);
c0104c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c40:	83 e8 0c             	sub    $0xc,%eax
c0104c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c49:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104c4c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104c4f:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0104c52:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0104c55:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c58:	8b 50 08             	mov    0x8(%eax),%edx
c0104c5b:	89 d0                	mov    %edx,%eax
c0104c5d:	c1 e0 02             	shl    $0x2,%eax
c0104c60:	01 d0                	add    %edx,%eax
c0104c62:	c1 e0 02             	shl    $0x2,%eax
c0104c65:	89 c2                	mov    %eax,%edx
c0104c67:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c6a:	01 d0                	add    %edx,%eax
c0104c6c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104c6f:	75 5a                	jne    c0104ccb <default_free_pages+0x1be>
            base->property += p->property;
c0104c71:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c74:	8b 50 08             	mov    0x8(%eax),%edx
c0104c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c7a:	8b 40 08             	mov    0x8(%eax),%eax
c0104c7d:	01 c2                	add    %eax,%edx
c0104c7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c82:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0104c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c88:	83 c0 04             	add    $0x4,%eax
c0104c8b:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0104c92:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104c95:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104c98:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104c9b:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0104c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ca1:	83 c0 0c             	add    $0xc,%eax
c0104ca4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104ca7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104caa:	8b 40 04             	mov    0x4(%eax),%eax
c0104cad:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104cb0:	8b 12                	mov    (%edx),%edx
c0104cb2:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104cb5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0104cb8:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104cbb:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104cbe:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104cc1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104cc4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104cc7:	89 10                	mov    %edx,(%eax)
c0104cc9:	eb 7a                	jmp    c0104d45 <default_free_pages+0x238>
        }
        else if (p + p->property == base) {
c0104ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cce:	8b 50 08             	mov    0x8(%eax),%edx
c0104cd1:	89 d0                	mov    %edx,%eax
c0104cd3:	c1 e0 02             	shl    $0x2,%eax
c0104cd6:	01 d0                	add    %edx,%eax
c0104cd8:	c1 e0 02             	shl    $0x2,%eax
c0104cdb:	89 c2                	mov    %eax,%edx
c0104cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ce0:	01 d0                	add    %edx,%eax
c0104ce2:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104ce5:	75 5e                	jne    c0104d45 <default_free_pages+0x238>
            p->property += base->property;
c0104ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cea:	8b 50 08             	mov    0x8(%eax),%edx
c0104ced:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cf0:	8b 40 08             	mov    0x8(%eax),%eax
c0104cf3:	01 c2                	add    %eax,%edx
c0104cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cf8:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0104cfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cfe:	83 c0 04             	add    $0x4,%eax
c0104d01:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0104d08:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104d0b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104d0e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104d11:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0104d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d17:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0104d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d1d:	83 c0 0c             	add    $0xc,%eax
c0104d20:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104d23:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104d26:	8b 40 04             	mov    0x4(%eax),%eax
c0104d29:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104d2c:	8b 12                	mov    (%edx),%edx
c0104d2e:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0104d31:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0104d34:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104d37:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104d3a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104d3d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104d40:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104d43:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
c0104d45:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0104d4b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104d4e:	0f 85 e9 fe ff ff    	jne    c0104c3d <default_free_pages+0x130>
        }
    }
    nr_free += n;
c0104d54:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0104d5a:	8b 50 08             	mov    0x8(%eax),%edx
c0104d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d60:	01 c2                	add    %eax,%edx
c0104d62:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0104d68:	89 50 08             	mov    %edx,0x8(%eax)
c0104d6b:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0104d71:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
c0104d74:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104d77:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0104d7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104d7d:	eb 6f                	jmp    c0104dee <default_free_pages+0x2e1>
        p = le2page(le, page_link);
c0104d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d82:	83 e8 0c             	sub    $0xc,%eax
c0104d85:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0104d88:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d8b:	8b 50 08             	mov    0x8(%eax),%edx
c0104d8e:	89 d0                	mov    %edx,%eax
c0104d90:	c1 e0 02             	shl    $0x2,%eax
c0104d93:	01 d0                	add    %edx,%eax
c0104d95:	c1 e0 02             	shl    $0x2,%eax
c0104d98:	89 c2                	mov    %eax,%edx
c0104d9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d9d:	01 d0                	add    %edx,%eax
c0104d9f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104da2:	72 3b                	jb     c0104ddf <default_free_pages+0x2d2>
            assert(base + base->property != p);
c0104da4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104da7:	8b 50 08             	mov    0x8(%eax),%edx
c0104daa:	89 d0                	mov    %edx,%eax
c0104dac:	c1 e0 02             	shl    $0x2,%eax
c0104daf:	01 d0                	add    %edx,%eax
c0104db1:	c1 e0 02             	shl    $0x2,%eax
c0104db4:	89 c2                	mov    %eax,%edx
c0104db6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104db9:	01 d0                	add    %edx,%eax
c0104dbb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104dbe:	75 3b                	jne    c0104dfb <default_free_pages+0x2ee>
c0104dc0:	8d 83 69 e9 fe ff    	lea    -0x11697(%ebx),%eax
c0104dc6:	50                   	push   %eax
c0104dc7:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0104dcd:	50                   	push   %eax
c0104dce:	68 b9 00 00 00       	push   $0xb9
c0104dd3:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0104dd9:	50                   	push   %eax
c0104dda:	e8 fa b6 ff ff       	call   c01004d9 <__panic>
c0104ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104de2:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104de5:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104de8:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c0104deb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104dee:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0104df4:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104df7:	75 86                	jne    c0104d7f <default_free_pages+0x272>
c0104df9:	eb 01                	jmp    c0104dfc <default_free_pages+0x2ef>
            break;
c0104dfb:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c0104dfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dff:	8d 50 0c             	lea    0xc(%eax),%edx
c0104e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e05:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104e08:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0104e0b:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104e0e:	8b 00                	mov    (%eax),%eax
c0104e10:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104e13:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104e16:	89 45 88             	mov    %eax,-0x78(%ebp)
c0104e19:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104e1c:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0104e1f:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104e22:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104e25:	89 10                	mov    %edx,(%eax)
c0104e27:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104e2a:	8b 10                	mov    (%eax),%edx
c0104e2c:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104e2f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104e32:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104e35:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104e38:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104e3b:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104e3e:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104e41:	89 10                	mov    %edx,(%eax)
}
c0104e43:	90                   	nop
c0104e44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104e47:	c9                   	leave  
c0104e48:	c3                   	ret    

c0104e49 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104e49:	55                   	push   %ebp
c0104e4a:	89 e5                	mov    %esp,%ebp
c0104e4c:	e8 61 b4 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0104e51:	05 ff 3a 01 00       	add    $0x13aff,%eax
    return nr_free;
c0104e56:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0104e5c:	8b 40 08             	mov    0x8(%eax),%eax
}
c0104e5f:	5d                   	pop    %ebp
c0104e60:	c3                   	ret    

c0104e61 <basic_check>:

static void
basic_check(void) {
c0104e61:	55                   	push   %ebp
c0104e62:	89 e5                	mov    %esp,%ebp
c0104e64:	53                   	push   %ebx
c0104e65:	83 ec 34             	sub    $0x34,%esp
c0104e68:	e8 49 b4 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0104e6d:	81 c3 e3 3a 01 00    	add    $0x13ae3,%ebx
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104e73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e83:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104e86:	83 ec 0c             	sub    $0xc,%esp
c0104e89:	6a 01                	push   $0x1
c0104e8b:	e8 29 e2 ff ff       	call   c01030b9 <alloc_pages>
c0104e90:	83 c4 10             	add    $0x10,%esp
c0104e93:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e96:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104e9a:	75 1f                	jne    c0104ebb <basic_check+0x5a>
c0104e9c:	8d 83 84 e9 fe ff    	lea    -0x1167c(%ebx),%eax
c0104ea2:	50                   	push   %eax
c0104ea3:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0104ea9:	50                   	push   %eax
c0104eaa:	68 ca 00 00 00       	push   $0xca
c0104eaf:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0104eb5:	50                   	push   %eax
c0104eb6:	e8 1e b6 ff ff       	call   c01004d9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104ebb:	83 ec 0c             	sub    $0xc,%esp
c0104ebe:	6a 01                	push   $0x1
c0104ec0:	e8 f4 e1 ff ff       	call   c01030b9 <alloc_pages>
c0104ec5:	83 c4 10             	add    $0x10,%esp
c0104ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ecb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ecf:	75 1f                	jne    c0104ef0 <basic_check+0x8f>
c0104ed1:	8d 83 a0 e9 fe ff    	lea    -0x11660(%ebx),%eax
c0104ed7:	50                   	push   %eax
c0104ed8:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0104ede:	50                   	push   %eax
c0104edf:	68 cb 00 00 00       	push   $0xcb
c0104ee4:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0104eea:	50                   	push   %eax
c0104eeb:	e8 e9 b5 ff ff       	call   c01004d9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104ef0:	83 ec 0c             	sub    $0xc,%esp
c0104ef3:	6a 01                	push   $0x1
c0104ef5:	e8 bf e1 ff ff       	call   c01030b9 <alloc_pages>
c0104efa:	83 c4 10             	add    $0x10,%esp
c0104efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f04:	75 1f                	jne    c0104f25 <basic_check+0xc4>
c0104f06:	8d 83 bc e9 fe ff    	lea    -0x11644(%ebx),%eax
c0104f0c:	50                   	push   %eax
c0104f0d:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0104f13:	50                   	push   %eax
c0104f14:	68 cc 00 00 00       	push   $0xcc
c0104f19:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0104f1f:	50                   	push   %eax
c0104f20:	e8 b4 b5 ff ff       	call   c01004d9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104f25:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f28:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104f2b:	74 10                	je     c0104f3d <basic_check+0xdc>
c0104f2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f30:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104f33:	74 08                	je     c0104f3d <basic_check+0xdc>
c0104f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f38:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104f3b:	75 1f                	jne    c0104f5c <basic_check+0xfb>
c0104f3d:	8d 83 d8 e9 fe ff    	lea    -0x11628(%ebx),%eax
c0104f43:	50                   	push   %eax
c0104f44:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0104f4a:	50                   	push   %eax
c0104f4b:	68 ce 00 00 00       	push   $0xce
c0104f50:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0104f56:	50                   	push   %eax
c0104f57:	e8 7d b5 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104f5c:	83 ec 0c             	sub    $0xc,%esp
c0104f5f:	ff 75 ec             	pushl  -0x14(%ebp)
c0104f62:	e8 4e f8 ff ff       	call   c01047b5 <page_ref>
c0104f67:	83 c4 10             	add    $0x10,%esp
c0104f6a:	85 c0                	test   %eax,%eax
c0104f6c:	75 24                	jne    c0104f92 <basic_check+0x131>
c0104f6e:	83 ec 0c             	sub    $0xc,%esp
c0104f71:	ff 75 f0             	pushl  -0x10(%ebp)
c0104f74:	e8 3c f8 ff ff       	call   c01047b5 <page_ref>
c0104f79:	83 c4 10             	add    $0x10,%esp
c0104f7c:	85 c0                	test   %eax,%eax
c0104f7e:	75 12                	jne    c0104f92 <basic_check+0x131>
c0104f80:	83 ec 0c             	sub    $0xc,%esp
c0104f83:	ff 75 f4             	pushl  -0xc(%ebp)
c0104f86:	e8 2a f8 ff ff       	call   c01047b5 <page_ref>
c0104f8b:	83 c4 10             	add    $0x10,%esp
c0104f8e:	85 c0                	test   %eax,%eax
c0104f90:	74 1f                	je     c0104fb1 <basic_check+0x150>
c0104f92:	8d 83 fc e9 fe ff    	lea    -0x11604(%ebx),%eax
c0104f98:	50                   	push   %eax
c0104f99:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0104f9f:	50                   	push   %eax
c0104fa0:	68 cf 00 00 00       	push   $0xcf
c0104fa5:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0104fab:	50                   	push   %eax
c0104fac:	e8 28 b5 ff ff       	call   c01004d9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104fb1:	83 ec 0c             	sub    $0xc,%esp
c0104fb4:	ff 75 ec             	pushl  -0x14(%ebp)
c0104fb7:	e8 dc f7 ff ff       	call   c0104798 <page2pa>
c0104fbc:	83 c4 10             	add    $0x10,%esp
c0104fbf:	89 c2                	mov    %eax,%edx
c0104fc1:	c7 c0 80 be 11 c0    	mov    $0xc011be80,%eax
c0104fc7:	8b 00                	mov    (%eax),%eax
c0104fc9:	c1 e0 0c             	shl    $0xc,%eax
c0104fcc:	39 c2                	cmp    %eax,%edx
c0104fce:	72 1f                	jb     c0104fef <basic_check+0x18e>
c0104fd0:	8d 83 38 ea fe ff    	lea    -0x115c8(%ebx),%eax
c0104fd6:	50                   	push   %eax
c0104fd7:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0104fdd:	50                   	push   %eax
c0104fde:	68 d1 00 00 00       	push   $0xd1
c0104fe3:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0104fe9:	50                   	push   %eax
c0104fea:	e8 ea b4 ff ff       	call   c01004d9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104fef:	83 ec 0c             	sub    $0xc,%esp
c0104ff2:	ff 75 f0             	pushl  -0x10(%ebp)
c0104ff5:	e8 9e f7 ff ff       	call   c0104798 <page2pa>
c0104ffa:	83 c4 10             	add    $0x10,%esp
c0104ffd:	89 c2                	mov    %eax,%edx
c0104fff:	c7 c0 80 be 11 c0    	mov    $0xc011be80,%eax
c0105005:	8b 00                	mov    (%eax),%eax
c0105007:	c1 e0 0c             	shl    $0xc,%eax
c010500a:	39 c2                	cmp    %eax,%edx
c010500c:	72 1f                	jb     c010502d <basic_check+0x1cc>
c010500e:	8d 83 55 ea fe ff    	lea    -0x115ab(%ebx),%eax
c0105014:	50                   	push   %eax
c0105015:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c010501b:	50                   	push   %eax
c010501c:	68 d2 00 00 00       	push   $0xd2
c0105021:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0105027:	50                   	push   %eax
c0105028:	e8 ac b4 ff ff       	call   c01004d9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010502d:	83 ec 0c             	sub    $0xc,%esp
c0105030:	ff 75 f4             	pushl  -0xc(%ebp)
c0105033:	e8 60 f7 ff ff       	call   c0104798 <page2pa>
c0105038:	83 c4 10             	add    $0x10,%esp
c010503b:	89 c2                	mov    %eax,%edx
c010503d:	c7 c0 80 be 11 c0    	mov    $0xc011be80,%eax
c0105043:	8b 00                	mov    (%eax),%eax
c0105045:	c1 e0 0c             	shl    $0xc,%eax
c0105048:	39 c2                	cmp    %eax,%edx
c010504a:	72 1f                	jb     c010506b <basic_check+0x20a>
c010504c:	8d 83 72 ea fe ff    	lea    -0x1158e(%ebx),%eax
c0105052:	50                   	push   %eax
c0105053:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0105059:	50                   	push   %eax
c010505a:	68 d3 00 00 00       	push   $0xd3
c010505f:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0105065:	50                   	push   %eax
c0105066:	e8 6e b4 ff ff       	call   c01004d9 <__panic>

    list_entry_t free_list_store = free_list;
c010506b:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0105071:	8b 50 04             	mov    0x4(%eax),%edx
c0105074:	8b 00                	mov    (%eax),%eax
c0105076:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105079:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010507c:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0105082:	89 45 dc             	mov    %eax,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0105085:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105088:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010508b:	89 50 04             	mov    %edx,0x4(%eax)
c010508e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105091:	8b 50 04             	mov    0x4(%eax),%edx
c0105094:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105097:	89 10                	mov    %edx,(%eax)
c0105099:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c010509f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return list->next == list;
c01050a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050a5:	8b 40 04             	mov    0x4(%eax),%eax
c01050a8:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01050ab:	0f 94 c0             	sete   %al
c01050ae:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01050b1:	85 c0                	test   %eax,%eax
c01050b3:	75 1f                	jne    c01050d4 <basic_check+0x273>
c01050b5:	8d 83 8f ea fe ff    	lea    -0x11571(%ebx),%eax
c01050bb:	50                   	push   %eax
c01050bc:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c01050c2:	50                   	push   %eax
c01050c3:	68 d7 00 00 00       	push   $0xd7
c01050c8:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c01050ce:	50                   	push   %eax
c01050cf:	e8 05 b4 ff ff       	call   c01004d9 <__panic>

    unsigned int nr_free_store = nr_free;
c01050d4:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c01050da:	8b 40 08             	mov    0x8(%eax),%eax
c01050dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01050e0:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c01050e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

    assert(alloc_page() == NULL);
c01050ed:	83 ec 0c             	sub    $0xc,%esp
c01050f0:	6a 01                	push   $0x1
c01050f2:	e8 c2 df ff ff       	call   c01030b9 <alloc_pages>
c01050f7:	83 c4 10             	add    $0x10,%esp
c01050fa:	85 c0                	test   %eax,%eax
c01050fc:	74 1f                	je     c010511d <basic_check+0x2bc>
c01050fe:	8d 83 a6 ea fe ff    	lea    -0x1155a(%ebx),%eax
c0105104:	50                   	push   %eax
c0105105:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c010510b:	50                   	push   %eax
c010510c:	68 dc 00 00 00       	push   $0xdc
c0105111:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0105117:	50                   	push   %eax
c0105118:	e8 bc b3 ff ff       	call   c01004d9 <__panic>

    free_page(p0);
c010511d:	83 ec 08             	sub    $0x8,%esp
c0105120:	6a 01                	push   $0x1
c0105122:	ff 75 ec             	pushl  -0x14(%ebp)
c0105125:	e8 df df ff ff       	call   c0103109 <free_pages>
c010512a:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c010512d:	83 ec 08             	sub    $0x8,%esp
c0105130:	6a 01                	push   $0x1
c0105132:	ff 75 f0             	pushl  -0x10(%ebp)
c0105135:	e8 cf df ff ff       	call   c0103109 <free_pages>
c010513a:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010513d:	83 ec 08             	sub    $0x8,%esp
c0105140:	6a 01                	push   $0x1
c0105142:	ff 75 f4             	pushl  -0xc(%ebp)
c0105145:	e8 bf df ff ff       	call   c0103109 <free_pages>
c010514a:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c010514d:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0105153:	8b 40 08             	mov    0x8(%eax),%eax
c0105156:	83 f8 03             	cmp    $0x3,%eax
c0105159:	74 1f                	je     c010517a <basic_check+0x319>
c010515b:	8d 83 bb ea fe ff    	lea    -0x11545(%ebx),%eax
c0105161:	50                   	push   %eax
c0105162:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0105168:	50                   	push   %eax
c0105169:	68 e1 00 00 00       	push   $0xe1
c010516e:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0105174:	50                   	push   %eax
c0105175:	e8 5f b3 ff ff       	call   c01004d9 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010517a:	83 ec 0c             	sub    $0xc,%esp
c010517d:	6a 01                	push   $0x1
c010517f:	e8 35 df ff ff       	call   c01030b9 <alloc_pages>
c0105184:	83 c4 10             	add    $0x10,%esp
c0105187:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010518a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010518e:	75 1f                	jne    c01051af <basic_check+0x34e>
c0105190:	8d 83 84 e9 fe ff    	lea    -0x1167c(%ebx),%eax
c0105196:	50                   	push   %eax
c0105197:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c010519d:	50                   	push   %eax
c010519e:	68 e3 00 00 00       	push   $0xe3
c01051a3:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c01051a9:	50                   	push   %eax
c01051aa:	e8 2a b3 ff ff       	call   c01004d9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01051af:	83 ec 0c             	sub    $0xc,%esp
c01051b2:	6a 01                	push   $0x1
c01051b4:	e8 00 df ff ff       	call   c01030b9 <alloc_pages>
c01051b9:	83 c4 10             	add    $0x10,%esp
c01051bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01051bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01051c3:	75 1f                	jne    c01051e4 <basic_check+0x383>
c01051c5:	8d 83 a0 e9 fe ff    	lea    -0x11660(%ebx),%eax
c01051cb:	50                   	push   %eax
c01051cc:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c01051d2:	50                   	push   %eax
c01051d3:	68 e4 00 00 00       	push   $0xe4
c01051d8:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c01051de:	50                   	push   %eax
c01051df:	e8 f5 b2 ff ff       	call   c01004d9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01051e4:	83 ec 0c             	sub    $0xc,%esp
c01051e7:	6a 01                	push   $0x1
c01051e9:	e8 cb de ff ff       	call   c01030b9 <alloc_pages>
c01051ee:	83 c4 10             	add    $0x10,%esp
c01051f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01051f8:	75 1f                	jne    c0105219 <basic_check+0x3b8>
c01051fa:	8d 83 bc e9 fe ff    	lea    -0x11644(%ebx),%eax
c0105200:	50                   	push   %eax
c0105201:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0105207:	50                   	push   %eax
c0105208:	68 e5 00 00 00       	push   $0xe5
c010520d:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0105213:	50                   	push   %eax
c0105214:	e8 c0 b2 ff ff       	call   c01004d9 <__panic>

    assert(alloc_page() == NULL);
c0105219:	83 ec 0c             	sub    $0xc,%esp
c010521c:	6a 01                	push   $0x1
c010521e:	e8 96 de ff ff       	call   c01030b9 <alloc_pages>
c0105223:	83 c4 10             	add    $0x10,%esp
c0105226:	85 c0                	test   %eax,%eax
c0105228:	74 1f                	je     c0105249 <basic_check+0x3e8>
c010522a:	8d 83 a6 ea fe ff    	lea    -0x1155a(%ebx),%eax
c0105230:	50                   	push   %eax
c0105231:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0105237:	50                   	push   %eax
c0105238:	68 e7 00 00 00       	push   $0xe7
c010523d:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0105243:	50                   	push   %eax
c0105244:	e8 90 b2 ff ff       	call   c01004d9 <__panic>

    free_page(p0);
c0105249:	83 ec 08             	sub    $0x8,%esp
c010524c:	6a 01                	push   $0x1
c010524e:	ff 75 ec             	pushl  -0x14(%ebp)
c0105251:	e8 b3 de ff ff       	call   c0103109 <free_pages>
c0105256:	83 c4 10             	add    $0x10,%esp
c0105259:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c010525f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0105262:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105265:	8b 40 04             	mov    0x4(%eax),%eax
c0105268:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010526b:	0f 94 c0             	sete   %al
c010526e:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0105271:	85 c0                	test   %eax,%eax
c0105273:	74 1f                	je     c0105294 <basic_check+0x433>
c0105275:	8d 83 c8 ea fe ff    	lea    -0x11538(%ebx),%eax
c010527b:	50                   	push   %eax
c010527c:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0105282:	50                   	push   %eax
c0105283:	68 ea 00 00 00       	push   $0xea
c0105288:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c010528e:	50                   	push   %eax
c010528f:	e8 45 b2 ff ff       	call   c01004d9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0105294:	83 ec 0c             	sub    $0xc,%esp
c0105297:	6a 01                	push   $0x1
c0105299:	e8 1b de ff ff       	call   c01030b9 <alloc_pages>
c010529e:	83 c4 10             	add    $0x10,%esp
c01052a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01052aa:	74 1f                	je     c01052cb <basic_check+0x46a>
c01052ac:	8d 83 e0 ea fe ff    	lea    -0x11520(%ebx),%eax
c01052b2:	50                   	push   %eax
c01052b3:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c01052b9:	50                   	push   %eax
c01052ba:	68 ed 00 00 00       	push   $0xed
c01052bf:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c01052c5:	50                   	push   %eax
c01052c6:	e8 0e b2 ff ff       	call   c01004d9 <__panic>
    assert(alloc_page() == NULL);
c01052cb:	83 ec 0c             	sub    $0xc,%esp
c01052ce:	6a 01                	push   $0x1
c01052d0:	e8 e4 dd ff ff       	call   c01030b9 <alloc_pages>
c01052d5:	83 c4 10             	add    $0x10,%esp
c01052d8:	85 c0                	test   %eax,%eax
c01052da:	74 1f                	je     c01052fb <basic_check+0x49a>
c01052dc:	8d 83 a6 ea fe ff    	lea    -0x1155a(%ebx),%eax
c01052e2:	50                   	push   %eax
c01052e3:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c01052e9:	50                   	push   %eax
c01052ea:	68 ee 00 00 00       	push   $0xee
c01052ef:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c01052f5:	50                   	push   %eax
c01052f6:	e8 de b1 ff ff       	call   c01004d9 <__panic>

    assert(nr_free == 0);
c01052fb:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0105301:	8b 40 08             	mov    0x8(%eax),%eax
c0105304:	85 c0                	test   %eax,%eax
c0105306:	74 1f                	je     c0105327 <basic_check+0x4c6>
c0105308:	8d 83 f9 ea fe ff    	lea    -0x11507(%ebx),%eax
c010530e:	50                   	push   %eax
c010530f:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0105315:	50                   	push   %eax
c0105316:	68 f0 00 00 00       	push   $0xf0
c010531b:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0105321:	50                   	push   %eax
c0105322:	e8 b2 b1 ff ff       	call   c01004d9 <__panic>
    free_list = free_list_store;
c0105327:	c7 c1 1c bf 11 c0    	mov    $0xc011bf1c,%ecx
c010532d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105330:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105333:	89 01                	mov    %eax,(%ecx)
c0105335:	89 51 04             	mov    %edx,0x4(%ecx)
    nr_free = nr_free_store;
c0105338:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c010533e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105341:	89 50 08             	mov    %edx,0x8(%eax)

    free_page(p);
c0105344:	83 ec 08             	sub    $0x8,%esp
c0105347:	6a 01                	push   $0x1
c0105349:	ff 75 e4             	pushl  -0x1c(%ebp)
c010534c:	e8 b8 dd ff ff       	call   c0103109 <free_pages>
c0105351:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0105354:	83 ec 08             	sub    $0x8,%esp
c0105357:	6a 01                	push   $0x1
c0105359:	ff 75 f0             	pushl  -0x10(%ebp)
c010535c:	e8 a8 dd ff ff       	call   c0103109 <free_pages>
c0105361:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0105364:	83 ec 08             	sub    $0x8,%esp
c0105367:	6a 01                	push   $0x1
c0105369:	ff 75 f4             	pushl  -0xc(%ebp)
c010536c:	e8 98 dd ff ff       	call   c0103109 <free_pages>
c0105371:	83 c4 10             	add    $0x10,%esp
}
c0105374:	90                   	nop
c0105375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0105378:	c9                   	leave  
c0105379:	c3                   	ret    

c010537a <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010537a:	55                   	push   %ebp
c010537b:	89 e5                	mov    %esp,%ebp
c010537d:	53                   	push   %ebx
c010537e:	81 ec 84 00 00 00    	sub    $0x84,%esp
c0105384:	e8 2d af ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0105389:	81 c3 c7 35 01 00    	add    $0x135c7,%ebx
    int count = 0, total = 0;
c010538f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105396:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010539d:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c01053a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01053a6:	eb 66                	jmp    c010540e <default_check+0x94>
        struct Page *p = le2page(le, page_link);
c01053a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053ab:	83 e8 0c             	sub    $0xc,%eax
c01053ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c01053b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01053b4:	83 c0 04             	add    $0x4,%eax
c01053b7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01053be:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01053c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01053c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01053c7:	0f a3 10             	bt     %edx,(%eax)
c01053ca:	19 c0                	sbb    %eax,%eax
c01053cc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01053cf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01053d3:	0f 95 c0             	setne  %al
c01053d6:	0f b6 c0             	movzbl %al,%eax
c01053d9:	85 c0                	test   %eax,%eax
c01053db:	75 1f                	jne    c01053fc <default_check+0x82>
c01053dd:	8d 83 06 eb fe ff    	lea    -0x114fa(%ebx),%eax
c01053e3:	50                   	push   %eax
c01053e4:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c01053ea:	50                   	push   %eax
c01053eb:	68 01 01 00 00       	push   $0x101
c01053f0:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c01053f6:	50                   	push   %eax
c01053f7:	e8 dd b0 ff ff       	call   c01004d9 <__panic>
        count ++, total += p->property;
c01053fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0105400:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105403:	8b 50 08             	mov    0x8(%eax),%edx
c0105406:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105409:	01 d0                	add    %edx,%eax
c010540b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010540e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105411:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0105414:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105417:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010541a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010541d:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0105423:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105426:	75 80                	jne    c01053a8 <default_check+0x2e>
    }
    assert(total == nr_free_pages());
c0105428:	e8 23 dd ff ff       	call   c0103150 <nr_free_pages>
c010542d:	89 c2                	mov    %eax,%edx
c010542f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105432:	39 c2                	cmp    %eax,%edx
c0105434:	74 1f                	je     c0105455 <default_check+0xdb>
c0105436:	8d 83 16 eb fe ff    	lea    -0x114ea(%ebx),%eax
c010543c:	50                   	push   %eax
c010543d:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0105443:	50                   	push   %eax
c0105444:	68 04 01 00 00       	push   $0x104
c0105449:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c010544f:	50                   	push   %eax
c0105450:	e8 84 b0 ff ff       	call   c01004d9 <__panic>

    basic_check();
c0105455:	e8 07 fa ff ff       	call   c0104e61 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010545a:	83 ec 0c             	sub    $0xc,%esp
c010545d:	6a 05                	push   $0x5
c010545f:	e8 55 dc ff ff       	call   c01030b9 <alloc_pages>
c0105464:	83 c4 10             	add    $0x10,%esp
c0105467:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c010546a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010546e:	75 1f                	jne    c010548f <default_check+0x115>
c0105470:	8d 83 2f eb fe ff    	lea    -0x114d1(%ebx),%eax
c0105476:	50                   	push   %eax
c0105477:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c010547d:	50                   	push   %eax
c010547e:	68 09 01 00 00       	push   $0x109
c0105483:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0105489:	50                   	push   %eax
c010548a:	e8 4a b0 ff ff       	call   c01004d9 <__panic>
    assert(!PageProperty(p0));
c010548f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105492:	83 c0 04             	add    $0x4,%eax
c0105495:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010549c:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010549f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01054a2:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01054a5:	0f a3 10             	bt     %edx,(%eax)
c01054a8:	19 c0                	sbb    %eax,%eax
c01054aa:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01054ad:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01054b1:	0f 95 c0             	setne  %al
c01054b4:	0f b6 c0             	movzbl %al,%eax
c01054b7:	85 c0                	test   %eax,%eax
c01054b9:	74 1f                	je     c01054da <default_check+0x160>
c01054bb:	8d 83 3a eb fe ff    	lea    -0x114c6(%ebx),%eax
c01054c1:	50                   	push   %eax
c01054c2:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c01054c8:	50                   	push   %eax
c01054c9:	68 0a 01 00 00       	push   $0x10a
c01054ce:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c01054d4:	50                   	push   %eax
c01054d5:	e8 ff af ff ff       	call   c01004d9 <__panic>

    list_entry_t free_list_store = free_list;
c01054da:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c01054e0:	8b 50 04             	mov    0x4(%eax),%edx
c01054e3:	8b 00                	mov    (%eax),%eax
c01054e5:	89 45 80             	mov    %eax,-0x80(%ebp)
c01054e8:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01054eb:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c01054f1:	89 45 b0             	mov    %eax,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01054f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01054f7:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01054fa:	89 50 04             	mov    %edx,0x4(%eax)
c01054fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105500:	8b 50 04             	mov    0x4(%eax),%edx
c0105503:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105506:	89 10                	mov    %edx,(%eax)
c0105508:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c010550e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return list->next == list;
c0105511:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105514:	8b 40 04             	mov    0x4(%eax),%eax
c0105517:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c010551a:	0f 94 c0             	sete   %al
c010551d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0105520:	85 c0                	test   %eax,%eax
c0105522:	75 1f                	jne    c0105543 <default_check+0x1c9>
c0105524:	8d 83 8f ea fe ff    	lea    -0x11571(%ebx),%eax
c010552a:	50                   	push   %eax
c010552b:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0105531:	50                   	push   %eax
c0105532:	68 0e 01 00 00       	push   $0x10e
c0105537:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c010553d:	50                   	push   %eax
c010553e:	e8 96 af ff ff       	call   c01004d9 <__panic>
    assert(alloc_page() == NULL);
c0105543:	83 ec 0c             	sub    $0xc,%esp
c0105546:	6a 01                	push   $0x1
c0105548:	e8 6c db ff ff       	call   c01030b9 <alloc_pages>
c010554d:	83 c4 10             	add    $0x10,%esp
c0105550:	85 c0                	test   %eax,%eax
c0105552:	74 1f                	je     c0105573 <default_check+0x1f9>
c0105554:	8d 83 a6 ea fe ff    	lea    -0x1155a(%ebx),%eax
c010555a:	50                   	push   %eax
c010555b:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0105561:	50                   	push   %eax
c0105562:	68 0f 01 00 00       	push   $0x10f
c0105567:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c010556d:	50                   	push   %eax
c010556e:	e8 66 af ff ff       	call   c01004d9 <__panic>

    unsigned int nr_free_store = nr_free;
c0105573:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0105579:	8b 40 08             	mov    0x8(%eax),%eax
c010557c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c010557f:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c0105585:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

    free_pages(p0 + 2, 3);
c010558c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010558f:	83 c0 28             	add    $0x28,%eax
c0105592:	83 ec 08             	sub    $0x8,%esp
c0105595:	6a 03                	push   $0x3
c0105597:	50                   	push   %eax
c0105598:	e8 6c db ff ff       	call   c0103109 <free_pages>
c010559d:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c01055a0:	83 ec 0c             	sub    $0xc,%esp
c01055a3:	6a 04                	push   $0x4
c01055a5:	e8 0f db ff ff       	call   c01030b9 <alloc_pages>
c01055aa:	83 c4 10             	add    $0x10,%esp
c01055ad:	85 c0                	test   %eax,%eax
c01055af:	74 1f                	je     c01055d0 <default_check+0x256>
c01055b1:	8d 83 4c eb fe ff    	lea    -0x114b4(%ebx),%eax
c01055b7:	50                   	push   %eax
c01055b8:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c01055be:	50                   	push   %eax
c01055bf:	68 15 01 00 00       	push   $0x115
c01055c4:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c01055ca:	50                   	push   %eax
c01055cb:	e8 09 af ff ff       	call   c01004d9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01055d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055d3:	83 c0 28             	add    $0x28,%eax
c01055d6:	83 c0 04             	add    $0x4,%eax
c01055d9:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01055e0:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01055e3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01055e6:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01055e9:	0f a3 10             	bt     %edx,(%eax)
c01055ec:	19 c0                	sbb    %eax,%eax
c01055ee:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01055f1:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01055f5:	0f 95 c0             	setne  %al
c01055f8:	0f b6 c0             	movzbl %al,%eax
c01055fb:	85 c0                	test   %eax,%eax
c01055fd:	74 0e                	je     c010560d <default_check+0x293>
c01055ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105602:	83 c0 28             	add    $0x28,%eax
c0105605:	8b 40 08             	mov    0x8(%eax),%eax
c0105608:	83 f8 03             	cmp    $0x3,%eax
c010560b:	74 1f                	je     c010562c <default_check+0x2b2>
c010560d:	8d 83 64 eb fe ff    	lea    -0x1149c(%ebx),%eax
c0105613:	50                   	push   %eax
c0105614:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c010561a:	50                   	push   %eax
c010561b:	68 16 01 00 00       	push   $0x116
c0105620:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0105626:	50                   	push   %eax
c0105627:	e8 ad ae ff ff       	call   c01004d9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010562c:	83 ec 0c             	sub    $0xc,%esp
c010562f:	6a 03                	push   $0x3
c0105631:	e8 83 da ff ff       	call   c01030b9 <alloc_pages>
c0105636:	83 c4 10             	add    $0x10,%esp
c0105639:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010563c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105640:	75 1f                	jne    c0105661 <default_check+0x2e7>
c0105642:	8d 83 90 eb fe ff    	lea    -0x11470(%ebx),%eax
c0105648:	50                   	push   %eax
c0105649:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c010564f:	50                   	push   %eax
c0105650:	68 17 01 00 00       	push   $0x117
c0105655:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c010565b:	50                   	push   %eax
c010565c:	e8 78 ae ff ff       	call   c01004d9 <__panic>
    assert(alloc_page() == NULL);
c0105661:	83 ec 0c             	sub    $0xc,%esp
c0105664:	6a 01                	push   $0x1
c0105666:	e8 4e da ff ff       	call   c01030b9 <alloc_pages>
c010566b:	83 c4 10             	add    $0x10,%esp
c010566e:	85 c0                	test   %eax,%eax
c0105670:	74 1f                	je     c0105691 <default_check+0x317>
c0105672:	8d 83 a6 ea fe ff    	lea    -0x1155a(%ebx),%eax
c0105678:	50                   	push   %eax
c0105679:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c010567f:	50                   	push   %eax
c0105680:	68 18 01 00 00       	push   $0x118
c0105685:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c010568b:	50                   	push   %eax
c010568c:	e8 48 ae ff ff       	call   c01004d9 <__panic>
    assert(p0 + 2 == p1);
c0105691:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105694:	83 c0 28             	add    $0x28,%eax
c0105697:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010569a:	74 1f                	je     c01056bb <default_check+0x341>
c010569c:	8d 83 ae eb fe ff    	lea    -0x11452(%ebx),%eax
c01056a2:	50                   	push   %eax
c01056a3:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c01056a9:	50                   	push   %eax
c01056aa:	68 19 01 00 00       	push   $0x119
c01056af:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c01056b5:	50                   	push   %eax
c01056b6:	e8 1e ae ff ff       	call   c01004d9 <__panic>

    p2 = p0 + 1;
c01056bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056be:	83 c0 14             	add    $0x14,%eax
c01056c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01056c4:	83 ec 08             	sub    $0x8,%esp
c01056c7:	6a 01                	push   $0x1
c01056c9:	ff 75 e8             	pushl  -0x18(%ebp)
c01056cc:	e8 38 da ff ff       	call   c0103109 <free_pages>
c01056d1:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c01056d4:	83 ec 08             	sub    $0x8,%esp
c01056d7:	6a 03                	push   $0x3
c01056d9:	ff 75 e0             	pushl  -0x20(%ebp)
c01056dc:	e8 28 da ff ff       	call   c0103109 <free_pages>
c01056e1:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c01056e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056e7:	83 c0 04             	add    $0x4,%eax
c01056ea:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01056f1:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01056f4:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01056f7:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01056fa:	0f a3 10             	bt     %edx,(%eax)
c01056fd:	19 c0                	sbb    %eax,%eax
c01056ff:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0105702:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105706:	0f 95 c0             	setne  %al
c0105709:	0f b6 c0             	movzbl %al,%eax
c010570c:	85 c0                	test   %eax,%eax
c010570e:	74 0b                	je     c010571b <default_check+0x3a1>
c0105710:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105713:	8b 40 08             	mov    0x8(%eax),%eax
c0105716:	83 f8 01             	cmp    $0x1,%eax
c0105719:	74 1f                	je     c010573a <default_check+0x3c0>
c010571b:	8d 83 bc eb fe ff    	lea    -0x11444(%ebx),%eax
c0105721:	50                   	push   %eax
c0105722:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0105728:	50                   	push   %eax
c0105729:	68 1e 01 00 00       	push   $0x11e
c010572e:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0105734:	50                   	push   %eax
c0105735:	e8 9f ad ff ff       	call   c01004d9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010573a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010573d:	83 c0 04             	add    $0x4,%eax
c0105740:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0105747:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010574a:	8b 45 90             	mov    -0x70(%ebp),%eax
c010574d:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0105750:	0f a3 10             	bt     %edx,(%eax)
c0105753:	19 c0                	sbb    %eax,%eax
c0105755:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0105758:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010575c:	0f 95 c0             	setne  %al
c010575f:	0f b6 c0             	movzbl %al,%eax
c0105762:	85 c0                	test   %eax,%eax
c0105764:	74 0b                	je     c0105771 <default_check+0x3f7>
c0105766:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105769:	8b 40 08             	mov    0x8(%eax),%eax
c010576c:	83 f8 03             	cmp    $0x3,%eax
c010576f:	74 1f                	je     c0105790 <default_check+0x416>
c0105771:	8d 83 e4 eb fe ff    	lea    -0x1141c(%ebx),%eax
c0105777:	50                   	push   %eax
c0105778:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c010577e:	50                   	push   %eax
c010577f:	68 1f 01 00 00       	push   $0x11f
c0105784:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c010578a:	50                   	push   %eax
c010578b:	e8 49 ad ff ff       	call   c01004d9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0105790:	83 ec 0c             	sub    $0xc,%esp
c0105793:	6a 01                	push   $0x1
c0105795:	e8 1f d9 ff ff       	call   c01030b9 <alloc_pages>
c010579a:	83 c4 10             	add    $0x10,%esp
c010579d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057a3:	83 e8 14             	sub    $0x14,%eax
c01057a6:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01057a9:	74 1f                	je     c01057ca <default_check+0x450>
c01057ab:	8d 83 0a ec fe ff    	lea    -0x113f6(%ebx),%eax
c01057b1:	50                   	push   %eax
c01057b2:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c01057b8:	50                   	push   %eax
c01057b9:	68 21 01 00 00       	push   $0x121
c01057be:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c01057c4:	50                   	push   %eax
c01057c5:	e8 0f ad ff ff       	call   c01004d9 <__panic>
    free_page(p0);
c01057ca:	83 ec 08             	sub    $0x8,%esp
c01057cd:	6a 01                	push   $0x1
c01057cf:	ff 75 e8             	pushl  -0x18(%ebp)
c01057d2:	e8 32 d9 ff ff       	call   c0103109 <free_pages>
c01057d7:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01057da:	83 ec 0c             	sub    $0xc,%esp
c01057dd:	6a 02                	push   $0x2
c01057df:	e8 d5 d8 ff ff       	call   c01030b9 <alloc_pages>
c01057e4:	83 c4 10             	add    $0x10,%esp
c01057e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057ed:	83 c0 14             	add    $0x14,%eax
c01057f0:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01057f3:	74 1f                	je     c0105814 <default_check+0x49a>
c01057f5:	8d 83 28 ec fe ff    	lea    -0x113d8(%ebx),%eax
c01057fb:	50                   	push   %eax
c01057fc:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0105802:	50                   	push   %eax
c0105803:	68 23 01 00 00       	push   $0x123
c0105808:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c010580e:	50                   	push   %eax
c010580f:	e8 c5 ac ff ff       	call   c01004d9 <__panic>

    free_pages(p0, 2);
c0105814:	83 ec 08             	sub    $0x8,%esp
c0105817:	6a 02                	push   $0x2
c0105819:	ff 75 e8             	pushl  -0x18(%ebp)
c010581c:	e8 e8 d8 ff ff       	call   c0103109 <free_pages>
c0105821:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0105824:	83 ec 08             	sub    $0x8,%esp
c0105827:	6a 01                	push   $0x1
c0105829:	ff 75 dc             	pushl  -0x24(%ebp)
c010582c:	e8 d8 d8 ff ff       	call   c0103109 <free_pages>
c0105831:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0105834:	83 ec 0c             	sub    $0xc,%esp
c0105837:	6a 05                	push   $0x5
c0105839:	e8 7b d8 ff ff       	call   c01030b9 <alloc_pages>
c010583e:	83 c4 10             	add    $0x10,%esp
c0105841:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105844:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105848:	75 1f                	jne    c0105869 <default_check+0x4ef>
c010584a:	8d 83 48 ec fe ff    	lea    -0x113b8(%ebx),%eax
c0105850:	50                   	push   %eax
c0105851:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0105857:	50                   	push   %eax
c0105858:	68 28 01 00 00       	push   $0x128
c010585d:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0105863:	50                   	push   %eax
c0105864:	e8 70 ac ff ff       	call   c01004d9 <__panic>
    assert(alloc_page() == NULL);
c0105869:	83 ec 0c             	sub    $0xc,%esp
c010586c:	6a 01                	push   $0x1
c010586e:	e8 46 d8 ff ff       	call   c01030b9 <alloc_pages>
c0105873:	83 c4 10             	add    $0x10,%esp
c0105876:	85 c0                	test   %eax,%eax
c0105878:	74 1f                	je     c0105899 <default_check+0x51f>
c010587a:	8d 83 a6 ea fe ff    	lea    -0x1155a(%ebx),%eax
c0105880:	50                   	push   %eax
c0105881:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0105887:	50                   	push   %eax
c0105888:	68 29 01 00 00       	push   $0x129
c010588d:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0105893:	50                   	push   %eax
c0105894:	e8 40 ac ff ff       	call   c01004d9 <__panic>

    assert(nr_free == 0);
c0105899:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c010589f:	8b 40 08             	mov    0x8(%eax),%eax
c01058a2:	85 c0                	test   %eax,%eax
c01058a4:	74 1f                	je     c01058c5 <default_check+0x54b>
c01058a6:	8d 83 f9 ea fe ff    	lea    -0x11507(%ebx),%eax
c01058ac:	50                   	push   %eax
c01058ad:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c01058b3:	50                   	push   %eax
c01058b4:	68 2b 01 00 00       	push   $0x12b
c01058b9:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c01058bf:	50                   	push   %eax
c01058c0:	e8 14 ac ff ff       	call   c01004d9 <__panic>
    nr_free = nr_free_store;
c01058c5:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c01058cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01058ce:	89 50 08             	mov    %edx,0x8(%eax)

    free_list = free_list_store;
c01058d1:	c7 c1 1c bf 11 c0    	mov    $0xc011bf1c,%ecx
c01058d7:	8b 45 80             	mov    -0x80(%ebp),%eax
c01058da:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01058dd:	89 01                	mov    %eax,(%ecx)
c01058df:	89 51 04             	mov    %edx,0x4(%ecx)
    free_pages(p0, 5);
c01058e2:	83 ec 08             	sub    $0x8,%esp
c01058e5:	6a 05                	push   $0x5
c01058e7:	ff 75 e8             	pushl  -0x18(%ebp)
c01058ea:	e8 1a d8 ff ff       	call   c0103109 <free_pages>
c01058ef:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c01058f2:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c01058f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01058fb:	eb 1d                	jmp    c010591a <default_check+0x5a0>
        struct Page *p = le2page(le, page_link);
c01058fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105900:	83 e8 0c             	sub    $0xc,%eax
c0105903:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0105906:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010590a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010590d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105910:	8b 40 08             	mov    0x8(%eax),%eax
c0105913:	29 c2                	sub    %eax,%edx
c0105915:	89 d0                	mov    %edx,%eax
c0105917:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010591a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010591d:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0105920:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105923:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105926:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105929:	c7 c0 1c bf 11 c0    	mov    $0xc011bf1c,%eax
c010592f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105932:	75 c9                	jne    c01058fd <default_check+0x583>
    }
    assert(count == 0);
c0105934:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105938:	74 1f                	je     c0105959 <default_check+0x5df>
c010593a:	8d 83 66 ec fe ff    	lea    -0x1139a(%ebx),%eax
c0105940:	50                   	push   %eax
c0105941:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c0105947:	50                   	push   %eax
c0105948:	68 36 01 00 00       	push   $0x136
c010594d:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0105953:	50                   	push   %eax
c0105954:	e8 80 ab ff ff       	call   c01004d9 <__panic>
    assert(total == 0);
c0105959:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010595d:	74 1f                	je     c010597e <default_check+0x604>
c010595f:	8d 83 71 ec fe ff    	lea    -0x1138f(%ebx),%eax
c0105965:	50                   	push   %eax
c0105966:	8d 83 06 e9 fe ff    	lea    -0x116fa(%ebx),%eax
c010596c:	50                   	push   %eax
c010596d:	68 37 01 00 00       	push   $0x137
c0105972:	8d 83 1b e9 fe ff    	lea    -0x116e5(%ebx),%eax
c0105978:	50                   	push   %eax
c0105979:	e8 5b ab ff ff       	call   c01004d9 <__panic>
}
c010597e:	90                   	nop
c010597f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0105982:	c9                   	leave  
c0105983:	c3                   	ret    

c0105984 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105984:	55                   	push   %ebp
c0105985:	89 e5                	mov    %esp,%ebp
c0105987:	83 ec 10             	sub    $0x10,%esp
c010598a:	e8 23 a9 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010598f:	05 c1 2f 01 00       	add    $0x12fc1,%eax
    size_t cnt = 0;
c0105994:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010599b:	eb 04                	jmp    c01059a1 <strlen+0x1d>
        cnt ++;
c010599d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c01059a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a4:	8d 50 01             	lea    0x1(%eax),%edx
c01059a7:	89 55 08             	mov    %edx,0x8(%ebp)
c01059aa:	0f b6 00             	movzbl (%eax),%eax
c01059ad:	84 c0                	test   %al,%al
c01059af:	75 ec                	jne    c010599d <strlen+0x19>
    }
    return cnt;
c01059b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01059b4:	c9                   	leave  
c01059b5:	c3                   	ret    

c01059b6 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01059b6:	55                   	push   %ebp
c01059b7:	89 e5                	mov    %esp,%ebp
c01059b9:	83 ec 10             	sub    $0x10,%esp
c01059bc:	e8 f1 a8 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01059c1:	05 8f 2f 01 00       	add    $0x12f8f,%eax
    size_t cnt = 0;
c01059c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01059cd:	eb 04                	jmp    c01059d3 <strnlen+0x1d>
        cnt ++;
c01059cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01059d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01059d9:	73 10                	jae    c01059eb <strnlen+0x35>
c01059db:	8b 45 08             	mov    0x8(%ebp),%eax
c01059de:	8d 50 01             	lea    0x1(%eax),%edx
c01059e1:	89 55 08             	mov    %edx,0x8(%ebp)
c01059e4:	0f b6 00             	movzbl (%eax),%eax
c01059e7:	84 c0                	test   %al,%al
c01059e9:	75 e4                	jne    c01059cf <strnlen+0x19>
    }
    return cnt;
c01059eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01059ee:	c9                   	leave  
c01059ef:	c3                   	ret    

c01059f0 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01059f0:	55                   	push   %ebp
c01059f1:	89 e5                	mov    %esp,%ebp
c01059f3:	57                   	push   %edi
c01059f4:	56                   	push   %esi
c01059f5:	83 ec 20             	sub    $0x20,%esp
c01059f8:	e8 b5 a8 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01059fd:	05 53 2f 01 00       	add    $0x12f53,%eax
c0105a02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a08:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105a0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a14:	89 d1                	mov    %edx,%ecx
c0105a16:	89 c2                	mov    %eax,%edx
c0105a18:	89 ce                	mov    %ecx,%esi
c0105a1a:	89 d7                	mov    %edx,%edi
c0105a1c:	ac                   	lods   %ds:(%esi),%al
c0105a1d:	aa                   	stos   %al,%es:(%edi)
c0105a1e:	84 c0                	test   %al,%al
c0105a20:	75 fa                	jne    c0105a1c <strcpy+0x2c>
c0105a22:	89 fa                	mov    %edi,%edx
c0105a24:	89 f1                	mov    %esi,%ecx
c0105a26:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105a29:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0105a32:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105a33:	83 c4 20             	add    $0x20,%esp
c0105a36:	5e                   	pop    %esi
c0105a37:	5f                   	pop    %edi
c0105a38:	5d                   	pop    %ebp
c0105a39:	c3                   	ret    

c0105a3a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105a3a:	55                   	push   %ebp
c0105a3b:	89 e5                	mov    %esp,%ebp
c0105a3d:	83 ec 10             	sub    $0x10,%esp
c0105a40:	e8 6d a8 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105a45:	05 0b 2f 01 00       	add    $0x12f0b,%eax
    char *p = dst;
c0105a4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105a50:	eb 21                	jmp    c0105a73 <strncpy+0x39>
        if ((*p = *src) != '\0') {
c0105a52:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a55:	0f b6 10             	movzbl (%eax),%edx
c0105a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a5b:	88 10                	mov    %dl,(%eax)
c0105a5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a60:	0f b6 00             	movzbl (%eax),%eax
c0105a63:	84 c0                	test   %al,%al
c0105a65:	74 04                	je     c0105a6b <strncpy+0x31>
            src ++;
c0105a67:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105a6b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105a6f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c0105a73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a77:	75 d9                	jne    c0105a52 <strncpy+0x18>
    }
    return dst;
c0105a79:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105a7c:	c9                   	leave  
c0105a7d:	c3                   	ret    

c0105a7e <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105a7e:	55                   	push   %ebp
c0105a7f:	89 e5                	mov    %esp,%ebp
c0105a81:	57                   	push   %edi
c0105a82:	56                   	push   %esi
c0105a83:	83 ec 20             	sub    $0x20,%esp
c0105a86:	e8 27 a8 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105a8b:	05 c5 2e 01 00       	add    $0x12ec5,%eax
c0105a90:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a93:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105aa2:	89 d1                	mov    %edx,%ecx
c0105aa4:	89 c2                	mov    %eax,%edx
c0105aa6:	89 ce                	mov    %ecx,%esi
c0105aa8:	89 d7                	mov    %edx,%edi
c0105aaa:	ac                   	lods   %ds:(%esi),%al
c0105aab:	ae                   	scas   %es:(%edi),%al
c0105aac:	75 08                	jne    c0105ab6 <strcmp+0x38>
c0105aae:	84 c0                	test   %al,%al
c0105ab0:	75 f8                	jne    c0105aaa <strcmp+0x2c>
c0105ab2:	31 c0                	xor    %eax,%eax
c0105ab4:	eb 04                	jmp    c0105aba <strcmp+0x3c>
c0105ab6:	19 c0                	sbb    %eax,%eax
c0105ab8:	0c 01                	or     $0x1,%al
c0105aba:	89 fa                	mov    %edi,%edx
c0105abc:	89 f1                	mov    %esi,%ecx
c0105abe:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ac1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105ac4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0105aca:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105acb:	83 c4 20             	add    $0x20,%esp
c0105ace:	5e                   	pop    %esi
c0105acf:	5f                   	pop    %edi
c0105ad0:	5d                   	pop    %ebp
c0105ad1:	c3                   	ret    

c0105ad2 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105ad2:	55                   	push   %ebp
c0105ad3:	89 e5                	mov    %esp,%ebp
c0105ad5:	e8 d8 a7 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105ada:	05 76 2e 01 00       	add    $0x12e76,%eax
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105adf:	eb 0c                	jmp    c0105aed <strncmp+0x1b>
        n --, s1 ++, s2 ++;
c0105ae1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105ae5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ae9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105aed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105af1:	74 1a                	je     c0105b0d <strncmp+0x3b>
c0105af3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af6:	0f b6 00             	movzbl (%eax),%eax
c0105af9:	84 c0                	test   %al,%al
c0105afb:	74 10                	je     c0105b0d <strncmp+0x3b>
c0105afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b00:	0f b6 10             	movzbl (%eax),%edx
c0105b03:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b06:	0f b6 00             	movzbl (%eax),%eax
c0105b09:	38 c2                	cmp    %al,%dl
c0105b0b:	74 d4                	je     c0105ae1 <strncmp+0xf>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105b0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b11:	74 18                	je     c0105b2b <strncmp+0x59>
c0105b13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b16:	0f b6 00             	movzbl (%eax),%eax
c0105b19:	0f b6 d0             	movzbl %al,%edx
c0105b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b1f:	0f b6 00             	movzbl (%eax),%eax
c0105b22:	0f b6 c0             	movzbl %al,%eax
c0105b25:	29 c2                	sub    %eax,%edx
c0105b27:	89 d0                	mov    %edx,%eax
c0105b29:	eb 05                	jmp    c0105b30 <strncmp+0x5e>
c0105b2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b30:	5d                   	pop    %ebp
c0105b31:	c3                   	ret    

c0105b32 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105b32:	55                   	push   %ebp
c0105b33:	89 e5                	mov    %esp,%ebp
c0105b35:	83 ec 04             	sub    $0x4,%esp
c0105b38:	e8 75 a7 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105b3d:	05 13 2e 01 00       	add    $0x12e13,%eax
c0105b42:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b45:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105b48:	eb 14                	jmp    c0105b5e <strchr+0x2c>
        if (*s == c) {
c0105b4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b4d:	0f b6 00             	movzbl (%eax),%eax
c0105b50:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105b53:	75 05                	jne    c0105b5a <strchr+0x28>
            return (char *)s;
c0105b55:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b58:	eb 13                	jmp    c0105b6d <strchr+0x3b>
        }
        s ++;
c0105b5a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0105b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b61:	0f b6 00             	movzbl (%eax),%eax
c0105b64:	84 c0                	test   %al,%al
c0105b66:	75 e2                	jne    c0105b4a <strchr+0x18>
    }
    return NULL;
c0105b68:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b6d:	c9                   	leave  
c0105b6e:	c3                   	ret    

c0105b6f <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105b6f:	55                   	push   %ebp
c0105b70:	89 e5                	mov    %esp,%ebp
c0105b72:	83 ec 04             	sub    $0x4,%esp
c0105b75:	e8 38 a7 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105b7a:	05 d6 2d 01 00       	add    $0x12dd6,%eax
c0105b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b82:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105b85:	eb 0f                	jmp    c0105b96 <strfind+0x27>
        if (*s == c) {
c0105b87:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b8a:	0f b6 00             	movzbl (%eax),%eax
c0105b8d:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105b90:	74 10                	je     c0105ba2 <strfind+0x33>
            break;
        }
        s ++;
c0105b92:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0105b96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b99:	0f b6 00             	movzbl (%eax),%eax
c0105b9c:	84 c0                	test   %al,%al
c0105b9e:	75 e7                	jne    c0105b87 <strfind+0x18>
c0105ba0:	eb 01                	jmp    c0105ba3 <strfind+0x34>
            break;
c0105ba2:	90                   	nop
    }
    return (char *)s;
c0105ba3:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105ba6:	c9                   	leave  
c0105ba7:	c3                   	ret    

c0105ba8 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105ba8:	55                   	push   %ebp
c0105ba9:	89 e5                	mov    %esp,%ebp
c0105bab:	83 ec 10             	sub    $0x10,%esp
c0105bae:	e8 ff a6 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105bb3:	05 9d 2d 01 00       	add    $0x12d9d,%eax
    int neg = 0;
c0105bb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105bbf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105bc6:	eb 04                	jmp    c0105bcc <strtol+0x24>
        s ++;
c0105bc8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105bcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bcf:	0f b6 00             	movzbl (%eax),%eax
c0105bd2:	3c 20                	cmp    $0x20,%al
c0105bd4:	74 f2                	je     c0105bc8 <strtol+0x20>
c0105bd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd9:	0f b6 00             	movzbl (%eax),%eax
c0105bdc:	3c 09                	cmp    $0x9,%al
c0105bde:	74 e8                	je     c0105bc8 <strtol+0x20>
    }

    // plus/minus sign
    if (*s == '+') {
c0105be0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be3:	0f b6 00             	movzbl (%eax),%eax
c0105be6:	3c 2b                	cmp    $0x2b,%al
c0105be8:	75 06                	jne    c0105bf0 <strtol+0x48>
        s ++;
c0105bea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bee:	eb 15                	jmp    c0105c05 <strtol+0x5d>
    }
    else if (*s == '-') {
c0105bf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf3:	0f b6 00             	movzbl (%eax),%eax
c0105bf6:	3c 2d                	cmp    $0x2d,%al
c0105bf8:	75 0b                	jne    c0105c05 <strtol+0x5d>
        s ++, neg = 1;
c0105bfa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bfe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105c05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c09:	74 06                	je     c0105c11 <strtol+0x69>
c0105c0b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105c0f:	75 24                	jne    c0105c35 <strtol+0x8d>
c0105c11:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c14:	0f b6 00             	movzbl (%eax),%eax
c0105c17:	3c 30                	cmp    $0x30,%al
c0105c19:	75 1a                	jne    c0105c35 <strtol+0x8d>
c0105c1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1e:	83 c0 01             	add    $0x1,%eax
c0105c21:	0f b6 00             	movzbl (%eax),%eax
c0105c24:	3c 78                	cmp    $0x78,%al
c0105c26:	75 0d                	jne    c0105c35 <strtol+0x8d>
        s += 2, base = 16;
c0105c28:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105c2c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105c33:	eb 2a                	jmp    c0105c5f <strtol+0xb7>
    }
    else if (base == 0 && s[0] == '0') {
c0105c35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c39:	75 17                	jne    c0105c52 <strtol+0xaa>
c0105c3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c3e:	0f b6 00             	movzbl (%eax),%eax
c0105c41:	3c 30                	cmp    $0x30,%al
c0105c43:	75 0d                	jne    c0105c52 <strtol+0xaa>
        s ++, base = 8;
c0105c45:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c49:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105c50:	eb 0d                	jmp    c0105c5f <strtol+0xb7>
    }
    else if (base == 0) {
c0105c52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c56:	75 07                	jne    c0105c5f <strtol+0xb7>
        base = 10;
c0105c58:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105c5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c62:	0f b6 00             	movzbl (%eax),%eax
c0105c65:	3c 2f                	cmp    $0x2f,%al
c0105c67:	7e 1b                	jle    c0105c84 <strtol+0xdc>
c0105c69:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c6c:	0f b6 00             	movzbl (%eax),%eax
c0105c6f:	3c 39                	cmp    $0x39,%al
c0105c71:	7f 11                	jg     c0105c84 <strtol+0xdc>
            dig = *s - '0';
c0105c73:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c76:	0f b6 00             	movzbl (%eax),%eax
c0105c79:	0f be c0             	movsbl %al,%eax
c0105c7c:	83 e8 30             	sub    $0x30,%eax
c0105c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c82:	eb 48                	jmp    c0105ccc <strtol+0x124>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105c84:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c87:	0f b6 00             	movzbl (%eax),%eax
c0105c8a:	3c 60                	cmp    $0x60,%al
c0105c8c:	7e 1b                	jle    c0105ca9 <strtol+0x101>
c0105c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c91:	0f b6 00             	movzbl (%eax),%eax
c0105c94:	3c 7a                	cmp    $0x7a,%al
c0105c96:	7f 11                	jg     c0105ca9 <strtol+0x101>
            dig = *s - 'a' + 10;
c0105c98:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c9b:	0f b6 00             	movzbl (%eax),%eax
c0105c9e:	0f be c0             	movsbl %al,%eax
c0105ca1:	83 e8 57             	sub    $0x57,%eax
c0105ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ca7:	eb 23                	jmp    c0105ccc <strtol+0x124>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105ca9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cac:	0f b6 00             	movzbl (%eax),%eax
c0105caf:	3c 40                	cmp    $0x40,%al
c0105cb1:	7e 3c                	jle    c0105cef <strtol+0x147>
c0105cb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb6:	0f b6 00             	movzbl (%eax),%eax
c0105cb9:	3c 5a                	cmp    $0x5a,%al
c0105cbb:	7f 32                	jg     c0105cef <strtol+0x147>
            dig = *s - 'A' + 10;
c0105cbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc0:	0f b6 00             	movzbl (%eax),%eax
c0105cc3:	0f be c0             	movsbl %al,%eax
c0105cc6:	83 e8 37             	sub    $0x37,%eax
c0105cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ccf:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105cd2:	7d 1a                	jge    c0105cee <strtol+0x146>
            break;
        }
        s ++, val = (val * base) + dig;
c0105cd4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105cdb:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105cdf:	89 c2                	mov    %eax,%edx
c0105ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ce4:	01 d0                	add    %edx,%eax
c0105ce6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105ce9:	e9 71 ff ff ff       	jmp    c0105c5f <strtol+0xb7>
            break;
c0105cee:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105cef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105cf3:	74 08                	je     c0105cfd <strtol+0x155>
        *endptr = (char *) s;
c0105cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cf8:	8b 55 08             	mov    0x8(%ebp),%edx
c0105cfb:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105cfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105d01:	74 07                	je     c0105d0a <strtol+0x162>
c0105d03:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d06:	f7 d8                	neg    %eax
c0105d08:	eb 03                	jmp    c0105d0d <strtol+0x165>
c0105d0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105d0d:	c9                   	leave  
c0105d0e:	c3                   	ret    

c0105d0f <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105d0f:	55                   	push   %ebp
c0105d10:	89 e5                	mov    %esp,%ebp
c0105d12:	57                   	push   %edi
c0105d13:	83 ec 24             	sub    $0x24,%esp
c0105d16:	e8 97 a5 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105d1b:	05 35 2c 01 00       	add    $0x12c35,%eax
c0105d20:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d23:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105d26:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105d2a:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d2d:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105d30:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105d33:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d36:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105d39:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105d3c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105d40:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105d43:	89 d7                	mov    %edx,%edi
c0105d45:	f3 aa                	rep stos %al,%es:(%edi)
c0105d47:	89 fa                	mov    %edi,%edx
c0105d49:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105d4c:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105d4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d52:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105d53:	83 c4 24             	add    $0x24,%esp
c0105d56:	5f                   	pop    %edi
c0105d57:	5d                   	pop    %ebp
c0105d58:	c3                   	ret    

c0105d59 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105d59:	55                   	push   %ebp
c0105d5a:	89 e5                	mov    %esp,%ebp
c0105d5c:	57                   	push   %edi
c0105d5d:	56                   	push   %esi
c0105d5e:	53                   	push   %ebx
c0105d5f:	83 ec 30             	sub    $0x30,%esp
c0105d62:	e8 4b a5 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105d67:	05 e9 2b 01 00       	add    $0x12be9,%eax
c0105d6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d75:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d78:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d7b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d81:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105d84:	73 42                	jae    c0105dc8 <memmove+0x6f>
c0105d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105d8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105d92:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d95:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105d98:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105d9b:	c1 e8 02             	shr    $0x2,%eax
c0105d9e:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105da0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105da3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105da6:	89 d7                	mov    %edx,%edi
c0105da8:	89 c6                	mov    %eax,%esi
c0105daa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105dac:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105daf:	83 e1 03             	and    $0x3,%ecx
c0105db2:	74 02                	je     c0105db6 <memmove+0x5d>
c0105db4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105db6:	89 f0                	mov    %esi,%eax
c0105db8:	89 fa                	mov    %edi,%edx
c0105dba:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105dbd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105dc0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c0105dc6:	eb 36                	jmp    c0105dfe <memmove+0xa5>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105dc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105dcb:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105dd1:	01 c2                	add    %eax,%edx
c0105dd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105dd6:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ddc:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105ddf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105de2:	89 c1                	mov    %eax,%ecx
c0105de4:	89 d8                	mov    %ebx,%eax
c0105de6:	89 d6                	mov    %edx,%esi
c0105de8:	89 c7                	mov    %eax,%edi
c0105dea:	fd                   	std    
c0105deb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ded:	fc                   	cld    
c0105dee:	89 f8                	mov    %edi,%eax
c0105df0:	89 f2                	mov    %esi,%edx
c0105df2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105df5:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105df8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105dfe:	83 c4 30             	add    $0x30,%esp
c0105e01:	5b                   	pop    %ebx
c0105e02:	5e                   	pop    %esi
c0105e03:	5f                   	pop    %edi
c0105e04:	5d                   	pop    %ebp
c0105e05:	c3                   	ret    

c0105e06 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105e06:	55                   	push   %ebp
c0105e07:	89 e5                	mov    %esp,%ebp
c0105e09:	57                   	push   %edi
c0105e0a:	56                   	push   %esi
c0105e0b:	83 ec 20             	sub    $0x20,%esp
c0105e0e:	e8 9f a4 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105e13:	05 3d 2b 01 00       	add    $0x12b3d,%eax
c0105e18:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e21:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e24:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e27:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e2d:	c1 e8 02             	shr    $0x2,%eax
c0105e30:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105e32:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e38:	89 d7                	mov    %edx,%edi
c0105e3a:	89 c6                	mov    %eax,%esi
c0105e3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e3e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105e41:	83 e1 03             	and    $0x3,%ecx
c0105e44:	74 02                	je     c0105e48 <memcpy+0x42>
c0105e46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e48:	89 f0                	mov    %esi,%eax
c0105e4a:	89 fa                	mov    %edi,%edx
c0105e4c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105e4f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105e52:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0105e58:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105e59:	83 c4 20             	add    $0x20,%esp
c0105e5c:	5e                   	pop    %esi
c0105e5d:	5f                   	pop    %edi
c0105e5e:	5d                   	pop    %ebp
c0105e5f:	c3                   	ret    

c0105e60 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105e60:	55                   	push   %ebp
c0105e61:	89 e5                	mov    %esp,%ebp
c0105e63:	83 ec 10             	sub    $0x10,%esp
c0105e66:	e8 47 a4 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105e6b:	05 e5 2a 01 00       	add    $0x12ae5,%eax
    const char *s1 = (const char *)v1;
c0105e70:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105e76:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e79:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105e7c:	eb 30                	jmp    c0105eae <memcmp+0x4e>
        if (*s1 != *s2) {
c0105e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e81:	0f b6 10             	movzbl (%eax),%edx
c0105e84:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e87:	0f b6 00             	movzbl (%eax),%eax
c0105e8a:	38 c2                	cmp    %al,%dl
c0105e8c:	74 18                	je     c0105ea6 <memcmp+0x46>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e91:	0f b6 00             	movzbl (%eax),%eax
c0105e94:	0f b6 d0             	movzbl %al,%edx
c0105e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e9a:	0f b6 00             	movzbl (%eax),%eax
c0105e9d:	0f b6 c0             	movzbl %al,%eax
c0105ea0:	29 c2                	sub    %eax,%edx
c0105ea2:	89 d0                	mov    %edx,%eax
c0105ea4:	eb 1a                	jmp    c0105ec0 <memcmp+0x60>
        }
        s1 ++, s2 ++;
c0105ea6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105eaa:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c0105eae:	8b 45 10             	mov    0x10(%ebp),%eax
c0105eb1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105eb4:	89 55 10             	mov    %edx,0x10(%ebp)
c0105eb7:	85 c0                	test   %eax,%eax
c0105eb9:	75 c3                	jne    c0105e7e <memcmp+0x1e>
    }
    return 0;
c0105ebb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105ec0:	c9                   	leave  
c0105ec1:	c3                   	ret    

c0105ec2 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105ec2:	55                   	push   %ebp
c0105ec3:	89 e5                	mov    %esp,%ebp
c0105ec5:	53                   	push   %ebx
c0105ec6:	83 ec 34             	sub    $0x34,%esp
c0105ec9:	e8 e8 a3 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0105ece:	81 c3 82 2a 01 00    	add    $0x12a82,%ebx
c0105ed4:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ed7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105eda:	8b 45 14             	mov    0x14(%ebp),%eax
c0105edd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105ee0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105ee3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105ee6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105ee9:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105eec:	8b 45 18             	mov    0x18(%ebp),%eax
c0105eef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105ef2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ef5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105ef8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105efb:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105f08:	74 1c                	je     c0105f26 <printnum+0x64>
c0105f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f0d:	ba 00 00 00 00       	mov    $0x0,%edx
c0105f12:	f7 75 e4             	divl   -0x1c(%ebp)
c0105f15:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f1b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105f20:	f7 75 e4             	divl   -0x1c(%ebp)
c0105f23:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f26:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f29:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f2c:	f7 75 e4             	divl   -0x1c(%ebp)
c0105f2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105f32:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105f35:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f38:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105f3b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105f3e:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105f41:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f44:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105f47:	8b 45 18             	mov    0x18(%ebp),%eax
c0105f4a:	ba 00 00 00 00       	mov    $0x0,%edx
c0105f4f:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0105f52:	72 41                	jb     c0105f95 <printnum+0xd3>
c0105f54:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0105f57:	77 05                	ja     c0105f5e <printnum+0x9c>
c0105f59:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105f5c:	72 37                	jb     c0105f95 <printnum+0xd3>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105f5e:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105f61:	83 e8 01             	sub    $0x1,%eax
c0105f64:	83 ec 04             	sub    $0x4,%esp
c0105f67:	ff 75 20             	pushl  0x20(%ebp)
c0105f6a:	50                   	push   %eax
c0105f6b:	ff 75 18             	pushl  0x18(%ebp)
c0105f6e:	ff 75 ec             	pushl  -0x14(%ebp)
c0105f71:	ff 75 e8             	pushl  -0x18(%ebp)
c0105f74:	ff 75 0c             	pushl  0xc(%ebp)
c0105f77:	ff 75 08             	pushl  0x8(%ebp)
c0105f7a:	e8 43 ff ff ff       	call   c0105ec2 <printnum>
c0105f7f:	83 c4 20             	add    $0x20,%esp
c0105f82:	eb 1b                	jmp    c0105f9f <printnum+0xdd>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105f84:	83 ec 08             	sub    $0x8,%esp
c0105f87:	ff 75 0c             	pushl  0xc(%ebp)
c0105f8a:	ff 75 20             	pushl  0x20(%ebp)
c0105f8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f90:	ff d0                	call   *%eax
c0105f92:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
c0105f95:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105f99:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105f9d:	7f e5                	jg     c0105f84 <printnum+0xc2>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105f9f:	8d 93 f2 ec fe ff    	lea    -0x1130e(%ebx),%edx
c0105fa5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105fa8:	01 d0                	add    %edx,%eax
c0105faa:	0f b6 00             	movzbl (%eax),%eax
c0105fad:	0f be c0             	movsbl %al,%eax
c0105fb0:	83 ec 08             	sub    $0x8,%esp
c0105fb3:	ff 75 0c             	pushl  0xc(%ebp)
c0105fb6:	50                   	push   %eax
c0105fb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fba:	ff d0                	call   *%eax
c0105fbc:	83 c4 10             	add    $0x10,%esp
}
c0105fbf:	90                   	nop
c0105fc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0105fc3:	c9                   	leave  
c0105fc4:	c3                   	ret    

c0105fc5 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105fc5:	55                   	push   %ebp
c0105fc6:	89 e5                	mov    %esp,%ebp
c0105fc8:	e8 e5 a2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105fcd:	05 83 29 01 00       	add    $0x12983,%eax
    if (lflag >= 2) {
c0105fd2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105fd6:	7e 14                	jle    c0105fec <getuint+0x27>
        return va_arg(*ap, unsigned long long);
c0105fd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fdb:	8b 00                	mov    (%eax),%eax
c0105fdd:	8d 48 08             	lea    0x8(%eax),%ecx
c0105fe0:	8b 55 08             	mov    0x8(%ebp),%edx
c0105fe3:	89 0a                	mov    %ecx,(%edx)
c0105fe5:	8b 50 04             	mov    0x4(%eax),%edx
c0105fe8:	8b 00                	mov    (%eax),%eax
c0105fea:	eb 30                	jmp    c010601c <getuint+0x57>
    }
    else if (lflag) {
c0105fec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105ff0:	74 16                	je     c0106008 <getuint+0x43>
        return va_arg(*ap, unsigned long);
c0105ff2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ff5:	8b 00                	mov    (%eax),%eax
c0105ff7:	8d 48 04             	lea    0x4(%eax),%ecx
c0105ffa:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ffd:	89 0a                	mov    %ecx,(%edx)
c0105fff:	8b 00                	mov    (%eax),%eax
c0106001:	ba 00 00 00 00       	mov    $0x0,%edx
c0106006:	eb 14                	jmp    c010601c <getuint+0x57>
    }
    else {
        return va_arg(*ap, unsigned int);
c0106008:	8b 45 08             	mov    0x8(%ebp),%eax
c010600b:	8b 00                	mov    (%eax),%eax
c010600d:	8d 48 04             	lea    0x4(%eax),%ecx
c0106010:	8b 55 08             	mov    0x8(%ebp),%edx
c0106013:	89 0a                	mov    %ecx,(%edx)
c0106015:	8b 00                	mov    (%eax),%eax
c0106017:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010601c:	5d                   	pop    %ebp
c010601d:	c3                   	ret    

c010601e <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010601e:	55                   	push   %ebp
c010601f:	89 e5                	mov    %esp,%ebp
c0106021:	e8 8c a2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0106026:	05 2a 29 01 00       	add    $0x1292a,%eax
    if (lflag >= 2) {
c010602b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010602f:	7e 14                	jle    c0106045 <getint+0x27>
        return va_arg(*ap, long long);
c0106031:	8b 45 08             	mov    0x8(%ebp),%eax
c0106034:	8b 00                	mov    (%eax),%eax
c0106036:	8d 48 08             	lea    0x8(%eax),%ecx
c0106039:	8b 55 08             	mov    0x8(%ebp),%edx
c010603c:	89 0a                	mov    %ecx,(%edx)
c010603e:	8b 50 04             	mov    0x4(%eax),%edx
c0106041:	8b 00                	mov    (%eax),%eax
c0106043:	eb 28                	jmp    c010606d <getint+0x4f>
    }
    else if (lflag) {
c0106045:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106049:	74 12                	je     c010605d <getint+0x3f>
        return va_arg(*ap, long);
c010604b:	8b 45 08             	mov    0x8(%ebp),%eax
c010604e:	8b 00                	mov    (%eax),%eax
c0106050:	8d 48 04             	lea    0x4(%eax),%ecx
c0106053:	8b 55 08             	mov    0x8(%ebp),%edx
c0106056:	89 0a                	mov    %ecx,(%edx)
c0106058:	8b 00                	mov    (%eax),%eax
c010605a:	99                   	cltd   
c010605b:	eb 10                	jmp    c010606d <getint+0x4f>
    }
    else {
        return va_arg(*ap, int);
c010605d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106060:	8b 00                	mov    (%eax),%eax
c0106062:	8d 48 04             	lea    0x4(%eax),%ecx
c0106065:	8b 55 08             	mov    0x8(%ebp),%edx
c0106068:	89 0a                	mov    %ecx,(%edx)
c010606a:	8b 00                	mov    (%eax),%eax
c010606c:	99                   	cltd   
    }
}
c010606d:	5d                   	pop    %ebp
c010606e:	c3                   	ret    

c010606f <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010606f:	55                   	push   %ebp
c0106070:	89 e5                	mov    %esp,%ebp
c0106072:	83 ec 18             	sub    $0x18,%esp
c0106075:	e8 38 a2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010607a:	05 d6 28 01 00       	add    $0x128d6,%eax
    va_list ap;

    va_start(ap, fmt);
c010607f:	8d 45 14             	lea    0x14(%ebp),%eax
c0106082:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0106085:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106088:	50                   	push   %eax
c0106089:	ff 75 10             	pushl  0x10(%ebp)
c010608c:	ff 75 0c             	pushl  0xc(%ebp)
c010608f:	ff 75 08             	pushl  0x8(%ebp)
c0106092:	e8 06 00 00 00       	call   c010609d <vprintfmt>
c0106097:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c010609a:	90                   	nop
c010609b:	c9                   	leave  
c010609c:	c3                   	ret    

c010609d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010609d:	55                   	push   %ebp
c010609e:	89 e5                	mov    %esp,%ebp
c01060a0:	57                   	push   %edi
c01060a1:	56                   	push   %esi
c01060a2:	53                   	push   %ebx
c01060a3:	83 ec 2c             	sub    $0x2c,%esp
c01060a6:	e8 8c 04 00 00       	call   c0106537 <__x86.get_pc_thunk.di>
c01060ab:	81 c7 a5 28 01 00    	add    $0x128a5,%edi
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01060b1:	eb 17                	jmp    c01060ca <vprintfmt+0x2d>
            if (ch == '\0') {
c01060b3:	85 db                	test   %ebx,%ebx
c01060b5:	0f 84 9a 03 00 00    	je     c0106455 <.L24+0x2d>
                return;
            }
            putch(ch, putdat);
c01060bb:	83 ec 08             	sub    $0x8,%esp
c01060be:	ff 75 0c             	pushl  0xc(%ebp)
c01060c1:	53                   	push   %ebx
c01060c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01060c5:	ff d0                	call   *%eax
c01060c7:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01060ca:	8b 45 10             	mov    0x10(%ebp),%eax
c01060cd:	8d 50 01             	lea    0x1(%eax),%edx
c01060d0:	89 55 10             	mov    %edx,0x10(%ebp)
c01060d3:	0f b6 00             	movzbl (%eax),%eax
c01060d6:	0f b6 d8             	movzbl %al,%ebx
c01060d9:	83 fb 25             	cmp    $0x25,%ebx
c01060dc:	75 d5                	jne    c01060b3 <vprintfmt+0x16>
        }

        // Process a %-escape sequence
        char padc = ' ';
c01060de:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
        width = precision = -1;
c01060e2:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
c01060e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01060ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
        lflag = altflag = 0;
c01060ef:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
c01060f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01060f9:	89 45 d0             	mov    %eax,-0x30(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01060fc:	8b 45 10             	mov    0x10(%ebp),%eax
c01060ff:	8d 50 01             	lea    0x1(%eax),%edx
c0106102:	89 55 10             	mov    %edx,0x10(%ebp)
c0106105:	0f b6 00             	movzbl (%eax),%eax
c0106108:	0f b6 d8             	movzbl %al,%ebx
c010610b:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010610e:	83 f8 55             	cmp    $0x55,%eax
c0106111:	0f 87 11 03 00 00    	ja     c0106428 <.L24>
c0106117:	c1 e0 02             	shl    $0x2,%eax
c010611a:	8b 84 38 18 ed fe ff 	mov    -0x112e8(%eax,%edi,1),%eax
c0106121:	01 f8                	add    %edi,%eax
c0106123:	ff e0                	jmp    *%eax

c0106125 <.L29>:

        // flag to pad on the right
        case '-':
            padc = '-';
c0106125:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
            goto reswitch;
c0106129:	eb d1                	jmp    c01060fc <vprintfmt+0x5f>

c010612b <.L31>:

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010612b:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
            goto reswitch;
c010612f:	eb cb                	jmp    c01060fc <vprintfmt+0x5f>

c0106131 <.L32>:

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0106131:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
                precision = precision * 10 + ch - '0';
c0106138:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010613b:	89 d0                	mov    %edx,%eax
c010613d:	c1 e0 02             	shl    $0x2,%eax
c0106140:	01 d0                	add    %edx,%eax
c0106142:	01 c0                	add    %eax,%eax
c0106144:	01 d8                	add    %ebx,%eax
c0106146:	83 e8 30             	sub    $0x30,%eax
c0106149:	89 45 d4             	mov    %eax,-0x2c(%ebp)
                ch = *fmt;
c010614c:	8b 45 10             	mov    0x10(%ebp),%eax
c010614f:	0f b6 00             	movzbl (%eax),%eax
c0106152:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0106155:	83 fb 2f             	cmp    $0x2f,%ebx
c0106158:	7e 39                	jle    c0106193 <.L25+0xc>
c010615a:	83 fb 39             	cmp    $0x39,%ebx
c010615d:	7f 34                	jg     c0106193 <.L25+0xc>
            for (precision = 0; ; ++ fmt) {
c010615f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0106163:	eb d3                	jmp    c0106138 <.L32+0x7>

c0106165 <.L28>:
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0106165:	8b 45 14             	mov    0x14(%ebp),%eax
c0106168:	8d 50 04             	lea    0x4(%eax),%edx
c010616b:	89 55 14             	mov    %edx,0x14(%ebp)
c010616e:	8b 00                	mov    (%eax),%eax
c0106170:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            goto process_precision;
c0106173:	eb 1f                	jmp    c0106194 <.L25+0xd>

c0106175 <.L30>:

        case '.':
            if (width < 0)
c0106175:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106179:	79 81                	jns    c01060fc <vprintfmt+0x5f>
                width = 0;
c010617b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
            goto reswitch;
c0106182:	e9 75 ff ff ff       	jmp    c01060fc <vprintfmt+0x5f>

c0106187 <.L25>:

        case '#':
            altflag = 1;
c0106187:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
            goto reswitch;
c010618e:	e9 69 ff ff ff       	jmp    c01060fc <vprintfmt+0x5f>
            goto process_precision;
c0106193:	90                   	nop

        process_precision:
            if (width < 0)
c0106194:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106198:	0f 89 5e ff ff ff    	jns    c01060fc <vprintfmt+0x5f>
                width = precision, precision = -1;
c010619e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01061a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01061a4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
            goto reswitch;
c01061ab:	e9 4c ff ff ff       	jmp    c01060fc <vprintfmt+0x5f>

c01061b0 <.L36>:

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01061b0:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
            goto reswitch;
c01061b4:	e9 43 ff ff ff       	jmp    c01060fc <vprintfmt+0x5f>

c01061b9 <.L33>:

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01061b9:	8b 45 14             	mov    0x14(%ebp),%eax
c01061bc:	8d 50 04             	lea    0x4(%eax),%edx
c01061bf:	89 55 14             	mov    %edx,0x14(%ebp)
c01061c2:	8b 00                	mov    (%eax),%eax
c01061c4:	83 ec 08             	sub    $0x8,%esp
c01061c7:	ff 75 0c             	pushl  0xc(%ebp)
c01061ca:	50                   	push   %eax
c01061cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01061ce:	ff d0                	call   *%eax
c01061d0:	83 c4 10             	add    $0x10,%esp
            break;
c01061d3:	e9 78 02 00 00       	jmp    c0106450 <.L24+0x28>

c01061d8 <.L35>:

        // error message
        case 'e':
            err = va_arg(ap, int);
c01061d8:	8b 45 14             	mov    0x14(%ebp),%eax
c01061db:	8d 50 04             	lea    0x4(%eax),%edx
c01061de:	89 55 14             	mov    %edx,0x14(%ebp)
c01061e1:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01061e3:	85 db                	test   %ebx,%ebx
c01061e5:	79 02                	jns    c01061e9 <.L35+0x11>
                err = -err;
c01061e7:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01061e9:	83 fb 06             	cmp    $0x6,%ebx
c01061ec:	7f 0b                	jg     c01061f9 <.L35+0x21>
c01061ee:	8b b4 9f 5c 01 00 00 	mov    0x15c(%edi,%ebx,4),%esi
c01061f5:	85 f6                	test   %esi,%esi
c01061f7:	75 1b                	jne    c0106214 <.L35+0x3c>
                printfmt(putch, putdat, "error %d", err);
c01061f9:	53                   	push   %ebx
c01061fa:	8d 87 03 ed fe ff    	lea    -0x112fd(%edi),%eax
c0106200:	50                   	push   %eax
c0106201:	ff 75 0c             	pushl  0xc(%ebp)
c0106204:	ff 75 08             	pushl  0x8(%ebp)
c0106207:	e8 63 fe ff ff       	call   c010606f <printfmt>
c010620c:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010620f:	e9 3c 02 00 00       	jmp    c0106450 <.L24+0x28>
                printfmt(putch, putdat, "%s", p);
c0106214:	56                   	push   %esi
c0106215:	8d 87 0c ed fe ff    	lea    -0x112f4(%edi),%eax
c010621b:	50                   	push   %eax
c010621c:	ff 75 0c             	pushl  0xc(%ebp)
c010621f:	ff 75 08             	pushl  0x8(%ebp)
c0106222:	e8 48 fe ff ff       	call   c010606f <printfmt>
c0106227:	83 c4 10             	add    $0x10,%esp
            break;
c010622a:	e9 21 02 00 00       	jmp    c0106450 <.L24+0x28>

c010622f <.L39>:

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010622f:	8b 45 14             	mov    0x14(%ebp),%eax
c0106232:	8d 50 04             	lea    0x4(%eax),%edx
c0106235:	89 55 14             	mov    %edx,0x14(%ebp)
c0106238:	8b 30                	mov    (%eax),%esi
c010623a:	85 f6                	test   %esi,%esi
c010623c:	75 06                	jne    c0106244 <.L39+0x15>
                p = "(null)";
c010623e:	8d b7 0f ed fe ff    	lea    -0x112f1(%edi),%esi
            }
            if (width > 0 && padc != '-') {
c0106244:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106248:	7e 78                	jle    c01062c2 <.L39+0x93>
c010624a:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
c010624e:	74 72                	je     c01062c2 <.L39+0x93>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106250:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106253:	83 ec 08             	sub    $0x8,%esp
c0106256:	50                   	push   %eax
c0106257:	56                   	push   %esi
c0106258:	89 fb                	mov    %edi,%ebx
c010625a:	e8 57 f7 ff ff       	call   c01059b6 <strnlen>
c010625f:	83 c4 10             	add    $0x10,%esp
c0106262:	89 c2                	mov    %eax,%edx
c0106264:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106267:	29 d0                	sub    %edx,%eax
c0106269:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010626c:	eb 17                	jmp    c0106285 <.L39+0x56>
                    putch(padc, putdat);
c010626e:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
c0106272:	83 ec 08             	sub    $0x8,%esp
c0106275:	ff 75 0c             	pushl  0xc(%ebp)
c0106278:	50                   	push   %eax
c0106279:	8b 45 08             	mov    0x8(%ebp),%eax
c010627c:	ff d0                	call   *%eax
c010627e:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106281:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
c0106285:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106289:	7f e3                	jg     c010626e <.L39+0x3f>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010628b:	eb 35                	jmp    c01062c2 <.L39+0x93>
                if (altflag && (ch < ' ' || ch > '~')) {
c010628d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106291:	74 1c                	je     c01062af <.L39+0x80>
c0106293:	83 fb 1f             	cmp    $0x1f,%ebx
c0106296:	7e 05                	jle    c010629d <.L39+0x6e>
c0106298:	83 fb 7e             	cmp    $0x7e,%ebx
c010629b:	7e 12                	jle    c01062af <.L39+0x80>
                    putch('?', putdat);
c010629d:	83 ec 08             	sub    $0x8,%esp
c01062a0:	ff 75 0c             	pushl  0xc(%ebp)
c01062a3:	6a 3f                	push   $0x3f
c01062a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01062a8:	ff d0                	call   *%eax
c01062aa:	83 c4 10             	add    $0x10,%esp
c01062ad:	eb 0f                	jmp    c01062be <.L39+0x8f>
                }
                else {
                    putch(ch, putdat);
c01062af:	83 ec 08             	sub    $0x8,%esp
c01062b2:	ff 75 0c             	pushl  0xc(%ebp)
c01062b5:	53                   	push   %ebx
c01062b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01062b9:	ff d0                	call   *%eax
c01062bb:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01062be:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
c01062c2:	89 f0                	mov    %esi,%eax
c01062c4:	8d 70 01             	lea    0x1(%eax),%esi
c01062c7:	0f b6 00             	movzbl (%eax),%eax
c01062ca:	0f be d8             	movsbl %al,%ebx
c01062cd:	85 db                	test   %ebx,%ebx
c01062cf:	74 26                	je     c01062f7 <.L39+0xc8>
c01062d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01062d5:	78 b6                	js     c010628d <.L39+0x5e>
c01062d7:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
c01062db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01062df:	79 ac                	jns    c010628d <.L39+0x5e>
                }
            }
            for (; width > 0; width --) {
c01062e1:	eb 14                	jmp    c01062f7 <.L39+0xc8>
                putch(' ', putdat);
c01062e3:	83 ec 08             	sub    $0x8,%esp
c01062e6:	ff 75 0c             	pushl  0xc(%ebp)
c01062e9:	6a 20                	push   $0x20
c01062eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01062ee:	ff d0                	call   *%eax
c01062f0:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
c01062f3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
c01062f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01062fb:	7f e6                	jg     c01062e3 <.L39+0xb4>
            }
            break;
c01062fd:	e9 4e 01 00 00       	jmp    c0106450 <.L24+0x28>

c0106302 <.L34>:

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0106302:	83 ec 08             	sub    $0x8,%esp
c0106305:	ff 75 d0             	pushl  -0x30(%ebp)
c0106308:	8d 45 14             	lea    0x14(%ebp),%eax
c010630b:	50                   	push   %eax
c010630c:	e8 0d fd ff ff       	call   c010601e <getint>
c0106311:	83 c4 10             	add    $0x10,%esp
c0106314:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106317:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            if ((long long)num < 0) {
c010631a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010631d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106320:	85 d2                	test   %edx,%edx
c0106322:	79 23                	jns    c0106347 <.L34+0x45>
                putch('-', putdat);
c0106324:	83 ec 08             	sub    $0x8,%esp
c0106327:	ff 75 0c             	pushl  0xc(%ebp)
c010632a:	6a 2d                	push   $0x2d
c010632c:	8b 45 08             	mov    0x8(%ebp),%eax
c010632f:	ff d0                	call   *%eax
c0106331:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0106334:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106337:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010633a:	f7 d8                	neg    %eax
c010633c:	83 d2 00             	adc    $0x0,%edx
c010633f:	f7 da                	neg    %edx
c0106341:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106344:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            }
            base = 10;
c0106347:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
c010634e:	e9 9f 00 00 00       	jmp    c01063f2 <.L41+0x1f>

c0106353 <.L40>:

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0106353:	83 ec 08             	sub    $0x8,%esp
c0106356:	ff 75 d0             	pushl  -0x30(%ebp)
c0106359:	8d 45 14             	lea    0x14(%ebp),%eax
c010635c:	50                   	push   %eax
c010635d:	e8 63 fc ff ff       	call   c0105fc5 <getuint>
c0106362:	83 c4 10             	add    $0x10,%esp
c0106365:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106368:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 10;
c010636b:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
c0106372:	eb 7e                	jmp    c01063f2 <.L41+0x1f>

c0106374 <.L37>:

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0106374:	83 ec 08             	sub    $0x8,%esp
c0106377:	ff 75 d0             	pushl  -0x30(%ebp)
c010637a:	8d 45 14             	lea    0x14(%ebp),%eax
c010637d:	50                   	push   %eax
c010637e:	e8 42 fc ff ff       	call   c0105fc5 <getuint>
c0106383:	83 c4 10             	add    $0x10,%esp
c0106386:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106389:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 8;
c010638c:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
            goto number;
c0106393:	eb 5d                	jmp    c01063f2 <.L41+0x1f>

c0106395 <.L38>:

        // pointer
        case 'p':
            putch('0', putdat);
c0106395:	83 ec 08             	sub    $0x8,%esp
c0106398:	ff 75 0c             	pushl  0xc(%ebp)
c010639b:	6a 30                	push   $0x30
c010639d:	8b 45 08             	mov    0x8(%ebp),%eax
c01063a0:	ff d0                	call   *%eax
c01063a2:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c01063a5:	83 ec 08             	sub    $0x8,%esp
c01063a8:	ff 75 0c             	pushl  0xc(%ebp)
c01063ab:	6a 78                	push   $0x78
c01063ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01063b0:	ff d0                	call   *%eax
c01063b2:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01063b5:	8b 45 14             	mov    0x14(%ebp),%eax
c01063b8:	8d 50 04             	lea    0x4(%eax),%edx
c01063bb:	89 55 14             	mov    %edx,0x14(%ebp)
c01063be:	8b 00                	mov    (%eax),%eax
c01063c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01063c3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            base = 16;
c01063ca:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
            goto number;
c01063d1:	eb 1f                	jmp    c01063f2 <.L41+0x1f>

c01063d3 <.L41>:

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01063d3:	83 ec 08             	sub    $0x8,%esp
c01063d6:	ff 75 d0             	pushl  -0x30(%ebp)
c01063d9:	8d 45 14             	lea    0x14(%ebp),%eax
c01063dc:	50                   	push   %eax
c01063dd:	e8 e3 fb ff ff       	call   c0105fc5 <getuint>
c01063e2:	83 c4 10             	add    $0x10,%esp
c01063e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01063e8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 16;
c01063eb:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01063f2:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
c01063f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01063f9:	83 ec 04             	sub    $0x4,%esp
c01063fc:	52                   	push   %edx
c01063fd:	ff 75 d8             	pushl  -0x28(%ebp)
c0106400:	50                   	push   %eax
c0106401:	ff 75 e4             	pushl  -0x1c(%ebp)
c0106404:	ff 75 e0             	pushl  -0x20(%ebp)
c0106407:	ff 75 0c             	pushl  0xc(%ebp)
c010640a:	ff 75 08             	pushl  0x8(%ebp)
c010640d:	e8 b0 fa ff ff       	call   c0105ec2 <printnum>
c0106412:	83 c4 20             	add    $0x20,%esp
            break;
c0106415:	eb 39                	jmp    c0106450 <.L24+0x28>

c0106417 <.L27>:

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0106417:	83 ec 08             	sub    $0x8,%esp
c010641a:	ff 75 0c             	pushl  0xc(%ebp)
c010641d:	53                   	push   %ebx
c010641e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106421:	ff d0                	call   *%eax
c0106423:	83 c4 10             	add    $0x10,%esp
            break;
c0106426:	eb 28                	jmp    c0106450 <.L24+0x28>

c0106428 <.L24>:

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0106428:	83 ec 08             	sub    $0x8,%esp
c010642b:	ff 75 0c             	pushl  0xc(%ebp)
c010642e:	6a 25                	push   $0x25
c0106430:	8b 45 08             	mov    0x8(%ebp),%eax
c0106433:	ff d0                	call   *%eax
c0106435:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0106438:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010643c:	eb 04                	jmp    c0106442 <.L24+0x1a>
c010643e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106442:	8b 45 10             	mov    0x10(%ebp),%eax
c0106445:	83 e8 01             	sub    $0x1,%eax
c0106448:	0f b6 00             	movzbl (%eax),%eax
c010644b:	3c 25                	cmp    $0x25,%al
c010644d:	75 ef                	jne    c010643e <.L24+0x16>
                /* do nothing */;
            break;
c010644f:	90                   	nop
    while (1) {
c0106450:	e9 5c fc ff ff       	jmp    c01060b1 <vprintfmt+0x14>
                return;
c0106455:	90                   	nop
        }
    }
}
c0106456:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0106459:	5b                   	pop    %ebx
c010645a:	5e                   	pop    %esi
c010645b:	5f                   	pop    %edi
c010645c:	5d                   	pop    %ebp
c010645d:	c3                   	ret    

c010645e <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010645e:	55                   	push   %ebp
c010645f:	89 e5                	mov    %esp,%ebp
c0106461:	e8 4c 9e ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0106466:	05 ea 24 01 00       	add    $0x124ea,%eax
    b->cnt ++;
c010646b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010646e:	8b 40 08             	mov    0x8(%eax),%eax
c0106471:	8d 50 01             	lea    0x1(%eax),%edx
c0106474:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106477:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010647a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010647d:	8b 10                	mov    (%eax),%edx
c010647f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106482:	8b 40 04             	mov    0x4(%eax),%eax
c0106485:	39 c2                	cmp    %eax,%edx
c0106487:	73 12                	jae    c010649b <sprintputch+0x3d>
        *b->buf ++ = ch;
c0106489:	8b 45 0c             	mov    0xc(%ebp),%eax
c010648c:	8b 00                	mov    (%eax),%eax
c010648e:	8d 48 01             	lea    0x1(%eax),%ecx
c0106491:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106494:	89 0a                	mov    %ecx,(%edx)
c0106496:	8b 55 08             	mov    0x8(%ebp),%edx
c0106499:	88 10                	mov    %dl,(%eax)
    }
}
c010649b:	90                   	nop
c010649c:	5d                   	pop    %ebp
c010649d:	c3                   	ret    

c010649e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010649e:	55                   	push   %ebp
c010649f:	89 e5                	mov    %esp,%ebp
c01064a1:	83 ec 18             	sub    $0x18,%esp
c01064a4:	e8 09 9e ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01064a9:	05 a7 24 01 00       	add    $0x124a7,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01064ae:	8d 45 14             	lea    0x14(%ebp),%eax
c01064b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01064b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01064b7:	50                   	push   %eax
c01064b8:	ff 75 10             	pushl  0x10(%ebp)
c01064bb:	ff 75 0c             	pushl  0xc(%ebp)
c01064be:	ff 75 08             	pushl  0x8(%ebp)
c01064c1:	e8 0b 00 00 00       	call   c01064d1 <vsnprintf>
c01064c6:	83 c4 10             	add    $0x10,%esp
c01064c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01064cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01064cf:	c9                   	leave  
c01064d0:	c3                   	ret    

c01064d1 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01064d1:	55                   	push   %ebp
c01064d2:	89 e5                	mov    %esp,%ebp
c01064d4:	83 ec 18             	sub    $0x18,%esp
c01064d7:	e8 d6 9d ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01064dc:	05 74 24 01 00       	add    $0x12474,%eax
    struct sprintbuf b = {str, str + size - 1, 0};
c01064e1:	8b 55 08             	mov    0x8(%ebp),%edx
c01064e4:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01064e7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01064ea:	8d 4a ff             	lea    -0x1(%edx),%ecx
c01064ed:	8b 55 08             	mov    0x8(%ebp),%edx
c01064f0:	01 ca                	add    %ecx,%edx
c01064f2:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01064f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01064fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106500:	74 0a                	je     c010650c <vsnprintf+0x3b>
c0106502:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0106505:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106508:	39 d1                	cmp    %edx,%ecx
c010650a:	76 07                	jbe    c0106513 <vsnprintf+0x42>
        return -E_INVAL;
c010650c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0106511:	eb 22                	jmp    c0106535 <vsnprintf+0x64>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0106513:	ff 75 14             	pushl  0x14(%ebp)
c0106516:	ff 75 10             	pushl  0x10(%ebp)
c0106519:	8d 55 ec             	lea    -0x14(%ebp),%edx
c010651c:	52                   	push   %edx
c010651d:	8d 80 0e db fe ff    	lea    -0x124f2(%eax),%eax
c0106523:	50                   	push   %eax
c0106524:	e8 74 fb ff ff       	call   c010609d <vprintfmt>
c0106529:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c010652c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010652f:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0106532:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106535:	c9                   	leave  
c0106536:	c3                   	ret    

c0106537 <__x86.get_pc_thunk.di>:
c0106537:	8b 3c 24             	mov    (%esp),%edi
c010653a:	c3                   	ret    
