-- Make fine for overdue return, damaged copy and lost copy
CREATE PROCEDURE MakeFine
@rent_id VARCHAR(10),
@reason VARCHAR(255),
@after_stat VARCHAR(255) = NULL
AS
	BEGIN
	DECLARE @user_id VARCHAR(10)
	SELECT @user_id = MEMBER_ID FROM RENT WHERE RENT_ID = @rent_id

	DECLARE @fine_amt FLOAT
	DECLARE @copy_id VARCHAR(10)
	
	IF @reason = 'Overdue' 
		BEGIN
		SELECT @fine_amt = CAST(DAYDIFF(DAY, DUE_DATE, RETURN_DATE) AS FLOAT) FROM RENT WHERE RENT_ID = @rent_id   
		INSERT INTO FINE (RENT_ID, MEMBER_ID, FINE_AMOUNT, REASON) VALUES (@rent_id, @user_id, @fine_amt, @reason)
		RETURN
		END
	IF @reason = 'Damaged copy'
		IF @after_stat IS NULL
			BEGIN
			RAISERROR ('The copy status must be entered', 0, 0)
			RETURN
			END
		ELSE
			BEGIN
			SELECT @fine_amt =  b.PRICE * 0.3 FROM RENT r 
				JOIN COPIES c ON r.COPIES_ID = c.COPIES_ID   
				JOIN BOOK b ON b.BOOK_ID = c.BOOK_ID
				WHERE r.RENT_ID = @rent_id
			INSERT INTO FINE (RENT_ID, MEMBER_ID, FINE_AMOUNT, REASON) VALUES (@rent_id, @user_id, @fine_amt, @reason)

			SELECT @copy_id =  COPIES_ID FROM RENT WHERE RENT_ID = @rent_id
			UPDATE COPIES
			SET BOOK_STAT = @after_stat
			WHERE COPIES_ID = @copy_id
			RETURN
			END
	IF @reason = 'Lost copy'
		BEGIN
		SELECT @fine_amt =  b.PRICE + 5 FROM RENT r 
			JOIN COPIES c ON r.COPIES_ID = c.COPIES_ID   
			JOIN BOOK b ON b.BOOK_ID = c.BOOK_ID
			WHERE r.RENT_ID = @rent_id
		INSERT INTO FINE (RENT_ID, MEMBER_ID, FINE_AMOUNT, REASON) VALUES (@rent_id, @user_id, @fine_amt, @reason)
		
		SELECT @copy_id =  COPIES_ID FROM RENT WHERE RENT_ID = @rent_id
		UPDATE COPIES
		SET BOOK_STAT = 'Lost', RENT_STAT = 'Lost'
		WHERE COPIES_ID = @copy_id
		RETURN
		END
	END

-- Update fine status when a new fine invoice is inserted
CREATE TRIGGER check_invoice
ON FINE_INV
AFTER INSERT
AS	
	DECLARE @fine_id INT;
	SELECT @fine_id = i.FINE_ID FROM inserted i;
	DECLARE @inv_id INT;
	SELECT @inv_id = i.INV_ID FROM inserted i;	
	DECLARE @inv_amt FLOAT;
	SELECT @inv_amt  = i.INV_AMOUNT FROM inserted i;

	IF NOT EXISTS (SELECT * FROM FINE WHERE FINE_ID = @fine_id AND FINE_AMOUNT = @inv_amt)
		UPDATE FINE_INV
		SET INV_STATUS = 'Error'
		WHERE INV_ID = @inv_id
	ELSE
		BEGIN
		UPDATE FINE_INV
		SET INV_STATUS = 'Finished'
		WHERE INV_ID = @inv_id

		UPDATE FINE
		SET FINE_STATUS = 'Paid'
		WHERE FINE_ID = @fine_id
		END