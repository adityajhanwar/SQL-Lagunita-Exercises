/*
 * Movie-Rating-Query-Exercises-Extra.sql
 * 5/23/19
 * Aditya Jhanwar
 * My solutions for Stanford Lagunita's SQL Database Course, exercise set 
 *  'SQL Movie-Rating Query Exercises: Extra'
 */

-- 1. Find the names of all reviewers who rated Gone with the Wind. 

-- Using join:
select distinct name
from Movie join Rating using(mID) join Reviewer using(rID)
where title = 'Gone with the Wind';

-- Using subquery:
select distinct name
from Reviewer join Rating using(rID)
where mID = (select mID from Movie where title = 'Gone with the Wind');

-- 2. For any rating where the reviewer is the same as the director of the movie, 
--    return the reviewer name, movie title, and number of stars. 

select director, title, stars
from Movie join Rating using(mID) join Reviewer using(rID)
where director = name;

-- 3. Return all reviewer names and movie names together in a single list, alphabetized.

select title from Movie 
union
select name from Reviewer
order by 1 asc;
 
-- 4. Find the titles of all movies not reviewed by Chris Jackson. 
select title
from Movie
where mID not in (select mID from Rating join Reviewer using(rID) where name = 'Chris Jackson');
 
 -- 5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, 
--    return the names of both reviewers. Eliminate duplicates, don't pair reviewers with 
--    themselves, and include each pair only once. For each pair, return the names in the 
--    pair in alphabetical order.

select distinct rev1.name, rev2.name
from Rating r1, Reviewer rev1, Rating r2, Reviewer rev2
where r1.rID = rev1.rID and 
    r2.rID = rev2.rID and
    r1.mID = r2.mID and
    rev1.name < rev2.name;
 
 -- 6. For each rating that is the lowest (fewest stars) currently in the database, return 
--    the reviewer name, movie title, and number of stars. 

select name, title, stars
from Movie join Rating using(mID) join Reviewer using(rID)
where stars = (select min(stars) from Rating);

-- 7. List movie titles and average ratings, from highest-rated to lowest-rated. If two 
--    or more movies have the same average rating, list them in alphabetical order. 

select title, avg(stars) as 'avg_stars'
from Movie join Rating using(mID)
group by mID, title
order by avg_stars desc, title asc;

-- 8. Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)

-- Using 'group by' and 'having'
select name
from Reviewer join Rating using(rID)
group by rID, name
having count(*) >= 3;

-- Without using 'group by' and 'having'
select distinct name
from Rating a join Rating b using(rID) join Rating c using(rID) join Reviewer using(rID)
where (a.ratingDate != b.ratingDate or a.mID != b.mID or a.stars != b.stars) and 
      (b.ratingDate != c.ratingDate or b.mID != c.mID or b.stars != c.stars) and
      (a.ratingDate != c.ratingDate or a.mID != c.mID or a.stars != c.stars);

-- 9. Some directors directed more than one movie. For all such directors, return the 
--    titles of all movies directed by them, along with the director name. Sort by 
--    director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)

-- Using 'count':
select title, director
from Movie
where director in (select director from Movie group by director having count(*) > 1)
order by director, title;

-- Without using 'count':
select title, director
from Movie
where director in (select m1.director from Movie m1 join Movie m2 using(director) where m1.title != m2.title)
order by director, title;

-- 10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating.

select title, avg(stars)
from Movie join Rating using(mID)
group by mID, title
having avg(stars) = (select avg(stars)
                    from Rating
                    group by mID
                    order by 1 desc
                    limit 1)

-- 11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.

select title, avg(stars)
from Movie join Rating using(mID)
group by mID, title
having avg(stars) = (select avg(stars)
                    from Rating
                    group by mID
                    order by 1 asc
                    limit 1);
					
-- 12. For each director, return the director's name together with the title(s) of the movie(s) they 
--     directed that received the highest rating among all of their movies, and the value of that rating. 
--     Ignore movies whose director is NULL. 					

select distinct director, title, stars
from (Movie join Rating using(mID)) a
where exists (select *
              from (Movie join Rating using(mID)) b
              where director is not NULL 
              group by director
              having max(stars) = a.stars and
              director = a.director)					