/*********************************
CIS435 - SQL Server Lab
Class Project
CIS435_CreateWBank.sql
Authors: Dane McClain, Sam Walton
*********************************/

/* ---- CREATE DATABASE ---- */
CREATE DATABASE WBank;
GO

USE WBank;

/* ---- CREATE TABLES STORED PROCEDURE ---- */
IF OBJECT_ID ('spCreateTables') IS NOT NULL
	DROP PROC spCreateTables;
GO

CREATE PROC spCreateTables
AS

	CREATE TABLE Locations
		(LocationID				INT				PRIMARY KEY IDENTITY,
		 LocationCode			VARCHAR(10)		NOT NULL DEFAULT 0,
		 Address				VARCHAR(50)		NULL,
		 City					VARCHAR(50)		NULL,
		 State					CHAR(2)			NULL);

	CREATE TABLE AccountType
		(AccountTypeID			INT				PRIMARY KEY IDENTITY,
		 AccountType			VARCHAR(40)		NOT NULL);

	CREATE TABLE Employees
		(EmployeeID				INT				PRIMARY KEY IDENTITY,
		 EmployeeNumber			CHAR(6)			NULL,
		 FirstName				VARCHAR(20)		NULL,
		 LastName				VARCHAR(50)		NOT NULL,
		 Title					VARCHAR(50)		NULL,
		 CanCreateNewAccount	BIT				NULL,
		 HourlySalary			SMALLMONEY		NULL DEFAULT 0,
		 Address				VARCHAR(50)		NULL,
		 City					VARCHAR(50)		NULL,
		 State					CHAR(2)			NULL);

	CREATE TABLE Customers
		(CustomerID				INT				PRIMARY KEY IDENTITY,
		 DateCreated			DATETIME		NULL,
		 AccountNumber			VARCHAR(20)		NULL,
		 AccountTypeID			INT				NULL REFERENCES AccountType (AccountTypeID),
		 FName					VARCHAR(50)		NULL,
		 LName					VARCHAR(50)		NULL,
		 Gender					CHAR(1)			NOT NULL CHECK (Gender LIKE '[FM]'),
		 Address				VARCHAR(50)		NULL,
		 City					VARCHAR(50)		NULL,
		 State					CHAR(2)			NULL,
		 PhoneNumber			CHAR(14)		NULL);

	CREATE TABLE Deposits
		(DepositID				INT				PRIMARY KEY IDENTITY,
		 LocationID				INT				NOT NULL REFERENCES Locations (LocationID),
		 EmployeeID				INT				NOT NULL REFERENCES Employees (EmployeeID),
		 CustomerID				INT				NOT NULL REFERENCES Customers (CustomerID),
		 DepositDate			DATETIME		NOT NULL,
		 DepositAmount			SMALLMONEY		NOT NULL CHECK (DepositAmount > 0));

	CREATE TABLE Withdrawals
		(WithdrawalID			INT				PRIMARY KEY IDENTITY,
		 LocationID				INT				NOT NULL REFERENCES Locations (LocationID),
		 EmployeeID				INT				NOT NULL REFERENCES Employees (EmployeeID),
		 CustomerID				INT				NOT NULL REFERENCES Customers (CustomerID),
		 WithdrawalDate			DATETIME		NOT NULL,
		 WithdrawalAmount		SMALLMONEY		NOT NULL CHECK (WithdrawalAmount > 0),
		 WithdrawalSuccessful	BIT				NOT NULL);

	CREATE TABLE CheckCashing
		(CheckCashingID			INT				PRIMARY KEY IDENTITY,
		 LocationID				INT				NOT NULL REFERENCES Locations (LocationID),
		 EmployeeID				INT				NOT NULL REFERENCES Employees (EmployeeID),
		 CustomerID				INT				NOT NULL REFERENCES Customers (CustomerID),
		 CheckCashingDate		DATETIME		NOT NULL,
		 CheckCashingAmount		SMALLMONEY		NOT NULL CHECK (CheckCashingAmount > 0));

	CREATE INDEX IX_Customers_AccountTypeID
		ON Customers (AccountTypeID);
	CREATE INDEX IX_Deposits_LocationID
		ON Deposits (LocationID);
	CREATE INDEX IX_Deposits_EmployeeID
		ON Deposits (EmployeeID);
	CREATE INDEX IX_Deposits_CustomerID
		ON Deposits (CustomerID);
	CREATE INDEX IX_Withdrawals_LocationID
		ON Withdrawals (LocationID);
	CREATE INDEX IX_Withdrawals_EmployeeID
		ON Withdrawals (EmployeeID);
	CREATE INDEX IX_Withdrawals_CustomerID
		ON Withdrawals (CustomerID);
	CREATE INDEX IX_CheckCashing_LocationID
		ON CheckCashing (LocationID);
	CREATE INDEX IX_CheckCashing_EmployeeID
		ON CheckCashing (EmployeeID);
	CREATE INDEX IX_CheckCashing_CustomerID
		ON CheckCashing (CustomerID);

	PRINT 'Create Tables Success';
GO
/* ---- END CREATE TABLES PROCEDURE ---- */

/* ---- LOCATION TABLE STORED PROCEDURE ---- */
IF OBJECT_ID ('spLocationData') IS NOT NULL
	DROP PROC spLocationData;
GO

CREATE PROC spLocationData
AS

	/* Declared Variables */
	DECLARE @genLocCode VARCHAR(255);
	DECLARE @tempLocCode VARCHAR(255);
	DECLARE @newLocCode VARCHAR(10);
	DECLARE @count INT;
	DECLARE @myRowCount INT;

	/* Populate Location Table */
	INSERT INTO Locations
				(City, State)
			VALUES
				('Boston', 'MA'),
				('New York', 'NY'),
				('Philadelphia', 'PA'),
				('Cleveland', 'OH'),
				('Richmond', 'VA'),
				('Atlanta', 'GA'),
				('Chicago', 'IL'),
				('St. Louis', 'MO'),
				('Minneapolis', 'MN'),
				('Kansas', 'MO');

	SET @myRowCount = @@ROWCOUNT;

	/* Generate Unique Location Codes for the 10 Locations */
	IF @myRowCount = 10
		SET @count = 1;

		WHILE @count >= 1 AND @count <= 10
			BEGIN
				SET @genLocCode = LEFT(CAST(CAST(CEILING(RAND()*10000000000)AS BIGINT)AS VARCHAR), 9);
				SET @tempLocCode = CONVERT(VARCHAR, @genLocCode, 9)
				SET @newLocCode = LEFT(@tempLocCode, 8) + '-' + SUBSTRING(@tempLocCode, 8, 1);

				UPDATE Locations
				SET LocationCode = @newLocCode
				WHERE LocationID = @count;

				SET @count = @count + 1;
			END;

	PRINT 'Location Tables Success';
GO
/* ---- END LOCATION TABLE PROCEDURE ---- */

/* ---- ACCOUNT TYPE STORED PROCEDURE ---- */
IF OBJECT_ID ('spAccountTypeData') IS NOT NULL
	DROP PROC spAccountTypeData;
GO

CREATE PROC spAccountTypeData
AS

	/* Populate AccountType Table */
	INSERT INTO AccountType
		(AccountType)
	VALUES
		('Checking'),
		('Savings'),
		('Business');

	PRINT 'Account Tables Success';
GO
/* ---- END ACCOUNT TYPE PROCEDURE ---- */

/* ---- EMPLOYEE TABLE STORED PROCEDURE ---- */
IF OBJECT_ID ('spEmployeeData') IS NOT NULL
	DROP PROC spEmployeeData;
GO

CREATE PROC spEmployeeData
AS

	/* Declared Variables */
	DECLARE @genEmpNum uniqueidentifier;
	DECLARE @tempEmpNum VARCHAR(255);
	DECLARE @newEmpNum CHAR(6);
	DECLARE @count INT;
	DECLARE @myRowCount INT;

	/* Populate Employee Table */
	INSERT INTO Employees
		(FirstName, LastName, Address, State)
	VALUES
		('Daniel', 'Hardcastle', '3012 Cobblestone Drive', 'VA'),
		('Yahtzee', 'Croshaw', '1213 Codebase Avenue', 'NY'),
		('Jim', 'Sterling', '8456 North Highway', 'NY'),
		('Jordan', 'Underneath', '5467 Mount Vernon Road', 'CO'),
		('Eli', 'Gripes', '8675 Waddell Street', 'KS'),
		('John', 'Enter', '0264 Schomburg Road', 'CA'),
		('Chris', 'Stuckman', '0256 West Belleview', 'CA'),
		('Manga', 'Minx', '5643 Osprey Street', 'CO'),
		('Jon', 'Tron', '5647 Clarke Drive', 'CA'),
		('Rob', 'Dyke', '9147 Apoka Vineland Road', 'NY'),
		('Lindsey', 'Stirling', '0215 Saint Marys Road', 'CA'),
		('Matthew', 'Santoro', '7641 Southwest Avenue', 'CA'),
		('Mike', 'Jeavons', '4867 39th Street', 'CO'),
		('Doug', 'Walker', '1894 14th Avenue', 'CA'),
		('Jonny', 'Ethco', '0258 W State Road', 'NY'),
		('Creeps', 'McPasta', '0367 Church Street', 'CO'),
		('Madame', 'Macabre', '8717 Ash Street', 'WA'),
		('Jared', 'Knabenbauer', '1587 Bombay Lane', 'CA'),
		('Sia', 'Creation', '6519 Allatoona Landing Road', 'KS'),
		('Lani', 'Pator', '6996 Team Drive', 'TX'),
		('Taka', 'Hata', '7564 Four Star Boulevard', 'TX'),
		('James', 'Nova', '6590 Hartley Bridge Road', 'TX'),
		('Dexter', 'Manning', '0345 Gulf Breeze Parkway', 'TX'),
		('Dan', 'Newz', '9436 Clark Drive', 'TX'),
		('David', 'Bennett', '0505 Steam Street', 'CA'),
		('Isabella', 'Bennet', '7818 Powered Road', 'CA'),
		('Sam', 'Luke', '5649 Giraffe Avenue', 'CA'),
		('Steve', 'Negrete', '1455 Rex Marksley Road', 'CA'),
		('Curtis', 'Thomas', '3620 Gorey Boulevard', 'CA'),
		('Erik', 'Lensherr', '0254 Demise Avenue', 'CA'),
		('Robert', 'Stine', '9456 Goosebumps Road', 'MA'),
		('Stephen', 'King', '8784 Shining Street', 'MA'),
		('Vincent', 'Cava', '9810 Confessions Road', 'NY'),
		('Edgar', 'Poe', '0248 Raven Road', 'VT'),
		('Howard', 'Lovecraft', '4702 Innsmouth Boulevard', 'VA'),
		('Bram', 'Stoker', '8754 Dracula Road', 'ND'),
		('Mary', 'Shelley', '4684 Frankenstein Street', 'SD'),
		('Dante', 'Alighieri', '0514 Inferno Road', 'PA'),
		('James', 'Sunderland', '7290 Silent Hill Avenue', 'WV'),
		('Harry', 'Mason', '8789 Silent Hill Boulevard', 'PA'),
		('Heather', 'Mason', '0646 Silent Hill Boulevard', 'PA'),
		('Yuri', 'Kozukata', '0814 Fatal Street', 'WA'),
		('Miu', 'Hinasaki', '0216 Frame Road', 'WA'),
		('Alexander', 'Brennenburg', '6981 Brennenburg Avenue', 'AK'),
		('Justine', 'Florbelle', '9875 Brennenburg Avenue', 'AK'),
		('Lisa', 'Trevor', '2597 Spencer Mansion Avenue', 'ME'),
		('Albert', 'Wesker', '3598 Spencer Mansion Avenue', 'ME'),
		('Ellen', 'Ripley', '5168 Sulaco Road', 'HI'),
		('Amanda', 'Ripley', '7148 Sulaco Road', 'HI'),
		('Toby', 'Fox', '1234 Undertale Road', 'MA');

	SET @myRowCount = @@ROWCOUNT;

	/* Generate Unique Employee Numbers for the 50 Employees */
	IF @myRowCount = 50
		SET @count = 1

		WHILE @count >= 1 AND @count <= 50
			BEGIN
				SET @genEmpNum = NEWID()
				SET @tempEmpNum = CONVERT(varchar(255), @genEmpNum)
				SET @newEmpNum = SUBSTRING(@tempEmpNum, 1, 6)

				UPDATE Employees
				SET EmployeeNumber = @newEmpNum
				WHERE EmployeeID = @count

				SET @count = @count + 1
			END;

	PRINT 'Employee Tables Success';
GO
/* ---- END EMPLOYEE TABLE PROCEDURE ---- */

/* ---- CUSTOMER TABLE STORED PROCEDURE ---- */
IF OBJECT_ID ('spCustomerData') IS NOT NULL
	DROP PROC spCustomerData;
GO

CREATE PROC spCustomerData
AS

	/* Declared Variables */
	DECLARE @genPhoneNum VARCHAR(255);
	DECLARE @tempPhoneNum VARCHAR(255);
	DECLARE @newPhoneNum VARCHAR(14);
	DECLARE @count INT;
	DECLARE @acctCount INT;
	DECLARE @myRowCount INT;

	/* Populate Customer Table */
	INSERT INTO Customers
		(FName, LName, Gender, Address, State)
	VALUES
		('Arin', 'Hanson', 'M', '4005 Grump Drive', 'CA'),
		('Daniel', 'Avidan', 'M', '3750 Unicorn Way', 'CA'),
		('Barry', 'Kramer', 'M', '1250 Bergie Court', 'NV'),
		('Suzy', 'Berhow', 'F', '1100 Mortimer Place', 'WA'),
		('Ross', 'O''Donovan', 'M', '9999 Perth Road', 'NY'),
		('Holly', 'Conrad', 'F', '1919 Birb Landing', 'TX'),
		('Kevin', 'Abernathy', 'M', '415 Friscotown Road', 'NY'),
		('Clarke', 'Griffin', 'F', '2930 Princess Street', 'PA'),
		('Bellamy', 'Blake', 'M', '4720 Rebel Trail', 'TX'),
		('Jasper', 'Jordan', 'M', '1415 Precious Lane', 'NY'),
		('Monty', 'Green', 'M', '1700 Cinnamon Street', 'NY'),
		('Octavia', 'Blake', 'F', '2300 Roll Road', 'NY'),
		('Maya', 'Vie', 'F', '1777 Revolutionary Highway', 'VA'),
		('Abigail', 'Griffin', 'F', '1813 Doctor Road', 'CT'),
		('Marcus', 'Kane', 'M', '578 Perfect Circle', 'GA'),
		('Thelonius', 'Jaha', 'M', '16 Hair Street', 'AK'),
		('Wells', 'Jaha', 'M', '4512 Forever Court', 'MA'),
		('Finn', 'Jones', 'M', '2780 Triangle Street', 'NJ'),
		('Kala', 'Dandekar', 'F', '1420 Bombay Temple Avenue', 'SC'),
		('Nomi', 'Marks', 'F', '1337 Pride Trace', 'CA'),
		('Sun', 'Bak', 'F', '1731 White Wolf Road', 'FL'),
		('Riley', 'Blue', 'F', '1840 Iceland Street', 'NY'),
		('Wolfgang', 'Bogdanow', 'M', '9001 Diamond Avenue', 'FL'),
		('Lito', 'Rodriguez', 'M', '87 Hernando Place', 'NY'),
		('Capheus', 'VanDamme', 'M', '100 Nairobi Court', 'CA'),
		('Will', 'Gorski', 'M', '5580 Chicago Boulevard', 'TN'),
		('Miklos', 'Lind', 'M', '6700 5th Avenue', 'NY'),
		('Marieke', 'Lind', 'F', '1280 Denmark Road', 'CA'),
		('Traejan', 'Lightrend', 'M', '8008 Hunter''s Chase', 'CA'),
		('Calen', 'Lismore', 'M', '1960 Kaiju Court', 'CA'),
		('Kylar', 'Stroud', 'M', '675 Still Loch Path', 'CO'),
		('Arin', 'Stroud', 'M', '2300 Bridle Lane', 'CO'),
		('Alphys', 'Dino', 'F', '3250 Hotland Road', 'NY'),
		('Undyne', 'Salmon', 'F', '27 Knights Avenue', 'ND'),
		('Toriel', 'Dreemurr', 'F', '10 Ruins Landing', 'GA'),
		('Muffet', 'Spiderly', 'F', '83 Arachnid Point', 'FL'),
		('Asriel', 'Dreemurr', 'M', '4300 Flowerfield Street', 'VA'),
		('Asgore', 'Dreemurr', 'M', '1 Home Road', 'ME'),
		('Temmie', 'Tem', 'F', '111 Hoi Street', 'CA'),
		('Sans', 'Gaster', 'M', '1290 Get Road', 'PA'),
		('Papyrus', 'Cook', 'M', '700 Dunked Boulevard', 'PA'),
		('Frisk', 'Chara', 'F', '12 On Trace', 'WA'),
		('Meta', 'Ton', 'M', '9021 Hollywood Avenue', 'CA'),
		('Rosefica', 'Riverglint', 'F', '3430 Bakers Road', 'FL'),
		('Rosearnica', 'Riverglint', 'F', '300 Priestess Court', 'NC'),
		('Rosepunica', 'Riverglint', 'F', '444 Eaton Lane', 'WV'),
		('Vittani', 'Bloodfire', 'F', '1215 Huntress Trail', 'CA'),
		('Imrinde', 'Redmorn', 'F', '300 Sunshine Place', 'HI'),
		('Vi', 'Sovari', 'F', '1789 Gibbet Road', 'NJ'),
		('Durzo', 'Blint', 'M', '4321 Cenaria Avenue', 'MA');

	SET @myRowCount = @@ROWCOUNT;

	/* Generate Unique Phone Numbers and Set Datetime and Account Numbers for the 50 Customers */
		SET @count = 1;

		WHILE @count >= 1 AND @count <= 50
			BEGIN
				SET @acctCount = (SELECT TOP 1 AccountTypeID FROM AccountType
								 ORDER BY NEWID());
				SET @genPhoneNum = LEFT(CAST(CAST(CEILING(RAND()*10000000000)AS BIGINT)AS VARCHAR), 10);
				SET @tempPhoneNum = CONVERT(VARCHAR, @genPhoneNum, 10)
				SET @newPhoneNum = '(' + LEFT(@tempPhoneNum, 3) + ') ' + SUBSTRING(@tempPhoneNum, 3, 3) + '-' + SUBSTRING(@tempPhoneNum, 6, 4);

				UPDATE Customers
				SET PhoneNumber = @newPhoneNum
				WHERE CustomerID = @count;

				UPDATE Customers
				SET DateCreated = GETDATE()
				WHERE CustomerID = @count;

				UPDATE Customers
				SET AccountTypeID = @acctCount
				WHERE CustomerID = @count;

				SET @count = @count + 1;
			END;

	PRINT 'Customer Tables Success';
GO
/* ---- END CUSTOMER TABLE PROCEDURE ---- */

/* ---- DEPOSIT TABLE STORED PROCEDURE ---- */
IF OBJECT_ID ('spDepositData') IS NOT NULL
	DROP PROC spDepositData;
GO

CREATE PROC spDepositData
AS

	/* Declared Variables */
	DECLARE @getLocID INT;
	DECLARE @getEmpID INT;
	DECLARE @getCustID INT;
	DECLARE @getDate DATETIME;
	DECLARE @getAmount SMALLMONEY;
	DECLARE @count INT;

	/* Generate Data for the 50 Deposits */
	SET @count = 1;

		WHILE @count >= 1 AND @count <= 50
			BEGIN
				SET @getLocID = (SELECT TOP 1 LocationID FROM Locations
								 ORDER BY NEWID());
				SET @getEmpID = (SELECT TOP 1 EmployeeID FROM Employees
								 ORDER BY NEWID());
				SET @getCustID = (SELECT TOP 1 CustomerID FROM Customers
								  ORDER BY NEWID());
				SET @getDate = DATEADD(day, (ABS(CHECKSUM(NEWID())) % 3650), '2000-01-01');

				SET @getAmount = ROUND(CAST(0 + RAND(CHECKSUM(NEWID())) * 5000 AS SMALLMONEY), 2);

				INSERT INTO Deposits
					(LocationID, EmployeeID, CustomerID, DepositDate, DepositAmount)
				VALUES
					(@getLocID, @getEmpID, @getCustID, @getDate, @getAmount);

				SET @count = @count + 1;
			END;

	PRINT 'Deposit Tables Success';
GO
/* ---- END DEPOSIT TABLE PROCEDURE ---- */

/* ---- WITHDRAWAL TABLE STORED PROCEDURE ---- */
IF OBJECT_ID ('spWithdrawalData') IS NOT NULL
	DROP PROC spWithdrawalData;
GO

CREATE PROC spWithdrawalData
AS

	/* Declared Variables */
	DECLARE @getLocID INT;
	DECLARE @getEmpID INT;
	DECLARE @getCustID INT;
	DECLARE @getDate DATETIME;
	DECLARE @getAmount SMALLMONEY;
	DECLARE @getSuccess BIT;
	DECLARE @count INT;

	/* Generate Data for the 50 Withdrawals */
	SET @count = 1;

		WHILE @count >= 1 AND @count <= 50
			BEGIN
				SET @getLocID = (SELECT TOP 1 LocationID FROM Locations
								 ORDER BY NEWID());
				SET @getEmpID = (SELECT TOP 1 EmployeeID FROM Employees
								 ORDER BY NEWID());
				SET @getCustID = (SELECT TOP 1 CustomerID FROM Customers
								  ORDER BY NEWID());
				SET @getDate = DATEADD(day, (ABS(CHECKSUM(NEWID())) % 3650), '2000-01-01');

				SET @getAmount = ROUND(CAST(0 + RAND(CHECKSUM(NEWID())) * 500 AS SMALLMONEY), 2);

				SET @getSuccess = CONVERT(BIT, ROUND(1 * RAND(), 0));

				INSERT INTO Withdrawals 
					(LocationID, EmployeeID, CustomerID, WithdrawalDate, WithdrawalAmount, WithdrawalSuccessful)
				VALUES
					(@getLocID, @getEmpID, @getCustID, @getDate, @getAmount, @getSuccess);

				SET @count = @count + 1;
			END;

	PRINT 'Withdrawal Tables Success';
GO
/* ---- END WITHDRAWAL TABLE PROCEDURE ---- */

/* ---- CHECK CASHING TABLE STORED PROCEDURE ---- */
IF OBJECT_ID ('spCheckCashingData') IS NOT NULL
	DROP PROC spCheckCashingData;
GO

CREATE PROC spCheckCashingData
AS

	/* Declared Variables */
	DECLARE @getLocID INT;
	DECLARE @getEmpID INT;
	DECLARE @getCustID INT;
	DECLARE @getDate DATETIME;
	DECLARE @getAmount SMALLMONEY;
	DECLARE @getSuccess BIT;
	DECLARE @count INT;

	/* Generate Data for the 50 Checks Cashed */
	SET @count = 1;

		WHILE @count >= 1 AND @count <= 50
			BEGIN
				SET @getLocID = (SELECT TOP 1 LocationID FROM Locations
								 ORDER BY NEWID());
				SET @getEmpID = (SELECT TOP 1 EmployeeID FROM Employees
								 ORDER BY NEWID());
				SET @getCustID = (SELECT TOP 1 CustomerID FROM Customers
								  ORDER BY NEWID());
				SET @getDate = DATEADD(day, (ABS(CHECKSUM(NEWID())) % 3650), '2000-01-01');

				SET @getAmount = ROUND(CAST(0 + RAND(CHECKSUM(NEWID())) * 5000 AS SMALLMONEY), 2);

				INSERT INTO CheckCashing 
					(LocationID, EmployeeID, CustomerID, CheckCashingDate, CheckCashingAmount)
				VALUES
					(@getLocID, @getEmpID, @getCustID, @getDate, @getAmount);

				SET @count = @count + 1;
			END;

	PRINT 'Check Cashing Tables Success';
GO
/* ---- CHECK CASHING TABLE PROCEDURE ---- */

/* ---- EXECUTE PROCEDURES TO POPULATE DATABASE ---- */
IF OBJECT_ID ('spPopulateData') IS NOT NULL
	DROP PROC spPopulateData;
GO

CREATE PROC spPopulateData
AS
	BEGIN
		EXEC spCreateTables;
		EXEC spLocationData;
		EXEC spAccountTypeData;
		EXEC spEmployeeData;
		EXEC spCustomerData;
		EXEC spDepositData;
		EXEC spWithdrawalData;
		EXEC spCheckCashingData;
	END;
	PRINT 'Populate Data Tables Success';
GO
/* ---- END EXECUTE PROCEDURE ---- */

EXEC spPopulateData;
