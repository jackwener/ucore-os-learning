
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
void grade_backtrace(void);
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
c0100048:	c7 c0 88 bf 11 c0    	mov    $0xc011bf88,%eax
c010004e:	89 c2                	mov    %eax,%edx
c0100050:	c7 c0 00 b0 11 c0    	mov    $0xc011b000,%eax
c0100056:	29 c2                	sub    %eax,%edx
c0100058:	89 d0                	mov    %edx,%eax
c010005a:	83 ec 04             	sub    $0x4,%esp
c010005d:	50                   	push   %eax
c010005e:	6a 00                	push   $0x0
c0100060:	c7 c0 00 b0 11 c0    	mov    $0xc011b000,%eax
c0100066:	50                   	push   %eax
c0100067:	e8 48 5e 00 00       	call   c0105eb4 <memset>
c010006c:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c010006f:	e8 96 18 00 00       	call   c010190a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100074:	8d 83 90 dd fe ff    	lea    -0x12270(%ebx),%eax
c010007a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010007d:	83 ec 08             	sub    $0x8,%esp
c0100080:	ff 75 f4             	pushl  -0xc(%ebp)
c0100083:	8d 83 ac dd fe ff    	lea    -0x12254(%ebx),%eax
c0100089:	50                   	push   %eax
c010008a:	e8 9a 02 00 00       	call   c0100329 <cprintf>
c010008f:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100092:	e8 d1 09 00 00       	call   c0100a68 <print_kerninfo>

    grade_backtrace();
c0100097:	e8 98 00 00 00       	call   c0100134 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010009c:	e8 14 38 00 00       	call   c01038b5 <pmm_init>

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
c0100195:	8d 83 b1 dd fe ff    	lea    -0x1224f(%ebx),%eax
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
c01001b6:	8d 83 bf dd fe ff    	lea    -0x12241(%ebx),%eax
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
c01001d7:	8d 83 cd dd fe ff    	lea    -0x12233(%ebx),%eax
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
c01001f8:	8d 83 db dd fe ff    	lea    -0x12225(%ebx),%eax
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
c0100219:	8d 83 e9 dd fe ff    	lea    -0x12217(%ebx),%eax
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
c0100277:	8d 83 f8 dd fe ff    	lea    -0x12208(%ebx),%eax
c010027d:	50                   	push   %eax
c010027e:	e8 a6 00 00 00       	call   c0100329 <cprintf>
c0100283:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c0100286:	e8 b2 ff ff ff       	call   c010023d <lab1_switch_to_user>
    lab1_print_cur_status();
c010028b:	e8 d0 fe ff ff       	call   c0100160 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100290:	83 ec 0c             	sub    $0xc,%esp
c0100293:	8d 83 18 de fe ff    	lea    -0x121e8(%ebx),%eax
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
c0100319:	e8 24 5f 00 00       	call   c0106242 <vprintfmt>
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
c010041f:	8d 83 37 de fe ff    	lea    -0x121c9(%ebx),%eax
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
c010050e:	8d 83 3a de fe ff    	lea    -0x121c6(%ebx),%eax
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
c0100532:	8d 83 56 de fe ff    	lea    -0x121aa(%ebx),%eax
c0100538:	50                   	push   %eax
c0100539:	e8 eb fd ff ff       	call   c0100329 <cprintf>
c010053e:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
c0100541:	83 ec 0c             	sub    $0xc,%esp
c0100544:	8d 83 58 de fe ff    	lea    -0x121a8(%ebx),%eax
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
c0100590:	8d 83 6a de fe ff    	lea    -0x12196(%ebx),%eax
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
c01005b4:	8d 83 56 de fe ff    	lea    -0x121aa(%ebx),%eax
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
c0100754:	8d 93 88 de fe ff    	lea    -0x12178(%ebx),%edx
c010075a:	89 10                	mov    %edx,(%eax)
    info->eip_line = 0;
c010075c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100766:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100769:	8d 93 88 de fe ff    	lea    -0x12178(%ebx),%edx
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
c010078f:	c7 c0 3c 79 10 c0    	mov    $0xc010793c,%eax
c0100795:	89 45 f4             	mov    %eax,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100798:	c7 c0 e0 2b 11 c0    	mov    $0xc0112be0,%eax
c010079e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01007a1:	c7 c0 e1 2b 11 c0    	mov    $0xc0112be1,%eax
c01007a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01007aa:	c7 c0 02 57 11 c0    	mov    $0xc0115702,%eax
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
c01008e6:	e8 29 54 00 00       	call   c0105d14 <strfind>
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
c0100a7d:	8d 83 92 de fe ff    	lea    -0x1216e(%ebx),%eax
c0100a83:	50                   	push   %eax
c0100a84:	e8 a0 f8 ff ff       	call   c0100329 <cprintf>
c0100a89:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100a8c:	83 ec 08             	sub    $0x8,%esp
c0100a8f:	c7 c0 36 00 10 c0    	mov    $0xc0100036,%eax
c0100a95:	50                   	push   %eax
c0100a96:	8d 83 ab de fe ff    	lea    -0x12155(%ebx),%eax
c0100a9c:	50                   	push   %eax
c0100a9d:	e8 87 f8 ff ff       	call   c0100329 <cprintf>
c0100aa2:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100aa5:	83 ec 08             	sub    $0x8,%esp
c0100aa8:	c7 c0 e0 66 10 c0    	mov    $0xc01066e0,%eax
c0100aae:	50                   	push   %eax
c0100aaf:	8d 83 c3 de fe ff    	lea    -0x1213d(%ebx),%eax
c0100ab5:	50                   	push   %eax
c0100ab6:	e8 6e f8 ff ff       	call   c0100329 <cprintf>
c0100abb:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100abe:	83 ec 08             	sub    $0x8,%esp
c0100ac1:	c7 c0 00 b0 11 c0    	mov    $0xc011b000,%eax
c0100ac7:	50                   	push   %eax
c0100ac8:	8d 83 db de fe ff    	lea    -0x12125(%ebx),%eax
c0100ace:	50                   	push   %eax
c0100acf:	e8 55 f8 ff ff       	call   c0100329 <cprintf>
c0100ad4:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100ad7:	83 ec 08             	sub    $0x8,%esp
c0100ada:	c7 c0 88 bf 11 c0    	mov    $0xc011bf88,%eax
c0100ae0:	50                   	push   %eax
c0100ae1:	8d 83 f3 de fe ff    	lea    -0x1210d(%ebx),%eax
c0100ae7:	50                   	push   %eax
c0100ae8:	e8 3c f8 ff ff       	call   c0100329 <cprintf>
c0100aed:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c0100af0:	c7 c0 88 bf 11 c0    	mov    $0xc011bf88,%eax
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
c0100b18:	8d 83 0c df fe ff    	lea    -0x120f4(%ebx),%eax
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
c0100b5e:	8d 83 36 df fe ff    	lea    -0x120ca(%ebx),%eax
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
c0100bc7:	8d 83 52 df fe ff    	lea    -0x120ae(%ebx),%eax
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
c0100c31:	8d 83 64 df fe ff    	lea    -0x1209c(%ebx),%eax
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
c0100c67:	8d 83 80 df fe ff    	lea    -0x12080(%ebx),%eax
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
c0100c83:	8d 83 88 df fe ff    	lea    -0x12078(%ebx),%eax
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
c0100d0f:	8d 83 0c e0 fe ff    	lea    -0x11ff4(%ebx),%eax
c0100d15:	50                   	push   %eax
c0100d16:	e8 bc 4f 00 00       	call   c0105cd7 <strchr>
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
c0100d37:	8d 83 11 e0 fe ff    	lea    -0x11fef(%ebx),%eax
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
c0100d7d:	8d 83 0c e0 fe ff    	lea    -0x11ff4(%ebx),%eax
c0100d83:	50                   	push   %eax
c0100d84:	e8 4e 4f 00 00       	call   c0105cd7 <strchr>
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
c0100dfd:	e8 21 4e 00 00       	call   c0105c23 <strcmp>
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
c0100e4d:	8d 83 2f e0 fe ff    	lea    -0x11fd1(%ebx),%eax
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
c0100e7d:	8d 83 48 e0 fe ff    	lea    -0x11fb8(%ebx),%eax
c0100e83:	50                   	push   %eax
c0100e84:	e8 a0 f4 ff ff       	call   c0100329 <cprintf>
c0100e89:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100e8c:	83 ec 0c             	sub    $0xc,%esp
c0100e8f:	8d 83 70 e0 fe ff    	lea    -0x11f90(%ebx),%eax
c0100e95:	50                   	push   %eax
c0100e96:	e8 8e f4 ff ff       	call   c0100329 <cprintf>
c0100e9b:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100e9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100ea2:	74 0e                	je     c0100eb2 <kmonitor+0x4a>
        print_trapframe(tf);
c0100ea4:	83 ec 0c             	sub    $0xc,%esp
c0100ea7:	ff 75 08             	pushl  0x8(%ebp)
c0100eaa:	e8 a5 0f 00 00       	call   c0101e54 <print_trapframe>
c0100eaf:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100eb2:	83 ec 0c             	sub    $0xc,%esp
c0100eb5:	8d 83 95 e0 fe ff    	lea    -0x11f6b(%ebx),%eax
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
c0100f38:	8d 83 99 e0 fe ff    	lea    -0x11f67(%ebx),%eax
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
c0100fff:	8d 83 a2 e0 fe ff    	lea    -0x11f5e(%ebx),%eax
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
c01014a4:	e8 55 4a 00 00       	call   c0105efe <memmove>
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
c010188f:	8d 81 bd e0 fe ff    	lea    -0x11f43(%ecx),%eax
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
c0101938:	8d 83 c9 e0 fe ff    	lea    -0x11f37(%ebx),%eax
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
#include <string.h>
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
c0101c47:	8d 90 e7 e0 fe ff    	lea    -0x11f19(%eax),%edx
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
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101d50:	c7 c2 02 85 11 c0    	mov    $0xc0118502,%edx
c0101d56:	8b 92 e4 01 00 00    	mov    0x1e4(%edx),%edx
c0101d5c:	66 89 90 f8 30 00 00 	mov    %dx,0x30f8(%eax)
c0101d63:	66 c7 80 fa 30 00 00 	movw   $0x8,0x30fa(%eax)
c0101d6a:	08 00 
c0101d6c:	0f b6 90 fc 30 00 00 	movzbl 0x30fc(%eax),%edx
c0101d73:	83 e2 e0             	and    $0xffffffe0,%edx
c0101d76:	88 90 fc 30 00 00    	mov    %dl,0x30fc(%eax)
c0101d7c:	0f b6 90 fc 30 00 00 	movzbl 0x30fc(%eax),%edx
c0101d83:	83 e2 1f             	and    $0x1f,%edx
c0101d86:	88 90 fc 30 00 00    	mov    %dl,0x30fc(%eax)
c0101d8c:	0f b6 90 fd 30 00 00 	movzbl 0x30fd(%eax),%edx
c0101d93:	83 e2 f0             	and    $0xfffffff0,%edx
c0101d96:	83 ca 0e             	or     $0xe,%edx
c0101d99:	88 90 fd 30 00 00    	mov    %dl,0x30fd(%eax)
c0101d9f:	0f b6 90 fd 30 00 00 	movzbl 0x30fd(%eax),%edx
c0101da6:	83 e2 ef             	and    $0xffffffef,%edx
c0101da9:	88 90 fd 30 00 00    	mov    %dl,0x30fd(%eax)
c0101daf:	0f b6 90 fd 30 00 00 	movzbl 0x30fd(%eax),%edx
c0101db6:	83 ca 60             	or     $0x60,%edx
c0101db9:	88 90 fd 30 00 00    	mov    %dl,0x30fd(%eax)
c0101dbf:	0f b6 90 fd 30 00 00 	movzbl 0x30fd(%eax),%edx
c0101dc6:	83 ca 80             	or     $0xffffff80,%edx
c0101dc9:	88 90 fd 30 00 00    	mov    %dl,0x30fd(%eax)
c0101dcf:	c7 c2 02 85 11 c0    	mov    $0xc0118502,%edx
c0101dd5:	8b 92 e4 01 00 00    	mov    0x1e4(%edx),%edx
c0101ddb:	c1 ea 10             	shr    $0x10,%edx
c0101dde:	66 89 90 fe 30 00 00 	mov    %dx,0x30fe(%eax)
c0101de5:	8d 80 50 00 00 00    	lea    0x50(%eax),%eax
c0101deb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101dee:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101df1:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
c0101df4:	90                   	nop
c0101df5:	c9                   	leave  
c0101df6:	c3                   	ret    

c0101df7 <trapname>:

static const char *
trapname(int trapno) {
c0101df7:	55                   	push   %ebp
c0101df8:	89 e5                	mov    %esp,%ebp
c0101dfa:	e8 b3 e4 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0101dff:	05 51 6b 01 00       	add    $0x16b51,%eax
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101e04:	8b 55 08             	mov    0x8(%ebp),%edx
c0101e07:	83 fa 13             	cmp    $0x13,%edx
c0101e0a:	77 0c                	ja     c0101e18 <trapname+0x21>
        return excnames[trapno];
c0101e0c:	8b 55 08             	mov    0x8(%ebp),%edx
c0101e0f:	8b 84 90 f0 00 00 00 	mov    0xf0(%eax,%edx,4),%eax
c0101e16:	eb 1a                	jmp    c0101e32 <trapname+0x3b>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101e18:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101e1c:	7e 0e                	jle    c0101e2c <trapname+0x35>
c0101e1e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101e22:	7f 08                	jg     c0101e2c <trapname+0x35>
        return "Hardware Interrupt";
c0101e24:	8d 80 f1 e0 fe ff    	lea    -0x11f0f(%eax),%eax
c0101e2a:	eb 06                	jmp    c0101e32 <trapname+0x3b>
    }
    return "(unknown trap)";
c0101e2c:	8d 80 04 e1 fe ff    	lea    -0x11efc(%eax),%eax
}
c0101e32:	5d                   	pop    %ebp
c0101e33:	c3                   	ret    

c0101e34 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101e34:	55                   	push   %ebp
c0101e35:	89 e5                	mov    %esp,%ebp
c0101e37:	e8 76 e4 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0101e3c:	05 14 6b 01 00       	add    $0x16b14,%eax
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101e41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e44:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e48:	66 83 f8 08          	cmp    $0x8,%ax
c0101e4c:	0f 94 c0             	sete   %al
c0101e4f:	0f b6 c0             	movzbl %al,%eax
}
c0101e52:	5d                   	pop    %ebp
c0101e53:	c3                   	ret    

c0101e54 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101e54:	55                   	push   %ebp
c0101e55:	89 e5                	mov    %esp,%ebp
c0101e57:	53                   	push   %ebx
c0101e58:	83 ec 14             	sub    $0x14,%esp
c0101e5b:	e8 56 e4 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0101e60:	81 c3 f0 6a 01 00    	add    $0x16af0,%ebx
    cprintf("trapframe at %p\n", tf);
c0101e66:	83 ec 08             	sub    $0x8,%esp
c0101e69:	ff 75 08             	pushl  0x8(%ebp)
c0101e6c:	8d 83 45 e1 fe ff    	lea    -0x11ebb(%ebx),%eax
c0101e72:	50                   	push   %eax
c0101e73:	e8 b1 e4 ff ff       	call   c0100329 <cprintf>
c0101e78:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101e7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e7e:	83 ec 0c             	sub    $0xc,%esp
c0101e81:	50                   	push   %eax
c0101e82:	e8 d3 01 00 00       	call   c010205a <print_regs>
c0101e87:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101e8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101e91:	0f b7 c0             	movzwl %ax,%eax
c0101e94:	83 ec 08             	sub    $0x8,%esp
c0101e97:	50                   	push   %eax
c0101e98:	8d 83 56 e1 fe ff    	lea    -0x11eaa(%ebx),%eax
c0101e9e:	50                   	push   %eax
c0101e9f:	e8 85 e4 ff ff       	call   c0100329 <cprintf>
c0101ea4:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101ea7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eaa:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101eae:	0f b7 c0             	movzwl %ax,%eax
c0101eb1:	83 ec 08             	sub    $0x8,%esp
c0101eb4:	50                   	push   %eax
c0101eb5:	8d 83 69 e1 fe ff    	lea    -0x11e97(%ebx),%eax
c0101ebb:	50                   	push   %eax
c0101ebc:	e8 68 e4 ff ff       	call   c0100329 <cprintf>
c0101ec1:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101ec4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec7:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101ecb:	0f b7 c0             	movzwl %ax,%eax
c0101ece:	83 ec 08             	sub    $0x8,%esp
c0101ed1:	50                   	push   %eax
c0101ed2:	8d 83 7c e1 fe ff    	lea    -0x11e84(%ebx),%eax
c0101ed8:	50                   	push   %eax
c0101ed9:	e8 4b e4 ff ff       	call   c0100329 <cprintf>
c0101ede:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ee1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee4:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ee8:	0f b7 c0             	movzwl %ax,%eax
c0101eeb:	83 ec 08             	sub    $0x8,%esp
c0101eee:	50                   	push   %eax
c0101eef:	8d 83 8f e1 fe ff    	lea    -0x11e71(%ebx),%eax
c0101ef5:	50                   	push   %eax
c0101ef6:	e8 2e e4 ff ff       	call   c0100329 <cprintf>
c0101efb:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101efe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f01:	8b 40 30             	mov    0x30(%eax),%eax
c0101f04:	83 ec 0c             	sub    $0xc,%esp
c0101f07:	50                   	push   %eax
c0101f08:	e8 ea fe ff ff       	call   c0101df7 <trapname>
c0101f0d:	83 c4 10             	add    $0x10,%esp
c0101f10:	89 c2                	mov    %eax,%edx
c0101f12:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f15:	8b 40 30             	mov    0x30(%eax),%eax
c0101f18:	83 ec 04             	sub    $0x4,%esp
c0101f1b:	52                   	push   %edx
c0101f1c:	50                   	push   %eax
c0101f1d:	8d 83 a2 e1 fe ff    	lea    -0x11e5e(%ebx),%eax
c0101f23:	50                   	push   %eax
c0101f24:	e8 00 e4 ff ff       	call   c0100329 <cprintf>
c0101f29:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101f2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f2f:	8b 40 34             	mov    0x34(%eax),%eax
c0101f32:	83 ec 08             	sub    $0x8,%esp
c0101f35:	50                   	push   %eax
c0101f36:	8d 83 b4 e1 fe ff    	lea    -0x11e4c(%ebx),%eax
c0101f3c:	50                   	push   %eax
c0101f3d:	e8 e7 e3 ff ff       	call   c0100329 <cprintf>
c0101f42:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101f45:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f48:	8b 40 38             	mov    0x38(%eax),%eax
c0101f4b:	83 ec 08             	sub    $0x8,%esp
c0101f4e:	50                   	push   %eax
c0101f4f:	8d 83 c3 e1 fe ff    	lea    -0x11e3d(%ebx),%eax
c0101f55:	50                   	push   %eax
c0101f56:	e8 ce e3 ff ff       	call   c0100329 <cprintf>
c0101f5b:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101f5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f61:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f65:	0f b7 c0             	movzwl %ax,%eax
c0101f68:	83 ec 08             	sub    $0x8,%esp
c0101f6b:	50                   	push   %eax
c0101f6c:	8d 83 d2 e1 fe ff    	lea    -0x11e2e(%ebx),%eax
c0101f72:	50                   	push   %eax
c0101f73:	e8 b1 e3 ff ff       	call   c0100329 <cprintf>
c0101f78:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101f7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f7e:	8b 40 40             	mov    0x40(%eax),%eax
c0101f81:	83 ec 08             	sub    $0x8,%esp
c0101f84:	50                   	push   %eax
c0101f85:	8d 83 e5 e1 fe ff    	lea    -0x11e1b(%ebx),%eax
c0101f8b:	50                   	push   %eax
c0101f8c:	e8 98 e3 ff ff       	call   c0100329 <cprintf>
c0101f91:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101f94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101f9b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101fa2:	eb 41                	jmp    c0101fe5 <print_trapframe+0x191>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101fa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fa7:	8b 50 40             	mov    0x40(%eax),%edx
c0101faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101fad:	21 d0                	and    %edx,%eax
c0101faf:	85 c0                	test   %eax,%eax
c0101fb1:	74 2b                	je     c0101fde <print_trapframe+0x18a>
c0101fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fb6:	8b 84 83 70 00 00 00 	mov    0x70(%ebx,%eax,4),%eax
c0101fbd:	85 c0                	test   %eax,%eax
c0101fbf:	74 1d                	je     c0101fde <print_trapframe+0x18a>
            cprintf("%s,", IA32flags[i]);
c0101fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fc4:	8b 84 83 70 00 00 00 	mov    0x70(%ebx,%eax,4),%eax
c0101fcb:	83 ec 08             	sub    $0x8,%esp
c0101fce:	50                   	push   %eax
c0101fcf:	8d 83 f4 e1 fe ff    	lea    -0x11e0c(%ebx),%eax
c0101fd5:	50                   	push   %eax
c0101fd6:	e8 4e e3 ff ff       	call   c0100329 <cprintf>
c0101fdb:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101fde:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101fe2:	d1 65 f0             	shll   -0x10(%ebp)
c0101fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fe8:	83 f8 17             	cmp    $0x17,%eax
c0101feb:	76 b7                	jbe    c0101fa4 <print_trapframe+0x150>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101fed:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ff0:	8b 40 40             	mov    0x40(%eax),%eax
c0101ff3:	c1 e8 0c             	shr    $0xc,%eax
c0101ff6:	83 e0 03             	and    $0x3,%eax
c0101ff9:	83 ec 08             	sub    $0x8,%esp
c0101ffc:	50                   	push   %eax
c0101ffd:	8d 83 f8 e1 fe ff    	lea    -0x11e08(%ebx),%eax
c0102003:	50                   	push   %eax
c0102004:	e8 20 e3 ff ff       	call   c0100329 <cprintf>
c0102009:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c010200c:	83 ec 0c             	sub    $0xc,%esp
c010200f:	ff 75 08             	pushl  0x8(%ebp)
c0102012:	e8 1d fe ff ff       	call   c0101e34 <trap_in_kernel>
c0102017:	83 c4 10             	add    $0x10,%esp
c010201a:	85 c0                	test   %eax,%eax
c010201c:	75 36                	jne    c0102054 <print_trapframe+0x200>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c010201e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102021:	8b 40 44             	mov    0x44(%eax),%eax
c0102024:	83 ec 08             	sub    $0x8,%esp
c0102027:	50                   	push   %eax
c0102028:	8d 83 01 e2 fe ff    	lea    -0x11dff(%ebx),%eax
c010202e:	50                   	push   %eax
c010202f:	e8 f5 e2 ff ff       	call   c0100329 <cprintf>
c0102034:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102037:	8b 45 08             	mov    0x8(%ebp),%eax
c010203a:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c010203e:	0f b7 c0             	movzwl %ax,%eax
c0102041:	83 ec 08             	sub    $0x8,%esp
c0102044:	50                   	push   %eax
c0102045:	8d 83 10 e2 fe ff    	lea    -0x11df0(%ebx),%eax
c010204b:	50                   	push   %eax
c010204c:	e8 d8 e2 ff ff       	call   c0100329 <cprintf>
c0102051:	83 c4 10             	add    $0x10,%esp
    }
}
c0102054:	90                   	nop
c0102055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102058:	c9                   	leave  
c0102059:	c3                   	ret    

c010205a <print_regs>:

void
print_regs(struct pushregs *regs) {
c010205a:	55                   	push   %ebp
c010205b:	89 e5                	mov    %esp,%ebp
c010205d:	53                   	push   %ebx
c010205e:	83 ec 04             	sub    $0x4,%esp
c0102061:	e8 50 e2 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0102066:	81 c3 ea 68 01 00    	add    $0x168ea,%ebx
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c010206c:	8b 45 08             	mov    0x8(%ebp),%eax
c010206f:	8b 00                	mov    (%eax),%eax
c0102071:	83 ec 08             	sub    $0x8,%esp
c0102074:	50                   	push   %eax
c0102075:	8d 83 23 e2 fe ff    	lea    -0x11ddd(%ebx),%eax
c010207b:	50                   	push   %eax
c010207c:	e8 a8 e2 ff ff       	call   c0100329 <cprintf>
c0102081:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102084:	8b 45 08             	mov    0x8(%ebp),%eax
c0102087:	8b 40 04             	mov    0x4(%eax),%eax
c010208a:	83 ec 08             	sub    $0x8,%esp
c010208d:	50                   	push   %eax
c010208e:	8d 83 32 e2 fe ff    	lea    -0x11dce(%ebx),%eax
c0102094:	50                   	push   %eax
c0102095:	e8 8f e2 ff ff       	call   c0100329 <cprintf>
c010209a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c010209d:	8b 45 08             	mov    0x8(%ebp),%eax
c01020a0:	8b 40 08             	mov    0x8(%eax),%eax
c01020a3:	83 ec 08             	sub    $0x8,%esp
c01020a6:	50                   	push   %eax
c01020a7:	8d 83 41 e2 fe ff    	lea    -0x11dbf(%ebx),%eax
c01020ad:	50                   	push   %eax
c01020ae:	e8 76 e2 ff ff       	call   c0100329 <cprintf>
c01020b3:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01020b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01020b9:	8b 40 0c             	mov    0xc(%eax),%eax
c01020bc:	83 ec 08             	sub    $0x8,%esp
c01020bf:	50                   	push   %eax
c01020c0:	8d 83 50 e2 fe ff    	lea    -0x11db0(%ebx),%eax
c01020c6:	50                   	push   %eax
c01020c7:	e8 5d e2 ff ff       	call   c0100329 <cprintf>
c01020cc:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01020cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01020d2:	8b 40 10             	mov    0x10(%eax),%eax
c01020d5:	83 ec 08             	sub    $0x8,%esp
c01020d8:	50                   	push   %eax
c01020d9:	8d 83 5f e2 fe ff    	lea    -0x11da1(%ebx),%eax
c01020df:	50                   	push   %eax
c01020e0:	e8 44 e2 ff ff       	call   c0100329 <cprintf>
c01020e5:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01020e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01020eb:	8b 40 14             	mov    0x14(%eax),%eax
c01020ee:	83 ec 08             	sub    $0x8,%esp
c01020f1:	50                   	push   %eax
c01020f2:	8d 83 6e e2 fe ff    	lea    -0x11d92(%ebx),%eax
c01020f8:	50                   	push   %eax
c01020f9:	e8 2b e2 ff ff       	call   c0100329 <cprintf>
c01020fe:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102101:	8b 45 08             	mov    0x8(%ebp),%eax
c0102104:	8b 40 18             	mov    0x18(%eax),%eax
c0102107:	83 ec 08             	sub    $0x8,%esp
c010210a:	50                   	push   %eax
c010210b:	8d 83 7d e2 fe ff    	lea    -0x11d83(%ebx),%eax
c0102111:	50                   	push   %eax
c0102112:	e8 12 e2 ff ff       	call   c0100329 <cprintf>
c0102117:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010211a:	8b 45 08             	mov    0x8(%ebp),%eax
c010211d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102120:	83 ec 08             	sub    $0x8,%esp
c0102123:	50                   	push   %eax
c0102124:	8d 83 8c e2 fe ff    	lea    -0x11d74(%ebx),%eax
c010212a:	50                   	push   %eax
c010212b:	e8 f9 e1 ff ff       	call   c0100329 <cprintf>
c0102130:	83 c4 10             	add    $0x10,%esp
}
c0102133:	90                   	nop
c0102134:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102137:	c9                   	leave  
c0102138:	c3                   	ret    

c0102139 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0102139:	55                   	push   %ebp
c010213a:	89 e5                	mov    %esp,%ebp
c010213c:	57                   	push   %edi
c010213d:	56                   	push   %esi
c010213e:	53                   	push   %ebx
c010213f:	83 ec 1c             	sub    $0x1c,%esp
c0102142:	e8 6f e1 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0102147:	81 c3 09 68 01 00    	add    $0x16809,%ebx
    char c;

    switch (tf->tf_trapno) {
c010214d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102150:	8b 40 30             	mov    0x30(%eax),%eax
c0102153:	83 f8 2f             	cmp    $0x2f,%eax
c0102156:	77 21                	ja     c0102179 <trap_dispatch+0x40>
c0102158:	83 f8 2e             	cmp    $0x2e,%eax
c010215b:	0f 83 3b 02 00 00    	jae    c010239c <trap_dispatch+0x263>
c0102161:	83 f8 21             	cmp    $0x21,%eax
c0102164:	0f 84 91 00 00 00    	je     c01021fb <trap_dispatch+0xc2>
c010216a:	83 f8 24             	cmp    $0x24,%eax
c010216d:	74 63                	je     c01021d2 <trap_dispatch+0x99>
c010216f:	83 f8 20             	cmp    $0x20,%eax
c0102172:	74 1c                	je     c0102190 <trap_dispatch+0x57>
c0102174:	e9 e9 01 00 00       	jmp    c0102362 <trap_dispatch+0x229>
c0102179:	83 f8 78             	cmp    $0x78,%eax
c010217c:	0f 84 a2 00 00 00    	je     c0102224 <trap_dispatch+0xeb>
c0102182:	83 f8 79             	cmp    $0x79,%eax
c0102185:	0f 84 57 01 00 00    	je     c01022e2 <trap_dispatch+0x1a9>
c010218b:	e9 d2 01 00 00       	jmp    c0102362 <trap_dispatch+0x229>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0102190:	c7 c0 0c bf 11 c0    	mov    $0xc011bf0c,%eax
c0102196:	8b 00                	mov    (%eax),%eax
c0102198:	8d 50 01             	lea    0x1(%eax),%edx
c010219b:	c7 c0 0c bf 11 c0    	mov    $0xc011bf0c,%eax
c01021a1:	89 10                	mov    %edx,(%eax)
        if (ticks % TICK_NUM == 0) {
c01021a3:	c7 c0 0c bf 11 c0    	mov    $0xc011bf0c,%eax
c01021a9:	8b 08                	mov    (%eax),%ecx
c01021ab:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c01021b0:	89 c8                	mov    %ecx,%eax
c01021b2:	f7 e2                	mul    %edx
c01021b4:	89 d0                	mov    %edx,%eax
c01021b6:	c1 e8 05             	shr    $0x5,%eax
c01021b9:	6b c0 64             	imul   $0x64,%eax,%eax
c01021bc:	29 c1                	sub    %eax,%ecx
c01021be:	89 c8                	mov    %ecx,%eax
c01021c0:	85 c0                	test   %eax,%eax
c01021c2:	0f 85 d7 01 00 00    	jne    c010239f <trap_dispatch+0x266>
            print_ticks();
c01021c8:	e8 64 fa ff ff       	call   c0101c31 <print_ticks>
        }
        break;
c01021cd:	e9 cd 01 00 00       	jmp    c010239f <trap_dispatch+0x266>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01021d2:	e8 c9 f7 ff ff       	call   c01019a0 <cons_getc>
c01021d7:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01021da:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c01021de:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c01021e2:	83 ec 04             	sub    $0x4,%esp
c01021e5:	52                   	push   %edx
c01021e6:	50                   	push   %eax
c01021e7:	8d 83 9b e2 fe ff    	lea    -0x11d65(%ebx),%eax
c01021ed:	50                   	push   %eax
c01021ee:	e8 36 e1 ff ff       	call   c0100329 <cprintf>
c01021f3:	83 c4 10             	add    $0x10,%esp
        break;
c01021f6:	e9 ab 01 00 00       	jmp    c01023a6 <trap_dispatch+0x26d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01021fb:	e8 a0 f7 ff ff       	call   c01019a0 <cons_getc>
c0102200:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102203:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0102207:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c010220b:	83 ec 04             	sub    $0x4,%esp
c010220e:	52                   	push   %edx
c010220f:	50                   	push   %eax
c0102210:	8d 83 ad e2 fe ff    	lea    -0x11d53(%ebx),%eax
c0102216:	50                   	push   %eax
c0102217:	e8 0d e1 ff ff       	call   c0100329 <cprintf>
c010221c:	83 c4 10             	add    $0x10,%esp
        break;
c010221f:	e9 82 01 00 00       	jmp    c01023a6 <trap_dispatch+0x26d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
c0102224:	8b 45 08             	mov    0x8(%ebp),%eax
c0102227:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010222b:	66 83 f8 1b          	cmp    $0x1b,%ax
c010222f:	0f 84 6d 01 00 00    	je     c01023a2 <trap_dispatch+0x269>
            switchk2u = *tf;
c0102235:	c7 c0 20 bf 11 c0    	mov    $0xc011bf20,%eax
c010223b:	8b 55 08             	mov    0x8(%ebp),%edx
c010223e:	89 d6                	mov    %edx,%esi
c0102240:	ba 4c 00 00 00       	mov    $0x4c,%edx
c0102245:	8b 0e                	mov    (%esi),%ecx
c0102247:	89 08                	mov    %ecx,(%eax)
c0102249:	8b 4c 16 fc          	mov    -0x4(%esi,%edx,1),%ecx
c010224d:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
c0102251:	8d 78 04             	lea    0x4(%eax),%edi
c0102254:	83 e7 fc             	and    $0xfffffffc,%edi
c0102257:	29 f8                	sub    %edi,%eax
c0102259:	29 c6                	sub    %eax,%esi
c010225b:	01 c2                	add    %eax,%edx
c010225d:	83 e2 fc             	and    $0xfffffffc,%edx
c0102260:	89 d0                	mov    %edx,%eax
c0102262:	c1 e8 02             	shr    $0x2,%eax
c0102265:	89 c1                	mov    %eax,%ecx
c0102267:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
c0102269:	c7 c0 20 bf 11 c0    	mov    $0xc011bf20,%eax
c010226f:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c0102275:	c7 c0 20 bf 11 c0    	mov    $0xc011bf20,%eax
c010227b:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c0102281:	c7 c0 20 bf 11 c0    	mov    $0xc011bf20,%eax
c0102287:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c010228b:	c7 c0 20 bf 11 c0    	mov    $0xc011bf20,%eax
c0102291:	66 89 50 28          	mov    %dx,0x28(%eax)
c0102295:	c7 c0 20 bf 11 c0    	mov    $0xc011bf20,%eax
c010229b:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c010229f:	c7 c0 20 bf 11 c0    	mov    $0xc011bf20,%eax
c01022a5:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
c01022a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ac:	8d 50 44             	lea    0x44(%eax),%edx
c01022af:	c7 c0 20 bf 11 c0    	mov    $0xc011bf20,%eax
c01022b5:	89 50 44             	mov    %edx,0x44(%eax)
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
c01022b8:	c7 c0 20 bf 11 c0    	mov    $0xc011bf20,%eax
c01022be:	8b 40 40             	mov    0x40(%eax),%eax
c01022c1:	80 cc 30             	or     $0x30,%ah
c01022c4:	89 c2                	mov    %eax,%edx
c01022c6:	c7 c0 20 bf 11 c0    	mov    $0xc011bf20,%eax
c01022cc:	89 50 40             	mov    %edx,0x40(%eax)
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c01022cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01022d2:	83 e8 04             	sub    $0x4,%eax
c01022d5:	c7 c2 20 bf 11 c0    	mov    $0xc011bf20,%edx
c01022db:	89 10                	mov    %edx,(%eax)
        }
        break;
c01022dd:	e9 c0 00 00 00       	jmp    c01023a2 <trap_dispatch+0x269>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
c01022e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01022e5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022e9:	66 83 f8 08          	cmp    $0x8,%ax
c01022ed:	0f 84 b2 00 00 00    	je     c01023a5 <trap_dispatch+0x26c>
            tf->tf_cs = KERNEL_CS;
c01022f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01022f6:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
c01022fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ff:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0102305:	8b 45 08             	mov    0x8(%ebp),%eax
c0102308:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c010230c:	8b 45 08             	mov    0x8(%ebp),%eax
c010230f:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0102313:	8b 45 08             	mov    0x8(%ebp),%eax
c0102316:	8b 40 40             	mov    0x40(%eax),%eax
c0102319:	80 e4 cf             	and    $0xcf,%ah
c010231c:	89 c2                	mov    %eax,%edx
c010231e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102321:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c0102324:	8b 45 08             	mov    0x8(%ebp),%eax
c0102327:	8b 40 44             	mov    0x44(%eax),%eax
c010232a:	83 e8 44             	sub    $0x44,%eax
c010232d:	89 c2                	mov    %eax,%edx
c010232f:	c7 c0 6c bf 11 c0    	mov    $0xc011bf6c,%eax
c0102335:	89 10                	mov    %edx,(%eax)
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c0102337:	c7 c0 6c bf 11 c0    	mov    $0xc011bf6c,%eax
c010233d:	8b 00                	mov    (%eax),%eax
c010233f:	83 ec 04             	sub    $0x4,%esp
c0102342:	6a 44                	push   $0x44
c0102344:	ff 75 08             	pushl  0x8(%ebp)
c0102347:	50                   	push   %eax
c0102348:	e8 b1 3b 00 00       	call   c0105efe <memmove>
c010234d:	83 c4 10             	add    $0x10,%esp
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c0102350:	c7 c0 6c bf 11 c0    	mov    $0xc011bf6c,%eax
c0102356:	8b 10                	mov    (%eax),%edx
c0102358:	8b 45 08             	mov    0x8(%ebp),%eax
c010235b:	83 e8 04             	sub    $0x4,%eax
c010235e:	89 10                	mov    %edx,(%eax)
        }
        break;
c0102360:	eb 43                	jmp    c01023a5 <trap_dispatch+0x26c>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102362:	8b 45 08             	mov    0x8(%ebp),%eax
c0102365:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102369:	0f b7 c0             	movzwl %ax,%eax
c010236c:	83 e0 03             	and    $0x3,%eax
c010236f:	85 c0                	test   %eax,%eax
c0102371:	75 33                	jne    c01023a6 <trap_dispatch+0x26d>
            print_trapframe(tf);
c0102373:	83 ec 0c             	sub    $0xc,%esp
c0102376:	ff 75 08             	pushl  0x8(%ebp)
c0102379:	e8 d6 fa ff ff       	call   c0101e54 <print_trapframe>
c010237e:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0102381:	83 ec 04             	sub    $0x4,%esp
c0102384:	8d 83 bc e2 fe ff    	lea    -0x11d44(%ebx),%eax
c010238a:	50                   	push   %eax
c010238b:	68 d2 00 00 00       	push   $0xd2
c0102390:	8d 83 d8 e2 fe ff    	lea    -0x11d28(%ebx),%eax
c0102396:	50                   	push   %eax
c0102397:	e8 3d e1 ff ff       	call   c01004d9 <__panic>
        break;
c010239c:	90                   	nop
c010239d:	eb 07                	jmp    c01023a6 <trap_dispatch+0x26d>
        break;
c010239f:	90                   	nop
c01023a0:	eb 04                	jmp    c01023a6 <trap_dispatch+0x26d>
        break;
c01023a2:	90                   	nop
c01023a3:	eb 01                	jmp    c01023a6 <trap_dispatch+0x26d>
        break;
c01023a5:	90                   	nop
        }
    }
}
c01023a6:	90                   	nop
c01023a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01023aa:	5b                   	pop    %ebx
c01023ab:	5e                   	pop    %esi
c01023ac:	5f                   	pop    %edi
c01023ad:	5d                   	pop    %ebp
c01023ae:	c3                   	ret    

c01023af <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c01023af:	55                   	push   %ebp
c01023b0:	89 e5                	mov    %esp,%ebp
c01023b2:	83 ec 08             	sub    $0x8,%esp
c01023b5:	e8 f8 de ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01023ba:	05 96 65 01 00       	add    $0x16596,%eax
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c01023bf:	83 ec 0c             	sub    $0xc,%esp
c01023c2:	ff 75 08             	pushl  0x8(%ebp)
c01023c5:	e8 6f fd ff ff       	call   c0102139 <trap_dispatch>
c01023ca:	83 c4 10             	add    $0x10,%esp
}
c01023cd:	90                   	nop
c01023ce:	c9                   	leave  
c01023cf:	c3                   	ret    

c01023d0 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01023d0:	6a 00                	push   $0x0
  pushl $0
c01023d2:	6a 00                	push   $0x0
  jmp __alltraps
c01023d4:	e9 69 0a 00 00       	jmp    c0102e42 <__alltraps>

c01023d9 <vector1>:
.globl vector1
vector1:
  pushl $0
c01023d9:	6a 00                	push   $0x0
  pushl $1
c01023db:	6a 01                	push   $0x1
  jmp __alltraps
c01023dd:	e9 60 0a 00 00       	jmp    c0102e42 <__alltraps>

c01023e2 <vector2>:
.globl vector2
vector2:
  pushl $0
c01023e2:	6a 00                	push   $0x0
  pushl $2
c01023e4:	6a 02                	push   $0x2
  jmp __alltraps
c01023e6:	e9 57 0a 00 00       	jmp    c0102e42 <__alltraps>

c01023eb <vector3>:
.globl vector3
vector3:
  pushl $0
c01023eb:	6a 00                	push   $0x0
  pushl $3
c01023ed:	6a 03                	push   $0x3
  jmp __alltraps
c01023ef:	e9 4e 0a 00 00       	jmp    c0102e42 <__alltraps>

c01023f4 <vector4>:
.globl vector4
vector4:
  pushl $0
c01023f4:	6a 00                	push   $0x0
  pushl $4
c01023f6:	6a 04                	push   $0x4
  jmp __alltraps
c01023f8:	e9 45 0a 00 00       	jmp    c0102e42 <__alltraps>

c01023fd <vector5>:
.globl vector5
vector5:
  pushl $0
c01023fd:	6a 00                	push   $0x0
  pushl $5
c01023ff:	6a 05                	push   $0x5
  jmp __alltraps
c0102401:	e9 3c 0a 00 00       	jmp    c0102e42 <__alltraps>

c0102406 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102406:	6a 00                	push   $0x0
  pushl $6
c0102408:	6a 06                	push   $0x6
  jmp __alltraps
c010240a:	e9 33 0a 00 00       	jmp    c0102e42 <__alltraps>

c010240f <vector7>:
.globl vector7
vector7:
  pushl $0
c010240f:	6a 00                	push   $0x0
  pushl $7
c0102411:	6a 07                	push   $0x7
  jmp __alltraps
c0102413:	e9 2a 0a 00 00       	jmp    c0102e42 <__alltraps>

c0102418 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102418:	6a 08                	push   $0x8
  jmp __alltraps
c010241a:	e9 23 0a 00 00       	jmp    c0102e42 <__alltraps>

c010241f <vector9>:
.globl vector9
vector9:
  pushl $0
c010241f:	6a 00                	push   $0x0
  pushl $9
c0102421:	6a 09                	push   $0x9
  jmp __alltraps
c0102423:	e9 1a 0a 00 00       	jmp    c0102e42 <__alltraps>

c0102428 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102428:	6a 0a                	push   $0xa
  jmp __alltraps
c010242a:	e9 13 0a 00 00       	jmp    c0102e42 <__alltraps>

c010242f <vector11>:
.globl vector11
vector11:
  pushl $11
c010242f:	6a 0b                	push   $0xb
  jmp __alltraps
c0102431:	e9 0c 0a 00 00       	jmp    c0102e42 <__alltraps>

c0102436 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102436:	6a 0c                	push   $0xc
  jmp __alltraps
c0102438:	e9 05 0a 00 00       	jmp    c0102e42 <__alltraps>

c010243d <vector13>:
.globl vector13
vector13:
  pushl $13
c010243d:	6a 0d                	push   $0xd
  jmp __alltraps
c010243f:	e9 fe 09 00 00       	jmp    c0102e42 <__alltraps>

c0102444 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102444:	6a 0e                	push   $0xe
  jmp __alltraps
c0102446:	e9 f7 09 00 00       	jmp    c0102e42 <__alltraps>

c010244b <vector15>:
.globl vector15
vector15:
  pushl $0
c010244b:	6a 00                	push   $0x0
  pushl $15
c010244d:	6a 0f                	push   $0xf
  jmp __alltraps
c010244f:	e9 ee 09 00 00       	jmp    c0102e42 <__alltraps>

c0102454 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102454:	6a 00                	push   $0x0
  pushl $16
c0102456:	6a 10                	push   $0x10
  jmp __alltraps
c0102458:	e9 e5 09 00 00       	jmp    c0102e42 <__alltraps>

c010245d <vector17>:
.globl vector17
vector17:
  pushl $17
c010245d:	6a 11                	push   $0x11
  jmp __alltraps
c010245f:	e9 de 09 00 00       	jmp    c0102e42 <__alltraps>

c0102464 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102464:	6a 00                	push   $0x0
  pushl $18
c0102466:	6a 12                	push   $0x12
  jmp __alltraps
c0102468:	e9 d5 09 00 00       	jmp    c0102e42 <__alltraps>

c010246d <vector19>:
.globl vector19
vector19:
  pushl $0
c010246d:	6a 00                	push   $0x0
  pushl $19
c010246f:	6a 13                	push   $0x13
  jmp __alltraps
c0102471:	e9 cc 09 00 00       	jmp    c0102e42 <__alltraps>

c0102476 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102476:	6a 00                	push   $0x0
  pushl $20
c0102478:	6a 14                	push   $0x14
  jmp __alltraps
c010247a:	e9 c3 09 00 00       	jmp    c0102e42 <__alltraps>

c010247f <vector21>:
.globl vector21
vector21:
  pushl $0
c010247f:	6a 00                	push   $0x0
  pushl $21
c0102481:	6a 15                	push   $0x15
  jmp __alltraps
c0102483:	e9 ba 09 00 00       	jmp    c0102e42 <__alltraps>

c0102488 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102488:	6a 00                	push   $0x0
  pushl $22
c010248a:	6a 16                	push   $0x16
  jmp __alltraps
c010248c:	e9 b1 09 00 00       	jmp    c0102e42 <__alltraps>

c0102491 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102491:	6a 00                	push   $0x0
  pushl $23
c0102493:	6a 17                	push   $0x17
  jmp __alltraps
c0102495:	e9 a8 09 00 00       	jmp    c0102e42 <__alltraps>

c010249a <vector24>:
.globl vector24
vector24:
  pushl $0
c010249a:	6a 00                	push   $0x0
  pushl $24
c010249c:	6a 18                	push   $0x18
  jmp __alltraps
c010249e:	e9 9f 09 00 00       	jmp    c0102e42 <__alltraps>

c01024a3 <vector25>:
.globl vector25
vector25:
  pushl $0
c01024a3:	6a 00                	push   $0x0
  pushl $25
c01024a5:	6a 19                	push   $0x19
  jmp __alltraps
c01024a7:	e9 96 09 00 00       	jmp    c0102e42 <__alltraps>

c01024ac <vector26>:
.globl vector26
vector26:
  pushl $0
c01024ac:	6a 00                	push   $0x0
  pushl $26
c01024ae:	6a 1a                	push   $0x1a
  jmp __alltraps
c01024b0:	e9 8d 09 00 00       	jmp    c0102e42 <__alltraps>

c01024b5 <vector27>:
.globl vector27
vector27:
  pushl $0
c01024b5:	6a 00                	push   $0x0
  pushl $27
c01024b7:	6a 1b                	push   $0x1b
  jmp __alltraps
c01024b9:	e9 84 09 00 00       	jmp    c0102e42 <__alltraps>

c01024be <vector28>:
.globl vector28
vector28:
  pushl $0
c01024be:	6a 00                	push   $0x0
  pushl $28
c01024c0:	6a 1c                	push   $0x1c
  jmp __alltraps
c01024c2:	e9 7b 09 00 00       	jmp    c0102e42 <__alltraps>

c01024c7 <vector29>:
.globl vector29
vector29:
  pushl $0
c01024c7:	6a 00                	push   $0x0
  pushl $29
c01024c9:	6a 1d                	push   $0x1d
  jmp __alltraps
c01024cb:	e9 72 09 00 00       	jmp    c0102e42 <__alltraps>

c01024d0 <vector30>:
.globl vector30
vector30:
  pushl $0
c01024d0:	6a 00                	push   $0x0
  pushl $30
c01024d2:	6a 1e                	push   $0x1e
  jmp __alltraps
c01024d4:	e9 69 09 00 00       	jmp    c0102e42 <__alltraps>

c01024d9 <vector31>:
.globl vector31
vector31:
  pushl $0
c01024d9:	6a 00                	push   $0x0
  pushl $31
c01024db:	6a 1f                	push   $0x1f
  jmp __alltraps
c01024dd:	e9 60 09 00 00       	jmp    c0102e42 <__alltraps>

c01024e2 <vector32>:
.globl vector32
vector32:
  pushl $0
c01024e2:	6a 00                	push   $0x0
  pushl $32
c01024e4:	6a 20                	push   $0x20
  jmp __alltraps
c01024e6:	e9 57 09 00 00       	jmp    c0102e42 <__alltraps>

c01024eb <vector33>:
.globl vector33
vector33:
  pushl $0
c01024eb:	6a 00                	push   $0x0
  pushl $33
c01024ed:	6a 21                	push   $0x21
  jmp __alltraps
c01024ef:	e9 4e 09 00 00       	jmp    c0102e42 <__alltraps>

c01024f4 <vector34>:
.globl vector34
vector34:
  pushl $0
c01024f4:	6a 00                	push   $0x0
  pushl $34
c01024f6:	6a 22                	push   $0x22
  jmp __alltraps
c01024f8:	e9 45 09 00 00       	jmp    c0102e42 <__alltraps>

c01024fd <vector35>:
.globl vector35
vector35:
  pushl $0
c01024fd:	6a 00                	push   $0x0
  pushl $35
c01024ff:	6a 23                	push   $0x23
  jmp __alltraps
c0102501:	e9 3c 09 00 00       	jmp    c0102e42 <__alltraps>

c0102506 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102506:	6a 00                	push   $0x0
  pushl $36
c0102508:	6a 24                	push   $0x24
  jmp __alltraps
c010250a:	e9 33 09 00 00       	jmp    c0102e42 <__alltraps>

c010250f <vector37>:
.globl vector37
vector37:
  pushl $0
c010250f:	6a 00                	push   $0x0
  pushl $37
c0102511:	6a 25                	push   $0x25
  jmp __alltraps
c0102513:	e9 2a 09 00 00       	jmp    c0102e42 <__alltraps>

c0102518 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102518:	6a 00                	push   $0x0
  pushl $38
c010251a:	6a 26                	push   $0x26
  jmp __alltraps
c010251c:	e9 21 09 00 00       	jmp    c0102e42 <__alltraps>

c0102521 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102521:	6a 00                	push   $0x0
  pushl $39
c0102523:	6a 27                	push   $0x27
  jmp __alltraps
c0102525:	e9 18 09 00 00       	jmp    c0102e42 <__alltraps>

c010252a <vector40>:
.globl vector40
vector40:
  pushl $0
c010252a:	6a 00                	push   $0x0
  pushl $40
c010252c:	6a 28                	push   $0x28
  jmp __alltraps
c010252e:	e9 0f 09 00 00       	jmp    c0102e42 <__alltraps>

c0102533 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102533:	6a 00                	push   $0x0
  pushl $41
c0102535:	6a 29                	push   $0x29
  jmp __alltraps
c0102537:	e9 06 09 00 00       	jmp    c0102e42 <__alltraps>

c010253c <vector42>:
.globl vector42
vector42:
  pushl $0
c010253c:	6a 00                	push   $0x0
  pushl $42
c010253e:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102540:	e9 fd 08 00 00       	jmp    c0102e42 <__alltraps>

c0102545 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102545:	6a 00                	push   $0x0
  pushl $43
c0102547:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102549:	e9 f4 08 00 00       	jmp    c0102e42 <__alltraps>

c010254e <vector44>:
.globl vector44
vector44:
  pushl $0
c010254e:	6a 00                	push   $0x0
  pushl $44
c0102550:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102552:	e9 eb 08 00 00       	jmp    c0102e42 <__alltraps>

c0102557 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102557:	6a 00                	push   $0x0
  pushl $45
c0102559:	6a 2d                	push   $0x2d
  jmp __alltraps
c010255b:	e9 e2 08 00 00       	jmp    c0102e42 <__alltraps>

c0102560 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102560:	6a 00                	push   $0x0
  pushl $46
c0102562:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102564:	e9 d9 08 00 00       	jmp    c0102e42 <__alltraps>

c0102569 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102569:	6a 00                	push   $0x0
  pushl $47
c010256b:	6a 2f                	push   $0x2f
  jmp __alltraps
c010256d:	e9 d0 08 00 00       	jmp    c0102e42 <__alltraps>

c0102572 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102572:	6a 00                	push   $0x0
  pushl $48
c0102574:	6a 30                	push   $0x30
  jmp __alltraps
c0102576:	e9 c7 08 00 00       	jmp    c0102e42 <__alltraps>

c010257b <vector49>:
.globl vector49
vector49:
  pushl $0
c010257b:	6a 00                	push   $0x0
  pushl $49
c010257d:	6a 31                	push   $0x31
  jmp __alltraps
c010257f:	e9 be 08 00 00       	jmp    c0102e42 <__alltraps>

c0102584 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102584:	6a 00                	push   $0x0
  pushl $50
c0102586:	6a 32                	push   $0x32
  jmp __alltraps
c0102588:	e9 b5 08 00 00       	jmp    c0102e42 <__alltraps>

c010258d <vector51>:
.globl vector51
vector51:
  pushl $0
c010258d:	6a 00                	push   $0x0
  pushl $51
c010258f:	6a 33                	push   $0x33
  jmp __alltraps
c0102591:	e9 ac 08 00 00       	jmp    c0102e42 <__alltraps>

c0102596 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102596:	6a 00                	push   $0x0
  pushl $52
c0102598:	6a 34                	push   $0x34
  jmp __alltraps
c010259a:	e9 a3 08 00 00       	jmp    c0102e42 <__alltraps>

c010259f <vector53>:
.globl vector53
vector53:
  pushl $0
c010259f:	6a 00                	push   $0x0
  pushl $53
c01025a1:	6a 35                	push   $0x35
  jmp __alltraps
c01025a3:	e9 9a 08 00 00       	jmp    c0102e42 <__alltraps>

c01025a8 <vector54>:
.globl vector54
vector54:
  pushl $0
c01025a8:	6a 00                	push   $0x0
  pushl $54
c01025aa:	6a 36                	push   $0x36
  jmp __alltraps
c01025ac:	e9 91 08 00 00       	jmp    c0102e42 <__alltraps>

c01025b1 <vector55>:
.globl vector55
vector55:
  pushl $0
c01025b1:	6a 00                	push   $0x0
  pushl $55
c01025b3:	6a 37                	push   $0x37
  jmp __alltraps
c01025b5:	e9 88 08 00 00       	jmp    c0102e42 <__alltraps>

c01025ba <vector56>:
.globl vector56
vector56:
  pushl $0
c01025ba:	6a 00                	push   $0x0
  pushl $56
c01025bc:	6a 38                	push   $0x38
  jmp __alltraps
c01025be:	e9 7f 08 00 00       	jmp    c0102e42 <__alltraps>

c01025c3 <vector57>:
.globl vector57
vector57:
  pushl $0
c01025c3:	6a 00                	push   $0x0
  pushl $57
c01025c5:	6a 39                	push   $0x39
  jmp __alltraps
c01025c7:	e9 76 08 00 00       	jmp    c0102e42 <__alltraps>

c01025cc <vector58>:
.globl vector58
vector58:
  pushl $0
c01025cc:	6a 00                	push   $0x0
  pushl $58
c01025ce:	6a 3a                	push   $0x3a
  jmp __alltraps
c01025d0:	e9 6d 08 00 00       	jmp    c0102e42 <__alltraps>

c01025d5 <vector59>:
.globl vector59
vector59:
  pushl $0
c01025d5:	6a 00                	push   $0x0
  pushl $59
c01025d7:	6a 3b                	push   $0x3b
  jmp __alltraps
c01025d9:	e9 64 08 00 00       	jmp    c0102e42 <__alltraps>

c01025de <vector60>:
.globl vector60
vector60:
  pushl $0
c01025de:	6a 00                	push   $0x0
  pushl $60
c01025e0:	6a 3c                	push   $0x3c
  jmp __alltraps
c01025e2:	e9 5b 08 00 00       	jmp    c0102e42 <__alltraps>

c01025e7 <vector61>:
.globl vector61
vector61:
  pushl $0
c01025e7:	6a 00                	push   $0x0
  pushl $61
c01025e9:	6a 3d                	push   $0x3d
  jmp __alltraps
c01025eb:	e9 52 08 00 00       	jmp    c0102e42 <__alltraps>

c01025f0 <vector62>:
.globl vector62
vector62:
  pushl $0
c01025f0:	6a 00                	push   $0x0
  pushl $62
c01025f2:	6a 3e                	push   $0x3e
  jmp __alltraps
c01025f4:	e9 49 08 00 00       	jmp    c0102e42 <__alltraps>

c01025f9 <vector63>:
.globl vector63
vector63:
  pushl $0
c01025f9:	6a 00                	push   $0x0
  pushl $63
c01025fb:	6a 3f                	push   $0x3f
  jmp __alltraps
c01025fd:	e9 40 08 00 00       	jmp    c0102e42 <__alltraps>

c0102602 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102602:	6a 00                	push   $0x0
  pushl $64
c0102604:	6a 40                	push   $0x40
  jmp __alltraps
c0102606:	e9 37 08 00 00       	jmp    c0102e42 <__alltraps>

c010260b <vector65>:
.globl vector65
vector65:
  pushl $0
c010260b:	6a 00                	push   $0x0
  pushl $65
c010260d:	6a 41                	push   $0x41
  jmp __alltraps
c010260f:	e9 2e 08 00 00       	jmp    c0102e42 <__alltraps>

c0102614 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102614:	6a 00                	push   $0x0
  pushl $66
c0102616:	6a 42                	push   $0x42
  jmp __alltraps
c0102618:	e9 25 08 00 00       	jmp    c0102e42 <__alltraps>

c010261d <vector67>:
.globl vector67
vector67:
  pushl $0
c010261d:	6a 00                	push   $0x0
  pushl $67
c010261f:	6a 43                	push   $0x43
  jmp __alltraps
c0102621:	e9 1c 08 00 00       	jmp    c0102e42 <__alltraps>

c0102626 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102626:	6a 00                	push   $0x0
  pushl $68
c0102628:	6a 44                	push   $0x44
  jmp __alltraps
c010262a:	e9 13 08 00 00       	jmp    c0102e42 <__alltraps>

c010262f <vector69>:
.globl vector69
vector69:
  pushl $0
c010262f:	6a 00                	push   $0x0
  pushl $69
c0102631:	6a 45                	push   $0x45
  jmp __alltraps
c0102633:	e9 0a 08 00 00       	jmp    c0102e42 <__alltraps>

c0102638 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102638:	6a 00                	push   $0x0
  pushl $70
c010263a:	6a 46                	push   $0x46
  jmp __alltraps
c010263c:	e9 01 08 00 00       	jmp    c0102e42 <__alltraps>

c0102641 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102641:	6a 00                	push   $0x0
  pushl $71
c0102643:	6a 47                	push   $0x47
  jmp __alltraps
c0102645:	e9 f8 07 00 00       	jmp    c0102e42 <__alltraps>

c010264a <vector72>:
.globl vector72
vector72:
  pushl $0
c010264a:	6a 00                	push   $0x0
  pushl $72
c010264c:	6a 48                	push   $0x48
  jmp __alltraps
c010264e:	e9 ef 07 00 00       	jmp    c0102e42 <__alltraps>

c0102653 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102653:	6a 00                	push   $0x0
  pushl $73
c0102655:	6a 49                	push   $0x49
  jmp __alltraps
c0102657:	e9 e6 07 00 00       	jmp    c0102e42 <__alltraps>

c010265c <vector74>:
.globl vector74
vector74:
  pushl $0
c010265c:	6a 00                	push   $0x0
  pushl $74
c010265e:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102660:	e9 dd 07 00 00       	jmp    c0102e42 <__alltraps>

c0102665 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102665:	6a 00                	push   $0x0
  pushl $75
c0102667:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102669:	e9 d4 07 00 00       	jmp    c0102e42 <__alltraps>

c010266e <vector76>:
.globl vector76
vector76:
  pushl $0
c010266e:	6a 00                	push   $0x0
  pushl $76
c0102670:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102672:	e9 cb 07 00 00       	jmp    c0102e42 <__alltraps>

c0102677 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102677:	6a 00                	push   $0x0
  pushl $77
c0102679:	6a 4d                	push   $0x4d
  jmp __alltraps
c010267b:	e9 c2 07 00 00       	jmp    c0102e42 <__alltraps>

c0102680 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102680:	6a 00                	push   $0x0
  pushl $78
c0102682:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102684:	e9 b9 07 00 00       	jmp    c0102e42 <__alltraps>

c0102689 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102689:	6a 00                	push   $0x0
  pushl $79
c010268b:	6a 4f                	push   $0x4f
  jmp __alltraps
c010268d:	e9 b0 07 00 00       	jmp    c0102e42 <__alltraps>

c0102692 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102692:	6a 00                	push   $0x0
  pushl $80
c0102694:	6a 50                	push   $0x50
  jmp __alltraps
c0102696:	e9 a7 07 00 00       	jmp    c0102e42 <__alltraps>

c010269b <vector81>:
.globl vector81
vector81:
  pushl $0
c010269b:	6a 00                	push   $0x0
  pushl $81
c010269d:	6a 51                	push   $0x51
  jmp __alltraps
c010269f:	e9 9e 07 00 00       	jmp    c0102e42 <__alltraps>

c01026a4 <vector82>:
.globl vector82
vector82:
  pushl $0
c01026a4:	6a 00                	push   $0x0
  pushl $82
c01026a6:	6a 52                	push   $0x52
  jmp __alltraps
c01026a8:	e9 95 07 00 00       	jmp    c0102e42 <__alltraps>

c01026ad <vector83>:
.globl vector83
vector83:
  pushl $0
c01026ad:	6a 00                	push   $0x0
  pushl $83
c01026af:	6a 53                	push   $0x53
  jmp __alltraps
c01026b1:	e9 8c 07 00 00       	jmp    c0102e42 <__alltraps>

c01026b6 <vector84>:
.globl vector84
vector84:
  pushl $0
c01026b6:	6a 00                	push   $0x0
  pushl $84
c01026b8:	6a 54                	push   $0x54
  jmp __alltraps
c01026ba:	e9 83 07 00 00       	jmp    c0102e42 <__alltraps>

c01026bf <vector85>:
.globl vector85
vector85:
  pushl $0
c01026bf:	6a 00                	push   $0x0
  pushl $85
c01026c1:	6a 55                	push   $0x55
  jmp __alltraps
c01026c3:	e9 7a 07 00 00       	jmp    c0102e42 <__alltraps>

c01026c8 <vector86>:
.globl vector86
vector86:
  pushl $0
c01026c8:	6a 00                	push   $0x0
  pushl $86
c01026ca:	6a 56                	push   $0x56
  jmp __alltraps
c01026cc:	e9 71 07 00 00       	jmp    c0102e42 <__alltraps>

c01026d1 <vector87>:
.globl vector87
vector87:
  pushl $0
c01026d1:	6a 00                	push   $0x0
  pushl $87
c01026d3:	6a 57                	push   $0x57
  jmp __alltraps
c01026d5:	e9 68 07 00 00       	jmp    c0102e42 <__alltraps>

c01026da <vector88>:
.globl vector88
vector88:
  pushl $0
c01026da:	6a 00                	push   $0x0
  pushl $88
c01026dc:	6a 58                	push   $0x58
  jmp __alltraps
c01026de:	e9 5f 07 00 00       	jmp    c0102e42 <__alltraps>

c01026e3 <vector89>:
.globl vector89
vector89:
  pushl $0
c01026e3:	6a 00                	push   $0x0
  pushl $89
c01026e5:	6a 59                	push   $0x59
  jmp __alltraps
c01026e7:	e9 56 07 00 00       	jmp    c0102e42 <__alltraps>

c01026ec <vector90>:
.globl vector90
vector90:
  pushl $0
c01026ec:	6a 00                	push   $0x0
  pushl $90
c01026ee:	6a 5a                	push   $0x5a
  jmp __alltraps
c01026f0:	e9 4d 07 00 00       	jmp    c0102e42 <__alltraps>

c01026f5 <vector91>:
.globl vector91
vector91:
  pushl $0
c01026f5:	6a 00                	push   $0x0
  pushl $91
c01026f7:	6a 5b                	push   $0x5b
  jmp __alltraps
c01026f9:	e9 44 07 00 00       	jmp    c0102e42 <__alltraps>

c01026fe <vector92>:
.globl vector92
vector92:
  pushl $0
c01026fe:	6a 00                	push   $0x0
  pushl $92
c0102700:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102702:	e9 3b 07 00 00       	jmp    c0102e42 <__alltraps>

c0102707 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102707:	6a 00                	push   $0x0
  pushl $93
c0102709:	6a 5d                	push   $0x5d
  jmp __alltraps
c010270b:	e9 32 07 00 00       	jmp    c0102e42 <__alltraps>

c0102710 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102710:	6a 00                	push   $0x0
  pushl $94
c0102712:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102714:	e9 29 07 00 00       	jmp    c0102e42 <__alltraps>

c0102719 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102719:	6a 00                	push   $0x0
  pushl $95
c010271b:	6a 5f                	push   $0x5f
  jmp __alltraps
c010271d:	e9 20 07 00 00       	jmp    c0102e42 <__alltraps>

c0102722 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102722:	6a 00                	push   $0x0
  pushl $96
c0102724:	6a 60                	push   $0x60
  jmp __alltraps
c0102726:	e9 17 07 00 00       	jmp    c0102e42 <__alltraps>

c010272b <vector97>:
.globl vector97
vector97:
  pushl $0
c010272b:	6a 00                	push   $0x0
  pushl $97
c010272d:	6a 61                	push   $0x61
  jmp __alltraps
c010272f:	e9 0e 07 00 00       	jmp    c0102e42 <__alltraps>

c0102734 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102734:	6a 00                	push   $0x0
  pushl $98
c0102736:	6a 62                	push   $0x62
  jmp __alltraps
c0102738:	e9 05 07 00 00       	jmp    c0102e42 <__alltraps>

c010273d <vector99>:
.globl vector99
vector99:
  pushl $0
c010273d:	6a 00                	push   $0x0
  pushl $99
c010273f:	6a 63                	push   $0x63
  jmp __alltraps
c0102741:	e9 fc 06 00 00       	jmp    c0102e42 <__alltraps>

c0102746 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102746:	6a 00                	push   $0x0
  pushl $100
c0102748:	6a 64                	push   $0x64
  jmp __alltraps
c010274a:	e9 f3 06 00 00       	jmp    c0102e42 <__alltraps>

c010274f <vector101>:
.globl vector101
vector101:
  pushl $0
c010274f:	6a 00                	push   $0x0
  pushl $101
c0102751:	6a 65                	push   $0x65
  jmp __alltraps
c0102753:	e9 ea 06 00 00       	jmp    c0102e42 <__alltraps>

c0102758 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102758:	6a 00                	push   $0x0
  pushl $102
c010275a:	6a 66                	push   $0x66
  jmp __alltraps
c010275c:	e9 e1 06 00 00       	jmp    c0102e42 <__alltraps>

c0102761 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102761:	6a 00                	push   $0x0
  pushl $103
c0102763:	6a 67                	push   $0x67
  jmp __alltraps
c0102765:	e9 d8 06 00 00       	jmp    c0102e42 <__alltraps>

c010276a <vector104>:
.globl vector104
vector104:
  pushl $0
c010276a:	6a 00                	push   $0x0
  pushl $104
c010276c:	6a 68                	push   $0x68
  jmp __alltraps
c010276e:	e9 cf 06 00 00       	jmp    c0102e42 <__alltraps>

c0102773 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102773:	6a 00                	push   $0x0
  pushl $105
c0102775:	6a 69                	push   $0x69
  jmp __alltraps
c0102777:	e9 c6 06 00 00       	jmp    c0102e42 <__alltraps>

c010277c <vector106>:
.globl vector106
vector106:
  pushl $0
c010277c:	6a 00                	push   $0x0
  pushl $106
c010277e:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102780:	e9 bd 06 00 00       	jmp    c0102e42 <__alltraps>

c0102785 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102785:	6a 00                	push   $0x0
  pushl $107
c0102787:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102789:	e9 b4 06 00 00       	jmp    c0102e42 <__alltraps>

c010278e <vector108>:
.globl vector108
vector108:
  pushl $0
c010278e:	6a 00                	push   $0x0
  pushl $108
c0102790:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102792:	e9 ab 06 00 00       	jmp    c0102e42 <__alltraps>

c0102797 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102797:	6a 00                	push   $0x0
  pushl $109
c0102799:	6a 6d                	push   $0x6d
  jmp __alltraps
c010279b:	e9 a2 06 00 00       	jmp    c0102e42 <__alltraps>

c01027a0 <vector110>:
.globl vector110
vector110:
  pushl $0
c01027a0:	6a 00                	push   $0x0
  pushl $110
c01027a2:	6a 6e                	push   $0x6e
  jmp __alltraps
c01027a4:	e9 99 06 00 00       	jmp    c0102e42 <__alltraps>

c01027a9 <vector111>:
.globl vector111
vector111:
  pushl $0
c01027a9:	6a 00                	push   $0x0
  pushl $111
c01027ab:	6a 6f                	push   $0x6f
  jmp __alltraps
c01027ad:	e9 90 06 00 00       	jmp    c0102e42 <__alltraps>

c01027b2 <vector112>:
.globl vector112
vector112:
  pushl $0
c01027b2:	6a 00                	push   $0x0
  pushl $112
c01027b4:	6a 70                	push   $0x70
  jmp __alltraps
c01027b6:	e9 87 06 00 00       	jmp    c0102e42 <__alltraps>

c01027bb <vector113>:
.globl vector113
vector113:
  pushl $0
c01027bb:	6a 00                	push   $0x0
  pushl $113
c01027bd:	6a 71                	push   $0x71
  jmp __alltraps
c01027bf:	e9 7e 06 00 00       	jmp    c0102e42 <__alltraps>

c01027c4 <vector114>:
.globl vector114
vector114:
  pushl $0
c01027c4:	6a 00                	push   $0x0
  pushl $114
c01027c6:	6a 72                	push   $0x72
  jmp __alltraps
c01027c8:	e9 75 06 00 00       	jmp    c0102e42 <__alltraps>

c01027cd <vector115>:
.globl vector115
vector115:
  pushl $0
c01027cd:	6a 00                	push   $0x0
  pushl $115
c01027cf:	6a 73                	push   $0x73
  jmp __alltraps
c01027d1:	e9 6c 06 00 00       	jmp    c0102e42 <__alltraps>

c01027d6 <vector116>:
.globl vector116
vector116:
  pushl $0
c01027d6:	6a 00                	push   $0x0
  pushl $116
c01027d8:	6a 74                	push   $0x74
  jmp __alltraps
c01027da:	e9 63 06 00 00       	jmp    c0102e42 <__alltraps>

c01027df <vector117>:
.globl vector117
vector117:
  pushl $0
c01027df:	6a 00                	push   $0x0
  pushl $117
c01027e1:	6a 75                	push   $0x75
  jmp __alltraps
c01027e3:	e9 5a 06 00 00       	jmp    c0102e42 <__alltraps>

c01027e8 <vector118>:
.globl vector118
vector118:
  pushl $0
c01027e8:	6a 00                	push   $0x0
  pushl $118
c01027ea:	6a 76                	push   $0x76
  jmp __alltraps
c01027ec:	e9 51 06 00 00       	jmp    c0102e42 <__alltraps>

c01027f1 <vector119>:
.globl vector119
vector119:
  pushl $0
c01027f1:	6a 00                	push   $0x0
  pushl $119
c01027f3:	6a 77                	push   $0x77
  jmp __alltraps
c01027f5:	e9 48 06 00 00       	jmp    c0102e42 <__alltraps>

c01027fa <vector120>:
.globl vector120
vector120:
  pushl $0
c01027fa:	6a 00                	push   $0x0
  pushl $120
c01027fc:	6a 78                	push   $0x78
  jmp __alltraps
c01027fe:	e9 3f 06 00 00       	jmp    c0102e42 <__alltraps>

c0102803 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102803:	6a 00                	push   $0x0
  pushl $121
c0102805:	6a 79                	push   $0x79
  jmp __alltraps
c0102807:	e9 36 06 00 00       	jmp    c0102e42 <__alltraps>

c010280c <vector122>:
.globl vector122
vector122:
  pushl $0
c010280c:	6a 00                	push   $0x0
  pushl $122
c010280e:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102810:	e9 2d 06 00 00       	jmp    c0102e42 <__alltraps>

c0102815 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102815:	6a 00                	push   $0x0
  pushl $123
c0102817:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102819:	e9 24 06 00 00       	jmp    c0102e42 <__alltraps>

c010281e <vector124>:
.globl vector124
vector124:
  pushl $0
c010281e:	6a 00                	push   $0x0
  pushl $124
c0102820:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102822:	e9 1b 06 00 00       	jmp    c0102e42 <__alltraps>

c0102827 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102827:	6a 00                	push   $0x0
  pushl $125
c0102829:	6a 7d                	push   $0x7d
  jmp __alltraps
c010282b:	e9 12 06 00 00       	jmp    c0102e42 <__alltraps>

c0102830 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102830:	6a 00                	push   $0x0
  pushl $126
c0102832:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102834:	e9 09 06 00 00       	jmp    c0102e42 <__alltraps>

c0102839 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102839:	6a 00                	push   $0x0
  pushl $127
c010283b:	6a 7f                	push   $0x7f
  jmp __alltraps
c010283d:	e9 00 06 00 00       	jmp    c0102e42 <__alltraps>

c0102842 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102842:	6a 00                	push   $0x0
  pushl $128
c0102844:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102849:	e9 f4 05 00 00       	jmp    c0102e42 <__alltraps>

c010284e <vector129>:
.globl vector129
vector129:
  pushl $0
c010284e:	6a 00                	push   $0x0
  pushl $129
c0102850:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102855:	e9 e8 05 00 00       	jmp    c0102e42 <__alltraps>

c010285a <vector130>:
.globl vector130
vector130:
  pushl $0
c010285a:	6a 00                	push   $0x0
  pushl $130
c010285c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102861:	e9 dc 05 00 00       	jmp    c0102e42 <__alltraps>

c0102866 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102866:	6a 00                	push   $0x0
  pushl $131
c0102868:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010286d:	e9 d0 05 00 00       	jmp    c0102e42 <__alltraps>

c0102872 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102872:	6a 00                	push   $0x0
  pushl $132
c0102874:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102879:	e9 c4 05 00 00       	jmp    c0102e42 <__alltraps>

c010287e <vector133>:
.globl vector133
vector133:
  pushl $0
c010287e:	6a 00                	push   $0x0
  pushl $133
c0102880:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102885:	e9 b8 05 00 00       	jmp    c0102e42 <__alltraps>

c010288a <vector134>:
.globl vector134
vector134:
  pushl $0
c010288a:	6a 00                	push   $0x0
  pushl $134
c010288c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102891:	e9 ac 05 00 00       	jmp    c0102e42 <__alltraps>

c0102896 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102896:	6a 00                	push   $0x0
  pushl $135
c0102898:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010289d:	e9 a0 05 00 00       	jmp    c0102e42 <__alltraps>

c01028a2 <vector136>:
.globl vector136
vector136:
  pushl $0
c01028a2:	6a 00                	push   $0x0
  pushl $136
c01028a4:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01028a9:	e9 94 05 00 00       	jmp    c0102e42 <__alltraps>

c01028ae <vector137>:
.globl vector137
vector137:
  pushl $0
c01028ae:	6a 00                	push   $0x0
  pushl $137
c01028b0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01028b5:	e9 88 05 00 00       	jmp    c0102e42 <__alltraps>

c01028ba <vector138>:
.globl vector138
vector138:
  pushl $0
c01028ba:	6a 00                	push   $0x0
  pushl $138
c01028bc:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01028c1:	e9 7c 05 00 00       	jmp    c0102e42 <__alltraps>

c01028c6 <vector139>:
.globl vector139
vector139:
  pushl $0
c01028c6:	6a 00                	push   $0x0
  pushl $139
c01028c8:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01028cd:	e9 70 05 00 00       	jmp    c0102e42 <__alltraps>

c01028d2 <vector140>:
.globl vector140
vector140:
  pushl $0
c01028d2:	6a 00                	push   $0x0
  pushl $140
c01028d4:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01028d9:	e9 64 05 00 00       	jmp    c0102e42 <__alltraps>

c01028de <vector141>:
.globl vector141
vector141:
  pushl $0
c01028de:	6a 00                	push   $0x0
  pushl $141
c01028e0:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01028e5:	e9 58 05 00 00       	jmp    c0102e42 <__alltraps>

c01028ea <vector142>:
.globl vector142
vector142:
  pushl $0
c01028ea:	6a 00                	push   $0x0
  pushl $142
c01028ec:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01028f1:	e9 4c 05 00 00       	jmp    c0102e42 <__alltraps>

c01028f6 <vector143>:
.globl vector143
vector143:
  pushl $0
c01028f6:	6a 00                	push   $0x0
  pushl $143
c01028f8:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01028fd:	e9 40 05 00 00       	jmp    c0102e42 <__alltraps>

c0102902 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102902:	6a 00                	push   $0x0
  pushl $144
c0102904:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102909:	e9 34 05 00 00       	jmp    c0102e42 <__alltraps>

c010290e <vector145>:
.globl vector145
vector145:
  pushl $0
c010290e:	6a 00                	push   $0x0
  pushl $145
c0102910:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102915:	e9 28 05 00 00       	jmp    c0102e42 <__alltraps>

c010291a <vector146>:
.globl vector146
vector146:
  pushl $0
c010291a:	6a 00                	push   $0x0
  pushl $146
c010291c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102921:	e9 1c 05 00 00       	jmp    c0102e42 <__alltraps>

c0102926 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102926:	6a 00                	push   $0x0
  pushl $147
c0102928:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010292d:	e9 10 05 00 00       	jmp    c0102e42 <__alltraps>

c0102932 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102932:	6a 00                	push   $0x0
  pushl $148
c0102934:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102939:	e9 04 05 00 00       	jmp    c0102e42 <__alltraps>

c010293e <vector149>:
.globl vector149
vector149:
  pushl $0
c010293e:	6a 00                	push   $0x0
  pushl $149
c0102940:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102945:	e9 f8 04 00 00       	jmp    c0102e42 <__alltraps>

c010294a <vector150>:
.globl vector150
vector150:
  pushl $0
c010294a:	6a 00                	push   $0x0
  pushl $150
c010294c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102951:	e9 ec 04 00 00       	jmp    c0102e42 <__alltraps>

c0102956 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102956:	6a 00                	push   $0x0
  pushl $151
c0102958:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010295d:	e9 e0 04 00 00       	jmp    c0102e42 <__alltraps>

c0102962 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102962:	6a 00                	push   $0x0
  pushl $152
c0102964:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102969:	e9 d4 04 00 00       	jmp    c0102e42 <__alltraps>

c010296e <vector153>:
.globl vector153
vector153:
  pushl $0
c010296e:	6a 00                	push   $0x0
  pushl $153
c0102970:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102975:	e9 c8 04 00 00       	jmp    c0102e42 <__alltraps>

c010297a <vector154>:
.globl vector154
vector154:
  pushl $0
c010297a:	6a 00                	push   $0x0
  pushl $154
c010297c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102981:	e9 bc 04 00 00       	jmp    c0102e42 <__alltraps>

c0102986 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102986:	6a 00                	push   $0x0
  pushl $155
c0102988:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010298d:	e9 b0 04 00 00       	jmp    c0102e42 <__alltraps>

c0102992 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102992:	6a 00                	push   $0x0
  pushl $156
c0102994:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102999:	e9 a4 04 00 00       	jmp    c0102e42 <__alltraps>

c010299e <vector157>:
.globl vector157
vector157:
  pushl $0
c010299e:	6a 00                	push   $0x0
  pushl $157
c01029a0:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01029a5:	e9 98 04 00 00       	jmp    c0102e42 <__alltraps>

c01029aa <vector158>:
.globl vector158
vector158:
  pushl $0
c01029aa:	6a 00                	push   $0x0
  pushl $158
c01029ac:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01029b1:	e9 8c 04 00 00       	jmp    c0102e42 <__alltraps>

c01029b6 <vector159>:
.globl vector159
vector159:
  pushl $0
c01029b6:	6a 00                	push   $0x0
  pushl $159
c01029b8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01029bd:	e9 80 04 00 00       	jmp    c0102e42 <__alltraps>

c01029c2 <vector160>:
.globl vector160
vector160:
  pushl $0
c01029c2:	6a 00                	push   $0x0
  pushl $160
c01029c4:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01029c9:	e9 74 04 00 00       	jmp    c0102e42 <__alltraps>

c01029ce <vector161>:
.globl vector161
vector161:
  pushl $0
c01029ce:	6a 00                	push   $0x0
  pushl $161
c01029d0:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01029d5:	e9 68 04 00 00       	jmp    c0102e42 <__alltraps>

c01029da <vector162>:
.globl vector162
vector162:
  pushl $0
c01029da:	6a 00                	push   $0x0
  pushl $162
c01029dc:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01029e1:	e9 5c 04 00 00       	jmp    c0102e42 <__alltraps>

c01029e6 <vector163>:
.globl vector163
vector163:
  pushl $0
c01029e6:	6a 00                	push   $0x0
  pushl $163
c01029e8:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01029ed:	e9 50 04 00 00       	jmp    c0102e42 <__alltraps>

c01029f2 <vector164>:
.globl vector164
vector164:
  pushl $0
c01029f2:	6a 00                	push   $0x0
  pushl $164
c01029f4:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01029f9:	e9 44 04 00 00       	jmp    c0102e42 <__alltraps>

c01029fe <vector165>:
.globl vector165
vector165:
  pushl $0
c01029fe:	6a 00                	push   $0x0
  pushl $165
c0102a00:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102a05:	e9 38 04 00 00       	jmp    c0102e42 <__alltraps>

c0102a0a <vector166>:
.globl vector166
vector166:
  pushl $0
c0102a0a:	6a 00                	push   $0x0
  pushl $166
c0102a0c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102a11:	e9 2c 04 00 00       	jmp    c0102e42 <__alltraps>

c0102a16 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102a16:	6a 00                	push   $0x0
  pushl $167
c0102a18:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102a1d:	e9 20 04 00 00       	jmp    c0102e42 <__alltraps>

c0102a22 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102a22:	6a 00                	push   $0x0
  pushl $168
c0102a24:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102a29:	e9 14 04 00 00       	jmp    c0102e42 <__alltraps>

c0102a2e <vector169>:
.globl vector169
vector169:
  pushl $0
c0102a2e:	6a 00                	push   $0x0
  pushl $169
c0102a30:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102a35:	e9 08 04 00 00       	jmp    c0102e42 <__alltraps>

c0102a3a <vector170>:
.globl vector170
vector170:
  pushl $0
c0102a3a:	6a 00                	push   $0x0
  pushl $170
c0102a3c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102a41:	e9 fc 03 00 00       	jmp    c0102e42 <__alltraps>

c0102a46 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102a46:	6a 00                	push   $0x0
  pushl $171
c0102a48:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102a4d:	e9 f0 03 00 00       	jmp    c0102e42 <__alltraps>

c0102a52 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102a52:	6a 00                	push   $0x0
  pushl $172
c0102a54:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102a59:	e9 e4 03 00 00       	jmp    c0102e42 <__alltraps>

c0102a5e <vector173>:
.globl vector173
vector173:
  pushl $0
c0102a5e:	6a 00                	push   $0x0
  pushl $173
c0102a60:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102a65:	e9 d8 03 00 00       	jmp    c0102e42 <__alltraps>

c0102a6a <vector174>:
.globl vector174
vector174:
  pushl $0
c0102a6a:	6a 00                	push   $0x0
  pushl $174
c0102a6c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102a71:	e9 cc 03 00 00       	jmp    c0102e42 <__alltraps>

c0102a76 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102a76:	6a 00                	push   $0x0
  pushl $175
c0102a78:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102a7d:	e9 c0 03 00 00       	jmp    c0102e42 <__alltraps>

c0102a82 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102a82:	6a 00                	push   $0x0
  pushl $176
c0102a84:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102a89:	e9 b4 03 00 00       	jmp    c0102e42 <__alltraps>

c0102a8e <vector177>:
.globl vector177
vector177:
  pushl $0
c0102a8e:	6a 00                	push   $0x0
  pushl $177
c0102a90:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102a95:	e9 a8 03 00 00       	jmp    c0102e42 <__alltraps>

c0102a9a <vector178>:
.globl vector178
vector178:
  pushl $0
c0102a9a:	6a 00                	push   $0x0
  pushl $178
c0102a9c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102aa1:	e9 9c 03 00 00       	jmp    c0102e42 <__alltraps>

c0102aa6 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102aa6:	6a 00                	push   $0x0
  pushl $179
c0102aa8:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102aad:	e9 90 03 00 00       	jmp    c0102e42 <__alltraps>

c0102ab2 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102ab2:	6a 00                	push   $0x0
  pushl $180
c0102ab4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102ab9:	e9 84 03 00 00       	jmp    c0102e42 <__alltraps>

c0102abe <vector181>:
.globl vector181
vector181:
  pushl $0
c0102abe:	6a 00                	push   $0x0
  pushl $181
c0102ac0:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102ac5:	e9 78 03 00 00       	jmp    c0102e42 <__alltraps>

c0102aca <vector182>:
.globl vector182
vector182:
  pushl $0
c0102aca:	6a 00                	push   $0x0
  pushl $182
c0102acc:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102ad1:	e9 6c 03 00 00       	jmp    c0102e42 <__alltraps>

c0102ad6 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102ad6:	6a 00                	push   $0x0
  pushl $183
c0102ad8:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102add:	e9 60 03 00 00       	jmp    c0102e42 <__alltraps>

c0102ae2 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102ae2:	6a 00                	push   $0x0
  pushl $184
c0102ae4:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102ae9:	e9 54 03 00 00       	jmp    c0102e42 <__alltraps>

c0102aee <vector185>:
.globl vector185
vector185:
  pushl $0
c0102aee:	6a 00                	push   $0x0
  pushl $185
c0102af0:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102af5:	e9 48 03 00 00       	jmp    c0102e42 <__alltraps>

c0102afa <vector186>:
.globl vector186
vector186:
  pushl $0
c0102afa:	6a 00                	push   $0x0
  pushl $186
c0102afc:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102b01:	e9 3c 03 00 00       	jmp    c0102e42 <__alltraps>

c0102b06 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102b06:	6a 00                	push   $0x0
  pushl $187
c0102b08:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102b0d:	e9 30 03 00 00       	jmp    c0102e42 <__alltraps>

c0102b12 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102b12:	6a 00                	push   $0x0
  pushl $188
c0102b14:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102b19:	e9 24 03 00 00       	jmp    c0102e42 <__alltraps>

c0102b1e <vector189>:
.globl vector189
vector189:
  pushl $0
c0102b1e:	6a 00                	push   $0x0
  pushl $189
c0102b20:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102b25:	e9 18 03 00 00       	jmp    c0102e42 <__alltraps>

c0102b2a <vector190>:
.globl vector190
vector190:
  pushl $0
c0102b2a:	6a 00                	push   $0x0
  pushl $190
c0102b2c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102b31:	e9 0c 03 00 00       	jmp    c0102e42 <__alltraps>

c0102b36 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102b36:	6a 00                	push   $0x0
  pushl $191
c0102b38:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102b3d:	e9 00 03 00 00       	jmp    c0102e42 <__alltraps>

c0102b42 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102b42:	6a 00                	push   $0x0
  pushl $192
c0102b44:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102b49:	e9 f4 02 00 00       	jmp    c0102e42 <__alltraps>

c0102b4e <vector193>:
.globl vector193
vector193:
  pushl $0
c0102b4e:	6a 00                	push   $0x0
  pushl $193
c0102b50:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102b55:	e9 e8 02 00 00       	jmp    c0102e42 <__alltraps>

c0102b5a <vector194>:
.globl vector194
vector194:
  pushl $0
c0102b5a:	6a 00                	push   $0x0
  pushl $194
c0102b5c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102b61:	e9 dc 02 00 00       	jmp    c0102e42 <__alltraps>

c0102b66 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102b66:	6a 00                	push   $0x0
  pushl $195
c0102b68:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102b6d:	e9 d0 02 00 00       	jmp    c0102e42 <__alltraps>

c0102b72 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102b72:	6a 00                	push   $0x0
  pushl $196
c0102b74:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102b79:	e9 c4 02 00 00       	jmp    c0102e42 <__alltraps>

c0102b7e <vector197>:
.globl vector197
vector197:
  pushl $0
c0102b7e:	6a 00                	push   $0x0
  pushl $197
c0102b80:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102b85:	e9 b8 02 00 00       	jmp    c0102e42 <__alltraps>

c0102b8a <vector198>:
.globl vector198
vector198:
  pushl $0
c0102b8a:	6a 00                	push   $0x0
  pushl $198
c0102b8c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102b91:	e9 ac 02 00 00       	jmp    c0102e42 <__alltraps>

c0102b96 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102b96:	6a 00                	push   $0x0
  pushl $199
c0102b98:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102b9d:	e9 a0 02 00 00       	jmp    c0102e42 <__alltraps>

c0102ba2 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102ba2:	6a 00                	push   $0x0
  pushl $200
c0102ba4:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102ba9:	e9 94 02 00 00       	jmp    c0102e42 <__alltraps>

c0102bae <vector201>:
.globl vector201
vector201:
  pushl $0
c0102bae:	6a 00                	push   $0x0
  pushl $201
c0102bb0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102bb5:	e9 88 02 00 00       	jmp    c0102e42 <__alltraps>

c0102bba <vector202>:
.globl vector202
vector202:
  pushl $0
c0102bba:	6a 00                	push   $0x0
  pushl $202
c0102bbc:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102bc1:	e9 7c 02 00 00       	jmp    c0102e42 <__alltraps>

c0102bc6 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102bc6:	6a 00                	push   $0x0
  pushl $203
c0102bc8:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102bcd:	e9 70 02 00 00       	jmp    c0102e42 <__alltraps>

c0102bd2 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102bd2:	6a 00                	push   $0x0
  pushl $204
c0102bd4:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102bd9:	e9 64 02 00 00       	jmp    c0102e42 <__alltraps>

c0102bde <vector205>:
.globl vector205
vector205:
  pushl $0
c0102bde:	6a 00                	push   $0x0
  pushl $205
c0102be0:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102be5:	e9 58 02 00 00       	jmp    c0102e42 <__alltraps>

c0102bea <vector206>:
.globl vector206
vector206:
  pushl $0
c0102bea:	6a 00                	push   $0x0
  pushl $206
c0102bec:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102bf1:	e9 4c 02 00 00       	jmp    c0102e42 <__alltraps>

c0102bf6 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102bf6:	6a 00                	push   $0x0
  pushl $207
c0102bf8:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102bfd:	e9 40 02 00 00       	jmp    c0102e42 <__alltraps>

c0102c02 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102c02:	6a 00                	push   $0x0
  pushl $208
c0102c04:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102c09:	e9 34 02 00 00       	jmp    c0102e42 <__alltraps>

c0102c0e <vector209>:
.globl vector209
vector209:
  pushl $0
c0102c0e:	6a 00                	push   $0x0
  pushl $209
c0102c10:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102c15:	e9 28 02 00 00       	jmp    c0102e42 <__alltraps>

c0102c1a <vector210>:
.globl vector210
vector210:
  pushl $0
c0102c1a:	6a 00                	push   $0x0
  pushl $210
c0102c1c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102c21:	e9 1c 02 00 00       	jmp    c0102e42 <__alltraps>

c0102c26 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102c26:	6a 00                	push   $0x0
  pushl $211
c0102c28:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102c2d:	e9 10 02 00 00       	jmp    c0102e42 <__alltraps>

c0102c32 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102c32:	6a 00                	push   $0x0
  pushl $212
c0102c34:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102c39:	e9 04 02 00 00       	jmp    c0102e42 <__alltraps>

c0102c3e <vector213>:
.globl vector213
vector213:
  pushl $0
c0102c3e:	6a 00                	push   $0x0
  pushl $213
c0102c40:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102c45:	e9 f8 01 00 00       	jmp    c0102e42 <__alltraps>

c0102c4a <vector214>:
.globl vector214
vector214:
  pushl $0
c0102c4a:	6a 00                	push   $0x0
  pushl $214
c0102c4c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102c51:	e9 ec 01 00 00       	jmp    c0102e42 <__alltraps>

c0102c56 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102c56:	6a 00                	push   $0x0
  pushl $215
c0102c58:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102c5d:	e9 e0 01 00 00       	jmp    c0102e42 <__alltraps>

c0102c62 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102c62:	6a 00                	push   $0x0
  pushl $216
c0102c64:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102c69:	e9 d4 01 00 00       	jmp    c0102e42 <__alltraps>

c0102c6e <vector217>:
.globl vector217
vector217:
  pushl $0
c0102c6e:	6a 00                	push   $0x0
  pushl $217
c0102c70:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102c75:	e9 c8 01 00 00       	jmp    c0102e42 <__alltraps>

c0102c7a <vector218>:
.globl vector218
vector218:
  pushl $0
c0102c7a:	6a 00                	push   $0x0
  pushl $218
c0102c7c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102c81:	e9 bc 01 00 00       	jmp    c0102e42 <__alltraps>

c0102c86 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102c86:	6a 00                	push   $0x0
  pushl $219
c0102c88:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102c8d:	e9 b0 01 00 00       	jmp    c0102e42 <__alltraps>

c0102c92 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102c92:	6a 00                	push   $0x0
  pushl $220
c0102c94:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102c99:	e9 a4 01 00 00       	jmp    c0102e42 <__alltraps>

c0102c9e <vector221>:
.globl vector221
vector221:
  pushl $0
c0102c9e:	6a 00                	push   $0x0
  pushl $221
c0102ca0:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102ca5:	e9 98 01 00 00       	jmp    c0102e42 <__alltraps>

c0102caa <vector222>:
.globl vector222
vector222:
  pushl $0
c0102caa:	6a 00                	push   $0x0
  pushl $222
c0102cac:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102cb1:	e9 8c 01 00 00       	jmp    c0102e42 <__alltraps>

c0102cb6 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102cb6:	6a 00                	push   $0x0
  pushl $223
c0102cb8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102cbd:	e9 80 01 00 00       	jmp    c0102e42 <__alltraps>

c0102cc2 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102cc2:	6a 00                	push   $0x0
  pushl $224
c0102cc4:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102cc9:	e9 74 01 00 00       	jmp    c0102e42 <__alltraps>

c0102cce <vector225>:
.globl vector225
vector225:
  pushl $0
c0102cce:	6a 00                	push   $0x0
  pushl $225
c0102cd0:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102cd5:	e9 68 01 00 00       	jmp    c0102e42 <__alltraps>

c0102cda <vector226>:
.globl vector226
vector226:
  pushl $0
c0102cda:	6a 00                	push   $0x0
  pushl $226
c0102cdc:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102ce1:	e9 5c 01 00 00       	jmp    c0102e42 <__alltraps>

c0102ce6 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102ce6:	6a 00                	push   $0x0
  pushl $227
c0102ce8:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102ced:	e9 50 01 00 00       	jmp    c0102e42 <__alltraps>

c0102cf2 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102cf2:	6a 00                	push   $0x0
  pushl $228
c0102cf4:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102cf9:	e9 44 01 00 00       	jmp    c0102e42 <__alltraps>

c0102cfe <vector229>:
.globl vector229
vector229:
  pushl $0
c0102cfe:	6a 00                	push   $0x0
  pushl $229
c0102d00:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102d05:	e9 38 01 00 00       	jmp    c0102e42 <__alltraps>

c0102d0a <vector230>:
.globl vector230
vector230:
  pushl $0
c0102d0a:	6a 00                	push   $0x0
  pushl $230
c0102d0c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102d11:	e9 2c 01 00 00       	jmp    c0102e42 <__alltraps>

c0102d16 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102d16:	6a 00                	push   $0x0
  pushl $231
c0102d18:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102d1d:	e9 20 01 00 00       	jmp    c0102e42 <__alltraps>

c0102d22 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102d22:	6a 00                	push   $0x0
  pushl $232
c0102d24:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102d29:	e9 14 01 00 00       	jmp    c0102e42 <__alltraps>

c0102d2e <vector233>:
.globl vector233
vector233:
  pushl $0
c0102d2e:	6a 00                	push   $0x0
  pushl $233
c0102d30:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102d35:	e9 08 01 00 00       	jmp    c0102e42 <__alltraps>

c0102d3a <vector234>:
.globl vector234
vector234:
  pushl $0
c0102d3a:	6a 00                	push   $0x0
  pushl $234
c0102d3c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102d41:	e9 fc 00 00 00       	jmp    c0102e42 <__alltraps>

c0102d46 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102d46:	6a 00                	push   $0x0
  pushl $235
c0102d48:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102d4d:	e9 f0 00 00 00       	jmp    c0102e42 <__alltraps>

c0102d52 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102d52:	6a 00                	push   $0x0
  pushl $236
c0102d54:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102d59:	e9 e4 00 00 00       	jmp    c0102e42 <__alltraps>

c0102d5e <vector237>:
.globl vector237
vector237:
  pushl $0
c0102d5e:	6a 00                	push   $0x0
  pushl $237
c0102d60:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102d65:	e9 d8 00 00 00       	jmp    c0102e42 <__alltraps>

c0102d6a <vector238>:
.globl vector238
vector238:
  pushl $0
c0102d6a:	6a 00                	push   $0x0
  pushl $238
c0102d6c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102d71:	e9 cc 00 00 00       	jmp    c0102e42 <__alltraps>

c0102d76 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102d76:	6a 00                	push   $0x0
  pushl $239
c0102d78:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102d7d:	e9 c0 00 00 00       	jmp    c0102e42 <__alltraps>

c0102d82 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102d82:	6a 00                	push   $0x0
  pushl $240
c0102d84:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102d89:	e9 b4 00 00 00       	jmp    c0102e42 <__alltraps>

c0102d8e <vector241>:
.globl vector241
vector241:
  pushl $0
c0102d8e:	6a 00                	push   $0x0
  pushl $241
c0102d90:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102d95:	e9 a8 00 00 00       	jmp    c0102e42 <__alltraps>

c0102d9a <vector242>:
.globl vector242
vector242:
  pushl $0
c0102d9a:	6a 00                	push   $0x0
  pushl $242
c0102d9c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102da1:	e9 9c 00 00 00       	jmp    c0102e42 <__alltraps>

c0102da6 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102da6:	6a 00                	push   $0x0
  pushl $243
c0102da8:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102dad:	e9 90 00 00 00       	jmp    c0102e42 <__alltraps>

c0102db2 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102db2:	6a 00                	push   $0x0
  pushl $244
c0102db4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102db9:	e9 84 00 00 00       	jmp    c0102e42 <__alltraps>

c0102dbe <vector245>:
.globl vector245
vector245:
  pushl $0
c0102dbe:	6a 00                	push   $0x0
  pushl $245
c0102dc0:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102dc5:	e9 78 00 00 00       	jmp    c0102e42 <__alltraps>

c0102dca <vector246>:
.globl vector246
vector246:
  pushl $0
c0102dca:	6a 00                	push   $0x0
  pushl $246
c0102dcc:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102dd1:	e9 6c 00 00 00       	jmp    c0102e42 <__alltraps>

c0102dd6 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102dd6:	6a 00                	push   $0x0
  pushl $247
c0102dd8:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102ddd:	e9 60 00 00 00       	jmp    c0102e42 <__alltraps>

c0102de2 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102de2:	6a 00                	push   $0x0
  pushl $248
c0102de4:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102de9:	e9 54 00 00 00       	jmp    c0102e42 <__alltraps>

c0102dee <vector249>:
.globl vector249
vector249:
  pushl $0
c0102dee:	6a 00                	push   $0x0
  pushl $249
c0102df0:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102df5:	e9 48 00 00 00       	jmp    c0102e42 <__alltraps>

c0102dfa <vector250>:
.globl vector250
vector250:
  pushl $0
c0102dfa:	6a 00                	push   $0x0
  pushl $250
c0102dfc:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102e01:	e9 3c 00 00 00       	jmp    c0102e42 <__alltraps>

c0102e06 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102e06:	6a 00                	push   $0x0
  pushl $251
c0102e08:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102e0d:	e9 30 00 00 00       	jmp    c0102e42 <__alltraps>

c0102e12 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102e12:	6a 00                	push   $0x0
  pushl $252
c0102e14:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102e19:	e9 24 00 00 00       	jmp    c0102e42 <__alltraps>

c0102e1e <vector253>:
.globl vector253
vector253:
  pushl $0
c0102e1e:	6a 00                	push   $0x0
  pushl $253
c0102e20:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102e25:	e9 18 00 00 00       	jmp    c0102e42 <__alltraps>

c0102e2a <vector254>:
.globl vector254
vector254:
  pushl $0
c0102e2a:	6a 00                	push   $0x0
  pushl $254
c0102e2c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102e31:	e9 0c 00 00 00       	jmp    c0102e42 <__alltraps>

c0102e36 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102e36:	6a 00                	push   $0x0
  pushl $255
c0102e38:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102e3d:	e9 00 00 00 00       	jmp    c0102e42 <__alltraps>

c0102e42 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102e42:	1e                   	push   %ds
    pushl %es
c0102e43:	06                   	push   %es
    pushl %fs
c0102e44:	0f a0                	push   %fs
    pushl %gs
c0102e46:	0f a8                	push   %gs
    pushal
c0102e48:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102e49:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102e4e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102e50:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102e52:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102e53:	e8 57 f5 ff ff       	call   c01023af <trap>

    # pop the pushed stack pointer
    popl %esp
c0102e58:	5c                   	pop    %esp

c0102e59 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102e59:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102e5a:	0f a9                	pop    %gs
    popl %fs
c0102e5c:	0f a1                	pop    %fs
    popl %es
c0102e5e:	07                   	pop    %es
    popl %ds
c0102e5f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102e60:	83 c4 08             	add    $0x8,%esp
    iret
c0102e63:	cf                   	iret   

c0102e64 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102e64:	55                   	push   %ebp
c0102e65:	89 e5                	mov    %esp,%ebp
c0102e67:	e8 46 d4 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102e6c:	05 e4 5a 01 00       	add    $0x15ae4,%eax
    return page - pages;
c0102e71:	8b 55 08             	mov    0x8(%ebp),%edx
c0102e74:	c7 c0 78 bf 11 c0    	mov    $0xc011bf78,%eax
c0102e7a:	8b 00                	mov    (%eax),%eax
c0102e7c:	29 c2                	sub    %eax,%edx
c0102e7e:	89 d0                	mov    %edx,%eax
c0102e80:	c1 f8 02             	sar    $0x2,%eax
c0102e83:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102e89:	5d                   	pop    %ebp
c0102e8a:	c3                   	ret    

c0102e8b <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102e8b:	55                   	push   %ebp
c0102e8c:	89 e5                	mov    %esp,%ebp
c0102e8e:	e8 1f d4 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102e93:	05 bd 5a 01 00       	add    $0x15abd,%eax
    return page2ppn(page) << PGSHIFT;
c0102e98:	ff 75 08             	pushl  0x8(%ebp)
c0102e9b:	e8 c4 ff ff ff       	call   c0102e64 <page2ppn>
c0102ea0:	83 c4 04             	add    $0x4,%esp
c0102ea3:	c1 e0 0c             	shl    $0xc,%eax
}
c0102ea6:	c9                   	leave  
c0102ea7:	c3                   	ret    

c0102ea8 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102ea8:	55                   	push   %ebp
c0102ea9:	89 e5                	mov    %esp,%ebp
c0102eab:	53                   	push   %ebx
c0102eac:	83 ec 04             	sub    $0x4,%esp
c0102eaf:	e8 fe d3 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102eb4:	05 9c 5a 01 00       	add    $0x15a9c,%eax
    if (PPN(pa) >= npage) {
c0102eb9:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ebc:	89 d1                	mov    %edx,%ecx
c0102ebe:	c1 e9 0c             	shr    $0xc,%ecx
c0102ec1:	8b 90 30 35 00 00    	mov    0x3530(%eax),%edx
c0102ec7:	39 d1                	cmp    %edx,%ecx
c0102ec9:	72 1a                	jb     c0102ee5 <pa2page+0x3d>
        panic("pa2page called with invalid pa");
c0102ecb:	83 ec 04             	sub    $0x4,%esp
c0102ece:	8d 90 2c e4 fe ff    	lea    -0x11bd4(%eax),%edx
c0102ed4:	52                   	push   %edx
c0102ed5:	6a 5a                	push   $0x5a
c0102ed7:	8d 90 4b e4 fe ff    	lea    -0x11bb5(%eax),%edx
c0102edd:	52                   	push   %edx
c0102ede:	89 c3                	mov    %eax,%ebx
c0102ee0:	e8 f4 d5 ff ff       	call   c01004d9 <__panic>
    }
    return &pages[PPN(pa)];
c0102ee5:	c7 c0 78 bf 11 c0    	mov    $0xc011bf78,%eax
c0102eeb:	8b 08                	mov    (%eax),%ecx
c0102eed:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ef0:	c1 e8 0c             	shr    $0xc,%eax
c0102ef3:	89 c2                	mov    %eax,%edx
c0102ef5:	89 d0                	mov    %edx,%eax
c0102ef7:	c1 e0 02             	shl    $0x2,%eax
c0102efa:	01 d0                	add    %edx,%eax
c0102efc:	c1 e0 02             	shl    $0x2,%eax
c0102eff:	01 c8                	add    %ecx,%eax
}
c0102f01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102f04:	c9                   	leave  
c0102f05:	c3                   	ret    

c0102f06 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102f06:	55                   	push   %ebp
c0102f07:	89 e5                	mov    %esp,%ebp
c0102f09:	53                   	push   %ebx
c0102f0a:	83 ec 14             	sub    $0x14,%esp
c0102f0d:	e8 a4 d3 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0102f12:	81 c3 3e 5a 01 00    	add    $0x15a3e,%ebx
    return KADDR(page2pa(page));
c0102f18:	ff 75 08             	pushl  0x8(%ebp)
c0102f1b:	e8 6b ff ff ff       	call   c0102e8b <page2pa>
c0102f20:	83 c4 04             	add    $0x4,%esp
c0102f23:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f29:	c1 e8 0c             	shr    $0xc,%eax
c0102f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f2f:	8b 83 30 35 00 00    	mov    0x3530(%ebx),%eax
c0102f35:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102f38:	72 18                	jb     c0102f52 <page2kva+0x4c>
c0102f3a:	ff 75 f4             	pushl  -0xc(%ebp)
c0102f3d:	8d 83 5c e4 fe ff    	lea    -0x11ba4(%ebx),%eax
c0102f43:	50                   	push   %eax
c0102f44:	6a 61                	push   $0x61
c0102f46:	8d 83 4b e4 fe ff    	lea    -0x11bb5(%ebx),%eax
c0102f4c:	50                   	push   %eax
c0102f4d:	e8 87 d5 ff ff       	call   c01004d9 <__panic>
c0102f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f55:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102f5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102f5d:	c9                   	leave  
c0102f5e:	c3                   	ret    

c0102f5f <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102f5f:	55                   	push   %ebp
c0102f60:	89 e5                	mov    %esp,%ebp
c0102f62:	53                   	push   %ebx
c0102f63:	83 ec 04             	sub    $0x4,%esp
c0102f66:	e8 47 d3 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102f6b:	05 e5 59 01 00       	add    $0x159e5,%eax
    if (!(pte & PTE_P)) {
c0102f70:	8b 55 08             	mov    0x8(%ebp),%edx
c0102f73:	83 e2 01             	and    $0x1,%edx
c0102f76:	85 d2                	test   %edx,%edx
c0102f78:	75 1a                	jne    c0102f94 <pte2page+0x35>
        panic("pte2page called with invalid pte");
c0102f7a:	83 ec 04             	sub    $0x4,%esp
c0102f7d:	8d 90 80 e4 fe ff    	lea    -0x11b80(%eax),%edx
c0102f83:	52                   	push   %edx
c0102f84:	6a 6c                	push   $0x6c
c0102f86:	8d 90 4b e4 fe ff    	lea    -0x11bb5(%eax),%edx
c0102f8c:	52                   	push   %edx
c0102f8d:	89 c3                	mov    %eax,%ebx
c0102f8f:	e8 45 d5 ff ff       	call   c01004d9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102f94:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f97:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102f9c:	83 ec 0c             	sub    $0xc,%esp
c0102f9f:	50                   	push   %eax
c0102fa0:	e8 03 ff ff ff       	call   c0102ea8 <pa2page>
c0102fa5:	83 c4 10             	add    $0x10,%esp
}
c0102fa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102fab:	c9                   	leave  
c0102fac:	c3                   	ret    

c0102fad <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102fad:	55                   	push   %ebp
c0102fae:	89 e5                	mov    %esp,%ebp
c0102fb0:	83 ec 08             	sub    $0x8,%esp
c0102fb3:	e8 fa d2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102fb8:	05 98 59 01 00       	add    $0x15998,%eax
    return pa2page(PDE_ADDR(pde));
c0102fbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fc0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102fc5:	83 ec 0c             	sub    $0xc,%esp
c0102fc8:	50                   	push   %eax
c0102fc9:	e8 da fe ff ff       	call   c0102ea8 <pa2page>
c0102fce:	83 c4 10             	add    $0x10,%esp
}
c0102fd1:	c9                   	leave  
c0102fd2:	c3                   	ret    

c0102fd3 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102fd3:	55                   	push   %ebp
c0102fd4:	89 e5                	mov    %esp,%ebp
c0102fd6:	e8 d7 d2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102fdb:	05 75 59 01 00       	add    $0x15975,%eax
    return page->ref;
c0102fe0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fe3:	8b 00                	mov    (%eax),%eax
}
c0102fe5:	5d                   	pop    %ebp
c0102fe6:	c3                   	ret    

c0102fe7 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102fe7:	55                   	push   %ebp
c0102fe8:	89 e5                	mov    %esp,%ebp
c0102fea:	e8 c3 d2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0102fef:	05 61 59 01 00       	add    $0x15961,%eax
    page->ref = val;
c0102ff4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ff7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ffa:	89 10                	mov    %edx,(%eax)
}
c0102ffc:	90                   	nop
c0102ffd:	5d                   	pop    %ebp
c0102ffe:	c3                   	ret    

c0102fff <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102fff:	55                   	push   %ebp
c0103000:	89 e5                	mov    %esp,%ebp
c0103002:	e8 ab d2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0103007:	05 49 59 01 00       	add    $0x15949,%eax
    page->ref += 1;
c010300c:	8b 45 08             	mov    0x8(%ebp),%eax
c010300f:	8b 00                	mov    (%eax),%eax
c0103011:	8d 50 01             	lea    0x1(%eax),%edx
c0103014:	8b 45 08             	mov    0x8(%ebp),%eax
c0103017:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103019:	8b 45 08             	mov    0x8(%ebp),%eax
c010301c:	8b 00                	mov    (%eax),%eax
}
c010301e:	5d                   	pop    %ebp
c010301f:	c3                   	ret    

c0103020 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103020:	55                   	push   %ebp
c0103021:	89 e5                	mov    %esp,%ebp
c0103023:	e8 8a d2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0103028:	05 28 59 01 00       	add    $0x15928,%eax
    page->ref -= 1;
c010302d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103030:	8b 00                	mov    (%eax),%eax
c0103032:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103035:	8b 45 08             	mov    0x8(%ebp),%eax
c0103038:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010303a:	8b 45 08             	mov    0x8(%ebp),%eax
c010303d:	8b 00                	mov    (%eax),%eax
}
c010303f:	5d                   	pop    %ebp
c0103040:	c3                   	ret    

c0103041 <__intr_save>:
__intr_save(void) {
c0103041:	55                   	push   %ebp
c0103042:	89 e5                	mov    %esp,%ebp
c0103044:	53                   	push   %ebx
c0103045:	83 ec 14             	sub    $0x14,%esp
c0103048:	e8 65 d2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010304d:	05 03 59 01 00       	add    $0x15903,%eax
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103052:	9c                   	pushf  
c0103053:	5a                   	pop    %edx
c0103054:	89 55 f4             	mov    %edx,-0xc(%ebp)
    return eflags;
c0103057:	8b 55 f4             	mov    -0xc(%ebp),%edx
    if (read_eflags() & FL_IF) {
c010305a:	81 e2 00 02 00 00    	and    $0x200,%edx
c0103060:	85 d2                	test   %edx,%edx
c0103062:	74 0e                	je     c0103072 <__intr_save+0x31>
        intr_disable();
c0103064:	89 c3                	mov    %eax,%ebx
c0103066:	e8 b5 eb ff ff       	call   c0101c20 <intr_disable>
        return 1;
c010306b:	b8 01 00 00 00       	mov    $0x1,%eax
c0103070:	eb 05                	jmp    c0103077 <__intr_save+0x36>
    return 0;
c0103072:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103077:	83 c4 14             	add    $0x14,%esp
c010307a:	5b                   	pop    %ebx
c010307b:	5d                   	pop    %ebp
c010307c:	c3                   	ret    

c010307d <__intr_restore>:
__intr_restore(bool flag) {
c010307d:	55                   	push   %ebp
c010307e:	89 e5                	mov    %esp,%ebp
c0103080:	53                   	push   %ebx
c0103081:	83 ec 04             	sub    $0x4,%esp
c0103084:	e8 29 d2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0103089:	05 c7 58 01 00       	add    $0x158c7,%eax
    if (flag) {
c010308e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103092:	74 07                	je     c010309b <__intr_restore+0x1e>
        intr_enable();
c0103094:	89 c3                	mov    %eax,%ebx
c0103096:	e8 74 eb ff ff       	call   c0101c0f <intr_enable>
}
c010309b:	90                   	nop
c010309c:	83 c4 04             	add    $0x4,%esp
c010309f:	5b                   	pop    %ebx
c01030a0:	5d                   	pop    %ebp
c01030a1:	c3                   	ret    

c01030a2 <lgdt>:
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd)
{
c01030a2:	55                   	push   %ebp
c01030a3:	89 e5                	mov    %esp,%ebp
c01030a5:	e8 08 d2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01030aa:	05 a6 58 01 00       	add    $0x158a6,%eax
    asm volatile("lgdt (%0)" ::"r"(pd));
c01030af:	8b 45 08             	mov    0x8(%ebp),%eax
c01030b2:	0f 01 10             	lgdtl  (%eax)
    asm volatile("movw %%ax, %%gs" ::"a"(USER_DS));
c01030b5:	b8 23 00 00 00       	mov    $0x23,%eax
c01030ba:	8e e8                	mov    %eax,%gs
    asm volatile("movw %%ax, %%fs" ::"a"(USER_DS));
c01030bc:	b8 23 00 00 00       	mov    $0x23,%eax
c01030c1:	8e e0                	mov    %eax,%fs
    asm volatile("movw %%ax, %%es" ::"a"(KERNEL_DS));
c01030c3:	b8 10 00 00 00       	mov    $0x10,%eax
c01030c8:	8e c0                	mov    %eax,%es
    asm volatile("movw %%ax, %%ds" ::"a"(KERNEL_DS));
c01030ca:	b8 10 00 00 00       	mov    $0x10,%eax
c01030cf:	8e d8                	mov    %eax,%ds
    asm volatile("movw %%ax, %%ss" ::"a"(KERNEL_DS));
c01030d1:	b8 10 00 00 00       	mov    $0x10,%eax
c01030d6:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile("ljmp %0, $1f\n 1:\n" ::"i"(KERNEL_CS));
c01030d8:	ea df 30 10 c0 08 00 	ljmp   $0x8,$0xc01030df
}
c01030df:	90                   	nop
c01030e0:	5d                   	pop    %ebp
c01030e1:	c3                   	ret    

c01030e2 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void load_esp0(uintptr_t esp0)
{
c01030e2:	55                   	push   %ebp
c01030e3:	89 e5                	mov    %esp,%ebp
c01030e5:	e8 c8 d1 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01030ea:	05 66 58 01 00       	add    $0x15866,%eax
    ts.ts_esp0 = esp0;
c01030ef:	8b 55 08             	mov    0x8(%ebp),%edx
c01030f2:	89 90 54 35 00 00    	mov    %edx,0x3554(%eax)
}
c01030f8:	90                   	nop
c01030f9:	5d                   	pop    %ebp
c01030fa:	c3                   	ret    

c01030fb <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void)
{
c01030fb:	55                   	push   %ebp
c01030fc:	89 e5                	mov    %esp,%ebp
c01030fe:	53                   	push   %ebx
c01030ff:	83 ec 10             	sub    $0x10,%esp
c0103102:	e8 af d1 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0103107:	81 c3 49 58 01 00    	add    $0x15849,%ebx
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c010310d:	c7 c0 00 80 11 c0    	mov    $0xc0118000,%eax
c0103113:	50                   	push   %eax
c0103114:	e8 c9 ff ff ff       	call   c01030e2 <load_esp0>
c0103119:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c010311c:	66 c7 83 58 35 00 00 	movw   $0x10,0x3558(%ebx)
c0103123:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103125:	66 c7 83 f8 ff ff ff 	movw   $0x68,-0x8(%ebx)
c010312c:	68 00 
c010312e:	8d 83 50 35 00 00    	lea    0x3550(%ebx),%eax
c0103134:	66 89 83 fa ff ff ff 	mov    %ax,-0x6(%ebx)
c010313b:	8d 83 50 35 00 00    	lea    0x3550(%ebx),%eax
c0103141:	c1 e8 10             	shr    $0x10,%eax
c0103144:	88 83 fc ff ff ff    	mov    %al,-0x4(%ebx)
c010314a:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
c0103151:	83 e0 f0             	and    $0xfffffff0,%eax
c0103154:	83 c8 09             	or     $0x9,%eax
c0103157:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
c010315d:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
c0103164:	83 e0 ef             	and    $0xffffffef,%eax
c0103167:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
c010316d:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
c0103174:	83 e0 9f             	and    $0xffffff9f,%eax
c0103177:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
c010317d:	0f b6 83 fd ff ff ff 	movzbl -0x3(%ebx),%eax
c0103184:	83 c8 80             	or     $0xffffff80,%eax
c0103187:	88 83 fd ff ff ff    	mov    %al,-0x3(%ebx)
c010318d:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c0103194:	83 e0 f0             	and    $0xfffffff0,%eax
c0103197:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c010319d:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c01031a4:	83 e0 ef             	and    $0xffffffef,%eax
c01031a7:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c01031ad:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c01031b4:	83 e0 df             	and    $0xffffffdf,%eax
c01031b7:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c01031bd:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c01031c4:	83 c8 40             	or     $0x40,%eax
c01031c7:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c01031cd:	0f b6 83 fe ff ff ff 	movzbl -0x2(%ebx),%eax
c01031d4:	83 e0 7f             	and    $0x7f,%eax
c01031d7:	88 83 fe ff ff ff    	mov    %al,-0x2(%ebx)
c01031dd:	8d 83 50 35 00 00    	lea    0x3550(%ebx),%eax
c01031e3:	c1 e8 18             	shr    $0x18,%eax
c01031e6:	88 83 ff ff ff ff    	mov    %al,-0x1(%ebx)

    // reload all segment registers
    lgdt(&gdt_pd);
c01031ec:	8d 83 d0 00 00 00    	lea    0xd0(%ebx),%eax
c01031f2:	50                   	push   %eax
c01031f3:	e8 aa fe ff ff       	call   c01030a2 <lgdt>
c01031f8:	83 c4 04             	add    $0x4,%esp
c01031fb:	66 c7 45 fa 28 00    	movw   $0x28,-0x6(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103201:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0103205:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103208:	90                   	nop
c0103209:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010320c:	c9                   	leave  
c010320d:	c3                   	ret    

c010320e <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void)
{
c010320e:	55                   	push   %ebp
c010320f:	89 e5                	mov    %esp,%ebp
c0103211:	53                   	push   %ebx
c0103212:	83 ec 04             	sub    $0x4,%esp
c0103215:	e8 9c d0 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c010321a:	81 c3 36 57 01 00    	add    $0x15736,%ebx
    pmm_manager = &default_pmm_manager;
c0103220:	c7 c0 70 bf 11 c0    	mov    $0xc011bf70,%eax
c0103226:	c7 c2 90 8a 11 c0    	mov    $0xc0118a90,%edx
c010322c:	89 10                	mov    %edx,(%eax)
    cprintf("memory management: %s\n", pmm_manager->name);
c010322e:	c7 c0 70 bf 11 c0    	mov    $0xc011bf70,%eax
c0103234:	8b 00                	mov    (%eax),%eax
c0103236:	8b 00                	mov    (%eax),%eax
c0103238:	83 ec 08             	sub    $0x8,%esp
c010323b:	50                   	push   %eax
c010323c:	8d 83 ac e4 fe ff    	lea    -0x11b54(%ebx),%eax
c0103242:	50                   	push   %eax
c0103243:	e8 e1 d0 ff ff       	call   c0100329 <cprintf>
c0103248:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c010324b:	c7 c0 70 bf 11 c0    	mov    $0xc011bf70,%eax
c0103251:	8b 00                	mov    (%eax),%eax
c0103253:	8b 40 04             	mov    0x4(%eax),%eax
c0103256:	ff d0                	call   *%eax
}
c0103258:	90                   	nop
c0103259:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010325c:	c9                   	leave  
c010325d:	c3                   	ret    

c010325e <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory
static void
init_memmap(struct Page *base, size_t n)
{
c010325e:	55                   	push   %ebp
c010325f:	89 e5                	mov    %esp,%ebp
c0103261:	83 ec 08             	sub    $0x8,%esp
c0103264:	e8 49 d0 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0103269:	05 e7 56 01 00       	add    $0x156e7,%eax
    pmm_manager->init_memmap(base, n);
c010326e:	c7 c0 70 bf 11 c0    	mov    $0xc011bf70,%eax
c0103274:	8b 00                	mov    (%eax),%eax
c0103276:	8b 40 08             	mov    0x8(%eax),%eax
c0103279:	83 ec 08             	sub    $0x8,%esp
c010327c:	ff 75 0c             	pushl  0xc(%ebp)
c010327f:	ff 75 08             	pushl  0x8(%ebp)
c0103282:	ff d0                	call   *%eax
c0103284:	83 c4 10             	add    $0x10,%esp
}
c0103287:	90                   	nop
c0103288:	c9                   	leave  
c0103289:	c3                   	ret    

c010328a <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory
struct Page *
alloc_pages(size_t n)
{
c010328a:	55                   	push   %ebp
c010328b:	89 e5                	mov    %esp,%ebp
c010328d:	53                   	push   %ebx
c010328e:	83 ec 14             	sub    $0x14,%esp
c0103291:	e8 20 d0 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0103296:	81 c3 ba 56 01 00    	add    $0x156ba,%ebx
    struct Page *page = NULL;
c010329c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01032a3:	e8 99 fd ff ff       	call   c0103041 <__intr_save>
c01032a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c01032ab:	c7 c0 70 bf 11 c0    	mov    $0xc011bf70,%eax
c01032b1:	8b 00                	mov    (%eax),%eax
c01032b3:	8b 40 0c             	mov    0xc(%eax),%eax
c01032b6:	83 ec 0c             	sub    $0xc,%esp
c01032b9:	ff 75 08             	pushl  0x8(%ebp)
c01032bc:	ff d0                	call   *%eax
c01032be:	83 c4 10             	add    $0x10,%esp
c01032c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c01032c4:	83 ec 0c             	sub    $0xc,%esp
c01032c7:	ff 75 f0             	pushl  -0x10(%ebp)
c01032ca:	e8 ae fd ff ff       	call   c010307d <__intr_restore>
c01032cf:	83 c4 10             	add    $0x10,%esp
    return page;
c01032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01032d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01032d8:	c9                   	leave  
c01032d9:	c3                   	ret    

c01032da <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n)
{
c01032da:	55                   	push   %ebp
c01032db:	89 e5                	mov    %esp,%ebp
c01032dd:	53                   	push   %ebx
c01032de:	83 ec 14             	sub    $0x14,%esp
c01032e1:	e8 d0 cf ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c01032e6:	81 c3 6a 56 01 00    	add    $0x1566a,%ebx
    bool intr_flag;
    local_intr_save(intr_flag);
c01032ec:	e8 50 fd ff ff       	call   c0103041 <__intr_save>
c01032f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01032f4:	c7 c0 70 bf 11 c0    	mov    $0xc011bf70,%eax
c01032fa:	8b 00                	mov    (%eax),%eax
c01032fc:	8b 40 10             	mov    0x10(%eax),%eax
c01032ff:	83 ec 08             	sub    $0x8,%esp
c0103302:	ff 75 0c             	pushl  0xc(%ebp)
c0103305:	ff 75 08             	pushl  0x8(%ebp)
c0103308:	ff d0                	call   *%eax
c010330a:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c010330d:	83 ec 0c             	sub    $0xc,%esp
c0103310:	ff 75 f4             	pushl  -0xc(%ebp)
c0103313:	e8 65 fd ff ff       	call   c010307d <__intr_restore>
c0103318:	83 c4 10             	add    $0x10,%esp
}
c010331b:	90                   	nop
c010331c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010331f:	c9                   	leave  
c0103320:	c3                   	ret    

c0103321 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
//of current free memory
size_t
nr_free_pages(void)
{
c0103321:	55                   	push   %ebp
c0103322:	89 e5                	mov    %esp,%ebp
c0103324:	53                   	push   %ebx
c0103325:	83 ec 14             	sub    $0x14,%esp
c0103328:	e8 89 cf ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c010332d:	81 c3 23 56 01 00    	add    $0x15623,%ebx
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103333:	e8 09 fd ff ff       	call   c0103041 <__intr_save>
c0103338:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c010333b:	c7 c0 70 bf 11 c0    	mov    $0xc011bf70,%eax
c0103341:	8b 00                	mov    (%eax),%eax
c0103343:	8b 40 14             	mov    0x14(%eax),%eax
c0103346:	ff d0                	call   *%eax
c0103348:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c010334b:	83 ec 0c             	sub    $0xc,%esp
c010334e:	ff 75 f4             	pushl  -0xc(%ebp)
c0103351:	e8 27 fd ff ff       	call   c010307d <__intr_restore>
c0103356:	83 c4 10             	add    $0x10,%esp
    return ret;
c0103359:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010335c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010335f:	c9                   	leave  
c0103360:	c3                   	ret    

c0103361 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void)
{
c0103361:	55                   	push   %ebp
c0103362:	89 e5                	mov    %esp,%ebp
c0103364:	57                   	push   %edi
c0103365:	56                   	push   %esi
c0103366:	53                   	push   %ebx
c0103367:	83 ec 7c             	sub    $0x7c,%esp
c010336a:	e8 cf 15 00 00       	call   c010493e <__x86.get_pc_thunk.si>
c010336f:	81 c6 e1 55 01 00    	add    $0x155e1,%esi
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103375:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c010337c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103383:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c010338a:	83 ec 0c             	sub    $0xc,%esp
c010338d:	8d 86 c3 e4 fe ff    	lea    -0x11b3d(%esi),%eax
c0103393:	50                   	push   %eax
c0103394:	89 f3                	mov    %esi,%ebx
c0103396:	e8 8e cf ff ff       	call   c0100329 <cprintf>
c010339b:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i++)
c010339e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01033a5:	e9 02 01 00 00       	jmp    c01034ac <page_init+0x14b>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01033aa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01033ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01033b0:	89 d0                	mov    %edx,%eax
c01033b2:	c1 e0 02             	shl    $0x2,%eax
c01033b5:	01 d0                	add    %edx,%eax
c01033b7:	c1 e0 02             	shl    $0x2,%eax
c01033ba:	01 c8                	add    %ecx,%eax
c01033bc:	8b 50 08             	mov    0x8(%eax),%edx
c01033bf:	8b 40 04             	mov    0x4(%eax),%eax
c01033c2:	89 45 a0             	mov    %eax,-0x60(%ebp)
c01033c5:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c01033c8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01033cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01033ce:	89 d0                	mov    %edx,%eax
c01033d0:	c1 e0 02             	shl    $0x2,%eax
c01033d3:	01 d0                	add    %edx,%eax
c01033d5:	c1 e0 02             	shl    $0x2,%eax
c01033d8:	01 c8                	add    %ecx,%eax
c01033da:	8b 48 0c             	mov    0xc(%eax),%ecx
c01033dd:	8b 58 10             	mov    0x10(%eax),%ebx
c01033e0:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01033e3:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01033e6:	01 c8                	add    %ecx,%eax
c01033e8:	11 da                	adc    %ebx,%edx
c01033ea:	89 45 98             	mov    %eax,-0x68(%ebp)
c01033ed:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c01033f0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01033f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01033f6:	89 d0                	mov    %edx,%eax
c01033f8:	c1 e0 02             	shl    $0x2,%eax
c01033fb:	01 d0                	add    %edx,%eax
c01033fd:	c1 e0 02             	shl    $0x2,%eax
c0103400:	01 c8                	add    %ecx,%eax
c0103402:	83 c0 14             	add    $0x14,%eax
c0103405:	8b 00                	mov    (%eax),%eax
c0103407:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c010340d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103410:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103413:	83 c0 ff             	add    $0xffffffff,%eax
c0103416:	83 d2 ff             	adc    $0xffffffff,%edx
c0103419:	89 c1                	mov    %eax,%ecx
c010341b:	89 d3                	mov    %edx,%ebx
c010341d:	8b 7d c4             	mov    -0x3c(%ebp),%edi
c0103420:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103423:	89 d0                	mov    %edx,%eax
c0103425:	c1 e0 02             	shl    $0x2,%eax
c0103428:	01 d0                	add    %edx,%eax
c010342a:	c1 e0 02             	shl    $0x2,%eax
c010342d:	01 f8                	add    %edi,%eax
c010342f:	8b 50 10             	mov    0x10(%eax),%edx
c0103432:	8b 40 0c             	mov    0xc(%eax),%eax
c0103435:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
c010343b:	53                   	push   %ebx
c010343c:	51                   	push   %ecx
c010343d:	ff 75 a4             	pushl  -0x5c(%ebp)
c0103440:	ff 75 a0             	pushl  -0x60(%ebp)
c0103443:	52                   	push   %edx
c0103444:	50                   	push   %eax
c0103445:	8d 86 d0 e4 fe ff    	lea    -0x11b30(%esi),%eax
c010344b:	50                   	push   %eax
c010344c:	89 f3                	mov    %esi,%ebx
c010344e:	e8 d6 ce ff ff       	call   c0100329 <cprintf>
c0103453:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM)
c0103456:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103459:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010345c:	89 d0                	mov    %edx,%eax
c010345e:	c1 e0 02             	shl    $0x2,%eax
c0103461:	01 d0                	add    %edx,%eax
c0103463:	c1 e0 02             	shl    $0x2,%eax
c0103466:	01 c8                	add    %ecx,%eax
c0103468:	83 c0 14             	add    $0x14,%eax
c010346b:	8b 00                	mov    (%eax),%eax
c010346d:	83 f8 01             	cmp    $0x1,%eax
c0103470:	75 36                	jne    c01034a8 <page_init+0x147>
        {
            if (maxpa < end && begin < KMEMSIZE)
c0103472:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103475:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103478:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c010347b:	77 2b                	ja     c01034a8 <page_init+0x147>
c010347d:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0103480:	72 05                	jb     c0103487 <page_init+0x126>
c0103482:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0103485:	73 21                	jae    c01034a8 <page_init+0x147>
c0103487:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010348b:	77 1b                	ja     c01034a8 <page_init+0x147>
c010348d:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103491:	72 09                	jb     c010349c <page_init+0x13b>
c0103493:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
c010349a:	77 0c                	ja     c01034a8 <page_init+0x147>
            {
                maxpa = end;
c010349c:	8b 45 98             	mov    -0x68(%ebp),%eax
c010349f:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01034a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01034a5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i++)
c01034a8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01034ac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01034af:	8b 00                	mov    (%eax),%eax
c01034b1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01034b4:	0f 8c f0 fe ff ff    	jl     c01033aa <page_init+0x49>
            }
        }
    }
    if (maxpa > KMEMSIZE)
c01034ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01034be:	72 1d                	jb     c01034dd <page_init+0x17c>
c01034c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01034c4:	77 09                	ja     c01034cf <page_init+0x16e>
c01034c6:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01034cd:	76 0e                	jbe    c01034dd <page_init+0x17c>
    {
        maxpa = KMEMSIZE;
c01034cf:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01034d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01034dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01034e3:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01034e7:	c1 ea 0c             	shr    $0xc,%edx
c01034ea:	89 c1                	mov    %eax,%ecx
c01034ec:	89 d3                	mov    %edx,%ebx
c01034ee:	89 c8                	mov    %ecx,%eax
c01034f0:	89 86 30 35 00 00    	mov    %eax,0x3530(%esi)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01034f6:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c01034fd:	c7 c0 88 bf 11 c0    	mov    $0xc011bf88,%eax
c0103503:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103506:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103509:	01 d0                	add    %edx,%eax
c010350b:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010350e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103511:	ba 00 00 00 00       	mov    $0x0,%edx
c0103516:	f7 75 c0             	divl   -0x40(%ebp)
c0103519:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010351c:	29 d0                	sub    %edx,%eax
c010351e:	89 c2                	mov    %eax,%edx
c0103520:	c7 c0 78 bf 11 c0    	mov    $0xc011bf78,%eax
c0103526:	89 10                	mov    %edx,(%eax)

    for (i = 0; i < npage; i++)
c0103528:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010352f:	eb 31                	jmp    c0103562 <page_init+0x201>
    {
        SetPageReserved(pages + i);
c0103531:	c7 c0 78 bf 11 c0    	mov    $0xc011bf78,%eax
c0103537:	8b 08                	mov    (%eax),%ecx
c0103539:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010353c:	89 d0                	mov    %edx,%eax
c010353e:	c1 e0 02             	shl    $0x2,%eax
c0103541:	01 d0                	add    %edx,%eax
c0103543:	c1 e0 02             	shl    $0x2,%eax
c0103546:	01 c8                	add    %ecx,%eax
c0103548:	83 c0 04             	add    $0x4,%eax
c010354b:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0103552:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103555:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103558:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010355b:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i++)
c010355e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103562:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103565:	8b 86 30 35 00 00    	mov    0x3530(%esi),%eax
c010356b:	39 c2                	cmp    %eax,%edx
c010356d:	72 c2                	jb     c0103531 <page_init+0x1d0>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c010356f:	8b 96 30 35 00 00    	mov    0x3530(%esi),%edx
c0103575:	89 d0                	mov    %edx,%eax
c0103577:	c1 e0 02             	shl    $0x2,%eax
c010357a:	01 d0                	add    %edx,%eax
c010357c:	c1 e0 02             	shl    $0x2,%eax
c010357f:	89 c2                	mov    %eax,%edx
c0103581:	c7 c0 78 bf 11 c0    	mov    $0xc011bf78,%eax
c0103587:	8b 00                	mov    (%eax),%eax
c0103589:	01 d0                	add    %edx,%eax
c010358b:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010358e:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0103595:	77 1d                	ja     c01035b4 <page_init+0x253>
c0103597:	ff 75 b8             	pushl  -0x48(%ebp)
c010359a:	8d 86 00 e5 fe ff    	lea    -0x11b00(%esi),%eax
c01035a0:	50                   	push   %eax
c01035a1:	68 e7 00 00 00       	push   $0xe7
c01035a6:	8d 86 24 e5 fe ff    	lea    -0x11adc(%esi),%eax
c01035ac:	50                   	push   %eax
c01035ad:	89 f3                	mov    %esi,%ebx
c01035af:	e8 25 cf ff ff       	call   c01004d9 <__panic>
c01035b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01035b7:	05 00 00 00 40       	add    $0x40000000,%eax
c01035bc:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i++)
c01035bf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01035c6:	e9 79 01 00 00       	jmp    c0103744 <page_init+0x3e3>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01035cb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01035ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01035d1:	89 d0                	mov    %edx,%eax
c01035d3:	c1 e0 02             	shl    $0x2,%eax
c01035d6:	01 d0                	add    %edx,%eax
c01035d8:	c1 e0 02             	shl    $0x2,%eax
c01035db:	01 c8                	add    %ecx,%eax
c01035dd:	8b 50 08             	mov    0x8(%eax),%edx
c01035e0:	8b 40 04             	mov    0x4(%eax),%eax
c01035e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01035e6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01035e9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01035ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01035ef:	89 d0                	mov    %edx,%eax
c01035f1:	c1 e0 02             	shl    $0x2,%eax
c01035f4:	01 d0                	add    %edx,%eax
c01035f6:	c1 e0 02             	shl    $0x2,%eax
c01035f9:	01 c8                	add    %ecx,%eax
c01035fb:	8b 48 0c             	mov    0xc(%eax),%ecx
c01035fe:	8b 58 10             	mov    0x10(%eax),%ebx
c0103601:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103604:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103607:	01 c8                	add    %ecx,%eax
c0103609:	11 da                	adc    %ebx,%edx
c010360b:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010360e:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM)
c0103611:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103614:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103617:	89 d0                	mov    %edx,%eax
c0103619:	c1 e0 02             	shl    $0x2,%eax
c010361c:	01 d0                	add    %edx,%eax
c010361e:	c1 e0 02             	shl    $0x2,%eax
c0103621:	01 c8                	add    %ecx,%eax
c0103623:	83 c0 14             	add    $0x14,%eax
c0103626:	8b 00                	mov    (%eax),%eax
c0103628:	83 f8 01             	cmp    $0x1,%eax
c010362b:	0f 85 0f 01 00 00    	jne    c0103740 <page_init+0x3df>
        {
            if (begin < freemem)
c0103631:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103634:	ba 00 00 00 00       	mov    $0x0,%edx
c0103639:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c010363c:	77 17                	ja     c0103655 <page_init+0x2f4>
c010363e:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0103641:	72 05                	jb     c0103648 <page_init+0x2e7>
c0103643:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103646:	73 0d                	jae    c0103655 <page_init+0x2f4>
            {
                begin = freemem;
c0103648:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010364b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010364e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE)
c0103655:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103659:	72 1d                	jb     c0103678 <page_init+0x317>
c010365b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010365f:	77 09                	ja     c010366a <page_init+0x309>
c0103661:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0103668:	76 0e                	jbe    c0103678 <page_init+0x317>
            {
                end = KMEMSIZE;
c010366a:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103671:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end)
c0103678:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010367b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010367e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103681:	0f 87 b9 00 00 00    	ja     c0103740 <page_init+0x3df>
c0103687:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010368a:	72 09                	jb     c0103695 <page_init+0x334>
c010368c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010368f:	0f 83 ab 00 00 00    	jae    c0103740 <page_init+0x3df>
            {
                begin = ROUNDUP(begin, PGSIZE);
c0103695:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c010369c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010369f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01036a2:	01 d0                	add    %edx,%eax
c01036a4:	83 e8 01             	sub    $0x1,%eax
c01036a7:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01036aa:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01036ad:	ba 00 00 00 00       	mov    $0x0,%edx
c01036b2:	f7 75 b0             	divl   -0x50(%ebp)
c01036b5:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01036b8:	29 d0                	sub    %edx,%eax
c01036ba:	ba 00 00 00 00       	mov    $0x0,%edx
c01036bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01036c2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01036c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01036c8:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01036cb:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01036ce:	ba 00 00 00 00       	mov    $0x0,%edx
c01036d3:	89 c7                	mov    %eax,%edi
c01036d5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01036db:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01036de:	89 d0                	mov    %edx,%eax
c01036e0:	83 e0 00             	and    $0x0,%eax
c01036e3:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01036e6:	8b 45 80             	mov    -0x80(%ebp),%eax
c01036e9:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01036ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01036ef:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end)
c01036f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01036f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01036f8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01036fb:	77 43                	ja     c0103740 <page_init+0x3df>
c01036fd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103700:	72 05                	jb     c0103707 <page_init+0x3a6>
c0103702:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103705:	73 39                	jae    c0103740 <page_init+0x3df>
                {
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103707:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010370a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010370d:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0103710:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0103713:	89 c3                	mov    %eax,%ebx
c0103715:	89 d6                	mov    %edx,%esi
c0103717:	89 d8                	mov    %ebx,%eax
c0103719:	89 f2                	mov    %esi,%edx
c010371b:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010371f:	c1 ea 0c             	shr    $0xc,%edx
c0103722:	89 c3                	mov    %eax,%ebx
c0103724:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103727:	83 ec 0c             	sub    $0xc,%esp
c010372a:	50                   	push   %eax
c010372b:	e8 78 f7 ff ff       	call   c0102ea8 <pa2page>
c0103730:	83 c4 10             	add    $0x10,%esp
c0103733:	83 ec 08             	sub    $0x8,%esp
c0103736:	53                   	push   %ebx
c0103737:	50                   	push   %eax
c0103738:	e8 21 fb ff ff       	call   c010325e <init_memmap>
c010373d:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i++)
c0103740:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103744:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103747:	8b 00                	mov    (%eax),%eax
c0103749:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010374c:	0f 8c 79 fe ff ff    	jl     c01035cb <page_init+0x26a>
                }
            }
        }
    }
}
c0103752:	90                   	nop
c0103753:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103756:	5b                   	pop    %ebx
c0103757:	5e                   	pop    %esi
c0103758:	5f                   	pop    %edi
c0103759:	5d                   	pop    %ebp
c010375a:	c3                   	ret    

c010375b <boot_map_segment>:
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm)
{
c010375b:	55                   	push   %ebp
c010375c:	89 e5                	mov    %esp,%ebp
c010375e:	53                   	push   %ebx
c010375f:	83 ec 24             	sub    $0x24,%esp
c0103762:	e8 4f cb ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0103767:	81 c3 e9 51 01 00    	add    $0x151e9,%ebx
    assert(PGOFF(la) == PGOFF(pa));
c010376d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103770:	33 45 14             	xor    0x14(%ebp),%eax
c0103773:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103778:	85 c0                	test   %eax,%eax
c010377a:	74 1f                	je     c010379b <boot_map_segment+0x40>
c010377c:	8d 83 32 e5 fe ff    	lea    -0x11ace(%ebx),%eax
c0103782:	50                   	push   %eax
c0103783:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0103789:	50                   	push   %eax
c010378a:	68 0c 01 00 00       	push   $0x10c
c010378f:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103795:	50                   	push   %eax
c0103796:	e8 3e cd ff ff       	call   c01004d9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010379b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01037a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037a5:	25 ff 0f 00 00       	and    $0xfff,%eax
c01037aa:	89 c2                	mov    %eax,%edx
c01037ac:	8b 45 10             	mov    0x10(%ebp),%eax
c01037af:	01 c2                	add    %eax,%edx
c01037b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037b4:	01 d0                	add    %edx,%eax
c01037b6:	83 e8 01             	sub    $0x1,%eax
c01037b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01037bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037bf:	ba 00 00 00 00       	mov    $0x0,%edx
c01037c4:	f7 75 f0             	divl   -0x10(%ebp)
c01037c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037ca:	29 d0                	sub    %edx,%eax
c01037cc:	c1 e8 0c             	shr    $0xc,%eax
c01037cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01037d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01037d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01037e0:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01037e3:	8b 45 14             	mov    0x14(%ebp),%eax
c01037e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01037f1:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
c01037f4:	eb 5d                	jmp    c0103853 <boot_map_segment+0xf8>
    {
        pte_t *ptep = get_pte(pgdir, la, 1);
c01037f6:	83 ec 04             	sub    $0x4,%esp
c01037f9:	6a 01                	push   $0x1
c01037fb:	ff 75 0c             	pushl  0xc(%ebp)
c01037fe:	ff 75 08             	pushl  0x8(%ebp)
c0103801:	e8 8e 01 00 00       	call   c0103994 <get_pte>
c0103806:	83 c4 10             	add    $0x10,%esp
c0103809:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010380c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103810:	75 1f                	jne    c0103831 <boot_map_segment+0xd6>
c0103812:	8d 83 5e e5 fe ff    	lea    -0x11aa2(%ebx),%eax
c0103818:	50                   	push   %eax
c0103819:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c010381f:	50                   	push   %eax
c0103820:	68 13 01 00 00       	push   $0x113
c0103825:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c010382b:	50                   	push   %eax
c010382c:	e8 a8 cc ff ff       	call   c01004d9 <__panic>
        *ptep = pa | PTE_P | perm;
c0103831:	8b 45 14             	mov    0x14(%ebp),%eax
c0103834:	0b 45 18             	or     0x18(%ebp),%eax
c0103837:	83 c8 01             	or     $0x1,%eax
c010383a:	89 c2                	mov    %eax,%edx
c010383c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010383f:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
c0103841:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103845:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010384c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103853:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103857:	75 9d                	jne    c01037f6 <boot_map_segment+0x9b>
    }
}
c0103859:	90                   	nop
c010385a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010385d:	c9                   	leave  
c010385e:	c3                   	ret    

c010385f <boot_alloc_page>:
//boot_alloc_page - allocate one page using pmm->alloc_pages(1)
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void)
{
c010385f:	55                   	push   %ebp
c0103860:	89 e5                	mov    %esp,%ebp
c0103862:	53                   	push   %ebx
c0103863:	83 ec 14             	sub    $0x14,%esp
c0103866:	e8 4b ca ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c010386b:	81 c3 e5 50 01 00    	add    $0x150e5,%ebx
    struct Page *p = alloc_page();
c0103871:	83 ec 0c             	sub    $0xc,%esp
c0103874:	6a 01                	push   $0x1
c0103876:	e8 0f fa ff ff       	call   c010328a <alloc_pages>
c010387b:	83 c4 10             	add    $0x10,%esp
c010387e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL)
c0103881:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103885:	75 1b                	jne    c01038a2 <boot_alloc_page+0x43>
    {
        panic("boot_alloc_page failed.\n");
c0103887:	83 ec 04             	sub    $0x4,%esp
c010388a:	8d 83 6b e5 fe ff    	lea    -0x11a95(%ebx),%eax
c0103890:	50                   	push   %eax
c0103891:	68 21 01 00 00       	push   $0x121
c0103896:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c010389c:	50                   	push   %eax
c010389d:	e8 37 cc ff ff       	call   c01004d9 <__panic>
    }
    return page2kva(p);
c01038a2:	83 ec 0c             	sub    $0xc,%esp
c01038a5:	ff 75 f4             	pushl  -0xc(%ebp)
c01038a8:	e8 59 f6 ff ff       	call   c0102f06 <page2kva>
c01038ad:	83 c4 10             	add    $0x10,%esp
}
c01038b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01038b3:	c9                   	leave  
c01038b4:	c3                   	ret    

c01038b5 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void pmm_init(void)
{
c01038b5:	55                   	push   %ebp
c01038b6:	89 e5                	mov    %esp,%ebp
c01038b8:	53                   	push   %ebx
c01038b9:	83 ec 14             	sub    $0x14,%esp
c01038bc:	e8 f5 c9 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c01038c1:	81 c3 8f 50 01 00    	add    $0x1508f,%ebx
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01038c7:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c01038cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01038d0:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01038d7:	77 1b                	ja     c01038f4 <pmm_init+0x3f>
c01038d9:	ff 75 f4             	pushl  -0xc(%ebp)
c01038dc:	8d 83 00 e5 fe ff    	lea    -0x11b00(%ebx),%eax
c01038e2:	50                   	push   %eax
c01038e3:	68 2b 01 00 00       	push   $0x12b
c01038e8:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c01038ee:	50                   	push   %eax
c01038ef:	e8 e5 cb ff ff       	call   c01004d9 <__panic>
c01038f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038f7:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01038fd:	c7 c0 74 bf 11 c0    	mov    $0xc011bf74,%eax
c0103903:	89 10                	mov    %edx,(%eax)
    //We need to alloc/free the physical memory (granularity is 4KB or other size).
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory.
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103905:	e8 04 f9 ff ff       	call   c010320e <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010390a:	e8 52 fa ff ff       	call   c0103361 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010390f:	e8 ef 03 00 00       	call   c0103d03 <check_alloc_page>

    check_pgdir();
c0103914:	e8 21 04 00 00       	call   c0103d3a <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103919:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c010391f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103922:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103929:	77 1b                	ja     c0103946 <pmm_init+0x91>
c010392b:	ff 75 f0             	pushl  -0x10(%ebp)
c010392e:	8d 83 00 e5 fe ff    	lea    -0x11b00(%ebx),%eax
c0103934:	50                   	push   %eax
c0103935:	68 41 01 00 00       	push   $0x141
c010393a:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103940:	50                   	push   %eax
c0103941:	e8 93 cb ff ff       	call   c01004d9 <__panic>
c0103946:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103949:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010394f:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103955:	05 ac 0f 00 00       	add    $0xfac,%eax
c010395a:	83 ca 03             	or     $0x3,%edx
c010395d:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010395f:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103965:	83 ec 0c             	sub    $0xc,%esp
c0103968:	6a 02                	push   $0x2
c010396a:	6a 00                	push   $0x0
c010396c:	68 00 00 00 38       	push   $0x38000000
c0103971:	68 00 00 00 c0       	push   $0xc0000000
c0103976:	50                   	push   %eax
c0103977:	e8 df fd ff ff       	call   c010375b <boot_map_segment>
c010397c:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010397f:	e8 77 f7 ff ff       	call   c01030fb <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0103984:	e8 d5 09 00 00       	call   c010435e <check_boot_pgdir>

    print_pgdir();
c0103989:	e8 43 0e 00 00       	call   c01047d1 <print_pgdir>
}
c010398e:	90                   	nop
c010398f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103992:	c9                   	leave  
c0103993:	c3                   	ret    

c0103994 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
c0103994:	55                   	push   %ebp
c0103995:	89 e5                	mov    %esp,%ebp
c0103997:	53                   	push   %ebx
c0103998:	83 ec 24             	sub    $0x24,%esp
c010399b:	e8 16 c9 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c01039a0:	81 c3 b0 4f 01 00    	add    $0x14fb0,%ebx
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
*/
    pde_t *pdep = &pgdir[PDX(la)];
c01039a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01039a9:	c1 e8 16             	shr    $0x16,%eax
c01039ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01039b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01039b6:	01 d0                	add    %edx,%eax
c01039b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //获取页表的地址不成功
    if (!(*pdep & PTE_P))
c01039bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039be:	8b 00                	mov    (%eax),%eax
c01039c0:	83 e0 01             	and    $0x1,%eax
c01039c3:	85 c0                	test   %eax,%eax
c01039c5:	0f 85 a4 00 00 00    	jne    c0103a6f <get_pte+0xdb>
    {
        struct Page *page;
        //申请一页
        if (!create || (page = alloc_page()) == NULL)
c01039cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01039cf:	74 16                	je     c01039e7 <get_pte+0x53>
c01039d1:	83 ec 0c             	sub    $0xc,%esp
c01039d4:	6a 01                	push   $0x1
c01039d6:	e8 af f8 ff ff       	call   c010328a <alloc_pages>
c01039db:	83 c4 10             	add    $0x10,%esp
c01039de:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039e5:	75 0a                	jne    c01039f1 <get_pte+0x5d>
        {
            return NULL;
c01039e7:	b8 00 00 00 00       	mov    $0x0,%eax
c01039ec:	e9 d4 00 00 00       	jmp    c0103ac5 <get_pte+0x131>
        }
        set_page_ref(page, 1);        //引用加1
c01039f1:	83 ec 08             	sub    $0x8,%esp
c01039f4:	6a 01                	push   $0x1
c01039f6:	ff 75 f0             	pushl  -0x10(%ebp)
c01039f9:	e8 e9 f5 ff ff       	call   c0102fe7 <set_page_ref>
c01039fe:	83 c4 10             	add    $0x10,%esp
        uintptr_t pa = page2pa(page); //获取地址
c0103a01:	83 ec 0c             	sub    $0xc,%esp
c0103a04:	ff 75 f0             	pushl  -0x10(%ebp)
c0103a07:	e8 7f f4 ff ff       	call   c0102e8b <page2pa>
c0103a0c:	83 c4 10             	add    $0x10,%esp
c0103a0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0103a12:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a15:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a1b:	c1 e8 0c             	shr    $0xc,%eax
c0103a1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a21:	8b 83 30 35 00 00    	mov    0x3530(%ebx),%eax
c0103a27:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103a2a:	72 1b                	jb     c0103a47 <get_pte+0xb3>
c0103a2c:	ff 75 e8             	pushl  -0x18(%ebp)
c0103a2f:	8d 83 5c e4 fe ff    	lea    -0x11ba4(%ebx),%eax
c0103a35:	50                   	push   %eax
c0103a36:	68 8d 01 00 00       	push   $0x18d
c0103a3b:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103a41:	50                   	push   %eax
c0103a42:	e8 92 ca ff ff       	call   c01004d9 <__panic>
c0103a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a4a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103a4f:	83 ec 04             	sub    $0x4,%esp
c0103a52:	68 00 10 00 00       	push   $0x1000
c0103a57:	6a 00                	push   $0x0
c0103a59:	50                   	push   %eax
c0103a5a:	e8 55 24 00 00       	call   c0105eb4 <memset>
c0103a5f:	83 c4 10             	add    $0x10,%esp
        *pdep = pa | PTE_U | PTE_W | PTE_P; //设置权限
c0103a62:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a65:	83 c8 07             	or     $0x7,%eax
c0103a68:	89 c2                	mov    %eax,%edx
c0103a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a6d:	89 10                	mov    %edx,(%eax)
    }
    //返回页表的地址
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0103a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a72:	8b 00                	mov    (%eax),%eax
c0103a74:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a79:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103a7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a7f:	c1 e8 0c             	shr    $0xc,%eax
c0103a82:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103a85:	8b 83 30 35 00 00    	mov    0x3530(%ebx),%eax
c0103a8b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103a8e:	72 1b                	jb     c0103aab <get_pte+0x117>
c0103a90:	ff 75 e0             	pushl  -0x20(%ebp)
c0103a93:	8d 83 5c e4 fe ff    	lea    -0x11ba4(%ebx),%eax
c0103a99:	50                   	push   %eax
c0103a9a:	68 91 01 00 00       	push   $0x191
c0103a9f:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103aa5:	50                   	push   %eax
c0103aa6:	e8 2e ca ff ff       	call   c01004d9 <__panic>
c0103aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103aae:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103ab3:	89 c2                	mov    %eax,%edx
c0103ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103ab8:	c1 e8 0c             	shr    $0xc,%eax
c0103abb:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103ac0:	c1 e0 02             	shl    $0x2,%eax
c0103ac3:	01 d0                	add    %edx,%eax
}
c0103ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103ac8:	c9                   	leave  
c0103ac9:	c3                   	ret    

c0103aca <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
c0103aca:	55                   	push   %ebp
c0103acb:	89 e5                	mov    %esp,%ebp
c0103acd:	83 ec 18             	sub    $0x18,%esp
c0103ad0:	e8 dd c7 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0103ad5:	05 7b 4e 01 00       	add    $0x14e7b,%eax
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103ada:	83 ec 04             	sub    $0x4,%esp
c0103add:	6a 00                	push   $0x0
c0103adf:	ff 75 0c             	pushl  0xc(%ebp)
c0103ae2:	ff 75 08             	pushl  0x8(%ebp)
c0103ae5:	e8 aa fe ff ff       	call   c0103994 <get_pte>
c0103aea:	83 c4 10             	add    $0x10,%esp
c0103aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL)
c0103af0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103af4:	74 08                	je     c0103afe <get_page+0x34>
    {
        *ptep_store = ptep;
c0103af6:	8b 45 10             	mov    0x10(%ebp),%eax
c0103af9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103afc:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P)
c0103afe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b02:	74 1f                	je     c0103b23 <get_page+0x59>
c0103b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b07:	8b 00                	mov    (%eax),%eax
c0103b09:	83 e0 01             	and    $0x1,%eax
c0103b0c:	85 c0                	test   %eax,%eax
c0103b0e:	74 13                	je     c0103b23 <get_page+0x59>
    {
        return pte2page(*ptep);
c0103b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b13:	8b 00                	mov    (%eax),%eax
c0103b15:	83 ec 0c             	sub    $0xc,%esp
c0103b18:	50                   	push   %eax
c0103b19:	e8 41 f4 ff ff       	call   c0102f5f <pte2page>
c0103b1e:	83 c4 10             	add    $0x10,%esp
c0103b21:	eb 05                	jmp    c0103b28 <get_page+0x5e>
    }
    return NULL;
c0103b23:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103b28:	c9                   	leave  
c0103b29:	c3                   	ret    

c0103b2a <page_remove_pte>:
//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep)
{
c0103b2a:	55                   	push   %ebp
c0103b2b:	89 e5                	mov    %esp,%ebp
c0103b2d:	83 ec 18             	sub    $0x18,%esp
c0103b30:	e8 7d c7 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0103b35:	05 1b 4e 01 00       	add    $0x14e1b,%eax
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
*/
    if (*ptep & PTE_P)
c0103b3a:	8b 45 10             	mov    0x10(%ebp),%eax
c0103b3d:	8b 00                	mov    (%eax),%eax
c0103b3f:	83 e0 01             	and    $0x1,%eax
c0103b42:	85 c0                	test   %eax,%eax
c0103b44:	74 50                	je     c0103b96 <page_remove_pte+0x6c>
    {
        struct Page *page = pte2page(*ptep);
c0103b46:	8b 45 10             	mov    0x10(%ebp),%eax
c0103b49:	8b 00                	mov    (%eax),%eax
c0103b4b:	83 ec 0c             	sub    $0xc,%esp
c0103b4e:	50                   	push   %eax
c0103b4f:	e8 0b f4 ff ff       	call   c0102f5f <pte2page>
c0103b54:	83 c4 10             	add    $0x10,%esp
c0103b57:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0)
c0103b5a:	83 ec 0c             	sub    $0xc,%esp
c0103b5d:	ff 75 f4             	pushl  -0xc(%ebp)
c0103b60:	e8 bb f4 ff ff       	call   c0103020 <page_ref_dec>
c0103b65:	83 c4 10             	add    $0x10,%esp
c0103b68:	85 c0                	test   %eax,%eax
c0103b6a:	75 10                	jne    c0103b7c <page_remove_pte+0x52>
        {
            free_page(page); //仅引用1次则释放
c0103b6c:	83 ec 08             	sub    $0x8,%esp
c0103b6f:	6a 01                	push   $0x1
c0103b71:	ff 75 f4             	pushl  -0xc(%ebp)
c0103b74:	e8 61 f7 ff ff       	call   c01032da <free_pages>
c0103b79:	83 c4 10             	add    $0x10,%esp
        }
        *ptep = 0;
c0103b7c:	8b 45 10             	mov    0x10(%ebp),%eax
c0103b7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la); //引用多次则释放pte
c0103b85:	83 ec 08             	sub    $0x8,%esp
c0103b88:	ff 75 0c             	pushl  0xc(%ebp)
c0103b8b:	ff 75 08             	pushl  0x8(%ebp)
c0103b8e:	e8 0c 01 00 00       	call   c0103c9f <tlb_invalidate>
c0103b93:	83 c4 10             	add    $0x10,%esp
    }
}
c0103b96:	90                   	nop
c0103b97:	c9                   	leave  
c0103b98:	c3                   	ret    

c0103b99 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
c0103b99:	55                   	push   %ebp
c0103b9a:	89 e5                	mov    %esp,%ebp
c0103b9c:	83 ec 18             	sub    $0x18,%esp
c0103b9f:	e8 0e c7 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0103ba4:	05 ac 4d 01 00       	add    $0x14dac,%eax
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103ba9:	83 ec 04             	sub    $0x4,%esp
c0103bac:	6a 00                	push   $0x0
c0103bae:	ff 75 0c             	pushl  0xc(%ebp)
c0103bb1:	ff 75 08             	pushl  0x8(%ebp)
c0103bb4:	e8 db fd ff ff       	call   c0103994 <get_pte>
c0103bb9:	83 c4 10             	add    $0x10,%esp
c0103bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL)
c0103bbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103bc3:	74 14                	je     c0103bd9 <page_remove+0x40>
    {
        page_remove_pte(pgdir, la, ptep);
c0103bc5:	83 ec 04             	sub    $0x4,%esp
c0103bc8:	ff 75 f4             	pushl  -0xc(%ebp)
c0103bcb:	ff 75 0c             	pushl  0xc(%ebp)
c0103bce:	ff 75 08             	pushl  0x8(%ebp)
c0103bd1:	e8 54 ff ff ff       	call   c0103b2a <page_remove_pte>
c0103bd6:	83 c4 10             	add    $0x10,%esp
    }
}
c0103bd9:	90                   	nop
c0103bda:	c9                   	leave  
c0103bdb:	c3                   	ret    

c0103bdc <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm)
{
c0103bdc:	55                   	push   %ebp
c0103bdd:	89 e5                	mov    %esp,%ebp
c0103bdf:	83 ec 18             	sub    $0x18,%esp
c0103be2:	e8 cb c6 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0103be7:	05 69 4d 01 00       	add    $0x14d69,%eax
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103bec:	83 ec 04             	sub    $0x4,%esp
c0103bef:	6a 01                	push   $0x1
c0103bf1:	ff 75 10             	pushl  0x10(%ebp)
c0103bf4:	ff 75 08             	pushl  0x8(%ebp)
c0103bf7:	e8 98 fd ff ff       	call   c0103994 <get_pte>
c0103bfc:	83 c4 10             	add    $0x10,%esp
c0103bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL)
c0103c02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103c06:	75 0a                	jne    c0103c12 <page_insert+0x36>
    {
        return -E_NO_MEM;
c0103c08:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103c0d:	e9 8b 00 00 00       	jmp    c0103c9d <page_insert+0xc1>
    }
    page_ref_inc(page);
c0103c12:	83 ec 0c             	sub    $0xc,%esp
c0103c15:	ff 75 0c             	pushl  0xc(%ebp)
c0103c18:	e8 e2 f3 ff ff       	call   c0102fff <page_ref_inc>
c0103c1d:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P)
c0103c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c23:	8b 00                	mov    (%eax),%eax
c0103c25:	83 e0 01             	and    $0x1,%eax
c0103c28:	85 c0                	test   %eax,%eax
c0103c2a:	74 40                	je     c0103c6c <page_insert+0x90>
    {
        struct Page *p = pte2page(*ptep);
c0103c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c2f:	8b 00                	mov    (%eax),%eax
c0103c31:	83 ec 0c             	sub    $0xc,%esp
c0103c34:	50                   	push   %eax
c0103c35:	e8 25 f3 ff ff       	call   c0102f5f <pte2page>
c0103c3a:	83 c4 10             	add    $0x10,%esp
c0103c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page)
c0103c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c43:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103c46:	75 10                	jne    c0103c58 <page_insert+0x7c>
        {
            page_ref_dec(page);
c0103c48:	83 ec 0c             	sub    $0xc,%esp
c0103c4b:	ff 75 0c             	pushl  0xc(%ebp)
c0103c4e:	e8 cd f3 ff ff       	call   c0103020 <page_ref_dec>
c0103c53:	83 c4 10             	add    $0x10,%esp
c0103c56:	eb 14                	jmp    c0103c6c <page_insert+0x90>
        }
        else
        {
            page_remove_pte(pgdir, la, ptep);
c0103c58:	83 ec 04             	sub    $0x4,%esp
c0103c5b:	ff 75 f4             	pushl  -0xc(%ebp)
c0103c5e:	ff 75 10             	pushl  0x10(%ebp)
c0103c61:	ff 75 08             	pushl  0x8(%ebp)
c0103c64:	e8 c1 fe ff ff       	call   c0103b2a <page_remove_pte>
c0103c69:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103c6c:	83 ec 0c             	sub    $0xc,%esp
c0103c6f:	ff 75 0c             	pushl  0xc(%ebp)
c0103c72:	e8 14 f2 ff ff       	call   c0102e8b <page2pa>
c0103c77:	83 c4 10             	add    $0x10,%esp
c0103c7a:	0b 45 14             	or     0x14(%ebp),%eax
c0103c7d:	83 c8 01             	or     $0x1,%eax
c0103c80:	89 c2                	mov    %eax,%edx
c0103c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c85:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103c87:	83 ec 08             	sub    $0x8,%esp
c0103c8a:	ff 75 10             	pushl  0x10(%ebp)
c0103c8d:	ff 75 08             	pushl  0x8(%ebp)
c0103c90:	e8 0a 00 00 00       	call   c0103c9f <tlb_invalidate>
c0103c95:	83 c4 10             	add    $0x10,%esp
    return 0;
c0103c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103c9d:	c9                   	leave  
c0103c9e:	c3                   	ret    

c0103c9f <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
c0103c9f:	55                   	push   %ebp
c0103ca0:	89 e5                	mov    %esp,%ebp
c0103ca2:	53                   	push   %ebx
c0103ca3:	83 ec 14             	sub    $0x14,%esp
c0103ca6:	e8 07 c6 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0103cab:	05 a5 4c 01 00       	add    $0x14ca5,%eax
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103cb0:	0f 20 da             	mov    %cr3,%edx
c0103cb3:	89 55 f0             	mov    %edx,-0x10(%ebp)
    return cr3;
c0103cb6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    if (rcr3() == PADDR(pgdir))
c0103cb9:	8b 55 08             	mov    0x8(%ebp),%edx
c0103cbc:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0103cbf:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103cc6:	77 1d                	ja     c0103ce5 <tlb_invalidate+0x46>
c0103cc8:	ff 75 f4             	pushl  -0xc(%ebp)
c0103ccb:	8d 90 00 e5 fe ff    	lea    -0x11b00(%eax),%edx
c0103cd1:	52                   	push   %edx
c0103cd2:	68 00 02 00 00       	push   $0x200
c0103cd7:	8d 90 24 e5 fe ff    	lea    -0x11adc(%eax),%edx
c0103cdd:	52                   	push   %edx
c0103cde:	89 c3                	mov    %eax,%ebx
c0103ce0:	e8 f4 c7 ff ff       	call   c01004d9 <__panic>
c0103ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ce8:	05 00 00 00 40       	add    $0x40000000,%eax
c0103ced:	39 c8                	cmp    %ecx,%eax
c0103cef:	75 0c                	jne    c0103cfd <tlb_invalidate+0x5e>
    {
        invlpg((void *)la);
c0103cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103cf4:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103cf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cfa:	0f 01 38             	invlpg (%eax)
    }
}
c0103cfd:	90                   	nop
c0103cfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103d01:	c9                   	leave  
c0103d02:	c3                   	ret    

c0103d03 <check_alloc_page>:

static void
check_alloc_page(void)
{
c0103d03:	55                   	push   %ebp
c0103d04:	89 e5                	mov    %esp,%ebp
c0103d06:	53                   	push   %ebx
c0103d07:	83 ec 04             	sub    $0x4,%esp
c0103d0a:	e8 a7 c5 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0103d0f:	81 c3 41 4c 01 00    	add    $0x14c41,%ebx
    pmm_manager->check();
c0103d15:	c7 c0 70 bf 11 c0    	mov    $0xc011bf70,%eax
c0103d1b:	8b 00                	mov    (%eax),%eax
c0103d1d:	8b 40 18             	mov    0x18(%eax),%eax
c0103d20:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0103d22:	83 ec 0c             	sub    $0xc,%esp
c0103d25:	8d 83 84 e5 fe ff    	lea    -0x11a7c(%ebx),%eax
c0103d2b:	50                   	push   %eax
c0103d2c:	e8 f8 c5 ff ff       	call   c0100329 <cprintf>
c0103d31:	83 c4 10             	add    $0x10,%esp
}
c0103d34:	90                   	nop
c0103d35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103d38:	c9                   	leave  
c0103d39:	c3                   	ret    

c0103d3a <check_pgdir>:

static void
check_pgdir(void)
{
c0103d3a:	55                   	push   %ebp
c0103d3b:	89 e5                	mov    %esp,%ebp
c0103d3d:	53                   	push   %ebx
c0103d3e:	83 ec 24             	sub    $0x24,%esp
c0103d41:	e8 70 c5 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0103d46:	81 c3 0a 4c 01 00    	add    $0x14c0a,%ebx
    assert(npage <= KMEMSIZE / PGSIZE);
c0103d4c:	8b 83 30 35 00 00    	mov    0x3530(%ebx),%eax
c0103d52:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103d57:	76 1f                	jbe    c0103d78 <check_pgdir+0x3e>
c0103d59:	8d 83 a3 e5 fe ff    	lea    -0x11a5d(%ebx),%eax
c0103d5f:	50                   	push   %eax
c0103d60:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0103d66:	50                   	push   %eax
c0103d67:	68 10 02 00 00       	push   $0x210
c0103d6c:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103d72:	50                   	push   %eax
c0103d73:	e8 61 c7 ff ff       	call   c01004d9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103d78:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103d7e:	85 c0                	test   %eax,%eax
c0103d80:	74 0f                	je     c0103d91 <check_pgdir+0x57>
c0103d82:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103d88:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103d8d:	85 c0                	test   %eax,%eax
c0103d8f:	74 1f                	je     c0103db0 <check_pgdir+0x76>
c0103d91:	8d 83 c0 e5 fe ff    	lea    -0x11a40(%ebx),%eax
c0103d97:	50                   	push   %eax
c0103d98:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0103d9e:	50                   	push   %eax
c0103d9f:	68 11 02 00 00       	push   $0x211
c0103da4:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103daa:	50                   	push   %eax
c0103dab:	e8 29 c7 ff ff       	call   c01004d9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103db0:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103db6:	83 ec 04             	sub    $0x4,%esp
c0103db9:	6a 00                	push   $0x0
c0103dbb:	6a 00                	push   $0x0
c0103dbd:	50                   	push   %eax
c0103dbe:	e8 07 fd ff ff       	call   c0103aca <get_page>
c0103dc3:	83 c4 10             	add    $0x10,%esp
c0103dc6:	85 c0                	test   %eax,%eax
c0103dc8:	74 1f                	je     c0103de9 <check_pgdir+0xaf>
c0103dca:	8d 83 f8 e5 fe ff    	lea    -0x11a08(%ebx),%eax
c0103dd0:	50                   	push   %eax
c0103dd1:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0103dd7:	50                   	push   %eax
c0103dd8:	68 12 02 00 00       	push   $0x212
c0103ddd:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103de3:	50                   	push   %eax
c0103de4:	e8 f0 c6 ff ff       	call   c01004d9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103de9:	83 ec 0c             	sub    $0xc,%esp
c0103dec:	6a 01                	push   $0x1
c0103dee:	e8 97 f4 ff ff       	call   c010328a <alloc_pages>
c0103df3:	83 c4 10             	add    $0x10,%esp
c0103df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103df9:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103dff:	6a 00                	push   $0x0
c0103e01:	6a 00                	push   $0x0
c0103e03:	ff 75 f4             	pushl  -0xc(%ebp)
c0103e06:	50                   	push   %eax
c0103e07:	e8 d0 fd ff ff       	call   c0103bdc <page_insert>
c0103e0c:	83 c4 10             	add    $0x10,%esp
c0103e0f:	85 c0                	test   %eax,%eax
c0103e11:	74 1f                	je     c0103e32 <check_pgdir+0xf8>
c0103e13:	8d 83 20 e6 fe ff    	lea    -0x119e0(%ebx),%eax
c0103e19:	50                   	push   %eax
c0103e1a:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0103e20:	50                   	push   %eax
c0103e21:	68 16 02 00 00       	push   $0x216
c0103e26:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103e2c:	50                   	push   %eax
c0103e2d:	e8 a7 c6 ff ff       	call   c01004d9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103e32:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103e38:	83 ec 04             	sub    $0x4,%esp
c0103e3b:	6a 00                	push   $0x0
c0103e3d:	6a 00                	push   $0x0
c0103e3f:	50                   	push   %eax
c0103e40:	e8 4f fb ff ff       	call   c0103994 <get_pte>
c0103e45:	83 c4 10             	add    $0x10,%esp
c0103e48:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103e4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103e4f:	75 1f                	jne    c0103e70 <check_pgdir+0x136>
c0103e51:	8d 83 4c e6 fe ff    	lea    -0x119b4(%ebx),%eax
c0103e57:	50                   	push   %eax
c0103e58:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0103e5e:	50                   	push   %eax
c0103e5f:	68 19 02 00 00       	push   $0x219
c0103e64:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103e6a:	50                   	push   %eax
c0103e6b:	e8 69 c6 ff ff       	call   c01004d9 <__panic>
    assert(pte2page(*ptep) == p1);
c0103e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e73:	8b 00                	mov    (%eax),%eax
c0103e75:	83 ec 0c             	sub    $0xc,%esp
c0103e78:	50                   	push   %eax
c0103e79:	e8 e1 f0 ff ff       	call   c0102f5f <pte2page>
c0103e7e:	83 c4 10             	add    $0x10,%esp
c0103e81:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103e84:	74 1f                	je     c0103ea5 <check_pgdir+0x16b>
c0103e86:	8d 83 79 e6 fe ff    	lea    -0x11987(%ebx),%eax
c0103e8c:	50                   	push   %eax
c0103e8d:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0103e93:	50                   	push   %eax
c0103e94:	68 1a 02 00 00       	push   $0x21a
c0103e99:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103e9f:	50                   	push   %eax
c0103ea0:	e8 34 c6 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p1) == 1);
c0103ea5:	83 ec 0c             	sub    $0xc,%esp
c0103ea8:	ff 75 f4             	pushl  -0xc(%ebp)
c0103eab:	e8 23 f1 ff ff       	call   c0102fd3 <page_ref>
c0103eb0:	83 c4 10             	add    $0x10,%esp
c0103eb3:	83 f8 01             	cmp    $0x1,%eax
c0103eb6:	74 1f                	je     c0103ed7 <check_pgdir+0x19d>
c0103eb8:	8d 83 8f e6 fe ff    	lea    -0x11971(%ebx),%eax
c0103ebe:	50                   	push   %eax
c0103ebf:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0103ec5:	50                   	push   %eax
c0103ec6:	68 1b 02 00 00       	push   $0x21b
c0103ecb:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103ed1:	50                   	push   %eax
c0103ed2:	e8 02 c6 ff ff       	call   c01004d9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103ed7:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103edd:	8b 00                	mov    (%eax),%eax
c0103edf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ee4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103eea:	c1 e8 0c             	shr    $0xc,%eax
c0103eed:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103ef0:	8b 83 30 35 00 00    	mov    0x3530(%ebx),%eax
c0103ef6:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103ef9:	72 1b                	jb     c0103f16 <check_pgdir+0x1dc>
c0103efb:	ff 75 ec             	pushl  -0x14(%ebp)
c0103efe:	8d 83 5c e4 fe ff    	lea    -0x11ba4(%ebx),%eax
c0103f04:	50                   	push   %eax
c0103f05:	68 1d 02 00 00       	push   $0x21d
c0103f0a:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103f10:	50                   	push   %eax
c0103f11:	e8 c3 c5 ff ff       	call   c01004d9 <__panic>
c0103f16:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f19:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103f1e:	83 c0 04             	add    $0x4,%eax
c0103f21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103f24:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103f2a:	83 ec 04             	sub    $0x4,%esp
c0103f2d:	6a 00                	push   $0x0
c0103f2f:	68 00 10 00 00       	push   $0x1000
c0103f34:	50                   	push   %eax
c0103f35:	e8 5a fa ff ff       	call   c0103994 <get_pte>
c0103f3a:	83 c4 10             	add    $0x10,%esp
c0103f3d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103f40:	74 1f                	je     c0103f61 <check_pgdir+0x227>
c0103f42:	8d 83 a4 e6 fe ff    	lea    -0x1195c(%ebx),%eax
c0103f48:	50                   	push   %eax
c0103f49:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0103f4f:	50                   	push   %eax
c0103f50:	68 1e 02 00 00       	push   $0x21e
c0103f55:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103f5b:	50                   	push   %eax
c0103f5c:	e8 78 c5 ff ff       	call   c01004d9 <__panic>

    p2 = alloc_page();
c0103f61:	83 ec 0c             	sub    $0xc,%esp
c0103f64:	6a 01                	push   $0x1
c0103f66:	e8 1f f3 ff ff       	call   c010328a <alloc_pages>
c0103f6b:	83 c4 10             	add    $0x10,%esp
c0103f6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103f71:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103f77:	6a 06                	push   $0x6
c0103f79:	68 00 10 00 00       	push   $0x1000
c0103f7e:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103f81:	50                   	push   %eax
c0103f82:	e8 55 fc ff ff       	call   c0103bdc <page_insert>
c0103f87:	83 c4 10             	add    $0x10,%esp
c0103f8a:	85 c0                	test   %eax,%eax
c0103f8c:	74 1f                	je     c0103fad <check_pgdir+0x273>
c0103f8e:	8d 83 cc e6 fe ff    	lea    -0x11934(%ebx),%eax
c0103f94:	50                   	push   %eax
c0103f95:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0103f9b:	50                   	push   %eax
c0103f9c:	68 21 02 00 00       	push   $0x221
c0103fa1:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103fa7:	50                   	push   %eax
c0103fa8:	e8 2c c5 ff ff       	call   c01004d9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103fad:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0103fb3:	83 ec 04             	sub    $0x4,%esp
c0103fb6:	6a 00                	push   $0x0
c0103fb8:	68 00 10 00 00       	push   $0x1000
c0103fbd:	50                   	push   %eax
c0103fbe:	e8 d1 f9 ff ff       	call   c0103994 <get_pte>
c0103fc3:	83 c4 10             	add    $0x10,%esp
c0103fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103fc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103fcd:	75 1f                	jne    c0103fee <check_pgdir+0x2b4>
c0103fcf:	8d 83 04 e7 fe ff    	lea    -0x118fc(%ebx),%eax
c0103fd5:	50                   	push   %eax
c0103fd6:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0103fdc:	50                   	push   %eax
c0103fdd:	68 22 02 00 00       	push   $0x222
c0103fe2:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0103fe8:	50                   	push   %eax
c0103fe9:	e8 eb c4 ff ff       	call   c01004d9 <__panic>
    assert(*ptep & PTE_U);
c0103fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ff1:	8b 00                	mov    (%eax),%eax
c0103ff3:	83 e0 04             	and    $0x4,%eax
c0103ff6:	85 c0                	test   %eax,%eax
c0103ff8:	75 1f                	jne    c0104019 <check_pgdir+0x2df>
c0103ffa:	8d 83 34 e7 fe ff    	lea    -0x118cc(%ebx),%eax
c0104000:	50                   	push   %eax
c0104001:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104007:	50                   	push   %eax
c0104008:	68 23 02 00 00       	push   $0x223
c010400d:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0104013:	50                   	push   %eax
c0104014:	e8 c0 c4 ff ff       	call   c01004d9 <__panic>
    assert(*ptep & PTE_W);
c0104019:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010401c:	8b 00                	mov    (%eax),%eax
c010401e:	83 e0 02             	and    $0x2,%eax
c0104021:	85 c0                	test   %eax,%eax
c0104023:	75 1f                	jne    c0104044 <check_pgdir+0x30a>
c0104025:	8d 83 42 e7 fe ff    	lea    -0x118be(%ebx),%eax
c010402b:	50                   	push   %eax
c010402c:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104032:	50                   	push   %eax
c0104033:	68 24 02 00 00       	push   $0x224
c0104038:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c010403e:	50                   	push   %eax
c010403f:	e8 95 c4 ff ff       	call   c01004d9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104044:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c010404a:	8b 00                	mov    (%eax),%eax
c010404c:	83 e0 04             	and    $0x4,%eax
c010404f:	85 c0                	test   %eax,%eax
c0104051:	75 1f                	jne    c0104072 <check_pgdir+0x338>
c0104053:	8d 83 50 e7 fe ff    	lea    -0x118b0(%ebx),%eax
c0104059:	50                   	push   %eax
c010405a:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104060:	50                   	push   %eax
c0104061:	68 25 02 00 00       	push   $0x225
c0104066:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c010406c:	50                   	push   %eax
c010406d:	e8 67 c4 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p2) == 1);
c0104072:	83 ec 0c             	sub    $0xc,%esp
c0104075:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104078:	e8 56 ef ff ff       	call   c0102fd3 <page_ref>
c010407d:	83 c4 10             	add    $0x10,%esp
c0104080:	83 f8 01             	cmp    $0x1,%eax
c0104083:	74 1f                	je     c01040a4 <check_pgdir+0x36a>
c0104085:	8d 83 66 e7 fe ff    	lea    -0x1189a(%ebx),%eax
c010408b:	50                   	push   %eax
c010408c:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104092:	50                   	push   %eax
c0104093:	68 26 02 00 00       	push   $0x226
c0104098:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c010409e:	50                   	push   %eax
c010409f:	e8 35 c4 ff ff       	call   c01004d9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01040a4:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c01040aa:	6a 00                	push   $0x0
c01040ac:	68 00 10 00 00       	push   $0x1000
c01040b1:	ff 75 f4             	pushl  -0xc(%ebp)
c01040b4:	50                   	push   %eax
c01040b5:	e8 22 fb ff ff       	call   c0103bdc <page_insert>
c01040ba:	83 c4 10             	add    $0x10,%esp
c01040bd:	85 c0                	test   %eax,%eax
c01040bf:	74 1f                	je     c01040e0 <check_pgdir+0x3a6>
c01040c1:	8d 83 78 e7 fe ff    	lea    -0x11888(%ebx),%eax
c01040c7:	50                   	push   %eax
c01040c8:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c01040ce:	50                   	push   %eax
c01040cf:	68 28 02 00 00       	push   $0x228
c01040d4:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c01040da:	50                   	push   %eax
c01040db:	e8 f9 c3 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p1) == 2);
c01040e0:	83 ec 0c             	sub    $0xc,%esp
c01040e3:	ff 75 f4             	pushl  -0xc(%ebp)
c01040e6:	e8 e8 ee ff ff       	call   c0102fd3 <page_ref>
c01040eb:	83 c4 10             	add    $0x10,%esp
c01040ee:	83 f8 02             	cmp    $0x2,%eax
c01040f1:	74 1f                	je     c0104112 <check_pgdir+0x3d8>
c01040f3:	8d 83 a4 e7 fe ff    	lea    -0x1185c(%ebx),%eax
c01040f9:	50                   	push   %eax
c01040fa:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104100:	50                   	push   %eax
c0104101:	68 29 02 00 00       	push   $0x229
c0104106:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c010410c:	50                   	push   %eax
c010410d:	e8 c7 c3 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p2) == 0);
c0104112:	83 ec 0c             	sub    $0xc,%esp
c0104115:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104118:	e8 b6 ee ff ff       	call   c0102fd3 <page_ref>
c010411d:	83 c4 10             	add    $0x10,%esp
c0104120:	85 c0                	test   %eax,%eax
c0104122:	74 1f                	je     c0104143 <check_pgdir+0x409>
c0104124:	8d 83 b6 e7 fe ff    	lea    -0x1184a(%ebx),%eax
c010412a:	50                   	push   %eax
c010412b:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104131:	50                   	push   %eax
c0104132:	68 2a 02 00 00       	push   $0x22a
c0104137:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c010413d:	50                   	push   %eax
c010413e:	e8 96 c3 ff ff       	call   c01004d9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104143:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0104149:	83 ec 04             	sub    $0x4,%esp
c010414c:	6a 00                	push   $0x0
c010414e:	68 00 10 00 00       	push   $0x1000
c0104153:	50                   	push   %eax
c0104154:	e8 3b f8 ff ff       	call   c0103994 <get_pte>
c0104159:	83 c4 10             	add    $0x10,%esp
c010415c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010415f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104163:	75 1f                	jne    c0104184 <check_pgdir+0x44a>
c0104165:	8d 83 04 e7 fe ff    	lea    -0x118fc(%ebx),%eax
c010416b:	50                   	push   %eax
c010416c:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104172:	50                   	push   %eax
c0104173:	68 2b 02 00 00       	push   $0x22b
c0104178:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c010417e:	50                   	push   %eax
c010417f:	e8 55 c3 ff ff       	call   c01004d9 <__panic>
    assert(pte2page(*ptep) == p1);
c0104184:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104187:	8b 00                	mov    (%eax),%eax
c0104189:	83 ec 0c             	sub    $0xc,%esp
c010418c:	50                   	push   %eax
c010418d:	e8 cd ed ff ff       	call   c0102f5f <pte2page>
c0104192:	83 c4 10             	add    $0x10,%esp
c0104195:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104198:	74 1f                	je     c01041b9 <check_pgdir+0x47f>
c010419a:	8d 83 79 e6 fe ff    	lea    -0x11987(%ebx),%eax
c01041a0:	50                   	push   %eax
c01041a1:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c01041a7:	50                   	push   %eax
c01041a8:	68 2c 02 00 00       	push   $0x22c
c01041ad:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c01041b3:	50                   	push   %eax
c01041b4:	e8 20 c3 ff ff       	call   c01004d9 <__panic>
    assert((*ptep & PTE_U) == 0);
c01041b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041bc:	8b 00                	mov    (%eax),%eax
c01041be:	83 e0 04             	and    $0x4,%eax
c01041c1:	85 c0                	test   %eax,%eax
c01041c3:	74 1f                	je     c01041e4 <check_pgdir+0x4aa>
c01041c5:	8d 83 c8 e7 fe ff    	lea    -0x11838(%ebx),%eax
c01041cb:	50                   	push   %eax
c01041cc:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c01041d2:	50                   	push   %eax
c01041d3:	68 2d 02 00 00       	push   $0x22d
c01041d8:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c01041de:	50                   	push   %eax
c01041df:	e8 f5 c2 ff ff       	call   c01004d9 <__panic>

    page_remove(boot_pgdir, 0x0);
c01041e4:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c01041ea:	83 ec 08             	sub    $0x8,%esp
c01041ed:	6a 00                	push   $0x0
c01041ef:	50                   	push   %eax
c01041f0:	e8 a4 f9 ff ff       	call   c0103b99 <page_remove>
c01041f5:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c01041f8:	83 ec 0c             	sub    $0xc,%esp
c01041fb:	ff 75 f4             	pushl  -0xc(%ebp)
c01041fe:	e8 d0 ed ff ff       	call   c0102fd3 <page_ref>
c0104203:	83 c4 10             	add    $0x10,%esp
c0104206:	83 f8 01             	cmp    $0x1,%eax
c0104209:	74 1f                	je     c010422a <check_pgdir+0x4f0>
c010420b:	8d 83 8f e6 fe ff    	lea    -0x11971(%ebx),%eax
c0104211:	50                   	push   %eax
c0104212:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104218:	50                   	push   %eax
c0104219:	68 30 02 00 00       	push   $0x230
c010421e:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0104224:	50                   	push   %eax
c0104225:	e8 af c2 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p2) == 0);
c010422a:	83 ec 0c             	sub    $0xc,%esp
c010422d:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104230:	e8 9e ed ff ff       	call   c0102fd3 <page_ref>
c0104235:	83 c4 10             	add    $0x10,%esp
c0104238:	85 c0                	test   %eax,%eax
c010423a:	74 1f                	je     c010425b <check_pgdir+0x521>
c010423c:	8d 83 b6 e7 fe ff    	lea    -0x1184a(%ebx),%eax
c0104242:	50                   	push   %eax
c0104243:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104249:	50                   	push   %eax
c010424a:	68 31 02 00 00       	push   $0x231
c010424f:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0104255:	50                   	push   %eax
c0104256:	e8 7e c2 ff ff       	call   c01004d9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c010425b:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0104261:	83 ec 08             	sub    $0x8,%esp
c0104264:	68 00 10 00 00       	push   $0x1000
c0104269:	50                   	push   %eax
c010426a:	e8 2a f9 ff ff       	call   c0103b99 <page_remove>
c010426f:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0104272:	83 ec 0c             	sub    $0xc,%esp
c0104275:	ff 75 f4             	pushl  -0xc(%ebp)
c0104278:	e8 56 ed ff ff       	call   c0102fd3 <page_ref>
c010427d:	83 c4 10             	add    $0x10,%esp
c0104280:	85 c0                	test   %eax,%eax
c0104282:	74 1f                	je     c01042a3 <check_pgdir+0x569>
c0104284:	8d 83 dd e7 fe ff    	lea    -0x11823(%ebx),%eax
c010428a:	50                   	push   %eax
c010428b:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104291:	50                   	push   %eax
c0104292:	68 34 02 00 00       	push   $0x234
c0104297:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c010429d:	50                   	push   %eax
c010429e:	e8 36 c2 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p2) == 0);
c01042a3:	83 ec 0c             	sub    $0xc,%esp
c01042a6:	ff 75 e4             	pushl  -0x1c(%ebp)
c01042a9:	e8 25 ed ff ff       	call   c0102fd3 <page_ref>
c01042ae:	83 c4 10             	add    $0x10,%esp
c01042b1:	85 c0                	test   %eax,%eax
c01042b3:	74 1f                	je     c01042d4 <check_pgdir+0x59a>
c01042b5:	8d 83 b6 e7 fe ff    	lea    -0x1184a(%ebx),%eax
c01042bb:	50                   	push   %eax
c01042bc:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c01042c2:	50                   	push   %eax
c01042c3:	68 35 02 00 00       	push   $0x235
c01042c8:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c01042ce:	50                   	push   %eax
c01042cf:	e8 05 c2 ff ff       	call   c01004d9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c01042d4:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c01042da:	8b 00                	mov    (%eax),%eax
c01042dc:	83 ec 0c             	sub    $0xc,%esp
c01042df:	50                   	push   %eax
c01042e0:	e8 c8 ec ff ff       	call   c0102fad <pde2page>
c01042e5:	83 c4 10             	add    $0x10,%esp
c01042e8:	83 ec 0c             	sub    $0xc,%esp
c01042eb:	50                   	push   %eax
c01042ec:	e8 e2 ec ff ff       	call   c0102fd3 <page_ref>
c01042f1:	83 c4 10             	add    $0x10,%esp
c01042f4:	83 f8 01             	cmp    $0x1,%eax
c01042f7:	74 1f                	je     c0104318 <check_pgdir+0x5de>
c01042f9:	8d 83 f0 e7 fe ff    	lea    -0x11810(%ebx),%eax
c01042ff:	50                   	push   %eax
c0104300:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104306:	50                   	push   %eax
c0104307:	68 37 02 00 00       	push   $0x237
c010430c:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0104312:	50                   	push   %eax
c0104313:	e8 c1 c1 ff ff       	call   c01004d9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104318:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c010431e:	8b 00                	mov    (%eax),%eax
c0104320:	83 ec 0c             	sub    $0xc,%esp
c0104323:	50                   	push   %eax
c0104324:	e8 84 ec ff ff       	call   c0102fad <pde2page>
c0104329:	83 c4 10             	add    $0x10,%esp
c010432c:	83 ec 08             	sub    $0x8,%esp
c010432f:	6a 01                	push   $0x1
c0104331:	50                   	push   %eax
c0104332:	e8 a3 ef ff ff       	call   c01032da <free_pages>
c0104337:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c010433a:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0104340:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104346:	83 ec 0c             	sub    $0xc,%esp
c0104349:	8d 83 17 e8 fe ff    	lea    -0x117e9(%ebx),%eax
c010434f:	50                   	push   %eax
c0104350:	e8 d4 bf ff ff       	call   c0100329 <cprintf>
c0104355:	83 c4 10             	add    $0x10,%esp
}
c0104358:	90                   	nop
c0104359:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010435c:	c9                   	leave  
c010435d:	c3                   	ret    

c010435e <check_boot_pgdir>:

static void
check_boot_pgdir(void)
{
c010435e:	55                   	push   %ebp
c010435f:	89 e5                	mov    %esp,%ebp
c0104361:	53                   	push   %ebx
c0104362:	83 ec 24             	sub    $0x24,%esp
c0104365:	e8 4c bf ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c010436a:	81 c3 e6 45 01 00    	add    $0x145e6,%ebx
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE)
c0104370:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104377:	e9 b5 00 00 00       	jmp    c0104431 <check_boot_pgdir+0xd3>
    {
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c010437c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010437f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104382:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104385:	c1 e8 0c             	shr    $0xc,%eax
c0104388:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010438b:	8b 83 30 35 00 00    	mov    0x3530(%ebx),%eax
c0104391:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104394:	72 1b                	jb     c01043b1 <check_boot_pgdir+0x53>
c0104396:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104399:	8d 83 5c e4 fe ff    	lea    -0x11ba4(%ebx),%eax
c010439f:	50                   	push   %eax
c01043a0:	68 45 02 00 00       	push   $0x245
c01043a5:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c01043ab:	50                   	push   %eax
c01043ac:	e8 28 c1 ff ff       	call   c01004d9 <__panic>
c01043b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043b4:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01043b9:	89 c2                	mov    %eax,%edx
c01043bb:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c01043c1:	83 ec 04             	sub    $0x4,%esp
c01043c4:	6a 00                	push   $0x0
c01043c6:	52                   	push   %edx
c01043c7:	50                   	push   %eax
c01043c8:	e8 c7 f5 ff ff       	call   c0103994 <get_pte>
c01043cd:	83 c4 10             	add    $0x10,%esp
c01043d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01043d3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01043d7:	75 1f                	jne    c01043f8 <check_boot_pgdir+0x9a>
c01043d9:	8d 83 34 e8 fe ff    	lea    -0x117cc(%ebx),%eax
c01043df:	50                   	push   %eax
c01043e0:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c01043e6:	50                   	push   %eax
c01043e7:	68 45 02 00 00       	push   $0x245
c01043ec:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c01043f2:	50                   	push   %eax
c01043f3:	e8 e1 c0 ff ff       	call   c01004d9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01043f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043fb:	8b 00                	mov    (%eax),%eax
c01043fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104402:	89 c2                	mov    %eax,%edx
c0104404:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104407:	39 c2                	cmp    %eax,%edx
c0104409:	74 1f                	je     c010442a <check_boot_pgdir+0xcc>
c010440b:	8d 83 71 e8 fe ff    	lea    -0x1178f(%ebx),%eax
c0104411:	50                   	push   %eax
c0104412:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104418:	50                   	push   %eax
c0104419:	68 46 02 00 00       	push   $0x246
c010441e:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0104424:	50                   	push   %eax
c0104425:	e8 af c0 ff ff       	call   c01004d9 <__panic>
    for (i = 0; i < npage; i += PGSIZE)
c010442a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104431:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104434:	8b 83 30 35 00 00    	mov    0x3530(%ebx),%eax
c010443a:	39 c2                	cmp    %eax,%edx
c010443c:	0f 82 3a ff ff ff    	jb     c010437c <check_boot_pgdir+0x1e>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104442:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0104448:	05 ac 0f 00 00       	add    $0xfac,%eax
c010444d:	8b 00                	mov    (%eax),%eax
c010444f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104454:	89 c2                	mov    %eax,%edx
c0104456:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c010445c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010445f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104466:	77 1b                	ja     c0104483 <check_boot_pgdir+0x125>
c0104468:	ff 75 f0             	pushl  -0x10(%ebp)
c010446b:	8d 83 00 e5 fe ff    	lea    -0x11b00(%ebx),%eax
c0104471:	50                   	push   %eax
c0104472:	68 49 02 00 00       	push   $0x249
c0104477:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c010447d:	50                   	push   %eax
c010447e:	e8 56 c0 ff ff       	call   c01004d9 <__panic>
c0104483:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104486:	05 00 00 00 40       	add    $0x40000000,%eax
c010448b:	39 d0                	cmp    %edx,%eax
c010448d:	74 1f                	je     c01044ae <check_boot_pgdir+0x150>
c010448f:	8d 83 88 e8 fe ff    	lea    -0x11778(%ebx),%eax
c0104495:	50                   	push   %eax
c0104496:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c010449c:	50                   	push   %eax
c010449d:	68 49 02 00 00       	push   $0x249
c01044a2:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c01044a8:	50                   	push   %eax
c01044a9:	e8 2b c0 ff ff       	call   c01004d9 <__panic>

    assert(boot_pgdir[0] == 0);
c01044ae:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c01044b4:	8b 00                	mov    (%eax),%eax
c01044b6:	85 c0                	test   %eax,%eax
c01044b8:	74 1f                	je     c01044d9 <check_boot_pgdir+0x17b>
c01044ba:	8d 83 bc e8 fe ff    	lea    -0x11744(%ebx),%eax
c01044c0:	50                   	push   %eax
c01044c1:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c01044c7:	50                   	push   %eax
c01044c8:	68 4b 02 00 00       	push   $0x24b
c01044cd:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c01044d3:	50                   	push   %eax
c01044d4:	e8 00 c0 ff ff       	call   c01004d9 <__panic>

    struct Page *p;
    p = alloc_page();
c01044d9:	83 ec 0c             	sub    $0xc,%esp
c01044dc:	6a 01                	push   $0x1
c01044de:	e8 a7 ed ff ff       	call   c010328a <alloc_pages>
c01044e3:	83 c4 10             	add    $0x10,%esp
c01044e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01044e9:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c01044ef:	6a 02                	push   $0x2
c01044f1:	68 00 01 00 00       	push   $0x100
c01044f6:	ff 75 ec             	pushl  -0x14(%ebp)
c01044f9:	50                   	push   %eax
c01044fa:	e8 dd f6 ff ff       	call   c0103bdc <page_insert>
c01044ff:	83 c4 10             	add    $0x10,%esp
c0104502:	85 c0                	test   %eax,%eax
c0104504:	74 1f                	je     c0104525 <check_boot_pgdir+0x1c7>
c0104506:	8d 83 d0 e8 fe ff    	lea    -0x11730(%ebx),%eax
c010450c:	50                   	push   %eax
c010450d:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104513:	50                   	push   %eax
c0104514:	68 4f 02 00 00       	push   $0x24f
c0104519:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c010451f:	50                   	push   %eax
c0104520:	e8 b4 bf ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p) == 1);
c0104525:	83 ec 0c             	sub    $0xc,%esp
c0104528:	ff 75 ec             	pushl  -0x14(%ebp)
c010452b:	e8 a3 ea ff ff       	call   c0102fd3 <page_ref>
c0104530:	83 c4 10             	add    $0x10,%esp
c0104533:	83 f8 01             	cmp    $0x1,%eax
c0104536:	74 1f                	je     c0104557 <check_boot_pgdir+0x1f9>
c0104538:	8d 83 fe e8 fe ff    	lea    -0x11702(%ebx),%eax
c010453e:	50                   	push   %eax
c010453f:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104545:	50                   	push   %eax
c0104546:	68 50 02 00 00       	push   $0x250
c010454b:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0104551:	50                   	push   %eax
c0104552:	e8 82 bf ff ff       	call   c01004d9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104557:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c010455d:	6a 02                	push   $0x2
c010455f:	68 00 11 00 00       	push   $0x1100
c0104564:	ff 75 ec             	pushl  -0x14(%ebp)
c0104567:	50                   	push   %eax
c0104568:	e8 6f f6 ff ff       	call   c0103bdc <page_insert>
c010456d:	83 c4 10             	add    $0x10,%esp
c0104570:	85 c0                	test   %eax,%eax
c0104572:	74 1f                	je     c0104593 <check_boot_pgdir+0x235>
c0104574:	8d 83 10 e9 fe ff    	lea    -0x116f0(%ebx),%eax
c010457a:	50                   	push   %eax
c010457b:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104581:	50                   	push   %eax
c0104582:	68 51 02 00 00       	push   $0x251
c0104587:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c010458d:	50                   	push   %eax
c010458e:	e8 46 bf ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p) == 2);
c0104593:	83 ec 0c             	sub    $0xc,%esp
c0104596:	ff 75 ec             	pushl  -0x14(%ebp)
c0104599:	e8 35 ea ff ff       	call   c0102fd3 <page_ref>
c010459e:	83 c4 10             	add    $0x10,%esp
c01045a1:	83 f8 02             	cmp    $0x2,%eax
c01045a4:	74 1f                	je     c01045c5 <check_boot_pgdir+0x267>
c01045a6:	8d 83 47 e9 fe ff    	lea    -0x116b9(%ebx),%eax
c01045ac:	50                   	push   %eax
c01045ad:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c01045b3:	50                   	push   %eax
c01045b4:	68 52 02 00 00       	push   $0x252
c01045b9:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c01045bf:	50                   	push   %eax
c01045c0:	e8 14 bf ff ff       	call   c01004d9 <__panic>

    const char *str = "ucore: Hello world!!";
c01045c5:	8d 83 58 e9 fe ff    	lea    -0x116a8(%ebx),%eax
c01045cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    strcpy((void *)0x100, str);
c01045ce:	83 ec 08             	sub    $0x8,%esp
c01045d1:	ff 75 e8             	pushl  -0x18(%ebp)
c01045d4:	68 00 01 00 00       	push   $0x100
c01045d9:	e8 b7 15 00 00       	call   c0105b95 <strcpy>
c01045de:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01045e1:	83 ec 08             	sub    $0x8,%esp
c01045e4:	68 00 11 00 00       	push   $0x1100
c01045e9:	68 00 01 00 00       	push   $0x100
c01045ee:	e8 30 16 00 00       	call   c0105c23 <strcmp>
c01045f3:	83 c4 10             	add    $0x10,%esp
c01045f6:	85 c0                	test   %eax,%eax
c01045f8:	74 1f                	je     c0104619 <check_boot_pgdir+0x2bb>
c01045fa:	8d 83 70 e9 fe ff    	lea    -0x11690(%ebx),%eax
c0104600:	50                   	push   %eax
c0104601:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104607:	50                   	push   %eax
c0104608:	68 56 02 00 00       	push   $0x256
c010460d:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c0104613:	50                   	push   %eax
c0104614:	e8 c0 be ff ff       	call   c01004d9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104619:	83 ec 0c             	sub    $0xc,%esp
c010461c:	ff 75 ec             	pushl  -0x14(%ebp)
c010461f:	e8 e2 e8 ff ff       	call   c0102f06 <page2kva>
c0104624:	83 c4 10             	add    $0x10,%esp
c0104627:	05 00 01 00 00       	add    $0x100,%eax
c010462c:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010462f:	83 ec 0c             	sub    $0xc,%esp
c0104632:	68 00 01 00 00       	push   $0x100
c0104637:	e8 ed 14 00 00       	call   c0105b29 <strlen>
c010463c:	83 c4 10             	add    $0x10,%esp
c010463f:	85 c0                	test   %eax,%eax
c0104641:	74 1f                	je     c0104662 <check_boot_pgdir+0x304>
c0104643:	8d 83 a8 e9 fe ff    	lea    -0x11658(%ebx),%eax
c0104649:	50                   	push   %eax
c010464a:	8d 83 49 e5 fe ff    	lea    -0x11ab7(%ebx),%eax
c0104650:	50                   	push   %eax
c0104651:	68 59 02 00 00       	push   $0x259
c0104656:	8d 83 24 e5 fe ff    	lea    -0x11adc(%ebx),%eax
c010465c:	50                   	push   %eax
c010465d:	e8 77 be ff ff       	call   c01004d9 <__panic>

    free_page(p);
c0104662:	83 ec 08             	sub    $0x8,%esp
c0104665:	6a 01                	push   $0x1
c0104667:	ff 75 ec             	pushl  -0x14(%ebp)
c010466a:	e8 6b ec ff ff       	call   c01032da <free_pages>
c010466f:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0104672:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0104678:	8b 00                	mov    (%eax),%eax
c010467a:	83 ec 0c             	sub    $0xc,%esp
c010467d:	50                   	push   %eax
c010467e:	e8 2a e9 ff ff       	call   c0102fad <pde2page>
c0104683:	83 c4 10             	add    $0x10,%esp
c0104686:	83 ec 08             	sub    $0x8,%esp
c0104689:	6a 01                	push   $0x1
c010468b:	50                   	push   %eax
c010468c:	e8 49 ec ff ff       	call   c01032da <free_pages>
c0104691:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0104694:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c010469a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01046a0:	83 ec 0c             	sub    $0xc,%esp
c01046a3:	8d 83 cc e9 fe ff    	lea    -0x11634(%ebx),%eax
c01046a9:	50                   	push   %eax
c01046aa:	e8 7a bc ff ff       	call   c0100329 <cprintf>
c01046af:	83 c4 10             	add    $0x10,%esp
}
c01046b2:	90                   	nop
c01046b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01046b6:	c9                   	leave  
c01046b7:	c3                   	ret    

c01046b8 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm)
{
c01046b8:	55                   	push   %ebp
c01046b9:	89 e5                	mov    %esp,%ebp
c01046bb:	e8 f2 bb ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01046c0:	05 90 42 01 00       	add    $0x14290,%eax
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01046c5:	8b 55 08             	mov    0x8(%ebp),%edx
c01046c8:	83 e2 04             	and    $0x4,%edx
c01046cb:	85 d2                	test   %edx,%edx
c01046cd:	74 07                	je     c01046d6 <perm2str+0x1e>
c01046cf:	ba 75 00 00 00       	mov    $0x75,%edx
c01046d4:	eb 05                	jmp    c01046db <perm2str+0x23>
c01046d6:	ba 2d 00 00 00       	mov    $0x2d,%edx
c01046db:	88 90 b8 35 00 00    	mov    %dl,0x35b8(%eax)
    str[1] = 'r';
c01046e1:	c6 80 b9 35 00 00 72 	movb   $0x72,0x35b9(%eax)
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01046e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01046eb:	83 e2 02             	and    $0x2,%edx
c01046ee:	85 d2                	test   %edx,%edx
c01046f0:	74 07                	je     c01046f9 <perm2str+0x41>
c01046f2:	ba 77 00 00 00       	mov    $0x77,%edx
c01046f7:	eb 05                	jmp    c01046fe <perm2str+0x46>
c01046f9:	ba 2d 00 00 00       	mov    $0x2d,%edx
c01046fe:	88 90 ba 35 00 00    	mov    %dl,0x35ba(%eax)
    str[3] = '\0';
c0104704:	c6 80 bb 35 00 00 00 	movb   $0x0,0x35bb(%eax)
    return str;
c010470b:	8d 80 b8 35 00 00    	lea    0x35b8(%eax),%eax
}
c0104711:	5d                   	pop    %ebp
c0104712:	c3                   	ret    

c0104713 <get_pgtable_items>:
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store)
{
c0104713:	55                   	push   %ebp
c0104714:	89 e5                	mov    %esp,%ebp
c0104716:	83 ec 10             	sub    $0x10,%esp
c0104719:	e8 94 bb ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010471e:	05 32 42 01 00       	add    $0x14232,%eax
    if (start >= right)
c0104723:	8b 45 10             	mov    0x10(%ebp),%eax
c0104726:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104729:	72 0e                	jb     c0104739 <get_pgtable_items+0x26>
    {
        return 0;
c010472b:	b8 00 00 00 00       	mov    $0x0,%eax
c0104730:	e9 9a 00 00 00       	jmp    c01047cf <get_pgtable_items+0xbc>
    }
    while (start < right && !(table[start] & PTE_P))
    {
        start++;
c0104735:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P))
c0104739:	8b 45 10             	mov    0x10(%ebp),%eax
c010473c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010473f:	73 18                	jae    c0104759 <get_pgtable_items+0x46>
c0104741:	8b 45 10             	mov    0x10(%ebp),%eax
c0104744:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010474b:	8b 45 14             	mov    0x14(%ebp),%eax
c010474e:	01 d0                	add    %edx,%eax
c0104750:	8b 00                	mov    (%eax),%eax
c0104752:	83 e0 01             	and    $0x1,%eax
c0104755:	85 c0                	test   %eax,%eax
c0104757:	74 dc                	je     c0104735 <get_pgtable_items+0x22>
    }
    if (start < right)
c0104759:	8b 45 10             	mov    0x10(%ebp),%eax
c010475c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010475f:	73 69                	jae    c01047ca <get_pgtable_items+0xb7>
    {
        if (left_store != NULL)
c0104761:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104765:	74 08                	je     c010476f <get_pgtable_items+0x5c>
        {
            *left_store = start;
c0104767:	8b 45 18             	mov    0x18(%ebp),%eax
c010476a:	8b 55 10             	mov    0x10(%ebp),%edx
c010476d:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start++] & PTE_USER);
c010476f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104772:	8d 50 01             	lea    0x1(%eax),%edx
c0104775:	89 55 10             	mov    %edx,0x10(%ebp)
c0104778:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010477f:	8b 45 14             	mov    0x14(%ebp),%eax
c0104782:	01 d0                	add    %edx,%eax
c0104784:	8b 00                	mov    (%eax),%eax
c0104786:	83 e0 07             	and    $0x7,%eax
c0104789:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
c010478c:	eb 04                	jmp    c0104792 <get_pgtable_items+0x7f>
        {
            start++;
c010478e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
c0104792:	8b 45 10             	mov    0x10(%ebp),%eax
c0104795:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104798:	73 1d                	jae    c01047b7 <get_pgtable_items+0xa4>
c010479a:	8b 45 10             	mov    0x10(%ebp),%eax
c010479d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01047a4:	8b 45 14             	mov    0x14(%ebp),%eax
c01047a7:	01 d0                	add    %edx,%eax
c01047a9:	8b 00                	mov    (%eax),%eax
c01047ab:	83 e0 07             	and    $0x7,%eax
c01047ae:	89 c2                	mov    %eax,%edx
c01047b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01047b3:	39 c2                	cmp    %eax,%edx
c01047b5:	74 d7                	je     c010478e <get_pgtable_items+0x7b>
        }
        if (right_store != NULL)
c01047b7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01047bb:	74 08                	je     c01047c5 <get_pgtable_items+0xb2>
        {
            *right_store = start;
c01047bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01047c0:	8b 55 10             	mov    0x10(%ebp),%edx
c01047c3:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01047c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01047c8:	eb 05                	jmp    c01047cf <get_pgtable_items+0xbc>
    }
    return 0;
c01047ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01047cf:	c9                   	leave  
c01047d0:	c3                   	ret    

c01047d1 <print_pgdir>:

//print_pgdir - print the PDT&PT
void print_pgdir(void)
{
c01047d1:	55                   	push   %ebp
c01047d2:	89 e5                	mov    %esp,%ebp
c01047d4:	57                   	push   %edi
c01047d5:	56                   	push   %esi
c01047d6:	53                   	push   %ebx
c01047d7:	83 ec 3c             	sub    $0x3c,%esp
c01047da:	e8 d7 ba ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c01047df:	81 c3 71 41 01 00    	add    $0x14171,%ebx
    cprintf("-------------------- BEGIN --------------------\n");
c01047e5:	83 ec 0c             	sub    $0xc,%esp
c01047e8:	8d 83 ec e9 fe ff    	lea    -0x11614(%ebx),%eax
c01047ee:	50                   	push   %eax
c01047ef:	e8 35 bb ff ff       	call   c0100329 <cprintf>
c01047f4:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c01047f7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
c01047fe:	e9 ef 00 00 00       	jmp    c01048f2 <print_pgdir+0x121>
    {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104806:	83 ec 0c             	sub    $0xc,%esp
c0104809:	50                   	push   %eax
c010480a:	e8 a9 fe ff ff       	call   c01046b8 <perm2str>
c010480f:	83 c4 10             	add    $0x10,%esp
c0104812:	89 45 c4             	mov    %eax,-0x3c(%ebp)
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104818:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010481b:	29 c2                	sub    %eax,%edx
c010481d:	89 d0                	mov    %edx,%eax
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010481f:	89 c6                	mov    %eax,%esi
c0104821:	c1 e6 16             	shl    $0x16,%esi
c0104824:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104827:	89 c1                	mov    %eax,%ecx
c0104829:	c1 e1 16             	shl    $0x16,%ecx
c010482c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010482f:	89 c2                	mov    %eax,%edx
c0104831:	c1 e2 16             	shl    $0x16,%edx
c0104834:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104837:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010483a:	29 c7                	sub    %eax,%edi
c010483c:	89 f8                	mov    %edi,%eax
c010483e:	83 ec 08             	sub    $0x8,%esp
c0104841:	ff 75 c4             	pushl  -0x3c(%ebp)
c0104844:	56                   	push   %esi
c0104845:	51                   	push   %ecx
c0104846:	52                   	push   %edx
c0104847:	50                   	push   %eax
c0104848:	8d 83 1d ea fe ff    	lea    -0x115e3(%ebx),%eax
c010484e:	50                   	push   %eax
c010484f:	e8 d5 ba ff ff       	call   c0100329 <cprintf>
c0104854:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
c0104857:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010485a:	c1 e0 0a             	shl    $0xa,%eax
c010485d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
c0104860:	eb 54                	jmp    c01048b6 <print_pgdir+0xe5>
        {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104865:	83 ec 0c             	sub    $0xc,%esp
c0104868:	50                   	push   %eax
c0104869:	e8 4a fe ff ff       	call   c01046b8 <perm2str>
c010486e:	83 c4 10             	add    $0x10,%esp
c0104871:	89 45 c4             	mov    %eax,-0x3c(%ebp)
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104874:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104877:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010487a:	29 c2                	sub    %eax,%edx
c010487c:	89 d0                	mov    %edx,%eax
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010487e:	89 c6                	mov    %eax,%esi
c0104880:	c1 e6 0c             	shl    $0xc,%esi
c0104883:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104886:	89 c1                	mov    %eax,%ecx
c0104888:	c1 e1 0c             	shl    $0xc,%ecx
c010488b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010488e:	89 c2                	mov    %eax,%edx
c0104890:	c1 e2 0c             	shl    $0xc,%edx
c0104893:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0104896:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104899:	29 c7                	sub    %eax,%edi
c010489b:	89 f8                	mov    %edi,%eax
c010489d:	83 ec 08             	sub    $0x8,%esp
c01048a0:	ff 75 c4             	pushl  -0x3c(%ebp)
c01048a3:	56                   	push   %esi
c01048a4:	51                   	push   %ecx
c01048a5:	52                   	push   %edx
c01048a6:	50                   	push   %eax
c01048a7:	8d 83 3c ea fe ff    	lea    -0x115c4(%ebx),%eax
c01048ad:	50                   	push   %eax
c01048ae:	e8 76 ba ff ff       	call   c0100329 <cprintf>
c01048b3:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
c01048b6:	bf 00 00 c0 fa       	mov    $0xfac00000,%edi
c01048bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01048be:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048c1:	89 d6                	mov    %edx,%esi
c01048c3:	c1 e6 0a             	shl    $0xa,%esi
c01048c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01048c9:	89 d1                	mov    %edx,%ecx
c01048cb:	c1 e1 0a             	shl    $0xa,%ecx
c01048ce:	83 ec 08             	sub    $0x8,%esp
c01048d1:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01048d4:	52                   	push   %edx
c01048d5:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01048d8:	52                   	push   %edx
c01048d9:	57                   	push   %edi
c01048da:	50                   	push   %eax
c01048db:	56                   	push   %esi
c01048dc:	51                   	push   %ecx
c01048dd:	e8 31 fe ff ff       	call   c0104713 <get_pgtable_items>
c01048e2:	83 c4 20             	add    $0x20,%esp
c01048e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01048e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01048ec:	0f 85 70 ff ff ff    	jne    c0104862 <print_pgdir+0x91>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
c01048f2:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01048f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01048fa:	83 ec 08             	sub    $0x8,%esp
c01048fd:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104900:	52                   	push   %edx
c0104901:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104904:	52                   	push   %edx
c0104905:	51                   	push   %ecx
c0104906:	50                   	push   %eax
c0104907:	68 00 04 00 00       	push   $0x400
c010490c:	6a 00                	push   $0x0
c010490e:	e8 00 fe ff ff       	call   c0104713 <get_pgtable_items>
c0104913:	83 c4 20             	add    $0x20,%esp
c0104916:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104919:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010491d:	0f 85 e0 fe ff ff    	jne    c0104803 <print_pgdir+0x32>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104923:	83 ec 0c             	sub    $0xc,%esp
c0104926:	8d 83 60 ea fe ff    	lea    -0x115a0(%ebx),%eax
c010492c:	50                   	push   %eax
c010492d:	e8 f7 b9 ff ff       	call   c0100329 <cprintf>
c0104932:	83 c4 10             	add    $0x10,%esp
}
c0104935:	90                   	nop
c0104936:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104939:	5b                   	pop    %ebx
c010493a:	5e                   	pop    %esi
c010493b:	5f                   	pop    %edi
c010493c:	5d                   	pop    %ebp
c010493d:	c3                   	ret    

c010493e <__x86.get_pc_thunk.si>:
c010493e:	8b 34 24             	mov    (%esp),%esi
c0104941:	c3                   	ret    

c0104942 <page2ppn>:
page2ppn(struct Page *page) {
c0104942:	55                   	push   %ebp
c0104943:	89 e5                	mov    %esp,%ebp
c0104945:	e8 68 b9 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010494a:	05 06 40 01 00       	add    $0x14006,%eax
    return page - pages;
c010494f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104952:	c7 c0 78 bf 11 c0    	mov    $0xc011bf78,%eax
c0104958:	8b 00                	mov    (%eax),%eax
c010495a:	29 c2                	sub    %eax,%edx
c010495c:	89 d0                	mov    %edx,%eax
c010495e:	c1 f8 02             	sar    $0x2,%eax
c0104961:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0104967:	5d                   	pop    %ebp
c0104968:	c3                   	ret    

c0104969 <page2pa>:
page2pa(struct Page *page) {
c0104969:	55                   	push   %ebp
c010496a:	89 e5                	mov    %esp,%ebp
c010496c:	e8 41 b9 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0104971:	05 df 3f 01 00       	add    $0x13fdf,%eax
    return page2ppn(page) << PGSHIFT;
c0104976:	ff 75 08             	pushl  0x8(%ebp)
c0104979:	e8 c4 ff ff ff       	call   c0104942 <page2ppn>
c010497e:	83 c4 04             	add    $0x4,%esp
c0104981:	c1 e0 0c             	shl    $0xc,%eax
}
c0104984:	c9                   	leave  
c0104985:	c3                   	ret    

c0104986 <page_ref>:
page_ref(struct Page *page) {
c0104986:	55                   	push   %ebp
c0104987:	89 e5                	mov    %esp,%ebp
c0104989:	e8 24 b9 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010498e:	05 c2 3f 01 00       	add    $0x13fc2,%eax
    return page->ref;
c0104993:	8b 45 08             	mov    0x8(%ebp),%eax
c0104996:	8b 00                	mov    (%eax),%eax
}
c0104998:	5d                   	pop    %ebp
c0104999:	c3                   	ret    

c010499a <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c010499a:	55                   	push   %ebp
c010499b:	89 e5                	mov    %esp,%ebp
c010499d:	e8 10 b9 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01049a2:	05 ae 3f 01 00       	add    $0x13fae,%eax
    page->ref = val;
c01049a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01049aa:	8b 55 0c             	mov    0xc(%ebp),%edx
c01049ad:	89 10                	mov    %edx,(%eax)
}
c01049af:	90                   	nop
c01049b0:	5d                   	pop    %ebp
c01049b1:	c3                   	ret    

c01049b2 <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void)
{
c01049b2:	55                   	push   %ebp
c01049b3:	89 e5                	mov    %esp,%ebp
c01049b5:	83 ec 10             	sub    $0x10,%esp
c01049b8:	e8 f5 b8 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01049bd:	05 93 3f 01 00       	add    $0x13f93,%eax
c01049c2:	c7 c2 7c bf 11 c0    	mov    $0xc011bf7c,%edx
c01049c8:	89 55 fc             	mov    %edx,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01049cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01049ce:	8b 4d fc             	mov    -0x4(%ebp),%ecx
c01049d1:	89 4a 04             	mov    %ecx,0x4(%edx)
c01049d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01049d7:	8b 4a 04             	mov    0x4(%edx),%ecx
c01049da:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01049dd:	89 0a                	mov    %ecx,(%edx)
    list_init(&free_list);
    nr_free = 0;
c01049df:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c01049e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
c01049ec:	90                   	nop
c01049ed:	c9                   	leave  
c01049ee:	c3                   	ret    

c01049ef <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n)
{
c01049ef:	55                   	push   %ebp
c01049f0:	89 e5                	mov    %esp,%ebp
c01049f2:	53                   	push   %ebx
c01049f3:	83 ec 34             	sub    $0x34,%esp
c01049f6:	e8 bb b8 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c01049fb:	81 c3 55 3f 01 00    	add    $0x13f55,%ebx
    assert(n > 0);
c0104a01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104a05:	75 1c                	jne    c0104a23 <default_init_memmap+0x34>
c0104a07:	8d 83 94 ea fe ff    	lea    -0x1156c(%ebx),%eax
c0104a0d:	50                   	push   %eax
c0104a0e:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0104a14:	50                   	push   %eax
c0104a15:	6a 6f                	push   $0x6f
c0104a17:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0104a1d:	50                   	push   %eax
c0104a1e:	e8 b6 ba ff ff       	call   c01004d9 <__panic>
    struct Page *p = base;
c0104a23:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c0104a29:	eb 72                	jmp    c0104a9d <default_init_memmap+0xae>
    {
        assert(PageReserved(p)); // 看看这个页是不是被内核保留的
c0104a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a2e:	83 c0 04             	add    $0x4,%eax
c0104a31:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104a38:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104a41:	0f a3 10             	bt     %edx,(%eax)
c0104a44:	19 c0                	sbb    %eax,%eax
c0104a46:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0104a49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104a4d:	0f 95 c0             	setne  %al
c0104a50:	0f b6 c0             	movzbl %al,%eax
c0104a53:	85 c0                	test   %eax,%eax
c0104a55:	75 1c                	jne    c0104a73 <default_init_memmap+0x84>
c0104a57:	8d 83 c5 ea fe ff    	lea    -0x1153b(%ebx),%eax
c0104a5d:	50                   	push   %eax
c0104a5e:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0104a64:	50                   	push   %eax
c0104a65:	6a 73                	push   $0x73
c0104a67:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0104a6d:	50                   	push   %eax
c0104a6e:	e8 66 ba ff ff       	call   c01004d9 <__panic>
        p->flags = p->property = 0;
c0104a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a80:	8b 50 08             	mov    0x8(%eax),%edx
c0104a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a86:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0104a89:	83 ec 08             	sub    $0x8,%esp
c0104a8c:	6a 00                	push   $0x0
c0104a8e:	ff 75 f4             	pushl  -0xc(%ebp)
c0104a91:	e8 04 ff ff ff       	call   c010499a <set_page_ref>
c0104a96:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p++)
c0104a99:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104aa0:	89 d0                	mov    %edx,%eax
c0104aa2:	c1 e0 02             	shl    $0x2,%eax
c0104aa5:	01 d0                	add    %edx,%eax
c0104aa7:	c1 e0 02             	shl    $0x2,%eax
c0104aaa:	89 c2                	mov    %eax,%edx
c0104aac:	8b 45 08             	mov    0x8(%ebp),%eax
c0104aaf:	01 d0                	add    %edx,%eax
c0104ab1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104ab4:	0f 85 71 ff ff ff    	jne    c0104a2b <default_init_memmap+0x3c>
    }
    base->property = n; // 头一个空闲页 要设置数量
c0104aba:	8b 45 08             	mov    0x8(%ebp),%eax
c0104abd:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104ac0:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104ac3:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ac6:	83 c0 04             	add    $0x4,%eax
c0104ac9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104ad0:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104ad3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104ad6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104ad9:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0104adc:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0104ae2:	8b 50 08             	mov    0x8(%eax),%edx
c0104ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ae8:	01 c2                	add    %eax,%edx
c0104aea:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0104af0:	89 50 08             	mov    %edx,0x8(%eax)
    // 初始化玩每个空闲页后 将其要插入到链表每次都插入到节点前面 因为是按地址排序
    list_add_before(&free_list, &(base->page_link));
c0104af3:	8b 45 08             	mov    0x8(%ebp),%eax
c0104af6:	83 c0 0c             	add    $0xc,%eax
c0104af9:	c7 c2 7c bf 11 c0    	mov    $0xc011bf7c,%edx
c0104aff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0104b02:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104b05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b08:	8b 00                	mov    (%eax),%eax
c0104b0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104b0d:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0104b10:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104b13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104b19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104b1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104b1f:	89 10                	mov    %edx,(%eax)
c0104b21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104b24:	8b 10                	mov    (%eax),%edx
c0104b26:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104b29:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104b2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b2f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104b32:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104b35:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b38:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104b3b:	89 10                	mov    %edx,(%eax)
}
c0104b3d:	90                   	nop
c0104b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104b41:	c9                   	leave  
c0104b42:	c3                   	ret    

c0104b43 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
c0104b43:	55                   	push   %ebp
c0104b44:	89 e5                	mov    %esp,%ebp
c0104b46:	53                   	push   %ebx
c0104b47:	83 ec 54             	sub    $0x54,%esp
c0104b4a:	e8 63 b7 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0104b4f:	05 01 3e 01 00       	add    $0x13e01,%eax
    assert(n > 0);
c0104b54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104b58:	75 21                	jne    c0104b7b <default_alloc_pages+0x38>
c0104b5a:	8d 90 94 ea fe ff    	lea    -0x1156c(%eax),%edx
c0104b60:	52                   	push   %edx
c0104b61:	8d 90 9a ea fe ff    	lea    -0x11566(%eax),%edx
c0104b67:	52                   	push   %edx
c0104b68:	68 81 00 00 00       	push   $0x81
c0104b6d:	8d 90 af ea fe ff    	lea    -0x11551(%eax),%edx
c0104b73:	52                   	push   %edx
c0104b74:	89 c3                	mov    %eax,%ebx
c0104b76:	e8 5e b9 ff ff       	call   c01004d9 <__panic>
    if (n > nr_free)
c0104b7b:	c7 c2 7c bf 11 c0    	mov    $0xc011bf7c,%edx
c0104b81:	8b 52 08             	mov    0x8(%edx),%edx
c0104b84:	39 55 08             	cmp    %edx,0x8(%ebp)
c0104b87:	76 0a                	jbe    c0104b93 <default_alloc_pages+0x50>
    {
        return NULL;
c0104b89:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b8e:	e9 55 01 00 00       	jmp    c0104ce8 <default_alloc_pages+0x1a5>
    }
    struct Page *page = NULL;
c0104b93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104b9a:	c7 c2 7c bf 11 c0    	mov    $0xc011bf7c,%edx
c0104ba0:	89 55 f0             	mov    %edx,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
c0104ba3:	eb 1c                	jmp    c0104bc1 <default_alloc_pages+0x7e>
    {
        struct Page *p = le2page(le, page_link);
c0104ba5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104ba8:	83 ea 0c             	sub    $0xc,%edx
c0104bab:	89 55 ec             	mov    %edx,-0x14(%ebp)
        if (p->property >= n)
c0104bae:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104bb1:	8b 52 08             	mov    0x8(%edx),%edx
c0104bb4:	39 55 08             	cmp    %edx,0x8(%ebp)
c0104bb7:	77 08                	ja     c0104bc1 <default_alloc_pages+0x7e>
        {
            page = p;
c0104bb9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104bbc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            break;
c0104bbf:	eb 1a                	jmp    c0104bdb <default_alloc_pages+0x98>
c0104bc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104bc4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return listelm->next;
c0104bc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104bca:	8b 52 04             	mov    0x4(%edx),%edx
    while ((le = list_next(le)) != &free_list)
c0104bcd:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0104bd0:	c7 c2 7c bf 11 c0    	mov    $0xc011bf7c,%edx
c0104bd6:	39 55 f0             	cmp    %edx,-0x10(%ebp)
c0104bd9:	75 ca                	jne    c0104ba5 <default_alloc_pages+0x62>
        }
    }
    if (page != NULL)
c0104bdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104bdf:	0f 84 00 01 00 00    	je     c0104ce5 <default_alloc_pages+0x1a2>
    {
        if (page->property > n)
c0104be5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104be8:	8b 52 08             	mov    0x8(%edx),%edx
c0104beb:	39 55 08             	cmp    %edx,0x8(%ebp)
c0104bee:	0f 83 98 00 00 00    	jae    c0104c8c <default_alloc_pages+0x149>
        {
            struct Page *p = page + n;
c0104bf4:	8b 4d 08             	mov    0x8(%ebp),%ecx
c0104bf7:	89 ca                	mov    %ecx,%edx
c0104bf9:	c1 e2 02             	shl    $0x2,%edx
c0104bfc:	01 ca                	add    %ecx,%edx
c0104bfe:	c1 e2 02             	shl    $0x2,%edx
c0104c01:	89 d1                	mov    %edx,%ecx
c0104c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104c06:	01 ca                	add    %ecx,%edx
c0104c08:	89 55 e8             	mov    %edx,-0x18(%ebp)
            p->property = page->property - n;
c0104c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104c0e:	8b 52 08             	mov    0x8(%edx),%edx
c0104c11:	89 d1                	mov    %edx,%ecx
c0104c13:	2b 4d 08             	sub    0x8(%ebp),%ecx
c0104c16:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104c19:	89 4a 08             	mov    %ecx,0x8(%edx)
            SetPageProperty(p);
c0104c1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104c1f:	83 c2 04             	add    $0x4,%edx
c0104c22:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0104c29:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104c2c:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104c2f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104c32:	0f ab 0a             	bts    %ecx,(%edx)
            list_add(&page->page_link, &(p->page_link));
c0104c35:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104c38:	83 c2 0c             	add    $0xc,%edx
c0104c3b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0104c3e:	83 c1 0c             	add    $0xc,%ecx
c0104c41:	89 4d e0             	mov    %ecx,-0x20(%ebp)
c0104c44:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0104c47:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104c4a:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0104c4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104c50:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104c53:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104c56:	8b 52 04             	mov    0x4(%edx),%edx
c0104c59:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104c5c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
c0104c5f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0104c62:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0104c65:	89 55 c8             	mov    %edx,-0x38(%ebp)
    prev->next = next->prev = elm;
c0104c68:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104c6b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104c6e:	89 0a                	mov    %ecx,(%edx)
c0104c70:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104c73:	8b 0a                	mov    (%edx),%ecx
c0104c75:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104c78:	89 4a 04             	mov    %ecx,0x4(%edx)
    elm->next = next;
c0104c7b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104c7e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
c0104c81:	89 4a 04             	mov    %ecx,0x4(%edx)
    elm->prev = prev;
c0104c84:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104c87:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0104c8a:	89 0a                	mov    %ecx,(%edx)
        }
        list_del(&(page->page_link));
c0104c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104c8f:	83 c2 0c             	add    $0xc,%edx
c0104c92:	89 55 b4             	mov    %edx,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104c95:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104c98:	8b 52 04             	mov    0x4(%edx),%edx
c0104c9b:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
c0104c9e:	8b 09                	mov    (%ecx),%ecx
c0104ca0:	89 4d b0             	mov    %ecx,-0x50(%ebp)
c0104ca3:	89 55 ac             	mov    %edx,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104ca6:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104ca9:	8b 4d ac             	mov    -0x54(%ebp),%ecx
c0104cac:	89 4a 04             	mov    %ecx,0x4(%edx)
    next->prev = prev;
c0104caf:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104cb2:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0104cb5:	89 0a                	mov    %ecx,(%edx)
        nr_free -= n;
c0104cb7:	c7 c2 7c bf 11 c0    	mov    $0xc011bf7c,%edx
c0104cbd:	8b 52 08             	mov    0x8(%edx),%edx
c0104cc0:	2b 55 08             	sub    0x8(%ebp),%edx
c0104cc3:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0104cc9:	89 50 08             	mov    %edx,0x8(%eax)
        ClearPageProperty(page);
c0104ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ccf:	83 c0 04             	add    $0x4,%eax
c0104cd2:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0104cd9:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104cdc:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104cdf:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104ce2:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0104ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104ce8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104ceb:	c9                   	leave  
c0104cec:	c3                   	ret    

c0104ced <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
c0104ced:	55                   	push   %ebp
c0104cee:	89 e5                	mov    %esp,%ebp
c0104cf0:	53                   	push   %ebx
c0104cf1:	81 ec 84 00 00 00    	sub    $0x84,%esp
c0104cf7:	e8 ba b5 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0104cfc:	81 c3 54 3c 01 00    	add    $0x13c54,%ebx
    assert(n > 0);
c0104d02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104d06:	75 1f                	jne    c0104d27 <default_free_pages+0x3a>
c0104d08:	8d 83 94 ea fe ff    	lea    -0x1156c(%ebx),%eax
c0104d0e:	50                   	push   %eax
c0104d0f:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0104d15:	50                   	push   %eax
c0104d16:	68 a4 00 00 00       	push   $0xa4
c0104d1b:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0104d21:	50                   	push   %eax
c0104d22:	e8 b2 b7 ff ff       	call   c01004d9 <__panic>
    struct Page *p = base;
c0104d27:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c0104d2d:	e9 95 00 00 00       	jmp    c0104dc7 <default_free_pages+0xda>
    {
        assert(!PageReserved(p) && !PageProperty(p));
c0104d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d35:	83 c0 04             	add    $0x4,%eax
c0104d38:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104d3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104d42:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d45:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104d48:	0f a3 10             	bt     %edx,(%eax)
c0104d4b:	19 c0                	sbb    %eax,%eax
c0104d4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0104d50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104d54:	0f 95 c0             	setne  %al
c0104d57:	0f b6 c0             	movzbl %al,%eax
c0104d5a:	85 c0                	test   %eax,%eax
c0104d5c:	75 2c                	jne    c0104d8a <default_free_pages+0x9d>
c0104d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d61:	83 c0 04             	add    $0x4,%eax
c0104d64:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0104d6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104d6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d71:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104d74:	0f a3 10             	bt     %edx,(%eax)
c0104d77:	19 c0                	sbb    %eax,%eax
c0104d79:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0104d7c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104d80:	0f 95 c0             	setne  %al
c0104d83:	0f b6 c0             	movzbl %al,%eax
c0104d86:	85 c0                	test   %eax,%eax
c0104d88:	74 1f                	je     c0104da9 <default_free_pages+0xbc>
c0104d8a:	8d 83 d8 ea fe ff    	lea    -0x11528(%ebx),%eax
c0104d90:	50                   	push   %eax
c0104d91:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0104d97:	50                   	push   %eax
c0104d98:	68 a8 00 00 00       	push   $0xa8
c0104d9d:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0104da3:	50                   	push   %eax
c0104da4:	e8 30 b7 ff ff       	call   c01004d9 <__panic>
        p->flags = 0;
c0104da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0104db3:	83 ec 08             	sub    $0x8,%esp
c0104db6:	6a 00                	push   $0x0
c0104db8:	ff 75 f4             	pushl  -0xc(%ebp)
c0104dbb:	e8 da fb ff ff       	call   c010499a <set_page_ref>
c0104dc0:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p++)
c0104dc3:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104dca:	89 d0                	mov    %edx,%eax
c0104dcc:	c1 e0 02             	shl    $0x2,%eax
c0104dcf:	01 d0                	add    %edx,%eax
c0104dd1:	c1 e0 02             	shl    $0x2,%eax
c0104dd4:	89 c2                	mov    %eax,%edx
c0104dd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dd9:	01 d0                	add    %edx,%eax
c0104ddb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104dde:	0f 85 4e ff ff ff    	jne    c0104d32 <default_free_pages+0x45>
    }
    base->property = n;
c0104de4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104de7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104dea:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104ded:	8b 45 08             	mov    0x8(%ebp),%eax
c0104df0:	83 c0 04             	add    $0x4,%eax
c0104df3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104dfa:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104dfd:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104e00:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104e03:	0f ab 10             	bts    %edx,(%eax)
c0104e06:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0104e0c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return listelm->next;
c0104e0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104e12:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0104e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 遍历freelist，合并页块
    while (le != &free_list)
c0104e18:	e9 08 01 00 00       	jmp    c0104f25 <default_free_pages+0x238>
    {
        p = le2page(le, page_link);
c0104e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e20:	83 e8 0c             	sub    $0xc,%eax
c0104e23:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e29:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104e2c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104e2f:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0104e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p)
c0104e35:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e38:	8b 50 08             	mov    0x8(%eax),%edx
c0104e3b:	89 d0                	mov    %edx,%eax
c0104e3d:	c1 e0 02             	shl    $0x2,%eax
c0104e40:	01 d0                	add    %edx,%eax
c0104e42:	c1 e0 02             	shl    $0x2,%eax
c0104e45:	89 c2                	mov    %eax,%edx
c0104e47:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e4a:	01 d0                	add    %edx,%eax
c0104e4c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104e4f:	75 5a                	jne    c0104eab <default_free_pages+0x1be>
        {
            base->property += p->property;
c0104e51:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e54:	8b 50 08             	mov    0x8(%eax),%edx
c0104e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e5a:	8b 40 08             	mov    0x8(%eax),%eax
c0104e5d:	01 c2                	add    %eax,%edx
c0104e5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e62:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0104e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e68:	83 c0 04             	add    $0x4,%eax
c0104e6b:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0104e72:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104e75:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104e78:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104e7b:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0104e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e81:	83 c0 0c             	add    $0xc,%eax
c0104e84:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104e87:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104e8a:	8b 40 04             	mov    0x4(%eax),%eax
c0104e8d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104e90:	8b 12                	mov    (%edx),%edx
c0104e92:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104e95:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0104e98:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104e9b:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104e9e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104ea1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104ea4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104ea7:	89 10                	mov    %edx,(%eax)
c0104ea9:	eb 7a                	jmp    c0104f25 <default_free_pages+0x238>
        }
        else if (p + p->property == base)
c0104eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eae:	8b 50 08             	mov    0x8(%eax),%edx
c0104eb1:	89 d0                	mov    %edx,%eax
c0104eb3:	c1 e0 02             	shl    $0x2,%eax
c0104eb6:	01 d0                	add    %edx,%eax
c0104eb8:	c1 e0 02             	shl    $0x2,%eax
c0104ebb:	89 c2                	mov    %eax,%edx
c0104ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ec0:	01 d0                	add    %edx,%eax
c0104ec2:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104ec5:	75 5e                	jne    c0104f25 <default_free_pages+0x238>
        {
            p->property += base->property;
c0104ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eca:	8b 50 08             	mov    0x8(%eax),%edx
c0104ecd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ed0:	8b 40 08             	mov    0x8(%eax),%eax
c0104ed3:	01 c2                	add    %eax,%edx
c0104ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ed8:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0104edb:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ede:	83 c0 04             	add    $0x4,%eax
c0104ee1:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0104ee8:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104eeb:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104eee:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104ef1:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0104ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ef7:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0104efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104efd:	83 c0 0c             	add    $0xc,%eax
c0104f00:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104f03:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f06:	8b 40 04             	mov    0x4(%eax),%eax
c0104f09:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104f0c:	8b 12                	mov    (%edx),%edx
c0104f0e:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0104f11:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0104f14:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104f17:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104f1a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104f1d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104f20:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104f23:	89 10                	mov    %edx,(%eax)
    while (le != &free_list)
c0104f25:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0104f2b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104f2e:	0f 85 e9 fe ff ff    	jne    c0104e1d <default_free_pages+0x130>
        }
    }
    nr_free += n;
c0104f34:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0104f3a:	8b 50 08             	mov    0x8(%eax),%edx
c0104f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f40:	01 c2                	add    %eax,%edx
c0104f42:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0104f48:	89 50 08             	mov    %edx,0x8(%eax)
c0104f4b:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0104f51:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
c0104f54:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104f57:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0104f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 将合并好的合适的页块添加回空闲页块链表
    while (le != &free_list)
c0104f5d:	eb 34                	jmp    c0104f93 <default_free_pages+0x2a6>
    {
        p = le2page(le, page_link);
c0104f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f62:	83 e8 0c             	sub    $0xc,%eax
c0104f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p)
c0104f68:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f6b:	8b 50 08             	mov    0x8(%eax),%edx
c0104f6e:	89 d0                	mov    %edx,%eax
c0104f70:	c1 e0 02             	shl    $0x2,%eax
c0104f73:	01 d0                	add    %edx,%eax
c0104f75:	c1 e0 02             	shl    $0x2,%eax
c0104f78:	89 c2                	mov    %eax,%edx
c0104f7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f7d:	01 d0                	add    %edx,%eax
c0104f7f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104f82:	73 1c                	jae    c0104fa0 <default_free_pages+0x2b3>
c0104f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f87:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104f8a:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104f8d:	8b 40 04             	mov    0x4(%eax),%eax
        {
            break;
        }
        le = list_next(le);
c0104f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list)
c0104f93:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0104f99:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104f9c:	75 c1                	jne    c0104f5f <default_free_pages+0x272>
c0104f9e:	eb 01                	jmp    c0104fa1 <default_free_pages+0x2b4>
            break;
c0104fa0:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c0104fa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fa4:	8d 50 0c             	lea    0xc(%eax),%edx
c0104fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104faa:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104fad:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0104fb0:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104fb3:	8b 00                	mov    (%eax),%eax
c0104fb5:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104fb8:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104fbb:	89 45 88             	mov    %eax,-0x78(%ebp)
c0104fbe:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104fc1:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0104fc4:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104fc7:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104fca:	89 10                	mov    %edx,(%eax)
c0104fcc:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104fcf:	8b 10                	mov    (%eax),%edx
c0104fd1:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104fd4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104fd7:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104fda:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104fdd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104fe0:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104fe3:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104fe6:	89 10                	mov    %edx,(%eax)
}
c0104fe8:	90                   	nop
c0104fe9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104fec:	c9                   	leave  
c0104fed:	c3                   	ret    

c0104fee <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
c0104fee:	55                   	push   %ebp
c0104fef:	89 e5                	mov    %esp,%ebp
c0104ff1:	e8 bc b2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0104ff6:	05 5a 39 01 00       	add    $0x1395a,%eax
    return nr_free;
c0104ffb:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0105001:	8b 40 08             	mov    0x8(%eax),%eax
}
c0105004:	5d                   	pop    %ebp
c0105005:	c3                   	ret    

c0105006 <basic_check>:

static void
basic_check(void)
{
c0105006:	55                   	push   %ebp
c0105007:	89 e5                	mov    %esp,%ebp
c0105009:	53                   	push   %ebx
c010500a:	83 ec 34             	sub    $0x34,%esp
c010500d:	e8 a4 b2 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0105012:	81 c3 3e 39 01 00    	add    $0x1393e,%ebx
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0105018:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010501f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105022:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105025:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105028:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010502b:	83 ec 0c             	sub    $0xc,%esp
c010502e:	6a 01                	push   $0x1
c0105030:	e8 55 e2 ff ff       	call   c010328a <alloc_pages>
c0105035:	83 c4 10             	add    $0x10,%esp
c0105038:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010503b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010503f:	75 1f                	jne    c0105060 <basic_check+0x5a>
c0105041:	8d 83 fd ea fe ff    	lea    -0x11503(%ebx),%eax
c0105047:	50                   	push   %eax
c0105048:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c010504e:	50                   	push   %eax
c010504f:	68 dc 00 00 00       	push   $0xdc
c0105054:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c010505a:	50                   	push   %eax
c010505b:	e8 79 b4 ff ff       	call   c01004d9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105060:	83 ec 0c             	sub    $0xc,%esp
c0105063:	6a 01                	push   $0x1
c0105065:	e8 20 e2 ff ff       	call   c010328a <alloc_pages>
c010506a:	83 c4 10             	add    $0x10,%esp
c010506d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105070:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105074:	75 1f                	jne    c0105095 <basic_check+0x8f>
c0105076:	8d 83 19 eb fe ff    	lea    -0x114e7(%ebx),%eax
c010507c:	50                   	push   %eax
c010507d:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105083:	50                   	push   %eax
c0105084:	68 dd 00 00 00       	push   $0xdd
c0105089:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c010508f:	50                   	push   %eax
c0105090:	e8 44 b4 ff ff       	call   c01004d9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0105095:	83 ec 0c             	sub    $0xc,%esp
c0105098:	6a 01                	push   $0x1
c010509a:	e8 eb e1 ff ff       	call   c010328a <alloc_pages>
c010509f:	83 c4 10             	add    $0x10,%esp
c01050a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01050a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01050a9:	75 1f                	jne    c01050ca <basic_check+0xc4>
c01050ab:	8d 83 35 eb fe ff    	lea    -0x114cb(%ebx),%eax
c01050b1:	50                   	push   %eax
c01050b2:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01050b8:	50                   	push   %eax
c01050b9:	68 de 00 00 00       	push   $0xde
c01050be:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c01050c4:	50                   	push   %eax
c01050c5:	e8 0f b4 ff ff       	call   c01004d9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01050ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01050d0:	74 10                	je     c01050e2 <basic_check+0xdc>
c01050d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01050d8:	74 08                	je     c01050e2 <basic_check+0xdc>
c01050da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01050e0:	75 1f                	jne    c0105101 <basic_check+0xfb>
c01050e2:	8d 83 54 eb fe ff    	lea    -0x114ac(%ebx),%eax
c01050e8:	50                   	push   %eax
c01050e9:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01050ef:	50                   	push   %eax
c01050f0:	68 e0 00 00 00       	push   $0xe0
c01050f5:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c01050fb:	50                   	push   %eax
c01050fc:	e8 d8 b3 ff ff       	call   c01004d9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0105101:	83 ec 0c             	sub    $0xc,%esp
c0105104:	ff 75 ec             	pushl  -0x14(%ebp)
c0105107:	e8 7a f8 ff ff       	call   c0104986 <page_ref>
c010510c:	83 c4 10             	add    $0x10,%esp
c010510f:	85 c0                	test   %eax,%eax
c0105111:	75 24                	jne    c0105137 <basic_check+0x131>
c0105113:	83 ec 0c             	sub    $0xc,%esp
c0105116:	ff 75 f0             	pushl  -0x10(%ebp)
c0105119:	e8 68 f8 ff ff       	call   c0104986 <page_ref>
c010511e:	83 c4 10             	add    $0x10,%esp
c0105121:	85 c0                	test   %eax,%eax
c0105123:	75 12                	jne    c0105137 <basic_check+0x131>
c0105125:	83 ec 0c             	sub    $0xc,%esp
c0105128:	ff 75 f4             	pushl  -0xc(%ebp)
c010512b:	e8 56 f8 ff ff       	call   c0104986 <page_ref>
c0105130:	83 c4 10             	add    $0x10,%esp
c0105133:	85 c0                	test   %eax,%eax
c0105135:	74 1f                	je     c0105156 <basic_check+0x150>
c0105137:	8d 83 78 eb fe ff    	lea    -0x11488(%ebx),%eax
c010513d:	50                   	push   %eax
c010513e:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105144:	50                   	push   %eax
c0105145:	68 e1 00 00 00       	push   $0xe1
c010514a:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105150:	50                   	push   %eax
c0105151:	e8 83 b3 ff ff       	call   c01004d9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0105156:	83 ec 0c             	sub    $0xc,%esp
c0105159:	ff 75 ec             	pushl  -0x14(%ebp)
c010515c:	e8 08 f8 ff ff       	call   c0104969 <page2pa>
c0105161:	83 c4 10             	add    $0x10,%esp
c0105164:	89 c2                	mov    %eax,%edx
c0105166:	c7 c0 80 be 11 c0    	mov    $0xc011be80,%eax
c010516c:	8b 00                	mov    (%eax),%eax
c010516e:	c1 e0 0c             	shl    $0xc,%eax
c0105171:	39 c2                	cmp    %eax,%edx
c0105173:	72 1f                	jb     c0105194 <basic_check+0x18e>
c0105175:	8d 83 b4 eb fe ff    	lea    -0x1144c(%ebx),%eax
c010517b:	50                   	push   %eax
c010517c:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105182:	50                   	push   %eax
c0105183:	68 e3 00 00 00       	push   $0xe3
c0105188:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c010518e:	50                   	push   %eax
c010518f:	e8 45 b3 ff ff       	call   c01004d9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0105194:	83 ec 0c             	sub    $0xc,%esp
c0105197:	ff 75 f0             	pushl  -0x10(%ebp)
c010519a:	e8 ca f7 ff ff       	call   c0104969 <page2pa>
c010519f:	83 c4 10             	add    $0x10,%esp
c01051a2:	89 c2                	mov    %eax,%edx
c01051a4:	c7 c0 80 be 11 c0    	mov    $0xc011be80,%eax
c01051aa:	8b 00                	mov    (%eax),%eax
c01051ac:	c1 e0 0c             	shl    $0xc,%eax
c01051af:	39 c2                	cmp    %eax,%edx
c01051b1:	72 1f                	jb     c01051d2 <basic_check+0x1cc>
c01051b3:	8d 83 d1 eb fe ff    	lea    -0x1142f(%ebx),%eax
c01051b9:	50                   	push   %eax
c01051ba:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01051c0:	50                   	push   %eax
c01051c1:	68 e4 00 00 00       	push   $0xe4
c01051c6:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c01051cc:	50                   	push   %eax
c01051cd:	e8 07 b3 ff ff       	call   c01004d9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01051d2:	83 ec 0c             	sub    $0xc,%esp
c01051d5:	ff 75 f4             	pushl  -0xc(%ebp)
c01051d8:	e8 8c f7 ff ff       	call   c0104969 <page2pa>
c01051dd:	83 c4 10             	add    $0x10,%esp
c01051e0:	89 c2                	mov    %eax,%edx
c01051e2:	c7 c0 80 be 11 c0    	mov    $0xc011be80,%eax
c01051e8:	8b 00                	mov    (%eax),%eax
c01051ea:	c1 e0 0c             	shl    $0xc,%eax
c01051ed:	39 c2                	cmp    %eax,%edx
c01051ef:	72 1f                	jb     c0105210 <basic_check+0x20a>
c01051f1:	8d 83 ee eb fe ff    	lea    -0x11412(%ebx),%eax
c01051f7:	50                   	push   %eax
c01051f8:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01051fe:	50                   	push   %eax
c01051ff:	68 e5 00 00 00       	push   $0xe5
c0105204:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c010520a:	50                   	push   %eax
c010520b:	e8 c9 b2 ff ff       	call   c01004d9 <__panic>

    list_entry_t free_list_store = free_list;
c0105210:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0105216:	8b 50 04             	mov    0x4(%eax),%edx
c0105219:	8b 00                	mov    (%eax),%eax
c010521b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010521e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105221:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0105227:	89 45 dc             	mov    %eax,-0x24(%ebp)
    elm->prev = elm->next = elm;
c010522a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010522d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105230:	89 50 04             	mov    %edx,0x4(%eax)
c0105233:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105236:	8b 50 04             	mov    0x4(%eax),%edx
c0105239:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010523c:	89 10                	mov    %edx,(%eax)
c010523e:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0105244:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return list->next == list;
c0105247:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010524a:	8b 40 04             	mov    0x4(%eax),%eax
c010524d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0105250:	0f 94 c0             	sete   %al
c0105253:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0105256:	85 c0                	test   %eax,%eax
c0105258:	75 1f                	jne    c0105279 <basic_check+0x273>
c010525a:	8d 83 0b ec fe ff    	lea    -0x113f5(%ebx),%eax
c0105260:	50                   	push   %eax
c0105261:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105267:	50                   	push   %eax
c0105268:	68 e9 00 00 00       	push   $0xe9
c010526d:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105273:	50                   	push   %eax
c0105274:	e8 60 b2 ff ff       	call   c01004d9 <__panic>

    unsigned int nr_free_store = nr_free;
c0105279:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c010527f:	8b 40 08             	mov    0x8(%eax),%eax
c0105282:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0105285:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c010528b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

    assert(alloc_page() == NULL);
c0105292:	83 ec 0c             	sub    $0xc,%esp
c0105295:	6a 01                	push   $0x1
c0105297:	e8 ee df ff ff       	call   c010328a <alloc_pages>
c010529c:	83 c4 10             	add    $0x10,%esp
c010529f:	85 c0                	test   %eax,%eax
c01052a1:	74 1f                	je     c01052c2 <basic_check+0x2bc>
c01052a3:	8d 83 22 ec fe ff    	lea    -0x113de(%ebx),%eax
c01052a9:	50                   	push   %eax
c01052aa:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01052b0:	50                   	push   %eax
c01052b1:	68 ee 00 00 00       	push   $0xee
c01052b6:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c01052bc:	50                   	push   %eax
c01052bd:	e8 17 b2 ff ff       	call   c01004d9 <__panic>

    free_page(p0);
c01052c2:	83 ec 08             	sub    $0x8,%esp
c01052c5:	6a 01                	push   $0x1
c01052c7:	ff 75 ec             	pushl  -0x14(%ebp)
c01052ca:	e8 0b e0 ff ff       	call   c01032da <free_pages>
c01052cf:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c01052d2:	83 ec 08             	sub    $0x8,%esp
c01052d5:	6a 01                	push   $0x1
c01052d7:	ff 75 f0             	pushl  -0x10(%ebp)
c01052da:	e8 fb df ff ff       	call   c01032da <free_pages>
c01052df:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c01052e2:	83 ec 08             	sub    $0x8,%esp
c01052e5:	6a 01                	push   $0x1
c01052e7:	ff 75 f4             	pushl  -0xc(%ebp)
c01052ea:	e8 eb df ff ff       	call   c01032da <free_pages>
c01052ef:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c01052f2:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c01052f8:	8b 40 08             	mov    0x8(%eax),%eax
c01052fb:	83 f8 03             	cmp    $0x3,%eax
c01052fe:	74 1f                	je     c010531f <basic_check+0x319>
c0105300:	8d 83 37 ec fe ff    	lea    -0x113c9(%ebx),%eax
c0105306:	50                   	push   %eax
c0105307:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c010530d:	50                   	push   %eax
c010530e:	68 f3 00 00 00       	push   $0xf3
c0105313:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105319:	50                   	push   %eax
c010531a:	e8 ba b1 ff ff       	call   c01004d9 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010531f:	83 ec 0c             	sub    $0xc,%esp
c0105322:	6a 01                	push   $0x1
c0105324:	e8 61 df ff ff       	call   c010328a <alloc_pages>
c0105329:	83 c4 10             	add    $0x10,%esp
c010532c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010532f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105333:	75 1f                	jne    c0105354 <basic_check+0x34e>
c0105335:	8d 83 fd ea fe ff    	lea    -0x11503(%ebx),%eax
c010533b:	50                   	push   %eax
c010533c:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105342:	50                   	push   %eax
c0105343:	68 f5 00 00 00       	push   $0xf5
c0105348:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c010534e:	50                   	push   %eax
c010534f:	e8 85 b1 ff ff       	call   c01004d9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105354:	83 ec 0c             	sub    $0xc,%esp
c0105357:	6a 01                	push   $0x1
c0105359:	e8 2c df ff ff       	call   c010328a <alloc_pages>
c010535e:	83 c4 10             	add    $0x10,%esp
c0105361:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105364:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105368:	75 1f                	jne    c0105389 <basic_check+0x383>
c010536a:	8d 83 19 eb fe ff    	lea    -0x114e7(%ebx),%eax
c0105370:	50                   	push   %eax
c0105371:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105377:	50                   	push   %eax
c0105378:	68 f6 00 00 00       	push   $0xf6
c010537d:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105383:	50                   	push   %eax
c0105384:	e8 50 b1 ff ff       	call   c01004d9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0105389:	83 ec 0c             	sub    $0xc,%esp
c010538c:	6a 01                	push   $0x1
c010538e:	e8 f7 de ff ff       	call   c010328a <alloc_pages>
c0105393:	83 c4 10             	add    $0x10,%esp
c0105396:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010539d:	75 1f                	jne    c01053be <basic_check+0x3b8>
c010539f:	8d 83 35 eb fe ff    	lea    -0x114cb(%ebx),%eax
c01053a5:	50                   	push   %eax
c01053a6:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01053ac:	50                   	push   %eax
c01053ad:	68 f7 00 00 00       	push   $0xf7
c01053b2:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c01053b8:	50                   	push   %eax
c01053b9:	e8 1b b1 ff ff       	call   c01004d9 <__panic>

    assert(alloc_page() == NULL);
c01053be:	83 ec 0c             	sub    $0xc,%esp
c01053c1:	6a 01                	push   $0x1
c01053c3:	e8 c2 de ff ff       	call   c010328a <alloc_pages>
c01053c8:	83 c4 10             	add    $0x10,%esp
c01053cb:	85 c0                	test   %eax,%eax
c01053cd:	74 1f                	je     c01053ee <basic_check+0x3e8>
c01053cf:	8d 83 22 ec fe ff    	lea    -0x113de(%ebx),%eax
c01053d5:	50                   	push   %eax
c01053d6:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01053dc:	50                   	push   %eax
c01053dd:	68 f9 00 00 00       	push   $0xf9
c01053e2:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c01053e8:	50                   	push   %eax
c01053e9:	e8 eb b0 ff ff       	call   c01004d9 <__panic>

    free_page(p0);
c01053ee:	83 ec 08             	sub    $0x8,%esp
c01053f1:	6a 01                	push   $0x1
c01053f3:	ff 75 ec             	pushl  -0x14(%ebp)
c01053f6:	e8 df de ff ff       	call   c01032da <free_pages>
c01053fb:	83 c4 10             	add    $0x10,%esp
c01053fe:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0105404:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0105407:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010540a:	8b 40 04             	mov    0x4(%eax),%eax
c010540d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0105410:	0f 94 c0             	sete   %al
c0105413:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0105416:	85 c0                	test   %eax,%eax
c0105418:	74 1f                	je     c0105439 <basic_check+0x433>
c010541a:	8d 83 44 ec fe ff    	lea    -0x113bc(%ebx),%eax
c0105420:	50                   	push   %eax
c0105421:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105427:	50                   	push   %eax
c0105428:	68 fc 00 00 00       	push   $0xfc
c010542d:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105433:	50                   	push   %eax
c0105434:	e8 a0 b0 ff ff       	call   c01004d9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0105439:	83 ec 0c             	sub    $0xc,%esp
c010543c:	6a 01                	push   $0x1
c010543e:	e8 47 de ff ff       	call   c010328a <alloc_pages>
c0105443:	83 c4 10             	add    $0x10,%esp
c0105446:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010544c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010544f:	74 1f                	je     c0105470 <basic_check+0x46a>
c0105451:	8d 83 5c ec fe ff    	lea    -0x113a4(%ebx),%eax
c0105457:	50                   	push   %eax
c0105458:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c010545e:	50                   	push   %eax
c010545f:	68 ff 00 00 00       	push   $0xff
c0105464:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c010546a:	50                   	push   %eax
c010546b:	e8 69 b0 ff ff       	call   c01004d9 <__panic>
    assert(alloc_page() == NULL);
c0105470:	83 ec 0c             	sub    $0xc,%esp
c0105473:	6a 01                	push   $0x1
c0105475:	e8 10 de ff ff       	call   c010328a <alloc_pages>
c010547a:	83 c4 10             	add    $0x10,%esp
c010547d:	85 c0                	test   %eax,%eax
c010547f:	74 1f                	je     c01054a0 <basic_check+0x49a>
c0105481:	8d 83 22 ec fe ff    	lea    -0x113de(%ebx),%eax
c0105487:	50                   	push   %eax
c0105488:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c010548e:	50                   	push   %eax
c010548f:	68 00 01 00 00       	push   $0x100
c0105494:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c010549a:	50                   	push   %eax
c010549b:	e8 39 b0 ff ff       	call   c01004d9 <__panic>

    assert(nr_free == 0);
c01054a0:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c01054a6:	8b 40 08             	mov    0x8(%eax),%eax
c01054a9:	85 c0                	test   %eax,%eax
c01054ab:	74 1f                	je     c01054cc <basic_check+0x4c6>
c01054ad:	8d 83 75 ec fe ff    	lea    -0x1138b(%ebx),%eax
c01054b3:	50                   	push   %eax
c01054b4:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01054ba:	50                   	push   %eax
c01054bb:	68 02 01 00 00       	push   $0x102
c01054c0:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c01054c6:	50                   	push   %eax
c01054c7:	e8 0d b0 ff ff       	call   c01004d9 <__panic>
    free_list = free_list_store;
c01054cc:	c7 c1 7c bf 11 c0    	mov    $0xc011bf7c,%ecx
c01054d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054d8:	89 01                	mov    %eax,(%ecx)
c01054da:	89 51 04             	mov    %edx,0x4(%ecx)
    nr_free = nr_free_store;
c01054dd:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c01054e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01054e6:	89 50 08             	mov    %edx,0x8(%eax)

    free_page(p);
c01054e9:	83 ec 08             	sub    $0x8,%esp
c01054ec:	6a 01                	push   $0x1
c01054ee:	ff 75 e4             	pushl  -0x1c(%ebp)
c01054f1:	e8 e4 dd ff ff       	call   c01032da <free_pages>
c01054f6:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c01054f9:	83 ec 08             	sub    $0x8,%esp
c01054fc:	6a 01                	push   $0x1
c01054fe:	ff 75 f0             	pushl  -0x10(%ebp)
c0105501:	e8 d4 dd ff ff       	call   c01032da <free_pages>
c0105506:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0105509:	83 ec 08             	sub    $0x8,%esp
c010550c:	6a 01                	push   $0x1
c010550e:	ff 75 f4             	pushl  -0xc(%ebp)
c0105511:	e8 c4 dd ff ff       	call   c01032da <free_pages>
c0105516:	83 c4 10             	add    $0x10,%esp
}
c0105519:	90                   	nop
c010551a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010551d:	c9                   	leave  
c010551e:	c3                   	ret    

c010551f <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
c010551f:	55                   	push   %ebp
c0105520:	89 e5                	mov    %esp,%ebp
c0105522:	53                   	push   %ebx
c0105523:	81 ec 84 00 00 00    	sub    $0x84,%esp
c0105529:	e8 88 ad ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c010552e:	81 c3 22 34 01 00    	add    $0x13422,%ebx
    int count = 0, total = 0;
c0105534:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010553b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0105542:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0105548:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c010554b:	eb 66                	jmp    c01055b3 <default_check+0x94>
    {
        struct Page *p = le2page(le, page_link);
c010554d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105550:	83 e8 0c             	sub    $0xc,%eax
c0105553:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0105556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105559:	83 c0 04             	add    $0x4,%eax
c010555c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105563:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105566:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105569:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010556c:	0f a3 10             	bt     %edx,(%eax)
c010556f:	19 c0                	sbb    %eax,%eax
c0105571:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0105574:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0105578:	0f 95 c0             	setne  %al
c010557b:	0f b6 c0             	movzbl %al,%eax
c010557e:	85 c0                	test   %eax,%eax
c0105580:	75 1f                	jne    c01055a1 <default_check+0x82>
c0105582:	8d 83 82 ec fe ff    	lea    -0x1137e(%ebx),%eax
c0105588:	50                   	push   %eax
c0105589:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c010558f:	50                   	push   %eax
c0105590:	68 15 01 00 00       	push   $0x115
c0105595:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c010559b:	50                   	push   %eax
c010559c:	e8 38 af ff ff       	call   c01004d9 <__panic>
        count++, total += p->property;
c01055a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01055a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01055a8:	8b 50 08             	mov    0x8(%eax),%edx
c01055ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055ae:	01 d0                	add    %edx,%eax
c01055b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01055b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c01055b9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01055bc:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c01055bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01055c2:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c01055c8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01055cb:	75 80                	jne    c010554d <default_check+0x2e>
    }
    assert(total == nr_free_pages());
c01055cd:	e8 4f dd ff ff       	call   c0103321 <nr_free_pages>
c01055d2:	89 c2                	mov    %eax,%edx
c01055d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055d7:	39 c2                	cmp    %eax,%edx
c01055d9:	74 1f                	je     c01055fa <default_check+0xdb>
c01055db:	8d 83 92 ec fe ff    	lea    -0x1136e(%ebx),%eax
c01055e1:	50                   	push   %eax
c01055e2:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01055e8:	50                   	push   %eax
c01055e9:	68 18 01 00 00       	push   $0x118
c01055ee:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c01055f4:	50                   	push   %eax
c01055f5:	e8 df ae ff ff       	call   c01004d9 <__panic>

    basic_check();
c01055fa:	e8 07 fa ff ff       	call   c0105006 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01055ff:	83 ec 0c             	sub    $0xc,%esp
c0105602:	6a 05                	push   $0x5
c0105604:	e8 81 dc ff ff       	call   c010328a <alloc_pages>
c0105609:	83 c4 10             	add    $0x10,%esp
c010560c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c010560f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105613:	75 1f                	jne    c0105634 <default_check+0x115>
c0105615:	8d 83 ab ec fe ff    	lea    -0x11355(%ebx),%eax
c010561b:	50                   	push   %eax
c010561c:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105622:	50                   	push   %eax
c0105623:	68 1d 01 00 00       	push   $0x11d
c0105628:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c010562e:	50                   	push   %eax
c010562f:	e8 a5 ae ff ff       	call   c01004d9 <__panic>
    assert(!PageProperty(p0));
c0105634:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105637:	83 c0 04             	add    $0x4,%eax
c010563a:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0105641:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105644:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105647:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010564a:	0f a3 10             	bt     %edx,(%eax)
c010564d:	19 c0                	sbb    %eax,%eax
c010564f:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0105652:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0105656:	0f 95 c0             	setne  %al
c0105659:	0f b6 c0             	movzbl %al,%eax
c010565c:	85 c0                	test   %eax,%eax
c010565e:	74 1f                	je     c010567f <default_check+0x160>
c0105660:	8d 83 b6 ec fe ff    	lea    -0x1134a(%ebx),%eax
c0105666:	50                   	push   %eax
c0105667:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c010566d:	50                   	push   %eax
c010566e:	68 1e 01 00 00       	push   $0x11e
c0105673:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105679:	50                   	push   %eax
c010567a:	e8 5a ae ff ff       	call   c01004d9 <__panic>

    list_entry_t free_list_store = free_list;
c010567f:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0105685:	8b 50 04             	mov    0x4(%eax),%edx
c0105688:	8b 00                	mov    (%eax),%eax
c010568a:	89 45 80             	mov    %eax,-0x80(%ebp)
c010568d:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0105690:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0105696:	89 45 b0             	mov    %eax,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0105699:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010569c:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010569f:	89 50 04             	mov    %edx,0x4(%eax)
c01056a2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01056a5:	8b 50 04             	mov    0x4(%eax),%edx
c01056a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01056ab:	89 10                	mov    %edx,(%eax)
c01056ad:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c01056b3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return list->next == list;
c01056b6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01056b9:	8b 40 04             	mov    0x4(%eax),%eax
c01056bc:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c01056bf:	0f 94 c0             	sete   %al
c01056c2:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01056c5:	85 c0                	test   %eax,%eax
c01056c7:	75 1f                	jne    c01056e8 <default_check+0x1c9>
c01056c9:	8d 83 0b ec fe ff    	lea    -0x113f5(%ebx),%eax
c01056cf:	50                   	push   %eax
c01056d0:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01056d6:	50                   	push   %eax
c01056d7:	68 22 01 00 00       	push   $0x122
c01056dc:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c01056e2:	50                   	push   %eax
c01056e3:	e8 f1 ad ff ff       	call   c01004d9 <__panic>
    assert(alloc_page() == NULL);
c01056e8:	83 ec 0c             	sub    $0xc,%esp
c01056eb:	6a 01                	push   $0x1
c01056ed:	e8 98 db ff ff       	call   c010328a <alloc_pages>
c01056f2:	83 c4 10             	add    $0x10,%esp
c01056f5:	85 c0                	test   %eax,%eax
c01056f7:	74 1f                	je     c0105718 <default_check+0x1f9>
c01056f9:	8d 83 22 ec fe ff    	lea    -0x113de(%ebx),%eax
c01056ff:	50                   	push   %eax
c0105700:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105706:	50                   	push   %eax
c0105707:	68 23 01 00 00       	push   $0x123
c010570c:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105712:	50                   	push   %eax
c0105713:	e8 c1 ad ff ff       	call   c01004d9 <__panic>

    unsigned int nr_free_store = nr_free;
c0105718:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c010571e:	8b 40 08             	mov    0x8(%eax),%eax
c0105721:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0105724:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c010572a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

    free_pages(p0 + 2, 3);
c0105731:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105734:	83 c0 28             	add    $0x28,%eax
c0105737:	83 ec 08             	sub    $0x8,%esp
c010573a:	6a 03                	push   $0x3
c010573c:	50                   	push   %eax
c010573d:	e8 98 db ff ff       	call   c01032da <free_pages>
c0105742:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0105745:	83 ec 0c             	sub    $0xc,%esp
c0105748:	6a 04                	push   $0x4
c010574a:	e8 3b db ff ff       	call   c010328a <alloc_pages>
c010574f:	83 c4 10             	add    $0x10,%esp
c0105752:	85 c0                	test   %eax,%eax
c0105754:	74 1f                	je     c0105775 <default_check+0x256>
c0105756:	8d 83 c8 ec fe ff    	lea    -0x11338(%ebx),%eax
c010575c:	50                   	push   %eax
c010575d:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105763:	50                   	push   %eax
c0105764:	68 29 01 00 00       	push   $0x129
c0105769:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c010576f:	50                   	push   %eax
c0105770:	e8 64 ad ff ff       	call   c01004d9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0105775:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105778:	83 c0 28             	add    $0x28,%eax
c010577b:	83 c0 04             	add    $0x4,%eax
c010577e:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0105785:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105788:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010578b:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010578e:	0f a3 10             	bt     %edx,(%eax)
c0105791:	19 c0                	sbb    %eax,%eax
c0105793:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0105796:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010579a:	0f 95 c0             	setne  %al
c010579d:	0f b6 c0             	movzbl %al,%eax
c01057a0:	85 c0                	test   %eax,%eax
c01057a2:	74 0e                	je     c01057b2 <default_check+0x293>
c01057a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057a7:	83 c0 28             	add    $0x28,%eax
c01057aa:	8b 40 08             	mov    0x8(%eax),%eax
c01057ad:	83 f8 03             	cmp    $0x3,%eax
c01057b0:	74 1f                	je     c01057d1 <default_check+0x2b2>
c01057b2:	8d 83 e0 ec fe ff    	lea    -0x11320(%ebx),%eax
c01057b8:	50                   	push   %eax
c01057b9:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01057bf:	50                   	push   %eax
c01057c0:	68 2a 01 00 00       	push   $0x12a
c01057c5:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c01057cb:	50                   	push   %eax
c01057cc:	e8 08 ad ff ff       	call   c01004d9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01057d1:	83 ec 0c             	sub    $0xc,%esp
c01057d4:	6a 03                	push   $0x3
c01057d6:	e8 af da ff ff       	call   c010328a <alloc_pages>
c01057db:	83 c4 10             	add    $0x10,%esp
c01057de:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01057e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01057e5:	75 1f                	jne    c0105806 <default_check+0x2e7>
c01057e7:	8d 83 0c ed fe ff    	lea    -0x112f4(%ebx),%eax
c01057ed:	50                   	push   %eax
c01057ee:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01057f4:	50                   	push   %eax
c01057f5:	68 2b 01 00 00       	push   $0x12b
c01057fa:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105800:	50                   	push   %eax
c0105801:	e8 d3 ac ff ff       	call   c01004d9 <__panic>
    assert(alloc_page() == NULL);
c0105806:	83 ec 0c             	sub    $0xc,%esp
c0105809:	6a 01                	push   $0x1
c010580b:	e8 7a da ff ff       	call   c010328a <alloc_pages>
c0105810:	83 c4 10             	add    $0x10,%esp
c0105813:	85 c0                	test   %eax,%eax
c0105815:	74 1f                	je     c0105836 <default_check+0x317>
c0105817:	8d 83 22 ec fe ff    	lea    -0x113de(%ebx),%eax
c010581d:	50                   	push   %eax
c010581e:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105824:	50                   	push   %eax
c0105825:	68 2c 01 00 00       	push   $0x12c
c010582a:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105830:	50                   	push   %eax
c0105831:	e8 a3 ac ff ff       	call   c01004d9 <__panic>
    assert(p0 + 2 == p1);
c0105836:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105839:	83 c0 28             	add    $0x28,%eax
c010583c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010583f:	74 1f                	je     c0105860 <default_check+0x341>
c0105841:	8d 83 2a ed fe ff    	lea    -0x112d6(%ebx),%eax
c0105847:	50                   	push   %eax
c0105848:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c010584e:	50                   	push   %eax
c010584f:	68 2d 01 00 00       	push   $0x12d
c0105854:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c010585a:	50                   	push   %eax
c010585b:	e8 79 ac ff ff       	call   c01004d9 <__panic>

    p2 = p0 + 1;
c0105860:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105863:	83 c0 14             	add    $0x14,%eax
c0105866:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c0105869:	83 ec 08             	sub    $0x8,%esp
c010586c:	6a 01                	push   $0x1
c010586e:	ff 75 e8             	pushl  -0x18(%ebp)
c0105871:	e8 64 da ff ff       	call   c01032da <free_pages>
c0105876:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0105879:	83 ec 08             	sub    $0x8,%esp
c010587c:	6a 03                	push   $0x3
c010587e:	ff 75 e0             	pushl  -0x20(%ebp)
c0105881:	e8 54 da ff ff       	call   c01032da <free_pages>
c0105886:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0105889:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010588c:	83 c0 04             	add    $0x4,%eax
c010588f:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0105896:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105899:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010589c:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010589f:	0f a3 10             	bt     %edx,(%eax)
c01058a2:	19 c0                	sbb    %eax,%eax
c01058a4:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01058a7:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01058ab:	0f 95 c0             	setne  %al
c01058ae:	0f b6 c0             	movzbl %al,%eax
c01058b1:	85 c0                	test   %eax,%eax
c01058b3:	74 0b                	je     c01058c0 <default_check+0x3a1>
c01058b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058b8:	8b 40 08             	mov    0x8(%eax),%eax
c01058bb:	83 f8 01             	cmp    $0x1,%eax
c01058be:	74 1f                	je     c01058df <default_check+0x3c0>
c01058c0:	8d 83 38 ed fe ff    	lea    -0x112c8(%ebx),%eax
c01058c6:	50                   	push   %eax
c01058c7:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01058cd:	50                   	push   %eax
c01058ce:	68 32 01 00 00       	push   $0x132
c01058d3:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c01058d9:	50                   	push   %eax
c01058da:	e8 fa ab ff ff       	call   c01004d9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01058df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058e2:	83 c0 04             	add    $0x4,%eax
c01058e5:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01058ec:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01058ef:	8b 45 90             	mov    -0x70(%ebp),%eax
c01058f2:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01058f5:	0f a3 10             	bt     %edx,(%eax)
c01058f8:	19 c0                	sbb    %eax,%eax
c01058fa:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01058fd:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0105901:	0f 95 c0             	setne  %al
c0105904:	0f b6 c0             	movzbl %al,%eax
c0105907:	85 c0                	test   %eax,%eax
c0105909:	74 0b                	je     c0105916 <default_check+0x3f7>
c010590b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010590e:	8b 40 08             	mov    0x8(%eax),%eax
c0105911:	83 f8 03             	cmp    $0x3,%eax
c0105914:	74 1f                	je     c0105935 <default_check+0x416>
c0105916:	8d 83 60 ed fe ff    	lea    -0x112a0(%ebx),%eax
c010591c:	50                   	push   %eax
c010591d:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105923:	50                   	push   %eax
c0105924:	68 33 01 00 00       	push   $0x133
c0105929:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c010592f:	50                   	push   %eax
c0105930:	e8 a4 ab ff ff       	call   c01004d9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0105935:	83 ec 0c             	sub    $0xc,%esp
c0105938:	6a 01                	push   $0x1
c010593a:	e8 4b d9 ff ff       	call   c010328a <alloc_pages>
c010593f:	83 c4 10             	add    $0x10,%esp
c0105942:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105945:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105948:	83 e8 14             	sub    $0x14,%eax
c010594b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010594e:	74 1f                	je     c010596f <default_check+0x450>
c0105950:	8d 83 86 ed fe ff    	lea    -0x1127a(%ebx),%eax
c0105956:	50                   	push   %eax
c0105957:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c010595d:	50                   	push   %eax
c010595e:	68 35 01 00 00       	push   $0x135
c0105963:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105969:	50                   	push   %eax
c010596a:	e8 6a ab ff ff       	call   c01004d9 <__panic>
    free_page(p0);
c010596f:	83 ec 08             	sub    $0x8,%esp
c0105972:	6a 01                	push   $0x1
c0105974:	ff 75 e8             	pushl  -0x18(%ebp)
c0105977:	e8 5e d9 ff ff       	call   c01032da <free_pages>
c010597c:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010597f:	83 ec 0c             	sub    $0xc,%esp
c0105982:	6a 02                	push   $0x2
c0105984:	e8 01 d9 ff ff       	call   c010328a <alloc_pages>
c0105989:	83 c4 10             	add    $0x10,%esp
c010598c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010598f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105992:	83 c0 14             	add    $0x14,%eax
c0105995:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105998:	74 1f                	je     c01059b9 <default_check+0x49a>
c010599a:	8d 83 a4 ed fe ff    	lea    -0x1125c(%ebx),%eax
c01059a0:	50                   	push   %eax
c01059a1:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01059a7:	50                   	push   %eax
c01059a8:	68 37 01 00 00       	push   $0x137
c01059ad:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c01059b3:	50                   	push   %eax
c01059b4:	e8 20 ab ff ff       	call   c01004d9 <__panic>

    free_pages(p0, 2);
c01059b9:	83 ec 08             	sub    $0x8,%esp
c01059bc:	6a 02                	push   $0x2
c01059be:	ff 75 e8             	pushl  -0x18(%ebp)
c01059c1:	e8 14 d9 ff ff       	call   c01032da <free_pages>
c01059c6:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c01059c9:	83 ec 08             	sub    $0x8,%esp
c01059cc:	6a 01                	push   $0x1
c01059ce:	ff 75 dc             	pushl  -0x24(%ebp)
c01059d1:	e8 04 d9 ff ff       	call   c01032da <free_pages>
c01059d6:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c01059d9:	83 ec 0c             	sub    $0xc,%esp
c01059dc:	6a 05                	push   $0x5
c01059de:	e8 a7 d8 ff ff       	call   c010328a <alloc_pages>
c01059e3:	83 c4 10             	add    $0x10,%esp
c01059e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01059e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059ed:	75 1f                	jne    c0105a0e <default_check+0x4ef>
c01059ef:	8d 83 c4 ed fe ff    	lea    -0x1123c(%ebx),%eax
c01059f5:	50                   	push   %eax
c01059f6:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c01059fc:	50                   	push   %eax
c01059fd:	68 3c 01 00 00       	push   $0x13c
c0105a02:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105a08:	50                   	push   %eax
c0105a09:	e8 cb aa ff ff       	call   c01004d9 <__panic>
    assert(alloc_page() == NULL);
c0105a0e:	83 ec 0c             	sub    $0xc,%esp
c0105a11:	6a 01                	push   $0x1
c0105a13:	e8 72 d8 ff ff       	call   c010328a <alloc_pages>
c0105a18:	83 c4 10             	add    $0x10,%esp
c0105a1b:	85 c0                	test   %eax,%eax
c0105a1d:	74 1f                	je     c0105a3e <default_check+0x51f>
c0105a1f:	8d 83 22 ec fe ff    	lea    -0x113de(%ebx),%eax
c0105a25:	50                   	push   %eax
c0105a26:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105a2c:	50                   	push   %eax
c0105a2d:	68 3d 01 00 00       	push   $0x13d
c0105a32:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105a38:	50                   	push   %eax
c0105a39:	e8 9b aa ff ff       	call   c01004d9 <__panic>

    assert(nr_free == 0);
c0105a3e:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0105a44:	8b 40 08             	mov    0x8(%eax),%eax
c0105a47:	85 c0                	test   %eax,%eax
c0105a49:	74 1f                	je     c0105a6a <default_check+0x54b>
c0105a4b:	8d 83 75 ec fe ff    	lea    -0x1138b(%ebx),%eax
c0105a51:	50                   	push   %eax
c0105a52:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105a58:	50                   	push   %eax
c0105a59:	68 3f 01 00 00       	push   $0x13f
c0105a5e:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105a64:	50                   	push   %eax
c0105a65:	e8 6f aa ff ff       	call   c01004d9 <__panic>
    nr_free = nr_free_store;
c0105a6a:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0105a70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105a73:	89 50 08             	mov    %edx,0x8(%eax)

    free_list = free_list_store;
c0105a76:	c7 c1 7c bf 11 c0    	mov    $0xc011bf7c,%ecx
c0105a7c:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105a7f:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105a82:	89 01                	mov    %eax,(%ecx)
c0105a84:	89 51 04             	mov    %edx,0x4(%ecx)
    free_pages(p0, 5);
c0105a87:	83 ec 08             	sub    $0x8,%esp
c0105a8a:	6a 05                	push   $0x5
c0105a8c:	ff 75 e8             	pushl  -0x18(%ebp)
c0105a8f:	e8 46 d8 ff ff       	call   c01032da <free_pages>
c0105a94:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0105a97:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0105a9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c0105aa0:	eb 1d                	jmp    c0105abf <default_check+0x5a0>
    {
        struct Page *p = le2page(le, page_link);
c0105aa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105aa5:	83 e8 0c             	sub    $0xc,%eax
c0105aa8:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
c0105aab:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0105aaf:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105ab2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105ab5:	8b 40 08             	mov    0x8(%eax),%eax
c0105ab8:	29 c2                	sub    %eax,%edx
c0105aba:	89 d0                	mov    %edx,%eax
c0105abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ac2:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0105ac5:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105ac8:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0105acb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ace:	c7 c0 7c bf 11 c0    	mov    $0xc011bf7c,%eax
c0105ad4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105ad7:	75 c9                	jne    c0105aa2 <default_check+0x583>
    }
    assert(count == 0);
c0105ad9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105add:	74 1f                	je     c0105afe <default_check+0x5df>
c0105adf:	8d 83 e2 ed fe ff    	lea    -0x1121e(%ebx),%eax
c0105ae5:	50                   	push   %eax
c0105ae6:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105aec:	50                   	push   %eax
c0105aed:	68 4b 01 00 00       	push   $0x14b
c0105af2:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105af8:	50                   	push   %eax
c0105af9:	e8 db a9 ff ff       	call   c01004d9 <__panic>
    assert(total == 0);
c0105afe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105b02:	74 1f                	je     c0105b23 <default_check+0x604>
c0105b04:	8d 83 ed ed fe ff    	lea    -0x11213(%ebx),%eax
c0105b0a:	50                   	push   %eax
c0105b0b:	8d 83 9a ea fe ff    	lea    -0x11566(%ebx),%eax
c0105b11:	50                   	push   %eax
c0105b12:	68 4c 01 00 00       	push   $0x14c
c0105b17:	8d 83 af ea fe ff    	lea    -0x11551(%ebx),%eax
c0105b1d:	50                   	push   %eax
c0105b1e:	e8 b6 a9 ff ff       	call   c01004d9 <__panic>
}
c0105b23:	90                   	nop
c0105b24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0105b27:	c9                   	leave  
c0105b28:	c3                   	ret    

c0105b29 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105b29:	55                   	push   %ebp
c0105b2a:	89 e5                	mov    %esp,%ebp
c0105b2c:	83 ec 10             	sub    $0x10,%esp
c0105b2f:	e8 7e a7 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105b34:	05 1c 2e 01 00       	add    $0x12e1c,%eax
    size_t cnt = 0;
c0105b39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105b40:	eb 04                	jmp    c0105b46 <strlen+0x1d>
        cnt ++;
c0105b42:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105b46:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b49:	8d 50 01             	lea    0x1(%eax),%edx
c0105b4c:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b4f:	0f b6 00             	movzbl (%eax),%eax
c0105b52:	84 c0                	test   %al,%al
c0105b54:	75 ec                	jne    c0105b42 <strlen+0x19>
    }
    return cnt;
c0105b56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b59:	c9                   	leave  
c0105b5a:	c3                   	ret    

c0105b5b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105b5b:	55                   	push   %ebp
c0105b5c:	89 e5                	mov    %esp,%ebp
c0105b5e:	83 ec 10             	sub    $0x10,%esp
c0105b61:	e8 4c a7 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105b66:	05 ea 2d 01 00       	add    $0x12dea,%eax
    size_t cnt = 0;
c0105b6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b72:	eb 04                	jmp    c0105b78 <strnlen+0x1d>
        cnt ++;
c0105b74:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b78:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b7b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105b7e:	73 10                	jae    c0105b90 <strnlen+0x35>
c0105b80:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b83:	8d 50 01             	lea    0x1(%eax),%edx
c0105b86:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b89:	0f b6 00             	movzbl (%eax),%eax
c0105b8c:	84 c0                	test   %al,%al
c0105b8e:	75 e4                	jne    c0105b74 <strnlen+0x19>
    }
    return cnt;
c0105b90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b93:	c9                   	leave  
c0105b94:	c3                   	ret    

c0105b95 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105b95:	55                   	push   %ebp
c0105b96:	89 e5                	mov    %esp,%ebp
c0105b98:	57                   	push   %edi
c0105b99:	56                   	push   %esi
c0105b9a:	83 ec 20             	sub    $0x20,%esp
c0105b9d:	e8 10 a7 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105ba2:	05 ae 2d 01 00       	add    $0x12dae,%eax
c0105ba7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105baa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bad:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105bb3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bb9:	89 d1                	mov    %edx,%ecx
c0105bbb:	89 c2                	mov    %eax,%edx
c0105bbd:	89 ce                	mov    %ecx,%esi
c0105bbf:	89 d7                	mov    %edx,%edi
c0105bc1:	ac                   	lods   %ds:(%esi),%al
c0105bc2:	aa                   	stos   %al,%es:(%edi)
c0105bc3:	84 c0                	test   %al,%al
c0105bc5:	75 fa                	jne    c0105bc1 <strcpy+0x2c>
c0105bc7:	89 fa                	mov    %edi,%edx
c0105bc9:	89 f1                	mov    %esi,%ecx
c0105bcb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105bce:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105bd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0105bd7:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105bd8:	83 c4 20             	add    $0x20,%esp
c0105bdb:	5e                   	pop    %esi
c0105bdc:	5f                   	pop    %edi
c0105bdd:	5d                   	pop    %ebp
c0105bde:	c3                   	ret    

c0105bdf <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105bdf:	55                   	push   %ebp
c0105be0:	89 e5                	mov    %esp,%ebp
c0105be2:	83 ec 10             	sub    $0x10,%esp
c0105be5:	e8 c8 a6 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105bea:	05 66 2d 01 00       	add    $0x12d66,%eax
    char *p = dst;
c0105bef:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105bf5:	eb 21                	jmp    c0105c18 <strncpy+0x39>
        if ((*p = *src) != '\0') {
c0105bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bfa:	0f b6 10             	movzbl (%eax),%edx
c0105bfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c00:	88 10                	mov    %dl,(%eax)
c0105c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c05:	0f b6 00             	movzbl (%eax),%eax
c0105c08:	84 c0                	test   %al,%al
c0105c0a:	74 04                	je     c0105c10 <strncpy+0x31>
            src ++;
c0105c0c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105c10:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105c14:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c0105c18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c1c:	75 d9                	jne    c0105bf7 <strncpy+0x18>
    }
    return dst;
c0105c1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c21:	c9                   	leave  
c0105c22:	c3                   	ret    

c0105c23 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105c23:	55                   	push   %ebp
c0105c24:	89 e5                	mov    %esp,%ebp
c0105c26:	57                   	push   %edi
c0105c27:	56                   	push   %esi
c0105c28:	83 ec 20             	sub    $0x20,%esp
c0105c2b:	e8 82 a6 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105c30:	05 20 2d 01 00       	add    $0x12d20,%eax
c0105c35:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c47:	89 d1                	mov    %edx,%ecx
c0105c49:	89 c2                	mov    %eax,%edx
c0105c4b:	89 ce                	mov    %ecx,%esi
c0105c4d:	89 d7                	mov    %edx,%edi
c0105c4f:	ac                   	lods   %ds:(%esi),%al
c0105c50:	ae                   	scas   %es:(%edi),%al
c0105c51:	75 08                	jne    c0105c5b <strcmp+0x38>
c0105c53:	84 c0                	test   %al,%al
c0105c55:	75 f8                	jne    c0105c4f <strcmp+0x2c>
c0105c57:	31 c0                	xor    %eax,%eax
c0105c59:	eb 04                	jmp    c0105c5f <strcmp+0x3c>
c0105c5b:	19 c0                	sbb    %eax,%eax
c0105c5d:	0c 01                	or     $0x1,%al
c0105c5f:	89 fa                	mov    %edi,%edx
c0105c61:	89 f1                	mov    %esi,%ecx
c0105c63:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c66:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105c69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0105c6f:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105c70:	83 c4 20             	add    $0x20,%esp
c0105c73:	5e                   	pop    %esi
c0105c74:	5f                   	pop    %edi
c0105c75:	5d                   	pop    %ebp
c0105c76:	c3                   	ret    

c0105c77 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105c77:	55                   	push   %ebp
c0105c78:	89 e5                	mov    %esp,%ebp
c0105c7a:	e8 33 a6 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105c7f:	05 d1 2c 01 00       	add    $0x12cd1,%eax
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105c84:	eb 0c                	jmp    c0105c92 <strncmp+0x1b>
        n --, s1 ++, s2 ++;
c0105c86:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105c8a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c8e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105c92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c96:	74 1a                	je     c0105cb2 <strncmp+0x3b>
c0105c98:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c9b:	0f b6 00             	movzbl (%eax),%eax
c0105c9e:	84 c0                	test   %al,%al
c0105ca0:	74 10                	je     c0105cb2 <strncmp+0x3b>
c0105ca2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca5:	0f b6 10             	movzbl (%eax),%edx
c0105ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cab:	0f b6 00             	movzbl (%eax),%eax
c0105cae:	38 c2                	cmp    %al,%dl
c0105cb0:	74 d4                	je     c0105c86 <strncmp+0xf>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105cb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cb6:	74 18                	je     c0105cd0 <strncmp+0x59>
c0105cb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cbb:	0f b6 00             	movzbl (%eax),%eax
c0105cbe:	0f b6 d0             	movzbl %al,%edx
c0105cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cc4:	0f b6 00             	movzbl (%eax),%eax
c0105cc7:	0f b6 c0             	movzbl %al,%eax
c0105cca:	29 c2                	sub    %eax,%edx
c0105ccc:	89 d0                	mov    %edx,%eax
c0105cce:	eb 05                	jmp    c0105cd5 <strncmp+0x5e>
c0105cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105cd5:	5d                   	pop    %ebp
c0105cd6:	c3                   	ret    

c0105cd7 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105cd7:	55                   	push   %ebp
c0105cd8:	89 e5                	mov    %esp,%ebp
c0105cda:	83 ec 04             	sub    $0x4,%esp
c0105cdd:	e8 d0 a5 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105ce2:	05 6e 2c 01 00       	add    $0x12c6e,%eax
c0105ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cea:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105ced:	eb 14                	jmp    c0105d03 <strchr+0x2c>
        if (*s == c) {
c0105cef:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf2:	0f b6 00             	movzbl (%eax),%eax
c0105cf5:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105cf8:	75 05                	jne    c0105cff <strchr+0x28>
            return (char *)s;
c0105cfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cfd:	eb 13                	jmp    c0105d12 <strchr+0x3b>
        }
        s ++;
c0105cff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0105d03:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d06:	0f b6 00             	movzbl (%eax),%eax
c0105d09:	84 c0                	test   %al,%al
c0105d0b:	75 e2                	jne    c0105cef <strchr+0x18>
    }
    return NULL;
c0105d0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105d12:	c9                   	leave  
c0105d13:	c3                   	ret    

c0105d14 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105d14:	55                   	push   %ebp
c0105d15:	89 e5                	mov    %esp,%ebp
c0105d17:	83 ec 04             	sub    $0x4,%esp
c0105d1a:	e8 93 a5 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105d1f:	05 31 2c 01 00       	add    $0x12c31,%eax
c0105d24:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d27:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105d2a:	eb 0f                	jmp    c0105d3b <strfind+0x27>
        if (*s == c) {
c0105d2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d2f:	0f b6 00             	movzbl (%eax),%eax
c0105d32:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105d35:	74 10                	je     c0105d47 <strfind+0x33>
            break;
        }
        s ++;
c0105d37:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0105d3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d3e:	0f b6 00             	movzbl (%eax),%eax
c0105d41:	84 c0                	test   %al,%al
c0105d43:	75 e7                	jne    c0105d2c <strfind+0x18>
c0105d45:	eb 01                	jmp    c0105d48 <strfind+0x34>
            break;
c0105d47:	90                   	nop
    }
    return (char *)s;
c0105d48:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105d4b:	c9                   	leave  
c0105d4c:	c3                   	ret    

c0105d4d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105d4d:	55                   	push   %ebp
c0105d4e:	89 e5                	mov    %esp,%ebp
c0105d50:	83 ec 10             	sub    $0x10,%esp
c0105d53:	e8 5a a5 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105d58:	05 f8 2b 01 00       	add    $0x12bf8,%eax
    int neg = 0;
c0105d5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105d64:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105d6b:	eb 04                	jmp    c0105d71 <strtol+0x24>
        s ++;
c0105d6d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105d71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d74:	0f b6 00             	movzbl (%eax),%eax
c0105d77:	3c 20                	cmp    $0x20,%al
c0105d79:	74 f2                	je     c0105d6d <strtol+0x20>
c0105d7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d7e:	0f b6 00             	movzbl (%eax),%eax
c0105d81:	3c 09                	cmp    $0x9,%al
c0105d83:	74 e8                	je     c0105d6d <strtol+0x20>
    }

    // plus/minus sign
    if (*s == '+') {
c0105d85:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d88:	0f b6 00             	movzbl (%eax),%eax
c0105d8b:	3c 2b                	cmp    $0x2b,%al
c0105d8d:	75 06                	jne    c0105d95 <strtol+0x48>
        s ++;
c0105d8f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d93:	eb 15                	jmp    c0105daa <strtol+0x5d>
    }
    else if (*s == '-') {
c0105d95:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d98:	0f b6 00             	movzbl (%eax),%eax
c0105d9b:	3c 2d                	cmp    $0x2d,%al
c0105d9d:	75 0b                	jne    c0105daa <strtol+0x5d>
        s ++, neg = 1;
c0105d9f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105da3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105daa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105dae:	74 06                	je     c0105db6 <strtol+0x69>
c0105db0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105db4:	75 24                	jne    c0105dda <strtol+0x8d>
c0105db6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db9:	0f b6 00             	movzbl (%eax),%eax
c0105dbc:	3c 30                	cmp    $0x30,%al
c0105dbe:	75 1a                	jne    c0105dda <strtol+0x8d>
c0105dc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dc3:	83 c0 01             	add    $0x1,%eax
c0105dc6:	0f b6 00             	movzbl (%eax),%eax
c0105dc9:	3c 78                	cmp    $0x78,%al
c0105dcb:	75 0d                	jne    c0105dda <strtol+0x8d>
        s += 2, base = 16;
c0105dcd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105dd1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105dd8:	eb 2a                	jmp    c0105e04 <strtol+0xb7>
    }
    else if (base == 0 && s[0] == '0') {
c0105dda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105dde:	75 17                	jne    c0105df7 <strtol+0xaa>
c0105de0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de3:	0f b6 00             	movzbl (%eax),%eax
c0105de6:	3c 30                	cmp    $0x30,%al
c0105de8:	75 0d                	jne    c0105df7 <strtol+0xaa>
        s ++, base = 8;
c0105dea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105dee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105df5:	eb 0d                	jmp    c0105e04 <strtol+0xb7>
    }
    else if (base == 0) {
c0105df7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105dfb:	75 07                	jne    c0105e04 <strtol+0xb7>
        base = 10;
c0105dfd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105e04:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e07:	0f b6 00             	movzbl (%eax),%eax
c0105e0a:	3c 2f                	cmp    $0x2f,%al
c0105e0c:	7e 1b                	jle    c0105e29 <strtol+0xdc>
c0105e0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e11:	0f b6 00             	movzbl (%eax),%eax
c0105e14:	3c 39                	cmp    $0x39,%al
c0105e16:	7f 11                	jg     c0105e29 <strtol+0xdc>
            dig = *s - '0';
c0105e18:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e1b:	0f b6 00             	movzbl (%eax),%eax
c0105e1e:	0f be c0             	movsbl %al,%eax
c0105e21:	83 e8 30             	sub    $0x30,%eax
c0105e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e27:	eb 48                	jmp    c0105e71 <strtol+0x124>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105e29:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e2c:	0f b6 00             	movzbl (%eax),%eax
c0105e2f:	3c 60                	cmp    $0x60,%al
c0105e31:	7e 1b                	jle    c0105e4e <strtol+0x101>
c0105e33:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e36:	0f b6 00             	movzbl (%eax),%eax
c0105e39:	3c 7a                	cmp    $0x7a,%al
c0105e3b:	7f 11                	jg     c0105e4e <strtol+0x101>
            dig = *s - 'a' + 10;
c0105e3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e40:	0f b6 00             	movzbl (%eax),%eax
c0105e43:	0f be c0             	movsbl %al,%eax
c0105e46:	83 e8 57             	sub    $0x57,%eax
c0105e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e4c:	eb 23                	jmp    c0105e71 <strtol+0x124>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105e4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e51:	0f b6 00             	movzbl (%eax),%eax
c0105e54:	3c 40                	cmp    $0x40,%al
c0105e56:	7e 3c                	jle    c0105e94 <strtol+0x147>
c0105e58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e5b:	0f b6 00             	movzbl (%eax),%eax
c0105e5e:	3c 5a                	cmp    $0x5a,%al
c0105e60:	7f 32                	jg     c0105e94 <strtol+0x147>
            dig = *s - 'A' + 10;
c0105e62:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e65:	0f b6 00             	movzbl (%eax),%eax
c0105e68:	0f be c0             	movsbl %al,%eax
c0105e6b:	83 e8 37             	sub    $0x37,%eax
c0105e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e74:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105e77:	7d 1a                	jge    c0105e93 <strtol+0x146>
            break;
        }
        s ++, val = (val * base) + dig;
c0105e79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105e7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e80:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105e84:	89 c2                	mov    %eax,%edx
c0105e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e89:	01 d0                	add    %edx,%eax
c0105e8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105e8e:	e9 71 ff ff ff       	jmp    c0105e04 <strtol+0xb7>
            break;
c0105e93:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105e94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105e98:	74 08                	je     c0105ea2 <strtol+0x155>
        *endptr = (char *) s;
c0105e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e9d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ea0:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105ea2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105ea6:	74 07                	je     c0105eaf <strtol+0x162>
c0105ea8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105eab:	f7 d8                	neg    %eax
c0105ead:	eb 03                	jmp    c0105eb2 <strtol+0x165>
c0105eaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105eb2:	c9                   	leave  
c0105eb3:	c3                   	ret    

c0105eb4 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105eb4:	55                   	push   %ebp
c0105eb5:	89 e5                	mov    %esp,%ebp
c0105eb7:	57                   	push   %edi
c0105eb8:	83 ec 24             	sub    $0x24,%esp
c0105ebb:	e8 f2 a3 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105ec0:	05 90 2a 01 00       	add    $0x12a90,%eax
c0105ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ec8:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105ecb:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105ecf:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ed2:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105ed5:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105ed8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105ede:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105ee1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105ee5:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105ee8:	89 d7                	mov    %edx,%edi
c0105eea:	f3 aa                	rep stos %al,%es:(%edi)
c0105eec:	89 fa                	mov    %edi,%edx
c0105eee:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105ef1:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105ef4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105ef7:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105ef8:	83 c4 24             	add    $0x24,%esp
c0105efb:	5f                   	pop    %edi
c0105efc:	5d                   	pop    %ebp
c0105efd:	c3                   	ret    

c0105efe <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105efe:	55                   	push   %ebp
c0105eff:	89 e5                	mov    %esp,%ebp
c0105f01:	57                   	push   %edi
c0105f02:	56                   	push   %esi
c0105f03:	53                   	push   %ebx
c0105f04:	83 ec 30             	sub    $0x30,%esp
c0105f07:	e8 a6 a3 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105f0c:	05 44 2a 01 00       	add    $0x12a44,%eax
c0105f11:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f14:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f17:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105f1d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f20:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f26:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105f29:	73 42                	jae    c0105f6d <memmove+0x6f>
c0105f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f34:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105f37:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f3a:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105f3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f40:	c1 e8 02             	shr    $0x2,%eax
c0105f43:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105f45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f48:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f4b:	89 d7                	mov    %edx,%edi
c0105f4d:	89 c6                	mov    %eax,%esi
c0105f4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f51:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105f54:	83 e1 03             	and    $0x3,%ecx
c0105f57:	74 02                	je     c0105f5b <memmove+0x5d>
c0105f59:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f5b:	89 f0                	mov    %esi,%eax
c0105f5d:	89 fa                	mov    %edi,%edx
c0105f5f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105f62:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105f65:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105f68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c0105f6b:	eb 36                	jmp    c0105fa3 <memmove+0xa5>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105f6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f70:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f73:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f76:	01 c2                	add    %eax,%edx
c0105f78:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f7b:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f81:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105f84:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f87:	89 c1                	mov    %eax,%ecx
c0105f89:	89 d8                	mov    %ebx,%eax
c0105f8b:	89 d6                	mov    %edx,%esi
c0105f8d:	89 c7                	mov    %eax,%edi
c0105f8f:	fd                   	std    
c0105f90:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f92:	fc                   	cld    
c0105f93:	89 f8                	mov    %edi,%eax
c0105f95:	89 f2                	mov    %esi,%edx
c0105f97:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105f9a:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105f9d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105fa3:	83 c4 30             	add    $0x30,%esp
c0105fa6:	5b                   	pop    %ebx
c0105fa7:	5e                   	pop    %esi
c0105fa8:	5f                   	pop    %edi
c0105fa9:	5d                   	pop    %ebp
c0105faa:	c3                   	ret    

c0105fab <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105fab:	55                   	push   %ebp
c0105fac:	89 e5                	mov    %esp,%ebp
c0105fae:	57                   	push   %edi
c0105faf:	56                   	push   %esi
c0105fb0:	83 ec 20             	sub    $0x20,%esp
c0105fb3:	e8 fa a2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0105fb8:	05 98 29 01 00       	add    $0x12998,%eax
c0105fbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fc9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fcc:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105fcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105fd2:	c1 e8 02             	shr    $0x2,%eax
c0105fd5:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105fd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fdd:	89 d7                	mov    %edx,%edi
c0105fdf:	89 c6                	mov    %eax,%esi
c0105fe1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105fe3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105fe6:	83 e1 03             	and    $0x3,%ecx
c0105fe9:	74 02                	je     c0105fed <memcpy+0x42>
c0105feb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105fed:	89 f0                	mov    %esi,%eax
c0105fef:	89 fa                	mov    %edi,%edx
c0105ff1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105ff4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105ff7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0105ffd:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105ffe:	83 c4 20             	add    $0x20,%esp
c0106001:	5e                   	pop    %esi
c0106002:	5f                   	pop    %edi
c0106003:	5d                   	pop    %ebp
c0106004:	c3                   	ret    

c0106005 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0106005:	55                   	push   %ebp
c0106006:	89 e5                	mov    %esp,%ebp
c0106008:	83 ec 10             	sub    $0x10,%esp
c010600b:	e8 a2 a2 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0106010:	05 40 29 01 00       	add    $0x12940,%eax
    const char *s1 = (const char *)v1;
c0106015:	8b 45 08             	mov    0x8(%ebp),%eax
c0106018:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010601b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010601e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0106021:	eb 30                	jmp    c0106053 <memcmp+0x4e>
        if (*s1 != *s2) {
c0106023:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106026:	0f b6 10             	movzbl (%eax),%edx
c0106029:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010602c:	0f b6 00             	movzbl (%eax),%eax
c010602f:	38 c2                	cmp    %al,%dl
c0106031:	74 18                	je     c010604b <memcmp+0x46>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0106033:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106036:	0f b6 00             	movzbl (%eax),%eax
c0106039:	0f b6 d0             	movzbl %al,%edx
c010603c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010603f:	0f b6 00             	movzbl (%eax),%eax
c0106042:	0f b6 c0             	movzbl %al,%eax
c0106045:	29 c2                	sub    %eax,%edx
c0106047:	89 d0                	mov    %edx,%eax
c0106049:	eb 1a                	jmp    c0106065 <memcmp+0x60>
        }
        s1 ++, s2 ++;
c010604b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010604f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c0106053:	8b 45 10             	mov    0x10(%ebp),%eax
c0106056:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106059:	89 55 10             	mov    %edx,0x10(%ebp)
c010605c:	85 c0                	test   %eax,%eax
c010605e:	75 c3                	jne    c0106023 <memcmp+0x1e>
    }
    return 0;
c0106060:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106065:	c9                   	leave  
c0106066:	c3                   	ret    

c0106067 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0106067:	55                   	push   %ebp
c0106068:	89 e5                	mov    %esp,%ebp
c010606a:	53                   	push   %ebx
c010606b:	83 ec 34             	sub    $0x34,%esp
c010606e:	e8 43 a2 ff ff       	call   c01002b6 <__x86.get_pc_thunk.bx>
c0106073:	81 c3 dd 28 01 00    	add    $0x128dd,%ebx
c0106079:	8b 45 10             	mov    0x10(%ebp),%eax
c010607c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010607f:	8b 45 14             	mov    0x14(%ebp),%eax
c0106082:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0106085:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106088:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010608b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010608e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0106091:	8b 45 18             	mov    0x18(%ebp),%eax
c0106094:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106097:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010609a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010609d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01060a0:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01060a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01060a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01060ad:	74 1c                	je     c01060cb <printnum+0x64>
c01060af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060b2:	ba 00 00 00 00       	mov    $0x0,%edx
c01060b7:	f7 75 e4             	divl   -0x1c(%ebp)
c01060ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01060bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060c0:	ba 00 00 00 00       	mov    $0x0,%edx
c01060c5:	f7 75 e4             	divl   -0x1c(%ebp)
c01060c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01060ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01060d1:	f7 75 e4             	divl   -0x1c(%ebp)
c01060d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01060d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01060da:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01060dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01060e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01060e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01060e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01060e9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01060ec:	8b 45 18             	mov    0x18(%ebp),%eax
c01060ef:	ba 00 00 00 00       	mov    $0x0,%edx
c01060f4:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c01060f7:	72 41                	jb     c010613a <printnum+0xd3>
c01060f9:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c01060fc:	77 05                	ja     c0106103 <printnum+0x9c>
c01060fe:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0106101:	72 37                	jb     c010613a <printnum+0xd3>
        printnum(putch, putdat, result, base, width - 1, padc);
c0106103:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106106:	83 e8 01             	sub    $0x1,%eax
c0106109:	83 ec 04             	sub    $0x4,%esp
c010610c:	ff 75 20             	pushl  0x20(%ebp)
c010610f:	50                   	push   %eax
c0106110:	ff 75 18             	pushl  0x18(%ebp)
c0106113:	ff 75 ec             	pushl  -0x14(%ebp)
c0106116:	ff 75 e8             	pushl  -0x18(%ebp)
c0106119:	ff 75 0c             	pushl  0xc(%ebp)
c010611c:	ff 75 08             	pushl  0x8(%ebp)
c010611f:	e8 43 ff ff ff       	call   c0106067 <printnum>
c0106124:	83 c4 20             	add    $0x20,%esp
c0106127:	eb 1b                	jmp    c0106144 <printnum+0xdd>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0106129:	83 ec 08             	sub    $0x8,%esp
c010612c:	ff 75 0c             	pushl  0xc(%ebp)
c010612f:	ff 75 20             	pushl  0x20(%ebp)
c0106132:	8b 45 08             	mov    0x8(%ebp),%eax
c0106135:	ff d0                	call   *%eax
c0106137:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
c010613a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010613e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106142:	7f e5                	jg     c0106129 <printnum+0xc2>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0106144:	8d 93 6e ee fe ff    	lea    -0x11192(%ebx),%edx
c010614a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010614d:	01 d0                	add    %edx,%eax
c010614f:	0f b6 00             	movzbl (%eax),%eax
c0106152:	0f be c0             	movsbl %al,%eax
c0106155:	83 ec 08             	sub    $0x8,%esp
c0106158:	ff 75 0c             	pushl  0xc(%ebp)
c010615b:	50                   	push   %eax
c010615c:	8b 45 08             	mov    0x8(%ebp),%eax
c010615f:	ff d0                	call   *%eax
c0106161:	83 c4 10             	add    $0x10,%esp
}
c0106164:	90                   	nop
c0106165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0106168:	c9                   	leave  
c0106169:	c3                   	ret    

c010616a <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010616a:	55                   	push   %ebp
c010616b:	89 e5                	mov    %esp,%ebp
c010616d:	e8 40 a1 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0106172:	05 de 27 01 00       	add    $0x127de,%eax
    if (lflag >= 2) {
c0106177:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010617b:	7e 14                	jle    c0106191 <getuint+0x27>
        return va_arg(*ap, unsigned long long);
c010617d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106180:	8b 00                	mov    (%eax),%eax
c0106182:	8d 48 08             	lea    0x8(%eax),%ecx
c0106185:	8b 55 08             	mov    0x8(%ebp),%edx
c0106188:	89 0a                	mov    %ecx,(%edx)
c010618a:	8b 50 04             	mov    0x4(%eax),%edx
c010618d:	8b 00                	mov    (%eax),%eax
c010618f:	eb 30                	jmp    c01061c1 <getuint+0x57>
    }
    else if (lflag) {
c0106191:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106195:	74 16                	je     c01061ad <getuint+0x43>
        return va_arg(*ap, unsigned long);
c0106197:	8b 45 08             	mov    0x8(%ebp),%eax
c010619a:	8b 00                	mov    (%eax),%eax
c010619c:	8d 48 04             	lea    0x4(%eax),%ecx
c010619f:	8b 55 08             	mov    0x8(%ebp),%edx
c01061a2:	89 0a                	mov    %ecx,(%edx)
c01061a4:	8b 00                	mov    (%eax),%eax
c01061a6:	ba 00 00 00 00       	mov    $0x0,%edx
c01061ab:	eb 14                	jmp    c01061c1 <getuint+0x57>
    }
    else {
        return va_arg(*ap, unsigned int);
c01061ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01061b0:	8b 00                	mov    (%eax),%eax
c01061b2:	8d 48 04             	lea    0x4(%eax),%ecx
c01061b5:	8b 55 08             	mov    0x8(%ebp),%edx
c01061b8:	89 0a                	mov    %ecx,(%edx)
c01061ba:	8b 00                	mov    (%eax),%eax
c01061bc:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01061c1:	5d                   	pop    %ebp
c01061c2:	c3                   	ret    

c01061c3 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01061c3:	55                   	push   %ebp
c01061c4:	89 e5                	mov    %esp,%ebp
c01061c6:	e8 e7 a0 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c01061cb:	05 85 27 01 00       	add    $0x12785,%eax
    if (lflag >= 2) {
c01061d0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01061d4:	7e 14                	jle    c01061ea <getint+0x27>
        return va_arg(*ap, long long);
c01061d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01061d9:	8b 00                	mov    (%eax),%eax
c01061db:	8d 48 08             	lea    0x8(%eax),%ecx
c01061de:	8b 55 08             	mov    0x8(%ebp),%edx
c01061e1:	89 0a                	mov    %ecx,(%edx)
c01061e3:	8b 50 04             	mov    0x4(%eax),%edx
c01061e6:	8b 00                	mov    (%eax),%eax
c01061e8:	eb 28                	jmp    c0106212 <getint+0x4f>
    }
    else if (lflag) {
c01061ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01061ee:	74 12                	je     c0106202 <getint+0x3f>
        return va_arg(*ap, long);
c01061f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01061f3:	8b 00                	mov    (%eax),%eax
c01061f5:	8d 48 04             	lea    0x4(%eax),%ecx
c01061f8:	8b 55 08             	mov    0x8(%ebp),%edx
c01061fb:	89 0a                	mov    %ecx,(%edx)
c01061fd:	8b 00                	mov    (%eax),%eax
c01061ff:	99                   	cltd   
c0106200:	eb 10                	jmp    c0106212 <getint+0x4f>
    }
    else {
        return va_arg(*ap, int);
c0106202:	8b 45 08             	mov    0x8(%ebp),%eax
c0106205:	8b 00                	mov    (%eax),%eax
c0106207:	8d 48 04             	lea    0x4(%eax),%ecx
c010620a:	8b 55 08             	mov    0x8(%ebp),%edx
c010620d:	89 0a                	mov    %ecx,(%edx)
c010620f:	8b 00                	mov    (%eax),%eax
c0106211:	99                   	cltd   
    }
}
c0106212:	5d                   	pop    %ebp
c0106213:	c3                   	ret    

c0106214 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0106214:	55                   	push   %ebp
c0106215:	89 e5                	mov    %esp,%ebp
c0106217:	83 ec 18             	sub    $0x18,%esp
c010621a:	e8 93 a0 ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010621f:	05 31 27 01 00       	add    $0x12731,%eax
    va_list ap;

    va_start(ap, fmt);
c0106224:	8d 45 14             	lea    0x14(%ebp),%eax
c0106227:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010622a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010622d:	50                   	push   %eax
c010622e:	ff 75 10             	pushl  0x10(%ebp)
c0106231:	ff 75 0c             	pushl  0xc(%ebp)
c0106234:	ff 75 08             	pushl  0x8(%ebp)
c0106237:	e8 06 00 00 00       	call   c0106242 <vprintfmt>
c010623c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c010623f:	90                   	nop
c0106240:	c9                   	leave  
c0106241:	c3                   	ret    

c0106242 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0106242:	55                   	push   %ebp
c0106243:	89 e5                	mov    %esp,%ebp
c0106245:	57                   	push   %edi
c0106246:	56                   	push   %esi
c0106247:	53                   	push   %ebx
c0106248:	83 ec 2c             	sub    $0x2c,%esp
c010624b:	e8 8c 04 00 00       	call   c01066dc <__x86.get_pc_thunk.di>
c0106250:	81 c7 00 27 01 00    	add    $0x12700,%edi
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0106256:	eb 17                	jmp    c010626f <vprintfmt+0x2d>
            if (ch == '\0') {
c0106258:	85 db                	test   %ebx,%ebx
c010625a:	0f 84 9a 03 00 00    	je     c01065fa <.L24+0x2d>
                return;
            }
            putch(ch, putdat);
c0106260:	83 ec 08             	sub    $0x8,%esp
c0106263:	ff 75 0c             	pushl  0xc(%ebp)
c0106266:	53                   	push   %ebx
c0106267:	8b 45 08             	mov    0x8(%ebp),%eax
c010626a:	ff d0                	call   *%eax
c010626c:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010626f:	8b 45 10             	mov    0x10(%ebp),%eax
c0106272:	8d 50 01             	lea    0x1(%eax),%edx
c0106275:	89 55 10             	mov    %edx,0x10(%ebp)
c0106278:	0f b6 00             	movzbl (%eax),%eax
c010627b:	0f b6 d8             	movzbl %al,%ebx
c010627e:	83 fb 25             	cmp    $0x25,%ebx
c0106281:	75 d5                	jne    c0106258 <vprintfmt+0x16>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0106283:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
        width = precision = -1;
c0106287:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
c010628e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106291:	89 45 d8             	mov    %eax,-0x28(%ebp)
        lflag = altflag = 0;
c0106294:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
c010629b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010629e:	89 45 d0             	mov    %eax,-0x30(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01062a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01062a4:	8d 50 01             	lea    0x1(%eax),%edx
c01062a7:	89 55 10             	mov    %edx,0x10(%ebp)
c01062aa:	0f b6 00             	movzbl (%eax),%eax
c01062ad:	0f b6 d8             	movzbl %al,%ebx
c01062b0:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01062b3:	83 f8 55             	cmp    $0x55,%eax
c01062b6:	0f 87 11 03 00 00    	ja     c01065cd <.L24>
c01062bc:	c1 e0 02             	shl    $0x2,%eax
c01062bf:	8b 84 38 94 ee fe ff 	mov    -0x1116c(%eax,%edi,1),%eax
c01062c6:	01 f8                	add    %edi,%eax
c01062c8:	ff e0                	jmp    *%eax

c01062ca <.L29>:

        // flag to pad on the right
        case '-':
            padc = '-';
c01062ca:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
            goto reswitch;
c01062ce:	eb d1                	jmp    c01062a1 <vprintfmt+0x5f>

c01062d0 <.L31>:

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01062d0:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
            goto reswitch;
c01062d4:	eb cb                	jmp    c01062a1 <vprintfmt+0x5f>

c01062d6 <.L32>:

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01062d6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
                precision = precision * 10 + ch - '0';
c01062dd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01062e0:	89 d0                	mov    %edx,%eax
c01062e2:	c1 e0 02             	shl    $0x2,%eax
c01062e5:	01 d0                	add    %edx,%eax
c01062e7:	01 c0                	add    %eax,%eax
c01062e9:	01 d8                	add    %ebx,%eax
c01062eb:	83 e8 30             	sub    $0x30,%eax
c01062ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
                ch = *fmt;
c01062f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01062f4:	0f b6 00             	movzbl (%eax),%eax
c01062f7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01062fa:	83 fb 2f             	cmp    $0x2f,%ebx
c01062fd:	7e 39                	jle    c0106338 <.L25+0xc>
c01062ff:	83 fb 39             	cmp    $0x39,%ebx
c0106302:	7f 34                	jg     c0106338 <.L25+0xc>
            for (precision = 0; ; ++ fmt) {
c0106304:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0106308:	eb d3                	jmp    c01062dd <.L32+0x7>

c010630a <.L28>:
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c010630a:	8b 45 14             	mov    0x14(%ebp),%eax
c010630d:	8d 50 04             	lea    0x4(%eax),%edx
c0106310:	89 55 14             	mov    %edx,0x14(%ebp)
c0106313:	8b 00                	mov    (%eax),%eax
c0106315:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            goto process_precision;
c0106318:	eb 1f                	jmp    c0106339 <.L25+0xd>

c010631a <.L30>:

        case '.':
            if (width < 0)
c010631a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010631e:	79 81                	jns    c01062a1 <vprintfmt+0x5f>
                width = 0;
c0106320:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
            goto reswitch;
c0106327:	e9 75 ff ff ff       	jmp    c01062a1 <vprintfmt+0x5f>

c010632c <.L25>:

        case '#':
            altflag = 1;
c010632c:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
            goto reswitch;
c0106333:	e9 69 ff ff ff       	jmp    c01062a1 <vprintfmt+0x5f>
            goto process_precision;
c0106338:	90                   	nop

        process_precision:
            if (width < 0)
c0106339:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010633d:	0f 89 5e ff ff ff    	jns    c01062a1 <vprintfmt+0x5f>
                width = precision, precision = -1;
c0106343:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106346:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0106349:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
            goto reswitch;
c0106350:	e9 4c ff ff ff       	jmp    c01062a1 <vprintfmt+0x5f>

c0106355 <.L36>:

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0106355:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
            goto reswitch;
c0106359:	e9 43 ff ff ff       	jmp    c01062a1 <vprintfmt+0x5f>

c010635e <.L33>:

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010635e:	8b 45 14             	mov    0x14(%ebp),%eax
c0106361:	8d 50 04             	lea    0x4(%eax),%edx
c0106364:	89 55 14             	mov    %edx,0x14(%ebp)
c0106367:	8b 00                	mov    (%eax),%eax
c0106369:	83 ec 08             	sub    $0x8,%esp
c010636c:	ff 75 0c             	pushl  0xc(%ebp)
c010636f:	50                   	push   %eax
c0106370:	8b 45 08             	mov    0x8(%ebp),%eax
c0106373:	ff d0                	call   *%eax
c0106375:	83 c4 10             	add    $0x10,%esp
            break;
c0106378:	e9 78 02 00 00       	jmp    c01065f5 <.L24+0x28>

c010637d <.L35>:

        // error message
        case 'e':
            err = va_arg(ap, int);
c010637d:	8b 45 14             	mov    0x14(%ebp),%eax
c0106380:	8d 50 04             	lea    0x4(%eax),%edx
c0106383:	89 55 14             	mov    %edx,0x14(%ebp)
c0106386:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0106388:	85 db                	test   %ebx,%ebx
c010638a:	79 02                	jns    c010638e <.L35+0x11>
                err = -err;
c010638c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010638e:	83 fb 06             	cmp    $0x6,%ebx
c0106391:	7f 0b                	jg     c010639e <.L35+0x21>
c0106393:	8b b4 9f 5c 01 00 00 	mov    0x15c(%edi,%ebx,4),%esi
c010639a:	85 f6                	test   %esi,%esi
c010639c:	75 1b                	jne    c01063b9 <.L35+0x3c>
                printfmt(putch, putdat, "error %d", err);
c010639e:	53                   	push   %ebx
c010639f:	8d 87 7f ee fe ff    	lea    -0x11181(%edi),%eax
c01063a5:	50                   	push   %eax
c01063a6:	ff 75 0c             	pushl  0xc(%ebp)
c01063a9:	ff 75 08             	pushl  0x8(%ebp)
c01063ac:	e8 63 fe ff ff       	call   c0106214 <printfmt>
c01063b1:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01063b4:	e9 3c 02 00 00       	jmp    c01065f5 <.L24+0x28>
                printfmt(putch, putdat, "%s", p);
c01063b9:	56                   	push   %esi
c01063ba:	8d 87 88 ee fe ff    	lea    -0x11178(%edi),%eax
c01063c0:	50                   	push   %eax
c01063c1:	ff 75 0c             	pushl  0xc(%ebp)
c01063c4:	ff 75 08             	pushl  0x8(%ebp)
c01063c7:	e8 48 fe ff ff       	call   c0106214 <printfmt>
c01063cc:	83 c4 10             	add    $0x10,%esp
            break;
c01063cf:	e9 21 02 00 00       	jmp    c01065f5 <.L24+0x28>

c01063d4 <.L39>:

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01063d4:	8b 45 14             	mov    0x14(%ebp),%eax
c01063d7:	8d 50 04             	lea    0x4(%eax),%edx
c01063da:	89 55 14             	mov    %edx,0x14(%ebp)
c01063dd:	8b 30                	mov    (%eax),%esi
c01063df:	85 f6                	test   %esi,%esi
c01063e1:	75 06                	jne    c01063e9 <.L39+0x15>
                p = "(null)";
c01063e3:	8d b7 8b ee fe ff    	lea    -0x11175(%edi),%esi
            }
            if (width > 0 && padc != '-') {
c01063e9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01063ed:	7e 78                	jle    c0106467 <.L39+0x93>
c01063ef:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
c01063f3:	74 72                	je     c0106467 <.L39+0x93>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01063f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01063f8:	83 ec 08             	sub    $0x8,%esp
c01063fb:	50                   	push   %eax
c01063fc:	56                   	push   %esi
c01063fd:	89 fb                	mov    %edi,%ebx
c01063ff:	e8 57 f7 ff ff       	call   c0105b5b <strnlen>
c0106404:	83 c4 10             	add    $0x10,%esp
c0106407:	89 c2                	mov    %eax,%edx
c0106409:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010640c:	29 d0                	sub    %edx,%eax
c010640e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0106411:	eb 17                	jmp    c010642a <.L39+0x56>
                    putch(padc, putdat);
c0106413:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
c0106417:	83 ec 08             	sub    $0x8,%esp
c010641a:	ff 75 0c             	pushl  0xc(%ebp)
c010641d:	50                   	push   %eax
c010641e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106421:	ff d0                	call   *%eax
c0106423:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106426:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
c010642a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010642e:	7f e3                	jg     c0106413 <.L39+0x3f>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106430:	eb 35                	jmp    c0106467 <.L39+0x93>
                if (altflag && (ch < ' ' || ch > '~')) {
c0106432:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106436:	74 1c                	je     c0106454 <.L39+0x80>
c0106438:	83 fb 1f             	cmp    $0x1f,%ebx
c010643b:	7e 05                	jle    c0106442 <.L39+0x6e>
c010643d:	83 fb 7e             	cmp    $0x7e,%ebx
c0106440:	7e 12                	jle    c0106454 <.L39+0x80>
                    putch('?', putdat);
c0106442:	83 ec 08             	sub    $0x8,%esp
c0106445:	ff 75 0c             	pushl  0xc(%ebp)
c0106448:	6a 3f                	push   $0x3f
c010644a:	8b 45 08             	mov    0x8(%ebp),%eax
c010644d:	ff d0                	call   *%eax
c010644f:	83 c4 10             	add    $0x10,%esp
c0106452:	eb 0f                	jmp    c0106463 <.L39+0x8f>
                }
                else {
                    putch(ch, putdat);
c0106454:	83 ec 08             	sub    $0x8,%esp
c0106457:	ff 75 0c             	pushl  0xc(%ebp)
c010645a:	53                   	push   %ebx
c010645b:	8b 45 08             	mov    0x8(%ebp),%eax
c010645e:	ff d0                	call   *%eax
c0106460:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106463:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
c0106467:	89 f0                	mov    %esi,%eax
c0106469:	8d 70 01             	lea    0x1(%eax),%esi
c010646c:	0f b6 00             	movzbl (%eax),%eax
c010646f:	0f be d8             	movsbl %al,%ebx
c0106472:	85 db                	test   %ebx,%ebx
c0106474:	74 26                	je     c010649c <.L39+0xc8>
c0106476:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010647a:	78 b6                	js     c0106432 <.L39+0x5e>
c010647c:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
c0106480:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0106484:	79 ac                	jns    c0106432 <.L39+0x5e>
                }
            }
            for (; width > 0; width --) {
c0106486:	eb 14                	jmp    c010649c <.L39+0xc8>
                putch(' ', putdat);
c0106488:	83 ec 08             	sub    $0x8,%esp
c010648b:	ff 75 0c             	pushl  0xc(%ebp)
c010648e:	6a 20                	push   $0x20
c0106490:	8b 45 08             	mov    0x8(%ebp),%eax
c0106493:	ff d0                	call   *%eax
c0106495:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
c0106498:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
c010649c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01064a0:	7f e6                	jg     c0106488 <.L39+0xb4>
            }
            break;
c01064a2:	e9 4e 01 00 00       	jmp    c01065f5 <.L24+0x28>

c01064a7 <.L34>:

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01064a7:	83 ec 08             	sub    $0x8,%esp
c01064aa:	ff 75 d0             	pushl  -0x30(%ebp)
c01064ad:	8d 45 14             	lea    0x14(%ebp),%eax
c01064b0:	50                   	push   %eax
c01064b1:	e8 0d fd ff ff       	call   c01061c3 <getint>
c01064b6:	83 c4 10             	add    $0x10,%esp
c01064b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01064bc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            if ((long long)num < 0) {
c01064bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01064c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01064c5:	85 d2                	test   %edx,%edx
c01064c7:	79 23                	jns    c01064ec <.L34+0x45>
                putch('-', putdat);
c01064c9:	83 ec 08             	sub    $0x8,%esp
c01064cc:	ff 75 0c             	pushl  0xc(%ebp)
c01064cf:	6a 2d                	push   $0x2d
c01064d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01064d4:	ff d0                	call   *%eax
c01064d6:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c01064d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01064dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01064df:	f7 d8                	neg    %eax
c01064e1:	83 d2 00             	adc    $0x0,%edx
c01064e4:	f7 da                	neg    %edx
c01064e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01064e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            }
            base = 10;
c01064ec:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
c01064f3:	e9 9f 00 00 00       	jmp    c0106597 <.L41+0x1f>

c01064f8 <.L40>:

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01064f8:	83 ec 08             	sub    $0x8,%esp
c01064fb:	ff 75 d0             	pushl  -0x30(%ebp)
c01064fe:	8d 45 14             	lea    0x14(%ebp),%eax
c0106501:	50                   	push   %eax
c0106502:	e8 63 fc ff ff       	call   c010616a <getuint>
c0106507:	83 c4 10             	add    $0x10,%esp
c010650a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010650d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 10;
c0106510:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
c0106517:	eb 7e                	jmp    c0106597 <.L41+0x1f>

c0106519 <.L37>:

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0106519:	83 ec 08             	sub    $0x8,%esp
c010651c:	ff 75 d0             	pushl  -0x30(%ebp)
c010651f:	8d 45 14             	lea    0x14(%ebp),%eax
c0106522:	50                   	push   %eax
c0106523:	e8 42 fc ff ff       	call   c010616a <getuint>
c0106528:	83 c4 10             	add    $0x10,%esp
c010652b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010652e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 8;
c0106531:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
            goto number;
c0106538:	eb 5d                	jmp    c0106597 <.L41+0x1f>

c010653a <.L38>:

        // pointer
        case 'p':
            putch('0', putdat);
c010653a:	83 ec 08             	sub    $0x8,%esp
c010653d:	ff 75 0c             	pushl  0xc(%ebp)
c0106540:	6a 30                	push   $0x30
c0106542:	8b 45 08             	mov    0x8(%ebp),%eax
c0106545:	ff d0                	call   *%eax
c0106547:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c010654a:	83 ec 08             	sub    $0x8,%esp
c010654d:	ff 75 0c             	pushl  0xc(%ebp)
c0106550:	6a 78                	push   $0x78
c0106552:	8b 45 08             	mov    0x8(%ebp),%eax
c0106555:	ff d0                	call   *%eax
c0106557:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010655a:	8b 45 14             	mov    0x14(%ebp),%eax
c010655d:	8d 50 04             	lea    0x4(%eax),%edx
c0106560:	89 55 14             	mov    %edx,0x14(%ebp)
c0106563:	8b 00                	mov    (%eax),%eax
c0106565:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106568:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            base = 16;
c010656f:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
            goto number;
c0106576:	eb 1f                	jmp    c0106597 <.L41+0x1f>

c0106578 <.L41>:

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0106578:	83 ec 08             	sub    $0x8,%esp
c010657b:	ff 75 d0             	pushl  -0x30(%ebp)
c010657e:	8d 45 14             	lea    0x14(%ebp),%eax
c0106581:	50                   	push   %eax
c0106582:	e8 e3 fb ff ff       	call   c010616a <getuint>
c0106587:	83 c4 10             	add    $0x10,%esp
c010658a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010658d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 16;
c0106590:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0106597:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
c010659b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010659e:	83 ec 04             	sub    $0x4,%esp
c01065a1:	52                   	push   %edx
c01065a2:	ff 75 d8             	pushl  -0x28(%ebp)
c01065a5:	50                   	push   %eax
c01065a6:	ff 75 e4             	pushl  -0x1c(%ebp)
c01065a9:	ff 75 e0             	pushl  -0x20(%ebp)
c01065ac:	ff 75 0c             	pushl  0xc(%ebp)
c01065af:	ff 75 08             	pushl  0x8(%ebp)
c01065b2:	e8 b0 fa ff ff       	call   c0106067 <printnum>
c01065b7:	83 c4 20             	add    $0x20,%esp
            break;
c01065ba:	eb 39                	jmp    c01065f5 <.L24+0x28>

c01065bc <.L27>:

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01065bc:	83 ec 08             	sub    $0x8,%esp
c01065bf:	ff 75 0c             	pushl  0xc(%ebp)
c01065c2:	53                   	push   %ebx
c01065c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01065c6:	ff d0                	call   *%eax
c01065c8:	83 c4 10             	add    $0x10,%esp
            break;
c01065cb:	eb 28                	jmp    c01065f5 <.L24+0x28>

c01065cd <.L24>:

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01065cd:	83 ec 08             	sub    $0x8,%esp
c01065d0:	ff 75 0c             	pushl  0xc(%ebp)
c01065d3:	6a 25                	push   $0x25
c01065d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01065d8:	ff d0                	call   *%eax
c01065da:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c01065dd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01065e1:	eb 04                	jmp    c01065e7 <.L24+0x1a>
c01065e3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01065e7:	8b 45 10             	mov    0x10(%ebp),%eax
c01065ea:	83 e8 01             	sub    $0x1,%eax
c01065ed:	0f b6 00             	movzbl (%eax),%eax
c01065f0:	3c 25                	cmp    $0x25,%al
c01065f2:	75 ef                	jne    c01065e3 <.L24+0x16>
                /* do nothing */;
            break;
c01065f4:	90                   	nop
    while (1) {
c01065f5:	e9 5c fc ff ff       	jmp    c0106256 <vprintfmt+0x14>
                return;
c01065fa:	90                   	nop
        }
    }
}
c01065fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01065fe:	5b                   	pop    %ebx
c01065ff:	5e                   	pop    %esi
c0106600:	5f                   	pop    %edi
c0106601:	5d                   	pop    %ebp
c0106602:	c3                   	ret    

c0106603 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0106603:	55                   	push   %ebp
c0106604:	89 e5                	mov    %esp,%ebp
c0106606:	e8 a7 9c ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010660b:	05 45 23 01 00       	add    $0x12345,%eax
    b->cnt ++;
c0106610:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106613:	8b 40 08             	mov    0x8(%eax),%eax
c0106616:	8d 50 01             	lea    0x1(%eax),%edx
c0106619:	8b 45 0c             	mov    0xc(%ebp),%eax
c010661c:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010661f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106622:	8b 10                	mov    (%eax),%edx
c0106624:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106627:	8b 40 04             	mov    0x4(%eax),%eax
c010662a:	39 c2                	cmp    %eax,%edx
c010662c:	73 12                	jae    c0106640 <sprintputch+0x3d>
        *b->buf ++ = ch;
c010662e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106631:	8b 00                	mov    (%eax),%eax
c0106633:	8d 48 01             	lea    0x1(%eax),%ecx
c0106636:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106639:	89 0a                	mov    %ecx,(%edx)
c010663b:	8b 55 08             	mov    0x8(%ebp),%edx
c010663e:	88 10                	mov    %dl,(%eax)
    }
}
c0106640:	90                   	nop
c0106641:	5d                   	pop    %ebp
c0106642:	c3                   	ret    

c0106643 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0106643:	55                   	push   %ebp
c0106644:	89 e5                	mov    %esp,%ebp
c0106646:	83 ec 18             	sub    $0x18,%esp
c0106649:	e8 64 9c ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c010664e:	05 02 23 01 00       	add    $0x12302,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0106653:	8d 45 14             	lea    0x14(%ebp),%eax
c0106656:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0106659:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010665c:	50                   	push   %eax
c010665d:	ff 75 10             	pushl  0x10(%ebp)
c0106660:	ff 75 0c             	pushl  0xc(%ebp)
c0106663:	ff 75 08             	pushl  0x8(%ebp)
c0106666:	e8 0b 00 00 00       	call   c0106676 <vsnprintf>
c010666b:	83 c4 10             	add    $0x10,%esp
c010666e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0106671:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106674:	c9                   	leave  
c0106675:	c3                   	ret    

c0106676 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0106676:	55                   	push   %ebp
c0106677:	89 e5                	mov    %esp,%ebp
c0106679:	83 ec 18             	sub    $0x18,%esp
c010667c:	e8 31 9c ff ff       	call   c01002b2 <__x86.get_pc_thunk.ax>
c0106681:	05 cf 22 01 00       	add    $0x122cf,%eax
    struct sprintbuf b = {str, str + size - 1, 0};
c0106686:	8b 55 08             	mov    0x8(%ebp),%edx
c0106689:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010668c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010668f:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0106692:	8b 55 08             	mov    0x8(%ebp),%edx
c0106695:	01 ca                	add    %ecx,%edx
c0106697:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010669a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01066a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01066a5:	74 0a                	je     c01066b1 <vsnprintf+0x3b>
c01066a7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01066aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01066ad:	39 d1                	cmp    %edx,%ecx
c01066af:	76 07                	jbe    c01066b8 <vsnprintf+0x42>
        return -E_INVAL;
c01066b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01066b6:	eb 22                	jmp    c01066da <vsnprintf+0x64>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01066b8:	ff 75 14             	pushl  0x14(%ebp)
c01066bb:	ff 75 10             	pushl  0x10(%ebp)
c01066be:	8d 55 ec             	lea    -0x14(%ebp),%edx
c01066c1:	52                   	push   %edx
c01066c2:	8d 80 b3 dc fe ff    	lea    -0x1234d(%eax),%eax
c01066c8:	50                   	push   %eax
c01066c9:	e8 74 fb ff ff       	call   c0106242 <vprintfmt>
c01066ce:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c01066d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01066d4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01066d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01066da:	c9                   	leave  
c01066db:	c3                   	ret    

c01066dc <__x86.get_pc_thunk.di>:
c01066dc:	8b 3c 24             	mov    (%esp),%edi
c01066df:	c3                   	ret    
