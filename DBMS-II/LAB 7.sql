--Trigger (Instead of trigger)
--Table : Log(LogMessage varchar(100), logDate Datetime)

select * from log
select * from student
--Part – A
--1. Create trigger for blocking student deletion.
create or alter trigger tr_blockingstudent
on student
instead of delete 
as begin
	print 'student deleted'
end
drop trigger tr_blockingstudent
delete from student
where StudentID=100000000

--2. Create trigger for making course read-only.
create or alter trigger tr_readonly
on course
instead of insert,update,delete 
as begin
	print 'this course is read only'
end

insert into course
values(1,'name',4,'cse',4)
drop trigger tr_readonly

--3. Create trigger for preventing faculty removal.
create or alter trigger tr_preventingfacultyremoval
on faculty
instead of delete 
as begin
	print 'cant remove faculty'
	insert into log values()
end

delete from faculty
where facultyid=101
drop trigger tr_preventingfacultyremoval


--4. Create instead of trigger to log all operations on COURSE (INSERT/UPDATE/DELETE) into Log table.
create or alter trigger tr_logalloperations
on course
instead of insert,update,delete 
as begin
	if exists (select * from inserted) and exists (select * from deleted)
		insert into log values('update',getdate())
	else if exists (select * from inserted)
		insert into log values('insert',getdate())
	else
		insert into log values('delete',getdate())
		
end

select * from course
select * from log
delete from course
where courseid='temp02'
drop trigger tr_logalloperations
--(Example: INSERT/UPDATE/DELETE operations are blocked for you in course table)
--5. Create trigger to Block student to update their enrollment year and print message ‘students are not
--allowed to update their enrollment year’
create or alter trigger tr_blocktoupdateenroll
on student
instead of update 
as begin
	if update (StuEnrollmentYear)
	begin
		print 'you are not allowed to change enrollmentyear'
	end
		
end

select * from student
update student
set StuEnrollmentYear='2022'
where StudentID=1
drop trigger tr_blocktoupdateenroll
--6. Create trigger for student age validation (Min 18).
create or alter trigger tr_agevalidation
on student
instead of insert,update 
as begin
	if exists (select * from inserted where year(getdate())-year(StuDateOfBirth)>=18)
	begin
		print 'approved'
	end
		
end

select * from student
update student
set StuDateOfBirth='2022-09-02'
where StudentID=1
update student
set StuDepartment='CSE'
where StudentID=1
drop trigger tr_agevalidation

--Part – B
--7. Create trigger for unique faculty’s email check.
create or alter trigger tr_uniquefacultysemailcheck
on faculty
instead of insert,update 
as begin
	if exists (select * from faculty where FacultyEmail in (select facultyemail from inserted))
	begin
		print 'not unique'
	end
	else
		print 'unique'
		
end

select * from faculty
update faculty
set FacultyEmail='Sheth@univ.edu'
where FacultyID=101
update faculty
set FacultyEmail='Sheth1@univ.edu'
where FacultyID=101
drop trigger tr_uniquefacultysemailcheck
--8. Create trigger for preventing duplicate enrollment.
create or alter trigger tr_uniquefacultyenrollcheck
on STUDENT
instead of insert,update 
as begin
	if exists (select * from STUDENT where StuEnrollmentYear in (select StuEnrollmentYear from inserted))
	begin
		print 'not unique'
	end
	else
		print 'unique'
		
end

select * from STUDENT
update STUDENT
set StuEnrollmentYear='2022'
where StudentID=1
update STUDENT
set StuEnrollmentYear='1998'
where StudentID=101
drop trigger tr_uniquefacultyenrollcheck
--Part - C
--9. Create trigger to Allow enrolment in month from Jan to August, otherwise print message enrolment
--closed.
create or alter trigger tr_allowenrollnum
on student
instead of insert
as begin
	if month(getdate()) not between 1 and 8
		begin
			print 'enrollment closed'
		end
end
drop trigger tr_allowenrollnum
--10. Create trigger to Allow only grade change in enrollment (block other updates)
create or alter trigger tr_gradechange
on student
instead of insert
as begin
	if update(StudentID) or update(StuName) or update(StuEmail) or update(StuPhone) or update(StuDepartment) or update(StuDateOfBirth)
		begin
			print 'cant change any field except enrollment'
		end
end

drop trigger tr_gradechange