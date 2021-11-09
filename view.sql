-- Get first person on every waitlists
CREATE VIEW WAITLIST_TOP
AS (
	SELECT wl.BOOK_ID, wl.MEMBER_ID, wl.WAIT_DATE, wl.WAITLIST_ID, wl.WAIT_STATUS
	FROM 
		(SELECT * FROM WAITLIST
		 WHERE WAIT_STATUS = 'Waiting') wl
	JOIN 
		(SELECT BOOK_ID, MIN(WAIT_DATE) AS MIN_DATE
		FROM WAITLIST
		WHERE WAIT_STATUS = 'Waiting'
		GROUP BY BOOK_ID) t
	on t.BOOK_ID = wl.BOOK_ID and t.MIN_DATE = wl.WAIT_DATE
	)

	select * from LOST_COPIES

-- Get all available copies
CREATE VIEW AVAILABLE_COPIES
AS 
(
	SELECT * 
	FROM COPIES
	WHERE RENT_STAT = 'Available'
)

-- Get all overdue reservations
CREATE VIEW OVERDUE_RESERVE
AS 
(
	SELECT *
	FROM RESERVE
	WHERE GETDATE() > DUE_DATE AND RESERVE_STATUS = 'Reserved'
)

-- Get all borrowed copies that are considered potentially lost
CREATE VIEW POT_LOST_COPIES
AS
(
	SELECT *
	FROM RENT
	WHERE GETDATE() > DUE_DATE + 45 AND RETURN_DATE IS NULL
)
*/

-- Get all current rent
CREATE VIEW CURRENT_RENT
AS
(	
	SELECT c.*
	FROM RENT r
	JOIN COPIES c ON c.COPIES_ID = r.COPIES_ID
	WHERE r.RETURN_DATE IS NULL
)

-- Get all lost copies
CREATE VIEW LOST_COPIES
AS
(
	SELECT c.COPIES_ID, c.BOOK_ID, b.TITLE, c.ADDED_DATE,  t.FINE_DATE
	FROM COPIES c
	JOIN BOOK b ON b.BOOK_ID = c.BOOK_ID
	JOIN (SELECT  r.COPIES_ID, f.FINE_DATE
		  FROM RENT r
		  JOIN FINE f ON r.RENT_ID = f.RENT_ID
		  WHERE REASON = 'Lost copy') t ON t.COPIES_ID = c.COPIES_ID
	WHERE RENT_STAT = 'Lost'
)

-- Get all unpaid fines
CREATE VIEW UNPAID_FINE
AS
(
	SELECT *
	FROM FINE
	WHERE FINE_STATUS = 'Unpaid'
)
	
