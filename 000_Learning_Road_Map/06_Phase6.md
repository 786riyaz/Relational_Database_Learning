# SQL Complete Course – Phase 6
# SQL Operators

**Level:** Beginner to Intermediate  
**Phase:** 6 of 25  
**Database:** MySQL 8.0+  
**Goal:** Understand SQL operators and learn how to filter, compare, calculate, and manipulate data using different conditions.

Operators are fundamental to SQL because they allow us to write conditions and perform calculations.

For example, suppose you have an Employee Management System.

You might want to:

- Find employees whose salary is greater than ₹50,000.
- Find employees whose age is between 20 and 30.
- Find employees from Ahmedabad or Surat.
- Find employees whose names start with 'R'.
- Find employees whose email is NULL.
- Calculate the annual salary of employees.

All these operations use SQL operators.

---

# 1. What are SQL Operators?

SQL operators are symbols or keywords used to perform operations on database values.

They are commonly used in:

- SELECT statements.
- WHERE conditions.
- UPDATE statements.
- DELETE statements.
- JOIN conditions.
- HAVING conditions.

### Example

```sql
SELECT *
FROM employees
WHERE salary > 50000;
```

Here:

- `salary` is a column.
- `>` is a comparison operator.
- `50000` is a value.

The condition checks whether an employee's salary is greater than 50,000.

### Types of SQL Operators

| Category | Purpose |
|---|---|
| Arithmetic Operators | Perform mathematical calculations |
| Comparison Operators | Compare two values |
| Logical Operators | Combine multiple conditions |
| Special Operators | Perform specific filtering operations |
| Bitwise Operators | Perform bit-level operations |

Let's understand each category.

---

# 2. Arithmetic Operators

Arithmetic operators are used to perform mathematical calculations.

MySQL supports the following arithmetic operators:

| Operator | Name | Example | Result |
|---|---|---|---:|
| + | Addition | 10 + 5 | 15 |
| - | Subtraction | 10 - 5 | 5 |
| * | Multiplication | 10 * 5 | 50 |
| / | Division | 10 / 5 | 2 |
| % | Modulo | 10 % 3 | 1 |
| DIV | Integer Division | 10 DIV 3 | 3 |

## 2.1 Addition (+)

Adds two values.

```sql
SELECT 10 + 20;
```

Output:

| 10 + 20 |
|---:|
| 30 |

Practical example:

```sql
SELECT
    name,
    salary,
    salary + 5000 AS updated_salary
FROM employees;
```

This calculates salary after adding 5000.

## 2.2 Subtraction (-)

Subtracts one value from another.

```sql
SELECT 100 - 40;
```

Output:

| 100 - 40 |
|---:|
| 60 |

Practical example:

```sql
SELECT
    product_name,
    price,
    price - 500 AS discounted_price
FROM products;
```

## 2.3 Multiplication (*)

Multiplies two values.

```sql
SELECT 10 * 5;
```

Output:

| 10 * 5 |
|---:|
| 50 |

Practical example:

```sql
SELECT
    product_name,
    price,
    quantity,
    price * quantity AS total_amount
FROM order_items;
```

This calculates the total amount for each order item.

## 2.4 Division (/)

Divides one value by another.

```sql
SELECT 100 / 5;
```

Output:

| 100 / 5 |
|---:|
| 20.0000 |

Practical example:

```sql
SELECT
    name,
    salary,
    salary / 12 AS monthly_salary
FROM employees;
```

## 2.5 Modulo (%)

Returns the remainder after division.

```sql
SELECT 10 % 3;
```

Output:

| 10 % 3 |
|---:|
| 1 |

Because:

```text
10 ÷ 3 = 3 remainder 1
```

Practical example:

Find employees whose IDs are even:

```sql
SELECT *
FROM employees
WHERE id % 2 = 0;
```

Find employees whose IDs are odd:

```sql
SELECT *
FROM employees
WHERE id % 2 != 0;
```

## 2.6 DIV Operator

`DIV` performs integer division.

```sql
SELECT 10 DIV 3;
```

Output:

| 10 DIV 3 |
|---:|
| 3 |

### / vs DIV vs %

| Operator | Operation | Example | Result |
|---|---|---|---:|
| / | Normal division | 10 / 3 | 3.3333 |
| DIV | Integer division | 10 DIV 3 | 3 |
| % | Remainder | 10 % 3 | 1 |

**Important:** Division by zero produces NULL and a warning in MySQL rather than a normal numeric result.

---

# 3. Comparison Operators

Comparison operators compare two values.

They are commonly used inside WHERE conditions.

MySQL supports these operators:

| Operator | Meaning |
|---|---|
| = | Equal to |
| != | Not equal to |
| <> | Not equal to |
| > | Greater than |
| < | Less than |
| >= | Greater than or equal to |
| <= | Less than or equal to |

Let's understand them.

## 3.1 Equal To (=)

Checks whether two values are equal.

Example:

```sql
SELECT *
FROM employees
WHERE city = 'Ahmedabad';
```

This retrieves employees whose city is Ahmedabad.

Another example:

```sql
SELECT *
FROM employees
WHERE salary = 50000;
```

This retrieves employees whose salary is exactly 50,000.

## 3.2 Not Equal To (!=)

Checks whether two values are different.

Example:

```sql
SELECT *
FROM employees
WHERE city != 'Ahmedabad';
```

This retrieves employees who are not from Ahmedabad.

## 3.3 Not Equal To (<>)

MySQL also supports `<>` as a not-equal operator.

```sql
SELECT *
FROM employees
WHERE city <> 'Ahmedabad';
```

This produces the same logical result as:

```sql
SELECT *
FROM employees
WHERE city != 'Ahmedabad';
```

Both are valid.

## 3.4 Greater Than (>)

Checks whether one value is greater than another.

```sql
SELECT *
FROM employees
WHERE salary > 50000;
```

This retrieves employees earning more than 50,000.

## 3.5 Less Than (<)

```sql
SELECT *
FROM employees
WHERE salary < 50000;
```

This retrieves employees earning less than 50,000.

## 3.6 Greater Than or Equal To (>=)

```sql
SELECT *
FROM employees
WHERE salary >= 50000;
```

This retrieves employees earning 50,000 or more.

## 3.7 Less Than or Equal To (<=)

```sql
SELECT *
FROM employees
WHERE salary <= 50000;
```

This retrieves employees earning 50,000 or less.

### Comparison Operators Quick Revision

| Condition | Meaning |
|---|---|
| age = 25 | Age is exactly 25 |
| age != 25 | Age is not 25 |
| age <> 25 | Age is not 25 |
| age > 25 | Age is greater than 25 |
| age < 25 | Age is less than 25 |
| age >= 25 | Age is 25 or greater |
| age <= 25 | Age is 25 or smaller |

---

# 4. Logical Operators

Logical operators are used to combine or modify multiple conditions.

MySQL supports:

- AND
- OR
- NOT

## 4.1 AND Operator

The AND operator returns TRUE only when all specified conditions are TRUE.

### Truth Table

| Condition A | Condition B | A AND B |
|---|---|---|
| TRUE | TRUE | TRUE |
| TRUE | FALSE | FALSE |
| FALSE | TRUE | FALSE |
| FALSE | FALSE | FALSE |

### Example

```sql
SELECT *
FROM employees
WHERE city = 'Ahmedabad'
AND salary > 50000;
```

This retrieves employees who:

1. Live in Ahmedabad.
2. Earn more than 50,000.

Both conditions must be satisfied.

### Multiple AND Conditions

```sql
SELECT *
FROM employees
WHERE city = 'Ahmedabad'
AND age > 25
AND salary > 50000;
```

All three conditions must be TRUE.

---

## 4.2 OR Operator

The OR operator returns TRUE when at least one condition is TRUE.

### Truth Table

| Condition A | Condition B | A OR B |
|---|---|---|
| TRUE | TRUE | TRUE |
| TRUE | FALSE | TRUE |
| FALSE | TRUE | TRUE |
| FALSE | FALSE | FALSE |

### Example

```sql
SELECT *
FROM employees
WHERE city = 'Ahmedabad'
OR city = 'Surat';
```

This retrieves employees from either Ahmedabad or Surat.

### Multiple OR Conditions

```sql
SELECT *
FROM employees
WHERE city = 'Ahmedabad'
OR city = 'Surat'
OR city = 'Vadodara';
```

This retrieves employees from any of the three cities.

---

## 4.3 NOT Operator

The NOT operator reverses a condition.

### Truth Table

| Condition | NOT Condition |
|---|---|
| TRUE | FALSE |
| FALSE | TRUE |

Example:

```sql
SELECT *
FROM employees
WHERE NOT city = 'Ahmedabad';
```

This retrieves employees whose city is not Ahmedabad.

Equivalent query:

```sql
SELECT *
FROM employees
WHERE city != 'Ahmedabad';
```

Another example:

```sql
SELECT *
FROM employees
WHERE NOT salary > 50000;
```

This retrieves employees whose salary is not greater than 50,000, including those with salary equal to or below 50,000.

---

# 5. Combining AND, OR, and NOT

You can combine multiple logical operators in one SQL query.

Example:

```sql
SELECT *
FROM employees
WHERE city = 'Ahmedabad'
AND salary > 50000
OR age < 25;
```

This can be confusing because SQL follows operator precedence.

In MySQL:

```text
NOT
AND
OR
```

AND has higher precedence than OR.

Therefore, the query is interpreted as:

```sql
SELECT *
FROM employees
WHERE
    (city = 'Ahmedabad' AND salary > 50000)
    OR age < 25;
```

Meaning:

Retrieve employees who:

- Live in Ahmedabad and earn more than 50,000.

OR

- Are younger than 25.

### Best Practice: Use Parentheses

Instead of relying on precedence, write:

```sql
SELECT *
FROM employees
WHERE
    (city = 'Ahmedabad' AND salary > 50000)
    OR age < 25;
```

Parentheses make the query easier to understand.

---

# 6. BETWEEN Operator

The `BETWEEN` operator is used to filter values within a specified range.

### Syntax

```sql
SELECT *
FROM table_name
WHERE column_name BETWEEN value1 AND value2;
```

### Example

```sql
SELECT *
FROM employees
WHERE salary BETWEEN 30000 AND 60000;
```

This retrieves employees whose salaries are between 30,000 and 60,000.

**Important:** BETWEEN is inclusive.

That means:

```text
salary >= 30000
AND
salary <= 60000
```

Both boundary values are included.

### Equivalent Query

```sql
SELECT *
FROM employees
WHERE salary >= 30000
AND salary <= 60000;
```

Both queries are logically equivalent.

### BETWEEN with Dates

```sql
SELECT *
FROM employees
WHERE joining_date
BETWEEN '2025-01-01' AND '2025-12-31';
```

This retrieves employees who joined during 2025.

### NOT BETWEEN

You can also use `NOT BETWEEN`.

```sql
SELECT *
FROM employees
WHERE salary NOT BETWEEN 30000 AND 60000;
```

This retrieves employees whose salaries are below 30,000 or above 60,000.

### Important: BETWEEN with DATETIME

Suppose `created_at` is DATETIME.

This query:

```sql
WHERE created_at BETWEEN
    '2026-11-01'
    AND '2026-11-30'
```

does not include most records from November 30 because the upper boundary represents midnight at the start of that date.

A safer approach is:

```sql
SELECT *
FROM orders
WHERE created_at >= '2026-11-01'
AND created_at < '2026-12-01';
```

This includes the entire month of November.

---

# 7. IN Operator

The `IN` operator checks whether a value matches any value in a specified list.

### Syntax

```sql
SELECT *
FROM table_name
WHERE column_name IN (value1, value2, value3);
```

### Example

```sql
SELECT *
FROM employees
WHERE city IN ('Ahmedabad', 'Surat', 'Vadodara');
```

This retrieves employees from any of these three cities.

### Equivalent Query Using OR

```sql
SELECT *
FROM employees
WHERE city = 'Ahmedabad'
OR city = 'Surat'
OR city = 'Vadodara';
```

Both queries produce the same logical result.

### Why Use IN?

It makes queries shorter and more readable when checking multiple possible values.

### IN with Numbers

```sql
SELECT *
FROM employees
WHERE age IN (22, 25, 30);
```

### IN with Subqueries

You can also use a subquery inside IN.

Example:

```sql
SELECT *
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE department_name = 'IT'
);
```

This retrieves employees belonging to the IT department.

We'll study subqueries in Phase 11.

---

# 8. NOT IN Operator

`NOT IN` retrieves records whose values do not match any value in the specified list.

### Example

```sql
SELECT *
FROM employees
WHERE city NOT IN ('Ahmedabad', 'Surat');
```

This retrieves employees who are not from Ahmedabad or Surat.

### Equivalent Query Using AND

```sql
SELECT *
FROM employees
WHERE city != 'Ahmedabad'
AND city != 'Surat';
```

### Important: NOT IN and NULL

NULL can produce unexpected results with NOT IN.

Example:

```sql
SELECT *
FROM employees
WHERE department_id NOT IN (1, 2, NULL);
```

This returns no matching rows because the comparisons involving NULL evaluate to UNKNOWN.

If you want to exclude NULL values explicitly:

```sql
SELECT *
FROM employees
WHERE department_id IS NOT NULL
AND department_id NOT IN (1, 2);
```

This is a very important SQL concept.

---

# 9. LIKE Operator

The `LIKE` operator is used for pattern matching.

It is commonly used to search for text values.

MySQL supports two primary wildcard characters:

| Wildcard | Meaning |
|---|---|
| % | Matches zero or more characters |
| _ | Matches exactly one character |

Let's understand both.

## 9.1 Percentage (%) Wildcard

`%` matches zero or more characters.

### A. Names Starting With R

```sql
SELECT *
FROM employees
WHERE name LIKE 'R%';
```

Matches:

```text
Riyaz
Rahul
Rohan
```

It finds names starting with R.

### B. Names Ending With N

```sql
SELECT *
FROM employees
WHERE name LIKE '%n';
```

Matches names ending with N.

### C. Names Containing A

```sql
SELECT *
FROM employees
WHERE name LIKE '%a%';
```

Matches names containing the letter A.

### D. Names Starting With RI

```sql
SELECT *
FROM employees
WHERE name LIKE 'Ri%';
```

Matches names starting with RI.

### E. Names Ending With AZ

```sql
SELECT *
FROM employees
WHERE name LIKE '%az';
```

Matches names ending with AZ.

---

## 9.2 Underscore (_) Wildcard

`_` matches exactly one character.

Example:

```sql
SELECT *
FROM employees
WHERE name LIKE '_iyaz';
```

This can match:

```text
Riyaz
```

Because `_` represents the first character.

### Another Example

```sql
SELECT *
FROM employees
WHERE name LIKE 'R____';
```

This matches names that:

- Start with R.
- Contain exactly four additional characters.

For example:

```text
Riyaz
Rahul
```

Both contain five characters.

### Multiple Underscores

```sql
SELECT *
FROM employees
WHERE name LIKE '__y%';
```

Meaning:

- First character: Anything.
- Second character: Anything.
- Third character: y.
- Remaining characters: Anything.

---

# 10. LIKE Pattern Summary

| Pattern | Meaning | Example |
|---|---|---|
| 'R%' | Starts with R | Riyaz |
| '%R' | Ends with R | Amir |
| '%R%' | Contains R | Riyaz |
| 'Ri%' | Starts with Ri | Riyaz |
| '%az' | Ends with az | Riyaz |
| '_a%' | Second character is a | Rahul |
| 'R____' | Exactly five characters starting with R | Riyaz |
| '%an%' | Contains an | Danish |

### Practical Examples

Find employees whose names start with A:

```sql
SELECT *
FROM employees
WHERE name LIKE 'A%';
```

Find employees whose emails end with gmail.com:

```sql
SELECT *
FROM employees
WHERE email LIKE '%@gmail.com';
```

Find products containing the word laptop:

```sql
SELECT *
FROM products
WHERE product_name LIKE '%laptop%';
```

**Note:** Case sensitivity of LIKE depends on the column collation. MySQL's common default collations are case-insensitive.

---

# 11. NOT LIKE Operator

`NOT LIKE` retrieves records that do not match a specified pattern.

### Example

```sql
SELECT *
FROM employees
WHERE name NOT LIKE 'R%';
```

This retrieves employees whose names do not start with R.

Another example:

```sql
SELECT *
FROM employees
WHERE email NOT LIKE '%@gmail.com';
```

This retrieves employees whose email addresses do not end with `@gmail.com`.

**Important:** Rows with NULL email values are not returned because the comparison evaluates to UNKNOWN.

---

# 12. IS NULL Operator

NULL represents missing or unknown information.

You cannot check NULL using the normal equality operator.

Incorrect:

```sql
SELECT *
FROM employees
WHERE email = NULL;
```

Correct:

```sql
SELECT *
FROM employees
WHERE email IS NULL;
```

This retrieves employees whose email column contains NULL.

### Example

Suppose the table contains:

| id | name | email |
|---:|---|---|
| 1 | Riyaz | riyaz@gmail.com |
| 2 | Ahmed | NULL |
| 3 | Rahul | rahul@gmail.com |
| 4 | Amit | NULL |

Query:

```sql
SELECT *
FROM employees
WHERE email IS NULL;
```

Output:

| id | name | email |
|---:|---|---|
| 2 | Ahmed | NULL |
| 4 | Amit | NULL |

---

# 13. IS NOT NULL Operator

Used to retrieve records where a column contains a non-NULL value.

Example:

```sql
SELECT *
FROM employees
WHERE email IS NOT NULL;
```

Output:

| id | name | email |
|---:|---|---|
| 1 | Riyaz | riyaz@gmail.com |
| 3 | Rahul | rahul@gmail.com |

### IS NULL vs IS NOT NULL

| Operator | Purpose |
|---|---|
| IS NULL | Finds missing/unknown values |
| IS NOT NULL | Finds values that are not NULL |

### Important

These operators check for NULL specifically.

They do not check for:

- Empty strings.
- Zero.
- Spaces.

For example:

```sql
WHERE email = '';
```

Checks for an empty string, not NULL.

---

# 14. REGEXP / REGEXP_LIKE

MySQL supports regular expressions for advanced pattern matching.

`REGEXP` is also known as `RLIKE`.

It is more powerful than LIKE.

### Example 1: Names Starting With A

```sql
SELECT *
FROM employees
WHERE name REGEXP '^A';
```

`^` means the beginning of the string.

### Example 2: Names Ending With N

```sql
SELECT *
FROM employees
WHERE name REGEXP 'n$';
```

`$` means the end of the string.

### Example 3: Names Containing A or E

```sql
SELECT *
FROM employees
WHERE name REGEXP '[ae]';
```

Matches names containing either A or E.

### Example 4: Names Starting With A or R

```sql
SELECT *
FROM employees
WHERE name REGEXP '^[AR]';
```

### Example 5: Names Containing Only Letters

```sql
SELECT *
FROM employees
WHERE name REGEXP '^[A-Za-z]+$';
```

This matches names containing only English letters.

### Example 6: Emails Ending With Gmail or Yahoo

```sql
SELECT *
FROM employees
WHERE email REGEXP '@(gmail|yahoo)\\.com$';
```

This matches email addresses ending in:

```text
@gmail.com
@yahoo.com
```

### Common REGEXP Symbols

| Symbol | Meaning |
|---|---|
| ^ | Beginning of string |
| $ | End of string |
| . | Any single character |
| * | Zero or more repetitions |
| + | One or more repetitions |
| ? | Zero or one repetition |
| [] | Character set |
| [^] | Negated character set |
| \| | OR alternative |
| {n} | Exactly n repetitions |
| {n,m} | Between n and m repetitions |
| () | Grouping |

### LIKE vs REGEXP

| LIKE | REGEXP |
|---|---|
| Simple pattern matching | Advanced pattern matching |
| Uses % and _ | Uses regular expression syntax |
| Easier to read | More flexible |
| Suitable for basic searches | Suitable for complex patterns |

---

# 15. BETWEEN vs IN vs LIKE

These three operators are frequently used in SQL filtering.

| Operator | Purpose | Example |
|---|---|---|
| BETWEEN | Match a range | `age BETWEEN 20 AND 30` |
| IN | Match specific values | `city IN ('Ahmedabad','Surat')` |
| LIKE | Match a text pattern | `name LIKE 'R%'` |

### Example: BETWEEN

```sql
SELECT *
FROM employees
WHERE salary BETWEEN 30000 AND 50000;
```

### Example: IN

```sql
SELECT *
FROM employees
WHERE city IN ('Ahmedabad', 'Surat');
```

### Example: LIKE

```sql
SELECT *
FROM employees
WHERE name LIKE 'R%';
```

Remember:

- BETWEEN checks ranges.
- IN checks a list of values.
- LIKE checks text patterns.

---

# 16. Operator Precedence

Operator precedence determines the order in which SQL operators are evaluated.

For example:

```sql
SELECT *
FROM employees
WHERE city = 'Ahmedabad'
OR city = 'Surat'
AND salary > 50000;
```

MySQL evaluates AND before OR.

Therefore, this is equivalent to:

```sql
SELECT *
FROM employees
WHERE
    city = 'Ahmedabad'
    OR (city = 'Surat' AND salary > 50000);
```

It does NOT mean:

```sql
WHERE
    (city = 'Ahmedabad' OR city = 'Surat')
    AND salary > 50000;
```

### Simplified Operator Precedence

| Priority | Operator |
|---|---|
| Higher | Parentheses |
| | Unary operators |
| | Multiplication, division, modulo |
| | Addition, subtraction |
| | Comparison operators |
| | NOT |
| | AND |
| Lower | OR |

This is a simplified overview; MySQL has a more detailed precedence table.

### Best Practice

Always use parentheses when combining multiple AND and OR conditions.

It makes queries predictable and easier to maintain.

---

# 17. Bitwise Operators (Introduction)

Bitwise operators work on the individual bits of integer values.

MySQL supports:

| Operator | Meaning |
|---|---|
| & | Bitwise AND |
| \| | Bitwise OR |
| ^ | Bitwise XOR |
| ~ | Bitwise NOT |
| << | Left Shift |
| >> | Right Shift |

### Example: Bitwise AND

```sql
SELECT 5 & 3;
```

Binary representation:

```text
5 = 0101
3 = 0011
---------
    0001
```

Result:

```text
1
```

### Example: Bitwise OR

```sql
SELECT 5 | 3;
```

```text
5 = 0101
3 = 0011
---------
    0111
```

Result:

```text
7
```

### Example: Bitwise XOR

```sql
SELECT 5 ^ 3;
```

Result:

```text
6
```

### Example: Left Shift

```sql
SELECT 5 << 1;
```

Result:

```text
10
```

### Real-world Usage

Bitwise operators can be used for:

- Permission flags.
- Feature flags.
- Compact status representation.
- Low-level data manipulation.

These are less commonly needed in everyday backend SQL queries, but they're useful to understand.

---

# 18. Practical Examples – Employee Management System

Let's combine everything.

Assume we have this employees table:

| id | name | age | city | salary | email |
|---:|---|---:|---|---:|---|
| 1 | Riyaz | 25 | Ahmedabad | 60000 | riyaz@gmail.com |
| 2 | Ahmed | 27 | Surat | 45000 | ahmed@yahoo.com |
| 3 | Rahul | 23 | Ahmedabad | 35000 | rahul@gmail.com |
| 4 | Amit | 30 | Vadodara | 70000 | NULL |
| 5 | Danish | 22 | Mumbai | 30000 | danish@gmail.com |
| 6 | Rohan | 28 | Surat | 55000 | NULL |
| 7 | Sameer | 26 | Delhi | 40000 | sameer@yahoo.com |

### Example 1: Salary Greater Than 40,000

```sql
SELECT *
FROM employees
WHERE salary > 40000;
```

### Example 2: Employees Between 22 and 27 Years Old

```sql
SELECT *
FROM employees
WHERE age BETWEEN 22 AND 27;
```

### Example 3: Employees From Ahmedabad and Surat

```sql
SELECT *
FROM employees
WHERE city IN ('Ahmedabad', 'Surat');
```

### Example 4: Employees Whose Names Start With R

```sql
SELECT *
FROM employees
WHERE name LIKE 'R%';
```

### Example 5: Employees Without Email Addresses

```sql
SELECT *
FROM employees
WHERE email IS NULL;
```

### Example 6: Employees From Ahmedabad Earning More Than 40,000

```sql
SELECT *
FROM employees
WHERE city = 'Ahmedabad'
AND salary > 40000;
```

### Example 7: Employees From Ahmedabad or Surat Earning More Than 40,000

```sql
SELECT *
FROM employees
WHERE city IN ('Ahmedabad', 'Surat')
AND salary > 40000;
```

### Example 8: Employees Not From Ahmedabad or Surat

```sql
SELECT *
FROM employees
WHERE city NOT IN ('Ahmedabad', 'Surat');
```

### Example 9: Employees Whose Names Contain 'an'

```sql
SELECT *
FROM employees
WHERE name LIKE '%an%';
```

### Example 10: Employees Whose Salary Is Not Between 30,000 and 50,000

```sql
SELECT *
FROM employees
WHERE salary NOT BETWEEN 30000 AND 50000;
```

---

# 19. Common SQL Mistakes

### Mistake 1: Using = NULL

Incorrect:

```sql
WHERE email = NULL;
```

Correct:

```sql
WHERE email IS NULL;
```

### Mistake 2: Confusing AND and OR

Incorrect for the intended meaning:

```sql
WHERE city = 'Ahmedabad'
OR city = 'Surat'
AND salary > 50000;
```

If both cities must satisfy the salary condition, use:

```sql
WHERE city IN ('Ahmedabad', 'Surat')
AND salary > 50000;
```

### Mistake 3: Forgetting Wildcards

Incorrect:

```sql
WHERE name LIKE 'R';
```

This matches only the exact string R.

Correct:

```sql
WHERE name LIKE 'R%';
```

### Mistake 4: Using NOT IN with NULL

Be careful when a NOT IN list or subquery contains NULL.

### Mistake 5: Assuming BETWEEN Excludes Boundaries

BETWEEN includes both boundaries.

### Mistake 6: Using LIKE for Numeric Ranges

Avoid:

```sql
WHERE salary LIKE '500%';
```

when your goal is to find salaries in a numeric range.

Use comparison operators instead.

---

# 20. Important SQL Interview Questions

## Beginner Level

1. What are SQL operators?
2. What are arithmetic operators?
3. What is the difference between `/` and `DIV`?
4. What is the modulo operator?
5. What are comparison operators?
6. What is the difference between `!=` and `<>`?
7. What are logical operators?
8. What is the difference between AND and OR?
9. What does the NOT operator do?
10. What is the truth table of AND and OR?

## Intermediate Level

11. What is the BETWEEN operator?
12. Is BETWEEN inclusive or exclusive?
13. What is the difference between BETWEEN and IN?
14. What is the IN operator?
15. What is NOT IN?
16. What is the LIKE operator?
17. What is the difference between `%` and `_`?
18. What is NOT LIKE?
19. What is IS NULL?
20. Why can't we use `= NULL`?

## Advanced Level

21. What is REGEXP?
22. What is the difference between LIKE and REGEXP?
23. What is operator precedence?
24. What is the precedence of AND and OR?
25. Why should we use parentheses in complex conditions?
26. What happens when NULL is included in a NOT IN list?
27. What are bitwise operators?
28. How do you find employees whose IDs are even?
29. How do you find employees whose names start with R and end with N?
30. How do you find employees whose salaries are outside a specified range?

---

# 21. Practical Assignments

Use the Employee Management System for these exercises.

Create a database and table if you haven't already.

```sql
CREATE DATABASE IF NOT EXISTS employee_db;

USE employee_db;

CREATE TABLE IF NOT EXISTS employees (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150),
    age TINYINT UNSIGNED,
    city VARCHAR(100),
    salary DECIMAL(12,2),
    department VARCHAR(100),
    joining_date DATE
);
```

Insert at least 20 employees with different values.

## Assignment 1: Arithmetic Operators

Write queries to:

1. Add 5,000 to every employee's salary in the result.
2. Calculate annual salary assuming monthly salary.
3. Calculate salary after deducting 10%.
4. Calculate 10% bonus for every employee.
5. Find employees with even IDs.
6. Find employees with odd IDs.

## Assignment 2: Comparison Operators

Write queries to:

1. Find employees earning more than 50,000.
2. Find employees earning less than 30,000.
3. Find employees aged exactly 25.
4. Find employees aged 25 or above.
5. Find employees earning exactly 40,000.
6. Find employees whose city is not Ahmedabad.

## Assignment 3: Logical Operators

Write queries to:

1. Find employees from Ahmedabad AND earning more than 40,000.
2. Find employees from Ahmedabad OR Surat.
3. Find employees older than 25 AND earning more than 50,000.
4. Find employees who are NOT from Delhi.
5. Find employees from Surat OR Vadodara AND aged above 25.
6. Find employees from Ahmedabad or Surat who earn between 30,000 and 60,000.

## Assignment 4: BETWEEN and IN

Write queries to:

1. Find employees aged between 20 and 30.
2. Find employees earning between 40,000 and 70,000.
3. Find employees from Ahmedabad, Surat, and Mumbai.
4. Find employees who are not from Ahmedabad or Delhi.
5. Find employees who joined between January 2025 and December 2025.

## Assignment 5: LIKE and REGEXP

Write queries to:

1. Find employees whose names start with R.
2. Find employees whose names end with N.
3. Find employees whose names contain A.
4. Find employees whose names contain exactly five characters.
5. Find employees whose names start with R and have exactly five characters.
6. Find employees whose emails end with gmail.com.
7. Find employees whose names contain either A or E.
8. Find employees whose names contain only alphabetic characters.

## Assignment 6: NULL

Write queries to:

1. Find employees without an email.
2. Find employees with an email.
3. Find employees whose department is NULL.
4. Find employees whose department is not NULL.

---

# 22. Phase 6 Quick Revision Sheet

| Operator | Category | Purpose |
|---|---|---|
| + | Arithmetic | Addition |
| - | Arithmetic | Subtraction |
| * | Arithmetic | Multiplication |
| / | Arithmetic | Division |
| % | Arithmetic | Modulo |
| DIV | Arithmetic | Integer division |
| = | Comparison | Equal |
| != | Comparison | Not equal |
| <> | Comparison | Not equal |
| > | Comparison | Greater than |
| < | Comparison | Less than |
| >= | Comparison | Greater than or equal |
| <= | Comparison | Less than or equal |
| AND | Logical | All conditions true |
| OR | Logical | At least one condition true |
| NOT | Logical | Reverses condition |
| BETWEEN | Special | Checks a range |
| IN | Special | Checks a list |
| NOT IN | Special | Excludes listed values |
| LIKE | Special | Pattern matching |
| NOT LIKE | Special | Excludes matching patterns |
| IS NULL | Special | Checks NULL |
| IS NOT NULL | Special | Checks non-NULL |
| REGEXP | Special | Regular expression matching |
| & | Bitwise | Bitwise AND |
| \| | Bitwise | Bitwise OR |
| ^ | Bitwise | Bitwise XOR |
| ~ | Bitwise | Bitwise NOT |
| << | Bitwise | Left shift |
| >> | Bitwise | Right shift |

---

# 23. Phase 6 Completion Checklist

| No. | Topic | Status |
|---|---|---|
| 1 | Introduction to SQL Operators | Covered |
| 2 | Arithmetic Operators | Covered |
| 3 | Comparison Operators | Covered |
| 4 | Logical Operators | Covered |
| 5 | AND | Covered |
| 6 | OR | Covered |
| 7 | NOT | Covered |
| 8 | Combining Logical Operators | Covered |
| 9 | BETWEEN | Covered |
| 10 | IN | Covered |
| 11 | NOT IN | Covered |
| 12 | LIKE | Covered |
| 13 | Wildcards (%) and (_) | Covered |
| 14 | NOT LIKE | Covered |
| 15 | IS NULL | Covered |
| 16 | IS NOT NULL | Covered |
| 17 | REGEXP | Covered |
| 18 | LIKE vs REGEXP | Covered |
| 19 | BETWEEN vs IN vs LIKE | Covered |
| 20 | Operator Precedence | Covered |
| 21 | Bitwise Operators | Introduction |
| 22 | Real-world SQL Filtering | Covered |

---

# What's Next?

## Phase 7 – SQL Constraints

In the next phase, we'll learn how to maintain data integrity and prevent invalid records from entering a database.

Topics:

1. What are SQL Constraints?
2. NOT NULL
3. UNIQUE
4. PRIMARY KEY
5. FOREIGN KEY
6. CHECK
7. DEFAULT
8. AUTO_INCREMENT
9. Composite Primary Key
10. Multiple Constraints on a Column
11. Referential Integrity
12. ON DELETE CASCADE
13. ON UPDATE CASCADE
14. ON DELETE SET NULL
15. ON DELETE RESTRICT
16. Primary Key vs Unique Key
17. Practical Database Design

**Important:** Constraints are essential for professional database development. They help ensure that your database remains consistent even when multiple applications or users modify the same data.

Tell me **"Next Phase"** when you're ready.