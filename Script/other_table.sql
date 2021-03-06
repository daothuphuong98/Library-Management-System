CREATE TABLE RENT 
(
	RENT_ID INT IDENTITY(1,1) PRIMARY KEY,
	MEMBER_ID VARCHAR(10) REFERENCES MEMBER(MEMBER_ID),
	COPIES_ID VARCHAR(10) REFERENCES COPIES(COPIES_ID),
	RENT_DATE DATETIME DEFAULT GETDATE(),
	DUE_DATE DATETIME DEFAULT DATEADD(DAY, 15, GETDATE()),
	RETURN_DATE DATETIME DEFAULT NULL,
	EXTEND INT DEFAULT 0,
	RENT_STAFF VARCHAR(10) REFERENCES STAFF(STAFF_ID),
	RETURN_STAFF VARCHAR(10) REFERENCES STAFF(STAFF_ID) DEFAULT NULL
)

CREATE TABLE RESERVE
(
	RESERVE_ID INT IDENTITY(1,1) PRIMARY KEY,
	COPIES_ID VARCHAR(10) REFERENCES COPIES(COPIES_ID),
	MEMBER_ID VARCHAR(10) REFERENCES MEMBER(MEMBER_ID),
	RESERVE_DATE DATETIME DEFAULT GETDATE(),
	DUE_DATE DATETIME DEFAULT DATEADD(DAY, 2, GETDATE()),
	RESERVE_STATUS VARCHAR(50) DEFAULT 'Reserved'
)

CREATE TABLE WAITLIST
(
	WAITLIST_ID INT IDENTITY(1,1) PRIMARY KEY,
	MEMBER_ID VARCHAR(10) REFERENCES MEMBER(MEMBER_ID),
	BOOK_ID VARCHAR(10) REFERENCES BOOK(BOOK_ID),
	WAIT_DATE DATETIME DEFAULT GETDATE(),
	WAIT_STATUS VARCHAR(50) DEFAULT 'Waiting'
	
)

CREATE TABLE FINE
(
	FINE_ID INT IDENTITY(1,1) PRIMARY KEY,
	RENT_ID INT REFERENCES RENT(RENT_ID),
	FINE_AMOUNT FLOAT,
	MEMBER_ID VARCHAR(10) REFERENCES MEMBER(MEMBER_ID),
	FINE_DATE DATETIME DEFAULT GETDATE(),
	REASON VARCHAR(255),
	AFTER_STATUS VARCHAR(255),
	FINE_STATUS VARCHAR(50) DEFAULT 'Unpaid'
)

CREATE TABLE FINE_INV
(
	INV_ID INT IDENTITY(1,1) PRIMARY KEY,
	FINE_ID INT REFERENCES FINE(FINE_ID),
	INV_AMOUNT FLOAT,
	INV_DATE DATETIME,
	INV_STATUS VARCHAR(50) DEFAULT 'Processing'
)


INSERT INTO RENT VALUES('GH667043', 'AV236', '2021-01-01', '2021-01-16', '2021-01-16', '0', '1543C', '4199A')
INSERT INTO RENT VALUES('GI405583', 'AV138', '2021-01-03', '2021-01-18', '2021-01-17', '0', '5928D', '2447F')
INSERT INTO RENT VALUES('FB787898', 'Al11878', '2021-01-03', '2021-02-17', '2021-02-28', '2', '2447F', '5889G')
INSERT INTO RENT VALUES('AE456176', 'AV121', '2021-01-03', '2021-01-18', '2021-01-16', '0', '4199A', '2447F')
INSERT INTO RENT VALUES('HB855934', 'AV587', '2021-01-04', '2021-02-03', '2021-02-03', '1', '5928D', '1543C')
INSERT INTO RENT VALUES('CH741977', 'AL141', '2021-01-05', '2021-02-04', '2021-02-03', '1', '5452E', '4199A')
INSERT INTO RENT VALUES('AA477915', 'AL7040', '2021-01-08', '2021-02-22', '2021-02-04', '2', '1543C', '4806A')
INSERT INTO RENT VALUES('HB361155', 'AV413', '2021-01-10', '2021-02-24', '2021-02-20', '2', '2447F', '5452E')
INSERT INTO RENT VALUES('HB965115', 'AV695', '2021-01-12', '2021-02-11', '2021-02-10', '1', '5452E', '6259B')
INSERT INTO RENT VALUES('HG282354', 'AV28', '2021-01-14', '2021-01-29', '2021-02-03', '0', '5889G', '2447F')
INSERT INTO RENT VALUES('FC163629', 'AL10773', '2021-01-14', '2021-01-29', '2021-02-02', '0', '1543C', '5452E')
INSERT INTO RENT VALUES('AA477915', 'AV697', '2021-01-14', '2021-02-13', '2021-02-10', '1', '5889G', '6259B')
INSERT INTO RENT VALUES('DG216156', 'AL8300', '2021-01-15', '2021-01-30', '2021-01-25', '0', '1543C', '4199A')
INSERT INTO RENT VALUES('HF488022', 'AV456', '2021-01-21', '2021-03-07', '2021-03-03', '2', '6259B', '5452E')
INSERT INTO RENT VALUES('FF107722', 'AV696', '2021-01-24', '2021-02-23', '2021-02-20', '1', '9724A', '1543C')
INSERT INTO RENT VALUES('HB965115', 'AL84666', '2021-01-25', '2021-02-24', '2021-02-24', '1', '4806A', '9724A')
INSERT INTO RENT VALUES('CA163551', 'AL11879', '2021-01-28', '2021-02-12', '2021-02-10', '0', '2447F', '1543C')
INSERT INTO RENT VALUES('ID935100', 'AL138', '2021-01-30', '2021-02-14', '2021-02-18', '0', '5889G', '9724A')
INSERT INTO RENT VALUES('GI396298', 'AL13866', '2021-01-31', '2021-03-02', '2021-03-08', '1', '2447F', '4199A')
INSERT INTO RENT VALUES('HB965115', 'AV414', '2021-02-01', '2021-03-18', '2021-03-23', '2', '6259B', '1543C')
INSERT INTO RENT VALUES('DA800392', 'AL8637', '2021-02-02', '2021-02-17', '2021-02-16', '0', '5889G', '4199A')
INSERT INTO RENT VALUES('HB361155', 'AL12642', '2021-02-03', '2021-02-18', '2021-02-15', '0', '5889G', '5452E')
INSERT INTO RENT VALUES('DB228004', 'AV112', '2021-02-03', '2021-03-20', '2021-03-23', '2', '1543C', '5928D')
INSERT INTO RENT VALUES('DG216156', 'AL1152', '2021-02-03', '2021-02-18', '2021-02-20', '0', '9724A', '4806A')
INSERT INTO RENT VALUES('IC699356', 'AV124', '2021-02-11', '2021-03-13', '2021-03-13', '1', '4806A', '1543C')
INSERT INTO RENT VALUES('HE722514', 'AV1218', '2021-02-13', '2021-03-15', '2021-03-18', '1', '5928D', '1543C')
INSERT INTO RENT VALUES('AC666869', 'AV1346', '2021-02-15', '2021-03-02', '2021-02-27', '0', '5889G', '5889G')
INSERT INTO RENT VALUES('HB965115', 'AV1217', '2021-02-17', '2021-04-03', '2021-04-01', '2', '5928D', '4199A')
INSERT INTO RENT VALUES('CA240857', 'AV113', '2021-02-19', '2021-04-05', '2021-03-29', '2', '4199A', '1543C')
INSERT INTO RENT VALUES('FB787898', 'AL1150', '2021-02-20', '2021-03-22', '2021-03-07', '1', '1543C', '4806A')
INSERT INTO RENT VALUES('HG721320', 'AL18236', '2021-02-22', '2021-03-09', '2021-03-07', '0', '9724A', '1543C')
INSERT INTO RENT VALUES('GH667043', 'AV1216', '2021-02-23', '2021-04-09', '2021-04-05', '2', '9724A', '4806A')
INSERT INTO RENT VALUES('BH607561', 'AL4505', '2021-02-23', '2021-04-09', '2021-04-16', '2', '9724A', '4199A')
INSERT INTO RENT VALUES('HE722514', 'AL5798', '2021-02-25', '2021-04-11', '2021-04-14', '2', '6259B', '6259B')
INSERT INTO RENT VALUES('HB965115', 'AL13853', '2021-03-01', '2021-03-16', '2021-03-16', '0', '4806A', '4199A')
INSERT INTO RENT VALUES('GI396298', 'AV1249', '2021-03-01', '2021-03-31', '2021-03-30', '1', '4199A', '2447F')
INSERT INTO RENT VALUES('HG721320', 'AL18237', '2021-03-01', '2021-04-15', '2021-04-18', '2', '1543C', '4806A')
INSERT INTO RENT VALUES('HF488022', 'AL138', '2021-03-09', '2021-04-09', '2021-04-09', '1', '1543C', '5452E')
INSERT INTO RENT VALUES('HG721320', 'AV695', '2021-03-10', '2021-03-25', '2021-03-25', '0', '5889G', '9724A')
INSERT INTO RENT VALUES('GG268562', 'AV381', '2021-03-10', '2021-03-25', '2021-03-21', '0', '5452E', '1543C')
INSERT INTO RENT VALUES('FB787898', 'AV586', '2021-03-10', '2021-04-09', '2021-03-25', '1', '2447F', '5928D')
INSERT INTO RENT VALUES('EA362778', 'AL5272', '2021-03-11', '2021-03-26', '2021-03-28', '0', '9724A', '5889G')
INSERT INTO RENT VALUES('FD482100', 'AL5981', '2021-03-15', '2021-04-29', '2021-04-30', '2', '1543C', '5452E')
INSERT INTO RENT VALUES('EH301014', 'AV585', '2021-03-16', '2021-04-30', '2021-04-20', '2', '9724A', '1543C')
INSERT INTO RENT VALUES('CH741977', 'AL1231', '2021-03-21', '2021-05-05', '2021-04-22', '2', '1543C', '6259B')
INSERT INTO RENT VALUES('GA151753', 'AV5212', '2021-04-01', '2021-04-16', '2021-04-15', '0', '6259B', '4199A')
INSERT INTO RENT VALUES('GH667043', 'AL14717', '2021-04-04', '2021-05-04', '2021-05-01', '1', '4199A', '4199A')
INSERT INTO RENT VALUES('FF107722', 'AV1323', '2021-04-05', '2021-05-05', '2021-04-19', '1', '4199A', '5928D')
INSERT INTO RENT VALUES('GA151753', 'AL1232', '2021-04-07', '2021-04-22', '2021-04-20', '0', '6259B', '9724A')
INSERT INTO RENT VALUES('FG156045', 'AV171', '2021-04-11', '2021-05-26', '2021-04-18', '2', '5889G', '5452E')
INSERT INTO RENT VALUES('HB573283', 'AL14718', '2021-04-13', '2021-05-28', NULL, '2', '4199A', NULL)
INSERT INTO RENT VALUES('IC699356', 'AL1633', '2021-04-22', '2021-05-22', NULL, '1', '6259B', NULL)
INSERT INTO RENT VALUES('AC666869', 'AL1232', '2021-04-22', '2021-05-22', NULL, '1', '1543C', NULL)
INSERT INTO RENT VALUES('HG721320', 'AL141', '2021-04-23', '2021-05-08', '2021-05-04', '0', '5452E', '4199A')
INSERT INTO RENT VALUES('HE722514', 'AL1231', '2021-04-24', '2021-05-24', NULL, '1', '4199A', NULL)
INSERT INTO RENT VALUES('HG282354', 'AV1251', '2021-04-24', '2021-05-09', '2021-05-08', '0', '4806A', '5452E')
INSERT INTO RENT VALUES('FF107722', 'AL14723', '2021-04-25', '2021-05-10', '2021-05-10', '0', '4199A', '2447F')
INSERT INTO RENT VALUES('FF880823', 'AV512', '2021-04-27', '2021-05-12', '2021-05-15', '0', '5889G', '5889G')
INSERT INTO RENT VALUES('ID935100', 'AV456', '2021-04-27', '2021-05-27', NULL, '1', '5928D', NULL)
INSERT INTO RENT VALUES('GF448228', 'AV1218', '2021-04-28', '2021-05-28', NULL, '1', '5928D', NULL)
INSERT INTO RENT VALUES('GH667043', 'AL4455', '2021-04-29', '2021-05-29', NULL, '1', '5928D', NULL)
INSERT INTO RENT VALUES('FF880823', 'AV169', '2021-04-29', '2021-05-29', NULL, '1', '4806A', NULL)
INSERT INTO RENT VALUES('CA163551', 'AV457', '2021-05-01', '2021-05-31', NULL, '1', '4199A', NULL)
INSERT INTO RENT VALUES('DE883346', 'AV115', '2021-05-03', '2021-06-02', NULL, '1', '9724A', NULL)
INSERT INTO RENT VALUES('GA151753', 'AV574', '2021-05-03', '2021-06-02', NULL, '1', '6259B', NULL)
INSERT INTO RENT VALUES('GI405583', 'AL1800', '2021-05-05', '2021-05-20', NULL, '0', '4806A', NULL)
INSERT INTO RENT VALUES('GB493876', 'AV280', '2021-05-05', '2021-05-20', '2021-05-20', '0', '5889G', '5889G')
INSERT INTO RENT VALUES('GF448228', 'AV1332', '2021-05-07', '2021-05-22', NULL, '0', '2447F', NULL)

INSERT INTO RESERVE VALUES('AV138', 'GI405583', '2021-01-03 00:00:00', '2021-01-05 00:00:00', 'Finished')
INSERT INTO RESERVE VALUES('AL8300', 'GF448228', '2021-01-25 00:00:00', '2021-01-27 00:00:00', 'Cancelled')
INSERT INTO RESERVE VALUES('AL11879', 'CA163551', '2021-01-28 00:00:00', '2021-01-30 00:00:00', 'Finished')
INSERT INTO RESERVE VALUES('AL1152', 'DG216156', '2021-02-02 00:00:00', '2021-02-04 00:00:00', 'Finished')
INSERT INTO RESERVE VALUES('AL14723', 'EA362778', '2021-02-05 00:00:00', '2021-02-07 00:00:00', 'Cancelled')
INSERT INTO RESERVE VALUES('AV1346', 'AC666869', '2021-02-13 00:00:00', '2021-02-15 00:00:00', 'Finished')
INSERT INTO RESERVE VALUES('AV135', 'GD917626', '2021-02-14 00:00:00', '2021-02-16 00:00:00', 'Cancelled')
INSERT INTO RESERVE VALUES('AL11943', 'CA240857', '2021-02-14 00:00:00', '2021-02-16 00:00:00', 'Cancelled')
INSERT INTO RESERVE VALUES('AV1249', 'GI396298', '2021-02-28 00:00:00', '2021-03-02 00:00:00', 'Finished')
INSERT INTO RESERVE VALUES('AV1250', 'FG156045', '2021-03-02 00:00:00', '2021-03-04 00:00:00', 'Cancelled')
INSERT INTO RESERVE VALUES('AL18236', 'BH540477', '2021-03-07 00:00:00', '2021-03-09 00:00:00', 'Cancelled')
INSERT INTO RESERVE VALUES('AV381', 'GG268562', '2021-03-09 00:00:00', '2021-03-11 00:00:00', 'Finished')
INSERT INTO RESERVE VALUES('AV280', 'DA800392', '2021-03-10 00:00:00', '2021-03-12 00:00:00', 'Cancelled')
INSERT INTO RESERVE VALUES('AV1218', 'HG282354', '2021-03-18 00:00:00', '2021-03-20 00:00:00', 'Cancelled')
INSERT INTO RESERVE VALUES('AV586', 'GD917626', '2021-03-25 00:00:00', '2021-03-27 00:00:00', 'Cancelled')
INSERT INTO RESERVE VALUES('AV5212', 'GA151753', '2021-04-01 00:00:00', '2021-04-03 00:00:00', 'Finished')
INSERT INTO RESERVE VALUES('AL5798', 'IC699356', '2021-04-14 00:00:00', '2021-04-16 00:00:00', 'Cancelled')
INSERT INTO RESERVE VALUES('AL1232', 'AC666869', '2021-04-20 00:00:00', '2021-04-22 00:00:00', 'Finished')
INSERT INTO RESERVE VALUES('AL8637', 'GB493876', '2021-05-01 00:00:00', '2021-05-03 00:00:00', 'Cancelled')
INSERT INTO RESERVE VALUES('AV209', 'BH607561', '2021-05-19 00:00:00', '2021-05-21 00:00:00', 'Reserved')
INSERT INTO RESERVE VALUES('AV695', 'IC699356', '2021-05-20 00:00:00', '2021-05-22 00:00:00', 'Reserved')
INSERT INTO RESERVE VALUES('AL5274', 'EH301014', '2021-05-20 00:00:00', '2021-05-22 00:00:00', 'Reserved')
INSERT INTO RESERVE VALUES('AL11786', 'AE456176', '2021-05-20 00:00:00', '2021-05-22 00:00:00', 'Reserved')
INSERT INTO RESERVE VALUES('AV1209', 'GD644041', '2021-05-20 00:00:00', '2021-05-22 00:00:00', 'Reserved')

INSERT INTO WAITLIST VALUES('GF448228', 'GA2256', '2021-01-20 00:00:00', 'Finished')
INSERT INTO WAITLIST VALUES('AE456176', 'IH8572', '2021-02-05 00:00:00', 'Cancelled')
INSERT INTO WAITLIST VALUES('HB965115', 'HB9973', '2021-02-07 00:00:00', 'Cancelled')
INSERT INTO WAITLIST VALUES('HF488022', 'GE9413', '2021-02-24 00:00:00', 'Cancelled')
INSERT INTO WAITLIST VALUES('HG282354', 'GE9413', '2021-02-24 00:00:00', 'Finished')
INSERT INTO WAITLIST VALUES('IC699356', 'IH7722', '2021-03-03 00:00:00', 'Finished')
INSERT INTO WAITLIST VALUES('BH540477', 'AG1102', '2021-03-04 00:00:00', 'Finished')
INSERT INTO WAITLIST VALUES('DB228004', 'EI3500', '2021-03-13 00:00:00', 'Cancelled')
INSERT INTO WAITLIST VALUES('GD917626', 'EI8430', '2021-03-20 00:00:00', 'Finished')
INSERT INTO WAITLIST VALUES('HE722514', 'GG9262', '2021-04-16 00:00:00', 'Cancelled')
INSERT INTO WAITLIST VALUES('AC666869', 'IC1759', '2021-04-17 00:00:00', 'Finished')
INSERT INTO WAITLIST VALUES('FF107722', 'IE1724', '2021-05-05 00:00:00', 'Waiting')
INSERT INTO WAITLIST VALUES('HG282354', 'GH5181', '2021-05-08 00:00:00', 'Waiting')
INSERT INTO WAITLIST VALUES('IC699356', 'GH5181', '2021-05-10 00:00:00', 'Waiting')
INSERT INTO WAITLIST VALUES('DE883346', 'FA1643', '2021-05-10 00:00:00', 'Waiting')
INSERT INTO WAITLIST VALUES('GA151753', 'IE1724', '2021-05-14 00:00:00', 'Cancelled')

INSERT INTO FINE VALUES('11', '4', 'FC163629', '2021-02-02 00:00:00', 'Overdue', NULL, 'Paid')
INSERT INTO FINE VALUES('10', '5', 'HG282354', '2021-02-03 00:00:00', 'Overdue', NULL, 'Paid')
INSERT INTO FINE VALUES('18', '4', 'ID935100', '2021-02-18 00:00:00', 'Overdue', NULL, 'Paid')
INSERT INTO FINE VALUES('24', '2', 'DG216156', '2021-02-20 00:00:00', 'Overdue', NULL, 'Paid')
INSERT INTO FINE VALUES('3', '11', 'FB787898', '2021-02-28 00:00:00', 'Overdue', NULL, 'Paid')
INSERT INTO FINE VALUES('19', '6', 'GI396298', '2021-03-08 00:00:00', 'Overdue', NULL, 'Paid')
INSERT INTO FINE VALUES('26', '3', 'HE722514', '2021-03-18 00:00:00', 'Overdue', NULL, 'Paid')
INSERT INTO FINE VALUES('23', '3', 'DB228004', '2021-03-20 00:00:00', 'Overdue', NULL, 'Paid')
INSERT INTO FINE VALUES('20', '5', 'HB965115', '2021-03-23 00:00:00', 'Overdue', NULL, 'Paid')
INSERT INTO FINE VALUES('42', '2', 'EA362778', '2021-03-28 00:00:00', 'Overdue', NULL, 'Paid')
INSERT INTO FINE VALUES('34', '3', 'HE722514', '2021-04-14 00:00:00', 'Overdue', NULL, 'Unpaid')
INSERT INTO FINE VALUES('33', '7', 'BH607561', '2021-04-16 00:00:00', 'Overdue', NULL, 'Paid')
INSERT INTO FINE VALUES('37', '3', 'HG721320', '2021-04-18 00:00:00', 'Overdue', NULL, 'Unpaid')
INSERT INTO FINE VALUES('43', '1', 'FD482100', '2021-04-29 00:00:00', 'Overdue', NULL, 'Unpaid')
INSERT INTO FINE VALUES('67', '24.9', 'GB493876', '2021-05-20 00:00:00', 'Lost copy', NULL, 'Unpaid')

INSERT INTO FINE_INV VALUES('1', '4', '2021-02-04 00:00:00', 'Finished')
INSERT INTO FINE_INV VALUES('2', '5', '2021-02-04 00:00:00', 'Finished')
INSERT INTO FINE_INV VALUES('3', '4', '2021-02-21 00:00:00', 'Finished')
INSERT INTO FINE_INV VALUES('4', '2', '2021-02-24 00:00:00', 'Finished')
INSERT INTO FINE_INV VALUES('5', '11', '2021-02-28 00:00:00', 'Finished')
INSERT INTO FINE_INV VALUES('6', '6', '2021-03-09 00:00:00', 'Finished')
INSERT INTO FINE_INV VALUES('7', '3', '2021-03-18 00:00:00', 'Finished')
INSERT INTO FINE_INV VALUES('8', '3', '2021-03-27 00:00:00', 'Finished')
INSERT INTO FINE_INV VALUES('9', '5', '2021-03-29 00:00:00', 'Finished')
INSERT INTO FINE_INV VALUES('10', '2', '2021-03-28 00:00:00', 'Finished')
INSERT INTO FINE_INV VALUES('12', '7', '2021-04-18 00:00:00', 'Finished')


UPDATE COPIES
SET RENT_STAT = 'Lost', BOOK_STAT = 'Lost'
WHERE COPIES_ID = 'AV280'

UPDATE COPIES
SET RENT_STAT = 'Reserved'
WHERE COPIES_ID IN (SELECT COPIES_ID FROM RESERVE WHERE RESERVE_STATUS = 'Reserved')

UPDATE COPIES
SET RENT_STAT = 'Rented'
WHERE COPIES_ID IN (SELECT COPIES_ID FROM RENT WHERE RETURN_DATE IS NULL)

UPDATE COPIES
SET RENT_STAT = 'Not for rent'
WHERE BOOK_ID IN ('CG2777', 'CC6197')
