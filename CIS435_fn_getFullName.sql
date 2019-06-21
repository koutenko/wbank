/*********************************
CIS435 - SQL Server Lab
Class Project
CIS435_fn_getFullName.sql
Authors: Dane McClain, Sam Walton
*********************************/

CREATE FUNCTION fn_getFullName
	(@firstName VARCHAR(50),
	 @lastName VARCHAR(50))
	 RETURNS VARCHAR(101)
BEGIN
	RETURN (SELECT @firstName + ' ' + @lastName);
END;