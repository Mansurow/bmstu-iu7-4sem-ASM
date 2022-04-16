PUBLIC X        ; метка X может быть доступна другим модулям
EXTRN exit: far ; метка exit доступна из другого модуля по дальному переходу

SSTK SEGMENT para STACK 'STACK'
	db 100 dup(0)
SSTK ENDS

SD1 SEGMENT para public 'DATA'
	X db 'X'
SD1 ENDS

SC1 SEGMENT para public 'CODE'
	assume CS:SC1, DS:SD1
main:	
	jmp exit ; безусловный переход на метку exit
SC1 ENDS
END main