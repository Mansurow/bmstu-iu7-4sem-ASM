EXTRN INPUT_ACTION: NEAR
EXTRN INPUT_SIGNED_DEC: NEAR
EXTRN OUT_SIGNED_BIN: NEAR
EXTRN OUT_SIGNED_DEC: NEAR
EXTRN OUT_UNSIGNED_HEX: NEAR
EXTRN NEWLINE_PRINT: NEAR

PUBLIC EXIT

STACKSEG SEGMENT PARA STACK 'STACK'
    DB 200H DUP(0)
STACKSEG ENDS

DATASEG SEGMENT PARA PUBLIC 'DATA'
    MENU DB 'Available actions:', 13, 10, 10
        DB '1. Input signed decimal number;', 13, 10
        DB '2. Ouput signed decimal number;', 13, 10
        DB '3. Convert to unsigned hexadecimal;', 13, 10
        DB '4. Convert to signed binary;', 13, 10, 10
        DB '0. Exit program.', 13, 10, 10
        DB 'Choose action: $'
        
    ACTIONS DW EXIT, INPUT_SIGNED_DEC, OUT_SIGNED_DEC, OUT_UNSIGNED_HEX, OUT_SIGNED_BIN
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG, SS:STACKSEG
    
MAIN:
    mov ax, DATASEG
    mov ds, ax
    
    START:
    mov dx, offset MENU
    mov ah, 09h
    int 21h
    
    call INPUT_ACTION
    call ACTIONS[si]
    jmp START
    
EXIT PROC NEAR
    mov ax, 4c00h
    int 21h
EXIT ENDP
 
CODESEG ENDS
END MAIN    