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