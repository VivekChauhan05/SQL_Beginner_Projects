# COVID-19 Data Exploration 🌐

## Overview

This project presents a comprehensive SQL-based exploration of COVID-19 data. It delves into identifying significant patterns, computing critical metrics, and performing transformative operations to generate actionable insights. Advanced SQL techniques such as joins, Common Table Expressions (CTEs), temporary tables, window functions, aggregate functions, creating views, and data type conversions are employed throughout this analysis.

---

## Data Sources 📊

The analysis leverages two primary datasets:

1. **CovidDeaths**: Provides information on COVID-19 cases, deaths, and population demographics.
2. **CovidVaccinations**: Records COVID-19 vaccination data across various locations.

---

## SQL Queries and Analysis 🛠️

### Initial Data Exploration

- **Filtering and Sorting Data:**

  ```sql
  SELECT *
  FROM PortfolioProject..CovidDeaths
  WHERE continent IS NOT NULL
  ORDER BY 3, 4;
  ```

- **Selecting Key Attributes:**

  ```sql
  SELECT Location, Date, Total_Cases, New_Cases, Total_Deaths, Population
  FROM PortfolioProject..CovidDeaths
  WHERE continent IS NOT NULL
  ORDER BY 1, 2;
  ```

### Key Metrics 📈

- **Total Cases vs Total Deaths:**
  This query evaluates the likelihood of mortality among COVID-19 patients within a given location.

  ```sql
  SELECT Location, Date, Total_Cases, Total_Deaths,
         (Total_Deaths / Total_Cases) * 100 AS DeathPercentage
  FROM PortfolioProject..CovidDeaths
  WHERE Location LIKE '%states%' AND continent IS NOT NULL
  ORDER BY 1, 2;
  ```

- **Total Cases vs Population:**
  This query calculates the proportion of the population infected by COVID-19.

  ```sql
  SELECT Location, Date, Population, Total_Cases,
         (Total_Cases / Population) * 100 AS PercentPopulationInfected
  FROM PortfolioProject..CovidDeaths
  ORDER BY 1, 2;
  ```

### Highest Infection and Death Rates 🏆

- **Countries with Highest Infection Rates:**

  ```sql
  SELECT Location, Population, MAX(Total_Cases) AS HighestInfectionCount,
         MAX((Total_Cases / Population) * 100) AS PercentPopulationInfected
  FROM PortfolioProject..CovidDeaths
  GROUP BY Location, Population
  ORDER BY PercentPopulationInfected DESC;
  ```

- **Countries with Highest Death Counts:**

  ```sql
  SELECT Location, MAX(CAST(Total_Deaths AS INT)) AS TotalDeathCount
  FROM PortfolioProject..CovidDeaths
  WHERE continent IS NOT NULL
  GROUP BY Location
  ORDER BY TotalDeathCount DESC;
  ```

### Continent-Level Analysis 🌍

- **Continents with Highest Death Counts:**

  ```sql
  SELECT Continent, MAX(CAST(Total_Deaths AS INT)) AS TotalDeathCount
  FROM PortfolioProject..CovidDeaths
  WHERE continent IS NOT NULL
  GROUP BY Continent
  ORDER BY TotalDeathCount DESC;
  ```

### Global Summary 🌎

- **Worldwide COVID-19 Metrics:**

  ```sql
  SELECT SUM(New_Cases) AS Total_Cases, SUM(CAST(New_Deaths AS INT)) AS Total_Deaths,
         (SUM(CAST(New_Deaths AS INT)) / SUM(New_Cases)) * 100 AS DeathPercentage
  FROM PortfolioProject..CovidDeaths
  WHERE continent IS NOT NULL
  ORDER BY 1, 2;
  ```

### Vaccination Analysis 💉

- **Population vs Vaccinations:**

  ```sql
  SELECT Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations,
         SUM(CONVERT(INT, Vac.New_Vaccinations)) OVER (PARTITION BY Dea.Location ORDER BY Dea.Location, Dea.Date) AS RollingPeopleVaccinated
  FROM PortfolioProject..CovidDeaths Dea
  JOIN PortfolioProject..CovidVaccinations Vac
    ON Dea.Location = Vac.Location AND Dea.Date = Vac.Date
  WHERE Dea.Continent IS NOT NULL
  ORDER BY 2, 3;
  ```

### Using CTEs for Calculation 🧮

- **Calculating Percent Population Vaccinated:**

  ```sql
  WITH PopvsVac AS (
      SELECT Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations,
             SUM(CONVERT(INT, Vac.New_Vaccinations)) OVER (PARTITION BY Dea.Location ORDER BY Dea.Location, Dea.Date) AS RollingPeopleVaccinated
      FROM PortfolioProject..CovidDeaths Dea
      JOIN PortfolioProject..CovidVaccinations Vac
        ON Dea.Location = Vac.Location AND Dea.Date = Vac.Date
      WHERE Dea.Continent IS NOT NULL
  )
  SELECT *, (RollingPeopleVaccinated / Population) * 100 AS PercentPopulationVaccinated
  FROM PopvsVac;
  ```

### Using Temporary Tables 📋

- **Creating and Populating Temporary Tables:**

  ```sql
  DROP TABLE IF EXISTS #PercentPopulationVaccinated;
  CREATE TABLE #PercentPopulationVaccinated (
      Continent NVARCHAR(255),
      Location NVARCHAR(255),
      Date DATETIME,
      Population NUMERIC,
      New_Vaccinations NUMERIC,
      RollingPeopleVaccinated NUMERIC
  );

  INSERT INTO #PercentPopulationVaccinated
  SELECT Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations,
         SUM(CONVERT(INT, Vac.New_Vaccinations)) OVER (PARTITION BY Dea.Location ORDER BY Dea.Location, Dea.Date) AS RollingPeopleVaccinated
  FROM PortfolioProject..CovidDeaths Dea
  JOIN PortfolioProject..CovidVaccinations Vac
    ON Dea.Location = Vac.Location AND Dea.Date = Vac.Date;

  SELECT *, (RollingPeopleVaccinated / Population) * 100 AS PercentPopulationVaccinated
  FROM #PercentPopulationVaccinated;
  ```

### Creating a View 👁️

- **Persisting Data for Visualization:**

  ```sql
  CREATE VIEW PercentPopulationVaccinated AS
  SELECT Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations,
         SUM(CONVERT(INT, Vac.New_Vaccinations)) OVER (PARTITION BY Dea.Location ORDER BY Dea.Location, Dea.Date) AS RollingPeopleVaccinated
  FROM PortfolioProject..CovidDeaths Dea
  JOIN PortfolioProject..CovidVaccinations Vac
    ON Dea.Location = Vac.Location AND Dea.Date = Vac.Date
  WHERE Dea.Continent IS NOT NULL;
  ```

---

## Key Skills Demonstrated 🎓

- Advanced Joins
- Common Table Expressions (CTEs)
- Temporary Tables
- Window Functions
- Aggregate Functions
- Creating Views
- Data Type Conversions

---

## Insights Derived 🔍

- Computed death percentages and infection rates across various geographies.
- Conducted comparative analyses of COVID-19 impacts on country and continent scales.
- Identified vaccination coverage relative to population sizes and its trends.

---

## Future Work 🚀

- Leverage the created view for advanced visualizations using tools such as Tableau or Power BI.
- Extend the analysis with predictive modeling or clustering techniques.

---

## Requirements 🖥️

- A SQL environment (e.g., SQL Server).
- Access to the datasets `PortfolioProject..CovidDeaths` and `PortfolioProject..CovidVaccinations`.

---

## Author ✍️

**Vivek**  
A passionate data enthusiast with expertise in Artificial Intelligence and Machine Learning, dedicated to transforming raw data into actionable insights through systematic cleaning and analysis.

