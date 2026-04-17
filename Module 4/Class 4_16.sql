-- Activity part 1
select *
from uspto_patents_g06
where abstract ilike '%agentic%';

select *
from uspto_patents_g06
where lower(abstract) rlike '.*agentic.*';

-- Activity Part 2: AISQL Review
select ai_complete(
    'snowflake-arctic',
    prompt('Summarize this abstract: {0}', abstract)
)
from uspto_patents_g06
limit 1;


-- Embeddings
select ai_embed(
    'e5-base-v2',
    'An agentic workflow'
) as embedding_e5;

-- Evaluates to yes/no
select ai_filter(
    'New York City is in the state of New York'
);

-- summarizing two invention titles
select ai_summarize_agg(
    invention_title
)
from uspto_patents_g06
limit 2;

-- classifcation from provided list
select ai_classify(
    'An agentic workflow',
    ['Traditional SQL', 'Modern LLM']   -- provided list / labels options
) as classification;

-- outputs Fruit

select ai_classify(
    'Apple',
    ['Fruit', 'Meat']
) as classification;


select ai_redact(
    'Patient John Smith, DOB 03/15/1985, SSN 123-45-6789, was seen at Fort Collins Medical Center on 04/10/2026. Contact: john.smith@email.com, phone 970-555-1234. Diagnosis: Type 2 Diabetes.'
) as redacted_profile;

select *
from ke_claim_finetune_data;