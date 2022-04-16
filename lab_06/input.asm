EXTRN NEWLINE_PRINT: NEAR
EXTRN EXIT: NEAR

PUBLIC SIGN
PUBLIC NUMBER
PUBLIC INPUT_SIGNED_DEC
PUBLIC INPUT_ACTION

DATASEG SEGMENT PARA PUBLIC 'DATA'
    NUMBER DW 0
    SIGN DB ' '
    INPUT_MSG DB 'Enter signed decimal number: $'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

INPUT_ACTION PROC NEAR
    
    MOV AH, 1
    INT 21H
    
    cmp al, 13
    je EXIT
    
    sub al, '0'
    mov cl, 2
    mul cl
    mov SI, AX
    ret            
    
INPUT_ACTION ENDP

ADD_FIGURE PROC NEAR
    mov cl, al
    mov ax, 10
    mul bx
    mov bx, ax
    mov ch, 0
    sub cl, '0'
    add bx, cx
    ret
ADD_FIGURE ENDP

INPUT_SIGNED_DEC PROC NEAR
    
     call NEWLINE_PRINT   
     mov dx, offset INPUT_MSG
     mov ah, 09h
     int 21h
     
     mov sign, 0               ; инцилизация знака числа
     mov bx, 0                 ; инцилизация используемых РОР
     mov dx, 0
     
     mov ah, 01h               ; ввод символа
     int 21h
     
     cmp al, 13                ; сравнивает если ничего не ввели
     je ENDINPUT
     
     cmp al, "-"               ; сравниваем отрицательное ли число
     jne POS_NUM
     
     mov dh, al
     mov sign, dh   
     jmp INPUT_FIGURE
     
     POS_NUM:
     call ADD_FIGURE
     
     INPUT_FIGURE:
        mov ah, 01h               ; ввод символа
        int 21h
        
        cmp al, 13                ; сравнивает если ничего не ввели
        je ENDINPUT
        
        call ADD_FIGURE
        JMP INPUT_FIGURE
     
     ENDINPUT:
     mov dh, SIGN
     cmp dh, '-'
     jne NOTNEG
     
     neg bx
     NOTNEG:   
     mov NUMBER, bx
     
     ret   
INPUT_SIGNED_DEC ENDP
    
CODESEG ENDS
END    