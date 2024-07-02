--pets2021
--15
select o.Surname, o.Name, p.Name from [dbo].[Owners] o
join [dbo].[Pets] p on o.OwnerID=p.OwnerID
join [dbo].[PetTypes] pt on p.PetTypeId=pt.PetTypeId
where o.Surname like '%z' and pt.Name='dog'

--16
select p.Name, p.BirthYear, prh.ProcedureDate from [dbo].[Pets] p
join [dbo].[ProceduresHistory] prh on p.PetId=prh.PetID
join [dbo].[Procedures] pr on prh.ProcedureId=pr.ProcedureId
join [dbo].[ProcedureTypes] prt on pr.ProcedureTypeId=prt.ProcedureTypeId
where prt.Name = 'hospitalization' and YEAR(prh.ProcedureDate) in (p.BirthYear,p.BirthYear+1)

--17
select distinct o.Surname, o.Name, p.Name from [dbo].[Owners] o
join [dbo].[Pets] p on o.OwnerID=p.OwnerID
join [dbo].[PetTypes] pt on p.PetTypeId=pt.PetTypeId
join [dbo].[ProceduresHistory] prh on p.PetId=prh.PetID
where o.City = 'detroit' and pt.Name='dog' and YEAR(prh.ProcedureDate)=2016 and MONTH(prh.ProcedureDate) in (6,7,8)

--18
select p.Description, p.Price from [dbo].[Procedures] p
where p.Price > (select AVG(p.Price) from [dbo].[Procedures] p)

--19
select COUNT(*) from [dbo].[Owners] o
where o.City in ('flint','pontiac') and o.OwnerID in (select p.OwnerID from [dbo].[Pets] p
where p.PetTypeId = (select pt.PetTypeId from [dbo].[PetTypes] pt where pt.Name='cat'))

--20
select COUNT(*) from [dbo].[Pets] p
where p.PetId in (select prh.PetID from [dbo].[ProceduresHistory] prh
where prh.ProcedureId in (select pr.ProcedureId from [dbo].[Procedures] pr
where pr.ProcedureTypeId = (select prt.ProcedureTypeId from [dbo].[ProcedureTypes] prt
where prt.Name = 'grooming')))

--21
select pt.Name, COUNT(*) raodenoba from [dbo].[Pets] p
join [dbo].[PetTypes] pt on p.PetTypeId=pt.PetTypeId
join [dbo].[ProceduresHistory] prh on p.PetId=prh.PetID
group by pt.Name

--22
select prt.Name, MIN(pr.Price) from [dbo].[ProcedureTypes] prt
join [dbo].[Procedures] pr on prt.ProcedureTypeId=pr.ProcedureTypeId
where prt.Name != 'vaccinations'
group by prt.Name
order by 2

--23
select o.Name, o.Surname, COUNT(*) from [dbo].[Owners] o
join [dbo].[Pets] p on o.OwnerID=p.OwnerID
group by o.Name, o.Surname
having COUNT(*)=3

--24
select DATENAME(mm,prh.ProcedureDate), count(*) from [dbo].[ProceduresHistory] prh
where YEAR(prh.ProcedureDate)=2016 and MONTH(prh.ProcedureDate) in (3,4,5)
group by DATENAME(mm,prh.ProcedureDate)
order by COUNT(*) desc

--25
insert into [dbo].[Pets] (Name, PetTypeId, Gender, BirthYear, OwnerID) values
('Fogu', 2, 'female', year(GETDATE()), (select o.OwnerID from [dbo].[Owners] o
where o.Name = 'lena' and o.Surname='Haliburton'))

--26
update [dbo].[Pets] set BirthYear=2017
where OwnerID = (select o.OwnerID from [dbo].[Owners] o
where o.Name = 'richard' and o.Surname='duke')

--27
update [dbo].[Procedures] set Price *= 0.93
where Price between 400 and 480 and ProcedureTypeId = (select prt.ProcedureTypeId from [dbo].[ProcedureTypes] prt
where prt.Name = 'GENERAL SURGERIES')

--28
delete [dbo].[ProceduresHistory]
where YEAR(ProcedureDate) = 2016 and MONTH(ProcedureDate)=11 and PetID = (select p.PetId from [dbo].[Pets] p
where p.Name = 'enyo')

--29
create procedure dbo.procedure01
@zcode int,
@ptype nvarchar(50)
as
if (select COUNT(*) from [dbo].[Pets] p
join [dbo].[Owners] o on p.OwnerID=o.OwnerID
join [dbo].[ProceduresHistory] prh on prh.PetID=p.PetId
join [dbo].[Procedures] pr on prh.ProcedureId=pr.ProcedureId
join [dbo].[ProcedureTypes] prt on pr.ProcedureTypeId=prt.ProcedureTypeId
where o.ZipCode = @zcode and LEFT(prt.Name,len(@ptype)) = @ptype) > 0
begin
select p.Name, o.City, o.ZipCode, prt.Name, prh.ProcedureDate, pr.Price from [dbo].[Pets] p
join [dbo].[Owners] o on p.OwnerID=o.OwnerID
join [dbo].[ProceduresHistory] prh on prh.PetID=p.PetId
join [dbo].[Procedures] pr on prh.ProcedureId=pr.ProcedureId
join [dbo].[ProcedureTypes] prt on pr.ProcedureTypeId=prt.ProcedureTypeId
where o.ZipCode = @zcode and LEFT(prt.Name,len(@ptype)) = @ptype
end
else
begin
print 'Record not found'
end

exec dbo.procedure01 48034,'off'
exec dbo.procedure01 48034,'offf'

--30
create procedure dbo.procedure02
@pdate date
as
if (select SUM(pr.Price) from [dbo].[ProceduresHistory] prh
join [dbo].[Procedures] pr on prh.ProcedureId=pr.ProcedureId
where prh.ProcedureDate = @pdate) is not null
begin
select SUM(pr.Price) from [dbo].[ProceduresHistory] prh
join [dbo].[Procedures] pr on prh.ProcedureId=pr.ProcedureId
where prh.ProcedureDate = @pdate
end
else
begin
print 'Procedure not found'
end

exec dbo.procedure02 '2016-01-16'
exec dbo.procedure02 '2030-01-16'