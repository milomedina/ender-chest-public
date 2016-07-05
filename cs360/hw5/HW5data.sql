DELETE FROM Loan;
DELETE FROM BookInfo;
DELETE FROM Members;
commit;


--MEMBER tuples
INSERT INTO MEMBERS(mid, mname, type) VALUES(20130010, 'Mike', 'Undergraduate');
INSERT INTO MEMBERS(mid, mname, type) VALUES(20130011, 'Jake', 'Undergraduate');
INSERT INTO MEMBERS(mid, mname, type) VALUES(20130013, 'Jason', 'Undergraduate');
INSERT INTO MEMBERS(mid, mname, type) VALUES(20133030, 'Mia', 'Graduate');
INSERT INTO MEMBERS(mid, mname, type) VALUES(20130103, 'Kane', 'Undergraduate');
INSERT INTO MEMBERS(mid, mname, type) VALUES(20120110, 'Jieun', 'Undergraduate');
INSERT INTO MEMBERS(mid, mname, type) VALUES(20130430, 'Steve', 'Undergraduate');
INSERT INTO MEMBERS(mid, mname, type) VALUES(20093333, 'Kate', 'Graduate');
INSERT INTO MEMBERS(mid, mname, type) VALUES(20123948, 'Michael', 'Undergraduate');
INSERT INTO MEMBERS(mid, mname, type) VALUES(20112234, 'Victoria', 'Undergraduate');
INSERT INTO MEMBERS(mid, mname, type) VALUES(20081234, 'Hani', 'Undergraduate');
INSERT INTO MEMBERS(mid, mname, type) VALUES(20091111, 'Mike', 'Undergraduate');
INSERT INTO MEMBERS(mid, mname, type) VALUES(345, 'John','Professor');
INSERT INTO MEMBERS(mid, mname, type) VALUES(555, 'Alice','Professor');

-- BookInfo tuples
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(1, 'Absolute C++', 2);
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(2, 'Data Warehousing', 2);
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(3, 'Database Systems', 2);
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(4, 'Database System Concepts', 2);
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(5, 'Database Systems', 2);
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(6, 'Introduction to Algorithm', 2);
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(7, 'Visual C#2008', 2);
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(8, 'Code Complete 2', 2);
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(9, 'The Kite Runner', 1);
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(10, 'What money cant buy', 3);
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(11, 'Linear Algebra', 4);
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(12, 'Pro GIT', 2);
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(13, 'Oracle PL/SQL tutorial', 2);
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(14, 'Guns, Germs and Steel', 4);
INSERT INTO BookInfo(bid, title, nrLoaned) VALUES(15, 'Linear Algebra', 4);


--LOAN tuples
INSERT INTO LOAN(mid, bid,  DueDate, NrExtension) 
	VALUES( 20130010, 6, SYSDATE-3,0);
INSERT INTO LOAN(mid, bid,  DueDate, NrExtension) 
	VALUES( 20130430, 2, SYSDATE + 7, 2);
INSERT INTO LOAN(mid, bid,  DueDate,NrExtension) 
	VALUES( 20093333, 4,  SYSDATE+3,0);
INSERT INTO LOAN(mid, bid,  DueDate,NrExtension) 
	VALUES( 555, 	  1,  SYSDATE+4,0);
INSERT INTO LOAN(mid, bid,  DueDate,NrExtension) 
	VALUES( 20133030, 7,  SYSDATE-10,1);
INSERT INTO LOAN(mid, bid,  DueDate,NrExtension)  
	VALUES( 20130010, 8,  SYSDATE-2,0);
INSERT INTO LOAN(mid, bid,  DueDate,NrExtension) 
	VALUES( 20081234, 11, SYSDATE+4,0);

COMMIT;