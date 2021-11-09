CREATE TABLE CHANGERESERVE
(	RESERVE_ID VARCHAR(50),
	FIELD NVARCHAR(30),
	OLD_DATA VARCHAR(50) DEFAULT NULL,
	NEW_DATA VARCHAR(50) DEFAULT NULL,
	ACTION_TIME smalldatetime);
	 
create trigger reserve_audit
on reserve
after update, insert
as 
declare @new_reserveid as INT;
declare @new_copiesid as VARCHAR(10);
declare @new_memberid as VARCHAR(10);
declare @new_reservedate as DATETIME;
declare @new_duedate as DATETIME;
declare @new_reservestatus as VARCHAR(50);

declare @old_reserveid as INT;
declare @old_copiesid as VARCHAR(10);
declare @old_memberid as VARCHAR(10);
declare @old_reservedate as DATETIME;
declare @old_duedate as DATETIME;
declare @old_reservestatus as VARCHAR(50);

select @new_reserveid = i.RESERVE_ID from inserted as i;
select @new_copiesid = i.COPIES_ID from inserted as i;
select @new_memberid = i.MEMBER_ID from inserted as i;
select @new_reservedate = i.RESERVE_DATE from inserted as i;
select @new_duedate = i.DUE_DATE from inserted as i;
select @new_reservestatus = i.RESERVE_STATUS from inserted as i;

select @old_reserveid = i.RESERVE_ID from deleted as i;
select @old_copiesid = i.COPIES_ID from deleted as i;
select @old_memberid = i.MEMBER_ID from deleted as i;
select @old_reservedate = i.RESERVE_DATE from deleted as i;
select @old_duedate = i.DUE_DATE from deleted as i;
select @old_reservestatus = i.RESERVE_STATUS from deleted as i;

begin 
if @new_reserveid <> @old_reserveid or (@old_reserveid is NULL and @new_reserveid is not NULL) or (@old_reserveid is not NULL and @new_reserveid is NULL)
insert into CHANGERESERVE values (CAST(@new_reserveid AS VARCHAR(50)), 'RESERVE_ID', CAST(@old_reserveid AS VARCHAR(50)), CAST(@new_reserveid AS VARCHAR(50)), SYSDATETIME())

if @new_copiesid <> @old_copiesid or (@old_copiesid is NULL and @new_copiesid is not NULL) or (@old_copiesid is not NULL and @new_copiesid is NULL)
insert into CHANGERESERVE values (CAST(@new_reserveid AS VARCHAR(50)), 'COPIES_ID', @old_copiesid, @new_copiesid, SYSDATETIME())

if @new_memberid <> @old_memberid or (@old_memberid is NULL and @new_memberid is not NULL) or (@old_memberid is not NULL and @new_memberid is NULL)
insert into CHANGERESERVE values (CAST(@new_reserveid AS VARCHAR(50)), 'MEMBER_ID', @old_memberid, @new_memberid, SYSDATETIME())

if @new_reservedate <> @old_reservedate or (@old_reservedate is NULL and @new_reservedate is not NULL) or (@old_reservedate is not NULL and @new_reservedate is NULL)
insert into CHANGERESERVE values (CAST(@new_reserveid AS VARCHAR(50)), 'RESERVE_DATE', CAST(@old_reservedate AS VARCHAR(50)), CAST(@new_reservedate AS VARCHAR(50)), SYSDATETIME())

if @new_duedate <> @old_duedate or (@old_duedate is NULL and @new_duedate is not NULL) or (@old_duedate is not NULL and @new_duedate is NULL)
insert into CHANGERESERVE values (CAST(@new_reserveid AS VARCHAR(50)), 'DUE_DATE', CAST(@old_duedate AS VARCHAR(50)), CAST(@new_duedate AS VARCHAR(50)), SYSDATETIME())

if @new_reservestatus <> @old_reservestatus or (@old_reservestatus is NULL and @new_reservestatus is not NULL) or (@old_reservestatus is not NULL and @new_reservestatus is NULL)
insert into CHANGERESERVE values (CAST(@new_reserveid AS VARCHAR(50)), 'RESERVE_STATUS', @old_reservestatus, @new_reservestatus, SYSDATETIME())
end;
