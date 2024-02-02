
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



   ; We reserve space for the sysinfo struct using the resb directive. The sysinfo struct contains various system information such as uptime, load averages, total RAM, free RAM, etc.
   ; We set up the registers with the appropriate values for the sysinfo syscall (eax for the syscall number, edi for the pointer to the sysinfo struct).
   ; We make the syscall using int 0x80.
   ; We check for errors by examining the return value in eax. If there is an error, we handle it accordingly.
   ;If the syscall succeeds, we can access the system information stored in the sysinfo_struct.
   ;Finally, we exit the program.

   ;Please note that accessing specific fields in the sysinfo struct requires knowledge of its layout, which may vary depending on the system architecture and kernel version. The example provided accesses the uptime field, but you can access other fields as needed.
