; Требуется составить программу на языке ассемблера, которая обеспечит ввод
; матрицы, преобразование согласно индивидуальному заданию и вывод изменённой
; матрицы.
; В программе должна быть выделена память под матрицу 9х9. Фактический размер
; задаётся пользователем и не превышает 9х9.
; Матрицу считать статической (как если бы в Си она была объявлена char a[9][9]) и
; работать с ней соответствующим образом.
; Тип матрицы “символьная” означает, что элементом матрицы является один символ.
; Тип “цифровая” означает, что элементом является цифра.
; Для решения задачи можно вводить дополнительные переменные, в том числе
; массивы
; мой вариант задания
; поменять местами соседние строки (1 и 2, 3 и 4 и т. д.)
; прямоугольная цифровая

SSEG SEGMENT para STACK 'STACK'
	db 100 dup(0)
SSEG ENDS

DSEGMATRIX SEGMENT para public 'DATA'
	N db 0
	M db 0
    M_MAX db 9
    N_MAX db 9
	MATRIX db 9 * 9 dup(0)
DSEGMATRIX ENDS

DSEGMSG SEGMENT para public 'DATA'
    NMSG db 'Enter N:$'
    MMSG db 'Enter M:$'
	MATRIXMSG db 'Enter matrix:$'
    RESULTMSG db 'RESULT:$'
DSEGMSG ENDS

CSEG SEGMENT para public 'DATA'
    ASSUME CS:CSEG, SS:SSEG, DS:DSEGMSG, ES:DSEGMATRIX

msg_print proc               ; процедура вывода сообщения                    
    
    mov ax, dx               ; указываем что выводим
    mov ah, 9                ; указываем что будет вызвана функция вывода строки
    int 21h                  ; DOS функция
    
    ret                      ; выход
msg_print endp

newline_print proc           ; процедура вывод новой строки
    
    mov ah, 02h              ; указываем что будем выводить символ
    mov dl, 10               ; символ новой строки
    int 21h                  ; DOS функция
    mov dl, 13               ; переводим указатель на начало
    int 21h                  ; DOS функция
    ret                      ; выход
    
newline_print endp

print_number proc            ; процедура вывода числа             
    
    push dx                  ; так в dh число то отправлем его в стек
    mov ah, 02h              ; указываем что будем выводить символ
    mov dl, ' '              ; указываем что выводем пробел
    int 21h                  ; DOS функция
    pop dx                   ; достаем из стека число
    
    add dh, '0'              ; прибавляем к числу 48 или '0', так оно выводится как символ ASCII
	mov dl, dh               ; так для вывода dl то записываем его из dh
	int 21h

    ret
print_number endp

read_number proc            ; процедура считывания числа

    mov ah, 02h
    mov dl, ' '
    int 21h
    
    mov ah, 01h
    int 21h
    mov dh, al              ; в al cчитано само число как символ
    sub dh, '0'
    
    ret
read_number endp

read_matrix proc           ; процедура чтения матрицы
    mov cx, 0              
    mov cl, N              ; сl присваиваем N
    mov bx, 0
    
    cmp cx, 0
    jle out_proc
    
    read_row_loop:         ; чтение строк
        push cx            ; cx предедущего цикла в стек
        mov cl, M
        mov si, 0
    
        cmp cx, 0
        jle out_change
        
        read_element_loop:       ; чтение элементов
            call read_number
            mov matrix[bx][si], dh      ; записываем число в матрицу из dh, так как прочитали туда
            inc si                      ; si++
            loop read_element_loop     
        call newline_print              ; вывод новой строки
        add bl, M_MAX                   ; bx + M_MAX  
           
        pop cx                          ; достаем из стека cx
        loop read_row_loop              
       
    ret
read_matrix endp

print_matrix proc        ; процедура вывода матрицы   
    mov cx, 0
    mov cl, N
    mov bx, 0
    
    cmp cx, 0
    jle out_proc
        
    print_row_loop:
        push cx
        mov cl, M
        mov si, 0
        
        cmp cx, 0
        jle out_change
        
        print_element_loop:
            mov dh, matrix[bx][si]        ; в dh кладем само значение чтобы предать в print_matrix
            call print_number
            inc si
            loop print_element_loop
        call newline_print
        add bl, M_MAX        
        pop cx
        loop print_row_loop
        
    ret
print_matrix endp

out_proc:   ; вывход из процедуры по неверным данным 
    ret

out_change: ; выход если в цикле по чтению, выводу и обмену по строкам мамтрицы, ошибка
   pop cx
   ret

change_matrix proc   ; процедура обмена 1 и 2, 3 и 4 - элементами

    mov ax, 0
    mov bl, 2 ; считаем количество обменов для цикла exchange_element_loop
    mov al, M
    div bl 
    
    mov cx, 0
    mov cl, N
    mov bx, 0
    
    cmp cx, 0
    jle out_proc
    
    line_loop:
        push cx   
        
        mov si, 0
        mov cl, al 
        
        cmp cx, 0
        jle out_change

        exchange_element_loop:            
            xchg ah, matrix[bx][si]     ; обмен элементами
            xchg ah, matrix[bx][si + 1]
            xchg ah, matrix[bx][si]
            add si, 2
            loop exchange_element_loop  
        add bl, M_MAX        
        pop cx
        loop line_loop
         
    ret
change_matrix endp

main:        
    mov ax, DSEGMSG
    mov ds, ax 
    
    mov ax, DSEGMATRIX
    mov es, ax
        
    mov dx, offset NMSG
    call msg_print
    
    call read_number 
    mov N, dh    
    call newline_print
    
    mov dx, offset MMSG
    call msg_print
    
    call read_number
    mov M, dh
    call newline_print    
    
    mov dx, offset MATRIXMSG
    call msg_print
    call newline_print
    
    call read_matrix
    
    call change_matrix
    
    mov dx, offset RESULTMSG
    call msg_print
    call newline_print
    
    call print_matrix    
    
    mov ax, 4c00h
    int 21h
CSEG ENDS
END main
