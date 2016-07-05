# Sungwon Cho
Version: Python 2.7
Location of Main Func: pa1.py
Time Complexity Analysis:
    - getm(matrix, i, j): O(1)
        : get cell value of ith row and jth column
        : -inf if i < 0 or j < 0, inf if i >= n or j >= m
        all operation could be done in constant

    - setm(matrix, i, j, value): O(1)
        : set cell value of ith row and jth column
        all operations could be done in constant

    - extract(matrix): O(m+n)
        : extract smallest value of the matrix
        after each iteration of the while loop, i) the loop exits or ii) value
        of the x or y are increased as 1. since getm returns inf if i>=n or j>=
        m, the loop can only executed at most m+n times

    - insert(matrix, elem): O(m+n)
        : insert given elem to the matrix
        starting from x=n and y=m, after each iteration of the while loop, i) t
        he loop exits or ii) value of the x or y are decreased as 1. if x=0 and
        y=0, then the loop exits, so the loop can only executed at most m+n tim
        es

    - reprm(matrix): O(mn)
        : convert matrix to a string
        since the operation require to scan the matrix at least once, nm time i
        s required

    - main(argv): O(mn)
        : solve the problem
        since it requires to read and write all values in the matrix, nm time i
        s required
