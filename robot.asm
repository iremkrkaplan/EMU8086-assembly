#start=robot.exe#

name "robot"

#make_bin#
#cs = 500#
#ds = 500#
#ss = 500#
#sp = ffff#
#ip = 0#

r_port equ 9

TOTAL_LAMPS equ 4

START:
    MOV BL, 0
    JMP main_loop

main_loop:
    CMP BL, TOTAL_LAMPS
    JGE stop_task
    
    CALL wait_robot
    MOV AL, 4
    OUT r_port, AL
    CALL wait_exam
    IN AL, r_port + 1
    
    CMP AL, 255
    JE handle_wall
    
    CMP AL, 8
    JE handle_lamp_off
    
    CMP AL, 0
    JE move_forward
    
    JMP random_turn_and_move

handle_wall:
    CALL wait_robot
    CALL random_turn
    CALL wait_robot
    MOV AL, 4
    OUT r_port, AL
    CALL wait_exam
    IN AL, r_port + 1
    CMP AL, 255
    JE handle_wall
    JMP random_turn_and_move

handle_lamp_off:
    CALL wait_robot
    MOV AL, 5
    OUT r_port, AL
    CALL wait_robot
    INC BL
    CMP BL, TOTAL_LAMPS
    JGE stop_task
    JMP random_turn_and_move

move_forward:
    CALL wait_robot
    MOV AL, 1
    OUT r_port, AL
    JMP main_loop

random_turn_and_move:
    CALL random_turn
    CALL wait_robot
    MOV AL, 1
    OUT r_port, AL
    JMP main_loop

stop_task:
stop_loop:
    JMP stop_loop

wait_robot PROC
busy:
    IN AL, r_port + 2
    TEST AL, 00000010b
    JNZ busy
    RET
wait_robot ENDP

wait_exam PROC
busy2:
    IN AL, r_port + 2
    TEST AL, 00000001b
    JZ busy2
    RET
wait_exam ENDP

random_turn PROC
    MOV AH, 0
    INT 1Ah
    TEST DL, 1
    JZ turn_left

turn_right:
    CALL wait_robot
    MOV AL, 3
    OUT r_port, AL
    RET

turn_left:
    CALL wait_robot
    MOV AL, 2
    OUT r_port, AL
    RET

random_turn ENDP

END START
