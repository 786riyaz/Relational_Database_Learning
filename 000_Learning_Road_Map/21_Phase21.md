# SQL Complete Learning Roadmap – Phase 21
# Transaction Isolation Levels

## 1. What Are Transaction Isolation Levels?

A database can handle multiple transactions simultaneously.

For example, imagine two users accessing the same bank account:

- Transaction A reads the account balance.
- Transaction B updates the account balance.
- Transaction A reads the balance again.

Should Transaction A see the updated balance or the original balance?

The answer depends on the **Transaction Isolation Level**.

A transaction isolation level determines how much one transaction is isolated from changes made by other concurrent transactions.

In simple terms:

**Isolation levels control what changes a transaction can see when other transactions are running simultaneously.**

They help prevent problems caused by concurrent database operations.

---

## 2. Why Do We Need Isolation Levels?

Consider this scenario:

An employee has a salary of ₹50,000.

Two transactions are running simultaneously:

**Transaction A:**
```sql
START TRANSACTION;

SELECT salary
FROM employees
WHERE id = 1;
```

**Transaction B:**
```sql
START TRANSACTION;

UPDATE employees
SET salary = 60000
WHERE id = 1;

COMMIT;
```

Transaction A executes the same SELECT query again.

What should happen?

There are different possibilities:

1. Transaction A sees ₹50,000 both times.
2. Transaction A sees ₹50,000 first and ₹60,000 second.
3. Transaction A might even see an uncommitted value from Transaction B under certain isolation settings.

These behaviors are controlled by transaction isolation levels.

---

# 3. Problems That Isolation Levels Prevent

Before learning the four isolation levels, understand the common concurrency problems.

There are four important concepts:

1. Dirty Read
2. Non-Repeatable Read
3. Phantom Read
4. Lost Update

## 3.1 Dirty Read

A dirty read occurs when one transaction reads data modified by another transaction that has not yet committed.

### Example

Suppose an employee's salary is ₹50,000.

**Transaction A:**
```sql
START TRANSACTION;

UPDATE employees
SET salary = 70000
WHERE id = 1;

-- Transaction A has not committed yet.
```

**Transaction B:**
```sql
START TRANSACTION;

SELECT salary
FROM employees
WHERE id = 1;
```

Suppose Transaction B reads ₹70,000.

However, Transaction A later executes:

```sql
ROLLBACK;
```

Now the actual salary returns to ₹50,000.

Transaction B has read a value that was never permanently committed.

This is called a **Dirty Read**.

### Visual Explanation

| Step | Transaction A | Transaction B |
|---|---|---|
| 1 | Updates salary to 70,000 | |
| 2 | Does not commit | |
| 3 | | Reads salary = 70,000 |
| 4 | Executes ROLLBACK | |
| 5 | Salary returns to 50,000 | |

Transaction B read uncommitted data.

**Real-world impact:**

Imagine a banking application displaying an incorrect balance because it reads an uncommitted transaction that is later rolled back.

---

## 3.2 Non-Repeatable Read

A non-repeatable read occurs when a transaction reads the same row twice but gets different values because another transaction modified and committed that row between the reads.

### Example

Suppose an employee's salary is ₹50,000.

**Transaction A:**
```sql
START TRANSACTION;

SELECT salary
FROM employees
WHERE id = 1;
```

Output:

```text
50000
```

Now Transaction B updates the salary.

**Transaction B:**
```sql
START TRANSACTION;

UPDATE employees
SET salary = 60000
WHERE id = 1;

COMMIT;
```

Transaction A executes the same query again:

```sql
SELECT salary
FROM employees
WHERE id = 1;
```

Output:

```text
60000
```

The same transaction received two different values for the same row.

This is called a **Non-Repeatable Read**.

### Visual Explanation

| Step | Transaction A | Transaction B |
|---|---|---|
| 1 | Reads salary = 50,000 | |
| 2 | | Updates salary to 60,000 |
| 3 | | COMMIT |
| 4 | Reads salary = 60,000 | |

**Real-world impact:**

An employee report might calculate information using different salary values during the same transaction.

---

## 3.3 Phantom Read

A phantom read occurs when a transaction executes the same range-based query twice but receives a different set of rows because another transaction inserted or deleted matching records.

### Example

Suppose we have an `employees` table.

**Transaction A:**
```sql
START TRANSACTION;

SELECT *
FROM employees
WHERE department = 'IT';
```

Output:

| id | name | department |
|---|---|---|
| 1 | Rahul | IT |
| 2 | Amit | IT |

Now Transaction B inserts another employee.

**Transaction B:**
```sql
START TRANSACTION;

INSERT INTO employees (id, name, department)
VALUES (3, 'Vijay', 'IT');

COMMIT;
```

Transaction A executes the same query again:

```sql
SELECT *
FROM employees
WHERE department = 'IT';
```

Output:

| id | name | department |
|---|---|---|
| 1 | Rahul | IT |
| 2 | Amit | IT |
| 3 | Vijay | IT |

A new matching row appeared.

This is called a **Phantom Read**.

### Difference Between Non-Repeatable Read and Phantom Read

| Non-Repeatable Read | Phantom Read |
|---|---|
| An existing row changes. | The set of matching rows changes. |
| Usually caused by UPDATE. | Usually caused by INSERT or DELETE. |
| Same row returns different values. | Same query returns different rows. |

---

## 3.4 Lost Update

A lost update occurs when two transactions read the same initial value and then update it independently, causing one transaction's change to overwrite the other's.

### Example

Suppose a bank account has ₹10,000.

Two transactions withdraw money simultaneously:

- Transaction A withdraws ₹1,000.
- Transaction B withdraws ₹2,000.

Both transactions initially read ₹10,000.

| Step | Transaction A | Transaction B |
|---|---|---|
| 1 | Reads 10,000 | |
| 2 | | Reads 10,000 |
| 3 | Calculates 9,000 | |
| 4 | | Calculates 8,000 |
| 5 | Updates balance to 9,000 | |
| 6 | | Updates balance to 8,000 |

Final balance:

```text
8000
```

But the correct balance should be:

```text
10000 - 1000 - 2000 = 7000
```

Transaction A's update was overwritten.

This is called a **Lost Update**.

Common solutions include:

- Pessimistic locking using `SELECT ... FOR UPDATE`.
- Optimistic locking using a version column.
- Atomic SQL updates such as `UPDATE accounts SET balance = balance - 1000 WHERE id = 1`.

---

# 4. Four Transaction Isolation Levels

SQL defines four standard transaction isolation levels.

From weakest to strongest:

1. READ UNCOMMITTED
2. READ COMMITTED
3. REPEATABLE READ
4. SERIALIZABLE

Let's understand each one.

## 4.1 READ UNCOMMITTED

This is the lowest isolation level.

A transaction can read changes made by another transaction even if those changes have not been committed.

### Example

**Transaction A:**
```sql
START TRANSACTION;

UPDATE employees
SET salary = 80000
WHERE id = 1;

-- No COMMIT yet.
```

**Transaction B:**
```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

START TRANSACTION;

SELECT salary
FROM employees
WHERE id = 1;
```

Transaction B may see:

```text
80000
```

Even though Transaction A has not committed.

### Characteristics

- Dirty reads: Possible.
- Non-repeatable reads: Possible.
- Phantom reads: Possible.
- Lowest isolation.
- Allows more concurrency but provides weaker consistency.

**Practical recommendation:** Avoid READ UNCOMMITTED for most business applications.

---

## 4.2 READ COMMITTED

Under this isolation level, a transaction can only read committed data.

It cannot read uncommitted changes from another transaction.

However, if another transaction commits changes between two SELECT statements, the first transaction can see those changes in its next SELECT.

### Example

**Transaction A:**
```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

SELECT salary
FROM employees
WHERE id = 1;
```

Output:

```text
50000
```

Now Transaction B:

```sql
START TRANSACTION;

UPDATE employees
SET salary = 60000
WHERE id = 1;

COMMIT;
```

Transaction A executes:

```sql
SELECT salary
FROM employees
WHERE id = 1;
```

Output:

```text
60000
```

The second query sees the newly committed value.

### Characteristics

- Dirty reads: Not possible.
- Non-repeatable reads: Possible.
- Phantom reads: Possible.
- Each consistent read gets a fresh snapshot.
- Often offers more concurrency than REPEATABLE READ.

**Practical use:** Applications where seeing the latest committed data on each statement is more important than keeping one consistent snapshot throughout a transaction.

---

## 4.3 REPEATABLE READ

This is the default transaction isolation level in MySQL InnoDB.

Under this isolation level, repeated consistent reads within the same transaction see the same snapshot of data.

### Example

**Transaction A:**
```sql
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;

SELECT salary
FROM employees
WHERE id = 1;
```

Output:

```text
50000
```

Now Transaction B updates the salary:

```sql
START TRANSACTION;

UPDATE employees
SET salary = 60000
WHERE id = 1;

COMMIT;
```

Transaction A executes:

```sql
SELECT salary
FROM employees
WHERE id = 1;
```

Output:

```text
50000
```

Even though Transaction B committed the new salary, Transaction A continues seeing its original snapshot.

### Characteristics

- Dirty reads: Not possible.
- Non-repeatable reads: Not possible for consistent reads.
- Phantom reads: Prevented for InnoDB consistent reads through snapshot behavior; locking range reads use next-key locking to prevent relevant phantom insertions.
- Provides a consistent snapshot within the transaction.
- Default in MySQL InnoDB.

**Practical use:** General business applications where transactions should work with a consistent view of data.

### Important MySQL Detail

The SQL standard describes REPEATABLE READ as potentially allowing phantom reads.

However, MySQL InnoDB provides additional behavior:

1. Ordinary consistent reads use MVCC snapshots.
2. Locking range reads can use gap locks and next-key locks to prevent matching rows from being inserted into the locked range.

Therefore, it is important to distinguish ordinary SELECT statements from locking reads.

---

## 4.4 SERIALIZABLE

This is the strongest standard isolation level.

It makes concurrent transactions behave as though they were executed one after another in a serial order.

It provides stronger protection against concurrency anomalies but can significantly reduce concurrency.

### Example

Transaction A:

```sql
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;

SELECT *
FROM employees
WHERE department = 'IT';
```

Transaction B:

```sql
START TRANSACTION;

INSERT INTO employees (id, name, department)
VALUES (10, 'Rahul', 'IT');
```

Depending on the locking situation, Transaction B may have to wait because Transaction A's query takes shared locks on the relevant data.

In InnoDB, when a transaction is active with autocommit disabled, ordinary SELECT statements under SERIALIZABLE are converted into shared locking reads.

### Characteristics

- Dirty reads: Not possible.
- Non-repeatable reads: Prevented.
- Phantom reads: Prevented.
- More locking and blocking.
- Lower concurrency in many workloads.

**Practical use:** Situations where strict serial execution semantics are needed and the performance cost is acceptable.

---

# 5. Comparison of All Four Isolation Levels

| Isolation Level | Dirty Read | Non-Repeatable Read | Phantom Read |
|---|---|---|---|
| READ UNCOMMITTED | Possible | Possible | Possible |
| READ COMMITTED | Prevented | Possible | Possible |
| REPEATABLE READ | Prevented | Prevented | Prevented in typical InnoDB read patterns |
| SERIALIZABLE | Prevented | Prevented | Prevented |

**Important:** This is a simplified comparison for learning. The precise behavior depends on the database engine and whether you use ordinary consistent reads or locking reads. InnoDB's REPEATABLE READ has stronger phantom protection than the basic SQL-standard description.

---

# 6. How MySQL Uses MVCC

You have already learned about MVCC (Multi-Version Concurrency Control) in the previous phase.

MVCC is one of the main mechanisms InnoDB uses to provide transaction isolation.

Instead of making every transaction wait for other transactions to finish, InnoDB can maintain multiple versions of a row.

For example:

Suppose an employee's salary changes:

```text
Original salary: 50,000
Updated salary: 60,000
```

Transaction A started earlier and established a consistent read snapshot.

Transaction B updates the salary and commits.

With REPEATABLE READ:

- Transaction A continues seeing the older committed version.
- Transaction B sees its updated value.
- A new transaction sees the latest committed value.

### Consistent Read Behavior

| Isolation Level | Consistent Read Snapshot |
|---|---|
| READ UNCOMMITTED | Does not provide the normal consistent snapshot guarantee |
| READ COMMITTED | New snapshot for each consistent SELECT |
| REPEATABLE READ | Snapshot established by the first consistent read and reused |
| SERIALIZABLE | Ordinary SELECTs become locking reads in an active transaction with autocommit disabled |

### Important: Consistent Reads vs Locking Reads

These are different:

**Consistent read:**
```sql
SELECT *
FROM employees
WHERE id = 1;
```

**Locking read:**
```sql
SELECT *
FROM employees
WHERE id = 1
FOR UPDATE;
```

A normal SELECT generally reads from an MVCC snapshot in InnoDB.

A locking read acquires locks and uses current-read behavior rather than simply reading the transaction's original consistent snapshot.

This distinction is especially important when working with REPEATABLE READ.

---

# 7. Checking the Current Isolation Level in MySQL

You can check the current session isolation level using:

```sql
SELECT @@transaction_isolation;
```

To check the session-level setting explicitly:

```sql
SELECT @@SESSION.transaction_isolation;
```

To check the global setting:

```sql
SELECT @@GLOBAL.transaction_isolation;
```

Example output:

```text
REPEATABLE-READ
```

This is the default MySQL InnoDB isolation level.

---

# 8. Changing Transaction Isolation Levels

MySQL allows you to change isolation levels at different scopes.

## 8.1 Change Isolation Level for Current Session

```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

Other examples:

```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

This affects the current connection.

It does not automatically affect other MySQL connections.

## 8.2 Change Global Isolation Level

```sql
SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

This changes the default isolation level for newly created sessions.

Existing connections keep their current session settings.

## 8.3 Change Isolation Level for the Next Transaction Only

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

This applies to the next transaction in the current session.

### Important Rules

- Set the isolation level before starting the transaction.
- Do not try to change it in the middle of an active transaction.
- SESSION affects the current connection.
- GLOBAL affects the default for new connections.
- A pooled Node.js connection may retain its session configuration when reused.

---

# 9. Practical Experiments Using Two MySQL Sessions

This is one of the most important practical exercises in this phase.

Open two separate MySQL Workbench query tabs.

Use:

- Session A: First query tab.
- Session B: Second query tab.

Both sessions should connect to the same database server.

Create a sample table:

```sql
CREATE DATABASE isolation_demo;

USE isolation_demo;

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department VARCHAR(50)
) ENGINE = InnoDB;

INSERT INTO employees
VALUES
(1, 'Rahul', 50000, 'IT'),
(2, 'Amit', 60000, 'HR'),
(3, 'Vijay', 70000, 'IT');
```

## Experiment 1: Dirty Read

### Session A

```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

START TRANSACTION;

UPDATE employees
SET salary = 90000
WHERE id = 1;
```

Do not commit.

### Session B

```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

START TRANSACTION;

SELECT salary
FROM employees
WHERE id = 1;
```

You may see:

```text
90000
```

This is a dirty read.

Now execute in Session A:

```sql
ROLLBACK;
```

The salary returns to:

```text
50000
```

### Repeat Using READ COMMITTED

In Session B:

```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

Start a new transaction and repeat the experiment.

Session B will see the last committed salary rather than Session A's uncommitted update.

---

## Experiment 2: Non-Repeatable Read

### Session A

```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

SELECT salary
FROM employees
WHERE id = 1;
```

Output:

```text
50000
```

### Session B

```sql
START TRANSACTION;

UPDATE employees
SET salary = 65000
WHERE id = 1;

COMMIT;
```

### Session A

Execute again:

```sql
SELECT salary
FROM employees
WHERE id = 1;
```

Output:

```text
65000
```

This demonstrates a non-repeatable read.

Now repeat the same experiment using REPEATABLE READ in Session A.

The second SELECT will continue seeing the original snapshot value.

---

## Experiment 3: Phantom Read

### Session A

```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

SELECT *
FROM employees
WHERE department = 'IT';
```

Suppose two employees are returned.

### Session B

```sql
START TRANSACTION;

INSERT INTO employees
VALUES (4, 'Karan', 55000, 'IT');

COMMIT;
```

### Session A

Execute again:

```sql
SELECT *
FROM employees
WHERE department = 'IT';
```

Now three employees are returned.

A new matching row appeared.

This demonstrates a phantom read.

### Repeat Using REPEATABLE READ

Set Session A to:

```sql
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
```

Start a new transaction and execute the first SELECT.

Then insert another matching employee and commit in Session B.

When Session A executes the same ordinary SELECT again, it continues seeing its original snapshot.

**Remember:** This example demonstrates InnoDB's consistent-read snapshot behavior. A locking range read such as `SELECT ... FOR UPDATE` behaves differently and can acquire next-key locks.

---

# 10. Isolation Levels and Performance

Higher isolation generally means stronger consistency guarantees but potentially more locking and blocking.

| Isolation Level | Consistency | Concurrency | Typical Recommendation |
|---|---|---|---|
| READ UNCOMMITTED | Very low | High | Rarely recommended |
| READ COMMITTED | Moderate | Generally higher | Useful in suitable workloads |
| REPEATABLE READ | High | Good | MySQL InnoDB default |
| SERIALIZABLE | Very high | More restrictive | Use when required |

### Which Isolation Level Should You Use?

For most MySQL applications:

**REPEATABLE READ**

It provides a consistent snapshot and is the default in InnoDB.

**READ COMMITTED**

Consider it when your application benefits from seeing newly committed data on each statement and can tolerate non-repeatable and phantom reads.

**SERIALIZABLE**

Use it when stronger serial execution semantics are necessary.

**READ UNCOMMITTED**

Generally avoid it for normal business transactions.

There is no universally best isolation level. The right choice depends on the application's correctness requirements and concurrency characteristics.

---

# 11. Using Isolation Levels with Node.js and MySQL2

Since you are learning Node.js backend development, it is important to understand how to configure isolation levels in application code.

Install the package:

```bash
npm install mysql2
```

Example:

```javascript
const mysql = require("mysql2/promise");

async function runTransaction() {
    const connection = await mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "password",
        database: "isolation_demo"
    });

    try {
        // Configure isolation before starting the transaction.
        await connection.query(
            "SET TRANSACTION ISOLATION LEVEL REPEATABLE READ"
        );

        await connection.beginTransaction();

        const [employees] = await connection.query(
            "SELECT * FROM employees WHERE department = ?",
            ["IT"]
        );

        console.log(employees);

        await connection.commit();

    } catch (error) {
        await connection.rollback();

        console.error("Transaction failed:", error);

    } finally {
        await connection.end();
    }
}

runTransaction();
```

### Important

For production applications using connection pools:

1. Acquire one connection from the pool.
2. Configure its isolation level.
3. Start the transaction.
4. Execute all transaction queries using that connection.
5. Commit or roll back.
6. Release the connection.

Do not assume separate queries issued through a pool will use the same database session.

---

# 12. Common Mistakes

| Mistake | Correct Understanding |
|---|---|
| Thinking REPEATABLE READ means every SELECT locks rows | Ordinary SELECTs generally use MVCC consistent reads. |
| Thinking READ COMMITTED prevents all concurrency problems | Non-repeatable and phantom reads can still occur. |
| Thinking SERIALIZABLE is always the best option | It can reduce concurrency and increase blocking. |
| Confusing phantom reads with non-repeatable reads | One changes existing row values; the other changes the matching row set. |
| Changing isolation level after starting a transaction | Configure it before the transaction begins. |
| Assuming GLOBAL changes existing connections | It affects the default for new sessions. |
| Assuming all MySQL engines behave like InnoDB | Isolation behavior depends on the storage engine. |
| Assuming MVCC eliminates all locks | InnoDB still uses locks for writes and locking reads. |

---

# 13. Interview Questions and Answers

### Q1. What is a transaction isolation level?

A transaction isolation level determines how visible concurrent transaction changes are to a transaction and which concurrency anomalies are permitted.

### Q2. What are the four standard isolation levels?

1. READ UNCOMMITTED
2. READ COMMITTED
3. REPEATABLE READ
4. SERIALIZABLE

### Q3. What is a dirty read?

Reading uncommitted data modified by another transaction.

### Q4. What is a non-repeatable read?

Reading the same row twice within a transaction and receiving different committed values.

### Q5. What is a phantom read?

Executing the same range query twice and receiving a different set of matching rows.

### Q6. What is the difference between a dirty read and a non-repeatable read?

A dirty read involves uncommitted changes. A non-repeatable read involves changes committed by another transaction.

### Q7. What is the default isolation level in MySQL InnoDB?

REPEATABLE READ.

### Q8. Which isolation level provides the strongest standard isolation?

SERIALIZABLE.

### Q9. What is MVCC?

Multi-Version Concurrency Control. It allows transactions to read appropriate versions of rows without requiring every ordinary read to block concurrent writes.

### Q10. Does REPEATABLE READ prevent phantom reads in MySQL?

InnoDB's consistent reads use a transaction snapshot, so repeated ordinary reads do not see newly committed matching rows. Locking range reads can use gap and next-key locks to prevent relevant phantom insertions.

### Q11. How can you check the current isolation level?

```sql
SELECT @@transaction_isolation;
```

### Q12. How can you change the isolation level for the current session?

```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

### Q13. What is the difference between SESSION and GLOBAL isolation settings?

SESSION changes the current connection. GLOBAL changes the default for newly established connections.

### Q14. What is the difference between a consistent read and a locking read?

A consistent read uses an MVCC snapshot. A locking read acquires locks and uses current-read behavior.

### Q15. Which isolation level should you use in a banking application?

It depends on the operation. REPEATABLE READ or SERIALIZABLE may be appropriate for some workflows, but correct locking, atomic updates, transaction design, and application-level validation are also essential.

---

# 14. Practical Assignments

Complete these exercises using MySQL Workbench.

### Assignment 1: Isolation Level Inspection

1. Check the current isolation level.
2. Change it to READ COMMITTED.
3. Check it again.
4. Change it to REPEATABLE READ.
5. Check it again.

### Assignment 2: Dirty Read

1. Open two MySQL sessions.
2. Set both to READ UNCOMMITTED.
3. Update an employee's salary in Session A.
4. Do not commit.
5. Read the salary in Session B.
6. Roll back Session A.
7. Repeat using READ COMMITTED.

### Assignment 3: Non-Repeatable Read

1. Set Session A to READ COMMITTED.
2. Read an employee's salary.
3. Update and commit the salary using Session B.
4. Read the salary again in Session A.
5. Repeat using REPEATABLE READ.
6. Compare the outputs.

### Assignment 4: Phantom Read

1. Create a transaction in Session A.
2. Execute a department-based SELECT.
3. Insert a matching employee using Session B.
4. Execute the same SELECT again in Session A.
5. Repeat using REPEATABLE READ.
6. Compare the outputs.

### Assignment 5: SERIALIZABLE

1. Set Session A to SERIALIZABLE.
2. Start a transaction.
3. Execute a SELECT.
4. Try inserting or updating matching data from Session B.
5. Observe whether Session B waits.
6. Commit Session A and observe what happens.

### Assignment 6: Node.js Integration

Create a Node.js application using MySQL2 that:

1. Connects to MySQL.
2. Sets the isolation level to REPEATABLE READ.
3. Starts a transaction.
4. Reads employee records.
5. Commits the transaction.
6. Rolls back if an error occurs.
7. Releases the connection properly.

---

# 15. Quick Revision

| Concept | Meaning |
|---|---|
| Isolation Level | Controls transaction visibility and isolation |
| Dirty Read | Reading uncommitted data |
| Non-Repeatable Read | Same row returns different values |
| Phantom Read | Same range query returns a different set of rows |
| Lost Update | One transaction overwrites another transaction's update |
| READ UNCOMMITTED | Allows dirty reads |
| READ COMMITTED | Reads only committed data |
| REPEATABLE READ | Maintains a consistent snapshot for repeated consistent reads |
| SERIALIZABLE | Provides the strongest standard isolation |
| MVCC | Maintains multiple row versions |
| Consistent Read | Reads from an MVCC snapshot |
| Locking Read | Reads while acquiring locks |
| Default MySQL InnoDB Level | REPEATABLE READ |

---

# 16. Phase 21 Completion Checklist

You should now be able to:

- [ ] Explain transaction isolation levels.
- [ ] Understand why isolation levels are required.
- [ ] Explain dirty reads.
- [ ] Explain non-repeatable reads.
- [ ] Explain phantom reads.
- [ ] Explain lost updates.
- [ ] Understand all four isolation levels.
- [ ] Compare their consistency guarantees.
- [ ] Understand MVCC and consistent snapshots.
- [ ] Differentiate consistent reads and locking reads.
- [ ] Check the current MySQL isolation level.
- [ ] Change SESSION and GLOBAL isolation levels.
- [ ] Perform practical experiments using two MySQL sessions.
- [ ] Configure transaction isolation in Node.js.

---

# Next Phase: Phase 22 – Stored Procedures, Functions and Triggers

In the next phase, we will learn:

1. What are stored procedures?
2. Creating and calling stored procedures.
3. IN, OUT and INOUT parameters.
4. Variables inside stored procedures.
5. IF, ELSEIF and ELSE conditions.
6. WHILE, REPEAT and LOOP.
7. Stored functions.
8. Stored procedures vs functions.
9. Triggers: BEFORE INSERT, AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE and AFTER DELETE.
10. OLD and NEW keywords.
11. Practical audit logging.
12. Stored procedure and trigger integration with Node.js.

**Phase 21 is complete.**