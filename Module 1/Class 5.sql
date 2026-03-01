-- Activty part 1

-- select all students who have expressed an interest in or done research?

select * 
from students
where ai_filter(
prompt('Does this statment express interest in conducting research or infer they have experience in research? : {0}', personal_statement)
);

