declare @str1 nvarchar(max)
declare @str2 nvarchar(max)
declare @str3 nvarchar(max)
set @str1='/asdfas/asdfasd/afdsa/123456789123456789123456789123456789'
set @str2='/asdfas/asdfasd/afdsa/'
set @str3='/asdfas/asdfasd/afdsa/dfasdf'
select substring(@str1,1, (len(@str1)- CHARINDEX('/',Reverse(@str1))))
select substring(@str2,1, (len(@str2)- CHARINDEX('/',Reverse(@str2))))
select len(@str3)- len(substring(@str3,1, (len(@str3)- CHARINDEX('/',Reverse(@str3)))))
select len(@str2)- len(substring(@str2,1, (len(@str2)- CHARINDEX('/',Reverse(@str2)))))
select 
case when len(@str1)- len(substring(@str1,1, (len(@str1)- CHARINDEX('/',Reverse(@str1)))))=37
then substring(@str1,1, (len(@str1)- CHARINDEX('/',Reverse(@str1)))) else @str1 end 

select 
case when len(@str2)- len(substring(@str2,1, (len(@str2)- CHARINDEX('/',Reverse(@str2)))))=37
then substring(@str2,1, (len(@str2)- CHARINDEX('/',Reverse(@str2)))) else @str2 end 

select 
case when len(@str3)- len(substring(@str3,1, (len(@str3)- CHARINDEX('/',Reverse(@str3)))))=37
then substring(@str3,1, (len(@str3)- CHARINDEX('/',Reverse(@str3)))) else @str3 end 
