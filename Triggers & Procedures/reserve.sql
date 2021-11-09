/* Insert reserve: INSERT INTO RESERVE(COPIES_ID, MEMBER_ID) VALUES (@COPIES_ID, @MEMBER_ID)*/

-- Change status of a copy to 'Reserved' after being reserved
CREATE TRIGGER change_status_reserve
ON RESERVE
AFTER INSERT
AS
DECLARE @copies_id as VARCHAR(10);
DECLARE @member_id as VARCHAR(10);
DECLARE @reserve_num as INT

SELECT @copies_id = i.COPIES_ID from inserted i;
SELECT @member_id = i.MEMBER_ID from inserted i;
SELECT @reserve_num = COUNT(*) FROM RESERVE WHERE MEMBER_ID = @member_id AND RESERVE_STATUS = 'Reserved'

BEGIN
	IF (@reserve_num >= 3) or (NOT EXISTS (SELECT * FROM AVAILABLE_COPIES WHERE COPIES_ID = @copies_id) )
		BEGIN
		RAISERROR('Copy is not available for reservation', 0, 0)
		ROLLBACK TRANSACTION
		END
	ELSE
		UPDATE COPIES
		SET RENT_STAT = 'Reserved'
		WHERE COPIES_ID = @copies_id
END

-- Run daily to cancel overdue reservation
CREATE PROCEDURE DailyCancelReserve
AS
	BEGIN
	MERGE COPIES
	USING OVERDUE_RESERVE ovr
	ON ovr.COPIES_ID = COPIES.COPIES_ID
	WHEN MATCHED THEN UPDATE SET RENT_STAT = 'Available';

	MERGE WAITLIST_TOP
	USING 
		(SELECT ovr.*, distinct COPIES.BOOK_ID 
			FROM OVERDUE_RESERVE ovr
			JOIN COPIES ON COPIES.COPIES_ID = ovr.COPIES_ID) t
	ON t.BOOK_ID = WAITLIST_TOP.BOOK_ID
	WHEN MATCHED THEN UPDATE SET WAIT_STATUS = 'Finished';

	UPDATE OVERDUE_RESERVE
	SET RESERVE_STATUS = 'Cancelled'
	END

-- Cancel reservation
CREATE PROCEDURE CancelReserve
@reserve_id VARCHAR(10)
AS
	BEGIN
	DECLARE @copies_id VARCHAR(10)
	SELECT @copies_id = COPIES_ID FROM RESERVE WHERE RESERVE_ID = @reserve_id
	UPDATE RESERVE
	SET RESERVE_STATUS = 'Cancelled'
	WHERE RESERVE_ID = @reserve_id

	UPDATE COPIES
	SET RENT_STAT = 'Available'
	WHERE COPIES_ID = @copies_id

	DECLARE @book_id varchar(10)
	SELECT @book_id = book_id from COPIES where COPIES_ID = @copies_id
	UPDATE WAITLIST_TOP
	SET WAIT_STATUS = 'Finished'
	WHERE MEMBER_ID = (SELECT MEMBER_ID FROM WAITLIST_TOP WHERE BOOK_ID = @book_id)
	END
	


