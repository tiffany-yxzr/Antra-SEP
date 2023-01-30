-- Q3
SELECT p.ProductName, SUM(Quantity) [Total Quantity]
FROM Products p
INNER JOIN [Order Details] o
ON p.ProductID = o.ProductID
GROUP BY p.ProductName
ORDER BY p.ProductName

-- Q4
SELECT City, SUM(Quantity) [Total Quantity]
FROM Customers c
INNER JOIN Orders o 
ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od 
ON o.OrderID = od.OrderID
GROUP BY City
ORDER BY [Total Quantity] DESC

-- Q5: List all Customer Cities that have at least two customers.
-- Q5a not so sure why this question needs to use UNION
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(*) >= 2
UNION 
SELECT DISTINCT Country
FROM Customers

-- Q5b
SELECT DISTINCT City FROM Customers
WHERE City IN (SELECT City FROM Customers
GROUP BY City
HAVING COUNT(*) >= 2)
ORDER BY City DESC

-- This is a more convenient approach for this question
SELECT COUNT(CustomerID) [Num of Customers], City
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >= 2
ORDER BY City DESC

-- Q8: List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5 p.ProductName, AVG(od.UnitPrice) AS AveragePrice, c.City, SUM(od.Quantity) AS TotalQuantity
FROM Products p
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY p.ProductName, c.City
ORDER BY TotalQuantity DESC
-- not sure about how to define "their average price"

-- Q9: List all cities that have never ordered something but we have employees there.
-- Q9a
SELECT City
FROM Employees
WHERE City NOT IN (SELECT City FROM Customers)

-- q9b: using a LEFT JOIN and a NULL check
SELECT Employees.City
FROM Employees
LEFT JOIN Customers
ON Employees.City = Customers.City
WHERE Customers.City IS NULL

-- Q10
-- List one city that is the city from where the employee sold most orders (not the product quantity) is 
SELECT TOP 1 e.City, COUNT(o.OrderID) AS TotalOrders
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.City
ORDER BY TotalOrders DESC

-- List the city of most total quantity of products ordered from.
WITH TotalSales AS (
    SELECT TOP 1 o.EmployeeID, SUM(od.Quantity) AS TotalQuantity
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY o.EmployeeID
    ORDER BY TotalQuantity DESC
) 
SELECT e.City 
FROM TotalSales t
JOIN Employees e ON t.EmployeeID = e.EmployeeID

-- Q11: How do you remove the duplicates record of a table?
-- 1. Use DISTINCT to get a result with unique combinations of the specified columns
-- 2. Use GROUP BY, which can get a result set with unique combincations of the specified columns after grouping the rows with identical values
-- 3. Subquery can also delete duplicate rows sometimes 