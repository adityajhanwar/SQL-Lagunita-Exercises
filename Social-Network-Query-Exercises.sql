/*
 * Social-Network-Query-Exercises.sql
 * 9/16/19
 * Aditya Jhanwar
 * My solutions for Stanford Lagunita's SQL Database Course, exercise set 'SQL Social-Network Query Exercises'
 */

-- 1. Find the names of all students who are friends with someone named Gabriel. 

-- Using join:
select h1.name
from Friend 
    join Highschooler h1 on h1.ID = ID1 
    join Highschooler h2 on h2.ID = ID2
where h2.name = 'Gabriel';

-- Using subquery:
select name
from Friend join Highschooler on ID = ID1 
where ID2 in (select ID from Highschooler where name = 'Gabriel');

-- 2. For every student who likes someone 2 or more grades younger than themselves, 
--    return that student's name and grade, and the name and grade of the student they like. 

select h1.name, h1.grade, h2.name, h2.grade
from Likes
    join Highschooler h1 on ID1 = h1.ID
    join Highschooler h2 on ID2 = h2.ID
where h1.grade - h2.grade >= 2;

-- 3. For every pair of students who both like each other, return the name and grade of both 
--    students. Include each pair only once, with the two names in alphabetical order. 

-- Using uncorrelated subquery:
select h1.name, h1.grade, h2.name, h2.grade
from Likes l
    join Highschooler h1 on l.ID1 = h1.ID
    join Highschooler h2 on l.ID2 = h2.ID
where (ID1, ID2) in (select ID2, ID1 from Likes) and
    h1.name < h2.name;

-- Using correlated subquery:
select h1.name, h1.grade, h2.name, h2.grade
from Likes l
    join Highschooler h1 on l.ID1 = h1.ID
    join Highschooler h2 on l.ID2 = h2.ID
where exists (select * from Likes where l.ID1 = ID2 and l.ID2 = ID1) and
    h1.name < h2.name;
	
-- Using join:
select h1.name, h1.grade, h2.name, h2.grade
from Likes l1, Likes l2, Highschooler h1, Highschooler h2
where (l1.ID1 = h1.ID and l1.ID2 = h2.ID) and
    (l2.ID1 = h2.ID and l2.ID2 = h1.ID) and
    h1.name < h2.name;
	
-- 4. Find all students who do not appear in the Likes table (as a student who likes or is 
--    liked) and return their names and grades. Sort by grade, then by name within each grade. 

select name, grade
from Highschooler
where ID not in (select ID1 from Likes union select ID2 from Likes)
order by grade asc, name asc;

-- 5. For every situation where student A likes student B, but we have no information about 
--    whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and 
--    B's names and grades. 

-- Using join:
select h1.name, h1.grade, h2.name, h2.grade
from Likes l1 
    left join Likes l2 on l1.ID2 = l2.ID1
    join Highschooler h1 on l1.ID1 = h1.ID
    join highschooler h2 on l1.ID2 = h2.ID
where l2.ID2 is null;

-- Using subquery:
select h1.name, h1.grade, h2.name, h2.grade
from Likes
    join Highschooler h1 on ID1 = h1.ID
    join highschooler h2 on ID2 = h2.ID
where ID2 not in (select ID1 from Likes);

-- 6. Find names and grades of students who only have friends in the same grade. Return the 
--    result sorted by grade, then by name within each grade. 

select h1.name, h1.grade
from Friend
    join Highschooler h1 on h1.ID = ID1
    join Highschooler h2 on h2.ID = ID2
group by ID1
having min(h2.grade) = max(h2.grade)
order by h1.grade, h1.name;

-- 7. For each student A who likes a student B where the two are not friends, find if they 
--    have a friend C in common (who can introduce them!). For all such trios, return the 
--    name and grade of A, B, and C. 

...

-- 8. Find the difference between the number of students in the school and the number of 
--    different first names. 

select count(*) - count(distinct name) as 'difference'
from Highschooler;

-- 9. Find the name and grade of all students who are liked by more than one other student. 

-- Using aggregation:
select name, grade
from Highschooler 
    join Likes on ID = ID2
group by ID2
having count(ID1) > 1;

-- Without using aggregation:
select distinct name, grade
from Likes a 
    join Likes b on a.ID2 = b.ID2
    join Highschooler on a.ID2 = ID
where a.ID1 < b.ID1
