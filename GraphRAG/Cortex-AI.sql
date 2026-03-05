USE ROLE ACCOUNTADMIN;
USE DATABASE KYC_AML_DB;
USE SCHEMA GOLD;

-- Grant yourself the AI power
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE ACCOUNTADMIN;

-- If you are using SYSADMIN for your worksheet, run this too:
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE SYSADMIN;

SELECT SNOWFLAKE.CORTEX.COMPLETE('mistral-7b', 'Say hello');

SELECT 
    SUSPECT_ENTITY,
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-7b', -- Swapping to a highly available model for the test
        CONCAT(
            'You are a Senior AML Investigator. Analyze this transaction loop: ',
            NVL(SUSPECT_ENTITY, 'Unknown'), ' sent funds through intermediaries. ',
            'Pattern: Circular funding. ',
            'Context: High-risk shell company activity. ',
            'Provide a Risk Score (1-10).'
        )
    ) as AI_ADJUDICATION
FROM AGENT_CONTEXT_CIRCULAR_LOOPS
LIMIT 5;


-- Create the Final Alert Table to store the intelligence
CREATE TABLE IF NOT EXISTS AML_INVESTIGATION_LOGS (
    ENTITY_ID STRING,
    AI_RISK_REPORT STRING,
    DETECTED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Execute the AI Adjudication
INSERT INTO AML_INVESTIGATION_LOGS (ENTITY_ID, AI_RISK_REPORT)
SELECT 
    SUSPECT_ENTITY,
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-7b', 
        CONCAT(
            'SYSTEM: You are a Lead AML Compliance Officer. ',
            'DATA: Suspect Entity ', SUSPECT_ENTITY, ' is involved in a 3-hop circular loop: ',
            SUSPECT_ENTITY, ' -> ', INTERMEDIARY_1, ' -> ', INTERMEDIARY_2, ' -> ', FINAL_RECIPIENT, '. ',
            'EXTERNAL NEWS: ', NVL((SELECT RAW_CONTENT:summary::STRING FROM KYC_AML_DB.BRONZE.RAW_INTELLIGENCE_FEEDS LIMIT 1), 'No recent news available.'),
            ' | TASK: In 50 words, explain why this circular path is a high-risk indicator for money laundering.'
        )
    ) as AI_ADJUDICATION
FROM AGENT_CONTEXT_CIRCULAR_LOOPS;


SELECT * FROM AML_INVESTIGATION_LOGS;