-- 1. Elevate to Account Admin to enable global AI features
USE ROLE ACCOUNTADMIN;

-- 2. Enable Cross-Region Inference 
-- This ensures you can access models like Llama 3 even if they aren't 
-- native to your specific Trial region.
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';

-- 3. Grant Permissions to your working role
-- Replace 'SYSADMIN' with your actual project role if different.
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE SYSADMIN;

-- 4. Test Cortex AI Inference
-- This "Hello World" for AI confirms your account can communicate with LLMs.
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'llama3-70b', 
    'Agentic AML environment check: Please provide a one-sentence confirmation that you are ready for Project Argus.'
) AS ai_test_response;


USE ROLE ACCOUNTADMIN;
CREATE DATABASE IF NOT EXISTS KYC_AML_DB;
CREATE SCHEMA IF NOT EXISTS KYC_AML_DB.BRONZE;


USE DATABASE KYC_AML_DB;
USE SCHEMA BRONZE;

-- 2. Enable Cross-Region AI
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';

-- 3. Grant Permissions
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE ACCOUNTADMIN;

-- 4. Test Cortex AI Inference
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'llama3-70b', 
    'Agentic AML environment check: Please provide a one-sentence confirmation that you are ready for Project Argus.'
) AS ai_test_response;

-- 5. Test Vector Engine Support (This will now work!)
CREATE OR REPLACE TABLE vector_test (
    id INT,
    embedding VECTOR(FLOAT, 768)
);

-- 5. Test Vector Engine Support
-- This confirms your account can store the 'Embeddings' used for RAG.
CREATE OR REPLACE TABLE bronze.vector_test (
    id INT,
    embedding VECTOR(FLOAT, 768) -- Standard size for Snowflake's e5-base-v2 model
);


-- Check if the table was created successfully
DESC TABLE bronze.vector_test;

-- Clean up
DROP TABLE bronze.vector_test;