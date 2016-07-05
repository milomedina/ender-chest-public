CREATE OR REPLACE PROCEDURE loan_book(v_mid IN NUMBER, v_bid IN NUMBER)
IS
	no_such_book_error EXCEPTION;
	already_loaned_error EXCEPTION;
	delinquent_error EXCEPTION;
	cnt NUMBER;
	delinquent NUMBER;
	mem_type Members.type%TYPE;
BEGIN
	SELECT COUNT(bid) INTO cnt
		FROM BookInfo WHERE bid = v_bid;
	IF cnt < 1 THEN
		RAISE no_such_book_error;
	END IF;
	
	SELECT COUNT(bid) INTO cnt
		FROM Loan WHERE bid = v_bid;
	IF cnt > 0 THEN
		RAISE already_loaned_error;
	END IF;
	
	delinquent := is_delinquent(v_mid);
	IF delinquent > 0 THEN
		RAISE delinquent_error;
	END IF;
	
	SELECT type INTO mem_type
		FROM Members WHERE mid = v_mid;
	IF mem_type = 'Undergradute' THEN
		INSERT INTO Loan VALUES (v_mid, v_bid, SYSDATE + 7, 0);
	ELSE
		INSERT INTO Loan VALUES (v_mid, v_bid, SYSDATE + 14, 0);
	END IF;
EXCEPTION
	WHEN no_such_book_error THEN
		RAISE_APPLICATION_ERROR(-20001, 'No such book');
	WHEN already_loaned_error THEN
		RAISE_APPLICATION_ERROR(-20002, 'Already loaned book');
	WHEN delinquent_error THEN
		RAISE_APPLICATION_ERROR(-20003, 'Deliquent user');
END;

/
