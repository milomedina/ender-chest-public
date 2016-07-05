#include<stdio.h>

int sbox5[4][16] = {
	{ 2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9 },
	{ 14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6 },
	{ 4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14 },
	{ 11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3 }
};

int ldt[63][15];

int sbox(int val) {
	int id1 = (val >> 5) * 2 + (val % 2);
	int id2 = ((val >= 32) ? val - 32 : val) >> 1;
	return sbox5[id1][id2];
}

int getbit(int n, int k) {
	return (n & (1 << k)) >> k;
}

int compute(int alpha, int beta) {
	int count = 0;
	for (int x = 0; x < 64; x++) {
		int lhs = 0, rhs = 0;
		for (int s = 0; s <= 5; s++)
			lhs ^= getbit(x, s) & getbit(alpha, s);

		for (int t = 0; t <= 3; t++)
			rhs ^= getbit(sbox(x), t) & getbit(beta, t);

		if (lhs == rhs) count++;
	}
	return count - 32;
}

int main() {
	printf("==========================LDT FOR SBOX5=========================\n");
	for (int i = 1; i < 64; i++)
		for (int j = 1; j < 16; j++)
			ldt[i - 1][j - 1] = compute(i, j);
	
	printf("   |");
	for (int i = 1; i < 16; i++)
		printf("%4d", i);
	
	printf("\n   -------------------------------------------------------------\n");

	for (int i = 1; i < 64; i++) {
		printf("%3d|", i);
		for (int j = 1; j < 16; j++)
			printf("%4d", ldt[i - 1][j - 1]);
		printf("\n");
	}
	getchar();
	return 0;
}