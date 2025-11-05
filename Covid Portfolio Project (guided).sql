/*
From Alex The Analyst on YouTube (video titled "Data Analyst Portfolio Project | SQL Data Exploration | Project 1/4")
Skills learned:
    Many things from SQL Essential Training LinkedIn Learning course, but also:
    importing tables from CSV files to DB Browser for SQLite,
    ordering by column # (not field name), PARTITIONs, CTEs

List of "DB Browser for SQLite" query tabs:
    SQL 1
    SQL 3
    SQL 4
    SQL 5
    SQL 6
    SQL 7
    SQL 8
    SQL 9
    SQL 10
*/


--========================================================--
-- SQL 1
-- SELECT *
-- FROM CovidDeaths
-- WHERE continent IS NOT NULL
-- ORDER BY 2,3--3,4

-- SELECT *
-- FROM CovidVaccinations
-- ORDER BY 3,4

-- Select data that we are going to be using

SELECT
	continent,--
	location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
FROM
	CovidDeaths
-- WHERE
-- 	continent IS NOT NULL
ORDER BY
	1,2

-- .
-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract Covid in your country
SELECT
	location,
	date,
	total_cases,
	total_deaths,
	(total_deaths*1.0 / total_cases)*100 AS DeathPercentage
FROM
	CovidDeaths
WHERE
-- 	location like 'Afghanistan'
	location like '%states%'
	AND	continent IS NOT NULL
ORDER BY
-- 	1,2
-- 	location,date
-- 	total_deaths ASC
	4


--========================================================--
-- SQL 3
-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

SELECT
	location,
	date,
	population,
	total_cases,
	(total_cases*1.0 / population)*100 AS PercentPopulationInfected --InfectedOfPopPercentage
FROM
	CovidDeaths
WHERE
	location like '%states%'
	AND	continent IS NOT NULL
ORDER BY
	4


--========================================================--
-- SQL 4
-- What countries have the highest infection rates?
-- Looking at countries with highest infection rate compared to population

-- SELECT
-- 	location,
-- 	date,
-- 	population,
-- 	total_cases,
-- 	max((total_cases*1.0 / population)*100) AS MaxInfectedOfPopPercentage
-- FROM
-- 	CovidDeaths
-- -- WHERE
-- -- 	location like '%states%'
-- --	AND	continent IS NOT NULL
-- GROUP BY
-- 	location
-- ORDER BY
-- 	4 DESC

SELECT
	location,
	date,
	population,
	max(total_cases) AS HighestInfectionCount,
	max((total_cases*1.0 / population)*100) AS PercentPopulationInfected
FROM
	CovidDeaths
WHERE
-- 	location like '%states%'
	AND continent IS NOT NULL
GROUP BY
	location, population
ORDER BY
	PercentPopulationInfected DESC


--========================================================--
-- SQL 5
-- Showing countries with highest death count per population

-- SELECT
-- 	location,
-- 	date,
-- 	population,
-- 	max(total_deaths) AS TotalDeathCount,--HighestDeathCount,
-- 	max((total_deaths*1.0 / population)*100) AS PercentPopulationDead
-- FROM
-- 	CovidDeaths
-- -- WHERE
-- -- 	location like '%states%'
-- GROUP BY
-- 	location, population
-- ORDER BY
-- 	PercentPopulationDead DESC

SELECT
	location,
	max(total_deaths) as TotalDeathCount
FROM
	CovidDeaths
WHERE
	continent IS NOT NULL
GROUP BY
	location
ORDER BY
	TotalDeathCount DESC


--========================================================--
-- SQL 6
-- LET'S BREAK THINGS UP BY CONTINENT
-- Showing continents with the highest death count per population

SELECT
	continent,
	max(total_deaths) AS TotalDeathCount
FROM
	CovidDeaths
WHERE
	continent IS NOT NULL
GROUP BY
	continent
ORDER BY
	TotalDeathCount DESC


--========================================================--
-- SQL 7
SELECT
	location,
	max(total_deaths) AS DeathCount
FROM
	CovidDeaths
WHERE
	continent IS NULL
GROUP BY
	location
ORDER BY
	DeathCount DESC


--========================================================--
-- SQL 8
-- GLOBAL NUMBERS

-- SELECT
-- 	date,
-- 	(SELECT sum(total_cases) FROM CovidDeaths
-- 	GROUP BY date HAVING continent IS NOT NULL),
-- 	(SELECT sum(total_deaths) FROM CovidDeaths
-- 	WHERE continent IS NOT NULL GROUP BY date)
-- FROM
-- 	CovidDeaths
-- -- GROUP BY
-- -- 	date
-- -- ORDER BY
-- -- 	sum(total_cases)

-- SELECT
-- 	date,
-- 	sum(total_cases),
-- 	sum(total_deaths)
-- FROM
-- 	CovidDeaths
-- GROUP BY
-- 	date
-- HAVING
-- 	continent IS NOT NULL
-- ORDER BY
-- 	sum(total_cases)

-- SELECT
-- 	date,
-- 	total_cases,
-- 	total_deaths
-- FROM
-- 	CovidDeaths
-- WHERE
-- 	location = 'World'

SELECT
-- 	date,
	sum(new_cases) AS total_cases,
	sum(new_deaths) AS total_deaths,
	sum(new_deaths)*1.0/sum(new_cases)*100 AS DeathPercentage
FROM
	CovidDeaths
WHERE
	continent IS NOT NULL
-- GROUP BY
-- 	date
ORDER BY
	2,3


--========================================================--
-- SQL 9
-- Looking at Total Population vs Vaccinations
-- (All of the code below works)

-- SELECT
-- 	dea.continent,
-- 	dea.location,
-- 	dea.date,
-- 	dea.population,
-- 	vac.new_vaccinations
-- 	, sum(vac.new_vaccinations) OVER (PARTITION BY dea.location
-- 	ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- -- 	, (RollingPeopleVaccinated/population)*100
-- FROM
-- 	CovidDeaths dea
-- JOIN
-- 	CovidVaccinations vac
-- ON
-- 	dea.location = vac.location
-- 	AND dea.date = vac.date
-- WHERE
-- 	dea.continent IS NOT NULL
-- ORDER BY
-- 	2,3


-- USE CTE

-- WITH PopvsVac (Continent, Location, Date, Population, Total_cases, New_vaccinations, RollingPeopleVaccinated)
-- AS
-- (
-- SELECT
-- 	dea.continent,
-- 	dea.location,
-- 	dea.date,
-- 	dea.population,
-- 	dea.total_cases,
-- 	vac.new_vaccinations
-- 	, sum(vac.new_vaccinations) OVER (PARTITION BY dea.location
-- -- 	ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- 	ORDER BY dea.location, dea.total_cases) AS RollingPeopleVaccinated
-- -- 	, (RollingPeopleVaccinated/population)*100
-- FROM
-- 	CovidDeaths dea
-- JOIN
-- 	CovidVaccinations vac
-- ON
-- 	dea.location = vac.location
-- 	AND dea.date = vac.date
-- WHERE
-- 	dea.continent IS NOT NULL
-- ORDER BY
-- 	2,total_cases
-- )
-- SELECT *, (RollingPeopleVaccinated*1.0/Population)*100
-- FROM PopvsVac


-- Creating View to store data for later visualizations

-- CREATE VIEW PercentPopulationVaccinated as
-- SELECT
-- 	dea.continent,
-- 	dea.location,
-- 	dea.date,
-- 	dea.population,
-- 	dea.total_cases,
-- 	vac.new_vaccinations
-- 	, sum(vac.new_vaccinations) OVER (PARTITION BY dea.location
-- -- 	ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- 	ORDER BY dea.location, dea.total_cases) AS RollingPeopleVaccinated
-- -- 	, (RollingPeopleVaccinated/population)*100
-- FROM
-- 	CovidDeaths dea
-- JOIN
-- 	CovidVaccinations vac
-- ON
-- 	dea.location = vac.location
-- 	AND dea.date = vac.date
-- WHERE
-- 	dea.continent IS NOT NULL
-- ORDER BY
-- 	2,total_cases

SELECT *
FROM PercentPopulationVaccinated


--========================================================--
-- SQL 10
-- Testing concatenation in SQLite

SELECT
--     concat(location,continent) --<-- doesn't work
    location||', '||continent
FROM
    CovidDeaths

