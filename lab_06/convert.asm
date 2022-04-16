EXTRN NUMBER : WORD
EXTRN SIGN : BYTE

PUBLIC UHEX
PUBLIC SBIN
PUBLIC SDEC

PUBLIC TO_SIGNED_BIN
PUBLIC TO_SIGNED_DEC
PUBLIC TO_UNSIGNED_HEX

DATASEG SEGMENT PARA PUBLIC 'DATA'
    MASK16 DW 15
    MASK2 DW 1
    UHEX DB 4 DUP(0), '$'
    SDEC DB 6 DUP(0), '$'
    SBIN DB 17 DUP(0),'$'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

TO_SIGNED_DEC PROC NEAR  ; перевод в 10 сс
        
    mov dh, SIGN         ; смотрим знак числа   
    mov cx, NUMBER       
    cmp dh, "-"          
    jne DEC_POS           ; при положительном не записываем в 1 стариший бит '-'
    mov SDEC[0], '-'
    neg cx
    DEC_POS:
    mov ax, 1      ; Счетчик степени
	mov si, 16     ; Счетчик цикла
	xor bx, bx     ; Переведенное число
    
    convert:
		mov dx, cx
		and dx, MASK2 ; 0 или 1
		
		cmp dx, 0
		je index
        add bx, ax
		
		index:
		
		shl ax, 1
		shr cx, 1
		dec si
		jnz convert
		
	mov ax, bx
	mov cx, 10        ; Делитель для получения последней цифры
	mov si, 5
	
	DIGIT_TO_SYMB:
		xor dx, dx
		div cx
		add dl, '0'
		mov SDEC[si], dl
		dec SI
		cmp si, 0
        jne DIGIT_TO_SYMB
  
    ret
TO_SIGNED_DEC ENDP

TO_UNSIGNED_HEX PROC NEAR   ; переводим в безнаковое 16 сс

    mov ax, NUMBER
    mov si, 3               
    convert_hex:
        mov dx, ax
        and dx, MASK16
        cmp dl, 10          ; доходим до 10, то число у нас F 
        jb ISDIGIT
        add dl, 7           ; прибавляем к числу 7
        
        ISDIGIT:
        add dl, '0'         ; переводим число в символ
        mov UHEX[SI], dl    ; записываем в буфер
        mov cl, 4
        sar ax, cl          ; сдвигаемся на 4, т.к одно 16-е число предст. 4-мя 2-ми
        dec si
        cmp si, -1
        jne convert_hex
        
    ret
TO_UNSIGNED_HEX ENDP

TO_SIGNED_BIN PROC NEAR   ; перевод в знаковую 2 сс

    mov dh, SIGN
    mov ax, NUMBER
    cmp dh, "-"          ; смотрим на clзнак
    jne BIN_POS
    neg ax
    mov SBIN[0], "-"
    BIN_POS:
    mov si, 16
    CONVERT_BIN:
        mov dx, ax
        and dx, MASK21
        add dl, '0'
        mov SBIN[si], dl
        mov cl, 1
        sar ax, cl
        dec si
        cmp si, 0
        jne CONVERT_BIN
                    
    ret
TO_SIGNED_BIN ENDP
    
CODESEG ENDS
END    