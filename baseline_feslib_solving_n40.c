#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "feslite.h"
#include "cycleclock.h"

int main()
{
    int n = 32; // num of variables;
    int k = 32; // num of quadratic boolean equations;
    int m = 16;

    /* Reading Numbers from File */
    u32 Fq[496]; // Quadratic terms num = C(2,32); Think about why not 496*m?? The fact is that any two systems in m systems have the same quadratic terms(which can be veritified by computing examples);
    u32 Fl[33 * m]; // Linear terms num = num of variables + 1;
    // === Reading The Equations from file fq_and_fl_array.dat ===
    FILE *FILE_IO_COUNT,*FILE_IO_READ;char TMP_CHAR;char NUM_CHAR[20];char READ_CHAR[20];int TMP_NUM;
    FILE_IO_COUNT = fopen("fq_and_fl_array.dat","r");FILE_IO_READ = fopen("fq_and_fl_array.dat","r");
    for (int INDEX_i = 0; INDEX_i < 496; ++INDEX_i)
    {
        int COUNT_BIT = 0;TMP_CHAR = fgetc(FILE_IO_COUNT);
        while(TMP_CHAR != ','){COUNT_BIT++;TMP_CHAR = fgetc(FILE_IO_COUNT);}
        fgets(NUM_CHAR, COUNT_BIT+1, FILE_IO_READ);
        fgets(READ_CHAR, 2, FILE_IO_READ);
        Fq[INDEX_i] = char2u32(NUM_CHAR);
    }
    for (int INDEX_i = 0; INDEX_i < 33*m; ++INDEX_i)
    {
        int COUNT_BIT = 0;TMP_CHAR = fgetc(FILE_IO_COUNT);
        while(TMP_CHAR != ','){COUNT_BIT++;TMP_CHAR = fgetc(FILE_IO_COUNT);}
        fgets(NUM_CHAR, COUNT_BIT+1, FILE_IO_READ);
        fgets(READ_CHAR, 2, FILE_IO_READ);
        Fl[INDEX_i] = char2u32(NUM_CHAR);
    }
    // === Reading End ===

    /* solve */
    u32 solutions[256 * m]; // Stored solutions;
    int size[m]; // Record how many solutions can be found of each system;
    uint64_t start = Now(); // Record the start time;
    feslite_solve(n, m, Fq, Fl, 256, solutions, size); // Solving m systems once;
    uint64_t stop = Now(); // Record the stop time;

    /* report */
    int kernel = feslite_default_kernel(); // Solver kernel;
    const char *name = feslite_kernel_name(kernel); // Which kernel used;
    printf("%s : %d lanes, %.2f cycles/candidate\n", 
        name, m, ((double) (stop - start)) / m / (1ll << n)); // Print time cost;
    for (int i = 0; i < m; i++)
    printf("Lane %d : %d solutions found\n", i, size[i]); // Print solving results;
    return EXIT_SUCCESS; // Ending;
}