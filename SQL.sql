---------- Remove Columns which won't be used in data analysis

-- From Deaths Table
ALTER TABLE CovidDeaths
DROP COLUMN new_cases_smoothed, new_deaths_smoothed, new_cases_smoothed_per_million, new_deaths_smoothed_per_million, reproduction_rate, icu_patients, icu_patients_per_million,
hosp_patients, hosp_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million, weekly_hosp_admissions, weekly_hosp_admissions_per_million, total_cases_per_million,
new_cases_per_million, new_deaths_per_million, total_deaths_per_million

-- From Vaccinations Table
ALTER TABLE CovidVaccinations
DROP COLUMN total_tests_per_thousand, new_tests_per_thousand, new_tests_smoothed, new_tests_smoothed_per_thousand, positive_rate, tests_units, total_vaccinations, total_boosters,
new_vaccinations_smoothed, total_vaccinations_per_hundred, people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred, total_boosters_per_hundred, new_vaccinations_smoothed_per_million,
new_people_vaccinated_smoothed, new_people_vaccinated_smoothed_per_hundred, stringency_index, aged_65_older, aged_70_older, extreme_poverty, cardiovasc_death_rate, diabetes_prevalence,
female_smokers, male_smokers, handwashing_facilities, hospital_beds_per_thousand, life_expectancy, human_development_index, excess_mortality_cumulative_absolute, excess_mortality_cumulative,
excess_mortality, excess_mortality_cumulative_per_million

---------- Not Separate Country Values in "Location"

/*
'European Union',
'Europe',
'High income',
'Low income',
'Lower middle income',
'Upper middle income',
'World',
'Oceania',
'Asia',
'North America',
'South America'
*/

---------- Looking for Covid Infections/Deaths Trends


-- Covid Infections by Country

Select location, Max(Total_cases) as 'Total Infections by Country', Max(Total_cases/population)*100 as 'Percentage of Infected By Country According to Country Population'
from CovidDeaths
Where location not in ('European Union',
'Europe',
'High income',
'Low income',
'Lower middle income',
'Upper middle income',
'World',
'Oceania',
'Asia',
'North America',
'South America') 
group by location
order by 'Total Infections by Country' desc


-- Total World Covid Infections and % According to World Population

Select location, Max(Total_cases) as 'Total Infections World', Max(Total_cases/population)*100 as '% of Total Infections World According to Population'
from CovidDeaths
Where location in ('World') 
group by location


-- Total Deaths From Covid By Country and % of Total Deaths According to Their Population

Select location, Max(total_deaths) as 'Total Deaths by Country', Max(total_deaths/population)*100 as 'Percentage of Deaths By Country According to Country Population'
from CovidDeaths
Where location not in ('European Union',
'Europe',
'High income',
'Low income',
'Lower middle income',
'Upper middle income',
'World',
'Oceania',
'Asia',
'North America',
'South America') 
group by location
order by 'Total Deaths by Country' desc


-- Total Death From Covid In World and % Of Total Deaths According To World Population

Select location, Max(total_deaths) as 'Total Deaths World', Max(total_deaths/population)*100 as '% of Total World Deaths According to Population'
from CovidDeaths
Where location in ('World') 
group by location


-- Infected VS Death VS Infected Death

Select location, Max(total_cases) as 'Total of Infected People by Country', Max(total_deaths) as 'Total Deaths by Country', max(total_deaths)/max(total_cases)*100 '% Infected Deaths'
from CovidDeaths
Where location not in ('European Union',
'Europe',
'High income',
'Low income',
'Lower middle income',
'Upper middle income',
'World',
'Oceania',
'Asia',
'North America',
'South America') 
group by location
order by 'Total of Infected People by Country' desc


-- Total Cases VS Total Deaths by Time/Location

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where total_cases IS NOT NULL
order by 1,2


-- Total Cases/Deaths By Continent and % of population and % from Infected

select continent, max(total_cases) as 'Total Cases Count', max(total_deaths) as 'Total Death Count', max(total_deaths)/max(total_cases)*100 as '% of Deaths of Infected People'
from CovidDeaths
where continent IS NOT NULL
group by continent
order by 'Total Cases Count' desc


------------------------------------------------------------------------------

---------- Looking for Vaccination Trends

-- People Vaccinated Vs People Fully Vaccinated By Countries

Select v.location, Max(people_vaccinated) as 'Total Vaccinations', Max(people_vaccinated/population)*100 as '% of Vaccinated',
Max(people_fully_vaccinated) as 'Fully Vaccinated', Max(people_fully_vaccinated/population)*100 as '% of Fully Vaccinated'
from CovidVaccinations V
join CovidDeaths D
on v.location = d.location
Where v.location not in ('European Union',
'Europe',
'High income',
'Low income',
'Lower middle income',
'Upper middle income',
'World',
'Oceania',
'Asia',
'North America',
'South America') 
group by v.location
order by 'Total Vaccinations' desc


-- People Vaccinated Vs People Fully Vaccinated World

Select v.location, Max(people_vaccinated) as 'Total Vaccinations', Max(people_vaccinated/population)*100 as '% of Vaccinated',
Max(people_fully_vaccinated) as 'Fully Vaccinated', Max(people_fully_vaccinated/population)*100 as '% of Fully Vaccinated'
from CovidVaccinations V
join CovidDeaths D
on v.location = d.location
Where v.location in ('World') 
group by v.location

-- People Vaccinated Vs People Fully Vaccinated By Continent

Select v.continent, Max(people_vaccinated) as 'Total Vaccinations', Max(people_vaccinated/population)*100 as '% of Vaccinated',
Max(people_fully_vaccinated) as 'Fully Vaccinated', Max(people_fully_vaccinated/population)*100 as '% of Fully Vaccinated'
from CovidVaccinations V
join CovidDeaths D
on v.location = d.location
Where v.continent IS NOT NULL
group by v.continent

------- Looking At Income Level Reflections


-- How Income Level Reflects On Covid Vaccinations

Select v.location, Max(people_vaccinated) as 'Total Vaccinations', Max(people_vaccinated/population)*100 as '% of Vaccinated',
Max(people_fully_vaccinated) as 'Fully Vaccinated', Max(people_fully_vaccinated/population)*100 as '% of Fully Vaccinated'
from CovidVaccinations V
join CovidDeaths D
on v.location = d.location
Where v.location in ('Low income', 
'Lower middle income',
'Upper middle income',
'High income') 
group by v.location


-- How Income Level Reflects On Covid Infected Deaths

Select v.location, Max(total_deaths) as 'Total Deaths', max(total_deaths)/max(total_cases)*100 'Percent Of Deaths'
from CovidVaccinations V
join CovidDeaths D
on v.location = d.location
Where v.location in ('Low income', 
'Lower middle income',
'Upper middle income',
'High income') 
group by v.location


--------- Creating Views for Future Work with Data

Create View CovidInfectionsByCountry
as
Select location, Max(Total_cases) as 'Total Infections by Country', Max(Total_cases/population)*100 as 'Percentage of Infected By Country According to Country Population'
from CovidDeaths
Where location not in ('European Union',
'Europe',
'High income',
'Low income',
'Lower middle income',
'Upper middle income',
'World',
'Oceania',
'Asia',
'North America',
'South America') 
group by location

--
Create View TotalWWInfectionsAndPercentage
as
Select location, Max(Total_cases) as 'Total Infections World', Max(Total_cases/population)*100 as '% of Total Infections World According to Population'
from CovidDeaths
Where location in ('World') 
group by location

--
Create View TotalDeathsByCountryAndPercentages
as
Select location, Max(total_deaths) as 'Total Deaths by Country', Max(total_deaths/population)*100 as 'Percentage of Deaths By Country According to Country Population'
from CovidDeaths
Where location not in ('European Union',
'Europe',
'High income',
'Low income',
'Lower middle income',
'Upper middle income',
'World',
'Oceania',
'Asia',
'North America',
'South America') 
group by location

--
Create View TotalDeathWorldPercentages
as
Select location, Max(total_deaths) as 'Total Deaths World', Max(total_deaths/population)*100 as '% of Total World Deaths According to Population'
from CovidDeaths
Where location in ('World') 
group by location

--
Create View ViewInfectedVSDeathVSInfectedDeath
as
Select location, Max(total_cases) as 'Total of Infected People by Country', Max(total_deaths) as 'Total Deaths by Country', max(total_deaths)/max(total_cases)*100 '% Infected Deaths'
from CovidDeaths
Where location not in ('European Union',
'Europe',
'High income',
'Low income',
'Lower middle income',
'Upper middle income',
'World',
'Oceania',
'Asia',
'North America',
'South America') 
group by location

--
Create View TotalCasesVSTotalDeathsByTime_Location
as
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where total_cases IS NOT NULL

--
Create View Total_Cases_Deaths_By_Continent_And_PercentOfPopulation_And_PercentInfected
as
select continent, max(total_cases) as 'Total Cases Count', max(total_deaths) as 'Total Death Count', max(total_deaths)/max(total_cases)*100 as '% of Deaths of Infected People'
from CovidDeaths
where continent IS NOT NULL
group by continent

--
Create View PeopleVaccinatedVsPeopleFullyVaccinatedCountries
as
Select v.location, Max(people_vaccinated) as 'Total Vaccinations', Max(people_vaccinated/population)*100 as '% of Vaccinated',
Max(people_fully_vaccinated) as 'Fully Vaccinated', Max(people_fully_vaccinated/population)*100 as '% of Fully Vaccinated'
from CovidVaccinations V
join CovidDeaths D
on v.location = d.location
Where v.location not in ('European Union',
'Europe',
'High income',
'Low income',
'Lower middle income',
'Upper middle income',
'World',
'Oceania',
'Asia',
'North America',
'South America') 
group by v.location

--
Create View ViewPeopleVaccinatedVsPeopleFullyVaccinatedWorld
as
Select v.location, Max(people_vaccinated) as 'Total Vaccinations', Max(people_vaccinated/population)*100 as '% of Vaccinated',
Max(people_fully_vaccinated) as 'Fully Vaccinated', Max(people_fully_vaccinated/population)*100 as '% of Fully Vaccinated'
from CovidVaccinations V
join CovidDeaths D
on v.location = d.location
Where v.location in ('World') 
group by v.location

--
Create View People_VaccinatedVsPeople_Fully_Vaccinated_By_Continent
as
Select v.continent, Max(people_vaccinated) as 'Total Vaccinations', Max(people_vaccinated/population)*100 as '% of Vaccinated',
Max(people_fully_vaccinated) as 'Fully Vaccinated', Max(people_fully_vaccinated/population)*100 as '% of Fully Vaccinated'
from CovidVaccinations V
join CovidDeaths D
on v.location = d.location
Where v.continent IS NOT NULL
group by v.continent

--
Create View HowIncomeLevelReflectsOnCovidVaccinations
as
Select v.location, Max(people_vaccinated) as 'Total Vaccinations', Max(people_vaccinated/population)*100 as '% of Vaccinated',
Max(people_fully_vaccinated) as 'Fully Vaccinated', Max(people_fully_vaccinated/population)*100 as '% of Fully Vaccinated'
from CovidVaccinations V
join CovidDeaths D
on v.location = d.location
Where v.location in ('Low income', 
'Lower middle income',
'Upper middle income',
'High income') 
group by v.location

--
Create View HowIncomeLevelReflectsOnCovidInfectedDeaths
as
Select v.location, Max(total_deaths) as 'Total Deaths', max(total_deaths)/max(total_cases)*100 'Percent Of Deaths'
from CovidVaccinations V
join CovidDeaths D
on v.location = d.location
Where v.location in ('Low income', 
'Lower middle income',
'Upper middle income',
'High income') 
group by v.location
