--1
select UPPER(d.Name), c.Title from [dbo].[Department] d
join [dbo].[Course] c on d.DepartmentID=c.DepartmentID
where d.Budget>240000
--2
select distinct p.LastName, p.FirstName,
case
when g.Grade is null then 0
end as grade
from [dbo].[Person] p
join [dbo].[StudentGrade] g on g.StudentID=p.PersonID
where p.EnrollmentDate is not null and g.Grade is null
--3
select p.FirstName, p.LastName, DATEDIFF(YY,p.HireDate,SYSDATETIME()) from [dbo].[Department] d
join [dbo].[Person] p  on p.PersonID=d.PersonId
where d.Name in ('engineering','mathematics') and p.HireDate is not null
--4
select p.LastName, p.FirstName from [dbo].[Person] p
join [dbo].[City] c on c.CityId=p.CityId
join [dbo].[Country] cn on cn.CountryId=c.CountryId
where p.HireDate is not null and cn.Name='USA'
order by p.LastName
--5
select c.Title, s.Grade, p.LastName, p.FirstName from [dbo].[Person] p
join [dbo].[StudentGrade] s on p.PersonID=s.StudentID
join [dbo].[Course] c on c.CourseID=s.CourseID
where p.EnrollmentDate is not null and s.Grade between 91 and 100
--6
select c.Title, d.Name from [dbo].[Course] c
join [dbo].[Department] d on d.DepartmentID=c.DepartmentID
where c.Credits=2
--7
select s.FirstName, s.LastName from [dbo].[Person] s
join [dbo].[StudentGrade] g on g.StudentID=s.PersonID
join [dbo].[Course] c on c.CourseID=g.CourseID
where s.EnrollmentDate is not null and c.Credits=3 and g.Grade between 81 and 90
--8
select p.LastName, p.FirstName from [dbo].[Person] p
join [dbo].[City] c on c.CityId=p.CityId
join [dbo].[StudentGrade] g on g.StudentID=p.PersonID
join [dbo].[Course] cr on cr.CourseID=g.CourseID
where p.EnrollmentDate is not null and c.Name in ('chicago', 'montreal', 'san jose') and cr.Title in ('calculus','physics')
--9
select distinct upper(c.Name) from [dbo].[Person] p
join [dbo].[City] c on c.CityId=p.CityId
where p.EnrollmentDate is not null
--10
select c.Name, p.LastName, p.FirstName from [dbo].[Person] p
join [dbo].[City] c on c.CityId=p.CityId
where c.Name like '% %'