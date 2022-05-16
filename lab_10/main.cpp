#include <iostream>
#include <ctime>
#include <chrono>

using namespace std;

#define N 4
#define TIMES 1e5

typedef struct vector
{
    float list[N];
} vector_t;

void cout_time(clock_t time, const char* action)
{
    if (time >= 1000)
        cout << action << ": " << ((double)time) / CLOCKS_PER_SEC / TIMES << " s." << endl;
    else
        cout << action << ": " << ((double)time) / TIMES << " ms." << endl;
}

float scalarMulty(const vector_t v1, const vector_t v2)
{
    float scalar = 0;

    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        scalar = 0;
        start_time = clock();
        for (int i = 0; i < N; i++)
            scalar += v1.list[i] * v2.list[i];
        res_time += clock() - start_time;
    }

    cout_time(res_time, "ScalarMulty: ");
    
    return scalar;
}

vector_t sum(const vector_t v1, const vector_t v2)
{
    vector_t result = { 0 };
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        for (int i = 0; i < N; i++)
            result.list[i] = v1.list[i] + v2.list[i];
        res_time += clock() - start_time;
    }

    cout_time(res_time, "SumVectors: ");

    return result;
}

float sse_scalarMulty(const vector_t v1, const vector_t v2)
{
    float result = 0;
    
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        /*__asm
        {
            movups xmm0, v1.list
            movups xmm1, v2.list

            mulps xmm0, xmm1
            haddps xmm0, xmm0
            haddps xmm0, xmm0

            movss result, xmm0
        }*/

        start_time = clock();
        __asm
        {
            movups xmm0, v1.list
            movups xmm1, v2.list

            mulps xmm0, xmm1

            movhlps xmm1, xmm0
            addps xmm0, xmm1
            movups xmm1, xmm0
            shufps xmm0, xmm0, 1
            addps xmm0, xmm1
            movss result, xmm0
        }
        res_time += clock() - start_time;
    }
    
    cout_time(res_time, "ASM ScalarMULty: ");

    return result;
}

vector_t sse_sum(const vector_t v1, const vector_t v2)
{
    vector_t result = { 0 };

    clock_t start_time, res_time = 0;
    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        __asm
        {
            vmovups xmm0, v1.list
            vmovups xmm1, v2.list
            vaddps xmm2, xmm1, xmm0
            vmovups result, xmm2
        }
        res_time += clock() - start_time;
    }

    cout_time(res_time, "ASM SumVectors: ");

    return result;
}

int main()
{

    vector_t v1 = { 1e-5, 2.32 ,4.45, 1.78};
    vector_t v2 = {2.900, 3.0, 4.43, 1.2};


    cout << scalarMulty(v1, v2) << endl;
    cout << sse_scalarMulty(v1, v2) << endl;

    cout << sum(v1, v2).list[2] << endl;
    cout << sse_sum(v1, v2).list[2] << endl;

    return 0;
}

