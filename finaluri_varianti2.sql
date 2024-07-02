--ცხრილების გაერთიანება join ოპერატორის საშუალებით
--15) გამოიტანეთ ი, პირების გვარი და სახელი რომელთა გვარი იწყება p სიმბოლოზე და რომლებსაც ჰყავთ დაღლი ,მესამე სვეტში გამოიტანეთ დაღლის სახელი
select o.Surname,o.Name from Owners o
inner join Pets p on o.OwnerID=p.OwnerID
inner join PetTypes pt on p.PetTypeId=pt.PetTypeId
where pt.Name='Dog' and o.Surname like 'p%'

--16)გამოიტანეთ ცხოველების სახელი რომლებსაც ჩაუტარდათ აცრა (vactinations) საკუთარ დაბადების წელს ,მეორე და მესამე სვეტში გამოიტანეთ დაბადების წელი და აცრის თარიღი
select p.Name,p.BirthYear from Pets p
inner join ProceduresHistory ph on p.PetId=ph.PetID
inner join Procedures pr on ph.ProcedureId=pr.ProcedureId
inner join ProcedureTypes prt on pr.ProcedureTypeId=prt.ProcedureTypeId
where prt.Name='vaccinations' and p.BirthYear=YEAR(ph.ProcedureDate)

--17)გამოიტანეთ ქალაქ Detroit-ში მცხოვრები პირების გვარი და სახელი რომლებმაც საკუთარ კატას ჩაუტარეს სამედიცინო პროცედურა 2016 წლის დეკემბრის პირველ ნახევარში, მესამე სვეტში გამოიტანეთ კატის სახელი თუ ცხოველს ამ პერიოდში პროცედურა ჩაუტარდა რამდენიმეჯერ, გამოტანისას მისი და მფლობელის მონაცემები გამოიტანეთ მხოლოდ ერთხელ
select distinct o.Name,o.Surname,p.Name from Owners o
inner join Pets p on o.OwnerID=p.OwnerID
inner join PetTypes pt on p.PetTypeId=pt.PetTypeId
inner join ProceduresHistory ph on p.PetId=ph.PetID
where YEAR(ph.ProcedureDate)=2016 and month(ph.ProcedureDate)=12
and day(ph.ProcedureDate)<=15 and pt.Name='cat' and o.City='Detroit'

--ცხრილის გაერთიანება subquery-ის საშუალებით, აკრძალულია join ოპერატორის გამოყენება
--18)გამოიტანეთ ყველაზე ძვირად ღირებული პროცედურის აღწერა(Description) და ფასი (Price)
select p.Description,p.Price from Procedures p
where p.Price in (select max(pr.Price)from Procedures pr)

--19)გამოიტანეთ ქალაქ Pontiac-ში მცხოვრებ იმ პირთა სახელი და გვარი, ვისაც ჰყავს ძაღლი (Dog)
select o.Name,o.Surname from Owners o
where o.City='pontiac' and o.OwnerID in
(select p.OwnerID from Pets p
where p.PetTypeId in
(select pt.PetTypeId from PetTypes pt
where pt.Name='dog'
))

--20)გამოიტანეთ 2016 წლის აპრილში ჩატარებული საშუალოზე ძვირად ღირებული პროცედურების ჩატარების თარიღები, თუ ერთ დღეს ჩატარდა ორი ან მეტი ასეთი პროცედურა, თარიღი გამოითანეთ მხოლოდ ერთხელ
 select distinct p.ProcedureDate from ProceduresHistory p
where p.ProcedureId in (select pr.ProcedureId from Procedures pr
where pr.price > (select avg(pro.Price)from Procedures pro))
and YEAR(p.ProcedureDate)=2016 and MONTH(p.ProcedureDate)=5

 --მონაცემთა დაჯგუფება

 --21)გამოიტანეთ ჩატარებული პროცედურების რაოდენობა ცხოველთა ტიპების მიხედვით, შედეგად ინდა მიიღოთ ვირტუა;ური ცხრილი, რომელსაც ექნება 2 სვეტი და 3 სტრიქონი
 
select d.name, count(a.procedureID)
from procedures a
join [dbo].[ProceduresHistory] b on a.procedureID = b.procedureID
join pets c on b.petID = c.petID
join petTypes d on c.PetTypeId = d.PetTypeId
group by d.name

 --22) გამოიტანეტ პროცედურის ტიპები და თითოეული მათგანი ყველაზე ძვირი პროცედურის ღირებულება. შედეგად უნდა მიიღოთ ვირტუალური ცხრილი, რომელსაც ექნება 2 სვეტი და 6 სტრიქონი. მონაცემები დაალაგეთ ღირებულების კლებადობის მიხედვით
 select b.name, max(a.price)
from procedures a
join [dbo].[ProcedureTypes] b on a.procedureTypeID = b.procedureTypeID
group by b.name

 --23)გამოიტანეთ პირების სახელი, გვარი და მათი ცხოველთა რაოდენობა მხოლოდ იმ პირებისთვის, რომლებსაც ჰყავთ ორზე მეტი ცხოველი
 select o.Name,o.Surname,count(*) PetNum from Owners o
inner join Pets p on p.OwnerID = o.OwnerID
group by o.Name,o.Surname
having count(*) > 2


 --24)გამოიტანეთ 2016 წლის გაზაფხულზე ჩატარებული პროცედურების რაოდენობა თვების მიხედვით. პირველ სვეთში გამოიტანეთ გაზაფხულის თვები ინგლისურ ენაზე, მეორე სვეტში კი პროცედურების რაოდენობა. მონაცემები დაალაგეთ პროცედურების რაოდენობის კლების მიხედვით
 select datename(mm,ph.ProcedureDate) month ,count(*) 'procedure count' from ProceduresHistory ph
where year(ph.ProcedureDate)=2016 and month(ph.ProcedureDate) between 3 and 5
group by datename(mm,ph.ProcedureDate)
order by count(*) desc

 --მონაცემების დამატება, განახლება და წაშლა subquery-ის გამოყენებით
 --25)ცხოველების ცხრილში (dbo.Pets) დაამატეთ მიმდინარე წელს დაბადებული ცხოველი, რომელიც ეკუთვნი Sabrina Britton-ს. ცხოველის სახელი და სქესი შეითანეთ თქვენი სურვილისამებრ
 insert into pets (petId, name, PetTypeId, Gender, Birthyear, ownerID)
values (4408,  'Fluffy',  )

 --26)პირი, რომელსაც ჰყავს 2014 წელს დაბადებული ცხოველი სახელით Dexter საცხოვრებლად გადავიდა თქვენს მეზობლად. შესაბამისად ჩაანაცვლეთ მისი მისამართი (StreetAdress და City) თქვენი მისამართით
 update Owners
SET City='Tbilisi',StreetAddress='Romanoz khomleli Street'
where OwnerID in (
select p.OwnerID from Pets p
where p.name='dexter' and p.BirthYear=2014)

 --27)იმ ორთოპედიული (Orthopedic) ტიპის პროცედურების ღირებულება, რომელთა ფასი აღემატება 300-ს შეამცირეთ 10%-ით
 update Procedures
set Price=price*0.9
where price>300 and ProcedureTypeId in (
select prt.ProcedureTypeId from ProcedureTypes prt
where prt.Name='ORTHOPEDIC')

 --28)პროცედურების ისტორიიდან (dbo.ProceduresHistory)წაშალეთ მონაცემები 2016 წლის აპრილში ჩატარებული აცრების (Vaccinations) შესახებ
 DELETE FROM ProceduresHistory
where year(ProcedureDate)=2016 and month(ProcedureDate)=4 and
ProcedureId in (
select pr.ProcedureId from Procedures pr
where pr.ProcedureTypeId in (
select prt.ProcedureTypeId from ProcedureTypes prt
where prt.name='VACCINATIONS'))


29) create procedure Procedure1
@petType varchar(255),
@procDate varchar(255)
as
 if exists(select pt.Name,ph.ProcedureDate from PetTypes pt
inner join Pets p on pt.PetTypeId=p.PetTypeId
inner join ProceduresHistory ph on p.PetId=ph.PetID
inner join Procedures pr on ph.ProcedureId=pr.ProcedureId
where pt.Name=@petType and ph.ProcedureDate=@procDate)
  begin
select pt.Name,ph.ProcedureDate from PetTypes pt
inner join Pets p on pt.PetTypeId=p.PetTypeId
inner join ProceduresHistory ph on p.PetId=ph.PetID
inner join Procedures pr on ph.ProcedureId=pr.ProcedureId
where pt.Name=@petType and ph.ProcedureDate=@procDate
  end
 else
  begin
print 'Reccord not found'
  end

  30) create procedure Procedure2
@city varchar(255)
as
select o.City, count(*) 'City not found' from Owners o
inner join Pets p on o.OwnerID=p.OwnerID
where o.City like '%'+@city+'%'
group by o.City
