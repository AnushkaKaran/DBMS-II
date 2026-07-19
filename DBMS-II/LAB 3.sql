 USE CSE_4B_368;

--Part – A 
--1.Create a stored procedure that accepts a date and returns all faculty members who joined on that date.
CREATE OR ALTER PROCEDURE PR_FACULTY_JOININGDATE
@DATE DATE
AS
BEGIN
	SELECT *
	FROM FACULTY
	WHERE FacultyJoiningDate = @DATE;
END

EXEC PR_FACULTY_JOININGDATE '2010-07-15';

--2.Create a stored procedure for ENROLLMENT table where user enters either StudentID and returns EnrollmentID, EnrollmentDate, Grade, and Status.
CREATE OR ALTER PROCEDURE PR_ENROLLMENTDETAILS
@STUID INT 
AS 
BEGIN
	SELECT ENROLLMENTID, StudentID,EnrollmentDate,Grade,EnrollmentStatus
	FROM ENROLLMENT
	WHERE StudentID = @STUID
END

EXEC PR_ENROLLMENTDETAILS 1;

--3.Create a stored procedure that accepts two integers (min and max credits) and returns all courses whose credits fall between these values.
CREATE OR ALTER PROC PR_MIN_MAX_CREDTITS
@MIN INT,
@MAX INT
AS
BEGIN
	SELECT COURSENAME 
	FROM COURSE
	WHERE CourseCredits BETWEEN @MIN AND @MAX
END

EXEC PR_MIN_MAX_CREDTITS 2,3;

--4.Create a stored procedure that accepts Course Name and returns the list of students enrolled in that course.
CREATE OR ALTER PROC PR_ENROLLSTU_BYCOURSE
@CNAME VARCHAR(20)
AS 
BEGIN
	SELECT COURSE.COURSENAME, COUNT(ENROLLMENT.StudentID)
	FROM ENROLLMENT
	JOIN COURSE
	ON ENROLLMENT.CourseID = COURSE.CourseID
	WHERE COURSE.CourseName = @CNAME
	GROUP BY COURSE.CourseName
END

EXEC PR_ENROLLSTU_BYCOURSE 'DATA STRUCTURES'

--5.Create a stored procedure that accepts Faculty Name and returns all course assignments.
CREATE OR ALTER PROC PR_COURSENAME
@FNAME VARCHAR(20)
AS
BEGIN
	SELECT FACULTY.FacultyName,COUNT(COURSE_ASSIGNMENT.COURSEID)
	FROM COURSE_ASSIGNMENT
	JOIN FACULTY
	ON FACULTY.FacultyID= COURSE_ASSIGNMENT.FacultyID
	JOIN COURSE
	ON COURSE.COURSEID= COURSE_ASSIGNMENT.COURSEID
	WHERE FACULTY.FacultyName = @FNAME
	GROUP BY FACULTY.FacultyName
END

EXEC PR_COURSENAME 'DR. SHETH';

--6.Create a stored procedure that accepts Semester number and Year, and returns all course assignments with faculty and classroom details.
CREATE OR ALTER PROC PR_FACULTY_CLASSROOM_DETAILS
@SEMNUM INT,
@YEAR INT
AS
BEGIN
	SELECT FACULTY.FacultyName,COURSE_ASSIGNMENT.CLASSROOM,COUNT(COURSE_ASSIGNMENT.COURSEID)
	FROM COURSE_ASSIGNMENT
	JOIN FACULTY
	ON FACULTY.FacultyID= COURSE_ASSIGNMENT.FacultyID
	JOIN COURSE
	ON COURSE.COURSEID= COURSE_ASSIGNMENT.COURSEID
	WHERE COURSE_ASSIGNMENT.Semester = @SEMNUM AND COURSE_ASSIGNMENT.YEAR = @YEAR
	GROUP BY FACULTY.FacultyName, COURSE_ASSIGNMENT.CLASSROOM
END

EXEC PR_FACULTY_CLASSROOM_DETAILS 1,2024;

--Part – B 

--7.	Create a stored procedure that accepts the first letter of Status ('A', 'C', 'D') and returns enrollment details.
CREATE OR ALTER PROC PR_ENROLLDETAILS_BYLETTER
@STATUS VARCHAR(15)
AS
BEGIN
	SELECT E.STUDENTID, E.COURSEID, E.GRADE, E.EnrollmentDate 
	FROM ENROLLMENT E
	WHERE E.ENROLLMENTSTATUS LIKE @STATUS+'%'
END

EXEC PR_ENROLLDETAILS_BYLETTER 'A';

--8.	Create a stored procedure that accepts either Student Name OR Department Name and returns student data accordingly.
CREATE OR ALTER PROC PR_STUDENT_DETAILS
@STUNAME VARCHAR(20)=NULL ,
@DEPTNAME VARCHAR(10)=NULL
AS
BEGIN
	SELECT *
	FROM STUDENT
	WHERE STUNAME = @STUNAME OR StuDepartment = @DEPTNAME;
END

EXEC PR_STUDENT_DETAILS ' ','CSE';

--9.	Create a stored procedure that accepts CourseID and returns all students enrolled grouped by enrollment status with counts.
CREATE OR ALTER PROC PR_ENROLLED_STUDENTS
@CID VARCHAR(10),
@TOTALSTUDENTS INT OUTPUT
AS 
BEGIN
	SELECT @TOTALSTUDENTS=COUNT(StudentID)
	FROM ENROLLMENT
	WHERE COURSEID = @CID
	GROUP BY EnrollmentStatus;
END

DECLARE @COUNT INT
EXEC PR_ENROLLED_STUDENTS 'CS101', @TOTALSTUDENTS=@COUNT OUT
SELECT @COUNT;

--Part – C 

--10.	Create a stored procedure that accepts a year as input and returns all courses assigned to faculty in that year with classroom details.
CREATE OR ALTER PROC PR_FACULTY_CLASSROOM_DETAILS
@YEAR INT
AS
BEGIN
	SELECT FACULTY.FacultyName,COURSE_ASSIGNMENT.CLASSROOM,COUNT(COURSE_ASSIGNMENT.COURSEID)
	FROM COURSE_ASSIGNMENT
	JOIN FACULTY
	ON FACULTY.FacultyID= COURSE_ASSIGNMENT.FacultyID
	JOIN COURSE
	ON COURSE.COURSEID= COURSE_ASSIGNMENT.COURSEID
	WHERE COURSE_ASSIGNMENT.YEAR = @YEAR
	GROUP BY FACULTY.FacultyName, COURSE_ASSIGNMENT.CLASSROOM
END

EXEC PR_FACULTY_CLASSROOM_DETAILS 2024;

--11.	Create a stored procedure that accepts From Date and To Date and returns all enrollments within that range with student and course details.
CREATE OR ALTER PROC PR_DETAILS
@FROMDATE DATE,
@TODATE DATE
AS
BEGIN
	SELECT S.STUNAME, S.STUDEPARTMENT,C.COURSENAME, C.COURSECREDITS
	FROM ENROLLMENT E
	JOIN STUDENT S 
	ON E.STUDENTID = S.StudentID
	JOIN COURSE C
	ON E.COURSEID = C.COURSEID
	WHERE E.EnrollmentDate BETWEEN @FROMDATE AND @TODATE
END

EXEC PR_DETAILS '2020-07-01', '2021-07-01';

--12.	Create a stored procedure that accepts FacultyID and calculates their total teaching load (sum of credits of all courses assigned).
CREATE OR ALTER PROC PR_FACULTY_TEACHINGLOAD
@FID INT
AS
BEGIN
	SELECT F.FacultyID, F.FACULTYNAME,SUM(C.COURSECREDITS)
	FROM COURSE_ASSIGNMENT CA
	JOIN COURSE C
	ON CA.COURSEID = C.COURSEID
	JOIN FACULTY F
	ON CA.FACULTYID = F.FACULTYID
	WHERE F.FacultyID = @FID
	GROUP BY F.FacultyID, F.FACULTYNAME;
END

EXEC PR_FACULTY_TEACHINGLOAD 101;