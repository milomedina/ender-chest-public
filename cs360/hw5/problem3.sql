CREATE OR REPLACE FUNCTION is_delinquent (v_mid IN NUMBER)
RETURN NUMBER
IS
	no_such_user_error EXCEPTION;
	dueDate Loan.dueDate%TYPE;
	cnt NUMBER;
	ret_value NUMBER;
	CURSOR loan_cursor IS
		SELECT DueDate FROM Loan WHERE mid = v_mid;
BEGIN
	SELECT COUNT(mid) INTO cnt
		FROM Members WHERE mid = v_mid;
	IF cnt < 1 THEN
		RAISE no_such_user_error;
	END IF;
	
	ret_value := 0;
	OPEN loan_cursor;
	LOOP
		FETCH loan_cursor INTO dueDate;
		IF TRUNC(SYSDATE - dueDate) > 0 THEN
			ret_value := 1;
		END IF;
		EXIT WHEN loan_cursor%NOTFOUND;
	END LOOP;
	CLOSE loan_cursor;
	RETURN ret_value;
EXCEPTION
	WHEN no_such_user_error THEN
		RAISE_APPLICATION_ERROR(-20000, 'No such user');
END;

/
