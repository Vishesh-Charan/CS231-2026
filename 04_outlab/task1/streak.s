section .data
    values:
        dq 4, 4, 4, 7, 7, 2, 2, 2, 2, 9, 9, 1, 7, 7, 7
    .end:
    n equ (values.end - values)/8

    ;; longest run of consecutive equal values is 4 by default

section .text
    global _start

_start:
;   find the length of the longest run of consecutive equal values in
;   `values`, and exit with that length
    mov rdi, 1
    mov rsi, 1
    sub rsp, 16
    mov rcx, qword[values]
    mov qword[rsp], rcx
    mov qword[rsp+8], 1
    .loop:
    cmp rsi, n
    jge .loopend
    mov rbx, [rsp]
    cmp qword[values+8*rsi], rbx
    jne .change
    inc rdi
    inc rsi 
    jmp .loop
    .change:
    mov rcx, qword[values +8*rsi]
    mov qword[rsp], rcx
    cmp qword[rsp+8], rdi
    jl .swap
    mov rdi,1
    inc rsi
    jmp .loop
    .swap:
    mov qword[rsp+8], rdi
    mov rdi,1 
    inc rsi
    jmp .loop
    .loopend:
    mov rdi, qword[rsp+8]
    add rsp, 16
    mov rax, 60
    syscall
