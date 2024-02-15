org 100h       

mov si,2000h
mov di,2004h
mov cl,4

mov dl,5
mov bl,1

put_values:
mov [si],bl
mov [di],dl
inc si
inc di
inc dl
inc bl
loop put_values

mov si,2000h
mov di,2004h
mov cl,4     

swap:
    mov al,[si]
    mov dl,[di]
    mov [si],dl
    mov [di],al
    inc si
    inc di
    loop swap
ret