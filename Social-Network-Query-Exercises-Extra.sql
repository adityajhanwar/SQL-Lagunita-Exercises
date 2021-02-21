/*
 * Social-Network-Query-Exercises-Extra.sql
 * 2/20/21
 * Aditya Jhanwar
 * My solutions for Stanford Lagunita's SQL Database Course, exercise set
 *    'SQL Social-Network Query Extra Exercises'
 */

-- 1. For every situation where student A likes student B, but student B likes
--    a different student C, return the names and grades of A, B, and C.

select a.name, a.grade, b.name, b.grade, c.name, c.grade
from Likes a_b, Likes b_c, Highschooler a, Highschooler b, Highschooler c
where a_b.ID2 = b_c.ID1 and
	b_c.ID2 != a_b.ID1 and
	a.ID = a_b.ID1 and
	b.ID = a_b.ID2 and
	c.ID = b_c.ID2;

-- 2. Find those students for whom all of their friends are in different grades
--    from themselves. Return the students' names and grades.

-- In other words, don't select students who have at least one friend in the
--    same grade as themselves.

select name, grade
from Highschooler
where ID not in (
	select ID1
	from Friend, Highschooler a, Highschooler b
  	where ID1 = a.ID and
	      ID2 = b.ID and
              a.grade = b.grade);

-- 3. What is the average number of friends per student? (Your result should be
--    just one number.)

select avg(num_friends) as avg_friends_per_student from (
	select count(ID2) as num_friends
	from Friend
	group by ID1) as friends_count;

-- 4. Find the number of students who are either friends with Cassandra or are
--    friends of friends of Cassandra. Do not count Cassandra, even though
--    technically she is a friend of a friend.

-- In other words, we want to find the number of students who are either
--    friends with Cassandra or are UNIQUE friends of friends of Cassandra
--    (excluding Cassandra herself).
-- For example, Max and Lucy are both friends of Cassandra but Max is also
--    friends with Lucy. Max and Cassandra should not be counted again.

select num_friends.num + num_friends_friends.num
from
(select count(ID1) as num
 from Friend
 where ID2 = (select ID
              from Highschooler
	      where name = 'Cassandra')) as num_friends,
(select count(ID2) as num
 from Friend
 where ID1 in (select ID1
   	       from Friend
   	       where ID2 = (select ID
                	    from Highschooler
	        	    where name = 'Cassandra')) and
        ID2 != (select ID
                from Highschooler
                where name = 'Cassandra')) as num_friends_friends;

-- 5. Find the name and grade of the student(s) with the greatest
--    number of friends.

select name, grade
from Friend, highschooler
where ID = ID1
group by ID
having count(ID2) = (select max(num_friends) from (
		     select count(ID2) as num_friends
		     from Friend
		     group by ID1) as friends_count);

