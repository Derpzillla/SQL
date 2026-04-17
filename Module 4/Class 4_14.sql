-- Activity Part 1: SQL challenge

select ai_embed(
    'snowflake-arctic-embed-l-v2.0',
    'Unstructured data analysis with AISQL in Snowflake'
) as embedding;

-- Activity part 2:

select *
from ke_claim_chunk_similarity
order by similarity_score desc;

