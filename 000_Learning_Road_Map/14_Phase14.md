# SQL Complete Learning Roadmap
# Phase 14 – Common Table Expressions (CTEs)
### MySQL 8.0+

## 1. What Is a CTE?

CTE stands for **Common Table Expression**.

A CTE is a temporary named result set that you define inside a SQL query using the `WITH` clause.

It allows you to write complex queries in smaller, more readable steps.

Think of a CTE as a temporary table that exists only while a particular SQL statement is executing.

### Basic Example

Suppose you want to find employees whose salaries are greater than ₹50,000.

Without a CTE:

```sql
SELECT *
FROM employees
WHERE salary > 50000;
```

This query is simple, so a CTE is not necessary.

However, imagine that you first need to calculate average salary and then find employees earning more than that average.

You can use a CTE:

```sql
WITH average_salary AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
)

SELECT *
FROM employees
WHERE salary > (
    SELECT avg_salary
    FROM average_salary
);
```

Here:

1. `WITH` declares a CTE.
2. `average_salary` is the CTE name.
3. The query inside parentheses generates the CTE result.
4. The main SELECT query uses that result.

### Important

A CTE:
- Is not a permanently stored table.
- Exists only for the statement in which it is defined.
- Can be referenced by the main query.
- Can make complex queries easier to understand.
- Can reference other CTEs defined earlier in the same WITH clause.

---

# 2. Why Do We Need CTEs?

Before CTEs, developers commonly used subqueries and derived tables to organize complex SQL queries.

Consider this requirement:

**Find employees whose salary is greater than the average salary of all employees.**

### Approach 1: Using a Subquery

```sql
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

This is perfectly valid.

But imagine the same calculation needs to be reused multiple times in a larger query.

The query can become difficult to read and maintain.

### Approach 2: Using a CTE

```sql
WITH salary_data AS (
    SELECT AVG(salary) AS average_salary
    FROM employees
)

SELECT
    e.id,
    e.first_name,
    e.salary,
    s.average_salary
FROM employees e
CROSS JOIN salary_data s
WHERE e.salary > s.average_salary;
```

This separates the calculation from the main query.

### Advantages of CTEs

1. **Readability:** Break complex SQL into smaller steps.
2. **Reusability:** Reference a CTE multiple times in the same statement.
3. **Maintainability:** Make complicated queries easier to modify.
4. **Recursive queries:** Support hierarchical and tree-like data.
5. **Logical organization:** Give meaningful names to intermediate results.

---

# 3. Basic CTE Syntax

```sql
WITH cte_name AS (
    SELECT column1, column2
    FROM table_name
    WHERE condition
)

SELECT *
FROM cte_name;
```

### Explanation

| Component | Meaning |
|---|---|
| WITH | Starts the CTE declaration |
| cte_name | Name of the CTE |
| AS | Introduces the CTE query |
| SELECT | Defines the result set |
| Main SELECT | Uses the CTE |

### Example

```sql
WITH it_employees AS (
    SELECT *
    FROM employees
    WHERE department = 'IT'
)

SELECT *
FROM it_employees;
```

This query:
1. Creates a temporary result named `it_employees`.
2. Selects employees belonging to the IT department.
3. Retrieves all records from that result.

**Note:** The CTE name is not the same as a permanent table name. It is available only inside the statement.

---

# 4. Preparing Sample Database

Let's create a database for practical CTE examples.

```sql
CREATE DATABASE sql_cte_db;

USE sql_cte_db;

CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50)
);

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    salary DECIMAL(10,2),
    department_id INT,
    manager_id INT NULL,
    joining_date DATE,

    FOREIGN KEY (department_id)
        REFERENCES departments(id),

    FOREIGN KEY (manager_id)
        REFERENCES employees(id)
);
```

Insert departments:

```sql
INSERT INTO departments (department_name)
VALUES
('IT'),
('HR'),
('Finance'),
('Marketing');
```

Insert employees:

```sql
INSERT INTO employees
(first_name, salary, department_id, manager_id, joining_date)
VALUES
('Riyaz', 80000, 1, NULL, '2020-01-15'),
('John', 60000, 1, 1, '2021-03-10'),
('Sarah', 75000, 2, 1, '2021-06-20'),
('David', 45000, 2, 3, '2022-02-01'),
('Alex', 90000, 3, 1, '2019-08-15'),
('Michael', 55000, 3, 5, '2023-04-10'),
('Emma', 65000, 4, 1, '2022-09-05'),
('Robert', 40000, 4, 7, '2024-01-15');
```

### Employees Table

| id | first_name | salary | department_id | manager_id |
|---:|---|---:|---:|---:|
| 1 | Riyaz | 80000 | 1 | NULL |
| 2 | John | 60000 | 1 | 1 |
| 3 | Sarah | 75000 | 2 | 1 |
| 4 | David | 45000 | 2 | 3 |
| 5 | Alex | 90000 | 3 | 1 |
| 6 | Michael | 55000 | 3 | 5 |
| 7 | Emma | 65000 | 4 | 1 |
| 8 | Robert | 40000 | 4 | 7 |

### Departments Table

| id | department_name |
|---:|---|
| 1 | IT |
| 2 | HR |
| 3 | Finance |
| 4 | Marketing |

---

# 5. CTE with WHERE

You can use WHERE inside a CTE to filter records.

Example:

```sql
WITH high_salary_employees AS (
    SELECT *
    FROM employees
    WHERE salary > 60000
)

SELECT *
FROM high_salary_employees;
```

Output:

| id | first_name | salary |
|---:|---|---:|
| 1 | Riyaz | 80000 |
| 3 | Sarah | 75000 |
| 5 | Alex | 90000 |
| 7 | Emma | 65000 |

### CTE with additional filtering

You can also apply another WHERE condition in the main query.

```sql
WITH high_salary_employees AS (
    SELECT *
    FROM employees
    WHERE salary > 60000
)

SELECT *
FROM high_salary_employees
WHERE department_id = 1;
```

Output:

| id | first_name | salary | department_id |
|---:|---|---:|---:|
| 1 | Riyaz | 80000 | 1 |

The first condition filters the CTE result. The second condition filters the result returned by the main query.

---

# 6. CTE with GROUP BY

CTEs are particularly useful for aggregation queries.

Example:

**Find the total salary of each department.**

```sql
WITH department_salary AS (
    SELECT
        department_id,
        SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
)

SELECT *
FROM department_salary;
```

Output:

| department_id | total_salary |
|---:|---:|
| 1 | 140000 |
| 2 | 120000 |
| 3 | 145000 |
| 4 | 105000 |

### CTE with HAVING

Find departments whose total salary is greater than ₹120,000.

```sql
WITH department_salary AS (
    SELECT
        department_id,
        SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
)

SELECT *
FROM department_salary
WHERE total_salary > 120000;
```

Output:

| department_id | total_salary |
|---:|---:|
| 1 | 140000 |
| 3 | 145000 |

You can also use HAVING inside the CTE:

```sql
WITH department_salary AS (
    SELECT
        department_id,
        SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
    HAVING SUM(salary) > 120000
)

SELECT *
FROM department_salary;
```

Both approaches can produce the same result.

---

# 7. CTE with JOIN

You can join a CTE with another table.

Example:

**Display department names and their total salary.**

```sql
WITH department_salary AS (
    SELECT
        department_id,
        SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
)

SELECT
    d.department_name,
    ds.total_salary
FROM department_salary ds
INNER JOIN departments d
    ON ds.department_id = d.id;
```

Output:

| department_name | total_salary |
|---|---:|
| IT | 140000 |
| HR | 120000 |
| Finance | 145000 |
| Marketing | 105000 |

### Why is this useful?

You can calculate aggregated information in the CTE and then join it with other tables.

This is common in:
- Employee analytics.
- Sales reporting.
- Financial reports.
- Inventory management.
- E-commerce dashboards.

---

# 8. CTE with ORDER BY and LIMIT

You can sort and limit the data inside a CTE.

Example:

**Find the top three highest-paid employees.**

```sql
WITH top_employees AS (
    SELECT *
    FROM employees
    ORDER BY salary DESC
    LIMIT 3
)

SELECT *
FROM top_employees
ORDER BY salary DESC;
```

Output:

| id | first_name | salary |
|---:|---|---:|
| 5 | Alex | 90000 |
| 1 | Riyaz | 80000 |
| 3 | Sarah | 75000 |

The CTE identifies the top three employees, and the main query displays them in descending salary order.

**Important:** If multiple employees have the same salary and you need deterministic results, add a secondary sorting column such as `id`.

---

# 9. Multiple CTEs

You can declare multiple CTEs inside one `WITH` clause.

Separate CTE definitions using commas.

### Syntax

```sql
WITH
cte1 AS (
    SELECT ...
),

cte2 AS (
    SELECT ...
),

cte3 AS (
    SELECT ...
)

SELECT *
FROM cte1;
```

### Example

Find:
1. Average salary of employees.
2. Highest salary of employees.
3. Employees earning more than the average salary.

```sql
WITH
average_salary AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
),

highest_salary AS (
    SELECT MAX(salary) AS max_salary
    FROM employees
),

high_salary_employees AS (
    SELECT *
    FROM employees
    WHERE salary > (
        SELECT avg_salary
        FROM average_salary
    )
)

SELECT
    h.first_name,
    h.salary,
    a.avg_salary,
    m.max_salary
FROM high_salary_employees h
CROSS JOIN average_salary a
CROSS JOIN highest_salary m;
```

Output:

| first_name | salary | avg_salary | max_salary |
|---|---:|---:|---:|
| Riyaz | 80000 | 63750 | 90000 |
| Sarah | 75000 | 63750 | 90000 |
| Alex | 90000 | 63750 | 90000 |
| Emma | 65000 | 63750 | 90000 |

### Important Rule

A CTE can reference a CTE declared earlier in the same WITH clause.

For example:

```sql
WITH
department_data AS (
    SELECT
        department_id,
        SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
),

high_salary_departments AS (
    SELECT *
    FROM department_data
    WHERE total_salary > 120000
)

SELECT *
FROM high_salary_departments;
```

Here:
- `department_data` is defined first.
- `high_salary_departments` uses the first CTE.

The order matters for ordinary non-recursive CTE dependencies.

---

# 10. CTE with Subqueries

You can use subqueries inside CTEs and CTEs inside subqueries.

Example:

Find employees earning more than their department's average salary.

```sql
WITH department_average AS (
    SELECT
        department_id,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)

SELECT
    e.first_name,
    e.salary,
    e.department_id,
    da.avg_salary
FROM employees e
INNER JOIN department_average da
    ON e.department_id = da.department_id
WHERE e.salary > da.avg_salary;
```

Output:

| first_name | salary | department_id | avg_salary |
|---|---:|---:|---:|
| Riyaz | 80000 | 1 | 70000 |
| Sarah | 75000 | 2 | 60000 |
| Alex | 90000 | 3 | 72500 |
| Emma | 65000 | 4 | 52500 |

This is a common real-world reporting requirement.

---

# 11. CTE with UPDATE

In MySQL, you can use a CTE with UPDATE.

Example:

Increase the salary of employees earning less than ₹50,000 by 10%.

```sql
WITH low_salary_employees AS (
    SELECT id
    FROM employees
    WHERE salary < 50000
)

UPDATE employees
SET salary = salary * 1.10
WHERE id IN (
    SELECT id
    FROM low_salary_employees
);
```

The CTE identifies employees with low salaries.

The UPDATE statement increases their salaries.

**Important:** Always test the CTE's SELECT query before running an UPDATE on production data.

---

# 12. CTE with DELETE

You can also use a CTE with DELETE.

Example:

Delete employees whose salary is below ₹45,000.

```sql
WITH low_salary_employees AS (
    SELECT id
    FROM employees
    WHERE salary < 45000
)

DELETE FROM employees
WHERE id IN (
    SELECT id
    FROM low_salary_employees
);
```

This deletes matching employee records.

**Important:** DELETE permanently removes records unless the operation is protected by a transaction and can be rolled back.

Also, deleting an employee who is referenced by another employee's `manager_id` can fail because of the foreign key constraint.

---

# 13. Recursive CTEs

This is one of the most important advanced features of CTEs.

A recursive CTE is a CTE that references itself.

It is useful when data has hierarchical or tree-like relationships.

Examples:
- Employee management hierarchy.
- Organization charts.
- Category and subcategory trees.
- Folder structures.
- Product category hierarchies.
- Parent-child relationships.

### Normal CTE vs Recursive CTE

| Normal CTE | Recursive CTE |
|---|---|
| Does not reference itself | References itself |
| Executes a normal query | Repeatedly builds results |
| Useful for intermediate result sets | Useful for hierarchical data |
| Uses WITH | Uses WITH RECURSIVE |

### Recursive CTE Syntax

```sql
WITH RECURSIVE cte_name AS (

    -- Anchor member
    SELECT ...

    UNION ALL

    -- Recursive member
    SELECT ...
    FROM table_name
    JOIN cte_name
        ON condition
)

SELECT *
FROM cte_name;
```

A recursive CTE has two important components.

**1. Anchor Member**

The initial query that starts the recursion.

**2. Recursive Member**

The query that references the CTE itself and generates subsequent results.

The recursion stops when the recursive member produces no more rows, or when a configured recursion limit is reached.

---

# 14. Recursive CTE Example – Generate Numbers

Let's generate numbers from 1 to 10.

```sql
WITH RECURSIVE numbers AS (

    SELECT 1 AS number

    UNION ALL

    SELECT number + 1
    FROM numbers
    WHERE number < 10

)

SELECT *
FROM numbers;
```

Output:

| number |
|---:|
| 1 |
| 2 |
| 3 |
| 4 |
| 5 |
| 6 |
| 7 |
| 8 |
| 9 |
| 10 |

### Step-by-step execution

**Step 1 – Anchor Member**

```sql
SELECT 1 AS number;
```

Result:

```text
1
```

**Step 2 – First Recursive Execution**

```sql
SELECT number + 1
FROM numbers
WHERE number < 10;
```

Result:

```text
2
```

**Step 3 – Second Recursive Execution**

Result:

```text
3
```

The process continues:

```text
4
5
6
7
8
9
10
```

**Step 4 – Termination**

When the number reaches 10, the condition:

```sql
WHERE number < 10
```

becomes false.

No further rows are generated.

Therefore, recursion stops.

### Important

The condition that stops recursion is essential.

Without a valid stopping condition, the recursive query may continue until MySQL's recursion limit is reached.

---

# 15. Recursive CTE Example – Generate Even Numbers

Generate even numbers from 2 to 20.

```sql
WITH RECURSIVE even_numbers AS (

    SELECT 2 AS number

    UNION ALL

    SELECT number + 2
    FROM even_numbers
    WHERE number < 20

)

SELECT *
FROM even_numbers;
```

Output:

| number |
|---:|
| 2 |
| 4 |
| 6 |
| 8 |
| 10 |
| 12 |
| 14 |
| 16 |
| 18 |
| 20 |

### Generate Odd Numbers

```sql
WITH RECURSIVE odd_numbers AS (

    SELECT 1 AS number

    UNION ALL

    SELECT number + 2
    FROM odd_numbers
    WHERE number < 19

)

SELECT *
FROM odd_numbers;
```

---

# 16. Recursive CTE Example – Calculate Factorial

A factorial is the product of all positive integers from 1 to a given number.

For example:

```text
5! = 5 × 4 × 3 × 2 × 1 = 120
```

SQL example:

```sql
WITH RECURSIVE factorial AS (

    SELECT
        1 AS number,
        1 AS result

    UNION ALL

    SELECT
        number + 1,
        result * (number + 1)
    FROM factorial
    WHERE number < 5

)

SELECT *
FROM factorial;
```

Output:

| number | result |
|---:|---:|
| 1 | 1 |
| 2 | 2 |
| 3 | 6 |
| 4 | 24 |
| 5 | 120 |

The final result is:

```sql
WITH RECURSIVE factorial AS (

    SELECT 1 AS number, 1 AS result

    UNION ALL

    SELECT number + 1, result * (number + 1)
    FROM factorial
    WHERE number < 5

)

SELECT result
FROM factorial
WHERE number = 5;
```

Output:

```text
120
```

---

# 17. Recursive CTE Example – Employee Hierarchy

This is one of the most practical uses of recursive CTEs.

Suppose you have an employee table:

| id | first_name | manager_id |
|---:|---|---:|
| 1 | Riyaz | NULL |
| 2 | John | 1 |
| 3 | Sarah | 1 |
| 4 | David | 3 |
| 5 | Alex | 1 |
| 6 | Michael | 5 |
| 7 | Emma | 1 |
| 8 | Robert | 7 |

The structure represents:

```text
Riyaz
│
├── John
├── Sarah
│   └── David
├── Alex
│   └── Michael
└── Emma
    └── Robert
```

### Requirement

Find all employees reporting directly or indirectly to Riyaz.

### Recursive CTE

```sql
WITH RECURSIVE employee_hierarchy AS (

    -- Anchor member
    SELECT
        id,
        first_name,
        manager_id,
        1 AS level
    FROM employees
    WHERE id = 1

    UNION ALL

    -- Recursive member
    SELECT
        e.id,
        e.first_name,
        e.manager_id,
        eh.level + 1
    FROM employees e
    INNER JOIN employee_hierarchy eh
        ON e.manager_id = eh.id

)

SELECT *
FROM employee_hierarchy;
```

### Output

| id | first_name | manager_id | level |
|---:|---|---:|---:|
| 1 | Riyaz | NULL | 1 |
| 2 | John | 1 | 2 |
| 3 | Sarah | 1 | 2 |
| 5 | Alex | 1 | 2 |
| 7 | Emma | 1 | 2 |
| 4 | David | 3 | 3 |
| 6 | Michael | 5 | 3 |
| 8 | Robert | 7 | 3 |

### Understanding the Query

**Anchor member:**

```sql
SELECT
    id,
    first_name,
    manager_id,
    1 AS level
FROM employees
WHERE id = 1
```

This starts with Riyaz.

**Recursive member:**

```sql
SELECT
    e.id,
    e.first_name,
    e.manager_id,
    eh.level + 1
FROM employees e
INNER JOIN employee_hierarchy eh
    ON e.manager_id = eh.id
```

This finds employees whose manager is already present in the hierarchy.

The process repeats until no more employees are found.

### Find Only Employees Under Riyaz

If you do not want to include Riyaz himself:

```sql
WITH RECURSIVE employee_hierarchy AS (

    SELECT
        id,
        first_name,
        manager_id,
        1 AS level
    FROM employees
    WHERE id = 1

    UNION ALL

    SELECT
        e.id,
        e.first_name,
        e.manager_id,
        eh.level + 1
    FROM employees e
    INNER JOIN employee_hierarchy eh
        ON e.manager_id = eh.id

)

SELECT *
FROM employee_hierarchy
WHERE id <> 1;
```

### Find Direct Reports Only

You do not need recursion for direct reports.

```sql
SELECT *
FROM employees
WHERE manager_id = 1;
```

Recursive CTEs become useful when you need employees at every level.

---

# 18. Recursive CTE Example – Generate a Date Range

Suppose you want to generate all dates between November 1 and November 10.

```sql
WITH RECURSIVE date_range AS (

    SELECT DATE('2026-11-01') AS date_value

    UNION ALL

    SELECT DATE_ADD(date_value, INTERVAL 1 DAY)
    FROM date_range
    WHERE date_value < '2026-11-10'

)

SELECT *
FROM date_range;
```

Output:

| date_value |
|---|
| 2026-11-01 |
| 2026-11-02 |
| 2026-11-03 |
| 2026-11-04 |
| 2026-11-05 |
| 2026-11-06 |
| 2026-11-07 |
| 2026-11-08 |
| 2026-11-09 |
| 2026-11-10 |

### Real-world use cases

- Generate calendar dates.
- Identify missing attendance records.
- Build daily sales reports.
- Generate monthly billing periods.
- Create date-based analytical reports.

---

# 19. Recursive CTE – Working with Hierarchical Categories

Imagine an e-commerce application with nested product categories.

Example:

```text
Electronics
│
├── Computers
│   ├── Laptops
│   └── Desktops
│
└── Mobiles
    ├── Android
    └── iPhone
```

Create a table:

```sql
CREATE TABLE categories (
    id INT PRIMARY KEY,
    category_name VARCHAR(100),
    parent_id INT NULL,

    FOREIGN KEY (parent_id)
        REFERENCES categories(id)
);
```

Insert records:

```sql
INSERT INTO categories
VALUES
(1, 'Electronics', NULL),
(2, 'Computers', 1),
(3, 'Laptops', 2),
(4, 'Desktops', 2),
(5, 'Mobiles', 1),
(6, 'Android', 5),
(7, 'iPhone', 5);
```

### Find All Subcategories of Electronics

```sql
WITH RECURSIVE category_tree AS (

    SELECT
        id,
        category_name,
        parent_id,
        1 AS level
    FROM categories
    WHERE id = 1

    UNION ALL

    SELECT
        c.id,
        c.category_name,
        c.parent_id,
        ct.level + 1
    FROM categories c
    INNER JOIN category_tree ct
        ON c.parent_id = ct.id

)

SELECT *
FROM category_tree
ORDER BY level, id;
```

Output:

| id | category_name | parent_id | level |
|---:|---|---:|---:|
| 1 | Electronics | NULL | 1 |
| 2 | Computers | 1 | 2 |
| 5 | Mobiles | 1 | 2 |
| 3 | Laptops | 2 | 3 |
| 4 | Desktops | 2 | 3 |
| 6 | Android | 5 | 3 |
| 7 | iPhone | 5 | 3 |

This is a common requirement in e-commerce applications.

---

# 20. Recursive CTE – Controlling Recursion Depth

MySQL has a system variable:

```sql
cte_max_recursion_depth
```

It controls the maximum recursion depth for recursive CTEs.

The default value is generally:

```text
1000
```

Check the current value:

```sql
SELECT @@cte_max_recursion_depth;
```

Change it for the current session:

```sql
SET SESSION cte_max_recursion_depth = 2000;
```

You can also set it for an individual query using an optimizer hint:

```sql
WITH RECURSIVE numbers AS (

    SELECT 1 AS number

    UNION ALL

    SELECT number + 1
    FROM numbers
    WHERE number < 1500

)

SELECT /*+ SET_VAR(cte_max_recursion_depth = 2000) */
    *
FROM numbers;
```

**Important:** Increasing the recursion limit does not fix infinite recursion or incorrect recursive logic.

Always design a proper termination condition.

---

# 21. Recursive CTE – Cycle Prevention

Hierarchical data can sometimes contain circular references.

For example:

```text
Employee A → Employee B
Employee B → Employee C
Employee C → Employee A
```

This creates a cycle.

A recursive query can repeatedly revisit the same records.

One approach is to track visited IDs.

Example:

```sql
WITH RECURSIVE employee_hierarchy AS (

    SELECT
        id,
        first_name,
        manager_id,
        CAST(id AS CHAR(2000)) AS visited_path,
        1 AS level
    FROM employees
    WHERE id = 1

    UNION ALL

    SELECT
        e.id,
        e.first_name,
        e.manager_id,
        CONCAT(eh.visited_path, ',', e.id),
        eh.level + 1
    FROM employees e
    INNER JOIN employee_hierarchy eh
        ON e.manager_id = eh.id
    WHERE FIND_IN_SET(
        CAST(e.id AS CHAR),
        eh.visited_path
    ) = 0

)

SELECT *
FROM employee_hierarchy;
```

This prevents revisiting an ID already present in the current path.

For complex hierarchical systems, consider using MySQL's recursive CTE cycle-detection capabilities where appropriate, or enforce acyclic relationships at the application/database design level.

---

# 22. CTE vs Subquery vs Derived Table vs Temporary Table

These concepts are related but different.

| Feature | CTE | Subquery | Derived Table | Temporary Table |
|---|---|---|---|---|
| Definition | WITH clause | Query inside another query | Subquery in FROM | CREATE TEMPORARY TABLE |
| Named result | Yes | Not necessarily | Usually has an alias | Yes |
| Reuse in same statement | Yes | Limited | Limited | Yes |
| Exists across statements | No | No | No | Yes, within session |
| Recursive support | Yes | No direct recursive syntax | No direct recursive syntax | Can be used with iterative logic |
| Physical storage | Optimizer-dependent | Optimizer-dependent | Optimizer-dependent | Stored as a temporary table |

### Example: Subquery

```sql
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

### Example: CTE

```sql
WITH average_salary AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
)

SELECT *
FROM employees
WHERE salary > (
    SELECT avg_salary
    FROM average_salary
);
```

### Example: Derived Table

```sql
SELECT *
FROM (
    SELECT
        department_id,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS department_data
WHERE avg_salary > 60000;
```

### Example: Temporary Table

```sql
CREATE TEMPORARY TABLE high_salary_employees AS
SELECT *
FROM employees
WHERE salary > 60000;
```

You can now use it in multiple statements during the session:

```sql
SELECT *
FROM high_salary_employees;
```

Remove it:

```sql
DROP TEMPORARY TABLE high_salary_employees;
```

**Important:** A CTE is not automatically faster than a subquery or temporary table. Choose based on readability, reuse requirements, and execution plans.

---

# 23. CTE Performance and Optimization

CTEs improve readability, but they do not guarantee better performance.

MySQL can process CTEs in different ways depending on the query.

### 23.1 CTE Merging

MySQL may merge a non-recursive CTE into the outer query.

This means the optimizer can combine the CTE logic with the main query instead of creating a separate materialized result.

### 23.2 CTE Materialization

MySQL may materialize a CTE into an internal temporary result.

This can be useful when a CTE is referenced multiple times.

However, materialization can also introduce additional processing and memory/storage requirements.

### 23.3 Multiple References

Example:

```sql
WITH department_salary AS (
    SELECT
        department_id,
        SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
)

SELECT *
FROM department_salary a
JOIN department_salary b
    ON a.department_id = b.department_id;
```

Here, the CTE is referenced more than once.

The optimizer decides how to process it.

### 23.4 Use EXPLAIN

You can inspect the execution plan:

```sql
EXPLAIN
WITH department_salary AS (
    SELECT
        department_id,
        SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
)

SELECT *
FROM department_salary;
```

For more detailed execution information:

```sql
EXPLAIN ANALYZE
WITH department_salary AS (
    SELECT
        department_id,
        SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
)

SELECT *
FROM department_salary;
```

`EXPLAIN ANALYZE` executes the query and reports actual execution information.

Use it carefully with expensive queries.

### Performance Best Practices

1. Avoid unnecessary CTEs for simple queries.
2. Give CTEs meaningful names.
3. Select only the required columns.
4. Apply filters as early as appropriate.
5. Ensure join columns are indexed where beneficial.
6. Avoid unnecessary repeated calculations.
7. Check execution plans.
8. Ensure recursive queries have proper termination conditions.
9. Avoid excessively deep recursion.
10. Test performance with realistic data volumes.

---

# 24. Common Mistakes

### Mistake 1: Forgetting the WITH Clause

Incorrect:

```sql
high_salary AS (
    SELECT *
    FROM employees
);
```

Correct:

```sql
WITH high_salary AS (
    SELECT *
    FROM employees
)
SELECT *
FROM high_salary;
```

### Mistake 2: Forgetting the Main Query

A CTE declaration must be followed by a statement that uses it.

```sql
WITH high_salary AS (
    SELECT *
    FROM employees
    WHERE salary > 60000
)

SELECT *
FROM high_salary;
```

### Mistake 3: Referencing a CTE Before It Is Defined

For ordinary non-recursive CTEs, define dependencies before the CTE that references them.

### Mistake 4: Missing the Recursive Stopping Condition

Incorrect recursive logic can continue until the recursion limit is reached.

Always include a condition that eventually stops generating rows.

### Mistake 5: Confusing CTEs with Permanent Tables

A CTE is not saved permanently.

You cannot expect it to exist in the next SQL statement.

### Mistake 6: Assuming CTEs Are Always Faster

A CTE is primarily a query organization feature.

Performance depends on the execution plan and optimizer decisions.

### Mistake 7: Using UNION Instead of UNION ALL in Recursive CTEs Without Understanding the Difference

Recursive CTEs commonly use UNION ALL.

Using UNION performs duplicate elimination and can change both the result and execution cost.

Choose the operator based on the intended recursion behavior.

---

# 25. Real-World Practical Examples

## Example 1: Department-Wise Average Salary

```sql
WITH department_average AS (
    SELECT
        department_id,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)

SELECT
    d.department_name,
    ROUND(da.avg_salary, 2) AS average_salary
FROM department_average da
JOIN departments d
    ON da.department_id = d.id;
```

## Example 2: Employees Earning Above Company Average

```sql
WITH company_average AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
)

SELECT
    first_name,
    salary
FROM employees
WHERE salary > (
    SELECT avg_salary
    FROM company_average
);
```

## Example 3: Department with Highest Total Salary

```sql
WITH department_salary AS (
    SELECT
        department_id,
        SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
)

SELECT
    d.department_name,
    ds.total_salary
FROM department_salary ds
JOIN departments d
    ON ds.department_id = d.id
ORDER BY ds.total_salary DESC
LIMIT 1;
```

## Example 4: Find Employees with More Than Five Years of Experience

```sql
WITH employee_experience AS (
    SELECT
        id,
        first_name,
        joining_date,
        TIMESTAMPDIFF(
            YEAR,
            joining_date,
            CURDATE()
        ) AS experience_years
    FROM employees
)

SELECT *
FROM employee_experience
WHERE experience_years >= 5;
```

## Example 5: Organization Hierarchy

```sql
WITH RECURSIVE organization AS (

    SELECT
        id,
        first_name,
        manager_id,
        1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.id,
        e.first_name,
        e.manager_id,
        o.level + 1
    FROM employees e
    JOIN organization o
        ON e.manager_id = o.id

)

SELECT *
FROM organization
ORDER BY level, id;
```

---

# 26. SQL CTE Interview Questions

### Beginner Level

1. What is a CTE?
2. What does CTE stand for?
3. What is the purpose of the WITH clause?
4. What is the difference between a CTE and a normal table?
5. How do you create a CTE?
6. Can you use WHERE inside a CTE?
7. Can you use GROUP BY inside a CTE?
8. Can you join a CTE with another table?
9. Can you create multiple CTEs in one query?
10. Does a CTE permanently store data?

### Intermediate Level

11. What is the difference between a CTE and a subquery?
12. What is the difference between a CTE and a derived table?
13. What is a recursive CTE?
14. What are the anchor and recursive members?
15. Can a CTE reference another CTE?
16. Can you use a CTE with UPDATE?
17. Can you use a CTE with DELETE?
18. What is the purpose of UNION ALL in recursive CTEs?
19. What happens if a recursive CTE has no termination condition?
20. What is `cte_max_recursion_depth`?

### Advanced Level

21. What is the difference between recursive and non-recursive CTEs?
22. How can you generate a sequence of numbers using a recursive CTE?
23. How can you generate a date range using a recursive CTE?
24. How can you retrieve an employee hierarchy using a recursive CTE?
25. How can you retrieve nested product categories?
26. What is CTE materialization?
27. What is CTE merging?
28. Does a CTE always improve query performance?
29. How do you prevent infinite recursion?
30. How can you analyze CTE performance using EXPLAIN ANALYZE?

---

# 27. Practical Assignments

Use the `sql_cte_db` database and the tables created earlier.

## Assignment 1 – Basic CTE

1. Create a CTE containing employees with salaries greater than ₹50,000.
2. Display employees belonging to the IT department.
3. Find employees who joined after January 1, 2022.
4. Find employees whose salary is between ₹50,000 and ₹80,000.
5. Display employees whose names start with `R`.

## Assignment 2 – Aggregation with CTE

1. Calculate total salary for each department.
2. Calculate average salary for each department.
3. Find departments whose average salary is greater than ₹60,000.
4. Find the department with the highest total salary.
5. Find the department with the lowest average salary.

## Assignment 3 – Multiple CTEs

1. Create a CTE for average company salary.
2. Create another CTE for maximum company salary.
3. Use both CTEs in one query.
4. Create a CTE for department salary totals.
5. Create another CTE to filter departments with total salary above ₹120,000.

## Assignment 4 – Recursive CTE

1. Generate numbers from 1 to 100.
2. Generate even numbers from 1 to 100.
3. Generate odd numbers from 1 to 100.
4. Generate dates for an entire month.
5. Generate factorial values from 1 to 10.
6. Retrieve all employees reporting to Riyaz.
7. Retrieve all employees at level 3.
8. Retrieve all subcategories of Electronics.
9. Display employee hierarchy with indentation.
10. Prevent cycles in hierarchical data.

## Assignment 5 – Advanced

1. Find employees earning more than their department average.
2. Find employees earning more than the company average.
3. Find the top three highest-paid employees.
4. Find departments with total salary greater than the company average salary multiplied by the department's employee count.
5. Generate a date range and identify dates without attendance records.
6. Create a hierarchical organization report using recursive CTEs.

---

# 28. Phase 14 – Quick Revision Sheet

| Concept | Description |
|---|---|
| CTE | Common Table Expression |
| WITH | Declares a CTE |
| CTE Name | Name assigned to the temporary result |
| Non-recursive CTE | CTE that does not reference itself |
| Recursive CTE | CTE that references itself |
| WITH RECURSIVE | Declares a recursive CTE |
| Anchor Member | Initial query of recursive CTE |
| Recursive Member | Query that references the CTE itself |
| UNION ALL | Combines anchor and recursive results while preserving duplicates |
| Recursion Depth | Maximum permitted recursive iterations |
| Materialization | Storing intermediate results internally |
| CTE Merging | Combining CTE logic with the outer query |

### Important Syntax

**Basic CTE:**

```sql
WITH cte_name AS (
    SELECT ...
)

SELECT *
FROM cte_name;
```

**Multiple CTEs:**

```sql
WITH
cte1 AS (
    SELECT ...
),

cte2 AS (
    SELECT ...
)

SELECT *
FROM cte1
JOIN cte2;
```

**Recursive CTE:**

```sql
WITH RECURSIVE cte_name AS (

    SELECT ...

    UNION ALL

    SELECT ...
    FROM cte_name
    WHERE condition

)

SELECT *
FROM cte_name;
```

---

# 29. Phase 14 Completion Checklist

Before moving to Phase 15, make sure you understand:

- [ ] What is a CTE?
- [ ] Why do we need CTEs?
- [ ] WITH clause.
- [ ] Basic CTE syntax.
- [ ] CTE with WHERE.
- [ ] CTE with GROUP BY and HAVING.
- [ ] CTE with JOIN.
- [ ] CTE with ORDER BY and LIMIT.
- [ ] Multiple CTEs.
- [ ] CTE with subqueries.
- [ ] CTE with UPDATE and DELETE.
- [ ] Recursive CTEs.
- [ ] Anchor and recursive members.
- [ ] Number generation.
- [ ] Factorial calculation.
- [ ] Employee hierarchy.
- [ ] Date range generation.
- [ ] Hierarchical categories.
- [ ] Recursion depth and cycle prevention.
- [ ] CTE vs Subquery vs Derived Table vs Temporary Table.
- [ ] CTE performance and optimization.
- [ ] EXPLAIN and EXPLAIN ANALYZE.

**Phase 14 is complete when you can organize complex queries using CTEs and independently write recursive queries for hierarchical data.**

---

## Next Phase: Phase 15 – SQL Window Functions

This is one of the most important advanced SQL topics, particularly for backend development, analytics, and technical interviews.

We will cover:

1. What are Window Functions?
2. Window Functions vs Aggregate Functions.
3. OVER() clause.
4. PARTITION BY.
5. ORDER BY inside OVER().
6. ROW_NUMBER().
7. RANK().
8. DENSE_RANK().
9. NTILE().
10. LAG() and LEAD().
11. FIRST_VALUE() and LAST_VALUE().
12. NTH_VALUE().
13. Running Total.
14. Moving Average.
15. Window Frames – ROWS and RANGE.
16. Top N records per group.
17. Department-wise salary ranking.
18. Advanced analytical queries.
19. Performance optimization.
20. Interview questions and practical assignments.

**Next: Phase 15 – SQL Window Functions.**