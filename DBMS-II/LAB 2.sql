USE CSE_4B_368;

--Part – A 

--1.	INSERT Procedures: Create stored procedures to insert records into STUDENT tables (SP_INSERT_STUDENT)
--StuID	Name	Email	Phone	Department	DOB	EnrollmentYear
--10	Harsh Parmar	harsh@univ.edu	9876543218	CSE	2005-09-18	2023
--20	Om Patel	om@univ.edu	9876543211	IT	2002-08-22	2022
CREATE OR ALTER PROCEDURE PR_INSERT_STUDENT
@STUID INT,
@NAME VARCHAR(20),
@EMAIL VARCHAR(20),
@PHONE VARCHAR(15),
@DEPARTMENT VARCHAR(6),
@DOB DATE,
@ENROLLMENTYEAR INT,
@CGPA DECIMAL(4,2)
AS
BEGIN
	INSERT INTO STUDENT VALUES (@STUID, @NAME,@EMAIL,@PHONE,@DEPARTMENT,@DOB,@ENROLLMENTYEAR,@CGPA);
END

EXEC PR_INSERT_STUDENT 10,'HARSH PARMAR','harsh@univ.edu','9876543218','CSE','2005-09-18',2023,NULL;
EXEC PR_INSERT_STUDENT 20,'OM PATEL','om@univ.edu','9876543211','IT','2002-08-22',2022,NULL;

SELECT * FROM STUDENT

--2.	INSERT Procedures: Create stored procedures to insert records into COURSE tables 
--(SP_INSERT_COURSE)
--CourseID	CourseName	Credits	Dept	Semester
--CS330	Computer Networks	4	CSE	5
--EC120	Electronic Circuits	3	ECE	2
CREATE OR ALTER PROCEDURE PR_INSERT_COURSE
@COURSEID VARCHAR(10),
@COURSENAME VARCHAR(20),
@CREDITS INT,
@DEPT VARCHAR(10),
@SEMESTER INT
AS
BEGIN
	INSERT INTO COURSE VALUES (@COURSEID, @COURSENAME,@CREDITS,@DEPT,@SEMESTER);
END

EXEC PR_INSERT_COURSE CS330,'COMPUTER NETWORKS',4,'CSE',5;
EXEC PR_INSERT_COURSE EC120,'ELECTRONIC CIRCUITS',3,'ECE',2;

SELECT * FROM COURSE;

--3.	UPDATE Procedures: Create stored procedure SP_UPDATE_STUDENT to update Email and Phone in STUDENT table. (Update using studentID)
CREATE OR ALTER PROCEDURE PR_UPDATE_STUDENT
@EMAIL VARCHAR(20),
@PHONE VARCHAR(15),
@ID INT
AS
BEGIN
	UPDATE STUDENT
	SET STUEMAIL = @EMAIL , STUPHONE = @PHONE
	WHERE StudentID = @ID;
END

--4.	DELETE Procedures: Create stored procedure SP_DELETE_STUDENT to delete records from STUDENT where Student Name is Om Patel.
CREATE OR ALTER PROCEDURE PR_DELETE_STUDENT
@NAME VARCHAR(20)
AS
BEGIN
	DELETE FROM STUDENT
	WHERE StuName = @NAME;
END

EXEC PR_DELETE_STUDENT 'OM PATEL'

SELECT * FROM STUDENT;

--5.	SELECT BY PRIMARY KEY: Create stored procedures to select records by primary key (SP_SELECT_STUDENT_BY_ID) from Student table.
CREATE OR ALTER PROCEDURE PR_SELECT_STUDENT_BY_ID
@STUID INT
AS 
BEGIN
	SELECT * 
	FROM STUDENT
	WHERE StudentID = @STUID;
END

EXEC PR_SELECT_STUDENT_BY_ID 2

--6.Create a stored procedure that shows details of the first 5 students ordered by EnrollmentYear.
CREATE OR ALTER PROCEDURE PR_SELECT_TOP_STUDENT
AS 
BEGIN
	SELECT TOP 5 *
	FROM STUDENT
	ORDER BY StuEnrollmentYear ASC;
END

EXEC PR_SELECT_TOP_STUDENT;

--Part – B 

--7.Create a stored procedure which displays faculty designation-wise count.
 CREATE OR ALTER PROCEDURE PR_FACULTYCOUNT
 AS
 BEGIN
	SELECT FacultyDesignation,COUNT(FACULTYNAME)
	FROM FACULTY
	GROUP BY FacultyDesignation;
END

EXEC PR_FACULTYCOUNT;

--8.Create a stored procedure that takes department name as input and returns all students in that department.
CREATE OR ALTER PROCEDURE PR_DEPTBY_STUDENTS
@DEPTNAME VARCHAR(10)
AS
BEGIN
	SELECT *
	FROM STUDENT
	WHERE StuDepartment = @DEPTNAME;
END

EXEC PR_DEPTBY_STUDENTS 'MECH';

--Part – C 
--9.Create a stored procedure which displays department-wise maximum, minimum, and average credits of courses.
CREATE OR ALTER PROCEDURE CREDITS_OF_COURSE
AS
BEGIN
	SELECT CourseDepartment,MAX(CourseCredits) AS MAX_CREDITS,
	MIN(CourseCredits) AS MIN_CREDITS, AVG(CourseCredits) AS AVG_CREDITS
	FROM COURSE
	GROUP BY CourseDepartment;
END

EXEC CREDITS_OF_COURSE;

--10.Create a stored procedure that accepts StudentID as parameter and returns all courses the student is enrolled in with their grades.
CREATE OR ALTER PROCEDURE PR_STUDENT_GRADES
@STUID INT
AS
BEGIN
	SELECT COURSE.CourseName, ENROLLMENT.StudentID,ENROLLMENT.Grade
	FROM COURSE
	JOIN ENROLLMENT
	ON COURSE.CourseID = ENROLLMENT.CourseID
	WHERE ENROLLMENT.StudentID = @STUID;
END

EXEC PR_STUDENT_GRADES 1;