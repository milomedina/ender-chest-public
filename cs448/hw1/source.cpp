#include<stdio.h>

int sbox5[4][16] = {
	{ 2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9 },
	{ 14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6 },
	{ 4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14 },
	{ 11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3 }
};

int sbox(int val) {
	int id1 = (val >> 5) * 2 + (val % 2);
	int id2 = ((val >= 32) ? val - 32 : val) >> 1;
	return sbox5[id1][id2];
}

void printfb(int val, int max) {
	int div = 1;
	for (int i = 0; i < max - 1; i++) div *= 2;
	for (; div > 0; div /= 2) {
		if (val >= div) {
			printf("1"); val -= div;
		}
		else
			printf("0");
	}
}

int diff(int val1, int val2) {
	int count = 0;
	for (int div = 8; div > 0; div /= 2) {
		if ((val1 >= div && val2 < div) || (val1 < div && val2 >= div))
			count++;
		if (val1 >= div)
			val1 -= div;
		if (val2 >= div)
			val2 -= div;
	}
	return count;
}

int main() {
	printf("=================TEST FOR SBOX5================\n");
	for (int i = 0; i < 64; i++) {
		int val1 = sbox(i); int val2 = sbox(i ^ 12);
		printf("%2d. ", i);
		printfb(i, 6); printf(" vs "); printfb(i ^ 12, 6); printf(" => ");
		printfb(val1, 4); printf(" vs "); printfb(val2, 4); printf("; diff by %d\n", diff(val1, val2));
	}

	getchar();
	return 0;
}