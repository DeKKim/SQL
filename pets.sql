select * from [dbo].[Owners]
select * from [dbo].[PetTypes]
select * from [dbo].[Pets]
select * from [dbo].[Procedures]
select * from [dbo].[ProceduresHistory]
select * from [dbo].[ProcedureTypes]

-------------------------------------------ცხრილების გაერთიანება join ოპერატორის საშუალებით--------------------------------------


--17. გამოიტანეთ იმ პირების გვარი და სახელი, რომელთა გვარი მთავრდება s სიმბოლოზე და ჰყავთ კატა. მესამე
--სვეტში გამოიტანეთ კატის სახელი;
select o.Surname , o.Name as OwnerName ,  p.Name as Petname from dbo.Owners o 
join dbo.Pets p on p.OwnerID=o.OwnerID
join dbo.PetTypes t on t.PetTypeId=p.PetTypeId
where t.Name = 'cat' and  right(o.Surname,1)='s' 


--18. გამოიტანეთ ცხოველების სახელები, რომლებსაც ჩაუტარდათ ორთოპედიული პროცედურა (ORTHOPEDIC)
--საკუთარ დაბადების წელს. მეორე და მესამე სვეტში გამოიტანეთ დაბადების წელი და პროცედურის
--ჩატარების თარიღი;

select p.Name , p.BirthYear , h.ProcedureDate from dbo.Pets p
join dbo.ProceduresHistory h on h.PetID=p.PetId
join dbo.Procedures pr on pr.ProcedureId=h.ProcedureId
join dbo.ProcedureTypes t on t.ProcedureTypeId=pr.ProcedureTypeId
where t.name= 'ORTHOPEDIC' and p.BirthYear = year(h.ProcedureDate)

--19. გამოიტანეთ ქალაქ Dutton-ში მცხოვრები პირების გვარი და სახელი, რომლებმაც საკუთარ თუთიყუშს
--ჩაუტარეს სამედიცინო პროცედურა 2016 წლის ოქტომბრის მეორე ნახევარში. მესამე სვეტში გამოიტანეთ
--თუთიყუშის სახელი. თუ თუთიყუშის ამ პერიოდში პროცედურა ჩაუტარდა რამდენიმეჯერ, გამოტანისას მისი
--და მფლობელის მონაცემები გამოიტანეთ მხოლოდ ერთხელ;

select distinct owners.Surname , owners.Name , pets.Name  from dbo.Owners owners 
join dbo.Pets pets on pets.OwnerID=owners.OwnerID
join dbo.PetTypes types on types.PetTypeId=pets.PetTypeId
join dbo.ProceduresHistory history on history.PetID=pets.PetId 
where types.Name='Parrot' and owners.City='Dutton' and 
year(history.ProcedureDate)=2016 and MONTH(history.ProcedureDate)=10 and day(history.ProcedureDate)>=15


---------------------------------------ცხრილების გაერთიანება subquery-ის საშუალებით. აკრძალულია join ოპერატორის გამოყენება---------------------------

--20. გამოიტანეთ ყველაზე იაფფასიანი პროცედურების აღწერა (Description) და ფასი (Price);

select p.Description , p.Price from dbo.Procedures p
where p.Price = 
(select min(pr.Price) from dbo.Procedures pr)

--21. გამოიტანეთ ქალაქებში Detroit ან Lansing -ში მცხოვრებ იმ პირთა რაოდენობა, რომლებსაც ჰყავთ ძაღლი (Dog)
--ან კატა (Cat);

select count(*) from dbo.Owners o
where  o.City in('Lansing','Detroit') and o.OwnerID in 
(select p.OwnerID from dbo.Pets p
	where p.PetTypeId in 
		(select t.PetTypeId from dbo.PetTypes t 
			where t.Name in ('cat' , 'dog')))

--22. გამოიტანეთ 2016 წლის იანვარში საშუალოზე იაფად ღირებული პროცედურების ჩატარების თარიღები. თუ
--ერთ დღეს ჩატარდა ორი ან მეტი ასეთი პროცედურა, თარიღი გამოიტანეთ მხოლოდ ერთხელ;

select distinct h.ProcedureDate from dbo.ProceduresHistory h 
where year(h.ProcedureDate)=2016 and month(h.ProcedureDate)=1 and  h.ProcedureId in
(select p.ProcedureId from dbo.Procedures p where p.Price <
	(select avg(pr.price) from dbo.Procedures pr))

-------------------------------------------მონაცემთა დაჯგუფება-----------------------------------------------------


--23. გამოიტანეთ ჩატარებული პროცედურების რაოდენობა ცხოველთა ტიპების მიხედვით. შედეგად უნდა მიიღოთ
--ვირტუალური ცხრილი, რომელსაც ექნება 2 სვეტი და 3 სტრიქონი;

select t.Name , count(*) from dbo.Procedures p
join dbo.ProceduresHistory ph on ph.ProcedureId=p.ProcedureId
join dbo.Pets pt on pt.PetId=ph.PetID
join dbo.PetTypes t on t.PetTypeId=pt.PetTypeId
group by t.name 


select pt.Name , count(*) from dbo.Procedures p
join dbo.ProceduresHistory h on h.ProcedureId=p.ProcedureId
join dbo.pets t on t.PetId=h.PetID
join dbo.PetTypes pt on pt.PetTypeId=t.PetTypeId
group by pt.Name

--24. გამოიტანეთ პროცედურის ტიპები და თითოეულ მათგანში ყველაზე იაფი პროცედურის ღირებულება.
--შედეგად უნდა მიიღოთ ვირტუალური ცხრილი, რომელსაც ექნება 2 სვეტი და 6 სტრიქონი. მონაცემები
--დაალაგეთ ღირებულების ზრდადობის მიხედვით;


select pt.name , min(p.Price) from dbo.ProcedureTypes pt 
join dbo.Procedures p on p.ProcedureTypeId=pt.ProcedureTypeId
group by pt.Name



select pt.Name  , min(p.Price)  from dbo.Procedures p
join  dbo.ProcedureTypes pt on p.ProcedureTypeId=pt.ProcedureTypeId
group by pt.Name



--25. გამოიტანეთ პირების სახელი, გვარი და მათი ცხოველთა რაოდენობა მხოლოდ იმ პირებისათვის, რომლებსაც
--ჰყავთ ერთზე მეტი ცხოველი;


select o.Surname , o.Name , count(*) from owners o 
join dbo.pets p on p.OwnerID=o.OwnerID
group by o.name , o.Surname
having count(*)>1



select count(*) , o.Name , o.Surname from dbo.Owners o
join dbo.Pets p on p.OwnerID=o.OwnerID
group by o.Name , o.Surname
having count(*)>1

--26. გამოიტანეთ 2016 წლის ზაფხულში ჩატარებული პროცედურების რაოდენობა თვეების მიხედვით. პირველ
--სვეტში გამოიტანეთ ზაფხულის თვეები ინგლისურ ენაზე, მეორე სვეტში კი პროცედურების რაოდენობა.
--მონაცემები დაალაგეთ პროცედურების რაოდენობის ზრდადობის მიხედვით;


select datename(mm,ph.ProcedureDate) , count(*) from dbo.ProceduresHistory ph
join dbo.Procedures p on ph.ProcedureId=p.ProcedureId
where datepart(mm,ph.ProcedureDate) in (6, 7, 8) and year(ph.ProcedureDate)=2016
group by datename(mm,ph.ProcedureDate)
order by 2


select datename(mm,ph.ProcedureDate) , count(*) from dbo.ProceduresHistory ph
where year(ph.ProcedureDate) =2016 and month(ph.ProcedureDate) between 6 and 8
group by datename(mm,ph.ProcedureDate)
order by 2

------------------------------------მონაცემების დამატება, განახლება და წაშლა subquery-ის გამოყენებით-----------------------------------------

--27. სამედიცინო პროცედურების ცხრილში დაამატეთ ახალი პროცედურა Carding რომლის პროცედურის ტიპის
--არის GROOMING. აღწერაში (Description) ჩაწერეთ removes the undercoat, ხოლო ფასში -17;

insert into dbo.Procedures (ProcedureTypeId , Description , Price)
values ((select pt.ProcedureTypeId from dbo.ProcedureTypes pt where pt.Name='Grooming') , 'removes the undercoast' , 39)


select * from dbo.Procedures

--28. ძაღლმა სახელად Jake შეიცვალა მფლობელი. ახალი მფლობელია Luisa Cuellar. ასახეთ ეს ცვლილება dbo.Pets
--ცხრილში - განაახლეთ Jake -ის ძველი მფლობელი ახლით.;

update dbo.Pets
set OwnerID = (select o.OwnerID from dbo.Owners o where o.Name='luisa' and o.Surname='cuellar')
where name='jake'

--29. იმ ქირურგიული (GENERAL SURGERIES) პროცედურების ღირებულება, რომელთა ფასი აღემატება 480 -ს,
--შეამცირეთ 8 % -ით;

update dbo.Procedures
set Price = price*0.92
where price>480 and ProcedureTypeId = (select pt.ProcedureTypeId from dbo.ProcedureTypes pt where pt.Name like '%GENERAL SURGERIES%')


--30. პროცედურების ისტორიიდან (dbo.ProceduresHistory) წაშალეთ მონაცემები 2016 წლის სექტემბერში
--ჩატარებული აცრების (VACCINATIONS) შესახებ.

delete from dbo.ProceduresHistory 
where year(ProcedureDate)=2016  and month(ProcedureDate)=9 and  ProcedureId in (select p.ProcedureId from dbo.Procedures p 
	where p.ProcedureTypeId in (select pt.ProcedureTypeId from dbo.ProcedureTypes pt where pt.Name = 'VACCINATIONS'))


--T-SQL პროცედურები
--31. შექმენით პროცედურა, რომელსაც გადაეცემა ორი პარამეტრი: ცხოველის მფლობელის საცხოვრებელი
--ქალაქის სახელი და სამედიცინო პროცედურის ჩატარების თარიღი. პროცედურამ უნდა დააბრუნოს ცხრილი,
--რომელშიც იქნება მონაცემები ამ ქალაქში და თარიღში ჩატარებული სამედიცინო პროცედურების შესახებ:
--ცხოველის სახელი, ცხოველის ტიპი, სამედიცინო პროცედურის ჩატარების თარიღი და ღირებულება,
--ცხოველის მფლობელის ქალაქი. თუ გადაცემული პარამეტრების მიხედვით მონაცემები არ მოიძებნა,
--პროცედურამ უნდა დააბრუნოს შეტყობინება: Record not found.

alter procedure dbo.task31
@city varchar(100),
@date date 
as 

if(
	select count(*) from dbo.Procedures p 
	where p.ProcedureId in (select ph.ProcedureId from dbo.ProceduresHistory ph
	where ph.ProcedureDate = @date and  ph.PetID  in (select pt.PetId from  dbo.Pets pt 
	where pt.OwnerID in (select o.OwnerID from dbo.Owners o where o.City like @city+'%') and 
	pt.PetTypeId in (select t.PetTypeId from dbo.PetTypes t)))
)<1
print 'Record not found.'
else 
select o.name , t.Name , ph.ProcedureDate , p.Price , o.City from dbo.Procedures p
join dbo.ProceduresHistory ph on ph.ProcedureId=p.ProcedureId
join dbo.Pets pt on pt.PetId=ph.PetID
join dbo.Owners o on o.OwnerID=pt.OwnerID
join dbo.PetTypes t on t.PetTypeId=pt.PetTypeId 
where o.City like @city +'%' and ph.ProcedureDate = @date


exec dbo.task31 'Marquette' , '2016-01-11'

exec dbo.task31 'Southfield' , '2116-05-22'

--32. შექმენით პროცედურა, რომელსაც პარამეტრად გადაეცემა სამედიცინო პროცედურის ტიპი სრულად ან
--ნაწილობრივ. პროცედურამ უნდა დააბრუნოს რიცხვი (რაოდენობა), რამდენჯერაც ჩატარდა ამ ტიპის
--სამედიცინო პროცედურა.

alter procedure dbo.task32
@type varchar(40),
@number int output 
as
set @number = (
	select count(*) from dbo.ProceduresHistory ph 
	where ph.ProcedureId in (
		select p.ProcedureId from dbo.Procedures p 
		where p.ProcedureTypeId =(
			select pt.ProcedureTypeId from dbo.ProcedureTypes pt
			where pt.name like @type + '%'
		)
	)
)
print @number


exec dbo.task32 'ortho' , null