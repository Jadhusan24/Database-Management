USE master;

DROP DATABASE IF EXISTS dbs710Sample;
CREATE DATABASE dbs710Sample;
GO
USE dbs710Sample;
GO

SET IMPLICIT_TRANSACTIONS ON;

-- This PART of script will drop all SEQUENCES and TABLES related to DEMO schema

DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS jobGrades;
DROP TABLE IF EXISTS jobHistory;

/*	This PART of the script creates SIX tables, polulates data, adds associated constraints
    and indexes for the DEMO user. */

-- --------------------------------------------------------------------
-- Create the COUNTRIES table to hold country information for customers
-- and company locations. 
-- LOCATIONS have a foreign key to this table.
-- --------------------------------------------------------------------
PRINT '******  Creating COUNTRIES table ....';

CREATE TABLE countries (
    countryID		char(2) PRIMARY KEY,
	countryName    nvarchar(40) COLLATE Latin1_General_CS_AS,
	regionID       tinyInt 
	);

-- --------------------------------------------------------------------
-- Create the LOCATIONS table to hold address information for company departments.
-- DEPARTMENTS has a foreign key to this table.
-- --------------------------------------------------------------------
PRINT '******  Creating LOCATIONS table ....';

CREATE TABLE locations (
	locationID		int	PRIMARY KEY,
    streetAddress	nvarchar(40),
    postalCode		nvarchar(12),
    city			nvarchar(30) COLLATE Latin1_General_CS_AS NOT NULL,
	stateProv		nvarchar(25),
	countryID		char(2),
	CONSTRAINT locations_countries_fk 
		FOREIGN KEY (countryID) REFERENCES countries(countryID)
    );

-- --------------------------------------------------------------------
-- Create the DEPARTMENTS table to hold company department information.
-- EMPLOYEES  has a foreign key to this table.
-- --------------------------------------------------------------------
PRINT '******  Creating DEPARTMENTS table ....';

CREATE TABLE departments (
	departmentID	int	PRIMARY KEY,
	departmentName nvarchar(30) NOT NULL,
    managerID      int,
    locationID     int,
	CONSTRAINT department_location_fk
		FOREIGN KEY (locationID) REFERENCES locations(locationID)
    );

-- ------------------------------------------------------------
-- Create the EMPLOYEES table to hold the employee personnel 
-- information for the company.
-- EMPLOYEES has a self referencing foreign key to this table.
-- ------------------------------------------------------------
PRINT '******  Creating EMPLOYEES table ....';

CREATE TABLE employees (
	employeeID		int		PRIMARY KEY,
    firstName		nvarchar(20) COLLATE Latin1_General_CS_AS,
    lastName		nvarchar(25) COLLATE Latin1_General_CS_AS NOT NULL,
    email			nvarchar(25) NOT NULL,
    phoneNumber		nvarchar(20),
    hireDate		smallDateTime NOT NULL DEFAULT (getdate()),
    jobID			nvarchar(10) NOT NULL,
    monthlySalary	decimal(8,2),
    commissionPercent  decimal(2,2),
    managerID		int,
    departmentID	int,
    CONSTRAINT emp_salary_chk CHECK (monthlySalary >= 0),
    CONSTRAINT emp_email_uk UNIQUE (email)
    );

ALTER TABLE employees
	ADD CONSTRAINT emp_dept_fk
		FOREIGN KEY (departmentID) REFERENCES departments(departmentID),
	CONSTRAINT emp_manager_fk
        FOREIGN KEY (managerID) REFERENCES employees(employeeID);

ALTER TABLE departments
ADD CONSTRAINT dept_mgr_fk
    FOREIGN KEY (managerID) REFERENCES employees (employeeID);

-- ------------------------------------------------------------------
-- Create the JOB_GRADES table that will show different SALARY GRADES 
-- depending on employee's SALARY RANGE
-- ------------------------------------------------------------------
PRINT '******  Creating JOB_GRADES table ....';

CREATE TABLE jobGrades (
	grade char(1) PRIMARY KEY,
	lowestSalary 	decimal(8,2) NOT NULL,
	highestSalary	decimal(8,2) NOT NULL
	);

-- DATA INSERTION
PRINT '******  Populating COUNTRIES table ....';

INSERT INTO countries VALUES 
    ( 'IT', 'Italy', 1), 
    ( 'JP', 'Japan', 3), 
    ( 'US', 'United States of America', 2),
	( 'CA', 'Canada', 2),
	( 'CN', 'China', 3),
	( 'IN', 'India', 3),
	( 'AU', 'Australia', 3),
	( 'ZW', 'Zimbabwe', 4),
	( 'SG', 'Singapore', 3),
	( 'UK', 'United Kingdom', 1),
	( 'FR', 'France', 1),
	( 'DE', 'Germany', 1),
	( 'ZM', 'Zambia', 4),
	( 'EG', 'Egypt', 4),
	( 'BR', 'Brazil', 2),
	( 'CH', 'Switzerland', 1),
	( 'NL', 'Netherlands', 1),
	( 'MX', 'Mexico', 2),
	( 'KW', 'Kuwait', 4),
	( 'IL', 'Israel', 4),
	( 'DK', 'Denmark', 1),
	( 'HK', 'HongKong', 3),
	( 'NG', 'Nigeria', 4),
	( 'AR', 'Argentina', 2),
	( 'BE', 'Belgium', 1);
COMMIT;

-- ***************************insert data into the LOCATIONS table
PRINT '******  Populating LOCATIONS table ....';

INSERT INTO locations VALUES 
    ( 1000, '1297 Via Cola di Rie', '00989', 'Roma', NULL, 'IT'),
	( 1100, '93091 Calle della Testa', '10934', 'Venice', NULL, 'IT'),
	( 1200, '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP'),
	( 1300, '9450 Kamiya-cho', '6823', 'Hiroshima', NULL, 'JP'),
	( 1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US'),
	( 1500, '2011 Interiors Blvd', '99236', 'south San Francisco', 'California', 'US'),
	( 1600, '2007 Zagora St', '50090', 'South Brunswick', 'New Jersey', 'US'),
	( 1700, '2004 Charade Rd', '98199', 'seattle', 'Washington', 'US'),
	( 1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA'),
	( 1900, '6092 Boxwood St', 'YSW 9T2', 'whitehorse', 'Yukon', 'CA'),
	( 2000, '40-5-12 Laogianggen', '190518', 'Beijing', NULL, 'CN'),
	( 2100, '1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra', 'IN'),
	( 2200, '12-98 Victoria Street', '2901', 'sydney', 'New South Wales', 'AU'),
	( 2300, '198 Clementi North', '540198', 'Singapore', NULL, 'SG'),
	( 2400, '8204 Arthur St', NULL, 'London', NULL, 'UK'),
	( 2500, 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK'),
	( 2600, '9702 Chester Road', '09629850293', 'Stretford', 'Manchester', 'UK'),
	( 2700, 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE'),
	( 2800, 'Rua Frei Caneca 1360 ', '01307-002', 'Sao Paulo', 'Sao Paulo', 'BR'),
	( 2900, '20 Rue des Corps-Saints', '1730', 'Geneva', 'Geneve', 'CH'),
	( 3000, 'Murtenstrasse 921', '3095', 'Bern', 'BE', 'CH'),
	( 3100, 'Pieter Breughelstraat 837', '3029SK', 'utrecht', 'Utrecht', 'NL'),
	( 3200, 'Mariano Escobedo 9991', '11932', 'Mexico City', 'Distrito Federal,', 'MX');
COMMIT;

-- ****************************insert data into the DEPARTMENTS table
PRINT '******  Populating DEPARTMENTS table ....';

-- disable integrity constraint to EMPLOYEES to load data
ALTER TABLE departments
	NOCHECK CONSTRAINT dept_mgr_fk;

INSERT INTO departments VALUES 
    ( 10, 'Administration', 200, 1700),
    ( 20, 'Marketing', 201, 1800),
	( 50, 'Shipping', 124, 1500),
	( 60, 'IT', 103, 1400),
	( 80, 'Sales', 149, 2500),
	( 90, 'Executive', 100, 1700),
	( 110, 'Accounting', 205, 1700),
	( 190, 'Contracting', NULL, 1700);
COMMIT;

ALTER TABLE departments
	CHECK CONSTRAINT dept_mgr_fk;

-- ***************************insert data into the EMPLOYEES table
PRINT '******  Populating EMPLOYEES table ....';

INSERT INTO employees VALUES 
	( 100,'steven','king','SKING','515.123.4567',CONVERT(date,'06/17/17',1),'AD_PRES',24000,NULL,NULL,90),
	( 101,'Neena','Kochhar','NKOCHHAR','515.123.4568',CONVERT(date,'09/21/19',1),'AD_VP',17000,NULL,100,90),
	( 102,'Lex','De Haan','LDEHAAN','515.123.4569',CONVERT(date,'01/13/13',1),'AD_VP',17000,NULL,100,90),
	( 103,'Alexander','Hunold','AHUNOLD','590.423.4567',CONVERT(date,'01/03/20',1),'IT_PROG',9000,NULL,102,60),
	( 104,'bruce','Ernst','BERNST','590.423.4568',CONVERT(date,'05/21/11',1),'IT_PROG',6000,NULL,103,60),
	( 107,'Diana','Lorentz','DLORENTZ','590.423.5567',CONVERT(date,'02/07/19',1),'IT_PROG',4200,NULL,103,60),
	( 124,'KEVIN','Mourgos','KMOURGOS','650.123.5234',CONVERT(date,'11/16/19',1),'ST_MAN',5800,NULL,100,50),
	( 141,'Trenna','rajs','TRAJS','650.121.8009',CONVERT(date,'10/17/15',1),'ST_CLERK',3500,NULL,124,50),
	( 142,'Curtis','Davies','CDAVIES','650.121.2994',CONVERT(date,'01/29/17',1),'ST_CLERK',3100,NULL,124,50),
	( 143,'Randall','Matos','RMATOS','650.121.2874',CONVERT(date,'03/15/18',1),'ST_CLERK',2600,NULL,124,50),
	( 144,'Peter','MacDougall','PMACDOUGALL','650.121.2004',CONVERT(date,'07/09/18',1),'ST_CLERK',2500,NULL,124,50),
	( 149,'Eleni','Zlotkey','EZLOTKEY','011.44.1344.429018',CONVERT(date,'01/29/20',1),'SA_MAN',10500,.2,100,80),
	( 174,'Ellen','ABEL','EABEL','011.44.1644.429267',CONVERT(date,'05/11/16',1),'SA_REP',11000,.30,149,80),
	( 176,'Jonathon','Taylor','JTAYLOR','011.44.1644.429265',CONVERT(date,'03/24/18',1),'SA_REP',8600,.20,149,80),
	( 178,'Kimberely','Grant','KGRANT','011.44.1644.429263',CONVERT(date,'05/24/19',1),'SA_REP',7000,.15,149,NULL),
	( 200,'Jennifer','Whalen','JWHALEN','515.123.4444',CONVERT(date,'09/17/07',1),'AD_ASST',4400,NULL,101,10),
	( 201,'Michael','Hartstein','MHARTSTE','515.123.5555',CONVERT(date,'02/17/16',1),'MK_MAN',13000,NULL,100,20),
	( 202,'Pat','Fay','PFAY','603.123.6666',CONVERT(date,'08/17/17',1),'MK_REP',6000,NULL,201,20),
	( 205,'Shelley','Higgins','SHIGGINS','515.123.8080',CONVERT(date,'06/07/14',1),'AC_MGR',12000,NULL,101,110),
	( 206,'William','Gietz','WGIETZ','515.123.8181',CONVERT(date,'06/07/14',1),'AC_ACCOUNT',8300,NULL,205,110);
COMMIT;

-- ***************************insert data into the JOB_GRADES table
PRINT '******  Populating JOB_GRADES table ....';

INSERT INTO jobGrades VALUES 
	('A',1000,2999),
	('B',3000,5999),
	('C',6000,9999),
	('D',10000,14999),
	('E',15000,24999),
	('F',25000,40000);
COMMIT;

--  Creating table JOB_HISTORY and populating data
PRINT '******  Creating JOB_HISTORY table ....';

CREATE TABLE jobHistory (
	employeeID   int NOT NULL,
	startDate    smallDateTime NOT NULL,
	endDate      smallDateTime NOT NULL,
	jobTitle        nvarchar(10)	NOT NULL,
	departmentID int,
    CONSTRAINT jhist_date_interval CHECK (enddate > startdate),
	CONSTRAINT jhist_pk PRIMARY KEY (employeeID, startdate),
	CONSTRAINT jhist_dept_fk
		FOREIGN KEY (departmentID) REFERENCES departments(departmentID)
    );

PRINT '******  Populating JOB_HISTORY table ....';

INSERT INTO jobHistory VALUES 
	(102, CONVERT(date,'01/13/13', 1), CONVERT(date,'07/24/18', 1), 'IT_PROG', 60),
	(101, CONVERT(date,'09/21/09', 1), CONVERT(date,'10/27/13', 1), 'AC_ACCOUNT', 110),
	(101, CONVERT(date,'10/28/13', 1), CONVERT(date,'03/15/17', 1), 'AC_MGR', 110),
	(201, CONVERT(date,'02/17/16', 1), CONVERT(date,'12/19/19', 1), 'MK_REP', 20),
	(114, CONVERT(date,'03/24/18', 1), CONVERT(date,'12/31/19', 1), 'ST_CLERK', 50),
	(122, CONVERT(date,'01/01/19', 1), CONVERT(date,'12/31/19', 1), 'ST_CLERK', 50),
	(200, CONVERT(date,'09/17/07', 1), CONVERT(date,'06/17/13', 1), 'AD_ASST', 90),
	(176, CONVERT(date,'03/24/18', 1), CONVERT(date,'12/31/18', 1), 'SA_REP', 80),
	(176, CONVERT(date,'01/01/19', 1), CONVERT(date,'12/31/19', 1), 'SA_MAN', 80),
	(200, CONVERT(date,'07/01/14', 1), CONVERT(date,'12/31/18', 1), 'AC_ACCOUNT', 90);
COMMIT;

CREATE INDEX emp_dept_idx ON employees (departmentID);
CREATE INDEX emp_job_idx ON employees (jobID);
CREATE INDEX emp_manager_idx ON employees (managerID);
CREATE INDEX emp_name_idx ON employees (lastName, firstName);
CREATE INDEX dept_location_idx ON departments (locationID);
CREATE INDEX loc_city_idx ON locations (city);
CREATE INDEX loc_state_province_idx	ON locations (stateProv);
CREATE INDEX loc_country_idx ON locations (countryID);

-- *********************************************
SET IMPLICIT_TRANSACTIONS OFF;
COMMIT;

PRINT '******  SCRIPT COMPLETE ******';