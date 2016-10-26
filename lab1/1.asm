
1.o:     file format elf32-i386


Disassembly of section .text:

00000000 <.text>:
   0:	ff 74 24 04          	pushl  0x4(%esp)
   4:	8b 5c 24 08          	mov    0x8(%esp),%ebx
   8:	83 c3 37             	add    $0x37,%ebx
   b:	53                   	push   %ebx
   c:	55                   	push   %ebp
   d:	89 e5                	mov    %esp,%ebp
   f:	c9                   	leave  
  10:	c3                   	ret    
