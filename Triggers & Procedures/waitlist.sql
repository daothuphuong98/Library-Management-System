/* Insert waitlist: INSERT INTO WAITLIST (MEMBER_ID, BOOK_ID) VALUES (@mmeber_id, @book_id)*/

-- When a copy is available, the first person on the waitlist get auto-reservation
CREATE TRIGGER auto_reserve
ON WAITLIST
AFTER UPDATE
AS
	DECLARE @prev_wait_stat VARCHAR(50)
	DECLARE @rec_wait_stat VARCHAR(50)
	DECLARE @book_id VARCHAR(10)
	DECLARE @member_id VARCHAR(10)
	DECLARE @copies_id VARCHAR(10)

	SELECT @rec_wait_stat = i.WAIT_STATUS FROM inserted i
	SELECT @prev_wait_stat = d.WAIT_STATUS FROM deleted d
	SELECT @book_id = i.BOOK_ID FROM inserted i
	SELECT @member_id = i.MEMBER_ID FROM inserted i

	BEGIN 
	IF @rec_wait_stat = 'Finished' and @prev_wait_stat = 'Waiting'
		BEGIN
		SELECT @copies_id = COPIES_ID FROM AVAILABLE_COPIES WHERE BOOK_ID = @book_id
		INSERT INTO RESERVE (COPIES_ID, MEMBER_ID) VALUES (@copies_id, @member_id)
		END
	END

-- When a new copy is inserted, check the waitlist of the book
CREATE TRIGGER CheckWaitlist
ON COPIES
AFTER INSERT
AS
	DECLARE @copy_id VARCHAR(10)
	DECLARE @book_id VARCHAR(10)
	SELECT @copy_id = i.COPIES_ID FROM inserted i
	SELECT @book_id = BOOK_ID FROM COPIES WHERE COPIES_ID = @copy_id

	BEGIN
	UPDATE WAITLIST_TOP
	SET WAIT_STATUS = 'Finished'
	WHERE BOOK_ID = @book_id
	END

-- Run daily to match people in waitlist with copies
CREATE PROCEDURE DailyCheckWaitlist
AS
	MERGE WAITLIST_TOP wlt
	USING (select distinct(book_id) from AVAILABLE_COPIES) avc
	ON wlt.BOOK_ID = avc.BOOK_ID
	WHEN MATCHED THEN UPDATE SET WAIT_STATUS = 'Finished';
