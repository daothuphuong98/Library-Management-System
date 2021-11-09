/* Insert rent: INSERT INTO RENT (MEMBER_ID, COPIES_ID, RENT_STAFF) VALUES (@member_id, @copies_id, @rent_staff) */

-- Check conditions of user before borrowing copies
CREATE TRIGGER reserve_check_and_update_status
ON RENT
INSTEAD OF INSERT
AS
DECLARE @member_id as VARCHAR(10);
DECLARE @copies_id as VARCHAR(10);
DECLARE @rent_staff as VARCHAR(10);

SELECT @member_id = i.MEMBER_ID from inserted i;
SELECT @copies_id = i.COPIES_ID from inserted i;
SELECT @rent_staff = i.RENT_STAFF from inserted i;

BEGIN
	IF EXISTS (SELECT * FROM RESERVE WHERE MEMBER_ID <> @member_id AND  COPIES_ID = @copies_id AND RESERVE_STATUS = 'Reserved')
		BEGIN
		RAISERROR('Warning: This copy has already been reserved', 0,0)
		RETURN
		END
	ELSE
		BEGIN
		DECLARE @rent_num INT
		SELECT @rent_num = COUNT(*) FROM RENT WHERE MEMBER_ID = @member_id AND RETURN_DATE IS NULL
		IF @rent_num >= 2
			BEGIN
			RAISERROR('Warning: Member has already rented 2 books', 0,0)
			RETURN
			END
		ELSE
			BEGIN
			IF EXISTS (SELECT * FROM UNPAID_FINE WHERE MEMBER_ID = @member_id)
				BEGIN
				RAISERROR('Warning: Member has unpaid fine(s)', 0,0)
				RETURN
				END
			ELSE
				BEGIN
				INSERT INTO RENT (MEMBER_ID, COPIES_ID, RENT_STAFF) VALUES (@member_id, @copies_id, @rent_staff)
			
				UPDATE RESERVE
				SET RESERVE_STATUS = 'Finished'
				WHERE MEMBER_ID = @member_id AND  COPIES_ID = @copies_id

				UPDATE COPIES
				SET RENT_STAT = 'Rented'
				WHERE COPIES_ID = @copies_id
				END
			END
		END
END


-- Return book, make fine and update waitlist
CREATE PROCEDURE ReturnBook
@copies_id VARCHAR(10),
@member_id VARCHAR(10),
@return_staff VARCHAR(10)
AS
	BEGIN
	IF NOT EXISTS (SELECT 1 FROM RENT WHERE COPIES_ID = @copies_id AND MEMBER_ID =  @member_id AND RETURN_DATE IS NULL)
		BEGIN
		RAISERROR('Warning: This copy has not been rented', 0,0)
		RETURN
		END
	ELSE
		BEGIN
		DECLARE @rent_id VARCHAR(10)
		SELECT @rent_id = RENT_ID FROM RENT WHERE COPIES_ID = @copies_id AND RETURN_DATE IS NULL AND MEMBER_ID =  @member_id
		DECLARE @late INT
		SELECT @late = DATEDIFF(DAY, GETDATE(), (SELECT DUE_DATE FROM RENT WHERE RENT_ID = @rent_id))

		UPDATE RENT
		SET RETURN_DATE = GETDATE(),
			RETURN_STAFF = @return_staff
		WHERE RENT_ID = @rent_id

		IF @late < 0
		EXEC MakeFine @rent_id, 'Overdue'

		UPDATE COPIES
		SET RENT_STAT = 'Available'
		WHERE COPIES_ID = @copies_id

		DECLARE @book_id varchar(10)
		SELECT @book_id = book_id from COPIES where COPIES_ID = @copies_id
		UPDATE WAITLIST_TOP
		SET WAIT_STATUS = 'Finished'
		WHERE MEMBER_ID = (SELECT MEMBER_ID FROM WAITLIST_TOP WHERE BOOK_ID = @book_id)
		END
	END


-- Extend rent
CREATE PROCEDURE ExtendRent
@rent_id VARCHAR(10)
AS
	BEGIN
	IF NOT EXISTS (SELECT 1 FROM RENT WHERE RENT_ID = @rent_id and RETURN_DATE IS NULL)
		BEGIN
		RAISERROR('Warning: User has not rented this copy', 0,0)
		RETURN
		END
	ELSE
		DECLARE @extend INT
		SELECT @extend = EXTEND FROM RENT WHERE RENT_ID = @rent_id
		IF @extend >= 2
			BEGIN
			RAISERROR('Warning: Max extension reached, cannot further extend the due date', 0,0)
			RETURN
			END
		ELSE
			UPDATE RENT
			SET EXTEND = @extend + 1, DUE_DATE = DUE_DATE + 15
			WHERE RENT_ID = @rent_id
	END

-- Run daily to charge fine to users who potentially lose the copies
CREATE PROCEDURE DailyCheckLostCopies
@return_staff VARCHAR(10)
AS
	BEGIN
	DECLARE cursorLost CURSOR
	FOR SELECT RENT_ID FROM POT_LOST_COPIES

	OPEN cursorLost
		DECLARE @rent_id VARCHAR(10)
		FETCH NEXT FROM cursorLost INTO @rent_id
		WHILE @@FETCH_STATUS = 0 
			BEGIN
			EXEC MAKE_FINE @rent_id, 'Lost copy'
			FETCH NEXT FROM cursorLost INTO @rent_id
			END
	CLOSE cursorLost
	
	UPDATE POT_LOST_COPIES
	SET RETURN_DATE = GETDATE(),
		RETURN_STAFF = @return_staff
	END








