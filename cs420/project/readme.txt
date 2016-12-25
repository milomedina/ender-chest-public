Python Version: 3.5.2

Dependency:
    PLY3.9 (python-lex-yacc)

Dependency Install:
    pip3 install ply

Build:
    python3 build.py

Execute:
    python3 nyang.py <file-path>

Out:
    parse.txt (for project 1):
        parser log that produced by PLY (level=DEBUG)
        contains state, stack, action and result
    tree.txt (for project 2):
        c-style AST representation with indentation
    table.txt (for proejct 2):
        the symbol table of entire program
        almost same format with the table in the pdf

Symbol Table:
    example:
        * GLOBAL - FUNC(NAME: for_loop)
        ORDER           NAME    TYPE    SIZE    ROLE
            1             a1     int           PARAM
            2              i     int             VAR
            3              j     int             VAR
            4              k   float             VAR
    location: located on the first line
        - always starts with GLOBAL
        - except global variable, - FUNC(NAME: <func-name>) is follows
        - for nested statement type, following notations can be followed
            - COMPOUND(ORDER: <order>)
            - IF(ORDER: <order>)
            - ELSE(ORDER: <order>)
            - FOR(ORDER: <order>)
            - WHILE(ORDER: <order>)
            - DOWHILE(ORDER: <order>)
            - CASE(NUM: <num>)
            - DEFAULT
        - basically, XXX(ORDER: n) means n-th XXX statements in a scope
        - any direct compound statements child of (if, else, for, while, dowhile) are ignored
            - for example, symbol table of following code is
                code:
                    while (black_pink == twice) {
                        int win;
                        win = me;
                    }
                table:
                    * GLOBAL - ... - WHILE(ORDER: 1)
                    ORDER NAME TYPE SIZE ROLE
                        1  win  int       VAR
        - order of else statements is equivalent to its if statements
            - for example, symbol table of following code is
                code:
                    if (a) { ioi = good_man; } else { ioi = pretty; }
                    if (me == samjo) { grade = A; }
                    if (c) { twice = bad; } else { int tt; twice = tt; }
                table:
                    * GLOBAL - ... - ELSE(ORDER: 3)
                    ORDER NAME TYPE SIZE ROLE
                        1   tt  int       VAR
    order: just simple 1 based indexing
    name: name of the variable or parameter
    type: int or float
    size: size of the variable or parameter,
        - if it is not array, just empty
    role: PARAM (parameter) or VAR(variable)
