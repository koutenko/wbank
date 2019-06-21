/*********************************
CIS435 - SQL Server Lab
Class Project
CIS435_Sp_AccountTypeList.sql
Authors: Dane McClain, Sam Walton
*********************************/

IF OBJECT_ID ('spAccountTypeList') IS NOT NULL
	DROP PROC spAccountTypeList;
GO

CREATE PROC spAccountTypeList
	@AcctType VARCHAR(20)
AS

	SELECT *
	FROM Customers JOIN AccountType
		ON Customers.AccountTypeID = AccountType.AccountTypeID
	WHERE AccountType.AccountType NOT IN
		(SELECT @AcctType
		 FROM AccountType);
GO