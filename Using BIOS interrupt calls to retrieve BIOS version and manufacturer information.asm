
section .data
    ; Define buffers to store the motherboard information
    manufacturer_buffer resb 64
    version_buffer resb 64

section .text
    global _start

_start:
    ; Call BIOS interrupt to retrieve BIOS version information
    mov ax, 0x1300        ; AX = BIOS function number for getting BIOS version
    mov di, version_buffer  ; DI = pointer to the buffer to store the string
    int 0x10              ; Call BIOS interrupt

    ; Call BIOS interrupt to retrieve BIOS manufacturer information
    mov ax, 0x1500        ; AX = BIOS function number for getting BIOS manufacturer
    mov di, manufacturer_buffer  ; DI = pointer to the buffer to store the string
    int 0x10              ; Call BIOS interrupt

    ; Print or process the collected motherboard information
    ; (Assuming you have some mechanism for printing strings)

    ; Exit the program
    mov eax, 1            ; syscall number for sys_exit
    xor ebx, ebx          ; exit code 0
    int 0x80              ; call kernel



    ;We use BIOS interrupt calls (int 0x10) to retrieve the BIOS version and manufacturer information.
    The specific function numbers (0x1300 and 0x1500) are used for accessing these details. However, these function numbers may vary across different BIOS implementations.
    We store the retrieved information in buffers (version_buffer and manufacturer_buffer) and then can further process or print them.

Remember, accessing hardware details at such a low level is highly platform-dependent and may not be feasible or reliable on all systems. For practical purposes, accessing detailed motherboard information is better achieved using higher-level programming languages or system utilities provided by the operating system.
