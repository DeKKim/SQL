--15
select p.name, p.year from [dbo].[Paintings] p
join [dbo].[Mediums] m on p.medium_id=m.medium_id
where m.medium_type='watercolor' and p.height_cm*p.width_cm <= 1000

--16
select a.last_name, a.first_name from [dbo].[Artists] a
join [dbo].[Countries] c on a.country_id=c.country_id
join [dbo].[Art_movements] am on a.art_movement_id=am.art_movement_id
where am.art_movement='Classicism' and c.Name='indonesia'

--17
select a.last_name, a.first_name, p.name, DATEDIFF(DD, gp.start_date, gp.end_date) from [dbo].[Paintings] p
join [dbo].[Artists] a on p.artist_id=a.artist_id
join [dbo].[GalleryPaintings] gp on p.painting_id=gp.painting_id
join [dbo].[Galleries] g on gp.gallery_id=g.gallery_id
where g.name='Galleria Moretti' and year(gp.start_date)=2019 and DATEPART(QUARTER, gp.start_date)in (3,4)

--18
select p.name, p.width_cm, p.height_cm from [dbo].[Paintings] p
where p.year between 1994 and 2004 and p.medium_id =
(select m.medium_id from [dbo].[Mediums] m
where m.medium_type='Acrylic')

--19
select count(*) from [dbo].[Paintings] p
where p.width_cm*p.height_cm >
(select AVG(p.height_cm*p.width_cm) from [dbo].[Paintings] p)

--20
select p.name from [dbo].[Paintings] p
where p.painting_id = (select gp.painting_id from [dbo].[GalleryPaintings] gp
where gp.start_date = (select MIN(gp.start_date) from [dbo].[GalleryPaintings] gp))

--21
select c.Name, count(*) from [dbo].[Artists] a
join [dbo].[Countries] c on a.country_id=c.country_id
join [dbo].[Paintings] p on a.artist_id=p.artist_id
where c.Name in ('Argentina','Brazil','Paraguay')
group by c.Name

--22
select am.art_movement, MAX(p.height_cm) from [dbo].[Art_movements] am
join [dbo].[Artists] a on am.art_movement_id=a.art_movement_id
join [dbo].[Paintings] p on p.artist_id=a.artist_id
group by am.art_movement
order by MAX(p.height_cm) desc

--23
select a.first_name, a.last_name, COUNT(*) from [dbo].[Artists] a
join [dbo].[Paintings] p on a.artist_id=p.artist_id
group by a.first_name, a.last_name
having count(*)>5

--24
insert into [dbo].[Paintings] (name, year, height_cm, width_cm, medium_id, artist_id) values
('singing in the rain', YEAR(GETDATE()), 60, 60,
(select m.medium_id from [dbo].[Mediums] m where m.medium_type='Tempera'),
(select a.artist_id from [dbo].[Artists] a where a.first_name='Michele' and a.last_name='Joice')
)

--25
update [dbo].[GalleryPaintings] set end_date = GETDATE()
where end_date is null and  painting_id in (select p.painting_id from [dbo].[Paintings] p
where p.artist_id = (select a.artist_id from [dbo].[Artists] a where a.first_name='Leana' and a.last_name='Daggett'))

--26
delete from [dbo].[Mediums]
where medium_id not in (select distinct p.medium_id from [dbo].[Paintings] p)

--27
create procedure dbo.procedure01
@wh int,
@lname varchar(50)
as
if (select count(*) from [dbo].[Artists] a
join [dbo].[Paintings] p on a.artist_id=p.artist_id
where p.width_cm<@wh and p.height_cm<@wh and LEFT(a.last_name, LEN(@lname))=@lname) > 0
begin
select a.last_name, a.first_name, p.name, p.height_cm, p.width_cm from [dbo].[Artists] a
join [dbo].[Paintings] p on a.artist_id=p.artist_id
where p.width_cm<@wh and p.height_cm<@wh and LEFT(a.last_name, LEN(@lname))=@lname
end
else
begin
print 'Record not found'
end

exec dbo.procedure01 100,'win'
exec dbo.procedure01 100,'winn'

--28
create procedure dbo.procedure02
@country varchar(50)
as
if (select count(*) from [dbo].[Countries] c where c.Name=@country) = 0
begin
insert into [dbo].[Countries] (Name) values
(@country)
end
else
begin
print 'country already exists'
end

exec dbo.procedure02 'colombia'