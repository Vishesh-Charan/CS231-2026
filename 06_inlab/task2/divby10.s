section .text
    global _start

; div_by_10(uint64_t n{rdi}) -> uint64_t{rax}
div_by_10:
    ; TODO
    mov rax, rdi
    xor rdx, rdx
    mov rcx, 5
    shr rax, 1
    div rcx
    ret

_start:
    ; TODO: call div_by_10(250), exit with the result
    mov rdi, 250
    xor rax,rax
    call div_by_10
    mov rdi, rax
    mov rax, 60
    syscall
