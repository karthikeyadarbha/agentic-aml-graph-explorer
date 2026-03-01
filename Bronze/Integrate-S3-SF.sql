USE ROLE ACCOUNTADMIN;

-- This creates the 'handshake' object in Snowflake
CREATE OR REPLACE STORAGE INTEGRATION s3_kyc_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::716171483574:role/Snowflake_S3_Access_Role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://amzn-aml-graph-bkt/');

-- RUN THIS and keep the results open
DESC INTEGRATION s3_kyc_integration;

USE ROLE ACCOUNTADMIN;
USE DATABASE KYC_AML_DB;
USE SCHEMA BRONZE;

-- Verify the stage exists in this specific schema
SHOW STAGES LIKE 'S3_AML_STAGE';

SELECT * FROM DIRECTORY(@BRONZE.S3_AML_STAGE);

DESC INTEGRATION s3_kyc_integration;

USE ROLE ACCOUNTADMIN;
USE DATABASE KYC_AML_DB;
USE SCHEMA BRONZE;

-- This "pings" the connection. If you see file names, you win!
ALTER STAGE BRONZE.S3_AML_STAGE REFRESH;

-- Re-create the stage one last time with explicit settings
CREATE OR REPLACE STAGE KYC_AML_DB.BRONZE.S3_AML_STAGE
    STORAGE_INTEGRATION = s3_kyc_integration
    URL = 's3://amzn-aml-graph-bkt/'
    DIRECTORY = (ENABLE = TRUE);



