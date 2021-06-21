use PortfolioProject

update [dbo].[country_vaccinations]
    set vaccines = replace (vaccines, ',', ' ')
	where vaccines like '%,%'

select*from [dbo].[country_vaccinations]
order by 2

---Share of people who got atleast one dose of vaccine
select country, date, people_vaccinated, population, (people_vaccinated/ population)*100 as Percent_OneDose
from [dbo].[country_vaccinations]
where country= 'india' 

---Share of people who got both doses of vaccine
select country, date, people_fully_vaccinated, population, (people_fully_vaccinated/ population)*100 as Percent_FullDose
from [dbo].[country_vaccinations]
where country= 'india' 

-----Rolling 7day avaerage of vaccines administered per 100 people
select country, date, daily_vaccinations, avg(daily_vaccinations/100) over (order by date
                                                                            rows between 3 preceding and 3 following) MovingAvg_SevenDay
from [dbo].[country_vaccinations] as vac
where country= 'india'

-----Total number of vaccination doses administered per 100 people 
select distinct country, max(total_vaccinations_per_hundred) as TotalVac_100
from [dbo].[country_vaccinations]
group by country
order by country 

---Total vaccine doses administered 
select distinct country, max(total_vaccinations) as TotalVac
from [dbo].[country_vaccinations]
group by country
order by TotalVac desc

------Vaccines administered in each country

SELECT distinct country, vaccines
FROM [dbo].[country_vaccinations]  
WHERE 'astrazeneca' IN (SELECT value FROM STRING_SPLIT(Tags, ' '))
UNION
SELECT distinct country, vaccines
FROM [dbo].[country_vaccinations]  
WHERE 'moderna' IN (SELECT value FROM STRING_SPLIT(Tags, ' '))
UNION
SELECT distinct country, vaccines
FROM [dbo].[country_vaccinations]  
WHERE 'sputnik v' IN (SELECT value FROM STRING_SPLIT(Tags, ' '))
UNION
SELECT distinct country, vaccines
FROM [dbo].[country_vaccinations]  
WHERE 'johnson&johnson' IN (SELECT value FROM STRING_SPLIT(Tags, ' '))
UNION
SELECT distinct country, vaccines
FROM [dbo].[country_vaccinations]  
WHERE 'pfizer' IN (SELECT value FROM STRING_SPLIT(Tags, ' '))
UNION
SELECT distinct country, vaccines
FROM [dbo].[country_vaccinations]  
WHERE 'sinovac' IN (SELECT value FROM STRING_SPLIT(Tags, ' '))
UNION
SELECT distinct country, vaccines
FROM [dbo].[country_vaccinations]  
WHERE 'sinopharm' IN (SELECT value FROM STRING_SPLIT(Tags, ' '))
UNION
SELECT distinct country, vaccines
FROM [dbo].[country_vaccinations]  
WHERE 'cansino' IN (SELECT value FROM STRING_SPLIT(Tags, ' '))
UNION
SELECT distinct country, vaccines
FROM [dbo].[country_vaccinations]  
WHERE 'covaxin' IN (SELECT value FROM STRING_SPLIT(Tags, ' '))



