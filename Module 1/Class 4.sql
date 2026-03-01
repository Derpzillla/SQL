
-- Jan 29th 
--activity 1
-- which classes do not have a textbook?

--describe table classes;

select *
from classes;

select class_id,
class_code,
class_name,
syllabus,
syllabus:textbook::string as textbook
from classes
where textbook is null;

-- Activity part 2: Summarize

select class_id,
class_name,
class_code,
learning_outcomes
from classes,
where learning_outcomes is not null;

select ai_summarize_agg(DESCRIPTION)
from classes
where DESCRIPTION is not null;

-- Part 3 AI_filter

select class_id,
class_code,
class_name,
learning_outcomes
from classes
where ai_filter(
    prompt('This learning outcome is related to math: {0}', learning_outcomes)
);

-- 4

select class_id,
class_code,
class_name,
learning_outcomes,
ai_classify(
learning_outcomes,
['math','physics','compu-ter science'],
{'output_mode':'multi'}

) as category
from classes
where learning_outcomes is not null;

-- 5 ai similarity
select class_id,
class_code,
class_name,
learning_outcomes,
ai_similarity(
'Students will write readable, tested programs; explain algorithmic trad-offs; and communicate results effectively to non-technical peers.',
learning_outcomes

) as simlarity_score
from classes
where learning_outcomes is not null
order by simlarity_score desc;
