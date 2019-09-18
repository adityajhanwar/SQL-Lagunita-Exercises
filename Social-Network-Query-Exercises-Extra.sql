/*
 * Social-Network-Query-Exercises-Extra.sql
 * 9/18/19
 * Aditya Jhanwar
 * My solutions for Stanford Lagunita's SQL Database Course, exercise set 'SQL Social-Network Query Extra Exercises'
 */

-- 1. For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.

select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from Likes l1, Likes l2, Highschooler h1, Highschooler h2, Highschooler h3
where (l1.ID2 = l2.ID1 and l1.ID1 != l2.ID2) and
    l1.ID1 = h1.ID and
    l1.ID2 = h2.ID and
    l2.ID2 = h3.ID;

-- 2. Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades.
 
-- Using 'group by':
select h1.name, h1.grade
from Friend, Highschooler h1, Highschooler h2
where ID1 = h1.ID and
    ID2 = h2.ID
group by ID1, h1.grade
having sum(h2.grade = h1.grade) = 0;

-- Without using 'group by':
select h1.name, h1.grade
from Highschooler h1
where grade not in (select grade
                    from Friend, Highschooler
                    where ID2 = ID and ID1 = h1.ID);

-- 3. What is the average number of friends per student? (Your result should be just one number.)
 
...

-- 4. Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.

...

-- 5. Find the name and grade of the student(s) with the greatest number of friends.

...