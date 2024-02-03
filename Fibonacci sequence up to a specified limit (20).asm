
section .data
    limit db 20       ; Limit of Fibonacci sequence
    fib_sequence times 20 db 0  ; Array to store Fibonacci sequence
    sum_even db 0      ; Variable to store the sum of even Fibonacci numbers
    newline db 0xA    ; Newline character

section .text
    global _start

_start:
    ; Initialize registers
    mov ecx, 2          ; Loop counter for Fibonacci sequence
    mov esi, fib_sequence ; Pointer to the start of Fibonacci sequence array
    mov byte [esi], 0   ; First Fibonacci number (0)
    mov byte [esi+1], 1 ; Second Fibonacci number (1)

fibonacci_loop:
    ; Calculate Fibonacci numbers
    mov al, [esi-1]     ; Load previous Fibonacci number
    add al, [esi]       ; Add to the current Fibonacci number
    mov [esi+ecx], al   ; Store the result in the array
    inc ecx             ; Increment loop counter
    inc esi             ; Move pointer to the next position in the array
    cmp ecx, limit      ; Compare loop counter with the limit
    jge sum_even_numbers ; Jump to sum_even_numbers if limit is reached
    jmp fibonacci_loop  ; Continue Fibonacci sequence generation

sum_even_numbers:
    ; Calculate sum of even Fibonacci numbers
    mov ecx, 2          ; Reset loop counter
    mov esi, fib_sequence ; Reset pointer to the start of Fibonacci sequence array
sum_even_loop:
    mov al, [esi+ecx]   ; Load Fibonacci number
    test al, 1          ; Test if number is even
    jnz next_number     ; Jump if not even
    add [sum_even], al  ; Add even number to the sum
next_number:
    add ecx, 1          ; Increment loop counter
    cmp ecx, limit      ; Compare loop counter with the limit
    jge print_result    ; Jump to print_result if limit is reached
    jmp sum_even_loop  ; Continue summing even Fibonacci numbers

print_result:
    ; Print the sum of even Fibonacci numbers
    mov eax, 4          ; System call for sys_write
    mov ebx, 1          ; File descriptor for stdout
    mov ecx, sum_even   ; Address of sum_even variable
    mov edx, 1          ; Length of the data to be printed
    int 0x80            ; Make system call

    ; Print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit the program
    mov eax, 1          ; System call for sys_exit
    xor ebx, ebx        ; Exit code 0
    int 0x80            ; Make system call



;generates the Fibonacci sequence up to a specified limit (20 in this case) and then calculates the sum of all even numbers in that sequence. Finally, it prints out the result.
