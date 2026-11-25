# SQL Complete Learning Roadmap – Phase 23
# Views and Temporary Tables

In this phase, we will learn two important database objects:

1. **Views**
2. **Temporary Tables**

Both help organize and simplify SQL queries, but they work differently.

For example, imagine you have an e-commerce database containing:

- Customers
- Products
- Orders
- Order Items
- Payments

Whenever you want to generate an order report, you might need to write a query involving multiple JOINs.

Instead of writing that complex query repeatedly, you can create a **VIEW**.

Similarly, if you need to store intermediate query results temporarily while processing a report, you can use a **TEMPORARY TABLE**.

Let's understand both in detail.

---

# 1. What Is a View?

A view is a virtual table created using a SELECT query.

It does not normally store its own copy of the underlying data. Instead, it stores the query definition.

Whenever you query the view, MySQL retrieves the data from the underlying tables.

### Example

Suppose you have an `employees` table.

| id | name | department | salary |
|---|---|---|---:|
| 1 | Rahul | IT | 50000 |
| 2 | Amit | HR | 40000 |
| 3 | Vijay | IT | 60000 |
| 4 | Karan | Sales | 35000 |

Suppose you frequently need employees from the IT department.

Normally, you execute:

```sql
SELECT id, name, salary
FROM employees
WHERE department = 'IT';
```

Instead, create a view:

```sql
CREATE VIEW it_employees AS
SELECT id, name, salary
FROM employees
WHERE department = 'IT';
```

Now you can execute:

```sql
SELECT *
FROM it_employees;
```

Output:

| id | name | salary |
|---|---|---:|
| 1 | Rahul | 50000 |
| 3 | Vijay | 60000 |

The view behaves like a virtual table.

### Important

A regular MySQL view stores the SELECT definition, not a separate copy of the result rows.

---

# 2. Creating a View

### Syntax

```sql
CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
WHERE condition;
```

### Example

```sql
CREATE VIEW high_salary_employees AS
SELECT id, name, department, salary
FROM employees
WHERE salary >= 50000;
```

Execute:

```sql
SELECT *
FROM high_salary_employees;
```

You can also filter the view:

```sql
SELECT *
FROM high_salary_employees
WHERE department = 'IT';
```

You can sort it:

```sql
SELECT *
FROM high_salary_employees
ORDER BY salary DESC;
```

You can select specific columns:

```sql
SELECT name, salary
FROM high_salary_employees;
```

**Remember:** You can use a view in many places where a regular table can be used in a SELECT query.

---

# 3. Creating a View Using Multiple Tables

Views become especially useful when you need to simplify complex JOIN queries.

Suppose you have these tables:

### customers

| id | name | email |
|---|---|---|
| 1 | Rahul | rahul@gmail.com |
| 2 | Amit | amit@gmail.com |

### orders

| id | customer_id | total_amount |
|---|---|---:|
| 101 | 1 | 5000 |
| 102 | 1 | 3000 |
| 103 | 2 | 7000 |

Normally, to retrieve customer order details:

```sql
SELECT
    o.id AS order_id,
    c.name AS customer_name,
    c.email,
    o.total_amount
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.id;
```

You can create a view:

```sql
CREATE VIEW customer_order_details AS
SELECT
    o.id AS order_id,
    c.id AS customer_id,
    c.name AS customer_name,
    c.email,
    o.total_amount
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.id;
```

Now simply execute:

```sql
SELECT *
FROM customer_order_details;
```

Output:

| order_id | customer_id | customer_name | email | total_amount |
|---|---|---|---|---:|
| 101 | 1 | Rahul | rahul@gmail.com | 5000 |
| 102 | 1 | Rahul | rahul@gmail.com | 3000 |
| 103 | 2 | Amit | amit@gmail.com | 7000 |

You do not need to rewrite the JOIN every time.

---

# 4. Creating a View with Aggregate Functions

Views can also contain aggregate functions and GROUP BY clauses.

### Example: Department Salary Report

```sql
CREATE VIEW department_salary_report AS
SELECT
    department,
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary,
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM employees
GROUP BY department;
```

Execute:

```sql
SELECT *
FROM department_salary_report;
```

Output:

| department | total_employees | average_salary | highest_salary | lowest_salary |
|---|---:|---:|---:|---:|
| IT | 2 | 55000 | 60000 | 50000 |
| HR | 1 | 40000 | 40000 | 40000 |
| Sales | 1 | 35000 | 35000 | 35000 |

This view can be reused in reporting applications.

---

# 5. Updating an Existing View

Suppose you already created a view:

```sql
CREATE VIEW it_employees AS
SELECT id, name, salary
FROM employees
WHERE department = 'IT';
```

Now you want to add the email column.

You can use `CREATE OR REPLACE VIEW`.

```sql
CREATE OR REPLACE VIEW it_employees AS
SELECT
    id,
    name,
    email,
    salary
FROM employees
WHERE department = 'IT';
```

This replaces the existing view definition.

### Alternative: ALTER VIEW

```sql
ALTER VIEW it_employees AS
SELECT
    id,
    name,
    email,
    salary
FROM employees
WHERE department = 'IT';
```

Both can modify a view definition.

---

# 6. Dropping a View

To delete a view:

```sql
DROP VIEW it_employees;
```

Safer:

```sql
DROP VIEW IF EXISTS it_employees;
```

### Important

Dropping a view does not delete the underlying tables or their data.

For example:

```sql
DROP VIEW IF EXISTS customer_order_details;
```

This removes only the view definition.

The `customers` and `orders` tables remain unchanged.

---

# 7. Viewing and Inspecting Views

### Show All Views

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

### View Definition

```sql
SHOW CREATE VIEW customer_order_details;
```

### View Information Through INFORMATION_SCHEMA

```sql
SELECT
    TABLE_NAME,
    VIEW_DEFINITION
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = DATABASE();
```

This displays view names and their definitions in the current database.

---

# 8. Can We INSERT, UPDATE and DELETE Through Views?

Yes, under certain conditions.

Some views are updatable, meaning you can modify the underlying table through the view.

However, not every view is updatable.

Let's understand.

## 8.1 Updating Through a View

Suppose you have this view:

```sql
CREATE VIEW it_employees AS
SELECT
    id,
    name,
    salary,
    department
FROM employees
WHERE department = 'IT';
```

Now execute:

```sql
UPDATE it_employees
SET salary = 70000
WHERE id = 1;
```

MySQL updates the corresponding row in the original `employees` table.

Verify:

```sql
SELECT *
FROM employees
WHERE id = 1;
```

The salary will now be 70000.

## 8.2 Inserting Through a View

```sql
INSERT INTO it_employees (
    id,
    name,
    salary,
    department
)
VALUES (
    10,
    'Karan',
    55000,
    'IT'
);
```

This inserts a row into the underlying `employees` table.

## 8.3 Deleting Through a View

```sql
DELETE FROM it_employees
WHERE id = 10;
```

This deletes the corresponding row from the underlying table.

### Important

A view is generally updatable when MySQL can map each view row to a single underlying table row.

Views involving features such as these are generally not updatable:

- Aggregate functions
- GROUP BY
- DISTINCT
- UNION
- Window functions
- Certain joins and derived tables
- Subqueries in the SELECT list or WHERE clause

For complex views, check the MySQL documentation or test the intended operation.

---

# 9. WITH CHECK OPTION

This is an important view concept.

Suppose you have a view that displays only IT employees.

```sql
CREATE VIEW it_employees AS
SELECT *
FROM employees
WHERE department = 'IT';
```

Now consider:

```sql
UPDATE it_employees
SET department = 'HR'
WHERE id = 1;
```

The underlying employee row is changed to HR.

After the update, that employee disappears from the IT view.

If you want to prevent updates that cause rows to stop satisfying the view condition, use `WITH CHECK OPTION`.

### Example

```sql
CREATE OR REPLACE VIEW it_employees AS
SELECT *
FROM employees
WHERE department = 'IT'
WITH CHECK OPTION;
```

Now try:

```sql
UPDATE it_employees
SET department = 'HR'
WHERE id = 1;
```

MySQL rejects the operation because the updated row no longer satisfies the view condition.

### Why Is It Useful?

It maintains the logical condition of an updatable view.

For example:

- An HR view should contain only HR employees.
- An IT view should contain only IT employees.
- An active-products view should contain only active products.

### LOCAL vs CASCADED CHECK OPTION

MySQL supports:

```sql
WITH LOCAL CHECK OPTION
```

and:

```sql
WITH CASCADED CHECK OPTION
```

- **LOCAL:** Checks the condition of the current view.
- **CASCADED:** Checks the current view and underlying views in its definition that have applicable conditions.

If no option is specified, MySQL uses CASCADED behavior.

---

# 10. Views and Security

Views are useful for controlling which data users can access.

Suppose your employee table contains:

| id | name | email | salary |
|---|---|---|---:|
| 1 | Rahul | rahul@gmail.com | 50000 |
| 2 | Amit | amit@gmail.com | 60000 |

You want to allow a user to view employee details but not salaries.

Create a view:

```sql
CREATE VIEW public_employee_details AS
SELECT
    id,
    name,
    email
FROM employees;
```

Grant permission:

```sql
GRANT SELECT
ON company_db.public_employee_details
TO 'report_user'@'localhost';
```

Now the user can query the view without being granted direct SELECT access to the underlying salary data.

**Important:** View security depends on its `SQL SECURITY` setting and the privileges of the definer or invoker. You should also ensure users do not have alternative permissions that expose the restricted columns.

---

# 11. Types of Views

There are two common conceptual categories.

### 1. Simple View

A simple view generally uses one table and does not contain complex operations.

Example:

```sql
CREATE VIEW employee_basic_details AS
SELECT id, name, department
FROM employees;
```

### 2. Complex View

A complex view can contain:

- Multiple tables
- JOINs
- Aggregate functions
- GROUP BY
- Subqueries

Example:

```sql
CREATE VIEW department_employee_summary AS
SELECT
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department;
```

**Note:** Simple and complex views are conceptual categories, not separate MySQL object types.

---

# 12. What Is a Temporary Table?

A temporary table is a table that exists temporarily within a database session.

Unlike a normal table, a temporary table is automatically removed when the session ends.

You can create it using:

```sql
CREATE TEMPORARY TABLE table_name (
    column1 datatype,
    column2 datatype
);
```

### Example

```sql
CREATE TEMPORARY TABLE temp_employees (
    id INT,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);
```

Insert records:

```sql
INSERT INTO temp_employees
VALUES
(1, 'Rahul', 50000),
(2, 'Amit', 60000);
```

Retrieve records:

```sql
SELECT *
FROM temp_employees;
```

Output:

| id | name | salary |
|---|---|---:|
| 1 | Rahul | 50000 |
| 2 | Amit | 60000 |

The temporary table is available only within the current database session.

---

# 13. Important Characteristics of Temporary Tables

| Feature | Temporary Table |
|---|---|
| Lifetime | Current database session |
| Automatically deleted | When the session ends |
| Can be manually deleted | Yes |
| Can contain indexes | Yes |
| Can contain primary keys | Yes |
| Can be modified | Yes |
| Visible to other sessions | No |
| Can have same name as permanent table | Yes, within the same database |
| Stores data | Yes, temporarily |

### Important

Two different MySQL sessions can create temporary tables with the same name without conflicting with each other.

For example:

**Session A:**

```sql
CREATE TEMPORARY TABLE temp_data (
    id INT,
    name VARCHAR(100)
);
```

**Session B:**

```sql
CREATE TEMPORARY TABLE temp_data (
    id INT,
    amount DECIMAL(10,2)
);
```

Both sessions can have their own temporary table named `temp_data`.

The tables are independent.

---

# 14. Inserting Data into Temporary Tables

You can insert data manually:

```sql
CREATE TEMPORARY TABLE temp_high_salary (
    id INT,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);
```

Insert:

```sql
INSERT INTO temp_high_salary
VALUES
(1, 'Rahul', 80000),
(2, 'Amit', 90000);
```

You can also insert query results directly.

### CREATE TEMPORARY TABLE AS SELECT

```sql
CREATE TEMPORARY TABLE temp_it_employees AS
SELECT
    id,
    name,
    salary
FROM employees
WHERE department = 'IT';
```

Now:

```sql
SELECT *
FROM temp_it_employees;
```

This creates a temporary table using the result of a SELECT query.

### Important Difference

`CREATE TEMPORARY TABLE ... AS SELECT` does not automatically copy all indexes, constraints, or other table properties from the source table.

If you need a specific structure, define it explicitly.

---

# 15. Updating and Deleting Temporary Table Data

Temporary tables support normal DML operations.

### UPDATE

```sql
UPDATE temp_it_employees
SET salary = salary + 5000
WHERE id = 1;
```

### DELETE

```sql
DELETE FROM temp_it_employees
WHERE id = 2;
```

### TRUNCATE

```sql
TRUNCATE TABLE temp_it_employees;
```

This removes all rows while keeping the temporary table structure.

### DROP

```sql
DROP TEMPORARY TABLE temp_it_employees;
```

This removes the temporary table itself.

You can also write:

```sql
DROP TEMPORARY TABLE IF EXISTS temp_it_employees;
```

---

# 16. Using Temporary Tables for Intermediate Calculations

Temporary tables are particularly useful for complex reporting and data processing.

### Example: High Salary Employees

Suppose you want to:

1. Find employees with salary above ₹50,000.
2. Store them temporarily.
3. Calculate their average salary.
4. Retrieve their details.

Step 1: Create the temporary table.

```sql
CREATE TEMPORARY TABLE temp_high_salary AS
SELECT
    id,
    name,
    department,
    salary
FROM employees
WHERE salary > 50000;
```

Step 2: Calculate average salary.

```sql
SELECT AVG(salary)
FROM temp_high_salary;
```

Step 3: Retrieve employees.

```sql
SELECT *
FROM temp_high_salary
ORDER BY salary DESC;
```

You can perform multiple operations on the same temporary data without repeatedly executing the original query.

---

# 17. Adding Indexes to Temporary Tables

Temporary tables can have indexes.

This is useful when working with larger intermediate datasets.

### Example

```sql
CREATE TEMPORARY TABLE temp_orders (
    id INT PRIMARY KEY,
    customer_id INT,
    total_amount DECIMAL(10,2)
);
```

You can also add an index later:

```sql
CREATE INDEX idx_customer_id
ON temp_orders(customer_id);
```

Now queries filtering by `customer_id` may benefit from the index.

Example:

```sql
SELECT *
FROM temp_orders
WHERE customer_id = 10;
```

As with normal tables, the optimizer determines whether an index is useful.

---

# 18. Temporary Tables and Stored Procedures

Temporary tables are frequently used inside stored procedures.

Example:

```sql
DELIMITER //

CREATE PROCEDURE GetHighSalaryEmployees()
BEGIN

    CREATE TEMPORARY TABLE temp_high_salary AS
    SELECT
        id,
        name,
        salary
    FROM employees
    WHERE salary > 50000;

    SELECT *
    FROM temp_high_salary;

    DROP TEMPORARY TABLE temp_high_salary;

END //

DELIMITER ;
```

Execute:

```sql
CALL GetHighSalaryEmployees();
```

### Important

If a procedure fails before reaching the DROP statement, the temporary table can remain available for the rest of that connection's lifetime.

A robust procedure should clean up temporary objects appropriately, including on error paths.

Also, a temporary table created inside a stored procedure can remain available to the caller after the procedure finishes if it is not dropped.

---

# 19. Temporary Tables vs Views

This is a very important comparison.

| Feature | View | Temporary Table |
|---|---|---|
| Type | Virtual table | Physical temporary table |
| Stores query definition | Yes | Not as a reusable view definition |
| Stores result rows separately | Normally no | Yes |
| Lifetime | Until dropped | Current session |
| Automatically deleted | No | Yes, when session ends |
| Can insert data | Only if updatable | Yes |
| Can update data | Only if updatable | Yes |
| Can delete data | Only if updatable | Yes |
| Can have indexes | No independent indexes | Yes |
| Uses underlying tables | Usually | Can store copied/intermediate data |
| Main purpose | Simplify queries and control access | Store intermediate data |

### Simple Explanation

**View:**

A saved SELECT query that behaves like a virtual table.

**Temporary Table:**

An actual temporary table that stores intermediate data.

---

# 20. Views vs CTEs vs Temporary Tables

You have already learned CTEs in Phase 14.

Now let's compare all three.

| Feature | View | CTE | Temporary Table |
|---|---|---|---|
| Definition | Saved database object | Defined inside one SQL statement | Temporary database table |
| Lifetime | Until dropped | Single statement | Current session |
| Stores rows separately | Normally no | Not inherently | Yes |
| Reusable across queries | Yes | No | Yes |
| Can be indexed independently | No | No | Yes |
| Can be modified directly | Sometimes | Limited and context-dependent | Yes |
| Recursive support | No recursive view syntax | Yes, recursive CTEs | No inherent recursion |
| Best use | Reusable query abstraction | Organizing one complex query | Multi-step data processing |

### Example of a CTE

```sql
WITH high_salary AS (
    SELECT *
    FROM employees
    WHERE salary > 50000
)
SELECT *
FROM high_salary;
```

### Example of a View

```sql
CREATE VIEW high_salary AS
SELECT *
FROM employees
WHERE salary > 50000;
```

### Example of a Temporary Table

```sql
CREATE TEMPORARY TABLE high_salary AS
SELECT *
FROM employees
WHERE salary > 50000;
```

All three can produce similar results, but their lifecycle and behavior are different.

---

# 21. Do Views Improve Performance?

A common misconception is that creating a view automatically makes a query faster.

This is incorrect.

A normal MySQL view generally does not store its result data.

When you query a view, MySQL optimizes the underlying query.

MySQL can use two main strategies for views:

1. MERGE
2. TEMPTABLE

### MERGE

MySQL merges the view definition into the outer query.

For example:

```sql
SELECT *
FROM high_salary_employees
WHERE department = 'IT';
```

MySQL may optimize this similarly to:

```sql
SELECT *
FROM employees
WHERE salary >= 50000
AND department = 'IT';
```

### TEMPTABLE

MySQL materializes the view result into an internal temporary table before processing the outer query.

This may happen when merging is not possible or is not selected.

### Important

A view is primarily an abstraction and maintainability feature, not automatically a performance optimization.

Use:

```sql
EXPLAIN
SELECT *
FROM high_salary_employees;
```

to inspect the query plan.

---

# 22. Materialized Views in MySQL

A materialized view stores the result of a query rather than calculating it every time.

For example, imagine you have millions of orders and frequently need total sales by month.

Instead of recalculating everything for every report, a materialized result could be stored in a separate table.

**Important: MySQL does not provide native materialized views.**

You can implement a similar approach using:

1. A regular table.
2. `INSERT INTO ... SELECT`.
3. Scheduled Events.
4. Stored Procedures.
5. Application-level background jobs.

### Example

Create a summary table:

```sql
CREATE TABLE monthly_sales_summary (
    sales_month DATE PRIMARY KEY,
    total_sales DECIMAL(15,2)
);
```

Populate it:

```sql
INSERT INTO monthly_sales_summary (
    sales_month,
    total_sales
)
SELECT
    DATE_FORMAT(order_date, '%Y-%m-01'),
    SUM(total_amount)
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01');
```

Now the reporting application can query:

```sql
SELECT *
FROM monthly_sales_summary;
```

You must implement a refresh strategy to keep this summary table synchronized with the original data.

---

# 23. Important Temporary Table Limitations

Keep these points in mind:

### 1. Session-specific

Another connection cannot directly access your temporary table.

### 2. Automatic cleanup

The temporary table is removed when the database session ends.

### 3. Same-name behavior

A temporary table can hide a permanent table with the same name in the current session.

For example, if both exist:

```sql
CREATE TEMPORARY TABLE employees (
    id INT,
    name VARCHAR(100)
);
```

Queries in that session resolve `employees` to the temporary table.

Other sessions still see the permanent table.

### 4. No Foreign Keys

MySQL temporary tables do not support foreign key constraints.

### 5. Explicit cleanup

Use:

```sql
DROP TEMPORARY TABLE IF EXISTS temp_table_name;
```

when the temporary table is no longer required.

### 6. Storage Engine

Temporary tables can use supported storage engines. MySQL may also create internal temporary tables automatically while processing certain queries.

Internal temporary tables and user-created temporary tables are related concepts but are not the same thing.

---

# 24. Practical Real-World Example: E-commerce Reporting

Suppose you have:

- customers
- orders
- order_items
- products

You want to generate customer sales reports.

### Step 1: Create a Customer Sales View

```sql
CREATE VIEW customer_sales_report AS
SELECT
    c.id AS customer_id,
    c.name AS customer_name,
    COUNT(DISTINCT o.id) AS total_orders,
    SUM(oi.quantity * oi.price) AS total_sales
FROM customers c

INNER JOIN orders o
    ON c.id = o.customer_id

INNER JOIN order_items oi
    ON o.id = oi.order_id

GROUP BY
    c.id,
    c.name;
```

### Step 2: Retrieve the Report

```sql
SELECT *
FROM customer_sales_report;
```

### Step 3: Find Top Customers

```sql
SELECT *
FROM customer_sales_report
ORDER BY total_sales DESC
LIMIT 10;
```

### Step 4: Store Top Customers Temporarily

```sql
CREATE TEMPORARY TABLE temp_top_customers AS
SELECT *
FROM customer_sales_report
ORDER BY total_sales DESC
LIMIT 10;
```

### Step 5: Perform Additional Analysis

```sql
SELECT
    COUNT(*) AS total_customers,
    AVG(total_sales) AS average_sales
FROM temp_top_customers;
```

This demonstrates how views and temporary tables can work together.

**Data-model note:** This example calculates sales from order-item quantities and prices. In a production reporting system, account for discounts, taxes, shipping, refunds, and order status according to the application's accounting rules.

---

# 25. Interview Questions and Answers

### Q1. What is a view?

A view is a virtual table based on a SELECT query. It stores the query definition rather than a separate copy of the underlying data.

### Q2. Why do we use views?

To simplify complex queries, improve maintainability, and control access to selected data.

### Q3. Does a view store data?

A normal MySQL view does not store its result rows separately.

### Q4. Can we update a view?

Yes, if the view is updatable and the modification can be mapped to its underlying table.

### Q5. What is WITH CHECK OPTION?

It prevents modifications through an updatable view that cause rows to stop satisfying the view's WHERE condition.

### Q6. Can a view contain JOINs?

Yes.

### Q7. Can a view contain aggregate functions?

Yes, but such views are generally not updatable.

### Q8. What is a temporary table?

A table that exists only within the current database session and is automatically removed when that session ends.

### Q9. Can multiple sessions create temporary tables with the same name?

Yes. Each session has its own independent temporary table.

### Q10. What happens when a session disconnects?

Its temporary tables are automatically dropped.

### Q11. Can temporary tables have indexes?

Yes.

### Q12. Can temporary tables have foreign keys?

MySQL temporary tables do not support foreign key constraints.

### Q13. What is the difference between a view and a temporary table?

A view stores a query definition, while a temporary table stores temporary rows.

### Q14. What is the difference between a CTE and a temporary table?

A CTE exists for one SQL statement. A temporary table can be reused across multiple statements within the same session.

### Q15. Does MySQL support materialized views?

No. MySQL does not provide native materialized views. Similar functionality can be implemented using summary tables and refresh mechanisms.

### Q16. What is the MERGE algorithm in views?

It allows MySQL to merge the view definition into the outer query for optimization.

### Q17. What is the TEMPTABLE algorithm?

It materializes the view result into an internal temporary table before processing the outer query.

### Q18. Can we create a view from another view?

Yes. MySQL supports views based on other views, subject to its view-definition and dependency restrictions.

---

# 26. Practical Assignments

Complete these exercises using MySQL Workbench.

## Assignment 1: Basic Views

Create views for:

1. All IT employees.
2. Employees with salary above ₹50,000.
3. Employees with name and department only.
4. Employees sorted by salary.
5. Employees belonging to a specific department.

## Assignment 2: Views with JOINs

Create views for:

1. Customer order details.
2. Product category details.
3. Employee department details.
4. Customer payment details.
5. Complete order information.

## Assignment 3: Aggregate Views

Create views for:

1. Department-wise employee count.
2. Department-wise average salary.
3. Monthly sales report.
4. Customer-wise total purchases.
5. Product-wise sales quantity.

## Assignment 4: View Operations

Practice:

1. CREATE VIEW.
2. CREATE OR REPLACE VIEW.
3. ALTER VIEW.
4. DROP VIEW.
5. SHOW CREATE VIEW.
6. UPDATE through an updatable view.
7. WITH CHECK OPTION.

## Assignment 5: Temporary Tables

Create temporary tables for:

1. High-salary employees.
2. IT department employees.
3. Top 10 customers.
4. Monthly sales summary.
5. Products with low inventory.

Practice:

- INSERT
- UPDATE
- DELETE
- TRUNCATE
- DROP
- CREATE TEMPORARY TABLE AS SELECT
- CREATE INDEX

## Assignment 6: Combined Project

Build an employee reporting workflow:

1. Create a department salary report view.
2. Create a temporary table containing employees with salary above the department average.
3. Calculate total salary.
4. Calculate average salary.
5. Find the highest-paid employee.
6. Drop the temporary table.

---

# 27. Quick Revision

| Concept | Meaning |
|---|---|
| View | Virtual table based on SELECT |
| CREATE VIEW | Creates a view |
| CREATE OR REPLACE VIEW | Creates or replaces a view |
| ALTER VIEW | Modifies a view definition |
| DROP VIEW | Deletes a view |
| WITH CHECK OPTION | Enforces view conditions on modifications |
| Simple View | View based on relatively straightforward queries |
| Complex View | View using JOINs, aggregates or other complex operations |
| MERGE | Merges view definition into outer query |
| TEMPTABLE | Materializes view results internally |
| Temporary Table | Session-specific table |
| CREATE TEMPORARY TABLE | Creates a temporary table |
| DROP TEMPORARY TABLE | Removes a temporary table |
| CTE | Query-scoped named result |
| Materialized View | Persisted query result; not natively supported by MySQL |

---

# 28. Phase 23 Completion Checklist

- [ ] Understand database views.
- [ ] Create views.
- [ ] Create views using JOINs.
- [ ] Create views using aggregate functions.
- [ ] Update and replace views.
- [ ] Drop views.
- [ ] Understand updatable views.
- [ ] Understand WITH CHECK OPTION.
- [ ] Use views for database security.
- [ ] Understand simple and complex views.
- [ ] Understand MERGE and TEMPTABLE algorithms.
- [ ] Understand materialized views.
- [ ] Create temporary tables.
- [ ] Insert data into temporary tables.
- [ ] Create temporary tables using SELECT.
- [ ] Update and delete temporary table data.
- [ ] Add indexes to temporary tables.
- [ ] Use temporary tables inside stored procedures.
- [ ] Understand views vs CTEs vs temporary tables.

---

## Next Phase: Phase 24 – Advanced Database Management

Topics we will cover:

1. MySQL Users and Account Management.
2. CREATE USER, ALTER USER and DROP USER.
3. GRANT and REVOKE.
4. Database privileges and table-level privileges.
5. Roles in MySQL.
6. Authentication and password policies.
7. Database backup and restore.
8. mysqldump and mysqlpump alternatives.
9. Importing and exporting databases.
10. MySQL Events and Event Scheduler.
11. Partitioning.
12. Generated Columns.
13. JSON operations and indexing.
14. Database monitoring.
15. Performance Schema.
16. Information Schema.
17. MySQL configuration and server variables.
18. Production database best practices.

**Phase 23 is complete.**