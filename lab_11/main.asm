    .686 ; тип процессора
    .model flat, stdcall ; плоская модель памяти,  соглашение о вызовах и именовании для процедур
    option casemap:none ; различие строчных и прописных букв


main_win    proto :DWORD,:DWORD,:DWORD,:DWORD ; прототип используемой функции

; подключение функций Windows
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib


; сегмент данных
    .data
class_name        db    "win_class",0     ; имя класса окна
win_name          db    "sum of digits",0 ; заголовок окна
button_name       db    "button",0        ; имя класса кнопки
button_text       db    "add",0           ; текст на кнопке
edit_name         db    "edit",0          ; имя класса для полей ввода
format_result     db    "%d",0            ; формат результата

; сегмент неинициализированных данных
    .data?
hinstance        HINSTANCE ?      ; handle экземпляра программы
command_line      LPSTR ?         ; адрес коммандной строки
hwnd_button      HWND ?           ; handle кнопки
hwnd_edit1       HWND ?           ; handle первого поля ввода
hwnd_edit2       HWND ?           ; handle второго поля ввода
buf              db    2 dup(?) ; буфер для чтения


; сегмент постоянных данных
    .const
button_id         equ    1 ; equ - директива определения констант
edit_id           equ    2


; сегмент кода
    .code
start:
    invoke    GetModuleHandle, NULL ; получение handle экземпляра программы
    mov       hinstance, eax 
    invoke    GetCommandLine ; получение адреса командной строки
    mov       command_line, eax
    invoke    main_win, hinstance, NULL, command_line, SW_SHOWDEFAULT ; вызов программы main_win
    invoke    ExitProcess, eax ; выход из программы


; главное окно
main_win    proc    hinst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:DWORD, CmdShow:DWORD
; локальные переменные
LOCAL    wc:WNDCLASSEX ; структура для регистрации класса окна
LOCAL    msg:MSG ; для обработки сообщений
LOCAL    hwnd:HWND ; для хранения handle окна

; заполнение структуры wc
    mov    wc.cbSize, SIZEOF WNDCLASSEX ; размер
    mov    wc.style, CS_HREDRAW or CS_VREDRAW ; стили
    mov    wc.lpfnWndProc, offset sum_digits ; функция окна 
    mov    wc.cbClsExtra, NULL ; дополнительные данные окна не нужны
    mov    wc.cbWndExtra, NULL
    push   hinst
    pop    wc.hInstance ; handle экземпляра программы
    mov    wc.hbrBackground, COLOR_BTNFACE+1 ; фон
    mov    wc.lpszMenuName, NULL ; меню не нужно
    mov    wc.lpszClassName, offset class_name ; имя класса окна
    invoke    LoadIcon, NULL, IDI_APPLICATION ; стандартная иконка приложения
    mov    wc.hIcon, eax
    mov    wc.hIconSm, eax
    invoke    LoadCursor, NULL, IDC_ARROW ; мышь на окне в виде стрелки
    mov    wc.hCursor, eax
    invoke    RegisterClassEx, addr wc ; регистрация класса окна

; создание окна     
    invoke    CreateWindowEx, WS_EX_CLIENTEDGE, addr class_name,\
        addr win_name, WS_OVERLAPPEDWINDOW, CW_USEDEFAULT,\
        CW_USEDEFAULT, 300, 200, NULL, NULL, hinst, NULL
    mov    hwnd, eax ; сохраняем handle окна

    invoke    ShowWindow, hwnd, SW_SHOWNORMAL ; отображение окна
    invoke    UpdateWindow, hwnd ; перерисуем окно

; цикл обработки сообщений
.WHILE TRUE
    invoke    GetMessage, addr msg, NULL, 0, 0
.BREAK .IF(!eax)
    invoke    TranslateMessage, addr msg
    invoke    DispatchMessage, addr msg
.ENDW
    mov    eax, msg.wParam
    ret
main_win    endp


; функция окна
sum_digits    proc    hwnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

; во время окончания работы - ноль в очередь сообщений
.IF uMsg == WM_DESTROY
    invoke    PostQuitMessage, NULL
; во время создания окна
.ELSEIF uMsg == WM_CREATE
; создание первого поля ввода
    invoke    CreateWindowEx,WS_EX_CLIENTEDGE,addr edit_name,\
        NULL, WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
        ES_AUTOHSCROLL, 50, 35, 200, 25, hwnd, 8, hinstance, NULL
    mov    hwnd_edit1, eax
; создание второго поля ввода
    invoke    CreateWindowEx, WS_EX_CLIENTEDGE, addr edit_name,\
        NULL, WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
        ES_AUTOHSCROLL, 50, 105, 200, 25, hwnd, 8, hinstance, NULL
    mov    hwnd_edit2, eax
; ввод с первого поля ввода
    invoke    SetFocus, hwnd_edit1

; создание кнопки
    invoke    CreateWindowEx, NULL, addr button_name, addr button_text,\
        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,
        75, 70, 140, 25, hwnd, button_id, hinstance, NULL
    mov    hwnd_button, eax

; после нажатия кнопки
.ELSEIF uMsg == WM_COMMAND
    mov    eax, wParam ; сохраняем идентификатор команды
    .IF ax == button_id ; если идентификатор команды = идентификатору кнопки
        shr    eax, 16
            .IF ax == BN_CLICKED
            push    edi
            push    ebx
first_digit:
            invoke GetWindowText, hwnd_edit1, addr buf, 2
            xor    edi, edi
            xor    eax, eax
            xor    ebx, ebx
            mov    cx, 10
            mov    bl, byte ptr buf[edi]
            sub    bl, '0'
            mul    cx
            add    eax, ebx
            push   eax

second_digit:
            invoke GetWindowText, hwnd_edit2, addr buf, 2
            xor    edi, edi
            xor    eax, eax
            xor    ebx, ebx
            mov    cx, 10
            mov    bl, byte ptr buf[edi]
            sub    bl, '0'
            mul    cx
            add    eax, ebx
            pop    ebx
            add eax, ebx

print_result:
            invoke wsprintf, addr buf, addr format_result, eax
            invoke MessageBox, hwnd, addr buf, addr win_name, MB_OK

            pop    ebx
            pop    edi
            .ENDIF
    .ENDIF
.ELSE ; для других сообщений стандартная обработка
    invoke    DefWindowProc,hwnd,uMsg,wParam,lParam
    ret
.ENDIF
    xor    eax, eax
    ret
sum_digits    endp
end    start