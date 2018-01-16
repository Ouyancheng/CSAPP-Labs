/*
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
    int a0, a1, a2, a3, a4, a5, a6, a7;
    if (M == 32 && N == 32) {
        // misses 287
        for (int bi = 0; bi < M; bi += 8) {
            for (int bj = 0; bj < N; bj += 8) {
                for (int i = bi; i < bi + 8; i++) {
                    a0 = A[bj][i];
                    a1 = A[bj+1][i];
                    a2 = A[bj+2][i];
                    a3 = A[bj+3][i];
                    a4 = A[bj+4][i];
                    a5 = A[bj+5][i];
                    a6 = A[bj+6][i];
                    a7 = A[bj+7][i];

                    B[i][bj] = a0;
                    B[i][bj+1] = a1;
                    B[i][bj+2] = a2;
                    B[i][bj+3] = a3;
                    B[i][bj+4] = a4;
                    B[i][bj+5] = a5;
                    B[i][bj+6] = a6;
                    B[i][bj+7] = a7;
                }
            }
        }

    } else if (M == 64 && N == 64) {
        // misses 1171 
        const int block_size = 8;
        for (int bi = 0; bi < M; bi += block_size) {
            for (int bj = 0; bj < N; bj += block_size) {
                for (int k = bj; k < bj + 4; k++) {
                    a0 = A[k][bi];
                    a1 = A[k][bi+1];
                    a2 = A[k][bi+2];
                    a3 = A[k][bi+3];
                    a4 = A[k][bi+4];
                    a5 = A[k][bi+5];
                    a6 = A[k][bi+6];
                    a7 = A[k][bi+7];

                    B[bi][k] = a0;
                    B[bi+1][k] = a1;
                    B[bi+2][k] = a2;
                    B[bi+3][k] = a3;
                    B[bi][k+4] = a4;
                    B[bi+1][k+4] = a5;
                    B[bi+2][k+4] = a6;
                    B[bi+3][k+4] = a7;
                }

                for (int i = bi; i < bi + 4; i++) {
                    a4 = A[bj+4][i];
                    a5 = A[bj+5][i];
                    a6 = A[bj+6][i];
                    a7 = A[bj+7][i];

                    a0 = B[i][bj+4];
                    a1 = B[i][bj+5];
                    a2 = B[i][bj+6];
                    a3 = B[i][bj+7];

                    B[i][bj+4] = a4;
                    B[i][bj+5] = a5;
                    B[i][bj+6] = a6;
                    B[i][bj+7] = a7;

                    B[i+4][bj] = a0;
                    B[i+4][bj+1] = a1;
                    B[i+4][bj+2] = a2;
                    B[i+4][bj+3] = a3;

                }
                for (int i = bi + 4; i < bi + 8; i++) {
                    a0 = A[bj+4][i];
                    a1 = A[bj+5][i];
                    a2 = A[bj+6][i];
                    a3 = A[bj+7][i];
                    B[i][bj+4] = a0;
                    B[i][bj+5] = a1;
                    B[i][bj+6] = a2;
                    B[i][bj+7] = a3;

                }

            }
        }

    } else {
        // misses: 1970
        const int block_size = 18;
        for (int bi = 0; bi < M; bi += block_size) {
            for (int bj = 0; bj < N; bj += block_size) {
                for (int i = bi; i < bi + block_size && i < M; i++) {
                    for (int j = bj; j < bj + block_size && j < N; j++) {
                        a0 = A[j][i];
                        B[i][j] = a0;
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
