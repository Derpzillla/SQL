
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
select table_catalog,table_name, column_name, data_type
from information_schema.columns
where table_name = 'OPENALEX_AUTHORS_INDEX'
order by table_name, ordinal_position;

-- Activity part 1:
select table_name,
column_name,
ordinal_position,
data_type
from information_schema.columns
where table_name = 'OPENALEX_SOURCES_INDEX' and
data_type = 'ARRAY'
order by ordinal_position;


-- Activity part 2

select openalex_source_id,
source_name,
works_counts_by_year
from openalex_sources_index
where source_name in ( 'MIS Quarterly', 'Information Systems Research')
limit 5;

-- swap db to z_db_instructor1 module3
select *,
works_counts_by_year_array[0] as works_counts_2025,
array_slice(works_counts_by_year_array,0,3) as most_recent_3yr
from v_works_counts_is_journals;


-- Activity part 3
select source_name, array_agg(f.value)
from v_works_counts_is_journals v,
lateral flatten(input => works_counts_by_year_array) f
where f.values > 100
group by source_name;

select *
from v_works_counts_is_journals v,
lateral flatten(input => works_counts_by_year_array) f
where f.values > 100;

select *
filter(works_counts_by_year_array, x ->x > 100)
from v_works_counts_is_journals;

select *
filter(works_counts_by_year_array, a->a >100) as years_wiht_more_100,
array_size(years_wiht_more_100) as num_years_more_100
from v_works_counts_is_journals;

select *,
reduce(works_counts_by_year_array,0, (acc,val) ->acc+ val) as total_works_counts
from v_works_counts_is_journals
order by total_works_counts desc;
-- as percentages of total
select *,
reduce(works_counts_by_year_array,0, (acc,val) ->acc+ val) as total_works_counts,
transform(works_counts_by_year_array, x -> round(x / total_works_counts)::number(10,2)) as total_works_percent
from v_works_counts_is_journals
order by total_works_counts desc;

select *
from openalex_works_index
limit 100;

select *
from openalex_authors_index
limit 100;

select *
from openalex_concepts_index
limit 100;

select *
from openalex_funders_index
limit 100;



SELECT 
  'snowflake' AS dbms,
  c.TABLE_CATALOG,
  c.TABLE_SCHEMA,
  c.TABLE_NAME,
  c.COLUMN_NAME,
  c.ORDINAL_POSITION,
  CASE 
    WHEN c.DATA_TYPE ILIKE 'NUMBER' 
    THEN 'NUMBER(' || c.NUMERIC_PRECISION || ',' || c.NUMERIC_SCALE || ')' 
    ELSE UPPER(c.DATA_TYPE)
  END AS DATA_TYPE,
  c.CHARACTER_MAXIMUM_LENGTH,
  NULL AS CONSTRAINT_TYPE,
  NULL AS REFERENCED_TABLE_SCHEMA,
  NULL AS REFERENCED_TABLE_NAME,
  NULL AS REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS c
INNER JOIN INFORMATION_SCHEMA.VIEWS v
  ON c.TABLE_CATALOG = v.TABLE_CATALOG
  AND c.TABLE_SCHEMA = v.TABLE_SCHEMA
  AND c.TABLE_NAME = v.TABLE_NAME
WHERE c.TABLE_NAME IN (
    'OPENALEX_AUTHORS_INDEX',
    'OPENALEX_CONCEPTS_INDEX',
    'OPENALEX_FUNDERS_INDEX',
    'OPENALEX_INSTITUTIONS_INDEX',
    'OPENALEX_SOURCES_INDEX',
    'OPENALEX_PUBLISHERS_INDEX',
    'OPENALEX_WORKS_INDEX'
  )
ORDER BY 
  c.TABLE_CATALOG,
  c.TABLE_SCHEMA,
  c.TABLE_NAME,
  c.ORDINAL_POSITION;