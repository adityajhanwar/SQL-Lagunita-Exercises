/*
 * Movie-Rating-Query-Exercises.sql
 * 5/23/19
 * Aditya Jhanwar
 * My solutions for Stanford Lagunita's SQL Database Course, exercise set 'SQL Movie-Rating Query Exercises'
 */

-- 1. Find the titles of all movies directed by Steven Spielberg. 

select title
from movie
where director = 'Steven Spielberg';

-- 2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 

select distinct year
from movie join rating using(mID)
where stars >= 4
order by year;

-- 3. Find the titles of all movies that have no ratings. 

select title
from movie
where mid not in (select mid from rating);

-- 4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 

select name
from reviewer join rating using(rid)
where ratingdate is null;

-- 5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 

select name, title, stars, ratingdate
from movie join rating using(mid) join reviewer using(rid)
order by name, title, stars;

-- 6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 

-- Using join:

select name, title
from reviewer join
(select *
from rating a join rating b using(rid)
where a.mid = b.mid and a.stars < b.stars and a.ratingdate < b.ratingdate) twice
using(rid) join movie using(mid);

-- Using correlated subquery:

select name, title
from reviewer join
(select * from rating r1 where exists(select * from rating r2 where r1.rid = r2.rid and r1.mid = r2.mid and r1.stars < r2.stars and r1.ratingdate < r2.ratingdate)) twice
using(rid) join movie using(mid);

-- 7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 

select title, max(stars)
from movie join rating using(mid)
group by mid
order by title;

-- 8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 

select title, max(stars)-min(stars) as 'rating_spread'
from movie join rating using(mid)
group by title
order by rating_spread desc, title;

-- 9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 

select
(select avg(avg_stars) as avg_before
from (select title, avg(stars) as avg_stars
      from movie join rating using(mid)
      where year < 1980
      group by mid) before)
-
(select avg(avg_stars) as avg_after
from (select title, avg(stars) as avg_stars
      from movie join rating using(mid)
      where year > 1980
      group by mid) after)

