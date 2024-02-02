
section .data
    processor_info db "Processor Information: ", 0
    buffer resb 32   ; Buffer to store CPU information

section .text
    global _start

_start:
    ; Use the uname syscall to get system information
    mov eax, 122        ; syscall number for uname
    mov edi, buffer     ; pointer to the buffer to store CPU information
    int 0x80            ; call kernel

    ; Print "Processor Information: "
    mov eax, 4          ; syscall number for sys_write
    mov ebx, 1          ; file descriptor 1 (stdout)
    mov ecx, processor_info
    mov edx, 20         ; length of the string
    int 0x80            ; call kernel

    ; Print the CPU information retrieved by uname syscall
    mov eax, 4          ; syscall number for sys_write
    mov ebx, 1          ; file descriptor 1 (stdout)
    mov ecx, buffer     ; pointer to the CPU information
    int 0x80            ; call kernel

    ; Exit the program
    mov eax, 1          ; syscall number for sys_exit
    xor ebx, ebx        ; exit code 0
    int 0x80            ; call kernel


    We use the uname syscall to retrieve system information, including CPU information.
    The CPU information is stored in the buffer.
    We print the "Processor Information: " string followed by the CPU information retrieved by the uname syscall.
    Finally, we exit the program.

Please note that the information returned by the uname syscall might not include detailed CPU specifications such as model name, speed, cache sizes, etc. For accessing more detailed CPU information, you would typically use higher-level programming languages or utilities provided by the operating system or hardware abstraction layers.
