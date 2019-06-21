/*********************************
CIS435 - SQL Server Lab
Class Project
CIS435_Sp_EmployeePay.sql
Authors: Dane McClain, Sam Walton
*********************************/

IF OBJECT_ID ('spEmployeePay') IS NOT NULL
	DROP PROC spEmployeePay;
GO

CREATE PROC spEmployeePay
AS

	DECLARE @count INT;

	SET @count = 1;

	WHILE @count >= 1 AND @count <= 50
		BEGIN
			UPDATE Employees
			SET HourlySalary = HourlySalary + 1.00
			WHERE EmployeeID = @count

			SET @count = @count + 1;
		END;
GO