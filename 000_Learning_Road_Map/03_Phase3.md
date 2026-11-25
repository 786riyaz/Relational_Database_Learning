# SQL Complete Course – Phase 3
# Database and Table Operations

**Level:** Beginner  
**Phase:** 3 of 25  
**Goal:** Learn how to create, view, modify, rename, and delete databases and tables using SQL.

In this phase, we'll start writing actual SQL queries.

We'll use MySQL 8.0+ syntax throughout the examples.

---

# 1. What is a Database?

A database is an organized collection of data.

In MySQL, a database contains database objects such as:

- Tables
- Views
- Stored Procedures
- Functions
- Triggers
- Events

Example:

Imagine we're building an Employee Management System.

We'll create a database called:

```text
company_db
```

Inside this database, we'll eventually create:

```text
company_db
    |
    |---- employees
    |
    |---- departments
    |
    |---- salaries
    |
    |---- attendance
    |
    |---- projects
```

Each table stores a particular type of information.

---

# 2. CREATE DATABASE

The `CREATE DATABASE` statement is used to create a new database.

### Syntax

```sql
CREATE DATABASE database_name;
```

### Example

```sql
CREATE DATABASE company_db;
```

This creates a database named `company_db`.

### Creating Another Database

```sql
CREATE DATABASE school_db;
```

### Important

Database names should be meaningful.

Good naming examples:

```text
company_db
expense_tracker
ecommerce_db
student_management
hospital_db
```

Avoid:

```text
database1
abc
test123
my database
```

---

# 3. SHOW DATABASES

The `SHOW DATABASES` statement displays the databases available on the MySQL server that your account is permitted to see.

### Syntax

```sql
SHOW DATABASES;
```

### Example

```sql
SHOW DATABASES;
```

Expected output (illustrative):

| Database |
|---|
| information_schema |
| mysql |
| performance_schema |
| sys |
| company_db |
| school_db |

### Important System Databases

MySQL creates several system databases.

| Database | Purpose |
|---|---|
| information_schema | Provides metadata about database objects |
| mysql | Stores system and account-related information |
| performance_schema | Provides performance monitoring information |
| sys | Provides simplified views for performance analysis |

**Important:** Don't manually delete or modify system databases unless you understand the consequences.

---

# 4. CREATE DATABASE IF NOT EXISTS

Suppose you execute:

```sql
CREATE DATABASE company_db;
```

But `company_db` already exists.

MySQL returns an error because a database with that name already exists.

To avoid this, use `IF NOT EXISTS`.

### Syntax

```sql
CREATE DATABASE IF NOT EXISTS database_name;
```

### Example

```sql
CREATE DATABASE IF NOT EXISTS company_db;
```

Now:

- If the database doesn't exist, MySQL creates it.
- If the database already exists, MySQL displays a warning instead of throwing an error.

### Difference

```sql
CREATE DATABASE company_db;
```

This produces an error if the database already exists.

```sql
CREATE DATABASE IF NOT EXISTS company_db;
```

This avoids that duplicate-database error.

### Real-world Usage

This is useful in:

- Database initialization scripts.
- Automated deployments.
- Development environments.
- Application setup scripts.

---

# 5. USE DATABASE

Suppose you have multiple databases:

```text
company_db
school_db
expense_tracker
```

You want to work with `company_db`.

Use the `USE` statement.

### Syntax

```sql
USE database_name;
```

### Example

```sql
USE company_db;
```

Expected output:

```text
Database changed
```

Now MySQL selects `company_db` as the current database.

You can execute queries against its tables without specifying the database name every time.

### Example

```sql
USE company_db;

CREATE TABLE employees (
    id INT,
    name VARCHAR(100)
);
```

Here, the `employees` table will be created inside `company_db`.

### Important

`USE` does not create a database.

It only selects an existing database for subsequent statements in the current session.

---

# 6. SELECT DATABASE()

How can we check which database is currently selected?

Use:

```sql
SELECT DATABASE();
```

Example:

```sql
USE company_db;

SELECT DATABASE();
```

Expected output:

| DATABASE() |
|---|
| company_db |

If no database is selected, it returns `NULL`.

This is useful when working with multiple databases.

---

# 7. DROP DATABASE

The `DROP DATABASE` statement permanently removes a database and its objects.

### Syntax

```sql
DROP DATABASE database_name;
```

### Example

```sql
DROP DATABASE school_db;
```

This deletes:

- The `school_db` database.
- All its tables.
- All its views.
- Its other contained database objects.

### Important Warning

**DROP DATABASE is a destructive operation.**

Once executed, the database and its data are removed.

Always verify the database name before executing this command.

### DROP DATABASE IF EXISTS

Suppose the database doesn't exist.

Executing:

```sql
DROP DATABASE school_db;
```

Will produce an error.

Instead:

```sql
DROP DATABASE IF EXISTS school_db;
```

This avoids an error if the database doesn't exist.

### Practical Example

```sql
CREATE DATABASE IF NOT EXISTS temporary_db;

DROP DATABASE IF EXISTS temporary_db;
```

---

# 8. What is a Table?

A table is a database object that stores structured data in rows and columns.

Example:

**employees**

| id | name | age | salary |
|---:|---|---:|---:|
| 1 | Riyaz | 25 | 50000 |
| 2 | Ahmed | 26 | 60000 |
| 3 | Rahul | 24 | 45000 |

Here:

- `employees` is the table name.
- `id`, `name`, `age`, and `salary` are columns.
- Each employee represents a row.

---

# 9. CREATE TABLE

The `CREATE TABLE` statement is used to create a new table inside a database.

### Syntax

```sql
CREATE TABLE table_name (
    column1 datatype,
    column2 datatype,
    column3 datatype
);
```

### Example

First select your database:

```sql
USE company_db;
```

Now create an employees table:

```sql
CREATE TABLE employees (
    id INT,
    name VARCHAR(100),
    age INT,
    salary DECIMAL(10, 2)
);
```

Explanation:

| Column | Data Type | Purpose |
|---|---|---|
| id | INT | Employee ID |
| name | VARCHAR(100) | Employee name |
| age | INT | Employee age |
| salary | DECIMAL(10,2) | Employee salary |

### Understanding DECIMAL(10,2)

`DECIMAL(10,2)` means:

- Maximum total digits: 10.
- Digits after decimal point: 2.
- Digits before decimal point: 8.

Example:

```text
12345678.99
```

This value contains 10 digits in total.

We'll study data types in detail in Phase 4.

---

# 10. CREATE TABLE IF NOT EXISTS

Suppose you execute:

```sql
CREATE TABLE employees (
    id INT,
    name VARCHAR(100)
);
```

If the table already exists, MySQL generates an error.

To avoid this:

### Syntax

```sql
CREATE TABLE IF NOT EXISTS table_name (
    column1 datatype,
    column2 datatype
);
```

### Example

```sql
CREATE TABLE IF NOT EXISTS employees (
    id INT,
    name VARCHAR(100)
);
```

If the table already exists, MySQL does not create another table.

**Important:** `IF NOT EXISTS` does not modify an existing table to match your new definition. It simply avoids the duplicate-table error.

---

# 11. SHOW TABLES

The `SHOW TABLES` statement displays tables in the currently selected database that your account is permitted to see.

### Syntax

```sql
SHOW TABLES;
```

### Example

```sql
USE company_db;

SHOW TABLES;
```

Expected output:

| Tables_in_company_db |
|---|
| employees |

If you create more tables:

```sql
CREATE TABLE departments (
    id INT,
    department_name VARCHAR(100)
);
```

Execute:

```sql
SHOW TABLES;
```

Expected output:

| Tables_in_company_db |
|---|
| departments |
| employees |

---

# 12. DESCRIBE TABLE

The `DESCRIBE` statement displays the structure of a table.

It shows information such as:

- Column names.
- Data types.
- NULL permissions.
- Key information.
- Default values.
- Extra properties.

### Syntax

```sql
DESCRIBE table_name;
```

You can also use:

```sql
DESC table_name;
```

### Example

```sql
DESC employees;
```

Expected output:

| Field | Type | Null | Key | Default | Extra |
|---|---|---|---|---|---|
| id | int | YES | | NULL | |
| name | varchar(100) | YES | | NULL | |
| age | int | YES | | NULL | |
| salary | decimal(10,2) | YES | | NULL | |

### DESCRIBE vs SHOW TABLES

| DESCRIBE | SHOW TABLES |
|---|---|
| Displays the structure of a particular table | Displays table names |
| Shows columns and data types | Shows available tables |
| Requires a table name | Does not require a table name |

---

# 13. SHOW CREATE TABLE

Sometimes you want to see the complete SQL statement used to create a table.

Use:

```sql
SHOW CREATE TABLE employees;
```

Example output (simplified):

```sql
CREATE TABLE `employees` (
    `id` int DEFAULT NULL,
    `name` varchar(100) DEFAULT NULL,
    `age` int DEFAULT NULL,
    `salary` decimal(10,2) DEFAULT NULL
);
```

This is useful for:

- Understanding table structures.
- Debugging.
- Database migrations.
- Recreating tables.
- Inspecting constraints and indexes.

**Difference:**

`DESCRIBE` shows the table structure in a tabular format.

`SHOW CREATE TABLE` shows the complete CREATE TABLE definition.

---

# 14. ALTER TABLE

The `ALTER TABLE` statement is used to modify the structure of an existing table.

For example, suppose your employees table currently contains:

```text
id
name
age
salary
```

Now you want to add an email column.

You can use `ALTER TABLE`.

### A. ADD COLUMN

Syntax:

```sql
ALTER TABLE table_name
ADD COLUMN column_name datatype;
```

Example:

```sql
ALTER TABLE employees
ADD COLUMN email VARCHAR(150);
```

Now the table contains:

```text
id
name
age
salary
email
```

### B. ADD MULTIPLE COLUMNS

```sql
ALTER TABLE employees
ADD COLUMN phone VARCHAR(15),
ADD COLUMN city VARCHAR(100);
```

Now two new columns are added.

### C. MODIFY COLUMN

The `MODIFY COLUMN` statement changes the data type or other supported column attributes.

Example:

```sql
ALTER TABLE employees
MODIFY COLUMN name VARCHAR(200);
```

Previously:

```text
VARCHAR(100)
```

Now:

```text
VARCHAR(200)
```

### D. CHANGE COLUMN

The `CHANGE COLUMN` statement can rename a column and modify its definition.

Syntax:

```sql
ALTER TABLE table_name
CHANGE COLUMN old_name new_name datatype;
```

Example:

```sql
ALTER TABLE employees
CHANGE COLUMN name employee_name VARCHAR(200);
```

Now:

```text
employee_name
```

replaces:

```text
name
```

**Important:** When using `CHANGE COLUMN`, you must specify the column definition again.

### E. RENAME COLUMN

MySQL also supports a dedicated command to rename a column.

```sql
ALTER TABLE employees
RENAME COLUMN employee_name TO name;
```

This changes the column name without requiring you to restate its data type.

### F. DROP COLUMN

The `DROP COLUMN` statement removes a column from a table.

Syntax:

```sql
ALTER TABLE table_name
DROP COLUMN column_name;
```

Example:

```sql
ALTER TABLE employees
DROP COLUMN phone;
```

The phone column is permanently removed, including its stored values.

### G. Add a Column at a Specific Position

MySQL supports `FIRST` and `AFTER`.

Add a column at the beginning:

```sql
ALTER TABLE employees
ADD COLUMN employee_code VARCHAR(20) FIRST;
```

Add a column after `name`:

```sql
ALTER TABLE employees
ADD COLUMN department VARCHAR(100) AFTER name;
```

### H. Rename a Table Using ALTER

```sql
ALTER TABLE employees
RENAME TO staff;
```

The table is now named `staff`.

---

# 15. DROP TABLE

The `DROP TABLE` statement permanently removes a table and its data.

### Syntax

```sql
DROP TABLE table_name;
```

### Example

```sql
DROP TABLE employees;
```

This removes the entire employees table.

It deletes:

- Table structure.
- All records.
- Associated table indexes.
- Associated table triggers.

### DROP TABLE IF EXISTS

```sql
DROP TABLE IF EXISTS employees;
```

This avoids an error if the table doesn't exist.

### Dropping Multiple Tables

```sql
DROP TABLE employees, departments;
```

This removes both tables.

**Warning:** DROP TABLE is destructive. Always check the table name before executing it.

---

# 16. TRUNCATE TABLE

The `TRUNCATE TABLE` statement removes all records from a table while preserving its table structure.

### Syntax

```sql
TRUNCATE TABLE table_name;
```

### Example

Suppose employees contains:

| id | name |
|---:|---|
| 1 | Riyaz |
| 2 | Ahmed |
| 3 | Rahul |

Execute:

```sql
TRUNCATE TABLE employees;
```

Now the table contains zero records.

However, the table still exists.

Its columns and indexes remain.

### Important Characteristics

1. Removes all records.
2. Keeps the table structure.
3. Does not support a WHERE clause.
4. Resets the AUTO_INCREMENT counter in MySQL.
5. Is generally implemented as a DDL operation.
6. Causes an implicit commit and cannot be rolled back like an ordinary transactional DELETE in MySQL.

We'll discuss `DELETE` in detail in Phase 5.

---

# 17. RENAME TABLE

The `RENAME TABLE` statement changes the name of an existing table.

### Syntax

```sql
RENAME TABLE old_table_name TO new_table_name;
```

### Example

```sql
RENAME TABLE employees TO staff;
```

Now:

```text
employees → staff
```

The table's data remains intact.

### Renaming Multiple Tables

```sql
RENAME TABLE
    employees TO staff,
    departments TO company_departments;
```

### RENAME TABLE vs ALTER TABLE RENAME

Both can rename tables.

```sql
RENAME TABLE employees TO staff;
```

And:

```sql
ALTER TABLE employees RENAME TO staff;
```

Both are valid in MySQL.

---

# 18. Difference Between DROP, DELETE, and TRUNCATE

This is one of the most important SQL interview questions.

| Feature | DROP | DELETE | TRUNCATE |
|---|---|---|---|
| Purpose | Removes table | Removes records | Removes all records |
| Table structure | Deleted | Preserved | Preserved |
| WHERE condition | No | Yes | No |
| Removes all records | Yes | Yes, without WHERE | Yes |
| AUTO_INCREMENT reset | Table removed | Normally not reset | Reset |
| Operation type | DDL | DML | DDL |
| Rollback in MySQL | No | Possible within a transaction for InnoDB | No |
| Table remains | No | Yes | Yes |

### Example

**DROP:**

```sql
DROP TABLE employees;
```

Entire table is deleted.

**DELETE:**

```sql
DELETE FROM employees
WHERE id = 1;
```

Only the employee with ID 1 is deleted.

**TRUNCATE:**

```sql
TRUNCATE TABLE employees;
```

All employee records are deleted, but the table remains.

### Practical Analogy

Imagine a notebook.

- DROP = Destroy the entire notebook.
- DELETE = Erase selected entries.
- TRUNCATE = Erase all entries but keep the notebook.

---

# 19. IF EXISTS vs IF NOT EXISTS

These clauses are used to avoid certain errors when working with database objects.

### IF NOT EXISTS

Used when creating objects.

Example:

```sql
CREATE DATABASE IF NOT EXISTS company_db;
```

Meaning:

Create the database only if it doesn't already exist.

Other examples:

```sql
CREATE TABLE IF NOT EXISTS employees (
    id INT
);
```

### IF EXISTS

Used with certain operations that remove or modify existing objects.

Example:

```sql
DROP DATABASE IF EXISTS company_db;
```

```sql
DROP TABLE IF EXISTS employees;
```

Meaning:

Perform the operation only if the object exists.

### Comparison

| IF EXISTS | IF NOT EXISTS |
|---|---|
| Checks whether an object exists | Checks whether an object does not exist |
| Commonly used with DROP | Commonly used with CREATE |
| Prevents missing-object errors | Prevents duplicate-object errors |

---

# 20. Complete Practical Example

Now let's combine everything.

We'll create a small Employee Management Database.

### Step 1: Create Database

```sql
CREATE DATABASE IF NOT EXISTS company_db;
```

### Step 2: Select Database

```sql
USE company_db;
```

### Step 3: Check Current Database

```sql
SELECT DATABASE();
```

### Step 4: Create Employees Table

```sql
CREATE TABLE IF NOT EXISTS employees (
    id INT,
    name VARCHAR(100),
    age INT,
    salary DECIMAL(10,2)
);
```

### Step 5: Check Tables

```sql
SHOW TABLES;
```

### Step 6: Check Table Structure

```sql
DESCRIBE employees;
```

### Step 7: Add Email Column

```sql
ALTER TABLE employees
ADD COLUMN email VARCHAR(150);
```

### Step 8: Add Phone Column

```sql
ALTER TABLE employees
ADD COLUMN phone VARCHAR(15);
```

### Step 9: Modify Name Column

```sql
ALTER TABLE employees
MODIFY COLUMN name VARCHAR(200);
```

### Step 10: Rename Phone Column

```sql
ALTER TABLE employees
RENAME COLUMN phone TO mobile_number;
```

### Step 11: Check Final Structure

```sql
DESCRIBE employees;
```

Expected structure:

| Column | Type |
|---|---|
| id | int |
| name | varchar(200) |
| age | int |
| salary | decimal(10,2) |
| email | varchar(150) |
| mobile_number | varchar(15) |

### Step 12: Rename Table

```sql
RENAME TABLE employees TO staff;
```

### Step 13: Verify

```sql
SHOW TABLES;
```

You should now see:

```text
staff
```

**Note:** We are only practicing database structure operations here. We'll learn how to insert actual employee records in Phase 5.

---

# 21. Important Interview Questions

Try answering these questions yourself.

1. What is a database?
2. How do you create a database in MySQL?
3. What is the difference between CREATE DATABASE and CREATE DATABASE IF NOT EXISTS?
4. How do you list all databases?
5. What is the purpose of the USE statement?
6. How do you find the currently selected database?
7. What happens when you execute DROP DATABASE?
8. What is a table?
9. How do you create a table?
10. What is the purpose of SHOW TABLES?
11. What is the difference between DESCRIBE and SHOW CREATE TABLE?
12. What is ALTER TABLE?
13. How do you add a new column?
14. What is the difference between MODIFY and CHANGE?
15. How do you rename a column?
16. How do you delete a column?
17. What is DROP TABLE?
18. What is TRUNCATE TABLE?
19. What is the difference between DROP, DELETE, and TRUNCATE?
20. What is the difference between IF EXISTS and IF NOT EXISTS?
21. Can you rename a table without losing its data?
22. Can you add multiple columns using one ALTER TABLE statement?
23. Does TRUNCATE remove the table structure?
24. Does DROP TABLE remove the table's data?
25. Can a database contain multiple tables?

---

# 22. Practical Assignments

Complete these exercises before moving to the next phase.

### Assignment 1: Database Creation

Create the following databases:

1. `school_db`
2. `hospital_db`
3. `ecommerce_db`
4. `expense_tracker`

Display all databases.

### Assignment 2: School Database

Inside `school_db`, create these tables:

**students**

| Column | Data Type |
|---|---|
| id | INT |
| name | VARCHAR(100) |
| age | INT |
| email | VARCHAR(150) |

**teachers**

| Column | Data Type |
|---|---|
| id | INT |
| name | VARCHAR(100) |
| subject | VARCHAR(100) |

**courses**

| Column | Data Type |
|---|---|
| id | INT |
| course_name | VARCHAR(100) |
| duration | INT |

### Assignment 3: ALTER TABLE

Perform these operations:

1. Add `mobile_number` to students.
2. Add `address` to students.
3. Modify `name` to VARCHAR(200).
4. Rename `mobile_number` to `phone`.
5. Add `created_at` to students.
6. Remove `address` from students.
7. Rename `teachers` to `school_teachers`.

### Assignment 4: DROP and TRUNCATE

Create a temporary table called `test_table`.

Perform:

1. DROP TABLE.
2. Recreate the table.
3. TRUNCATE TABLE.
4. DROP TABLE IF EXISTS.

### Assignment 5: Conceptual Questions

1. Can we create two tables with the same name inside one database?
2. Can two different databases contain tables with identical names?
3. Can we add a column to an existing table?
4. Can we change a column's data type?
5. Can we rename a table without losing records?
6. Does TRUNCATE delete a database?
7. Does DROP TABLE delete the entire database?
8. Can we execute CREATE TABLE without selecting a database?
9. What happens if we execute USE on a database that doesn't exist?
10. What happens if we execute CREATE TABLE IF NOT EXISTS on an existing table with a different structure?

---

# 23. Phase 3 Revision Sheet

| Command | Purpose |
|---|---|
| CREATE DATABASE | Creates a database |
| SHOW DATABASES | Lists databases |
| USE | Selects a database |
| SELECT DATABASE() | Returns current database |
| DROP DATABASE | Deletes a database |
| CREATE TABLE | Creates a table |
| SHOW TABLES | Lists tables |
| DESCRIBE | Displays table structure |
| SHOW CREATE TABLE | Displays table creation SQL |
| ALTER TABLE | Modifies table structure |
| ADD COLUMN | Adds a column |
| MODIFY COLUMN | Modifies a column definition |
| CHANGE COLUMN | Renames and modifies a column |
| RENAME COLUMN | Renames a column |
| DROP COLUMN | Removes a column |
| DROP TABLE | Deletes a table |
| TRUNCATE TABLE | Removes all records |
| RENAME TABLE | Renames a table |

---

## Phase 3 – Completion Checklist

| No. | Topic | Status |
|---|---|---|
| 1 | CREATE DATABASE | Covered |
| 2 | SHOW DATABASES | Covered |
| 3 | IF NOT EXISTS | Covered |
| 4 | USE DATABASE | Covered |
| 5 | SELECT DATABASE() | Covered |
| 6 | DROP DATABASE | Covered |
| 7 | CREATE TABLE | Covered |
| 8 | SHOW TABLES | Covered |
| 9 | DESCRIBE | Covered |
| 10 | SHOW CREATE TABLE | Covered |
| 11 | ALTER TABLE | Covered |
| 12 | ADD COLUMN | Covered |
| 13 | MODIFY COLUMN | Covered |
| 14 | CHANGE COLUMN | Covered |
| 15 | RENAME COLUMN | Covered |
| 16 | DROP COLUMN | Covered |
| 17 | DROP TABLE | Covered |
| 18 | TRUNCATE TABLE | Covered |
| 19 | RENAME TABLE | Covered |
| 20 | IF EXISTS | Covered |

**Phase 3 is complete from a theory perspective.**

### Next: Phase 4 – SQL Data Types

We'll cover:

- Numeric Data Types
- INT, BIGINT, SMALLINT, TINYINT
- DECIMAL, FLOAT, DOUBLE
- CHAR vs VARCHAR
- TEXT and LONGTEXT
- DATE, TIME, DATETIME, TIMESTAMP
- BOOLEAN
- BINARY and BLOB
- ENUM and SET
- Signed vs Unsigned
- Storage requirements
- Choosing the correct data type
- Practical examples and interview questions

**Important:** Phase 4 is particularly useful for backend developers because choosing the correct database data type affects storage, data integrity, and application behavior.

Tell me **"Next Phase"** when you're ready.