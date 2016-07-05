/* 
 * CS:APP Data Lab 
 * 
 * Sungwon Cho (known as Sam Jo)
 * 
 * bits.c - Source file with your solutions to the Lab.
 *          This is the file you will hand in to your instructor.
 *
 * WARNING: Do not include the <stdio.h> header; it confuses the dlc
 * compiler. You can still use printf for debugging without including
 * <stdio.h>, although you might get a compiler warning. In general,
 * it's not good practice to ignore compiler warnings, but in this
 * case it's OK.  
 */

#if 0
/*
 * Instructions to Students:
 *
 * STEP 1: Read the following instructions carefully.
 */

You will provide your solution to the Data Lab by
editing the collection of functions in this source file.

INTEGER CODING RULES:
 
  Replace the "return" statement in each function with one
  or more lines of C code that implements the function. Your code 
  must conform to the following style:
 
  int Funct(arg1, arg2, ...) {
      /* brief description of how your implementation works */
      int var1 = Expr1;
      ...
      int varM = ExprM;

      varJ = ExprJ;
      ...
      varN = ExprN;
      return ExprR;
  }

  Each "Expr" is an expression using ONLY the following:
  1. Integer constants 0 through 255 (0xFF), inclusive. You are
      not allowed to use big constants such as 0xffffffff.
  2. Function arguments and local variables (no global variables).
  3. Unary integer operations ! ~
  4. Binary integer operations & ^ | + << >>
    
  Some of the problems restrict the set of allowed operators even further.
  Each "Expr" may consist of multiple operators. You are not restricted to
  one operator per line.

  You are expressly forbidden to:
  1. Use any control constructs such as if, do, while, for, switch, etc.
  2. Define or use any macros.
  3. Define any additional functions in this file.
  4. Call any functions.
  5. Use any other operations, such as &&, ||, -, or ?:
  6. Use any form of casting.
  7. Use any data type other than int.  This implies that you
     cannot use arrays, structs, or unions.

 
  You may assume that your machine:
  1. Uses 2s complement, 32-bit representations of integers.
  2. Performs right shifts arithmetically.
  3. Has unpredictable behavior when shifting an integer by more
     than the word size.

EXAMPLES OF ACCEPTABLE CODING STYLE:
  /*
   * pow2plus1 - returns 2^x + 1, where 0 <= x <= 31
   */
  int pow2plus1(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     return (1 << x) + 1;
  }

  /*
   * pow2plus4 - returns 2^x + 4, where 0 <= x <= 31
   */
  int pow2plus4(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     int result = (1 << x);
     result += 4;
     return result;
  }

FLOATING POINT CODING RULES

For the problems that require you to implent floating-point operations,
the coding rules are less strict.  You are allowed to use looping and
conditional control.  You are allowed to use both ints and unsigneds.
You can use arbitrary integer and unsigned constants.

You are expressly forbidden to:
  1. Define or use any macros.
  2. Define any additional functions in this file.
  3. Call any functions.
  4. Use any form of casting.
  5. Use any data type other than int or unsigned.  This means that you
     cannot use arrays, structs, or unions.
  6. Use any floating point data types, operations, or constants.


NOTES:
  1. Use the dlc (data lab checker) compiler (described in the handout) to 
     check the legality of your solutions.
  2. Each function has a maximum number of operators (! ~ & ^ | + << >>)
     that you are allowed to use for your implementation of the function. 
     The max operator count is checked by dlc. Note that '=' is not 
     counted; you may use as many of these as you want without penalty.
  3. Use the btest test harness to check your functions for correctness.
  4. Use the BDD checker to formally verify your functions
  5. The maximum number of ops for each function is given in the
     header comment for each function. If there are any inconsistencies 
     between the maximum ops in the writeup and in this file, consider
     this file the authoritative source.

/*
 * STEP 2: Modify the following functions according the coding rules.
 * 
 *   IMPORTANT. TO AVOID GRADING SURPRISES:
 *   1. Use the dlc compiler to check that your solutions conform
 *      to the coding rules.
 *   2. Use the BDD checker to formally verify that your solutions produce 
 *      the correct answers.
 */


#endif
/* 
 * bitNor - ~(x|y) using only ~ and & 
 *   Example: bitNor(0x6, 0x5) = 0xFFFFFFF8
 *   Legal ops: ~ &
 *   Max ops: 8
 *   Rating: 1
 */
int bitNor(int x, int y) {
    // simple logic: ~(x|y) = ~x & ~y
    return ~x & ~y;
}

/* 
 * copyLSB - set all bits of result to least significant bit of x
 *   Example: copyLSB(5) = 0xFFFFFFFF, copyLSB(6) = 0x00000000
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 5
 *   Rating: 2
 */
int copyLSB(int x) {
    // x << 31: 10...0 or 00...0
    return (x << 31) >> 31;
}

/* 
 * isEqual - return 1 if x == y, and 0 otherwise 
 *   Examples: isEqual(5,5) = 1, isEqual(4,5) = 0
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 5
 *   Rating: 2
 */
int isEqual(int x, int y) {
    // simple xor: a xor a = 0
    return !(x ^ y);
}

/* 
 * bitMask - Generate a mask consisting of all 1's 
 *   lowbit and highbit
 *   Examples: bitMask(5,3) = 0x38
 *   Assume 0 <= lowbit <= 31, and 0 <= highbit <= 31
 *   If lowbit > highbit, then mask should be all 0's
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 16
 *   Rating: 3
 */
int bitMask(int highbit, int lowbit) {
    // prepare 2^h - 1: (1 << hightbit + 1) - 1
    int ones = (1 << highbit << 1) + ~0;
    
    // remove 0's: >> l << l
    return ones >> lowbit << lowbit;
}

/*
 * bitCount - returns count of number of 1's in word
 *   Examples: bitCount(5) = 2, bitCount(7) = 3
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 40
 *   Rating: 4
 */
int bitCount(int x) {
    // lv1: 0b01010101010101010101010101010101
    int lv1p = 0x55 << 8 | 0x55;
    int lv1 = lv1p << 16 | lv1p;

    // lv2: 0b00110011001100110011001100110011
    int lv2p = 0x33 << 8| 0x33;
    int lv2 = lv2p << 16 | lv2p;

    // lv4: 0b00001111000011110000111100001111
    int lv4p = 0x0f << 8 | 0x0f;
    int lv4 = lv4p << 16 | lv4p;

    // lv8: 0b00000000111111110000000011111111
    int lv8 = 0xff << 16 | 0xff;
    
    // lv16: 0b00000000000000001111111111111111
    int lv16 = 0xff << 8 | 0xff;
    
    x = ((x >> 1) & lv1) + (x & lv1);
    x = ((x >> 2) & lv2) + (x & lv2);
    x = ((x >> 4) & lv4) + (x & lv4);
    x = ((x >> 8) & lv8) + (x & lv8);
    x = ((x >> 16) & lv16) + (x & lv16);
    return x;
}

/* 
 * TMax - return maximum two's complement integer 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 4
 *   Rating: 1
 */
int tmax(void) {
    // 10...000 -> 01...111
    return ~(1 << 31);
}

/* 
 * isNonNegative - return 1 if x >= 0, return 0 otherwise 
 *   Example: isNonNegative(-1) = 0.  isNonNegative(0) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 6
 *   Rating: 3
 */
int isNonNegative(int x) {
    // simple msb: x >> 31
    return !(x >> 31);
}

/* 
 * addOK - Determine if can compute x+y without overflow
 *   Example: addOK(0x80000000,0x80000000) = 0,
 *            addOK(0x80000000,0x70000000) = 1, 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3
 */
int addOK(int x, int y) {
    // sadd, sx, sy: 0 if x+y, x, y >= 0
    int sadd = (x + y) >> 31;
    int sx = x >> 31;
    int sy = y >> 31;

    // overflow if: x >= 0 && y >= 0 && x+y < 0 or
    //              x < 0 && y < 0 && x+y >= 0
    return !((!sx & !sy & sadd) | (sx & sy & !sadd)); 
}

/* 
 * rempwr2 - Compute x%(2^n), for 0 <= n <= 30
 *   Negative arguments should yield negative remainders
 *   Examples: rempwr2(15,2) = 3, rempwr2(-35,3) = -3
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3
 */
int rempwr2(int x, int n) {
    // r: x & (2^n - 1)
    int r = x & ((1 << n) + ~0);

    // mask: all 1's if x < 0; otherwise 0
    int mask = x >> 31;

    // if-stat: r=0 ? 0:
    //                x >= 0 ? r:
    //                         r - 2^n
    return (!r + ~0)
         & ((r & ~mask) |
            ((r + ~(1 << n) + 1) & mask));
}

/* 
 * isLess - if x < y  then return 1, else return 0 
 *   Example: isLess(4,5) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 24
 *   Rating: 3
 */
int isLess(int x, int y) {
    // sdiff, sx, sy: 0 if x-y, x, y >= 0
    int sdiff = (x + (~y) + 1) >> 31;
    int sx = x >> 31;
    int sy = y >> 31;

    // NOT less if: x >= 0 && y < 0
    // less if: x < 0 && y >= 0 or x-y < 0 
    return ((sx | ~sy)
         & ((sx & ~sy) |
            sdiff)) & 1;
}

/* 
 * absVal - absolute value of x
 *   Example: absVal(-1) = 1.
 *   You may assume -TMax <= x <= TMax
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 10
 *   Rating: 4
 */
int absVal(int x) {
    // mask: all 1's if x < 0; otherwise 0
    int mask = x >> 31;

    // if-stat: if x >= 0 ? x : -x
    return (x & ~mask)
         | (((~x) + 1) & mask);
}

/*
 * isPower2 - returns 1 if x is a power of 2, and 0 otherwise
 *   Examples: isPower2(5) = 0, isPower2(8) = 1, isPower2(0) = 0
 *   Note that no negative number is a power of 2.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 4
 */
int isPower2(int x) {
    // px: 1 if x >= 0
    int px = !(x >> 31);

    // r: 1 if x=0x00..010..00
    int r = !(x & (x + ~0));

    // cond: r && x >= 0 && x != 0
    return r & px & !!x;
}

/* 
 * float_neg - Return bit-level equivalent of expression -f for
 *   floating point argument f.
 *   Both the argument and result are passed as unsigned int's, but
 *   they are to be interpreted as the bit-level representations of
 *   single-precision floating point values.
 *   When argument is NaN, return argument.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 10
 *   Rating: 2
 */
unsigned float_neg(unsigned uf) {
    // if NaN return itself
    if (uf == 0x7fc00000 ||
        uf == 0xffc00000)
        return uf;
     
    // simply inverse sign
    return uf ^ (1 << 31);
}

/* 
 * float_half - Return bit-level equivalent of expression 0.5*f for
 *   floating point argument f.
 *   Both the argument and result are passed as unsigned int's, but
 *   they are to be interpreted as the bit-level representation of
 *   single-precision floating point values.
 *   When argument is NaN, return argument
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned float_half(unsigned uf) {
    // e: exp
    unsigned e = uf >> 23 & 0xff;
    // f: frac
    unsigned f = uf << 9 >> 9;
    // s: sign
    unsigned s = uf >> 31 << 31;

    // return itself if NaN or Inf
    if (e == 0xff) return uf;

    // if e==1, frac should be added 1
    if (e == 0x01) f += 0x800000;

    // if e==1, frac should shifted
    if (e <= 0x01) {
        // do round-to-even
        if (f % 4 == 3)
            f += 1;
        f = f >> 1;
    }

    // if e > 0, sub 1 to e
    if (e > 0x00) 
        e -= 1;

    // reassemble sign, exp and frac
    return s | (e << 23) | f;
}

/* 
 * float_i2f - Return bit-level equivalent of expression (float) x
 *   Result is returned as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point values.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned float_i2f(int x) {
    unsigned s = 0, e = 0, f = 0;
    unsigned abs = 0, ct = 0, cx = 0;
    unsigned gb = 0, rb = 0, sb = 0;
    
    // if 0 return 0
    if (x == 0) return 0;

    // s: sign of x
    s = x < 0;
    // abs: abs(x)
    abs = s ? -x : x;

    // calculate ct; abs < 2^ct
    cx = abs;
    while (cx) {
        ct += 1;
        cx >>= 1;
    }

    // e: exp
    e = ct + 0x7e;
    // f: 32bit frac
    f = abs << (33 - ct);

    // gb: guard bit
    gb = f & (1 << 9);
    // rb: rounding bit
    rb = f & (1 << 8);
    // sb: sticky bits
    sb = f & 0xff;
    
    // f: 23bit frac
    f = f >> 9;

    // round-to-even
    if (rb && (sb || (!sb && gb)))
        f += 1;
    
    // if overflow frac, add 1 to e
    if (f == 0x800000) {
        f = 0; e += 1;
    }

    // reassemble sign, exp and frac
    return (s << 31) | (e << 23) | f;
}
