; New Year Tree with Flashing Lights
; Student ID: 20220808056.


org 100h

jmp start

; --- DATA SECTION ---



num_line1 db ' *** *** *** *** *** *** *** *** *** *** ***', 0
num_line2 db '   * * *   *   * * * * * * * * * * * *   *', 0
num_line3 db '  *  * *  *   *  * * *** * * *** * * *** ***', 0 
num_line4 db ' *   * * *   *   * * * * * * * * * *   * * *', 0 
num_line5 db ' *** *** *** *** *** *** *** *** *** *** ***', 0


; Tree lines
tree_line1  db '        * ', 0
tree_line2  db '       *** ', 0
tree_line3  db '      ***** ', 0
tree_line4  db '     ******* ', 0
tree_line5  db '    ********* ', 0
tree_line6  db '   *********** ', 0
tree_line7  db '  ************* ', 0
tree_line8  db ' *************** ', 0
tree_line9  db '       *** ', 0
tree_line10 db '       *** ', 0




; HAPPY (Red)
happy_line1 db '*  *  *  *** *** * *', 0
happy_line2 db '*  * * * * * * * * *', 0
happy_line3 db '**** *** *** *** ***', 0
happy_line4 db '*  * * * *   *    *', 0
happy_line5 db '*  * * * *   *    *', 0

; NEW (Cyan)
new_line1 db '*  * ** * * *', 0
new_line2 db '** * *  * * *', 0
new_line3 db '* ** ** * * *', 0
new_line4 db '*  * *  * * *', 0
new_line5 db '*  * ** *****', 0

; YEAR (Magenta)
year_line1 db '*  ****  *  **', 0
year_line2 db ' ****   * * * * ', 0
year_line3 db '  * *** *** * *', 0
year_line4 db '  * *   * * **', 0
year_line5 db '  * *** * * * *', 0

; Tree positions for flashing lights (row, col)
light_positions:
    db 2, 40   ; Top Star
    db 3, 39, 3, 41
    db 4, 38, 4, 40, 4, 42
    db 5, 37, 5, 39, 5, 41, 5, 43
    db 6, 36, 6, 38, 6, 40, 6, 42, 6, 44
    db 7, 35, 7, 37, 7, 39, 7, 41, 7, 43, 7, 45
    db 8, 34, 8, 36, 8, 38, 8, 40, 8, 42, 8, 44, 8, 46
    db 0FFh, 0FFh  ; End marker

; --- CODE SECTION ---
start:
    ; Set video mode 03h (80x25 text color)
    mov ah, 0
    mov al, 3
    int 10h
    
    ; Hide cursor
    mov ah, 1
    mov ch, 20h
    int 10h
    
    call clear_screen
    call draw_tree
    call draw_student_number
    call draw_happy_new_year
    
    ; Start the flashing lights
    call flashing_lights_loop
    
    mov ax, 4c00h
    int 21h

; --- PROCEDURES ---

clear_screen proc
    mov ah, 6       
    mov al, 0       
    mov bh, 07h     
    mov cx, 0       
    mov dx, 184Fh   
    int 10h
    ret
clear_screen endp
                 
                 
                 

draw_student_number proc
    mov dl, 12
    mov bl, 15      ; White

    mov dh, 12      ; directly under tree
    mov si, offset num_line1
    call print_string_generic

    mov dh, 13
    mov si, offset num_line2
    call print_string_generic

    mov dh, 14
    mov si, offset num_line3
    call print_string_generic

    mov dh, 15
    mov si, offset num_line4
    call print_string_generic
    
    mov dh, 16
    mov si, offset num_line5
    call print_string_generic  
    

    ret
draw_student_number endp
           
                 
draw_tree proc
    push ax
    push bx
    push dx
    push si
    
    mov si, offset tree_line1
    mov dh, 2
    call draw_tree_lines_loop
    
    mov si, offset tree_line2
    mov dh, 3
    call draw_tree_lines_loop
    
    mov si, offset tree_line3
    mov dh, 4
    call draw_tree_lines_loop
    
    mov si, offset tree_line4
    mov dh, 5
    call draw_tree_lines_loop
    
    mov si, offset tree_line5
    mov dh, 6
    call draw_tree_lines_loop
    
    mov si, offset tree_line6
    mov dh, 7
    call draw_tree_lines_loop
    
    mov si, offset tree_line7
    mov dh, 8
    call draw_tree_lines_loop
    
    mov si, offset tree_line8
    mov dh, 9
    call draw_tree_lines_loop

    ; Trunk
    mov dh, 10
    mov dl, 39
    call draw_trunk_piece
    mov dh, 11
    mov dl, 39
    call draw_trunk_piece
    mov dh, 12
    mov dl, 39
    call draw_trunk_piece
    
    pop si
    pop dx
    pop bx
    pop ax
    ret
draw_tree endp

draw_trunk_piece proc
    mov ah, 2
    mov bh, 0
    int 10h
    mov ah, 9
    mov al, '*'
    mov bl, 6       ; Brown
    mov cx, 3
    int 10h
    ret
draw_trunk_piece endp

draw_tree_lines_loop proc
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov dl, 32      ; Center column
    mov ah, 2       
    mov bh, 0
    int 10h
    
    mov bl, 2       ; Green
    
next_tree_char:
    mov al, [si]
    cmp al, 0
    je tree_line_done
    
    cmp al, '*'
    jne skip_draw_star
    
    mov ah, 9
    mov cx, 1
    int 10h
    
skip_draw_star:
    inc si
    inc dl
    mov ah, 2
    int 10h
    jmp next_tree_char
    
tree_line_done:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
draw_tree_lines_loop endp


draw_happy_new_year proc
    ; Draw HAPPY (Left) - Red
    mov dl, 5       
    mov bl, 12      ; Light Red
    mov dh, 18      
    mov si, offset happy_line1
    call print_string_generic
    mov dh, 19
    mov si, offset happy_line2
    call print_string_generic
    mov dh, 20
    mov si, offset happy_line3
    call print_string_generic
    mov dh, 21
    mov si, offset happy_line4
    call print_string_generic
    mov dh, 22
    mov si, offset happy_line5
    call print_string_generic
    
    ; Draw NEW (Middle) - Cyan
    mov dl, 40      
    mov bl, 11      ; Light Cyan
    mov dh, 18
    mov si, offset new_line1
    call print_string_generic
    mov dh, 19
    mov si, offset new_line2
    call print_string_generic
    mov dh, 20
    mov si, offset new_line3
    call print_string_generic
    mov dh, 21
    mov si, offset new_line4
    call print_string_generic
    mov dh, 22
    mov si, offset new_line5
    call print_string_generic
    
    ; Draw YEAR (Right) - Magenta
    mov dl, 63      
    mov bl, 13      ; Light Magenta
    mov dh, 18
    mov si, offset year_line1
    call print_string_generic
    mov dh, 19
    mov si, offset year_line2
    call print_string_generic
    mov dh, 20
    mov si, offset year_line3
    call print_string_generic
    mov dh, 21
    mov si, offset year_line4
    call print_string_generic
    mov dh, 22
    mov si, offset year_line5
    call print_string_generic
    
    ret
draw_happy_new_year endp

print_string_generic proc
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov ah, 2
    mov bh, 0
    int 10h
    
generic_loop:
    mov al, [si]
    cmp al, 0
    je generic_done
    
    mov ah, 9
    mov cx, 1
    int 10h
    
    inc si
    inc dl
    mov ah, 2
    int 10h
    jmp generic_loop
    
generic_done:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_string_generic endp

flashing_lights_loop proc
main_blink_loop:
    mov si, offset light_positions

process_lights:
    mov dh, [si]        ; row
    mov dl, [si+1]      ; column

    cmp dh, 0FFh
    je blink_delay

    ; Set cursor position
    mov ah, 2
    mov bh, 0
    int 10h

    ; Get system time
    mov ah, 2Ch
    int 21h             ; DH = seconds

    ; DH mod 3
    mov al, dh
    xor ah, ah
    mov bl, 3
    div bl              ; AH = remainder (0–2)

    cmp ah, 0
    je color_red
    cmp ah, 1
    je color_yellow

    mov bl, 11          ; Cyan
    jmp draw_light

color_red:
    mov bl, 4
    jmp draw_light

color_yellow:
    mov bl, 14

draw_light:
    mov al, '*'
    mov ah, 9
    mov cx, 1
    int 10h

    add si, 2
    jmp process_lights

blink_delay:
    mov cx, 100
delay_loop:
    nop
    loop delay_loop

    jmp main_blink_loop
flashing_lights_loop endp