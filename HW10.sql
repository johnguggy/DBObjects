CREATE DATABASE HW10;
GO

USE HW10;
GO

SET NOCOUNT ON;

IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID('Employees'))
DROP TABLE Employees;
GO

CREATE TABLE Employees (
	ID INT IDENTITY(1,1) Primary Key, 
	BadgeNum INT NOT NULL UNIQUE,
	Title VARCHAR(20),
	DATEHired DateTime2 NULL
	);
GO

CREATE TRIGGER Employees_Insert
ON dbo.Employees
AFTER INSERT, UPDATE
AS
DECLARE @BadgeNum INT;
SELECT @BadgeNum = BadgeNum
FROM inserted

	IF (@BadgeNum >=0 and @BadgeNum <=300) BEGIN
		UPDATE Employees SET Title = 'Clerk', DATEHired = GetDate()
		WHERE @BadgeNum = BadgeNum;
		END
		ELSE
	IF (@BadgeNum >=300 and @BadgeNum <=600) BEGIN
		UPDATE Employees SET Title = 'Office Employee', DATEHired = GetDate()
		WHERE @BadgeNum = BadgeNum;
		END
		ELSE
	IF (@BadgeNum >=700 and @BadgeNum <=800) BEGIN
		UPDATE Employees SET Title = 'Manager', DATEHired = GetDate()
		WHERE @BadgeNum = BadgeNum;
		END
		ELSE
	IF (@BadgeNum >=900 and @BadgeNum <=1000) BEGIN
		UPDATE Employees SET Title = 'Director', DATEHired = GetDate()
		WHERE @BadgeNum = BadgeNum;
		END
GO

DECLARE @counter int = 1;
DECLARE @random int;
WHILE @counter <26 BEGIN
	SET @random = CAST(RAND() * 1000 AS INT);
	SELECT BadgeNum, Title, DATEHired from Employees WHERE BadgeNum = @random BEGIN
		INSERT INTO dbo.Employees (BadgeNum, Title, DATEHired)
		VALUES (@random, 'NULL', GETDATE());
		SET @counter += 1;
		END;
		BEGIN
			Continue;
		END;
END;
GO

DECLARE @BadgeNum INT;
DECLARE @Title VARCHAR(20);
DECLARE @DATEHired DateTime2
DECLARE Employees CURSOR FAST_FORWARD FOR
	SELECT BadgeNum, Title, DATEHired
	FROM Employees;

OPEN Employees
FETCH NEXT FROM Employees INTO @BadgeNum, @Title, @DATEHired;
WHILE @@FETCH_STATUS = 0 BEGIN
	PRINT 'BadgeNum= ' + CONVERT(VARCHAR(4), @BadgeNum) + 'Title=' + @Title + 'DATEHired=' + CONVERT(VARCHAR(30), @DATEHired)
	FETCH NEXT FROM Employees INTO @BadgeNum, @Title, @DATEHired;
END;

CLOSE Employees;
DEALLOCATE Employees;
GO

SELECT * FROM Employees

DROP Table Employees

DROP TRIGGER Employees_Insert