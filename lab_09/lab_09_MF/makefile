# Пояснение про некоторые опции gcc:
# -m80387 - заставляет компилятор генерировать инструкции для операций с плавающей запятой
# -mno-80387 - заставляет компилятор генерировать инструкции, использующие библиотечные вызовы для операций с плавающей запятой
# -mno-sse - запрещаем компилятору использовать регистры XMM/MMX и инструкции SSE

# Ключ -mno-sse ОПЦИОНАЛЕН!!!!! (по крайней мере, на компьютере автора) Без него компилятор генерирует те же самые инструкции 
# (не используя регистры XMM/MMX и инструкции SSE), потому что ключ -m80387 уже заставляет компилятор отключить SSE.
# Из последней ссылки из readme к лабе: "При их компиляции с параметром -O0 gcc использует регистры XMM/MMX и инструкции SSE, 
# если специально не заданы параметры -mno-sse (и другие)".
# Слово "другие", видимо, является ключевым.

# Также по ходу дела выяснилось, что для распознавания интеловского синтаксиса (а не нативного под gcc) достаточно компиляции с опцией -masm=intel,
# и не обязательно в начале каждой вставки указывать ".intel_syntax noprefix".

_MAKE_OUT_DIR_ := $(shell mkdir -p out)
_MAKE_ASM_DIR_ := $(shell mkdir -p assembly)
_MAKE_DISASM_DIR_ := $(shell mkdir -p disassembly)
 
.PHONY: math_sse math_fpu math_asm math pi run assembly disassembly clean

math_sse:
	@echo
	@echo "SSE: "
	g++ main_math.cpp -mno-80387 -DSSE -O0 -o math_sse.exe
	./math_sse.exe

math_fpu:
	@echo
	@echo "FPU: "
	g++ main_math.cpp -m80387 -mno-sse -DFLOAT_80 -O0 -o math_fpu.exe
	./math_fpu.exe

math_asm:
	@echo
	@echo "ASM: "
	g++ main_math.cpp -masm=intel -DASM -O0 -o math_asm.exe
	./math_asm.exe

math: math_sse math_fpu math_asm

sin:
	@echo
	g++ main_sin.cpp -masm=intel -o cmp_sin.exe
	./cmp_sin.exe

run_all: math sin

# Посмотреть ассемблерный код можно 2 способами:

assembly:
	g++ -S main_math.cpp -mno-80387 -DSSE -O0 -o assembly/math_sse.s
	g++ -S main_math.cpp -m80387 -mno-sse -DFLOAT_80 -O0 -o assembly/math_fpu.s
	g++ -S main_math.cpp -masm=intel -DASM -O0 -o assembly/math_asm.s
	g++ -S main_sin.cpp -masm=intel -o assembly/main_sin.s

disassembly:
	g++ -c main_math.cpp -mno-80387 -DSSE -O0 -o out/math_sse.o
	g++ -c main_math.cpp -m80387 -mno-sse -DFLOAT_80 -O0 -o out/math_fpu.o
	g++ -c main_math.cpp -masm=intel -DASM -O0 -o out/math_asm.o
	g++ -c main_sin.cpp -masm=intel -o out/main_sin.o
	objdump -M intel-mnemonic -d out/math_sse.o  > disassembly/math_sse.txt
	objdump -M intel-mnemonic -d out/math_fpu.o  > disassembly/math_fpu.txt
	objdump -M intel-mnemonic -d out/math_asm.o  > disassembly/math_asm.txt
	objdump -M intel-mnemonic -d out/main_sin.o  > disassembly/main_sin.txt

clean:
	rm -rf out/* assembly/* disassembly/* *.exe

