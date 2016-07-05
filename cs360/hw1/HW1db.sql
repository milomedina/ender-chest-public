--- INITIALIZATION
SET LINESIZE 300;

DROP TABLE TAKES;
DROP TABLE COURSE;
DROP TABLE STUDENT;

--- TABLE CREATION
CREATE TABLE STUDENT (
	studentId NUMBER PRIMARY KEY,
	name VARCHAR2(10),
	department VARCHAR2(25),
	semesters NUMBER,
	doubleMajor VARCHAR2(25));
	
CREATE TABLE COURSE (
	courseNo VARCHAR2(7) PRIMARY KEY,
	title VARCHAR2(40),
	couseType VARCHAR2(20),
	classroom VARCHAR2 (15));
	
CREATE TABLE TAKES (
	studentId NUMBER REFERENCES STUDENT(studentId) ON DELETE CASCADE,
	courseNo VARCHAR2(7) REFERENCES COURSE(courseNo) ON DELETE CASCADE,
	semTaken VARCHAR2(20),
	applyDate DATE );
	
--- STUDENT TUPLES (15)
INSERT INTO STUDENT (studentId, name, department, semesters, doubleMajor) VALUES (2008012, 'Noah', 'Computer Science',8 , 'Mathematical Science');
INSERT INTO STUDENT (studentId, name, department, semesters, doubleMajor) VALUES (2009057, 'Logan', 'Bio and Brain Engineering',8, NULL);
INSERT INTO STUDENT (studentId, name, department, semesters) VALUES (2010002, 'Emma', 'Chemistry',7);
INSERT INTO STUDENT (studentId, name, department, semesters) VALUES (2010105, 'Olivia', 'Computer Science',6);
INSERT INTO STUDENT (studentId, name, department, semesters) VALUES (2011016, 'Jackson', 'Mathematical Science',5);
INSERT INTO STUDENT (studentId, name, department, semesters) VALUES (2011102, 'Jacob', 'Industrial Design',7);
INSERT INTO STUDENT (studentId, name, department, semesters, doubleMajor) VALUES (2012035, 'Amelia', 'Electrical Engineering',6, 'Computer Science');
INSERT INTO STUDENT (studentId, name, department, semesters) VALUES (2012089, 'Emily', 'Computer Science',3);
INSERT INTO STUDENT (studentId, name, department, semesters) VALUES (2012063, 'Benjamin', 'Electrical Engineering',2);
INSERT INTO STUDENT (studentId, name, department, semesters) VALUES (2013029, 'Oliver','Industrial Design',3);
INSERT INTO STUDENT (studentId, name, department, semesters) VALUES (2013045, 'Abigail', 'Electrical Engineering',4);
INSERT INTO STUDENT (studentId, name, department, semesters) VALUES (2013047, 'Lily', 'Computer Science',4);
INSERT INTO STUDENT (studentId, name, department, semesters) VALUES (2014014, 'Alexander', 'Electrical Engineering',2);
INSERT INTO STUDENT (studentId, name, department, semesters) VALUES (2014053, 'Hannah','Computer Science',3);
INSERT INTO STUDENT (studentId, name, department, semesters) VALUES (2015610, 'Sofia', 'Bio and Brain Engineering',1);

--- COURSE TUPLES (9)
INSERT INTO COURSE (courseNo, title, couseType, classroom) VALUES ('BiS200', 'Bioengineering Fundamentals', 'Major Required', 'E11, 405');
INSERT INTO COURSE (courseNo, title, couseType, classroom) VALUES ('CS360', 'Introduction to Database', 'Major Elective', 'E11, 402');
INSERT INTO COURSE (courseNo, title, couseType, classroom) VALUES ('CS101', 'Introduction to Programming', 'Basic Required', 'E11, 103');
INSERT INTO COURSE (courseNo, title, couseType, classroom) VALUES ('CH325', 'Bioorganic Chemistry', 'Major Elective', 'E6, 313');
INSERT INTO COURSE (courseNo, title, couseType, classroom) VALUES ('EE201', 'Circuit Theory', 'Major Required', 'E11, 201');
INSERT INTO COURSE (courseNo, title, couseType, classroom) VALUES ('CC500', 'Scientific Writing', 'General Required', 'N4, 1117');
INSERT INTO COURSE (courseNo, title, couseType, classroom) VALUES ('CC511', 'Probability and Stastics', 'General Required', 'E11, 402');
INSERT INTO COURSE (courseNo, title, couseType, classroom) VALUES ('CS230', 'System Programming', 'Major Elective', 'N1, 101');
INSERT INTO COURSE (courseNo, title, couseType, classroom) VALUES ('CS206', 'Data Structure', 'Major Required', 'N1, 102');

--- TAKES TUPLES (30)
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2009057, 'CC500', '2015, Spring', DATE'2014-12-01');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2009057, 'CS360', '2015, Spring', DATE'2014-12-03');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2010002, 'CS360', '2015, Spring', DATE'2014-12-04');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2010002, 'CC511', '2015, Spring', DATE'2015-01-13');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2010002, 'CH325', '2015, Spring', DATE'2015-01-07');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2010105, 'CS206', '2015, Spring', DATE'2014-12-01');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2010105, 'CC511', '2015, Spring', DATE'2014-01-07');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2010105, 'CC500', '2015, Spring', DATE'2014-12-01');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2011102, 'CS360', '2015, Spring', DATE'2014-12-04');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2011102, 'EE201', '2015, Spring', DATE'2015-02-23');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2012035, 'EE201', '2015, Spring', DATE'2014-12-03');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2012035, 'CC500', '2015, Spring', DATE'2015-01-07');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2012035, 'CC511', '2015, Spring', DATE'2014-12-03');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2012089, 'CS230', '2015, Spring', DATE'2014-12-01');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2012089, 'CS206', '2015, Spring', DATE'2014-12-01');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2012089, 'CS101', '2015, Spring', DATE'2014-12-01');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2012063, 'EE201', '2015, Spring', DATE'2014-12-04');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2013029, 'CS101', '2015, Spring', DATE'2015-02-25');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2013029, 'CS230', '2015, Spring', DATE'2014-12-03');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2013045, 'CH325', '2015, Spring', DATE'2015-01-08');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2013045, 'CC500', '2015, Spring', DATE'2015-01-07');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2013045, 'CC511', '2015, Spring', DATE'2015-01-07');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2014014, 'CS101', '2015, Spring', DATE'2014-12-03');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2014014, 'EE201', '2015, Spring', DATE'2014-12-01');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2014014, 'CS360', '2015, Spring', DATE'2014-12-01');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2014014, 'CH325', '2015, Spring', DATE'2014-12-01');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2014014, 'CS206', '2015, Spring', DATE'2014-12-01');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2014053, 'BiS200', '2015, Spring', DATE'2014-12-01');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2014053, 'CS360', '2015, Spring', DATE'2015-02-23');
INSERT INTO TAKES (studentId, courseNo, semTaken, applyDate) VALUES (2015610, 'BiS200', '2015, Spring', DATE'2015-02-10');


--- COMMIT DML COMMANDS
COMMIT;
