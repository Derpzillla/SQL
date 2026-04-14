SELECT *
FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_DAILY_HISTORY
WHERE SERVICE_TYPE='AI_SERVICES';

-- Activity Part 1: SQL Challenge
-- Pick a keyword
-- Search for patents that use that keyword
-- Use ILIKE, RLIKE, and/or SEARCH

SELECT *
FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_DAILY_HISTORY
WHERE SERVICE_TYPE='AI_SERVICES';

-- Activity Part 1: SQL Challenge
-- Pick a keyword
-- Search for patents that use that keyword
-- Use ILIKE, RLIKE, and/or SEARCH
select *
from uspto_patents_g06
where abstract ilike '%federat%';

select *
from uspto_patents_g06
where abstract rlike '.*\\bfederat\\w*\\b.*';

select *
from uspto_patents_g06
where SEARCH(abstract, 'federate federated federation federating federates');

-- Activity Part 2: AI_SIMILARITY
select *
from uspto_patents_g06
where patent_id = 'NEW_IDEA';

select
from uspto_patents_g06 sample (5 rows);

select patent_id,
    invention_title,
    ai_similarity(
        'System and Method for Enhancing Search Engine Performance Using Federated Learning and External-Interrupt-Based Customized Behavior',
        invention_title
    ) as similarity_score
from uspto_patents_g06 sample (5 rows)
order by similarity_score desc;

-- Activity Part 3: Embeddings
select ai_embed(
    'e5-base-v2',
    'System and Method for Enhancing Search Engine Performance Using Federated Learning and External-Interrupt-Based Customized Behavior'
) as embedding,
array_size(embedding::array);

-- Activity Part 4: Distance
select patent_id,
    invention_title,
    vector_cosine_similarity(
        ai_embed(
            'snowflake-arctic-embed-l-v2.0-8k',
            'System and Method for Enhancing Search Engine Performance Using Federated Learning and External-Interrupt-Based Customized Behavior'
        ),
        ai_embed(
            'snowflake-arctic-embed-l-v2.0-8k',
            invention_title
        )
    ) as similarity_score
from uspto_patents_g06 sample (5 rows)
order by similarity_score desc;

-- Activity Part 5
select patent_id,
    invention_title,
    vector_cosine_similarity(
        ai_embed(
            'snowflake-arctic-embed-l-v2.0-8k',
            'FEDerated learning'
        ),
        invention_title_embed
    ) as similarity_score
from uspto_patents_g06
--order by similarity_score desc
limit 5;