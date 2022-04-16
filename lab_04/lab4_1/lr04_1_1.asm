EXTRN output_X: near  ; указываем что метка output_X доступна в бругом модуле с ближайжим переходом

STK SEGMENT PARA STACK 'STACK'
	db 100 dup(0)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
	X db 'R'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG, SS:STK
main:
	mov ax, DSEG 
	mov ds, ax

	call output_X ; вызов процедуры	

	mov ax, 4c00h ; успешный выход
	int 21h       ; вызов функции DOS
CSEG ENDS

PUBLIC X          ; указываем что метка X может быть доступна в других модулях

END main

; выводит R на второй строке DOSBOX зеленным цветом
