
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4 66                	in     $0x66,%al

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
f0100015:	b8 00 10 11 00       	mov    $0x111000,%eax
f010001a:	0f 22 d8             	mov    %eax,%cr3
f010001d:	0f 20 c0             	mov    %cr0,%eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
f0100025:	0f 22 c0             	mov    %eax,%cr0
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp
f0100034:	bc 00 10 11 f0       	mov    $0xf0111000,%esp
f0100039:	e8 03 01 00 00       	call   f0100141 <i386_init>

f010003e <spin>:
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_warn>:
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	53                   	push   %ebx
f0100044:	83 ec 14             	sub    $0x14,%esp
f0100047:	8d 5d 14             	lea    0x14(%ebp),%ebx
f010004a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010004d:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100051:	8b 45 08             	mov    0x8(%ebp),%eax
f0100054:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100058:	c7 04 24 a0 1e 10 f0 	movl   $0xf0101ea0,(%esp)
f010005f:	e8 eb 0a 00 00       	call   f0100b4f <cprintf>
f0100064:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100068:	8b 45 10             	mov    0x10(%ebp),%eax
f010006b:	89 04 24             	mov    %eax,(%esp)
f010006e:	e8 a9 0a 00 00       	call   f0100b1c <vcprintf>
f0100073:	c7 04 24 c5 1f 10 f0 	movl   $0xf0101fc5,(%esp)
f010007a:	e8 d0 0a 00 00       	call   f0100b4f <cprintf>
f010007f:	83 c4 14             	add    $0x14,%esp
f0100082:	5b                   	pop    %ebx
f0100083:	5d                   	pop    %ebp
f0100084:	c3                   	ret    

f0100085 <_panic>:
f0100085:	55                   	push   %ebp
f0100086:	89 e5                	mov    %esp,%ebp
f0100088:	56                   	push   %esi
f0100089:	53                   	push   %ebx
f010008a:	83 ec 10             	sub    $0x10,%esp
f010008d:	8b 75 10             	mov    0x10(%ebp),%esi
f0100090:	83 3d 00 33 11 f0 00 	cmpl   $0x0,0xf0113300
f0100097:	75 3d                	jne    f01000d6 <_panic+0x51>
f0100099:	89 35 00 33 11 f0    	mov    %esi,0xf0113300
f010009f:	fa                   	cli    
f01000a0:	fc                   	cld    
f01000a1:	8d 5d 14             	lea    0x14(%ebp),%ebx
f01000a4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01000a7:	89 44 24 08          	mov    %eax,0x8(%esp)
f01000ab:	8b 45 08             	mov    0x8(%ebp),%eax
f01000ae:	89 44 24 04          	mov    %eax,0x4(%esp)
f01000b2:	c7 04 24 ba 1e 10 f0 	movl   $0xf0101eba,(%esp)
f01000b9:	e8 91 0a 00 00       	call   f0100b4f <cprintf>
f01000be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01000c2:	89 34 24             	mov    %esi,(%esp)
f01000c5:	e8 52 0a 00 00       	call   f0100b1c <vcprintf>
f01000ca:	c7 04 24 c5 1f 10 f0 	movl   $0xf0101fc5,(%esp)
f01000d1:	e8 79 0a 00 00       	call   f0100b4f <cprintf>
f01000d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01000dd:	e8 40 08 00 00       	call   f0100922 <monitor>
f01000e2:	eb f2                	jmp    f01000d6 <_panic+0x51>

f01000e4 <test_backtrace>:
f01000e4:	55                   	push   %ebp
f01000e5:	89 e5                	mov    %esp,%ebp
f01000e7:	53                   	push   %ebx
f01000e8:	83 ec 14             	sub    $0x14,%esp
f01000eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01000ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01000f2:	c7 04 24 d2 1e 10 f0 	movl   $0xf0101ed2,(%esp)
f01000f9:	e8 51 0a 00 00       	call   f0100b4f <cprintf>
f01000fe:	85 db                	test   %ebx,%ebx
f0100100:	7e 0d                	jle    f010010f <test_backtrace+0x2b>
f0100102:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0100105:	89 04 24             	mov    %eax,(%esp)
f0100108:	e8 d7 ff ff ff       	call   f01000e4 <test_backtrace>
f010010d:	eb 1c                	jmp    f010012b <test_backtrace+0x47>
f010010f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100116:	00 
f0100117:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010011e:	00 
f010011f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100126:	e8 3e 09 00 00       	call   f0100a69 <mon_backtrace>
f010012b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010012f:	c7 04 24 ee 1e 10 f0 	movl   $0xf0101eee,(%esp)
f0100136:	e8 14 0a 00 00       	call   f0100b4f <cprintf>
f010013b:	83 c4 14             	add    $0x14,%esp
f010013e:	5b                   	pop    %ebx
f010013f:	5d                   	pop    %ebp
f0100140:	c3                   	ret    

f0100141 <i386_init>:
f0100141:	55                   	push   %ebp
f0100142:	89 e5                	mov    %esp,%ebp
f0100144:	57                   	push   %edi
f0100145:	53                   	push   %ebx
f0100146:	81 ec 20 01 00 00    	sub    $0x120,%esp
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
f010017f:	b8 60 39 11 f0       	mov    $0xf0113960,%eax
f0100184:	2d 00 33 11 f0       	sub    $0xf0113300,%eax
f0100189:	89 44 24 08          	mov    %eax,0x8(%esp)
f010018d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100194:	00 
f0100195:	c7 04 24 00 33 11 f0 	movl   $0xf0113300,(%esp)
f010019c:	e8 25 18 00 00       	call   f01019c6 <memset>
f01001a1:	e8 f4 03 00 00       	call   f010059a <cons_init>
f01001a6:	8d 45 f6             	lea    -0xa(%ebp),%eax
f01001a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01001ad:	8d 7d f7             	lea    -0x9(%ebp),%edi
f01001b0:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01001b4:	c7 44 24 04 ac 1a 00 	movl   $0x1aac,0x4(%esp)
f01001bb:	00 
f01001bc:	c7 04 24 50 1f 10 f0 	movl   $0xf0101f50,(%esp)
f01001c3:	e8 87 09 00 00       	call   f0100b4f <cprintf>
f01001c8:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
f01001cf:	00 
f01001d0:	c7 04 24 70 1f 10 f0 	movl   $0xf0101f70,(%esp)
f01001d7:	e8 73 09 00 00       	call   f0100b4f <cprintf>
f01001dc:	0f be 45 f6          	movsbl -0xa(%ebp),%eax
f01001e0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01001e4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
f01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01001ec:	c7 04 24 09 1f 10 f0 	movl   $0xf0101f09,(%esp)
f01001f3:	e8 57 09 00 00       	call   f0100b4f <cprintf>
f01001f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01001ff:	00 
f0100200:	c7 04 24 22 1f 10 f0 	movl   $0xf0101f22,(%esp)
f0100207:	e8 43 09 00 00       	call   f0100b4f <cprintf>
f010020c:	c7 44 24 08 ff 00 00 	movl   $0xff,0x8(%esp)
f0100213:	00 
f0100214:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
f010021b:	00 
f010021c:	8d 9d f6 fe ff ff    	lea    -0x10a(%ebp),%ebx
f0100222:	89 1c 24             	mov    %ebx,(%esp)
f0100225:	e8 9c 17 00 00       	call   f01019c6 <memset>
f010022a:	89 7c 24 08          	mov    %edi,0x8(%esp)
f010022e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100232:	c7 04 24 20 1f 10 f0 	movl   $0xf0101f20,(%esp)
f0100239:	e8 11 09 00 00       	call   f0100b4f <cprintf>
f010023e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
f0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100246:	c7 04 24 25 1f 10 f0 	movl   $0xf0101f25,(%esp)
f010024d:	e8 fd 08 00 00       	call   f0100b4f <cprintf>
f0100252:	c7 44 24 08 00 fc ff 	movl   $0xfffffc00,0x8(%esp)
f0100259:	ff 
f010025a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
f0100261:	00 
f0100262:	c7 04 24 31 1f 10 f0 	movl   $0xf0101f31,(%esp)
f0100269:	e8 e1 08 00 00       	call   f0100b4f <cprintf>
f010026e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f0100275:	e8 6a fe ff ff       	call   f01000e4 <test_backtrace>
f010027a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100281:	e8 9c 06 00 00       	call   f0100922 <monitor>
f0100286:	eb f2                	jmp    f010027a <i386_init+0x139>
	...

f0100290 <delay>:
f0100290:	55                   	push   %ebp
f0100291:	89 e5                	mov    %esp,%ebp
f0100293:	ba 84 00 00 00       	mov    $0x84,%edx
f0100298:	ec                   	in     (%dx),%al
f0100299:	ec                   	in     (%dx),%al
f010029a:	ec                   	in     (%dx),%al
f010029b:	ec                   	in     (%dx),%al
f010029c:	5d                   	pop    %ebp
f010029d:	c3                   	ret    

f010029e <serial_proc_data>:
f010029e:	55                   	push   %ebp
f010029f:	89 e5                	mov    %esp,%ebp
f01002a1:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01002a6:	ec                   	in     (%dx),%al
f01002a7:	89 c2                	mov    %eax,%edx
f01002a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01002ae:	f6 c2 01             	test   $0x1,%dl
f01002b1:	74 09                	je     f01002bc <serial_proc_data+0x1e>
f01002b3:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01002b8:	ec                   	in     (%dx),%al
f01002b9:	0f b6 c0             	movzbl %al,%eax
f01002bc:	5d                   	pop    %ebp
f01002bd:	c3                   	ret    

f01002be <cons_intr>:
f01002be:	55                   	push   %ebp
f01002bf:	89 e5                	mov    %esp,%ebp
f01002c1:	57                   	push   %edi
f01002c2:	56                   	push   %esi
f01002c3:	53                   	push   %ebx
f01002c4:	83 ec 0c             	sub    $0xc,%esp
f01002c7:	89 c6                	mov    %eax,%esi
f01002c9:	bb 44 35 11 f0       	mov    $0xf0113544,%ebx
f01002ce:	bf 40 33 11 f0       	mov    $0xf0113340,%edi
f01002d3:	eb 1e                	jmp    f01002f3 <cons_intr+0x35>
f01002d5:	85 c0                	test   %eax,%eax
f01002d7:	74 1a                	je     f01002f3 <cons_intr+0x35>
f01002d9:	8b 13                	mov    (%ebx),%edx
f01002db:	88 04 17             	mov    %al,(%edi,%edx,1)
f01002de:	8d 42 01             	lea    0x1(%edx),%eax
f01002e1:	3d 00 02 00 00       	cmp    $0x200,%eax
f01002e6:	0f 94 c2             	sete   %dl
f01002e9:	0f b6 d2             	movzbl %dl,%edx
f01002ec:	83 ea 01             	sub    $0x1,%edx
f01002ef:	21 d0                	and    %edx,%eax
f01002f1:	89 03                	mov    %eax,(%ebx)
f01002f3:	ff d6                	call   *%esi
f01002f5:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002f8:	75 db                	jne    f01002d5 <cons_intr+0x17>
f01002fa:	83 c4 0c             	add    $0xc,%esp
f01002fd:	5b                   	pop    %ebx
f01002fe:	5e                   	pop    %esi
f01002ff:	5f                   	pop    %edi
f0100300:	5d                   	pop    %ebp
f0100301:	c3                   	ret    

f0100302 <kbd_intr>:
f0100302:	55                   	push   %ebp
f0100303:	89 e5                	mov    %esp,%ebp
f0100305:	83 ec 08             	sub    $0x8,%esp
f0100308:	b8 8a 06 10 f0       	mov    $0xf010068a,%eax
f010030d:	e8 ac ff ff ff       	call   f01002be <cons_intr>
f0100312:	c9                   	leave  
f0100313:	c3                   	ret    

f0100314 <serial_intr>:
f0100314:	55                   	push   %ebp
f0100315:	89 e5                	mov    %esp,%ebp
f0100317:	83 ec 08             	sub    $0x8,%esp
f010031a:	83 3d 24 33 11 f0 00 	cmpl   $0x0,0xf0113324
f0100321:	74 0a                	je     f010032d <serial_intr+0x19>
f0100323:	b8 9e 02 10 f0       	mov    $0xf010029e,%eax
f0100328:	e8 91 ff ff ff       	call   f01002be <cons_intr>
f010032d:	c9                   	leave  
f010032e:	c3                   	ret    

f010032f <cons_getc>:
f010032f:	55                   	push   %ebp
f0100330:	89 e5                	mov    %esp,%ebp
f0100332:	83 ec 08             	sub    $0x8,%esp
f0100335:	e8 da ff ff ff       	call   f0100314 <serial_intr>
f010033a:	e8 c3 ff ff ff       	call   f0100302 <kbd_intr>
f010033f:	8b 15 40 35 11 f0    	mov    0xf0113540,%edx
f0100345:	b8 00 00 00 00       	mov    $0x0,%eax
f010034a:	3b 15 44 35 11 f0    	cmp    0xf0113544,%edx
f0100350:	74 21                	je     f0100373 <cons_getc+0x44>
f0100352:	0f b6 82 40 33 11 f0 	movzbl -0xfeeccc0(%edx),%eax
f0100359:	83 c2 01             	add    $0x1,%edx
f010035c:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f0100362:	0f 94 c1             	sete   %cl
f0100365:	0f b6 c9             	movzbl %cl,%ecx
f0100368:	83 e9 01             	sub    $0x1,%ecx
f010036b:	21 ca                	and    %ecx,%edx
f010036d:	89 15 40 35 11 f0    	mov    %edx,0xf0113540
f0100373:	c9                   	leave  
f0100374:	c3                   	ret    

f0100375 <getchar>:
f0100375:	55                   	push   %ebp
f0100376:	89 e5                	mov    %esp,%ebp
f0100378:	83 ec 08             	sub    $0x8,%esp
f010037b:	e8 af ff ff ff       	call   f010032f <cons_getc>
f0100380:	85 c0                	test   %eax,%eax
f0100382:	74 f7                	je     f010037b <getchar+0x6>
f0100384:	c9                   	leave  
f0100385:	c3                   	ret    

f0100386 <iscons>:
f0100386:	55                   	push   %ebp
f0100387:	89 e5                	mov    %esp,%ebp
f0100389:	b8 01 00 00 00       	mov    $0x1,%eax
f010038e:	5d                   	pop    %ebp
f010038f:	c3                   	ret    

f0100390 <cons_putc>:
f0100390:	55                   	push   %ebp
f0100391:	89 e5                	mov    %esp,%ebp
f0100393:	57                   	push   %edi
f0100394:	56                   	push   %esi
f0100395:	53                   	push   %ebx
f0100396:	83 ec 2c             	sub    $0x2c,%esp
f0100399:	89 c7                	mov    %eax,%edi
f010039b:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01003a0:	ec                   	in     (%dx),%al
f01003a1:	a8 20                	test   $0x20,%al
f01003a3:	75 21                	jne    f01003c6 <cons_putc+0x36>
f01003a5:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003aa:	be fd 03 00 00       	mov    $0x3fd,%esi
f01003af:	e8 dc fe ff ff       	call   f0100290 <delay>
f01003b4:	89 f2                	mov    %esi,%edx
f01003b6:	ec                   	in     (%dx),%al
f01003b7:	a8 20                	test   $0x20,%al
f01003b9:	75 0b                	jne    f01003c6 <cons_putc+0x36>
f01003bb:	83 c3 01             	add    $0x1,%ebx
f01003be:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
f01003c4:	75 e9                	jne    f01003af <cons_putc+0x1f>
f01003c6:	89 fa                	mov    %edi,%edx
f01003c8:	89 f8                	mov    %edi,%eax
f01003ca:	88 55 e7             	mov    %dl,-0x19(%ebp)
f01003cd:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01003d2:	ee                   	out    %al,(%dx)
f01003d3:	b2 79                	mov    $0x79,%dl
f01003d5:	ec                   	in     (%dx),%al
f01003d6:	84 c0                	test   %al,%al
f01003d8:	78 21                	js     f01003fb <cons_putc+0x6b>
f01003da:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003df:	be 79 03 00 00       	mov    $0x379,%esi
f01003e4:	e8 a7 fe ff ff       	call   f0100290 <delay>
f01003e9:	89 f2                	mov    %esi,%edx
f01003eb:	ec                   	in     (%dx),%al
f01003ec:	84 c0                	test   %al,%al
f01003ee:	78 0b                	js     f01003fb <cons_putc+0x6b>
f01003f0:	83 c3 01             	add    $0x1,%ebx
f01003f3:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
f01003f9:	75 e9                	jne    f01003e4 <cons_putc+0x54>
f01003fb:	ba 78 03 00 00       	mov    $0x378,%edx
f0100400:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100404:	ee                   	out    %al,(%dx)
f0100405:	b2 7a                	mov    $0x7a,%dl
f0100407:	b8 0d 00 00 00       	mov    $0xd,%eax
f010040c:	ee                   	out    %al,(%dx)
f010040d:	b8 08 00 00 00       	mov    $0x8,%eax
f0100412:	ee                   	out    %al,(%dx)
f0100413:	f7 c7 00 ff ff ff    	test   $0xffffff00,%edi
f0100419:	75 06                	jne    f0100421 <cons_putc+0x91>
f010041b:	81 cf 00 07 00 00    	or     $0x700,%edi
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
f010045a:	0f b7 05 30 33 11 f0 	movzwl 0xf0113330,%eax
f0100461:	66 85 c0             	test   %ax,%ax
f0100464:	0f 84 e8 00 00 00    	je     f0100552 <cons_putc+0x1c2>
f010046a:	83 e8 01             	sub    $0x1,%eax
f010046d:	66 a3 30 33 11 f0    	mov    %ax,0xf0113330
f0100473:	0f b7 c0             	movzwl %ax,%eax
f0100476:	66 81 e7 00 ff       	and    $0xff00,%di
f010047b:	83 cf 20             	or     $0x20,%edi
f010047e:	8b 15 2c 33 11 f0    	mov    0xf011332c,%edx
f0100484:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100488:	eb 7b                	jmp    f0100505 <cons_putc+0x175>
f010048a:	66 83 05 30 33 11 f0 	addw   $0x50,0xf0113330
f0100491:	50 
f0100492:	0f b7 05 30 33 11 f0 	movzwl 0xf0113330,%eax
f0100499:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f010049f:	c1 e8 10             	shr    $0x10,%eax
f01004a2:	66 c1 e8 06          	shr    $0x6,%ax
f01004a6:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004a9:	c1 e0 04             	shl    $0x4,%eax
f01004ac:	66 a3 30 33 11 f0    	mov    %ax,0xf0113330
f01004b2:	eb 51                	jmp    f0100505 <cons_putc+0x175>
f01004b4:	b8 20 00 00 00       	mov    $0x20,%eax
f01004b9:	e8 d2 fe ff ff       	call   f0100390 <cons_putc>
f01004be:	b8 20 00 00 00       	mov    $0x20,%eax
f01004c3:	e8 c8 fe ff ff       	call   f0100390 <cons_putc>
f01004c8:	b8 20 00 00 00       	mov    $0x20,%eax
f01004cd:	e8 be fe ff ff       	call   f0100390 <cons_putc>
f01004d2:	b8 20 00 00 00       	mov    $0x20,%eax
f01004d7:	e8 b4 fe ff ff       	call   f0100390 <cons_putc>
f01004dc:	b8 20 00 00 00       	mov    $0x20,%eax
f01004e1:	e8 aa fe ff ff       	call   f0100390 <cons_putc>
f01004e6:	eb 1d                	jmp    f0100505 <cons_putc+0x175>
f01004e8:	0f b7 05 30 33 11 f0 	movzwl 0xf0113330,%eax
f01004ef:	0f b7 c8             	movzwl %ax,%ecx
f01004f2:	8b 15 2c 33 11 f0    	mov    0xf011332c,%edx
f01004f8:	66 89 3c 4a          	mov    %di,(%edx,%ecx,2)
f01004fc:	83 c0 01             	add    $0x1,%eax
f01004ff:	66 a3 30 33 11 f0    	mov    %ax,0xf0113330
f0100505:	66 81 3d 30 33 11 f0 	cmpw   $0x7cf,0xf0113330
f010050c:	cf 07 
f010050e:	76 42                	jbe    f0100552 <cons_putc+0x1c2>
f0100510:	a1 2c 33 11 f0       	mov    0xf011332c,%eax
f0100515:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
f010051c:	00 
f010051d:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100523:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100527:	89 04 24             	mov    %eax,(%esp)
f010052a:	e8 f6 14 00 00       	call   f0101a25 <memmove>
f010052f:	8b 15 2c 33 11 f0    	mov    0xf011332c,%edx
f0100535:	b8 80 07 00 00       	mov    $0x780,%eax
f010053a:	66 c7 04 42 20 07    	movw   $0x720,(%edx,%eax,2)
f0100540:	83 c0 01             	add    $0x1,%eax
f0100543:	3d d0 07 00 00       	cmp    $0x7d0,%eax
f0100548:	75 f0                	jne    f010053a <cons_putc+0x1aa>
f010054a:	66 83 2d 30 33 11 f0 	subw   $0x50,0xf0113330
f0100551:	50 
f0100552:	8b 0d 28 33 11 f0    	mov    0xf0113328,%ecx
f0100558:	89 cb                	mov    %ecx,%ebx
f010055a:	b8 0e 00 00 00       	mov    $0xe,%eax
f010055f:	89 ca                	mov    %ecx,%edx
f0100561:	ee                   	out    %al,(%dx)
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
f0100582:	83 c4 2c             	add    $0x2c,%esp
f0100585:	5b                   	pop    %ebx
f0100586:	5e                   	pop    %esi
f0100587:	5f                   	pop    %edi
f0100588:	5d                   	pop    %ebp
f0100589:	c3                   	ret    

f010058a <cputchar>:
f010058a:	55                   	push   %ebp
f010058b:	89 e5                	mov    %esp,%ebp
f010058d:	83 ec 08             	sub    $0x8,%esp
f0100590:	8b 45 08             	mov    0x8(%ebp),%eax
f0100593:	e8 f8 fd ff ff       	call   f0100390 <cons_putc>
f0100598:	c9                   	leave  
f0100599:	c3                   	ret    

f010059a <cons_init>:
f010059a:	55                   	push   %ebp
f010059b:	89 e5                	mov    %esp,%ebp
f010059d:	57                   	push   %edi
f010059e:	56                   	push   %esi
f010059f:	53                   	push   %ebx
f01005a0:	83 ec 1c             	sub    $0x1c,%esp
f01005a3:	b8 00 80 0b f0       	mov    $0xf00b8000,%eax
f01005a8:	0f b7 10             	movzwl (%eax),%edx
f01005ab:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
f01005b0:	0f b7 00             	movzwl (%eax),%eax
f01005b3:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01005b7:	74 11                	je     f01005ca <cons_init+0x30>
f01005b9:	c7 05 28 33 11 f0 b4 	movl   $0x3b4,0xf0113328
f01005c0:	03 00 00 
f01005c3:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
f01005c8:	eb 16                	jmp    f01005e0 <cons_init+0x46>
f01005ca:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
f01005d1:	c7 05 28 33 11 f0 d4 	movl   $0x3d4,0xf0113328
f01005d8:	03 00 00 
f01005db:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f01005e0:	8b 0d 28 33 11 f0    	mov    0xf0113328,%ecx
f01005e6:	89 cb                	mov    %ecx,%ebx
f01005e8:	b8 0e 00 00 00       	mov    $0xe,%eax
f01005ed:	89 ca                	mov    %ecx,%edx
f01005ef:	ee                   	out    %al,(%dx)
f01005f0:	83 c1 01             	add    $0x1,%ecx
f01005f3:	89 ca                	mov    %ecx,%edx
f01005f5:	ec                   	in     (%dx),%al
f01005f6:	0f b6 f8             	movzbl %al,%edi
f01005f9:	c1 e7 08             	shl    $0x8,%edi
f01005fc:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100601:	89 da                	mov    %ebx,%edx
f0100603:	ee                   	out    %al,(%dx)
f0100604:	89 ca                	mov    %ecx,%edx
f0100606:	ec                   	in     (%dx),%al
f0100607:	89 35 2c 33 11 f0    	mov    %esi,0xf011332c
f010060d:	0f b6 c8             	movzbl %al,%ecx
f0100610:	09 cf                	or     %ecx,%edi
f0100612:	66 89 3d 30 33 11 f0 	mov    %di,0xf0113330
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
f010065b:	b2 fd                	mov    $0xfd,%dl
f010065d:	ec                   	in     (%dx),%al
f010065e:	3c ff                	cmp    $0xff,%al
f0100660:	0f 95 c0             	setne  %al
f0100663:	0f b6 f0             	movzbl %al,%esi
f0100666:	89 35 24 33 11 f0    	mov    %esi,0xf0113324
f010066c:	89 da                	mov    %ebx,%edx
f010066e:	ec                   	in     (%dx),%al
f010066f:	89 ca                	mov    %ecx,%edx
f0100671:	ec                   	in     (%dx),%al
f0100672:	85 f6                	test   %esi,%esi
f0100674:	75 0c                	jne    f0100682 <cons_init+0xe8>
f0100676:	c7 04 24 9e 1f 10 f0 	movl   $0xf0101f9e,(%esp)
f010067d:	e8 cd 04 00 00       	call   f0100b4f <cprintf>
f0100682:	83 c4 1c             	add    $0x1c,%esp
f0100685:	5b                   	pop    %ebx
f0100686:	5e                   	pop    %esi
f0100687:	5f                   	pop    %edi
f0100688:	5d                   	pop    %ebp
f0100689:	c3                   	ret    

f010068a <kbd_proc_data>:
f010068a:	55                   	push   %ebp
f010068b:	89 e5                	mov    %esp,%ebp
f010068d:	53                   	push   %ebx
f010068e:	83 ec 14             	sub    $0x14,%esp
f0100691:	ba 64 00 00 00       	mov    $0x64,%edx
f0100696:	ec                   	in     (%dx),%al
f0100697:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f010069c:	a8 01                	test   $0x1,%al
f010069e:	0f 84 d9 00 00 00    	je     f010077d <kbd_proc_data+0xf3>
f01006a4:	b2 60                	mov    $0x60,%dl
f01006a6:	ec                   	in     (%dx),%al
f01006a7:	3c e0                	cmp    $0xe0,%al
f01006a9:	75 11                	jne    f01006bc <kbd_proc_data+0x32>
f01006ab:	83 0d 20 33 11 f0 40 	orl    $0x40,0xf0113320
f01006b2:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006b7:	e9 c1 00 00 00       	jmp    f010077d <kbd_proc_data+0xf3>
f01006bc:	84 c0                	test   %al,%al
f01006be:	79 32                	jns    f01006f2 <kbd_proc_data+0x68>
f01006c0:	8b 15 20 33 11 f0    	mov    0xf0113320,%edx
f01006c6:	f6 c2 40             	test   $0x40,%dl
f01006c9:	75 03                	jne    f01006ce <kbd_proc_data+0x44>
f01006cb:	83 e0 7f             	and    $0x7f,%eax
f01006ce:	0f b6 c0             	movzbl %al,%eax
f01006d1:	0f b6 80 e0 1f 10 f0 	movzbl -0xfefe020(%eax),%eax
f01006d8:	83 c8 40             	or     $0x40,%eax
f01006db:	0f b6 c0             	movzbl %al,%eax
f01006de:	f7 d0                	not    %eax
f01006e0:	21 c2                	and    %eax,%edx
f01006e2:	89 15 20 33 11 f0    	mov    %edx,0xf0113320
f01006e8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006ed:	e9 8b 00 00 00       	jmp    f010077d <kbd_proc_data+0xf3>
f01006f2:	8b 15 20 33 11 f0    	mov    0xf0113320,%edx
f01006f8:	f6 c2 40             	test   $0x40,%dl
f01006fb:	74 0c                	je     f0100709 <kbd_proc_data+0x7f>
f01006fd:	83 c8 80             	or     $0xffffff80,%eax
f0100700:	83 e2 bf             	and    $0xffffffbf,%edx
f0100703:	89 15 20 33 11 f0    	mov    %edx,0xf0113320
f0100709:	0f b6 c0             	movzbl %al,%eax
f010070c:	0f b6 90 e0 1f 10 f0 	movzbl -0xfefe020(%eax),%edx
f0100713:	0b 15 20 33 11 f0    	or     0xf0113320,%edx
f0100719:	0f b6 88 e0 20 10 f0 	movzbl -0xfefdf20(%eax),%ecx
f0100720:	31 ca                	xor    %ecx,%edx
f0100722:	89 15 20 33 11 f0    	mov    %edx,0xf0113320
f0100728:	89 d1                	mov    %edx,%ecx
f010072a:	83 e1 03             	and    $0x3,%ecx
f010072d:	8b 0c 8d e0 21 10 f0 	mov    -0xfefde20(,%ecx,4),%ecx
f0100734:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
f0100738:	f6 c2 08             	test   $0x8,%dl
f010073b:	74 1a                	je     f0100757 <kbd_proc_data+0xcd>
f010073d:	89 d9                	mov    %ebx,%ecx
f010073f:	8d 43 9f             	lea    -0x61(%ebx),%eax
f0100742:	83 f8 19             	cmp    $0x19,%eax
f0100745:	77 05                	ja     f010074c <kbd_proc_data+0xc2>
f0100747:	83 eb 20             	sub    $0x20,%ebx
f010074a:	eb 0b                	jmp    f0100757 <kbd_proc_data+0xcd>
f010074c:	83 e9 41             	sub    $0x41,%ecx
f010074f:	83 f9 19             	cmp    $0x19,%ecx
f0100752:	77 03                	ja     f0100757 <kbd_proc_data+0xcd>
f0100754:	83 c3 20             	add    $0x20,%ebx
f0100757:	f7 d2                	not    %edx
f0100759:	f6 c2 06             	test   $0x6,%dl
f010075c:	75 1f                	jne    f010077d <kbd_proc_data+0xf3>
f010075e:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100764:	75 17                	jne    f010077d <kbd_proc_data+0xf3>
f0100766:	c7 04 24 bb 1f 10 f0 	movl   $0xf0101fbb,(%esp)
f010076d:	e8 dd 03 00 00       	call   f0100b4f <cprintf>
f0100772:	ba 92 00 00 00       	mov    $0x92,%edx
f0100777:	b8 03 00 00 00       	mov    $0x3,%eax
f010077c:	ee                   	out    %al,(%dx)
f010077d:	89 d8                	mov    %ebx,%eax
f010077f:	83 c4 14             	add    $0x14,%esp
f0100782:	5b                   	pop    %ebx
f0100783:	5d                   	pop    %ebp
f0100784:	c3                   	ret    
	...

f0100790 <getbuff>:
f0100790:	55                   	push   %ebp
f0100791:	89 e5                	mov    %esp,%ebp
f0100793:	8b 45 08             	mov    0x8(%ebp),%eax
f0100796:	8d 55 04             	lea    0x4(%ebp),%edx
f0100799:	8b 12                	mov    (%edx),%edx
f010079b:	89 10                	mov    %edx,(%eax)
f010079d:	8d 50 04             	lea    0x4(%eax),%edx
f01007a0:	89 50 f8             	mov    %edx,-0x8(%eax)
f01007a3:	5d                   	pop    %ebp
f01007a4:	c3                   	ret    

f01007a5 <start_overflow>:
f01007a5:	55                   	push   %ebp
f01007a6:	89 e5                	mov    %esp,%ebp
f01007a8:	57                   	push   %edi
f01007a9:	81 ec 04 01 00 00    	sub    $0x104,%esp
f01007af:	8d bd fc fe ff ff    	lea    -0x104(%ebp),%edi
f01007b5:	b9 40 00 00 00       	mov    $0x40,%ecx
f01007ba:	b8 00 00 00 00       	mov    $0x0,%eax
f01007bf:	f3 ab                	rep stos %eax,%es:(%edi)
f01007c1:	8d 85 fc fe ff ff    	lea    -0x104(%ebp),%eax
f01007c7:	c7 40 04 ff 74 24 04 	movl   $0x42474ff,0x4(%eax)
f01007ce:	c7 40 08 55 89 e5 83 	movl   $0x83e58955,0x8(%eax)
f01007d5:	c7 40 0c ec 18 c7 04 	movl   $0x4c718ec,0xc(%eax)
f01007dc:	c7 40 10 24 f0 21 10 	movl   $0x1021f024,0x10(%eax)
f01007e3:	c7 40 14 f0 e8 29 03 	movl   $0x329e8f0,0x14(%eax)
f01007ea:	c7 40 18 00 00 c9 c3 	movl   $0xc3c90000,0x18(%eax)
f01007f1:	89 04 24             	mov    %eax,(%esp)
f01007f4:	e8 97 ff ff ff       	call   f0100790 <getbuff>
f01007f9:	81 c4 04 01 00 00    	add    $0x104,%esp
f01007ff:	5f                   	pop    %edi
f0100800:	5d                   	pop    %ebp
f0100801:	c3                   	ret    

f0100802 <overflow_me>:
f0100802:	55                   	push   %ebp
f0100803:	89 e5                	mov    %esp,%ebp
f0100805:	e8 9b ff ff ff       	call   f01007a5 <start_overflow>
f010080a:	5d                   	pop    %ebp
f010080b:	c3                   	ret    

f010080c <read_eip>:
f010080c:	55                   	push   %ebp
f010080d:	89 e5                	mov    %esp,%ebp
f010080f:	8b 45 04             	mov    0x4(%ebp),%eax
f0100812:	5d                   	pop    %ebp
f0100813:	c3                   	ret    

f0100814 <do_overflow>:
f0100814:	55                   	push   %ebp
f0100815:	89 e5                	mov    %esp,%ebp
f0100817:	83 ec 18             	sub    $0x18,%esp
f010081a:	c7 04 24 f0 21 10 f0 	movl   $0xf01021f0,(%esp)
f0100821:	e8 29 03 00 00       	call   f0100b4f <cprintf>
f0100826:	c9                   	leave  
f0100827:	c3                   	ret    

f0100828 <mon_kerninfo>:
f0100828:	55                   	push   %ebp
f0100829:	89 e5                	mov    %esp,%ebp
f010082b:	83 ec 18             	sub    $0x18,%esp
f010082e:	c7 04 24 02 22 10 f0 	movl   $0xf0102202,(%esp)
f0100835:	e8 15 03 00 00       	call   f0100b4f <cprintf>
f010083a:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f0100841:	00 
f0100842:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f0100849:	f0 
f010084a:	c7 04 24 b0 22 10 f0 	movl   $0xf01022b0,(%esp)
f0100851:	e8 f9 02 00 00       	call   f0100b4f <cprintf>
f0100856:	c7 44 24 08 95 1e 10 	movl   $0x101e95,0x8(%esp)
f010085d:	00 
f010085e:	c7 44 24 04 95 1e 10 	movl   $0xf0101e95,0x4(%esp)
f0100865:	f0 
f0100866:	c7 04 24 d4 22 10 f0 	movl   $0xf01022d4,(%esp)
f010086d:	e8 dd 02 00 00       	call   f0100b4f <cprintf>
f0100872:	c7 44 24 08 00 33 11 	movl   $0x113300,0x8(%esp)
f0100879:	00 
f010087a:	c7 44 24 04 00 33 11 	movl   $0xf0113300,0x4(%esp)
f0100881:	f0 
f0100882:	c7 04 24 f8 22 10 f0 	movl   $0xf01022f8,(%esp)
f0100889:	e8 c1 02 00 00       	call   f0100b4f <cprintf>
f010088e:	c7 44 24 08 60 39 11 	movl   $0x113960,0x8(%esp)
f0100895:	00 
f0100896:	c7 44 24 04 60 39 11 	movl   $0xf0113960,0x4(%esp)
f010089d:	f0 
f010089e:	c7 04 24 1c 23 10 f0 	movl   $0xf010231c,(%esp)
f01008a5:	e8 a5 02 00 00       	call   f0100b4f <cprintf>
f01008aa:	b8 5f 3d 11 f0       	mov    $0xf0113d5f,%eax
f01008af:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f01008b4:	89 c2                	mov    %eax,%edx
f01008b6:	c1 fa 1f             	sar    $0x1f,%edx
f01008b9:	c1 ea 16             	shr    $0x16,%edx
f01008bc:	8d 04 02             	lea    (%edx,%eax,1),%eax
f01008bf:	c1 f8 0a             	sar    $0xa,%eax
f01008c2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01008c6:	c7 04 24 40 23 10 f0 	movl   $0xf0102340,(%esp)
f01008cd:	e8 7d 02 00 00       	call   f0100b4f <cprintf>
f01008d2:	b8 00 00 00 00       	mov    $0x0,%eax
f01008d7:	c9                   	leave  
f01008d8:	c3                   	ret    

f01008d9 <mon_help>:
f01008d9:	55                   	push   %ebp
f01008da:	89 e5                	mov    %esp,%ebp
f01008dc:	83 ec 18             	sub    $0x18,%esp
f01008df:	a1 18 24 10 f0       	mov    0xf0102418,%eax
f01008e4:	89 44 24 08          	mov    %eax,0x8(%esp)
f01008e8:	a1 14 24 10 f0       	mov    0xf0102414,%eax
f01008ed:	89 44 24 04          	mov    %eax,0x4(%esp)
f01008f1:	c7 04 24 1b 22 10 f0 	movl   $0xf010221b,(%esp)
f01008f8:	e8 52 02 00 00       	call   f0100b4f <cprintf>
f01008fd:	a1 24 24 10 f0       	mov    0xf0102424,%eax
f0100902:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100906:	a1 20 24 10 f0       	mov    0xf0102420,%eax
f010090b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010090f:	c7 04 24 1b 22 10 f0 	movl   $0xf010221b,(%esp)
f0100916:	e8 34 02 00 00       	call   f0100b4f <cprintf>
f010091b:	b8 00 00 00 00       	mov    $0x0,%eax
f0100920:	c9                   	leave  
f0100921:	c3                   	ret    

f0100922 <monitor>:
f0100922:	55                   	push   %ebp
f0100923:	89 e5                	mov    %esp,%ebp
f0100925:	57                   	push   %edi
f0100926:	56                   	push   %esi
f0100927:	53                   	push   %ebx
f0100928:	83 ec 5c             	sub    $0x5c,%esp
f010092b:	c7 04 24 6c 23 10 f0 	movl   $0xf010236c,(%esp)
f0100932:	e8 18 02 00 00       	call   f0100b4f <cprintf>
f0100937:	c7 04 24 90 23 10 f0 	movl   $0xf0102390,(%esp)
f010093e:	e8 0c 02 00 00       	call   f0100b4f <cprintf>
f0100943:	bf 14 24 10 f0       	mov    $0xf0102414,%edi
f0100948:	c7 04 24 24 22 10 f0 	movl   $0xf0102224,(%esp)
f010094f:	e8 ec 0d 00 00       	call   f0101740 <readline>
f0100954:	89 c3                	mov    %eax,%ebx
f0100956:	85 c0                	test   %eax,%eax
f0100958:	74 ee                	je     f0100948 <monitor+0x26>
f010095a:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
f0100961:	be 00 00 00 00       	mov    $0x0,%esi
f0100966:	eb 06                	jmp    f010096e <monitor+0x4c>
f0100968:	c6 03 00             	movb   $0x0,(%ebx)
f010096b:	83 c3 01             	add    $0x1,%ebx
f010096e:	0f b6 03             	movzbl (%ebx),%eax
f0100971:	84 c0                	test   %al,%al
f0100973:	74 6a                	je     f01009df <monitor+0xbd>
f0100975:	0f be c0             	movsbl %al,%eax
f0100978:	89 44 24 04          	mov    %eax,0x4(%esp)
f010097c:	c7 04 24 28 22 10 f0 	movl   $0xf0102228,(%esp)
f0100983:	e8 e6 0f 00 00       	call   f010196e <strchr>
f0100988:	85 c0                	test   %eax,%eax
f010098a:	75 dc                	jne    f0100968 <monitor+0x46>
f010098c:	80 3b 00             	cmpb   $0x0,(%ebx)
f010098f:	74 4e                	je     f01009df <monitor+0xbd>
f0100991:	83 fe 0f             	cmp    $0xf,%esi
f0100994:	75 16                	jne    f01009ac <monitor+0x8a>
f0100996:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f010099d:	00 
f010099e:	c7 04 24 2d 22 10 f0 	movl   $0xf010222d,(%esp)
f01009a5:	e8 a5 01 00 00       	call   f0100b4f <cprintf>
f01009aa:	eb 9c                	jmp    f0100948 <monitor+0x26>
f01009ac:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f01009b0:	83 c6 01             	add    $0x1,%esi
f01009b3:	0f b6 03             	movzbl (%ebx),%eax
f01009b6:	84 c0                	test   %al,%al
f01009b8:	75 0c                	jne    f01009c6 <monitor+0xa4>
f01009ba:	eb b2                	jmp    f010096e <monitor+0x4c>
f01009bc:	83 c3 01             	add    $0x1,%ebx
f01009bf:	0f b6 03             	movzbl (%ebx),%eax
f01009c2:	84 c0                	test   %al,%al
f01009c4:	74 a8                	je     f010096e <monitor+0x4c>
f01009c6:	0f be c0             	movsbl %al,%eax
f01009c9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009cd:	c7 04 24 28 22 10 f0 	movl   $0xf0102228,(%esp)
f01009d4:	e8 95 0f 00 00       	call   f010196e <strchr>
f01009d9:	85 c0                	test   %eax,%eax
f01009db:	74 df                	je     f01009bc <monitor+0x9a>
f01009dd:	eb 8f                	jmp    f010096e <monitor+0x4c>
f01009df:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01009e6:	00 
f01009e7:	85 f6                	test   %esi,%esi
f01009e9:	0f 84 59 ff ff ff    	je     f0100948 <monitor+0x26>
f01009ef:	8b 07                	mov    (%edi),%eax
f01009f1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009f5:	8b 45 a8             	mov    -0x58(%ebp),%eax
f01009f8:	89 04 24             	mov    %eax,(%esp)
f01009fb:	e8 f9 0e 00 00       	call   f01018f9 <strcmp>
f0100a00:	ba 00 00 00 00       	mov    $0x0,%edx
f0100a05:	85 c0                	test   %eax,%eax
f0100a07:	74 1d                	je     f0100a26 <monitor+0x104>
f0100a09:	a1 20 24 10 f0       	mov    0xf0102420,%eax
f0100a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a12:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100a15:	89 04 24             	mov    %eax,(%esp)
f0100a18:	e8 dc 0e 00 00       	call   f01018f9 <strcmp>
f0100a1d:	85 c0                	test   %eax,%eax
f0100a1f:	75 28                	jne    f0100a49 <monitor+0x127>
f0100a21:	ba 01 00 00 00       	mov    $0x1,%edx
f0100a26:	6b d2 0c             	imul   $0xc,%edx,%edx
f0100a29:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a2c:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100a30:	8d 45 a8             	lea    -0x58(%ebp),%eax
f0100a33:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a37:	89 34 24             	mov    %esi,(%esp)
f0100a3a:	ff 92 1c 24 10 f0    	call   *-0xfefdbe4(%edx)
f0100a40:	85 c0                	test   %eax,%eax
f0100a42:	78 1d                	js     f0100a61 <monitor+0x13f>
f0100a44:	e9 ff fe ff ff       	jmp    f0100948 <monitor+0x26>
f0100a49:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a50:	c7 04 24 4a 22 10 f0 	movl   $0xf010224a,(%esp)
f0100a57:	e8 f3 00 00 00       	call   f0100b4f <cprintf>
f0100a5c:	e9 e7 fe ff ff       	jmp    f0100948 <monitor+0x26>
f0100a61:	83 c4 5c             	add    $0x5c,%esp
f0100a64:	5b                   	pop    %ebx
f0100a65:	5e                   	pop    %esi
f0100a66:	5f                   	pop    %edi
f0100a67:	5d                   	pop    %ebp
f0100a68:	c3                   	ret    

f0100a69 <mon_backtrace>:
f0100a69:	55                   	push   %ebp
f0100a6a:	89 e5                	mov    %esp,%ebp
f0100a6c:	57                   	push   %edi
f0100a6d:	56                   	push   %esi
f0100a6e:	53                   	push   %ebx
f0100a6f:	83 ec 4c             	sub    $0x4c,%esp
f0100a72:	89 eb                	mov    %ebp,%ebx
f0100a74:	bf 00 00 00 00       	mov    $0x0,%edi
f0100a79:	8d 73 04             	lea    0x4(%ebx),%esi
f0100a7c:	8b 43 18             	mov    0x18(%ebx),%eax
f0100a7f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f0100a83:	8b 43 14             	mov    0x14(%ebx),%eax
f0100a86:	89 44 24 18          	mov    %eax,0x18(%esp)
f0100a8a:	8b 43 10             	mov    0x10(%ebx),%eax
f0100a8d:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100a91:	8b 43 0c             	mov    0xc(%ebx),%eax
f0100a94:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100a98:	8b 43 08             	mov    0x8(%ebx),%eax
f0100a9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100a9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0100aa3:	8b 06                	mov    (%esi),%eax
f0100aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100aa9:	c7 04 24 b8 23 10 f0 	movl   $0xf01023b8,(%esp)
f0100ab0:	e8 9a 00 00 00       	call   f0100b4f <cprintf>
f0100ab5:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0100ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100abc:	8b 06                	mov    (%esi),%eax
f0100abe:	89 04 24             	mov    %eax,(%esp)
f0100ac1:	e8 f8 01 00 00       	call   f0100cbe <debuginfo_eip>
f0100ac6:	8b 06                	mov    (%esi),%eax
f0100ac8:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100acb:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100acf:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100ad2:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100ad6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100ad9:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100add:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0100ae0:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ae4:	c7 04 24 60 22 10 f0 	movl   $0xf0102260,(%esp)
f0100aeb:	e8 5f 00 00 00       	call   f0100b4f <cprintf>
f0100af0:	8b 1b                	mov    (%ebx),%ebx
f0100af2:	83 c7 01             	add    $0x1,%edi
f0100af5:	83 ff 07             	cmp    $0x7,%edi
f0100af8:	0f 85 7b ff ff ff    	jne    f0100a79 <mon_backtrace+0x10>
f0100afe:	e8 ff fc ff ff       	call   f0100802 <overflow_me>
f0100b03:	c7 04 24 6f 22 10 f0 	movl   $0xf010226f,(%esp)
f0100b0a:	e8 40 00 00 00       	call   f0100b4f <cprintf>
f0100b0f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b14:	83 c4 4c             	add    $0x4c,%esp
f0100b17:	5b                   	pop    %ebx
f0100b18:	5e                   	pop    %esi
f0100b19:	5f                   	pop    %edi
f0100b1a:	5d                   	pop    %ebp
f0100b1b:	c3                   	ret    

f0100b1c <vcprintf>:
f0100b1c:	55                   	push   %ebp
f0100b1d:	89 e5                	mov    %esp,%ebp
f0100b1f:	83 ec 28             	sub    $0x28,%esp
f0100b22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0100b29:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100b2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100b30:	8b 45 08             	mov    0x8(%ebp),%eax
f0100b33:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100b37:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b3e:	c7 04 24 69 0b 10 f0 	movl   $0xf0100b69,(%esp)
f0100b45:	e8 bd 06 00 00       	call   f0101207 <vprintfmt>
f0100b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100b4d:	c9                   	leave  
f0100b4e:	c3                   	ret    

f0100b4f <cprintf>:
f0100b4f:	55                   	push   %ebp
f0100b50:	89 e5                	mov    %esp,%ebp
f0100b52:	83 ec 18             	sub    $0x18,%esp
f0100b55:	8d 45 0c             	lea    0xc(%ebp),%eax
f0100b58:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b5c:	8b 45 08             	mov    0x8(%ebp),%eax
f0100b5f:	89 04 24             	mov    %eax,(%esp)
f0100b62:	e8 b5 ff ff ff       	call   f0100b1c <vcprintf>
f0100b67:	c9                   	leave  
f0100b68:	c3                   	ret    

f0100b69 <putch>:
f0100b69:	55                   	push   %ebp
f0100b6a:	89 e5                	mov    %esp,%ebp
f0100b6c:	53                   	push   %ebx
f0100b6d:	83 ec 14             	sub    $0x14,%esp
f0100b70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0100b73:	8b 45 08             	mov    0x8(%ebp),%eax
f0100b76:	89 04 24             	mov    %eax,(%esp)
f0100b79:	e8 0c fa ff ff       	call   f010058a <cputchar>
f0100b7e:	83 03 01             	addl   $0x1,(%ebx)
f0100b81:	83 c4 14             	add    $0x14,%esp
f0100b84:	5b                   	pop    %ebx
f0100b85:	5d                   	pop    %ebp
f0100b86:	c3                   	ret    
	...

f0100b90 <stab_binsearch>:
f0100b90:	55                   	push   %ebp
f0100b91:	89 e5                	mov    %esp,%ebp
f0100b93:	57                   	push   %edi
f0100b94:	56                   	push   %esi
f0100b95:	53                   	push   %ebx
f0100b96:	83 ec 14             	sub    $0x14,%esp
f0100b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100b9c:	89 55 e8             	mov    %edx,-0x18(%ebp)
f0100b9f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0100ba2:	8b 75 08             	mov    0x8(%ebp),%esi
f0100ba5:	8b 1a                	mov    (%edx),%ebx
f0100ba7:	8b 01                	mov    (%ecx),%eax
f0100ba9:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0100bac:	39 c3                	cmp    %eax,%ebx
f0100bae:	0f 8f 9c 00 00 00    	jg     f0100c50 <stab_binsearch+0xc0>
f0100bb4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0100bbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0100bbe:	01 d8                	add    %ebx,%eax
f0100bc0:	89 c7                	mov    %eax,%edi
f0100bc2:	c1 ef 1f             	shr    $0x1f,%edi
f0100bc5:	01 c7                	add    %eax,%edi
f0100bc7:	d1 ff                	sar    %edi
f0100bc9:	39 df                	cmp    %ebx,%edi
f0100bcb:	7c 33                	jl     f0100c00 <stab_binsearch+0x70>
f0100bcd:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100bd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0100bd3:	0f b6 44 82 04       	movzbl 0x4(%edx,%eax,4),%eax
f0100bd8:	39 f0                	cmp    %esi,%eax
f0100bda:	0f 84 bc 00 00 00    	je     f0100c9c <stab_binsearch+0x10c>
f0100be0:	8d 44 7f fd          	lea    -0x3(%edi,%edi,2),%eax
f0100be4:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx
f0100be8:	89 f8                	mov    %edi,%eax
f0100bea:	83 e8 01             	sub    $0x1,%eax
f0100bed:	39 d8                	cmp    %ebx,%eax
f0100bef:	7c 0f                	jl     f0100c00 <stab_binsearch+0x70>
f0100bf1:	0f b6 0a             	movzbl (%edx),%ecx
f0100bf4:	83 ea 0c             	sub    $0xc,%edx
f0100bf7:	39 f1                	cmp    %esi,%ecx
f0100bf9:	75 ef                	jne    f0100bea <stab_binsearch+0x5a>
f0100bfb:	e9 9e 00 00 00       	jmp    f0100c9e <stab_binsearch+0x10e>
f0100c00:	8d 5f 01             	lea    0x1(%edi),%ebx
f0100c03:	eb 3c                	jmp    f0100c41 <stab_binsearch+0xb1>
f0100c05:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0100c08:	89 01                	mov    %eax,(%ecx)
f0100c0a:	8d 5f 01             	lea    0x1(%edi),%ebx
f0100c0d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0100c14:	eb 2b                	jmp    f0100c41 <stab_binsearch+0xb1>
f0100c16:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100c19:	76 14                	jbe    f0100c2f <stab_binsearch+0x9f>
f0100c1b:	83 e8 01             	sub    $0x1,%eax
f0100c1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0100c21:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0100c24:	89 02                	mov    %eax,(%edx)
f0100c26:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0100c2d:	eb 12                	jmp    f0100c41 <stab_binsearch+0xb1>
f0100c2f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0100c32:	89 01                	mov    %eax,(%ecx)
f0100c34:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0100c38:	89 c3                	mov    %eax,%ebx
f0100c3a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0100c41:	39 5d ec             	cmp    %ebx,-0x14(%ebp)
f0100c44:	0f 8d 71 ff ff ff    	jge    f0100bbb <stab_binsearch+0x2b>
f0100c4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0100c4e:	75 0f                	jne    f0100c5f <stab_binsearch+0xcf>
f0100c50:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0100c53:	8b 03                	mov    (%ebx),%eax
f0100c55:	83 e8 01             	sub    $0x1,%eax
f0100c58:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0100c5b:	89 02                	mov    %eax,(%edx)
f0100c5d:	eb 57                	jmp    f0100cb6 <stab_binsearch+0x126>
f0100c5f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0100c62:	8b 01                	mov    (%ecx),%eax
f0100c64:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0100c67:	8b 0b                	mov    (%ebx),%ecx
f0100c69:	39 c1                	cmp    %eax,%ecx
f0100c6b:	7d 28                	jge    f0100c95 <stab_binsearch+0x105>
f0100c6d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100c70:	8b 5d f0             	mov    -0x10(%ebp),%ebx
f0100c73:	0f b6 54 93 04       	movzbl 0x4(%ebx,%edx,4),%edx
f0100c78:	39 f2                	cmp    %esi,%edx
f0100c7a:	74 19                	je     f0100c95 <stab_binsearch+0x105>
f0100c7c:	8d 54 40 fd          	lea    -0x3(%eax,%eax,2),%edx
f0100c80:	8d 54 93 04          	lea    0x4(%ebx,%edx,4),%edx
f0100c84:	83 e8 01             	sub    $0x1,%eax
f0100c87:	39 c1                	cmp    %eax,%ecx
f0100c89:	7d 0a                	jge    f0100c95 <stab_binsearch+0x105>
f0100c8b:	0f b6 1a             	movzbl (%edx),%ebx
f0100c8e:	83 ea 0c             	sub    $0xc,%edx
f0100c91:	39 f3                	cmp    %esi,%ebx
f0100c93:	75 ef                	jne    f0100c84 <stab_binsearch+0xf4>
f0100c95:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0100c98:	89 02                	mov    %eax,(%edx)
f0100c9a:	eb 1a                	jmp    f0100cb6 <stab_binsearch+0x126>
f0100c9c:	89 f8                	mov    %edi,%eax
f0100c9e:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100ca1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0100ca4:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0100ca8:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100cab:	0f 82 54 ff ff ff    	jb     f0100c05 <stab_binsearch+0x75>
f0100cb1:	e9 60 ff ff ff       	jmp    f0100c16 <stab_binsearch+0x86>
f0100cb6:	83 c4 14             	add    $0x14,%esp
f0100cb9:	5b                   	pop    %ebx
f0100cba:	5e                   	pop    %esi
f0100cbb:	5f                   	pop    %edi
f0100cbc:	5d                   	pop    %ebp
f0100cbd:	c3                   	ret    

f0100cbe <debuginfo_eip>:
f0100cbe:	55                   	push   %ebp
f0100cbf:	89 e5                	mov    %esp,%ebp
f0100cc1:	83 ec 48             	sub    $0x48,%esp
f0100cc4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0100cc7:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0100cca:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0100ccd:	8b 75 08             	mov    0x8(%ebp),%esi
f0100cd0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0100cd3:	c7 03 2c 24 10 f0    	movl   $0xf010242c,(%ebx)
f0100cd9:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
f0100ce0:	c7 43 08 2c 24 10 f0 	movl   $0xf010242c,0x8(%ebx)
f0100ce7:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
f0100cee:	89 73 10             	mov    %esi,0x10(%ebx)
f0100cf1:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
f0100cf8:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0100cfe:	76 12                	jbe    f0100d12 <debuginfo_eip+0x54>
f0100d00:	b8 d2 83 10 f0       	mov    $0xf01083d2,%eax
f0100d05:	3d f1 67 10 f0       	cmp    $0xf01067f1,%eax
f0100d0a:	0f 86 b2 01 00 00    	jbe    f0100ec2 <debuginfo_eip+0x204>
f0100d10:	eb 1c                	jmp    f0100d2e <debuginfo_eip+0x70>
f0100d12:	c7 44 24 08 36 24 10 	movl   $0xf0102436,0x8(%esp)
f0100d19:	f0 
f0100d1a:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
f0100d21:	00 
f0100d22:	c7 04 24 43 24 10 f0 	movl   $0xf0102443,(%esp)
f0100d29:	e8 57 f3 ff ff       	call   f0100085 <_panic>
f0100d2e:	80 3d d1 83 10 f0 00 	cmpb   $0x0,0xf01083d1
f0100d35:	0f 85 87 01 00 00    	jne    f0100ec2 <debuginfo_eip+0x204>
f0100d3b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0100d42:	b8 f0 67 10 f0       	mov    $0xf01067f0,%eax
f0100d47:	2d e0 26 10 f0       	sub    $0xf01026e0,%eax
f0100d4c:	c1 f8 02             	sar    $0x2,%eax
f0100d4f:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0100d55:	83 e8 01             	sub    $0x1,%eax
f0100d58:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100d5b:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0100d5e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0100d61:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100d65:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0100d6c:	b8 e0 26 10 f0       	mov    $0xf01026e0,%eax
f0100d71:	e8 1a fe ff ff       	call   f0100b90 <stab_binsearch>
f0100d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100d79:	85 c0                	test   %eax,%eax
f0100d7b:	0f 84 41 01 00 00    	je     f0100ec2 <debuginfo_eip+0x204>
f0100d81:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0100d84:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100d87:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100d8a:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0100d8d:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100d90:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100d94:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0100d9b:	b8 e0 26 10 f0       	mov    $0xf01026e0,%eax
f0100da0:	e8 eb fd ff ff       	call   f0100b90 <stab_binsearch>
f0100da5:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100da8:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0100dab:	7f 3c                	jg     f0100de9 <debuginfo_eip+0x12b>
f0100dad:	6b c0 0c             	imul   $0xc,%eax,%eax
f0100db0:	8b 80 e0 26 10 f0    	mov    -0xfefd920(%eax),%eax
f0100db6:	ba d2 83 10 f0       	mov    $0xf01083d2,%edx
f0100dbb:	81 ea f1 67 10 f0    	sub    $0xf01067f1,%edx
f0100dc1:	39 d0                	cmp    %edx,%eax
f0100dc3:	73 08                	jae    f0100dcd <debuginfo_eip+0x10f>
f0100dc5:	05 f1 67 10 f0       	add    $0xf01067f1,%eax
f0100dca:	89 43 08             	mov    %eax,0x8(%ebx)
f0100dcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100dd0:	6b d0 0c             	imul   $0xc,%eax,%edx
f0100dd3:	8b 92 e8 26 10 f0    	mov    -0xfefd918(%edx),%edx
f0100dd9:	89 53 10             	mov    %edx,0x10(%ebx)
f0100ddc:	29 d6                	sub    %edx,%esi
f0100dde:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100de1:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100de4:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100de7:	eb 0f                	jmp    f0100df8 <debuginfo_eip+0x13a>
f0100de9:	89 73 10             	mov    %esi,0x10(%ebx)
f0100dec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100def:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100df2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100df5:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100df8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f0100dff:	00 
f0100e00:	8b 43 08             	mov    0x8(%ebx),%eax
f0100e03:	89 04 24             	mov    %eax,(%esp)
f0100e06:	e8 90 0b 00 00       	call   f010199b <strfind>
f0100e0b:	2b 43 08             	sub    0x8(%ebx),%eax
f0100e0e:	89 43 0c             	mov    %eax,0xc(%ebx)
f0100e11:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0100e14:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0100e17:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100e1b:	c7 04 24 44 00 00 00 	movl   $0x44,(%esp)
f0100e22:	b8 e0 26 10 f0       	mov    $0xf01026e0,%eax
f0100e27:	e8 64 fd ff ff       	call   f0100b90 <stab_binsearch>
f0100e2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100e2f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f0100e32:	0f 8f 8a 00 00 00    	jg     f0100ec2 <debuginfo_eip+0x204>
f0100e38:	ba e0 26 10 f0       	mov    $0xf01026e0,%edx
f0100e3d:	6b c0 0c             	imul   $0xc,%eax,%eax
f0100e40:	0f b7 44 10 06       	movzwl 0x6(%eax,%edx,1),%eax
f0100e45:	89 43 04             	mov    %eax,0x4(%ebx)
f0100e48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e4b:	6b c8 0c             	imul   $0xc,%eax,%ecx
f0100e4e:	8b 14 11             	mov    (%ecx,%edx,1),%edx
f0100e51:	81 c2 f1 67 10 f0    	add    $0xf01067f1,%edx
f0100e57:	89 13                	mov    %edx,(%ebx)
f0100e59:	89 c7                	mov    %eax,%edi
f0100e5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100e5e:	6b d0 0c             	imul   $0xc,%eax,%edx
f0100e61:	81 c2 e8 26 10 f0    	add    $0xf01026e8,%edx
f0100e67:	eb 06                	jmp    f0100e6f <debuginfo_eip+0x1b1>
f0100e69:	83 e8 01             	sub    $0x1,%eax
f0100e6c:	83 ea 0c             	sub    $0xc,%edx
f0100e6f:	89 c6                	mov    %eax,%esi
f0100e71:	39 f8                	cmp    %edi,%eax
f0100e73:	7c 1c                	jl     f0100e91 <debuginfo_eip+0x1d3>
f0100e75:	0f b6 4a fc          	movzbl -0x4(%edx),%ecx
f0100e79:	80 f9 84             	cmp    $0x84,%cl
f0100e7c:	74 5d                	je     f0100edb <debuginfo_eip+0x21d>
f0100e7e:	80 f9 64             	cmp    $0x64,%cl
f0100e81:	75 e6                	jne    f0100e69 <debuginfo_eip+0x1ab>
f0100e83:	83 3a 00             	cmpl   $0x0,(%edx)
f0100e86:	74 e1                	je     f0100e69 <debuginfo_eip+0x1ab>
f0100e88:	eb 51                	jmp    f0100edb <debuginfo_eip+0x21d>
f0100e8a:	05 f1 67 10 f0       	add    $0xf01067f1,%eax
f0100e8f:	89 03                	mov    %eax,(%ebx)
f0100e91:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100e94:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0100e97:	7d 30                	jge    f0100ec9 <debuginfo_eip+0x20b>
f0100e99:	83 c0 01             	add    $0x1,%eax
f0100e9c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100e9f:	ba e0 26 10 f0       	mov    $0xf01026e0,%edx
f0100ea4:	eb 08                	jmp    f0100eae <debuginfo_eip+0x1f0>
f0100ea6:	83 43 14 01          	addl   $0x1,0x14(%ebx)
f0100eaa:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
f0100eae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100eb1:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0100eb4:	7d 13                	jge    f0100ec9 <debuginfo_eip+0x20b>
f0100eb6:	6b c0 0c             	imul   $0xc,%eax,%eax
f0100eb9:	80 7c 10 04 a0       	cmpb   $0xa0,0x4(%eax,%edx,1)
f0100ebe:	74 e6                	je     f0100ea6 <debuginfo_eip+0x1e8>
f0100ec0:	eb 07                	jmp    f0100ec9 <debuginfo_eip+0x20b>
f0100ec2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100ec7:	eb 05                	jmp    f0100ece <debuginfo_eip+0x210>
f0100ec9:	b8 00 00 00 00       	mov    $0x0,%eax
f0100ece:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0100ed1:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0100ed4:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0100ed7:	89 ec                	mov    %ebp,%esp
f0100ed9:	5d                   	pop    %ebp
f0100eda:	c3                   	ret    
f0100edb:	6b c6 0c             	imul   $0xc,%esi,%eax
f0100ede:	8b 80 e0 26 10 f0    	mov    -0xfefd920(%eax),%eax
f0100ee4:	ba d2 83 10 f0       	mov    $0xf01083d2,%edx
f0100ee9:	81 ea f1 67 10 f0    	sub    $0xf01067f1,%edx
f0100eef:	39 d0                	cmp    %edx,%eax
f0100ef1:	72 97                	jb     f0100e8a <debuginfo_eip+0x1cc>
f0100ef3:	eb 9c                	jmp    f0100e91 <debuginfo_eip+0x1d3>
	...

f0100f00 <printnum_width>:
f0100f00:	55                   	push   %ebp
f0100f01:	89 e5                	mov    %esp,%ebp
f0100f03:	57                   	push   %edi
f0100f04:	56                   	push   %esi
f0100f05:	53                   	push   %ebx
f0100f06:	83 ec 4c             	sub    $0x4c,%esp
f0100f09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0100f0c:	89 d7                	mov    %edx,%edi
f0100f0e:	8b 45 08             	mov    0x8(%ebp),%eax
f0100f11:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100f14:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100f17:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100f1a:	8b 45 10             	mov    0x10(%ebp),%eax
f0100f1d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100f20:	be 00 00 00 00       	mov    $0x0,%esi
f0100f25:	39 d6                	cmp    %edx,%esi
f0100f27:	72 07                	jb     f0100f30 <printnum_width+0x30>
f0100f29:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100f2c:	39 c8                	cmp    %ecx,%eax
f0100f2e:	77 70                	ja     f0100fa0 <printnum_width+0xa0>
f0100f30:	8b 5d 20             	mov    0x20(%ebp),%ebx
f0100f33:	83 03 01             	addl   $0x1,(%ebx)
f0100f36:	89 5c 24 18          	mov    %ebx,0x18(%esp)
f0100f3a:	8b 55 1c             	mov    0x1c(%ebp),%edx
f0100f3d:	89 54 24 14          	mov    %edx,0x14(%esp)
f0100f41:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0100f44:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0100f48:	8b 55 14             	mov    0x14(%ebp),%edx
f0100f4b:	83 ea 01             	sub    $0x1,%edx
f0100f4e:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100f52:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100f56:	8b 44 24 08          	mov    0x8(%esp),%eax
f0100f5a:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0100f5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100f61:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0100f64:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100f67:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100f6b:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0100f6f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100f72:	89 0c 24             	mov    %ecx,(%esp)
f0100f75:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100f78:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100f7c:	e8 af 0c 00 00       	call   f0101c30 <__udivdi3>
f0100f81:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0100f84:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0100f87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0100f8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0100f8f:	89 04 24             	mov    %eax,(%esp)
f0100f92:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100f96:	89 fa                	mov    %edi,%edx
f0100f98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100f9b:	e8 60 ff ff ff       	call   f0100f00 <printnum_width>
f0100fa0:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100fa4:	8b 04 24             	mov    (%esp),%eax
f0100fa7:	8b 54 24 04          	mov    0x4(%esp),%edx
f0100fab:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100fae:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0100fb1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100fb4:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100fb8:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0100fbc:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100fbf:	89 0c 24             	mov    %ecx,(%esp)
f0100fc2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100fc5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100fc9:	e8 92 0d 00 00       	call   f0101d60 <__umoddi3>
f0100fce:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0100fd1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0100fd5:	0f be 80 51 24 10 f0 	movsbl -0xfefdbaf(%eax),%eax
f0100fdc:	89 04 24             	mov    %eax,(%esp)
f0100fdf:	ff 55 e4             	call   *-0x1c(%ebp)
f0100fe2:	8b 4d 1c             	mov    0x1c(%ebp),%ecx
f0100fe5:	8b 01                	mov    (%ecx),%eax
f0100fe7:	83 c0 01             	add    $0x1,%eax
f0100fea:	89 01                	mov    %eax,(%ecx)
f0100fec:	8b 5d 20             	mov    0x20(%ebp),%ebx
f0100fef:	8b 13                	mov    (%ebx),%edx
f0100ff1:	83 c2 01             	add    $0x1,%edx
f0100ff4:	39 d0                	cmp    %edx,%eax
f0100ff6:	75 2e                	jne    f0101026 <printnum_width+0x126>
f0100ff8:	39 45 14             	cmp    %eax,0x14(%ebp)
f0100ffb:	7e 29                	jle    f0101026 <printnum_width+0x126>
f0100ffd:	8b 55 14             	mov    0x14(%ebp),%edx
f0101000:	29 c2                	sub    %eax,%edx
f0101002:	85 d2                	test   %edx,%edx
f0101004:	7e 20                	jle    f0101026 <printnum_width+0x126>
f0101006:	be 00 00 00 00       	mov    $0x0,%esi
f010100b:	89 cb                	mov    %ecx,%ebx
f010100d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101011:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0101014:	89 0c 24             	mov    %ecx,(%esp)
f0101017:	ff 55 e4             	call   *-0x1c(%ebp)
f010101a:	83 c6 01             	add    $0x1,%esi
f010101d:	8b 45 14             	mov    0x14(%ebp),%eax
f0101020:	2b 03                	sub    (%ebx),%eax
f0101022:	39 f0                	cmp    %esi,%eax
f0101024:	7f e7                	jg     f010100d <printnum_width+0x10d>
f0101026:	83 c4 4c             	add    $0x4c,%esp
f0101029:	5b                   	pop    %ebx
f010102a:	5e                   	pop    %esi
f010102b:	5f                   	pop    %edi
f010102c:	5d                   	pop    %ebp
f010102d:	c3                   	ret    

f010102e <printnum>:
f010102e:	55                   	push   %ebp
f010102f:	89 e5                	mov    %esp,%ebp
f0101031:	57                   	push   %edi
f0101032:	56                   	push   %esi
f0101033:	53                   	push   %ebx
f0101034:	83 ec 5c             	sub    $0x5c,%esp
f0101037:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010103a:	89 d6                	mov    %edx,%esi
f010103c:	8b 45 08             	mov    0x8(%ebp),%eax
f010103f:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101042:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101045:	89 55 d0             	mov    %edx,-0x30(%ebp)
f0101048:	8b 55 10             	mov    0x10(%ebp),%edx
f010104b:	8b 5d 14             	mov    0x14(%ebp),%ebx
f010104e:	8b 7d 18             	mov    0x18(%ebp),%edi
f0101051:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0101058:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f010105f:	83 ff 30             	cmp    $0x30,%edi
f0101062:	74 42                	je     f01010a6 <printnum+0x78>
f0101064:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0101067:	83 f8 07             	cmp    $0x7,%eax
f010106a:	77 3a                	ja     f01010a6 <printnum+0x78>
f010106c:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010106f:	89 44 24 18          	mov    %eax,0x18(%esp)
f0101073:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101076:	89 44 24 14          	mov    %eax,0x14(%esp)
f010107a:	c7 44 24 10 20 00 00 	movl   $0x20,0x10(%esp)
f0101081:	00 
f0101082:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0101086:	89 54 24 08          	mov    %edx,0x8(%esp)
f010108a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010108d:	89 0c 24             	mov    %ecx,(%esp)
f0101090:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0101093:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101097:	89 f2                	mov    %esi,%edx
f0101099:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010109c:	e8 5f fe ff ff       	call   f0100f00 <printnum_width>
f01010a1:	e9 c8 00 00 00       	jmp    f010116e <printnum+0x140>
f01010a6:	89 55 c8             	mov    %edx,-0x38(%ebp)
f01010a9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f01010ad:	77 15                	ja     f01010c4 <printnum+0x96>
f01010af:	90                   	nop
f01010b0:	72 05                	jb     f01010b7 <printnum+0x89>
f01010b2:	39 55 cc             	cmp    %edx,-0x34(%ebp)
f01010b5:	73 0d                	jae    f01010c4 <printnum+0x96>
f01010b7:	83 eb 01             	sub    $0x1,%ebx
f01010ba:	85 db                	test   %ebx,%ebx
f01010bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01010c0:	7f 61                	jg     f0101123 <printnum+0xf5>
f01010c2:	eb 70                	jmp    f0101134 <printnum+0x106>
f01010c4:	89 7c 24 10          	mov    %edi,0x10(%esp)
f01010c8:	83 eb 01             	sub    $0x1,%ebx
f01010cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f01010cf:	89 54 24 08          	mov    %edx,0x8(%esp)
f01010d3:	8b 44 24 08          	mov    0x8(%esp),%eax
f01010d7:	8b 54 24 0c          	mov    0xc(%esp),%edx
f01010db:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01010de:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f01010e1:	8b 55 c8             	mov    -0x38(%ebp),%edx
f01010e4:	89 54 24 08          	mov    %edx,0x8(%esp)
f01010e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f01010ef:	00 
f01010f0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f01010f3:	89 0c 24             	mov    %ecx,(%esp)
f01010f6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f01010f9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01010fd:	e8 2e 0b 00 00       	call   f0101c30 <__udivdi3>
f0101102:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0101105:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0101108:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010110c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0101110:	89 04 24             	mov    %eax,(%esp)
f0101113:	89 54 24 04          	mov    %edx,0x4(%esp)
f0101117:	89 f2                	mov    %esi,%edx
f0101119:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010111c:	e8 0d ff ff ff       	call   f010102e <printnum>
f0101121:	eb 11                	jmp    f0101134 <printnum+0x106>
f0101123:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101127:	89 3c 24             	mov    %edi,(%esp)
f010112a:	ff 55 d4             	call   *-0x2c(%ebp)
f010112d:	83 eb 01             	sub    $0x1,%ebx
f0101130:	85 db                	test   %ebx,%ebx
f0101132:	7f ef                	jg     f0101123 <printnum+0xf5>
f0101134:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101138:	8b 74 24 04          	mov    0x4(%esp),%esi
f010113c:	8b 45 c8             	mov    -0x38(%ebp),%eax
f010113f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101143:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f010114a:	00 
f010114b:	8b 55 cc             	mov    -0x34(%ebp),%edx
f010114e:	89 14 24             	mov    %edx,(%esp)
f0101151:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0101154:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0101158:	e8 03 0c 00 00       	call   f0101d60 <__umoddi3>
f010115d:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101161:	0f be 80 51 24 10 f0 	movsbl -0xfefdbaf(%eax),%eax
f0101168:	89 04 24             	mov    %eax,(%esp)
f010116b:	ff 55 d4             	call   *-0x2c(%ebp)
f010116e:	83 c4 5c             	add    $0x5c,%esp
f0101171:	5b                   	pop    %ebx
f0101172:	5e                   	pop    %esi
f0101173:	5f                   	pop    %edi
f0101174:	5d                   	pop    %ebp
f0101175:	c3                   	ret    

f0101176 <getuint>:
f0101176:	55                   	push   %ebp
f0101177:	89 e5                	mov    %esp,%ebp
f0101179:	83 fa 01             	cmp    $0x1,%edx
f010117c:	7e 0e                	jle    f010118c <getuint+0x16>
f010117e:	8b 10                	mov    (%eax),%edx
f0101180:	8d 4a 08             	lea    0x8(%edx),%ecx
f0101183:	89 08                	mov    %ecx,(%eax)
f0101185:	8b 02                	mov    (%edx),%eax
f0101187:	8b 52 04             	mov    0x4(%edx),%edx
f010118a:	eb 22                	jmp    f01011ae <getuint+0x38>
f010118c:	85 d2                	test   %edx,%edx
f010118e:	74 10                	je     f01011a0 <getuint+0x2a>
f0101190:	8b 10                	mov    (%eax),%edx
f0101192:	8d 4a 04             	lea    0x4(%edx),%ecx
f0101195:	89 08                	mov    %ecx,(%eax)
f0101197:	8b 02                	mov    (%edx),%eax
f0101199:	ba 00 00 00 00       	mov    $0x0,%edx
f010119e:	eb 0e                	jmp    f01011ae <getuint+0x38>
f01011a0:	8b 10                	mov    (%eax),%edx
f01011a2:	8d 4a 04             	lea    0x4(%edx),%ecx
f01011a5:	89 08                	mov    %ecx,(%eax)
f01011a7:	8b 02                	mov    (%edx),%eax
f01011a9:	ba 00 00 00 00       	mov    $0x0,%edx
f01011ae:	5d                   	pop    %ebp
f01011af:	c3                   	ret    

f01011b0 <getint>:
f01011b0:	55                   	push   %ebp
f01011b1:	89 e5                	mov    %esp,%ebp
f01011b3:	83 fa 01             	cmp    $0x1,%edx
f01011b6:	7e 0e                	jle    f01011c6 <getint+0x16>
f01011b8:	8b 10                	mov    (%eax),%edx
f01011ba:	8d 4a 08             	lea    0x8(%edx),%ecx
f01011bd:	89 08                	mov    %ecx,(%eax)
f01011bf:	8b 02                	mov    (%edx),%eax
f01011c1:	8b 52 04             	mov    0x4(%edx),%edx
f01011c4:	eb 22                	jmp    f01011e8 <getint+0x38>
f01011c6:	85 d2                	test   %edx,%edx
f01011c8:	74 10                	je     f01011da <getint+0x2a>
f01011ca:	8b 10                	mov    (%eax),%edx
f01011cc:	8d 4a 04             	lea    0x4(%edx),%ecx
f01011cf:	89 08                	mov    %ecx,(%eax)
f01011d1:	8b 02                	mov    (%edx),%eax
f01011d3:	89 c2                	mov    %eax,%edx
f01011d5:	c1 fa 1f             	sar    $0x1f,%edx
f01011d8:	eb 0e                	jmp    f01011e8 <getint+0x38>
f01011da:	8b 10                	mov    (%eax),%edx
f01011dc:	8d 4a 04             	lea    0x4(%edx),%ecx
f01011df:	89 08                	mov    %ecx,(%eax)
f01011e1:	8b 02                	mov    (%edx),%eax
f01011e3:	89 c2                	mov    %eax,%edx
f01011e5:	c1 fa 1f             	sar    $0x1f,%edx
f01011e8:	5d                   	pop    %ebp
f01011e9:	c3                   	ret    

f01011ea <sprintputch>:
f01011ea:	55                   	push   %ebp
f01011eb:	89 e5                	mov    %esp,%ebp
f01011ed:	8b 45 0c             	mov    0xc(%ebp),%eax
f01011f0:	83 40 08 01          	addl   $0x1,0x8(%eax)
f01011f4:	8b 10                	mov    (%eax),%edx
f01011f6:	3b 50 04             	cmp    0x4(%eax),%edx
f01011f9:	73 0a                	jae    f0101205 <sprintputch+0x1b>
f01011fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01011fe:	88 0a                	mov    %cl,(%edx)
f0101200:	83 c2 01             	add    $0x1,%edx
f0101203:	89 10                	mov    %edx,(%eax)
f0101205:	5d                   	pop    %ebp
f0101206:	c3                   	ret    

f0101207 <vprintfmt>:
f0101207:	55                   	push   %ebp
f0101208:	89 e5                	mov    %esp,%ebp
f010120a:	57                   	push   %edi
f010120b:	56                   	push   %esi
f010120c:	53                   	push   %ebx
f010120d:	83 ec 5c             	sub    $0x5c,%esp
f0101210:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0101213:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0101216:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
f010121d:	eb 17                	jmp    f0101236 <vprintfmt+0x2f>
f010121f:	85 c0                	test   %eax,%eax
f0101221:	0f 84 5e 04 00 00    	je     f0101685 <vprintfmt+0x47e>
f0101227:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010122b:	89 04 24             	mov    %eax,(%esp)
f010122e:	ff 55 08             	call   *0x8(%ebp)
f0101231:	eb 03                	jmp    f0101236 <vprintfmt+0x2f>
f0101233:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0101236:	0f b6 03             	movzbl (%ebx),%eax
f0101239:	83 c3 01             	add    $0x1,%ebx
f010123c:	83 f8 25             	cmp    $0x25,%eax
f010123f:	75 de                	jne    f010121f <vprintfmt+0x18>
f0101241:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f0101248:	c6 45 d0 20          	movb   $0x20,-0x30(%ebp)
f010124c:	be ff ff ff ff       	mov    $0xffffffff,%esi
f0101251:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
f0101258:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010125f:	eb 06                	jmp    f0101267 <vprintfmt+0x60>
f0101261:	c6 45 d0 2d          	movb   $0x2d,-0x30(%ebp)
f0101265:	89 cb                	mov    %ecx,%ebx
f0101267:	0f b6 03             	movzbl (%ebx),%eax
f010126a:	0f b6 d0             	movzbl %al,%edx
f010126d:	8d 4b 01             	lea    0x1(%ebx),%ecx
f0101270:	83 e8 23             	sub    $0x23,%eax
f0101273:	3c 55                	cmp    $0x55,%al
f0101275:	0f 87 ec 03 00 00    	ja     f0101667 <vprintfmt+0x460>
f010127b:	0f b6 c0             	movzbl %al,%eax
f010127e:	ff 24 85 5c 25 10 f0 	jmp    *-0xfefdaa4(,%eax,4)
f0101285:	c6 45 d0 30          	movb   $0x30,-0x30(%ebp)
f0101289:	eb da                	jmp    f0101265 <vprintfmt+0x5e>
f010128b:	8d 72 d0             	lea    -0x30(%edx),%esi
f010128e:	0f be 01             	movsbl (%ecx),%eax
f0101291:	8d 50 d0             	lea    -0x30(%eax),%edx
f0101294:	83 fa 09             	cmp    $0x9,%edx
f0101297:	76 0b                	jbe    f01012a4 <vprintfmt+0x9d>
f0101299:	eb 43                	jmp    f01012de <vprintfmt+0xd7>
f010129b:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%ebp)
f01012a2:	eb c1                	jmp    f0101265 <vprintfmt+0x5e>
f01012a4:	83 c1 01             	add    $0x1,%ecx
f01012a7:	8d 14 b6             	lea    (%esi,%esi,4),%edx
f01012aa:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
f01012ae:	0f be 01             	movsbl (%ecx),%eax
f01012b1:	8d 50 d0             	lea    -0x30(%eax),%edx
f01012b4:	83 fa 09             	cmp    $0x9,%edx
f01012b7:	76 eb                	jbe    f01012a4 <vprintfmt+0x9d>
f01012b9:	eb 23                	jmp    f01012de <vprintfmt+0xd7>
f01012bb:	8b 45 14             	mov    0x14(%ebp),%eax
f01012be:	8d 50 04             	lea    0x4(%eax),%edx
f01012c1:	89 55 14             	mov    %edx,0x14(%ebp)
f01012c4:	8b 30                	mov    (%eax),%esi
f01012c6:	eb 16                	jmp    f01012de <vprintfmt+0xd7>
f01012c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01012cb:	c1 f8 1f             	sar    $0x1f,%eax
f01012ce:	f7 d0                	not    %eax
f01012d0:	21 45 e4             	and    %eax,-0x1c(%ebp)
f01012d3:	eb 90                	jmp    f0101265 <vprintfmt+0x5e>
f01012d5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
f01012dc:	eb 87                	jmp    f0101265 <vprintfmt+0x5e>
f01012de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01012e2:	79 81                	jns    f0101265 <vprintfmt+0x5e>
f01012e4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f01012e7:	8b 75 c8             	mov    -0x38(%ebp),%esi
f01012ea:	e9 76 ff ff ff       	jmp    f0101265 <vprintfmt+0x5e>
f01012ef:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
f01012f3:	e9 6d ff ff ff       	jmp    f0101265 <vprintfmt+0x5e>
f01012f8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f01012fb:	8b 45 14             	mov    0x14(%ebp),%eax
f01012fe:	8d 50 04             	lea    0x4(%eax),%edx
f0101301:	89 55 14             	mov    %edx,0x14(%ebp)
f0101304:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101308:	8b 00                	mov    (%eax),%eax
f010130a:	89 04 24             	mov    %eax,(%esp)
f010130d:	ff 55 08             	call   *0x8(%ebp)
f0101310:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0101313:	e9 1e ff ff ff       	jmp    f0101236 <vprintfmt+0x2f>
f0101318:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f010131b:	8b 45 14             	mov    0x14(%ebp),%eax
f010131e:	8d 50 04             	lea    0x4(%eax),%edx
f0101321:	89 55 14             	mov    %edx,0x14(%ebp)
f0101324:	8b 00                	mov    (%eax),%eax
f0101326:	89 c2                	mov    %eax,%edx
f0101328:	c1 fa 1f             	sar    $0x1f,%edx
f010132b:	31 d0                	xor    %edx,%eax
f010132d:	29 d0                	sub    %edx,%eax
f010132f:	83 f8 06             	cmp    $0x6,%eax
f0101332:	7f 0b                	jg     f010133f <vprintfmt+0x138>
f0101334:	8b 14 85 b4 26 10 f0 	mov    -0xfefd94c(,%eax,4),%edx
f010133b:	85 d2                	test   %edx,%edx
f010133d:	75 23                	jne    f0101362 <vprintfmt+0x15b>
f010133f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101343:	c7 44 24 08 62 24 10 	movl   $0xf0102462,0x8(%esp)
f010134a:	f0 
f010134b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010134f:	8b 45 08             	mov    0x8(%ebp),%eax
f0101352:	89 04 24             	mov    %eax,(%esp)
f0101355:	e8 b3 03 00 00       	call   f010170d <printfmt>
f010135a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f010135d:	e9 d4 fe ff ff       	jmp    f0101236 <vprintfmt+0x2f>
f0101362:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0101366:	c7 44 24 08 6b 24 10 	movl   $0xf010246b,0x8(%esp)
f010136d:	f0 
f010136e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101372:	8b 55 08             	mov    0x8(%ebp),%edx
f0101375:	89 14 24             	mov    %edx,(%esp)
f0101378:	e8 90 03 00 00       	call   f010170d <printfmt>
f010137d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0101380:	e9 b1 fe ff ff       	jmp    f0101236 <vprintfmt+0x2f>
f0101385:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f0101388:	89 cb                	mov    %ecx,%ebx
f010138a:	89 f1                	mov    %esi,%ecx
f010138c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010138f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0101392:	8b 45 14             	mov    0x14(%ebp),%eax
f0101395:	8d 50 04             	lea    0x4(%eax),%edx
f0101398:	89 55 14             	mov    %edx,0x14(%ebp)
f010139b:	8b 00                	mov    (%eax),%eax
f010139d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01013a0:	85 c0                	test   %eax,%eax
f01013a2:	75 07                	jne    f01013ab <vprintfmt+0x1a4>
f01013a4:	c7 45 d4 6e 24 10 f0 	movl   $0xf010246e,-0x2c(%ebp)
f01013ab:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f01013af:	7e 06                	jle    f01013b7 <vprintfmt+0x1b0>
f01013b1:	80 7d d0 2d          	cmpb   $0x2d,-0x30(%ebp)
f01013b5:	75 13                	jne    f01013ca <vprintfmt+0x1c3>
f01013b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01013ba:	0f be 02             	movsbl (%edx),%eax
f01013bd:	85 c0                	test   %eax,%eax
f01013bf:	0f 85 95 00 00 00    	jne    f010145a <vprintfmt+0x253>
f01013c5:	e9 85 00 00 00       	jmp    f010144f <vprintfmt+0x248>
f01013ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f01013ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01013d1:	89 04 24             	mov    %eax,(%esp)
f01013d4:	e8 62 04 00 00       	call   f010183b <strnlen>
f01013d9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f01013dc:	29 c2                	sub    %eax,%edx
f01013de:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01013e1:	85 d2                	test   %edx,%edx
f01013e3:	7e d2                	jle    f01013b7 <vprintfmt+0x1b0>
f01013e5:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
f01013e9:	89 75 c4             	mov    %esi,-0x3c(%ebp)
f01013ec:	89 5d c0             	mov    %ebx,-0x40(%ebp)
f01013ef:	89 d3                	mov    %edx,%ebx
f01013f1:	89 c6                	mov    %eax,%esi
f01013f3:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01013f7:	89 34 24             	mov    %esi,(%esp)
f01013fa:	ff 55 08             	call   *0x8(%ebp)
f01013fd:	83 eb 01             	sub    $0x1,%ebx
f0101400:	85 db                	test   %ebx,%ebx
f0101402:	7f ef                	jg     f01013f3 <vprintfmt+0x1ec>
f0101404:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0101407:	8b 5d c0             	mov    -0x40(%ebp),%ebx
f010140a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0101411:	eb a4                	jmp    f01013b7 <vprintfmt+0x1b0>
f0101413:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0101417:	74 19                	je     f0101432 <vprintfmt+0x22b>
f0101419:	8d 50 e0             	lea    -0x20(%eax),%edx
f010141c:	83 fa 5e             	cmp    $0x5e,%edx
f010141f:	76 11                	jbe    f0101432 <vprintfmt+0x22b>
f0101421:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101425:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f010142c:	ff 55 08             	call   *0x8(%ebp)
f010142f:	90                   	nop
f0101430:	eb 0a                	jmp    f010143c <vprintfmt+0x235>
f0101432:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101436:	89 04 24             	mov    %eax,(%esp)
f0101439:	ff 55 08             	call   *0x8(%ebp)
f010143c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
f0101440:	0f be 03             	movsbl (%ebx),%eax
f0101443:	85 c0                	test   %eax,%eax
f0101445:	74 05                	je     f010144c <vprintfmt+0x245>
f0101447:	83 c3 01             	add    $0x1,%ebx
f010144a:	eb 19                	jmp    f0101465 <vprintfmt+0x25e>
f010144c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010144f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0101453:	7f 1e                	jg     f0101473 <vprintfmt+0x26c>
f0101455:	e9 d9 fd ff ff       	jmp    f0101233 <vprintfmt+0x2c>
f010145a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010145d:	83 c2 01             	add    $0x1,%edx
f0101460:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
f0101463:	89 d3                	mov    %edx,%ebx
f0101465:	85 f6                	test   %esi,%esi
f0101467:	78 aa                	js     f0101413 <vprintfmt+0x20c>
f0101469:	83 ee 01             	sub    $0x1,%esi
f010146c:	79 a5                	jns    f0101413 <vprintfmt+0x20c>
f010146e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101471:	eb dc                	jmp    f010144f <vprintfmt+0x248>
f0101473:	8b 75 08             	mov    0x8(%ebp),%esi
f0101476:	89 5d d8             	mov    %ebx,-0x28(%ebp)
f0101479:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f010147c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101480:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0101487:	ff d6                	call   *%esi
f0101489:	83 eb 01             	sub    $0x1,%ebx
f010148c:	85 db                	test   %ebx,%ebx
f010148e:	7f ec                	jg     f010147c <vprintfmt+0x275>
f0101490:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f0101493:	e9 9e fd ff ff       	jmp    f0101236 <vprintfmt+0x2f>
f0101498:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f010149b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010149e:	8d 45 14             	lea    0x14(%ebp),%eax
f01014a1:	e8 0a fd ff ff       	call   f01011b0 <getint>
f01014a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01014a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01014ac:	89 c3                	mov    %eax,%ebx
f01014ae:	89 d6                	mov    %edx,%esi
f01014b0:	ba 0a 00 00 00       	mov    $0xa,%edx
f01014b5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01014b9:	0f 89 b2 00 00 00    	jns    f0101571 <vprintfmt+0x36a>
f01014bf:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01014c3:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f01014ca:	ff 55 08             	call   *0x8(%ebp)
f01014cd:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f01014d0:	8b 75 dc             	mov    -0x24(%ebp),%esi
f01014d3:	f7 db                	neg    %ebx
f01014d5:	83 d6 00             	adc    $0x0,%esi
f01014d8:	f7 de                	neg    %esi
f01014da:	ba 0a 00 00 00       	mov    $0xa,%edx
f01014df:	e9 8d 00 00 00       	jmp    f0101571 <vprintfmt+0x36a>
f01014e4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f01014e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01014ea:	8d 45 14             	lea    0x14(%ebp),%eax
f01014ed:	e8 84 fc ff ff       	call   f0101176 <getuint>
f01014f2:	89 c3                	mov    %eax,%ebx
f01014f4:	89 d6                	mov    %edx,%esi
f01014f6:	ba 0a 00 00 00       	mov    $0xa,%edx
f01014fb:	eb 74                	jmp    f0101571 <vprintfmt+0x36a>
f01014fd:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f0101500:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101504:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f010150b:	ff 55 08             	call   *0x8(%ebp)
f010150e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101511:	8d 45 14             	lea    0x14(%ebp),%eax
f0101514:	e8 5d fc ff ff       	call   f0101176 <getuint>
f0101519:	89 c3                	mov    %eax,%ebx
f010151b:	89 d6                	mov    %edx,%esi
f010151d:	ba 08 00 00 00       	mov    $0x8,%edx
f0101522:	eb 4d                	jmp    f0101571 <vprintfmt+0x36a>
f0101524:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f0101527:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010152b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f0101532:	ff 55 08             	call   *0x8(%ebp)
f0101535:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101539:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f0101540:	ff 55 08             	call   *0x8(%ebp)
f0101543:	8b 45 14             	mov    0x14(%ebp),%eax
f0101546:	8d 50 04             	lea    0x4(%eax),%edx
f0101549:	89 55 14             	mov    %edx,0x14(%ebp)
f010154c:	8b 18                	mov    (%eax),%ebx
f010154e:	be 00 00 00 00       	mov    $0x0,%esi
f0101553:	ba 10 00 00 00       	mov    $0x10,%edx
f0101558:	eb 17                	jmp    f0101571 <vprintfmt+0x36a>
f010155a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f010155d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101560:	8d 45 14             	lea    0x14(%ebp),%eax
f0101563:	e8 0e fc ff ff       	call   f0101176 <getuint>
f0101568:	89 c3                	mov    %eax,%ebx
f010156a:	89 d6                	mov    %edx,%esi
f010156c:	ba 10 00 00 00       	mov    $0x10,%edx
f0101571:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
f0101575:	89 44 24 10          	mov    %eax,0x10(%esp)
f0101579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010157c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101580:	89 54 24 08          	mov    %edx,0x8(%esp)
f0101584:	89 1c 24             	mov    %ebx,(%esp)
f0101587:	89 74 24 04          	mov    %esi,0x4(%esp)
f010158b:	89 fa                	mov    %edi,%edx
f010158d:	8b 45 08             	mov    0x8(%ebp),%eax
f0101590:	e8 99 fa ff ff       	call   f010102e <printnum>
f0101595:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0101598:	e9 99 fc ff ff       	jmp    f0101236 <vprintfmt+0x2f>
f010159d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f01015a0:	8b 45 14             	mov    0x14(%ebp),%eax
f01015a3:	8d 50 04             	lea    0x4(%eax),%edx
f01015a6:	89 55 14             	mov    %edx,0x14(%ebp)
f01015a9:	8b 30                	mov    (%eax),%esi
f01015ab:	85 f6                	test   %esi,%esi
f01015ad:	75 21                	jne    f01015d0 <vprintfmt+0x3c9>
f01015af:	bb e1 24 10 f0       	mov    $0xf01024e1,%ebx
f01015b4:	b8 0a 00 00 00       	mov    $0xa,%eax
f01015b9:	89 04 24             	mov    %eax,(%esp)
f01015bc:	e8 c9 ef ff ff       	call   f010058a <cputchar>
f01015c1:	0f be 03             	movsbl (%ebx),%eax
f01015c4:	83 c3 01             	add    $0x1,%ebx
f01015c7:	85 c0                	test   %eax,%eax
f01015c9:	75 ee                	jne    f01015b9 <vprintfmt+0x3b2>
f01015cb:	e9 63 fc ff ff       	jmp    f0101233 <vprintfmt+0x2c>
f01015d0:	80 3f ff             	cmpb   $0xff,(%edi)
f01015d3:	75 27                	jne    f01015fc <vprintfmt+0x3f5>
f01015d5:	bb 19 25 10 f0       	mov    $0xf0102519,%ebx
f01015da:	b8 0a 00 00 00       	mov    $0xa,%eax
f01015df:	89 04 24             	mov    %eax,(%esp)
f01015e2:	e8 a3 ef ff ff       	call   f010058a <cputchar>
f01015e7:	0f be 03             	movsbl (%ebx),%eax
f01015ea:	83 c3 01             	add    $0x1,%ebx
f01015ed:	85 c0                	test   %eax,%eax
f01015ef:	75 ee                	jne    f01015df <vprintfmt+0x3d8>
f01015f1:	c6 06 ff             	movb   $0xff,(%esi)
f01015f4:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f01015f7:	e9 3a fc ff ff       	jmp    f0101236 <vprintfmt+0x2f>
f01015fc:	0f b6 07             	movzbl (%edi),%eax
f01015ff:	88 06                	mov    %al,(%esi)
f0101601:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0101604:	e9 2d fc ff ff       	jmp    f0101236 <vprintfmt+0x2f>
f0101609:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f010160c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101610:	89 14 24             	mov    %edx,(%esp)
f0101613:	ff 55 08             	call   *0x8(%ebp)
f0101616:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0101619:	e9 18 fc ff ff       	jmp    f0101236 <vprintfmt+0x2f>
f010161e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f0101621:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101624:	8d 45 14             	lea    0x14(%ebp),%eax
f0101627:	e8 84 fb ff ff       	call   f01011b0 <getint>
f010162c:	89 c3                	mov    %eax,%ebx
f010162e:	89 d6                	mov    %edx,%esi
f0101630:	85 d2                	test   %edx,%edx
f0101632:	79 17                	jns    f010164b <vprintfmt+0x444>
f0101634:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101638:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f010163f:	ff 55 08             	call   *0x8(%ebp)
f0101642:	f7 db                	neg    %ebx
f0101644:	83 d6 00             	adc    $0x0,%esi
f0101647:	f7 de                	neg    %esi
f0101649:	eb 0e                	jmp    f0101659 <vprintfmt+0x452>
f010164b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010164f:	c7 04 24 2b 00 00 00 	movl   $0x2b,(%esp)
f0101656:	ff 55 08             	call   *0x8(%ebp)
f0101659:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
f010165d:	ba 0a 00 00 00       	mov    $0xa,%edx
f0101662:	e9 0a ff ff ff       	jmp    f0101571 <vprintfmt+0x36a>
f0101667:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010166b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0101672:	ff 55 08             	call   *0x8(%ebp)
f0101675:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0101678:	80 38 25             	cmpb   $0x25,(%eax)
f010167b:	0f 84 b5 fb ff ff    	je     f0101236 <vprintfmt+0x2f>
f0101681:	89 c3                	mov    %eax,%ebx
f0101683:	eb f0                	jmp    f0101675 <vprintfmt+0x46e>
f0101685:	83 c4 5c             	add    $0x5c,%esp
f0101688:	5b                   	pop    %ebx
f0101689:	5e                   	pop    %esi
f010168a:	5f                   	pop    %edi
f010168b:	5d                   	pop    %ebp
f010168c:	c3                   	ret    

f010168d <vsnprintf>:
f010168d:	55                   	push   %ebp
f010168e:	89 e5                	mov    %esp,%ebp
f0101690:	83 ec 28             	sub    $0x28,%esp
f0101693:	8b 45 08             	mov    0x8(%ebp),%eax
f0101696:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101699:	85 c0                	test   %eax,%eax
f010169b:	74 04                	je     f01016a1 <vsnprintf+0x14>
f010169d:	85 d2                	test   %edx,%edx
f010169f:	7f 07                	jg     f01016a8 <vsnprintf+0x1b>
f01016a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01016a6:	eb 3b                	jmp    f01016e3 <vsnprintf+0x56>
f01016a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01016ab:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
f01016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01016b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f01016b9:	8b 45 14             	mov    0x14(%ebp),%eax
f01016bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01016c0:	8b 45 10             	mov    0x10(%ebp),%eax
f01016c3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01016c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01016ca:	89 44 24 04          	mov    %eax,0x4(%esp)
f01016ce:	c7 04 24 ea 11 10 f0 	movl   $0xf01011ea,(%esp)
f01016d5:	e8 2d fb ff ff       	call   f0101207 <vprintfmt>
f01016da:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01016dd:	c6 00 00             	movb   $0x0,(%eax)
f01016e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01016e3:	c9                   	leave  
f01016e4:	c3                   	ret    

f01016e5 <snprintf>:
f01016e5:	55                   	push   %ebp
f01016e6:	89 e5                	mov    %esp,%ebp
f01016e8:	83 ec 18             	sub    $0x18,%esp
f01016eb:	8d 45 14             	lea    0x14(%ebp),%eax
f01016ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01016f2:	8b 45 10             	mov    0x10(%ebp),%eax
f01016f5:	89 44 24 08          	mov    %eax,0x8(%esp)
f01016f9:	8b 45 0c             	mov    0xc(%ebp),%eax
f01016fc:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101700:	8b 45 08             	mov    0x8(%ebp),%eax
f0101703:	89 04 24             	mov    %eax,(%esp)
f0101706:	e8 82 ff ff ff       	call   f010168d <vsnprintf>
f010170b:	c9                   	leave  
f010170c:	c3                   	ret    

f010170d <printfmt>:
f010170d:	55                   	push   %ebp
f010170e:	89 e5                	mov    %esp,%ebp
f0101710:	83 ec 18             	sub    $0x18,%esp
f0101713:	8d 45 14             	lea    0x14(%ebp),%eax
f0101716:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010171a:	8b 45 10             	mov    0x10(%ebp),%eax
f010171d:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101721:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101724:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101728:	8b 45 08             	mov    0x8(%ebp),%eax
f010172b:	89 04 24             	mov    %eax,(%esp)
f010172e:	e8 d4 fa ff ff       	call   f0101207 <vprintfmt>
f0101733:	c9                   	leave  
f0101734:	c3                   	ret    
	...

f0101740 <readline>:
f0101740:	55                   	push   %ebp
f0101741:	89 e5                	mov    %esp,%ebp
f0101743:	57                   	push   %edi
f0101744:	56                   	push   %esi
f0101745:	53                   	push   %ebx
f0101746:	83 ec 1c             	sub    $0x1c,%esp
f0101749:	8b 45 08             	mov    0x8(%ebp),%eax
f010174c:	85 c0                	test   %eax,%eax
f010174e:	74 10                	je     f0101760 <readline+0x20>
f0101750:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101754:	c7 04 24 6b 24 10 f0 	movl   $0xf010246b,(%esp)
f010175b:	e8 ef f3 ff ff       	call   f0100b4f <cprintf>
f0101760:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101767:	e8 1a ec ff ff       	call   f0100386 <iscons>
f010176c:	89 c7                	mov    %eax,%edi
f010176e:	be 00 00 00 00       	mov    $0x0,%esi
f0101773:	e8 fd eb ff ff       	call   f0100375 <getchar>
f0101778:	89 c3                	mov    %eax,%ebx
f010177a:	85 c0                	test   %eax,%eax
f010177c:	79 17                	jns    f0101795 <readline+0x55>
f010177e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101782:	c7 04 24 d0 26 10 f0 	movl   $0xf01026d0,(%esp)
f0101789:	e8 c1 f3 ff ff       	call   f0100b4f <cprintf>
f010178e:	b8 00 00 00 00       	mov    $0x0,%eax
f0101793:	eb 76                	jmp    f010180b <readline+0xcb>
f0101795:	83 f8 08             	cmp    $0x8,%eax
f0101798:	74 08                	je     f01017a2 <readline+0x62>
f010179a:	83 f8 7f             	cmp    $0x7f,%eax
f010179d:	8d 76 00             	lea    0x0(%esi),%esi
f01017a0:	75 19                	jne    f01017bb <readline+0x7b>
f01017a2:	85 f6                	test   %esi,%esi
f01017a4:	7e 15                	jle    f01017bb <readline+0x7b>
f01017a6:	85 ff                	test   %edi,%edi
f01017a8:	74 0c                	je     f01017b6 <readline+0x76>
f01017aa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f01017b1:	e8 d4 ed ff ff       	call   f010058a <cputchar>
f01017b6:	83 ee 01             	sub    $0x1,%esi
f01017b9:	eb b8                	jmp    f0101773 <readline+0x33>
f01017bb:	83 fb 1f             	cmp    $0x1f,%ebx
f01017be:	66 90                	xchg   %ax,%ax
f01017c0:	7e 23                	jle    f01017e5 <readline+0xa5>
f01017c2:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01017c8:	7f 1b                	jg     f01017e5 <readline+0xa5>
f01017ca:	85 ff                	test   %edi,%edi
f01017cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01017d0:	74 08                	je     f01017da <readline+0x9a>
f01017d2:	89 1c 24             	mov    %ebx,(%esp)
f01017d5:	e8 b0 ed ff ff       	call   f010058a <cputchar>
f01017da:	88 9e 60 35 11 f0    	mov    %bl,-0xfeecaa0(%esi)
f01017e0:	83 c6 01             	add    $0x1,%esi
f01017e3:	eb 8e                	jmp    f0101773 <readline+0x33>
f01017e5:	83 fb 0a             	cmp    $0xa,%ebx
f01017e8:	74 05                	je     f01017ef <readline+0xaf>
f01017ea:	83 fb 0d             	cmp    $0xd,%ebx
f01017ed:	75 84                	jne    f0101773 <readline+0x33>
f01017ef:	85 ff                	test   %edi,%edi
f01017f1:	74 0c                	je     f01017ff <readline+0xbf>
f01017f3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f01017fa:	e8 8b ed ff ff       	call   f010058a <cputchar>
f01017ff:	c6 86 60 35 11 f0 00 	movb   $0x0,-0xfeecaa0(%esi)
f0101806:	b8 60 35 11 f0       	mov    $0xf0113560,%eax
f010180b:	83 c4 1c             	add    $0x1c,%esp
f010180e:	5b                   	pop    %ebx
f010180f:	5e                   	pop    %esi
f0101810:	5f                   	pop    %edi
f0101811:	5d                   	pop    %ebp
f0101812:	c3                   	ret    
	...

f0101820 <strlen>:
f0101820:	55                   	push   %ebp
f0101821:	89 e5                	mov    %esp,%ebp
f0101823:	8b 55 08             	mov    0x8(%ebp),%edx
f0101826:	b8 00 00 00 00       	mov    $0x0,%eax
f010182b:	80 3a 00             	cmpb   $0x0,(%edx)
f010182e:	74 09                	je     f0101839 <strlen+0x19>
f0101830:	83 c0 01             	add    $0x1,%eax
f0101833:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0101837:	75 f7                	jne    f0101830 <strlen+0x10>
f0101839:	5d                   	pop    %ebp
f010183a:	c3                   	ret    

f010183b <strnlen>:
f010183b:	55                   	push   %ebp
f010183c:	89 e5                	mov    %esp,%ebp
f010183e:	53                   	push   %ebx
f010183f:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101842:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0101845:	85 c9                	test   %ecx,%ecx
f0101847:	74 19                	je     f0101862 <strnlen+0x27>
f0101849:	80 3b 00             	cmpb   $0x0,(%ebx)
f010184c:	74 14                	je     f0101862 <strnlen+0x27>
f010184e:	b8 00 00 00 00       	mov    $0x0,%eax
f0101853:	83 c0 01             	add    $0x1,%eax
f0101856:	39 c8                	cmp    %ecx,%eax
f0101858:	74 0d                	je     f0101867 <strnlen+0x2c>
f010185a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
f010185e:	75 f3                	jne    f0101853 <strnlen+0x18>
f0101860:	eb 05                	jmp    f0101867 <strnlen+0x2c>
f0101862:	b8 00 00 00 00       	mov    $0x0,%eax
f0101867:	5b                   	pop    %ebx
f0101868:	5d                   	pop    %ebp
f0101869:	c3                   	ret    

f010186a <strcpy>:
f010186a:	55                   	push   %ebp
f010186b:	89 e5                	mov    %esp,%ebp
f010186d:	53                   	push   %ebx
f010186e:	8b 45 08             	mov    0x8(%ebp),%eax
f0101871:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101874:	ba 00 00 00 00       	mov    $0x0,%edx
f0101879:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f010187d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0101880:	83 c2 01             	add    $0x1,%edx
f0101883:	84 c9                	test   %cl,%cl
f0101885:	75 f2                	jne    f0101879 <strcpy+0xf>
f0101887:	5b                   	pop    %ebx
f0101888:	5d                   	pop    %ebp
f0101889:	c3                   	ret    

f010188a <strncpy>:
f010188a:	55                   	push   %ebp
f010188b:	89 e5                	mov    %esp,%ebp
f010188d:	56                   	push   %esi
f010188e:	53                   	push   %ebx
f010188f:	8b 45 08             	mov    0x8(%ebp),%eax
f0101892:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101895:	8b 75 10             	mov    0x10(%ebp),%esi
f0101898:	85 f6                	test   %esi,%esi
f010189a:	74 18                	je     f01018b4 <strncpy+0x2a>
f010189c:	b9 00 00 00 00       	mov    $0x0,%ecx
f01018a1:	0f b6 1a             	movzbl (%edx),%ebx
f01018a4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
f01018a7:	80 3a 01             	cmpb   $0x1,(%edx)
f01018aa:	83 da ff             	sbb    $0xffffffff,%edx
f01018ad:	83 c1 01             	add    $0x1,%ecx
f01018b0:	39 ce                	cmp    %ecx,%esi
f01018b2:	77 ed                	ja     f01018a1 <strncpy+0x17>
f01018b4:	5b                   	pop    %ebx
f01018b5:	5e                   	pop    %esi
f01018b6:	5d                   	pop    %ebp
f01018b7:	c3                   	ret    

f01018b8 <strlcpy>:
f01018b8:	55                   	push   %ebp
f01018b9:	89 e5                	mov    %esp,%ebp
f01018bb:	56                   	push   %esi
f01018bc:	53                   	push   %ebx
f01018bd:	8b 75 08             	mov    0x8(%ebp),%esi
f01018c0:	8b 55 0c             	mov    0xc(%ebp),%edx
f01018c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01018c6:	89 f0                	mov    %esi,%eax
f01018c8:	85 c9                	test   %ecx,%ecx
f01018ca:	74 27                	je     f01018f3 <strlcpy+0x3b>
f01018cc:	83 e9 01             	sub    $0x1,%ecx
f01018cf:	74 1d                	je     f01018ee <strlcpy+0x36>
f01018d1:	0f b6 1a             	movzbl (%edx),%ebx
f01018d4:	84 db                	test   %bl,%bl
f01018d6:	74 16                	je     f01018ee <strlcpy+0x36>
f01018d8:	88 18                	mov    %bl,(%eax)
f01018da:	83 c0 01             	add    $0x1,%eax
f01018dd:	83 e9 01             	sub    $0x1,%ecx
f01018e0:	74 0e                	je     f01018f0 <strlcpy+0x38>
f01018e2:	83 c2 01             	add    $0x1,%edx
f01018e5:	0f b6 1a             	movzbl (%edx),%ebx
f01018e8:	84 db                	test   %bl,%bl
f01018ea:	75 ec                	jne    f01018d8 <strlcpy+0x20>
f01018ec:	eb 02                	jmp    f01018f0 <strlcpy+0x38>
f01018ee:	89 f0                	mov    %esi,%eax
f01018f0:	c6 00 00             	movb   $0x0,(%eax)
f01018f3:	29 f0                	sub    %esi,%eax
f01018f5:	5b                   	pop    %ebx
f01018f6:	5e                   	pop    %esi
f01018f7:	5d                   	pop    %ebp
f01018f8:	c3                   	ret    

f01018f9 <strcmp>:
f01018f9:	55                   	push   %ebp
f01018fa:	89 e5                	mov    %esp,%ebp
f01018fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01018ff:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101902:	0f b6 01             	movzbl (%ecx),%eax
f0101905:	84 c0                	test   %al,%al
f0101907:	74 15                	je     f010191e <strcmp+0x25>
f0101909:	3a 02                	cmp    (%edx),%al
f010190b:	75 11                	jne    f010191e <strcmp+0x25>
f010190d:	83 c1 01             	add    $0x1,%ecx
f0101910:	83 c2 01             	add    $0x1,%edx
f0101913:	0f b6 01             	movzbl (%ecx),%eax
f0101916:	84 c0                	test   %al,%al
f0101918:	74 04                	je     f010191e <strcmp+0x25>
f010191a:	3a 02                	cmp    (%edx),%al
f010191c:	74 ef                	je     f010190d <strcmp+0x14>
f010191e:	0f b6 c0             	movzbl %al,%eax
f0101921:	0f b6 12             	movzbl (%edx),%edx
f0101924:	29 d0                	sub    %edx,%eax
f0101926:	5d                   	pop    %ebp
f0101927:	c3                   	ret    

f0101928 <strncmp>:
f0101928:	55                   	push   %ebp
f0101929:	89 e5                	mov    %esp,%ebp
f010192b:	53                   	push   %ebx
f010192c:	8b 55 08             	mov    0x8(%ebp),%edx
f010192f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0101932:	8b 45 10             	mov    0x10(%ebp),%eax
f0101935:	85 c0                	test   %eax,%eax
f0101937:	74 23                	je     f010195c <strncmp+0x34>
f0101939:	0f b6 1a             	movzbl (%edx),%ebx
f010193c:	84 db                	test   %bl,%bl
f010193e:	74 24                	je     f0101964 <strncmp+0x3c>
f0101940:	3a 19                	cmp    (%ecx),%bl
f0101942:	75 20                	jne    f0101964 <strncmp+0x3c>
f0101944:	83 e8 01             	sub    $0x1,%eax
f0101947:	74 13                	je     f010195c <strncmp+0x34>
f0101949:	83 c2 01             	add    $0x1,%edx
f010194c:	83 c1 01             	add    $0x1,%ecx
f010194f:	0f b6 1a             	movzbl (%edx),%ebx
f0101952:	84 db                	test   %bl,%bl
f0101954:	74 0e                	je     f0101964 <strncmp+0x3c>
f0101956:	3a 19                	cmp    (%ecx),%bl
f0101958:	74 ea                	je     f0101944 <strncmp+0x1c>
f010195a:	eb 08                	jmp    f0101964 <strncmp+0x3c>
f010195c:	b8 00 00 00 00       	mov    $0x0,%eax
f0101961:	5b                   	pop    %ebx
f0101962:	5d                   	pop    %ebp
f0101963:	c3                   	ret    
f0101964:	0f b6 02             	movzbl (%edx),%eax
f0101967:	0f b6 11             	movzbl (%ecx),%edx
f010196a:	29 d0                	sub    %edx,%eax
f010196c:	eb f3                	jmp    f0101961 <strncmp+0x39>

f010196e <strchr>:
f010196e:	55                   	push   %ebp
f010196f:	89 e5                	mov    %esp,%ebp
f0101971:	8b 45 08             	mov    0x8(%ebp),%eax
f0101974:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
f0101978:	0f b6 10             	movzbl (%eax),%edx
f010197b:	84 d2                	test   %dl,%dl
f010197d:	74 15                	je     f0101994 <strchr+0x26>
f010197f:	38 ca                	cmp    %cl,%dl
f0101981:	75 07                	jne    f010198a <strchr+0x1c>
f0101983:	eb 14                	jmp    f0101999 <strchr+0x2b>
f0101985:	38 ca                	cmp    %cl,%dl
f0101987:	90                   	nop
f0101988:	74 0f                	je     f0101999 <strchr+0x2b>
f010198a:	83 c0 01             	add    $0x1,%eax
f010198d:	0f b6 10             	movzbl (%eax),%edx
f0101990:	84 d2                	test   %dl,%dl
f0101992:	75 f1                	jne    f0101985 <strchr+0x17>
f0101994:	b8 00 00 00 00       	mov    $0x0,%eax
f0101999:	5d                   	pop    %ebp
f010199a:	c3                   	ret    

f010199b <strfind>:
f010199b:	55                   	push   %ebp
f010199c:	89 e5                	mov    %esp,%ebp
f010199e:	8b 45 08             	mov    0x8(%ebp),%eax
f01019a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
f01019a5:	0f b6 10             	movzbl (%eax),%edx
f01019a8:	84 d2                	test   %dl,%dl
f01019aa:	74 18                	je     f01019c4 <strfind+0x29>
f01019ac:	38 ca                	cmp    %cl,%dl
f01019ae:	75 0a                	jne    f01019ba <strfind+0x1f>
f01019b0:	eb 12                	jmp    f01019c4 <strfind+0x29>
f01019b2:	38 ca                	cmp    %cl,%dl
f01019b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01019b8:	74 0a                	je     f01019c4 <strfind+0x29>
f01019ba:	83 c0 01             	add    $0x1,%eax
f01019bd:	0f b6 10             	movzbl (%eax),%edx
f01019c0:	84 d2                	test   %dl,%dl
f01019c2:	75 ee                	jne    f01019b2 <strfind+0x17>
f01019c4:	5d                   	pop    %ebp
f01019c5:	c3                   	ret    

f01019c6 <memset>:
f01019c6:	55                   	push   %ebp
f01019c7:	89 e5                	mov    %esp,%ebp
f01019c9:	83 ec 0c             	sub    $0xc,%esp
f01019cc:	89 1c 24             	mov    %ebx,(%esp)
f01019cf:	89 74 24 04          	mov    %esi,0x4(%esp)
f01019d3:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01019d7:	8b 7d 08             	mov    0x8(%ebp),%edi
f01019da:	8b 45 0c             	mov    0xc(%ebp),%eax
f01019dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01019e0:	85 c9                	test   %ecx,%ecx
f01019e2:	74 30                	je     f0101a14 <memset+0x4e>
f01019e4:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01019ea:	75 25                	jne    f0101a11 <memset+0x4b>
f01019ec:	f6 c1 03             	test   $0x3,%cl
f01019ef:	75 20                	jne    f0101a11 <memset+0x4b>
f01019f1:	0f b6 d0             	movzbl %al,%edx
f01019f4:	89 d3                	mov    %edx,%ebx
f01019f6:	c1 e3 08             	shl    $0x8,%ebx
f01019f9:	89 d6                	mov    %edx,%esi
f01019fb:	c1 e6 18             	shl    $0x18,%esi
f01019fe:	89 d0                	mov    %edx,%eax
f0101a00:	c1 e0 10             	shl    $0x10,%eax
f0101a03:	09 f0                	or     %esi,%eax
f0101a05:	09 d0                	or     %edx,%eax
f0101a07:	09 d8                	or     %ebx,%eax
f0101a09:	c1 e9 02             	shr    $0x2,%ecx
f0101a0c:	fc                   	cld    
f0101a0d:	f3 ab                	rep stos %eax,%es:(%edi)
f0101a0f:	eb 03                	jmp    f0101a14 <memset+0x4e>
f0101a11:	fc                   	cld    
f0101a12:	f3 aa                	rep stos %al,%es:(%edi)
f0101a14:	89 f8                	mov    %edi,%eax
f0101a16:	8b 1c 24             	mov    (%esp),%ebx
f0101a19:	8b 74 24 04          	mov    0x4(%esp),%esi
f0101a1d:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0101a21:	89 ec                	mov    %ebp,%esp
f0101a23:	5d                   	pop    %ebp
f0101a24:	c3                   	ret    

f0101a25 <memmove>:
f0101a25:	55                   	push   %ebp
f0101a26:	89 e5                	mov    %esp,%ebp
f0101a28:	83 ec 08             	sub    $0x8,%esp
f0101a2b:	89 34 24             	mov    %esi,(%esp)
f0101a2e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101a32:	8b 45 08             	mov    0x8(%ebp),%eax
f0101a35:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0101a38:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101a3b:	89 c7                	mov    %eax,%edi
f0101a3d:	39 c6                	cmp    %eax,%esi
f0101a3f:	73 35                	jae    f0101a76 <memmove+0x51>
f0101a41:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0101a44:	39 d0                	cmp    %edx,%eax
f0101a46:	73 2e                	jae    f0101a76 <memmove+0x51>
f0101a48:	01 cf                	add    %ecx,%edi
f0101a4a:	f6 c2 03             	test   $0x3,%dl
f0101a4d:	75 1b                	jne    f0101a6a <memmove+0x45>
f0101a4f:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0101a55:	75 13                	jne    f0101a6a <memmove+0x45>
f0101a57:	f6 c1 03             	test   $0x3,%cl
f0101a5a:	75 0e                	jne    f0101a6a <memmove+0x45>
f0101a5c:	83 ef 04             	sub    $0x4,%edi
f0101a5f:	8d 72 fc             	lea    -0x4(%edx),%esi
f0101a62:	c1 e9 02             	shr    $0x2,%ecx
f0101a65:	fd                   	std    
f0101a66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0101a68:	eb 09                	jmp    f0101a73 <memmove+0x4e>
f0101a6a:	83 ef 01             	sub    $0x1,%edi
f0101a6d:	8d 72 ff             	lea    -0x1(%edx),%esi
f0101a70:	fd                   	std    
f0101a71:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
f0101a73:	fc                   	cld    
f0101a74:	eb 20                	jmp    f0101a96 <memmove+0x71>
f0101a76:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0101a7c:	75 15                	jne    f0101a93 <memmove+0x6e>
f0101a7e:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0101a84:	75 0d                	jne    f0101a93 <memmove+0x6e>
f0101a86:	f6 c1 03             	test   $0x3,%cl
f0101a89:	75 08                	jne    f0101a93 <memmove+0x6e>
f0101a8b:	c1 e9 02             	shr    $0x2,%ecx
f0101a8e:	fc                   	cld    
f0101a8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0101a91:	eb 03                	jmp    f0101a96 <memmove+0x71>
f0101a93:	fc                   	cld    
f0101a94:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
f0101a96:	8b 34 24             	mov    (%esp),%esi
f0101a99:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0101a9d:	89 ec                	mov    %ebp,%esp
f0101a9f:	5d                   	pop    %ebp
f0101aa0:	c3                   	ret    

f0101aa1 <memcpy>:
f0101aa1:	55                   	push   %ebp
f0101aa2:	89 e5                	mov    %esp,%ebp
f0101aa4:	83 ec 0c             	sub    $0xc,%esp
f0101aa7:	8b 45 10             	mov    0x10(%ebp),%eax
f0101aaa:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101aae:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
f0101ab8:	89 04 24             	mov    %eax,(%esp)
f0101abb:	e8 65 ff ff ff       	call   f0101a25 <memmove>
f0101ac0:	c9                   	leave  
f0101ac1:	c3                   	ret    

f0101ac2 <memcmp>:
f0101ac2:	55                   	push   %ebp
f0101ac3:	89 e5                	mov    %esp,%ebp
f0101ac5:	57                   	push   %edi
f0101ac6:	56                   	push   %esi
f0101ac7:	53                   	push   %ebx
f0101ac8:	8b 75 08             	mov    0x8(%ebp),%esi
f0101acb:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0101ace:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0101ad1:	85 c9                	test   %ecx,%ecx
f0101ad3:	74 36                	je     f0101b0b <memcmp+0x49>
f0101ad5:	0f b6 06             	movzbl (%esi),%eax
f0101ad8:	0f b6 1f             	movzbl (%edi),%ebx
f0101adb:	38 d8                	cmp    %bl,%al
f0101add:	74 20                	je     f0101aff <memcmp+0x3d>
f0101adf:	eb 14                	jmp    f0101af5 <memcmp+0x33>
f0101ae1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
f0101ae6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
f0101aeb:	83 c2 01             	add    $0x1,%edx
f0101aee:	83 e9 01             	sub    $0x1,%ecx
f0101af1:	38 d8                	cmp    %bl,%al
f0101af3:	74 12                	je     f0101b07 <memcmp+0x45>
f0101af5:	0f b6 c0             	movzbl %al,%eax
f0101af8:	0f b6 db             	movzbl %bl,%ebx
f0101afb:	29 d8                	sub    %ebx,%eax
f0101afd:	eb 11                	jmp    f0101b10 <memcmp+0x4e>
f0101aff:	83 e9 01             	sub    $0x1,%ecx
f0101b02:	ba 00 00 00 00       	mov    $0x0,%edx
f0101b07:	85 c9                	test   %ecx,%ecx
f0101b09:	75 d6                	jne    f0101ae1 <memcmp+0x1f>
f0101b0b:	b8 00 00 00 00       	mov    $0x0,%eax
f0101b10:	5b                   	pop    %ebx
f0101b11:	5e                   	pop    %esi
f0101b12:	5f                   	pop    %edi
f0101b13:	5d                   	pop    %ebp
f0101b14:	c3                   	ret    

f0101b15 <memfind>:
f0101b15:	55                   	push   %ebp
f0101b16:	89 e5                	mov    %esp,%ebp
f0101b18:	8b 45 08             	mov    0x8(%ebp),%eax
f0101b1b:	89 c2                	mov    %eax,%edx
f0101b1d:	03 55 10             	add    0x10(%ebp),%edx
f0101b20:	39 d0                	cmp    %edx,%eax
f0101b22:	73 15                	jae    f0101b39 <memfind+0x24>
f0101b24:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
f0101b28:	38 08                	cmp    %cl,(%eax)
f0101b2a:	75 06                	jne    f0101b32 <memfind+0x1d>
f0101b2c:	eb 0b                	jmp    f0101b39 <memfind+0x24>
f0101b2e:	38 08                	cmp    %cl,(%eax)
f0101b30:	74 07                	je     f0101b39 <memfind+0x24>
f0101b32:	83 c0 01             	add    $0x1,%eax
f0101b35:	39 c2                	cmp    %eax,%edx
f0101b37:	77 f5                	ja     f0101b2e <memfind+0x19>
f0101b39:	5d                   	pop    %ebp
f0101b3a:	c3                   	ret    

f0101b3b <strtol>:
f0101b3b:	55                   	push   %ebp
f0101b3c:	89 e5                	mov    %esp,%ebp
f0101b3e:	57                   	push   %edi
f0101b3f:	56                   	push   %esi
f0101b40:	53                   	push   %ebx
f0101b41:	83 ec 04             	sub    $0x4,%esp
f0101b44:	8b 55 08             	mov    0x8(%ebp),%edx
f0101b47:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0101b4a:	0f b6 02             	movzbl (%edx),%eax
f0101b4d:	3c 20                	cmp    $0x20,%al
f0101b4f:	74 04                	je     f0101b55 <strtol+0x1a>
f0101b51:	3c 09                	cmp    $0x9,%al
f0101b53:	75 0e                	jne    f0101b63 <strtol+0x28>
f0101b55:	83 c2 01             	add    $0x1,%edx
f0101b58:	0f b6 02             	movzbl (%edx),%eax
f0101b5b:	3c 20                	cmp    $0x20,%al
f0101b5d:	74 f6                	je     f0101b55 <strtol+0x1a>
f0101b5f:	3c 09                	cmp    $0x9,%al
f0101b61:	74 f2                	je     f0101b55 <strtol+0x1a>
f0101b63:	3c 2b                	cmp    $0x2b,%al
f0101b65:	75 0c                	jne    f0101b73 <strtol+0x38>
f0101b67:	83 c2 01             	add    $0x1,%edx
f0101b6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101b71:	eb 15                	jmp    f0101b88 <strtol+0x4d>
f0101b73:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101b7a:	3c 2d                	cmp    $0x2d,%al
f0101b7c:	75 0a                	jne    f0101b88 <strtol+0x4d>
f0101b7e:	83 c2 01             	add    $0x1,%edx
f0101b81:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
f0101b88:	85 db                	test   %ebx,%ebx
f0101b8a:	0f 94 c0             	sete   %al
f0101b8d:	74 05                	je     f0101b94 <strtol+0x59>
f0101b8f:	83 fb 10             	cmp    $0x10,%ebx
f0101b92:	75 18                	jne    f0101bac <strtol+0x71>
f0101b94:	80 3a 30             	cmpb   $0x30,(%edx)
f0101b97:	75 13                	jne    f0101bac <strtol+0x71>
f0101b99:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0101b9d:	8d 76 00             	lea    0x0(%esi),%esi
f0101ba0:	75 0a                	jne    f0101bac <strtol+0x71>
f0101ba2:	83 c2 02             	add    $0x2,%edx
f0101ba5:	bb 10 00 00 00       	mov    $0x10,%ebx
f0101baa:	eb 15                	jmp    f0101bc1 <strtol+0x86>
f0101bac:	84 c0                	test   %al,%al
f0101bae:	66 90                	xchg   %ax,%ax
f0101bb0:	74 0f                	je     f0101bc1 <strtol+0x86>
f0101bb2:	bb 0a 00 00 00       	mov    $0xa,%ebx
f0101bb7:	80 3a 30             	cmpb   $0x30,(%edx)
f0101bba:	75 05                	jne    f0101bc1 <strtol+0x86>
f0101bbc:	83 c2 01             	add    $0x1,%edx
f0101bbf:	b3 08                	mov    $0x8,%bl
f0101bc1:	b8 00 00 00 00       	mov    $0x0,%eax
f0101bc6:	89 de                	mov    %ebx,%esi
f0101bc8:	0f b6 0a             	movzbl (%edx),%ecx
f0101bcb:	89 cf                	mov    %ecx,%edi
f0101bcd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
f0101bd0:	80 fb 09             	cmp    $0x9,%bl
f0101bd3:	77 08                	ja     f0101bdd <strtol+0xa2>
f0101bd5:	0f be c9             	movsbl %cl,%ecx
f0101bd8:	83 e9 30             	sub    $0x30,%ecx
f0101bdb:	eb 1e                	jmp    f0101bfb <strtol+0xc0>
f0101bdd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
f0101be0:	80 fb 19             	cmp    $0x19,%bl
f0101be3:	77 08                	ja     f0101bed <strtol+0xb2>
f0101be5:	0f be c9             	movsbl %cl,%ecx
f0101be8:	83 e9 57             	sub    $0x57,%ecx
f0101beb:	eb 0e                	jmp    f0101bfb <strtol+0xc0>
f0101bed:	8d 5f bf             	lea    -0x41(%edi),%ebx
f0101bf0:	80 fb 19             	cmp    $0x19,%bl
f0101bf3:	77 15                	ja     f0101c0a <strtol+0xcf>
f0101bf5:	0f be c9             	movsbl %cl,%ecx
f0101bf8:	83 e9 37             	sub    $0x37,%ecx
f0101bfb:	39 f1                	cmp    %esi,%ecx
f0101bfd:	7d 0b                	jge    f0101c0a <strtol+0xcf>
f0101bff:	83 c2 01             	add    $0x1,%edx
f0101c02:	0f af c6             	imul   %esi,%eax
f0101c05:	8d 04 01             	lea    (%ecx,%eax,1),%eax
f0101c08:	eb be                	jmp    f0101bc8 <strtol+0x8d>
f0101c0a:	89 c1                	mov    %eax,%ecx
f0101c0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0101c10:	74 05                	je     f0101c17 <strtol+0xdc>
f0101c12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101c15:	89 13                	mov    %edx,(%ebx)
f0101c17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0101c1b:	74 04                	je     f0101c21 <strtol+0xe6>
f0101c1d:	89 c8                	mov    %ecx,%eax
f0101c1f:	f7 d8                	neg    %eax
f0101c21:	83 c4 04             	add    $0x4,%esp
f0101c24:	5b                   	pop    %ebx
f0101c25:	5e                   	pop    %esi
f0101c26:	5f                   	pop    %edi
f0101c27:	5d                   	pop    %ebp
f0101c28:	c3                   	ret    
f0101c29:	00 00                	add    %al,(%eax)
f0101c2b:	00 00                	add    %al,(%eax)
f0101c2d:	00 00                	add    %al,(%eax)
	...

f0101c30 <__udivdi3>:
f0101c30:	55                   	push   %ebp
f0101c31:	89 e5                	mov    %esp,%ebp
f0101c33:	57                   	push   %edi
f0101c34:	56                   	push   %esi
f0101c35:	83 ec 10             	sub    $0x10,%esp
f0101c38:	8b 45 14             	mov    0x14(%ebp),%eax
f0101c3b:	8b 55 08             	mov    0x8(%ebp),%edx
f0101c3e:	8b 75 10             	mov    0x10(%ebp),%esi
f0101c41:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0101c44:	85 c0                	test   %eax,%eax
f0101c46:	89 55 f0             	mov    %edx,-0x10(%ebp)
f0101c49:	75 35                	jne    f0101c80 <__udivdi3+0x50>
f0101c4b:	39 fe                	cmp    %edi,%esi
f0101c4d:	77 61                	ja     f0101cb0 <__udivdi3+0x80>
f0101c4f:	85 f6                	test   %esi,%esi
f0101c51:	75 0b                	jne    f0101c5e <__udivdi3+0x2e>
f0101c53:	b8 01 00 00 00       	mov    $0x1,%eax
f0101c58:	31 d2                	xor    %edx,%edx
f0101c5a:	f7 f6                	div    %esi
f0101c5c:	89 c6                	mov    %eax,%esi
f0101c5e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0101c61:	31 d2                	xor    %edx,%edx
f0101c63:	89 f8                	mov    %edi,%eax
f0101c65:	f7 f6                	div    %esi
f0101c67:	89 c7                	mov    %eax,%edi
f0101c69:	89 c8                	mov    %ecx,%eax
f0101c6b:	f7 f6                	div    %esi
f0101c6d:	89 c1                	mov    %eax,%ecx
f0101c6f:	89 fa                	mov    %edi,%edx
f0101c71:	89 c8                	mov    %ecx,%eax
f0101c73:	83 c4 10             	add    $0x10,%esp
f0101c76:	5e                   	pop    %esi
f0101c77:	5f                   	pop    %edi
f0101c78:	5d                   	pop    %ebp
f0101c79:	c3                   	ret    
f0101c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101c80:	39 f8                	cmp    %edi,%eax
f0101c82:	77 1c                	ja     f0101ca0 <__udivdi3+0x70>
f0101c84:	0f bd d0             	bsr    %eax,%edx
f0101c87:	83 f2 1f             	xor    $0x1f,%edx
f0101c8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101c8d:	75 39                	jne    f0101cc8 <__udivdi3+0x98>
f0101c8f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0101c92:	0f 86 a0 00 00 00    	jbe    f0101d38 <__udivdi3+0x108>
f0101c98:	39 f8                	cmp    %edi,%eax
f0101c9a:	0f 82 98 00 00 00    	jb     f0101d38 <__udivdi3+0x108>
f0101ca0:	31 ff                	xor    %edi,%edi
f0101ca2:	31 c9                	xor    %ecx,%ecx
f0101ca4:	89 c8                	mov    %ecx,%eax
f0101ca6:	89 fa                	mov    %edi,%edx
f0101ca8:	83 c4 10             	add    $0x10,%esp
f0101cab:	5e                   	pop    %esi
f0101cac:	5f                   	pop    %edi
f0101cad:	5d                   	pop    %ebp
f0101cae:	c3                   	ret    
f0101caf:	90                   	nop
f0101cb0:	89 d1                	mov    %edx,%ecx
f0101cb2:	89 fa                	mov    %edi,%edx
f0101cb4:	89 c8                	mov    %ecx,%eax
f0101cb6:	31 ff                	xor    %edi,%edi
f0101cb8:	f7 f6                	div    %esi
f0101cba:	89 c1                	mov    %eax,%ecx
f0101cbc:	89 fa                	mov    %edi,%edx
f0101cbe:	89 c8                	mov    %ecx,%eax
f0101cc0:	83 c4 10             	add    $0x10,%esp
f0101cc3:	5e                   	pop    %esi
f0101cc4:	5f                   	pop    %edi
f0101cc5:	5d                   	pop    %ebp
f0101cc6:	c3                   	ret    
f0101cc7:	90                   	nop
f0101cc8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101ccc:	89 f2                	mov    %esi,%edx
f0101cce:	d3 e0                	shl    %cl,%eax
f0101cd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0101cd3:	b8 20 00 00 00       	mov    $0x20,%eax
f0101cd8:	2b 45 f4             	sub    -0xc(%ebp),%eax
f0101cdb:	89 c1                	mov    %eax,%ecx
f0101cdd:	d3 ea                	shr    %cl,%edx
f0101cdf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101ce3:	0b 55 ec             	or     -0x14(%ebp),%edx
f0101ce6:	d3 e6                	shl    %cl,%esi
f0101ce8:	89 c1                	mov    %eax,%ecx
f0101cea:	89 75 e8             	mov    %esi,-0x18(%ebp)
f0101ced:	89 fe                	mov    %edi,%esi
f0101cef:	d3 ee                	shr    %cl,%esi
f0101cf1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101cf5:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101cf8:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101cfb:	d3 e7                	shl    %cl,%edi
f0101cfd:	89 c1                	mov    %eax,%ecx
f0101cff:	d3 ea                	shr    %cl,%edx
f0101d01:	09 d7                	or     %edx,%edi
f0101d03:	89 f2                	mov    %esi,%edx
f0101d05:	89 f8                	mov    %edi,%eax
f0101d07:	f7 75 ec             	divl   -0x14(%ebp)
f0101d0a:	89 d6                	mov    %edx,%esi
f0101d0c:	89 c7                	mov    %eax,%edi
f0101d0e:	f7 65 e8             	mull   -0x18(%ebp)
f0101d11:	39 d6                	cmp    %edx,%esi
f0101d13:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101d16:	72 30                	jb     f0101d48 <__udivdi3+0x118>
f0101d18:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101d1b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0101d1f:	d3 e2                	shl    %cl,%edx
f0101d21:	39 c2                	cmp    %eax,%edx
f0101d23:	73 05                	jae    f0101d2a <__udivdi3+0xfa>
f0101d25:	3b 75 ec             	cmp    -0x14(%ebp),%esi
f0101d28:	74 1e                	je     f0101d48 <__udivdi3+0x118>
f0101d2a:	89 f9                	mov    %edi,%ecx
f0101d2c:	31 ff                	xor    %edi,%edi
f0101d2e:	e9 71 ff ff ff       	jmp    f0101ca4 <__udivdi3+0x74>
f0101d33:	90                   	nop
f0101d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101d38:	31 ff                	xor    %edi,%edi
f0101d3a:	b9 01 00 00 00       	mov    $0x1,%ecx
f0101d3f:	e9 60 ff ff ff       	jmp    f0101ca4 <__udivdi3+0x74>
f0101d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101d48:	8d 4f ff             	lea    -0x1(%edi),%ecx
f0101d4b:	31 ff                	xor    %edi,%edi
f0101d4d:	89 c8                	mov    %ecx,%eax
f0101d4f:	89 fa                	mov    %edi,%edx
f0101d51:	83 c4 10             	add    $0x10,%esp
f0101d54:	5e                   	pop    %esi
f0101d55:	5f                   	pop    %edi
f0101d56:	5d                   	pop    %ebp
f0101d57:	c3                   	ret    
	...

f0101d60 <__umoddi3>:
f0101d60:	55                   	push   %ebp
f0101d61:	89 e5                	mov    %esp,%ebp
f0101d63:	57                   	push   %edi
f0101d64:	56                   	push   %esi
f0101d65:	83 ec 20             	sub    $0x20,%esp
f0101d68:	8b 55 14             	mov    0x14(%ebp),%edx
f0101d6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101d6e:	8b 7d 10             	mov    0x10(%ebp),%edi
f0101d71:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101d74:	85 d2                	test   %edx,%edx
f0101d76:	89 c8                	mov    %ecx,%eax
f0101d78:	89 4d f4             	mov    %ecx,-0xc(%ebp)
f0101d7b:	75 13                	jne    f0101d90 <__umoddi3+0x30>
f0101d7d:	39 f7                	cmp    %esi,%edi
f0101d7f:	76 3f                	jbe    f0101dc0 <__umoddi3+0x60>
f0101d81:	89 f2                	mov    %esi,%edx
f0101d83:	f7 f7                	div    %edi
f0101d85:	89 d0                	mov    %edx,%eax
f0101d87:	31 d2                	xor    %edx,%edx
f0101d89:	83 c4 20             	add    $0x20,%esp
f0101d8c:	5e                   	pop    %esi
f0101d8d:	5f                   	pop    %edi
f0101d8e:	5d                   	pop    %ebp
f0101d8f:	c3                   	ret    
f0101d90:	39 f2                	cmp    %esi,%edx
f0101d92:	77 4c                	ja     f0101de0 <__umoddi3+0x80>
f0101d94:	0f bd ca             	bsr    %edx,%ecx
f0101d97:	83 f1 1f             	xor    $0x1f,%ecx
f0101d9a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0101d9d:	75 51                	jne    f0101df0 <__umoddi3+0x90>
f0101d9f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
f0101da2:	0f 87 e0 00 00 00    	ja     f0101e88 <__umoddi3+0x128>
f0101da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101dab:	29 f8                	sub    %edi,%eax
f0101dad:	19 d6                	sbb    %edx,%esi
f0101daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101db5:	89 f2                	mov    %esi,%edx
f0101db7:	83 c4 20             	add    $0x20,%esp
f0101dba:	5e                   	pop    %esi
f0101dbb:	5f                   	pop    %edi
f0101dbc:	5d                   	pop    %ebp
f0101dbd:	c3                   	ret    
f0101dbe:	66 90                	xchg   %ax,%ax
f0101dc0:	85 ff                	test   %edi,%edi
f0101dc2:	75 0b                	jne    f0101dcf <__umoddi3+0x6f>
f0101dc4:	b8 01 00 00 00       	mov    $0x1,%eax
f0101dc9:	31 d2                	xor    %edx,%edx
f0101dcb:	f7 f7                	div    %edi
f0101dcd:	89 c7                	mov    %eax,%edi
f0101dcf:	89 f0                	mov    %esi,%eax
f0101dd1:	31 d2                	xor    %edx,%edx
f0101dd3:	f7 f7                	div    %edi
f0101dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101dd8:	f7 f7                	div    %edi
f0101dda:	eb a9                	jmp    f0101d85 <__umoddi3+0x25>
f0101ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101de0:	89 c8                	mov    %ecx,%eax
f0101de2:	89 f2                	mov    %esi,%edx
f0101de4:	83 c4 20             	add    $0x20,%esp
f0101de7:	5e                   	pop    %esi
f0101de8:	5f                   	pop    %edi
f0101de9:	5d                   	pop    %ebp
f0101dea:	c3                   	ret    
f0101deb:	90                   	nop
f0101dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101df0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101df4:	d3 e2                	shl    %cl,%edx
f0101df6:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101df9:	ba 20 00 00 00       	mov    $0x20,%edx
f0101dfe:	2b 55 f0             	sub    -0x10(%ebp),%edx
f0101e01:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101e04:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101e08:	89 fa                	mov    %edi,%edx
f0101e0a:	d3 ea                	shr    %cl,%edx
f0101e0c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101e10:	0b 55 f4             	or     -0xc(%ebp),%edx
f0101e13:	d3 e7                	shl    %cl,%edi
f0101e15:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101e19:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101e1c:	89 f2                	mov    %esi,%edx
f0101e1e:	89 7d e8             	mov    %edi,-0x18(%ebp)
f0101e21:	89 c7                	mov    %eax,%edi
f0101e23:	d3 ea                	shr    %cl,%edx
f0101e25:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101e29:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101e2c:	89 c2                	mov    %eax,%edx
f0101e2e:	d3 e6                	shl    %cl,%esi
f0101e30:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101e34:	d3 ea                	shr    %cl,%edx
f0101e36:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101e3a:	09 d6                	or     %edx,%esi
f0101e3c:	89 f0                	mov    %esi,%eax
f0101e3e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0101e41:	d3 e7                	shl    %cl,%edi
f0101e43:	89 f2                	mov    %esi,%edx
f0101e45:	f7 75 f4             	divl   -0xc(%ebp)
f0101e48:	89 d6                	mov    %edx,%esi
f0101e4a:	f7 65 e8             	mull   -0x18(%ebp)
f0101e4d:	39 d6                	cmp    %edx,%esi
f0101e4f:	72 2b                	jb     f0101e7c <__umoddi3+0x11c>
f0101e51:	39 c7                	cmp    %eax,%edi
f0101e53:	72 23                	jb     f0101e78 <__umoddi3+0x118>
f0101e55:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101e59:	29 c7                	sub    %eax,%edi
f0101e5b:	19 d6                	sbb    %edx,%esi
f0101e5d:	89 f0                	mov    %esi,%eax
f0101e5f:	89 f2                	mov    %esi,%edx
f0101e61:	d3 ef                	shr    %cl,%edi
f0101e63:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101e67:	d3 e0                	shl    %cl,%eax
f0101e69:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101e6d:	09 f8                	or     %edi,%eax
f0101e6f:	d3 ea                	shr    %cl,%edx
f0101e71:	83 c4 20             	add    $0x20,%esp
f0101e74:	5e                   	pop    %esi
f0101e75:	5f                   	pop    %edi
f0101e76:	5d                   	pop    %ebp
f0101e77:	c3                   	ret    
f0101e78:	39 d6                	cmp    %edx,%esi
f0101e7a:	75 d9                	jne    f0101e55 <__umoddi3+0xf5>
f0101e7c:	2b 45 e8             	sub    -0x18(%ebp),%eax
f0101e7f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
f0101e82:	eb d1                	jmp    f0101e55 <__umoddi3+0xf5>
f0101e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101e88:	39 f2                	cmp    %esi,%edx
f0101e8a:	0f 82 18 ff ff ff    	jb     f0101da8 <__umoddi3+0x48>
f0101e90:	e9 1d ff ff ff       	jmp    f0101db2 <__umoddi3+0x52>

Disassembly of section .rodata:

f0101ea0 <shiftcode-0x140>:
f0101ea0:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
f0101ea4:	65                   	gs
f0101ea5:	6c                   	insb   (%dx),%es:(%edi)
f0101ea6:	20 77 61             	and    %dh,0x61(%edi)
f0101ea9:	72 6e                	jb     f0101f19 <etext+0x84>
f0101eab:	69 6e 67 20 61 74 20 	imul   $0x20746120,0x67(%esi),%ebp
f0101eb2:	25 73 3a 25 64       	and    $0x64253a73,%eax
f0101eb7:	3a 20                	cmp    (%eax),%ah
f0101eb9:	00 6b 65             	add    %ch,0x65(%ebx)
f0101ebc:	72 6e                	jb     f0101f2c <etext+0x97>
f0101ebe:	65                   	gs
f0101ebf:	6c                   	insb   (%dx),%es:(%edi)
f0101ec0:	20 70 61             	and    %dh,0x61(%eax)
f0101ec3:	6e                   	outsb  %ds:(%esi),(%dx)
f0101ec4:	69 63 20 61 74 20 25 	imul   $0x25207461,0x20(%ebx),%esp
f0101ecb:	73 3a                	jae    f0101f07 <etext+0x72>
f0101ecd:	25 64 3a 20 00       	and    $0x203a64,%eax
f0101ed2:	65 6e                	outsb  %gs:(%esi),(%dx)
f0101ed4:	74 65                	je     f0101f3b <etext+0xa6>
f0101ed6:	72 69                	jb     f0101f41 <etext+0xac>
f0101ed8:	6e                   	outsb  %ds:(%esi),(%dx)
f0101ed9:	67 20 74 65          	addr16 and %dh,0x65(%si)
f0101edd:	73 74                	jae    f0101f53 <etext+0xbe>
f0101edf:	5f                   	pop    %edi
f0101ee0:	62 61 63             	bound  %esp,0x63(%ecx)
f0101ee3:	6b 74 72 61 63       	imul   $0x63,0x61(%edx,%esi,2),%esi
f0101ee8:	65 20 25 64 0a 00 6c 	and    %ah,%gs:0x6c000a64
f0101eef:	65                   	gs
f0101ef0:	61                   	popa   
f0101ef1:	76 69                	jbe    f0101f5c <etext+0xc7>
f0101ef3:	6e                   	outsb  %ds:(%esi),(%dx)
f0101ef4:	67 20 74 65          	addr16 and %dh,0x65(%si)
f0101ef8:	73 74                	jae    f0101f6e <etext+0xd9>
f0101efa:	5f                   	pop    %edi
f0101efb:	62 61 63             	bound  %esp,0x63(%ecx)
f0101efe:	6b 74 72 61 63       	imul   $0x63,0x61(%edx,%esi,2),%esi
f0101f03:	65 20 25 64 0a 00 63 	and    %ah,%gs:0x63000a64
f0101f0a:	68 6e 75 6d 31       	push   $0x316d756e
f0101f0f:	3a 20                	cmp    (%eax),%ah
f0101f11:	25 64 20 63 68       	and    $0x68632064,%eax
f0101f16:	6e                   	outsb  %ds:(%esi),(%dx)
f0101f17:	75 6d                	jne    f0101f86 <etext+0xf1>
f0101f19:	32 3a                	xor    (%edx),%bh
f0101f1b:	20 25 64 0a 00 25    	and    %ah,0x25000a64
f0101f21:	73 25                	jae    f0101f48 <etext+0xb3>
f0101f23:	6e                   	outsb  %ds:(%esi),(%dx)
f0101f24:	00 63 68             	add    %ah,0x68(%ebx)
f0101f27:	6e                   	outsb  %ds:(%esi),(%dx)
f0101f28:	75 6d                	jne    f0101f97 <etext+0x102>
f0101f2a:	31 3a                	xor    %edi,(%edx)
f0101f2c:	20 25 64 0a 00 73    	and    %ah,0x73000a64
f0101f32:	68 6f 77 20 6d       	push   $0x6d20776f
f0101f37:	65 20 74 68 65       	and    %dh,%gs:0x65(%eax,%ebp,2)
f0101f3c:	20 73 69             	and    %dh,0x69(%ebx)
f0101f3f:	67 6e                	addr16 outsb %ds:(%si),(%dx)
f0101f41:	3a 20                	cmp    (%eax),%ah
f0101f43:	25 2b 64 2c 20       	and    $0x202c642b,%eax
f0101f48:	25 2b 64 0a 00       	and    $0xa642b,%eax
f0101f4d:	00 00                	add    %al,(%eax)
f0101f4f:	00 36                	add    %dh,(%esi)
f0101f51:	38 32                	cmp    %dh,(%edx)
f0101f53:	38 20                	cmp    %ah,(%eax)
f0101f55:	64 65 63 69 6d       	arpl   %bp,%fs:%gs:0x6d(%ecx)
f0101f5a:	61                   	popa   
f0101f5b:	6c                   	insb   (%dx),%es:(%edi)
f0101f5c:	20 69 73             	and    %ch,0x73(%ecx)
f0101f5f:	20 25 6f 20 6f 63    	and    %ah,0x636f206f
f0101f65:	74 61                	je     f0101fc8 <etext+0x133>
f0101f67:	6c                   	insb   (%dx),%es:(%edi)
f0101f68:	21 25 6e 0a 25 6e    	and    %esp,0x6e250a6e
f0101f6e:	00 00                	add    %al,(%eax)
f0101f70:	70 61                	jo     f0101fd3 <etext+0x13e>
f0101f72:	64 69 6e 67 20 73 70 	imul   $0x61707320,%fs:0x67(%esi),%ebp
f0101f79:	61 
f0101f7a:	63 65 20             	arpl   %sp,0x20(%ebp)
f0101f7d:	69 6e 20 74 68 65 20 	imul   $0x20656874,0x20(%esi),%ebp
f0101f84:	72 69                	jb     f0101fef <shiftcode+0xf>
f0101f86:	67 68 74 20 74 6f    	addr16 push $0x6f742074
f0101f8c:	20 6e 75             	and    %ch,0x75(%esi)
f0101f8f:	6d                   	insl   (%dx),%es:(%edi)
f0101f90:	62 65 72             	bound  %esp,0x72(%ebp)
f0101f93:	20 32                	and    %dh,(%edx)
f0101f95:	32 3a                	xor    (%edx),%bh
f0101f97:	20 25 38 64 2e 0a    	and    %ah,0xa2e6438
f0101f9d:	00 53 65             	add    %dl,0x65(%ebx)
f0101fa0:	72 69                	jb     f010200b <shiftcode+0x2b>
f0101fa2:	61                   	popa   
f0101fa3:	6c                   	insb   (%dx),%es:(%edi)
f0101fa4:	20 70 6f             	and    %dh,0x6f(%eax)
f0101fa7:	72 74                	jb     f010201d <shiftcode+0x3d>
f0101fa9:	20 64 6f 65          	and    %ah,0x65(%edi,%ebp,2)
f0101fad:	73 20                	jae    f0101fcf <etext+0x13a>
f0101faf:	6e                   	outsb  %ds:(%esi),(%dx)
f0101fb0:	6f                   	outsl  %ds:(%esi),(%dx)
f0101fb1:	74 20                	je     f0101fd3 <etext+0x13e>
f0101fb3:	65                   	gs
f0101fb4:	78 69                	js     f010201f <shiftcode+0x3f>
f0101fb6:	73 74                	jae    f010202c <shiftcode+0x4c>
f0101fb8:	21 0a                	and    %ecx,(%edx)
f0101fba:	00 52 65             	add    %dl,0x65(%edx)
f0101fbd:	62 6f 6f             	bound  %ebp,0x6f(%edi)
f0101fc0:	74 69                	je     f010202b <shiftcode+0x4b>
f0101fc2:	6e                   	outsb  %ds:(%esi),(%dx)
f0101fc3:	67 21 0a             	addr16 and %ecx,(%bp,%si)
	...

f0101fe0 <shiftcode>:
	...
f0101ffc:	00 02                	add    %al,(%edx)
	...
f010200a:	01 00                	add    %eax,(%eax)
	...
f0102014:	00 00                	add    %al,(%eax)
f0102016:	01 00                	add    %eax,(%eax)
f0102018:	04 00                	add    $0x0,%al
	...
f010207a:	00 00                	add    %al,(%eax)
f010207c:	00 02                	add    %al,(%edx)
	...
f0102096:	00 00                	add    %al,(%eax)
f0102098:	04 00                	add    $0x0,%al
	...

f01020e0 <togglecode>:
	...
f0102118:	00 00                	add    %al,(%eax)
f010211a:	08 00                	or     %al,(%eax)
	...
f0102124:	00 10                	add    %dl,(%eax)
f0102126:	20 00                	and    %al,(%eax)
	...

f01021e0 <charcode>:
f01021e0:	00 30                	add    %dh,(%eax)
f01021e2:	11 f0                	adc    %esi,%eax
f01021e4:	00 31                	add    %dh,(%ecx)
f01021e6:	11 f0                	adc    %esi,%eax
f01021e8:	00 32                	add    %dh,(%edx)
f01021ea:	11 f0                	adc    %esi,%eax
f01021ec:	00 32                	add    %dh,(%edx)
f01021ee:	11 f0                	adc    %esi,%eax
f01021f0:	4f                   	dec    %edi
f01021f1:	76 65                	jbe    f0102258 <charcode+0x78>
f01021f3:	72 66                	jb     f010225b <charcode+0x7b>
f01021f5:	6c                   	insb   (%dx),%es:(%edi)
f01021f6:	6f                   	outsl  %ds:(%esi),(%dx)
f01021f7:	77 20                	ja     f0102219 <charcode+0x39>
f01021f9:	73 75                	jae    f0102270 <charcode+0x90>
f01021fb:	63 63 65             	arpl   %sp,0x65(%ebx)
f01021fe:	73 73                	jae    f0102273 <charcode+0x93>
f0102200:	0a 00                	or     (%eax),%al
f0102202:	53                   	push   %ebx
f0102203:	70 65                	jo     f010226a <charcode+0x8a>
f0102205:	63 69 61             	arpl   %bp,0x61(%ecx)
f0102208:	6c                   	insb   (%dx),%es:(%edi)
f0102209:	20 6b 65             	and    %ch,0x65(%ebx)
f010220c:	72 6e                	jb     f010227c <charcode+0x9c>
f010220e:	65                   	gs
f010220f:	6c                   	insb   (%dx),%es:(%edi)
f0102210:	20 73 79             	and    %dh,0x79(%ebx)
f0102213:	6d                   	insl   (%dx),%es:(%edi)
f0102214:	62 6f 6c             	bound  %ebp,0x6c(%edi)
f0102217:	73 3a                	jae    f0102253 <charcode+0x73>
f0102219:	0a 00                	or     (%eax),%al
f010221b:	25 73 20 2d 20       	and    $0x202d2073,%eax
f0102220:	25 73 0a 00 4b       	and    $0x4b000a73,%eax
f0102225:	3e 20 00             	and    %al,%ds:(%eax)
f0102228:	09 0d 0a 20 00 54    	or     %ecx,0x5400200a
f010222e:	6f                   	outsl  %ds:(%esi),(%dx)
f010222f:	6f                   	outsl  %ds:(%esi),(%dx)
f0102230:	20 6d 61             	and    %ch,0x61(%ebp)
f0102233:	6e                   	outsb  %ds:(%esi),(%dx)
f0102234:	79 20                	jns    f0102256 <charcode+0x76>
f0102236:	61                   	popa   
f0102237:	72 67                	jb     f01022a0 <charcode+0xc0>
f0102239:	75 6d                	jne    f01022a8 <charcode+0xc8>
f010223b:	65 6e                	outsb  %gs:(%esi),(%dx)
f010223d:	74 73                	je     f01022b2 <charcode+0xd2>
f010223f:	20 28                	and    %ch,(%eax)
f0102241:	6d                   	insl   (%dx),%es:(%edi)
f0102242:	61                   	popa   
f0102243:	78 20                	js     f0102265 <charcode+0x85>
f0102245:	25 64 29 0a 00       	and    $0xa2964,%eax
f010224a:	55                   	push   %ebp
f010224b:	6e                   	outsb  %ds:(%esi),(%dx)
f010224c:	6b 6e 6f 77          	imul   $0x77,0x6f(%esi),%ebp
f0102250:	6e                   	outsb  %ds:(%esi),(%dx)
f0102251:	20 63 6f             	and    %ah,0x6f(%ebx)
f0102254:	6d                   	insl   (%dx),%es:(%edi)
f0102255:	6d                   	insl   (%dx),%es:(%edi)
f0102256:	61                   	popa   
f0102257:	6e                   	outsb  %ds:(%esi),(%dx)
f0102258:	64 20 27             	and    %ah,%fs:(%edi)
f010225b:	25 73 27 0a 00       	and    $0xa2773,%eax
f0102260:	09 25 73 3a 25 64    	or     %esp,0x64253a73
f0102266:	3a 20                	cmp    (%eax),%ah
f0102268:	25 73 2b 25 64       	and    $0x64252b73,%eax
f010226d:	0a 00                	or     (%eax),%al
f010226f:	42                   	inc    %edx
f0102270:	61                   	popa   
f0102271:	63 6b 74             	arpl   %bp,0x74(%ebx)
f0102274:	72 61                	jb     f01022d7 <charcode+0xf7>
f0102276:	63 65 20             	arpl   %sp,0x20(%ebp)
f0102279:	73 75                	jae    f01022f0 <charcode+0x110>
f010227b:	63 63 65             	arpl   %sp,0x65(%ebx)
f010227e:	73 73                	jae    f01022f3 <charcode+0x113>
f0102280:	0a 00                	or     (%eax),%al
f0102282:	68 65 6c 70 00       	push   $0x706c65
f0102287:	44                   	inc    %esp
f0102288:	69 73 70 6c 61 79 20 	imul   $0x2079616c,0x70(%ebx),%esi
f010228f:	74 68                	je     f01022f9 <charcode+0x119>
f0102291:	69 73 20 6c 69 73 74 	imul   $0x7473696c,0x20(%ebx),%esi
f0102298:	20 6f 66             	and    %ch,0x66(%edi)
f010229b:	20 63 6f             	and    %ah,0x6f(%ebx)
f010229e:	6d                   	insl   (%dx),%es:(%edi)
f010229f:	6d                   	insl   (%dx),%es:(%edi)
f01022a0:	61                   	popa   
f01022a1:	6e                   	outsb  %ds:(%esi),(%dx)
f01022a2:	64                   	fs
f01022a3:	73 00                	jae    f01022a5 <charcode+0xc5>
f01022a5:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
f01022a9:	69 6e 66 6f 00 00 00 	imul   $0x6f,0x66(%esi),%ebp
f01022b0:	20 20                	and    %ah,(%eax)
f01022b2:	65 6e                	outsb  %gs:(%esi),(%dx)
f01022b4:	74 72                	je     f0102328 <charcode+0x148>
f01022b6:	79 20                	jns    f01022d8 <charcode+0xf8>
f01022b8:	20 25 30 38 78 20    	and    %ah,0x20783830
f01022be:	28 76 69             	sub    %dh,0x69(%esi)
f01022c1:	72 74                	jb     f0102337 <charcode+0x157>
f01022c3:	29 20                	sub    %esp,(%eax)
f01022c5:	20 25 30 38 78 20    	and    %ah,0x20783830
f01022cb:	28 70 68             	sub    %dh,0x68(%eax)
f01022ce:	79 73                	jns    f0102343 <charcode+0x163>
f01022d0:	29 0a                	sub    %ecx,(%edx)
f01022d2:	00 00                	add    %al,(%eax)
f01022d4:	20 20                	and    %ah,(%eax)
f01022d6:	65                   	gs
f01022d7:	74 65                	je     f010233e <charcode+0x15e>
f01022d9:	78 74                	js     f010234f <charcode+0x16f>
f01022db:	20 20                	and    %ah,(%eax)
f01022dd:	25 30 38 78 20       	and    $0x20783830,%eax
f01022e2:	28 76 69             	sub    %dh,0x69(%esi)
f01022e5:	72 74                	jb     f010235b <charcode+0x17b>
f01022e7:	29 20                	sub    %esp,(%eax)
f01022e9:	20 25 30 38 78 20    	and    %ah,0x20783830
f01022ef:	28 70 68             	sub    %dh,0x68(%eax)
f01022f2:	79 73                	jns    f0102367 <charcode+0x187>
f01022f4:	29 0a                	sub    %ecx,(%edx)
f01022f6:	00 00                	add    %al,(%eax)
f01022f8:	20 20                	and    %ah,(%eax)
f01022fa:	65                   	gs
f01022fb:	64                   	fs
f01022fc:	61                   	popa   
f01022fd:	74 61                	je     f0102360 <charcode+0x180>
f01022ff:	20 20                	and    %ah,(%eax)
f0102301:	25 30 38 78 20       	and    $0x20783830,%eax
f0102306:	28 76 69             	sub    %dh,0x69(%esi)
f0102309:	72 74                	jb     f010237f <charcode+0x19f>
f010230b:	29 20                	sub    %esp,(%eax)
f010230d:	20 25 30 38 78 20    	and    %ah,0x20783830
f0102313:	28 70 68             	sub    %dh,0x68(%eax)
f0102316:	79 73                	jns    f010238b <charcode+0x1ab>
f0102318:	29 0a                	sub    %ecx,(%edx)
f010231a:	00 00                	add    %al,(%eax)
f010231c:	20 20                	and    %ah,(%eax)
f010231e:	65 6e                	outsb  %gs:(%esi),(%dx)
f0102320:	64 20 20             	and    %ah,%fs:(%eax)
f0102323:	20 20                	and    %ah,(%eax)
f0102325:	25 30 38 78 20       	and    $0x20783830,%eax
f010232a:	28 76 69             	sub    %dh,0x69(%esi)
f010232d:	72 74                	jb     f01023a3 <charcode+0x1c3>
f010232f:	29 20                	sub    %esp,(%eax)
f0102331:	20 25 30 38 78 20    	and    %ah,0x20783830
f0102337:	28 70 68             	sub    %dh,0x68(%eax)
f010233a:	79 73                	jns    f01023af <charcode+0x1cf>
f010233c:	29 0a                	sub    %ecx,(%edx)
f010233e:	00 00                	add    %al,(%eax)
f0102340:	4b                   	dec    %ebx
f0102341:	65                   	gs
f0102342:	72 6e                	jb     f01023b2 <charcode+0x1d2>
f0102344:	65                   	gs
f0102345:	6c                   	insb   (%dx),%es:(%edi)
f0102346:	20 65 78             	and    %ah,0x78(%ebp)
f0102349:	65 63 75 74          	arpl   %si,%gs:0x74(%ebp)
f010234d:	61                   	popa   
f010234e:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
f0102352:	6d                   	insl   (%dx),%es:(%edi)
f0102353:	65                   	gs
f0102354:	6d                   	insl   (%dx),%es:(%edi)
f0102355:	6f                   	outsl  %ds:(%esi),(%dx)
f0102356:	72 79                	jb     f01023d1 <charcode+0x1f1>
f0102358:	20 66 6f             	and    %ah,0x6f(%esi)
f010235b:	6f                   	outsl  %ds:(%esi),(%dx)
f010235c:	74 70                	je     f01023ce <charcode+0x1ee>
f010235e:	72 69                	jb     f01023c9 <charcode+0x1e9>
f0102360:	6e                   	outsb  %ds:(%esi),(%dx)
f0102361:	74 3a                	je     f010239d <charcode+0x1bd>
f0102363:	20 25 64 4b 42 0a    	and    %ah,0xa424b64
f0102369:	00 00                	add    %al,(%eax)
f010236b:	00 57 65             	add    %dl,0x65(%edi)
f010236e:	6c                   	insb   (%dx),%es:(%edi)
f010236f:	63 6f 6d             	arpl   %bp,0x6d(%edi)
f0102372:	65 20 74 6f 20       	and    %dh,%gs:0x20(%edi,%ebp,2)
f0102377:	74 68                	je     f01023e1 <charcode+0x201>
f0102379:	65 20 4a 4f          	and    %cl,%gs:0x4f(%edx)
f010237d:	53                   	push   %ebx
f010237e:	20 6b 65             	and    %ch,0x65(%ebx)
f0102381:	72 6e                	jb     f01023f1 <charcode+0x211>
f0102383:	65                   	gs
f0102384:	6c                   	insb   (%dx),%es:(%edi)
f0102385:	20 6d 6f             	and    %ch,0x6f(%ebp)
f0102388:	6e                   	outsb  %ds:(%esi),(%dx)
f0102389:	69 74 6f 72 21 0a 00 	imul   $0x54000a21,0x72(%edi,%ebp,2),%esi
f0102390:	54 
f0102391:	79 70                	jns    f0102403 <charcode+0x223>
f0102393:	65 20 27             	and    %ah,%gs:(%edi)
f0102396:	68 65 6c 70 27       	push   $0x27706c65
f010239b:	20 66 6f             	and    %ah,0x6f(%esi)
f010239e:	72 20                	jb     f01023c0 <charcode+0x1e0>
f01023a0:	61                   	popa   
f01023a1:	20 6c 69 73          	and    %ch,0x73(%ecx,%ebp,2)
f01023a5:	74 20                	je     f01023c7 <charcode+0x1e7>
f01023a7:	6f                   	outsl  %ds:(%esi),(%dx)
f01023a8:	66                   	data16
f01023a9:	20 63 6f             	and    %ah,0x6f(%ebx)
f01023ac:	6d                   	insl   (%dx),%es:(%edi)
f01023ad:	6d                   	insl   (%dx),%es:(%edi)
f01023ae:	61                   	popa   
f01023af:	6e                   	outsb  %ds:(%esi),(%dx)
f01023b0:	64                   	fs
f01023b1:	73 2e                	jae    f01023e1 <charcode+0x201>
f01023b3:	0a 00                	or     (%eax),%al
f01023b5:	00 00                	add    %al,(%eax)
f01023b7:	00 65 69             	add    %ah,0x69(%ebp)
f01023ba:	70 20                	jo     f01023dc <charcode+0x1fc>
f01023bc:	25 30 38 78 20       	and    $0x20783830,%eax
f01023c1:	20 65 62             	and    %ah,0x62(%ebp)
f01023c4:	70 20                	jo     f01023e6 <charcode+0x206>
f01023c6:	25 70 20 20 61       	and    $0x61202070,%eax
f01023cb:	72 67                	jb     f0102434 <commands+0x20>
f01023cd:	73 20                	jae    f01023ef <charcode+0x20f>
f01023cf:	25 30 38 78 20       	and    $0x20783830,%eax
f01023d4:	25 30 38 78 20       	and    $0x20783830,%eax
f01023d9:	25 30 38 78 20       	and    $0x20783830,%eax
f01023de:	25 30 38 78 20       	and    $0x20783830,%eax
f01023e3:	25 30 38 78 0a       	and    $0xa783830,%eax
f01023e8:	00 00                	add    %al,(%eax)
f01023ea:	00 00                	add    %al,(%eax)
f01023ec:	44                   	inc    %esp
f01023ed:	69 73 70 6c 61 79 20 	imul   $0x2079616c,0x70(%ebx),%esi
f01023f4:	69 6e 66 6f 72 6d 61 	imul   $0x616d726f,0x66(%esi),%ebp
f01023fb:	74 69                	je     f0102466 <commands+0x52>
f01023fd:	6f                   	outsl  %ds:(%esi),(%dx)
f01023fe:	6e                   	outsb  %ds:(%esi),(%dx)
f01023ff:	20 61 62             	and    %ah,0x62(%ecx)
f0102402:	6f                   	outsl  %ds:(%esi),(%dx)
f0102403:	75 74                	jne    f0102479 <commands+0x65>
f0102405:	20 74 68 65          	and    %dh,0x65(%eax,%ebp,2)
f0102409:	20 6b 65             	and    %ch,0x65(%ebx)
f010240c:	72 6e                	jb     f010247c <commands+0x68>
f010240e:	65                   	gs
f010240f:	6c                   	insb   (%dx),%es:(%edi)
f0102410:	00 00                	add    %al,(%eax)
	...

f0102414 <commands>:
f0102414:	82                   	(bad)  
f0102415:	22 10                	and    (%eax),%dl
f0102417:	f0 87 22             	lock xchg %esp,(%edx)
f010241a:	10 f0                	adc    %dh,%al
f010241c:	d9 08                	(bad)  (%eax)
f010241e:	10 f0                	adc    %dh,%al
f0102420:	a5                   	movsl  %ds:(%esi),%es:(%edi)
f0102421:	22 10                	and    (%eax),%dl
f0102423:	f0 ec                	lock in (%dx),%al
f0102425:	23 10                	and    (%eax),%edx
f0102427:	f0 28 08             	lock sub %cl,(%eax)
f010242a:	10 f0                	adc    %dh,%al
f010242c:	3c 75                	cmp    $0x75,%al
f010242e:	6e                   	outsb  %ds:(%esi),(%dx)
f010242f:	6b 6e 6f 77          	imul   $0x77,0x6f(%esi),%ebp
f0102433:	6e                   	outsb  %ds:(%esi),(%dx)
f0102434:	3e 00 55 73          	add    %dl,%ds:0x73(%ebp)
f0102438:	65                   	gs
f0102439:	72 20                	jb     f010245b <commands+0x47>
f010243b:	61                   	popa   
f010243c:	64                   	fs
f010243d:	64                   	fs
f010243e:	72 65                	jb     f01024a5 <commands+0x91>
f0102440:	73 73                	jae    f01024b5 <commands+0xa1>
f0102442:	00 6b 65             	add    %ch,0x65(%ebx)
f0102445:	72 6e                	jb     f01024b5 <commands+0xa1>
f0102447:	2f                   	das    
f0102448:	6b 64 65 62 75       	imul   $0x75,0x62(%ebp,%eiz,2),%esp
f010244d:	67 2e 63 00          	addr16 arpl %ax,%cs:(%bx,%si)
f0102451:	30 31                	xor    %dh,(%ecx)
f0102453:	32 33                	xor    (%ebx),%dh
f0102455:	34 35                	xor    $0x35,%al
f0102457:	36                   	ss
f0102458:	37                   	aaa    
f0102459:	38 39                	cmp    %bh,(%ecx)
f010245b:	61                   	popa   
f010245c:	62 63 64             	bound  %esp,0x64(%ebx)
f010245f:	65                   	gs
f0102460:	66                   	data16
f0102461:	00 65 72             	add    %ah,0x72(%ebp)
f0102464:	72 6f                	jb     f01024d5 <commands+0xc1>
f0102466:	72 20                	jb     f0102488 <commands+0x74>
f0102468:	25 64 00 25 73       	and    $0x73250064,%eax
f010246d:	00 28                	add    %ch,(%eax)
f010246f:	6e                   	outsb  %ds:(%esi),(%dx)
f0102470:	75 6c                	jne    f01024de <commands+0xca>
f0102472:	6c                   	insb   (%dx),%es:(%edi)
f0102473:	29 00                	sub    %eax,(%eax)
f0102475:	75 6e                	jne    f01024e5 <commands+0xd1>
f0102477:	73 70                	jae    f01024e9 <commands+0xd5>
f0102479:	65 63 69 66          	arpl   %bp,%gs:0x66(%ecx)
f010247d:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%ebp),%esp
f0102484:	6f                   	outsl  %ds:(%esi),(%dx)
f0102485:	72 00                	jb     f0102487 <commands+0x73>
f0102487:	62 61 64             	bound  %esp,0x64(%ecx)
f010248a:	20 65 6e             	and    %ah,0x6e(%ebp)
f010248d:	76 69                	jbe    f01024f8 <commands+0xe4>
f010248f:	72 6f                	jb     f0102500 <commands+0xec>
f0102491:	6e                   	outsb  %ds:(%esi),(%dx)
f0102492:	6d                   	insl   (%dx),%es:(%edi)
f0102493:	65 6e                	outsb  %gs:(%esi),(%dx)
f0102495:	74 00                	je     f0102497 <commands+0x83>
f0102497:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%esi),%ebp
f010249e:	20 70 61             	and    %dh,0x61(%eax)
f01024a1:	72 61                	jb     f0102504 <commands+0xf0>
f01024a3:	6d                   	insl   (%dx),%es:(%edi)
f01024a4:	65                   	gs
f01024a5:	74 65                	je     f010250c <commands+0xf8>
f01024a7:	72 00                	jb     f01024a9 <commands+0x95>
f01024a9:	6f                   	outsl  %ds:(%esi),(%dx)
f01024aa:	75 74                	jne    f0102520 <commands+0x10c>
f01024ac:	20 6f 66             	and    %ch,0x66(%edi)
f01024af:	20 6d 65             	and    %ch,0x65(%ebp)
f01024b2:	6d                   	insl   (%dx),%es:(%edi)
f01024b3:	6f                   	outsl  %ds:(%esi),(%dx)
f01024b4:	72 79                	jb     f010252f <commands+0x11b>
f01024b6:	00 6f 75             	add    %ch,0x75(%edi)
f01024b9:	74 20                	je     f01024db <commands+0xc7>
f01024bb:	6f                   	outsl  %ds:(%esi),(%dx)
f01024bc:	66                   	data16
f01024bd:	20 65 6e             	and    %ah,0x6e(%ebp)
f01024c0:	76 69                	jbe    f010252b <commands+0x117>
f01024c2:	72 6f                	jb     f0102533 <commands+0x11f>
f01024c4:	6e                   	outsb  %ds:(%esi),(%dx)
f01024c5:	6d                   	insl   (%dx),%es:(%edi)
f01024c6:	65 6e                	outsb  %gs:(%esi),(%dx)
f01024c8:	74 73                	je     f010253d <commands+0x129>
f01024ca:	00 73 65             	add    %dh,0x65(%ebx)
f01024cd:	67 6d                	addr16 insl (%dx),%es:(%di)
f01024cf:	65 6e                	outsb  %gs:(%esi),(%dx)
f01024d1:	74 61                	je     f0102534 <commands+0x120>
f01024d3:	74 69                	je     f010253e <commands+0x12a>
f01024d5:	6f                   	outsl  %ds:(%esi),(%dx)
f01024d6:	6e                   	outsb  %ds:(%esi),(%dx)
f01024d7:	20 66 61             	and    %ah,0x61(%esi)
f01024da:	75 6c                	jne    f0102548 <commands+0x134>
f01024dc:	74 00                	je     f01024de <commands+0xca>
f01024de:	00 00                	add    %al,(%eax)
f01024e0:	0a 65 72             	or     0x72(%ebp),%ah
f01024e3:	72 6f                	jb     f0102554 <commands+0x140>
f01024e5:	72 21                	jb     f0102508 <commands+0xf4>
f01024e7:	20 77 72             	and    %dh,0x72(%edi)
f01024ea:	69 74 69 6e 67 20 74 	imul   $0x68742067,0x6e(%ecx,%ebp,2),%esi
f01024f1:	68 
f01024f2:	72 6f                	jb     f0102563 <commands+0x14f>
f01024f4:	75 67                	jne    f010255d <commands+0x149>
f01024f6:	68 20 4e 55 4c       	push   $0x4c554e20
f01024fb:	4c                   	dec    %esp
f01024fc:	20 70 6f             	and    %dh,0x6f(%eax)
f01024ff:	69 6e 74 65 72 21 20 	imul   $0x20217265,0x74(%esi),%ebp
f0102506:	28 25 6e 20 61 72    	sub    %ah,0x7261206e
f010250c:	67 75 6d             	addr16 jne f010257c <commands+0x168>
f010250f:	65 6e                	outsb  %gs:(%esi),(%dx)
f0102511:	74 29                	je     f010253c <commands+0x128>
f0102513:	0a 00                	or     (%eax),%al
f0102515:	00 00                	add    %al,(%eax)
f0102517:	00 0a                	add    %cl,(%edx)
f0102519:	77 61                	ja     f010257c <commands+0x168>
f010251b:	72 6e                	jb     f010258b <commands+0x177>
f010251d:	69 6e 67 21 20 54 68 	imul   $0x68542021,0x67(%esi),%ebp
f0102524:	65 20 76 61          	and    %dh,%gs:0x61(%esi)
f0102528:	6c                   	insb   (%dx),%es:(%edi)
f0102529:	75 65                	jne    f0102590 <commands+0x17c>
f010252b:	20 25 6e 20 61 72    	and    %ah,0x7261206e
f0102531:	67 75 6d             	addr16 jne f01025a1 <commands+0x18d>
f0102534:	65 6e                	outsb  %gs:(%esi),(%dx)
f0102536:	74 20                	je     f0102558 <commands+0x144>
f0102538:	70 6f                	jo     f01025a9 <commands+0x195>
f010253a:	69 6e 74 65 64 20 74 	imul   $0x74206465,0x74(%esi),%ebp
f0102541:	6f                   	outsl  %ds:(%esi),(%dx)
f0102542:	20 68 61             	and    %ch,0x61(%eax)
f0102545:	73 20                	jae    f0102567 <commands+0x153>
f0102547:	62 65 65             	bound  %esp,0x65(%ebp)
f010254a:	6e                   	outsb  %ds:(%esi),(%dx)
f010254b:	20 6f 76             	and    %ch,0x76(%edi)
f010254e:	65                   	gs
f010254f:	72 66                	jb     f01025b7 <commands+0x1a3>
f0102551:	6c                   	insb   (%dx),%es:(%edi)
f0102552:	6f                   	outsl  %ds:(%esi),(%dx)
f0102553:	77 65                	ja     f01025ba <commands+0x1a6>
f0102555:	64 21 0a             	and    %ecx,%fs:(%edx)
f0102558:	00 00                	add    %al,(%eax)
f010255a:	00 00                	add    %al,(%eax)
f010255c:	d5 12                	aad    $0x12
f010255e:	10 f0                	adc    %dh,%al
f0102560:	67 16                	addr16 push %ss
f0102562:	10 f0                	adc    %dh,%al
f0102564:	09 16                	or     %edx,(%esi)
f0102566:	10 f0                	adc    %dh,%al
f0102568:	67 16                	addr16 push %ss
f010256a:	10 f0                	adc    %dh,%al
f010256c:	67 16                	addr16 push %ss
f010256e:	10 f0                	adc    %dh,%al
f0102570:	67 16                	addr16 push %ss
f0102572:	10 f0                	adc    %dh,%al
f0102574:	67 16                	addr16 push %ss
f0102576:	10 f0                	adc    %dh,%al
f0102578:	bb 12 10 f0 1e       	mov    $0x1ef01012,%ebx
f010257d:	16                   	push   %ss
f010257e:	10 f0                	adc    %dh,%al
f0102580:	67 16                	addr16 push %ss
f0102582:	10 f0                	adc    %dh,%al
f0102584:	61                   	popa   
f0102585:	12 10                	adc    (%eax),%dl
f0102587:	f0 c8 12 10 f0       	lock enter $0x1012,$0xf0
f010258c:	67 16                	addr16 push %ss
f010258e:	10 f0                	adc    %dh,%al
f0102590:	85 12                	test   %edx,(%edx)
f0102592:	10 f0                	adc    %dh,%al
f0102594:	9b                   	fwait
f0102595:	12 10                	adc    (%eax),%dl
f0102597:	f0                   	lock
f0102598:	9b                   	fwait
f0102599:	12 10                	adc    (%eax),%dl
f010259b:	f0                   	lock
f010259c:	9b                   	fwait
f010259d:	12 10                	adc    (%eax),%dl
f010259f:	f0                   	lock
f01025a0:	9b                   	fwait
f01025a1:	12 10                	adc    (%eax),%dl
f01025a3:	f0                   	lock
f01025a4:	9b                   	fwait
f01025a5:	12 10                	adc    (%eax),%dl
f01025a7:	f0                   	lock
f01025a8:	9b                   	fwait
f01025a9:	12 10                	adc    (%eax),%dl
f01025ab:	f0                   	lock
f01025ac:	9b                   	fwait
f01025ad:	12 10                	adc    (%eax),%dl
f01025af:	f0                   	lock
f01025b0:	9b                   	fwait
f01025b1:	12 10                	adc    (%eax),%dl
f01025b3:	f0 8b 12             	lock mov (%edx),%edx
f01025b6:	10 f0                	adc    %dh,%al
f01025b8:	67 16                	addr16 push %ss
f01025ba:	10 f0                	adc    %dh,%al
f01025bc:	67 16                	addr16 push %ss
f01025be:	10 f0                	adc    %dh,%al
f01025c0:	67 16                	addr16 push %ss
f01025c2:	10 f0                	adc    %dh,%al
f01025c4:	67 16                	addr16 push %ss
f01025c6:	10 f0                	adc    %dh,%al
f01025c8:	67 16                	addr16 push %ss
f01025ca:	10 f0                	adc    %dh,%al
f01025cc:	67 16                	addr16 push %ss
f01025ce:	10 f0                	adc    %dh,%al
f01025d0:	67 16                	addr16 push %ss
f01025d2:	10 f0                	adc    %dh,%al
f01025d4:	67 16                	addr16 push %ss
f01025d6:	10 f0                	adc    %dh,%al
f01025d8:	67 16                	addr16 push %ss
f01025da:	10 f0                	adc    %dh,%al
f01025dc:	67 16                	addr16 push %ss
f01025de:	10 f0                	adc    %dh,%al
f01025e0:	67 16                	addr16 push %ss
f01025e2:	10 f0                	adc    %dh,%al
f01025e4:	67 16                	addr16 push %ss
f01025e6:	10 f0                	adc    %dh,%al
f01025e8:	67 16                	addr16 push %ss
f01025ea:	10 f0                	adc    %dh,%al
f01025ec:	67 16                	addr16 push %ss
f01025ee:	10 f0                	adc    %dh,%al
f01025f0:	67 16                	addr16 push %ss
f01025f2:	10 f0                	adc    %dh,%al
f01025f4:	67 16                	addr16 push %ss
f01025f6:	10 f0                	adc    %dh,%al
f01025f8:	67 16                	addr16 push %ss
f01025fa:	10 f0                	adc    %dh,%al
f01025fc:	67 16                	addr16 push %ss
f01025fe:	10 f0                	adc    %dh,%al
f0102600:	67 16                	addr16 push %ss
f0102602:	10 f0                	adc    %dh,%al
f0102604:	67 16                	addr16 push %ss
f0102606:	10 f0                	adc    %dh,%al
f0102608:	67 16                	addr16 push %ss
f010260a:	10 f0                	adc    %dh,%al
f010260c:	67 16                	addr16 push %ss
f010260e:	10 f0                	adc    %dh,%al
f0102610:	67 16                	addr16 push %ss
f0102612:	10 f0                	adc    %dh,%al
f0102614:	67 16                	addr16 push %ss
f0102616:	10 f0                	adc    %dh,%al
f0102618:	67 16                	addr16 push %ss
f010261a:	10 f0                	adc    %dh,%al
f010261c:	67 16                	addr16 push %ss
f010261e:	10 f0                	adc    %dh,%al
f0102620:	67 16                	addr16 push %ss
f0102622:	10 f0                	adc    %dh,%al
f0102624:	67 16                	addr16 push %ss
f0102626:	10 f0                	adc    %dh,%al
f0102628:	67 16                	addr16 push %ss
f010262a:	10 f0                	adc    %dh,%al
f010262c:	67 16                	addr16 push %ss
f010262e:	10 f0                	adc    %dh,%al
f0102630:	67 16                	addr16 push %ss
f0102632:	10 f0                	adc    %dh,%al
f0102634:	67 16                	addr16 push %ss
f0102636:	10 f0                	adc    %dh,%al
f0102638:	67 16                	addr16 push %ss
f010263a:	10 f0                	adc    %dh,%al
f010263c:	67 16                	addr16 push %ss
f010263e:	10 f0                	adc    %dh,%al
f0102640:	67 16                	addr16 push %ss
f0102642:	10 f0                	adc    %dh,%al
f0102644:	67 16                	addr16 push %ss
f0102646:	10 f0                	adc    %dh,%al
f0102648:	67 16                	addr16 push %ss
f010264a:	10 f0                	adc    %dh,%al
f010264c:	67 16                	addr16 push %ss
f010264e:	10 f0                	adc    %dh,%al
f0102650:	67 16                	addr16 push %ss
f0102652:	10 f0                	adc    %dh,%al
f0102654:	67 16                	addr16 push %ss
f0102656:	10 f0                	adc    %dh,%al
f0102658:	67 16                	addr16 push %ss
f010265a:	10 f0                	adc    %dh,%al
f010265c:	f8                   	clc    
f010265d:	12 10                	adc    (%eax),%dl
f010265f:	f0 98                	lock cwtl 
f0102661:	14 10                	adc    $0x10,%al
f0102663:	f0 18 13             	lock sbb %dl,(%ebx)
f0102666:	10 f0                	adc    %dh,%al
f0102668:	67 16                	addr16 push %ss
f010266a:	10 f0                	adc    %dh,%al
f010266c:	67 16                	addr16 push %ss
f010266e:	10 f0                	adc    %dh,%al
f0102670:	67 16                	addr16 push %ss
f0102672:	10 f0                	adc    %dh,%al
f0102674:	67 16                	addr16 push %ss
f0102676:	10 f0                	adc    %dh,%al
f0102678:	67 16                	addr16 push %ss
f010267a:	10 f0                	adc    %dh,%al
f010267c:	67 16                	addr16 push %ss
f010267e:	10 f0                	adc    %dh,%al
f0102680:	ef                   	out    %eax,(%dx)
f0102681:	12 10                	adc    (%eax),%dl
f0102683:	f0 67 16             	lock addr16 push %ss
f0102686:	10 f0                	adc    %dh,%al
f0102688:	9d                   	popf   
f0102689:	15 10 f0 fd 14       	adc    $0x14fdf010,%eax
f010268e:	10 f0                	adc    %dh,%al
f0102690:	24 15                	and    $0x15,%al
f0102692:	10 f0                	adc    %dh,%al
f0102694:	67 16                	addr16 push %ss
f0102696:	10 f0                	adc    %dh,%al
f0102698:	67 16                	addr16 push %ss
f010269a:	10 f0                	adc    %dh,%al
f010269c:	85 13                	test   %edx,(%ebx)
f010269e:	10 f0                	adc    %dh,%al
f01026a0:	67 16                	addr16 push %ss
f01026a2:	10 f0                	adc    %dh,%al
f01026a4:	e4 14                	in     $0x14,%al
f01026a6:	10 f0                	adc    %dh,%al
f01026a8:	67 16                	addr16 push %ss
f01026aa:	10 f0                	adc    %dh,%al
f01026ac:	67 16                	addr16 push %ss
f01026ae:	10 f0                	adc    %dh,%al
f01026b0:	5a                   	pop    %edx
f01026b1:	15 10 f0 00 00       	adc    $0xf010,%eax

f01026b4 <error_string>:
f01026b4:	00 00                	add    %al,(%eax)
f01026b6:	00 00                	add    %al,(%eax)
f01026b8:	75 24                	jne    f01026de <error_string+0x2a>
f01026ba:	10 f0                	adc    %dh,%al
f01026bc:	87 24 10             	xchg   %esp,(%eax,%edx,1)
f01026bf:	f0 97                	lock xchg %eax,%edi
f01026c1:	24 10                	and    $0x10,%al
f01026c3:	f0 a9 24 10 f0 b7    	lock test $0xb7f01024,%eax
f01026c9:	24 10                	and    $0x10,%al
f01026cb:	f0 cb                	lock lret 
f01026cd:	24 10                	and    $0x10,%al
f01026cf:	f0 72 65             	lock jb f0102737 <__STAB_BEGIN__+0x57>
f01026d2:	61                   	popa   
f01026d3:	64 20 65 72          	and    %ah,%fs:0x72(%ebp)
f01026d7:	72 6f                	jb     f0102748 <__STAB_BEGIN__+0x68>
f01026d9:	72 3a                	jb     f0102715 <__STAB_BEGIN__+0x35>
f01026db:	20                   	.byte 0x20
f01026dc:	25                   	.byte 0x25
f01026dd:	65 0a 00             	or     %gs:(%eax),%al

Disassembly of section .stab:

f01026e0 <__STAB_BEGIN__>:
f01026e0:	01 00                	add    %eax,(%eax)
f01026e2:	00 00                	add    %al,(%eax)
f01026e4:	00 00                	add    %al,(%eax)
f01026e6:	6b 05 e1 1b 00 00 01 	imul   $0x1,0x1be1,%eax
f01026ed:	00 00                	add    %al,(%eax)
f01026ef:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
f01026f3:	00 00                	add    %al,(%eax)
f01026f5:	00 10                	add    %dl,(%eax)
f01026f7:	f0 12 00             	lock adc (%eax),%al
f01026fa:	00 00                	add    %al,(%eax)
f01026fc:	84 00                	test   %al,(%eax)
f01026fe:	00 00                	add    %al,(%eax)
f0102700:	0c 00                	or     $0x0,%al
f0102702:	10 f0                	adc    %dh,%al
f0102704:	00 00                	add    %al,(%eax)
f0102706:	00 00                	add    %al,(%eax)
f0102708:	44                   	inc    %esp
f0102709:	00 2c 00             	add    %ch,(%eax,%eax,1)
f010270c:	0c 00                	or     $0x0,%al
f010270e:	10 f0                	adc    %dh,%al
f0102710:	00 00                	add    %al,(%eax)
f0102712:	00 00                	add    %al,(%eax)
f0102714:	44                   	inc    %esp
f0102715:	00 38                	add    %bh,(%eax)
f0102717:	00 15 00 10 f0 00    	add    %dl,0xf01000
f010271d:	00 00                	add    %al,(%eax)
f010271f:	00 44 00 39          	add    %al,0x39(%eax,%eax,1)
f0102723:	00 1a                	add    %bl,(%edx)
f0102725:	00 10                	add    %dl,(%eax)
f0102727:	f0 00 00             	lock add %al,(%eax)
f010272a:	00 00                	add    %al,(%eax)
f010272c:	44                   	inc    %esp
f010272d:	00 3b                	add    %bh,(%ebx)
f010272f:	00 1d 00 10 f0 00    	add    %bl,0xf01000
f0102735:	00 00                	add    %al,(%eax)
f0102737:	00 44 00 3c          	add    %al,0x3c(%eax,%eax,1)
f010273b:	00 20                	add    %ah,(%eax)
f010273d:	00 10                	add    %dl,(%eax)
f010273f:	f0 00 00             	lock add %al,(%eax)
f0102742:	00 00                	add    %al,(%eax)
f0102744:	44                   	inc    %esp
f0102745:	00 3d 00 25 00 10    	add    %bh,0x10002500
f010274b:	f0 00 00             	lock add %al,(%eax)
f010274e:	00 00                	add    %al,(%eax)
f0102750:	44                   	inc    %esp
f0102751:	00 42 00             	add    %al,0x0(%edx)
f0102754:	28 00                	sub    %al,(%eax)
f0102756:	10 f0                	adc    %dh,%al
f0102758:	00 00                	add    %al,(%eax)
f010275a:	00 00                	add    %al,(%eax)
f010275c:	44                   	inc    %esp
f010275d:	00 43 00             	add    %al,0x0(%ebx)
f0102760:	2d 00 10 f0 00       	sub    $0xf01000,%eax
f0102765:	00 00                	add    %al,(%eax)
f0102767:	00 44 00 49          	add    %al,0x49(%eax,%eax,1)
f010276b:	00 2f                	add    %ch,(%edi)
f010276d:	00 10                	add    %dl,(%eax)
f010276f:	f0 00 00             	lock add %al,(%eax)
f0102772:	00 00                	add    %al,(%eax)
f0102774:	44                   	inc    %esp
f0102775:	00 4c 00 34          	add    %cl,0x34(%eax,%eax,1)
f0102779:	00 10                	add    %dl,(%eax)
f010277b:	f0 00 00             	lock add %al,(%eax)
f010277e:	00 00                	add    %al,(%eax)
f0102780:	44                   	inc    %esp
f0102781:	00 4f 00             	add    %cl,0x0(%edi)
f0102784:	39 00                	cmp    %eax,(%eax)
f0102786:	10 f0                	adc    %dh,%al
f0102788:	00 00                	add    %al,(%eax)
f010278a:	00 00                	add    %al,(%eax)
f010278c:	44                   	inc    %esp
f010278d:	00 52 00             	add    %dl,0x0(%edx)
f0102790:	3e 00 10             	add    %dl,%ds:(%eax)
f0102793:	f0 1f                	lock pop %ds
f0102795:	00 00                	add    %al,(%eax)
f0102797:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
f010279b:	00 40 00             	add    %al,0x0(%eax)
f010279e:	10 f0                	adc    %dh,%al
f01027a0:	31 00                	xor    %eax,(%eax)
f01027a2:	00 00                	add    %al,(%eax)
f01027a4:	3c 00                	cmp    $0x0,%al
f01027a6:	00 00                	add    %al,(%eax)
f01027a8:	00 00                	add    %al,(%eax)
f01027aa:	00 00                	add    %al,(%eax)
f01027ac:	40                   	inc    %eax
f01027ad:	00 00                	add    %al,(%eax)
f01027af:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f01027b5:	00 00                	add    %al,(%eax)
f01027b7:	00 6a 00             	add    %ch,0x0(%edx)
f01027ba:	00 00                	add    %al,(%eax)
f01027bc:	80 00 00             	addb   $0x0,(%eax)
f01027bf:	00 00                	add    %al,(%eax)
f01027c1:	00 00                	add    %al,(%eax)
f01027c3:	00 84 00 00 00 80 00 	add    %al,0x800000(%eax,%eax,1)
f01027ca:	00 00                	add    %al,(%eax)
f01027cc:	00 00                	add    %al,(%eax)
f01027ce:	00 00                	add    %al,(%eax)
f01027d0:	b3 00                	mov    $0x0,%bl
f01027d2:	00 00                	add    %al,(%eax)
f01027d4:	80 00 00             	addb   $0x0,(%eax)
f01027d7:	00 00                	add    %al,(%eax)
f01027d9:	00 00                	add    %al,(%eax)
f01027db:	00 dc                	add    %bl,%ah
f01027dd:	00 00                	add    %al,(%eax)
f01027df:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f01027e5:	00 00                	add    %al,(%eax)
f01027e7:	00 0a                	add    %cl,(%edx)
f01027e9:	01 00                	add    %eax,(%eax)
f01027eb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f01027f1:	00 00                	add    %al,(%eax)
f01027f3:	00 35 01 00 00 80    	add    %dh,0x80000001
f01027f9:	00 00                	add    %al,(%eax)
f01027fb:	00 00                	add    %al,(%eax)
f01027fd:	00 00                	add    %al,(%eax)
f01027ff:	00 60 01             	add    %ah,0x1(%eax)
f0102802:	00 00                	add    %al,(%eax)
f0102804:	80 00 00             	addb   $0x0,(%eax)
f0102807:	00 00                	add    %al,(%eax)
f0102809:	00 00                	add    %al,(%eax)
f010280b:	00 86 01 00 00 80    	add    %al,-0x7fffffff(%esi)
f0102811:	00 00                	add    %al,(%eax)
f0102813:	00 00                	add    %al,(%eax)
f0102815:	00 00                	add    %al,(%eax)
f0102817:	00 b0 01 00 00 80    	add    %dh,-0x7fffffff(%eax)
f010281d:	00 00                	add    %al,(%eax)
f010281f:	00 00                	add    %al,(%eax)
f0102821:	00 00                	add    %al,(%eax)
f0102823:	00 d6                	add    %dl,%dh
f0102825:	01 00                	add    %eax,(%eax)
f0102827:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f010282d:	00 00                	add    %al,(%eax)
f010282f:	00 fb                	add    %bh,%bl
f0102831:	01 00                	add    %eax,(%eax)
f0102833:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102839:	00 00                	add    %al,(%eax)
f010283b:	00 15 02 00 00 80    	add    %dl,0x80000002
f0102841:	00 00                	add    %al,(%eax)
f0102843:	00 00                	add    %al,(%eax)
f0102845:	00 00                	add    %al,(%eax)
f0102847:	00 30                	add    %dh,(%eax)
f0102849:	02 00                	add    (%eax),%al
f010284b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102851:	00 00                	add    %al,(%eax)
f0102853:	00 51 02             	add    %dl,0x2(%ecx)
f0102856:	00 00                	add    %al,(%eax)
f0102858:	80 00 00             	addb   $0x0,(%eax)
f010285b:	00 00                	add    %al,(%eax)
f010285d:	00 00                	add    %al,(%eax)
f010285f:	00 70 02             	add    %dh,0x2(%eax)
f0102862:	00 00                	add    %al,(%eax)
f0102864:	80 00 00             	addb   $0x0,(%eax)
f0102867:	00 00                	add    %al,(%eax)
f0102869:	00 00                	add    %al,(%eax)
f010286b:	00 8f 02 00 00 80    	add    %cl,-0x7ffffffe(%edi)
f0102871:	00 00                	add    %al,(%eax)
f0102873:	00 00                	add    %al,(%eax)
f0102875:	00 00                	add    %al,(%eax)
f0102877:	00 b0 02 00 00 80    	add    %dh,-0x7ffffffe(%eax)
f010287d:	00 00                	add    %al,(%eax)
f010287f:	00 00                	add    %al,(%eax)
f0102881:	00 00                	add    %al,(%eax)
f0102883:	00 c4                	add    %al,%ah
f0102885:	02 00                	add    (%eax),%al
f0102887:	00 82 00 00 00 16    	add    %al,0x16000000(%edx)
f010288d:	59                   	pop    %ecx
f010288e:	01 00                	add    %eax,(%eax)
f0102890:	d0 02                	rolb   (%edx)
f0102892:	00 00                	add    %al,(%eax)
f0102894:	82                   	(bad)  
f0102895:	00 00                	add    %al,(%eax)
f0102897:	00 37                	add    %dh,(%edi)
f0102899:	53                   	push   %ebx
f010289a:	00 00                	add    %al,(%eax)
f010289c:	de 02                	fiadd  (%edx)
f010289e:	00 00                	add    %al,(%eax)
f01028a0:	80 00 00             	addb   $0x0,(%eax)
f01028a3:	00 00                	add    %al,(%eax)
f01028a5:	00 00                	add    %al,(%eax)
f01028a7:	00 f0                	add    %dh,%al
f01028a9:	02 00                	add    (%eax),%al
f01028ab:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f01028b1:	00 00                	add    %al,(%eax)
f01028b3:	00 05 03 00 00 80    	add    %al,0x80000003
f01028b9:	00 00                	add    %al,(%eax)
f01028bb:	00 00                	add    %al,(%eax)
f01028bd:	00 00                	add    %al,(%eax)
f01028bf:	00 1b                	add    %bl,(%ebx)
f01028c1:	03 00                	add    (%eax),%eax
f01028c3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f01028c9:	00 00                	add    %al,(%eax)
f01028cb:	00 30                	add    %dh,(%eax)
f01028cd:	03 00                	add    (%eax),%eax
f01028cf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f01028d5:	00 00                	add    %al,(%eax)
f01028d7:	00 46 03             	add    %al,0x3(%esi)
f01028da:	00 00                	add    %al,(%eax)
f01028dc:	80 00 00             	addb   $0x0,(%eax)
f01028df:	00 00                	add    %al,(%eax)
f01028e1:	00 00                	add    %al,(%eax)
f01028e3:	00 5b 03             	add    %bl,0x3(%ebx)
f01028e6:	00 00                	add    %al,(%eax)
f01028e8:	80 00 00             	addb   $0x0,(%eax)
f01028eb:	00 00                	add    %al,(%eax)
f01028ed:	00 00                	add    %al,(%eax)
f01028ef:	00 71 03             	add    %dh,0x3(%ecx)
f01028f2:	00 00                	add    %al,(%eax)
f01028f4:	80 00 00             	addb   $0x0,(%eax)
f01028f7:	00 00                	add    %al,(%eax)
f01028f9:	00 00                	add    %al,(%eax)
f01028fb:	00 86 03 00 00 80    	add    %al,-0x7ffffffd(%esi)
f0102901:	00 00                	add    %al,(%eax)
f0102903:	00 00                	add    %al,(%eax)
f0102905:	00 00                	add    %al,(%eax)
f0102907:	00 9c 03 00 00 80 00 	add    %bl,0x800000(%ebx,%eax,1)
f010290e:	00 00                	add    %al,(%eax)
f0102910:	00 00                	add    %al,(%eax)
f0102912:	00 00                	add    %al,(%eax)
f0102914:	b3 03                	mov    $0x3,%bl
f0102916:	00 00                	add    %al,(%eax)
f0102918:	80 00 00             	addb   $0x0,(%eax)
f010291b:	00 00                	add    %al,(%eax)
f010291d:	00 00                	add    %al,(%eax)
f010291f:	00 cb                	add    %cl,%bl
f0102921:	03 00                	add    (%eax),%eax
f0102923:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102929:	00 00                	add    %al,(%eax)
f010292b:	00 e4                	add    %ah,%ah
f010292d:	03 00                	add    (%eax),%eax
f010292f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102935:	00 00                	add    %al,(%eax)
f0102937:	00 f8                	add    %bh,%al
f0102939:	03 00                	add    (%eax),%eax
f010293b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102941:	00 00                	add    %al,(%eax)
f0102943:	00 0d 04 00 00 80    	add    %cl,0x80000004
f0102949:	00 00                	add    %al,(%eax)
f010294b:	00 00                	add    %al,(%eax)
f010294d:	00 00                	add    %al,(%eax)
f010294f:	00 23                	add    %ah,(%ebx)
f0102951:	04 00                	add    $0x0,%al
f0102953:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102959:	00 00                	add    %al,(%eax)
f010295b:	00 00                	add    %al,(%eax)
f010295d:	00 00                	add    %al,(%eax)
f010295f:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
f0102965:	00 00                	add    %al,(%eax)
f0102967:	00 37                	add    %dh,(%edi)
f0102969:	04 00                	add    $0x0,%al
f010296b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102971:	00 00                	add    %al,(%eax)
f0102973:	00 4f 05             	add    %cl,0x5(%edi)
f0102976:	00 00                	add    %al,(%eax)
f0102978:	80 00 00             	addb   $0x0,(%eax)
f010297b:	00 00                	add    %al,(%eax)
f010297d:	00 00                	add    %al,(%eax)
f010297f:	00 7e 08             	add    %bh,0x8(%esi)
f0102982:	00 00                	add    %al,(%eax)
f0102984:	80 00 00             	addb   $0x0,(%eax)
f0102987:	00 00                	add    %al,(%eax)
f0102989:	00 00                	add    %al,(%eax)
f010298b:	00 3f                	add    %bh,(%edi)
f010298d:	09 00                	or     %eax,(%eax)
f010298f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102995:	00 00                	add    %al,(%eax)
f0102997:	00 00                	add    %al,(%eax)
f0102999:	00 00                	add    %al,(%eax)
f010299b:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
f01029a1:	00 00                	add    %al,(%eax)
f01029a3:	00 7b 09             	add    %bh,0x9(%ebx)
f01029a6:	00 00                	add    %al,(%eax)
f01029a8:	82                   	(bad)  
f01029a9:	00 00                	add    %al,(%eax)
f01029ab:	00 40 3b             	add    %al,0x3b(%eax)
f01029ae:	00 00                	add    %al,(%eax)
f01029b0:	8d 09                	lea    (%ecx),%ecx
f01029b2:	00 00                	add    %al,(%eax)
f01029b4:	80 00 00             	addb   $0x0,(%eax)
f01029b7:	00 00                	add    %al,(%eax)
f01029b9:	00 00                	add    %al,(%eax)
f01029bb:	00 a0 09 00 00 80    	add    %ah,-0x7ffffff7(%eax)
f01029c1:	00 00                	add    %al,(%eax)
f01029c3:	00 00                	add    %al,(%eax)
f01029c5:	00 00                	add    %al,(%eax)
f01029c7:	00 b3 09 00 00 80    	add    %dh,-0x7ffffff7(%ebx)
f01029cd:	00 00                	add    %al,(%eax)
f01029cf:	00 00                	add    %al,(%eax)
f01029d1:	00 00                	add    %al,(%eax)
f01029d3:	00 eb                	add    %ch,%bl
f01029d5:	09 00                	or     %eax,(%eax)
f01029d7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f01029dd:	00 00                	add    %al,(%eax)
f01029df:	00 3c 0a             	add    %bh,(%edx,%ecx,1)
f01029e2:	00 00                	add    %al,(%eax)
f01029e4:	80 00 00             	addb   $0x0,(%eax)
	...
f01029ef:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
f01029f5:	00 00                	add    %al,(%eax)
f01029f7:	00 73 0a             	add    %dh,0xa(%ebx)
f01029fa:	00 00                	add    %al,(%eax)
f01029fc:	20 00                	and    %al,(%eax)
f01029fe:	00 00                	add    %al,(%eax)
f0102a00:	00 00                	add    %al,(%eax)
f0102a02:	00 00                	add    %al,(%eax)
f0102a04:	ad                   	lods   %ds:(%esi),%eax
f0102a05:	0a 00                	or     (%eax),%al
f0102a07:	00 20                	add    %ah,(%eax)
	...
f0102a11:	00 00                	add    %al,(%eax)
f0102a13:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
f0102a17:	00 40 00             	add    %al,0x0(%eax)
f0102a1a:	10 f0                	adc    %dh,%al
f0102a1c:	d7                   	xlat   %ds:(%ebx)
f0102a1d:	0a 00                	or     (%eax),%al
f0102a1f:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
f0102a23:	00 40 00             	add    %al,0x0(%eax)
f0102a26:	10 f0                	adc    %dh,%al
f0102a28:	31 00                	xor    %eax,(%eax)
f0102a2a:	00 00                	add    %al,(%eax)
f0102a2c:	3c 00                	cmp    $0x0,%al
f0102a2e:	00 00                	add    %al,(%eax)
f0102a30:	00 00                	add    %al,(%eax)
f0102a32:	00 00                	add    %al,(%eax)
f0102a34:	40                   	inc    %eax
f0102a35:	00 00                	add    %al,(%eax)
f0102a37:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102a3d:	00 00                	add    %al,(%eax)
f0102a3f:	00 6a 00             	add    %ch,0x0(%edx)
f0102a42:	00 00                	add    %al,(%eax)
f0102a44:	80 00 00             	addb   $0x0,(%eax)
f0102a47:	00 00                	add    %al,(%eax)
f0102a49:	00 00                	add    %al,(%eax)
f0102a4b:	00 84 00 00 00 80 00 	add    %al,0x800000(%eax,%eax,1)
f0102a52:	00 00                	add    %al,(%eax)
f0102a54:	00 00                	add    %al,(%eax)
f0102a56:	00 00                	add    %al,(%eax)
f0102a58:	b3 00                	mov    $0x0,%bl
f0102a5a:	00 00                	add    %al,(%eax)
f0102a5c:	80 00 00             	addb   $0x0,(%eax)
f0102a5f:	00 00                	add    %al,(%eax)
f0102a61:	00 00                	add    %al,(%eax)
f0102a63:	00 dc                	add    %bl,%ah
f0102a65:	00 00                	add    %al,(%eax)
f0102a67:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102a6d:	00 00                	add    %al,(%eax)
f0102a6f:	00 0a                	add    %cl,(%edx)
f0102a71:	01 00                	add    %eax,(%eax)
f0102a73:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102a79:	00 00                	add    %al,(%eax)
f0102a7b:	00 35 01 00 00 80    	add    %dh,0x80000001
f0102a81:	00 00                	add    %al,(%eax)
f0102a83:	00 00                	add    %al,(%eax)
f0102a85:	00 00                	add    %al,(%eax)
f0102a87:	00 60 01             	add    %ah,0x1(%eax)
f0102a8a:	00 00                	add    %al,(%eax)
f0102a8c:	80 00 00             	addb   $0x0,(%eax)
f0102a8f:	00 00                	add    %al,(%eax)
f0102a91:	00 00                	add    %al,(%eax)
f0102a93:	00 86 01 00 00 80    	add    %al,-0x7fffffff(%esi)
f0102a99:	00 00                	add    %al,(%eax)
f0102a9b:	00 00                	add    %al,(%eax)
f0102a9d:	00 00                	add    %al,(%eax)
f0102a9f:	00 b0 01 00 00 80    	add    %dh,-0x7fffffff(%eax)
f0102aa5:	00 00                	add    %al,(%eax)
f0102aa7:	00 00                	add    %al,(%eax)
f0102aa9:	00 00                	add    %al,(%eax)
f0102aab:	00 d6                	add    %dl,%dh
f0102aad:	01 00                	add    %eax,(%eax)
f0102aaf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102ab5:	00 00                	add    %al,(%eax)
f0102ab7:	00 fb                	add    %bh,%bl
f0102ab9:	01 00                	add    %eax,(%eax)
f0102abb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102ac1:	00 00                	add    %al,(%eax)
f0102ac3:	00 15 02 00 00 80    	add    %dl,0x80000002
f0102ac9:	00 00                	add    %al,(%eax)
f0102acb:	00 00                	add    %al,(%eax)
f0102acd:	00 00                	add    %al,(%eax)
f0102acf:	00 30                	add    %dh,(%eax)
f0102ad1:	02 00                	add    (%eax),%al
f0102ad3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102ad9:	00 00                	add    %al,(%eax)
f0102adb:	00 51 02             	add    %dl,0x2(%ecx)
f0102ade:	00 00                	add    %al,(%eax)
f0102ae0:	80 00 00             	addb   $0x0,(%eax)
f0102ae3:	00 00                	add    %al,(%eax)
f0102ae5:	00 00                	add    %al,(%eax)
f0102ae7:	00 70 02             	add    %dh,0x2(%eax)
f0102aea:	00 00                	add    %al,(%eax)
f0102aec:	80 00 00             	addb   $0x0,(%eax)
f0102aef:	00 00                	add    %al,(%eax)
f0102af1:	00 00                	add    %al,(%eax)
f0102af3:	00 8f 02 00 00 80    	add    %cl,-0x7ffffffe(%edi)
f0102af9:	00 00                	add    %al,(%eax)
f0102afb:	00 00                	add    %al,(%eax)
f0102afd:	00 00                	add    %al,(%eax)
f0102aff:	00 b0 02 00 00 80    	add    %dh,-0x7ffffffe(%eax)
f0102b05:	00 00                	add    %al,(%eax)
f0102b07:	00 00                	add    %al,(%eax)
f0102b09:	00 00                	add    %al,(%eax)
f0102b0b:	00 e3                	add    %ah,%bl
f0102b0d:	0a 00                	or     (%eax),%al
f0102b0f:	00 82 00 00 00 00    	add    %al,0x0(%edx)
f0102b15:	00 00                	add    %al,(%eax)
f0102b17:	00 f1                	add    %dh,%cl
f0102b19:	0a 00                	or     (%eax),%al
f0102b1b:	00 82 00 00 00 50    	add    %al,0x50000000(%edx)
f0102b21:	06                   	push   %es
f0102b22:	00 00                	add    %al,(%eax)
f0102b24:	00 0b                	add    %cl,(%ebx)
f0102b26:	00 00                	add    %al,(%eax)
f0102b28:	80 00 00             	addb   $0x0,(%eax)
	...
f0102b33:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
f0102b39:	00 00                	add    %al,(%eax)
f0102b3b:	00 00                	add    %al,(%eax)
f0102b3d:	00 00                	add    %al,(%eax)
f0102b3f:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
f0102b45:	00 00                	add    %al,(%eax)
f0102b47:	00 1c 0b             	add    %bl,(%ebx,%ecx,1)
f0102b4a:	00 00                	add    %al,(%eax)
f0102b4c:	82                   	(bad)  
f0102b4d:	00 00                	add    %al,(%eax)
f0102b4f:	00 00                	add    %al,(%eax)
f0102b51:	00 00                	add    %al,(%eax)
f0102b53:	00 d0                	add    %dl,%al
f0102b55:	02 00                	add    (%eax),%al
f0102b57:	00 c2                	add    %al,%dl
f0102b59:	00 00                	add    %al,(%eax)
f0102b5b:	00 37                	add    %dh,(%edi)
f0102b5d:	53                   	push   %ebx
f0102b5e:	00 00                	add    %al,(%eax)
f0102b60:	00 00                	add    %al,(%eax)
f0102b62:	00 00                	add    %al,(%eax)
f0102b64:	a2 00 00 00 00       	mov    %al,0x0
f0102b69:	00 00                	add    %al,(%eax)
f0102b6b:	00 2b                	add    %ch,(%ebx)
f0102b6d:	0b 00                	or     (%eax),%eax
f0102b6f:	00 24 00             	add    %ah,(%eax,%eax,1)
f0102b72:	00 00                	add    %al,(%eax)
f0102b74:	40                   	inc    %eax
f0102b75:	00 10                	add    %dl,(%eax)
f0102b77:	f0 39 0b             	lock cmp %ecx,(%ebx)
f0102b7a:	00 00                	add    %al,(%eax)
f0102b7c:	a0 00 00 00 08       	mov    0x8000000,%al
f0102b81:	00 00                	add    %al,(%eax)
f0102b83:	00 4d 0b             	add    %cl,0xb(%ebp)
f0102b86:	00 00                	add    %al,(%eax)
f0102b88:	a0 00 00 00 0c       	mov    0xc000000,%al
f0102b8d:	00 00                	add    %al,(%eax)
f0102b8f:	00 59 0b             	add    %bl,0xb(%ecx)
f0102b92:	00 00                	add    %al,(%eax)
f0102b94:	a0 00 00 00 10       	mov    0x10000000,%al
f0102b99:	00 00                	add    %al,(%eax)
f0102b9b:	00 00                	add    %al,(%eax)
f0102b9d:	00 00                	add    %al,(%eax)
f0102b9f:	00 44 00 5e          	add    %al,0x5e(%eax,%eax,1)
	...
f0102bab:	00 44 00 5d          	add    %al,0x5d(%eax,%eax,1)
f0102baf:	00 07                	add    %al,(%edi)
f0102bb1:	00 00                	add    %al,(%eax)
f0102bb3:	00 00                	add    %al,(%eax)
f0102bb5:	00 00                	add    %al,(%eax)
f0102bb7:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
f0102bbb:	00 0a                	add    %cl,(%edx)
f0102bbd:	00 00                	add    %al,(%eax)
f0102bbf:	00 00                	add    %al,(%eax)
f0102bc1:	00 00                	add    %al,(%eax)
f0102bc3:	00 44 00 63          	add    %al,0x63(%eax,%eax,1)
f0102bc7:	00 24 00             	add    %ah,(%eax,%eax,1)
f0102bca:	00 00                	add    %al,(%eax)
f0102bcc:	00 00                	add    %al,(%eax)
f0102bce:	00 00                	add    %al,(%eax)
f0102bd0:	44                   	inc    %esp
f0102bd1:	00 64 00 33          	add    %ah,0x33(%eax,%eax,1)
f0102bd5:	00 00                	add    %al,(%eax)
f0102bd7:	00 00                	add    %al,(%eax)
f0102bd9:	00 00                	add    %al,(%eax)
f0102bdb:	00 44 00 66          	add    %al,0x66(%eax,%eax,1)
f0102bdf:	00 3f                	add    %bh,(%edi)
f0102be1:	00 00                	add    %al,(%eax)
f0102be3:	00 65 0b             	add    %ah,0xb(%ebp)
f0102be6:	00 00                	add    %al,(%eax)
f0102be8:	40                   	inc    %eax
f0102be9:	00 00                	add    %al,(%eax)
f0102beb:	00 00                	add    %al,(%eax)
f0102bed:	00 00                	add    %al,(%eax)
f0102bef:	00 72 0b             	add    %dh,0xb(%edx)
f0102bf2:	00 00                	add    %al,(%eax)
f0102bf4:	40                   	inc    %eax
f0102bf5:	00 00                	add    %al,(%eax)
f0102bf7:	00 00                	add    %al,(%eax)
f0102bf9:	00 00                	add    %al,(%eax)
f0102bfb:	00 7e 0b             	add    %bh,0xb(%esi)
f0102bfe:	00 00                	add    %al,(%eax)
f0102c00:	40                   	inc    %eax
f0102c01:	00 00                	add    %al,(%eax)
f0102c03:	00 00                	add    %al,(%eax)
f0102c05:	00 00                	add    %al,(%eax)
f0102c07:	00 8a 0b 00 00 24    	add    %cl,0x2400000b(%edx)
f0102c0d:	00 00                	add    %al,(%eax)
f0102c0f:	00 85 00 10 f0 99    	add    %al,-0x660ff000(%ebp)
f0102c15:	0b 00                	or     (%eax),%eax
f0102c17:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
f0102c1d:	00 00                	add    %al,(%eax)
f0102c1f:	00 4d 0b             	add    %cl,0xb(%ebp)
f0102c22:	00 00                	add    %al,(%eax)
f0102c24:	a0 00 00 00 0c       	mov    0xc000000,%al
f0102c29:	00 00                	add    %al,(%eax)
f0102c2b:	00 59 0b             	add    %bl,0xb(%ecx)
f0102c2e:	00 00                	add    %al,(%eax)
f0102c30:	a0 00 00 00 10       	mov    0x10000000,%al
f0102c35:	00 00                	add    %al,(%eax)
f0102c37:	00 00                	add    %al,(%eax)
f0102c39:	00 00                	add    %al,(%eax)
f0102c3b:	00 44 00 45          	add    %al,0x45(%eax,%eax,1)
	...
f0102c47:	00 44 00 48          	add    %al,0x48(%eax,%eax,1)
f0102c4b:	00 0b                	add    %cl,(%ebx)
f0102c4d:	00 00                	add    %al,(%eax)
f0102c4f:	00 00                	add    %al,(%eax)
f0102c51:	00 00                	add    %al,(%eax)
f0102c53:	00 44 00 4a          	add    %al,0x4a(%eax,%eax,1)
f0102c57:	00 14 00             	add    %dl,(%eax,%eax,1)
f0102c5a:	00 00                	add    %al,(%eax)
f0102c5c:	00 00                	add    %al,(%eax)
f0102c5e:	00 00                	add    %al,(%eax)
f0102c60:	44                   	inc    %esp
f0102c61:	00 4d 00             	add    %cl,0x0(%ebp)
f0102c64:	1a 00                	sbb    (%eax),%al
f0102c66:	00 00                	add    %al,(%eax)
f0102c68:	00 00                	add    %al,(%eax)
f0102c6a:	00 00                	add    %al,(%eax)
f0102c6c:	44                   	inc    %esp
f0102c6d:	00 44 00 1c          	add    %al,0x1c(%eax,%eax,1)
f0102c71:	00 00                	add    %al,(%eax)
f0102c73:	00 00                	add    %al,(%eax)
f0102c75:	00 00                	add    %al,(%eax)
f0102c77:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
f0102c7b:	00 1f                	add    %bl,(%edi)
f0102c7d:	00 00                	add    %al,(%eax)
f0102c7f:	00 00                	add    %al,(%eax)
f0102c81:	00 00                	add    %al,(%eax)
f0102c83:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
f0102c87:	00 39                	add    %bh,(%ecx)
f0102c89:	00 00                	add    %al,(%eax)
f0102c8b:	00 00                	add    %al,(%eax)
f0102c8d:	00 00                	add    %al,(%eax)
f0102c8f:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
f0102c93:	00 45 00             	add    %al,0x0(%ebp)
f0102c96:	00 00                	add    %al,(%eax)
f0102c98:	00 00                	add    %al,(%eax)
f0102c9a:	00 00                	add    %al,(%eax)
f0102c9c:	44                   	inc    %esp
f0102c9d:	00 58 00             	add    %bl,0x0(%eax)
f0102ca0:	51                   	push   %ecx
f0102ca1:	00 00                	add    %al,(%eax)
f0102ca3:	00 65 0b             	add    %ah,0xb(%ebp)
f0102ca6:	00 00                	add    %al,(%eax)
f0102ca8:	40                   	inc    %eax
f0102ca9:	00 00                	add    %al,(%eax)
f0102cab:	00 00                	add    %al,(%eax)
f0102cad:	00 00                	add    %al,(%eax)
f0102caf:	00 72 0b             	add    %dh,0xb(%edx)
f0102cb2:	00 00                	add    %al,(%eax)
f0102cb4:	40                   	inc    %eax
f0102cb5:	00 00                	add    %al,(%eax)
f0102cb7:	00 00                	add    %al,(%eax)
f0102cb9:	00 00                	add    %al,(%eax)
f0102cbb:	00 7e 0b             	add    %bh,0xb(%esi)
f0102cbe:	00 00                	add    %al,(%eax)
f0102cc0:	40                   	inc    %eax
f0102cc1:	00 00                	add    %al,(%eax)
f0102cc3:	00 06                	add    %al,(%esi)
f0102cc5:	00 00                	add    %al,(%eax)
f0102cc7:	00 a6 0b 00 00 24    	add    %ah,0x2400000b(%esi)
f0102ccd:	00 00                	add    %al,(%eax)
f0102ccf:	00 e4                	add    %ah,%ah
f0102cd1:	00 10                	add    %dl,(%eax)
f0102cd3:	f0 bd 0b 00 00 a0    	lock mov $0xa000000b,%ebp
f0102cd9:	00 00                	add    %al,(%eax)
f0102cdb:	00 08                	add    %cl,(%eax)
f0102cdd:	00 00                	add    %al,(%eax)
f0102cdf:	00 00                	add    %al,(%eax)
f0102ce1:	00 00                	add    %al,(%eax)
f0102ce3:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
	...
f0102cef:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
f0102cf3:	00 0a                	add    %cl,(%edx)
f0102cf5:	00 00                	add    %al,(%eax)
f0102cf7:	00 00                	add    %al,(%eax)
f0102cf9:	00 00                	add    %al,(%eax)
f0102cfb:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
f0102cff:	00 1a                	add    %bl,(%edx)
f0102d01:	00 00                	add    %al,(%eax)
f0102d03:	00 00                	add    %al,(%eax)
f0102d05:	00 00                	add    %al,(%eax)
f0102d07:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
f0102d0b:	00 1e                	add    %bl,(%esi)
f0102d0d:	00 00                	add    %al,(%eax)
f0102d0f:	00 00                	add    %al,(%eax)
f0102d11:	00 00                	add    %al,(%eax)
f0102d13:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
f0102d17:	00 2b                	add    %ch,(%ebx)
f0102d19:	00 00                	add    %al,(%eax)
f0102d1b:	00 00                	add    %al,(%eax)
f0102d1d:	00 00                	add    %al,(%eax)
f0102d1f:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
f0102d23:	00 47 00             	add    %al,0x0(%edi)
f0102d26:	00 00                	add    %al,(%eax)
f0102d28:	00 00                	add    %al,(%eax)
f0102d2a:	00 00                	add    %al,(%eax)
f0102d2c:	44                   	inc    %esp
f0102d2d:	00 14 00             	add    %dl,(%eax,%eax,1)
f0102d30:	57                   	push   %edi
f0102d31:	00 00                	add    %al,(%eax)
f0102d33:	00 c6                	add    %al,%dh
f0102d35:	0b 00                	or     (%eax),%eax
f0102d37:	00 40 00             	add    %al,0x0(%eax)
f0102d3a:	00 00                	add    %al,(%eax)
f0102d3c:	03 00                	add    (%eax),%eax
f0102d3e:	00 00                	add    %al,(%eax)
f0102d40:	cf                   	iret   
f0102d41:	0b 00                	or     (%eax),%eax
f0102d43:	00 24 00             	add    %ah,(%eax,%eax,1)
f0102d46:	00 00                	add    %al,(%eax)
f0102d48:	41                   	inc    %ecx
f0102d49:	01 10                	add    %edx,(%eax)
f0102d4b:	f0 00 00             	lock add %al,(%eax)
f0102d4e:	00 00                	add    %al,(%eax)
f0102d50:	44                   	inc    %esp
f0102d51:	00 18                	add    %bl,(%eax)
	...
f0102d5b:	00 44 00 1c          	add    %al,0x1c(%eax,%eax,1)
f0102d5f:	00 0b                	add    %cl,(%ebx)
f0102d61:	00 00                	add    %al,(%eax)
f0102d63:	00 00                	add    %al,(%eax)
f0102d65:	00 00                	add    %al,(%eax)
f0102d67:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
f0102d6b:	00 3e                	add    %bh,(%esi)
f0102d6d:	00 00                	add    %al,(%eax)
f0102d6f:	00 00                	add    %al,(%eax)
f0102d71:	00 00                	add    %al,(%eax)
f0102d73:	00 44 00 24          	add    %al,0x24(%eax,%eax,1)
f0102d77:	00 60 00             	add    %ah,0x0(%eax)
f0102d7a:	00 00                	add    %al,(%eax)
f0102d7c:	00 00                	add    %al,(%eax)
f0102d7e:	00 00                	add    %al,(%eax)
f0102d80:	44                   	inc    %esp
f0102d81:	00 26                	add    %ah,(%esi)
f0102d83:	00 65 00             	add    %ah,0x0(%ebp)
f0102d86:	00 00                	add    %al,(%eax)
f0102d88:	00 00                	add    %al,(%eax)
f0102d8a:	00 00                	add    %al,(%eax)
f0102d8c:	44                   	inc    %esp
f0102d8d:	00 27                	add    %ah,(%edi)
f0102d8f:	00 87 00 00 00 00    	add    %al,0x0(%edi)
f0102d95:	00 00                	add    %al,(%eax)
f0102d97:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
f0102d9b:	00 9b 00 00 00 00    	add    %bl,0x0(%ebx)
f0102da1:	00 00                	add    %al,(%eax)
f0102da3:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
f0102da7:	00 b7 00 00 00 00    	add    %dh,0x0(%edi)
f0102dad:	00 00                	add    %al,(%eax)
f0102daf:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
f0102db3:	00 cb                	add    %cl,%bl
f0102db5:	00 00                	add    %al,(%eax)
f0102db7:	00 00                	add    %al,(%eax)
f0102db9:	00 00                	add    %al,(%eax)
f0102dbb:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
f0102dbf:	00 e9                	add    %ch,%cl
f0102dc1:	00 00                	add    %al,(%eax)
f0102dc3:	00 00                	add    %al,(%eax)
f0102dc5:	00 00                	add    %al,(%eax)
f0102dc7:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
f0102dcb:	00 fd                	add    %bh,%ch
f0102dcd:	00 00                	add    %al,(%eax)
f0102dcf:	00 00                	add    %al,(%eax)
f0102dd1:	00 00                	add    %al,(%eax)
f0102dd3:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
f0102dd7:	00 11                	add    %dl,(%ecx)
f0102dd9:	01 00                	add    %eax,(%eax)
f0102ddb:	00 00                	add    %al,(%eax)
f0102ddd:	00 00                	add    %al,(%eax)
f0102ddf:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
f0102de3:	00 2d 01 00 00 00    	add    %ch,0x1
f0102de9:	00 00                	add    %al,(%eax)
f0102deb:	00 44 00 35          	add    %al,0x35(%eax,%eax,1)
f0102def:	00 39                	add    %bh,(%ecx)
f0102df1:	01 00                	add    %eax,(%eax)
f0102df3:	00 e1                	add    %ah,%cl
f0102df5:	0b 00                	or     (%eax),%eax
f0102df7:	00 80 00 00 00 f7    	add    %al,-0x9000000(%eax)
f0102dfd:	ff                   	(bad)  
f0102dfe:	ff                   	(bad)  
f0102dff:	ff ee                	ljmp   *<internal disassembler error>
f0102e01:	0b 00                	or     (%eax),%eax
f0102e03:	00 80 00 00 00 f6    	add    %al,-0xa000000(%eax)
f0102e09:	ff                   	(bad)  
f0102e0a:	ff                   	(bad)  
f0102e0b:	ff                   	(bad)  
f0102e0c:	fb                   	sti    
f0102e0d:	0b 00                	or     (%eax),%eax
f0102e0f:	00 80 00 00 00 f6    	add    %al,-0xa000000(%eax)
f0102e15:	fe                   	(bad)  
f0102e16:	ff                   	(bad)  
f0102e17:	ff 00                	incl   (%eax)
f0102e19:	00 00                	add    %al,(%eax)
f0102e1b:	00 c0                	add    %al,%al
	...
f0102e25:	00 00                	add    %al,(%eax)
f0102e27:	00 e0                	add    %ah,%al
f0102e29:	00 00                	add    %al,(%eax)
f0102e2b:	00 47 01             	add    %al,0x1(%edi)
f0102e2e:	00 00                	add    %al,(%eax)
f0102e30:	2b 0c 00             	sub    (%eax,%eax,1),%ecx
f0102e33:	00 28                	add    %ch,(%eax)
f0102e35:	00 00                	add    %al,(%eax)
f0102e37:	00 00                	add    %al,(%eax)
f0102e39:	33 11                	xor    (%ecx),%edx
f0102e3b:	f0 00 00             	lock add %al,(%eax)
f0102e3e:	00 00                	add    %al,(%eax)
f0102e40:	64 00 00             	add    %al,%fs:(%eax)
f0102e43:	00 88 02 10 f0 3c    	add    %cl,0x3cf01002(%eax)
f0102e49:	0c 00                	or     $0x0,%al
f0102e4b:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
f0102e4f:	00 90 02 10 f0 31    	add    %dl,0x31f01002(%eax)
f0102e55:	00 00                	add    %al,(%eax)
f0102e57:	00 3c 00             	add    %bh,(%eax,%eax,1)
f0102e5a:	00 00                	add    %al,(%eax)
f0102e5c:	00 00                	add    %al,(%eax)
f0102e5e:	00 00                	add    %al,(%eax)
f0102e60:	40                   	inc    %eax
f0102e61:	00 00                	add    %al,(%eax)
f0102e63:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102e69:	00 00                	add    %al,(%eax)
f0102e6b:	00 6a 00             	add    %ch,0x0(%edx)
f0102e6e:	00 00                	add    %al,(%eax)
f0102e70:	80 00 00             	addb   $0x0,(%eax)
f0102e73:	00 00                	add    %al,(%eax)
f0102e75:	00 00                	add    %al,(%eax)
f0102e77:	00 84 00 00 00 80 00 	add    %al,0x800000(%eax,%eax,1)
f0102e7e:	00 00                	add    %al,(%eax)
f0102e80:	00 00                	add    %al,(%eax)
f0102e82:	00 00                	add    %al,(%eax)
f0102e84:	b3 00                	mov    $0x0,%bl
f0102e86:	00 00                	add    %al,(%eax)
f0102e88:	80 00 00             	addb   $0x0,(%eax)
f0102e8b:	00 00                	add    %al,(%eax)
f0102e8d:	00 00                	add    %al,(%eax)
f0102e8f:	00 dc                	add    %bl,%ah
f0102e91:	00 00                	add    %al,(%eax)
f0102e93:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102e99:	00 00                	add    %al,(%eax)
f0102e9b:	00 0a                	add    %cl,(%edx)
f0102e9d:	01 00                	add    %eax,(%eax)
f0102e9f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102ea5:	00 00                	add    %al,(%eax)
f0102ea7:	00 35 01 00 00 80    	add    %dh,0x80000001
f0102ead:	00 00                	add    %al,(%eax)
f0102eaf:	00 00                	add    %al,(%eax)
f0102eb1:	00 00                	add    %al,(%eax)
f0102eb3:	00 60 01             	add    %ah,0x1(%eax)
f0102eb6:	00 00                	add    %al,(%eax)
f0102eb8:	80 00 00             	addb   $0x0,(%eax)
f0102ebb:	00 00                	add    %al,(%eax)
f0102ebd:	00 00                	add    %al,(%eax)
f0102ebf:	00 86 01 00 00 80    	add    %al,-0x7fffffff(%esi)
f0102ec5:	00 00                	add    %al,(%eax)
f0102ec7:	00 00                	add    %al,(%eax)
f0102ec9:	00 00                	add    %al,(%eax)
f0102ecb:	00 b0 01 00 00 80    	add    %dh,-0x7fffffff(%eax)
f0102ed1:	00 00                	add    %al,(%eax)
f0102ed3:	00 00                	add    %al,(%eax)
f0102ed5:	00 00                	add    %al,(%eax)
f0102ed7:	00 d6                	add    %dl,%dh
f0102ed9:	01 00                	add    %eax,(%eax)
f0102edb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102ee1:	00 00                	add    %al,(%eax)
f0102ee3:	00 fb                	add    %bh,%bl
f0102ee5:	01 00                	add    %eax,(%eax)
f0102ee7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102eed:	00 00                	add    %al,(%eax)
f0102eef:	00 15 02 00 00 80    	add    %dl,0x80000002
f0102ef5:	00 00                	add    %al,(%eax)
f0102ef7:	00 00                	add    %al,(%eax)
f0102ef9:	00 00                	add    %al,(%eax)
f0102efb:	00 30                	add    %dh,(%eax)
f0102efd:	02 00                	add    (%eax),%al
f0102eff:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0102f05:	00 00                	add    %al,(%eax)
f0102f07:	00 51 02             	add    %dl,0x2(%ecx)
f0102f0a:	00 00                	add    %al,(%eax)
f0102f0c:	80 00 00             	addb   $0x0,(%eax)
f0102f0f:	00 00                	add    %al,(%eax)
f0102f11:	00 00                	add    %al,(%eax)
f0102f13:	00 70 02             	add    %dh,0x2(%eax)
f0102f16:	00 00                	add    %al,(%eax)
f0102f18:	80 00 00             	addb   $0x0,(%eax)
f0102f1b:	00 00                	add    %al,(%eax)
f0102f1d:	00 00                	add    %al,(%eax)
f0102f1f:	00 8f 02 00 00 80    	add    %cl,-0x7ffffffe(%edi)
f0102f25:	00 00                	add    %al,(%eax)
f0102f27:	00 00                	add    %al,(%eax)
f0102f29:	00 00                	add    %al,(%eax)
f0102f2b:	00 b0 02 00 00 80    	add    %dh,-0x7ffffffe(%eax)
f0102f31:	00 00                	add    %al,(%eax)
f0102f33:	00 00                	add    %al,(%eax)
f0102f35:	00 00                	add    %al,(%eax)
f0102f37:	00 4b 0c             	add    %cl,0xc(%ebx)
f0102f3a:	00 00                	add    %al,(%eax)
f0102f3c:	82                   	(bad)  
f0102f3d:	00 00                	add    %al,(%eax)
f0102f3f:	00 00                	add    %al,(%eax)
f0102f41:	00 00                	add    %al,(%eax)
f0102f43:	00 d0                	add    %dl,%al
f0102f45:	02 00                	add    (%eax),%al
f0102f47:	00 c2                	add    %al,%dl
f0102f49:	00 00                	add    %al,(%eax)
f0102f4b:	00 37                	add    %dh,(%edi)
f0102f4d:	53                   	push   %ebx
f0102f4e:	00 00                	add    %al,(%eax)
f0102f50:	00 00                	add    %al,(%eax)
f0102f52:	00 00                	add    %al,(%eax)
f0102f54:	a2 00 00 00 00       	mov    %al,0x0
f0102f59:	00 00                	add    %al,(%eax)
f0102f5b:	00 7b 09             	add    %bh,0x9(%ebx)
f0102f5e:	00 00                	add    %al,(%eax)
f0102f60:	c2 00 00             	ret    $0x0
f0102f63:	00 40 3b             	add    %al,0x3b(%eax)
f0102f66:	00 00                	add    %al,(%eax)
f0102f68:	c4 02                	les    (%edx),%eax
f0102f6a:	00 00                	add    %al,(%eax)
f0102f6c:	c2 00 00             	ret    $0x0
f0102f6f:	00 16                	add    %dl,(%esi)
f0102f71:	59                   	pop    %ecx
f0102f72:	01 00                	add    %eax,(%eax)
f0102f74:	57                   	push   %edi
f0102f75:	0c 00                	or     $0x0,%al
f0102f77:	00 82 00 00 00 00    	add    %al,0x0(%edx)
f0102f7d:	00 00                	add    %al,(%eax)
f0102f7f:	00 e3                	add    %ah,%bl
f0102f81:	0a 00                	or     (%eax),%al
f0102f83:	00 c2                	add    %al,%dl
f0102f85:	00 00                	add    %al,(%eax)
f0102f87:	00 00                	add    %al,(%eax)
f0102f89:	00 00                	add    %al,(%eax)
f0102f8b:	00 f1                	add    %dh,%cl
f0102f8d:	0a 00                	or     (%eax),%al
f0102f8f:	00 c2                	add    %al,%dl
f0102f91:	00 00                	add    %al,(%eax)
f0102f93:	00 50 06             	add    %dl,0x6(%eax)
f0102f96:	00 00                	add    %al,(%eax)
f0102f98:	00 00                	add    %al,(%eax)
f0102f9a:	00 00                	add    %al,(%eax)
f0102f9c:	a2 00 00 00 00       	mov    %al,0x0
f0102fa1:	00 00                	add    %al,(%eax)
f0102fa3:	00 66 0c             	add    %ah,0xc(%esi)
f0102fa6:	00 00                	add    %al,(%eax)
f0102fa8:	24 00                	and    $0x0,%al
f0102faa:	00 00                	add    %al,(%eax)
f0102fac:	90                   	nop
f0102fad:	02 10                	add    (%eax),%dl
f0102faf:	f0 00 00             	lock add %al,(%eax)
f0102fb2:	00 00                	add    %al,(%eax)
f0102fb4:	44                   	inc    %esp
f0102fb5:	00 11                	add    %dl,(%ecx)
f0102fb7:	00 00                	add    %al,(%eax)
f0102fb9:	00 00                	add    %al,(%eax)
f0102fbb:	00 4b 0c             	add    %cl,0xc(%ebx)
f0102fbe:	00 00                	add    %al,(%eax)
f0102fc0:	84 00                	test   %al,(%eax)
f0102fc2:	00 00                	add    %al,(%eax)
f0102fc4:	93                   	xchg   %eax,%ebx
f0102fc5:	02 10                	add    (%eax),%dl
f0102fc7:	f0 00 00             	lock add %al,(%eax)
f0102fca:	00 00                	add    %al,(%eax)
f0102fcc:	44                   	inc    %esp
f0102fcd:	00 30                	add    %dh,(%eax)
f0102fcf:	00 03                	add    %al,(%ebx)
f0102fd1:	00 00                	add    %al,(%eax)
f0102fd3:	00 3c 0c             	add    %bh,(%esp,%ecx,1)
f0102fd6:	00 00                	add    %al,(%eax)
f0102fd8:	84 00                	test   %al,(%eax)
f0102fda:	00 00                	add    %al,(%eax)
f0102fdc:	9c                   	pushf  
f0102fdd:	02 10                	add    (%eax),%dl
f0102fdf:	f0 00 00             	lock add %al,(%eax)
f0102fe2:	00 00                	add    %al,(%eax)
f0102fe4:	44                   	inc    %esp
f0102fe5:	00 16                	add    %dl,(%esi)
f0102fe7:	00 0c 00             	add    %cl,(%eax,%eax,1)
f0102fea:	00 00                	add    %al,(%eax)
f0102fec:	74 0c                	je     f0102ffa <__STAB_BEGIN__+0x91a>
f0102fee:	00 00                	add    %al,(%eax)
f0102ff0:	40                   	inc    %eax
	...
f0102ff9:	00 00                	add    %al,(%eax)
f0102ffb:	00 c0                	add    %al,%al
f0102ffd:	00 00                	add    %al,(%eax)
f0102fff:	00 03                	add    %al,(%ebx)
f0103001:	00 00                	add    %al,(%eax)
f0103003:	00 00                	add    %al,(%eax)
f0103005:	00 00                	add    %al,(%eax)
f0103007:	00 e0                	add    %ah,%al
f0103009:	00 00                	add    %al,(%eax)
f010300b:	00 09                	add    %cl,(%ecx)
f010300d:	00 00                	add    %al,(%eax)
f010300f:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f0103013:	00 40 00             	add    %al,0x0(%eax)
	...
f010301e:	00 00                	add    %al,(%eax)
f0103020:	c0 00 00             	rolb   $0x0,(%eax)
f0103023:	00 09                	add    %cl,(%ecx)
f0103025:	00 00                	add    %al,(%eax)
f0103027:	00 00                	add    %al,(%eax)
f0103029:	00 00                	add    %al,(%eax)
f010302b:	00 e0                	add    %ah,%al
f010302d:	00 00                	add    %al,(%eax)
f010302f:	00 0a                	add    %cl,(%edx)
f0103031:	00 00                	add    %al,(%eax)
f0103033:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f0103037:	00 40 00             	add    %al,0x0(%eax)
	...
f0103042:	00 00                	add    %al,(%eax)
f0103044:	c0 00 00             	rolb   $0x0,(%eax)
f0103047:	00 0a                	add    %cl,(%edx)
f0103049:	00 00                	add    %al,(%eax)
f010304b:	00 00                	add    %al,(%eax)
f010304d:	00 00                	add    %al,(%eax)
f010304f:	00 e0                	add    %ah,%al
f0103051:	00 00                	add    %al,(%eax)
f0103053:	00 0b                	add    %cl,(%ebx)
f0103055:	00 00                	add    %al,(%eax)
f0103057:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f010305b:	00 40 00             	add    %al,0x0(%eax)
	...
f0103066:	00 00                	add    %al,(%eax)
f0103068:	c0 00 00             	rolb   $0x0,(%eax)
f010306b:	00 0b                	add    %cl,(%ebx)
f010306d:	00 00                	add    %al,(%eax)
f010306f:	00 00                	add    %al,(%eax)
f0103071:	00 00                	add    %al,(%eax)
f0103073:	00 e0                	add    %ah,%al
f0103075:	00 00                	add    %al,(%eax)
f0103077:	00 0c 00             	add    %cl,(%eax,%eax,1)
f010307a:	00 00                	add    %al,(%eax)
f010307c:	80 0c 00 00          	orb    $0x0,(%eax,%eax,1)
f0103080:	24 00                	and    $0x0,%al
f0103082:	00 00                	add    %al,(%eax)
f0103084:	9e                   	sahf   
f0103085:	02 10                	add    (%eax),%dl
f0103087:	f0 00 00             	lock add %al,(%eax)
f010308a:	00 00                	add    %al,(%eax)
f010308c:	44                   	inc    %esp
f010308d:	00 34 00             	add    %dh,(%eax,%eax,1)
f0103090:	00 00                	add    %al,(%eax)
f0103092:	00 00                	add    %al,(%eax)
f0103094:	4b                   	dec    %ebx
f0103095:	0c 00                	or     $0x0,%al
f0103097:	00 84 00 00 00 a1 02 	add    %al,0x2a10000(%eax,%eax,1)
f010309e:	10 f0                	adc    %dh,%al
f01030a0:	00 00                	add    %al,(%eax)
f01030a2:	00 00                	add    %al,(%eax)
f01030a4:	44                   	inc    %esp
f01030a5:	00 30                	add    %dh,(%eax)
f01030a7:	00 03                	add    %al,(%ebx)
f01030a9:	00 00                	add    %al,(%eax)
f01030ab:	00 3c 0c             	add    %bh,(%esp,%ecx,1)
f01030ae:	00 00                	add    %al,(%eax)
f01030b0:	84 00                	test   %al,(%eax)
f01030b2:	00 00                	add    %al,(%eax)
f01030b4:	a9 02 10 f0 00       	test   $0xf01002,%eax
f01030b9:	00 00                	add    %al,(%eax)
f01030bb:	00 44 00 35          	add    %al,0x35(%eax,%eax,1)
f01030bf:	00 0b                	add    %cl,(%ebx)
f01030c1:	00 00                	add    %al,(%eax)
f01030c3:	00 4b 0c             	add    %cl,0xc(%ebx)
f01030c6:	00 00                	add    %al,(%eax)
f01030c8:	84 00                	test   %al,(%eax)
f01030ca:	00 00                	add    %al,(%eax)
f01030cc:	b3 02                	mov    $0x2,%bl
f01030ce:	10 f0                	adc    %dh,%al
f01030d0:	00 00                	add    %al,(%eax)
f01030d2:	00 00                	add    %al,(%eax)
f01030d4:	44                   	inc    %esp
f01030d5:	00 30                	add    %dh,(%eax)
f01030d7:	00 15 00 00 00 3c    	add    %dl,0x3c000000
f01030dd:	0c 00                	or     $0x0,%al
f01030df:	00 84 00 00 00 b9 02 	add    %al,0x2b90000(%eax,%eax,1)
f01030e6:	10 f0                	adc    %dh,%al
f01030e8:	00 00                	add    %al,(%eax)
f01030ea:	00 00                	add    %al,(%eax)
f01030ec:	44                   	inc    %esp
f01030ed:	00 37                	add    %dh,(%edi)
f01030ef:	00 1b                	add    %bl,(%ebx)
f01030f1:	00 00                	add    %al,(%eax)
f01030f3:	00 00                	add    %al,(%eax)
f01030f5:	00 00                	add    %al,(%eax)
f01030f7:	00 44 00 38          	add    %al,0x38(%eax,%eax,1)
f01030fb:	00 1e                	add    %bl,(%esi)
f01030fd:	00 00                	add    %al,(%eax)
f01030ff:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f0103103:	00 40 00             	add    %al,0x0(%eax)
f0103106:	00 00                	add    %al,(%eax)
f0103108:	02 00                	add    (%eax),%al
f010310a:	00 00                	add    %al,(%eax)
f010310c:	00 00                	add    %al,(%eax)
f010310e:	00 00                	add    %al,(%eax)
f0103110:	c0 00 00             	rolb   $0x0,(%eax)
f0103113:	00 03                	add    %al,(%ebx)
f0103115:	00 00                	add    %al,(%eax)
f0103117:	00 00                	add    %al,(%eax)
f0103119:	00 00                	add    %al,(%eax)
f010311b:	00 e0                	add    %ah,%al
f010311d:	00 00                	add    %al,(%eax)
f010311f:	00 0b                	add    %cl,(%ebx)
f0103121:	00 00                	add    %al,(%eax)
f0103123:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f0103127:	00 40 00             	add    %al,0x0(%eax)
	...
f0103132:	00 00                	add    %al,(%eax)
f0103134:	c0 00 00             	rolb   $0x0,(%eax)
f0103137:	00 15 00 00 00 00    	add    %dl,0x0
f010313d:	00 00                	add    %al,(%eax)
f010313f:	00 e0                	add    %ah,%al
f0103141:	00 00                	add    %al,(%eax)
f0103143:	00 1b                	add    %bl,(%ebx)
f0103145:	00 00                	add    %al,(%eax)
f0103147:	00 98 0c 00 00 24    	add    %bl,0x2400000c(%eax)
f010314d:	00 00                	add    %al,(%eax)
f010314f:	00 be 02 10 f0 aa    	add    %bh,-0x550feffe(%esi)
f0103155:	0c 00                	or     $0x0,%al
f0103157:	00 40 00             	add    %al,0x0(%eax)
f010315a:	00 00                	add    %al,(%eax)
f010315c:	06                   	push   %es
f010315d:	00 00                	add    %al,(%eax)
f010315f:	00 00                	add    %al,(%eax)
f0103161:	00 00                	add    %al,(%eax)
f0103163:	00 44 00 89          	add    %al,-0x77(%eax,%eax,1)
f0103167:	01 00                	add    %eax,(%eax)
f0103169:	00 00                	add    %al,(%eax)
f010316b:	00 00                	add    %al,(%eax)
f010316d:	00 00                	add    %al,(%eax)
f010316f:	00 44 00 8f          	add    %al,-0x71(%eax,%eax,1)
f0103173:	01 0b                	add    %ecx,(%ebx)
f0103175:	00 00                	add    %al,(%eax)
f0103177:	00 00                	add    %al,(%eax)
f0103179:	00 00                	add    %al,(%eax)
f010317b:	00 44 00 8c          	add    %al,-0x74(%eax,%eax,1)
f010317f:	01 15 00 00 00 00    	add    %edx,0x0
f0103185:	00 00                	add    %al,(%eax)
f0103187:	00 44 00 8d          	add    %al,-0x73(%eax,%eax,1)
f010318b:	01 17                	add    %edx,(%edi)
f010318d:	00 00                	add    %al,(%eax)
f010318f:	00 00                	add    %al,(%eax)
f0103191:	00 00                	add    %al,(%eax)
f0103193:	00 44 00 8f          	add    %al,-0x71(%eax,%eax,1)
f0103197:	01 1b                	add    %ebx,(%ebx)
f0103199:	00 00                	add    %al,(%eax)
f010319b:	00 00                	add    %al,(%eax)
f010319d:	00 00                	add    %al,(%eax)
f010319f:	00 44 00 90          	add    %al,-0x70(%eax,%eax,1)
f01031a3:	01 23                	add    %esp,(%ebx)
f01031a5:	00 00                	add    %al,(%eax)
f01031a7:	00 00                	add    %al,(%eax)
f01031a9:	00 00                	add    %al,(%eax)
f01031ab:	00 44 00 91          	add    %al,-0x6f(%eax,%eax,1)
f01031af:	01 28                	add    %ebp,(%eax)
f01031b1:	00 00                	add    %al,(%eax)
f01031b3:	00 00                	add    %al,(%eax)
f01031b5:	00 00                	add    %al,(%eax)
f01031b7:	00 44 00 8c          	add    %al,-0x74(%eax,%eax,1)
f01031bb:	01 35 00 00 00 00    	add    %esi,0x0
f01031c1:	00 00                	add    %al,(%eax)
f01031c3:	00 44 00 93          	add    %al,-0x6d(%eax,%eax,1)
f01031c7:	01 3c 00             	add    %edi,(%eax,%eax,1)
f01031ca:	00 00                	add    %al,(%eax)
f01031cc:	c6                   	(bad)  
f01031cd:	0c 00                	or     $0x0,%al
f01031cf:	00 40 00             	add    %al,0x0(%eax)
	...
f01031da:	00 00                	add    %al,(%eax)
f01031dc:	c0 00 00             	rolb   $0x0,(%eax)
	...
f01031e7:	00 e0                	add    %ah,%al
f01031e9:	00 00                	add    %al,(%eax)
f01031eb:	00 44 00 00          	add    %al,0x0(%eax,%eax,1)
f01031ef:	00 cf                	add    %cl,%bh
f01031f1:	0c 00                	or     $0x0,%al
f01031f3:	00 24 00             	add    %ah,(%eax,%eax,1)
f01031f6:	00 00                	add    %al,(%eax)
f01031f8:	02 03                	add    (%ebx),%al
f01031fa:	10 f0                	adc    %dh,%al
f01031fc:	00 00                	add    %al,(%eax)
f01031fe:	00 00                	add    %al,(%eax)
f0103200:	44                   	inc    %esp
f0103201:	00 6d 01             	add    %ch,0x1(%ebp)
	...
f010320c:	44                   	inc    %esp
f010320d:	00 6e 01             	add    %ch,0x1(%esi)
f0103210:	06                   	push   %es
f0103211:	00 00                	add    %al,(%eax)
f0103213:	00 00                	add    %al,(%eax)
f0103215:	00 00                	add    %al,(%eax)
f0103217:	00 44 00 6f          	add    %al,0x6f(%eax,%eax,1)
f010321b:	01 10                	add    %edx,(%eax)
f010321d:	00 00                	add    %al,(%eax)
f010321f:	00 e0                	add    %ah,%al
f0103221:	0c 00                	or     $0x0,%al
f0103223:	00 24 00             	add    %ah,(%eax,%eax,1)
f0103226:	00 00                	add    %al,(%eax)
f0103228:	14 03                	adc    $0x3,%al
f010322a:	10 f0                	adc    %dh,%al
f010322c:	00 00                	add    %al,(%eax)
f010322e:	00 00                	add    %al,(%eax)
f0103230:	44                   	inc    %esp
f0103231:	00 3c 00             	add    %bh,(%eax,%eax,1)
	...
f010323c:	44                   	inc    %esp
f010323d:	00 3d 00 06 00 00    	add    %bh,0x600
f0103243:	00 00                	add    %al,(%eax)
f0103245:	00 00                	add    %al,(%eax)
f0103247:	00 44 00 3e          	add    %al,0x3e(%eax,%eax,1)
f010324b:	00 0f                	add    %cl,(%edi)
f010324d:	00 00                	add    %al,(%eax)
f010324f:	00 00                	add    %al,(%eax)
f0103251:	00 00                	add    %al,(%eax)
f0103253:	00 44 00 3f          	add    %al,0x3f(%eax,%eax,1)
f0103257:	00 19                	add    %bl,(%ecx)
f0103259:	00 00                	add    %al,(%eax)
f010325b:	00 f4                	add    %dh,%ah
f010325d:	0c 00                	or     $0x0,%al
f010325f:	00 24 00             	add    %ah,(%eax,%eax,1)
f0103262:	00 00                	add    %al,(%eax)
f0103264:	2f                   	das    
f0103265:	03 10                	add    (%eax),%edx
f0103267:	f0 00 00             	lock add %al,(%eax)
f010326a:	00 00                	add    %al,(%eax)
f010326c:	44                   	inc    %esp
f010326d:	00 98 01 00 00 00    	add    %bl,0x1(%eax)
f0103273:	00 00                	add    %al,(%eax)
f0103275:	00 00                	add    %al,(%eax)
f0103277:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
f010327b:	01 06                	add    %eax,(%esi)
f010327d:	00 00                	add    %al,(%eax)
f010327f:	00 00                	add    %al,(%eax)
f0103281:	00 00                	add    %al,(%eax)
f0103283:	00 44 00 9f          	add    %al,-0x61(%eax,%eax,1)
f0103287:	01 0b                	add    %ecx,(%ebx)
f0103289:	00 00                	add    %al,(%eax)
f010328b:	00 00                	add    %al,(%eax)
f010328d:	00 00                	add    %al,(%eax)
f010328f:	00 44 00 a2          	add    %al,-0x5e(%eax,%eax,1)
f0103293:	01 10                	add    %edx,(%eax)
f0103295:	00 00                	add    %al,(%eax)
f0103297:	00 00                	add    %al,(%eax)
f0103299:	00 00                	add    %al,(%eax)
f010329b:	00 44 00 a3          	add    %al,-0x5d(%eax,%eax,1)
f010329f:	01 23                	add    %esp,(%ebx)
f01032a1:	00 00                	add    %al,(%eax)
f01032a3:	00 00                	add    %al,(%eax)
f01032a5:	00 00                	add    %al,(%eax)
f01032a7:	00 44 00 a4          	add    %al,-0x5c(%eax,%eax,1)
f01032ab:	01 2d 00 00 00 00    	add    %ebp,0x0
f01032b1:	00 00                	add    %al,(%eax)
f01032b3:	00 44 00 a5          	add    %al,-0x5b(%eax,%eax,1)
f01032b7:	01 33                	add    %esi,(%ebx)
f01032b9:	00 00                	add    %al,(%eax)
f01032bb:	00 00                	add    %al,(%eax)
f01032bd:	00 00                	add    %al,(%eax)
f01032bf:	00 44 00 a9          	add    %al,-0x57(%eax,%eax,1)
f01032c3:	01 44 00 00          	add    %eax,0x0(%eax,%eax,1)
f01032c7:	00 c6                	add    %al,%dh
f01032c9:	0c 00                	or     $0x0,%al
f01032cb:	00 40 00             	add    %al,0x0(%eax)
	...
f01032d6:	00 00                	add    %al,(%eax)
f01032d8:	c0 00 00             	rolb   $0x0,(%eax)
	...
f01032e3:	00 e0                	add    %ah,%al
f01032e5:	00 00                	add    %al,(%eax)
f01032e7:	00 46 00             	add    %al,0x0(%esi)
f01032ea:	00 00                	add    %al,(%eax)
f01032ec:	05 0d 00 00 24       	add    $0x2400000d,%eax
f01032f1:	00 00                	add    %al,(%eax)
f01032f3:	00 75 03             	add    %dh,0x3(%ebp)
f01032f6:	10 f0                	adc    %dh,%al
f01032f8:	00 00                	add    %al,(%eax)
f01032fa:	00 00                	add    %al,(%eax)
f01032fc:	44                   	inc    %esp
f01032fd:	00 cb                	add    %cl,%bl
f01032ff:	01 00                	add    %eax,(%eax)
f0103301:	00 00                	add    %al,(%eax)
f0103303:	00 00                	add    %al,(%eax)
f0103305:	00 00                	add    %al,(%eax)
f0103307:	00 44 00 ce          	add    %al,-0x32(%eax,%eax,1)
f010330b:	01 06                	add    %eax,(%esi)
f010330d:	00 00                	add    %al,(%eax)
f010330f:	00 00                	add    %al,(%eax)
f0103311:	00 00                	add    %al,(%eax)
f0103313:	00 44 00 d1          	add    %al,-0x2f(%eax,%eax,1)
f0103317:	01 0f                	add    %ecx,(%edi)
f0103319:	00 00                	add    %al,(%eax)
f010331b:	00 c6                	add    %al,%dh
f010331d:	0c 00                	or     $0x0,%al
f010331f:	00 40 00             	add    %al,0x0(%eax)
	...
f010332a:	00 00                	add    %al,(%eax)
f010332c:	c0 00 00             	rolb   $0x0,(%eax)
	...
f0103337:	00 e0                	add    %ah,%al
f0103339:	00 00                	add    %al,(%eax)
f010333b:	00 11                	add    %dl,(%ecx)
f010333d:	00 00                	add    %al,(%eax)
f010333f:	00 14 0d 00 00 24 00 	add    %dl,0x240000(,%ecx,1)
f0103346:	00 00                	add    %al,(%eax)
f0103348:	86 03                	xchg   %al,(%ebx)
f010334a:	10 f0                	adc    %dh,%al
f010334c:	22 0d 00 00 a0 00    	and    0xa00000,%cl
f0103352:	00 00                	add    %al,(%eax)
f0103354:	08 00                	or     %al,(%eax)
f0103356:	00 00                	add    %al,(%eax)
f0103358:	00 00                	add    %al,(%eax)
f010335a:	00 00                	add    %al,(%eax)
f010335c:	44                   	inc    %esp
f010335d:	00 d5                	add    %dl,%ch
f010335f:	01 00                	add    %eax,(%eax)
f0103361:	00 00                	add    %al,(%eax)
f0103363:	00 00                	add    %al,(%eax)
f0103365:	00 00                	add    %al,(%eax)
f0103367:	00 44 00 d8          	add    %al,-0x28(%eax,%eax,1)
f010336b:	01 03                	add    %eax,(%ebx)
f010336d:	00 00                	add    %al,(%eax)
f010336f:	00 2f                	add    %ch,(%edi)
f0103371:	0d 00 00 24 00       	or     $0x240000,%eax
f0103376:	00 00                	add    %al,(%eax)
f0103378:	90                   	nop
f0103379:	03 10                	add    (%eax),%edx
f010337b:	f0 41                	lock inc %ecx
f010337d:	0d 00 00 40 00       	or     $0x400000,%eax
f0103382:	00 00                	add    %al,(%eax)
f0103384:	07                   	pop    %es
f0103385:	00 00                	add    %al,(%eax)
f0103387:	00 00                	add    %al,(%eax)
f0103389:	00 00                	add    %al,(%eax)
f010338b:	00 44 00 ae          	add    %al,-0x52(%eax,%eax,1)
f010338f:	01 00                	add    %eax,(%eax)
f0103391:	00 00                	add    %al,(%eax)
f0103393:	00 4b 0c             	add    %cl,0xc(%ebx)
f0103396:	00 00                	add    %al,(%eax)
f0103398:	84 00                	test   %al,(%eax)
f010339a:	00 00                	add    %al,(%eax)
f010339c:	9b                   	fwait
f010339d:	03 10                	add    (%eax),%edx
f010339f:	f0 00 00             	lock add %al,(%eax)
f01033a2:	00 00                	add    %al,(%eax)
f01033a4:	44                   	inc    %esp
f01033a5:	00 30                	add    %dh,(%eax)
f01033a7:	00 0b                	add    %cl,(%ebx)
f01033a9:	00 00                	add    %al,(%eax)
f01033ab:	00 3c 0c             	add    %bh,(%esp,%ecx,1)
f01033ae:	00 00                	add    %al,(%eax)
f01033b0:	84 00                	test   %al,(%eax)
f01033b2:	00 00                	add    %al,(%eax)
f01033b4:	a1 03 10 f0 00       	mov    0xf01003,%eax
f01033b9:	00 00                	add    %al,(%eax)
f01033bb:	00 44 00 46          	add    %al,0x46(%eax,%eax,1)
f01033bf:	00 11                	add    %dl,(%ecx)
f01033c1:	00 00                	add    %al,(%eax)
f01033c3:	00 4b 0c             	add    %cl,0xc(%ebx)
f01033c6:	00 00                	add    %al,(%eax)
f01033c8:	84 00                	test   %al,(%eax)
f01033ca:	00 00                	add    %al,(%eax)
f01033cc:	aa                   	stos   %al,%es:(%edi)
f01033cd:	03 10                	add    (%eax),%edx
f01033cf:	f0 00 00             	lock add %al,(%eax)
f01033d2:	00 00                	add    %al,(%eax)
f01033d4:	44                   	inc    %esp
f01033d5:	00 30                	add    %dh,(%eax)
f01033d7:	00 1a                	add    %bl,(%edx)
f01033d9:	00 00                	add    %al,(%eax)
f01033db:	00 3c 0c             	add    %bh,(%esp,%ecx,1)
f01033de:	00 00                	add    %al,(%eax)
f01033e0:	84 00                	test   %al,(%eax)
f01033e2:	00 00                	add    %al,(%eax)
f01033e4:	af                   	scas   %es:(%edi),%eax
f01033e5:	03 10                	add    (%eax),%edx
f01033e7:	f0 00 00             	lock add %al,(%eax)
f01033ea:	00 00                	add    %al,(%eax)
f01033ec:	44                   	inc    %esp
f01033ed:	00 49 00             	add    %cl,0x0(%ecx)
f01033f0:	1f                   	pop    %ds
f01033f1:	00 00                	add    %al,(%eax)
f01033f3:	00 4b 0c             	add    %cl,0xc(%ebx)
f01033f6:	00 00                	add    %al,(%eax)
f01033f8:	84 00                	test   %al,(%eax)
f01033fa:	00 00                	add    %al,(%eax)
f01033fc:	b4 03                	mov    $0x3,%ah
f01033fe:	10 f0                	adc    %dh,%al
f0103400:	00 00                	add    %al,(%eax)
f0103402:	00 00                	add    %al,(%eax)
f0103404:	44                   	inc    %esp
f0103405:	00 30                	add    %dh,(%eax)
f0103407:	00 24 00             	add    %ah,(%eax,%eax,1)
f010340a:	00 00                	add    %al,(%eax)
f010340c:	3c 0c                	cmp    $0xc,%al
f010340e:	00 00                	add    %al,(%eax)
f0103410:	84 00                	test   %al,(%eax)
f0103412:	00 00                	add    %al,(%eax)
f0103414:	b7 03                	mov    $0x3,%bh
f0103416:	10 f0                	adc    %dh,%al
f0103418:	00 00                	add    %al,(%eax)
f010341a:	00 00                	add    %al,(%eax)
f010341c:	44                   	inc    %esp
f010341d:	00 46 00             	add    %al,0x0(%esi)
f0103420:	27                   	daa    
f0103421:	00 00                	add    %al,(%eax)
f0103423:	00 00                	add    %al,(%eax)
f0103425:	00 00                	add    %al,(%eax)
f0103427:	00 44 00 48          	add    %al,0x48(%eax,%eax,1)
f010342b:	00 2b                	add    %ch,(%ebx)
f010342d:	00 00                	add    %al,(%eax)
f010342f:	00 00                	add    %al,(%eax)
f0103431:	00 00                	add    %al,(%eax)
f0103433:	00 44 00 46          	add    %al,0x46(%eax,%eax,1)
f0103437:	00 2e                	add    %ch,(%esi)
f0103439:	00 00                	add    %al,(%eax)
f010343b:	00 00                	add    %al,(%eax)
f010343d:	00 00                	add    %al,(%eax)
f010343f:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
f0103443:	00 36                	add    %dh,(%esi)
f0103445:	00 00                	add    %al,(%eax)
f0103447:	00 4b 0c             	add    %cl,0xc(%ebx)
f010344a:	00 00                	add    %al,(%eax)
f010344c:	84 00                	test   %al,(%eax)
f010344e:	00 00                	add    %al,(%eax)
f0103450:	cd 03                	int    $0x3
f0103452:	10 f0                	adc    %dh,%al
f0103454:	00 00                	add    %al,(%eax)
f0103456:	00 00                	add    %al,(%eax)
f0103458:	44                   	inc    %esp
f0103459:	00 62 00             	add    %ah,0x0(%edx)
f010345c:	3d 00 00 00 00       	cmp    $0x0,%eax
f0103461:	00 00                	add    %al,(%eax)
f0103463:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
f0103467:	00 43 00             	add    %al,0x0(%ebx)
f010346a:	00 00                	add    %al,(%eax)
f010346c:	3c 0c                	cmp    $0xc,%al
f010346e:	00 00                	add    %al,(%eax)
f0103470:	84 00                	test   %al,(%eax)
f0103472:	00 00                	add    %al,(%eax)
f0103474:	d6                   	(bad)  
f0103475:	03 10                	add    (%eax),%edx
f0103477:	f0 00 00             	lock add %al,(%eax)
f010347a:	00 00                	add    %al,(%eax)
f010347c:	44                   	inc    %esp
f010347d:	00 74 00 46          	add    %dh,0x46(%eax,%eax,1)
f0103481:	00 00                	add    %al,(%eax)
f0103483:	00 4b 0c             	add    %cl,0xc(%ebx)
f0103486:	00 00                	add    %al,(%eax)
f0103488:	84 00                	test   %al,(%eax)
f010348a:	00 00                	add    %al,(%eax)
f010348c:	df 03                	fild   (%ebx)
f010348e:	10 f0                	adc    %dh,%al
f0103490:	00 00                	add    %al,(%eax)
f0103492:	00 00                	add    %al,(%eax)
f0103494:	44                   	inc    %esp
f0103495:	00 30                	add    %dh,(%eax)
f0103497:	00 4f 00             	add    %cl,0x0(%edi)
f010349a:	00 00                	add    %al,(%eax)
f010349c:	3c 0c                	cmp    $0xc,%al
f010349e:	00 00                	add    %al,(%eax)
f01034a0:	84 00                	test   %al,(%eax)
f01034a2:	00 00                	add    %al,(%eax)
f01034a4:	e4 03                	in     $0x3,%al
f01034a6:	10 f0                	adc    %dh,%al
f01034a8:	00 00                	add    %al,(%eax)
f01034aa:	00 00                	add    %al,(%eax)
f01034ac:	44                   	inc    %esp
f01034ad:	00 75 00             	add    %dh,0x0(%ebp)
f01034b0:	54                   	push   %esp
f01034b1:	00 00                	add    %al,(%eax)
f01034b3:	00 4b 0c             	add    %cl,0xc(%ebx)
f01034b6:	00 00                	add    %al,(%eax)
f01034b8:	84 00                	test   %al,(%eax)
f01034ba:	00 00                	add    %al,(%eax)
f01034bc:	e9 03 10 f0 00       	jmp    f10044c4 <end+0xef0b64>
f01034c1:	00 00                	add    %al,(%eax)
f01034c3:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
f01034c7:	00 59 00             	add    %bl,0x0(%ecx)
f01034ca:	00 00                	add    %al,(%eax)
f01034cc:	3c 0c                	cmp    $0xc,%al
f01034ce:	00 00                	add    %al,(%eax)
f01034d0:	84 00                	test   %al,(%eax)
f01034d2:	00 00                	add    %al,(%eax)
f01034d4:	ec                   	in     (%dx),%al
f01034d5:	03 10                	add    (%eax),%edx
f01034d7:	f0 00 00             	lock add %al,(%eax)
f01034da:	00 00                	add    %al,(%eax)
f01034dc:	44                   	inc    %esp
f01034dd:	00 74 00 5c          	add    %dh,0x5c(%eax,%eax,1)
f01034e1:	00 00                	add    %al,(%eax)
f01034e3:	00 4b 0c             	add    %cl,0xc(%ebx)
f01034e6:	00 00                	add    %al,(%eax)
f01034e8:	84 00                	test   %al,(%eax)
f01034ea:	00 00                	add    %al,(%eax)
f01034ec:	fb                   	sti    
f01034ed:	03 10                	add    (%eax),%edx
f01034ef:	f0 00 00             	lock add %al,(%eax)
f01034f2:	00 00                	add    %al,(%eax)
f01034f4:	44                   	inc    %esp
f01034f5:	00 62 00             	add    %ah,0x0(%edx)
f01034f8:	6b 00 00             	imul   $0x0,(%eax),%eax
f01034fb:	00 3c 0c             	add    %bh,(%esp,%ecx,1)
f01034fe:	00 00                	add    %al,(%eax)
f0103500:	84 00                	test   %al,(%eax)
f0103502:	00 00                	add    %al,(%eax)
f0103504:	13 04 10             	adc    (%eax,%edx,1),%eax
f0103507:	f0 00 00             	lock add %al,(%eax)
f010350a:	00 00                	add    %al,(%eax)
f010350c:	44                   	inc    %esp
f010350d:	00 a6 00 83 00 00    	add    %ah,0x8300(%esi)
f0103513:	00 00                	add    %al,(%eax)
f0103515:	00 00                	add    %al,(%eax)
f0103517:	00 44 00 a7          	add    %al,-0x59(%eax,%eax,1)
f010351b:	00 8b 00 00 00 00    	add    %cl,0x0(%ebx)
f0103521:	00 00                	add    %al,(%eax)
f0103523:	00 44 00 a9          	add    %al,-0x57(%eax,%eax,1)
f0103527:	00 91 00 00 00 00    	add    %dl,0x0(%ecx)
f010352d:	00 00                	add    %al,(%eax)
f010352f:	00 44 00 ab          	add    %al,-0x55(%eax,%eax,1)
f0103533:	00 ca                	add    %cl,%dl
f0103535:	00 00                	add    %al,(%eax)
f0103537:	00 00                	add    %al,(%eax)
f0103539:	00 00                	add    %al,(%eax)
f010353b:	00 44 00 ac          	add    %al,-0x54(%eax,%eax,1)
f010353f:	00 da                	add    %bl,%dl
f0103541:	00 00                	add    %al,(%eax)
f0103543:	00 00                	add    %al,(%eax)
f0103545:	00 00                	add    %al,(%eax)
f0103547:	00 44 00 ad          	add    %al,-0x53(%eax,%eax,1)
f010354b:	00 e3                	add    %ah,%bl
f010354d:	00 00                	add    %al,(%eax)
f010354f:	00 00                	add    %al,(%eax)
f0103551:	00 00                	add    %al,(%eax)
f0103553:	00 44 00 b1          	add    %al,-0x4f(%eax,%eax,1)
f0103557:	00 fa                	add    %bh,%dl
f0103559:	00 00                	add    %al,(%eax)
f010355b:	00 00                	add    %al,(%eax)
f010355d:	00 00                	add    %al,(%eax)
f010355f:	00 44 00 b4          	add    %al,-0x4c(%eax,%eax,1)
f0103563:	00 02                	add    %al,(%edx)
f0103565:	01 00                	add    %eax,(%eax)
f0103567:	00 00                	add    %al,(%eax)
f0103569:	00 00                	add    %al,(%eax)
f010356b:	00 44 00 b7          	add    %al,-0x49(%eax,%eax,1)
f010356f:	00 24 01             	add    %ah,(%ecx,%eax,1)
f0103572:	00 00                	add    %al,(%eax)
f0103574:	00 00                	add    %al,(%eax)
f0103576:	00 00                	add    %al,(%eax)
f0103578:	44                   	inc    %esp
f0103579:	00 b8 00 2e 01 00    	add    %bh,0x12e00(%eax)
f010357f:	00 00                	add    %al,(%eax)
f0103581:	00 00                	add    %al,(%eax)
f0103583:	00 44 00 b9          	add    %al,-0x47(%eax,%eax,1)
f0103587:	00 38                	add    %bh,(%eax)
f0103589:	01 00                	add    %eax,(%eax)
f010358b:	00 00                	add    %al,(%eax)
f010358d:	00 00                	add    %al,(%eax)
f010358f:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
f0103593:	00 42 01             	add    %al,0x1(%edx)
f0103596:	00 00                	add    %al,(%eax)
f0103598:	00 00                	add    %al,(%eax)
f010359a:	00 00                	add    %al,(%eax)
f010359c:	44                   	inc    %esp
f010359d:	00 bb 00 4c 01 00    	add    %bh,0x14c00(%ebx)
f01035a3:	00 00                	add    %al,(%eax)
f01035a5:	00 00                	add    %al,(%eax)
f01035a7:	00 44 00 be          	add    %al,-0x42(%eax,%eax,1)
f01035ab:	00 58 01             	add    %bl,0x1(%eax)
f01035ae:	00 00                	add    %al,(%eax)
f01035b0:	00 00                	add    %al,(%eax)
f01035b2:	00 00                	add    %al,(%eax)
f01035b4:	44                   	inc    %esp
f01035b5:	00 c3                	add    %al,%bl
f01035b7:	00 75 01             	add    %dh,0x1(%ebp)
f01035ba:	00 00                	add    %al,(%eax)
f01035bc:	00 00                	add    %al,(%eax)
f01035be:	00 00                	add    %al,(%eax)
f01035c0:	44                   	inc    %esp
f01035c1:	00 c6                	add    %al,%dh
f01035c3:	00 80 01 00 00 00    	add    %al,0x1(%eax)
f01035c9:	00 00                	add    %al,(%eax)
f01035cb:	00 44 00 c8          	add    %al,-0x38(%eax,%eax,1)
f01035cf:	00 9f 01 00 00 00    	add    %bl,0x1(%edi)
f01035d5:	00 00                	add    %al,(%eax)
f01035d7:	00 44 00 c7          	add    %al,-0x39(%eax,%eax,1)
f01035db:	00 b0 01 00 00 00    	add    %dh,0x1(%eax)
f01035e1:	00 00                	add    %al,(%eax)
f01035e3:	00 44 00 c9          	add    %al,-0x37(%eax,%eax,1)
f01035e7:	00 ba 01 00 00 00    	add    %bh,0x1(%edx)
f01035ed:	00 00                	add    %al,(%eax)
f01035ef:	00 44 00 cd          	add    %al,-0x33(%eax,%eax,1)
f01035f3:	00 c2                	add    %al,%dl
f01035f5:	01 00                	add    %eax,(%eax)
f01035f7:	00 4b 0c             	add    %cl,0xc(%ebx)
f01035fa:	00 00                	add    %al,(%eax)
f01035fc:	84 00                	test   %al,(%eax)
f01035fe:	00 00                	add    %al,(%eax)
f0103600:	5a                   	pop    %edx
f0103601:	05 10 f0 00 00       	add    $0xf010,%eax
f0103606:	00 00                	add    %al,(%eax)
f0103608:	44                   	inc    %esp
f0103609:	00 62 00             	add    %ah,0x0(%edx)
f010360c:	ca 01 00             	lret   $0x1
f010360f:	00 3c 0c             	add    %bh,(%esp,%ecx,1)
f0103612:	00 00                	add    %al,(%eax)
f0103614:	84 00                	test   %al,(%eax)
f0103616:	00 00                	add    %al,(%eax)
f0103618:	62 05 10 f0 00 00    	bound  %eax,0xf010
f010361e:	00 00                	add    %al,(%eax)
f0103620:	44                   	inc    %esp
f0103621:	00 ce                	add    %cl,%dh
f0103623:	00 d2                	add    %dl,%dl
f0103625:	01 00                	add    %eax,(%eax)
f0103627:	00 4b 0c             	add    %cl,0xc(%ebx)
f010362a:	00 00                	add    %al,(%eax)
f010362c:	84 00                	test   %al,(%eax)
f010362e:	00 00                	add    %al,(%eax)
f0103630:	6c                   	insb   (%dx),%es:(%edi)
f0103631:	05 10 f0 00 00       	add    $0xf010,%eax
f0103636:	00 00                	add    %al,(%eax)
f0103638:	44                   	inc    %esp
f0103639:	00 62 00             	add    %ah,0x0(%edx)
f010363c:	dc 01                	faddl  (%ecx)
f010363e:	00 00                	add    %al,(%eax)
f0103640:	3c 0c                	cmp    $0xc,%al
f0103642:	00 00                	add    %al,(%eax)
f0103644:	84 00                	test   %al,(%eax)
f0103646:	00 00                	add    %al,(%eax)
f0103648:	82                   	(bad)  
f0103649:	05 10 f0 00 00       	add    $0xf010,%eax
f010364e:	00 00                	add    %al,(%eax)
f0103650:	44                   	inc    %esp
f0103651:	00 b2 01 f2 01 00    	add    %dh,0x1f201(%edx)
f0103657:	00 4a 0d             	add    %cl,0xd(%edx)
f010365a:	00 00                	add    %al,(%eax)
f010365c:	40                   	inc    %eax
f010365d:	00 00                	add    %al,(%eax)
f010365f:	00 03                	add    %al,(%ebx)
f0103661:	00 00                	add    %al,(%eax)
f0103663:	00 00                	add    %al,(%eax)
f0103665:	00 00                	add    %al,(%eax)
f0103667:	00 c0                	add    %al,%al
f0103669:	00 00                	add    %al,(%eax)
f010366b:	00 0b                	add    %cl,(%ebx)
f010366d:	00 00                	add    %al,(%eax)
f010366f:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f0103673:	00 40 00             	add    %al,0x0(%eax)
	...
f010367e:	00 00                	add    %al,(%eax)
f0103680:	c0 00 00             	rolb   $0x0,(%eax)
f0103683:	00 1a                	add    %bl,(%edx)
f0103685:	00 00                	add    %al,(%eax)
f0103687:	00 00                	add    %al,(%eax)
f0103689:	00 00                	add    %al,(%eax)
f010368b:	00 e0                	add    %ah,%al
f010368d:	00 00                	add    %al,(%eax)
f010368f:	00 1f                	add    %bl,(%edi)
f0103691:	00 00                	add    %al,(%eax)
f0103693:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f0103697:	00 40 00             	add    %al,0x0(%eax)
	...
f01036a2:	00 00                	add    %al,(%eax)
f01036a4:	c0 00 00             	rolb   $0x0,(%eax)
f01036a7:	00 0b                	add    %cl,(%ebx)
f01036a9:	00 00                	add    %al,(%eax)
f01036ab:	00 00                	add    %al,(%eax)
f01036ad:	00 00                	add    %al,(%eax)
f01036af:	00 e0                	add    %ah,%al
f01036b1:	00 00                	add    %al,(%eax)
f01036b3:	00 11                	add    %dl,(%ecx)
f01036b5:	00 00                	add    %al,(%eax)
f01036b7:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f01036bb:	00 40 00             	add    %al,0x0(%eax)
	...
f01036c6:	00 00                	add    %al,(%eax)
f01036c8:	c0 00 00             	rolb   $0x0,(%eax)
f01036cb:	00 24 00             	add    %ah,(%eax,%eax,1)
f01036ce:	00 00                	add    %al,(%eax)
f01036d0:	00 00                	add    %al,(%eax)
f01036d2:	00 00                	add    %al,(%eax)
f01036d4:	e0 00                	loopne f01036d6 <__STAB_BEGIN__+0xff6>
f01036d6:	00 00                	add    %al,(%eax)
f01036d8:	27                   	daa    
f01036d9:	00 00                	add    %al,(%eax)
f01036db:	00 00                	add    %al,(%eax)
f01036dd:	00 00                	add    %al,(%eax)
f01036df:	00 e0                	add    %ah,%al
f01036e1:	00 00                	add    %al,(%eax)
f01036e3:	00 43 00             	add    %al,0x0(%ebx)
f01036e6:	00 00                	add    %al,(%eax)
f01036e8:	4a                   	dec    %edx
f01036e9:	0d 00 00 40 00       	or     $0x400000,%eax
f01036ee:	00 00                	add    %al,(%eax)
f01036f0:	03 00                	add    (%eax),%eax
f01036f2:	00 00                	add    %al,(%eax)
f01036f4:	00 00                	add    %al,(%eax)
f01036f6:	00 00                	add    %al,(%eax)
f01036f8:	c0 00 00             	rolb   $0x0,(%eax)
f01036fb:	00 43 00             	add    %al,0x0(%ebx)
f01036fe:	00 00                	add    %al,(%eax)
f0103700:	74 0c                	je     f010370e <__STAB_BEGIN__+0x102e>
f0103702:	00 00                	add    %al,(%eax)
f0103704:	40                   	inc    %eax
	...
f010370d:	00 00                	add    %al,(%eax)
f010370f:	00 c0                	add    %al,%al
f0103711:	00 00                	add    %al,(%eax)
f0103713:	00 4f 00             	add    %cl,0x0(%edi)
f0103716:	00 00                	add    %al,(%eax)
f0103718:	00 00                	add    %al,(%eax)
f010371a:	00 00                	add    %al,(%eax)
f010371c:	e0 00                	loopne f010371e <__STAB_BEGIN__+0x103e>
f010371e:	00 00                	add    %al,(%eax)
f0103720:	54                   	push   %esp
f0103721:	00 00                	add    %al,(%eax)
f0103723:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f0103727:	00 40 00             	add    %al,0x0(%eax)
	...
f0103732:	00 00                	add    %al,(%eax)
f0103734:	c0 00 00             	rolb   $0x0,(%eax)
f0103737:	00 43 00             	add    %al,0x0(%ebx)
f010373a:	00 00                	add    %al,(%eax)
f010373c:	00 00                	add    %al,(%eax)
f010373e:	00 00                	add    %al,(%eax)
f0103740:	e0 00                	loopne f0103742 <__STAB_BEGIN__+0x1062>
f0103742:	00 00                	add    %al,(%eax)
f0103744:	46                   	inc    %esi
f0103745:	00 00                	add    %al,(%eax)
f0103747:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f010374b:	00 40 00             	add    %al,0x0(%eax)
	...
f0103756:	00 00                	add    %al,(%eax)
f0103758:	c0 00 00             	rolb   $0x0,(%eax)
f010375b:	00 59 00             	add    %bl,0x0(%ecx)
f010375e:	00 00                	add    %al,(%eax)
f0103760:	00 00                	add    %al,(%eax)
f0103762:	00 00                	add    %al,(%eax)
f0103764:	e0 00                	loopne f0103766 <__STAB_BEGIN__+0x1086>
f0103766:	00 00                	add    %al,(%eax)
f0103768:	5c                   	pop    %esp
f0103769:	00 00                	add    %al,(%eax)
f010376b:	00 00                	add    %al,(%eax)
f010376d:	00 00                	add    %al,(%eax)
f010376f:	00 e0                	add    %ah,%al
f0103771:	00 00                	add    %al,(%eax)
f0103773:	00 83 00 00 00 4a    	add    %al,0x4a000000(%ebx)
f0103779:	0d 00 00 40 00       	or     $0x400000,%eax
	...
f0103786:	00 00                	add    %al,(%eax)
f0103788:	c0 00 00             	rolb   $0x0,(%eax)
f010378b:	00 80 01 00 00 00    	add    %al,0x1(%eax)
f0103791:	00 00                	add    %al,(%eax)
f0103793:	00 e0                	add    %ah,%al
f0103795:	00 00                	add    %al,(%eax)
f0103797:	00 c2                	add    %al,%dl
f0103799:	01 00                	add    %eax,(%eax)
f010379b:	00 53 0d             	add    %dl,0xd(%ebx)
f010379e:	00 00                	add    %al,(%eax)
f01037a0:	24 00                	and    $0x0,%al
f01037a2:	00 00                	add    %al,(%eax)
f01037a4:	8a 05 10 f0 64 0d    	mov    0xd64f010,%al
f01037aa:	00 00                	add    %al,(%eax)
f01037ac:	a0 00 00 00 08       	mov    0x8000000,%al
f01037b1:	00 00                	add    %al,(%eax)
f01037b3:	00 00                	add    %al,(%eax)
f01037b5:	00 00                	add    %al,(%eax)
f01037b7:	00 44 00 c5          	add    %al,-0x3b(%eax,%eax,1)
f01037bb:	01 00                	add    %eax,(%eax)
f01037bd:	00 00                	add    %al,(%eax)
f01037bf:	00 00                	add    %al,(%eax)
f01037c1:	00 00                	add    %al,(%eax)
f01037c3:	00 44 00 c6          	add    %al,-0x3a(%eax,%eax,1)
f01037c7:	01 06                	add    %eax,(%esi)
f01037c9:	00 00                	add    %al,(%eax)
f01037cb:	00 00                	add    %al,(%eax)
f01037cd:	00 00                	add    %al,(%eax)
f01037cf:	00 44 00 c7          	add    %al,-0x39(%eax,%eax,1)
f01037d3:	01 0e                	add    %ecx,(%esi)
f01037d5:	00 00                	add    %al,(%eax)
f01037d7:	00 6d 0d             	add    %ch,0xd(%ebp)
f01037da:	00 00                	add    %al,(%eax)
f01037dc:	24 00                	and    $0x0,%al
f01037de:	00 00                	add    %al,(%eax)
f01037e0:	9a 05 10 f0 00 00 00 	lcall  $0x0,$0xf01005
f01037e7:	00 44 00 b7          	add    %al,-0x49(%eax,%eax,1)
f01037eb:	01 00                	add    %eax,(%eax)
f01037ed:	00 00                	add    %al,(%eax)
f01037ef:	00 00                	add    %al,(%eax)
f01037f1:	00 00                	add    %al,(%eax)
f01037f3:	00 44 00 8c          	add    %al,-0x74(%eax,%eax,1)
f01037f7:	00 09                	add    %cl,(%ecx)
f01037f9:	00 00                	add    %al,(%eax)
f01037fb:	00 00                	add    %al,(%eax)
f01037fd:	00 00                	add    %al,(%eax)
f01037ff:	00 44 00 8d          	add    %al,-0x73(%eax,%eax,1)
f0103803:	00 11                	add    %dl,(%ecx)
f0103805:	00 00                	add    %al,(%eax)
f0103807:	00 00                	add    %al,(%eax)
f0103809:	00 00                	add    %al,(%eax)
f010380b:	00 44 00 8e          	add    %al,-0x72(%eax,%eax,1)
f010380f:	00 16                	add    %dl,(%esi)
f0103811:	00 00                	add    %al,(%eax)
f0103813:	00 00                	add    %al,(%eax)
f0103815:	00 00                	add    %al,(%eax)
f0103817:	00 44 00 90          	add    %al,-0x70(%eax,%eax,1)
f010381b:	00 1f                	add    %bl,(%edi)
f010381d:	00 00                	add    %al,(%eax)
f010381f:	00 00                	add    %al,(%eax)
f0103821:	00 00                	add    %al,(%eax)
f0103823:	00 44 00 92          	add    %al,-0x6e(%eax,%eax,1)
f0103827:	00 30                	add    %dh,(%eax)
f0103829:	00 00                	add    %al,(%eax)
f010382b:	00 00                	add    %al,(%eax)
f010382d:	00 00                	add    %al,(%eax)
f010382f:	00 44 00 93          	add    %al,-0x6d(%eax,%eax,1)
f0103833:	00 37                	add    %dh,(%edi)
f0103835:	00 00                	add    %al,(%eax)
f0103837:	00 00                	add    %al,(%eax)
f0103839:	00 00                	add    %al,(%eax)
f010383b:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
f010383f:	00 46 00             	add    %al,0x0(%esi)
f0103842:	00 00                	add    %al,(%eax)
f0103844:	4b                   	dec    %ebx
f0103845:	0c 00                	or     $0x0,%al
f0103847:	00 84 00 00 00 e8 05 	add    %al,0x5e80000(%eax,%eax,1)
f010384e:	10 f0                	adc    %dh,%al
f0103850:	00 00                	add    %al,(%eax)
f0103852:	00 00                	add    %al,(%eax)
f0103854:	44                   	inc    %esp
f0103855:	00 62 00             	add    %ah,0x0(%edx)
f0103858:	4e                   	dec    %esi
f0103859:	00 00                	add    %al,(%eax)
f010385b:	00 3c 0c             	add    %bh,(%esp,%ecx,1)
f010385e:	00 00                	add    %al,(%eax)
f0103860:	84 00                	test   %al,(%eax)
f0103862:	00 00                	add    %al,(%eax)
f0103864:	f0 05 10 f0 00 00    	lock add $0xf010,%eax
f010386a:	00 00                	add    %al,(%eax)
f010386c:	44                   	inc    %esp
f010386d:	00 98 00 56 00 00    	add    %bl,0x5600(%eax)
f0103873:	00 4b 0c             	add    %cl,0xc(%ebx)
f0103876:	00 00                	add    %al,(%eax)
f0103878:	84 00                	test   %al,(%eax)
f010387a:	00 00                	add    %al,(%eax)
f010387c:	f3 05 10 f0 00 00    	repz add $0xf010,%eax
f0103882:	00 00                	add    %al,(%eax)
f0103884:	44                   	inc    %esp
f0103885:	00 30                	add    %dh,(%eax)
f0103887:	00 59 00             	add    %bl,0x0(%ecx)
f010388a:	00 00                	add    %al,(%eax)
f010388c:	3c 0c                	cmp    $0xc,%al
f010388e:	00 00                	add    %al,(%eax)
f0103890:	84 00                	test   %al,(%eax)
f0103892:	00 00                	add    %al,(%eax)
f0103894:	f6 05 10 f0 00 00 00 	testb  $0x0,0xf010
f010389b:	00 44 00 98          	add    %al,-0x68(%eax,%eax,1)
f010389f:	00 5c 00 00          	add    %bl,0x0(%eax,%eax,1)
f01038a3:	00 4b 0c             	add    %cl,0xc(%ebx)
f01038a6:	00 00                	add    %al,(%eax)
f01038a8:	84 00                	test   %al,(%eax)
f01038aa:	00 00                	add    %al,(%eax)
f01038ac:	fc                   	cld    
f01038ad:	05 10 f0 00 00       	add    $0xf010,%eax
f01038b2:	00 00                	add    %al,(%eax)
f01038b4:	44                   	inc    %esp
f01038b5:	00 62 00             	add    %ah,0x0(%edx)
f01038b8:	62 00                	bound  %eax,(%eax)
f01038ba:	00 00                	add    %al,(%eax)
f01038bc:	00 00                	add    %al,(%eax)
f01038be:	00 00                	add    %al,(%eax)
f01038c0:	44                   	inc    %esp
f01038c1:	00 30                	add    %dh,(%eax)
f01038c3:	00 6a 00             	add    %ch,0x0(%edx)
f01038c6:	00 00                	add    %al,(%eax)
f01038c8:	3c 0c                	cmp    $0xc,%al
f01038ca:	00 00                	add    %al,(%eax)
f01038cc:	84 00                	test   %al,(%eax)
f01038ce:	00 00                	add    %al,(%eax)
f01038d0:	07                   	pop    %es
f01038d1:	06                   	push   %es
f01038d2:	10 f0                	adc    %dh,%al
f01038d4:	00 00                	add    %al,(%eax)
f01038d6:	00 00                	add    %al,(%eax)
f01038d8:	44                   	inc    %esp
f01038d9:	00 9c 00 6d 00 00 00 	add    %bl,0x6d(%eax,%eax,1)
f01038e0:	00 00                	add    %al,(%eax)
f01038e2:	00 00                	add    %al,(%eax)
f01038e4:	44                   	inc    %esp
f01038e5:	00 9d 00 73 00 00    	add    %bl,0x7300(%ebp)
f01038eb:	00 4b 0c             	add    %cl,0xc(%ebx)
f01038ee:	00 00                	add    %al,(%eax)
f01038f0:	84 00                	test   %al,(%eax)
f01038f2:	00 00                	add    %al,(%eax)
f01038f4:	19 06                	sbb    %eax,(%esi)
f01038f6:	10 f0                	adc    %dh,%al
f01038f8:	00 00                	add    %al,(%eax)
f01038fa:	00 00                	add    %al,(%eax)
f01038fc:	44                   	inc    %esp
f01038fd:	00 62 00             	add    %ah,0x0(%edx)
f0103900:	7f 00                	jg     f0103902 <__STAB_BEGIN__+0x1222>
f0103902:	00 00                	add    %al,(%eax)
f0103904:	00 00                	add    %al,(%eax)
f0103906:	00 00                	add    %al,(%eax)
f0103908:	44                   	inc    %esp
f0103909:	00 30                	add    %dh,(%eax)
f010390b:	00 c1                	add    %al,%cl
f010390d:	00 00                	add    %al,(%eax)
f010390f:	00 3c 0c             	add    %bh,(%esp,%ecx,1)
f0103912:	00 00                	add    %al,(%eax)
f0103914:	84 00                	test   %al,(%eax)
f0103916:	00 00                	add    %al,(%eax)
f0103918:	5e                   	pop    %esi
f0103919:	06                   	push   %es
f010391a:	10 f0                	adc    %dh,%al
f010391c:	00 00                	add    %al,(%eax)
f010391e:	00 00                	add    %al,(%eax)
f0103920:	44                   	inc    %esp
f0103921:	00 63 00             	add    %ah,0x0(%ebx)
f0103924:	c4 00                	les    (%eax),%eax
f0103926:	00 00                	add    %al,(%eax)
f0103928:	4b                   	dec    %ebx
f0103929:	0c 00                	or     $0x0,%al
f010392b:	00 84 00 00 00 6c 06 	add    %al,0x66c0000(%eax,%eax,1)
f0103932:	10 f0                	adc    %dh,%al
f0103934:	00 00                	add    %al,(%eax)
f0103936:	00 00                	add    %al,(%eax)
f0103938:	44                   	inc    %esp
f0103939:	00 30                	add    %dh,(%eax)
f010393b:	00 d2                	add    %dl,%dl
f010393d:	00 00                	add    %al,(%eax)
f010393f:	00 3c 0c             	add    %bh,(%esp,%ecx,1)
f0103942:	00 00                	add    %al,(%eax)
f0103944:	84 00                	test   %al,(%eax)
f0103946:	00 00                	add    %al,(%eax)
f0103948:	72 06                	jb     f0103950 <__STAB_BEGIN__+0x1270>
f010394a:	10 f0                	adc    %dh,%al
f010394c:	00 00                	add    %al,(%eax)
f010394e:	00 00                	add    %al,(%eax)
f0103950:	44                   	inc    %esp
f0103951:	00 bc 01 d8 00 00 00 	add    %bh,0xd8(%ecx,%eax,1)
f0103958:	00 00                	add    %al,(%eax)
f010395a:	00 00                	add    %al,(%eax)
f010395c:	44                   	inc    %esp
f010395d:	00 bd 01 dc 00 00    	add    %bh,0xdc01(%ebp)
f0103963:	00 00                	add    %al,(%eax)
f0103965:	00 00                	add    %al,(%eax)
f0103967:	00 44 00 be          	add    %al,-0x42(%eax,%eax,1)
f010396b:	01 e8                	add    %ebp,%eax
f010396d:	00 00                	add    %al,(%eax)
f010396f:	00 7f 0d             	add    %bh,0xd(%edi)
f0103972:	00 00                	add    %al,(%eax)
f0103974:	40                   	inc    %eax
f0103975:	00 00                	add    %al,(%eax)
f0103977:	00 06                	add    %al,(%esi)
f0103979:	00 00                	add    %al,(%eax)
f010397b:	00 91 0d 00 00 40    	add    %dl,0x4000000d(%ecx)
f0103981:	00 00                	add    %al,(%eax)
f0103983:	00 02                	add    %al,(%edx)
f0103985:	00 00                	add    %al,(%eax)
f0103987:	00 9c 0d 00 00 40 00 	add    %bl,0x400000(%ebp,%ecx,1)
f010398e:	00 00                	add    %al,(%eax)
f0103990:	07                   	pop    %es
f0103991:	00 00                	add    %al,(%eax)
f0103993:	00 00                	add    %al,(%eax)
f0103995:	00 00                	add    %al,(%eax)
f0103997:	00 c0                	add    %al,%al
f0103999:	00 00                	add    %al,(%eax)
f010399b:	00 09                	add    %cl,(%ecx)
f010399d:	00 00                	add    %al,(%eax)
f010399f:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f01039a3:	00 40 00             	add    %al,0x0(%eax)
	...
f01039ae:	00 00                	add    %al,(%eax)
f01039b0:	c0 00 00             	rolb   $0x0,(%eax)
f01039b3:	00 59 00             	add    %bl,0x0(%ecx)
f01039b6:	00 00                	add    %al,(%eax)
f01039b8:	00 00                	add    %al,(%eax)
f01039ba:	00 00                	add    %al,(%eax)
f01039bc:	e0 00                	loopne f01039be <__STAB_BEGIN__+0x12de>
f01039be:	00 00                	add    %al,(%eax)
f01039c0:	5c                   	pop    %esp
f01039c1:	00 00                	add    %al,(%eax)
f01039c3:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f01039c7:	00 40 00             	add    %al,0x0(%eax)
	...
f01039d2:	00 00                	add    %al,(%eax)
f01039d4:	c0 00 00             	rolb   $0x0,(%eax)
f01039d7:	00 6a 00             	add    %ch,0x0(%edx)
f01039da:	00 00                	add    %al,(%eax)
f01039dc:	00 00                	add    %al,(%eax)
f01039de:	00 00                	add    %al,(%eax)
f01039e0:	e0 00                	loopne f01039e2 <__STAB_BEGIN__+0x1302>
f01039e2:	00 00                	add    %al,(%eax)
f01039e4:	6d                   	insl   (%dx),%es:(%edi)
f01039e5:	00 00                	add    %al,(%eax)
f01039e7:	00 00                	add    %al,(%eax)
f01039e9:	00 00                	add    %al,(%eax)
f01039eb:	00 e0                	add    %ah,%al
f01039ed:	00 00                	add    %al,(%eax)
f01039ef:	00 7f 00             	add    %bh,0x0(%edi)
f01039f2:	00 00                	add    %al,(%eax)
f01039f4:	74 0c                	je     f0103a02 <__STAB_BEGIN__+0x1322>
f01039f6:	00 00                	add    %al,(%eax)
f01039f8:	40                   	inc    %eax
	...
f0103a01:	00 00                	add    %al,(%eax)
f0103a03:	00 c0                	add    %al,%al
f0103a05:	00 00                	add    %al,(%eax)
f0103a07:	00 c1                	add    %al,%cl
f0103a09:	00 00                	add    %al,(%eax)
f0103a0b:	00 00                	add    %al,(%eax)
f0103a0d:	00 00                	add    %al,(%eax)
f0103a0f:	00 e0                	add    %ah,%al
f0103a11:	00 00                	add    %al,(%eax)
f0103a13:	00 c4                	add    %al,%ah
f0103a15:	00 00                	add    %al,(%eax)
f0103a17:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f0103a1b:	00 40 00             	add    %al,0x0(%eax)
	...
f0103a26:	00 00                	add    %al,(%eax)
f0103a28:	c0 00 00             	rolb   $0x0,(%eax)
f0103a2b:	00 d2                	add    %dl,%dl
f0103a2d:	00 00                	add    %al,(%eax)
f0103a2f:	00 00                	add    %al,(%eax)
f0103a31:	00 00                	add    %al,(%eax)
f0103a33:	00 e0                	add    %ah,%al
f0103a35:	00 00                	add    %al,(%eax)
f0103a37:	00 d5                	add    %dl,%ch
f0103a39:	00 00                	add    %al,(%eax)
f0103a3b:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f0103a3f:	00 40 00             	add    %al,0x0(%eax)
	...
f0103a4a:	00 00                	add    %al,(%eax)
f0103a4c:	c0 00 00             	rolb   $0x0,(%eax)
f0103a4f:	00 d5                	add    %dl,%ch
f0103a51:	00 00                	add    %al,(%eax)
f0103a53:	00 00                	add    %al,(%eax)
f0103a55:	00 00                	add    %al,(%eax)
f0103a57:	00 e0                	add    %ah,%al
f0103a59:	00 00                	add    %al,(%eax)
f0103a5b:	00 d8                	add    %bl,%al
f0103a5d:	00 00                	add    %al,(%eax)
f0103a5f:	00 a7 0d 00 00 24    	add    %ah,0x2400000d(%edi)
f0103a65:	00 00                	add    %al,(%eax)
f0103a67:	00 8a 06 10 f0 00    	add    %cl,0xf01006(%edx)
f0103a6d:	00 00                	add    %al,(%eax)
f0103a6f:	00 44 00 3d          	add    %al,0x3d(%eax,%eax,1)
f0103a73:	01 00                	add    %eax,(%eax)
f0103a75:	00 00                	add    %al,(%eax)
f0103a77:	00 4b 0c             	add    %cl,0xc(%ebx)
f0103a7a:	00 00                	add    %al,(%eax)
f0103a7c:	84 00                	test   %al,(%eax)
f0103a7e:	00 00                	add    %al,(%eax)
f0103a80:	91                   	xchg   %eax,%ecx
f0103a81:	06                   	push   %es
f0103a82:	10 f0                	adc    %dh,%al
f0103a84:	00 00                	add    %al,(%eax)
f0103a86:	00 00                	add    %al,(%eax)
f0103a88:	44                   	inc    %esp
f0103a89:	00 30                	add    %dh,(%eax)
f0103a8b:	00 07                	add    %al,(%edi)
f0103a8d:	00 00                	add    %al,(%eax)
f0103a8f:	00 3c 0c             	add    %bh,(%esp,%ecx,1)
f0103a92:	00 00                	add    %al,(%eax)
f0103a94:	84 00                	test   %al,(%eax)
f0103a96:	00 00                	add    %al,(%eax)
f0103a98:	97                   	xchg   %eax,%edi
f0103a99:	06                   	push   %es
f0103a9a:	10 f0                	adc    %dh,%al
f0103a9c:	00 00                	add    %al,(%eax)
f0103a9e:	00 00                	add    %al,(%eax)
f0103aa0:	44                   	inc    %esp
f0103aa1:	00 42 01             	add    %al,0x1(%edx)
f0103aa4:	0d 00 00 00 4b       	or     $0x4b000000,%eax
f0103aa9:	0c 00                	or     $0x0,%al
f0103aab:	00 84 00 00 00 a4 06 	add    %al,0x6a40000(%eax,%eax,1)
f0103ab2:	10 f0                	adc    %dh,%al
f0103ab4:	00 00                	add    %al,(%eax)
f0103ab6:	00 00                	add    %al,(%eax)
f0103ab8:	44                   	inc    %esp
f0103ab9:	00 30                	add    %dh,(%eax)
f0103abb:	00 1a                	add    %bl,(%edx)
f0103abd:	00 00                	add    %al,(%eax)
f0103abf:	00 3c 0c             	add    %bh,(%esp,%ecx,1)
f0103ac2:	00 00                	add    %al,(%eax)
f0103ac4:	84 00                	test   %al,(%eax)
f0103ac6:	00 00                	add    %al,(%eax)
f0103ac8:	a7                   	cmpsl  %es:(%edi),%ds:(%esi)
f0103ac9:	06                   	push   %es
f0103aca:	10 f0                	adc    %dh,%al
f0103acc:	00 00                	add    %al,(%eax)
f0103ace:	00 00                	add    %al,(%eax)
f0103ad0:	44                   	inc    %esp
f0103ad1:	00 47 01             	add    %al,0x1(%edi)
f0103ad4:	1d 00 00 00 00       	sbb    $0x0,%eax
f0103ad9:	00 00                	add    %al,(%eax)
f0103adb:	00 44 00 49          	add    %al,0x49(%eax,%eax,1)
f0103adf:	01 21                	add    %esp,(%ecx)
f0103ae1:	00 00                	add    %al,(%eax)
f0103ae3:	00 00                	add    %al,(%eax)
f0103ae5:	00 00                	add    %al,(%eax)
f0103ae7:	00 44 00 4a          	add    %al,0x4a(%eax,%eax,1)
f0103aeb:	01 2d 00 00 00 00    	add    %ebp,0x0
f0103af1:	00 00                	add    %al,(%eax)
f0103af3:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
f0103af7:	01 32                	add    %esi,(%edx)
f0103af9:	00 00                	add    %al,(%eax)
f0103afb:	00 00                	add    %al,(%eax)
f0103afd:	00 00                	add    %al,(%eax)
f0103aff:	00 44 00 4d          	add    %al,0x4d(%eax,%eax,1)
f0103b03:	01 36                	add    %esi,(%esi)
f0103b05:	00 00                	add    %al,(%eax)
f0103b07:	00 00                	add    %al,(%eax)
f0103b09:	00 00                	add    %al,(%eax)
f0103b0b:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
f0103b0f:	01 44 00 00          	add    %eax,0x0(%eax,%eax,1)
f0103b13:	00 00                	add    %al,(%eax)
f0103b15:	00 00                	add    %al,(%eax)
f0103b17:	00 44 00 4f          	add    %al,0x4f(%eax,%eax,1)
f0103b1b:	01 63 00             	add    %esp,0x0(%ebx)
f0103b1e:	00 00                	add    %al,(%eax)
f0103b20:	00 00                	add    %al,(%eax)
f0103b22:	00 00                	add    %al,(%eax)
f0103b24:	44                   	inc    %esp
f0103b25:	00 50 01             	add    %dl,0x1(%eax)
f0103b28:	68 00 00 00 00       	push   $0x0
f0103b2d:	00 00                	add    %al,(%eax)
f0103b2f:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
f0103b33:	01 73 00             	add    %esi,0x0(%ebx)
f0103b36:	00 00                	add    %al,(%eax)
f0103b38:	00 00                	add    %al,(%eax)
f0103b3a:	00 00                	add    %al,(%eax)
f0103b3c:	44                   	inc    %esp
f0103b3d:	00 53 01             	add    %dl,0x1(%ebx)
f0103b40:	76 00                	jbe    f0103b42 <__STAB_BEGIN__+0x1462>
f0103b42:	00 00                	add    %al,(%eax)
f0103b44:	00 00                	add    %al,(%eax)
f0103b46:	00 00                	add    %al,(%eax)
f0103b48:	44                   	inc    %esp
f0103b49:	00 56 01             	add    %dl,0x1(%esi)
f0103b4c:	7f 00                	jg     f0103b4e <__STAB_BEGIN__+0x146e>
f0103b4e:	00 00                	add    %al,(%eax)
f0103b50:	00 00                	add    %al,(%eax)
f0103b52:	00 00                	add    %al,(%eax)
f0103b54:	44                   	inc    %esp
f0103b55:	00 57 01             	add    %dl,0x1(%edi)
f0103b58:	82                   	(bad)  
f0103b59:	00 00                	add    %al,(%eax)
f0103b5b:	00 00                	add    %al,(%eax)
f0103b5d:	00 00                	add    %al,(%eax)
f0103b5f:	00 44 00 59          	add    %al,0x59(%eax,%eax,1)
f0103b63:	01 9e 00 00 00 00    	add    %ebx,0x0(%esi)
f0103b69:	00 00                	add    %al,(%eax)
f0103b6b:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
f0103b6f:	01 ae 00 00 00 00    	add    %ebp,0x0(%esi)
f0103b75:	00 00                	add    %al,(%eax)
f0103b77:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
f0103b7b:	01 b3 00 00 00 00    	add    %esi,0x0(%ebx)
f0103b81:	00 00                	add    %al,(%eax)
f0103b83:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
f0103b87:	01 bd 00 00 00 00    	add    %edi,0x0(%ebp)
f0103b8d:	00 00                	add    %al,(%eax)
f0103b8f:	00 44 00 5d          	add    %al,0x5d(%eax,%eax,1)
f0103b93:	01 c2                	add    %eax,%edx
f0103b95:	00 00                	add    %al,(%eax)
f0103b97:	00 00                	add    %al,(%eax)
f0103b99:	00 00                	add    %al,(%eax)
f0103b9b:	00 44 00 5e          	add    %al,0x5e(%eax,%eax,1)
f0103b9f:	01 ca                	add    %ecx,%edx
f0103ba1:	00 00                	add    %al,(%eax)
f0103ba3:	00 00                	add    %al,(%eax)
f0103ba5:	00 00                	add    %al,(%eax)
f0103ba7:	00 44 00 63          	add    %al,0x63(%eax,%eax,1)
f0103bab:	01 cd                	add    %ecx,%ebp
f0103bad:	00 00                	add    %al,(%eax)
f0103baf:	00 00                	add    %al,(%eax)
f0103bb1:	00 00                	add    %al,(%eax)
f0103bb3:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
f0103bb7:	01 dc                	add    %ebx,%esp
f0103bb9:	00 00                	add    %al,(%eax)
f0103bbb:	00 4b 0c             	add    %cl,0xc(%ebx)
f0103bbe:	00 00                	add    %al,(%eax)
f0103bc0:	84 00                	test   %al,(%eax)
f0103bc2:	00 00                	add    %al,(%eax)
f0103bc4:	72 07                	jb     f0103bcd <__STAB_BEGIN__+0x14ed>
f0103bc6:	10 f0                	adc    %dh,%al
f0103bc8:	00 00                	add    %al,(%eax)
f0103bca:	00 00                	add    %al,(%eax)
f0103bcc:	44                   	inc    %esp
f0103bcd:	00 62 00             	add    %ah,0x0(%edx)
f0103bd0:	e8 00 00 00 3c       	call   2c103bd5 <_start+0x2c003bc9>
f0103bd5:	0c 00                	or     $0x0,%al
f0103bd7:	00 84 00 00 00 7d 07 	add    %al,0x77d0000(%eax,%eax,1)
f0103bde:	10 f0                	adc    %dh,%al
f0103be0:	00 00                	add    %al,(%eax)
f0103be2:	00 00                	add    %al,(%eax)
f0103be4:	44                   	inc    %esp
f0103be5:	00 69 01             	add    %ch,0x1(%ecx)
f0103be8:	f3 00 00             	repz add %al,(%eax)
f0103beb:	00 c6                	add    %al,%dh
f0103bed:	0c 00                	or     $0x0,%al
f0103bef:	00 40 00             	add    %al,0x0(%eax)
f0103bf2:	00 00                	add    %al,(%eax)
f0103bf4:	03 00                	add    (%eax),%eax
f0103bf6:	00 00                	add    %al,(%eax)
f0103bf8:	74 0c                	je     f0103c06 <__STAB_BEGIN__+0x1526>
f0103bfa:	00 00                	add    %al,(%eax)
f0103bfc:	40                   	inc    %eax
f0103bfd:	00 00                	add    %al,(%eax)
f0103bff:	00 00                	add    %al,(%eax)
f0103c01:	00 00                	add    %al,(%eax)
f0103c03:	00 bc 0d 00 00 28 00 	add    %bh,0x280000(%ebp,%ecx,1)
f0103c0a:	00 00                	add    %al,(%eax)
f0103c0c:	20 33                	and    %dh,(%ebx)
f0103c0e:	11 f0                	adc    %esi,%eax
f0103c10:	00 00                	add    %al,(%eax)
f0103c12:	00 00                	add    %al,(%eax)
f0103c14:	c0 00 00             	rolb   $0x0,(%eax)
f0103c17:	00 00                	add    %al,(%eax)
f0103c19:	00 00                	add    %al,(%eax)
f0103c1b:	00 74 0c 00          	add    %dh,0x0(%esp,%ecx,1)
f0103c1f:	00 40 00             	add    %al,0x0(%eax)
	...
f0103c2a:	00 00                	add    %al,(%eax)
f0103c2c:	c0 00 00             	rolb   $0x0,(%eax)
f0103c2f:	00 07                	add    %al,(%edi)
f0103c31:	00 00                	add    %al,(%eax)
f0103c33:	00 00                	add    %al,(%eax)
f0103c35:	00 00                	add    %al,(%eax)
f0103c37:	00 e0                	add    %ah,%al
f0103c39:	00 00                	add    %al,(%eax)
f0103c3b:	00 0d 00 00 00 00    	add    %cl,0x0
f0103c41:	00 00                	add    %al,(%eax)
f0103c43:	00 e0                	add    %ah,%al
f0103c45:	00 00                	add    %al,(%eax)
f0103c47:	00 fb                	add    %bh,%bl
f0103c49:	00 00                	add    %al,(%eax)
f0103c4b:	00 c9                	add    %cl,%cl
f0103c4d:	0d 00 00 28 00       	or     $0x280000,%eax
f0103c52:	00 00                	add    %al,(%eax)
f0103c54:	24 33                	and    $0x33,%al
f0103c56:	11 f0                	adc    %esi,%eax
f0103c58:	de 0d 00 00 28 00    	fimul  0x280000
f0103c5e:	00 00                	add    %al,(%eax)
f0103c60:	28 33                	sub    %dh,(%ebx)
f0103c62:	11 f0                	adc    %esi,%eax
f0103c64:	ef                   	out    %eax,(%dx)
f0103c65:	0d 00 00 28 00       	or     $0x280000,%eax
f0103c6a:	00 00                	add    %al,(%eax)
f0103c6c:	2c 33                	sub    $0x33,%al
f0103c6e:	11 f0                	adc    %esi,%eax
f0103c70:	06                   	push   %es
f0103c71:	0e                   	push   %cs
f0103c72:	00 00                	add    %al,(%eax)
f0103c74:	28 00                	sub    %al,(%eax)
f0103c76:	00 00                	add    %al,(%eax)
f0103c78:	30 33                	xor    %dh,(%ebx)
f0103c7a:	11 f0                	adc    %esi,%eax
f0103c7c:	15 0e 00 00 26       	adc    $0x2600000e,%eax
f0103c81:	00 00                	add    %al,(%eax)
f0103c83:	00 e0                	add    %ah,%al
f0103c85:	1f                   	pop    %ds
f0103c86:	10 f0                	adc    %dh,%al
f0103c88:	4a                   	dec    %edx
f0103c89:	0e                   	push   %cs
f0103c8a:	00 00                	add    %al,(%eax)
f0103c8c:	26 00 00             	add    %al,%es:(%eax)
f0103c8f:	00 e0                	add    %ah,%al
f0103c91:	20 10                	and    %dl,(%eax)
f0103c93:	f0 5d                	lock pop %ebp
f0103c95:	0e                   	push   %cs
f0103c96:	00 00                	add    %al,(%eax)
f0103c98:	26 00 00             	add    %al,%es:(%eax)
f0103c9b:	00 00                	add    %al,(%eax)
f0103c9d:	30 11                	xor    %dl,(%ecx)
f0103c9f:	f0 6f                	lock outsl %ds:(%esi),(%dx)
f0103ca1:	0e                   	push   %cs
f0103ca2:	00 00                	add    %al,(%eax)
f0103ca4:	26 00 00             	add    %al,%es:(%eax)
f0103ca7:	00 00                	add    %al,(%eax)
f0103ca9:	31 11                	xor    %edx,(%ecx)
f0103cab:	f0 80 0e 00          	lock orb $0x0,(%esi)
f0103caf:	00 26                	add    %ah,(%esi)
f0103cb1:	00 00                	add    %al,(%eax)
f0103cb3:	00 00                	add    %al,(%eax)
f0103cb5:	32 11                	xor    (%ecx),%dl
f0103cb7:	f0 8f                	lock (bad) 
f0103cb9:	0e                   	push   %cs
f0103cba:	00 00                	add    %al,(%eax)
f0103cbc:	26 00 00             	add    %al,%es:(%eax)
f0103cbf:	00 e0                	add    %ah,%al
f0103cc1:	21 10                	and    %edx,(%eax)
f0103cc3:	f0 bb 0e 00 00 28    	lock mov $0x2800000e,%ebx
f0103cc9:	00 00                	add    %al,(%eax)
f0103ccb:	00 40 33             	add    %al,0x33(%eax)
f0103cce:	11 f0                	adc    %esi,%eax
f0103cd0:	00 00                	add    %al,(%eax)
f0103cd2:	00 00                	add    %al,(%eax)
f0103cd4:	64 00 00             	add    %al,%fs:(%eax)
f0103cd7:	00 85 07 10 f0 1b    	add    %al,0x1bf01007(%ebp)
f0103cdd:	0f 00 00             	sldt   (%eax)
f0103ce0:	64 00 02             	add    %al,%fs:(%edx)
f0103ce3:	00 90 07 10 f0 31    	add    %dl,0x31f01007(%eax)
f0103ce9:	00 00                	add    %al,(%eax)
f0103ceb:	00 3c 00             	add    %bh,(%eax,%eax,1)
f0103cee:	00 00                	add    %al,(%eax)
f0103cf0:	00 00                	add    %al,(%eax)
f0103cf2:	00 00                	add    %al,(%eax)
f0103cf4:	40                   	inc    %eax
f0103cf5:	00 00                	add    %al,(%eax)
f0103cf7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0103cfd:	00 00                	add    %al,(%eax)
f0103cff:	00 6a 00             	add    %ch,0x0(%edx)
f0103d02:	00 00                	add    %al,(%eax)
f0103d04:	80 00 00             	addb   $0x0,(%eax)
f0103d07:	00 00                	add    %al,(%eax)
f0103d09:	00 00                	add    %al,(%eax)
f0103d0b:	00 84 00 00 00 80 00 	add    %al,0x800000(%eax,%eax,1)
f0103d12:	00 00                	add    %al,(%eax)
f0103d14:	00 00                	add    %al,(%eax)
f0103d16:	00 00                	add    %al,(%eax)
f0103d18:	b3 00                	mov    $0x0,%bl
f0103d1a:	00 00                	add    %al,(%eax)
f0103d1c:	80 00 00             	addb   $0x0,(%eax)
f0103d1f:	00 00                	add    %al,(%eax)
f0103d21:	00 00                	add    %al,(%eax)
f0103d23:	00 dc                	add    %bl,%ah
f0103d25:	00 00                	add    %al,(%eax)
f0103d27:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0103d2d:	00 00                	add    %al,(%eax)
f0103d2f:	00 0a                	add    %cl,(%edx)
f0103d31:	01 00                	add    %eax,(%eax)
f0103d33:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0103d39:	00 00                	add    %al,(%eax)
f0103d3b:	00 35 01 00 00 80    	add    %dh,0x80000001
f0103d41:	00 00                	add    %al,(%eax)
f0103d43:	00 00                	add    %al,(%eax)
f0103d45:	00 00                	add    %al,(%eax)
f0103d47:	00 60 01             	add    %ah,0x1(%eax)
f0103d4a:	00 00                	add    %al,(%eax)
f0103d4c:	80 00 00             	addb   $0x0,(%eax)
f0103d4f:	00 00                	add    %al,(%eax)
f0103d51:	00 00                	add    %al,(%eax)
f0103d53:	00 86 01 00 00 80    	add    %al,-0x7fffffff(%esi)
f0103d59:	00 00                	add    %al,(%eax)
f0103d5b:	00 00                	add    %al,(%eax)
f0103d5d:	00 00                	add    %al,(%eax)
f0103d5f:	00 b0 01 00 00 80    	add    %dh,-0x7fffffff(%eax)
f0103d65:	00 00                	add    %al,(%eax)
f0103d67:	00 00                	add    %al,(%eax)
f0103d69:	00 00                	add    %al,(%eax)
f0103d6b:	00 d6                	add    %dl,%dh
f0103d6d:	01 00                	add    %eax,(%eax)
f0103d6f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0103d75:	00 00                	add    %al,(%eax)
f0103d77:	00 fb                	add    %bh,%bl
f0103d79:	01 00                	add    %eax,(%eax)
f0103d7b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0103d81:	00 00                	add    %al,(%eax)
f0103d83:	00 15 02 00 00 80    	add    %dl,0x80000002
f0103d89:	00 00                	add    %al,(%eax)
f0103d8b:	00 00                	add    %al,(%eax)
f0103d8d:	00 00                	add    %al,(%eax)
f0103d8f:	00 30                	add    %dh,(%eax)
f0103d91:	02 00                	add    (%eax),%al
f0103d93:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0103d99:	00 00                	add    %al,(%eax)
f0103d9b:	00 51 02             	add    %dl,0x2(%ecx)
f0103d9e:	00 00                	add    %al,(%eax)
f0103da0:	80 00 00             	addb   $0x0,(%eax)
f0103da3:	00 00                	add    %al,(%eax)
f0103da5:	00 00                	add    %al,(%eax)
f0103da7:	00 70 02             	add    %dh,0x2(%eax)
f0103daa:	00 00                	add    %al,(%eax)
f0103dac:	80 00 00             	addb   $0x0,(%eax)
f0103daf:	00 00                	add    %al,(%eax)
f0103db1:	00 00                	add    %al,(%eax)
f0103db3:	00 8f 02 00 00 80    	add    %cl,-0x7ffffffe(%edi)
f0103db9:	00 00                	add    %al,(%eax)
f0103dbb:	00 00                	add    %al,(%eax)
f0103dbd:	00 00                	add    %al,(%eax)
f0103dbf:	00 b0 02 00 00 80    	add    %dh,-0x7ffffffe(%eax)
f0103dc5:	00 00                	add    %al,(%eax)
f0103dc7:	00 00                	add    %al,(%eax)
f0103dc9:	00 00                	add    %al,(%eax)
f0103dcb:	00 e3                	add    %ah,%bl
f0103dcd:	0a 00                	or     (%eax),%al
f0103dcf:	00 c2                	add    %al,%dl
f0103dd1:	00 00                	add    %al,(%eax)
f0103dd3:	00 00                	add    %al,(%eax)
f0103dd5:	00 00                	add    %al,(%eax)
f0103dd7:	00 f1                	add    %dh,%cl
f0103dd9:	0a 00                	or     (%eax),%al
f0103ddb:	00 c2                	add    %al,%dl
f0103ddd:	00 00                	add    %al,(%eax)
f0103ddf:	00 50 06             	add    %dl,0x6(%eax)
f0103de2:	00 00                	add    %al,(%eax)
f0103de4:	1c 0b                	sbb    $0xb,%al
f0103de6:	00 00                	add    %al,(%eax)
f0103de8:	c2 00 00             	ret    $0x0
f0103deb:	00 00                	add    %al,(%eax)
f0103ded:	00 00                	add    %al,(%eax)
f0103def:	00 d0                	add    %dl,%al
f0103df1:	02 00                	add    (%eax),%al
f0103df3:	00 c2                	add    %al,%dl
f0103df5:	00 00                	add    %al,(%eax)
f0103df7:	00 37                	add    %dh,(%edi)
f0103df9:	53                   	push   %ebx
f0103dfa:	00 00                	add    %al,(%eax)
f0103dfc:	7b 09                	jnp    f0103e07 <__STAB_BEGIN__+0x1727>
f0103dfe:	00 00                	add    %al,(%eax)
f0103e00:	c2 00 00             	ret    $0x0
f0103e03:	00 40 3b             	add    %al,0x3b(%eax)
f0103e06:	00 00                	add    %al,(%eax)
f0103e08:	c4 02                	les    (%edx),%eax
f0103e0a:	00 00                	add    %al,(%eax)
f0103e0c:	c2 00 00             	ret    $0x0
f0103e0f:	00 16                	add    %dl,(%esi)
f0103e11:	59                   	pop    %ecx
f0103e12:	01 00                	add    %eax,(%eax)
f0103e14:	2a 0f                	sub    (%edi),%cl
f0103e16:	00 00                	add    %al,(%eax)
f0103e18:	82                   	(bad)  
f0103e19:	00 00                	add    %al,(%eax)
f0103e1b:	00 0d 30 00 00 3a    	add    %cl,0x3a000030
f0103e21:	0f 00 00             	sldt   (%eax)
f0103e24:	80 00 00             	addb   $0x0,(%eax)
	...
f0103e2f:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
f0103e35:	00 00                	add    %al,(%eax)
f0103e37:	00 e9                	add    %ch,%cl
f0103e39:	0f 00 00             	sldt   (%eax)
f0103e3c:	80 00 00             	addb   $0x0,(%eax)
f0103e3f:	00 00                	add    %al,(%eax)
f0103e41:	00 00                	add    %al,(%eax)
f0103e43:	00 40 10             	add    %al,0x10(%eax)
f0103e46:	00 00                	add    %al,(%eax)
f0103e48:	24 00                	and    $0x0,%al
f0103e4a:	00 00                	add    %al,(%eax)
f0103e4c:	90                   	nop
f0103e4d:	07                   	pop    %es
f0103e4e:	10 f0                	adc    %dh,%al
f0103e50:	50                   	push   %eax
f0103e51:	10 00                	adc    %al,(%eax)
f0103e53:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
f0103e59:	00 00                	add    %al,(%eax)
f0103e5b:	00 00                	add    %al,(%eax)
f0103e5d:	00 00                	add    %al,(%eax)
f0103e5f:	00 44 00 4a          	add    %al,0x4a(%eax,%eax,1)
	...
f0103e6b:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
f0103e6f:	00 06                	add    %al,(%esi)
f0103e71:	00 00                	add    %al,(%eax)
f0103e73:	00 00                	add    %al,(%eax)
f0103e75:	00 00                	add    %al,(%eax)
f0103e77:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
f0103e7b:	00 09                	add    %cl,(%ecx)
f0103e7d:	00 00                	add    %al,(%eax)
f0103e7f:	00 00                	add    %al,(%eax)
f0103e81:	00 00                	add    %al,(%eax)
f0103e83:	00 44 00 4f          	add    %al,0x4f(%eax,%eax,1)
f0103e87:	00 0d 00 00 00 00    	add    %cl,0x0
f0103e8d:	00 00                	add    %al,(%eax)
f0103e8f:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
f0103e93:	00 13                	add    %dl,(%ebx)
f0103e95:	00 00                	add    %al,(%eax)
f0103e97:	00 5b 10             	add    %bl,0x10(%ebx)
f0103e9a:	00 00                	add    %al,(%eax)
f0103e9c:	40                   	inc    %eax
f0103e9d:	00 00                	add    %al,(%eax)
f0103e9f:	00 00                	add    %al,(%eax)
f0103ea1:	00 00                	add    %al,(%eax)
f0103ea3:	00 66 10             	add    %ah,0x10(%esi)
f0103ea6:	00 00                	add    %al,(%eax)
f0103ea8:	40                   	inc    %eax
f0103ea9:	00 00                	add    %al,(%eax)
f0103eab:	00 02                	add    %al,(%edx)
f0103ead:	00 00                	add    %al,(%eax)
f0103eaf:	00 00                	add    %al,(%eax)
f0103eb1:	00 00                	add    %al,(%eax)
f0103eb3:	00 c0                	add    %al,%al
f0103eb5:	00 00                	add    %al,(%eax)
f0103eb7:	00 06                	add    %al,(%esi)
f0103eb9:	00 00                	add    %al,(%eax)
f0103ebb:	00 00                	add    %al,(%eax)
f0103ebd:	00 00                	add    %al,(%eax)
f0103ebf:	00 e0                	add    %ah,%al
f0103ec1:	00 00                	add    %al,(%eax)
f0103ec3:	00 09                	add    %cl,(%ecx)
f0103ec5:	00 00                	add    %al,(%eax)
f0103ec7:	00 76 10             	add    %dh,0x10(%esi)
f0103eca:	00 00                	add    %al,(%eax)
f0103ecc:	24 00                	and    $0x0,%al
f0103ece:	00 00                	add    %al,(%eax)
f0103ed0:	a5                   	movsl  %ds:(%esi),%es:(%edi)
f0103ed1:	07                   	pop    %es
f0103ed2:	10 f0                	adc    %dh,%al
f0103ed4:	00 00                	add    %al,(%eax)
f0103ed6:	00 00                	add    %al,(%eax)
f0103ed8:	44                   	inc    %esp
f0103ed9:	00 54 00 00          	add    %dl,0x0(%eax,%eax,1)
f0103edd:	00 00                	add    %al,(%eax)
f0103edf:	00 00                	add    %al,(%eax)
f0103ee1:	00 00                	add    %al,(%eax)
f0103ee3:	00 44 00 5f          	add    %al,0x5f(%eax,%eax,1)
f0103ee7:	00 0a                	add    %cl,(%edx)
f0103ee9:	00 00                	add    %al,(%eax)
f0103eeb:	00 00                	add    %al,(%eax)
f0103eed:	00 00                	add    %al,(%eax)
f0103eef:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
f0103ef3:	00 1c 00             	add    %bl,(%eax,%eax,1)
f0103ef6:	00 00                	add    %al,(%eax)
f0103ef8:	00 00                	add    %al,(%eax)
f0103efa:	00 00                	add    %al,(%eax)
f0103efc:	44                   	inc    %esp
f0103efd:	00 66 00             	add    %ah,0x0(%esi)
f0103f00:	22 00                	and    (%eax),%al
f0103f02:	00 00                	add    %al,(%eax)
f0103f04:	00 00                	add    %al,(%eax)
f0103f06:	00 00                	add    %al,(%eax)
f0103f08:	44                   	inc    %esp
f0103f09:	00 67 00             	add    %ah,0x0(%edi)
f0103f0c:	29 00                	sub    %eax,(%eax)
f0103f0e:	00 00                	add    %al,(%eax)
f0103f10:	00 00                	add    %al,(%eax)
f0103f12:	00 00                	add    %al,(%eax)
f0103f14:	44                   	inc    %esp
f0103f15:	00 68 00             	add    %ch,0x0(%eax)
f0103f18:	30 00                	xor    %al,(%eax)
f0103f1a:	00 00                	add    %al,(%eax)
f0103f1c:	00 00                	add    %al,(%eax)
f0103f1e:	00 00                	add    %al,(%eax)
f0103f20:	44                   	inc    %esp
f0103f21:	00 69 00             	add    %ch,0x0(%ecx)
f0103f24:	37                   	aaa    
f0103f25:	00 00                	add    %al,(%eax)
f0103f27:	00 00                	add    %al,(%eax)
f0103f29:	00 00                	add    %al,(%eax)
f0103f2b:	00 44 00 6a          	add    %al,0x6a(%eax,%eax,1)
f0103f2f:	00 3e                	add    %bh,(%esi)
f0103f31:	00 00                	add    %al,(%eax)
f0103f33:	00 00                	add    %al,(%eax)
f0103f35:	00 00                	add    %al,(%eax)
f0103f37:	00 44 00 6b          	add    %al,0x6b(%eax,%eax,1)
f0103f3b:	00 45 00             	add    %al,0x0(%ebp)
f0103f3e:	00 00                	add    %al,(%eax)
f0103f40:	00 00                	add    %al,(%eax)
f0103f42:	00 00                	add    %al,(%eax)
f0103f44:	44                   	inc    %esp
f0103f45:	00 6c 00 4c          	add    %ch,0x4c(%eax,%eax,1)
f0103f49:	00 00                	add    %al,(%eax)
f0103f4b:	00 00                	add    %al,(%eax)
f0103f4d:	00 00                	add    %al,(%eax)
f0103f4f:	00 44 00 6e          	add    %al,0x6e(%eax,%eax,1)
f0103f53:	00 54 00 00          	add    %dl,0x0(%eax,%eax,1)
f0103f57:	00 8d 10 00 00 80    	add    %cl,-0x7ffffff0(%ebp)
f0103f5d:	00 00                	add    %al,(%eax)
f0103f5f:	00 fc                	add    %bh,%ah
f0103f61:	fe                   	(bad)  
f0103f62:	ff                   	(bad)  
f0103f63:	ff                   	(bad)  
f0103f64:	bb 10 00 00 40       	mov    $0x40000010,%ebx
	...
f0103f71:	00 00                	add    %al,(%eax)
f0103f73:	00 c0                	add    %al,%al
	...
f0103f7d:	00 00                	add    %al,(%eax)
f0103f7f:	00 e0                	add    %ah,%al
f0103f81:	00 00                	add    %al,(%eax)
f0103f83:	00 5d 00             	add    %bl,0x0(%ebp)
f0103f86:	00 00                	add    %al,(%eax)
f0103f88:	ce                   	into   
f0103f89:	10 00                	adc    %al,(%eax)
f0103f8b:	00 24 00             	add    %ah,(%eax,%eax,1)
f0103f8e:	00 00                	add    %al,(%eax)
f0103f90:	02 08                	add    (%eax),%cl
f0103f92:	10 f0                	adc    %dh,%al
f0103f94:	00 00                	add    %al,(%eax)
f0103f96:	00 00                	add    %al,(%eax)
f0103f98:	44                   	inc    %esp
f0103f99:	00 72 00             	add    %dh,0x0(%edx)
	...
f0103fa4:	44                   	inc    %esp
f0103fa5:	00 73 00             	add    %dh,0x0(%ebx)
f0103fa8:	03 00                	add    (%eax),%eax
f0103faa:	00 00                	add    %al,(%eax)
f0103fac:	00 00                	add    %al,(%eax)
f0103fae:	00 00                	add    %al,(%eax)
f0103fb0:	44                   	inc    %esp
f0103fb1:	00 74 00 08          	add    %dh,0x8(%eax,%eax,1)
f0103fb5:	00 00                	add    %al,(%eax)
f0103fb7:	00 e2                	add    %ah,%dl
f0103fb9:	10 00                	adc    %al,(%eax)
f0103fbb:	00 24 00             	add    %ah,(%eax,%eax,1)
f0103fbe:	00 00                	add    %al,(%eax)
f0103fc0:	0c 08                	or     $0x8,%al
f0103fc2:	10 f0                	adc    %dh,%al
f0103fc4:	00 00                	add    %al,(%eax)
f0103fc6:	00 00                	add    %al,(%eax)
f0103fc8:	44                   	inc    %esp
f0103fc9:	00 d0                	add    %dl,%al
	...
f0103fd3:	00 44 00 d2          	add    %al,-0x2e(%eax,%eax,1)
f0103fd7:	00 03                	add    %al,(%ebx)
f0103fd9:	00 00                	add    %al,(%eax)
f0103fdb:	00 00                	add    %al,(%eax)
f0103fdd:	00 00                	add    %al,(%eax)
f0103fdf:	00 44 00 d4          	add    %al,-0x2c(%eax,%eax,1)
f0103fe3:	00 06                	add    %al,(%esi)
f0103fe5:	00 00                	add    %al,(%eax)
f0103fe7:	00 f2                	add    %dh,%dl
f0103fe9:	10 00                	adc    %al,(%eax)
f0103feb:	00 40 00             	add    %al,0x0(%eax)
	...
f0103ff6:	00 00                	add    %al,(%eax)
f0103ff8:	c0 00 00             	rolb   $0x0,(%eax)
	...
f0104003:	00 e0                	add    %ah,%al
f0104005:	00 00                	add    %al,(%eax)
f0104007:	00 08                	add    %cl,(%eax)
f0104009:	00 00                	add    %al,(%eax)
f010400b:	00 02                	add    %al,(%edx)
f010400d:	11 00                	adc    %eax,(%eax)
f010400f:	00 24 00             	add    %ah,(%eax,%eax,1)
f0104012:	00 00                	add    %al,(%eax)
f0104014:	14 08                	adc    $0x8,%al
f0104016:	10 f0                	adc    %dh,%al
f0104018:	00 00                	add    %al,(%eax)
f010401a:	00 00                	add    %al,(%eax)
f010401c:	44                   	inc    %esp
f010401d:	00 46 00             	add    %al,0x0(%esi)
	...
f0104028:	44                   	inc    %esp
f0104029:	00 47 00             	add    %al,0x0(%edi)
f010402c:	06                   	push   %es
f010402d:	00 00                	add    %al,(%eax)
f010402f:	00 00                	add    %al,(%eax)
f0104031:	00 00                	add    %al,(%eax)
f0104033:	00 44 00 48          	add    %al,0x48(%eax,%eax,1)
f0104037:	00 12                	add    %dl,(%edx)
f0104039:	00 00                	add    %al,(%eax)
f010403b:	00 16                	add    %dl,(%esi)
f010403d:	11 00                	adc    %eax,(%eax)
f010403f:	00 24 00             	add    %ah,(%eax,%eax,1)
f0104042:	00 00                	add    %al,(%eax)
f0104044:	28 08                	sub    %cl,(%eax)
f0104046:	10 f0                	adc    %dh,%al
f0104048:	2a 11                	sub    (%ecx),%dl
f010404a:	00 00                	add    %al,(%eax)
f010404c:	a0 00 00 00 08       	mov    0x8000000,%al
f0104051:	00 00                	add    %al,(%eax)
f0104053:	00 36                	add    %dh,(%esi)
f0104055:	11 00                	adc    %eax,(%eax)
f0104057:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
f010405d:	00 00                	add    %al,(%eax)
f010405f:	00 4a 11             	add    %cl,0x11(%edx)
f0104062:	00 00                	add    %al,(%eax)
f0104064:	a0 00 00 00 10       	mov    0x10000000,%al
f0104069:	00 00                	add    %al,(%eax)
f010406b:	00 00                	add    %al,(%eax)
f010406d:	00 00                	add    %al,(%eax)
f010406f:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
	...
f010407b:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
f010407f:	00 06                	add    %al,(%esi)
f0104081:	00 00                	add    %al,(%eax)
f0104083:	00 00                	add    %al,(%eax)
f0104085:	00 00                	add    %al,(%eax)
f0104087:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
f010408b:	00 12                	add    %dl,(%edx)
f010408d:	00 00                	add    %al,(%eax)
f010408f:	00 00                	add    %al,(%eax)
f0104091:	00 00                	add    %al,(%eax)
f0104093:	00 44 00 33          	add    %al,0x33(%eax,%eax,1)
f0104097:	00 2e                	add    %ch,(%esi)
f0104099:	00 00                	add    %al,(%eax)
f010409b:	00 00                	add    %al,(%eax)
f010409d:	00 00                	add    %al,(%eax)
f010409f:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
f01040a3:	00 4a 00             	add    %cl,0x0(%edx)
f01040a6:	00 00                	add    %al,(%eax)
f01040a8:	00 00                	add    %al,(%eax)
f01040aa:	00 00                	add    %al,(%eax)
f01040ac:	44                   	inc    %esp
f01040ad:	00 35 00 66 00 00    	add    %dh,0x6600
f01040b3:	00 00                	add    %al,(%eax)
f01040b5:	00 00                	add    %al,(%eax)
f01040b7:	00 44 00 36          	add    %al,0x36(%eax,%eax,1)
f01040bb:	00 82 00 00 00 00    	add    %al,0x0(%edx)
f01040c1:	00 00                	add    %al,(%eax)
f01040c3:	00 44 00 39          	add    %al,0x39(%eax,%eax,1)
f01040c7:	00 aa 00 00 00 6a    	add    %ch,0x6a000000(%edx)
f01040cd:	11 00                	adc    %eax,(%eax)
f01040cf:	00 24 00             	add    %ah,(%eax,%eax,1)
f01040d2:	00 00                	add    %al,(%eax)
f01040d4:	d9 08                	(bad)  (%eax)
f01040d6:	10 f0                	adc    %dh,%al
f01040d8:	2a 11                	sub    (%ecx),%dl
f01040da:	00 00                	add    %al,(%eax)
f01040dc:	a0 00 00 00 08       	mov    0x8000000,%al
f01040e1:	00 00                	add    %al,(%eax)
f01040e3:	00 7a 11             	add    %bh,0x11(%edx)
f01040e6:	00 00                	add    %al,(%eax)
f01040e8:	a0 00 00 00 0c       	mov    0xc000000,%al
f01040ed:	00 00                	add    %al,(%eax)
f01040ef:	00 87 11 00 00 a0    	add    %al,-0x5fffffef(%edi)
f01040f5:	00 00                	add    %al,(%eax)
f01040f7:	00 10                	add    %dl,(%eax)
f01040f9:	00 00                	add    %al,(%eax)
f01040fb:	00 00                	add    %al,(%eax)
f01040fd:	00 00                	add    %al,(%eax)
f01040ff:	00 44 00 24          	add    %al,0x24(%eax,%eax,1)
	...
f010410b:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
f010410f:	00 06                	add    %al,(%esi)
f0104111:	00 00                	add    %al,(%eax)
f0104113:	00 00                	add    %al,(%eax)
f0104115:	00 00                	add    %al,(%eax)
f0104117:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
f010411b:	00 42 00             	add    %al,0x0(%edx)
f010411e:	00 00                	add    %al,(%eax)
f0104120:	92                   	xchg   %eax,%edx
f0104121:	11 00                	adc    %eax,(%eax)
f0104123:	00 24 00             	add    %ah,(%eax,%eax,1)
f0104126:	00 00                	add    %al,(%eax)
f0104128:	22 09                	and    (%ecx),%cl
f010412a:	10 f0                	adc    %dh,%al
f010412c:	87 11                	xchg   %edx,(%ecx)
f010412e:	00 00                	add    %al,(%eax)
f0104130:	a0 00 00 00 08       	mov    0x8000000,%al
f0104135:	00 00                	add    %al,(%eax)
f0104137:	00 00                	add    %al,(%eax)
f0104139:	00 00                	add    %al,(%eax)
f010413b:	00 44 00 bc          	add    %al,-0x44(%eax,%eax,1)
	...
f0104147:	00 44 00 bf          	add    %al,-0x41(%eax,%eax,1)
f010414b:	00 09                	add    %cl,(%ecx)
f010414d:	00 00                	add    %al,(%eax)
f010414f:	00 00                	add    %al,(%eax)
f0104151:	00 00                	add    %al,(%eax)
f0104153:	00 44 00 c0          	add    %al,-0x40(%eax,%eax,1)
f0104157:	00 15 00 00 00 00    	add    %dl,0x0
f010415d:	00 00                	add    %al,(%eax)
f010415f:	00 44 00 b3          	add    %al,-0x4d(%eax,%eax,1)
f0104163:	00 21                	add    %ah,(%ecx)
f0104165:	00 00                	add    %al,(%eax)
f0104167:	00 00                	add    %al,(%eax)
f0104169:	00 00                	add    %al,(%eax)
f010416b:	00 44 00 c4          	add    %al,-0x3c(%eax,%eax,1)
f010416f:	00 26                	add    %ah,(%esi)
f0104171:	00 00                	add    %al,(%eax)
f0104173:	00 00                	add    %al,(%eax)
f0104175:	00 00                	add    %al,(%eax)
f0104177:	00 44 00 c5          	add    %al,-0x3b(%eax,%eax,1)
f010417b:	00 34 00             	add    %dh,(%eax,%eax,1)
f010417e:	00 00                	add    %al,(%eax)
f0104180:	00 00                	add    %al,(%eax)
f0104182:	00 00                	add    %al,(%eax)
f0104184:	44                   	inc    %esp
f0104185:	00 9c 00 38 00 00 00 	add    %bl,0x38(%eax,%eax,1)
f010418c:	00 00                	add    %al,(%eax)
f010418e:	00 00                	add    %al,(%eax)
f0104190:	44                   	inc    %esp
f0104191:	00 a0 00 46 00 00    	add    %ah,0x4600(%eax)
f0104197:	00 00                	add    %al,(%eax)
f0104199:	00 00                	add    %al,(%eax)
f010419b:	00 44 00 9f          	add    %al,-0x61(%eax,%eax,1)
f010419f:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
f01041a3:	00 00                	add    %al,(%eax)
f01041a5:	00 00                	add    %al,(%eax)
f01041a7:	00 44 00 a1          	add    %al,-0x5f(%eax,%eax,1)
f01041ab:	00 6a 00             	add    %ch,0x0(%edx)
f01041ae:	00 00                	add    %al,(%eax)
f01041b0:	00 00                	add    %al,(%eax)
f01041b2:	00 00                	add    %al,(%eax)
f01041b4:	44                   	inc    %esp
f01041b5:	00 a5 00 6f 00 00    	add    %ah,0x6f00(%ebp)
f01041bb:	00 00                	add    %al,(%eax)
f01041bd:	00 00                	add    %al,(%eax)
f01041bf:	00 44 00 a6          	add    %al,-0x5a(%eax,%eax,1)
f01041c3:	00 74 00 00          	add    %dh,0x0(%eax,%eax,1)
f01041c7:	00 00                	add    %al,(%eax)
f01041c9:	00 00                	add    %al,(%eax)
f01041cb:	00 44 00 a9          	add    %al,-0x57(%eax,%eax,1)
f01041cf:	00 8a 00 00 00 00    	add    %cl,0x0(%edx)
f01041d5:	00 00                	add    %al,(%eax)
f01041d7:	00 44 00 aa          	add    %al,-0x56(%eax,%eax,1)
f01041db:	00 91 00 00 00 00    	add    %dl,0x0(%ecx)
f01041e1:	00 00                	add    %al,(%eax)
f01041e3:	00 44 00 ab          	add    %al,-0x55(%eax,%eax,1)
f01041e7:	00 9a 00 00 00 00    	add    %bl,0x0(%edx)
f01041ed:	00 00                	add    %al,(%eax)
f01041ef:	00 44 00 aa          	add    %al,-0x56(%eax,%eax,1)
f01041f3:	00 9d 00 00 00 00    	add    %bl,0x0(%ebp)
f01041f9:	00 00                	add    %al,(%eax)
f01041fb:	00 44 00 ad          	add    %al,-0x53(%eax,%eax,1)
f01041ff:	00 bd 00 00 00 00    	add    %bh,0x0(%ebp)
f0104205:	00 00                	add    %al,(%eax)
f0104207:	00 44 00 b0          	add    %al,-0x50(%eax,%eax,1)
f010420b:	00 c5                	add    %al,%ch
f010420d:	00 00                	add    %al,(%eax)
f010420f:	00 00                	add    %al,(%eax)
f0104211:	00 00                	add    %al,(%eax)
f0104213:	00 44 00 b3          	add    %al,-0x4d(%eax,%eax,1)
f0104217:	00 cd                	add    %cl,%ch
f0104219:	00 00                	add    %al,(%eax)
f010421b:	00 00                	add    %al,(%eax)
f010421d:	00 00                	add    %al,(%eax)
f010421f:	00 44 00 b4          	add    %al,-0x4c(%eax,%eax,1)
f0104223:	00 04 01             	add    %al,(%ecx,%eax,1)
f0104226:	00 00                	add    %al,(%eax)
f0104228:	00 00                	add    %al,(%eax)
f010422a:	00 00                	add    %al,(%eax)
f010422c:	44                   	inc    %esp
f010422d:	00 c6                	add    %al,%dh
f010422f:	00 1e                	add    %bl,(%esi)
f0104231:	01 00                	add    %eax,(%eax)
f0104233:	00 00                	add    %al,(%eax)
f0104235:	00 00                	add    %al,(%eax)
f0104237:	00 44 00 b6          	add    %al,-0x4a(%eax,%eax,1)
f010423b:	00 27                	add    %ah,(%edi)
f010423d:	01 00                	add    %eax,(%eax)
f010423f:	00 00                	add    %al,(%eax)
f0104241:	00 00                	add    %al,(%eax)
f0104243:	00 44 00 c9          	add    %al,-0x37(%eax,%eax,1)
f0104247:	00 3f                	add    %bh,(%edi)
f0104249:	01 00                	add    %eax,(%eax)
f010424b:	00 a2 11 00 00 40    	add    %ah,0x40000011(%edx)
f0104251:	00 00                	add    %al,(%eax)
f0104253:	00 03                	add    %al,(%ebx)
f0104255:	00 00                	add    %al,(%eax)
f0104257:	00 00                	add    %al,(%eax)
f0104259:	00 00                	add    %al,(%eax)
f010425b:	00 c0                	add    %al,%al
f010425d:	00 00                	add    %al,(%eax)
f010425f:	00 00                	add    %al,(%eax)
f0104261:	00 00                	add    %al,(%eax)
f0104263:	00 ad 11 00 00 40    	add    %ch,0x40000011(%ebp)
f0104269:	00 00                	add    %al,(%eax)
f010426b:	00 06                	add    %al,(%esi)
f010426d:	00 00                	add    %al,(%eax)
f010426f:	00 b9 11 00 00 80    	add    %bh,-0x7fffffef(%ecx)
f0104275:	00 00                	add    %al,(%eax)
f0104277:	00 a8 ff ff ff 4a    	add    %ch,0x4affffff(%eax)
f010427d:	0d 00 00 40 00       	or     $0x400000,%eax
f0104282:	00 00                	add    %al,(%eax)
f0104284:	02 00                	add    (%eax),%al
f0104286:	00 00                	add    %al,(%eax)
f0104288:	00 00                	add    %al,(%eax)
f010428a:	00 00                	add    %al,(%eax)
f010428c:	c0 00 00             	rolb   $0x0,(%eax)
f010428f:	00 38                	add    %bh,(%eax)
f0104291:	00 00                	add    %al,(%eax)
f0104293:	00 00                	add    %al,(%eax)
f0104295:	00 00                	add    %al,(%eax)
f0104297:	00 e0                	add    %ah,%al
f0104299:	00 00                	add    %al,(%eax)
f010429b:	00 1e                	add    %bl,(%esi)
f010429d:	01 00                	add    %eax,(%eax)
f010429f:	00 ad 11 00 00 40    	add    %ch,0x40000011(%ebp)
f01042a5:	00 00                	add    %al,(%eax)
f01042a7:	00 06                	add    %al,(%esi)
f01042a9:	00 00                	add    %al,(%eax)
f01042ab:	00 d9                	add    %bl,%cl
f01042ad:	11 00                	adc    %eax,(%eax)
f01042af:	00 80 00 00 00 a8    	add    %al,-0x58000000(%eax)
f01042b5:	ff                   	(bad)  
f01042b6:	ff                   	(bad)  
f01042b7:	ff 4a 0d             	decl   0xd(%edx)
f01042ba:	00 00                	add    %al,(%eax)
f01042bc:	40                   	inc    %eax
f01042bd:	00 00                	add    %al,(%eax)
f01042bf:	00 02                	add    %al,(%edx)
f01042c1:	00 00                	add    %al,(%eax)
f01042c3:	00 00                	add    %al,(%eax)
f01042c5:	00 00                	add    %al,(%eax)
f01042c7:	00 c0                	add    %al,%al
f01042c9:	00 00                	add    %al,(%eax)
f01042cb:	00 21                	add    %ah,(%ecx)
f01042cd:	00 00                	add    %al,(%eax)
f01042cf:	00 00                	add    %al,(%eax)
f01042d1:	00 00                	add    %al,(%eax)
f01042d3:	00 e0                	add    %ah,%al
f01042d5:	00 00                	add    %al,(%eax)
f01042d7:	00 26                	add    %ah,(%esi)
f01042d9:	00 00                	add    %al,(%eax)
f01042db:	00 ad 11 00 00 40    	add    %ch,0x40000011(%ebp)
f01042e1:	00 00                	add    %al,(%eax)
f01042e3:	00 06                	add    %al,(%esi)
f01042e5:	00 00                	add    %al,(%eax)
f01042e7:	00 d9                	add    %bl,%cl
f01042e9:	11 00                	adc    %eax,(%eax)
f01042eb:	00 80 00 00 00 a8    	add    %al,-0x58000000(%eax)
f01042f1:	ff                   	(bad)  
f01042f2:	ff                   	(bad)  
f01042f3:	ff 4a 0d             	decl   0xd(%edx)
f01042f6:	00 00                	add    %al,(%eax)
f01042f8:	40                   	inc    %eax
f01042f9:	00 00                	add    %al,(%eax)
f01042fb:	00 02                	add    %al,(%edx)
f01042fd:	00 00                	add    %al,(%eax)
f01042ff:	00 00                	add    %al,(%eax)
f0104301:	00 00                	add    %al,(%eax)
f0104303:	00 c0                	add    %al,%al
f0104305:	00 00                	add    %al,(%eax)
f0104307:	00 27                	add    %ah,(%edi)
f0104309:	01 00                	add    %eax,(%eax)
f010430b:	00 00                	add    %al,(%eax)
f010430d:	00 00                	add    %al,(%eax)
f010430f:	00 e0                	add    %ah,%al
f0104311:	00 00                	add    %al,(%eax)
f0104313:	00 3f                	add    %bh,(%edi)
f0104315:	01 00                	add    %eax,(%eax)
f0104317:	00 00                	add    %al,(%eax)
f0104319:	00 00                	add    %al,(%eax)
f010431b:	00 e0                	add    %ah,%al
f010431d:	00 00                	add    %al,(%eax)
f010431f:	00 47 01             	add    %al,0x1(%edi)
f0104322:	00 00                	add    %al,(%eax)
f0104324:	e5 11                	in     $0x11,%eax
f0104326:	00 00                	add    %al,(%eax)
f0104328:	24 00                	and    $0x0,%al
f010432a:	00 00                	add    %al,(%eax)
f010432c:	69 0a 10 f0 2a 11    	imul   $0x112af010,(%edx),%ecx
f0104332:	00 00                	add    %al,(%eax)
f0104334:	a0 00 00 00 08       	mov    0x8000000,%al
f0104339:	00 00                	add    %al,(%eax)
f010433b:	00 7a 11             	add    %bh,0x11(%edx)
f010433e:	00 00                	add    %al,(%eax)
f0104340:	a0 00 00 00 0c       	mov    0xc000000,%al
f0104345:	00 00                	add    %al,(%eax)
f0104347:	00 87 11 00 00 a0    	add    %al,-0x5fffffef(%edi)
f010434d:	00 00                	add    %al,(%eax)
f010434f:	00 10                	add    %dl,(%eax)
f0104351:	00 00                	add    %al,(%eax)
f0104353:	00 00                	add    %al,(%eax)
f0104355:	00 00                	add    %al,(%eax)
f0104357:	00 44 00 78          	add    %al,0x78(%eax,%eax,1)
	...
f0104363:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
f0104367:	00 09                	add    %cl,(%ecx)
f0104369:	00 00                	add    %al,(%eax)
f010436b:	00 00                	add    %al,(%eax)
f010436d:	00 00                	add    %al,(%eax)
f010436f:	00 44 00 82          	add    %al,-0x7e(%eax,%eax,1)
f0104373:	00 10                	add    %dl,(%eax)
f0104375:	00 00                	add    %al,(%eax)
f0104377:	00 00                	add    %al,(%eax)
f0104379:	00 00                	add    %al,(%eax)
f010437b:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
f010437f:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
f0104383:	00 00                	add    %al,(%eax)
f0104385:	00 00                	add    %al,(%eax)
f0104387:	00 44 00 84          	add    %al,-0x7c(%eax,%eax,1)
f010438b:	00 5d 00             	add    %bl,0x0(%ebp)
f010438e:	00 00                	add    %al,(%eax)
f0104390:	00 00                	add    %al,(%eax)
f0104392:	00 00                	add    %al,(%eax)
f0104394:	44                   	inc    %esp
f0104395:	00 85 00 87 00 00    	add    %al,0x8700(%ebp)
f010439b:	00 00                	add    %al,(%eax)
f010439d:	00 00                	add    %al,(%eax)
f010439f:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
f01043a3:	00 89 00 00 00 00    	add    %cl,0x0(%ecx)
f01043a9:	00 00                	add    %al,(%eax)
f01043ab:	00 44 00 87          	add    %al,-0x79(%eax,%eax,1)
f01043af:	00 95 00 00 00 00    	add    %dl,0x0(%ebp)
f01043b5:	00 00                	add    %al,(%eax)
f01043b7:	00 44 00 88          	add    %al,-0x78(%eax,%eax,1)
f01043bb:	00 9a 00 00 00 00    	add    %bl,0x0(%edx)
f01043c1:	00 00                	add    %al,(%eax)
f01043c3:	00 44 00 8a          	add    %al,-0x76(%eax,%eax,1)
f01043c7:	00 a6 00 00 00 fa    	add    %ah,-0x6000000(%esi)
f01043cd:	11 00                	adc    %eax,(%eax)
f01043cf:	00 80 00 00 00 d0    	add    %al,-0x30000000(%eax)
f01043d5:	ff                   	(bad)  
f01043d6:	ff                   	(bad)  
f01043d7:	ff 0a                	decl   (%edx)
f01043d9:	12 00                	adc    (%eax),%al
f01043db:	00 40 00             	add    %al,0x0(%eax)
f01043de:	00 00                	add    %al,(%eax)
f01043e0:	03 00                	add    (%eax),%eax
f01043e2:	00 00                	add    %al,(%eax)
f01043e4:	4a                   	dec    %edx
f01043e5:	0d 00 00 40 00       	or     $0x400000,%eax
f01043ea:	00 00                	add    %al,(%eax)
f01043ec:	07                   	pop    %es
f01043ed:	00 00                	add    %al,(%eax)
f01043ef:	00 00                	add    %al,(%eax)
f01043f1:	00 00                	add    %al,(%eax)
f01043f3:	00 c0                	add    %al,%al
	...
f01043fd:	00 00                	add    %al,(%eax)
f01043ff:	00 e0                	add    %ah,%al
f0104401:	00 00                	add    %al,(%eax)
f0104403:	00 b3 00 00 00 1e    	add    %dh,0x1e000000(%ebx)
f0104409:	12 00                	adc    (%eax),%al
f010440b:	00 26                	add    %ah,(%esi)
f010440d:	00 00                	add    %al,(%eax)
f010440f:	00 14 24             	add    %dl,(%esp)
f0104412:	10 f0                	adc    %dh,%al
f0104414:	00 00                	add    %al,(%eax)
f0104416:	00 00                	add    %al,(%eax)
f0104418:	64 00 00             	add    %al,%fs:(%eax)
f010441b:	00 1c 0b             	add    %bl,(%ebx,%ecx,1)
f010441e:	10 f0                	adc    %dh,%al
f0104420:	43                   	inc    %ebx
f0104421:	12 00                	adc    (%eax),%al
f0104423:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
f0104427:	00 1c 0b             	add    %bl,(%ebx,%ecx,1)
f010442a:	10 f0                	adc    %dh,%al
f010442c:	31 00                	xor    %eax,(%eax)
f010442e:	00 00                	add    %al,(%eax)
f0104430:	3c 00                	cmp    $0x0,%al
f0104432:	00 00                	add    %al,(%eax)
f0104434:	00 00                	add    %al,(%eax)
f0104436:	00 00                	add    %al,(%eax)
f0104438:	40                   	inc    %eax
f0104439:	00 00                	add    %al,(%eax)
f010443b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0104441:	00 00                	add    %al,(%eax)
f0104443:	00 6a 00             	add    %ch,0x0(%edx)
f0104446:	00 00                	add    %al,(%eax)
f0104448:	80 00 00             	addb   $0x0,(%eax)
f010444b:	00 00                	add    %al,(%eax)
f010444d:	00 00                	add    %al,(%eax)
f010444f:	00 84 00 00 00 80 00 	add    %al,0x800000(%eax,%eax,1)
f0104456:	00 00                	add    %al,(%eax)
f0104458:	00 00                	add    %al,(%eax)
f010445a:	00 00                	add    %al,(%eax)
f010445c:	b3 00                	mov    $0x0,%bl
f010445e:	00 00                	add    %al,(%eax)
f0104460:	80 00 00             	addb   $0x0,(%eax)
f0104463:	00 00                	add    %al,(%eax)
f0104465:	00 00                	add    %al,(%eax)
f0104467:	00 dc                	add    %bl,%ah
f0104469:	00 00                	add    %al,(%eax)
f010446b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0104471:	00 00                	add    %al,(%eax)
f0104473:	00 0a                	add    %cl,(%edx)
f0104475:	01 00                	add    %eax,(%eax)
f0104477:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f010447d:	00 00                	add    %al,(%eax)
f010447f:	00 35 01 00 00 80    	add    %dh,0x80000001
f0104485:	00 00                	add    %al,(%eax)
f0104487:	00 00                	add    %al,(%eax)
f0104489:	00 00                	add    %al,(%eax)
f010448b:	00 60 01             	add    %ah,0x1(%eax)
f010448e:	00 00                	add    %al,(%eax)
f0104490:	80 00 00             	addb   $0x0,(%eax)
f0104493:	00 00                	add    %al,(%eax)
f0104495:	00 00                	add    %al,(%eax)
f0104497:	00 86 01 00 00 80    	add    %al,-0x7fffffff(%esi)
f010449d:	00 00                	add    %al,(%eax)
f010449f:	00 00                	add    %al,(%eax)
f01044a1:	00 00                	add    %al,(%eax)
f01044a3:	00 b0 01 00 00 80    	add    %dh,-0x7fffffff(%eax)
f01044a9:	00 00                	add    %al,(%eax)
f01044ab:	00 00                	add    %al,(%eax)
f01044ad:	00 00                	add    %al,(%eax)
f01044af:	00 d6                	add    %dl,%dh
f01044b1:	01 00                	add    %eax,(%eax)
f01044b3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f01044b9:	00 00                	add    %al,(%eax)
f01044bb:	00 fb                	add    %bh,%bl
f01044bd:	01 00                	add    %eax,(%eax)
f01044bf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f01044c5:	00 00                	add    %al,(%eax)
f01044c7:	00 15 02 00 00 80    	add    %dl,0x80000002
f01044cd:	00 00                	add    %al,(%eax)
f01044cf:	00 00                	add    %al,(%eax)
f01044d1:	00 00                	add    %al,(%eax)
f01044d3:	00 30                	add    %dh,(%eax)
f01044d5:	02 00                	add    (%eax),%al
f01044d7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f01044dd:	00 00                	add    %al,(%eax)
f01044df:	00 51 02             	add    %dl,0x2(%ecx)
f01044e2:	00 00                	add    %al,(%eax)
f01044e4:	80 00 00             	addb   $0x0,(%eax)
f01044e7:	00 00                	add    %al,(%eax)
f01044e9:	00 00                	add    %al,(%eax)
f01044eb:	00 70 02             	add    %dh,0x2(%eax)
f01044ee:	00 00                	add    %al,(%eax)
f01044f0:	80 00 00             	addb   $0x0,(%eax)
f01044f3:	00 00                	add    %al,(%eax)
f01044f5:	00 00                	add    %al,(%eax)
f01044f7:	00 8f 02 00 00 80    	add    %cl,-0x7ffffffe(%edi)
f01044fd:	00 00                	add    %al,(%eax)
f01044ff:	00 00                	add    %al,(%eax)
f0104501:	00 00                	add    %al,(%eax)
f0104503:	00 b0 02 00 00 80    	add    %dh,-0x7ffffffe(%eax)
f0104509:	00 00                	add    %al,(%eax)
f010450b:	00 00                	add    %al,(%eax)
f010450d:	00 00                	add    %al,(%eax)
f010450f:	00 d0                	add    %dl,%al
f0104511:	02 00                	add    (%eax),%al
f0104513:	00 c2                	add    %al,%dl
f0104515:	00 00                	add    %al,(%eax)
f0104517:	00 37                	add    %dh,(%edi)
f0104519:	53                   	push   %ebx
f010451a:	00 00                	add    %al,(%eax)
f010451c:	e3 0a                	jecxz  f0104528 <__STAB_BEGIN__+0x1e48>
f010451e:	00 00                	add    %al,(%eax)
f0104520:	c2 00 00             	ret    $0x0
f0104523:	00 00                	add    %al,(%eax)
f0104525:	00 00                	add    %al,(%eax)
f0104527:	00 f1                	add    %dh,%cl
f0104529:	0a 00                	or     (%eax),%al
f010452b:	00 c2                	add    %al,%dl
f010452d:	00 00                	add    %al,(%eax)
f010452f:	00 50 06             	add    %dl,0x6(%eax)
f0104532:	00 00                	add    %al,(%eax)
f0104534:	51                   	push   %ecx
f0104535:	12 00                	adc    (%eax),%al
f0104537:	00 24 00             	add    %ah,(%eax,%eax,1)
f010453a:	00 00                	add    %al,(%eax)
f010453c:	1c 0b                	sbb    $0xb,%al
f010453e:	10 f0                	adc    %dh,%al
f0104540:	61                   	popa   
f0104541:	12 00                	adc    (%eax),%al
f0104543:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
f0104549:	00 00                	add    %al,(%eax)
f010454b:	00 74 12 00          	add    %dh,0x0(%edx,%edx,1)
f010454f:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
f0104555:	00 00                	add    %al,(%eax)
f0104557:	00 00                	add    %al,(%eax)
f0104559:	00 00                	add    %al,(%eax)
f010455b:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
	...
f0104567:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
f010456b:	00 06                	add    %al,(%esi)
f010456d:	00 00                	add    %al,(%eax)
f010456f:	00 00                	add    %al,(%eax)
f0104571:	00 00                	add    %al,(%eax)
f0104573:	00 44 00 15          	add    %al,0x15(%eax,%eax,1)
f0104577:	00 0d 00 00 00 00    	add    %cl,0x0
f010457d:	00 00                	add    %al,(%eax)
f010457f:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
f0104583:	00 2e                	add    %ch,(%esi)
f0104585:	00 00                	add    %al,(%eax)
f0104587:	00 7e 12             	add    %bh,0x12(%esi)
f010458a:	00 00                	add    %al,(%eax)
f010458c:	80 00 00             	addb   $0x0,(%eax)
f010458f:	00 f4                	add    %dh,%ah
f0104591:	ff                   	(bad)  
f0104592:	ff                   	(bad)  
f0104593:	ff                   	(bad)  
f0104594:	7e 0b                	jle    f01045a1 <__STAB_BEGIN__+0x1ec1>
f0104596:	00 00                	add    %al,(%eax)
f0104598:	40                   	inc    %eax
f0104599:	00 00                	add    %al,(%eax)
f010459b:	00 00                	add    %al,(%eax)
f010459d:	00 00                	add    %al,(%eax)
f010459f:	00 88 12 00 00 40    	add    %cl,0x40000012(%eax)
	...
f01045ad:	00 00                	add    %al,(%eax)
f01045af:	00 c0                	add    %al,%al
	...
f01045b9:	00 00                	add    %al,(%eax)
f01045bb:	00 e0                	add    %ah,%al
f01045bd:	00 00                	add    %al,(%eax)
f01045bf:	00 33                	add    %dh,(%ebx)
f01045c1:	00 00                	add    %al,(%eax)
f01045c3:	00 92 12 00 00 24    	add    %dl,0x24000012(%edx)
f01045c9:	00 00                	add    %al,(%eax)
f01045cb:	00 4f 0b             	add    %cl,0xb(%edi)
f01045ce:	10 f0                	adc    %dh,%al
f01045d0:	59                   	pop    %ecx
f01045d1:	0b 00                	or     (%eax),%eax
f01045d3:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
f01045d9:	00 00                	add    %al,(%eax)
f01045db:	00 00                	add    %al,(%eax)
f01045dd:	00 00                	add    %al,(%eax)
f01045df:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
	...
f01045eb:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
f01045ef:	00 06                	add    %al,(%esi)
f01045f1:	00 00                	add    %al,(%eax)
f01045f3:	00 00                	add    %al,(%eax)
f01045f5:	00 00                	add    %al,(%eax)
f01045f7:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
f01045fb:	00 09                	add    %cl,(%ecx)
f01045fd:	00 00                	add    %al,(%eax)
f01045ff:	00 00                	add    %al,(%eax)
f0104601:	00 00                	add    %al,(%eax)
f0104603:	00 44 00 24          	add    %al,0x24(%eax,%eax,1)
f0104607:	00 18                	add    %bl,(%eax)
f0104609:	00 00                	add    %al,(%eax)
f010460b:	00 a1 12 00 00 40    	add    %ah,0x40000012(%ecx)
f0104611:	00 00                	add    %al,(%eax)
f0104613:	00 00                	add    %al,(%eax)
f0104615:	00 00                	add    %al,(%eax)
f0104617:	00 7e 0b             	add    %bh,0xb(%esi)
f010461a:	00 00                	add    %al,(%eax)
f010461c:	40                   	inc    %eax
	...
f0104625:	00 00                	add    %al,(%eax)
f0104627:	00 c0                	add    %al,%al
	...
f0104631:	00 00                	add    %al,(%eax)
f0104633:	00 e0                	add    %ah,%al
f0104635:	00 00                	add    %al,(%eax)
f0104637:	00 1a                	add    %bl,(%edx)
f0104639:	00 00                	add    %al,(%eax)
f010463b:	00 ac 12 00 00 24 00 	add    %ch,0x240000(%edx,%edx,1)
f0104642:	00 00                	add    %al,(%eax)
f0104644:	69 0b 10 f0 ba 12    	imul   $0x12baf010,(%ebx),%ecx
f010464a:	00 00                	add    %al,(%eax)
f010464c:	a0 00 00 00 08       	mov    0x8000000,%al
f0104651:	00 00                	add    %al,(%eax)
f0104653:	00 c4                	add    %al,%ah
f0104655:	12 00                	adc    (%eax),%al
f0104657:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
f010465d:	00 00                	add    %al,(%eax)
f010465f:	00 00                	add    %al,(%eax)
f0104661:	00 00                	add    %al,(%eax)
f0104663:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
	...
f010466f:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
f0104673:	00 0a                	add    %cl,(%edx)
f0104675:	00 00                	add    %al,(%eax)
f0104677:	00 00                	add    %al,(%eax)
f0104679:	00 00                	add    %al,(%eax)
f010467b:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
f010467f:	00 15 00 00 00 00    	add    %dl,0x0
f0104685:	00 00                	add    %al,(%eax)
f0104687:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
f010468b:	00 18                	add    %bl,(%eax)
f010468d:	00 00                	add    %al,(%eax)
f010468f:	00 d7                	add    %dl,%bh
f0104691:	12 00                	adc    (%eax),%al
f0104693:	00 40 00             	add    %al,0x0(%eax)
f0104696:	00 00                	add    %al,(%eax)
f0104698:	00 00                	add    %al,(%eax)
f010469a:	00 00                	add    %al,(%eax)
f010469c:	e1 12                	loope  f01046b0 <__STAB_BEGIN__+0x1fd0>
f010469e:	00 00                	add    %al,(%eax)
f01046a0:	40                   	inc    %eax
f01046a1:	00 00                	add    %al,(%eax)
f01046a3:	00 03                	add    %al,(%ebx)
f01046a5:	00 00                	add    %al,(%eax)
f01046a7:	00 00                	add    %al,(%eax)
f01046a9:	00 00                	add    %al,(%eax)
f01046ab:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
f01046af:	00 87 0b 10 f0 ed    	add    %al,-0x120feff5(%edi)
f01046b5:	12 00                	adc    (%eax),%al
f01046b7:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
f01046bb:	00 90 0b 10 f0 31    	add    %dl,0x31f0100b(%eax)
f01046c1:	00 00                	add    %al,(%eax)
f01046c3:	00 3c 00             	add    %bh,(%eax,%eax,1)
f01046c6:	00 00                	add    %al,(%eax)
f01046c8:	00 00                	add    %al,(%eax)
f01046ca:	00 00                	add    %al,(%eax)
f01046cc:	40                   	inc    %eax
f01046cd:	00 00                	add    %al,(%eax)
f01046cf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f01046d5:	00 00                	add    %al,(%eax)
f01046d7:	00 6a 00             	add    %ch,0x0(%edx)
f01046da:	00 00                	add    %al,(%eax)
f01046dc:	80 00 00             	addb   $0x0,(%eax)
f01046df:	00 00                	add    %al,(%eax)
f01046e1:	00 00                	add    %al,(%eax)
f01046e3:	00 84 00 00 00 80 00 	add    %al,0x800000(%eax,%eax,1)
f01046ea:	00 00                	add    %al,(%eax)
f01046ec:	00 00                	add    %al,(%eax)
f01046ee:	00 00                	add    %al,(%eax)
f01046f0:	b3 00                	mov    $0x0,%bl
f01046f2:	00 00                	add    %al,(%eax)
f01046f4:	80 00 00             	addb   $0x0,(%eax)
f01046f7:	00 00                	add    %al,(%eax)
f01046f9:	00 00                	add    %al,(%eax)
f01046fb:	00 dc                	add    %bl,%ah
f01046fd:	00 00                	add    %al,(%eax)
f01046ff:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0104705:	00 00                	add    %al,(%eax)
f0104707:	00 0a                	add    %cl,(%edx)
f0104709:	01 00                	add    %eax,(%eax)
f010470b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0104711:	00 00                	add    %al,(%eax)
f0104713:	00 35 01 00 00 80    	add    %dh,0x80000001
f0104719:	00 00                	add    %al,(%eax)
f010471b:	00 00                	add    %al,(%eax)
f010471d:	00 00                	add    %al,(%eax)
f010471f:	00 60 01             	add    %ah,0x1(%eax)
f0104722:	00 00                	add    %al,(%eax)
f0104724:	80 00 00             	addb   $0x0,(%eax)
f0104727:	00 00                	add    %al,(%eax)
f0104729:	00 00                	add    %al,(%eax)
f010472b:	00 86 01 00 00 80    	add    %al,-0x7fffffff(%esi)
f0104731:	00 00                	add    %al,(%eax)
f0104733:	00 00                	add    %al,(%eax)
f0104735:	00 00                	add    %al,(%eax)
f0104737:	00 b0 01 00 00 80    	add    %dh,-0x7fffffff(%eax)
f010473d:	00 00                	add    %al,(%eax)
f010473f:	00 00                	add    %al,(%eax)
f0104741:	00 00                	add    %al,(%eax)
f0104743:	00 d6                	add    %dl,%dh
f0104745:	01 00                	add    %eax,(%eax)
f0104747:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f010474d:	00 00                	add    %al,(%eax)
f010474f:	00 fb                	add    %bh,%bl
f0104751:	01 00                	add    %eax,(%eax)
f0104753:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0104759:	00 00                	add    %al,(%eax)
f010475b:	00 15 02 00 00 80    	add    %dl,0x80000002
f0104761:	00 00                	add    %al,(%eax)
f0104763:	00 00                	add    %al,(%eax)
f0104765:	00 00                	add    %al,(%eax)
f0104767:	00 30                	add    %dh,(%eax)
f0104769:	02 00                	add    (%eax),%al
f010476b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0104771:	00 00                	add    %al,(%eax)
f0104773:	00 51 02             	add    %dl,0x2(%ecx)
f0104776:	00 00                	add    %al,(%eax)
f0104778:	80 00 00             	addb   $0x0,(%eax)
f010477b:	00 00                	add    %al,(%eax)
f010477d:	00 00                	add    %al,(%eax)
f010477f:	00 70 02             	add    %dh,0x2(%eax)
f0104782:	00 00                	add    %al,(%eax)
f0104784:	80 00 00             	addb   $0x0,(%eax)
f0104787:	00 00                	add    %al,(%eax)
f0104789:	00 00                	add    %al,(%eax)
f010478b:	00 8f 02 00 00 80    	add    %cl,-0x7ffffffe(%edi)
f0104791:	00 00                	add    %al,(%eax)
f0104793:	00 00                	add    %al,(%eax)
f0104795:	00 00                	add    %al,(%eax)
f0104797:	00 b0 02 00 00 80    	add    %dh,-0x7ffffffe(%eax)
f010479d:	00 00                	add    %al,(%eax)
f010479f:	00 00                	add    %al,(%eax)
f01047a1:	00 00                	add    %al,(%eax)
f01047a3:	00 fb                	add    %bh,%bl
f01047a5:	12 00                	adc    (%eax),%al
f01047a7:	00 82 00 00 00 9c    	add    %al,-0x64000000(%edx)
f01047ad:	1c 00                	sbb    $0x0,%al
f01047af:	00 d0                	add    %dl,%al
f01047b1:	02 00                	add    (%eax),%al
f01047b3:	00 c2                	add    %al,%dl
f01047b5:	00 00                	add    %al,(%eax)
f01047b7:	00 37                	add    %dh,(%edi)
f01047b9:	53                   	push   %ebx
f01047ba:	00 00                	add    %al,(%eax)
f01047bc:	08 13                	or     %dl,(%ebx)
f01047be:	00 00                	add    %al,(%eax)
f01047c0:	80 00 00             	addb   $0x0,(%eax)
	...
f01047cb:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
f01047d1:	00 00                	add    %al,(%eax)
f01047d3:	00 7b 09             	add    %bh,0x9(%ebx)
f01047d6:	00 00                	add    %al,(%eax)
f01047d8:	c2 00 00             	ret    $0x0
f01047db:	00 40 3b             	add    %al,0x3b(%eax)
f01047de:	00 00                	add    %al,(%eax)
f01047e0:	c4 02                	les    (%edx),%eax
f01047e2:	00 00                	add    %al,(%eax)
f01047e4:	c2 00 00             	ret    $0x0
f01047e7:	00 16                	add    %dl,(%esi)
f01047e9:	59                   	pop    %ecx
f01047ea:	01 00                	add    %eax,(%eax)
f01047ec:	57                   	push   %edi
f01047ed:	0c 00                	or     $0x0,%al
f01047ef:	00 c2                	add    %al,%dl
f01047f1:	00 00                	add    %al,(%eax)
f01047f3:	00 00                	add    %al,(%eax)
f01047f5:	00 00                	add    %al,(%eax)
f01047f7:	00 e3                	add    %ah,%bl
f01047f9:	0a 00                	or     (%eax),%al
f01047fb:	00 c2                	add    %al,%dl
f01047fd:	00 00                	add    %al,(%eax)
f01047ff:	00 00                	add    %al,(%eax)
f0104801:	00 00                	add    %al,(%eax)
f0104803:	00 f1                	add    %dh,%cl
f0104805:	0a 00                	or     (%eax),%al
f0104807:	00 c2                	add    %al,%dl
f0104809:	00 00                	add    %al,(%eax)
f010480b:	00 50 06             	add    %dl,0x6(%eax)
f010480e:	00 00                	add    %al,(%eax)
f0104810:	2a 0f                	sub    (%edi),%cl
f0104812:	00 00                	add    %al,(%eax)
f0104814:	c2 00 00             	ret    $0x0
f0104817:	00 0d 30 00 00 78    	add    %cl,0x78000030
f010481d:	13 00                	adc    (%eax),%eax
f010481f:	00 24 00             	add    %ah,(%eax,%eax,1)
f0104822:	00 00                	add    %al,(%eax)
f0104824:	90                   	nop
f0104825:	0b 10                	or     (%eax),%edx
f0104827:	f0 8f                	lock (bad) 
f0104829:	13 00                	adc    (%eax),%eax
f010482b:	00 a0 00 00 00 f0    	add    %ah,-0x10000000(%eax)
f0104831:	ff                   	(bad)  
f0104832:	ff                   	(bad)  
f0104833:	ff a4 13 00 00 a0 00 	jmp    *0xa00000(%ebx,%edx,1)
f010483a:	00 00                	add    %al,(%eax)
f010483c:	e8 ff ff ff bf       	call   b0104840 <_start+0xb0004834>
f0104841:	13 00                	adc    (%eax),%eax
f0104843:	00 a0 00 00 00 e0    	add    %ah,-0x20000000(%eax)
f0104849:	ff                   	(bad)  
f010484a:	ff                   	(bad)  
f010484b:	ff d4                	call   *%esp
f010484d:	13 00                	adc    (%eax),%eax
f010484f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
f0104855:	00 00                	add    %al,(%eax)
f0104857:	00 e0                	add    %ah,%al
f0104859:	13 00                	adc    (%eax),%eax
f010485b:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
f0104861:	00 00                	add    %al,(%eax)
f0104863:	00 00                	add    %al,(%eax)
f0104865:	00 00                	add    %al,(%eax)
f0104867:	00 44 00 35          	add    %al,0x35(%eax,%eax,1)
	...
f0104873:	00 44 00 36          	add    %al,0x36(%eax,%eax,1)
f0104877:	00 15 00 00 00 00    	add    %dl,0x0
f010487d:	00 00                	add    %al,(%eax)
f010487f:	00 44 00 38          	add    %al,0x38(%eax,%eax,1)
f0104883:	00 1c 00             	add    %bl,(%eax,%eax,1)
f0104886:	00 00                	add    %al,(%eax)
f0104888:	00 00                	add    %al,(%eax)
f010488a:	00 00                	add    %al,(%eax)
f010488c:	44                   	inc    %esp
f010488d:	00 39                	add    %bh,(%ecx)
f010488f:	00 2b                	add    %ch,(%ebx)
f0104891:	00 00                	add    %al,(%eax)
f0104893:	00 00                	add    %al,(%eax)
f0104895:	00 00                	add    %al,(%eax)
f0104897:	00 44 00 3c          	add    %al,0x3c(%eax,%eax,1)
f010489b:	00 39                	add    %bh,(%ecx)
f010489d:	00 00                	add    %al,(%eax)
f010489f:	00 00                	add    %al,(%eax)
f01048a1:	00 00                	add    %al,(%eax)
f01048a3:	00 44 00 3d          	add    %al,0x3d(%eax,%eax,1)
f01048a7:	00 5a 00             	add    %bl,0x0(%edx)
f01048aa:	00 00                	add    %al,(%eax)
f01048ac:	00 00                	add    %al,(%eax)
f01048ae:	00 00                	add    %al,(%eax)
f01048b0:	44                   	inc    %esp
f01048b1:	00 3c 00             	add    %bh,(%eax,%eax,1)
f01048b4:	5d                   	pop    %ebp
f01048b5:	00 00                	add    %al,(%eax)
f01048b7:	00 00                	add    %al,(%eax)
f01048b9:	00 00                	add    %al,(%eax)
f01048bb:	00 44 00 3f          	add    %al,0x3f(%eax,%eax,1)
f01048bf:	00 70 00             	add    %dh,0x0(%eax)
f01048c2:	00 00                	add    %al,(%eax)
f01048c4:	00 00                	add    %al,(%eax)
f01048c6:	00 00                	add    %al,(%eax)
f01048c8:	44                   	inc    %esp
f01048c9:	00 40 00             	add    %al,0x0(%eax)
f01048cc:	73 00                	jae    f01048ce <__STAB_BEGIN__+0x21ee>
f01048ce:	00 00                	add    %al,(%eax)
f01048d0:	00 00                	add    %al,(%eax)
f01048d2:	00 00                	add    %al,(%eax)
f01048d4:	44                   	inc    %esp
f01048d5:	00 46 00             	add    %al,0x0(%esi)
f01048d8:	75 00                	jne    f01048da <__STAB_BEGIN__+0x21fa>
f01048da:	00 00                	add    %al,(%eax)
f01048dc:	00 00                	add    %al,(%eax)
f01048de:	00 00                	add    %al,(%eax)
f01048e0:	44                   	inc    %esp
f01048e1:	00 47 00             	add    %al,0x0(%edi)
f01048e4:	7a 00                	jp     f01048e6 <__STAB_BEGIN__+0x2206>
f01048e6:	00 00                	add    %al,(%eax)
f01048e8:	00 00                	add    %al,(%eax)
f01048ea:	00 00                	add    %al,(%eax)
f01048ec:	44                   	inc    %esp
f01048ed:	00 48 00             	add    %cl,0x0(%eax)
f01048f0:	86 00                	xchg   %al,(%eax)
f01048f2:	00 00                	add    %al,(%eax)
f01048f4:	00 00                	add    %al,(%eax)
f01048f6:	00 00                	add    %al,(%eax)
f01048f8:	44                   	inc    %esp
f01048f9:	00 49 00             	add    %cl,0x0(%ecx)
f01048fc:	8b 00                	mov    (%eax),%eax
f01048fe:	00 00                	add    %al,(%eax)
f0104900:	00 00                	add    %al,(%eax)
f0104902:	00 00                	add    %al,(%eax)
f0104904:	44                   	inc    %esp
f0104905:	00 4e 00             	add    %cl,0x0(%esi)
f0104908:	9f                   	lahf   
f0104909:	00 00                	add    %al,(%eax)
f010490b:	00 00                	add    %al,(%eax)
f010490d:	00 00                	add    %al,(%eax)
f010490f:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
f0104913:	00 a4 00 00 00 00 00 	add    %ah,0x0(%eax,%eax,1)
f010491a:	00 00                	add    %al,(%eax)
f010491c:	44                   	inc    %esp
f010491d:	00 38                	add    %bh,(%eax)
f010491f:	00 b1 00 00 00 00    	add    %dh,0x0(%ecx)
f0104925:	00 00                	add    %al,(%eax)
f0104927:	00 44 00 54          	add    %al,0x54(%eax,%eax,1)
f010492b:	00 ba 00 00 00 00    	add    %bh,0x0(%edx)
f0104931:	00 00                	add    %al,(%eax)
f0104933:	00 44 00 55          	add    %al,0x55(%eax,%eax,1)
f0104937:	00 c0                	add    %al,%al
f0104939:	00 00                	add    %al,(%eax)
f010493b:	00 00                	add    %al,(%eax)
f010493d:	00 00                	add    %al,(%eax)
f010493f:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
f0104943:	00 cf                	add    %cl,%bh
f0104945:	00 00                	add    %al,(%eax)
f0104947:	00 00                	add    %al,(%eax)
f0104949:	00 00                	add    %al,(%eax)
f010494b:	00 44 00 59          	add    %al,0x59(%eax,%eax,1)
f010494f:	00 d4                	add    %dl,%ah
f0104951:	00 00                	add    %al,(%eax)
f0104953:	00 00                	add    %al,(%eax)
f0104955:	00 00                	add    %al,(%eax)
f0104957:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
f010495b:	00 d9                	add    %bl,%cl
f010495d:	00 00                	add    %al,(%eax)
f010495f:	00 00                	add    %al,(%eax)
f0104961:	00 00                	add    %al,(%eax)
f0104963:	00 44 00 59          	add    %al,0x59(%eax,%eax,1)
f0104967:	00 dd                	add    %bl,%ch
f0104969:	00 00                	add    %al,(%eax)
f010496b:	00 00                	add    %al,(%eax)
f010496d:	00 00                	add    %al,(%eax)
f010496f:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
f0104973:	00 f4                	add    %dh,%ah
f0104975:	00 00                	add    %al,(%eax)
f0104977:	00 00                	add    %al,(%eax)
f0104979:	00 00                	add    %al,(%eax)
f010497b:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
f010497f:	00 f7                	add    %dh,%bh
f0104981:	00 00                	add    %al,(%eax)
f0104983:	00 00                	add    %al,(%eax)
f0104985:	00 00                	add    %al,(%eax)
f0104987:	00 44 00 59          	add    %al,0x59(%eax,%eax,1)
f010498b:	00 fb                	add    %bh,%bl
f010498d:	00 00                	add    %al,(%eax)
f010498f:	00 00                	add    %al,(%eax)
f0104991:	00 00                	add    %al,(%eax)
f0104993:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
f0104997:	00 01                	add    %al,(%ecx)
f0104999:	01 00                	add    %eax,(%eax)
f010499b:	00 00                	add    %al,(%eax)
f010499d:	00 00                	add    %al,(%eax)
f010499f:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
f01049a3:	00 05 01 00 00 00    	add    %al,0x1
f01049a9:	00 00                	add    %al,(%eax)
f01049ab:	00 44 00 5e          	add    %al,0x5e(%eax,%eax,1)
f01049af:	00 0c 01             	add    %cl,(%ecx,%eax,1)
f01049b2:	00 00                	add    %al,(%eax)
f01049b4:	00 00                	add    %al,(%eax)
f01049b6:	00 00                	add    %al,(%eax)
f01049b8:	44                   	inc    %esp
f01049b9:	00 45 00             	add    %al,0x0(%ebp)
f01049bc:	0e                   	push   %cs
f01049bd:	01 00                	add    %eax,(%eax)
f01049bf:	00 00                	add    %al,(%eax)
f01049c1:	00 00                	add    %al,(%eax)
f01049c3:	00 44 00 5e          	add    %al,0x5e(%eax,%eax,1)
f01049c7:	00 26                	add    %ah,(%esi)
f01049c9:	01 00                	add    %eax,(%eax)
f01049cb:	00 ed                	add    %ch,%ch
f01049cd:	13 00                	adc    (%eax),%eax
f01049cf:	00 40 00             	add    %al,0x0(%eax)
f01049d2:	00 00                	add    %al,(%eax)
f01049d4:	03 00                	add    (%eax),%eax
f01049d6:	00 00                	add    %al,(%eax)
f01049d8:	f6 13                	notb   (%ebx)
f01049da:	00 00                	add    %al,(%eax)
f01049dc:	80 00 00             	addb   $0x0,(%eax)
f01049df:	00 ec                	add    %ch,%ah
f01049e1:	ff                   	(bad)  
f01049e2:	ff                   	(bad)  
f01049e3:	ff                   	(bad)  
f01049e4:	fe                   	(bad)  
f01049e5:	13 00                	adc    (%eax),%eax
f01049e7:	00 80 00 00 00 e4    	add    %al,-0x1c000000(%eax)
f01049ed:	ff                   	(bad)  
f01049ee:	ff                   	(bad)  
f01049ef:	ff 10                	call   *(%eax)
f01049f1:	14 00                	adc    $0x0,%al
f01049f3:	00 40 00             	add    %al,0x0(%eax)
f01049f6:	00 00                	add    %al,(%eax)
f01049f8:	06                   	push   %es
f01049f9:	00 00                	add    %al,(%eax)
f01049fb:	00 00                	add    %al,(%eax)
f01049fd:	00 00                	add    %al,(%eax)
f01049ff:	00 c0                	add    %al,%al
f0104a01:	00 00                	add    %al,(%eax)
f0104a03:	00 00                	add    %al,(%eax)
f0104a05:	00 00                	add    %al,(%eax)
f0104a07:	00 1c 14             	add    %bl,(%esp,%edx,1)
f0104a0a:	00 00                	add    %al,(%eax)
f0104a0c:	40                   	inc    %eax
f0104a0d:	00 00                	add    %al,(%eax)
f0104a0f:	00 07                	add    %al,(%edi)
f0104a11:	00 00                	add    %al,(%eax)
f0104a13:	00 2a                	add    %ch,(%edx)
f0104a15:	14 00                	adc    $0x0,%al
f0104a17:	00 40 00             	add    %al,0x0(%eax)
	...
f0104a22:	00 00                	add    %al,(%eax)
f0104a24:	c0 00 00             	rolb   $0x0,(%eax)
f0104a27:	00 2b                	add    %ch,(%ebx)
f0104a29:	00 00                	add    %al,(%eax)
f0104a2b:	00 00                	add    %al,(%eax)
f0104a2d:	00 00                	add    %al,(%eax)
f0104a2f:	00 e0                	add    %ah,%al
f0104a31:	00 00                	add    %al,(%eax)
f0104a33:	00 b1 00 00 00 1c    	add    %dh,0x1c000000(%ecx)
f0104a39:	14 00                	adc    $0x0,%al
f0104a3b:	00 40 00             	add    %al,0x0(%eax)
f0104a3e:	00 00                	add    %al,(%eax)
f0104a40:	07                   	pop    %es
f0104a41:	00 00                	add    %al,(%eax)
f0104a43:	00 2a                	add    %ch,(%edx)
f0104a45:	14 00                	adc    $0x0,%al
f0104a47:	00 40 00             	add    %al,0x0(%eax)
	...
f0104a52:	00 00                	add    %al,(%eax)
f0104a54:	c0 00 00             	rolb   $0x0,(%eax)
f0104a57:	00 0e                	add    %cl,(%esi)
f0104a59:	01 00                	add    %eax,(%eax)
f0104a5b:	00 00                	add    %al,(%eax)
f0104a5d:	00 00                	add    %al,(%eax)
f0104a5f:	00 e0                	add    %ah,%al
f0104a61:	00 00                	add    %al,(%eax)
f0104a63:	00 26                	add    %ah,(%esi)
f0104a65:	01 00                	add    %eax,(%eax)
f0104a67:	00 00                	add    %al,(%eax)
f0104a69:	00 00                	add    %al,(%eax)
f0104a6b:	00 e0                	add    %ah,%al
f0104a6d:	00 00                	add    %al,(%eax)
f0104a6f:	00 2e                	add    %ch,(%esi)
f0104a71:	01 00                	add    %eax,(%eax)
f0104a73:	00 33                	add    %dh,(%ebx)
f0104a75:	14 00                	adc    $0x0,%al
f0104a77:	00 24 00             	add    %ah,(%eax,%eax,1)
f0104a7a:	00 00                	add    %al,(%eax)
f0104a7c:	be 0c 10 f0 e0       	mov    $0xe0f0100c,%esi
f0104a81:	13 00                	adc    (%eax),%eax
f0104a83:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
f0104a89:	00 00                	add    %al,(%eax)
f0104a8b:	00 48 14             	add    %cl,0x14(%eax)
f0104a8e:	00 00                	add    %al,(%eax)
f0104a90:	a0 00 00 00 0c       	mov    0xc000000,%al
f0104a95:	00 00                	add    %al,(%eax)
f0104a97:	00 00                	add    %al,(%eax)
f0104a99:	00 00                	add    %al,(%eax)
f0104a9b:	00 44 00 6a          	add    %al,0x6a(%eax,%eax,1)
	...
f0104aa7:	00 44 00 70          	add    %al,0x70(%eax,%eax,1)
f0104aab:	00 15 00 00 00 00    	add    %dl,0x0
f0104ab1:	00 00                	add    %al,(%eax)
f0104ab3:	00 44 00 71          	add    %al,0x71(%eax,%eax,1)
f0104ab7:	00 1b                	add    %bl,(%ebx)
f0104ab9:	00 00                	add    %al,(%eax)
f0104abb:	00 00                	add    %al,(%eax)
f0104abd:	00 00                	add    %al,(%eax)
f0104abf:	00 44 00 72          	add    %al,0x72(%eax,%eax,1)
f0104ac3:	00 22                	add    %ah,(%edx)
f0104ac5:	00 00                	add    %al,(%eax)
f0104ac7:	00 00                	add    %al,(%eax)
f0104ac9:	00 00                	add    %al,(%eax)
f0104acb:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
f0104acf:	00 29                	add    %ch,(%ecx)
f0104ad1:	00 00                	add    %al,(%eax)
f0104ad3:	00 00                	add    %al,(%eax)
f0104ad5:	00 00                	add    %al,(%eax)
f0104ad7:	00 44 00 74          	add    %al,0x74(%eax,%eax,1)
f0104adb:	00 30                	add    %dh,(%eax)
f0104add:	00 00                	add    %al,(%eax)
f0104adf:	00 00                	add    %al,(%eax)
f0104ae1:	00 00                	add    %al,(%eax)
f0104ae3:	00 44 00 75          	add    %al,0x75(%eax,%eax,1)
f0104ae7:	00 33                	add    %dh,(%ebx)
f0104ae9:	00 00                	add    %al,(%eax)
f0104aeb:	00 00                	add    %al,(%eax)
f0104aed:	00 00                	add    %al,(%eax)
f0104aef:	00 44 00 78          	add    %al,0x78(%eax,%eax,1)
f0104af3:	00 3a                	add    %bh,(%edx)
f0104af5:	00 00                	add    %al,(%eax)
f0104af7:	00 00                	add    %al,(%eax)
f0104af9:	00 00                	add    %al,(%eax)
f0104afb:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
f0104aff:	00 42 00             	add    %al,0x0(%edx)
f0104b02:	00 00                	add    %al,(%eax)
f0104b04:	00 00                	add    %al,(%eax)
f0104b06:	00 00                	add    %al,(%eax)
f0104b08:	44                   	inc    %esp
f0104b09:	00 7f 00             	add    %bh,0x0(%edi)
f0104b0c:	54                   	push   %esp
f0104b0d:	00 00                	add    %al,(%eax)
f0104b0f:	00 00                	add    %al,(%eax)
f0104b11:	00 00                	add    %al,(%eax)
f0104b13:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
f0104b17:	00 70 00             	add    %dh,0x0(%eax)
f0104b1a:	00 00                	add    %al,(%eax)
f0104b1c:	00 00                	add    %al,(%eax)
f0104b1e:	00 00                	add    %al,(%eax)
f0104b20:	44                   	inc    %esp
f0104b21:	00 8c 00 7d 00 00 00 	add    %cl,0x7d(%eax,%eax,1)
f0104b28:	00 00                	add    %al,(%eax)
f0104b2a:	00 00                	add    %al,(%eax)
f0104b2c:	44                   	inc    %esp
f0104b2d:	00 8d 00 84 00 00    	add    %cl,0x8400(%ebp)
f0104b33:	00 00                	add    %al,(%eax)
f0104b35:	00 00                	add    %al,(%eax)
f0104b37:	00 44 00 8e          	add    %al,-0x72(%eax,%eax,1)
f0104b3b:	00 9d 00 00 00 00    	add    %bl,0x0(%ebp)
f0104b41:	00 00                	add    %al,(%eax)
f0104b43:	00 44 00 8f          	add    %al,-0x71(%eax,%eax,1)
f0104b47:	00 b8 00 00 00 00    	add    %bh,0x0(%eax)
f0104b4d:	00 00                	add    %al,(%eax)
f0104b4f:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
f0104b53:	00 c3                	add    %al,%bl
f0104b55:	00 00                	add    %al,(%eax)
f0104b57:	00 00                	add    %al,(%eax)
f0104b59:	00 00                	add    %al,(%eax)
f0104b5b:	00 44 00 95          	add    %al,-0x6b(%eax,%eax,1)
f0104b5f:	00 c6                	add    %al,%dh
f0104b61:	00 00                	add    %al,(%eax)
f0104b63:	00 00                	add    %al,(%eax)
f0104b65:	00 00                	add    %al,(%eax)
f0104b67:	00 44 00 96          	add    %al,-0x6a(%eax,%eax,1)
f0104b6b:	00 cc                	add    %cl,%ah
f0104b6d:	00 00                	add    %al,(%eax)
f0104b6f:	00 00                	add    %al,(%eax)
f0104b71:	00 00                	add    %al,(%eax)
f0104b73:	00 44 00 98          	add    %al,-0x68(%eax,%eax,1)
f0104b77:	00 e7                	add    %ah,%bh
f0104b79:	00 00                	add    %al,(%eax)
f0104b7b:	00 00                	add    %al,(%eax)
f0104b7d:	00 00                	add    %al,(%eax)
f0104b7f:	00 44 00 9b          	add    %al,-0x65(%eax,%eax,1)
f0104b83:	00 ef                	add    %ch,%bh
f0104b85:	00 00                	add    %al,(%eax)
f0104b87:	00 00                	add    %al,(%eax)
f0104b89:	00 00                	add    %al,(%eax)
f0104b8b:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
f0104b8f:	00 07                	add    %al,(%edi)
f0104b91:	01 00                	add    %eax,(%eax)
f0104b93:	00 00                	add    %al,(%eax)
f0104b95:	00 00                	add    %al,(%eax)
f0104b97:	00 44 00 9d          	add    %al,-0x63(%eax,%eax,1)
f0104b9b:	00 0f                	add    %cl,(%edi)
f0104b9d:	01 00                	add    %eax,(%eax)
f0104b9f:	00 00                	add    %al,(%eax)
f0104ba1:	00 00                	add    %al,(%eax)
f0104ba3:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
f0104ba7:	00 1e                	add    %bl,(%esi)
f0104ba9:	01 00                	add    %eax,(%eax)
f0104bab:	00 00                	add    %al,(%eax)
f0104bad:	00 00                	add    %al,(%eax)
f0104baf:	00 44 00 a0          	add    %al,-0x60(%eax,%eax,1)
f0104bb3:	00 20                	add    %ah,(%eax)
f0104bb5:	01 00                	add    %eax,(%eax)
f0104bb7:	00 00                	add    %al,(%eax)
f0104bb9:	00 00                	add    %al,(%eax)
f0104bbb:	00 44 00 a1          	add    %al,-0x5f(%eax,%eax,1)
f0104bbf:	00 23                	add    %ah,(%ebx)
f0104bc1:	01 00                	add    %eax,(%eax)
f0104bc3:	00 00                	add    %al,(%eax)
f0104bc5:	00 00                	add    %al,(%eax)
f0104bc7:	00 44 00 a5          	add    %al,-0x5b(%eax,%eax,1)
f0104bcb:	00 2b                	add    %ch,(%ebx)
f0104bcd:	01 00                	add    %eax,(%eax)
f0104bcf:	00 00                	add    %al,(%eax)
f0104bd1:	00 00                	add    %al,(%eax)
f0104bd3:	00 44 00 a6          	add    %al,-0x5a(%eax,%eax,1)
f0104bd7:	00 2e                	add    %ch,(%esi)
f0104bd9:	01 00                	add    %eax,(%eax)
f0104bdb:	00 00                	add    %al,(%eax)
f0104bdd:	00 00                	add    %al,(%eax)
f0104bdf:	00 44 00 a7          	add    %al,-0x59(%eax,%eax,1)
f0104be3:	00 34 01             	add    %dh,(%ecx,%eax,1)
f0104be6:	00 00                	add    %al,(%eax)
f0104be8:	00 00                	add    %al,(%eax)
f0104bea:	00 00                	add    %al,(%eax)
f0104bec:	44                   	inc    %esp
f0104bed:	00 aa 00 3a 01 00    	add    %ch,0x13a00(%edx)
f0104bf3:	00 00                	add    %al,(%eax)
f0104bf5:	00 00                	add    %al,(%eax)
f0104bf7:	00 44 00 b5          	add    %al,-0x4b(%eax,%eax,1)
f0104bfb:	00 53 01             	add    %dl,0x1(%ebx)
f0104bfe:	00 00                	add    %al,(%eax)
f0104c00:	00 00                	add    %al,(%eax)
f0104c02:	00 00                	add    %al,(%eax)
f0104c04:	44                   	inc    %esp
f0104c05:	00 b6 00 6e 01 00    	add    %dh,0x16e00(%esi)
f0104c0b:	00 00                	add    %al,(%eax)
f0104c0d:	00 00                	add    %al,(%eax)
f0104c0f:	00 44 00 b7          	add    %al,-0x49(%eax,%eax,1)
f0104c13:	00 7a 01             	add    %bh,0x1(%edx)
f0104c16:	00 00                	add    %al,(%eax)
f0104c18:	00 00                	add    %al,(%eax)
f0104c1a:	00 00                	add    %al,(%eax)
f0104c1c:	44                   	inc    %esp
f0104c1d:	00 b8 00 8a 01 00    	add    %bh,0x18a00(%eax)
f0104c23:	00 00                	add    %al,(%eax)
f0104c25:	00 00                	add    %al,(%eax)
f0104c27:	00 44 00 bf          	add    %al,-0x41(%eax,%eax,1)
f0104c2b:	00 9b 01 00 00 00    	add    %bl,0x1(%ebx)
f0104c31:	00 00                	add    %al,(%eax)
f0104c33:	00 44 00 be          	add    %al,-0x42(%eax,%eax,1)
f0104c37:	00 a9 01 00 00 00    	add    %ch,0x1(%ecx)
f0104c3d:	00 00                	add    %al,(%eax)
f0104c3f:	00 44 00 c0          	add    %al,-0x40(%eax,%eax,1)
f0104c43:	00 b7 01 00 00 00    	add    %dh,0x1(%edi)
f0104c49:	00 00                	add    %al,(%eax)
f0104c4b:	00 44 00 be          	add    %al,-0x42(%eax,%eax,1)
f0104c4f:	00 bb 01 00 00 00    	add    %bh,0x1(%ebx)
f0104c55:	00 00                	add    %al,(%eax)
f0104c57:	00 44 00 c3          	add    %al,-0x3d(%eax,%eax,1)
f0104c5b:	00 cc                	add    %cl,%ah
f0104c5d:	01 00                	add    %eax,(%eax)
f0104c5f:	00 00                	add    %al,(%eax)
f0104c61:	00 00                	add    %al,(%eax)
f0104c63:	00 44 00 c8          	add    %al,-0x38(%eax,%eax,1)
f0104c67:	00 d3                	add    %dl,%bl
f0104c69:	01 00                	add    %eax,(%eax)
f0104c6b:	00 00                	add    %al,(%eax)
f0104c6d:	00 00                	add    %al,(%eax)
f0104c6f:	00 44 00 c9          	add    %al,-0x37(%eax,%eax,1)
f0104c73:	00 db                	add    %bl,%bl
f0104c75:	01 00                	add    %eax,(%eax)
f0104c77:	00 00                	add    %al,(%eax)
f0104c79:	00 00                	add    %al,(%eax)
f0104c7b:	00 44 00 ca          	add    %al,-0x36(%eax,%eax,1)
f0104c7f:	00 e1                	add    %ah,%cl
f0104c81:	01 00                	add    %eax,(%eax)
f0104c83:	00 00                	add    %al,(%eax)
f0104c85:	00 00                	add    %al,(%eax)
f0104c87:	00 44 00 c9          	add    %al,-0x37(%eax,%eax,1)
f0104c8b:	00 e6                	add    %ah,%dh
f0104c8d:	01 00                	add    %eax,(%eax)
f0104c8f:	00 00                	add    %al,(%eax)
f0104c91:	00 00                	add    %al,(%eax)
f0104c93:	00 44 00 cc          	add    %al,-0x34(%eax,%eax,1)
f0104c97:	00 e8                	add    %ch,%al
f0104c99:	01 00                	add    %eax,(%eax)
f0104c9b:	00 00                	add    %al,(%eax)
f0104c9d:	00 00                	add    %al,(%eax)
f0104c9f:	00 44 00 cb          	add    %al,-0x35(%eax,%eax,1)
f0104ca3:	00 ec                	add    %ch,%ah
f0104ca5:	01 00                	add    %eax,(%eax)
f0104ca7:	00 00                	add    %al,(%eax)
f0104ca9:	00 00                	add    %al,(%eax)
f0104cab:	00 44 00 ca          	add    %al,-0x36(%eax,%eax,1)
f0104caf:	00 f0                	add    %dh,%al
f0104cb1:	01 00                	add    %eax,(%eax)
f0104cb3:	00 00                	add    %al,(%eax)
f0104cb5:	00 00                	add    %al,(%eax)
f0104cb7:	00 44 00 c9          	add    %al,-0x37(%eax,%eax,1)
f0104cbb:	00 f3                	add    %dh,%bl
f0104cbd:	01 00                	add    %eax,(%eax)
f0104cbf:	00 00                	add    %al,(%eax)
f0104cc1:	00 00                	add    %al,(%eax)
f0104cc3:	00 44 00 ca          	add    %al,-0x36(%eax,%eax,1)
f0104cc7:	00 f8                	add    %bh,%al
f0104cc9:	01 00                	add    %eax,(%eax)
f0104ccb:	00 00                	add    %al,(%eax)
f0104ccd:	00 00                	add    %al,(%eax)
f0104ccf:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
f0104cd3:	00 10                	add    %dl,(%eax)
f0104cd5:	02 00                	add    (%eax),%al
f0104cd7:	00 00                	add    %al,(%eax)
f0104cd9:	00 00                	add    %al,(%eax)
f0104cdb:	00 44 00 c2          	add    %al,-0x3e(%eax,%eax,1)
f0104cdf:	00 1d 02 00 00 5c    	add    %bl,0x5c000002
f0104ce5:	14 00                	adc    $0x0,%al
f0104ce7:	00 80 00 00 00 e4    	add    %al,-0x1c000000(%eax)
f0104ced:	ff                   	(bad)  
f0104cee:	ff                   	(bad)  
f0104cef:	ff 68 14             	ljmp   *0x14(%eax)
f0104cf2:	00 00                	add    %al,(%eax)
f0104cf4:	80 00 00             	addb   $0x0,(%eax)
f0104cf7:	00 e0                	add    %ah,%al
f0104cf9:	ff                   	(bad)  
f0104cfa:	ff                   	(bad)  
f0104cfb:	ff 74 14 00          	pushl  0x0(%esp,%edx,1)
f0104cff:	00 80 00 00 00 dc    	add    %al,-0x24000000(%eax)
f0104d05:	ff                   	(bad)  
f0104d06:	ff                   	(bad)  
f0104d07:	ff                   	(bad)  
f0104d08:	7f 14                	jg     f0104d1e <__STAB_BEGIN__+0x263e>
f0104d0a:	00 00                	add    %al,(%eax)
f0104d0c:	80 00 00             	addb   $0x0,(%eax)
f0104d0f:	00 d8                	add    %bl,%al
f0104d11:	ff                   	(bad)  
f0104d12:	ff                   	(bad)  
f0104d13:	ff 8a 14 00 00 80    	decl   -0x7fffffec(%edx)
f0104d19:	00 00                	add    %al,(%eax)
f0104d1b:	00 d4                	add    %dl,%ah
f0104d1d:	ff                   	(bad)  
f0104d1e:	ff                   	(bad)  
f0104d1f:	ff 96 14 00 00 80    	call   *-0x7fffffec(%esi)
f0104d25:	00 00                	add    %al,(%eax)
f0104d27:	00 d0                	add    %dl,%al
f0104d29:	ff                   	(bad)  
f0104d2a:	ff                   	(bad)  
f0104d2b:	ff a2 14 00 00 40    	jmp    *0x40000014(%edx)
f0104d31:	00 00                	add    %al,(%eax)
f0104d33:	00 06                	add    %al,(%esi)
f0104d35:	00 00                	add    %al,(%eax)
f0104d37:	00 af 14 00 00 40    	add    %ch,0x40000014(%edi)
f0104d3d:	00 00                	add    %al,(%eax)
f0104d3f:	00 03                	add    %al,(%ebx)
f0104d41:	00 00                	add    %al,(%eax)
f0104d43:	00 00                	add    %al,(%eax)
f0104d45:	00 00                	add    %al,(%eax)
f0104d47:	00 c0                	add    %al,%al
	...
f0104d51:	00 00                	add    %al,(%eax)
f0104d53:	00 e0                	add    %ah,%al
f0104d55:	00 00                	add    %al,(%eax)
f0104d57:	00 37                	add    %dh,(%edi)
f0104d59:	02 00                	add    (%eax),%al
f0104d5b:	00 00                	add    %al,(%eax)
f0104d5d:	00 00                	add    %al,(%eax)
f0104d5f:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
f0104d63:	00 f5                	add    %dh,%ch
f0104d65:	0e                   	push   %cs
f0104d66:	10 f0                	adc    %dh,%al
f0104d68:	bc 14 00 00 64       	mov    $0x64000014,%esp
f0104d6d:	00 02                	add    %al,(%edx)
f0104d6f:	00 00                	add    %al,(%eax)
f0104d71:	0f 10 f0             	movups %xmm0,%xmm6
f0104d74:	31 00                	xor    %eax,(%eax)
f0104d76:	00 00                	add    %al,(%eax)
f0104d78:	3c 00                	cmp    $0x0,%al
f0104d7a:	00 00                	add    %al,(%eax)
f0104d7c:	00 00                	add    %al,(%eax)
f0104d7e:	00 00                	add    %al,(%eax)
f0104d80:	40                   	inc    %eax
f0104d81:	00 00                	add    %al,(%eax)
f0104d83:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0104d89:	00 00                	add    %al,(%eax)
f0104d8b:	00 6a 00             	add    %ch,0x0(%edx)
f0104d8e:	00 00                	add    %al,(%eax)
f0104d90:	80 00 00             	addb   $0x0,(%eax)
f0104d93:	00 00                	add    %al,(%eax)
f0104d95:	00 00                	add    %al,(%eax)
f0104d97:	00 84 00 00 00 80 00 	add    %al,0x800000(%eax,%eax,1)
f0104d9e:	00 00                	add    %al,(%eax)
f0104da0:	00 00                	add    %al,(%eax)
f0104da2:	00 00                	add    %al,(%eax)
f0104da4:	b3 00                	mov    $0x0,%bl
f0104da6:	00 00                	add    %al,(%eax)
f0104da8:	80 00 00             	addb   $0x0,(%eax)
f0104dab:	00 00                	add    %al,(%eax)
f0104dad:	00 00                	add    %al,(%eax)
f0104daf:	00 dc                	add    %bl,%ah
f0104db1:	00 00                	add    %al,(%eax)
f0104db3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0104db9:	00 00                	add    %al,(%eax)
f0104dbb:	00 0a                	add    %cl,(%edx)
f0104dbd:	01 00                	add    %eax,(%eax)
f0104dbf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0104dc5:	00 00                	add    %al,(%eax)
f0104dc7:	00 35 01 00 00 80    	add    %dh,0x80000001
f0104dcd:	00 00                	add    %al,(%eax)
f0104dcf:	00 00                	add    %al,(%eax)
f0104dd1:	00 00                	add    %al,(%eax)
f0104dd3:	00 60 01             	add    %ah,0x1(%eax)
f0104dd6:	00 00                	add    %al,(%eax)
f0104dd8:	80 00 00             	addb   $0x0,(%eax)
f0104ddb:	00 00                	add    %al,(%eax)
f0104ddd:	00 00                	add    %al,(%eax)
f0104ddf:	00 86 01 00 00 80    	add    %al,-0x7fffffff(%esi)
f0104de5:	00 00                	add    %al,(%eax)
f0104de7:	00 00                	add    %al,(%eax)
f0104de9:	00 00                	add    %al,(%eax)
f0104deb:	00 b0 01 00 00 80    	add    %dh,-0x7fffffff(%eax)
f0104df1:	00 00                	add    %al,(%eax)
f0104df3:	00 00                	add    %al,(%eax)
f0104df5:	00 00                	add    %al,(%eax)
f0104df7:	00 d6                	add    %dl,%dh
f0104df9:	01 00                	add    %eax,(%eax)
f0104dfb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0104e01:	00 00                	add    %al,(%eax)
f0104e03:	00 fb                	add    %bh,%bl
f0104e05:	01 00                	add    %eax,(%eax)
f0104e07:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0104e0d:	00 00                	add    %al,(%eax)
f0104e0f:	00 15 02 00 00 80    	add    %dl,0x80000002
f0104e15:	00 00                	add    %al,(%eax)
f0104e17:	00 00                	add    %al,(%eax)
f0104e19:	00 00                	add    %al,(%eax)
f0104e1b:	00 30                	add    %dh,(%eax)
f0104e1d:	02 00                	add    (%eax),%al
f0104e1f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0104e25:	00 00                	add    %al,(%eax)
f0104e27:	00 51 02             	add    %dl,0x2(%ecx)
f0104e2a:	00 00                	add    %al,(%eax)
f0104e2c:	80 00 00             	addb   $0x0,(%eax)
f0104e2f:	00 00                	add    %al,(%eax)
f0104e31:	00 00                	add    %al,(%eax)
f0104e33:	00 70 02             	add    %dh,0x2(%eax)
f0104e36:	00 00                	add    %al,(%eax)
f0104e38:	80 00 00             	addb   $0x0,(%eax)
f0104e3b:	00 00                	add    %al,(%eax)
f0104e3d:	00 00                	add    %al,(%eax)
f0104e3f:	00 8f 02 00 00 80    	add    %cl,-0x7ffffffe(%edi)
f0104e45:	00 00                	add    %al,(%eax)
f0104e47:	00 00                	add    %al,(%eax)
f0104e49:	00 00                	add    %al,(%eax)
f0104e4b:	00 b0 02 00 00 80    	add    %dh,-0x7ffffffe(%eax)
f0104e51:	00 00                	add    %al,(%eax)
f0104e53:	00 00                	add    %al,(%eax)
f0104e55:	00 00                	add    %al,(%eax)
f0104e57:	00 d0                	add    %dl,%al
f0104e59:	02 00                	add    (%eax),%al
f0104e5b:	00 c2                	add    %al,%dl
f0104e5d:	00 00                	add    %al,(%eax)
f0104e5f:	00 37                	add    %dh,(%edi)
f0104e61:	53                   	push   %ebx
f0104e62:	00 00                	add    %al,(%eax)
f0104e64:	e3 0a                	jecxz  f0104e70 <__STAB_BEGIN__+0x2790>
f0104e66:	00 00                	add    %al,(%eax)
f0104e68:	c2 00 00             	ret    $0x0
f0104e6b:	00 00                	add    %al,(%eax)
f0104e6d:	00 00                	add    %al,(%eax)
f0104e6f:	00 f1                	add    %dh,%cl
f0104e71:	0a 00                	or     (%eax),%al
f0104e73:	00 c2                	add    %al,%dl
f0104e75:	00 00                	add    %al,(%eax)
f0104e77:	00 50 06             	add    %dl,0x6(%eax)
f0104e7a:	00 00                	add    %al,(%eax)
f0104e7c:	cb                   	lret   
f0104e7d:	14 00                	adc    $0x0,%al
f0104e7f:	00 82 00 00 00 2c    	add    %al,0x2c000000(%edx)
f0104e85:	1a 00                	sbb    (%eax),%al
f0104e87:	00 d9                	add    %bl,%cl
f0104e89:	14 00                	adc    $0x0,%al
f0104e8b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0104e91:	00 00                	add    %al,(%eax)
f0104e93:	00 00                	add    %al,(%eax)
f0104e95:	00 00                	add    %al,(%eax)
f0104e97:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
f0104e9d:	00 00                	add    %al,(%eax)
f0104e9f:	00 3b                	add    %bh,(%ebx)
f0104ea1:	15 00 00 80 00       	adc    $0x800000,%eax
f0104ea6:	00 00                	add    %al,(%eax)
f0104ea8:	00 00                	add    %al,(%eax)
f0104eaa:	00 00                	add    %al,(%eax)
f0104eac:	82                   	(bad)  
f0104ead:	15 00 00 24 00       	adc    $0x240000,%eax
f0104eb2:	00 00                	add    %al,(%eax)
f0104eb4:	00 0f                	add    %cl,(%edi)
f0104eb6:	10 f0                	adc    %dh,%al
f0104eb8:	99                   	cltd   
f0104eb9:	15 00 00 a0 00       	adc    $0xa00000,%eax
f0104ebe:	00 00                	add    %al,(%eax)
f0104ec0:	e4 ff                	in     $0xff,%al
f0104ec2:	ff                   	(bad)  
f0104ec3:	ff b7 15 00 00 40    	pushl  0x40000015(%edi)
f0104ec9:	00 00                	add    %al,(%eax)
f0104ecb:	00 07                	add    %al,(%edi)
f0104ecd:	00 00                	add    %al,(%eax)
f0104ecf:	00 ce                	add    %cl,%dh
f0104ed1:	15 00 00 a0 00       	adc    $0xa00000,%eax
f0104ed6:	00 00                	add    %al,(%eax)
f0104ed8:	08 00                	or     %al,(%eax)
f0104eda:	00 00                	add    %al,(%eax)
f0104edc:	d9 15 00 00 a0 00    	fsts   0xa00000
f0104ee2:	00 00                	add    %al,(%eax)
f0104ee4:	10 00                	adc    %al,(%eax)
f0104ee6:	00 00                	add    %al,(%eax)
f0104ee8:	e5 15                	in     $0x15,%eax
f0104eea:	00 00                	add    %al,(%eax)
f0104eec:	a0 00 00 00 14       	mov    0x14000000,%al
f0104ef1:	00 00                	add    %al,(%eax)
f0104ef3:	00 f2                	add    %dh,%dl
f0104ef5:	15 00 00 a0 00       	adc    $0xa00000,%eax
f0104efa:	00 00                	add    %al,(%eax)
f0104efc:	18 00                	sbb    %al,(%eax)
f0104efe:	00 00                	add    %al,(%eax)
f0104f00:	fe                   	(bad)  
f0104f01:	15 00 00 a0 00       	adc    $0xa00000,%eax
f0104f06:	00 00                	add    %al,(%eax)
f0104f08:	1c 00                	sbb    $0x0,%al
f0104f0a:	00 00                	add    %al,(%eax)
f0104f0c:	13 16                	adc    (%esi),%edx
f0104f0e:	00 00                	add    %al,(%eax)
f0104f10:	a0 00 00 00 20       	mov    0x20000000,%al
f0104f15:	00 00                	add    %al,(%eax)
f0104f17:	00 00                	add    %al,(%eax)
f0104f19:	00 00                	add    %al,(%eax)
f0104f1b:	00 44 00 22          	add    %al,0x22(%eax,%eax,1)
	...
f0104f27:	00 44 00 24          	add    %al,0x24(%eax,%eax,1)
f0104f2b:	00 1d 00 00 00 00    	add    %bl,0x0
f0104f31:	00 00                	add    %al,(%eax)
f0104f33:	00 44 00 25          	add    %al,0x25(%eax,%eax,1)
f0104f37:	00 30                	add    %dh,(%eax)
f0104f39:	00 00                	add    %al,(%eax)
f0104f3b:	00 00                	add    %al,(%eax)
f0104f3d:	00 00                	add    %al,(%eax)
f0104f3f:	00 44 00 26          	add    %al,0x26(%eax,%eax,1)
f0104f43:	00 36                	add    %dh,(%esi)
f0104f45:	00 00                	add    %al,(%eax)
f0104f47:	00 00                	add    %al,(%eax)
f0104f49:	00 00                	add    %al,(%eax)
f0104f4b:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
f0104f4f:	00 a0 00 00 00 00    	add    %ah,0x0(%eax)
f0104f55:	00 00                	add    %al,(%eax)
f0104f57:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
f0104f5b:	00 e2                	add    %ah,%dl
f0104f5d:	00 00                	add    %al,(%eax)
f0104f5f:	00 00                	add    %al,(%eax)
f0104f61:	00 00                	add    %al,(%eax)
f0104f63:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
f0104f67:	00 ec                	add    %ch,%ah
f0104f69:	00 00                	add    %al,(%eax)
f0104f6b:	00 00                	add    %al,(%eax)
f0104f6d:	00 00                	add    %al,(%eax)
f0104f6f:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
f0104f73:	00 f8                	add    %bh,%al
f0104f75:	00 00                	add    %al,(%eax)
f0104f77:	00 00                	add    %al,(%eax)
f0104f79:	00 00                	add    %al,(%eax)
f0104f7b:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
f0104f7f:	00 fd                	add    %bh,%ch
f0104f81:	00 00                	add    %al,(%eax)
f0104f83:	00 00                	add    %al,(%eax)
f0104f85:	00 00                	add    %al,(%eax)
f0104f87:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
f0104f8b:	00 0d 01 00 00 00    	add    %cl,0x1
f0104f91:	00 00                	add    %al,(%eax)
f0104f93:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
f0104f97:	00 1a                	add    %bl,(%edx)
f0104f99:	01 00                	add    %eax,(%eax)
f0104f9b:	00 00                	add    %al,(%eax)
f0104f9d:	00 00                	add    %al,(%eax)
f0104f9f:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
f0104fa3:	00 26                	add    %ah,(%esi)
f0104fa5:	01 00                	add    %eax,(%eax)
f0104fa7:	00 4a 0d             	add    %cl,0xd(%edx)
f0104faa:	00 00                	add    %al,(%eax)
f0104fac:	40                   	inc    %eax
f0104fad:	00 00                	add    %al,(%eax)
f0104faf:	00 06                	add    %al,(%esi)
f0104fb1:	00 00                	add    %al,(%eax)
f0104fb3:	00 22                	add    %ah,(%edx)
f0104fb5:	16                   	push   %ss
f0104fb6:	00 00                	add    %al,(%eax)
f0104fb8:	40                   	inc    %eax
	...
f0104fc1:	00 00                	add    %al,(%eax)
f0104fc3:	00 c0                	add    %al,%al
	...
f0104fcd:	00 00                	add    %al,(%eax)
f0104fcf:	00 e0                	add    %ah,%al
f0104fd1:	00 00                	add    %al,(%eax)
f0104fd3:	00 2e                	add    %ch,(%esi)
f0104fd5:	01 00                	add    %eax,(%eax)
f0104fd7:	00 2e                	add    %ch,(%esi)
f0104fd9:	16                   	push   %ss
f0104fda:	00 00                	add    %al,(%eax)
f0104fdc:	24 00                	and    $0x0,%al
f0104fde:	00 00                	add    %al,(%eax)
f0104fe0:	2e 10 10             	adc    %dl,%cs:(%eax)
f0104fe3:	f0 3f                	lock aas 
f0104fe5:	16                   	push   %ss
f0104fe6:	00 00                	add    %al,(%eax)
f0104fe8:	a0 00 00 00 d4       	mov    0xd4000000,%al
f0104fed:	ff                   	(bad)  
f0104fee:	ff                   	(bad)  
f0104fef:	ff 4d 16             	decl   0x16(%ebp)
f0104ff2:	00 00                	add    %al,(%eax)
f0104ff4:	40                   	inc    %eax
f0104ff5:	00 00                	add    %al,(%eax)
f0104ff7:	00 06                	add    %al,(%esi)
f0104ff9:	00 00                	add    %al,(%eax)
f0104ffb:	00 ce                	add    %cl,%dh
f0104ffd:	15 00 00 a0 00       	adc    $0xa00000,%eax
f0105002:	00 00                	add    %al,(%eax)
f0105004:	08 00                	or     %al,(%eax)
f0105006:	00 00                	add    %al,(%eax)
f0105008:	d9 15 00 00 a0 00    	fsts   0xa00000
f010500e:	00 00                	add    %al,(%eax)
f0105010:	10 00                	adc    %al,(%eax)
f0105012:	00 00                	add    %al,(%eax)
f0105014:	e5 15                	in     $0x15,%eax
f0105016:	00 00                	add    %al,(%eax)
f0105018:	a0 00 00 00 14       	mov    0x14000000,%al
f010501d:	00 00                	add    %al,(%eax)
f010501f:	00 f2                	add    %dh,%dl
f0105021:	15 00 00 a0 00       	adc    $0xa00000,%eax
f0105026:	00 00                	add    %al,(%eax)
f0105028:	18 00                	sbb    %al,(%eax)
f010502a:	00 00                	add    %al,(%eax)
f010502c:	00 00                	add    %al,(%eax)
f010502e:	00 00                	add    %al,(%eax)
f0105030:	44                   	inc    %esp
f0105031:	00 3a                	add    %bh,(%edx)
	...
f010503b:	00 44 00 3f          	add    %al,0x3f(%eax,%eax,1)
f010503f:	00 23                	add    %ah,(%ebx)
f0105041:	00 00                	add    %al,(%eax)
f0105043:	00 00                	add    %al,(%eax)
f0105045:	00 00                	add    %al,(%eax)
f0105047:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
f010504b:	00 31                	add    %dh,(%ecx)
f010504d:	00 00                	add    %al,(%eax)
f010504f:	00 00                	add    %al,(%eax)
f0105051:	00 00                	add    %al,(%eax)
f0105053:	00 44 00 41          	add    %al,0x41(%eax,%eax,1)
f0105057:	00 36                	add    %dh,(%esi)
f0105059:	00 00                	add    %al,(%eax)
f010505b:	00 00                	add    %al,(%eax)
f010505d:	00 00                	add    %al,(%eax)
f010505f:	00 44 00 43          	add    %al,0x43(%eax,%eax,1)
f0105063:	00 3e                	add    %bh,(%esi)
f0105065:	00 00                	add    %al,(%eax)
f0105067:	00 00                	add    %al,(%eax)
f0105069:	00 00                	add    %al,(%eax)
f010506b:	00 44 00 44          	add    %al,0x44(%eax,%eax,1)
f010506f:	00 73 00             	add    %dh,0x0(%ebx)
f0105072:	00 00                	add    %al,(%eax)
f0105074:	00 00                	add    %al,(%eax)
f0105076:	00 00                	add    %al,(%eax)
f0105078:	44                   	inc    %esp
f0105079:	00 48 00             	add    %cl,0x0(%eax)
f010507c:	78 00                	js     f010507e <__STAB_BEGIN__+0x299e>
f010507e:	00 00                	add    %al,(%eax)
f0105080:	00 00                	add    %al,(%eax)
f0105082:	00 00                	add    %al,(%eax)
f0105084:	44                   	inc    %esp
f0105085:	00 4c 00 89          	add    %cl,-0x77(%eax,%eax,1)
f0105089:	00 00                	add    %al,(%eax)
f010508b:	00 00                	add    %al,(%eax)
f010508d:	00 00                	add    %al,(%eax)
f010508f:	00 44 00 49          	add    %al,0x49(%eax,%eax,1)
f0105093:	00 96 00 00 00 00    	add    %dl,0x0(%esi)
f0105099:	00 00                	add    %al,(%eax)
f010509b:	00 44 00 4d          	add    %al,0x4d(%eax,%eax,1)
f010509f:	00 f5                	add    %dh,%ch
f01050a1:	00 00                	add    %al,(%eax)
f01050a3:	00 00                	add    %al,(%eax)
f01050a5:	00 00                	add    %al,(%eax)
f01050a7:	00 44 00 4c          	add    %al,0x4c(%eax,%eax,1)
f01050ab:	00 ff                	add    %bh,%bh
f01050ad:	00 00                	add    %al,(%eax)
f01050af:	00 00                	add    %al,(%eax)
f01050b1:	00 00                	add    %al,(%eax)
f01050b3:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
f01050b7:	00 06                	add    %al,(%esi)
f01050b9:	01 00                	add    %eax,(%eax)
f01050bb:	00 00                	add    %al,(%eax)
f01050bd:	00 00                	add    %al,(%eax)
f01050bf:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
f01050c3:	00 40 01             	add    %al,0x1(%eax)
f01050c6:	00 00                	add    %al,(%eax)
f01050c8:	5c                   	pop    %esp
f01050c9:	16                   	push   %ss
f01050ca:	00 00                	add    %al,(%eax)
f01050cc:	80 00 00             	addb   $0x0,(%eax)
f01050cf:	00 e4                	add    %ah,%ah
f01050d1:	ff                   	(bad)  
f01050d2:	ff                   	(bad)  
f01050d3:	ff 67 16             	jmp    *0x16(%edi)
f01050d6:	00 00                	add    %al,(%eax)
f01050d8:	80 00 00             	addb   $0x0,(%eax)
f01050db:	00 e0                	add    %ah,%al
f01050dd:	ff                   	(bad)  
f01050de:	ff                   	(bad)  
f01050df:	ff 22                	jmp    *(%edx)
f01050e1:	16                   	push   %ss
f01050e2:	00 00                	add    %al,(%eax)
f01050e4:	40                   	inc    %eax
f01050e5:	00 00                	add    %al,(%eax)
f01050e7:	00 02                	add    %al,(%edx)
f01050e9:	00 00                	add    %al,(%eax)
f01050eb:	00 73 16             	add    %dh,0x16(%ebx)
f01050ee:	00 00                	add    %al,(%eax)
f01050f0:	40                   	inc    %eax
f01050f1:	00 00                	add    %al,(%eax)
f01050f3:	00 03                	add    %al,(%ebx)
f01050f5:	00 00                	add    %al,(%eax)
f01050f7:	00 80 16 00 00 40    	add    %al,0x40000016(%eax)
f01050fd:	00 00                	add    %al,(%eax)
f01050ff:	00 07                	add    %al,(%edi)
f0105101:	00 00                	add    %al,(%eax)
f0105103:	00 00                	add    %al,(%eax)
f0105105:	00 00                	add    %al,(%eax)
f0105107:	00 c0                	add    %al,%al
	...
f0105111:	00 00                	add    %al,(%eax)
f0105113:	00 e0                	add    %ah,%al
f0105115:	00 00                	add    %al,(%eax)
f0105117:	00 48 01             	add    %cl,0x1(%eax)
f010511a:	00 00                	add    %al,(%eax)
f010511c:	8c 16                	mov    %ss,(%esi)
f010511e:	00 00                	add    %al,(%eax)
f0105120:	24 00                	and    $0x0,%al
f0105122:	00 00                	add    %al,(%eax)
f0105124:	76 11                	jbe    f0105137 <__STAB_BEGIN__+0x2a57>
f0105126:	10 f0                	adc    %dh,%al
f0105128:	9b                   	fwait
f0105129:	16                   	push   %ss
f010512a:	00 00                	add    %al,(%eax)
f010512c:	40                   	inc    %eax
f010512d:	00 00                	add    %al,(%eax)
f010512f:	00 00                	add    %al,(%eax)
f0105131:	00 00                	add    %al,(%eax)
f0105133:	00 ad 16 00 00 40    	add    %ch,0x40000016(%ebp)
f0105139:	00 00                	add    %al,(%eax)
f010513b:	00 02                	add    %al,(%edx)
f010513d:	00 00                	add    %al,(%eax)
f010513f:	00 00                	add    %al,(%eax)
f0105141:	00 00                	add    %al,(%eax)
f0105143:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
	...
f010514f:	00 44 00 59          	add    %al,0x59(%eax,%eax,1)
f0105153:	00 03                	add    %al,(%ebx)
f0105155:	00 00                	add    %al,(%eax)
f0105157:	00 00                	add    %al,(%eax)
f0105159:	00 00                	add    %al,(%eax)
f010515b:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
f010515f:	00 08                	add    %cl,(%eax)
f0105161:	00 00                	add    %al,(%eax)
f0105163:	00 00                	add    %al,(%eax)
f0105165:	00 00                	add    %al,(%eax)
f0105167:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
f010516b:	00 16                	add    %dl,(%esi)
f010516d:	00 00                	add    %al,(%eax)
f010516f:	00 00                	add    %al,(%eax)
f0105171:	00 00                	add    %al,(%eax)
f0105173:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
f0105177:	00 1a                	add    %bl,(%edx)
f0105179:	00 00                	add    %al,(%eax)
f010517b:	00 00                	add    %al,(%eax)
f010517d:	00 00                	add    %al,(%eax)
f010517f:	00 44 00 5e          	add    %al,0x5e(%eax,%eax,1)
f0105183:	00 2a                	add    %ch,(%edx)
f0105185:	00 00                	add    %al,(%eax)
f0105187:	00 00                	add    %al,(%eax)
f0105189:	00 00                	add    %al,(%eax)
f010518b:	00 44 00 5f          	add    %al,0x5f(%eax,%eax,1)
f010518f:	00 38                	add    %bh,(%eax)
f0105191:	00 00                	add    %al,(%eax)
f0105193:	00 ba 16 00 00 24    	add    %bh,0x24000016(%edx)
f0105199:	00 00                	add    %al,(%eax)
f010519b:	00 b0 11 10 f0 c8    	add    %dh,-0x370fefef(%eax)
f01051a1:	16                   	push   %ss
f01051a2:	00 00                	add    %al,(%eax)
f01051a4:	40                   	inc    %eax
f01051a5:	00 00                	add    %al,(%eax)
f01051a7:	00 00                	add    %al,(%eax)
f01051a9:	00 00                	add    %al,(%eax)
f01051ab:	00 ad 16 00 00 40    	add    %ch,0x40000016(%ebp)
f01051b1:	00 00                	add    %al,(%eax)
f01051b3:	00 02                	add    %al,(%edx)
f01051b5:	00 00                	add    %al,(%eax)
f01051b7:	00 00                	add    %al,(%eax)
f01051b9:	00 00                	add    %al,(%eax)
f01051bb:	00 44 00 65          	add    %al,0x65(%eax,%eax,1)
	...
f01051c7:	00 44 00 66          	add    %al,0x66(%eax,%eax,1)
f01051cb:	00 03                	add    %al,(%ebx)
f01051cd:	00 00                	add    %al,(%eax)
f01051cf:	00 00                	add    %al,(%eax)
f01051d1:	00 00                	add    %al,(%eax)
f01051d3:	00 44 00 67          	add    %al,0x67(%eax,%eax,1)
f01051d7:	00 08                	add    %cl,(%eax)
f01051d9:	00 00                	add    %al,(%eax)
f01051db:	00 00                	add    %al,(%eax)
f01051dd:	00 00                	add    %al,(%eax)
f01051df:	00 44 00 68          	add    %al,0x68(%eax,%eax,1)
f01051e3:	00 16                	add    %dl,(%esi)
f01051e5:	00 00                	add    %al,(%eax)
f01051e7:	00 00                	add    %al,(%eax)
f01051e9:	00 00                	add    %al,(%eax)
f01051eb:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
f01051ef:	00 1a                	add    %bl,(%edx)
f01051f1:	00 00                	add    %al,(%eax)
f01051f3:	00 00                	add    %al,(%eax)
f01051f5:	00 00                	add    %al,(%eax)
f01051f7:	00 44 00 6b          	add    %al,0x6b(%eax,%eax,1)
f01051fb:	00 2a                	add    %ch,(%edx)
f01051fd:	00 00                	add    %al,(%eax)
f01051ff:	00 00                	add    %al,(%eax)
f0105201:	00 00                	add    %al,(%eax)
f0105203:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
f0105207:	00 38                	add    %bh,(%eax)
f0105209:	00 00                	add    %al,(%eax)
f010520b:	00 d3                	add    %dl,%bl
f010520d:	16                   	push   %ss
f010520e:	00 00                	add    %al,(%eax)
f0105210:	24 00                	and    $0x0,%al
f0105212:	00 00                	add    %al,(%eax)
f0105214:	ea 11 10 f0 ba 12 00 	ljmp   $0x12,$0xbaf01011
f010521b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
f0105221:	00 00                	add    %al,(%eax)
f0105223:	00 e7                	add    %ah,%bh
f0105225:	16                   	push   %ss
f0105226:	00 00                	add    %al,(%eax)
f0105228:	a0 00 00 00 0c       	mov    0xc000000,%al
f010522d:	00 00                	add    %al,(%eax)
f010522f:	00 00                	add    %al,(%eax)
f0105231:	00 00                	add    %al,(%eax)
f0105233:	00 44 00 5f          	add    %al,0x5f(%eax,%eax,1)
f0105237:	01 00                	add    %eax,(%eax)
f0105239:	00 00                	add    %al,(%eax)
f010523b:	00 00                	add    %al,(%eax)
f010523d:	00 00                	add    %al,(%eax)
f010523f:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
f0105243:	01 06                	add    %eax,(%esi)
f0105245:	00 00                	add    %al,(%eax)
f0105247:	00 00                	add    %al,(%eax)
f0105249:	00 00                	add    %al,(%eax)
f010524b:	00 44 00 61          	add    %al,0x61(%eax,%eax,1)
f010524f:	01 0a                	add    %ecx,(%edx)
f0105251:	00 00                	add    %al,(%eax)
f0105253:	00 00                	add    %al,(%eax)
f0105255:	00 00                	add    %al,(%eax)
f0105257:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
f010525b:	01 11                	add    %edx,(%ecx)
f010525d:	00 00                	add    %al,(%eax)
f010525f:	00 00                	add    %al,(%eax)
f0105261:	00 00                	add    %al,(%eax)
f0105263:	00 44 00 63          	add    %al,0x63(%eax,%eax,1)
f0105267:	01 1b                	add    %ebx,(%ebx)
f0105269:	00 00                	add    %al,(%eax)
f010526b:	00 d7                	add    %dl,%bh
f010526d:	12 00                	adc    (%eax),%al
f010526f:	00 40 00             	add    %al,0x0(%eax)
f0105272:	00 00                	add    %al,(%eax)
f0105274:	01 00                	add    %eax,(%eax)
f0105276:	00 00                	add    %al,(%eax)
f0105278:	f9                   	stc    
f0105279:	16                   	push   %ss
f010527a:	00 00                	add    %al,(%eax)
f010527c:	40                   	inc    %eax
f010527d:	00 00                	add    %al,(%eax)
f010527f:	00 00                	add    %al,(%eax)
f0105281:	00 00                	add    %al,(%eax)
f0105283:	00 03                	add    %al,(%ebx)
f0105285:	17                   	pop    %ss
f0105286:	00 00                	add    %al,(%eax)
f0105288:	24 00                	and    $0x0,%al
f010528a:	00 00                	add    %al,(%eax)
f010528c:	07                   	pop    %es
f010528d:	12 10                	adc    (%eax),%dl
f010528f:	f0 3f                	lock aas 
f0105291:	16                   	push   %ss
f0105292:	00 00                	add    %al,(%eax)
f0105294:	a0 00 00 00 08       	mov    0x8000000,%al
f0105299:	00 00                	add    %al,(%eax)
f010529b:	00 15 17 00 00 a0    	add    %dl,0xa0000017
f01052a1:	00 00                	add    %al,(%eax)
f01052a3:	00 0c 00             	add    %cl,(%eax,%eax,1)
f01052a6:	00 00                	add    %al,(%eax)
f01052a8:	24 17                	and    $0x17,%al
f01052aa:	00 00                	add    %al,(%eax)
f01052ac:	a0 00 00 00 10       	mov    0x10000000,%al
f01052b1:	00 00                	add    %al,(%eax)
f01052b3:	00 74 12 00          	add    %dh,0x0(%edx,%edx,1)
f01052b7:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
f01052bd:	00 00                	add    %al,(%eax)
f01052bf:	00 00                	add    %al,(%eax)
f01052c1:	00 00                	add    %al,(%eax)
f01052c3:	00 44 00 74          	add    %al,0x74(%eax,%eax,1)
	...
f01052cf:	00 44 00 b8          	add    %al,-0x48(%eax,%eax,1)
f01052d3:	00 0f                	add    %cl,(%edi)
f01052d5:	00 00                	add    %al,(%eax)
f01052d7:	00 00                	add    %al,(%eax)
f01052d9:	00 00                	add    %al,(%eax)
f01052db:	00 44 00 7e          	add    %al,0x7e(%eax,%eax,1)
f01052df:	00 18                	add    %bl,(%eax)
f01052e1:	00 00                	add    %al,(%eax)
f01052e3:	00 00                	add    %al,(%eax)
f01052e5:	00 00                	add    %al,(%eax)
f01052e7:	00 44 00 80          	add    %al,-0x80(%eax,%eax,1)
f01052eb:	00 20                	add    %ah,(%eax)
f01052ed:	00 00                	add    %al,(%eax)
f01052ef:	00 00                	add    %al,(%eax)
f01052f1:	00 00                	add    %al,(%eax)
f01052f3:	00 44 00 7d          	add    %al,0x7d(%eax,%eax,1)
f01052f7:	00 2f                	add    %ch,(%edi)
f01052f9:	00 00                	add    %al,(%eax)
f01052fb:	00 00                	add    %al,(%eax)
f01052fd:	00 00                	add    %al,(%eax)
f01052ff:	00 44 00 8a          	add    %al,-0x76(%eax,%eax,1)
f0105303:	00 60 00             	add    %ah,0x0(%eax)
f0105306:	00 00                	add    %al,(%eax)
f0105308:	00 00                	add    %al,(%eax)
f010530a:	00 00                	add    %al,(%eax)
f010530c:	44                   	inc    %esp
f010530d:	00 a3 00 84 00 00    	add    %ah,0x8400(%ebx)
f0105313:	00 00                	add    %al,(%eax)
f0105315:	00 00                	add    %al,(%eax)
f0105317:	00 44 00 a4          	add    %al,-0x5c(%eax,%eax,1)
f010531b:	00 87 00 00 00 00    	add    %al,0x0(%edi)
f0105321:	00 00                	add    %al,(%eax)
f0105323:	00 44 00 a5          	add    %al,-0x5b(%eax,%eax,1)
f0105327:	00 8a 00 00 00 00    	add    %cl,0x0(%edx)
f010532d:	00 00                	add    %al,(%eax)
f010532f:	00 44 00 a0          	add    %al,-0x60(%eax,%eax,1)
f0105333:	00 9b 00 00 00 00    	add    %bl,0x0(%ebx)
f0105339:	00 00                	add    %al,(%eax)
f010533b:	00 44 00 a2          	add    %al,-0x5e(%eax,%eax,1)
f010533f:	00 9d 00 00 00 00    	add    %bl,0x0(%ebp)
f0105345:	00 00                	add    %al,(%eax)
f0105347:	00 44 00 a3          	add    %al,-0x5d(%eax,%eax,1)
f010534b:	00 a0 00 00 00 00    	add    %ah,0x0(%eax)
f0105351:	00 00                	add    %al,(%eax)
f0105353:	00 44 00 a4          	add    %al,-0x5c(%eax,%eax,1)
f0105357:	00 a7 00 00 00 00    	add    %ah,0x0(%edi)
f010535d:	00 00                	add    %al,(%eax)
f010535f:	00 44 00 a5          	add    %al,-0x5b(%eax,%eax,1)
f0105363:	00 aa 00 00 00 00    	add    %ch,0x0(%edx)
f0105369:	00 00                	add    %al,(%eax)
f010536b:	00 44 00 ab          	add    %al,-0x55(%eax,%eax,1)
f010536f:	00 b4 00 00 00 00 00 	add    %dh,0x0(%eax,%eax,1)
f0105376:	00 00                	add    %al,(%eax)
f0105378:	44                   	inc    %esp
f0105379:	00 ac 00 bf 00 00 00 	add    %ch,0xbf(%eax,%eax,1)
f0105380:	00 00                	add    %al,(%eax)
f0105382:	00 00                	add    %al,(%eax)
f0105384:	44                   	inc    %esp
f0105385:	00 af 00 c1 00 00    	add    %ch,0xc100(%edi)
f010538b:	00 00                	add    %al,(%eax)
f010538d:	00 00                	add    %al,(%eax)
f010538f:	00 44 00 b5          	add    %al,-0x4b(%eax,%eax,1)
f0105393:	00 d5                	add    %dl,%ch
f0105395:	00 00                	add    %al,(%eax)
f0105397:	00 00                	add    %al,(%eax)
f0105399:	00 00                	add    %al,(%eax)
f010539b:	00 44 00 b8          	add    %al,-0x48(%eax,%eax,1)
f010539f:	00 d7                	add    %dl,%bh
f01053a1:	00 00                	add    %al,(%eax)
f01053a3:	00 00                	add    %al,(%eax)
f01053a5:	00 00                	add    %al,(%eax)
f01053a7:	00 44 00 be          	add    %al,-0x42(%eax,%eax,1)
f01053ab:	00 e8                	add    %ch,%al
f01053ad:	00 00                	add    %al,(%eax)
f01053af:	00 00                	add    %al,(%eax)
f01053b1:	00 00                	add    %al,(%eax)
f01053b3:	00 44 00 bf          	add    %al,-0x41(%eax,%eax,1)
f01053b7:	00 ec                	add    %ch,%ah
f01053b9:	00 00                	add    %al,(%eax)
f01053bb:	00 00                	add    %al,(%eax)
f01053bd:	00 00                	add    %al,(%eax)
f01053bf:	00 44 00 c3          	add    %al,-0x3d(%eax,%eax,1)
f01053c3:	00 f4                	add    %dh,%ah
f01053c5:	00 00                	add    %al,(%eax)
f01053c7:	00 00                	add    %al,(%eax)
f01053c9:	00 00                	add    %al,(%eax)
f01053cb:	00 44 00 c4          	add    %al,-0x3c(%eax,%eax,1)
f01053cf:	00 0c 01             	add    %cl,(%ecx,%eax,1)
f01053d2:	00 00                	add    %al,(%eax)
f01053d4:	00 00                	add    %al,(%eax)
f01053d6:	00 00                	add    %al,(%eax)
f01053d8:	44                   	inc    %esp
f01053d9:	00 c8                	add    %cl,%al
f01053db:	00 14 01             	add    %dl,(%ecx,%eax,1)
f01053de:	00 00                	add    %al,(%eax)
f01053e0:	00 00                	add    %al,(%eax)
f01053e2:	00 00                	add    %al,(%eax)
f01053e4:	44                   	inc    %esp
f01053e5:	00 cb                	add    %cl,%bl
f01053e7:	00 28                	add    %ch,(%eax)
f01053e9:	01 00                	add    %eax,(%eax)
f01053eb:	00 00                	add    %al,(%eax)
f01053ed:	00 00                	add    %al,(%eax)
f01053ef:	00 44 00 cc          	add    %al,-0x34(%eax,%eax,1)
f01053f3:	00 38                	add    %bh,(%eax)
f01053f5:	01 00                	add    %eax,(%eax)
f01053f7:	00 00                	add    %al,(%eax)
f01053f9:	00 00                	add    %al,(%eax)
f01053fb:	00 44 00 cb          	add    %al,-0x35(%eax,%eax,1)
f01053ff:	00 56 01             	add    %dl,0x1(%esi)
f0105402:	00 00                	add    %al,(%eax)
f0105404:	00 00                	add    %al,(%eax)
f0105406:	00 00                	add    %al,(%eax)
f0105408:	44                   	inc    %esp
f0105409:	00 ce                	add    %cl,%dh
f010540b:	00 5b 01             	add    %bl,0x1(%ebx)
f010540e:	00 00                	add    %al,(%eax)
f0105410:	00 00                	add    %al,(%eax)
f0105412:	00 00                	add    %al,(%eax)
f0105414:	44                   	inc    %esp
f0105415:	00 d3                	add    %dl,%bl
f0105417:	00 8b 01 00 00 00    	add    %cl,0x1(%ebx)
f010541d:	00 00                	add    %al,(%eax)
f010541f:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
f0105423:	00 a4 01 00 00 00 00 	add    %ah,0x0(%ecx,%eax,1)
f010542a:	00 00                	add    %al,(%eax)
f010542c:	44                   	inc    %esp
f010542d:	00 d8                	add    %bl,%al
f010542f:	00 b0 01 00 00 00    	add    %dh,0x1(%eax)
f0105435:	00 00                	add    %al,(%eax)
f0105437:	00 44 00 d6          	add    %al,-0x2a(%eax,%eax,1)
f010543b:	00 c3                	add    %al,%bl
f010543d:	01 00                	add    %eax,(%eax)
f010543f:	00 00                	add    %al,(%eax)
f0105441:	00 00                	add    %al,(%eax)
f0105443:	00 44 00 d7          	add    %al,-0x29(%eax,%eax,1)
f0105447:	00 de                	add    %bl,%dh
f0105449:	01 00                	add    %eax,(%eax)
f010544b:	00 00                	add    %al,(%eax)
f010544d:	00 00                	add    %al,(%eax)
f010544f:	00 44 00 d6          	add    %al,-0x2a(%eax,%eax,1)
f0105453:	00 f6                	add    %dh,%dh
f0105455:	01 00                	add    %eax,(%eax)
f0105457:	00 00                	add    %al,(%eax)
f0105459:	00 00                	add    %al,(%eax)
f010545b:	00 44 00 d9          	add    %al,-0x27(%eax,%eax,1)
f010545f:	00 0c 02             	add    %cl,(%edx,%eax,1)
f0105462:	00 00                	add    %al,(%eax)
f0105464:	00 00                	add    %al,(%eax)
f0105466:	00 00                	add    %al,(%eax)
f0105468:	44                   	inc    %esp
f0105469:	00 da                	add    %bl,%dl
f010546b:	00 1a                	add    %bl,(%edx)
f010546d:	02 00                	add    (%eax),%al
f010546f:	00 00                	add    %al,(%eax)
f0105471:	00 00                	add    %al,(%eax)
f0105473:	00 44 00 d9          	add    %al,-0x27(%eax,%eax,1)
f0105477:	00 28                	add    %ch,(%eax)
f0105479:	02 00                	add    (%eax),%al
f010547b:	00 00                	add    %al,(%eax)
f010547d:	00 00                	add    %al,(%eax)
f010547f:	00 44 00 dc          	add    %al,-0x24(%eax,%eax,1)
f0105483:	00 2b                	add    %ch,(%ebx)
f0105485:	02 00                	add    (%eax),%al
f0105487:	00 00                	add    %al,(%eax)
f0105489:	00 00                	add    %al,(%eax)
f010548b:	00 44 00 d8          	add    %al,-0x28(%eax,%eax,1)
f010548f:	00 35 02 00 00 00    	add    %dh,0x2
f0105495:	00 00                	add    %al,(%eax)
f0105497:	00 44 00 dd          	add    %al,-0x23(%eax,%eax,1)
f010549b:	00 48 02             	add    %cl,0x2(%eax)
f010549e:	00 00                	add    %al,(%eax)
f01054a0:	00 00                	add    %al,(%eax)
f01054a2:	00 00                	add    %al,(%eax)
f01054a4:	44                   	inc    %esp
f01054a5:	00 d8                	add    %bl,%al
f01054a7:	00 53 02             	add    %dl,0x2(%ebx)
f01054aa:	00 00                	add    %al,(%eax)
f01054ac:	00 00                	add    %al,(%eax)
f01054ae:	00 00                	add    %al,(%eax)
f01054b0:	44                   	inc    %esp
f01054b1:	00 de                	add    %bl,%dh
f01054b3:	00 75 02             	add    %dh,0x2(%ebp)
f01054b6:	00 00                	add    %al,(%eax)
f01054b8:	00 00                	add    %al,(%eax)
f01054ba:	00 00                	add    %al,(%eax)
f01054bc:	44                   	inc    %esp
f01054bd:	00 dd                	add    %bl,%ch
f01054bf:	00 82 02 00 00 00    	add    %al,0x2(%edx)
f01054c5:	00 00                	add    %al,(%eax)
f01054c7:	00 44 00 e3          	add    %al,-0x1d(%eax,%eax,1)
f01054cb:	00 94 02 00 00 00 00 	add    %dl,0x0(%edx,%eax,1)
f01054d2:	00 00                	add    %al,(%eax)
f01054d4:	44                   	inc    %esp
f01054d5:	00 e4                	add    %ah,%ah
f01054d7:	00 ae 02 00 00 00    	add    %ch,0x2(%esi)
f01054dd:	00 00                	add    %al,(%eax)
f01054df:	00 44 00 e5          	add    %al,-0x1b(%eax,%eax,1)
f01054e3:	00 b8 02 00 00 00    	add    %bh,0x2(%eax)
f01054e9:	00 00                	add    %al,(%eax)
f01054eb:	00 44 00 e6          	add    %al,-0x1a(%eax,%eax,1)
f01054ef:	00 c6                	add    %al,%dh
f01054f1:	02 00                	add    (%eax),%al
f01054f3:	00 00                	add    %al,(%eax)
f01054f5:	00 00                	add    %al,(%eax)
f01054f7:	00 44 00 ed          	add    %al,-0x13(%eax,%eax,1)
f01054fb:	00 e0                	add    %ah,%al
f01054fd:	02 00                	add    (%eax),%al
f01054ff:	00 00                	add    %al,(%eax)
f0105501:	00 00                	add    %al,(%eax)
f0105503:	00 44 00 ef          	add    %al,-0x11(%eax,%eax,1)
f0105507:	00 f4                	add    %dh,%ah
f0105509:	02 00                	add    (%eax),%al
f010550b:	00 00                	add    %al,(%eax)
f010550d:	00 00                	add    %al,(%eax)
f010550f:	00 44 00 f5          	add    %al,-0xb(%eax,%eax,1)
f0105513:	00 f9                	add    %bh,%cl
f0105515:	02 00                	add    (%eax),%al
f0105517:	00 00                	add    %al,(%eax)
f0105519:	00 00                	add    %al,(%eax)
f010551b:	00 44 00 f6          	add    %al,-0xa(%eax,%eax,1)
f010551f:	00 07                	add    %al,(%edi)
f0105521:	03 00                	add    (%eax),%eax
f0105523:	00 00                	add    %al,(%eax)
f0105525:	00 00                	add    %al,(%eax)
f0105527:	00 44 00 f8          	add    %al,-0x8(%eax,%eax,1)
f010552b:	00 1b                	add    %bl,(%ebx)
f010552d:	03 00                	add    (%eax),%eax
f010552f:	00 00                	add    %al,(%eax)
f0105531:	00 00                	add    %al,(%eax)
f0105533:	00 44 00 fc          	add    %al,-0x4(%eax,%eax,1)
f0105537:	00 20                	add    %ah,(%eax)
f0105539:	03 00                	add    (%eax),%eax
f010553b:	00 00                	add    %al,(%eax)
f010553d:	00 00                	add    %al,(%eax)
f010553f:	00 44 00 fd          	add    %al,-0x3(%eax,%eax,1)
f0105543:	00 2e                	add    %ch,(%esi)
f0105545:	03 00                	add    (%eax),%eax
f0105547:	00 00                	add    %al,(%eax)
f0105549:	00 00                	add    %al,(%eax)
f010554b:	00 44 00 fe          	add    %al,-0x2(%eax,%eax,1)
f010554f:	00 3c 03             	add    %bh,(%ebx,%eax,1)
f0105552:	00 00                	add    %al,(%eax)
f0105554:	00 00                	add    %al,(%eax)
f0105556:	00 00                	add    %al,(%eax)
f0105558:	44                   	inc    %esp
f0105559:	00 01                	add    %al,(%ecx)
f010555b:	01 51 03             	add    %edx,0x3(%ecx)
f010555e:	00 00                	add    %al,(%eax)
f0105560:	00 00                	add    %al,(%eax)
f0105562:	00 00                	add    %al,(%eax)
f0105564:	44                   	inc    %esp
f0105565:	00 06                	add    %al,(%esi)
f0105567:	01 56 03             	add    %edx,0x3(%esi)
f010556a:	00 00                	add    %al,(%eax)
f010556c:	00 00                	add    %al,(%eax)
f010556e:	00 00                	add    %al,(%eax)
f0105570:	44                   	inc    %esp
f0105571:	00 09                	add    %cl,(%ecx)
f0105573:	01 6a 03             	add    %ebp,0x3(%edx)
f0105576:	00 00                	add    %al,(%eax)
f0105578:	00 00                	add    %al,(%eax)
f010557a:	00 00                	add    %al,(%eax)
f010557c:	44                   	inc    %esp
f010557d:	00 0a                	add    %cl,(%edx)
f010557f:	01 91 03 00 00 00    	add    %edx,0x3(%ecx)
f0105585:	00 00                	add    %al,(%eax)
f0105587:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
f010558b:	01 99 03 00 00 00    	add    %ebx,0x3(%ecx)
f0105591:	00 00                	add    %al,(%eax)
f0105593:	00 44 00 21          	add    %al,0x21(%eax,%eax,1)
f0105597:	01 a4 03 00 00 00 00 	add    %esp,0x0(%ebx,%eax,1)
f010559e:	00 00                	add    %al,(%eax)
f01055a0:	44                   	inc    %esp
f01055a1:	00 23                	add    %ah,(%ebx)
f01055a3:	01 b2 03 00 00 00    	add    %esi,0x3(%edx)
f01055a9:	00 00                	add    %al,(%eax)
f01055ab:	00 44 00 22          	add    %al,0x22(%eax,%eax,1)
f01055af:	01 ba 03 00 00 00    	add    %edi,0x3(%edx)
f01055b5:	00 00                	add    %al,(%eax)
f01055b7:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
f01055bb:	01 c9                	add    %ecx,%ecx
f01055bd:	03 00                	add    (%eax),%eax
f01055bf:	00 00                	add    %al,(%eax)
f01055c1:	00 00                	add    %al,(%eax)
f01055c3:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
f01055c7:	01 d8                	add    %ebx,%eax
f01055c9:	03 00                	add    (%eax),%eax
f01055cb:	00 00                	add    %al,(%eax)
f01055cd:	00 00                	add    %al,(%eax)
f01055cf:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
f01055d3:	01 e0                	add    %esp,%eax
f01055d5:	03 00                	add    (%eax),%eax
f01055d7:	00 00                	add    %al,(%eax)
f01055d9:	00 00                	add    %al,(%eax)
f01055db:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
f01055df:	01 ea                	add    %ebp,%edx
f01055e1:	03 00                	add    (%eax),%eax
f01055e3:	00 00                	add    %al,(%eax)
f01055e5:	00 00                	add    %al,(%eax)
f01055e7:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
f01055eb:	01 f0                	add    %esi,%eax
f01055ed:	03 00                	add    (%eax),%eax
f01055ef:	00 00                	add    %al,(%eax)
f01055f1:	00 00                	add    %al,(%eax)
f01055f3:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
f01055f7:	01 f5                	add    %esi,%ebp
f01055f9:	03 00                	add    (%eax),%eax
f01055fb:	00 00                	add    %al,(%eax)
f01055fd:	00 00                	add    %al,(%eax)
f01055ff:	00 44 00 2f          	add    %al,0x2f(%eax,%eax,1)
f0105603:	01 fd                	add    %edi,%ebp
f0105605:	03 00                	add    (%eax),%eax
f0105607:	00 00                	add    %al,(%eax)
f0105609:	00 00                	add    %al,(%eax)
f010560b:	00 44 00 33          	add    %al,0x33(%eax,%eax,1)
f010560f:	01 05 04 00 00 00    	add    %eax,0x4
f0105615:	00 00                	add    %al,(%eax)
f0105617:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
f010561b:	01 12                	add    %edx,(%edx)
f010561d:	04 00                	add    $0x0,%al
f010561f:	00 00                	add    %al,(%eax)
f0105621:	00 00                	add    %al,(%eax)
f0105623:	00 44 00 39          	add    %al,0x39(%eax,%eax,1)
f0105627:	01 1a                	add    %ebx,(%edx)
f0105629:	04 00                	add    $0x0,%al
f010562b:	00 00                	add    %al,(%eax)
f010562d:	00 00                	add    %al,(%eax)
f010562f:	00 44 00 3a          	add    %al,0x3a(%eax,%eax,1)
f0105633:	01 29                	add    %ebp,(%ecx)
f0105635:	04 00                	add    $0x0,%al
f0105637:	00 00                	add    %al,(%eax)
f0105639:	00 00                	add    %al,(%eax)
f010563b:	00 44 00 3b          	add    %al,0x3b(%eax,%eax,1)
f010563f:	01 2d 04 00 00 00    	add    %ebp,0x4
f0105645:	00 00                	add    %al,(%eax)
f0105647:	00 44 00 3c          	add    %al,0x3c(%eax,%eax,1)
f010564b:	01 3b                	add    %edi,(%ebx)
f010564d:	04 00                	add    $0x0,%al
f010564f:	00 00                	add    %al,(%eax)
f0105651:	00 00                	add    %al,(%eax)
f0105653:	00 44 00 3f          	add    %al,0x3f(%eax,%eax,1)
f0105657:	01 44 04 00          	add    %eax,0x0(%esp,%eax,1)
f010565b:	00 00                	add    %al,(%eax)
f010565d:	00 00                	add    %al,(%eax)
f010565f:	00 44 00 42          	add    %al,0x42(%eax,%eax,1)
f0105663:	01 52 04             	add    %edx,0x4(%edx)
f0105666:	00 00                	add    %al,(%eax)
f0105668:	00 00                	add    %al,(%eax)
f010566a:	00 00                	add    %al,(%eax)
f010566c:	44                   	inc    %esp
f010566d:	00 43 01             	add    %al,0x1(%ebx)
f0105670:	5b                   	pop    %ebx
f0105671:	04 00                	add    $0x0,%al
f0105673:	00 00                	add    %al,(%eax)
f0105675:	00 00                	add    %al,(%eax)
f0105677:	00 44 00 45          	add    %al,0x45(%eax,%eax,1)
f010567b:	01 60 04             	add    %esp,0x4(%eax)
f010567e:	00 00                	add    %al,(%eax)
f0105680:	00 00                	add    %al,(%eax)
f0105682:	00 00                	add    %al,(%eax)
f0105684:	44                   	inc    %esp
f0105685:	00 46 01             	add    %al,0x1(%esi)
f0105688:	6e                   	outsb  %ds:(%esi),(%dx)
f0105689:	04 00                	add    $0x0,%al
f010568b:	00 00                	add    %al,(%eax)
f010568d:	00 00                	add    %al,(%eax)
f010568f:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
f0105693:	01 7e 04             	add    %edi,0x4(%esi)
f0105696:	00 00                	add    %al,(%eax)
f0105698:	37                   	aaa    
f0105699:	17                   	pop    %ss
f010569a:	00 00                	add    %al,(%eax)
f010569c:	80 00 00             	addb   $0x0,(%eax)
f010569f:	00 d4                	add    %dl,%ah
f01056a1:	ff                   	(bad)  
f01056a2:	ff                   	(bad)  
f01056a3:	ff 40 17             	incl   0x17(%eax)
f01056a6:	00 00                	add    %al,(%eax)
f01056a8:	40                   	inc    %eax
f01056a9:	00 00                	add    %al,(%eax)
f01056ab:	00 06                	add    %al,(%esi)
f01056ad:	00 00                	add    %al,(%eax)
f01056af:	00 d7                	add    %dl,%bh
f01056b1:	12 00                	adc    (%eax),%al
f01056b3:	00 40 00             	add    %al,0x0(%eax)
f01056b6:	00 00                	add    %al,(%eax)
f01056b8:	00 00                	add    %al,(%eax)
f01056ba:	00 00                	add    %al,(%eax)
f01056bc:	49                   	dec    %ecx
f01056bd:	17                   	pop    %ss
f01056be:	00 00                	add    %al,(%eax)
f01056c0:	40                   	inc    %eax
f01056c1:	00 00                	add    %al,(%eax)
f01056c3:	00 00                	add    %al,(%eax)
f01056c5:	00 00                	add    %al,(%eax)
f01056c7:	00 54 17 00          	add    %dl,0x0(%edi,%edx,1)
f01056cb:	00 40 00             	add    %al,0x0(%eax)
f01056ce:	00 00                	add    %al,(%eax)
f01056d0:	03 00                	add    (%eax),%eax
f01056d2:	00 00                	add    %al,(%eax)
f01056d4:	5f                   	pop    %edi
f01056d5:	17                   	pop    %ss
f01056d6:	00 00                	add    %al,(%eax)
f01056d8:	40                   	inc    %eax
f01056d9:	00 00                	add    %al,(%eax)
f01056db:	00 02                	add    %al,(%edx)
f01056dd:	00 00                	add    %al,(%eax)
f01056df:	00 6b 17             	add    %ch,0x17(%ebx)
f01056e2:	00 00                	add    %al,(%eax)
f01056e4:	80 00 00             	addb   $0x0,(%eax)
f01056e7:	00 d4                	add    %dl,%ah
f01056e9:	ff                   	(bad)  
f01056ea:	ff                   	(bad)  
f01056eb:	ff 77 17             	pushl  0x17(%edi)
f01056ee:	00 00                	add    %al,(%eax)
f01056f0:	80 00 00             	addb   $0x0,(%eax)
f01056f3:	00 e4                	add    %ah,%ah
f01056f5:	ff                   	(bad)  
f01056f6:	ff                   	(bad)  
f01056f7:	ff 83 17 00 00 40    	incl   0x40000017(%ebx)
f01056fd:	00 00                	add    %al,(%eax)
f01056ff:	00 06                	add    %al,(%esi)
f0105701:	00 00                	add    %al,(%eax)
f0105703:	00 94 17 00 00 80 00 	add    %dl,0x800000(%edi,%edx,1)
f010570a:	00 00                	add    %al,(%eax)
f010570c:	d8 ff                	fdivr  %st(7),%st
f010570e:	ff                   	(bad)  
f010570f:	ff a2 17 00 00 80    	jmp    *-0x7fffffe9(%edx)
f0105715:	00 00                	add    %al,(%eax)
f0105717:	00 d0                	add    %dl,%al
f0105719:	ff                   	(bad)  
f010571a:	ff                   	(bad)  
f010571b:	ff ad 17 00 00 40    	ljmp   *0x40000017(%ebp)
f0105721:	00 00                	add    %al,(%eax)
f0105723:	00 07                	add    %al,(%edi)
f0105725:	00 00                	add    %al,(%eax)
f0105727:	00 bc 17 00 00 40 00 	add    %bh,0x400000(%edi,%edx,1)
f010572e:	00 00                	add    %al,(%eax)
f0105730:	03 00                	add    (%eax),%eax
f0105732:	00 00                	add    %al,(%eax)
f0105734:	00 00                	add    %al,(%eax)
f0105736:	00 00                	add    %al,(%eax)
f0105738:	c0 00 00             	rolb   $0x0,(%eax)
f010573b:	00 00                	add    %al,(%eax)
f010573d:	00 00                	add    %al,(%eax)
f010573f:	00 c8                	add    %cl,%al
f0105741:	17                   	pop    %ss
f0105742:	00 00                	add    %al,(%eax)
f0105744:	40                   	inc    %eax
f0105745:	00 00                	add    %al,(%eax)
f0105747:	00 03                	add    %al,(%ebx)
f0105749:	00 00                	add    %al,(%eax)
f010574b:	00 db                	add    %bl,%bl
f010574d:	17                   	pop    %ss
f010574e:	00 00                	add    %al,(%eax)
f0105750:	40                   	inc    %eax
f0105751:	00 00                	add    %al,(%eax)
f0105753:	00 03                	add    %al,(%ebx)
f0105755:	00 00                	add    %al,(%eax)
f0105757:	00 00                	add    %al,(%eax)
f0105759:	00 00                	add    %al,(%eax)
f010575b:	00 c0                	add    %al,%al
f010575d:	00 00                	add    %al,(%eax)
f010575f:	00 99 03 00 00 00    	add    %bl,0x3(%ecx)
f0105765:	00 00                	add    %al,(%eax)
f0105767:	00 e0                	add    %ah,%al
f0105769:	00 00                	add    %al,(%eax)
f010576b:	00 05 04 00 00 00    	add    %al,0x4
f0105771:	00 00                	add    %al,(%eax)
f0105773:	00 e0                	add    %ah,%al
f0105775:	00 00                	add    %al,(%eax)
f0105777:	00 86 04 00 00 f2    	add    %al,-0xdfffffc(%esi)
f010577d:	17                   	pop    %ss
f010577e:	00 00                	add    %al,(%eax)
f0105780:	24 00                	and    $0x0,%al
f0105782:	00 00                	add    %al,(%eax)
f0105784:	8d 16                	lea    (%esi),%edx
f0105786:	10 f0                	adc    %dh,%al
f0105788:	03 18                	add    (%eax),%ebx
f010578a:	00 00                	add    %al,(%eax)
f010578c:	a0 00 00 00 08       	mov    0x8000000,%al
f0105791:	00 00                	add    %al,(%eax)
f0105793:	00 0e                	add    %cl,(%esi)
f0105795:	18 00                	sbb    %al,(%eax)
f0105797:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
f010579d:	00 00                	add    %al,(%eax)
f010579f:	00 17                	add    %dl,(%edi)
f01057a1:	18 00                	sbb    %al,(%eax)
f01057a3:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
f01057a9:	00 00                	add    %al,(%eax)
f01057ab:	00 74 12 00          	add    %dh,0x0(%edx,%edx,1)
f01057af:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
f01057b5:	00 00                	add    %al,(%eax)
f01057b7:	00 00                	add    %al,(%eax)
f01057b9:	00 00                	add    %al,(%eax)
f01057bb:	00 44 00 67          	add    %al,0x67(%eax,%eax,1)
f01057bf:	01 00                	add    %eax,(%eax)
f01057c1:	00 00                	add    %al,(%eax)
f01057c3:	00 00                	add    %al,(%eax)
f01057c5:	00 00                	add    %al,(%eax)
f01057c7:	00 44 00 6a          	add    %al,0x6a(%eax,%eax,1)
f01057cb:	01 0c 00             	add    %ecx,(%eax,%eax,1)
f01057ce:	00 00                	add    %al,(%eax)
f01057d0:	00 00                	add    %al,(%eax)
f01057d2:	00 00                	add    %al,(%eax)
f01057d4:	44                   	inc    %esp
f01057d5:	00 68 01             	add    %ch,0x1(%eax)
f01057d8:	1b 00                	sbb    (%eax),%eax
f01057da:	00 00                	add    %al,(%eax)
f01057dc:	00 00                	add    %al,(%eax)
f01057de:	00 00                	add    %al,(%eax)
f01057e0:	44                   	inc    %esp
f01057e1:	00 6e 01             	add    %ch,0x1(%esi)
f01057e4:	2c 00                	sub    $0x0,%al
f01057e6:	00 00                	add    %al,(%eax)
f01057e8:	00 00                	add    %al,(%eax)
f01057ea:	00 00                	add    %al,(%eax)
f01057ec:	44                   	inc    %esp
f01057ed:	00 71 01             	add    %dh,0x1(%ecx)
f01057f0:	4d                   	dec    %ebp
f01057f1:	00 00                	add    %al,(%eax)
f01057f3:	00 00                	add    %al,(%eax)
f01057f5:	00 00                	add    %al,(%eax)
f01057f7:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
f01057fb:	01 53 00             	add    %edx,0x0(%ebx)
f01057fe:	00 00                	add    %al,(%eax)
f0105800:	00 00                	add    %al,(%eax)
f0105802:	00 00                	add    %al,(%eax)
f0105804:	44                   	inc    %esp
f0105805:	00 74 01 56          	add    %dh,0x56(%ecx,%eax,1)
f0105809:	00 00                	add    %al,(%eax)
f010580b:	00 23                	add    %ah,(%ebx)
f010580d:	18 00                	sbb    %al,(%eax)
f010580f:	00 80 00 00 00 ec    	add    %al,-0x14000000(%eax)
f0105815:	ff                   	(bad)  
f0105816:	ff                   	(bad)  
f0105817:	ff 2c 18             	ljmp   *(%eax,%ebx,1)
f010581a:	00 00                	add    %al,(%eax)
f010581c:	40                   	inc    %eax
f010581d:	00 00                	add    %al,(%eax)
f010581f:	00 00                	add    %al,(%eax)
f0105821:	00 00                	add    %al,(%eax)
f0105823:	00 37                	add    %dh,(%edi)
f0105825:	18 00                	sbb    %al,(%eax)
f0105827:	00 40 00             	add    %al,0x0(%eax)
f010582a:	00 00                	add    %al,(%eax)
f010582c:	02 00                	add    (%eax),%al
f010582e:	00 00                	add    %al,(%eax)
f0105830:	bc 17 00 00 40       	mov    $0x40000017,%esp
f0105835:	00 00                	add    %al,(%eax)
f0105837:	00 00                	add    %al,(%eax)
f0105839:	00 00                	add    %al,(%eax)
f010583b:	00 88 12 00 00 40    	add    %cl,0x40000012(%eax)
	...
f0105849:	00 00                	add    %al,(%eax)
f010584b:	00 c0                	add    %al,%al
	...
f0105855:	00 00                	add    %al,(%eax)
f0105857:	00 e0                	add    %ah,%al
f0105859:	00 00                	add    %al,(%eax)
f010585b:	00 58 00             	add    %bl,0x0(%eax)
f010585e:	00 00                	add    %al,(%eax)
f0105860:	40                   	inc    %eax
f0105861:	18 00                	sbb    %al,(%eax)
f0105863:	00 24 00             	add    %ah,(%eax,%eax,1)
f0105866:	00 00                	add    %al,(%eax)
f0105868:	e5 16                	in     $0x16,%eax
f010586a:	10 f0                	adc    %dh,%al
f010586c:	03 18                	add    (%eax),%ebx
f010586e:	00 00                	add    %al,(%eax)
f0105870:	a0 00 00 00 08       	mov    0x8000000,%al
f0105875:	00 00                	add    %al,(%eax)
f0105877:	00 0e                	add    %cl,(%esi)
f0105879:	18 00                	sbb    %al,(%eax)
f010587b:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
f0105881:	00 00                	add    %al,(%eax)
f0105883:	00 17                	add    %dl,(%edi)
f0105885:	18 00                	sbb    %al,(%eax)
f0105887:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
f010588d:	00 00                	add    %al,(%eax)
f010588f:	00 00                	add    %al,(%eax)
f0105891:	00 00                	add    %al,(%eax)
f0105893:	00 44 00 78          	add    %al,0x78(%eax,%eax,1)
f0105897:	01 00                	add    %eax,(%eax)
f0105899:	00 00                	add    %al,(%eax)
f010589b:	00 00                	add    %al,(%eax)
f010589d:	00 00                	add    %al,(%eax)
f010589f:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
f01058a3:	01 06                	add    %eax,(%esi)
f01058a5:	00 00                	add    %al,(%eax)
f01058a7:	00 00                	add    %al,(%eax)
f01058a9:	00 00                	add    %al,(%eax)
f01058ab:	00 44 00 7d          	add    %al,0x7d(%eax,%eax,1)
f01058af:	01 09                	add    %ecx,(%ecx)
f01058b1:	00 00                	add    %al,(%eax)
f01058b3:	00 00                	add    %al,(%eax)
f01058b5:	00 00                	add    %al,(%eax)
f01058b7:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
f01058bb:	01 26                	add    %esp,(%esi)
f01058bd:	00 00                	add    %al,(%eax)
f01058bf:	00 50 18             	add    %dl,0x18(%eax)
f01058c2:	00 00                	add    %al,(%eax)
f01058c4:	40                   	inc    %eax
f01058c5:	00 00                	add    %al,(%eax)
f01058c7:	00 00                	add    %al,(%eax)
f01058c9:	00 00                	add    %al,(%eax)
f01058cb:	00 2c 18             	add    %ch,(%eax,%ebx,1)
f01058ce:	00 00                	add    %al,(%eax)
f01058d0:	40                   	inc    %eax
f01058d1:	00 00                	add    %al,(%eax)
f01058d3:	00 00                	add    %al,(%eax)
f01058d5:	00 00                	add    %al,(%eax)
f01058d7:	00 37                	add    %dh,(%edi)
f01058d9:	18 00                	sbb    %al,(%eax)
f01058db:	00 40 00             	add    %al,0x0(%eax)
f01058de:	00 00                	add    %al,(%eax)
f01058e0:	00 00                	add    %al,(%eax)
f01058e2:	00 00                	add    %al,(%eax)
f01058e4:	bc 17 00 00 40       	mov    $0x40000017,%esp
	...
f01058f1:	00 00                	add    %al,(%eax)
f01058f3:	00 c0                	add    %al,%al
	...
f01058fd:	00 00                	add    %al,(%eax)
f01058ff:	00 e0                	add    %ah,%al
f0105901:	00 00                	add    %al,(%eax)
f0105903:	00 28                	add    %ch,(%eax)
f0105905:	00 00                	add    %al,(%eax)
f0105907:	00 5a 18             	add    %bl,0x18(%edx)
f010590a:	00 00                	add    %al,(%eax)
f010590c:	24 00                	and    $0x0,%al
f010590e:	00 00                	add    %al,(%eax)
f0105910:	0d 17 10 f0 3f       	or     $0x3ff01017,%eax
f0105915:	16                   	push   %ss
f0105916:	00 00                	add    %al,(%eax)
f0105918:	a0 00 00 00 08       	mov    0x8000000,%al
f010591d:	00 00                	add    %al,(%eax)
f010591f:	00 15 17 00 00 a0    	add    %dl,0xa0000017
f0105925:	00 00                	add    %al,(%eax)
f0105927:	00 0c 00             	add    %cl,(%eax,%eax,1)
f010592a:	00 00                	add    %al,(%eax)
f010592c:	17                   	pop    %ss
f010592d:	18 00                	sbb    %al,(%eax)
f010592f:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
f0105935:	00 00                	add    %al,(%eax)
f0105937:	00 00                	add    %al,(%eax)
f0105939:	00 00                	add    %al,(%eax)
f010593b:	00 44 00 4f          	add    %al,0x4f(%eax,%eax,1)
f010593f:	01 00                	add    %eax,(%eax)
f0105941:	00 00                	add    %al,(%eax)
f0105943:	00 00                	add    %al,(%eax)
f0105945:	00 00                	add    %al,(%eax)
f0105947:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
f010594b:	01 06                	add    %eax,(%esi)
f010594d:	00 00                	add    %al,(%eax)
f010594f:	00 00                	add    %al,(%eax)
f0105951:	00 00                	add    %al,(%eax)
f0105953:	00 44 00 53          	add    %al,0x53(%eax,%eax,1)
f0105957:	01 09                	add    %ecx,(%ecx)
f0105959:	00 00                	add    %al,(%eax)
f010595b:	00 00                	add    %al,(%eax)
f010595d:	00 00                	add    %al,(%eax)
f010595f:	00 44 00 55          	add    %al,0x55(%eax,%eax,1)
f0105963:	01 26                	add    %esp,(%esi)
f0105965:	00 00                	add    %al,(%eax)
f0105967:	00 6b 18             	add    %ch,0x18(%ebx)
f010596a:	00 00                	add    %al,(%eax)
f010596c:	40                   	inc    %eax
f010596d:	00 00                	add    %al,(%eax)
f010596f:	00 00                	add    %al,(%eax)
f0105971:	00 00                	add    %al,(%eax)
f0105973:	00 ad 17 00 00 40    	add    %ch,0x40000017(%ebp)
f0105979:	00 00                	add    %al,(%eax)
f010597b:	00 00                	add    %al,(%eax)
f010597d:	00 00                	add    %al,(%eax)
f010597f:	00 bc 17 00 00 40 00 	add    %bh,0x400000(%edi,%edx,1)
f0105986:	00 00                	add    %al,(%eax)
f0105988:	00 00                	add    %al,(%eax)
f010598a:	00 00                	add    %al,(%eax)
f010598c:	79 18                	jns    f01059a6 <__STAB_BEGIN__+0x32c6>
f010598e:	00 00                	add    %al,(%eax)
f0105990:	26 00 00             	add    %al,%es:(%eax)
f0105993:	00 b4 26 10 f0 00 00 	add    %dh,0xf010(%esi,%eiz,1)
f010599a:	00 00                	add    %al,(%eax)
f010599c:	64 00 00             	add    %al,%fs:(%eax)
f010599f:	00 35 17 10 f0 b0    	add    %dh,0xb0f01017
f01059a5:	18 00                	sbb    %al,(%eax)
f01059a7:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
f01059ab:	00 40 17             	add    %al,0x17(%eax)
f01059ae:	10 f0                	adc    %dh,%al
f01059b0:	31 00                	xor    %eax,(%eax)
f01059b2:	00 00                	add    %al,(%eax)
f01059b4:	3c 00                	cmp    $0x0,%al
f01059b6:	00 00                	add    %al,(%eax)
f01059b8:	00 00                	add    %al,(%eax)
f01059ba:	00 00                	add    %al,(%eax)
f01059bc:	40                   	inc    %eax
f01059bd:	00 00                	add    %al,(%eax)
f01059bf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f01059c5:	00 00                	add    %al,(%eax)
f01059c7:	00 6a 00             	add    %ch,0x0(%edx)
f01059ca:	00 00                	add    %al,(%eax)
f01059cc:	80 00 00             	addb   $0x0,(%eax)
f01059cf:	00 00                	add    %al,(%eax)
f01059d1:	00 00                	add    %al,(%eax)
f01059d3:	00 84 00 00 00 80 00 	add    %al,0x800000(%eax,%eax,1)
f01059da:	00 00                	add    %al,(%eax)
f01059dc:	00 00                	add    %al,(%eax)
f01059de:	00 00                	add    %al,(%eax)
f01059e0:	b3 00                	mov    $0x0,%bl
f01059e2:	00 00                	add    %al,(%eax)
f01059e4:	80 00 00             	addb   $0x0,(%eax)
f01059e7:	00 00                	add    %al,(%eax)
f01059e9:	00 00                	add    %al,(%eax)
f01059eb:	00 dc                	add    %bl,%ah
f01059ed:	00 00                	add    %al,(%eax)
f01059ef:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f01059f5:	00 00                	add    %al,(%eax)
f01059f7:	00 0a                	add    %cl,(%edx)
f01059f9:	01 00                	add    %eax,(%eax)
f01059fb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0105a01:	00 00                	add    %al,(%eax)
f0105a03:	00 35 01 00 00 80    	add    %dh,0x80000001
f0105a09:	00 00                	add    %al,(%eax)
f0105a0b:	00 00                	add    %al,(%eax)
f0105a0d:	00 00                	add    %al,(%eax)
f0105a0f:	00 60 01             	add    %ah,0x1(%eax)
f0105a12:	00 00                	add    %al,(%eax)
f0105a14:	80 00 00             	addb   $0x0,(%eax)
f0105a17:	00 00                	add    %al,(%eax)
f0105a19:	00 00                	add    %al,(%eax)
f0105a1b:	00 86 01 00 00 80    	add    %al,-0x7fffffff(%esi)
f0105a21:	00 00                	add    %al,(%eax)
f0105a23:	00 00                	add    %al,(%eax)
f0105a25:	00 00                	add    %al,(%eax)
f0105a27:	00 b0 01 00 00 80    	add    %dh,-0x7fffffff(%eax)
f0105a2d:	00 00                	add    %al,(%eax)
f0105a2f:	00 00                	add    %al,(%eax)
f0105a31:	00 00                	add    %al,(%eax)
f0105a33:	00 d6                	add    %dl,%dh
f0105a35:	01 00                	add    %eax,(%eax)
f0105a37:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0105a3d:	00 00                	add    %al,(%eax)
f0105a3f:	00 fb                	add    %bh,%bl
f0105a41:	01 00                	add    %eax,(%eax)
f0105a43:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0105a49:	00 00                	add    %al,(%eax)
f0105a4b:	00 15 02 00 00 80    	add    %dl,0x80000002
f0105a51:	00 00                	add    %al,(%eax)
f0105a53:	00 00                	add    %al,(%eax)
f0105a55:	00 00                	add    %al,(%eax)
f0105a57:	00 30                	add    %dh,(%eax)
f0105a59:	02 00                	add    (%eax),%al
f0105a5b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0105a61:	00 00                	add    %al,(%eax)
f0105a63:	00 51 02             	add    %dl,0x2(%ecx)
f0105a66:	00 00                	add    %al,(%eax)
f0105a68:	80 00 00             	addb   $0x0,(%eax)
f0105a6b:	00 00                	add    %al,(%eax)
f0105a6d:	00 00                	add    %al,(%eax)
f0105a6f:	00 70 02             	add    %dh,0x2(%eax)
f0105a72:	00 00                	add    %al,(%eax)
f0105a74:	80 00 00             	addb   $0x0,(%eax)
f0105a77:	00 00                	add    %al,(%eax)
f0105a79:	00 00                	add    %al,(%eax)
f0105a7b:	00 8f 02 00 00 80    	add    %cl,-0x7ffffffe(%edi)
f0105a81:	00 00                	add    %al,(%eax)
f0105a83:	00 00                	add    %al,(%eax)
f0105a85:	00 00                	add    %al,(%eax)
f0105a87:	00 b0 02 00 00 80    	add    %dh,-0x7ffffffe(%eax)
f0105a8d:	00 00                	add    %al,(%eax)
f0105a8f:	00 00                	add    %al,(%eax)
f0105a91:	00 00                	add    %al,(%eax)
f0105a93:	00 e3                	add    %ah,%bl
f0105a95:	0a 00                	or     (%eax),%al
f0105a97:	00 c2                	add    %al,%dl
f0105a99:	00 00                	add    %al,(%eax)
f0105a9b:	00 00                	add    %al,(%eax)
f0105a9d:	00 00                	add    %al,(%eax)
f0105a9f:	00 f1                	add    %dh,%cl
f0105aa1:	0a 00                	or     (%eax),%al
f0105aa3:	00 c2                	add    %al,%dl
f0105aa5:	00 00                	add    %al,(%eax)
f0105aa7:	00 50 06             	add    %dl,0x6(%eax)
f0105aaa:	00 00                	add    %al,(%eax)
f0105aac:	cb                   	lret   
f0105aad:	14 00                	adc    $0x0,%al
f0105aaf:	00 c2                	add    %al,%dl
f0105ab1:	00 00                	add    %al,(%eax)
f0105ab3:	00 2c 1a             	add    %ch,(%edx,%ebx,1)
f0105ab6:	00 00                	add    %al,(%eax)
f0105ab8:	bf 18 00 00 24       	mov    $0x24000018,%edi
f0105abd:	00 00                	add    %al,(%eax)
f0105abf:	00 40 17             	add    %al,0x17(%eax)
f0105ac2:	10 f0                	adc    %dh,%al
f0105ac4:	cf                   	iret   
f0105ac5:	18 00                	sbb    %al,(%eax)
f0105ac7:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
f0105acd:	00 00                	add    %al,(%eax)
f0105acf:	00 00                	add    %al,(%eax)
f0105ad1:	00 00                	add    %al,(%eax)
f0105ad3:	00 44 00 09          	add    %al,0x9(%eax,%eax,1)
	...
f0105adf:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
f0105ae3:	00 0c 00             	add    %cl,(%eax,%eax,1)
f0105ae6:	00 00                	add    %al,(%eax)
f0105ae8:	00 00                	add    %al,(%eax)
f0105aea:	00 00                	add    %al,(%eax)
f0105aec:	44                   	inc    %esp
f0105aed:	00 0d 00 10 00 00    	add    %cl,0x1000
f0105af3:	00 00                	add    %al,(%eax)
f0105af5:	00 00                	add    %al,(%eax)
f0105af7:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
f0105afb:	00 20                	add    %ah,(%eax)
f0105afd:	00 00                	add    %al,(%eax)
f0105aff:	00 00                	add    %al,(%eax)
f0105b01:	00 00                	add    %al,(%eax)
f0105b03:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
f0105b07:	00 33                	add    %dh,(%ebx)
f0105b09:	00 00                	add    %al,(%eax)
f0105b0b:	00 00                	add    %al,(%eax)
f0105b0d:	00 00                	add    %al,(%eax)
f0105b0f:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
f0105b13:	00 3a                	add    %bh,(%edx)
f0105b15:	00 00                	add    %al,(%eax)
f0105b17:	00 00                	add    %al,(%eax)
f0105b19:	00 00                	add    %al,(%eax)
f0105b1b:	00 44 00 14          	add    %al,0x14(%eax,%eax,1)
f0105b1f:	00 3e                	add    %bh,(%esi)
f0105b21:	00 00                	add    %al,(%eax)
f0105b23:	00 00                	add    %al,(%eax)
f0105b25:	00 00                	add    %al,(%eax)
f0105b27:	00 44 00 15          	add    %al,0x15(%eax,%eax,1)
f0105b2b:	00 53 00             	add    %dl,0x0(%ebx)
f0105b2e:	00 00                	add    %al,(%eax)
f0105b30:	00 00                	add    %al,(%eax)
f0105b32:	00 00                	add    %al,(%eax)
f0105b34:	44                   	inc    %esp
f0105b35:	00 16                	add    %dl,(%esi)
f0105b37:	00 55 00             	add    %dl,0x0(%ebp)
f0105b3a:	00 00                	add    %al,(%eax)
f0105b3c:	00 00                	add    %al,(%eax)
f0105b3e:	00 00                	add    %al,(%eax)
f0105b40:	44                   	inc    %esp
f0105b41:	00 17                	add    %dl,(%edi)
f0105b43:	00 66 00             	add    %ah,0x0(%esi)
f0105b46:	00 00                	add    %al,(%eax)
f0105b48:	00 00                	add    %al,(%eax)
f0105b4a:	00 00                	add    %al,(%eax)
f0105b4c:	44                   	inc    %esp
f0105b4d:	00 18                	add    %bl,(%eax)
f0105b4f:	00 6a 00             	add    %ch,0x0(%edx)
f0105b52:	00 00                	add    %al,(%eax)
f0105b54:	00 00                	add    %al,(%eax)
f0105b56:	00 00                	add    %al,(%eax)
f0105b58:	44                   	inc    %esp
f0105b59:	00 19                	add    %bl,(%ecx)
f0105b5b:	00 76 00             	add    %dh,0x0(%esi)
f0105b5e:	00 00                	add    %al,(%eax)
f0105b60:	00 00                	add    %al,(%eax)
f0105b62:	00 00                	add    %al,(%eax)
f0105b64:	44                   	inc    %esp
f0105b65:	00 16                	add    %dl,(%esi)
f0105b67:	00 79 00             	add    %bh,0x0(%ecx)
f0105b6a:	00 00                	add    %al,(%eax)
f0105b6c:	00 00                	add    %al,(%eax)
f0105b6e:	00 00                	add    %al,(%eax)
f0105b70:	44                   	inc    %esp
f0105b71:	00 1a                	add    %bl,(%edx)
f0105b73:	00 7b 00             	add    %bh,0x0(%ebx)
f0105b76:	00 00                	add    %al,(%eax)
f0105b78:	00 00                	add    %al,(%eax)
f0105b7a:	00 00                	add    %al,(%eax)
f0105b7c:	44                   	inc    %esp
f0105b7d:	00 1b                	add    %bl,(%ebx)
f0105b7f:	00 8a 00 00 00 00    	add    %cl,0x0(%edx)
f0105b85:	00 00                	add    %al,(%eax)
f0105b87:	00 44 00 1c          	add    %al,0x1c(%eax,%eax,1)
f0105b8b:	00 92 00 00 00 00    	add    %dl,0x0(%edx)
f0105b91:	00 00                	add    %al,(%eax)
f0105b93:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
f0105b97:	00 9a 00 00 00 00    	add    %bl,0x0(%edx)
f0105b9d:	00 00                	add    %al,(%eax)
f0105b9f:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
f0105ba3:	00 a5 00 00 00 00    	add    %ah,0x0(%ebp)
f0105ba9:	00 00                	add    %al,(%eax)
f0105bab:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
f0105baf:	00 af 00 00 00 00    	add    %ch,0x0(%edi)
f0105bb5:	00 00                	add    %al,(%eax)
f0105bb7:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
f0105bbb:	00 b3 00 00 00 00    	add    %dh,0x0(%ebx)
f0105bc1:	00 00                	add    %al,(%eax)
f0105bc3:	00 44 00 21          	add    %al,0x21(%eax,%eax,1)
f0105bc7:	00 bf 00 00 00 00    	add    %bh,0x0(%edi)
f0105bcd:	00 00                	add    %al,(%eax)
f0105bcf:	00 44 00 25          	add    %al,0x25(%eax,%eax,1)
f0105bd3:	00 cb                	add    %cl,%bl
f0105bd5:	00 00                	add    %al,(%eax)
f0105bd7:	00 4a 0d             	add    %cl,0xd(%edx)
f0105bda:	00 00                	add    %al,(%eax)
f0105bdc:	40                   	inc    %eax
f0105bdd:	00 00                	add    %al,(%eax)
f0105bdf:	00 06                	add    %al,(%esi)
f0105be1:	00 00                	add    %al,(%eax)
f0105be3:	00 c6                	add    %al,%dh
f0105be5:	0c 00                	or     $0x0,%al
f0105be7:	00 40 00             	add    %al,0x0(%eax)
f0105bea:	00 00                	add    %al,(%eax)
f0105bec:	03 00                	add    (%eax),%eax
f0105bee:	00 00                	add    %al,(%eax)
f0105bf0:	e5 18                	in     $0x18,%eax
f0105bf2:	00 00                	add    %al,(%eax)
f0105bf4:	40                   	inc    %eax
f0105bf5:	00 00                	add    %al,(%eax)
f0105bf7:	00 07                	add    %al,(%edi)
f0105bf9:	00 00                	add    %al,(%eax)
f0105bfb:	00 f4                	add    %dh,%ah
f0105bfd:	18 00                	sbb    %al,(%eax)
f0105bff:	00 40 00             	add    %al,0x0(%eax)
	...
f0105c0a:	00 00                	add    %al,(%eax)
f0105c0c:	c0 00 00             	rolb   $0x0,(%eax)
	...
f0105c17:	00 e0                	add    %ah,%al
f0105c19:	00 00                	add    %al,(%eax)
f0105c1b:	00 d3                	add    %dl,%bl
f0105c1d:	00 00                	add    %al,(%eax)
f0105c1f:	00 03                	add    %al,(%ebx)
f0105c21:	19 00                	sbb    %eax,(%eax)
f0105c23:	00 28                	add    %ch,(%eax)
f0105c25:	00 00                	add    %al,(%eax)
f0105c27:	00 60 35             	add    %ah,0x35(%eax)
f0105c2a:	11 f0                	adc    %esi,%eax
f0105c2c:	00 00                	add    %al,(%eax)
f0105c2e:	00 00                	add    %al,(%eax)
f0105c30:	64 00 00             	add    %al,%fs:(%eax)
f0105c33:	00 13                	add    %dl,(%ebx)
f0105c35:	18 10                	sbb    %dl,(%eax)
f0105c37:	f0 33 19             	lock xor (%ecx),%ebx
f0105c3a:	00 00                	add    %al,(%eax)
f0105c3c:	64 00 02             	add    %al,%fs:(%edx)
f0105c3f:	00 20                	add    %ah,(%eax)
f0105c41:	18 10                	sbb    %dl,(%eax)
f0105c43:	f0 31 00             	lock xor %eax,(%eax)
f0105c46:	00 00                	add    %al,(%eax)
f0105c48:	3c 00                	cmp    $0x0,%al
f0105c4a:	00 00                	add    %al,(%eax)
f0105c4c:	00 00                	add    %al,(%eax)
f0105c4e:	00 00                	add    %al,(%eax)
f0105c50:	40                   	inc    %eax
f0105c51:	00 00                	add    %al,(%eax)
f0105c53:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0105c59:	00 00                	add    %al,(%eax)
f0105c5b:	00 6a 00             	add    %ch,0x0(%edx)
f0105c5e:	00 00                	add    %al,(%eax)
f0105c60:	80 00 00             	addb   $0x0,(%eax)
f0105c63:	00 00                	add    %al,(%eax)
f0105c65:	00 00                	add    %al,(%eax)
f0105c67:	00 84 00 00 00 80 00 	add    %al,0x800000(%eax,%eax,1)
f0105c6e:	00 00                	add    %al,(%eax)
f0105c70:	00 00                	add    %al,(%eax)
f0105c72:	00 00                	add    %al,(%eax)
f0105c74:	b3 00                	mov    $0x0,%bl
f0105c76:	00 00                	add    %al,(%eax)
f0105c78:	80 00 00             	addb   $0x0,(%eax)
f0105c7b:	00 00                	add    %al,(%eax)
f0105c7d:	00 00                	add    %al,(%eax)
f0105c7f:	00 dc                	add    %bl,%ah
f0105c81:	00 00                	add    %al,(%eax)
f0105c83:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0105c89:	00 00                	add    %al,(%eax)
f0105c8b:	00 0a                	add    %cl,(%edx)
f0105c8d:	01 00                	add    %eax,(%eax)
f0105c8f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0105c95:	00 00                	add    %al,(%eax)
f0105c97:	00 35 01 00 00 80    	add    %dh,0x80000001
f0105c9d:	00 00                	add    %al,(%eax)
f0105c9f:	00 00                	add    %al,(%eax)
f0105ca1:	00 00                	add    %al,(%eax)
f0105ca3:	00 60 01             	add    %ah,0x1(%eax)
f0105ca6:	00 00                	add    %al,(%eax)
f0105ca8:	80 00 00             	addb   $0x0,(%eax)
f0105cab:	00 00                	add    %al,(%eax)
f0105cad:	00 00                	add    %al,(%eax)
f0105caf:	00 86 01 00 00 80    	add    %al,-0x7fffffff(%esi)
f0105cb5:	00 00                	add    %al,(%eax)
f0105cb7:	00 00                	add    %al,(%eax)
f0105cb9:	00 00                	add    %al,(%eax)
f0105cbb:	00 b0 01 00 00 80    	add    %dh,-0x7fffffff(%eax)
f0105cc1:	00 00                	add    %al,(%eax)
f0105cc3:	00 00                	add    %al,(%eax)
f0105cc5:	00 00                	add    %al,(%eax)
f0105cc7:	00 d6                	add    %dl,%dh
f0105cc9:	01 00                	add    %eax,(%eax)
f0105ccb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0105cd1:	00 00                	add    %al,(%eax)
f0105cd3:	00 fb                	add    %bh,%bl
f0105cd5:	01 00                	add    %eax,(%eax)
f0105cd7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0105cdd:	00 00                	add    %al,(%eax)
f0105cdf:	00 15 02 00 00 80    	add    %dl,0x80000002
f0105ce5:	00 00                	add    %al,(%eax)
f0105ce7:	00 00                	add    %al,(%eax)
f0105ce9:	00 00                	add    %al,(%eax)
f0105ceb:	00 30                	add    %dh,(%eax)
f0105ced:	02 00                	add    (%eax),%al
f0105cef:	00 80 00 00 00 00    	add    %al,0x0(%eax)
f0105cf5:	00 00                	add    %al,(%eax)
f0105cf7:	00 51 02             	add    %dl,0x2(%ecx)
f0105cfa:	00 00                	add    %al,(%eax)
f0105cfc:	80 00 00             	addb   $0x0,(%eax)
f0105cff:	00 00                	add    %al,(%eax)
f0105d01:	00 00                	add    %al,(%eax)
f0105d03:	00 70 02             	add    %dh,0x2(%eax)
f0105d06:	00 00                	add    %al,(%eax)
f0105d08:	80 00 00             	addb   $0x0,(%eax)
f0105d0b:	00 00                	add    %al,(%eax)
f0105d0d:	00 00                	add    %al,(%eax)
f0105d0f:	00 8f 02 00 00 80    	add    %cl,-0x7ffffffe(%edi)
f0105d15:	00 00                	add    %al,(%eax)
f0105d17:	00 00                	add    %al,(%eax)
f0105d19:	00 00                	add    %al,(%eax)
f0105d1b:	00 b0 02 00 00 80    	add    %dh,-0x7ffffffe(%eax)
f0105d21:	00 00                	add    %al,(%eax)
f0105d23:	00 00                	add    %al,(%eax)
f0105d25:	00 00                	add    %al,(%eax)
f0105d27:	00 1c 0b             	add    %bl,(%ebx,%ecx,1)
f0105d2a:	00 00                	add    %al,(%eax)
f0105d2c:	c2 00 00             	ret    $0x0
f0105d2f:	00 00                	add    %al,(%eax)
f0105d31:	00 00                	add    %al,(%eax)
f0105d33:	00 d0                	add    %dl,%al
f0105d35:	02 00                	add    (%eax),%al
f0105d37:	00 c2                	add    %al,%dl
f0105d39:	00 00                	add    %al,(%eax)
f0105d3b:	00 37                	add    %dh,(%edi)
f0105d3d:	53                   	push   %ebx
f0105d3e:	00 00                	add    %al,(%eax)
f0105d40:	40                   	inc    %eax
f0105d41:	19 00                	sbb    %eax,(%eax)
f0105d43:	00 24 00             	add    %ah,(%eax,%eax,1)
f0105d46:	00 00                	add    %al,(%eax)
f0105d48:	20 18                	and    %bl,(%eax)
f0105d4a:	10 f0                	adc    %dh,%al
f0105d4c:	4e                   	dec    %esi
f0105d4d:	19 00                	sbb    %eax,(%eax)
f0105d4f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
f0105d55:	00 00                	add    %al,(%eax)
f0105d57:	00 00                	add    %al,(%eax)
f0105d59:	00 00                	add    %al,(%eax)
f0105d5b:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
	...
f0105d67:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
f0105d6b:	00 06                	add    %al,(%esi)
f0105d6d:	00 00                	add    %al,(%eax)
f0105d6f:	00 00                	add    %al,(%eax)
f0105d71:	00 00                	add    %al,(%eax)
f0105d73:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
f0105d77:	00 10                	add    %dl,(%eax)
f0105d79:	00 00                	add    %al,(%eax)
f0105d7b:	00 00                	add    %al,(%eax)
f0105d7d:	00 00                	add    %al,(%eax)
f0105d7f:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
f0105d83:	00 13                	add    %dl,(%ebx)
f0105d85:	00 00                	add    %al,(%eax)
f0105d87:	00 00                	add    %al,(%eax)
f0105d89:	00 00                	add    %al,(%eax)
f0105d8b:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
f0105d8f:	00 19                	add    %bl,(%ecx)
f0105d91:	00 00                	add    %al,(%eax)
f0105d93:	00 37                	add    %dh,(%edi)
f0105d95:	18 00                	sbb    %al,(%eax)
f0105d97:	00 40 00             	add    %al,0x0(%eax)
f0105d9a:	00 00                	add    %al,(%eax)
f0105d9c:	00 00                	add    %al,(%eax)
f0105d9e:	00 00                	add    %al,(%eax)
f0105da0:	5f                   	pop    %edi
f0105da1:	19 00                	sbb    %eax,(%eax)
f0105da3:	00 40 00             	add    %al,0x0(%eax)
f0105da6:	00 00                	add    %al,(%eax)
f0105da8:	02 00                	add    (%eax),%al
f0105daa:	00 00                	add    %al,(%eax)
f0105dac:	00 00                	add    %al,(%eax)
f0105dae:	00 00                	add    %al,(%eax)
f0105db0:	c0 00 00             	rolb   $0x0,(%eax)
	...
f0105dbb:	00 e0                	add    %ah,%al
f0105dbd:	00 00                	add    %al,(%eax)
f0105dbf:	00 1b                	add    %bl,(%ebx)
f0105dc1:	00 00                	add    %al,(%eax)
f0105dc3:	00 69 19             	add    %ch,0x19(%ecx)
f0105dc6:	00 00                	add    %al,(%eax)
f0105dc8:	24 00                	and    $0x0,%al
f0105dca:	00 00                	add    %al,(%eax)
f0105dcc:	3b 18                	cmp    (%eax),%ebx
f0105dce:	10 f0                	adc    %dh,%al
f0105dd0:	78 19                	js     f0105deb <__STAB_BEGIN__+0x370b>
f0105dd2:	00 00                	add    %al,(%eax)
f0105dd4:	a0 00 00 00 08       	mov    0x8000000,%al
f0105dd9:	00 00                	add    %al,(%eax)
f0105ddb:	00 82 19 00 00 a0    	add    %al,-0x5fffffe7(%edx)
f0105de1:	00 00                	add    %al,(%eax)
f0105de3:	00 0c 00             	add    %cl,(%eax,%eax,1)
f0105de6:	00 00                	add    %al,(%eax)
f0105de8:	00 00                	add    %al,(%eax)
f0105dea:	00 00                	add    %al,(%eax)
f0105dec:	44                   	inc    %esp
f0105ded:	00 17                	add    %dl,(%edi)
	...
f0105df7:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
f0105dfb:	00 0a                	add    %cl,(%edx)
f0105dfd:	00 00                	add    %al,(%eax)
f0105dff:	00 00                	add    %al,(%eax)
f0105e01:	00 00                	add    %al,(%eax)
f0105e03:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
f0105e07:	00 18                	add    %bl,(%eax)
f0105e09:	00 00                	add    %al,(%eax)
f0105e0b:	00 00                	add    %al,(%eax)
f0105e0d:	00 00                	add    %al,(%eax)
f0105e0f:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
f0105e13:	00 1b                	add    %bl,(%ebx)
f0105e15:	00 00                	add    %al,(%eax)
f0105e17:	00 00                	add    %al,(%eax)
f0105e19:	00 00                	add    %al,(%eax)
f0105e1b:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
f0105e1f:	00 2c 00             	add    %ch,(%eax,%eax,1)
f0105e22:	00 00                	add    %al,(%eax)
f0105e24:	37                   	aaa    
f0105e25:	18 00                	sbb    %al,(%eax)
f0105e27:	00 40 00             	add    %al,0x0(%eax)
f0105e2a:	00 00                	add    %al,(%eax)
f0105e2c:	00 00                	add    %al,(%eax)
f0105e2e:	00 00                	add    %al,(%eax)
f0105e30:	5f                   	pop    %edi
f0105e31:	19 00                	sbb    %eax,(%eax)
f0105e33:	00 40 00             	add    %al,0x0(%eax)
f0105e36:	00 00                	add    %al,(%eax)
f0105e38:	03 00                	add    (%eax),%eax
f0105e3a:	00 00                	add    %al,(%eax)
f0105e3c:	8f                   	(bad)  
f0105e3d:	19 00                	sbb    %eax,(%eax)
f0105e3f:	00 40 00             	add    %al,0x0(%eax)
f0105e42:	00 00                	add    %al,(%eax)
f0105e44:	01 00                	add    %eax,(%eax)
f0105e46:	00 00                	add    %al,(%eax)
f0105e48:	00 00                	add    %al,(%eax)
f0105e4a:	00 00                	add    %al,(%eax)
f0105e4c:	c0 00 00             	rolb   $0x0,(%eax)
	...
f0105e57:	00 e0                	add    %ah,%al
f0105e59:	00 00                	add    %al,(%eax)
f0105e5b:	00 2f                	add    %ch,(%edi)
f0105e5d:	00 00                	add    %al,(%eax)
f0105e5f:	00 9c 19 00 00 24 00 	add    %bl,0x240000(%ecx,%ebx,1)
f0105e66:	00 00                	add    %al,(%eax)
f0105e68:	6a 18                	push   $0x18
f0105e6a:	10 f0                	adc    %dh,%al
f0105e6c:	b2 19                	mov    $0x19,%dl
f0105e6e:	00 00                	add    %al,(%eax)
f0105e70:	a0 00 00 00 08       	mov    0x8000000,%al
f0105e75:	00 00                	add    %al,(%eax)
f0105e77:	00 be 19 00 00 a0    	add    %bh,-0x5fffffe7(%esi)
f0105e7d:	00 00                	add    %al,(%eax)
f0105e7f:	00 0c 00             	add    %cl,(%eax,%eax,1)
f0105e82:	00 00                	add    %al,(%eax)
f0105e84:	00 00                	add    %al,(%eax)
f0105e86:	00 00                	add    %al,(%eax)
f0105e88:	44                   	inc    %esp
f0105e89:	00 21                	add    %ah,(%ecx)
	...
f0105e93:	00 44 00 21          	add    %al,0x21(%eax,%eax,1)
f0105e97:	00 0a                	add    %cl,(%edx)
f0105e99:	00 00                	add    %al,(%eax)
f0105e9b:	00 00                	add    %al,(%eax)
f0105e9d:	00 00                	add    %al,(%eax)
f0105e9f:	00 44 00 25          	add    %al,0x25(%eax,%eax,1)
f0105ea3:	00 0f                	add    %cl,(%edi)
f0105ea5:	00 00                	add    %al,(%eax)
f0105ea7:	00 00                	add    %al,(%eax)
f0105ea9:	00 00                	add    %al,(%eax)
f0105eab:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
f0105eaf:	00 1d 00 00 00 ca    	add    %bl,0xca000000
f0105eb5:	19 00                	sbb    %eax,(%eax)
f0105eb7:	00 40 00             	add    %al,0x0(%eax)
f0105eba:	00 00                	add    %al,(%eax)
f0105ebc:	00 00                	add    %al,(%eax)
f0105ebe:	00 00                	add    %al,(%eax)
f0105ec0:	d6                   	(bad)  
f0105ec1:	19 00                	sbb    %eax,(%eax)
f0105ec3:	00 40 00             	add    %al,0x0(%eax)
f0105ec6:	00 00                	add    %al,(%eax)
f0105ec8:	03 00                	add    (%eax),%eax
f0105eca:	00 00                	add    %al,(%eax)
f0105ecc:	e2 19                	loop   f0105ee7 <__STAB_BEGIN__+0x3807>
f0105ece:	00 00                	add    %al,(%eax)
f0105ed0:	24 00                	and    $0x0,%al
f0105ed2:	00 00                	add    %al,(%eax)
f0105ed4:	8a 18                	mov    (%eax),%bl
f0105ed6:	10 f0                	adc    %dh,%al
f0105ed8:	b2 19                	mov    $0x19,%dl
f0105eda:	00 00                	add    %al,(%eax)
f0105edc:	a0 00 00 00 08       	mov    0x8000000,%al
f0105ee1:	00 00                	add    %al,(%eax)
f0105ee3:	00 be 19 00 00 a0    	add    %bh,-0x5fffffe7(%esi)
f0105ee9:	00 00                	add    %al,(%eax)
f0105eeb:	00 0c 00             	add    %cl,(%eax,%eax,1)
f0105eee:	00 00                	add    %al,(%eax)
f0105ef0:	82                   	(bad)  
f0105ef1:	19 00                	sbb    %eax,(%eax)
f0105ef3:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
f0105ef9:	00 00                	add    %al,(%eax)
f0105efb:	00 00                	add    %al,(%eax)
f0105efd:	00 00                	add    %al,(%eax)
f0105eff:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
	...
f0105f0b:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
f0105f0f:	00 0e                	add    %cl,(%esi)
f0105f11:	00 00                	add    %al,(%eax)
f0105f13:	00 00                	add    %al,(%eax)
f0105f15:	00 00                	add    %al,(%eax)
f0105f17:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
f0105f1b:	00 17                	add    %dl,(%edi)
f0105f1d:	00 00                	add    %al,(%eax)
f0105f1f:	00 00                	add    %al,(%eax)
f0105f21:	00 00                	add    %al,(%eax)
f0105f23:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
f0105f27:	00 1d 00 00 00 00    	add    %bl,0x0
f0105f2d:	00 00                	add    %al,(%eax)
f0105f2f:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
f0105f33:	00 23                	add    %ah,(%ebx)
f0105f35:	00 00                	add    %al,(%eax)
f0105f37:	00 00                	add    %al,(%eax)
f0105f39:	00 00                	add    %al,(%eax)
f0105f3b:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
f0105f3f:	00 2a                	add    %ch,(%edx)
f0105f41:	00 00                	add    %al,(%eax)
f0105f43:	00 f2                	add    %dh,%dl
f0105f45:	19 00                	sbb    %eax,(%eax)
f0105f47:	00 40 00             	add    %al,0x0(%eax)
f0105f4a:	00 00                	add    %al,(%eax)
f0105f4c:	01 00                	add    %eax,(%eax)
f0105f4e:	00 00                	add    %al,(%eax)
f0105f50:	ca 19 00             	lret   $0x19
f0105f53:	00 40 00             	add    %al,0x0(%eax)
f0105f56:	00 00                	add    %al,(%eax)
f0105f58:	00 00                	add    %al,(%eax)
f0105f5a:	00 00                	add    %al,(%eax)
f0105f5c:	d6                   	(bad)  
f0105f5d:	19 00                	sbb    %eax,(%eax)
f0105f5f:	00 40 00             	add    %al,0x0(%eax)
f0105f62:	00 00                	add    %al,(%eax)
f0105f64:	02 00                	add    (%eax),%al
f0105f66:	00 00                	add    %al,(%eax)
f0105f68:	8f                   	(bad)  
f0105f69:	19 00                	sbb    %eax,(%eax)
f0105f6b:	00 40 00             	add    %al,0x0(%eax)
f0105f6e:	00 00                	add    %al,(%eax)
f0105f70:	06                   	push   %es
f0105f71:	00 00                	add    %al,(%eax)
f0105f73:	00 00                	add    %al,(%eax)
f0105f75:	00 00                	add    %al,(%eax)
f0105f77:	00 c0                	add    %al,%al
	...
f0105f81:	00 00                	add    %al,(%eax)
f0105f83:	00 e0                	add    %ah,%al
f0105f85:	00 00                	add    %al,(%eax)
f0105f87:	00 2e                	add    %ch,(%esi)
f0105f89:	00 00                	add    %al,(%eax)
f0105f8b:	00 fc                	add    %bh,%ah
f0105f8d:	19 00                	sbb    %eax,(%eax)
f0105f8f:	00 24 00             	add    %ah,(%eax,%eax,1)
f0105f92:	00 00                	add    %al,(%eax)
f0105f94:	b8 18 10 f0 b2       	mov    $0xb2f01018,%eax
f0105f99:	19 00                	sbb    %eax,(%eax)
f0105f9b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
f0105fa1:	00 00                	add    %al,(%eax)
f0105fa3:	00 be 19 00 00 a0    	add    %bh,-0x5fffffe7(%esi)
f0105fa9:	00 00                	add    %al,(%eax)
f0105fab:	00 0c 00             	add    %cl,(%eax,%eax,1)
f0105fae:	00 00                	add    %al,(%eax)
f0105fb0:	82                   	(bad)  
f0105fb1:	19 00                	sbb    %eax,(%eax)
f0105fb3:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
f0105fb9:	00 00                	add    %al,(%eax)
f0105fbb:	00 00                	add    %al,(%eax)
f0105fbd:	00 00                	add    %al,(%eax)
f0105fbf:	00 44 00 3b          	add    %al,0x3b(%eax,%eax,1)
	...
f0105fcb:	00 44 00 3f          	add    %al,0x3f(%eax,%eax,1)
f0105fcf:	00 0e                	add    %cl,(%esi)
f0105fd1:	00 00                	add    %al,(%eax)
f0105fd3:	00 00                	add    %al,(%eax)
f0105fd5:	00 00                	add    %al,(%eax)
f0105fd7:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
f0105fdb:	00 14 00             	add    %dl,(%eax,%eax,1)
f0105fde:	00 00                	add    %al,(%eax)
f0105fe0:	00 00                	add    %al,(%eax)
f0105fe2:	00 00                	add    %al,(%eax)
f0105fe4:	44                   	inc    %esp
f0105fe5:	00 41 00             	add    %al,0x0(%ecx)
f0105fe8:	20 00                	and    %al,(%eax)
f0105fea:	00 00                	add    %al,(%eax)
f0105fec:	00 00                	add    %al,(%eax)
f0105fee:	00 00                	add    %al,(%eax)
f0105ff0:	44                   	inc    %esp
f0105ff1:	00 40 00             	add    %al,0x0(%eax)
f0105ff4:	25 00 00 00 00       	and    $0x0,%eax
f0105ff9:	00 00                	add    %al,(%eax)
f0105ffb:	00 44 00 41          	add    %al,0x41(%eax,%eax,1)
f0105fff:	00 2a                	add    %ch,(%edx)
f0106001:	00 00                	add    %al,(%eax)
f0106003:	00 00                	add    %al,(%eax)
f0106005:	00 00                	add    %al,(%eax)
f0106007:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
f010600b:	00 2d 00 00 00 00    	add    %ch,0x0
f0106011:	00 00                	add    %al,(%eax)
f0106013:	00 44 00 42          	add    %al,0x42(%eax,%eax,1)
f0106017:	00 38                	add    %bh,(%eax)
f0106019:	00 00                	add    %al,(%eax)
f010601b:	00 00                	add    %al,(%eax)
f010601d:	00 00                	add    %al,(%eax)
f010601f:	00 44 00 45          	add    %al,0x45(%eax,%eax,1)
f0106023:	00 3d 00 00 00 ca    	add    %bh,0xca000000
f0106029:	19 00                	sbb    %eax,(%eax)
f010602b:	00 40 00             	add    %al,0x0(%eax)
f010602e:	00 00                	add    %al,(%eax)
f0106030:	06                   	push   %es
f0106031:	00 00                	add    %al,(%eax)
f0106033:	00 d6                	add    %dl,%dh
f0106035:	19 00                	sbb    %eax,(%eax)
f0106037:	00 40 00             	add    %al,0x0(%eax)
f010603a:	00 00                	add    %al,(%eax)
f010603c:	02 00                	add    (%eax),%al
f010603e:	00 00                	add    %al,(%eax)
f0106040:	8f                   	(bad)  
f0106041:	19 00                	sbb    %eax,(%eax)
f0106043:	00 40 00             	add    %al,0x0(%eax)
f0106046:	00 00                	add    %al,(%eax)
f0106048:	01 00                	add    %eax,(%eax)
f010604a:	00 00                	add    %al,(%eax)
f010604c:	0c 1a                	or     $0x1a,%al
f010604e:	00 00                	add    %al,(%eax)
f0106050:	24 00                	and    $0x0,%al
f0106052:	00 00                	add    %al,(%eax)
f0106054:	f9                   	stc    
f0106055:	18 10                	sbb    %dl,(%eax)
f0106057:	f0 1a 1a             	lock sbb (%edx),%bl
f010605a:	00 00                	add    %al,(%eax)
f010605c:	a0 00 00 00 08       	mov    0x8000000,%al
f0106061:	00 00                	add    %al,(%eax)
f0106063:	00 24 1a             	add    %ah,(%edx,%ebx,1)
f0106066:	00 00                	add    %al,(%eax)
f0106068:	a0 00 00 00 0c       	mov    0xc000000,%al
f010606d:	00 00                	add    %al,(%eax)
f010606f:	00 00                	add    %al,(%eax)
f0106071:	00 00                	add    %al,(%eax)
f0106073:	00 44 00 49          	add    %al,0x49(%eax,%eax,1)
	...
f010607f:	00 44 00 4a          	add    %al,0x4a(%eax,%eax,1)
f0106083:	00 09                	add    %cl,(%ecx)
f0106085:	00 00                	add    %al,(%eax)
f0106087:	00 00                	add    %al,(%eax)
f0106089:	00 00                	add    %al,(%eax)
f010608b:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
f010608f:	00 14 00             	add    %dl,(%eax,%eax,1)
f0106092:	00 00                	add    %al,(%eax)
f0106094:	00 00                	add    %al,(%eax)
f0106096:	00 00                	add    %al,(%eax)
f0106098:	44                   	inc    %esp
f0106099:	00 4a 00             	add    %cl,0x0(%edx)
f010609c:	1a 00                	sbb    (%eax),%al
f010609e:	00 00                	add    %al,(%eax)
f01060a0:	00 00                	add    %al,(%eax)
f01060a2:	00 00                	add    %al,(%eax)
f01060a4:	44                   	inc    %esp
f01060a5:	00 4d 00             	add    %cl,0x0(%ebp)
f01060a8:	2d 00 00 00 2e       	sub    $0x2e000000,%eax
f01060ad:	1a 00                	sbb    (%eax),%al
f01060af:	00 40 00             	add    %al,0x0(%eax)
f01060b2:	00 00                	add    %al,(%eax)
f01060b4:	01 00                	add    %eax,(%eax)
f01060b6:	00 00                	add    %al,(%eax)
f01060b8:	38 1a                	cmp    %bl,(%edx)
f01060ba:	00 00                	add    %al,(%eax)
f01060bc:	40                   	inc    %eax
f01060bd:	00 00                	add    %al,(%eax)
f01060bf:	00 02                	add    %al,(%edx)
f01060c1:	00 00                	add    %al,(%eax)
f01060c3:	00 42 1a             	add    %al,0x1a(%edx)
f01060c6:	00 00                	add    %al,(%eax)
f01060c8:	24 00                	and    $0x0,%al
f01060ca:	00 00                	add    %al,(%eax)
f01060cc:	28 19                	sub    %bl,(%ecx)
f01060ce:	10 f0                	adc    %dh,%al
f01060d0:	1a 1a                	sbb    (%edx),%bl
f01060d2:	00 00                	add    %al,(%eax)
f01060d4:	a0 00 00 00 08       	mov    0x8000000,%al
f01060d9:	00 00                	add    %al,(%eax)
f01060db:	00 24 1a             	add    %ah,(%edx,%ebx,1)
f01060de:	00 00                	add    %al,(%eax)
f01060e0:	a0 00 00 00 0c       	mov    0xc000000,%al
f01060e5:	00 00                	add    %al,(%eax)
f01060e7:	00 51 1a             	add    %dl,0x1a(%ecx)
f01060ea:	00 00                	add    %al,(%eax)
f01060ec:	a0 00 00 00 10       	mov    0x10000000,%al
f01060f1:	00 00                	add    %al,(%eax)
f01060f3:	00 00                	add    %al,(%eax)
f01060f5:	00 00                	add    %al,(%eax)
f01060f7:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
	...
f0106103:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
f0106107:	00 0d 00 00 00 00    	add    %cl,0x0
f010610d:	00 00                	add    %al,(%eax)
f010610f:	00 44 00 53          	add    %al,0x53(%eax,%eax,1)
f0106113:	00 21                	add    %ah,(%ecx)
f0106115:	00 00                	add    %al,(%eax)
f0106117:	00 00                	add    %al,(%eax)
f0106119:	00 00                	add    %al,(%eax)
f010611b:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
f010611f:	00 27                	add    %ah,(%edi)
f0106121:	00 00                	add    %al,(%eax)
f0106123:	00 00                	add    %al,(%eax)
f0106125:	00 00                	add    %al,(%eax)
f0106127:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
f010612b:	00 39                	add    %bh,(%ecx)
f010612d:	00 00                	add    %al,(%eax)
f010612f:	00 00                	add    %al,(%eax)
f0106131:	00 00                	add    %al,(%eax)
f0106133:	00 44 00 57          	add    %al,0x57(%eax,%eax,1)
f0106137:	00 3c 00             	add    %bh,(%eax,%eax,1)
f010613a:	00 00                	add    %al,(%eax)
f010613c:	2e 1a 00             	sbb    %cs:(%eax),%al
f010613f:	00 40 00             	add    %al,0x0(%eax)
f0106142:	00 00                	add    %al,(%eax)
f0106144:	02 00                	add    (%eax),%al
f0106146:	00 00                	add    %al,(%eax)
f0106148:	38 1a                	cmp    %bl,(%edx)
f010614a:	00 00                	add    %al,(%eax)
f010614c:	40                   	inc    %eax
f010614d:	00 00                	add    %al,(%eax)
f010614f:	00 01                	add    %al,(%ecx)
f0106151:	00 00                	add    %al,(%eax)
f0106153:	00 5b 1a             	add    %bl,0x1a(%ebx)
f0106156:	00 00                	add    %al,(%eax)
f0106158:	40                   	inc    %eax
f0106159:	00 00                	add    %al,(%eax)
f010615b:	00 00                	add    %al,(%eax)
f010615d:	00 00                	add    %al,(%eax)
f010615f:	00 65 1a             	add    %ah,0x1a(%ebp)
f0106162:	00 00                	add    %al,(%eax)
f0106164:	24 00                	and    $0x0,%al
f0106166:	00 00                	add    %al,(%eax)
f0106168:	6e                   	outsb  %ds:(%esi),(%dx)
f0106169:	19 10                	sbb    %edx,(%eax)
f010616b:	f0 78 19             	lock js f0106187 <__STAB_BEGIN__+0x3aa7>
f010616e:	00 00                	add    %al,(%eax)
f0106170:	a0 00 00 00 08       	mov    0x8000000,%al
f0106175:	00 00                	add    %al,(%eax)
f0106177:	00 64 0d 00          	add    %ah,0x0(%ebp,%ecx,1)
f010617b:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
f0106181:	00 00                	add    %al,(%eax)
f0106183:	00 00                	add    %al,(%eax)
f0106185:	00 00                	add    %al,(%eax)
f0106187:	00 44 00 5e          	add    %al,0x5e(%eax,%eax,1)
	...
f0106193:	00 44 00 5f          	add    %al,0x5f(%eax,%eax,1)
f0106197:	00 0a                	add    %cl,(%edx)
f0106199:	00 00                	add    %al,(%eax)
f010619b:	00 00                	add    %al,(%eax)
f010619d:	00 00                	add    %al,(%eax)
f010619f:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
f01061a3:	00 11                	add    %dl,(%ecx)
f01061a5:	00 00                	add    %al,(%eax)
f01061a7:	00 00                	add    %al,(%eax)
f01061a9:	00 00                	add    %al,(%eax)
f01061ab:	00 44 00 5f          	add    %al,0x5f(%eax,%eax,1)
f01061af:	00 1c 00             	add    %bl,(%eax,%eax,1)
f01061b2:	00 00                	add    %al,(%eax)
f01061b4:	00 00                	add    %al,(%eax)
f01061b6:	00 00                	add    %al,(%eax)
f01061b8:	44                   	inc    %esp
f01061b9:	00 63 00             	add    %ah,0x0(%ebx)
f01061bc:	2b 00                	sub    (%eax),%eax
f01061be:	00 00                	add    %al,(%eax)
f01061c0:	5f                   	pop    %edi
f01061c1:	19 00                	sbb    %eax,(%eax)
f01061c3:	00 40 00             	add    %al,0x0(%eax)
f01061c6:	00 00                	add    %al,(%eax)
f01061c8:	00 00                	add    %al,(%eax)
f01061ca:	00 00                	add    %al,(%eax)
f01061cc:	74 1a                	je     f01061e8 <__STAB_BEGIN__+0x3b08>
f01061ce:	00 00                	add    %al,(%eax)
f01061d0:	40                   	inc    %eax
f01061d1:	00 00                	add    %al,(%eax)
f01061d3:	00 01                	add    %al,(%ecx)
f01061d5:	00 00                	add    %al,(%eax)
f01061d7:	00 7d 1a             	add    %bh,0x1a(%ebp)
f01061da:	00 00                	add    %al,(%eax)
f01061dc:	24 00                	and    $0x0,%al
f01061de:	00 00                	add    %al,(%eax)
f01061e0:	9b                   	fwait
f01061e1:	19 10                	sbb    %edx,(%eax)
f01061e3:	f0 78 19             	lock js f01061ff <__STAB_BEGIN__+0x3b1f>
f01061e6:	00 00                	add    %al,(%eax)
f01061e8:	a0 00 00 00 08       	mov    0x8000000,%al
f01061ed:	00 00                	add    %al,(%eax)
f01061ef:	00 64 0d 00          	add    %ah,0x0(%ebp,%ecx,1)
f01061f3:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
f01061f9:	00 00                	add    %al,(%eax)
f01061fb:	00 00                	add    %al,(%eax)
f01061fd:	00 00                	add    %al,(%eax)
f01061ff:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
	...
f010620b:	00 44 00 6a          	add    %al,0x6a(%eax,%eax,1)
f010620f:	00 0a                	add    %cl,(%edx)
f0106211:	00 00                	add    %al,(%eax)
f0106213:	00 00                	add    %al,(%eax)
f0106215:	00 00                	add    %al,(%eax)
f0106217:	00 44 00 6b          	add    %al,0x6b(%eax,%eax,1)
f010621b:	00 11                	add    %dl,(%ecx)
f010621d:	00 00                	add    %al,(%eax)
f010621f:	00 00                	add    %al,(%eax)
f0106221:	00 00                	add    %al,(%eax)
f0106223:	00 44 00 6a          	add    %al,0x6a(%eax,%eax,1)
f0106227:	00 1f                	add    %bl,(%edi)
f0106229:	00 00                	add    %al,(%eax)
f010622b:	00 00                	add    %al,(%eax)
f010622d:	00 00                	add    %al,(%eax)
f010622f:	00 44 00 6e          	add    %al,0x6e(%eax,%eax,1)
f0106233:	00 29                	add    %ch,(%ecx)
f0106235:	00 00                	add    %al,(%eax)
f0106237:	00 5f 19             	add    %bl,0x19(%edi)
f010623a:	00 00                	add    %al,(%eax)
f010623c:	40                   	inc    %eax
f010623d:	00 00                	add    %al,(%eax)
f010623f:	00 00                	add    %al,(%eax)
f0106241:	00 00                	add    %al,(%eax)
f0106243:	00 74 1a 00          	add    %dh,0x0(%edx,%ebx,1)
f0106247:	00 40 00             	add    %al,0x0(%eax)
f010624a:	00 00                	add    %al,(%eax)
f010624c:	01 00                	add    %eax,(%eax)
f010624e:	00 00                	add    %al,(%eax)
f0106250:	8d 1a                	lea    (%edx),%ebx
f0106252:	00 00                	add    %al,(%eax)
f0106254:	24 00                	and    $0x0,%al
f0106256:	00 00                	add    %al,(%eax)
f0106258:	c6                   	(bad)  
f0106259:	19 10                	sbb    %edx,(%eax)
f010625b:	f0 a4                	lock movsb %ds:(%esi),%es:(%edi)
f010625d:	1a 00                	sbb    (%eax),%al
f010625f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
f0106265:	00 00                	add    %al,(%eax)
f0106267:	00 64 0d 00          	add    %ah,0x0(%ebp,%ecx,1)
f010626b:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
f0106271:	00 00                	add    %al,(%eax)
f0106273:	00 51 1a             	add    %dl,0x1a(%ecx)
f0106276:	00 00                	add    %al,(%eax)
f0106278:	a0 00 00 00 10       	mov    0x10000000,%al
f010627d:	00 00                	add    %al,(%eax)
f010627f:	00 00                	add    %al,(%eax)
f0106281:	00 00                	add    %al,(%eax)
f0106283:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
	...
f010628f:	00 44 00 76          	add    %al,0x76(%eax,%eax,1)
f0106293:	00 1a                	add    %bl,(%edx)
f0106295:	00 00                	add    %al,(%eax)
f0106297:	00 00                	add    %al,(%eax)
f0106299:	00 00                	add    %al,(%eax)
f010629b:	00 44 00 78          	add    %al,0x78(%eax,%eax,1)
f010629f:	00 1e                	add    %bl,(%esi)
f01062a1:	00 00                	add    %al,(%eax)
f01062a3:	00 00                	add    %al,(%eax)
f01062a5:	00 00                	add    %al,(%eax)
f01062a7:	00 44 00 79          	add    %al,0x79(%eax,%eax,1)
f01062ab:	00 2b                	add    %ch,(%ebx)
f01062ad:	00 00                	add    %al,(%eax)
f01062af:	00 00                	add    %al,(%eax)
f01062b1:	00 00                	add    %al,(%eax)
f01062b3:	00 44 00 7a          	add    %al,0x7a(%eax,%eax,1)
f01062b7:	00 2e                	add    %ch,(%esi)
f01062b9:	00 00                	add    %al,(%eax)
f01062bb:	00 00                	add    %al,(%eax)
f01062bd:	00 00                	add    %al,(%eax)
f01062bf:	00 44 00 7b          	add    %al,0x7b(%eax,%eax,1)
f01062c3:	00 41 00             	add    %al,0x0(%ecx)
f01062c6:	00 00                	add    %al,(%eax)
f01062c8:	00 00                	add    %al,(%eax)
f01062ca:	00 00                	add    %al,(%eax)
f01062cc:	44                   	inc    %esp
f01062cd:	00 78 00             	add    %bh,0x0(%eax)
f01062d0:	49                   	dec    %ecx
f01062d1:	00 00                	add    %al,(%eax)
f01062d3:	00 00                	add    %al,(%eax)
f01062d5:	00 00                	add    %al,(%eax)
f01062d7:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
f01062db:	00 4b 00             	add    %cl,0x0(%ebx)
f01062de:	00 00                	add    %al,(%eax)
f01062e0:	00 00                	add    %al,(%eax)
f01062e2:	00 00                	add    %al,(%eax)
f01062e4:	44                   	inc    %esp
f01062e5:	00 83 00 4e 00 00    	add    %al,0x4e00(%ebx)
f01062eb:	00 ae 1a 00 00 40    	add    %ch,0x4000001a(%esi)
f01062f1:	00 00                	add    %al,(%eax)
f01062f3:	00 07                	add    %al,(%edi)
f01062f5:	00 00                	add    %al,(%eax)
f01062f7:	00 c6                	add    %al,%dh
f01062f9:	0c 00                	or     $0x0,%al
f01062fb:	00 40 00             	add    %al,0x0(%eax)
f01062fe:	00 00                	add    %al,(%eax)
f0106300:	00 00                	add    %al,(%eax)
f0106302:	00 00                	add    %al,(%eax)
f0106304:	5b                   	pop    %ebx
f0106305:	1a 00                	sbb    (%eax),%al
f0106307:	00 40 00             	add    %al,0x0(%eax)
f010630a:	00 00                	add    %al,(%eax)
f010630c:	01 00                	add    %eax,(%eax)
f010630e:	00 00                	add    %al,(%eax)
f0106310:	b8 1a 00 00 24       	mov    $0x2400001a,%eax
f0106315:	00 00                	add    %al,(%eax)
f0106317:	00 25 1a 10 f0 c8    	add    %ah,0xc8f0101a
f010631d:	1a 00                	sbb    (%eax),%al
f010631f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
f0106325:	00 00                	add    %al,(%eax)
f0106327:	00 d4                	add    %dl,%ah
f0106329:	1a 00                	sbb    (%eax),%al
f010632b:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
f0106331:	00 00                	add    %al,(%eax)
f0106333:	00 51 1a             	add    %dl,0x1a(%ecx)
f0106336:	00 00                	add    %al,(%eax)
f0106338:	a0 00 00 00 10       	mov    0x10000000,%al
f010633d:	00 00                	add    %al,(%eax)
f010633f:	00 00                	add    %al,(%eax)
f0106341:	00 00                	add    %al,(%eax)
f0106343:	00 44 00 87          	add    %al,-0x79(%eax,%eax,1)
	...
f010634f:	00 44 00 8b          	add    %al,-0x75(%eax,%eax,1)
f0106353:	00 13                	add    %dl,(%ebx)
f0106355:	00 00                	add    %al,(%eax)
f0106357:	00 00                	add    %al,(%eax)
f0106359:	00 00                	add    %al,(%eax)
f010635b:	00 44 00 8c          	add    %al,-0x74(%eax,%eax,1)
f010635f:	00 16                	add    %dl,(%esi)
f0106361:	00 00                	add    %al,(%eax)
f0106363:	00 00                	add    %al,(%eax)
f0106365:	00 00                	add    %al,(%eax)
f0106367:	00 44 00 8d          	add    %al,-0x73(%eax,%eax,1)
f010636b:	00 18                	add    %bl,(%eax)
f010636d:	00 00                	add    %al,(%eax)
f010636f:	00 00                	add    %al,(%eax)
f0106371:	00 00                	add    %al,(%eax)
f0106373:	00 44 00 8f          	add    %al,-0x71(%eax,%eax,1)
f0106377:	00 23                	add    %ah,(%ebx)
f0106379:	00 00                	add    %al,(%eax)
f010637b:	00 00                	add    %al,(%eax)
f010637d:	00 00                	add    %al,(%eax)
f010637f:	00 44 00 90          	add    %al,-0x70(%eax,%eax,1)
f0106383:	00 25 00 00 00 00    	add    %ah,0x0
f0106389:	00 00                	add    %al,(%eax)
f010638b:	00 44 00 91          	add    %al,-0x6f(%eax,%eax,1)
f010638f:	00 37                	add    %dh,(%edi)
f0106391:	00 00                	add    %al,(%eax)
f0106393:	00 00                	add    %al,(%eax)
f0106395:	00 00                	add    %al,(%eax)
f0106397:	00 44 00 90          	add    %al,-0x70(%eax,%eax,1)
f010639b:	00 43 00             	add    %al,0x0(%ebx)
f010639e:	00 00                	add    %al,(%eax)
f01063a0:	00 00                	add    %al,(%eax)
f01063a2:	00 00                	add    %al,(%eax)
f01063a4:	44                   	inc    %esp
f01063a5:	00 94 00 45 00 00 00 	add    %dl,0x45(%eax,%eax,1)
f01063ac:	00 00                	add    %al,(%eax)
f01063ae:	00 00                	add    %al,(%eax)
f01063b0:	44                   	inc    %esp
f01063b1:	00 97 00 4e 00 00    	add    %dl,0x4e00(%edi)
f01063b7:	00 00                	add    %al,(%eax)
f01063b9:	00 00                	add    %al,(%eax)
f01063bb:	00 44 00 8d          	add    %al,-0x73(%eax,%eax,1)
f01063bf:	00 4f 00             	add    %cl,0x0(%edi)
f01063c2:	00 00                	add    %al,(%eax)
f01063c4:	00 00                	add    %al,(%eax)
f01063c6:	00 00                	add    %al,(%eax)
f01063c8:	44                   	inc    %esp
f01063c9:	00 99 00 51 00 00    	add    %bl,0x5100(%ecx)
f01063cf:	00 00                	add    %al,(%eax)
f01063d1:	00 00                	add    %al,(%eax)
f01063d3:	00 44 00 9a          	add    %al,-0x66(%eax,%eax,1)
f01063d7:	00 66 00             	add    %ah,0x0(%esi)
f01063da:	00 00                	add    %al,(%eax)
f01063dc:	00 00                	add    %al,(%eax)
f01063de:	00 00                	add    %al,(%eax)
f01063e0:	44                   	inc    %esp
f01063e1:	00 99 00 6c 00 00    	add    %bl,0x6c00(%ecx)
f01063e7:	00 00                	add    %al,(%eax)
f01063e9:	00 00                	add    %al,(%eax)
f01063eb:	00 44 00 9d          	add    %al,-0x63(%eax,%eax,1)
f01063ef:	00 6e 00             	add    %ch,0x0(%esi)
f01063f2:	00 00                	add    %al,(%eax)
f01063f4:	00 00                	add    %al,(%eax)
f01063f6:	00 00                	add    %al,(%eax)
f01063f8:	44                   	inc    %esp
f01063f9:	00 a1 00 71 00 00    	add    %ah,0x7100(%ecx)
f01063ff:	00 5f 19             	add    %bl,0x19(%edi)
f0106402:	00 00                	add    %al,(%eax)
f0106404:	40                   	inc    %eax
f0106405:	00 00                	add    %al,(%eax)
f0106407:	00 06                	add    %al,(%esi)
f0106409:	00 00                	add    %al,(%eax)
f010640b:	00 e8                	add    %ch,%al
f010640d:	1a 00                	sbb    (%eax),%al
f010640f:	00 40 00             	add    %al,0x0(%eax)
f0106412:	00 00                	add    %al,(%eax)
f0106414:	07                   	pop    %es
f0106415:	00 00                	add    %al,(%eax)
f0106417:	00 f2                	add    %dh,%dl
f0106419:	1a 00                	sbb    (%eax),%al
f010641b:	00 40 00             	add    %al,0x0(%eax)
f010641e:	00 00                	add    %al,(%eax)
f0106420:	00 00                	add    %al,(%eax)
f0106422:	00 00                	add    %al,(%eax)
f0106424:	5b                   	pop    %ebx
f0106425:	1a 00                	sbb    (%eax),%al
f0106427:	00 40 00             	add    %al,0x0(%eax)
f010642a:	00 00                	add    %al,(%eax)
f010642c:	01 00                	add    %eax,(%eax)
f010642e:	00 00                	add    %al,(%eax)
f0106430:	00 00                	add    %al,(%eax)
f0106432:	00 00                	add    %al,(%eax)
f0106434:	c0 00 00             	rolb   $0x0,(%eax)
	...
f010643f:	00 e0                	add    %ah,%al
f0106441:	00 00                	add    %al,(%eax)
f0106443:	00 7c 00 00          	add    %bh,0x0(%eax,%eax,1)
f0106447:	00 fe                	add    %bh,%dh
f0106449:	1a 00                	sbb    (%eax),%al
f010644b:	00 24 00             	add    %ah,(%eax,%eax,1)
f010644e:	00 00                	add    %al,(%eax)
f0106450:	a1 1a 10 f0 c8       	mov    0xc8f0101a,%eax
f0106455:	1a 00                	sbb    (%eax),%al
f0106457:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
f010645d:	00 00                	add    %al,(%eax)
f010645f:	00 0d 1b 00 00 a0    	add    %cl,0xa000001b
f0106465:	00 00                	add    %al,(%eax)
f0106467:	00 0c 00             	add    %cl,(%eax,%eax,1)
f010646a:	00 00                	add    %al,(%eax)
f010646c:	51                   	push   %ecx
f010646d:	1a 00                	sbb    (%eax),%al
f010646f:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
f0106475:	00 00                	add    %al,(%eax)
f0106477:	00 00                	add    %al,(%eax)
f0106479:	00 00                	add    %al,(%eax)
f010647b:	00 44 00 ce          	add    %al,-0x32(%eax,%eax,1)
	...
f0106487:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
f010648b:	00 06                	add    %al,(%esi)
f010648d:	00 00                	add    %al,(%eax)
f010648f:	00 00                	add    %al,(%eax)
f0106491:	00 00                	add    %al,(%eax)
f0106493:	00 44 00 d0          	add    %al,-0x30(%eax,%eax,1)
f0106497:	00 1f                	add    %bl,(%edi)
f0106499:	00 00                	add    %al,(%eax)
f010649b:	00 f2                	add    %dh,%dl
f010649d:	1a 00                	sbb    (%eax),%al
f010649f:	00 40 00             	add    %al,0x0(%eax)
f01064a2:	00 00                	add    %al,(%eax)
f01064a4:	00 00                	add    %al,(%eax)
f01064a6:	00 00                	add    %al,(%eax)
f01064a8:	19 1b                	sbb    %ebx,(%ebx)
f01064aa:	00 00                	add    %al,(%eax)
f01064ac:	40                   	inc    %eax
f01064ad:	00 00                	add    %al,(%eax)
f01064af:	00 00                	add    %al,(%eax)
f01064b1:	00 00                	add    %al,(%eax)
f01064b3:	00 5b 1a             	add    %bl,0x1a(%ebx)
f01064b6:	00 00                	add    %al,(%eax)
f01064b8:	40                   	inc    %eax
f01064b9:	00 00                	add    %al,(%eax)
f01064bb:	00 00                	add    %al,(%eax)
f01064bd:	00 00                	add    %al,(%eax)
f01064bf:	00 25 1b 00 00 24    	add    %ah,0x2400001b
f01064c5:	00 00                	add    %al,(%eax)
f01064c7:	00 c2                	add    %al,%dl
f01064c9:	1a 10                	sbb    (%eax),%dl
f01064cb:	f0 33 1b             	lock xor (%ebx),%ebx
f01064ce:	00 00                	add    %al,(%eax)
f01064d0:	a0 00 00 00 08       	mov    0x8000000,%al
f01064d5:	00 00                	add    %al,(%eax)
f01064d7:	00 3e                	add    %bh,(%esi)
f01064d9:	1b 00                	sbb    (%eax),%eax
f01064db:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
f01064e1:	00 00                	add    %al,(%eax)
f01064e3:	00 51 1a             	add    %dl,0x1a(%ecx)
f01064e6:	00 00                	add    %al,(%eax)
f01064e8:	a0 00 00 00 10       	mov    0x10000000,%al
f01064ed:	00 00                	add    %al,(%eax)
f01064ef:	00 00                	add    %al,(%eax)
f01064f1:	00 00                	add    %al,(%eax)
f01064f3:	00 44 00 d4          	add    %al,-0x2c(%eax,%eax,1)
	...
f01064ff:	00 44 00 d8          	add    %al,-0x28(%eax,%eax,1)
f0106503:	00 0f                	add    %cl,(%edi)
f0106505:	00 00                	add    %al,(%eax)
f0106507:	00 00                	add    %al,(%eax)
f0106509:	00 00                	add    %al,(%eax)
f010650b:	00 44 00 d9          	add    %al,-0x27(%eax,%eax,1)
f010650f:	00 13                	add    %dl,(%ebx)
f0106511:	00 00                	add    %al,(%eax)
f0106513:	00 00                	add    %al,(%eax)
f0106515:	00 00                	add    %al,(%eax)
f0106517:	00 44 00 da          	add    %al,-0x26(%eax,%eax,1)
f010651b:	00 33                	add    %dh,(%ebx)
f010651d:	00 00                	add    %al,(%eax)
f010651f:	00 00                	add    %al,(%eax)
f0106521:	00 00                	add    %al,(%eax)
f0106523:	00 44 00 d8          	add    %al,-0x28(%eax,%eax,1)
f0106527:	00 3d 00 00 00 00    	add    %bh,0x0
f010652d:	00 00                	add    %al,(%eax)
f010652f:	00 44 00 df          	add    %al,-0x21(%eax,%eax,1)
f0106533:	00 4e 00             	add    %cl,0x0(%esi)
f0106536:	00 00                	add    %al,(%eax)
f0106538:	49                   	dec    %ecx
f0106539:	1b 00                	sbb    (%eax),%eax
f010653b:	00 40 00             	add    %al,0x0(%eax)
f010653e:	00 00                	add    %al,(%eax)
f0106540:	06                   	push   %es
f0106541:	00 00                	add    %al,(%eax)
f0106543:	00 54 1b 00          	add    %dl,0x0(%ebx,%ebx,1)
f0106547:	00 40 00             	add    %al,0x0(%eax)
f010654a:	00 00                	add    %al,(%eax)
f010654c:	07                   	pop    %es
f010654d:	00 00                	add    %al,(%eax)
f010654f:	00 5b 1a             	add    %bl,0x1a(%ebx)
f0106552:	00 00                	add    %al,(%eax)
f0106554:	40                   	inc    %eax
f0106555:	00 00                	add    %al,(%eax)
f0106557:	00 01                	add    %al,(%ecx)
f0106559:	00 00                	add    %al,(%eax)
f010655b:	00 5f 1b             	add    %bl,0x1b(%edi)
f010655e:	00 00                	add    %al,(%eax)
f0106560:	24 00                	and    $0x0,%al
f0106562:	00 00                	add    %al,(%eax)
f0106564:	15 1b 10 f0 6f       	adc    $0x6ff0101b,%eax
f0106569:	1b 00                	sbb    (%eax),%eax
f010656b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
f0106571:	00 00                	add    %al,(%eax)
f0106573:	00 64 0d 00          	add    %ah,0x0(%ebp,%ecx,1)
f0106577:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
f010657d:	00 00                	add    %al,(%eax)
f010657f:	00 51 1a             	add    %dl,0x1a(%ecx)
f0106582:	00 00                	add    %al,(%eax)
f0106584:	a0 00 00 00 10       	mov    0x10000000,%al
f0106589:	00 00                	add    %al,(%eax)
f010658b:	00 00                	add    %al,(%eax)
f010658d:	00 00                	add    %al,(%eax)
f010658f:	00 44 00 e3          	add    %al,-0x1d(%eax,%eax,1)
	...
f010659b:	00 44 00 e4          	add    %al,-0x1c(%eax,%eax,1)
f010659f:	00 06                	add    %al,(%esi)
f01065a1:	00 00                	add    %al,(%eax)
f01065a3:	00 00                	add    %al,(%eax)
f01065a5:	00 00                	add    %al,(%eax)
f01065a7:	00 44 00 e5          	add    %al,-0x1b(%eax,%eax,1)
f01065ab:	00 0b                	add    %cl,(%ebx)
f01065ad:	00 00                	add    %al,(%eax)
f01065af:	00 00                	add    %al,(%eax)
f01065b1:	00 00                	add    %al,(%eax)
f01065b3:	00 44 00 e6          	add    %al,-0x1a(%eax,%eax,1)
f01065b7:	00 0f                	add    %cl,(%edi)
f01065b9:	00 00                	add    %al,(%eax)
f01065bb:	00 00                	add    %al,(%eax)
f01065bd:	00 00                	add    %al,(%eax)
f01065bf:	00 44 00 e5          	add    %al,-0x1b(%eax,%eax,1)
f01065c3:	00 1d 00 00 00 00    	add    %bl,0x0
f01065c9:	00 00                	add    %al,(%eax)
f01065cb:	00 44 00 e9          	add    %al,-0x17(%eax,%eax,1)
f01065cf:	00 24 00             	add    %ah,(%eax,%eax,1)
f01065d2:	00 00                	add    %al,(%eax)
f01065d4:	79 1b                	jns    f01065f1 <__STAB_BEGIN__+0x3f11>
f01065d6:	00 00                	add    %al,(%eax)
f01065d8:	40                   	inc    %eax
f01065d9:	00 00                	add    %al,(%eax)
f01065db:	00 02                	add    %al,(%edx)
f01065dd:	00 00                	add    %al,(%eax)
f01065df:	00 86 1b 00 00 40    	add    %al,0x4000001b(%esi)
	...
f01065ed:	00 00                	add    %al,(%eax)
f01065ef:	00 c0                	add    %al,%al
	...
f01065f9:	00 00                	add    %al,(%eax)
f01065fb:	00 e0                	add    %ah,%al
f01065fd:	00 00                	add    %al,(%eax)
f01065ff:	00 26                	add    %ah,(%esi)
f0106601:	00 00                	add    %al,(%eax)
f0106603:	00 90 1b 00 00 24    	add    %dl,0x2400001b(%eax)
f0106609:	00 00                	add    %al,(%eax)
f010660b:	00 3b                	add    %bh,(%ebx)
f010660d:	1b 10                	sbb    (%eax),%edx
f010660f:	f0 78 19             	lock js f010662b <__STAB_BEGIN__+0x3f4b>
f0106612:	00 00                	add    %al,(%eax)
f0106614:	a0 00 00 00 08       	mov    0x8000000,%al
f0106619:	00 00                	add    %al,(%eax)
f010661b:	00 9e 1b 00 00 a0    	add    %bl,-0x5fffffe5(%esi)
f0106621:	00 00                	add    %al,(%eax)
f0106623:	00 0c 00             	add    %cl,(%eax,%eax,1)
f0106626:	00 00                	add    %al,(%eax)
f0106628:	b5 1b                	mov    $0x1b,%ch
f010662a:	00 00                	add    %al,(%eax)
f010662c:	a0 00 00 00 10       	mov    0x10000000,%al
f0106631:	00 00                	add    %al,(%eax)
f0106633:	00 00                	add    %al,(%eax)
f0106635:	00 00                	add    %al,(%eax)
f0106637:	00 44 00 ed          	add    %al,-0x13(%eax,%eax,1)
	...
f0106643:	00 44 00 f2          	add    %al,-0xe(%eax,%eax,1)
f0106647:	00 0f                	add    %cl,(%edi)
f0106649:	00 00                	add    %al,(%eax)
f010664b:	00 00                	add    %al,(%eax)
f010664d:	00 00                	add    %al,(%eax)
f010664f:	00 44 00 f3          	add    %al,-0xd(%eax,%eax,1)
f0106653:	00 1a                	add    %bl,(%edx)
f0106655:	00 00                	add    %al,(%eax)
f0106657:	00 00                	add    %al,(%eax)
f0106659:	00 00                	add    %al,(%eax)
f010665b:	00 44 00 f2          	add    %al,-0xe(%eax,%eax,1)
f010665f:	00 1d 00 00 00 00    	add    %bl,0x0
f0106665:	00 00                	add    %al,(%eax)
f0106667:	00 44 00 f6          	add    %al,-0xa(%eax,%eax,1)
f010666b:	00 28                	add    %ch,(%eax)
f010666d:	00 00                	add    %al,(%eax)
f010666f:	00 00                	add    %al,(%eax)
f0106671:	00 00                	add    %al,(%eax)
f0106673:	00 44 00 f7          	add    %al,-0x9(%eax,%eax,1)
f0106677:	00 2c 00             	add    %ch,(%eax,%eax,1)
f010667a:	00 00                	add    %al,(%eax)
f010667c:	00 00                	add    %al,(%eax)
f010667e:	00 00                	add    %al,(%eax)
f0106680:	44                   	inc    %esp
f0106681:	00 f8                	add    %bh,%al
f0106683:	00 38                	add    %bh,(%eax)
f0106685:	00 00                	add    %al,(%eax)
f0106687:	00 00                	add    %al,(%eax)
f0106689:	00 00                	add    %al,(%eax)
f010668b:	00 44 00 f9          	add    %al,-0x7(%eax,%eax,1)
f010668f:	00 43 00             	add    %al,0x0(%ebx)
f0106692:	00 00                	add    %al,(%eax)
f0106694:	00 00                	add    %al,(%eax)
f0106696:	00 00                	add    %al,(%eax)
f0106698:	44                   	inc    %esp
f0106699:	00 fc                	add    %bh,%ah
f010669b:	00 4d 00             	add    %cl,0x0(%ebp)
f010669e:	00 00                	add    %al,(%eax)
f01066a0:	00 00                	add    %al,(%eax)
f01066a2:	00 00                	add    %al,(%eax)
f01066a4:	44                   	inc    %esp
f01066a5:	00 fd                	add    %bh,%ch
f01066a7:	00 67 00             	add    %ah,0x0(%edi)
f01066aa:	00 00                	add    %al,(%eax)
f01066ac:	00 00                	add    %al,(%eax)
f01066ae:	00 00                	add    %al,(%eax)
f01066b0:	44                   	inc    %esp
f01066b1:	00 fc                	add    %bh,%ah
f01066b3:	00 6f 00             	add    %ch,0x0(%edi)
f01066b6:	00 00                	add    %al,(%eax)
f01066b8:	00 00                	add    %al,(%eax)
f01066ba:	00 00                	add    %al,(%eax)
f01066bc:	44                   	inc    %esp
f01066bd:	00 fe                	add    %bh,%dh
f01066bf:	00 71 00             	add    %dh,0x0(%ecx)
f01066c2:	00 00                	add    %al,(%eax)
f01066c4:	00 00                	add    %al,(%eax)
f01066c6:	00 00                	add    %al,(%eax)
f01066c8:	44                   	inc    %esp
f01066c9:	00 ff                	add    %bh,%bh
f01066cb:	00 81 00 00 00 00    	add    %al,0x0(%ecx)
f01066d1:	00 00                	add    %al,(%eax)
f01066d3:	00 44 00 fe          	add    %al,-0x2(%eax,%eax,1)
f01066d7:	00 86 00 00 00 00    	add    %al,0x0(%esi)
f01066dd:	00 00                	add    %al,(%eax)
f01066df:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
f01066e3:	01 8d 00 00 00 00    	add    %ecx,0x0(%ebp)
f01066e9:	00 00                	add    %al,(%eax)
f01066eb:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
f01066ef:	01 9a 00 00 00 00    	add    %ebx,0x0(%edx)
f01066f5:	00 00                	add    %al,(%eax)
f01066f7:	00 44 00 09          	add    %al,0x9(%eax,%eax,1)
f01066fb:	01 a2 00 00 00 00    	add    %esp,0x0(%edx)
f0106701:	00 00                	add    %al,(%eax)
f0106703:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
f0106707:	01 aa 00 00 00 00    	add    %ebp,0x0(%edx)
f010670d:	00 00                	add    %al,(%eax)
f010670f:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
f0106713:	01 b2 00 00 00 00    	add    %esi,0x0(%edx)
f0106719:	00 00                	add    %al,(%eax)
f010671b:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
f010671f:	01 ba 00 00 00 00    	add    %edi,0x0(%edx)
f0106725:	00 00                	add    %al,(%eax)
f0106727:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
f010672b:	01 c0                	add    %eax,%eax
f010672d:	00 00                	add    %al,(%eax)
f010672f:	00 00                	add    %al,(%eax)
f0106731:	00 00                	add    %al,(%eax)
f0106733:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
f0106737:	01 c4                	add    %eax,%esp
f0106739:	00 00                	add    %al,(%eax)
f010673b:	00 00                	add    %al,(%eax)
f010673d:	00 00                	add    %al,(%eax)
f010673f:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
f0106743:	01 cd                	add    %ecx,%ebp
f0106745:	00 00                	add    %al,(%eax)
f0106747:	00 00                	add    %al,(%eax)
f0106749:	00 00                	add    %al,(%eax)
f010674b:	00 44 00 15          	add    %al,0x15(%eax,%eax,1)
f010674f:	01 d1                	add    %edx,%ecx
f0106751:	00 00                	add    %al,(%eax)
f0106753:	00 00                	add    %al,(%eax)
f0106755:	00 00                	add    %al,(%eax)
f0106757:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
f010675b:	01 d7                	add    %edx,%edi
f010675d:	00 00                	add    %al,(%eax)
f010675f:	00 00                	add    %al,(%eax)
f0106761:	00 00                	add    %al,(%eax)
f0106763:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
f0106767:	01 dc                	add    %ebx,%esp
f0106769:	00 00                	add    %al,(%eax)
f010676b:	00 00                	add    %al,(%eax)
f010676d:	00 00                	add    %al,(%eax)
f010676f:	00 44 00 18          	add    %al,0x18(%eax,%eax,1)
f0106773:	01 e6                	add    %esp,%esi
f0106775:	00 00                	add    %al,(%eax)
f0106777:	00 c1                	add    %al,%cl
f0106779:	1b 00                	sbb    (%eax),%eax
f010677b:	00 80 00 00 00 f0    	add    %al,-0x10000000(%eax)
f0106781:	ff                   	(bad)  
f0106782:	ff                   	(bad)  
f0106783:	ff cb                	dec    %ebx
f0106785:	1b 00                	sbb    (%eax),%eax
f0106787:	00 40 00             	add    %al,0x0(%eax)
f010678a:	00 00                	add    %al,(%eax)
f010678c:	00 00                	add    %al,(%eax)
f010678e:	00 00                	add    %al,(%eax)
f0106790:	5f                   	pop    %edi
f0106791:	19 00                	sbb    %eax,(%eax)
f0106793:	00 40 00             	add    %al,0x0(%eax)
f0106796:	00 00                	add    %al,(%eax)
f0106798:	02 00                	add    (%eax),%al
f010679a:	00 00                	add    %al,(%eax)
f010679c:	5f                   	pop    %edi
f010679d:	17                   	pop    %ss
f010679e:	00 00                	add    %al,(%eax)
f01067a0:	40                   	inc    %eax
f01067a1:	00 00                	add    %al,(%eax)
f01067a3:	00 03                	add    %al,(%ebx)
f01067a5:	00 00                	add    %al,(%eax)
f01067a7:	00 00                	add    %al,(%eax)
f01067a9:	00 00                	add    %al,(%eax)
f01067ab:	00 c0                	add    %al,%al
f01067ad:	00 00                	add    %al,(%eax)
f01067af:	00 00                	add    %al,(%eax)
f01067b1:	00 00                	add    %al,(%eax)
f01067b3:	00 d6                	add    %dl,%dh
f01067b5:	1b 00                	sbb    (%eax),%eax
f01067b7:	00 40 00             	add    %al,0x0(%eax)
f01067ba:	00 00                	add    %al,(%eax)
f01067bc:	01 00                	add    %eax,(%eax)
f01067be:	00 00                	add    %al,(%eax)
f01067c0:	00 00                	add    %al,(%eax)
f01067c2:	00 00                	add    %al,(%eax)
f01067c4:	c0 00 00             	rolb   $0x0,(%eax)
f01067c7:	00 8d 00 00 00 00    	add    %cl,0x0(%ebp)
f01067cd:	00 00                	add    %al,(%eax)
f01067cf:	00 e0                	add    %ah,%al
f01067d1:	00 00                	add    %al,(%eax)
f01067d3:	00 cd                	add    %cl,%ch
f01067d5:	00 00                	add    %al,(%eax)
f01067d7:	00 00                	add    %al,(%eax)
f01067d9:	00 00                	add    %al,(%eax)
f01067db:	00 e0                	add    %ah,%al
f01067dd:	00 00                	add    %al,(%eax)
f01067df:	00 ee                	add    %ch,%dh
f01067e1:	00 00                	add    %al,(%eax)
f01067e3:	00 00                	add    %al,(%eax)
f01067e5:	00 00                	add    %al,(%eax)
f01067e7:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
f01067eb:	00 29                	add    %ch,(%ecx)
f01067ed:	1c 10                	sbb    $0x10,%al
f01067ef:	f0                   	lock

f01067f0 <__STAB_END__>:
	...

Disassembly of section .stabstr:

f01067f1 <__STABSTR_BEGIN__>:
f01067f1:	00 7b 73             	add    %bh,0x73(%ebx)
f01067f4:	74 61                	je     f0106857 <__STABSTR_BEGIN__+0x66>
f01067f6:	6e                   	outsb  %ds:(%esi),(%dx)
f01067f7:	64                   	fs
f01067f8:	61                   	popa   
f01067f9:	72 64                	jb     f010685f <__STABSTR_BEGIN__+0x6e>
f01067fb:	20 69 6e             	and    %ch,0x6e(%ecx)
f01067fe:	70 75                	jo     f0106875 <__STABSTR_BEGIN__+0x84>
f0106800:	74 7d                	je     f010687f <__STABSTR_BEGIN__+0x8e>
f0106802:	00 6b 65             	add    %ch,0x65(%ebx)
f0106805:	72 6e                	jb     f0106875 <__STABSTR_BEGIN__+0x84>
f0106807:	2f                   	das    
f0106808:	65 6e                	outsb  %gs:(%esi),(%dx)
f010680a:	74 72                	je     f010687e <__STABSTR_BEGIN__+0x8d>
f010680c:	79 2e                	jns    f010683c <__STABSTR_BEGIN__+0x4b>
f010680e:	53                   	push   %ebx
f010680f:	00 6b 65             	add    %ch,0x65(%ebx)
f0106812:	72 6e                	jb     f0106882 <__STABSTR_BEGIN__+0x91>
f0106814:	2f                   	das    
f0106815:	65 6e                	outsb  %gs:(%esi),(%dx)
f0106817:	74 72                	je     f010688b <__STABSTR_BEGIN__+0x9a>
f0106819:	79 70                	jns    f010688b <__STABSTR_BEGIN__+0x9a>
f010681b:	67 64 69 72 2e 63 00 	addr16 imul $0x63670063,%fs:0x2e(%bp,%si),%esi
f0106822:	67 63 
f0106824:	63 32                	arpl   %si,(%edx)
f0106826:	5f                   	pop    %edi
f0106827:	63 6f 6d             	arpl   %bp,0x6d(%edi)
f010682a:	70 69                	jo     f0106895 <__STABSTR_BEGIN__+0xa4>
f010682c:	6c                   	insb   (%dx),%es:(%edi)
f010682d:	65 64 2e 00 69 6e    	add    %ch,%cs:%fs:%gs:0x6e(%ecx)
f0106833:	74 3a                	je     f010686f <__STABSTR_BEGIN__+0x7e>
f0106835:	74 28                	je     f010685f <__STABSTR_BEGIN__+0x6e>
f0106837:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f010683a:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
f0106840:	31 29                	xor    %ebp,(%ecx)
f0106842:	3b 2d 32 31 34 37    	cmp    0x37343132,%ebp
f0106848:	34 38                	xor    $0x38,%al
f010684a:	33 36                	xor    (%esi),%esi
f010684c:	34 38                	xor    $0x38,%al
f010684e:	3b 32                	cmp    (%edx),%esi
f0106850:	31 34 37             	xor    %esi,(%edi,%esi,1)
f0106853:	34 38                	xor    $0x38,%al
f0106855:	33 36                	xor    (%esi),%esi
f0106857:	34 37                	xor    $0x37,%al
f0106859:	3b 00                	cmp    (%eax),%eax
f010685b:	63 68 61             	arpl   %bp,0x61(%eax)
f010685e:	72 3a                	jb     f010689a <__STABSTR_BEGIN__+0xa9>
f0106860:	74 28                	je     f010688a <__STABSTR_BEGIN__+0x99>
f0106862:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0106865:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
f010686b:	32 29                	xor    (%ecx),%ch
f010686d:	3b 30                	cmp    (%eax),%esi
f010686f:	3b 31                	cmp    (%ecx),%esi
f0106871:	32 37                	xor    (%edi),%dh
f0106873:	3b 00                	cmp    (%eax),%eax
f0106875:	6c                   	insb   (%dx),%es:(%edi)
f0106876:	6f                   	outsl  %ds:(%esi),(%dx)
f0106877:	6e                   	outsb  %ds:(%esi),(%dx)
f0106878:	67 20 69 6e          	addr16 and %ch,0x6e(%bx,%di)
f010687c:	74 3a                	je     f01068b8 <__STABSTR_BEGIN__+0xc7>
f010687e:	74 28                	je     f01068a8 <__STABSTR_BEGIN__+0xb7>
f0106880:	30 2c 33             	xor    %ch,(%ebx,%esi,1)
f0106883:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
f0106889:	33 29                	xor    (%ecx),%ebp
f010688b:	3b 2d 32 31 34 37    	cmp    0x37343132,%ebp
f0106891:	34 38                	xor    $0x38,%al
f0106893:	33 36                	xor    (%esi),%esi
f0106895:	34 38                	xor    $0x38,%al
f0106897:	3b 32                	cmp    (%edx),%esi
f0106899:	31 34 37             	xor    %esi,(%edi,%esi,1)
f010689c:	34 38                	xor    $0x38,%al
f010689e:	33 36                	xor    (%esi),%esi
f01068a0:	34 37                	xor    $0x37,%al
f01068a2:	3b 00                	cmp    (%eax),%eax
f01068a4:	75 6e                	jne    f0106914 <__STABSTR_BEGIN__+0x123>
f01068a6:	73 69                	jae    f0106911 <__STABSTR_BEGIN__+0x120>
f01068a8:	67 6e                	addr16 outsb %ds:(%si),(%dx)
f01068aa:	65 64 20 69 6e       	and    %ch,%fs:%gs:0x6e(%ecx)
f01068af:	74 3a                	je     f01068eb <__STABSTR_BEGIN__+0xfa>
f01068b1:	74 28                	je     f01068db <__STABSTR_BEGIN__+0xea>
f01068b3:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f01068b6:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
f01068bc:	34 29                	xor    $0x29,%al
f01068be:	3b 30                	cmp    (%eax),%esi
f01068c0:	3b 34 32             	cmp    (%edx,%esi,1),%esi
f01068c3:	39 34 39             	cmp    %esi,(%ecx,%edi,1)
f01068c6:	36                   	ss
f01068c7:	37                   	aaa    
f01068c8:	32 39                	xor    (%ecx),%bh
f01068ca:	35 3b 00 6c 6f       	xor    $0x6f6c003b,%eax
f01068cf:	6e                   	outsb  %ds:(%esi),(%dx)
f01068d0:	67 20 75 6e          	addr16 and %dh,0x6e(%di)
f01068d4:	73 69                	jae    f010693f <__STABSTR_BEGIN__+0x14e>
f01068d6:	67 6e                	addr16 outsb %ds:(%si),(%dx)
f01068d8:	65 64 20 69 6e       	and    %ch,%fs:%gs:0x6e(%ecx)
f01068dd:	74 3a                	je     f0106919 <__STABSTR_BEGIN__+0x128>
f01068df:	74 28                	je     f0106909 <__STABSTR_BEGIN__+0x118>
f01068e1:	30 2c 35 29 3d 72 28 	xor    %ch,0x28723d29(,%esi,1)
f01068e8:	30 2c 35 29 3b 30 3b 	xor    %ch,0x3b303b29(,%esi,1)
f01068ef:	34 32                	xor    $0x32,%al
f01068f1:	39 34 39             	cmp    %esi,(%ecx,%edi,1)
f01068f4:	36                   	ss
f01068f5:	37                   	aaa    
f01068f6:	32 39                	xor    (%ecx),%bh
f01068f8:	35 3b 00 6c 6f       	xor    $0x6f6c003b,%eax
f01068fd:	6e                   	outsb  %ds:(%esi),(%dx)
f01068fe:	67 20 6c 6f          	addr16 and %ch,0x6f(%si)
f0106902:	6e                   	outsb  %ds:(%esi),(%dx)
f0106903:	67 20 69 6e          	addr16 and %ch,0x6e(%bx,%di)
f0106907:	74 3a                	je     f0106943 <__STABSTR_BEGIN__+0x152>
f0106909:	74 28                	je     f0106933 <__STABSTR_BEGIN__+0x142>
f010690b:	30 2c 36             	xor    %ch,(%esi,%esi,1)
f010690e:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
f0106914:	36 29 3b             	sub    %edi,%ss:(%ebx)
f0106917:	2d 30 3b 34 32       	sub    $0x32343b30,%eax
f010691c:	39 34 39             	cmp    %esi,(%ecx,%edi,1)
f010691f:	36                   	ss
f0106920:	37                   	aaa    
f0106921:	32 39                	xor    (%ecx),%bh
f0106923:	35 3b 00 6c 6f       	xor    $0x6f6c003b,%eax
f0106928:	6e                   	outsb  %ds:(%esi),(%dx)
f0106929:	67 20 6c 6f          	addr16 and %ch,0x6f(%si)
f010692d:	6e                   	outsb  %ds:(%esi),(%dx)
f010692e:	67 20 75 6e          	addr16 and %dh,0x6e(%di)
f0106932:	73 69                	jae    f010699d <__STABSTR_BEGIN__+0x1ac>
f0106934:	67 6e                	addr16 outsb %ds:(%si),(%dx)
f0106936:	65 64 20 69 6e       	and    %ch,%fs:%gs:0x6e(%ecx)
f010693b:	74 3a                	je     f0106977 <__STABSTR_BEGIN__+0x186>
f010693d:	74 28                	je     f0106967 <__STABSTR_BEGIN__+0x176>
f010693f:	30 2c 37             	xor    %ch,(%edi,%esi,1)
f0106942:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
f0106948:	37                   	aaa    
f0106949:	29 3b                	sub    %edi,(%ebx)
f010694b:	30 3b                	xor    %bh,(%ebx)
f010694d:	2d 31 3b 00 73       	sub    $0x73003b31,%eax
f0106952:	68 6f 72 74 20       	push   $0x2074726f
f0106957:	69 6e 74 3a 74 28 30 	imul   $0x3028743a,0x74(%esi),%ebp
f010695e:	2c 38                	sub    $0x38,%al
f0106960:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
f0106966:	38 29                	cmp    %ch,(%ecx)
f0106968:	3b 2d 33 32 37 36    	cmp    0x36373233,%ebp
f010696e:	38 3b                	cmp    %bh,(%ebx)
f0106970:	33 32                	xor    (%edx),%esi
f0106972:	37                   	aaa    
f0106973:	36                   	ss
f0106974:	37                   	aaa    
f0106975:	3b 00                	cmp    (%eax),%eax
f0106977:	73 68                	jae    f01069e1 <__STABSTR_BEGIN__+0x1f0>
f0106979:	6f                   	outsl  %ds:(%esi),(%dx)
f010697a:	72 74                	jb     f01069f0 <__STABSTR_BEGIN__+0x1ff>
f010697c:	20 75 6e             	and    %dh,0x6e(%ebp)
f010697f:	73 69                	jae    f01069ea <__STABSTR_BEGIN__+0x1f9>
f0106981:	67 6e                	addr16 outsb %ds:(%si),(%dx)
f0106983:	65 64 20 69 6e       	and    %ch,%fs:%gs:0x6e(%ecx)
f0106988:	74 3a                	je     f01069c4 <__STABSTR_BEGIN__+0x1d3>
f010698a:	74 28                	je     f01069b4 <__STABSTR_BEGIN__+0x1c3>
f010698c:	30 2c 39             	xor    %ch,(%ecx,%edi,1)
f010698f:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
f0106995:	39 29                	cmp    %ebp,(%ecx)
f0106997:	3b 30                	cmp    (%eax),%esi
f0106999:	3b 36                	cmp    (%esi),%esi
f010699b:	35 35 33 35 3b       	xor    $0x3b353335,%eax
f01069a0:	00 73 69             	add    %dh,0x69(%ebx)
f01069a3:	67 6e                	addr16 outsb %ds:(%si),(%dx)
f01069a5:	65 64 20 63 68       	and    %ah,%fs:%gs:0x68(%ebx)
f01069aa:	61                   	popa   
f01069ab:	72 3a                	jb     f01069e7 <__STABSTR_BEGIN__+0x1f6>
f01069ad:	74 28                	je     f01069d7 <__STABSTR_BEGIN__+0x1e6>
f01069af:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01069b2:	30 29                	xor    %ch,(%ecx)
f01069b4:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
f01069b9:	31 30                	xor    %esi,(%eax)
f01069bb:	29 3b                	sub    %edi,(%ebx)
f01069bd:	2d 31 32 38 3b       	sub    $0x3b383231,%eax
f01069c2:	31 32                	xor    %esi,(%edx)
f01069c4:	37                   	aaa    
f01069c5:	3b 00                	cmp    (%eax),%eax
f01069c7:	75 6e                	jne    f0106a37 <__STABSTR_BEGIN__+0x246>
f01069c9:	73 69                	jae    f0106a34 <__STABSTR_BEGIN__+0x243>
f01069cb:	67 6e                	addr16 outsb %ds:(%si),(%dx)
f01069cd:	65 64 20 63 68       	and    %ah,%fs:%gs:0x68(%ebx)
f01069d2:	61                   	popa   
f01069d3:	72 3a                	jb     f0106a0f <__STABSTR_BEGIN__+0x21e>
f01069d5:	74 28                	je     f01069ff <__STABSTR_BEGIN__+0x20e>
f01069d7:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01069da:	31 29                	xor    %ebp,(%ecx)
f01069dc:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
f01069e1:	31 31                	xor    %esi,(%ecx)
f01069e3:	29 3b                	sub    %edi,(%ebx)
f01069e5:	30 3b                	xor    %bh,(%ebx)
f01069e7:	32 35 35 3b 00 66    	xor    0x66003b35,%dh
f01069ed:	6c                   	insb   (%dx),%es:(%edi)
f01069ee:	6f                   	outsl  %ds:(%esi),(%dx)
f01069ef:	61                   	popa   
f01069f0:	74 3a                	je     f0106a2c <__STABSTR_BEGIN__+0x23b>
f01069f2:	74 28                	je     f0106a1c <__STABSTR_BEGIN__+0x22b>
f01069f4:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01069f7:	32 29                	xor    (%ecx),%ch
f01069f9:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
f01069fe:	31 29                	xor    %ebp,(%ecx)
f0106a00:	3b 34 3b             	cmp    (%ebx,%edi,1),%esi
f0106a03:	30 3b                	xor    %bh,(%ebx)
f0106a05:	00 64 6f 75          	add    %ah,0x75(%edi,%ebp,2)
f0106a09:	62 6c 65 3a          	bound  %ebp,0x3a(%ebp,%eiz,2)
f0106a0d:	74 28                	je     f0106a37 <__STABSTR_BEGIN__+0x246>
f0106a0f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0106a12:	33 29                	xor    (%ecx),%ebp
f0106a14:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
f0106a19:	31 29                	xor    %ebp,(%ecx)
f0106a1b:	3b 38                	cmp    (%eax),%edi
f0106a1d:	3b 30                	cmp    (%eax),%esi
f0106a1f:	3b 00                	cmp    (%eax),%eax
f0106a21:	6c                   	insb   (%dx),%es:(%edi)
f0106a22:	6f                   	outsl  %ds:(%esi),(%dx)
f0106a23:	6e                   	outsb  %ds:(%esi),(%dx)
f0106a24:	67 20 64 6f          	addr16 and %ah,0x6f(%si)
f0106a28:	75 62                	jne    f0106a8c <__STABSTR_BEGIN__+0x29b>
f0106a2a:	6c                   	insb   (%dx),%es:(%edi)
f0106a2b:	65 3a 74 28 30       	cmp    %gs:0x30(%eax,%ebp,1),%dh
f0106a30:	2c 31                	sub    $0x31,%al
f0106a32:	34 29                	xor    $0x29,%al
f0106a34:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
f0106a39:	31 29                	xor    %ebp,(%ecx)
f0106a3b:	3b 31                	cmp    (%ecx),%esi
f0106a3d:	32 3b                	xor    (%ebx),%bh
f0106a3f:	30 3b                	xor    %bh,(%ebx)
f0106a41:	00 5f 44             	add    %bl,0x44(%edi)
f0106a44:	65 63 69 6d          	arpl   %bp,%gs:0x6d(%ecx)
f0106a48:	61                   	popa   
f0106a49:	6c                   	insb   (%dx),%es:(%edi)
f0106a4a:	33 32                	xor    (%edx),%esi
f0106a4c:	3a 74 28 30          	cmp    0x30(%eax,%ebp,1),%dh
f0106a50:	2c 31                	sub    $0x31,%al
f0106a52:	35 29 3d 72 28       	xor    $0x28723d29,%eax
f0106a57:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0106a5a:	29 3b                	sub    %edi,(%ebx)
f0106a5c:	34 3b                	xor    $0x3b,%al
f0106a5e:	30 3b                	xor    %bh,(%ebx)
f0106a60:	00 5f 44             	add    %bl,0x44(%edi)
f0106a63:	65 63 69 6d          	arpl   %bp,%gs:0x6d(%ecx)
f0106a67:	61                   	popa   
f0106a68:	6c                   	insb   (%dx),%es:(%edi)
f0106a69:	36                   	ss
f0106a6a:	34 3a                	xor    $0x3a,%al
f0106a6c:	74 28                	je     f0106a96 <__STABSTR_BEGIN__+0x2a5>
f0106a6e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0106a71:	36 29 3d 72 28 30 2c 	sub    %edi,%ss:0x2c302872
f0106a78:	31 29                	xor    %ebp,(%ecx)
f0106a7a:	3b 38                	cmp    (%eax),%edi
f0106a7c:	3b 30                	cmp    (%eax),%esi
f0106a7e:	3b 00                	cmp    (%eax),%eax
f0106a80:	5f                   	pop    %edi
f0106a81:	44                   	inc    %esp
f0106a82:	65 63 69 6d          	arpl   %bp,%gs:0x6d(%ecx)
f0106a86:	61                   	popa   
f0106a87:	6c                   	insb   (%dx),%es:(%edi)
f0106a88:	31 32                	xor    %esi,(%edx)
f0106a8a:	38 3a                	cmp    %bh,(%edx)
f0106a8c:	74 28                	je     f0106ab6 <__STABSTR_BEGIN__+0x2c5>
f0106a8e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0106a91:	37                   	aaa    
f0106a92:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
f0106a98:	31 29                	xor    %ebp,(%ecx)
f0106a9a:	3b 31                	cmp    (%ecx),%esi
f0106a9c:	36 3b 30             	cmp    %ss:(%eax),%esi
f0106a9f:	3b 00                	cmp    (%eax),%eax
f0106aa1:	76 6f                	jbe    f0106b12 <__STABSTR_BEGIN__+0x321>
f0106aa3:	69 64 3a 74 28 30 2c 	imul   $0x312c3028,0x74(%edx,%edi,1),%esp
f0106aaa:	31 
f0106aab:	38 29                	cmp    %ch,(%ecx)
f0106aad:	3d 28 30 2c 31       	cmp    $0x312c3028,%eax
f0106ab2:	38 29                	cmp    %ch,(%ecx)
f0106ab4:	00 2e                	add    %ch,(%esi)
f0106ab6:	2f                   	das    
f0106ab7:	69 6e 63 2f 6d 6d 75 	imul   $0x756d6d2f,0x63(%esi),%ebp
f0106abe:	2e                   	cs
f0106abf:	68 00 2e 2f 69       	push   $0x692f2e00
f0106ac4:	6e                   	outsb  %ds:(%esi),(%dx)
f0106ac5:	63 2f                	arpl   %bp,(%edi)
f0106ac7:	74 79                	je     f0106b42 <__STABSTR_BEGIN__+0x351>
f0106ac9:	70 65                	jo     f0106b30 <__STABSTR_BEGIN__+0x33f>
f0106acb:	73 2e                	jae    f0106afb <__STABSTR_BEGIN__+0x30a>
f0106acd:	68 00 62 6f 6f       	push   $0x6f6f6200
f0106ad2:	6c                   	insb   (%dx),%es:(%edi)
f0106ad3:	3a 74 28 32          	cmp    0x32(%eax,%ebp,1),%dh
f0106ad7:	2c 31                	sub    $0x31,%al
f0106ad9:	29 3d 28 30 2c 31    	sub    %edi,0x312c3028
f0106adf:	29 00                	sub    %eax,(%eax)
f0106ae1:	69 6e 74 38 5f 74 3a 	imul   $0x3a745f38,0x74(%esi),%ebp
f0106ae8:	74 28                	je     f0106b12 <__STABSTR_BEGIN__+0x321>
f0106aea:	32 2c 32             	xor    (%edx,%esi,1),%ch
f0106aed:	29 3d 28 30 2c 31    	sub    %edi,0x312c3028
f0106af3:	30 29                	xor    %ch,(%ecx)
f0106af5:	00 75 69             	add    %dh,0x69(%ebp)
f0106af8:	6e                   	outsb  %ds:(%esi),(%dx)
f0106af9:	74 38                	je     f0106b33 <__STABSTR_BEGIN__+0x342>
f0106afb:	5f                   	pop    %edi
f0106afc:	74 3a                	je     f0106b38 <__STABSTR_BEGIN__+0x347>
f0106afe:	74 28                	je     f0106b28 <__STABSTR_BEGIN__+0x337>
f0106b00:	32 2c 33             	xor    (%ebx,%esi,1),%ch
f0106b03:	29 3d 28 30 2c 31    	sub    %edi,0x312c3028
f0106b09:	31 29                	xor    %ebp,(%ecx)
f0106b0b:	00 69 6e             	add    %ch,0x6e(%ecx)
f0106b0e:	74 31                	je     f0106b41 <__STABSTR_BEGIN__+0x350>
f0106b10:	36                   	ss
f0106b11:	5f                   	pop    %edi
f0106b12:	74 3a                	je     f0106b4e <__STABSTR_BEGIN__+0x35d>
f0106b14:	74 28                	je     f0106b3e <__STABSTR_BEGIN__+0x34d>
f0106b16:	32 2c 34             	xor    (%esp,%esi,1),%ch
f0106b19:	29 3d 28 30 2c 38    	sub    %edi,0x382c3028
f0106b1f:	29 00                	sub    %eax,(%eax)
f0106b21:	75 69                	jne    f0106b8c <__STABSTR_BEGIN__+0x39b>
f0106b23:	6e                   	outsb  %ds:(%esi),(%dx)
f0106b24:	74 31                	je     f0106b57 <__STABSTR_BEGIN__+0x366>
f0106b26:	36                   	ss
f0106b27:	5f                   	pop    %edi
f0106b28:	74 3a                	je     f0106b64 <__STABSTR_BEGIN__+0x373>
f0106b2a:	74 28                	je     f0106b54 <__STABSTR_BEGIN__+0x363>
f0106b2c:	32 2c 35 29 3d 28 30 	xor    0x30283d29(,%esi,1),%ch
f0106b33:	2c 39                	sub    $0x39,%al
f0106b35:	29 00                	sub    %eax,(%eax)
f0106b37:	69 6e 74 33 32 5f 74 	imul   $0x745f3233,0x74(%esi),%ebp
f0106b3e:	3a 74 28 32          	cmp    0x32(%eax,%ebp,1),%dh
f0106b42:	2c 36                	sub    $0x36,%al
f0106b44:	29 3d 28 30 2c 31    	sub    %edi,0x312c3028
f0106b4a:	29 00                	sub    %eax,(%eax)
f0106b4c:	75 69                	jne    f0106bb7 <__STABSTR_BEGIN__+0x3c6>
f0106b4e:	6e                   	outsb  %ds:(%esi),(%dx)
f0106b4f:	74 33                	je     f0106b84 <__STABSTR_BEGIN__+0x393>
f0106b51:	32 5f 74             	xor    0x74(%edi),%bl
f0106b54:	3a 74 28 32          	cmp    0x32(%eax,%ebp,1),%dh
f0106b58:	2c 37                	sub    $0x37,%al
f0106b5a:	29 3d 28 30 2c 34    	sub    %edi,0x342c3028
f0106b60:	29 00                	sub    %eax,(%eax)
f0106b62:	69 6e 74 36 34 5f 74 	imul   $0x745f3436,0x74(%esi),%ebp
f0106b69:	3a 74 28 32          	cmp    0x32(%eax,%ebp,1),%dh
f0106b6d:	2c 38                	sub    $0x38,%al
f0106b6f:	29 3d 28 30 2c 36    	sub    %edi,0x362c3028
f0106b75:	29 00                	sub    %eax,(%eax)
f0106b77:	75 69                	jne    f0106be2 <__STABSTR_BEGIN__+0x3f1>
f0106b79:	6e                   	outsb  %ds:(%esi),(%dx)
f0106b7a:	74 36                	je     f0106bb2 <__STABSTR_BEGIN__+0x3c1>
f0106b7c:	34 5f                	xor    $0x5f,%al
f0106b7e:	74 3a                	je     f0106bba <__STABSTR_BEGIN__+0x3c9>
f0106b80:	74 28                	je     f0106baa <__STABSTR_BEGIN__+0x3b9>
f0106b82:	32 2c 39             	xor    (%ecx,%edi,1),%ch
f0106b85:	29 3d 28 30 2c 37    	sub    %edi,0x372c3028
f0106b8b:	29 00                	sub    %eax,(%eax)
f0106b8d:	69 6e 74 70 74 72 5f 	imul   $0x5f727470,0x74(%esi),%ebp
f0106b94:	74 3a                	je     f0106bd0 <__STABSTR_BEGIN__+0x3df>
f0106b96:	74 28                	je     f0106bc0 <__STABSTR_BEGIN__+0x3cf>
f0106b98:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f0106b9b:	30 29                	xor    %ch,(%ecx)
f0106b9d:	3d 28 32 2c 36       	cmp    $0x362c3228,%eax
f0106ba2:	29 00                	sub    %eax,(%eax)
f0106ba4:	75 69                	jne    f0106c0f <__STABSTR_BEGIN__+0x41e>
f0106ba6:	6e                   	outsb  %ds:(%esi),(%dx)
f0106ba7:	74 70                	je     f0106c19 <__STABSTR_BEGIN__+0x428>
f0106ba9:	74 72                	je     f0106c1d <__STABSTR_BEGIN__+0x42c>
f0106bab:	5f                   	pop    %edi
f0106bac:	74 3a                	je     f0106be8 <__STABSTR_BEGIN__+0x3f7>
f0106bae:	74 28                	je     f0106bd8 <__STABSTR_BEGIN__+0x3e7>
f0106bb0:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f0106bb3:	31 29                	xor    %ebp,(%ecx)
f0106bb5:	3d 28 32 2c 37       	cmp    $0x372c3228,%eax
f0106bba:	29 00                	sub    %eax,(%eax)
f0106bbc:	70 68                	jo     f0106c26 <__STABSTR_BEGIN__+0x435>
f0106bbe:	79 73                	jns    f0106c33 <__STABSTR_BEGIN__+0x442>
f0106bc0:	61                   	popa   
f0106bc1:	64                   	fs
f0106bc2:	64                   	fs
f0106bc3:	72 5f                	jb     f0106c24 <__STABSTR_BEGIN__+0x433>
f0106bc5:	74 3a                	je     f0106c01 <__STABSTR_BEGIN__+0x410>
f0106bc7:	74 28                	je     f0106bf1 <__STABSTR_BEGIN__+0x400>
f0106bc9:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f0106bcc:	32 29                	xor    (%ecx),%ch
f0106bce:	3d 28 32 2c 37       	cmp    $0x372c3228,%eax
f0106bd3:	29 00                	sub    %eax,(%eax)
f0106bd5:	70 70                	jo     f0106c47 <__STABSTR_BEGIN__+0x456>
f0106bd7:	6e                   	outsb  %ds:(%esi),(%dx)
f0106bd8:	5f                   	pop    %edi
f0106bd9:	74 3a                	je     f0106c15 <__STABSTR_BEGIN__+0x424>
f0106bdb:	74 28                	je     f0106c05 <__STABSTR_BEGIN__+0x414>
f0106bdd:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f0106be0:	33 29                	xor    (%ecx),%ebp
f0106be2:	3d 28 32 2c 37       	cmp    $0x372c3228,%eax
f0106be7:	29 00                	sub    %eax,(%eax)
f0106be9:	73 69                	jae    f0106c54 <__STABSTR_BEGIN__+0x463>
f0106beb:	7a 65                	jp     f0106c52 <__STABSTR_BEGIN__+0x461>
f0106bed:	5f                   	pop    %edi
f0106bee:	74 3a                	je     f0106c2a <__STABSTR_BEGIN__+0x439>
f0106bf0:	74 28                	je     f0106c1a <__STABSTR_BEGIN__+0x429>
f0106bf2:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f0106bf5:	34 29                	xor    $0x29,%al
f0106bf7:	3d 28 32 2c 37       	cmp    $0x372c3228,%eax
f0106bfc:	29 00                	sub    %eax,(%eax)
f0106bfe:	73 73                	jae    f0106c73 <__STABSTR_BEGIN__+0x482>
f0106c00:	69 7a 65 5f 74 3a 74 	imul   $0x743a745f,0x65(%edx),%edi
f0106c07:	28 32                	sub    %dh,(%edx)
f0106c09:	2c 31                	sub    $0x31,%al
f0106c0b:	35 29 3d 28 32       	xor    $0x32283d29,%eax
f0106c10:	2c 36                	sub    $0x36,%al
f0106c12:	29 00                	sub    %eax,(%eax)
f0106c14:	6f                   	outsl  %ds:(%esi),(%dx)
f0106c15:	66 66 5f             	pop    %di
f0106c18:	74 3a                	je     f0106c54 <__STABSTR_BEGIN__+0x463>
f0106c1a:	74 28                	je     f0106c44 <__STABSTR_BEGIN__+0x453>
f0106c1c:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f0106c1f:	36 29 3d 28 32 2c 36 	sub    %edi,%ss:0x362c3228
f0106c26:	29 00                	sub    %eax,(%eax)
f0106c28:	53                   	push   %ebx
f0106c29:	65                   	gs
f0106c2a:	67                   	addr16
f0106c2b:	64                   	fs
f0106c2c:	65                   	gs
f0106c2d:	73 63                	jae    f0106c92 <__STABSTR_BEGIN__+0x4a1>
f0106c2f:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
f0106c33:	2c 31                	sub    $0x31,%al
f0106c35:	29 3d 73 38 73 64    	sub    %edi,0x64733873
f0106c3b:	5f                   	pop    %edi
f0106c3c:	6c                   	insb   (%dx),%es:(%edi)
f0106c3d:	69 6d 5f 31 35 5f 30 	imul   $0x305f3531,0x5f(%ebp),%ebp
f0106c44:	3a 28                	cmp    (%eax),%ch
f0106c46:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0106c49:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
f0106c4c:	2c 31                	sub    $0x31,%al
f0106c4e:	36 3b 73 64          	cmp    %ss:0x64(%ebx),%esi
f0106c52:	5f                   	pop    %edi
f0106c53:	62 61 73             	bound  %esp,0x73(%ecx)
f0106c56:	65                   	gs
f0106c57:	5f                   	pop    %edi
f0106c58:	31 35 5f 30 3a 28    	xor    %esi,0x283a305f
f0106c5e:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0106c61:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
f0106c64:	36                   	ss
f0106c65:	2c 31                	sub    $0x31,%al
f0106c67:	36 3b 73 64          	cmp    %ss:0x64(%ebx),%esi
f0106c6b:	5f                   	pop    %edi
f0106c6c:	62 61 73             	bound  %esp,0x73(%ecx)
f0106c6f:	65                   	gs
f0106c70:	5f                   	pop    %edi
f0106c71:	32 33                	xor    (%ebx),%dh
f0106c73:	5f                   	pop    %edi
f0106c74:	31 36                	xor    %esi,(%esi)
f0106c76:	3a 28                	cmp    (%eax),%ch
f0106c78:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0106c7b:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
f0106c7e:	32 2c 38             	xor    (%eax,%edi,1),%ch
f0106c81:	3b 73 64             	cmp    0x64(%ebx),%esi
f0106c84:	5f                   	pop    %edi
f0106c85:	74 79                	je     f0106d00 <__STABSTR_BEGIN__+0x50f>
f0106c87:	70 65                	jo     f0106cee <__STABSTR_BEGIN__+0x4fd>
f0106c89:	3a 28                	cmp    (%eax),%ch
f0106c8b:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0106c8e:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
f0106c91:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0106c94:	3b 73 64             	cmp    0x64(%ebx),%esi
f0106c97:	5f                   	pop    %edi
f0106c98:	73 3a                	jae    f0106cd4 <__STABSTR_BEGIN__+0x4e3>
f0106c9a:	28 30                	sub    %dh,(%eax)
f0106c9c:	2c 34                	sub    $0x34,%al
f0106c9e:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
f0106ca1:	34 2c                	xor    $0x2c,%al
f0106ca3:	31 3b                	xor    %edi,(%ebx)
f0106ca5:	73 64                	jae    f0106d0b <__STABSTR_BEGIN__+0x51a>
f0106ca7:	5f                   	pop    %edi
f0106ca8:	64                   	fs
f0106ca9:	70 6c                	jo     f0106d17 <__STABSTR_BEGIN__+0x526>
f0106cab:	3a 28                	cmp    (%eax),%ch
f0106cad:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0106cb0:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
f0106cb3:	35 2c 32 3b 73       	xor    $0x733b322c,%eax
f0106cb8:	64                   	fs
f0106cb9:	5f                   	pop    %edi
f0106cba:	70 3a                	jo     f0106cf6 <__STABSTR_BEGIN__+0x505>
f0106cbc:	28 30                	sub    %dh,(%eax)
f0106cbe:	2c 34                	sub    $0x34,%al
f0106cc0:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
f0106cc3:	37                   	aaa    
f0106cc4:	2c 31                	sub    $0x31,%al
f0106cc6:	3b 73 64             	cmp    0x64(%ebx),%esi
f0106cc9:	5f                   	pop    %edi
f0106cca:	6c                   	insb   (%dx),%es:(%edi)
f0106ccb:	69 6d 5f 31 39 5f 31 	imul   $0x315f3931,0x5f(%ebp),%ebp
f0106cd2:	36 3a 28             	cmp    %ss:(%eax),%ch
f0106cd5:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0106cd8:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
f0106cdb:	38 2c 34             	cmp    %ch,(%esp,%esi,1)
f0106cde:	3b 73 64             	cmp    0x64(%ebx),%esi
f0106ce1:	5f                   	pop    %edi
f0106ce2:	61                   	popa   
f0106ce3:	76 6c                	jbe    f0106d51 <__STABSTR_BEGIN__+0x560>
f0106ce5:	3a 28                	cmp    (%eax),%ch
f0106ce7:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0106cea:	29 2c 35 32 2c 31 3b 	sub    %ebp,0x3b312c32(,%esi,1)
f0106cf1:	73 64                	jae    f0106d57 <__STABSTR_BEGIN__+0x566>
f0106cf3:	5f                   	pop    %edi
f0106cf4:	72 73                	jb     f0106d69 <__STABSTR_BEGIN__+0x578>
f0106cf6:	76 31                	jbe    f0106d29 <__STABSTR_BEGIN__+0x538>
f0106cf8:	3a 28                	cmp    (%eax),%ch
f0106cfa:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0106cfd:	29 2c 35 33 2c 31 3b 	sub    %ebp,0x3b312c33(,%esi,1)
f0106d04:	73 64                	jae    f0106d6a <__STABSTR_BEGIN__+0x579>
f0106d06:	5f                   	pop    %edi
f0106d07:	64 62 3a             	bound  %edi,%fs:(%edx)
f0106d0a:	28 30                	sub    %dh,(%eax)
f0106d0c:	2c 34                	sub    $0x34,%al
f0106d0e:	29 2c 35 34 2c 31 3b 	sub    %ebp,0x3b312c34(,%esi,1)
f0106d15:	73 64                	jae    f0106d7b <__STABSTR_BEGIN__+0x58a>
f0106d17:	5f                   	pop    %edi
f0106d18:	67 3a 28             	addr16 cmp (%bx,%si),%ch
f0106d1b:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0106d1e:	29 2c 35 35 2c 31 3b 	sub    %ebp,0x3b312c35(,%esi,1)
f0106d25:	73 64                	jae    f0106d8b <__STABSTR_BEGIN__+0x59a>
f0106d27:	5f                   	pop    %edi
f0106d28:	62 61 73             	bound  %esp,0x73(%ecx)
f0106d2b:	65                   	gs
f0106d2c:	5f                   	pop    %edi
f0106d2d:	33 31                	xor    (%ecx),%esi
f0106d2f:	5f                   	pop    %edi
f0106d30:	32 34 3a             	xor    (%edx,%edi,1),%dh
f0106d33:	28 30                	sub    %dh,(%eax)
f0106d35:	2c 34                	sub    $0x34,%al
f0106d37:	29 2c 35 36 2c 38 3b 	sub    %ebp,0x3b382c36(,%esi,1)
f0106d3e:	3b 00                	cmp    (%eax),%eax
f0106d40:	54                   	push   %esp
f0106d41:	61                   	popa   
f0106d42:	73 6b                	jae    f0106daf <__STABSTR_BEGIN__+0x5be>
f0106d44:	73 74                	jae    f0106dba <__STABSTR_BEGIN__+0x5c9>
f0106d46:	61                   	popa   
f0106d47:	74 65                	je     f0106dae <__STABSTR_BEGIN__+0x5bd>
f0106d49:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
f0106d4d:	2c 32                	sub    $0x32,%al
f0106d4f:	29 3d 73 31 30 34    	sub    %edi,0x34303173
f0106d55:	74 73                	je     f0106dca <__STABSTR_BEGIN__+0x5d9>
f0106d57:	5f                   	pop    %edi
f0106d58:	6c                   	insb   (%dx),%es:(%edi)
f0106d59:	69 6e 6b 3a 28 32 2c 	imul   $0x2c32283a,0x6b(%esi),%ebp
f0106d60:	37                   	aaa    
f0106d61:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
f0106d64:	2c 33                	sub    $0x33,%al
f0106d66:	32 3b                	xor    (%ebx),%bh
f0106d68:	74 73                	je     f0106ddd <__STABSTR_BEGIN__+0x5ec>
f0106d6a:	5f                   	pop    %edi
f0106d6b:	65                   	gs
f0106d6c:	73 70                	jae    f0106dde <__STABSTR_BEGIN__+0x5ed>
f0106d6e:	30 3a                	xor    %bh,(%edx)
f0106d70:	28 32                	sub    %dh,(%edx)
f0106d72:	2c 31                	sub    $0x31,%al
f0106d74:	31 29                	xor    %ebp,(%ecx)
f0106d76:	2c 33                	sub    $0x33,%al
f0106d78:	32 2c 33             	xor    (%ebx,%esi,1),%ch
f0106d7b:	32 3b                	xor    (%ebx),%bh
f0106d7d:	74 73                	je     f0106df2 <__STABSTR_BEGIN__+0x601>
f0106d7f:	5f                   	pop    %edi
f0106d80:	73 73                	jae    f0106df5 <__STABSTR_BEGIN__+0x604>
f0106d82:	30 3a                	xor    %bh,(%edx)
f0106d84:	28 32                	sub    %dh,(%edx)
f0106d86:	2c 35                	sub    $0x35,%al
f0106d88:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
f0106d8b:	34 2c                	xor    $0x2c,%al
f0106d8d:	31 36                	xor    %esi,(%esi)
f0106d8f:	3b 74 73 5f          	cmp    0x5f(%ebx,%esi,2),%esi
f0106d93:	70 61                	jo     f0106df6 <__STABSTR_BEGIN__+0x605>
f0106d95:	64 64 69 6e 67 31 3a 	imul   $0x32283a31,%fs:0x67(%esi),%ebp
f0106d9c:	28 32 
f0106d9e:	2c 35                	sub    $0x35,%al
f0106da0:	29 2c 38             	sub    %ebp,(%eax,%edi,1)
f0106da3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0106da6:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f0106dab:	65                   	gs
f0106dac:	73 70                	jae    f0106e1e <__STABSTR_BEGIN__+0x62d>
f0106dae:	31 3a                	xor    %edi,(%edx)
f0106db0:	28 32                	sub    %dh,(%edx)
f0106db2:	2c 31                	sub    $0x31,%al
f0106db4:	31 29                	xor    %ebp,(%ecx)
f0106db6:	2c 39                	sub    $0x39,%al
f0106db8:	36                   	ss
f0106db9:	2c 33                	sub    $0x33,%al
f0106dbb:	32 3b                	xor    (%ebx),%bh
f0106dbd:	74 73                	je     f0106e32 <__STABSTR_BEGIN__+0x641>
f0106dbf:	5f                   	pop    %edi
f0106dc0:	73 73                	jae    f0106e35 <__STABSTR_BEGIN__+0x644>
f0106dc2:	31 3a                	xor    %edi,(%edx)
f0106dc4:	28 32                	sub    %dh,(%edx)
f0106dc6:	2c 35                	sub    $0x35,%al
f0106dc8:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
f0106dcb:	32 38                	xor    (%eax),%bh
f0106dcd:	2c 31                	sub    $0x31,%al
f0106dcf:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f0106dd4:	70 61                	jo     f0106e37 <__STABSTR_BEGIN__+0x646>
f0106dd6:	64 64 69 6e 67 32 3a 	imul   $0x32283a32,%fs:0x67(%esi),%ebp
f0106ddd:	28 32 
f0106ddf:	2c 35                	sub    $0x35,%al
f0106de1:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
f0106de4:	34 34                	xor    $0x34,%al
f0106de6:	2c 31                	sub    $0x31,%al
f0106de8:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f0106ded:	65                   	gs
f0106dee:	73 70                	jae    f0106e60 <__STABSTR_BEGIN__+0x66f>
f0106df0:	32 3a                	xor    (%edx),%bh
f0106df2:	28 32                	sub    %dh,(%edx)
f0106df4:	2c 31                	sub    $0x31,%al
f0106df6:	31 29                	xor    %ebp,(%ecx)
f0106df8:	2c 31                	sub    $0x31,%al
f0106dfa:	36 30 2c 33          	xor    %ch,%ss:(%ebx,%esi,1)
f0106dfe:	32 3b                	xor    (%ebx),%bh
f0106e00:	74 73                	je     f0106e75 <__STABSTR_BEGIN__+0x684>
f0106e02:	5f                   	pop    %edi
f0106e03:	73 73                	jae    f0106e78 <__STABSTR_BEGIN__+0x687>
f0106e05:	32 3a                	xor    (%edx),%bh
f0106e07:	28 32                	sub    %dh,(%edx)
f0106e09:	2c 35                	sub    $0x35,%al
f0106e0b:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
f0106e0e:	39 32                	cmp    %esi,(%edx)
f0106e10:	2c 31                	sub    $0x31,%al
f0106e12:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f0106e17:	70 61                	jo     f0106e7a <__STABSTR_BEGIN__+0x689>
f0106e19:	64 64 69 6e 67 33 3a 	imul   $0x32283a33,%fs:0x67(%esi),%ebp
f0106e20:	28 32 
f0106e22:	2c 35                	sub    $0x35,%al
f0106e24:	29 2c 32             	sub    %ebp,(%edx,%esi,1)
f0106e27:	30 38                	xor    %bh,(%eax)
f0106e29:	2c 31                	sub    $0x31,%al
f0106e2b:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f0106e30:	63 72 33             	arpl   %si,0x33(%edx)
f0106e33:	3a 28                	cmp    (%eax),%ch
f0106e35:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f0106e38:	32 29                	xor    (%ecx),%ch
f0106e3a:	2c 32                	sub    $0x32,%al
f0106e3c:	32 34 2c             	xor    (%esp,%ebp,1),%dh
f0106e3f:	33 32                	xor    (%edx),%esi
f0106e41:	3b 74 73 5f          	cmp    0x5f(%ebx,%esi,2),%esi
f0106e45:	65 69 70 3a 28 32 2c 	imul   $0x312c3228,%gs:0x3a(%eax),%esi
f0106e4c:	31 
f0106e4d:	31 29                	xor    %ebp,(%ecx)
f0106e4f:	2c 32                	sub    $0x32,%al
f0106e51:	35 36 2c 33 32       	xor    $0x32332c36,%eax
f0106e56:	3b 74 73 5f          	cmp    0x5f(%ebx,%esi,2),%esi
f0106e5a:	65                   	gs
f0106e5b:	66                   	data16
f0106e5c:	6c                   	insb   (%dx),%es:(%edi)
f0106e5d:	61                   	popa   
f0106e5e:	67 73 3a             	addr16 jae f0106e9b <__STABSTR_BEGIN__+0x6aa>
f0106e61:	28 32                	sub    %dh,(%edx)
f0106e63:	2c 37                	sub    $0x37,%al
f0106e65:	29 2c 32             	sub    %ebp,(%edx,%esi,1)
f0106e68:	38 38                	cmp    %bh,(%eax)
f0106e6a:	2c 33                	sub    $0x33,%al
f0106e6c:	32 3b                	xor    (%ebx),%bh
f0106e6e:	74 73                	je     f0106ee3 <__STABSTR_BEGIN__+0x6f2>
f0106e70:	5f                   	pop    %edi
f0106e71:	65                   	gs
f0106e72:	61                   	popa   
f0106e73:	78 3a                	js     f0106eaf <__STABSTR_BEGIN__+0x6be>
f0106e75:	28 32                	sub    %dh,(%edx)
f0106e77:	2c 37                	sub    $0x37,%al
f0106e79:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
f0106e7c:	32 30                	xor    (%eax),%dh
f0106e7e:	2c 33                	sub    $0x33,%al
f0106e80:	32 3b                	xor    (%ebx),%bh
f0106e82:	74 73                	je     f0106ef7 <__STABSTR_BEGIN__+0x706>
f0106e84:	5f                   	pop    %edi
f0106e85:	65 63 78 3a          	arpl   %di,%gs:0x3a(%eax)
f0106e89:	28 32                	sub    %dh,(%edx)
f0106e8b:	2c 37                	sub    $0x37,%al
f0106e8d:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
f0106e90:	35 32 2c 33 32       	xor    $0x32332c32,%eax
f0106e95:	3b 74 73 5f          	cmp    0x5f(%ebx,%esi,2),%esi
f0106e99:	65                   	gs
f0106e9a:	64                   	fs
f0106e9b:	78 3a                	js     f0106ed7 <__STABSTR_BEGIN__+0x6e6>
f0106e9d:	28 32                	sub    %dh,(%edx)
f0106e9f:	2c 37                	sub    $0x37,%al
f0106ea1:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
f0106ea4:	38 34 2c             	cmp    %dh,(%esp,%ebp,1)
f0106ea7:	33 32                	xor    (%edx),%esi
f0106ea9:	3b 74 73 5f          	cmp    0x5f(%ebx,%esi,2),%esi
f0106ead:	65 62 78 3a          	bound  %edi,%gs:0x3a(%eax)
f0106eb1:	28 32                	sub    %dh,(%edx)
f0106eb3:	2c 37                	sub    $0x37,%al
f0106eb5:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
f0106eb8:	31 36                	xor    %esi,(%esi)
f0106eba:	2c 33                	sub    $0x33,%al
f0106ebc:	32 3b                	xor    (%ebx),%bh
f0106ebe:	74 73                	je     f0106f33 <__STABSTR_BEGIN__+0x742>
f0106ec0:	5f                   	pop    %edi
f0106ec1:	65                   	gs
f0106ec2:	73 70                	jae    f0106f34 <__STABSTR_BEGIN__+0x743>
f0106ec4:	3a 28                	cmp    (%eax),%ch
f0106ec6:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f0106ec9:	31 29                	xor    %ebp,(%ecx)
f0106ecb:	2c 34                	sub    $0x34,%al
f0106ecd:	34 38                	xor    $0x38,%al
f0106ecf:	2c 33                	sub    $0x33,%al
f0106ed1:	32 3b                	xor    (%ebx),%bh
f0106ed3:	74 73                	je     f0106f48 <__STABSTR_BEGIN__+0x757>
f0106ed5:	5f                   	pop    %edi
f0106ed6:	65 62 70 3a          	bound  %esi,%gs:0x3a(%eax)
f0106eda:	28 32                	sub    %dh,(%edx)
f0106edc:	2c 31                	sub    $0x31,%al
f0106ede:	31 29                	xor    %ebp,(%ecx)
f0106ee0:	2c 34                	sub    $0x34,%al
f0106ee2:	38 30                	cmp    %dh,(%eax)
f0106ee4:	2c 33                	sub    $0x33,%al
f0106ee6:	32 3b                	xor    (%ebx),%bh
f0106ee8:	74 73                	je     f0106f5d <__STABSTR_BEGIN__+0x76c>
f0106eea:	5f                   	pop    %edi
f0106eeb:	65                   	gs
f0106eec:	73 69                	jae    f0106f57 <__STABSTR_BEGIN__+0x766>
f0106eee:	3a 28                	cmp    (%eax),%ch
f0106ef0:	32 2c 37             	xor    (%edi,%esi,1),%ch
f0106ef3:	29 2c 35 31 32 2c 33 	sub    %ebp,0x332c3231(,%esi,1)
f0106efa:	32 3b                	xor    (%ebx),%bh
f0106efc:	74 73                	je     f0106f71 <__STABSTR_BEGIN__+0x780>
f0106efe:	5f                   	pop    %edi
f0106eff:	65 64 69 3a 28 32 2c 	imul   $0x372c3228,%fs:%gs:(%edx),%edi
f0106f06:	37 
f0106f07:	29 2c 35 34 34 2c 33 	sub    %ebp,0x332c3434(,%esi,1)
f0106f0e:	32 3b                	xor    (%ebx),%bh
f0106f10:	74 73                	je     f0106f85 <__STABSTR_BEGIN__+0x794>
f0106f12:	5f                   	pop    %edi
f0106f13:	65                   	gs
f0106f14:	73 3a                	jae    f0106f50 <__STABSTR_BEGIN__+0x75f>
f0106f16:	28 32                	sub    %dh,(%edx)
f0106f18:	2c 35                	sub    $0x35,%al
f0106f1a:	29 2c 35 37 36 2c 31 	sub    %ebp,0x312c3637(,%esi,1)
f0106f21:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f0106f26:	70 61                	jo     f0106f89 <__STABSTR_BEGIN__+0x798>
f0106f28:	64 64 69 6e 67 34 3a 	imul   $0x32283a34,%fs:0x67(%esi),%ebp
f0106f2f:	28 32 
f0106f31:	2c 35                	sub    $0x35,%al
f0106f33:	29 2c 35 39 32 2c 31 	sub    %ebp,0x312c3239(,%esi,1)
f0106f3a:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f0106f3f:	63 73 3a             	arpl   %si,0x3a(%ebx)
f0106f42:	28 32                	sub    %dh,(%edx)
f0106f44:	2c 35                	sub    $0x35,%al
f0106f46:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
f0106f49:	30 38                	xor    %bh,(%eax)
f0106f4b:	2c 31                	sub    $0x31,%al
f0106f4d:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f0106f52:	70 61                	jo     f0106fb5 <__STABSTR_BEGIN__+0x7c4>
f0106f54:	64 64 69 6e 67 35 3a 	imul   $0x32283a35,%fs:0x67(%esi),%ebp
f0106f5b:	28 32 
f0106f5d:	2c 35                	sub    $0x35,%al
f0106f5f:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
f0106f62:	32 34 2c             	xor    (%esp,%ebp,1),%dh
f0106f65:	31 36                	xor    %esi,(%esi)
f0106f67:	3b 74 73 5f          	cmp    0x5f(%ebx,%esi,2),%esi
f0106f6b:	73 73                	jae    f0106fe0 <__STABSTR_BEGIN__+0x7ef>
f0106f6d:	3a 28                	cmp    (%eax),%ch
f0106f6f:	32 2c 35 29 2c 36 34 	xor    0x34362c29(,%esi,1),%ch
f0106f76:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0106f79:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f0106f7e:	70 61                	jo     f0106fe1 <__STABSTR_BEGIN__+0x7f0>
f0106f80:	64 64 69 6e 67 36 3a 	imul   $0x32283a36,%fs:0x67(%esi),%ebp
f0106f87:	28 32 
f0106f89:	2c 35                	sub    $0x35,%al
f0106f8b:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
f0106f8e:	35 36 2c 31 36       	xor    $0x36312c36,%eax
f0106f93:	3b 74 73 5f          	cmp    0x5f(%ebx,%esi,2),%esi
f0106f97:	64                   	fs
f0106f98:	73 3a                	jae    f0106fd4 <__STABSTR_BEGIN__+0x7e3>
f0106f9a:	28 32                	sub    %dh,(%edx)
f0106f9c:	2c 35                	sub    $0x35,%al
f0106f9e:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
f0106fa1:	37                   	aaa    
f0106fa2:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f0106fa5:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f0106faa:	70 61                	jo     f010700d <__STABSTR_BEGIN__+0x81c>
f0106fac:	64 64 69 6e 67 37 3a 	imul   $0x32283a37,%fs:0x67(%esi),%ebp
f0106fb3:	28 32 
f0106fb5:	2c 35                	sub    $0x35,%al
f0106fb7:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
f0106fba:	38 38                	cmp    %bh,(%eax)
f0106fbc:	2c 31                	sub    $0x31,%al
f0106fbe:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f0106fc3:	66                   	data16
f0106fc4:	73 3a                	jae    f0107000 <__STABSTR_BEGIN__+0x80f>
f0106fc6:	28 32                	sub    %dh,(%edx)
f0106fc8:	2c 35                	sub    $0x35,%al
f0106fca:	29 2c 37             	sub    %ebp,(%edi,%esi,1)
f0106fcd:	30 34 2c             	xor    %dh,(%esp,%ebp,1)
f0106fd0:	31 36                	xor    %esi,(%esi)
f0106fd2:	3b 74 73 5f          	cmp    0x5f(%ebx,%esi,2),%esi
f0106fd6:	70 61                	jo     f0107039 <__STABSTR_BEGIN__+0x848>
f0106fd8:	64 64 69 6e 67 38 3a 	imul   $0x32283a38,%fs:0x67(%esi),%ebp
f0106fdf:	28 32 
f0106fe1:	2c 35                	sub    $0x35,%al
f0106fe3:	29 2c 37             	sub    %ebp,(%edi,%esi,1)
f0106fe6:	32 30                	xor    (%eax),%dh
f0106fe8:	2c 31                	sub    $0x31,%al
f0106fea:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f0106fef:	67 73 3a             	addr16 jae f010702c <__STABSTR_BEGIN__+0x83b>
f0106ff2:	28 32                	sub    %dh,(%edx)
f0106ff4:	2c 35                	sub    $0x35,%al
f0106ff6:	29 2c 37             	sub    %ebp,(%edi,%esi,1)
f0106ff9:	33 36                	xor    (%esi),%esi
f0106ffb:	2c 31                	sub    $0x31,%al
f0106ffd:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f0107002:	70 61                	jo     f0107065 <__STABSTR_BEGIN__+0x874>
f0107004:	64 64 69 6e 67 39 3a 	imul   $0x32283a39,%fs:0x67(%esi),%ebp
f010700b:	28 32 
f010700d:	2c 35                	sub    $0x35,%al
f010700f:	29 2c 37             	sub    %ebp,(%edi,%esi,1)
f0107012:	35 32 2c 31 36       	xor    $0x36312c32,%eax
f0107017:	3b 74 73 5f          	cmp    0x5f(%ebx,%esi,2),%esi
f010701b:	6c                   	insb   (%dx),%es:(%edi)
f010701c:	64                   	fs
f010701d:	74 3a                	je     f0107059 <__STABSTR_BEGIN__+0x868>
f010701f:	28 32                	sub    %dh,(%edx)
f0107021:	2c 35                	sub    $0x35,%al
f0107023:	29 2c 37             	sub    %ebp,(%edi,%esi,1)
f0107026:	36 38 2c 31          	cmp    %ch,%ss:(%ecx,%esi,1)
f010702a:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f010702f:	70 61                	jo     f0107092 <__STABSTR_BEGIN__+0x8a1>
f0107031:	64 64 69 6e 67 31 30 	imul   $0x283a3031,%fs:0x67(%esi),%ebp
f0107038:	3a 28 
f010703a:	32 2c 35 29 2c 37 38 	xor    0x38372c29(,%esi,1),%ch
f0107041:	34 2c                	xor    $0x2c,%al
f0107043:	31 36                	xor    %esi,(%esi)
f0107045:	3b 74 73 5f          	cmp    0x5f(%ebx,%esi,2),%esi
f0107049:	74 3a                	je     f0107085 <__STABSTR_BEGIN__+0x894>
f010704b:	28 32                	sub    %dh,(%edx)
f010704d:	2c 35                	sub    $0x35,%al
f010704f:	29 2c 38             	sub    %ebp,(%eax,%edi,1)
f0107052:	30 30                	xor    %dh,(%eax)
f0107054:	2c 31                	sub    $0x31,%al
f0107056:	36 3b 74 73 5f       	cmp    %ss:0x5f(%ebx,%esi,2),%esi
f010705b:	69 6f 6d 62 3a 28 32 	imul   $0x32283a62,0x6d(%edi),%ebp
f0107062:	2c 35                	sub    $0x35,%al
f0107064:	29 2c 38             	sub    %ebp,(%eax,%edi,1)
f0107067:	31 36                	xor    %esi,(%esi)
f0107069:	2c 31                	sub    $0x31,%al
f010706b:	36 3b 3b             	cmp    %ss:(%ebx),%edi
f010706e:	00 47 61             	add    %al,0x61(%edi)
f0107071:	74 65                	je     f01070d8 <__STABSTR_BEGIN__+0x8e7>
f0107073:	64                   	fs
f0107074:	65                   	gs
f0107075:	73 63                	jae    f01070da <__STABSTR_BEGIN__+0x8e9>
f0107077:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
f010707b:	2c 33                	sub    $0x33,%al
f010707d:	29 3d 73 38 67 64    	sub    %edi,0x64673873
f0107083:	5f                   	pop    %edi
f0107084:	6f                   	outsl  %ds:(%esi),(%dx)
f0107085:	66 66 5f             	pop    %di
f0107088:	31 35 5f 30 3a 28    	xor    %esi,0x283a305f
f010708e:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0107091:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
f0107094:	2c 31                	sub    $0x31,%al
f0107096:	36 3b 67 64          	cmp    %ss:0x64(%edi),%esp
f010709a:	5f                   	pop    %edi
f010709b:	73 73                	jae    f0107110 <__STABSTR_BEGIN__+0x91f>
f010709d:	3a 28                	cmp    (%eax),%ch
f010709f:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f01070a2:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
f01070a5:	36                   	ss
f01070a6:	2c 31                	sub    $0x31,%al
f01070a8:	36 3b 67 64          	cmp    %ss:0x64(%edi),%esp
f01070ac:	5f                   	pop    %edi
f01070ad:	61                   	popa   
f01070ae:	72 67                	jb     f0107117 <__STABSTR_BEGIN__+0x926>
f01070b0:	73 3a                	jae    f01070ec <__STABSTR_BEGIN__+0x8fb>
f01070b2:	28 30                	sub    %dh,(%eax)
f01070b4:	2c 34                	sub    $0x34,%al
f01070b6:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
f01070b9:	32 2c 35 3b 67 64 5f 	xor    0x5f64673b(,%esi,1),%ch
f01070c0:	72 73                	jb     f0107135 <__STABSTR_BEGIN__+0x944>
f01070c2:	76 31                	jbe    f01070f5 <__STABSTR_BEGIN__+0x904>
f01070c4:	3a 28                	cmp    (%eax),%ch
f01070c6:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f01070c9:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
f01070cc:	37                   	aaa    
f01070cd:	2c 33                	sub    $0x33,%al
f01070cf:	3b 67 64             	cmp    0x64(%edi),%esp
f01070d2:	5f                   	pop    %edi
f01070d3:	74 79                	je     f010714e <__STABSTR_BEGIN__+0x95d>
f01070d5:	70 65                	jo     f010713c <__STABSTR_BEGIN__+0x94b>
f01070d7:	3a 28                	cmp    (%eax),%ch
f01070d9:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f01070dc:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
f01070df:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f01070e2:	3b 67 64             	cmp    0x64(%edi),%esp
f01070e5:	5f                   	pop    %edi
f01070e6:	73 3a                	jae    f0107122 <__STABSTR_BEGIN__+0x931>
f01070e8:	28 30                	sub    %dh,(%eax)
f01070ea:	2c 34                	sub    $0x34,%al
f01070ec:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
f01070ef:	34 2c                	xor    $0x2c,%al
f01070f1:	31 3b                	xor    %edi,(%ebx)
f01070f3:	67                   	addr16
f01070f4:	64                   	fs
f01070f5:	5f                   	pop    %edi
f01070f6:	64                   	fs
f01070f7:	70 6c                	jo     f0107165 <__STABSTR_BEGIN__+0x974>
f01070f9:	3a 28                	cmp    (%eax),%ch
f01070fb:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f01070fe:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
f0107101:	35 2c 32 3b 67       	xor    $0x673b322c,%eax
f0107106:	64                   	fs
f0107107:	5f                   	pop    %edi
f0107108:	70 3a                	jo     f0107144 <__STABSTR_BEGIN__+0x953>
f010710a:	28 30                	sub    %dh,(%eax)
f010710c:	2c 34                	sub    $0x34,%al
f010710e:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
f0107111:	37                   	aaa    
f0107112:	2c 31                	sub    $0x31,%al
f0107114:	3b 67 64             	cmp    0x64(%edi),%esp
f0107117:	5f                   	pop    %edi
f0107118:	6f                   	outsl  %ds:(%esi),(%dx)
f0107119:	66 66 5f             	pop    %di
f010711c:	33 31                	xor    (%ecx),%esi
f010711e:	5f                   	pop    %edi
f010711f:	31 36                	xor    %esi,(%esi)
f0107121:	3a 28                	cmp    (%eax),%ch
f0107123:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0107126:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
f0107129:	38 2c 31             	cmp    %ch,(%ecx,%esi,1)
f010712c:	36 3b 3b             	cmp    %ss:(%ebx),%edi
f010712f:	00 50 73             	add    %dl,0x73(%eax)
f0107132:	65                   	gs
f0107133:	75 64                	jne    f0107199 <__STABSTR_BEGIN__+0x9a8>
f0107135:	6f                   	outsl  %ds:(%esi),(%dx)
f0107136:	64                   	fs
f0107137:	65                   	gs
f0107138:	73 63                	jae    f010719d <__STABSTR_BEGIN__+0x9ac>
f010713a:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
f010713e:	2c 34                	sub    $0x34,%al
f0107140:	29 3d 73 36 70 64    	sub    %edi,0x64703673
f0107146:	5f                   	pop    %edi
f0107147:	6c                   	insb   (%dx),%es:(%edi)
f0107148:	69 6d 3a 28 32 2c 35 	imul   $0x352c3228,0x3a(%ebp),%ebp
f010714f:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
f0107152:	2c 31                	sub    $0x31,%al
f0107154:	36 3b 70 64          	cmp    %ss:0x64(%eax),%esi
f0107158:	5f                   	pop    %edi
f0107159:	62 61 73             	bound  %esp,0x73(%ecx)
f010715c:	65 3a 28             	cmp    %gs:(%eax),%ch
f010715f:	32 2c 37             	xor    (%edi,%esi,1),%ch
f0107162:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
f0107165:	36                   	ss
f0107166:	2c 33                	sub    $0x33,%al
f0107168:	32 3b                	xor    (%ebx),%bh
f010716a:	3b 00                	cmp    (%eax),%eax
f010716c:	2e                   	cs
f010716d:	2f                   	das    
f010716e:	69 6e 63 2f 6d 65 6d 	imul   $0x6d656d2f,0x63(%esi),%ebp
f0107175:	6c                   	insb   (%dx),%es:(%edi)
f0107176:	61                   	popa   
f0107177:	79 6f                	jns    f01071e8 <__STABSTR_BEGIN__+0x9f7>
f0107179:	75 74                	jne    f01071ef <__STABSTR_BEGIN__+0x9fe>
f010717b:	2e                   	cs
f010717c:	68 00 70 74 65       	push   $0x65747000
f0107181:	5f                   	pop    %edi
f0107182:	74 3a                	je     f01071be <__STABSTR_BEGIN__+0x9cd>
f0107184:	74 28                	je     f01071ae <__STABSTR_BEGIN__+0x9bd>
f0107186:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
f0107189:	29 3d 28 32 2c 37    	sub    %edi,0x372c3228
f010718f:	29 00                	sub    %eax,(%eax)
f0107191:	70 64                	jo     f01071f7 <__STABSTR_BEGIN__+0xa06>
f0107193:	65                   	gs
f0107194:	5f                   	pop    %edi
f0107195:	74 3a                	je     f01071d1 <__STABSTR_BEGIN__+0x9e0>
f0107197:	74 28                	je     f01071c1 <__STABSTR_BEGIN__+0x9d0>
f0107199:	33 2c 32             	xor    (%edx,%esi,1),%ebp
f010719c:	29 3d 28 32 2c 37    	sub    %edi,0x372c3228
f01071a2:	29 00                	sub    %eax,(%eax)
f01071a4:	50                   	push   %eax
f01071a5:	61                   	popa   
f01071a6:	67                   	addr16
f01071a7:	65                   	gs
f01071a8:	5f                   	pop    %edi
f01071a9:	6c                   	insb   (%dx),%es:(%edi)
f01071aa:	69 73 74 3a 54 28 33 	imul   $0x3328543a,0x74(%ebx),%esi
f01071b1:	2c 33                	sub    $0x33,%al
f01071b3:	29 3d 73 34 6c 68    	sub    %edi,0x686c3473
f01071b9:	5f                   	pop    %edi
f01071ba:	66 69 72 73 74 3a    	imul   $0x3a74,0x73(%edx),%si
f01071c0:	28 33                	sub    %dh,(%ebx)
f01071c2:	2c 34                	sub    $0x34,%al
f01071c4:	29 3d 2a 28 33 2c    	sub    %edi,0x2c33282a
f01071ca:	35 29 3d 78 73       	xor    $0x73783d29,%eax
f01071cf:	50                   	push   %eax
f01071d0:	61                   	popa   
f01071d1:	67 65 3a 2c          	addr16 cmp %gs:(%si),%ch
f01071d5:	30 2c 33             	xor    %ch,(%ebx,%esi,1)
f01071d8:	32 3b                	xor    (%ebx),%bh
f01071da:	3b 00                	cmp    (%eax),%eax
f01071dc:	50                   	push   %eax
f01071dd:	61                   	popa   
f01071de:	67                   	addr16
f01071df:	65                   	gs
f01071e0:	5f                   	pop    %edi
f01071e1:	4c                   	dec    %esp
f01071e2:	49                   	dec    %ecx
f01071e3:	53                   	push   %ebx
f01071e4:	54                   	push   %esp
f01071e5:	5f                   	pop    %edi
f01071e6:	65 6e                	outsb  %gs:(%esi),(%dx)
f01071e8:	74 72                	je     f010725c <__STABSTR_BEGIN__+0xa6b>
f01071ea:	79 5f                	jns    f010724b <__STABSTR_BEGIN__+0xa5a>
f01071ec:	74 3a                	je     f0107228 <__STABSTR_BEGIN__+0xa37>
f01071ee:	74 28                	je     f0107218 <__STABSTR_BEGIN__+0xa27>
f01071f0:	33 2c 36             	xor    (%esi,%esi,1),%ebp
f01071f3:	29 3d 28 33 2c 37    	sub    %edi,0x372c3328
f01071f9:	29 3d 73 38 6c 65    	sub    %edi,0x656c3873
f01071ff:	5f                   	pop    %edi
f0107200:	6e                   	outsb  %ds:(%esi),(%dx)
f0107201:	65                   	gs
f0107202:	78 74                	js     f0107278 <__STABSTR_BEGIN__+0xa87>
f0107204:	3a 28                	cmp    (%eax),%ch
f0107206:	33 2c 34             	xor    (%esp,%esi,1),%ebp
f0107209:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
f010720c:	2c 33                	sub    $0x33,%al
f010720e:	32 3b                	xor    (%ebx),%bh
f0107210:	6c                   	insb   (%dx),%es:(%edi)
f0107211:	65                   	gs
f0107212:	5f                   	pop    %edi
f0107213:	70 72                	jo     f0107287 <__STABSTR_BEGIN__+0xa96>
f0107215:	65                   	gs
f0107216:	76 3a                	jbe    f0107252 <__STABSTR_BEGIN__+0xa61>
f0107218:	28 33                	sub    %dh,(%ebx)
f010721a:	2c 38                	sub    $0x38,%al
f010721c:	29 3d 2a 28 33 2c    	sub    %edi,0x2c33282a
f0107222:	34 29                	xor    $0x29,%al
f0107224:	2c 33                	sub    $0x33,%al
f0107226:	32 2c 33             	xor    (%ebx,%esi,1),%ch
f0107229:	32 3b                	xor    (%ebx),%bh
f010722b:	3b 00                	cmp    (%eax),%eax
f010722d:	50                   	push   %eax
f010722e:	61                   	popa   
f010722f:	67 65 3a 54 28       	addr16 cmp %gs:0x28(%si),%dl
f0107234:	33 2c 35 29 3d 73 31 	xor    0x31733d29(,%esi,1),%ebp
f010723b:	32 70 70             	xor    0x70(%eax),%dh
f010723e:	5f                   	pop    %edi
f010723f:	6c                   	insb   (%dx),%es:(%edi)
f0107240:	69 6e 6b 3a 28 33 2c 	imul   $0x2c33283a,0x6b(%esi),%ebp
f0107247:	36 29 2c 30          	sub    %ebp,%ss:(%eax,%esi,1)
f010724b:	2c 36                	sub    $0x36,%al
f010724d:	34 3b                	xor    $0x3b,%al
f010724f:	70 70                	jo     f01072c1 <__STABSTR_BEGIN__+0xad0>
f0107251:	5f                   	pop    %edi
f0107252:	72 65                	jb     f01072b9 <__STABSTR_BEGIN__+0xac8>
f0107254:	66                   	data16
f0107255:	3a 28                	cmp    (%eax),%ch
f0107257:	32 2c 35 29 2c 36 34 	xor    0x34362c29(,%esi,1),%ch
f010725e:	2c 31                	sub    $0x31,%al
f0107260:	36 3b 3b             	cmp    %ss:(%ebx),%edi
f0107263:	00 65 6e             	add    %ah,0x6e(%ebp)
f0107266:	74 72                	je     f01072da <__STABSTR_BEGIN__+0xae9>
f0107268:	79 5f                	jns    f01072c9 <__STABSTR_BEGIN__+0xad8>
f010726a:	70 67                	jo     f01072d3 <__STABSTR_BEGIN__+0xae2>
f010726c:	74 61                	je     f01072cf <__STABSTR_BEGIN__+0xade>
f010726e:	62 6c 65 3a          	bound  %ebp,0x3a(%ebp,%eiz,2)
f0107272:	47                   	inc    %edi
f0107273:	28 30                	sub    %dh,(%eax)
f0107275:	2c 31                	sub    $0x31,%al
f0107277:	39 29                	cmp    %ebp,(%ecx)
f0107279:	3d 61 72 28 30       	cmp    $0x30287261,%eax
f010727e:	2c 32                	sub    $0x32,%al
f0107280:	30 29                	xor    %ch,(%ecx)
f0107282:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
f0107287:	32 30                	xor    (%eax),%dh
f0107289:	29 3b                	sub    %edi,(%ebx)
f010728b:	30 3b                	xor    %bh,(%ebx)
f010728d:	2d 31 3b 3b 30       	sub    $0x303b3b31,%eax
f0107292:	3b 31                	cmp    (%ecx),%esi
f0107294:	30 32                	xor    %dh,(%edx)
f0107296:	33 3b                	xor    (%ebx),%edi
f0107298:	28 33                	sub    %dh,(%ebx)
f010729a:	2c 31                	sub    $0x31,%al
f010729c:	29 00                	sub    %eax,(%eax)
f010729e:	65 6e                	outsb  %gs:(%esi),(%dx)
f01072a0:	74 72                	je     f0107314 <__STABSTR_BEGIN__+0xb23>
f01072a2:	79 5f                	jns    f0107303 <__STABSTR_BEGIN__+0xb12>
f01072a4:	70 67                	jo     f010730d <__STABSTR_BEGIN__+0xb1c>
f01072a6:	64 69 72 3a 47 28 30 	imul   $0x2c302847,%fs:0x3a(%edx),%esi
f01072ad:	2c 
f01072ae:	32 31                	xor    (%ecx),%dh
f01072b0:	29 3d 61 72 28 30    	sub    %edi,0x30287261
f01072b6:	2c 32                	sub    $0x32,%al
f01072b8:	30 29                	xor    %ch,(%ecx)
f01072ba:	3b 30                	cmp    (%eax),%esi
f01072bc:	3b 31                	cmp    (%ecx),%esi
f01072be:	30 32                	xor    %dh,(%edx)
f01072c0:	33 3b                	xor    (%ebx),%edi
f01072c2:	28 33                	sub    %dh,(%ebx)
f01072c4:	2c 32                	sub    $0x32,%al
f01072c6:	29 00                	sub    %eax,(%eax)
f01072c8:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
f01072cc:	2f                   	das    
f01072cd:	69 6e 69 74 2e 63 00 	imul   $0x632e74,0x69(%esi),%ebp
f01072d4:	2e                   	cs
f01072d5:	2f                   	das    
f01072d6:	69 6e 63 2f 73 74 64 	imul   $0x6474732f,0x63(%esi),%ebp
f01072dd:	69 6f 2e 68 00 2e 2f 	imul   $0x2f2e0068,0x2e(%edi),%ebp
f01072e4:	69 6e 63 2f 73 74 64 	imul   $0x6474732f,0x63(%esi),%ebp
f01072eb:	61                   	popa   
f01072ec:	72 67                	jb     f0107355 <__STABSTR_BEGIN__+0xb64>
f01072ee:	2e                   	cs
f01072ef:	68 00 76 61 5f       	push   $0x5f617600
f01072f4:	6c                   	insb   (%dx),%es:(%edi)
f01072f5:	69 73 74 3a 74 28 32 	imul   $0x3228743a,0x74(%ebx),%esi
f01072fc:	2c 31                	sub    $0x31,%al
f01072fe:	29 3d 28 32 2c 32    	sub    %edi,0x322c3228
f0107304:	29 3d 2a 28 30 2c    	sub    %edi,0x2c30282a
f010730a:	32 29                	xor    (%ecx),%ch
f010730c:	00 2e                	add    %ch,(%esi)
f010730e:	2f                   	das    
f010730f:	69 6e 63 2f 73 74 72 	imul   $0x7274732f,0x63(%esi),%ebp
f0107316:	69 6e 67 2e 68 00 5f 	imul   $0x5f00682e,0x67(%esi),%ebp
f010731d:	77 61                	ja     f0107380 <__STABSTR_BEGIN__+0xb8f>
f010731f:	72 6e                	jb     f010738f <__STABSTR_BEGIN__+0xb9e>
f0107321:	3a 46 28             	cmp    0x28(%esi),%al
f0107324:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107327:	38 29                	cmp    %ch,(%ecx)
f0107329:	00 66 69             	add    %ah,0x69(%esi)
f010732c:	6c                   	insb   (%dx),%es:(%edi)
f010732d:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
f0107331:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107334:	39 29                	cmp    %ebp,(%ecx)
f0107336:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f010733b:	32 29                	xor    (%ecx),%ch
f010733d:	00 6c 69 6e          	add    %ch,0x6e(%ecx,%ebp,2)
f0107341:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
f0107345:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107348:	29 00                	sub    %eax,(%eax)
f010734a:	66 6d                	insw   (%dx),%es:(%edi)
f010734c:	74 3a                	je     f0107388 <__STABSTR_BEGIN__+0xb97>
f010734e:	70 28                	jo     f0107378 <__STABSTR_BEGIN__+0xb87>
f0107350:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107353:	39 29                	cmp    %ebp,(%ecx)
f0107355:	00 66 69             	add    %ah,0x69(%esi)
f0107358:	6c                   	insb   (%dx),%es:(%edi)
f0107359:	65 3a 72 28          	cmp    %gs:0x28(%edx),%dh
f010735d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107360:	39 29                	cmp    %ebp,(%ecx)
f0107362:	00 6c 69 6e          	add    %ch,0x6e(%ecx,%ebp,2)
f0107366:	65 3a 72 28          	cmp    %gs:0x28(%edx),%dh
f010736a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f010736d:	29 00                	sub    %eax,(%eax)
f010736f:	66 6d                	insw   (%dx),%es:(%edi)
f0107371:	74 3a                	je     f01073ad <__STABSTR_BEGIN__+0xbbc>
f0107373:	72 28                	jb     f010739d <__STABSTR_BEGIN__+0xbac>
f0107375:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107378:	39 29                	cmp    %ebp,(%ecx)
f010737a:	00 5f 70             	add    %bl,0x70(%edi)
f010737d:	61                   	popa   
f010737e:	6e                   	outsb  %ds:(%esi),(%dx)
f010737f:	69 63 3a 46 28 30 2c 	imul   $0x2c302846,0x3a(%ebx),%esp
f0107386:	31 38                	xor    %edi,(%eax)
f0107388:	29 00                	sub    %eax,(%eax)
f010738a:	66 69 6c 65 3a 70 28 	imul   $0x2870,0x3a(%ebp,%eiz,2),%bp
f0107391:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107394:	39 29                	cmp    %ebp,(%ecx)
f0107396:	00 74 65 73          	add    %dh,0x73(%ebp,%eiz,2)
f010739a:	74 5f                	je     f01073fb <__STABSTR_BEGIN__+0xc0a>
f010739c:	62 61 63             	bound  %esp,0x63(%ecx)
f010739f:	6b 74 72 61 63       	imul   $0x63,0x61(%edx,%esi,2),%esi
f01073a4:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
f01073a8:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01073ab:	38 29                	cmp    %ch,(%ecx)
f01073ad:	00 78 3a             	add    %bh,0x3a(%eax)
f01073b0:	70 28                	jo     f01073da <__STABSTR_BEGIN__+0xbe9>
f01073b2:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01073b5:	29 00                	sub    %eax,(%eax)
f01073b7:	78 3a                	js     f01073f3 <__STABSTR_BEGIN__+0xc02>
f01073b9:	72 28                	jb     f01073e3 <__STABSTR_BEGIN__+0xbf2>
f01073bb:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01073be:	29 00                	sub    %eax,(%eax)
f01073c0:	69 33 38 36 5f 69    	imul   $0x695f3638,(%ebx),%esi
f01073c6:	6e                   	outsb  %ds:(%esi),(%dx)
f01073c7:	69 74 3a 46 28 30 2c 	imul   $0x312c3028,0x46(%edx,%edi,1),%esi
f01073ce:	31 
f01073cf:	38 29                	cmp    %ch,(%ecx)
f01073d1:	00 63 68             	add    %ah,0x68(%ebx)
f01073d4:	6e                   	outsb  %ds:(%esi),(%dx)
f01073d5:	75 6d                	jne    f0107444 <__STABSTR_BEGIN__+0xc53>
f01073d7:	31 3a                	xor    %edi,(%edx)
f01073d9:	28 30                	sub    %dh,(%eax)
f01073db:	2c 32                	sub    $0x32,%al
f01073dd:	29 00                	sub    %eax,(%eax)
f01073df:	63 68 6e             	arpl   %bp,0x6e(%eax)
f01073e2:	75 6d                	jne    f0107451 <__STABSTR_BEGIN__+0xc60>
f01073e4:	32 3a                	xor    (%edx),%bh
f01073e6:	28 30                	sub    %dh,(%eax)
f01073e8:	2c 32                	sub    $0x32,%al
f01073ea:	29 00                	sub    %eax,(%eax)
f01073ec:	6e                   	outsb  %ds:(%esi),(%dx)
f01073ed:	74 65                	je     f0107454 <__STABSTR_BEGIN__+0xc63>
f01073ef:	73 74                	jae    f0107465 <__STABSTR_BEGIN__+0xc74>
f01073f1:	3a 28                	cmp    (%eax),%ch
f01073f3:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01073f6:	30 29                	xor    %ch,(%ecx)
f01073f8:	3d 61 72 28 30       	cmp    $0x30287261,%eax
f01073fd:	2c 32                	sub    $0x32,%al
f01073ff:	31 29                	xor    %ebp,(%ecx)
f0107401:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
f0107406:	32 31                	xor    (%ecx),%dh
f0107408:	29 3b                	sub    %edi,(%ebx)
f010740a:	30 3b                	xor    %bh,(%ebx)
f010740c:	2d 31 3b 3b 30       	sub    $0x303b3b31,%eax
f0107411:	3b 32                	cmp    (%edx),%esi
f0107413:	35 35 3b 28 30       	xor    $0x30283b35,%eax
f0107418:	2c 32                	sub    $0x32,%al
f010741a:	29 00                	sub    %eax,(%eax)
f010741c:	70 61                	jo     f010747f <__STABSTR_BEGIN__+0xc8e>
f010741e:	6e                   	outsb  %ds:(%esi),(%dx)
f010741f:	69 63 73 74 72 3a 53 	imul   $0x533a7274,0x73(%ebx),%esp
f0107426:	28 30                	sub    %dh,(%eax)
f0107428:	2c 31                	sub    $0x31,%al
f010742a:	39 29                	cmp    %ebp,(%ecx)
f010742c:	00 6b 65             	add    %ch,0x65(%ebx)
f010742f:	72 6e                	jb     f010749f <__STABSTR_BEGIN__+0xcae>
f0107431:	2f                   	das    
f0107432:	63 6f 6e             	arpl   %bp,0x6e(%edi)
f0107435:	73 6f                	jae    f01074a6 <__STABSTR_BEGIN__+0xcb5>
f0107437:	6c                   	insb   (%dx),%es:(%edi)
f0107438:	65 2e 63 00          	arpl   %ax,%cs:%gs:(%eax)
f010743c:	2e                   	cs
f010743d:	2f                   	das    
f010743e:	69 6e 63 2f 78 38 36 	imul   $0x3638782f,0x63(%esi),%ebp
f0107445:	2e                   	cs
f0107446:	68 00 2e 2f 69       	push   $0x692f2e00
f010744b:	6e                   	outsb  %ds:(%esi),(%dx)
f010744c:	63 2f                	arpl   %bp,(%edi)
f010744e:	61                   	popa   
f010744f:	73 73                	jae    f01074c4 <__STABSTR_BEGIN__+0xcd3>
f0107451:	65                   	gs
f0107452:	72 74                	jb     f01074c8 <__STABSTR_BEGIN__+0xcd7>
f0107454:	2e                   	cs
f0107455:	68 00 64 65 6c       	push   $0x6c656400
f010745a:	61                   	popa   
f010745b:	79 3a                	jns    f0107497 <__STABSTR_BEGIN__+0xca6>
f010745d:	66                   	data16
f010745e:	28 30                	sub    %dh,(%eax)
f0107460:	2c 31                	sub    $0x31,%al
f0107462:	38 29                	cmp    %ch,(%ecx)
f0107464:	00 64 61 74          	add    %ah,0x74(%ecx,%eiz,2)
f0107468:	61                   	popa   
f0107469:	3a 72 28             	cmp    0x28(%edx),%dh
f010746c:	32 2c 33             	xor    (%ebx,%esi,1),%ch
f010746f:	29 00                	sub    %eax,(%eax)
f0107471:	73 65                	jae    f01074d8 <__STABSTR_BEGIN__+0xce7>
f0107473:	72 69                	jb     f01074de <__STABSTR_BEGIN__+0xced>
f0107475:	61                   	popa   
f0107476:	6c                   	insb   (%dx),%es:(%edi)
f0107477:	5f                   	pop    %edi
f0107478:	70 72                	jo     f01074ec <__STABSTR_BEGIN__+0xcfb>
f010747a:	6f                   	outsl  %ds:(%esi),(%dx)
f010747b:	63 5f 64             	arpl   %bx,0x64(%edi)
f010747e:	61                   	popa   
f010747f:	74 61                	je     f01074e2 <__STABSTR_BEGIN__+0xcf1>
f0107481:	3a 66 28             	cmp    0x28(%esi),%ah
f0107484:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107487:	29 00                	sub    %eax,(%eax)
f0107489:	63 6f 6e             	arpl   %bp,0x6e(%edi)
f010748c:	73 5f                	jae    f01074ed <__STABSTR_BEGIN__+0xcfc>
f010748e:	69 6e 74 72 3a 66 28 	imul   $0x28663a72,0x74(%esi),%ebp
f0107495:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107498:	38 29                	cmp    %ch,(%ecx)
f010749a:	00 70 72             	add    %dh,0x72(%eax)
f010749d:	6f                   	outsl  %ds:(%esi),(%dx)
f010749e:	63 3a                	arpl   %di,(%edx)
f01074a0:	50                   	push   %eax
f01074a1:	28 30                	sub    %dh,(%eax)
f01074a3:	2c 31                	sub    $0x31,%al
f01074a5:	39 29                	cmp    %ebp,(%ecx)
f01074a7:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f01074ac:	32 30                	xor    (%eax),%dh
f01074ae:	29 3d 66 28 30 2c    	sub    %edi,0x2c302866
f01074b4:	31 29                	xor    %ebp,(%ecx)
f01074b6:	00 63 3a             	add    %ah,0x3a(%ebx)
f01074b9:	72 28                	jb     f01074e3 <__STABSTR_BEGIN__+0xcf2>
f01074bb:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01074be:	29 00                	sub    %eax,(%eax)
f01074c0:	6b 62 64 5f          	imul   $0x5f,0x64(%edx),%esp
f01074c4:	69 6e 74 72 3a 46 28 	imul   $0x28463a72,0x74(%esi),%ebp
f01074cb:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01074ce:	38 29                	cmp    %ch,(%ecx)
f01074d0:	00 73 65             	add    %dh,0x65(%ebx)
f01074d3:	72 69                	jb     f010753e <__STABSTR_BEGIN__+0xd4d>
f01074d5:	61                   	popa   
f01074d6:	6c                   	insb   (%dx),%es:(%edi)
f01074d7:	5f                   	pop    %edi
f01074d8:	69 6e 74 72 3a 46 28 	imul   $0x28463a72,0x74(%esi),%ebp
f01074df:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01074e2:	38 29                	cmp    %ch,(%ecx)
f01074e4:	00 63 6f             	add    %ah,0x6f(%ebx)
f01074e7:	6e                   	outsb  %ds:(%esi),(%dx)
f01074e8:	73 5f                	jae    f0107549 <__STABSTR_BEGIN__+0xd58>
f01074ea:	67                   	addr16
f01074eb:	65                   	gs
f01074ec:	74 63                	je     f0107551 <__STABSTR_BEGIN__+0xd60>
f01074ee:	3a 46 28             	cmp    0x28(%esi),%al
f01074f1:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01074f4:	29 00                	sub    %eax,(%eax)
f01074f6:	67                   	addr16
f01074f7:	65                   	gs
f01074f8:	74 63                	je     f010755d <__STABSTR_BEGIN__+0xd6c>
f01074fa:	68 61 72 3a 46       	push   $0x463a7261
f01074ff:	28 30                	sub    %dh,(%eax)
f0107501:	2c 31                	sub    $0x31,%al
f0107503:	29 00                	sub    %eax,(%eax)
f0107505:	69 73 63 6f 6e 73 3a 	imul   $0x3a736e6f,0x63(%ebx),%esi
f010750c:	46                   	inc    %esi
f010750d:	28 30                	sub    %dh,(%eax)
f010750f:	2c 31                	sub    $0x31,%al
f0107511:	29 00                	sub    %eax,(%eax)
f0107513:	66                   	data16
f0107514:	64 6e                	outsb  %fs:(%esi),(%dx)
f0107516:	75 6d                	jne    f0107585 <__STABSTR_BEGIN__+0xd94>
f0107518:	3a 70 28             	cmp    0x28(%eax),%dh
f010751b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f010751e:	29 00                	sub    %eax,(%eax)
f0107520:	63 6f 6e             	arpl   %bp,0x6e(%edi)
f0107523:	73 5f                	jae    f0107584 <__STABSTR_BEGIN__+0xd93>
f0107525:	70 75                	jo     f010759c <__STABSTR_BEGIN__+0xdab>
f0107527:	74 63                	je     f010758c <__STABSTR_BEGIN__+0xd9b>
f0107529:	3a 66 28             	cmp    0x28(%esi),%ah
f010752c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f010752f:	38 29                	cmp    %ch,(%ecx)
f0107531:	00 63 3a             	add    %ah,0x3a(%ebx)
f0107534:	50                   	push   %eax
f0107535:	28 30                	sub    %dh,(%eax)
f0107537:	2c 31                	sub    $0x31,%al
f0107539:	29 00                	sub    %eax,(%eax)
f010753b:	69 3a 72 28 30 2c    	imul   $0x2c302872,(%edx),%edi
f0107541:	31 29                	xor    %ebp,(%ecx)
f0107543:	00 63 70             	add    %ah,0x70(%ebx)
f0107546:	75 74                	jne    f01075bc <__STABSTR_BEGIN__+0xdcb>
f0107548:	63 68 61             	arpl   %bp,0x61(%eax)
f010754b:	72 3a                	jb     f0107587 <__STABSTR_BEGIN__+0xd96>
f010754d:	46                   	inc    %esi
f010754e:	28 30                	sub    %dh,(%eax)
f0107550:	2c 31                	sub    $0x31,%al
f0107552:	38 29                	cmp    %ch,(%ecx)
f0107554:	00 63 3a             	add    %ah,0x3a(%ebx)
f0107557:	70 28                	jo     f0107581 <__STABSTR_BEGIN__+0xd90>
f0107559:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f010755c:	29 00                	sub    %eax,(%eax)
f010755e:	63 6f 6e             	arpl   %bp,0x6e(%edi)
f0107561:	73 5f                	jae    f01075c2 <__STABSTR_BEGIN__+0xdd1>
f0107563:	69 6e 69 74 3a 46 28 	imul   $0x28463a74,0x69(%esi),%ebp
f010756a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f010756d:	38 29                	cmp    %ch,(%ecx)
f010756f:	00 63 70             	add    %ah,0x70(%ebx)
f0107572:	3a 72 28             	cmp    0x28(%edx),%dh
f0107575:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107578:	31 29                	xor    %ebp,(%ecx)
f010757a:	3d 2a 28 32 2c       	cmp    $0x2c32282a,%eax
f010757f:	35 29 00 77 61       	xor    $0x61770029,%eax
f0107584:	73 3a                	jae    f01075c0 <__STABSTR_BEGIN__+0xdcf>
f0107586:	72 28                	jb     f01075b0 <__STABSTR_BEGIN__+0xdbf>
f0107588:	32 2c 35 29 00 70 6f 	xor    0x6f700029(,%esi,1),%ch
f010758f:	73 3a                	jae    f01075cb <__STABSTR_BEGIN__+0xdda>
f0107591:	72 28                	jb     f01075bb <__STABSTR_BEGIN__+0xdca>
f0107593:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0107596:	29 00                	sub    %eax,(%eax)
f0107598:	6b 62 64 5f          	imul   $0x5f,0x64(%edx),%esp
f010759c:	70 72                	jo     f0107610 <__STABSTR_BEGIN__+0xe1f>
f010759e:	6f                   	outsl  %ds:(%esi),(%dx)
f010759f:	63 5f 64             	arpl   %bx,0x64(%edi)
f01075a2:	61                   	popa   
f01075a3:	74 61                	je     f0107606 <__STABSTR_BEGIN__+0xe15>
f01075a5:	3a 66 28             	cmp    0x28(%esi),%ah
f01075a8:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01075ab:	29 00                	sub    %eax,(%eax)
f01075ad:	73 68                	jae    f0107617 <__STABSTR_BEGIN__+0xe26>
f01075af:	69 66 74 3a 56 28 32 	imul   $0x3228563a,0x74(%esi),%esp
f01075b6:	2c 37                	sub    $0x37,%al
f01075b8:	29 00                	sub    %eax,(%eax)
f01075ba:	73 65                	jae    f0107621 <__STABSTR_BEGIN__+0xe30>
f01075bc:	72 69                	jb     f0107627 <__STABSTR_BEGIN__+0xe36>
f01075be:	61                   	popa   
f01075bf:	6c                   	insb   (%dx),%es:(%edi)
f01075c0:	5f                   	pop    %edi
f01075c1:	65                   	gs
f01075c2:	78 69                	js     f010762d <__STABSTR_BEGIN__+0xe3c>
f01075c4:	73 74                	jae    f010763a <__STABSTR_BEGIN__+0xe49>
f01075c6:	73 3a                	jae    f0107602 <__STABSTR_BEGIN__+0xe11>
f01075c8:	53                   	push   %ebx
f01075c9:	28 32                	sub    %dh,(%edx)
f01075cb:	2c 31                	sub    $0x31,%al
f01075cd:	29 00                	sub    %eax,(%eax)
f01075cf:	61                   	popa   
f01075d0:	64                   	fs
f01075d1:	64                   	fs
f01075d2:	72 5f                	jb     f0107633 <__STABSTR_BEGIN__+0xe42>
f01075d4:	36 38 34 35 3a 53 28 	cmp    %dh,%ss:0x3028533a(,%esi,1)
f01075db:	30 
f01075dc:	2c 34                	sub    $0x34,%al
f01075de:	29 00                	sub    %eax,(%eax)
f01075e0:	63 72 74             	arpl   %si,0x74(%edx)
f01075e3:	5f                   	pop    %edi
f01075e4:	62 75 66             	bound  %esi,0x66(%ebp)
f01075e7:	3a 53 28             	cmp    0x28(%ebx),%dl
f01075ea:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01075ed:	32 29                	xor    (%ecx),%ch
f01075ef:	3d 2a 28 32 2c       	cmp    $0x2c32282a,%eax
f01075f4:	35 29 00 63 72       	xor    $0x72630029,%eax
f01075f9:	74 5f                	je     f010765a <__STABSTR_BEGIN__+0xe69>
f01075fb:	70 6f                	jo     f010766c <__STABSTR_BEGIN__+0xe7b>
f01075fd:	73 3a                	jae    f0107639 <__STABSTR_BEGIN__+0xe48>
f01075ff:	53                   	push   %ebx
f0107600:	28 32                	sub    %dh,(%edx)
f0107602:	2c 35                	sub    $0x35,%al
f0107604:	29 00                	sub    %eax,(%eax)
f0107606:	73 68                	jae    f0107670 <__STABSTR_BEGIN__+0xe7f>
f0107608:	69 66 74 63 6f 64 65 	imul   $0x65646f63,0x74(%esi),%esp
f010760f:	3a 53 28             	cmp    0x28(%ebx),%dl
f0107612:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107615:	33 29                	xor    (%ecx),%ebp
f0107617:	3d 61 72 28 30       	cmp    $0x30287261,%eax
f010761c:	2c 32                	sub    $0x32,%al
f010761e:	34 29                	xor    $0x29,%al
f0107620:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
f0107625:	32 34 29             	xor    (%ecx,%ebp,1),%dh
f0107628:	3b 30                	cmp    (%eax),%esi
f010762a:	3b 2d 31 3b 3b 30    	cmp    0x303b3b31,%ebp
f0107630:	3b 32                	cmp    (%edx),%esi
f0107632:	35 35 3b 28 32       	xor    $0x32283b35,%eax
f0107637:	2c 33                	sub    $0x33,%al
f0107639:	29 00                	sub    %eax,(%eax)
f010763b:	74 6f                	je     f01076ac <__STABSTR_BEGIN__+0xebb>
f010763d:	67 67 6c             	addr16 insb (%dx),%es:(%di)
f0107640:	65 63 6f 64          	arpl   %bp,%gs:0x64(%edi)
f0107644:	65 3a 53 28          	cmp    %gs:0x28(%ebx),%dl
f0107648:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f010764b:	33 29                	xor    (%ecx),%ebp
f010764d:	00 6e 6f             	add    %ch,0x6f(%esi)
f0107650:	72 6d                	jb     f01076bf <__STABSTR_BEGIN__+0xece>
f0107652:	61                   	popa   
f0107653:	6c                   	insb   (%dx),%es:(%edi)
f0107654:	6d                   	insl   (%dx),%es:(%edi)
f0107655:	61                   	popa   
f0107656:	70 3a                	jo     f0107692 <__STABSTR_BEGIN__+0xea1>
f0107658:	53                   	push   %ebx
f0107659:	28 30                	sub    %dh,(%eax)
f010765b:	2c 32                	sub    $0x32,%al
f010765d:	33 29                	xor    (%ecx),%ebp
f010765f:	00 73 68             	add    %dh,0x68(%ebx)
f0107662:	69 66 74 6d 61 70 3a 	imul   $0x3a70616d,0x74(%esi),%esp
f0107669:	53                   	push   %ebx
f010766a:	28 30                	sub    %dh,(%eax)
f010766c:	2c 32                	sub    $0x32,%al
f010766e:	33 29                	xor    (%ecx),%ebp
f0107670:	00 63 74             	add    %ah,0x74(%ebx)
f0107673:	6c                   	insb   (%dx),%es:(%edi)
f0107674:	6d                   	insl   (%dx),%es:(%edi)
f0107675:	61                   	popa   
f0107676:	70 3a                	jo     f01076b2 <__STABSTR_BEGIN__+0xec1>
f0107678:	53                   	push   %ebx
f0107679:	28 30                	sub    %dh,(%eax)
f010767b:	2c 32                	sub    $0x32,%al
f010767d:	33 29                	xor    (%ecx),%ebp
f010767f:	00 63 68             	add    %ah,0x68(%ebx)
f0107682:	61                   	popa   
f0107683:	72 63                	jb     f01076e8 <__STABSTR_BEGIN__+0xef7>
f0107685:	6f                   	outsl  %ds:(%esi),(%dx)
f0107686:	64 65 3a 53 28       	cmp    %fs:%gs:0x28(%ebx),%dl
f010768b:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f010768e:	35 29 3d 61 72       	xor    $0x72613d29,%eax
f0107693:	28 30                	sub    %dh,(%eax)
f0107695:	2c 32                	sub    $0x32,%al
f0107697:	34 29                	xor    $0x29,%al
f0107699:	3b 30                	cmp    (%eax),%esi
f010769b:	3b 33                	cmp    (%ebx),%esi
f010769d:	3b 28                	cmp    (%eax),%ebp
f010769f:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01076a2:	36 29 3d 2a 28 32 2c 	sub    %edi,%ss:0x2c32282a
f01076a9:	33 29                	xor    (%ecx),%ebp
f01076ab:	00 63 6f             	add    %ah,0x6f(%ebx)
f01076ae:	6e                   	outsb  %ds:(%esi),(%dx)
f01076af:	73 3a                	jae    f01076eb <__STABSTR_BEGIN__+0xefa>
f01076b1:	53                   	push   %ebx
f01076b2:	28 30                	sub    %dh,(%eax)
f01076b4:	2c 32                	sub    $0x32,%al
f01076b6:	37                   	aaa    
f01076b7:	29 3d 73 35 32 30    	sub    %edi,0x30323573
f01076bd:	62 75 66             	bound  %esi,0x66(%ebp)
f01076c0:	3a 28                	cmp    (%eax),%ch
f01076c2:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01076c5:	38 29                	cmp    %ch,(%ecx)
f01076c7:	3d 61 72 28 30       	cmp    $0x30287261,%eax
f01076cc:	2c 32                	sub    $0x32,%al
f01076ce:	34 29                	xor    $0x29,%al
f01076d0:	3b 30                	cmp    (%eax),%esi
f01076d2:	3b 35 31 31 3b 28    	cmp    0x283b3131,%esi
f01076d8:	32 2c 33             	xor    (%ebx,%esi,1),%ch
f01076db:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
f01076de:	2c 34                	sub    $0x34,%al
f01076e0:	30 39                	xor    %bh,(%ecx)
f01076e2:	36 3b 72 70          	cmp    %ss:0x70(%edx),%esi
f01076e6:	6f                   	outsl  %ds:(%esi),(%dx)
f01076e7:	73 3a                	jae    f0107723 <__STABSTR_BEGIN__+0xf32>
f01076e9:	28 32                	sub    %dh,(%edx)
f01076eb:	2c 37                	sub    $0x37,%al
f01076ed:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
f01076f0:	30 39                	xor    %bh,(%ecx)
f01076f2:	36                   	ss
f01076f3:	2c 33                	sub    $0x33,%al
f01076f5:	32 3b                	xor    (%ebx),%bh
f01076f7:	77 70                	ja     f0107769 <__STABSTR_BEGIN__+0xf78>
f01076f9:	6f                   	outsl  %ds:(%esi),(%dx)
f01076fa:	73 3a                	jae    f0107736 <__STABSTR_BEGIN__+0xf45>
f01076fc:	28 32                	sub    %dh,(%edx)
f01076fe:	2c 37                	sub    $0x37,%al
f0107700:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
f0107703:	31 32                	xor    %esi,(%edx)
f0107705:	38 2c 33             	cmp    %ch,(%ebx,%esi,1)
f0107708:	32 3b                	xor    (%ebx),%bh
f010770a:	3b 00                	cmp    (%eax),%eax
f010770c:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
f0107710:	2f                   	das    
f0107711:	6d                   	insl   (%dx),%es:(%edi)
f0107712:	6f                   	outsl  %ds:(%esi),(%dx)
f0107713:	6e                   	outsb  %ds:(%esi),(%dx)
f0107714:	69 74 6f 72 2e 63 00 	imul   $0x2e00632e,0x72(%edi,%ebp,2),%esi
f010771b:	2e 
f010771c:	2f                   	das    
f010771d:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
f0107721:	2f                   	das    
f0107722:	6b 64 65 62 75       	imul   $0x75,0x62(%ebp,%eiz,2),%esp
f0107727:	67                   	addr16
f0107728:	2e                   	cs
f0107729:	68 00 45 69 70       	push   $0x70694500
f010772e:	64 65 62 75 67       	bound  %esi,%fs:%gs:0x67(%ebp)
f0107733:	69 6e 66 6f 3a 54 28 	imul   $0x28543a6f,0x66(%esi),%ebp
f010773a:	37                   	aaa    
f010773b:	2c 31                	sub    $0x31,%al
f010773d:	29 3d 73 32 34 65    	sub    %edi,0x65343273
f0107743:	69 70 5f 66 69 6c 65 	imul   $0x656c6966,0x5f(%eax),%esi
f010774a:	3a 28                	cmp    (%eax),%ch
f010774c:	37                   	aaa    
f010774d:	2c 32                	sub    $0x32,%al
f010774f:	29 3d 2a 28 30 2c    	sub    %edi,0x2c30282a
f0107755:	32 29                	xor    (%ecx),%ch
f0107757:	2c 30                	sub    $0x30,%al
f0107759:	2c 33                	sub    $0x33,%al
f010775b:	32 3b                	xor    (%ebx),%bh
f010775d:	65 69 70 5f 6c 69 6e 	imul   $0x656e696c,%gs:0x5f(%eax),%esi
f0107764:	65 
f0107765:	3a 28                	cmp    (%eax),%ch
f0107767:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f010776a:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
f010776d:	32 2c 33             	xor    (%ebx,%esi,1),%ch
f0107770:	32 3b                	xor    (%ebx),%bh
f0107772:	65 69 70 5f 66 6e 5f 	imul   $0x6e5f6e66,%gs:0x5f(%eax),%esi
f0107779:	6e 
f010777a:	61                   	popa   
f010777b:	6d                   	insl   (%dx),%es:(%edi)
f010777c:	65 3a 28             	cmp    %gs:(%eax),%ch
f010777f:	37                   	aaa    
f0107780:	2c 32                	sub    $0x32,%al
f0107782:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
f0107785:	34 2c                	xor    $0x2c,%al
f0107787:	33 32                	xor    (%edx),%esi
f0107789:	3b 65 69             	cmp    0x69(%ebp),%esp
f010778c:	70 5f                	jo     f01077ed <__STABSTR_BEGIN__+0xffc>
f010778e:	66                   	data16
f010778f:	6e                   	outsb  %ds:(%esi),(%dx)
f0107790:	5f                   	pop    %edi
f0107791:	6e                   	outsb  %ds:(%esi),(%dx)
f0107792:	61                   	popa   
f0107793:	6d                   	insl   (%dx),%es:(%edi)
f0107794:	65                   	gs
f0107795:	6c                   	insb   (%dx),%es:(%edi)
f0107796:	65 6e                	outsb  %gs:(%esi),(%dx)
f0107798:	3a 28                	cmp    (%eax),%ch
f010779a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f010779d:	29 2c 39             	sub    %ebp,(%ecx,%edi,1)
f01077a0:	36                   	ss
f01077a1:	2c 33                	sub    $0x33,%al
f01077a3:	32 3b                	xor    (%ebx),%bh
f01077a5:	65 69 70 5f 66 6e 5f 	imul   $0x615f6e66,%gs:0x5f(%eax),%esi
f01077ac:	61 
f01077ad:	64                   	fs
f01077ae:	64                   	fs
f01077af:	72 3a                	jb     f01077eb <__STABSTR_BEGIN__+0xffa>
f01077b1:	28 34 2c             	sub    %dh,(%esp,%ebp,1)
f01077b4:	31 31                	xor    %esi,(%ecx)
f01077b6:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
f01077b9:	32 38                	xor    (%eax),%bh
f01077bb:	2c 33                	sub    $0x33,%al
f01077bd:	32 3b                	xor    (%ebx),%bh
f01077bf:	65 69 70 5f 66 6e 5f 	imul   $0x6e5f6e66,%gs:0x5f(%eax),%esi
f01077c6:	6e 
f01077c7:	61                   	popa   
f01077c8:	72 67                	jb     f0107831 <__STABSTR_BEGIN__+0x1040>
f01077ca:	3a 28                	cmp    (%eax),%ch
f01077cc:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01077cf:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
f01077d2:	36 30 2c 33          	xor    %ch,%ss:(%ebx,%esi,1)
f01077d6:	32 3b                	xor    (%ebx),%bh
f01077d8:	3b 00                	cmp    (%eax),%eax
f01077da:	43                   	inc    %ebx
f01077db:	6f                   	outsl  %ds:(%esi),(%dx)
f01077dc:	6d                   	insl   (%dx),%es:(%edi)
f01077dd:	6d                   	insl   (%dx),%es:(%edi)
f01077de:	61                   	popa   
f01077df:	6e                   	outsb  %ds:(%esi),(%dx)
f01077e0:	64 3a 54 28 30       	cmp    %fs:0x30(%eax,%ebp,1),%dl
f01077e5:	2c 31                	sub    $0x31,%al
f01077e7:	39 29                	cmp    %ebp,(%ecx)
f01077e9:	3d 73 31 32 6e       	cmp    $0x6e323173,%eax
f01077ee:	61                   	popa   
f01077ef:	6d                   	insl   (%dx),%es:(%edi)
f01077f0:	65 3a 28             	cmp    %gs:(%eax),%ch
f01077f3:	37                   	aaa    
f01077f4:	2c 32                	sub    $0x32,%al
f01077f6:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
f01077f9:	2c 33                	sub    $0x33,%al
f01077fb:	32 3b                	xor    (%ebx),%bh
f01077fd:	64                   	fs
f01077fe:	65                   	gs
f01077ff:	73 63                	jae    f0107864 <__STABSTR_BEGIN__+0x1073>
f0107801:	3a 28                	cmp    (%eax),%ch
f0107803:	37                   	aaa    
f0107804:	2c 32                	sub    $0x32,%al
f0107806:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
f0107809:	32 2c 33             	xor    (%ebx,%esi,1),%ch
f010780c:	32 3b                	xor    (%ebx),%bh
f010780e:	66                   	data16
f010780f:	75 6e                	jne    f010787f <__STABSTR_BEGIN__+0x108e>
f0107811:	63 3a                	arpl   %di,(%edx)
f0107813:	28 30                	sub    %dh,(%eax)
f0107815:	2c 32                	sub    $0x32,%al
f0107817:	30 29                	xor    %ch,(%ecx)
f0107819:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f010781e:	32 31                	xor    (%ecx),%dh
f0107820:	29 3d 66 28 30 2c    	sub    %edi,0x2c302866
f0107826:	31 29                	xor    %ebp,(%ecx)
f0107828:	2c 36                	sub    $0x36,%al
f010782a:	34 2c                	xor    $0x2c,%al
f010782c:	33 32                	xor    (%edx),%esi
f010782e:	3b 3b                	cmp    (%ebx),%edi
f0107830:	00 67 65             	add    %ah,0x65(%edi)
f0107833:	74 62                	je     f0107897 <__STABSTR_BEGIN__+0x10a6>
f0107835:	75 66                	jne    f010789d <__STABSTR_BEGIN__+0x10ac>
f0107837:	66                   	data16
f0107838:	3a 46 28             	cmp    0x28(%esi),%al
f010783b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f010783e:	38 29                	cmp    %ch,(%ecx)
f0107840:	00 73 74             	add    %dh,0x74(%ebx)
f0107843:	72 3a                	jb     f010787f <__STABSTR_BEGIN__+0x108e>
f0107845:	70 28                	jo     f010786f <__STABSTR_BEGIN__+0x107e>
f0107847:	32 2c 32             	xor    (%edx,%esi,1),%ch
f010784a:	29 00                	sub    %eax,(%eax)
f010784c:	73 74                	jae    f01078c2 <__STABSTR_BEGIN__+0x10d1>
f010784e:	72 3a                	jb     f010788a <__STABSTR_BEGIN__+0x1099>
f0107850:	72 28                	jb     f010787a <__STABSTR_BEGIN__+0x1089>
f0107852:	32 2c 32             	xor    (%edx,%esi,1),%ch
f0107855:	29 00                	sub    %eax,(%eax)
f0107857:	70 72                	jo     f01078cb <__STABSTR_BEGIN__+0x10da>
f0107859:	65                   	gs
f010785a:	74 61                	je     f01078bd <__STABSTR_BEGIN__+0x10cc>
f010785c:	64                   	fs
f010785d:	64                   	fs
f010785e:	72 3a                	jb     f010789a <__STABSTR_BEGIN__+0x10a9>
f0107860:	72 28                	jb     f010788a <__STABSTR_BEGIN__+0x1099>
f0107862:	34 2c                	xor    $0x2c,%al
f0107864:	37                   	aaa    
f0107865:	29 00                	sub    %eax,(%eax)
f0107867:	73 74                	jae    f01078dd <__STABSTR_BEGIN__+0x10ec>
f0107869:	61                   	popa   
f010786a:	72 74                	jb     f01078e0 <__STABSTR_BEGIN__+0x10ef>
f010786c:	5f                   	pop    %edi
f010786d:	6f                   	outsl  %ds:(%esi),(%dx)
f010786e:	76 65                	jbe    f01078d5 <__STABSTR_BEGIN__+0x10e4>
f0107870:	72 66                	jb     f01078d8 <__STABSTR_BEGIN__+0x10e7>
f0107872:	6c                   	insb   (%dx),%es:(%edi)
f0107873:	6f                   	outsl  %ds:(%esi),(%dx)
f0107874:	77 3a                	ja     f01078b0 <__STABSTR_BEGIN__+0x10bf>
f0107876:	46                   	inc    %esi
f0107877:	28 30                	sub    %dh,(%eax)
f0107879:	2c 31                	sub    $0x31,%al
f010787b:	38 29                	cmp    %ch,(%ecx)
f010787d:	00 73 74             	add    %dh,0x74(%ebx)
f0107880:	72 3a                	jb     f01078bc <__STABSTR_BEGIN__+0x10cb>
f0107882:	28 30                	sub    %dh,(%eax)
f0107884:	2c 32                	sub    $0x32,%al
f0107886:	32 29                	xor    (%ecx),%ch
f0107888:	3d 61 72 28 30       	cmp    $0x30287261,%eax
f010788d:	2c 32                	sub    $0x32,%al
f010788f:	33 29                	xor    (%ecx),%ebp
f0107891:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
f0107896:	32 33                	xor    (%ebx),%dh
f0107898:	29 3b                	sub    %edi,(%ebx)
f010789a:	30 3b                	xor    %bh,(%ebx)
f010789c:	2d 31 3b 3b 30       	sub    $0x303b3b31,%eax
f01078a1:	3b 32                	cmp    (%edx),%esi
f01078a3:	35 35 3b 28 30       	xor    $0x30283b35,%eax
f01078a8:	2c 32                	sub    $0x32,%al
f01078aa:	29 00                	sub    %eax,(%eax)
f01078ac:	70 74                	jo     f0107922 <__STABSTR_BEGIN__+0x1131>
f01078ae:	72 3a                	jb     f01078ea <__STABSTR_BEGIN__+0x10f9>
f01078b0:	72 28                	jb     f01078da <__STABSTR_BEGIN__+0x10e9>
f01078b2:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01078b5:	34 29                	xor    $0x29,%al
f01078b7:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f01078bc:	31 29                	xor    %ebp,(%ecx)
f01078be:	00 6f 76             	add    %ch,0x76(%edi)
f01078c1:	65                   	gs
f01078c2:	72 66                	jb     f010792a <__STABSTR_BEGIN__+0x1139>
f01078c4:	6c                   	insb   (%dx),%es:(%edi)
f01078c5:	6f                   	outsl  %ds:(%esi),(%dx)
f01078c6:	77 5f                	ja     f0107927 <__STABSTR_BEGIN__+0x1136>
f01078c8:	6d                   	insl   (%dx),%es:(%edi)
f01078c9:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
f01078cd:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01078d0:	38 29                	cmp    %ch,(%ecx)
f01078d2:	00 72 65             	add    %dh,0x65(%edx)
f01078d5:	61                   	popa   
f01078d6:	64                   	fs
f01078d7:	5f                   	pop    %edi
f01078d8:	65 69 70 3a 46 28 30 	imul   $0x2c302846,%gs:0x3a(%eax),%esi
f01078df:	2c 
f01078e0:	34 29                	xor    $0x29,%al
f01078e2:	00 63 61             	add    %ah,0x61(%ebx)
f01078e5:	6c                   	insb   (%dx),%es:(%edi)
f01078e6:	6c                   	insb   (%dx),%es:(%edi)
f01078e7:	65                   	gs
f01078e8:	72 70                	jb     f010795a <__STABSTR_BEGIN__+0x1169>
f01078ea:	63 3a                	arpl   %di,(%edx)
f01078ec:	72 28                	jb     f0107916 <__STABSTR_BEGIN__+0x1125>
f01078ee:	34 2c                	xor    $0x2c,%al
f01078f0:	37                   	aaa    
f01078f1:	29 00                	sub    %eax,(%eax)
f01078f3:	64 6f                	outsl  %fs:(%esi),(%dx)
f01078f5:	5f                   	pop    %edi
f01078f6:	6f                   	outsl  %ds:(%esi),(%dx)
f01078f7:	76 65                	jbe    f010795e <__STABSTR_BEGIN__+0x116d>
f01078f9:	72 66                	jb     f0107961 <__STABSTR_BEGIN__+0x1170>
f01078fb:	6c                   	insb   (%dx),%es:(%edi)
f01078fc:	6f                   	outsl  %ds:(%esi),(%dx)
f01078fd:	77 3a                	ja     f0107939 <__STABSTR_BEGIN__+0x1148>
f01078ff:	46                   	inc    %esi
f0107900:	28 30                	sub    %dh,(%eax)
f0107902:	2c 31                	sub    $0x31,%al
f0107904:	38 29                	cmp    %ch,(%ecx)
f0107906:	00 6d 6f             	add    %ch,0x6f(%ebp)
f0107909:	6e                   	outsb  %ds:(%esi),(%dx)
f010790a:	5f                   	pop    %edi
f010790b:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
f010790f:	69 6e 66 6f 3a 46 28 	imul   $0x28463a6f,0x66(%esi),%ebp
f0107916:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107919:	29 00                	sub    %eax,(%eax)
f010791b:	61                   	popa   
f010791c:	72 67                	jb     f0107985 <__STABSTR_BEGIN__+0x1194>
f010791e:	63 3a                	arpl   %di,(%edx)
f0107920:	70 28                	jo     f010794a <__STABSTR_BEGIN__+0x1159>
f0107922:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107925:	29 00                	sub    %eax,(%eax)
f0107927:	61                   	popa   
f0107928:	72 67                	jb     f0107991 <__STABSTR_BEGIN__+0x11a0>
f010792a:	76 3a                	jbe    f0107966 <__STABSTR_BEGIN__+0x1175>
f010792c:	70 28                	jo     f0107956 <__STABSTR_BEGIN__+0x1165>
f010792e:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107931:	35 29 3d 2a 28       	xor    $0x282a3d29,%eax
f0107936:	32 2c 32             	xor    (%edx,%esi,1),%ch
f0107939:	29 00                	sub    %eax,(%eax)
f010793b:	74 66                	je     f01079a3 <__STABSTR_BEGIN__+0x11b2>
f010793d:	3a 70 28             	cmp    0x28(%eax),%dh
f0107940:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107943:	36 29 3d 2a 28 30 2c 	sub    %edi,%ss:0x2c30282a
f010794a:	32 37                	xor    (%edi),%dh
f010794c:	29 3d 78 73 54 72    	sub    %edi,0x72547378
f0107952:	61                   	popa   
f0107953:	70 66                	jo     f01079bb <__STABSTR_BEGIN__+0x11ca>
f0107955:	72 61                	jb     f01079b8 <__STABSTR_BEGIN__+0x11c7>
f0107957:	6d                   	insl   (%dx),%es:(%edi)
f0107958:	65 3a 00             	cmp    %gs:(%eax),%al
f010795b:	6d                   	insl   (%dx),%es:(%edi)
f010795c:	6f                   	outsl  %ds:(%esi),(%dx)
f010795d:	6e                   	outsb  %ds:(%esi),(%dx)
f010795e:	5f                   	pop    %edi
f010795f:	68 65 6c 70 3a       	push   $0x3a706c65
f0107964:	46                   	inc    %esi
f0107965:	28 30                	sub    %dh,(%eax)
f0107967:	2c 31                	sub    $0x31,%al
f0107969:	29 00                	sub    %eax,(%eax)
f010796b:	61                   	popa   
f010796c:	72 67                	jb     f01079d5 <__STABSTR_BEGIN__+0x11e4>
f010796e:	76 3a                	jbe    f01079aa <__STABSTR_BEGIN__+0x11b9>
f0107970:	70 28                	jo     f010799a <__STABSTR_BEGIN__+0x11a9>
f0107972:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107975:	35 29 00 74 66       	xor    $0x66740029,%eax
f010797a:	3a 70 28             	cmp    0x28(%eax),%dh
f010797d:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107980:	36 29 00             	sub    %eax,%ss:(%eax)
f0107983:	6d                   	insl   (%dx),%es:(%edi)
f0107984:	6f                   	outsl  %ds:(%esi),(%dx)
f0107985:	6e                   	outsb  %ds:(%esi),(%dx)
f0107986:	69 74 6f 72 3a 46 28 	imul   $0x3028463a,0x72(%edi,%ebp,2),%esi
f010798d:	30 
f010798e:	2c 31                	sub    $0x31,%al
f0107990:	38 29                	cmp    %ch,(%ecx)
f0107992:	00 62 75             	add    %ah,0x75(%edx)
f0107995:	66                   	data16
f0107996:	3a 72 28             	cmp    0x28(%edx),%dh
f0107999:	32 2c 32             	xor    (%edx,%esi,1),%ch
f010799c:	29 00                	sub    %eax,(%eax)
f010799e:	61                   	popa   
f010799f:	72 67                	jb     f0107a08 <__STABSTR_BEGIN__+0x1217>
f01079a1:	63 3a                	arpl   %di,(%edx)
f01079a3:	72 28                	jb     f01079cd <__STABSTR_BEGIN__+0x11dc>
f01079a5:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01079a8:	29 00                	sub    %eax,(%eax)
f01079aa:	61                   	popa   
f01079ab:	72 67                	jb     f0107a14 <__STABSTR_BEGIN__+0x1223>
f01079ad:	76 3a                	jbe    f01079e9 <__STABSTR_BEGIN__+0x11f8>
f01079af:	28 30                	sub    %dh,(%eax)
f01079b1:	2c 32                	sub    $0x32,%al
f01079b3:	38 29                	cmp    %ch,(%ecx)
f01079b5:	3d 61 72 28 30       	cmp    $0x30287261,%eax
f01079ba:	2c 32                	sub    $0x32,%al
f01079bc:	33 29                	xor    (%ecx),%ebp
f01079be:	3b 30                	cmp    (%eax),%esi
f01079c0:	3b 31                	cmp    (%ecx),%esi
f01079c2:	35 3b 28 32 2c       	xor    $0x2c32283b,%eax
f01079c7:	32 29                	xor    (%ecx),%ch
f01079c9:	00 61 72             	add    %ah,0x72(%ecx)
f01079cc:	67 76 3a             	addr16 jbe f0107a09 <__STABSTR_BEGIN__+0x1218>
f01079cf:	28 30                	sub    %dh,(%eax)
f01079d1:	2c 32                	sub    $0x32,%al
f01079d3:	38 29                	cmp    %ch,(%ecx)
f01079d5:	00 6d 6f             	add    %ch,0x6f(%ebp)
f01079d8:	6e                   	outsb  %ds:(%esi),(%dx)
f01079d9:	5f                   	pop    %edi
f01079da:	62 61 63             	bound  %esp,0x63(%ecx)
f01079dd:	6b 74 72 61 63       	imul   $0x63,0x61(%edx,%esi,2),%esi
f01079e2:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
f01079e6:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01079e9:	29 00                	sub    %eax,(%eax)
f01079eb:	64 65 62 75 67       	bound  %esi,%fs:%gs:0x67(%ebp)
f01079f0:	69 6e 66 6f 3a 28 37 	imul   $0x37283a6f,0x66(%esi),%ebp
f01079f7:	2c 31                	sub    $0x31,%al
f01079f9:	29 00                	sub    %eax,(%eax)
f01079fb:	70 65                	jo     f0107a62 <__STABSTR_BEGIN__+0x1271>
f01079fd:	62 70 3a             	bound  %esi,0x3a(%eax)
f0107a00:	72 28                	jb     f0107a2a <__STABSTR_BEGIN__+0x1239>
f0107a02:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107a05:	39 29                	cmp    %ebp,(%ecx)
f0107a07:	3d 2a 28 34 2c       	cmp    $0x2c34282a,%eax
f0107a0c:	37                   	aaa    
f0107a0d:	29 00                	sub    %eax,(%eax)
f0107a0f:	63 6f 6d             	arpl   %bp,0x6d(%edi)
f0107a12:	6d                   	insl   (%dx),%es:(%edi)
f0107a13:	61                   	popa   
f0107a14:	6e                   	outsb  %ds:(%esi),(%dx)
f0107a15:	64                   	fs
f0107a16:	73 3a                	jae    f0107a52 <__STABSTR_BEGIN__+0x1261>
f0107a18:	53                   	push   %ebx
f0107a19:	28 30                	sub    %dh,(%eax)
f0107a1b:	2c 33                	sub    $0x33,%al
f0107a1d:	30 29                	xor    %ch,(%ecx)
f0107a1f:	3d 61 72 28 30       	cmp    $0x30287261,%eax
f0107a24:	2c 32                	sub    $0x32,%al
f0107a26:	33 29                	xor    (%ecx),%ebp
f0107a28:	3b 30                	cmp    (%eax),%esi
f0107a2a:	3b 31                	cmp    (%ecx),%esi
f0107a2c:	3b 28                	cmp    (%eax),%ebp
f0107a2e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107a31:	39 29                	cmp    %ebp,(%ecx)
f0107a33:	00 6b 65             	add    %ch,0x65(%ebx)
f0107a36:	72 6e                	jb     f0107aa6 <__STABSTR_BEGIN__+0x12b5>
f0107a38:	2f                   	das    
f0107a39:	70 72                	jo     f0107aad <__STABSTR_BEGIN__+0x12bc>
f0107a3b:	69 6e 74 66 2e 63 00 	imul   $0x632e66,0x74(%esi),%ebp
f0107a42:	76 63                	jbe    f0107aa7 <__STABSTR_BEGIN__+0x12b6>
f0107a44:	70 72                	jo     f0107ab8 <__STABSTR_BEGIN__+0x12c7>
f0107a46:	69 6e 74 66 3a 46 28 	imul   $0x28463a66,0x74(%esi),%ebp
f0107a4d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107a50:	29 00                	sub    %eax,(%eax)
f0107a52:	66 6d                	insw   (%dx),%es:(%edi)
f0107a54:	74 3a                	je     f0107a90 <__STABSTR_BEGIN__+0x129f>
f0107a56:	70 28                	jo     f0107a80 <__STABSTR_BEGIN__+0x128f>
f0107a58:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107a5b:	39 29                	cmp    %ebp,(%ecx)
f0107a5d:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f0107a62:	32 29                	xor    (%ecx),%ch
f0107a64:	00 61 70             	add    %ah,0x70(%ecx)
f0107a67:	3a 70 28             	cmp    0x28(%eax),%dh
f0107a6a:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
f0107a6d:	29 00                	sub    %eax,(%eax)
f0107a6f:	63 6e 74             	arpl   %bp,0x74(%esi)
f0107a72:	3a 28                	cmp    (%eax),%ch
f0107a74:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107a77:	29 00                	sub    %eax,(%eax)
f0107a79:	61                   	popa   
f0107a7a:	70 3a                	jo     f0107ab6 <__STABSTR_BEGIN__+0x12c5>
f0107a7c:	72 28                	jb     f0107aa6 <__STABSTR_BEGIN__+0x12b5>
f0107a7e:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
f0107a81:	29 00                	sub    %eax,(%eax)
f0107a83:	63 70 72             	arpl   %si,0x72(%eax)
f0107a86:	69 6e 74 66 3a 46 28 	imul   $0x28463a66,0x74(%esi),%ebp
f0107a8d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107a90:	29 00                	sub    %eax,(%eax)
f0107a92:	63 6e 74             	arpl   %bp,0x74(%esi)
f0107a95:	3a 72 28             	cmp    0x28(%edx),%dh
f0107a98:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107a9b:	29 00                	sub    %eax,(%eax)
f0107a9d:	70 75                	jo     f0107b14 <__STABSTR_BEGIN__+0x1323>
f0107a9f:	74 63                	je     f0107b04 <__STABSTR_BEGIN__+0x1313>
f0107aa1:	68 3a 66 28 30       	push   $0x3028663a
f0107aa6:	2c 31                	sub    $0x31,%al
f0107aa8:	38 29                	cmp    %ch,(%ecx)
f0107aaa:	00 63 68             	add    %ah,0x68(%ebx)
f0107aad:	3a 70 28             	cmp    0x28(%eax),%dh
f0107ab0:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107ab3:	29 00                	sub    %eax,(%eax)
f0107ab5:	63 6e 74             	arpl   %bp,0x74(%esi)
f0107ab8:	3a 70 28             	cmp    0x28(%eax),%dh
f0107abb:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107abe:	30 29                	xor    %ch,(%ecx)
f0107ac0:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f0107ac5:	31 29                	xor    %ebp,(%ecx)
f0107ac7:	00 63 68             	add    %ah,0x68(%ebx)
f0107aca:	3a 72 28             	cmp    0x28(%edx),%dh
f0107acd:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107ad0:	29 00                	sub    %eax,(%eax)
f0107ad2:	63 6e 74             	arpl   %bp,0x74(%esi)
f0107ad5:	3a 72 28             	cmp    0x28(%edx),%dh
f0107ad8:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107adb:	30 29                	xor    %ch,(%ecx)
f0107add:	00 6b 65             	add    %ch,0x65(%ebx)
f0107ae0:	72 6e                	jb     f0107b50 <__STABSTR_BEGIN__+0x135f>
f0107ae2:	2f                   	das    
f0107ae3:	6b 64 65 62 75       	imul   $0x75,0x62(%ebp,%eiz,2),%esp
f0107ae8:	67 2e 63 00          	addr16 arpl %ax,%cs:(%bx,%si)
f0107aec:	2e                   	cs
f0107aed:	2f                   	das    
f0107aee:	69 6e 63 2f 73 74 61 	imul   $0x6174732f,0x63(%esi),%ebp
f0107af5:	62 2e                	bound  %ebp,(%esi)
f0107af7:	68 00 53 74 61       	push   $0x61745300
f0107afc:	62 3a                	bound  %edi,(%edx)
f0107afe:	54                   	push   %esp
f0107aff:	28 31                	sub    %dh,(%ecx)
f0107b01:	2c 31                	sub    $0x31,%al
f0107b03:	29 3d 73 31 32 6e    	sub    %edi,0x6e323173
f0107b09:	5f                   	pop    %edi
f0107b0a:	73 74                	jae    f0107b80 <__STABSTR_BEGIN__+0x138f>
f0107b0c:	72 78                	jb     f0107b86 <__STABSTR_BEGIN__+0x1395>
f0107b0e:	3a 28                	cmp    (%eax),%ch
f0107b10:	32 2c 37             	xor    (%edi,%esi,1),%ch
f0107b13:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
f0107b16:	2c 33                	sub    $0x33,%al
f0107b18:	32 3b                	xor    (%ebx),%bh
f0107b1a:	6e                   	outsb  %ds:(%esi),(%dx)
f0107b1b:	5f                   	pop    %edi
f0107b1c:	74 79                	je     f0107b97 <__STABSTR_BEGIN__+0x13a6>
f0107b1e:	70 65                	jo     f0107b85 <__STABSTR_BEGIN__+0x1394>
f0107b20:	3a 28                	cmp    (%eax),%ch
f0107b22:	32 2c 33             	xor    (%ebx,%esi,1),%ch
f0107b25:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
f0107b28:	32 2c 38             	xor    (%eax,%edi,1),%ch
f0107b2b:	3b 6e 5f             	cmp    0x5f(%esi),%ebp
f0107b2e:	6f                   	outsl  %ds:(%esi),(%dx)
f0107b2f:	74 68                	je     f0107b99 <__STABSTR_BEGIN__+0x13a8>
f0107b31:	65                   	gs
f0107b32:	72 3a                	jb     f0107b6e <__STABSTR_BEGIN__+0x137d>
f0107b34:	28 32                	sub    %dh,(%edx)
f0107b36:	2c 33                	sub    $0x33,%al
f0107b38:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
f0107b3b:	30 2c 38             	xor    %ch,(%eax,%edi,1)
f0107b3e:	3b 6e 5f             	cmp    0x5f(%esi),%ebp
f0107b41:	64                   	fs
f0107b42:	65                   	gs
f0107b43:	73 63                	jae    f0107ba8 <__STABSTR_BEGIN__+0x13b7>
f0107b45:	3a 28                	cmp    (%eax),%ch
f0107b47:	32 2c 35 29 2c 34 38 	xor    0x38342c29(,%esi,1),%ch
f0107b4e:	2c 31                	sub    $0x31,%al
f0107b50:	36 3b 6e 5f          	cmp    %ss:0x5f(%esi),%ebp
f0107b54:	76 61                	jbe    f0107bb7 <__STABSTR_BEGIN__+0x13c6>
f0107b56:	6c                   	insb   (%dx),%es:(%edi)
f0107b57:	75 65                	jne    f0107bbe <__STABSTR_BEGIN__+0x13cd>
f0107b59:	3a 28                	cmp    (%eax),%ch
f0107b5b:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f0107b5e:	31 29                	xor    %ebp,(%ecx)
f0107b60:	2c 36                	sub    $0x36,%al
f0107b62:	34 2c                	xor    $0x2c,%al
f0107b64:	33 32                	xor    (%edx),%esi
f0107b66:	3b 3b                	cmp    (%ebx),%edi
f0107b68:	00 73 74             	add    %dh,0x74(%ebx)
f0107b6b:	61                   	popa   
f0107b6c:	62 5f 62             	bound  %ebx,0x62(%edi)
f0107b6f:	69 6e 73 65 61 72 63 	imul   $0x63726165,0x73(%esi),%ebp
f0107b76:	68 3a 66 28 30       	push   $0x3028663a
f0107b7b:	2c 31                	sub    $0x31,%al
f0107b7d:	38 29                	cmp    %ch,(%ecx)
f0107b7f:	00 73 74             	add    %dh,0x74(%ebx)
f0107b82:	61                   	popa   
f0107b83:	62 73 3a             	bound  %esi,0x3a(%ebx)
f0107b86:	70 28                	jo     f0107bb0 <__STABSTR_BEGIN__+0x13bf>
f0107b88:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107b8b:	39 29                	cmp    %ebp,(%ecx)
f0107b8d:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
f0107b92:	31 29                	xor    %ebp,(%ecx)
f0107b94:	00 72 65             	add    %dh,0x65(%edx)
f0107b97:	67 69 6f 6e 5f 6c 65 	addr16 imul $0x66656c5f,0x6e(%bx),%ebp
f0107b9e:	66 
f0107b9f:	74 3a                	je     f0107bdb <__STABSTR_BEGIN__+0x13ea>
f0107ba1:	70 28                	jo     f0107bcb <__STABSTR_BEGIN__+0x13da>
f0107ba3:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107ba6:	30 29                	xor    %ch,(%ecx)
f0107ba8:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f0107bad:	31 29                	xor    %ebp,(%ecx)
f0107baf:	00 72 65             	add    %dh,0x65(%edx)
f0107bb2:	67 69 6f 6e 5f 72 69 	addr16 imul $0x6769725f,0x6e(%bx),%ebp
f0107bb9:	67 
f0107bba:	68 74 3a 70 28       	push   $0x28703a74
f0107bbf:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107bc2:	30 29                	xor    %ch,(%ecx)
f0107bc4:	00 74 79 70          	add    %dh,0x70(%ecx,%edi,2)
f0107bc8:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
f0107bcc:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107bcf:	29 00                	sub    %eax,(%eax)
f0107bd1:	61                   	popa   
f0107bd2:	64                   	fs
f0107bd3:	64                   	fs
f0107bd4:	72 3a                	jb     f0107c10 <__STABSTR_BEGIN__+0x141f>
f0107bd6:	70 28                	jo     f0107c00 <__STABSTR_BEGIN__+0x140f>
f0107bd8:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f0107bdb:	31 29                	xor    %ebp,(%ecx)
f0107bdd:	00 6c 3a 72          	add    %ch,0x72(%edx,%edi,1)
f0107be1:	28 30                	sub    %dh,(%eax)
f0107be3:	2c 31                	sub    $0x31,%al
f0107be5:	29 00                	sub    %eax,(%eax)
f0107be7:	72 3a                	jb     f0107c23 <__STABSTR_BEGIN__+0x1432>
f0107be9:	28 30                	sub    %dh,(%eax)
f0107beb:	2c 31                	sub    $0x31,%al
f0107bed:	29 00                	sub    %eax,(%eax)
f0107bef:	61                   	popa   
f0107bf0:	6e                   	outsb  %ds:(%esi),(%dx)
f0107bf1:	79 5f                	jns    f0107c52 <__STABSTR_BEGIN__+0x1461>
f0107bf3:	6d                   	insl   (%dx),%es:(%edi)
f0107bf4:	61                   	popa   
f0107bf5:	74 63                	je     f0107c5a <__STABSTR_BEGIN__+0x1469>
f0107bf7:	68 65 73 3a 28       	push   $0x283a7365
f0107bfc:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107bff:	29 00                	sub    %eax,(%eax)
f0107c01:	74 79                	je     f0107c7c <__STABSTR_BEGIN__+0x148b>
f0107c03:	70 65                	jo     f0107c6a <__STABSTR_BEGIN__+0x1479>
f0107c05:	3a 72 28             	cmp    0x28(%edx),%dh
f0107c08:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107c0b:	29 00                	sub    %eax,(%eax)
f0107c0d:	74 72                	je     f0107c81 <__STABSTR_BEGIN__+0x1490>
f0107c0f:	75 65                	jne    f0107c76 <__STABSTR_BEGIN__+0x1485>
f0107c11:	5f                   	pop    %edi
f0107c12:	6d                   	insl   (%dx),%es:(%edi)
f0107c13:	3a 72 28             	cmp    0x28(%edx),%dh
f0107c16:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107c19:	29 00                	sub    %eax,(%eax)
f0107c1b:	6d                   	insl   (%dx),%es:(%edi)
f0107c1c:	3a 72 28             	cmp    0x28(%edx),%dh
f0107c1f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107c22:	29 00                	sub    %eax,(%eax)
f0107c24:	64 65 62 75 67       	bound  %esi,%fs:%gs:0x67(%ebp)
f0107c29:	69 6e 66 6f 5f 65 69 	imul   $0x69655f6f,0x66(%esi),%ebp
f0107c30:	70 3a                	jo     f0107c6c <__STABSTR_BEGIN__+0x147b>
f0107c32:	46                   	inc    %esi
f0107c33:	28 30                	sub    %dh,(%eax)
f0107c35:	2c 31                	sub    $0x31,%al
f0107c37:	29 00                	sub    %eax,(%eax)
f0107c39:	69 6e 66 6f 3a 70 28 	imul   $0x28703a6f,0x66(%esi),%ebp
f0107c40:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107c43:	31 29                	xor    %ebp,(%ecx)
f0107c45:	3d 2a 28 38 2c       	cmp    $0x2c38282a,%eax
f0107c4a:	31 29                	xor    %ebp,(%ecx)
f0107c4c:	00 6c 66 69          	add    %ch,0x69(%esi,%eiz,2)
f0107c50:	6c                   	insb   (%dx),%es:(%edi)
f0107c51:	65 3a 28             	cmp    %gs:(%eax),%ch
f0107c54:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107c57:	29 00                	sub    %eax,(%eax)
f0107c59:	72 66                	jb     f0107cc1 <__STABSTR_BEGIN__+0x14d0>
f0107c5b:	69 6c 65 3a 28 30 2c 	imul   $0x312c3028,0x3a(%ebp,%eiz,2),%ebp
f0107c62:	31 
f0107c63:	29 00                	sub    %eax,(%eax)
f0107c65:	6c                   	insb   (%dx),%es:(%edi)
f0107c66:	66                   	data16
f0107c67:	75 6e                	jne    f0107cd7 <__STABSTR_BEGIN__+0x14e6>
f0107c69:	3a 28                	cmp    (%eax),%ch
f0107c6b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107c6e:	29 00                	sub    %eax,(%eax)
f0107c70:	72 66                	jb     f0107cd8 <__STABSTR_BEGIN__+0x14e7>
f0107c72:	75 6e                	jne    f0107ce2 <__STABSTR_BEGIN__+0x14f1>
f0107c74:	3a 28                	cmp    (%eax),%ch
f0107c76:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107c79:	29 00                	sub    %eax,(%eax)
f0107c7b:	6c                   	insb   (%dx),%es:(%edi)
f0107c7c:	6c                   	insb   (%dx),%es:(%edi)
f0107c7d:	69 6e 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%esi),%ebp
f0107c84:	31 29                	xor    %ebp,(%ecx)
f0107c86:	00 72 6c             	add    %dh,0x6c(%edx)
f0107c89:	69 6e 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%esi),%ebp
f0107c90:	31 29                	xor    %ebp,(%ecx)
f0107c92:	00 61 64             	add    %ah,0x64(%ecx)
f0107c95:	64                   	fs
f0107c96:	72 3a                	jb     f0107cd2 <__STABSTR_BEGIN__+0x14e1>
f0107c98:	72 28                	jb     f0107cc2 <__STABSTR_BEGIN__+0x14d1>
f0107c9a:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f0107c9d:	31 29                	xor    %ebp,(%ecx)
f0107c9f:	00 69 6e             	add    %ch,0x6e(%ecx)
f0107ca2:	66 6f                	outsw  %ds:(%esi),(%dx)
f0107ca4:	3a 72 28             	cmp    0x28(%edx),%dh
f0107ca7:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107caa:	31 29                	xor    %ebp,(%ecx)
f0107cac:	00 6c 69 62          	add    %ch,0x62(%ecx,%ebp,2)
f0107cb0:	2f                   	das    
f0107cb1:	70 72                	jo     f0107d25 <__STABSTR_BEGIN__+0x1534>
f0107cb3:	69 6e 74 66 6d 74 2e 	imul   $0x2e746d66,0x74(%esi),%ebp
f0107cba:	63 00                	arpl   %ax,(%eax)
f0107cbc:	2e                   	cs
f0107cbd:	2f                   	das    
f0107cbe:	69 6e 63 2f 65 72 72 	imul   $0x7272652f,0x63(%esi),%ebp
f0107cc5:	6f                   	outsl  %ds:(%esi),(%dx)
f0107cc6:	72 2e                	jb     f0107cf6 <__STABSTR_BEGIN__+0x1505>
f0107cc8:	68 00 20 3a 54       	push   $0x543a2000
f0107ccd:	28 34 2c             	sub    %dh,(%esp,%ebp,1)
f0107cd0:	31 29                	xor    %ebp,(%ecx)
f0107cd2:	3d 65 45 5f 55       	cmp    $0x555f4565,%eax
f0107cd7:	4e                   	dec    %esi
f0107cd8:	53                   	push   %ebx
f0107cd9:	50                   	push   %eax
f0107cda:	45                   	inc    %ebp
f0107cdb:	43                   	inc    %ebx
f0107cdc:	49                   	dec    %ecx
f0107cdd:	46                   	inc    %esi
f0107cde:	49                   	dec    %ecx
f0107cdf:	45                   	inc    %ebp
f0107ce0:	44                   	inc    %esp
f0107ce1:	3a 31                	cmp    (%ecx),%dh
f0107ce3:	2c 45                	sub    $0x45,%al
f0107ce5:	5f                   	pop    %edi
f0107ce6:	42                   	inc    %edx
f0107ce7:	41                   	inc    %ecx
f0107ce8:	44                   	inc    %esp
f0107ce9:	5f                   	pop    %edi
f0107cea:	45                   	inc    %ebp
f0107ceb:	4e                   	dec    %esi
f0107cec:	56                   	push   %esi
f0107ced:	3a 32                	cmp    (%edx),%dh
f0107cef:	2c 45                	sub    $0x45,%al
f0107cf1:	5f                   	pop    %edi
f0107cf2:	49                   	dec    %ecx
f0107cf3:	4e                   	dec    %esi
f0107cf4:	56                   	push   %esi
f0107cf5:	41                   	inc    %ecx
f0107cf6:	4c                   	dec    %esp
f0107cf7:	3a 33                	cmp    (%ebx),%dh
f0107cf9:	2c 45                	sub    $0x45,%al
f0107cfb:	5f                   	pop    %edi
f0107cfc:	4e                   	dec    %esi
f0107cfd:	4f                   	dec    %edi
f0107cfe:	5f                   	pop    %edi
f0107cff:	4d                   	dec    %ebp
f0107d00:	45                   	inc    %ebp
f0107d01:	4d                   	dec    %ebp
f0107d02:	3a 34 2c             	cmp    (%esp,%ebp,1),%dh
f0107d05:	45                   	inc    %ebp
f0107d06:	5f                   	pop    %edi
f0107d07:	4e                   	dec    %esi
f0107d08:	4f                   	dec    %edi
f0107d09:	5f                   	pop    %edi
f0107d0a:	46                   	inc    %esi
f0107d0b:	52                   	push   %edx
f0107d0c:	45                   	inc    %ebp
f0107d0d:	45                   	inc    %ebp
f0107d0e:	5f                   	pop    %edi
f0107d0f:	45                   	inc    %ebp
f0107d10:	4e                   	dec    %esi
f0107d11:	56                   	push   %esi
f0107d12:	3a 35 2c 45 5f 46    	cmp    0x465f452c,%dh
f0107d18:	41                   	inc    %ecx
f0107d19:	55                   	push   %ebp
f0107d1a:	4c                   	dec    %esp
f0107d1b:	54                   	push   %esp
f0107d1c:	3a 36                	cmp    (%esi),%dh
f0107d1e:	2c 4d                	sub    $0x4d,%al
f0107d20:	41                   	inc    %ecx
f0107d21:	58                   	pop    %eax
f0107d22:	45                   	inc    %ebp
f0107d23:	52                   	push   %edx
f0107d24:	52                   	push   %edx
f0107d25:	4f                   	dec    %edi
f0107d26:	52                   	push   %edx
f0107d27:	3a 37                	cmp    (%edi),%dh
f0107d29:	2c 3b                	sub    $0x3b,%al
f0107d2b:	00 73 70             	add    %dh,0x70(%ebx)
f0107d2e:	72 69                	jb     f0107d99 <__STABSTR_BEGIN__+0x15a8>
f0107d30:	6e                   	outsb  %ds:(%esi),(%dx)
f0107d31:	74 62                	je     f0107d95 <__STABSTR_BEGIN__+0x15a4>
f0107d33:	75 66                	jne    f0107d9b <__STABSTR_BEGIN__+0x15aa>
f0107d35:	3a 54 28 30          	cmp    0x30(%eax,%ebp,1),%dl
f0107d39:	2c 31                	sub    $0x31,%al
f0107d3b:	39 29                	cmp    %ebp,(%ecx)
f0107d3d:	3d 73 31 32 62       	cmp    $0x62323173,%eax
f0107d42:	75 66                	jne    f0107daa <__STABSTR_BEGIN__+0x15b9>
f0107d44:	3a 28                	cmp    (%eax),%ch
f0107d46:	33 2c 32             	xor    (%edx,%esi,1),%ebp
f0107d49:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
f0107d4c:	2c 33                	sub    $0x33,%al
f0107d4e:	32 3b                	xor    (%ebx),%bh
f0107d50:	65 62 75 66          	bound  %esi,%gs:0x66(%ebp)
f0107d54:	3a 28                	cmp    (%eax),%ch
f0107d56:	33 2c 32             	xor    (%edx,%esi,1),%ebp
f0107d59:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
f0107d5c:	32 2c 33             	xor    (%ebx,%esi,1),%ch
f0107d5f:	32 3b                	xor    (%ebx),%bh
f0107d61:	63 6e 74             	arpl   %bp,0x74(%esi)
f0107d64:	3a 28                	cmp    (%eax),%ch
f0107d66:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107d69:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
f0107d6c:	34 2c                	xor    $0x2c,%al
f0107d6e:	33 32                	xor    (%edx),%esi
f0107d70:	3b 3b                	cmp    (%ebx),%edi
f0107d72:	00 70 72             	add    %dh,0x72(%eax)
f0107d75:	69 6e 74 6e 75 6d 5f 	imul   $0x5f6d756e,0x74(%esi),%ebp
f0107d7c:	77 69                	ja     f0107de7 <__STABSTR_BEGIN__+0x15f6>
f0107d7e:	64                   	fs
f0107d7f:	74 68                	je     f0107de9 <__STABSTR_BEGIN__+0x15f8>
f0107d81:	3a 66 28             	cmp    0x28(%esi),%ah
f0107d84:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107d87:	38 29                	cmp    %ch,(%ecx)
f0107d89:	00 70 75             	add    %dh,0x75(%eax)
f0107d8c:	74 63                	je     f0107df1 <__STABSTR_BEGIN__+0x1600>
f0107d8e:	68 3a 70 28 30       	push   $0x3028703a
f0107d93:	2c 32                	sub    $0x32,%al
f0107d95:	30 29                	xor    %ch,(%ecx)
f0107d97:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f0107d9c:	32 31                	xor    (%ecx),%dh
f0107d9e:	29 3d 66 28 30 2c    	sub    %edi,0x2c302866
f0107da4:	31 38                	xor    %edi,(%eax)
f0107da6:	29 00                	sub    %eax,(%eax)
f0107da8:	70 75                	jo     f0107e1f <__STABSTR_BEGIN__+0x162e>
f0107daa:	74 64                	je     f0107e10 <__STABSTR_BEGIN__+0x161f>
f0107dac:	61                   	popa   
f0107dad:	74 3a                	je     f0107de9 <__STABSTR_BEGIN__+0x15f8>
f0107daf:	50                   	push   %eax
f0107db0:	28 30                	sub    %dh,(%eax)
f0107db2:	2c 32                	sub    $0x32,%al
f0107db4:	32 29                	xor    (%ecx),%ch
f0107db6:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f0107dbb:	31 38                	xor    %edi,(%eax)
f0107dbd:	29 00                	sub    %eax,(%eax)
f0107dbf:	6e                   	outsb  %ds:(%esi),(%dx)
f0107dc0:	75 6d                	jne    f0107e2f <__STABSTR_BEGIN__+0x163e>
f0107dc2:	3a 70 28             	cmp    0x28(%eax),%dh
f0107dc5:	30 2c 37             	xor    %ch,(%edi,%esi,1)
f0107dc8:	29 00                	sub    %eax,(%eax)
f0107dca:	62 61 73             	bound  %esp,0x73(%ecx)
f0107dcd:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
f0107dd1:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0107dd4:	29 00                	sub    %eax,(%eax)
f0107dd6:	77 69                	ja     f0107e41 <__STABSTR_BEGIN__+0x1650>
f0107dd8:	64                   	fs
f0107dd9:	74 68                	je     f0107e43 <__STABSTR_BEGIN__+0x1652>
f0107ddb:	3a 70 28             	cmp    0x28(%eax),%dh
f0107dde:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107de1:	29 00                	sub    %eax,(%eax)
f0107de3:	70 61                	jo     f0107e46 <__STABSTR_BEGIN__+0x1655>
f0107de5:	64 63 3a             	arpl   %di,%fs:(%edx)
f0107de8:	70 28                	jo     f0107e12 <__STABSTR_BEGIN__+0x1621>
f0107dea:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107ded:	29 00                	sub    %eax,(%eax)
f0107def:	70 61                	jo     f0107e52 <__STABSTR_BEGIN__+0x1661>
f0107df1:	6d                   	insl   (%dx),%es:(%edi)
f0107df2:	6e                   	outsb  %ds:(%esi),(%dx)
f0107df3:	74 3a                	je     f0107e2f <__STABSTR_BEGIN__+0x163e>
f0107df5:	70 28                	jo     f0107e1f <__STABSTR_BEGIN__+0x162e>
f0107df7:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107dfa:	33 29                	xor    (%ecx),%ebp
f0107dfc:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f0107e01:	31 29                	xor    %ebp,(%ecx)
f0107e03:	00 70 63             	add    %dh,0x63(%eax)
f0107e06:	6f                   	outsl  %ds:(%esi),(%dx)
f0107e07:	75 6e                	jne    f0107e77 <__STABSTR_BEGIN__+0x1686>
f0107e09:	74 3a                	je     f0107e45 <__STABSTR_BEGIN__+0x1654>
f0107e0b:	70 28                	jo     f0107e35 <__STABSTR_BEGIN__+0x1644>
f0107e0d:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107e10:	33 29                	xor    (%ecx),%ebp
f0107e12:	00 62 61             	add    %ah,0x61(%edx)
f0107e15:	73 65                	jae    f0107e7c <__STABSTR_BEGIN__+0x168b>
f0107e17:	3a 72 28             	cmp    0x28(%edx),%dh
f0107e1a:	30 2c 34             	xor    %ch,(%esp,%esi,1)
f0107e1d:	29 00                	sub    %eax,(%eax)
f0107e1f:	70 72                	jo     f0107e93 <__STABSTR_BEGIN__+0x16a2>
f0107e21:	69 6e 74 6e 75 6d 3a 	imul   $0x3a6d756e,0x74(%esi),%ebp
f0107e28:	66                   	data16
f0107e29:	28 30                	sub    %dh,(%eax)
f0107e2b:	2c 31                	sub    $0x31,%al
f0107e2d:	38 29                	cmp    %ch,(%ecx)
f0107e2f:	00 70 75             	add    %dh,0x75(%eax)
f0107e32:	74 63                	je     f0107e97 <__STABSTR_BEGIN__+0x16a6>
f0107e34:	68 3a 70 28 30       	push   $0x3028703a
f0107e39:	2c 32                	sub    $0x32,%al
f0107e3b:	30 29                	xor    %ch,(%ecx)
f0107e3d:	00 70 75             	add    %dh,0x75(%eax)
f0107e40:	74 64                	je     f0107ea6 <__STABSTR_BEGIN__+0x16b5>
f0107e42:	61                   	popa   
f0107e43:	74 3a                	je     f0107e7f <__STABSTR_BEGIN__+0x168e>
f0107e45:	50                   	push   %eax
f0107e46:	28 30                	sub    %dh,(%eax)
f0107e48:	2c 32                	sub    $0x32,%al
f0107e4a:	32 29                	xor    (%ecx),%ch
f0107e4c:	00 61 6d             	add    %ah,0x6d(%ecx)
f0107e4f:	6e                   	outsb  %ds:(%esi),(%dx)
f0107e50:	74 3a                	je     f0107e8c <__STABSTR_BEGIN__+0x169b>
f0107e52:	28 30                	sub    %dh,(%eax)
f0107e54:	2c 31                	sub    $0x31,%al
f0107e56:	29 00                	sub    %eax,(%eax)
f0107e58:	63 6f 75             	arpl   %bp,0x75(%edi)
f0107e5b:	6e                   	outsb  %ds:(%esi),(%dx)
f0107e5c:	74 3a                	je     f0107e98 <__STABSTR_BEGIN__+0x16a7>
f0107e5e:	28 30                	sub    %dh,(%eax)
f0107e60:	2c 31                	sub    $0x31,%al
f0107e62:	29 00                	sub    %eax,(%eax)
f0107e64:	77 69                	ja     f0107ecf <__STABSTR_BEGIN__+0x16de>
f0107e66:	64                   	fs
f0107e67:	74 68                	je     f0107ed1 <__STABSTR_BEGIN__+0x16e0>
f0107e69:	3a 72 28             	cmp    0x28(%edx),%dh
f0107e6c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107e6f:	29 00                	sub    %eax,(%eax)
f0107e71:	70 61                	jo     f0107ed4 <__STABSTR_BEGIN__+0x16e3>
f0107e73:	64 63 3a             	arpl   %di,%fs:(%edx)
f0107e76:	72 28                	jb     f0107ea0 <__STABSTR_BEGIN__+0x16af>
f0107e78:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107e7b:	29 00                	sub    %eax,(%eax)
f0107e7d:	67                   	addr16
f0107e7e:	65                   	gs
f0107e7f:	74 75                	je     f0107ef6 <__STABSTR_BEGIN__+0x1705>
f0107e81:	69 6e 74 3a 66 28 30 	imul   $0x3028663a,0x74(%esi),%ebp
f0107e88:	2c 37                	sub    $0x37,%al
f0107e8a:	29 00                	sub    %eax,(%eax)
f0107e8c:	61                   	popa   
f0107e8d:	70 3a                	jo     f0107ec9 <__STABSTR_BEGIN__+0x16d8>
f0107e8f:	50                   	push   %eax
f0107e90:	28 30                	sub    %dh,(%eax)
f0107e92:	2c 32                	sub    $0x32,%al
f0107e94:	34 29                	xor    $0x29,%al
f0107e96:	3d 2a 28 33 2c       	cmp    $0x2c33282a,%eax
f0107e9b:	31 29                	xor    %ebp,(%ecx)
f0107e9d:	00 6c 66 6c          	add    %ch,0x6c(%esi,%eiz,2)
f0107ea1:	61                   	popa   
f0107ea2:	67 3a 50 28          	addr16 cmp 0x28(%bx,%si),%dl
f0107ea6:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107ea9:	29 00                	sub    %eax,(%eax)
f0107eab:	67                   	addr16
f0107eac:	65                   	gs
f0107ead:	74 69                	je     f0107f18 <__STABSTR_BEGIN__+0x1727>
f0107eaf:	6e                   	outsb  %ds:(%esi),(%dx)
f0107eb0:	74 3a                	je     f0107eec <__STABSTR_BEGIN__+0x16fb>
f0107eb2:	66                   	data16
f0107eb3:	28 30                	sub    %dh,(%eax)
f0107eb5:	2c 36                	sub    $0x36,%al
f0107eb7:	29 00                	sub    %eax,(%eax)
f0107eb9:	61                   	popa   
f0107eba:	70 3a                	jo     f0107ef6 <__STABSTR_BEGIN__+0x1705>
f0107ebc:	50                   	push   %eax
f0107ebd:	28 30                	sub    %dh,(%eax)
f0107ebf:	2c 32                	sub    $0x32,%al
f0107ec1:	34 29                	xor    $0x29,%al
f0107ec3:	00 73 70             	add    %dh,0x70(%ebx)
f0107ec6:	72 69                	jb     f0107f31 <__STABSTR_BEGIN__+0x1740>
f0107ec8:	6e                   	outsb  %ds:(%esi),(%dx)
f0107ec9:	74 70                	je     f0107f3b <__STABSTR_BEGIN__+0x174a>
f0107ecb:	75 74                	jne    f0107f41 <__STABSTR_BEGIN__+0x1750>
f0107ecd:	63 68 3a             	arpl   %bp,0x3a(%eax)
f0107ed0:	66                   	data16
f0107ed1:	28 30                	sub    %dh,(%eax)
f0107ed3:	2c 31                	sub    $0x31,%al
f0107ed5:	38 29                	cmp    %ch,(%ecx)
f0107ed7:	00 62 3a             	add    %ah,0x3a(%edx)
f0107eda:	70 28                	jo     f0107f04 <__STABSTR_BEGIN__+0x1713>
f0107edc:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107edf:	35 29 3d 2a 28       	xor    $0x282a3d29,%eax
f0107ee4:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107ee7:	39 29                	cmp    %ebp,(%ecx)
f0107ee9:	00 62 3a             	add    %ah,0x3a(%edx)
f0107eec:	72 28                	jb     f0107f16 <__STABSTR_BEGIN__+0x1725>
f0107eee:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107ef1:	35 29 00 76 70       	xor    $0x70760029,%eax
f0107ef6:	72 69                	jb     f0107f61 <__STABSTR_BEGIN__+0x1770>
f0107ef8:	6e                   	outsb  %ds:(%esi),(%dx)
f0107ef9:	74 66                	je     f0107f61 <__STABSTR_BEGIN__+0x1770>
f0107efb:	6d                   	insl   (%dx),%es:(%edi)
f0107efc:	74 3a                	je     f0107f38 <__STABSTR_BEGIN__+0x1747>
f0107efe:	46                   	inc    %esi
f0107eff:	28 30                	sub    %dh,(%eax)
f0107f01:	2c 31                	sub    $0x31,%al
f0107f03:	38 29                	cmp    %ch,(%ecx)
f0107f05:	00 70 75             	add    %dh,0x75(%eax)
f0107f08:	74 64                	je     f0107f6e <__STABSTR_BEGIN__+0x177d>
f0107f0a:	61                   	popa   
f0107f0b:	74 3a                	je     f0107f47 <__STABSTR_BEGIN__+0x1756>
f0107f0d:	70 28                	jo     f0107f37 <__STABSTR_BEGIN__+0x1746>
f0107f0f:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107f12:	32 29                	xor    (%ecx),%ch
f0107f14:	00 66 6d             	add    %ah,0x6d(%esi)
f0107f17:	74 3a                	je     f0107f53 <__STABSTR_BEGIN__+0x1762>
f0107f19:	70 28                	jo     f0107f43 <__STABSTR_BEGIN__+0x1752>
f0107f1b:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107f1e:	36 29 3d 2a 28 30 2c 	sub    %edi,%ss:0x2c30282a
f0107f25:	32 29                	xor    (%ecx),%ch
f0107f27:	00 70 3a             	add    %dh,0x3a(%eax)
f0107f2a:	28 30                	sub    %dh,(%eax)
f0107f2c:	2c 32                	sub    $0x32,%al
f0107f2e:	36 29 00             	sub    %eax,%ss:(%eax)
f0107f31:	71 3a                	jno    f0107f6d <__STABSTR_BEGIN__+0x177c>
f0107f33:	72 28                	jb     f0107f5d <__STABSTR_BEGIN__+0x176c>
f0107f35:	33 2c 32             	xor    (%edx,%esi,1),%ebp
f0107f38:	29 00                	sub    %eax,(%eax)
f0107f3a:	65                   	gs
f0107f3b:	72 72                	jb     f0107faf <__STABSTR_BEGIN__+0x17be>
f0107f3d:	3a 72 28             	cmp    0x28(%edx),%dh
f0107f40:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107f43:	29 00                	sub    %eax,(%eax)
f0107f45:	6e                   	outsb  %ds:(%esi),(%dx)
f0107f46:	75 6d                	jne    f0107fb5 <__STABSTR_BEGIN__+0x17c4>
f0107f48:	3a 72 28             	cmp    0x28(%edx),%dh
f0107f4b:	30 2c 37             	xor    %ch,(%edi,%esi,1)
f0107f4e:	29 00                	sub    %eax,(%eax)
f0107f50:	62 61 73             	bound  %esp,0x73(%ecx)
f0107f53:	65 3a 72 28          	cmp    %gs:0x28(%edx),%dh
f0107f57:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107f5a:	29 00                	sub    %eax,(%eax)
f0107f5c:	6c                   	insb   (%dx),%es:(%edi)
f0107f5d:	66                   	data16
f0107f5e:	6c                   	insb   (%dx),%es:(%edi)
f0107f5f:	61                   	popa   
f0107f60:	67 3a 28             	addr16 cmp (%bx,%si),%ch
f0107f63:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107f66:	29 00                	sub    %eax,(%eax)
f0107f68:	77 69                	ja     f0107fd3 <__STABSTR_BEGIN__+0x17e2>
f0107f6a:	64                   	fs
f0107f6b:	74 68                	je     f0107fd5 <__STABSTR_BEGIN__+0x17e4>
f0107f6d:	3a 28                	cmp    (%eax),%ch
f0107f6f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107f72:	29 00                	sub    %eax,(%eax)
f0107f74:	70 72                	jo     f0107fe8 <__STABSTR_BEGIN__+0x17f7>
f0107f76:	65 63 69 73          	arpl   %bp,%gs:0x73(%ecx)
f0107f7a:	69 6f 6e 3a 72 28 30 	imul   $0x3028723a,0x6e(%edi),%ebp
f0107f81:	2c 31                	sub    $0x31,%al
f0107f83:	29 00                	sub    %eax,(%eax)
f0107f85:	61                   	popa   
f0107f86:	6c                   	insb   (%dx),%es:(%edi)
f0107f87:	74 66                	je     f0107fef <__STABSTR_BEGIN__+0x17fe>
f0107f89:	6c                   	insb   (%dx),%es:(%edi)
f0107f8a:	61                   	popa   
f0107f8b:	67 3a 28             	addr16 cmp (%bx,%si),%ch
f0107f8e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107f91:	29 00                	sub    %eax,(%eax)
f0107f93:	70 61                	jo     f0107ff6 <__STABSTR_BEGIN__+0x1805>
f0107f95:	64 63 3a             	arpl   %di,%fs:(%edx)
f0107f98:	28 30                	sub    %dh,(%eax)
f0107f9a:	2c 32                	sub    $0x32,%al
f0107f9c:	29 00                	sub    %eax,(%eax)
f0107f9e:	70 75                	jo     f0108015 <__STABSTR_BEGIN__+0x1824>
f0107fa0:	74 64                	je     f0108006 <__STABSTR_BEGIN__+0x1815>
f0107fa2:	61                   	popa   
f0107fa3:	74 3a                	je     f0107fdf <__STABSTR_BEGIN__+0x17ee>
f0107fa5:	72 28                	jb     f0107fcf <__STABSTR_BEGIN__+0x17de>
f0107fa7:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107faa:	32 29                	xor    (%ecx),%ch
f0107fac:	00 66 6d             	add    %ah,0x6d(%esi)
f0107faf:	74 3a                	je     f0107feb <__STABSTR_BEGIN__+0x17fa>
f0107fb1:	72 28                	jb     f0107fdb <__STABSTR_BEGIN__+0x17ea>
f0107fb3:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107fb6:	36 29 00             	sub    %eax,%ss:(%eax)
f0107fb9:	6e                   	outsb  %ds:(%esi),(%dx)
f0107fba:	75 6c                	jne    f0108028 <__STABSTR_BEGIN__+0x1837>
f0107fbc:	6c                   	insb   (%dx),%es:(%edi)
f0107fbd:	5f                   	pop    %edi
f0107fbe:	65                   	gs
f0107fbf:	72 72                	jb     f0108033 <__STABSTR_BEGIN__+0x1842>
f0107fc1:	6f                   	outsl  %ds:(%esi),(%dx)
f0107fc2:	72 3a                	jb     f0107ffe <__STABSTR_BEGIN__+0x180d>
f0107fc4:	72 28                	jb     f0107fee <__STABSTR_BEGIN__+0x17fd>
f0107fc6:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107fc9:	36 29 00             	sub    %eax,%ss:(%eax)
f0107fcc:	6f                   	outsl  %ds:(%esi),(%dx)
f0107fcd:	76 65                	jbe    f0108034 <__STABSTR_BEGIN__+0x1843>
f0107fcf:	72 66                	jb     f0108037 <__STABSTR_BEGIN__+0x1846>
f0107fd1:	6c                   	insb   (%dx),%es:(%edi)
f0107fd2:	6f                   	outsl  %ds:(%esi),(%dx)
f0107fd3:	77 5f                	ja     f0108034 <__STABSTR_BEGIN__+0x1843>
f0107fd5:	65                   	gs
f0107fd6:	72 72                	jb     f010804a <__STABSTR_BEGIN__+0x1859>
f0107fd8:	6f                   	outsl  %ds:(%esi),(%dx)
f0107fd9:	72 3a                	jb     f0108015 <__STABSTR_BEGIN__+0x1824>
f0107fdb:	72 28                	jb     f0108005 <__STABSTR_BEGIN__+0x1814>
f0107fdd:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0107fe0:	36 29 00             	sub    %eax,%ss:(%eax)
f0107fe3:	76 73                	jbe    f0108058 <__STABSTR_BEGIN__+0x1867>
f0107fe5:	6e                   	outsb  %ds:(%esi),(%dx)
f0107fe6:	70 72                	jo     f010805a <__STABSTR_BEGIN__+0x1869>
f0107fe8:	69 6e 74 66 3a 46 28 	imul   $0x28463a66,0x74(%esi),%ebp
f0107fef:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0107ff2:	29 00                	sub    %eax,(%eax)
f0107ff4:	62 75 66             	bound  %esi,0x66(%ebp)
f0107ff7:	3a 70 28             	cmp    0x28(%eax),%dh
f0107ffa:	33 2c 32             	xor    (%edx,%esi,1),%ebp
f0107ffd:	29 00                	sub    %eax,(%eax)
f0107fff:	6e                   	outsb  %ds:(%esi),(%dx)
f0108000:	3a 70 28             	cmp    0x28(%eax),%dh
f0108003:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0108006:	29 00                	sub    %eax,(%eax)
f0108008:	66 6d                	insw   (%dx),%es:(%edi)
f010800a:	74 3a                	je     f0108046 <__STABSTR_BEGIN__+0x1855>
f010800c:	70 28                	jo     f0108036 <__STABSTR_BEGIN__+0x1845>
f010800e:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0108011:	36 29 00             	sub    %eax,%ss:(%eax)
f0108014:	62 3a                	bound  %edi,(%edx)
f0108016:	28 30                	sub    %dh,(%eax)
f0108018:	2c 31                	sub    $0x31,%al
f010801a:	39 29                	cmp    %ebp,(%ecx)
f010801c:	00 62 75             	add    %ah,0x75(%edx)
f010801f:	66                   	data16
f0108020:	3a 72 28             	cmp    0x28(%edx),%dh
f0108023:	33 2c 32             	xor    (%edx,%esi,1),%ebp
f0108026:	29 00                	sub    %eax,(%eax)
f0108028:	6e                   	outsb  %ds:(%esi),(%dx)
f0108029:	3a 72 28             	cmp    0x28(%edx),%dh
f010802c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f010802f:	29 00                	sub    %eax,(%eax)
f0108031:	73 6e                	jae    f01080a1 <__STABSTR_BEGIN__+0x18b0>
f0108033:	70 72                	jo     f01080a7 <__STABSTR_BEGIN__+0x18b6>
f0108035:	69 6e 74 66 3a 46 28 	imul   $0x28463a66,0x74(%esi),%ebp
f010803c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f010803f:	29 00                	sub    %eax,(%eax)
f0108041:	72 63                	jb     f01080a6 <__STABSTR_BEGIN__+0x18b5>
f0108043:	3a 72 28             	cmp    0x28(%edx),%dh
f0108046:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0108049:	29 00                	sub    %eax,(%eax)
f010804b:	70 72                	jo     f01080bf <__STABSTR_BEGIN__+0x18ce>
f010804d:	69 6e 74 66 6d 74 3a 	imul   $0x3a746d66,0x74(%esi),%ebp
f0108054:	46                   	inc    %esi
f0108055:	28 30                	sub    %dh,(%eax)
f0108057:	2c 31                	sub    $0x31,%al
f0108059:	38 29                	cmp    %ch,(%ecx)
f010805b:	00 70 75             	add    %dh,0x75(%eax)
f010805e:	74 63                	je     f01080c3 <__STABSTR_BEGIN__+0x18d2>
f0108060:	68 3a 72 28 30       	push   $0x3028723a
f0108065:	2c 32                	sub    $0x32,%al
f0108067:	30 29                	xor    %ch,(%ecx)
f0108069:	00 65 72             	add    %ah,0x72(%ebp)
f010806c:	72 6f                	jb     f01080dd <__STABSTR_BEGIN__+0x18ec>
f010806e:	72 5f                	jb     f01080cf <__STABSTR_BEGIN__+0x18de>
f0108070:	73 74                	jae    f01080e6 <__STABSTR_BEGIN__+0x18f5>
f0108072:	72 69                	jb     f01080dd <__STABSTR_BEGIN__+0x18ec>
f0108074:	6e                   	outsb  %ds:(%esi),(%dx)
f0108075:	67 3a 53 28          	addr16 cmp 0x28(%bp,%di),%dl
f0108079:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f010807c:	37                   	aaa    
f010807d:	29 3d 61 72 28 30    	sub    %edi,0x30287261
f0108083:	2c 32                	sub    $0x32,%al
f0108085:	38 29                	cmp    %ch,(%ecx)
f0108087:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
f010808c:	32 38                	xor    (%eax),%bh
f010808e:	29 3b                	sub    %edi,(%ebx)
f0108090:	30 3b                	xor    %bh,(%ebx)
f0108092:	2d 31 3b 3b 30       	sub    $0x303b3b31,%eax
f0108097:	3b 36                	cmp    (%esi),%esi
f0108099:	3b 28                	cmp    (%eax),%ebp
f010809b:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f010809e:	36 29 00             	sub    %eax,%ss:(%eax)
f01080a1:	6c                   	insb   (%dx),%es:(%edi)
f01080a2:	69 62 2f 72 65 61 64 	imul   $0x64616572,0x2f(%edx),%esp
f01080a9:	6c                   	insb   (%dx),%es:(%edi)
f01080aa:	69 6e 65 2e 63 00 72 	imul   $0x7200632e,0x65(%esi),%ebp
f01080b1:	65                   	gs
f01080b2:	61                   	popa   
f01080b3:	64                   	fs
f01080b4:	6c                   	insb   (%dx),%es:(%edi)
f01080b5:	69 6e 65 3a 46 28 32 	imul   $0x3228463a,0x65(%esi),%ebp
f01080bc:	2c 32                	sub    $0x32,%al
f01080be:	29 00                	sub    %eax,(%eax)
f01080c0:	70 72                	jo     f0108134 <__STABSTR_BEGIN__+0x1943>
f01080c2:	6f                   	outsl  %ds:(%esi),(%dx)
f01080c3:	6d                   	insl   (%dx),%es:(%edi)
f01080c4:	70 74                	jo     f010813a <__STABSTR_BEGIN__+0x1949>
f01080c6:	3a 70 28             	cmp    0x28(%eax),%dh
f01080c9:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01080cc:	39 29                	cmp    %ebp,(%ecx)
f01080ce:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f01080d3:	32 29                	xor    (%ecx),%ch
f01080d5:	00 65 63             	add    %ah,0x63(%ebp)
f01080d8:	68 6f 69 6e 67       	push   $0x676e696f
f01080dd:	3a 72 28             	cmp    0x28(%edx),%dh
f01080e0:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01080e3:	29 00                	sub    %eax,(%eax)
f01080e5:	70 72                	jo     f0108159 <__STABSTR_BEGIN__+0x1968>
f01080e7:	6f                   	outsl  %ds:(%esi),(%dx)
f01080e8:	6d                   	insl   (%dx),%es:(%edi)
f01080e9:	70 74                	jo     f010815f <__STABSTR_BEGIN__+0x196e>
f01080eb:	3a 72 28             	cmp    0x28(%edx),%dh
f01080ee:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01080f1:	39 29                	cmp    %ebp,(%ecx)
f01080f3:	00 62 75             	add    %ah,0x75(%edx)
f01080f6:	66                   	data16
f01080f7:	3a 53 28             	cmp    0x28(%ebx),%dl
f01080fa:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01080fd:	30 29                	xor    %ch,(%ecx)
f01080ff:	3d 61 72 28 30       	cmp    $0x30287261,%eax
f0108104:	2c 32                	sub    $0x32,%al
f0108106:	31 29                	xor    %ebp,(%ecx)
f0108108:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
f010810d:	32 31                	xor    (%ecx),%dh
f010810f:	29 3b                	sub    %edi,(%ebx)
f0108111:	30 3b                	xor    %bh,(%ebx)
f0108113:	2d 31 3b 3b 30       	sub    $0x303b3b31,%eax
f0108118:	3b 31                	cmp    (%ecx),%esi
f010811a:	30 32                	xor    %dh,(%edx)
f010811c:	33 3b                	xor    (%ebx),%edi
f010811e:	28 30                	sub    %dh,(%eax)
f0108120:	2c 32                	sub    $0x32,%al
f0108122:	29 00                	sub    %eax,(%eax)
f0108124:	6c                   	insb   (%dx),%es:(%edi)
f0108125:	69 62 2f 73 74 72 69 	imul   $0x69727473,0x2f(%edx),%esp
f010812c:	6e                   	outsb  %ds:(%esi),(%dx)
f010812d:	67 2e 63 00          	addr16 arpl %ax,%cs:(%bx,%si)
f0108131:	73 74                	jae    f01081a7 <__STABSTR_BEGIN__+0x19b6>
f0108133:	72 6c                	jb     f01081a1 <__STABSTR_BEGIN__+0x19b0>
f0108135:	65 6e                	outsb  %gs:(%esi),(%dx)
f0108137:	3a 46 28             	cmp    0x28(%esi),%al
f010813a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f010813d:	29 00                	sub    %eax,(%eax)
f010813f:	73 3a                	jae    f010817b <__STABSTR_BEGIN__+0x198a>
f0108141:	70 28                	jo     f010816b <__STABSTR_BEGIN__+0x197a>
f0108143:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0108146:	39 29                	cmp    %ebp,(%ecx)
f0108148:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f010814d:	32 29                	xor    (%ecx),%ch
f010814f:	00 73 3a             	add    %dh,0x3a(%ebx)
f0108152:	72 28                	jb     f010817c <__STABSTR_BEGIN__+0x198b>
f0108154:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0108157:	39 29                	cmp    %ebp,(%ecx)
f0108159:	00 73 74             	add    %dh,0x74(%ebx)
f010815c:	72 6e                	jb     f01081cc <__STABSTR_BEGIN__+0x19db>
f010815e:	6c                   	insb   (%dx),%es:(%edi)
f010815f:	65 6e                	outsb  %gs:(%esi),(%dx)
f0108161:	3a 46 28             	cmp    0x28(%esi),%al
f0108164:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0108167:	29 00                	sub    %eax,(%eax)
f0108169:	73 3a                	jae    f01081a5 <__STABSTR_BEGIN__+0x19b4>
f010816b:	70 28                	jo     f0108195 <__STABSTR_BEGIN__+0x19a4>
f010816d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0108170:	39 29                	cmp    %ebp,(%ecx)
f0108172:	00 73 69             	add    %dh,0x69(%ebx)
f0108175:	7a 65                	jp     f01081dc <__STABSTR_BEGIN__+0x19eb>
f0108177:	3a 70 28             	cmp    0x28(%eax),%dh
f010817a:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f010817d:	34 29                	xor    $0x29,%al
f010817f:	00 73 69             	add    %dh,0x69(%ebx)
f0108182:	7a 65                	jp     f01081e9 <__STABSTR_BEGIN__+0x19f8>
f0108184:	3a 72 28             	cmp    0x28(%edx),%dh
f0108187:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f010818a:	34 29                	xor    $0x29,%al
f010818c:	00 73 74             	add    %dh,0x74(%ebx)
f010818f:	72 63                	jb     f01081f4 <__STABSTR_BEGIN__+0x1a03>
f0108191:	70 79                	jo     f010820c <__STABSTR_BEGIN__+0x1a1b>
f0108193:	3a 46 28             	cmp    0x28(%esi),%al
f0108196:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0108199:	30 29                	xor    %ch,(%ecx)
f010819b:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f01081a0:	32 29                	xor    (%ecx),%ch
f01081a2:	00 64 73 74          	add    %ah,0x74(%ebx,%esi,2)
f01081a6:	3a 70 28             	cmp    0x28(%eax),%dh
f01081a9:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01081ac:	30 29                	xor    %ch,(%ecx)
f01081ae:	00 73 72             	add    %dh,0x72(%ebx)
f01081b1:	63 3a                	arpl   %di,(%edx)
f01081b3:	70 28                	jo     f01081dd <__STABSTR_BEGIN__+0x19ec>
f01081b5:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01081b8:	39 29                	cmp    %ebp,(%ecx)
f01081ba:	00 64 73 74          	add    %ah,0x74(%ebx,%esi,2)
f01081be:	3a 72 28             	cmp    0x28(%edx),%dh
f01081c1:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01081c4:	30 29                	xor    %ch,(%ecx)
f01081c6:	00 73 72             	add    %dh,0x72(%ebx)
f01081c9:	63 3a                	arpl   %di,(%edx)
f01081cb:	72 28                	jb     f01081f5 <__STABSTR_BEGIN__+0x1a04>
f01081cd:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01081d0:	39 29                	cmp    %ebp,(%ecx)
f01081d2:	00 73 74             	add    %dh,0x74(%ebx)
f01081d5:	72 6e                	jb     f0108245 <__STABSTR_BEGIN__+0x1a54>
f01081d7:	63 70 79             	arpl   %si,0x79(%eax)
f01081da:	3a 46 28             	cmp    0x28(%esi),%al
f01081dd:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01081e0:	30 29                	xor    %ch,(%ecx)
f01081e2:	00 69 3a             	add    %ch,0x3a(%ecx)
f01081e5:	72 28                	jb     f010820f <__STABSTR_BEGIN__+0x1a1e>
f01081e7:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f01081ea:	34 29                	xor    $0x29,%al
f01081ec:	00 73 74             	add    %dh,0x74(%ebx)
f01081ef:	72 6c                	jb     f010825d <__STABSTR_BEGIN__+0x1a6c>
f01081f1:	63 70 79             	arpl   %si,0x79(%eax)
f01081f4:	3a 46 28             	cmp    0x28(%esi),%al
f01081f7:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f01081fa:	34 29                	xor    $0x29,%al
f01081fc:	00 73 74             	add    %dh,0x74(%ebx)
f01081ff:	72 63                	jb     f0108264 <__STABSTR_BEGIN__+0x1a73>
f0108201:	6d                   	insl   (%dx),%es:(%edi)
f0108202:	70 3a                	jo     f010823e <__STABSTR_BEGIN__+0x1a4d>
f0108204:	46                   	inc    %esi
f0108205:	28 30                	sub    %dh,(%eax)
f0108207:	2c 31                	sub    $0x31,%al
f0108209:	29 00                	sub    %eax,(%eax)
f010820b:	70 3a                	jo     f0108247 <__STABSTR_BEGIN__+0x1a56>
f010820d:	70 28                	jo     f0108237 <__STABSTR_BEGIN__+0x1a46>
f010820f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0108212:	39 29                	cmp    %ebp,(%ecx)
f0108214:	00 71 3a             	add    %dh,0x3a(%ecx)
f0108217:	70 28                	jo     f0108241 <__STABSTR_BEGIN__+0x1a50>
f0108219:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f010821c:	39 29                	cmp    %ebp,(%ecx)
f010821e:	00 70 3a             	add    %dh,0x3a(%eax)
f0108221:	72 28                	jb     f010824b <__STABSTR_BEGIN__+0x1a5a>
f0108223:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0108226:	39 29                	cmp    %ebp,(%ecx)
f0108228:	00 71 3a             	add    %dh,0x3a(%ecx)
f010822b:	72 28                	jb     f0108255 <__STABSTR_BEGIN__+0x1a64>
f010822d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0108230:	39 29                	cmp    %ebp,(%ecx)
f0108232:	00 73 74             	add    %dh,0x74(%ebx)
f0108235:	72 6e                	jb     f01082a5 <__STABSTR_BEGIN__+0x1ab4>
f0108237:	63 6d 70             	arpl   %bp,0x70(%ebp)
f010823a:	3a 46 28             	cmp    0x28(%esi),%al
f010823d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0108240:	29 00                	sub    %eax,(%eax)
f0108242:	6e                   	outsb  %ds:(%esi),(%dx)
f0108243:	3a 70 28             	cmp    0x28(%eax),%dh
f0108246:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f0108249:	34 29                	xor    $0x29,%al
f010824b:	00 6e 3a             	add    %ch,0x3a(%esi)
f010824e:	72 28                	jb     f0108278 <__STABSTR_BEGIN__+0x1a87>
f0108250:	32 2c 31             	xor    (%ecx,%esi,1),%ch
f0108253:	34 29                	xor    $0x29,%al
f0108255:	00 73 74             	add    %dh,0x74(%ebx)
f0108258:	72 63                	jb     f01082bd <__STABSTR_BEGIN__+0x1acc>
f010825a:	68 72 3a 46 28       	push   $0x28463a72
f010825f:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0108262:	30 29                	xor    %ch,(%ecx)
f0108264:	00 63 3a             	add    %ah,0x3a(%ebx)
f0108267:	72 28                	jb     f0108291 <__STABSTR_BEGIN__+0x1aa0>
f0108269:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f010826c:	29 00                	sub    %eax,(%eax)
f010826e:	73 74                	jae    f01082e4 <__STABSTR_BEGIN__+0x1af3>
f0108270:	72 66                	jb     f01082d8 <__STABSTR_BEGIN__+0x1ae7>
f0108272:	69 6e 64 3a 46 28 30 	imul   $0x3028463a,0x64(%esi),%ebp
f0108279:	2c 32                	sub    $0x32,%al
f010827b:	30 29                	xor    %ch,(%ecx)
f010827d:	00 6d 65             	add    %ch,0x65(%ebp)
f0108280:	6d                   	insl   (%dx),%es:(%edi)
f0108281:	73 65                	jae    f01082e8 <__STABSTR_BEGIN__+0x1af7>
f0108283:	74 3a                	je     f01082bf <__STABSTR_BEGIN__+0x1ace>
f0108285:	46                   	inc    %esi
f0108286:	28 30                	sub    %dh,(%eax)
f0108288:	2c 32                	sub    $0x32,%al
f010828a:	31 29                	xor    %ebp,(%ecx)
f010828c:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f0108291:	31 38                	xor    %edi,(%eax)
f0108293:	29 00                	sub    %eax,(%eax)
f0108295:	76 3a                	jbe    f01082d1 <__STABSTR_BEGIN__+0x1ae0>
f0108297:	70 28                	jo     f01082c1 <__STABSTR_BEGIN__+0x1ad0>
f0108299:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f010829c:	31 29                	xor    %ebp,(%ecx)
f010829e:	00 76 3a             	add    %dh,0x3a(%esi)
f01082a1:	72 28                	jb     f01082cb <__STABSTR_BEGIN__+0x1ada>
f01082a3:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01082a6:	31 29                	xor    %ebp,(%ecx)
f01082a8:	00 6d 65             	add    %ch,0x65(%ebp)
f01082ab:	6d                   	insl   (%dx),%es:(%edi)
f01082ac:	6d                   	insl   (%dx),%es:(%edi)
f01082ad:	6f                   	outsl  %ds:(%esi),(%dx)
f01082ae:	76 65                	jbe    f0108315 <__STABSTR_BEGIN__+0x1b24>
f01082b0:	3a 46 28             	cmp    0x28(%esi),%al
f01082b3:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01082b6:	31 29                	xor    %ebp,(%ecx)
f01082b8:	00 64 73 74          	add    %ah,0x74(%ebx,%esi,2)
f01082bc:	3a 70 28             	cmp    0x28(%eax),%dh
f01082bf:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01082c2:	31 29                	xor    %ebp,(%ecx)
f01082c4:	00 73 72             	add    %dh,0x72(%ebx)
f01082c7:	63 3a                	arpl   %di,(%edx)
f01082c9:	70 28                	jo     f01082f3 <__STABSTR_BEGIN__+0x1b02>
f01082cb:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01082ce:	32 29                	xor    (%ecx),%ch
f01082d0:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f01082d5:	31 38                	xor    %edi,(%eax)
f01082d7:	29 00                	sub    %eax,(%eax)
f01082d9:	64 3a 72 28          	cmp    %fs:0x28(%edx),%dh
f01082dd:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01082e0:	30 29                	xor    %ch,(%ecx)
f01082e2:	00 64 73 74          	add    %ah,0x74(%ebx,%esi,2)
f01082e6:	3a 72 28             	cmp    0x28(%edx),%dh
f01082e9:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01082ec:	31 29                	xor    %ebp,(%ecx)
f01082ee:	00 6d 65             	add    %ch,0x65(%ebp)
f01082f1:	6d                   	insl   (%dx),%es:(%edi)
f01082f2:	63 70 79             	arpl   %si,0x79(%eax)
f01082f5:	3a 46 28             	cmp    0x28(%esi),%al
f01082f8:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f01082fb:	31 29                	xor    %ebp,(%ecx)
f01082fd:	00 73 72             	add    %dh,0x72(%ebx)
f0108300:	63 3a                	arpl   %di,(%edx)
f0108302:	70 28                	jo     f010832c <__STABSTR_BEGIN__+0x1b3b>
f0108304:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0108307:	31 29                	xor    %ebp,(%ecx)
f0108309:	00 73 72             	add    %dh,0x72(%ebx)
f010830c:	63 3a                	arpl   %di,(%edx)
f010830e:	72 28                	jb     f0108338 <__STABSTR_BEGIN__+0x1b47>
f0108310:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0108313:	31 29                	xor    %ebp,(%ecx)
f0108315:	00 6d 65             	add    %ch,0x65(%ebp)
f0108318:	6d                   	insl   (%dx),%es:(%edi)
f0108319:	63 6d 70             	arpl   %bp,0x70(%ebp)
f010831c:	3a 46 28             	cmp    0x28(%esi),%al
f010831f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f0108322:	29 00                	sub    %eax,(%eax)
f0108324:	76 31                	jbe    f0108357 <__STABSTR_BEGIN__+0x1b66>
f0108326:	3a 70 28             	cmp    0x28(%eax),%dh
f0108329:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f010832c:	32 29                	xor    (%ecx),%ch
f010832e:	00 76 32             	add    %dh,0x32(%esi)
f0108331:	3a 70 28             	cmp    0x28(%eax),%dh
f0108334:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0108337:	32 29                	xor    (%ecx),%ch
f0108339:	00 76 31             	add    %dh,0x31(%esi)
f010833c:	3a 72 28             	cmp    0x28(%edx),%dh
f010833f:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0108342:	32 29                	xor    (%ecx),%ch
f0108344:	00 76 32             	add    %dh,0x32(%esi)
f0108347:	3a 72 28             	cmp    0x28(%edx),%dh
f010834a:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f010834d:	32 29                	xor    (%ecx),%ch
f010834f:	00 6d 65             	add    %ch,0x65(%ebp)
f0108352:	6d                   	insl   (%dx),%es:(%edi)
f0108353:	66 69 6e 64 3a 46    	imul   $0x463a,0x64(%esi),%bp
f0108359:	28 30                	sub    %dh,(%eax)
f010835b:	2c 32                	sub    $0x32,%al
f010835d:	31 29                	xor    %ebp,(%ecx)
f010835f:	00 73 3a             	add    %dh,0x3a(%ebx)
f0108362:	70 28                	jo     f010838c <__STABSTR_BEGIN__+0x1b9b>
f0108364:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0108367:	32 29                	xor    (%ecx),%ch
f0108369:	00 65 6e             	add    %ah,0x6e(%ebp)
f010836c:	64                   	fs
f010836d:	73 3a                	jae    f01083a9 <__STABSTR_BEGIN__+0x1bb8>
f010836f:	72 28                	jb     f0108399 <__STABSTR_BEGIN__+0x1ba8>
f0108371:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f0108374:	32 29                	xor    (%ecx),%ch
f0108376:	00 73 3a             	add    %dh,0x3a(%ebx)
f0108379:	72 28                	jb     f01083a3 <__STABSTR_BEGIN__+0x1bb2>
f010837b:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f010837e:	32 29                	xor    (%ecx),%ch
f0108380:	00 73 74             	add    %dh,0x74(%ebx)
f0108383:	72 74                	jb     f01083f9 <__STABSTR_END__+0x27>
f0108385:	6f                   	outsl  %ds:(%esi),(%dx)
f0108386:	6c                   	insb   (%dx),%es:(%edi)
f0108387:	3a 46 28             	cmp    0x28(%esi),%al
f010838a:	30 2c 33             	xor    %ch,(%ebx,%esi,1)
f010838d:	29 00                	sub    %eax,(%eax)
f010838f:	65 6e                	outsb  %gs:(%esi),(%dx)
f0108391:	64                   	fs
f0108392:	70 74                	jo     f0108408 <__STABSTR_END__+0x36>
f0108394:	72 3a                	jb     f01083d0 <__STABSTR_BEGIN__+0x1bdf>
f0108396:	70 28                	jo     f01083c0 <__STABSTR_BEGIN__+0x1bcf>
f0108398:	30 2c 32             	xor    %ch,(%edx,%esi,1)
f010839b:	33 29                	xor    (%ecx),%ebp
f010839d:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
f01083a2:	32 30                	xor    (%eax),%dh
f01083a4:	29 00                	sub    %eax,(%eax)
f01083a6:	62 61 73             	bound  %esp,0x73(%ecx)
f01083a9:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
f01083ad:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01083b0:	29 00                	sub    %eax,(%eax)
f01083b2:	6e                   	outsb  %ds:(%esi),(%dx)
f01083b3:	65 67 3a 28          	addr16 cmp %gs:(%bx,%si),%ch
f01083b7:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
f01083ba:	29 00                	sub    %eax,(%eax)
f01083bc:	76 61                	jbe    f010841f <__STABSTR_END__+0x4d>
f01083be:	6c                   	insb   (%dx),%es:(%edi)
f01083bf:	3a 72 28             	cmp    0x28(%edx),%dh
f01083c2:	30 2c 33             	xor    %ch,(%ebx,%esi,1)
f01083c5:	29 00                	sub    %eax,(%eax)
f01083c7:	64 69 67 3a 72 28 30 	imul   $0x2c302872,%fs:0x3a(%edi),%esp
f01083ce:	2c 
f01083cf:	31 29                	xor    %ebp,(%ecx)
	...

f01083d2 <__STABSTR_END__>:
	...

Disassembly of section .data:

f0109000 <bootstack>:
	...

f0111000 <bootstacktop>:
f0111000:	01 20                	add    %esp,(%eax)
f0111002:	11 00                	adc    %eax,(%eax)
	...
f0111f00:	03 20                	add    (%eax),%esp
f0111f02:	11 00                	adc    %eax,(%eax)
	...

f0112000 <entry_pgtable>:
f0112000:	03 00                	add    (%eax),%eax
f0112002:	00 00                	add    %al,(%eax)
f0112004:	03 10                	add    (%eax),%edx
f0112006:	00 00                	add    %al,(%eax)
f0112008:	03 20                	add    (%eax),%esp
f011200a:	00 00                	add    %al,(%eax)
f011200c:	03 30                	add    (%eax),%esi
f011200e:	00 00                	add    %al,(%eax)
f0112010:	03 40 00             	add    0x0(%eax),%eax
f0112013:	00 03                	add    %al,(%ebx)
f0112015:	50                   	push   %eax
f0112016:	00 00                	add    %al,(%eax)
f0112018:	03 60 00             	add    0x0(%eax),%esp
f011201b:	00 03                	add    %al,(%ebx)
f011201d:	70 00                	jo     f011201f <entry_pgtable+0x1f>
f011201f:	00 03                	add    %al,(%ebx)
f0112021:	80 00 00             	addb   $0x0,(%eax)
f0112024:	03 90 00 00 03 a0    	add    -0x5ffd0000(%eax),%edx
f011202a:	00 00                	add    %al,(%eax)
f011202c:	03 b0 00 00 03 c0    	add    -0x3ffd0000(%eax),%esi
f0112032:	00 00                	add    %al,(%eax)
f0112034:	03 d0                	add    %eax,%edx
f0112036:	00 00                	add    %al,(%eax)
f0112038:	03 e0                	add    %eax,%esp
f011203a:	00 00                	add    %al,(%eax)
f011203c:	03 f0                	add    %eax,%esi
f011203e:	00 00                	add    %al,(%eax)
f0112040:	03 00                	add    (%eax),%eax
f0112042:	01 00                	add    %eax,(%eax)
f0112044:	03 10                	add    (%eax),%edx
f0112046:	01 00                	add    %eax,(%eax)
f0112048:	03 20                	add    (%eax),%esp
f011204a:	01 00                	add    %eax,(%eax)
f011204c:	03 30                	add    (%eax),%esi
f011204e:	01 00                	add    %eax,(%eax)
f0112050:	03 40 01             	add    0x1(%eax),%eax
f0112053:	00 03                	add    %al,(%ebx)
f0112055:	50                   	push   %eax
f0112056:	01 00                	add    %eax,(%eax)
f0112058:	03 60 01             	add    0x1(%eax),%esp
f011205b:	00 03                	add    %al,(%ebx)
f011205d:	70 01                	jo     f0112060 <entry_pgtable+0x60>
f011205f:	00 03                	add    %al,(%ebx)
f0112061:	80 01 00             	addb   $0x0,(%ecx)
f0112064:	03 90 01 00 03 a0    	add    -0x5ffcffff(%eax),%edx
f011206a:	01 00                	add    %eax,(%eax)
f011206c:	03 b0 01 00 03 c0    	add    -0x3ffcffff(%eax),%esi
f0112072:	01 00                	add    %eax,(%eax)
f0112074:	03 d0                	add    %eax,%edx
f0112076:	01 00                	add    %eax,(%eax)
f0112078:	03 e0                	add    %eax,%esp
f011207a:	01 00                	add    %eax,(%eax)
f011207c:	03 f0                	add    %eax,%esi
f011207e:	01 00                	add    %eax,(%eax)
f0112080:	03 00                	add    (%eax),%eax
f0112082:	02 00                	add    (%eax),%al
f0112084:	03 10                	add    (%eax),%edx
f0112086:	02 00                	add    (%eax),%al
f0112088:	03 20                	add    (%eax),%esp
f011208a:	02 00                	add    (%eax),%al
f011208c:	03 30                	add    (%eax),%esi
f011208e:	02 00                	add    (%eax),%al
f0112090:	03 40 02             	add    0x2(%eax),%eax
f0112093:	00 03                	add    %al,(%ebx)
f0112095:	50                   	push   %eax
f0112096:	02 00                	add    (%eax),%al
f0112098:	03 60 02             	add    0x2(%eax),%esp
f011209b:	00 03                	add    %al,(%ebx)
f011209d:	70 02                	jo     f01120a1 <entry_pgtable+0xa1>
f011209f:	00 03                	add    %al,(%ebx)
f01120a1:	80 02 00             	addb   $0x0,(%edx)
f01120a4:	03 90 02 00 03 a0    	add    -0x5ffcfffe(%eax),%edx
f01120aa:	02 00                	add    (%eax),%al
f01120ac:	03 b0 02 00 03 c0    	add    -0x3ffcfffe(%eax),%esi
f01120b2:	02 00                	add    (%eax),%al
f01120b4:	03 d0                	add    %eax,%edx
f01120b6:	02 00                	add    (%eax),%al
f01120b8:	03 e0                	add    %eax,%esp
f01120ba:	02 00                	add    (%eax),%al
f01120bc:	03 f0                	add    %eax,%esi
f01120be:	02 00                	add    (%eax),%al
f01120c0:	03 00                	add    (%eax),%eax
f01120c2:	03 00                	add    (%eax),%eax
f01120c4:	03 10                	add    (%eax),%edx
f01120c6:	03 00                	add    (%eax),%eax
f01120c8:	03 20                	add    (%eax),%esp
f01120ca:	03 00                	add    (%eax),%eax
f01120cc:	03 30                	add    (%eax),%esi
f01120ce:	03 00                	add    (%eax),%eax
f01120d0:	03 40 03             	add    0x3(%eax),%eax
f01120d3:	00 03                	add    %al,(%ebx)
f01120d5:	50                   	push   %eax
f01120d6:	03 00                	add    (%eax),%eax
f01120d8:	03 60 03             	add    0x3(%eax),%esp
f01120db:	00 03                	add    %al,(%ebx)
f01120dd:	70 03                	jo     f01120e2 <entry_pgtable+0xe2>
f01120df:	00 03                	add    %al,(%ebx)
f01120e1:	80 03 00             	addb   $0x0,(%ebx)
f01120e4:	03 90 03 00 03 a0    	add    -0x5ffcfffd(%eax),%edx
f01120ea:	03 00                	add    (%eax),%eax
f01120ec:	03 b0 03 00 03 c0    	add    -0x3ffcfffd(%eax),%esi
f01120f2:	03 00                	add    (%eax),%eax
f01120f4:	03 d0                	add    %eax,%edx
f01120f6:	03 00                	add    (%eax),%eax
f01120f8:	03 e0                	add    %eax,%esp
f01120fa:	03 00                	add    (%eax),%eax
f01120fc:	03 f0                	add    %eax,%esi
f01120fe:	03 00                	add    (%eax),%eax
f0112100:	03 00                	add    (%eax),%eax
f0112102:	04 00                	add    $0x0,%al
f0112104:	03 10                	add    (%eax),%edx
f0112106:	04 00                	add    $0x0,%al
f0112108:	03 20                	add    (%eax),%esp
f011210a:	04 00                	add    $0x0,%al
f011210c:	03 30                	add    (%eax),%esi
f011210e:	04 00                	add    $0x0,%al
f0112110:	03 40 04             	add    0x4(%eax),%eax
f0112113:	00 03                	add    %al,(%ebx)
f0112115:	50                   	push   %eax
f0112116:	04 00                	add    $0x0,%al
f0112118:	03 60 04             	add    0x4(%eax),%esp
f011211b:	00 03                	add    %al,(%ebx)
f011211d:	70 04                	jo     f0112123 <entry_pgtable+0x123>
f011211f:	00 03                	add    %al,(%ebx)
f0112121:	80 04 00 03          	addb   $0x3,(%eax,%eax,1)
f0112125:	90                   	nop
f0112126:	04 00                	add    $0x0,%al
f0112128:	03 a0 04 00 03 b0    	add    -0x4ffcfffc(%eax),%esp
f011212e:	04 00                	add    $0x0,%al
f0112130:	03 c0                	add    %eax,%eax
f0112132:	04 00                	add    $0x0,%al
f0112134:	03 d0                	add    %eax,%edx
f0112136:	04 00                	add    $0x0,%al
f0112138:	03 e0                	add    %eax,%esp
f011213a:	04 00                	add    $0x0,%al
f011213c:	03 f0                	add    %eax,%esi
f011213e:	04 00                	add    $0x0,%al
f0112140:	03 00                	add    (%eax),%eax
f0112142:	05 00 03 10 05       	add    $0x5100300,%eax
f0112147:	00 03                	add    %al,(%ebx)
f0112149:	20 05 00 03 30 05    	and    %al,0x5300300
f011214f:	00 03                	add    %al,(%ebx)
f0112151:	40                   	inc    %eax
f0112152:	05 00 03 50 05       	add    $0x5500300,%eax
f0112157:	00 03                	add    %al,(%ebx)
f0112159:	60                   	pusha  
f011215a:	05 00 03 70 05       	add    $0x5700300,%eax
f011215f:	00 03                	add    %al,(%ebx)
f0112161:	80 05 00 03 90 05 00 	addb   $0x0,0x5900300
f0112168:	03 a0 05 00 03 b0    	add    -0x4ffcfffb(%eax),%esp
f011216e:	05 00 03 c0 05       	add    $0x5c00300,%eax
f0112173:	00 03                	add    %al,(%ebx)
f0112175:	d0 05 00 03 e0 05    	rolb   0x5e00300
f011217b:	00 03                	add    %al,(%ebx)
f011217d:	f0 05 00 03 00 06    	lock add $0x6000300,%eax
f0112183:	00 03                	add    %al,(%ebx)
f0112185:	10 06                	adc    %al,(%esi)
f0112187:	00 03                	add    %al,(%ebx)
f0112189:	20 06                	and    %al,(%esi)
f011218b:	00 03                	add    %al,(%ebx)
f011218d:	30 06                	xor    %al,(%esi)
f011218f:	00 03                	add    %al,(%ebx)
f0112191:	40                   	inc    %eax
f0112192:	06                   	push   %es
f0112193:	00 03                	add    %al,(%ebx)
f0112195:	50                   	push   %eax
f0112196:	06                   	push   %es
f0112197:	00 03                	add    %al,(%ebx)
f0112199:	60                   	pusha  
f011219a:	06                   	push   %es
f011219b:	00 03                	add    %al,(%ebx)
f011219d:	70 06                	jo     f01121a5 <entry_pgtable+0x1a5>
f011219f:	00 03                	add    %al,(%ebx)
f01121a1:	80 06 00             	addb   $0x0,(%esi)
f01121a4:	03 90 06 00 03 a0    	add    -0x5ffcfffa(%eax),%edx
f01121aa:	06                   	push   %es
f01121ab:	00 03                	add    %al,(%ebx)
f01121ad:	b0 06                	mov    $0x6,%al
f01121af:	00 03                	add    %al,(%ebx)
f01121b1:	c0 06 00             	rolb   $0x0,(%esi)
f01121b4:	03 d0                	add    %eax,%edx
f01121b6:	06                   	push   %es
f01121b7:	00 03                	add    %al,(%ebx)
f01121b9:	e0 06                	loopne f01121c1 <entry_pgtable+0x1c1>
f01121bb:	00 03                	add    %al,(%ebx)
f01121bd:	f0 06                	lock push %es
f01121bf:	00 03                	add    %al,(%ebx)
f01121c1:	00 07                	add    %al,(%edi)
f01121c3:	00 03                	add    %al,(%ebx)
f01121c5:	10 07                	adc    %al,(%edi)
f01121c7:	00 03                	add    %al,(%ebx)
f01121c9:	20 07                	and    %al,(%edi)
f01121cb:	00 03                	add    %al,(%ebx)
f01121cd:	30 07                	xor    %al,(%edi)
f01121cf:	00 03                	add    %al,(%ebx)
f01121d1:	40                   	inc    %eax
f01121d2:	07                   	pop    %es
f01121d3:	00 03                	add    %al,(%ebx)
f01121d5:	50                   	push   %eax
f01121d6:	07                   	pop    %es
f01121d7:	00 03                	add    %al,(%ebx)
f01121d9:	60                   	pusha  
f01121da:	07                   	pop    %es
f01121db:	00 03                	add    %al,(%ebx)
f01121dd:	70 07                	jo     f01121e6 <entry_pgtable+0x1e6>
f01121df:	00 03                	add    %al,(%ebx)
f01121e1:	80 07 00             	addb   $0x0,(%edi)
f01121e4:	03 90 07 00 03 a0    	add    -0x5ffcfff9(%eax),%edx
f01121ea:	07                   	pop    %es
f01121eb:	00 03                	add    %al,(%ebx)
f01121ed:	b0 07                	mov    $0x7,%al
f01121ef:	00 03                	add    %al,(%ebx)
f01121f1:	c0 07 00             	rolb   $0x0,(%edi)
f01121f4:	03 d0                	add    %eax,%edx
f01121f6:	07                   	pop    %es
f01121f7:	00 03                	add    %al,(%ebx)
f01121f9:	e0 07                	loopne f0112202 <entry_pgtable+0x202>
f01121fb:	00 03                	add    %al,(%ebx)
f01121fd:	f0 07                	lock pop %es
f01121ff:	00 03                	add    %al,(%ebx)
f0112201:	00 08                	add    %cl,(%eax)
f0112203:	00 03                	add    %al,(%ebx)
f0112205:	10 08                	adc    %cl,(%eax)
f0112207:	00 03                	add    %al,(%ebx)
f0112209:	20 08                	and    %cl,(%eax)
f011220b:	00 03                	add    %al,(%ebx)
f011220d:	30 08                	xor    %cl,(%eax)
f011220f:	00 03                	add    %al,(%ebx)
f0112211:	40                   	inc    %eax
f0112212:	08 00                	or     %al,(%eax)
f0112214:	03 50 08             	add    0x8(%eax),%edx
f0112217:	00 03                	add    %al,(%ebx)
f0112219:	60                   	pusha  
f011221a:	08 00                	or     %al,(%eax)
f011221c:	03 70 08             	add    0x8(%eax),%esi
f011221f:	00 03                	add    %al,(%ebx)
f0112221:	80 08 00             	orb    $0x0,(%eax)
f0112224:	03 90 08 00 03 a0    	add    -0x5ffcfff8(%eax),%edx
f011222a:	08 00                	or     %al,(%eax)
f011222c:	03 b0 08 00 03 c0    	add    -0x3ffcfff8(%eax),%esi
f0112232:	08 00                	or     %al,(%eax)
f0112234:	03 d0                	add    %eax,%edx
f0112236:	08 00                	or     %al,(%eax)
f0112238:	03 e0                	add    %eax,%esp
f011223a:	08 00                	or     %al,(%eax)
f011223c:	03 f0                	add    %eax,%esi
f011223e:	08 00                	or     %al,(%eax)
f0112240:	03 00                	add    (%eax),%eax
f0112242:	09 00                	or     %eax,(%eax)
f0112244:	03 10                	add    (%eax),%edx
f0112246:	09 00                	or     %eax,(%eax)
f0112248:	03 20                	add    (%eax),%esp
f011224a:	09 00                	or     %eax,(%eax)
f011224c:	03 30                	add    (%eax),%esi
f011224e:	09 00                	or     %eax,(%eax)
f0112250:	03 40 09             	add    0x9(%eax),%eax
f0112253:	00 03                	add    %al,(%ebx)
f0112255:	50                   	push   %eax
f0112256:	09 00                	or     %eax,(%eax)
f0112258:	03 60 09             	add    0x9(%eax),%esp
f011225b:	00 03                	add    %al,(%ebx)
f011225d:	70 09                	jo     f0112268 <entry_pgtable+0x268>
f011225f:	00 03                	add    %al,(%ebx)
f0112261:	80 09 00             	orb    $0x0,(%ecx)
f0112264:	03 90 09 00 03 a0    	add    -0x5ffcfff7(%eax),%edx
f011226a:	09 00                	or     %eax,(%eax)
f011226c:	03 b0 09 00 03 c0    	add    -0x3ffcfff7(%eax),%esi
f0112272:	09 00                	or     %eax,(%eax)
f0112274:	03 d0                	add    %eax,%edx
f0112276:	09 00                	or     %eax,(%eax)
f0112278:	03 e0                	add    %eax,%esp
f011227a:	09 00                	or     %eax,(%eax)
f011227c:	03 f0                	add    %eax,%esi
f011227e:	09 00                	or     %eax,(%eax)
f0112280:	03 00                	add    (%eax),%eax
f0112282:	0a 00                	or     (%eax),%al
f0112284:	03 10                	add    (%eax),%edx
f0112286:	0a 00                	or     (%eax),%al
f0112288:	03 20                	add    (%eax),%esp
f011228a:	0a 00                	or     (%eax),%al
f011228c:	03 30                	add    (%eax),%esi
f011228e:	0a 00                	or     (%eax),%al
f0112290:	03 40 0a             	add    0xa(%eax),%eax
f0112293:	00 03                	add    %al,(%ebx)
f0112295:	50                   	push   %eax
f0112296:	0a 00                	or     (%eax),%al
f0112298:	03 60 0a             	add    0xa(%eax),%esp
f011229b:	00 03                	add    %al,(%ebx)
f011229d:	70 0a                	jo     f01122a9 <entry_pgtable+0x2a9>
f011229f:	00 03                	add    %al,(%ebx)
f01122a1:	80 0a 00             	orb    $0x0,(%edx)
f01122a4:	03 90 0a 00 03 a0    	add    -0x5ffcfff6(%eax),%edx
f01122aa:	0a 00                	or     (%eax),%al
f01122ac:	03 b0 0a 00 03 c0    	add    -0x3ffcfff6(%eax),%esi
f01122b2:	0a 00                	or     (%eax),%al
f01122b4:	03 d0                	add    %eax,%edx
f01122b6:	0a 00                	or     (%eax),%al
f01122b8:	03 e0                	add    %eax,%esp
f01122ba:	0a 00                	or     (%eax),%al
f01122bc:	03 f0                	add    %eax,%esi
f01122be:	0a 00                	or     (%eax),%al
f01122c0:	03 00                	add    (%eax),%eax
f01122c2:	0b 00                	or     (%eax),%eax
f01122c4:	03 10                	add    (%eax),%edx
f01122c6:	0b 00                	or     (%eax),%eax
f01122c8:	03 20                	add    (%eax),%esp
f01122ca:	0b 00                	or     (%eax),%eax
f01122cc:	03 30                	add    (%eax),%esi
f01122ce:	0b 00                	or     (%eax),%eax
f01122d0:	03 40 0b             	add    0xb(%eax),%eax
f01122d3:	00 03                	add    %al,(%ebx)
f01122d5:	50                   	push   %eax
f01122d6:	0b 00                	or     (%eax),%eax
f01122d8:	03 60 0b             	add    0xb(%eax),%esp
f01122db:	00 03                	add    %al,(%ebx)
f01122dd:	70 0b                	jo     f01122ea <entry_pgtable+0x2ea>
f01122df:	00 03                	add    %al,(%ebx)
f01122e1:	80 0b 00             	orb    $0x0,(%ebx)
f01122e4:	03 90 0b 00 03 a0    	add    -0x5ffcfff5(%eax),%edx
f01122ea:	0b 00                	or     (%eax),%eax
f01122ec:	03 b0 0b 00 03 c0    	add    -0x3ffcfff5(%eax),%esi
f01122f2:	0b 00                	or     (%eax),%eax
f01122f4:	03 d0                	add    %eax,%edx
f01122f6:	0b 00                	or     (%eax),%eax
f01122f8:	03 e0                	add    %eax,%esp
f01122fa:	0b 00                	or     (%eax),%eax
f01122fc:	03 f0                	add    %eax,%esi
f01122fe:	0b 00                	or     (%eax),%eax
f0112300:	03 00                	add    (%eax),%eax
f0112302:	0c 00                	or     $0x0,%al
f0112304:	03 10                	add    (%eax),%edx
f0112306:	0c 00                	or     $0x0,%al
f0112308:	03 20                	add    (%eax),%esp
f011230a:	0c 00                	or     $0x0,%al
f011230c:	03 30                	add    (%eax),%esi
f011230e:	0c 00                	or     $0x0,%al
f0112310:	03 40 0c             	add    0xc(%eax),%eax
f0112313:	00 03                	add    %al,(%ebx)
f0112315:	50                   	push   %eax
f0112316:	0c 00                	or     $0x0,%al
f0112318:	03 60 0c             	add    0xc(%eax),%esp
f011231b:	00 03                	add    %al,(%ebx)
f011231d:	70 0c                	jo     f011232b <entry_pgtable+0x32b>
f011231f:	00 03                	add    %al,(%ebx)
f0112321:	80 0c 00 03          	orb    $0x3,(%eax,%eax,1)
f0112325:	90                   	nop
f0112326:	0c 00                	or     $0x0,%al
f0112328:	03 a0 0c 00 03 b0    	add    -0x4ffcfff4(%eax),%esp
f011232e:	0c 00                	or     $0x0,%al
f0112330:	03 c0                	add    %eax,%eax
f0112332:	0c 00                	or     $0x0,%al
f0112334:	03 d0                	add    %eax,%edx
f0112336:	0c 00                	or     $0x0,%al
f0112338:	03 e0                	add    %eax,%esp
f011233a:	0c 00                	or     $0x0,%al
f011233c:	03 f0                	add    %eax,%esi
f011233e:	0c 00                	or     $0x0,%al
f0112340:	03 00                	add    (%eax),%eax
f0112342:	0d 00 03 10 0d       	or     $0xd100300,%eax
f0112347:	00 03                	add    %al,(%ebx)
f0112349:	20 0d 00 03 30 0d    	and    %cl,0xd300300
f011234f:	00 03                	add    %al,(%ebx)
f0112351:	40                   	inc    %eax
f0112352:	0d 00 03 50 0d       	or     $0xd500300,%eax
f0112357:	00 03                	add    %al,(%ebx)
f0112359:	60                   	pusha  
f011235a:	0d 00 03 70 0d       	or     $0xd700300,%eax
f011235f:	00 03                	add    %al,(%ebx)
f0112361:	80 0d 00 03 90 0d 00 	orb    $0x0,0xd900300
f0112368:	03 a0 0d 00 03 b0    	add    -0x4ffcfff3(%eax),%esp
f011236e:	0d 00 03 c0 0d       	or     $0xdc00300,%eax
f0112373:	00 03                	add    %al,(%ebx)
f0112375:	d0 0d 00 03 e0 0d    	rorb   0xde00300
f011237b:	00 03                	add    %al,(%ebx)
f011237d:	f0 0d 00 03 00 0e    	lock or $0xe000300,%eax
f0112383:	00 03                	add    %al,(%ebx)
f0112385:	10 0e                	adc    %cl,(%esi)
f0112387:	00 03                	add    %al,(%ebx)
f0112389:	20 0e                	and    %cl,(%esi)
f011238b:	00 03                	add    %al,(%ebx)
f011238d:	30 0e                	xor    %cl,(%esi)
f011238f:	00 03                	add    %al,(%ebx)
f0112391:	40                   	inc    %eax
f0112392:	0e                   	push   %cs
f0112393:	00 03                	add    %al,(%ebx)
f0112395:	50                   	push   %eax
f0112396:	0e                   	push   %cs
f0112397:	00 03                	add    %al,(%ebx)
f0112399:	60                   	pusha  
f011239a:	0e                   	push   %cs
f011239b:	00 03                	add    %al,(%ebx)
f011239d:	70 0e                	jo     f01123ad <entry_pgtable+0x3ad>
f011239f:	00 03                	add    %al,(%ebx)
f01123a1:	80 0e 00             	orb    $0x0,(%esi)
f01123a4:	03 90 0e 00 03 a0    	add    -0x5ffcfff2(%eax),%edx
f01123aa:	0e                   	push   %cs
f01123ab:	00 03                	add    %al,(%ebx)
f01123ad:	b0 0e                	mov    $0xe,%al
f01123af:	00 03                	add    %al,(%ebx)
f01123b1:	c0 0e 00             	rorb   $0x0,(%esi)
f01123b4:	03 d0                	add    %eax,%edx
f01123b6:	0e                   	push   %cs
f01123b7:	00 03                	add    %al,(%ebx)
f01123b9:	e0 0e                	loopne f01123c9 <entry_pgtable+0x3c9>
f01123bb:	00 03                	add    %al,(%ebx)
f01123bd:	f0 0e                	lock push %cs
f01123bf:	00 03                	add    %al,(%ebx)
f01123c1:	00 0f                	add    %cl,(%edi)
f01123c3:	00 03                	add    %al,(%ebx)
f01123c5:	10 0f                	adc    %cl,(%edi)
f01123c7:	00 03                	add    %al,(%ebx)
f01123c9:	20 0f                	and    %cl,(%edi)
f01123cb:	00 03                	add    %al,(%ebx)
f01123cd:	30 0f                	xor    %cl,(%edi)
f01123cf:	00 03                	add    %al,(%ebx)
f01123d1:	40                   	inc    %eax
f01123d2:	0f 00 03             	sldt   (%ebx)
f01123d5:	50                   	push   %eax
f01123d6:	0f 00 03             	sldt   (%ebx)
f01123d9:	60                   	pusha  
f01123da:	0f 00 03             	sldt   (%ebx)
f01123dd:	70 0f                	jo     f01123ee <entry_pgtable+0x3ee>
f01123df:	00 03                	add    %al,(%ebx)
f01123e1:	80 0f 00             	orb    $0x0,(%edi)
f01123e4:	03 90 0f 00 03 a0    	add    -0x5ffcfff1(%eax),%edx
f01123ea:	0f 00 03             	sldt   (%ebx)
f01123ed:	b0 0f                	mov    $0xf,%al
f01123ef:	00 03                	add    %al,(%ebx)
f01123f1:	c0 0f 00             	rorb   $0x0,(%edi)
f01123f4:	03 d0                	add    %eax,%edx
f01123f6:	0f 00 03             	sldt   (%ebx)
f01123f9:	e0 0f                	loopne f011240a <entry_pgtable+0x40a>
f01123fb:	00 03                	add    %al,(%ebx)
f01123fd:	f0 0f 00 03          	lock sldt (%ebx)
f0112401:	00 10                	add    %dl,(%eax)
f0112403:	00 03                	add    %al,(%ebx)
f0112405:	10 10                	adc    %dl,(%eax)
f0112407:	00 03                	add    %al,(%ebx)
f0112409:	20 10                	and    %dl,(%eax)
f011240b:	00 03                	add    %al,(%ebx)
f011240d:	30 10                	xor    %dl,(%eax)
f011240f:	00 03                	add    %al,(%ebx)
f0112411:	40                   	inc    %eax
f0112412:	10 00                	adc    %al,(%eax)
f0112414:	03 50 10             	add    0x10(%eax),%edx
f0112417:	00 03                	add    %al,(%ebx)
f0112419:	60                   	pusha  
f011241a:	10 00                	adc    %al,(%eax)
f011241c:	03 70 10             	add    0x10(%eax),%esi
f011241f:	00 03                	add    %al,(%ebx)
f0112421:	80 10 00             	adcb   $0x0,(%eax)
f0112424:	03 90 10 00 03 a0    	add    -0x5ffcfff0(%eax),%edx
f011242a:	10 00                	adc    %al,(%eax)
f011242c:	03 b0 10 00 03 c0    	add    -0x3ffcfff0(%eax),%esi
f0112432:	10 00                	adc    %al,(%eax)
f0112434:	03 d0                	add    %eax,%edx
f0112436:	10 00                	adc    %al,(%eax)
f0112438:	03 e0                	add    %eax,%esp
f011243a:	10 00                	adc    %al,(%eax)
f011243c:	03 f0                	add    %eax,%esi
f011243e:	10 00                	adc    %al,(%eax)
f0112440:	03 00                	add    (%eax),%eax
f0112442:	11 00                	adc    %eax,(%eax)
f0112444:	03 10                	add    (%eax),%edx
f0112446:	11 00                	adc    %eax,(%eax)
f0112448:	03 20                	add    (%eax),%esp
f011244a:	11 00                	adc    %eax,(%eax)
f011244c:	03 30                	add    (%eax),%esi
f011244e:	11 00                	adc    %eax,(%eax)
f0112450:	03 40 11             	add    0x11(%eax),%eax
f0112453:	00 03                	add    %al,(%ebx)
f0112455:	50                   	push   %eax
f0112456:	11 00                	adc    %eax,(%eax)
f0112458:	03 60 11             	add    0x11(%eax),%esp
f011245b:	00 03                	add    %al,(%ebx)
f011245d:	70 11                	jo     f0112470 <entry_pgtable+0x470>
f011245f:	00 03                	add    %al,(%ebx)
f0112461:	80 11 00             	adcb   $0x0,(%ecx)
f0112464:	03 90 11 00 03 a0    	add    -0x5ffcffef(%eax),%edx
f011246a:	11 00                	adc    %eax,(%eax)
f011246c:	03 b0 11 00 03 c0    	add    -0x3ffcffef(%eax),%esi
f0112472:	11 00                	adc    %eax,(%eax)
f0112474:	03 d0                	add    %eax,%edx
f0112476:	11 00                	adc    %eax,(%eax)
f0112478:	03 e0                	add    %eax,%esp
f011247a:	11 00                	adc    %eax,(%eax)
f011247c:	03 f0                	add    %eax,%esi
f011247e:	11 00                	adc    %eax,(%eax)
f0112480:	03 00                	add    (%eax),%eax
f0112482:	12 00                	adc    (%eax),%al
f0112484:	03 10                	add    (%eax),%edx
f0112486:	12 00                	adc    (%eax),%al
f0112488:	03 20                	add    (%eax),%esp
f011248a:	12 00                	adc    (%eax),%al
f011248c:	03 30                	add    (%eax),%esi
f011248e:	12 00                	adc    (%eax),%al
f0112490:	03 40 12             	add    0x12(%eax),%eax
f0112493:	00 03                	add    %al,(%ebx)
f0112495:	50                   	push   %eax
f0112496:	12 00                	adc    (%eax),%al
f0112498:	03 60 12             	add    0x12(%eax),%esp
f011249b:	00 03                	add    %al,(%ebx)
f011249d:	70 12                	jo     f01124b1 <entry_pgtable+0x4b1>
f011249f:	00 03                	add    %al,(%ebx)
f01124a1:	80 12 00             	adcb   $0x0,(%edx)
f01124a4:	03 90 12 00 03 a0    	add    -0x5ffcffee(%eax),%edx
f01124aa:	12 00                	adc    (%eax),%al
f01124ac:	03 b0 12 00 03 c0    	add    -0x3ffcffee(%eax),%esi
f01124b2:	12 00                	adc    (%eax),%al
f01124b4:	03 d0                	add    %eax,%edx
f01124b6:	12 00                	adc    (%eax),%al
f01124b8:	03 e0                	add    %eax,%esp
f01124ba:	12 00                	adc    (%eax),%al
f01124bc:	03 f0                	add    %eax,%esi
f01124be:	12 00                	adc    (%eax),%al
f01124c0:	03 00                	add    (%eax),%eax
f01124c2:	13 00                	adc    (%eax),%eax
f01124c4:	03 10                	add    (%eax),%edx
f01124c6:	13 00                	adc    (%eax),%eax
f01124c8:	03 20                	add    (%eax),%esp
f01124ca:	13 00                	adc    (%eax),%eax
f01124cc:	03 30                	add    (%eax),%esi
f01124ce:	13 00                	adc    (%eax),%eax
f01124d0:	03 40 13             	add    0x13(%eax),%eax
f01124d3:	00 03                	add    %al,(%ebx)
f01124d5:	50                   	push   %eax
f01124d6:	13 00                	adc    (%eax),%eax
f01124d8:	03 60 13             	add    0x13(%eax),%esp
f01124db:	00 03                	add    %al,(%ebx)
f01124dd:	70 13                	jo     f01124f2 <entry_pgtable+0x4f2>
f01124df:	00 03                	add    %al,(%ebx)
f01124e1:	80 13 00             	adcb   $0x0,(%ebx)
f01124e4:	03 90 13 00 03 a0    	add    -0x5ffcffed(%eax),%edx
f01124ea:	13 00                	adc    (%eax),%eax
f01124ec:	03 b0 13 00 03 c0    	add    -0x3ffcffed(%eax),%esi
f01124f2:	13 00                	adc    (%eax),%eax
f01124f4:	03 d0                	add    %eax,%edx
f01124f6:	13 00                	adc    (%eax),%eax
f01124f8:	03 e0                	add    %eax,%esp
f01124fa:	13 00                	adc    (%eax),%eax
f01124fc:	03 f0                	add    %eax,%esi
f01124fe:	13 00                	adc    (%eax),%eax
f0112500:	03 00                	add    (%eax),%eax
f0112502:	14 00                	adc    $0x0,%al
f0112504:	03 10                	add    (%eax),%edx
f0112506:	14 00                	adc    $0x0,%al
f0112508:	03 20                	add    (%eax),%esp
f011250a:	14 00                	adc    $0x0,%al
f011250c:	03 30                	add    (%eax),%esi
f011250e:	14 00                	adc    $0x0,%al
f0112510:	03 40 14             	add    0x14(%eax),%eax
f0112513:	00 03                	add    %al,(%ebx)
f0112515:	50                   	push   %eax
f0112516:	14 00                	adc    $0x0,%al
f0112518:	03 60 14             	add    0x14(%eax),%esp
f011251b:	00 03                	add    %al,(%ebx)
f011251d:	70 14                	jo     f0112533 <entry_pgtable+0x533>
f011251f:	00 03                	add    %al,(%ebx)
f0112521:	80 14 00 03          	adcb   $0x3,(%eax,%eax,1)
f0112525:	90                   	nop
f0112526:	14 00                	adc    $0x0,%al
f0112528:	03 a0 14 00 03 b0    	add    -0x4ffcffec(%eax),%esp
f011252e:	14 00                	adc    $0x0,%al
f0112530:	03 c0                	add    %eax,%eax
f0112532:	14 00                	adc    $0x0,%al
f0112534:	03 d0                	add    %eax,%edx
f0112536:	14 00                	adc    $0x0,%al
f0112538:	03 e0                	add    %eax,%esp
f011253a:	14 00                	adc    $0x0,%al
f011253c:	03 f0                	add    %eax,%esi
f011253e:	14 00                	adc    $0x0,%al
f0112540:	03 00                	add    (%eax),%eax
f0112542:	15 00 03 10 15       	adc    $0x15100300,%eax
f0112547:	00 03                	add    %al,(%ebx)
f0112549:	20 15 00 03 30 15    	and    %dl,0x15300300
f011254f:	00 03                	add    %al,(%ebx)
f0112551:	40                   	inc    %eax
f0112552:	15 00 03 50 15       	adc    $0x15500300,%eax
f0112557:	00 03                	add    %al,(%ebx)
f0112559:	60                   	pusha  
f011255a:	15 00 03 70 15       	adc    $0x15700300,%eax
f011255f:	00 03                	add    %al,(%ebx)
f0112561:	80 15 00 03 90 15 00 	adcb   $0x0,0x15900300
f0112568:	03 a0 15 00 03 b0    	add    -0x4ffcffeb(%eax),%esp
f011256e:	15 00 03 c0 15       	adc    $0x15c00300,%eax
f0112573:	00 03                	add    %al,(%ebx)
f0112575:	d0 15 00 03 e0 15    	rclb   0x15e00300
f011257b:	00 03                	add    %al,(%ebx)
f011257d:	f0 15 00 03 00 16    	lock adc $0x16000300,%eax
f0112583:	00 03                	add    %al,(%ebx)
f0112585:	10 16                	adc    %dl,(%esi)
f0112587:	00 03                	add    %al,(%ebx)
f0112589:	20 16                	and    %dl,(%esi)
f011258b:	00 03                	add    %al,(%ebx)
f011258d:	30 16                	xor    %dl,(%esi)
f011258f:	00 03                	add    %al,(%ebx)
f0112591:	40                   	inc    %eax
f0112592:	16                   	push   %ss
f0112593:	00 03                	add    %al,(%ebx)
f0112595:	50                   	push   %eax
f0112596:	16                   	push   %ss
f0112597:	00 03                	add    %al,(%ebx)
f0112599:	60                   	pusha  
f011259a:	16                   	push   %ss
f011259b:	00 03                	add    %al,(%ebx)
f011259d:	70 16                	jo     f01125b5 <entry_pgtable+0x5b5>
f011259f:	00 03                	add    %al,(%ebx)
f01125a1:	80 16 00             	adcb   $0x0,(%esi)
f01125a4:	03 90 16 00 03 a0    	add    -0x5ffcffea(%eax),%edx
f01125aa:	16                   	push   %ss
f01125ab:	00 03                	add    %al,(%ebx)
f01125ad:	b0 16                	mov    $0x16,%al
f01125af:	00 03                	add    %al,(%ebx)
f01125b1:	c0 16 00             	rclb   $0x0,(%esi)
f01125b4:	03 d0                	add    %eax,%edx
f01125b6:	16                   	push   %ss
f01125b7:	00 03                	add    %al,(%ebx)
f01125b9:	e0 16                	loopne f01125d1 <entry_pgtable+0x5d1>
f01125bb:	00 03                	add    %al,(%ebx)
f01125bd:	f0 16                	lock push %ss
f01125bf:	00 03                	add    %al,(%ebx)
f01125c1:	00 17                	add    %dl,(%edi)
f01125c3:	00 03                	add    %al,(%ebx)
f01125c5:	10 17                	adc    %dl,(%edi)
f01125c7:	00 03                	add    %al,(%ebx)
f01125c9:	20 17                	and    %dl,(%edi)
f01125cb:	00 03                	add    %al,(%ebx)
f01125cd:	30 17                	xor    %dl,(%edi)
f01125cf:	00 03                	add    %al,(%ebx)
f01125d1:	40                   	inc    %eax
f01125d2:	17                   	pop    %ss
f01125d3:	00 03                	add    %al,(%ebx)
f01125d5:	50                   	push   %eax
f01125d6:	17                   	pop    %ss
f01125d7:	00 03                	add    %al,(%ebx)
f01125d9:	60                   	pusha  
f01125da:	17                   	pop    %ss
f01125db:	00 03                	add    %al,(%ebx)
f01125dd:	70 17                	jo     f01125f6 <entry_pgtable+0x5f6>
f01125df:	00 03                	add    %al,(%ebx)
f01125e1:	80 17 00             	adcb   $0x0,(%edi)
f01125e4:	03 90 17 00 03 a0    	add    -0x5ffcffe9(%eax),%edx
f01125ea:	17                   	pop    %ss
f01125eb:	00 03                	add    %al,(%ebx)
f01125ed:	b0 17                	mov    $0x17,%al
f01125ef:	00 03                	add    %al,(%ebx)
f01125f1:	c0 17 00             	rclb   $0x0,(%edi)
f01125f4:	03 d0                	add    %eax,%edx
f01125f6:	17                   	pop    %ss
f01125f7:	00 03                	add    %al,(%ebx)
f01125f9:	e0 17                	loopne f0112612 <entry_pgtable+0x612>
f01125fb:	00 03                	add    %al,(%ebx)
f01125fd:	f0 17                	lock pop %ss
f01125ff:	00 03                	add    %al,(%ebx)
f0112601:	00 18                	add    %bl,(%eax)
f0112603:	00 03                	add    %al,(%ebx)
f0112605:	10 18                	adc    %bl,(%eax)
f0112607:	00 03                	add    %al,(%ebx)
f0112609:	20 18                	and    %bl,(%eax)
f011260b:	00 03                	add    %al,(%ebx)
f011260d:	30 18                	xor    %bl,(%eax)
f011260f:	00 03                	add    %al,(%ebx)
f0112611:	40                   	inc    %eax
f0112612:	18 00                	sbb    %al,(%eax)
f0112614:	03 50 18             	add    0x18(%eax),%edx
f0112617:	00 03                	add    %al,(%ebx)
f0112619:	60                   	pusha  
f011261a:	18 00                	sbb    %al,(%eax)
f011261c:	03 70 18             	add    0x18(%eax),%esi
f011261f:	00 03                	add    %al,(%ebx)
f0112621:	80 18 00             	sbbb   $0x0,(%eax)
f0112624:	03 90 18 00 03 a0    	add    -0x5ffcffe8(%eax),%edx
f011262a:	18 00                	sbb    %al,(%eax)
f011262c:	03 b0 18 00 03 c0    	add    -0x3ffcffe8(%eax),%esi
f0112632:	18 00                	sbb    %al,(%eax)
f0112634:	03 d0                	add    %eax,%edx
f0112636:	18 00                	sbb    %al,(%eax)
f0112638:	03 e0                	add    %eax,%esp
f011263a:	18 00                	sbb    %al,(%eax)
f011263c:	03 f0                	add    %eax,%esi
f011263e:	18 00                	sbb    %al,(%eax)
f0112640:	03 00                	add    (%eax),%eax
f0112642:	19 00                	sbb    %eax,(%eax)
f0112644:	03 10                	add    (%eax),%edx
f0112646:	19 00                	sbb    %eax,(%eax)
f0112648:	03 20                	add    (%eax),%esp
f011264a:	19 00                	sbb    %eax,(%eax)
f011264c:	03 30                	add    (%eax),%esi
f011264e:	19 00                	sbb    %eax,(%eax)
f0112650:	03 40 19             	add    0x19(%eax),%eax
f0112653:	00 03                	add    %al,(%ebx)
f0112655:	50                   	push   %eax
f0112656:	19 00                	sbb    %eax,(%eax)
f0112658:	03 60 19             	add    0x19(%eax),%esp
f011265b:	00 03                	add    %al,(%ebx)
f011265d:	70 19                	jo     f0112678 <entry_pgtable+0x678>
f011265f:	00 03                	add    %al,(%ebx)
f0112661:	80 19 00             	sbbb   $0x0,(%ecx)
f0112664:	03 90 19 00 03 a0    	add    -0x5ffcffe7(%eax),%edx
f011266a:	19 00                	sbb    %eax,(%eax)
f011266c:	03 b0 19 00 03 c0    	add    -0x3ffcffe7(%eax),%esi
f0112672:	19 00                	sbb    %eax,(%eax)
f0112674:	03 d0                	add    %eax,%edx
f0112676:	19 00                	sbb    %eax,(%eax)
f0112678:	03 e0                	add    %eax,%esp
f011267a:	19 00                	sbb    %eax,(%eax)
f011267c:	03 f0                	add    %eax,%esi
f011267e:	19 00                	sbb    %eax,(%eax)
f0112680:	03 00                	add    (%eax),%eax
f0112682:	1a 00                	sbb    (%eax),%al
f0112684:	03 10                	add    (%eax),%edx
f0112686:	1a 00                	sbb    (%eax),%al
f0112688:	03 20                	add    (%eax),%esp
f011268a:	1a 00                	sbb    (%eax),%al
f011268c:	03 30                	add    (%eax),%esi
f011268e:	1a 00                	sbb    (%eax),%al
f0112690:	03 40 1a             	add    0x1a(%eax),%eax
f0112693:	00 03                	add    %al,(%ebx)
f0112695:	50                   	push   %eax
f0112696:	1a 00                	sbb    (%eax),%al
f0112698:	03 60 1a             	add    0x1a(%eax),%esp
f011269b:	00 03                	add    %al,(%ebx)
f011269d:	70 1a                	jo     f01126b9 <entry_pgtable+0x6b9>
f011269f:	00 03                	add    %al,(%ebx)
f01126a1:	80 1a 00             	sbbb   $0x0,(%edx)
f01126a4:	03 90 1a 00 03 a0    	add    -0x5ffcffe6(%eax),%edx
f01126aa:	1a 00                	sbb    (%eax),%al
f01126ac:	03 b0 1a 00 03 c0    	add    -0x3ffcffe6(%eax),%esi
f01126b2:	1a 00                	sbb    (%eax),%al
f01126b4:	03 d0                	add    %eax,%edx
f01126b6:	1a 00                	sbb    (%eax),%al
f01126b8:	03 e0                	add    %eax,%esp
f01126ba:	1a 00                	sbb    (%eax),%al
f01126bc:	03 f0                	add    %eax,%esi
f01126be:	1a 00                	sbb    (%eax),%al
f01126c0:	03 00                	add    (%eax),%eax
f01126c2:	1b 00                	sbb    (%eax),%eax
f01126c4:	03 10                	add    (%eax),%edx
f01126c6:	1b 00                	sbb    (%eax),%eax
f01126c8:	03 20                	add    (%eax),%esp
f01126ca:	1b 00                	sbb    (%eax),%eax
f01126cc:	03 30                	add    (%eax),%esi
f01126ce:	1b 00                	sbb    (%eax),%eax
f01126d0:	03 40 1b             	add    0x1b(%eax),%eax
f01126d3:	00 03                	add    %al,(%ebx)
f01126d5:	50                   	push   %eax
f01126d6:	1b 00                	sbb    (%eax),%eax
f01126d8:	03 60 1b             	add    0x1b(%eax),%esp
f01126db:	00 03                	add    %al,(%ebx)
f01126dd:	70 1b                	jo     f01126fa <entry_pgtable+0x6fa>
f01126df:	00 03                	add    %al,(%ebx)
f01126e1:	80 1b 00             	sbbb   $0x0,(%ebx)
f01126e4:	03 90 1b 00 03 a0    	add    -0x5ffcffe5(%eax),%edx
f01126ea:	1b 00                	sbb    (%eax),%eax
f01126ec:	03 b0 1b 00 03 c0    	add    -0x3ffcffe5(%eax),%esi
f01126f2:	1b 00                	sbb    (%eax),%eax
f01126f4:	03 d0                	add    %eax,%edx
f01126f6:	1b 00                	sbb    (%eax),%eax
f01126f8:	03 e0                	add    %eax,%esp
f01126fa:	1b 00                	sbb    (%eax),%eax
f01126fc:	03 f0                	add    %eax,%esi
f01126fe:	1b 00                	sbb    (%eax),%eax
f0112700:	03 00                	add    (%eax),%eax
f0112702:	1c 00                	sbb    $0x0,%al
f0112704:	03 10                	add    (%eax),%edx
f0112706:	1c 00                	sbb    $0x0,%al
f0112708:	03 20                	add    (%eax),%esp
f011270a:	1c 00                	sbb    $0x0,%al
f011270c:	03 30                	add    (%eax),%esi
f011270e:	1c 00                	sbb    $0x0,%al
f0112710:	03 40 1c             	add    0x1c(%eax),%eax
f0112713:	00 03                	add    %al,(%ebx)
f0112715:	50                   	push   %eax
f0112716:	1c 00                	sbb    $0x0,%al
f0112718:	03 60 1c             	add    0x1c(%eax),%esp
f011271b:	00 03                	add    %al,(%ebx)
f011271d:	70 1c                	jo     f011273b <entry_pgtable+0x73b>
f011271f:	00 03                	add    %al,(%ebx)
f0112721:	80 1c 00 03          	sbbb   $0x3,(%eax,%eax,1)
f0112725:	90                   	nop
f0112726:	1c 00                	sbb    $0x0,%al
f0112728:	03 a0 1c 00 03 b0    	add    -0x4ffcffe4(%eax),%esp
f011272e:	1c 00                	sbb    $0x0,%al
f0112730:	03 c0                	add    %eax,%eax
f0112732:	1c 00                	sbb    $0x0,%al
f0112734:	03 d0                	add    %eax,%edx
f0112736:	1c 00                	sbb    $0x0,%al
f0112738:	03 e0                	add    %eax,%esp
f011273a:	1c 00                	sbb    $0x0,%al
f011273c:	03 f0                	add    %eax,%esi
f011273e:	1c 00                	sbb    $0x0,%al
f0112740:	03 00                	add    (%eax),%eax
f0112742:	1d 00 03 10 1d       	sbb    $0x1d100300,%eax
f0112747:	00 03                	add    %al,(%ebx)
f0112749:	20 1d 00 03 30 1d    	and    %bl,0x1d300300
f011274f:	00 03                	add    %al,(%ebx)
f0112751:	40                   	inc    %eax
f0112752:	1d 00 03 50 1d       	sbb    $0x1d500300,%eax
f0112757:	00 03                	add    %al,(%ebx)
f0112759:	60                   	pusha  
f011275a:	1d 00 03 70 1d       	sbb    $0x1d700300,%eax
f011275f:	00 03                	add    %al,(%ebx)
f0112761:	80 1d 00 03 90 1d 00 	sbbb   $0x0,0x1d900300
f0112768:	03 a0 1d 00 03 b0    	add    -0x4ffcffe3(%eax),%esp
f011276e:	1d 00 03 c0 1d       	sbb    $0x1dc00300,%eax
f0112773:	00 03                	add    %al,(%ebx)
f0112775:	d0 1d 00 03 e0 1d    	rcrb   0x1de00300
f011277b:	00 03                	add    %al,(%ebx)
f011277d:	f0 1d 00 03 00 1e    	lock sbb $0x1e000300,%eax
f0112783:	00 03                	add    %al,(%ebx)
f0112785:	10 1e                	adc    %bl,(%esi)
f0112787:	00 03                	add    %al,(%ebx)
f0112789:	20 1e                	and    %bl,(%esi)
f011278b:	00 03                	add    %al,(%ebx)
f011278d:	30 1e                	xor    %bl,(%esi)
f011278f:	00 03                	add    %al,(%ebx)
f0112791:	40                   	inc    %eax
f0112792:	1e                   	push   %ds
f0112793:	00 03                	add    %al,(%ebx)
f0112795:	50                   	push   %eax
f0112796:	1e                   	push   %ds
f0112797:	00 03                	add    %al,(%ebx)
f0112799:	60                   	pusha  
f011279a:	1e                   	push   %ds
f011279b:	00 03                	add    %al,(%ebx)
f011279d:	70 1e                	jo     f01127bd <entry_pgtable+0x7bd>
f011279f:	00 03                	add    %al,(%ebx)
f01127a1:	80 1e 00             	sbbb   $0x0,(%esi)
f01127a4:	03 90 1e 00 03 a0    	add    -0x5ffcffe2(%eax),%edx
f01127aa:	1e                   	push   %ds
f01127ab:	00 03                	add    %al,(%ebx)
f01127ad:	b0 1e                	mov    $0x1e,%al
f01127af:	00 03                	add    %al,(%ebx)
f01127b1:	c0 1e 00             	rcrb   $0x0,(%esi)
f01127b4:	03 d0                	add    %eax,%edx
f01127b6:	1e                   	push   %ds
f01127b7:	00 03                	add    %al,(%ebx)
f01127b9:	e0 1e                	loopne f01127d9 <entry_pgtable+0x7d9>
f01127bb:	00 03                	add    %al,(%ebx)
f01127bd:	f0 1e                	lock push %ds
f01127bf:	00 03                	add    %al,(%ebx)
f01127c1:	00 1f                	add    %bl,(%edi)
f01127c3:	00 03                	add    %al,(%ebx)
f01127c5:	10 1f                	adc    %bl,(%edi)
f01127c7:	00 03                	add    %al,(%ebx)
f01127c9:	20 1f                	and    %bl,(%edi)
f01127cb:	00 03                	add    %al,(%ebx)
f01127cd:	30 1f                	xor    %bl,(%edi)
f01127cf:	00 03                	add    %al,(%ebx)
f01127d1:	40                   	inc    %eax
f01127d2:	1f                   	pop    %ds
f01127d3:	00 03                	add    %al,(%ebx)
f01127d5:	50                   	push   %eax
f01127d6:	1f                   	pop    %ds
f01127d7:	00 03                	add    %al,(%ebx)
f01127d9:	60                   	pusha  
f01127da:	1f                   	pop    %ds
f01127db:	00 03                	add    %al,(%ebx)
f01127dd:	70 1f                	jo     f01127fe <entry_pgtable+0x7fe>
f01127df:	00 03                	add    %al,(%ebx)
f01127e1:	80 1f 00             	sbbb   $0x0,(%edi)
f01127e4:	03 90 1f 00 03 a0    	add    -0x5ffcffe1(%eax),%edx
f01127ea:	1f                   	pop    %ds
f01127eb:	00 03                	add    %al,(%ebx)
f01127ed:	b0 1f                	mov    $0x1f,%al
f01127ef:	00 03                	add    %al,(%ebx)
f01127f1:	c0 1f 00             	rcrb   $0x0,(%edi)
f01127f4:	03 d0                	add    %eax,%edx
f01127f6:	1f                   	pop    %ds
f01127f7:	00 03                	add    %al,(%ebx)
f01127f9:	e0 1f                	loopne f011281a <entry_pgtable+0x81a>
f01127fb:	00 03                	add    %al,(%ebx)
f01127fd:	f0 1f                	lock pop %ds
f01127ff:	00 03                	add    %al,(%ebx)
f0112801:	00 20                	add    %ah,(%eax)
f0112803:	00 03                	add    %al,(%ebx)
f0112805:	10 20                	adc    %ah,(%eax)
f0112807:	00 03                	add    %al,(%ebx)
f0112809:	20 20                	and    %ah,(%eax)
f011280b:	00 03                	add    %al,(%ebx)
f011280d:	30 20                	xor    %ah,(%eax)
f011280f:	00 03                	add    %al,(%ebx)
f0112811:	40                   	inc    %eax
f0112812:	20 00                	and    %al,(%eax)
f0112814:	03 50 20             	add    0x20(%eax),%edx
f0112817:	00 03                	add    %al,(%ebx)
f0112819:	60                   	pusha  
f011281a:	20 00                	and    %al,(%eax)
f011281c:	03 70 20             	add    0x20(%eax),%esi
f011281f:	00 03                	add    %al,(%ebx)
f0112821:	80 20 00             	andb   $0x0,(%eax)
f0112824:	03 90 20 00 03 a0    	add    -0x5ffcffe0(%eax),%edx
f011282a:	20 00                	and    %al,(%eax)
f011282c:	03 b0 20 00 03 c0    	add    -0x3ffcffe0(%eax),%esi
f0112832:	20 00                	and    %al,(%eax)
f0112834:	03 d0                	add    %eax,%edx
f0112836:	20 00                	and    %al,(%eax)
f0112838:	03 e0                	add    %eax,%esp
f011283a:	20 00                	and    %al,(%eax)
f011283c:	03 f0                	add    %eax,%esi
f011283e:	20 00                	and    %al,(%eax)
f0112840:	03 00                	add    (%eax),%eax
f0112842:	21 00                	and    %eax,(%eax)
f0112844:	03 10                	add    (%eax),%edx
f0112846:	21 00                	and    %eax,(%eax)
f0112848:	03 20                	add    (%eax),%esp
f011284a:	21 00                	and    %eax,(%eax)
f011284c:	03 30                	add    (%eax),%esi
f011284e:	21 00                	and    %eax,(%eax)
f0112850:	03 40 21             	add    0x21(%eax),%eax
f0112853:	00 03                	add    %al,(%ebx)
f0112855:	50                   	push   %eax
f0112856:	21 00                	and    %eax,(%eax)
f0112858:	03 60 21             	add    0x21(%eax),%esp
f011285b:	00 03                	add    %al,(%ebx)
f011285d:	70 21                	jo     f0112880 <entry_pgtable+0x880>
f011285f:	00 03                	add    %al,(%ebx)
f0112861:	80 21 00             	andb   $0x0,(%ecx)
f0112864:	03 90 21 00 03 a0    	add    -0x5ffcffdf(%eax),%edx
f011286a:	21 00                	and    %eax,(%eax)
f011286c:	03 b0 21 00 03 c0    	add    -0x3ffcffdf(%eax),%esi
f0112872:	21 00                	and    %eax,(%eax)
f0112874:	03 d0                	add    %eax,%edx
f0112876:	21 00                	and    %eax,(%eax)
f0112878:	03 e0                	add    %eax,%esp
f011287a:	21 00                	and    %eax,(%eax)
f011287c:	03 f0                	add    %eax,%esi
f011287e:	21 00                	and    %eax,(%eax)
f0112880:	03 00                	add    (%eax),%eax
f0112882:	22 00                	and    (%eax),%al
f0112884:	03 10                	add    (%eax),%edx
f0112886:	22 00                	and    (%eax),%al
f0112888:	03 20                	add    (%eax),%esp
f011288a:	22 00                	and    (%eax),%al
f011288c:	03 30                	add    (%eax),%esi
f011288e:	22 00                	and    (%eax),%al
f0112890:	03 40 22             	add    0x22(%eax),%eax
f0112893:	00 03                	add    %al,(%ebx)
f0112895:	50                   	push   %eax
f0112896:	22 00                	and    (%eax),%al
f0112898:	03 60 22             	add    0x22(%eax),%esp
f011289b:	00 03                	add    %al,(%ebx)
f011289d:	70 22                	jo     f01128c1 <entry_pgtable+0x8c1>
f011289f:	00 03                	add    %al,(%ebx)
f01128a1:	80 22 00             	andb   $0x0,(%edx)
f01128a4:	03 90 22 00 03 a0    	add    -0x5ffcffde(%eax),%edx
f01128aa:	22 00                	and    (%eax),%al
f01128ac:	03 b0 22 00 03 c0    	add    -0x3ffcffde(%eax),%esi
f01128b2:	22 00                	and    (%eax),%al
f01128b4:	03 d0                	add    %eax,%edx
f01128b6:	22 00                	and    (%eax),%al
f01128b8:	03 e0                	add    %eax,%esp
f01128ba:	22 00                	and    (%eax),%al
f01128bc:	03 f0                	add    %eax,%esi
f01128be:	22 00                	and    (%eax),%al
f01128c0:	03 00                	add    (%eax),%eax
f01128c2:	23 00                	and    (%eax),%eax
f01128c4:	03 10                	add    (%eax),%edx
f01128c6:	23 00                	and    (%eax),%eax
f01128c8:	03 20                	add    (%eax),%esp
f01128ca:	23 00                	and    (%eax),%eax
f01128cc:	03 30                	add    (%eax),%esi
f01128ce:	23 00                	and    (%eax),%eax
f01128d0:	03 40 23             	add    0x23(%eax),%eax
f01128d3:	00 03                	add    %al,(%ebx)
f01128d5:	50                   	push   %eax
f01128d6:	23 00                	and    (%eax),%eax
f01128d8:	03 60 23             	add    0x23(%eax),%esp
f01128db:	00 03                	add    %al,(%ebx)
f01128dd:	70 23                	jo     f0112902 <entry_pgtable+0x902>
f01128df:	00 03                	add    %al,(%ebx)
f01128e1:	80 23 00             	andb   $0x0,(%ebx)
f01128e4:	03 90 23 00 03 a0    	add    -0x5ffcffdd(%eax),%edx
f01128ea:	23 00                	and    (%eax),%eax
f01128ec:	03 b0 23 00 03 c0    	add    -0x3ffcffdd(%eax),%esi
f01128f2:	23 00                	and    (%eax),%eax
f01128f4:	03 d0                	add    %eax,%edx
f01128f6:	23 00                	and    (%eax),%eax
f01128f8:	03 e0                	add    %eax,%esp
f01128fa:	23 00                	and    (%eax),%eax
f01128fc:	03 f0                	add    %eax,%esi
f01128fe:	23 00                	and    (%eax),%eax
f0112900:	03 00                	add    (%eax),%eax
f0112902:	24 00                	and    $0x0,%al
f0112904:	03 10                	add    (%eax),%edx
f0112906:	24 00                	and    $0x0,%al
f0112908:	03 20                	add    (%eax),%esp
f011290a:	24 00                	and    $0x0,%al
f011290c:	03 30                	add    (%eax),%esi
f011290e:	24 00                	and    $0x0,%al
f0112910:	03 40 24             	add    0x24(%eax),%eax
f0112913:	00 03                	add    %al,(%ebx)
f0112915:	50                   	push   %eax
f0112916:	24 00                	and    $0x0,%al
f0112918:	03 60 24             	add    0x24(%eax),%esp
f011291b:	00 03                	add    %al,(%ebx)
f011291d:	70 24                	jo     f0112943 <entry_pgtable+0x943>
f011291f:	00 03                	add    %al,(%ebx)
f0112921:	80 24 00 03          	andb   $0x3,(%eax,%eax,1)
f0112925:	90                   	nop
f0112926:	24 00                	and    $0x0,%al
f0112928:	03 a0 24 00 03 b0    	add    -0x4ffcffdc(%eax),%esp
f011292e:	24 00                	and    $0x0,%al
f0112930:	03 c0                	add    %eax,%eax
f0112932:	24 00                	and    $0x0,%al
f0112934:	03 d0                	add    %eax,%edx
f0112936:	24 00                	and    $0x0,%al
f0112938:	03 e0                	add    %eax,%esp
f011293a:	24 00                	and    $0x0,%al
f011293c:	03 f0                	add    %eax,%esi
f011293e:	24 00                	and    $0x0,%al
f0112940:	03 00                	add    (%eax),%eax
f0112942:	25 00 03 10 25       	and    $0x25100300,%eax
f0112947:	00 03                	add    %al,(%ebx)
f0112949:	20 25 00 03 30 25    	and    %ah,0x25300300
f011294f:	00 03                	add    %al,(%ebx)
f0112951:	40                   	inc    %eax
f0112952:	25 00 03 50 25       	and    $0x25500300,%eax
f0112957:	00 03                	add    %al,(%ebx)
f0112959:	60                   	pusha  
f011295a:	25 00 03 70 25       	and    $0x25700300,%eax
f011295f:	00 03                	add    %al,(%ebx)
f0112961:	80 25 00 03 90 25 00 	andb   $0x0,0x25900300
f0112968:	03 a0 25 00 03 b0    	add    -0x4ffcffdb(%eax),%esp
f011296e:	25 00 03 c0 25       	and    $0x25c00300,%eax
f0112973:	00 03                	add    %al,(%ebx)
f0112975:	d0 25 00 03 e0 25    	shlb   0x25e00300
f011297b:	00 03                	add    %al,(%ebx)
f011297d:	f0 25 00 03 00 26    	lock and $0x26000300,%eax
f0112983:	00 03                	add    %al,(%ebx)
f0112985:	10 26                	adc    %ah,(%esi)
f0112987:	00 03                	add    %al,(%ebx)
f0112989:	20 26                	and    %ah,(%esi)
f011298b:	00 03                	add    %al,(%ebx)
f011298d:	30 26                	xor    %ah,(%esi)
f011298f:	00 03                	add    %al,(%ebx)
f0112991:	40                   	inc    %eax
f0112992:	26 00 03             	add    %al,%es:(%ebx)
f0112995:	50                   	push   %eax
f0112996:	26 00 03             	add    %al,%es:(%ebx)
f0112999:	60                   	pusha  
f011299a:	26 00 03             	add    %al,%es:(%ebx)
f011299d:	70 26                	jo     f01129c5 <entry_pgtable+0x9c5>
f011299f:	00 03                	add    %al,(%ebx)
f01129a1:	80 26 00             	andb   $0x0,(%esi)
f01129a4:	03 90 26 00 03 a0    	add    -0x5ffcffda(%eax),%edx
f01129aa:	26 00 03             	add    %al,%es:(%ebx)
f01129ad:	b0 26                	mov    $0x26,%al
f01129af:	00 03                	add    %al,(%ebx)
f01129b1:	c0 26 00             	shlb   $0x0,(%esi)
f01129b4:	03 d0                	add    %eax,%edx
f01129b6:	26 00 03             	add    %al,%es:(%ebx)
f01129b9:	e0 26                	loopne f01129e1 <entry_pgtable+0x9e1>
f01129bb:	00 03                	add    %al,(%ebx)
f01129bd:	f0 26 00 03          	lock add %al,%es:(%ebx)
f01129c1:	00 27                	add    %ah,(%edi)
f01129c3:	00 03                	add    %al,(%ebx)
f01129c5:	10 27                	adc    %ah,(%edi)
f01129c7:	00 03                	add    %al,(%ebx)
f01129c9:	20 27                	and    %ah,(%edi)
f01129cb:	00 03                	add    %al,(%ebx)
f01129cd:	30 27                	xor    %ah,(%edi)
f01129cf:	00 03                	add    %al,(%ebx)
f01129d1:	40                   	inc    %eax
f01129d2:	27                   	daa    
f01129d3:	00 03                	add    %al,(%ebx)
f01129d5:	50                   	push   %eax
f01129d6:	27                   	daa    
f01129d7:	00 03                	add    %al,(%ebx)
f01129d9:	60                   	pusha  
f01129da:	27                   	daa    
f01129db:	00 03                	add    %al,(%ebx)
f01129dd:	70 27                	jo     f0112a06 <entry_pgtable+0xa06>
f01129df:	00 03                	add    %al,(%ebx)
f01129e1:	80 27 00             	andb   $0x0,(%edi)
f01129e4:	03 90 27 00 03 a0    	add    -0x5ffcffd9(%eax),%edx
f01129ea:	27                   	daa    
f01129eb:	00 03                	add    %al,(%ebx)
f01129ed:	b0 27                	mov    $0x27,%al
f01129ef:	00 03                	add    %al,(%ebx)
f01129f1:	c0 27 00             	shlb   $0x0,(%edi)
f01129f4:	03 d0                	add    %eax,%edx
f01129f6:	27                   	daa    
f01129f7:	00 03                	add    %al,(%ebx)
f01129f9:	e0 27                	loopne f0112a22 <entry_pgtable+0xa22>
f01129fb:	00 03                	add    %al,(%ebx)
f01129fd:	f0 27                	lock daa 
f01129ff:	00 03                	add    %al,(%ebx)
f0112a01:	00 28                	add    %ch,(%eax)
f0112a03:	00 03                	add    %al,(%ebx)
f0112a05:	10 28                	adc    %ch,(%eax)
f0112a07:	00 03                	add    %al,(%ebx)
f0112a09:	20 28                	and    %ch,(%eax)
f0112a0b:	00 03                	add    %al,(%ebx)
f0112a0d:	30 28                	xor    %ch,(%eax)
f0112a0f:	00 03                	add    %al,(%ebx)
f0112a11:	40                   	inc    %eax
f0112a12:	28 00                	sub    %al,(%eax)
f0112a14:	03 50 28             	add    0x28(%eax),%edx
f0112a17:	00 03                	add    %al,(%ebx)
f0112a19:	60                   	pusha  
f0112a1a:	28 00                	sub    %al,(%eax)
f0112a1c:	03 70 28             	add    0x28(%eax),%esi
f0112a1f:	00 03                	add    %al,(%ebx)
f0112a21:	80 28 00             	subb   $0x0,(%eax)
f0112a24:	03 90 28 00 03 a0    	add    -0x5ffcffd8(%eax),%edx
f0112a2a:	28 00                	sub    %al,(%eax)
f0112a2c:	03 b0 28 00 03 c0    	add    -0x3ffcffd8(%eax),%esi
f0112a32:	28 00                	sub    %al,(%eax)
f0112a34:	03 d0                	add    %eax,%edx
f0112a36:	28 00                	sub    %al,(%eax)
f0112a38:	03 e0                	add    %eax,%esp
f0112a3a:	28 00                	sub    %al,(%eax)
f0112a3c:	03 f0                	add    %eax,%esi
f0112a3e:	28 00                	sub    %al,(%eax)
f0112a40:	03 00                	add    (%eax),%eax
f0112a42:	29 00                	sub    %eax,(%eax)
f0112a44:	03 10                	add    (%eax),%edx
f0112a46:	29 00                	sub    %eax,(%eax)
f0112a48:	03 20                	add    (%eax),%esp
f0112a4a:	29 00                	sub    %eax,(%eax)
f0112a4c:	03 30                	add    (%eax),%esi
f0112a4e:	29 00                	sub    %eax,(%eax)
f0112a50:	03 40 29             	add    0x29(%eax),%eax
f0112a53:	00 03                	add    %al,(%ebx)
f0112a55:	50                   	push   %eax
f0112a56:	29 00                	sub    %eax,(%eax)
f0112a58:	03 60 29             	add    0x29(%eax),%esp
f0112a5b:	00 03                	add    %al,(%ebx)
f0112a5d:	70 29                	jo     f0112a88 <entry_pgtable+0xa88>
f0112a5f:	00 03                	add    %al,(%ebx)
f0112a61:	80 29 00             	subb   $0x0,(%ecx)
f0112a64:	03 90 29 00 03 a0    	add    -0x5ffcffd7(%eax),%edx
f0112a6a:	29 00                	sub    %eax,(%eax)
f0112a6c:	03 b0 29 00 03 c0    	add    -0x3ffcffd7(%eax),%esi
f0112a72:	29 00                	sub    %eax,(%eax)
f0112a74:	03 d0                	add    %eax,%edx
f0112a76:	29 00                	sub    %eax,(%eax)
f0112a78:	03 e0                	add    %eax,%esp
f0112a7a:	29 00                	sub    %eax,(%eax)
f0112a7c:	03 f0                	add    %eax,%esi
f0112a7e:	29 00                	sub    %eax,(%eax)
f0112a80:	03 00                	add    (%eax),%eax
f0112a82:	2a 00                	sub    (%eax),%al
f0112a84:	03 10                	add    (%eax),%edx
f0112a86:	2a 00                	sub    (%eax),%al
f0112a88:	03 20                	add    (%eax),%esp
f0112a8a:	2a 00                	sub    (%eax),%al
f0112a8c:	03 30                	add    (%eax),%esi
f0112a8e:	2a 00                	sub    (%eax),%al
f0112a90:	03 40 2a             	add    0x2a(%eax),%eax
f0112a93:	00 03                	add    %al,(%ebx)
f0112a95:	50                   	push   %eax
f0112a96:	2a 00                	sub    (%eax),%al
f0112a98:	03 60 2a             	add    0x2a(%eax),%esp
f0112a9b:	00 03                	add    %al,(%ebx)
f0112a9d:	70 2a                	jo     f0112ac9 <entry_pgtable+0xac9>
f0112a9f:	00 03                	add    %al,(%ebx)
f0112aa1:	80 2a 00             	subb   $0x0,(%edx)
f0112aa4:	03 90 2a 00 03 a0    	add    -0x5ffcffd6(%eax),%edx
f0112aaa:	2a 00                	sub    (%eax),%al
f0112aac:	03 b0 2a 00 03 c0    	add    -0x3ffcffd6(%eax),%esi
f0112ab2:	2a 00                	sub    (%eax),%al
f0112ab4:	03 d0                	add    %eax,%edx
f0112ab6:	2a 00                	sub    (%eax),%al
f0112ab8:	03 e0                	add    %eax,%esp
f0112aba:	2a 00                	sub    (%eax),%al
f0112abc:	03 f0                	add    %eax,%esi
f0112abe:	2a 00                	sub    (%eax),%al
f0112ac0:	03 00                	add    (%eax),%eax
f0112ac2:	2b 00                	sub    (%eax),%eax
f0112ac4:	03 10                	add    (%eax),%edx
f0112ac6:	2b 00                	sub    (%eax),%eax
f0112ac8:	03 20                	add    (%eax),%esp
f0112aca:	2b 00                	sub    (%eax),%eax
f0112acc:	03 30                	add    (%eax),%esi
f0112ace:	2b 00                	sub    (%eax),%eax
f0112ad0:	03 40 2b             	add    0x2b(%eax),%eax
f0112ad3:	00 03                	add    %al,(%ebx)
f0112ad5:	50                   	push   %eax
f0112ad6:	2b 00                	sub    (%eax),%eax
f0112ad8:	03 60 2b             	add    0x2b(%eax),%esp
f0112adb:	00 03                	add    %al,(%ebx)
f0112add:	70 2b                	jo     f0112b0a <entry_pgtable+0xb0a>
f0112adf:	00 03                	add    %al,(%ebx)
f0112ae1:	80 2b 00             	subb   $0x0,(%ebx)
f0112ae4:	03 90 2b 00 03 a0    	add    -0x5ffcffd5(%eax),%edx
f0112aea:	2b 00                	sub    (%eax),%eax
f0112aec:	03 b0 2b 00 03 c0    	add    -0x3ffcffd5(%eax),%esi
f0112af2:	2b 00                	sub    (%eax),%eax
f0112af4:	03 d0                	add    %eax,%edx
f0112af6:	2b 00                	sub    (%eax),%eax
f0112af8:	03 e0                	add    %eax,%esp
f0112afa:	2b 00                	sub    (%eax),%eax
f0112afc:	03 f0                	add    %eax,%esi
f0112afe:	2b 00                	sub    (%eax),%eax
f0112b00:	03 00                	add    (%eax),%eax
f0112b02:	2c 00                	sub    $0x0,%al
f0112b04:	03 10                	add    (%eax),%edx
f0112b06:	2c 00                	sub    $0x0,%al
f0112b08:	03 20                	add    (%eax),%esp
f0112b0a:	2c 00                	sub    $0x0,%al
f0112b0c:	03 30                	add    (%eax),%esi
f0112b0e:	2c 00                	sub    $0x0,%al
f0112b10:	03 40 2c             	add    0x2c(%eax),%eax
f0112b13:	00 03                	add    %al,(%ebx)
f0112b15:	50                   	push   %eax
f0112b16:	2c 00                	sub    $0x0,%al
f0112b18:	03 60 2c             	add    0x2c(%eax),%esp
f0112b1b:	00 03                	add    %al,(%ebx)
f0112b1d:	70 2c                	jo     f0112b4b <entry_pgtable+0xb4b>
f0112b1f:	00 03                	add    %al,(%ebx)
f0112b21:	80 2c 00 03          	subb   $0x3,(%eax,%eax,1)
f0112b25:	90                   	nop
f0112b26:	2c 00                	sub    $0x0,%al
f0112b28:	03 a0 2c 00 03 b0    	add    -0x4ffcffd4(%eax),%esp
f0112b2e:	2c 00                	sub    $0x0,%al
f0112b30:	03 c0                	add    %eax,%eax
f0112b32:	2c 00                	sub    $0x0,%al
f0112b34:	03 d0                	add    %eax,%edx
f0112b36:	2c 00                	sub    $0x0,%al
f0112b38:	03 e0                	add    %eax,%esp
f0112b3a:	2c 00                	sub    $0x0,%al
f0112b3c:	03 f0                	add    %eax,%esi
f0112b3e:	2c 00                	sub    $0x0,%al
f0112b40:	03 00                	add    (%eax),%eax
f0112b42:	2d 00 03 10 2d       	sub    $0x2d100300,%eax
f0112b47:	00 03                	add    %al,(%ebx)
f0112b49:	20 2d 00 03 30 2d    	and    %ch,0x2d300300
f0112b4f:	00 03                	add    %al,(%ebx)
f0112b51:	40                   	inc    %eax
f0112b52:	2d 00 03 50 2d       	sub    $0x2d500300,%eax
f0112b57:	00 03                	add    %al,(%ebx)
f0112b59:	60                   	pusha  
f0112b5a:	2d 00 03 70 2d       	sub    $0x2d700300,%eax
f0112b5f:	00 03                	add    %al,(%ebx)
f0112b61:	80 2d 00 03 90 2d 00 	subb   $0x0,0x2d900300
f0112b68:	03 a0 2d 00 03 b0    	add    -0x4ffcffd3(%eax),%esp
f0112b6e:	2d 00 03 c0 2d       	sub    $0x2dc00300,%eax
f0112b73:	00 03                	add    %al,(%ebx)
f0112b75:	d0 2d 00 03 e0 2d    	shrb   0x2de00300
f0112b7b:	00 03                	add    %al,(%ebx)
f0112b7d:	f0 2d 00 03 00 2e    	lock sub $0x2e000300,%eax
f0112b83:	00 03                	add    %al,(%ebx)
f0112b85:	10 2e                	adc    %ch,(%esi)
f0112b87:	00 03                	add    %al,(%ebx)
f0112b89:	20 2e                	and    %ch,(%esi)
f0112b8b:	00 03                	add    %al,(%ebx)
f0112b8d:	30 2e                	xor    %ch,(%esi)
f0112b8f:	00 03                	add    %al,(%ebx)
f0112b91:	40                   	inc    %eax
f0112b92:	2e 00 03             	add    %al,%cs:(%ebx)
f0112b95:	50                   	push   %eax
f0112b96:	2e 00 03             	add    %al,%cs:(%ebx)
f0112b99:	60                   	pusha  
f0112b9a:	2e 00 03             	add    %al,%cs:(%ebx)
f0112b9d:	70 2e                	jo     f0112bcd <entry_pgtable+0xbcd>
f0112b9f:	00 03                	add    %al,(%ebx)
f0112ba1:	80 2e 00             	subb   $0x0,(%esi)
f0112ba4:	03 90 2e 00 03 a0    	add    -0x5ffcffd2(%eax),%edx
f0112baa:	2e 00 03             	add    %al,%cs:(%ebx)
f0112bad:	b0 2e                	mov    $0x2e,%al
f0112baf:	00 03                	add    %al,(%ebx)
f0112bb1:	c0 2e 00             	shrb   $0x0,(%esi)
f0112bb4:	03 d0                	add    %eax,%edx
f0112bb6:	2e 00 03             	add    %al,%cs:(%ebx)
f0112bb9:	e0 2e                	loopne f0112be9 <entry_pgtable+0xbe9>
f0112bbb:	00 03                	add    %al,(%ebx)
f0112bbd:	f0 2e 00 03          	lock add %al,%cs:(%ebx)
f0112bc1:	00 2f                	add    %ch,(%edi)
f0112bc3:	00 03                	add    %al,(%ebx)
f0112bc5:	10 2f                	adc    %ch,(%edi)
f0112bc7:	00 03                	add    %al,(%ebx)
f0112bc9:	20 2f                	and    %ch,(%edi)
f0112bcb:	00 03                	add    %al,(%ebx)
f0112bcd:	30 2f                	xor    %ch,(%edi)
f0112bcf:	00 03                	add    %al,(%ebx)
f0112bd1:	40                   	inc    %eax
f0112bd2:	2f                   	das    
f0112bd3:	00 03                	add    %al,(%ebx)
f0112bd5:	50                   	push   %eax
f0112bd6:	2f                   	das    
f0112bd7:	00 03                	add    %al,(%ebx)
f0112bd9:	60                   	pusha  
f0112bda:	2f                   	das    
f0112bdb:	00 03                	add    %al,(%ebx)
f0112bdd:	70 2f                	jo     f0112c0e <entry_pgtable+0xc0e>
f0112bdf:	00 03                	add    %al,(%ebx)
f0112be1:	80 2f 00             	subb   $0x0,(%edi)
f0112be4:	03 90 2f 00 03 a0    	add    -0x5ffcffd1(%eax),%edx
f0112bea:	2f                   	das    
f0112beb:	00 03                	add    %al,(%ebx)
f0112bed:	b0 2f                	mov    $0x2f,%al
f0112bef:	00 03                	add    %al,(%ebx)
f0112bf1:	c0 2f 00             	shrb   $0x0,(%edi)
f0112bf4:	03 d0                	add    %eax,%edx
f0112bf6:	2f                   	das    
f0112bf7:	00 03                	add    %al,(%ebx)
f0112bf9:	e0 2f                	loopne f0112c2a <entry_pgtable+0xc2a>
f0112bfb:	00 03                	add    %al,(%ebx)
f0112bfd:	f0 2f                	lock das 
f0112bff:	00 03                	add    %al,(%ebx)
f0112c01:	00 30                	add    %dh,(%eax)
f0112c03:	00 03                	add    %al,(%ebx)
f0112c05:	10 30                	adc    %dh,(%eax)
f0112c07:	00 03                	add    %al,(%ebx)
f0112c09:	20 30                	and    %dh,(%eax)
f0112c0b:	00 03                	add    %al,(%ebx)
f0112c0d:	30 30                	xor    %dh,(%eax)
f0112c0f:	00 03                	add    %al,(%ebx)
f0112c11:	40                   	inc    %eax
f0112c12:	30 00                	xor    %al,(%eax)
f0112c14:	03 50 30             	add    0x30(%eax),%edx
f0112c17:	00 03                	add    %al,(%ebx)
f0112c19:	60                   	pusha  
f0112c1a:	30 00                	xor    %al,(%eax)
f0112c1c:	03 70 30             	add    0x30(%eax),%esi
f0112c1f:	00 03                	add    %al,(%ebx)
f0112c21:	80 30 00             	xorb   $0x0,(%eax)
f0112c24:	03 90 30 00 03 a0    	add    -0x5ffcffd0(%eax),%edx
f0112c2a:	30 00                	xor    %al,(%eax)
f0112c2c:	03 b0 30 00 03 c0    	add    -0x3ffcffd0(%eax),%esi
f0112c32:	30 00                	xor    %al,(%eax)
f0112c34:	03 d0                	add    %eax,%edx
f0112c36:	30 00                	xor    %al,(%eax)
f0112c38:	03 e0                	add    %eax,%esp
f0112c3a:	30 00                	xor    %al,(%eax)
f0112c3c:	03 f0                	add    %eax,%esi
f0112c3e:	30 00                	xor    %al,(%eax)
f0112c40:	03 00                	add    (%eax),%eax
f0112c42:	31 00                	xor    %eax,(%eax)
f0112c44:	03 10                	add    (%eax),%edx
f0112c46:	31 00                	xor    %eax,(%eax)
f0112c48:	03 20                	add    (%eax),%esp
f0112c4a:	31 00                	xor    %eax,(%eax)
f0112c4c:	03 30                	add    (%eax),%esi
f0112c4e:	31 00                	xor    %eax,(%eax)
f0112c50:	03 40 31             	add    0x31(%eax),%eax
f0112c53:	00 03                	add    %al,(%ebx)
f0112c55:	50                   	push   %eax
f0112c56:	31 00                	xor    %eax,(%eax)
f0112c58:	03 60 31             	add    0x31(%eax),%esp
f0112c5b:	00 03                	add    %al,(%ebx)
f0112c5d:	70 31                	jo     f0112c90 <entry_pgtable+0xc90>
f0112c5f:	00 03                	add    %al,(%ebx)
f0112c61:	80 31 00             	xorb   $0x0,(%ecx)
f0112c64:	03 90 31 00 03 a0    	add    -0x5ffcffcf(%eax),%edx
f0112c6a:	31 00                	xor    %eax,(%eax)
f0112c6c:	03 b0 31 00 03 c0    	add    -0x3ffcffcf(%eax),%esi
f0112c72:	31 00                	xor    %eax,(%eax)
f0112c74:	03 d0                	add    %eax,%edx
f0112c76:	31 00                	xor    %eax,(%eax)
f0112c78:	03 e0                	add    %eax,%esp
f0112c7a:	31 00                	xor    %eax,(%eax)
f0112c7c:	03 f0                	add    %eax,%esi
f0112c7e:	31 00                	xor    %eax,(%eax)
f0112c80:	03 00                	add    (%eax),%eax
f0112c82:	32 00                	xor    (%eax),%al
f0112c84:	03 10                	add    (%eax),%edx
f0112c86:	32 00                	xor    (%eax),%al
f0112c88:	03 20                	add    (%eax),%esp
f0112c8a:	32 00                	xor    (%eax),%al
f0112c8c:	03 30                	add    (%eax),%esi
f0112c8e:	32 00                	xor    (%eax),%al
f0112c90:	03 40 32             	add    0x32(%eax),%eax
f0112c93:	00 03                	add    %al,(%ebx)
f0112c95:	50                   	push   %eax
f0112c96:	32 00                	xor    (%eax),%al
f0112c98:	03 60 32             	add    0x32(%eax),%esp
f0112c9b:	00 03                	add    %al,(%ebx)
f0112c9d:	70 32                	jo     f0112cd1 <entry_pgtable+0xcd1>
f0112c9f:	00 03                	add    %al,(%ebx)
f0112ca1:	80 32 00             	xorb   $0x0,(%edx)
f0112ca4:	03 90 32 00 03 a0    	add    -0x5ffcffce(%eax),%edx
f0112caa:	32 00                	xor    (%eax),%al
f0112cac:	03 b0 32 00 03 c0    	add    -0x3ffcffce(%eax),%esi
f0112cb2:	32 00                	xor    (%eax),%al
f0112cb4:	03 d0                	add    %eax,%edx
f0112cb6:	32 00                	xor    (%eax),%al
f0112cb8:	03 e0                	add    %eax,%esp
f0112cba:	32 00                	xor    (%eax),%al
f0112cbc:	03 f0                	add    %eax,%esi
f0112cbe:	32 00                	xor    (%eax),%al
f0112cc0:	03 00                	add    (%eax),%eax
f0112cc2:	33 00                	xor    (%eax),%eax
f0112cc4:	03 10                	add    (%eax),%edx
f0112cc6:	33 00                	xor    (%eax),%eax
f0112cc8:	03 20                	add    (%eax),%esp
f0112cca:	33 00                	xor    (%eax),%eax
f0112ccc:	03 30                	add    (%eax),%esi
f0112cce:	33 00                	xor    (%eax),%eax
f0112cd0:	03 40 33             	add    0x33(%eax),%eax
f0112cd3:	00 03                	add    %al,(%ebx)
f0112cd5:	50                   	push   %eax
f0112cd6:	33 00                	xor    (%eax),%eax
f0112cd8:	03 60 33             	add    0x33(%eax),%esp
f0112cdb:	00 03                	add    %al,(%ebx)
f0112cdd:	70 33                	jo     f0112d12 <entry_pgtable+0xd12>
f0112cdf:	00 03                	add    %al,(%ebx)
f0112ce1:	80 33 00             	xorb   $0x0,(%ebx)
f0112ce4:	03 90 33 00 03 a0    	add    -0x5ffcffcd(%eax),%edx
f0112cea:	33 00                	xor    (%eax),%eax
f0112cec:	03 b0 33 00 03 c0    	add    -0x3ffcffcd(%eax),%esi
f0112cf2:	33 00                	xor    (%eax),%eax
f0112cf4:	03 d0                	add    %eax,%edx
f0112cf6:	33 00                	xor    (%eax),%eax
f0112cf8:	03 e0                	add    %eax,%esp
f0112cfa:	33 00                	xor    (%eax),%eax
f0112cfc:	03 f0                	add    %eax,%esi
f0112cfe:	33 00                	xor    (%eax),%eax
f0112d00:	03 00                	add    (%eax),%eax
f0112d02:	34 00                	xor    $0x0,%al
f0112d04:	03 10                	add    (%eax),%edx
f0112d06:	34 00                	xor    $0x0,%al
f0112d08:	03 20                	add    (%eax),%esp
f0112d0a:	34 00                	xor    $0x0,%al
f0112d0c:	03 30                	add    (%eax),%esi
f0112d0e:	34 00                	xor    $0x0,%al
f0112d10:	03 40 34             	add    0x34(%eax),%eax
f0112d13:	00 03                	add    %al,(%ebx)
f0112d15:	50                   	push   %eax
f0112d16:	34 00                	xor    $0x0,%al
f0112d18:	03 60 34             	add    0x34(%eax),%esp
f0112d1b:	00 03                	add    %al,(%ebx)
f0112d1d:	70 34                	jo     f0112d53 <entry_pgtable+0xd53>
f0112d1f:	00 03                	add    %al,(%ebx)
f0112d21:	80 34 00 03          	xorb   $0x3,(%eax,%eax,1)
f0112d25:	90                   	nop
f0112d26:	34 00                	xor    $0x0,%al
f0112d28:	03 a0 34 00 03 b0    	add    -0x4ffcffcc(%eax),%esp
f0112d2e:	34 00                	xor    $0x0,%al
f0112d30:	03 c0                	add    %eax,%eax
f0112d32:	34 00                	xor    $0x0,%al
f0112d34:	03 d0                	add    %eax,%edx
f0112d36:	34 00                	xor    $0x0,%al
f0112d38:	03 e0                	add    %eax,%esp
f0112d3a:	34 00                	xor    $0x0,%al
f0112d3c:	03 f0                	add    %eax,%esi
f0112d3e:	34 00                	xor    $0x0,%al
f0112d40:	03 00                	add    (%eax),%eax
f0112d42:	35 00 03 10 35       	xor    $0x35100300,%eax
f0112d47:	00 03                	add    %al,(%ebx)
f0112d49:	20 35 00 03 30 35    	and    %dh,0x35300300
f0112d4f:	00 03                	add    %al,(%ebx)
f0112d51:	40                   	inc    %eax
f0112d52:	35 00 03 50 35       	xor    $0x35500300,%eax
f0112d57:	00 03                	add    %al,(%ebx)
f0112d59:	60                   	pusha  
f0112d5a:	35 00 03 70 35       	xor    $0x35700300,%eax
f0112d5f:	00 03                	add    %al,(%ebx)
f0112d61:	80 35 00 03 90 35 00 	xorb   $0x0,0x35900300
f0112d68:	03 a0 35 00 03 b0    	add    -0x4ffcffcb(%eax),%esp
f0112d6e:	35 00 03 c0 35       	xor    $0x35c00300,%eax
f0112d73:	00 03                	add    %al,(%ebx)
f0112d75:	d0                   	(bad)  
f0112d76:	35 00 03 e0 35       	xor    $0x35e00300,%eax
f0112d7b:	00 03                	add    %al,(%ebx)
f0112d7d:	f0 35 00 03 00 36    	lock xor $0x36000300,%eax
f0112d83:	00 03                	add    %al,(%ebx)
f0112d85:	10 36                	adc    %dh,(%esi)
f0112d87:	00 03                	add    %al,(%ebx)
f0112d89:	20 36                	and    %dh,(%esi)
f0112d8b:	00 03                	add    %al,(%ebx)
f0112d8d:	30 36                	xor    %dh,(%esi)
f0112d8f:	00 03                	add    %al,(%ebx)
f0112d91:	40                   	inc    %eax
f0112d92:	36 00 03             	add    %al,%ss:(%ebx)
f0112d95:	50                   	push   %eax
f0112d96:	36 00 03             	add    %al,%ss:(%ebx)
f0112d99:	60                   	pusha  
f0112d9a:	36 00 03             	add    %al,%ss:(%ebx)
f0112d9d:	70 36                	jo     f0112dd5 <entry_pgtable+0xdd5>
f0112d9f:	00 03                	add    %al,(%ebx)
f0112da1:	80 36 00             	xorb   $0x0,(%esi)
f0112da4:	03 90 36 00 03 a0    	add    -0x5ffcffca(%eax),%edx
f0112daa:	36 00 03             	add    %al,%ss:(%ebx)
f0112dad:	b0 36                	mov    $0x36,%al
f0112daf:	00 03                	add    %al,(%ebx)
f0112db1:	c0                   	(bad)  
f0112db2:	36 00 03             	add    %al,%ss:(%ebx)
f0112db5:	d0                   	(bad)  
f0112db6:	36 00 03             	add    %al,%ss:(%ebx)
f0112db9:	e0 36                	loopne f0112df1 <entry_pgtable+0xdf1>
f0112dbb:	00 03                	add    %al,(%ebx)
f0112dbd:	f0 36 00 03          	lock add %al,%ss:(%ebx)
f0112dc1:	00 37                	add    %dh,(%edi)
f0112dc3:	00 03                	add    %al,(%ebx)
f0112dc5:	10 37                	adc    %dh,(%edi)
f0112dc7:	00 03                	add    %al,(%ebx)
f0112dc9:	20 37                	and    %dh,(%edi)
f0112dcb:	00 03                	add    %al,(%ebx)
f0112dcd:	30 37                	xor    %dh,(%edi)
f0112dcf:	00 03                	add    %al,(%ebx)
f0112dd1:	40                   	inc    %eax
f0112dd2:	37                   	aaa    
f0112dd3:	00 03                	add    %al,(%ebx)
f0112dd5:	50                   	push   %eax
f0112dd6:	37                   	aaa    
f0112dd7:	00 03                	add    %al,(%ebx)
f0112dd9:	60                   	pusha  
f0112dda:	37                   	aaa    
f0112ddb:	00 03                	add    %al,(%ebx)
f0112ddd:	70 37                	jo     f0112e16 <entry_pgtable+0xe16>
f0112ddf:	00 03                	add    %al,(%ebx)
f0112de1:	80 37 00             	xorb   $0x0,(%edi)
f0112de4:	03 90 37 00 03 a0    	add    -0x5ffcffc9(%eax),%edx
f0112dea:	37                   	aaa    
f0112deb:	00 03                	add    %al,(%ebx)
f0112ded:	b0 37                	mov    $0x37,%al
f0112def:	00 03                	add    %al,(%ebx)
f0112df1:	c0                   	(bad)  
f0112df2:	37                   	aaa    
f0112df3:	00 03                	add    %al,(%ebx)
f0112df5:	d0                   	(bad)  
f0112df6:	37                   	aaa    
f0112df7:	00 03                	add    %al,(%ebx)
f0112df9:	e0 37                	loopne f0112e32 <entry_pgtable+0xe32>
f0112dfb:	00 03                	add    %al,(%ebx)
f0112dfd:	f0 37                	lock aaa 
f0112dff:	00 03                	add    %al,(%ebx)
f0112e01:	00 38                	add    %bh,(%eax)
f0112e03:	00 03                	add    %al,(%ebx)
f0112e05:	10 38                	adc    %bh,(%eax)
f0112e07:	00 03                	add    %al,(%ebx)
f0112e09:	20 38                	and    %bh,(%eax)
f0112e0b:	00 03                	add    %al,(%ebx)
f0112e0d:	30 38                	xor    %bh,(%eax)
f0112e0f:	00 03                	add    %al,(%ebx)
f0112e11:	40                   	inc    %eax
f0112e12:	38 00                	cmp    %al,(%eax)
f0112e14:	03 50 38             	add    0x38(%eax),%edx
f0112e17:	00 03                	add    %al,(%ebx)
f0112e19:	60                   	pusha  
f0112e1a:	38 00                	cmp    %al,(%eax)
f0112e1c:	03 70 38             	add    0x38(%eax),%esi
f0112e1f:	00 03                	add    %al,(%ebx)
f0112e21:	80 38 00             	cmpb   $0x0,(%eax)
f0112e24:	03 90 38 00 03 a0    	add    -0x5ffcffc8(%eax),%edx
f0112e2a:	38 00                	cmp    %al,(%eax)
f0112e2c:	03 b0 38 00 03 c0    	add    -0x3ffcffc8(%eax),%esi
f0112e32:	38 00                	cmp    %al,(%eax)
f0112e34:	03 d0                	add    %eax,%edx
f0112e36:	38 00                	cmp    %al,(%eax)
f0112e38:	03 e0                	add    %eax,%esp
f0112e3a:	38 00                	cmp    %al,(%eax)
f0112e3c:	03 f0                	add    %eax,%esi
f0112e3e:	38 00                	cmp    %al,(%eax)
f0112e40:	03 00                	add    (%eax),%eax
f0112e42:	39 00                	cmp    %eax,(%eax)
f0112e44:	03 10                	add    (%eax),%edx
f0112e46:	39 00                	cmp    %eax,(%eax)
f0112e48:	03 20                	add    (%eax),%esp
f0112e4a:	39 00                	cmp    %eax,(%eax)
f0112e4c:	03 30                	add    (%eax),%esi
f0112e4e:	39 00                	cmp    %eax,(%eax)
f0112e50:	03 40 39             	add    0x39(%eax),%eax
f0112e53:	00 03                	add    %al,(%ebx)
f0112e55:	50                   	push   %eax
f0112e56:	39 00                	cmp    %eax,(%eax)
f0112e58:	03 60 39             	add    0x39(%eax),%esp
f0112e5b:	00 03                	add    %al,(%ebx)
f0112e5d:	70 39                	jo     f0112e98 <entry_pgtable+0xe98>
f0112e5f:	00 03                	add    %al,(%ebx)
f0112e61:	80 39 00             	cmpb   $0x0,(%ecx)
f0112e64:	03 90 39 00 03 a0    	add    -0x5ffcffc7(%eax),%edx
f0112e6a:	39 00                	cmp    %eax,(%eax)
f0112e6c:	03 b0 39 00 03 c0    	add    -0x3ffcffc7(%eax),%esi
f0112e72:	39 00                	cmp    %eax,(%eax)
f0112e74:	03 d0                	add    %eax,%edx
f0112e76:	39 00                	cmp    %eax,(%eax)
f0112e78:	03 e0                	add    %eax,%esp
f0112e7a:	39 00                	cmp    %eax,(%eax)
f0112e7c:	03 f0                	add    %eax,%esi
f0112e7e:	39 00                	cmp    %eax,(%eax)
f0112e80:	03 00                	add    (%eax),%eax
f0112e82:	3a 00                	cmp    (%eax),%al
f0112e84:	03 10                	add    (%eax),%edx
f0112e86:	3a 00                	cmp    (%eax),%al
f0112e88:	03 20                	add    (%eax),%esp
f0112e8a:	3a 00                	cmp    (%eax),%al
f0112e8c:	03 30                	add    (%eax),%esi
f0112e8e:	3a 00                	cmp    (%eax),%al
f0112e90:	03 40 3a             	add    0x3a(%eax),%eax
f0112e93:	00 03                	add    %al,(%ebx)
f0112e95:	50                   	push   %eax
f0112e96:	3a 00                	cmp    (%eax),%al
f0112e98:	03 60 3a             	add    0x3a(%eax),%esp
f0112e9b:	00 03                	add    %al,(%ebx)
f0112e9d:	70 3a                	jo     f0112ed9 <entry_pgtable+0xed9>
f0112e9f:	00 03                	add    %al,(%ebx)
f0112ea1:	80 3a 00             	cmpb   $0x0,(%edx)
f0112ea4:	03 90 3a 00 03 a0    	add    -0x5ffcffc6(%eax),%edx
f0112eaa:	3a 00                	cmp    (%eax),%al
f0112eac:	03 b0 3a 00 03 c0    	add    -0x3ffcffc6(%eax),%esi
f0112eb2:	3a 00                	cmp    (%eax),%al
f0112eb4:	03 d0                	add    %eax,%edx
f0112eb6:	3a 00                	cmp    (%eax),%al
f0112eb8:	03 e0                	add    %eax,%esp
f0112eba:	3a 00                	cmp    (%eax),%al
f0112ebc:	03 f0                	add    %eax,%esi
f0112ebe:	3a 00                	cmp    (%eax),%al
f0112ec0:	03 00                	add    (%eax),%eax
f0112ec2:	3b 00                	cmp    (%eax),%eax
f0112ec4:	03 10                	add    (%eax),%edx
f0112ec6:	3b 00                	cmp    (%eax),%eax
f0112ec8:	03 20                	add    (%eax),%esp
f0112eca:	3b 00                	cmp    (%eax),%eax
f0112ecc:	03 30                	add    (%eax),%esi
f0112ece:	3b 00                	cmp    (%eax),%eax
f0112ed0:	03 40 3b             	add    0x3b(%eax),%eax
f0112ed3:	00 03                	add    %al,(%ebx)
f0112ed5:	50                   	push   %eax
f0112ed6:	3b 00                	cmp    (%eax),%eax
f0112ed8:	03 60 3b             	add    0x3b(%eax),%esp
f0112edb:	00 03                	add    %al,(%ebx)
f0112edd:	70 3b                	jo     f0112f1a <entry_pgtable+0xf1a>
f0112edf:	00 03                	add    %al,(%ebx)
f0112ee1:	80 3b 00             	cmpb   $0x0,(%ebx)
f0112ee4:	03 90 3b 00 03 a0    	add    -0x5ffcffc5(%eax),%edx
f0112eea:	3b 00                	cmp    (%eax),%eax
f0112eec:	03 b0 3b 00 03 c0    	add    -0x3ffcffc5(%eax),%esi
f0112ef2:	3b 00                	cmp    (%eax),%eax
f0112ef4:	03 d0                	add    %eax,%edx
f0112ef6:	3b 00                	cmp    (%eax),%eax
f0112ef8:	03 e0                	add    %eax,%esp
f0112efa:	3b 00                	cmp    (%eax),%eax
f0112efc:	03 f0                	add    %eax,%esi
f0112efe:	3b 00                	cmp    (%eax),%eax
f0112f00:	03 00                	add    (%eax),%eax
f0112f02:	3c 00                	cmp    $0x0,%al
f0112f04:	03 10                	add    (%eax),%edx
f0112f06:	3c 00                	cmp    $0x0,%al
f0112f08:	03 20                	add    (%eax),%esp
f0112f0a:	3c 00                	cmp    $0x0,%al
f0112f0c:	03 30                	add    (%eax),%esi
f0112f0e:	3c 00                	cmp    $0x0,%al
f0112f10:	03 40 3c             	add    0x3c(%eax),%eax
f0112f13:	00 03                	add    %al,(%ebx)
f0112f15:	50                   	push   %eax
f0112f16:	3c 00                	cmp    $0x0,%al
f0112f18:	03 60 3c             	add    0x3c(%eax),%esp
f0112f1b:	00 03                	add    %al,(%ebx)
f0112f1d:	70 3c                	jo     f0112f5b <entry_pgtable+0xf5b>
f0112f1f:	00 03                	add    %al,(%ebx)
f0112f21:	80 3c 00 03          	cmpb   $0x3,(%eax,%eax,1)
f0112f25:	90                   	nop
f0112f26:	3c 00                	cmp    $0x0,%al
f0112f28:	03 a0 3c 00 03 b0    	add    -0x4ffcffc4(%eax),%esp
f0112f2e:	3c 00                	cmp    $0x0,%al
f0112f30:	03 c0                	add    %eax,%eax
f0112f32:	3c 00                	cmp    $0x0,%al
f0112f34:	03 d0                	add    %eax,%edx
f0112f36:	3c 00                	cmp    $0x0,%al
f0112f38:	03 e0                	add    %eax,%esp
f0112f3a:	3c 00                	cmp    $0x0,%al
f0112f3c:	03 f0                	add    %eax,%esi
f0112f3e:	3c 00                	cmp    $0x0,%al
f0112f40:	03 00                	add    (%eax),%eax
f0112f42:	3d 00 03 10 3d       	cmp    $0x3d100300,%eax
f0112f47:	00 03                	add    %al,(%ebx)
f0112f49:	20 3d 00 03 30 3d    	and    %bh,0x3d300300
f0112f4f:	00 03                	add    %al,(%ebx)
f0112f51:	40                   	inc    %eax
f0112f52:	3d 00 03 50 3d       	cmp    $0x3d500300,%eax
f0112f57:	00 03                	add    %al,(%ebx)
f0112f59:	60                   	pusha  
f0112f5a:	3d 00 03 70 3d       	cmp    $0x3d700300,%eax
f0112f5f:	00 03                	add    %al,(%ebx)
f0112f61:	80 3d 00 03 90 3d 00 	cmpb   $0x0,0x3d900300
f0112f68:	03 a0 3d 00 03 b0    	add    -0x4ffcffc3(%eax),%esp
f0112f6e:	3d 00 03 c0 3d       	cmp    $0x3dc00300,%eax
f0112f73:	00 03                	add    %al,(%ebx)
f0112f75:	d0 3d 00 03 e0 3d    	sarb   0x3de00300
f0112f7b:	00 03                	add    %al,(%ebx)
f0112f7d:	f0 3d 00 03 00 3e    	lock cmp $0x3e000300,%eax
f0112f83:	00 03                	add    %al,(%ebx)
f0112f85:	10 3e                	adc    %bh,(%esi)
f0112f87:	00 03                	add    %al,(%ebx)
f0112f89:	20 3e                	and    %bh,(%esi)
f0112f8b:	00 03                	add    %al,(%ebx)
f0112f8d:	30 3e                	xor    %bh,(%esi)
f0112f8f:	00 03                	add    %al,(%ebx)
f0112f91:	40                   	inc    %eax
f0112f92:	3e 00 03             	add    %al,%ds:(%ebx)
f0112f95:	50                   	push   %eax
f0112f96:	3e 00 03             	add    %al,%ds:(%ebx)
f0112f99:	60                   	pusha  
f0112f9a:	3e 00 03             	add    %al,%ds:(%ebx)
f0112f9d:	70 3e                	jo     f0112fdd <entry_pgtable+0xfdd>
f0112f9f:	00 03                	add    %al,(%ebx)
f0112fa1:	80 3e 00             	cmpb   $0x0,(%esi)
f0112fa4:	03 90 3e 00 03 a0    	add    -0x5ffcffc2(%eax),%edx
f0112faa:	3e 00 03             	add    %al,%ds:(%ebx)
f0112fad:	b0 3e                	mov    $0x3e,%al
f0112faf:	00 03                	add    %al,(%ebx)
f0112fb1:	c0 3e 00             	sarb   $0x0,(%esi)
f0112fb4:	03 d0                	add    %eax,%edx
f0112fb6:	3e 00 03             	add    %al,%ds:(%ebx)
f0112fb9:	e0 3e                	loopne f0112ff9 <entry_pgtable+0xff9>
f0112fbb:	00 03                	add    %al,(%ebx)
f0112fbd:	f0 3e 00 03          	lock add %al,%ds:(%ebx)
f0112fc1:	00 3f                	add    %bh,(%edi)
f0112fc3:	00 03                	add    %al,(%ebx)
f0112fc5:	10 3f                	adc    %bh,(%edi)
f0112fc7:	00 03                	add    %al,(%ebx)
f0112fc9:	20 3f                	and    %bh,(%edi)
f0112fcb:	00 03                	add    %al,(%ebx)
f0112fcd:	30 3f                	xor    %bh,(%edi)
f0112fcf:	00 03                	add    %al,(%ebx)
f0112fd1:	40                   	inc    %eax
f0112fd2:	3f                   	aas    
f0112fd3:	00 03                	add    %al,(%ebx)
f0112fd5:	50                   	push   %eax
f0112fd6:	3f                   	aas    
f0112fd7:	00 03                	add    %al,(%ebx)
f0112fd9:	60                   	pusha  
f0112fda:	3f                   	aas    
f0112fdb:	00 03                	add    %al,(%ebx)
f0112fdd:	70 3f                	jo     f011301e <normalmap+0x1e>
f0112fdf:	00 03                	add    %al,(%ebx)
f0112fe1:	80 3f 00             	cmpb   $0x0,(%edi)
f0112fe4:	03 90 3f 00 03 a0    	add    -0x5ffcffc1(%eax),%edx
f0112fea:	3f                   	aas    
f0112feb:	00 03                	add    %al,(%ebx)
f0112fed:	b0 3f                	mov    $0x3f,%al
f0112fef:	00 03                	add    %al,(%ebx)
f0112ff1:	c0 3f 00             	sarb   $0x0,(%edi)
f0112ff4:	03 d0                	add    %eax,%edx
f0112ff6:	3f                   	aas    
f0112ff7:	00 03                	add    %al,(%ebx)
f0112ff9:	e0 3f                	loopne f011303a <normalmap+0x3a>
f0112ffb:	00 03                	add    %al,(%ebx)
f0112ffd:	f0 3f                	lock aas 
	...

f0113000 <normalmap>:
f0113000:	00 1b                	add    %bl,(%ebx)
f0113002:	31 32                	xor    %esi,(%edx)
f0113004:	33 34 35 36 37 38 39 	xor    0x39383736(,%esi,1),%esi
f011300b:	30 2d 3d 08 09 71    	xor    %ch,0x7109083d
f0113011:	77 65                	ja     f0113078 <normalmap+0x78>
f0113013:	72 74                	jb     f0113089 <normalmap+0x89>
f0113015:	79 75                	jns    f011308c <normalmap+0x8c>
f0113017:	69 6f 70 5b 5d 0a 00 	imul   $0xa5d5b,0x70(%edi),%ebp
f011301e:	61                   	popa   
f011301f:	73 64                	jae    f0113085 <normalmap+0x85>
f0113021:	66 67 68 6a 6b       	addr16 pushw $0x6b6a
f0113026:	6c                   	insb   (%dx),%es:(%edi)
f0113027:	3b 27                	cmp    (%edi),%esp
f0113029:	60                   	pusha  
f011302a:	00 5c 7a 78          	add    %bl,0x78(%edx,%edi,2)
f011302e:	63 76 62             	arpl   %si,0x62(%esi)
f0113031:	6e                   	outsb  %ds:(%esi),(%dx)
f0113032:	6d                   	insl   (%dx),%es:(%edi)
f0113033:	2c 2e                	sub    $0x2e,%al
f0113035:	2f                   	das    
f0113036:	00 2a                	add    %ch,(%edx)
f0113038:	00 20                	add    %ah,(%eax)
	...
f0113046:	00 37                	add    %dh,(%edi)
f0113048:	38 39                	cmp    %bh,(%ecx)
f011304a:	2d 34 35 36 2b       	sub    $0x2b363534,%eax
f011304f:	31 32                	xor    %esi,(%edx)
f0113051:	33 30                	xor    (%eax),%esi
f0113053:	2e 00 00             	add    %al,%cs:(%eax)
	...
f011309a:	00 00                	add    %al,(%eax)
f011309c:	0a 00                	or     (%eax),%al
	...
f01130b2:	00 00                	add    %al,(%eax)
f01130b4:	00 2f                	add    %ch,(%edi)
	...
f01130c6:	00 e0                	add    %ah,%al
f01130c8:	e2 e6                	loop   f01130b0 <normalmap+0xb0>
f01130ca:	00 e4                	add    %ah,%ah
f01130cc:	00 e5                	add    %ah,%ch
f01130ce:	00 e1                	add    %ah,%cl
f01130d0:	e3 e7                	jecxz  f01130b9 <normalmap+0xb9>
f01130d2:	e8 e9 00 00 00       	call   f01131c0 <shiftmap+0xc0>
	...

f0113100 <shiftmap>:
f0113100:	00 1b                	add    %bl,(%ebx)
f0113102:	21 40 23             	and    %eax,0x23(%eax)
f0113105:	24 25                	and    $0x25,%al
f0113107:	5e                   	pop    %esi
f0113108:	26 2a 28             	sub    %es:(%eax),%ch
f011310b:	29 5f 2b             	sub    %ebx,0x2b(%edi)
f011310e:	08 09                	or     %cl,(%ecx)
f0113110:	51                   	push   %ecx
f0113111:	57                   	push   %edi
f0113112:	45                   	inc    %ebp
f0113113:	52                   	push   %edx
f0113114:	54                   	push   %esp
f0113115:	59                   	pop    %ecx
f0113116:	55                   	push   %ebp
f0113117:	49                   	dec    %ecx
f0113118:	4f                   	dec    %edi
f0113119:	50                   	push   %eax
f011311a:	7b 7d                	jnp    f0113199 <shiftmap+0x99>
f011311c:	0a 00                	or     (%eax),%al
f011311e:	41                   	inc    %ecx
f011311f:	53                   	push   %ebx
f0113120:	44                   	inc    %esp
f0113121:	46                   	inc    %esi
f0113122:	47                   	inc    %edi
f0113123:	48                   	dec    %eax
f0113124:	4a                   	dec    %edx
f0113125:	4b                   	dec    %ebx
f0113126:	4c                   	dec    %esp
f0113127:	3a 22                	cmp    (%edx),%ah
f0113129:	7e 00                	jle    f011312b <shiftmap+0x2b>
f011312b:	7c 5a                	jl     f0113187 <shiftmap+0x87>
f011312d:	58                   	pop    %eax
f011312e:	43                   	inc    %ebx
f011312f:	56                   	push   %esi
f0113130:	42                   	inc    %edx
f0113131:	4e                   	dec    %esi
f0113132:	4d                   	dec    %ebp
f0113133:	3c 3e                	cmp    $0x3e,%al
f0113135:	3f                   	aas    
f0113136:	00 2a                	add    %ch,(%edx)
f0113138:	00 20                	add    %ah,(%eax)
	...
f0113146:	00 37                	add    %dh,(%edi)
f0113148:	38 39                	cmp    %bh,(%ecx)
f011314a:	2d 34 35 36 2b       	sub    $0x2b363534,%eax
f011314f:	31 32                	xor    %esi,(%edx)
f0113151:	33 30                	xor    (%eax),%esi
f0113153:	2e 00 00             	add    %al,%cs:(%eax)
	...
f011319a:	00 00                	add    %al,(%eax)
f011319c:	0a 00                	or     (%eax),%al
	...
f01131b2:	00 00                	add    %al,(%eax)
f01131b4:	00 2f                	add    %ch,(%edi)
	...
f01131c6:	00 e0                	add    %ah,%al
f01131c8:	e2 e6                	loop   f01131b0 <shiftmap+0xb0>
f01131ca:	00 e4                	add    %ah,%ah
f01131cc:	00 e5                	add    %ah,%ch
f01131ce:	00 e1                	add    %ah,%cl
f01131d0:	e3 e7                	jecxz  f01131b9 <shiftmap+0xb9>
f01131d2:	e8 e9 00 00 00       	call   f01132c0 <ctlmap+0xc0>
	...

f0113200 <ctlmap>:
	...
f0113210:	11 17                	adc    %edx,(%edi)
f0113212:	05 12 14 19 15       	add    $0x15191412,%eax
f0113217:	09 0f                	or     %ecx,(%edi)
f0113219:	10 00                	adc    %al,(%eax)
f011321b:	00 0d 00 01 13 04    	add    %cl,0x4130100
f0113221:	06                   	push   %es
f0113222:	07                   	pop    %es
f0113223:	08 0a                	or     %cl,(%edx)
f0113225:	0b 0c 00             	or     (%eax,%eax,1),%ecx
f0113228:	00 00                	add    %al,(%eax)
f011322a:	00 1c 1a             	add    %bl,(%edx,%ebx,1)
f011322d:	18 03                	sbb    %al,(%ebx)
f011322f:	16                   	push   %ss
f0113230:	02 0e                	add    (%esi),%cl
f0113232:	0d 00 00 ef 00       	or     $0xef0000,%eax
	...
f0113297:	e0 00                	loopne f0113299 <ctlmap+0x99>
	...
f01132b5:	ef                   	out    %eax,(%dx)
	...
f01132c6:	00 00                	add    %al,(%eax)
f01132c8:	e2 e6                	loop   f01132b0 <ctlmap+0xb0>
f01132ca:	00 e4                	add    %ah,%ah
f01132cc:	00 e5                	add    %ah,%ch
f01132ce:	00 e1                	add    %ah,%cl
f01132d0:	e3 e7                	jecxz  f01132b9 <ctlmap+0xb9>
f01132d2:	e8 e9 00 00 00       	call   f01133c0 <cons+0x80>
	...

Disassembly of section .bss:

f0113300 <panicstr>:
	...

f0113320 <shift.1372>:
f0113320:	00 00                	add    %al,(%eax)
	...

f0113324 <serial_exists>:
f0113324:	00 00                	add    %al,(%eax)
	...

f0113328 <addr_6845>:
f0113328:	00 00                	add    %al,(%eax)
	...

f011332c <crt_buf>:
f011332c:	00 00                	add    %al,(%eax)
	...

f0113330 <crt_pos>:
	...

f0113340 <cons>:
	...

f0113560 <buf>:
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	47                   	inc    %edi
   1:	43                   	inc    %ebx
   2:	43                   	inc    %ebx
   3:	3a 20                	cmp    (%eax),%ah
   5:	28 44 65 62          	sub    %al,0x62(%ebp,%eiz,2)
   9:	69 61 6e 20 34 2e 34 	imul   $0x342e3420,0x6e(%ecx),%esp
  10:	2e                   	cs
  11:	35 2d 38 29 20       	xor    $0x2029382d,%eax
  16:	34 2e                	xor    $0x2e,%al
  18:	34 2e                	xor    $0x2e,%al
  1a:	35                   	.byte 0x35
	...
