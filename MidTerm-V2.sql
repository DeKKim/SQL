--1
select p.LastName, p.FirstName, c.Name, cn.Name from [dbo].[Person] p
join [dbo].[City] c on c.CityId=p.CityId
join [dbo].[Country] cn on cn.CountryId=c.CountryId
where p.HireDate is not null and cn.Name='canada'
order by p.LastName
--2
select c.Name, p.LastName, p.FirstName from [dbo].[Person] p
join [dbo].[City] c on c.CityId=p.CityId
where p.HireDate is not null and c.Name like '% %'
--3
select c.Title, d.Name from [dbo].[Course] c
join [dbo].[Department] d on d.DepartmentID=c.DepartmentID
where c.Credits=4 and d.Name!='engineering'
--4
select c.Name, cr.Title, p.LastName, p.FirstName from [dbo].[Person] p
join [dbo].[City] c on c.CityId=p.CityId
join [dbo].[StudentGrade] g on g.StudentID=p.PersonID
join [dbo].[Course] cr on cr.CourseID=g.CourseID
where p.EnrollmentDate is not null and c.Name in ('mexico city','acapulco')
and cr.Title in ('poetry','physics')
--5
select p.LastName, p.FirstName from [dbo].[Person] p
join [dbo].[StudentGrade] g on g.StudentID=p.PersonID
join [dbo].[Course] cr on cr.CourseID=g.CourseID
where p.EnrollmentDate is not null and cr.Title='macroeconomics' and g.Grade is null
--6
select distinct LOWER(c.Name) city from [dbo].[Person] p
join [dbo].[City] c on c.CityId=p.CityId
where p.HireDate is not null
--7
select d.Name, c.Title from [dbo].[Department] d
join [dbo].[Course] c on c.DepartmentID=d.DepartmentID
where d.Budget<=220000
--8
select p.FirstName, p.LastName, CEILING(g.Grade+(g.Grade*0.01)) NewGrade from [dbo].[Person] p
join [dbo].[StudentGrade] g on g.StudentID=p.PersonID
join [dbo].[Course] cr on cr.CourseID=g.CourseID
where p.EnrollmentDate is not null and cr.Credits=4 and g.Grade between 71 and 80
--9
select p.FirstName, p.LastName, DATEDIFF(MM,p.HireDate,SYSDATETIME()) months from [dbo].[Person] p
join [dbo].[Department] d on d.PersonId=p.PersonID
where p.HireDate is not null and d.Name in ('english','economics')
--10
select cr.Title, g.Grade, p.LastName, p.FirstName from [dbo].[Person] p
join [dbo].[StudentGrade] g on g.StudentID=p.PersonID
join [dbo].[Course] cr on cr.CourseID=g.CourseID
where p.EnrollmentDate is not null and g.Grade between 41 and 50