CREATE TABLE CHANGEWAITLIST
(	WAITLIST_ID VARCHAR(50),
	FIELD NVARCHAR(30),
	OLD_DATA VARCHAR(50) DEFAULT NULL,
	NEW_DATA VARCHAR(50) DEFAULT NULL,
	ACTION_TIME smalldatetime);

create trigger waitlist_audit
on waitlist
after update, insert
as 
declare @new_waitlistid as INT;
declare @new_memberid as VARCHAR(10);
declare @new_bookid as VARCHAR(10);
declare @new_waitdate as DATETIME;
declare @new_waitstatus as VARCHAR(50);

declare @old_waitlistid as INT;
declare @old_memberid as VARCHAR(10);
declare @old_bookid as VARCHAR(10);
declare @old_waitdate as DATETIME;
declare @old_waitstatus as VARCHAR(50);

select @new_waitlistid = i.WAITLIST_ID from inserted as i;
select @new_memberid = i.MEMBER_ID from inserted as i;
select @new_bookid = i.BOOK_ID from inserted as i;
select @new_waitdate = i.WAIT_DATE from inserted as i;
select @new_waitstatus = i.WAIT_STATUS from inserted as i;

select @old_waitlistid = i.WAITLIST_ID from deleted as i;
select @old_memberid = i.MEMBER_ID from deleted as i;
select @old_bookid = i.BOOK_ID from deleted as i;
select @old_waitdate = i.WAIT_DATE from deleted as i;
select @old_waitstatus = i.WAIT_STATUS from deleted as i;

begin 
if @new_waitlistid <> @old_waitlistid or (@old_waitlistid is NULL and @new_waitlistid is not NULL) or (@old_waitlistid is not NULL and @new_waitlistid is NULL)
insert into CHANGEWAITLIST values (CAST(@new_waitlistid AS VARCHAR(50)), 'WAITLIST_ID', CAST(@old_waitlistid AS VARCHAR(50)), CAST(@new_waitlistid AS VARCHAR(50)), SYSDATETIME())

if @new_memberid <> @old_memberid or (@old_memberid is NULL and @new_memberid is not NULL) or (@old_memberid is not NULL and @new_memberid is NULL)
insert into CHANGEWAITLIST values (CAST(@new_waitlistid AS VARCHAR(50)), 'MEMBER_ID', @old_memberid, @new_memberid, SYSDATETIME())

if @new_bookid <> @old_bookid or (@old_bookid is NULL and @new_bookid is not NULL) or (@old_bookid is not NULL and @new_bookid is NULL)
insert into CHANGEWAITLIST values (CAST(@new_waitlistid AS VARCHAR(50)), 'BOOK_ID', @old_bookid, @new_bookid, SYSDATETIME())

if @new_waitdate <> @old_waitdate or (@old_waitdate is NULL and @new_waitdate is not NULL) or (@old_waitdate is not NULL and @new_waitdate is NULL)
insert into CHANGEWAITLIST values (CAST(@new_waitlistid AS VARCHAR(50)), 'WAIT_DATE', CAST(@old_waitdate AS VARCHAR(50)), CAST(@new_waitdate AS VARCHAR(50)), SYSDATETIME())

if @new_waitstatus <> @old_waitstatus or (@old_waitstatus is NULL and @new_waitstatus is not NULL) or (@old_waitstatus is not NULL and @new_waitstatus is NULL)
insert into CHANGEWAITLIST values (CAST(@new_waitlistid AS VARCHAR(50)), 'WAIT_STATUS', @old_waitstatus, @new_waitstatus, SYSDATETIME())
end;
