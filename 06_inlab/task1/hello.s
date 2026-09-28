section .data
    msg: db "Hello "
    buf: times 512 db 0

section .text
    global _start

_start:
    ; TODO: read a line from stdin (fd 0), then print "Hello " followed by the
    ;       bytes you read to stdout (fd 1) using a SINGLE write syscall. Exit 0.
    xor rax, rax
    mov rdi, 0
    mov rsi, buf
    mov rdx, 100
    syscall

    mov rax,1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 100
    syscall
    mov rax, 60
    xor edi, edi
    syscall
