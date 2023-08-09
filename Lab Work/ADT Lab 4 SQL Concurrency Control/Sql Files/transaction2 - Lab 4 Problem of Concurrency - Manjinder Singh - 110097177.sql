-- Manjinder Singh(110097177)
-- Transaction number - 2

-- Answer 3 With Transaction - 2 Concurrency Problem
use BankData;
BEGIN TRANSACTION;

DECLARE @WithdrawAmountForTrans2 DECIMAL(10, 2); -- Variable for storing withdrawal amount for transaction 2.
SET @WithdrawAmountForTrans2 = 50; -- Setting withdrawal amount for transaction 2.

DECLARE @CurrentBalanceForTrans2 DECIMAL(10, 2); -- Variable for storing current balance for account number 2.
SELECT @CurrentBalanceForTrans2 = Balance
FROM BankAccount
WHERE AccountNumber = 1; -- Storing value of current balance from database to the variable "@CurrentBalanceForTrans2".


-- Checking Balance if it is more than or equal to the withdrawal amount then only transacion  will take place.
IF (@CurrentBalanceForTrans2 >= @WithdrawAmountForTrans2)
BEGIN
   -- Deducting the amount 50 and in the mean time transaction 1 is still in wait state. Amoutn updated from 1000 to 950.
	PRINT CONCAT('Balance stored for account num - 1(2nd Instance):- ', @CurrentBalanceForTrans2);
	PRINT CONCAT('Amount to be withdrawn for account num - 1(2nd Instance):- ',  @WithdrawAmountForTrans2);
	DECLARE @Balance_var DECIMAL(10, 2);
	set @Balance_var = @CurrentBalanceForTrans2 - @WithdrawAmountForTrans2
	PRINT CONCAT('Balance Left After Transaction 2 in 2nd Instance:- ',@Balance_var);
    
	UPDATE BankAccount
    SET Balance = @Balance_var
    WHERE AccountNumber = 1;
    PRINT 'Amount is Deducted based on the 2nd transaction instance in the database.';
	
	select * from BankAccount;
END
ELSE
BEGIN
	PRINT 'Insufficient balance, Rollback the transaction number 2';
	ROLLBACK;
END

COMMIT TRANSACTION;
