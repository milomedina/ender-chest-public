#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <time.h>

#include "aes.h"

/* 
 * Use public domain open-source of C AES-128
 * https://github.com/kokke/tiny-AES128-C/
 */

void print2(uint8_t val) {
	uint8_t div = 128;
	for (; div > 0; div /= 2) {
		if (val >= div) {
			printf("1"); val -= div;
		}
		else
			printf("0");
	}
	printf(" ");
}

uint8_t diff(uint8_t val1, uint8_t val2) {
	uint8_t count = 0;
	for (uint8_t div = 128; div > 0; div /= 2) {
		if ((val1 >= div && val2 < div) || (val1 < div && val2 >= div))
			count++;
		if (val1 >= div)
			val1 -= div;
		if (val2 >= div)
			val2 -= div;
	}
	return count;
}

void print16(uint8_t* str)
{
    unsigned char i;
    for(i = 0; i < 16; ++i)
        printf("%.2x", str[i]);
    printf("\n");
}

uint8_t* all0(void) {
	uint8_t* zeros = malloc(16 * sizeof(uint8_t));
	unsigned char i;
	for (i = 0; i < 16; ++i)
		zeros[i] = 0;
	return zeros;
}

uint8_t* random16(void) {
	uint8_t* random = malloc(16 * sizeof(uint8_t));
	unsigned char i;
	for (i = 0; i < 16; ++i)
		random[i] = rand() % 256;
	return random;
}

void test_ed(uint8_t* key, uint8_t* inter, uint8_t* in)
{
	uint8_t ct[16];
	uint8_t pt[16];

	printf("PT:\t"); print16(in);
	printf("KEY:\t"); print16(key);

	AES128_ECB_encrypt(in, key, inter, ct);
	printf("CT:\t"); print16(ct);

	AES128_ECB_decrypt(ct, key, pt);
	printf("PT(D):\t"); print16(pt);

	return inter;
}

int main(void)
{
	srand((unsigned)time(NULL));


	uint8_t tkey[16] = { 0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c };
	uint8_t tin[16] = { 0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a };
	uint8_t tout[16] = { 0x3a, 0xd7, 0x7b, 0xb4, 0x0d, 0x7a, 0x36, 0x60, 0xa8, 0x9e, 0xca, 0xf3, 0x24, 0x66, 0xef, 0x97 };
	uint8_t tinter[176];
	printf("TEST FOR NIST TEST VECTOR\n");
	test_ed(tkey, tinter, tin);
	printf("CT(O):\t"); print16(tout);

	printf("\n");

	uint8_t* key = all0();
	uint8_t* in = all0();
	uint8_t inter[176];
	printf("TEST FOR ALL0 KEY AND PT\n");
	test_ed(key, inter, in);

	printf("\n");

	uint8_t inter1[176];
	key = random16(); in = random16();
	printf("TEST FOR RANDOM KEY AND PT\n");
	test_ed(key, inter1, in);

	printf("\n");

	uint8_t inter2[176];
	in[0] = in[0] ^ 128;
	printf("TEST FOR ONE BIT CHANGE PT\n");
	test_ed(key, inter2, in);

	printf("\n\nBIT DIFFERENCES\n");
	for (int i = 0; i < 11; ++i)
	{
		printf("Round %.2d: ", i);
		int count = 0;
		for (int j = 0; j < 16; ++j)
			printf("%.2x", inter1[i * 16 + j]);
		printf(" vs ");
		for (int j = 0; j < 16; ++j)
			printf("%.2x", inter2[i * 16 + j]);
		printf(" ->");
		for (int j = 0; j < 16; ++j) {
			int val = diff(inter1[i * 16 + j], inter2[i * 16 + j]);
			printf(" %d", val);
			count += val;
		}
		printf(", total diff: %d\n", count);
	}

	getchar();
	return 0;
}