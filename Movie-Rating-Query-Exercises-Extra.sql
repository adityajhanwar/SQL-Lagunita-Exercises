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






