/*********************************
CIS435 - SQL Server Lab
Class Project
CIS435_EmployeeSameState.sql
Authors: Dane McClain, Sam Walton
*********************************/

CREATE VIEW EmployeeSameState
AS
	SELECT *
	FROM Employees
	WHERE State = 'CA';