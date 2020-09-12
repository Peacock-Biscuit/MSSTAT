-- testQuery2: Display the title, year produced, rating and duration for each movie 
-- that is at least one hour long, but no more than two hours long.
create or replace view testQuery2 as
SELECT title, produced, rating, duration FROM movies WHERE duration BETWEEN 60 AND 120;

-- testQuery6: Display the title, year produced, rating
--  and duration for each PG-13 movie that was produced after the year 2004.
create or replace view testQuery6 as
SELECT title, produced, rating, duration FROM movies WHERE rating="PG-13" AND produced>2004;

-- testQuery18: Display the number of movies included in each distinct rating category, along with the shortest 
-- and longest durations for the movies in that category.
create or replace view testQuery18 as
SELECT rating, COUNT(*), MIN(duration), MAX(duration) FROM movies GROUP BY rating;
-- testQuery33: Display a unique list of the first and last names of of any account holders
--  where their first name contains the letter 'a', but doesn't have an 'a' as the last letter.
create or replace view testQuery33 as
SELECT DISTINCT(fname), lname FROM viewers WHERE fname LIKE "%a%" AND fname NOT LIKE "%a";
-- testQuery11: Display the title, year produced, rating, duration and release date for each R-rated movie released in January.
create or replace view testQuery11 as
SELECT title, produced, rating, duration, released FROM movies WHERE rating="R" AND released LIKE "%-01-%";
-- testQuery35: Display the service, minimum and maximum account sizes, and the cumulative size
-- for each service that has (or might have) more than 100 bonus credits.
create or replace view testQuery35 as
SELECT service, MIN(account_size) AS "minimum_size", MAX(account_size) AS "maximum_size", SUM(account_size) AS "cumulative_size" FROM viewers WHERE bonus_credits > 100 GROUP BY service;
-- testQuery42: Display number of services, along with the total number of employees
--  and viewers for all services that aren't headquartered in the state of California.
create or replace view testQuery42 as
SELECT COUNT(*) AS number_services, SUM(employees) AS "total_employees", SUM(viewers) AS "total_viewers" FROM services WHERE headquarters NOT LIKE "%California%";
-- testQuery39: Display the number of movies produced by each company for rating category,
--  where they've produced at least two movies in that category.
create or replace view testQuery39 as
SELECT company, rating, COUNT(rating) AS "movies_produced" FROM movies GROUP BY company, rating HAVING COUNT(rating)>=2;
-- testQuery27: Display the first and last names, service, bonus credits and parental limit status for each account 
-- that has parental limits set and doesn't have (or might not have) at least 500 bonus credits.
create or replace view testQuery27 as
SELECT fname, lname, service, bonus_credits, parental_limit FROM viewers WHERE parental_limit="yes" AND bonus_credits<500;