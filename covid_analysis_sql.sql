create database CapstoneProject;
use CapstoneProject;
show databases;


show tables;

#death percentage of total population of a country
select location, max(cast(total_deaths as unsigned))/(population) as total_deaths_location_perc from covid_data group by location order by total_deaths_location_perc desc;

select location,population from covid_data limit 4;
#all data
select * from covid_data group by continent, location order by total_deaths;

#counting total locations/countries
select count(distinct(location)) from covid_data where continent != "";

#counting total null values in continent
select count(*) from covid_data where continent != "";

#percentage of deaths out of total infected patients per country
select location,max(total_deaths)/max(total_cases) as death_perc_infected from covid_data group by location order by death_perc_infected;

#country which has the highest deaths
select location, max(cast(total_deaths as unsigned))/max(total_cases) as total_death_count from covid_data where total_cases!=0 group by location order by total_death_count desc;

#total deaths per continent
select continent, max(cast(total_deaths as unsigned)) as total_deaths_count from covid_data
where continent != ""
group by continent
order by total_deaths_count desc;

select location, max(cast(total_deaths as unsigned)) as death_count from covid_data
where continent = ''
group by location
order by death_count desc;

select continent, max(cast(total_deaths as unsigned)) as death_count from covid_data
where continent != ''
group by continent
order by death_count desc;

select date, sum(new_cases) from covid_data
where continent != ''
group by date
order by 1,2;

select date, sum(new_cases) as new_case, sum(new_deaths) as new_death,
sum(new_deaths)/sum(new_cases)*100 as death_perc_new from covid_data
where continent != ""
group by date
order by 1,3;

select sum(new_cases), sum(new_deaths) as new_death, sum(new_deaths)/sum(new_cases)*100 from covid_data
where continent != '';

select * from covid_data limit 2;


select continent,sum(population),sum(people_vaccinated), sum(people_fully_vaccinated), sum(new_vaccinations) from covid_data
where continent != ''
group by continent;

select location, new_vaccinations, sum(new_vaccinations) over (partition by location)
from covid_data
where continent != '';

select location, population, max(people_vaccinated) as partially_vaccinated, max(people_fully_vaccinated) as fully_vaccinated,
max(people_vaccinated)/population*100 as partially_vacccinated_perc,max(people_fully_vaccinated)/population*100 as fully_vacccinated_perc from covid_data
where continent != ''
group by location
order by population desc;

drop table if exists population_vaccinated;
create table population_vaccinated
(
	continent varchar(255),
    location varchar(255),
	date datetime,
    population numeric,
    new_vaccinations varchar(255)
);

insert into population_vaccinated
select continent, location, date, population, new_vaccinations
from covid_data
where continent != '';

select distinct(new_vaccinations), location from population_vaccinated;

select location, population, max(total_cases) as total_infected, max(total_cases/population)*100 as infected_population_perc
from covid_data
where continent != ''
group by location, population
order by infected_population_perc;

select location, population,date, max(total_cases) over (partition by location) as total_infected, max((total_cases/population))*100 as infected_perc
from covid_data
group by location,population,date
order by infected_perc desc;
