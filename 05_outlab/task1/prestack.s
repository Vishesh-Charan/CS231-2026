section .rodata
    error_msg: db "There should be 3 command line arguments!",10
    .end: db 0 ; null terminator for the TA's mental peace
    error_msg_len equ (error_msg.end-error_msg)

section .text
    global _start

; my_strlen(const char* str{rdi}) -> rax (not counting the null terminator)
my_strlen:
    .start:
    mov rsi, rdi
    mov rax, 0
    .loop:
    movzx rbx, byte[rsi]
    cmp rbx, 0
    jz .endi
    inc rax
    inc rsi
    jmp .loop
    .endi:
    ret

; my_atoi(const char* str{rdi}) -> rax (handles an optional leading '-')
my_atoi:
    .start:
    mov rax, 0
    mov rsi, rdi
    mov rbx, 1
    jmp .neg
    .mneg:
    mov rbx, -1
    inc rsi
    jmp .loop
    .neg:
    cmp byte[rsi], '-'
    je .mneg
    .loop:
    cmp byte[rsi], '0'
    jl .end
    cmp byte[rsi], '9'
    jg .end
    movzx rdx, byte[rsi]
    sub rdx, '0'
    imul rax, 10
    add rax, rdx
    inc rsi
    jmp .loop
    .end:
    imul rax, rbx
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
;   check argc at [rsp] if it is 3, if not print error_msg and exit.
;   argv[1] is at [rsp+16], argv[2] is at [rsp+24] (argc is at [rsp]).
;   Print argv[1] as-is (using my_strlen + a direct write syscall), then
;   exit with gcd(atoi(argv[1]), atoi(argv[2])).

    cmp qword[rsp], 3
    jne .errorms 
    mov rdi, qword[rsp+16]
    call my_strlen
    sub rsp, 8
    mov [rsp], rax
    mov rax, 1
    mov rdi, 1
    mov rsi, qword[rsp+24]
    mov rdx, qword[rsp]
    syscall
    add rsp, 8
    mov rdi, qword[rsp+16]
    call my_atoi
    sub rsp, 8
    mov [rsp], rax
    mov rdi, qword[rsp+32]
    call my_atoi
    sub rsp, 8
    mov [rsp], rax
    mov rsi, qword[rsp]
    add rsp, 8
    mov rdi, qword[rsp]
    add rsp, 8
    call gcd
    mov rdi, rax
    jmp .end
    .errorms:
    mov rax, 1
    mov rdi, 2
    mov rsi, error_msg
    mov rdx, error_msg_len
    syscall

    .end:
    mov rax, 60
    syscall
