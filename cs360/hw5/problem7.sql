CREATE OR REPLACE PROCEDURE extend_due(v_mid IN NUMBER, v_bid IN NUMBER)
IS
	no_such_history_error EXCEPTION;
	delinquent_error EXCEPTION;
	too_much_extended EXCEPTION;
	PRAGMA EXCEPTION_INIT(too_much_extended, -2290);
	
	cnt NUMBER;
	delinquent NUMBER;
BEGIN
	SELECT COUNT(mid) INTO cnt
		FROM Loan WHERE mid = v_mid AND bid = v_bid;
	IF cnt < 1 THEN
		RAISE no_such_history_error;
	END IF;
	
	delinquent := is_delinquent(v_mid);
	IF delinquent > 0 THEN
		RAISE delinquent_error;
	END IF;
	
	UPDATE Loan
		SET nrExtension = nrExtension + 1, dueDate = dueDate + 7
		WHERE mid = v_mid AND bid = v_bid;
		
EXCEPTION
	WHEN no_such_history_error THEN
		RAISE_APPLICATION_ERROR(-20005, 'No such history');
	WHEN delinquent_error THEN
		RAISE_APPLICATION_ERROR(-20003, 'Deliquent user');
	WHEN too_much_extended THEN
		RAISE_APPLICATION_ERROR(-20006, 'Can''t extend the loan more than 3 times');
END;

/
