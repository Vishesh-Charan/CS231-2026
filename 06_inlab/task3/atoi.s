section .bss
    buf: resb 256

section .text
    global _start

; my_atoi(const char* buf{rdi}, size_t len{rsi}) -> uint64_t{rax}
my_atoi:
    ; TODO
    xor rax, rax
    .loop:
    movzx rbx, byte[rdi]
    cmp rbx, '0'
    jl .end
    cmp rbx, '9'
    jg .end
    sub rbx, '0'
    imul rax, 10
    add rax, rbx
    inc rdi
    jmp .loop
    .end:
    ret

_start:
    ; TODO: read a line from stdin into buf, call my_atoi, exit with the result
    mov rax, 0
    mov rsi, buf
    mov rdi, 0
    mov rdx, 100
    syscall
    mov rdi, buf
    mov rsi, 100
    call my_atoi
    mov rdi, rax
    mov rax, 60
    syscall
