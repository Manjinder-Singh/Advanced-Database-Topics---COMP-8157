-- Manjinder Singh(110097177)
-- Answer 1
Create Database BankData;
Use BankData;
CREATE TABLE BankAccount ( AccountNumber INT PRIMARY KEY, Balance DECIMAL(10, 2) );
Insert into BankAccount values(1, 1000);

-- Answer 2
-- Transaction number - 1 Concurrency Problem
BEGIN TRANSACTION;

DECLARE @WithdrawAmountForTrans1 DECIMAL(10, 2); -- Variable for storing withdrawal amount for transaction 1.
SET @WithdrawAmountForTrans1 = 100; -- Setting withdrawal amount for transaction 1.

DECLARE @CurrentBalanceForTrans1 DECIMAL(10, 2); -- Variable for storing current balance for account number 1.
SELECT @CurrentBalanceForTrans1 = Balance
FROM BankAccount
WHERE AccountNumber = 1; -- Storing value of current balance from database to the variable "@CurrentBalanceForTrans1".

WAITFOR DELAY '00:00:10' -- Adding delay of 10 seconds while transaction 2 already updates the value of balance.



-- Checking Balance if it is more than or equal to the withdrawal amount then only transacion  will take place.
IF (@CurrentBalanceForTrans1 >= @WithdrawAmountForTrans1)
BEGIN
  -- Deduct the amount based on the 1st transaction instance without considering the update made by the second transaction.
  -- Amount 100 is getting deducted from 1000 in transaction 1 even though transaction 2 updated the value from 1000 to 950 but still it wont consider the latest updated value.
    PRINT CONCAT('Balance stored for account num - 1(1st Instance):- ', @CurrentBalanceForTrans1);
	PRINT CONCAT('Amount to be withdrawn for account num - 1(1st Instance):- ',  @WithdrawAmountForTrans1);
	DECLARE @Balance_var DECIMAL(10, 2);
	set @Balance_var = @CurrentBalanceForTrans1 - @WithdrawAmountForTrans1
	PRINT CONCAT('Balance Left After Transaction 1 in 1st Instance:- ',@Balance_var);
	
	UPDATE BankAccount
	SET Balance = @Balance_var
	WHERE AccountNumber = 1;
    PRINT 'Amount is Deducted based on the 1st transaction instance in the database without considering the update already made by the second transaction.'
	
	select * from BankAccount;
END

ELSE
BEGIN
PRINT 'Insufficient balance, rollback the transaction number 2';
	ROLLBACK;
END

COMMIT TRANSACTION;


