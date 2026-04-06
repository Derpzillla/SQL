-- Activity part 1: SQL Challange
-- What educational insititions with colorado in the name are in the openalex data?

select openalex_institution_id,
institution_name,
institution_type,
summary_stats,
works_counts_by_year
from openalex_institutions_index
where institution_name ilike '%Colorado%' and
institution_type = 'education'
limit 5;

-- Activity pPart 2: CSU Performance
select openalex_institution_id,
       institution_name,
       works_counts_by_year,
       f.value:year::number as year,
       f.value:works_count::number as works_count,
       f.value:cited_by_count::number as cited_by_count
from openalex_institutions_index,
     lateral flatten(input => works_counts_by_year) f
where openalex_institution_id = 'https://openalex.org/I92446798'
order by year;

-- Activity part 3: Haversine Distance
select openalex_institution_id,
       institution_name,
       haversine(
           40.585258483886720000,
           -105.084419250488280000,
           institution_latitude,
           institution_longitude
       ) as distance_km
from openalex_institutions_index
where distance_km < 100 and
      institution_type = 'education';


-- Activity part 4: comparison to other state universities
select institution_name,
       works_count,
       works_cited_by_count as citations_count,
       rank() over (order by works_count desc) as works_rank,
       rank() over (order by works_cited_by_count desc) as citations_rank,
       case
           when openalex_institution_id = 'https://openalex.org/I92446798'
           then 'Colorado State University'
           else 'Other'
       end as institution_flag
from SNOWFLAKE_PUBLIC_DATA_FREE.PUBLIC_DATA_FREE.OPENALEX_INSTITUTIONS_INDEX
where institution_name ilike '%state%university%'
and institution_type = 'education'
and institution_country_geo_id = 'country/USA'
order by works_cited_by_count desc;

--Activity Part 5: Cortex Code
-- CSU collaboration network size compared to similar US state universities
SELECT 
    institution_name,
    ARRAY_SIZE(associated_openalex_institution_ids) AS network_size,
    works_count,
    works_cited_by_count AS citations_count,
    CASE
        WHEN openalex_institution_id = 'https://openalex.org/I92446798'
        THEN 'CSU'
        ELSE ''
    END AS flag
FROM SNOWFLAKE_PUBLIC_DATA_FREE.PUBLIC_DATA_FREE.OPENALEX_INSTITUTIONS_INDEX
WHERE institution_name ILIKE '%state%university%'
  AND institution_type = 'education'
  AND institution_country_geo_id = 'country/USA'
ORDER BY network_size DESC
LIMIT 25;
