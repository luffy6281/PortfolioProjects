--select*from PortfolioProject..COVID_Vaccinations
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population 
from PortfolioProject..COVID_Deaths

--Looking at total_Deaths vs total_cases
--Shows the likelihood of dying due to covid in India
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercent
from PortfolioProject..COVID_Deaths
where location= 'India'
order by 1,2

--Looking at total_cases vs population
select location, date, population, total_cases, (total_cases/population)*100 as Infectrate
from PortfolioProject..COVID_Deaths
where location= 'India'
and continent is not null 
order by 1,2

--Looking at countries with highest infected
select location, population, max(total_cases), (max(total_cases)/population)*100 as Infectpercent
from PortfolioProject..COVID_Deaths 
where continent is not null 
group by location, population
order by Infectpercent desc 

--countries with Highest death count per population
select location, max(cast (total_deaths as int)) as totaldeathcount
from PortfolioProject..COVID_Deaths
where continent is not null 
group by location
order by totaldeathcount desc 

--highest death count by continents
select location, max(cast (total_deaths as int)) as totaldeathcount
from PortfolioProject..COVID_Deaths
where continent is null
group by location
order by totaldeathcount desc
 
--Global Rate
select sum(new_cases) as cases_total, sum(cast(new_deaths as int)) as deaths_total, (sum(cast(new_deaths as int))/sum(new_cases))*100 as Globaldeaths
from PortfolioProject..COVID_Deaths
where continent is not null
order by 1,2
------------------------------------------------------------------------------------------------------------------
---Total population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as cumulative_vaccination
from PortfolioProject..COVID_Deaths dea
join PortfolioProject..COVID_Vaccinations vac
 on dea.location= vac.location
 and dea.date= vac.date
where dea.continent is not null 
order by 2,3

--Use CTE

with PopvsVac(continent, location, date, population, new_vaccinations, cumulative_vaccination)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as cumulative_vaccination
from PortfolioProject..COVID_Deaths dea
join PortfolioProject..COVID_Vaccinations vac
 on dea.location= vac.location
 and dea.date= vac.date
where dea.continent is not null 
)
select*, (cumulative_vaccination/population)*100 as Cumulative_percent
from PopvsVac      

---TEMP Table

drop table #PercentPopulation_Vaccinated

create table #PercentPopulation_Vaccinated
(
continent nvarchar(60),
location nvarchar(60),
date datetime,
population numeric,
new_vaccinations numeric,
cumulative_vaccination numeric
)

insert into #PercentPopulation_Vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as cumulative_vaccination
from PortfolioProject..COVID_Deaths dea
join PortfolioProject..COVID_Vaccinations vac
 on dea.location= vac.location
 and dea.date= vac.date
where dea.continent is not null

select*, (cumulative_vaccination/population)*100 
from #PercentPopulation_Vaccinated
order by 1,2

------Create view to store data for visualization

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as cumulative_vaccination
from PortfolioProject..COVID_Deaths dea
join PortfolioProject..COVID_Vaccinations vac
 on dea.location= vac.location
 and dea.date= vac.date
where dea.continent is not null 
--order by 2,3 

select*from PercentPopulationVaccinated





