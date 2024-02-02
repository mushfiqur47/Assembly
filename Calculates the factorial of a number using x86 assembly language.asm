
section .data
    prompt db 'Enter a number: ', 0
    output db 'Factorial: ', 0
    newline db 0xA, 0xD, 0

section .bss
    num resb 10      ; Buffer to store input number
    result resb 10   ; Buffer to store result

section .text
    global _start

_start:
    ; Display prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 15
    int 0x80

    ; Read input
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 10
    int 0x80

    ; Convert input to integer
    xor eax, eax
    xor ecx, ecx
    xor edx, edx
    mov ebx, num
.next_digit:
    movzx edx, byte [ebx + ecx] ; Load next byte of input
    test dl, dl
    jz .end_of_input
    sub edx, '0'                ; Convert ASCII to integer
    imul eax, 10                ; Multiply current number by 10
    add eax, edx                ; Add current digit
    inc ecx                     ; Move to next byte
    jmp .next_digit
.end_of_input:

    ; Calculate factorial
    mov ebx, eax        ; Store input number in ebx
    mov eax, 1          ; Initialize factorial result to 1
.loop:
    mul ebx             ; Multiply eax by ebx
    dec ebx             ; Decrement ebx
    test ebx, ebx       ; Check if ebx is zero
    jnz .loop           ; Jump to loop if ebx is not zero

    ; Convert factorial result to string
    mov esi, result     ; Pointer to result buffer
    add esi, 9          ; Move pointer to end of buffer
    mov byte [esi], 0   ; Null-terminate string
    dec esi             ; Move pointer to last digit
.convert_loop:
    xor edx, edx        ; Clear edx
    div dword [ten]     ; Divide eax by 10, remainder in edx
    add dl, '0'         ; Convert remainder to ASCII
    mov [esi], dl       ; Store ASCII digit
    dec esi             ; Move pointer to previous digit
    test eax, eax       ; Check if quotient is zero
    jnz .convert_loop   ; If not, continue conversion

    ; Print factorial result
    mov eax, 4
    mov ebx, 1
    mov ecx, output
    mov edx, 10
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 10
    int 0x80

    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80

section .data
    ten dd 10



;This program takes a number as input, calculates its factorial, and then prints the result. It uses basic input/output operations and integer arithmetic in assembly language.
