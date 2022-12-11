


Select *
From PortfolioProject1..CovidDeaths$
Where continent is not null
Order by 3,4


--Select *
--From PortfolioProject1..CovidVaccinations$
--Order by 3,4

--Select Data thet we are going to start with

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject1..CovidDeaths$
Where continent is not null 
Order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of fatalility if contracted in particular country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
From PortfolioProject1..CovidDeaths$
Where location like '%states%'
and continent is not null 
Order by 1,2


-- Total Cases vs Total Population
-- Shows what % of population infected with COvid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfectd
From PortfolioProject1..CovidDeaths$
--Where location like '%states%' 
Order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select location, date, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfectd
From PortfolioProject1..CovidDeaths$
--Where location like '%states%'
Group by Location, Population
Order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths$
--Where location like '%states%'
Where continent is not null
Group by Location
Order by TotalDeathCount desc


-- Breaking things down by CONTINENT

-- Showing continents with the highest death per population

Select continent, Max(total_deaths as int) as TotalDeathCount
From PortfolioProject1..CovidDeaths$
--Where location like '%states%'
Group by continent
Order by TotalDeathCount desc


-- Global Numbers

Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths$
--Where location like '%states%'
Where continent is not null
-- Group by date
Order by 1,2


-- Total Population vs Vaccinations
-- SHows Percentage of Population that has received at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, Sum(Convert(int, vac.new_vaccinations)) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated -- , (RollingPeopleVaccinated/population)*100
From PortfolioProject1..CovidDeaths$ dea
Join PortfolioProject1..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

 


-- Using Temp Table to perform Calculation on Partition By in previous query

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinatged numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, Sum(Convert(int, vac.new_vaccinations)) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated -- , (RollingPeopleVaccinated/population)*100
From PortfolioProject1..CovidDeaths$ dea
Join PortfolioProject1..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, Sum(Convert(int, vac.new_vaccinations)) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated -- , (RollingPeopleVaccinated/population)*100
From PortfolioProject1..CovidDeaths$ dea
Join PortfolioProject1..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null



