/*
 * Social-Network-Query-Exercises.sql
 * 5/23/19
 * Aditya Jhanwar
 * My solutions for Stanford Lagunita's SQL Database Course, exercise set 'SQL Social-Network Query Exercises'
 */

-- 1. Find the names of all students who are friends with someone named Gabriel. 

select h2.name
from friend join highschooler h1 on h1.id = id1 join highschooler h2 on h2.id = id2
where h1.name = 'Gabriel';

-- 2. For every student who likes someone 2 or more grades younger than themselves, 
--    return that student's name and grade, and the name and grade of the student they like. 

select h1.name, h1.grade, h2.name, h2.grade
from likes join highschooler h1 on h1.id = id1 join highschooler h2 on h2.id = id2
where h1.grade - h2.grade >= 2;

-- 3. For every pair of students who both like each other, return the name and grade of both 
--    students. Include each pair only once, with the two names in alphabetical order. 

select h1.name, h1.grade, h2.name, h2.grade
from (select * 
	from likes a 
	where exists (select * from likes b where a.id1 = b.id2 and a.id2 = b.id1)) both_like
join highschooler h1 on h1.id = id1 join highschooler h2 on h2.id = id2
where h1.name < h2.name
order by h1.name, h2.name;

-- 4. Find all students who do not appear in the Likes table (as a student who likes or is 
--    liked) and return their names and grades. Sort by grade, then by name within each grade. 

select name, grade
from highschooler
where id not in (select distinct id1 from likes union select distinct id2 from likes)
order by grade, name;


-- 5. For every situation where student A likes student B, but we have no information about 
--    whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and 
--    B's names and grades. 

-- using join
select h1.name, h1.grade, h2.name, h2.grade
from likes join highschooler h1 on h1.id = id1 join highschooler h2 on h2.id = id2
where h2.id not in (select distinct id1 from likes);

-- using subquery
select h1.name, h1.grade, h2.name, h2.grade
from (select * from likes where id2 not in (select id1 from likes)) no_like_back
    join highschooler h1 on h1.id = id1 join highschooler h2 on h2.id = id2;

-- NOTE: Both have equivalent results in performance

-- 6. 


















