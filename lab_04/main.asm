; с двумя сегментами данных. Ввести строку цифр до 0 до 5 в
; первый сегмент, далее во 2-й байт второго сегмента записать
; сумму 2-й и 5-й цифр.

; Stack segment.
SSEG SEGMENT PARA STACK 'STACK'
    DB 100 DUP(0)
SSEG ENDS

; Buffer segment.
DSEG1 SEGMENT PARA public 'DATA'
    DB 100
    DB 0
    DB 100 DUP(0)
DSEG1 ENDS

; Result data segment.
DSEG2 SEGMENT PARA public 'DATA'
    DB 2 DUP(0)
DSEG2 ENDS

; Main code segment.
CSEG SEGMENT PARA public 'CODE'
    ASSUME CS:CSEG, DS:DSEG1, ES:DSEG2, SS:SSEG
MAIN:
    ; DATASEG1
    MOV AX, DSEG1
    MOV DS, AX

    ; Echoed input.
    MOV AH, 0AH        ; указание номер функции для ввода с помощью прерывания
    MOV DX, 0  
    INT 21H            ; вызов функции
    
    ; Sum.
    MOV DH, DS:3       ; берем из введенных данных 2-ю цифру
    SUB DH, '0'        ; отнимает от 2 цифры символ ноль         
    ADD DH, DS:6       ; сложение
    MOV ES:1, DH
    
    ; Output.
    MOV AH, 2          ; указываем адресс функции вывода символа
    MOV DL, 13         ; курсор поместить в нач. строки
    INT 21H
    MOV DL, 10         ; перевод на следующую строку
    INT 21H
    MOV DL, ES:1       ; указываем адресс результата сложения
    INT 21H
    
    MOV AH, 4CH
    INT 21H
CSEG ENDS
END MAIN