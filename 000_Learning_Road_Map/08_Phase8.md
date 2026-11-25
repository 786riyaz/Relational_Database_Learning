# SQL Complete Learning Roadmap
# Phase 8 – SQL Aggregate Functions

**Database:** MySQL 8.0+  
**Level:** Beginner to Intermediate  
**Goal:** Learn how to calculate, summarize, and analyze data using SQL aggregate functions.

---

# 1. What Are Aggregate Functions?

Aggregate functions perform calculations on multiple rows and return a single result.

For example, suppose we have an `employees` table:

| id | name | department | salary |
|---:|---|---|---:|
| 1 | John | IT | 50000 |
| 2 | Sarah | HR | 40000 |
| 3 | David | IT | 60000 |
| 4 | Alex | Finance | 45000 |
| 5 | Mike | HR | 55000 |

Suppose you want to find:

- Total number of employees.
- Total salary paid to employees.
- Average employee salary.
- Highest salary.
- Lowest salary.

You could retrieve all records and calculate these values in JavaScript.

However, SQL provides built-in aggregate functions that perform these calculations directly inside the database.

### Main Aggregate Functions

| Function | Purpose |
|---|---|
| COUNT() | Counts rows or non-NULL values |
| SUM() | Calculates the total |
| AVG() | Calculates the average |
| MIN() | Finds the minimum value |
| MAX() | Finds the maximum value |

### General Syntax

```sql
SELECT AGGREGATE_FUNCTION(column_name)
FROM table_name;
```

Example:

```sql
SELECT COUNT(*)
FROM employees;
```

Output:

| COUNT(*) |
|---:|
| 5 |

**Important:** Aggregate functions generally ignore NULL values, except `COUNT(*)`, which counts rows regardless of NULL values.

---

# 2. COUNT() Function

The `COUNT()` function counts records or non-NULL values.

It is one of the most frequently used SQL aggregate functions.

There are three commonly used forms:

1. `COUNT(*)`
2. `COUNT(column_name)`
3. `COUNT(DISTINCT column_name)`

## 2.1 COUNT(*)

Counts all rows in a table.

```sql
SELECT COUNT(*)
FROM employees;
```

Output:

| COUNT(*) |
|---:|
| 5 |

Even if some columns contain NULL, those rows are counted.

### Using an Alias

```sql
SELECT COUNT(*) AS total_employees
FROM employees;
```

Output:

| total_employees |
|---:|
| 5 |

Aliases make query results easier to understand.

## 2.2 COUNT(column_name)

Counts only non-NULL values in a particular column.

Suppose we have:

| id | name | email |
|---:|---|---|
| 1 | John | john@example.com |
| 2 | Sarah | NULL |
| 3 | David | david@example.com |
| 4 | Alex | NULL |
| 5 | Mike | mike@example.com |

Query:

```sql
SELECT COUNT(email) AS total_emails
FROM employees;
```

Output:

| total_emails |
|---:|
| 3 |

Why?

Because two records contain NULL in the email column.

`COUNT(email)` ignores those two values.

## 2.3 COUNT(DISTINCT column_name)

Counts unique, non-NULL values.

Suppose we have:

| id | name | department |
|---:|---|---|
| 1 | John | IT |
| 2 | Sarah | HR |
| 3 | David | IT |
| 4 | Alex | Finance |
| 5 | Mike | HR |

Query:

```sql
SELECT COUNT(DISTINCT department) AS total_departments
FROM employees;
```

Output:

| total_departments |
|---:|
| 3 |

Because there are three unique department values:

- IT
- HR
- Finance

### COUNT() Comparison

| Query | Meaning |
|---|---|
| `COUNT(*)` | Counts all rows |
| `COUNT(id)` | Counts rows where id is not NULL |
| `COUNT(email)` | Counts non-NULL email values |
| `COUNT(DISTINCT department)` | Counts unique, non-NULL departments |

### Important Interview Question

**What is the difference between COUNT(*) and COUNT(column_name)?**

Answer:

`COUNT(*)` counts every row, whereas `COUNT(column_name)` counts only rows where that column contains a non-NULL value.

---

# 3. SUM() Function

The `SUM()` function calculates the total of numeric values in a column.

### Syntax

```sql
SELECT SUM(column_name)
FROM table_name;
```

### Example

Consider this employee table:

| id | name | salary |
|---:|---|---:|
| 1 | John | 50000 |
| 2 | Sarah | 40000 |
| 3 | David | 60000 |
| 4 | Alex | 45000 |
| 5 | Mike | 55000 |

Query:

```sql
SELECT SUM(salary) AS total_salary
FROM employees;
```

Output:

| total_salary |
|---:|
| 250000 |

Calculation:

```text
50000 + 40000 + 60000 + 45000 + 55000

= 250000
```

### SUM() with WHERE

Suppose you want the total salary of employees working in IT.

```sql
SELECT SUM(salary) AS it_total_salary
FROM employees
WHERE department = 'IT';
```

Output:

| it_total_salary |
|---:|
| 110000 |

### SUM() with DISTINCT

You can also use DISTINCT with SUM.

```sql
SELECT SUM(DISTINCT salary) AS unique_salary_total
FROM employees;
```

This adds each distinct non-NULL salary only once.

For example, if salaries are:

```text
50000
40000
50000
60000
```

Then:

```text
SUM(salary) = 200000

SUM(DISTINCT salary) = 150000
```

Because the repeated `50000` is counted only once.

**Important:** SUM() returns NULL if there are no matching non-NULL values.

You can use `COALESCE()` to return zero instead.

```sql
SELECT COALESCE(SUM(salary), 0) AS total_salary
FROM employees
WHERE department = 'Sales';
```

---

# 4. AVG() Function

The `AVG()` function calculates the average of numeric values.

### Formula

```text
Average = Sum of Values / Number of Values
```

### Syntax

```sql
SELECT AVG(column_name)
FROM table_name;
```

### Example

| id | name | salary |
|---:|---|---:|
| 1 | John | 50000 |
| 2 | Sarah | 40000 |
| 3 | David | 60000 |
| 4 | Alex | 45000 |
| 5 | Mike | 55000 |

Query:

```sql
SELECT AVG(salary) AS average_salary
FROM employees;
```

Output:

| average_salary |
|---:|
| 50000 |

Calculation:

```text
(50000 + 40000 + 60000 + 45000 + 55000) / 5

= 250000 / 5

= 50000
```

### AVG() with WHERE

Find the average salary of IT employees.

```sql
SELECT AVG(salary) AS average_it_salary
FROM employees
WHERE department = 'IT';
```

### AVG() with DISTINCT

```sql
SELECT AVG(DISTINCT salary)
FROM employees;
```

This calculates the average using only distinct non-NULL salary values.

### Important: AVG() Ignores NULL

Suppose salaries are:

| id | salary |
|---:|---:|
| 1 | 50000 |
| 2 | 40000 |
| 3 | NULL |
| 4 | 60000 |

Query:

```sql
SELECT AVG(salary)
FROM employees;
```

Calculation:

```text
(50000 + 40000 + 60000) / 3

= 50000
```

NULL is excluded from both the sum and the count.

---

# 5. MIN() Function

The `MIN()` function returns the smallest value from a column.

It works with numeric, date, and string values.

### Syntax

```sql
SELECT MIN(column_name)
FROM table_name;
```

### Example: Minimum Salary

```sql
SELECT MIN(salary) AS minimum_salary
FROM employees;
```

Output:

| minimum_salary |
|---:|
| 40000 |

### Example: Earliest Joining Date

Suppose we have an employee joining date column.

```sql
SELECT MIN(joining_date) AS earliest_joining_date
FROM employees;
```

This returns the earliest date.

### Example: Alphabetically Smallest Name

```sql
SELECT MIN(name) AS first_name_alphabetically
FROM employees;
```

This returns the smallest string according to the applicable collation's sorting rules.

**Important:** MIN() ignores NULL values. If no non-NULL values exist, it returns NULL.

---

# 6. MAX() Function

The `MAX()` function returns the largest value from a column.

It works with numeric, date, and string values.

### Syntax

```sql
SELECT MAX(column_name)
FROM table_name;
```

### Example: Maximum Salary

```sql
SELECT MAX(salary) AS highest_salary
FROM employees;
```

Output:

| highest_salary |
|---:|
| 60000 |

### Example: Latest Joining Date

```sql
SELECT MAX(joining_date) AS latest_joining_date
FROM employees;
```

This returns the most recent joining date.

### Example: Alphabetically Largest Name

```sql
SELECT MAX(name)
FROM employees;
```

This returns the largest string according to the column's collation.

**Important:** MAX() also ignores NULL values.

---

# 7. Multiple Aggregate Functions in One Query

You can use multiple aggregate functions in a single SELECT statement.

This is particularly useful for generating reports and analytics.

### Example

```sql
SELECT
    COUNT(*) AS total_employees,
    SUM(salary) AS total_salary,
    AVG(salary) AS average_salary,
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary
FROM employees;
```

Output:

| total_employees | total_salary | average_salary | minimum_salary | maximum_salary |
|---:|---:|---:|---:|---:|
| 5 | 250000 | 50000 | 40000 | 60000 |

With one SQL query, you get five different statistics.

### Practical Use Cases

- Employee salary reports.
- Monthly revenue reports.
- Total product inventory.
- Average customer spending.
- Minimum and maximum product prices.
- Total orders and sales.

---

# 8. DISTINCT with Aggregate Functions

`DISTINCT` removes duplicate values before an aggregate function performs its calculation.

### Example Table

| id | department | salary |
|---:|---|---:|
| 1 | IT | 50000 |
| 2 | HR | 40000 |
| 3 | IT | 50000 |
| 4 | Finance | 60000 |
| 5 | HR | 40000 |

### COUNT Without DISTINCT

```sql
SELECT COUNT(department)
FROM employees;
```

Output:

```text
5
```

### COUNT With DISTINCT

```sql
SELECT COUNT(DISTINCT department)
FROM employees;
```

Output:

```text
3
```

### SUM Without DISTINCT

```sql
SELECT SUM(salary)
FROM employees;
```

Output:

```text
240000
```

### SUM With DISTINCT

```sql
SELECT SUM(DISTINCT salary)
FROM employees;
```

Output:

```text
150000
```

Calculation:

```text
50000 + 40000 + 60000 = 150000
```

### AVG Without DISTINCT

```sql
SELECT AVG(salary)
FROM employees;
```

Output:

```text
48000
```

### AVG With DISTINCT

```sql
SELECT AVG(DISTINCT salary)
FROM employees;
```

Output:

```text
50000
```

Calculation:

```text
(50000 + 40000 + 60000) / 3

= 50000
```

### Important Concept

DISTINCT applies to the values passed into the aggregate function.

For example:

```sql
COUNT(DISTINCT department)
```

means:

1. Get department values.
2. Remove duplicates.
3. Ignore NULL values.
4. Count the remaining values.

---

# 9. Aggregate Functions with WHERE

You can combine aggregate functions with WHERE to calculate statistics for specific records.

Remember:

**WHERE filters rows before aggregate calculations are performed.**

### Example 1: Total IT Salary

```sql
SELECT SUM(salary) AS total_it_salary
FROM employees
WHERE department = 'IT';
```

### Example 2: Number of HR Employees

```sql
SELECT COUNT(*) AS total_hr_employees
FROM employees
WHERE department = 'HR';
```

### Example 3: Average Salary Above 50000

```sql
SELECT AVG(salary) AS average_salary
FROM employees
WHERE salary > 50000;
```

### Example 4: Highest Salary in Finance

```sql
SELECT MAX(salary) AS highest_finance_salary
FROM employees
WHERE department = 'Finance';
```

### Important Difference

Consider these two queries:

```sql
SELECT COUNT(*)
FROM employees;
```

This counts all employees.

```sql
SELECT COUNT(*)
FROM employees
WHERE salary > 50000;
```

This counts only employees whose salary is greater than 50000.

---

# 10. Aggregate Functions with NULL Values

Understanding NULL behavior is very important when working with aggregate functions.

Consider:

| id | name | salary |
|---:|---|---:|
| 1 | John | 50000 |
| 2 | Sarah | 40000 |
| 3 | David | NULL |
| 4 | Alex | 60000 |
| 5 | Mike | NULL |

Now execute:

```sql
SELECT
    COUNT(*) AS total_rows,
    COUNT(salary) AS salary_records,
    SUM(salary) AS total_salary,
    AVG(salary) AS average_salary,
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary
FROM employees;
```

Output:

| total_rows | salary_records | total_salary | average_salary | minimum_salary | maximum_salary |
|---:|---:|---:|---:|---:|---:|
| 5 | 3 | 150000 | 50000 | 40000 | 60000 |

### Why?

`COUNT(*)` counts all five rows.

`COUNT(salary)` counts only three non-NULL salary values.

`SUM(salary)` adds only non-NULL salaries.

`AVG(salary)` calculates the average using only three non-NULL salaries.

`MIN()` and `MAX()` ignore NULL values.

### What If All Values Are NULL?

Consider:

| id | salary |
|---:|---:|
| 1 | NULL |
| 2 | NULL |
| 3 | NULL |

Query:

```sql
SELECT
    COUNT(*) AS total_rows,
    COUNT(salary) AS salary_count,
    SUM(salary) AS total_salary,
    AVG(salary) AS average_salary,
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary
FROM employees;
```

Output:

| total_rows | salary_count | total_salary | average_salary | minimum_salary | maximum_salary |
|---:|---:|---:|---:|---:|---:|
| 3 | 0 | NULL | NULL | NULL | NULL |

Notice that `COUNT(*)` still returns 3.

### Handling NULL with COALESCE()

Sometimes you want zero instead of NULL.

```sql
SELECT
    COALESCE(SUM(salary), 0) AS total_salary
FROM employees;
```

If SUM returns NULL, COALESCE returns zero.

You can also use it with AVG:

```sql
SELECT
    COALESCE(AVG(salary), 0) AS average_salary
FROM employees;
```

**Remember:** COALESCE is not an aggregate function. It is a function that returns the first non-NULL argument.

---

# 11. Aggregate Functions with GROUP BY

This is one of the most important SQL concepts.

`GROUP BY` divides rows into groups based on one or more columns.

Aggregate functions then calculate results separately for each group.

### Example

Consider:

**employees**

| id | name | department | salary |
|---:|---|---|---:|
| 1 | John | IT | 50000 |
| 2 | Sarah | HR | 40000 |
| 3 | David | IT | 60000 |
| 4 | Alex | Finance | 45000 |
| 5 | Mike | HR | 55000 |

Suppose you want the total salary for each department.

Without GROUP BY, you get one total:

```sql
SELECT SUM(salary)
FROM employees;
```

Output:

| SUM(salary) |
|---:|
| 250000 |

But we need separate totals for each department.

### Using GROUP BY

```sql
SELECT
    department,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department;
```

Output:

| department | total_salary |
|---|---:|
| Finance | 45000 |
| HR | 95000 |
| IT | 110000 |

### How Does GROUP BY Work?

Conceptually, MySQL performs these operations:

**Step 1:** Read employee records.

**Step 2:** Group records based on department.

```text
IT:
John - 50000
David - 60000

HR:
Sarah - 40000
Mike - 55000

Finance:
Alex - 45000
```

**Step 3:** Calculate SUM(salary) separately for each group.

```text
IT       = 110000
HR       = 95000
Finance  = 45000
```

**Step 4:** Return one result row per group.

### GROUP BY with COUNT()

Find the number of employees in each department.

```sql
SELECT
    department,
    COUNT(*) AS total_employees
FROM employees
GROUP BY department;
```

Output:

| department | total_employees |
|---|---:|
| Finance | 1 |
| HR | 2 |
| IT | 2 |

### GROUP BY with AVG()

```sql
SELECT
    department,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department;
```

Output:

| department | average_salary |
|---|---:|
| Finance | 45000 |
| HR | 47500 |
| IT | 55000 |

### GROUP BY with MIN() and MAX()

```sql
SELECT
    department,
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary
FROM employees
GROUP BY department;
```

Output:

| department | minimum_salary | maximum_salary |
|---|---:|---:|
| Finance | 45000 | 45000 |
| HR | 40000 | 55000 |
| IT | 50000 | 60000 |

### Important GROUP BY Rule

When using GROUP BY, every selected column should generally be:

1. Included in the GROUP BY clause, or
2. Used inside an aggregate function, or
3. Functionally dependent on the GROUP BY columns in a way MySQL can recognize.

For example:

```sql
SELECT
    department,
    name,
    SUM(salary)
FROM employees
GROUP BY department;
```

This query is generally invalid with MySQL's default `ONLY_FULL_GROUP_BY` SQL mode because `name` is neither grouped nor aggregated.

Why?

Because one department can have multiple employee names. MySQL cannot determine which name should appear in the department's result row.

Correct query:

```sql
SELECT
    department,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department;
```

If you need employee names, use an appropriate aggregate or a separate query.

**Important:** Do not disable `ONLY_FULL_GROUP_BY` just to make ambiguous queries work.

---

# 12. GROUP BY Multiple Columns

You can group records using multiple columns.

### Example

Suppose we have:

| id | department | gender | salary |
|---:|---|---|---:|
| 1 | IT | Male | 50000 |
| 2 | IT | Female | 60000 |
| 3 | IT | Male | 55000 |
| 4 | HR | Female | 40000 |
| 5 | HR | Male | 45000 |

Suppose you want the number of employees grouped by both department and gender.

```sql
SELECT
    department,
    gender,
    COUNT(*) AS total_employees
FROM employees
GROUP BY department, gender;
```

Output:

| department | gender | total_employees |
|---|---|---:|
| HR | Female | 1 |
| HR | Male | 1 |
| IT | Female | 1 |
| IT | Male | 2 |

### How Does It Work?

MySQL creates groups based on the combination of both columns.

For example:

```text
IT + Male
IT + Female
HR + Male
HR + Female
```

Each combination becomes a separate group.

### Practical Example

Calculate total salary for each department and job title:

```sql
SELECT
    department,
    job_title,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department, job_title;
```

---

# 13. GROUP BY with ORDER BY

You can sort grouped results using ORDER BY.

### Example: Highest Department Salary First

```sql
SELECT
    department,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department
ORDER BY total_salary DESC;
```

Output:

| department | total_salary |
|---|---:|
| IT | 110000 |
| HR | 95000 |
| Finance | 45000 |

### Sort by Department Name

```sql
SELECT
    department,
    COUNT(*) AS total_employees
FROM employees
GROUP BY department
ORDER BY department ASC;
```

### Sort by Aggregate Result

```sql
SELECT
    department,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department
ORDER BY average_salary DESC;
```

**Important:** GROUP BY and ORDER BY have different responsibilities.

- GROUP BY creates groups.
- ORDER BY sorts the resulting rows.

---

# 14. GROUP BY with WHERE

You can filter records before grouping them.

Remember:

**WHERE filters individual rows before GROUP BY creates groups.**

### Example

Find the total salary for each department, considering only employees whose salary is greater than 40000.

```sql
SELECT
    department,
    SUM(salary) AS total_salary
FROM employees
WHERE salary > 40000
GROUP BY department;
```

### Execution Concept

Suppose the records are:

| name | department | salary |
|---|---|---:|
| John | IT | 50000 |
| Sarah | HR | 40000 |
| David | IT | 60000 |
| Alex | Finance | 45000 |
| Mike | HR | 55000 |

First, WHERE removes records with salary <= 40000.

Then GROUP BY creates department groups.

Finally, SUM calculates the total for each department.

### Another Example

Count employees earning more than 50000 in each department.

```sql
SELECT
    department,
    COUNT(*) AS employee_count
FROM employees
WHERE salary > 50000
GROUP BY department;
```

---

# 15. Aggregate Functions with HAVING

`HAVING` filters groups after GROUP BY has created them.

This is different from WHERE.

### WHERE vs HAVING

| WHERE | HAVING |
|---|---|
| Filters individual rows | Filters groups |
| Applied before GROUP BY | Applied after GROUP BY |
| Commonly used with normal conditions | Commonly used with aggregate conditions |
| Cannot directly filter aggregate results | Can filter aggregate results |

### Example

Suppose you want departments having total salary greater than 90000.

You cannot use WHERE directly on `SUM(salary)` because WHERE filters rows before aggregation.

Use HAVING:

```sql
SELECT
    department,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING SUM(salary) > 90000;
```

Output:

| department | total_salary |
|---|---:|
| HR | 95000 |
| IT | 110000 |

Finance is excluded because its total salary is only 45000.

### HAVING with COUNT()

Find departments having more than one employee.

```sql
SELECT
    department,
    COUNT(*) AS total_employees
FROM employees
GROUP BY department
HAVING COUNT(*) > 1;
```

Output:

| department | total_employees |
|---|---:|
| HR | 2 |
| IT | 2 |

### HAVING with AVG()

Find departments where average salary is greater than 50000.

```sql
SELECT
    department,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 50000;
```

Output:

| department | average_salary |
|---|---:|
| IT | 55000 |

### HAVING with Multiple Conditions

```sql
SELECT
    department,
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department
HAVING COUNT(*) >= 2
AND AVG(salary) > 45000;
```

This returns departments satisfying both conditions.

---

# 16. WHERE vs HAVING – Practical Comparison

Let's understand this with a single example.

Suppose you want:

**Find departments having at least two employees, but consider only employees earning more than 40000.**

Query:

```sql
SELECT
    department,
    COUNT(*) AS total_employees,
    SUM(salary) AS total_salary
FROM employees
WHERE salary > 40000
GROUP BY department
HAVING COUNT(*) >= 2;
```

Execution:

**Step 1 – FROM**

Read records from employees.

**Step 2 – WHERE**

Keep employees whose salary is greater than 40000.

**Step 3 – GROUP BY**

Group remaining records by department.

**Step 4 – HAVING**

Keep only groups having at least two employees.

**Step 5 – SELECT**

Calculate and return the selected columns.

**Step 6 – ORDER BY**

Sort results if specified.

This is the conceptual logical processing order of the query.

### Visual Comparison

```text
EMPLOYEES TABLE
       |
       v
WHERE salary > 40000
       |
       v
GROUP BY department
       |
       v
HAVING COUNT(*) >= 2
       |
       v
SELECT department, COUNT(*), SUM(salary)
       |
       v
FINAL RESULT
```

---

# 17. GROUP BY with Expressions

You can group records using expressions and calculated values.

### Example: Group Employees by Salary Range

```sql
SELECT
    CASE
        WHEN salary < 40000 THEN 'Low Salary'
        WHEN salary BETWEEN 40000 AND 60000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS salary_range,

    COUNT(*) AS total_employees

FROM employees

GROUP BY
    CASE
        WHEN salary < 40000 THEN 'Low Salary'
        WHEN salary BETWEEN 40000 AND 60000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END;
```

This groups employees into salary categories.

### Example: Group Orders by Year

Suppose we have an `orders` table containing `order_date`.

```sql
SELECT
    YEAR(order_date) AS order_year,
    COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_date);
```

This calculates the number of orders for each year.

### Example: Group Orders by Month

```sql
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    order_year,
    order_month;
```

**Important:** Grouping by month alone combines January from different years. Include the year when analyzing multiple years of data.

---

# 18. Aggregate Functions with DISTINCT and GROUP BY

You can combine DISTINCT with aggregate functions inside grouped queries.

### Example: Unique Customers per Department

Suppose you have:

**sales**

| id | department | customer_id | amount |
|---:|---|---:|---:|
| 1 | IT | 101 | 5000 |
| 2 | IT | 102 | 6000 |
| 3 | IT | 101 | 3000 |
| 4 | HR | 103 | 4000 |
| 5 | HR | 103 | 2000 |

Query:

```sql
SELECT
    department,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM sales
GROUP BY department;
```

Output:

| department | unique_customers |
|---|---:|
| HR | 1 |
| IT | 2 |

### Example: Total Sales per Department

```sql
SELECT
    department,
    SUM(amount) AS total_sales
FROM sales
GROUP BY department;
```

Output:

| department | total_sales |
|---|---:|
| HR | 6000 |
| IT | 14000 |

---

# 19. Important Aggregate Function Rules

### Rule 1: Aggregate Functions Ignore NULL

Except `COUNT(*)`, which counts all rows.

### Rule 2: Aggregate Functions Usually Return One Result

Without GROUP BY, an aggregate query normally returns one result row.

```sql
SELECT SUM(salary)
FROM employees;
```

### Rule 3: GROUP BY Produces Multiple Result Rows

```sql
SELECT department, SUM(salary)
FROM employees
GROUP BY department;
```

Each department produces one result row.

### Rule 4: WHERE Cannot Directly Filter Aggregate Results

Incorrect:

```sql
SELECT department, SUM(salary)
FROM employees
WHERE SUM(salary) > 50000
GROUP BY department;
```

Correct:

```sql
SELECT department, SUM(salary)
FROM employees
GROUP BY department
HAVING SUM(salary) > 50000;
```

### Rule 5: Aggregate Functions Can Be Combined

```sql
SELECT
    COUNT(*) AS total,
    AVG(salary) AS average,
    MAX(salary) AS highest
FROM employees;
```

### Rule 6: Aggregate Functions Cannot Normally Be Nested Directly

This is invalid:

```sql
SELECT AVG(SUM(salary))
FROM employees;
```

To aggregate an aggregate result, use a subquery or CTE.

Example:

```sql
SELECT AVG(department_salary)
FROM (
    SELECT SUM(salary) AS department_salary
    FROM employees
    GROUP BY department
) AS department_totals;
```

This calculates the average total salary across departments.

---

# 20. Practical Real-World Examples

These examples demonstrate how aggregate functions are used in actual applications.

## Example 1: Total Number of Users

```sql
SELECT COUNT(*) AS total_users
FROM users;
```

Used in admin dashboards.

## Example 2: Total Revenue

```sql
SELECT SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'Completed';
```

Used in e-commerce analytics.

## Example 3: Average Order Value

```sql
SELECT AVG(total_amount) AS average_order_value
FROM orders
WHERE status = 'Completed';
```

Used to measure average customer spending per order.

## Example 4: Total Orders Per Customer

```sql
SELECT
    customer_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id;
```

Used for customer analytics.

## Example 5: Top Revenue-Generating Products

```sql
SELECT
    product_id,
    SUM(quantity * unit_price) AS total_revenue
FROM order_items
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;
```

Used to identify the best-selling products by revenue.

## Example 6: Monthly Revenue

```sql
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(total_amount) AS monthly_revenue
FROM orders
WHERE status = 'Completed'
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    order_year,
    order_month;
```

Used in financial reports.

## Example 7: Departments with More Than Five Employees

```sql
SELECT
    department_id,
    COUNT(*) AS total_employees
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5;
```

Used in HR analytics.

## Example 8: Products with Low Stock

```sql
SELECT
    category_id,
    SUM(stock_quantity) AS total_stock
FROM products
GROUP BY category_id
HAVING SUM(stock_quantity) < 100;
```

Used in inventory management.

---

# 21. Common Mistakes and Best Practices

| Mistake | Correct Approach |
|---|---|
| Using COUNT(column) when you need all rows | Use COUNT(*) |
| Assuming COUNT(column) counts NULL values | Remember it ignores NULL |
| Using WHERE with SUM() | Use HAVING for aggregate conditions |
| Selecting ungrouped columns | Group them or aggregate them |
| Assuming AVG() counts NULL as zero | AVG() ignores NULL |
| Using SUM(DISTINCT) without understanding it | Remember duplicate values are counted once |
| Grouping by month without year | Include YEAR() for multi-year reports |
| Assuming GROUP BY sorts results | Use ORDER BY explicitly |
| Using SELECT * with GROUP BY | Select grouped or aggregated columns |

### Performance Best Practices

1. Filter unnecessary rows before aggregation using WHERE.
2. Use indexes on appropriate filtering and grouping columns where beneficial.
3. Avoid unnecessary DISTINCT operations.
4. Avoid fetching all rows into Node.js just to calculate totals.
5. Use SQL aggregate functions for database-side calculations.
6. Analyze expensive queries using `EXPLAIN`.

---

# 22. SQL Aggregate Functions Interview Questions

### Beginner Level

**1. What are aggregate functions in SQL?**

Functions that perform calculations on multiple rows and return a summarized result.

**2. Name the five main aggregate functions.**

- COUNT()
- SUM()
- AVG()
- MIN()
- MAX()

**3. What is the difference between COUNT(*) and COUNT(column)?**

COUNT(*) counts all rows, while COUNT(column) counts non-NULL values.

**4. Does SUM() ignore NULL values?**

Yes. SUM() ignores NULL values.

**5. What does AVG() calculate?**

It calculates the arithmetic average of non-NULL numeric values.

### Intermediate Level

**6. What is GROUP BY?**

GROUP BY groups records based on one or more columns so aggregate calculations can be performed separately for each group.

**7. What is the difference between WHERE and HAVING?**

WHERE filters rows before grouping, while HAVING filters groups after aggregation.

**8. Can we use multiple aggregate functions in one query?**

Yes.

```sql
SELECT
    COUNT(*),
    SUM(salary),
    AVG(salary),
    MIN(salary),
    MAX(salary)
FROM employees;
```

**9. Can GROUP BY contain multiple columns?**

Yes.

```sql
SELECT department, gender, COUNT(*)
FROM employees
GROUP BY department, gender;
```

**10. Can we use ORDER BY with GROUP BY?**

Yes. ORDER BY sorts the final grouped result.

### Advanced Level

**11. What is the difference between SUM(column) and SUM(DISTINCT column)?**

SUM(column) adds all non-NULL values, including duplicates. SUM(DISTINCT column) adds only unique non-NULL values.

**12. What happens when all values passed to SUM() are NULL?**

SUM() returns NULL.

**13. How can we return zero instead of NULL?**

```sql
SELECT COALESCE(SUM(salary), 0)
FROM employees;
```

**14. Can we use aggregate functions directly in WHERE?**

No. Use HAVING for conditions on aggregate results.

**15. Can aggregate functions be nested directly?**

Generally, no. Use a subquery or CTE.

**16. Does GROUP BY automatically sort results?**

Do not rely on implicit ordering. Use ORDER BY when sorting is required.

**17. What is ONLY_FULL_GROUP_BY?**

It is a MySQL SQL mode that rejects queries selecting nonaggregated columns that are neither grouped nor functionally dependent on grouped columns.

---

# 23. Practical Assignments

Use the following tables for practice.

### employees

| id | name | department | salary | gender |
|---:|---|---|---:|---|
| 1 | John | IT | 50000 | Male |
| 2 | Sarah | HR | 40000 | Female |
| 3 | David | IT | 60000 | Male |
| 4 | Alex | Finance | 45000 | Male |
| 5 | Mike | HR | 55000 | Male |
| 6 | Emma | IT | 70000 | Female |
| 7 | Olivia | Finance | 65000 | Female |
| 8 | James | HR | 35000 | Male |
| 9 | Sophia | IT | 55000 | Female |
| 10 | Robert | Finance | 50000 | Male |

### Assignment 1: Basic Aggregation

Write queries to find:

1. Total number of employees.
2. Total salary of all employees.
3. Average salary.
4. Highest salary.
5. Lowest salary.
6. Total number of unique departments.
7. Total number of male employees.
8. Total number of female employees.

### Assignment 2: GROUP BY

Write queries to find:

1. Number of employees in each department.
2. Total salary for each department.
3. Average salary for each department.
4. Highest salary in each department.
5. Lowest salary in each department.
6. Number of employees by gender.
7. Total salary by gender.
8. Average salary by gender.

### Assignment 3: HAVING

Write queries to find:

1. Departments having more than two employees.
2. Departments having total salary greater than 150000.
3. Departments having average salary greater than 50000.
4. Departments having maximum salary greater than 60000.
5. Departments having at least two female employees.

### Assignment 4: Combined Queries

Write queries to find:

1. Departments having more than two employees, sorted by average salary descending.
2. Total salary of male employees in each department.
3. Departments having total salary greater than 100000, considering only employees earning more than 40000.
4. Number of employees in each department earning more than 50000.
5. Department with the highest total salary.

---

# 24. Phase 8 Quick Revision Sheet

| Function / Clause | Purpose | Example |
|---|---|---|
| COUNT(*) | Count all rows | `COUNT(*)` |
| COUNT(column) | Count non-NULL values | `COUNT(email)` |
| COUNT(DISTINCT column) | Count unique non-NULL values | `COUNT(DISTINCT department)` |
| SUM() | Calculate total | `SUM(salary)` |
| AVG() | Calculate average | `AVG(salary)` |
| MIN() | Find minimum | `MIN(salary)` |
| MAX() | Find maximum | `MAX(salary)` |
| GROUP BY | Group rows | `GROUP BY department` |
| HAVING | Filter groups | `HAVING COUNT(*) > 5` |
| WHERE | Filter individual rows | `WHERE salary > 50000` |
| COALESCE() | Replace NULL with another value | `COALESCE(SUM(salary), 0)` |

### SQL Logical Processing Order

Remember this conceptual order:

```text
1. FROM
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. DISTINCT
7. ORDER BY
8. LIMIT
```

This is particularly important for understanding GROUP BY and HAVING.

---

# 25. Phase 8 Completion Checklist

Before moving to Phase 9, make sure you can:

- [ ] Explain aggregate functions.
- [ ] Use COUNT().
- [ ] Understand COUNT(*) vs COUNT(column).
- [ ] Use COUNT(DISTINCT).
- [ ] Use SUM().
- [ ] Use AVG().
- [ ] Use MIN() and MAX().
- [ ] Combine multiple aggregate functions.
- [ ] Understand DISTINCT with aggregate functions.
- [ ] Handle NULL values in aggregate calculations.
- [ ] Use COALESCE().
- [ ] Understand GROUP BY.
- [ ] Group records using multiple columns.
- [ ] Combine GROUP BY with ORDER BY.
- [ ] Combine GROUP BY with WHERE.
- [ ] Understand HAVING.
- [ ] Understand WHERE vs HAVING.
- [ ] Write queries using multiple aggregate functions.
- [ ] Solve practical business analytics queries.

---

## Next Phase: Phase 9 – GROUP BY and HAVING (Advanced)

Phase 8 introduced aggregate functions and the fundamentals of grouping. Phase 9 will go deeper into grouping and filtering grouped data.

Topics:

1. GROUP BY Internal Working
2. GROUP BY Multiple Columns – Advanced
3. GROUP BY with Expressions
4. GROUP BY with CASE
5. WHERE vs HAVING – Advanced Differences
6. HAVING with Multiple Conditions
7. GROUP BY with JOIN
8. GROUP BY with Subqueries
9. ROLLUP
10. GROUPING() Function
11. Multiple-Level Aggregation
12. Common GROUP BY Errors
13. Real-World Reporting Queries
14. Interview Questions
15. Practical Assignments

**Phase 8 is complete.** Continue to Phase 9 when you're ready.