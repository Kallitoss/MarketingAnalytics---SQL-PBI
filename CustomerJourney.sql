
-- Common Table Expression (CTE) to identify and tag duplicate records

WITH CTE_DuplicateRecords AS (
    SELECT 
        JourneyID,  -- Select the unique identifier for each journey to ensure data traceability
        CustomerID,  -- Select the unique identifier for each customer
        ProductID,  -- Select the unique identifier for each product
        VisitDate,  -- Select the date of the visit, which helps in determining the timeline of customer interactions
        Stage,  -- Select the stage of the customer journey (e.g., Awareness, Consideration, etc.)
        Action,  -- Select the action taken by the customer (e.g., View, Click, Purchase)
        Duration,  -- Select the duration of the action or interaction
        -- Use ROW_NUMBER() to assign a unique row number to each record within the partition defined below
        ROW_NUMBER() OVER (
            -- PARTITION BY groups the rows based on the specified columns that should be unique
            PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action  
            -- ORDER BY defines how to order the rows within each partition (usually by a unique identifier like JourneyID)
            ORDER BY JourneyID  
        ) AS row_num  -- This creates a new column 'row_num' that numbers each row within its partition
    FROM 
        dbo.customer_journey  -- Specifies the source table from which to select the data
)

-- Select all records from the CTE where row_num > 1, which indicates duplicate entries
    
SELECT *
FROM CTE_DuplicateRecords
WHERE row_num > 1  -- Filters out the first occurrence (row_num = 1) and only shows the duplicates (row_num > 1)
ORDER BY JourneyID

---Query that selectsthe final cleansed and standardized data

SELECT   JourneyID,  -- Select the unique identifier for each journey to ensure data traceability
         CustomerID,  -- Select the unique identifier for each customer
         ProductID,  -- Select the unique identifier for each product
         VisitDate,  -- Select the date of the visit, which helps in determining the timeline of customer interactions
         Stage,  -- Select the stage of the customer journey (e.g., Awareness, Consideration, etc.)
         Action,  -- Select the action taken by the customer (e.g., View, Click, Purchase)
		 COALESCE(Duration, avg_duration) AS Duration -- Replaces missing durations with the average duration for the corresponding date
		 FROM(
			-- Subquery to process and clean the data 
			SELECT 
			JourneyID,
			CustomerID,
			ProductID,
			VisitDate,
			UPPER(Stage) AS Stage,  -- Converts Stage values to uppercase for consistency in data analysis
			Action,
			Duration,
			AVG(Duration) OVER(PARTITION BY VisitDate) AS avg_duration, -- Calculates the average duration for each date, using only numeric values
			ROW_NUMBER() OVER (
						 PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action  -- Groups by these columns to identify duplicate records 
						 ORDER BY JourneyID
					 ) AS row_num
			FROM customer_journey
		 ) AS subsquery
		 WHERE row_num = 1 -- Keeps only the first occurrence of each duplicate group identified in the subquery

