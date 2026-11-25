# SQL Complete Learning Roadmap
# Phase 11 – SQL Subqueries

**Database:** MySQL 8.0+  
**Level:** Intermediate to Advanced  
**Goal:** Learn how to write queries inside other queries, retrieve calculated results, compare records against aggregated data, and solve complex database problems.

Subqueries are an important SQL concept because they allow you to break complex problems into smaller queries.

They are commonly used in backend development, reporting, analytics, and database operations.

---

# 1. What Are Subqueries?

A subquery is a SQL query written inside another SQL query.

It is also called an **inner query** or **nested query**.

The query containing the subquery is called the **outer query**.

### Example

Suppose we have an `employees` table:

| id | name | department | salary |
|---:|---|---|---:|
| 1 | John | IT | 50000 |
| 2 | Sarah | HR | 40000 |
| 3 | David | IT | 60000 |
| 4 | Alex | Finance | 45000 |
| 5 | Mike | HR | 55000 |

**Requirement:** Find employees earning more than the company's average salary.

We can solve this using two queries.

### Step 1: Calculate Average Salary

```sql
SELECT AVG(salary)
FROM employees;
```

Output:

```text
50000
```

### Step 2: Find Employees Earning More Than Average

```sql
SELECT *
FROM employees
WHERE salary > 50000;
```

Output:

| id | name | department | salary |
|---:|---|---|---:|
| 3 | David | IT | 60000 |
| 5 | Mike | HR | 55000 |

But instead of executing two separate queries, we can combine them.

### Using a Subquery

```sql
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

### Understanding the Query

**Inner Query:**

```sql
SELECT AVG(salary)
FROM employees;
```

Calculates the average salary.

**Outer Query:**

```sql
SELECT *
FROM employees
WHERE salary > 50000;
```

Uses the result of the inner query to filter employees.

### General Syntax

```sql
SELECT columns
FROM table_name
WHERE column_name OPERATOR (
    SELECT columns
    FROM another_table
);
```

**Important:** A subquery must be enclosed in parentheses.

---

# 2. Why Do We Need Subqueries?

Consider these requirements:

1. Find employees earning more than the company average salary.
2. Find the highest-paid employee.
3. Find departments having more employees than the average department size.
4. Find customers who have placed orders.
5. Find products that have never been ordered.
6. Find employees earning more than their department's average salary.

These problems often require intermediate calculations or existence checks.

Subqueries allow you to perform those calculations inside a single SQL statement.

### Benefits

- Break complex queries into smaller logical parts.
- Perform comparisons against aggregate results.
- Filter records using results from another query.
- Check whether related records exist.
- Calculate intermediate datasets.
- Avoid executing multiple separate SQL statements from application code.

---

# 3. Types of Subqueries

Subqueries can be classified based on the result they return and how they are used.

### Based on Returned Results

| Type | Description |
|---|---|
| Single-row subquery | Returns one row |
| Multiple-row subquery | Returns multiple rows |
| Scalar subquery | Returns exactly one column and one row |
| Multiple-column subquery | Returns multiple columns |

### Based on Usage

| Type | Description |
|---|---|
| Subquery with WHERE | Filters records |
| Subquery with SELECT | Calculates a value for output |
| Subquery with FROM | Creates a derived table |
| Subquery with HAVING | Filters grouped results |
| Subquery with IN | Matches values against a result set |
| Subquery with EXISTS | Checks whether records exist |
| Correlated subquery | References the outer query |

Let's understand each one.

---

# 4. Single-Row Subqueries

A single-row subquery returns one row.

It is commonly used with comparison operators:

- `=`
- `>`
- `<`
- `>=`
- `<=`
- `<>`

### Example: Find the Highest-Paid Employee

```sql
SELECT *
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
);
```

Output:

| id | name | department | salary |
|---:|---|---|---:|
| 3 | David | IT | 60000 |

The inner query returns one value: `60000`.

The outer query finds employees whose salary equals that value.

### Example: Find Employees Earning More Than Average

```sql
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

### Example: Find Employees Earning Less Than Maximum Salary

```sql
SELECT *
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
);
```

### Important

A scalar subquery must return one column and at most one row when used in a scalar expression.

If a scalar subquery returns multiple rows, MySQL generates an error.

Example:

```sql
SELECT *
FROM employees
WHERE salary = (
    SELECT salary
    FROM employees
    WHERE department = 'IT'
);
```

This may fail because multiple IT employees can exist.

You would need an appropriate aggregate or a multiple-row operator such as IN.

---

# 5. Multiple-Row Subqueries

A multiple-row subquery returns multiple rows.

You generally cannot use a multiple-row result directly with `=` or `>`.

Instead, use operators such as:

- IN
- NOT IN
- ANY
- ALL
- EXISTS

### Example: Find Employees Working in Departments Located in Ahmedabad

Suppose we have two tables.

**departments**

| id | department_name | location |
|---:|---|---|
| 1 | IT | Ahmedabad |
| 2 | HR | Mumbai |
| 3 | Finance | Ahmedabad |

**employees**

| id | name | department_id |
|---:|---|---:|
| 101 | John | 1 |
| 102 | Sarah | 2 |
| 103 | David | 3 |
| 104 | Alex | 1 |

### Query

```sql
SELECT *
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE location = 'Ahmedabad'
);
```

The inner query returns:

| id |
|---:|
| 1 |
| 3 |

The outer query finds employees whose department ID is either 1 or 3.

Output:

| id | name | department_id |
|---:|---|---:|
| 101 | John | 1 |
| 103 | David | 3 |
| 104 | Alex | 1 |

### Why IN?

Because the inner query returns multiple department IDs.

The outer query checks whether each employee's department ID belongs to that result set.

---

# 6. Scalar Subqueries

A scalar subquery returns exactly one value: one row and one column.

It can be used in places where a single expression is allowed.

### Example

```sql
SELECT
    name,
    salary,
    (SELECT AVG(salary) FROM employees) AS company_average
FROM employees;
```

Output:

| name | salary | company_average |
|---|---:|---:|
| John | 50000 | 50000 |
| Sarah | 40000 | 50000 |
| David | 60000 | 50000 |
| Alex | 45000 | 50000 |
| Mike | 55000 | 50000 |

The scalar subquery calculates the company average and displays it alongside every employee.

### Another Example: Salary Difference

```sql
SELECT
    name,
    salary,
    salary - (
        SELECT AVG(salary)
        FROM employees
    ) AS salary_difference
FROM employees;
```

This shows how much each employee earns above or below the company average.

### Important

A scalar subquery returning no rows evaluates to NULL.

A scalar subquery returning multiple rows causes an error.

---

# 7. Subqueries with WHERE

This is one of the most common uses of subqueries.

You can use subqueries in WHERE to filter records based on another query's result.

### Example 1: Employees Earning More Than Average

```sql
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

### Example 2: Employees Belonging to IT or HR Departments

```sql
SELECT *
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE department_name IN ('IT', 'HR')
);
```

### Example 3: Employees Not Working in Ahmedabad

```sql
SELECT *
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE location <> 'Ahmedabad'
);
```

### Example 4: Employees Having the Highest Salary

```sql
SELECT *
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
);
```

---

# 8. Subqueries with SELECT

You can place a scalar subquery inside the SELECT list.

This is useful when you want to display a calculated value alongside regular table columns.

### Example 1: Display Company Average Salary

```sql
SELECT
    name,
    department,
    salary,

    (
        SELECT AVG(salary)
        FROM employees
    ) AS company_average_salary

FROM employees;
```

### Example 2: Display Total Employee Count

```sql
SELECT
    name,
    salary,

    (
        SELECT COUNT(*)
        FROM employees
    ) AS total_employees

FROM employees;
```

### Example 3: Display Department Employee Count

```sql
SELECT
    e.name,
    e.department_id,

    (
        SELECT COUNT(*)
        FROM employees e2
        WHERE e2.department_id = e.department_id
    ) AS department_employee_count

FROM employees e;
```

This third example is a correlated subquery, which we will study in detail later.

---

# 9. Subqueries with FROM

A subquery inside FROM creates a temporary result set that the outer query can use.

This is called a **derived table**.

### Example: Find Departments Having Average Salary Greater Than 50000

First, calculate average salary for each department.

```sql
SELECT
    department,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department;
```

Now use this query inside FROM.

```sql
SELECT *
FROM (
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
) AS department_averages
WHERE average_salary > 50000;
```

### How Does It Work?

**Inner Query:**

```sql
SELECT
    department,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department;
```

Produces a temporary result:

| department | average_salary |
|---|---:|
| IT | 60000 |
| HR | 47500 |
| Finance | 55000 |

**Outer Query:**

```sql
SELECT *
FROM department_averages
WHERE average_salary > 50000;
```

Returns:

| department | average_salary |
|---|---:|
| IT | 60000 |
| Finance | 55000 |

### Important Rule

In MySQL, a derived table in FROM must have an alias.

Incorrect:

```sql
SELECT *
FROM (
    SELECT department
    FROM employees
);
```

Correct:

```sql
SELECT *
FROM (
    SELECT department
    FROM employees
) AS employee_departments;
```

---

# 10. Subqueries with HAVING

You can use subqueries inside HAVING to compare aggregated results against another calculated result.

### Example: Departments Having Above-Company-Average Salary

```sql
SELECT
    department,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM employees
);
```

This compares each department's average salary against the overall employee average.

### Example: Departments Having More Employees Than Average Department Size

```sql
SELECT
    department_id,
    COUNT(*) AS total_employees
FROM employees
GROUP BY department_id
HAVING COUNT(*) > (
    SELECT AVG(employee_count)
    FROM (
        SELECT COUNT(*) AS employee_count
        FROM employees
        GROUP BY department_id
    ) AS department_counts
);
```

This is a multi-level aggregation query.

---

# 11. IN Operator with Subqueries

The IN operator checks whether a value matches any value returned by a subquery.

### Syntax

```sql
SELECT columns
FROM table_name
WHERE column_name IN (
    SELECT column_name
    FROM another_table
);
```

### Example

Find employees belonging to departments located in Ahmedabad.

```sql
SELECT *
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE location = 'Ahmedabad'
);
```

### IN vs =

Using `=`:

```sql
WHERE department_id = (
    SELECT id
    FROM departments
    WHERE location = 'Ahmedabad'
);
```

This requires the subquery to return at most one row.

Using IN:

```sql
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE location = 'Ahmedabad'
);
```

This supports multiple returned rows.

### Important

IN is especially useful when the subquery returns multiple values.

---

# 12. NOT IN Operator with Subqueries

NOT IN returns records whose values do not match any value in the subquery result.

### Example: Find Employees Not Working in IT or HR

```sql
SELECT *
FROM employees
WHERE department_id NOT IN (
    SELECT id
    FROM departments
    WHERE department_name IN ('IT', 'HR')
);
```

### Important NULL Problem with NOT IN

This is a very important SQL concept.

Suppose the subquery returns:

```text
1
2
NULL
```

Now consider:

```sql
SELECT *
FROM employees
WHERE department_id NOT IN (
    SELECT department_id
    FROM some_table
);
```

If the subquery returns NULL, comparisons involving NOT IN can evaluate to UNKNOWN.

As a result, the query may return no rows unexpectedly.

### Safer Approach

Filter NULL values inside the subquery:

```sql
SELECT *
FROM employees
WHERE department_id NOT IN (
    SELECT department_id
    FROM some_table
    WHERE department_id IS NOT NULL
);
```

For finding records without a related record, `NOT EXISTS` is often a safer alternative.

---

# 13. EXISTS Operator

EXISTS checks whether a subquery returns at least one row.

It returns:

- TRUE if at least one row exists.
- FALSE if no rows exist.

### Syntax

```sql
SELECT columns
FROM table_name
WHERE EXISTS (
    SELECT 1
    FROM another_table
    WHERE condition
);
```

### Example: Find Customers Who Have Placed Orders

**customers**

| id | name |
|---:|---|
| 1 | John |
| 2 | Sarah |
| 3 | David |

**orders**

| id | customer_id | total_amount |
|---:|---:|---:|
| 101 | 1 | 5000 |
| 102 | 2 | 3000 |
| 103 | 1 | 7000 |

Query:

```sql
SELECT *
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
);
```

Output:

| id | name |
|---:|---|
| 1 | John |
| 2 | Sarah |

David is excluded because he has no orders.

### How Does EXISTS Work?

For each customer, the subquery checks whether a matching order exists.

Conceptually:

```text
John:
Matching order exists → TRUE

Sarah:
Matching order exists → TRUE

David:
No matching order → FALSE
```

Only customers for whom EXISTS is TRUE are returned.

### Why SELECT 1?

In EXISTS, the actual selected values are irrelevant.

These are equivalent for existence checking:

```sql
EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
)
```

```sql
EXISTS (
    SELECT *
    FROM orders o
    WHERE o.customer_id = c.id
)
```

`SELECT 1` communicates clearly that we only care about existence.

---

# 14. NOT EXISTS Operator

NOT EXISTS checks whether a subquery returns no rows.

It returns TRUE when no matching record exists.

### Example: Find Customers Without Orders

```sql
SELECT *
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
);
```

Output:

| id | name |
|---:|---|
| 3 | David |

### Example: Find Products Never Ordered

```sql
SELECT *
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.id
);
```

### Example: Find Departments Without Employees

```sql
SELECT *
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.id
);
```

### EXISTS vs NOT EXISTS

| EXISTS | NOT EXISTS |
|---|---|
| Checks whether matching rows exist | Checks whether matching rows do not exist |
| Returns TRUE when rows exist | Returns TRUE when no rows exist |
| Finds customers with orders | Finds customers without orders |

### Important Interview Point

EXISTS and NOT EXISTS are commonly used for checking relationships without returning columns from the related table.

MySQL may optimize EXISTS and NOT EXISTS using semijoin or antijoin strategies, depending on the query.

---

# 15. ANY Operator

ANY compares a value against the values returned by a subquery.

The condition becomes TRUE if the comparison is TRUE for at least one value.

### Syntax

```sql
SELECT columns
FROM table_name
WHERE column_name OPERATOR ANY (
    SELECT column_name
    FROM another_table
);
```

### Example

Suppose employee salaries are:

| id | name | salary |
|---:|---|---:|
| 1 | John | 30000 |
| 2 | Sarah | 45000 |
| 3 | David | 60000 |
| 4 | Alex | 70000 |

Find employees earning more than ANY salary in the HR department.

```sql
SELECT *
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees
    WHERE department = 'HR'
);
```

If HR salaries are:

```text
40000
50000
60000
```

Then:

```text
salary > ANY (40000, 50000, 60000)
```

means the salary must be greater than at least one of those values.

For non-NULL values, this is equivalent to:

```sql
salary > MIN(HR salaries)
```

### Important

ANY means at least one comparison must be TRUE.

---

# 16. ALL Operator

ALL compares a value against every value returned by a subquery.

The condition becomes TRUE only when the comparison is TRUE for all returned values.

### Example

Find employees earning more than ALL employees in the HR department.

```sql
SELECT *
FROM employees
WHERE salary > ALL (
    SELECT salary
    FROM employees
    WHERE department = 'HR'
);
```

If HR salaries are:

```text
40000
50000
60000
```

Then:

```text
salary > ALL (40000, 50000, 60000)
```

means the salary must be greater than every HR salary.

For non-NULL values, this is equivalent to:

```sql
salary > MAX(HR salaries)
```

### ANY vs ALL

| ANY | ALL |
|---|---|
| At least one comparison must be TRUE | Every comparison must be TRUE |
| Greater than ANY means greater than at least one value | Greater than ALL means greater than every value |
| Can be equivalent to comparison with MIN | Can be equivalent to comparison with MAX |

### Important NULL Behavior

If a comparison cannot be determined because of NULL values, ANY and ALL can produce UNKNOWN.

Also, when a subquery returns no rows:

- `ANY` evaluates to FALSE.
- `ALL` evaluates to TRUE.

This follows SQL's three-valued logic and is worth remembering for interviews.

---

# 17. Correlated Subqueries

A correlated subquery is a subquery that references a column from the outer query.

Unlike a simple independent subquery, it depends on the current row being processed by the outer query.

### Example: Find Employees Earning More Than Their Department Average

Consider:

| id | name | department | salary |
|---:|---|---|---:|
| 1 | John | IT | 50000 |
| 2 | Sarah | HR | 40000 |
| 3 | David | IT | 70000 |
| 4 | Alex | HR | 60000 |
| 5 | Mike | IT | 55000 |

### Query

```sql
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department = e.department
);
```

### Understanding the Query

Outer query:

```sql
SELECT *
FROM employees e;
```

Inner query:

```sql
SELECT AVG(salary)
FROM employees e2
WHERE e2.department = e.department;
```

Notice:

```sql
e2.department = e.department
```

The inner query references `e.department`, which belongs to the outer query.

That makes it a correlated subquery.

### Conceptual Execution

For John:

```text
Department = IT

IT Average:
(50000 + 70000 + 55000) / 3

= 58333.33

John Salary = 50000

50000 > 58333.33?
No
```

For David:

```text
Department = IT

IT Average = 58333.33

David Salary = 70000

70000 > 58333.33?
Yes
```

For Sarah:

```text
Department = HR

HR Average:
(40000 + 60000) / 2

= 50000

Sarah Salary = 40000

40000 > 50000?
No
```

### Output

| id | name | department | salary |
|---:|---|---|---:|
| 3 | David | IT | 70000 |
| 4 | Alex | HR | 60000 |

### Important

Conceptually, a correlated subquery depends on each outer row.

However, MySQL's optimizer may transform or optimize it. Do not assume that the database literally executes a completely separate physical query for every row.

---

# 18. Another Correlated Subquery Example

Find the number of employees in each department.

```sql
SELECT
    e.name,
    e.department,

    (
        SELECT COUNT(*)
        FROM employees e2
        WHERE e2.department = e.department
    ) AS department_employee_count

FROM employees e;
```

Output:

| name | department | department_employee_count |
|---|---|---:|
| John | IT | 3 |
| Sarah | HR | 2 |
| David | IT | 3 |
| Alex | HR | 2 |
| Mike | IT | 3 |

### Explanation

For every employee, the inner query counts employees belonging to the same department.

This is a classic correlated subquery.

---

# 19. Nested Subqueries

A nested subquery means a subquery inside another subquery.

You can use multiple levels of nested queries to solve complex problems.

### Example: Find Employees Working in the Department with the Highest Average Salary

```sql
SELECT *
FROM employees
WHERE department IN (
    SELECT department
    FROM employees
    GROUP BY department
    HAVING AVG(salary) = (
        SELECT MAX(department_average)
        FROM (
            SELECT AVG(salary) AS department_average
            FROM employees
            GROUP BY department
        ) AS department_averages
    )
);
```

### Understanding the Query

**Level 1:**

```sql
SELECT AVG(salary) AS department_average
FROM employees
GROUP BY department;
```

Calculates average salary for every department.

**Level 2:**

```sql
SELECT MAX(department_average)
FROM (...);
```

Finds the highest department average.

**Level 3:**

```sql
SELECT department
FROM employees
GROUP BY department
HAVING AVG(salary) = (...);
```

Finds the department or departments having that highest average.

**Outer Query:**

```sql
SELECT *
FROM employees
WHERE department IN (...);
```

Returns all employees belonging to those departments.

---

# 20. Subquery vs JOIN

Both subqueries and JOINs can solve many of the same problems.

However, their structures and intended uses differ.

### Example: Find Employees Working in IT

**Using JOIN**

```sql
SELECT
    e.*
FROM employees e
INNER JOIN departments d
    ON e.department_id = d.id
WHERE d.department_name = 'IT';
```

**Using Subquery**

```sql
SELECT *
FROM employees
WHERE department_id = (
    SELECT id
    FROM departments
    WHERE department_name = 'IT'
);
```

### Comparison

| Subquery | JOIN |
|---|---|
| Query inside another query | Combines related tables |
| Useful for intermediate calculations | Useful for retrieving related columns |
| Useful with IN, EXISTS, ANY and ALL | Useful for combining multiple tables |
| Can be easier to understand for some conditions | Often easier for multi-table reporting |

### Which Is Faster?

There is no universal rule.

MySQL can optimize many subqueries into joins or semijoins.

Performance depends on:

- Query structure.
- Indexes.
- Table sizes.
- Data distribution.
- Query execution plan.

Use:

```sql
EXPLAIN
SELECT *
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE location = 'Ahmedabad'
);
```

Compare it with an equivalent JOIN query when performance matters.

---

# 21. Subquery vs CTE

A CTE stands for Common Table Expression.

It allows you to define a named temporary result set using `WITH`.

We will study CTEs in detail in Phase 14.

For now, understand the difference.

### Using a Subquery

```sql
SELECT *
FROM (
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
) AS department_averages
WHERE average_salary > 50000;
```

### Using a CTE

```sql
WITH department_averages AS (
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
)

SELECT *
FROM department_averages
WHERE average_salary > 50000;
```

### Comparison

| Subquery | CTE |
|---|---|
| Written inside another query | Defined using WITH |
| Can become difficult to read when deeply nested | Often easier to read |
| Useful for localized intermediate calculations | Useful for named intermediate result sets |
| Can be nested | Can reference earlier CTEs in the same WITH clause |

**Important:** CTEs are not automatically faster than subqueries. Performance depends on the optimizer and query structure.

---

# 22. Common Subquery Mistakes

### Mistake 1: Using = with Multiple-Row Results

Incorrect:

```sql
SELECT *
FROM employees
WHERE department_id = (
    SELECT id
    FROM departments
    WHERE location = 'Ahmedabad'
);
```

If multiple departments exist in Ahmedabad, this fails.

Correct:

```sql
SELECT *
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE location = 'Ahmedabad'
);
```

### Mistake 2: NOT IN with NULL

Potentially problematic:

```sql
SELECT *
FROM employees
WHERE department_id NOT IN (
    SELECT department_id
    FROM departments
);
```

If the subquery contains NULL, the result can be unexpected.

Safer alternative:

```sql
SELECT *
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM departments d
    WHERE d.id = e.department_id
);
```

### Mistake 3: Forgetting Derived Table Alias

Incorrect:

```sql
SELECT *
FROM (
    SELECT department
    FROM employees
);
```

Correct:

```sql
SELECT *
FROM (
    SELECT department
    FROM employees
) AS employee_data;
```

### Mistake 4: Returning Multiple Columns in a Scalar Subquery

Incorrect:

```sql
SELECT *
FROM employees
WHERE salary = (
    SELECT id, salary
    FROM employees
);
```

A scalar expression expects one column and at most one row.

### Mistake 5: Writing Unnecessary Correlated Subqueries

A correlated subquery can be harder to optimize in some cases.

Compare it with a JOIN or a grouped derived table.

Choose the clearest query that meets the performance requirements.

---

# 23. Real-World Examples

## Example 1: Find Customers Who Have Placed Orders

```sql
SELECT *
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
);
```

## Example 2: Find Customers Without Orders

```sql
SELECT *
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
);
```

## Example 3: Find Products More Expensive Than Average Product Price

```sql
SELECT *
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);
```

## Example 4: Find Products Never Ordered

```sql
SELECT *
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.id
);
```

## Example 5: Find Customers Spending More Than Average Customer Spending

```sql
SELECT
    customer_id,
    SUM(total_amount) AS total_spending
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > (
    SELECT AVG(customer_spending)
    FROM (
        SELECT SUM(total_amount) AS customer_spending
        FROM orders
        GROUP BY customer_id
    ) AS customer_totals
);
```

## Example 6: Find Employees Earning More Than Their Department Average

```sql
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);
```

## Example 7: Find the Second-Highest Distinct Salary

```sql
SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
);
```

This finds the second-highest distinct salary.

If the highest salary occurs multiple times, those duplicate values are excluded before finding the next-highest value.

If there is no second distinct salary, the result is NULL.

---

# 24. Subquery Performance Best Practices

Subqueries are powerful, but poorly structured queries can become expensive.

Follow these practices:

### 1. Use Appropriate Indexes

For correlated queries:

```sql
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);
```

An index on `department_id` may help:

```sql
CREATE INDEX idx_employee_department
ON employees(department_id);
```

### 2. Prefer EXISTS for Existence Checks

Example:

```sql
SELECT *
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
);
```

EXISTS expresses the requirement directly.

It is not universally faster than IN or JOIN; the optimizer determines the execution strategy.

### 3. Avoid Unnecessary Nested Subqueries

Deeply nested queries can become difficult to maintain.

Consider using CTEs when you reach more complex query structures.

### 4. Avoid SELECT *

Retrieve only required columns.

### 5. Use EXPLAIN

```sql
EXPLAIN
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

Use execution plans to understand how MySQL processes the query.

### 6. Understand Correlated Subqueries

Correlated subqueries depend on outer-query values.

For large datasets, compare their execution plans with JOIN-based or grouped derived-table alternatives.

---

# 25. SQL Subqueries Interview Questions

## Beginner Level

**1. What is a subquery?**

A subquery is a SQL query written inside another SQL query.

**2. What is an inner query?**

The query inside another query is called the inner query or subquery.

**3. What is an outer query?**

The query containing the subquery is called the outer query.

**4. What is a scalar subquery?**

A subquery that returns exactly one column and one row.

**5. Can a subquery be used inside WHERE?**

Yes.

```sql
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

## Intermediate Level

**6. What is the difference between IN and EXISTS?**

IN checks whether a value matches a value in a result set. EXISTS checks whether a subquery returns at least one row.

**7. What is a correlated subquery?**

A subquery that references a column from the outer query.

**8. What is a derived table?**

A subquery used in the FROM clause that acts as a temporary table for the outer query.

**9. What happens when a scalar subquery returns multiple rows?**

MySQL generates an error.

**10. What is the difference between ANY and ALL?**

ANY requires at least one comparison to be TRUE. ALL requires every comparison to be TRUE.

## Advanced Level

**11. What is the difference between NOT IN and NOT EXISTS?**

NOT IN compares values against a result set and can behave unexpectedly when NULL is present. NOT EXISTS checks the absence of matching rows and is often safer for anti-match queries.

**12. Can we use subqueries inside SELECT?**

Yes, provided the subquery is valid in that expression context. A scalar subquery is commonly used.

**13. Can we use subqueries inside HAVING?**

Yes.

**14. What is the difference between correlated and non-correlated subqueries?**

A non-correlated subquery does not reference the outer query. A correlated subquery does.

**15. Can a subquery contain another subquery?**

Yes. This is called a nested subquery.

**16. Which is faster: JOIN or subquery?**

There is no universal answer. Performance depends on the query, indexes, data distribution, and execution plan.

**17. What is a semijoin?**

A semijoin returns rows from one side for which a matching row exists on the other side, without multiplying the outer rows by the number of matches. MySQL can use semijoin strategies to optimize certain IN and EXISTS queries.

---

# 26. Practical Assignments

Use the following tables for practice.

### employees

| id | name | department_id | salary |
|---:|---|---:|---:|
| 1 | John | 1 | 50000 |
| 2 | Sarah | 2 | 40000 |
| 3 | David | 1 | 70000 |
| 4 | Alex | 2 | 60000 |
| 5 | Mike | 3 | 55000 |
| 6 | Emma | 3 | 75000 |
| 7 | Olivia | 1 | 65000 |
| 8 | James | 2 | 35000 |

### departments

| id | department_name | location |
|---:|---|---|
| 1 | IT | Ahmedabad |
| 2 | HR | Mumbai |
| 3 | Finance | Delhi |
| 4 | Marketing | Ahmedabad |

### Assignment 1: Basic Subqueries

Write queries to:

1. Find employees earning more than the average salary.
2. Find employees earning less than the average salary.
3. Find employees having the highest salary.
4. Find employees having the lowest salary.
5. Find employees working in departments located in Ahmedabad.
6. Find employees not working in the IT department.
7. Find employees earning more than the salary of Sarah.
8. Find employees earning less than the salary of David.

### Assignment 2: IN and NOT IN

Write queries to:

1. Find employees working in IT or HR.
2. Find employees working outside Ahmedabad.
3. Find departments that have employees.
4. Find employees whose department IDs exist in the departments table.
5. Find departments that do not have employees.

### Assignment 3: EXISTS and NOT EXISTS

Create customers and orders tables.

Write queries to:

1. Find customers who have placed orders.
2. Find customers who have not placed orders.
3. Find products that have been ordered.
4. Find products that have never been ordered.
5. Find departments having employees.
6. Find departments without employees.

### Assignment 4: Correlated Subqueries

Write queries to:

1. Find employees earning more than their department average.
2. Find employees earning less than their department average.
3. Display employee names with department employee counts.
4. Find employees having the highest salary in their department.
5. Find employees having the lowest salary in their department.
6. Find employees earning more than their manager.

### Assignment 5: Advanced Subqueries

Write queries to:

1. Find the second-highest distinct salary.
2. Find the third-highest distinct salary.
3. Find departments having above-company-average salary.
4. Find departments having more employees than the average department size.
5. Find customers spending more than average customer spending.
6. Find the department with the highest average salary.
7. Find employees belonging to the department with the highest average salary.
8. Find products priced above the average price of their category.

---

# 27. Phase 11 Quick Revision Sheet

| Concept | Purpose |
|---|---|
| Subquery | Query inside another query |
| Single-row subquery | Returns one row |
| Scalar subquery | Returns one value |
| Multiple-row subquery | Returns multiple rows |
| IN | Checks membership in a result set |
| NOT IN | Checks non-membership; watch for NULL |
| EXISTS | Checks whether matching rows exist |
| NOT EXISTS | Checks whether matching rows do not exist |
| ANY | At least one comparison must be TRUE |
| ALL | Every comparison must be TRUE |
| Correlated subquery | References the outer query |
| Nested subquery | Subquery inside another subquery |
| Derived table | Subquery inside FROM |
| JOIN | Combines related tables |
| CTE | Named temporary result set using WITH |

### Important Differences

| Feature | EXISTS | IN |
|---|---|---|
| Purpose | Checks existence | Checks value membership |
| Returns | Boolean condition | Boolean condition |
| NULL considerations | Different behavior from NOT IN | NULL can affect comparisons |
| Common use | Related-row existence | Matching values |

| Feature | Correlated Subquery | Non-Correlated Subquery |
|---|---|---|
| References outer query | Yes | No |
| Depends on outer row | Yes | No |
| Common use | Per-row comparisons | Overall aggregate comparisons |

---

# 28. Phase 11 Completion Checklist

Before moving to Phase 12, make sure you can:

- [ ] Explain what subqueries are.
- [ ] Understand inner and outer queries.
- [ ] Write single-row subqueries.
- [ ] Write multiple-row subqueries.
- [ ] Understand scalar subqueries.
- [ ] Use subqueries with WHERE.
- [ ] Use subqueries with SELECT.
- [ ] Use subqueries with FROM.
- [ ] Use subqueries with HAVING.
- [ ] Use IN and NOT IN.
- [ ] Understand NULL problems with NOT IN.
- [ ] Use EXISTS and NOT EXISTS.
- [ ] Understand ANY and ALL.
- [ ] Write correlated subqueries.
- [ ] Write nested subqueries.
- [ ] Understand derived tables.
- [ ] Compare JOINs and subqueries.
- [ ] Compare subqueries and CTEs.
- [ ] Understand subquery performance.
- [ ] Solve real-world SQL problems using subqueries.

---

# Next Phase: Phase 12 – SQL Functions

In Phase 12, we will study built-in SQL functions that help manipulate strings, numbers, dates, NULL values, and data types.

Topics:

1. What Are SQL Functions?
2. Built-in Functions vs User-Defined Functions
3. String Functions
4. CONCAT()
5. CONCAT_WS()
6. LENGTH() and CHAR_LENGTH()
7. UPPER() and LOWER()
8. TRIM(), LTRIM(), RTRIM()
9. SUBSTRING()
10. REPLACE()
11. LOCATE() and INSTR()
12. LEFT() and RIGHT()
13. Numeric Functions
14. ROUND(), CEIL(), FLOOR()
15. ABS(), MOD(), POWER(), SQRT()
16. Date and Time Functions
17. NOW(), CURDATE(), CURTIME()
18. DATE(), TIME(), YEAR(), MONTH(), DAY()
19. DATEDIFF(), TIMESTAMPDIFF()
20. DATE_ADD() and DATE_SUB()
21. NULL Handling Functions
22. COALESCE(), IFNULL(), NULLIF()
23. Conditional Functions – IF() and CASE
24. Type Conversion Functions
25. CAST() and CONVERT()
26. JSON Functions
27. Practical Examples
28. Interview Questions
29. Assignments

**Phase 11 is complete.** Subqueries are especially important for solving complex SQL problems. Practice correlated subqueries and EXISTS/NOT EXISTS carefully before proceeding to Phase 12.