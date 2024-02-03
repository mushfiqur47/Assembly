
section .data
    var1 dd 10   ; First variable
    var2 dd 20   ; Second variable

section .text
global _start

_start:
    ; Compare var1 and var2
    mov eax, dword [var1]
    cmp eax, dword [var2]

    ; Jump based on the comparison result
    jg  greater_than
    jl  less_than
    je  equal_to

greater_than:
    ; Code to execute if var1 is greater than var2
    ; For example:
    ; Print "var1 is greater than var2"
    mov eax, 4            ; System call for sys_write
    mov ebx, 1            ; File descriptor for stdout
    mov ecx, greater_msg  ; Message to print
    mov edx, greater_len  ; Length of the message
    int 0x80              ; Make system call
    jmp end_program       ; Jump to the end of the program

less_than:
    ; Code to execute if var1 is less than var2
    ; For example:
    ; Print "var1 is less than var2"
    mov eax, 4           ; System call for sys_write
    mov ebx, 1           ; File descriptor for stdout
    mov ecx, less_msg    ; Message to print
    mov edx, less_len    ; Length of the message
    int 0x80             ; Make system call
    jmp end_program      ; Jump to the end of the program

equal_to:
    ; Code to execute if var1 is equal to var2
    ; For example:
    ; Print "var1 is equal to var2"
    mov eax, 4          ; System call for sys_write
    mov ebx, 1          ; File descriptor for stdout
    mov ecx, equal_msg  ; Message to print
    mov edx, equal_len  ; Length of the message
    int 0x80            ; Make system call
    jmp end_program     ; Jump to the end of the program

end_program:
    ; Exit the program
    mov eax, 1          ; System call for sys_exit
    xor ebx, ebx        ; Exit code 0
    int 0x80            ; Make system call

section .data
    greater_msg db 'var1 is greater than var2', 0xA
    greater_len equ $ - greater_msg

    less_msg db 'var1 is less than var2', 0xA
    less_len equ $ - less_msg

    equal_msg db 'var1 is equal to var2', 0xA
    equal_len equ $ - equal_msg



;This code demonstrates conditional branching using the CMP (compare) and Jxx (jump if) instructions: compares the values of var1 and var2 and then takes different actions based on the result of the comparison. If var1 is greater than var2, it prints a message indicating so. If var1 is less than var2, it prints a different message. If var1 is equal to var2, it prints yet another message. Finally, the program exits. This demonstrates basic decision-making in assembly language using conditional branching.
