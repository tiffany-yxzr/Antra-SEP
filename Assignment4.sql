-- Q1
CREATE VIEW view_product_yang AS
SELECT p.ProductName, SUM(od.Quantity) [Total Order Quantity]
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName

SELECT * FROM view_product_yang

-- Q2
CREATE PROCEDURE sp_product_order_quantity_yang (@ProductID int, @TotalOrderQuantity int OUTPUT)
AS
BEGIN
    SELECT @TotalOrderQuantity = SUM(Quantity)
    FROM [Order Details]
    WHERE ProductID = @ProductID
END;

DECLARE @Result int;
EXEC sp_product_order_quantity_yang @ProductID = 1, @TotalOrderQuantity = @Result OUTPUT;
SELECT @Result AS TotalOrderQuantity

-- Q3
CREATE PROC sp_product_order_city_yang (@product_name VARCHAR(50))
AS
BEGIN
    SELECT TOP 5
        c.City, SUM(od.Quantity) as TotalQuantity
    FROM
        Orders o
        INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
        INNER JOIN Products p ON od.ProductID = p.ProductID
        INNER JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE
        p.ProductName = @product_name
    GROUP BY
        c.City
    ORDER BY
        TotalQuantity DESC
END

Exec sp_product_order_city_yang Chang

Drop proc sp_product_order_city_yang

-- Q4
CREATE TABLE city_yang (
    Id INT PRIMARY KEY,
    City VARCHAR(50)
)

INSERT INTO city_yang (Id, City)
VALUES
    (1, 'Seattle'),
    (2, 'Green Bay')

CREATE TABLE people_yang (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    City INT,
    FOREIGN KEY (City) REFERENCES city_yang(Id)
)

INSERT INTO people_yang (Id, Name, City)
VALUES
    (1, 'Aaron Rodgers', 2),
    (2, 'Russell Wilson', 1),
    (3, 'Jody Nelson', 2)

select * from people_yang
select * from city_yang

-- First, create a new city "Madison" in the city_yang table
INSERT INTO city_yang (Id, City)
VALUES (3, 'Madison')

-- Update the city of any people from Seattle to Madison
UPDATE people_yang
SET City = 3
WHERE City = (SELECT Id FROM city_yang WHERE City = 'Seattle')

-- Remove the city of Seattle from the city_yang table
DELETE FROM city_yang
WHERE City = 'Seattle'

select * from people_yang
select * from city_yang

CREATE VIEW Packers_yang AS
SELECT Name
FROM people_yang
WHERE City = (SELECT Id FROM city_yang WHERE City = 'Green Bay')

select * from Packers_yang 
-- all test passed

-- drop both tables and view
DROP TABLE people_yang
DROP TABLE city_yang
DROP VIEW Packers_yang

-- Q5
CREATE PROCEDURE sp_birthday_employees_yang
AS
BEGIN
   IF OBJECT_ID('birthday_employees_yang', 'U') IS NOT NULL
      DROP TABLE birthday_employees_yang;

   CREATE TABLE birthday_employees_yang (
      EmployeeID int,
      Name nvarchar(50),
      Birthday date
   );

   INSERT INTO birthday_employees_yang (EmployeeID, Name, Birthday)
   SELECT EmployeeID, FirstName + ' ' + LastName, BirthDate
   FROM Employees
   WHERE MONTH(BirthDate) = 2;
END;

EXEC sp_birthday_employees_yang

SELECT * FROM birthday_employees_yang

SELECT * FROM Employees -- all test passed

-- drop the table
DROP TABLE birthday_employees_yang

-- Q6: How do you make sure two tables have the same data?
-- Use a SET operation: 
-- Use a MINUS, INTERSECT, or EXCEPT operation to compare the data in two tables and identify any differences.

-- Use a JOIN query: 
-- Join the two tables based on a common column and compare the values in each row. 
-- If the values match, then the data in both tables is the same. 
-- If not, then we can identify the rows that have differences and take appropriate action.

-- Use a UNION query
-- Use UNION to combine the data from both tables and then count the number of rows in the result set. 
-- If the count is equal to the sum of the number of rows in each table, then the data in both tables is the same.