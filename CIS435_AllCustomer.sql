/*********************************
CIS435 - SQL Server Lab
Class Project
CIS435_AllCustomer.sql
Authors: Dane McClain, Sam Walton
*********************************/

CREATE VIEW AllCustomer
AS
	SELECT FName, LName, Address, PhoneNumber
	FROM Customers JOIN Deposits
		ON Customers.CustomerID = Deposits.CustomerID
	WHERE DepositAmount > 1000.00;