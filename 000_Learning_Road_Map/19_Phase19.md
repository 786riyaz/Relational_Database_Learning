# SQL Complete Learning Roadmap
# Phase 19 – Transactions and ACID Properties
### MySQL 8.0+

Database Transactions are essential for building reliable applications.

Imagine you are developing a banking application.

A customer transfers ₹5,000 from Account A to Account B.

Two operations must happen:

1. Deduct ₹5,000 from Account A.
2. Add ₹5,000 to Account B.

What happens if the first operation succeeds but the second fails?

Account A loses ₹5,000, but Account B never receives it.

This creates an inconsistent financial system.

**Database Transactions solve this problem by allowing multiple SQL operations to be treated as one logical unit of work.**

In this phase, we will learn transactions, COMMIT, ROLLBACK, SAVEPOINT, ACID properties, and practical transaction handling in MySQL.

---

# 1. What Is a Database Transaction?

A **Database Transaction** is a group of one or more database operations executed as a single logical unit of work.

A transaction should either:

- Complete successfully.
- Or be rolled back if it fails.

### Example: Bank Transfer

Suppose:

| Account | Balance |
|---|---:|
| Account A | ₹20,000 |
| Account B | ₹10,000 |

Account A transfers ₹5,000 to Account B.

Expected result:

| Account | Previous Balance | New Balance |
|---|---:|---:|
| Account A | ₹20,000 | ₹15,000 |
| Account B | ₹10,000 | ₹15,000 |

Both operations must succeed together.

If either operation fails, the transaction should be rolled back.

### Without Transactions

```sql
UPDATE accounts
SET balance = balance - 5000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 5000
WHERE id = 2;
```

Problem:

If the first query succeeds and the second fails, the money is deducted but never credited.

### With Transactions

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 5000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 5000
WHERE id = 2;

COMMIT;
```

Now both operations belong to one transaction.

If something goes wrong before COMMIT:

```sql
ROLLBACK;
```

MySQL reverses the changes made by the current transaction.

**Important:** Transactions require a transactional storage engine such as InnoDB. MyISAM does not provide the same transactional guarantees.

---

# 2. Why Do We Need Transactions?

Transactions are required whenever multiple database operations must succeed or fail together.

### Main Benefits

1. Maintain data consistency.
2. Prevent incomplete operations.
3. Protect financial transactions.
4. Handle failures safely.
5. Support concurrent users.
6. Maintain database integrity.
7. Allow controlled rollback.

### Real-World Examples

| Application | Transaction Example |
|---|---|
| Banking | Transfer money between accounts |
| E-commerce | Create order and reserve inventory |
| Payment Gateway | Record payment and update order status |
| Inventory | Reduce stock after purchase |
| Ticket Booking | Reserve a seat and create booking |
| Expense Tracker | Create expense and update account balance |
| Hospital | Create appointment and reserve doctor slot |

---

# 3. What Are the Main Transaction Commands?

MySQL provides several important transaction commands.

| Command | Purpose |
|---|---|
| START TRANSACTION | Begins a transaction |
| BEGIN | Alternative way to begin a transaction |
| COMMIT | Permanently commits the transaction |
| ROLLBACK | Reverses uncommitted transaction changes |
| SAVEPOINT | Creates a named point inside a transaction |
| ROLLBACK TO SAVEPOINT | Rolls back to a specific savepoint |
| RELEASE SAVEPOINT | Removes a savepoint |
| SET autocommit | Controls automatic transaction commits |

Let's understand each one.

---

# 4. START TRANSACTION

`START TRANSACTION` begins a new transaction.

Syntax:

```sql
START TRANSACTION;
```

You can also use:

```sql
BEGIN;
```

Example:

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 5000
WHERE id = 1;
```

At this point, the transaction has started, and the update has been executed.

However, the transaction has not yet been committed.

---

# 5. COMMIT

`COMMIT` permanently saves the changes made by the current transaction.

Syntax:

```sql
COMMIT;
```

Example:

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 5000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 5000
WHERE id = 2;

COMMIT;
```

After COMMIT, the transaction is successfully completed.

The committed changes cannot be reversed using an ordinary ROLLBACK.

If you need to reverse a committed business operation, you generally execute a new compensating transaction.

### Important

COMMIT does not mean that every possible future failure is impossible.

Durability depends on the database's storage and configuration settings, which we will discuss under ACID.

---

# 6. ROLLBACK

`ROLLBACK` reverses the uncommitted changes made by the current transaction.

Syntax:

```sql
ROLLBACK;
```

Example:

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 5000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 5000
WHERE id = 2;

ROLLBACK;
```

The updates are reversed.

The account balances return to their original values, assuming the transaction was operating on transactional tables and no earlier COMMIT occurred.

### When Should You Use ROLLBACK?

- A payment operation fails.
- A database constraint is violated.
- An inventory update fails.
- A required record does not exist.
- Application validation fails after some database changes.
- An unexpected error occurs.

---

# 7. Complete Practical Example – Bank Transfer

Let's implement a banking transaction in MySQL.

### Step 1: Create Database

```sql
CREATE DATABASE transaction_practice;

USE transaction_practice;
```

### Step 2: Create Accounts Table

```sql
CREATE TABLE accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_holder VARCHAR(100) NOT NULL,
    balance DECIMAL(12,2) NOT NULL,

    CHECK (balance >= 0)
) ENGINE = InnoDB;
```

### Step 3: Insert Sample Data

```sql
INSERT INTO accounts (account_holder, balance)
VALUES
('Riyaz', 20000),
('John', 10000);
```

Check balances:

```sql
SELECT * FROM accounts;
```

Expected:

| id | account_holder | balance |
|---:|---|---:|
| 1 | Riyaz | 20000.00 |
| 2 | John | 10000.00 |

### Step 4: Transfer Money

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 5000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 5000
WHERE id = 2;

COMMIT;
```

### Step 5: Verify Results

```sql
SELECT * FROM accounts;
```

Expected:

| id | account_holder | balance |
|---:|---|---:|
| 1 | Riyaz | 15000.00 |
| 2 | John | 15000.00 |

The transaction completed successfully.

### Important Production Consideration

The previous example demonstrates transaction syntax, but a production banking system needs additional safeguards.

For example:

- Verify the sender exists.
- Verify the receiver exists.
- Check that the sender has sufficient funds.
- Prevent concurrent transfers from overspending.
- Validate the transfer amount.
- Record a transaction history.
- Use appropriate locking.
- Handle duplicate requests safely.

We will cover concurrency and locking in Phase 20.

---

# 8. What Happens When a Transaction Fails?

Let's understand a failure scenario.

Initial balances:

| Account | Balance |
|---|---:|
| Riyaz | ₹20,000 |
| John | ₹10,000 |

Suppose we execute:

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 5000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 5000
WHERE id = 999;

COMMIT;
```

Problem:

Account ID 999 does not exist.

The second UPDATE affects zero rows.

**Important:** MySQL does not automatically consider an UPDATE affecting zero rows to be a transaction failure.

The first UPDATE can still be committed.

Therefore, blindly executing COMMIT here would be incorrect.

### Better Approach

Check the affected rows in your application.

Or use a conditional SQL approach.

For example:

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 5000
WHERE id = 1
AND balance >= 5000;

-- Verify exactly one row was updated.

UPDATE accounts
SET balance = balance + 5000
WHERE id = 2;

-- Verify exactly one row was updated.

COMMIT;
```

If either operation does not meet the expected conditions:

```sql
ROLLBACK;
```

This illustrates an important rule:

**A transaction does not automatically know whether your business operation was successful. Your application must validate the results of its SQL statements.**

---

# 9. What Is SAVEPOINT?

A SAVEPOINT creates a named point inside a transaction.

It allows you to roll back only part of the transaction instead of rolling back everything.

Syntax:

```sql
SAVEPOINT savepoint_name;
```

### Example

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

SAVEPOINT after_first_update;

UPDATE accounts
SET balance = balance + 1000
WHERE id = 2;

ROLLBACK TO SAVEPOINT after_first_update;

COMMIT;
```

What happens?

1. Transaction starts.
2. First account is updated.
3. A savepoint is created.
4. Second account is updated.
5. The transaction rolls back to the savepoint.
6. The second update is reversed.
7. The first update remains.
8. COMMIT saves the first update.

Final result:

Only the first account's update is committed.

This is useful for partial rollback scenarios, although your application must ensure that the resulting business state is valid.

---

# 10. RELEASE SAVEPOINT

`RELEASE SAVEPOINT` removes a savepoint.

Syntax:

```sql
RELEASE SAVEPOINT savepoint_name;
```

Example:

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

SAVEPOINT sp1;

UPDATE accounts
SET balance = balance + 1000
WHERE id = 2;

RELEASE SAVEPOINT sp1;

COMMIT;
```

After releasing a savepoint, you can no longer roll back to that savepoint.

### Important

- COMMIT removes all savepoints.
- Full ROLLBACK removes all savepoints.
- ROLLBACK TO SAVEPOINT does not end the transaction.
- Releasing a savepoint does not commit the transaction.

---

# 11. What Is Autocommit?

Autocommit controls whether MySQL automatically commits each individual statement.

By default, MySQL normally uses:

```sql
autocommit = 1
```

Check it:

```sql
SELECT @@autocommit;
```

### Autocommit ON

When autocommit is enabled, each successful standalone statement is committed automatically.

Example:

```sql
UPDATE accounts
SET balance = balance + 1000
WHERE id = 1;
```

The update is automatically committed when the statement completes successfully.

### Autocommit OFF

You can disable autocommit:

```sql
SET autocommit = 0;
```

Now statements are part of an open transaction until you explicitly commit or roll back.

Example:

```sql
UPDATE accounts
SET balance = balance + 1000
WHERE id = 1;

COMMIT;
```

Enable autocommit again:

```sql
SET autocommit = 1;
```

### Important Difference

| Autocommit ON | Autocommit OFF |
|---|---|
| Each standalone statement commits automatically | Changes remain uncommitted until COMMIT |
| Convenient for normal queries | Useful when manually controlling multiple operations |
| No explicit transaction required for individual statements | Explicit transaction management is required |

**Best Practice:** For application development, use explicit transactions around operations that must succeed or fail together.

---

# 12. What Are ACID Properties?

ACID is the foundation of reliable database transactions.

ACID stands for:

- Atomicity
- Consistency
- Isolation
- Durability

These four properties help ensure that transactions execute reliably.

Let's understand each one in detail.

---

# 13. Atomicity

Atomicity means:

**A transaction is treated as one indivisible unit of work.**

Either all required operations succeed, or none of their changes are committed.

### Example

A bank transfer contains:

```text
Operation 1: Deduct ₹5,000 from Account A
Operation 2: Add ₹5,000 to Account B
```

If the second operation fails, the first operation must be rolled back.

### Without Atomicity

```text
Account A: -₹5,000
Account B: No change
```

This is incorrect.

### With Atomicity

```text
Account A: Original balance
Account B: Original balance
```

The incomplete transaction is rolled back.

### SQL Example

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 5000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 5000
WHERE id = 2;

COMMIT;
```

If an error occurs and the transaction is rolled back, the uncommitted changes are reversed.

**Atomicity = All or Nothing.**

---

# 14. Consistency

Consistency means:

**A transaction must preserve the database's defined integrity rules.**

A transaction should take the database from one valid state to another valid state.

### Example

Suppose an account balance cannot be negative.

We define:

```sql
CREATE TABLE accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(12,2) NOT NULL,

    CHECK (balance >= 0)
);
```

Now this query:

```sql
UPDATE accounts
SET balance = -500
WHERE id = 1;
```

Violates the CHECK constraint.

MySQL rejects the operation.

### Other Integrity Rules

- Primary Key constraints.
- Foreign Key constraints.
- UNIQUE constraints.
- NOT NULL constraints.
- CHECK constraints.
- Application-level business rules.

### Important

Consistency does not mean that MySQL automatically understands every business rule.

For example, MySQL does not automatically know that an order must not contain more items than available stock unless you implement that rule through suitable database constraints, transaction logic, or application logic.

**Consistency = Database rules remain satisfied.**

---

# 15. Isolation

Isolation means concurrent transactions should not interfere with one another in ways that violate the selected isolation guarantees.

Imagine two customers trying to purchase the last available product.

Initial stock:

```text
Available Stock = 1
```

Transaction A checks stock.

Transaction B also checks stock.

Both see stock = 1.

Both try to purchase.

Without appropriate concurrency control, both transactions might incorrectly proceed.

Isolation and locking mechanisms help prevent this.

We will study this in depth in:

**Phase 20 – Concurrency Control and Locking**

And:

**Phase 21 – Isolation Levels**

**Isolation = Transactions are protected from problematic interference with concurrent transactions.**

---

# 16. Durability

Durability means:

**Once a transaction is successfully committed, its changes should survive failures according to the database's durability guarantees.**

Example:

1. Customer transfers ₹5,000.
2. MySQL commits the transaction.
3. The server unexpectedly crashes.
4. After recovery, the committed transfer should still be reflected in the database.

In InnoDB, durability is supported through mechanisms including:

- Redo logs.
- Write-ahead logging.
- Crash recovery.
- Appropriate flushing and storage configuration.

### Important MySQL Settings

One relevant setting is:

```sql
SHOW VARIABLES LIKE 'innodb_flush_log_at_trx_commit';
```

A common setting for strong transaction durability is:

```text
innodb_flush_log_at_trx_commit = 1
```

With this setting, InnoDB flushes the redo log to durable storage at each transaction commit, subject to the guarantees of the operating system and storage hardware.

Another relevant setting is:

```sql
SHOW VARIABLES LIKE 'sync_binlog';
```

For stronger binary log durability, a common setting is:

```text
sync_binlog = 1
```

The appropriate configuration depends on the deployment's recovery and performance requirements.

**Durability = Committed changes survive failures within the configured durability guarantees.**

---

# 17. ACID Properties – Complete Revision

| Property | Meaning | Example |
|---|---|---|
| Atomicity | All operations succeed or are rolled back | Bank transfer |
| Consistency | Integrity rules remain satisfied | Balance cannot become negative |
| Isolation | Concurrent transactions are controlled | Two customers buying the last item |
| Durability | Committed changes survive failures | Transfer remains saved after a crash |

### Easy Way to Remember

```text
A = All or Nothing
C = Consistent Database
I = Independent Transaction Execution
D = Data Remains Saved
```

---

# 18. What Are Transaction States?

A transaction moves through different states during execution.

A simplified transaction lifecycle:

```text
       START
         |
         ↓
      ACTIVE
         |
         ↓
   SQL Operations
         |
         ↓
   ┌──────────────┐
   |              |
   ↓              ↓
 COMMIT         ROLLBACK
   |              |
   ↓              ↓
COMMITTED       ABORTED
```

### Active

The transaction is executing SQL statements.

### Committed

The transaction completed successfully and its changes were committed.

### Aborted

The transaction was rolled back or terminated due to an error or failure.

### Note

These are conceptual transaction states. Actual database internals have more detailed lifecycle and recovery states.

---

# 19. Implicit Commit in MySQL

This is an important MySQL-specific concept.

Some SQL statements cause an implicit COMMIT.

This means they can commit an existing transaction automatically.

Many DDL statements cause implicit commits.

Examples include:

```sql
CREATE TABLE
ALTER TABLE
DROP TABLE
TRUNCATE TABLE
CREATE DATABASE
DROP DATABASE
```

### Example

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

CREATE TABLE test_table (
    id INT PRIMARY KEY
);

ROLLBACK;
```

You might expect the ROLLBACK to reverse everything.

However, `CREATE TABLE` causes an implicit commit.

Therefore, the earlier UPDATE may already have been committed.

The later ROLLBACK cannot undo it.

### Important Rule

Avoid mixing DDL operations and business transactions unless you understand MySQL's implicit-commit behavior.

---

# 20. Explicit vs Implicit Transactions

| Explicit Transaction | Implicit Transaction |
|---|---|
| Developer manually controls transaction boundaries | Database automatically commits individual statements |
| Uses START TRANSACTION and COMMIT | Commonly uses autocommit |
| Supports grouping multiple operations | Each standalone statement is its own transaction |
| Useful for banking and order processing | Useful for ordinary independent operations |

Example of explicit transaction:

```sql
START TRANSACTION;

INSERT INTO orders (customer_id, total_amount)
VALUES (1, 5000);

INSERT INTO payments (order_id, amount)
VALUES (LAST_INSERT_ID(), 5000);

COMMIT;
```

The example assumes the relevant tables exist and the payment row references the newly created order. In production, capture the order ID carefully because `LAST_INSERT_ID()` is connection-specific.

---

# 21. Real-World Example – E-Commerce Order Transaction

Imagine a customer purchases a product.

The application must:

1. Create an order.
2. Create order items.
3. Reduce inventory.
4. Create a payment record.

These operations should be handled consistently.

### Example Tables

```sql
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    stock INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    CHECK (stock >= 0),
    CHECK (price >= 0)
) ENGINE = InnoDB;
```

```sql
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(30) NOT NULL
) ENGINE = InnoDB;
```

```sql
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id),

    CHECK (quantity > 0),
    CHECK (price >= 0)
) ENGINE = InnoDB;
```

```sql
CREATE TABLE payments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(30) NOT NULL,

    FOREIGN KEY (order_id) REFERENCES orders(id),

    CHECK (amount >= 0)
) ENGINE = InnoDB;
```

### Transaction Example

Assume product ID 1 has enough stock.

```sql
START TRANSACTION;

-- Step 1: Create order
INSERT INTO orders
(customer_id, total_amount, status)
VALUES
(1, 2000, 'PENDING');

SET @order_id = LAST_INSERT_ID();

-- Step 2: Reduce product stock
UPDATE products
SET stock = stock - 2
WHERE id = 1
AND stock >= 2;

-- Step 3: Insert order item
INSERT INTO order_items
(order_id, product_id, quantity, price)
VALUES
(@order_id, 1, 2, 1000);

-- Step 4: Create payment record
INSERT INTO payments
(order_id, amount, status)
VALUES
(@order_id, 2000, 'PENDING');

COMMIT;
```

### Important Production Issue

This example demonstrates transaction grouping, but it is not yet a complete production-safe implementation.

If the product does not have sufficient stock, the UPDATE may affect zero rows without automatically aborting the transaction.

The application must verify the affected-row count and issue ROLLBACK when the stock update does not succeed.

A more defensive SQL approach is:

```sql
START TRANSACTION;

UPDATE products
SET stock = stock - 2
WHERE id = 1
AND stock >= 2;

-- Check that exactly one row was updated.
-- If not, ROLLBACK and stop.

COMMIT;
```

For a complete order workflow, the application should also calculate the amount from trusted product prices rather than accepting an arbitrary total from the client.

---

# 22. Transactions and Node.js

Since Node.js backend applications frequently use MySQL, transaction management is an important practical skill.

Let's understand the basic concept.

Suppose you use:

- Node.js
- Express
- MySQL
- mysql2 package

A transaction must use the same database connection for all its operations.

Why?

Because a transaction belongs to a specific database session.

You cannot safely start a transaction on one pooled connection and execute its next query on an unrelated connection.

### Example Using mysql2

Install:

```bash
npm install mysql2
```

Create a database connection pool:

```javascript
const mysql = require("mysql2/promise");

const pool = mysql.createPool({
    host: "localhost",
    user: "root",
    password: "password",
    database: "transaction_practice",
    waitForConnections: true,
    connectionLimit: 10
});
```

### Transaction Function

```javascript
async function transferMoney(fromId, toId, amount) {
    const connection = await pool.getConnection();

    try {
        await connection.beginTransaction();

        // Deduct money from sender
        const [debitResult] = await connection.execute(
            `UPDATE accounts
             SET balance = balance - ?
             WHERE id = ?
             AND balance >= ?`,
            [amount, fromId, amount]
        );

        if (debitResult.affectedRows !== 1) {
            throw new Error("Insufficient balance or sender not found");
        }

        // Credit receiver
        const [creditResult] = await connection.execute(
            `UPDATE accounts
             SET balance = balance + ?
             WHERE id = ?`,
            [amount, toId]
        );

        if (creditResult.affectedRows !== 1) {
            throw new Error("Receiver account not found");
        }

        await connection.commit();

        return {
            success: true,
            message: "Money transferred successfully"
        };

    } catch (error) {
        await connection.rollback();

        throw error;

    } finally {
        connection.release();
    }
}
```

### Important Production Improvements

The above example is a learning implementation. A production banking workflow should also:

1. Validate that the amount is positive and within permitted limits.
2. Prevent transferring money to the same account if prohibited.
3. Lock or safely update both accounts to handle concurrent transfers.
4. Record a transaction history.
5. Use idempotency keys to prevent duplicate transfer requests.
6. Handle database connection failures during COMMIT carefully.
7. Ensure account ownership and authorization.
8. Use consistent locking order to reduce deadlocks.

We will explore row locking and deadlocks in Phase 20.

### Important Rule

Always use the same connection object for:

```javascript
beginTransaction()
execute()
execute()
commit()
rollback()
```

And release the connection after the transaction is finished.

---

# 23. What Happens If the Application Crashes?

Consider this scenario:

1. Node.js starts a transaction.
2. The application deducts money.
3. The application crashes before COMMIT.

What happens?

If the connection is lost before the transaction commits, MySQL rolls back the uncommitted InnoDB transaction when it detects the disconnected session.

The committed data remains unchanged.

### Another Scenario

1. Node.js executes COMMIT.
2. MySQL successfully commits.
3. The network connection fails before Node.js receives the response.

Now the application may not know whether the transaction committed.

This is an important distributed-systems problem.

The application should not blindly retry a financial operation because it may execute the same operation twice.

A common solution is an **idempotency key**.

For example, assign every payment request a unique identifier and enforce its uniqueness in the database.

That way, retrying the same request cannot create a second payment record.

---

# 24. What Is an Idempotent Operation?

An operation is idempotent if repeating it produces the same intended result as executing it once.

Example:

```sql
UPDATE users
SET status = 'ACTIVE'
WHERE id = 1;
```

Executing this multiple times produces the same final status.

But consider:

```sql
UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;
```

Executing this twice deducts ₹2,000.

It is not idempotent.

### Why Is Idempotency Important?

It helps prevent duplicate operations caused by:

- Network retries.
- Client retries.
- Payment gateway callbacks.
- Server timeouts.
- Duplicate API requests.

### Example Table

```sql
CREATE TABLE payment_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    idempotency_key VARCHAR(100) NOT NULL UNIQUE,
    amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(30) NOT NULL
);
```

Now the database can reject duplicate idempotency keys.

A complete implementation must still handle concurrent duplicate requests and return the original result appropriately.

---

# 25. Common Transaction Mistakes

| Mistake | Problem | Better Approach |
|---|---|---|
| Forgetting COMMIT | Changes remain uncommitted | Explicitly commit successful transactions |
| Forgetting ROLLBACK | Partial changes may remain pending | Roll back when an operation fails |
| Using different connections | Transaction boundaries are lost | Use one connection throughout |
| Keeping transactions open too long | Locks remain held longer | Keep transactions short |
| Assuming zero affected rows is an error | MySQL may still allow COMMIT | Check affected-row counts |
| Mixing DDL and transactions | DDL may implicitly commit | Keep schema changes separate |
| Blindly retrying transfers | Can cause duplicate transfers | Use idempotency keys |
| Ignoring concurrency | Can cause incorrect business results | Use suitable locking and isolation |
| Not handling connection errors | Transaction outcome may be uncertain | Design safe retry and reconciliation logic |

---

# 26. Important Transaction Questions

### Q1. Can we ROLLBACK after COMMIT?

No.

After COMMIT, the transaction has completed.

To reverse a committed business operation, perform a new compensating transaction.

### Q2. Can we execute multiple UPDATE statements in one transaction?

Yes.

```sql
START TRANSACTION;

UPDATE employees
SET salary = salary + 1000
WHERE id = 1;

UPDATE employees
SET salary = salary + 1000
WHERE id = 2;

COMMIT;
```

### Q3. What happens if MySQL crashes before COMMIT?

Uncommitted InnoDB transaction changes are rolled back during recovery.

### Q4. What happens if MySQL crashes after COMMIT?

Committed changes should survive according to the configured durability guarantees.

### Q5. Can one transaction contain INSERT, UPDATE and DELETE?

Yes.

```sql
START TRANSACTION;

INSERT INTO employees (name)
VALUES ('Riyaz');

UPDATE employees
SET name = 'Riyaz Khan'
WHERE id = 1;

DELETE FROM employees
WHERE id = 2;

COMMIT;
```

### Q6. Can we use SAVEPOINT multiple times?

Yes.

A transaction can contain multiple savepoints.

### Q7. Does ROLLBACK TO SAVEPOINT end the transaction?

No.

It rolls back to the specified savepoint but keeps the transaction active.

### Q8. Does SELECT require a transaction?

Not always.

However, transactions can be useful when multiple reads must observe a consistent view of data.

### Q9. Are all MySQL tables transactional?

No.

Transactional guarantees depend on the storage engine. InnoDB supports transactions; MyISAM does not provide equivalent transactional support.

### Q10. What are ACID properties?

Atomicity, Consistency, Isolation and Durability.

---

# 27. Practical Assignments

Complete these assignments using MySQL.

## Assignment 1 – Basic Transactions

Create a bank database with:

```sql
CREATE DATABASE bank_db;

USE bank_db;
```

Create accounts:

```sql
CREATE TABLE accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    balance DECIMAL(12,2) NOT NULL,
    CHECK (balance >= 0)
) ENGINE = InnoDB;
```

Insert five accounts.

Tasks:

1. Transfer money between two accounts.
2. Use START TRANSACTION.
3. Use COMMIT.
4. Perform another transfer.
5. Use ROLLBACK.
6. Verify balances after both operations.

## Assignment 2 – SAVEPOINT

Tasks:

1. Start a transaction.
2. Update Account A.
3. Create SAVEPOINT S1.
4. Update Account B.
5. Create SAVEPOINT S2.
6. Update Account C.
7. Roll back to S2.
8. Commit.
9. Verify the results.

## Assignment 3 – Autocommit

Tasks:

1. Check current autocommit.
2. Disable autocommit.
3. Execute an UPDATE.
4. Verify the change in your current session.
5. Roll back.
6. Verify the original value.
7. Enable autocommit.

## Assignment 4 – ACID Properties

Write practical examples explaining:

1. Atomicity in a bank transfer.
2. Consistency using CHECK constraints.
3. Isolation when two users purchase the same product.
4. Durability after a server crash.

## Assignment 5 – Node.js Transaction

Build a simple Express API:

```text
POST /transfer
```

Request:

```json
{
    "fromAccount": 1,
    "toAccount": 2,
    "amount": 5000
}
```

Requirements:

1. Validate the request.
2. Start a database transaction.
3. Deduct money from the sender.
4. Verify sufficient balance.
5. Credit the receiver.
6. Verify the receiver exists.
7. Commit on success.
8. Roll back on failure.
9. Release the connection.
10. Return an appropriate API response.

---

# 28. Phase 19 – Quick Revision Sheet

| Concept | Meaning |
|---|---|
| Transaction | Group of database operations treated as one logical unit |
| START TRANSACTION | Begins a transaction |
| COMMIT | Saves transaction changes |
| ROLLBACK | Reverses uncommitted changes |
| SAVEPOINT | Creates a rollback point |
| ROLLBACK TO SAVEPOINT | Rolls back part of a transaction |
| RELEASE SAVEPOINT | Removes a savepoint |
| Autocommit | Automatically commits standalone statements |
| ACID | Atomicity, Consistency, Isolation, Durability |
| Atomicity | All or nothing |
| Consistency | Preserves database integrity rules |
| Isolation | Controls interference between concurrent transactions |
| Durability | Committed changes survive failures within configured guarantees |
| Implicit Commit | Automatic commit caused by certain SQL statements |
| Idempotency | Repeating an operation does not duplicate its intended effect |
| InnoDB | MySQL storage engine supporting transactions |

### Most Important SQL Commands

```sql
-- Start transaction
START TRANSACTION;

-- Commit
COMMIT;

-- Rollback
ROLLBACK;

-- Create savepoint
SAVEPOINT sp1;

-- Rollback to savepoint
ROLLBACK TO SAVEPOINT sp1;

-- Release savepoint
RELEASE SAVEPOINT sp1;

-- Check autocommit
SELECT @@autocommit;

-- Disable autocommit
SET autocommit = 0;

-- Enable autocommit
SET autocommit = 1;
```

---

# 29. Phase 19 Completion Checklist

Before moving to Phase 20, make sure you understand:

- [ ] What is a database transaction?
- [ ] Why do we need transactions?
- [ ] START TRANSACTION.
- [ ] COMMIT.
- [ ] ROLLBACK.
- [ ] SAVEPOINT.
- [ ] ROLLBACK TO SAVEPOINT.
- [ ] RELEASE SAVEPOINT.
- [ ] Autocommit.
- [ ] ACID properties.
- [ ] Atomicity.
- [ ] Consistency.
- [ ] Isolation.
- [ ] Durability.
- [ ] Transaction states.
- [ ] Explicit vs implicit transactions.
- [ ] Implicit commits in MySQL.
- [ ] InnoDB transaction support.
- [ ] Transactions in banking applications.
- [ ] Transactions in e-commerce applications.
- [ ] Transactions using Node.js and MySQL.
- [ ] Idempotency.
- [ ] Handling transaction failures.

**Phase 19 is complete when you can implement a multi-step database operation that either completes successfully or rolls back safely when something goes wrong.**

---

# Next Phase – Phase 20: Concurrency Control and Locking

In Phase 19, we learned how transactions work.

But what happens when multiple users execute transactions simultaneously?

For example:

- Two customers try to purchase the last product.
- Two bank transfers update the same account.
- Two employees update the same customer record.
- Multiple requests modify the same inventory.

These situations introduce concurrency problems.

In Phase 20, we will cover:

1. What Is Concurrency?
2. What Is Concurrency Control?
3. Database Locks.
4. Shared Locks.
5. Exclusive Locks.
6. Row-Level Locking.
7. Table-Level Locking.
8. Pessimistic Locking.
9. Optimistic Locking.
10. SELECT FOR UPDATE.
11. SELECT FOR SHARE.
12. Deadlocks.
13. Deadlock Detection.
14. Lock Wait Timeout.
15. Lock Escalation Concepts.
16. Lost Update Problem.
17. Dirty Write.
18. Locking in Banking Applications.
19. Locking in Inventory Systems.
20. Concurrency Handling in Node.js.
21. Interview Questions and Practical Assignments.

**Next: Phase 20 – Concurrency Control and Locking.**