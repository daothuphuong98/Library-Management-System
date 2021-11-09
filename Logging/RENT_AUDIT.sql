CREATE TABLE CHANGERENT
(	RENT_ID VARCHAR(50),
	FIELD NVARCHAR(30),
	OLD_DATA VARCHAR(50) DEFAULT NULL,
	NEW_DATA VARCHAR(50) DEFAULT NULL,
	ACTION_TIME smalldatetime);

create trigger rent_audit
on rent
after update, insert
as 
declare @new_rentid as INT;
declare @new_memberid as VARCHAR(10);
declare @new_copiesid as VARCHAR(10);
declare @new_rentdate as DATETIME;
declare @new_duedate as DATETIME;
declare @new_returndate as DATETIME;
declare @new_extend as INT;
declare @new_rentstaff as VARCHAR(10);
declare @new_returnstaff as VARCHAR(10);

declare @old_rentid as INT;
declare @old_memberid as VARCHAR(10);
declare @old_copiesid as VARCHAR(10);
declare @old_rentdate as DATETIME;
declare @old_duedate as DATETIME;
declare @old_returndate as DATETIME;
declare @old_extend as INT;
declare @old_rentstaff as VARCHAR(10);
declare @old_returnstaff as VARCHAR(10);

select @new_rentid = i.RENT_ID from inserted as i;
select @new_memberid = i.MEMBER_ID from inserted as i;
select @new_copiesid = i.COPIES_ID from inserted as i;
select @new_rentdate = i.RENT_DATE from inserted as i;
select @new_duedate = i.DUE_DATE from inserted as i;
select @new_returndate = i.RETURN_DATE from inserted as i;
select @new_extend = i.EXTEND from inserted as i;
select @new_rentstaff = i.RENT_STAFF from inserted as i;
select @new_returnstaff = i.RETURN_STAFF from inserted as i;

select @old_rentid = i.RENT_ID from deleted as i;
select @old_memberid = i.MEMBER_ID from deleted as i;
select @old_copiesid = i.COPIES_ID from deleted as i;
select @old_rentdate = i.RENT_DATE from deleted as i;
select @old_duedate = i.DUE_DATE from deleted as i;
select @old_returndate = i.RETURN_DATE from deleted as i;
select @old_extend = i.EXTEND from deleted as i;
select @old_rentstaff = i.RENT_STAFF from deleted as i;
select @old_returnstaff = i.RETURN_STAFF from deleted as i;

begin 
if @new_rentid <> @old_rentid or (@old_rentid is NULL and @new_rentid is not NULL) or (@old_rentid is not NULL and @new_rentid is NULL)
insert into CHANGERENT values (CAST(@new_rentid AS VARCHAR(50)), 'RENT_ID', CAST(@old_rentid AS VARCHAR(50)), CAST(@new_rentid AS VARCHAR(50)), SYSDATETIME())

if @new_memberid <> @old_memberid or (@old_memberid is NULL and @new_memberid is not NULL) or (@old_memberid is not NULL and @new_memberid is NULL)
insert into CHANGERENT values (CAST(@new_rentid AS VARCHAR(50)), 'MEMBER_ID', @old_memberid, @new_memberid, SYSDATETIME())

if @new_copiesid <> @old_copiesid or (@old_copiesid is NULL and @new_copiesid is not NULL) or (@old_copiesid is not NULL and @new_copiesid is NULL)
insert into CHANGERENT values (CAST(@new_rentid AS VARCHAR(50)), 'COPIES_ID', @old_copiesid, @new_copiesid, SYSDATETIME())

if @new_rentdate <> @old_rentdate or (@old_rentdate is NULL and @new_rentdate is not NULL) or (@old_rentdate is not NULL and @new_rentdate is NULL)
insert into CHANGERENT values (CAST(@new_rentid AS VARCHAR(50)), 'RENT_DATE', CAST(@old_rentdate AS VARCHAR(50)), CAST(@new_rentdate AS VARCHAR(50)), SYSDATETIME())

if @new_duedate <> @old_duedate or (@old_duedate is NULL and @new_duedate is not NULL) or (@old_duedate is not NULL and @new_duedate is NULL)
insert into CHANGERENT values (CAST(@new_rentid AS VARCHAR(50)), 'DUE_DATE', CAST(@old_duedate AS VARCHAR(50)), CAST(@new_duedate AS VARCHAR(50)), SYSDATETIME())

if @new_returndate <> @old_returndate or (@old_returndate is NULL and @new_returndate is not NULL) or (@old_returndate is not NULL and @new_returndate is NULL)
insert into CHANGERENT values (CAST(@new_rentid AS VARCHAR(50)), 'RETURN_DATE', CAST(@old_returndate AS VARCHAR(50)), CAST(@new_returndate AS VARCHAR(50)), SYSDATETIME())

if @new_extend <> @old_extend or (@old_extend is NULL and @new_extend is not NULL) or (@old_extend is not NULL and @new_extend is NULL)
insert into CHANGERENT values (CAST(@new_rentid AS VARCHAR(50)), 'EXTEND', CAST(@old_extend AS VARCHAR(50)), CAST(@new_extend AS VARCHAR(50)), SYSDATETIME())

if @new_rentstaff <> @old_rentstaff or (@old_rentstaff is NULL and @new_rentstaff is not NULL) or (@old_rentstaff is not NULL and @new_rentstaff is NULL)
insert into CHANGERENT values (CAST(@new_rentid AS VARCHAR(50)), 'RENT_STAFF', @old_rentstaff, @new_rentstaff, SYSDATETIME())

if @new_returnstaff <> @old_returnstaff or (@old_returnstaff is NULL and @new_returnstaff is not NULL) or (@old_returnstaff is not NULL and @new_returnstaff is NULL)
insert into CHANGERENT values (CAST(@new_rentid AS VARCHAR(50)), 'RETURN_STAFF', @old_returnstaff, @new_returnstaff, SYSDATETIME())
end;
