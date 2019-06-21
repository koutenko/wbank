/*********************************
CIS435 - SQL Server Lab
Class Project
CIS435_SelectChecking.sql
Authors: Dane McClain, Sam Walton
*********************************/

SELECT CustomerID, dbo.fn_getFullName(FName, LName) AS 'Full Name', DateCreated, 
		AccountNumber, Customers.AccountTypeID, Gender, 
		Address, City, State, PhoneNumber, AccountType
FROM Customers JOIN AccountType
	ON Customers.AccountTypeID = AccountType.AccountTypeID
WHERE Customers.AccountTypeID = 1;

