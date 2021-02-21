/*
 * Movie-Rating-Query-Exercises.sql
 * 2/20/21
 * Aditya Jhanwar
 * My solutions for Stanford Lagunita's SQL Database Course, exercise set
 *    'SQL Movie-Rating Query Exercises'
 */

-- 1. Find the titles of all movies directed by Steven Spielberg.

select title
from movie
where director = 'Steven Spielberg';

-- 2. Find all years that have a movie that received a rating of 4 or 5,
--    and sort them in increasing order.

select distinct year
from movie join rating using(mID)
where stars >= 4
order by year asc;

-- 3. Find the titles of all movies that have no ratings.

-- Using subquery:
select title
from movie
where mid not in (select mid from rating);

-- Using join:
select title
from Movie left join Rating using(mID)
where rID is null;

-- 4. Some reviewers didn't provide a date with their rating. Find the names
--    of all reviewers who have ratings with a NULL value for the date.

select name
from Rating join Reviewer using(rID)
where ratingDate is null;

-- 5. Write a query to return the ratings data in a more readable format:
--    reviewer name, movie title, stars, and ratingDate.
--    Also, sort the data, first by reviewer name, then by movie title,
--    and lastly by number of stars.

select name, title, stars, ratingdate
from movie join rating using(mid) join reviewer using(rid)
order by name, title, stars;

-- 6. For all cases where the same reviewer rated the same movie twice and
--    gave it a higher rating the second time, return the reviewer's name and
--    the title of the movie.

select r.name, title
from Rating r1
	join Rating r2 on r1.mID = r2.mID
	join Movie m on r1.mID = m.mID
	join Reviewer r on r1.rID = r.rID
where r1.rID = r2.rID and r2.stars > r1.stars and r2.ratingDate > r1.ratingDate;

-- 7. For each movie that has at least one rating, find the highest number of
--    stars that movie received. Return the movie title and number of stars.
--    Sort by movie title.

select title, max(stars)
from movie join rating using(mid)
group by mid
order by title;

-- 8. For each movie, return the title and the 'rating spread', that is, the
--    difference between highest and lowest ratings given to that movie.
--    Sort by rating spread from highest to lowest, then by movie title.

select title, max(stars) - min(stars) as 'rating_spread'
from movie join rating using(mid)
group by title
order by rating_spread desc, title;

-- 9. Find the difference between the average rating of movies released before
--    1980 and the average rating of movies released after 1980.
--    (Make sure to calculate the average rating for each movie, then the
--    average of those averages for movies before 1980 and movies after.
--    Don't just calculate the overall average rating before and after 1980.)

select avg(before.avgEach) - avg(after.avgEach) as 'difference'
from (select avg(stars) avgEach
		from Rating join Movie using(mID)
		where year < 1980
		group by mID) before,
	 (select avg(stars) avgEach
		from Rating join Movie using(mID)
		where year > 1980
		group by mID) after;
