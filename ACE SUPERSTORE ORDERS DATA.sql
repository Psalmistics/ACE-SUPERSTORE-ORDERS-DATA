--     DATA CLEANING  --

--- Removing time(blank) from order date.

SELECT *
FROM DBO.Orders$

ALTER TABLE DBO.Orders$
ADD OrderDate2 DATE

UPDATE DBO.Orders$
SET OrderDate2 = CONVERT (DATE, [Order Date])


--- Removing time(blank) from ship date.

ALTER TABLE DBO.Orders$
ADD ShipDate2 DATE

UPDATE DBO.Orders$
SET ShipDate2 = CONVERT (DATE, [Ship Date])

ALTER TABLE Orders$
DROP COLUMN [Ship Date]




-----------------DATA ANALYSIS----------

----PRODUCTS SHIPPED USING 'STANDARD MODE' BETWEEN 2012 TO 2015 STARTING FOR THE LATEST ORDERS

SELECT [Product Name], ShipDate2, [Ship Mode]
FROM	DBO.Orders$
WHERE 
[Ship Mode] = 'Standard Class' AND 
ShipDate2 BETWEEN '2012' AND '2015'
ORDER BY ShipDate2 DESC

   ----25,362 PRODUCTS WERE SHIPPED USING STANDARD MODE FROM 2012 - 2015




   ---TOTAL NO OF SALES FROM ORDERS SHIPPED TO FRANCE  

SELECT COUNT (Sales) AS [France Sales]
FROM dbo.Orders$
WHERE Country LIKE 'France'

---2,827 ORDERS WERE SHIPPED TO FRANCE





---TOTAL SALES FROM EACH CATEGORY OF Office Supplies, Technology AND Furniture 
 
SELECT SUM(Sales) AS [office supplies sales]
FROM DBO.Orders$
WHERE Category LIKE 'Office Supplies'

SELECT SUM(Sales) AS [Technology sales]
FROM DBO.Orders$
WHERE Category LIKE 'Technology'

SELECT SUM(Sales) AS [furniture sales]
FROM DBO.Orders$
WHERE Category LIKE 'Furniture'

---OFFICE SUPPLIES = 31,273, TECHNOLOGY = 10141, FURNITURE = 9,876





---INFORMATION ABOUT THE HIGHEST ORDER EVER PLACED ON OFFICE SUPPLIES CATEGORY

SELECT MAX(Sales) AS [highest office supplies sales]
FROM dbo.Orders$
WHERE Category LIKE 'Office Supplies'

SELECT [Customer Name], Sales, [OrderDate2]
FROM DBO.Orders$
WHERE Sales = 9892.74

SELECT [Customer Name], Sales, [OrderDate2], [Product Name]
FROM DBO.Orders$
WHERE [Customer Name] LIKE 'Adrian Barton' 
ORDER BY [OrderDate2] DESC

---- ORDER WAS PLACED ON DEC. 18TH, 2013 BY ADRIAN BARTON, AMOUNT OF ORDER WAS $9,892.74





---splitting year out of OrderDate2 for to determine sales per year

SELECT YEAR(OrderDate2) AS YEAR, OrderDate2, [Product Name] [Customer Name], ShipDate2
FROM DBO.Orders$
ORDER BY OrderDate2





----showing total sales per year. using SUBQUERY

SELECT DISTINCT SUM(Sales) AS SALESPERYEAR, YEAR(OrderDate2) AS YEAR
FROM (
SELECT YEAR(OrderDate2) AS YEAR, MONTH(OrderDate2)+1 AS MONTH, OrderDate2, [Product Name], [Customer Name], ShipDate2, Sales
FROM DBO.Orders$) sub
GROUP BY YEAR(OrderDate2)
ORDER BY 2,1

----2011[2259450.89553998] 
----2012[2677438.69439998] 
----2013[3405746.44937998] 
----2014[4299865.87055997]





---Number of returned orders whose value are more than $500 using JOINS 

SELECT  O.Country, O.Sales, O.[Customer Name], O.[Product Name], R.Returned
FROM DBO.Orders$ o
JOIN DBO.Returns$ r
ON R.[Order ID] = O.[Order ID]

-----total orders returned are 3055 in total




----orders returned per country using JOINS and SUBQUERY

SELECT COUNT(Country) AS [RETURNS BY COUNTRY], SUM(Sales) AS [RETURNS AMOUNT], Country
FROM
(SELECT  O.Country, O.Sales, O.[Customer Name], O.[Product Name], R.Returned
FROM DBO.Orders$ o
JOIN DBO.Returns$ r
ON R.[Order ID] = O.[Order ID]) sub
GROUP BY Country
ORDER BY [RETURNS BY COUNTRY]

---Orders were returned from 48 countries in total with the highest orders returned from 
----[United States: 804 ORDERS WORTH $180,982.3419] 




---total amount of orders returned

SELECT SUM([RETURNED AMOUNT]) AS [TOTAL VALUE OF RETURNED ORDERS]
FROM
(SELECT COUNT(Country) AS [RETURNS BY COUNTRY], SUM(Sales) AS [RETURNED AMOUNT], Country
FROM
(SELECT  O.Country, O.Sales, O.[Customer Name], O.[Product Name], R.Returned
FROM DBO.Orders$ o
JOIN DBO.Returns$ r
ON R.[Order ID] = O.[Order ID]) sub
GROUP BY Country) sub

----total amount = $819,768.37938




----using LEFT JOIN to see both orders with return and without return

SELECT  O.Country, O.Sales, O.[Customer Name], O.[Product Name], R.Returned
FROM DBO.Orders$ o
LEFT JOIN DBO.Returns$ r
ON O.[Order ID] = R.[Order ID]




-----Using GROUP BY statement to determine sum of total sales per country

SELECT Count(Country) AS [COUNTRY'S ORDER], Country, SUM(Sales) AS [ALL COUNTRY'S SALES]
FROM Orders$
GROUP BY Country
ORDER BY SUM(Sales)
 
 ----least sales is from Equitorial Guinea with $150.51 and the most is from United States with $2,297,200.86.




 ---- sum of sales per country with reverence to other order details using PATITION BY

SELECT Sales, 
	   OrderDate2, 
	   [Customer Name], 
	   [Product Name],
	   Country,
	   Sales,
	   SUM(Sales) OVER (PARTITION BY Country) AS CountrySales
FROM Orders$


----Selecting the customers whose sums of orders exceed 15,900---------

SELECT SUM(sales) AS SUM, [Customer Name]
FROM Orders$
GROUP BY [Customer Name] 
HAVING SUM(sales) > 15900


