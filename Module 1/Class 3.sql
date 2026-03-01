
--use database z_db_instructor1;
--use schema academic;

--show tables;

describe table classes;


SELECT * 
FROM classes 
WHERE max_capacity > 30
order by max_capacity desc;


select class_id,
    syllabus:textbook::string as textbook,
    syllabus:readings::array as readings,
    readings[0]::string as readings
from classes;


select student_id,
student_profile,
f.*
from students,
    lateral flatten(input => student_profile) f;
