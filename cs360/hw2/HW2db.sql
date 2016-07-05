--initialization
SET LINESIZE 400;

DROP TABLE WORKS_ON;
DROP TABLE EMPLOYEE;
DROP TABLE PROJECT;
PURGE recyclebin;

--table creation
CREATE TABLE EMPLOYEE (
	EmployeeID NUMBER PRIMARY KEY,
	Name VARCHAR2(15),
	Department VARCHAR2(30),
	Salary NUMBER,
	Manager char(15));
		
CREATE TABLE PROJECT (
	ProjectID VARCHAR2(10) PRIMARY KEY,
	Name VARCHAR2(40),
	Location VARCHAR2(80),
	StartDate DATE);
		
CREATE TABLE WORKS_ON (
	EmployeeID NUMBER REFERENCES EMPLOYEE(EmployeeID) ON DELETE CASCADE,
	ProjectID varchar2(10) REFERENCES PROJECT(ProjectID) ON DELETE CASCADE,
	Hours number);

--EMPLOYEE tuples
INSERT INTO EMPLOYEE(EmployeeID, Name, Department, Salary) VALUES(70547, 'Rachel', 'Research', 4500);
INSERT INTO EMPLOYEE(EmployeeID, Name, Department, Salary) VALUES(71041, 'Andrew', 'Headquarter', 6000);
INSERT INTO EMPLOYEE(EmployeeID, Name, Department, Salary) VALUES(80122, 'Brian', 'Research', 5100);
INSERT INTO EMPLOYEE(EmployeeID, Name, Department, Salary) VALUES(80221, 'Victoria', 'Development', 3900);
INSERT INTO EMPLOYEE(EmployeeID, Name, Department, Salary) VALUES(80412, 'Dave', 'Research', 3700);
INSERT INTO EMPLOYEE(EmployeeID, Name, Department, Salary) VALUES(81111, 'Stella', 'Research', 4500);
INSERT INTO EMPLOYEE(EmployeeID, Name, Department, Salary) VALUES(90574, 'Monica', 'Development', 5000);
INSERT INTO EMPLOYEE(EmployeeID, Name, Department, Salary) VALUES(90610, 'Brando', 'Development', 3800);
INSERT INTO EMPLOYEE(EmployeeID, Name, Department, Salary) VALUES(90714, 'Brian', 'Research', 4600);
INSERT INTO EMPLOYEE(EmployeeID, Name, Department, Salary) VALUES(90811, 'Monica', 'Headquarter', 6500);
INSERT INTO EMPLOYEE(EmployeeID, Name, Department, Salary) VALUES(90912, 'Diana', 'Research', 4100);
INSERT INTO EMPLOYEE(EmployeeID, Name, Department, Salary) VALUES(91124, 'John', 'Development', 4500);
INSERT INTO EMPLOYEE(EmployeeID, Name, Department, Salary, Manager) VALUES(70439, 'Smith', 'Headquarter', 6500, 'YES');
INSERT INTO EMPLOYEE(EmployeeID, Name, Department, Salary, Manager) VALUES(81201, 'Mike', 'Development', 4900, 'YES');

--PROJECT tuples
INSERT INTO PROJECT(ProjectID, Name, Location, StartDate) VALUES('SP101', 'Product A', 'LA', DATE'2010-03-07');
INSERT INTO PROJECT(ProjectID, Name, Location, StartDate) VALUES('SP202', 'Product B', 'LA', DATE'2010-04-13');
INSERT INTO PROJECT(ProjectID, Name, Location, StartDate) VALUES('SP204', 'Product C', 'LA', DATE'2010-08-15');
INSERT INTO PROJECT(ProjectID, Name, Location, StartDate) VALUES('SP206', 'Product D', 'Chicago', DATE'2009-04-05');
INSERT INTO PROJECT(ProjectID, Name, Location, StartDate) VALUES('SP230', 'Product E', 'Chicago', DATE'2009-04-05');
INSERT INTO PROJECT(ProjectID, Name, Location, StartDate) VALUES('SP300', 'Product F', 'Chicago', DATE'2011-09-02');
INSERT INTO PROJECT(ProjectID, Name, Location, StartDate) VALUES('SP310', 'Product G', 'Chicago', DATE'2011-09-02');
INSERT INTO PROJECT(ProjectID, Name, Location, StartDate) VALUES('SP311', 'Product H', 'Seattle', DATE'2010-03-07');
INSERT INTO PROJECT(ProjectID, Name, Location, StartDate) VALUES('SP322', 'Product I', 'Seattle', DATE'2010-03-07');
INSERT INTO PROJECT(ProjectID, Name, Location, StartDate) VALUES('SP330', 'Product J', 'Houston', DATE'2010-10-25');
INSERT INTO PROJECT(ProjectID, Name, Location, StartDate) VALUES('SP360', 'Product K', 'Houston', DATE'2010-10-25');
INSERT INTO PROJECT(ProjectID, Name, Location, StartDate) VALUES('SP408', 'Product L', 'Houston', DATE'2009-04-05');

--WORKS_ON tuples
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(70547, 'SP310', 37);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(70547, 'SP408', 40);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(71041, 'SP204', 37);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(71041, 'SP330', 43);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(71041, 'SP360', 37);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80122, 'SP202', 33);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80122, 'SP204', 43);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80122, 'SP300', 37);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80122, 'SP310', 40);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80122, 'SP360', 43);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80122, 'SP408', 33);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80221, 'SP101', 27);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80221, 'SP202', 23);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80221, 'SP206', 40);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80221, 'SP230', 33);	
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80221, 'SP330', 40);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80412, 'SP202', 37);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80412, 'SP206', 23);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80412, 'SP300', 33);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(80412, 'SP360', 43);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90574, 'SP101', 37);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90574, 'SP202', 40);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90574, 'SP206', 43);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90574, 'SP230', 37);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90574, 'SP300', 33);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90574, 'SP310', 40);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90574, 'SP330', 40);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90610, 'SP101', 33);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90610, 'SP202', 33);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90610, 'SP206', 37);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90610, 'SP230', 33);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90714, 'SP101', 43);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90714, 'SP202', 33);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90714, 'SP230', 33);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90714, 'SP330', 37);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90912, 'SP101', 33);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90912, 'SP202', 33);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90912, 'SP206', 40);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90912, 'SP310', 37);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(90912, 'SP330', 40);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(91124, 'SP310', 33);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(91124, 'SP330', 37);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(91124, 'SP360', 40);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(91124, 'SP408', 37);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(70439, 'SP408', 35);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(70439, 'SP310', 32);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(81201, 'SP101', 32);
INSERT INTO WORKS_ON(EmployeeID, ProjectID, Hours) VALUES(81201, 'SP330', 31);

commit;
