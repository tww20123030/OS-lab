push 4(%esp)
movl  8(%esp),%ebx
add  $0x37,%ebx
push %ebx  #address of do_overflow
push %ebp
mov  %esp,%ebp
leave
ret

