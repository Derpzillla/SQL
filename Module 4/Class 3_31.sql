-- Actibity Part 1: Structure of the Data

select *
from information_schema.views
where table_name ilike 'uspto%';

select * 
from uspto_patent_index
limit 5;

select *
from USPTO_PATENT_RELATIONSHIPS
limit 5;

select *
from USPTO_PATENT_CONTRIBUTOR_RELATIONSHIPS
limit 5;

select *
from USPTO_CONTRIBUTOR_INDEX
limit 5;

-- Activity part 2: JSON for single patent

select *
from uspto_patent_index
limit 1;

select patent_id,
invention_title,
patent_raw_json:"us-bibliographic-data-application". "invention-title"."#text"::string as invention_title_from_json
from uspto_patent_index
limit 1;