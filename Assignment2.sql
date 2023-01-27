-- AdventureWorks2019 Database
-- Q1
SELECT COUNT(*) [Number of Products]
FROM Production.Product;

-- Q3
SELECT ProductSubcategoryID, COUNT(*) CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL -- to filter out NULL value; If we need to include NULL value, we can simply delete this line of code
GROUP BY ProductSubcategoryID

-- Q4
SELECT ProductSubcategoryID, COUNT(*) CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NULL
GROUP BY ProductSubcategoryID

-- Q5
SELECT SUM(Quantity) [Product Total Quantity]
FROM Production.ProductInventory -- this will return a single value for total quantity for all products

SELECT SUM(Quantity) [Product Total Quantity]
FROM Production.ProductInventory
GROUP BY ProductID -- this will return sum of product quantity based on each ProductID

-- Q6 
SELECT ProductID, SUM(Quantity) [The Sum]
FROM Production.ProductInventory
WHERE LocationID = 40 
GROUP BY ProductID
HAVING SUM(Quantity) < 100

-- Q10
SELECT ProductID, Shelf, AVG(Quantity) TheAvg
FROM Production.ProductInventory
WHERE Shelf <> 'N/A'
GROUP BY ProductID, Shelf

-- Q11
SELECT Color, Class, COUNT(*) [The Count], AVG(ListPrice) [AvgPrice]
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class -- The results shows that it's not grouped idependently over two different classes

-- Therefore, Grouping SETS will help
SELECT Color, Class, COUNT(*) [The Count], AVG(ListPrice) [AvgPrice]
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY GROUPING SETS ((Color), (Class))

-- Joins
-- Q12
SELECT cr.[Name] Country, sp.[Name] Provine
FROM Person.CountryRegion cr 
INNER JOIN Person.StateProvince sp
ON cr.CountryRegionCode = sp.CountryRegionCode

-- Q13
SELECT cr.[Name] Country, sp.[Name] Provine
FROM Person.CountryRegion cr 
INNER JOIN Person.StateProvince sp
ON cr.CountryRegionCode = sp.CountryRegionCode
WHERE cr.[Name] IN ('Canada', 'Germany')
ORDER BY 1, 2

-- Northwind Database
-- Q15
WITH ZipCodeLocation AS (
    SELECT ShipPostalCode [ZipCode], SUM(Quantity) [Total Quantity]
    FROM Orders o
    JOIN "Order Details" od ON o.OrderID = od.OrderID
    GROUP BY ShipPostalCode
)
SELECT TOP 5 [ZipCode], [Total Quantity]
FROM ZipCodeLocation
ORDER BY [Total Quantity] DESC

-- Q17
SELECT City, COUNT(*) [Number of Customers]
FROM Customers
GROUP BY City
ORDER BY City

-- Q18
SELECT City, COUNT(*) [Number of Customers]
FROM Customers
GROUP BY City
HAVING COUNT(*) > 2
ORDER BY City

-- Q19
-- sort the result based on the order date instead of customer name
SELECT DISTINCT c.ContactName [Customer Name], o.OrderDate [Order Date]
FROM Customers c
INNER JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE OrderDate > '1998-01-01'
ORDER BY [Order Date]

-- Q20 
-- I sort the result based on Customer Name in alphabetical order instead of sorting their most recent order date
WITH RecentOrderDate AS(
SELECT CustomerID, MAX(OrderDate) [RecentOrderDate]
From Orders
GROUP BY CustomerID
)
SELECT c.ContactName [Customer Name], ro.RecentOrderDate [RecentOrderDate]
FROM Customers c
INNER JOIN RecentOrderDate ro
ON c.CustomerID = ro.CustomerID
ORDER BY [Customer Name] 

-- Q23
-- SELECT su.CompanyName [Supplier Company Name], sh.CompanyName [Shipping Company Name]
-- FROM Suppliers su
-- INNER JOIN Orders o ON su.SupplierID = o.ShipVia
-- INNER JOIN Shippers sh ON o.ShipVia = sh.ShipperID
-- GROUP BY su.CompanyName, sh.CompanyName
-- ORDER BY su.CompanyName --> it only returns 3 rows which are not a valid approach

-- We can use Cartesian Join for each row of one table to every row of another table
SELECT su.CompanyName [Supplier Company Name], sh.CompanyName [Shipping Company Name]
FROM Suppliers su
CROSS JOIN Shippers sh
ORDER BY 1, 2

-- Q26
WITH ReporteeCount AS (
    select ReportsTo, COUNT(*) [ReporteeCount]
    FROM Employees
    WHERE ReportsTo IS NOT NULL
    GROUP BY ReportsTo
)
SELECT e.FirstName + ' ' + e.LastName [Manager Name], rc.ReporteeCount
FROM Employees e
INNER JOIN ReporteeCount rc ON e.EmployeeID = rc.ReportsTo
WHERE rc.ReporteeCount > 2
ORDER BY rc.ReporteeCount DESC;