--select * from SQLTutorial.dbo.EmployeeSalary
--select * from SQLTutorial.dbo.EmployeeDemographics
--select * from SQLTutorial.dbo.EmployeeSalary Full Outer Join SQLTutorial.dbo.EmployeeDemographics ON EmployeeSalary.EmployeeID = EmployeeDemographics.EmployeeID

--Create Table WarehouseEmployeeDemographics 
--(EmployeeID int, 
--FirstName varchar(50), 
--LastName varchar(50), 
--Age int, 
--Gender varchar(50)
--)

--Insert into WarehouseEmployeeDemographics VALUES
--(1001, 'Jim', 'Halpert', 30, 'Male'),
--(1002, 'Pam', 'Beasley', 30, 'Female'),
--(1003, 'Dwight', 'Schrute', 29, 'Male'),
--(1004, 'Angela', 'Martin', 31, 'Female'),
--(1005, 'Toby', 'Flenderson', 32, 'Male'),
--(1006, 'Michael', 'Scott', 35, 'Male'),
--(1007, 'Meredith', 'Palmer', 32, 'Female'),
--(1008, 'Stanley', 'Hudson', 38, 'Male'),
--(1009, 'Kevin', 'Malone', 31, 'Male')

--select * from SQLTutorial.dbo.EmployeeDemographics 
--UNION ALL
--select * from SQLTutorial.dbo.WarehouseEmployeeDemographics

--select * from SQLTutorial.dbo.EmployeeDemographics 
--UNION 
--select * from SQLTutorial.dbo.WarehouseEmployeeDemographics

--select EmployeeID,FirstName,LastName,
--CASE
--   WHEN AGE > 30 THEN 'Old'
--   ELSE 'Young'
--END AS AgeGrp
--from SQLTutorial.dbo.EmployeeDemographics 

--CTEs

--WITH CTE_emp AS (
-- Select FirstName, LastName,Gender,
-- AVG(Salary) OVER (PARTITION BY Gender) as avgsalry,
-- COUNT(Gender) OVER (PARTITION BY Gender) as gendercnt
-- from SQLTutorial.dbo.EmployeeDemographics emp Inner Join 
--SQLTutorial.dbo.EmployeeSalary sal
--on emp.EmployeeID = sal.EmployeeID
--)

----select * from CTE_emp
--select avgsalry, gendercnt from CTE_emp where avgsalry > 50000

--Temp tables

--create table #temp_empl (
--EmployeeID int, 
--FirstName varchar(50), 
--LastName varchar(50), 
--)

--select * from #temp_empl

--insert into #temp_empl 
--select EmployeeID, FirstName, LastName from SQLTutorial..EmployeeDemographics

--Stored procedure

--create procedure test2
--as 
--select * from EmployeeDemographics

--exec test2

--create procedure test3
--AS
--create table #temp_empl3 (
--JobTitle Varchar(100),
--EmployeesPerJob int,
--AvgAge int,
--AvgSalary int
--)

--insert into #temp_empl3
--   select JobTitle, count(JobTitle) as EmployeesPerJob, AVG(Age) as AvgAge, AVG(Salary) as AvgSalary
--   from SQLTutorial.dbo.EmployeeSalary inner join
--   SQLTutorial.dbo.EmployeeDemographics
--   on EmployeeSalary.EmployeeID = EmployeeDemographics.EmployeeID
--   group by JobTitle

--select * from  #temp_empl3


--EXEC test3
 

 select JobTitle, AVG(Salary) from SQLTutorial.dbo.EmployeeSalary group by JobTitle

 select JobTitle, AVG(Salary) over (partition by(JobTitle)) from SQLTutorial.dbo.EmployeeSalary

