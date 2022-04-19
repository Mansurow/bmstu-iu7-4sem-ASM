.MODEL TINY
.186

CodeSeg SEGMENT
	ASSUME CS:CodeSeg, DS:CodeSeg              ; CS и DS указывают на сегмент кода
    ORG 100h                                   ; размер PSP(Префикс программного сегмента) 
                                               ; для COM программы - 256 байтов, поэтому смещение 100h
          
                                               ; При запуске программы номер параграфа начала PSP заносится в DS
MAIN:   
    jmp INIT         

    CURRENT db 0     
    SPEED db 01fh     ; скорость автоповтора ввода символов
    OLD_BREAKING dd ? ; адресс старого прерывания  
    FLAG db 228
    
    
MY_BREAKING:
    pusha             ; сохраняет в стеке содержимое 16-битных РОН
    
    mov ah, 02h       ; 02h - функции вывода символа
    int 1ah           ; функция BIOS для получения текущего времени
                      ; прерывание BIOS 
                       
    cmp dh, CURRENT   ; сравниваем значение в dh с текущем
	mov CURRENT, dh   ;
	je end_my_breaking      ;
    
    mov al, 0F3h      ; установить параметры режима автоповтора
                      ; 60h порт данных контроллера клавиатуры для чтения  
	out 60h, al       ; инструкция OUT выводит данные из регистра AL или AX в порт ввода-вывода
	mov al, SPEED     ; новая скорость автоповтора
	out 60h, al       ; новое состояние светодиодов.
    
    dec SPEED         ; уменьшием вывод на 1 символ (30 символов - самый медленный)
	test SPEED, 01fh  ; результат битового И записывается в ZF
	jz reset          ; ZF = 1, то значит значение 0 и переходим к сбросу
	jmp end_my_breaking     
    
    reset:
        mov SPEED, 01fh  ; cброс скорость в начальное значение
    
    end_my_breaking:
        popa
        
        jmp CS:OLD_BREAKING
    
INIT:
    mov ax, 3508h     ; ah = 35h, al = номер прерывания (00H до 0ffH)
                      ; DOS 35h вектор прерывания
                      ; Возвращает значение вектора прерывания для INT (AL)      
                      ; 08h - перехвать прерывания
                      ; !!! Меняет сегментный регистр ES
                      ; ES:BX = адрес обработчика прерывания
    int 21h           ; Определить адрес обработчика.              
    
    cmp es:FLAG, 228  ; если уже был перехват нашей программой то возвращаем к старому значению
    je UNINSTALL
    
    jmp INSTALL
    
INSTALL:    
  
    mov word ptr OLD_BREAKING, BX 	     ; сохранение смещения обработчика, 
                                         ; т.к. 35h хранит данные в ES:BX или ES:[AL * 4]
	mov word ptr OLD_BREAKING + 2, ES    ; сохранение сегмента обработчика
    
    mov ax, 2508h               ; установка адреса нового обработчика
                                ; ah = 25h al = номер прерывания (00H до 0ffH)    
	mov dx, offset MY_BREAKING  ; указание смещения нашего обработчика
    int 21h                     ; вызов DOS - функции  
    
    mov dx, offset INIT         ; смещение команды, начиная с которой фрагмент программы 
                                ; может быть удалён из памяти
	int 27h                     ; новый обработчик будет резидентным.
    
UNINSTALL:    
    pusha

    
    mov dx, word ptr ES:OLD_BREAKING
	mov ds, word ptr ES:OLD_BREAKING + 2
	
	mov ax, 2508h
	int 21h
    
    mov al, 0F3h
	out 60h, al
	mov al, 0
	out 60h, al
    
    popa
    
    mov ah, 49h ; Установить режим передачи
	int 21h     ; вызов DOS
    
    mov ax, 4c00h
    int 21h
CodeSeg ENDS    
END MAIN