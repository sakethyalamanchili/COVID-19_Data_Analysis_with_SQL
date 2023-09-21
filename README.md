# COVID-19 Data Exploration

This repository contains SQL queries for exploring COVID-19 data using various SQL skills and techniques. The queries analyze data from the 'CovidDeaths' and 'CovidVaccinations' tables in the 'PortfolioProject' database. Here's a brief overview of the queries and their purposes:

## Queries

1. **Select All Columns and Filter by Continent**
   - Selects all columns from the 'CovidDeaths' table, filtering rows where the 'continent' column is not null, and orders the result set by specific columns.

2. **Select Data to Start With**
   - Selects essential columns like Location, Date, Total Cases, New Cases, Total Deaths, and Population, filtering out rows where the continent is not null and ordering the result.

3. **Total Cases vs Total Deaths (India)**
   - Calculates the death percentage in India by dividing total deaths by total cases, ensuring accurate numeric conversion.

4. **Total Cases vs Population**
   - Calculates the percentage of population infected with COVID-19 for each location and date.

5. **Countries with Highest Infection Rate vs Population**
   - Identifies countries with the highest infection count compared to their population and calculates the percentage of the population infected.

6. **Countries with Highest Death Count per Population**
   - Lists countries with the highest death count per population.

7. **Continents with the Highest Death Count per Population**
   - Lists continents with the highest death count per population.

8. **Global New Cases and Death Percentage**
   - Calculates the number of new cases and the death percentage for each date globally.

9. **Global Total Cases and Deaths**
   - Computes the total global cases, total deaths, and death percentage.

10. **Total Population vs Vaccinations**
    - Calculates the rolling total of people vaccinated for each location and date and presents it alongside other relevant data.

11. **CTE Calculation for Vaccination Percentage**
    - Uses a Common Table Expression (CTE) to calculate the vaccination percentage.

12. **Temp Table Calculation for Vaccination Percentage**
    - Uses a temporary table to calculate the vaccination percentage.

13. **Creating a View for Vaccination Data**
    - Creates a view to store vaccination data for later visualizations.

## How to Use

1. Ensure you have access to the 'PortfolioProject' database with the 'CovidDeaths' and 'CovidVaccinations' tables.

2. Copy and paste the SQL queries into your SQL management tool (e.g., SQL Server Management Studio) and execute them.

3. Explore the results of each query for insights into COVID-19 data.

**Dataset Link**: [COVID-19 Data Source](https://ourworldindata.org/covid-deaths)

## Author

Saketh Yalamanchili

Feel free to modify and adapt these queries to suit your specific needs. If you have any questions or suggestions, please don't hesitate to reach out.
