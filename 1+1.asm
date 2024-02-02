section .data
    ; No data section needed for this example

section .text
    global _start

_start:
    ; Load the value 1 into a register
    mov eax, 1

    ; Add 1 to the value in the register
    add eax, 1

    ; Exit the program
    mov eax, 1          ; syscall number for sys_exit
    xor ebx, ebx        ; exit code 0
    int 0x80            ; call kernel
