
section .data
    sum_msg db "The sum of the first 1000 positive integers is: ", 0
    newline db 0xA, 0xD, 0
    sum_result db 20 DUP ('$')

section .bss
    sum resd 1   ; Variable to store the sum

section .text
    global _start

_start:
    ; Initialize sum to 0
    mov dword [sum], 0

    ; Loop to calculate the sum
    mov ecx, 1         ; Counter for the loop
calc_sum_loop:
    add dword [sum], ecx  ; Add current value of counter to sum
    inc ecx               ; Increment counter
    cmp ecx, 1001         ; Check if counter reaches 1001
    jnz calc_sum_loop     ; If not, continue loop

    ; Convert the sum to ASCII
    mov eax, dword [sum]
    mov ebx, sum_result
    call dword [int_to_ascii]

    ; Print the result message
    mov eax, 4
    mov ebx, 1
    mov ecx, sum_msg
    mov edx, 46    ; Length of the message
    int 0x80

    ; Print the sum
    mov eax, 4
    mov ebx, 1
    mov ecx, sum_result
    call dword [print_string]

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 2
    int 0x80

    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_string:
    ; Print a null-terminated string
    ; Inputs:
    ;   ebx: pointer to the string
    ; Outputs:
    ;   None
    .print_loop:
        mov al, byte [ebx]   ; Load the next byte of the string
        test al, al          ; Check if it's the null terminator
        jz .print_done       ; If so, we're done
        mov [esp], eax       ; Move the character to the stack
        mov eax, 1           ; syscall number for sys_write
        mov ebx, 1           ; file descriptor 1 (stdout)
        lea ecx, [esp]       ; Pointer to the character in the stack
        mov edx, 1           ; Length of the character
        int 0x80             ; call kernel
        inc ebx              ; Move to the next character
        jmp .print_loop      ; Continue looping
    .print_done:
        ret

int_to_ascii:
    ; Convert an integer to ASCII representation
    ; Inputs:
    ;   eax: integer to convert
    ;   ebx: pointer to the buffer to store the result
    ; Outputs:
    ;   None
    ; Note: The buffer should have enough space to store the ASCII representation of the integer.
    mov esi, 10   ; Divisor for conversion
    mov edi, ebx  ; Pointer to the buffer
    add edi, 19   ; Move pointer to the end of the buffer
    mov byte [edi], 0  ; Null-terminate the string
.convert_loop:
    xor edx, edx      ; Clear edx for division
    div esi           ; Divide eax by 10
    add dl, '0'       ; Convert remainder to ASCII
    dec edi           ; Move pointer to the left
    mov [edi], dl     ; Store ASCII digit
    test eax, eax     ; Check if quotient is zero
    jnz .convert_loop ; If not, continue conversion
    ret

