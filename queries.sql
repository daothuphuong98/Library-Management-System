-- 1 Thông tin về Top 5 các tác giả hay được mượn nhất
SELECT TOP 5 AUTHOR, 
       RENT_COUNT,
	   CONVERT(DECIMAL(10, 2), (RENT_COUNT + 0.0)/(SELECT COUNT(*) FROM RENT) + 0.0) RENT_PERCENT
FROM (
	SELECT AUTHOR_ID, COUNT(*) RENT_COUNT
	FROM RENT r
	JOIN COPIES c ON c.COPIES_ID = r.COPIES_ID
	JOIN BOOK_AUTHOR ba ON ba.BOOK_ID = c.BOOK_ID
	GROUP BY ba.AUTHOR_ID) t
JOIN AUTHOR a ON a.AUTHOR_ID = t.AUTHOR_ID
ORDER BY RENT_COUNT DESC

--2 Thông tin về Top 5 các keyword hay được mượn nhất
SELECT TOP 5 KEYWORD, 
       RENT_COUNT,
	   CONVERT(DECIMAL(10, 2), (RENT_COUNT + 0.0)/(SELECT COUNT(*) FROM RENT) + 0.0) RENT_PERCENT
FROM (
	SELECT KEYWORD_ID, COUNT(*) RENT_COUNT
	FROM RENT r
	JOIN COPIES c ON c.COPIES_ID = r.COPIES_ID
	JOIN BOOK_KW bk ON bk.BOOK_ID = c.BOOK_ID
	GROUP BY bk.KEYWORD_ID) t
JOIN KEYWORD k ON k.KEYWORD_ID = t.KEYWORD_ID
ORDER BY RENT_COUNT DESC

-- 3 Thông tin về Top 5 các thể loại hay được mượn nhất
WITH t AS (
	SELECT (CATEGORY + '00') AS CAT, COUNT(*) CAT_COUNT
	FROM RENT r
	JOIN COPIES c ON c.COPIES_ID = r.COPIES_ID
	JOIN (SELECT *, SUBSTRING(DDC_ID, 1, 1) CATEGORY FROM BOOK) b ON b.BOOK_ID = c.BOOK_ID
	GROUP BY b.CATEGORY)
SELECT TOP 5 DDC.CATEGORY,
	   t.CAT_COUNT,
	   CONVERT(DECIMAL(10, 2), (CAT_COUNT + 0.0)/(SELECT COUNT(*) FROM RENT) + 0.0) CAT_PERCENT
FROM t
JOIN DDC ON DDC.DDC_ID = t.CAT
ORDER BY CAT_COUNT DESC

-- 4 Thông tin về các lỗi phạt hay gặp
-- ->Cân nhắc thắt chặt nội quy nếu tình trạng mất sách hay làm hỏng sách diễn ra thường xuyên

SELECT REASON, 
       COUNT(*) FINE_COUNT,
	   CONVERT(DECIMAL(10, 2), (COUNT(*) + 0.0)/(SELECT COUNT(*) FROM RENT) + 0.0) FINE_PERCENT
FROM FINE
GROUP BY REASON
ORDER BY FINE_COUNT DESC

-- 5 Thông tin về chất lượng các đầu sách
-- -> đảm bảo phần lớn các sách có trong thư viện đều ở tình trạng tốt
SELECT BOOK_STAT, 
	COUNT(*) STAT_COUNT, 
	CONVERT(DECIMAL(10, 2), 
	CAST(COUNT(*) AS FLOAT) / CAST((SELECT COUNT(*) FROM COPIES) AS FLOAT)) AS STAT_PERCENT
FROM COPIES
GROUP BY BOOK_STAT
ORDER BY STAT_COUNT DESC

--6 Số lượng staff từng vị trí -> kiểm tra xem có vị trí nào có quá nhiều nhân viên không 
SELECT TITLE, 
	   COUNT(TITLE) AS NUMBER,
	   CONVERT(DECIMAL(10, 2), (COUNT(TITLE) + 0.0)/(SELECT COUNT(*) FROM STAFF) + 0.0) PERCENTS
FROM STAFF
GROUP BY TITLE
ORDER BY NUMBER DESC

-- 7 Số lượng member đến mượn sách các ngày trong tuần 
-- -> thống kê xem ngày nào thường có nhiều người mượn để tăng cường nhân viên phục vụ
WITH t AS (
	SELECT *, DATENAME(WEEKDAY, RENT_DATE) AS DAY_OF_WEEK
	FROM RENT)

SELECT DAY_OF_WEEK, 
       COUNT(*) DAY_COUNT,
	   CONVERT(DECIMAL(10, 2), (COUNT(*) + 0.0)/(SELECT COUNT(*) FROM RENT) + 0.0) DAY_PERCENT
FROM t
GROUP BY DAY_OF_WEEK
ORDER BY DAY_COUNT DESC

-- 8 Thông tin độ tuổi của member chia thành các nhóm tuổi: dưới 30 (sinh sau 1991), 30 -45 (sinh 1976-1990), 45 - 60 (sinh 1961-1975), trên 60 tuổi (sinh trước 1960) 
-- -> nhập sách phù hợp với độ tuổi
WITH t AS 
	(SELECT *,
	CASE 
	 WHEN BIRTHDAY >= '1991-01-01' THEN 'Under 30'
	 WHEN BIRTHDAY BETWEEN '1976-01-01' AND '1990-12-31' THEN '30-45'
	 WHEN BIRTHDAY BETWEEN '1961-01-01' AND '1976- 12-31' THEN '45-60'
	 WHEN BIRTHDAY <= '1960-12-31' THEN 'Above 60'
	END AS AGE
	FROM MEMBER)

SELECT AGE, 
       COUNT(*) AGE_COUNT,
	   CONVERT(DECIMAL(10, 2), (COUNT(*) + 0.0)/(SELECT COUNT(*) FROM MEMBER) + 0.0) AGE_PERCENT
FROM t
GROUP BY AGE
ORDER BY AGE_COUNT DESC


-- 9 Thông tin các quyển sách chưa được mượn lần nào 
-- -> xem xét di chuyển vị trí các cuốn sách này ra các chỗ khác để nhường vị trí đẹp cho các quyển sách được mượn nhiều hơn
SELECT b.*
FROM BOOK b

EXCEPT

SELECT b.*
FROM RENT r
JOIN COPIES c ON c.COPIES_ID = r.COPIES_ID
JOIN BOOK b ON b.BOOK_ID = c.BOOK_ID

--10 Thông tin các member quen thuộc của thư viện. Biết rằng member quen thuộc là các member đến mượn sách ít nhất 3 lần--
SELECT t.MEMBER_ID, FIRST_NAME, LAST_NAME, RENT_COUNT
FROM MEMBER
JOIN (
	SELECT MEMBER_ID, COUNT(*) AS RENT_COUNT
	FROM RENT
	GROUP BY MEMBER_ID
	HAVING COUNT(*) >= 3) t ON t.MEMBER_ID = MEMBER.MEMBER_ID
ORDER BY RENT_COUNT DESC

--11 Thời gian trung bình mượn sách là bao lâu -> Xem có nhiều hơn số ngày mà thư viện đang quy định nhiều không nếu có cân nhắc tăng thời gian mượn sách để member không phải đến gia hạn nhiều lần
 SELECT CONVERT(DECIMAL(10, 2), AVG(CAST(RETURN_DATE - RENT_DATE AS FLOAT))) RENT_AVG
 FROM RENT