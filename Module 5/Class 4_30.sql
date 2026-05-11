-- Activity part 1: Credit usage
select *
from metering_history
limit 20;

select *
from query_history
limit 10;


select *
from cortex_aisql_usage_history
limit 10;

-- Activity part 2: UDF (user defined function) and stored procedures.

CREATE OR REPLACE FUNCTION multiply_numbers(a FLOAT, b FLOAT)
RETURNS FLOAT
AS
$$
    a * b
$$;

SELECT multiply_numbers(5, 3);

-- Python

CREATE OR REPLACE FUNCTION celsius_to_fahrenheit(temp_c FLOAT)
RETURNS FLOAT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
HANDLER = 'convert'
AS
$$
def convert(temp_c):
    return (temp_c * 9.0 / 5.0) + 32
$$;

SELECT celsius_to_fahrenheit(0);



CREATE OR REPLACE PROCEDURE get_query_history(row_limit INTEGER)
RETURNS TABLE (query_id VARCHAR, query_text VARCHAR, user_name VARCHAR, execution_status VARCHAR)
LANGUAGE SQL
AS
$$
DECLARE
    res RESULTSET;
BEGIN
    res := (SELECT query_id, query_text, user_name, execution_status
            FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
            LIMIT :row_limit);
    RETURN TABLE(res);
END;
$$;

CALL get_query_history(5);



CREATE OR REPLACE PROCEDURE get_databases()
RETURNS TABLE (database_name VARCHAR, created_on TIMESTAMP_LTZ, owner VARCHAR)
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'run'
AS
$$
def run(session):
    return session.sql("SELECT database_name, created_on, owner FROM SNOWFLAKE.INFORMATION_SCHEMA.DATABASES ORDER BY created_on DESC")
$$;

CALL get_databases();


