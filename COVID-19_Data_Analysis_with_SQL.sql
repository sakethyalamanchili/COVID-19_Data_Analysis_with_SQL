/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


-- Select all columns from the 'CovidDeaths' table in the 'PortfolioProject' database.
SELECT *
-- Filter rows where the 'continent' column is not null.
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
-- Order the result set by the third and fourth columns (columns 3 and 4).
ORDER BY 3, 4





-- Select Data that we are going to be starting with

-- Select columns for Location, date, total_cases, new_cases, total_deaths, and population.
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
ORDER BY 1,2





-- Total Cases vs Total Deaths
-- Shows the probability of mortality if you contract COVID-19 in your country.

-- Selecting the desired columns and calculating DeathPercentage
SELECT
    Location,         -- Location of the data
    date,             -- Date of the data
    total_cases,      -- Total cases in India
    total_deaths,     -- Total deaths in India
    ((CAST(total_deaths AS float)) / (CAST(total_cases AS float))) * 100 as DeathPercentage
                     -- Calculating the DeathPercentage using CAST for accuracy
FROM
    PortfolioProject..CovidDeaths
WHERE
    location = 'India'   -- Filtering data for India
    AND continent IS NOT NULL   -- Ensuring continent information is available
ORDER BY 1, 2   -- Sorting the results by Location and Date





-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT Location, date, Population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2





-- Countries with Highest Infection Rate compared to Population
-- Select the location, population, and the maximum total cases within each location.
-- Calculate the highest infection count and the percentage of the population infected.

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, 
	MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC





-- Countries with Highest Death Count per Population

SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC
 




-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

SELECT continent, MAX(CONVERT(int, total_deaths)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC





-- GLOBAL NUMBERS
-- Calculate the number of new cases for each date.

SELECT date, SUM(new_cases) AS NewCases, SUM(CONVERT(int, new_deaths)) AS NewDeaths,
	SUM(CONVERT(int, new_deaths))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date DESC





/* This SQL query retrieves data from the 'CovidDeaths' table to calculate the total cases, total deaths,
and death percentage on each date for all continents. It ensures there is no division by zero in the death percentage calculation. */

SELECT
    date,
    SUM(new_cases) AS total_cases,
    SUM(cast(new_deaths AS int)) as total_deaths,
    CASE
        WHEN SUM(new_Cases) = 0 THEN 0  -- Avoid division by zero
        ELSE SUM(CAST(new_deaths AS int))/SUM(new_Cases)*100
    END AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date





-- GLOBAL TOTAL

SELECT SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths,
	SUM(cast(new_deaths as int))/SUM(new_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
ORDER BY 1,2





-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
/* This SQL query retrieves data from the 'CovidDeaths' and 'CovidVaccinations' tables
to calculate rolling people vaccinated for each location and date, ensuring proper data type handling. */

SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3





-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS VaccinationPercentage
FROM PopvsVac





-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

Select *, (RollingPeopleVaccinated/Population)*100 AS VaccinationPercentage
From #PercentPopulationVaccinated





-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *
FROM PercentPopulationVaccinated