
section .data
    ; Define room descriptions
    room0_desc db 'You are in a dark cave.', 0
    room1_desc db 'You are in a forest.', 0
    room2_desc db 'You are in a castle.', 0
    room3_desc db 'You are on a beach.', 0
    ; Define room connections
    room0_exit db 'East', 0
    room1_exit db 'North', 0
    room2_exit db 'West', 0
    room3_exit db 'South', 0
    ; Define enemy descriptions
    enemy0_desc db 'A ferocious wolf blocks your path!', 0
    enemy1_desc db 'A giant spider crawls towards you!', 0
    enemy2_desc db 'A wicked witch appears before you!', 0
    enemy3_desc db 'A menacing shark swims closer!', 0
    ; Define treasure descriptions
    treasure0_desc db 'You found a shiny gem!', 0
    treasure1_desc db 'You found a golden key!', 0
    treasure2_desc db 'You found a magical potion!', 0
    treasure3_desc db 'You found a bag of coins!', 0

section .bss
    current_room resb 1    ; Variable to store current room number
    player_health resb 1   ; Variable to store player health
    enemy_present resb 1   ; Flag to indicate if an enemy is present
    treasure_present resb 1  ; Flag to indicate if a treasure is present

section .text
    global _start

_start:
    ; Initialize game state
    mov byte [current_room], 0   ; Start in room 0
    mov byte [player_health], 3  ; Set player health to 3
    mov byte [enemy_present], 0  ; No enemy present initially
    mov byte [treasure_present], 0  ; No treasure present initially
    call print_room_description

main_loop:
    ; Check if player has health
    movzx eax, byte [player_health]
    test eax, eax
    jz game_over

    ; Check if player reached the final room
    cmp byte [current_room], 3
    je game_win

    ; Check for enemy or treasure in current room
    call check_for_enemy
    call check_for_treasure

    ; Display room options
    call print_room_options

    ; Get player input
    call get_player_input

    ; Process player input
    cmp al, 'n'  ; Move to next room
    je move_next_room
    cmp al, 'a'  ; Attack enemy
    je attack_enemy
    cmp al, 'p'  ; Pick up treasure
    je pick_up_treasure
    jmp main_loop

move_next_room:
    ; Move to the next room
    inc byte [current_room]
    call print_room_description
    jmp main_loop

attack_enemy:
    ; Attack the enemy
    movzx eax, byte [player_health]
    dec eax
    mov byte [player_health], al
    call print_enemy_defeat
    jmp main_loop

pick_up_treasure:
    ; Pick up the treasure
    mov byte [treasure_present], 0
    call print_treasure_found
    jmp main_loop

game_over:
    ; Game over message
    mov eax, 4
    mov ebx, 1
    mov ecx, game_over_msg
    mov edx, game_over_msg_len
    int 0x80

    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80

game_win:
    ; Game win message
    mov eax, 4
    mov ebx, 1
    mov ecx, game_win_msg
    mov edx, game_win_msg_len
    int 0x80

    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_room_description:
    ; Print current room description
    mov eax, 4
    mov ebx, 1
    mov edx, room_desc_len
    cmp byte [current_room], 0
    je .room0
    cmp byte [current_room], 1
    je .room1
    cmp byte [current_room], 2
    je .room2
    cmp byte [current_room], 3
    je .room3
    ; Default room description
    mov ecx, default_room_desc
    jmp .print_desc
.room0:
    mov ecx, room0_desc
    jmp .print_desc
.room1:
    mov ecx, room1_desc
    jmp .print_desc
.room2:
    mov ecx, room2_desc
    jmp .print_desc
.room3:
    mov ecx, room3_desc
.print_desc:
    int 0x80
    ret

print_room_options:
    ; Print room options
    mov eax, 4
    mov ebx, 1
    mov edx, room_options_len
    mov ecx, room_options
    int 0x80
    ret

check_for_enemy:
    ; Check if there is an enemy in the current room
    mov byte [enemy_present], 0
    cmp byte [current_room], 0
    jne .not_room0
    mov byte [enemy_present], 1
    ret
.not_room0:
    ; Check for other rooms' enemies
    ; (Implementation omitted for brevity)
    ret

check_for_treasure:
    ; Check if there is treasure in the current room
    mov byte [treasure_present], 0
    cmp byte [current_room], 1
    jne .not_room1
    mov byte [treasure_present], 1
    ret
.not_room1:
    ; Check for other rooms' treasure
    ; (Implementation omitted for brevity)
    ret

get_player_input:
    ; Get player input
    mov eax, 3
    mov ebx, 0
    mov ecx, player_input
    mov edx, 1
    int 0x80
    ret

section .data
    ; Define game over message
    game_over_msg db 'Game over! You lost all your health.', 0xA, 0xD, 0
    game_over_msg_len equ $ - game_over_msg
    ; Define game win message
    game_win_msg db 'Congratulations! You reached the end of the game!', 0xA, 0xD, 0
    game_win_msg_len equ $ - game_win_msg
    ; Define default room description
    default_room_desc db 'You are in an unknown place.', 0
    ; Define room options
    room_options db 'Options:', 0xA, 0xD, ' - Move to the next room (n)', 0xA, 0xD, ' - Attack enemy (a)', 0xA, 0xD, ' - Pick up treasure (p)', 0xA, 0xD, 0
    room_options_len equ $ - room_options
    ; Define player input buffer
    player_input resb 1





;This program simulates a text-based adventure game where the player navigates through different rooms, encounters enemies, and collects treasures. The player's goal is to reach the final room while managing their health and making strategic decisions. The game responds to player input and updates the game state accordingly.
