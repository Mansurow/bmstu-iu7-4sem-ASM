SD1 SEGMENT para common 'DATA' ; так как тип common то данные налажываются друг на друга и хранятся по одному и тому же адресу
	C1 LABEL byte    
	ORG 1h           ; смещение на 1 байт
	C2 LABEL byte
SD1 ENDS

CSEG SEGMENT para 'CODE'
	ASSUME CS:CSEG, DS:SD1
main:
	mov ax, SD1
	mov ds, ax
	mov ah, 2   ; функция вывода символа
	mov dl, C1
	int 21h
	mov dl, C2
	int 21h
	mov ax, 4c00h ; успешное завершение программы
	int 21h
CSEG ENDS
END main

; вывод D4