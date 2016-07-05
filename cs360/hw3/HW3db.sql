--- INITIALIZATION
SET LINESIZE 300;

drop table student cascade constraint;
drop table enroll cascade constraint;
drop table professor cascade constraint;
drop table course cascade constraint;

--- TABLE CREATION
create table student(
stuID 		char(30) 	not null,
stuName 	char(30),
year 		integer,
department 	char(30),
primary key(stuID)
);

create table professor(
profID		char(30)	not null,
profName	char(30),
department	char(30),
primary key(profID)
);

create table course(
courseID 	char(30) 	not null,
title 		char(30),
department 	char(30),
credit 		integer,
profID		char(30) references professor(profID) ON DELETE CASCADE,
primary key(courseID)
);

create table enroll(
courseID 	char(30) references course(courseID) ON DELETE CASCADE,
stuID		char(30) references student(stuID) ON DELETE CASCADE,
grade		char(4),
primary key(courseID, stuID)
);
commit;


insert into student values ('s20151436', 'Katherine', 2015, 'Computer Sciences');
insert into student values ('s20141583', 'Sunny', 2014, 'Computer Sciences');
insert into student values ('s20112432', 'Bob', 2011, 'Computer Sciences');
insert into student values ('s20122431', 'Stella', 2012, 'Computer Sciences');
insert into student values ('s20126532', 'Peter', 2012, 'Computer Sciences');
insert into student values ('s20131111', 'John', 2013, 'Electronic Engineering');
insert into student values ('s20133246', 'Daniel', 2013, 'Electronic Engineering');
insert into student values ('s20134718', 'David', 2013, 'Computer Sciences');
insert into student values ('s20104356', 'Olivia', 2010, 'Computer Sciences');
insert into student values ('s20113578', 'Esthel', 2011, 'Computer Sciences');

commit;

insert into professor values('p100', 'mhKim', 'Computer Sciences');
insert into professor values('p101', 'cdYoo', 'Electronic Engineering');
insert into professor values('p102', 'syRyu', 'Computer Sciences');
insert into professor values('p103', 'wanChoi', 'Electronic Engineering');
insert into professor values('p104', 'isShin', 'Computer Sciences');
insert into professor values('p105', 'guHwang', 'Mathematical Sciences');
insert into professor values('p106', 'ucLee', 'Knowledge Service Engineering');
insert into professor values('p107', 'tsHan', 'Computer Sciences');

commit;

insert into course values ('cs360', 'Database', 'Computer Sciences', 3, 'p100');
insert into course values ('ee202', 'Signal and System', 'Electronic Engineering', 3, 'p101');
insert into course values ('cs101', 'Programming', 'Computer Sciences', 3, 'p102');
insert into course values ('cs206', 'Data Structure', 'Computer Sciences', 3, 'p100');
insert into course values ('ee321', 'Communication Engineering', 'Electronic Engineering', 3, 'p103');
insert into course values ('cs330', 'Operating System', 'Computer Sciences', 3, 'p104');
insert into course values ('mas350', 'Elementary Probability Theory', 'Mathematical Sciences', 3, 'p105');
insert into course values ('kse631', 'Content Networking', 'Knowledge Service Engineering', 3, 'p106');
insert into course values ('cs220', 'Programming Principles', 'Computer Sciences', 3, 'p107');
insert into course values ('cs204', 'Discrete Mathmatics', 'Computer Sciences', 3, 'p102');

commit;


insert into enroll values('cs330', 's20151436', 'A');
insert into enroll values('cs360', 's20151436', 'A');
insert into enroll values('cs206', 's20151436', 'B');
insert into enroll values('cs220', 's20151436', 'A');
insert into enroll values('cs101', 's20151436', 'A');	
insert into enroll values('ee321', 's20131111', 'A');
insert into enroll values('cs330', 's20131111', 'B');
insert into enroll values('mas350', 's20112432', 'B');
insert into enroll values('kse631', 's20133246', 'A');	
insert into enroll values('cs330', 's20133246', 'A');
insert into enroll values('ee202', 's20133246', 'B');
insert into enroll values('cs360', 's20122431', 'A');
insert into enroll values('cs360', 's20104356', 'A');
insert into enroll values('cs360', 's20126532', 'B');
insert into enroll values('cs101', 's20113578', 'A');
insert into enroll values('cs204', 's20126532', 'A');
insert into enroll values('cs220', 's20112432', 'A');

commit;
