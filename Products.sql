SELECT * 
FROM dbo.products
--------------------------------------------------------

--Query to categorise products based on their price

SELECT  ProductID, --Selects the unique identifier for each product
		ProductName, --Selects the name of each product
		Price, --Selects the price of each product

		CASE --Categorise the products into price categories: Low, Medium or High
			WHEN Price < 50 THEN 'LOW'
			WHEN Price BETWEEN 50  AND 200 THEN 'MEDIUM'
			--WHEN Price > 200 THEN 'HIGH'
			ELSE 'HIGH'
		END AS PriceCategory
FROM products