#start=Emulation Kit.exe#

.model small
.stack 100h

.data
A dw 1234h
B dw 0ABCh
HexBuffer db 8 dup(0)
NUMBERS db 00111111b
        db 00000110b
        db 01011011b
        db 01001111b
        db 01100110b
        db 01101101b
        db 01111101b
        db 00000111b
        db 01111111b
        db 01101111b
        db 01110111b
        db 01111100b
        db 00111001b
        db 01011110b
        db 01111001b
        db 01110001b

.code
main proc
    mov ax, @data
    mov ds, ax
    
    mov ax, 0
    mov dx, 0
    
    mov cx, 0
    mov bx, A
    shl bx, 1
    rcl cx, 1
    
    mov ax, A
    mov dx, 0
    shl ax, 1
    rcl dx, 1
    shl ax, 1
    rcl dx, 1
    shl ax, 1
    rcl dx, 1
    
    add ax, bx
    adc dx, cx
    
    mov bx, B
    mov cx, 0
    shl bx, 1
    rcl cx, 1
    
    add bx, B
    adc cx, 0
    
    add ax, bx
    adc dx, cx
    
    call ConvertToHex
    call DisplayHex
    
    mov ax, 4C00h
    int 21h
    
main endp

ConvertToHex proc
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov si, 0
    mov cx, 8
    
convert_loop:
    mov bl, dh
    shr bl, 4
    and bl, 0Fh
    
    push cx
    mov cx, 4
rotate_loop:
    shl ax, 1
    rcl dx, 1
    loop rotate_loop
    pop cx
    
    cmp bl, 9
    jbe is_digit
    add bl, 7
is_digit:
    add bl, '0'
    
    mov HexBuffer[si], bl
    inc si
    
    loop convert_loop
    
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
ConvertToHex endp

DisplayHex proc
    push ax
    push bx
    push cx
    push si
    
    mov si, 0
    mov cx, 8
    
display_loop:
    mov bl, HexBuffer[si]
    
    cmp bl, '9'
    jbe is_digit2
    sub bl, 7
is_digit2:
    sub bl, '0'
    
    mov ah, bl
    call DisplayDigit
    
    push cx
    mov cx, 1000
delay_loop:
    loop delay_loop
    pop cx
    
    inc si
    loop display_loop
    
    pop si
    pop cx
    pop bx
    pop ax
    ret
DisplayHex endp

DisplayDigit proc
    push ax
    push dx
    push si
    
    mov al, ah
    mov ah, 0
    mov si, ax
    mov al, NUMBERS[si]
    mov dx, 2037h
    out dx, al
    
    pop si
    pop dx
    pop ax
    ret
DisplayDigit endp

end main
