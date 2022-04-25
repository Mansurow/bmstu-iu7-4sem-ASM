#include <iostream>
#include <cstring>

using namespace std;

extern "C"
{
	void my_strcpy(char* dst, const char* src, int len);
}

size_t my_strlen(const char* str)
{
	size_t result = 0;
	while (*(str++) != 0)
	{
		++result;
	}

	return result;
}

size_t asm_strlen(const char* str)
{
	size_t len = 0;
	__asm {
		push ecx;
		push edi;
		xor ecx, ecx;
		mov edi, str;
		xor al, al;
		while_not_end:
			inc ecx;
/* Команда SCASB сравнивает регистр AL с байтом в ячейке памяти по адресу ES:DI 
и устанавливает флаги аналогично команде CMP. После выполнения команды, 
 регистр DI увеличивается на 1, если флаг DF = 0, или уменьшается на 1, если DF = 1. */            
			scasb;
			jne while_not_end
		dec ecx;
		mov len, ecx;
		pop edi;
		pop ecx;
	}

	return len;
}

int main()
{
	char str[100] = "Test strlen for lab_08 assambler!";
	printf("Test string: %s\n", str);
	int l = asm_strlen(str);
	cout << "asm_strlen: " << l << endl;
	l = my_strlen(str);
	cout << "my_strlen: " << l << endl;
	l = strlen(str);
	cout << "strlen: " << l << endl;

	char src[] = "Test strcpy for lab_08 assambler";
	char dst[] = "Test strcpy for lab_08 assambler";
	int len = asm_strlen(src);

	printf("Test string: %s\n", src);

	my_strcpy(dst, src, len);
	printf("Identic strings: %s\n", dst);

	char before[100] = { '0' }, 
		* middle = before + 2, 
		* after = middle + 2;

	printf("String length = %d\n", len);

	my_strcpy(middle, src, len);
	printf("Coppied string: %s\n", middle);

	my_strcpy(before, middle, len);
	printf("Copy before pointer: %s\n", before);

	my_strcpy(after, before, len);
	printf("Copy after pointer: %s\n", before);

	return 0;
}