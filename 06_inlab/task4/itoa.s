section .bss
    inbuf:  resb 256
    outbuf: resb 32

section .text
    global _start

; my_atoi(const char* buf{rdi}, size_t len{rsi}) -> uint64_t{rax}
my_atoi:
    ; TODO: copy your Task 3 solution here
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

; ----------------------------------------------------------------------------
; my_itoa(uint64_t n{rdi}, char* buf{rsi}) -> size_t{rax}   -- GIVEN, do not edit
;   Writes the decimal text of n into buf (no null terminator). Returns the
;   number of digits written. Digits fall out of the div-by-10 loop least
;   significant first, so we fill buf forwards and then reverse it in place.
; ----------------------------------------------------------------------------
my_itoa:
    mov rax, rdi
    mov r8, rsi          ; write pointer
    mov r9, 10
.emit:
    xor edx, edx
    div r9              ; rax = rax/10, rdx = rax%10
    add dl, '0'
    mov [r8], dl
    inc r8
    test rax, rax
    jnz .emit

    mov rax, r8
    sub rax, rsi         ; rax = number of digits

    dec r8               ; last digit
.reverse:
    cmp rsi, r8
    jae .done
    mov cl, [rsi]
    mov dl, [r8]
    mov [rsi], dl
    mov [r8], cl
    inc rsi
    dec r8
    jmp .reverse
.done:
    ret

_start:
    ; TODO: read two lines from stdin, my_atoi each, add them, my_itoa the sum
    ;       into outbuf, write the digits + a newline to stdout, exit 0.
    
    xor rax, rax
    xor rdi, rdi
    mov rsi, inbuf
    mov rdx, 100
    syscall
    mov rdi, inbuf
    mov rsi, 100
    call my_atoi
    sub rsp, 8
    mov [rsp], rax
    inc rdi
    mov rsi, 100
    call my_atoi
    sub rsp, 8
    mov [rsp], rax
    mov rdi, qword[rsp]
    add rsp, 8
    add rdi, qword[rsp]
    add rsp, 8
    mov rsi, outbuf
    sub rsp, 8
    mov [rsp], rsi
    call my_itoa


    mov rsi, [rsp]
    add rsp, 8
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    xor edi, edi
    syscall
