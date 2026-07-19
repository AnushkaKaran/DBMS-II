		--- LAB 1 ---

USE CSE_4B_368;

-- Part A --

--1.	Retrieve all unique departments from the STUDENT table.
SELECT DISTINCT STUDEPARTMENT FROM STUDENT;

--2.	Insert a new student record into the STUDENT table.
--(9, 'Neha Singh', 'neha.singh@univ.edu', '9876543218', 'IT', '2003-09-20', 2021)
INSERT INTO STUDENT VALUES (9, 'Neha Singh', 'neha.singh@univ.edu', '9876543218', 'IT', '2003-09-20', 2021);

SELECT * FROM STUDENT;

INSERT INTO STUDENT VALUES (8, 'Pooja Rao', 'pooja@univ.edu', '9876543217', 'ECE', '2004-06-12', 2022,null);

--3.	Change the Email of student 'Raj Patel' to 'raj.p@univ.edu'. (STUDENT table)
UPDATE STUDENT
SET STUEMAIL = 'raj.p@univ.edu'
WHERE STUNAME = 'Raj Patel';

SELECT * FROM STUDENT;

--4.	Add a new column 'CGPA' with datatype DECIMAL(3,2) to the STUDENT table.
ALTER TABLE STUDENT
ADD CGPA DECIMAL(3,2);

SELECT * FROM STUDENT;

--5.	Retrieve all courses whose CourseName starts with 'Data'. (COURSE table)
SELECT *
FROM COURSE
WHERE COURSENAME LIKE 'Data%';

--6.	Retrieve all students whose Name contains 'Shah'. (STUDENT table)
SELECT *
FROM STUDENT
WHERE STUNAME LIKE '%Shah%';

--7.	Display all Faculty Names in UPPERCASE. (FACULTY table)
SELECT UPPER(FacultyName) AS FacultyName
FROM FACULTY;


--8.	Find all faculty who joined after 2015. (FACULTY table)
SELECT *
FROM FACULTY
WHERE FACULTYJOININGDATE > '2015';

--9.	Find the SQUARE ROOT of Credits for the course 'Database Management Systems'. (COURSE table)
SELECT SQRT(COURSECREDITS) AS CreditSquareRoot
FROM COURSE
WHERE CourseName = 'Database Management Systems';

SELECT * FROM FACULTY;

--10.	Find the Current Date using SQL Server in-built function.
SELECT GETDATE() AS CURRENTDATE;

--11.	Find the top 3 students who enrolled earliest (by EnrollmentYear). (STUDENT table)
SELECT TOP 3 STUNAME, STUENROLLMENTYEAR
FROM STUDENT
ORDER BY STUENROLLMENTYEAR ;

--12.	Find all enrollments that were made in the year 2022. (ENROLLMENT table)
SELECT *
FROM ENROLLMENT
WHERE YEAR(ENROLLMENTDATE) = 2022;

--13.	Find the number of courses offered by each department. (COURSE table)
SELECT COURSEDEPARTMENT, COUNT(*) AS TOTALCOURSES
FROM COURSE
GROUP BY COURSEDEPARTMENT;

--14.	Retrieve the CourseID which has more than 2 enrollments. (ENROLLMENT table)
SELECT COURSEID
FROM ENROLLMENT
GROUP BY COURSEID
HAVING COUNT(STUDENTID) > 2

--15.	Retrieve all the student name with their enrollment status. (STUDENT & ENROLLMENT table)
SELECT S.STUNAME, E.ENROLLMENTSTATUS
FROM STUDENT S
JOIN ENROLLMENT E
ON S.STUDENTID = E.STUDENTID;

--16.	Select all student names with their enrolled course names. (STUDENT, COURSE, ENROLLMENT table)
SELECT STUDENT.STUNAME, COURSE.COURSENAME
FROM ENROLLMENT 
JOIN STUDENT 
ON STUDENT.STUDENTID = ENROLLMENT.STUDENTID
JOIN COURSE
ON COURSE.COURSEID = ENROLLMENT.COURSEID;

--17.	Create a view called 'ActiveEnrollments' showing only active enrollments with student name and  course name. (STUDENT, COURSE, ENROLLMENT,  table)
 
--CREATE VIEW ActiveEnrollments
--AS
--SELECT STUDENT.STUNAME, COURSE.COURSENAME
--FROM ENROLLMENT 
--JOIN STUDENT 
--ON STUDENT.STUDENTID = ENROLLMENT.STUDENTID
--JOIN COURSE
--ON COURSE.COURSEID = ENROLLMENT.COURSEID
--WHERE ENROLLMENT.ENROLLMENTSTATUS = 'ACTIVE';

--SELECT * FROM ActiveEnrollments;

--18.	Retrieve the student’s name who is not enrol in any course using subquery. (STUDENT, ENROLLMENT TABLE)
SELECT STUNAME
FROM STUDENT
WHERE STUDENTID NOT IN 
	(SELECT StudentID 
	FROM ENROLLMENT
	);

--19.	Display course name having second highest credit. (COURSE table)
SELECT TOP 1 COURSENAME, COURSECREDITS
FROM COURSE
WHERE COURSECREDITS IN (
	SELECT DISTINCT TOP 2 COURSECREDITS
	FROM COURSE
	ORDER BY COURSECREDITS DESC
)
ORDER BY COURSECREDITS


--Part – B 


--20.	Retrieve all courses along with the total number of students enrolled. (COURSE, ENROLLMENT table)
SELECT COURSE.COURSENAME, COUNT(ENROLLMENT.ENROLLMENTID) AS ENROLLED_STU 
FROM COURSE
JOIN ENROLLMENT
ON COURSE.COURSEID = ENROLLMENT.COURSEID
GROUP BY COURSE.COURSENAME;

--21.	Retrieve the total number of enrollments for each status, showing only statuses that have more than 2 enrollments. (ENROLLMENT table)
SELECT ENROLLMENTSTATUS , COUNT(*) AS TOTAL_ENROLLS
FROM ENROLLMENT
GROUP BY ENROLLMENTSTATUS
HAVING COUNT(*)>2;

--22.	Retrieve all courses taught by 'Dr. Sheth' and order them by Credits. (FACULTY, COURSE, COURSE_ASSIGNMENT table)
SELECT C.CourseName, C.CourseCredits
FROM COURSE C
JOIN COURSE_ASSIGNMENT CA ON C.CourseID = CA.CourseID
JOIN FACULTY F ON CA.FacultyID = F.FacultyID
WHERE F.FacultyName = 'Dr. Sheth'
ORDER BY C.CourseCredits;


--Part – C 
--23.	List all students who are enrolled in more than 3 courses. (STUDENT, ENROLLMENT table)
SELECT STUDENT.STUNAME, COUNT(ENROLLMENT.COURSEID) AS TOTAL_COURSES
FROM STUDENT
JOIN ENROLLMENT
ON STUDENT.STUDENTID = ENROLLMENT.STUDENTID
GROUP BY STUDENT.STUNAME
HAVING COUNT(ENROLLMENT.COURSEID) > 3;

--24.	Find students who have enrolled in both 'CS101' and 'CS201' Using Sub Query. (STUDENT, ENROLLMENT table)
SELECT STUNAME 
FROM STUDENT
WHERE STUDENTID IN (
	SELECT STUDENTID
	FROM ENROLLMENT
	WHERE COURSEID = 'CS101'
)
AND STUDENTID IN (
	SELECT STUDENTID
	FROM ENROLLMENT
	WHERE COURSEID = 'CS201'
);

--25.	Retrieve department-wise count of faculty members along with their average years of experience (calculate experience from JoiningDate). (Faculty table)
SELECT FACULTYDEPARTMENT, COUNT(*) AS FACULTY_COUNT,
AVG(DATEDIFF(YEAR, FacultyJoiningDate, GETDATE())) AS AvgExperienceYears
FROM FACULTY
GROUP BY FacultyDepartment;