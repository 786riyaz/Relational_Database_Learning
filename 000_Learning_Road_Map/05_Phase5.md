# SQL Complete Course – Phase 5
# CRUD Operations (Create, Read, Update, Delete)

**Level:** Beginner  
**Phase:** 5 of 25  
**Database:** MySQL 8.0+  
**Goal:** Learn how to insert, retrieve, update, and delete records from database tables.

This is one of the most important phases in SQL because almost every backend application performs CRUD operations.

For example, consider an Expense Tracker application:

| User Action | Database Operation |
|---|---|
| Add a new expense | INSERT |
| View all expenses | SELECT |
| Edit an expense | UPDATE |
| Delete an expense | DELETE |

Let's understand each operation in detail.

---

# 1. What is CRUD?

CRUD stands for:

- **C – Create**
- **R – Read**
- **U – Update**
- **D – Delete**

CRUD represents the four fundamental operations used to manage data in a database.

### 1. CREATE

Used to insert new records into a table.

SQL command:

```sql
INSERT
```

Example:

```sql
INSERT INTO students (id, name, age)
VALUES (1, 'Riyaz', 25);
```

### 2. READ

Used to retrieve existing records.

SQL command:

```sql
SELECT
```

Example:

```sql
SELECT * FROM students;
```

### 3. UPDATE

Used to modify existing records.

SQL command:

```sql
UPDATE
```

Example:

```sql
UPDATE students
SET age = 26
WHERE id = 1;
```

### 4. DELETE

Used to remove existing records.

SQL command:

```sql
DELETE
```

Example:

```sql
DELETE FROM students
WHERE id = 1;
```

### CRUD Summary

| Operation | SQL Command | Purpose |
|---|---|---|
| Create | INSERT | Add records |
| Read | SELECT | Retrieve records |
| Update | UPDATE | Modify records |
| Delete | DELETE | Remove records |

**Important:** CRUD Create is different from SQL `CREATE TABLE`.

- CRUD Create means inserting a new record.
- `CREATE TABLE` means creating a database structure.

---

# 2. Preparing Our Practical Database

Throughout this phase, we'll work with a Student Management System.

First, create a database:

```sql
CREATE DATABASE IF NOT EXISTS school_db;
```

Select the database:

```sql
USE school_db;
```

Create a students table:

```sql
CREATE TABLE IF NOT EXISTS students (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    age TINYINT UNSIGNED,
    city VARCHAR(100),
    fees DECIMAL(10,2),
    admission_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);
```

We'll study `AUTO_INCREMENT`, `PRIMARY KEY`, `NOT NULL`, and other constraints in Phase 7.

For now, understand that this table will store student information.

---

# 3. INSERT INTO – Inserting Records

The `INSERT INTO` statement is used to insert new records into a table.

There are multiple ways to insert records.

## 3.1 Insert a Single Record

### Syntax

```sql
INSERT INTO table_name (column1, column2, column3)
VALUES (value1, value2, value3);
```

### Example

```sql
INSERT INTO students (
    name,
    email,
    age,
    city,
    fees,
    admission_date
)
VALUES (
    'Riyaz',
    'riyaz@example.com',
    25,
    'Ahmedabad',
    25000.00,
    '2026-11-25'
);
```

This inserts one student into the students table.

### Important

Notice that we didn't provide the `id` or `is_active` values.

Why?

- `id` is AUTO_INCREMENT, so MySQL generates it automatically.
- `is_active` has a default value of TRUE.

You don't need to provide values for columns that have suitable defaults or automatically generated values.

---

## 3.2 Insert Multiple Records

You can insert multiple records using one INSERT statement.

### Syntax

```sql
INSERT INTO table_name (column1, column2, column3)
VALUES
    (value1, value2, value3),
    (value4, value5, value6),
    (value7, value8, value9);
```

### Example

```sql
INSERT INTO students (
    name,
    email,
    age,
    city,
    fees,
    admission_date
)
VALUES
    (
        'Ahmed',
        'ahmed@example.com',
        26,
        'Surat',
        30000.00,
        '2026-11-20'
    ),
    (
        'Rahul',
        'rahul@example.com',
        24,
        'Vadodara',
        20000.00,
        '2026-11-21'
    ),
    (
        'Amit',
        'amit@example.com',
        23,
        'Ahmedabad',
        22000.00,
        '2026-11-22'
    );
```

This inserts three records using one query.

### Why Use Multiple INSERT?

Instead of executing:

```sql
INSERT INTO students (...) VALUES (...);

INSERT INTO students (...) VALUES (...);

INSERT INTO students (...) VALUES (...);
```

You can execute one statement containing multiple records.

This is generally more efficient for bulk insertion.

---

## 3.3 INSERT Without Specifying Column Names

You can insert records without specifying column names.

### Example

```sql
INSERT INTO students
VALUES (
    10,
    'John',
    'john@example.com',
    25,
    'Mumbai',
    25000.00,
    '2026-11-25',
    TRUE
);
```

However, this requires providing values for every column in the correct order.

### Why Is This Not Recommended?

Suppose someone changes the table structure by adding another column.

Your INSERT query may stop working or require modification.

**Best Practice:** Specify column names explicitly.

```sql
INSERT INTO students (
    name,
    email,
    age,
    city
)
VALUES (
    'John',
    'john@example.com',
    25,
    'Mumbai'
);
```

---

## 3.4 INSERT Only Specific Columns

You don't need to insert values into every column.

Example:

```sql
INSERT INTO students (
    name,
    email
)
VALUES (
    'Ali',
    'ali@example.com'
);
```

What happens to the remaining columns?

| Column | Value |
|---|---|
| id | Automatically generated |
| name | Ali |
| email | ali@example.com |
| age | NULL |
| city | NULL |
| fees | NULL |
| admission_date | NULL |
| is_active | TRUE |

This happens because the omitted columns allow NULL or have a default value.

---

## 3.5 INSERT Using DEFAULT

You can explicitly use the DEFAULT keyword to insert a column's default value.

Example:

```sql
INSERT INTO students (
    name,
    email,
    is_active
)
VALUES (
    'Sameer',
    'sameer@example.com',
    DEFAULT
);
```

Here, `is_active` receives its default value of TRUE.

---

# 4. SELECT – Retrieving Records

The `SELECT` statement is used to retrieve data from database tables.

It is one of the most frequently used SQL commands.

### Basic Syntax

```sql
SELECT column1, column2
FROM table_name;
```

### Example

```sql
SELECT name, email
FROM students;
```

This retrieves only the name and email columns.

Expected output (illustrative):

| name | email |
|---|---|
| Riyaz | riyaz@example.com |
| Ahmed | ahmed@example.com |
| Rahul | rahul@example.com |
| Amit | amit@example.com |

---

# 5. SELECT *

The `*` symbol is used to select all columns from a table.

### Example

```sql
SELECT *
FROM students;
```

This retrieves all columns and records from the students table.

### Difference

**Selecting Specific Columns:**

```sql
SELECT name, age
FROM students;
```

**Selecting All Columns:**

```sql
SELECT *
FROM students;
```

### Which Is Better?

For production applications, selecting only the required columns is generally better.

For example:

```sql
SELECT id, name, email
FROM students;
```

Instead of:

```sql
SELECT *
FROM students;
```

Benefits:

- Less unnecessary data transfer.
- Better query clarity.
- Reduced memory usage in applications.
- Less sensitivity to changes in table structure.

---

# 6. WHERE Clause

The `WHERE` clause is used to filter records based on specified conditions.

### Syntax

```sql
SELECT column_name
FROM table_name
WHERE condition;
```

### Example

```sql
SELECT *
FROM students
WHERE city = 'Ahmedabad';
```

This retrieves only students from Ahmedabad.

### Another Example

```sql
SELECT *
FROM students
WHERE age > 24;
```

This retrieves students whose age is greater than 24.

### WHERE with Multiple Conditions

```sql
SELECT *
FROM students
WHERE city = 'Ahmedabad'
AND age > 24;
```

This retrieves students who:

1. Live in Ahmedabad.
2. Are older than 24.

### WHERE with OR

```sql
SELECT *
FROM students
WHERE city = 'Ahmedabad'
OR city = 'Surat';
```

This retrieves students from either Ahmedabad or Surat.

We'll study all SQL operators in detail in Phase 6.

---

# 7. UPDATE – Updating Records

The `UPDATE` statement is used to modify existing records in a table.

### Syntax

```sql
UPDATE table_name
SET column_name = new_value
WHERE condition;
```

### Example

Suppose Riyaz's age changes from 25 to 26.

```sql
UPDATE students
SET age = 26
WHERE id = 1;
```

This updates only the student whose ID is 1.

### Updating Multiple Columns

You can update multiple columns in one statement.

```sql
UPDATE students
SET
    age = 27,
    city = 'Mumbai',
    fees = 35000.00
WHERE id = 1;
```

This updates three columns for the same student.

### Updating Multiple Records

Suppose you want to increase the fees of all students by 10%.

```sql
UPDATE students
SET fees = fees * 1.10;
```

This updates every row in the table.

### Updating Records with Conditions

```sql
UPDATE students
SET is_active = FALSE
WHERE age > 25;
```

This deactivates all students older than 25.

### Extremely Important: UPDATE Without WHERE

Consider:

```sql
UPDATE students
SET city = 'Ahmedabad';
```

This updates the city of every student.

It does not update just one student.

**Best Practice:** Always verify your WHERE condition before executing UPDATE queries.

---

# 8. DELETE – Deleting Records

The `DELETE` statement removes records from a table.

### Syntax

```sql
DELETE FROM table_name
WHERE condition;
```

### Example

Delete a student whose ID is 3:

```sql
DELETE FROM students
WHERE id = 3;
```

Only that student's record is deleted.

### Delete Multiple Records

```sql
DELETE FROM students
WHERE city = 'Surat';
```

This deletes all students from Surat.

### Delete All Records

```sql
DELETE FROM students;
```

This removes all records from the students table.

However, the table structure remains.

### DELETE vs TRUNCATE

| DELETE | TRUNCATE |
|---|---|
| DML operation | DDL operation |
| Supports WHERE | Does not support WHERE |
| Can delete selected rows | Removes all rows |
| Can be rolled back within a transaction for InnoDB | Causes an implicit commit |
| Normally does not reset AUTO_INCREMENT | Resets AUTO_INCREMENT |

---

# 9. DISTINCT – Removing Duplicate Results

The `DISTINCT` keyword is used to retrieve unique values.

Suppose the students table contains:

| id | name | city |
|---:|---|---|
| 1 | Riyaz | Ahmedabad |
| 2 | Ahmed | Surat |
| 3 | Rahul | Ahmedabad |
| 4 | Amit | Vadodara |
| 5 | Sameer | Surat |

Notice that Ahmedabad and Surat appear multiple times.

### Example

```sql
SELECT DISTINCT city
FROM students;
```

Expected output:

| city |
|---|
| Ahmedabad |
| Surat |
| Vadodara |

Duplicate city values are removed from the result.

### DISTINCT with Multiple Columns

```sql
SELECT DISTINCT city, age
FROM students;
```

Here, MySQL returns unique combinations of city and age.

Important:

DISTINCT applies to the complete combination of selected columns, not independently to each column.

### DISTINCT vs UNIQUE

| DISTINCT | UNIQUE Constraint |
|---|---|
| Used in SELECT queries | Used in table definitions |
| Removes duplicate result rows | Prevents duplicate stored values |
| Does not modify table data | Enforces data integrity |

We'll study UNIQUE constraints in Phase 7.

---

# 10. ORDER BY – Sorting Records

The `ORDER BY` clause is used to sort query results.

It supports two directions:

- ASC – Ascending
- DESC – Descending

### Syntax

```sql
SELECT *
FROM table_name
ORDER BY column_name;
```

### Example: Ascending Order

```sql
SELECT *
FROM students
ORDER BY age ASC;
```

This sorts students from youngest to oldest.

### Example: Descending Order

```sql
SELECT *
FROM students
ORDER BY age DESC;
```

This sorts students from oldest to youngest.

### Multiple Column Sorting

You can sort using multiple columns.

```sql
SELECT *
FROM students
ORDER BY city ASC, age DESC;
```

Execution meaning:

1. Sort by city alphabetically.
2. For students with the same city, sort by age from highest to lowest.

### ORDER BY with Aliases

```sql
SELECT
    name,
    fees AS total_fees
FROM students
ORDER BY total_fees DESC;
```

Here, `total_fees` is an alias used for sorting.

---

# 11. ASC vs DESC

| ASC | DESC |
|---|---|
| Ascending order | Descending order |
| Small to large | Large to small |
| A to Z | Z to A |
| Oldest to newest (for dates) | Newest to oldest (for dates) |
| Default ORDER BY direction | Must be specified explicitly |

### Important

If you don't specify ASC or DESC, MySQL uses ascending order by default.

These queries are equivalent:

```sql
SELECT * FROM students
ORDER BY age;
```

```sql
SELECT * FROM students
ORDER BY age ASC;
```

---

# 12. LIMIT – Limiting the Number of Records

The `LIMIT` clause restricts the number of rows returned.

### Syntax

```sql
SELECT *
FROM table_name
LIMIT number;
```

### Example

```sql
SELECT *
FROM students
LIMIT 5;
```

This returns at most five records.

### Real-world Usage

Suppose your application has 10 lakh students.

You don't want to retrieve all records on the first page.

Instead:

```sql
SELECT *
FROM students
LIMIT 10;
```

This retrieves at most 10 records.

### LIMIT with ORDER BY

Suppose you want the five students with the highest fees.

```sql
SELECT *
FROM students
ORDER BY fees DESC
LIMIT 5;
```

This is a common SQL query pattern.

---

# 13. OFFSET – Skipping Records

`OFFSET` is used to skip a specified number of records before returning results.

### Syntax

```sql
SELECT *
FROM table_name
LIMIT number OFFSET number;
```

### Example

```sql
SELECT *
FROM students
LIMIT 5 OFFSET 10;
```

Meaning:

- Skip the first 10 records.
- Return the next 5 records.

### Practical Example: Pagination

Suppose your application displays 10 students per page.

| Page | LIMIT | OFFSET |
|---|---:|---:|
| Page 1 | 10 | 0 |
| Page 2 | 10 | 10 |
| Page 3 | 10 | 20 |
| Page 4 | 10 | 30 |
| Page 5 | 10 | 40 |

### Pagination Formula

```text
OFFSET = (Page Number - 1) × Page Size
```

Example:

Page number = 3

Page size = 10

```text
OFFSET = (3 - 1) × 10
OFFSET = 20
```

Query:

```sql
SELECT *
FROM students
ORDER BY id
LIMIT 10 OFFSET 20;
```

### Alternative LIMIT Syntax

MySQL also supports:

```sql
SELECT *
FROM students
LIMIT 10, 20;
```

This means:

- Skip 10 rows.
- Return 20 rows.

Be careful: In this syntax, the first number is OFFSET and the second number is LIMIT.

### Important Performance Consideration

Large OFFSET values can become inefficient because MySQL may need to scan and discard many rows.

For large datasets, keyset pagination is often preferable.

We'll discuss advanced optimization later.

---

# 14. SQL Aliases – AS

An alias is a temporary name assigned to a column or table within a query.

The `AS` keyword is commonly used to create aliases.

### A. Column Alias

Syntax:

```sql
SELECT column_name AS alias_name
FROM table_name;
```

Example:

```sql
SELECT
    name AS student_name,
    city AS student_city
FROM students;
```

Output:

| student_name | student_city |
|---|---|
| Riyaz | Ahmedabad |
| Ahmed | Surat |
| Rahul | Ahmedabad |

The original table column names are not changed.

Only the query result headings are changed.

### B. Table Alias

You can also assign aliases to tables.

Example:

```sql
SELECT s.name, s.email
FROM students AS s;
```

Here:

- `students` is the original table.
- `s` is its alias.

You can omit AS:

```sql
SELECT s.name, s.email
FROM students s;
```

Both are valid.

### Why Do We Need Table Aliases?

Aliases make queries shorter and more readable, especially when working with multiple tables.

For example:

```sql
SELECT
    s.name,
    s.email
FROM students AS s;
```

We'll use table aliases extensively when learning JOINs in Phase 10.

---

# 15. Complete SQL Logical Query Processing Order

This is an important advanced concept.

Consider:

```sql
SELECT
    city,
    COUNT(*) AS total_students
FROM students
WHERE age > 18
GROUP BY city
HAVING COUNT(*) > 2
ORDER BY total_students DESC
LIMIT 5;
```

You might assume SQL executes each clause from top to bottom.

However, SQL uses a logical query processing order.

A simplified order is:

| Order | Clause | Purpose |
|---:|---|---|
| 1 | FROM | Identify source tables |
| 2 | WHERE | Filter individual rows |
| 3 | GROUP BY | Group rows |
| 4 | HAVING | Filter groups |
| 5 | SELECT | Determine output expressions |
| 6 | DISTINCT | Remove duplicate result rows |
| 7 | ORDER BY | Sort results |
| 8 | LIMIT | Restrict returned rows |

**Important:** This is the logical processing order, not necessarily the physical execution order chosen by MySQL's optimizer.

We'll explore GROUP BY and HAVING in Phase 9.

---

# 16. NULL vs Empty String vs Zero

This is a very important concept in SQL.

These three values are different.

### NULL

NULL represents missing or unknown data.

Example:

```sql
INSERT INTO students (name, email)
VALUES ('Riyaz', NULL);
```

Here, the email is unknown or missing.

### Empty String

An empty string is a valid string containing zero characters.

Example:

```sql
INSERT INTO students (name, email)
VALUES ('Ahmed', '');
```

Here, the email contains an empty string.

### Zero

Zero is a numeric value.

Example:

```sql
INSERT INTO students (name, age)
VALUES ('Rahul', 0);
```

Here, the age value is zero.

### Comparison

| Value | Meaning |
|---|---|
| NULL | Missing or unknown |
| '' | Empty string |
| 0 | Numeric zero |

### Important: Checking NULL

Incorrect:

```sql
SELECT *
FROM students
WHERE email = NULL;
```

Correct:

```sql
SELECT *
FROM students
WHERE email IS NULL;
```

To find records where email is not NULL:

```sql
SELECT *
FROM students
WHERE email IS NOT NULL;
```

We'll study NULL handling more deeply in later phases.

---

# 17. Real-world Example: Expense Tracker CRUD

Let's understand how CRUD works in an actual backend application.

Suppose we're developing an Expense Tracker.

Create a table:

```sql
CREATE TABLE expenses (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    category VARCHAR(100),
    expense_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### CREATE – Add Expense

```sql
INSERT INTO expenses (
    title,
    amount,
    category,
    expense_date
)
VALUES (
    'Electricity Bill',
    1500.00,
    'Utilities',
    '2026-11-25'
);
```

### READ – View Expenses

```sql
SELECT *
FROM expenses;
```

### READ – Filter Expenses

```sql
SELECT *
FROM expenses
WHERE category = 'Utilities';
```

### UPDATE – Modify Expense

```sql
UPDATE expenses
SET amount = 1800.00
WHERE id = 1;
```

### DELETE – Remove Expense

```sql
DELETE FROM expenses
WHERE id = 1;
```

These are the basic database operations performed by a typical backend application.

---

# 18. Common SQL Mistakes

### Mistake 1: Forgetting WHERE in UPDATE

Dangerous:

```sql
UPDATE students
SET age = 30;
```

This updates every student.

### Mistake 2: Forgetting WHERE in DELETE

Dangerous:

```sql
DELETE FROM students;
```

This deletes every record.

### Mistake 3: Using = NULL

Incorrect:

```sql
WHERE email = NULL;
```

Correct:

```sql
WHERE email IS NULL;
```

### Mistake 4: Forgetting String Quotes

Incorrect:

```sql
SELECT *
FROM students
WHERE city = Ahmedabad;
```

Correct:

```sql
SELECT *
FROM students
WHERE city = 'Ahmedabad';
```

### Mistake 5: Using SELECT * Everywhere

Avoid retrieving unnecessary columns in production applications.

### Mistake 6: Using LIMIT Without ORDER BY for Pagination

This query:

```sql
SELECT *
FROM students
LIMIT 10 OFFSET 20;
```

doesn't guarantee a consistent ordering.

Better:

```sql
SELECT *
FROM students
ORDER BY id
LIMIT 10 OFFSET 20;
```

---

# 19. Important SQL Interview Questions

## Beginner Level

1. What is CRUD?
2. What is the difference between INSERT and CREATE TABLE?
3. What is the purpose of INSERT INTO?
4. How do you insert multiple records?
5. Can we insert records without specifying column names?
6. What is SELECT?
7. What is the difference between SELECT * and SELECT specific columns?
8. What is the purpose of WHERE?
9. What is UPDATE?
10. What happens when UPDATE is executed without WHERE?

## Intermediate Level

11. What is DELETE?
12. What is the difference between DELETE and TRUNCATE?
13. What is DISTINCT?
14. What is the difference between DISTINCT and UNIQUE?
15. What is ORDER BY?
16. What is the difference between ASC and DESC?
17. What is LIMIT?
18. What is OFFSET?
19. What is SQL pagination?
20. What is the difference between LIMIT and OFFSET?

## Advanced Level

21. What is an SQL alias?
22. What is the difference between column aliases and table aliases?
23. Can we use aliases in ORDER BY?
24. What is the logical SQL query processing order?
25. What is the difference between NULL, empty string, and zero?
26. Why can't we use `= NULL`?
27. Why should we use ORDER BY with LIMIT?
28. What is keyset pagination?
29. Can UPDATE modify multiple columns?
30. Can DELETE remove multiple records in one query?

---

# 20. Practical Assignments

Now it's time to practice.

Use the `school_db` database and `students` table.

## Assignment 1: Insert Records

Insert at least 15 students with different:

- Names
- Email addresses
- Ages
- Cities
- Fees
- Admission dates

Include students from:

- Ahmedabad
- Surat
- Vadodara
- Mumbai
- Delhi

## Assignment 2: SELECT Queries

Write SQL queries to:

1. Retrieve all students.
2. Retrieve only student names.
3. Retrieve names and emails.
4. Retrieve students from Ahmedabad.
5. Retrieve students older than 20.
6. Retrieve students with fees greater than 20,000.
7. Retrieve students from Surat.
8. Retrieve students whose age is exactly 25.
9. Retrieve students whose city is Ahmedabad and age is greater than 20.
10. Retrieve only the first five students.

## Assignment 3: UPDATE Queries

Write SQL queries to:

1. Update one student's name.
2. Update one student's email.
3. Change one student's city.
4. Increase one student's fees.
5. Update multiple columns simultaneously.
6. Deactivate all students older than 25.
7. Increase the fees of all students by 10%.

## Assignment 4: DELETE Queries

Write SQL queries to:

1. Delete a student using ID.
2. Delete all students from Mumbai.
3. Delete students whose fees are below 10,000.
4. Delete students whose age is below 18.

**Practice these queries carefully. Always verify the affected records before running DELETE.**

## Assignment 5: DISTINCT and ORDER BY

Write queries to:

1. Find all unique cities.
2. Find all unique ages.
3. Sort students by name alphabetically.
4. Sort students by fees from highest to lowest.
5. Sort students by age from lowest to highest.
6. Sort by city and then by age.
7. Find the five students paying the highest fees.
8. Find the three youngest students.

## Assignment 6: Pagination

Assume each page displays five students.

Write queries for:

1. Page 1.
2. Page 2.
3. Page 3.
4. Page 4.

Use LIMIT and OFFSET.

---

# 21. Phase 5 Quick Revision Sheet

| Command | Purpose | Example |
|---|---|---|
| INSERT INTO | Insert records | `INSERT INTO students ...` |
| SELECT | Retrieve records | `SELECT * FROM students;` |
| WHERE | Filter records | `WHERE age > 20` |
| UPDATE | Modify records | `UPDATE students SET age = 25` |
| DELETE | Remove records | `DELETE FROM students WHERE id = 1` |
| DISTINCT | Retrieve unique results | `SELECT DISTINCT city` |
| ORDER BY | Sort records | `ORDER BY age DESC` |
| ASC | Ascending sorting | `ORDER BY age ASC` |
| DESC | Descending sorting | `ORDER BY age DESC` |
| LIMIT | Restrict result count | `LIMIT 10` |
| OFFSET | Skip records | `LIMIT 10 OFFSET 20` |
| AS | Assign aliases | `name AS student_name` |
| IS NULL | Find NULL values | `WHERE email IS NULL` |
| IS NOT NULL | Find non-NULL values | `WHERE email IS NOT NULL` |

---

# 22. Phase 5 Completion Checklist

| No. | Topic | Status |
|---|---|---|
| 1 | CRUD Introduction | Covered |
| 2 | INSERT INTO | Covered |
| 3 | Single Record Insertion | Covered |
| 4 | Multiple Record Insertion | Covered |
| 5 | INSERT Without Column Names | Covered |
| 6 | INSERT Specific Columns | Covered |
| 7 | INSERT DEFAULT | Covered |
| 8 | SELECT | Covered |
| 9 | SELECT * | Covered |
| 10 | WHERE | Covered |
| 11 | UPDATE | Covered |
| 12 | UPDATE Multiple Columns | Covered |
| 13 | DELETE | Covered |
| 14 | DISTINCT | Covered |
| 15 | ORDER BY | Covered |
| 16 | ASC and DESC | Covered |
| 17 | LIMIT | Covered |
| 18 | OFFSET | Covered |
| 19 | Pagination | Covered |
| 20 | SQL Aliases | Covered |
| 21 | Logical Query Processing Order | Covered |
| 22 | NULL vs Empty String vs Zero | Covered |
| 23 | Common SQL Mistakes | Covered |

---

# What's Next?

## Phase 6 – SQL Operators

This phase is extremely important because operators allow you to filter and manipulate data based on conditions.

We'll cover:

**Arithmetic Operators**
- Addition (+)
- Subtraction (-)
- Multiplication (*)
- Division (/)
- Modulo (%)

**Comparison Operators**
- Equal to (=)
- Not Equal to (!=, <>)
- Greater than (>)
- Less than (<)
- Greater than or equal to (>=)
- Less than or equal to (<=)

**Logical Operators**
- AND
- OR
- NOT

**Special Operators**
- BETWEEN
- IN
- NOT IN
- LIKE
- NOT LIKE
- IS NULL
- IS NOT NULL
- REGEXP

**Additional Concepts**
- Operator Precedence
- Combining Multiple Conditions
- Practical Filtering Problems

**My recommendation:** Complete the practical assignments from Phase 5 before moving ahead. CRUD operations are foundational for almost every backend developer.

Tell me **"Next Phase"** when you're ready.