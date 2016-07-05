CREATE OR REPLACE TRIGGER Trigger_loan_book
AFTER INSERT ON Loan FOR EACH ROW
BEGIN
	UPDATE BookInfo
	SET nrLoaned = nrLoaned + 1
	WHERE bid = :new.bid;
END;

/
