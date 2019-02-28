--Must use temp table, table variable won't work--

create table #shiftDuration (
	Centre nvarchar(100),
	Name nvarchar(100),
	Room nvarchar(100),
	Start date,
	Duration Decimal(18,2)
)

declare @dateColumn nvarchar(max),@sql nvarchar(max)
set @dateColumn=''

insert into #shiftDuration
select * from
(select 
	S.name as [Centre],
	E.Name as [Name],
	D.name as [Room],
	Convert(date, RE.startdatetime) as [Start],
	--Convert(nvarchar,DatePart(YYYY, RE.startdatetime))+'-'+Convert(nvarchar,DatePart(MM, RE.startdatetime))+'-'+Convert(nvarchar,DatePart(DAY, RE.startdatetime)) as [Start],
	Cast(DateDiff(SS,RE.StartDateTime,RE.EndDateTime)/3600.00 as decimal(18,2)) as [Duration]
	from RosterEntry RE
	left join rostershift RS on RS.id=RE.RosterShiftId
	left join Department D on RS.departmentid=D.id
	left join [Site] S on S.id=D.SiteId
	left join Employee E on E.id=RE.EmployeeId

	where RE.StartDateTime between '2018-11-19 00:00:00' and '2018-12-31 23:59:59') as J

select * from #shiftDuration where Name='HELOO, JESSICA'

select @dateColumn+=N',p.'+QUOTENAME(Start) 
from 
( select Top 14 * from
(select distinct Start from #shiftDuration) as O
order by Start asc) as I

select @dateColumn

set @sql=N'select * from #shiftDuration as U Pivot (Max(Duration) for Start in ('+STUFF(REPLACE(@dateColumn,'p.',''),1,1,'')+')) as P order by [Centre] asc;'
print @sql

exec sp_executesql @sql

drop table #shiftDuration