-- Send email to subscribers
CREATE PROCEDURE SubNoti
@email VARCHAR(100),
@message VARCHAR(120) OUTPUT
AS SELECT @message = 'Sent email to' + @email

-- Send emails to subscribers to notify new magazines
CREATE TRIGGER check_subscribe
ON MAG_COPIES
AFTER INSERT
AS
	DECLARE @mag_id VARCHAR(10)
	SELECT @mag_id = i.MAG_ID FROM inserted i;

	DECLARE cursorSub CURSOR FOR
	SELECT EMAIL
	FROM SUBSCRIBE
	JOIN MEMBER ON MEMBER.MEMBER_ID = SUBSCRIBE.MEMBER_ID
	WHERE MAG_ID = 'MAG03' and SUB_STATUS = 'Active'

	OPEN cursorSub
	DECLARE @email VARCHAR(10)
	FETCH NEXT FROM cursorSub INTO @email
	WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @message VARCHAR(120)
			EXEC SubNoti @email, @message output
			PRINT @message
			FETCH NEXT FROM cursorSub INTO @email
		END
	CLOSE cursorSub
	DEALLOCATE cursorSub