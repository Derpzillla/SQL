-- Activity Part 1: SQL Challenge
-- Extract the abstract for one patent
-- Abstract: One paragraph
select patent_id,
    invention_title,
    patent_raw_json,
    patent_raw_json:"abstract".p."#text"
from uspto_patent_index
limit 1;

-- Abstract: Lateral Flatten
select patent_id,
    invention_title,
    patent_raw_json,
    f.*
from uspto_patent_index,
    lateral flatten (input => patent_raw_json:"abstract".p) f
limit 5;

-- Activity part 2: Describe

-- Descriptive statistics for USPTO_PATENTS_G06
SELECT
    COUNT(*) AS total_rows,

    -- NUMBER_OF_CLAIMS (numeric)
    MIN(NUMBER_OF_CLAIMS) AS claims_min,
    MAX(NUMBER_OF_CLAIMS) AS claims_max,
    AVG(NUMBER_OF_CLAIMS) AS claims_avg,
    MEDIAN(NUMBER_OF_CLAIMS) AS claims_median,
    STDDEV(NUMBER_OF_CLAIMS) AS claims_stddev,
    COUNT(NUMBER_OF_CLAIMS) AS claims_non_null,
    COUNT(*) - COUNT(NUMBER_OF_CLAIMS) AS claims_null_count,

    -- APPLICATION_DATE
    MIN(APPLICATION_DATE) AS app_date_min,
    MAX(APPLICATION_DATE) AS app_date_max,
    COUNT(APPLICATION_DATE) AS app_date_non_null,
    COUNT(*) - COUNT(APPLICATION_DATE) AS app_date_null_count,

    -- DOCUMENT_PUBLICATION_DATE
    MIN(DOCUMENT_PUBLICATION_DATE) AS pub_date_min,
    MAX(DOCUMENT_PUBLICATION_DATE) AS pub_date_max,
    COUNT(DOCUMENT_PUBLICATION_DATE) AS pub_date_non_null,
    COUNT(*) - COUNT(DOCUMENT_PUBLICATION_DATE) AS pub_date_null_count,

    -- Categorical cardinalities
    COUNT(DISTINCT PATENT_ID) AS distinct_patent_ids,
    COUNT(DISTINCT PATENT_TYPE) AS distinct_patent_types,
    COUNT(DISTINCT PATENT_STATUS) AS distinct_patent_statuses,
    COUNT(DISTINCT MAIN_CPC_SECTION) AS distinct_cpc_sections,
    COUNT(DISTINCT MAIN_CPC_CLASS) AS distinct_cpc_classes,
    COUNT(DISTINCT MAIN_CPC_SUBCLASS) AS distinct_cpc_subclasses
FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06;

-- Value distributions for categorical columns
SELECT 'PATENT_TYPE' AS column_name, PATENT_TYPE AS value, COUNT(*) AS cnt
FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06
GROUP BY PATENT_TYPE
UNION ALL
SELECT 'PATENT_STATUS', PATENT_STATUS, COUNT(*)
FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06
GROUP BY PATENT_STATUS
UNION ALL
SELECT 'MAIN_CPC_SUBCLASS', MAIN_CPC_SUBCLASS, COUNT(*)
FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06
GROUP BY MAIN_CPC_SUBCLASS
ORDER BY column_name, cnt DESC;

-- Count of patents per CPC category down to subgroup level
SELECT
    MAIN_CPC_SECTION,
    MAIN_CPC_SECTION_DESCR,
    MAIN_CPC_CLASS,
    MAIN_CPC_CLASS_DESCR,
    MAIN_CPC_SUBCLASS,
    MAIN_CPC_SUBCLASS_DESCR,
    MAIN_CPC_MAINGROUP,
    MAIN_CPC_MAINGROUP_DESCR,
    MAIN_CPC_SUBGROUP,
    MAIN_CPC_SUBGROUP_DESCR,
    COUNT(*) AS patent_count
FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06
GROUP BY ALL
ORDER BY patent_count DESC
limit 3;

-- Time series of patent counts by CPC maingroup, top 5 per year
WITH yearly_counts AS (
    SELECT
        YEAR(APPLICATION_DATE) AS app_year,
        MAIN_CPC_MAINGROUP,
        MAIN_CPC_MAINGROUP_DESCR,
        COUNT(*) AS patent_count
    FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06
    GROUP BY ALL
),
ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY app_year ORDER BY patent_count DESC) AS rnk
    FROM yearly_counts
)
SELECT
    app_year,
    rnk,
    MAIN_CPC_MAINGROUP,
    MAIN_CPC_MAINGROUP_DESCR,
    patent_count
FROM ranked
WHERE rnk <= 5
ORDER BY app_year, rnk;



--- Activity part 3: AI_Complete

select patent_id,
    invention_title,
    abstract,
    ai_complete(
        'mistral-7b',
        prompt('Explain the main ideas of this patent to someone who does not have any technical knowlege. Patent title: {0}. Patent Abstract: {1}.', invention_title, abstract)
    ) as patent_ai_summary
from uspto_patents_g06 sample (1 rows);

select patent_id,
    invention_title,
    ai_similarity(
        'Method executed by sensor controller of electromagnetic resonance system, sensor controller, and position detection device',
        invention_title
    ) as cosine_similarity
from uspto_patents_g06 sample (10 rows)
order by cosine_similarity desc;

select patent_id,
    invention_title,
    ai_filter(
        prompt('This patent is related to electromagnetic: {0}', invention_title)
    ) as is_electromagnetic_related
from uspto_patents_g06 sample (10 rows);


select patent_id,
    invention_title
ai_classify(
        invention_title,
        ['hardware', 'software', 'other']
    ) as classification,
    classification:labels::string
from uspto_patents_g06
limit 5;

select ai_summarize_agg(invention_title)
from uspto_patents_g06
where invention_title ilike '%distributed%'
limit 10;