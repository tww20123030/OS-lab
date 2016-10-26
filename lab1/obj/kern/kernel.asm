
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
f0100058:	c7 04 24 c0 1e 10 f0 	movl   $0xf0101ec0,(%esp)
f010005f:	e8 03 0b 00 00       	call   f0100b67 <cprintf>
	vcprintf(fmt, ap);
f0100064:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100068:	8b 45 10             	mov    0x10(%ebp),%eax
f010006b:	89 04 24             	mov    %eax,(%esp)
f010006e:	e8 c1 0a 00 00       	call   f0100b34 <vcprintf>
	cprintf("\n");
f0100073:	c7 04 24 e5 1f 10 f0 	movl   $0xf0101fe5,(%esp)
f010007a:	e8 e8 0a 00 00       	call   f0100b67 <cprintf>
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
f01000b2:	c7 04 24 da 1e 10 f0 	movl   $0xf0101eda,(%esp)
f01000b9:	e8 a9 0a 00 00       	call   f0100b67 <cprintf>
	vcprintf(fmt, ap);
f01000be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01000c2:	89 34 24             	mov    %esi,(%esp)
f01000c5:	e8 6a 0a 00 00       	call   f0100b34 <vcprintf>
	cprintf("\n");
f01000ca:	c7 04 24 e5 1f 10 f0 	movl   $0xf0101fe5,(%esp)
f01000d1:	e8 91 0a 00 00       	call   f0100b67 <cprintf>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01000dd:	e8 54 08 00 00       	call   f0100936 <monitor>
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
f01000f2:	c7 04 24 f2 1e 10 f0 	movl   $0xf0101ef2,(%esp)
f01000f9:	e8 69 0a 00 00       	call   f0100b67 <cprintf>
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
f0100126:	e8 55 09 00 00       	call   f0100a80 <mon_backtrace>
	cprintf("leaving test_backtrace %d\n", x);
f010012b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010012f:	c7 04 24 0e 1f 10 f0 	movl   $0xf0101f0e,(%esp)
f0100136:	e8 2c 0a 00 00       	call   f0100b67 <cprintf>
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
f010019c:	e8 35 18 00 00       	call   f01019d6 <memset>

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
f01001bc:	c7 04 24 70 1f 10 f0 	movl   $0xf0101f70,(%esp)
f01001c3:	e8 9f 09 00 00       	call   f0100b67 <cprintf>
	cprintf("pading space in the right to number 22: %8d.\n", 22);
f01001c8:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
f01001cf:	00 
f01001d0:	c7 04 24 90 1f 10 f0 	movl   $0xf0101f90,(%esp)
f01001d7:	e8 8b 09 00 00       	call   f0100b67 <cprintf>
	cprintf("chnum1: %d chnum2: %d\n", chnum1, chnum2);
f01001dc:	0f be 45 f6          	movsbl -0xa(%ebp),%eax
f01001e0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01001e4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
f01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01001ec:	c7 04 24 29 1f 10 f0 	movl   $0xf0101f29,(%esp)
f01001f3:	e8 6f 09 00 00       	call   f0100b67 <cprintf>
	cprintf("%n", NULL);
f01001f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01001ff:	00 
f0100200:	c7 04 24 42 1f 10 f0 	movl   $0xf0101f42,(%esp)
f0100207:	e8 5b 09 00 00       	call   f0100b67 <cprintf>
	memset(ntest, 0xd, sizeof(ntest) - 1);
f010020c:	c7 44 24 08 ff 00 00 	movl   $0xff,0x8(%esp)
f0100213:	00 
f0100214:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
f010021b:	00 
f010021c:	8d 9d f6 fe ff ff    	lea    -0x10a(%ebp),%ebx
f0100222:	89 1c 24             	mov    %ebx,(%esp)
f0100225:	e8 ac 17 00 00       	call   f01019d6 <memset>
	cprintf("%s%n", ntest, &chnum1); 
f010022a:	89 7c 24 08          	mov    %edi,0x8(%esp)
f010022e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100232:	c7 04 24 40 1f 10 f0 	movl   $0xf0101f40,(%esp)
f0100239:	e8 29 09 00 00       	call   f0100b67 <cprintf>
	cprintf("chnum1: %d\n", chnum1);
f010023e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
f0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100246:	c7 04 24 45 1f 10 f0 	movl   $0xf0101f45,(%esp)
f010024d:	e8 15 09 00 00       	call   f0100b67 <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f0100252:	c7 44 24 08 00 fc ff 	movl   $0xfffffc00,0x8(%esp)
f0100259:	ff 
f010025a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
f0100261:	00 
f0100262:	c7 04 24 51 1f 10 f0 	movl   $0xf0101f51,(%esp)
f0100269:	e8 f9 08 00 00       	call   f0100b67 <cprintf>


	// Test the stack backtrace function (lab 1 only)
	test_backtrace(5);
f010026e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f0100275:	e8 6a fe ff ff       	call   f01000e4 <test_backtrace>

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
f010027a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100281:	e8 b0 06 00 00       	call   f0100936 <monitor>
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
f010052a:	e8 06 15 00 00       	call   f0101a35 <memmove>
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
f0100676:	c7 04 24 be 1f 10 f0 	movl   $0xf0101fbe,(%esp)
f010067d:	e8 e5 04 00 00       	call   f0100b67 <cprintf>
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
f01006d1:	0f b6 80 00 20 10 f0 	movzbl -0xfefe000(%eax),%eax
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
f010070c:	0f b6 90 00 20 10 f0 	movzbl -0xfefe000(%eax),%edx
f0100713:	0b 15 20 33 11 f0    	or     0xf0113320,%edx
f0100719:	0f b6 88 00 21 10 f0 	movzbl -0xfefdf00(%eax),%ecx
f0100720:	31 ca                	xor    %ecx,%edx
f0100722:	89 15 20 33 11 f0    	mov    %edx,0xf0113320

	c = charcode[shift & (CTL | SHIFT)][data];
f0100728:	89 d1                	mov    %edx,%ecx
f010072a:	83 e1 03             	and    $0x3,%ecx
f010072d:	8b 0c 8d 00 22 10 f0 	mov    -0xfefde00(,%ecx,4),%ecx
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
f0100766:	c7 04 24 db 1f 10 f0 	movl   $0xf0101fdb,(%esp)
f010076d:	e8 f5 03 00 00       	call   f0100b67 <cprintf>
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

f0100790 <getbuff>:
do_overflow(void)
{
    cprintf("Overflow success\n");
}

void getbuff(char* str){
f0100790:	55                   	push   %ebp
f0100791:	89 e5                	mov    %esp,%ebp
f0100793:	8b 55 08             	mov    0x8(%ebp),%edx
// Lab1 only
// read the pointer to the retaddr on the stack
static uint32_t
read_pretaddr() {
    uint32_t pretaddr;
    __asm __volatile("leal 4(%%ebp), %0" : "=r" (pretaddr)); 
f0100796:	8d 45 04             	lea    0x4(%ebp),%eax

void getbuff(char* str){
	int *pret;
	int *p = (int*)str;
	pret = (int*)read_pretaddr();
	*p = *pret;//the normal return address of getbuff
f0100799:	8b 08                	mov    (%eax),%ecx
f010079b:	89 0a                	mov    %ecx,(%edx)
	*pret = (int)(p+1);//set the return  address to the address of attack code
f010079d:	83 c2 04             	add    $0x4,%edx
f01007a0:	89 10                	mov    %edx,(%eax)
	return;
}
f01007a2:	5d                   	pop    %ebp
f01007a3:	c3                   	ret    

f01007a4 <read_eip>:
// return EIP of caller.
// does not work if inlined.
// putting at the end of the file seems to prevent inlining.
unsigned
read_eip()
{
f01007a4:	55                   	push   %ebp
f01007a5:	89 e5                	mov    %esp,%ebp
	uint32_t callerpc;
	__asm __volatile("movl 4(%%ebp), %0" : "=r" (callerpc));
f01007a7:	8b 45 04             	mov    0x4(%ebp),%eax
	return callerpc;
}
f01007aa:	5d                   	pop    %ebp
f01007ab:	c3                   	ret    

f01007ac <start_overflow>:
	*pret = (int)(p+1);//set the return  address to the address of attack code
	return;
}
void
start_overflow(void)
{
f01007ac:	55                   	push   %ebp
f01007ad:	89 e5                	mov    %esp,%ebp
f01007af:	81 ec 28 01 00 00    	sub    $0x128,%esp
f01007b5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f01007b8:	89 7d fc             	mov    %edi,-0x4(%ebp)
    // you augmented in the "Exercise 9" to do this job.

    // hint: You can use the read_pretaddr function to retrieve 
    //       the pointer to the function call return address;
    
    char str[256] = {};
f01007bb:	8d bd f8 fe ff ff    	lea    -0x108(%ebp),%edi
f01007c1:	b9 40 00 00 00       	mov    $0x40,%ecx
f01007c6:	b8 00 00 00 00       	mov    $0x0,%eax
f01007cb:	f3 ab                	rep stos %eax,%es:(%edi)
    int nstr = 0;
    char *pret_addr;
	// Your code here.
    char num;
    int *ptr = (int*)str;
f01007cd:	8d 9d f8 fe ff ff    	lea    -0x108(%ebp),%ebx
    
    ptr[1] = 0xff24148b;
f01007d3:	c7 43 04 8b 14 24 ff 	movl   $0xff24148b,0x4(%ebx)
    ptr[2] = 0x831a8b32;
f01007da:	c7 43 08 32 8b 1a 83 	movl   $0x831a8b32,0x8(%ebx)
    ptr[3] = 0x555337c3;
f01007e1:	c7 43 0c c3 37 53 55 	movl   $0x555337c3,0xc(%ebx)
    ptr[4] = 0xc3c9e589;
f01007e8:	c7 43 10 89 e5 c9 c3 	movl   $0xc3c9e589,0x10(%ebx)
    getbuff(str);
f01007ef:	89 1c 24             	mov    %ebx,(%esp)
f01007f2:	e8 99 ff ff ff       	call   f0100790 <getbuff>
    cprintf("%s%n\n",str,&num);
f01007f7:	8d 85 f7 fe ff ff    	lea    -0x109(%ebp),%eax
f01007fd:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100801:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100805:	c7 04 24 10 22 10 f0 	movl   $0xf0102210,(%esp)
f010080c:	e8 56 03 00 00       	call   f0100b67 <cprintf>
}
f0100811:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0100814:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0100817:	89 ec                	mov    %ebp,%esp
f0100819:	5d                   	pop    %ebp
f010081a:	c3                   	ret    

f010081b <overflow_me>:

void
overflow_me(void)
{
f010081b:	55                   	push   %ebp
f010081c:	89 e5                	mov    %esp,%ebp
f010081e:	83 ec 08             	sub    $0x8,%esp
        start_overflow();
f0100821:	e8 86 ff ff ff       	call   f01007ac <start_overflow>
}
f0100826:	c9                   	leave  
f0100827:	c3                   	ret    

f0100828 <do_overflow>:
    return pretaddr;
}

void
do_overflow(void)
{
f0100828:	55                   	push   %ebp
f0100829:	89 e5                	mov    %esp,%ebp
f010082b:	83 ec 18             	sub    $0x18,%esp
    cprintf("Overflow success\n");
f010082e:	c7 04 24 16 22 10 f0 	movl   $0xf0102216,(%esp)
f0100835:	e8 2d 03 00 00       	call   f0100b67 <cprintf>
}
f010083a:	c9                   	leave  
f010083b:	c3                   	ret    

f010083c <mon_kerninfo>:
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f010083c:	55                   	push   %ebp
f010083d:	89 e5                	mov    %esp,%ebp
f010083f:	83 ec 18             	sub    $0x18,%esp
	extern char entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100842:	c7 04 24 28 22 10 f0 	movl   $0xf0102228,(%esp)
f0100849:	e8 19 03 00 00       	call   f0100b67 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010084e:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f0100855:	00 
f0100856:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f010085d:	f0 
f010085e:	c7 04 24 d4 22 10 f0 	movl   $0xf01022d4,(%esp)
f0100865:	e8 fd 02 00 00       	call   f0100b67 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f010086a:	c7 44 24 08 a5 1e 10 	movl   $0x101ea5,0x8(%esp)
f0100871:	00 
f0100872:	c7 44 24 04 a5 1e 10 	movl   $0xf0101ea5,0x4(%esp)
f0100879:	f0 
f010087a:	c7 04 24 f8 22 10 f0 	movl   $0xf01022f8,(%esp)
f0100881:	e8 e1 02 00 00       	call   f0100b67 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100886:	c7 44 24 08 00 33 11 	movl   $0x113300,0x8(%esp)
f010088d:	00 
f010088e:	c7 44 24 04 00 33 11 	movl   $0xf0113300,0x4(%esp)
f0100895:	f0 
f0100896:	c7 04 24 1c 23 10 f0 	movl   $0xf010231c,(%esp)
f010089d:	e8 c5 02 00 00       	call   f0100b67 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01008a2:	c7 44 24 08 60 39 11 	movl   $0x113960,0x8(%esp)
f01008a9:	00 
f01008aa:	c7 44 24 04 60 39 11 	movl   $0xf0113960,0x4(%esp)
f01008b1:	f0 
f01008b2:	c7 04 24 40 23 10 f0 	movl   $0xf0102340,(%esp)
f01008b9:	e8 a9 02 00 00       	call   f0100b67 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008be:	b8 5f 3d 11 f0       	mov    $0xf0113d5f,%eax
f01008c3:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f01008c8:	89 c2                	mov    %eax,%edx
f01008ca:	c1 fa 1f             	sar    $0x1f,%edx
f01008cd:	c1 ea 16             	shr    $0x16,%edx
f01008d0:	8d 04 02             	lea    (%edx,%eax,1),%eax
f01008d3:	c1 f8 0a             	sar    $0xa,%eax
f01008d6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01008da:	c7 04 24 64 23 10 f0 	movl   $0xf0102364,(%esp)
f01008e1:	e8 81 02 00 00       	call   f0100b67 <cprintf>
		(end-entry+1023)/1024);
	return 0;
}
f01008e6:	b8 00 00 00 00       	mov    $0x0,%eax
f01008eb:	c9                   	leave  
f01008ec:	c3                   	ret    

f01008ed <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01008ed:	55                   	push   %ebp
f01008ee:	89 e5                	mov    %esp,%ebp
f01008f0:	83 ec 18             	sub    $0x18,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01008f3:	a1 3c 24 10 f0       	mov    0xf010243c,%eax
f01008f8:	89 44 24 08          	mov    %eax,0x8(%esp)
f01008fc:	a1 38 24 10 f0       	mov    0xf0102438,%eax
f0100901:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100905:	c7 04 24 41 22 10 f0 	movl   $0xf0102241,(%esp)
f010090c:	e8 56 02 00 00       	call   f0100b67 <cprintf>
f0100911:	a1 48 24 10 f0       	mov    0xf0102448,%eax
f0100916:	89 44 24 08          	mov    %eax,0x8(%esp)
f010091a:	a1 44 24 10 f0       	mov    0xf0102444,%eax
f010091f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100923:	c7 04 24 41 22 10 f0 	movl   $0xf0102241,(%esp)
f010092a:	e8 38 02 00 00       	call   f0100b67 <cprintf>
	return 0;
}
f010092f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100934:	c9                   	leave  
f0100935:	c3                   	ret    

f0100936 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100936:	55                   	push   %ebp
f0100937:	89 e5                	mov    %esp,%ebp
f0100939:	57                   	push   %edi
f010093a:	56                   	push   %esi
f010093b:	53                   	push   %ebx
f010093c:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f010093f:	c7 04 24 90 23 10 f0 	movl   $0xf0102390,(%esp)
f0100946:	e8 1c 02 00 00       	call   f0100b67 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f010094b:	c7 04 24 b4 23 10 f0 	movl   $0xf01023b4,(%esp)
f0100952:	e8 10 02 00 00       	call   f0100b67 <cprintf>

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f0100957:	bf 38 24 10 f0       	mov    $0xf0102438,%edi
	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");


	while (1) {
		buf = readline("K> ");
f010095c:	c7 04 24 4a 22 10 f0 	movl   $0xf010224a,(%esp)
f0100963:	e8 e8 0d 00 00       	call   f0101750 <readline>
f0100968:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f010096a:	85 c0                	test   %eax,%eax
f010096c:	74 ee                	je     f010095c <monitor+0x26>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f010096e:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
f0100975:	be 00 00 00 00       	mov    $0x0,%esi
f010097a:	eb 06                	jmp    f0100982 <monitor+0x4c>
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f010097c:	c6 03 00             	movb   $0x0,(%ebx)
f010097f:	83 c3 01             	add    $0x1,%ebx
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100982:	0f b6 03             	movzbl (%ebx),%eax
f0100985:	84 c0                	test   %al,%al
f0100987:	74 6c                	je     f01009f5 <monitor+0xbf>
f0100989:	0f be c0             	movsbl %al,%eax
f010098c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100990:	c7 04 24 4e 22 10 f0 	movl   $0xf010224e,(%esp)
f0100997:	e8 e2 0f 00 00       	call   f010197e <strchr>
f010099c:	85 c0                	test   %eax,%eax
f010099e:	75 dc                	jne    f010097c <monitor+0x46>
			*buf++ = 0;
		if (*buf == 0)
f01009a0:	80 3b 00             	cmpb   $0x0,(%ebx)
f01009a3:	74 50                	je     f01009f5 <monitor+0xbf>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f01009a5:	83 fe 0f             	cmp    $0xf,%esi
f01009a8:	75 16                	jne    f01009c0 <monitor+0x8a>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f01009aa:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f01009b1:	00 
f01009b2:	c7 04 24 53 22 10 f0 	movl   $0xf0102253,(%esp)
f01009b9:	e8 a9 01 00 00       	call   f0100b67 <cprintf>
f01009be:	eb 9c                	jmp    f010095c <monitor+0x26>
			return 0;
		}
		argv[argc++] = buf;
f01009c0:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f01009c4:	83 c6 01             	add    $0x1,%esi
		while (*buf && !strchr(WHITESPACE, *buf))
f01009c7:	0f b6 03             	movzbl (%ebx),%eax
f01009ca:	84 c0                	test   %al,%al
f01009cc:	75 0e                	jne    f01009dc <monitor+0xa6>
f01009ce:	66 90                	xchg   %ax,%ax
f01009d0:	eb b0                	jmp    f0100982 <monitor+0x4c>
			buf++;
f01009d2:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f01009d5:	0f b6 03             	movzbl (%ebx),%eax
f01009d8:	84 c0                	test   %al,%al
f01009da:	74 a6                	je     f0100982 <monitor+0x4c>
f01009dc:	0f be c0             	movsbl %al,%eax
f01009df:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009e3:	c7 04 24 4e 22 10 f0 	movl   $0xf010224e,(%esp)
f01009ea:	e8 8f 0f 00 00       	call   f010197e <strchr>
f01009ef:	85 c0                	test   %eax,%eax
f01009f1:	74 df                	je     f01009d2 <monitor+0x9c>
f01009f3:	eb 8d                	jmp    f0100982 <monitor+0x4c>
			buf++;
	}
	argv[argc] = 0;
f01009f5:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01009fc:	00 

	// Lookup and invoke the command
	if (argc == 0)
f01009fd:	85 f6                	test   %esi,%esi
f01009ff:	90                   	nop
f0100a00:	0f 84 56 ff ff ff    	je     f010095c <monitor+0x26>
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f0100a06:	8b 07                	mov    (%edi),%eax
f0100a08:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a0c:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100a0f:	89 04 24             	mov    %eax,(%esp)
f0100a12:	e8 f2 0e 00 00       	call   f0101909 <strcmp>
f0100a17:	ba 00 00 00 00       	mov    $0x0,%edx
f0100a1c:	85 c0                	test   %eax,%eax
f0100a1e:	74 1d                	je     f0100a3d <monitor+0x107>
f0100a20:	a1 44 24 10 f0       	mov    0xf0102444,%eax
f0100a25:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a29:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100a2c:	89 04 24             	mov    %eax,(%esp)
f0100a2f:	e8 d5 0e 00 00       	call   f0101909 <strcmp>
f0100a34:	85 c0                	test   %eax,%eax
f0100a36:	75 28                	jne    f0100a60 <monitor+0x12a>
f0100a38:	ba 01 00 00 00       	mov    $0x1,%edx
			return commands[i].func(argc, argv, tf);
f0100a3d:	6b d2 0c             	imul   $0xc,%edx,%edx
f0100a40:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a43:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100a47:	8d 45 a8             	lea    -0x58(%ebp),%eax
f0100a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a4e:	89 34 24             	mov    %esi,(%esp)
f0100a51:	ff 92 40 24 10 f0    	call   *-0xfefdbc0(%edx)


	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f0100a57:	85 c0                	test   %eax,%eax
f0100a59:	78 1d                	js     f0100a78 <monitor+0x142>
f0100a5b:	e9 fc fe ff ff       	jmp    f010095c <monitor+0x26>
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100a60:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100a63:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a67:	c7 04 24 70 22 10 f0 	movl   $0xf0102270,(%esp)
f0100a6e:	e8 f4 00 00 00       	call   f0100b67 <cprintf>
f0100a73:	e9 e4 fe ff ff       	jmp    f010095c <monitor+0x26>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f0100a78:	83 c4 5c             	add    $0x5c,%esp
f0100a7b:	5b                   	pop    %ebx
f0100a7c:	5e                   	pop    %esi
f0100a7d:	5f                   	pop    %edi
f0100a7e:	5d                   	pop    %ebp
f0100a7f:	c3                   	ret    

f0100a80 <mon_backtrace>:
        start_overflow();
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100a80:	55                   	push   %ebp
f0100a81:	89 e5                	mov    %esp,%ebp
f0100a83:	57                   	push   %edi
f0100a84:	56                   	push   %esi
f0100a85:	53                   	push   %ebx
f0100a86:	83 ec 4c             	sub    $0x4c,%esp
    struct Eipdebuginfo debuginfo;
    struct Eipdebuginfo *info = &debuginfo;

    uint32_t *pebp;
    int i;
    pebp = (uint32_t*)read_ebp();
f0100a89:	89 eb                	mov    %ebp,%ebx
f0100a8b:	bf 00 00 00 00       	mov    $0x0,%edi
    //cprintf("pebp:%p %p\n",pebp, pebp+1);
    for(i = 0; i < 7; i++){
    	cprintf("eip %08x  ebp %p  args %08x %08x %08x %08x %08x\n",*(pebp+1), pebp, *(pebp+2), *(pebp+3), *(pebp+4), *(pebp+5), *(pebp+6));
f0100a90:	8d 73 04             	lea    0x4(%ebx),%esi
f0100a93:	8b 43 18             	mov    0x18(%ebx),%eax
f0100a96:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f0100a9a:	8b 43 14             	mov    0x14(%ebx),%eax
f0100a9d:	89 44 24 18          	mov    %eax,0x18(%esp)
f0100aa1:	8b 43 10             	mov    0x10(%ebx),%eax
f0100aa4:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100aa8:	8b 43 0c             	mov    0xc(%ebx),%eax
f0100aab:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100aaf:	8b 43 08             	mov    0x8(%ebx),%eax
f0100ab2:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100ab6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0100aba:	8b 06                	mov    (%esi),%eax
f0100abc:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ac0:	c7 04 24 dc 23 10 f0 	movl   $0xf01023dc,(%esp)
f0100ac7:	e8 9b 00 00 00       	call   f0100b67 <cprintf>
    	debuginfo_eip(*(pebp+1),info);
f0100acc:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0100acf:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ad3:	8b 06                	mov    (%esi),%eax
f0100ad5:	89 04 24             	mov    %eax,(%esp)
f0100ad8:	e8 f1 01 00 00       	call   f0100cce <debuginfo_eip>
	cprintf("	%s:%d: %s+%d\n",info->eip_file, info->eip_line, info->eip_fn_name, *(pebp+1)-info->eip_fn_addr);
f0100add:	8b 06                	mov    (%esi),%eax
f0100adf:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100ae2:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100ae6:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100ae9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100aed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100af0:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100af4:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0100af7:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100afb:	c7 04 24 86 22 10 f0 	movl   $0xf0102286,(%esp)
f0100b02:	e8 60 00 00 00       	call   f0100b67 <cprintf>
	pebp = (uint32_t*)*(pebp);
f0100b07:	8b 1b                	mov    (%ebx),%ebx

    uint32_t *pebp;
    int i;
    pebp = (uint32_t*)read_ebp();
    //cprintf("pebp:%p %p\n",pebp, pebp+1);
    for(i = 0; i < 7; i++){
f0100b09:	83 c7 01             	add    $0x1,%edi
f0100b0c:	83 ff 07             	cmp    $0x7,%edi
f0100b0f:	0f 85 7b ff ff ff    	jne    f0100a90 <mon_backtrace+0x10>
    	cprintf("eip %08x  ebp %p  args %08x %08x %08x %08x %08x\n",*(pebp+1), pebp, *(pebp+2), *(pebp+3), *(pebp+4), *(pebp+5), *(pebp+6));
    	debuginfo_eip(*(pebp+1),info);
	cprintf("	%s:%d: %s+%d\n",info->eip_file, info->eip_line, info->eip_fn_name, *(pebp+1)-info->eip_fn_addr);
	pebp = (uint32_t*)*(pebp);
    }
    overflow_me();
f0100b15:	e8 01 fd ff ff       	call   f010081b <overflow_me>
    cprintf("Backtrace success\n");
f0100b1a:	c7 04 24 95 22 10 f0 	movl   $0xf0102295,(%esp)
f0100b21:	e8 41 00 00 00       	call   f0100b67 <cprintf>
	return 0;
}
f0100b26:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b2b:	83 c4 4c             	add    $0x4c,%esp
f0100b2e:	5b                   	pop    %ebx
f0100b2f:	5e                   	pop    %esi
f0100b30:	5f                   	pop    %edi
f0100b31:	5d                   	pop    %ebp
f0100b32:	c3                   	ret    
	...

f0100b34 <vcprintf>:
    (*cnt)++;
}

int
vcprintf(const char *fmt, va_list ap)
{
f0100b34:	55                   	push   %ebp
f0100b35:	89 e5                	mov    %esp,%ebp
f0100b37:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f0100b3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);// ap:store the argument inputed by user.
f0100b41:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100b44:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100b48:	8b 45 08             	mov    0x8(%ebp),%eax
f0100b4b:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100b4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100b52:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b56:	c7 04 24 81 0b 10 f0 	movl   $0xf0100b81,(%esp)
f0100b5d:	e8 b5 06 00 00       	call   f0101217 <vprintfmt>
	return cnt;
}
f0100b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100b65:	c9                   	leave  
f0100b66:	c3                   	ret    

f0100b67 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0100b67:	55                   	push   %ebp
f0100b68:	89 e5                	mov    %esp,%ebp
f0100b6a:	83 ec 18             	sub    $0x18,%esp
	vprintfmt((void*)putch, &cnt, fmt, ap);// ap:store the argument inputed by user.
	return cnt;
}

int
cprintf(const char *fmt, ...)
f0100b6d:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
f0100b70:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b74:	8b 45 08             	mov    0x8(%ebp),%eax
f0100b77:	89 04 24             	mov    %eax,(%esp)
f0100b7a:	e8 b5 ff ff ff       	call   f0100b34 <vcprintf>
	
	va_end(ap);
	return cnt;
}
f0100b7f:	c9                   	leave  
f0100b80:	c3                   	ret    

f0100b81 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0100b81:	55                   	push   %ebp
f0100b82:	89 e5                	mov    %esp,%ebp
f0100b84:	53                   	push   %ebx
f0100b85:	83 ec 14             	sub    $0x14,%esp
f0100b88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f0100b8b:	8b 45 08             	mov    0x8(%ebp),%eax
f0100b8e:	89 04 24             	mov    %eax,(%esp)
f0100b91:	e8 f4 f9 ff ff       	call   f010058a <cputchar>
    (*cnt)++;
f0100b96:	83 03 01             	addl   $0x1,(%ebx)
}
f0100b99:	83 c4 14             	add    $0x14,%esp
f0100b9c:	5b                   	pop    %ebx
f0100b9d:	5d                   	pop    %ebp
f0100b9e:	c3                   	ret    
	...

f0100ba0 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0100ba0:	55                   	push   %ebp
f0100ba1:	89 e5                	mov    %esp,%ebp
f0100ba3:	57                   	push   %edi
f0100ba4:	56                   	push   %esi
f0100ba5:	53                   	push   %ebx
f0100ba6:	83 ec 14             	sub    $0x14,%esp
f0100ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100bac:	89 55 e8             	mov    %edx,-0x18(%ebp)
f0100baf:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0100bb2:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0100bb5:	8b 1a                	mov    (%edx),%ebx
f0100bb7:	8b 01                	mov    (%ecx),%eax
f0100bb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	while (l <= r) {
f0100bbc:	39 c3                	cmp    %eax,%ebx
f0100bbe:	0f 8f 9c 00 00 00    	jg     f0100c60 <stab_binsearch+0xc0>
f0100bc4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		int true_m = (l + r) / 2, m = true_m;
f0100bcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0100bce:	01 d8                	add    %ebx,%eax
f0100bd0:	89 c7                	mov    %eax,%edi
f0100bd2:	c1 ef 1f             	shr    $0x1f,%edi
f0100bd5:	01 c7                	add    %eax,%edi
f0100bd7:	d1 ff                	sar    %edi
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0100bd9:	39 df                	cmp    %ebx,%edi
f0100bdb:	7c 33                	jl     f0100c10 <stab_binsearch+0x70>
f0100bdd:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100be0:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0100be3:	0f b6 44 82 04       	movzbl 0x4(%edx,%eax,4),%eax
f0100be8:	39 f0                	cmp    %esi,%eax
f0100bea:	0f 84 bc 00 00 00    	je     f0100cac <stab_binsearch+0x10c>
f0100bf0:	8d 44 7f fd          	lea    -0x3(%edi,%edi,2),%eax
f0100bf4:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx
f0100bf8:	89 f8                	mov    %edi,%eax
			m--;
f0100bfa:	83 e8 01             	sub    $0x1,%eax
	
	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0100bfd:	39 d8                	cmp    %ebx,%eax
f0100bff:	7c 0f                	jl     f0100c10 <stab_binsearch+0x70>
f0100c01:	0f b6 0a             	movzbl (%edx),%ecx
f0100c04:	83 ea 0c             	sub    $0xc,%edx
f0100c07:	39 f1                	cmp    %esi,%ecx
f0100c09:	75 ef                	jne    f0100bfa <stab_binsearch+0x5a>
f0100c0b:	e9 9e 00 00 00       	jmp    f0100cae <stab_binsearch+0x10e>
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0100c10:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0100c13:	eb 3c                	jmp    f0100c51 <stab_binsearch+0xb1>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
f0100c15:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0100c18:	89 01                	mov    %eax,(%ecx)
			l = true_m + 1;
f0100c1a:	8d 5f 01             	lea    0x1(%edi),%ebx
f0100c1d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0100c24:	eb 2b                	jmp    f0100c51 <stab_binsearch+0xb1>
		} else if (stabs[m].n_value > addr) {
f0100c26:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100c29:	76 14                	jbe    f0100c3f <stab_binsearch+0x9f>
			*region_right = m - 1;
f0100c2b:	83 e8 01             	sub    $0x1,%eax
f0100c2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0100c31:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0100c34:	89 02                	mov    %eax,(%edx)
f0100c36:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0100c3d:	eb 12                	jmp    f0100c51 <stab_binsearch+0xb1>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0100c3f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0100c42:	89 01                	mov    %eax,(%ecx)
			l = m;
			addr++;
f0100c44:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0100c48:	89 c3                	mov    %eax,%ebx
f0100c4a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;
	
	while (l <= r) {
f0100c51:	39 5d ec             	cmp    %ebx,-0x14(%ebp)
f0100c54:	0f 8d 71 ff ff ff    	jge    f0100bcb <stab_binsearch+0x2b>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f0100c5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0100c5e:	75 0f                	jne    f0100c6f <stab_binsearch+0xcf>
		*region_right = *region_left - 1;
f0100c60:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0100c63:	8b 03                	mov    (%ebx),%eax
f0100c65:	83 e8 01             	sub    $0x1,%eax
f0100c68:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0100c6b:	89 02                	mov    %eax,(%edx)
f0100c6d:	eb 57                	jmp    f0100cc6 <stab_binsearch+0x126>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100c6f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0100c72:	8b 01                	mov    (%ecx),%eax
		     l > *region_left && stabs[l].n_type != type;
f0100c74:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0100c77:	8b 0b                	mov    (%ebx),%ecx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100c79:	39 c1                	cmp    %eax,%ecx
f0100c7b:	7d 28                	jge    f0100ca5 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f0100c7d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100c80:	8b 5d f0             	mov    -0x10(%ebp),%ebx
f0100c83:	0f b6 54 93 04       	movzbl 0x4(%ebx,%edx,4),%edx
f0100c88:	39 f2                	cmp    %esi,%edx
f0100c8a:	74 19                	je     f0100ca5 <stab_binsearch+0x105>
f0100c8c:	8d 54 40 fd          	lea    -0x3(%eax,%eax,2),%edx
f0100c90:	8d 54 93 04          	lea    0x4(%ebx,%edx,4),%edx
		     l--)
f0100c94:	83 e8 01             	sub    $0x1,%eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100c97:	39 c1                	cmp    %eax,%ecx
f0100c99:	7d 0a                	jge    f0100ca5 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f0100c9b:	0f b6 1a             	movzbl (%edx),%ebx
f0100c9e:	83 ea 0c             	sub    $0xc,%edx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100ca1:	39 f3                	cmp    %esi,%ebx
f0100ca3:	75 ef                	jne    f0100c94 <stab_binsearch+0xf4>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
f0100ca5:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0100ca8:	89 02                	mov    %eax,(%edx)
f0100caa:	eb 1a                	jmp    f0100cc6 <stab_binsearch+0x126>
	}
}
f0100cac:	89 f8                	mov    %edi,%eax
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0100cae:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100cb1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0100cb4:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0100cb8:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100cbb:	0f 82 54 ff ff ff    	jb     f0100c15 <stab_binsearch+0x75>
f0100cc1:	e9 60 ff ff ff       	jmp    f0100c26 <stab_binsearch+0x86>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0100cc6:	83 c4 14             	add    $0x14,%esp
f0100cc9:	5b                   	pop    %ebx
f0100cca:	5e                   	pop    %esi
f0100ccb:	5f                   	pop    %edi
f0100ccc:	5d                   	pop    %ebp
f0100ccd:	c3                   	ret    

f0100cce <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0100cce:	55                   	push   %ebp
f0100ccf:	89 e5                	mov    %esp,%ebp
f0100cd1:	83 ec 48             	sub    $0x48,%esp
f0100cd4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0100cd7:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0100cda:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0100cdd:	8b 75 08             	mov    0x8(%ebp),%esi
f0100ce0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0100ce3:	c7 03 50 24 10 f0    	movl   $0xf0102450,(%ebx)
	info->eip_line = 0;
f0100ce9:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0100cf0:	c7 43 08 50 24 10 f0 	movl   $0xf0102450,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0100cf7:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0100cfe:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0100d01:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0100d08:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0100d0e:	76 12                	jbe    f0100d22 <debuginfo_eip+0x54>
		// Can't search for user-level addresses yet!
  	        panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100d10:	b8 00 84 10 f0       	mov    $0xf0108400,%eax
f0100d15:	3d 15 68 10 f0       	cmp    $0xf0106815,%eax
f0100d1a:	0f 86 b2 01 00 00    	jbe    f0100ed2 <debuginfo_eip+0x204>
f0100d20:	eb 1c                	jmp    f0100d3e <debuginfo_eip+0x70>
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
	} else {
		// Can't search for user-level addresses yet!
  	        panic("User address");
f0100d22:	c7 44 24 08 5a 24 10 	movl   $0xf010245a,0x8(%esp)
f0100d29:	f0 
f0100d2a:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
f0100d31:	00 
f0100d32:	c7 04 24 67 24 10 f0 	movl   $0xf0102467,(%esp)
f0100d39:	e8 47 f3 ff ff       	call   f0100085 <_panic>
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100d3e:	80 3d ff 83 10 f0 00 	cmpb   $0x0,0xf01083ff
f0100d45:	0f 85 87 01 00 00    	jne    f0100ed2 <debuginfo_eip+0x204>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.
	
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0100d4b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0100d52:	b8 14 68 10 f0       	mov    $0xf0106814,%eax
f0100d57:	2d 04 27 10 f0       	sub    $0xf0102704,%eax
f0100d5c:	c1 f8 02             	sar    $0x2,%eax
f0100d5f:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0100d65:	83 e8 01             	sub    $0x1,%eax
f0100d68:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0100d6b:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0100d6e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0100d71:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100d75:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0100d7c:	b8 04 27 10 f0       	mov    $0xf0102704,%eax
f0100d81:	e8 1a fe ff ff       	call   f0100ba0 <stab_binsearch>
	if (lfile == 0)
f0100d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100d89:	85 c0                	test   %eax,%eax
f0100d8b:	0f 84 41 01 00 00    	je     f0100ed2 <debuginfo_eip+0x204>
		return -1;
	
	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0100d91:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0100d94:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100d97:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0100d9a:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0100d9d:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100da0:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100da4:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0100dab:	b8 04 27 10 f0       	mov    $0xf0102704,%eax
f0100db0:	e8 eb fd ff ff       	call   f0100ba0 <stab_binsearch>

	if (lfun <= rfun) {
f0100db5:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100db8:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0100dbb:	7f 3c                	jg     f0100df9 <debuginfo_eip+0x12b>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0100dbd:	6b c0 0c             	imul   $0xc,%eax,%eax
f0100dc0:	8b 80 04 27 10 f0    	mov    -0xfefd8fc(%eax),%eax
f0100dc6:	ba 00 84 10 f0       	mov    $0xf0108400,%edx
f0100dcb:	81 ea 15 68 10 f0    	sub    $0xf0106815,%edx
f0100dd1:	39 d0                	cmp    %edx,%eax
f0100dd3:	73 08                	jae    f0100ddd <debuginfo_eip+0x10f>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0100dd5:	05 15 68 10 f0       	add    $0xf0106815,%eax
f0100dda:	89 43 08             	mov    %eax,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0100ddd:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100de0:	6b d0 0c             	imul   $0xc,%eax,%edx
f0100de3:	8b 92 0c 27 10 f0    	mov    -0xfefd8f4(%edx),%edx
f0100de9:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0100dec:	29 d6                	sub    %edx,%esi
		// Search within the function definition for the line number.
		lline = lfun;
f0100dee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0100df1:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100df4:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100df7:	eb 0f                	jmp    f0100e08 <debuginfo_eip+0x13a>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f0100df9:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f0100dfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100dff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0100e02:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100e05:	89 45 d0             	mov    %eax,-0x30(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0100e08:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f0100e0f:	00 
f0100e10:	8b 43 08             	mov    0x8(%ebx),%eax
f0100e13:	89 04 24             	mov    %eax,(%esp)
f0100e16:	e8 90 0b 00 00       	call   f01019ab <strfind>
f0100e1b:	2b 43 08             	sub    0x8(%ebx),%eax
f0100e1e:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);//N_SLINE:line number in text segment
f0100e21:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0100e24:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0100e27:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100e2b:	c7 04 24 44 00 00 00 	movl   $0x44,(%esp)
f0100e32:	b8 04 27 10 f0       	mov    $0xf0102704,%eax
f0100e37:	e8 64 fd ff ff       	call   f0100ba0 <stab_binsearch>
	if(lline > rline)return -1;
f0100e3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100e3f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f0100e42:	0f 8f 8a 00 00 00    	jg     f0100ed2 <debuginfo_eip+0x204>
	info->eip_line = stabs[lline].n_desc;//line number
f0100e48:	ba 04 27 10 f0       	mov    $0xf0102704,%edx
f0100e4d:	6b c0 0c             	imul   $0xc,%eax,%eax
f0100e50:	0f b7 44 10 06       	movzwl 0x6(%eax,%edx,1),%eax
f0100e55:	89 43 04             	mov    %eax,0x4(%ebx)
	info->eip_file = stabs[lfile].n_strx + stabstr;
f0100e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e5b:	6b c8 0c             	imul   $0xc,%eax,%ecx
f0100e5e:	8b 14 11             	mov    (%ecx,%edx,1),%edx
f0100e61:	81 c2 15 68 10 f0    	add    $0xf0106815,%edx
f0100e67:	89 13                	mov    %edx,(%ebx)
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
f0100e69:	89 c7                	mov    %eax,%edi
f0100e6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100e6e:	6b d0 0c             	imul   $0xc,%eax,%edx
f0100e71:	81 c2 0c 27 10 f0    	add    $0xf010270c,%edx
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100e77:	eb 06                	jmp    f0100e7f <debuginfo_eip+0x1b1>
f0100e79:	83 e8 01             	sub    $0x1,%eax
f0100e7c:	83 ea 0c             	sub    $0xc,%edx
f0100e7f:	89 c6                	mov    %eax,%esi
f0100e81:	39 f8                	cmp    %edi,%eax
f0100e83:	7c 1c                	jl     f0100ea1 <debuginfo_eip+0x1d3>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0100e85:	0f b6 4a fc          	movzbl -0x4(%edx),%ecx
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100e89:	80 f9 84             	cmp    $0x84,%cl
f0100e8c:	74 5d                	je     f0100eeb <debuginfo_eip+0x21d>
f0100e8e:	80 f9 64             	cmp    $0x64,%cl
f0100e91:	75 e6                	jne    f0100e79 <debuginfo_eip+0x1ab>
f0100e93:	83 3a 00             	cmpl   $0x0,(%edx)
f0100e96:	74 e1                	je     f0100e79 <debuginfo_eip+0x1ab>
f0100e98:	eb 51                	jmp    f0100eeb <debuginfo_eip+0x21d>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
		info->eip_file = stabstr + stabs[lline].n_strx;
f0100e9a:	05 15 68 10 f0       	add    $0xf0106815,%eax
f0100e9f:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0100ea1:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100ea4:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0100ea7:	7d 30                	jge    f0100ed9 <debuginfo_eip+0x20b>
		for (lline = lfun + 1;
f0100ea9:	83 c0 01             	add    $0x1,%eax
f0100eac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100eaf:	ba 04 27 10 f0       	mov    $0xf0102704,%edx


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0100eb4:	eb 08                	jmp    f0100ebe <debuginfo_eip+0x1f0>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f0100eb6:	83 43 14 01          	addl   $0x1,0x14(%ebx)
	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
f0100eba:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100ebe:	8b 45 d4             	mov    -0x2c(%ebp),%eax


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0100ec1:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0100ec4:	7d 13                	jge    f0100ed9 <debuginfo_eip+0x20b>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100ec6:	6b c0 0c             	imul   $0xc,%eax,%eax
f0100ec9:	80 7c 10 04 a0       	cmpb   $0xa0,0x4(%eax,%edx,1)
f0100ece:	74 e6                	je     f0100eb6 <debuginfo_eip+0x1e8>
f0100ed0:	eb 07                	jmp    f0100ed9 <debuginfo_eip+0x20b>
f0100ed2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100ed7:	eb 05                	jmp    f0100ede <debuginfo_eip+0x210>
f0100ed9:	b8 00 00 00 00       	mov    $0x0,%eax
		     lline++)
			info->eip_fn_narg++;
	
	return 0;
}
f0100ede:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0100ee1:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0100ee4:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0100ee7:	89 ec                	mov    %ebp,%esp
f0100ee9:	5d                   	pop    %ebp
f0100eea:	c3                   	ret    
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0100eeb:	6b c6 0c             	imul   $0xc,%esi,%eax
f0100eee:	8b 80 04 27 10 f0    	mov    -0xfefd8fc(%eax),%eax
f0100ef4:	ba 00 84 10 f0       	mov    $0xf0108400,%edx
f0100ef9:	81 ea 15 68 10 f0    	sub    $0xf0106815,%edx
f0100eff:	39 d0                	cmp    %edx,%eax
f0100f01:	72 97                	jb     f0100e9a <debuginfo_eip+0x1cc>
f0100f03:	eb 9c                	jmp    f0100ea1 <debuginfo_eip+0x1d3>
	...

f0100f10 <printnum_width>:
};
//left justified 
static void
printnum_width(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc,int *pamnt,int *pcount)
{
f0100f10:	55                   	push   %ebp
f0100f11:	89 e5                	mov    %esp,%ebp
f0100f13:	57                   	push   %edi
f0100f14:	56                   	push   %esi
f0100f15:	53                   	push   %ebx
f0100f16:	83 ec 4c             	sub    $0x4c,%esp
f0100f19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0100f1c:	89 d7                	mov    %edx,%edi
f0100f1e:	8b 45 08             	mov    0x8(%ebp),%eax
f0100f21:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100f24:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100f27:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100f2a:	8b 45 10             	mov    0x10(%ebp),%eax
		int i;
		if(num >= base){
f0100f2d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100f30:	be 00 00 00 00       	mov    $0x0,%esi
f0100f35:	39 d6                	cmp    %edx,%esi
f0100f37:	72 07                	jb     f0100f40 <printnum_width+0x30>
f0100f39:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100f3c:	39 c8                	cmp    %ecx,%eax
f0100f3e:	77 70                	ja     f0100fb0 <printnum_width+0xa0>
			(*pcount)++;
f0100f40:	8b 5d 20             	mov    0x20(%ebp),%ebx
f0100f43:	83 03 01             	addl   $0x1,(%ebx)
			printnum_width(putch, putdat, num / base, base, width - 1, padc, pamnt, pcount);//num/base is used to print the least significant digit
f0100f46:	89 5c 24 18          	mov    %ebx,0x18(%esp)
f0100f4a:	8b 55 1c             	mov    0x1c(%ebp),%edx
f0100f4d:	89 54 24 14          	mov    %edx,0x14(%esp)
f0100f51:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0100f54:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0100f58:	8b 55 14             	mov    0x14(%ebp),%edx
f0100f5b:	83 ea 01             	sub    $0x1,%edx
f0100f5e:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100f62:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100f66:	8b 44 24 08          	mov    0x8(%esp),%eax
f0100f6a:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0100f6e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100f71:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0100f74:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100f77:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100f7b:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0100f7f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100f82:	89 0c 24             	mov    %ecx,(%esp)
f0100f85:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100f88:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100f8c:	e8 af 0c 00 00       	call   f0101c40 <__udivdi3>
f0100f91:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0100f94:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0100f97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0100f9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0100f9f:	89 04 24             	mov    %eax,(%esp)
f0100fa2:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100fa6:	89 fa                	mov    %edi,%edx
f0100fa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100fab:	e8 60 ff ff ff       	call   f0100f10 <printnum_width>
		}
		putch("0123456789abcdef"[num % base], putdat);
f0100fb0:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100fb4:	8b 04 24             	mov    (%esp),%eax
f0100fb7:	8b 54 24 04          	mov    0x4(%esp),%edx
f0100fbb:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100fbe:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0100fc1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100fc4:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100fc8:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0100fcc:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100fcf:	89 0c 24             	mov    %ecx,(%esp)
f0100fd2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100fd5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100fd9:	e8 92 0d 00 00       	call   f0101d70 <__umoddi3>
f0100fde:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0100fe1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0100fe5:	0f be 80 75 24 10 f0 	movsbl -0xfefdb8b(%eax),%eax
f0100fec:	89 04 24             	mov    %eax,(%esp)
f0100fef:	ff 55 e4             	call   *-0x1c(%ebp)
		(*pamnt)++;//record the times of print operation
f0100ff2:	8b 4d 1c             	mov    0x1c(%ebp),%ecx
f0100ff5:	8b 01                	mov    (%ecx),%eax
f0100ff7:	83 c0 01             	add    $0x1,%eax
f0100ffa:	89 01                	mov    %eax,(%ecx)
		if( *pamnt == (*pcount + 1) ){
f0100ffc:	8b 5d 20             	mov    0x20(%ebp),%ebx
f0100fff:	8b 13                	mov    (%ebx),%edx
f0101001:	83 c2 01             	add    $0x1,%edx
f0101004:	39 d0                	cmp    %edx,%eax
f0101006:	75 2e                	jne    f0101036 <printnum_width+0x126>
			if( width > *pamnt ){
f0101008:	39 45 14             	cmp    %eax,0x14(%ebp)
f010100b:	7e 29                	jle    f0101036 <printnum_width+0x126>
				for( i = 0; i < width - *pamnt;  i++){
f010100d:	8b 55 14             	mov    0x14(%ebp),%edx
f0101010:	29 c2                	sub    %eax,%edx
f0101012:	85 d2                	test   %edx,%edx
f0101014:	7e 20                	jle    f0101036 <printnum_width+0x126>
f0101016:	be 00 00 00 00       	mov    $0x0,%esi
f010101b:	89 cb                	mov    %ecx,%ebx
					putch(padc, putdat);
f010101d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101021:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0101024:	89 0c 24             	mov    %ecx,(%esp)
f0101027:	ff 55 e4             	call   *-0x1c(%ebp)
		}
		putch("0123456789abcdef"[num % base], putdat);
		(*pamnt)++;//record the times of print operation
		if( *pamnt == (*pcount + 1) ){
			if( width > *pamnt ){
				for( i = 0; i < width - *pamnt;  i++){
f010102a:	83 c6 01             	add    $0x1,%esi
f010102d:	8b 45 14             	mov    0x14(%ebp),%eax
f0101030:	2b 03                	sub    (%ebx),%eax
f0101032:	39 f0                	cmp    %esi,%eax
f0101034:	7f e7                	jg     f010101d <printnum_width+0x10d>
					putch(padc, putdat);
				}	
			}
        	}
		return;
}
f0101036:	83 c4 4c             	add    $0x4c,%esp
f0101039:	5b                   	pop    %ebx
f010103a:	5e                   	pop    %esi
f010103b:	5f                   	pop    %edi
f010103c:	5d                   	pop    %ebp
f010103d:	c3                   	ret    

f010103e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f010103e:	55                   	push   %ebp
f010103f:	89 e5                	mov    %esp,%ebp
f0101041:	57                   	push   %edi
f0101042:	56                   	push   %esi
f0101043:	53                   	push   %ebx
f0101044:	83 ec 5c             	sub    $0x5c,%esp
f0101047:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010104a:	89 d6                	mov    %edx,%esi
f010104c:	8b 45 08             	mov    0x8(%ebp),%eax
f010104f:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101052:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101055:	89 55 d0             	mov    %edx,-0x30(%ebp)
f0101058:	8b 55 10             	mov    0x10(%ebp),%edx
f010105b:	8b 5d 14             	mov    0x14(%ebp),%ebx
f010105e:	8b 7d 18             	mov    0x18(%ebp),%edi
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	int amnt = 0, count = 0; 
f0101061:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0101068:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	if( padc != '0'){
f010106f:	83 ff 30             	cmp    $0x30,%edi
f0101072:	74 42                	je     f01010b6 <printnum+0x78>
		if( 9 > width && width > 0 ){
f0101074:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0101077:	83 f8 07             	cmp    $0x7,%eax
f010107a:	77 3a                	ja     f01010b6 <printnum+0x78>
			padc = ' ';
			printnum_width(putch, putdat, num, base, width, padc, &amnt, &count);
f010107c:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010107f:	89 44 24 18          	mov    %eax,0x18(%esp)
f0101083:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101086:	89 44 24 14          	mov    %eax,0x14(%esp)
f010108a:	c7 44 24 10 20 00 00 	movl   $0x20,0x10(%esp)
f0101091:	00 
f0101092:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0101096:	89 54 24 08          	mov    %edx,0x8(%esp)
f010109a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010109d:	89 0c 24             	mov    %ecx,(%esp)
f01010a0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f01010a3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01010a7:	89 f2                	mov    %esi,%edx
f01010a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01010ac:	e8 5f fe ff ff       	call   f0100f10 <printnum_width>
			return;
f01010b1:	e9 c8 00 00 00       	jmp    f010117e <printnum+0x140>
		}
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f01010b6:	89 55 c8             	mov    %edx,-0x38(%ebp)
f01010b9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f01010bd:	77 15                	ja     f01010d4 <printnum+0x96>
f01010bf:	90                   	nop
f01010c0:	72 05                	jb     f01010c7 <printnum+0x89>
f01010c2:	39 55 cc             	cmp    %edx,-0x34(%ebp)
f01010c5:	73 0d                	jae    f01010d4 <printnum+0x96>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
f01010c7:	83 eb 01             	sub    $0x1,%ebx
f01010ca:	85 db                	test   %ebx,%ebx
f01010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01010d0:	7f 61                	jg     f0101133 <printnum+0xf5>
f01010d2:	eb 70                	jmp    f0101144 <printnum+0x106>
			return;
		}
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
f01010d4:	89 7c 24 10          	mov    %edi,0x10(%esp)
f01010d8:	83 eb 01             	sub    $0x1,%ebx
f01010db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f01010df:	89 54 24 08          	mov    %edx,0x8(%esp)
f01010e3:	8b 44 24 08          	mov    0x8(%esp),%eax
f01010e7:	8b 54 24 0c          	mov    0xc(%esp),%edx
f01010eb:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01010ee:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f01010f1:	8b 55 c8             	mov    -0x38(%ebp),%edx
f01010f4:	89 54 24 08          	mov    %edx,0x8(%esp)
f01010f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f01010ff:	00 
f0101100:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0101103:	89 0c 24             	mov    %ecx,(%esp)
f0101106:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0101109:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010110d:	e8 2e 0b 00 00       	call   f0101c40 <__udivdi3>
f0101112:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0101115:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0101118:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010111c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0101120:	89 04 24             	mov    %eax,(%esp)
f0101123:	89 54 24 04          	mov    %edx,0x4(%esp)
f0101127:	89 f2                	mov    %esi,%edx
f0101129:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010112c:	e8 0d ff ff ff       	call   f010103e <printnum>
f0101131:	eb 11                	jmp    f0101144 <printnum+0x106>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
			putch(padc, putdat);
f0101133:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101137:	89 3c 24             	mov    %edi,(%esp)
f010113a:	ff 55 d4             	call   *-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
f010113d:	83 eb 01             	sub    $0x1,%ebx
f0101140:	85 db                	test   %ebx,%ebx
f0101142:	7f ef                	jg     f0101133 <printnum+0xf5>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit// highest digit
	putch("0123456789abcdef"[num % base], putdat);
f0101144:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101148:	8b 74 24 04          	mov    0x4(%esp),%esi
f010114c:	8b 45 c8             	mov    -0x38(%ebp),%eax
f010114f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101153:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f010115a:	00 
f010115b:	8b 55 cc             	mov    -0x34(%ebp),%edx
f010115e:	89 14 24             	mov    %edx,(%esp)
f0101161:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0101164:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0101168:	e8 03 0c 00 00       	call   f0101d70 <__umoddi3>
f010116d:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101171:	0f be 80 75 24 10 f0 	movsbl -0xfefdb8b(%eax),%eax
f0101178:	89 04 24             	mov    %eax,(%esp)
f010117b:	ff 55 d4             	call   *-0x2c(%ebp)
}
f010117e:	83 c4 5c             	add    $0x5c,%esp
f0101181:	5b                   	pop    %ebx
f0101182:	5e                   	pop    %esi
f0101183:	5f                   	pop    %edi
f0101184:	5d                   	pop    %ebp
f0101185:	c3                   	ret    

f0101186 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f0101186:	55                   	push   %ebp
f0101187:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0101189:	83 fa 01             	cmp    $0x1,%edx
f010118c:	7e 0e                	jle    f010119c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
f010118e:	8b 10                	mov    (%eax),%edx
f0101190:	8d 4a 08             	lea    0x8(%edx),%ecx
f0101193:	89 08                	mov    %ecx,(%eax)
f0101195:	8b 02                	mov    (%edx),%eax
f0101197:	8b 52 04             	mov    0x4(%edx),%edx
f010119a:	eb 22                	jmp    f01011be <getuint+0x38>
	else if (lflag)
f010119c:	85 d2                	test   %edx,%edx
f010119e:	74 10                	je     f01011b0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
f01011a0:	8b 10                	mov    (%eax),%edx
f01011a2:	8d 4a 04             	lea    0x4(%edx),%ecx
f01011a5:	89 08                	mov    %ecx,(%eax)
f01011a7:	8b 02                	mov    (%edx),%eax
f01011a9:	ba 00 00 00 00       	mov    $0x0,%edx
f01011ae:	eb 0e                	jmp    f01011be <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
f01011b0:	8b 10                	mov    (%eax),%edx
f01011b2:	8d 4a 04             	lea    0x4(%edx),%ecx
f01011b5:	89 08                	mov    %ecx,(%eax)
f01011b7:	8b 02                	mov    (%edx),%eax
f01011b9:	ba 00 00 00 00       	mov    $0x0,%edx
}
f01011be:	5d                   	pop    %ebp
f01011bf:	c3                   	ret    

f01011c0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
f01011c0:	55                   	push   %ebp
f01011c1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f01011c3:	83 fa 01             	cmp    $0x1,%edx
f01011c6:	7e 0e                	jle    f01011d6 <getint+0x16>
		return va_arg(*ap, long long);
f01011c8:	8b 10                	mov    (%eax),%edx
f01011ca:	8d 4a 08             	lea    0x8(%edx),%ecx
f01011cd:	89 08                	mov    %ecx,(%eax)
f01011cf:	8b 02                	mov    (%edx),%eax
f01011d1:	8b 52 04             	mov    0x4(%edx),%edx
f01011d4:	eb 22                	jmp    f01011f8 <getint+0x38>
	else if (lflag)
f01011d6:	85 d2                	test   %edx,%edx
f01011d8:	74 10                	je     f01011ea <getint+0x2a>
		return va_arg(*ap, long);
f01011da:	8b 10                	mov    (%eax),%edx
f01011dc:	8d 4a 04             	lea    0x4(%edx),%ecx
f01011df:	89 08                	mov    %ecx,(%eax)
f01011e1:	8b 02                	mov    (%edx),%eax
f01011e3:	89 c2                	mov    %eax,%edx
f01011e5:	c1 fa 1f             	sar    $0x1f,%edx
f01011e8:	eb 0e                	jmp    f01011f8 <getint+0x38>
	else
		return va_arg(*ap, int);
f01011ea:	8b 10                	mov    (%eax),%edx
f01011ec:	8d 4a 04             	lea    0x4(%edx),%ecx
f01011ef:	89 08                	mov    %ecx,(%eax)
f01011f1:	8b 02                	mov    (%edx),%eax
f01011f3:	89 c2                	mov    %eax,%edx
f01011f5:	c1 fa 1f             	sar    $0x1f,%edx
}
f01011f8:	5d                   	pop    %ebp
f01011f9:	c3                   	ret    

f01011fa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f01011fa:	55                   	push   %ebp
f01011fb:	89 e5                	mov    %esp,%ebp
f01011fd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0101200:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0101204:	8b 10                	mov    (%eax),%edx
f0101206:	3b 50 04             	cmp    0x4(%eax),%edx
f0101209:	73 0a                	jae    f0101215 <sprintputch+0x1b>
		*b->buf++ = ch;
f010120b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010120e:	88 0a                	mov    %cl,(%edx)
f0101210:	83 c2 01             	add    $0x1,%edx
f0101213:	89 10                	mov    %edx,(%eax)
}
f0101215:	5d                   	pop    %ebp
f0101216:	c3                   	ret    

f0101217 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f0101217:	55                   	push   %ebp
f0101218:	89 e5                	mov    %esp,%ebp
f010121a:	57                   	push   %edi
f010121b:	56                   	push   %esi
f010121c:	53                   	push   %ebx
f010121d:	83 ec 5c             	sub    $0x5c,%esp
f0101220:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0101223:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
f0101226:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
f010122d:	eb 17                	jmp    f0101246 <vprintfmt+0x2f>
	int base, lflag, width, precision, altflag;
	char padc;
	//putdata: the total amount of characters having been printed now
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f010122f:	85 c0                	test   %eax,%eax
f0101231:	0f 84 5e 04 00 00    	je     f0101695 <vprintfmt+0x47e>
				return;
			putch(ch, putdat);
f0101237:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010123b:	89 04 24             	mov    %eax,(%esp)
f010123e:	ff 55 08             	call   *0x8(%ebp)
f0101241:	eb 03                	jmp    f0101246 <vprintfmt+0x2f>
f0101243:	8b 5d cc             	mov    -0x34(%ebp),%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	//putdata: the total amount of characters having been printed now
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0101246:	0f b6 03             	movzbl (%ebx),%eax
f0101249:	83 c3 01             	add    $0x1,%ebx
f010124c:	83 f8 25             	cmp    $0x25,%eax
f010124f:	75 de                	jne    f010122f <vprintfmt+0x18>
f0101251:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f0101258:	c6 45 d0 20          	movb   $0x20,-0x30(%ebp)
f010125c:	be ff ff ff ff       	mov    $0xffffffff,%esi
f0101261:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
f0101268:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010126f:	eb 06                	jmp    f0101277 <vprintfmt+0x60>
f0101271:	c6 45 d0 2d          	movb   $0x2d,-0x30(%ebp)
f0101275:	89 cb                	mov    %ecx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0101277:	0f b6 03             	movzbl (%ebx),%eax
f010127a:	0f b6 d0             	movzbl %al,%edx
f010127d:	8d 4b 01             	lea    0x1(%ebx),%ecx
f0101280:	83 e8 23             	sub    $0x23,%eax
f0101283:	3c 55                	cmp    $0x55,%al
f0101285:	0f 87 ec 03 00 00    	ja     f0101677 <vprintfmt+0x460>
f010128b:	0f b6 c0             	movzbl %al,%eax
f010128e:	ff 24 85 80 25 10 f0 	jmp    *-0xfefda80(,%eax,4)
f0101295:	c6 45 d0 30          	movb   $0x30,-0x30(%ebp)
f0101299:	eb da                	jmp    f0101275 <vprintfmt+0x5e>
		case '8':
			width = 8;
			goto reswitch;
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f010129b:	8d 72 d0             	lea    -0x30(%edx),%esi
				ch = *fmt;
f010129e:	0f be 01             	movsbl (%ecx),%eax
				if (ch < '0' || ch > '9')
f01012a1:	8d 50 d0             	lea    -0x30(%eax),%edx
f01012a4:	83 fa 09             	cmp    $0x9,%edx
f01012a7:	76 0b                	jbe    f01012b4 <vprintfmt+0x9d>
f01012a9:	eb 43                	jmp    f01012ee <vprintfmt+0xd7>
f01012ab:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%ebp)
		case '5':
		case '6':
		case '7':
		case '8':
			width = 8;
			goto reswitch;
f01012b2:	eb c1                	jmp    f0101275 <vprintfmt+0x5e>
		case '9':
			for (precision = 0; ; ++fmt) {
f01012b4:	83 c1 01             	add    $0x1,%ecx
				precision = precision * 10 + ch - '0';
f01012b7:	8d 14 b6             	lea    (%esi,%esi,4),%edx
f01012ba:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
f01012be:	0f be 01             	movsbl (%ecx),%eax
				if (ch < '0' || ch > '9')
f01012c1:	8d 50 d0             	lea    -0x30(%eax),%edx
f01012c4:	83 fa 09             	cmp    $0x9,%edx
f01012c7:	76 eb                	jbe    f01012b4 <vprintfmt+0x9d>
f01012c9:	eb 23                	jmp    f01012ee <vprintfmt+0xd7>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f01012cb:	8b 45 14             	mov    0x14(%ebp),%eax
f01012ce:	8d 50 04             	lea    0x4(%eax),%edx
f01012d1:	89 55 14             	mov    %edx,0x14(%ebp)
f01012d4:	8b 30                	mov    (%eax),%esi
			goto process_precision;
f01012d6:	eb 16                	jmp    f01012ee <vprintfmt+0xd7>

		case '.':
			if (width < 0)
f01012d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01012db:	c1 f8 1f             	sar    $0x1f,%eax
f01012de:	f7 d0                	not    %eax
f01012e0:	21 45 e4             	and    %eax,-0x1c(%ebp)
f01012e3:	eb 90                	jmp    f0101275 <vprintfmt+0x5e>
f01012e5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
f01012ec:	eb 87                	jmp    f0101275 <vprintfmt+0x5e>

		process_precision:
			if (width < 0)
f01012ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01012f2:	79 81                	jns    f0101275 <vprintfmt+0x5e>
f01012f4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f01012f7:	8b 75 c8             	mov    -0x38(%ebp),%esi
f01012fa:	e9 76 ff ff ff       	jmp    f0101275 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f01012ff:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
f0101303:	e9 6d ff ff ff       	jmp    f0101275 <vprintfmt+0x5e>
f0101308:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f010130b:	8b 45 14             	mov    0x14(%ebp),%eax
f010130e:	8d 50 04             	lea    0x4(%eax),%edx
f0101311:	89 55 14             	mov    %edx,0x14(%ebp)
f0101314:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101318:	8b 00                	mov    (%eax),%eax
f010131a:	89 04 24             	mov    %eax,(%esp)
f010131d:	ff 55 08             	call   *0x8(%ebp)
f0101320:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f0101323:	e9 1e ff ff ff       	jmp    f0101246 <vprintfmt+0x2f>
f0101328:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
f010132b:	8b 45 14             	mov    0x14(%ebp),%eax
f010132e:	8d 50 04             	lea    0x4(%eax),%edx
f0101331:	89 55 14             	mov    %edx,0x14(%ebp)
f0101334:	8b 00                	mov    (%eax),%eax
f0101336:	89 c2                	mov    %eax,%edx
f0101338:	c1 fa 1f             	sar    $0x1f,%edx
f010133b:	31 d0                	xor    %edx,%eax
f010133d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f010133f:	83 f8 06             	cmp    $0x6,%eax
f0101342:	7f 0b                	jg     f010134f <vprintfmt+0x138>
f0101344:	8b 14 85 d8 26 10 f0 	mov    -0xfefd928(,%eax,4),%edx
f010134b:	85 d2                	test   %edx,%edx
f010134d:	75 23                	jne    f0101372 <vprintfmt+0x15b>
				printfmt(putch, putdat, "error %d", err);
f010134f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101353:	c7 44 24 08 86 24 10 	movl   $0xf0102486,0x8(%esp)
f010135a:	f0 
f010135b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010135f:	8b 45 08             	mov    0x8(%ebp),%eax
f0101362:	89 04 24             	mov    %eax,(%esp)
f0101365:	e8 b3 03 00 00       	call   f010171d <printfmt>
f010136a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f010136d:	e9 d4 fe ff ff       	jmp    f0101246 <vprintfmt+0x2f>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
f0101372:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0101376:	c7 44 24 08 8f 24 10 	movl   $0xf010248f,0x8(%esp)
f010137d:	f0 
f010137e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101382:	8b 55 08             	mov    0x8(%ebp),%edx
f0101385:	89 14 24             	mov    %edx,(%esp)
f0101388:	e8 90 03 00 00       	call   f010171d <printfmt>
f010138d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0101390:	e9 b1 fe ff ff       	jmp    f0101246 <vprintfmt+0x2f>
f0101395:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f0101398:	89 cb                	mov    %ecx,%ebx
f010139a:	89 f1                	mov    %esi,%ecx
f010139c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010139f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f01013a2:	8b 45 14             	mov    0x14(%ebp),%eax
f01013a5:	8d 50 04             	lea    0x4(%eax),%edx
f01013a8:	89 55 14             	mov    %edx,0x14(%ebp)
f01013ab:	8b 00                	mov    (%eax),%eax
f01013ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01013b0:	85 c0                	test   %eax,%eax
f01013b2:	75 07                	jne    f01013bb <vprintfmt+0x1a4>
f01013b4:	c7 45 d4 92 24 10 f0 	movl   $0xf0102492,-0x2c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
f01013bb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f01013bf:	7e 06                	jle    f01013c7 <vprintfmt+0x1b0>
f01013c1:	80 7d d0 2d          	cmpb   $0x2d,-0x30(%ebp)
f01013c5:	75 13                	jne    f01013da <vprintfmt+0x1c3>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f01013c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01013ca:	0f be 02             	movsbl (%edx),%eax
f01013cd:	85 c0                	test   %eax,%eax
f01013cf:	0f 85 95 00 00 00    	jne    f010146a <vprintfmt+0x253>
f01013d5:	e9 85 00 00 00       	jmp    f010145f <vprintfmt+0x248>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f01013da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f01013de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01013e1:	89 04 24             	mov    %eax,(%esp)
f01013e4:	e8 62 04 00 00       	call   f010184b <strnlen>
f01013e9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f01013ec:	29 c2                	sub    %eax,%edx
f01013ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01013f1:	85 d2                	test   %edx,%edx
f01013f3:	7e d2                	jle    f01013c7 <vprintfmt+0x1b0>
					putch(padc, putdat);
f01013f5:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
f01013f9:	89 75 c4             	mov    %esi,-0x3c(%ebp)
f01013fc:	89 5d c0             	mov    %ebx,-0x40(%ebp)
f01013ff:	89 d3                	mov    %edx,%ebx
f0101401:	89 c6                	mov    %eax,%esi
f0101403:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101407:	89 34 24             	mov    %esi,(%esp)
f010140a:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f010140d:	83 eb 01             	sub    $0x1,%ebx
f0101410:	85 db                	test   %ebx,%ebx
f0101412:	7f ef                	jg     f0101403 <vprintfmt+0x1ec>
f0101414:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0101417:	8b 5d c0             	mov    -0x40(%ebp),%ebx
f010141a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0101421:	eb a4                	jmp    f01013c7 <vprintfmt+0x1b0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f0101423:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0101427:	74 19                	je     f0101442 <vprintfmt+0x22b>
f0101429:	8d 50 e0             	lea    -0x20(%eax),%edx
f010142c:	83 fa 5e             	cmp    $0x5e,%edx
f010142f:	76 11                	jbe    f0101442 <vprintfmt+0x22b>
					putch('?', putdat);
f0101431:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101435:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f010143c:	ff 55 08             	call   *0x8(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f010143f:	90                   	nop
f0101440:	eb 0a                	jmp    f010144c <vprintfmt+0x235>
					putch('?', putdat);
				else
					putch(ch, putdat);
f0101442:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101446:	89 04 24             	mov    %eax,(%esp)
f0101449:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010144c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
f0101450:	0f be 03             	movsbl (%ebx),%eax
f0101453:	85 c0                	test   %eax,%eax
f0101455:	74 05                	je     f010145c <vprintfmt+0x245>
f0101457:	83 c3 01             	add    $0x1,%ebx
f010145a:	eb 19                	jmp    f0101475 <vprintfmt+0x25e>
f010145c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f010145f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0101463:	7f 1e                	jg     f0101483 <vprintfmt+0x26c>
f0101465:	e9 d9 fd ff ff       	jmp    f0101243 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010146a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010146d:	83 c2 01             	add    $0x1,%edx
f0101470:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
f0101473:	89 d3                	mov    %edx,%ebx
f0101475:	85 f6                	test   %esi,%esi
f0101477:	78 aa                	js     f0101423 <vprintfmt+0x20c>
f0101479:	83 ee 01             	sub    $0x1,%esi
f010147c:	79 a5                	jns    f0101423 <vprintfmt+0x20c>
f010147e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101481:	eb dc                	jmp    f010145f <vprintfmt+0x248>
f0101483:	8b 75 08             	mov    0x8(%ebp),%esi
f0101486:	89 5d d8             	mov    %ebx,-0x28(%ebp)
f0101489:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f010148c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101490:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0101497:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0101499:	83 eb 01             	sub    $0x1,%ebx
f010149c:	85 db                	test   %ebx,%ebx
f010149e:	7f ec                	jg     f010148c <vprintfmt+0x275>
f01014a0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f01014a3:	e9 9e fd ff ff       	jmp    f0101246 <vprintfmt+0x2f>
f01014a8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);//different data type
f01014ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01014ae:	8d 45 14             	lea    0x14(%ebp),%eax
f01014b1:	e8 0a fd ff ff       	call   f01011c0 <getint>
f01014b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01014b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01014bc:	89 c3                	mov    %eax,%ebx
f01014be:	89 d6                	mov    %edx,%esi
f01014c0:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
f01014c5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01014c9:	0f 89 b2 00 00 00    	jns    f0101581 <vprintfmt+0x36a>
				putch('-', putdat);
f01014cf:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01014d3:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f01014da:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f01014dd:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f01014e0:	8b 75 dc             	mov    -0x24(%ebp),%esi
f01014e3:	f7 db                	neg    %ebx
f01014e5:	83 d6 00             	adc    $0x0,%esi
f01014e8:	f7 de                	neg    %esi
f01014ea:	ba 0a 00 00 00       	mov    $0xa,%edx
f01014ef:	e9 8d 00 00 00       	jmp    f0101581 <vprintfmt+0x36a>
f01014f4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f01014f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01014fa:	8d 45 14             	lea    0x14(%ebp),%eax
f01014fd:	e8 84 fc ff ff       	call   f0101186 <getuint>
f0101502:	89 c3                	mov    %eax,%ebx
f0101504:	89 d6                	mov    %edx,%esi
f0101506:	ba 0a 00 00 00       	mov    $0xa,%edx
			base = 10;
			goto number;
f010150b:	eb 74                	jmp    f0101581 <vprintfmt+0x36a>
f010150d:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			// display a number in octal form and the form should begin with '0'
			putch('0', putdat);
f0101510:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101514:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f010151b:	ff 55 08             	call   *0x8(%ebp)
			num = getuint(&ap, lflag);
f010151e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101521:	8d 45 14             	lea    0x14(%ebp),%eax
f0101524:	e8 5d fc ff ff       	call   f0101186 <getuint>
f0101529:	89 c3                	mov    %eax,%ebx
f010152b:	89 d6                	mov    %edx,%esi
f010152d:	ba 08 00 00 00       	mov    $0x8,%edx
			base = 8;
			goto number;
f0101532:	eb 4d                	jmp    f0101581 <vprintfmt+0x36a>
f0101534:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
f0101537:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010153b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f0101542:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f0101545:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101549:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f0101550:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
f0101553:	8b 45 14             	mov    0x14(%ebp),%eax
f0101556:	8d 50 04             	lea    0x4(%eax),%edx
f0101559:	89 55 14             	mov    %edx,0x14(%ebp)
f010155c:	8b 18                	mov    (%eax),%ebx
f010155e:	be 00 00 00 00       	mov    $0x0,%esi
f0101563:	ba 10 00 00 00       	mov    $0x10,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
f0101568:	eb 17                	jmp    f0101581 <vprintfmt+0x36a>
f010156a:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':

			num = getuint(&ap, lflag);
f010156d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101570:	8d 45 14             	lea    0x14(%ebp),%eax
f0101573:	e8 0e fc ff ff       	call   f0101186 <getuint>
f0101578:	89 c3                	mov    %eax,%ebx
f010157a:	89 d6                	mov    %edx,%esi
f010157c:	ba 10 00 00 00       	mov    $0x10,%edx
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
f0101581:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
f0101585:	89 44 24 10          	mov    %eax,0x10(%esp)
f0101589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010158c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101590:	89 54 24 08          	mov    %edx,0x8(%esp)
f0101594:	89 1c 24             	mov    %ebx,(%esp)
f0101597:	89 74 24 04          	mov    %esi,0x4(%esp)
f010159b:	89 fa                	mov    %edi,%edx
f010159d:	8b 45 08             	mov    0x8(%ebp),%eax
f01015a0:	e8 99 fa ff ff       	call   f010103e <printnum>
f01015a5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f01015a8:	e9 99 fc ff ff       	jmp    f0101246 <vprintfmt+0x2f>
f01015ad:	89 4d cc             	mov    %ecx,-0x34(%ebp)
            //        can represent.

            const char *null_error = "\nerror! writing through NULL pointer! (%n argument)\n";
            const char *overflow_error = "\nwarning! The value %n argument pointed to has been overflowed!\n";
            // Your code here
	    q = va_arg(ap, char *);//after call va_arg(), it will point to next argument
f01015b0:	8b 45 14             	mov    0x14(%ebp),%eax
f01015b3:	8d 50 04             	lea    0x4(%eax),%edx
f01015b6:	89 55 14             	mov    %edx,0x14(%ebp)
f01015b9:	8b 30                	mov    (%eax),%esi
	    if ( q == NULL ){
f01015bb:	85 f6                	test   %esi,%esi
f01015bd:	75 21                	jne    f01015e0 <vprintfmt+0x3c9>
f01015bf:	bb 05 25 10 f0       	mov    $0xf0102505,%ebx
f01015c4:	b8 0a 00 00 00       	mov    $0xa,%eax
		while ((ch = *null_error++) != '\0') {
                        cputchar(ch);
f01015c9:	89 04 24             	mov    %eax,(%esp)
f01015cc:	e8 b9 ef ff ff       	call   f010058a <cputchar>
            const char *null_error = "\nerror! writing through NULL pointer! (%n argument)\n";
            const char *overflow_error = "\nwarning! The value %n argument pointed to has been overflowed!\n";
            // Your code here
	    q = va_arg(ap, char *);//after call va_arg(), it will point to next argument
	    if ( q == NULL ){
		while ((ch = *null_error++) != '\0') {
f01015d1:	0f be 03             	movsbl (%ebx),%eax
f01015d4:	83 c3 01             	add    $0x1,%ebx
f01015d7:	85 c0                	test   %eax,%eax
f01015d9:	75 ee                	jne    f01015c9 <vprintfmt+0x3b2>
f01015db:	e9 63 fc ff ff       	jmp    f0101243 <vprintfmt+0x2c>
                        cputchar(ch);
                }
	    	break;
	    }
	    if ( *(unsigned char *)putdat >= 255 ){//why did it can't be 255?  
f01015e0:	80 3f ff             	cmpb   $0xff,(%edi)
f01015e3:	75 27                	jne    f010160c <vprintfmt+0x3f5>
f01015e5:	bb 3d 25 10 f0       	mov    $0xf010253d,%ebx
f01015ea:	b8 0a 00 00 00       	mov    $0xa,%eax
		while ((ch = *(char *) overflow_error++) != '\0') {
                        cputchar(ch);
f01015ef:	89 04 24             	mov    %eax,(%esp)
f01015f2:	e8 93 ef ff ff       	call   f010058a <cputchar>
                        cputchar(ch);
                }
	    	break;
	    }
	    if ( *(unsigned char *)putdat >= 255 ){//why did it can't be 255?  
		while ((ch = *(char *) overflow_error++) != '\0') {
f01015f7:	0f be 03             	movsbl (%ebx),%eax
f01015fa:	83 c3 01             	add    $0x1,%ebx
f01015fd:	85 c0                	test   %eax,%eax
f01015ff:	75 ee                	jne    f01015ef <vprintfmt+0x3d8>
                        cputchar(ch);
                }
		*q = -1;
f0101601:	c6 06 ff             	movb   $0xff,(%esi)
f0101604:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		break;
f0101607:	e9 3a fc ff ff       	jmp    f0101246 <vprintfmt+0x2f>
	    }
 	    *q = *(char *)putdat;
f010160c:	0f b6 07             	movzbl (%edi),%eax
f010160f:	88 06                	mov    %al,(%esi)
f0101611:	8b 5d cc             	mov    -0x34(%ebp),%ebx
            break;
f0101614:	e9 2d fc ff ff       	jmp    f0101246 <vprintfmt+0x2f>
f0101619:	89 4d cc             	mov    %ecx,-0x34(%ebp)
        }
		// escaped '%' character
		case '%':
			putch(ch, putdat);
f010161c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101620:	89 14 24             	mov    %edx,(%esp)
f0101623:	ff 55 08             	call   *0x8(%ebp)
f0101626:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f0101629:	e9 18 fc ff ff       	jmp    f0101246 <vprintfmt+0x2f>
f010162e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
			
		// unrecognized escape sequence - just print it literally
		//precede the result with a plus or minus sign (+ or -) even for positive numbers-added by tww
		case '+':
			num = getint(&ap, lflag);//after call getint(),the argument will go to next
f0101631:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101634:	8d 45 14             	lea    0x14(%ebp),%eax
f0101637:	e8 84 fb ff ff       	call   f01011c0 <getint>
f010163c:	89 c3                	mov    %eax,%ebx
f010163e:	89 d6                	mov    %edx,%esi
		        if ((long long) num < 0) {
f0101640:	85 d2                	test   %edx,%edx
f0101642:	79 17                	jns    f010165b <vprintfmt+0x444>
				putch('-', putdat);
f0101644:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101648:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f010164f:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f0101652:	f7 db                	neg    %ebx
f0101654:	83 d6 00             	adc    $0x0,%esi
f0101657:	f7 de                	neg    %esi
f0101659:	eb 0e                	jmp    f0101669 <vprintfmt+0x452>
			}
			else{
				putch('+', putdat);
f010165b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010165f:	c7 04 24 2b 00 00 00 	movl   $0x2b,(%esp)
f0101666:	ff 55 08             	call   *0x8(%ebp)
			}
			base = 10;
			fmt++;
f0101669:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
f010166d:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
f0101672:	e9 0a ff ff ff       	jmp    f0101581 <vprintfmt+0x36a>
		default:
			putch('%', putdat);
f0101677:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010167b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0101682:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f0101685:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0101688:	80 38 25             	cmpb   $0x25,(%eax)
f010168b:	0f 84 b5 fb ff ff    	je     f0101246 <vprintfmt+0x2f>
f0101691:	89 c3                	mov    %eax,%ebx
f0101693:	eb f0                	jmp    f0101685 <vprintfmt+0x46e>
				/* do nothing */;
			break;
		}
	}
}
f0101695:	83 c4 5c             	add    $0x5c,%esp
f0101698:	5b                   	pop    %ebx
f0101699:	5e                   	pop    %esi
f010169a:	5f                   	pop    %edi
f010169b:	5d                   	pop    %ebp
f010169c:	c3                   	ret    

f010169d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f010169d:	55                   	push   %ebp
f010169e:	89 e5                	mov    %esp,%ebp
f01016a0:	83 ec 28             	sub    $0x28,%esp
f01016a3:	8b 45 08             	mov    0x8(%ebp),%eax
f01016a6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
f01016a9:	85 c0                	test   %eax,%eax
f01016ab:	74 04                	je     f01016b1 <vsnprintf+0x14>
f01016ad:	85 d2                	test   %edx,%edx
f01016af:	7f 07                	jg     f01016b8 <vsnprintf+0x1b>
f01016b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01016b6:	eb 3b                	jmp    f01016f3 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
f01016b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01016bb:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
f01016bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01016c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01016c9:	8b 45 14             	mov    0x14(%ebp),%eax
f01016cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01016d0:	8b 45 10             	mov    0x10(%ebp),%eax
f01016d3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01016d7:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01016da:	89 44 24 04          	mov    %eax,0x4(%esp)
f01016de:	c7 04 24 fa 11 10 f0 	movl   $0xf01011fa,(%esp)
f01016e5:	e8 2d fb ff ff       	call   f0101217 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01016ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01016ed:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01016f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f01016f3:	c9                   	leave  
f01016f4:	c3                   	ret    

f01016f5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f01016f5:	55                   	push   %ebp
f01016f6:	89 e5                	mov    %esp,%ebp
f01016f8:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
f01016fb:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
f01016fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101702:	8b 45 10             	mov    0x10(%ebp),%eax
f0101705:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101709:	8b 45 0c             	mov    0xc(%ebp),%eax
f010170c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101710:	8b 45 08             	mov    0x8(%ebp),%eax
f0101713:	89 04 24             	mov    %eax,(%esp)
f0101716:	e8 82 ff ff ff       	call   f010169d <vsnprintf>
	va_end(ap);

	return rc;
}
f010171b:	c9                   	leave  
f010171c:	c3                   	ret    

f010171d <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...)
{
f010171d:	55                   	push   %ebp
f010171e:	89 e5                	mov    %esp,%ebp
f0101720:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...)
f0101723:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
f0101726:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010172a:	8b 45 10             	mov    0x10(%ebp),%eax
f010172d:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101731:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101734:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101738:	8b 45 08             	mov    0x8(%ebp),%eax
f010173b:	89 04 24             	mov    %eax,(%esp)
f010173e:	e8 d4 fa ff ff       	call   f0101217 <vprintfmt>
	va_end(ap);
}
f0101743:	c9                   	leave  
f0101744:	c3                   	ret    
	...

f0101750 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0101750:	55                   	push   %ebp
f0101751:	89 e5                	mov    %esp,%ebp
f0101753:	57                   	push   %edi
f0101754:	56                   	push   %esi
f0101755:	53                   	push   %ebx
f0101756:	83 ec 1c             	sub    $0x1c,%esp
f0101759:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f010175c:	85 c0                	test   %eax,%eax
f010175e:	74 10                	je     f0101770 <readline+0x20>
		cprintf("%s", prompt);
f0101760:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101764:	c7 04 24 8f 24 10 f0 	movl   $0xf010248f,(%esp)
f010176b:	e8 f7 f3 ff ff       	call   f0100b67 <cprintf>

	i = 0;
	echoing = iscons(0);
f0101770:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101777:	e8 0a ec ff ff       	call   f0100386 <iscons>
f010177c:	89 c7                	mov    %eax,%edi
f010177e:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
f0101783:	e8 ed eb ff ff       	call   f0100375 <getchar>
f0101788:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f010178a:	85 c0                	test   %eax,%eax
f010178c:	79 17                	jns    f01017a5 <readline+0x55>
			cprintf("read error: %e\n", c);
f010178e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101792:	c7 04 24 f4 26 10 f0 	movl   $0xf01026f4,(%esp)
f0101799:	e8 c9 f3 ff ff       	call   f0100b67 <cprintf>
f010179e:	b8 00 00 00 00       	mov    $0x0,%eax
			return NULL;
f01017a3:	eb 76                	jmp    f010181b <readline+0xcb>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01017a5:	83 f8 08             	cmp    $0x8,%eax
f01017a8:	74 08                	je     f01017b2 <readline+0x62>
f01017aa:	83 f8 7f             	cmp    $0x7f,%eax
f01017ad:	8d 76 00             	lea    0x0(%esi),%esi
f01017b0:	75 19                	jne    f01017cb <readline+0x7b>
f01017b2:	85 f6                	test   %esi,%esi
f01017b4:	7e 15                	jle    f01017cb <readline+0x7b>
			if (echoing)
f01017b6:	85 ff                	test   %edi,%edi
f01017b8:	74 0c                	je     f01017c6 <readline+0x76>
				cputchar('\b');
f01017ba:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f01017c1:	e8 c4 ed ff ff       	call   f010058a <cputchar>
			i--;
f01017c6:	83 ee 01             	sub    $0x1,%esi
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01017c9:	eb b8                	jmp    f0101783 <readline+0x33>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
f01017cb:	83 fb 1f             	cmp    $0x1f,%ebx
f01017ce:	66 90                	xchg   %ax,%ax
f01017d0:	7e 23                	jle    f01017f5 <readline+0xa5>
f01017d2:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01017d8:	7f 1b                	jg     f01017f5 <readline+0xa5>
			if (echoing)
f01017da:	85 ff                	test   %edi,%edi
f01017dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01017e0:	74 08                	je     f01017ea <readline+0x9a>
				cputchar(c);
f01017e2:	89 1c 24             	mov    %ebx,(%esp)
f01017e5:	e8 a0 ed ff ff       	call   f010058a <cputchar>
			buf[i++] = c;
f01017ea:	88 9e 60 35 11 f0    	mov    %bl,-0xfeecaa0(%esi)
f01017f0:	83 c6 01             	add    $0x1,%esi
f01017f3:	eb 8e                	jmp    f0101783 <readline+0x33>
		} else if (c == '\n' || c == '\r') {
f01017f5:	83 fb 0a             	cmp    $0xa,%ebx
f01017f8:	74 05                	je     f01017ff <readline+0xaf>
f01017fa:	83 fb 0d             	cmp    $0xd,%ebx
f01017fd:	75 84                	jne    f0101783 <readline+0x33>
			if (echoing)
f01017ff:	85 ff                	test   %edi,%edi
f0101801:	74 0c                	je     f010180f <readline+0xbf>
				cputchar('\n');
f0101803:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f010180a:	e8 7b ed ff ff       	call   f010058a <cputchar>
			buf[i] = 0;
f010180f:	c6 86 60 35 11 f0 00 	movb   $0x0,-0xfeecaa0(%esi)
f0101816:	b8 60 35 11 f0       	mov    $0xf0113560,%eax
			return buf;
		}
	}
}
f010181b:	83 c4 1c             	add    $0x1c,%esp
f010181e:	5b                   	pop    %ebx
f010181f:	5e                   	pop    %esi
f0101820:	5f                   	pop    %edi
f0101821:	5d                   	pop    %ebp
f0101822:	c3                   	ret    
	...

f0101830 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0101830:	55                   	push   %ebp
f0101831:	89 e5                	mov    %esp,%ebp
f0101833:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0101836:	b8 00 00 00 00       	mov    $0x0,%eax
f010183b:	80 3a 00             	cmpb   $0x0,(%edx)
f010183e:	74 09                	je     f0101849 <strlen+0x19>
		n++;
f0101840:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0101843:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0101847:	75 f7                	jne    f0101840 <strlen+0x10>
		n++;
	return n;
}
f0101849:	5d                   	pop    %ebp
f010184a:	c3                   	ret    

f010184b <strnlen>:

int
strnlen(const char *s, size_t size)
{
f010184b:	55                   	push   %ebp
f010184c:	89 e5                	mov    %esp,%ebp
f010184e:	53                   	push   %ebx
f010184f:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101852:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0101855:	85 c9                	test   %ecx,%ecx
f0101857:	74 19                	je     f0101872 <strnlen+0x27>
f0101859:	80 3b 00             	cmpb   $0x0,(%ebx)
f010185c:	74 14                	je     f0101872 <strnlen+0x27>
f010185e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
f0101863:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0101866:	39 c8                	cmp    %ecx,%eax
f0101868:	74 0d                	je     f0101877 <strnlen+0x2c>
f010186a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
f010186e:	75 f3                	jne    f0101863 <strnlen+0x18>
f0101870:	eb 05                	jmp    f0101877 <strnlen+0x2c>
f0101872:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
f0101877:	5b                   	pop    %ebx
f0101878:	5d                   	pop    %ebp
f0101879:	c3                   	ret    

f010187a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010187a:	55                   	push   %ebp
f010187b:	89 e5                	mov    %esp,%ebp
f010187d:	53                   	push   %ebx
f010187e:	8b 45 08             	mov    0x8(%ebp),%eax
f0101881:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101884:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0101889:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f010188d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0101890:	83 c2 01             	add    $0x1,%edx
f0101893:	84 c9                	test   %cl,%cl
f0101895:	75 f2                	jne    f0101889 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0101897:	5b                   	pop    %ebx
f0101898:	5d                   	pop    %ebp
f0101899:	c3                   	ret    

f010189a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f010189a:	55                   	push   %ebp
f010189b:	89 e5                	mov    %esp,%ebp
f010189d:	56                   	push   %esi
f010189e:	53                   	push   %ebx
f010189f:	8b 45 08             	mov    0x8(%ebp),%eax
f01018a2:	8b 55 0c             	mov    0xc(%ebp),%edx
f01018a5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01018a8:	85 f6                	test   %esi,%esi
f01018aa:	74 18                	je     f01018c4 <strncpy+0x2a>
f01018ac:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
f01018b1:	0f b6 1a             	movzbl (%edx),%ebx
f01018b4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01018b7:	80 3a 01             	cmpb   $0x1,(%edx)
f01018ba:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01018bd:	83 c1 01             	add    $0x1,%ecx
f01018c0:	39 ce                	cmp    %ecx,%esi
f01018c2:	77 ed                	ja     f01018b1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f01018c4:	5b                   	pop    %ebx
f01018c5:	5e                   	pop    %esi
f01018c6:	5d                   	pop    %ebp
f01018c7:	c3                   	ret    

f01018c8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01018c8:	55                   	push   %ebp
f01018c9:	89 e5                	mov    %esp,%ebp
f01018cb:	56                   	push   %esi
f01018cc:	53                   	push   %ebx
f01018cd:	8b 75 08             	mov    0x8(%ebp),%esi
f01018d0:	8b 55 0c             	mov    0xc(%ebp),%edx
f01018d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01018d6:	89 f0                	mov    %esi,%eax
f01018d8:	85 c9                	test   %ecx,%ecx
f01018da:	74 27                	je     f0101903 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
f01018dc:	83 e9 01             	sub    $0x1,%ecx
f01018df:	74 1d                	je     f01018fe <strlcpy+0x36>
f01018e1:	0f b6 1a             	movzbl (%edx),%ebx
f01018e4:	84 db                	test   %bl,%bl
f01018e6:	74 16                	je     f01018fe <strlcpy+0x36>
			*dst++ = *src++;
f01018e8:	88 18                	mov    %bl,(%eax)
f01018ea:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f01018ed:	83 e9 01             	sub    $0x1,%ecx
f01018f0:	74 0e                	je     f0101900 <strlcpy+0x38>
			*dst++ = *src++;
f01018f2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f01018f5:	0f b6 1a             	movzbl (%edx),%ebx
f01018f8:	84 db                	test   %bl,%bl
f01018fa:	75 ec                	jne    f01018e8 <strlcpy+0x20>
f01018fc:	eb 02                	jmp    f0101900 <strlcpy+0x38>
f01018fe:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
f0101900:	c6 00 00             	movb   $0x0,(%eax)
f0101903:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
f0101905:	5b                   	pop    %ebx
f0101906:	5e                   	pop    %esi
f0101907:	5d                   	pop    %ebp
f0101908:	c3                   	ret    

f0101909 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0101909:	55                   	push   %ebp
f010190a:	89 e5                	mov    %esp,%ebp
f010190c:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010190f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0101912:	0f b6 01             	movzbl (%ecx),%eax
f0101915:	84 c0                	test   %al,%al
f0101917:	74 15                	je     f010192e <strcmp+0x25>
f0101919:	3a 02                	cmp    (%edx),%al
f010191b:	75 11                	jne    f010192e <strcmp+0x25>
		p++, q++;
f010191d:	83 c1 01             	add    $0x1,%ecx
f0101920:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f0101923:	0f b6 01             	movzbl (%ecx),%eax
f0101926:	84 c0                	test   %al,%al
f0101928:	74 04                	je     f010192e <strcmp+0x25>
f010192a:	3a 02                	cmp    (%edx),%al
f010192c:	74 ef                	je     f010191d <strcmp+0x14>
f010192e:	0f b6 c0             	movzbl %al,%eax
f0101931:	0f b6 12             	movzbl (%edx),%edx
f0101934:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0101936:	5d                   	pop    %ebp
f0101937:	c3                   	ret    

f0101938 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0101938:	55                   	push   %ebp
f0101939:	89 e5                	mov    %esp,%ebp
f010193b:	53                   	push   %ebx
f010193c:	8b 55 08             	mov    0x8(%ebp),%edx
f010193f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0101942:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
f0101945:	85 c0                	test   %eax,%eax
f0101947:	74 23                	je     f010196c <strncmp+0x34>
f0101949:	0f b6 1a             	movzbl (%edx),%ebx
f010194c:	84 db                	test   %bl,%bl
f010194e:	74 24                	je     f0101974 <strncmp+0x3c>
f0101950:	3a 19                	cmp    (%ecx),%bl
f0101952:	75 20                	jne    f0101974 <strncmp+0x3c>
f0101954:	83 e8 01             	sub    $0x1,%eax
f0101957:	74 13                	je     f010196c <strncmp+0x34>
		n--, p++, q++;
f0101959:	83 c2 01             	add    $0x1,%edx
f010195c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f010195f:	0f b6 1a             	movzbl (%edx),%ebx
f0101962:	84 db                	test   %bl,%bl
f0101964:	74 0e                	je     f0101974 <strncmp+0x3c>
f0101966:	3a 19                	cmp    (%ecx),%bl
f0101968:	74 ea                	je     f0101954 <strncmp+0x1c>
f010196a:	eb 08                	jmp    f0101974 <strncmp+0x3c>
f010196c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0101971:	5b                   	pop    %ebx
f0101972:	5d                   	pop    %ebp
f0101973:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0101974:	0f b6 02             	movzbl (%edx),%eax
f0101977:	0f b6 11             	movzbl (%ecx),%edx
f010197a:	29 d0                	sub    %edx,%eax
f010197c:	eb f3                	jmp    f0101971 <strncmp+0x39>

f010197e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f010197e:	55                   	push   %ebp
f010197f:	89 e5                	mov    %esp,%ebp
f0101981:	8b 45 08             	mov    0x8(%ebp),%eax
f0101984:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0101988:	0f b6 10             	movzbl (%eax),%edx
f010198b:	84 d2                	test   %dl,%dl
f010198d:	74 15                	je     f01019a4 <strchr+0x26>
		if (*s == c)
f010198f:	38 ca                	cmp    %cl,%dl
f0101991:	75 07                	jne    f010199a <strchr+0x1c>
f0101993:	eb 14                	jmp    f01019a9 <strchr+0x2b>
f0101995:	38 ca                	cmp    %cl,%dl
f0101997:	90                   	nop
f0101998:	74 0f                	je     f01019a9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f010199a:	83 c0 01             	add    $0x1,%eax
f010199d:	0f b6 10             	movzbl (%eax),%edx
f01019a0:	84 d2                	test   %dl,%dl
f01019a2:	75 f1                	jne    f0101995 <strchr+0x17>
f01019a4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
f01019a9:	5d                   	pop    %ebp
f01019aa:	c3                   	ret    

f01019ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01019ab:	55                   	push   %ebp
f01019ac:	89 e5                	mov    %esp,%ebp
f01019ae:	8b 45 08             	mov    0x8(%ebp),%eax
f01019b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01019b5:	0f b6 10             	movzbl (%eax),%edx
f01019b8:	84 d2                	test   %dl,%dl
f01019ba:	74 18                	je     f01019d4 <strfind+0x29>
		if (*s == c)
f01019bc:	38 ca                	cmp    %cl,%dl
f01019be:	75 0a                	jne    f01019ca <strfind+0x1f>
f01019c0:	eb 12                	jmp    f01019d4 <strfind+0x29>
f01019c2:	38 ca                	cmp    %cl,%dl
f01019c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01019c8:	74 0a                	je     f01019d4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f01019ca:	83 c0 01             	add    $0x1,%eax
f01019cd:	0f b6 10             	movzbl (%eax),%edx
f01019d0:	84 d2                	test   %dl,%dl
f01019d2:	75 ee                	jne    f01019c2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
f01019d4:	5d                   	pop    %ebp
f01019d5:	c3                   	ret    

f01019d6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01019d6:	55                   	push   %ebp
f01019d7:	89 e5                	mov    %esp,%ebp
f01019d9:	83 ec 0c             	sub    $0xc,%esp
f01019dc:	89 1c 24             	mov    %ebx,(%esp)
f01019df:	89 74 24 04          	mov    %esi,0x4(%esp)
f01019e3:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01019e7:	8b 7d 08             	mov    0x8(%ebp),%edi
f01019ea:	8b 45 0c             	mov    0xc(%ebp),%eax
f01019ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01019f0:	85 c9                	test   %ecx,%ecx
f01019f2:	74 30                	je     f0101a24 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01019f4:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01019fa:	75 25                	jne    f0101a21 <memset+0x4b>
f01019fc:	f6 c1 03             	test   $0x3,%cl
f01019ff:	75 20                	jne    f0101a21 <memset+0x4b>
		c &= 0xFF;
f0101a01:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0101a04:	89 d3                	mov    %edx,%ebx
f0101a06:	c1 e3 08             	shl    $0x8,%ebx
f0101a09:	89 d6                	mov    %edx,%esi
f0101a0b:	c1 e6 18             	shl    $0x18,%esi
f0101a0e:	89 d0                	mov    %edx,%eax
f0101a10:	c1 e0 10             	shl    $0x10,%eax
f0101a13:	09 f0                	or     %esi,%eax
f0101a15:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
f0101a17:	09 d8                	or     %ebx,%eax
f0101a19:	c1 e9 02             	shr    $0x2,%ecx
f0101a1c:	fc                   	cld    
f0101a1d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0101a1f:	eb 03                	jmp    f0101a24 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0101a21:	fc                   	cld    
f0101a22:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0101a24:	89 f8                	mov    %edi,%eax
f0101a26:	8b 1c 24             	mov    (%esp),%ebx
f0101a29:	8b 74 24 04          	mov    0x4(%esp),%esi
f0101a2d:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0101a31:	89 ec                	mov    %ebp,%esp
f0101a33:	5d                   	pop    %ebp
f0101a34:	c3                   	ret    

f0101a35 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0101a35:	55                   	push   %ebp
f0101a36:	89 e5                	mov    %esp,%ebp
f0101a38:	83 ec 08             	sub    $0x8,%esp
f0101a3b:	89 34 24             	mov    %esi,(%esp)
f0101a3e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101a42:	8b 45 08             	mov    0x8(%ebp),%eax
f0101a45:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
f0101a48:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
f0101a4b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
f0101a4d:	39 c6                	cmp    %eax,%esi
f0101a4f:	73 35                	jae    f0101a86 <memmove+0x51>
f0101a51:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0101a54:	39 d0                	cmp    %edx,%eax
f0101a56:	73 2e                	jae    f0101a86 <memmove+0x51>
		s += n;
		d += n;
f0101a58:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101a5a:	f6 c2 03             	test   $0x3,%dl
f0101a5d:	75 1b                	jne    f0101a7a <memmove+0x45>
f0101a5f:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0101a65:	75 13                	jne    f0101a7a <memmove+0x45>
f0101a67:	f6 c1 03             	test   $0x3,%cl
f0101a6a:	75 0e                	jne    f0101a7a <memmove+0x45>
			asm volatile("std; rep movsl\n"
f0101a6c:	83 ef 04             	sub    $0x4,%edi
f0101a6f:	8d 72 fc             	lea    -0x4(%edx),%esi
f0101a72:	c1 e9 02             	shr    $0x2,%ecx
f0101a75:	fd                   	std    
f0101a76:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101a78:	eb 09                	jmp    f0101a83 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f0101a7a:	83 ef 01             	sub    $0x1,%edi
f0101a7d:	8d 72 ff             	lea    -0x1(%edx),%esi
f0101a80:	fd                   	std    
f0101a81:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0101a83:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0101a84:	eb 20                	jmp    f0101aa6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101a86:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0101a8c:	75 15                	jne    f0101aa3 <memmove+0x6e>
f0101a8e:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0101a94:	75 0d                	jne    f0101aa3 <memmove+0x6e>
f0101a96:	f6 c1 03             	test   $0x3,%cl
f0101a99:	75 08                	jne    f0101aa3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
f0101a9b:	c1 e9 02             	shr    $0x2,%ecx
f0101a9e:	fc                   	cld    
f0101a9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101aa1:	eb 03                	jmp    f0101aa6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0101aa3:	fc                   	cld    
f0101aa4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0101aa6:	8b 34 24             	mov    (%esp),%esi
f0101aa9:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0101aad:	89 ec                	mov    %ebp,%esp
f0101aaf:	5d                   	pop    %ebp
f0101ab0:	c3                   	ret    

f0101ab1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
f0101ab1:	55                   	push   %ebp
f0101ab2:	89 e5                	mov    %esp,%ebp
f0101ab4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0101ab7:	8b 45 10             	mov    0x10(%ebp),%eax
f0101aba:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101abe:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101ac1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
f0101ac8:	89 04 24             	mov    %eax,(%esp)
f0101acb:	e8 65 ff ff ff       	call   f0101a35 <memmove>
}
f0101ad0:	c9                   	leave  
f0101ad1:	c3                   	ret    

f0101ad2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0101ad2:	55                   	push   %ebp
f0101ad3:	89 e5                	mov    %esp,%ebp
f0101ad5:	57                   	push   %edi
f0101ad6:	56                   	push   %esi
f0101ad7:	53                   	push   %ebx
f0101ad8:	8b 75 08             	mov    0x8(%ebp),%esi
f0101adb:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0101ade:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0101ae1:	85 c9                	test   %ecx,%ecx
f0101ae3:	74 36                	je     f0101b1b <memcmp+0x49>
		if (*s1 != *s2)
f0101ae5:	0f b6 06             	movzbl (%esi),%eax
f0101ae8:	0f b6 1f             	movzbl (%edi),%ebx
f0101aeb:	38 d8                	cmp    %bl,%al
f0101aed:	74 20                	je     f0101b0f <memcmp+0x3d>
f0101aef:	eb 14                	jmp    f0101b05 <memcmp+0x33>
f0101af1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
f0101af6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
f0101afb:	83 c2 01             	add    $0x1,%edx
f0101afe:	83 e9 01             	sub    $0x1,%ecx
f0101b01:	38 d8                	cmp    %bl,%al
f0101b03:	74 12                	je     f0101b17 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
f0101b05:	0f b6 c0             	movzbl %al,%eax
f0101b08:	0f b6 db             	movzbl %bl,%ebx
f0101b0b:	29 d8                	sub    %ebx,%eax
f0101b0d:	eb 11                	jmp    f0101b20 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0101b0f:	83 e9 01             	sub    $0x1,%ecx
f0101b12:	ba 00 00 00 00       	mov    $0x0,%edx
f0101b17:	85 c9                	test   %ecx,%ecx
f0101b19:	75 d6                	jne    f0101af1 <memcmp+0x1f>
f0101b1b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
f0101b20:	5b                   	pop    %ebx
f0101b21:	5e                   	pop    %esi
f0101b22:	5f                   	pop    %edi
f0101b23:	5d                   	pop    %ebp
f0101b24:	c3                   	ret    

f0101b25 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0101b25:	55                   	push   %ebp
f0101b26:	89 e5                	mov    %esp,%ebp
f0101b28:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
f0101b2b:	89 c2                	mov    %eax,%edx
f0101b2d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0101b30:	39 d0                	cmp    %edx,%eax
f0101b32:	73 15                	jae    f0101b49 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
f0101b34:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
f0101b38:	38 08                	cmp    %cl,(%eax)
f0101b3a:	75 06                	jne    f0101b42 <memfind+0x1d>
f0101b3c:	eb 0b                	jmp    f0101b49 <memfind+0x24>
f0101b3e:	38 08                	cmp    %cl,(%eax)
f0101b40:	74 07                	je     f0101b49 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f0101b42:	83 c0 01             	add    $0x1,%eax
f0101b45:	39 c2                	cmp    %eax,%edx
f0101b47:	77 f5                	ja     f0101b3e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f0101b49:	5d                   	pop    %ebp
f0101b4a:	c3                   	ret    

f0101b4b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0101b4b:	55                   	push   %ebp
f0101b4c:	89 e5                	mov    %esp,%ebp
f0101b4e:	57                   	push   %edi
f0101b4f:	56                   	push   %esi
f0101b50:	53                   	push   %ebx
f0101b51:	83 ec 04             	sub    $0x4,%esp
f0101b54:	8b 55 08             	mov    0x8(%ebp),%edx
f0101b57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0101b5a:	0f b6 02             	movzbl (%edx),%eax
f0101b5d:	3c 20                	cmp    $0x20,%al
f0101b5f:	74 04                	je     f0101b65 <strtol+0x1a>
f0101b61:	3c 09                	cmp    $0x9,%al
f0101b63:	75 0e                	jne    f0101b73 <strtol+0x28>
		s++;
f0101b65:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0101b68:	0f b6 02             	movzbl (%edx),%eax
f0101b6b:	3c 20                	cmp    $0x20,%al
f0101b6d:	74 f6                	je     f0101b65 <strtol+0x1a>
f0101b6f:	3c 09                	cmp    $0x9,%al
f0101b71:	74 f2                	je     f0101b65 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
f0101b73:	3c 2b                	cmp    $0x2b,%al
f0101b75:	75 0c                	jne    f0101b83 <strtol+0x38>
		s++;
f0101b77:	83 c2 01             	add    $0x1,%edx
f0101b7a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101b81:	eb 15                	jmp    f0101b98 <strtol+0x4d>
	else if (*s == '-')
f0101b83:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101b8a:	3c 2d                	cmp    $0x2d,%al
f0101b8c:	75 0a                	jne    f0101b98 <strtol+0x4d>
		s++, neg = 1;
f0101b8e:	83 c2 01             	add    $0x1,%edx
f0101b91:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0101b98:	85 db                	test   %ebx,%ebx
f0101b9a:	0f 94 c0             	sete   %al
f0101b9d:	74 05                	je     f0101ba4 <strtol+0x59>
f0101b9f:	83 fb 10             	cmp    $0x10,%ebx
f0101ba2:	75 18                	jne    f0101bbc <strtol+0x71>
f0101ba4:	80 3a 30             	cmpb   $0x30,(%edx)
f0101ba7:	75 13                	jne    f0101bbc <strtol+0x71>
f0101ba9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0101bad:	8d 76 00             	lea    0x0(%esi),%esi
f0101bb0:	75 0a                	jne    f0101bbc <strtol+0x71>
		s += 2, base = 16;
f0101bb2:	83 c2 02             	add    $0x2,%edx
f0101bb5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0101bba:	eb 15                	jmp    f0101bd1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0101bbc:	84 c0                	test   %al,%al
f0101bbe:	66 90                	xchg   %ax,%ax
f0101bc0:	74 0f                	je     f0101bd1 <strtol+0x86>
f0101bc2:	bb 0a 00 00 00       	mov    $0xa,%ebx
f0101bc7:	80 3a 30             	cmpb   $0x30,(%edx)
f0101bca:	75 05                	jne    f0101bd1 <strtol+0x86>
		s++, base = 8;
f0101bcc:	83 c2 01             	add    $0x1,%edx
f0101bcf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0101bd1:	b8 00 00 00 00       	mov    $0x0,%eax
f0101bd6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0101bd8:	0f b6 0a             	movzbl (%edx),%ecx
f0101bdb:	89 cf                	mov    %ecx,%edi
f0101bdd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
f0101be0:	80 fb 09             	cmp    $0x9,%bl
f0101be3:	77 08                	ja     f0101bed <strtol+0xa2>
			dig = *s - '0';
f0101be5:	0f be c9             	movsbl %cl,%ecx
f0101be8:	83 e9 30             	sub    $0x30,%ecx
f0101beb:	eb 1e                	jmp    f0101c0b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
f0101bed:	8d 5f 9f             	lea    -0x61(%edi),%ebx
f0101bf0:	80 fb 19             	cmp    $0x19,%bl
f0101bf3:	77 08                	ja     f0101bfd <strtol+0xb2>
			dig = *s - 'a' + 10;
f0101bf5:	0f be c9             	movsbl %cl,%ecx
f0101bf8:	83 e9 57             	sub    $0x57,%ecx
f0101bfb:	eb 0e                	jmp    f0101c0b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
f0101bfd:	8d 5f bf             	lea    -0x41(%edi),%ebx
f0101c00:	80 fb 19             	cmp    $0x19,%bl
f0101c03:	77 15                	ja     f0101c1a <strtol+0xcf>
			dig = *s - 'A' + 10;
f0101c05:	0f be c9             	movsbl %cl,%ecx
f0101c08:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f0101c0b:	39 f1                	cmp    %esi,%ecx
f0101c0d:	7d 0b                	jge    f0101c1a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
f0101c0f:	83 c2 01             	add    $0x1,%edx
f0101c12:	0f af c6             	imul   %esi,%eax
f0101c15:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
f0101c18:	eb be                	jmp    f0101bd8 <strtol+0x8d>
f0101c1a:	89 c1                	mov    %eax,%ecx

	if (endptr)
f0101c1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0101c20:	74 05                	je     f0101c27 <strtol+0xdc>
		*endptr = (char *) s;
f0101c22:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101c25:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
f0101c27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0101c2b:	74 04                	je     f0101c31 <strtol+0xe6>
f0101c2d:	89 c8                	mov    %ecx,%eax
f0101c2f:	f7 d8                	neg    %eax
}
f0101c31:	83 c4 04             	add    $0x4,%esp
f0101c34:	5b                   	pop    %ebx
f0101c35:	5e                   	pop    %esi
f0101c36:	5f                   	pop    %edi
f0101c37:	5d                   	pop    %ebp
f0101c38:	c3                   	ret    
f0101c39:	00 00                	add    %al,(%eax)
f0101c3b:	00 00                	add    %al,(%eax)
f0101c3d:	00 00                	add    %al,(%eax)
	...

f0101c40 <__udivdi3>:
f0101c40:	55                   	push   %ebp
f0101c41:	89 e5                	mov    %esp,%ebp
f0101c43:	57                   	push   %edi
f0101c44:	56                   	push   %esi
f0101c45:	83 ec 10             	sub    $0x10,%esp
f0101c48:	8b 45 14             	mov    0x14(%ebp),%eax
f0101c4b:	8b 55 08             	mov    0x8(%ebp),%edx
f0101c4e:	8b 75 10             	mov    0x10(%ebp),%esi
f0101c51:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0101c54:	85 c0                	test   %eax,%eax
f0101c56:	89 55 f0             	mov    %edx,-0x10(%ebp)
f0101c59:	75 35                	jne    f0101c90 <__udivdi3+0x50>
f0101c5b:	39 fe                	cmp    %edi,%esi
f0101c5d:	77 61                	ja     f0101cc0 <__udivdi3+0x80>
f0101c5f:	85 f6                	test   %esi,%esi
f0101c61:	75 0b                	jne    f0101c6e <__udivdi3+0x2e>
f0101c63:	b8 01 00 00 00       	mov    $0x1,%eax
f0101c68:	31 d2                	xor    %edx,%edx
f0101c6a:	f7 f6                	div    %esi
f0101c6c:	89 c6                	mov    %eax,%esi
f0101c6e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0101c71:	31 d2                	xor    %edx,%edx
f0101c73:	89 f8                	mov    %edi,%eax
f0101c75:	f7 f6                	div    %esi
f0101c77:	89 c7                	mov    %eax,%edi
f0101c79:	89 c8                	mov    %ecx,%eax
f0101c7b:	f7 f6                	div    %esi
f0101c7d:	89 c1                	mov    %eax,%ecx
f0101c7f:	89 fa                	mov    %edi,%edx
f0101c81:	89 c8                	mov    %ecx,%eax
f0101c83:	83 c4 10             	add    $0x10,%esp
f0101c86:	5e                   	pop    %esi
f0101c87:	5f                   	pop    %edi
f0101c88:	5d                   	pop    %ebp
f0101c89:	c3                   	ret    
f0101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101c90:	39 f8                	cmp    %edi,%eax
f0101c92:	77 1c                	ja     f0101cb0 <__udivdi3+0x70>
f0101c94:	0f bd d0             	bsr    %eax,%edx
f0101c97:	83 f2 1f             	xor    $0x1f,%edx
f0101c9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101c9d:	75 39                	jne    f0101cd8 <__udivdi3+0x98>
f0101c9f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0101ca2:	0f 86 a0 00 00 00    	jbe    f0101d48 <__udivdi3+0x108>
f0101ca8:	39 f8                	cmp    %edi,%eax
f0101caa:	0f 82 98 00 00 00    	jb     f0101d48 <__udivdi3+0x108>
f0101cb0:	31 ff                	xor    %edi,%edi
f0101cb2:	31 c9                	xor    %ecx,%ecx
f0101cb4:	89 c8                	mov    %ecx,%eax
f0101cb6:	89 fa                	mov    %edi,%edx
f0101cb8:	83 c4 10             	add    $0x10,%esp
f0101cbb:	5e                   	pop    %esi
f0101cbc:	5f                   	pop    %edi
f0101cbd:	5d                   	pop    %ebp
f0101cbe:	c3                   	ret    
f0101cbf:	90                   	nop
f0101cc0:	89 d1                	mov    %edx,%ecx
f0101cc2:	89 fa                	mov    %edi,%edx
f0101cc4:	89 c8                	mov    %ecx,%eax
f0101cc6:	31 ff                	xor    %edi,%edi
f0101cc8:	f7 f6                	div    %esi
f0101cca:	89 c1                	mov    %eax,%ecx
f0101ccc:	89 fa                	mov    %edi,%edx
f0101cce:	89 c8                	mov    %ecx,%eax
f0101cd0:	83 c4 10             	add    $0x10,%esp
f0101cd3:	5e                   	pop    %esi
f0101cd4:	5f                   	pop    %edi
f0101cd5:	5d                   	pop    %ebp
f0101cd6:	c3                   	ret    
f0101cd7:	90                   	nop
f0101cd8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101cdc:	89 f2                	mov    %esi,%edx
f0101cde:	d3 e0                	shl    %cl,%eax
f0101ce0:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0101ce3:	b8 20 00 00 00       	mov    $0x20,%eax
f0101ce8:	2b 45 f4             	sub    -0xc(%ebp),%eax
f0101ceb:	89 c1                	mov    %eax,%ecx
f0101ced:	d3 ea                	shr    %cl,%edx
f0101cef:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101cf3:	0b 55 ec             	or     -0x14(%ebp),%edx
f0101cf6:	d3 e6                	shl    %cl,%esi
f0101cf8:	89 c1                	mov    %eax,%ecx
f0101cfa:	89 75 e8             	mov    %esi,-0x18(%ebp)
f0101cfd:	89 fe                	mov    %edi,%esi
f0101cff:	d3 ee                	shr    %cl,%esi
f0101d01:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101d05:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101d08:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101d0b:	d3 e7                	shl    %cl,%edi
f0101d0d:	89 c1                	mov    %eax,%ecx
f0101d0f:	d3 ea                	shr    %cl,%edx
f0101d11:	09 d7                	or     %edx,%edi
f0101d13:	89 f2                	mov    %esi,%edx
f0101d15:	89 f8                	mov    %edi,%eax
f0101d17:	f7 75 ec             	divl   -0x14(%ebp)
f0101d1a:	89 d6                	mov    %edx,%esi
f0101d1c:	89 c7                	mov    %eax,%edi
f0101d1e:	f7 65 e8             	mull   -0x18(%ebp)
f0101d21:	39 d6                	cmp    %edx,%esi
f0101d23:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101d26:	72 30                	jb     f0101d58 <__udivdi3+0x118>
f0101d28:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101d2b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101d2f:	d3 e2                	shl    %cl,%edx
f0101d31:	39 c2                	cmp    %eax,%edx
f0101d33:	73 05                	jae    f0101d3a <__udivdi3+0xfa>
f0101d35:	3b 75 ec             	cmp    -0x14(%ebp),%esi
f0101d38:	74 1e                	je     f0101d58 <__udivdi3+0x118>
f0101d3a:	89 f9                	mov    %edi,%ecx
f0101d3c:	31 ff                	xor    %edi,%edi
f0101d3e:	e9 71 ff ff ff       	jmp    f0101cb4 <__udivdi3+0x74>
f0101d43:	90                   	nop
f0101d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101d48:	31 ff                	xor    %edi,%edi
f0101d4a:	b9 01 00 00 00       	mov    $0x1,%ecx
f0101d4f:	e9 60 ff ff ff       	jmp    f0101cb4 <__udivdi3+0x74>
f0101d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101d58:	8d 4f ff             	lea    -0x1(%edi),%ecx
f0101d5b:	31 ff                	xor    %edi,%edi
f0101d5d:	89 c8                	mov    %ecx,%eax
f0101d5f:	89 fa                	mov    %edi,%edx
f0101d61:	83 c4 10             	add    $0x10,%esp
f0101d64:	5e                   	pop    %esi
f0101d65:	5f                   	pop    %edi
f0101d66:	5d                   	pop    %ebp
f0101d67:	c3                   	ret    
	...

f0101d70 <__umoddi3>:
f0101d70:	55                   	push   %ebp
f0101d71:	89 e5                	mov    %esp,%ebp
f0101d73:	57                   	push   %edi
f0101d74:	56                   	push   %esi
f0101d75:	83 ec 20             	sub    $0x20,%esp
f0101d78:	8b 55 14             	mov    0x14(%ebp),%edx
f0101d7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101d7e:	8b 7d 10             	mov    0x10(%ebp),%edi
f0101d81:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101d84:	85 d2                	test   %edx,%edx
f0101d86:	89 c8                	mov    %ecx,%eax
f0101d88:	89 4d f4             	mov    %ecx,-0xc(%ebp)
f0101d8b:	75 13                	jne    f0101da0 <__umoddi3+0x30>
f0101d8d:	39 f7                	cmp    %esi,%edi
f0101d8f:	76 3f                	jbe    f0101dd0 <__umoddi3+0x60>
f0101d91:	89 f2                	mov    %esi,%edx
f0101d93:	f7 f7                	div    %edi
f0101d95:	89 d0                	mov    %edx,%eax
f0101d97:	31 d2                	xor    %edx,%edx
f0101d99:	83 c4 20             	add    $0x20,%esp
f0101d9c:	5e                   	pop    %esi
f0101d9d:	5f                   	pop    %edi
f0101d9e:	5d                   	pop    %ebp
f0101d9f:	c3                   	ret    
f0101da0:	39 f2                	cmp    %esi,%edx
f0101da2:	77 4c                	ja     f0101df0 <__umoddi3+0x80>
f0101da4:	0f bd ca             	bsr    %edx,%ecx
f0101da7:	83 f1 1f             	xor    $0x1f,%ecx
f0101daa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0101dad:	75 51                	jne    f0101e00 <__umoddi3+0x90>
f0101daf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
f0101db2:	0f 87 e0 00 00 00    	ja     f0101e98 <__umoddi3+0x128>
f0101db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101dbb:	29 f8                	sub    %edi,%eax
f0101dbd:	19 d6                	sbb    %edx,%esi
f0101dbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101dc5:	89 f2                	mov    %esi,%edx
f0101dc7:	83 c4 20             	add    $0x20,%esp
f0101dca:	5e                   	pop    %esi
f0101dcb:	5f                   	pop    %edi
f0101dcc:	5d                   	pop    %ebp
f0101dcd:	c3                   	ret    
f0101dce:	66 90                	xchg   %ax,%ax
f0101dd0:	85 ff                	test   %edi,%edi
f0101dd2:	75 0b                	jne    f0101ddf <__umoddi3+0x6f>
f0101dd4:	b8 01 00 00 00       	mov    $0x1,%eax
f0101dd9:	31 d2                	xor    %edx,%edx
f0101ddb:	f7 f7                	div    %edi
f0101ddd:	89 c7                	mov    %eax,%edi
f0101ddf:	89 f0                	mov    %esi,%eax
f0101de1:	31 d2                	xor    %edx,%edx
f0101de3:	f7 f7                	div    %edi
f0101de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101de8:	f7 f7                	div    %edi
f0101dea:	eb a9                	jmp    f0101d95 <__umoddi3+0x25>
f0101dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101df0:	89 c8                	mov    %ecx,%eax
f0101df2:	89 f2                	mov    %esi,%edx
f0101df4:	83 c4 20             	add    $0x20,%esp
f0101df7:	5e                   	pop    %esi
f0101df8:	5f                   	pop    %edi
f0101df9:	5d                   	pop    %ebp
f0101dfa:	c3                   	ret    
f0101dfb:	90                   	nop
f0101dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101e00:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101e04:	d3 e2                	shl    %cl,%edx
f0101e06:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101e09:	ba 20 00 00 00       	mov    $0x20,%edx
f0101e0e:	2b 55 f0             	sub    -0x10(%ebp),%edx
f0101e11:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101e14:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101e18:	89 fa                	mov    %edi,%edx
f0101e1a:	d3 ea                	shr    %cl,%edx
f0101e1c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101e20:	0b 55 f4             	or     -0xc(%ebp),%edx
f0101e23:	d3 e7                	shl    %cl,%edi
f0101e25:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101e29:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101e2c:	89 f2                	mov    %esi,%edx
f0101e2e:	89 7d e8             	mov    %edi,-0x18(%ebp)
f0101e31:	89 c7                	mov    %eax,%edi
f0101e33:	d3 ea                	shr    %cl,%edx
f0101e35:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101e39:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101e3c:	89 c2                	mov    %eax,%edx
f0101e3e:	d3 e6                	shl    %cl,%esi
f0101e40:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101e44:	d3 ea                	shr    %cl,%edx
f0101e46:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101e4a:	09 d6                	or     %edx,%esi
f0101e4c:	89 f0                	mov    %esi,%eax
f0101e4e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0101e51:	d3 e7                	shl    %cl,%edi
f0101e53:	89 f2                	mov    %esi,%edx
f0101e55:	f7 75 f4             	divl   -0xc(%ebp)
f0101e58:	89 d6                	mov    %edx,%esi
f0101e5a:	f7 65 e8             	mull   -0x18(%ebp)
f0101e5d:	39 d6                	cmp    %edx,%esi
f0101e5f:	72 2b                	jb     f0101e8c <__umoddi3+0x11c>
f0101e61:	39 c7                	cmp    %eax,%edi
f0101e63:	72 23                	jb     f0101e88 <__umoddi3+0x118>
f0101e65:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101e69:	29 c7                	sub    %eax,%edi
f0101e6b:	19 d6                	sbb    %edx,%esi
f0101e6d:	89 f0                	mov    %esi,%eax
f0101e6f:	89 f2                	mov    %esi,%edx
f0101e71:	d3 ef                	shr    %cl,%edi
f0101e73:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101e77:	d3 e0                	shl    %cl,%eax
f0101e79:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101e7d:	09 f8                	or     %edi,%eax
f0101e7f:	d3 ea                	shr    %cl,%edx
f0101e81:	83 c4 20             	add    $0x20,%esp
f0101e84:	5e                   	pop    %esi
f0101e85:	5f                   	pop    %edi
f0101e86:	5d                   	pop    %ebp
f0101e87:	c3                   	ret    
f0101e88:	39 d6                	cmp    %edx,%esi
f0101e8a:	75 d9                	jne    f0101e65 <__umoddi3+0xf5>
f0101e8c:	2b 45 e8             	sub    -0x18(%ebp),%eax
f0101e8f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
f0101e92:	eb d1                	jmp    f0101e65 <__umoddi3+0xf5>
f0101e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101e98:	39 f2                	cmp    %esi,%edx
f0101e9a:	0f 82 18 ff ff ff    	jb     f0101db8 <__umoddi3+0x48>
f0101ea0:	e9 1d ff ff ff       	jmp    f0101dc2 <__umoddi3+0x52>
