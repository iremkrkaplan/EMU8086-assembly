#start=Emulation Kit.exe#

.model small
.stack 100h

.data
ValuesLow  dw 1111h, 2222h, 3333h, 4444h
ValuesHigh dw 0001h, 0002h, 0003h, 0004h
LimitLow  dw 0FFFFh
LimitHigh dw 0000h
SumLow  dw 0
SumHigh dw 0
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
    
    mov SumLow, 0
    mov SumHigh, 0
    
    mov cx, 4
    mov si, 0
    
process_loop:
    push cx
    
    mov ax, ValuesLow[si]
    mov dx, ValuesHigh[si]
    
    mov bx, dx
    mov cx, ax
    
    shl ax, 1
    rcl dx, 1
    shl ax, 1
    rcl dx, 1
    
    push dx
    push ax
    
    mov ax, cx
    mov dx, bx
    
    shr dx, 1
    rcr ax, 1
    
    pop bx
    pop cx
    
    sub bx, ax
    sbb cx, dx
    
    mov ax, SumLow
    mov dx, SumHigh
    
    add ax, bx
    adc dx, cx
    
    mov SumLow, ax
    mov SumHigh, dx
    
    add si, 2
    pop cx
    loop process_loop
    
    mov ax, SumLow
    mov dx, SumHigh
    
    cmp dx, LimitHigh
    jb sum_less
    ja sum_greater
    
    cmp ax, LimitLow
    jb sum_less
    ja sum_greater
    
    jmp convert_display
    
sum_less:
    mov ax, SumLow
    mov dx, SumHigh
    jmp convert_display
    
sum_greater:
    mov ax, 0FFFFh
    mov dx, 0FFFFh
    
convert_display:
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
    push di
    
    push dx
    push ax
    
    mov si, 0
    mov cx, 8
    
convert_loop:
    mov bl, dh
    shr bl, 4
    and bl, 0Fh
    
    cmp bl, 9
    jbe is_digit
    add bl, 7
is_digit:
    add bl, '0'
    
    mov HexBuffer[si], bl
    inc si
    
    push cx
    mov cx, 4
rotate_loop:
    shl ax, 1
    rcl dx, 1
    loop rotate_loop
    pop cx
    
    loop convert_loop
    
    pop ax
    pop dx
    
    pop di
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
