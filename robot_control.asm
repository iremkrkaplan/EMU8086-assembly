.model small
.stack 100h

.data
LAMPS_ON db 0
TOTAL_LAMPS equ 4

.code
main proc
    mov ax, @data
    mov ds, ax
    
    mov LAMPS_ON, 0
    
navigation_loop:
    call wait_robot
    mov al, 4
    out 9, al
    
    call wait_robot
    in al, 10
    
    cmp al, 255
    je wall_detected
    
    cmp al, 8
    je lamp_detected
    
    cmp al, 0
    je empty_space
    
    jmp navigation_loop

wall_detected:
    call random_turn
    jmp navigation_loop

lamp_detected:
    call wait_robot
    mov al, 5
    out 9, al
    
    inc LAMPS_ON
    mov al, LAMPS_ON
    cmp al, TOTAL_LAMPS
    je task_complete
    
    call wait_robot
    mov al, 4
    out 9, al
    jmp navigation_loop

empty_space:
    call wait_robot
    mov al, 1
    out 9, al
    jmp navigation_loop

task_complete:
    jmp task_complete

wait_robot proc
    push ax
wait_loop:
    in al, 11
    test al, 10b
    jnz wait_loop
    pop ax
    ret
wait_robot endp

random_turn proc
    push ax
    push dx
    
turn_check:
    mov ah, 0
    int 1Ah
    test dl, 1
    jz turn_left
    jmp turn_right

turn_left:
    call wait_robot
    mov al, 2
    out 9, al
    call wait_robot
    mov al, 4
    out 9, al
    call wait_robot
    in al, 10
    cmp al, 255
    je turn_again
    pop dx
    pop ax
    ret

turn_right:
    call wait_robot
    mov al, 3
    out 9, al
    call wait_robot
    mov al, 4
    out 9, al
    call wait_robot
    in al, 10
    cmp al, 255
    je turn_again
    pop dx
    pop ax
    ret

turn_again:
    mov ah, 0
    int 1Ah
    test dl, 1
    jz turn_left
    jmp turn_right

random_turn endp

main endp
end main

