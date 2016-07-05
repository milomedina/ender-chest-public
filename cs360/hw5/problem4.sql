CREATE OR REPLACE FUNCTION get_late_fee (v_bid IN NUMBER)
RETURN NUMBER
IS
	no_such_book_error EXCEPTION;
	dueDate Loan.DueDate%TYPE;
	cnt NUMBER;
BEGIN
	SELECT COUNT(bid) INTO cnt
		FROM BookInfo WHERE bid = v_bid;
	IF cnt < 1 THEN
		RAISE no_such_book_error;
	END IF;
	
	SELECT COUNT(bid) INTO cnt
		FROM Loan WHERE bid = v_bid;
	IF cnt < 1 THEN
		RETURN 0;
	END IF;
	
	SELECT DueDate INTO dueDate
		FROM Loan WHERE bid = v_bid;
	IF TRUNC(SYSDATE - dueDate) <= 0 THEN
		RETURN 0;
	ELSE
		RETURN 100 * TRUNC(SYSDATE - dueDate);
	END IF;
EXCEPTION
	WHEN no_such_book_error THEN
		RAISE_APPLICATION_ERROR(-20001, 'No such book');
END;

/
