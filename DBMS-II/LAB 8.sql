-- LAB 8--

--Part – A 


--1. Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error. 
CREATE PROCEDURE PR_DIVIDENUMBERS
    @NUM1 INT,
    @NUM2 INT
AS
BEGIN
    BEGIN TRY
        DECLARE @RESULT INT
        SET @RESULT = @NUM1 / @NUM2
        PRINT 'RESULT = ' + CAST(@RESULT AS VARCHAR)
    END TRY

    BEGIN CATCH
        PRINT 'Error occurs that is - Divide by zero error'
        PRINT ERROR_MESSAGE()
    END CATCH
END

EXEC PR_DIVIDENUMBERS 10,0

--2. Try to convert string to integer and handle the error using try…catch block. 
GO
CREATE OR ALTER PROCEDURE PR_CONVERTSTRINGTOINT
    @VALUE VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        DECLARE @NUM INT
        SET @NUM = CAST(@VALUE AS INT)

        PRINT 'CONVERTED NUMBER = ' + CAST(@NUM AS VARCHAR)
    END TRY

    BEGIN CATCH
        PRINT 'ERROR WHILE CONVERTING STRING TO INTEGER'
        PRINT ERROR_MESSAGE()
    END CATCH
END

EXEC PR_CONVERTSTRINGTOINT 'ABC'

--3. Create a procedure that prints the sum of two numbers: take both numbers as integer & handle 
--exception with all error functions if any one enters string value in numbers otherwise print result.
GO
CREATE OR ALTER PROCEDURE PR_SUMTWONUMBERS
    @NUM1 VARCHAR(20),
    @NUM2 VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        DECLARE @N1 INT
        DECLARE @N2 INT

        SET @N1 = CAST(@NUM1 AS INT)
        SET @N2 = CAST(@NUM2 AS INT)

        PRINT 'SUM = ' + CAST(@N1 + @N2 AS VARCHAR)
    END TRY

    BEGIN CATCH
        PRINT 'ERROR OCCURRED'
        PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS VARCHAR)
        PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE()
        PRINT 'SEVERITY: ' + CAST(ERROR_SEVERITY() AS VARCHAR)
        PRINT 'STATE: ' + CAST(ERROR_STATE() AS VARCHAR)
    END CATCH
END

EXEC PR_SUMTWONUMBERS 10,'GHADIYA';

--4. Handle a Primary Key Violation while inserting data into student table and print the error details such
--as the error message, error number, severity, and state. 

SELECT * FROM STUDENT
GO
CREATE OR ALTER PROCEDURE PR_INSERTSTUDENT
    @STUDENTID INT,
    @STUNAME VARCHAR(50),
    @STUEMAIL VARCHAR(50),
    @STUPHONE VARCHAR(50),
    @STUDEPARTMENT VARCHAR(50),
    @STUDATEOFBIRTH DATE,
    @STUENROLLMENTYEAR INT,
    @CGPA DECIMAL(4,2)

AS
BEGIN
    BEGIN TRY
        INSERT INTO STUDENT VALUES(@STUDENTID,@STUNAME,@STUEMAIL,@STUPHONE,@STUDEPARTMENT,@STUDATEOFBIRTH,@STUENROLLMENTYEAR,@CGPA)
        PRINT 'STUDENT INSERTED SUCCESSFULLY'
    END TRY

    BEGIN CATCH
        PRINT 'PRIMARY KEY VIOLATION OCCURRED'
        PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS VARCHAR)
        PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE()
        PRINT 'SEVERITY: ' + CAST(ERROR_SEVERITY() AS VARCHAR)
        PRINT 'STATE: ' + CAST(ERROR_STATE() AS VARCHAR)
    END CATCH
END

EXEC PR_INSERTSTUDENT 1,'GHADIYA','GHADIYA@2023','9986579','CSE','2006-02-12',2024,5.2;


--5. Throw custom exception using stored procedure which accepts StudentID as input & that throws
--Error like no StudentID is available in database.
GO
CREATE OR ALTER PROCEDURE PR_CHECKSTUDENT
    @STUDENTID INT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM STUDENT WHERE STUDENTID=@STUDENTID)
    BEGIN
        THROW 50001, 'STUDENTID NOT AVAILABLE IN DATABASE', 1
    END
    ELSE
    BEGIN
        PRINT 'STUDENT EXISTS'
    END
END

EXEC PR_CHECKSTUDENT 10

--6. Handle a Foreign Key Violation while inserting data into Enrollment table and print appropriate error
--message
SELECT * FROM ENROLLMENT;

GO
CREATE OR ALTER PROCEDURE PR_INSERTENROLL
    @ENROLLMENTID INT,
    @STUDENTID INT,
    @COURSEID VARCHAR(10),
    @ENROLLMENTDATE DATE,
    @GRADE VARCHAR(50),
    @ENROLLSTATUS VARCHAR(20)
AS
BEGIN
BEGIN TRY
    INSERT INTO ENROLLMENT VALUES(@ENROLLMENTID,@STUDENTID,@COURSEID,@ENROLLMENTDATE,@GRADE,@ENROLLSTATUS)  
END TRY

BEGIN CATCH
    PRINT 'FOREIGN KEY VIOLATION'

    PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE()
END CATCH
END