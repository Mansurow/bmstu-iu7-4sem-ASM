EXTRN TO_SIGNED_BIN: NEAR
EXTRN TO_SIGNED_DEC: NEAR
EXTRN TO_UNSIGNED_HEX : NEAR

EXTRN UHEX: BYTE
EXTRN SBIN: BYTE
EXTRN SDEC: BYTE
EXTRN SIGN: BYTE

PUBLIC OUT_SIGNED_BIN
PUBLIC OUT_SIGNED_DEC
PUBLIC OUT_UNSIGNED_HEX
PUBLIC NEWLINE_PRINT

DATASEG SEGMENT PARA PUBLIC 'DATA'
    OUT_SDEC_MSG DB 'Signed decimal number: $'
    OUT_UHEX_MSG DB 'Unsigned hexadecimal number:  $'
    OUT_SBIN_MSG DB 'Signed binary number: $'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

NEWLINE_PRINT PROC NEAR                   
    
    mov ah, 02h
    mov dl, 10
    int 21h
   
    ret  
NEWLINE_PRINT ENDP 
    
OUT_SIGNED_BIN PROC NEAR
    
    call NEWLINE_PRINT

    mov DX, OFFSET OUT_SBIN_MSG
    mov ah, 09h
    int 21H
    
    
    
    call TO_SIGNED_BIN

    mov ah, 09h
    mov dx, OFFSET SBIN
    int 21h
    
    call NEWLINE_PRINT
    call NEWLINE_PRINT
    
    RET
OUT_SIGNED_BIN ENDP

OUT_SIGNED_DEC PROC NEAR

    call NEWLINE_PRINT
    
    mov DX, OFFSET OUT_SDEC_MSG
    mov ah, 09h
    int 21H

    call TO_SIGNED_DEC

    mov ah, 09h
    mov dx, OFFSET SDEC
    INT 21h
    
    call NEWLINE_PRINT
    call NEWLINE_PRINT
    
    ret
OUT_SIGNED_DEC ENDP

OUT_UNSIGNED_HEX PROC NEAR

    call NEWLINE_PRINT
    
    mov DX, OFFSET OUT_UHEX_MSG
    mov ah, 09h
    int 21H

    call TO_UNSIGNED_HEX

    mov ah, 09h
    mov dx, OFFSET UHEX
    int 21h
    
    call NEWLINE_PRINT
    call NEWLINE_PRINT
    
    ret
OUT_UNSIGNED_HEX ENDP

CODESEG ENDS
END  