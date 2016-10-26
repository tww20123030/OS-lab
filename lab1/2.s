mov (%esp),%edx
push (%edx)
mov  (%edx),%ebx
add  $0x37,%ebx
push %ebx  #address of do_overflow
push %ebp
mov  %esp,%ebp
leave
ret

