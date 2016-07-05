/*
 * Sungwon Cho (known as Sam Jo)
 * Time: 2015-11-02T13:01+09:00
 * 
 * trans.c - Matrix transpose B = A^T
 *
 * Each transpose function must have a prototype of the form:
 * void trans(int M, int N, int A[N][M], int B[M][N]);
 *
 * A transpose function is evaluated by counting the number of misses
 * on a 1KB direct mapped cache with a block size of 32 bytes.
 */

#include <stdio.h>
#include "cachelab.h"

int is_transpose(int M, int N, int A[N][M], int B[M][N]);

/* 
 * transpose_submit - This is the solution transpose function that you
 *     will be graded on for Part B of the assignment. Do not change
 *     the description string "Transpose submission", as the driver
 *     searches for that string to identify the transpose function to
 *     be graded. 
 */
char transpose_submit_desc[] = "Transpose submission";
void transpose_submit(int M, int N, int A[N][M], int B[M][N])
{
    int i, j;
    if (N == 32 && M == 32) {
        // for 32x32
        int n, m, d;

        // use 8x8 blocking and save diagonal entries to temp variable
        for (i = 0; i < 32; i += 8) {
            for (j = 0; j < 32; j+= 8) {
                for (n = i; n < i + 8; n++) {
                    for (m = j; m < j + 8; m++) {
                        if (n != m)
                            B[m][n] = A[n][m];
                        else
                            d = A[n][m];
                    }
                    if (i == j)
                        B[n][n] = d;
                }
            }
        }
    } else if (N == 64 && M == 64) {
        // for 64x64
        int k, t0, t1, t2, t3;
        
        // use 8x8 blocking
        for (i = 0; i < 64; i+= 8) {
            for (j = 0; j < 64; j += 8) {
                // handle first 4 elements of A[j ~ j+7]
                for (k = 0; k < 8; k++) {
                    // store the elements to temp variable to reduce miss
                    t0 = A[j+k][i+0];
                    t1 = A[j+k][i+1];
                    t2 = A[j+k][i+2];
                    t3 = A[j+k][i+3];
                    B[i+0][j+k] = t0;
                    B[i+1][j+k] = t1;
                    B[i+2][j+k] = t2;
                    B[i+3][j+k] = t3;
                }

                // start inverse order to reduce cache miss of A[j+7]
                for (k = 7; k >= 0; k--) {
                    t0 = A[j+k][i+4];
                    t1 = A[j+k][i+5];
                    t2 = A[j+k][i+6];
                    t3 = A[j+k][i+7];
                    B[i+4][j+k] = t0;
                    B[i+5][j+k] = t1;
                    B[i+6][j+k] = t2;
                    B[i+7][j+k] = t3;
                }
            }
        }
    } else if (N == 67 && M == 61) {
        // for 67x61
        int n, m, nmax, mmax;

        // use 17x17 blocking and normal transpose
        for (i = 0; i <= 51; i += 17) {
            for (j = 0; j <= 51; j+= 17) {
                nmax = i + 17 > N ? N : i + 17;
                mmax = j + 17 > M ? M : j + 17;
                for (n = i; n < nmax; n++) {
                    for (m = j; m < mmax; m++) {
                        B[m][n] = A[n][m];
                    }
                }
            }
        }
    }
}

/* 
 * You can define additional transpose functions below. We've defined
 * a simple one below to help you get started. 
 */ 

/* 
 * trans - A simple baseline transpose function, not optimized for the cache.
 */
char trans_desc[] = "Simple row-wise scan transpose";
void trans(int M, int N, int A[N][M], int B[M][N])
{
    int i, j, tmp;

    for (i = 0; i < N; i++) {
        for (j = 0; j < M; j++) {
            tmp = A[i][j];
            B[j][i] = tmp;
        }
    }    

}

/*
 * registerFunctions - This function registers your transpose
 *     functions with the driver.  At runtime, the driver will
 *     evaluate each of the registered functions and summarize their
 *     performance. This is a handy way to experiment with different
 *     transpose strategies.
 */
void registerFunctions()
{
    /* Register your solution function */
    registerTransFunction(transpose_submit, transpose_submit_desc); 

    /* Register any additional transpose functions */
    registerTransFunction(trans, trans_desc); 

}

/* 
 * is_transpose - This helper function checks if B is the transpose of
 *     A. You can check the correctness of your transpose by calling
 *     it before returning from the transpose function.
 */
int is_transpose(int M, int N, int A[N][M], int B[M][N])
{
    int i, j;

    for (i = 0; i < N; i++) {
        for (j = 0; j < M; ++j) {
            if (A[i][j] != B[j][i]) {
                return 0;
            }
        }
    }
    return 1;
}

