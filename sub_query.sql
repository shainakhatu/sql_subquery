



use sub_query;
select * from movies;
--  --

-- find the movies with highest profit(vs order by)?

select * from movies
where (gross- budget) = (select max(gross- budget)from movies);

select * from movies 
order by (gross - budget) desc limit 1;

-- Find how many movies have a rating > the avg of all the movie ratings(Find the count of above average movies) --

select count(*) from movies
where score > (select avg(score) from movies);

-- Find the highest rated movie of 2000--
select * from movies
where year = 2000 and score =(select max(score)from movies
                                 where year = 2000);
-- Find the highest rated movie among all movies whose number of votes are >the dataset avg votes --


select * from movies
where score =(select max(score) from movies
where votes > (select avg(votes)from movies));

-- Find all the movies made by top 3 directors(in terms of total gross income) --

with top_director as (select director from movies
				       group by director order by sum(gross)
                         desc limit 3)
select * from movies 
where director in (select * from top_director);                 

-- Find all movies of all those actors whose filmography's avg rating > 8.5(take25000 votes as cutoff) --

select * from movies
where star in  (select star from movies
				where votes >25000
				group by star
				order by avg(score) > 8.5);

-- Find the most profitable movie of each year --
select * from movies
where (year,gross - budget) in (select year,max(gross - budget)
                                        from movies
                                         group by year);
										
-- Find the highest rated movie of each genre votes cutoff of 25000 --
select * from movies
where (genre,score) in (select genre,max(score)from movies
                           where votes > 25000
                           group by genre)
and votes > 25000;

-- Find the highest grossing movies of top 5 actor/director combo in terms of total gross income --

with top_duos as(select star,director,max(gross)
from movies
group by 1,2
order by sum(gross) desc limit 5
)
select * from movies
where (star,director,gross) in (select * from top_duos);

-- Find all the movies that have a rating higher than the average rating of movies in the same genre--


select * from movies m1
where score > (select avg(score)from movies m2 where m2.genre = m1.genre);

-- Get the percentage of votes for each movie compared to the total number of votes --


select name,(votes/(select sum(votes) from movies))*100 as total_votes from movies;

-- Display all movie names ,genre, score and avg(score) of genre --

select name,genre,score,(select avg(genre) from movies m2 where m2.genre = m1.genre) from movies m1








