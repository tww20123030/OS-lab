
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4 66                	in     $0x66,%al

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# physical addresses [0, 4MB).  This 4MB region will be suffice
	# until we set up our real page table in i386_vm_init in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 10 11 00       	mov    $0x111000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 10 11 f0       	mov    $0xf0111000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 03 01 00 00       	call   f0100141 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	53                   	push   %ebx
f0100044:	83 ec 14             	sub    $0x14,%esp
		monitor(NULL);
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
f0100047:	8d 5d 14             	lea    0x14(%ebp),%ebx
{
	va_list ap;

	va_start(ap, fmt);
	cprintf("kernel warning at %s:%d: ", file, line);
f010004a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010004d:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100051:	8b 45 08             	mov    0x8(%ebp),%eax
f0100054:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100058:	c7 04 24 60 1f 10 f0 	movl   $0xf0101f60,(%esp)
f010005f:	e8 97 0b 00 00       	call   f0100bfb <cprintf>
	vcprintf(fmt, ap);
f0100064:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100068:	8b 45 10             	mov    0x10(%ebp),%eax
f010006b:	89 04 24             	mov    %eax,(%esp)
f010006e:	e8 55 0b 00 00       	call   f0100bc8 <vcprintf>
	cprintf("\n");
f0100073:	c7 04 24 85 20 10 f0 	movl   $0xf0102085,(%esp)
f010007a:	e8 7c 0b 00 00       	call   f0100bfb <cprintf>
	va_end(ap);
}
f010007f:	83 c4 14             	add    $0x14,%esp
f0100082:	5b                   	pop    %ebx
f0100083:	5d                   	pop    %ebp
f0100084:	c3                   	ret    

f0100085 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100085:	55                   	push   %ebp
f0100086:	89 e5                	mov    %esp,%ebp
f0100088:	56                   	push   %esi
f0100089:	53                   	push   %ebx
f010008a:	83 ec 10             	sub    $0x10,%esp
f010008d:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100090:	83 3d 00 33 11 f0 00 	cmpl   $0x0,0xf0113300
f0100097:	75 3d                	jne    f01000d6 <_panic+0x51>
		goto dead;
	panicstr = fmt;
f0100099:	89 35 00 33 11 f0    	mov    %esi,0xf0113300

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
f010009f:	fa                   	cli    
f01000a0:	fc                   	cld    
/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
f01000a1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");

	va_start(ap, fmt);
	cprintf("kernel panic at %s:%d: ", file, line);
f01000a4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01000a7:	89 44 24 08          	mov    %eax,0x8(%esp)
f01000ab:	8b 45 08             	mov    0x8(%ebp),%eax
f01000ae:	89 44 24 04          	mov    %eax,0x4(%esp)
f01000b2:	c7 04 24 7a 1f 10 f0 	movl   $0xf0101f7a,(%esp)
f01000b9:	e8 3d 0b 00 00       	call   f0100bfb <cprintf>
	vcprintf(fmt, ap);
f01000be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01000c2:	89 34 24             	mov    %esi,(%esp)
f01000c5:	e8 fe 0a 00 00       	call   f0100bc8 <vcprintf>
	cprintf("\n");
f01000ca:	c7 04 24 85 20 10 f0 	movl   $0xf0102085,(%esp)
f01000d1:	e8 25 0b 00 00       	call   f0100bfb <cprintf>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01000dd:	e8 f9 08 00 00       	call   f01009db <monitor>
f01000e2:	eb f2                	jmp    f01000d6 <_panic+0x51>

f01000e4 <test_backtrace>:
#include <kern/console.h>

// Test the stack backtrace function (lab 1 only)
void
test_backtrace(int x)
{
f01000e4:	55                   	push   %ebp
f01000e5:	89 e5                	mov    %esp,%ebp
f01000e7:	53                   	push   %ebx
f01000e8:	83 ec 14             	sub    $0x14,%esp
f01000eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("entering test_backtrace %d\n", x);
f01000ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01000f2:	c7 04 24 92 1f 10 f0 	movl   $0xf0101f92,(%esp)
f01000f9:	e8 fd 0a 00 00       	call   f0100bfb <cprintf>
	if (x > 0)
f01000fe:	85 db                	test   %ebx,%ebx
f0100100:	7e 0d                	jle    f010010f <test_backtrace+0x2b>
		test_backtrace(x-1);
f0100102:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0100105:	89 04 24             	mov    %eax,(%esp)
f0100108:	e8 d7 ff ff ff       	call   f01000e4 <test_backtrace>
f010010d:	eb 1c                	jmp    f010012b <test_backtrace+0x47>
	else
		mon_backtrace(0, 0, 0);
f010010f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100116:	00 
f0100117:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010011e:	00 
f010011f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100126:	e8 e8 09 00 00       	call   f0100b13 <mon_backtrace>
	cprintf("leaving test_backtrace %d\n", x);
f010012b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010012f:	c7 04 24 ae 1f 10 f0 	movl   $0xf0101fae,(%esp)
f0100136:	e8 c0 0a 00 00       	call   f0100bfb <cprintf>
}
f010013b:	83 c4 14             	add    $0x14,%esp
f010013e:	5b                   	pop    %ebx
f010013f:	5d                   	pop    %ebp
f0100140:	c3                   	ret    

f0100141 <i386_init>:

void
i386_init(void)
{
f0100141:	55                   	push   %ebp
f0100142:	89 e5                	mov    %esp,%ebp
f0100144:	57                   	push   %edi
f0100145:	53                   	push   %ebx
f0100146:	81 ec 20 01 00 00    	sub    $0x120,%esp
	extern char edata[], end[];
   	// Lab1 only

	char chnum1 = 0, chnum2 = 0, chnum3 = 0, ntest[256] = {};
f010014c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
f0100150:	c6 45 f6 00          	movb   $0x0,-0xa(%ebp)
f0100154:	ba 00 01 00 00       	mov    $0x100,%edx
f0100159:	b8 00 00 00 00       	mov    $0x0,%eax
f010015e:	8d bd f6 fe ff ff    	lea    -0x10a(%ebp),%edi
f0100164:	66 ab                	stos   %ax,%es:(%edi)
f0100166:	83 ea 02             	sub    $0x2,%edx
f0100169:	89 d1                	mov    %edx,%ecx
f010016b:	c1 e9 02             	shr    $0x2,%ecx
f010016e:	f3 ab                	rep stos %eax,%es:(%edi)
f0100170:	f6 c2 02             	test   $0x2,%dl
f0100173:	74 02                	je     f0100177 <i386_init+0x36>
f0100175:	66 ab                	stos   %ax,%es:(%edi)
f0100177:	83 e2 01             	and    $0x1,%edx
f010017a:	85 d2                	test   %edx,%edx
f010017c:	74 01                	je     f010017f <i386_init+0x3e>
f010017e:	aa                   	stos   %al,%es:(%edi)
	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f010017f:	b8 60 39 11 f0       	mov    $0xf0113960,%eax
f0100184:	2d 00 33 11 f0       	sub    $0xf0113300,%eax
f0100189:	89 44 24 08          	mov    %eax,0x8(%esp)
f010018d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100194:	00 
f0100195:	c7 04 24 00 33 11 f0 	movl   $0xf0113300,(%esp)
f010019c:	e8 d5 18 00 00       	call   f0101a76 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f01001a1:	e8 f4 03 00 00       	call   f010059a <cons_init>

	cprintf("6828 decimal is %o octal!%n\n%n", 6828, &chnum1, &chnum2);
f01001a6:	8d 45 f6             	lea    -0xa(%ebp),%eax
f01001a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01001ad:	8d 7d f7             	lea    -0x9(%ebp),%edi
f01001b0:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01001b4:	c7 44 24 04 ac 1a 00 	movl   $0x1aac,0x4(%esp)
f01001bb:	00 
f01001bc:	c7 04 24 10 20 10 f0 	movl   $0xf0102010,(%esp)
f01001c3:	e8 33 0a 00 00       	call   f0100bfb <cprintf>
	cprintf("pading space in the right to number 22: %8d.\n", 22);
f01001c8:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
f01001cf:	00 
f01001d0:	c7 04 24 30 20 10 f0 	movl   $0xf0102030,(%esp)
f01001d7:	e8 1f 0a 00 00       	call   f0100bfb <cprintf>
	cprintf("chnum1: %d chnum2: %d\n", chnum1, chnum2);
f01001dc:	0f be 45 f6          	movsbl -0xa(%ebp),%eax
f01001e0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01001e4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
f01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01001ec:	c7 04 24 c9 1f 10 f0 	movl   $0xf0101fc9,(%esp)
f01001f3:	e8 03 0a 00 00       	call   f0100bfb <cprintf>
	cprintf("%n", NULL);
f01001f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01001ff:	00 
f0100200:	c7 04 24 e2 1f 10 f0 	movl   $0xf0101fe2,(%esp)
f0100207:	e8 ef 09 00 00       	call   f0100bfb <cprintf>
	memset(ntest, 0xd, sizeof(ntest) - 1);
f010020c:	c7 44 24 08 ff 00 00 	movl   $0xff,0x8(%esp)
f0100213:	00 
f0100214:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
f010021b:	00 
f010021c:	8d 9d f6 fe ff ff    	lea    -0x10a(%ebp),%ebx
f0100222:	89 1c 24             	mov    %ebx,(%esp)
f0100225:	e8 4c 18 00 00       	call   f0101a76 <memset>
	cprintf("%s%n", ntest, &chnum1); 
f010022a:	89 7c 24 08          	mov    %edi,0x8(%esp)
f010022e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100232:	c7 04 24 e0 1f 10 f0 	movl   $0xf0101fe0,(%esp)
f0100239:	e8 bd 09 00 00       	call   f0100bfb <cprintf>
	cprintf("chnum1: %d\n", chnum1);
f010023e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
f0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100246:	c7 04 24 e5 1f 10 f0 	movl   $0xf0101fe5,(%esp)
f010024d:	e8 a9 09 00 00       	call   f0100bfb <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f0100252:	c7 44 24 08 00 fc ff 	movl   $0xfffffc00,0x8(%esp)
f0100259:	ff 
f010025a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
f0100261:	00 
f0100262:	c7 04 24 f1 1f 10 f0 	movl   $0xf0101ff1,(%esp)
f0100269:	e8 8d 09 00 00       	call   f0100bfb <cprintf>


	// Test the stack backtrace function (lab 1 only)
	test_backtrace(5);
f010026e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f0100275:	e8 6a fe ff ff       	call   f01000e4 <test_backtrace>

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
f010027a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100281:	e8 55 07 00 00       	call   f01009db <monitor>
f0100286:	eb f2                	jmp    f010027a <i386_init+0x139>
	...

f0100290 <delay>:
static void cons_putc(int c);

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
f0100290:	55                   	push   %ebp
f0100291:	89 e5                	mov    %esp,%ebp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100293:	ba 84 00 00 00       	mov    $0x84,%edx
f0100298:	ec                   	in     (%dx),%al
f0100299:	ec                   	in     (%dx),%al
f010029a:	ec                   	in     (%dx),%al
f010029b:	ec                   	in     (%dx),%al
	inb(0x84);
	inb(0x84);
	inb(0x84);
	inb(0x84);
}
f010029c:	5d                   	pop    %ebp
f010029d:	c3                   	ret    

f010029e <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f010029e:	55                   	push   %ebp
f010029f:	89 e5                	mov    %esp,%ebp
f01002a1:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01002a6:	ec                   	in     (%dx),%al
f01002a7:	89 c2                	mov    %eax,%edx
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f01002a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01002ae:	f6 c2 01             	test   $0x1,%dl
f01002b1:	74 09                	je     f01002bc <serial_proc_data+0x1e>
f01002b3:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01002b8:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f01002b9:	0f b6 c0             	movzbl %al,%eax
}
f01002bc:	5d                   	pop    %ebp
f01002bd:	c3                   	ret    

f01002be <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f01002be:	55                   	push   %ebp
f01002bf:	89 e5                	mov    %esp,%ebp
f01002c1:	57                   	push   %edi
f01002c2:	56                   	push   %esi
f01002c3:	53                   	push   %ebx
f01002c4:	83 ec 0c             	sub    $0xc,%esp
f01002c7:	89 c6                	mov    %eax,%esi
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
f01002c9:	bb 44 35 11 f0       	mov    $0xf0113544,%ebx
f01002ce:	bf 40 33 11 f0       	mov    $0xf0113340,%edi
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f01002d3:	eb 1e                	jmp    f01002f3 <cons_intr+0x35>
		if (c == 0)
f01002d5:	85 c0                	test   %eax,%eax
f01002d7:	74 1a                	je     f01002f3 <cons_intr+0x35>
			continue;
		cons.buf[cons.wpos++] = c;
f01002d9:	8b 13                	mov    (%ebx),%edx
f01002db:	88 04 17             	mov    %al,(%edi,%edx,1)
f01002de:	8d 42 01             	lea    0x1(%edx),%eax
		if (cons.wpos == CONSBUFSIZE)
f01002e1:	3d 00 02 00 00       	cmp    $0x200,%eax
			cons.wpos = 0;
f01002e6:	0f 94 c2             	sete   %dl
f01002e9:	0f b6 d2             	movzbl %dl,%edx
f01002ec:	83 ea 01             	sub    $0x1,%edx
f01002ef:	21 d0                	and    %edx,%eax
f01002f1:	89 03                	mov    %eax,(%ebx)
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f01002f3:	ff d6                	call   *%esi
f01002f5:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002f8:	75 db                	jne    f01002d5 <cons_intr+0x17>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
f01002fa:	83 c4 0c             	add    $0xc,%esp
f01002fd:	5b                   	pop    %ebx
f01002fe:	5e                   	pop    %esi
f01002ff:	5f                   	pop    %edi
f0100300:	5d                   	pop    %ebp
f0100301:	c3                   	ret    

f0100302 <kbd_intr>:
	return c;
}

void
kbd_intr(void)
{
f0100302:	55                   	push   %ebp
f0100303:	89 e5                	mov    %esp,%ebp
f0100305:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100308:	b8 8a 06 10 f0       	mov    $0xf010068a,%eax
f010030d:	e8 ac ff ff ff       	call   f01002be <cons_intr>
}
f0100312:	c9                   	leave  
f0100313:	c3                   	ret    

f0100314 <serial_intr>:
	return inb(COM1+COM_RX);
}

void
serial_intr(void)
{
f0100314:	55                   	push   %ebp
f0100315:	89 e5                	mov    %esp,%ebp
f0100317:	83 ec 08             	sub    $0x8,%esp
	if (serial_exists)
f010031a:	83 3d 24 33 11 f0 00 	cmpl   $0x0,0xf0113324
f0100321:	74 0a                	je     f010032d <serial_intr+0x19>
		cons_intr(serial_proc_data);
f0100323:	b8 9e 02 10 f0       	mov    $0xf010029e,%eax
f0100328:	e8 91 ff ff ff       	call   f01002be <cons_intr>
}
f010032d:	c9                   	leave  
f010032e:	c3                   	ret    

f010032f <cons_getc>:
}

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f010032f:	55                   	push   %ebp
f0100330:	89 e5                	mov    %esp,%ebp
f0100332:	83 ec 08             	sub    $0x8,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f0100335:	e8 da ff ff ff       	call   f0100314 <serial_intr>
	kbd_intr();
f010033a:	e8 c3 ff ff ff       	call   f0100302 <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f010033f:	8b 15 40 35 11 f0    	mov    0xf0113540,%edx
f0100345:	b8 00 00 00 00       	mov    $0x0,%eax
f010034a:	3b 15 44 35 11 f0    	cmp    0xf0113544,%edx
f0100350:	74 21                	je     f0100373 <cons_getc+0x44>
		c = cons.buf[cons.rpos++];
f0100352:	0f b6 82 40 33 11 f0 	movzbl -0xfeeccc0(%edx),%eax
f0100359:	83 c2 01             	add    $0x1,%edx
		if (cons.rpos == CONSBUFSIZE)
f010035c:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.rpos = 0;
f0100362:	0f 94 c1             	sete   %cl
f0100365:	0f b6 c9             	movzbl %cl,%ecx
f0100368:	83 e9 01             	sub    $0x1,%ecx
f010036b:	21 ca                	and    %ecx,%edx
f010036d:	89 15 40 35 11 f0    	mov    %edx,0xf0113540
		return c;
	}
	return 0;
}
f0100373:	c9                   	leave  
f0100374:	c3                   	ret    

f0100375 <getchar>:
	cons_putc(c);
}

int
getchar(void)
{
f0100375:	55                   	push   %ebp
f0100376:	89 e5                	mov    %esp,%ebp
f0100378:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f010037b:	e8 af ff ff ff       	call   f010032f <cons_getc>
f0100380:	85 c0                	test   %eax,%eax
f0100382:	74 f7                	je     f010037b <getchar+0x6>
		/* do nothing */;
	return c;
}
f0100384:	c9                   	leave  
f0100385:	c3                   	ret    

f0100386 <iscons>:

int
iscons(int fdnum)
{
f0100386:	55                   	push   %ebp
f0100387:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f0100389:	b8 01 00 00 00       	mov    $0x1,%eax
f010038e:	5d                   	pop    %ebp
f010038f:	c3                   	ret    

f0100390 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100390:	55                   	push   %ebp
f0100391:	89 e5                	mov    %esp,%ebp
f0100393:	57                   	push   %edi
f0100394:	56                   	push   %esi
f0100395:	53                   	push   %ebx
f0100396:	83 ec 2c             	sub    $0x2c,%esp
f0100399:	89 c7                	mov    %eax,%edi
f010039b:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01003a0:	ec                   	in     (%dx),%al
static void
serial_putc(int c)
{
	int i;
	
	for (i = 0;
f01003a1:	a8 20                	test   $0x20,%al
f01003a3:	75 21                	jne    f01003c6 <cons_putc+0x36>
f01003a5:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003aa:	be fd 03 00 00       	mov    $0x3fd,%esi
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
f01003af:	e8 dc fe ff ff       	call   f0100290 <delay>
f01003b4:	89 f2                	mov    %esi,%edx
f01003b6:	ec                   	in     (%dx),%al
static void
serial_putc(int c)
{
	int i;
	
	for (i = 0;
f01003b7:	a8 20                	test   $0x20,%al
f01003b9:	75 0b                	jne    f01003c6 <cons_putc+0x36>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
f01003bb:	83 c3 01             	add    $0x1,%ebx
static void
serial_putc(int c)
{
	int i;
	
	for (i = 0;
f01003be:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
f01003c4:	75 e9                	jne    f01003af <cons_putc+0x1f>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
	
	outb(COM1 + COM_TX, c);
f01003c6:	89 fa                	mov    %edi,%edx
f01003c8:	89 f8                	mov    %edi,%eax
f01003ca:	88 55 e7             	mov    %dl,-0x19(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003cd:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01003d2:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003d3:	b2 79                	mov    $0x79,%dl
f01003d5:	ec                   	in     (%dx),%al
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01003d6:	84 c0                	test   %al,%al
f01003d8:	78 21                	js     f01003fb <cons_putc+0x6b>
f01003da:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003df:	be 79 03 00 00       	mov    $0x379,%esi
		delay();
f01003e4:	e8 a7 fe ff ff       	call   f0100290 <delay>
f01003e9:	89 f2                	mov    %esi,%edx
f01003eb:	ec                   	in     (%dx),%al
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01003ec:	84 c0                	test   %al,%al
f01003ee:	78 0b                	js     f01003fb <cons_putc+0x6b>
f01003f0:	83 c3 01             	add    $0x1,%ebx
f01003f3:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
f01003f9:	75 e9                	jne    f01003e4 <cons_putc+0x54>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003fb:	ba 78 03 00 00       	mov    $0x378,%edx
f0100400:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100404:	ee                   	out    %al,(%dx)
f0100405:	b2 7a                	mov    $0x7a,%dl
f0100407:	b8 0d 00 00 00       	mov    $0xd,%eax
f010040c:	ee                   	out    %al,(%dx)
f010040d:	b8 08 00 00 00       	mov    $0x8,%eax
f0100412:	ee                   	out    %al,(%dx)

static void
cga_putc(int c)
{
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
f0100413:	f7 c7 00 ff ff ff    	test   $0xffffff00,%edi
f0100419:	75 06                	jne    f0100421 <cons_putc+0x91>
		c |= 0x0700;
f010041b:	81 cf 00 07 00 00    	or     $0x700,%edi

	switch (c & 0xff) {
f0100421:	89 f8                	mov    %edi,%eax
f0100423:	25 ff 00 00 00       	and    $0xff,%eax
f0100428:	83 f8 09             	cmp    $0x9,%eax
f010042b:	0f 84 83 00 00 00    	je     f01004b4 <cons_putc+0x124>
f0100431:	83 f8 09             	cmp    $0x9,%eax
f0100434:	7f 0c                	jg     f0100442 <cons_putc+0xb2>
f0100436:	83 f8 08             	cmp    $0x8,%eax
f0100439:	0f 85 a9 00 00 00    	jne    f01004e8 <cons_putc+0x158>
f010043f:	90                   	nop
f0100440:	eb 18                	jmp    f010045a <cons_putc+0xca>
f0100442:	83 f8 0a             	cmp    $0xa,%eax
f0100445:	8d 76 00             	lea    0x0(%esi),%esi
f0100448:	74 40                	je     f010048a <cons_putc+0xfa>
f010044a:	83 f8 0d             	cmp    $0xd,%eax
f010044d:	8d 76 00             	lea    0x0(%esi),%esi
f0100450:	0f 85 92 00 00 00    	jne    f01004e8 <cons_putc+0x158>
f0100456:	66 90                	xchg   %ax,%ax
f0100458:	eb 38                	jmp    f0100492 <cons_putc+0x102>
	case '\b':
		if (crt_pos > 0) {
f010045a:	0f b7 05 30 33 11 f0 	movzwl 0xf0113330,%eax
f0100461:	66 85 c0             	test   %ax,%ax
f0100464:	0f 84 e8 00 00 00    	je     f0100552 <cons_putc+0x1c2>
			crt_pos--;
f010046a:	83 e8 01             	sub    $0x1,%eax
f010046d:	66 a3 30 33 11 f0    	mov    %ax,0xf0113330
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100473:	0f b7 c0             	movzwl %ax,%eax
f0100476:	66 81 e7 00 ff       	and    $0xff00,%di
f010047b:	83 cf 20             	or     $0x20,%edi
f010047e:	8b 15 2c 33 11 f0    	mov    0xf011332c,%edx
f0100484:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100488:	eb 7b                	jmp    f0100505 <cons_putc+0x175>
		}
		break;
	case '\n':
		crt_pos += CRT_COLS;
f010048a:	66 83 05 30 33 11 f0 	addw   $0x50,0xf0113330
f0100491:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f0100492:	0f b7 05 30 33 11 f0 	movzwl 0xf0113330,%eax
f0100499:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f010049f:	c1 e8 10             	shr    $0x10,%eax
f01004a2:	66 c1 e8 06          	shr    $0x6,%ax
f01004a6:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004a9:	c1 e0 04             	shl    $0x4,%eax
f01004ac:	66 a3 30 33 11 f0    	mov    %ax,0xf0113330
f01004b2:	eb 51                	jmp    f0100505 <cons_putc+0x175>
		break;
	case '\t':
		cons_putc(' ');
f01004b4:	b8 20 00 00 00       	mov    $0x20,%eax
f01004b9:	e8 d2 fe ff ff       	call   f0100390 <cons_putc>
		cons_putc(' ');
f01004be:	b8 20 00 00 00       	mov    $0x20,%eax
f01004c3:	e8 c8 fe ff ff       	call   f0100390 <cons_putc>
		cons_putc(' ');
f01004c8:	b8 20 00 00 00       	mov    $0x20,%eax
f01004cd:	e8 be fe ff ff       	call   f0100390 <cons_putc>
		cons_putc(' ');
f01004d2:	b8 20 00 00 00       	mov    $0x20,%eax
f01004d7:	e8 b4 fe ff ff       	call   f0100390 <cons_putc>
		cons_putc(' ');
f01004dc:	b8 20 00 00 00       	mov    $0x20,%eax
f01004e1:	e8 aa fe ff ff       	call   f0100390 <cons_putc>
f01004e6:	eb 1d                	jmp    f0100505 <cons_putc+0x175>
		break;
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f01004e8:	0f b7 05 30 33 11 f0 	movzwl 0xf0113330,%eax
f01004ef:	0f b7 c8             	movzwl %ax,%ecx
f01004f2:	8b 15 2c 33 11 f0    	mov    0xf011332c,%edx
f01004f8:	66 89 3c 4a          	mov    %di,(%edx,%ecx,2)
f01004fc:	83 c0 01             	add    $0x1,%eax
f01004ff:	66 a3 30 33 11 f0    	mov    %ax,0xf0113330
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f0100505:	66 81 3d 30 33 11 f0 	cmpw   $0x7cf,0xf0113330
f010050c:	cf 07 
f010050e:	76 42                	jbe    f0100552 <cons_putc+0x1c2>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100510:	a1 2c 33 11 f0       	mov    0xf011332c,%eax
f0100515:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
f010051c:	00 
f010051d:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100523:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100527:	89 04 24             	mov    %eax,(%esp)
f010052a:	e8 a6 15 00 00       	call   f0101ad5 <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
			crt_buf[i] = 0x0700 | ' ';
f010052f:	8b 15 2c 33 11 f0    	mov    0xf011332c,%edx
f0100535:	b8 80 07 00 00       	mov    $0x780,%eax
f010053a:	66 c7 04 42 20 07    	movw   $0x720,(%edx,%eax,2)
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100540:	83 c0 01             	add    $0x1,%eax
f0100543:	3d d0 07 00 00       	cmp    $0x7d0,%eax
f0100548:	75 f0                	jne    f010053a <cons_putc+0x1aa>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
f010054a:	66 83 2d 30 33 11 f0 	subw   $0x50,0xf0113330
f0100551:	50 
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f0100552:	8b 0d 28 33 11 f0    	mov    0xf0113328,%ecx
f0100558:	89 cb                	mov    %ecx,%ebx
f010055a:	b8 0e 00 00 00       	mov    $0xe,%eax
f010055f:	89 ca                	mov    %ecx,%edx
f0100561:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100562:	0f b7 35 30 33 11 f0 	movzwl 0xf0113330,%esi
f0100569:	83 c1 01             	add    $0x1,%ecx
f010056c:	89 f0                	mov    %esi,%eax
f010056e:	66 c1 e8 08          	shr    $0x8,%ax
f0100572:	89 ca                	mov    %ecx,%edx
f0100574:	ee                   	out    %al,(%dx)
f0100575:	b8 0f 00 00 00       	mov    $0xf,%eax
f010057a:	89 da                	mov    %ebx,%edx
f010057c:	ee                   	out    %al,(%dx)
f010057d:	89 f0                	mov    %esi,%eax
f010057f:	89 ca                	mov    %ecx,%edx
f0100581:	ee                   	out    %al,(%dx)
cons_putc(int c)
{
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100582:	83 c4 2c             	add    $0x2c,%esp
f0100585:	5b                   	pop    %ebx
f0100586:	5e                   	pop    %esi
f0100587:	5f                   	pop    %edi
f0100588:	5d                   	pop    %ebp
f0100589:	c3                   	ret    

f010058a <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f010058a:	55                   	push   %ebp
f010058b:	89 e5                	mov    %esp,%ebp
f010058d:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f0100590:	8b 45 08             	mov    0x8(%ebp),%eax
f0100593:	e8 f8 fd ff ff       	call   f0100390 <cons_putc>
}
f0100598:	c9                   	leave  
f0100599:	c3                   	ret    

f010059a <cons_init>:
}

// initialize the console devices
void
cons_init(void)
{
f010059a:	55                   	push   %ebp
f010059b:	89 e5                	mov    %esp,%ebp
f010059d:	57                   	push   %edi
f010059e:	56                   	push   %esi
f010059f:	53                   	push   %ebx
f01005a0:	83 ec 1c             	sub    $0x1c,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
f01005a3:	b8 00 80 0b f0       	mov    $0xf00b8000,%eax
f01005a8:	0f b7 10             	movzwl (%eax),%edx
	*cp = (uint16_t) 0xA55A;
f01005ab:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
	if (*cp != 0xA55A) {
f01005b0:	0f b7 00             	movzwl (%eax),%eax
f01005b3:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01005b7:	74 11                	je     f01005ca <cons_init+0x30>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
		addr_6845 = MONO_BASE;
f01005b9:	c7 05 28 33 11 f0 b4 	movl   $0x3b4,0xf0113328
f01005c0:	03 00 00 
f01005c3:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
f01005c8:	eb 16                	jmp    f01005e0 <cons_init+0x46>
	} else {
		*cp = was;
f01005ca:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01005d1:	c7 05 28 33 11 f0 d4 	movl   $0x3d4,0xf0113328
f01005d8:	03 00 00 
f01005db:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
	}
	
	/* Extract cursor location */
	outb(addr_6845, 14);
f01005e0:	8b 0d 28 33 11 f0    	mov    0xf0113328,%ecx
f01005e6:	89 cb                	mov    %ecx,%ebx
f01005e8:	b8 0e 00 00 00       	mov    $0xe,%eax
f01005ed:	89 ca                	mov    %ecx,%edx
f01005ef:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01005f0:	83 c1 01             	add    $0x1,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01005f3:	89 ca                	mov    %ecx,%edx
f01005f5:	ec                   	in     (%dx),%al
f01005f6:	0f b6 f8             	movzbl %al,%edi
f01005f9:	c1 e7 08             	shl    $0x8,%edi
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01005fc:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100601:	89 da                	mov    %ebx,%edx
f0100603:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100604:	89 ca                	mov    %ecx,%edx
f0100606:	ec                   	in     (%dx),%al
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (uint16_t*) cp;
f0100607:	89 35 2c 33 11 f0    	mov    %esi,0xf011332c
	crt_pos = pos;
f010060d:	0f b6 c8             	movzbl %al,%ecx
f0100610:	09 cf                	or     %ecx,%edi
f0100612:	66 89 3d 30 33 11 f0 	mov    %di,0xf0113330
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100619:	bb fa 03 00 00       	mov    $0x3fa,%ebx
f010061e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100623:	89 da                	mov    %ebx,%edx
f0100625:	ee                   	out    %al,(%dx)
f0100626:	b2 fb                	mov    $0xfb,%dl
f0100628:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010062d:	ee                   	out    %al,(%dx)
f010062e:	b9 f8 03 00 00       	mov    $0x3f8,%ecx
f0100633:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100638:	89 ca                	mov    %ecx,%edx
f010063a:	ee                   	out    %al,(%dx)
f010063b:	b2 f9                	mov    $0xf9,%dl
f010063d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100642:	ee                   	out    %al,(%dx)
f0100643:	b2 fb                	mov    $0xfb,%dl
f0100645:	b8 03 00 00 00       	mov    $0x3,%eax
f010064a:	ee                   	out    %al,(%dx)
f010064b:	b2 fc                	mov    $0xfc,%dl
f010064d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100652:	ee                   	out    %al,(%dx)
f0100653:	b2 f9                	mov    $0xf9,%dl
f0100655:	b8 01 00 00 00       	mov    $0x1,%eax
f010065a:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010065b:	b2 fd                	mov    $0xfd,%dl
f010065d:	ec                   	in     (%dx),%al
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f010065e:	3c ff                	cmp    $0xff,%al
f0100660:	0f 95 c0             	setne  %al
f0100663:	0f b6 f0             	movzbl %al,%esi
f0100666:	89 35 24 33 11 f0    	mov    %esi,0xf0113324
f010066c:	89 da                	mov    %ebx,%edx
f010066e:	ec                   	in     (%dx),%al
f010066f:	89 ca                	mov    %ecx,%edx
f0100671:	ec                   	in     (%dx),%al
{
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f0100672:	85 f6                	test   %esi,%esi
f0100674:	75 0c                	jne    f0100682 <cons_init+0xe8>
		cprintf("Serial port does not exist!\n");
f0100676:	c7 04 24 5e 20 10 f0 	movl   $0xf010205e,(%esp)
f010067d:	e8 79 05 00 00       	call   f0100bfb <cprintf>
}
f0100682:	83 c4 1c             	add    $0x1c,%esp
f0100685:	5b                   	pop    %ebx
f0100686:	5e                   	pop    %esi
f0100687:	5f                   	pop    %edi
f0100688:	5d                   	pop    %ebp
f0100689:	c3                   	ret    

f010068a <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f010068a:	55                   	push   %ebp
f010068b:	89 e5                	mov    %esp,%ebp
f010068d:	53                   	push   %ebx
f010068e:	83 ec 14             	sub    $0x14,%esp
f0100691:	ba 64 00 00 00       	mov    $0x64,%edx
f0100696:	ec                   	in     (%dx),%al
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
f0100697:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f010069c:	a8 01                	test   $0x1,%al
f010069e:	0f 84 d9 00 00 00    	je     f010077d <kbd_proc_data+0xf3>
f01006a4:	b2 60                	mov    $0x60,%dl
f01006a6:	ec                   	in     (%dx),%al
		return -1;

	data = inb(KBDATAP);

	if (data == 0xE0) {
f01006a7:	3c e0                	cmp    $0xe0,%al
f01006a9:	75 11                	jne    f01006bc <kbd_proc_data+0x32>
		// E0 escape character
		shift |= E0ESC;
f01006ab:	83 0d 20 33 11 f0 40 	orl    $0x40,0xf0113320
f01006b2:	bb 00 00 00 00       	mov    $0x0,%ebx
		return 0;
f01006b7:	e9 c1 00 00 00       	jmp    f010077d <kbd_proc_data+0xf3>
	} else if (data & 0x80) {
f01006bc:	84 c0                	test   %al,%al
f01006be:	79 32                	jns    f01006f2 <kbd_proc_data+0x68>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f01006c0:	8b 15 20 33 11 f0    	mov    0xf0113320,%edx
f01006c6:	f6 c2 40             	test   $0x40,%dl
f01006c9:	75 03                	jne    f01006ce <kbd_proc_data+0x44>
f01006cb:	83 e0 7f             	and    $0x7f,%eax
		shift &= ~(shiftcode[data] | E0ESC);
f01006ce:	0f b6 c0             	movzbl %al,%eax
f01006d1:	0f b6 80 a0 20 10 f0 	movzbl -0xfefdf60(%eax),%eax
f01006d8:	83 c8 40             	or     $0x40,%eax
f01006db:	0f b6 c0             	movzbl %al,%eax
f01006de:	f7 d0                	not    %eax
f01006e0:	21 c2                	and    %eax,%edx
f01006e2:	89 15 20 33 11 f0    	mov    %edx,0xf0113320
f01006e8:	bb 00 00 00 00       	mov    $0x0,%ebx
		return 0;
f01006ed:	e9 8b 00 00 00       	jmp    f010077d <kbd_proc_data+0xf3>
	} else if (shift & E0ESC) {
f01006f2:	8b 15 20 33 11 f0    	mov    0xf0113320,%edx
f01006f8:	f6 c2 40             	test   $0x40,%dl
f01006fb:	74 0c                	je     f0100709 <kbd_proc_data+0x7f>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f01006fd:	83 c8 80             	or     $0xffffff80,%eax
		shift &= ~E0ESC;
f0100700:	83 e2 bf             	and    $0xffffffbf,%edx
f0100703:	89 15 20 33 11 f0    	mov    %edx,0xf0113320
	}

	shift |= shiftcode[data];
f0100709:	0f b6 c0             	movzbl %al,%eax
	shift ^= togglecode[data];
f010070c:	0f b6 90 a0 20 10 f0 	movzbl -0xfefdf60(%eax),%edx
f0100713:	0b 15 20 33 11 f0    	or     0xf0113320,%edx
f0100719:	0f b6 88 a0 21 10 f0 	movzbl -0xfefde60(%eax),%ecx
f0100720:	31 ca                	xor    %ecx,%edx
f0100722:	89 15 20 33 11 f0    	mov    %edx,0xf0113320

	c = charcode[shift & (CTL | SHIFT)][data];
f0100728:	89 d1                	mov    %edx,%ecx
f010072a:	83 e1 03             	and    $0x3,%ecx
f010072d:	8b 0c 8d a0 22 10 f0 	mov    -0xfefdd60(,%ecx,4),%ecx
f0100734:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
	if (shift & CAPSLOCK) {
f0100738:	f6 c2 08             	test   $0x8,%dl
f010073b:	74 1a                	je     f0100757 <kbd_proc_data+0xcd>
		if ('a' <= c && c <= 'z')
f010073d:	89 d9                	mov    %ebx,%ecx
f010073f:	8d 43 9f             	lea    -0x61(%ebx),%eax
f0100742:	83 f8 19             	cmp    $0x19,%eax
f0100745:	77 05                	ja     f010074c <kbd_proc_data+0xc2>
			c += 'A' - 'a';
f0100747:	83 eb 20             	sub    $0x20,%ebx
f010074a:	eb 0b                	jmp    f0100757 <kbd_proc_data+0xcd>
		else if ('A' <= c && c <= 'Z')
f010074c:	83 e9 41             	sub    $0x41,%ecx
f010074f:	83 f9 19             	cmp    $0x19,%ecx
f0100752:	77 03                	ja     f0100757 <kbd_proc_data+0xcd>
			c += 'a' - 'A';
f0100754:	83 c3 20             	add    $0x20,%ebx
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100757:	f7 d2                	not    %edx
f0100759:	f6 c2 06             	test   $0x6,%dl
f010075c:	75 1f                	jne    f010077d <kbd_proc_data+0xf3>
f010075e:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100764:	75 17                	jne    f010077d <kbd_proc_data+0xf3>
		cprintf("Rebooting!\n");
f0100766:	c7 04 24 7b 20 10 f0 	movl   $0xf010207b,(%esp)
f010076d:	e8 89 04 00 00       	call   f0100bfb <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100772:	ba 92 00 00 00       	mov    $0x92,%edx
f0100777:	b8 03 00 00 00       	mov    $0x3,%eax
f010077c:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f010077d:	89 d8                	mov    %ebx,%eax
f010077f:	83 c4 14             	add    $0x14,%esp
f0100782:	5b                   	pop    %ebx
f0100783:	5d                   	pop    %ebp
f0100784:	c3                   	ret    
	...

f0100790 <GetCycleCount>:
	cprintf("Kernel executable memory footprint: %dKB\n",
		(end-entry+1023)/1024);
	return 0;
}
inline uint64_t GetCycleCount()
{
f0100790:	55                   	push   %ebp
f0100791:	89 e5                	mov    %esp,%ebp
	uint64_t time;
 	__asm __volatile("rdtsc": "=r" (time));
f0100793:	0f 31                	rdtsc  
	return time;
}
f0100795:	5d                   	pop    %ebp
f0100796:	c3                   	ret    

f0100797 <getbuff>:
do_overflow(void)
{
    cprintf("Overflow success\n");
}

void getbuff(char* str){
f0100797:	55                   	push   %ebp
f0100798:	89 e5                	mov    %esp,%ebp
f010079a:	8b 55 08             	mov    0x8(%ebp),%edx
// Lab1 only
// read the pointer to the retaddr on the stack
static uint32_t
read_pretaddr() {
    uint32_t pretaddr;
    __asm __volatile("leal 4(%%ebp), %0" : "=r" (pretaddr)); 
f010079d:	8d 45 04             	lea    0x4(%ebp),%eax

void getbuff(char* str){
	int *pret;
	int *p = (int*)str;
	pret = (int*)read_pretaddr();
	*p = *pret;//the normal return address of getbuff
f01007a0:	8b 08                	mov    (%eax),%ecx
f01007a2:	89 0a                	mov    %ecx,(%edx)
	*pret = (int)(p+1);//set the return  address to the address of attack code
f01007a4:	83 c2 04             	add    $0x4,%edx
f01007a7:	89 10                	mov    %edx,(%eax)
	return;
}
f01007a9:	5d                   	pop    %ebp
f01007aa:	c3                   	ret    

f01007ab <read_eip>:
// return EIP of caller.
// does not work if inlined.
// putting at the end of the file seems to prevent inlining.
unsigned
read_eip()
{
f01007ab:	55                   	push   %ebp
f01007ac:	89 e5                	mov    %esp,%ebp
	uint32_t callerpc;
	__asm __volatile("movl 4(%%ebp), %0" : "=r" (callerpc));
f01007ae:	8b 45 04             	mov    0x4(%ebp),%eax
	return callerpc;
}
f01007b1:	5d                   	pop    %ebp
f01007b2:	c3                   	ret    

f01007b3 <start_overflow>:
	*pret = (int)(p+1);//set the return  address to the address of attack code
	return;
}
void
start_overflow(void)
{
f01007b3:	55                   	push   %ebp
f01007b4:	89 e5                	mov    %esp,%ebp
f01007b6:	81 ec 28 01 00 00    	sub    $0x128,%esp
f01007bc:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f01007bf:	89 7d fc             	mov    %edi,-0x4(%ebp)
    // you augmented in the "Exercise 9" to do this job.

    // hint: You can use the read_pretaddr function to retrieve 
    //       the pointer to the function call return address;
    
    char str[256] = {};
f01007c2:	8d bd f8 fe ff ff    	lea    -0x108(%ebp),%edi
f01007c8:	b9 40 00 00 00       	mov    $0x40,%ecx
f01007cd:	b8 00 00 00 00       	mov    $0x0,%eax
f01007d2:	f3 ab                	rep stos %eax,%es:(%edi)
    int nstr = 0;
    char *pret_addr;
	// Your code here.
    char num;
    int *ptr = (int*)str;
f01007d4:	8d 9d f8 fe ff ff    	lea    -0x108(%ebp),%ebx
    
    ptr[1] = 0xff24148b;
f01007da:	c7 43 04 8b 14 24 ff 	movl   $0xff24148b,0x4(%ebx)
    ptr[2] = 0x831a8b32;
f01007e1:	c7 43 08 32 8b 1a 83 	movl   $0x831a8b32,0x8(%ebx)
    ptr[3] = 0x555337c3;
f01007e8:	c7 43 0c c3 37 53 55 	movl   $0x555337c3,0xc(%ebx)
    ptr[4] = 0xc3c9e589;
f01007ef:	c7 43 10 89 e5 c9 c3 	movl   $0xc3c9e589,0x10(%ebx)
    getbuff(str);
f01007f6:	89 1c 24             	mov    %ebx,(%esp)
f01007f9:	e8 99 ff ff ff       	call   f0100797 <getbuff>
    cprintf("%s%n\n",str,&num);
f01007fe:	8d 85 f7 fe ff ff    	lea    -0x109(%ebp),%eax
f0100804:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100808:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010080c:	c7 04 24 b0 22 10 f0 	movl   $0xf01022b0,(%esp)
f0100813:	e8 e3 03 00 00       	call   f0100bfb <cprintf>
}
f0100818:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f010081b:	8b 7d fc             	mov    -0x4(%ebp),%edi
f010081e:	89 ec                	mov    %ebp,%esp
f0100820:	5d                   	pop    %ebp
f0100821:	c3                   	ret    

f0100822 <overflow_me>:

void
overflow_me(void)
{
f0100822:	55                   	push   %ebp
f0100823:	89 e5                	mov    %esp,%ebp
f0100825:	83 ec 08             	sub    $0x8,%esp
        start_overflow();
f0100828:	e8 86 ff ff ff       	call   f01007b3 <start_overflow>
}
f010082d:	c9                   	leave  
f010082e:	c3                   	ret    

f010082f <do_overflow>:
    return pretaddr;
}

void
do_overflow(void)
{
f010082f:	55                   	push   %ebp
f0100830:	89 e5                	mov    %esp,%ebp
f0100832:	83 ec 18             	sub    $0x18,%esp
    cprintf("Overflow success\n");
f0100835:	c7 04 24 b6 22 10 f0 	movl   $0xf01022b6,(%esp)
f010083c:	e8 ba 03 00 00       	call   f0100bfb <cprintf>
}
f0100841:	c9                   	leave  
f0100842:	c3                   	ret    

f0100843 <mon_time>:
{
	uint64_t time;
 	__asm __volatile("rdtsc": "=r" (time));
	return time;
}
int mon_time(int argc, char **argv, struct Trapframe *tf){
f0100843:	55                   	push   %ebp
f0100844:	89 e5                	mov    %esp,%ebp
f0100846:	83 ec 38             	sub    $0x38,%esp
f0100849:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f010084c:	89 75 f8             	mov    %esi,-0x8(%ebp)
f010084f:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0100852:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0100855:	bb 00 00 00 00       	mov    $0x0,%ebx
f010085a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int time = 0;
	int i;
	int (*f)(int argc, char** argv, struct Trapframe* tf);

	for (i = 0; i < NCOMMANDS; i++){
		if(*commands[i].name == *argv[1]){
f0100861:	8b b3 20 25 10 f0    	mov    -0xfefdae0(%ebx),%esi
f0100867:	8b 47 04             	mov    0x4(%edi),%eax
f010086a:	0f b6 16             	movzbl (%esi),%edx
f010086d:	3a 10                	cmp    (%eax),%dl
f010086f:	75 3a                	jne    f01008ab <mon_time+0x68>
	return 0;
}
inline uint64_t GetCycleCount()
{
	uint64_t time;
 	__asm __volatile("rdtsc": "=r" (time));
f0100871:	0f 31                	rdtsc  
	int i;
	int (*f)(int argc, char** argv, struct Trapframe* tf);

	for (i = 0; i < NCOMMANDS; i++){
		if(*commands[i].name == *argv[1]){
			time = (int)GetCycleCount();
f0100873:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			//f = commands[i].func;
			commands[i].func(argc, argv, tf);
f0100876:	8b 45 10             	mov    0x10(%ebp),%eax
f0100879:	89 44 24 08          	mov    %eax,0x8(%esp)
f010087d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100881:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0100884:	89 0c 24             	mov    %ecx,(%esp)
f0100887:	ff 93 28 25 10 f0    	call   *-0xfefdad8(%ebx)
	return 0;
}
inline uint64_t GetCycleCount()
{
	uint64_t time;
 	__asm __volatile("rdtsc": "=r" (time));
f010088d:	0f 31                	rdtsc  
	for (i = 0; i < NCOMMANDS; i++){
		if(*commands[i].name == *argv[1]){
			time = (int)GetCycleCount();
			//f = commands[i].func;
			commands[i].func(argc, argv, tf);
			time = (int)GetCycleCount()- time;
f010088f:	89 c1                	mov    %eax,%ecx
f0100891:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
f0100894:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
			cprintf("%s cycles: %d\n", commands[i].name, time);
f0100897:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010089b:	89 74 24 04          	mov    %esi,0x4(%esp)
f010089f:	c7 04 24 c8 22 10 f0 	movl   $0xf01022c8,(%esp)
f01008a6:	e8 50 03 00 00       	call   f0100bfb <cprintf>
f01008ab:	83 c3 0c             	add    $0xc,%ebx
int mon_time(int argc, char **argv, struct Trapframe *tf){
	int time = 0;
	int i;
	int (*f)(int argc, char** argv, struct Trapframe* tf);

	for (i = 0; i < NCOMMANDS; i++){
f01008ae:	83 fb 24             	cmp    $0x24,%ebx
f01008b1:	75 ae                	jne    f0100861 <mon_time+0x1e>
			cprintf("%s cycles: %d\n", commands[i].name, time);
		}
	}
		//cprintf("%s %s\n",commands[0].name,commands[1].name);
	return time;
}
f01008b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01008b6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f01008b9:	8b 75 f8             	mov    -0x8(%ebp),%esi
f01008bc:	8b 7d fc             	mov    -0x4(%ebp),%edi
f01008bf:	89 ec                	mov    %ebp,%esp
f01008c1:	5d                   	pop    %ebp
f01008c2:	c3                   	ret    

f01008c3 <mon_kerninfo>:
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01008c3:	55                   	push   %ebp
f01008c4:	89 e5                	mov    %esp,%ebp
f01008c6:	83 ec 18             	sub    $0x18,%esp
	extern char entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01008c9:	c7 04 24 d7 22 10 f0 	movl   $0xf01022d7,(%esp)
f01008d0:	e8 26 03 00 00       	call   f0100bfb <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01008d5:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f01008dc:	00 
f01008dd:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f01008e4:	f0 
f01008e5:	c7 04 24 88 23 10 f0 	movl   $0xf0102388,(%esp)
f01008ec:	e8 0a 03 00 00       	call   f0100bfb <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01008f1:	c7 44 24 08 45 1f 10 	movl   $0x101f45,0x8(%esp)
f01008f8:	00 
f01008f9:	c7 44 24 04 45 1f 10 	movl   $0xf0101f45,0x4(%esp)
f0100900:	f0 
f0100901:	c7 04 24 ac 23 10 f0 	movl   $0xf01023ac,(%esp)
f0100908:	e8 ee 02 00 00       	call   f0100bfb <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010090d:	c7 44 24 08 00 33 11 	movl   $0x113300,0x8(%esp)
f0100914:	00 
f0100915:	c7 44 24 04 00 33 11 	movl   $0xf0113300,0x4(%esp)
f010091c:	f0 
f010091d:	c7 04 24 d0 23 10 f0 	movl   $0xf01023d0,(%esp)
f0100924:	e8 d2 02 00 00       	call   f0100bfb <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100929:	c7 44 24 08 60 39 11 	movl   $0x113960,0x8(%esp)
f0100930:	00 
f0100931:	c7 44 24 04 60 39 11 	movl   $0xf0113960,0x4(%esp)
f0100938:	f0 
f0100939:	c7 04 24 f4 23 10 f0 	movl   $0xf01023f4,(%esp)
f0100940:	e8 b6 02 00 00       	call   f0100bfb <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100945:	b8 5f 3d 11 f0       	mov    $0xf0113d5f,%eax
f010094a:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f010094f:	89 c2                	mov    %eax,%edx
f0100951:	c1 fa 1f             	sar    $0x1f,%edx
f0100954:	c1 ea 16             	shr    $0x16,%edx
f0100957:	8d 04 02             	lea    (%edx,%eax,1),%eax
f010095a:	c1 f8 0a             	sar    $0xa,%eax
f010095d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100961:	c7 04 24 18 24 10 f0 	movl   $0xf0102418,(%esp)
f0100968:	e8 8e 02 00 00       	call   f0100bfb <cprintf>
		(end-entry+1023)/1024);
	return 0;
}
f010096d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100972:	c9                   	leave  
f0100973:	c3                   	ret    

f0100974 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100974:	55                   	push   %ebp
f0100975:	89 e5                	mov    %esp,%ebp
f0100977:	83 ec 18             	sub    $0x18,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f010097a:	a1 24 25 10 f0       	mov    0xf0102524,%eax
f010097f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100983:	a1 20 25 10 f0       	mov    0xf0102520,%eax
f0100988:	89 44 24 04          	mov    %eax,0x4(%esp)
f010098c:	c7 04 24 f0 22 10 f0 	movl   $0xf01022f0,(%esp)
f0100993:	e8 63 02 00 00       	call   f0100bfb <cprintf>
f0100998:	a1 30 25 10 f0       	mov    0xf0102530,%eax
f010099d:	89 44 24 08          	mov    %eax,0x8(%esp)
f01009a1:	a1 2c 25 10 f0       	mov    0xf010252c,%eax
f01009a6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009aa:	c7 04 24 f0 22 10 f0 	movl   $0xf01022f0,(%esp)
f01009b1:	e8 45 02 00 00       	call   f0100bfb <cprintf>
f01009b6:	a1 3c 25 10 f0       	mov    0xf010253c,%eax
f01009bb:	89 44 24 08          	mov    %eax,0x8(%esp)
f01009bf:	a1 38 25 10 f0       	mov    0xf0102538,%eax
f01009c4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009c8:	c7 04 24 f0 22 10 f0 	movl   $0xf01022f0,(%esp)
f01009cf:	e8 27 02 00 00       	call   f0100bfb <cprintf>
	return 0;
}
f01009d4:	b8 00 00 00 00       	mov    $0x0,%eax
f01009d9:	c9                   	leave  
f01009da:	c3                   	ret    

f01009db <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f01009db:	55                   	push   %ebp
f01009dc:	89 e5                	mov    %esp,%ebp
f01009de:	57                   	push   %edi
f01009df:	56                   	push   %esi
f01009e0:	53                   	push   %ebx
f01009e1:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f01009e4:	c7 04 24 44 24 10 f0 	movl   $0xf0102444,(%esp)
f01009eb:	e8 0b 02 00 00       	call   f0100bfb <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f01009f0:	c7 04 24 68 24 10 f0 	movl   $0xf0102468,(%esp)
f01009f7:	e8 ff 01 00 00       	call   f0100bfb <cprintf>


	while (1) {
		buf = readline("K> ");
f01009fc:	c7 04 24 f9 22 10 f0 	movl   $0xf01022f9,(%esp)
f0100a03:	e8 e8 0d 00 00       	call   f01017f0 <readline>
f0100a08:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100a0a:	85 c0                	test   %eax,%eax
f0100a0c:	74 ee                	je     f01009fc <monitor+0x21>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100a0e:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
f0100a15:	be 00 00 00 00       	mov    $0x0,%esi
f0100a1a:	eb 06                	jmp    f0100a22 <monitor+0x47>
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f0100a1c:	c6 03 00             	movb   $0x0,(%ebx)
f0100a1f:	83 c3 01             	add    $0x1,%ebx
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100a22:	0f b6 03             	movzbl (%ebx),%eax
f0100a25:	84 c0                	test   %al,%al
f0100a27:	74 6c                	je     f0100a95 <monitor+0xba>
f0100a29:	0f be c0             	movsbl %al,%eax
f0100a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a30:	c7 04 24 fd 22 10 f0 	movl   $0xf01022fd,(%esp)
f0100a37:	e8 e2 0f 00 00       	call   f0101a1e <strchr>
f0100a3c:	85 c0                	test   %eax,%eax
f0100a3e:	75 dc                	jne    f0100a1c <monitor+0x41>
			*buf++ = 0;
		if (*buf == 0)
f0100a40:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a43:	74 50                	je     f0100a95 <monitor+0xba>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100a45:	83 fe 0f             	cmp    $0xf,%esi
f0100a48:	75 16                	jne    f0100a60 <monitor+0x85>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100a4a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f0100a51:	00 
f0100a52:	c7 04 24 02 23 10 f0 	movl   $0xf0102302,(%esp)
f0100a59:	e8 9d 01 00 00       	call   f0100bfb <cprintf>
f0100a5e:	eb 9c                	jmp    f01009fc <monitor+0x21>
			return 0;
		}
		argv[argc++] = buf;
f0100a60:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f0100a64:	83 c6 01             	add    $0x1,%esi
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a67:	0f b6 03             	movzbl (%ebx),%eax
f0100a6a:	84 c0                	test   %al,%al
f0100a6c:	75 0e                	jne    f0100a7c <monitor+0xa1>
f0100a6e:	66 90                	xchg   %ax,%ax
f0100a70:	eb b0                	jmp    f0100a22 <monitor+0x47>
			buf++;
f0100a72:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a75:	0f b6 03             	movzbl (%ebx),%eax
f0100a78:	84 c0                	test   %al,%al
f0100a7a:	74 a6                	je     f0100a22 <monitor+0x47>
f0100a7c:	0f be c0             	movsbl %al,%eax
f0100a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a83:	c7 04 24 fd 22 10 f0 	movl   $0xf01022fd,(%esp)
f0100a8a:	e8 8f 0f 00 00       	call   f0101a1e <strchr>
f0100a8f:	85 c0                	test   %eax,%eax
f0100a91:	74 df                	je     f0100a72 <monitor+0x97>
f0100a93:	eb 8d                	jmp    f0100a22 <monitor+0x47>
			buf++;
	}
	argv[argc] = 0;
f0100a95:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100a9c:	00 

	// Lookup and invoke the command
	if (argc == 0)
f0100a9d:	85 f6                	test   %esi,%esi
f0100a9f:	90                   	nop
f0100aa0:	0f 84 56 ff ff ff    	je     f01009fc <monitor+0x21>
f0100aa6:	bb 20 25 10 f0       	mov    $0xf0102520,%ebx
f0100aab:	bf 00 00 00 00       	mov    $0x0,%edi
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f0100ab0:	8b 03                	mov    (%ebx),%eax
f0100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ab6:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100ab9:	89 04 24             	mov    %eax,(%esp)
f0100abc:	e8 e8 0e 00 00       	call   f01019a9 <strcmp>
f0100ac1:	85 c0                	test   %eax,%eax
f0100ac3:	75 23                	jne    f0100ae8 <monitor+0x10d>
			return commands[i].func(argc, argv, tf);
f0100ac5:	6b ff 0c             	imul   $0xc,%edi,%edi
f0100ac8:	8b 45 08             	mov    0x8(%ebp),%eax
f0100acb:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100acf:	8d 45 a8             	lea    -0x58(%ebp),%eax
f0100ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ad6:	89 34 24             	mov    %esi,(%esp)
f0100ad9:	ff 97 28 25 10 f0    	call   *-0xfefdad8(%edi)


	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f0100adf:	85 c0                	test   %eax,%eax
f0100ae1:	78 28                	js     f0100b0b <monitor+0x130>
f0100ae3:	e9 14 ff ff ff       	jmp    f01009fc <monitor+0x21>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
f0100ae8:	83 c7 01             	add    $0x1,%edi
f0100aeb:	83 c3 0c             	add    $0xc,%ebx
f0100aee:	83 ff 03             	cmp    $0x3,%edi
f0100af1:	75 bd                	jne    f0100ab0 <monitor+0xd5>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100af3:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100af6:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100afa:	c7 04 24 1f 23 10 f0 	movl   $0xf010231f,(%esp)
f0100b01:	e8 f5 00 00 00       	call   f0100bfb <cprintf>
f0100b06:	e9 f1 fe ff ff       	jmp    f01009fc <monitor+0x21>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f0100b0b:	83 c4 5c             	add    $0x5c,%esp
f0100b0e:	5b                   	pop    %ebx
f0100b0f:	5e                   	pop    %esi
f0100b10:	5f                   	pop    %edi
f0100b11:	5d                   	pop    %ebp
f0100b12:	c3                   	ret    

f0100b13 <mon_backtrace>:
        start_overflow();
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100b13:	55                   	push   %ebp
f0100b14:	89 e5                	mov    %esp,%ebp
f0100b16:	57                   	push   %edi
f0100b17:	56                   	push   %esi
f0100b18:	53                   	push   %ebx
f0100b19:	83 ec 4c             	sub    $0x4c,%esp
    struct Eipdebuginfo debuginfo;
    struct Eipdebuginfo *info = &debuginfo;

    uint32_t *pebp;
    int i;
    pebp = (uint32_t*)read_ebp();
f0100b1c:	89 eb                	mov    %ebp,%ebx
f0100b1e:	bf 00 00 00 00       	mov    $0x0,%edi
    //cprintf("pebp:%p %p\n",pebp, pebp+1);
    for(i = 0; i < 7; i++){
    	cprintf("eip %08x  ebp %p  args %08x %08x %08x %08x %08x\n",*(pebp+1), pebp, *(pebp+2), *(pebp+3), *(pebp+4), *(pebp+5), *(pebp+6));
f0100b23:	8d 73 04             	lea    0x4(%ebx),%esi
f0100b26:	8b 43 18             	mov    0x18(%ebx),%eax
f0100b29:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f0100b2d:	8b 43 14             	mov    0x14(%ebx),%eax
f0100b30:	89 44 24 18          	mov    %eax,0x18(%esp)
f0100b34:	8b 43 10             	mov    0x10(%ebx),%eax
f0100b37:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100b3b:	8b 43 0c             	mov    0xc(%ebx),%eax
f0100b3e:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100b42:	8b 43 08             	mov    0x8(%ebx),%eax
f0100b45:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100b49:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0100b4d:	8b 06                	mov    (%esi),%eax
f0100b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b53:	c7 04 24 90 24 10 f0 	movl   $0xf0102490,(%esp)
f0100b5a:	e8 9c 00 00 00       	call   f0100bfb <cprintf>
    	debuginfo_eip(*(pebp+1),info);
f0100b5f:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0100b62:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b66:	8b 06                	mov    (%esi),%eax
f0100b68:	89 04 24             	mov    %eax,(%esp)
f0100b6b:	e8 fe 01 00 00       	call   f0100d6e <debuginfo_eip>
	cprintf("	%s:%d: %s+%d\n",info->eip_file, info->eip_line, info->eip_fn_name, *(pebp+1)-info->eip_fn_addr);
f0100b70:	8b 06                	mov    (%esi),%eax
f0100b72:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100b75:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100b79:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100b7c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100b80:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100b83:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100b87:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0100b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b8e:	c7 04 24 35 23 10 f0 	movl   $0xf0102335,(%esp)
f0100b95:	e8 61 00 00 00       	call   f0100bfb <cprintf>
	pebp = (uint32_t*)*(pebp);
f0100b9a:	8b 1b                	mov    (%ebx),%ebx

    uint32_t *pebp;
    int i;
    pebp = (uint32_t*)read_ebp();
    //cprintf("pebp:%p %p\n",pebp, pebp+1);
    for(i = 0; i < 7; i++){
f0100b9c:	83 c7 01             	add    $0x1,%edi
f0100b9f:	83 ff 07             	cmp    $0x7,%edi
f0100ba2:	0f 85 7b ff ff ff    	jne    f0100b23 <mon_backtrace+0x10>
    	cprintf("eip %08x  ebp %p  args %08x %08x %08x %08x %08x\n",*(pebp+1), pebp, *(pebp+2), *(pebp+3), *(pebp+4), *(pebp+5), *(pebp+6));
    	debuginfo_eip(*(pebp+1),info);
	cprintf("	%s:%d: %s+%d\n",info->eip_file, info->eip_line, info->eip_fn_name, *(pebp+1)-info->eip_fn_addr);
	pebp = (uint32_t*)*(pebp);
    }
    overflow_me();
f0100ba8:	e8 75 fc ff ff       	call   f0100822 <overflow_me>
    cprintf("Backtrace success\n");
f0100bad:	c7 04 24 44 23 10 f0 	movl   $0xf0102344,(%esp)
f0100bb4:	e8 42 00 00 00       	call   f0100bfb <cprintf>
	return 0;
}
f0100bb9:	b8 00 00 00 00       	mov    $0x0,%eax
f0100bbe:	83 c4 4c             	add    $0x4c,%esp
f0100bc1:	5b                   	pop    %ebx
f0100bc2:	5e                   	pop    %esi
f0100bc3:	5f                   	pop    %edi
f0100bc4:	5d                   	pop    %ebp
f0100bc5:	c3                   	ret    
	...

f0100bc8 <vcprintf>:
    (*cnt)++;
}

int
vcprintf(const char *fmt, va_list ap)
{
f0100bc8:	55                   	push   %ebp
f0100bc9:	89 e5                	mov    %esp,%ebp
f0100bcb:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f0100bce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);// ap:store the argument inputed by user.
f0100bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100bd8:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100bdc:	8b 45 08             	mov    0x8(%ebp),%eax
f0100bdf:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100be3:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100be6:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100bea:	c7 04 24 15 0c 10 f0 	movl   $0xf0100c15,(%esp)
f0100bf1:	e8 c1 06 00 00       	call   f01012b7 <vprintfmt>
	return cnt;
}
f0100bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100bf9:	c9                   	leave  
f0100bfa:	c3                   	ret    

f0100bfb <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0100bfb:	55                   	push   %ebp
f0100bfc:	89 e5                	mov    %esp,%ebp
f0100bfe:	83 ec 18             	sub    $0x18,%esp
	vprintfmt((void*)putch, &cnt, fmt, ap);// ap:store the argument inputed by user.
	return cnt;
}

int
cprintf(const char *fmt, ...)
f0100c01:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
f0100c04:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100c08:	8b 45 08             	mov    0x8(%ebp),%eax
f0100c0b:	89 04 24             	mov    %eax,(%esp)
f0100c0e:	e8 b5 ff ff ff       	call   f0100bc8 <vcprintf>
	
	va_end(ap);
	return cnt;
}
f0100c13:	c9                   	leave  
f0100c14:	c3                   	ret    

f0100c15 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0100c15:	55                   	push   %ebp
f0100c16:	89 e5                	mov    %esp,%ebp
f0100c18:	53                   	push   %ebx
f0100c19:	83 ec 14             	sub    $0x14,%esp
f0100c1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f0100c1f:	8b 45 08             	mov    0x8(%ebp),%eax
f0100c22:	89 04 24             	mov    %eax,(%esp)
f0100c25:	e8 60 f9 ff ff       	call   f010058a <cputchar>
    (*cnt)++;
f0100c2a:	83 03 01             	addl   $0x1,(%ebx)
}
f0100c2d:	83 c4 14             	add    $0x14,%esp
f0100c30:	5b                   	pop    %ebx
f0100c31:	5d                   	pop    %ebp
f0100c32:	c3                   	ret    
	...

f0100c40 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0100c40:	55                   	push   %ebp
f0100c41:	89 e5                	mov    %esp,%ebp
f0100c43:	57                   	push   %edi
f0100c44:	56                   	push   %esi
f0100c45:	53                   	push   %ebx
f0100c46:	83 ec 14             	sub    $0x14,%esp
f0100c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100c4c:	89 55 e8             	mov    %edx,-0x18(%ebp)
f0100c4f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0100c52:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0100c55:	8b 1a                	mov    (%edx),%ebx
f0100c57:	8b 01                	mov    (%ecx),%eax
f0100c59:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	while (l <= r) {
f0100c5c:	39 c3                	cmp    %eax,%ebx
f0100c5e:	0f 8f 9c 00 00 00    	jg     f0100d00 <stab_binsearch+0xc0>
f0100c64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		int true_m = (l + r) / 2, m = true_m;
f0100c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0100c6e:	01 d8                	add    %ebx,%eax
f0100c70:	89 c7                	mov    %eax,%edi
f0100c72:	c1 ef 1f             	shr    $0x1f,%edi
f0100c75:	01 c7                	add    %eax,%edi
f0100c77:	d1 ff                	sar    %edi
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0100c79:	39 df                	cmp    %ebx,%edi
f0100c7b:	7c 33                	jl     f0100cb0 <stab_binsearch+0x70>
f0100c7d:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100c80:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0100c83:	0f b6 44 82 04       	movzbl 0x4(%edx,%eax,4),%eax
f0100c88:	39 f0                	cmp    %esi,%eax
f0100c8a:	0f 84 bc 00 00 00    	je     f0100d4c <stab_binsearch+0x10c>
f0100c90:	8d 44 7f fd          	lea    -0x3(%edi,%edi,2),%eax
f0100c94:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx
f0100c98:	89 f8                	mov    %edi,%eax
			m--;
f0100c9a:	83 e8 01             	sub    $0x1,%eax
	
	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0100c9d:	39 d8                	cmp    %ebx,%eax
f0100c9f:	7c 0f                	jl     f0100cb0 <stab_binsearch+0x70>
f0100ca1:	0f b6 0a             	movzbl (%edx),%ecx
f0100ca4:	83 ea 0c             	sub    $0xc,%edx
f0100ca7:	39 f1                	cmp    %esi,%ecx
f0100ca9:	75 ef                	jne    f0100c9a <stab_binsearch+0x5a>
f0100cab:	e9 9e 00 00 00       	jmp    f0100d4e <stab_binsearch+0x10e>
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0100cb0:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0100cb3:	eb 3c                	jmp    f0100cf1 <stab_binsearch+0xb1>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
f0100cb5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0100cb8:	89 01                	mov    %eax,(%ecx)
			l = true_m + 1;
f0100cba:	8d 5f 01             	lea    0x1(%edi),%ebx
f0100cbd:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0100cc4:	eb 2b                	jmp    f0100cf1 <stab_binsearch+0xb1>
		} else if (stabs[m].n_value > addr) {
f0100cc6:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100cc9:	76 14                	jbe    f0100cdf <stab_binsearch+0x9f>
			*region_right = m - 1;
f0100ccb:	83 e8 01             	sub    $0x1,%eax
f0100cce:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0100cd1:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0100cd4:	89 02                	mov    %eax,(%edx)
f0100cd6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0100cdd:	eb 12                	jmp    f0100cf1 <stab_binsearch+0xb1>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0100cdf:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0100ce2:	89 01                	mov    %eax,(%ecx)
			l = m;
			addr++;
f0100ce4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0100ce8:	89 c3                	mov    %eax,%ebx
f0100cea:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;
	
	while (l <= r) {
f0100cf1:	39 5d ec             	cmp    %ebx,-0x14(%ebp)
f0100cf4:	0f 8d 71 ff ff ff    	jge    f0100c6b <stab_binsearch+0x2b>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f0100cfa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0100cfe:	75 0f                	jne    f0100d0f <stab_binsearch+0xcf>
		*region_right = *region_left - 1;
f0100d00:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0100d03:	8b 03                	mov    (%ebx),%eax
f0100d05:	83 e8 01             	sub    $0x1,%eax
f0100d08:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0100d0b:	89 02                	mov    %eax,(%edx)
f0100d0d:	eb 57                	jmp    f0100d66 <stab_binsearch+0x126>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100d0f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0100d12:	8b 01                	mov    (%ecx),%eax
		     l > *region_left && stabs[l].n_type != type;
f0100d14:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0100d17:	8b 0b                	mov    (%ebx),%ecx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100d19:	39 c1                	cmp    %eax,%ecx
f0100d1b:	7d 28                	jge    f0100d45 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f0100d1d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100d20:	8b 5d f0             	mov    -0x10(%ebp),%ebx
f0100d23:	0f b6 54 93 04       	movzbl 0x4(%ebx,%edx,4),%edx
f0100d28:	39 f2                	cmp    %esi,%edx
f0100d2a:	74 19                	je     f0100d45 <stab_binsearch+0x105>
f0100d2c:	8d 54 40 fd          	lea    -0x3(%eax,%eax,2),%edx
f0100d30:	8d 54 93 04          	lea    0x4(%ebx,%edx,4),%edx
		     l--)
f0100d34:	83 e8 01             	sub    $0x1,%eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100d37:	39 c1                	cmp    %eax,%ecx
f0100d39:	7d 0a                	jge    f0100d45 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f0100d3b:	0f b6 1a             	movzbl (%edx),%ebx
f0100d3e:	83 ea 0c             	sub    $0xc,%edx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100d41:	39 f3                	cmp    %esi,%ebx
f0100d43:	75 ef                	jne    f0100d34 <stab_binsearch+0xf4>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
f0100d45:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0100d48:	89 02                	mov    %eax,(%edx)
f0100d4a:	eb 1a                	jmp    f0100d66 <stab_binsearch+0x126>
	}
}
f0100d4c:	89 f8                	mov    %edi,%eax
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0100d4e:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100d51:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0100d54:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0100d58:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100d5b:	0f 82 54 ff ff ff    	jb     f0100cb5 <stab_binsearch+0x75>
f0100d61:	e9 60 ff ff ff       	jmp    f0100cc6 <stab_binsearch+0x86>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0100d66:	83 c4 14             	add    $0x14,%esp
f0100d69:	5b                   	pop    %ebx
f0100d6a:	5e                   	pop    %esi
f0100d6b:	5f                   	pop    %edi
f0100d6c:	5d                   	pop    %ebp
f0100d6d:	c3                   	ret    

f0100d6e <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0100d6e:	55                   	push   %ebp
f0100d6f:	89 e5                	mov    %esp,%ebp
f0100d71:	83 ec 48             	sub    $0x48,%esp
f0100d74:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0100d77:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0100d7a:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0100d7d:	8b 75 08             	mov    0x8(%ebp),%esi
f0100d80:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0100d83:	c7 03 44 25 10 f0    	movl   $0xf0102544,(%ebx)
	info->eip_line = 0;
f0100d89:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0100d90:	c7 43 08 44 25 10 f0 	movl   $0xf0102544,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0100d97:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0100d9e:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0100da1:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0100da8:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0100dae:	76 12                	jbe    f0100dc2 <debuginfo_eip+0x54>
		// Can't search for user-level addresses yet!
  	        panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100db0:	b8 81 86 10 f0       	mov    $0xf0108681,%eax
f0100db5:	3d 4d 6a 10 f0       	cmp    $0xf0106a4d,%eax
f0100dba:	0f 86 b2 01 00 00    	jbe    f0100f72 <debuginfo_eip+0x204>
f0100dc0:	eb 1c                	jmp    f0100dde <debuginfo_eip+0x70>
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
	} else {
		// Can't search for user-level addresses yet!
  	        panic("User address");
f0100dc2:	c7 44 24 08 4e 25 10 	movl   $0xf010254e,0x8(%esp)
f0100dc9:	f0 
f0100dca:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
f0100dd1:	00 
f0100dd2:	c7 04 24 5b 25 10 f0 	movl   $0xf010255b,(%esp)
f0100dd9:	e8 a7 f2 ff ff       	call   f0100085 <_panic>
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100dde:	80 3d 80 86 10 f0 00 	cmpb   $0x0,0xf0108680
f0100de5:	0f 85 87 01 00 00    	jne    f0100f72 <debuginfo_eip+0x204>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.
	
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0100deb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0100df2:	b8 4c 6a 10 f0       	mov    $0xf0106a4c,%eax
f0100df7:	2d f8 27 10 f0       	sub    $0xf01027f8,%eax
f0100dfc:	c1 f8 02             	sar    $0x2,%eax
f0100dff:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0100e05:	83 e8 01             	sub    $0x1,%eax
f0100e08:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0100e0b:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0100e0e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0100e11:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100e15:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0100e1c:	b8 f8 27 10 f0       	mov    $0xf01027f8,%eax
f0100e21:	e8 1a fe ff ff       	call   f0100c40 <stab_binsearch>
	if (lfile == 0)
f0100e26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e29:	85 c0                	test   %eax,%eax
f0100e2b:	0f 84 41 01 00 00    	je     f0100f72 <debuginfo_eip+0x204>
		return -1;
	
	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0100e31:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0100e34:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100e37:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0100e3a:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0100e3d:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100e40:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100e44:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0100e4b:	b8 f8 27 10 f0       	mov    $0xf01027f8,%eax
f0100e50:	e8 eb fd ff ff       	call   f0100c40 <stab_binsearch>

	if (lfun <= rfun) {
f0100e55:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100e58:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0100e5b:	7f 3c                	jg     f0100e99 <debuginfo_eip+0x12b>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0100e5d:	6b c0 0c             	imul   $0xc,%eax,%eax
f0100e60:	8b 80 f8 27 10 f0    	mov    -0xfefd808(%eax),%eax
f0100e66:	ba 81 86 10 f0       	mov    $0xf0108681,%edx
f0100e6b:	81 ea 4d 6a 10 f0    	sub    $0xf0106a4d,%edx
f0100e71:	39 d0                	cmp    %edx,%eax
f0100e73:	73 08                	jae    f0100e7d <debuginfo_eip+0x10f>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0100e75:	05 4d 6a 10 f0       	add    $0xf0106a4d,%eax
f0100e7a:	89 43 08             	mov    %eax,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0100e7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100e80:	6b d0 0c             	imul   $0xc,%eax,%edx
f0100e83:	8b 92 00 28 10 f0    	mov    -0xfefd800(%edx),%edx
f0100e89:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0100e8c:	29 d6                	sub    %edx,%esi
		// Search within the function definition for the line number.
		lline = lfun;
f0100e8e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0100e91:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100e94:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100e97:	eb 0f                	jmp    f0100ea8 <debuginfo_eip+0x13a>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f0100e99:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f0100e9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e9f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0100ea2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100ea5:	89 45 d0             	mov    %eax,-0x30(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0100ea8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f0100eaf:	00 
f0100eb0:	8b 43 08             	mov    0x8(%ebx),%eax
f0100eb3:	89 04 24             	mov    %eax,(%esp)
f0100eb6:	e8 90 0b 00 00       	call   f0101a4b <strfind>
f0100ebb:	2b 43 08             	sub    0x8(%ebx),%eax
f0100ebe:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);//N_SLINE:line number in text segment
f0100ec1:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0100ec4:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0100ec7:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100ecb:	c7 04 24 44 00 00 00 	movl   $0x44,(%esp)
f0100ed2:	b8 f8 27 10 f0       	mov    $0xf01027f8,%eax
f0100ed7:	e8 64 fd ff ff       	call   f0100c40 <stab_binsearch>
	if(lline > rline)return -1;
f0100edc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100edf:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f0100ee2:	0f 8f 8a 00 00 00    	jg     f0100f72 <debuginfo_eip+0x204>
	info->eip_line = stabs[lline].n_desc;//line number
f0100ee8:	ba f8 27 10 f0       	mov    $0xf01027f8,%edx
f0100eed:	6b c0 0c             	imul   $0xc,%eax,%eax
f0100ef0:	0f b7 44 10 06       	movzwl 0x6(%eax,%edx,1),%eax
f0100ef5:	89 43 04             	mov    %eax,0x4(%ebx)
	info->eip_file = stabs[lfile].n_strx + stabstr;
f0100ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100efb:	6b c8 0c             	imul   $0xc,%eax,%ecx
f0100efe:	8b 14 11             	mov    (%ecx,%edx,1),%edx
f0100f01:	81 c2 4d 6a 10 f0    	add    $0xf0106a4d,%edx
f0100f07:	89 13                	mov    %edx,(%ebx)
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
f0100f09:	89 c7                	mov    %eax,%edi
f0100f0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100f0e:	6b d0 0c             	imul   $0xc,%eax,%edx
f0100f11:	81 c2 00 28 10 f0    	add    $0xf0102800,%edx
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100f17:	eb 06                	jmp    f0100f1f <debuginfo_eip+0x1b1>
f0100f19:	83 e8 01             	sub    $0x1,%eax
f0100f1c:	83 ea 0c             	sub    $0xc,%edx
f0100f1f:	89 c6                	mov    %eax,%esi
f0100f21:	39 f8                	cmp    %edi,%eax
f0100f23:	7c 1c                	jl     f0100f41 <debuginfo_eip+0x1d3>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0100f25:	0f b6 4a fc          	movzbl -0x4(%edx),%ecx
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100f29:	80 f9 84             	cmp    $0x84,%cl
f0100f2c:	74 5d                	je     f0100f8b <debuginfo_eip+0x21d>
f0100f2e:	80 f9 64             	cmp    $0x64,%cl
f0100f31:	75 e6                	jne    f0100f19 <debuginfo_eip+0x1ab>
f0100f33:	83 3a 00             	cmpl   $0x0,(%edx)
f0100f36:	74 e1                	je     f0100f19 <debuginfo_eip+0x1ab>
f0100f38:	eb 51                	jmp    f0100f8b <debuginfo_eip+0x21d>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
		info->eip_file = stabstr + stabs[lline].n_strx;
f0100f3a:	05 4d 6a 10 f0       	add    $0xf0106a4d,%eax
f0100f3f:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0100f41:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100f44:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0100f47:	7d 30                	jge    f0100f79 <debuginfo_eip+0x20b>
		for (lline = lfun + 1;
f0100f49:	83 c0 01             	add    $0x1,%eax
f0100f4c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100f4f:	ba f8 27 10 f0       	mov    $0xf01027f8,%edx


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0100f54:	eb 08                	jmp    f0100f5e <debuginfo_eip+0x1f0>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f0100f56:	83 43 14 01          	addl   $0x1,0x14(%ebx)
	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
f0100f5a:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100f5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0100f61:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0100f64:	7d 13                	jge    f0100f79 <debuginfo_eip+0x20b>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100f66:	6b c0 0c             	imul   $0xc,%eax,%eax
f0100f69:	80 7c 10 04 a0       	cmpb   $0xa0,0x4(%eax,%edx,1)
f0100f6e:	74 e6                	je     f0100f56 <debuginfo_eip+0x1e8>
f0100f70:	eb 07                	jmp    f0100f79 <debuginfo_eip+0x20b>
f0100f72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100f77:	eb 05                	jmp    f0100f7e <debuginfo_eip+0x210>
f0100f79:	b8 00 00 00 00       	mov    $0x0,%eax
		     lline++)
			info->eip_fn_narg++;
	
	return 0;
}
f0100f7e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0100f81:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0100f84:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0100f87:	89 ec                	mov    %ebp,%esp
f0100f89:	5d                   	pop    %ebp
f0100f8a:	c3                   	ret    
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0100f8b:	6b c6 0c             	imul   $0xc,%esi,%eax
f0100f8e:	8b 80 f8 27 10 f0    	mov    -0xfefd808(%eax),%eax
f0100f94:	ba 81 86 10 f0       	mov    $0xf0108681,%edx
f0100f99:	81 ea 4d 6a 10 f0    	sub    $0xf0106a4d,%edx
f0100f9f:	39 d0                	cmp    %edx,%eax
f0100fa1:	72 97                	jb     f0100f3a <debuginfo_eip+0x1cc>
f0100fa3:	eb 9c                	jmp    f0100f41 <debuginfo_eip+0x1d3>
	...

f0100fb0 <printnum_width>:
};
//left justified 
static void
printnum_width(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc,int *pamnt,int *pcount)
{
f0100fb0:	55                   	push   %ebp
f0100fb1:	89 e5                	mov    %esp,%ebp
f0100fb3:	57                   	push   %edi
f0100fb4:	56                   	push   %esi
f0100fb5:	53                   	push   %ebx
f0100fb6:	83 ec 4c             	sub    $0x4c,%esp
f0100fb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0100fbc:	89 d7                	mov    %edx,%edi
f0100fbe:	8b 45 08             	mov    0x8(%ebp),%eax
f0100fc1:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100fc4:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100fc7:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100fca:	8b 45 10             	mov    0x10(%ebp),%eax
		int i;
		if(num >= base){
f0100fcd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100fd0:	be 00 00 00 00       	mov    $0x0,%esi
f0100fd5:	39 d6                	cmp    %edx,%esi
f0100fd7:	72 07                	jb     f0100fe0 <printnum_width+0x30>
f0100fd9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100fdc:	39 c8                	cmp    %ecx,%eax
f0100fde:	77 70                	ja     f0101050 <printnum_width+0xa0>
			(*pcount)++;
f0100fe0:	8b 5d 20             	mov    0x20(%ebp),%ebx
f0100fe3:	83 03 01             	addl   $0x1,(%ebx)
			printnum_width(putch, putdat, num / base, base, width - 1, padc, pamnt, pcount);//num/base is used to print the least significant digit
f0100fe6:	89 5c 24 18          	mov    %ebx,0x18(%esp)
f0100fea:	8b 55 1c             	mov    0x1c(%ebp),%edx
f0100fed:	89 54 24 14          	mov    %edx,0x14(%esp)
f0100ff1:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0100ff4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0100ff8:	8b 55 14             	mov    0x14(%ebp),%edx
f0100ffb:	83 ea 01             	sub    $0x1,%edx
f0100ffe:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0101002:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101006:	8b 44 24 08          	mov    0x8(%esp),%eax
f010100a:	8b 54 24 0c          	mov    0xc(%esp),%edx
f010100e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101011:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0101014:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101017:	89 54 24 08          	mov    %edx,0x8(%esp)
f010101b:	89 74 24 0c          	mov    %esi,0xc(%esp)
f010101f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0101022:	89 0c 24             	mov    %ecx,(%esp)
f0101025:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0101028:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010102c:	e8 af 0c 00 00       	call   f0101ce0 <__udivdi3>
f0101031:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0101034:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0101037:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010103b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010103f:	89 04 24             	mov    %eax,(%esp)
f0101042:	89 54 24 04          	mov    %edx,0x4(%esp)
f0101046:	89 fa                	mov    %edi,%edx
f0101048:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010104b:	e8 60 ff ff ff       	call   f0100fb0 <printnum_width>
		}
		putch("0123456789abcdef"[num % base], putdat);
f0101050:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101054:	8b 04 24             	mov    (%esp),%eax
f0101057:	8b 54 24 04          	mov    0x4(%esp),%edx
f010105b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010105e:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0101061:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101064:	89 54 24 08          	mov    %edx,0x8(%esp)
f0101068:	89 74 24 0c          	mov    %esi,0xc(%esp)
f010106c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f010106f:	89 0c 24             	mov    %ecx,(%esp)
f0101072:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0101075:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101079:	e8 92 0d 00 00       	call   f0101e10 <__umoddi3>
f010107e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0101081:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0101085:	0f be 80 69 25 10 f0 	movsbl -0xfefda97(%eax),%eax
f010108c:	89 04 24             	mov    %eax,(%esp)
f010108f:	ff 55 e4             	call   *-0x1c(%ebp)
		(*pamnt)++;//record the times of print operation
f0101092:	8b 4d 1c             	mov    0x1c(%ebp),%ecx
f0101095:	8b 01                	mov    (%ecx),%eax
f0101097:	83 c0 01             	add    $0x1,%eax
f010109a:	89 01                	mov    %eax,(%ecx)
		if( *pamnt == (*pcount + 1) ){
f010109c:	8b 5d 20             	mov    0x20(%ebp),%ebx
f010109f:	8b 13                	mov    (%ebx),%edx
f01010a1:	83 c2 01             	add    $0x1,%edx
f01010a4:	39 d0                	cmp    %edx,%eax
f01010a6:	75 2e                	jne    f01010d6 <printnum_width+0x126>
			if( width > *pamnt ){
f01010a8:	39 45 14             	cmp    %eax,0x14(%ebp)
f01010ab:	7e 29                	jle    f01010d6 <printnum_width+0x126>
				for( i = 0; i < width - *pamnt;  i++){
f01010ad:	8b 55 14             	mov    0x14(%ebp),%edx
f01010b0:	29 c2                	sub    %eax,%edx
f01010b2:	85 d2                	test   %edx,%edx
f01010b4:	7e 20                	jle    f01010d6 <printnum_width+0x126>
f01010b6:	be 00 00 00 00       	mov    $0x0,%esi
f01010bb:	89 cb                	mov    %ecx,%ebx
					putch(padc, putdat);
f01010bd:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01010c1:	8b 4d 18             	mov    0x18(%ebp),%ecx
f01010c4:	89 0c 24             	mov    %ecx,(%esp)
f01010c7:	ff 55 e4             	call   *-0x1c(%ebp)
		}
		putch("0123456789abcdef"[num % base], putdat);
		(*pamnt)++;//record the times of print operation
		if( *pamnt == (*pcount + 1) ){
			if( width > *pamnt ){
				for( i = 0; i < width - *pamnt;  i++){
f01010ca:	83 c6 01             	add    $0x1,%esi
f01010cd:	8b 45 14             	mov    0x14(%ebp),%eax
f01010d0:	2b 03                	sub    (%ebx),%eax
f01010d2:	39 f0                	cmp    %esi,%eax
f01010d4:	7f e7                	jg     f01010bd <printnum_width+0x10d>
					putch(padc, putdat);
				}	
			}
        	}
		return;
}
f01010d6:	83 c4 4c             	add    $0x4c,%esp
f01010d9:	5b                   	pop    %ebx
f01010da:	5e                   	pop    %esi
f01010db:	5f                   	pop    %edi
f01010dc:	5d                   	pop    %ebp
f01010dd:	c3                   	ret    

f01010de <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f01010de:	55                   	push   %ebp
f01010df:	89 e5                	mov    %esp,%ebp
f01010e1:	57                   	push   %edi
f01010e2:	56                   	push   %esi
f01010e3:	53                   	push   %ebx
f01010e4:	83 ec 5c             	sub    $0x5c,%esp
f01010e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01010ea:	89 d6                	mov    %edx,%esi
f01010ec:	8b 45 08             	mov    0x8(%ebp),%eax
f01010ef:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01010f2:	8b 55 0c             	mov    0xc(%ebp),%edx
f01010f5:	89 55 d0             	mov    %edx,-0x30(%ebp)
f01010f8:	8b 55 10             	mov    0x10(%ebp),%edx
f01010fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
f01010fe:	8b 7d 18             	mov    0x18(%ebp),%edi
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	int amnt = 0, count = 0; 
f0101101:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0101108:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	if( padc != '0'){
f010110f:	83 ff 30             	cmp    $0x30,%edi
f0101112:	74 42                	je     f0101156 <printnum+0x78>
		if( 9 > width && width > 0 ){
f0101114:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0101117:	83 f8 07             	cmp    $0x7,%eax
f010111a:	77 3a                	ja     f0101156 <printnum+0x78>
			padc = ' ';
			printnum_width(putch, putdat, num, base, width, padc, &amnt, &count);
f010111c:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010111f:	89 44 24 18          	mov    %eax,0x18(%esp)
f0101123:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101126:	89 44 24 14          	mov    %eax,0x14(%esp)
f010112a:	c7 44 24 10 20 00 00 	movl   $0x20,0x10(%esp)
f0101131:	00 
f0101132:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0101136:	89 54 24 08          	mov    %edx,0x8(%esp)
f010113a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010113d:	89 0c 24             	mov    %ecx,(%esp)
f0101140:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0101143:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101147:	89 f2                	mov    %esi,%edx
f0101149:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010114c:	e8 5f fe ff ff       	call   f0100fb0 <printnum_width>
			return;
f0101151:	e9 c8 00 00 00       	jmp    f010121e <printnum+0x140>
		}
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0101156:	89 55 c8             	mov    %edx,-0x38(%ebp)
f0101159:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f010115d:	77 15                	ja     f0101174 <printnum+0x96>
f010115f:	90                   	nop
f0101160:	72 05                	jb     f0101167 <printnum+0x89>
f0101162:	39 55 cc             	cmp    %edx,-0x34(%ebp)
f0101165:	73 0d                	jae    f0101174 <printnum+0x96>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
f0101167:	83 eb 01             	sub    $0x1,%ebx
f010116a:	85 db                	test   %ebx,%ebx
f010116c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101170:	7f 61                	jg     f01011d3 <printnum+0xf5>
f0101172:	eb 70                	jmp    f01011e4 <printnum+0x106>
			return;
		}
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0101174:	89 7c 24 10          	mov    %edi,0x10(%esp)
f0101178:	83 eb 01             	sub    $0x1,%ebx
f010117b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010117f:	89 54 24 08          	mov    %edx,0x8(%esp)
f0101183:	8b 44 24 08          	mov    0x8(%esp),%eax
f0101187:	8b 54 24 0c          	mov    0xc(%esp),%edx
f010118b:	89 45 c0             	mov    %eax,-0x40(%ebp)
f010118e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0101191:	8b 55 c8             	mov    -0x38(%ebp),%edx
f0101194:	89 54 24 08          	mov    %edx,0x8(%esp)
f0101198:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f010119f:	00 
f01011a0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f01011a3:	89 0c 24             	mov    %ecx,(%esp)
f01011a6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f01011a9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01011ad:	e8 2e 0b 00 00       	call   f0101ce0 <__udivdi3>
f01011b2:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f01011b5:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f01011b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01011bc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f01011c0:	89 04 24             	mov    %eax,(%esp)
f01011c3:	89 54 24 04          	mov    %edx,0x4(%esp)
f01011c7:	89 f2                	mov    %esi,%edx
f01011c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01011cc:	e8 0d ff ff ff       	call   f01010de <printnum>
f01011d1:	eb 11                	jmp    f01011e4 <printnum+0x106>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
			putch(padc, putdat);
f01011d3:	89 74 24 04          	mov    %esi,0x4(%esp)
f01011d7:	89 3c 24             	mov    %edi,(%esp)
f01011da:	ff 55 d4             	call   *-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
f01011dd:	83 eb 01             	sub    $0x1,%ebx
f01011e0:	85 db                	test   %ebx,%ebx
f01011e2:	7f ef                	jg     f01011d3 <printnum+0xf5>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit// highest digit
	putch("0123456789abcdef"[num % base], putdat);
f01011e4:	89 74 24 04          	mov    %esi,0x4(%esp)
f01011e8:	8b 74 24 04          	mov    0x4(%esp),%esi
f01011ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01011ef:	89 44 24 08          	mov    %eax,0x8(%esp)
f01011f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f01011fa:	00 
f01011fb:	8b 55 cc             	mov    -0x34(%ebp),%edx
f01011fe:	89 14 24             	mov    %edx,(%esp)
f0101201:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0101204:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0101208:	e8 03 0c 00 00       	call   f0101e10 <__umoddi3>
f010120d:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101211:	0f be 80 69 25 10 f0 	movsbl -0xfefda97(%eax),%eax
f0101218:	89 04 24             	mov    %eax,(%esp)
f010121b:	ff 55 d4             	call   *-0x2c(%ebp)
}
f010121e:	83 c4 5c             	add    $0x5c,%esp
f0101221:	5b                   	pop    %ebx
f0101222:	5e                   	pop    %esi
f0101223:	5f                   	pop    %edi
f0101224:	5d                   	pop    %ebp
f0101225:	c3                   	ret    

f0101226 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f0101226:	55                   	push   %ebp
f0101227:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0101229:	83 fa 01             	cmp    $0x1,%edx
f010122c:	7e 0e                	jle    f010123c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
f010122e:	8b 10                	mov    (%eax),%edx
f0101230:	8d 4a 08             	lea    0x8(%edx),%ecx
f0101233:	89 08                	mov    %ecx,(%eax)
f0101235:	8b 02                	mov    (%edx),%eax
f0101237:	8b 52 04             	mov    0x4(%edx),%edx
f010123a:	eb 22                	jmp    f010125e <getuint+0x38>
	else if (lflag)
f010123c:	85 d2                	test   %edx,%edx
f010123e:	74 10                	je     f0101250 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
f0101240:	8b 10                	mov    (%eax),%edx
f0101242:	8d 4a 04             	lea    0x4(%edx),%ecx
f0101245:	89 08                	mov    %ecx,(%eax)
f0101247:	8b 02                	mov    (%edx),%eax
f0101249:	ba 00 00 00 00       	mov    $0x0,%edx
f010124e:	eb 0e                	jmp    f010125e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
f0101250:	8b 10                	mov    (%eax),%edx
f0101252:	8d 4a 04             	lea    0x4(%edx),%ecx
f0101255:	89 08                	mov    %ecx,(%eax)
f0101257:	8b 02                	mov    (%edx),%eax
f0101259:	ba 00 00 00 00       	mov    $0x0,%edx
}
f010125e:	5d                   	pop    %ebp
f010125f:	c3                   	ret    

f0101260 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
f0101260:	55                   	push   %ebp
f0101261:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0101263:	83 fa 01             	cmp    $0x1,%edx
f0101266:	7e 0e                	jle    f0101276 <getint+0x16>
		return va_arg(*ap, long long);
f0101268:	8b 10                	mov    (%eax),%edx
f010126a:	8d 4a 08             	lea    0x8(%edx),%ecx
f010126d:	89 08                	mov    %ecx,(%eax)
f010126f:	8b 02                	mov    (%edx),%eax
f0101271:	8b 52 04             	mov    0x4(%edx),%edx
f0101274:	eb 22                	jmp    f0101298 <getint+0x38>
	else if (lflag)
f0101276:	85 d2                	test   %edx,%edx
f0101278:	74 10                	je     f010128a <getint+0x2a>
		return va_arg(*ap, long);
f010127a:	8b 10                	mov    (%eax),%edx
f010127c:	8d 4a 04             	lea    0x4(%edx),%ecx
f010127f:	89 08                	mov    %ecx,(%eax)
f0101281:	8b 02                	mov    (%edx),%eax
f0101283:	89 c2                	mov    %eax,%edx
f0101285:	c1 fa 1f             	sar    $0x1f,%edx
f0101288:	eb 0e                	jmp    f0101298 <getint+0x38>
	else
		return va_arg(*ap, int);
f010128a:	8b 10                	mov    (%eax),%edx
f010128c:	8d 4a 04             	lea    0x4(%edx),%ecx
f010128f:	89 08                	mov    %ecx,(%eax)
f0101291:	8b 02                	mov    (%edx),%eax
f0101293:	89 c2                	mov    %eax,%edx
f0101295:	c1 fa 1f             	sar    $0x1f,%edx
}
f0101298:	5d                   	pop    %ebp
f0101299:	c3                   	ret    

f010129a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f010129a:	55                   	push   %ebp
f010129b:	89 e5                	mov    %esp,%ebp
f010129d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f01012a0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f01012a4:	8b 10                	mov    (%eax),%edx
f01012a6:	3b 50 04             	cmp    0x4(%eax),%edx
f01012a9:	73 0a                	jae    f01012b5 <sprintputch+0x1b>
		*b->buf++ = ch;
f01012ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01012ae:	88 0a                	mov    %cl,(%edx)
f01012b0:	83 c2 01             	add    $0x1,%edx
f01012b3:	89 10                	mov    %edx,(%eax)
}
f01012b5:	5d                   	pop    %ebp
f01012b6:	c3                   	ret    

f01012b7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f01012b7:	55                   	push   %ebp
f01012b8:	89 e5                	mov    %esp,%ebp
f01012ba:	57                   	push   %edi
f01012bb:	56                   	push   %esi
f01012bc:	53                   	push   %ebx
f01012bd:	83 ec 5c             	sub    $0x5c,%esp
f01012c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01012c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
f01012c6:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
f01012cd:	eb 17                	jmp    f01012e6 <vprintfmt+0x2f>
	int base, lflag, width, precision, altflag;
	char padc;
	//putdata: the total amount of characters having been printed now
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f01012cf:	85 c0                	test   %eax,%eax
f01012d1:	0f 84 5e 04 00 00    	je     f0101735 <vprintfmt+0x47e>
				return;
			putch(ch, putdat);
f01012d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01012db:	89 04 24             	mov    %eax,(%esp)
f01012de:	ff 55 08             	call   *0x8(%ebp)
f01012e1:	eb 03                	jmp    f01012e6 <vprintfmt+0x2f>
f01012e3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	//putdata: the total amount of characters having been printed now
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01012e6:	0f b6 03             	movzbl (%ebx),%eax
f01012e9:	83 c3 01             	add    $0x1,%ebx
f01012ec:	83 f8 25             	cmp    $0x25,%eax
f01012ef:	75 de                	jne    f01012cf <vprintfmt+0x18>
f01012f1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f01012f8:	c6 45 d0 20          	movb   $0x20,-0x30(%ebp)
f01012fc:	be ff ff ff ff       	mov    $0xffffffff,%esi
f0101301:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
f0101308:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010130f:	eb 06                	jmp    f0101317 <vprintfmt+0x60>
f0101311:	c6 45 d0 2d          	movb   $0x2d,-0x30(%ebp)
f0101315:	89 cb                	mov    %ecx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0101317:	0f b6 03             	movzbl (%ebx),%eax
f010131a:	0f b6 d0             	movzbl %al,%edx
f010131d:	8d 4b 01             	lea    0x1(%ebx),%ecx
f0101320:	83 e8 23             	sub    $0x23,%eax
f0101323:	3c 55                	cmp    $0x55,%al
f0101325:	0f 87 ec 03 00 00    	ja     f0101717 <vprintfmt+0x460>
f010132b:	0f b6 c0             	movzbl %al,%eax
f010132e:	ff 24 85 74 26 10 f0 	jmp    *-0xfefd98c(,%eax,4)
f0101335:	c6 45 d0 30          	movb   $0x30,-0x30(%ebp)
f0101339:	eb da                	jmp    f0101315 <vprintfmt+0x5e>
		case '8':
			width = 8;
			goto reswitch;
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f010133b:	8d 72 d0             	lea    -0x30(%edx),%esi
				ch = *fmt;
f010133e:	0f be 01             	movsbl (%ecx),%eax
				if (ch < '0' || ch > '9')
f0101341:	8d 50 d0             	lea    -0x30(%eax),%edx
f0101344:	83 fa 09             	cmp    $0x9,%edx
f0101347:	76 0b                	jbe    f0101354 <vprintfmt+0x9d>
f0101349:	eb 43                	jmp    f010138e <vprintfmt+0xd7>
f010134b:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%ebp)
		case '5':
		case '6':
		case '7':
		case '8':
			width = 8;
			goto reswitch;
f0101352:	eb c1                	jmp    f0101315 <vprintfmt+0x5e>
		case '9':
			for (precision = 0; ; ++fmt) {
f0101354:	83 c1 01             	add    $0x1,%ecx
				precision = precision * 10 + ch - '0';
f0101357:	8d 14 b6             	lea    (%esi,%esi,4),%edx
f010135a:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
f010135e:	0f be 01             	movsbl (%ecx),%eax
				if (ch < '0' || ch > '9')
f0101361:	8d 50 d0             	lea    -0x30(%eax),%edx
f0101364:	83 fa 09             	cmp    $0x9,%edx
f0101367:	76 eb                	jbe    f0101354 <vprintfmt+0x9d>
f0101369:	eb 23                	jmp    f010138e <vprintfmt+0xd7>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f010136b:	8b 45 14             	mov    0x14(%ebp),%eax
f010136e:	8d 50 04             	lea    0x4(%eax),%edx
f0101371:	89 55 14             	mov    %edx,0x14(%ebp)
f0101374:	8b 30                	mov    (%eax),%esi
			goto process_precision;
f0101376:	eb 16                	jmp    f010138e <vprintfmt+0xd7>

		case '.':
			if (width < 0)
f0101378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010137b:	c1 f8 1f             	sar    $0x1f,%eax
f010137e:	f7 d0                	not    %eax
f0101380:	21 45 e4             	and    %eax,-0x1c(%ebp)
f0101383:	eb 90                	jmp    f0101315 <vprintfmt+0x5e>
f0101385:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
f010138c:	eb 87                	jmp    f0101315 <vprintfmt+0x5e>

		process_precision:
			if (width < 0)
f010138e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0101392:	79 81                	jns    f0101315 <vprintfmt+0x5e>
f0101394:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f0101397:	8b 75 c8             	mov    -0x38(%ebp),%esi
f010139a:	e9 76 ff ff ff       	jmp    f0101315 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f010139f:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
f01013a3:	e9 6d ff ff ff       	jmp    f0101315 <vprintfmt+0x5e>
f01013a8:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f01013ab:	8b 45 14             	mov    0x14(%ebp),%eax
f01013ae:	8d 50 04             	lea    0x4(%eax),%edx
f01013b1:	89 55 14             	mov    %edx,0x14(%ebp)
f01013b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01013b8:	8b 00                	mov    (%eax),%eax
f01013ba:	89 04 24             	mov    %eax,(%esp)
f01013bd:	ff 55 08             	call   *0x8(%ebp)
f01013c0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f01013c3:	e9 1e ff ff ff       	jmp    f01012e6 <vprintfmt+0x2f>
f01013c8:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
f01013cb:	8b 45 14             	mov    0x14(%ebp),%eax
f01013ce:	8d 50 04             	lea    0x4(%eax),%edx
f01013d1:	89 55 14             	mov    %edx,0x14(%ebp)
f01013d4:	8b 00                	mov    (%eax),%eax
f01013d6:	89 c2                	mov    %eax,%edx
f01013d8:	c1 fa 1f             	sar    $0x1f,%edx
f01013db:	31 d0                	xor    %edx,%eax
f01013dd:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01013df:	83 f8 06             	cmp    $0x6,%eax
f01013e2:	7f 0b                	jg     f01013ef <vprintfmt+0x138>
f01013e4:	8b 14 85 cc 27 10 f0 	mov    -0xfefd834(,%eax,4),%edx
f01013eb:	85 d2                	test   %edx,%edx
f01013ed:	75 23                	jne    f0101412 <vprintfmt+0x15b>
				printfmt(putch, putdat, "error %d", err);
f01013ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01013f3:	c7 44 24 08 7a 25 10 	movl   $0xf010257a,0x8(%esp)
f01013fa:	f0 
f01013fb:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01013ff:	8b 45 08             	mov    0x8(%ebp),%eax
f0101402:	89 04 24             	mov    %eax,(%esp)
f0101405:	e8 b3 03 00 00       	call   f01017bd <printfmt>
f010140a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f010140d:	e9 d4 fe ff ff       	jmp    f01012e6 <vprintfmt+0x2f>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
f0101412:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0101416:	c7 44 24 08 83 25 10 	movl   $0xf0102583,0x8(%esp)
f010141d:	f0 
f010141e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101422:	8b 55 08             	mov    0x8(%ebp),%edx
f0101425:	89 14 24             	mov    %edx,(%esp)
f0101428:	e8 90 03 00 00       	call   f01017bd <printfmt>
f010142d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0101430:	e9 b1 fe ff ff       	jmp    f01012e6 <vprintfmt+0x2f>
f0101435:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f0101438:	89 cb                	mov    %ecx,%ebx
f010143a:	89 f1                	mov    %esi,%ecx
f010143c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010143f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0101442:	8b 45 14             	mov    0x14(%ebp),%eax
f0101445:	8d 50 04             	lea    0x4(%eax),%edx
f0101448:	89 55 14             	mov    %edx,0x14(%ebp)
f010144b:	8b 00                	mov    (%eax),%eax
f010144d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101450:	85 c0                	test   %eax,%eax
f0101452:	75 07                	jne    f010145b <vprintfmt+0x1a4>
f0101454:	c7 45 d4 86 25 10 f0 	movl   $0xf0102586,-0x2c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
f010145b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f010145f:	7e 06                	jle    f0101467 <vprintfmt+0x1b0>
f0101461:	80 7d d0 2d          	cmpb   $0x2d,-0x30(%ebp)
f0101465:	75 13                	jne    f010147a <vprintfmt+0x1c3>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0101467:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010146a:	0f be 02             	movsbl (%edx),%eax
f010146d:	85 c0                	test   %eax,%eax
f010146f:	0f 85 95 00 00 00    	jne    f010150a <vprintfmt+0x253>
f0101475:	e9 85 00 00 00       	jmp    f01014ff <vprintfmt+0x248>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f010147a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f010147e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101481:	89 04 24             	mov    %eax,(%esp)
f0101484:	e8 62 04 00 00       	call   f01018eb <strnlen>
f0101489:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f010148c:	29 c2                	sub    %eax,%edx
f010148e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101491:	85 d2                	test   %edx,%edx
f0101493:	7e d2                	jle    f0101467 <vprintfmt+0x1b0>
					putch(padc, putdat);
f0101495:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
f0101499:	89 75 c4             	mov    %esi,-0x3c(%ebp)
f010149c:	89 5d c0             	mov    %ebx,-0x40(%ebp)
f010149f:	89 d3                	mov    %edx,%ebx
f01014a1:	89 c6                	mov    %eax,%esi
f01014a3:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01014a7:	89 34 24             	mov    %esi,(%esp)
f01014aa:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f01014ad:	83 eb 01             	sub    $0x1,%ebx
f01014b0:	85 db                	test   %ebx,%ebx
f01014b2:	7f ef                	jg     f01014a3 <vprintfmt+0x1ec>
f01014b4:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f01014b7:	8b 5d c0             	mov    -0x40(%ebp),%ebx
f01014ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f01014c1:	eb a4                	jmp    f0101467 <vprintfmt+0x1b0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f01014c3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f01014c7:	74 19                	je     f01014e2 <vprintfmt+0x22b>
f01014c9:	8d 50 e0             	lea    -0x20(%eax),%edx
f01014cc:	83 fa 5e             	cmp    $0x5e,%edx
f01014cf:	76 11                	jbe    f01014e2 <vprintfmt+0x22b>
					putch('?', putdat);
f01014d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01014d5:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f01014dc:	ff 55 08             	call   *0x8(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f01014df:	90                   	nop
f01014e0:	eb 0a                	jmp    f01014ec <vprintfmt+0x235>
					putch('?', putdat);
				else
					putch(ch, putdat);
f01014e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01014e6:	89 04 24             	mov    %eax,(%esp)
f01014e9:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f01014ec:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
f01014f0:	0f be 03             	movsbl (%ebx),%eax
f01014f3:	85 c0                	test   %eax,%eax
f01014f5:	74 05                	je     f01014fc <vprintfmt+0x245>
f01014f7:	83 c3 01             	add    $0x1,%ebx
f01014fa:	eb 19                	jmp    f0101515 <vprintfmt+0x25e>
f01014fc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f01014ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0101503:	7f 1e                	jg     f0101523 <vprintfmt+0x26c>
f0101505:	e9 d9 fd ff ff       	jmp    f01012e3 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010150a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010150d:	83 c2 01             	add    $0x1,%edx
f0101510:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
f0101513:	89 d3                	mov    %edx,%ebx
f0101515:	85 f6                	test   %esi,%esi
f0101517:	78 aa                	js     f01014c3 <vprintfmt+0x20c>
f0101519:	83 ee 01             	sub    $0x1,%esi
f010151c:	79 a5                	jns    f01014c3 <vprintfmt+0x20c>
f010151e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101521:	eb dc                	jmp    f01014ff <vprintfmt+0x248>
f0101523:	8b 75 08             	mov    0x8(%ebp),%esi
f0101526:	89 5d d8             	mov    %ebx,-0x28(%ebp)
f0101529:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f010152c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101530:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0101537:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0101539:	83 eb 01             	sub    $0x1,%ebx
f010153c:	85 db                	test   %ebx,%ebx
f010153e:	7f ec                	jg     f010152c <vprintfmt+0x275>
f0101540:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f0101543:	e9 9e fd ff ff       	jmp    f01012e6 <vprintfmt+0x2f>
f0101548:	89 4d cc             	mov    %ecx,-0x34(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);//different data type
f010154b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010154e:	8d 45 14             	lea    0x14(%ebp),%eax
f0101551:	e8 0a fd ff ff       	call   f0101260 <getint>
f0101556:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101559:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010155c:	89 c3                	mov    %eax,%ebx
f010155e:	89 d6                	mov    %edx,%esi
f0101560:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
f0101565:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0101569:	0f 89 b2 00 00 00    	jns    f0101621 <vprintfmt+0x36a>
				putch('-', putdat);
f010156f:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101573:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f010157a:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f010157d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f0101580:	8b 75 dc             	mov    -0x24(%ebp),%esi
f0101583:	f7 db                	neg    %ebx
f0101585:	83 d6 00             	adc    $0x0,%esi
f0101588:	f7 de                	neg    %esi
f010158a:	ba 0a 00 00 00       	mov    $0xa,%edx
f010158f:	e9 8d 00 00 00       	jmp    f0101621 <vprintfmt+0x36a>
f0101594:	89 4d cc             	mov    %ecx,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f0101597:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010159a:	8d 45 14             	lea    0x14(%ebp),%eax
f010159d:	e8 84 fc ff ff       	call   f0101226 <getuint>
f01015a2:	89 c3                	mov    %eax,%ebx
f01015a4:	89 d6                	mov    %edx,%esi
f01015a6:	ba 0a 00 00 00       	mov    $0xa,%edx
			base = 10;
			goto number;
f01015ab:	eb 74                	jmp    f0101621 <vprintfmt+0x36a>
f01015ad:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			// display a number in octal form and the form should begin with '0'
			putch('0', putdat);
f01015b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01015b4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f01015bb:	ff 55 08             	call   *0x8(%ebp)
			num = getuint(&ap, lflag);
f01015be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01015c1:	8d 45 14             	lea    0x14(%ebp),%eax
f01015c4:	e8 5d fc ff ff       	call   f0101226 <getuint>
f01015c9:	89 c3                	mov    %eax,%ebx
f01015cb:	89 d6                	mov    %edx,%esi
f01015cd:	ba 08 00 00 00       	mov    $0x8,%edx
			base = 8;
			goto number;
f01015d2:	eb 4d                	jmp    f0101621 <vprintfmt+0x36a>
f01015d4:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
f01015d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01015db:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f01015e2:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f01015e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01015e9:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f01015f0:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
f01015f3:	8b 45 14             	mov    0x14(%ebp),%eax
f01015f6:	8d 50 04             	lea    0x4(%eax),%edx
f01015f9:	89 55 14             	mov    %edx,0x14(%ebp)
f01015fc:	8b 18                	mov    (%eax),%ebx
f01015fe:	be 00 00 00 00       	mov    $0x0,%esi
f0101603:	ba 10 00 00 00       	mov    $0x10,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
f0101608:	eb 17                	jmp    f0101621 <vprintfmt+0x36a>
f010160a:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':

			num = getuint(&ap, lflag);
f010160d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101610:	8d 45 14             	lea    0x14(%ebp),%eax
f0101613:	e8 0e fc ff ff       	call   f0101226 <getuint>
f0101618:	89 c3                	mov    %eax,%ebx
f010161a:	89 d6                	mov    %edx,%esi
f010161c:	ba 10 00 00 00       	mov    $0x10,%edx
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
f0101621:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
f0101625:	89 44 24 10          	mov    %eax,0x10(%esp)
f0101629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010162c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101630:	89 54 24 08          	mov    %edx,0x8(%esp)
f0101634:	89 1c 24             	mov    %ebx,(%esp)
f0101637:	89 74 24 04          	mov    %esi,0x4(%esp)
f010163b:	89 fa                	mov    %edi,%edx
f010163d:	8b 45 08             	mov    0x8(%ebp),%eax
f0101640:	e8 99 fa ff ff       	call   f01010de <printnum>
f0101645:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f0101648:	e9 99 fc ff ff       	jmp    f01012e6 <vprintfmt+0x2f>
f010164d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
            //        can represent.

            const char *null_error = "\nerror! writing through NULL pointer! (%n argument)\n";
            const char *overflow_error = "\nwarning! The value %n argument pointed to has been overflowed!\n";
            // Your code here
	    q = va_arg(ap, char *);//after call va_arg(), it will point to next argument
f0101650:	8b 45 14             	mov    0x14(%ebp),%eax
f0101653:	8d 50 04             	lea    0x4(%eax),%edx
f0101656:	89 55 14             	mov    %edx,0x14(%ebp)
f0101659:	8b 30                	mov    (%eax),%esi
	    if ( q == NULL ){
f010165b:	85 f6                	test   %esi,%esi
f010165d:	75 21                	jne    f0101680 <vprintfmt+0x3c9>
f010165f:	bb f9 25 10 f0       	mov    $0xf01025f9,%ebx
f0101664:	b8 0a 00 00 00       	mov    $0xa,%eax
		while ((ch = *null_error++) != '\0') {
                        cputchar(ch);
f0101669:	89 04 24             	mov    %eax,(%esp)
f010166c:	e8 19 ef ff ff       	call   f010058a <cputchar>
            const char *null_error = "\nerror! writing through NULL pointer! (%n argument)\n";
            const char *overflow_error = "\nwarning! The value %n argument pointed to has been overflowed!\n";
            // Your code here
	    q = va_arg(ap, char *);//after call va_arg(), it will point to next argument
	    if ( q == NULL ){
		while ((ch = *null_error++) != '\0') {
f0101671:	0f be 03             	movsbl (%ebx),%eax
f0101674:	83 c3 01             	add    $0x1,%ebx
f0101677:	85 c0                	test   %eax,%eax
f0101679:	75 ee                	jne    f0101669 <vprintfmt+0x3b2>
f010167b:	e9 63 fc ff ff       	jmp    f01012e3 <vprintfmt+0x2c>
                        cputchar(ch);
                }
	    	break;
	    }
	    if ( *(unsigned char *)putdat >= 255 ){//why did it can't be 255?  
f0101680:	80 3f ff             	cmpb   $0xff,(%edi)
f0101683:	75 27                	jne    f01016ac <vprintfmt+0x3f5>
f0101685:	bb 31 26 10 f0       	mov    $0xf0102631,%ebx
f010168a:	b8 0a 00 00 00       	mov    $0xa,%eax
		while ((ch = *(char *) overflow_error++) != '\0') {
                        cputchar(ch);
f010168f:	89 04 24             	mov    %eax,(%esp)
f0101692:	e8 f3 ee ff ff       	call   f010058a <cputchar>
                        cputchar(ch);
                }
	    	break;
	    }
	    if ( *(unsigned char *)putdat >= 255 ){//why did it can't be 255?  
		while ((ch = *(char *) overflow_error++) != '\0') {
f0101697:	0f be 03             	movsbl (%ebx),%eax
f010169a:	83 c3 01             	add    $0x1,%ebx
f010169d:	85 c0                	test   %eax,%eax
f010169f:	75 ee                	jne    f010168f <vprintfmt+0x3d8>
                        cputchar(ch);
                }
		*q = -1;
f01016a1:	c6 06 ff             	movb   $0xff,(%esi)
f01016a4:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		break;
f01016a7:	e9 3a fc ff ff       	jmp    f01012e6 <vprintfmt+0x2f>
	    }
 	    *q = *(char *)putdat;
f01016ac:	0f b6 07             	movzbl (%edi),%eax
f01016af:	88 06                	mov    %al,(%esi)
f01016b1:	8b 5d cc             	mov    -0x34(%ebp),%ebx
            break;
f01016b4:	e9 2d fc ff ff       	jmp    f01012e6 <vprintfmt+0x2f>
f01016b9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
        }
		// escaped '%' character
		case '%':
			putch(ch, putdat);
f01016bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01016c0:	89 14 24             	mov    %edx,(%esp)
f01016c3:	ff 55 08             	call   *0x8(%ebp)
f01016c6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f01016c9:	e9 18 fc ff ff       	jmp    f01012e6 <vprintfmt+0x2f>
f01016ce:	89 4d cc             	mov    %ecx,-0x34(%ebp)
			
		// unrecognized escape sequence - just print it literally
		//precede the result with a plus or minus sign (+ or -) even for positive numbers-added by tww
		case '+':
			num = getint(&ap, lflag);//after call getint(),the argument will go to next
f01016d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01016d4:	8d 45 14             	lea    0x14(%ebp),%eax
f01016d7:	e8 84 fb ff ff       	call   f0101260 <getint>
f01016dc:	89 c3                	mov    %eax,%ebx
f01016de:	89 d6                	mov    %edx,%esi
		        if ((long long) num < 0) {
f01016e0:	85 d2                	test   %edx,%edx
f01016e2:	79 17                	jns    f01016fb <vprintfmt+0x444>
				putch('-', putdat);
f01016e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01016e8:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f01016ef:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f01016f2:	f7 db                	neg    %ebx
f01016f4:	83 d6 00             	adc    $0x0,%esi
f01016f7:	f7 de                	neg    %esi
f01016f9:	eb 0e                	jmp    f0101709 <vprintfmt+0x452>
			}
			else{
				putch('+', putdat);
f01016fb:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01016ff:	c7 04 24 2b 00 00 00 	movl   $0x2b,(%esp)
f0101706:	ff 55 08             	call   *0x8(%ebp)
			}
			base = 10;
			fmt++;
f0101709:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
f010170d:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
f0101712:	e9 0a ff ff ff       	jmp    f0101621 <vprintfmt+0x36a>
		default:
			putch('%', putdat);
f0101717:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010171b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0101722:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f0101725:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0101728:	80 38 25             	cmpb   $0x25,(%eax)
f010172b:	0f 84 b5 fb ff ff    	je     f01012e6 <vprintfmt+0x2f>
f0101731:	89 c3                	mov    %eax,%ebx
f0101733:	eb f0                	jmp    f0101725 <vprintfmt+0x46e>
				/* do nothing */;
			break;
		}
	}
}
f0101735:	83 c4 5c             	add    $0x5c,%esp
f0101738:	5b                   	pop    %ebx
f0101739:	5e                   	pop    %esi
f010173a:	5f                   	pop    %edi
f010173b:	5d                   	pop    %ebp
f010173c:	c3                   	ret    

f010173d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f010173d:	55                   	push   %ebp
f010173e:	89 e5                	mov    %esp,%ebp
f0101740:	83 ec 28             	sub    $0x28,%esp
f0101743:	8b 45 08             	mov    0x8(%ebp),%eax
f0101746:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
f0101749:	85 c0                	test   %eax,%eax
f010174b:	74 04                	je     f0101751 <vsnprintf+0x14>
f010174d:	85 d2                	test   %edx,%edx
f010174f:	7f 07                	jg     f0101758 <vsnprintf+0x1b>
f0101751:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0101756:	eb 3b                	jmp    f0101793 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
f0101758:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010175b:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
f010175f:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0101762:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0101769:	8b 45 14             	mov    0x14(%ebp),%eax
f010176c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101770:	8b 45 10             	mov    0x10(%ebp),%eax
f0101773:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101777:	8d 45 ec             	lea    -0x14(%ebp),%eax
f010177a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010177e:	c7 04 24 9a 12 10 f0 	movl   $0xf010129a,(%esp)
f0101785:	e8 2d fb ff ff       	call   f01012b7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f010178a:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010178d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0101790:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f0101793:	c9                   	leave  
f0101794:	c3                   	ret    

f0101795 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0101795:	55                   	push   %ebp
f0101796:	89 e5                	mov    %esp,%ebp
f0101798:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
f010179b:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
f010179e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01017a2:	8b 45 10             	mov    0x10(%ebp),%eax
f01017a5:	89 44 24 08          	mov    %eax,0x8(%esp)
f01017a9:	8b 45 0c             	mov    0xc(%ebp),%eax
f01017ac:	89 44 24 04          	mov    %eax,0x4(%esp)
f01017b0:	8b 45 08             	mov    0x8(%ebp),%eax
f01017b3:	89 04 24             	mov    %eax,(%esp)
f01017b6:	e8 82 ff ff ff       	call   f010173d <vsnprintf>
	va_end(ap);

	return rc;
}
f01017bb:	c9                   	leave  
f01017bc:	c3                   	ret    

f01017bd <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...)
{
f01017bd:	55                   	push   %ebp
f01017be:	89 e5                	mov    %esp,%ebp
f01017c0:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...)
f01017c3:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
f01017c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01017ca:	8b 45 10             	mov    0x10(%ebp),%eax
f01017cd:	89 44 24 08          	mov    %eax,0x8(%esp)
f01017d1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01017d4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01017d8:	8b 45 08             	mov    0x8(%ebp),%eax
f01017db:	89 04 24             	mov    %eax,(%esp)
f01017de:	e8 d4 fa ff ff       	call   f01012b7 <vprintfmt>
	va_end(ap);
}
f01017e3:	c9                   	leave  
f01017e4:	c3                   	ret    
	...

f01017f0 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f01017f0:	55                   	push   %ebp
f01017f1:	89 e5                	mov    %esp,%ebp
f01017f3:	57                   	push   %edi
f01017f4:	56                   	push   %esi
f01017f5:	53                   	push   %ebx
f01017f6:	83 ec 1c             	sub    $0x1c,%esp
f01017f9:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f01017fc:	85 c0                	test   %eax,%eax
f01017fe:	74 10                	je     f0101810 <readline+0x20>
		cprintf("%s", prompt);
f0101800:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101804:	c7 04 24 83 25 10 f0 	movl   $0xf0102583,(%esp)
f010180b:	e8 eb f3 ff ff       	call   f0100bfb <cprintf>

	i = 0;
	echoing = iscons(0);
f0101810:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101817:	e8 6a eb ff ff       	call   f0100386 <iscons>
f010181c:	89 c7                	mov    %eax,%edi
f010181e:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
f0101823:	e8 4d eb ff ff       	call   f0100375 <getchar>
f0101828:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f010182a:	85 c0                	test   %eax,%eax
f010182c:	79 17                	jns    f0101845 <readline+0x55>
			cprintf("read error: %e\n", c);
f010182e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101832:	c7 04 24 e8 27 10 f0 	movl   $0xf01027e8,(%esp)
f0101839:	e8 bd f3 ff ff       	call   f0100bfb <cprintf>
f010183e:	b8 00 00 00 00       	mov    $0x0,%eax
			return NULL;
f0101843:	eb 76                	jmp    f01018bb <readline+0xcb>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0101845:	83 f8 08             	cmp    $0x8,%eax
f0101848:	74 08                	je     f0101852 <readline+0x62>
f010184a:	83 f8 7f             	cmp    $0x7f,%eax
f010184d:	8d 76 00             	lea    0x0(%esi),%esi
f0101850:	75 19                	jne    f010186b <readline+0x7b>
f0101852:	85 f6                	test   %esi,%esi
f0101854:	7e 15                	jle    f010186b <readline+0x7b>
			if (echoing)
f0101856:	85 ff                	test   %edi,%edi
f0101858:	74 0c                	je     f0101866 <readline+0x76>
				cputchar('\b');
f010185a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f0101861:	e8 24 ed ff ff       	call   f010058a <cputchar>
			i--;
f0101866:	83 ee 01             	sub    $0x1,%esi
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0101869:	eb b8                	jmp    f0101823 <readline+0x33>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
f010186b:	83 fb 1f             	cmp    $0x1f,%ebx
f010186e:	66 90                	xchg   %ax,%ax
f0101870:	7e 23                	jle    f0101895 <readline+0xa5>
f0101872:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0101878:	7f 1b                	jg     f0101895 <readline+0xa5>
			if (echoing)
f010187a:	85 ff                	test   %edi,%edi
f010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101880:	74 08                	je     f010188a <readline+0x9a>
				cputchar(c);
f0101882:	89 1c 24             	mov    %ebx,(%esp)
f0101885:	e8 00 ed ff ff       	call   f010058a <cputchar>
			buf[i++] = c;
f010188a:	88 9e 60 35 11 f0    	mov    %bl,-0xfeecaa0(%esi)
f0101890:	83 c6 01             	add    $0x1,%esi
f0101893:	eb 8e                	jmp    f0101823 <readline+0x33>
		} else if (c == '\n' || c == '\r') {
f0101895:	83 fb 0a             	cmp    $0xa,%ebx
f0101898:	74 05                	je     f010189f <readline+0xaf>
f010189a:	83 fb 0d             	cmp    $0xd,%ebx
f010189d:	75 84                	jne    f0101823 <readline+0x33>
			if (echoing)
f010189f:	85 ff                	test   %edi,%edi
f01018a1:	74 0c                	je     f01018af <readline+0xbf>
				cputchar('\n');
f01018a3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f01018aa:	e8 db ec ff ff       	call   f010058a <cputchar>
			buf[i] = 0;
f01018af:	c6 86 60 35 11 f0 00 	movb   $0x0,-0xfeecaa0(%esi)
f01018b6:	b8 60 35 11 f0       	mov    $0xf0113560,%eax
			return buf;
		}
	}
}
f01018bb:	83 c4 1c             	add    $0x1c,%esp
f01018be:	5b                   	pop    %ebx
f01018bf:	5e                   	pop    %esi
f01018c0:	5f                   	pop    %edi
f01018c1:	5d                   	pop    %ebp
f01018c2:	c3                   	ret    
	...

f01018d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f01018d0:	55                   	push   %ebp
f01018d1:	89 e5                	mov    %esp,%ebp
f01018d3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f01018d6:	b8 00 00 00 00       	mov    $0x0,%eax
f01018db:	80 3a 00             	cmpb   $0x0,(%edx)
f01018de:	74 09                	je     f01018e9 <strlen+0x19>
		n++;
f01018e0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f01018e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f01018e7:	75 f7                	jne    f01018e0 <strlen+0x10>
		n++;
	return n;
}
f01018e9:	5d                   	pop    %ebp
f01018ea:	c3                   	ret    

f01018eb <strnlen>:

int
strnlen(const char *s, size_t size)
{
f01018eb:	55                   	push   %ebp
f01018ec:	89 e5                	mov    %esp,%ebp
f01018ee:	53                   	push   %ebx
f01018ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01018f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01018f5:	85 c9                	test   %ecx,%ecx
f01018f7:	74 19                	je     f0101912 <strnlen+0x27>
f01018f9:	80 3b 00             	cmpb   $0x0,(%ebx)
f01018fc:	74 14                	je     f0101912 <strnlen+0x27>
f01018fe:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
f0101903:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0101906:	39 c8                	cmp    %ecx,%eax
f0101908:	74 0d                	je     f0101917 <strnlen+0x2c>
f010190a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
f010190e:	75 f3                	jne    f0101903 <strnlen+0x18>
f0101910:	eb 05                	jmp    f0101917 <strnlen+0x2c>
f0101912:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
f0101917:	5b                   	pop    %ebx
f0101918:	5d                   	pop    %ebp
f0101919:	c3                   	ret    

f010191a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010191a:	55                   	push   %ebp
f010191b:	89 e5                	mov    %esp,%ebp
f010191d:	53                   	push   %ebx
f010191e:	8b 45 08             	mov    0x8(%ebp),%eax
f0101921:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101924:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0101929:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f010192d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0101930:	83 c2 01             	add    $0x1,%edx
f0101933:	84 c9                	test   %cl,%cl
f0101935:	75 f2                	jne    f0101929 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0101937:	5b                   	pop    %ebx
f0101938:	5d                   	pop    %ebp
f0101939:	c3                   	ret    

f010193a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f010193a:	55                   	push   %ebp
f010193b:	89 e5                	mov    %esp,%ebp
f010193d:	56                   	push   %esi
f010193e:	53                   	push   %ebx
f010193f:	8b 45 08             	mov    0x8(%ebp),%eax
f0101942:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101945:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0101948:	85 f6                	test   %esi,%esi
f010194a:	74 18                	je     f0101964 <strncpy+0x2a>
f010194c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
f0101951:	0f b6 1a             	movzbl (%edx),%ebx
f0101954:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0101957:	80 3a 01             	cmpb   $0x1,(%edx)
f010195a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f010195d:	83 c1 01             	add    $0x1,%ecx
f0101960:	39 ce                	cmp    %ecx,%esi
f0101962:	77 ed                	ja     f0101951 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f0101964:	5b                   	pop    %ebx
f0101965:	5e                   	pop    %esi
f0101966:	5d                   	pop    %ebp
f0101967:	c3                   	ret    

f0101968 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0101968:	55                   	push   %ebp
f0101969:	89 e5                	mov    %esp,%ebp
f010196b:	56                   	push   %esi
f010196c:	53                   	push   %ebx
f010196d:	8b 75 08             	mov    0x8(%ebp),%esi
f0101970:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101973:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0101976:	89 f0                	mov    %esi,%eax
f0101978:	85 c9                	test   %ecx,%ecx
f010197a:	74 27                	je     f01019a3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
f010197c:	83 e9 01             	sub    $0x1,%ecx
f010197f:	74 1d                	je     f010199e <strlcpy+0x36>
f0101981:	0f b6 1a             	movzbl (%edx),%ebx
f0101984:	84 db                	test   %bl,%bl
f0101986:	74 16                	je     f010199e <strlcpy+0x36>
			*dst++ = *src++;
f0101988:	88 18                	mov    %bl,(%eax)
f010198a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f010198d:	83 e9 01             	sub    $0x1,%ecx
f0101990:	74 0e                	je     f01019a0 <strlcpy+0x38>
			*dst++ = *src++;
f0101992:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f0101995:	0f b6 1a             	movzbl (%edx),%ebx
f0101998:	84 db                	test   %bl,%bl
f010199a:	75 ec                	jne    f0101988 <strlcpy+0x20>
f010199c:	eb 02                	jmp    f01019a0 <strlcpy+0x38>
f010199e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
f01019a0:	c6 00 00             	movb   $0x0,(%eax)
f01019a3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
f01019a5:	5b                   	pop    %ebx
f01019a6:	5e                   	pop    %esi
f01019a7:	5d                   	pop    %ebp
f01019a8:	c3                   	ret    

f01019a9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01019a9:	55                   	push   %ebp
f01019aa:	89 e5                	mov    %esp,%ebp
f01019ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01019af:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01019b2:	0f b6 01             	movzbl (%ecx),%eax
f01019b5:	84 c0                	test   %al,%al
f01019b7:	74 15                	je     f01019ce <strcmp+0x25>
f01019b9:	3a 02                	cmp    (%edx),%al
f01019bb:	75 11                	jne    f01019ce <strcmp+0x25>
		p++, q++;
f01019bd:	83 c1 01             	add    $0x1,%ecx
f01019c0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f01019c3:	0f b6 01             	movzbl (%ecx),%eax
f01019c6:	84 c0                	test   %al,%al
f01019c8:	74 04                	je     f01019ce <strcmp+0x25>
f01019ca:	3a 02                	cmp    (%edx),%al
f01019cc:	74 ef                	je     f01019bd <strcmp+0x14>
f01019ce:	0f b6 c0             	movzbl %al,%eax
f01019d1:	0f b6 12             	movzbl (%edx),%edx
f01019d4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
f01019d6:	5d                   	pop    %ebp
f01019d7:	c3                   	ret    

f01019d8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f01019d8:	55                   	push   %ebp
f01019d9:	89 e5                	mov    %esp,%ebp
f01019db:	53                   	push   %ebx
f01019dc:	8b 55 08             	mov    0x8(%ebp),%edx
f01019df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01019e2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
f01019e5:	85 c0                	test   %eax,%eax
f01019e7:	74 23                	je     f0101a0c <strncmp+0x34>
f01019e9:	0f b6 1a             	movzbl (%edx),%ebx
f01019ec:	84 db                	test   %bl,%bl
f01019ee:	74 24                	je     f0101a14 <strncmp+0x3c>
f01019f0:	3a 19                	cmp    (%ecx),%bl
f01019f2:	75 20                	jne    f0101a14 <strncmp+0x3c>
f01019f4:	83 e8 01             	sub    $0x1,%eax
f01019f7:	74 13                	je     f0101a0c <strncmp+0x34>
		n--, p++, q++;
f01019f9:	83 c2 01             	add    $0x1,%edx
f01019fc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f01019ff:	0f b6 1a             	movzbl (%edx),%ebx
f0101a02:	84 db                	test   %bl,%bl
f0101a04:	74 0e                	je     f0101a14 <strncmp+0x3c>
f0101a06:	3a 19                	cmp    (%ecx),%bl
f0101a08:	74 ea                	je     f01019f4 <strncmp+0x1c>
f0101a0a:	eb 08                	jmp    f0101a14 <strncmp+0x3c>
f0101a0c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0101a11:	5b                   	pop    %ebx
f0101a12:	5d                   	pop    %ebp
f0101a13:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0101a14:	0f b6 02             	movzbl (%edx),%eax
f0101a17:	0f b6 11             	movzbl (%ecx),%edx
f0101a1a:	29 d0                	sub    %edx,%eax
f0101a1c:	eb f3                	jmp    f0101a11 <strncmp+0x39>

f0101a1e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0101a1e:	55                   	push   %ebp
f0101a1f:	89 e5                	mov    %esp,%ebp
f0101a21:	8b 45 08             	mov    0x8(%ebp),%eax
f0101a24:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0101a28:	0f b6 10             	movzbl (%eax),%edx
f0101a2b:	84 d2                	test   %dl,%dl
f0101a2d:	74 15                	je     f0101a44 <strchr+0x26>
		if (*s == c)
f0101a2f:	38 ca                	cmp    %cl,%dl
f0101a31:	75 07                	jne    f0101a3a <strchr+0x1c>
f0101a33:	eb 14                	jmp    f0101a49 <strchr+0x2b>
f0101a35:	38 ca                	cmp    %cl,%dl
f0101a37:	90                   	nop
f0101a38:	74 0f                	je     f0101a49 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f0101a3a:	83 c0 01             	add    $0x1,%eax
f0101a3d:	0f b6 10             	movzbl (%eax),%edx
f0101a40:	84 d2                	test   %dl,%dl
f0101a42:	75 f1                	jne    f0101a35 <strchr+0x17>
f0101a44:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
f0101a49:	5d                   	pop    %ebp
f0101a4a:	c3                   	ret    

f0101a4b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0101a4b:	55                   	push   %ebp
f0101a4c:	89 e5                	mov    %esp,%ebp
f0101a4e:	8b 45 08             	mov    0x8(%ebp),%eax
f0101a51:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0101a55:	0f b6 10             	movzbl (%eax),%edx
f0101a58:	84 d2                	test   %dl,%dl
f0101a5a:	74 18                	je     f0101a74 <strfind+0x29>
		if (*s == c)
f0101a5c:	38 ca                	cmp    %cl,%dl
f0101a5e:	75 0a                	jne    f0101a6a <strfind+0x1f>
f0101a60:	eb 12                	jmp    f0101a74 <strfind+0x29>
f0101a62:	38 ca                	cmp    %cl,%dl
f0101a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101a68:	74 0a                	je     f0101a74 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f0101a6a:	83 c0 01             	add    $0x1,%eax
f0101a6d:	0f b6 10             	movzbl (%eax),%edx
f0101a70:	84 d2                	test   %dl,%dl
f0101a72:	75 ee                	jne    f0101a62 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
f0101a74:	5d                   	pop    %ebp
f0101a75:	c3                   	ret    

f0101a76 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0101a76:	55                   	push   %ebp
f0101a77:	89 e5                	mov    %esp,%ebp
f0101a79:	83 ec 0c             	sub    $0xc,%esp
f0101a7c:	89 1c 24             	mov    %ebx,(%esp)
f0101a7f:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101a83:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0101a87:	8b 7d 08             	mov    0x8(%ebp),%edi
f0101a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101a8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0101a90:	85 c9                	test   %ecx,%ecx
f0101a92:	74 30                	je     f0101ac4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0101a94:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0101a9a:	75 25                	jne    f0101ac1 <memset+0x4b>
f0101a9c:	f6 c1 03             	test   $0x3,%cl
f0101a9f:	75 20                	jne    f0101ac1 <memset+0x4b>
		c &= 0xFF;
f0101aa1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0101aa4:	89 d3                	mov    %edx,%ebx
f0101aa6:	c1 e3 08             	shl    $0x8,%ebx
f0101aa9:	89 d6                	mov    %edx,%esi
f0101aab:	c1 e6 18             	shl    $0x18,%esi
f0101aae:	89 d0                	mov    %edx,%eax
f0101ab0:	c1 e0 10             	shl    $0x10,%eax
f0101ab3:	09 f0                	or     %esi,%eax
f0101ab5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
f0101ab7:	09 d8                	or     %ebx,%eax
f0101ab9:	c1 e9 02             	shr    $0x2,%ecx
f0101abc:	fc                   	cld    
f0101abd:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0101abf:	eb 03                	jmp    f0101ac4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0101ac1:	fc                   	cld    
f0101ac2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0101ac4:	89 f8                	mov    %edi,%eax
f0101ac6:	8b 1c 24             	mov    (%esp),%ebx
f0101ac9:	8b 74 24 04          	mov    0x4(%esp),%esi
f0101acd:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0101ad1:	89 ec                	mov    %ebp,%esp
f0101ad3:	5d                   	pop    %ebp
f0101ad4:	c3                   	ret    

f0101ad5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0101ad5:	55                   	push   %ebp
f0101ad6:	89 e5                	mov    %esp,%ebp
f0101ad8:	83 ec 08             	sub    $0x8,%esp
f0101adb:	89 34 24             	mov    %esi,(%esp)
f0101ade:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
f0101ae5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
f0101ae8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
f0101aeb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
f0101aed:	39 c6                	cmp    %eax,%esi
f0101aef:	73 35                	jae    f0101b26 <memmove+0x51>
f0101af1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0101af4:	39 d0                	cmp    %edx,%eax
f0101af6:	73 2e                	jae    f0101b26 <memmove+0x51>
		s += n;
		d += n;
f0101af8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101afa:	f6 c2 03             	test   $0x3,%dl
f0101afd:	75 1b                	jne    f0101b1a <memmove+0x45>
f0101aff:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0101b05:	75 13                	jne    f0101b1a <memmove+0x45>
f0101b07:	f6 c1 03             	test   $0x3,%cl
f0101b0a:	75 0e                	jne    f0101b1a <memmove+0x45>
			asm volatile("std; rep movsl\n"
f0101b0c:	83 ef 04             	sub    $0x4,%edi
f0101b0f:	8d 72 fc             	lea    -0x4(%edx),%esi
f0101b12:	c1 e9 02             	shr    $0x2,%ecx
f0101b15:	fd                   	std    
f0101b16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101b18:	eb 09                	jmp    f0101b23 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f0101b1a:	83 ef 01             	sub    $0x1,%edi
f0101b1d:	8d 72 ff             	lea    -0x1(%edx),%esi
f0101b20:	fd                   	std    
f0101b21:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0101b23:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0101b24:	eb 20                	jmp    f0101b46 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101b26:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0101b2c:	75 15                	jne    f0101b43 <memmove+0x6e>
f0101b2e:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0101b34:	75 0d                	jne    f0101b43 <memmove+0x6e>
f0101b36:	f6 c1 03             	test   $0x3,%cl
f0101b39:	75 08                	jne    f0101b43 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
f0101b3b:	c1 e9 02             	shr    $0x2,%ecx
f0101b3e:	fc                   	cld    
f0101b3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101b41:	eb 03                	jmp    f0101b46 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0101b43:	fc                   	cld    
f0101b44:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0101b46:	8b 34 24             	mov    (%esp),%esi
f0101b49:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0101b4d:	89 ec                	mov    %ebp,%esp
f0101b4f:	5d                   	pop    %ebp
f0101b50:	c3                   	ret    

f0101b51 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
f0101b51:	55                   	push   %ebp
f0101b52:	89 e5                	mov    %esp,%ebp
f0101b54:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0101b57:	8b 45 10             	mov    0x10(%ebp),%eax
f0101b5a:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101b61:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101b65:	8b 45 08             	mov    0x8(%ebp),%eax
f0101b68:	89 04 24             	mov    %eax,(%esp)
f0101b6b:	e8 65 ff ff ff       	call   f0101ad5 <memmove>
}
f0101b70:	c9                   	leave  
f0101b71:	c3                   	ret    

f0101b72 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0101b72:	55                   	push   %ebp
f0101b73:	89 e5                	mov    %esp,%ebp
f0101b75:	57                   	push   %edi
f0101b76:	56                   	push   %esi
f0101b77:	53                   	push   %ebx
f0101b78:	8b 75 08             	mov    0x8(%ebp),%esi
f0101b7b:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0101b7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0101b81:	85 c9                	test   %ecx,%ecx
f0101b83:	74 36                	je     f0101bbb <memcmp+0x49>
		if (*s1 != *s2)
f0101b85:	0f b6 06             	movzbl (%esi),%eax
f0101b88:	0f b6 1f             	movzbl (%edi),%ebx
f0101b8b:	38 d8                	cmp    %bl,%al
f0101b8d:	74 20                	je     f0101baf <memcmp+0x3d>
f0101b8f:	eb 14                	jmp    f0101ba5 <memcmp+0x33>
f0101b91:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
f0101b96:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
f0101b9b:	83 c2 01             	add    $0x1,%edx
f0101b9e:	83 e9 01             	sub    $0x1,%ecx
f0101ba1:	38 d8                	cmp    %bl,%al
f0101ba3:	74 12                	je     f0101bb7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
f0101ba5:	0f b6 c0             	movzbl %al,%eax
f0101ba8:	0f b6 db             	movzbl %bl,%ebx
f0101bab:	29 d8                	sub    %ebx,%eax
f0101bad:	eb 11                	jmp    f0101bc0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0101baf:	83 e9 01             	sub    $0x1,%ecx
f0101bb2:	ba 00 00 00 00       	mov    $0x0,%edx
f0101bb7:	85 c9                	test   %ecx,%ecx
f0101bb9:	75 d6                	jne    f0101b91 <memcmp+0x1f>
f0101bbb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
f0101bc0:	5b                   	pop    %ebx
f0101bc1:	5e                   	pop    %esi
f0101bc2:	5f                   	pop    %edi
f0101bc3:	5d                   	pop    %ebp
f0101bc4:	c3                   	ret    

f0101bc5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0101bc5:	55                   	push   %ebp
f0101bc6:	89 e5                	mov    %esp,%ebp
f0101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
f0101bcb:	89 c2                	mov    %eax,%edx
f0101bcd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0101bd0:	39 d0                	cmp    %edx,%eax
f0101bd2:	73 15                	jae    f0101be9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
f0101bd4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
f0101bd8:	38 08                	cmp    %cl,(%eax)
f0101bda:	75 06                	jne    f0101be2 <memfind+0x1d>
f0101bdc:	eb 0b                	jmp    f0101be9 <memfind+0x24>
f0101bde:	38 08                	cmp    %cl,(%eax)
f0101be0:	74 07                	je     f0101be9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f0101be2:	83 c0 01             	add    $0x1,%eax
f0101be5:	39 c2                	cmp    %eax,%edx
f0101be7:	77 f5                	ja     f0101bde <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f0101be9:	5d                   	pop    %ebp
f0101bea:	c3                   	ret    

f0101beb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0101beb:	55                   	push   %ebp
f0101bec:	89 e5                	mov    %esp,%ebp
f0101bee:	57                   	push   %edi
f0101bef:	56                   	push   %esi
f0101bf0:	53                   	push   %ebx
f0101bf1:	83 ec 04             	sub    $0x4,%esp
f0101bf4:	8b 55 08             	mov    0x8(%ebp),%edx
f0101bf7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0101bfa:	0f b6 02             	movzbl (%edx),%eax
f0101bfd:	3c 20                	cmp    $0x20,%al
f0101bff:	74 04                	je     f0101c05 <strtol+0x1a>
f0101c01:	3c 09                	cmp    $0x9,%al
f0101c03:	75 0e                	jne    f0101c13 <strtol+0x28>
		s++;
f0101c05:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0101c08:	0f b6 02             	movzbl (%edx),%eax
f0101c0b:	3c 20                	cmp    $0x20,%al
f0101c0d:	74 f6                	je     f0101c05 <strtol+0x1a>
f0101c0f:	3c 09                	cmp    $0x9,%al
f0101c11:	74 f2                	je     f0101c05 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
f0101c13:	3c 2b                	cmp    $0x2b,%al
f0101c15:	75 0c                	jne    f0101c23 <strtol+0x38>
		s++;
f0101c17:	83 c2 01             	add    $0x1,%edx
f0101c1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101c21:	eb 15                	jmp    f0101c38 <strtol+0x4d>
	else if (*s == '-')
f0101c23:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101c2a:	3c 2d                	cmp    $0x2d,%al
f0101c2c:	75 0a                	jne    f0101c38 <strtol+0x4d>
		s++, neg = 1;
f0101c2e:	83 c2 01             	add    $0x1,%edx
f0101c31:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0101c38:	85 db                	test   %ebx,%ebx
f0101c3a:	0f 94 c0             	sete   %al
f0101c3d:	74 05                	je     f0101c44 <strtol+0x59>
f0101c3f:	83 fb 10             	cmp    $0x10,%ebx
f0101c42:	75 18                	jne    f0101c5c <strtol+0x71>
f0101c44:	80 3a 30             	cmpb   $0x30,(%edx)
f0101c47:	75 13                	jne    f0101c5c <strtol+0x71>
f0101c49:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0101c4d:	8d 76 00             	lea    0x0(%esi),%esi
f0101c50:	75 0a                	jne    f0101c5c <strtol+0x71>
		s += 2, base = 16;
f0101c52:	83 c2 02             	add    $0x2,%edx
f0101c55:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0101c5a:	eb 15                	jmp    f0101c71 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0101c5c:	84 c0                	test   %al,%al
f0101c5e:	66 90                	xchg   %ax,%ax
f0101c60:	74 0f                	je     f0101c71 <strtol+0x86>
f0101c62:	bb 0a 00 00 00       	mov    $0xa,%ebx
f0101c67:	80 3a 30             	cmpb   $0x30,(%edx)
f0101c6a:	75 05                	jne    f0101c71 <strtol+0x86>
		s++, base = 8;
f0101c6c:	83 c2 01             	add    $0x1,%edx
f0101c6f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0101c71:	b8 00 00 00 00       	mov    $0x0,%eax
f0101c76:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0101c78:	0f b6 0a             	movzbl (%edx),%ecx
f0101c7b:	89 cf                	mov    %ecx,%edi
f0101c7d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
f0101c80:	80 fb 09             	cmp    $0x9,%bl
f0101c83:	77 08                	ja     f0101c8d <strtol+0xa2>
			dig = *s - '0';
f0101c85:	0f be c9             	movsbl %cl,%ecx
f0101c88:	83 e9 30             	sub    $0x30,%ecx
f0101c8b:	eb 1e                	jmp    f0101cab <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
f0101c8d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
f0101c90:	80 fb 19             	cmp    $0x19,%bl
f0101c93:	77 08                	ja     f0101c9d <strtol+0xb2>
			dig = *s - 'a' + 10;
f0101c95:	0f be c9             	movsbl %cl,%ecx
f0101c98:	83 e9 57             	sub    $0x57,%ecx
f0101c9b:	eb 0e                	jmp    f0101cab <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
f0101c9d:	8d 5f bf             	lea    -0x41(%edi),%ebx
f0101ca0:	80 fb 19             	cmp    $0x19,%bl
f0101ca3:	77 15                	ja     f0101cba <strtol+0xcf>
			dig = *s - 'A' + 10;
f0101ca5:	0f be c9             	movsbl %cl,%ecx
f0101ca8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f0101cab:	39 f1                	cmp    %esi,%ecx
f0101cad:	7d 0b                	jge    f0101cba <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
f0101caf:	83 c2 01             	add    $0x1,%edx
f0101cb2:	0f af c6             	imul   %esi,%eax
f0101cb5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
f0101cb8:	eb be                	jmp    f0101c78 <strtol+0x8d>
f0101cba:	89 c1                	mov    %eax,%ecx

	if (endptr)
f0101cbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0101cc0:	74 05                	je     f0101cc7 <strtol+0xdc>
		*endptr = (char *) s;
f0101cc2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101cc5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
f0101cc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0101ccb:	74 04                	je     f0101cd1 <strtol+0xe6>
f0101ccd:	89 c8                	mov    %ecx,%eax
f0101ccf:	f7 d8                	neg    %eax
}
f0101cd1:	83 c4 04             	add    $0x4,%esp
f0101cd4:	5b                   	pop    %ebx
f0101cd5:	5e                   	pop    %esi
f0101cd6:	5f                   	pop    %edi
f0101cd7:	5d                   	pop    %ebp
f0101cd8:	c3                   	ret    
f0101cd9:	00 00                	add    %al,(%eax)
f0101cdb:	00 00                	add    %al,(%eax)
f0101cdd:	00 00                	add    %al,(%eax)
	...

f0101ce0 <__udivdi3>:
f0101ce0:	55                   	push   %ebp
f0101ce1:	89 e5                	mov    %esp,%ebp
f0101ce3:	57                   	push   %edi
f0101ce4:	56                   	push   %esi
f0101ce5:	83 ec 10             	sub    $0x10,%esp
f0101ce8:	8b 45 14             	mov    0x14(%ebp),%eax
f0101ceb:	8b 55 08             	mov    0x8(%ebp),%edx
f0101cee:	8b 75 10             	mov    0x10(%ebp),%esi
f0101cf1:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0101cf4:	85 c0                	test   %eax,%eax
f0101cf6:	89 55 f0             	mov    %edx,-0x10(%ebp)
f0101cf9:	75 35                	jne    f0101d30 <__udivdi3+0x50>
f0101cfb:	39 fe                	cmp    %edi,%esi
f0101cfd:	77 61                	ja     f0101d60 <__udivdi3+0x80>
f0101cff:	85 f6                	test   %esi,%esi
f0101d01:	75 0b                	jne    f0101d0e <__udivdi3+0x2e>
f0101d03:	b8 01 00 00 00       	mov    $0x1,%eax
f0101d08:	31 d2                	xor    %edx,%edx
f0101d0a:	f7 f6                	div    %esi
f0101d0c:	89 c6                	mov    %eax,%esi
f0101d0e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0101d11:	31 d2                	xor    %edx,%edx
f0101d13:	89 f8                	mov    %edi,%eax
f0101d15:	f7 f6                	div    %esi
f0101d17:	89 c7                	mov    %eax,%edi
f0101d19:	89 c8                	mov    %ecx,%eax
f0101d1b:	f7 f6                	div    %esi
f0101d1d:	89 c1                	mov    %eax,%ecx
f0101d1f:	89 fa                	mov    %edi,%edx
f0101d21:	89 c8                	mov    %ecx,%eax
f0101d23:	83 c4 10             	add    $0x10,%esp
f0101d26:	5e                   	pop    %esi
f0101d27:	5f                   	pop    %edi
f0101d28:	5d                   	pop    %ebp
f0101d29:	c3                   	ret    
f0101d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101d30:	39 f8                	cmp    %edi,%eax
f0101d32:	77 1c                	ja     f0101d50 <__udivdi3+0x70>
f0101d34:	0f bd d0             	bsr    %eax,%edx
f0101d37:	83 f2 1f             	xor    $0x1f,%edx
f0101d3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101d3d:	75 39                	jne    f0101d78 <__udivdi3+0x98>
f0101d3f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0101d42:	0f 86 a0 00 00 00    	jbe    f0101de8 <__udivdi3+0x108>
f0101d48:	39 f8                	cmp    %edi,%eax
f0101d4a:	0f 82 98 00 00 00    	jb     f0101de8 <__udivdi3+0x108>
f0101d50:	31 ff                	xor    %edi,%edi
f0101d52:	31 c9                	xor    %ecx,%ecx
f0101d54:	89 c8                	mov    %ecx,%eax
f0101d56:	89 fa                	mov    %edi,%edx
f0101d58:	83 c4 10             	add    $0x10,%esp
f0101d5b:	5e                   	pop    %esi
f0101d5c:	5f                   	pop    %edi
f0101d5d:	5d                   	pop    %ebp
f0101d5e:	c3                   	ret    
f0101d5f:	90                   	nop
f0101d60:	89 d1                	mov    %edx,%ecx
f0101d62:	89 fa                	mov    %edi,%edx
f0101d64:	89 c8                	mov    %ecx,%eax
f0101d66:	31 ff                	xor    %edi,%edi
f0101d68:	f7 f6                	div    %esi
f0101d6a:	89 c1                	mov    %eax,%ecx
f0101d6c:	89 fa                	mov    %edi,%edx
f0101d6e:	89 c8                	mov    %ecx,%eax
f0101d70:	83 c4 10             	add    $0x10,%esp
f0101d73:	5e                   	pop    %esi
f0101d74:	5f                   	pop    %edi
f0101d75:	5d                   	pop    %ebp
f0101d76:	c3                   	ret    
f0101d77:	90                   	nop
f0101d78:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101d7c:	89 f2                	mov    %esi,%edx
f0101d7e:	d3 e0                	shl    %cl,%eax
f0101d80:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0101d83:	b8 20 00 00 00       	mov    $0x20,%eax
f0101d88:	2b 45 f4             	sub    -0xc(%ebp),%eax
f0101d8b:	89 c1                	mov    %eax,%ecx
f0101d8d:	d3 ea                	shr    %cl,%edx
f0101d8f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101d93:	0b 55 ec             	or     -0x14(%ebp),%edx
f0101d96:	d3 e6                	shl    %cl,%esi
f0101d98:	89 c1                	mov    %eax,%ecx
f0101d9a:	89 75 e8             	mov    %esi,-0x18(%ebp)
f0101d9d:	89 fe                	mov    %edi,%esi
f0101d9f:	d3 ee                	shr    %cl,%esi
f0101da1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101da5:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101da8:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101dab:	d3 e7                	shl    %cl,%edi
f0101dad:	89 c1                	mov    %eax,%ecx
f0101daf:	d3 ea                	shr    %cl,%edx
f0101db1:	09 d7                	or     %edx,%edi
f0101db3:	89 f2                	mov    %esi,%edx
f0101db5:	89 f8                	mov    %edi,%eax
f0101db7:	f7 75 ec             	divl   -0x14(%ebp)
f0101dba:	89 d6                	mov    %edx,%esi
f0101dbc:	89 c7                	mov    %eax,%edi
f0101dbe:	f7 65 e8             	mull   -0x18(%ebp)
f0101dc1:	39 d6                	cmp    %edx,%esi
f0101dc3:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101dc6:	72 30                	jb     f0101df8 <__udivdi3+0x118>
f0101dc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101dcb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101dcf:	d3 e2                	shl    %cl,%edx
f0101dd1:	39 c2                	cmp    %eax,%edx
f0101dd3:	73 05                	jae    f0101dda <__udivdi3+0xfa>
f0101dd5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
f0101dd8:	74 1e                	je     f0101df8 <__udivdi3+0x118>
f0101dda:	89 f9                	mov    %edi,%ecx
f0101ddc:	31 ff                	xor    %edi,%edi
f0101dde:	e9 71 ff ff ff       	jmp    f0101d54 <__udivdi3+0x74>
f0101de3:	90                   	nop
f0101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101de8:	31 ff                	xor    %edi,%edi
f0101dea:	b9 01 00 00 00       	mov    $0x1,%ecx
f0101def:	e9 60 ff ff ff       	jmp    f0101d54 <__udivdi3+0x74>
f0101df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101df8:	8d 4f ff             	lea    -0x1(%edi),%ecx
f0101dfb:	31 ff                	xor    %edi,%edi
f0101dfd:	89 c8                	mov    %ecx,%eax
f0101dff:	89 fa                	mov    %edi,%edx
f0101e01:	83 c4 10             	add    $0x10,%esp
f0101e04:	5e                   	pop    %esi
f0101e05:	5f                   	pop    %edi
f0101e06:	5d                   	pop    %ebp
f0101e07:	c3                   	ret    
	...

f0101e10 <__umoddi3>:
f0101e10:	55                   	push   %ebp
f0101e11:	89 e5                	mov    %esp,%ebp
f0101e13:	57                   	push   %edi
f0101e14:	56                   	push   %esi
f0101e15:	83 ec 20             	sub    $0x20,%esp
f0101e18:	8b 55 14             	mov    0x14(%ebp),%edx
f0101e1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101e1e:	8b 7d 10             	mov    0x10(%ebp),%edi
f0101e21:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101e24:	85 d2                	test   %edx,%edx
f0101e26:	89 c8                	mov    %ecx,%eax
f0101e28:	89 4d f4             	mov    %ecx,-0xc(%ebp)
f0101e2b:	75 13                	jne    f0101e40 <__umoddi3+0x30>
f0101e2d:	39 f7                	cmp    %esi,%edi
f0101e2f:	76 3f                	jbe    f0101e70 <__umoddi3+0x60>
f0101e31:	89 f2                	mov    %esi,%edx
f0101e33:	f7 f7                	div    %edi
f0101e35:	89 d0                	mov    %edx,%eax
f0101e37:	31 d2                	xor    %edx,%edx
f0101e39:	83 c4 20             	add    $0x20,%esp
f0101e3c:	5e                   	pop    %esi
f0101e3d:	5f                   	pop    %edi
f0101e3e:	5d                   	pop    %ebp
f0101e3f:	c3                   	ret    
f0101e40:	39 f2                	cmp    %esi,%edx
f0101e42:	77 4c                	ja     f0101e90 <__umoddi3+0x80>
f0101e44:	0f bd ca             	bsr    %edx,%ecx
f0101e47:	83 f1 1f             	xor    $0x1f,%ecx
f0101e4a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0101e4d:	75 51                	jne    f0101ea0 <__umoddi3+0x90>
f0101e4f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
f0101e52:	0f 87 e0 00 00 00    	ja     f0101f38 <__umoddi3+0x128>
f0101e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101e5b:	29 f8                	sub    %edi,%eax
f0101e5d:	19 d6                	sbb    %edx,%esi
f0101e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101e65:	89 f2                	mov    %esi,%edx
f0101e67:	83 c4 20             	add    $0x20,%esp
f0101e6a:	5e                   	pop    %esi
f0101e6b:	5f                   	pop    %edi
f0101e6c:	5d                   	pop    %ebp
f0101e6d:	c3                   	ret    
f0101e6e:	66 90                	xchg   %ax,%ax
f0101e70:	85 ff                	test   %edi,%edi
f0101e72:	75 0b                	jne    f0101e7f <__umoddi3+0x6f>
f0101e74:	b8 01 00 00 00       	mov    $0x1,%eax
f0101e79:	31 d2                	xor    %edx,%edx
f0101e7b:	f7 f7                	div    %edi
f0101e7d:	89 c7                	mov    %eax,%edi
f0101e7f:	89 f0                	mov    %esi,%eax
f0101e81:	31 d2                	xor    %edx,%edx
f0101e83:	f7 f7                	div    %edi
f0101e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101e88:	f7 f7                	div    %edi
f0101e8a:	eb a9                	jmp    f0101e35 <__umoddi3+0x25>
f0101e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101e90:	89 c8                	mov    %ecx,%eax
f0101e92:	89 f2                	mov    %esi,%edx
f0101e94:	83 c4 20             	add    $0x20,%esp
f0101e97:	5e                   	pop    %esi
f0101e98:	5f                   	pop    %edi
f0101e99:	5d                   	pop    %ebp
f0101e9a:	c3                   	ret    
f0101e9b:	90                   	nop
f0101e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101ea0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101ea4:	d3 e2                	shl    %cl,%edx
f0101ea6:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101ea9:	ba 20 00 00 00       	mov    $0x20,%edx
f0101eae:	2b 55 f0             	sub    -0x10(%ebp),%edx
f0101eb1:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101eb4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101eb8:	89 fa                	mov    %edi,%edx
f0101eba:	d3 ea                	shr    %cl,%edx
f0101ebc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101ec0:	0b 55 f4             	or     -0xc(%ebp),%edx
f0101ec3:	d3 e7                	shl    %cl,%edi
f0101ec5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101ec9:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101ecc:	89 f2                	mov    %esi,%edx
f0101ece:	89 7d e8             	mov    %edi,-0x18(%ebp)
f0101ed1:	89 c7                	mov    %eax,%edi
f0101ed3:	d3 ea                	shr    %cl,%edx
f0101ed5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101ed9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101edc:	89 c2                	mov    %eax,%edx
f0101ede:	d3 e6                	shl    %cl,%esi
f0101ee0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101ee4:	d3 ea                	shr    %cl,%edx
f0101ee6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101eea:	09 d6                	or     %edx,%esi
f0101eec:	89 f0                	mov    %esi,%eax
f0101eee:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0101ef1:	d3 e7                	shl    %cl,%edi
f0101ef3:	89 f2                	mov    %esi,%edx
f0101ef5:	f7 75 f4             	divl   -0xc(%ebp)
f0101ef8:	89 d6                	mov    %edx,%esi
f0101efa:	f7 65 e8             	mull   -0x18(%ebp)
f0101efd:	39 d6                	cmp    %edx,%esi
f0101eff:	72 2b                	jb     f0101f2c <__umoddi3+0x11c>
f0101f01:	39 c7                	cmp    %eax,%edi
f0101f03:	72 23                	jb     f0101f28 <__umoddi3+0x118>
f0101f05:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101f09:	29 c7                	sub    %eax,%edi
f0101f0b:	19 d6                	sbb    %edx,%esi
f0101f0d:	89 f0                	mov    %esi,%eax
f0101f0f:	89 f2                	mov    %esi,%edx
f0101f11:	d3 ef                	shr    %cl,%edi
f0101f13:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101f17:	d3 e0                	shl    %cl,%eax
f0101f19:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101f1d:	09 f8                	or     %edi,%eax
f0101f1f:	d3 ea                	shr    %cl,%edx
f0101f21:	83 c4 20             	add    $0x20,%esp
f0101f24:	5e                   	pop    %esi
f0101f25:	5f                   	pop    %edi
f0101f26:	5d                   	pop    %ebp
f0101f27:	c3                   	ret    
f0101f28:	39 d6                	cmp    %edx,%esi
f0101f2a:	75 d9                	jne    f0101f05 <__umoddi3+0xf5>
f0101f2c:	2b 45 e8             	sub    -0x18(%ebp),%eax
f0101f2f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
f0101f32:	eb d1                	jmp    f0101f05 <__umoddi3+0xf5>
f0101f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101f38:	39 f2                	cmp    %esi,%edx
f0101f3a:	0f 82 18 ff ff ff    	jb     f0101e58 <__umoddi3+0x48>
f0101f40:	e9 1d ff ff ff       	jmp    f0101e62 <__umoddi3+0x52>
