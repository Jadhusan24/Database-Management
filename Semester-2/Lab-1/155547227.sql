-- Jadhusan M Sadhik
-- 155547227
-- jmohammedsadhik@myseneca.ca


USE dbs710Sample;
GO

-- 1. Display employee id, last name, and salary of employees earning $5,000 to $8,000, sorted by top salaries and then by last name
SELECT employeeID, lastName, FORMAT(monthlySalary, '$###,###.##') AS salary
FROM employees
WHERE monthlySalary BETWEEN 5000 AND 8000
ORDER BY monthlySalary DESC, lastName;

-- 2. Display job titles and full names of employees with first name containing 'e' or 'E' (BONUS for not using OR)
SELECT jobID AS JobTitle, CONCAT(firstName, ' ', lastName) AS FullName
FROM employees
WHERE LOWER(firstName) LIKE '%e%'
ORDER BY jobID, FullName;

-- 3. Create a query to display the address
DECLARE @city_param NVARCHAR(255) = 'your_city';
SELECT streetAddress, city, stateProv, postalCode, countryID
FROM locations
WHERE city = @city_param;

-- 4. Write a query to display the tomorrow’s date in the following format:
SELECT FORMAT(GETDATE() + 1, 'MMMM dd "of year" yyyy') AS Tomorrow;

-- 5. Employee details with increased salary and annual pay increase
SELECT lastName, firstName, departmentName, monthlySalary,
       ROUND(monthlySalary * 1.035, 0) AS GoodSalary,
       ROUND((monthlySalary * 1.035 - monthlySalary) * 12, 0) AS AnnualPayIncrease
FROM employees
JOIN departments ON employees.departmentID = departments.departmentID
WHERE departments.departmentID IN (20, 50, 60);

-- 6. Create a query that outputs employees, listing their id, name, the department namethey work in, the date they were hired, and the number of years
SELECT employeeID, lastName, firstName, departmentName, hireDate,
       DATEDIFF(YEAR, hireDate, GETDATE()) AS YearsWorked
FROM employees
JOIN departments ON employees.departmentID = departments.departmentID
ORDER BY YearsWorked DESC;

-- 7. Create a query that returns a list of employees whom work in the IT department andwhose first name starts with a ‘B’ OR their last name starts with an ‘L’.
SELECT employeeID, lastName, firstName, departmentName, hireDate
FROM employees
JOIN departments ON employees.departmentID = departments.departmentID
WHERE departmentName = 'IT' AND (firstName LIKE 'B%' OR lastName LIKE 'L%');

-- 8. Create the required statements to insert yourself as an employee
INSERT INTO employees (employeeID, firstName, lastName, email, phoneNumber, hireDate, jobID, monthlySalary, managerID, departmentID)
VALUES 
    (224, 'Jadhusan', 'Sadhik', 'jmohammedsadhik@myseneca.ca', '123-456-7890', GETDATE(), 'Clerk', 8000, 225, 80),
    (225, 'Safoura', 'Janosepah', 'safoura.janosepah@senecapolytechnic.ca', '987-654-3210', '2024-01-03', 'Sales Mgr', 10000, NULL, 80);

-- 9. Congrats to Bruce Ernst as he just received a $500 per month raise.
UPDATE employees
SET monthlySalary = monthlySalary + 500
WHERE employeeID = 104;

-- 10. Write the statements to delete both your professor and yourself from the database.
DELETE FROM employees
WHERE employeeID IN (224, 225);