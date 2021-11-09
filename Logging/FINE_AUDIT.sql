CREATE TABLE CHANGEFINE
(	FINE_ID VARCHAR(50),
	FIELD NVARCHAR(30),
	OLD_DATA VARCHAR(50) DEFAULT NULL,
	NEW_DATA VARCHAR(50) DEFAULT NULL,
	ACTION_TIME smalldatetime);

create trigger fine_audit
on fine
after update, insert
as 
declare @new_fineid as INT;
declare @new_rentid as INT;
declare @new_fineamount as FLOAT;
declare @new_memberid as VARCHAR(10);
declare @new_finedate as DATETIME;
declare @new_reason as VARCHAR(255);
declare @new_afterstatus as VARCHAR(255);
declare @new_finestatus as VARCHAR(50);

declare @old_fineid as INT;
declare @old_rentid as INT;
declare @old_fineamount as FLOAT;
declare @old_memberid as VARCHAR(10);
declare @old_finedate as DATETIME;
declare @old_reason as VARCHAR(255);
declare @old_afterstatus as VARCHAR(255);
declare @old_finestatus as VARCHAR(50);

select @new_fineid = i.FINE_ID from inserted as i;
select @new_rentid = i.RENT_ID from inserted as i;
select @new_fineamount = i.FINE_AMOUNT from inserted as i;
select @new_memberid = i.MEMBER_ID from inserted as i;
select @new_finedate = i.FINE_DATE from inserted as i;
select @new_reason = i.REASON from inserted as i;
select @new_afterstatus = i.AFTER_STATUS from inserted as i;
select @new_finestatus = i.FINE_STATUS from inserted as i;

select @old_fineid = i.FINE_ID from deleted as i;
select @old_rentid = i.RENT_ID from deleted as i;
select @old_fineamount = i.FINE_AMOUNT from deleted as i;
select @old_memberid = i.MEMBER_ID from deleted as i;
select @old_finedate = i.FINE_DATE from deleted as i;
select @old_reason = i.REASON from deleted as i;
select @old_afterstatus = i.AFTER_STATUS from deleted as i;
select @old_finestatus = i.FINE_STATUS from deleted as i;

begin 
if @new_fineid <> @old_fineid or (@old_fineid is NULL and @new_fineid is not NULL) or (@old_fineid is not NULL and @new_fineid is NULL)
insert into CHANGEFINE values (CAST(@new_fineid AS VARCHAR(50)), 'FINE_ID', CAST(@old_fineid AS VARCHAR(50)), CAST(@new_fineid AS VARCHAR(50)), SYSDATETIME())

if @new_rentid <> @old_rentid or (@old_rentid is NULL and @new_rentid is not NULL) or (@old_rentid is not NULL and @new_rentid is NULL)
insert into CHANGEFINE values (CAST(@new_fineid AS VARCHAR(50)), 'RENT_ID', CAST(@old_rentid AS VARCHAR(50)), CAST(@new_rentid AS VARCHAR(50)), SYSDATETIME())

if @new_fineamount <> @old_fineamount or (@old_fineamount is NULL and @new_fineamount is not NULL) or (@old_fineamount is not NULL and @new_fineamount is NULL)
insert into CHANGEFINE values (CAST(@new_fineid AS VARCHAR(50)), 'FINE_AMOUNT', @old_fineamount, @new_fineamount, SYSDATETIME())

if @new_memberid <> @old_memberid or (@old_memberid is NULL and @new_memberid is not NULL) or (@old_memberid is not NULL and @new_memberid is NULL)
insert into CHANGEFINE values (CAST(@new_fineid AS VARCHAR(50)), 'MEMBER_ID', @old_memberid, @new_memberid, SYSDATETIME())

if @new_finedate <> @old_finedate or (@old_finedate is NULL and @new_finedate is not NULL) or (@old_finedate is not NULL and @new_finedate is NULL)
insert into CHANGEFINE values (CAST(@new_fineid AS VARCHAR(50)), 'FINE_DATE', CAST(@old_finedate AS VARCHAR(50)), CAST(@new_finedate AS VARCHAR(50)), SYSDATETIME())

if @new_reason <> @old_reason or (@old_reason is NULL and @new_reason is not NULL) or (@old_reason is not NULL and @new_reason is NULL)
insert into CHANGEFINE values (CAST(@new_fineid AS VARCHAR(50)), 'REASON', @old_reason, @new_reason, SYSDATETIME())

if @new_afterstatus <> @old_afterstatus or (@old_afterstatus is NULL and @new_afterstatus is not NULL) or (@old_afterstatus is not NULL and @new_afterstatus is NULL)
insert into CHANGEFINE values (CAST(@new_fineid AS VARCHAR(50)), 'AFTER_STATUS', @old_afterstatus, @new_afterstatus, SYSDATETIME())

if @new_finestatus <> @old_finestatus or (@old_finestatus is NULL and @new_finestatus is not NULL) or (@old_finestatus is not NULL and @new_finestatus is NULL)
insert into CHANGEFINE values (CAST(@new_fineid AS VARCHAR(50)), 'FINE_STATUS', @old_finestatus, @new_finestatus, SYSDATETIME())
end;

