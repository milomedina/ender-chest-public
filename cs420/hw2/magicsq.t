AREA    R
AREA    MEM

// R(0): n
// R(1): i
// R(2): j
// R(3): v1
// R(4): v2
// R(5): tmp

// i-th row j-th column
// v1 = (i + j - 1) + floor(n / 2) mod n
// v2 = (i + 2j - 2) mod n + 1
// v  = n((i + j - 1 + floor(n / 2)) mod n)
//    + ((i + 2j - 2) mod n) + 1
//    = n * v1 + v2

LAB     START
        READI   R(0)

        // v1 = floor(n/2) - 1
        DIV     R(0)@   2       R(3)
        SUB     R(3)@   1       R(3)

        // v2 = n - 2
        SUB     R(0)@   2       R(4)

        MOVE    1   R(1)
LAB     ROWLOOP
        // v1 = (v1 + 1) mod n
        ADD     R(3)@   1       R(3)
        SUB     R(3)@   R(0)@   R(3)
        JMPN    R(3)@   VFROW
        JMP     ENDVFROW
LAB     VFROW
        ADD     R(3)@   R(0)@   R(3)
LAB     ENDVFROW

        // v2 = (v2 + 1) mod n
        ADD     R(4)@   1       R(4)
        SUB     R(4)@   R(0)@   R(4)
        JMPN    R(4)@   VSROW
        JMP     ENDVSROW
LAB     VSROW
        ADD     R(4)@   R(0)@   R(4)
LAB     ENDVSROW

        MOVE    1   R(2)
LAB     COLLOOP
        // v1 = (v1 + 1) mod n
        ADD     R(3)@   1       R(3)
        SUB     R(3)@   R(0)@   R(3)
        JMPN    R(3)@   VFCOL
        JMP     ENDVFCOL
LAB     VFCOL
        ADD     R(3)@   R(0)@   R(3)
LAB     ENDVFCOL

        // v2 = (v2 + 2) mod n
        ADD     R(4)@   2       R(4)
        SUB     R(4)@   R(0)@   R(4)
        JMPN    R(4)@   VSCOL
        JMP     ENDVSCOL
LAB     VSCOL
        ADD     R(4)@   R(0)@   R(4)
LAB     ENDVSCOL


        MOVE    R(0)@   R(5)
        MUL     R(0)@   R(3)@   R(5)
        ADD     R(5)@   R(4)@   R(5)
        ADD     R(5)@   1       R(5)
        WRITE   R(5)@

        ADD     R(2)@   1       R(2)
        SUB     R(0)@   R(2)@   R(5)
        JMPN    R(5)@   ENDCOLLOOP
        JMP     COLLOOP
LAB     ENDCOLLOOP
        WRITE ""

        ADD     R(1)@   1       R(1)
        SUB     R(0)@   R(1)@   R(5)
        JMPN    R(5)@   ENDROWLOOP
        JMP     ROWLOOP
LAB     ENDROWLOOP


LAB     END
