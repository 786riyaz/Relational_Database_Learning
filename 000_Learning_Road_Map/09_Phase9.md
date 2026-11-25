# SQL Complete Learning Roadmap
# Phase 9 – GROUP BY and HAVING (Advanced)

**Database:** MySQL 8.0+  
**Level:** Intermediate to Advanced  
**Goal:** Master advanced grouping, filtering aggregated results, multi-level aggregation, and generating business reports using SQL.

In Phase 8, we learned aggregate functions such as `COUNT()`, `SUM()`, `AVG()`, `MIN()`, and `MAX()`.

Now we will learn how to combine these functions with advanced `GROUP BY` and `HAVING` techniques.

---

# 1. Understanding GROUP BY Internally

`GROUP BY` divides rows into groups based on the values of one or more columns.

Aggregate functions then calculate results separately for each group.

Consider this `employees` table:

| id | name | department | salary |
|---:|---|---|---:|
| 1 | John | IT | 50000 |
| 2 | Sarah | HR | 40000 |
| 3 | David | IT | 60000 |
| 4 | Alex | Finance | 45000 |
| 5 | Mike | HR | 55000 |
| 6 | Emma | IT | 70000 |
| 7 | Olivia | Finance | 65000 |
| 8 | James | HR | 35000 |

### Query

```sql
SELECT
    department,
    COUNT(*) AS total_employees,
    SUM(salary) AS total_salary,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department;
```

### Output

| department | total_employees | total_salary | average_salary |
|---|---:|---:|---:|
| Finance | 2 | 110000 | 55000 |
| HR | 3 | 130000 | 43333.33 |
| IT | 3 | 180000 | 60000 |

### How Does GROUP BY Work?

Conceptually, MySQL performs the following operations:

**Step 1: Read records**

MySQL reads the employee records.

**Step 2: Identify unique department values**

```text
IT
HR
Finance
```

**Step 3: Create groups**

```text
IT:
John - 50000
David - 60000
Emma - 70000

HR:
Sarah - 40000
Mike - 55000
James - 35000

Finance:
Alex - 45000
Olivia - 65000
```

**Step 4: Apply aggregate functions**

```text
IT:
COUNT = 3
SUM   = 180000
AVG   = 60000

HR:
COUNT = 3
SUM   = 130000
AVG   = 43333.33

Finance:
COUNT = 2
SUM   = 110000
AVG   = 55000
```

**Step 5: Return grouped results**

One result row is returned for each department.

### Important Concept

Without GROUP BY, an aggregate query generally returns one result row.

With GROUP BY, it returns one result row per group.

---

# 2. GROUP BY Multiple Columns – Advanced

You can group records using multiple columns.

This means MySQL creates groups based on the combination of values in those columns.

Consider:

| id | department | gender | salary |
|---:|---|---|---:|
| 1 | IT | Male | 50000 |
| 2 | IT | Female | 60000 |
| 3 | IT | Male | 55000 |
| 4 | HR | Female | 40000 |
| 5 | HR | Male | 45000 |
| 6 | HR | Female | 50000 |
| 7 | Finance | Male | 65000 |

### Query

```sql
SELECT
    department,
    gender,
    COUNT(*) AS total_employees,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department, gender;
```

### Output

| department | gender | total_employees | total_salary |
|---|---|---:|---:|
| Finance | Male | 1 | 65000 |
| HR | Female | 2 | 90000 |
| HR | Male | 1 | 45000 |
| IT | Female | 1 | 60000 |
| IT | Male | 2 | 105000 |

### How Does It Work?

MySQL groups records using combinations:

```text
IT + Male
IT + Female

HR + Male
HR + Female

Finance + Male
```

Each combination becomes a separate group.

### Another Example: Department and Job Title

Suppose an employee table contains:

| id | name | department | job_title | salary |
|---:|---|---|---|---:|
| 1 | John | IT | Developer | 50000 |
| 2 | Sarah | IT | Tester | 40000 |
| 3 | David | IT | Developer | 60000 |
| 4 | Alex | HR | Manager | 70000 |
| 5 | Mike | HR | Recruiter | 45000 |

Query:

```sql
SELECT
    department,
    job_title,
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department, job_title;
```

This generates a separate group for each department and job title combination.

### Important

The order of columns in GROUP BY can affect the resulting index and query execution plan, but grouping by the same set of columns produces the same logical groups.

For example:

```sql
GROUP BY department, gender
```

and

```sql
GROUP BY gender, department
```

produce the same logical combinations.

---

# 3. GROUP BY with Expressions

You are not limited to grouping by actual table columns.

You can group records using expressions and calculated values.

### Example 1: Group by Year

Suppose we have an `orders` table:

| id | customer_id | order_date | amount |
|---:|---:|---|---:|
| 1 | 101 | 2024-01-10 | 5000 |
| 2 | 102 | 2024-03-15 | 7000 |
| 3 | 103 | 2025-02-20 | 9000 |
| 4 | 101 | 2025-05-12 | 6000 |
| 5 | 104 | 2026-01-18 | 8000 |

Find total revenue for each year.

```sql
SELECT
    YEAR(order_date) AS order_year,
    SUM(amount) AS total_revenue
FROM orders
GROUP BY YEAR(order_date);
```

Output:

| order_year | total_revenue |
|---:|---:|
| 2024 | 12000 |
| 2025 | 15000 |
| 2026 | 8000 |

### Example 2: Group by Month

```sql
SELECT
    MONTH(order_date) AS order_month,
    SUM(amount) AS total_revenue
FROM orders
GROUP BY MONTH(order_date);
```

**Important:** This combines the same month across different years.

For example, January 2024 and January 2025 would be part of the same group.

For multi-year reports, include the year:

```sql
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(amount) AS total_revenue
FROM orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    order_year,
    order_month;
```

### Example 3: Group by Salary Range

Suppose you want to divide employees into salary categories.

```sql
SELECT
    CASE
        WHEN salary < 40000 THEN 'Low'
        WHEN salary BETWEEN 40000 AND 60000 THEN 'Medium'
        ELSE 'High'
    END AS salary_range,

    COUNT(*) AS total_employees

FROM employees

GROUP BY
    CASE
        WHEN salary < 40000 THEN 'Low'
        WHEN salary BETWEEN 40000 AND 60000 THEN 'Medium'
        ELSE 'High'
    END;
```

Output:

| salary_range | total_employees |
|---|---:|
| High | 2 |
| Low | 1 |
| Medium | 5 |

The actual output depends on the employee data.

### Practical Use Cases

Grouping by expressions is useful for:

- Monthly revenue reports.
- Yearly sales reports.
- Employee salary categories.
- Customer age groups.
- Product price ranges.
- Order date analysis.

---

# 4. GROUP BY with CASE

`CASE` allows conditional logic inside SQL queries.

You can combine CASE with GROUP BY to create custom categories.

### Example: Employee Salary Classification

```sql
SELECT
    CASE
        WHEN salary < 40000 THEN 'Low Salary'
        WHEN salary BETWEEN 40000 AND 60000 THEN 'Medium Salary'
        WHEN salary > 60000 THEN 'High Salary'
    END AS salary_category,

    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary

FROM employees

GROUP BY
    CASE
        WHEN salary < 40000 THEN 'Low Salary'
        WHEN salary BETWEEN 40000 AND 60000 THEN 'Medium Salary'
        WHEN salary > 60000 THEN 'High Salary'
    END;
```

### How Does It Work?

Suppose the salaries are:

| Employee | Salary |
|---|---:|
| John | 30000 |
| Sarah | 45000 |
| David | 65000 |
| Alex | 55000 |
| Mike | 35000 |

CASE generates categories:

| Employee | Salary | Category |
|---|---:|---|
| John | 30000 | Low Salary |
| Sarah | 45000 | Medium Salary |
| David | 65000 | High Salary |
| Alex | 55000 | Medium Salary |
| Mike | 35000 | Low Salary |

GROUP BY then groups employees according to the generated category.

### Alternative: Use a Derived Table

If you do not want to repeat the CASE expression, use a subquery.

```sql
SELECT
    salary_category,
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary
FROM (
    SELECT
        id,
        name,
        salary,
        CASE
            WHEN salary < 40000 THEN 'Low Salary'
            WHEN salary BETWEEN 40000 AND 60000 THEN 'Medium Salary'
            ELSE 'High Salary'
        END AS salary_category
    FROM employees
) AS categorized_employees
GROUP BY salary_category;
```

This approach separates classification logic from aggregation logic.

---

# 5. WHERE vs HAVING – Advanced Differences

Both WHERE and HAVING filter data, but they operate at different stages.

This distinction is essential when writing advanced SQL queries.

### WHERE

WHERE filters individual rows before grouping.

### HAVING

HAVING filters groups after grouping and aggregation.

### Example Table

| id | name | department | salary |
|---:|---|---|---:|
| 1 | John | IT | 50000 |
| 2 | Sarah | HR | 40000 |
| 3 | David | IT | 60000 |
| 4 | Alex | Finance | 45000 |
| 5 | Mike | HR | 55000 |
| 6 | Emma | IT | 70000 |

### Example 1: Using WHERE

Find department-wise total salary, considering only employees earning more than 50000.

```sql
SELECT
    department,
    SUM(salary) AS total_salary
FROM employees
WHERE salary > 50000
GROUP BY department;
```

Here, employees earning 50000 or less are removed before grouping.

### Example 2: Using HAVING

Find departments where total salary exceeds 100000.

```sql
SELECT
    department,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING SUM(salary) > 100000;
```

Here, MySQL first calculates total salary for each department and then filters the groups.

### Example 3: Using WHERE and HAVING Together

Find departments where:

- Only employees earning more than 40000 are considered.
- The department must have at least two qualifying employees.
- Total salary must exceed 100000.

```sql
SELECT
    department,
    COUNT(*) AS total_employees,
    SUM(salary) AS total_salary
FROM employees
WHERE salary > 40000
GROUP BY department
HAVING COUNT(*) >= 2
AND SUM(salary) > 100000;
```

### Execution Flow

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
COUNT(*) and SUM(salary)
       |
       v
HAVING COUNT(*) >= 2
AND SUM(salary) > 100000
       |
       v
FINAL RESULT
```

### Important Interview Question

**Can we use aggregate functions in WHERE?**

No, aggregate functions cannot normally be used directly in WHERE because WHERE filters individual rows before aggregation.

Use HAVING to filter aggregate results.

---

# 6. HAVING with Multiple Conditions

HAVING supports logical operators such as:

- AND
- OR
- NOT
- IN
- BETWEEN

You can use these operators to filter grouped results.

### Example 1: AND

Find departments where:

- Employee count is greater than 2.
- Average salary is greater than 45000.

```sql
SELECT
    department,
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department
HAVING COUNT(*) > 2
AND AVG(salary) > 45000;
```

Both conditions must be satisfied.

### Example 2: OR

Find departments where either:

- Total salary is greater than 150000.
- Employee count is greater than 5.

```sql
SELECT
    department,
    COUNT(*) AS total_employees,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING SUM(salary) > 150000
OR COUNT(*) > 5;
```

At least one condition must be true.

### Example 3: BETWEEN

Find departments having average salaries between 40000 and 60000.

```sql
SELECT
    department,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department
HAVING AVG(salary) BETWEEN 40000 AND 60000;
```

### Example 4: IN

Find departments whose total employee count is either 2 or 5.

```sql
SELECT
    department,
    COUNT(*) AS total_employees
FROM employees
GROUP BY department
HAVING COUNT(*) IN (2, 5);
```

### Example 5: Multiple Aggregate Conditions

```sql
SELECT
    department,
    COUNT(*) AS total_employees,
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department
HAVING COUNT(*) >= 2
AND MIN(salary) >= 30000
AND MAX(salary) <= 100000
AND AVG(salary) > 40000;
```

This is useful when generating complex business reports.

---

# 7. GROUP BY with JOIN

This is one of the most important real-world SQL techniques.

In actual applications, data is generally distributed across multiple related tables.

You often need to JOIN tables first and then GROUP BY the combined result.

### Example Database

**departments**

| id | department_name |
|---:|---|
| 1 | IT |
| 2 | HR |
| 3 | Finance |

**employees**

| id | name | department_id | salary |
|---:|---|---:|---:|
| 101 | John | 1 | 50000 |
| 102 | Sarah | 2 | 40000 |
| 103 | David | 1 | 60000 |
| 104 | Alex | 3 | 45000 |
| 105 | Mike | 2 | 55000 |

### Requirement

Find total salary for each department.

### Query

```sql
SELECT
    d.department_name,
    SUM(e.salary) AS total_salary
FROM departments d
INNER JOIN employees e
    ON d.id = e.department_id
GROUP BY d.id, d.department_name;
```

### Output

| department_name | total_salary |
|---|---:|
| IT | 110000 |
| HR | 95000 |
| Finance | 45000 |

### How Does It Work?

**Step 1:** INNER JOIN combines employees and departments.

Conceptual result:

| employee | department_name | salary |
|---|---|---:|
| John | IT | 50000 |
| Sarah | HR | 40000 |
| David | IT | 60000 |
| Alex | Finance | 45000 |
| Mike | HR | 55000 |

**Step 2:** GROUP BY groups records by department.

**Step 3:** SUM calculates total salary for each department.

### Example 2: Employee Count Per Department

```sql
SELECT
    d.department_name,
    COUNT(e.id) AS total_employees
FROM departments d
LEFT JOIN employees e
    ON d.id = e.department_id
GROUP BY d.id, d.department_name;
```

Why use LEFT JOIN?

Because we also want departments that have zero employees.

Example output:

| department_name | total_employees |
|---|---:|
| IT | 2 |
| HR | 2 |
| Finance | 1 |
| Marketing | 0 |

**Important:** When using LEFT JOIN, use `COUNT(e.id)` rather than `COUNT(*)` to count matching employees. An unmatched department still produces one row with NULL employee columns.

### Example 3: Average Salary Per Department

```sql
SELECT
    d.department_name,
    AVG(e.salary) AS average_salary
FROM departments d
LEFT JOIN employees e
    ON d.id = e.department_id
GROUP BY d.id, d.department_name;
```

For departments without employees, AVG returns NULL.

### Example 4: Departments with Total Salary Above 100000

```sql
SELECT
    d.department_name,
    SUM(e.salary) AS total_salary
FROM departments d
INNER JOIN employees e
    ON d.id = e.department_id
GROUP BY d.id, d.department_name
HAVING SUM(e.salary) > 100000;
```

### Real-World Applications

GROUP BY with JOIN is commonly used for:

- Total sales per customer.
- Total revenue per product category.
- Number of orders per customer.
- Employee count per department.
- Total payments per user.
- Inventory value per warehouse.

---

# 8. GROUP BY with Subqueries

A subquery is a query written inside another SQL query.

You can combine subqueries with GROUP BY to perform more advanced calculations.

### Example 1: Departments with Above-Average Salary

First, calculate the overall average salary.

```sql
SELECT AVG(salary)
FROM employees;
```

Now find department-wise average salary.

```sql
SELECT
    department,
    AVG(salary) AS department_average
FROM employees
GROUP BY department;
```

Now combine them:

```sql
SELECT
    department,
    AVG(salary) AS department_average
FROM employees
GROUP BY department
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM employees
);
```

This returns departments whose average salary is greater than the overall employee average.

### Example 2: Departments with More Employees Than Average

```sql
SELECT
    department,
    COUNT(*) AS total_employees
FROM employees
GROUP BY department
HAVING COUNT(*) > (
    SELECT AVG(employee_count)
    FROM (
        SELECT COUNT(*) AS employee_count
        FROM employees
        GROUP BY department
    ) AS department_counts
);
```

Let's understand this.

**Inner query:**

```sql
SELECT COUNT(*) AS employee_count
FROM employees
GROUP BY department;
```

Calculates employee count for every department.

**Middle query:**

```sql
SELECT AVG(employee_count)
FROM (
    ...
) AS department_counts;
```

Calculates average department size.

**Outer query:**

Returns departments whose employee count is greater than the average department size.

### Example 3: Customers Who Have Spent More Than Average Customer Spending

Suppose we have:

**orders**

| id | customer_id | total_amount |
|---:|---:|---:|
| 1 | 101 | 5000 |
| 2 | 102 | 3000 |
| 3 | 101 | 4000 |
| 4 | 103 | 2000 |
| 5 | 102 | 6000 |
| 6 | 104 | 10000 |

Query:

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

This compares each customer's total spending with the average total spending across customers.

---

# 9. ROLLUP

`ROLLUP` is an advanced GROUP BY feature that generates summary rows and subtotals.

It is especially useful for business reports.

Suppose we have a sales table:

| id | department | product | amount |
|---:|---|---|---:|
| 1 | IT | Laptop | 50000 |
| 2 | IT | Mouse | 2000 |
| 3 | IT | Keyboard | 3000 |
| 4 | HR | Laptop | 45000 |
| 5 | HR | Mouse | 1500 |
| 6 | Finance | Laptop | 60000 |

### Normal GROUP BY

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
| Finance | 60000 |
| HR | 46500 |
| IT | 55000 |

This only provides department totals.

But sometimes you also need the grand total.

### Using ROLLUP

```sql
SELECT
    department,
    SUM(amount) AS total_sales
FROM sales
GROUP BY department WITH ROLLUP;
```

Output conceptually:

| department | total_sales |
|---|---:|
| Finance | 60000 |
| HR | 46500 |
| IT | 55000 |
| NULL | 161500 |

The final row represents the grand total.

### ROLLUP with Multiple Columns

```sql
SELECT
    department,
    product,
    SUM(amount) AS total_sales
FROM sales
GROUP BY department, product WITH ROLLUP;
```

This generates:

1. Department and product-level totals.
2. Department-level subtotals.
3. Grand total.

Conceptual output:

| department | product | total_sales |
|---|---|---:|
| Finance | Laptop | 60000 |
| Finance | NULL | 60000 |
| HR | Laptop | 45000 |
| HR | Mouse | 1500 |
| HR | NULL | 46500 |
| IT | Keyboard | 3000 |
| IT | Laptop | 50000 |
| IT | Mouse | 2000 |
| IT | NULL | 55000 |
| NULL | NULL | 161500 |

The NULL values generated by ROLLUP indicate subtotal or grand-total rows.

### Important ROLLUP Syntax

In MySQL, use:

```sql
GROUP BY column1, column2 WITH ROLLUP
```

Do not write:

```sql
GROUP BY column1 WITH ROLLUP, column2
```

`WITH ROLLUP` applies to the complete GROUP BY list.

### When to Use ROLLUP?

- Department-wise and company-wide salary reports.
- Product category sales reports.
- Regional revenue summaries.
- Monthly and yearly financial reports.
- Inventory summaries.

---

# 10. GROUPING() Function

When using ROLLUP, NULL values can be confusing.

A NULL might represent:

1. An actual NULL value in the source data.
2. A subtotal generated by ROLLUP.

MySQL provides the `GROUPING()` function to distinguish these cases.

### Syntax

```sql
GROUPING(column_name)
```

It returns:

- `0` when the column value is part of the grouping level.
- `1` when the column has been aggregated away in a ROLLUP subtotal.

### Example

```sql
SELECT
    department,
    product,
    SUM(amount) AS total_sales,

    GROUPING(department) AS department_grouping,
    GROUPING(product) AS product_grouping

FROM sales

GROUP BY department, product WITH ROLLUP;
```

### Understanding the Result

| department | product | total_sales | department_grouping | product_grouping |
|---|---|---:|---:|---:|
| IT | Laptop | 50000 | 0 | 0 |
| IT | Mouse | 2000 | 0 | 0 |
| IT | NULL | 52000 | 0 | 1 |
| HR | Laptop | 45000 | 0 | 0 |
| HR | Mouse | 1500 | 0 | 0 |
| HR | NULL | 46500 | 0 | 1 |
| NULL | NULL | 98500 | 1 | 1 |

The exact values depend on the source records.

### Creating Meaningful Labels

Instead of showing NULL for subtotal rows:

```sql
SELECT
    CASE
        WHEN GROUPING(department) = 1 THEN 'Grand Total'
        ELSE COALESCE(department, 'Unknown Department')
    END AS department,

    CASE
        WHEN GROUPING(product) = 1 THEN 'Subtotal'
        ELSE COALESCE(product, 'Unknown Product')
    END AS product,

    SUM(amount) AS total_sales

FROM sales

GROUP BY department, product WITH ROLLUP;
```

Now the result is easier to understand in reports.

**Important:** GROUPING() is especially useful when presenting ROLLUP output in dashboards and reporting applications.

---

# 11. Multiple-Level Aggregation

Sometimes you need to perform calculations at multiple levels.

For example:

- Calculate total salary for each department.
- Calculate average department salary total.
- Find the department with the highest total salary.

These are examples of multi-level aggregation.

### Example 1: Average Department Salary Total

```sql
SELECT
    AVG(department_salary) AS average_department_salary
FROM (
    SELECT
        department,
        SUM(salary) AS department_salary
    FROM employees
    GROUP BY department
) AS department_totals;
```

### How Does It Work?

**First level:**

```sql
SELECT
    department,
    SUM(salary) AS department_salary
FROM employees
GROUP BY department;
```

This calculates the total salary of each department.

**Second level:**

```sql
SELECT AVG(department_salary)
FROM (...);
```

This calculates the average of those department totals.

### Example 2: Find the Department with the Highest Total Salary

```sql
SELECT
    department,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department
ORDER BY total_salary DESC
LIMIT 1;
```

This returns one department with the highest total salary.

If multiple departments tie and you want all of them:

```sql
SELECT
    department,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING SUM(salary) = (
    SELECT MAX(department_salary)
    FROM (
        SELECT SUM(salary) AS department_salary
        FROM employees
        GROUP BY department
    ) AS department_totals
);
```

### Example 3: Calculate Percentage Contribution of Each Department

Suppose you want to know what percentage of the company's total salary belongs to each department.

```sql
SELECT
    department,
    SUM(salary) AS department_salary,

    ROUND(
        SUM(salary) * 100.0 /
        (SELECT SUM(salary) FROM employees),
        2
    ) AS salary_percentage

FROM employees

GROUP BY department;
```

Example output:

| department | department_salary | salary_percentage |
|---|---:|---:|
| IT | 180000 | 42.86 |
| HR | 130000 | 30.95 |
| Finance | 110000 | 26.19 |

The percentages add up to approximately 100%.

---

# 12. GROUP BY with LIMIT

You can use LIMIT to restrict the number of grouped results returned.

### Example: Top Three Departments by Total Salary

```sql
SELECT
    department,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department
ORDER BY total_salary DESC
LIMIT 3;
```

### Example: Department with Lowest Average Salary

```sql
SELECT
    department,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department
ORDER BY average_salary ASC
LIMIT 1;
```

### Important

Always use ORDER BY when you need a meaningful top-N or bottom-N result.

Without ORDER BY, LIMIT does not guarantee which groups will be returned.

---

# 13. Common GROUP BY Errors

Understanding these mistakes will help you write correct SQL queries.

## Error 1: Selecting an Ungrouped Column

Incorrect:

```sql
SELECT
    department,
    name,
    SUM(salary)
FROM employees
GROUP BY department;
```

Why is it incorrect?

One department can contain multiple employee names.

MySQL cannot determine which name should appear in the result.

Correct:

```sql
SELECT
    department,
    SUM(salary)
FROM employees
GROUP BY department;
```

Or use an appropriate aggregate if the requirement calls for one.

## Error 2: Using Aggregate Functions in WHERE

Incorrect:

```sql
SELECT department, SUM(salary)
FROM employees
WHERE SUM(salary) > 100000
GROUP BY department;
```

Correct:

```sql
SELECT department, SUM(salary)
FROM employees
GROUP BY department
HAVING SUM(salary) > 100000;
```

## Error 3: Forgetting GROUP BY

Incorrect for department-wise totals:

```sql
SELECT department, SUM(salary)
FROM employees;
```

Correct:

```sql
SELECT department, SUM(salary)
FROM employees
GROUP BY department;
```

## Error 4: Using COUNT(*) with LEFT JOIN

Suppose a department has no employees.

Incorrect for counting employees:

```sql
SELECT
    d.department_name,
    COUNT(*) AS total_employees
FROM departments d
LEFT JOIN employees e
    ON d.id = e.department_id
GROUP BY d.id, d.department_name;
```

An unmatched department still produces one joined row, so COUNT(*) returns 1.

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

COUNT(e.id) ignores the NULL employee ID and correctly returns zero.

## Error 5: Grouping by Month Without Year

Potentially incorrect for multi-year reporting:

```sql
SELECT
    MONTH(order_date),
    SUM(amount)
FROM orders
GROUP BY MONTH(order_date);
```

Correct:

```sql
SELECT
    YEAR(order_date),
    MONTH(order_date),
    SUM(amount)
FROM orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date);
```

---

# 14. Real-World Reporting Queries

Let's look at some practical queries used in actual backend applications.

## Example 1: Total Orders Per Customer

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

This includes customers who have not placed any orders.

## Example 2: Total Revenue Per Customer

```sql
SELECT
    c.id,
    c.name,
    COALESCE(SUM(o.total_amount), 0) AS total_revenue
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
GROUP BY c.id, c.name;
```

## Example 3: Product Category Revenue

Suppose we have:

- categories
- products
- order_items

```sql
SELECT
    c.category_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM categories c
INNER JOIN products p
    ON c.id = p.category_id
INNER JOIN order_items oi
    ON p.id = oi.product_id
GROUP BY c.id, c.category_name
ORDER BY total_revenue DESC;
```

This calculates revenue by product category.

## Example 4: Monthly Completed Orders

```sql
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'Completed'
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    order_year,
    order_month;
```

## Example 5: Customers with More Than Five Orders

```sql
SELECT
    customer_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 5;
```

## Example 6: Employees Earning More Than Their Department Average

This example uses a subquery with GROUP BY.

```sql
SELECT
    e.id,
    e.name,
    e.department,
    e.salary
FROM employees e
INNER JOIN (
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
) AS department_averages
    ON e.department = department_averages.department
WHERE e.salary > department_averages.average_salary;
```

This returns employees earning more than their department's average salary.

---

# 15. Performance Best Practices

Advanced GROUP BY queries can become expensive when working with large datasets.

Follow these practices.

### 1. Filter Records Before Grouping

Prefer filtering unnecessary rows using WHERE.

```sql
SELECT
    department,
    SUM(salary)
FROM employees
WHERE status = 'Active'
GROUP BY department;
```

### 2. Create Appropriate Indexes

For queries filtering and grouping by department:

```sql
CREATE INDEX idx_employee_department
ON employees(department);
```

Whether this index improves performance depends on the query, table size, data distribution, and execution plan.

### 3. Avoid Unnecessary DISTINCT

```sql
SELECT
    department,
    COUNT(DISTINCT employee_id)
FROM employees
GROUP BY department;
```

Use DISTINCT only when you actually need unique values.

### 4. Avoid Selecting Unnecessary Columns

Instead of:

```sql
SELECT *
FROM employees
GROUP BY department;
```

Use:

```sql
SELECT
    department,
    COUNT(*) AS total_employees
FROM employees
GROUP BY department;
```

### 5. Use EXPLAIN

MySQL provides EXPLAIN to inspect query execution plans.

```sql
EXPLAIN
SELECT
    department,
    SUM(salary)
FROM employees
GROUP BY department;
```

It helps you understand how MySQL plans to execute a query.

### 6. Be Careful with JOINs Before Aggregation

If a JOIN produces duplicate rows, aggregate values may become inflated.

For example, joining an employee table with a table containing multiple records per employee can duplicate employee salary values.

Understand the relationship cardinality before aggregating.

---

# 16. SQL GROUP BY and HAVING Interview Questions

## Beginner Level

**1. What is GROUP BY?**

GROUP BY groups rows based on one or more columns so aggregate calculations can be performed for each group.

**2. What is HAVING?**

HAVING filters grouped results based on conditions, commonly involving aggregate functions.

**3. What is the difference between WHERE and HAVING?**

WHERE filters individual rows before grouping. HAVING filters groups after aggregation.

**4. Can GROUP BY use multiple columns?**

Yes.

```sql
GROUP BY department, gender;
```

**5. Does GROUP BY automatically sort results?**

Do not rely on implicit ordering. Use ORDER BY when sorting is required.

## Intermediate Level

**6. Can we use aggregate functions inside HAVING?**

Yes.

```sql
HAVING COUNT(*) > 5;
```

**7. Can we use aggregate functions inside WHERE?**

Not directly in a normal query block. Use HAVING or a subquery.

**8. Can GROUP BY be used with JOIN?**

Yes. It is frequently used to summarize data from multiple related tables.

**9. What is ROLLUP?**

ROLLUP generates additional subtotal and grand-total rows for grouped results.

**10. What is the purpose of GROUPING()?**

It identifies whether a NULL value in a ROLLUP result represents a subtotal or an actual grouped value.

## Advanced Level

**11. Can we use GROUP BY with CASE?**

Yes. CASE can create custom categories, which can then be grouped.

**12. How can we find departments having average salary greater than the company average?**

```sql
SELECT
    department,
    AVG(salary)
FROM employees
GROUP BY department
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM employees
);
```

**13. How can we calculate percentage contribution of each department to total salary?**

```sql
SELECT
    department,
    SUM(salary) AS department_salary,
    SUM(salary) * 100.0 /
    (SELECT SUM(salary) FROM employees) AS percentage
FROM employees
GROUP BY department;
```

**14. What is multi-level aggregation?**

It means performing aggregation at one level and then aggregating those results again, usually through a subquery or CTE.

**15. Why should we use COUNT(e.id) instead of COUNT(*) with LEFT JOIN?**

Because COUNT(*) counts the unmatched row produced by LEFT JOIN, whereas COUNT(e.id) ignores its NULL employee ID.

**16. What is ONLY_FULL_GROUP_BY?**

A MySQL SQL mode that enforces valid grouping rules by rejecting ambiguous nonaggregated columns.

---

# 17. Practical Assignments

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

### Assignment 1: Advanced GROUP BY

Write queries to:

1. Find the total salary for each department.
2. Find the total salary for each department and gender.
3. Find the average salary for each department.
4. Find the maximum and minimum salary for each department.
5. Count employees in each department.
6. Count employees in each department and gender.
7. Group employees into Low, Medium, and High salary categories.
8. Find the number of employees in each salary category.

### Assignment 2: Advanced HAVING

Write queries to:

1. Find departments having more than two employees.
2. Find departments having average salary greater than 50000.
3. Find departments having total salary greater than 150000.
4. Find departments having minimum salary greater than 40000.
5. Find departments having maximum salary greater than 60000.
6. Find departments having more than two employees and average salary greater than 45000.
7. Find departments having at least two male employees.
8. Find departments whose total salary is between 100000 and 200000.

### Assignment 3: GROUP BY with JOIN

Create these tables:

- departments
- employees

Write queries to:

1. Display department-wise employee count.
2. Display department-wise total salary.
3. Display department-wise average salary.
4. Display departments having no employees.
5. Display departments having more than two employees.
6. Display the department with the highest total salary.
7. Display employees earning more than their department's average salary.

### Assignment 4: ROLLUP

Create a sales table:

```sql
CREATE TABLE sales (
    id INT PRIMARY KEY AUTO_INCREMENT,
    department VARCHAR(100),
    product VARCHAR(100),
    amount DECIMAL(10,2)
);
```

Insert sample data and write queries to:

1. Find total sales per department.
2. Find total sales per product.
3. Find department and product-wise sales.
4. Generate department subtotals using ROLLUP.
5. Generate a grand total.
6. Use GROUPING() to identify subtotal rows.
7. Display meaningful labels instead of NULL for subtotal rows.

### Assignment 5: Real-World Business Analytics

Create an e-commerce database with:

- customers
- products
- categories
- orders
- order_items

Write queries to:

1. Find total orders per customer.
2. Find total spending per customer.
3. Find average order value.
4. Find total revenue per category.
5. Find the top five revenue-generating products.
6. Find customers who have placed more than five orders.
7. Find monthly revenue.
8. Find the month with the highest revenue.
9. Find categories whose revenue exceeds 100000.
10. Calculate each category's percentage contribution to total revenue.

---

# 18. Phase 9 Quick Revision Sheet

| Concept | Purpose | Example |
|---|---|---|
| GROUP BY | Group records | `GROUP BY department` |
| Multiple GROUP BY | Group by combinations | `GROUP BY department, gender` |
| GROUP BY Expression | Group calculated values | `GROUP BY YEAR(order_date)` |
| GROUP BY CASE | Group custom categories | `GROUP BY CASE WHEN ... END` |
| HAVING | Filter groups | `HAVING COUNT(*) > 5` |
| WHERE | Filter rows | `WHERE salary > 50000` |
| ROLLUP | Generate subtotals and grand total | `GROUP BY department WITH ROLLUP` |
| GROUPING() | Identify ROLLUP-generated NULLs | `GROUPING(department)` |
| Multi-level Aggregation | Aggregate aggregated results | Subquery with GROUP BY |
| GROUP BY + JOIN | Aggregate related tables | JOIN followed by GROUP BY |

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

---

# 19. Phase 9 Completion Checklist

Before moving to Phase 10, make sure you can:

- [ ] Understand how GROUP BY works.
- [ ] Group records using multiple columns.
- [ ] Group records using expressions.
- [ ] Use CASE with GROUP BY.
- [ ] Understand WHERE vs HAVING.
- [ ] Use multiple conditions in HAVING.
- [ ] Combine GROUP BY with JOIN.
- [ ] Combine GROUP BY with subqueries.
- [ ] Understand ROLLUP.
- [ ] Use GROUPING().
- [ ] Perform multi-level aggregation.
- [ ] Calculate percentage contributions.
- [ ] Use GROUP BY with ORDER BY and LIMIT.
- [ ] Understand common GROUP BY errors.
- [ ] Optimize grouping queries.
- [ ] Write practical business reporting queries.

---

# Next Phase: Phase 10 – SQL JOINS

This is one of the most important topics in SQL and backend development.

We will cover:

1. What Are SQL Joins?
2. Why Do We Need Joins?
3. Understanding Relationships Between Tables
4. INNER JOIN
5. LEFT JOIN
6. RIGHT JOIN
7. FULL OUTER JOIN and MySQL Workarounds
8. CROSS JOIN
9. SELF JOIN
10. Multiple Table Joins
11. JOIN with WHERE
12. JOIN with GROUP BY
13. JOIN with HAVING
14. JOIN with Aggregate Functions
15. JOIN vs Subquery
16. UNION vs JOIN
17. Common JOIN Mistakes
18. JOIN Performance and Indexing
19. Real-World E-commerce Database Examples
20. Interview Questions and Assignments

**Phase 9 is complete.** Phase 10 will focus on SQL JOINs, which are essential for working with relational databases and building Node.js + MySQL applications.