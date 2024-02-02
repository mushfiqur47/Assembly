
section .data
    sysinfo_struct resb 64  ; Reserve space for sysinfo struct

section .text
    global _start

_start:
    ; Prepare syscall parameters
    mov eax, 99              ; syscall number for sysinfo
    mov edi, sysinfo_struct  ; pointer to the sysinfo struct
    int 0x80                 ; call kernel

    ; Check for errors (eax contains return value)
    test eax, eax            ; Check if there was an error
    jns success              ; Jump if no error
    ; Handle error here, e.g., print an error message
    mov eax, 1               ; syscall number for sys_exit
    xor ebx, ebx             ; exit code 0
    int 0x80                 ; call kernel

success:
    ; Sysinfo data is now in the sysinfo_struct
    ; You can access the data using the struct format specified by the sysinfo syscall
    ; For example, to print the uptime:
    mov ebx, [sysinfo_struct + 8]  ; Offset of uptime in sysinfo struct
    ; ebx now contains the uptime value in seconds
    ; Print or use the uptime value as needed

    ; Exit the program
    mov eax, 1               ; syscall number for sys_exit
    xor ebx, ebx             ; exit code 0
    int 0x80                 ; call kernel



section .data
    sysinfo_struct resb 64  ; Reserve space for sysinfo struct

section .text
    global _start

_start:
    ; Prepare syscall parameters
    mov eax, 99              ; syscall number for sysinfo
    mov edi, sysinfo_struct  ; pointer to the sysinfo struct
    int 0x80                 ; call kernel

    ; Check for errors (eax contains return value)
    test eax, eax            ; Check if there was an error
    jns success              ; Jump if no error
    ; Handle error here, e.g., print an error message
    mov eax, 1               ; syscall number for sys_exit
    xor ebx, ebx             ; exit code 0
    int 0x80                 ; call kernel

success:
    ; Sysinfo data is now in the sysinfo_struct
    ; You can access the data using the struct format specified by the sysinfo syscall
    ; For example, to print the uptime:
    mov ebx, [sysinfo_struct + 8]  ; Offset of uptime in sysinfo struct
    ; ebx now contains the uptime value in seconds
    ; Print or use the uptime value as needed

    ; Exit the program
    mov eax, 1               ; syscall number for sys_exit
    xor ebx, ebx             ; exit code 0
    int 0x80                 ; call kernel
