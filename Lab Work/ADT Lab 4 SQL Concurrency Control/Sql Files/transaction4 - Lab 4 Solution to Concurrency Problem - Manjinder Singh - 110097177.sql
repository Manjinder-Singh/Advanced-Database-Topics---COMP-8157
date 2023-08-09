-- Manjinder Singh(110097177)
-- Transaction number - 4 Solution to Concurrency Problem
-- update BankAccount set Balance=1000;
-- This transaction wont be executed for update operation due to ISOLATION LEVEL REPEATABLE READ Mode set on Transaction 3 
use BankData;
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ -- Isolation Level set to Repeatable Read.

DECLARE @WithdrawAmountForTrans4 DECIMAL(10, 2); -- Variable for storing withdrawal amount for transaction 4.
SET @WithdrawAmountForTrans4 = 50; -- Setting withdrawal amount for transaction 4.

DECLARE @CurrentBalanceForTrans4 DECIMAL(10, 2); -- Variable for storing current balance for account number 1.
SELECT @CurrentBalanceForTrans4 = Balance
FROM BankAccount
WHERE AccountNumber = 1; -- Storing value of current balance from database to the variable "@CurrentBalanceForTrans4".


-- Checking Balance if it is more than or equal to the withdrawal amount then only transacion  will take place.
IF (@CurrentBalanceForTrans4 >= @WithdrawAmountForTrans4)
BEGIN
   -- Trying to Deduct the amount 50 and in the mean time transaction 3 is still in wait state. Amount wont be updated from 1000 to 950 due to high isolation level set for Transaction number 3.
	PRINT CONCAT('Balance stored for account num - 1(4th Instance):- ', @CurrentBalanceForTrans4);
	PRINT CONCAT('Amount to be withdrawn for account num - 1(4th Instance):- ',  @WithdrawAmountForTrans4);
	DECLARE @Balance_var DECIMAL(10, 2);
	set @Balance_var = @CurrentBalanceForTrans4 - @WithdrawAmountForTrans4
	PRINT CONCAT('Balance Left After Transaction 4 in 4th Instance:- ',@Balance_var);
    
	UPDATE BankAccount
    SET Balance = @Balance_var
    WHERE AccountNumber = 1;
    PRINT 'Balance updated.'; -- Amount is supposed to be deducted based on the 4th transaction instance in the database but it wont be due to isolation level.
	
	select * from BankAccount;
END
ELSE
BEGIN
	PRINT 'Insufficient balance, Rollback the transaction number 4';
	ROLLBACK;
END

COMMIT TRANSACTION;
