
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
f0100058:	c7 04 24 40 1e 10 f0 	movl   $0xf0101e40,(%esp)
f010005f:	e8 77 0a 00 00       	call   f0100adb <cprintf>
	vcprintf(fmt, ap);
f0100064:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100068:	8b 45 10             	mov    0x10(%ebp),%eax
f010006b:	89 04 24             	mov    %eax,(%esp)
f010006e:	e8 35 0a 00 00       	call   f0100aa8 <vcprintf>
	cprintf("\n");
f0100073:	c7 04 24 65 1f 10 f0 	movl   $0xf0101f65,(%esp)
f010007a:	e8 5c 0a 00 00       	call   f0100adb <cprintf>
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
f01000b2:	c7 04 24 5a 1e 10 f0 	movl   $0xf0101e5a,(%esp)
f01000b9:	e8 1d 0a 00 00       	call   f0100adb <cprintf>
	vcprintf(fmt, ap);
f01000be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01000c2:	89 34 24             	mov    %esi,(%esp)
f01000c5:	e8 de 09 00 00       	call   f0100aa8 <vcprintf>
	cprintf("\n");
f01000ca:	c7 04 24 65 1f 10 f0 	movl   $0xf0101f65,(%esp)
f01000d1:	e8 05 0a 00 00       	call   f0100adb <cprintf>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01000dd:	e8 ce 07 00 00       	call   f01008b0 <monitor>
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
f01000f2:	c7 04 24 72 1e 10 f0 	movl   $0xf0101e72,(%esp)
f01000f9:	e8 dd 09 00 00       	call   f0100adb <cprintf>
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
f0100126:	e8 cc 08 00 00       	call   f01009f7 <mon_backtrace>
	cprintf("leaving test_backtrace %d\n", x);
f010012b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010012f:	c7 04 24 8e 1e 10 f0 	movl   $0xf0101e8e,(%esp)
f0100136:	e8 a0 09 00 00       	call   f0100adb <cprintf>
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
f010019c:	e8 b5 17 00 00       	call   f0101956 <memset>

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
f01001bc:	c7 04 24 f0 1e 10 f0 	movl   $0xf0101ef0,(%esp)
f01001c3:	e8 13 09 00 00       	call   f0100adb <cprintf>
	cprintf("pading space in the right to number 22: %8d.\n", 22);
f01001c8:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
f01001cf:	00 
f01001d0:	c7 04 24 10 1f 10 f0 	movl   $0xf0101f10,(%esp)
f01001d7:	e8 ff 08 00 00       	call   f0100adb <cprintf>
	cprintf("chnum1: %d chnum2: %d\n", chnum1, chnum2);
f01001dc:	0f be 45 f6          	movsbl -0xa(%ebp),%eax
f01001e0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01001e4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
f01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01001ec:	c7 04 24 a9 1e 10 f0 	movl   $0xf0101ea9,(%esp)
f01001f3:	e8 e3 08 00 00       	call   f0100adb <cprintf>
	cprintf("%n", NULL);
f01001f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01001ff:	00 
f0100200:	c7 04 24 c2 1e 10 f0 	movl   $0xf0101ec2,(%esp)
f0100207:	e8 cf 08 00 00       	call   f0100adb <cprintf>
	memset(ntest, 0xd, sizeof(ntest) - 1);
f010020c:	c7 44 24 08 ff 00 00 	movl   $0xff,0x8(%esp)
f0100213:	00 
f0100214:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
f010021b:	00 
f010021c:	8d 9d f6 fe ff ff    	lea    -0x10a(%ebp),%ebx
f0100222:	89 1c 24             	mov    %ebx,(%esp)
f0100225:	e8 2c 17 00 00       	call   f0101956 <memset>
	cprintf("%s%n", ntest, &chnum1); 
f010022a:	89 7c 24 08          	mov    %edi,0x8(%esp)
f010022e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100232:	c7 04 24 c0 1e 10 f0 	movl   $0xf0101ec0,(%esp)
f0100239:	e8 9d 08 00 00       	call   f0100adb <cprintf>
	cprintf("chnum1: %d\n", chnum1);
f010023e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
f0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100246:	c7 04 24 c5 1e 10 f0 	movl   $0xf0101ec5,(%esp)
f010024d:	e8 89 08 00 00       	call   f0100adb <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f0100252:	c7 44 24 08 00 fc ff 	movl   $0xfffffc00,0x8(%esp)
f0100259:	ff 
f010025a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
f0100261:	00 
f0100262:	c7 04 24 d1 1e 10 f0 	movl   $0xf0101ed1,(%esp)
f0100269:	e8 6d 08 00 00       	call   f0100adb <cprintf>


	// Test the stack backtrace function (lab 1 only)
	test_backtrace(5);
f010026e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f0100275:	e8 6a fe ff ff       	call   f01000e4 <test_backtrace>

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
f010027a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100281:	e8 2a 06 00 00       	call   f01008b0 <monitor>
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
f010052a:	e8 86 14 00 00       	call   f01019b5 <memmove>
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
f0100676:	c7 04 24 3e 1f 10 f0 	movl   $0xf0101f3e,(%esp)
f010067d:	e8 59 04 00 00       	call   f0100adb <cprintf>
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
f01006d1:	0f b6 80 80 1f 10 f0 	movzbl -0xfefe080(%eax),%eax
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
f010070c:	0f b6 90 80 1f 10 f0 	movzbl -0xfefe080(%eax),%edx
f0100713:	0b 15 20 33 11 f0    	or     0xf0113320,%edx
f0100719:	0f b6 88 80 20 10 f0 	movzbl -0xfefdf80(%eax),%ecx
f0100720:	31 ca                	xor    %ecx,%edx
f0100722:	89 15 20 33 11 f0    	mov    %edx,0xf0113320

	c = charcode[shift & (CTL | SHIFT)][data];
f0100728:	89 d1                	mov    %edx,%ecx
f010072a:	83 e1 03             	and    $0x3,%ecx
f010072d:	8b 0c 8d 80 21 10 f0 	mov    -0xfefde80(,%ecx,4),%ecx
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
f0100766:	c7 04 24 5b 1f 10 f0 	movl   $0xf0101f5b,(%esp)
f010076d:	e8 69 03 00 00       	call   f0100adb <cprintf>
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

f01007a2 <do_overflow>:
    return pretaddr;
}

void
do_overflow(void)
{
f01007a2:	55                   	push   %ebp
f01007a3:	89 e5                	mov    %esp,%ebp
f01007a5:	83 ec 18             	sub    $0x18,%esp
    cprintf("Overflow success\n");
f01007a8:	c7 04 24 90 21 10 f0 	movl   $0xf0102190,(%esp)
f01007af:	e8 27 03 00 00       	call   f0100adb <cprintf>
}
f01007b4:	c9                   	leave  
f01007b5:	c3                   	ret    

f01007b6 <mon_kerninfo>:
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01007b6:	55                   	push   %ebp
f01007b7:	89 e5                	mov    %esp,%ebp
f01007b9:	83 ec 18             	sub    $0x18,%esp
	extern char entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01007bc:	c7 04 24 a2 21 10 f0 	movl   $0xf01021a2,(%esp)
f01007c3:	e8 13 03 00 00       	call   f0100adb <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01007c8:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f01007cf:	00 
f01007d0:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f01007d7:	f0 
f01007d8:	c7 04 24 50 22 10 f0 	movl   $0xf0102250,(%esp)
f01007df:	e8 f7 02 00 00       	call   f0100adb <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01007e4:	c7 44 24 08 25 1e 10 	movl   $0x101e25,0x8(%esp)
f01007eb:	00 
f01007ec:	c7 44 24 04 25 1e 10 	movl   $0xf0101e25,0x4(%esp)
f01007f3:	f0 
f01007f4:	c7 04 24 74 22 10 f0 	movl   $0xf0102274,(%esp)
f01007fb:	e8 db 02 00 00       	call   f0100adb <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100800:	c7 44 24 08 00 33 11 	movl   $0x113300,0x8(%esp)
f0100807:	00 
f0100808:	c7 44 24 04 00 33 11 	movl   $0xf0113300,0x4(%esp)
f010080f:	f0 
f0100810:	c7 04 24 98 22 10 f0 	movl   $0xf0102298,(%esp)
f0100817:	e8 bf 02 00 00       	call   f0100adb <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010081c:	c7 44 24 08 60 39 11 	movl   $0x113960,0x8(%esp)
f0100823:	00 
f0100824:	c7 44 24 04 60 39 11 	movl   $0xf0113960,0x4(%esp)
f010082b:	f0 
f010082c:	c7 04 24 bc 22 10 f0 	movl   $0xf01022bc,(%esp)
f0100833:	e8 a3 02 00 00       	call   f0100adb <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100838:	b8 5f 3d 11 f0       	mov    $0xf0113d5f,%eax
f010083d:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f0100842:	89 c2                	mov    %eax,%edx
f0100844:	c1 fa 1f             	sar    $0x1f,%edx
f0100847:	c1 ea 16             	shr    $0x16,%edx
f010084a:	8d 04 02             	lea    (%edx,%eax,1),%eax
f010084d:	c1 f8 0a             	sar    $0xa,%eax
f0100850:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100854:	c7 04 24 e0 22 10 f0 	movl   $0xf01022e0,(%esp)
f010085b:	e8 7b 02 00 00       	call   f0100adb <cprintf>
		(end-entry+1023)/1024);
	return 0;
}
f0100860:	b8 00 00 00 00       	mov    $0x0,%eax
f0100865:	c9                   	leave  
f0100866:	c3                   	ret    

f0100867 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100867:	55                   	push   %ebp
f0100868:	89 e5                	mov    %esp,%ebp
f010086a:	83 ec 18             	sub    $0x18,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f010086d:	a1 b8 23 10 f0       	mov    0xf01023b8,%eax
f0100872:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100876:	a1 b4 23 10 f0       	mov    0xf01023b4,%eax
f010087b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010087f:	c7 04 24 bb 21 10 f0 	movl   $0xf01021bb,(%esp)
f0100886:	e8 50 02 00 00       	call   f0100adb <cprintf>
f010088b:	a1 c4 23 10 f0       	mov    0xf01023c4,%eax
f0100890:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100894:	a1 c0 23 10 f0       	mov    0xf01023c0,%eax
f0100899:	89 44 24 04          	mov    %eax,0x4(%esp)
f010089d:	c7 04 24 bb 21 10 f0 	movl   $0xf01021bb,(%esp)
f01008a4:	e8 32 02 00 00       	call   f0100adb <cprintf>
	return 0;
}
f01008a9:	b8 00 00 00 00       	mov    $0x0,%eax
f01008ae:	c9                   	leave  
f01008af:	c3                   	ret    

f01008b0 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f01008b0:	55                   	push   %ebp
f01008b1:	89 e5                	mov    %esp,%ebp
f01008b3:	57                   	push   %edi
f01008b4:	56                   	push   %esi
f01008b5:	53                   	push   %ebx
f01008b6:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f01008b9:	c7 04 24 0c 23 10 f0 	movl   $0xf010230c,(%esp)
f01008c0:	e8 16 02 00 00       	call   f0100adb <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f01008c5:	c7 04 24 30 23 10 f0 	movl   $0xf0102330,(%esp)
f01008cc:	e8 0a 02 00 00       	call   f0100adb <cprintf>

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f01008d1:	bf b4 23 10 f0       	mov    $0xf01023b4,%edi
	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");


	while (1) {
		buf = readline("K> ");
f01008d6:	c7 04 24 c4 21 10 f0 	movl   $0xf01021c4,(%esp)
f01008dd:	e8 ee 0d 00 00       	call   f01016d0 <readline>
f01008e2:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f01008e4:	85 c0                	test   %eax,%eax
f01008e6:	74 ee                	je     f01008d6 <monitor+0x26>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f01008e8:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
f01008ef:	be 00 00 00 00       	mov    $0x0,%esi
f01008f4:	eb 06                	jmp    f01008fc <monitor+0x4c>
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f01008f6:	c6 03 00             	movb   $0x0,(%ebx)
f01008f9:	83 c3 01             	add    $0x1,%ebx
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f01008fc:	0f b6 03             	movzbl (%ebx),%eax
f01008ff:	84 c0                	test   %al,%al
f0100901:	74 6a                	je     f010096d <monitor+0xbd>
f0100903:	0f be c0             	movsbl %al,%eax
f0100906:	89 44 24 04          	mov    %eax,0x4(%esp)
f010090a:	c7 04 24 c8 21 10 f0 	movl   $0xf01021c8,(%esp)
f0100911:	e8 e8 0f 00 00       	call   f01018fe <strchr>
f0100916:	85 c0                	test   %eax,%eax
f0100918:	75 dc                	jne    f01008f6 <monitor+0x46>
			*buf++ = 0;
		if (*buf == 0)
f010091a:	80 3b 00             	cmpb   $0x0,(%ebx)
f010091d:	74 4e                	je     f010096d <monitor+0xbd>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f010091f:	83 fe 0f             	cmp    $0xf,%esi
f0100922:	75 16                	jne    f010093a <monitor+0x8a>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100924:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f010092b:	00 
f010092c:	c7 04 24 cd 21 10 f0 	movl   $0xf01021cd,(%esp)
f0100933:	e8 a3 01 00 00       	call   f0100adb <cprintf>
f0100938:	eb 9c                	jmp    f01008d6 <monitor+0x26>
			return 0;
		}
		argv[argc++] = buf;
f010093a:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f010093e:	83 c6 01             	add    $0x1,%esi
		while (*buf && !strchr(WHITESPACE, *buf))
f0100941:	0f b6 03             	movzbl (%ebx),%eax
f0100944:	84 c0                	test   %al,%al
f0100946:	75 0c                	jne    f0100954 <monitor+0xa4>
f0100948:	eb b2                	jmp    f01008fc <monitor+0x4c>
			buf++;
f010094a:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f010094d:	0f b6 03             	movzbl (%ebx),%eax
f0100950:	84 c0                	test   %al,%al
f0100952:	74 a8                	je     f01008fc <monitor+0x4c>
f0100954:	0f be c0             	movsbl %al,%eax
f0100957:	89 44 24 04          	mov    %eax,0x4(%esp)
f010095b:	c7 04 24 c8 21 10 f0 	movl   $0xf01021c8,(%esp)
f0100962:	e8 97 0f 00 00       	call   f01018fe <strchr>
f0100967:	85 c0                	test   %eax,%eax
f0100969:	74 df                	je     f010094a <monitor+0x9a>
f010096b:	eb 8f                	jmp    f01008fc <monitor+0x4c>
			buf++;
	}
	argv[argc] = 0;
f010096d:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100974:	00 

	// Lookup and invoke the command
	if (argc == 0)
f0100975:	85 f6                	test   %esi,%esi
f0100977:	0f 84 59 ff ff ff    	je     f01008d6 <monitor+0x26>
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f010097d:	8b 07                	mov    (%edi),%eax
f010097f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100983:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100986:	89 04 24             	mov    %eax,(%esp)
f0100989:	e8 fb 0e 00 00       	call   f0101889 <strcmp>
f010098e:	ba 00 00 00 00       	mov    $0x0,%edx
f0100993:	85 c0                	test   %eax,%eax
f0100995:	74 1d                	je     f01009b4 <monitor+0x104>
f0100997:	a1 c0 23 10 f0       	mov    0xf01023c0,%eax
f010099c:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009a0:	8b 45 a8             	mov    -0x58(%ebp),%eax
f01009a3:	89 04 24             	mov    %eax,(%esp)
f01009a6:	e8 de 0e 00 00       	call   f0101889 <strcmp>
f01009ab:	85 c0                	test   %eax,%eax
f01009ad:	75 28                	jne    f01009d7 <monitor+0x127>
f01009af:	ba 01 00 00 00       	mov    $0x1,%edx
			return commands[i].func(argc, argv, tf);
f01009b4:	6b d2 0c             	imul   $0xc,%edx,%edx
f01009b7:	8b 45 08             	mov    0x8(%ebp),%eax
f01009ba:	89 44 24 08          	mov    %eax,0x8(%esp)
f01009be:	8d 45 a8             	lea    -0x58(%ebp),%eax
f01009c1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009c5:	89 34 24             	mov    %esi,(%esp)
f01009c8:	ff 92 bc 23 10 f0    	call   *-0xfefdc44(%edx)


	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f01009ce:	85 c0                	test   %eax,%eax
f01009d0:	78 1d                	js     f01009ef <monitor+0x13f>
f01009d2:	e9 ff fe ff ff       	jmp    f01008d6 <monitor+0x26>
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f01009d7:	8b 45 a8             	mov    -0x58(%ebp),%eax
f01009da:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009de:	c7 04 24 ea 21 10 f0 	movl   $0xf01021ea,(%esp)
f01009e5:	e8 f1 00 00 00       	call   f0100adb <cprintf>
f01009ea:	e9 e7 fe ff ff       	jmp    f01008d6 <monitor+0x26>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f01009ef:	83 c4 5c             	add    $0x5c,%esp
f01009f2:	5b                   	pop    %ebx
f01009f3:	5e                   	pop    %esi
f01009f4:	5f                   	pop    %edi
f01009f5:	5d                   	pop    %ebp
f01009f6:	c3                   	ret    

f01009f7 <mon_backtrace>:
        start_overflow();
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01009f7:	55                   	push   %ebp
f01009f8:	89 e5                	mov    %esp,%ebp
f01009fa:	57                   	push   %edi
f01009fb:	56                   	push   %esi
f01009fc:	53                   	push   %ebx
f01009fd:	83 ec 4c             	sub    $0x4c,%esp
    struct Eipdebuginfo debuginfo;
    struct Eipdebuginfo *info = &debuginfo;

    uint32_t *pebp;
    int i;
    pebp = (uint32_t*)read_ebp();
f0100a00:	89 eb                	mov    %ebp,%ebx
f0100a02:	bf 00 00 00 00       	mov    $0x0,%edi
    //cprintf("pebp:%p %p\n",pebp, pebp+1);
    for(i = 0; i < 7; i++){
    	cprintf("eip %08x  ebp %p  args %08x %08x %08x %08x %08x\n",*(pebp+1), pebp, *(pebp+2), *(pebp+3), *(pebp+4), *(pebp+5), *(pebp+6));
f0100a07:	8d 73 04             	lea    0x4(%ebx),%esi
f0100a0a:	8b 43 18             	mov    0x18(%ebx),%eax
f0100a0d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f0100a11:	8b 43 14             	mov    0x14(%ebx),%eax
f0100a14:	89 44 24 18          	mov    %eax,0x18(%esp)
f0100a18:	8b 43 10             	mov    0x10(%ebx),%eax
f0100a1b:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100a1f:	8b 43 0c             	mov    0xc(%ebx),%eax
f0100a22:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100a26:	8b 43 08             	mov    0x8(%ebx),%eax
f0100a29:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100a2d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0100a31:	8b 06                	mov    (%esi),%eax
f0100a33:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a37:	c7 04 24 58 23 10 f0 	movl   $0xf0102358,(%esp)
f0100a3e:	e8 98 00 00 00       	call   f0100adb <cprintf>
    	debuginfo_eip(*(pebp+1),info);
f0100a43:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0100a46:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a4a:	8b 06                	mov    (%esi),%eax
f0100a4c:	89 04 24             	mov    %eax,(%esp)
f0100a4f:	e8 fa 01 00 00       	call   f0100c4e <debuginfo_eip>
	cprintf("	%s:%d: %s+%d\n",info->eip_file, info->eip_line, info->eip_fn_name, *(pebp+1)-info->eip_fn_addr);
f0100a54:	8b 06                	mov    (%esi),%eax
f0100a56:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100a59:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100a5d:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100a60:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100a64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100a67:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100a6b:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0100a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a72:	c7 04 24 00 22 10 f0 	movl   $0xf0102200,(%esp)
f0100a79:	e8 5d 00 00 00       	call   f0100adb <cprintf>
	pebp = (uint32_t*)*(pebp);
f0100a7e:	8b 1b                	mov    (%ebx),%ebx

    uint32_t *pebp;
    int i;
    pebp = (uint32_t*)read_ebp();
    //cprintf("pebp:%p %p\n",pebp, pebp+1);
    for(i = 0; i < 7; i++){
f0100a80:	83 c7 01             	add    $0x1,%edi
f0100a83:	83 ff 07             	cmp    $0x7,%edi
f0100a86:	0f 85 7b ff ff ff    	jne    f0100a07 <mon_backtrace+0x10>
    	debuginfo_eip(*(pebp+1),info);
	cprintf("	%s:%d: %s+%d\n",info->eip_file, info->eip_line, info->eip_fn_name, *(pebp+1)-info->eip_fn_addr);
	pebp = (uint32_t*)*(pebp);
    }
    overflow_me();
    cprintf("Backtrace success\n");
f0100a8c:	c7 04 24 0f 22 10 f0 	movl   $0xf010220f,(%esp)
f0100a93:	e8 43 00 00 00       	call   f0100adb <cprintf>
	return 0;
}
f0100a98:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a9d:	83 c4 4c             	add    $0x4c,%esp
f0100aa0:	5b                   	pop    %ebx
f0100aa1:	5e                   	pop    %esi
f0100aa2:	5f                   	pop    %edi
f0100aa3:	5d                   	pop    %ebp
f0100aa4:	c3                   	ret    
f0100aa5:	00 00                	add    %al,(%eax)
	...

f0100aa8 <vcprintf>:
    (*cnt)++;
}

int
vcprintf(const char *fmt, va_list ap)
{
f0100aa8:	55                   	push   %ebp
f0100aa9:	89 e5                	mov    %esp,%ebp
f0100aab:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f0100aae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);// ap:store the argument inputed by user.
f0100ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100ab8:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100abc:	8b 45 08             	mov    0x8(%ebp),%eax
f0100abf:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100ac3:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100ac6:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100aca:	c7 04 24 f5 0a 10 f0 	movl   $0xf0100af5,(%esp)
f0100ad1:	e8 c1 06 00 00       	call   f0101197 <vprintfmt>
	return cnt;
}
f0100ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100ad9:	c9                   	leave  
f0100ada:	c3                   	ret    

f0100adb <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0100adb:	55                   	push   %ebp
f0100adc:	89 e5                	mov    %esp,%ebp
f0100ade:	83 ec 18             	sub    $0x18,%esp
	vprintfmt((void*)putch, &cnt, fmt, ap);// ap:store the argument inputed by user.
	return cnt;
}

int
cprintf(const char *fmt, ...)
f0100ae1:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
f0100ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ae8:	8b 45 08             	mov    0x8(%ebp),%eax
f0100aeb:	89 04 24             	mov    %eax,(%esp)
f0100aee:	e8 b5 ff ff ff       	call   f0100aa8 <vcprintf>
	
	va_end(ap);
	return cnt;
}
f0100af3:	c9                   	leave  
f0100af4:	c3                   	ret    

f0100af5 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0100af5:	55                   	push   %ebp
f0100af6:	89 e5                	mov    %esp,%ebp
f0100af8:	53                   	push   %ebx
f0100af9:	83 ec 14             	sub    $0x14,%esp
f0100afc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f0100aff:	8b 45 08             	mov    0x8(%ebp),%eax
f0100b02:	89 04 24             	mov    %eax,(%esp)
f0100b05:	e8 80 fa ff ff       	call   f010058a <cputchar>
    (*cnt)++;
f0100b0a:	83 03 01             	addl   $0x1,(%ebx)
}
f0100b0d:	83 c4 14             	add    $0x14,%esp
f0100b10:	5b                   	pop    %ebx
f0100b11:	5d                   	pop    %ebp
f0100b12:	c3                   	ret    
	...

f0100b20 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0100b20:	55                   	push   %ebp
f0100b21:	89 e5                	mov    %esp,%ebp
f0100b23:	57                   	push   %edi
f0100b24:	56                   	push   %esi
f0100b25:	53                   	push   %ebx
f0100b26:	83 ec 14             	sub    $0x14,%esp
f0100b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100b2c:	89 55 e8             	mov    %edx,-0x18(%ebp)
f0100b2f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0100b32:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0100b35:	8b 1a                	mov    (%edx),%ebx
f0100b37:	8b 01                	mov    (%ecx),%eax
f0100b39:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	while (l <= r) {
f0100b3c:	39 c3                	cmp    %eax,%ebx
f0100b3e:	0f 8f 9c 00 00 00    	jg     f0100be0 <stab_binsearch+0xc0>
f0100b44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		int true_m = (l + r) / 2, m = true_m;
f0100b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0100b4e:	01 d8                	add    %ebx,%eax
f0100b50:	89 c7                	mov    %eax,%edi
f0100b52:	c1 ef 1f             	shr    $0x1f,%edi
f0100b55:	01 c7                	add    %eax,%edi
f0100b57:	d1 ff                	sar    %edi
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0100b59:	39 df                	cmp    %ebx,%edi
f0100b5b:	7c 33                	jl     f0100b90 <stab_binsearch+0x70>
f0100b5d:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100b60:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0100b63:	0f b6 44 82 04       	movzbl 0x4(%edx,%eax,4),%eax
f0100b68:	39 f0                	cmp    %esi,%eax
f0100b6a:	0f 84 bc 00 00 00    	je     f0100c2c <stab_binsearch+0x10c>
f0100b70:	8d 44 7f fd          	lea    -0x3(%edi,%edi,2),%eax
f0100b74:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx
f0100b78:	89 f8                	mov    %edi,%eax
			m--;
f0100b7a:	83 e8 01             	sub    $0x1,%eax
	
	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0100b7d:	39 d8                	cmp    %ebx,%eax
f0100b7f:	7c 0f                	jl     f0100b90 <stab_binsearch+0x70>
f0100b81:	0f b6 0a             	movzbl (%edx),%ecx
f0100b84:	83 ea 0c             	sub    $0xc,%edx
f0100b87:	39 f1                	cmp    %esi,%ecx
f0100b89:	75 ef                	jne    f0100b7a <stab_binsearch+0x5a>
f0100b8b:	e9 9e 00 00 00       	jmp    f0100c2e <stab_binsearch+0x10e>
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0100b90:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0100b93:	eb 3c                	jmp    f0100bd1 <stab_binsearch+0xb1>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
f0100b95:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0100b98:	89 01                	mov    %eax,(%ecx)
			l = true_m + 1;
f0100b9a:	8d 5f 01             	lea    0x1(%edi),%ebx
f0100b9d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0100ba4:	eb 2b                	jmp    f0100bd1 <stab_binsearch+0xb1>
		} else if (stabs[m].n_value > addr) {
f0100ba6:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100ba9:	76 14                	jbe    f0100bbf <stab_binsearch+0x9f>
			*region_right = m - 1;
f0100bab:	83 e8 01             	sub    $0x1,%eax
f0100bae:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0100bb1:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0100bb4:	89 02                	mov    %eax,(%edx)
f0100bb6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0100bbd:	eb 12                	jmp    f0100bd1 <stab_binsearch+0xb1>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0100bbf:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0100bc2:	89 01                	mov    %eax,(%ecx)
			l = m;
			addr++;
f0100bc4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0100bc8:	89 c3                	mov    %eax,%ebx
f0100bca:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;
	
	while (l <= r) {
f0100bd1:	39 5d ec             	cmp    %ebx,-0x14(%ebp)
f0100bd4:	0f 8d 71 ff ff ff    	jge    f0100b4b <stab_binsearch+0x2b>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f0100bda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0100bde:	75 0f                	jne    f0100bef <stab_binsearch+0xcf>
		*region_right = *region_left - 1;
f0100be0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0100be3:	8b 03                	mov    (%ebx),%eax
f0100be5:	83 e8 01             	sub    $0x1,%eax
f0100be8:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0100beb:	89 02                	mov    %eax,(%edx)
f0100bed:	eb 57                	jmp    f0100c46 <stab_binsearch+0x126>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100bef:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0100bf2:	8b 01                	mov    (%ecx),%eax
		     l > *region_left && stabs[l].n_type != type;
f0100bf4:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0100bf7:	8b 0b                	mov    (%ebx),%ecx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100bf9:	39 c1                	cmp    %eax,%ecx
f0100bfb:	7d 28                	jge    f0100c25 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f0100bfd:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100c00:	8b 5d f0             	mov    -0x10(%ebp),%ebx
f0100c03:	0f b6 54 93 04       	movzbl 0x4(%ebx,%edx,4),%edx
f0100c08:	39 f2                	cmp    %esi,%edx
f0100c0a:	74 19                	je     f0100c25 <stab_binsearch+0x105>
f0100c0c:	8d 54 40 fd          	lea    -0x3(%eax,%eax,2),%edx
f0100c10:	8d 54 93 04          	lea    0x4(%ebx,%edx,4),%edx
		     l--)
f0100c14:	83 e8 01             	sub    $0x1,%eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100c17:	39 c1                	cmp    %eax,%ecx
f0100c19:	7d 0a                	jge    f0100c25 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f0100c1b:	0f b6 1a             	movzbl (%edx),%ebx
f0100c1e:	83 ea 0c             	sub    $0xc,%edx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100c21:	39 f3                	cmp    %esi,%ebx
f0100c23:	75 ef                	jne    f0100c14 <stab_binsearch+0xf4>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
f0100c25:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0100c28:	89 02                	mov    %eax,(%edx)
f0100c2a:	eb 1a                	jmp    f0100c46 <stab_binsearch+0x126>
	}
}
f0100c2c:	89 f8                	mov    %edi,%eax
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0100c2e:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100c31:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0100c34:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0100c38:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100c3b:	0f 82 54 ff ff ff    	jb     f0100b95 <stab_binsearch+0x75>
f0100c41:	e9 60 ff ff ff       	jmp    f0100ba6 <stab_binsearch+0x86>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0100c46:	83 c4 14             	add    $0x14,%esp
f0100c49:	5b                   	pop    %ebx
f0100c4a:	5e                   	pop    %esi
f0100c4b:	5f                   	pop    %edi
f0100c4c:	5d                   	pop    %ebp
f0100c4d:	c3                   	ret    

f0100c4e <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0100c4e:	55                   	push   %ebp
f0100c4f:	89 e5                	mov    %esp,%ebp
f0100c51:	83 ec 48             	sub    $0x48,%esp
f0100c54:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0100c57:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0100c5a:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0100c5d:	8b 75 08             	mov    0x8(%ebp),%esi
f0100c60:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0100c63:	c7 03 cc 23 10 f0    	movl   $0xf01023cc,(%ebx)
	info->eip_line = 0;
f0100c69:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0100c70:	c7 43 08 cc 23 10 f0 	movl   $0xf01023cc,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0100c77:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0100c7e:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0100c81:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0100c88:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0100c8e:	76 12                	jbe    f0100ca2 <debuginfo_eip+0x54>
		// Can't search for user-level addresses yet!
  	        panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100c90:	b8 d1 81 10 f0       	mov    $0xf01081d1,%eax
f0100c95:	3d 59 66 10 f0       	cmp    $0xf0106659,%eax
f0100c9a:	0f 86 b2 01 00 00    	jbe    f0100e52 <debuginfo_eip+0x204>
f0100ca0:	eb 1c                	jmp    f0100cbe <debuginfo_eip+0x70>
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
	} else {
		// Can't search for user-level addresses yet!
  	        panic("User address");
f0100ca2:	c7 44 24 08 d6 23 10 	movl   $0xf01023d6,0x8(%esp)
f0100ca9:	f0 
f0100caa:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
f0100cb1:	00 
f0100cb2:	c7 04 24 e3 23 10 f0 	movl   $0xf01023e3,(%esp)
f0100cb9:	e8 c7 f3 ff ff       	call   f0100085 <_panic>
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100cbe:	80 3d d0 81 10 f0 00 	cmpb   $0x0,0xf01081d0
f0100cc5:	0f 85 87 01 00 00    	jne    f0100e52 <debuginfo_eip+0x204>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.
	
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0100ccb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0100cd2:	b8 58 66 10 f0       	mov    $0xf0106658,%eax
f0100cd7:	2d 80 26 10 f0       	sub    $0xf0102680,%eax
f0100cdc:	c1 f8 02             	sar    $0x2,%eax
f0100cdf:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0100ce5:	83 e8 01             	sub    $0x1,%eax
f0100ce8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0100ceb:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0100cee:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0100cf1:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100cf5:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0100cfc:	b8 80 26 10 f0       	mov    $0xf0102680,%eax
f0100d01:	e8 1a fe ff ff       	call   f0100b20 <stab_binsearch>
	if (lfile == 0)
f0100d06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100d09:	85 c0                	test   %eax,%eax
f0100d0b:	0f 84 41 01 00 00    	je     f0100e52 <debuginfo_eip+0x204>
		return -1;
	
	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0100d11:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0100d14:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100d17:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0100d1a:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0100d1d:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100d20:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100d24:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0100d2b:	b8 80 26 10 f0       	mov    $0xf0102680,%eax
f0100d30:	e8 eb fd ff ff       	call   f0100b20 <stab_binsearch>

	if (lfun <= rfun) {
f0100d35:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100d38:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0100d3b:	7f 3c                	jg     f0100d79 <debuginfo_eip+0x12b>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0100d3d:	6b c0 0c             	imul   $0xc,%eax,%eax
f0100d40:	8b 80 80 26 10 f0    	mov    -0xfefd980(%eax),%eax
f0100d46:	ba d1 81 10 f0       	mov    $0xf01081d1,%edx
f0100d4b:	81 ea 59 66 10 f0    	sub    $0xf0106659,%edx
f0100d51:	39 d0                	cmp    %edx,%eax
f0100d53:	73 08                	jae    f0100d5d <debuginfo_eip+0x10f>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0100d55:	05 59 66 10 f0       	add    $0xf0106659,%eax
f0100d5a:	89 43 08             	mov    %eax,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0100d5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100d60:	6b d0 0c             	imul   $0xc,%eax,%edx
f0100d63:	8b 92 88 26 10 f0    	mov    -0xfefd978(%edx),%edx
f0100d69:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0100d6c:	29 d6                	sub    %edx,%esi
		// Search within the function definition for the line number.
		lline = lfun;
f0100d6e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0100d71:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100d74:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100d77:	eb 0f                	jmp    f0100d88 <debuginfo_eip+0x13a>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f0100d79:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f0100d7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100d7f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0100d82:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100d85:	89 45 d0             	mov    %eax,-0x30(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0100d88:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f0100d8f:	00 
f0100d90:	8b 43 08             	mov    0x8(%ebx),%eax
f0100d93:	89 04 24             	mov    %eax,(%esp)
f0100d96:	e8 90 0b 00 00       	call   f010192b <strfind>
f0100d9b:	2b 43 08             	sub    0x8(%ebx),%eax
f0100d9e:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);//N_SLINE:line number in text segment
f0100da1:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0100da4:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0100da7:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100dab:	c7 04 24 44 00 00 00 	movl   $0x44,(%esp)
f0100db2:	b8 80 26 10 f0       	mov    $0xf0102680,%eax
f0100db7:	e8 64 fd ff ff       	call   f0100b20 <stab_binsearch>
	if(lline > rline)return -1;
f0100dbc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100dbf:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f0100dc2:	0f 8f 8a 00 00 00    	jg     f0100e52 <debuginfo_eip+0x204>
	info->eip_line = stabs[lline].n_desc;//line number
f0100dc8:	ba 80 26 10 f0       	mov    $0xf0102680,%edx
f0100dcd:	6b c0 0c             	imul   $0xc,%eax,%eax
f0100dd0:	0f b7 44 10 06       	movzwl 0x6(%eax,%edx,1),%eax
f0100dd5:	89 43 04             	mov    %eax,0x4(%ebx)
	info->eip_file = stabs[lfile].n_strx + stabstr;
f0100dd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100ddb:	6b c8 0c             	imul   $0xc,%eax,%ecx
f0100dde:	8b 14 11             	mov    (%ecx,%edx,1),%edx
f0100de1:	81 c2 59 66 10 f0    	add    $0xf0106659,%edx
f0100de7:	89 13                	mov    %edx,(%ebx)
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
f0100de9:	89 c7                	mov    %eax,%edi
f0100deb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100dee:	6b d0 0c             	imul   $0xc,%eax,%edx
f0100df1:	81 c2 88 26 10 f0    	add    $0xf0102688,%edx
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100df7:	eb 06                	jmp    f0100dff <debuginfo_eip+0x1b1>
f0100df9:	83 e8 01             	sub    $0x1,%eax
f0100dfc:	83 ea 0c             	sub    $0xc,%edx
f0100dff:	89 c6                	mov    %eax,%esi
f0100e01:	39 f8                	cmp    %edi,%eax
f0100e03:	7c 1c                	jl     f0100e21 <debuginfo_eip+0x1d3>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0100e05:	0f b6 4a fc          	movzbl -0x4(%edx),%ecx
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100e09:	80 f9 84             	cmp    $0x84,%cl
f0100e0c:	74 5d                	je     f0100e6b <debuginfo_eip+0x21d>
f0100e0e:	80 f9 64             	cmp    $0x64,%cl
f0100e11:	75 e6                	jne    f0100df9 <debuginfo_eip+0x1ab>
f0100e13:	83 3a 00             	cmpl   $0x0,(%edx)
f0100e16:	74 e1                	je     f0100df9 <debuginfo_eip+0x1ab>
f0100e18:	eb 51                	jmp    f0100e6b <debuginfo_eip+0x21d>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
		info->eip_file = stabstr + stabs[lline].n_strx;
f0100e1a:	05 59 66 10 f0       	add    $0xf0106659,%eax
f0100e1f:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0100e21:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100e24:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0100e27:	7d 30                	jge    f0100e59 <debuginfo_eip+0x20b>
		for (lline = lfun + 1;
f0100e29:	83 c0 01             	add    $0x1,%eax
f0100e2c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100e2f:	ba 80 26 10 f0       	mov    $0xf0102680,%edx


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0100e34:	eb 08                	jmp    f0100e3e <debuginfo_eip+0x1f0>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f0100e36:	83 43 14 01          	addl   $0x1,0x14(%ebx)
	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
f0100e3a:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100e3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0100e41:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0100e44:	7d 13                	jge    f0100e59 <debuginfo_eip+0x20b>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100e46:	6b c0 0c             	imul   $0xc,%eax,%eax
f0100e49:	80 7c 10 04 a0       	cmpb   $0xa0,0x4(%eax,%edx,1)
f0100e4e:	74 e6                	je     f0100e36 <debuginfo_eip+0x1e8>
f0100e50:	eb 07                	jmp    f0100e59 <debuginfo_eip+0x20b>
f0100e52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100e57:	eb 05                	jmp    f0100e5e <debuginfo_eip+0x210>
f0100e59:	b8 00 00 00 00       	mov    $0x0,%eax
		     lline++)
			info->eip_fn_narg++;
	
	return 0;
}
f0100e5e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0100e61:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0100e64:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0100e67:	89 ec                	mov    %ebp,%esp
f0100e69:	5d                   	pop    %ebp
f0100e6a:	c3                   	ret    
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0100e6b:	6b c6 0c             	imul   $0xc,%esi,%eax
f0100e6e:	8b 80 80 26 10 f0    	mov    -0xfefd980(%eax),%eax
f0100e74:	ba d1 81 10 f0       	mov    $0xf01081d1,%edx
f0100e79:	81 ea 59 66 10 f0    	sub    $0xf0106659,%edx
f0100e7f:	39 d0                	cmp    %edx,%eax
f0100e81:	72 97                	jb     f0100e1a <debuginfo_eip+0x1cc>
f0100e83:	eb 9c                	jmp    f0100e21 <debuginfo_eip+0x1d3>
	...

f0100e90 <printnum_width>:
};
//left justified 
static void
printnum_width(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc,int *pamnt,int *pcount)
{
f0100e90:	55                   	push   %ebp
f0100e91:	89 e5                	mov    %esp,%ebp
f0100e93:	57                   	push   %edi
f0100e94:	56                   	push   %esi
f0100e95:	53                   	push   %ebx
f0100e96:	83 ec 4c             	sub    $0x4c,%esp
f0100e99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0100e9c:	89 d7                	mov    %edx,%edi
f0100e9e:	8b 45 08             	mov    0x8(%ebp),%eax
f0100ea1:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100ea4:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100ea7:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100eaa:	8b 45 10             	mov    0x10(%ebp),%eax
		int i;
		if(num >= base){
f0100ead:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100eb0:	be 00 00 00 00       	mov    $0x0,%esi
f0100eb5:	39 d6                	cmp    %edx,%esi
f0100eb7:	72 07                	jb     f0100ec0 <printnum_width+0x30>
f0100eb9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100ebc:	39 c8                	cmp    %ecx,%eax
f0100ebe:	77 70                	ja     f0100f30 <printnum_width+0xa0>
			(*pcount)++;
f0100ec0:	8b 5d 20             	mov    0x20(%ebp),%ebx
f0100ec3:	83 03 01             	addl   $0x1,(%ebx)
			printnum_width(putch, putdat, num / base, base, width - 1, padc, pamnt, pcount);//num/base is used to print the least significant digit
f0100ec6:	89 5c 24 18          	mov    %ebx,0x18(%esp)
f0100eca:	8b 55 1c             	mov    0x1c(%ebp),%edx
f0100ecd:	89 54 24 14          	mov    %edx,0x14(%esp)
f0100ed1:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0100ed4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0100ed8:	8b 55 14             	mov    0x14(%ebp),%edx
f0100edb:	83 ea 01             	sub    $0x1,%edx
f0100ede:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100ee2:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100ee6:	8b 44 24 08          	mov    0x8(%esp),%eax
f0100eea:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0100eee:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100ef1:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0100ef4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100ef7:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100efb:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0100eff:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100f02:	89 0c 24             	mov    %ecx,(%esp)
f0100f05:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100f08:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100f0c:	e8 af 0c 00 00       	call   f0101bc0 <__udivdi3>
f0100f11:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0100f14:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0100f17:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0100f1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0100f1f:	89 04 24             	mov    %eax,(%esp)
f0100f22:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100f26:	89 fa                	mov    %edi,%edx
f0100f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100f2b:	e8 60 ff ff ff       	call   f0100e90 <printnum_width>
		}
		putch("0123456789abcdef"[num % base], putdat);
f0100f30:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100f34:	8b 04 24             	mov    (%esp),%eax
f0100f37:	8b 54 24 04          	mov    0x4(%esp),%edx
f0100f3b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100f3e:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0100f41:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100f44:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100f48:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0100f4c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100f4f:	89 0c 24             	mov    %ecx,(%esp)
f0100f52:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100f55:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100f59:	e8 92 0d 00 00       	call   f0101cf0 <__umoddi3>
f0100f5e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0100f61:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0100f65:	0f be 80 f1 23 10 f0 	movsbl -0xfefdc0f(%eax),%eax
f0100f6c:	89 04 24             	mov    %eax,(%esp)
f0100f6f:	ff 55 e4             	call   *-0x1c(%ebp)
		(*pamnt)++;//record the times of print operation
f0100f72:	8b 4d 1c             	mov    0x1c(%ebp),%ecx
f0100f75:	8b 01                	mov    (%ecx),%eax
f0100f77:	83 c0 01             	add    $0x1,%eax
f0100f7a:	89 01                	mov    %eax,(%ecx)
		if( *pamnt == (*pcount + 1) ){
f0100f7c:	8b 5d 20             	mov    0x20(%ebp),%ebx
f0100f7f:	8b 13                	mov    (%ebx),%edx
f0100f81:	83 c2 01             	add    $0x1,%edx
f0100f84:	39 d0                	cmp    %edx,%eax
f0100f86:	75 2e                	jne    f0100fb6 <printnum_width+0x126>
			if( width > *pamnt ){
f0100f88:	39 45 14             	cmp    %eax,0x14(%ebp)
f0100f8b:	7e 29                	jle    f0100fb6 <printnum_width+0x126>
				for( i = 0; i < width - *pamnt;  i++){
f0100f8d:	8b 55 14             	mov    0x14(%ebp),%edx
f0100f90:	29 c2                	sub    %eax,%edx
f0100f92:	85 d2                	test   %edx,%edx
f0100f94:	7e 20                	jle    f0100fb6 <printnum_width+0x126>
f0100f96:	be 00 00 00 00       	mov    $0x0,%esi
f0100f9b:	89 cb                	mov    %ecx,%ebx
					putch(padc, putdat);
f0100f9d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100fa1:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0100fa4:	89 0c 24             	mov    %ecx,(%esp)
f0100fa7:	ff 55 e4             	call   *-0x1c(%ebp)
		}
		putch("0123456789abcdef"[num % base], putdat);
		(*pamnt)++;//record the times of print operation
		if( *pamnt == (*pcount + 1) ){
			if( width > *pamnt ){
				for( i = 0; i < width - *pamnt;  i++){
f0100faa:	83 c6 01             	add    $0x1,%esi
f0100fad:	8b 45 14             	mov    0x14(%ebp),%eax
f0100fb0:	2b 03                	sub    (%ebx),%eax
f0100fb2:	39 f0                	cmp    %esi,%eax
f0100fb4:	7f e7                	jg     f0100f9d <printnum_width+0x10d>
					putch(padc, putdat);
				}	
			}
        	}
		return;
}
f0100fb6:	83 c4 4c             	add    $0x4c,%esp
f0100fb9:	5b                   	pop    %ebx
f0100fba:	5e                   	pop    %esi
f0100fbb:	5f                   	pop    %edi
f0100fbc:	5d                   	pop    %ebp
f0100fbd:	c3                   	ret    

f0100fbe <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0100fbe:	55                   	push   %ebp
f0100fbf:	89 e5                	mov    %esp,%ebp
f0100fc1:	57                   	push   %edi
f0100fc2:	56                   	push   %esi
f0100fc3:	53                   	push   %ebx
f0100fc4:	83 ec 5c             	sub    $0x5c,%esp
f0100fc7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100fca:	89 d6                	mov    %edx,%esi
f0100fcc:	8b 45 08             	mov    0x8(%ebp),%eax
f0100fcf:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100fd5:	89 55 d0             	mov    %edx,-0x30(%ebp)
f0100fd8:	8b 55 10             	mov    0x10(%ebp),%edx
f0100fdb:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0100fde:	8b 7d 18             	mov    0x18(%ebp),%edi
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	int amnt = 0, count = 0; 
f0100fe1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0100fe8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	if( padc != '0'){
f0100fef:	83 ff 30             	cmp    $0x30,%edi
f0100ff2:	74 42                	je     f0101036 <printnum+0x78>
		if( 9 > width && width > 0 ){
f0100ff4:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0100ff7:	83 f8 07             	cmp    $0x7,%eax
f0100ffa:	77 3a                	ja     f0101036 <printnum+0x78>
			padc = ' ';
			printnum_width(putch, putdat, num, base, width, padc, &amnt, &count);
f0100ffc:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0100fff:	89 44 24 18          	mov    %eax,0x18(%esp)
f0101003:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101006:	89 44 24 14          	mov    %eax,0x14(%esp)
f010100a:	c7 44 24 10 20 00 00 	movl   $0x20,0x10(%esp)
f0101011:	00 
f0101012:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0101016:	89 54 24 08          	mov    %edx,0x8(%esp)
f010101a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010101d:	89 0c 24             	mov    %ecx,(%esp)
f0101020:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0101023:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101027:	89 f2                	mov    %esi,%edx
f0101029:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010102c:	e8 5f fe ff ff       	call   f0100e90 <printnum_width>
			return;
f0101031:	e9 c8 00 00 00       	jmp    f01010fe <printnum+0x140>
		}
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0101036:	89 55 c8             	mov    %edx,-0x38(%ebp)
f0101039:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f010103d:	77 15                	ja     f0101054 <printnum+0x96>
f010103f:	90                   	nop
f0101040:	72 05                	jb     f0101047 <printnum+0x89>
f0101042:	39 55 cc             	cmp    %edx,-0x34(%ebp)
f0101045:	73 0d                	jae    f0101054 <printnum+0x96>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
f0101047:	83 eb 01             	sub    $0x1,%ebx
f010104a:	85 db                	test   %ebx,%ebx
f010104c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101050:	7f 61                	jg     f01010b3 <printnum+0xf5>
f0101052:	eb 70                	jmp    f01010c4 <printnum+0x106>
			return;
		}
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0101054:	89 7c 24 10          	mov    %edi,0x10(%esp)
f0101058:	83 eb 01             	sub    $0x1,%ebx
f010105b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010105f:	89 54 24 08          	mov    %edx,0x8(%esp)
f0101063:	8b 44 24 08          	mov    0x8(%esp),%eax
f0101067:	8b 54 24 0c          	mov    0xc(%esp),%edx
f010106b:	89 45 c0             	mov    %eax,-0x40(%ebp)
f010106e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0101071:	8b 55 c8             	mov    -0x38(%ebp),%edx
f0101074:	89 54 24 08          	mov    %edx,0x8(%esp)
f0101078:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f010107f:	00 
f0101080:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0101083:	89 0c 24             	mov    %ecx,(%esp)
f0101086:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0101089:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010108d:	e8 2e 0b 00 00       	call   f0101bc0 <__udivdi3>
f0101092:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0101095:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0101098:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010109c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f01010a0:	89 04 24             	mov    %eax,(%esp)
f01010a3:	89 54 24 04          	mov    %edx,0x4(%esp)
f01010a7:	89 f2                	mov    %esi,%edx
f01010a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01010ac:	e8 0d ff ff ff       	call   f0100fbe <printnum>
f01010b1:	eb 11                	jmp    f01010c4 <printnum+0x106>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
			putch(padc, putdat);
f01010b3:	89 74 24 04          	mov    %esi,0x4(%esp)
f01010b7:	89 3c 24             	mov    %edi,(%esp)
f01010ba:	ff 55 d4             	call   *-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
f01010bd:	83 eb 01             	sub    $0x1,%ebx
f01010c0:	85 db                	test   %ebx,%ebx
f01010c2:	7f ef                	jg     f01010b3 <printnum+0xf5>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit// highest digit
	putch("0123456789abcdef"[num % base], putdat);
f01010c4:	89 74 24 04          	mov    %esi,0x4(%esp)
f01010c8:	8b 74 24 04          	mov    0x4(%esp),%esi
f01010cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01010cf:	89 44 24 08          	mov    %eax,0x8(%esp)
f01010d3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f01010da:	00 
f01010db:	8b 55 cc             	mov    -0x34(%ebp),%edx
f01010de:	89 14 24             	mov    %edx,(%esp)
f01010e1:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f01010e4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f01010e8:	e8 03 0c 00 00       	call   f0101cf0 <__umoddi3>
f01010ed:	89 74 24 04          	mov    %esi,0x4(%esp)
f01010f1:	0f be 80 f1 23 10 f0 	movsbl -0xfefdc0f(%eax),%eax
f01010f8:	89 04 24             	mov    %eax,(%esp)
f01010fb:	ff 55 d4             	call   *-0x2c(%ebp)
}
f01010fe:	83 c4 5c             	add    $0x5c,%esp
f0101101:	5b                   	pop    %ebx
f0101102:	5e                   	pop    %esi
f0101103:	5f                   	pop    %edi
f0101104:	5d                   	pop    %ebp
f0101105:	c3                   	ret    

f0101106 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f0101106:	55                   	push   %ebp
f0101107:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0101109:	83 fa 01             	cmp    $0x1,%edx
f010110c:	7e 0e                	jle    f010111c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
f010110e:	8b 10                	mov    (%eax),%edx
f0101110:	8d 4a 08             	lea    0x8(%edx),%ecx
f0101113:	89 08                	mov    %ecx,(%eax)
f0101115:	8b 02                	mov    (%edx),%eax
f0101117:	8b 52 04             	mov    0x4(%edx),%edx
f010111a:	eb 22                	jmp    f010113e <getuint+0x38>
	else if (lflag)
f010111c:	85 d2                	test   %edx,%edx
f010111e:	74 10                	je     f0101130 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
f0101120:	8b 10                	mov    (%eax),%edx
f0101122:	8d 4a 04             	lea    0x4(%edx),%ecx
f0101125:	89 08                	mov    %ecx,(%eax)
f0101127:	8b 02                	mov    (%edx),%eax
f0101129:	ba 00 00 00 00       	mov    $0x0,%edx
f010112e:	eb 0e                	jmp    f010113e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
f0101130:	8b 10                	mov    (%eax),%edx
f0101132:	8d 4a 04             	lea    0x4(%edx),%ecx
f0101135:	89 08                	mov    %ecx,(%eax)
f0101137:	8b 02                	mov    (%edx),%eax
f0101139:	ba 00 00 00 00       	mov    $0x0,%edx
}
f010113e:	5d                   	pop    %ebp
f010113f:	c3                   	ret    

f0101140 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
f0101140:	55                   	push   %ebp
f0101141:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0101143:	83 fa 01             	cmp    $0x1,%edx
f0101146:	7e 0e                	jle    f0101156 <getint+0x16>
		return va_arg(*ap, long long);
f0101148:	8b 10                	mov    (%eax),%edx
f010114a:	8d 4a 08             	lea    0x8(%edx),%ecx
f010114d:	89 08                	mov    %ecx,(%eax)
f010114f:	8b 02                	mov    (%edx),%eax
f0101151:	8b 52 04             	mov    0x4(%edx),%edx
f0101154:	eb 22                	jmp    f0101178 <getint+0x38>
	else if (lflag)
f0101156:	85 d2                	test   %edx,%edx
f0101158:	74 10                	je     f010116a <getint+0x2a>
		return va_arg(*ap, long);
f010115a:	8b 10                	mov    (%eax),%edx
f010115c:	8d 4a 04             	lea    0x4(%edx),%ecx
f010115f:	89 08                	mov    %ecx,(%eax)
f0101161:	8b 02                	mov    (%edx),%eax
f0101163:	89 c2                	mov    %eax,%edx
f0101165:	c1 fa 1f             	sar    $0x1f,%edx
f0101168:	eb 0e                	jmp    f0101178 <getint+0x38>
	else
		return va_arg(*ap, int);
f010116a:	8b 10                	mov    (%eax),%edx
f010116c:	8d 4a 04             	lea    0x4(%edx),%ecx
f010116f:	89 08                	mov    %ecx,(%eax)
f0101171:	8b 02                	mov    (%edx),%eax
f0101173:	89 c2                	mov    %eax,%edx
f0101175:	c1 fa 1f             	sar    $0x1f,%edx
}
f0101178:	5d                   	pop    %ebp
f0101179:	c3                   	ret    

f010117a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f010117a:	55                   	push   %ebp
f010117b:	89 e5                	mov    %esp,%ebp
f010117d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0101180:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0101184:	8b 10                	mov    (%eax),%edx
f0101186:	3b 50 04             	cmp    0x4(%eax),%edx
f0101189:	73 0a                	jae    f0101195 <sprintputch+0x1b>
		*b->buf++ = ch;
f010118b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010118e:	88 0a                	mov    %cl,(%edx)
f0101190:	83 c2 01             	add    $0x1,%edx
f0101193:	89 10                	mov    %edx,(%eax)
}
f0101195:	5d                   	pop    %ebp
f0101196:	c3                   	ret    

f0101197 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f0101197:	55                   	push   %ebp
f0101198:	89 e5                	mov    %esp,%ebp
f010119a:	57                   	push   %edi
f010119b:	56                   	push   %esi
f010119c:	53                   	push   %ebx
f010119d:	83 ec 5c             	sub    $0x5c,%esp
f01011a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01011a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
f01011a6:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
f01011ad:	eb 17                	jmp    f01011c6 <vprintfmt+0x2f>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f01011af:	85 c0                	test   %eax,%eax
f01011b1:	0f 84 5e 04 00 00    	je     f0101615 <vprintfmt+0x47e>
				return;
			putch(ch, putdat);
f01011b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01011bb:	89 04 24             	mov    %eax,(%esp)
f01011be:	ff 55 08             	call   *0x8(%ebp)
f01011c1:	eb 03                	jmp    f01011c6 <vprintfmt+0x2f>
f01011c3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01011c6:	0f b6 03             	movzbl (%ebx),%eax
f01011c9:	83 c3 01             	add    $0x1,%ebx
f01011cc:	83 f8 25             	cmp    $0x25,%eax
f01011cf:	75 de                	jne    f01011af <vprintfmt+0x18>
f01011d1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f01011d8:	c6 45 d0 20          	movb   $0x20,-0x30(%ebp)
f01011dc:	be ff ff ff ff       	mov    $0xffffffff,%esi
f01011e1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
f01011e8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f01011ef:	eb 06                	jmp    f01011f7 <vprintfmt+0x60>
f01011f1:	c6 45 d0 2d          	movb   $0x2d,-0x30(%ebp)
f01011f5:	89 cb                	mov    %ecx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01011f7:	0f b6 03             	movzbl (%ebx),%eax
f01011fa:	0f b6 d0             	movzbl %al,%edx
f01011fd:	8d 4b 01             	lea    0x1(%ebx),%ecx
f0101200:	83 e8 23             	sub    $0x23,%eax
f0101203:	3c 55                	cmp    $0x55,%al
f0101205:	0f 87 ec 03 00 00    	ja     f01015f7 <vprintfmt+0x460>
f010120b:	0f b6 c0             	movzbl %al,%eax
f010120e:	ff 24 85 fc 24 10 f0 	jmp    *-0xfefdb04(,%eax,4)
f0101215:	c6 45 d0 30          	movb   $0x30,-0x30(%ebp)
f0101219:	eb da                	jmp    f01011f5 <vprintfmt+0x5e>
		case '8':
			width = 8;
			goto reswitch;
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f010121b:	8d 72 d0             	lea    -0x30(%edx),%esi
				ch = *fmt;
f010121e:	0f be 01             	movsbl (%ecx),%eax
				if (ch < '0' || ch > '9')
f0101221:	8d 50 d0             	lea    -0x30(%eax),%edx
f0101224:	83 fa 09             	cmp    $0x9,%edx
f0101227:	76 0b                	jbe    f0101234 <vprintfmt+0x9d>
f0101229:	eb 43                	jmp    f010126e <vprintfmt+0xd7>
f010122b:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%ebp)
		case '5':
		case '6':
		case '7':
		case '8':
			width = 8;
			goto reswitch;
f0101232:	eb c1                	jmp    f01011f5 <vprintfmt+0x5e>
		case '9':
			for (precision = 0; ; ++fmt) {
f0101234:	83 c1 01             	add    $0x1,%ecx
				precision = precision * 10 + ch - '0';
f0101237:	8d 14 b6             	lea    (%esi,%esi,4),%edx
f010123a:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
f010123e:	0f be 01             	movsbl (%ecx),%eax
				if (ch < '0' || ch > '9')
f0101241:	8d 50 d0             	lea    -0x30(%eax),%edx
f0101244:	83 fa 09             	cmp    $0x9,%edx
f0101247:	76 eb                	jbe    f0101234 <vprintfmt+0x9d>
f0101249:	eb 23                	jmp    f010126e <vprintfmt+0xd7>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f010124b:	8b 45 14             	mov    0x14(%ebp),%eax
f010124e:	8d 50 04             	lea    0x4(%eax),%edx
f0101251:	89 55 14             	mov    %edx,0x14(%ebp)
f0101254:	8b 30                	mov    (%eax),%esi
			goto process_precision;
f0101256:	eb 16                	jmp    f010126e <vprintfmt+0xd7>

		case '.':
			if (width < 0)
f0101258:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010125b:	c1 f8 1f             	sar    $0x1f,%eax
f010125e:	f7 d0                	not    %eax
f0101260:	21 45 e4             	and    %eax,-0x1c(%ebp)
f0101263:	eb 90                	jmp    f01011f5 <vprintfmt+0x5e>
f0101265:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
f010126c:	eb 87                	jmp    f01011f5 <vprintfmt+0x5e>

		process_precision:
			if (width < 0)
f010126e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0101272:	79 81                	jns    f01011f5 <vprintfmt+0x5e>
f0101274:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f0101277:	8b 75 c8             	mov    -0x38(%ebp),%esi
f010127a:	e9 76 ff ff ff       	jmp    f01011f5 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f010127f:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
f0101283:	e9 6d ff ff ff       	jmp    f01011f5 <vprintfmt+0x5e>
f0101288:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f010128b:	8b 45 14             	mov    0x14(%ebp),%eax
f010128e:	8d 50 04             	lea    0x4(%eax),%edx
f0101291:	89 55 14             	mov    %edx,0x14(%ebp)
f0101294:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101298:	8b 00                	mov    (%eax),%eax
f010129a:	89 04 24             	mov    %eax,(%esp)
f010129d:	ff 55 08             	call   *0x8(%ebp)
f01012a0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f01012a3:	e9 1e ff ff ff       	jmp    f01011c6 <vprintfmt+0x2f>
f01012a8:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
f01012ab:	8b 45 14             	mov    0x14(%ebp),%eax
f01012ae:	8d 50 04             	lea    0x4(%eax),%edx
f01012b1:	89 55 14             	mov    %edx,0x14(%ebp)
f01012b4:	8b 00                	mov    (%eax),%eax
f01012b6:	89 c2                	mov    %eax,%edx
f01012b8:	c1 fa 1f             	sar    $0x1f,%edx
f01012bb:	31 d0                	xor    %edx,%eax
f01012bd:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01012bf:	83 f8 06             	cmp    $0x6,%eax
f01012c2:	7f 0b                	jg     f01012cf <vprintfmt+0x138>
f01012c4:	8b 14 85 54 26 10 f0 	mov    -0xfefd9ac(,%eax,4),%edx
f01012cb:	85 d2                	test   %edx,%edx
f01012cd:	75 23                	jne    f01012f2 <vprintfmt+0x15b>
				printfmt(putch, putdat, "error %d", err);
f01012cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01012d3:	c7 44 24 08 02 24 10 	movl   $0xf0102402,0x8(%esp)
f01012da:	f0 
f01012db:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01012df:	8b 45 08             	mov    0x8(%ebp),%eax
f01012e2:	89 04 24             	mov    %eax,(%esp)
f01012e5:	e8 b3 03 00 00       	call   f010169d <printfmt>
f01012ea:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01012ed:	e9 d4 fe ff ff       	jmp    f01011c6 <vprintfmt+0x2f>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
f01012f2:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01012f6:	c7 44 24 08 0b 24 10 	movl   $0xf010240b,0x8(%esp)
f01012fd:	f0 
f01012fe:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101302:	8b 55 08             	mov    0x8(%ebp),%edx
f0101305:	89 14 24             	mov    %edx,(%esp)
f0101308:	e8 90 03 00 00       	call   f010169d <printfmt>
f010130d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0101310:	e9 b1 fe ff ff       	jmp    f01011c6 <vprintfmt+0x2f>
f0101315:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f0101318:	89 cb                	mov    %ecx,%ebx
f010131a:	89 f1                	mov    %esi,%ecx
f010131c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010131f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0101322:	8b 45 14             	mov    0x14(%ebp),%eax
f0101325:	8d 50 04             	lea    0x4(%eax),%edx
f0101328:	89 55 14             	mov    %edx,0x14(%ebp)
f010132b:	8b 00                	mov    (%eax),%eax
f010132d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101330:	85 c0                	test   %eax,%eax
f0101332:	75 07                	jne    f010133b <vprintfmt+0x1a4>
f0101334:	c7 45 d4 0e 24 10 f0 	movl   $0xf010240e,-0x2c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
f010133b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f010133f:	7e 06                	jle    f0101347 <vprintfmt+0x1b0>
f0101341:	80 7d d0 2d          	cmpb   $0x2d,-0x30(%ebp)
f0101345:	75 13                	jne    f010135a <vprintfmt+0x1c3>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0101347:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010134a:	0f be 02             	movsbl (%edx),%eax
f010134d:	85 c0                	test   %eax,%eax
f010134f:	0f 85 95 00 00 00    	jne    f01013ea <vprintfmt+0x253>
f0101355:	e9 85 00 00 00       	jmp    f01013df <vprintfmt+0x248>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f010135a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f010135e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101361:	89 04 24             	mov    %eax,(%esp)
f0101364:	e8 62 04 00 00       	call   f01017cb <strnlen>
f0101369:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f010136c:	29 c2                	sub    %eax,%edx
f010136e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101371:	85 d2                	test   %edx,%edx
f0101373:	7e d2                	jle    f0101347 <vprintfmt+0x1b0>
					putch(padc, putdat);
f0101375:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
f0101379:	89 75 c4             	mov    %esi,-0x3c(%ebp)
f010137c:	89 5d c0             	mov    %ebx,-0x40(%ebp)
f010137f:	89 d3                	mov    %edx,%ebx
f0101381:	89 c6                	mov    %eax,%esi
f0101383:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101387:	89 34 24             	mov    %esi,(%esp)
f010138a:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f010138d:	83 eb 01             	sub    $0x1,%ebx
f0101390:	85 db                	test   %ebx,%ebx
f0101392:	7f ef                	jg     f0101383 <vprintfmt+0x1ec>
f0101394:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0101397:	8b 5d c0             	mov    -0x40(%ebp),%ebx
f010139a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f01013a1:	eb a4                	jmp    f0101347 <vprintfmt+0x1b0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f01013a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f01013a7:	74 19                	je     f01013c2 <vprintfmt+0x22b>
f01013a9:	8d 50 e0             	lea    -0x20(%eax),%edx
f01013ac:	83 fa 5e             	cmp    $0x5e,%edx
f01013af:	76 11                	jbe    f01013c2 <vprintfmt+0x22b>
					putch('?', putdat);
f01013b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01013b5:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f01013bc:	ff 55 08             	call   *0x8(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f01013bf:	90                   	nop
f01013c0:	eb 0a                	jmp    f01013cc <vprintfmt+0x235>
					putch('?', putdat);
				else
					putch(ch, putdat);
f01013c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01013c6:	89 04 24             	mov    %eax,(%esp)
f01013c9:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f01013cc:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
f01013d0:	0f be 03             	movsbl (%ebx),%eax
f01013d3:	85 c0                	test   %eax,%eax
f01013d5:	74 05                	je     f01013dc <vprintfmt+0x245>
f01013d7:	83 c3 01             	add    $0x1,%ebx
f01013da:	eb 19                	jmp    f01013f5 <vprintfmt+0x25e>
f01013dc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f01013df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01013e3:	7f 1e                	jg     f0101403 <vprintfmt+0x26c>
f01013e5:	e9 d9 fd ff ff       	jmp    f01011c3 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f01013ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01013ed:	83 c2 01             	add    $0x1,%edx
f01013f0:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
f01013f3:	89 d3                	mov    %edx,%ebx
f01013f5:	85 f6                	test   %esi,%esi
f01013f7:	78 aa                	js     f01013a3 <vprintfmt+0x20c>
f01013f9:	83 ee 01             	sub    $0x1,%esi
f01013fc:	79 a5                	jns    f01013a3 <vprintfmt+0x20c>
f01013fe:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101401:	eb dc                	jmp    f01013df <vprintfmt+0x248>
f0101403:	8b 75 08             	mov    0x8(%ebp),%esi
f0101406:	89 5d d8             	mov    %ebx,-0x28(%ebp)
f0101409:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f010140c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101410:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0101417:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0101419:	83 eb 01             	sub    $0x1,%ebx
f010141c:	85 db                	test   %ebx,%ebx
f010141e:	7f ec                	jg     f010140c <vprintfmt+0x275>
f0101420:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f0101423:	e9 9e fd ff ff       	jmp    f01011c6 <vprintfmt+0x2f>
f0101428:	89 4d cc             	mov    %ecx,-0x34(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);//different data type
f010142b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010142e:	8d 45 14             	lea    0x14(%ebp),%eax
f0101431:	e8 0a fd ff ff       	call   f0101140 <getint>
f0101436:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101439:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010143c:	89 c3                	mov    %eax,%ebx
f010143e:	89 d6                	mov    %edx,%esi
f0101440:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
f0101445:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0101449:	0f 89 b2 00 00 00    	jns    f0101501 <vprintfmt+0x36a>
				putch('-', putdat);
f010144f:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101453:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f010145a:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f010145d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f0101460:	8b 75 dc             	mov    -0x24(%ebp),%esi
f0101463:	f7 db                	neg    %ebx
f0101465:	83 d6 00             	adc    $0x0,%esi
f0101468:	f7 de                	neg    %esi
f010146a:	ba 0a 00 00 00       	mov    $0xa,%edx
f010146f:	e9 8d 00 00 00       	jmp    f0101501 <vprintfmt+0x36a>
f0101474:	89 4d cc             	mov    %ecx,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f0101477:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010147a:	8d 45 14             	lea    0x14(%ebp),%eax
f010147d:	e8 84 fc ff ff       	call   f0101106 <getuint>
f0101482:	89 c3                	mov    %eax,%ebx
f0101484:	89 d6                	mov    %edx,%esi
f0101486:	ba 0a 00 00 00       	mov    $0xa,%edx
			base = 10;
			goto number;
f010148b:	eb 74                	jmp    f0101501 <vprintfmt+0x36a>
f010148d:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			// display a number in octal form and the form should begin with '0'
			putch('0', putdat);
f0101490:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101494:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f010149b:	ff 55 08             	call   *0x8(%ebp)
			num = getuint(&ap, lflag);
f010149e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01014a1:	8d 45 14             	lea    0x14(%ebp),%eax
f01014a4:	e8 5d fc ff ff       	call   f0101106 <getuint>
f01014a9:	89 c3                	mov    %eax,%ebx
f01014ab:	89 d6                	mov    %edx,%esi
f01014ad:	ba 08 00 00 00       	mov    $0x8,%edx
			base = 8;
			goto number;
f01014b2:	eb 4d                	jmp    f0101501 <vprintfmt+0x36a>
f01014b4:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
f01014b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01014bb:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f01014c2:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f01014c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01014c9:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f01014d0:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
f01014d3:	8b 45 14             	mov    0x14(%ebp),%eax
f01014d6:	8d 50 04             	lea    0x4(%eax),%edx
f01014d9:	89 55 14             	mov    %edx,0x14(%ebp)
f01014dc:	8b 18                	mov    (%eax),%ebx
f01014de:	be 00 00 00 00       	mov    $0x0,%esi
f01014e3:	ba 10 00 00 00       	mov    $0x10,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
f01014e8:	eb 17                	jmp    f0101501 <vprintfmt+0x36a>
f01014ea:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':

			num = getuint(&ap, lflag);
f01014ed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01014f0:	8d 45 14             	lea    0x14(%ebp),%eax
f01014f3:	e8 0e fc ff ff       	call   f0101106 <getuint>
f01014f8:	89 c3                	mov    %eax,%ebx
f01014fa:	89 d6                	mov    %edx,%esi
f01014fc:	ba 10 00 00 00       	mov    $0x10,%edx
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
f0101501:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
f0101505:	89 44 24 10          	mov    %eax,0x10(%esp)
f0101509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010150c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101510:	89 54 24 08          	mov    %edx,0x8(%esp)
f0101514:	89 1c 24             	mov    %ebx,(%esp)
f0101517:	89 74 24 04          	mov    %esi,0x4(%esp)
f010151b:	89 fa                	mov    %edi,%edx
f010151d:	8b 45 08             	mov    0x8(%ebp),%eax
f0101520:	e8 99 fa ff ff       	call   f0100fbe <printnum>
f0101525:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f0101528:	e9 99 fc ff ff       	jmp    f01011c6 <vprintfmt+0x2f>
f010152d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
            //        can represent.

            const char *null_error = "\nerror! writing through NULL pointer! (%n argument)\n";
            const char *overflow_error = "\nwarning! The value %n argument pointed to has been overflowed!\n";
            // Your code here
	    q = va_arg(ap, char *);//after call va_arg(), it will point to next argument
f0101530:	8b 45 14             	mov    0x14(%ebp),%eax
f0101533:	8d 50 04             	lea    0x4(%eax),%edx
f0101536:	89 55 14             	mov    %edx,0x14(%ebp)
f0101539:	8b 30                	mov    (%eax),%esi
	    if ( q == NULL ){
f010153b:	85 f6                	test   %esi,%esi
f010153d:	75 21                	jne    f0101560 <vprintfmt+0x3c9>
f010153f:	bb 81 24 10 f0       	mov    $0xf0102481,%ebx
f0101544:	b8 0a 00 00 00       	mov    $0xa,%eax
		while ((ch = *null_error++) != '\0') {
                        cputchar(ch);
f0101549:	89 04 24             	mov    %eax,(%esp)
f010154c:	e8 39 f0 ff ff       	call   f010058a <cputchar>
            const char *null_error = "\nerror! writing through NULL pointer! (%n argument)\n";
            const char *overflow_error = "\nwarning! The value %n argument pointed to has been overflowed!\n";
            // Your code here
	    q = va_arg(ap, char *);//after call va_arg(), it will point to next argument
	    if ( q == NULL ){
		while ((ch = *null_error++) != '\0') {
f0101551:	0f be 03             	movsbl (%ebx),%eax
f0101554:	83 c3 01             	add    $0x1,%ebx
f0101557:	85 c0                	test   %eax,%eax
f0101559:	75 ee                	jne    f0101549 <vprintfmt+0x3b2>
f010155b:	e9 63 fc ff ff       	jmp    f01011c3 <vprintfmt+0x2c>
                        cputchar(ch);
                }
	    	break;
	    }
	    if ( *(unsigned char *)putdat >= 255 ){//why did it can't be 255?  
f0101560:	80 3f ff             	cmpb   $0xff,(%edi)
f0101563:	75 27                	jne    f010158c <vprintfmt+0x3f5>
f0101565:	bb b9 24 10 f0       	mov    $0xf01024b9,%ebx
f010156a:	b8 0a 00 00 00       	mov    $0xa,%eax
		while ((ch = *(char *) overflow_error++) != '\0') {
                        cputchar(ch);
f010156f:	89 04 24             	mov    %eax,(%esp)
f0101572:	e8 13 f0 ff ff       	call   f010058a <cputchar>
                        cputchar(ch);
                }
	    	break;
	    }
	    if ( *(unsigned char *)putdat >= 255 ){//why did it can't be 255?  
		while ((ch = *(char *) overflow_error++) != '\0') {
f0101577:	0f be 03             	movsbl (%ebx),%eax
f010157a:	83 c3 01             	add    $0x1,%ebx
f010157d:	85 c0                	test   %eax,%eax
f010157f:	75 ee                	jne    f010156f <vprintfmt+0x3d8>
                        cputchar(ch);
                }
		*q = -1;
f0101581:	c6 06 ff             	movb   $0xff,(%esi)
f0101584:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		break;
f0101587:	e9 3a fc ff ff       	jmp    f01011c6 <vprintfmt+0x2f>
	    }
 	    *q = *(char *)putdat;
f010158c:	0f b6 07             	movzbl (%edi),%eax
f010158f:	88 06                	mov    %al,(%esi)
f0101591:	8b 5d cc             	mov    -0x34(%ebp),%ebx
            break;
f0101594:	e9 2d fc ff ff       	jmp    f01011c6 <vprintfmt+0x2f>
f0101599:	89 4d cc             	mov    %ecx,-0x34(%ebp)
        }
		// escaped '%' character
		case '%':
			putch(ch, putdat);
f010159c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01015a0:	89 14 24             	mov    %edx,(%esp)
f01015a3:	ff 55 08             	call   *0x8(%ebp)
f01015a6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f01015a9:	e9 18 fc ff ff       	jmp    f01011c6 <vprintfmt+0x2f>
f01015ae:	89 4d cc             	mov    %ecx,-0x34(%ebp)
			
		// unrecognized escape sequence - just print it literally
		//precede the result with a plus or minus sign (+ or -) even for positive numbers-added by tww
		case '+':
			num = getint(&ap, lflag);//after call getint(),the argument will go to next
f01015b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01015b4:	8d 45 14             	lea    0x14(%ebp),%eax
f01015b7:	e8 84 fb ff ff       	call   f0101140 <getint>
f01015bc:	89 c3                	mov    %eax,%ebx
f01015be:	89 d6                	mov    %edx,%esi
		        if ((long long) num < 0) {
f01015c0:	85 d2                	test   %edx,%edx
f01015c2:	79 17                	jns    f01015db <vprintfmt+0x444>
				putch('-', putdat);
f01015c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01015c8:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f01015cf:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f01015d2:	f7 db                	neg    %ebx
f01015d4:	83 d6 00             	adc    $0x0,%esi
f01015d7:	f7 de                	neg    %esi
f01015d9:	eb 0e                	jmp    f01015e9 <vprintfmt+0x452>
			}
			else{
				putch('+', putdat);
f01015db:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01015df:	c7 04 24 2b 00 00 00 	movl   $0x2b,(%esp)
f01015e6:	ff 55 08             	call   *0x8(%ebp)
			}
			base = 10;
			fmt++;
f01015e9:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
f01015ed:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
f01015f2:	e9 0a ff ff ff       	jmp    f0101501 <vprintfmt+0x36a>
		default:
			putch('%', putdat);
f01015f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01015fb:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0101602:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f0101605:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0101608:	80 38 25             	cmpb   $0x25,(%eax)
f010160b:	0f 84 b5 fb ff ff    	je     f01011c6 <vprintfmt+0x2f>
f0101611:	89 c3                	mov    %eax,%ebx
f0101613:	eb f0                	jmp    f0101605 <vprintfmt+0x46e>
				/* do nothing */;
			break;
		}
	}
}
f0101615:	83 c4 5c             	add    $0x5c,%esp
f0101618:	5b                   	pop    %ebx
f0101619:	5e                   	pop    %esi
f010161a:	5f                   	pop    %edi
f010161b:	5d                   	pop    %ebp
f010161c:	c3                   	ret    

f010161d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f010161d:	55                   	push   %ebp
f010161e:	89 e5                	mov    %esp,%ebp
f0101620:	83 ec 28             	sub    $0x28,%esp
f0101623:	8b 45 08             	mov    0x8(%ebp),%eax
f0101626:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
f0101629:	85 c0                	test   %eax,%eax
f010162b:	74 04                	je     f0101631 <vsnprintf+0x14>
f010162d:	85 d2                	test   %edx,%edx
f010162f:	7f 07                	jg     f0101638 <vsnprintf+0x1b>
f0101631:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0101636:	eb 3b                	jmp    f0101673 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
f0101638:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010163b:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
f010163f:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0101642:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0101649:	8b 45 14             	mov    0x14(%ebp),%eax
f010164c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101650:	8b 45 10             	mov    0x10(%ebp),%eax
f0101653:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101657:	8d 45 ec             	lea    -0x14(%ebp),%eax
f010165a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010165e:	c7 04 24 7a 11 10 f0 	movl   $0xf010117a,(%esp)
f0101665:	e8 2d fb ff ff       	call   f0101197 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f010166a:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010166d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0101670:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f0101673:	c9                   	leave  
f0101674:	c3                   	ret    

f0101675 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0101675:	55                   	push   %ebp
f0101676:	89 e5                	mov    %esp,%ebp
f0101678:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
f010167b:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
f010167e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101682:	8b 45 10             	mov    0x10(%ebp),%eax
f0101685:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101689:	8b 45 0c             	mov    0xc(%ebp),%eax
f010168c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101690:	8b 45 08             	mov    0x8(%ebp),%eax
f0101693:	89 04 24             	mov    %eax,(%esp)
f0101696:	e8 82 ff ff ff       	call   f010161d <vsnprintf>
	va_end(ap);

	return rc;
}
f010169b:	c9                   	leave  
f010169c:	c3                   	ret    

f010169d <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...)
{
f010169d:	55                   	push   %ebp
f010169e:	89 e5                	mov    %esp,%ebp
f01016a0:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...)
f01016a3:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
f01016a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01016aa:	8b 45 10             	mov    0x10(%ebp),%eax
f01016ad:	89 44 24 08          	mov    %eax,0x8(%esp)
f01016b1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01016b4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01016b8:	8b 45 08             	mov    0x8(%ebp),%eax
f01016bb:	89 04 24             	mov    %eax,(%esp)
f01016be:	e8 d4 fa ff ff       	call   f0101197 <vprintfmt>
	va_end(ap);
}
f01016c3:	c9                   	leave  
f01016c4:	c3                   	ret    
	...

f01016d0 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f01016d0:	55                   	push   %ebp
f01016d1:	89 e5                	mov    %esp,%ebp
f01016d3:	57                   	push   %edi
f01016d4:	56                   	push   %esi
f01016d5:	53                   	push   %ebx
f01016d6:	83 ec 1c             	sub    $0x1c,%esp
f01016d9:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f01016dc:	85 c0                	test   %eax,%eax
f01016de:	74 10                	je     f01016f0 <readline+0x20>
		cprintf("%s", prompt);
f01016e0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01016e4:	c7 04 24 0b 24 10 f0 	movl   $0xf010240b,(%esp)
f01016eb:	e8 eb f3 ff ff       	call   f0100adb <cprintf>

	i = 0;
	echoing = iscons(0);
f01016f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01016f7:	e8 8a ec ff ff       	call   f0100386 <iscons>
f01016fc:	89 c7                	mov    %eax,%edi
f01016fe:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
f0101703:	e8 6d ec ff ff       	call   f0100375 <getchar>
f0101708:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f010170a:	85 c0                	test   %eax,%eax
f010170c:	79 17                	jns    f0101725 <readline+0x55>
			cprintf("read error: %e\n", c);
f010170e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101712:	c7 04 24 70 26 10 f0 	movl   $0xf0102670,(%esp)
f0101719:	e8 bd f3 ff ff       	call   f0100adb <cprintf>
f010171e:	b8 00 00 00 00       	mov    $0x0,%eax
			return NULL;
f0101723:	eb 76                	jmp    f010179b <readline+0xcb>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0101725:	83 f8 08             	cmp    $0x8,%eax
f0101728:	74 08                	je     f0101732 <readline+0x62>
f010172a:	83 f8 7f             	cmp    $0x7f,%eax
f010172d:	8d 76 00             	lea    0x0(%esi),%esi
f0101730:	75 19                	jne    f010174b <readline+0x7b>
f0101732:	85 f6                	test   %esi,%esi
f0101734:	7e 15                	jle    f010174b <readline+0x7b>
			if (echoing)
f0101736:	85 ff                	test   %edi,%edi
f0101738:	74 0c                	je     f0101746 <readline+0x76>
				cputchar('\b');
f010173a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f0101741:	e8 44 ee ff ff       	call   f010058a <cputchar>
			i--;
f0101746:	83 ee 01             	sub    $0x1,%esi
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0101749:	eb b8                	jmp    f0101703 <readline+0x33>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
f010174b:	83 fb 1f             	cmp    $0x1f,%ebx
f010174e:	66 90                	xchg   %ax,%ax
f0101750:	7e 23                	jle    f0101775 <readline+0xa5>
f0101752:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0101758:	7f 1b                	jg     f0101775 <readline+0xa5>
			if (echoing)
f010175a:	85 ff                	test   %edi,%edi
f010175c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101760:	74 08                	je     f010176a <readline+0x9a>
				cputchar(c);
f0101762:	89 1c 24             	mov    %ebx,(%esp)
f0101765:	e8 20 ee ff ff       	call   f010058a <cputchar>
			buf[i++] = c;
f010176a:	88 9e 60 35 11 f0    	mov    %bl,-0xfeecaa0(%esi)
f0101770:	83 c6 01             	add    $0x1,%esi
f0101773:	eb 8e                	jmp    f0101703 <readline+0x33>
		} else if (c == '\n' || c == '\r') {
f0101775:	83 fb 0a             	cmp    $0xa,%ebx
f0101778:	74 05                	je     f010177f <readline+0xaf>
f010177a:	83 fb 0d             	cmp    $0xd,%ebx
f010177d:	75 84                	jne    f0101703 <readline+0x33>
			if (echoing)
f010177f:	85 ff                	test   %edi,%edi
f0101781:	74 0c                	je     f010178f <readline+0xbf>
				cputchar('\n');
f0101783:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f010178a:	e8 fb ed ff ff       	call   f010058a <cputchar>
			buf[i] = 0;
f010178f:	c6 86 60 35 11 f0 00 	movb   $0x0,-0xfeecaa0(%esi)
f0101796:	b8 60 35 11 f0       	mov    $0xf0113560,%eax
			return buf;
		}
	}
}
f010179b:	83 c4 1c             	add    $0x1c,%esp
f010179e:	5b                   	pop    %ebx
f010179f:	5e                   	pop    %esi
f01017a0:	5f                   	pop    %edi
f01017a1:	5d                   	pop    %ebp
f01017a2:	c3                   	ret    
	...

f01017b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f01017b0:	55                   	push   %ebp
f01017b1:	89 e5                	mov    %esp,%ebp
f01017b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f01017b6:	b8 00 00 00 00       	mov    $0x0,%eax
f01017bb:	80 3a 00             	cmpb   $0x0,(%edx)
f01017be:	74 09                	je     f01017c9 <strlen+0x19>
		n++;
f01017c0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f01017c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f01017c7:	75 f7                	jne    f01017c0 <strlen+0x10>
		n++;
	return n;
}
f01017c9:	5d                   	pop    %ebp
f01017ca:	c3                   	ret    

f01017cb <strnlen>:

int
strnlen(const char *s, size_t size)
{
f01017cb:	55                   	push   %ebp
f01017cc:	89 e5                	mov    %esp,%ebp
f01017ce:	53                   	push   %ebx
f01017cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01017d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01017d5:	85 c9                	test   %ecx,%ecx
f01017d7:	74 19                	je     f01017f2 <strnlen+0x27>
f01017d9:	80 3b 00             	cmpb   $0x0,(%ebx)
f01017dc:	74 14                	je     f01017f2 <strnlen+0x27>
f01017de:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
f01017e3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01017e6:	39 c8                	cmp    %ecx,%eax
f01017e8:	74 0d                	je     f01017f7 <strnlen+0x2c>
f01017ea:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
f01017ee:	75 f3                	jne    f01017e3 <strnlen+0x18>
f01017f0:	eb 05                	jmp    f01017f7 <strnlen+0x2c>
f01017f2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
f01017f7:	5b                   	pop    %ebx
f01017f8:	5d                   	pop    %ebp
f01017f9:	c3                   	ret    

f01017fa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f01017fa:	55                   	push   %ebp
f01017fb:	89 e5                	mov    %esp,%ebp
f01017fd:	53                   	push   %ebx
f01017fe:	8b 45 08             	mov    0x8(%ebp),%eax
f0101801:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101804:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0101809:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f010180d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0101810:	83 c2 01             	add    $0x1,%edx
f0101813:	84 c9                	test   %cl,%cl
f0101815:	75 f2                	jne    f0101809 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0101817:	5b                   	pop    %ebx
f0101818:	5d                   	pop    %ebp
f0101819:	c3                   	ret    

f010181a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f010181a:	55                   	push   %ebp
f010181b:	89 e5                	mov    %esp,%ebp
f010181d:	56                   	push   %esi
f010181e:	53                   	push   %ebx
f010181f:	8b 45 08             	mov    0x8(%ebp),%eax
f0101822:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101825:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0101828:	85 f6                	test   %esi,%esi
f010182a:	74 18                	je     f0101844 <strncpy+0x2a>
f010182c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
f0101831:	0f b6 1a             	movzbl (%edx),%ebx
f0101834:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0101837:	80 3a 01             	cmpb   $0x1,(%edx)
f010183a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f010183d:	83 c1 01             	add    $0x1,%ecx
f0101840:	39 ce                	cmp    %ecx,%esi
f0101842:	77 ed                	ja     f0101831 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f0101844:	5b                   	pop    %ebx
f0101845:	5e                   	pop    %esi
f0101846:	5d                   	pop    %ebp
f0101847:	c3                   	ret    

f0101848 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0101848:	55                   	push   %ebp
f0101849:	89 e5                	mov    %esp,%ebp
f010184b:	56                   	push   %esi
f010184c:	53                   	push   %ebx
f010184d:	8b 75 08             	mov    0x8(%ebp),%esi
f0101850:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101853:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0101856:	89 f0                	mov    %esi,%eax
f0101858:	85 c9                	test   %ecx,%ecx
f010185a:	74 27                	je     f0101883 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
f010185c:	83 e9 01             	sub    $0x1,%ecx
f010185f:	74 1d                	je     f010187e <strlcpy+0x36>
f0101861:	0f b6 1a             	movzbl (%edx),%ebx
f0101864:	84 db                	test   %bl,%bl
f0101866:	74 16                	je     f010187e <strlcpy+0x36>
			*dst++ = *src++;
f0101868:	88 18                	mov    %bl,(%eax)
f010186a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f010186d:	83 e9 01             	sub    $0x1,%ecx
f0101870:	74 0e                	je     f0101880 <strlcpy+0x38>
			*dst++ = *src++;
f0101872:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f0101875:	0f b6 1a             	movzbl (%edx),%ebx
f0101878:	84 db                	test   %bl,%bl
f010187a:	75 ec                	jne    f0101868 <strlcpy+0x20>
f010187c:	eb 02                	jmp    f0101880 <strlcpy+0x38>
f010187e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
f0101880:	c6 00 00             	movb   $0x0,(%eax)
f0101883:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
f0101885:	5b                   	pop    %ebx
f0101886:	5e                   	pop    %esi
f0101887:	5d                   	pop    %ebp
f0101888:	c3                   	ret    

f0101889 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0101889:	55                   	push   %ebp
f010188a:	89 e5                	mov    %esp,%ebp
f010188c:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010188f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0101892:	0f b6 01             	movzbl (%ecx),%eax
f0101895:	84 c0                	test   %al,%al
f0101897:	74 15                	je     f01018ae <strcmp+0x25>
f0101899:	3a 02                	cmp    (%edx),%al
f010189b:	75 11                	jne    f01018ae <strcmp+0x25>
		p++, q++;
f010189d:	83 c1 01             	add    $0x1,%ecx
f01018a0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f01018a3:	0f b6 01             	movzbl (%ecx),%eax
f01018a6:	84 c0                	test   %al,%al
f01018a8:	74 04                	je     f01018ae <strcmp+0x25>
f01018aa:	3a 02                	cmp    (%edx),%al
f01018ac:	74 ef                	je     f010189d <strcmp+0x14>
f01018ae:	0f b6 c0             	movzbl %al,%eax
f01018b1:	0f b6 12             	movzbl (%edx),%edx
f01018b4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
f01018b6:	5d                   	pop    %ebp
f01018b7:	c3                   	ret    

f01018b8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f01018b8:	55                   	push   %ebp
f01018b9:	89 e5                	mov    %esp,%ebp
f01018bb:	53                   	push   %ebx
f01018bc:	8b 55 08             	mov    0x8(%ebp),%edx
f01018bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01018c2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
f01018c5:	85 c0                	test   %eax,%eax
f01018c7:	74 23                	je     f01018ec <strncmp+0x34>
f01018c9:	0f b6 1a             	movzbl (%edx),%ebx
f01018cc:	84 db                	test   %bl,%bl
f01018ce:	74 24                	je     f01018f4 <strncmp+0x3c>
f01018d0:	3a 19                	cmp    (%ecx),%bl
f01018d2:	75 20                	jne    f01018f4 <strncmp+0x3c>
f01018d4:	83 e8 01             	sub    $0x1,%eax
f01018d7:	74 13                	je     f01018ec <strncmp+0x34>
		n--, p++, q++;
f01018d9:	83 c2 01             	add    $0x1,%edx
f01018dc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f01018df:	0f b6 1a             	movzbl (%edx),%ebx
f01018e2:	84 db                	test   %bl,%bl
f01018e4:	74 0e                	je     f01018f4 <strncmp+0x3c>
f01018e6:	3a 19                	cmp    (%ecx),%bl
f01018e8:	74 ea                	je     f01018d4 <strncmp+0x1c>
f01018ea:	eb 08                	jmp    f01018f4 <strncmp+0x3c>
f01018ec:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f01018f1:	5b                   	pop    %ebx
f01018f2:	5d                   	pop    %ebp
f01018f3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f01018f4:	0f b6 02             	movzbl (%edx),%eax
f01018f7:	0f b6 11             	movzbl (%ecx),%edx
f01018fa:	29 d0                	sub    %edx,%eax
f01018fc:	eb f3                	jmp    f01018f1 <strncmp+0x39>

f01018fe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f01018fe:	55                   	push   %ebp
f01018ff:	89 e5                	mov    %esp,%ebp
f0101901:	8b 45 08             	mov    0x8(%ebp),%eax
f0101904:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0101908:	0f b6 10             	movzbl (%eax),%edx
f010190b:	84 d2                	test   %dl,%dl
f010190d:	74 15                	je     f0101924 <strchr+0x26>
		if (*s == c)
f010190f:	38 ca                	cmp    %cl,%dl
f0101911:	75 07                	jne    f010191a <strchr+0x1c>
f0101913:	eb 14                	jmp    f0101929 <strchr+0x2b>
f0101915:	38 ca                	cmp    %cl,%dl
f0101917:	90                   	nop
f0101918:	74 0f                	je     f0101929 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f010191a:	83 c0 01             	add    $0x1,%eax
f010191d:	0f b6 10             	movzbl (%eax),%edx
f0101920:	84 d2                	test   %dl,%dl
f0101922:	75 f1                	jne    f0101915 <strchr+0x17>
f0101924:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
f0101929:	5d                   	pop    %ebp
f010192a:	c3                   	ret    

f010192b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010192b:	55                   	push   %ebp
f010192c:	89 e5                	mov    %esp,%ebp
f010192e:	8b 45 08             	mov    0x8(%ebp),%eax
f0101931:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0101935:	0f b6 10             	movzbl (%eax),%edx
f0101938:	84 d2                	test   %dl,%dl
f010193a:	74 18                	je     f0101954 <strfind+0x29>
		if (*s == c)
f010193c:	38 ca                	cmp    %cl,%dl
f010193e:	75 0a                	jne    f010194a <strfind+0x1f>
f0101940:	eb 12                	jmp    f0101954 <strfind+0x29>
f0101942:	38 ca                	cmp    %cl,%dl
f0101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101948:	74 0a                	je     f0101954 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f010194a:	83 c0 01             	add    $0x1,%eax
f010194d:	0f b6 10             	movzbl (%eax),%edx
f0101950:	84 d2                	test   %dl,%dl
f0101952:	75 ee                	jne    f0101942 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
f0101954:	5d                   	pop    %ebp
f0101955:	c3                   	ret    

f0101956 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0101956:	55                   	push   %ebp
f0101957:	89 e5                	mov    %esp,%ebp
f0101959:	83 ec 0c             	sub    $0xc,%esp
f010195c:	89 1c 24             	mov    %ebx,(%esp)
f010195f:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101963:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0101967:	8b 7d 08             	mov    0x8(%ebp),%edi
f010196a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010196d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0101970:	85 c9                	test   %ecx,%ecx
f0101972:	74 30                	je     f01019a4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0101974:	f7 c7 03 00 00 00    	test   $0x3,%edi
f010197a:	75 25                	jne    f01019a1 <memset+0x4b>
f010197c:	f6 c1 03             	test   $0x3,%cl
f010197f:	75 20                	jne    f01019a1 <memset+0x4b>
		c &= 0xFF;
f0101981:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0101984:	89 d3                	mov    %edx,%ebx
f0101986:	c1 e3 08             	shl    $0x8,%ebx
f0101989:	89 d6                	mov    %edx,%esi
f010198b:	c1 e6 18             	shl    $0x18,%esi
f010198e:	89 d0                	mov    %edx,%eax
f0101990:	c1 e0 10             	shl    $0x10,%eax
f0101993:	09 f0                	or     %esi,%eax
f0101995:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
f0101997:	09 d8                	or     %ebx,%eax
f0101999:	c1 e9 02             	shr    $0x2,%ecx
f010199c:	fc                   	cld    
f010199d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f010199f:	eb 03                	jmp    f01019a4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01019a1:	fc                   	cld    
f01019a2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01019a4:	89 f8                	mov    %edi,%eax
f01019a6:	8b 1c 24             	mov    (%esp),%ebx
f01019a9:	8b 74 24 04          	mov    0x4(%esp),%esi
f01019ad:	8b 7c 24 08          	mov    0x8(%esp),%edi
f01019b1:	89 ec                	mov    %ebp,%esp
f01019b3:	5d                   	pop    %ebp
f01019b4:	c3                   	ret    

f01019b5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01019b5:	55                   	push   %ebp
f01019b6:	89 e5                	mov    %esp,%ebp
f01019b8:	83 ec 08             	sub    $0x8,%esp
f01019bb:	89 34 24             	mov    %esi,(%esp)
f01019be:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01019c2:	8b 45 08             	mov    0x8(%ebp),%eax
f01019c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
f01019c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
f01019cb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
f01019cd:	39 c6                	cmp    %eax,%esi
f01019cf:	73 35                	jae    f0101a06 <memmove+0x51>
f01019d1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01019d4:	39 d0                	cmp    %edx,%eax
f01019d6:	73 2e                	jae    f0101a06 <memmove+0x51>
		s += n;
		d += n;
f01019d8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01019da:	f6 c2 03             	test   $0x3,%dl
f01019dd:	75 1b                	jne    f01019fa <memmove+0x45>
f01019df:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01019e5:	75 13                	jne    f01019fa <memmove+0x45>
f01019e7:	f6 c1 03             	test   $0x3,%cl
f01019ea:	75 0e                	jne    f01019fa <memmove+0x45>
			asm volatile("std; rep movsl\n"
f01019ec:	83 ef 04             	sub    $0x4,%edi
f01019ef:	8d 72 fc             	lea    -0x4(%edx),%esi
f01019f2:	c1 e9 02             	shr    $0x2,%ecx
f01019f5:	fd                   	std    
f01019f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01019f8:	eb 09                	jmp    f0101a03 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f01019fa:	83 ef 01             	sub    $0x1,%edi
f01019fd:	8d 72 ff             	lea    -0x1(%edx),%esi
f0101a00:	fd                   	std    
f0101a01:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0101a03:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0101a04:	eb 20                	jmp    f0101a26 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101a06:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0101a0c:	75 15                	jne    f0101a23 <memmove+0x6e>
f0101a0e:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0101a14:	75 0d                	jne    f0101a23 <memmove+0x6e>
f0101a16:	f6 c1 03             	test   $0x3,%cl
f0101a19:	75 08                	jne    f0101a23 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
f0101a1b:	c1 e9 02             	shr    $0x2,%ecx
f0101a1e:	fc                   	cld    
f0101a1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101a21:	eb 03                	jmp    f0101a26 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0101a23:	fc                   	cld    
f0101a24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0101a26:	8b 34 24             	mov    (%esp),%esi
f0101a29:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0101a2d:	89 ec                	mov    %ebp,%esp
f0101a2f:	5d                   	pop    %ebp
f0101a30:	c3                   	ret    

f0101a31 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
f0101a31:	55                   	push   %ebp
f0101a32:	89 e5                	mov    %esp,%ebp
f0101a34:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0101a37:	8b 45 10             	mov    0x10(%ebp),%eax
f0101a3a:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101a41:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101a45:	8b 45 08             	mov    0x8(%ebp),%eax
f0101a48:	89 04 24             	mov    %eax,(%esp)
f0101a4b:	e8 65 ff ff ff       	call   f01019b5 <memmove>
}
f0101a50:	c9                   	leave  
f0101a51:	c3                   	ret    

f0101a52 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0101a52:	55                   	push   %ebp
f0101a53:	89 e5                	mov    %esp,%ebp
f0101a55:	57                   	push   %edi
f0101a56:	56                   	push   %esi
f0101a57:	53                   	push   %ebx
f0101a58:	8b 75 08             	mov    0x8(%ebp),%esi
f0101a5b:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0101a5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0101a61:	85 c9                	test   %ecx,%ecx
f0101a63:	74 36                	je     f0101a9b <memcmp+0x49>
		if (*s1 != *s2)
f0101a65:	0f b6 06             	movzbl (%esi),%eax
f0101a68:	0f b6 1f             	movzbl (%edi),%ebx
f0101a6b:	38 d8                	cmp    %bl,%al
f0101a6d:	74 20                	je     f0101a8f <memcmp+0x3d>
f0101a6f:	eb 14                	jmp    f0101a85 <memcmp+0x33>
f0101a71:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
f0101a76:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
f0101a7b:	83 c2 01             	add    $0x1,%edx
f0101a7e:	83 e9 01             	sub    $0x1,%ecx
f0101a81:	38 d8                	cmp    %bl,%al
f0101a83:	74 12                	je     f0101a97 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
f0101a85:	0f b6 c0             	movzbl %al,%eax
f0101a88:	0f b6 db             	movzbl %bl,%ebx
f0101a8b:	29 d8                	sub    %ebx,%eax
f0101a8d:	eb 11                	jmp    f0101aa0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0101a8f:	83 e9 01             	sub    $0x1,%ecx
f0101a92:	ba 00 00 00 00       	mov    $0x0,%edx
f0101a97:	85 c9                	test   %ecx,%ecx
f0101a99:	75 d6                	jne    f0101a71 <memcmp+0x1f>
f0101a9b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
f0101aa0:	5b                   	pop    %ebx
f0101aa1:	5e                   	pop    %esi
f0101aa2:	5f                   	pop    %edi
f0101aa3:	5d                   	pop    %ebp
f0101aa4:	c3                   	ret    

f0101aa5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0101aa5:	55                   	push   %ebp
f0101aa6:	89 e5                	mov    %esp,%ebp
f0101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
f0101aab:	89 c2                	mov    %eax,%edx
f0101aad:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0101ab0:	39 d0                	cmp    %edx,%eax
f0101ab2:	73 15                	jae    f0101ac9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
f0101ab4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
f0101ab8:	38 08                	cmp    %cl,(%eax)
f0101aba:	75 06                	jne    f0101ac2 <memfind+0x1d>
f0101abc:	eb 0b                	jmp    f0101ac9 <memfind+0x24>
f0101abe:	38 08                	cmp    %cl,(%eax)
f0101ac0:	74 07                	je     f0101ac9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f0101ac2:	83 c0 01             	add    $0x1,%eax
f0101ac5:	39 c2                	cmp    %eax,%edx
f0101ac7:	77 f5                	ja     f0101abe <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f0101ac9:	5d                   	pop    %ebp
f0101aca:	c3                   	ret    

f0101acb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0101acb:	55                   	push   %ebp
f0101acc:	89 e5                	mov    %esp,%ebp
f0101ace:	57                   	push   %edi
f0101acf:	56                   	push   %esi
f0101ad0:	53                   	push   %ebx
f0101ad1:	83 ec 04             	sub    $0x4,%esp
f0101ad4:	8b 55 08             	mov    0x8(%ebp),%edx
f0101ad7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0101ada:	0f b6 02             	movzbl (%edx),%eax
f0101add:	3c 20                	cmp    $0x20,%al
f0101adf:	74 04                	je     f0101ae5 <strtol+0x1a>
f0101ae1:	3c 09                	cmp    $0x9,%al
f0101ae3:	75 0e                	jne    f0101af3 <strtol+0x28>
		s++;
f0101ae5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0101ae8:	0f b6 02             	movzbl (%edx),%eax
f0101aeb:	3c 20                	cmp    $0x20,%al
f0101aed:	74 f6                	je     f0101ae5 <strtol+0x1a>
f0101aef:	3c 09                	cmp    $0x9,%al
f0101af1:	74 f2                	je     f0101ae5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
f0101af3:	3c 2b                	cmp    $0x2b,%al
f0101af5:	75 0c                	jne    f0101b03 <strtol+0x38>
		s++;
f0101af7:	83 c2 01             	add    $0x1,%edx
f0101afa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101b01:	eb 15                	jmp    f0101b18 <strtol+0x4d>
	else if (*s == '-')
f0101b03:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101b0a:	3c 2d                	cmp    $0x2d,%al
f0101b0c:	75 0a                	jne    f0101b18 <strtol+0x4d>
		s++, neg = 1;
f0101b0e:	83 c2 01             	add    $0x1,%edx
f0101b11:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0101b18:	85 db                	test   %ebx,%ebx
f0101b1a:	0f 94 c0             	sete   %al
f0101b1d:	74 05                	je     f0101b24 <strtol+0x59>
f0101b1f:	83 fb 10             	cmp    $0x10,%ebx
f0101b22:	75 18                	jne    f0101b3c <strtol+0x71>
f0101b24:	80 3a 30             	cmpb   $0x30,(%edx)
f0101b27:	75 13                	jne    f0101b3c <strtol+0x71>
f0101b29:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0101b2d:	8d 76 00             	lea    0x0(%esi),%esi
f0101b30:	75 0a                	jne    f0101b3c <strtol+0x71>
		s += 2, base = 16;
f0101b32:	83 c2 02             	add    $0x2,%edx
f0101b35:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0101b3a:	eb 15                	jmp    f0101b51 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0101b3c:	84 c0                	test   %al,%al
f0101b3e:	66 90                	xchg   %ax,%ax
f0101b40:	74 0f                	je     f0101b51 <strtol+0x86>
f0101b42:	bb 0a 00 00 00       	mov    $0xa,%ebx
f0101b47:	80 3a 30             	cmpb   $0x30,(%edx)
f0101b4a:	75 05                	jne    f0101b51 <strtol+0x86>
		s++, base = 8;
f0101b4c:	83 c2 01             	add    $0x1,%edx
f0101b4f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0101b51:	b8 00 00 00 00       	mov    $0x0,%eax
f0101b56:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0101b58:	0f b6 0a             	movzbl (%edx),%ecx
f0101b5b:	89 cf                	mov    %ecx,%edi
f0101b5d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
f0101b60:	80 fb 09             	cmp    $0x9,%bl
f0101b63:	77 08                	ja     f0101b6d <strtol+0xa2>
			dig = *s - '0';
f0101b65:	0f be c9             	movsbl %cl,%ecx
f0101b68:	83 e9 30             	sub    $0x30,%ecx
f0101b6b:	eb 1e                	jmp    f0101b8b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
f0101b6d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
f0101b70:	80 fb 19             	cmp    $0x19,%bl
f0101b73:	77 08                	ja     f0101b7d <strtol+0xb2>
			dig = *s - 'a' + 10;
f0101b75:	0f be c9             	movsbl %cl,%ecx
f0101b78:	83 e9 57             	sub    $0x57,%ecx
f0101b7b:	eb 0e                	jmp    f0101b8b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
f0101b7d:	8d 5f bf             	lea    -0x41(%edi),%ebx
f0101b80:	80 fb 19             	cmp    $0x19,%bl
f0101b83:	77 15                	ja     f0101b9a <strtol+0xcf>
			dig = *s - 'A' + 10;
f0101b85:	0f be c9             	movsbl %cl,%ecx
f0101b88:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f0101b8b:	39 f1                	cmp    %esi,%ecx
f0101b8d:	7d 0b                	jge    f0101b9a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
f0101b8f:	83 c2 01             	add    $0x1,%edx
f0101b92:	0f af c6             	imul   %esi,%eax
f0101b95:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
f0101b98:	eb be                	jmp    f0101b58 <strtol+0x8d>
f0101b9a:	89 c1                	mov    %eax,%ecx

	if (endptr)
f0101b9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0101ba0:	74 05                	je     f0101ba7 <strtol+0xdc>
		*endptr = (char *) s;
f0101ba2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101ba5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
f0101ba7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0101bab:	74 04                	je     f0101bb1 <strtol+0xe6>
f0101bad:	89 c8                	mov    %ecx,%eax
f0101baf:	f7 d8                	neg    %eax
}
f0101bb1:	83 c4 04             	add    $0x4,%esp
f0101bb4:	5b                   	pop    %ebx
f0101bb5:	5e                   	pop    %esi
f0101bb6:	5f                   	pop    %edi
f0101bb7:	5d                   	pop    %ebp
f0101bb8:	c3                   	ret    
f0101bb9:	00 00                	add    %al,(%eax)
f0101bbb:	00 00                	add    %al,(%eax)
f0101bbd:	00 00                	add    %al,(%eax)
	...

f0101bc0 <__udivdi3>:
f0101bc0:	55                   	push   %ebp
f0101bc1:	89 e5                	mov    %esp,%ebp
f0101bc3:	57                   	push   %edi
f0101bc4:	56                   	push   %esi
f0101bc5:	83 ec 10             	sub    $0x10,%esp
f0101bc8:	8b 45 14             	mov    0x14(%ebp),%eax
f0101bcb:	8b 55 08             	mov    0x8(%ebp),%edx
f0101bce:	8b 75 10             	mov    0x10(%ebp),%esi
f0101bd1:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0101bd4:	85 c0                	test   %eax,%eax
f0101bd6:	89 55 f0             	mov    %edx,-0x10(%ebp)
f0101bd9:	75 35                	jne    f0101c10 <__udivdi3+0x50>
f0101bdb:	39 fe                	cmp    %edi,%esi
f0101bdd:	77 61                	ja     f0101c40 <__udivdi3+0x80>
f0101bdf:	85 f6                	test   %esi,%esi
f0101be1:	75 0b                	jne    f0101bee <__udivdi3+0x2e>
f0101be3:	b8 01 00 00 00       	mov    $0x1,%eax
f0101be8:	31 d2                	xor    %edx,%edx
f0101bea:	f7 f6                	div    %esi
f0101bec:	89 c6                	mov    %eax,%esi
f0101bee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0101bf1:	31 d2                	xor    %edx,%edx
f0101bf3:	89 f8                	mov    %edi,%eax
f0101bf5:	f7 f6                	div    %esi
f0101bf7:	89 c7                	mov    %eax,%edi
f0101bf9:	89 c8                	mov    %ecx,%eax
f0101bfb:	f7 f6                	div    %esi
f0101bfd:	89 c1                	mov    %eax,%ecx
f0101bff:	89 fa                	mov    %edi,%edx
f0101c01:	89 c8                	mov    %ecx,%eax
f0101c03:	83 c4 10             	add    $0x10,%esp
f0101c06:	5e                   	pop    %esi
f0101c07:	5f                   	pop    %edi
f0101c08:	5d                   	pop    %ebp
f0101c09:	c3                   	ret    
f0101c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101c10:	39 f8                	cmp    %edi,%eax
f0101c12:	77 1c                	ja     f0101c30 <__udivdi3+0x70>
f0101c14:	0f bd d0             	bsr    %eax,%edx
f0101c17:	83 f2 1f             	xor    $0x1f,%edx
f0101c1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101c1d:	75 39                	jne    f0101c58 <__udivdi3+0x98>
f0101c1f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0101c22:	0f 86 a0 00 00 00    	jbe    f0101cc8 <__udivdi3+0x108>
f0101c28:	39 f8                	cmp    %edi,%eax
f0101c2a:	0f 82 98 00 00 00    	jb     f0101cc8 <__udivdi3+0x108>
f0101c30:	31 ff                	xor    %edi,%edi
f0101c32:	31 c9                	xor    %ecx,%ecx
f0101c34:	89 c8                	mov    %ecx,%eax
f0101c36:	89 fa                	mov    %edi,%edx
f0101c38:	83 c4 10             	add    $0x10,%esp
f0101c3b:	5e                   	pop    %esi
f0101c3c:	5f                   	pop    %edi
f0101c3d:	5d                   	pop    %ebp
f0101c3e:	c3                   	ret    
f0101c3f:	90                   	nop
f0101c40:	89 d1                	mov    %edx,%ecx
f0101c42:	89 fa                	mov    %edi,%edx
f0101c44:	89 c8                	mov    %ecx,%eax
f0101c46:	31 ff                	xor    %edi,%edi
f0101c48:	f7 f6                	div    %esi
f0101c4a:	89 c1                	mov    %eax,%ecx
f0101c4c:	89 fa                	mov    %edi,%edx
f0101c4e:	89 c8                	mov    %ecx,%eax
f0101c50:	83 c4 10             	add    $0x10,%esp
f0101c53:	5e                   	pop    %esi
f0101c54:	5f                   	pop    %edi
f0101c55:	5d                   	pop    %ebp
f0101c56:	c3                   	ret    
f0101c57:	90                   	nop
f0101c58:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101c5c:	89 f2                	mov    %esi,%edx
f0101c5e:	d3 e0                	shl    %cl,%eax
f0101c60:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0101c63:	b8 20 00 00 00       	mov    $0x20,%eax
f0101c68:	2b 45 f4             	sub    -0xc(%ebp),%eax
f0101c6b:	89 c1                	mov    %eax,%ecx
f0101c6d:	d3 ea                	shr    %cl,%edx
f0101c6f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101c73:	0b 55 ec             	or     -0x14(%ebp),%edx
f0101c76:	d3 e6                	shl    %cl,%esi
f0101c78:	89 c1                	mov    %eax,%ecx
f0101c7a:	89 75 e8             	mov    %esi,-0x18(%ebp)
f0101c7d:	89 fe                	mov    %edi,%esi
f0101c7f:	d3 ee                	shr    %cl,%esi
f0101c81:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101c85:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101c88:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101c8b:	d3 e7                	shl    %cl,%edi
f0101c8d:	89 c1                	mov    %eax,%ecx
f0101c8f:	d3 ea                	shr    %cl,%edx
f0101c91:	09 d7                	or     %edx,%edi
f0101c93:	89 f2                	mov    %esi,%edx
f0101c95:	89 f8                	mov    %edi,%eax
f0101c97:	f7 75 ec             	divl   -0x14(%ebp)
f0101c9a:	89 d6                	mov    %edx,%esi
f0101c9c:	89 c7                	mov    %eax,%edi
f0101c9e:	f7 65 e8             	mull   -0x18(%ebp)
f0101ca1:	39 d6                	cmp    %edx,%esi
f0101ca3:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101ca6:	72 30                	jb     f0101cd8 <__udivdi3+0x118>
f0101ca8:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101cab:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101caf:	d3 e2                	shl    %cl,%edx
f0101cb1:	39 c2                	cmp    %eax,%edx
f0101cb3:	73 05                	jae    f0101cba <__udivdi3+0xfa>
f0101cb5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
f0101cb8:	74 1e                	je     f0101cd8 <__udivdi3+0x118>
f0101cba:	89 f9                	mov    %edi,%ecx
f0101cbc:	31 ff                	xor    %edi,%edi
f0101cbe:	e9 71 ff ff ff       	jmp    f0101c34 <__udivdi3+0x74>
f0101cc3:	90                   	nop
f0101cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101cc8:	31 ff                	xor    %edi,%edi
f0101cca:	b9 01 00 00 00       	mov    $0x1,%ecx
f0101ccf:	e9 60 ff ff ff       	jmp    f0101c34 <__udivdi3+0x74>
f0101cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101cd8:	8d 4f ff             	lea    -0x1(%edi),%ecx
f0101cdb:	31 ff                	xor    %edi,%edi
f0101cdd:	89 c8                	mov    %ecx,%eax
f0101cdf:	89 fa                	mov    %edi,%edx
f0101ce1:	83 c4 10             	add    $0x10,%esp
f0101ce4:	5e                   	pop    %esi
f0101ce5:	5f                   	pop    %edi
f0101ce6:	5d                   	pop    %ebp
f0101ce7:	c3                   	ret    
	...

f0101cf0 <__umoddi3>:
f0101cf0:	55                   	push   %ebp
f0101cf1:	89 e5                	mov    %esp,%ebp
f0101cf3:	57                   	push   %edi
f0101cf4:	56                   	push   %esi
f0101cf5:	83 ec 20             	sub    $0x20,%esp
f0101cf8:	8b 55 14             	mov    0x14(%ebp),%edx
f0101cfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101cfe:	8b 7d 10             	mov    0x10(%ebp),%edi
f0101d01:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101d04:	85 d2                	test   %edx,%edx
f0101d06:	89 c8                	mov    %ecx,%eax
f0101d08:	89 4d f4             	mov    %ecx,-0xc(%ebp)
f0101d0b:	75 13                	jne    f0101d20 <__umoddi3+0x30>
f0101d0d:	39 f7                	cmp    %esi,%edi
f0101d0f:	76 3f                	jbe    f0101d50 <__umoddi3+0x60>
f0101d11:	89 f2                	mov    %esi,%edx
f0101d13:	f7 f7                	div    %edi
f0101d15:	89 d0                	mov    %edx,%eax
f0101d17:	31 d2                	xor    %edx,%edx
f0101d19:	83 c4 20             	add    $0x20,%esp
f0101d1c:	5e                   	pop    %esi
f0101d1d:	5f                   	pop    %edi
f0101d1e:	5d                   	pop    %ebp
f0101d1f:	c3                   	ret    
f0101d20:	39 f2                	cmp    %esi,%edx
f0101d22:	77 4c                	ja     f0101d70 <__umoddi3+0x80>
f0101d24:	0f bd ca             	bsr    %edx,%ecx
f0101d27:	83 f1 1f             	xor    $0x1f,%ecx
f0101d2a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0101d2d:	75 51                	jne    f0101d80 <__umoddi3+0x90>
f0101d2f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
f0101d32:	0f 87 e0 00 00 00    	ja     f0101e18 <__umoddi3+0x128>
f0101d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101d3b:	29 f8                	sub    %edi,%eax
f0101d3d:	19 d6                	sbb    %edx,%esi
f0101d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101d45:	89 f2                	mov    %esi,%edx
f0101d47:	83 c4 20             	add    $0x20,%esp
f0101d4a:	5e                   	pop    %esi
f0101d4b:	5f                   	pop    %edi
f0101d4c:	5d                   	pop    %ebp
f0101d4d:	c3                   	ret    
f0101d4e:	66 90                	xchg   %ax,%ax
f0101d50:	85 ff                	test   %edi,%edi
f0101d52:	75 0b                	jne    f0101d5f <__umoddi3+0x6f>
f0101d54:	b8 01 00 00 00       	mov    $0x1,%eax
f0101d59:	31 d2                	xor    %edx,%edx
f0101d5b:	f7 f7                	div    %edi
f0101d5d:	89 c7                	mov    %eax,%edi
f0101d5f:	89 f0                	mov    %esi,%eax
f0101d61:	31 d2                	xor    %edx,%edx
f0101d63:	f7 f7                	div    %edi
f0101d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101d68:	f7 f7                	div    %edi
f0101d6a:	eb a9                	jmp    f0101d15 <__umoddi3+0x25>
f0101d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101d70:	89 c8                	mov    %ecx,%eax
f0101d72:	89 f2                	mov    %esi,%edx
f0101d74:	83 c4 20             	add    $0x20,%esp
f0101d77:	5e                   	pop    %esi
f0101d78:	5f                   	pop    %edi
f0101d79:	5d                   	pop    %ebp
f0101d7a:	c3                   	ret    
f0101d7b:	90                   	nop
f0101d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101d80:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101d84:	d3 e2                	shl    %cl,%edx
f0101d86:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101d89:	ba 20 00 00 00       	mov    $0x20,%edx
f0101d8e:	2b 55 f0             	sub    -0x10(%ebp),%edx
f0101d91:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101d94:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101d98:	89 fa                	mov    %edi,%edx
f0101d9a:	d3 ea                	shr    %cl,%edx
f0101d9c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101da0:	0b 55 f4             	or     -0xc(%ebp),%edx
f0101da3:	d3 e7                	shl    %cl,%edi
f0101da5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101da9:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101dac:	89 f2                	mov    %esi,%edx
f0101dae:	89 7d e8             	mov    %edi,-0x18(%ebp)
f0101db1:	89 c7                	mov    %eax,%edi
f0101db3:	d3 ea                	shr    %cl,%edx
f0101db5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101db9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101dbc:	89 c2                	mov    %eax,%edx
f0101dbe:	d3 e6                	shl    %cl,%esi
f0101dc0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101dc4:	d3 ea                	shr    %cl,%edx
f0101dc6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101dca:	09 d6                	or     %edx,%esi
f0101dcc:	89 f0                	mov    %esi,%eax
f0101dce:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0101dd1:	d3 e7                	shl    %cl,%edi
f0101dd3:	89 f2                	mov    %esi,%edx
f0101dd5:	f7 75 f4             	divl   -0xc(%ebp)
f0101dd8:	89 d6                	mov    %edx,%esi
f0101dda:	f7 65 e8             	mull   -0x18(%ebp)
f0101ddd:	39 d6                	cmp    %edx,%esi
f0101ddf:	72 2b                	jb     f0101e0c <__umoddi3+0x11c>
f0101de1:	39 c7                	cmp    %eax,%edi
f0101de3:	72 23                	jb     f0101e08 <__umoddi3+0x118>
f0101de5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101de9:	29 c7                	sub    %eax,%edi
f0101deb:	19 d6                	sbb    %edx,%esi
f0101ded:	89 f0                	mov    %esi,%eax
f0101def:	89 f2                	mov    %esi,%edx
f0101df1:	d3 ef                	shr    %cl,%edi
f0101df3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101df7:	d3 e0                	shl    %cl,%eax
f0101df9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101dfd:	09 f8                	or     %edi,%eax
f0101dff:	d3 ea                	shr    %cl,%edx
f0101e01:	83 c4 20             	add    $0x20,%esp
f0101e04:	5e                   	pop    %esi
f0101e05:	5f                   	pop    %edi
f0101e06:	5d                   	pop    %ebp
f0101e07:	c3                   	ret    
f0101e08:	39 d6                	cmp    %edx,%esi
f0101e0a:	75 d9                	jne    f0101de5 <__umoddi3+0xf5>
f0101e0c:	2b 45 e8             	sub    -0x18(%ebp),%eax
f0101e0f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
f0101e12:	eb d1                	jmp    f0101de5 <__umoddi3+0xf5>
f0101e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101e18:	39 f2                	cmp    %esi,%edx
f0101e1a:	0f 82 18 ff ff ff    	jb     f0101d38 <__umoddi3+0x48>
f0101e20:	e9 1d ff ff ff       	jmp    f0101d42 <__umoddi3+0x52>
