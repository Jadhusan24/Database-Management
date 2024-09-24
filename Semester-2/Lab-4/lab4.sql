-- Lab 4 - Code Procedures/Conditional Statements
-- Jadushan Mohommed 155547227

-- Task 1: Check if a number is even or odd
CREATE OR ALTER PROCEDURE CheckEvenOrOdd_Jadushan_Mohommed
    @number_even_odd INT
AS
BEGIN
    DECLARE @result NVARCHAR(50);
    SET @result =
        CASE WHEN @number_even_odd % 2 = 0 THEN 'The number is even.'
             ELSE 'The number is odd.' END;
    PRINT @result;
END;
GO

-- Task 2: Check if a number is prime
CREATE OR ALTER PROCEDURE CheckPrimeNumber_Jadushan_Mohommed
    @number_prime INT
AS
BEGIN
    DECLARE @is_prime BIT = 1;
    DECLARE @i INT = 2;

    IF @number_prime <= 1
        SET @is_prime = 0;
    ELSE IF @number_prime = 2
        SET @is_prime = 1;
    ELSE IF @number_prime % 2 = 0
        SET @is_prime = 0;
    ELSE
        WHILE @i <= @number_prime/2
        BEGIN
            IF @number_prime % @i = 0
            BEGIN
                SET @is_prime = 0;
                BREAK;
            END
            SET @i = @i + 1;
        END

    IF @is_prime = 1
        PRINT CAST(@number_prime AS NVARCHAR(20)) + ' is a prime number.'
    ELSE
        PRINT CAST(@number_prime AS NVARCHAR(20)) + ' is not a prime number.';
END;
GO

-- Task 3: Display employee information
CREATE OR ALTER PROCEDURE DisplayEmployeeInfo_Jadushan_Mohommed
    @employee_id_info INT
AS
BEGIN
    SELECT 
        firstName AS First_name, 
        lastName AS Last_name, 
        email AS Email, 
        phoneNumber AS Phone_number, 
        hireDate AS Hire_date, 
        jobID AS Job_title
    FROM employees
    WHERE employeeID = @employee_id_info;

    IF @@ROWCOUNT = 0
        PRINT 'Employee with ID ' + CAST(@employee_id_info AS NVARCHAR(10)) + ' not found.';
END;
GO

-- Task 4: Update salaries for a given department
CREATE OR ALTER PROCEDURE UpdateDepartmentSalaries_Jadushan_Mohommed
    @department_id_salary INT,
    @percentage_increase DECIMAL(5, 2)
AS
BEGIN
    DECLARE @rows_updated_salary INT;

    UPDATE employees
    SET monthlySalary = CASE WHEN monthlySalary > 0 THEN monthlySalary * (1 + @percentage_increase / 100)
                            ELSE monthlySalary END
    WHERE departmentID = @department_id_salary;

    SET @rows_updated_salary = @@ROWCOUNT;

    PRINT 'Number of rows updated: ' + CAST(@rows_updated_salary AS NVARCHAR(10));
END;
GO

-- Task 5: Update salaries based on average
CREATE OR ALTER PROCEDURE UpdateSalariesBasedOnAverage_Jadushan_Mohommed
AS
BEGIN
    DECLARE @avg_salary DECIMAL(10, 2);

    SELECT @avg_salary = AVG(monthlySalary)
    FROM employees;

    UPDATE employees
    SET monthlySalary = CASE WHEN @avg_salary <= 9000 THEN monthlySalary * 1.02
                             ELSE monthlySalary * 1.01 END
    WHERE monthlySalary < @avg_salary;

    PRINT 'Number of rows updated.';
END;
GO

-- Task 6: Categorize employees based on salary
CREATE OR ALTER PROCEDURE CategorizeEmployees_Jadushan_Mohommed
AS
BEGIN
    DECLARE @low_salary_cat INT = 0;
    DECLARE @fair_salary_cat INT = 0;
    DECLARE @high_salary_cat INT = 0;
    DECLARE @min_salary_cat DECIMAL(10, 2);
    DECLARE @max_salary_cat DECIMAL(10, 2);
    DECLARE @avg_salary DECIMAL(10, 2);

    SELECT @min_salary_cat = MIN(monthlySalary),
           @max_salary_cat = MAX(monthlySalary),
           @avg_salary = AVG(monthlySalary)
    FROM employees;

    SELECT 
        @low_salary_cat = SUM(CASE WHEN monthlySalary < (@avg_salary - @min_salary_cat) / 2 THEN 1 ELSE 0 END),
        @high_salary_cat = SUM(CASE WHEN monthlySalary > (@max_salary_cat - @avg_salary) / 2 THEN 1 ELSE 0 END),
        @fair_salary_cat = COUNT(*) - @low_salary_cat - @high_salary_cat
    FROM employees;

    PRINT 'Low: ' + CAST(@low_salary_cat AS NVARCHAR(10));
    PRINT 'Fair: ' + CAST(@fair_salary_cat AS NVARCHAR(10));
    PRINT 'High: ' + CAST(@high_salary_cat AS NVARCHAR(10));
END;
GO
