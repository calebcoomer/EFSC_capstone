DROP TABLE IF EXISTS BREVARD_MASTER_RAW; 

DROP TABLE IF EXISTS BREVARD_ARREST; 

CREATE TABLE BREVARD_MASTER_RAW AS 
SELECT arrest_date, 
	crime_degree, 
	crime_level, 
	offense_name, 
	offense_grouping, 
	statute, 
	sex, 
	race, 
	source_file, 
	source_row 
FROM FDLE_MASTER_RAW 
WHERE county = 'Brevard'; 
INSERT INTO PIPELINE_RUN_LOG 
    		(run_id, action, row_count, message) 
  VALUES 
    		(
			  1,
        'BREVARD_MASTER_RAW creation', 
        (SELECT COUNT(*) FROM BREVARD_MASTER_RAW), 
        'Table created successfully' 
    		); 

			
CREATE TABLE BREVARD_ARREST AS 
SELECT * 
FROM BREVARD_MASTER_RAW; 
INSERT INTO PIPELINE_RUN_LOG 
    		(run_id, action, row_count, message) 
  VALUES 
    		(
			  1,
        'BREVARD_ARREST creation', 
        (SELECT COUNT(*) FROM BREVARD_ARREST), 
        'Table created successfully' 
    		); 


ALTER TABLE BREVARD_ARREST  
ALTER COLUMN arrest_date TYPE DATE  
	USING arrest_date::date;  
INSERT INTO PIPELINE_RUN_LOG 
    		(run_id, action, row_count, message) 
  VALUES 
    		(
			  1,
        'BREVARD_ARREST typing', 
        (SELECT COUNT(*) FROM BREVARD_ARREST), 
        'Arrest_date field converted to DATE type' 
    		); 

		
UPDATE BREVARD_ARREST  
	SET statute = UPPER(statute); 
INSERT INTO PIPELINE_RUN_LOG 
    		(run_id, action, row_count, message) 
  VALUES 
    		(
			  1,
        'BREVARD_ARREST normalization', 
        (SELECT COUNT(*) FROM BREVARD_ARREST), 
        'Statutes converted to uppercase' 
    		); 


UPDATE BREVARD_ARREST  
	SET source_file = RIGHT(REPLACE(source_file, '.csv', ''), 2); 
INSERT INTO PIPELINE_RUN_LOG 
    		(run_id, action, row_count, message) 
  VALUES 
    		(
			  1,
        'BREVARD_ARREST normalization', 
        (SELECT COUNT(*) FROM BREVARD_ARREST), 
        'Source_file sliced down to two digits' 
    		);

			
ALTER TABLE BREVARD_ARREST  
ALTER COLUMN source_file TYPE INTEGER  
  USING source_file::INTEGER, 
ALTER COLUMN source_row TYPE INTEGER  
	USING source_row::INTEGER;
INSERT INTO PIPELINE_RUN_LOG 
    		(run_id, action, row_count, message) 
  VALUES 
    		(
			  1,
        'BREVARD_ARREST typing', 
        (SELECT COUNT(*) FROM BREVARD_ARREST), 
        'Source_file field converted to INT type' 
    		);
INSERT INTO PIPELINE_RUN_LOG 
    		(run_id, action, row_count, message) 
  VALUES 
    		(
			  1,
        'BREVARD_ARREST typing', 
        (SELECT COUNT(*) FROM BREVARD_ARREST), 
        'Source_row field converted to INT type' 
    		);


ALTER TABLE BREVARD_ARREST 
ADD CONSTRAINT source_key 
	PRIMARY KEY (source_file, source_row);
INSERT INTO PIPELINE_RUN_LOG 
    		(run_id, action, row_count, message) 
  VALUES 
    		(
			  1,
        'BREVARD_ARREST key assignment', 
       	(SELECT COUNT(*) FROM BREVARD_ARREST), 
       	'Composite key created, source_file and source_row' 
    		);	
