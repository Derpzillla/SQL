-- Activity Part 1: SQL Challenge
-- Pick a random patent; classify it as 'AI' or 'Other'
select patent_id,
    invention_title,
    ai_classify(
        invention_title,
        ['AI', 'Other']
    ) as classification,
    classification:labels::string
from uspto_patents_g06 sample (1 rows);

-- Demo
-- Merge two random patents into a new idea using AI_COMPLETE and insert into the table
INSERT INTO uspto_patents_g06 (patent_id, invention_title, abstract)
WITH two_patents AS (
    SELECT *
    FROM uspto_patents_g06 SAMPLE (2 ROWS)
),
merged AS (
    SELECT
        SNOWFLAKE.CORTEX.AI_COMPLETE(
            'claude-3-5-sonnet',
            'You are an inventor. Given these two patents, merge them into one new invention. '
            || 'Return ONLY a JSON object with two keys: "title" (a short invention title) and "abstract" (a 2-3 sentence abstract). '
            || 'Patent 1 Title: ' || NVL(p1.invention_title, '')
            || ' | Patent 1 Abstract: ' || NVL(p1.abstract, '')
            || ' | Patent 2 Title: ' || NVL(p2.invention_title, '')
            || ' | Patent 2 Abstract: ' || NVL(p2.abstract, '')
        ) AS ai_response
    FROM two_patents p1,
         two_patents p2
    WHERE p1.patent_id != p2.patent_id
    LIMIT 1
)
SELECT
    'NEW_IDEA',
    TRY_PARSE_JSON(ai_response):title::VARCHAR,
    TRY_PARSE_JSON(ai_response):abstract::VARCHAR
FROM merged;

-- Verify the inserted patent
SELECT patent_id, invention_title, abstract
FROM uspto_patents_g06
WHERE patent_id = 'NEW_IDEA';

-- Activity Part 2: New Patent Idea
select *
from uspto_patents_g06
where patent_id = 'NEW_IDEA';

-- Activity part 3
select count(*)
from uspto_patents_g06
where main_cpc_subclass = 'F' and
    main_cpc_maingroup = '11';

-- Activity Part 4 
-- Activity Part 4: Extract Keywords from our New Patent Idea
SELECT 
    patent_id,
    AI_EXTRACT(
        text => abstract,
        responseFormat => ['keywords: Extract unique, relevant single-word keywords only. Exclude stop words like the, a, an, is, are, of, in, to, for, and, or, with, on, at, by, from, that, this, it, as, be, was, were, been, have, has, had, which, but, not, can, will, would, should, could, do, did, their, them, they, its. Return only individual words, not phrases.']
    ):response:keywords AS keywords
FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06
WHERE patent_id = 'NEW_IDEA';

-- Activity Part 5
-- Activity Part 6: Find Similar Patents Using AI_FILTER
SELECT patent_id, invention_title, abstract
FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06
WHERE main_cpc_maingroup = (
    SELECT main_cpc_maingroup
    FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06
    WHERE patent_id = 'NEW_IDEA'
)
AND patent_id != 'NEW_IDEA'
AND AI_FILTER(
    PROMPT(
        'Is this patent abstract related to at least one of these three categories?
        1. Vector Search & Embeddings: query, vector, representation, embedding, space, search, similarity, scores
        2. Search Engine Optimization: search, engine, results, improve, performance, dynamically
        3. System Monitoring & Error Handling: external, interrupts, performance, issues, corrective, actions, address
        Abstract: {0}',
        abstract
    )
);


-- Activity Part 6: RLIKE - Find Patents Related to Federate and Search
SELECT patent_id, invention_title, abstract
FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06
WHERE main_cpc_maingroup = (
    SELECT main_cpc_maingroup
    FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06
    WHERE patent_id = 'NEW_IDEA'
)
AND abstract RLIKE '.*\\bfederat\\w*\\b.*'
OR abstract RLIKE '.*\\bsearch\\w*\\b.*';

-- Activity Part 7: SEARCH - Find Patents Related to Federated Computing
SELECT patent_id, invention_title, abstract
FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06
WHERE main_cpc_maingroup = (
    SELECT main_cpc_maingroup
    FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06
    WHERE patent_id = 'NEW_IDEA'
)
AND SEARCH(abstract, 'federated computing distributed
decentralized collaborative learning aggregation node client
server model training');

-- Activity Part 7: Majority Vote

WITH base_patents AS (
    SELECT patent_id, invention_title, abstract
    FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06
    WHERE main_cpc_maingroup = (
        SELECT main_cpc_maingroup
        FROM Z_DB_INSTRUCTOR1.MODULE4.USPTO_PATENTS_G06
        WHERE patent_id = 'NEW_IDEA'
    )
    AND patent_id != 'NEW_IDEA'
),

-- Method 1: AI_FILTER
method_ai AS (
    SELECT patent_id FROM base_patents
    WHERE AI_FILTER(
        PROMPT(
            'Is this patent abstract related to at least one of these three categories?
            1. Vector Search & Embeddings... 2. SEO... 3. System Monitoring... Abstract: {0}',
            abstract
        )
    )
),

-- Method 2: RLIKE
method_rlike AS (
    SELECT patent_id FROM base_patents
    WHERE abstract RLIKE '.*\\bfederat\\w*\\b.*'
       OR abstract RLIKE '.*\\bsearch\\w*\\b.*'
),

-- Method 3: SEARCH
method_search AS (
    SELECT patent_id FROM base_patents
    WHERE SEARCH(abstract, 'federated computing distributed decentralized collaborative learning aggregation node client server model training')
),

-- Combine results and count "votes"
combined_results AS (
    SELECT patent_id FROM method_ai
    UNION ALL
    SELECT patent_id FROM method_rlike
    UNION ALL
    SELECT patent_id FROM method_search
)

SELECT 
    p.patent_id, 
    p.invention_title, 
    COUNT(*) as vote_count
FROM combined_results c
JOIN base_patents p ON c.patent_id = p.patent_id
GROUP BY p.patent_id, p.invention_title
HAVING vote_count >= 2
ORDER BY vote_count DESC;