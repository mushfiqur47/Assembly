
section .data
    filename db 'example.txt',0  ; File name to delete

section .text
    global _start

_start:
    ; Use the unlink syscall to delete the file
    mov eax, 10             ; syscall number for unlink
    mov ebx, filename      ; pointer to the file name
    int 0x80               ; call kernel

    ; Check for errors (eax contains return value)
    test eax, eax          ; Check if there was an error
    jnz error              ; Jump to error label if there was an error

    ; Exit the program
    mov eax, 1             ; syscall number for sys_exit
    xor ebx, ebx           ; exit code 0
    int 0x80               ; call kernel

error:
    ; Handle error here, e.g., print an error message
    ; Then exit the program with a non-zero exit code
    mov eax, 1             ; syscall number for sys_exit
    mov ebx, 1             ; exit code 1 (indicating error)
    int 0x80               ; call kernel


    ;The unlink syscall is used to delete the file specified by the filename variable.
    ;If an error occurs during the deletion process, the program jumps to the error label, where you can handle the error (e.g., print an error message).
    ;After deletion or error handling, the program exits with an appropriate exit code.

    ;To use this code, replace 'example.txt' in the filename variable with the name of the file you want to delete. Then assemble and run the code using the appropriate steps for your assembly environment.
