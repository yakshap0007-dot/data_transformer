-- Project: Data Transformer


CREATE DATABASE IF NOT EXISTS data_transformer;
USE data_transformer;

-- Re-create tables so this script can be run more than once.
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Employees;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(120),
    RegistrationDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_orders_customers
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2) NOT NULL
);

-- Sample data for Customers
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, RegistrationDate) VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2022-03-15'),
(2, 'Jane', 'Smith', ' jane.smith@email.com ', '2021-11-02'),
(3, 'Amit', 'Shah', 'amit.shah@email.com', '2023-01-10'),
(4, 'Priya', 'Patel', 'priya.patel@email.com', '2023-06-22'),
(5, 'Ravi', 'Mehta', 'ravi.mehta@email.com', '2024-02-05');

-- Sample data for Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(101, 1, '2023-07-01', 150.50),
(102, 2, '2023-07-03', 200.75),
(103, 1, '2023-07-10', 650.00),
(104, 3, '2023-08-12', 1250.00),
(105, 4, '2024-01-05', 520.00);

-- Sample data for Employees
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, HireDate, Salary) VALUES
(1, 'Mark', 'Johnson', 'Sales', '2020-01-15', 50000.00),
(2, 'Susan', 'Lee', 'HR', '2021-03-20', 55000.00),
(3, 'Neha', 'Desai', 'IT', '2019-06-10', 72000.00),
(4, 'Arjun', 'Patel', 'Finance', '2022-09-01', 46000.00),
(5, 'Sara', 'Khan', 'IT', '2018-11-25', 85000.00);

-- Check the tables and sample records
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Employees;

-- 1. INNER JOIN: orders that have matching customer records
SELECT o.OrderID, c.CustomerID, c.FirstName, c.LastName, o.OrderDate, o.TotalAmount
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;

-- 2. LEFT JOIN: all customers, whether they have an order or not
SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderID, o.TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 3. RIGHT JOIN: all orders and matching customer details, if any
SELECT o.OrderID, o.CustomerID, c.FirstName, c.LastName, o.TotalAmount
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 4. FULL OUTER JOIN equivalent in MySQL using LEFT JOIN + unmatched RIGHT JOIN rows
SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderID, o.TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
UNION
SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderID, o.TotalAmount
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 5. Customers whose total order amount is above the average order amount
SELECT c.CustomerID, c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(o.TotalAmount) > (SELECT AVG(TotalAmount) FROM Orders);

-- 6. Employees whose salary is above the average employee salary
SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- 7. Extract the year and month from each order date
SELECT OrderID, OrderDate,
       YEAR(OrderDate) AS OrderYear,
       MONTH(OrderDate) AS OrderMonth
FROM Orders;

-- 8. Difference in days between order date and current date
SELECT OrderID, OrderDate,
       DATEDIFF(CURDATE(), OrderDate) AS DaysSinceOrder
FROM Orders;

-- 9. Format the order date in a readable format
SELECT OrderID, OrderDate,
       DATE_FORMAT(OrderDate, '%d-%b-%Y') AS FormattedOrderDate
FROM Orders;

-- 10. Concatenate first and last names to create a full name
SELECT CustomerID,
       CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers;

-- 11. Replace 'John' with 'Jonathan' in the first-name output
SELECT CustomerID, FirstName,
       REPLACE(FirstName, 'John', 'Jonathan') AS UpdatedFirstName
FROM Customers;

-- 12. Convert first names to uppercase and last names to lowercase
SELECT CustomerID,
       UPPER(FirstName) AS FirstNameUppercase,
       LOWER(LastName) AS LastNameLowercase
FROM Customers;

-- 13. Remove extra spaces from the email field
SELECT CustomerID, Email,
       TRIM(Email) AS CleanEmail
FROM Customers;

-- 14. Running total of TotalAmount for each order, in order-date order
SELECT OrderID, OrderDate, TotalAmount,
       SUM(TotalAmount) OVER (
           ORDER BY OrderDate, OrderID
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS RunningTotal
FROM Orders;

-- 15. Rank orders by TotalAmount, highest amount gets rank 1
SELECT OrderID, TotalAmount,
       RANK() OVER (ORDER BY TotalAmount DESC) AS OrderRank
FROM Orders;

-- 16. Assign discount based on TotalAmount
-- Assumption: amount > 1000 = 10%, amount > 500 = 5%, otherwise 0%.
SELECT OrderID, TotalAmount,
       CASE
           WHEN TotalAmount > 1000 THEN 10
           WHEN TotalAmount > 500 THEN 5
           ELSE 0
       END AS DiscountPercent,
       ROUND(TotalAmount * (
           CASE
               WHEN TotalAmount > 1000 THEN 0.10
               WHEN TotalAmount > 500 THEN 0.05
               ELSE 0
           END
       ), 2) AS DiscountAmount,
       ROUND(TotalAmount - TotalAmount * (
           CASE
               WHEN TotalAmount > 1000 THEN 0.10
               WHEN TotalAmount > 500 THEN 0.05
               ELSE 0
           END
       ), 2) AS FinalAmount
FROM Orders;

-- 17. Categorize employee salaries as High, Medium, or Low
-- Assumption: salary >= 70000 = High; >= 50000 = Medium; otherwise Low.
SELECT EmployeeID, FirstName, LastName, Salary,
       CASE
           WHEN Salary >= 70000 THEN 'High'
           WHEN Salary >= 50000 THEN 'Medium'
           ELSE 'Low'
       END AS SalaryCategory
FROM Employees;
