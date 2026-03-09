-- Activity part 1

show tables; 
show views;

select *
from information_schema.views;

select * 
from openalex_authors_index
limit 5;

select count(*)
from openalex_authors_index;
select * from openalex_works_index
limit 5;

select * 
from openalex_works_index sample(0.0001);

-- Activity part 2
select * 
from openalex_works_index
where openalex_work_id = 'https://openalex.org/W3124166904';

-- Activity part 3
select * 
from information_schema.views
where table_name ilike 'openalex%';

describe view openalex_works_index;

select *
from information_schema.columns
where table_name ilike 'openalex%'
order by table_name, ordinal_position;

select *
from information_schema.columns
where table_name ilike 'openalex%' and
data_type in ('ARRAY', 'VARIANT')
order by table_name, ordinal_position;

select openalex_author_id,
author_name,
ALTERNATIVE_AUTHOR_NAMES
OPENALEX_CONCEPT_IDS,
OPENALEX_CONCEPT_DETAILS,
WORKS_COUNTS_BY_YEAR,
SUMMARY_STATS
from openalex_authors_index
limit 5;