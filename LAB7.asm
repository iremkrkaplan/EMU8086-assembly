
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here 

LEA DX,MES
MOV AH,09H ;DOLAR ISARETI GORENE KADAR
INT 21H


LEA SI,palindrome
LEA DI,PALINDROME
LEA BX,PALINDROME
MOV AH,01H
NEXT:
    INT 21H
    CMP AL,0DH ;0DH ENTER CHARACTER \N 
    JE LINEEND:
    MOV [DI],AL
    INC DI
    JMP NEXT

LINEEND:
    MOV AL,'$'
    MOV [DI],AL


CALPAL:
    DEC DI ; EN SON DOLAR ISARETI KOYDUK ORNEGIN KEK$ INPUTU ICIN $ TEN K YE GELDIK
    MOV AL,[SI]
    CMP AL,[DI]     ;CMP [SI],[DI]   
    JNE NOTPAL:
    INC SI
    CMP SI,DI  ;DI DAH
    JL CALPAL:
  

PAL:           
    
    LEA DX,MES2
    MOV AH,09H
    INT 21H 
    INC DX
    MOV BX,DX
    MOV [BX],':' 
    INT 21H   
    LEA DX,MES2
    LEA DX,BX
    MOV AH,09H
    INT 21H 
    JMP END 

NOTPAL: 
     LEA DX,MES3
     MOV AH,09H
     INT 21H

END:


ret

MES DB 10,'ENTER THE STRING:$'
MES2 DB 13,10, 'THIS IS A PAL$'
MES3 DB 13,10,'THIS IS NOT A PAL$'
Palindrome db 50 dup<0>