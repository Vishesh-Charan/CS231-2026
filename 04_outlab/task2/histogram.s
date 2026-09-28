section .data
    text:
        db "mississippi"
    .end:
    text_len equ (text.end - text)

    counts: times 26 dd 0

    ;; the most common letter's count is 4 by default

section .text
    global _start

_start:
;   build a histogram of letter counts into `counts` (counts[c - 'a']
;   for each byte c in `text`), then exit with the highest count found
;   in `counts`
    xor rdi,rdi
    mov rsi, 1
    movzx rbx, byte[text]
    sub rbx, 'a'
    inc dword[counts+4*rbx]
    sub rsp, 8
    mov qword[rsp+8], 1
    .loop:
    cmp rsi, text_len
    jge .loopend
    movzx rbx, byte[text+rsi]
    sub rbx, 'a'
    inc dword[counts+4*rbx]
    movsx rcx, dword[counts+4*rbx]
    cmp qword[rsp+8], rcx
    jl .swap
    inc rsi
    jmp .loop
    .swap:
    mov qword[rsp+8], rcx
    inc rsi
    jmp .loop
    .loopend:
    mov rdi, qword[rsp+8]
    add rsp, 8
    mov rax, 60
    syscall