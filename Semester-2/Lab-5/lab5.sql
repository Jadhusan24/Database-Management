-- Jadhusan M Sadhik
-- 155547227
-- jmohammedsadhik@myseneca.ca

 --------------------------------------------------------------
USE dbs710Sample;
GO
 --------------------------------------------------------------

-- Task 1 ---------------------------------------------------------------------------------------------------------------------------
CREATE or alter FUNCTION fncCalcFactorial (@n INT)
RETURNS INT
AS
BEGIN
    DECLARE @result INT = 1;
    DECLARE @i INT = 1;

    WHILE @i <= @n
    BEGIN
        SET @result = @result * @i;
        SET @i = @i + 1;
    END

    RETURN @result;
END;
GO

-- Task 2 ---------------------------------------------------------------------------------------------------------------------------
CREATE or alter PROCEDURE spCalcCurrentSalary
    @EmployeeID INT
AS
BEGIN
    DECLARE @CurrentSalary DECIMAL(10, 2);
    DECLARE @VacationWeeks INT;
    DECLARE @HireDate DATE;
    DECLARE @YearsWorked INT;

    -- Check if employee exists
    IF NOT EXISTS (SELECT 1 FROM employees WHERE employeeID = @EmployeeID)
    BEGIN
        PRINT 'Employee with ID ' + CAST(@EmployeeID AS VARCHAR) + ' does not exist.';
        RETURN;
    END

    -- Get employee's hire date
    SELECT @HireDate = hireDate FROM employees WHERE employeeID = @EmployeeID;

    -- Calculate years worked
    SET @YearsWorked = DATEDIFF(YEAR, @HireDate, GETDATE());

    -- Calculate current salary
    SELECT @CurrentSalary = monthlySalary * POWER(1.04, @YearsWorked)
    FROM employees
    WHERE employeeID = @EmployeeID;

    -- Calculate vacation weeks
    IF @YearsWorked >= 3
        SET @VacationWeeks = CASE
                                WHEN @YearsWorked <= 6 THEN 2 + (@YearsWorked - 3)
                                ELSE 6
                             END
    ELSE
        SET @VacationWeeks = 2;

    -- Output results
    PRINT 'Current Salary: $' + CAST(@CurrentSalary AS VARCHAR);
    PRINT 'Vacation Weeks: ' + CAST(@VacationWeeks AS VARCHAR);
END;
GO

-- Task 3 ---------------------------------------------------------------------------------------------------------------------------
CREATE or alter PROCEDURE spDepartmentsReport
AS
BEGIN
    DECLARE @DeptID INT;
    DECLARE @DeptName NVARCHAR(50);
    DECLARE @City NVARCHAR(50);
    DECLARE @NumEmp INT;

    DECLARE dept_cursor CURSOR FOR
    SELECT d.departmentID, d.departmentName, l.city, COUNT(e.employeeID) AS NumEmp
    FROM departments d
    LEFT JOIN employees e ON d.departmentID = e.departmentID
    LEFT JOIN locations l ON d.locationID = l.locationID
    GROUP BY d.departmentID, d.departmentName, l.city;

    OPEN dept_cursor;
    FETCH NEXT FROM dept_cursor INTO @DeptID, @DeptName, @City, @NumEmp;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'DeptID: ' + CAST(@DeptID AS VARCHAR) + ', Department: ' + @DeptName +
              ', City: ' + @City + ', NumEmp: ' + CAST(@NumEmp AS VARCHAR);
        FETCH NEXT FROM dept_cursor INTO @DeptID, @DeptName, @City, @NumEmp;
    END

    CLOSE dept_cursor;
    DEALLOCATE dept_cursor;
END;
GO

-- Task 4 ---------------------------------------------------------------------------------------------------------------------------
CREATE or alter FUNCTION spDetermineWinningTeam (@gameID INT)
RETURNS INT
AS
BEGIN
    -- Return -1 for game not played, 0 for tie, and the winning team's ID otherwise
    	declare @winid int

	if (select Isplayed from sportLeagues.dbo.games where gameid = @gameid) = 0
		return -1;

	select @winid =
		case
			when homescore > visitscore then hometeam
			when homescore < visitscore then visitteam
			else 0
		end
	from sportLeagues.dbo.games where gameid = @gameid

	RETURN @winid;
END;
GO


create or alter function dbo.spDetermineWinningTeam (@gameid int)
returns int
as
begin

end
go

-- Execute tasks for sample outputs
-- Task 1: Execute fncCalcFactorial for 3 different input values
PRINT 'Factorial of 5: ' + CAST(dbo.fncCalcFactorial(5) AS VARCHAR);
PRINT 'Factorial of 7: ' + CAST(dbo.fncCalcFactorial(7) AS VARCHAR);
PRINT 'Factorial of 10: ' + CAST(dbo.fncCalcFactorial(10) AS VARCHAR);

-- Task 2: Execute spCalcCurrentSalary for 3 different employee IDs
EXEC spCalcCurrentSalary @EmployeeID = 101; -- Example employee ID
EXEC spCalcCurrentSalary @EmployeeID = 103; -- Example employee ID
EXEC spCalcCurrentSalary @EmployeeID = 105; -- Non-existent employee ID

-- Task 3: Execute spDepartmentsReport
EXEC dbo.spDepartmentsReport;

-- Task 4
select t.teamid, t.teamname, count(case when dbo.spDetermineWinningTeam(g.gameid) = t.teamid then 1 end) as totalgameswon
from sportLeagues.dbo.teams t left join sportLeagues.dbo.games g on t.teamid = g.hometeam or t.teamid = g.visitteam
group by t.teamid, t.teamname
order by totalgameswon desc