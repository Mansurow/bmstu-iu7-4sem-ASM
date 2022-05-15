#include <iostream>
#include <ctime>
#include <cmath>

using namespace std;

//       float - 6-7 чисел (32-разрядная)
//      double - 15 чисел  (64-разрядная)
//   __float80 - 19 чисел  (80-разрядная)
// long double - 19 чисел  (80-разрядная)

#define PRESION "%s %f %s %f = %g\n" 
#define TIMES 1e5

void cout_time(clock_t time, const char* action)
{
    if (time >= 1000)
        cout << "   " << action << ": " << ((double)time) / CLOCKS_PER_SEC / TIMES << " s.";
    else
        cout << "   " << action << ": " << ((double)time) / TIMES << " ms.";
}


template <typename Type>
Type sum(Type a, Type b)
{
    Type result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        result = a + b;
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Sum");

    return result;
}

template <typename Type>
Type sum_asm(Type a, Type b)
{
    Type result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        // fld загружает на вершину стека
        // faddp складывает ST(1) и ST(0), сохраняем результат в ST(1) и извлекаем из стека сопроцессора (поэтому 'p' в названии команды)
        // fstp извлекаем число из FPU в память, в данном случае из ST(0) в result
        start_time = clock();
        __asm {
            fld a
            fld b
            faddp ST(1), ST(0)
            fstp result
        }
        res_time += clock() - start_time;
    }
    
    cout_time(res_time, "Sum");
    
    return result;
}

template <typename Type>
Type mul(Type a, Type b)
{
    Type result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        result = a * b;
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Mul");

    return result;
}

template <typename Type>
Type mul_asm(Type a, Type b)
{
    Type result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        // fld загружает на вершину стека
        // fmulp умножает ST(1) и ST(0), сохраняем результат в ST(1) и извлекаем из стека сопроцессора (поэтому 'p' в названии команды)
        // fstp извлекаем число из FPU в память, в данном случае из ST(0) в result
        start_time = clock();
        __asm {
            fld a               
            fld b               
            fmulp ST(1), ST(0)  
            fstp result         
        }
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Mul");

    return result;
}

template <typename Type>
Type sub(Type a, Type b)
{
    Type result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        result = a - b;
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Sub");

    return result;
}

template <typename Type>
Type sub_asm(Type a, Type b)
{
    Type result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        // fld загружает на вершину стека
        // fsubp отнимает ST(1) - ST(0), сохраняем результат в ST(1) и извлекаем из стека сопроцессора (поэтому 'p' в названии команды)
        // fstp извлекаем число из FPU в память, в данном случае из ST(0) в result
        start_time = clock();
        __asm {
            fld a
            fld b
            fsubp ST(1), ST(0)
            fstp result
        }
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Sub");

    return result;
}

template <typename Type>
Type div(Type a, Type b)
{
    Type result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        result = a / b;
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Div");

    return result;
}

template <typename Type>
Type div_asm(Type a, Type b)
{
    Type result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        // fld загружает на вершину стека
        // fdivp делит ST(1) / ST(0), сохраняем результат в ST(1) и извлекаем из стека сопроцессора (поэтому 'p' в названии команды)
        // fstp извлекаем число из FPU в память, в данном случае из ST(0) в result
        start_time = clock();
        __asm {
            fld a
            fld b
            fdivp ST(1), ST(0)
            fstp result
        }
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Div");

    return result;
}

template <typename Type>
void time_measure(Type a, Type b)
{
   /* cout << "Sum opearation:" << endl;
    printf(PRESION, "  ", a, "+", b, sum_asm(a, b));
    printf(PRESION, "  ", a, "+", b, sum(a, b));

    cout << "Mul opearation:" << endl;
    printf(PRESION, "  ", a, "*", b, mul_asm(a, b));
    printf(PRESION, "  ", a, "*", b, mul(a, b));

    cout << "Sub opearation:" << endl;
    printf(PRESION, "  ", a, "-", b, sub_asm(a, b));
    printf(PRESION, "  ", a, "-", b, sub(a, b));

    cout << "Div opearation:" << endl;
    printf(PRESION, "  ", a, "/", b, div_asm(a, b));
    printf(PRESION, "  ", a, "/", b, div(a, b));*/

    
    cout << "   ASM:";
    sum_asm(a, b);
    mul_asm(a, b);
    sub_asm(a, b);
    div_asm(a, b);
    cout << endl << "   CPP:";
    sum(a, b);
    mul(a, b);
    sub(a, b);
    div(a, b);
}

double sin_asm()
{
    double result = 0.0;
    __asm
    {
        fldpi      
        fsin
        fstp result
    }
    return result;
}

double sin_half_asm()
{
    double result = 0.0;
    double divide = 2.0;
    __asm
    {
        fldpi
        fld divide;
        fdiv
        fsin
        fstp result
    }
    return result;
}


int main()
{
    float f1 = 1.1f;
    float f2 = 2.3f;
    cout << "FLOAT:" << endl;
    time_measure(f1, f2);

    double d1 = 2.3;
    double d2 = 5.6;
    cout << "\nDOUBLE:" << endl;
    time_measure(d1, d2);

    long double ld1 = 2.3;
    long double ld2 = 5.6;
    cout << "\nLONG DOUBLE:" << endl;
    time_measure(ld1, ld2);

    cout << endl << "CMP sin():" << endl;
    printf("sin(3.14)         = %.20f\n", sin(3.14));
    printf("sin(3.141596)     = %.20f\n", sin(3.141596));
    //printf("sin(M_PI)         = %.20f\n", sin(M_PI));
    printf("sin_asm(3.141596) = %.20f\n", sin_asm());
    cout << endl;
    printf("sin(3.14 / 2)          = %.20f\n", sin(3.14 / 2.0));
    printf("sin(3.141596 / 2)      = %.20f\n", sin(3.141596 / 2.0));
    //printf("sin(M_PI/ 2.0)         = %.20f\n", sin(M_PI / 2.0));
    printf("sin_half_asm(3.141596) = %.20f\n", sin_half_asm());
    
}
