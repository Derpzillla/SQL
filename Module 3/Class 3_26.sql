-- Actibity part 1a: arrays

select *
from information_schema.columns
where table_name ilike 'openalex%' and
      data_type = 'ARRAY'
order by table_name, ordinal_position;

select *
from information_schema.views
where table_name ilike 'openalex%';

-- Activity part 1b
-- Pick one of the array columns in openalex and extract the first element

select openalex_work_id,
       work_title,
       openalex_concept_details,
       openalex_concept_details[0] as first_concept
from openalex_works_index
limit 5;


-- Activity Part 1c
-- Pick one of the array columns and return the number of elements in that array
select openalex_author_id,
       author_name,
       openalex_concept_ids,
       array_size(openalex_concept_ids) as num_of_concepts
from openalex_authors_index
order by num_of_concepts desc
limit 5;

-- Activity Part 1d
-- Pick one of the array columns and return the elements one per row
select *
from openalex_authors_index,
     lateral flatten(input => openalex_concept_ids)
where openalex_author_id = 'https://openalex.org/A5051835435';


-- Activity Part 2a: JSON
-- Find all of the VARIANT columns in the OpenAlex tables
select *
from information_schema.columns
where table_name ilike 'openalex%' and
      data_type = 'VARIANT'
order by table_name, ordinal_position;

-- Activity Part 2b
-- Using dot notation, extract the value of one JSON key from one variant column
select openalex_author_id,
       author_name,
       summary_stats:"2yr_cited_by_count"
from openalex_authors_index
limit 5;

-- Actibity part 2c

select openalex_institution_id,
       institution_name,
       works_counts_by_year,
       f.value:year as year,
       f.value:works_count as works_count
from openalex_institutions_index,
     lateral flatten(input => works_counts_by_year) f
where openalex_institution_id = 'https://openalex.org/I4403386476'
order by year;