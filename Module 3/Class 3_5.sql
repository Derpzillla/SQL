
-- Activity part1

select*
from openalex_works_index
where array_size(openalex_author_ids) >1
limit 10;

select *
from openalex_authors_index
limit 5;
--where openalez_author_id = 'https://openalezxx.org/A5028350682'

-- get col names and types for a specific dataset
select table_name, column_name, data_type
from information_schema.columns
where table_name = 'OPENALEX_AUTHORS_INDEX'
order by table_name, ordinal_position;