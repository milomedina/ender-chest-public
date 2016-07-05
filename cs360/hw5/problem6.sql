CREATE OR REPLACE FUNCTION return_book (v_bid IN NUMBER)
RETURN NUMBER
IS
	book_not_loaned_error EXCEPTION;
	late_fee NUMBER;
	cnt NUMBER;
BEGIN
	SELECT COUNT(bid) INTO cnt
		FROM Loan WHERE bid = v_bid;
	IF cnt < 1 THEN
		RAISE book_not_loaned_error;
	END IF;
	
	late_fee := get_late_fee(v_bid);
	DELETE Loan WHERE bid = v_bid;
	RETURN late_fee;
EXCEPTION
	WHEN book_not_loaned_error THEN
		RAISE_APPLICATION_ERROR(-20004, 'Book not loaned');
END;

/
