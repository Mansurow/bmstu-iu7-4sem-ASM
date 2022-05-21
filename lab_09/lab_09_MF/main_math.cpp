//       float - 6-7 чисел (32-разрядная)
//      double - 15 чисел  (64-разрядная)
//   __float80 - 19 чисел  (80-разрядная)
// long double - 19 чисел  (80-разрядная)

#include <iostream>
#include <ctime>
#include <cmath>

using namespace std;

#define PRESION "%s %f %s %f = %g\n" 
#define TIMES 1e7

void cout_time(clock_t time, const char* action)
{
    if (time >= 1000)
        cout << "   " << action << ": " << ((double)time) / CLOCKS_PER_SEC << " s.";
    else
        cout << "   " << action << ": " << ((double)time) << " ms.";
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
#ifdef ASM
template <typename Type>
Type sum_asm(Type a, Type b)
{
    Type result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        __asm__(
            "fld %1\n"                                          // загружаем a на вершину стека
            "fld %2\n"                                          // загружаем b на вершину стека
            "faddp %%ST(1), %%ST(0)\n"                          // складываем ST(1) и ST(0), сохраняем результат в ST(1) и извлекаем из стека сопроцессора (поэтому 'p' в названии команды)
            "fstp %0\n"                                         // извлекаем число из FPU в память, в данном случае из ST(0) в res
            : "=m"(result)                                      // res - выходной параметр
            : "m"(a),                                           // a - входной параметр
              "m"(b)                                            // b - входной параметр
        );
        res_time += clock() - start_time;
    }
    
    cout_time(res_time, "Sum");
    
    return result;
}

template <typename Type>
Type mul_asm(Type a, Type b)
{
    Type result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        __asm__
        (
            "fld %1\n"
            "fld %2\n"
            "fmulp %%ST(1), %%ST(0)\n"
            "fstp %0\n"
            :"=m"(result)
            : "m"(a),
            "m"(b)
        );
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Mul");

    return result;
}

template <typename Type>
Type sub_asm(Type a, Type b)
{
    Type result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        __asm__
        (
            "fld %1\n"
            "fld %2\n"
            "fsubp %%ST(1), %%ST(0)\n"
            "fstp %0\n"
            :"=m"(result)
            : "m"(a),
            "m"(b)
        );
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Sub");

    return result;
}

template <typename Type>
Type div_asm(Type a, Type b)
{
    Type result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        __asm__
        (
            "fld %1\n"
            "fld %2\n"
            "fdivp %%ST(1), %%ST(0)\n"
            "fstp %0\n"
            :"=m"(result)
            : "m"(a),
              "m"(b)
        );
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Div");

    return result;
}
#endif

template <typename Type>
void time_measure(Type a, Type b)
{
    /*cout << "Sum opearation:" << endl;
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

    #ifdef ASM
    cout << "   ASM:";
    sum_asm(a, b);
    mul_asm(a, b);
    sub_asm(a, b);
    div_asm(a, b);
    #else
    cout << "   CPP:";
    sum(a, b);
    mul(a, b);
    sub(a, b);
    div(a, b);
    #endif
}

int main()
{
    float f1 = 1.1f;
    float f2 = 2.3f;
    cout << " FLOAT:" << endl;
    time_measure(f1, f2);

    double d1 = 2.3;
    double d2 = 5.6;
    cout << "\n DOUBLE:" << endl;
    time_measure(d1, d2);
    
    #ifndef SSE
    long double ld1 = 2.3;
    long double ld2 = 5.6;
    
    cout << "\n __FLOAT80:" << endl;
    time_measure<__float80>(ld1, ld2);
    
    cout << "\n LONG DOUBLE:" << endl;
    time_measure(ld1, ld2);
    #endif
}
