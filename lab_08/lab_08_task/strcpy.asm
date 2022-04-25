.686
.model flat, c
.stack
.code

public my_strcpy

my_strcpy proc
                ; my_strcpy(edx, ecx, eax)
    mov esi, ecx; ecx = src
    mov edi, edx; edx = dst
    mov ecx, eax; eax = len

    cmp edi, esi; src == dst ? quit : not_equal()
    je exit

not_equal : ; строки не перекрываются
    cmp edi, esi; edi < esi == dst < src
	jl copy

	mov eax, ediыЫыы
	sub eax, esi

	cmp eax, ecx
	jge copy

complicated_copy : ; строки перекрываются
	add edi, ecx; смещаемся на длину и копируем с конца
	add esi, ecx
	sub esi, 1
	sub edi, 1
	std; df = 1

	copy:
    rep movsb; from esi to edi while df == 0  len == ecx раз
    cld; df = 0
exit:
    ret
my_strcpy endp

end