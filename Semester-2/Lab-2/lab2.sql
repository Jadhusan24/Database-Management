-- Jadhusan M Sadhik
-- 155547227
-- jmohammedsadhik@myseneca.ca


USE dbs710Sample;
GO
----------------------------Q1 A-------------------------------------------
-- Displaying the lowest salary, average salary, highest salary, and differences:

-- Selecting the minimum (lowest) salary in the company
SELECT
    MIN(monthlySalary) AS LowestSalary,
    -- Calculating the average salary in the company
    AVG(monthlySalary) AS AverageSalary,
    -- Selecting the maximum (highest) salary in the company
    MAX(monthlySalary) AS HighestSalary,
    -- Calculating the difference between the lowest and average salaries
    AVG(monthlySalary) - MIN(monthlySalary) AS DifferenceLowestToAverage,
    -- Calculating the difference between the highest and average salaries
    MAX(monthlySalary) - AVG(monthlySalary) AS DifferenceHighestToAverage
-- From the 'employees' table
FROM employees;

--------------------------------------------------------------------------------------------------------------------
----------------------------Q2 A-------------------------------------------

-- Displaying the number of employees for each job in the same department with more than one person
SELECT
    departmentID,
    jobID,
    COUNT(*) AS NumberOfEmployees
FROM employees
GROUP BY departmentID, jobID
HAVING COUNT(*) > 1
ORDER BY NumberOfEmployees DESC;

--------------------------------------------------------------------------------------------------------------------
----------------------------Q3 A-------------------------------------------

-- Displaying job titles and total monthly compensation for jobs that require more than $7,000 per month
SELECT
    jobID,
    SUM(monthlySalary + ISNULL(commissionPercent * monthlySalary, 0)) AS TotalMonthlyCompensation
FROM employees
GROUP BY jobID
HAVING SUM(monthlySalary + ISNULL(commissionPercent * monthlySalary, 0)) > 7000
ORDER BY TotalMonthlyCompensation DESC;

--------------------------------------------------------------------------------------------------------------------
----------------------------Q4 A-------------------------------------------
-- Displaying the number of employees supervised by each manager and their annual salary
SELECT
    M.employeeID AS ManagerID,
    M.firstName AS ManagerFirstName,
    M.lastName AS ManagerLastName,
    COUNT(E.employeeID) AS SupervisedPersons,
    SUM(E.monthlySalary * 12) AS AnnualSalary
FROM employees M
JOIN employees E ON M.employeeID = E.managerID
WHERE E.monthlySalary * 12 <= 200000
GROUP BY M.employeeID, M.firstName, M.lastName
ORDER BY SupervisedPersons DESC;


--------------------------------------------------------------------------------------------------------------------
----------------------------Q5 A-------------------------------------------
-- Displaying the number of employees in each department with more than 5 years of service
SELECT
    d.departmentID,
    d.departmentName,
    COUNT(e.employeeID) AS EmployeesWithMoreThan5Years
FROM departments d
LEFT JOIN employees e ON d.departmentID = e.departmentID
WHERE DATEDIFF(YEAR, e.hireDate, GETDATE()) > 5 OR e.departmentID IS NULL
GROUP BY d.departmentID, d.departmentName;

----------------------------Q5 B-------------------------------------------
-- BONUS: Determining the overall total number of watches required using the first query
SELECT
    SUM(EmployeesWithMoreThan5Years) AS OverallTotalWatches
FROM (
    -- The first query to get the count of employees in each department with more than 5 years of service
    SELECT
        d.departmentID,
        d.departmentName,
        COUNT(e.employeeID) AS EmployeesWithMoreThan5Years
    FROM departments d
    LEFT JOIN employees e ON d.departmentID = e.departmentID
    WHERE DATEDIFF(YEAR, e.hireDate, GETDATE()) > 5 OR e.departmentID IS NULL
    GROUP BY d.departmentID, d.departmentName
) AS DepartmentCounts;


/*
Q1 A:
This set of instructions helps find important information about how much people are paid in the company. It figures out the smallest, average, and largest salaries. It also looks at the differences between the smallest and average salaries and between the largest and average salaries. This is useful for understanding how salaries are spread out in the company.

Q1 B:
The answers from the questions about salaries give us a good idea about how people are paid in the company. By comparing the smallest, average, and largest salaries, we can see if there are any big differences. These differences can show if some people are paid much more or less than the average.

Q2 A:
This part helps us find out how many people do the same job in the same part of the company. It only looks at jobs where there is more than one person doing the same thing. The list is organized to show jobs with the most people first.

Q2 B:
The information we get from finding how many people do the same job in a department is helpful. If there are many people in a role, it might mean that the job is very important. On the other hand, if there are fewer people, it could be a specialized job or we might need more staff. The list is organized to help us find areas where we might have too many or too few staff.

Q3 A:
This part shows the names of jobs and how much money they cost each month. It only includes jobs that need more than $7,000 per month. The list is organized to show the jobs that cost the most first.

Q3 B:
The results from this list give us good information for planning how much money we need for different jobs. Executives can use this data to decide where to put their resources and make sure the company's budget for staff matches its goals. The organized list helps focus on jobs that have the biggest impact.

Q4 A:
This part shows how many people each manager is in charge of and how much money they earn in a year. It only includes managers who earn less than $200,000 per year.

Q5 A:
This part helps us know how many people in each part of the company have worked for more than 5 years. It also includes people who are not linked to any specific part of the company.

Q5 B:
The bonus part helps us figure out how many watches we need for employees who have worked for more than 5 years. It adds up the counts from each part to give us the total number of watches needed.*/