CREATE TABLE CHANGECOPIES
(	COPIES_ID VARCHAR(50),
	FIELD NVARCHAR(30),
	OLD_DATA VARCHAR(50) DEFAULT NULL,
	NEW_DATA VARCHAR(50) DEFAULT NULL,
	ACTION_TIME smalldatetime
);

create trigger copies_audit
on copies
after update, insert
as 
declare @new_copiesid as VARCHAR(10);
declare @new_bookid as VARCHAR(10);
declare @new_rentstat as VARCHAR(20);
declare @new_bookstat as VARCHAR(255);
declare @new_addeddate as DATETIME;

declare @old_copiesid as VARCHAR(10);
declare @old_bookid as VARCHAR(10);
declare @old_rentstat as VARCHAR(20);
declare @old_bookstat as VARCHAR(255);
declare @old_addeddate as DATETIME;

select @new_copiesid = i.COPIES_ID from inserted as i;
select @new_bookid = i.BOOK_ID from inserted as i;
select @new_rentstat = i.RENT_STAT from inserted as i;
select @new_bookstat = i.BOOK_STAT from inserted as i;
select @new_addeddate = i.ADDED_DATE from inserted as i;

select @old_copiesid = i.COPIES_ID from deleted as i;
select @old_bookid = i.BOOK_ID from deleted as i;
select @old_rentstat = i.RENT_STAT from deleted as i;
select @old_bookstat = i.BOOK_STAT from deleted as i;
select @old_addeddate = i.ADDED_DATE from deleted as i;

begin 
if @new_copiesid <> @old_copiesid or (@old_copiesid is NULL and @new_copiesid is not NULL) or (@old_copiesid is not NULL and @new_copiesid is NULL)
insert into CHANGECOPIES values (@new_copiesid, 'COPIES_ID', @old_copiesid, @new_copiesid, SYSDATETIME())

if @new_bookid <> @old_bookid or (@old_bookid is NULL and @new_bookid is not NULL) or (@old_bookid is not NULL and @new_bookid is NULL)
insert into CHANGECOPIES values (@new_copiesid, 'BOOK_ID', @old_bookid, @new_bookid, SYSDATETIME())

if @new_rentstat <> @old_rentstat or (@old_rentstat is NULL and @new_rentstat is not NULL) or (@old_rentstat is not NULL and @new_rentstat is NULL)
insert into CHANGECOPIES values (@new_copiesid, 'RENT_STAT', @old_rentstat, @new_rentstat, SYSDATETIME())

if @new_bookstat <> @old_bookstat or (@old_bookstat is NULL and @new_bookstat is not NULL) or (@old_bookstat is not NULL and @new_bookstat is NULL)
insert into CHANGECOPIES values (@new_copiesid, 'BOOK_STAT', @old_bookstat, @new_bookstat, SYSDATETIME())

if @new_addeddate <> @old_addeddate or (@old_addeddate is NULL and @new_addeddate is not NULL) or (@old_addeddate is not NULL and @new_addeddate is NULL)
insert into CHANGECOPIES values (@new_copiesid, 'ADDED_DATE', CAST(@old_addeddate AS VARCHAR(50)), CAST(@new_addeddate AS VARCHAR(50)), SYSDATETIME())
end;
