-- Q1. Add an employee record for Jadushan Mohammad
INSERT INTO employees (employeeID, firstName, lastName, email, phoneNumber, hireDate, jobID, monthlySalary, commissionPercent, managerID, departmentID)
VALUES (123457856, 'Jadushan', 'Mohammad', 'jmohammad@seneca.ca', '64152878795', GETDATE(), 'AD_ASST', NULL, 0.21, 100, 90);

-- Q2. Update the salary of employees with last names Matos and Whalen
UPDATE employees
SET monthlySalary = 2500
WHERE lastName IN ('Matos', 'Whalen');

-- Part B – Sub-Queries

-- Q3. List last names of employees in the same department as Abel
SELECT lastName
FROM employees
WHERE departmentID = (
    SELECT departmentID
    FROM employees
    WHERE lastName = 'Abel'
);

-- Q4. Display the last name of the lowest paid employee(s)
SELECT lastName
FROM employees
WHERE monthlySalary = (
    SELECT MIN(monthlySalary)
    FROM employees
);

-- Q5. Show the city of the lowest paid employee(s)
SELECT city
FROM locations
WHERE locationID IN (
    SELECT locationID
    FROM employees
    WHERE monthlySalary = (
        SELECT MIN(monthlySalary)
        FROM employees
    )
);

-- Q6. Display last name, departmentID, and salary of the lowest paid employee(s) in each department. Sort by departmentID.
SELECT e.lastName, e.departmentID, e.monthlySalary
FROM employees e
JOIN (
    SELECT departmentID, MIN(monthlySalary) AS minSalary
    FROM employees
    GROUP BY departmentID
) AS deptMinSalary ON e.departmentID = deptMinSalary.departmentID AND e.monthlySalary = deptMinSalary.minSalary
ORDER BY e.departmentID;

-- Q7. Show the last name of the lowest paid employee(s) in each city.
SELECT e.lastName
FROM employees e
JOIN (
    SELECT l.city, MIN(e.monthlySalary) AS minSalary
    FROM employees e
    JOIN locations l ON e.locationID = l.locationID
    GROUP BY l.city
) AS locMinSalary ON e.locationID = (
    SELECT l.locationID
    FROM locations l
    WHERE l.city = locMinSalary.city
) AND e.monthlySalary = locMinSalary.minSalary;

-- Q8. Display last name, job title, and salary for employees with salaries matching those in the IT Department. Sort by salary ascending first and then by last name.
SELECT lastName, jobID, monthlySalary
FROM employees
WHERE monthlySalary IN (
    SELECT monthlySalary
    FROM employees
    WHERE departmentID IN (
        SELECT departmentID
        FROM departments
        WHERE departmentName = 'IT'
    )
)
ORDER BY monthlySalary, lastName;

-- Part C - Set Operators 

-- Q9. Generate a list of Department IDs for departments without ST_CLERK job
SELECT departmentID
FROM departments
WHERE departmentID NOT IN (
    SELECT departmentID
    FROM employees
    WHERE jobID = '210'
);

-- Q10. List countries with no departments located in them. Display country ID and name.
SELECT countryID, countryName
FROM countries
WHERE countryID NOT IN (
    SELECT DISTINCT countryID
    FROM locations
    WHERE countryID IS NOT NULL
);

-- Q11. Quickly provide a list of departments 10, 50, 20 in that order with job and department ID displayed.
SELECT jobID, departmentID
FROM employees
WHERE departmentID IN (10, 50, 20)
ORDER BY CASE departmentID
    WHEN 10 THEN 1
    WHEN 50 THEN 2
    WHEN 20 THEN 3
    ELSE 4
END;

-- Q12. Provide a single report with last name and department ID of all employees, and department ID and name of all departments.
SELECT lastName, departmentID
FROM employees
UNION ALL
SELECT NULL AS lastName, departmentID
FROM departments
UNION ALL
SELECT NULL AS lastName, NULL AS departmentID;
```