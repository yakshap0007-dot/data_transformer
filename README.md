# data_transformer
Data Transformer
About the Project

Data Transformer is a beginner-friendly SQL project. It shows how to use SQL to connect tables, filter data, work with dates and text, calculate running totals, rank orders, and create categories using conditions.
This project uses a small example of a company's customer, order, and employee data.

--> Objectives
- Practise SQL JOIN operations.
- Use subqueries to compare values with averages.
- Extract and format dates.
- Change and clean text values.
- Use window functions such as SUM() OVER() and RANK().
- Use CASE to calculate discounts and salary categories.

Tables Used
1. Customers
Column	Meaning
CustomerID	Unique ID for each customer
FirstName	Customer's first name
LastName	Customer's last name
Email	Customer's email address
RegistrationDate	Date the customer registered


2. Orders
Column	Meaning
OrderID	Unique ID for each order
CustomerID	Customer who placed the order
OrderDate	Date of the order
TotalAmount	Total value of the order


3. Employees
Column	Meaning
EmployeeID	Unique ID for each employee
FirstName	Employee's first name
LastName	Employee's last name
Department	Employee's department
HireDate	Employee's joining date
Salary	Employee's salary


SQL Topics Covered
1. INNER JOIN
2. LEFT JOIN
3. RIGHT JOIN
4. Full outer join result using UNION (MySQL does not directly support FULL OUTER JOIN)
5. Subqueries and aggregate functions
6. Date functions: YEAR(), MONTH(), DATEDIFF(), DATE_FORMAT()
7. String functions: CONCAT(), REPLACE(), UPPER(), LOWER(), TRIM()
8. Window functions: SUM() OVER() and RANK()
9. Conditional logic with CASE

--> Requirements
- MySQL 8.0 or later
- MySQL Workbench or another MySQL client
MySQL 8.0 is recommended because the project uses window functions.
How to Run the Project

1. Install and open MySQL Workbench.
2. Connect to your local MySQL server.
3. Open the data_transformer.sql file.
4. Run the script. It creates the database, creates the three tables, and inserts sample records.
5. Run the SELECT statements to see the results of each task.
6. To run only one task, select that query and click the execute button.

Note: The script drops and recreates the three project tables when run. Do not use it in a database that contains data you need to keep.
Assumptions
- For discounts, orders above 1000 get a 10% discount, orders above 500 get a 5% discount, and all other orders get no discount.
- For salary categories, salary of 70000 or more is High, salary of 50000 or more is Medium, and anything lower is Low.
- The sample data is only for learning and demonstration.
- 
Project Files
- data_transformer.sql — table creation, sample data, and all 17 SQL tasks.
- README.md — project details and setup instructions.

Learning Outcome
After completing this project, a student should understand how to combine data from multiple tables, apply SQL functions, perform calculations, and prepare data in a useful format for reporting.

Author
yaksha patel 

License
This project is created for educational and practice purposes.
