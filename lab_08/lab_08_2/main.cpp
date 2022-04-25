// пример 2 

#include <iostream>

extern "C"
{
	void testAsm(); // подключение в код на Си/Си++ функции
                    // на другом языке программирования,
                    // выполненной в соответствии с соглашениями
                    // о вызовах Си
}
int main()
{
	int i;
	__asm {
		mov eax, 5;
		mov i, eax;
	}
	std::cout << i;
	testAsm();
	__asm {
		mov i, eax;
	}
	std::cout << i;
	return 0;
}