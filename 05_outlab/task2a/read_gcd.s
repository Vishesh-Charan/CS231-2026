extern printf
extern exit

section .data
    fmt: db "gcd = %ld", 10, 0

section .bss
    buf: resb 256 ; so much excess space!

section .text
    global _start

; my_strtol_10(const char* str{rdi}, char** str_end{rsi}) -> rax
; write the address of the first character you do not read in [rsi]
my_strtol_10:
    .start:
    mov rax, 0
    mov rbx, 1
    cmp byte[rdi], ' '
    je .redo
    jmp .neg
    .redo:
    inc rdi
    jmp .start
    .mneg:
    mov rbx, -1
    inc rdi
    jmp .loop
    .neg:
    cmp byte[rdi], '-'
    je .mneg
    .loop:
    cmp byte[rdi], '0'
    jl .end
    cmp byte[rdi], '9'
    jg .end
    movzx rdx, byte[rdi]
    sub rdx, '0'
    imul rax, 10
    add rax, rdx
    inc rdi
    jmp .loop
    .end:
    imul rax, rbx
    mov [rsi], rdi
    ret

; gcd(int64_t a{rdi}, int64_t b{rsi}) -> rax
gcd:
    mov rax, 0
    cmp rdi, 0
    je .az
    cmp rsi, 0
    je .bz
    .loop:
    cmp rdi, rsi
    jle .suba
    sub rdi, rsi
    jmp gcd
    .suba:
    sub rsi, rdi 
    jmp gcd
    .az:
    mov rax, rsi
    jmp .end
    .bz:
    mov rax, rdi
    jmp .end
    .end:
    ret

_start:
    and rsp, -16
;   Read "A B" (space-separated) from stdin in ONE read syscall, parse both
;   numbers with my_strtol_10 (skipping the separator through strtol),
;   and printf("gcd = %ld\n", gcd(A, B)).
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 256
    syscall
    mov rdi, rsi
    mov rsi, rsp
    call my_strtol_10
    sub rsp, 8
    mov [rsp], rax
    mov rdi, [rsi]
    call my_strtol_10
    mov rdi, [rsp]
    mov rsi, rax
    add rsp, 8
    call gcd
    mov rdi, fmt
    mov rsi, rax
    xor eax, eax
    call printf
    xor edi, edi
    call exit
