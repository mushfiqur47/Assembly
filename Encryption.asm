
section .data
    filename db "file.txt",0
    key db 0x12, 0x34, 0x56, 0x78
    key_len equ $-key

section .text
    global _start
    
_start:
    ; Open the file for reading
    mov eax, 5                  ; sys_open system call
    mov ebx, filename           ; pointer to filename
    mov ecx, 0                  ; flags (O_RDONLY)
    int 0x80                    ; call kernel

    ; Check if file opened successfully
    cmp eax, -1
    je error

    mov ebx, eax                ; save file descriptor

    ; Get file size
    mov eax, 19                 ; sys_fstat system call
    mov ecx, ebx                ; file descriptor
    lea edx, [esp-12]           ; pointer to stat structure
    int 0x80                    ; call kernel

    ; Check if fstat succeeded
    cmp eax, -1
    je error

    mov eax, [esp-12+4]         ; retrieve file size

    ; Allocate memory for file content
    sub esp, eax

    ; Read file content
    mov eax, 3                  ; sys_read system call
    mov ebx, [esp+4]            ; file descriptor
    mov ecx, esp                ; pointer to buffer
    mov edx, eax                ; number of bytes to read
    int 0x80                    ; call kernel

    ; Encrypt file content
    mov esi, esp                ; pointer to file content
    mov ecx, eax                ; number of bytes read
    mov edi, key                ; pointer to encryption key
    mov edx, key_len            ; length of encryption key

encrypt:
    xor [esi], byte [edi]       ; encryption operation
    inc esi
    inc edi
    loop encrypt

    ; Write encrypted content back to file
    mov eax, 4                  ; sys_write system call
    mov ebx, [esp+4]            ; file descriptor
    mov ecx, esp                ; pointer to encrypted content
    mov edx, [esp+12]           ; number of bytes to write
    int 0x80                    ; call kernel

    ; Cleanup and exit
    mov eax, 6                  ; sys_close system call
    mov ebx, [esp+4]            ; file descriptor
    int 0x80                    ; call kernel

    add esp, eax
    xor eax, eax
    ret

error:
    ; Handle error case here
    xor eax, eax
    mov ebx, 1                  ; stderr file descriptor
    mov ecx, error_message
    mov edx, error_len
    int 0x80                    ; call kernel

    xor eax, eax
    mov ebx, -1                 ; exit status
    int 0x80                    ; call kernel

section .data
    error_message db "An error occurred.", 0
    error_len equ $-error_message


;This assembly code opens a file, reads its content, encrypts it using a predefined key, and then writes the encrypted content back to the file. Make sure to replace "file.txt" with the name of the file you want to encrypt. The encryption key is provided as an example and can be modified to suit your needs. Remember that file encryption can have legal implications, so use this code responsibly and ensure you have the necessary permissions before proceeding.

