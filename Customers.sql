SELECT * 
FROM DBO.customers

SELECT * 
FROM geography 

----------------------------------------------------------

--SQL STATEMENT TO JOIN Customers table with Geography table to enrich customer data with geographic informations

SELECT C.CustomerID, --Selects the unique identifier for each customer
	   C.CustomerName, --Selects the name of each customer
	   C.Email, --Selects the unique email of each customer
	   C.Age, --Selects the age of every customer	
	   G.Country, --Selects the living country of each customer to enrich customer data
	   G.City --Selects the living city of each customer to enrich customer data
	   

FROM customers C --Specifies the alias for customers table as C
LEFT JOIN
 dbo.geography G --Specifies the alias for geography table as g
 ON C.GeographyID = G.GeographyID