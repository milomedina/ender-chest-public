CREATE TABLE BookInfo (
	bid NUMBER PRIMARY KEY,
	title VARCHAR(128) NOT NULL,
	nrLoaned NUMBER
);

CREATE TABLE Members (
	mid NUMBER PRIMARY KEY,
	mname VARCHAR(32) NOT NULL,
	type VARCHAR(15) CHECK (type IN ('Undergraduate', 'Graduate', 'Professor'))
);

CREATE TABLE Loan (
	mid NUMBER REFERENCES Members(mid),
	bid NUMBER REFERENCES BookInfo(bid),
	dueDate DATE NOT NULL,
	nrExtension NUMBER CHECK (nrExtension >=0 AND nrExtension <= 3),
	PRIMARY KEY(mid, bid)
);

CREATE VIEW BookLoanInfo AS
	SELECT * FROM (SELECT bid, title FROM BookInfo)
	NATURAL LEFT OUTER JOIN (SELECT bid, dueDate FROM Loan);

COMMIT;

/
