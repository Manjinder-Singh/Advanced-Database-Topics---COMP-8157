-- Manjinder Singh(110097177)
Create Database BankData;
Use BankData;
CREATE TABLE BankAccount ( AccountNumber INT PRIMARY KEY, Balance DECIMAL(10, 2) );
Insert into BankAccount values(1, 1000);

-- Transaction number - 3 Solution to Concurrency Problem
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ -- Isolation Level set to Repeatable Read.

DECLARE @WithdrawAmountForTrans3 DECIMAL(10, 2); -- Variable for storing withdrawal amount for transaction 3.
SET @WithdrawAmountForTrans3 = 100; -- Setting withdrawal amount for transaction 3.

DECLARE @CurrentBalanceForTrans3 DECIMAL(10, 2); -- Variable for storing current balance for account number 1.
SELECT @CurrentBalanceForTrans3 = Balance
FROM BankAccount
WHERE AccountNumber = 1; -- Storing value of current balance from database to the variable "@CurrentBalanceForTrans1".

WAITFOR DELAY '00:00:10' -- Adding delay of 10 seconds while transaction 4 already trying to update the value of balance due to isolation level.

-- Checking Balance if it is more than or equal to the withdrawal amount then only transacion  will take place.
IF (@CurrentBalanceForTrans3 >= @WithdrawAmountForTrans3)
BEGIN
  -- Deduct the amount based on this transaction instance without considering any other transaction for the same accoutn number beacuse this transacton has set lock on priorty.
  -- Amount 100 is getting deducted from 1000 in transaction 3 and also transaction 4 won't be able to update due to REPEATABLE READ Mode of Isolataion Level.
    PRINT CONCAT('Balance stored for account num - 1(3rd Instance):- ', @CurrentBalanceForTrans3);
	PRINT CONCAT('Amount to be withdrawn for account num - 1(3rd Instance):- ',  @WithdrawAmountForTrans3);
	DECLARE @Balance_var DECIMAL(10, 2);
	set @Balance_var = @CurrentBalanceForTrans3 - @WithdrawAmountForTrans3
	PRINT CONCAT('Balance Left After Transaction 3 in 3rd Instance:- ',@Balance_var);
	
	UPDATE BankAccount
	SET Balance = @Balance_var
	WHERE AccountNumber = 1;
    PRINT 'Amount is Deducted based on the 3rd transaction instance in the database while Transaction 4 is locked to perform update operation.'
	
	select * from BankAccount;
END

ELSE
BEGIN
PRINT 'Insufficient balance, rollback the transaction number 3.';
	ROLLBACK;
END

COMMIT TRANSACTION;


