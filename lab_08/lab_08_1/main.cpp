// пример 1 

#include <iostream>

int main()
{
    int i;
    __asm{
        mov eax, 5;
        mov i, eax;
    }
    std::cout << i;
    return 0;
}