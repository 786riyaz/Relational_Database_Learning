# SQL Complete Learning Roadmap
# Phase 20 – Concurrency Control and Locking
### MySQL 8.0+ | InnoDB

In Phase 19, we learned about database transactions and ACID properties.

Now let's understand what happens when **multiple users access and modify the same database records simultaneously**.

This is called concurrency.

Imagine you are developing an e-commerce application.

There is only one mobile phone left in stock.

Two customers try to purchase it at almost exactly the same time.

Both customers check the inventory:

```text
Available Stock = 1
```

Both requests see that one item is available.

Both attempt to purchase it.

Without proper concurrency control, your application might sell two phones even though only one exists.

This is a database concurrency problem.

**Concurrency Control ensures that simultaneous transactions interact safely and maintain data consistency.**

---

# 1. What Is Concurrency?

Concurrency means multiple transactions execute during overlapping periods.

They may be reading or modifying the same database records.

### Example

Suppose two users are accessing the same bank account.

Initial balance:

```text
Account Balance = ₹10,000
```

Two transactions start:

**Transaction A:**

Withdraw ₹3,000.

**Transaction B:**

Withdraw ₹5,000.

Both transactions may read the same initial balance.

Depending on how they execute, they can interfere with each other.

This is why databases need concurrency control.

### Real-World Examples

| Application | Concurrency Scenario |
|---|---|
| Banking | Two withdrawals from one account |
| E-commerce | Multiple customers buying the last product |
| Ticket Booking | Two users booking the same seat |
| Hospital | Two users booking the same appointment slot |
| Inventory | Multiple orders updating stock |
| Expense Tracker | Multiple requests updating an account balance |

---

# 2. What Is Concurrency Control?

Concurrency Control is the process of managing simultaneous database transactions to prevent incorrect results and preserve database consistency.

Its objectives include:

1. Prevent conflicting operations.
2. Protect data integrity.
3. Avoid lost updates.
4. Prevent dirty reads where prohibited by the isolation level.
5. Manage simultaneous writes.
6. Maintain transaction isolation.
7. Ensure correct results under concurrent execution.

MySQL InnoDB uses mechanisms such as:

- Row-level locks.
- Record locks.
- Gap locks.
- Next-key locks.
- Multiversion Concurrency Control (MVCC).
- Deadlock detection.

We will study these concepts in this phase.

---

# 3. What Is a Database Lock?

A **Database Lock** is a mechanism that controls access to database resources while transactions are executing.

Locks help prevent conflicting operations.

For example:

Suppose Transaction A is updating an employee's salary.

Transaction B also wants to update the same employee's salary.

A lock can prevent both transactions from modifying the same record simultaneously in an unsafe manner.

### Example

Initial salary:

```text
Employee Salary = ₹50,000
```

Transaction A:

```sql
UPDATE employees
SET salary = 55000
WHERE id = 1;
```

Transaction B:

```sql
UPDATE employees
SET salary = 60000
WHERE id = 1;
```

If both transactions execute concurrently, MySQL must coordinate access to the record.

InnoDB uses locking to control conflicting modifications.

---

# 4. Types of Database Locks

Important lock categories include:

1. Shared Lock.
2. Exclusive Lock.
3. Intention Lock.
4. Record Lock.
5. Gap Lock.
6. Next-Key Lock.
7. Table Lock.

Let's understand them.

---

# 5. Shared Lock (S Lock)

A Shared Lock allows a transaction to read a record while preventing conflicting exclusive modifications to that locked record.

Multiple transactions can hold shared locks on the same record simultaneously.

### Example

Transaction A:

```sql
START TRANSACTION;

SELECT *
FROM employees
WHERE id = 1
FOR SHARE;
```

Transaction B:

```sql
START TRANSACTION;

SELECT *
FROM employees
WHERE id = 1
FOR SHARE;
```

Both transactions can acquire shared locks on the same matching record.

However, a transaction trying to acquire an incompatible exclusive lock must wait.

### Characteristics

- Multiple transactions can hold shared locks on the same record.
- Shared locks support coordinated reading.
- Conflicting exclusive modifications are blocked until the shared lock is released.
- COMMIT or ROLLBACK normally releases transaction locks.

### Real-World Example

Two administrators are reading the same employee record while another process attempts to modify it.

Shared locking can prevent the modification until the relevant locks are released.

---

# 6. Exclusive Lock (X Lock)

An Exclusive Lock allows a transaction to modify a locked record while preventing other transactions from acquiring conflicting locks on that record.

It is commonly used for UPDATE, DELETE, and locking reads.

### Example

Transaction A:

```sql
START TRANSACTION;

SELECT *
FROM employees
WHERE id = 1
FOR UPDATE;
```

This requests an exclusive lock on the matching record.

Transaction B:

```sql
START TRANSACTION;

SELECT *
FROM employees
WHERE id = 1
FOR UPDATE;
```

Transaction B must wait while Transaction A holds the conflicting lock.

### Characteristics

- Only one transaction can hold an exclusive lock on a given record at a time.
- Conflicting shared and exclusive locks cannot be granted simultaneously.
- Used to protect data during modifications.
- Normally released when the transaction ends.

### Shared Lock vs Exclusive Lock

| Shared Lock | Exclusive Lock |
|---|---|
| Used for shared reading | Used for exclusive access |
| Multiple transactions can hold compatible shared locks | Only one transaction can hold an exclusive lock |
| Blocks conflicting exclusive locks | Blocks conflicting shared and exclusive locks |
| SQL: FOR SHARE | SQL: FOR UPDATE |

**Important:** Ordinary SELECT statements in InnoDB generally do not acquire shared record locks. They normally use MVCC consistent reads.

`FOR SHARE` explicitly requests shared locking.

---

# 7. What Is Row-Level Locking?

Row-Level Locking means the database locks individual records rather than locking an entire table.

InnoDB supports row-level locking.

### Example

Suppose an employees table contains:

| id | name | salary |
|---:|---|---:|
| 1 | Riyaz | 50000 |
| 2 | John | 60000 |
| 3 | Alex | 45000 |

Transaction A:

```sql
START TRANSACTION;

UPDATE employees
SET salary = 55000
WHERE id = 1;
```

Transaction A locks the relevant record.

Transaction B:

```sql
START TRANSACTION;

UPDATE employees
SET salary = 65000
WHERE id = 2;
```

Because the transactions modify different records, they can generally proceed concurrently.

### Benefits

- Better concurrency.
- Less unnecessary blocking.
- Multiple transactions can modify different records simultaneously.
- Suitable for high-traffic applications.

### Important

InnoDB locking is more complex than simply locking one visible row.

Depending on the isolation level, index access path, and query condition, InnoDB may also acquire:

- Record locks.
- Gap locks.
- Next-key locks.

For UPDATE and DELETE statements, a suitable index is important because the rows scanned during execution can affect locking behavior.

---

# 8. What Is Table-Level Locking?

Table-Level Locking locks an entire table rather than individual records.

Example:

```sql
LOCK TABLES employees WRITE;
```

This requests a write lock on the table.

Release the lock:

```sql
UNLOCK TABLES;
```

### Table-Level vs Row-Level Locking

| Row-Level Locking | Table-Level Locking |
|---|---|
| Locks individual records or index ranges | Locks an entire table |
| Allows more concurrent operations | Restricts concurrent access more broadly |
| Commonly used by InnoDB | Explicitly available through LOCK TABLES |
| Suitable for transactional applications | Useful for certain specialized operations |

### Important MySQL Detail

`LOCK TABLES` has special transaction and implicit-commit behavior.

Do not casually mix it with ordinary InnoDB transaction management.

For most transactional application development, prefer InnoDB's row-level locking mechanisms.

---

# 9. What Is an Intention Lock?

An Intention Lock is a table-level lock that indicates a transaction intends to acquire locks on individual records within the table.

InnoDB uses intention locks to coordinate table-level and row-level locking.

Two important types are:

- Intention Shared (IS).
- Intention Exclusive (IX).

### Intention Shared (IS)

Indicates that a transaction intends to acquire shared locks on individual records.

### Intention Exclusive (IX)

Indicates that a transaction intends to acquire exclusive locks on individual records.

### Example

```sql
START TRANSACTION;

SELECT *
FROM employees
WHERE id = 1
FOR UPDATE;
```

InnoDB may acquire:

- An intention-exclusive table lock.
- An exclusive record lock on the relevant record.

You generally do not need to create these locks manually.

InnoDB manages them internally.

---

# 10. What Is a Record Lock?

A Record Lock locks an index record.

In InnoDB, record locks are associated with index records rather than abstract SQL rows.

Example:

```sql
START TRANSACTION;

SELECT *
FROM employees
WHERE id = 10
FOR UPDATE;
```

If `id` is the primary key, InnoDB can lock the corresponding primary-key index record.

### Important

The exact records locked depend on the query execution plan and isolation level.

Using an appropriate index generally helps MySQL locate the intended records efficiently and can reduce unnecessary locking.

---

# 11. What Is a Gap Lock?

A Gap Lock locks a range between index records.

It prevents certain transactions from inserting new index records into that protected gap.

Gap locks are particularly relevant under InnoDB's REPEATABLE READ isolation level.

### Example

Suppose an indexed column contains:

```text
10, 20, 30, 40
```

There are gaps between the indexed values:

```text
(-∞, 10)
(10, 20)
(20, 30)
(30, 40)
(40, +∞)
```

A transaction may acquire a gap lock that prevents another transaction from inserting a value into a particular protected range.

### Why Are Gap Locks Needed?

They help prevent certain phantom insertions in locking range reads.

Example:

```sql
START TRANSACTION;

SELECT *
FROM employees
WHERE id BETWEEN 10 AND 20
FOR UPDATE;
```

Under applicable InnoDB isolation and execution conditions, InnoDB may lock the matching records and relevant gaps.

A concurrent transaction attempting to insert a row into the protected range may need to wait.

### Important

Gap locking behavior depends on:

- Transaction isolation level.
- Whether the search is a unique lookup or range lookup.
- The index used.
- Whether the statement is a locking read or modification.

Do not assume every SELECT locks gaps.

---

# 12. What Is a Next-Key Lock?

A Next-Key Lock is a combination of:

1. Record Lock.
2. Gap Lock.

It locks an index record and the gap immediately preceding that record.

InnoDB uses next-key locks to prevent certain phantom rows.

### Example

Suppose an index contains:

```text
10, 20, 30, 40
```

A next-key lock associated with record `20` can protect:

```text
(10, 20]
```

This means:

- The gap between 10 and 20.
- The record containing 20.

### Why Are Next-Key Locks Important?

They help maintain consistent results for locking range operations under InnoDB's default REPEATABLE READ isolation level.

### Record Lock vs Gap Lock vs Next-Key Lock

| Lock | Purpose |
|---|---|
| Record Lock | Locks an index record |
| Gap Lock | Locks the gap between index records |
| Next-Key Lock | Locks an index record and its preceding gap |

---

# 13. What Is MVCC?

MVCC stands for **Multiversion Concurrency Control**.

It is a mechanism that allows transactions to read consistent versions of data without always blocking writers.

InnoDB uses MVCC.

### Why Do We Need MVCC?

Imagine:

Transaction A:

```sql
START TRANSACTION;

SELECT balance
FROM accounts
WHERE id = 1;
```

Transaction B:

```sql
UPDATE accounts
SET balance = 15000
WHERE id = 1;

COMMIT;
```

Transaction A may continue reading an earlier committed version of the row, depending on its isolation level and read type.

This allows ordinary reads and writes to coexist more efficiently.

### How Does MVCC Work?

InnoDB maintains internal information such as:

- Transaction IDs.
- Row version information.
- Undo records.
- Read views.

When a transaction performs a consistent read, InnoDB determines which row version is visible to that transaction.

If a newer version is not visible, InnoDB can reconstruct an older version using undo information.

### Benefits

1. Reduces read/write blocking.
2. Supports consistent reads.
3. Improves concurrency.
4. Helps implement transaction isolation.

### Important

MVCC does not mean that all reads are lock-free.

Locking reads such as `FOR UPDATE` and `FOR SHARE` request locks.

Ordinary consistent reads generally use MVCC.

---

# 14. What Is Pessimistic Locking?

Pessimistic Locking assumes conflicts are likely.

Therefore, a transaction locks the required records before modifying them.

This prevents other transactions from making conflicting modifications while the lock is held.

### Example

Suppose two users want to purchase the same product.

The application first locks the product record.

```sql
START TRANSACTION;

SELECT stock
FROM products
WHERE id = 1
FOR UPDATE;
```

Now the transaction has requested an exclusive lock on the matching record.

After checking the stock:

```sql
UPDATE products
SET stock = stock - 1
WHERE id = 1;

COMMIT;
```

Another transaction trying to acquire a conflicting lock on that record must wait.

### Advantages

- Prevents conflicting updates while locks are held.
- Useful for critical shared records.
- Suitable for financial and inventory operations.

### Disadvantages

- Transactions may wait.
- Locks can reduce concurrency.
- Deadlocks can occur.
- Long transactions can affect performance.

---

# 15. What Is Optimistic Locking?

Optimistic Locking assumes conflicts are relatively uncommon.

Instead of locking a record before reading it, the application checks whether the record changed before applying the update.

A common implementation uses a version column.

### Example Table

```sql
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    stock INT NOT NULL,
    version INT NOT NULL DEFAULT 0
);
```

Suppose the current record is:

| id | name | stock | version |
|---:|---|---:|---:|
| 1 | Laptop | 10 | 0 |

The application reads:

```text
stock = 10
version = 0
```

Now it attempts to update:

```sql
UPDATE products
SET stock = 9,
    version = version + 1
WHERE id = 1
AND version = 0;
```

If the update affects one row, it succeeds.

The version becomes 1.

### What If Another Transaction Already Updated It?

Suppose another transaction changed:

```text
version = 1
```

Now the previous query:

```sql
UPDATE products
SET stock = 9,
    version = version + 1
WHERE id = 1
AND version = 0;
```

affects zero rows.

This means the record changed since the application read it.

The application can:

1. Read the latest record.
2. Recalculate the intended change.
3. Retry if appropriate.
4. Or return a conflict response.

### Pessimistic vs Optimistic Locking

| Pessimistic Locking | Optimistic Locking |
|---|---|
| Locks records before modification | Checks whether data changed before modification |
| Assumes conflicts may happen | Assumes conflicts are relatively uncommon |
| Uses SELECT FOR UPDATE | Commonly uses a version column |
| Transactions may wait | Conflicts are detected during update |
| Useful for critical shared records | Useful when conflicts are infrequent |

---

# 16. What Is SELECT FOR UPDATE?

`SELECT ... FOR UPDATE` is a locking read that requests exclusive locks on the records it reads.

It is commonly used in transactions when the application must inspect a record and then modify it safely.

### Syntax

```sql
START TRANSACTION;

SELECT *
FROM accounts
WHERE id = 1
FOR UPDATE;
```

Now the matching record is locked for exclusive access.

Other transactions attempting conflicting operations must wait.

### Complete Example

```sql
START TRANSACTION;

SELECT balance
FROM accounts
WHERE id = 1
FOR UPDATE;

UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

COMMIT;
```

### When Should You Use It?

- Bank transfers.
- Inventory management.
- Ticket booking.
- Appointment booking.
- Payment processing.
- Any operation requiring read-modify-write consistency.

### Important

`FOR UPDATE` should be used inside an explicit transaction.

Without an active transaction, the lock does not provide the intended multi-statement protection because an autocommitted statement ends immediately.

---

# 17. What Is SELECT FOR SHARE?

`SELECT ... FOR SHARE` requests shared locks on the matching records.

It allows compatible shared locking reads but prevents conflicting modifications while the locks are held.

### Syntax

```sql
START TRANSACTION;

SELECT *
FROM employees
WHERE id = 1
FOR SHARE;
```

Another transaction can generally acquire a shared lock on the same record.

But a transaction trying to modify the record must wait for conflicting shared locks to be released.

### FOR UPDATE vs FOR SHARE

| FOR UPDATE | FOR SHARE |
|---|---|
| Requests exclusive locks | Requests shared locks |
| Used when the transaction plans to modify records | Used when shared locking is needed |
| Blocks conflicting readers requesting locks and writers | Blocks conflicting writers |
| Suitable for read-modify-write operations | Suitable for coordinated reads |

**Note:** Ordinary SELECT statements do not need FOR SHARE to read data. MVCC already supports consistent reads.

---

# 18. What Is a Deadlock?

A Deadlock occurs when two or more transactions wait for each other in such a way that none can proceed.

Let's understand with an example.

Suppose there are two accounts:

```text
Account A = ID 1
Account B = ID 2
```

### Transaction A

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 100
WHERE id = 1;
```

Transaction A locks Account A.

### Transaction B

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 200
WHERE id = 2;
```

Transaction B locks Account B.

Now:

Transaction A tries to update Account B:

```sql
UPDATE accounts
SET balance = balance + 100
WHERE id = 2;
```

Transaction B tries to update Account A:

```sql
UPDATE accounts
SET balance = balance + 200
WHERE id = 1;
```

The situation:

```text
Transaction A
    |
    | Holds Lock on Account A
    |
    ↓
Waiting for Account B
    ↑
    |
    | Holds Lock on Account B
    |
Transaction B
```

Neither transaction can continue.

This is a deadlock.

### How Does MySQL Handle Deadlocks?

InnoDB automatically detects deadlocks.

It selects one transaction as a victim and rolls it back so that the other transaction can proceed.

The application should handle the deadlock error and retry the transaction when appropriate.

---

# 19. How to Prevent Deadlocks?

Deadlocks cannot always be eliminated, but they can be reduced.

### Technique 1 – Access Records in a Consistent Order

Bad:

Transaction A:

```sql
UPDATE accounts
SET balance = balance - 100
WHERE id = 1;

UPDATE accounts
SET balance = balance + 100
WHERE id = 2;
```

Transaction B:

```sql
UPDATE accounts
SET balance = balance - 200
WHERE id = 2;

UPDATE accounts
SET balance = balance + 200
WHERE id = 1;
```

Both transactions access records in different orders.

Better:

Always access accounts in ascending ID order.

For example:

```text
Account 1 → Account 2
```

regardless of transfer direction.

This reduces circular waiting.

### Technique 2 – Keep Transactions Short

Avoid:

- Long calculations inside transactions.
- User interactions while a transaction is open.
- Network API calls while holding database locks.
- Unnecessary SQL statements inside transactions.

### Technique 3 – Use Appropriate Indexes

Poor indexes can cause MySQL to scan and lock more records than expected.

Use suitable indexes to narrow down the records being accessed.

### Technique 4 – Update Only Required Records

Avoid unnecessary updates.

### Technique 5 – Handle Deadlock Errors

A deadlock victim should be able to retry its transaction safely.

Use a limited retry strategy with a small delay.

---

# 20. What Is Lock Wait Timeout?

A Lock Wait Timeout occurs when a transaction waits too long to acquire a required lock.

MySQL has a configurable setting:

```sql
SHOW VARIABLES LIKE 'innodb_lock_wait_timeout';
```

Set a session-specific timeout:

```sql
SET SESSION innodb_lock_wait_timeout = 10;
```

This sets the lock wait timeout to 10 seconds for the current session.

### Example

Transaction A:

```sql
START TRANSACTION;

UPDATE employees
SET salary = 60000
WHERE id = 1;
```

Do not commit yet.

Transaction B:

```sql
START TRANSACTION;

UPDATE employees
SET salary = 70000
WHERE id = 1;
```

Transaction B must wait because Transaction A holds a conflicting lock.

If the lock is not released before the timeout, Transaction B receives a lock wait timeout error.

### Important Difference

| Deadlock | Lock Wait Timeout |
|---|---|
| Circular waiting dependency | Waiting exceeds configured time |
| InnoDB detects deadlock | Timeout occurs after waiting too long |
| InnoDB rolls back a victim transaction | By default, the failed statement is rolled back |
| Transaction-level rollback may occur depending on configuration | Application may need to explicitly roll back the transaction |

A relevant setting is:

```sql
SHOW VARIABLES LIKE 'innodb_rollback_on_timeout';
```

By default, a lock wait timeout generally rolls back only the waiting statement, not necessarily the entire transaction.

Your application should normally roll back the full transaction after an unexpected transactional error unless it has a deliberate recovery strategy.

---

# 21. What Is the Lost Update Problem?

A Lost Update occurs when two transactions read the same initial value and their updates overwrite each other's intended changes.

### Example

Initial balance:

```text
₹10,000
```

Transaction A reads:

```text
₹10,000
```

Transaction B reads:

```text
₹10,000
```

Transaction A calculates:

```text
₹10,000 + ₹2,000 = ₹12,000
```

Transaction B calculates:

```text
₹10,000 - ₹1,000 = ₹9,000
```

If both write their calculated values, the final balance may become:

```text
₹9,000
```

Transaction A's increase is lost.

### Better Solution 1 – Atomic UPDATE

Instead of reading and calculating in application code:

```sql
UPDATE accounts
SET balance = balance + 2000
WHERE id = 1;
```

This performs the arithmetic directly in the database.

### Better Solution 2 – Pessimistic Locking

```sql
START TRANSACTION;

SELECT balance
FROM accounts
WHERE id = 1
FOR UPDATE;

UPDATE accounts
SET balance = balance + 2000
WHERE id = 1;

COMMIT;
```

### Better Solution 3 – Optimistic Locking

Use a version column and verify that the version has not changed.

---

# 22. What Is a Dirty Write?

A Dirty Write occurs when one transaction overwrites data written by another transaction that has not yet committed.

Dirty writes are prevented by InnoDB's locking mechanisms.

### Example

Transaction A:

```sql
START TRANSACTION;

UPDATE employees
SET salary = 60000
WHERE id = 1;
```

Transaction B:

```sql
START TRANSACTION;

UPDATE employees
SET salary = 70000
WHERE id = 1;
```

Transaction B cannot simply overwrite Transaction A's uncommitted modification.

It must wait for the conflicting lock to be released.

**Important:** Dirty writes and dirty reads are different problems.

- Dirty write: overwriting another transaction's uncommitted changes.
- Dirty read: reading another transaction's uncommitted changes.

We will study dirty reads and other isolation anomalies in Phase 21.

---

# 23. What Is Lock Escalation?

Lock Escalation is a database mechanism in which many smaller locks are replaced by a larger lock.

For example:

```text
Many row locks → One table lock
```

Some database systems use lock escalation to reduce lock-management overhead.

### Does InnoDB Automatically Escalate Row Locks to Table Locks?

No. InnoDB does not use traditional automatic row-to-table lock escalation in the same way some other database systems do.

However, transactions can still acquire table-level locks for specific operations.

Do not confuse intention locks with lock escalation.

---

# 24. Practical MySQL Example – Inventory Locking

Let's implement an inventory system.

### Step 1 – Create Table

```sql
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    stock INT NOT NULL,

    CHECK (stock >= 0)
) ENGINE = InnoDB;
```

### Step 2 – Insert Data

```sql
INSERT INTO products (name, stock)
VALUES
('Laptop', 5),
('Mobile', 10),
('Keyboard', 20);
```

### Step 3 – Start Transaction

```sql
START TRANSACTION;
```

### Step 4 – Lock Product Record

```sql
SELECT *
FROM products
WHERE id = 1
FOR UPDATE;
```

### Step 5 – Check Stock

Suppose the stock is 5.

We want to purchase 2 units.

### Step 6 – Update Stock

```sql
UPDATE products
SET stock = stock - 2
WHERE id = 1
AND stock >= 2;
```

Verify that exactly one row was updated.

### Step 7 – Commit

```sql
COMMIT;
```

Final stock:

```text
5 - 2 = 3
```

### What If Another User Tries to Purchase Simultaneously?

The second transaction must wait for the conflicting lock.

After the first transaction commits, the second transaction can read the updated stock and proceed based on the new value.

This prevents both transactions from independently purchasing against the same stale stock value.

---

# 25. Advanced Topic – Locking With Multiple Rows

Suppose a customer transfers money between two accounts.

You should lock both records before changing their balances.

Example:

```sql
START TRANSACTION;

SELECT *
FROM accounts
WHERE id IN (1, 2)
ORDER BY id
FOR UPDATE;

-- Validate balances and transfer amount.

UPDATE accounts
SET balance = balance - 1000
WHERE id = 1
AND balance >= 1000;

UPDATE accounts
SET balance = balance + 1000
WHERE id = 2;

COMMIT;
```

The `ORDER BY id` helps establish a consistent logical access order.

For strict control over lock acquisition order, some implementations retrieve and lock each record in a known sequence rather than relying only on the result ordering of a multi-row query.

### Why Lock Both Accounts?

Because both balances are part of the same business operation.

Locking both records prevents another transaction from making conflicting changes while the transfer is being processed.

---

# 26. Advanced Topic – NOWAIT

MySQL 8.0 supports `NOWAIT` with locking reads.

It tells MySQL not to wait if the requested lock cannot be acquired immediately.

Instead, the statement returns an error.

Example:

```sql
START TRANSACTION;

SELECT *
FROM products
WHERE id = 1
FOR UPDATE NOWAIT;
```

### When Is It Useful?

- Real-time applications.
- Systems where waiting is undesirable.
- Operations that can quickly return a conflict response.

### Difference

Without NOWAIT:

```sql
SELECT *
FROM products
WHERE id = 1
FOR UPDATE;
```

The transaction waits for the lock.

With NOWAIT:

```sql
SELECT *
FROM products
WHERE id = 1
FOR UPDATE NOWAIT;
```

The query fails immediately if the lock is unavailable.

---

# 27. Advanced Topic – SKIP LOCKED

MySQL 8.0 also supports `SKIP LOCKED`.

It skips records that are already locked by other transactions rather than waiting for them.

This is particularly useful for job queues.

### Example: Job Queue

Suppose multiple workers process pending jobs.

```sql
START TRANSACTION;

SELECT *
FROM jobs
WHERE status = 'PENDING'
ORDER BY id
LIMIT 1
FOR UPDATE SKIP LOCKED;
```

Worker A locks Job 1.

Worker B executes the same query.

Instead of waiting for Job 1, Worker B skips it and selects another available job.

After processing:

```sql
UPDATE jobs
SET status = 'PROCESSING'
WHERE id = 2;

COMMIT;
```

### Important

`SKIP LOCKED` intentionally returns an incomplete view of the matching rows.

It is suitable for queue-like workloads, not general-purpose queries where every matching record must be considered.

---

# 28. How to Inspect Locks in MySQL

MySQL provides Performance Schema tables for inspecting lock information.

### Check Current Transactions

```sql
SELECT *
FROM information_schema.innodb_trx;
```

This provides information about active InnoDB transactions.

### Check Data Locks

```sql
SELECT *
FROM performance_schema.data_locks;
```

This displays lock information maintained by InnoDB.

### Check Lock Waits

```sql
SELECT *
FROM performance_schema.data_lock_waits;
```

This displays relationships between waiting and blocking locks.

### Check InnoDB Status

```sql
SHOW ENGINE INNODB STATUS;
```

This is particularly useful for diagnosing deadlocks.

The output contains information about:

- Active transactions.
- Latest detected deadlock.
- Lock waits.
- InnoDB internal status.

---

# 29. Concurrency Control in Node.js

Let's understand how this applies to your Node.js backend applications.

Suppose you have an endpoint:

```text
POST /purchase
```

Request:

```json
{
    "productId": 1,
    "quantity": 2
}
```

You need to:

1. Start a transaction.
2. Lock the product.
3. Check available stock.
4. Reduce stock.
5. Create an order.
6. Commit the transaction.
7. Roll back if something fails.

### Example Using mysql2

```javascript
const mysql = require("mysql2/promise");

const pool = mysql.createPool({
    host: "localhost",
    user: "root",
    password: "password",
    database: "shop_db",
    waitForConnections: true,
    connectionLimit: 10
});

async function purchaseProduct(productId, quantity) {
    const connection = await pool.getConnection();

    try {
        await connection.beginTransaction();

        // Lock product record
        const [products] = await connection.execute(
            `SELECT id, name, stock, price
             FROM products
             WHERE id = ?
             FOR UPDATE`,
            [productId]
        );

        if (products.length === 0) {
            throw new Error("Product not found");
        }

        const product = products[0];

        if (product.stock < quantity) {
            throw new Error("Insufficient stock");
        }

        // Update stock
        const [updateResult] = await connection.execute(
            `UPDATE products
             SET stock = stock - ?
             WHERE id = ?
             AND stock >= ?`,
            [quantity, productId, quantity]
        );

        if (updateResult.affectedRows !== 1) {
            throw new Error("Unable to update stock");
        }

        // Calculate total using trusted database price
        const totalAmount = product.price * quantity;

        // Create order
        const [orderResult] = await connection.execute(
            `INSERT INTO orders
             (product_id, quantity, total_amount)
             VALUES (?, ?, ?)`,
            [productId, quantity, totalAmount]
        );

        await connection.commit();

        return {
            success: true,
            orderId: orderResult.insertId,
            totalAmount
        };

    } catch (error) {
        await connection.rollback();
        throw error;

    } finally {
        connection.release();
    }
}
```

### Important Production Considerations

This example demonstrates transaction and locking concepts.

A real purchase workflow should also include:

- Input validation.
- Positive quantity validation.
- Customer authentication and authorization.
- Order item records.
- Idempotency.
- Payment processing outside long-held database locks.
- Safe handling of deadlocks.
- Appropriate retry logic.
- Transaction outcome reconciliation.

Never call an external payment API while holding database locks for an extended period.

A common design is to reserve inventory in a short database transaction, perform payment processing separately, and then confirm or release the reservation based on the payment result.

---

# 30. Common Concurrency Mistakes

| Mistake | Problem | Solution |
|---|---|---|
| Updating records without considering concurrency | Lost updates or incorrect results | Use atomic updates or locking |
| Not using transactions | Partial operations | Group related operations |
| Locking records for too long | Other transactions wait | Keep transactions short |
| Accessing records in different orders | Deadlocks become more likely | Use a consistent lock order |
| Ignoring lock wait errors | Requests fail unexpectedly | Handle and report lock failures |
| Blindly retrying every failure | Can duplicate business operations | Use safe retry rules and idempotency |
| Missing indexes | More records may be scanned and locked | Use suitable indexes |
| Using FOR UPDATE for every SELECT | Unnecessary blocking | Lock only when required |
| Ignoring deadlock logs | Repeated deadlocks remain unresolved | Inspect InnoDB status and improve transaction design |

---

# 31. Concurrency Control Interview Questions

### Beginner Level

1. What is concurrency?
2. What is concurrency control?
3. What is a database lock?
4. What is a shared lock?
5. What is an exclusive lock?
6. What is row-level locking?
7. What is table-level locking?
8. What is MVCC?
9. What is pessimistic locking?
10. What is optimistic locking?

### Intermediate Level

11. What is SELECT FOR UPDATE?
12. What is SELECT FOR SHARE?
13. What is a record lock?
14. What is a gap lock?
15. What is a next-key lock?
16. What is an intention lock?
17. What is a deadlock?
18. What is a lock wait timeout?
19. What is a lost update?
20. What is a dirty write?

### Advanced Level

21. How does InnoDB detect deadlocks?
22. How can deadlocks be prevented?
23. How does MVCC work internally?
24. What is the difference between record locks and gap locks?
25. What is the difference between optimistic and pessimistic locking?
26. What happens when a transaction crashes while holding locks?
27. What is NOWAIT?
28. What is SKIP LOCKED?
29. How does indexing affect locking?
30. How would you prevent two customers from purchasing the last product?
31. How would you safely implement a bank transfer?
32. How would you implement optimistic locking in Node.js?

---

# 32. Practical Assignments

## Assignment 1 – Shared Lock

Create an employees table.

Tasks:

1. Open two MySQL sessions.
2. Start a transaction in Session A.
3. Execute SELECT FOR SHARE.
4. Execute SELECT FOR SHARE in Session B.
5. Observe that both can acquire compatible shared locks.
6. Try updating the same row from Session B.
7. Observe the locking behavior.
8. Commit Session A.

## Assignment 2 – Exclusive Lock

Tasks:

1. Open two MySQL sessions.
2. Start a transaction in Session A.
3. Execute SELECT FOR UPDATE.
4. Try SELECT FOR UPDATE in Session B on the same record.
5. Observe the waiting behavior.
6. Commit Session A.
7. Observe Session B proceeding.

## Assignment 3 – Deadlock

Create two accounts.

Tasks:

1. Start Transaction A in Session A.
2. Update Account 1.
3. Start Transaction B in Session B.
4. Update Account 2.
5. Update Account 2 in Transaction A.
6. Update Account 1 in Transaction B.
7. Observe the deadlock.
8. Run SHOW ENGINE INNODB STATUS.

## Assignment 4 – Optimistic Locking

Create:

```sql
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    stock INT,
    version INT NOT NULL DEFAULT 0
);
```

Tasks:

1. Insert sample products.
2. Read a product's version.
3. Update the product using its version.
4. Update the same product from another session.
5. Try the first update again with the old version.
6. Observe the affected-row count.
7. Implement retry handling in Node.js.

## Assignment 5 – Inventory Management API

Create:

```text
POST /purchase
```

Requirements:

1. Accept product ID and quantity.
2. Start a transaction.
3. Lock the product using FOR UPDATE.
4. Verify product availability.
5. Reduce stock.
6. Create an order.
7. Commit on success.
8. Roll back on failure.
9. Handle deadlock errors.
10. Test with multiple simultaneous requests.

---

# 33. Phase 20 – Quick Revision Sheet

| Concept | Meaning |
|---|---|
| Concurrency | Multiple transactions executing during overlapping periods |
| Concurrency Control | Managing concurrent database operations safely |
| Shared Lock | Allows compatible shared locking reads |
| Exclusive Lock | Prevents conflicting access to a locked record |
| Row-Level Lock | Locks individual index records or ranges |
| Table-Level Lock | Locks an entire table |
| Intention Lock | Indicates intention to acquire row-level locks |
| Record Lock | Locks an index record |
| Gap Lock | Prevents certain insertions into an index gap |
| Next-Key Lock | Record lock combined with preceding gap lock |
| MVCC | Maintains multiple row versions for consistent reads |
| Pessimistic Locking | Locks records before modification |
| Optimistic Locking | Detects conflicting updates using version checks |
| FOR UPDATE | Requests exclusive locks |
| FOR SHARE | Requests shared locks |
| Deadlock | Transactions wait for each other in a circular dependency |
| Lock Wait Timeout | Waiting exceeds the configured timeout |
| Lost Update | One transaction overwrites another transaction's intended update |
| Dirty Write | Overwriting another transaction's uncommitted changes |
| NOWAIT | Fails immediately if the required lock is unavailable |
| SKIP LOCKED | Skips records that are already locked |

---

# 34. Phase 20 Completion Checklist

Before moving to Phase 21, make sure you understand:

- [ ] What is concurrency?
- [ ] What is concurrency control?
- [ ] Shared Locks.
- [ ] Exclusive Locks.
- [ ] Row-Level Locking.
- [ ] Table-Level Locking.
- [ ] Intention Locks.
- [ ] Record Locks.
- [ ] Gap Locks.
- [ ] Next-Key Locks.
- [ ] MVCC.
- [ ] Pessimistic Locking.
- [ ] Optimistic Locking.
- [ ] SELECT FOR UPDATE.
- [ ] SELECT FOR SHARE.
- [ ] Deadlocks.
- [ ] Deadlock Prevention.
- [ ] Lock Wait Timeout.
- [ ] Lost Update Problem.
- [ ] Dirty Write.
- [ ] Lock Escalation.
- [ ] NOWAIT.
- [ ] SKIP LOCKED.
- [ ] Inspecting Locks in MySQL.
- [ ] Concurrency Handling in Node.js.

**Phase 20 is complete when you can safely handle multiple simultaneous requests modifying the same database records without causing incorrect business results.**

---

# Next Phase – Phase 21: Transaction Isolation Levels

In Phase 20, we learned how locks and concurrency control work.

Now we need to understand how much isolation one transaction receives from other transactions.

MySQL supports four standard transaction isolation levels:

1. READ UNCOMMITTED.
2. READ COMMITTED.
3. REPEATABLE READ.
4. SERIALIZABLE.

We will cover:

- What are transaction isolation levels?
- Dirty Reads.
- Non-Repeatable Reads.
- Phantom Reads.
- Read Skew.
- READ UNCOMMITTED.
- READ COMMITTED.
- REPEATABLE READ.
- SERIALIZABLE.
- Default MySQL Isolation Level.
- SET TRANSACTION ISOLATION LEVEL.
- MVCC and Isolation Levels.
- Locking Behavior at Different Levels.
- Practical Two-Session Experiments.
- Isolation Level Performance Trade-offs.
- Interview Questions and Assignments.

**Next: Phase 21 – Transaction Isolation Levels.**