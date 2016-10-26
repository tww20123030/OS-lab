
2.o:     file format elf32-i386


Disassembly of section .text:

00000000 <.text>:
   0:	8b 14 24             	mov    (%esp),%edx
   3:	ff 32                	pushl  (%edx)
   5:	8b 1a                	mov    (%edx),%ebx
   7:	83 c3 37             	add    $0x37,%ebx
   a:	53                   	push   %ebx
   b:	55                   	push   %ebp
   c:	89 e5                	mov    %esp,%ebp
   e:	c9                   	leave  
   f:	c3                   	ret    
