USE aa630_m5_activity ;
#1.1 List all transactions for account #2 that are Deposits, ordered from newest to oldest. (use table transaction). 
# How many transactions are returned?
SELECT *
FROM transactions
WHERE account_id = 2 AND transaction_type = 'Deposit'
ORDER BY transaction_date DESC;

#1.2 How much are the 3 largest transactions for?
SELECT *
FROM transactions
ORDER BY amount DESC
LIMIT 3;

#1.3 Calculate the total transaction amount per account and list accounts in descending order of total transactions.(Hint: we need to use SUM(amount). 
# What is the top amount?
SELECT account_id, sum(amount) AS total_amount
FROM transactions
GROUP BY account_id
ORDER BY total_amount DESC;

#1.4 Find accounts with more than 3 transactions
SELECT account_id, COUNT(*)
FROM Transactions
GROUP BY account_id
HAVING COUNT(*) > 3;

#2.1 List all accounts with the customer’s full name and branch name
# What columns did you join the tables on?
SELECT concat( c.first_name, ' ', c.last_name) AS full_name , b.branch_name
FROM accounts a
INNER JOIN customers c ON a.customer_id = c.customer_id
INNER JOIN branches b ON a.branch_id = b.branch_id;

#2.2 List all customers and their accounts(Include customers who do not have accounts)
# What columns did you join the tables on?
SELECT c.customer_id, a.account_id
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id;

#2.3 List all branches and the accounts in them, including branches with no accounts
# What columns did you join the tables on?
SELECT b.branch_name, a.account_id
FROM branches b
RIGHT JOIN accounts a
ON b.branch_id =a.branch_id;

#2.3 4 List all transactions for customer "John Doe"
# What type of action (withdrawal, deposit) is returned?
SELECT b.branch_name, a.account_id
FROM accounts a
RIGHT JOIN branches b
ON a.branch_id =b.branch_id;

#2.4 List all transactions for customer "John Doe". 
# What type of action (withdrawal, deposit) is returned? 
SELECT *
FROM Transactions t
JOIN Accounts a ON  t.account_id = a.account_id
JOIN Customers c ON a.customer_id = c.customer_id
WHERE c.first_name = 'John' AND c.last_name = 'Doe';

#2.5 Combine account balances and transaction amounts above 1000 into a single list.
# What does a UNION do? Would duplicated be returned?
SELECT account_id, balance, 'Account' AS type
FROM Accounts
WHERE balance > 1000
UNION
SELECT account_id, amount, 'Transaction' AS type
FROM Transactions
WHERE amount > 1000;

#3.1 Insert a new checking account for customer_id 5 at branch_id with a balance of 1000
INSERT INTO Accounts (customer_id, branch_id, account_type, balance)
VALUES (5, 1, 'Checking', 1000);

#3.2 Update account #10 balance to 5000. Make sure you are selecting the right account
UPDATE Accounts
SET balance = 5000
WHERE account_id = 10;

#3.3 First write a SELECT statement to show all transactions that we know are system errors (where the amount is -99) 
# Show results and confirm how many there are
SELECT *
FROM Transactions
WHERE amount = -99;

DELETE FROM Transactions
WHERE amount = -99
LIMIT 100;

#3.4 Using the provided query, copy it over and run the statement to see how we can use TRANSACTIONS
START TRANSACTION;
-- Deposit
INSERT INTO Transactions(account_id, transaction_type, amount, transaction_date)
VALUES (1,'Deposit',1000,CURDATE());
-- Savepoint before risky withdrawal
SAVEPOINT before_withdrawal;
-- Attempt withdrawal
UPDATE Accounts
SET balance = balance - 5000
WHERE account_id = 1;
-- Rollback only the withdrawal if it would fail
ROLLBACK TO SAVEPOINT before_withdrawal;
-- Commit deposit
COMMIT;
