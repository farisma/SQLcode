--select * from PortfolioProject.dbo.covidvaccinations
--select * from PortfolioProject.dbo.coviddeaths

select location, date, total_deaths
from PortfolioProject.dbo.owidcoviddata

select location, date, total_deaths/total_cases * 100 as deathrate, population from PortfolioProject.dbo.owidcoviddata

--population infected rate
select location, date, total_cases, total_cases/population * 100 as poplrate, population 
from PortfolioProject.dbo.owidcoviddata


--highest infection and total cases rate and total death rate

select location, population, MAX(total_cases) as highestinfectioncnt, MAX(total_cases/population) * 100 as poplrate, MAX(total_deaths/population) * 100 as deathrate
from PortfolioProject.dbo.owidcoviddata
--where location like '%india%' 
group by location, population 
order by location desc


select location, total_deaths 
from PortfolioProject.dbo.owidcoviddata
order by total_deaths desc

select location, Max(total_deaths) from PortfolioProject.dbo.owidcoviddata
where continent is null
group by location
order by location desc


--global numbers

select date, SUM(total_deaths) as totaldeaths, SUM(new_deaths)/SUM(new_cases) as deathpercent
from PortfolioProject.dbo.owidcoviddata
where continent is not null 
group by date
having SUM(new_cases) != 0
order by date

select date, location, SUM(new_cases) as new cases
from PortfolioProject.dbo.owidcoviddata
group by date, location
having SUM(new_cases) = 0


select 
SUM(total_deaths) as deaths,
SUM(total_cases) as cases,
SUM(population) as population,
SUM(total_cases)/SUM(population) * 100 as totalcasesrate,
SUM(total_deaths)/SUM(population) * 100 as deathrate 
from PortfolioProject.dbo.owidcoviddata


select * from PortfolioProject.dbo.covidvaccinations

--Join 
select * from PortfolioProject.dbo.owidcoviddata as dea
join PortfolioProject.dbo.covidvaccinations as vac
on dea.date = vac.date and dea.location = vac.location

--Total population vs total vaccinations

select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations 
from PortfolioProject.dbo.owidcoviddata as dea
join PortfolioProject.dbo.covidvaccinations as vac
on dea.date = vac.date and dea.location = vac.location


--Below code will fetch number of vaccinations based on location and date against each row, as mentioned in partition by (order by location and date)
--usually if we just just partition by location, it will just show total vaccinations with respect to each location in each rows
--in this case, each row of location will show sum of vaccinations in the previous row and contious row, not the total vaccinations with respect to location
-- Its called finding the rolling sum of rows
select dea.continent, dea.location,dea.date, dea.population, SUM(cast(vac.new_vaccinations as int)) over (PARTITION BY dea.location order by dea.date,dea.location) as rollingsumvaccine
from PortfolioProject.dbo.owidcoviddata as dea
join PortfolioProject.dbo.covidvaccinations as vac
on dea.date = vac.date and dea.location = vac.location

--if we want to use the aliases as input for another column, its not possible, thats when we use CTE
--we can use those aliases in CTEs
-- below, for example, newvac cant be used, so we need to use temp table or CTE.
select  dea.location,dea.date, SUM(cast(vac.new_tests as int)) as newvac, newvac/vac.total_tests as n
from PortfolioProject.dbo.owidcoviddata as dea
join PortfolioProject.dbo.covidvaccinations as vac
on dea.date = vac.date and dea.location = vac.location
group by dea.location,dea.date


-- using CTE
-- here variables must be passed as we use join below and number of variables passed should be same as number of variables in 
-- select query
with CTE_newvac ( location,date,population, newvac)
as
(
select dea.location, dea.date, dea.population, SUM(cast(vac.new_tests as int)) as newvac
from PortfolioProject.dbo.owidcoviddata as dea
join PortfolioProject.dbo.covidvaccinations as vac
on dea.date = vac.date and dea.location = vac.location
group by dea.location,dea.date,dea.population
)

select *, newvac/population as popratio from CTE_newvac where newvac is not NULL

-- using temptable 
drop table if exists #temp_newvac 
create table #temp_newvac 
(
location nvarchar(255),
date nvarchar(255),
population numeric,
newvac numeric
)

insert into #temp_newvac 
select dea.location, dea.date, dea.population, SUM(cast(vac.new_tests as int)) as newvac
from PortfolioProject.dbo.owidcoviddata as dea
join PortfolioProject.dbo.covidvaccinations as vac
on dea.date = vac.date and dea.location = vac.location
group by dea.location,dea.date,dea.population


select *, newvac/population as n from #temp_newvac where newvac is not NULL

-- create view - view is used for visualisations later using tableu or powerbi
-- can be found in views below tables in LHS

create view testview as
select dea.location, dea.date, dea.population, SUM(cast(vac.new_tests as int)) as newvac
from PortfolioProject.dbo.owidcoviddata as dea
join PortfolioProject.dbo.covidvaccinations as vac
on dea.date = vac.date and dea.location = vac.location
group by dea.location,dea.date,dea.population


select * from testview