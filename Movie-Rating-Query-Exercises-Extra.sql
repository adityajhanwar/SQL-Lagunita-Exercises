/*
 * Movie-Rating-Query-Exercises-Extra.sql
 * 5/23/19
 * Aditya Jhanwar
 * My solutions for Stanford Lagunita's SQL Database Course, exercise set 
 *  'SQL Movie-Rating Query Exercises: Extra'
 */

-- 1. Find the names of all reviewers who rated Gone with the Wind. 

select distinct name
from Movie join Rating using(mID) join Reviewer using(rID)
where title = 'Gone with the Wind';

-- 2. For any rating where the reviewer is the same as the director of the movie, 
--    return the reviewer name, movie title, and number of stars. 

select name, title, stars
from Movie join Rating using(mID) join Reviewer using(rID)
where name = director;

-- 3. Return all reviewer names and movie names together in a single list, alphabetized.

select title from movie
union
select name from reviewer
order by 1;

-- 4. Find the titles of all movies not reviewed by Chris Jackson. 

select title
from Movie
where mid not in (select mid from Rating join Reviewer 
		using(rID) where name = 'Chris Jackson');

-- 5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, 
--    return the names of both reviewers. Eliminate duplicates, don't pair reviewers with 
--    themselves, and include each pair only once. For each pair, return the names in the 
--    pair in alphabetical order. 

select distinct rev1.name, rev2.name
from rating r1, rating r2, reviewer rev1, reviewer rev2 
where r1.mid = r2.mid and r1.rid = rev1.rid and r2.rid = rev2.rid and rev1.name < rev2.name
order by rev1.name;

-- 6. For each rating that is the lowest (fewest stars) currently in the database, return 
--    the reviewer name, movie title, and number of stars. 

select name, title, stars
from Movie join Rating using(mID) join Reviewer using(rID)
where stars = (select min(stars) from rating);

-- 7. List movie titles and average ratings, from highest-rated to lowest-rated. If two 
--    or more movies have the same average rating, list them in alphabetical order. 

select title, avg(stars)
from movie join rating using(mid)
group by mid
order by avg(stars) desc, title;

-- 8. Find the names of all reviewers who have contributed three or more ratings. 

select name
from reviewer join rating using(rid) 
group by rid
having count(*) >= 3;

-- 9. Some directors directed more than one movie. For all such directors, return the 
--    titles of all movies directed by them, along with the director name. Sort by 
--    director name, then movie title.

select title, director
from movie where director in (select director from movie group by director having count(*) > 1)
order by director, title;

-- 10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating.

select title, avg(stars)
from movie join rating rating using(mid)
group by mid 
having avg(stars) = (select avg(stars)
                    from rating
                    group by mid
                    order by avg(stars) desc
                    limit 1);

-- 11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.

select title, avg(stars)
from movie join rating rating using(mid)
group by mid 
having avg(stars) = (select avg(stars)
                    from rating
                    group by mid
                    order by avg(stars) asc
                    limit 1);

-- 12. For each director, return the director's name together with the title(s) of the movie(s) they 
--     directed that received the highest rating among all of their movies, and the value of that rating. 
--     Ignore movies whose director is NULL. 

select director, title, stars
from movie join rating using(mid)
where director is not null
group by director
having max(stars);

