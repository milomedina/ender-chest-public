--- INITIALIZATION
SET LINESIZE 300;

drop table USERS cascade constraint;
drop table LOGS cascade constraint;

--- TABLE CREATION
create table USERS(
UserID 		varchar2(10) 	not null,
Passwd	 	varchar2(10)	not null,
UserMoney 	integer			not null,
primary key(UserID)
);

create table LOGS(
LogDate 	DATE	not null,
UserID 		varchar2(10) 	references USERS(UserID) ON DELETE CASCADE,
UserMode 		varchar2(10),
OtherID 	varchar2(10)		references USERS(UserID) ON DELETE CASCADE,
MoneyIn 	integer,
MoneyOut	integer
);

commit;

