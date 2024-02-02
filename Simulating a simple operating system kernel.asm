
section .data
    ; Define process control block (PCB) structure
    pcb_size equ 16
    pcb_pid_offset equ 0
    pcb_state_offset equ 4
    pcb_priority_offset equ 8
    pcb_memory_offset equ 12

    ; Define process states
    STATE_NEW equ 0
    STATE_READY equ 1
    STATE_RUNNING equ 2
    STATE_BLOCKED equ 3
    STATE_TERMINATED equ 4

    ; Define system call numbers
    SYS_CREATE_PROCESS equ 0
    SYS_TERMINATE_PROCESS equ 1
    SYS_SCHEDULE equ 2
    SYS_ALLOCATE_MEMORY equ 3
    SYS_DEALLOCATE_MEMORY equ 4
    SYS_SEND_MESSAGE equ 5
    SYS_RECEIVE_MESSAGE equ 6

    ; Define system call error codes
    ERR_SUCCESS equ 0
    ERR_INVALID_PID equ -1
    ERR_INVALID_PRIORITY equ -2
    ERR_INSUFFICIENT_MEMORY equ -3
    ERR_MESSAGE_QUEUE_FULL equ -4
    ERR_MESSAGE_QUEUE_EMPTY equ -5

section .bss
    ; Define process table
    process_table resb 256 * pcb_size  ; 256 processes maximum

    ; Define memory management variables
    memory_pool resb 65536  ; 64KB memory pool
    memory_bitmap resb 8192  ; 64KB / 8 bits = 8192 bytes (one bit per 8 bytes)

section .text
    global _start

_start:
    ; Initialize kernel
    call initialize_memory_manager

    ; Create initial system processes
    call create_process, init_process
    call create_process, idle_process

    ; Run scheduler
    call scheduler

initialize_memory_manager:
    ; Initialize memory manager
    mov ecx, 8192  ; 64KB / 8 bytes per bit = 8192 bytes
    mov edi, memory_bitmap
    mov eax, 0      ; Clear memory bitmap
    rep stosb
    ret

create_process:
    ; Create a new process
    ; Inputs:
    ;   eax: address of the process control block (PCB)
    ;   ebx: entry point of the process
    ;   ecx: priority of the process
    ; Outputs:
    ;   eax: error code (0 for success, negative for failure)
    ;   ebx: process ID if successful
    mov [eax + pcb_pid_offset], ebx
    mov [eax + pcb_state_offset], STATE_READY
    mov [eax + pcb_priority_offset], ecx
    ; Allocate memory for the process stack
    call allocate_memory, 1024  ; 1KB stack size
    jns .allocate_success
    ; Error handling
    mov eax, ERR_INSUFFICIENT_MEMORY
    ret
.allocate_success:
    ; Initialize stack pointer
    mov [eax + pcb_memory_offset], eax
    ; Add the process to the process table
    call add_process_to_table, eax
    ret

terminate_process:
    ; Terminate a process
    ; Inputs:
    ;   eax: process ID
    ; Outputs:
    ;   eax: error code (0 for success, negative for failure)
    mov edi, process_table
    mov ecx, 256
    .search_loop:
        cmp dword [edi + pcb_pid_offset], eax
        je .found_process
        add edi, pcb_size
        loop .search_loop
    ; Process not found
    mov eax, ERR_INVALID_PID
    ret
    .found_process:
        ; Deallocate memory
        mov ebx, [edi + pcb_memory_offset]
        call deallocate_memory, ebx
        ; Remove process from the process table
        sub edi, process_table
        mov ebx, edi
        mov edx, 256
        sub edx, 1
        mov eax, pcb_size
        mul edx
        add ebx, eax
        mov ecx, pcb_size
        cld
        rep movsb
        ; Update process count
        dec dword [process_count]
        ret

scheduler:
    ; Simple round-robin scheduler
    ; Inputs:
    ;   None
    ; Outputs:
    ;   None
    .scheduler_loop:
        mov edi, process_table
        mov ecx, 256
        .find_next_process:
            cmp byte [edi + pcb_state_offset], STATE_READY
            jne .not_ready
            ; Switch to the next process
            call switch_to_process, edi
            jmp .process_found
            .not_ready:
                add edi, pcb_size
                loop .find_next_process
        ; No ready processes found, go idle
        call switch_to_process, idle_process
        .process_found:
            ; Sleep for a short time
            mov eax, 1000000  ; Approximately 1 second
            call delay
        jmp .scheduler_loop

allocate_memory:
    ; Allocate memory from memory pool
    ; Inputs:
    ;   eax: size of memory to allocate
    ; Outputs:
    ;   eax: address of allocated memory if successful, negative error code if failed
    ;   ebx: error code (0 for success, negative for failure)
    ;   ecx: size of memory to allocate (unchanged)
    ;   edx: temporary register
    mov edi, memory_pool
    mov edx, ecx
    shr edx, 3  ; Convert bytes to bitmap index (each bit represents 8 bytes)
    mov ebx, 0  ; Clear error code
    .search_loop:
        test byte [edi + edx], 0xFF  ; Check if all bits are set (memory fully allocated)
        jnz .not_found
        ; Attempt to allocate memory
        mov esi, 0  ; Bit index within the byte
        .search_byte_loop:
            test byte [edi + edx], 1 << esi
            jz .found_space
            inc esi
            cmp esi, 8
            jne .search_byte_loop
        inc edx  ; Move to next byte
        jmp .search_loop
    .not_found:
        ; Memory not found
        mov eax, ERR_INSUFFICIENT_MEMORY
        ret
    .found_space:
        ; Mark memory as allocated
        or byte [edi + edx], 1 << esi
        ; Calculate memory address
        mov eax, edx
        shl eax, 3  ; Convert bitmap index to bytes
        add eax, esi  ; Add bit index
        shl eax, 6  ; Convert bytes to address (64 bytes per bit)
        add eax, memory_pool
        ret

deallocate_memory:
    ; Deallocate memory from memory pool
    ; Inputs:
    ;   eax: address of memory to deallocate
    ; Outputs:
    ;   eax: error code (0 for success, negative for failure)
    ;   ebx: temporary register
    ;   ecx: temporary register
    ;   edx: temporary register
    mov ebx, eax
    sub ebx, memory_pool  ; Calculate offset from memory pool base address
    mov ecx, ebx
    shr ecx, 6  ; Convert address to bitmap index (64 bytes per bit)
    mov edx, ebx
    and edx, 0x3F  ; Extract bit index within the byte
    mov eax, 0  ; Clear error code
    ; Clear memory allocation bit
    mov byte [memory_pool + ecx], byte [memory_pool + ecx] & ~(1 << edx)
    ret

delay:
    ; Delay function
    ; Inputs:
    ;   eax: delay duration
    ; Outputs:
    ;   None
    .delay_loop:
        dec eax
        jnz .delay_loop
    ret

switch_to_process:
    ; Context switch to a process
    ; Inputs:
    ;   eax: address of the process control block (PCB)
    ; Outputs:
    ;   None
    ;   ebx: temporary register
    ;   ecx: temporary register
    ;   edx: temporary register
    ;   esi: temporary register
    ;   edi: temporary register
    ;   ebp: temporary register
    ;   esp: stack pointer of the process
    mov ebx, [eax + pcb_memory_offset]  ; Get process stack pointer
    mov esp, ebx  ; Set stack pointer
    ret

add_process_to_table:
    ; Add a process to the process table
    ; Inputs:
    ;   eax: address of the process control block (PCB)
    ; Outputs:
    ;   None
    ;   ebx: temporary register
    ;   ecx: temporary register
    ;   edx: temporary register
    ;   esi: temporary register
    ;   edi: temporary register
    ;   ebp: temporary register
    ;   esp: temporary register
    ;   eax: process ID if successful
    ;   ebx: error code (0 for success, negative for failure)
    mov edi, process_table
    mov ecx, 256
    .find_empty_slot:
        cmp byte [edi + pcb_state_offset], STATE_TERMINATED
        je .found_empty_slot
        add edi, pcb_size
        loop .find_empty_slot
    ; No empty slot found
    mov eax, ERR_INSUFFICIENT_MEMORY
    ret
    .found_empty_slot:
        ; Copy process control block to the table
        mov ebx, eax
        rep movsb
        ; Update process count
        mov eax, [process_count]
        inc eax
        mov [process_count], eax
        ret

idle_process:
    ; Idle process
    ; Inputs:
    ;   None
    ; Outputs:
    ;   None
    ;   ebx: temporary register
    ;   ecx: temporary register
    ;   edx: temporary register
    ;   esi: temporary register
    ;   edi: temporary register
    ;   ebp: temporary register
    ;   esp: temporary register
    .idle_loop:
        hlt  ; Halt CPU
        jmp .idle_loop  ; Loop indefinitely
