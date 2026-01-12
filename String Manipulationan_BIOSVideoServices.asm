org 100h

.data
    msg1 db 'Enter first number: $'
    msg2 db 0Dh, 0Ah, 'Enter second number: $'
    msg3 db 0Dh, 0Ah, 'Sum: $'
    msg4 db 0Dh, 0Ah, 'Difference: $'
    msg5 db 0Dh, 0Ah, 'Press any key to exit...$'
    num1 db ?
    num2 db ?
    result db ?

.code
main proc
    ; Display message 1
    mov dx, offset msg1
    mov ah, 09h
    int 21h
    
    ; Read first number
    mov ah, 01h
    int 21h
    sub al, 30h     
    mov num1, al
    
    ; Display message 2
    mov dx, offset msg2
    mov ah, 09h
    int 21h
    
    ; Read second number
    mov ah, 01h
    int 21h
    sub al, 30h    
    mov num2, al
    
    ; Calculate sum
    mov al, num1
    add al, num2
    mov result, al
    
    ; Display sum message
    mov dx, offset msg3
    mov ah, 09h
    int 21h
    
    ; Display sum result
    mov al, result
    add al, 30h
    mov dl, al
    mov ah, 02h
    int 21h
    
    ; Calculate difference
    mov al, num1
    sub al, num2
    mov result, al
    
    ; Display difference message
    mov dx, offset msg4
    mov ah, 09h
    int 21h
    
    ; Display difference result
    mov al, result
    add al, 30h
    mov dl, al
    mov ah, 02h
    int 21h
    
    ; Wait for key press
    mov dx, offset msg5
    mov ah, 09h
    int 21h
    
    mov ah, 01h
    int 21h
    
    ; Exit program
    mov ah, 4Ch
    int 21h
    
main endp
end main
