extern printf
extern exit
extern scanf

section .rodata
    infmt: db "%ld %ld", 0
    outfmt: db "gcd = %ld", 10, 0

section .bss
    val_a: resq 1
    val_b: resq 1

section .text
    global _start

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
;   Read two numbers with scanf("%ld %ld", &a, &b), and
;   printf("gcd = %ld\n", gcd(a, b)).


    xor edi, edi
    call exit
