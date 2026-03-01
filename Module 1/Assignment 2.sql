-- Assingment 2
-- Write 2 structured queries
-- Write 2 semi-structured queries
-- 1 unstructured data query
-- use z_db_instructor1, academic.

-- provide comments about what it should do, and use at least select, from, where, order by. Can use joins too and more but these are optional.
-- Submit as a text or word file.

select *
from students;

-- structured queries

-- 1. 

-- find all students that have completed a personal project

select * 
from students
where personal_projects is not null
order by GPA desc;


-- 2
select *
from classes
where department in ('History', 'Computer Science')
order by MAX_CAPACITY;

-- 3

-- Selecting only the first word from the class name columnm, that meet on tuesday.
SELECT class_id,
class_name,
SPLIT_PART(class_name, ' ', 1) as class_name,
meeting_days
FROM Z_DB_INSTRUCTOR1.ACADEMIC.CLASSES
WHERE ARRAY_CONTAINS('Tue'::VARIANT, meeting_days)
order by class_id DESC;


-- 4

-- Selecting classes that have 2 or more specific pre-requisite clases that meet in person.

select *
from classes
where modality = 'In-Person' and array_size(prerequisites)>1
order by class_id desc;

-- 5
-- Seeing how 'close' students majors are to their personal statements (in a rudeimentary fasion)

select student_id,
first_name,
last_name,
gpa,
STUDENT_PROFILE,
STUDENT_PROFILE['major'],
ai_similarity(
STUDENT_PROFILE['major'],
personal_statement

) as simlarity_score
from students
where personal_statement is not null
order by simlarity_score desc;