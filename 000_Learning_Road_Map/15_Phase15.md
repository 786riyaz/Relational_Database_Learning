# SQL Complete Learning Roadmap
# Phase 15 – SQL Window Functions
### MySQL 8.0+

Window Functions are among the most important advanced SQL concepts. They are widely used in analytics, reporting, financial applications, dashboards, and technical interviews.

---

# 1. What Are Window Functions?

A **Window Function** performs calculations across a set of related rows while keeping the individual rows in the result.

Unlike aggregate functions, window functions do not combine multiple rows into a single result row.

They calculate a value for each row based on a group of related rows.

### Example: Aggregate Function

Suppose we have an employees table:

| id | name | department | salary |
|---:|---|---|---:|
| 1 | Riyaz | IT | 80000 |
| 2 | John | IT | 60000 |
| 3 | Sarah | HR | 75000 |
| 4 | David | HR | 45000 |
| 5 | Alex | Finance | 90000 |

Calculate the average salary:

```sql
SELECT AVG(salary) AS average_salary
FROM employees;
```

Output:

| average_salary |
|---:|
| 70000 |

Notice that the result contains only one row.

### Example: Window Function

```sql
SELECT
    name,
    department,
    salary,
    AVG(salary) OVER() AS average_salary
FROM employees;
```

Output:

| name | department | salary | average_salary |
|---|---|---:|---:|
| Riyaz | IT | 80000 | 70000 |
| John | IT | 60000 | 70000 |
| Sarah | HR | 75000 | 70000 |
| David | HR | 45000 | 70000 |
| Alex | Finance | 90000 | 70000 |

Notice that every employee remains in the result.

The average salary is calculated across all employees and displayed alongside each row.

**This is the main difference between aggregate functions and window functions.**

---

# 2. Aggregate Functions vs Window Functions

| Feature | Aggregate Functions | Window Functions |
|---|---|---|
| Purpose | Calculate values across rows | Calculate values across related rows |
| Output | Usually one row per group | Preserves individual rows |
| GROUP BY | Commonly used | Not required |
| OVER() | Not required | Required |
| Example | AVG(), SUM(), COUNT() | AVG() OVER(), SUM() OVER() |
| Use case | Department salary summary | Salary comparison per employee |

### Aggregate Example

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
| IT | 70000 |
| HR | 60000 |
| Finance | 90000 |

### Window Function Example

```sql
SELECT
    name,
    department,
    salary,
    AVG(salary) OVER(
        PARTITION BY department
    ) AS average_salary
FROM employees;
```

Output:

| name | department | salary | average_salary |
|---|---|---:|---:|
| Riyaz | IT | 80000 | 70000 |
| John | IT | 60000 | 70000 |
| Sarah | HR | 75000 | 60000 |
| David | HR | 45000 | 60000 |
| Alex | Finance | 90000 | 90000 |

Every employee is displayed, but the average is calculated separately for each department.

---

# 3. Understanding the OVER() Clause

The `OVER()` clause defines the window of rows that a window function operates on.

### Syntax

```sql
function_name() OVER (
    PARTITION BY column
    ORDER BY column
    ROWS BETWEEN ...
)
```

The three main components are:

| Component | Purpose |
|---|---|
| PARTITION BY | Divides rows into groups |
| ORDER BY | Defines row ordering inside the window |
| Frame clause | Defines which rows around the current row are included |

All three are not mandatory in every window function.

### Basic Example

```sql
SELECT
    name,
    salary,
    SUM(salary) OVER() AS total_salary
FROM employees;
```

Here:

```sql
OVER()
```

means the function operates over the entire result set.

---

# 4. Understanding PARTITION BY

`PARTITION BY` divides the result set into separate groups, called partitions.

Each partition is processed independently.

Think of it as grouping records for window calculations without reducing the number of rows.

### Example

```sql
SELECT
    name,
    department,
    salary,
    AVG(salary) OVER(
        PARTITION BY department
    ) AS department_average
FROM employees;
```

Output:

| name | department | salary | department_average |
|---|---|---:|---:|
| Riyaz | IT | 80000 | 70000 |
| John | IT | 60000 | 70000 |
| Sarah | HR | 75000 | 60000 |
| David | HR | 45000 | 60000 |
| Alex | Finance | 90000 | 90000 |

### How does it work?

The database logically creates these partitions:

**IT Partition**

| name | salary |
|---|---:|
| Riyaz | 80000 |
| John | 60000 |

Average = 70000

**HR Partition**

| name | salary |
|---|---:|
| Sarah | 75000 |
| David | 45000 |

Average = 60000

**Finance Partition**

| name | salary |
|---|---:|
| Alex | 90000 |

Average = 90000

Each employee gets the average salary of their department.

### PARTITION BY Multiple Columns

You can partition by multiple columns.

```sql
SELECT
    name,
    department,
    job_role,
    salary,
    AVG(salary) OVER(
        PARTITION BY department, job_role
    ) AS average_salary
FROM employees;
```

This creates separate partitions for each combination of department and job role.

### PARTITION BY vs GROUP BY

| PARTITION BY | GROUP BY |
|---|---|
| Used with window functions | Used with aggregate queries |
| Keeps individual rows | Groups rows into result rows |
| Does not reduce row count | Usually reduces row count |
| Can calculate values per partition | Calculates values per group |

---

# 5. ORDER BY Inside OVER()

`ORDER BY` inside `OVER()` determines the order in which rows are processed by the window function.

Example:

```sql
SELECT
    name,
    salary,
    ROW_NUMBER() OVER(
        ORDER BY salary DESC
    ) AS row_number
FROM employees;
```

Output:

| name | salary | row_number |
|---|---:|---:|
| Alex | 90000 | 1 |
| Riyaz | 80000 | 2 |
| Sarah | 75000 | 3 |
| John | 60000 | 4 |
| David | 45000 | 5 |

Notice that the highest-paid employee gets row number 1.

**Important:** `ORDER BY` inside `OVER()` does not guarantee the final display order of the query.

If you want to sort the final output, use an outer `ORDER BY`:

```sql
SELECT
    name,
    salary,
    ROW_NUMBER() OVER(
        ORDER BY salary DESC
    ) AS row_number
FROM employees
ORDER BY salary DESC;
```

---

# 6. ROW_NUMBER()

`ROW_NUMBER()` assigns a unique sequential number to each row within a partition.

### Syntax

```sql
ROW_NUMBER() OVER (
    PARTITION BY column
    ORDER BY column
)
```

### Example

```sql
SELECT
    name,
    department,
    salary,
    ROW_NUMBER() OVER(
        ORDER BY salary DESC
    ) AS row_number
FROM employees;
```

Output:

| name | department | salary | row_number |
|---|---|---:|---:|
| Alex | Finance | 90000 | 1 |
| Riyaz | IT | 80000 | 2 |
| Sarah | HR | 75000 | 3 |
| John | IT | 60000 | 4 |
| David | HR | 45000 | 5 |

### ROW_NUMBER() with PARTITION BY

Assign row numbers separately for each department.

```sql
SELECT
    name,
    department,
    salary,
    ROW_NUMBER() OVER(
        PARTITION BY department
        ORDER BY salary DESC
    ) AS row_number
FROM employees;
```

Output:

| name | department | salary | row_number |
|---|---|---:|---:|
| Riyaz | IT | 80000 | 1 |
| John | IT | 60000 | 2 |
| Sarah | HR | 75000 | 1 |
| David | HR | 45000 | 2 |
| Alex | Finance | 90000 | 1 |

Each department starts numbering from 1.

### Important: Handling Ties

Suppose two employees have the same salary.

`ROW_NUMBER()` still assigns different numbers.

To make the numbering deterministic, include a unique secondary sorting column:

```sql
SELECT
    name,
    salary,
    ROW_NUMBER() OVER(
        ORDER BY salary DESC, id ASC
    ) AS row_number
FROM employees;
```

### Real-World Use Cases

- Assign unique ranks.
- Find the latest record per customer.
- Remove duplicate records.
- Implement pagination.
- Identify the first transaction per user.

---

# 7. RANK()

`RANK()` assigns rankings based on the ordering of values.

If two or more rows have the same value, they receive the same rank.

The next rank is skipped.

### Example

Imagine these employee salaries:

| Name | Salary |
|---|---:|
| Alex | 90000 |
| Riyaz | 80000 |
| Sarah | 80000 |
| John | 60000 |
| David | 45000 |

Query:

```sql
SELECT
    name,
    salary,
    RANK() OVER(
        ORDER BY salary DESC
    ) AS employee_rank
FROM employees;
```

Output:

| name | salary | employee_rank |
|---|---:|---:|
| Alex | 90000 | 1 |
| Riyaz | 80000 | 2 |
| Sarah | 80000 | 2 |
| John | 60000 | 4 |
| David | 45000 | 5 |

Notice:
- Riyaz and Sarah both get rank 2.
- Rank 3 is skipped.
- John receives rank 4.

### RANK() with PARTITION BY

```sql
SELECT
    name,
    department,
    salary,
    RANK() OVER(
        PARTITION BY department
        ORDER BY salary DESC
    ) AS department_rank
FROM employees;
```

This ranks employees separately within each department.

---

# 8. DENSE_RANK()

`DENSE_RANK()` works similarly to `RANK()`, but it does not skip ranking numbers.

### Example

```sql
SELECT
    name,
    salary,
    DENSE_RANK() OVER(
        ORDER BY salary DESC
    ) AS dense_rank
FROM employees;
```

Assume salaries:

| Name | Salary |
|---|---:|
| Alex | 90000 |
| Riyaz | 80000 |
| Sarah | 80000 |
| John | 60000 |
| David | 45000 |

Output:

| name | salary | dense_rank |
|---|---:|---:|
| Alex | 90000 | 1 |
| Riyaz | 80000 | 2 |
| Sarah | 80000 | 2 |
| John | 60000 | 3 |
| David | 45000 | 4 |

### ROW_NUMBER() vs RANK() vs DENSE_RANK()

This is one of the most important SQL interview questions.

| Function | Handles Ties | Skips Rank Numbers |
|---|---|---|
| ROW_NUMBER() | Gives unique numbers | No |
| RANK() | Same rank for ties | Yes |
| DENSE_RANK() | Same rank for ties | No |

### Example

Input values:

```text
100, 90, 90, 80, 70
```

Output:

| Value | ROW_NUMBER | RANK | DENSE_RANK |
|---:|---:|---:|---:|
| 100 | 1 | 1 | 1 |
| 90 | 2 | 2 | 2 |
| 90 | 3 | 2 | 2 |
| 80 | 4 | 4 | 3 |
| 70 | 5 | 5 | 4 |

**Remember:**
- ROW_NUMBER = Always unique.
- RANK = Skips numbers after ties.
- DENSE_RANK = Does not skip numbers after ties.

---

# 9. NTILE()

`NTILE()` divides ordered rows into a specified number of approximately equal-sized groups, called buckets.

### Syntax

```sql
NTILE(number_of_buckets) OVER (
    ORDER BY column
)
```

### Example

Divide employees into two salary groups.

```sql
SELECT
    name,
    salary,
    NTILE(2) OVER(
        ORDER BY salary DESC
    ) AS salary_group
FROM employees;
```

Output:

| name | salary | salary_group |
|---|---:|---:|
| Alex | 90000 | 1 |
| Riyaz | 80000 | 1 |
| Sarah | 75000 | 1 |
| John | 60000 | 2 |
| David | 45000 | 2 |

### NTILE(4)

```sql
SELECT
    name,
    salary,
    NTILE(4) OVER(
        ORDER BY salary DESC
    ) AS salary_quartile
FROM employees;
```

This divides employees into four approximately equal-sized groups.

### Use Cases

- Salary quartiles.
- Customer segmentation.
- Performance groups.
- Sales distribution analysis.
- Dividing records into batches.

**Important:** NTILE() distributes rows, not distinct values. Equal salaries can end up in different buckets.

---

# 10. LAG()

`LAG()` retrieves a value from a previous row within the same window.

### Syntax

```sql
LAG(column, offset, default_value) OVER (
    ORDER BY column
)
```

Parameters:

| Parameter | Meaning |
|---|---|
| column | Value to retrieve |
| offset | Number of rows to look backward |
| default_value | Value returned when the previous row does not exist |

### Example

Suppose you have monthly sales:

| Month | Sales |
|---|---:|
| January | 10000 |
| February | 15000 |
| March | 12000 |
| April | 20000 |

Create a table:

```sql
CREATE TABLE monthly_sales (
    id INT PRIMARY KEY AUTO_INCREMENT,
    month_name VARCHAR(20),
    month_number INT,
    sales DECIMAL(10,2)
);

INSERT INTO monthly_sales
(month_name, month_number, sales)
VALUES
('January', 1, 10000),
('February', 2, 15000),
('March', 3, 12000),
('April', 4, 20000);
```

Query:

```sql
SELECT
    month_name,
    sales,
    LAG(sales) OVER(
        ORDER BY month_number
    ) AS previous_month_sales
FROM monthly_sales;
```

Output:

| month_name | sales | previous_month_sales |
|---|---:|---:|
| January | 10000 | NULL |
| February | 15000 | 10000 |
| March | 12000 | 15000 |
| April | 20000 | 12000 |

The first row has no previous row, so its result is NULL.

### LAG() with Offset

```sql
SELECT
    month_name,
    sales,
    LAG(sales, 2) OVER(
        ORDER BY month_number
    ) AS sales_two_months_ago
FROM monthly_sales;
```

This retrieves the sales value from two rows earlier.

### LAG() with Default Value

```sql
SELECT
    month_name,
    sales,
    LAG(sales, 1, 0) OVER(
        ORDER BY month_number
    ) AS previous_month_sales
FROM monthly_sales;
```

January returns 0 instead of NULL.

---

# 11. LEAD()

`LEAD()` retrieves a value from a future row within the same window.

It is the opposite of LAG().

### Syntax

```sql
LEAD(column, offset, default_value) OVER (
    ORDER BY column
)
```

Example:

```sql
SELECT
    month_name,
    sales,
    LEAD(sales) OVER(
        ORDER BY month_number
    ) AS next_month_sales
FROM monthly_sales;
```

Output:

| month_name | sales | next_month_sales |
|---|---:|---:|
| January | 10000 | 15000 |
| February | 15000 | 12000 |
| March | 12000 | 20000 |
| April | 20000 | NULL |

### LAG() vs LEAD()

| LAG() | LEAD() |
|---|---|
| Looks at previous rows | Looks at future rows |
| Retrieves earlier values | Retrieves later values |
| Useful for previous-month comparisons | Useful for next-month comparisons |

### Real-World Use Cases

- Compare current and previous sales.
- Compare current and next transactions.
- Calculate month-over-month growth.
- Identify changes in employee salaries.
- Detect gaps in event sequences.

---

# 12. FIRST_VALUE()

`FIRST_VALUE()` returns the first value in the current window frame.

### Syntax

```sql
FIRST_VALUE(column) OVER (
    PARTITION BY column
    ORDER BY column
)
```

Example:

```sql
SELECT
    name,
    department,
    salary,
    FIRST_VALUE(name) OVER(
        PARTITION BY department
        ORDER BY salary DESC
    ) AS highest_paid_employee
FROM employees;
```

Output:

| name | department | salary | highest_paid_employee |
|---|---|---:|---|
| Riyaz | IT | 80000 | Riyaz |
| John | IT | 60000 | Riyaz |
| Sarah | HR | 75000 | Sarah |
| David | HR | 45000 | Sarah |
| Alex | Finance | 90000 | Alex |

It returns the first employee in each department after sorting by salary descending.

---

# 13. LAST_VALUE()

`LAST_VALUE()` returns the last value in the current window frame.

This function has an important behavior that many developers misunderstand.

### Example

```sql
SELECT
    name,
    salary,
    LAST_VALUE(name) OVER(
        ORDER BY salary
    ) AS last_employee
FROM employees;
```

This may not return the last employee of the entire result set for every row.

Why?

Because the default window frame with an ORDER BY generally ends at the current row's peer group, not necessarily at the final row.

### Correct Way to Get the Last Value in the Entire Partition

```sql
SELECT
    name,
    salary,
    LAST_VALUE(name) OVER(
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS last_employee
FROM employees;
```

Now the frame includes all rows in the partition.

### Important Window Frame Keywords

| Keyword | Meaning |
|---|---|
| UNBOUNDED PRECEDING | Start of partition |
| CURRENT ROW | Current row |
| UNBOUNDED FOLLOWING | End of partition |
| N PRECEDING | N rows before current row |
| N FOLLOWING | N rows after current row |

---

# 14. NTH_VALUE()

`NTH_VALUE()` retrieves the value at a specified position in the current window frame.

### Syntax

```sql
NTH_VALUE(column, N) OVER (
    ORDER BY column
    ROWS BETWEEN ...
)
```

Example:

Find the second-highest-paid employee's name in the entire result.

```sql
SELECT
    name,
    salary,
    NTH_VALUE(name, 2) OVER(
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS second_highest_paid
FROM employees;
```

If salaries are:

| Name | Salary |
|---|---:|
| Alex | 90000 |
| Riyaz | 80000 |
| Sarah | 75000 |
| John | 60000 |
| David | 45000 |

The `second_highest_paid` column returns Riyaz for every row.

**Important:** If the requested row is outside the current window frame, `NTH_VALUE()` returns NULL.

---

# 15. Running Total

A running total is a cumulative sum calculated row by row.

For example:

| Month | Sales |
|---|---:|
| January | 10000 |
| February | 15000 |
| March | 12000 |
| April | 20000 |

Running total:

| Month | Sales | Running Total |
|---|---:|---:|
| January | 10000 | 10000 |
| February | 15000 | 25000 |
| March | 12000 | 37000 |
| April | 20000 | 57000 |

### SQL Query

```sql
SELECT
    month_name,
    sales,
    SUM(sales) OVER(
        ORDER BY month_number
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_total
FROM monthly_sales;
```

### Explanation

```sql
ROWS BETWEEN UNBOUNDED PRECEDING
AND CURRENT ROW
```

Means:

- Start from the first row.
- Include every row up to the current row.
- Calculate the sum.

### Running Total by Department

```sql
SELECT
    name,
    department,
    salary,
    SUM(salary) OVER(
        PARTITION BY department
        ORDER BY salary DESC, id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_salary
FROM employees;
```

The running total restarts for each department.

---

# 16. Moving Average

A moving average calculates the average of a fixed number of nearby rows.

It is useful for analyzing trends and reducing short-term fluctuations.

Suppose monthly sales are:

| Month | Sales |
|---|---:|
| January | 10000 |
| February | 15000 |
| March | 12000 |
| April | 20000 |
| May | 18000 |

Calculate a three-row moving average.

```sql
SELECT
    month_name,
    sales,
    ROUND(
        AVG(sales) OVER(
            ORDER BY month_number
            ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS moving_average
FROM monthly_sales;
```

The window includes:
- Current row.
- One previous row.
- Two previous rows.

For the third row:

```text
January   = 10000
February  = 15000
March     = 12000

Average = (10000 + 15000 + 12000) / 3

        = 12333.33
```

### Output

| Month | Sales | Moving Average |
|---|---:|---:|
| January | 10000 | 10000.00 |
| February | 15000 | 12500.00 |
| March | 12000 | 12333.33 |
| April | 20000 | 15666.67 |
| May | 18000 | 16666.67 |

The first two rows use fewer than three available rows because there are not yet three preceding/current rows.

---

# 17. Window Frames – ROWS and RANGE

Window frames define which rows are included in a window calculation.

They are especially important for:
- Running totals.
- Moving averages.
- FIRST_VALUE().
- LAST_VALUE().
- NTH_VALUE().

### ROWS

`ROWS` defines a frame based on physical row positions.

Example:

```sql
SELECT
    month_name,
    sales,
    SUM(sales) OVER(
        ORDER BY month_number
        ROWS BETWEEN 1 PRECEDING
        AND CURRENT ROW
    ) AS total_sales
FROM monthly_sales;
```

This includes:
- One previous row.
- Current row.

### RANGE

`RANGE` defines a frame based on ordering values and peer rows.

Example:

```sql
SELECT
    name,
    salary,
    SUM(salary) OVER(
        ORDER BY salary
        RANGE BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_salary
FROM employees;
```

Rows with the same ordering value are peers and are included together in a RANGE frame ending at CURRENT ROW.

### ROWS vs RANGE

| ROWS | RANGE |
|---|---|
| Based on physical row positions | Based on ordering values |
| Counts preceding/following rows | Includes rows within a value-based range |
| Useful for moving averages | Useful when peer values should be treated together |
| Can distinguish rows with equal ordering values | Treats equal ordering values as peers |

### Common Frame Boundaries

| Frame Boundary | Meaning |
|---|---|
| UNBOUNDED PRECEDING | Start of partition |
| 1 PRECEDING | One row/value before current |
| 2 PRECEDING | Two rows/values before current |
| CURRENT ROW | Current row or its peer group, depending on frame type |
| 1 FOLLOWING | One row/value after current |
| UNBOUNDED FOLLOWING | End of partition |

### Important Default Frame Behavior

When an aggregate window function has `ORDER BY` but no explicit frame, MySQL generally uses a frame equivalent to:

```sql
RANGE BETWEEN UNBOUNDED PRECEDING
AND CURRENT ROW
```

This means duplicate ordering values can affect cumulative calculations.

For predictable row-by-row running totals, explicitly specify:

```sql
ROWS BETWEEN UNBOUNDED PRECEDING
AND CURRENT ROW
```

Also add a unique secondary ordering column when deterministic row order is required.

---

# 18. Top N Records Per Group

This is one of the most common real-world window function problems.

### Requirement

Find the top two highest-paid employees in each department.

```sql
WITH ranked_employees AS (

    SELECT
        id,
        name,
        department,
        salary,
        ROW_NUMBER() OVER(
            PARTITION BY department
            ORDER BY salary DESC, id
        ) AS row_num

    FROM employees

)

SELECT *
FROM ranked_employees
WHERE row_num <= 2;
```

### Output

| id | name | department | salary | row_num |
|---:|---|---|---:|---:|
| 1 | Riyaz | IT | 80000 | 1 |
| 2 | John | IT | 60000 | 2 |
| 3 | Sarah | HR | 75000 | 1 |
| 4 | David | HR | 45000 | 2 |
| 5 | Alex | Finance | 90000 | 1 |

The query:
1. Assigns row numbers within each department.
2. Sorts employees by salary.
3. Returns only the first two employees per department.

### Important

You cannot generally filter a window function result directly in the WHERE clause of the same SELECT.

This is invalid:

```sql
SELECT
    name,
    salary,
    ROW_NUMBER() OVER(
        ORDER BY salary DESC
    ) AS row_num
FROM employees
WHERE row_num <= 2;
```

Why?

Because WHERE is logically evaluated before the SELECT list, where the window function result is produced.

Use a CTE or derived table to filter the calculated result.

---

# 19. Find the Second-Highest Salary

There are several ways to solve this problem.

### Method 1: Using DENSE_RANK()

```sql
WITH salary_ranking AS (

    SELECT
        name,
        salary,
        DENSE_RANK() OVER(
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employees

)

SELECT *
FROM salary_ranking
WHERE salary_rank = 2;
```

This returns employees earning the second-highest distinct salary.

### Method 2: Using LIMIT and OFFSET

```sql
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 1;
```

This returns the second-highest distinct salary value.

### Difference

| DENSE_RANK() | LIMIT + OFFSET |
|---|---|
| Can return employee details | Returns selected salary values |
| Useful for ranking | Useful for selecting a particular ordered value |
| Works with partitions | Requires additional logic for group-wise ranking |

---

# 20. Department-Wise Salary Ranking

Requirement: Rank employees by salary within each department.

```sql
SELECT
    e.name,
    d.department_name,
    e.salary,

    RANK() OVER(
        PARTITION BY e.department_id
        ORDER BY e.salary DESC
    ) AS salary_rank

FROM employees e

INNER JOIN departments d
    ON e.department_id = d.id;
```

This generates independent salary rankings for each department.

### Find the Highest-Paid Employee in Each Department

```sql
WITH ranked_employees AS (

    SELECT
        e.name,
        e.department_id,
        e.salary,

        ROW_NUMBER() OVER(
            PARTITION BY e.department_id
            ORDER BY e.salary DESC, e.id
        ) AS row_num

    FROM employees e

)

SELECT *
FROM ranked_employees
WHERE row_num = 1;
```

---

# 21. Calculate Month-over-Month Growth

This is a common business analytics requirement.

Formula:

\[
Growth\ Percentage =
\frac{Current\ Sales - Previous\ Sales}
{Previous\ Sales} \times 100
\]

SQL:

```sql
WITH sales_comparison AS (

    SELECT
        month_name,
        month_number,
        sales,

        LAG(sales) OVER(
            ORDER BY month_number
        ) AS previous_sales

    FROM monthly_sales

)

SELECT
    month_name,
    sales,
    previous_sales,

    ROUND(
        (
            (sales - previous_sales)
            / NULLIF(previous_sales, 0)
        ) * 100,
        2
    ) AS growth_percentage

FROM sales_comparison;
```

Possible output:

| month_name | sales | previous_sales | growth_percentage |
|---|---:|---:|---:|
| January | 10000 | NULL | NULL |
| February | 15000 | 10000 | 50.00 |
| March | 12000 | 15000 | -20.00 |
| April | 20000 | 12000 | 66.67 |

This technique is useful for:
- Monthly sales reports.
- Revenue dashboards.
- Customer growth analysis.
- Financial reporting.

---

# 22. Window Functions with Multiple Partitions

You can use multiple window functions in the same SELECT query.

Example:

```sql
SELECT
    name,
    department,
    salary,

    ROW_NUMBER() OVER(
        PARTITION BY department
        ORDER BY salary DESC, id
    ) AS row_num,

    RANK() OVER(
        PARTITION BY department
        ORDER BY salary DESC
    ) AS salary_rank,

    AVG(salary) OVER(
        PARTITION BY department
    ) AS department_average,

    MAX(salary) OVER(
        PARTITION BY department
    ) AS highest_salary

FROM employees;
```

This query calculates:
- Employee row number.
- Salary rank.
- Department average salary.
- Highest salary in the department.

All without reducing the number of employee records.

---

# 23. Named Windows Using the WINDOW Clause

When multiple window functions use the same window definition, you can define a named window.

This avoids repeating the same `PARTITION BY` and `ORDER BY` clauses.

### Syntax

```sql
SELECT
    column1,
    function1() OVER window_name,
    function2() OVER window_name

FROM table_name

WINDOW window_name AS (
    PARTITION BY column
    ORDER BY column
);
```

### Example

```sql
SELECT
    name,
    department,
    salary,

    ROW_NUMBER() OVER department_window AS row_num,

    RANK() OVER department_window AS salary_rank,

    DENSE_RANK() OVER department_window AS dense_rank

FROM employees

WINDOW department_window AS (
    PARTITION BY department
    ORDER BY salary DESC
);
```

The named window is declared using the `WINDOW` clause after the FROM clause.

**Important:** Named windows can be reused by window functions in the same SELECT statement.

---

# 24. Window Functions vs GROUP BY vs CTE vs Subquery

These concepts are often confused.

| Feature | GROUP BY | Window Functions | CTE | Subquery |
|---|---|---|---|---|
| Main purpose | Group and aggregate records | Calculate across related rows | Organize complex queries | Nest a query |
| Preserves individual rows | Usually no | Yes | Depends on query | Depends on query |
| Uses OVER() | No | Yes | No | No |
| Recursive support | No | No | Yes | No direct recursive syntax |
| Can be combined | Yes | Yes | Yes | Yes |

### Example: GROUP BY

```sql
SELECT
    department,
    AVG(salary)
FROM employees
GROUP BY department;
```

Returns one row per department.

### Example: Window Function

```sql
SELECT
    name,
    department,
    salary,
    AVG(salary) OVER(
        PARTITION BY department
    ) AS average_salary
FROM employees;
```

Returns every employee with their department average.

### Example: CTE with Window Function

```sql
WITH employee_ranking AS (

    SELECT
        name,
        department,
        salary,

        RANK() OVER(
            PARTITION BY department
            ORDER BY salary DESC
        ) AS salary_rank

    FROM employees

)

SELECT *
FROM employee_ranking
WHERE salary_rank = 1;
```

This finds the highest-ranked employees in every department, including ties.

---

# 25. Window Functions Performance and Best Practices

Window functions can require sorting and processing large sets of records.

Follow these practices:

1. Select only the columns you need.
2. Filter unnecessary rows before calculating windows when logically correct.
3. Use PARTITION BY when calculations should be independent per group.
4. Use deterministic ORDER BY clauses when row ordering matters.
5. Add appropriate indexes for partitioning and ordering columns when beneficial.
6. Avoid calculating the same window expressions repeatedly.
7. Use named windows when multiple functions share the same specification.
8. Use CTEs or derived tables to filter window function results.
9. Specify explicit frames when running calculations need predictable behavior.
10. Check query execution plans using EXPLAIN and EXPLAIN ANALYZE.

### Example: Index for Window Queries

Suppose you frequently execute:

```sql
SELECT
    name,
    department,
    salary,
    RANK() OVER(
        PARTITION BY department
        ORDER BY salary DESC
    ) AS salary_rank
FROM employees;
```

An index such as:

```sql
CREATE INDEX idx_department_salary
ON employees(department, salary);
```

may help some query plans.

However, an index does not guarantee that MySQL can avoid sorting for every window operation. Verify using EXPLAIN ANALYZE.

---

# 26. Common Mistakes

### Mistake 1: Confusing GROUP BY with PARTITION BY

GROUP BY reduces rows into groups.

PARTITION BY divides rows for window calculations while preserving individual rows.

### Mistake 2: Filtering Window Functions Directly in WHERE

Incorrect:

```sql
SELECT
    name,
    ROW_NUMBER() OVER(
        ORDER BY salary DESC
    ) AS row_num
FROM employees
WHERE row_num <= 3;
```

Correct:

```sql
WITH ranked_employees AS (
    SELECT
        name,
        salary,
        ROW_NUMBER() OVER(
            ORDER BY salary DESC
        ) AS row_num
    FROM employees
)

SELECT *
FROM ranked_employees
WHERE row_num <= 3;
```

### Mistake 3: Confusing RANK() and DENSE_RANK()

Remember:

- RANK() skips numbers after ties.
- DENSE_RANK() does not skip numbers.

### Mistake 4: Forgetting PARTITION BY

Without PARTITION BY, the window generally operates across the entire result set.

### Mistake 5: Assuming LAST_VALUE() Returns the Final Partition Value

The default frame may end at the current row or peer group.

Specify:

```sql
ROWS BETWEEN UNBOUNDED PRECEDING
AND UNBOUNDED FOLLOWING
```

when you need the final value of the entire partition.

### Mistake 6: Not Handling Duplicate Ordering Values

When using ROW_NUMBER(), add a unique tie-breaker if deterministic numbering matters.

### Mistake 7: Forgetting NULL Handling in LAG() and LEAD()

The first LAG() result and last LEAD() result are NULL by default when the requested row does not exist.

You can specify a default value.

---

# 27. Real-World Practical Examples

## Example 1: Find Top Three Employees in Each Department

```sql
WITH ranked_employees AS (

    SELECT
        e.id,
        e.name,
        e.department,
        e.salary,

        ROW_NUMBER() OVER(
            PARTITION BY e.department
            ORDER BY e.salary DESC, e.id
        ) AS row_num

    FROM employees e

)

SELECT *
FROM ranked_employees
WHERE row_num <= 3;
```

## Example 2: Find Employees Earning More Than Their Department Average

```sql
SELECT
    name,
    department,
    salary,

    AVG(salary) OVER(
        PARTITION BY department
    ) AS department_average

FROM employees

QUALIFY salary > AVG(salary) OVER(
    PARTITION BY department
);
```

**Important:** MySQL does not support `QUALIFY`. Use a CTE instead:

```sql
WITH employee_data AS (

    SELECT
        name,
        department,
        salary,

        AVG(salary) OVER(
            PARTITION BY department
        ) AS department_average

    FROM employees

)

SELECT *
FROM employee_data
WHERE salary > department_average;
```

## Example 3: Find the Latest Order for Each Customer

Assume an `orders` table:

```sql
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME,
    total_amount DECIMAL(10,2)
);
```

Query:

```sql
WITH ranked_orders AS (

    SELECT
        id,
        customer_id,
        order_date,
        total_amount,

        ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY order_date DESC, id DESC
        ) AS row_num

    FROM orders

)

SELECT *
FROM ranked_orders
WHERE row_num = 1;
```

This returns the latest order for every customer.

## Example 4: Calculate Running Account Balance

Assume a transactions table:

```sql
CREATE TABLE transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    transaction_date DATETIME,
    amount DECIMAL(10,2)
);
```

Query:

```sql
SELECT
    account_id,
    transaction_date,
    amount,

    SUM(amount) OVER(
        PARTITION BY account_id
        ORDER BY transaction_date, id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_balance

FROM transactions;
```

This calculates the running balance for each account, assuming `amount` contains positive credits and negative debits and the initial balance is zero.

## Example 5: Compare Current and Previous Employee Salary

Assume an `employee_salary_history` table:

```sql
CREATE TABLE employee_salary_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    salary DECIMAL(10,2),
    effective_date DATE
);
```

Query:

```sql
SELECT
    employee_id,
    effective_date,
    salary,

    LAG(salary) OVER(
        PARTITION BY employee_id
        ORDER BY effective_date, id
    ) AS previous_salary

FROM employee_salary_history;
```

This helps identify salary changes over time.

---

# 28. SQL Window Functions Interview Questions

### Beginner Level

1. What are window functions?
2. What is the purpose of OVER()?
3. What is PARTITION BY?
4. What is the difference between PARTITION BY and GROUP BY?
5. What is ORDER BY inside OVER()?
6. Does a window function reduce the number of rows?
7. What is ROW_NUMBER()?
8. What is RANK()?
9. What is DENSE_RANK()?
10. What is the difference between ROW_NUMBER(), RANK(), and DENSE_RANK()?

### Intermediate Level

11. What is NTILE()?
12. What is LAG()?
13. What is LEAD()?
14. What is FIRST_VALUE()?
15. What is LAST_VALUE()?
16. What is NTH_VALUE()?
17. What is a running total?
18. What is a moving average?
19. What is a window frame?
20. What is the difference between ROWS and RANGE?

### Advanced Level

21. What is the default frame when ORDER BY is specified?
22. Why can LAST_VALUE() return an unexpected result?
23. How do you find the second-highest salary using DENSE_RANK()?
24. How do you find the top three employees in each department?
25. How do you find the latest order per customer?
26. How do you calculate month-over-month growth?
27. How do you calculate a running balance?
28. What is a named window?
29. Can window functions be used directly in WHERE?
30. How do you optimize queries using window functions?

---

# 29. Practical Assignments

Use the employees and monthly_sales tables created earlier.

## Assignment 1 – Basic Window Functions

1. Display every employee with the company's average salary.
2. Display every employee with the company's total salary.
3. Calculate department-wise average salary.
4. Calculate department-wise maximum salary.
5. Calculate department-wise minimum salary.
6. Count employees in each department using a window function.

## Assignment 2 – Ranking Functions

1. Assign row numbers to employees based on salary.
2. Rank employees by salary.
3. Assign dense ranks based on salary.
4. Rank employees separately in each department.
5. Find the highest-paid employee in each department.
6. Find the second-highest-paid employee in each department.
7. Find the top three employees in each department.
8. Divide employees into four salary groups using NTILE().

## Assignment 3 – LAG() and LEAD()

1. Display previous month's sales.
2. Display next month's sales.
3. Calculate month-over-month sales difference.
4. Calculate month-over-month sales growth percentage.
5. Compare each employee's salary with the previous employee's salary.
6. Find the previous salary for every employee using salary history.

## Assignment 4 – Running Total and Moving Average

1. Calculate the running total of monthly sales.
2. Calculate the running average of monthly sales.
3. Calculate a three-month moving average.
4. Calculate department-wise running salary.
5. Calculate running transaction balance for each bank account.

## Assignment 5 – Advanced Window Functions

1. Find the second-highest salary in the company.
2. Find the top two salaries in every department.
3. Find employees earning more than their department average.
4. Find the latest order for every customer.
5. Find the first order for every customer.
6. Calculate cumulative revenue.
7. Calculate salary differences between consecutive salary-history records.
8. Use FIRST_VALUE() to find the highest-paid employee per department.
9. Use LAST_VALUE() to find the lowest-paid employee per department.
10. Use NTH_VALUE() to retrieve the third-highest-paid employee.

---

# 30. Phase 15 – Quick Revision Sheet

| Function / Concept | Purpose |
|---|---|
| OVER() | Defines the window |
| PARTITION BY | Divides rows into groups |
| ORDER BY | Defines ordering within the window |
| ROWS | Defines frame using row positions |
| RANGE | Defines frame using ordering values and peers |
| ROW_NUMBER() | Assigns unique sequential numbers |
| RANK() | Assigns ranks with gaps after ties |
| DENSE_RANK() | Assigns ranks without gaps |
| NTILE() | Divides rows into buckets |
| LAG() | Retrieves a previous row's value |
| LEAD() | Retrieves a future row's value |
| FIRST_VALUE() | Retrieves first value in frame |
| LAST_VALUE() | Retrieves last value in frame |
| NTH_VALUE() | Retrieves value at a specified position |
| SUM() OVER() | Calculates window sum |
| AVG() OVER() | Calculates window average |
| COUNT() OVER() | Calculates window count |
| MIN() OVER() | Calculates window minimum |
| MAX() OVER() | Calculates window maximum |
| WINDOW | Defines a reusable named window |

### Most Important Syntax

**Basic Window Function:**

```sql
SELECT
    column_name,
    function_name() OVER()
FROM table_name;
```

**Partitioning:**

```sql
SELECT
    column_name,
    AVG(salary) OVER(
        PARTITION BY department
    )
FROM employees;
```

**Ranking:**

```sql
SELECT
    name,
    RANK() OVER(
        ORDER BY salary DESC
    ) AS employee_rank
FROM employees;
```

**Running Total:**

```sql
SELECT
    SUM(sales) OVER(
        ORDER BY month_number
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_total
FROM monthly_sales;
```

**Previous Row:**

```sql
SELECT
    LAG(sales) OVER(
        ORDER BY month_number
    ) AS previous_sales
FROM monthly_sales;
```

**Top N Per Group:**

```sql
WITH ranked_data AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY department
            ORDER BY salary DESC, id
        ) AS row_num
    FROM employees
)

SELECT *
FROM ranked_data
WHERE row_num <= 3;
```

---

# 31. Phase 15 Completion Checklist

Before moving to Phase 16, make sure you understand:

- [ ] What are Window Functions?
- [ ] Aggregate Functions vs Window Functions.
- [ ] OVER() clause.
- [ ] PARTITION BY.
- [ ] ORDER BY inside OVER().
- [ ] ROW_NUMBER().
- [ ] RANK().
- [ ] DENSE_RANK().
- [ ] NTILE().
- [ ] LAG().
- [ ] LEAD().
- [ ] FIRST_VALUE().
- [ ] LAST_VALUE().
- [ ] NTH_VALUE().
- [ ] Running Total.
- [ ] Moving Average.
- [ ] Window Frames.
- [ ] ROWS vs RANGE.
- [ ] Top N records per group.
- [ ] Department-wise ranking.
- [ ] Named Windows.
- [ ] Window Functions with CTEs.
- [ ] Performance optimization.

**Phase 15 is complete when you can independently write ranking queries, calculate running totals, compare previous and next records, and solve top-N-per-group problems using window functions.**

---

## Next Phase: Phase 16 – Database Design and Relationships

In Phase 16, we will cover:

1. What is Database Design?
2. Database Schema.
3. Entities and Attributes.
4. Primary Keys and Foreign Keys.
5. One-to-One Relationships.
6. One-to-Many Relationships.
7. Many-to-Many Relationships.
8. Junction Tables.
9. Self-Referencing Relationships.
10. ER Diagrams.
11. Cardinality and Participation.
12. Designing an E-commerce Database.
13. Designing an Employee Management Database.
14. Designing a Library Management Database.
15. Database Design Best Practices.
16. Common Database Design Mistakes.
17. Interview Questions and Practical Assignments.

**Next: Phase 16 – Database Design and Relationships.**