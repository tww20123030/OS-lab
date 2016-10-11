
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
f0100015:	b8 00 00 11 00       	mov    $0x110000,%eax
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
f0100034:	bc 00 00 11 f0       	mov    $0xf0110000,%esp

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
f0100058:	c7 04 24 40 1d 10 f0 	movl   $0xf0101d40,(%esp)
f010005f:	e8 e7 09 00 00       	call   f0100a4b <cprintf>
	vcprintf(fmt, ap);
f0100064:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100068:	8b 45 10             	mov    0x10(%ebp),%eax
f010006b:	89 04 24             	mov    %eax,(%esp)
f010006e:	e8 a5 09 00 00       	call   f0100a18 <vcprintf>
	cprintf("\n");
f0100073:	c7 04 24 65 1e 10 f0 	movl   $0xf0101e65,(%esp)
f010007a:	e8 cc 09 00 00       	call   f0100a4b <cprintf>
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
f0100090:	83 3d 00 23 11 f0 00 	cmpl   $0x0,0xf0112300
f0100097:	75 3d                	jne    f01000d6 <_panic+0x51>
		goto dead;
	panicstr = fmt;
f0100099:	89 35 00 23 11 f0    	mov    %esi,0xf0112300

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
f01000b2:	c7 04 24 5a 1d 10 f0 	movl   $0xf0101d5a,(%esp)
f01000b9:	e8 8d 09 00 00       	call   f0100a4b <cprintf>
	vcprintf(fmt, ap);
f01000be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01000c2:	89 34 24             	mov    %esi,(%esp)
f01000c5:	e8 4e 09 00 00       	call   f0100a18 <vcprintf>
	cprintf("\n");
f01000ca:	c7 04 24 65 1e 10 f0 	movl   $0xf0101e65,(%esp)
f01000d1:	e8 75 09 00 00       	call   f0100a4b <cprintf>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01000dd:	e8 e7 07 00 00       	call   f01008c9 <monitor>
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
f01000f2:	c7 04 24 72 1d 10 f0 	movl   $0xf0101d72,(%esp)
f01000f9:	e8 4d 09 00 00       	call   f0100a4b <cprintf>
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
f0100126:	e8 77 06 00 00       	call   f01007a2 <mon_backtrace>
	cprintf("leaving test_backtrace %d\n", x);
f010012b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010012f:	c7 04 24 8e 1d 10 f0 	movl   $0xf0101d8e,(%esp)
f0100136:	e8 10 09 00 00       	call   f0100a4b <cprintf>
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
f010017f:	b8 60 29 11 f0       	mov    $0xf0112960,%eax
f0100184:	2d 00 23 11 f0       	sub    $0xf0112300,%eax
f0100189:	89 44 24 08          	mov    %eax,0x8(%esp)
f010018d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100194:	00 
f0100195:	c7 04 24 00 23 11 f0 	movl   $0xf0112300,(%esp)
f010019c:	e8 b5 16 00 00       	call   f0101856 <memset>

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
f01001bc:	c7 04 24 f0 1d 10 f0 	movl   $0xf0101df0,(%esp)
f01001c3:	e8 83 08 00 00       	call   f0100a4b <cprintf>
	cprintf("pading space in the right to number 22: %8d.\n", 22);
f01001c8:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
f01001cf:	00 
f01001d0:	c7 04 24 10 1e 10 f0 	movl   $0xf0101e10,(%esp)
f01001d7:	e8 6f 08 00 00       	call   f0100a4b <cprintf>
	cprintf("chnum1: %d chnum2: %d\n", chnum1, chnum2);
f01001dc:	0f be 45 f6          	movsbl -0xa(%ebp),%eax
f01001e0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01001e4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
f01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01001ec:	c7 04 24 a9 1d 10 f0 	movl   $0xf0101da9,(%esp)
f01001f3:	e8 53 08 00 00       	call   f0100a4b <cprintf>
	cprintf("%n", NULL);
f01001f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01001ff:	00 
f0100200:	c7 04 24 c2 1d 10 f0 	movl   $0xf0101dc2,(%esp)
f0100207:	e8 3f 08 00 00       	call   f0100a4b <cprintf>
	memset(ntest, 0xd, sizeof(ntest) - 1);
f010020c:	c7 44 24 08 ff 00 00 	movl   $0xff,0x8(%esp)
f0100213:	00 
f0100214:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
f010021b:	00 
f010021c:	8d 9d f6 fe ff ff    	lea    -0x10a(%ebp),%ebx
f0100222:	89 1c 24             	mov    %ebx,(%esp)
f0100225:	e8 2c 16 00 00       	call   f0101856 <memset>
	cprintf("%s%n", ntest, &chnum1); 
f010022a:	89 7c 24 08          	mov    %edi,0x8(%esp)
f010022e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100232:	c7 04 24 c0 1d 10 f0 	movl   $0xf0101dc0,(%esp)
f0100239:	e8 0d 08 00 00       	call   f0100a4b <cprintf>
	cprintf("chnum1: %d\n", chnum1);
f010023e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
f0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100246:	c7 04 24 c5 1d 10 f0 	movl   $0xf0101dc5,(%esp)
f010024d:	e8 f9 07 00 00       	call   f0100a4b <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f0100252:	c7 44 24 08 00 fc ff 	movl   $0xfffffc00,0x8(%esp)
f0100259:	ff 
f010025a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
f0100261:	00 
f0100262:	c7 04 24 d1 1d 10 f0 	movl   $0xf0101dd1,(%esp)
f0100269:	e8 dd 07 00 00       	call   f0100a4b <cprintf>


	// Test the stack backtrace function (lab 1 only)
	test_backtrace(5);
f010026e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f0100275:	e8 6a fe ff ff       	call   f01000e4 <test_backtrace>

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
f010027a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100281:	e8 43 06 00 00       	call   f01008c9 <monitor>
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
f01002c9:	bb 44 25 11 f0       	mov    $0xf0112544,%ebx
f01002ce:	bf 40 23 11 f0       	mov    $0xf0112340,%edi
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
f010031a:	83 3d 24 23 11 f0 00 	cmpl   $0x0,0xf0112324
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
f010033f:	8b 15 40 25 11 f0    	mov    0xf0112540,%edx
f0100345:	b8 00 00 00 00       	mov    $0x0,%eax
f010034a:	3b 15 44 25 11 f0    	cmp    0xf0112544,%edx
f0100350:	74 21                	je     f0100373 <cons_getc+0x44>
		c = cons.buf[cons.rpos++];
f0100352:	0f b6 82 40 23 11 f0 	movzbl -0xfeedcc0(%edx),%eax
f0100359:	83 c2 01             	add    $0x1,%edx
		if (cons.rpos == CONSBUFSIZE)
f010035c:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.rpos = 0;
f0100362:	0f 94 c1             	sete   %cl
f0100365:	0f b6 c9             	movzbl %cl,%ecx
f0100368:	83 e9 01             	sub    $0x1,%ecx
f010036b:	21 ca                	and    %ecx,%edx
f010036d:	89 15 40 25 11 f0    	mov    %edx,0xf0112540
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
f010045a:	0f b7 05 30 23 11 f0 	movzwl 0xf0112330,%eax
f0100461:	66 85 c0             	test   %ax,%ax
f0100464:	0f 84 e8 00 00 00    	je     f0100552 <cons_putc+0x1c2>
			crt_pos--;
f010046a:	83 e8 01             	sub    $0x1,%eax
f010046d:	66 a3 30 23 11 f0    	mov    %ax,0xf0112330
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100473:	0f b7 c0             	movzwl %ax,%eax
f0100476:	66 81 e7 00 ff       	and    $0xff00,%di
f010047b:	83 cf 20             	or     $0x20,%edi
f010047e:	8b 15 2c 23 11 f0    	mov    0xf011232c,%edx
f0100484:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100488:	eb 7b                	jmp    f0100505 <cons_putc+0x175>
		}
		break;
	case '\n':
		crt_pos += CRT_COLS;
f010048a:	66 83 05 30 23 11 f0 	addw   $0x50,0xf0112330
f0100491:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f0100492:	0f b7 05 30 23 11 f0 	movzwl 0xf0112330,%eax
f0100499:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f010049f:	c1 e8 10             	shr    $0x10,%eax
f01004a2:	66 c1 e8 06          	shr    $0x6,%ax
f01004a6:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004a9:	c1 e0 04             	shl    $0x4,%eax
f01004ac:	66 a3 30 23 11 f0    	mov    %ax,0xf0112330
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
f01004e8:	0f b7 05 30 23 11 f0 	movzwl 0xf0112330,%eax
f01004ef:	0f b7 c8             	movzwl %ax,%ecx
f01004f2:	8b 15 2c 23 11 f0    	mov    0xf011232c,%edx
f01004f8:	66 89 3c 4a          	mov    %di,(%edx,%ecx,2)
f01004fc:	83 c0 01             	add    $0x1,%eax
f01004ff:	66 a3 30 23 11 f0    	mov    %ax,0xf0112330
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f0100505:	66 81 3d 30 23 11 f0 	cmpw   $0x7cf,0xf0112330
f010050c:	cf 07 
f010050e:	76 42                	jbe    f0100552 <cons_putc+0x1c2>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100510:	a1 2c 23 11 f0       	mov    0xf011232c,%eax
f0100515:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
f010051c:	00 
f010051d:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100523:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100527:	89 04 24             	mov    %eax,(%esp)
f010052a:	e8 86 13 00 00       	call   f01018b5 <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
			crt_buf[i] = 0x0700 | ' ';
f010052f:	8b 15 2c 23 11 f0    	mov    0xf011232c,%edx
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
f010054a:	66 83 2d 30 23 11 f0 	subw   $0x50,0xf0112330
f0100551:	50 
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f0100552:	8b 0d 28 23 11 f0    	mov    0xf0112328,%ecx
f0100558:	89 cb                	mov    %ecx,%ebx
f010055a:	b8 0e 00 00 00       	mov    $0xe,%eax
f010055f:	89 ca                	mov    %ecx,%edx
f0100561:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100562:	0f b7 35 30 23 11 f0 	movzwl 0xf0112330,%esi
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
f01005b9:	c7 05 28 23 11 f0 b4 	movl   $0x3b4,0xf0112328
f01005c0:	03 00 00 
f01005c3:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
f01005c8:	eb 16                	jmp    f01005e0 <cons_init+0x46>
	} else {
		*cp = was;
f01005ca:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01005d1:	c7 05 28 23 11 f0 d4 	movl   $0x3d4,0xf0112328
f01005d8:	03 00 00 
f01005db:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
	}
	
	/* Extract cursor location */
	outb(addr_6845, 14);
f01005e0:	8b 0d 28 23 11 f0    	mov    0xf0112328,%ecx
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
f0100607:	89 35 2c 23 11 f0    	mov    %esi,0xf011232c
	crt_pos = pos;
f010060d:	0f b6 c8             	movzbl %al,%ecx
f0100610:	09 cf                	or     %ecx,%edi
f0100612:	66 89 3d 30 23 11 f0 	mov    %di,0xf0112330
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
f0100666:	89 35 24 23 11 f0    	mov    %esi,0xf0112324
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
f0100676:	c7 04 24 3e 1e 10 f0 	movl   $0xf0101e3e,(%esp)
f010067d:	e8 c9 03 00 00       	call   f0100a4b <cprintf>
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
f01006ab:	83 0d 20 23 11 f0 40 	orl    $0x40,0xf0112320
f01006b2:	bb 00 00 00 00       	mov    $0x0,%ebx
		return 0;
f01006b7:	e9 c1 00 00 00       	jmp    f010077d <kbd_proc_data+0xf3>
	} else if (data & 0x80) {
f01006bc:	84 c0                	test   %al,%al
f01006be:	79 32                	jns    f01006f2 <kbd_proc_data+0x68>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f01006c0:	8b 15 20 23 11 f0    	mov    0xf0112320,%edx
f01006c6:	f6 c2 40             	test   $0x40,%dl
f01006c9:	75 03                	jne    f01006ce <kbd_proc_data+0x44>
f01006cb:	83 e0 7f             	and    $0x7f,%eax
		shift &= ~(shiftcode[data] | E0ESC);
f01006ce:	0f b6 c0             	movzbl %al,%eax
f01006d1:	0f b6 80 80 1e 10 f0 	movzbl -0xfefe180(%eax),%eax
f01006d8:	83 c8 40             	or     $0x40,%eax
f01006db:	0f b6 c0             	movzbl %al,%eax
f01006de:	f7 d0                	not    %eax
f01006e0:	21 c2                	and    %eax,%edx
f01006e2:	89 15 20 23 11 f0    	mov    %edx,0xf0112320
f01006e8:	bb 00 00 00 00       	mov    $0x0,%ebx
		return 0;
f01006ed:	e9 8b 00 00 00       	jmp    f010077d <kbd_proc_data+0xf3>
	} else if (shift & E0ESC) {
f01006f2:	8b 15 20 23 11 f0    	mov    0xf0112320,%edx
f01006f8:	f6 c2 40             	test   $0x40,%dl
f01006fb:	74 0c                	je     f0100709 <kbd_proc_data+0x7f>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f01006fd:	83 c8 80             	or     $0xffffff80,%eax
		shift &= ~E0ESC;
f0100700:	83 e2 bf             	and    $0xffffffbf,%edx
f0100703:	89 15 20 23 11 f0    	mov    %edx,0xf0112320
	}

	shift |= shiftcode[data];
f0100709:	0f b6 c0             	movzbl %al,%eax
	shift ^= togglecode[data];
f010070c:	0f b6 90 80 1e 10 f0 	movzbl -0xfefe180(%eax),%edx
f0100713:	0b 15 20 23 11 f0    	or     0xf0112320,%edx
f0100719:	0f b6 88 80 1f 10 f0 	movzbl -0xfefe080(%eax),%ecx
f0100720:	31 ca                	xor    %ecx,%edx
f0100722:	89 15 20 23 11 f0    	mov    %edx,0xf0112320

	c = charcode[shift & (CTL | SHIFT)][data];
f0100728:	89 d1                	mov    %edx,%ecx
f010072a:	83 e1 03             	and    $0x3,%ecx
f010072d:	8b 0c 8d 80 20 10 f0 	mov    -0xfefdf80(,%ecx,4),%ecx
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
f0100766:	c7 04 24 5b 1e 10 f0 	movl   $0xf0101e5b,(%esp)
f010076d:	e8 d9 02 00 00       	call   f0100a4b <cprintf>
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

f0100790 <start_overflow>:
    cprintf("Overflow success\n");
}

void
start_overflow(void)
{
f0100790:	55                   	push   %ebp
f0100791:	89 e5                	mov    %esp,%ebp

	// Your code here.
    


}
f0100793:	5d                   	pop    %ebp
f0100794:	c3                   	ret    

f0100795 <overflow_me>:

void
overflow_me(void)
{
f0100795:	55                   	push   %ebp
f0100796:	89 e5                	mov    %esp,%ebp
        start_overflow();
}
f0100798:	5d                   	pop    %ebp
f0100799:	c3                   	ret    

f010079a <read_eip>:
// return EIP of caller.
// does not work if inlined.
// putting at the end of the file seems to prevent inlining.
unsigned
read_eip()
{
f010079a:	55                   	push   %ebp
f010079b:	89 e5                	mov    %esp,%ebp
	uint32_t callerpc;
	__asm __volatile("movl 4(%%ebp), %0" : "=r" (callerpc));
f010079d:	8b 45 04             	mov    0x4(%ebp),%eax
	return callerpc;
}
f01007a0:	5d                   	pop    %ebp
f01007a1:	c3                   	ret    

f01007a2 <mon_backtrace>:
        start_overflow();
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01007a2:	55                   	push   %ebp
f01007a3:	89 e5                	mov    %esp,%ebp
f01007a5:	83 ec 18             	sub    $0x18,%esp
	// Your code here.
    overflow_me();
    cprintf("Backtrace success\n");
f01007a8:	c7 04 24 90 20 10 f0 	movl   $0xf0102090,(%esp)
f01007af:	e8 97 02 00 00       	call   f0100a4b <cprintf>
	return 0;
}
f01007b4:	b8 00 00 00 00       	mov    $0x0,%eax
f01007b9:	c9                   	leave  
f01007ba:	c3                   	ret    

f01007bb <do_overflow>:
    return pretaddr;
}

void
do_overflow(void)
{
f01007bb:	55                   	push   %ebp
f01007bc:	89 e5                	mov    %esp,%ebp
f01007be:	83 ec 18             	sub    $0x18,%esp
    cprintf("Overflow success\n");
f01007c1:	c7 04 24 a3 20 10 f0 	movl   $0xf01020a3,(%esp)
f01007c8:	e8 7e 02 00 00       	call   f0100a4b <cprintf>
}
f01007cd:	c9                   	leave  
f01007ce:	c3                   	ret    

f01007cf <mon_kerninfo>:
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01007cf:	55                   	push   %ebp
f01007d0:	89 e5                	mov    %esp,%ebp
f01007d2:	83 ec 18             	sub    $0x18,%esp
	extern char entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01007d5:	c7 04 24 b5 20 10 f0 	movl   $0xf01020b5,(%esp)
f01007dc:	e8 6a 02 00 00       	call   f0100a4b <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01007e1:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f01007e8:	00 
f01007e9:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f01007f0:	f0 
f01007f1:	c7 04 24 40 21 10 f0 	movl   $0xf0102140,(%esp)
f01007f8:	e8 4e 02 00 00       	call   f0100a4b <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01007fd:	c7 44 24 08 25 1d 10 	movl   $0x101d25,0x8(%esp)
f0100804:	00 
f0100805:	c7 44 24 04 25 1d 10 	movl   $0xf0101d25,0x4(%esp)
f010080c:	f0 
f010080d:	c7 04 24 64 21 10 f0 	movl   $0xf0102164,(%esp)
f0100814:	e8 32 02 00 00       	call   f0100a4b <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100819:	c7 44 24 08 00 23 11 	movl   $0x112300,0x8(%esp)
f0100820:	00 
f0100821:	c7 44 24 04 00 23 11 	movl   $0xf0112300,0x4(%esp)
f0100828:	f0 
f0100829:	c7 04 24 88 21 10 f0 	movl   $0xf0102188,(%esp)
f0100830:	e8 16 02 00 00       	call   f0100a4b <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100835:	c7 44 24 08 60 29 11 	movl   $0x112960,0x8(%esp)
f010083c:	00 
f010083d:	c7 44 24 04 60 29 11 	movl   $0xf0112960,0x4(%esp)
f0100844:	f0 
f0100845:	c7 04 24 ac 21 10 f0 	movl   $0xf01021ac,(%esp)
f010084c:	e8 fa 01 00 00       	call   f0100a4b <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100851:	b8 5f 2d 11 f0       	mov    $0xf0112d5f,%eax
f0100856:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f010085b:	89 c2                	mov    %eax,%edx
f010085d:	c1 fa 1f             	sar    $0x1f,%edx
f0100860:	c1 ea 16             	shr    $0x16,%edx
f0100863:	8d 04 02             	lea    (%edx,%eax,1),%eax
f0100866:	c1 f8 0a             	sar    $0xa,%eax
f0100869:	89 44 24 04          	mov    %eax,0x4(%esp)
f010086d:	c7 04 24 d0 21 10 f0 	movl   $0xf01021d0,(%esp)
f0100874:	e8 d2 01 00 00       	call   f0100a4b <cprintf>
		(end-entry+1023)/1024);
	return 0;
}
f0100879:	b8 00 00 00 00       	mov    $0x0,%eax
f010087e:	c9                   	leave  
f010087f:	c3                   	ret    

f0100880 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100880:	55                   	push   %ebp
f0100881:	89 e5                	mov    %esp,%ebp
f0100883:	83 ec 18             	sub    $0x18,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0100886:	a1 74 22 10 f0       	mov    0xf0102274,%eax
f010088b:	89 44 24 08          	mov    %eax,0x8(%esp)
f010088f:	a1 70 22 10 f0       	mov    0xf0102270,%eax
f0100894:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100898:	c7 04 24 ce 20 10 f0 	movl   $0xf01020ce,(%esp)
f010089f:	e8 a7 01 00 00       	call   f0100a4b <cprintf>
f01008a4:	a1 80 22 10 f0       	mov    0xf0102280,%eax
f01008a9:	89 44 24 08          	mov    %eax,0x8(%esp)
f01008ad:	a1 7c 22 10 f0       	mov    0xf010227c,%eax
f01008b2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01008b6:	c7 04 24 ce 20 10 f0 	movl   $0xf01020ce,(%esp)
f01008bd:	e8 89 01 00 00       	call   f0100a4b <cprintf>
	return 0;
}
f01008c2:	b8 00 00 00 00       	mov    $0x0,%eax
f01008c7:	c9                   	leave  
f01008c8:	c3                   	ret    

f01008c9 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f01008c9:	55                   	push   %ebp
f01008ca:	89 e5                	mov    %esp,%ebp
f01008cc:	57                   	push   %edi
f01008cd:	56                   	push   %esi
f01008ce:	53                   	push   %ebx
f01008cf:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f01008d2:	c7 04 24 fc 21 10 f0 	movl   $0xf01021fc,(%esp)
f01008d9:	e8 6d 01 00 00       	call   f0100a4b <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f01008de:	c7 04 24 20 22 10 f0 	movl   $0xf0102220,(%esp)
f01008e5:	e8 61 01 00 00       	call   f0100a4b <cprintf>

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f01008ea:	bf 70 22 10 f0       	mov    $0xf0102270,%edi
	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");


	while (1) {
		buf = readline("K> ");
f01008ef:	c7 04 24 d7 20 10 f0 	movl   $0xf01020d7,(%esp)
f01008f6:	e8 d5 0c 00 00       	call   f01015d0 <readline>
f01008fb:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f01008fd:	85 c0                	test   %eax,%eax
f01008ff:	74 ee                	je     f01008ef <monitor+0x26>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100901:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
f0100908:	be 00 00 00 00       	mov    $0x0,%esi
f010090d:	eb 06                	jmp    f0100915 <monitor+0x4c>
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f010090f:	c6 03 00             	movb   $0x0,(%ebx)
f0100912:	83 c3 01             	add    $0x1,%ebx
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100915:	0f b6 03             	movzbl (%ebx),%eax
f0100918:	84 c0                	test   %al,%al
f010091a:	74 6f                	je     f010098b <monitor+0xc2>
f010091c:	0f be c0             	movsbl %al,%eax
f010091f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100923:	c7 04 24 db 20 10 f0 	movl   $0xf01020db,(%esp)
f010092a:	e8 cf 0e 00 00       	call   f01017fe <strchr>
f010092f:	85 c0                	test   %eax,%eax
f0100931:	75 dc                	jne    f010090f <monitor+0x46>
			*buf++ = 0;
		if (*buf == 0)
f0100933:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100936:	74 53                	je     f010098b <monitor+0xc2>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100938:	83 fe 0f             	cmp    $0xf,%esi
f010093b:	90                   	nop
f010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0100940:	75 16                	jne    f0100958 <monitor+0x8f>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100942:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f0100949:	00 
f010094a:	c7 04 24 e0 20 10 f0 	movl   $0xf01020e0,(%esp)
f0100951:	e8 f5 00 00 00       	call   f0100a4b <cprintf>
f0100956:	eb 97                	jmp    f01008ef <monitor+0x26>
			return 0;
		}
		argv[argc++] = buf;
f0100958:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f010095c:	83 c6 01             	add    $0x1,%esi
		while (*buf && !strchr(WHITESPACE, *buf))
f010095f:	0f b6 03             	movzbl (%ebx),%eax
f0100962:	84 c0                	test   %al,%al
f0100964:	75 0c                	jne    f0100972 <monitor+0xa9>
f0100966:	eb ad                	jmp    f0100915 <monitor+0x4c>
			buf++;
f0100968:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f010096b:	0f b6 03             	movzbl (%ebx),%eax
f010096e:	84 c0                	test   %al,%al
f0100970:	74 a3                	je     f0100915 <monitor+0x4c>
f0100972:	0f be c0             	movsbl %al,%eax
f0100975:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100979:	c7 04 24 db 20 10 f0 	movl   $0xf01020db,(%esp)
f0100980:	e8 79 0e 00 00       	call   f01017fe <strchr>
f0100985:	85 c0                	test   %eax,%eax
f0100987:	74 df                	je     f0100968 <monitor+0x9f>
f0100989:	eb 8a                	jmp    f0100915 <monitor+0x4c>
			buf++;
	}
	argv[argc] = 0;
f010098b:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100992:	00 

	// Lookup and invoke the command
	if (argc == 0)
f0100993:	85 f6                	test   %esi,%esi
f0100995:	0f 84 54 ff ff ff    	je     f01008ef <monitor+0x26>
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f010099b:	8b 07                	mov    (%edi),%eax
f010099d:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009a1:	8b 45 a8             	mov    -0x58(%ebp),%eax
f01009a4:	89 04 24             	mov    %eax,(%esp)
f01009a7:	e8 dd 0d 00 00       	call   f0101789 <strcmp>
f01009ac:	ba 00 00 00 00       	mov    $0x0,%edx
f01009b1:	85 c0                	test   %eax,%eax
f01009b3:	74 1d                	je     f01009d2 <monitor+0x109>
f01009b5:	a1 7c 22 10 f0       	mov    0xf010227c,%eax
f01009ba:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009be:	8b 45 a8             	mov    -0x58(%ebp),%eax
f01009c1:	89 04 24             	mov    %eax,(%esp)
f01009c4:	e8 c0 0d 00 00       	call   f0101789 <strcmp>
f01009c9:	85 c0                	test   %eax,%eax
f01009cb:	75 28                	jne    f01009f5 <monitor+0x12c>
f01009cd:	ba 01 00 00 00       	mov    $0x1,%edx
			return commands[i].func(argc, argv, tf);
f01009d2:	6b d2 0c             	imul   $0xc,%edx,%edx
f01009d5:	8b 45 08             	mov    0x8(%ebp),%eax
f01009d8:	89 44 24 08          	mov    %eax,0x8(%esp)
f01009dc:	8d 45 a8             	lea    -0x58(%ebp),%eax
f01009df:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009e3:	89 34 24             	mov    %esi,(%esp)
f01009e6:	ff 92 78 22 10 f0    	call   *-0xfefdd88(%edx)


	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f01009ec:	85 c0                	test   %eax,%eax
f01009ee:	78 1d                	js     f0100a0d <monitor+0x144>
f01009f0:	e9 fa fe ff ff       	jmp    f01008ef <monitor+0x26>
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f01009f5:	8b 45 a8             	mov    -0x58(%ebp),%eax
f01009f8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009fc:	c7 04 24 fd 20 10 f0 	movl   $0xf01020fd,(%esp)
f0100a03:	e8 43 00 00 00       	call   f0100a4b <cprintf>
f0100a08:	e9 e2 fe ff ff       	jmp    f01008ef <monitor+0x26>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f0100a0d:	83 c4 5c             	add    $0x5c,%esp
f0100a10:	5b                   	pop    %ebx
f0100a11:	5e                   	pop    %esi
f0100a12:	5f                   	pop    %edi
f0100a13:	5d                   	pop    %ebp
f0100a14:	c3                   	ret    
f0100a15:	00 00                	add    %al,(%eax)
	...

f0100a18 <vcprintf>:
    (*cnt)++;
}

int
vcprintf(const char *fmt, va_list ap)
{
f0100a18:	55                   	push   %ebp
f0100a19:	89 e5                	mov    %esp,%ebp
f0100a1b:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f0100a1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);// ap:store the argument inputed by user.
f0100a25:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100a28:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100a2c:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a2f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100a33:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100a36:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a3a:	c7 04 24 65 0a 10 f0 	movl   $0xf0100a65,(%esp)
f0100a41:	e8 4b 06 00 00       	call   f0101091 <vprintfmt>
	return cnt;
}
f0100a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100a49:	c9                   	leave  
f0100a4a:	c3                   	ret    

f0100a4b <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0100a4b:	55                   	push   %ebp
f0100a4c:	89 e5                	mov    %esp,%ebp
f0100a4e:	83 ec 18             	sub    $0x18,%esp
	vprintfmt((void*)putch, &cnt, fmt, ap);// ap:store the argument inputed by user.
	return cnt;
}

int
cprintf(const char *fmt, ...)
f0100a51:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
f0100a54:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a58:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a5b:	89 04 24             	mov    %eax,(%esp)
f0100a5e:	e8 b5 ff ff ff       	call   f0100a18 <vcprintf>
	
	va_end(ap);
	return cnt;
}
f0100a63:	c9                   	leave  
f0100a64:	c3                   	ret    

f0100a65 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0100a65:	55                   	push   %ebp
f0100a66:	89 e5                	mov    %esp,%ebp
f0100a68:	53                   	push   %ebx
f0100a69:	83 ec 14             	sub    $0x14,%esp
f0100a6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f0100a6f:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a72:	89 04 24             	mov    %eax,(%esp)
f0100a75:	e8 10 fb ff ff       	call   f010058a <cputchar>
    (*cnt)++;
f0100a7a:	83 03 01             	addl   $0x1,(%ebx)
}
f0100a7d:	83 c4 14             	add    $0x14,%esp
f0100a80:	5b                   	pop    %ebx
f0100a81:	5d                   	pop    %ebp
f0100a82:	c3                   	ret    
	...

f0100a90 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0100a90:	55                   	push   %ebp
f0100a91:	89 e5                	mov    %esp,%ebp
f0100a93:	57                   	push   %edi
f0100a94:	56                   	push   %esi
f0100a95:	53                   	push   %ebx
f0100a96:	83 ec 14             	sub    $0x14,%esp
f0100a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100a9c:	89 55 e8             	mov    %edx,-0x18(%ebp)
f0100a9f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0100aa2:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0100aa5:	8b 1a                	mov    (%edx),%ebx
f0100aa7:	8b 01                	mov    (%ecx),%eax
f0100aa9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	while (l <= r) {
f0100aac:	39 c3                	cmp    %eax,%ebx
f0100aae:	0f 8f 9c 00 00 00    	jg     f0100b50 <stab_binsearch+0xc0>
f0100ab4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		int true_m = (l + r) / 2, m = true_m;
f0100abb:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0100abe:	01 d8                	add    %ebx,%eax
f0100ac0:	89 c7                	mov    %eax,%edi
f0100ac2:	c1 ef 1f             	shr    $0x1f,%edi
f0100ac5:	01 c7                	add    %eax,%edi
f0100ac7:	d1 ff                	sar    %edi
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0100ac9:	39 df                	cmp    %ebx,%edi
f0100acb:	7c 33                	jl     f0100b00 <stab_binsearch+0x70>
f0100acd:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100ad0:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0100ad3:	0f b6 44 82 04       	movzbl 0x4(%edx,%eax,4),%eax
f0100ad8:	39 f0                	cmp    %esi,%eax
f0100ada:	0f 84 bc 00 00 00    	je     f0100b9c <stab_binsearch+0x10c>
f0100ae0:	8d 44 7f fd          	lea    -0x3(%edi,%edi,2),%eax
f0100ae4:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx
f0100ae8:	89 f8                	mov    %edi,%eax
			m--;
f0100aea:	83 e8 01             	sub    $0x1,%eax
	
	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0100aed:	39 d8                	cmp    %ebx,%eax
f0100aef:	7c 0f                	jl     f0100b00 <stab_binsearch+0x70>
f0100af1:	0f b6 0a             	movzbl (%edx),%ecx
f0100af4:	83 ea 0c             	sub    $0xc,%edx
f0100af7:	39 f1                	cmp    %esi,%ecx
f0100af9:	75 ef                	jne    f0100aea <stab_binsearch+0x5a>
f0100afb:	e9 9e 00 00 00       	jmp    f0100b9e <stab_binsearch+0x10e>
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0100b00:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0100b03:	eb 3c                	jmp    f0100b41 <stab_binsearch+0xb1>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
f0100b05:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0100b08:	89 01                	mov    %eax,(%ecx)
			l = true_m + 1;
f0100b0a:	8d 5f 01             	lea    0x1(%edi),%ebx
f0100b0d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0100b14:	eb 2b                	jmp    f0100b41 <stab_binsearch+0xb1>
		} else if (stabs[m].n_value > addr) {
f0100b16:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100b19:	76 14                	jbe    f0100b2f <stab_binsearch+0x9f>
			*region_right = m - 1;
f0100b1b:	83 e8 01             	sub    $0x1,%eax
f0100b1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0100b21:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0100b24:	89 02                	mov    %eax,(%edx)
f0100b26:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0100b2d:	eb 12                	jmp    f0100b41 <stab_binsearch+0xb1>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0100b2f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0100b32:	89 01                	mov    %eax,(%ecx)
			l = m;
			addr++;
f0100b34:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0100b38:	89 c3                	mov    %eax,%ebx
f0100b3a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;
	
	while (l <= r) {
f0100b41:	39 5d ec             	cmp    %ebx,-0x14(%ebp)
f0100b44:	0f 8d 71 ff ff ff    	jge    f0100abb <stab_binsearch+0x2b>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f0100b4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0100b4e:	75 0f                	jne    f0100b5f <stab_binsearch+0xcf>
		*region_right = *region_left - 1;
f0100b50:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0100b53:	8b 03                	mov    (%ebx),%eax
f0100b55:	83 e8 01             	sub    $0x1,%eax
f0100b58:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0100b5b:	89 02                	mov    %eax,(%edx)
f0100b5d:	eb 57                	jmp    f0100bb6 <stab_binsearch+0x126>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100b5f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0100b62:	8b 01                	mov    (%ecx),%eax
		     l > *region_left && stabs[l].n_type != type;
f0100b64:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0100b67:	8b 0b                	mov    (%ebx),%ecx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100b69:	39 c1                	cmp    %eax,%ecx
f0100b6b:	7d 28                	jge    f0100b95 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f0100b6d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100b70:	8b 5d f0             	mov    -0x10(%ebp),%ebx
f0100b73:	0f b6 54 93 04       	movzbl 0x4(%ebx,%edx,4),%edx
f0100b78:	39 f2                	cmp    %esi,%edx
f0100b7a:	74 19                	je     f0100b95 <stab_binsearch+0x105>
f0100b7c:	8d 54 40 fd          	lea    -0x3(%eax,%eax,2),%edx
f0100b80:	8d 54 93 04          	lea    0x4(%ebx,%edx,4),%edx
		     l--)
f0100b84:	83 e8 01             	sub    $0x1,%eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100b87:	39 c1                	cmp    %eax,%ecx
f0100b89:	7d 0a                	jge    f0100b95 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f0100b8b:	0f b6 1a             	movzbl (%edx),%ebx
f0100b8e:	83 ea 0c             	sub    $0xc,%edx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100b91:	39 f3                	cmp    %esi,%ebx
f0100b93:	75 ef                	jne    f0100b84 <stab_binsearch+0xf4>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
f0100b95:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0100b98:	89 02                	mov    %eax,(%edx)
f0100b9a:	eb 1a                	jmp    f0100bb6 <stab_binsearch+0x126>
	}
}
f0100b9c:	89 f8                	mov    %edi,%eax
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0100b9e:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100ba1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0100ba4:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0100ba8:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100bab:	0f 82 54 ff ff ff    	jb     f0100b05 <stab_binsearch+0x75>
f0100bb1:	e9 60 ff ff ff       	jmp    f0100b16 <stab_binsearch+0x86>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0100bb6:	83 c4 14             	add    $0x14,%esp
f0100bb9:	5b                   	pop    %ebx
f0100bba:	5e                   	pop    %esi
f0100bbb:	5f                   	pop    %edi
f0100bbc:	5d                   	pop    %ebp
f0100bbd:	c3                   	ret    

f0100bbe <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0100bbe:	55                   	push   %ebp
f0100bbf:	89 e5                	mov    %esp,%ebp
f0100bc1:	83 ec 28             	sub    $0x28,%esp
f0100bc4:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0100bc7:	89 75 fc             	mov    %esi,-0x4(%ebp)
f0100bca:	8b 75 08             	mov    0x8(%ebp),%esi
f0100bcd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0100bd0:	c7 03 88 22 10 f0    	movl   $0xf0102288,(%ebx)
	info->eip_line = 0;
f0100bd6:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0100bdd:	c7 43 08 88 22 10 f0 	movl   $0xf0102288,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0100be4:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0100beb:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0100bee:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0100bf5:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0100bfb:	76 12                	jbe    f0100c0f <debuginfo_eip+0x51>
		// Can't search for user-level addresses yet!
  	        panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100bfd:	b8 58 7f 10 f0       	mov    $0xf0107f58,%eax
f0100c02:	3d 0d 64 10 f0       	cmp    $0xf010640d,%eax
f0100c07:	0f 86 53 01 00 00    	jbe    f0100d60 <debuginfo_eip+0x1a2>
f0100c0d:	eb 1c                	jmp    f0100c2b <debuginfo_eip+0x6d>
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
	} else {
		// Can't search for user-level addresses yet!
  	        panic("User address");
f0100c0f:	c7 44 24 08 92 22 10 	movl   $0xf0102292,0x8(%esp)
f0100c16:	f0 
f0100c17:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
f0100c1e:	00 
f0100c1f:	c7 04 24 9f 22 10 f0 	movl   $0xf010229f,(%esp)
f0100c26:	e8 5a f4 ff ff       	call   f0100085 <_panic>
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100c2b:	80 3d 57 7f 10 f0 00 	cmpb   $0x0,0xf0107f57
f0100c32:	0f 85 28 01 00 00    	jne    f0100d60 <debuginfo_eip+0x1a2>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.
	
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0100c38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	rfile = (stab_end - stabs) - 1;
f0100c3f:	b8 0c 64 10 f0       	mov    $0xf010640c,%eax
f0100c44:	2d 3c 25 10 f0       	sub    $0xf010253c,%eax
f0100c49:	c1 f8 02             	sar    $0x2,%eax
f0100c4c:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0100c52:	83 e8 01             	sub    $0x1,%eax
f0100c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0100c58:	8d 4d f0             	lea    -0x10(%ebp),%ecx
f0100c5b:	8d 55 f4             	lea    -0xc(%ebp),%edx
f0100c5e:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100c62:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0100c69:	b8 3c 25 10 f0       	mov    $0xf010253c,%eax
f0100c6e:	e8 1d fe ff ff       	call   f0100a90 <stab_binsearch>
	if (lfile == 0)
f0100c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100c76:	85 c0                	test   %eax,%eax
f0100c78:	0f 84 e2 00 00 00    	je     f0100d60 <debuginfo_eip+0x1a2>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0100c7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	rfun = rfile;
f0100c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100c84:	89 45 e8             	mov    %eax,-0x18(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0100c87:	8d 4d e8             	lea    -0x18(%ebp),%ecx
f0100c8a:	8d 55 ec             	lea    -0x14(%ebp),%edx
f0100c8d:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100c91:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0100c98:	b8 3c 25 10 f0       	mov    $0xf010253c,%eax
f0100c9d:	e8 ee fd ff ff       	call   f0100a90 <stab_binsearch>

	if (lfun <= rfun) {
f0100ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0100ca5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
f0100ca8:	7f 31                	jg     f0100cdb <debuginfo_eip+0x11d>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0100caa:	6b c0 0c             	imul   $0xc,%eax,%eax
f0100cad:	8b 80 3c 25 10 f0    	mov    -0xfefdac4(%eax),%eax
f0100cb3:	ba 58 7f 10 f0       	mov    $0xf0107f58,%edx
f0100cb8:	81 ea 0d 64 10 f0    	sub    $0xf010640d,%edx
f0100cbe:	39 d0                	cmp    %edx,%eax
f0100cc0:	73 08                	jae    f0100cca <debuginfo_eip+0x10c>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0100cc2:	05 0d 64 10 f0       	add    $0xf010640d,%eax
f0100cc7:	89 43 08             	mov    %eax,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0100cca:	8b 75 ec             	mov    -0x14(%ebp),%esi
f0100ccd:	6b c6 0c             	imul   $0xc,%esi,%eax
f0100cd0:	8b 80 44 25 10 f0    	mov    -0xfefdabc(%eax),%eax
f0100cd6:	89 43 10             	mov    %eax,0x10(%ebx)
f0100cd9:	eb 06                	jmp    f0100ce1 <debuginfo_eip+0x123>
		lline = lfun;
		rline = rfun;
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f0100cdb:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f0100cde:	8b 75 f4             	mov    -0xc(%ebp),%esi
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0100ce1:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f0100ce8:	00 
f0100ce9:	8b 43 08             	mov    0x8(%ebx),%eax
f0100cec:	89 04 24             	mov    %eax,(%esp)
f0100cef:	e8 37 0b 00 00       	call   f010182b <strfind>
f0100cf4:	2b 43 08             	sub    0x8(%ebx),%eax
f0100cf7:	89 43 0c             	mov    %eax,0xc(%ebx)
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
f0100cfa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
f0100cfd:	6b c6 0c             	imul   $0xc,%esi,%eax
f0100d00:	05 44 25 10 f0       	add    $0xf0102544,%eax
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100d05:	eb 06                	jmp    f0100d0d <debuginfo_eip+0x14f>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f0100d07:	83 ee 01             	sub    $0x1,%esi
f0100d0a:	83 e8 0c             	sub    $0xc,%eax
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100d0d:	39 ce                	cmp    %ecx,%esi
f0100d0f:	7c 20                	jl     f0100d31 <debuginfo_eip+0x173>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0100d11:	0f b6 50 fc          	movzbl -0x4(%eax),%edx
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100d15:	80 fa 84             	cmp    $0x84,%dl
f0100d18:	74 5c                	je     f0100d76 <debuginfo_eip+0x1b8>
f0100d1a:	80 fa 64             	cmp    $0x64,%dl
f0100d1d:	75 e8                	jne    f0100d07 <debuginfo_eip+0x149>
f0100d1f:	83 38 00             	cmpl   $0x0,(%eax)
f0100d22:	74 e3                	je     f0100d07 <debuginfo_eip+0x149>
f0100d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0100d28:	eb 4c                	jmp    f0100d76 <debuginfo_eip+0x1b8>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
		info->eip_file = stabstr + stabs[lline].n_strx;
f0100d2a:	05 0d 64 10 f0       	add    $0xf010640d,%eax
f0100d2f:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0100d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0100d34:	3b 45 e8             	cmp    -0x18(%ebp),%eax
f0100d37:	7d 2e                	jge    f0100d67 <debuginfo_eip+0x1a9>
		for (lline = lfun + 1;
f0100d39:	83 c0 01             	add    $0x1,%eax
f0100d3c:	6b d0 0c             	imul   $0xc,%eax,%edx
f0100d3f:	81 c2 40 25 10 f0    	add    $0xf0102540,%edx
f0100d45:	eb 07                	jmp    f0100d4e <debuginfo_eip+0x190>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f0100d47:	83 43 14 01          	addl   $0x1,0x14(%ebx)
	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
f0100d4b:	83 c0 01             	add    $0x1,%eax


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0100d4e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
f0100d51:	7d 14                	jge    f0100d67 <debuginfo_eip+0x1a9>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100d53:	0f b6 0a             	movzbl (%edx),%ecx
f0100d56:	83 c2 0c             	add    $0xc,%edx


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0100d59:	80 f9 a0             	cmp    $0xa0,%cl
f0100d5c:	74 e9                	je     f0100d47 <debuginfo_eip+0x189>
f0100d5e:	eb 07                	jmp    f0100d67 <debuginfo_eip+0x1a9>
f0100d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100d65:	eb 05                	jmp    f0100d6c <debuginfo_eip+0x1ae>
f0100d67:	b8 00 00 00 00       	mov    $0x0,%eax
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
	
	return 0;
}
f0100d6c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0100d6f:	8b 75 fc             	mov    -0x4(%ebp),%esi
f0100d72:	89 ec                	mov    %ebp,%esp
f0100d74:	5d                   	pop    %ebp
f0100d75:	c3                   	ret    
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0100d76:	6b f6 0c             	imul   $0xc,%esi,%esi
f0100d79:	8b 86 3c 25 10 f0    	mov    -0xfefdac4(%esi),%eax
f0100d7f:	ba 58 7f 10 f0       	mov    $0xf0107f58,%edx
f0100d84:	81 ea 0d 64 10 f0    	sub    $0xf010640d,%edx
f0100d8a:	39 d0                	cmp    %edx,%eax
f0100d8c:	72 9c                	jb     f0100d2a <debuginfo_eip+0x16c>
f0100d8e:	eb a1                	jmp    f0100d31 <debuginfo_eip+0x173>

f0100d90 <printnum_width>:
};

static void
printnum_width(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc,int *pamnt,int *pcount)
{
f0100d90:	55                   	push   %ebp
f0100d91:	89 e5                	mov    %esp,%ebp
f0100d93:	57                   	push   %edi
f0100d94:	56                   	push   %esi
f0100d95:	53                   	push   %ebx
f0100d96:	83 ec 4c             	sub    $0x4c,%esp
f0100d99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0100d9c:	89 d7                	mov    %edx,%edi
f0100d9e:	8b 45 08             	mov    0x8(%ebp),%eax
f0100da1:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100da4:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100da7:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100daa:	8b 45 10             	mov    0x10(%ebp),%eax
		int i;
		if(num >= base){
f0100dad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100db0:	be 00 00 00 00       	mov    $0x0,%esi
f0100db5:	39 d6                	cmp    %edx,%esi
f0100db7:	72 07                	jb     f0100dc0 <printnum_width+0x30>
f0100db9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100dbc:	39 c8                	cmp    %ecx,%eax
f0100dbe:	77 70                	ja     f0100e30 <printnum_width+0xa0>
			(*pcount)++;
f0100dc0:	8b 5d 20             	mov    0x20(%ebp),%ebx
f0100dc3:	83 03 01             	addl   $0x1,(%ebx)
			printnum_width(putch, putdat, num / base, base, width - 1, padc, pamnt, pcount);//num/base is used to print the least significant digit
f0100dc6:	89 5c 24 18          	mov    %ebx,0x18(%esp)
f0100dca:	8b 55 1c             	mov    0x1c(%ebp),%edx
f0100dcd:	89 54 24 14          	mov    %edx,0x14(%esp)
f0100dd1:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0100dd4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0100dd8:	8b 55 14             	mov    0x14(%ebp),%edx
f0100ddb:	83 ea 01             	sub    $0x1,%edx
f0100dde:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100de2:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100de6:	8b 44 24 08          	mov    0x8(%esp),%eax
f0100dea:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0100dee:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100df1:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0100df4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100df7:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100dfb:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0100dff:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100e02:	89 0c 24             	mov    %ecx,(%esp)
f0100e05:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100e08:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100e0c:	e8 af 0c 00 00       	call   f0101ac0 <__udivdi3>
f0100e11:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0100e14:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0100e17:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0100e1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0100e1f:	89 04 24             	mov    %eax,(%esp)
f0100e22:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100e26:	89 fa                	mov    %edi,%edx
f0100e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e2b:	e8 60 ff ff ff       	call   f0100d90 <printnum_width>
		}
		putch("0123456789abcdef"[num % base], putdat);
f0100e30:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100e34:	8b 04 24             	mov    (%esp),%eax
f0100e37:	8b 54 24 04          	mov    0x4(%esp),%edx
f0100e3b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100e3e:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0100e41:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100e44:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100e48:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0100e4c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100e4f:	89 0c 24             	mov    %ecx,(%esp)
f0100e52:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100e55:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100e59:	e8 92 0d 00 00       	call   f0101bf0 <__umoddi3>
f0100e5e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0100e61:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0100e65:	0f be 80 ad 22 10 f0 	movsbl -0xfefdd53(%eax),%eax
f0100e6c:	89 04 24             	mov    %eax,(%esp)
f0100e6f:	ff 55 e4             	call   *-0x1c(%ebp)
		(*pamnt)++;//record the times of print operation
f0100e72:	8b 4d 1c             	mov    0x1c(%ebp),%ecx
f0100e75:	8b 01                	mov    (%ecx),%eax
f0100e77:	83 c0 01             	add    $0x1,%eax
f0100e7a:	89 01                	mov    %eax,(%ecx)
		if( *pamnt == (*pcount + 1) ){
f0100e7c:	8b 5d 20             	mov    0x20(%ebp),%ebx
f0100e7f:	8b 13                	mov    (%ebx),%edx
f0100e81:	83 c2 01             	add    $0x1,%edx
f0100e84:	39 d0                	cmp    %edx,%eax
f0100e86:	75 2e                	jne    f0100eb6 <printnum_width+0x126>
			if( width > *pamnt ){
f0100e88:	39 45 14             	cmp    %eax,0x14(%ebp)
f0100e8b:	7e 29                	jle    f0100eb6 <printnum_width+0x126>
				for( i = 0; i < width - *pamnt;  i++){
f0100e8d:	8b 55 14             	mov    0x14(%ebp),%edx
f0100e90:	29 c2                	sub    %eax,%edx
f0100e92:	85 d2                	test   %edx,%edx
f0100e94:	7e 20                	jle    f0100eb6 <printnum_width+0x126>
f0100e96:	be 00 00 00 00       	mov    $0x0,%esi
f0100e9b:	89 cb                	mov    %ecx,%ebx
					putch(padc, putdat);
f0100e9d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100ea1:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0100ea4:	89 0c 24             	mov    %ecx,(%esp)
f0100ea7:	ff 55 e4             	call   *-0x1c(%ebp)
		}
		putch("0123456789abcdef"[num % base], putdat);
		(*pamnt)++;//record the times of print operation
		if( *pamnt == (*pcount + 1) ){
			if( width > *pamnt ){
				for( i = 0; i < width - *pamnt;  i++){
f0100eaa:	83 c6 01             	add    $0x1,%esi
f0100ead:	8b 45 14             	mov    0x14(%ebp),%eax
f0100eb0:	2b 03                	sub    (%ebx),%eax
f0100eb2:	39 f0                	cmp    %esi,%eax
f0100eb4:	7f e7                	jg     f0100e9d <printnum_width+0x10d>
					putch(padc, putdat);
				}	
			}
        	}
		return;
}
f0100eb6:	83 c4 4c             	add    $0x4c,%esp
f0100eb9:	5b                   	pop    %ebx
f0100eba:	5e                   	pop    %esi
f0100ebb:	5f                   	pop    %edi
f0100ebc:	5d                   	pop    %ebp
f0100ebd:	c3                   	ret    

f0100ebe <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0100ebe:	55                   	push   %ebp
f0100ebf:	89 e5                	mov    %esp,%ebp
f0100ec1:	57                   	push   %edi
f0100ec2:	56                   	push   %esi
f0100ec3:	53                   	push   %ebx
f0100ec4:	83 ec 5c             	sub    $0x5c,%esp
f0100ec7:	89 c7                	mov    %eax,%edi
f0100ec9:	89 d6                	mov    %edx,%esi
f0100ecb:	8b 45 08             	mov    0x8(%ebp),%eax
f0100ece:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0100ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100ed4:	89 55 cc             	mov    %edx,-0x34(%ebp)
f0100ed7:	8b 55 10             	mov    0x10(%ebp),%edx
f0100eda:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	int amnt = 0, count = 0; 
f0100edd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0100ee4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	if( 9 > width && width > 0 ){
f0100eeb:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0100eee:	83 f8 07             	cmp    $0x7,%eax
f0100ef1:	77 38                	ja     f0100f2b <printnum+0x6d>
		printnum_width(putch, putdat, num, base, width, padc, &amnt, &count);
f0100ef3:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0100ef6:	89 44 24 18          	mov    %eax,0x18(%esp)
f0100efa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0100efd:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100f01:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0100f04:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0100f08:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0100f0c:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100f10:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0100f13:	89 1c 24             	mov    %ebx,(%esp)
f0100f16:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0100f19:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100f1d:	89 f2                	mov    %esi,%edx
f0100f1f:	89 f8                	mov    %edi,%eax
f0100f21:	e8 6a fe ff ff       	call   f0100d90 <printnum_width>
		return;
f0100f26:	e9 cd 00 00 00       	jmp    f0100ff8 <printnum+0x13a>
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0100f2b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0100f2e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
f0100f32:	77 17                	ja     f0100f4b <printnum+0x8d>
f0100f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0100f38:	72 08                	jb     f0100f42 <printnum+0x84>
f0100f3a:	39 55 c8             	cmp    %edx,-0x38(%ebp)
f0100f3d:	8d 76 00             	lea    0x0(%esi),%esi
f0100f40:	73 09                	jae    f0100f4b <printnum+0x8d>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
f0100f42:	83 eb 01             	sub    $0x1,%ebx
f0100f45:	85 db                	test   %ebx,%ebx
f0100f47:	7f 63                	jg     f0100fac <printnum+0xee>
f0100f49:	eb 74                	jmp    f0100fbf <printnum+0x101>
		printnum_width(putch, putdat, num, base, width, padc, &amnt, &count);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0100f4b:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0100f4e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0100f52:	83 eb 01             	sub    $0x1,%ebx
f0100f55:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0100f59:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100f5d:	8b 44 24 08          	mov    0x8(%esp),%eax
f0100f61:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0100f65:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100f68:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0100f6b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0100f6e:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100f72:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0100f79:	00 
f0100f7a:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0100f7d:	89 0c 24             	mov    %ecx,(%esp)
f0100f80:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0100f83:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100f87:	e8 34 0b 00 00       	call   f0101ac0 <__udivdi3>
f0100f8c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100f8f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100f92:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0100f96:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0100f9a:	89 04 24             	mov    %eax,(%esp)
f0100f9d:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100fa1:	89 f2                	mov    %esi,%edx
f0100fa3:	89 f8                	mov    %edi,%eax
f0100fa5:	e8 14 ff ff ff       	call   f0100ebe <printnum>
f0100faa:	eb 13                	jmp    f0100fbf <printnum+0x101>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
			putch(padc, putdat);
f0100fac:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100fb0:	8b 45 18             	mov    0x18(%ebp),%eax
f0100fb3:	89 04 24             	mov    %eax,(%esp)
f0100fb6:	ff d7                	call   *%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
f0100fb8:	83 eb 01             	sub    $0x1,%ebx
f0100fbb:	85 db                	test   %ebx,%ebx
f0100fbd:	7f ed                	jg     f0100fac <printnum+0xee>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit// highest digit
	putch("0123456789abcdef"[num % base], putdat);
f0100fbf:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100fc3:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100fc7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0100fca:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100fce:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0100fd5:	00 
f0100fd6:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0100fd9:	89 0c 24             	mov    %ecx,(%esp)
f0100fdc:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0100fdf:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100fe3:	e8 08 0c 00 00       	call   f0101bf0 <__umoddi3>
f0100fe8:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100fec:	0f be 80 ad 22 10 f0 	movsbl -0xfefdd53(%eax),%eax
f0100ff3:	89 04 24             	mov    %eax,(%esp)
f0100ff6:	ff d7                	call   *%edi
}
f0100ff8:	83 c4 5c             	add    $0x5c,%esp
f0100ffb:	5b                   	pop    %ebx
f0100ffc:	5e                   	pop    %esi
f0100ffd:	5f                   	pop    %edi
f0100ffe:	5d                   	pop    %ebp
f0100fff:	c3                   	ret    

f0101000 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f0101000:	55                   	push   %ebp
f0101001:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0101003:	83 fa 01             	cmp    $0x1,%edx
f0101006:	7e 0e                	jle    f0101016 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
f0101008:	8b 10                	mov    (%eax),%edx
f010100a:	8d 4a 08             	lea    0x8(%edx),%ecx
f010100d:	89 08                	mov    %ecx,(%eax)
f010100f:	8b 02                	mov    (%edx),%eax
f0101011:	8b 52 04             	mov    0x4(%edx),%edx
f0101014:	eb 22                	jmp    f0101038 <getuint+0x38>
	else if (lflag)
f0101016:	85 d2                	test   %edx,%edx
f0101018:	74 10                	je     f010102a <getuint+0x2a>
		return va_arg(*ap, unsigned long);
f010101a:	8b 10                	mov    (%eax),%edx
f010101c:	8d 4a 04             	lea    0x4(%edx),%ecx
f010101f:	89 08                	mov    %ecx,(%eax)
f0101021:	8b 02                	mov    (%edx),%eax
f0101023:	ba 00 00 00 00       	mov    $0x0,%edx
f0101028:	eb 0e                	jmp    f0101038 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
f010102a:	8b 10                	mov    (%eax),%edx
f010102c:	8d 4a 04             	lea    0x4(%edx),%ecx
f010102f:	89 08                	mov    %ecx,(%eax)
f0101031:	8b 02                	mov    (%edx),%eax
f0101033:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0101038:	5d                   	pop    %ebp
f0101039:	c3                   	ret    

f010103a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
f010103a:	55                   	push   %ebp
f010103b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f010103d:	83 fa 01             	cmp    $0x1,%edx
f0101040:	7e 0e                	jle    f0101050 <getint+0x16>
		return va_arg(*ap, long long);
f0101042:	8b 10                	mov    (%eax),%edx
f0101044:	8d 4a 08             	lea    0x8(%edx),%ecx
f0101047:	89 08                	mov    %ecx,(%eax)
f0101049:	8b 02                	mov    (%edx),%eax
f010104b:	8b 52 04             	mov    0x4(%edx),%edx
f010104e:	eb 22                	jmp    f0101072 <getint+0x38>
	else if (lflag)
f0101050:	85 d2                	test   %edx,%edx
f0101052:	74 10                	je     f0101064 <getint+0x2a>
		return va_arg(*ap, long);
f0101054:	8b 10                	mov    (%eax),%edx
f0101056:	8d 4a 04             	lea    0x4(%edx),%ecx
f0101059:	89 08                	mov    %ecx,(%eax)
f010105b:	8b 02                	mov    (%edx),%eax
f010105d:	89 c2                	mov    %eax,%edx
f010105f:	c1 fa 1f             	sar    $0x1f,%edx
f0101062:	eb 0e                	jmp    f0101072 <getint+0x38>
	else
		return va_arg(*ap, int);
f0101064:	8b 10                	mov    (%eax),%edx
f0101066:	8d 4a 04             	lea    0x4(%edx),%ecx
f0101069:	89 08                	mov    %ecx,(%eax)
f010106b:	8b 02                	mov    (%edx),%eax
f010106d:	89 c2                	mov    %eax,%edx
f010106f:	c1 fa 1f             	sar    $0x1f,%edx
}
f0101072:	5d                   	pop    %ebp
f0101073:	c3                   	ret    

f0101074 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0101074:	55                   	push   %ebp
f0101075:	89 e5                	mov    %esp,%ebp
f0101077:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f010107a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f010107e:	8b 10                	mov    (%eax),%edx
f0101080:	3b 50 04             	cmp    0x4(%eax),%edx
f0101083:	73 0a                	jae    f010108f <sprintputch+0x1b>
		*b->buf++ = ch;
f0101085:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101088:	88 0a                	mov    %cl,(%edx)
f010108a:	83 c2 01             	add    $0x1,%edx
f010108d:	89 10                	mov    %edx,(%eax)
}
f010108f:	5d                   	pop    %ebp
f0101090:	c3                   	ret    

f0101091 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f0101091:	55                   	push   %ebp
f0101092:	89 e5                	mov    %esp,%ebp
f0101094:	57                   	push   %edi
f0101095:	56                   	push   %esi
f0101096:	53                   	push   %ebx
f0101097:	83 ec 5c             	sub    $0x5c,%esp
f010109a:	8b 7d 0c             	mov    0xc(%ebp),%edi
f010109d:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
f01010a0:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
f01010a7:	eb 17                	jmp    f01010c0 <vprintfmt+0x2f>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f01010a9:	85 c0                	test   %eax,%eax
f01010ab:	0f 84 65 04 00 00    	je     f0101516 <vprintfmt+0x485>
				return;
			putch(ch, putdat);
f01010b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01010b5:	89 04 24             	mov    %eax,(%esp)
f01010b8:	ff 55 08             	call   *0x8(%ebp)
f01010bb:	eb 03                	jmp    f01010c0 <vprintfmt+0x2f>
f01010bd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01010c0:	0f b6 03             	movzbl (%ebx),%eax
f01010c3:	83 c3 01             	add    $0x1,%ebx
f01010c6:	83 f8 25             	cmp    $0x25,%eax
f01010c9:	75 de                	jne    f01010a9 <vprintfmt+0x18>
f01010cb:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
f01010cf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f01010d6:	be ff ff ff ff       	mov    $0xffffffff,%esi
f01010db:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
f01010e2:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
f01010e9:	eb 06                	jmp    f01010f1 <vprintfmt+0x60>
f01010eb:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f01010ef:	89 cb                	mov    %ecx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01010f1:	0f b6 03             	movzbl (%ebx),%eax
f01010f4:	0f b6 d0             	movzbl %al,%edx
f01010f7:	8d 4b 01             	lea    0x1(%ebx),%ecx
f01010fa:	83 e8 23             	sub    $0x23,%eax
f01010fd:	3c 55                	cmp    $0x55,%al
f01010ff:	0f 87 f3 03 00 00    	ja     f01014f8 <vprintfmt+0x467>
f0101105:	0f b6 c0             	movzbl %al,%eax
f0101108:	ff 24 85 b8 23 10 f0 	jmp    *-0xfefdc48(,%eax,4)
f010110f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f0101113:	eb da                	jmp    f01010ef <vprintfmt+0x5e>
			width = 8;
			padc = ' ';
			goto reswitch;
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f0101115:	8d 72 d0             	lea    -0x30(%edx),%esi
				ch = *fmt;
f0101118:	0f be 01             	movsbl (%ecx),%eax
				if (ch < '0' || ch > '9')
f010111b:	8d 50 d0             	lea    -0x30(%eax),%edx
f010111e:	83 fa 09             	cmp    $0x9,%edx
f0101121:	76 0f                	jbe    f0101132 <vprintfmt+0xa1>
f0101123:	eb 47                	jmp    f010116c <vprintfmt+0xdb>
f0101125:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
f0101129:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
			width = 8;
			padc = ' ';
			goto reswitch;
f0101130:	eb bd                	jmp    f01010ef <vprintfmt+0x5e>
		case '9':
			for (precision = 0; ; ++fmt) {
f0101132:	83 c1 01             	add    $0x1,%ecx
				precision = precision * 10 + ch - '0';
f0101135:	8d 14 b6             	lea    (%esi,%esi,4),%edx
f0101138:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
f010113c:	0f be 01             	movsbl (%ecx),%eax
				if (ch < '0' || ch > '9')
f010113f:	8d 50 d0             	lea    -0x30(%eax),%edx
f0101142:	83 fa 09             	cmp    $0x9,%edx
f0101145:	76 eb                	jbe    f0101132 <vprintfmt+0xa1>
f0101147:	eb 23                	jmp    f010116c <vprintfmt+0xdb>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0101149:	8b 45 14             	mov    0x14(%ebp),%eax
f010114c:	8d 50 04             	lea    0x4(%eax),%edx
f010114f:	89 55 14             	mov    %edx,0x14(%ebp)
f0101152:	8b 30                	mov    (%eax),%esi
			goto process_precision;
f0101154:	eb 16                	jmp    f010116c <vprintfmt+0xdb>

		case '.':
			if (width < 0)
f0101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101159:	c1 f8 1f             	sar    $0x1f,%eax
f010115c:	f7 d0                	not    %eax
f010115e:	21 45 e4             	and    %eax,-0x1c(%ebp)
f0101161:	eb 8c                	jmp    f01010ef <vprintfmt+0x5e>
f0101163:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
f010116a:	eb 83                	jmp    f01010ef <vprintfmt+0x5e>

		process_precision:
			if (width < 0)
f010116c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0101170:	0f 89 79 ff ff ff    	jns    f01010ef <vprintfmt+0x5e>
f0101176:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f0101179:	8b 75 c8             	mov    -0x38(%ebp),%esi
f010117c:	e9 6e ff ff ff       	jmp    f01010ef <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f0101181:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
			goto reswitch;
f0101185:	e9 65 ff ff ff       	jmp    f01010ef <vprintfmt+0x5e>
f010118a:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f010118d:	8b 45 14             	mov    0x14(%ebp),%eax
f0101190:	8d 50 04             	lea    0x4(%eax),%edx
f0101193:	89 55 14             	mov    %edx,0x14(%ebp)
f0101196:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010119a:	8b 00                	mov    (%eax),%eax
f010119c:	89 04 24             	mov    %eax,(%esp)
f010119f:	ff 55 08             	call   *0x8(%ebp)
f01011a2:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f01011a5:	e9 16 ff ff ff       	jmp    f01010c0 <vprintfmt+0x2f>
f01011aa:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
f01011ad:	8b 45 14             	mov    0x14(%ebp),%eax
f01011b0:	8d 50 04             	lea    0x4(%eax),%edx
f01011b3:	89 55 14             	mov    %edx,0x14(%ebp)
f01011b6:	8b 00                	mov    (%eax),%eax
f01011b8:	89 c2                	mov    %eax,%edx
f01011ba:	c1 fa 1f             	sar    $0x1f,%edx
f01011bd:	31 d0                	xor    %edx,%eax
f01011bf:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01011c1:	83 f8 06             	cmp    $0x6,%eax
f01011c4:	7f 0b                	jg     f01011d1 <vprintfmt+0x140>
f01011c6:	8b 14 85 10 25 10 f0 	mov    -0xfefdaf0(,%eax,4),%edx
f01011cd:	85 d2                	test   %edx,%edx
f01011cf:	75 23                	jne    f01011f4 <vprintfmt+0x163>
				printfmt(putch, putdat, "error %d", err);
f01011d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01011d5:	c7 44 24 08 be 22 10 	movl   $0xf01022be,0x8(%esp)
f01011dc:	f0 
f01011dd:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01011e1:	8b 45 08             	mov    0x8(%ebp),%eax
f01011e4:	89 04 24             	mov    %eax,(%esp)
f01011e7:	e8 b2 03 00 00       	call   f010159e <printfmt>
f01011ec:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01011ef:	e9 cc fe ff ff       	jmp    f01010c0 <vprintfmt+0x2f>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
f01011f4:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01011f8:	c7 44 24 08 c7 22 10 	movl   $0xf01022c7,0x8(%esp)
f01011ff:	f0 
f0101200:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101204:	8b 55 08             	mov    0x8(%ebp),%edx
f0101207:	89 14 24             	mov    %edx,(%esp)
f010120a:	e8 8f 03 00 00       	call   f010159e <printfmt>
f010120f:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0101212:	e9 a9 fe ff ff       	jmp    f01010c0 <vprintfmt+0x2f>
f0101217:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f010121a:	89 cb                	mov    %ecx,%ebx
f010121c:	89 f1                	mov    %esi,%ecx
f010121e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101221:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0101224:	8b 45 14             	mov    0x14(%ebp),%eax
f0101227:	8d 50 04             	lea    0x4(%eax),%edx
f010122a:	89 55 14             	mov    %edx,0x14(%ebp)
f010122d:	8b 00                	mov    (%eax),%eax
f010122f:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101232:	85 c0                	test   %eax,%eax
f0101234:	75 07                	jne    f010123d <vprintfmt+0x1ac>
f0101236:	c7 45 d0 ca 22 10 f0 	movl   $0xf01022ca,-0x30(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
f010123d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f0101241:	7e 06                	jle    f0101249 <vprintfmt+0x1b8>
f0101243:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f0101247:	75 13                	jne    f010125c <vprintfmt+0x1cb>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0101249:	8b 55 d0             	mov    -0x30(%ebp),%edx
f010124c:	0f be 02             	movsbl (%edx),%eax
f010124f:	85 c0                	test   %eax,%eax
f0101251:	0f 85 94 00 00 00    	jne    f01012eb <vprintfmt+0x25a>
f0101257:	e9 84 00 00 00       	jmp    f01012e0 <vprintfmt+0x24f>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f010125c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0101260:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101263:	89 04 24             	mov    %eax,(%esp)
f0101266:	e8 60 04 00 00       	call   f01016cb <strnlen>
f010126b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f010126e:	29 c2                	sub    %eax,%edx
f0101270:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101273:	85 d2                	test   %edx,%edx
f0101275:	7e d2                	jle    f0101249 <vprintfmt+0x1b8>
					putch(padc, putdat);
f0101277:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f010127b:	89 75 c4             	mov    %esi,-0x3c(%ebp)
f010127e:	89 5d c0             	mov    %ebx,-0x40(%ebp)
f0101281:	89 d3                	mov    %edx,%ebx
f0101283:	89 c6                	mov    %eax,%esi
f0101285:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101289:	89 34 24             	mov    %esi,(%esp)
f010128c:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f010128f:	83 eb 01             	sub    $0x1,%ebx
f0101292:	85 db                	test   %ebx,%ebx
f0101294:	7f ef                	jg     f0101285 <vprintfmt+0x1f4>
f0101296:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0101299:	8b 5d c0             	mov    -0x40(%ebp),%ebx
f010129c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f01012a3:	eb a4                	jmp    f0101249 <vprintfmt+0x1b8>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f01012a5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f01012a9:	74 18                	je     f01012c3 <vprintfmt+0x232>
f01012ab:	8d 50 e0             	lea    -0x20(%eax),%edx
f01012ae:	83 fa 5e             	cmp    $0x5e,%edx
f01012b1:	76 10                	jbe    f01012c3 <vprintfmt+0x232>
					putch('?', putdat);
f01012b3:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01012b7:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f01012be:	ff 55 08             	call   *0x8(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f01012c1:	eb 0a                	jmp    f01012cd <vprintfmt+0x23c>
					putch('?', putdat);
				else
					putch(ch, putdat);
f01012c3:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01012c7:	89 04 24             	mov    %eax,(%esp)
f01012ca:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f01012cd:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
f01012d1:	0f be 03             	movsbl (%ebx),%eax
f01012d4:	85 c0                	test   %eax,%eax
f01012d6:	74 05                	je     f01012dd <vprintfmt+0x24c>
f01012d8:	83 c3 01             	add    $0x1,%ebx
f01012db:	eb 19                	jmp    f01012f6 <vprintfmt+0x265>
f01012dd:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f01012e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01012e4:	7f 1e                	jg     f0101304 <vprintfmt+0x273>
f01012e6:	e9 d2 fd ff ff       	jmp    f01010bd <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f01012eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01012ee:	83 c2 01             	add    $0x1,%edx
f01012f1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
f01012f4:	89 d3                	mov    %edx,%ebx
f01012f6:	85 f6                	test   %esi,%esi
f01012f8:	78 ab                	js     f01012a5 <vprintfmt+0x214>
f01012fa:	83 ee 01             	sub    $0x1,%esi
f01012fd:	79 a6                	jns    f01012a5 <vprintfmt+0x214>
f01012ff:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0101302:	eb dc                	jmp    f01012e0 <vprintfmt+0x24f>
f0101304:	8b 75 08             	mov    0x8(%ebp),%esi
f0101307:	89 5d d8             	mov    %ebx,-0x28(%ebp)
f010130a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f010130d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101311:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0101318:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f010131a:	83 eb 01             	sub    $0x1,%ebx
f010131d:	85 db                	test   %ebx,%ebx
f010131f:	7f ec                	jg     f010130d <vprintfmt+0x27c>
f0101321:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f0101324:	e9 97 fd ff ff       	jmp    f01010c0 <vprintfmt+0x2f>
f0101329:	89 4d cc             	mov    %ecx,-0x34(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);//different data type
f010132c:	8b 55 d0             	mov    -0x30(%ebp),%edx
f010132f:	8d 45 14             	lea    0x14(%ebp),%eax
f0101332:	e8 03 fd ff ff       	call   f010103a <getint>
f0101337:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010133a:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010133d:	89 c3                	mov    %eax,%ebx
f010133f:	89 d6                	mov    %edx,%esi
f0101341:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
f0101346:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f010134a:	0f 89 b2 00 00 00    	jns    f0101402 <vprintfmt+0x371>
				putch('-', putdat);
f0101350:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101354:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f010135b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f010135e:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f0101361:	8b 75 dc             	mov    -0x24(%ebp),%esi
f0101364:	f7 db                	neg    %ebx
f0101366:	83 d6 00             	adc    $0x0,%esi
f0101369:	f7 de                	neg    %esi
f010136b:	ba 0a 00 00 00       	mov    $0xa,%edx
f0101370:	e9 8d 00 00 00       	jmp    f0101402 <vprintfmt+0x371>
f0101375:	89 4d cc             	mov    %ecx,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f0101378:	8b 55 d0             	mov    -0x30(%ebp),%edx
f010137b:	8d 45 14             	lea    0x14(%ebp),%eax
f010137e:	e8 7d fc ff ff       	call   f0101000 <getuint>
f0101383:	89 c3                	mov    %eax,%ebx
f0101385:	89 d6                	mov    %edx,%esi
f0101387:	ba 0a 00 00 00       	mov    $0xa,%edx
			base = 10;
			goto number;
f010138c:	eb 74                	jmp    f0101402 <vprintfmt+0x371>
f010138e:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			// display a number in octal form and the form should begin with '0'
			putch('0', putdat);
f0101391:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101395:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f010139c:	ff 55 08             	call   *0x8(%ebp)
			num = getuint(&ap, lflag);
f010139f:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01013a2:	8d 45 14             	lea    0x14(%ebp),%eax
f01013a5:	e8 56 fc ff ff       	call   f0101000 <getuint>
f01013aa:	89 c3                	mov    %eax,%ebx
f01013ac:	89 d6                	mov    %edx,%esi
f01013ae:	ba 08 00 00 00       	mov    $0x8,%edx
			base = 8;
			goto number;
f01013b3:	eb 4d                	jmp    f0101402 <vprintfmt+0x371>
f01013b5:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
f01013b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01013bc:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f01013c3:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f01013c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01013ca:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f01013d1:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
f01013d4:	8b 45 14             	mov    0x14(%ebp),%eax
f01013d7:	8d 50 04             	lea    0x4(%eax),%edx
f01013da:	89 55 14             	mov    %edx,0x14(%ebp)
f01013dd:	8b 18                	mov    (%eax),%ebx
f01013df:	be 00 00 00 00       	mov    $0x0,%esi
f01013e4:	ba 10 00 00 00       	mov    $0x10,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
f01013e9:	eb 17                	jmp    f0101402 <vprintfmt+0x371>
f01013eb:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':

			num = getuint(&ap, lflag);
f01013ee:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01013f1:	8d 45 14             	lea    0x14(%ebp),%eax
f01013f4:	e8 07 fc ff ff       	call   f0101000 <getuint>
f01013f9:	89 c3                	mov    %eax,%ebx
f01013fb:	89 d6                	mov    %edx,%esi
f01013fd:	ba 10 00 00 00       	mov    $0x10,%edx
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
f0101402:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f0101406:	89 44 24 10          	mov    %eax,0x10(%esp)
f010140a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010140d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101411:	89 54 24 08          	mov    %edx,0x8(%esp)
f0101415:	89 1c 24             	mov    %ebx,(%esp)
f0101418:	89 74 24 04          	mov    %esi,0x4(%esp)
f010141c:	89 fa                	mov    %edi,%edx
f010141e:	8b 45 08             	mov    0x8(%ebp),%eax
f0101421:	e8 98 fa ff ff       	call   f0100ebe <printnum>
f0101426:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f0101429:	e9 92 fc ff ff       	jmp    f01010c0 <vprintfmt+0x2f>
f010142e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
            //        can represent.

            const char *null_error = "\nerror! writing through NULL pointer! (%n argument)\n";
            const char *overflow_error = "\nwarning! The value %n argument pointed to has been overflowed!\n";
            // Your code here
	    q = va_arg(ap, char *);//after call va_arg(), it will point to next argument
f0101431:	8b 45 14             	mov    0x14(%ebp),%eax
f0101434:	8d 50 04             	lea    0x4(%eax),%edx
f0101437:	89 55 14             	mov    %edx,0x14(%ebp)
f010143a:	8b 30                	mov    (%eax),%esi
	    if ( q == NULL ){
f010143c:	85 f6                	test   %esi,%esi
f010143e:	75 21                	jne    f0101461 <vprintfmt+0x3d0>
f0101440:	bb 3d 23 10 f0       	mov    $0xf010233d,%ebx
f0101445:	b8 0a 00 00 00       	mov    $0xa,%eax
		while ((ch = *null_error++) != '\0') {
                        cputchar(ch);
f010144a:	89 04 24             	mov    %eax,(%esp)
f010144d:	e8 38 f1 ff ff       	call   f010058a <cputchar>
            const char *null_error = "\nerror! writing through NULL pointer! (%n argument)\n";
            const char *overflow_error = "\nwarning! The value %n argument pointed to has been overflowed!\n";
            // Your code here
	    q = va_arg(ap, char *);//after call va_arg(), it will point to next argument
	    if ( q == NULL ){
		while ((ch = *null_error++) != '\0') {
f0101452:	0f be 03             	movsbl (%ebx),%eax
f0101455:	83 c3 01             	add    $0x1,%ebx
f0101458:	85 c0                	test   %eax,%eax
f010145a:	75 ee                	jne    f010144a <vprintfmt+0x3b9>
f010145c:	e9 5c fc ff ff       	jmp    f01010bd <vprintfmt+0x2c>
                        cputchar(ch);
                }
	    	break;
	    }
	    if ( *(unsigned char *)putdat >= 255 ){//why did it can't be 255?  
f0101461:	80 3f ff             	cmpb   $0xff,(%edi)
f0101464:	75 27                	jne    f010148d <vprintfmt+0x3fc>
f0101466:	bb 75 23 10 f0       	mov    $0xf0102375,%ebx
f010146b:	b8 0a 00 00 00       	mov    $0xa,%eax
		while ((ch = *(char *) overflow_error++) != '\0') {
                        cputchar(ch);
f0101470:	89 04 24             	mov    %eax,(%esp)
f0101473:	e8 12 f1 ff ff       	call   f010058a <cputchar>
                        cputchar(ch);
                }
	    	break;
	    }
	    if ( *(unsigned char *)putdat >= 255 ){//why did it can't be 255?  
		while ((ch = *(char *) overflow_error++) != '\0') {
f0101478:	0f be 03             	movsbl (%ebx),%eax
f010147b:	83 c3 01             	add    $0x1,%ebx
f010147e:	85 c0                	test   %eax,%eax
f0101480:	75 ee                	jne    f0101470 <vprintfmt+0x3df>
                        cputchar(ch);
                }
		*q = -1;
f0101482:	c6 06 ff             	movb   $0xff,(%esi)
f0101485:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		break;
f0101488:	e9 33 fc ff ff       	jmp    f01010c0 <vprintfmt+0x2f>
	    }
 	    *q = *(char *)putdat;
f010148d:	0f b6 07             	movzbl (%edi),%eax
f0101490:	88 06                	mov    %al,(%esi)
f0101492:	8b 5d cc             	mov    -0x34(%ebp),%ebx
            break;
f0101495:	e9 26 fc ff ff       	jmp    f01010c0 <vprintfmt+0x2f>
f010149a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
        }
		// escaped '%' character
		case '%':
			putch(ch, putdat);
f010149d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01014a1:	89 14 24             	mov    %edx,(%esp)
f01014a4:	ff 55 08             	call   *0x8(%ebp)
f01014a7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f01014aa:	e9 11 fc ff ff       	jmp    f01010c0 <vprintfmt+0x2f>
f01014af:	89 4d cc             	mov    %ecx,-0x34(%ebp)
			
		// unrecognized escape sequence - just print it literally
		//precede the result with a plus or minus sign (+ or -) even for positive numbers-added by tww
		case '+':
			num = getint(&ap, lflag);//after call getint(),the argument will go to next
f01014b2:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01014b5:	8d 45 14             	lea    0x14(%ebp),%eax
f01014b8:	e8 7d fb ff ff       	call   f010103a <getint>
f01014bd:	89 c3                	mov    %eax,%ebx
f01014bf:	89 d6                	mov    %edx,%esi
		        if ((long long) num < 0) {
f01014c1:	85 d2                	test   %edx,%edx
f01014c3:	79 17                	jns    f01014dc <vprintfmt+0x44b>
				putch('-', putdat);
f01014c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01014c9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f01014d0:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f01014d3:	f7 db                	neg    %ebx
f01014d5:	83 d6 00             	adc    $0x0,%esi
f01014d8:	f7 de                	neg    %esi
f01014da:	eb 0e                	jmp    f01014ea <vprintfmt+0x459>
			}
			else{
				putch('+', putdat);
f01014dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01014e0:	c7 04 24 2b 00 00 00 	movl   $0x2b,(%esp)
f01014e7:	ff 55 08             	call   *0x8(%ebp)
			}
			base = 10;
			fmt++;
f01014ea:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
f01014ee:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
f01014f3:	e9 0a ff ff ff       	jmp    f0101402 <vprintfmt+0x371>
		default:
			putch('%', putdat);
f01014f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01014fc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0101503:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f0101506:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0101509:	80 38 25             	cmpb   $0x25,(%eax)
f010150c:	0f 84 ae fb ff ff    	je     f01010c0 <vprintfmt+0x2f>
f0101512:	89 c3                	mov    %eax,%ebx
f0101514:	eb f0                	jmp    f0101506 <vprintfmt+0x475>
				/* do nothing */;
			break;
		}
	}
}
f0101516:	83 c4 5c             	add    $0x5c,%esp
f0101519:	5b                   	pop    %ebx
f010151a:	5e                   	pop    %esi
f010151b:	5f                   	pop    %edi
f010151c:	5d                   	pop    %ebp
f010151d:	c3                   	ret    

f010151e <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f010151e:	55                   	push   %ebp
f010151f:	89 e5                	mov    %esp,%ebp
f0101521:	83 ec 28             	sub    $0x28,%esp
f0101524:	8b 45 08             	mov    0x8(%ebp),%eax
f0101527:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
f010152a:	85 c0                	test   %eax,%eax
f010152c:	74 04                	je     f0101532 <vsnprintf+0x14>
f010152e:	85 d2                	test   %edx,%edx
f0101530:	7f 07                	jg     f0101539 <vsnprintf+0x1b>
f0101532:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0101537:	eb 3b                	jmp    f0101574 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
f0101539:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010153c:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
f0101540:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0101543:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f010154a:	8b 45 14             	mov    0x14(%ebp),%eax
f010154d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101551:	8b 45 10             	mov    0x10(%ebp),%eax
f0101554:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101558:	8d 45 ec             	lea    -0x14(%ebp),%eax
f010155b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010155f:	c7 04 24 74 10 10 f0 	movl   $0xf0101074,(%esp)
f0101566:	e8 26 fb ff ff       	call   f0101091 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f010156b:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010156e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0101571:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f0101574:	c9                   	leave  
f0101575:	c3                   	ret    

f0101576 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0101576:	55                   	push   %ebp
f0101577:	89 e5                	mov    %esp,%ebp
f0101579:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
f010157c:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
f010157f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101583:	8b 45 10             	mov    0x10(%ebp),%eax
f0101586:	89 44 24 08          	mov    %eax,0x8(%esp)
f010158a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010158d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101591:	8b 45 08             	mov    0x8(%ebp),%eax
f0101594:	89 04 24             	mov    %eax,(%esp)
f0101597:	e8 82 ff ff ff       	call   f010151e <vsnprintf>
	va_end(ap);

	return rc;
}
f010159c:	c9                   	leave  
f010159d:	c3                   	ret    

f010159e <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...)
{
f010159e:	55                   	push   %ebp
f010159f:	89 e5                	mov    %esp,%ebp
f01015a1:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...)
f01015a4:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
f01015a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01015ab:	8b 45 10             	mov    0x10(%ebp),%eax
f01015ae:	89 44 24 08          	mov    %eax,0x8(%esp)
f01015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
f01015b5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01015b9:	8b 45 08             	mov    0x8(%ebp),%eax
f01015bc:	89 04 24             	mov    %eax,(%esp)
f01015bf:	e8 cd fa ff ff       	call   f0101091 <vprintfmt>
	va_end(ap);
}
f01015c4:	c9                   	leave  
f01015c5:	c3                   	ret    
	...

f01015d0 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f01015d0:	55                   	push   %ebp
f01015d1:	89 e5                	mov    %esp,%ebp
f01015d3:	57                   	push   %edi
f01015d4:	56                   	push   %esi
f01015d5:	53                   	push   %ebx
f01015d6:	83 ec 1c             	sub    $0x1c,%esp
f01015d9:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f01015dc:	85 c0                	test   %eax,%eax
f01015de:	74 10                	je     f01015f0 <readline+0x20>
		cprintf("%s", prompt);
f01015e0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01015e4:	c7 04 24 c7 22 10 f0 	movl   $0xf01022c7,(%esp)
f01015eb:	e8 5b f4 ff ff       	call   f0100a4b <cprintf>

	i = 0;
	echoing = iscons(0);
f01015f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01015f7:	e8 8a ed ff ff       	call   f0100386 <iscons>
f01015fc:	89 c7                	mov    %eax,%edi
f01015fe:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
f0101603:	e8 6d ed ff ff       	call   f0100375 <getchar>
f0101608:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f010160a:	85 c0                	test   %eax,%eax
f010160c:	79 17                	jns    f0101625 <readline+0x55>
			cprintf("read error: %e\n", c);
f010160e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101612:	c7 04 24 2c 25 10 f0 	movl   $0xf010252c,(%esp)
f0101619:	e8 2d f4 ff ff       	call   f0100a4b <cprintf>
f010161e:	b8 00 00 00 00       	mov    $0x0,%eax
			return NULL;
f0101623:	eb 76                	jmp    f010169b <readline+0xcb>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0101625:	83 f8 08             	cmp    $0x8,%eax
f0101628:	74 08                	je     f0101632 <readline+0x62>
f010162a:	83 f8 7f             	cmp    $0x7f,%eax
f010162d:	8d 76 00             	lea    0x0(%esi),%esi
f0101630:	75 19                	jne    f010164b <readline+0x7b>
f0101632:	85 f6                	test   %esi,%esi
f0101634:	7e 15                	jle    f010164b <readline+0x7b>
			if (echoing)
f0101636:	85 ff                	test   %edi,%edi
f0101638:	74 0c                	je     f0101646 <readline+0x76>
				cputchar('\b');
f010163a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f0101641:	e8 44 ef ff ff       	call   f010058a <cputchar>
			i--;
f0101646:	83 ee 01             	sub    $0x1,%esi
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0101649:	eb b8                	jmp    f0101603 <readline+0x33>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
f010164b:	83 fb 1f             	cmp    $0x1f,%ebx
f010164e:	66 90                	xchg   %ax,%ax
f0101650:	7e 23                	jle    f0101675 <readline+0xa5>
f0101652:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0101658:	7f 1b                	jg     f0101675 <readline+0xa5>
			if (echoing)
f010165a:	85 ff                	test   %edi,%edi
f010165c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101660:	74 08                	je     f010166a <readline+0x9a>
				cputchar(c);
f0101662:	89 1c 24             	mov    %ebx,(%esp)
f0101665:	e8 20 ef ff ff       	call   f010058a <cputchar>
			buf[i++] = c;
f010166a:	88 9e 60 25 11 f0    	mov    %bl,-0xfeedaa0(%esi)
f0101670:	83 c6 01             	add    $0x1,%esi
f0101673:	eb 8e                	jmp    f0101603 <readline+0x33>
		} else if (c == '\n' || c == '\r') {
f0101675:	83 fb 0a             	cmp    $0xa,%ebx
f0101678:	74 05                	je     f010167f <readline+0xaf>
f010167a:	83 fb 0d             	cmp    $0xd,%ebx
f010167d:	75 84                	jne    f0101603 <readline+0x33>
			if (echoing)
f010167f:	85 ff                	test   %edi,%edi
f0101681:	74 0c                	je     f010168f <readline+0xbf>
				cputchar('\n');
f0101683:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f010168a:	e8 fb ee ff ff       	call   f010058a <cputchar>
			buf[i] = 0;
f010168f:	c6 86 60 25 11 f0 00 	movb   $0x0,-0xfeedaa0(%esi)
f0101696:	b8 60 25 11 f0       	mov    $0xf0112560,%eax
			return buf;
		}
	}
}
f010169b:	83 c4 1c             	add    $0x1c,%esp
f010169e:	5b                   	pop    %ebx
f010169f:	5e                   	pop    %esi
f01016a0:	5f                   	pop    %edi
f01016a1:	5d                   	pop    %ebp
f01016a2:	c3                   	ret    
	...

f01016b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f01016b0:	55                   	push   %ebp
f01016b1:	89 e5                	mov    %esp,%ebp
f01016b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f01016b6:	b8 00 00 00 00       	mov    $0x0,%eax
f01016bb:	80 3a 00             	cmpb   $0x0,(%edx)
f01016be:	74 09                	je     f01016c9 <strlen+0x19>
		n++;
f01016c0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f01016c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f01016c7:	75 f7                	jne    f01016c0 <strlen+0x10>
		n++;
	return n;
}
f01016c9:	5d                   	pop    %ebp
f01016ca:	c3                   	ret    

f01016cb <strnlen>:

int
strnlen(const char *s, size_t size)
{
f01016cb:	55                   	push   %ebp
f01016cc:	89 e5                	mov    %esp,%ebp
f01016ce:	53                   	push   %ebx
f01016cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01016d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01016d5:	85 c9                	test   %ecx,%ecx
f01016d7:	74 19                	je     f01016f2 <strnlen+0x27>
f01016d9:	80 3b 00             	cmpb   $0x0,(%ebx)
f01016dc:	74 14                	je     f01016f2 <strnlen+0x27>
f01016de:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
f01016e3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01016e6:	39 c8                	cmp    %ecx,%eax
f01016e8:	74 0d                	je     f01016f7 <strnlen+0x2c>
f01016ea:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
f01016ee:	75 f3                	jne    f01016e3 <strnlen+0x18>
f01016f0:	eb 05                	jmp    f01016f7 <strnlen+0x2c>
f01016f2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
f01016f7:	5b                   	pop    %ebx
f01016f8:	5d                   	pop    %ebp
f01016f9:	c3                   	ret    

f01016fa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f01016fa:	55                   	push   %ebp
f01016fb:	89 e5                	mov    %esp,%ebp
f01016fd:	53                   	push   %ebx
f01016fe:	8b 45 08             	mov    0x8(%ebp),%eax
f0101701:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101704:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0101709:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f010170d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0101710:	83 c2 01             	add    $0x1,%edx
f0101713:	84 c9                	test   %cl,%cl
f0101715:	75 f2                	jne    f0101709 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0101717:	5b                   	pop    %ebx
f0101718:	5d                   	pop    %ebp
f0101719:	c3                   	ret    

f010171a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f010171a:	55                   	push   %ebp
f010171b:	89 e5                	mov    %esp,%ebp
f010171d:	56                   	push   %esi
f010171e:	53                   	push   %ebx
f010171f:	8b 45 08             	mov    0x8(%ebp),%eax
f0101722:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101725:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0101728:	85 f6                	test   %esi,%esi
f010172a:	74 18                	je     f0101744 <strncpy+0x2a>
f010172c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
f0101731:	0f b6 1a             	movzbl (%edx),%ebx
f0101734:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0101737:	80 3a 01             	cmpb   $0x1,(%edx)
f010173a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f010173d:	83 c1 01             	add    $0x1,%ecx
f0101740:	39 ce                	cmp    %ecx,%esi
f0101742:	77 ed                	ja     f0101731 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f0101744:	5b                   	pop    %ebx
f0101745:	5e                   	pop    %esi
f0101746:	5d                   	pop    %ebp
f0101747:	c3                   	ret    

f0101748 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0101748:	55                   	push   %ebp
f0101749:	89 e5                	mov    %esp,%ebp
f010174b:	56                   	push   %esi
f010174c:	53                   	push   %ebx
f010174d:	8b 75 08             	mov    0x8(%ebp),%esi
f0101750:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101753:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0101756:	89 f0                	mov    %esi,%eax
f0101758:	85 c9                	test   %ecx,%ecx
f010175a:	74 27                	je     f0101783 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
f010175c:	83 e9 01             	sub    $0x1,%ecx
f010175f:	74 1d                	je     f010177e <strlcpy+0x36>
f0101761:	0f b6 1a             	movzbl (%edx),%ebx
f0101764:	84 db                	test   %bl,%bl
f0101766:	74 16                	je     f010177e <strlcpy+0x36>
			*dst++ = *src++;
f0101768:	88 18                	mov    %bl,(%eax)
f010176a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f010176d:	83 e9 01             	sub    $0x1,%ecx
f0101770:	74 0e                	je     f0101780 <strlcpy+0x38>
			*dst++ = *src++;
f0101772:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f0101775:	0f b6 1a             	movzbl (%edx),%ebx
f0101778:	84 db                	test   %bl,%bl
f010177a:	75 ec                	jne    f0101768 <strlcpy+0x20>
f010177c:	eb 02                	jmp    f0101780 <strlcpy+0x38>
f010177e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
f0101780:	c6 00 00             	movb   $0x0,(%eax)
f0101783:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
f0101785:	5b                   	pop    %ebx
f0101786:	5e                   	pop    %esi
f0101787:	5d                   	pop    %ebp
f0101788:	c3                   	ret    

f0101789 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0101789:	55                   	push   %ebp
f010178a:	89 e5                	mov    %esp,%ebp
f010178c:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010178f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0101792:	0f b6 01             	movzbl (%ecx),%eax
f0101795:	84 c0                	test   %al,%al
f0101797:	74 15                	je     f01017ae <strcmp+0x25>
f0101799:	3a 02                	cmp    (%edx),%al
f010179b:	75 11                	jne    f01017ae <strcmp+0x25>
		p++, q++;
f010179d:	83 c1 01             	add    $0x1,%ecx
f01017a0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f01017a3:	0f b6 01             	movzbl (%ecx),%eax
f01017a6:	84 c0                	test   %al,%al
f01017a8:	74 04                	je     f01017ae <strcmp+0x25>
f01017aa:	3a 02                	cmp    (%edx),%al
f01017ac:	74 ef                	je     f010179d <strcmp+0x14>
f01017ae:	0f b6 c0             	movzbl %al,%eax
f01017b1:	0f b6 12             	movzbl (%edx),%edx
f01017b4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
f01017b6:	5d                   	pop    %ebp
f01017b7:	c3                   	ret    

f01017b8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f01017b8:	55                   	push   %ebp
f01017b9:	89 e5                	mov    %esp,%ebp
f01017bb:	53                   	push   %ebx
f01017bc:	8b 55 08             	mov    0x8(%ebp),%edx
f01017bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01017c2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
f01017c5:	85 c0                	test   %eax,%eax
f01017c7:	74 23                	je     f01017ec <strncmp+0x34>
f01017c9:	0f b6 1a             	movzbl (%edx),%ebx
f01017cc:	84 db                	test   %bl,%bl
f01017ce:	74 24                	je     f01017f4 <strncmp+0x3c>
f01017d0:	3a 19                	cmp    (%ecx),%bl
f01017d2:	75 20                	jne    f01017f4 <strncmp+0x3c>
f01017d4:	83 e8 01             	sub    $0x1,%eax
f01017d7:	74 13                	je     f01017ec <strncmp+0x34>
		n--, p++, q++;
f01017d9:	83 c2 01             	add    $0x1,%edx
f01017dc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f01017df:	0f b6 1a             	movzbl (%edx),%ebx
f01017e2:	84 db                	test   %bl,%bl
f01017e4:	74 0e                	je     f01017f4 <strncmp+0x3c>
f01017e6:	3a 19                	cmp    (%ecx),%bl
f01017e8:	74 ea                	je     f01017d4 <strncmp+0x1c>
f01017ea:	eb 08                	jmp    f01017f4 <strncmp+0x3c>
f01017ec:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f01017f1:	5b                   	pop    %ebx
f01017f2:	5d                   	pop    %ebp
f01017f3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f01017f4:	0f b6 02             	movzbl (%edx),%eax
f01017f7:	0f b6 11             	movzbl (%ecx),%edx
f01017fa:	29 d0                	sub    %edx,%eax
f01017fc:	eb f3                	jmp    f01017f1 <strncmp+0x39>

f01017fe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f01017fe:	55                   	push   %ebp
f01017ff:	89 e5                	mov    %esp,%ebp
f0101801:	8b 45 08             	mov    0x8(%ebp),%eax
f0101804:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0101808:	0f b6 10             	movzbl (%eax),%edx
f010180b:	84 d2                	test   %dl,%dl
f010180d:	74 15                	je     f0101824 <strchr+0x26>
		if (*s == c)
f010180f:	38 ca                	cmp    %cl,%dl
f0101811:	75 07                	jne    f010181a <strchr+0x1c>
f0101813:	eb 14                	jmp    f0101829 <strchr+0x2b>
f0101815:	38 ca                	cmp    %cl,%dl
f0101817:	90                   	nop
f0101818:	74 0f                	je     f0101829 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f010181a:	83 c0 01             	add    $0x1,%eax
f010181d:	0f b6 10             	movzbl (%eax),%edx
f0101820:	84 d2                	test   %dl,%dl
f0101822:	75 f1                	jne    f0101815 <strchr+0x17>
f0101824:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
f0101829:	5d                   	pop    %ebp
f010182a:	c3                   	ret    

f010182b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010182b:	55                   	push   %ebp
f010182c:	89 e5                	mov    %esp,%ebp
f010182e:	8b 45 08             	mov    0x8(%ebp),%eax
f0101831:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0101835:	0f b6 10             	movzbl (%eax),%edx
f0101838:	84 d2                	test   %dl,%dl
f010183a:	74 18                	je     f0101854 <strfind+0x29>
		if (*s == c)
f010183c:	38 ca                	cmp    %cl,%dl
f010183e:	75 0a                	jne    f010184a <strfind+0x1f>
f0101840:	eb 12                	jmp    f0101854 <strfind+0x29>
f0101842:	38 ca                	cmp    %cl,%dl
f0101844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101848:	74 0a                	je     f0101854 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f010184a:	83 c0 01             	add    $0x1,%eax
f010184d:	0f b6 10             	movzbl (%eax),%edx
f0101850:	84 d2                	test   %dl,%dl
f0101852:	75 ee                	jne    f0101842 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
f0101854:	5d                   	pop    %ebp
f0101855:	c3                   	ret    

f0101856 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0101856:	55                   	push   %ebp
f0101857:	89 e5                	mov    %esp,%ebp
f0101859:	83 ec 0c             	sub    $0xc,%esp
f010185c:	89 1c 24             	mov    %ebx,(%esp)
f010185f:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101863:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0101867:	8b 7d 08             	mov    0x8(%ebp),%edi
f010186a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010186d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0101870:	85 c9                	test   %ecx,%ecx
f0101872:	74 30                	je     f01018a4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0101874:	f7 c7 03 00 00 00    	test   $0x3,%edi
f010187a:	75 25                	jne    f01018a1 <memset+0x4b>
f010187c:	f6 c1 03             	test   $0x3,%cl
f010187f:	75 20                	jne    f01018a1 <memset+0x4b>
		c &= 0xFF;
f0101881:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0101884:	89 d3                	mov    %edx,%ebx
f0101886:	c1 e3 08             	shl    $0x8,%ebx
f0101889:	89 d6                	mov    %edx,%esi
f010188b:	c1 e6 18             	shl    $0x18,%esi
f010188e:	89 d0                	mov    %edx,%eax
f0101890:	c1 e0 10             	shl    $0x10,%eax
f0101893:	09 f0                	or     %esi,%eax
f0101895:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
f0101897:	09 d8                	or     %ebx,%eax
f0101899:	c1 e9 02             	shr    $0x2,%ecx
f010189c:	fc                   	cld    
f010189d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f010189f:	eb 03                	jmp    f01018a4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01018a1:	fc                   	cld    
f01018a2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01018a4:	89 f8                	mov    %edi,%eax
f01018a6:	8b 1c 24             	mov    (%esp),%ebx
f01018a9:	8b 74 24 04          	mov    0x4(%esp),%esi
f01018ad:	8b 7c 24 08          	mov    0x8(%esp),%edi
f01018b1:	89 ec                	mov    %ebp,%esp
f01018b3:	5d                   	pop    %ebp
f01018b4:	c3                   	ret    

f01018b5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01018b5:	55                   	push   %ebp
f01018b6:	89 e5                	mov    %esp,%ebp
f01018b8:	83 ec 08             	sub    $0x8,%esp
f01018bb:	89 34 24             	mov    %esi,(%esp)
f01018be:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01018c2:	8b 45 08             	mov    0x8(%ebp),%eax
f01018c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
f01018c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
f01018cb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
f01018cd:	39 c6                	cmp    %eax,%esi
f01018cf:	73 35                	jae    f0101906 <memmove+0x51>
f01018d1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01018d4:	39 d0                	cmp    %edx,%eax
f01018d6:	73 2e                	jae    f0101906 <memmove+0x51>
		s += n;
		d += n;
f01018d8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01018da:	f6 c2 03             	test   $0x3,%dl
f01018dd:	75 1b                	jne    f01018fa <memmove+0x45>
f01018df:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01018e5:	75 13                	jne    f01018fa <memmove+0x45>
f01018e7:	f6 c1 03             	test   $0x3,%cl
f01018ea:	75 0e                	jne    f01018fa <memmove+0x45>
			asm volatile("std; rep movsl\n"
f01018ec:	83 ef 04             	sub    $0x4,%edi
f01018ef:	8d 72 fc             	lea    -0x4(%edx),%esi
f01018f2:	c1 e9 02             	shr    $0x2,%ecx
f01018f5:	fd                   	std    
f01018f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01018f8:	eb 09                	jmp    f0101903 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f01018fa:	83 ef 01             	sub    $0x1,%edi
f01018fd:	8d 72 ff             	lea    -0x1(%edx),%esi
f0101900:	fd                   	std    
f0101901:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0101903:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0101904:	eb 20                	jmp    f0101926 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101906:	f7 c6 03 00 00 00    	test   $0x3,%esi
f010190c:	75 15                	jne    f0101923 <memmove+0x6e>
f010190e:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0101914:	75 0d                	jne    f0101923 <memmove+0x6e>
f0101916:	f6 c1 03             	test   $0x3,%cl
f0101919:	75 08                	jne    f0101923 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
f010191b:	c1 e9 02             	shr    $0x2,%ecx
f010191e:	fc                   	cld    
f010191f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101921:	eb 03                	jmp    f0101926 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0101923:	fc                   	cld    
f0101924:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0101926:	8b 34 24             	mov    (%esp),%esi
f0101929:	8b 7c 24 04          	mov    0x4(%esp),%edi
f010192d:	89 ec                	mov    %ebp,%esp
f010192f:	5d                   	pop    %ebp
f0101930:	c3                   	ret    

f0101931 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
f0101931:	55                   	push   %ebp
f0101932:	89 e5                	mov    %esp,%ebp
f0101934:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0101937:	8b 45 10             	mov    0x10(%ebp),%eax
f010193a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010193e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101941:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101945:	8b 45 08             	mov    0x8(%ebp),%eax
f0101948:	89 04 24             	mov    %eax,(%esp)
f010194b:	e8 65 ff ff ff       	call   f01018b5 <memmove>
}
f0101950:	c9                   	leave  
f0101951:	c3                   	ret    

f0101952 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0101952:	55                   	push   %ebp
f0101953:	89 e5                	mov    %esp,%ebp
f0101955:	57                   	push   %edi
f0101956:	56                   	push   %esi
f0101957:	53                   	push   %ebx
f0101958:	8b 75 08             	mov    0x8(%ebp),%esi
f010195b:	8b 7d 0c             	mov    0xc(%ebp),%edi
f010195e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0101961:	85 c9                	test   %ecx,%ecx
f0101963:	74 36                	je     f010199b <memcmp+0x49>
		if (*s1 != *s2)
f0101965:	0f b6 06             	movzbl (%esi),%eax
f0101968:	0f b6 1f             	movzbl (%edi),%ebx
f010196b:	38 d8                	cmp    %bl,%al
f010196d:	74 20                	je     f010198f <memcmp+0x3d>
f010196f:	eb 14                	jmp    f0101985 <memcmp+0x33>
f0101971:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
f0101976:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
f010197b:	83 c2 01             	add    $0x1,%edx
f010197e:	83 e9 01             	sub    $0x1,%ecx
f0101981:	38 d8                	cmp    %bl,%al
f0101983:	74 12                	je     f0101997 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
f0101985:	0f b6 c0             	movzbl %al,%eax
f0101988:	0f b6 db             	movzbl %bl,%ebx
f010198b:	29 d8                	sub    %ebx,%eax
f010198d:	eb 11                	jmp    f01019a0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010198f:	83 e9 01             	sub    $0x1,%ecx
f0101992:	ba 00 00 00 00       	mov    $0x0,%edx
f0101997:	85 c9                	test   %ecx,%ecx
f0101999:	75 d6                	jne    f0101971 <memcmp+0x1f>
f010199b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
f01019a0:	5b                   	pop    %ebx
f01019a1:	5e                   	pop    %esi
f01019a2:	5f                   	pop    %edi
f01019a3:	5d                   	pop    %ebp
f01019a4:	c3                   	ret    

f01019a5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01019a5:	55                   	push   %ebp
f01019a6:	89 e5                	mov    %esp,%ebp
f01019a8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
f01019ab:	89 c2                	mov    %eax,%edx
f01019ad:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01019b0:	39 d0                	cmp    %edx,%eax
f01019b2:	73 15                	jae    f01019c9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
f01019b4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
f01019b8:	38 08                	cmp    %cl,(%eax)
f01019ba:	75 06                	jne    f01019c2 <memfind+0x1d>
f01019bc:	eb 0b                	jmp    f01019c9 <memfind+0x24>
f01019be:	38 08                	cmp    %cl,(%eax)
f01019c0:	74 07                	je     f01019c9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f01019c2:	83 c0 01             	add    $0x1,%eax
f01019c5:	39 c2                	cmp    %eax,%edx
f01019c7:	77 f5                	ja     f01019be <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f01019c9:	5d                   	pop    %ebp
f01019ca:	c3                   	ret    

f01019cb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01019cb:	55                   	push   %ebp
f01019cc:	89 e5                	mov    %esp,%ebp
f01019ce:	57                   	push   %edi
f01019cf:	56                   	push   %esi
f01019d0:	53                   	push   %ebx
f01019d1:	83 ec 04             	sub    $0x4,%esp
f01019d4:	8b 55 08             	mov    0x8(%ebp),%edx
f01019d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01019da:	0f b6 02             	movzbl (%edx),%eax
f01019dd:	3c 20                	cmp    $0x20,%al
f01019df:	74 04                	je     f01019e5 <strtol+0x1a>
f01019e1:	3c 09                	cmp    $0x9,%al
f01019e3:	75 0e                	jne    f01019f3 <strtol+0x28>
		s++;
f01019e5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01019e8:	0f b6 02             	movzbl (%edx),%eax
f01019eb:	3c 20                	cmp    $0x20,%al
f01019ed:	74 f6                	je     f01019e5 <strtol+0x1a>
f01019ef:	3c 09                	cmp    $0x9,%al
f01019f1:	74 f2                	je     f01019e5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
f01019f3:	3c 2b                	cmp    $0x2b,%al
f01019f5:	75 0c                	jne    f0101a03 <strtol+0x38>
		s++;
f01019f7:	83 c2 01             	add    $0x1,%edx
f01019fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101a01:	eb 15                	jmp    f0101a18 <strtol+0x4d>
	else if (*s == '-')
f0101a03:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101a0a:	3c 2d                	cmp    $0x2d,%al
f0101a0c:	75 0a                	jne    f0101a18 <strtol+0x4d>
		s++, neg = 1;
f0101a0e:	83 c2 01             	add    $0x1,%edx
f0101a11:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0101a18:	85 db                	test   %ebx,%ebx
f0101a1a:	0f 94 c0             	sete   %al
f0101a1d:	74 05                	je     f0101a24 <strtol+0x59>
f0101a1f:	83 fb 10             	cmp    $0x10,%ebx
f0101a22:	75 18                	jne    f0101a3c <strtol+0x71>
f0101a24:	80 3a 30             	cmpb   $0x30,(%edx)
f0101a27:	75 13                	jne    f0101a3c <strtol+0x71>
f0101a29:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0101a2d:	8d 76 00             	lea    0x0(%esi),%esi
f0101a30:	75 0a                	jne    f0101a3c <strtol+0x71>
		s += 2, base = 16;
f0101a32:	83 c2 02             	add    $0x2,%edx
f0101a35:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0101a3a:	eb 15                	jmp    f0101a51 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0101a3c:	84 c0                	test   %al,%al
f0101a3e:	66 90                	xchg   %ax,%ax
f0101a40:	74 0f                	je     f0101a51 <strtol+0x86>
f0101a42:	bb 0a 00 00 00       	mov    $0xa,%ebx
f0101a47:	80 3a 30             	cmpb   $0x30,(%edx)
f0101a4a:	75 05                	jne    f0101a51 <strtol+0x86>
		s++, base = 8;
f0101a4c:	83 c2 01             	add    $0x1,%edx
f0101a4f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0101a51:	b8 00 00 00 00       	mov    $0x0,%eax
f0101a56:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0101a58:	0f b6 0a             	movzbl (%edx),%ecx
f0101a5b:	89 cf                	mov    %ecx,%edi
f0101a5d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
f0101a60:	80 fb 09             	cmp    $0x9,%bl
f0101a63:	77 08                	ja     f0101a6d <strtol+0xa2>
			dig = *s - '0';
f0101a65:	0f be c9             	movsbl %cl,%ecx
f0101a68:	83 e9 30             	sub    $0x30,%ecx
f0101a6b:	eb 1e                	jmp    f0101a8b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
f0101a6d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
f0101a70:	80 fb 19             	cmp    $0x19,%bl
f0101a73:	77 08                	ja     f0101a7d <strtol+0xb2>
			dig = *s - 'a' + 10;
f0101a75:	0f be c9             	movsbl %cl,%ecx
f0101a78:	83 e9 57             	sub    $0x57,%ecx
f0101a7b:	eb 0e                	jmp    f0101a8b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
f0101a7d:	8d 5f bf             	lea    -0x41(%edi),%ebx
f0101a80:	80 fb 19             	cmp    $0x19,%bl
f0101a83:	77 15                	ja     f0101a9a <strtol+0xcf>
			dig = *s - 'A' + 10;
f0101a85:	0f be c9             	movsbl %cl,%ecx
f0101a88:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f0101a8b:	39 f1                	cmp    %esi,%ecx
f0101a8d:	7d 0b                	jge    f0101a9a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
f0101a8f:	83 c2 01             	add    $0x1,%edx
f0101a92:	0f af c6             	imul   %esi,%eax
f0101a95:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
f0101a98:	eb be                	jmp    f0101a58 <strtol+0x8d>
f0101a9a:	89 c1                	mov    %eax,%ecx

	if (endptr)
f0101a9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0101aa0:	74 05                	je     f0101aa7 <strtol+0xdc>
		*endptr = (char *) s;
f0101aa2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101aa5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
f0101aa7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0101aab:	74 04                	je     f0101ab1 <strtol+0xe6>
f0101aad:	89 c8                	mov    %ecx,%eax
f0101aaf:	f7 d8                	neg    %eax
}
f0101ab1:	83 c4 04             	add    $0x4,%esp
f0101ab4:	5b                   	pop    %ebx
f0101ab5:	5e                   	pop    %esi
f0101ab6:	5f                   	pop    %edi
f0101ab7:	5d                   	pop    %ebp
f0101ab8:	c3                   	ret    
f0101ab9:	00 00                	add    %al,(%eax)
f0101abb:	00 00                	add    %al,(%eax)
f0101abd:	00 00                	add    %al,(%eax)
	...

f0101ac0 <__udivdi3>:
f0101ac0:	55                   	push   %ebp
f0101ac1:	89 e5                	mov    %esp,%ebp
f0101ac3:	57                   	push   %edi
f0101ac4:	56                   	push   %esi
f0101ac5:	83 ec 10             	sub    $0x10,%esp
f0101ac8:	8b 45 14             	mov    0x14(%ebp),%eax
f0101acb:	8b 55 08             	mov    0x8(%ebp),%edx
f0101ace:	8b 75 10             	mov    0x10(%ebp),%esi
f0101ad1:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0101ad4:	85 c0                	test   %eax,%eax
f0101ad6:	89 55 f0             	mov    %edx,-0x10(%ebp)
f0101ad9:	75 35                	jne    f0101b10 <__udivdi3+0x50>
f0101adb:	39 fe                	cmp    %edi,%esi
f0101add:	77 61                	ja     f0101b40 <__udivdi3+0x80>
f0101adf:	85 f6                	test   %esi,%esi
f0101ae1:	75 0b                	jne    f0101aee <__udivdi3+0x2e>
f0101ae3:	b8 01 00 00 00       	mov    $0x1,%eax
f0101ae8:	31 d2                	xor    %edx,%edx
f0101aea:	f7 f6                	div    %esi
f0101aec:	89 c6                	mov    %eax,%esi
f0101aee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0101af1:	31 d2                	xor    %edx,%edx
f0101af3:	89 f8                	mov    %edi,%eax
f0101af5:	f7 f6                	div    %esi
f0101af7:	89 c7                	mov    %eax,%edi
f0101af9:	89 c8                	mov    %ecx,%eax
f0101afb:	f7 f6                	div    %esi
f0101afd:	89 c1                	mov    %eax,%ecx
f0101aff:	89 fa                	mov    %edi,%edx
f0101b01:	89 c8                	mov    %ecx,%eax
f0101b03:	83 c4 10             	add    $0x10,%esp
f0101b06:	5e                   	pop    %esi
f0101b07:	5f                   	pop    %edi
f0101b08:	5d                   	pop    %ebp
f0101b09:	c3                   	ret    
f0101b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101b10:	39 f8                	cmp    %edi,%eax
f0101b12:	77 1c                	ja     f0101b30 <__udivdi3+0x70>
f0101b14:	0f bd d0             	bsr    %eax,%edx
f0101b17:	83 f2 1f             	xor    $0x1f,%edx
f0101b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101b1d:	75 39                	jne    f0101b58 <__udivdi3+0x98>
f0101b1f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0101b22:	0f 86 a0 00 00 00    	jbe    f0101bc8 <__udivdi3+0x108>
f0101b28:	39 f8                	cmp    %edi,%eax
f0101b2a:	0f 82 98 00 00 00    	jb     f0101bc8 <__udivdi3+0x108>
f0101b30:	31 ff                	xor    %edi,%edi
f0101b32:	31 c9                	xor    %ecx,%ecx
f0101b34:	89 c8                	mov    %ecx,%eax
f0101b36:	89 fa                	mov    %edi,%edx
f0101b38:	83 c4 10             	add    $0x10,%esp
f0101b3b:	5e                   	pop    %esi
f0101b3c:	5f                   	pop    %edi
f0101b3d:	5d                   	pop    %ebp
f0101b3e:	c3                   	ret    
f0101b3f:	90                   	nop
f0101b40:	89 d1                	mov    %edx,%ecx
f0101b42:	89 fa                	mov    %edi,%edx
f0101b44:	89 c8                	mov    %ecx,%eax
f0101b46:	31 ff                	xor    %edi,%edi
f0101b48:	f7 f6                	div    %esi
f0101b4a:	89 c1                	mov    %eax,%ecx
f0101b4c:	89 fa                	mov    %edi,%edx
f0101b4e:	89 c8                	mov    %ecx,%eax
f0101b50:	83 c4 10             	add    $0x10,%esp
f0101b53:	5e                   	pop    %esi
f0101b54:	5f                   	pop    %edi
f0101b55:	5d                   	pop    %ebp
f0101b56:	c3                   	ret    
f0101b57:	90                   	nop
f0101b58:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101b5c:	89 f2                	mov    %esi,%edx
f0101b5e:	d3 e0                	shl    %cl,%eax
f0101b60:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0101b63:	b8 20 00 00 00       	mov    $0x20,%eax
f0101b68:	2b 45 f4             	sub    -0xc(%ebp),%eax
f0101b6b:	89 c1                	mov    %eax,%ecx
f0101b6d:	d3 ea                	shr    %cl,%edx
f0101b6f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101b73:	0b 55 ec             	or     -0x14(%ebp),%edx
f0101b76:	d3 e6                	shl    %cl,%esi
f0101b78:	89 c1                	mov    %eax,%ecx
f0101b7a:	89 75 e8             	mov    %esi,-0x18(%ebp)
f0101b7d:	89 fe                	mov    %edi,%esi
f0101b7f:	d3 ee                	shr    %cl,%esi
f0101b81:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101b85:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101b88:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101b8b:	d3 e7                	shl    %cl,%edi
f0101b8d:	89 c1                	mov    %eax,%ecx
f0101b8f:	d3 ea                	shr    %cl,%edx
f0101b91:	09 d7                	or     %edx,%edi
f0101b93:	89 f2                	mov    %esi,%edx
f0101b95:	89 f8                	mov    %edi,%eax
f0101b97:	f7 75 ec             	divl   -0x14(%ebp)
f0101b9a:	89 d6                	mov    %edx,%esi
f0101b9c:	89 c7                	mov    %eax,%edi
f0101b9e:	f7 65 e8             	mull   -0x18(%ebp)
f0101ba1:	39 d6                	cmp    %edx,%esi
f0101ba3:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101ba6:	72 30                	jb     f0101bd8 <__udivdi3+0x118>
f0101ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101bab:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101baf:	d3 e2                	shl    %cl,%edx
f0101bb1:	39 c2                	cmp    %eax,%edx
f0101bb3:	73 05                	jae    f0101bba <__udivdi3+0xfa>
f0101bb5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
f0101bb8:	74 1e                	je     f0101bd8 <__udivdi3+0x118>
f0101bba:	89 f9                	mov    %edi,%ecx
f0101bbc:	31 ff                	xor    %edi,%edi
f0101bbe:	e9 71 ff ff ff       	jmp    f0101b34 <__udivdi3+0x74>
f0101bc3:	90                   	nop
f0101bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101bc8:	31 ff                	xor    %edi,%edi
f0101bca:	b9 01 00 00 00       	mov    $0x1,%ecx
f0101bcf:	e9 60 ff ff ff       	jmp    f0101b34 <__udivdi3+0x74>
f0101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101bd8:	8d 4f ff             	lea    -0x1(%edi),%ecx
f0101bdb:	31 ff                	xor    %edi,%edi
f0101bdd:	89 c8                	mov    %ecx,%eax
f0101bdf:	89 fa                	mov    %edi,%edx
f0101be1:	83 c4 10             	add    $0x10,%esp
f0101be4:	5e                   	pop    %esi
f0101be5:	5f                   	pop    %edi
f0101be6:	5d                   	pop    %ebp
f0101be7:	c3                   	ret    
	...

f0101bf0 <__umoddi3>:
f0101bf0:	55                   	push   %ebp
f0101bf1:	89 e5                	mov    %esp,%ebp
f0101bf3:	57                   	push   %edi
f0101bf4:	56                   	push   %esi
f0101bf5:	83 ec 20             	sub    $0x20,%esp
f0101bf8:	8b 55 14             	mov    0x14(%ebp),%edx
f0101bfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101bfe:	8b 7d 10             	mov    0x10(%ebp),%edi
f0101c01:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101c04:	85 d2                	test   %edx,%edx
f0101c06:	89 c8                	mov    %ecx,%eax
f0101c08:	89 4d f4             	mov    %ecx,-0xc(%ebp)
f0101c0b:	75 13                	jne    f0101c20 <__umoddi3+0x30>
f0101c0d:	39 f7                	cmp    %esi,%edi
f0101c0f:	76 3f                	jbe    f0101c50 <__umoddi3+0x60>
f0101c11:	89 f2                	mov    %esi,%edx
f0101c13:	f7 f7                	div    %edi
f0101c15:	89 d0                	mov    %edx,%eax
f0101c17:	31 d2                	xor    %edx,%edx
f0101c19:	83 c4 20             	add    $0x20,%esp
f0101c1c:	5e                   	pop    %esi
f0101c1d:	5f                   	pop    %edi
f0101c1e:	5d                   	pop    %ebp
f0101c1f:	c3                   	ret    
f0101c20:	39 f2                	cmp    %esi,%edx
f0101c22:	77 4c                	ja     f0101c70 <__umoddi3+0x80>
f0101c24:	0f bd ca             	bsr    %edx,%ecx
f0101c27:	83 f1 1f             	xor    $0x1f,%ecx
f0101c2a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0101c2d:	75 51                	jne    f0101c80 <__umoddi3+0x90>
f0101c2f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
f0101c32:	0f 87 e0 00 00 00    	ja     f0101d18 <__umoddi3+0x128>
f0101c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101c3b:	29 f8                	sub    %edi,%eax
f0101c3d:	19 d6                	sbb    %edx,%esi
f0101c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101c45:	89 f2                	mov    %esi,%edx
f0101c47:	83 c4 20             	add    $0x20,%esp
f0101c4a:	5e                   	pop    %esi
f0101c4b:	5f                   	pop    %edi
f0101c4c:	5d                   	pop    %ebp
f0101c4d:	c3                   	ret    
f0101c4e:	66 90                	xchg   %ax,%ax
f0101c50:	85 ff                	test   %edi,%edi
f0101c52:	75 0b                	jne    f0101c5f <__umoddi3+0x6f>
f0101c54:	b8 01 00 00 00       	mov    $0x1,%eax
f0101c59:	31 d2                	xor    %edx,%edx
f0101c5b:	f7 f7                	div    %edi
f0101c5d:	89 c7                	mov    %eax,%edi
f0101c5f:	89 f0                	mov    %esi,%eax
f0101c61:	31 d2                	xor    %edx,%edx
f0101c63:	f7 f7                	div    %edi
f0101c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101c68:	f7 f7                	div    %edi
f0101c6a:	eb a9                	jmp    f0101c15 <__umoddi3+0x25>
f0101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101c70:	89 c8                	mov    %ecx,%eax
f0101c72:	89 f2                	mov    %esi,%edx
f0101c74:	83 c4 20             	add    $0x20,%esp
f0101c77:	5e                   	pop    %esi
f0101c78:	5f                   	pop    %edi
f0101c79:	5d                   	pop    %ebp
f0101c7a:	c3                   	ret    
f0101c7b:	90                   	nop
f0101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101c80:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101c84:	d3 e2                	shl    %cl,%edx
f0101c86:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101c89:	ba 20 00 00 00       	mov    $0x20,%edx
f0101c8e:	2b 55 f0             	sub    -0x10(%ebp),%edx
f0101c91:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101c94:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101c98:	89 fa                	mov    %edi,%edx
f0101c9a:	d3 ea                	shr    %cl,%edx
f0101c9c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101ca0:	0b 55 f4             	or     -0xc(%ebp),%edx
f0101ca3:	d3 e7                	shl    %cl,%edi
f0101ca5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101ca9:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101cac:	89 f2                	mov    %esi,%edx
f0101cae:	89 7d e8             	mov    %edi,-0x18(%ebp)
f0101cb1:	89 c7                	mov    %eax,%edi
f0101cb3:	d3 ea                	shr    %cl,%edx
f0101cb5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101cb9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101cbc:	89 c2                	mov    %eax,%edx
f0101cbe:	d3 e6                	shl    %cl,%esi
f0101cc0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101cc4:	d3 ea                	shr    %cl,%edx
f0101cc6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101cca:	09 d6                	or     %edx,%esi
f0101ccc:	89 f0                	mov    %esi,%eax
f0101cce:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0101cd1:	d3 e7                	shl    %cl,%edi
f0101cd3:	89 f2                	mov    %esi,%edx
f0101cd5:	f7 75 f4             	divl   -0xc(%ebp)
f0101cd8:	89 d6                	mov    %edx,%esi
f0101cda:	f7 65 e8             	mull   -0x18(%ebp)
f0101cdd:	39 d6                	cmp    %edx,%esi
f0101cdf:	72 2b                	jb     f0101d0c <__umoddi3+0x11c>
f0101ce1:	39 c7                	cmp    %eax,%edi
f0101ce3:	72 23                	jb     f0101d08 <__umoddi3+0x118>
f0101ce5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101ce9:	29 c7                	sub    %eax,%edi
f0101ceb:	19 d6                	sbb    %edx,%esi
f0101ced:	89 f0                	mov    %esi,%eax
f0101cef:	89 f2                	mov    %esi,%edx
f0101cf1:	d3 ef                	shr    %cl,%edi
f0101cf3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101cf7:	d3 e0                	shl    %cl,%eax
f0101cf9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101cfd:	09 f8                	or     %edi,%eax
f0101cff:	d3 ea                	shr    %cl,%edx
f0101d01:	83 c4 20             	add    $0x20,%esp
f0101d04:	5e                   	pop    %esi
f0101d05:	5f                   	pop    %edi
f0101d06:	5d                   	pop    %ebp
f0101d07:	c3                   	ret    
f0101d08:	39 d6                	cmp    %edx,%esi
f0101d0a:	75 d9                	jne    f0101ce5 <__umoddi3+0xf5>
f0101d0c:	2b 45 e8             	sub    -0x18(%ebp),%eax
f0101d0f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
f0101d12:	eb d1                	jmp    f0101ce5 <__umoddi3+0xf5>
f0101d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101d18:	39 f2                	cmp    %esi,%edx
f0101d1a:	0f 82 18 ff ff ff    	jb     f0101c38 <__umoddi3+0x48>
f0101d20:	e9 1d ff ff ff       	jmp    f0101c42 <__umoddi3+0x52>
