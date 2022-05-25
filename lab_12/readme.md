# Лабораторная работа 10 “Математический сопроцессор”

## Условие
С помощью x64dbg, IDA Freeware или других дизассемблеров/отладчиков определить
пароль, необходимый для получения сообщения "congrats you cracked the password" в
прикреплённой программе

## Процесс

Скачать [IDA Freeware и .exe](https://drive.google.com/drive/u/0/folders/15d5tq85jYTIIs9tT2a_5l_w2ysexK2VZ), _архив lab_12_

После того как сказали, запустили и указали путь к .exe файла

![image](https://user-images.githubusercontent.com/62243773/170366842-17072ac8-6066-474e-a932-aa9624e9173d.png)

Здесь в строчках находится наш пароль и еще его можно посмотреть в стеке:
```
mov     dword ptr [esp+38h], 73736170h
mov     dword ptr [esp+3Ch], 64726F77h
mov     dword ptr [esp+40h], 333231h
```
