
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
f0100058:	c7 04 24 80 1d 10 f0 	movl   $0xf0101d80,(%esp)
f010005f:	e8 37 0a 00 00       	call   f0100a9b <cprintf>
	vcprintf(fmt, ap);
f0100064:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100068:	8b 45 10             	mov    0x10(%ebp),%eax
f010006b:	89 04 24             	mov    %eax,(%esp)
f010006e:	e8 f5 09 00 00       	call   f0100a68 <vcprintf>
	cprintf("\n");
f0100073:	c7 04 24 a5 1e 10 f0 	movl   $0xf0101ea5,(%esp)
f010007a:	e8 1c 0a 00 00       	call   f0100a9b <cprintf>
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
f01000b2:	c7 04 24 9a 1d 10 f0 	movl   $0xf0101d9a,(%esp)
f01000b9:	e8 dd 09 00 00       	call   f0100a9b <cprintf>
	vcprintf(fmt, ap);
f01000be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01000c2:	89 34 24             	mov    %esi,(%esp)
f01000c5:	e8 9e 09 00 00       	call   f0100a68 <vcprintf>
	cprintf("\n");
f01000ca:	c7 04 24 a5 1e 10 f0 	movl   $0xf0101ea5,(%esp)
f01000d1:	e8 c5 09 00 00       	call   f0100a9b <cprintf>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01000dd:	e8 39 08 00 00       	call   f010091b <monitor>
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
f01000f2:	c7 04 24 b2 1d 10 f0 	movl   $0xf0101db2,(%esp)
f01000f9:	e8 9d 09 00 00       	call   f0100a9b <cprintf>
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
f010012f:	c7 04 24 ce 1d 10 f0 	movl   $0xf0101dce,(%esp)
f0100136:	e8 60 09 00 00       	call   f0100a9b <cprintf>
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
f010019c:	e8 05 17 00 00       	call   f01018a6 <memset>

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
f01001bc:	c7 04 24 30 1e 10 f0 	movl   $0xf0101e30,(%esp)
f01001c3:	e8 d3 08 00 00       	call   f0100a9b <cprintf>
	cprintf("pading space in the right to number 22: %8d.\n", 22);
f01001c8:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
f01001cf:	00 
f01001d0:	c7 04 24 50 1e 10 f0 	movl   $0xf0101e50,(%esp)
f01001d7:	e8 bf 08 00 00       	call   f0100a9b <cprintf>
	cprintf("chnum1: %d chnum2: %d\n", chnum1, chnum2);
f01001dc:	0f be 45 f6          	movsbl -0xa(%ebp),%eax
f01001e0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01001e4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
f01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01001ec:	c7 04 24 e9 1d 10 f0 	movl   $0xf0101de9,(%esp)
f01001f3:	e8 a3 08 00 00       	call   f0100a9b <cprintf>
	cprintf("%n", NULL);
f01001f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01001ff:	00 
f0100200:	c7 04 24 02 1e 10 f0 	movl   $0xf0101e02,(%esp)
f0100207:	e8 8f 08 00 00       	call   f0100a9b <cprintf>
	memset(ntest, 0xd, sizeof(ntest) - 1);
f010020c:	c7 44 24 08 ff 00 00 	movl   $0xff,0x8(%esp)
f0100213:	00 
f0100214:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
f010021b:	00 
f010021c:	8d 9d f6 fe ff ff    	lea    -0x10a(%ebp),%ebx
f0100222:	89 1c 24             	mov    %ebx,(%esp)
f0100225:	e8 7c 16 00 00       	call   f01018a6 <memset>
	cprintf("%s%n", ntest, &chnum1); 
f010022a:	89 7c 24 08          	mov    %edi,0x8(%esp)
f010022e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100232:	c7 04 24 00 1e 10 f0 	movl   $0xf0101e00,(%esp)
f0100239:	e8 5d 08 00 00       	call   f0100a9b <cprintf>
	cprintf("chnum1: %d\n", chnum1);
f010023e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
f0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100246:	c7 04 24 05 1e 10 f0 	movl   $0xf0101e05,(%esp)
f010024d:	e8 49 08 00 00       	call   f0100a9b <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f0100252:	c7 44 24 08 00 fc ff 	movl   $0xfffffc00,0x8(%esp)
f0100259:	ff 
f010025a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
f0100261:	00 
f0100262:	c7 04 24 11 1e 10 f0 	movl   $0xf0101e11,(%esp)
f0100269:	e8 2d 08 00 00       	call   f0100a9b <cprintf>


	// Test the stack backtrace function (lab 1 only)
	test_backtrace(5);
f010026e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f0100275:	e8 6a fe ff ff       	call   f01000e4 <test_backtrace>

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
f010027a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100281:	e8 95 06 00 00       	call   f010091b <monitor>
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
f010052a:	e8 d6 13 00 00       	call   f0101905 <memmove>
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
f0100676:	c7 04 24 7e 1e 10 f0 	movl   $0xf0101e7e,(%esp)
f010067d:	e8 19 04 00 00       	call   f0100a9b <cprintf>
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
f01006d1:	0f b6 80 c0 1e 10 f0 	movzbl -0xfefe140(%eax),%eax
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
f010070c:	0f b6 90 c0 1e 10 f0 	movzbl -0xfefe140(%eax),%edx
f0100713:	0b 15 20 33 11 f0    	or     0xf0113320,%edx
f0100719:	0f b6 88 c0 1f 10 f0 	movzbl -0xfefe040(%eax),%ecx
f0100720:	31 ca                	xor    %ecx,%edx
f0100722:	89 15 20 33 11 f0    	mov    %edx,0xf0113320

	c = charcode[shift & (CTL | SHIFT)][data];
f0100728:	89 d1                	mov    %edx,%ecx
f010072a:	83 e1 03             	and    $0x3,%ecx
f010072d:	8b 0c 8d c0 20 10 f0 	mov    -0xfefdf40(,%ecx,4),%ecx
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
f0100766:	c7 04 24 9b 1e 10 f0 	movl   $0xf0101e9b,(%esp)
f010076d:	e8 29 03 00 00       	call   f0100a9b <cprintf>
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
f01007a5:	56                   	push   %esi
f01007a6:	53                   	push   %ebx
f01007a7:	83 ec 20             	sub    $0x20,%esp
	// Your code here.
    uint32_t *pebp;
    int i;
    pebp = (uint32_t*)read_ebp();
f01007aa:	89 eb                	mov    %ebp,%ebx
f01007ac:	be 00 00 00 00       	mov    $0x0,%esi
    //cprintf("pebp:%p %p\n",pebp, pebp+1);
    for(i = 0; i < 7; i++){
    	cprintf("eip %08x  ebp %p  args %08x %08x %08x %08x %08x\n",*(pebp+1), pebp, *(pebp+2), *(pebp+3), *(pebp+4), *(pebp+5), *(pebp+6));
f01007b1:	8b 43 18             	mov    0x18(%ebx),%eax
f01007b4:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f01007b8:	8b 43 14             	mov    0x14(%ebx),%eax
f01007bb:	89 44 24 18          	mov    %eax,0x18(%esp)
f01007bf:	8b 43 10             	mov    0x10(%ebx),%eax
f01007c2:	89 44 24 14          	mov    %eax,0x14(%esp)
f01007c6:	8b 43 0c             	mov    0xc(%ebx),%eax
f01007c9:	89 44 24 10          	mov    %eax,0x10(%esp)
f01007cd:	8b 43 08             	mov    0x8(%ebx),%eax
f01007d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01007d4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f01007d8:	8b 43 04             	mov    0x4(%ebx),%eax
f01007db:	89 44 24 04          	mov    %eax,0x4(%esp)
f01007df:	c7 04 24 d0 20 10 f0 	movl   $0xf01020d0,(%esp)
f01007e6:	e8 b0 02 00 00       	call   f0100a9b <cprintf>
	pebp = (uint32_t*)*(pebp);
f01007eb:	8b 1b                	mov    (%ebx),%ebx
	// Your code here.
    uint32_t *pebp;
    int i;
    pebp = (uint32_t*)read_ebp();
    //cprintf("pebp:%p %p\n",pebp, pebp+1);
    for(i = 0; i < 7; i++){
f01007ed:	83 c6 01             	add    $0x1,%esi
f01007f0:	83 fe 07             	cmp    $0x7,%esi
f01007f3:	75 bc                	jne    f01007b1 <mon_backtrace+0xf>
    	cprintf("eip %08x  ebp %p  args %08x %08x %08x %08x %08x\n",*(pebp+1), pebp, *(pebp+2), *(pebp+3), *(pebp+4), *(pebp+5), *(pebp+6));
	pebp = (uint32_t*)*(pebp);
    }
    overflow_me();
    cprintf("Backtrace success\n");
f01007f5:	c7 04 24 31 22 10 f0 	movl   $0xf0102231,(%esp)
f01007fc:	e8 9a 02 00 00       	call   f0100a9b <cprintf>
	return 0;
}
f0100801:	b8 00 00 00 00       	mov    $0x0,%eax
f0100806:	83 c4 20             	add    $0x20,%esp
f0100809:	5b                   	pop    %ebx
f010080a:	5e                   	pop    %esi
f010080b:	5d                   	pop    %ebp
f010080c:	c3                   	ret    

f010080d <do_overflow>:
    return pretaddr;
}

void
do_overflow(void)
{
f010080d:	55                   	push   %ebp
f010080e:	89 e5                	mov    %esp,%ebp
f0100810:	83 ec 18             	sub    $0x18,%esp
    cprintf("Overflow success\n");
f0100813:	c7 04 24 44 22 10 f0 	movl   $0xf0102244,(%esp)
f010081a:	e8 7c 02 00 00       	call   f0100a9b <cprintf>
}
f010081f:	c9                   	leave  
f0100820:	c3                   	ret    

f0100821 <mon_kerninfo>:
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100821:	55                   	push   %ebp
f0100822:	89 e5                	mov    %esp,%ebp
f0100824:	83 ec 18             	sub    $0x18,%esp
	extern char entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100827:	c7 04 24 56 22 10 f0 	movl   $0xf0102256,(%esp)
f010082e:	e8 68 02 00 00       	call   f0100a9b <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100833:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f010083a:	00 
f010083b:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f0100842:	f0 
f0100843:	c7 04 24 04 21 10 f0 	movl   $0xf0102104,(%esp)
f010084a:	e8 4c 02 00 00       	call   f0100a9b <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f010084f:	c7 44 24 08 75 1d 10 	movl   $0x101d75,0x8(%esp)
f0100856:	00 
f0100857:	c7 44 24 04 75 1d 10 	movl   $0xf0101d75,0x4(%esp)
f010085e:	f0 
f010085f:	c7 04 24 28 21 10 f0 	movl   $0xf0102128,(%esp)
f0100866:	e8 30 02 00 00       	call   f0100a9b <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010086b:	c7 44 24 08 00 33 11 	movl   $0x113300,0x8(%esp)
f0100872:	00 
f0100873:	c7 44 24 04 00 33 11 	movl   $0xf0113300,0x4(%esp)
f010087a:	f0 
f010087b:	c7 04 24 4c 21 10 f0 	movl   $0xf010214c,(%esp)
f0100882:	e8 14 02 00 00       	call   f0100a9b <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100887:	c7 44 24 08 60 39 11 	movl   $0x113960,0x8(%esp)
f010088e:	00 
f010088f:	c7 44 24 04 60 39 11 	movl   $0xf0113960,0x4(%esp)
f0100896:	f0 
f0100897:	c7 04 24 70 21 10 f0 	movl   $0xf0102170,(%esp)
f010089e:	e8 f8 01 00 00       	call   f0100a9b <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008a3:	b8 5f 3d 11 f0       	mov    $0xf0113d5f,%eax
f01008a8:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f01008ad:	89 c2                	mov    %eax,%edx
f01008af:	c1 fa 1f             	sar    $0x1f,%edx
f01008b2:	c1 ea 16             	shr    $0x16,%edx
f01008b5:	8d 04 02             	lea    (%edx,%eax,1),%eax
f01008b8:	c1 f8 0a             	sar    $0xa,%eax
f01008bb:	89 44 24 04          	mov    %eax,0x4(%esp)
f01008bf:	c7 04 24 94 21 10 f0 	movl   $0xf0102194,(%esp)
f01008c6:	e8 d0 01 00 00       	call   f0100a9b <cprintf>
		(end-entry+1023)/1024);
	return 0;
}
f01008cb:	b8 00 00 00 00       	mov    $0x0,%eax
f01008d0:	c9                   	leave  
f01008d1:	c3                   	ret    

f01008d2 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01008d2:	55                   	push   %ebp
f01008d3:	89 e5                	mov    %esp,%ebp
f01008d5:	83 ec 18             	sub    $0x18,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01008d8:	a1 e4 22 10 f0       	mov    0xf01022e4,%eax
f01008dd:	89 44 24 08          	mov    %eax,0x8(%esp)
f01008e1:	a1 e0 22 10 f0       	mov    0xf01022e0,%eax
f01008e6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01008ea:	c7 04 24 6f 22 10 f0 	movl   $0xf010226f,(%esp)
f01008f1:	e8 a5 01 00 00       	call   f0100a9b <cprintf>
f01008f6:	a1 f0 22 10 f0       	mov    0xf01022f0,%eax
f01008fb:	89 44 24 08          	mov    %eax,0x8(%esp)
f01008ff:	a1 ec 22 10 f0       	mov    0xf01022ec,%eax
f0100904:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100908:	c7 04 24 6f 22 10 f0 	movl   $0xf010226f,(%esp)
f010090f:	e8 87 01 00 00       	call   f0100a9b <cprintf>
	return 0;
}
f0100914:	b8 00 00 00 00       	mov    $0x0,%eax
f0100919:	c9                   	leave  
f010091a:	c3                   	ret    

f010091b <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f010091b:	55                   	push   %ebp
f010091c:	89 e5                	mov    %esp,%ebp
f010091e:	57                   	push   %edi
f010091f:	56                   	push   %esi
f0100920:	53                   	push   %ebx
f0100921:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100924:	c7 04 24 c0 21 10 f0 	movl   $0xf01021c0,(%esp)
f010092b:	e8 6b 01 00 00       	call   f0100a9b <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100930:	c7 04 24 e4 21 10 f0 	movl   $0xf01021e4,(%esp)
f0100937:	e8 5f 01 00 00       	call   f0100a9b <cprintf>

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f010093c:	bf e0 22 10 f0       	mov    $0xf01022e0,%edi
	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");


	while (1) {
		buf = readline("K> ");
f0100941:	c7 04 24 78 22 10 f0 	movl   $0xf0102278,(%esp)
f0100948:	e8 d3 0c 00 00       	call   f0101620 <readline>
f010094d:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f010094f:	85 c0                	test   %eax,%eax
f0100951:	74 ee                	je     f0100941 <monitor+0x26>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100953:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
f010095a:	be 00 00 00 00       	mov    $0x0,%esi
f010095f:	eb 06                	jmp    f0100967 <monitor+0x4c>
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f0100961:	c6 03 00             	movb   $0x0,(%ebx)
f0100964:	83 c3 01             	add    $0x1,%ebx
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100967:	0f b6 03             	movzbl (%ebx),%eax
f010096a:	84 c0                	test   %al,%al
f010096c:	74 6d                	je     f01009db <monitor+0xc0>
f010096e:	0f be c0             	movsbl %al,%eax
f0100971:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100975:	c7 04 24 7c 22 10 f0 	movl   $0xf010227c,(%esp)
f010097c:	e8 cd 0e 00 00       	call   f010184e <strchr>
f0100981:	85 c0                	test   %eax,%eax
f0100983:	75 dc                	jne    f0100961 <monitor+0x46>
			*buf++ = 0;
		if (*buf == 0)
f0100985:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100988:	74 51                	je     f01009db <monitor+0xc0>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f010098a:	83 fe 0f             	cmp    $0xf,%esi
f010098d:	8d 76 00             	lea    0x0(%esi),%esi
f0100990:	75 16                	jne    f01009a8 <monitor+0x8d>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100992:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f0100999:	00 
f010099a:	c7 04 24 81 22 10 f0 	movl   $0xf0102281,(%esp)
f01009a1:	e8 f5 00 00 00       	call   f0100a9b <cprintf>
f01009a6:	eb 99                	jmp    f0100941 <monitor+0x26>
			return 0;
		}
		argv[argc++] = buf;
f01009a8:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f01009ac:	83 c6 01             	add    $0x1,%esi
		while (*buf && !strchr(WHITESPACE, *buf))
f01009af:	0f b6 03             	movzbl (%ebx),%eax
f01009b2:	84 c0                	test   %al,%al
f01009b4:	75 0c                	jne    f01009c2 <monitor+0xa7>
f01009b6:	eb af                	jmp    f0100967 <monitor+0x4c>
			buf++;
f01009b8:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f01009bb:	0f b6 03             	movzbl (%ebx),%eax
f01009be:	84 c0                	test   %al,%al
f01009c0:	74 a5                	je     f0100967 <monitor+0x4c>
f01009c2:	0f be c0             	movsbl %al,%eax
f01009c5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009c9:	c7 04 24 7c 22 10 f0 	movl   $0xf010227c,(%esp)
f01009d0:	e8 79 0e 00 00       	call   f010184e <strchr>
f01009d5:	85 c0                	test   %eax,%eax
f01009d7:	74 df                	je     f01009b8 <monitor+0x9d>
f01009d9:	eb 8c                	jmp    f0100967 <monitor+0x4c>
			buf++;
	}
	argv[argc] = 0;
f01009db:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01009e2:	00 

	// Lookup and invoke the command
	if (argc == 0)
f01009e3:	85 f6                	test   %esi,%esi
f01009e5:	0f 84 56 ff ff ff    	je     f0100941 <monitor+0x26>
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f01009eb:	8b 07                	mov    (%edi),%eax
f01009ed:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009f1:	8b 45 a8             	mov    -0x58(%ebp),%eax
f01009f4:	89 04 24             	mov    %eax,(%esp)
f01009f7:	e8 dd 0d 00 00       	call   f01017d9 <strcmp>
f01009fc:	ba 00 00 00 00       	mov    $0x0,%edx
f0100a01:	85 c0                	test   %eax,%eax
f0100a03:	74 1d                	je     f0100a22 <monitor+0x107>
f0100a05:	a1 ec 22 10 f0       	mov    0xf01022ec,%eax
f0100a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a0e:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100a11:	89 04 24             	mov    %eax,(%esp)
f0100a14:	e8 c0 0d 00 00       	call   f01017d9 <strcmp>
f0100a19:	85 c0                	test   %eax,%eax
f0100a1b:	75 28                	jne    f0100a45 <monitor+0x12a>
f0100a1d:	ba 01 00 00 00       	mov    $0x1,%edx
			return commands[i].func(argc, argv, tf);
f0100a22:	6b d2 0c             	imul   $0xc,%edx,%edx
f0100a25:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a28:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100a2c:	8d 45 a8             	lea    -0x58(%ebp),%eax
f0100a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a33:	89 34 24             	mov    %esi,(%esp)
f0100a36:	ff 92 e8 22 10 f0    	call   *-0xfefdd18(%edx)


	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f0100a3c:	85 c0                	test   %eax,%eax
f0100a3e:	78 1d                	js     f0100a5d <monitor+0x142>
f0100a40:	e9 fc fe ff ff       	jmp    f0100941 <monitor+0x26>
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100a45:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100a48:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a4c:	c7 04 24 9e 22 10 f0 	movl   $0xf010229e,(%esp)
f0100a53:	e8 43 00 00 00       	call   f0100a9b <cprintf>
f0100a58:	e9 e4 fe ff ff       	jmp    f0100941 <monitor+0x26>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f0100a5d:	83 c4 5c             	add    $0x5c,%esp
f0100a60:	5b                   	pop    %ebx
f0100a61:	5e                   	pop    %esi
f0100a62:	5f                   	pop    %edi
f0100a63:	5d                   	pop    %ebp
f0100a64:	c3                   	ret    
f0100a65:	00 00                	add    %al,(%eax)
	...

f0100a68 <vcprintf>:
    (*cnt)++;
}

int
vcprintf(const char *fmt, va_list ap)
{
f0100a68:	55                   	push   %ebp
f0100a69:	89 e5                	mov    %esp,%ebp
f0100a6b:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f0100a6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);// ap:store the argument inputed by user.
f0100a75:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100a78:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100a7c:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a7f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100a83:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100a86:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a8a:	c7 04 24 b5 0a 10 f0 	movl   $0xf0100ab5,(%esp)
f0100a91:	e8 51 06 00 00       	call   f01010e7 <vprintfmt>
	return cnt;
}
f0100a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100a99:	c9                   	leave  
f0100a9a:	c3                   	ret    

f0100a9b <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0100a9b:	55                   	push   %ebp
f0100a9c:	89 e5                	mov    %esp,%ebp
f0100a9e:	83 ec 18             	sub    $0x18,%esp
	vprintfmt((void*)putch, &cnt, fmt, ap);// ap:store the argument inputed by user.
	return cnt;
}

int
cprintf(const char *fmt, ...)
f0100aa1:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
f0100aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100aa8:	8b 45 08             	mov    0x8(%ebp),%eax
f0100aab:	89 04 24             	mov    %eax,(%esp)
f0100aae:	e8 b5 ff ff ff       	call   f0100a68 <vcprintf>
	
	va_end(ap);
	return cnt;
}
f0100ab3:	c9                   	leave  
f0100ab4:	c3                   	ret    

f0100ab5 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0100ab5:	55                   	push   %ebp
f0100ab6:	89 e5                	mov    %esp,%ebp
f0100ab8:	53                   	push   %ebx
f0100ab9:	83 ec 14             	sub    $0x14,%esp
f0100abc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f0100abf:	8b 45 08             	mov    0x8(%ebp),%eax
f0100ac2:	89 04 24             	mov    %eax,(%esp)
f0100ac5:	e8 c0 fa ff ff       	call   f010058a <cputchar>
    (*cnt)++;
f0100aca:	83 03 01             	addl   $0x1,(%ebx)
}
f0100acd:	83 c4 14             	add    $0x14,%esp
f0100ad0:	5b                   	pop    %ebx
f0100ad1:	5d                   	pop    %ebp
f0100ad2:	c3                   	ret    
	...

f0100ae0 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0100ae0:	55                   	push   %ebp
f0100ae1:	89 e5                	mov    %esp,%ebp
f0100ae3:	57                   	push   %edi
f0100ae4:	56                   	push   %esi
f0100ae5:	53                   	push   %ebx
f0100ae6:	83 ec 14             	sub    $0x14,%esp
f0100ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100aec:	89 55 e8             	mov    %edx,-0x18(%ebp)
f0100aef:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0100af2:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0100af5:	8b 1a                	mov    (%edx),%ebx
f0100af7:	8b 01                	mov    (%ecx),%eax
f0100af9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	while (l <= r) {
f0100afc:	39 c3                	cmp    %eax,%ebx
f0100afe:	0f 8f 9c 00 00 00    	jg     f0100ba0 <stab_binsearch+0xc0>
f0100b04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		int true_m = (l + r) / 2, m = true_m;
f0100b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0100b0e:	01 d8                	add    %ebx,%eax
f0100b10:	89 c7                	mov    %eax,%edi
f0100b12:	c1 ef 1f             	shr    $0x1f,%edi
f0100b15:	01 c7                	add    %eax,%edi
f0100b17:	d1 ff                	sar    %edi
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0100b19:	39 df                	cmp    %ebx,%edi
f0100b1b:	7c 33                	jl     f0100b50 <stab_binsearch+0x70>
f0100b1d:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100b20:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0100b23:	0f b6 44 82 04       	movzbl 0x4(%edx,%eax,4),%eax
f0100b28:	39 f0                	cmp    %esi,%eax
f0100b2a:	0f 84 bc 00 00 00    	je     f0100bec <stab_binsearch+0x10c>
f0100b30:	8d 44 7f fd          	lea    -0x3(%edi,%edi,2),%eax
f0100b34:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx
f0100b38:	89 f8                	mov    %edi,%eax
			m--;
f0100b3a:	83 e8 01             	sub    $0x1,%eax
	
	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0100b3d:	39 d8                	cmp    %ebx,%eax
f0100b3f:	7c 0f                	jl     f0100b50 <stab_binsearch+0x70>
f0100b41:	0f b6 0a             	movzbl (%edx),%ecx
f0100b44:	83 ea 0c             	sub    $0xc,%edx
f0100b47:	39 f1                	cmp    %esi,%ecx
f0100b49:	75 ef                	jne    f0100b3a <stab_binsearch+0x5a>
f0100b4b:	e9 9e 00 00 00       	jmp    f0100bee <stab_binsearch+0x10e>
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0100b50:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0100b53:	eb 3c                	jmp    f0100b91 <stab_binsearch+0xb1>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
f0100b55:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0100b58:	89 01                	mov    %eax,(%ecx)
			l = true_m + 1;
f0100b5a:	8d 5f 01             	lea    0x1(%edi),%ebx
f0100b5d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0100b64:	eb 2b                	jmp    f0100b91 <stab_binsearch+0xb1>
		} else if (stabs[m].n_value > addr) {
f0100b66:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100b69:	76 14                	jbe    f0100b7f <stab_binsearch+0x9f>
			*region_right = m - 1;
f0100b6b:	83 e8 01             	sub    $0x1,%eax
f0100b6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0100b71:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0100b74:	89 02                	mov    %eax,(%edx)
f0100b76:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0100b7d:	eb 12                	jmp    f0100b91 <stab_binsearch+0xb1>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0100b7f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0100b82:	89 01                	mov    %eax,(%ecx)
			l = m;
			addr++;
f0100b84:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0100b88:	89 c3                	mov    %eax,%ebx
f0100b8a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;
	
	while (l <= r) {
f0100b91:	39 5d ec             	cmp    %ebx,-0x14(%ebp)
f0100b94:	0f 8d 71 ff ff ff    	jge    f0100b0b <stab_binsearch+0x2b>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f0100b9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0100b9e:	75 0f                	jne    f0100baf <stab_binsearch+0xcf>
		*region_right = *region_left - 1;
f0100ba0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0100ba3:	8b 03                	mov    (%ebx),%eax
f0100ba5:	83 e8 01             	sub    $0x1,%eax
f0100ba8:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0100bab:	89 02                	mov    %eax,(%edx)
f0100bad:	eb 57                	jmp    f0100c06 <stab_binsearch+0x126>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100baf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0100bb2:	8b 01                	mov    (%ecx),%eax
		     l > *region_left && stabs[l].n_type != type;
f0100bb4:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0100bb7:	8b 0b                	mov    (%ebx),%ecx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100bb9:	39 c1                	cmp    %eax,%ecx
f0100bbb:	7d 28                	jge    f0100be5 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f0100bbd:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100bc0:	8b 5d f0             	mov    -0x10(%ebp),%ebx
f0100bc3:	0f b6 54 93 04       	movzbl 0x4(%ebx,%edx,4),%edx
f0100bc8:	39 f2                	cmp    %esi,%edx
f0100bca:	74 19                	je     f0100be5 <stab_binsearch+0x105>
f0100bcc:	8d 54 40 fd          	lea    -0x3(%eax,%eax,2),%edx
f0100bd0:	8d 54 93 04          	lea    0x4(%ebx,%edx,4),%edx
		     l--)
f0100bd4:	83 e8 01             	sub    $0x1,%eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100bd7:	39 c1                	cmp    %eax,%ecx
f0100bd9:	7d 0a                	jge    f0100be5 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f0100bdb:	0f b6 1a             	movzbl (%edx),%ebx
f0100bde:	83 ea 0c             	sub    $0xc,%edx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0100be1:	39 f3                	cmp    %esi,%ebx
f0100be3:	75 ef                	jne    f0100bd4 <stab_binsearch+0xf4>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
f0100be5:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0100be8:	89 02                	mov    %eax,(%edx)
f0100bea:	eb 1a                	jmp    f0100c06 <stab_binsearch+0x126>
	}
}
f0100bec:	89 f8                	mov    %edi,%eax
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0100bee:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100bf1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0100bf4:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0100bf8:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100bfb:	0f 82 54 ff ff ff    	jb     f0100b55 <stab_binsearch+0x75>
f0100c01:	e9 60 ff ff ff       	jmp    f0100b66 <stab_binsearch+0x86>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0100c06:	83 c4 14             	add    $0x14,%esp
f0100c09:	5b                   	pop    %ebx
f0100c0a:	5e                   	pop    %esi
f0100c0b:	5f                   	pop    %edi
f0100c0c:	5d                   	pop    %ebp
f0100c0d:	c3                   	ret    

f0100c0e <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0100c0e:	55                   	push   %ebp
f0100c0f:	89 e5                	mov    %esp,%ebp
f0100c11:	83 ec 28             	sub    $0x28,%esp
f0100c14:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0100c17:	89 75 fc             	mov    %esi,-0x4(%ebp)
f0100c1a:	8b 75 08             	mov    0x8(%ebp),%esi
f0100c1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0100c20:	c7 03 f8 22 10 f0    	movl   $0xf01022f8,(%ebx)
	info->eip_line = 0;
f0100c26:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0100c2d:	c7 43 08 f8 22 10 f0 	movl   $0xf01022f8,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0100c34:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0100c3b:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0100c3e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0100c45:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0100c4b:	76 12                	jbe    f0100c5f <debuginfo_eip+0x51>
		// Can't search for user-level addresses yet!
  	        panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100c4d:	b8 52 80 10 f0       	mov    $0xf0108052,%eax
f0100c52:	3d f5 64 10 f0       	cmp    $0xf01064f5,%eax
f0100c57:	0f 86 53 01 00 00    	jbe    f0100db0 <debuginfo_eip+0x1a2>
f0100c5d:	eb 1c                	jmp    f0100c7b <debuginfo_eip+0x6d>
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
	} else {
		// Can't search for user-level addresses yet!
  	        panic("User address");
f0100c5f:	c7 44 24 08 02 23 10 	movl   $0xf0102302,0x8(%esp)
f0100c66:	f0 
f0100c67:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
f0100c6e:	00 
f0100c6f:	c7 04 24 0f 23 10 f0 	movl   $0xf010230f,(%esp)
f0100c76:	e8 0a f4 ff ff       	call   f0100085 <_panic>
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100c7b:	80 3d 51 80 10 f0 00 	cmpb   $0x0,0xf0108051
f0100c82:	0f 85 28 01 00 00    	jne    f0100db0 <debuginfo_eip+0x1a2>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.
	
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0100c88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	rfile = (stab_end - stabs) - 1;
f0100c8f:	b8 f4 64 10 f0       	mov    $0xf01064f4,%eax
f0100c94:	2d ac 25 10 f0       	sub    $0xf01025ac,%eax
f0100c99:	c1 f8 02             	sar    $0x2,%eax
f0100c9c:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0100ca2:	83 e8 01             	sub    $0x1,%eax
f0100ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0100ca8:	8d 4d f0             	lea    -0x10(%ebp),%ecx
f0100cab:	8d 55 f4             	lea    -0xc(%ebp),%edx
f0100cae:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100cb2:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0100cb9:	b8 ac 25 10 f0       	mov    $0xf01025ac,%eax
f0100cbe:	e8 1d fe ff ff       	call   f0100ae0 <stab_binsearch>
	if (lfile == 0)
f0100cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100cc6:	85 c0                	test   %eax,%eax
f0100cc8:	0f 84 e2 00 00 00    	je     f0100db0 <debuginfo_eip+0x1a2>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0100cce:	89 45 ec             	mov    %eax,-0x14(%ebp)
	rfun = rfile;
f0100cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100cd4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0100cd7:	8d 4d e8             	lea    -0x18(%ebp),%ecx
f0100cda:	8d 55 ec             	lea    -0x14(%ebp),%edx
f0100cdd:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100ce1:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0100ce8:	b8 ac 25 10 f0       	mov    $0xf01025ac,%eax
f0100ced:	e8 ee fd ff ff       	call   f0100ae0 <stab_binsearch>

	if (lfun <= rfun) {
f0100cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0100cf5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
f0100cf8:	7f 31                	jg     f0100d2b <debuginfo_eip+0x11d>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0100cfa:	6b c0 0c             	imul   $0xc,%eax,%eax
f0100cfd:	8b 80 ac 25 10 f0    	mov    -0xfefda54(%eax),%eax
f0100d03:	ba 52 80 10 f0       	mov    $0xf0108052,%edx
f0100d08:	81 ea f5 64 10 f0    	sub    $0xf01064f5,%edx
f0100d0e:	39 d0                	cmp    %edx,%eax
f0100d10:	73 08                	jae    f0100d1a <debuginfo_eip+0x10c>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0100d12:	05 f5 64 10 f0       	add    $0xf01064f5,%eax
f0100d17:	89 43 08             	mov    %eax,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0100d1a:	8b 75 ec             	mov    -0x14(%ebp),%esi
f0100d1d:	6b c6 0c             	imul   $0xc,%esi,%eax
f0100d20:	8b 80 b4 25 10 f0    	mov    -0xfefda4c(%eax),%eax
f0100d26:	89 43 10             	mov    %eax,0x10(%ebx)
f0100d29:	eb 06                	jmp    f0100d31 <debuginfo_eip+0x123>
		lline = lfun;
		rline = rfun;
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f0100d2b:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f0100d2e:	8b 75 f4             	mov    -0xc(%ebp),%esi
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0100d31:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f0100d38:	00 
f0100d39:	8b 43 08             	mov    0x8(%ebx),%eax
f0100d3c:	89 04 24             	mov    %eax,(%esp)
f0100d3f:	e8 37 0b 00 00       	call   f010187b <strfind>
f0100d44:	2b 43 08             	sub    0x8(%ebx),%eax
f0100d47:	89 43 0c             	mov    %eax,0xc(%ebx)
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
f0100d4a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
f0100d4d:	6b c6 0c             	imul   $0xc,%esi,%eax
f0100d50:	05 b4 25 10 f0       	add    $0xf01025b4,%eax
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100d55:	eb 06                	jmp    f0100d5d <debuginfo_eip+0x14f>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f0100d57:	83 ee 01             	sub    $0x1,%esi
f0100d5a:	83 e8 0c             	sub    $0xc,%eax
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100d5d:	39 ce                	cmp    %ecx,%esi
f0100d5f:	7c 20                	jl     f0100d81 <debuginfo_eip+0x173>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0100d61:	0f b6 50 fc          	movzbl -0x4(%eax),%edx
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100d65:	80 fa 84             	cmp    $0x84,%dl
f0100d68:	74 5c                	je     f0100dc6 <debuginfo_eip+0x1b8>
f0100d6a:	80 fa 64             	cmp    $0x64,%dl
f0100d6d:	75 e8                	jne    f0100d57 <debuginfo_eip+0x149>
f0100d6f:	83 38 00             	cmpl   $0x0,(%eax)
f0100d72:	74 e3                	je     f0100d57 <debuginfo_eip+0x149>
f0100d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0100d78:	eb 4c                	jmp    f0100dc6 <debuginfo_eip+0x1b8>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
		info->eip_file = stabstr + stabs[lline].n_strx;
f0100d7a:	05 f5 64 10 f0       	add    $0xf01064f5,%eax
f0100d7f:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0100d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0100d84:	3b 45 e8             	cmp    -0x18(%ebp),%eax
f0100d87:	7d 2e                	jge    f0100db7 <debuginfo_eip+0x1a9>
		for (lline = lfun + 1;
f0100d89:	83 c0 01             	add    $0x1,%eax
f0100d8c:	6b d0 0c             	imul   $0xc,%eax,%edx
f0100d8f:	81 c2 b0 25 10 f0    	add    $0xf01025b0,%edx
f0100d95:	eb 07                	jmp    f0100d9e <debuginfo_eip+0x190>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f0100d97:	83 43 14 01          	addl   $0x1,0x14(%ebx)
	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
f0100d9b:	83 c0 01             	add    $0x1,%eax


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0100d9e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
f0100da1:	7d 14                	jge    f0100db7 <debuginfo_eip+0x1a9>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100da3:	0f b6 0a             	movzbl (%edx),%ecx
f0100da6:	83 c2 0c             	add    $0xc,%edx


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0100da9:	80 f9 a0             	cmp    $0xa0,%cl
f0100dac:	74 e9                	je     f0100d97 <debuginfo_eip+0x189>
f0100dae:	eb 07                	jmp    f0100db7 <debuginfo_eip+0x1a9>
f0100db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100db5:	eb 05                	jmp    f0100dbc <debuginfo_eip+0x1ae>
f0100db7:	b8 00 00 00 00       	mov    $0x0,%eax
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
	
	return 0;
}
f0100dbc:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0100dbf:	8b 75 fc             	mov    -0x4(%ebp),%esi
f0100dc2:	89 ec                	mov    %ebp,%esp
f0100dc4:	5d                   	pop    %ebp
f0100dc5:	c3                   	ret    
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0100dc6:	6b f6 0c             	imul   $0xc,%esi,%esi
f0100dc9:	8b 86 ac 25 10 f0    	mov    -0xfefda54(%esi),%eax
f0100dcf:	ba 52 80 10 f0       	mov    $0xf0108052,%edx
f0100dd4:	81 ea f5 64 10 f0    	sub    $0xf01064f5,%edx
f0100dda:	39 d0                	cmp    %edx,%eax
f0100ddc:	72 9c                	jb     f0100d7a <debuginfo_eip+0x16c>
f0100dde:	eb a1                	jmp    f0100d81 <debuginfo_eip+0x173>

f0100de0 <printnum_width>:
};
//left justified 
static void
printnum_width(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc,int *pamnt,int *pcount)
{
f0100de0:	55                   	push   %ebp
f0100de1:	89 e5                	mov    %esp,%ebp
f0100de3:	57                   	push   %edi
f0100de4:	56                   	push   %esi
f0100de5:	53                   	push   %ebx
f0100de6:	83 ec 4c             	sub    $0x4c,%esp
f0100de9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0100dec:	89 d7                	mov    %edx,%edi
f0100dee:	8b 45 08             	mov    0x8(%ebp),%eax
f0100df1:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100df4:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100df7:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100dfa:	8b 45 10             	mov    0x10(%ebp),%eax
		int i;
		if(num >= base){
f0100dfd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100e00:	be 00 00 00 00       	mov    $0x0,%esi
f0100e05:	39 d6                	cmp    %edx,%esi
f0100e07:	72 07                	jb     f0100e10 <printnum_width+0x30>
f0100e09:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100e0c:	39 c8                	cmp    %ecx,%eax
f0100e0e:	77 70                	ja     f0100e80 <printnum_width+0xa0>
			(*pcount)++;
f0100e10:	8b 5d 20             	mov    0x20(%ebp),%ebx
f0100e13:	83 03 01             	addl   $0x1,(%ebx)
			printnum_width(putch, putdat, num / base, base, width - 1, padc, pamnt, pcount);//num/base is used to print the least significant digit
f0100e16:	89 5c 24 18          	mov    %ebx,0x18(%esp)
f0100e1a:	8b 55 1c             	mov    0x1c(%ebp),%edx
f0100e1d:	89 54 24 14          	mov    %edx,0x14(%esp)
f0100e21:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0100e24:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0100e28:	8b 55 14             	mov    0x14(%ebp),%edx
f0100e2b:	83 ea 01             	sub    $0x1,%edx
f0100e2e:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100e32:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100e36:	8b 44 24 08          	mov    0x8(%esp),%eax
f0100e3a:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0100e3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100e41:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0100e44:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100e47:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100e4b:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0100e4f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100e52:	89 0c 24             	mov    %ecx,(%esp)
f0100e55:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100e58:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100e5c:	e8 af 0c 00 00       	call   f0101b10 <__udivdi3>
f0100e61:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0100e64:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0100e67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0100e6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0100e6f:	89 04 24             	mov    %eax,(%esp)
f0100e72:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100e76:	89 fa                	mov    %edi,%edx
f0100e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e7b:	e8 60 ff ff ff       	call   f0100de0 <printnum_width>
		}
		putch("0123456789abcdef"[num % base], putdat);
f0100e80:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100e84:	8b 04 24             	mov    (%esp),%eax
f0100e87:	8b 54 24 04          	mov    0x4(%esp),%edx
f0100e8b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100e8e:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0100e91:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100e94:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100e98:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0100e9c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100e9f:	89 0c 24             	mov    %ecx,(%esp)
f0100ea2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100ea5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100ea9:	e8 92 0d 00 00       	call   f0101c40 <__umoddi3>
f0100eae:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0100eb1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0100eb5:	0f be 80 1d 23 10 f0 	movsbl -0xfefdce3(%eax),%eax
f0100ebc:	89 04 24             	mov    %eax,(%esp)
f0100ebf:	ff 55 e4             	call   *-0x1c(%ebp)
		(*pamnt)++;//record the times of print operation
f0100ec2:	8b 4d 1c             	mov    0x1c(%ebp),%ecx
f0100ec5:	8b 01                	mov    (%ecx),%eax
f0100ec7:	83 c0 01             	add    $0x1,%eax
f0100eca:	89 01                	mov    %eax,(%ecx)
		if( *pamnt == (*pcount + 1) ){
f0100ecc:	8b 5d 20             	mov    0x20(%ebp),%ebx
f0100ecf:	8b 13                	mov    (%ebx),%edx
f0100ed1:	83 c2 01             	add    $0x1,%edx
f0100ed4:	39 d0                	cmp    %edx,%eax
f0100ed6:	75 2e                	jne    f0100f06 <printnum_width+0x126>
			if( width > *pamnt ){
f0100ed8:	39 45 14             	cmp    %eax,0x14(%ebp)
f0100edb:	7e 29                	jle    f0100f06 <printnum_width+0x126>
				for( i = 0; i < width - *pamnt;  i++){
f0100edd:	8b 55 14             	mov    0x14(%ebp),%edx
f0100ee0:	29 c2                	sub    %eax,%edx
f0100ee2:	85 d2                	test   %edx,%edx
f0100ee4:	7e 20                	jle    f0100f06 <printnum_width+0x126>
f0100ee6:	be 00 00 00 00       	mov    $0x0,%esi
f0100eeb:	89 cb                	mov    %ecx,%ebx
					putch(padc, putdat);
f0100eed:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100ef1:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0100ef4:	89 0c 24             	mov    %ecx,(%esp)
f0100ef7:	ff 55 e4             	call   *-0x1c(%ebp)
		}
		putch("0123456789abcdef"[num % base], putdat);
		(*pamnt)++;//record the times of print operation
		if( *pamnt == (*pcount + 1) ){
			if( width > *pamnt ){
				for( i = 0; i < width - *pamnt;  i++){
f0100efa:	83 c6 01             	add    $0x1,%esi
f0100efd:	8b 45 14             	mov    0x14(%ebp),%eax
f0100f00:	2b 03                	sub    (%ebx),%eax
f0100f02:	39 f0                	cmp    %esi,%eax
f0100f04:	7f e7                	jg     f0100eed <printnum_width+0x10d>
					putch(padc, putdat);
				}	
			}
        	}
		return;
}
f0100f06:	83 c4 4c             	add    $0x4c,%esp
f0100f09:	5b                   	pop    %ebx
f0100f0a:	5e                   	pop    %esi
f0100f0b:	5f                   	pop    %edi
f0100f0c:	5d                   	pop    %ebp
f0100f0d:	c3                   	ret    

f0100f0e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0100f0e:	55                   	push   %ebp
f0100f0f:	89 e5                	mov    %esp,%ebp
f0100f11:	57                   	push   %edi
f0100f12:	56                   	push   %esi
f0100f13:	53                   	push   %ebx
f0100f14:	83 ec 5c             	sub    $0x5c,%esp
f0100f17:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100f1a:	89 d6                	mov    %edx,%esi
f0100f1c:	8b 45 08             	mov    0x8(%ebp),%eax
f0100f1f:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100f22:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100f25:	89 55 d0             	mov    %edx,-0x30(%ebp)
f0100f28:	8b 55 10             	mov    0x10(%ebp),%edx
f0100f2b:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0100f2e:	8b 7d 18             	mov    0x18(%ebp),%edi
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	int amnt = 0, count = 0; 
f0100f31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0100f38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	if( padc != '0'){
f0100f3f:	83 ff 30             	cmp    $0x30,%edi
f0100f42:	74 42                	je     f0100f86 <printnum+0x78>
		if( 9 > width && width > 0 ){
f0100f44:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0100f47:	83 f8 07             	cmp    $0x7,%eax
f0100f4a:	77 3a                	ja     f0100f86 <printnum+0x78>
			padc = ' ';
			printnum_width(putch, putdat, num, base, width, padc, &amnt, &count);
f0100f4c:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0100f4f:	89 44 24 18          	mov    %eax,0x18(%esp)
f0100f53:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0100f56:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100f5a:	c7 44 24 10 20 00 00 	movl   $0x20,0x10(%esp)
f0100f61:	00 
f0100f62:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0100f66:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100f6a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0100f6d:	89 0c 24             	mov    %ecx,(%esp)
f0100f70:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0100f73:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100f77:	89 f2                	mov    %esi,%edx
f0100f79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100f7c:	e8 5f fe ff ff       	call   f0100de0 <printnum_width>
			return;
f0100f81:	e9 c8 00 00 00       	jmp    f010104e <printnum+0x140>
		}
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0100f86:	89 55 c8             	mov    %edx,-0x38(%ebp)
f0100f89:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0100f8d:	77 15                	ja     f0100fa4 <printnum+0x96>
f0100f8f:	90                   	nop
f0100f90:	72 05                	jb     f0100f97 <printnum+0x89>
f0100f92:	39 55 cc             	cmp    %edx,-0x34(%ebp)
f0100f95:	73 0d                	jae    f0100fa4 <printnum+0x96>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
f0100f97:	83 eb 01             	sub    $0x1,%ebx
f0100f9a:	85 db                	test   %ebx,%ebx
f0100f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0100fa0:	7f 61                	jg     f0101003 <printnum+0xf5>
f0100fa2:	eb 70                	jmp    f0101014 <printnum+0x106>
			return;
		}
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0100fa4:	89 7c 24 10          	mov    %edi,0x10(%esp)
f0100fa8:	83 eb 01             	sub    $0x1,%ebx
f0100fab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0100faf:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100fb3:	8b 44 24 08          	mov    0x8(%esp),%eax
f0100fb7:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0100fbb:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0100fbe:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0100fc1:	8b 55 c8             	mov    -0x38(%ebp),%edx
f0100fc4:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100fc8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0100fcf:	00 
f0100fd0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0100fd3:	89 0c 24             	mov    %ecx,(%esp)
f0100fd6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0100fd9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100fdd:	e8 2e 0b 00 00       	call   f0101b10 <__udivdi3>
f0100fe2:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0100fe5:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100fe8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0100fec:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0100ff0:	89 04 24             	mov    %eax,(%esp)
f0100ff3:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100ff7:	89 f2                	mov    %esi,%edx
f0100ff9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100ffc:	e8 0d ff ff ff       	call   f0100f0e <printnum>
f0101001:	eb 11                	jmp    f0101014 <printnum+0x106>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
			putch(padc, putdat);
f0101003:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101007:	89 3c 24             	mov    %edi,(%esp)
f010100a:	ff 55 d4             	call   *-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)//-- then compare
f010100d:	83 eb 01             	sub    $0x1,%ebx
f0101010:	85 db                	test   %ebx,%ebx
f0101012:	7f ef                	jg     f0101003 <printnum+0xf5>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit// highest digit
	putch("0123456789abcdef"[num % base], putdat);
f0101014:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101018:	8b 74 24 04          	mov    0x4(%esp),%esi
f010101c:	8b 45 c8             	mov    -0x38(%ebp),%eax
f010101f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101023:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f010102a:	00 
f010102b:	8b 55 cc             	mov    -0x34(%ebp),%edx
f010102e:	89 14 24             	mov    %edx,(%esp)
f0101031:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0101034:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0101038:	e8 03 0c 00 00       	call   f0101c40 <__umoddi3>
f010103d:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101041:	0f be 80 1d 23 10 f0 	movsbl -0xfefdce3(%eax),%eax
f0101048:	89 04 24             	mov    %eax,(%esp)
f010104b:	ff 55 d4             	call   *-0x2c(%ebp)
}
f010104e:	83 c4 5c             	add    $0x5c,%esp
f0101051:	5b                   	pop    %ebx
f0101052:	5e                   	pop    %esi
f0101053:	5f                   	pop    %edi
f0101054:	5d                   	pop    %ebp
f0101055:	c3                   	ret    

f0101056 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f0101056:	55                   	push   %ebp
f0101057:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0101059:	83 fa 01             	cmp    $0x1,%edx
f010105c:	7e 0e                	jle    f010106c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
f010105e:	8b 10                	mov    (%eax),%edx
f0101060:	8d 4a 08             	lea    0x8(%edx),%ecx
f0101063:	89 08                	mov    %ecx,(%eax)
f0101065:	8b 02                	mov    (%edx),%eax
f0101067:	8b 52 04             	mov    0x4(%edx),%edx
f010106a:	eb 22                	jmp    f010108e <getuint+0x38>
	else if (lflag)
f010106c:	85 d2                	test   %edx,%edx
f010106e:	74 10                	je     f0101080 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
f0101070:	8b 10                	mov    (%eax),%edx
f0101072:	8d 4a 04             	lea    0x4(%edx),%ecx
f0101075:	89 08                	mov    %ecx,(%eax)
f0101077:	8b 02                	mov    (%edx),%eax
f0101079:	ba 00 00 00 00       	mov    $0x0,%edx
f010107e:	eb 0e                	jmp    f010108e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
f0101080:	8b 10                	mov    (%eax),%edx
f0101082:	8d 4a 04             	lea    0x4(%edx),%ecx
f0101085:	89 08                	mov    %ecx,(%eax)
f0101087:	8b 02                	mov    (%edx),%eax
f0101089:	ba 00 00 00 00       	mov    $0x0,%edx
}
f010108e:	5d                   	pop    %ebp
f010108f:	c3                   	ret    

f0101090 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
f0101090:	55                   	push   %ebp
f0101091:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0101093:	83 fa 01             	cmp    $0x1,%edx
f0101096:	7e 0e                	jle    f01010a6 <getint+0x16>
		return va_arg(*ap, long long);
f0101098:	8b 10                	mov    (%eax),%edx
f010109a:	8d 4a 08             	lea    0x8(%edx),%ecx
f010109d:	89 08                	mov    %ecx,(%eax)
f010109f:	8b 02                	mov    (%edx),%eax
f01010a1:	8b 52 04             	mov    0x4(%edx),%edx
f01010a4:	eb 22                	jmp    f01010c8 <getint+0x38>
	else if (lflag)
f01010a6:	85 d2                	test   %edx,%edx
f01010a8:	74 10                	je     f01010ba <getint+0x2a>
		return va_arg(*ap, long);
f01010aa:	8b 10                	mov    (%eax),%edx
f01010ac:	8d 4a 04             	lea    0x4(%edx),%ecx
f01010af:	89 08                	mov    %ecx,(%eax)
f01010b1:	8b 02                	mov    (%edx),%eax
f01010b3:	89 c2                	mov    %eax,%edx
f01010b5:	c1 fa 1f             	sar    $0x1f,%edx
f01010b8:	eb 0e                	jmp    f01010c8 <getint+0x38>
	else
		return va_arg(*ap, int);
f01010ba:	8b 10                	mov    (%eax),%edx
f01010bc:	8d 4a 04             	lea    0x4(%edx),%ecx
f01010bf:	89 08                	mov    %ecx,(%eax)
f01010c1:	8b 02                	mov    (%edx),%eax
f01010c3:	89 c2                	mov    %eax,%edx
f01010c5:	c1 fa 1f             	sar    $0x1f,%edx
}
f01010c8:	5d                   	pop    %ebp
f01010c9:	c3                   	ret    

f01010ca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f01010ca:	55                   	push   %ebp
f01010cb:	89 e5                	mov    %esp,%ebp
f01010cd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f01010d0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f01010d4:	8b 10                	mov    (%eax),%edx
f01010d6:	3b 50 04             	cmp    0x4(%eax),%edx
f01010d9:	73 0a                	jae    f01010e5 <sprintputch+0x1b>
		*b->buf++ = ch;
f01010db:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01010de:	88 0a                	mov    %cl,(%edx)
f01010e0:	83 c2 01             	add    $0x1,%edx
f01010e3:	89 10                	mov    %edx,(%eax)
}
f01010e5:	5d                   	pop    %ebp
f01010e6:	c3                   	ret    

f01010e7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f01010e7:	55                   	push   %ebp
f01010e8:	89 e5                	mov    %esp,%ebp
f01010ea:	57                   	push   %edi
f01010eb:	56                   	push   %esi
f01010ec:	53                   	push   %ebx
f01010ed:	83 ec 5c             	sub    $0x5c,%esp
f01010f0:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01010f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
f01010f6:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
f01010fd:	eb 17                	jmp    f0101116 <vprintfmt+0x2f>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f01010ff:	85 c0                	test   %eax,%eax
f0101101:	0f 84 5e 04 00 00    	je     f0101565 <vprintfmt+0x47e>
				return;
			putch(ch, putdat);
f0101107:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010110b:	89 04 24             	mov    %eax,(%esp)
f010110e:	ff 55 08             	call   *0x8(%ebp)
f0101111:	eb 03                	jmp    f0101116 <vprintfmt+0x2f>
f0101113:	8b 5d cc             	mov    -0x34(%ebp),%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0101116:	0f b6 03             	movzbl (%ebx),%eax
f0101119:	83 c3 01             	add    $0x1,%ebx
f010111c:	83 f8 25             	cmp    $0x25,%eax
f010111f:	75 de                	jne    f01010ff <vprintfmt+0x18>
f0101121:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f0101128:	c6 45 d0 20          	movb   $0x20,-0x30(%ebp)
f010112c:	be ff ff ff ff       	mov    $0xffffffff,%esi
f0101131:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
f0101138:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010113f:	eb 06                	jmp    f0101147 <vprintfmt+0x60>
f0101141:	c6 45 d0 2d          	movb   $0x2d,-0x30(%ebp)
f0101145:	89 cb                	mov    %ecx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0101147:	0f b6 03             	movzbl (%ebx),%eax
f010114a:	0f b6 d0             	movzbl %al,%edx
f010114d:	8d 4b 01             	lea    0x1(%ebx),%ecx
f0101150:	83 e8 23             	sub    $0x23,%eax
f0101153:	3c 55                	cmp    $0x55,%al
f0101155:	0f 87 ec 03 00 00    	ja     f0101547 <vprintfmt+0x460>
f010115b:	0f b6 c0             	movzbl %al,%eax
f010115e:	ff 24 85 28 24 10 f0 	jmp    *-0xfefdbd8(,%eax,4)
f0101165:	c6 45 d0 30          	movb   $0x30,-0x30(%ebp)
f0101169:	eb da                	jmp    f0101145 <vprintfmt+0x5e>
		case '8':
			width = 8;
			goto reswitch;
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f010116b:	8d 72 d0             	lea    -0x30(%edx),%esi
				ch = *fmt;
f010116e:	0f be 01             	movsbl (%ecx),%eax
				if (ch < '0' || ch > '9')
f0101171:	8d 50 d0             	lea    -0x30(%eax),%edx
f0101174:	83 fa 09             	cmp    $0x9,%edx
f0101177:	76 0b                	jbe    f0101184 <vprintfmt+0x9d>
f0101179:	eb 43                	jmp    f01011be <vprintfmt+0xd7>
f010117b:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%ebp)
		case '5':
		case '6':
		case '7':
		case '8':
			width = 8;
			goto reswitch;
f0101182:	eb c1                	jmp    f0101145 <vprintfmt+0x5e>
		case '9':
			for (precision = 0; ; ++fmt) {
f0101184:	83 c1 01             	add    $0x1,%ecx
				precision = precision * 10 + ch - '0';
f0101187:	8d 14 b6             	lea    (%esi,%esi,4),%edx
f010118a:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
f010118e:	0f be 01             	movsbl (%ecx),%eax
				if (ch < '0' || ch > '9')
f0101191:	8d 50 d0             	lea    -0x30(%eax),%edx
f0101194:	83 fa 09             	cmp    $0x9,%edx
f0101197:	76 eb                	jbe    f0101184 <vprintfmt+0x9d>
f0101199:	eb 23                	jmp    f01011be <vprintfmt+0xd7>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f010119b:	8b 45 14             	mov    0x14(%ebp),%eax
f010119e:	8d 50 04             	lea    0x4(%eax),%edx
f01011a1:	89 55 14             	mov    %edx,0x14(%ebp)
f01011a4:	8b 30                	mov    (%eax),%esi
			goto process_precision;
f01011a6:	eb 16                	jmp    f01011be <vprintfmt+0xd7>

		case '.':
			if (width < 0)
f01011a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01011ab:	c1 f8 1f             	sar    $0x1f,%eax
f01011ae:	f7 d0                	not    %eax
f01011b0:	21 45 e4             	and    %eax,-0x1c(%ebp)
f01011b3:	eb 90                	jmp    f0101145 <vprintfmt+0x5e>
f01011b5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
f01011bc:	eb 87                	jmp    f0101145 <vprintfmt+0x5e>

		process_precision:
			if (width < 0)
f01011be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01011c2:	79 81                	jns    f0101145 <vprintfmt+0x5e>
f01011c4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f01011c7:	8b 75 c8             	mov    -0x38(%ebp),%esi
f01011ca:	e9 76 ff ff ff       	jmp    f0101145 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f01011cf:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
f01011d3:	e9 6d ff ff ff       	jmp    f0101145 <vprintfmt+0x5e>
f01011d8:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f01011db:	8b 45 14             	mov    0x14(%ebp),%eax
f01011de:	8d 50 04             	lea    0x4(%eax),%edx
f01011e1:	89 55 14             	mov    %edx,0x14(%ebp)
f01011e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01011e8:	8b 00                	mov    (%eax),%eax
f01011ea:	89 04 24             	mov    %eax,(%esp)
f01011ed:	ff 55 08             	call   *0x8(%ebp)
f01011f0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f01011f3:	e9 1e ff ff ff       	jmp    f0101116 <vprintfmt+0x2f>
f01011f8:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
f01011fb:	8b 45 14             	mov    0x14(%ebp),%eax
f01011fe:	8d 50 04             	lea    0x4(%eax),%edx
f0101201:	89 55 14             	mov    %edx,0x14(%ebp)
f0101204:	8b 00                	mov    (%eax),%eax
f0101206:	89 c2                	mov    %eax,%edx
f0101208:	c1 fa 1f             	sar    $0x1f,%edx
f010120b:	31 d0                	xor    %edx,%eax
f010120d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f010120f:	83 f8 06             	cmp    $0x6,%eax
f0101212:	7f 0b                	jg     f010121f <vprintfmt+0x138>
f0101214:	8b 14 85 80 25 10 f0 	mov    -0xfefda80(,%eax,4),%edx
f010121b:	85 d2                	test   %edx,%edx
f010121d:	75 23                	jne    f0101242 <vprintfmt+0x15b>
				printfmt(putch, putdat, "error %d", err);
f010121f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101223:	c7 44 24 08 2e 23 10 	movl   $0xf010232e,0x8(%esp)
f010122a:	f0 
f010122b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010122f:	8b 45 08             	mov    0x8(%ebp),%eax
f0101232:	89 04 24             	mov    %eax,(%esp)
f0101235:	e8 b3 03 00 00       	call   f01015ed <printfmt>
f010123a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f010123d:	e9 d4 fe ff ff       	jmp    f0101116 <vprintfmt+0x2f>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
f0101242:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0101246:	c7 44 24 08 37 23 10 	movl   $0xf0102337,0x8(%esp)
f010124d:	f0 
f010124e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101252:	8b 55 08             	mov    0x8(%ebp),%edx
f0101255:	89 14 24             	mov    %edx,(%esp)
f0101258:	e8 90 03 00 00       	call   f01015ed <printfmt>
f010125d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0101260:	e9 b1 fe ff ff       	jmp    f0101116 <vprintfmt+0x2f>
f0101265:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f0101268:	89 cb                	mov    %ecx,%ebx
f010126a:	89 f1                	mov    %esi,%ecx
f010126c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010126f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0101272:	8b 45 14             	mov    0x14(%ebp),%eax
f0101275:	8d 50 04             	lea    0x4(%eax),%edx
f0101278:	89 55 14             	mov    %edx,0x14(%ebp)
f010127b:	8b 00                	mov    (%eax),%eax
f010127d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101280:	85 c0                	test   %eax,%eax
f0101282:	75 07                	jne    f010128b <vprintfmt+0x1a4>
f0101284:	c7 45 d4 3a 23 10 f0 	movl   $0xf010233a,-0x2c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
f010128b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f010128f:	7e 06                	jle    f0101297 <vprintfmt+0x1b0>
f0101291:	80 7d d0 2d          	cmpb   $0x2d,-0x30(%ebp)
f0101295:	75 13                	jne    f01012aa <vprintfmt+0x1c3>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0101297:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010129a:	0f be 02             	movsbl (%edx),%eax
f010129d:	85 c0                	test   %eax,%eax
f010129f:	0f 85 95 00 00 00    	jne    f010133a <vprintfmt+0x253>
f01012a5:	e9 85 00 00 00       	jmp    f010132f <vprintfmt+0x248>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f01012aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f01012ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01012b1:	89 04 24             	mov    %eax,(%esp)
f01012b4:	e8 62 04 00 00       	call   f010171b <strnlen>
f01012b9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f01012bc:	29 c2                	sub    %eax,%edx
f01012be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01012c1:	85 d2                	test   %edx,%edx
f01012c3:	7e d2                	jle    f0101297 <vprintfmt+0x1b0>
					putch(padc, putdat);
f01012c5:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
f01012c9:	89 75 c4             	mov    %esi,-0x3c(%ebp)
f01012cc:	89 5d c0             	mov    %ebx,-0x40(%ebp)
f01012cf:	89 d3                	mov    %edx,%ebx
f01012d1:	89 c6                	mov    %eax,%esi
f01012d3:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01012d7:	89 34 24             	mov    %esi,(%esp)
f01012da:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f01012dd:	83 eb 01             	sub    $0x1,%ebx
f01012e0:	85 db                	test   %ebx,%ebx
f01012e2:	7f ef                	jg     f01012d3 <vprintfmt+0x1ec>
f01012e4:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f01012e7:	8b 5d c0             	mov    -0x40(%ebp),%ebx
f01012ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f01012f1:	eb a4                	jmp    f0101297 <vprintfmt+0x1b0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f01012f3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f01012f7:	74 19                	je     f0101312 <vprintfmt+0x22b>
f01012f9:	8d 50 e0             	lea    -0x20(%eax),%edx
f01012fc:	83 fa 5e             	cmp    $0x5e,%edx
f01012ff:	76 11                	jbe    f0101312 <vprintfmt+0x22b>
					putch('?', putdat);
f0101301:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101305:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f010130c:	ff 55 08             	call   *0x8(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f010130f:	90                   	nop
f0101310:	eb 0a                	jmp    f010131c <vprintfmt+0x235>
					putch('?', putdat);
				else
					putch(ch, putdat);
f0101312:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101316:	89 04 24             	mov    %eax,(%esp)
f0101319:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010131c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
f0101320:	0f be 03             	movsbl (%ebx),%eax
f0101323:	85 c0                	test   %eax,%eax
f0101325:	74 05                	je     f010132c <vprintfmt+0x245>
f0101327:	83 c3 01             	add    $0x1,%ebx
f010132a:	eb 19                	jmp    f0101345 <vprintfmt+0x25e>
f010132c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f010132f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0101333:	7f 1e                	jg     f0101353 <vprintfmt+0x26c>
f0101335:	e9 d9 fd ff ff       	jmp    f0101113 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010133a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010133d:	83 c2 01             	add    $0x1,%edx
f0101340:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
f0101343:	89 d3                	mov    %edx,%ebx
f0101345:	85 f6                	test   %esi,%esi
f0101347:	78 aa                	js     f01012f3 <vprintfmt+0x20c>
f0101349:	83 ee 01             	sub    $0x1,%esi
f010134c:	79 a5                	jns    f01012f3 <vprintfmt+0x20c>
f010134e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101351:	eb dc                	jmp    f010132f <vprintfmt+0x248>
f0101353:	8b 75 08             	mov    0x8(%ebp),%esi
f0101356:	89 5d d8             	mov    %ebx,-0x28(%ebp)
f0101359:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f010135c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101360:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0101367:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0101369:	83 eb 01             	sub    $0x1,%ebx
f010136c:	85 db                	test   %ebx,%ebx
f010136e:	7f ec                	jg     f010135c <vprintfmt+0x275>
f0101370:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f0101373:	e9 9e fd ff ff       	jmp    f0101116 <vprintfmt+0x2f>
f0101378:	89 4d cc             	mov    %ecx,-0x34(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);//different data type
f010137b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010137e:	8d 45 14             	lea    0x14(%ebp),%eax
f0101381:	e8 0a fd ff ff       	call   f0101090 <getint>
f0101386:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101389:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010138c:	89 c3                	mov    %eax,%ebx
f010138e:	89 d6                	mov    %edx,%esi
f0101390:	ba 0a 00 00 00       	mov    $0xa,%edx
			if ((long long) num < 0) {
f0101395:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0101399:	0f 89 b2 00 00 00    	jns    f0101451 <vprintfmt+0x36a>
				putch('-', putdat);
f010139f:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01013a3:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f01013aa:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f01013ad:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f01013b0:	8b 75 dc             	mov    -0x24(%ebp),%esi
f01013b3:	f7 db                	neg    %ebx
f01013b5:	83 d6 00             	adc    $0x0,%esi
f01013b8:	f7 de                	neg    %esi
f01013ba:	ba 0a 00 00 00       	mov    $0xa,%edx
f01013bf:	e9 8d 00 00 00       	jmp    f0101451 <vprintfmt+0x36a>
f01013c4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f01013c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01013ca:	8d 45 14             	lea    0x14(%ebp),%eax
f01013cd:	e8 84 fc ff ff       	call   f0101056 <getuint>
f01013d2:	89 c3                	mov    %eax,%ebx
f01013d4:	89 d6                	mov    %edx,%esi
f01013d6:	ba 0a 00 00 00       	mov    $0xa,%edx
			base = 10;
			goto number;
f01013db:	eb 74                	jmp    f0101451 <vprintfmt+0x36a>
f01013dd:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			// display a number in octal form and the form should begin with '0'
			putch('0', putdat);
f01013e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01013e4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f01013eb:	ff 55 08             	call   *0x8(%ebp)
			num = getuint(&ap, lflag);
f01013ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01013f1:	8d 45 14             	lea    0x14(%ebp),%eax
f01013f4:	e8 5d fc ff ff       	call   f0101056 <getuint>
f01013f9:	89 c3                	mov    %eax,%ebx
f01013fb:	89 d6                	mov    %edx,%esi
f01013fd:	ba 08 00 00 00       	mov    $0x8,%edx
			base = 8;
			goto number;
f0101402:	eb 4d                	jmp    f0101451 <vprintfmt+0x36a>
f0101404:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
f0101407:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010140b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f0101412:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f0101415:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101419:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f0101420:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
f0101423:	8b 45 14             	mov    0x14(%ebp),%eax
f0101426:	8d 50 04             	lea    0x4(%eax),%edx
f0101429:	89 55 14             	mov    %edx,0x14(%ebp)
f010142c:	8b 18                	mov    (%eax),%ebx
f010142e:	be 00 00 00 00       	mov    $0x0,%esi
f0101433:	ba 10 00 00 00       	mov    $0x10,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
f0101438:	eb 17                	jmp    f0101451 <vprintfmt+0x36a>
f010143a:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':

			num = getuint(&ap, lflag);
f010143d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101440:	8d 45 14             	lea    0x14(%ebp),%eax
f0101443:	e8 0e fc ff ff       	call   f0101056 <getuint>
f0101448:	89 c3                	mov    %eax,%ebx
f010144a:	89 d6                	mov    %edx,%esi
f010144c:	ba 10 00 00 00       	mov    $0x10,%edx
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
f0101451:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
f0101455:	89 44 24 10          	mov    %eax,0x10(%esp)
f0101459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010145c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101460:	89 54 24 08          	mov    %edx,0x8(%esp)
f0101464:	89 1c 24             	mov    %ebx,(%esp)
f0101467:	89 74 24 04          	mov    %esi,0x4(%esp)
f010146b:	89 fa                	mov    %edi,%edx
f010146d:	8b 45 08             	mov    0x8(%ebp),%eax
f0101470:	e8 99 fa ff ff       	call   f0100f0e <printnum>
f0101475:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f0101478:	e9 99 fc ff ff       	jmp    f0101116 <vprintfmt+0x2f>
f010147d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
            //        can represent.

            const char *null_error = "\nerror! writing through NULL pointer! (%n argument)\n";
            const char *overflow_error = "\nwarning! The value %n argument pointed to has been overflowed!\n";
            // Your code here
	    q = va_arg(ap, char *);//after call va_arg(), it will point to next argument
f0101480:	8b 45 14             	mov    0x14(%ebp),%eax
f0101483:	8d 50 04             	lea    0x4(%eax),%edx
f0101486:	89 55 14             	mov    %edx,0x14(%ebp)
f0101489:	8b 30                	mov    (%eax),%esi
	    if ( q == NULL ){
f010148b:	85 f6                	test   %esi,%esi
f010148d:	75 21                	jne    f01014b0 <vprintfmt+0x3c9>
f010148f:	bb ad 23 10 f0       	mov    $0xf01023ad,%ebx
f0101494:	b8 0a 00 00 00       	mov    $0xa,%eax
		while ((ch = *null_error++) != '\0') {
                        cputchar(ch);
f0101499:	89 04 24             	mov    %eax,(%esp)
f010149c:	e8 e9 f0 ff ff       	call   f010058a <cputchar>
            const char *null_error = "\nerror! writing through NULL pointer! (%n argument)\n";
            const char *overflow_error = "\nwarning! The value %n argument pointed to has been overflowed!\n";
            // Your code here
	    q = va_arg(ap, char *);//after call va_arg(), it will point to next argument
	    if ( q == NULL ){
		while ((ch = *null_error++) != '\0') {
f01014a1:	0f be 03             	movsbl (%ebx),%eax
f01014a4:	83 c3 01             	add    $0x1,%ebx
f01014a7:	85 c0                	test   %eax,%eax
f01014a9:	75 ee                	jne    f0101499 <vprintfmt+0x3b2>
f01014ab:	e9 63 fc ff ff       	jmp    f0101113 <vprintfmt+0x2c>
                        cputchar(ch);
                }
	    	break;
	    }
	    if ( *(unsigned char *)putdat >= 255 ){//why did it can't be 255?  
f01014b0:	80 3f ff             	cmpb   $0xff,(%edi)
f01014b3:	75 27                	jne    f01014dc <vprintfmt+0x3f5>
f01014b5:	bb e5 23 10 f0       	mov    $0xf01023e5,%ebx
f01014ba:	b8 0a 00 00 00       	mov    $0xa,%eax
		while ((ch = *(char *) overflow_error++) != '\0') {
                        cputchar(ch);
f01014bf:	89 04 24             	mov    %eax,(%esp)
f01014c2:	e8 c3 f0 ff ff       	call   f010058a <cputchar>
                        cputchar(ch);
                }
	    	break;
	    }
	    if ( *(unsigned char *)putdat >= 255 ){//why did it can't be 255?  
		while ((ch = *(char *) overflow_error++) != '\0') {
f01014c7:	0f be 03             	movsbl (%ebx),%eax
f01014ca:	83 c3 01             	add    $0x1,%ebx
f01014cd:	85 c0                	test   %eax,%eax
f01014cf:	75 ee                	jne    f01014bf <vprintfmt+0x3d8>
                        cputchar(ch);
                }
		*q = -1;
f01014d1:	c6 06 ff             	movb   $0xff,(%esi)
f01014d4:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		break;
f01014d7:	e9 3a fc ff ff       	jmp    f0101116 <vprintfmt+0x2f>
	    }
 	    *q = *(char *)putdat;
f01014dc:	0f b6 07             	movzbl (%edi),%eax
f01014df:	88 06                	mov    %al,(%esi)
f01014e1:	8b 5d cc             	mov    -0x34(%ebp),%ebx
            break;
f01014e4:	e9 2d fc ff ff       	jmp    f0101116 <vprintfmt+0x2f>
f01014e9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
        }
		// escaped '%' character
		case '%':
			putch(ch, putdat);
f01014ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01014f0:	89 14 24             	mov    %edx,(%esp)
f01014f3:	ff 55 08             	call   *0x8(%ebp)
f01014f6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f01014f9:	e9 18 fc ff ff       	jmp    f0101116 <vprintfmt+0x2f>
f01014fe:	89 4d cc             	mov    %ecx,-0x34(%ebp)
			
		// unrecognized escape sequence - just print it literally
		//precede the result with a plus or minus sign (+ or -) even for positive numbers-added by tww
		case '+':
			num = getint(&ap, lflag);//after call getint(),the argument will go to next
f0101501:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101504:	8d 45 14             	lea    0x14(%ebp),%eax
f0101507:	e8 84 fb ff ff       	call   f0101090 <getint>
f010150c:	89 c3                	mov    %eax,%ebx
f010150e:	89 d6                	mov    %edx,%esi
		        if ((long long) num < 0) {
f0101510:	85 d2                	test   %edx,%edx
f0101512:	79 17                	jns    f010152b <vprintfmt+0x444>
				putch('-', putdat);
f0101514:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101518:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f010151f:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f0101522:	f7 db                	neg    %ebx
f0101524:	83 d6 00             	adc    $0x0,%esi
f0101527:	f7 de                	neg    %esi
f0101529:	eb 0e                	jmp    f0101539 <vprintfmt+0x452>
			}
			else{
				putch('+', putdat);
f010152b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010152f:	c7 04 24 2b 00 00 00 	movl   $0x2b,(%esp)
f0101536:	ff 55 08             	call   *0x8(%ebp)
			}
			base = 10;
			fmt++;
f0101539:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
f010153d:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
f0101542:	e9 0a ff ff ff       	jmp    f0101451 <vprintfmt+0x36a>
		default:
			putch('%', putdat);
f0101547:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010154b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0101552:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f0101555:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0101558:	80 38 25             	cmpb   $0x25,(%eax)
f010155b:	0f 84 b5 fb ff ff    	je     f0101116 <vprintfmt+0x2f>
f0101561:	89 c3                	mov    %eax,%ebx
f0101563:	eb f0                	jmp    f0101555 <vprintfmt+0x46e>
				/* do nothing */;
			break;
		}
	}
}
f0101565:	83 c4 5c             	add    $0x5c,%esp
f0101568:	5b                   	pop    %ebx
f0101569:	5e                   	pop    %esi
f010156a:	5f                   	pop    %edi
f010156b:	5d                   	pop    %ebp
f010156c:	c3                   	ret    

f010156d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f010156d:	55                   	push   %ebp
f010156e:	89 e5                	mov    %esp,%ebp
f0101570:	83 ec 28             	sub    $0x28,%esp
f0101573:	8b 45 08             	mov    0x8(%ebp),%eax
f0101576:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
f0101579:	85 c0                	test   %eax,%eax
f010157b:	74 04                	je     f0101581 <vsnprintf+0x14>
f010157d:	85 d2                	test   %edx,%edx
f010157f:	7f 07                	jg     f0101588 <vsnprintf+0x1b>
f0101581:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0101586:	eb 3b                	jmp    f01015c3 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
f0101588:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010158b:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
f010158f:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0101592:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0101599:	8b 45 14             	mov    0x14(%ebp),%eax
f010159c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01015a0:	8b 45 10             	mov    0x10(%ebp),%eax
f01015a3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01015a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01015aa:	89 44 24 04          	mov    %eax,0x4(%esp)
f01015ae:	c7 04 24 ca 10 10 f0 	movl   $0xf01010ca,(%esp)
f01015b5:	e8 2d fb ff ff       	call   f01010e7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01015ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01015bd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f01015c3:	c9                   	leave  
f01015c4:	c3                   	ret    

f01015c5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f01015c5:	55                   	push   %ebp
f01015c6:	89 e5                	mov    %esp,%ebp
f01015c8:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
f01015cb:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
f01015ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01015d2:	8b 45 10             	mov    0x10(%ebp),%eax
f01015d5:	89 44 24 08          	mov    %eax,0x8(%esp)
f01015d9:	8b 45 0c             	mov    0xc(%ebp),%eax
f01015dc:	89 44 24 04          	mov    %eax,0x4(%esp)
f01015e0:	8b 45 08             	mov    0x8(%ebp),%eax
f01015e3:	89 04 24             	mov    %eax,(%esp)
f01015e6:	e8 82 ff ff ff       	call   f010156d <vsnprintf>
	va_end(ap);

	return rc;
}
f01015eb:	c9                   	leave  
f01015ec:	c3                   	ret    

f01015ed <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...)
{
f01015ed:	55                   	push   %ebp
f01015ee:	89 e5                	mov    %esp,%ebp
f01015f0:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt,...)
f01015f3:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
f01015f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01015fa:	8b 45 10             	mov    0x10(%ebp),%eax
f01015fd:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101601:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101604:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101608:	8b 45 08             	mov    0x8(%ebp),%eax
f010160b:	89 04 24             	mov    %eax,(%esp)
f010160e:	e8 d4 fa ff ff       	call   f01010e7 <vprintfmt>
	va_end(ap);
}
f0101613:	c9                   	leave  
f0101614:	c3                   	ret    
	...

f0101620 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0101620:	55                   	push   %ebp
f0101621:	89 e5                	mov    %esp,%ebp
f0101623:	57                   	push   %edi
f0101624:	56                   	push   %esi
f0101625:	53                   	push   %ebx
f0101626:	83 ec 1c             	sub    $0x1c,%esp
f0101629:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f010162c:	85 c0                	test   %eax,%eax
f010162e:	74 10                	je     f0101640 <readline+0x20>
		cprintf("%s", prompt);
f0101630:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101634:	c7 04 24 37 23 10 f0 	movl   $0xf0102337,(%esp)
f010163b:	e8 5b f4 ff ff       	call   f0100a9b <cprintf>

	i = 0;
	echoing = iscons(0);
f0101640:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101647:	e8 3a ed ff ff       	call   f0100386 <iscons>
f010164c:	89 c7                	mov    %eax,%edi
f010164e:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
f0101653:	e8 1d ed ff ff       	call   f0100375 <getchar>
f0101658:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f010165a:	85 c0                	test   %eax,%eax
f010165c:	79 17                	jns    f0101675 <readline+0x55>
			cprintf("read error: %e\n", c);
f010165e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101662:	c7 04 24 9c 25 10 f0 	movl   $0xf010259c,(%esp)
f0101669:	e8 2d f4 ff ff       	call   f0100a9b <cprintf>
f010166e:	b8 00 00 00 00       	mov    $0x0,%eax
			return NULL;
f0101673:	eb 76                	jmp    f01016eb <readline+0xcb>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0101675:	83 f8 08             	cmp    $0x8,%eax
f0101678:	74 08                	je     f0101682 <readline+0x62>
f010167a:	83 f8 7f             	cmp    $0x7f,%eax
f010167d:	8d 76 00             	lea    0x0(%esi),%esi
f0101680:	75 19                	jne    f010169b <readline+0x7b>
f0101682:	85 f6                	test   %esi,%esi
f0101684:	7e 15                	jle    f010169b <readline+0x7b>
			if (echoing)
f0101686:	85 ff                	test   %edi,%edi
f0101688:	74 0c                	je     f0101696 <readline+0x76>
				cputchar('\b');
f010168a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f0101691:	e8 f4 ee ff ff       	call   f010058a <cputchar>
			i--;
f0101696:	83 ee 01             	sub    $0x1,%esi
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0101699:	eb b8                	jmp    f0101653 <readline+0x33>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
f010169b:	83 fb 1f             	cmp    $0x1f,%ebx
f010169e:	66 90                	xchg   %ax,%ax
f01016a0:	7e 23                	jle    f01016c5 <readline+0xa5>
f01016a2:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01016a8:	7f 1b                	jg     f01016c5 <readline+0xa5>
			if (echoing)
f01016aa:	85 ff                	test   %edi,%edi
f01016ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01016b0:	74 08                	je     f01016ba <readline+0x9a>
				cputchar(c);
f01016b2:	89 1c 24             	mov    %ebx,(%esp)
f01016b5:	e8 d0 ee ff ff       	call   f010058a <cputchar>
			buf[i++] = c;
f01016ba:	88 9e 60 35 11 f0    	mov    %bl,-0xfeecaa0(%esi)
f01016c0:	83 c6 01             	add    $0x1,%esi
f01016c3:	eb 8e                	jmp    f0101653 <readline+0x33>
		} else if (c == '\n' || c == '\r') {
f01016c5:	83 fb 0a             	cmp    $0xa,%ebx
f01016c8:	74 05                	je     f01016cf <readline+0xaf>
f01016ca:	83 fb 0d             	cmp    $0xd,%ebx
f01016cd:	75 84                	jne    f0101653 <readline+0x33>
			if (echoing)
f01016cf:	85 ff                	test   %edi,%edi
f01016d1:	74 0c                	je     f01016df <readline+0xbf>
				cputchar('\n');
f01016d3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f01016da:	e8 ab ee ff ff       	call   f010058a <cputchar>
			buf[i] = 0;
f01016df:	c6 86 60 35 11 f0 00 	movb   $0x0,-0xfeecaa0(%esi)
f01016e6:	b8 60 35 11 f0       	mov    $0xf0113560,%eax
			return buf;
		}
	}
}
f01016eb:	83 c4 1c             	add    $0x1c,%esp
f01016ee:	5b                   	pop    %ebx
f01016ef:	5e                   	pop    %esi
f01016f0:	5f                   	pop    %edi
f01016f1:	5d                   	pop    %ebp
f01016f2:	c3                   	ret    
	...

f0101700 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0101700:	55                   	push   %ebp
f0101701:	89 e5                	mov    %esp,%ebp
f0101703:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0101706:	b8 00 00 00 00       	mov    $0x0,%eax
f010170b:	80 3a 00             	cmpb   $0x0,(%edx)
f010170e:	74 09                	je     f0101719 <strlen+0x19>
		n++;
f0101710:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0101713:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0101717:	75 f7                	jne    f0101710 <strlen+0x10>
		n++;
	return n;
}
f0101719:	5d                   	pop    %ebp
f010171a:	c3                   	ret    

f010171b <strnlen>:

int
strnlen(const char *s, size_t size)
{
f010171b:	55                   	push   %ebp
f010171c:	89 e5                	mov    %esp,%ebp
f010171e:	53                   	push   %ebx
f010171f:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101722:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0101725:	85 c9                	test   %ecx,%ecx
f0101727:	74 19                	je     f0101742 <strnlen+0x27>
f0101729:	80 3b 00             	cmpb   $0x0,(%ebx)
f010172c:	74 14                	je     f0101742 <strnlen+0x27>
f010172e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
f0101733:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0101736:	39 c8                	cmp    %ecx,%eax
f0101738:	74 0d                	je     f0101747 <strnlen+0x2c>
f010173a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
f010173e:	75 f3                	jne    f0101733 <strnlen+0x18>
f0101740:	eb 05                	jmp    f0101747 <strnlen+0x2c>
f0101742:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
f0101747:	5b                   	pop    %ebx
f0101748:	5d                   	pop    %ebp
f0101749:	c3                   	ret    

f010174a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010174a:	55                   	push   %ebp
f010174b:	89 e5                	mov    %esp,%ebp
f010174d:	53                   	push   %ebx
f010174e:	8b 45 08             	mov    0x8(%ebp),%eax
f0101751:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101754:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0101759:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f010175d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0101760:	83 c2 01             	add    $0x1,%edx
f0101763:	84 c9                	test   %cl,%cl
f0101765:	75 f2                	jne    f0101759 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0101767:	5b                   	pop    %ebx
f0101768:	5d                   	pop    %ebp
f0101769:	c3                   	ret    

f010176a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f010176a:	55                   	push   %ebp
f010176b:	89 e5                	mov    %esp,%ebp
f010176d:	56                   	push   %esi
f010176e:	53                   	push   %ebx
f010176f:	8b 45 08             	mov    0x8(%ebp),%eax
f0101772:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101775:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0101778:	85 f6                	test   %esi,%esi
f010177a:	74 18                	je     f0101794 <strncpy+0x2a>
f010177c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
f0101781:	0f b6 1a             	movzbl (%edx),%ebx
f0101784:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0101787:	80 3a 01             	cmpb   $0x1,(%edx)
f010178a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f010178d:	83 c1 01             	add    $0x1,%ecx
f0101790:	39 ce                	cmp    %ecx,%esi
f0101792:	77 ed                	ja     f0101781 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f0101794:	5b                   	pop    %ebx
f0101795:	5e                   	pop    %esi
f0101796:	5d                   	pop    %ebp
f0101797:	c3                   	ret    

f0101798 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0101798:	55                   	push   %ebp
f0101799:	89 e5                	mov    %esp,%ebp
f010179b:	56                   	push   %esi
f010179c:	53                   	push   %ebx
f010179d:	8b 75 08             	mov    0x8(%ebp),%esi
f01017a0:	8b 55 0c             	mov    0xc(%ebp),%edx
f01017a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01017a6:	89 f0                	mov    %esi,%eax
f01017a8:	85 c9                	test   %ecx,%ecx
f01017aa:	74 27                	je     f01017d3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
f01017ac:	83 e9 01             	sub    $0x1,%ecx
f01017af:	74 1d                	je     f01017ce <strlcpy+0x36>
f01017b1:	0f b6 1a             	movzbl (%edx),%ebx
f01017b4:	84 db                	test   %bl,%bl
f01017b6:	74 16                	je     f01017ce <strlcpy+0x36>
			*dst++ = *src++;
f01017b8:	88 18                	mov    %bl,(%eax)
f01017ba:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f01017bd:	83 e9 01             	sub    $0x1,%ecx
f01017c0:	74 0e                	je     f01017d0 <strlcpy+0x38>
			*dst++ = *src++;
f01017c2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f01017c5:	0f b6 1a             	movzbl (%edx),%ebx
f01017c8:	84 db                	test   %bl,%bl
f01017ca:	75 ec                	jne    f01017b8 <strlcpy+0x20>
f01017cc:	eb 02                	jmp    f01017d0 <strlcpy+0x38>
f01017ce:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
f01017d0:	c6 00 00             	movb   $0x0,(%eax)
f01017d3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
f01017d5:	5b                   	pop    %ebx
f01017d6:	5e                   	pop    %esi
f01017d7:	5d                   	pop    %ebp
f01017d8:	c3                   	ret    

f01017d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01017d9:	55                   	push   %ebp
f01017da:	89 e5                	mov    %esp,%ebp
f01017dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01017df:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01017e2:	0f b6 01             	movzbl (%ecx),%eax
f01017e5:	84 c0                	test   %al,%al
f01017e7:	74 15                	je     f01017fe <strcmp+0x25>
f01017e9:	3a 02                	cmp    (%edx),%al
f01017eb:	75 11                	jne    f01017fe <strcmp+0x25>
		p++, q++;
f01017ed:	83 c1 01             	add    $0x1,%ecx
f01017f0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f01017f3:	0f b6 01             	movzbl (%ecx),%eax
f01017f6:	84 c0                	test   %al,%al
f01017f8:	74 04                	je     f01017fe <strcmp+0x25>
f01017fa:	3a 02                	cmp    (%edx),%al
f01017fc:	74 ef                	je     f01017ed <strcmp+0x14>
f01017fe:	0f b6 c0             	movzbl %al,%eax
f0101801:	0f b6 12             	movzbl (%edx),%edx
f0101804:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0101806:	5d                   	pop    %ebp
f0101807:	c3                   	ret    

f0101808 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0101808:	55                   	push   %ebp
f0101809:	89 e5                	mov    %esp,%ebp
f010180b:	53                   	push   %ebx
f010180c:	8b 55 08             	mov    0x8(%ebp),%edx
f010180f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0101812:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
f0101815:	85 c0                	test   %eax,%eax
f0101817:	74 23                	je     f010183c <strncmp+0x34>
f0101819:	0f b6 1a             	movzbl (%edx),%ebx
f010181c:	84 db                	test   %bl,%bl
f010181e:	74 24                	je     f0101844 <strncmp+0x3c>
f0101820:	3a 19                	cmp    (%ecx),%bl
f0101822:	75 20                	jne    f0101844 <strncmp+0x3c>
f0101824:	83 e8 01             	sub    $0x1,%eax
f0101827:	74 13                	je     f010183c <strncmp+0x34>
		n--, p++, q++;
f0101829:	83 c2 01             	add    $0x1,%edx
f010182c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f010182f:	0f b6 1a             	movzbl (%edx),%ebx
f0101832:	84 db                	test   %bl,%bl
f0101834:	74 0e                	je     f0101844 <strncmp+0x3c>
f0101836:	3a 19                	cmp    (%ecx),%bl
f0101838:	74 ea                	je     f0101824 <strncmp+0x1c>
f010183a:	eb 08                	jmp    f0101844 <strncmp+0x3c>
f010183c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0101841:	5b                   	pop    %ebx
f0101842:	5d                   	pop    %ebp
f0101843:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0101844:	0f b6 02             	movzbl (%edx),%eax
f0101847:	0f b6 11             	movzbl (%ecx),%edx
f010184a:	29 d0                	sub    %edx,%eax
f010184c:	eb f3                	jmp    f0101841 <strncmp+0x39>

f010184e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f010184e:	55                   	push   %ebp
f010184f:	89 e5                	mov    %esp,%ebp
f0101851:	8b 45 08             	mov    0x8(%ebp),%eax
f0101854:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0101858:	0f b6 10             	movzbl (%eax),%edx
f010185b:	84 d2                	test   %dl,%dl
f010185d:	74 15                	je     f0101874 <strchr+0x26>
		if (*s == c)
f010185f:	38 ca                	cmp    %cl,%dl
f0101861:	75 07                	jne    f010186a <strchr+0x1c>
f0101863:	eb 14                	jmp    f0101879 <strchr+0x2b>
f0101865:	38 ca                	cmp    %cl,%dl
f0101867:	90                   	nop
f0101868:	74 0f                	je     f0101879 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f010186a:	83 c0 01             	add    $0x1,%eax
f010186d:	0f b6 10             	movzbl (%eax),%edx
f0101870:	84 d2                	test   %dl,%dl
f0101872:	75 f1                	jne    f0101865 <strchr+0x17>
f0101874:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
f0101879:	5d                   	pop    %ebp
f010187a:	c3                   	ret    

f010187b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010187b:	55                   	push   %ebp
f010187c:	89 e5                	mov    %esp,%ebp
f010187e:	8b 45 08             	mov    0x8(%ebp),%eax
f0101881:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0101885:	0f b6 10             	movzbl (%eax),%edx
f0101888:	84 d2                	test   %dl,%dl
f010188a:	74 18                	je     f01018a4 <strfind+0x29>
		if (*s == c)
f010188c:	38 ca                	cmp    %cl,%dl
f010188e:	75 0a                	jne    f010189a <strfind+0x1f>
f0101890:	eb 12                	jmp    f01018a4 <strfind+0x29>
f0101892:	38 ca                	cmp    %cl,%dl
f0101894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101898:	74 0a                	je     f01018a4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f010189a:	83 c0 01             	add    $0x1,%eax
f010189d:	0f b6 10             	movzbl (%eax),%edx
f01018a0:	84 d2                	test   %dl,%dl
f01018a2:	75 ee                	jne    f0101892 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
f01018a4:	5d                   	pop    %ebp
f01018a5:	c3                   	ret    

f01018a6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01018a6:	55                   	push   %ebp
f01018a7:	89 e5                	mov    %esp,%ebp
f01018a9:	83 ec 0c             	sub    $0xc,%esp
f01018ac:	89 1c 24             	mov    %ebx,(%esp)
f01018af:	89 74 24 04          	mov    %esi,0x4(%esp)
f01018b3:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01018b7:	8b 7d 08             	mov    0x8(%ebp),%edi
f01018ba:	8b 45 0c             	mov    0xc(%ebp),%eax
f01018bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01018c0:	85 c9                	test   %ecx,%ecx
f01018c2:	74 30                	je     f01018f4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01018c4:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01018ca:	75 25                	jne    f01018f1 <memset+0x4b>
f01018cc:	f6 c1 03             	test   $0x3,%cl
f01018cf:	75 20                	jne    f01018f1 <memset+0x4b>
		c &= 0xFF;
f01018d1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01018d4:	89 d3                	mov    %edx,%ebx
f01018d6:	c1 e3 08             	shl    $0x8,%ebx
f01018d9:	89 d6                	mov    %edx,%esi
f01018db:	c1 e6 18             	shl    $0x18,%esi
f01018de:	89 d0                	mov    %edx,%eax
f01018e0:	c1 e0 10             	shl    $0x10,%eax
f01018e3:	09 f0                	or     %esi,%eax
f01018e5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
f01018e7:	09 d8                	or     %ebx,%eax
f01018e9:	c1 e9 02             	shr    $0x2,%ecx
f01018ec:	fc                   	cld    
f01018ed:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01018ef:	eb 03                	jmp    f01018f4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01018f1:	fc                   	cld    
f01018f2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01018f4:	89 f8                	mov    %edi,%eax
f01018f6:	8b 1c 24             	mov    (%esp),%ebx
f01018f9:	8b 74 24 04          	mov    0x4(%esp),%esi
f01018fd:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0101901:	89 ec                	mov    %ebp,%esp
f0101903:	5d                   	pop    %ebp
f0101904:	c3                   	ret    

f0101905 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0101905:	55                   	push   %ebp
f0101906:	89 e5                	mov    %esp,%ebp
f0101908:	83 ec 08             	sub    $0x8,%esp
f010190b:	89 34 24             	mov    %esi,(%esp)
f010190e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101912:	8b 45 08             	mov    0x8(%ebp),%eax
f0101915:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
f0101918:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
f010191b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
f010191d:	39 c6                	cmp    %eax,%esi
f010191f:	73 35                	jae    f0101956 <memmove+0x51>
f0101921:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0101924:	39 d0                	cmp    %edx,%eax
f0101926:	73 2e                	jae    f0101956 <memmove+0x51>
		s += n;
		d += n;
f0101928:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010192a:	f6 c2 03             	test   $0x3,%dl
f010192d:	75 1b                	jne    f010194a <memmove+0x45>
f010192f:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0101935:	75 13                	jne    f010194a <memmove+0x45>
f0101937:	f6 c1 03             	test   $0x3,%cl
f010193a:	75 0e                	jne    f010194a <memmove+0x45>
			asm volatile("std; rep movsl\n"
f010193c:	83 ef 04             	sub    $0x4,%edi
f010193f:	8d 72 fc             	lea    -0x4(%edx),%esi
f0101942:	c1 e9 02             	shr    $0x2,%ecx
f0101945:	fd                   	std    
f0101946:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101948:	eb 09                	jmp    f0101953 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f010194a:	83 ef 01             	sub    $0x1,%edi
f010194d:	8d 72 ff             	lea    -0x1(%edx),%esi
f0101950:	fd                   	std    
f0101951:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0101953:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0101954:	eb 20                	jmp    f0101976 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101956:	f7 c6 03 00 00 00    	test   $0x3,%esi
f010195c:	75 15                	jne    f0101973 <memmove+0x6e>
f010195e:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0101964:	75 0d                	jne    f0101973 <memmove+0x6e>
f0101966:	f6 c1 03             	test   $0x3,%cl
f0101969:	75 08                	jne    f0101973 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
f010196b:	c1 e9 02             	shr    $0x2,%ecx
f010196e:	fc                   	cld    
f010196f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101971:	eb 03                	jmp    f0101976 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0101973:	fc                   	cld    
f0101974:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0101976:	8b 34 24             	mov    (%esp),%esi
f0101979:	8b 7c 24 04          	mov    0x4(%esp),%edi
f010197d:	89 ec                	mov    %ebp,%esp
f010197f:	5d                   	pop    %ebp
f0101980:	c3                   	ret    

f0101981 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
f0101981:	55                   	push   %ebp
f0101982:	89 e5                	mov    %esp,%ebp
f0101984:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0101987:	8b 45 10             	mov    0x10(%ebp),%eax
f010198a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010198e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101991:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101995:	8b 45 08             	mov    0x8(%ebp),%eax
f0101998:	89 04 24             	mov    %eax,(%esp)
f010199b:	e8 65 ff ff ff       	call   f0101905 <memmove>
}
f01019a0:	c9                   	leave  
f01019a1:	c3                   	ret    

f01019a2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f01019a2:	55                   	push   %ebp
f01019a3:	89 e5                	mov    %esp,%ebp
f01019a5:	57                   	push   %edi
f01019a6:	56                   	push   %esi
f01019a7:	53                   	push   %ebx
f01019a8:	8b 75 08             	mov    0x8(%ebp),%esi
f01019ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01019ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01019b1:	85 c9                	test   %ecx,%ecx
f01019b3:	74 36                	je     f01019eb <memcmp+0x49>
		if (*s1 != *s2)
f01019b5:	0f b6 06             	movzbl (%esi),%eax
f01019b8:	0f b6 1f             	movzbl (%edi),%ebx
f01019bb:	38 d8                	cmp    %bl,%al
f01019bd:	74 20                	je     f01019df <memcmp+0x3d>
f01019bf:	eb 14                	jmp    f01019d5 <memcmp+0x33>
f01019c1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
f01019c6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
f01019cb:	83 c2 01             	add    $0x1,%edx
f01019ce:	83 e9 01             	sub    $0x1,%ecx
f01019d1:	38 d8                	cmp    %bl,%al
f01019d3:	74 12                	je     f01019e7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
f01019d5:	0f b6 c0             	movzbl %al,%eax
f01019d8:	0f b6 db             	movzbl %bl,%ebx
f01019db:	29 d8                	sub    %ebx,%eax
f01019dd:	eb 11                	jmp    f01019f0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01019df:	83 e9 01             	sub    $0x1,%ecx
f01019e2:	ba 00 00 00 00       	mov    $0x0,%edx
f01019e7:	85 c9                	test   %ecx,%ecx
f01019e9:	75 d6                	jne    f01019c1 <memcmp+0x1f>
f01019eb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
f01019f0:	5b                   	pop    %ebx
f01019f1:	5e                   	pop    %esi
f01019f2:	5f                   	pop    %edi
f01019f3:	5d                   	pop    %ebp
f01019f4:	c3                   	ret    

f01019f5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01019f5:	55                   	push   %ebp
f01019f6:	89 e5                	mov    %esp,%ebp
f01019f8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
f01019fb:	89 c2                	mov    %eax,%edx
f01019fd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0101a00:	39 d0                	cmp    %edx,%eax
f0101a02:	73 15                	jae    f0101a19 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
f0101a04:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
f0101a08:	38 08                	cmp    %cl,(%eax)
f0101a0a:	75 06                	jne    f0101a12 <memfind+0x1d>
f0101a0c:	eb 0b                	jmp    f0101a19 <memfind+0x24>
f0101a0e:	38 08                	cmp    %cl,(%eax)
f0101a10:	74 07                	je     f0101a19 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f0101a12:	83 c0 01             	add    $0x1,%eax
f0101a15:	39 c2                	cmp    %eax,%edx
f0101a17:	77 f5                	ja     f0101a0e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f0101a19:	5d                   	pop    %ebp
f0101a1a:	c3                   	ret    

f0101a1b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0101a1b:	55                   	push   %ebp
f0101a1c:	89 e5                	mov    %esp,%ebp
f0101a1e:	57                   	push   %edi
f0101a1f:	56                   	push   %esi
f0101a20:	53                   	push   %ebx
f0101a21:	83 ec 04             	sub    $0x4,%esp
f0101a24:	8b 55 08             	mov    0x8(%ebp),%edx
f0101a27:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0101a2a:	0f b6 02             	movzbl (%edx),%eax
f0101a2d:	3c 20                	cmp    $0x20,%al
f0101a2f:	74 04                	je     f0101a35 <strtol+0x1a>
f0101a31:	3c 09                	cmp    $0x9,%al
f0101a33:	75 0e                	jne    f0101a43 <strtol+0x28>
		s++;
f0101a35:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0101a38:	0f b6 02             	movzbl (%edx),%eax
f0101a3b:	3c 20                	cmp    $0x20,%al
f0101a3d:	74 f6                	je     f0101a35 <strtol+0x1a>
f0101a3f:	3c 09                	cmp    $0x9,%al
f0101a41:	74 f2                	je     f0101a35 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
f0101a43:	3c 2b                	cmp    $0x2b,%al
f0101a45:	75 0c                	jne    f0101a53 <strtol+0x38>
		s++;
f0101a47:	83 c2 01             	add    $0x1,%edx
f0101a4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101a51:	eb 15                	jmp    f0101a68 <strtol+0x4d>
	else if (*s == '-')
f0101a53:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101a5a:	3c 2d                	cmp    $0x2d,%al
f0101a5c:	75 0a                	jne    f0101a68 <strtol+0x4d>
		s++, neg = 1;
f0101a5e:	83 c2 01             	add    $0x1,%edx
f0101a61:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0101a68:	85 db                	test   %ebx,%ebx
f0101a6a:	0f 94 c0             	sete   %al
f0101a6d:	74 05                	je     f0101a74 <strtol+0x59>
f0101a6f:	83 fb 10             	cmp    $0x10,%ebx
f0101a72:	75 18                	jne    f0101a8c <strtol+0x71>
f0101a74:	80 3a 30             	cmpb   $0x30,(%edx)
f0101a77:	75 13                	jne    f0101a8c <strtol+0x71>
f0101a79:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0101a7d:	8d 76 00             	lea    0x0(%esi),%esi
f0101a80:	75 0a                	jne    f0101a8c <strtol+0x71>
		s += 2, base = 16;
f0101a82:	83 c2 02             	add    $0x2,%edx
f0101a85:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0101a8a:	eb 15                	jmp    f0101aa1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0101a8c:	84 c0                	test   %al,%al
f0101a8e:	66 90                	xchg   %ax,%ax
f0101a90:	74 0f                	je     f0101aa1 <strtol+0x86>
f0101a92:	bb 0a 00 00 00       	mov    $0xa,%ebx
f0101a97:	80 3a 30             	cmpb   $0x30,(%edx)
f0101a9a:	75 05                	jne    f0101aa1 <strtol+0x86>
		s++, base = 8;
f0101a9c:	83 c2 01             	add    $0x1,%edx
f0101a9f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0101aa1:	b8 00 00 00 00       	mov    $0x0,%eax
f0101aa6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0101aa8:	0f b6 0a             	movzbl (%edx),%ecx
f0101aab:	89 cf                	mov    %ecx,%edi
f0101aad:	8d 59 d0             	lea    -0x30(%ecx),%ebx
f0101ab0:	80 fb 09             	cmp    $0x9,%bl
f0101ab3:	77 08                	ja     f0101abd <strtol+0xa2>
			dig = *s - '0';
f0101ab5:	0f be c9             	movsbl %cl,%ecx
f0101ab8:	83 e9 30             	sub    $0x30,%ecx
f0101abb:	eb 1e                	jmp    f0101adb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
f0101abd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
f0101ac0:	80 fb 19             	cmp    $0x19,%bl
f0101ac3:	77 08                	ja     f0101acd <strtol+0xb2>
			dig = *s - 'a' + 10;
f0101ac5:	0f be c9             	movsbl %cl,%ecx
f0101ac8:	83 e9 57             	sub    $0x57,%ecx
f0101acb:	eb 0e                	jmp    f0101adb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
f0101acd:	8d 5f bf             	lea    -0x41(%edi),%ebx
f0101ad0:	80 fb 19             	cmp    $0x19,%bl
f0101ad3:	77 15                	ja     f0101aea <strtol+0xcf>
			dig = *s - 'A' + 10;
f0101ad5:	0f be c9             	movsbl %cl,%ecx
f0101ad8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f0101adb:	39 f1                	cmp    %esi,%ecx
f0101add:	7d 0b                	jge    f0101aea <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
f0101adf:	83 c2 01             	add    $0x1,%edx
f0101ae2:	0f af c6             	imul   %esi,%eax
f0101ae5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
f0101ae8:	eb be                	jmp    f0101aa8 <strtol+0x8d>
f0101aea:	89 c1                	mov    %eax,%ecx

	if (endptr)
f0101aec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0101af0:	74 05                	je     f0101af7 <strtol+0xdc>
		*endptr = (char *) s;
f0101af2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101af5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
f0101af7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0101afb:	74 04                	je     f0101b01 <strtol+0xe6>
f0101afd:	89 c8                	mov    %ecx,%eax
f0101aff:	f7 d8                	neg    %eax
}
f0101b01:	83 c4 04             	add    $0x4,%esp
f0101b04:	5b                   	pop    %ebx
f0101b05:	5e                   	pop    %esi
f0101b06:	5f                   	pop    %edi
f0101b07:	5d                   	pop    %ebp
f0101b08:	c3                   	ret    
f0101b09:	00 00                	add    %al,(%eax)
f0101b0b:	00 00                	add    %al,(%eax)
f0101b0d:	00 00                	add    %al,(%eax)
	...

f0101b10 <__udivdi3>:
f0101b10:	55                   	push   %ebp
f0101b11:	89 e5                	mov    %esp,%ebp
f0101b13:	57                   	push   %edi
f0101b14:	56                   	push   %esi
f0101b15:	83 ec 10             	sub    $0x10,%esp
f0101b18:	8b 45 14             	mov    0x14(%ebp),%eax
f0101b1b:	8b 55 08             	mov    0x8(%ebp),%edx
f0101b1e:	8b 75 10             	mov    0x10(%ebp),%esi
f0101b21:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0101b24:	85 c0                	test   %eax,%eax
f0101b26:	89 55 f0             	mov    %edx,-0x10(%ebp)
f0101b29:	75 35                	jne    f0101b60 <__udivdi3+0x50>
f0101b2b:	39 fe                	cmp    %edi,%esi
f0101b2d:	77 61                	ja     f0101b90 <__udivdi3+0x80>
f0101b2f:	85 f6                	test   %esi,%esi
f0101b31:	75 0b                	jne    f0101b3e <__udivdi3+0x2e>
f0101b33:	b8 01 00 00 00       	mov    $0x1,%eax
f0101b38:	31 d2                	xor    %edx,%edx
f0101b3a:	f7 f6                	div    %esi
f0101b3c:	89 c6                	mov    %eax,%esi
f0101b3e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0101b41:	31 d2                	xor    %edx,%edx
f0101b43:	89 f8                	mov    %edi,%eax
f0101b45:	f7 f6                	div    %esi
f0101b47:	89 c7                	mov    %eax,%edi
f0101b49:	89 c8                	mov    %ecx,%eax
f0101b4b:	f7 f6                	div    %esi
f0101b4d:	89 c1                	mov    %eax,%ecx
f0101b4f:	89 fa                	mov    %edi,%edx
f0101b51:	89 c8                	mov    %ecx,%eax
f0101b53:	83 c4 10             	add    $0x10,%esp
f0101b56:	5e                   	pop    %esi
f0101b57:	5f                   	pop    %edi
f0101b58:	5d                   	pop    %ebp
f0101b59:	c3                   	ret    
f0101b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101b60:	39 f8                	cmp    %edi,%eax
f0101b62:	77 1c                	ja     f0101b80 <__udivdi3+0x70>
f0101b64:	0f bd d0             	bsr    %eax,%edx
f0101b67:	83 f2 1f             	xor    $0x1f,%edx
f0101b6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101b6d:	75 39                	jne    f0101ba8 <__udivdi3+0x98>
f0101b6f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0101b72:	0f 86 a0 00 00 00    	jbe    f0101c18 <__udivdi3+0x108>
f0101b78:	39 f8                	cmp    %edi,%eax
f0101b7a:	0f 82 98 00 00 00    	jb     f0101c18 <__udivdi3+0x108>
f0101b80:	31 ff                	xor    %edi,%edi
f0101b82:	31 c9                	xor    %ecx,%ecx
f0101b84:	89 c8                	mov    %ecx,%eax
f0101b86:	89 fa                	mov    %edi,%edx
f0101b88:	83 c4 10             	add    $0x10,%esp
f0101b8b:	5e                   	pop    %esi
f0101b8c:	5f                   	pop    %edi
f0101b8d:	5d                   	pop    %ebp
f0101b8e:	c3                   	ret    
f0101b8f:	90                   	nop
f0101b90:	89 d1                	mov    %edx,%ecx
f0101b92:	89 fa                	mov    %edi,%edx
f0101b94:	89 c8                	mov    %ecx,%eax
f0101b96:	31 ff                	xor    %edi,%edi
f0101b98:	f7 f6                	div    %esi
f0101b9a:	89 c1                	mov    %eax,%ecx
f0101b9c:	89 fa                	mov    %edi,%edx
f0101b9e:	89 c8                	mov    %ecx,%eax
f0101ba0:	83 c4 10             	add    $0x10,%esp
f0101ba3:	5e                   	pop    %esi
f0101ba4:	5f                   	pop    %edi
f0101ba5:	5d                   	pop    %ebp
f0101ba6:	c3                   	ret    
f0101ba7:	90                   	nop
f0101ba8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101bac:	89 f2                	mov    %esi,%edx
f0101bae:	d3 e0                	shl    %cl,%eax
f0101bb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0101bb3:	b8 20 00 00 00       	mov    $0x20,%eax
f0101bb8:	2b 45 f4             	sub    -0xc(%ebp),%eax
f0101bbb:	89 c1                	mov    %eax,%ecx
f0101bbd:	d3 ea                	shr    %cl,%edx
f0101bbf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101bc3:	0b 55 ec             	or     -0x14(%ebp),%edx
f0101bc6:	d3 e6                	shl    %cl,%esi
f0101bc8:	89 c1                	mov    %eax,%ecx
f0101bca:	89 75 e8             	mov    %esi,-0x18(%ebp)
f0101bcd:	89 fe                	mov    %edi,%esi
f0101bcf:	d3 ee                	shr    %cl,%esi
f0101bd1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101bd5:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101bd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101bdb:	d3 e7                	shl    %cl,%edi
f0101bdd:	89 c1                	mov    %eax,%ecx
f0101bdf:	d3 ea                	shr    %cl,%edx
f0101be1:	09 d7                	or     %edx,%edi
f0101be3:	89 f2                	mov    %esi,%edx
f0101be5:	89 f8                	mov    %edi,%eax
f0101be7:	f7 75 ec             	divl   -0x14(%ebp)
f0101bea:	89 d6                	mov    %edx,%esi
f0101bec:	89 c7                	mov    %eax,%edi
f0101bee:	f7 65 e8             	mull   -0x18(%ebp)
f0101bf1:	39 d6                	cmp    %edx,%esi
f0101bf3:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101bf6:	72 30                	jb     f0101c28 <__udivdi3+0x118>
f0101bf8:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101bfb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101bff:	d3 e2                	shl    %cl,%edx
f0101c01:	39 c2                	cmp    %eax,%edx
f0101c03:	73 05                	jae    f0101c0a <__udivdi3+0xfa>
f0101c05:	3b 75 ec             	cmp    -0x14(%ebp),%esi
f0101c08:	74 1e                	je     f0101c28 <__udivdi3+0x118>
f0101c0a:	89 f9                	mov    %edi,%ecx
f0101c0c:	31 ff                	xor    %edi,%edi
f0101c0e:	e9 71 ff ff ff       	jmp    f0101b84 <__udivdi3+0x74>
f0101c13:	90                   	nop
f0101c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101c18:	31 ff                	xor    %edi,%edi
f0101c1a:	b9 01 00 00 00       	mov    $0x1,%ecx
f0101c1f:	e9 60 ff ff ff       	jmp    f0101b84 <__udivdi3+0x74>
f0101c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101c28:	8d 4f ff             	lea    -0x1(%edi),%ecx
f0101c2b:	31 ff                	xor    %edi,%edi
f0101c2d:	89 c8                	mov    %ecx,%eax
f0101c2f:	89 fa                	mov    %edi,%edx
f0101c31:	83 c4 10             	add    $0x10,%esp
f0101c34:	5e                   	pop    %esi
f0101c35:	5f                   	pop    %edi
f0101c36:	5d                   	pop    %ebp
f0101c37:	c3                   	ret    
	...

f0101c40 <__umoddi3>:
f0101c40:	55                   	push   %ebp
f0101c41:	89 e5                	mov    %esp,%ebp
f0101c43:	57                   	push   %edi
f0101c44:	56                   	push   %esi
f0101c45:	83 ec 20             	sub    $0x20,%esp
f0101c48:	8b 55 14             	mov    0x14(%ebp),%edx
f0101c4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101c4e:	8b 7d 10             	mov    0x10(%ebp),%edi
f0101c51:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101c54:	85 d2                	test   %edx,%edx
f0101c56:	89 c8                	mov    %ecx,%eax
f0101c58:	89 4d f4             	mov    %ecx,-0xc(%ebp)
f0101c5b:	75 13                	jne    f0101c70 <__umoddi3+0x30>
f0101c5d:	39 f7                	cmp    %esi,%edi
f0101c5f:	76 3f                	jbe    f0101ca0 <__umoddi3+0x60>
f0101c61:	89 f2                	mov    %esi,%edx
f0101c63:	f7 f7                	div    %edi
f0101c65:	89 d0                	mov    %edx,%eax
f0101c67:	31 d2                	xor    %edx,%edx
f0101c69:	83 c4 20             	add    $0x20,%esp
f0101c6c:	5e                   	pop    %esi
f0101c6d:	5f                   	pop    %edi
f0101c6e:	5d                   	pop    %ebp
f0101c6f:	c3                   	ret    
f0101c70:	39 f2                	cmp    %esi,%edx
f0101c72:	77 4c                	ja     f0101cc0 <__umoddi3+0x80>
f0101c74:	0f bd ca             	bsr    %edx,%ecx
f0101c77:	83 f1 1f             	xor    $0x1f,%ecx
f0101c7a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0101c7d:	75 51                	jne    f0101cd0 <__umoddi3+0x90>
f0101c7f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
f0101c82:	0f 87 e0 00 00 00    	ja     f0101d68 <__umoddi3+0x128>
f0101c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101c8b:	29 f8                	sub    %edi,%eax
f0101c8d:	19 d6                	sbb    %edx,%esi
f0101c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101c95:	89 f2                	mov    %esi,%edx
f0101c97:	83 c4 20             	add    $0x20,%esp
f0101c9a:	5e                   	pop    %esi
f0101c9b:	5f                   	pop    %edi
f0101c9c:	5d                   	pop    %ebp
f0101c9d:	c3                   	ret    
f0101c9e:	66 90                	xchg   %ax,%ax
f0101ca0:	85 ff                	test   %edi,%edi
f0101ca2:	75 0b                	jne    f0101caf <__umoddi3+0x6f>
f0101ca4:	b8 01 00 00 00       	mov    $0x1,%eax
f0101ca9:	31 d2                	xor    %edx,%edx
f0101cab:	f7 f7                	div    %edi
f0101cad:	89 c7                	mov    %eax,%edi
f0101caf:	89 f0                	mov    %esi,%eax
f0101cb1:	31 d2                	xor    %edx,%edx
f0101cb3:	f7 f7                	div    %edi
f0101cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101cb8:	f7 f7                	div    %edi
f0101cba:	eb a9                	jmp    f0101c65 <__umoddi3+0x25>
f0101cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101cc0:	89 c8                	mov    %ecx,%eax
f0101cc2:	89 f2                	mov    %esi,%edx
f0101cc4:	83 c4 20             	add    $0x20,%esp
f0101cc7:	5e                   	pop    %esi
f0101cc8:	5f                   	pop    %edi
f0101cc9:	5d                   	pop    %ebp
f0101cca:	c3                   	ret    
f0101ccb:	90                   	nop
f0101ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101cd0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101cd4:	d3 e2                	shl    %cl,%edx
f0101cd6:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101cd9:	ba 20 00 00 00       	mov    $0x20,%edx
f0101cde:	2b 55 f0             	sub    -0x10(%ebp),%edx
f0101ce1:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101ce4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101ce8:	89 fa                	mov    %edi,%edx
f0101cea:	d3 ea                	shr    %cl,%edx
f0101cec:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101cf0:	0b 55 f4             	or     -0xc(%ebp),%edx
f0101cf3:	d3 e7                	shl    %cl,%edi
f0101cf5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101cf9:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101cfc:	89 f2                	mov    %esi,%edx
f0101cfe:	89 7d e8             	mov    %edi,-0x18(%ebp)
f0101d01:	89 c7                	mov    %eax,%edi
f0101d03:	d3 ea                	shr    %cl,%edx
f0101d05:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101d09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101d0c:	89 c2                	mov    %eax,%edx
f0101d0e:	d3 e6                	shl    %cl,%esi
f0101d10:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101d14:	d3 ea                	shr    %cl,%edx
f0101d16:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101d1a:	09 d6                	or     %edx,%esi
f0101d1c:	89 f0                	mov    %esi,%eax
f0101d1e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0101d21:	d3 e7                	shl    %cl,%edi
f0101d23:	89 f2                	mov    %esi,%edx
f0101d25:	f7 75 f4             	divl   -0xc(%ebp)
f0101d28:	89 d6                	mov    %edx,%esi
f0101d2a:	f7 65 e8             	mull   -0x18(%ebp)
f0101d2d:	39 d6                	cmp    %edx,%esi
f0101d2f:	72 2b                	jb     f0101d5c <__umoddi3+0x11c>
f0101d31:	39 c7                	cmp    %eax,%edi
f0101d33:	72 23                	jb     f0101d58 <__umoddi3+0x118>
f0101d35:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101d39:	29 c7                	sub    %eax,%edi
f0101d3b:	19 d6                	sbb    %edx,%esi
f0101d3d:	89 f0                	mov    %esi,%eax
f0101d3f:	89 f2                	mov    %esi,%edx
f0101d41:	d3 ef                	shr    %cl,%edi
f0101d43:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101d47:	d3 e0                	shl    %cl,%eax
f0101d49:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101d4d:	09 f8                	or     %edi,%eax
f0101d4f:	d3 ea                	shr    %cl,%edx
f0101d51:	83 c4 20             	add    $0x20,%esp
f0101d54:	5e                   	pop    %esi
f0101d55:	5f                   	pop    %edi
f0101d56:	5d                   	pop    %ebp
f0101d57:	c3                   	ret    
f0101d58:	39 d6                	cmp    %edx,%esi
f0101d5a:	75 d9                	jne    f0101d35 <__umoddi3+0xf5>
f0101d5c:	2b 45 e8             	sub    -0x18(%ebp),%eax
f0101d5f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
f0101d62:	eb d1                	jmp    f0101d35 <__umoddi3+0xf5>
f0101d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101d68:	39 f2                	cmp    %esi,%edx
f0101d6a:	0f 82 18 ff ff ff    	jb     f0101c88 <__umoddi3+0x48>
f0101d70:	e9 1d ff ff ff       	jmp    f0101c92 <__umoddi3+0x52>
