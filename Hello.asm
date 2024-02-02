
section .data
    hello db 'Hello, World!',0

section .text
    global _start

_start:
    ; Write the string to stdout
    mov eax, 4          ; syscall number for sys_write
    mov ebx, 1          ; file descriptor 1 (stdout)
    mov ecx, hello      ; pointer to the string
    mov edx, 13         ; length of the string
    int 0x80            ; call kernel

    ; Exit the program
    mov eax, 1          ; syscall number for sys_exit
    xor ebx, ebx        ; exit code 0
    int 0x80            ; call kernel




;To assemble and run this program, you'll need NASM installed on your system. Save the code in a file (e.g., hello.asm) and then run the following commands:

;nasm -f elf hello.asm
;ld -m elf_i386 -s -o hello hello.o
;./hello

