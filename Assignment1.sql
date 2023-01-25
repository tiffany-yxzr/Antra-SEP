-- Q1
SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product;

-- Q2
SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product
WHERE ListPrice <> 0;

-- Q3
SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product
WHERE Color IS NOT NULL;

-- Q4
SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product
WHERE Color IS NOT NULL
AND ListPrice > 0;

-- Q5
SELECT Name + ' - ' + Color "Concatenation"
FROM Production.Product
WHERE Color IS NOT NULL;

-- Q6
SELECT TOP 6 'NAME:' + Name + ' -- ' + 'COLOR:' + Color "Product Details"
FROM Production.Product
WHERE Color IS NOT NULL;

-- Q8
SELECT ProductID, Name 
FROM Production.Product
WHERE ProductID BETWEEN 400 AND 500;

-- Q9
SELECT ProductID, Name, Color 
FROM Production.Product
WHERE Color = 'black' OR Color = 'blue';

-- Q10
-- Method 1
SELECT Name, ListPrice 
FROM Production.Product
WHERE (Name IN ('Seat Lug', 'Seat Post', 'Seat Stays ', 'Seat Tube', 'Short-Sleeve Classic Jersey, M', 'Short-Sleeve Classic Jersey, L'))
ORDER BY Name;

-- Method 2 using wildcard
SELECT Name, ListPrice 
FROM Production.Product
WHERE Name LIKE 'Seat%' OR Name LIKE 'Short% L' OR Name LIKE 'Short%M'
ORDER BY Name;

-- Q12
SELECT TOP 5 Name, ListPrice 
FROM Production.Product
WHERE Name LIKE 'A%' OR Name LIKE 'Seat%'
ORDER BY Name; -- this will get the exactly same result from the homework's question

-- However, if we want to get the products name start with either 'A' or 'S', the query needs a small revision
SELECT Name, ListPrice 
FROM Production.Product
WHERE Name LIKE 'A%' OR Name LIKE 'S%'
ORDER BY Name; 

-- Q13
SELECT Name 
FROM Production.Product
WHERE Name LIKE 'Spo[^k]%'
ORDER BY Name;

-- Q14
SELECT DISTINCT Color
FROM Production.Product
ORDER BY Color DESC;