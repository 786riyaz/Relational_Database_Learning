# SQL Complete Learning Roadmap
# Phase 10 – SQL JOINS

**Database:** MySQL 8.0+  
**Level:** Beginner to Advanced  
**Goal:** Learn how to retrieve and combine data from multiple related tables using SQL JOINs.

SQL JOINs are among the most important concepts in relational database development.

In real-world applications, data is distributed across multiple tables to avoid duplication and maintain relationships.

For example, an e-commerce application might have separate tables for:

- Customers
- Products
- Categories
- Orders
- Order Items
- Payments

If you want to display an order with its customer details and purchased products, you need JOINs.

---

# 1. What Are SQL JOINS?

A JOIN combines rows from two or more tables based on a related column or a specified condition.

### Example

Suppose we have two tables.

**employees**

| id | name | department_id |
|---:|---|---:|
| 1 | John | 101 |
| 2 | Sarah | 102 |
| 3 | David | 101 |
| 4 | Alex | 103 |
| 5 | Mike | NULL |

**departments**

| id | department_name |
|---:|---|
| 101 | IT |
| 102 | HR |
| 103 | Finance |
| 104 | Marketing |

Here:

- `employees.department_id` references `departments.id`.
- One department can have multiple employees.
- An employee belongs to a department through `department_id`.

Suppose you want employee names along with their department names.

You could execute two separate queries and combine the results in JavaScript.

However, SQL JOINs allow you to do this directly.

### Example

```sql
SELECT
    employees.name,
    departments.department_name
FROM employees
INNER JOIN departments
    ON employees.department_id = departments.id;
```

### Output

| name | department_name |
|---|---|
| John | IT |
| Sarah | HR |
| David | IT |
| Alex | Finance |

Notice:

- Mike is excluded because his department_id is NULL.
- Marketing is excluded because it has no employees.

This is because we used INNER JOIN.

---

# 2. Why Do We Need JOINs?

Consider an employee management system.

Without proper database normalization, you might create one table:

**employees**

| id | name | department_name | department_location |
|---:|---|---|---|
| 1 | John | IT | Ahmedabad |
| 2 | Sarah | HR | Mumbai |
| 3 | David | IT | Ahmedabad |
| 4 | Alex | Finance | Delhi |

Notice that department information is repeated.

If the IT department location changes, you need to update multiple employee records.

This creates problems:

- Data duplication.
- Update anomalies.
- Inconsistent information.
- Difficult database maintenance.

Instead, create separate tables.

**employees**

| id | name | department_id |
|---:|---|---:|
| 1 | John | 101 |
| 2 | Sarah | 102 |
| 3 | David | 101 |
| 4 | Alex | 103 |

**departments**

| id | department_name | location |
|---:|---|---|
| 101 | IT | Ahmedabad |
| 102 | HR | Mumbai |
| 103 | Finance | Delhi |

Now you can retrieve the required information using JOINs.

**Important:** JOINs allow you to keep data organized across multiple tables while retrieving it together when needed.

---

# 3. Understanding Relationships Between Tables

Before learning different JOIN types, understand the common relationships between relational database tables.

## 3.1 One-to-One Relationship

One record in table A is associated with one record in table B.

Example:

**users**

| id | name |
|---:|---|
| 1 | John |
| 2 | Sarah |

**user_profiles**

| id | user_id | address |
|---:|---:|---|
| 1 | 1 | Ahmedabad |
| 2 | 2 | Mumbai |

Here, each user has one profile.

A foreign key with a UNIQUE constraint can enforce this relationship.

## 3.2 One-to-Many Relationship

One record in table A can be associated with multiple records in table B.

Example:

**departments**

| id | name |
|---:|---|
| 1 | IT |
| 2 | HR |

**employees**

| id | name | department_id |
|---:|---|---:|
| 101 | John | 1 |
| 102 | Sarah | 1 |
| 103 | David | 2 |

One department can have multiple employees.

This is one of the most common relationships in SQL.

## 3.3 Many-to-Many Relationship

Multiple records in table A can be associated with multiple records in table B.

Example:

- One student can enroll in multiple courses.
- One course can contain multiple students.

You generally implement this using a junction table.

**students**

| id | name |
|---:|---|
| 1 | John |
| 2 | Sarah |

**courses**

| id | course_name |
|---:|---|
| 101 | JavaScript |
| 102 | SQL |

**enrollments**

| student_id | course_id |
|---:|---:|
| 1 | 101 |
| 1 | 102 |
| 2 | 101 |

The enrollments table connects students and courses.

---

# 4. Types of SQL JOINS

The main JOIN types are:

| JOIN Type | Purpose |
|---|---|
| INNER JOIN | Returns matching records from both tables |
| LEFT JOIN | Returns all records from the left table and matching records from the right |
| RIGHT JOIN | Returns all records from the right table and matching records from the left |
| FULL OUTER JOIN | Returns matching and nonmatching records from both tables |
| CROSS JOIN | Returns every possible combination |
| SELF JOIN | Joins a table with itself |

**Important MySQL note:** MySQL does not directly support `FULL OUTER JOIN`. We will learn how to implement its equivalent using UNION.

Let's understand each JOIN with examples.

---

# 5. INNER JOIN

INNER JOIN returns only the records that have matching values in both tables.

### Syntax

```sql
SELECT columns
FROM table1
INNER JOIN table2
    ON table1.column = table2.column;
```

### Example Tables

**employees**

| id | name | department_id |
|---:|---|---:|
| 1 | John | 101 |
| 2 | Sarah | 102 |
| 3 | David | 101 |
| 4 | Alex | 103 |
| 5 | Mike | NULL |

**departments**

| id | department_name |
|---:|---|
| 101 | IT |
| 102 | HR |
| 103 | Finance |
| 104 | Marketing |

### Query

```sql
SELECT
    employees.id,
    employees.name,
    departments.department_name
FROM employees
INNER JOIN departments
    ON employees.department_id = departments.id;
```

### Output

| id | name | department_name |
|---:|---|---|
| 1 | John | IT |
| 2 | Sarah | HR |
| 3 | David | IT |
| 4 | Alex | Finance |

### How Does INNER JOIN Work?

MySQL compares:

```text
employees.department_id
```

with:

```text
departments.id
```

It returns rows where both values match.

Conceptually:

```text
101 = 101  → Match
102 = 102  → Match
101 = 101  → Match
103 = 103  → Match
NULL = ?   → No match
```

Marketing is excluded because no employee belongs to department `104`.

Mike is excluded because his department ID is NULL.

### INNER JOIN vs JOIN

These two queries are equivalent:

```sql
SELECT *
FROM employees
INNER JOIN departments
    ON employees.department_id = departments.id;
```

```sql
SELECT *
FROM employees
JOIN departments
    ON employees.department_id = departments.id;
```

`JOIN` without a modifier means `INNER JOIN` in MySQL.

### Using Table Aliases

Instead of writing full table names repeatedly, use aliases.

```sql
SELECT
    e.id,
    e.name,
    d.department_name
FROM employees AS e
INNER JOIN departments AS d
    ON e.department_id = d.id;
```

This is cleaner and commonly used in production SQL queries.

### When to Use INNER JOIN?

- Display employees with department names.
- Display orders with customer details.
- Display products with category names.
- Display students with their enrolled courses.
- Display payments associated with orders.

---

# 6. LEFT JOIN

LEFT JOIN returns:

1. Every record from the left table.
2. Matching records from the right table.
3. NULL values for right-table columns when no match exists.

### Syntax

```sql
SELECT columns
FROM table1
LEFT JOIN table2
    ON table1.column = table2.column;
```

### Example

Using the same tables:

**employees**

| id | name | department_id |
|---:|---|---:|
| 1 | John | 101 |
| 2 | Sarah | 102 |
| 3 | David | 101 |
| 4 | Alex | 103 |
| 5 | Mike | NULL |

**departments**

| id | department_name |
|---:|---|
| 101 | IT |
| 102 | HR |
| 103 | Finance |
| 104 | Marketing |

### Query

```sql
SELECT
    e.id,
    e.name,
    d.department_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.id;
```

### Output

| id | name | department_name |
|---:|---|---|
| 1 | John | IT |
| 2 | Sarah | HR |
| 3 | David | IT |
| 4 | Alex | Finance |
| 5 | Mike | NULL |

Notice that Mike is included even though he does not have a matching department.

Why?

Because LEFT JOIN preserves all rows from the left table.

### Important Concept

The left table is the table written before LEFT JOIN.

```sql
FROM employees e
LEFT JOIN departments d
```

Here:

- Left table: employees
- Right table: departments

All employee records are preserved.

### Example 2: Find All Departments and Their Employees

Now reverse the table order.

```sql
SELECT
    d.id,
    d.department_name,
    e.name
FROM departments d
LEFT JOIN employees e
    ON d.id = e.department_id;
```

Output:

| id | department_name | name |
|---:|---|---|
| 101 | IT | John |
| 101 | IT | David |
| 102 | HR | Sarah |
| 103 | Finance | Alex |
| 104 | Marketing | NULL |

Notice that Marketing appears even though it has no employees.

### When to Use LEFT JOIN?

- Find all customers, including those without orders.
- Find all departments, including those without employees.
- Find all products, including those never ordered.
- Find all users, including those without profiles.

---

# 7. RIGHT JOIN

RIGHT JOIN returns:

1. Every record from the right table.
2. Matching records from the left table.
3. NULL values for left-table columns when no match exists.

### Syntax

```sql
SELECT columns
FROM table1
RIGHT JOIN table2
    ON table1.column = table2.column;
```

### Example

```sql
SELECT
    e.id,
    e.name,
    d.department_name
FROM employees e
RIGHT JOIN departments d
    ON e.department_id = d.id;
```

### Output

| id | name | department_name |
|---:|---|---|
| 1 | John | IT |
| 3 | David | IT |
| 2 | Sarah | HR |
| 4 | Alex | Finance |
| NULL | NULL | Marketing |

Marketing is included even though it has no matching employee.

### LEFT JOIN vs RIGHT JOIN

| LEFT JOIN | RIGHT JOIN |
|---|---|
| Preserves all left-table rows | Preserves all right-table rows |
| Missing right values become NULL | Missing left values become NULL |
| Commonly used | Less commonly used |

### Important: RIGHT JOIN Can Be Rewritten as LEFT JOIN

These queries are logically equivalent:

```sql
SELECT
    e.id,
    e.name,
    d.department_name
FROM employees e
RIGHT JOIN departments d
    ON e.department_id = d.id;
```

```sql
SELECT
    e.id,
    e.name,
    d.department_name
FROM departments d
LEFT JOIN employees e
    ON d.id = e.department_id;
```

**Best practice:** Many developers prefer LEFT JOIN because it makes query structure easier to read consistently.

---

# 8. FULL OUTER JOIN

FULL OUTER JOIN returns:

- Matching records from both tables.
- Nonmatching records from the left table.
- Nonmatching records from the right table.

Unlike INNER JOIN, it does not discard unmatched records.

### Important MySQL Note

MySQL does not support FULL OUTER JOIN directly.

This syntax will not work in MySQL:

```sql
SELECT *
FROM employees
FULL OUTER JOIN departments
    ON employees.department_id = departments.id;
```

However, we can achieve equivalent results using LEFT JOIN, RIGHT JOIN, and UNION.

### Example Using UNION

```sql
SELECT
    e.id,
    e.name,
    d.department_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.id

UNION

SELECT
    e.id,
    e.name,
    d.department_name
FROM employees e
RIGHT JOIN departments d
    ON e.department_id = d.id;
```

### Output

| id | name | department_name |
|---:|---|---|
| 1 | John | IT |
| 2 | Sarah | HR |
| 3 | David | IT |
| 4 | Alex | Finance |
| 5 | Mike | NULL |
| NULL | NULL | Marketing |

This includes all employees and all departments.

### FULL OUTER JOIN Using LEFT JOIN + UNION ALL

You can also write:

```sql
SELECT
    e.id,
    e.name,
    d.department_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.id

UNION ALL

SELECT
    e.id,
    e.name,
    d.department_name
FROM employees e
RIGHT JOIN departments d
    ON e.department_id = d.id
WHERE e.id IS NULL;
```

Why use `UNION ALL` here?

- The LEFT JOIN already includes all matching records and unmatched employees.
- The second query adds only unmatched departments.
- Therefore, no duplicate elimination is needed.

This is often a more efficient way to emulate FULL OUTER JOIN.

**Important:** If your left-side key can be NULL, use a guaranteed non-NULL column such as a primary key for the unmatched-row check.

---

# 9. CROSS JOIN

CROSS JOIN returns every possible combination of rows from two tables.

This is called a Cartesian product.

### Syntax

```sql
SELECT columns
FROM table1
CROSS JOIN table2;
```

### Example

**colors**

| id | color |
|---:|---|
| 1 | Red |
| 2 | Blue |

**sizes**

| id | size |
|---:|---|
| 1 | Small |
| 2 | Medium |
| 3 | Large |

### Query

```sql
SELECT
    c.color,
    s.size
FROM colors c
CROSS JOIN sizes s;
```

### Output

| color | size |
|---|---|
| Red | Small |
| Red | Medium |
| Red | Large |
| Blue | Small |
| Blue | Medium |
| Blue | Large |

### How Many Rows?

Formula:

```text
Total Rows = Rows in Table A × Rows in Table B
```

Here:

```text
2 × 3 = 6
```

If table A contains 10 records and table B contains 20 records:

```text
10 × 20 = 200 rows
```

### Practical Use Cases

- Generate product variants.
- Generate combinations of dates and time slots.
- Create all possible color-size combinations.
- Generate test data.
- Build reporting dimensions.

### Important Warning

CROSS JOIN can produce a very large number of rows.

For example:

```text
10,000 × 20,000 = 200,000,000 rows
```

Use it only when you genuinely need all combinations.

---

# 10. SELF JOIN

A SELF JOIN means joining a table with itself.

It is useful when records in the same table are related to each other.

### Example: Employee and Manager Relationship

Consider:

**employees**

| id | name | manager_id |
|---:|---|---:|
| 1 | John | NULL |
| 2 | Sarah | 1 |
| 3 | David | 1 |
| 4 | Alex | 2 |
| 5 | Mike | 2 |

Here:

- John is a manager.
- Sarah and David report to John.
- Alex and Mike report to Sarah.

The manager relationship exists inside the same table.

### Requirement

Display employee names along with their manager names.

### Query

```sql
SELECT
    e.name AS employee_name,
    m.name AS manager_name
FROM employees e
LEFT JOIN employees m
    ON e.manager_id = m.id;
```

### Output

| employee_name | manager_name |
|---|---|
| John | NULL |
| Sarah | John |
| David | John |
| Alex | Sarah |
| Mike | Sarah |

### How Does It Work?

We use the same table twice:

```sql
employees e
```

Represents the employee.

```sql
employees m
```

Represents the manager.

The JOIN condition:

```sql
e.manager_id = m.id
```

matches each employee's manager ID with another employee's ID.

### Another Example: Find Employees Without Managers

```sql
SELECT
    e.id,
    e.name
FROM employees e
LEFT JOIN employees m
    ON e.manager_id = m.id
WHERE e.manager_id IS NULL;
```

Output:

| id | name |
|---:|---|
| 1 | John |

### Practical Use Cases

- Employee-manager hierarchy.
- Category-subcategory relationships.
- Parent-child records.
- Referral systems.
- Organizational structures.

---

# 11. Multiple Table JOINS

In real applications, you often need to combine more than two tables.

Let's understand this with an e-commerce database.

### Tables

**customers**

| id | name |
|---:|---|
| 1 | John |
| 2 | Sarah |
| 3 | David |

**orders**

| id | customer_id | order_date |
|---:|---:|---|
| 101 | 1 | 2026-01-10 |
| 102 | 2 | 2026-01-11 |
| 103 | 1 | 2026-01-15 |

**order_items**

| id | order_id | product_id | quantity |
|---:|---:|---:|---:|
| 1 | 101 | 201 | 2 |
| 2 | 101 | 202 | 1 |
| 3 | 102 | 203 | 3 |
| 4 | 103 | 201 | 1 |

**products**

| id | product_name | price |
|---:|---|---:|
| 201 | Laptop | 50000 |
| 202 | Mouse | 1000 |
| 203 | Keyboard | 2000 |

### Requirement

Display:

- Customer name.
- Order ID.
- Order date.
- Product name.
- Quantity.
- Product price.

### Query

```sql
SELECT
    c.name AS customer_name,
    o.id AS order_id,
    o.order_date,
    p.product_name,
    oi.quantity,
    p.price
FROM customers c

INNER JOIN orders o
    ON c.id = o.customer_id

INNER JOIN order_items oi
    ON o.id = oi.order_id

INNER JOIN products p
    ON oi.product_id = p.id;
```

### Output

| customer_name | order_id | order_date | product_name | quantity | price |
|---|---:|---|---|---:|---:|
| John | 101 | 2026-01-10 | Laptop | 2 | 50000 |
| John | 101 | 2026-01-10 | Mouse | 1 | 1000 |
| Sarah | 102 | 2026-01-11 | Keyboard | 3 | 2000 |
| John | 103 | 2026-01-15 | Laptop | 1 | 50000 |

### How Does It Work?

**Step 1:** Join customers with orders.

**Step 2:** Join the result with order_items.

**Step 3:** Join the result with products.

**Step 4:** Return the requested columns.

### Important Concept

You can join multiple tables in a single query.

There is no requirement that a query must contain only one JOIN.

---

# 12. JOIN with WHERE

You can combine JOINs with WHERE to filter the joined records.

### Example 1: Find IT Department Employees

```sql
SELECT
    e.name,
    d.department_name
FROM employees e
INNER JOIN departments d
    ON e.department_id = d.id
WHERE d.department_name = 'IT';
```

### Example 2: Find Orders After a Specific Date

```sql
SELECT
    c.name,
    o.id AS order_id,
    o.order_date
FROM customers c
INNER JOIN orders o
    ON c.id = o.customer_id
WHERE o.order_date >= '2026-01-01';
```

### Example 3: Find Products Whose Price Is Greater Than 10000

```sql
SELECT
    o.id AS order_id,
    p.product_name,
    p.price
FROM orders o
INNER JOIN order_items oi
    ON o.id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.id
WHERE p.price > 10000;
```

**Remember:** JOIN combines related data; WHERE filters the resulting rows.

---

# 13. JOIN with GROUP BY

JOIN and GROUP BY are frequently used together for reporting.

### Example 1: Total Orders Per Customer

```sql
SELECT
    c.id,
    c.name,
    COUNT(o.id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
GROUP BY c.id, c.name;
```

### Example 2: Total Revenue Per Customer

```sql
SELECT
    c.id,
    c.name,
    COALESCE(
        SUM(oi.quantity * p.price),
        0
    ) AS total_revenue
FROM customers c

LEFT JOIN orders o
    ON c.id = o.customer_id

LEFT JOIN order_items oi
    ON o.id = oi.order_id

LEFT JOIN products p
    ON oi.product_id = p.id

GROUP BY c.id, c.name;
```

### Example 3: Total Revenue Per Product

```sql
SELECT
    p.id,
    p.product_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM products p
INNER JOIN order_items oi
    ON p.id = oi.product_id
GROUP BY p.id, p.product_name;
```

### Example 4: Department-Wise Employee Count

```sql
SELECT
    d.department_name,
    COUNT(e.id) AS total_employees
FROM departments d
LEFT JOIN employees e
    ON d.id = e.department_id
GROUP BY d.id, d.department_name;
```

---

# 14. JOIN with HAVING

HAVING filters grouped results after JOIN and aggregation.

### Example: Customers with More Than Two Orders

```sql
SELECT
    c.id,
    c.name,
    COUNT(o.id) AS total_orders
FROM customers c
INNER JOIN orders o
    ON c.id = o.customer_id
GROUP BY c.id, c.name
HAVING COUNT(o.id) > 2;
```

### Example: Products Generating More Than 100000 Revenue

```sql
SELECT
    p.id,
    p.product_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM products p
INNER JOIN order_items oi
    ON p.id = oi.product_id
GROUP BY p.id, p.product_name
HAVING SUM(oi.quantity * p.price) > 100000;
```

### Example: Departments with Average Salary Above 50000

```sql
SELECT
    d.department_name,
    AVG(e.salary) AS average_salary
FROM departments d
INNER JOIN employees e
    ON d.id = e.department_id
GROUP BY d.id, d.department_name
HAVING AVG(e.salary) > 50000;
```

---

# 15. JOIN with Aggregate Functions

This section combines everything learned so far.

Consider an e-commerce application.

### Requirement 1: Total Orders and Spending Per Customer

```sql
SELECT
    c.id,
    c.name,
    COUNT(DISTINCT o.id) AS total_orders,
    COALESCE(SUM(oi.quantity * p.price), 0) AS total_spending
FROM customers c

LEFT JOIN orders o
    ON c.id = o.customer_id

LEFT JOIN order_items oi
    ON o.id = oi.order_id

LEFT JOIN products p
    ON oi.product_id = p.id

GROUP BY c.id, c.name;
```

### Why COUNT(DISTINCT o.id)?

One order can contain multiple order items.

For example:

| order_id | product |
|---:|---|
| 101 | Laptop |
| 101 | Mouse |
| 102 | Keyboard |

If we use:

```sql
COUNT(o.id)
```

Order `101` would be counted twice.

Using:

```sql
COUNT(DISTINCT o.id)
```

counts each order only once.

### Requirement 2: Top Five Customers by Spending

```sql
SELECT
    c.id,
    c.name,
    SUM(oi.quantity * p.price) AS total_spending
FROM customers c

INNER JOIN orders o
    ON c.id = o.customer_id

INNER JOIN order_items oi
    ON o.id = oi.order_id

INNER JOIN products p
    ON oi.product_id = p.id

GROUP BY c.id, c.name
ORDER BY total_spending DESC
LIMIT 5;
```

### Requirement 3: Average Order Value

First calculate the total amount for each order, then calculate the average across orders.

```sql
SELECT
    AVG(order_total) AS average_order_value
FROM (
    SELECT
        o.id,
        SUM(oi.quantity * p.price) AS order_total
    FROM orders o

    INNER JOIN order_items oi
        ON o.id = oi.order_id

    INNER JOIN products p
        ON oi.product_id = p.id

    GROUP BY o.id
) AS order_totals;
```

**Important:** Average order value means the average of order totals, not the average of individual product prices.

---

# 16. JOIN vs Subquery

Both JOINs and subqueries can be used to retrieve related data, but their structure and use cases differ.

### JOIN Example

Find employees working in the IT department.

```sql
SELECT
    e.name
FROM employees e
INNER JOIN departments d
    ON e.department_id = d.id
WHERE d.department_name = 'IT';
```

### Subquery Example

```sql
SELECT name
FROM employees
WHERE department_id = (
    SELECT id
    FROM departments
    WHERE department_name = 'IT'
);
```

Both queries can produce the same result when `department_name` is unique.

### Comparison

| JOIN | Subquery |
|---|---|
| Combines related tables | Uses one query inside another |
| Useful for retrieving columns from multiple tables | Useful for filtering or calculating intermediate results |
| Often convenient for multi-table reports | Often convenient for existence and scalar comparisons |
| Can produce multiple rows per parent when relationships are one-to-many | Depends on the subquery result and operator |

### Which Is Faster?

There is no universal answer.

MySQL's optimizer can transform many subqueries and joins into similar execution plans.

Performance depends on:

- Query structure.
- Indexes.
- Table sizes.
- Data distribution.
- JOIN cardinality.
- Execution plan.

Use `EXPLAIN` to compare actual query plans.

---

# 17. UNION vs JOIN

JOIN and UNION are different operations.

This is a common interview question.

### JOIN

JOIN combines columns from related tables.

Example:

```sql
SELECT
    e.name,
    d.department_name
FROM employees e
INNER JOIN departments d
    ON e.department_id = d.id;
```

The result contains columns from both tables.

### UNION

UNION combines the result rows of multiple SELECT queries vertically.

Example:

```sql
SELECT name
FROM employees

UNION

SELECT department_name
FROM departments;
```

The result contains values from both queries in one column.

### Comparison

| JOIN | UNION |
|---|---|
| Combines columns horizontally | Combines rows vertically |
| Usually connects related tables | Combines compatible SELECT results |
| Uses ON conditions for matching | Does not require matching keys |
| Can return multiple columns from different tables | Each SELECT must return the same number of columns |
| Can create duplicate rows depending on relationships | UNION removes duplicate result rows |

### UNION ALL

UNION removes duplicate rows.

UNION ALL preserves duplicates.

```sql
SELECT name FROM employees

UNION ALL

SELECT department_name FROM departments;
```

**Important:** The corresponding columns must have compatible data types.

---

# 18. Common JOIN Mistakes

### Mistake 1: Forgetting the ON Condition

Incorrect:

```sql
SELECT *
FROM employees
JOIN departments;
```

This can result in a Cartesian product.

Correct:

```sql
SELECT *
FROM employees e
JOIN departments d
    ON e.department_id = d.id;
```

### Mistake 2: Using the Wrong JOIN Type

Suppose you need all customers, including customers without orders.

Incorrect:

```sql
SELECT
    c.name,
    o.id
FROM customers c
INNER JOIN orders o
    ON c.id = o.customer_id;
```

Correct:

```sql
SELECT
    c.name,
    o.id
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id;
```

### Mistake 3: Turning LEFT JOIN into INNER JOIN Accidentally

Consider:

```sql
SELECT
    d.department_name,
    e.name
FROM departments d
LEFT JOIN employees e
    ON d.id = e.department_id
WHERE e.salary > 50000;
```

This removes departments without employees because `e.salary > 50000` evaluates to UNKNOWN for their NULL values.

If you want to preserve all departments while matching only employees earning more than 50000, put the condition in ON:

```sql
SELECT
    d.department_name,
    e.name
FROM departments d
LEFT JOIN employees e
    ON d.id = e.department_id
    AND e.salary > 50000;
```

### Mistake 4: Using COUNT(*) with LEFT JOIN

Incorrect:

```sql
SELECT
    d.department_name,
    COUNT(*) AS total_employees
FROM departments d
LEFT JOIN employees e
    ON d.id = e.department_id
GROUP BY d.id, d.department_name;
```

Correct:

```sql
SELECT
    d.department_name,
    COUNT(e.id) AS total_employees
FROM departments d
LEFT JOIN employees e
    ON d.id = e.department_id
GROUP BY d.id, d.department_name;
```

### Mistake 5: Duplicate Aggregation Results

Suppose one employee has multiple projects.

Joining employees to projects duplicates employee rows.

If you calculate:

```sql
SUM(e.salary)
```

after that JOIN, salary may be counted multiple times.

Possible solutions:

- Aggregate projects before joining.
- Aggregate employee salaries separately.
- Use a suitable subquery or CTE.
- Understand the relationship cardinality before aggregating.

**Important:** `SUM(DISTINCT e.salary)` is not a general solution because two different employees may legitimately have the same salary.

---

# 19. JOIN Performance and Indexing

JOIN performance is strongly influenced by indexes and the query execution plan.

### 1. Index Foreign Key Columns

Example:

```sql
CREATE INDEX idx_employee_department
ON employees(department_id);
```

MySQL InnoDB generally creates a suitable index automatically for a foreign key if one does not already exist.

However, explicitly checking your indexes is good practice.

### 2. Index Columns Used in JOIN Conditions

Example:

```sql
SELECT
    e.name,
    d.department_name
FROM employees e
INNER JOIN departments d
    ON e.department_id = d.id;
```

Useful indexes include:

- `employees.department_id`
- `departments.id`

The referenced `departments.id` is normally already indexed as a primary key.

### 3. Select Only Required Columns

Avoid:

```sql
SELECT *
FROM employees e
JOIN departments d
    ON e.department_id = d.id;
```

Prefer:

```sql
SELECT
    e.name,
    d.department_name
FROM employees e
JOIN departments d
    ON e.department_id = d.id;
```

### 4. Use EXPLAIN

```sql
EXPLAIN
SELECT
    e.name,
    d.department_name
FROM employees e
INNER JOIN departments d
    ON e.department_id = d.id;
```

EXPLAIN helps you inspect:

- Access type.
- Possible indexes.
- Selected index.
- Estimated rows.
- Join order.

### 5. Understand JOIN Cardinality

Before joining tables, understand whether the relationship is:

- One-to-one.
- One-to-many.
- Many-to-many.

This prevents unexpected duplicate rows.

---

# 20. Real-World E-commerce JOIN Example

Let's build a simplified e-commerce database.

## Step 1: Create Database

```sql
CREATE DATABASE ecommerce_db;

USE ecommerce_db;
```

## Step 2: Create Customers

```sql
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
);
```

## Step 3: Create Categories

```sql
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);
```

## Step 4: Create Products

```sql
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category_id INT,

    FOREIGN KEY (category_id)
        REFERENCES categories(id)
);
```

## Step 5: Create Orders

```sql
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(30) DEFAULT 'Pending',

    FOREIGN KEY (customer_id)
        REFERENCES customers(id)
);
```

## Step 6: Create Order Items

```sql
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(id),

    FOREIGN KEY (product_id)
        REFERENCES products(id)
);
```

Notice that `unit_price` is stored in order_items.

Why?

Because product prices can change over time, but historical order prices should remain unchanged.

## Step 7: Insert Sample Data

```sql
INSERT INTO customers (name, email)
VALUES
('John', 'john@example.com'),
('Sarah', 'sarah@example.com'),
('David', 'david@example.com');

INSERT INTO categories (category_name)
VALUES
('Electronics'),
('Accessories'),
('Furniture');

INSERT INTO products (product_name, price, category_id)
VALUES
('Laptop', 50000, 1),
('Mouse', 1000, 2),
('Keyboard', 2000, 2),
('Chair', 5000, 3);

INSERT INTO orders (customer_id, order_date, status)
VALUES
(1, '2026-01-10', 'Completed'),
(2, '2026-01-11', 'Completed'),
(1, '2026-01-15', 'Pending');

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 50000),
(1, 2, 2, 1000),
(2, 3, 1, 2000),
(3, 4, 2, 5000);
```

## Step 8: Display Complete Order Details

```sql
SELECT
    o.id AS order_id,
    c.name AS customer_name,
    o.order_date,
    o.status,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS item_total
FROM orders o

INNER JOIN customers c
    ON o.customer_id = c.id

INNER JOIN order_items oi
    ON o.id = oi.order_id

INNER JOIN products p
    ON oi.product_id = p.id

ORDER BY o.id;
```

## Step 9: Calculate Total Amount Per Order

```sql
SELECT
    o.id AS order_id,
    c.name AS customer_name,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o

INNER JOIN customers c
    ON o.customer_id = c.id

INNER JOIN order_items oi
    ON o.id = oi.order_id

GROUP BY o.id, c.name;
```

## Step 10: Find Total Spending Per Customer

```sql
SELECT
    c.id,
    c.name,
    COALESCE(
        SUM(oi.quantity * oi.unit_price),
        0
    ) AS total_spending
FROM customers c

LEFT JOIN orders o
    ON c.id = o.customer_id

LEFT JOIN order_items oi
    ON o.id = oi.order_id

GROUP BY c.id, c.name;
```

## Step 11: Find Customers Without Orders

```sql
SELECT
    c.id,
    c.name
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
WHERE o.id IS NULL;
```

## Step 12: Find Products That Have Never Been Ordered

```sql
SELECT
    p.id,
    p.product_name
FROM products p
LEFT JOIN order_items oi
    ON p.id = oi.product_id
WHERE oi.id IS NULL;
```

## Step 13: Find Category-Wise Revenue

```sql
SELECT
    c.category_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM categories c

INNER JOIN products p
    ON c.id = p.category_id

INNER JOIN order_items oi
    ON p.id = oi.product_id

GROUP BY c.id, c.category_name;
```

This is a practical example of JOINs used in backend applications.

---

# 21. SQL JOIN Interview Questions

## Beginner Level

**1. What is a JOIN in SQL?**

JOIN combines rows from two or more tables based on a related column or condition.

**2. What are the different types of JOINs?**

- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- FULL OUTER JOIN
- CROSS JOIN
- SELF JOIN

**3. What is INNER JOIN?**

It returns only matching records from both tables.

**4. What is LEFT JOIN?**

It returns all rows from the left table and matching rows from the right table. Missing right-side values become NULL.

**5. What is RIGHT JOIN?**

It returns all rows from the right table and matching rows from the left table.

**6. Does MySQL support FULL OUTER JOIN?**

No. It can be emulated using LEFT JOIN and RIGHT JOIN combined with UNION or UNION ALL.

## Intermediate Level

**7. What is CROSS JOIN?**

It produces the Cartesian product of two tables.

**8. What is SELF JOIN?**

It joins a table with itself using table aliases.

**9. Can we JOIN more than two tables?**

Yes. You can join multiple tables in a single query.

**10. What is the difference between INNER JOIN and LEFT JOIN?**

INNER JOIN returns only matching records. LEFT JOIN preserves all rows from the left table, including those without a match.

**11. What is the difference between JOIN and UNION?**

JOIN combines columns horizontally. UNION combines result rows vertically.

**12. Why do we use table aliases?**

Aliases make queries shorter, easier to read, and help distinguish multiple references to the same table.

## Advanced Level

**13. Can we use GROUP BY with JOIN?**

Yes. It is frequently used to aggregate data across related tables.

**14. What happens when a JOIN produces duplicate rows?**

Rows can multiply based on relationship cardinality. Aggregates such as SUM and COUNT may become inflated.

**15. How can we find records that do not have matching records in another table?**

Use LEFT JOIN with an IS NULL condition on a non-NULL key from the right table.

```sql
SELECT c.*
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
WHERE o.id IS NULL;
```

**16. What is the difference between a condition in ON and WHERE for LEFT JOIN?**

A condition in ON controls which right-side records match while preserving left-side rows.

A condition in WHERE filters the resulting rows and can eliminate unmatched left-side records.

**17. How can we improve JOIN performance?**

- Use appropriate indexes.
- Join on compatible data types.
- Filter unnecessary rows.
- Avoid unnecessary columns.
- Understand relationship cardinality.
- Inspect execution plans using EXPLAIN.

**18. What is a Cartesian product?**

It is the result of combining every row from one table with every row from another table.

**19. Why is COUNT(e.id) preferred over COUNT(*) with LEFT JOIN?**

Because COUNT(e.id) ignores NULL values for unmatched child records, while COUNT(*) counts the unmatched joined row.

**20. Can we use the same table twice in a query?**

Yes. This is commonly done using SELF JOIN with different aliases.

---

# 22. Practical Assignments

Complete these assignments yourself using MySQL.

## Assignment 1: Employee Management System

Create two tables:

**departments**

- id
- department_name

**employees**

- id
- name
- salary
- department_id

Write queries to:

1. Display employees with their department names using INNER JOIN.
2. Display all employees, including those without departments.
3. Display all departments, including departments without employees.
4. Find employees who do not belong to any department.
5. Find departments that do not have employees.
6. Find total salary per department.
7. Find employee count per department.
8. Find departments having more than three employees.
9. Find the department with the highest total salary.
10. Display employees earning more than their department's average salary.

## Assignment 2: Student Course Management System

Create:

- students
- courses
- enrollments

Write queries to:

1. Display students with their enrolled courses.
2. Display all students, including students who have not enrolled in any course.
3. Display all courses, including courses without students.
4. Find students enrolled in more than two courses.
5. Find the number of students per course.
6. Find courses having more than five students.
7. Find students who have not enrolled in any course.
8. Find courses that have no enrolled students.

## Assignment 3: E-commerce Management System

Create:

- customers
- products
- categories
- orders
- order_items

Write queries to:

1. Display order details with customer information.
2. Display orders with product names and quantities.
3. Find total spending per customer.
4. Find total revenue per product.
5. Find category-wise revenue.
6. Find the top five customers by spending.
7. Find customers without orders.
8. Find products that have never been ordered.
9. Find customers having more than five orders.
10. Find monthly revenue.
11. Find the highest-value order.
12. Find products with total sales quantity greater than 100.

## Assignment 4: SELF JOIN

Create an employees table containing:

- id
- name
- manager_id

Write queries to:

1. Display employees with manager names.
2. Find employees without managers.
3. Find employees reporting to a specific manager.
4. Find the number of direct reports for each manager.
5. Display employee-manager pairs.

---

# 23. Phase 10 Quick Revision Sheet

| JOIN Type | What It Returns |
|---|---|
| INNER JOIN | Matching rows from both tables |
| LEFT JOIN | All left rows + matching right rows |
| RIGHT JOIN | All right rows + matching left rows |
| FULL OUTER JOIN | All rows from both tables, matched where possible |
| CROSS JOIN | Every possible combination |
| SELF JOIN | A table joined with itself |

### Important SQL Patterns

**Find matching records:**

```sql
SELECT *
FROM table_a a
INNER JOIN table_b b
    ON a.id = b.a_id;
```

**Find all records from the left table:**

```sql
SELECT *
FROM table_a a
LEFT JOIN table_b b
    ON a.id = b.a_id;
```

**Find records without a match:**

```sql
SELECT a.*
FROM table_a a
LEFT JOIN table_b b
    ON a.id = b.a_id
WHERE b.id IS NULL;
```

**Join multiple tables:**

```sql
SELECT *
FROM table_a a
JOIN table_b b
    ON a.id = b.a_id
JOIN table_c c
    ON b.id = c.b_id;
```

**Self JOIN:**

```sql
SELECT
    e.name AS employee,
    m.name AS manager
FROM employees e
LEFT JOIN employees m
    ON e.manager_id = m.id;
```

---

# 24. Phase 10 Completion Checklist

Before moving to Phase 11, make sure you can:

- [ ] Explain what SQL JOINs are.
- [ ] Understand one-to-one relationships.
- [ ] Understand one-to-many relationships.
- [ ] Understand many-to-many relationships.
- [ ] Write INNER JOIN queries.
- [ ] Write LEFT JOIN queries.
- [ ] Write RIGHT JOIN queries.
- [ ] Emulate FULL OUTER JOIN in MySQL.
- [ ] Understand CROSS JOIN.
- [ ] Write SELF JOIN queries.
- [ ] Join three or more tables.
- [ ] Combine JOIN with WHERE.
- [ ] Combine JOIN with GROUP BY.
- [ ] Combine JOIN with HAVING.
- [ ] Use aggregate functions with JOIN.
- [ ] Understand JOIN vs Subquery.
- [ ] Understand JOIN vs UNION.
- [ ] Identify and prevent duplicate aggregation.
- [ ] Understand JOIN performance and indexing.
- [ ] Build multi-table queries for an e-commerce database.

---

# Next Phase: Phase 11 – SQL Subqueries

Subqueries are another essential SQL concept. They allow you to write queries inside other queries and solve complex database problems.

Topics:

1. What Are Subqueries?
2. Why Do We Need Subqueries?
3. Single-Row Subqueries
4. Multiple-Row Subqueries
5. Scalar Subqueries
6. Column Subqueries
7. Table Subqueries
8. Subqueries with WHERE
9. Subqueries with SELECT
10. Subqueries with FROM
11. Subqueries with HAVING
12. Subqueries with IN
13. Subqueries with NOT IN
14. Subqueries with EXISTS
15. Subqueries with NOT EXISTS
16. ANY and ALL Operators
17. Correlated Subqueries
18. Nested Subqueries
19. Subquery vs JOIN
20. Subquery vs CTE
21. Performance Optimization
22. Real-World Examples
23. Interview Questions
24. Practical Assignments

**Phase 10 is complete.** SQL JOINs are essential for relational database development. Make sure you practice joining three or more tables before proceeding to Phase 11.