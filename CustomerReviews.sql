
----------------------------------

-- Query to clean double space problem in ReviewText column

SELECT CR.ReviewID,
       CR.CustomerID,
	   CR.ProductID,
	   CR.ReviewDate,
	   CR.Rating,
	   --Cleans up the reviewText by replacing double spaces with single spaces to ensure that the text is more readable
	  REPLACE(CR.ReviewText, '  ', ' ') AS ReviewText,
	  CASE 
		WHEN Rating = 1 OR Rating = 2 THEN 'Negative'
		WHEN Rating = 3 THEN 'Mixed Negative'
		WHEN Rating >= 4 THEN 'Positive'
	  END AS SentimentScore	
FROM customer_reviews AS CR