# SQL Complete Learning Roadmap
# Phase 13 – SQL Set Operations (MySQL 8.0+)

## 1. What Are SQL Set Operations?

Set operations are used to combine the results of two or more `SELECT` queries into a single result set.

For example, imagine you have two tables:

**employees_2025**

| id | name | department |
|---:|---|---|
| 1 | Riyaz | IT |
| 2 | John | HR |
| 3 | Sarah | Finance |

**employees_2026**

| id | name | department |
|---:|---|---|
| 2 | John | HR |
| 3 | Sarah | Finance |
| 4 | David | IT |

You want to combine employee records from both tables.

Instead of writing separate SELECT queries, you can use set operations.

### Types of Set Operations

| Operation | Purpose |
|---|---|
| UNION | Combines results and removes duplicates |
| UNION ALL | Combines results and keeps duplicates |
| INTERSECT | Returns common records |
| EXCEPT | Returns records from the first query that are absent from the second |

**MySQL support:**

- UNION: Supported.
- UNION ALL: Supported.
- INTERSECT: Supported in MySQL 8.0.31+.
- EXCEPT: Supported in MySQL 8.0.31+.

---

# 2. Preparing Sample Tables

Let's create two tables for practical examples.

```sql
CREATE DATABASE sql_set_operations_db;

USE sql_set_operations_db;

CREATE TABLE employees_2025 (
    id INT,
    name VARCHAR(50),
    department VARCHAR(50)
);

CREATE TABLE employees_2026 (
    id INT,
    name VARCHAR(50),
    department VARCHAR(50)
);
```

Insert records:

```sql
INSERT INTO employees_2025
VALUES
(1, 'Riyaz', 'IT'),
(2, 'John', 'HR'),
(3, 'Sarah', 'Finance'),
(5, 'Alex', 'Marketing');

INSERT INTO employees_2026
VALUES
(2, 'John', 'HR'),
(3, 'Sarah', 'Finance'),
(4, 'David', 'IT'),
(6, 'Michael', 'Sales');
```

### employees_2025

| id | name | department |
|---:|---|---|
| 1 | Riyaz | IT |
| 2 | John | HR |
| 3 | Sarah | Finance |
| 5 | Alex | Marketing |

### employees_2026

| id | name | department |
|---:|---|---|
| 2 | John | HR |
| 3 | Sarah | Finance |
| 4 | David | IT |
| 6 | Michael | Sales |

We will use these tables throughout this phase.

---

# 3. UNION

`UNION` combines the results of multiple SELECT queries and removes duplicate rows.

### Syntax

```sql
SELECT column1, column2
FROM table1

UNION

SELECT column1, column2
FROM table2;
```

### Example

```sql
SELECT id, name, department
FROM employees_2025

UNION

SELECT id, name, department
FROM employees_2026;
```

### Output

| id | name | department |
|---:|---|---|
| 1 | Riyaz | IT |
| 2 | John | HR |
| 3 | Sarah | Finance |
| 4 | David | IT |
| 5 | Alex | Marketing |
| 6 | Michael | Sales |

Notice that John and Sarah appear only once, even though they exist in both tables.

**Why?**

Because `UNION` removes duplicate rows from the combined result.

### Important points

1. UNION combines results vertically.
2. Duplicate rows are removed.
3. Each SELECT must return the same number of columns.
4. Corresponding columns must have compatible data types.
5. Column names in the final result are generally taken from the first SELECT.

---

# 4. UNION ALL

`UNION ALL` combines results without removing duplicates.

### Syntax

```sql
SELECT column1, column2
FROM table1

UNION ALL

SELECT column1, column2
FROM table2;
```

### Example

```sql
SELECT id, name, department
FROM employees_2025

UNION ALL

SELECT id, name, department
FROM employees_2026;
```

### Output

| id | name | department |
|---:|---|---|
| 1 | Riyaz | IT |
| 2 | John | HR |
| 3 | Sarah | Finance |
| 5 | Alex | Marketing |
| 2 | John | HR |
| 3 | Sarah | Finance |
| 4 | David | IT |
| 6 | Michael | Sales |

Notice that John and Sarah appear twice.

### Why use UNION ALL?

Because sometimes duplicate records are meaningful.

For example:
- Combining transaction records.
- Combining monthly sales.
- Combining employee attendance records.
- Combining application logs.
- Combining historical data.

---

# 5. UNION vs UNION ALL

This is an important SQL interview question.

| Feature | UNION | UNION ALL |
|---|---|---|
| Combines multiple queries | Yes | Yes |
| Removes duplicate rows | Yes | No |
| Keeps duplicate rows | No | Yes |
| Performance | Generally slower | Generally faster |
| Duplicate elimination | Required | Not required |
| Use case | Unique combined results | Preserve all records |

### Performance Example

Consider two tables containing one million records each.

```sql
SELECT id FROM table1
UNION
SELECT id FROM table2;
```

MySQL needs to eliminate duplicate rows.

But:

```sql
SELECT id FROM table1
UNION ALL
SELECT id FROM table2;
```

MySQL does not need to perform duplicate elimination.

Therefore, `UNION ALL` is generally more efficient.

**Best practice:** Use `UNION ALL` when you do not need duplicate removal.

---

# 6. INTERSECT

`INTERSECT` returns only the records that exist in both query results.

Think of it as finding common records.

### Syntax

```sql
SELECT column1, column2
FROM table1

INTERSECT

SELECT column1, column2
FROM table2;
```

### Example

```sql
SELECT id, name, department
FROM employees_2025

INTERSECT

SELECT id, name, department
FROM employees_2026;
```

### Output

| id | name | department |
|---:|---|---|
| 2 | John | HR |
| 3 | Sarah | Finance |

Why?

Because John and Sarah exist in both result sets with matching values in all selected columns.

### Important points

1. INTERSECT returns common rows.
2. Duplicate rows are eliminated by default.
3. Both queries must return the same number of compatible columns.
4. MySQL supports INTERSECT starting from version 8.0.31.

### INTERSECT ALL

MySQL 8.0.31+ also supports:

```sql
SELECT id, name, department
FROM employees_2025

INTERSECT ALL

SELECT id, name, department
FROM employees_2026;
```

`INTERSECT ALL` preserves duplicate occurrences up to the number present in both result sets.

---

# 7. EXCEPT

`EXCEPT` returns records from the first query that do not exist in the second query.

Think of it as finding the difference between two result sets.

### Syntax

```sql
SELECT column1, column2
FROM table1

EXCEPT

SELECT column1, column2
FROM table2;
```

### Example

```sql
SELECT id, name, department
FROM employees_2025

EXCEPT

SELECT id, name, department
FROM employees_2026;
```

### Output

| id | name | department |
|---:|---|---|
| 1 | Riyaz | IT |
| 5 | Alex | Marketing |

Why?

Because Riyaz and Alex exist in `employees_2025` but not in `employees_2026`.

### EXCEPT ALL

MySQL 8.0.31+ supports:

```sql
SELECT id, name, department
FROM employees_2025

EXCEPT ALL

SELECT id, name, department
FROM employees_2026;
```

`EXCEPT ALL` preserves the remaining duplicate occurrences rather than eliminating all duplicates.

---

# 8. Understanding All Four Operations Visually

Suppose:

**Set A:** 1, 2, 3, 4

**Set B:** 3, 4, 5, 6

| Operation | Result |
|---|---|
| UNION | 1, 2, 3, 4, 5, 6 |
| UNION ALL | 1, 2, 3, 4, 3, 4, 5, 6 |
| INTERSECT | 3, 4 |
| EXCEPT (A EXCEPT B) | 1, 2 |

Remember:

- UNION = A + B, unique rows.
- UNION ALL = A + B, all rows.
- INTERSECT = A ∩ B.
- EXCEPT = A − B.

---

# 9. Rules for Using Set Operations

There are some important rules when combining SELECT queries.

## Rule 1: Same Number of Columns

This is valid:

```sql
SELECT id, name
FROM employees_2025

UNION

SELECT id, name
FROM employees_2026;
```

This is invalid:

```sql
SELECT id, name
FROM employees_2025

UNION

SELECT id, name, department
FROM employees_2026;
```

Because the first query returns two columns and the second returns three.

## Rule 2: Compatible Data Types

Corresponding columns should have compatible data types.

Example:

```sql
SELECT id, name
FROM employees_2025

UNION

SELECT id, department
FROM employees_2026;
```

This may execute because MySQL can find a common result type for the corresponding columns.

However, it is logically confusing because the second column represents different information.

**Best practice:** Keep corresponding columns semantically meaningful and use compatible types.

## Rule 3: Column Names Come from the First SELECT

Example:

```sql
SELECT
    id AS employee_id,
    name AS employee_name
FROM employees_2025

UNION

SELECT
    id AS id_number,
    name AS full_name
FROM employees_2026;
```

The resulting column names are:

| employee_id | employee_name |
|---|---|

The aliases from the second SELECT do not replace the first SELECT's column names.

## Rule 4: Column Order Matters

Example:

```sql
SELECT id, name
FROM employees_2025

UNION

SELECT name, id
FROM employees_2026;
```

This is not equivalent to matching columns by their names.

SQL set operations match columns by their **position**, not by their aliases.

Always maintain the same logical column order.

---

# 10. ORDER BY with UNION

You can sort the final combined result using `ORDER BY`.

### Example

```sql
SELECT id, name, department
FROM employees_2025

UNION

SELECT id, name, department
FROM employees_2026

ORDER BY name ASC;
```

This sorts the combined result by employee name.

### Output

| id | name | department |
|---:|---|---|
| 5 | Alex | Marketing |
| 4 | David | IT |
| 2 | John | HR |
| 6 | Michael | Sales |
| 1 | Riyaz | IT |
| 3 | Sarah | Finance |

**Important:** The final `ORDER BY` applies to the entire combined result, not independently to each SELECT.

---

# 11. LIMIT with UNION

You can use `LIMIT` to restrict the number of records returned.

Example:

```sql
SELECT id, name
FROM employees_2025

UNION

SELECT id, name
FROM employees_2026

ORDER BY id

LIMIT 3;
```

Output:

| id | name |
|---:|---|
| 1 | Riyaz |
| 2 | John |
| 3 | Sarah |

The final result contains only three records.

### LIMIT with OFFSET

```sql
SELECT id, name
FROM employees_2025

UNION

SELECT id, name
FROM employees_2026

ORDER BY id

LIMIT 3 OFFSET 2;
```

This skips the first two records and returns the next three.

---

# 12. ORDER BY and LIMIT Inside Individual Queries

Sometimes you may want to limit each SELECT independently before combining the results.

Use parentheses to make the query structure clear.

Example:

```sql
(
    SELECT id, name
    FROM employees_2025
    ORDER BY id DESC
    LIMIT 2
)

UNION ALL

(
    SELECT id, name
    FROM employees_2026
    ORDER BY id DESC
    LIMIT 2
);
```

This selects the two highest-ID employees from each table and combines the results.

**Important:** Parentheses help define individual query scopes. Do not confuse an individual query's ordering with ordering of the final combined result.

---

# 13. Multiple UNION Operations

You can combine more than two SELECT queries.

Example:

```sql
SELECT id, name
FROM employees_2025

UNION

SELECT id, name
FROM employees_2026

UNION

SELECT id, name
FROM employees_2025;
```

MySQL combines all three result sets and removes duplicate rows.

You can also use UNION ALL multiple times:

```sql
SELECT id, name
FROM employees_2025

UNION ALL

SELECT id, name
FROM employees_2026

UNION ALL

SELECT id, name
FROM employees_2025;
```

This preserves all rows, including repeated results from the same table.

---

# 14. Combining Set Operations

You can combine different set operations in one query.

Example:

```sql
(
    SELECT id, name
    FROM employees_2025

    UNION

    SELECT id, name
    FROM employees_2026
)

EXCEPT

SELECT id, name
FROM employees_2026;
```

This first combines both employee lists and then removes records found in the 2026 list.

Result:

| id | name |
|---:|---|
| 1 | Riyaz |
| 5 | Alex |

### Important: Operator Precedence

When combining different set operators, do not rely on assumptions about evaluation order.

Use parentheses to explicitly control the intended grouping.

This improves readability and avoids ambiguity.

---

# 15. Set Operations vs JOIN

This is a very important concept.

Both set operations and JOIN can combine data, but they solve different problems.

## Set Operations

Set operations combine rows vertically.

Example:

```sql
SELECT id, name
FROM employees_2025

UNION

SELECT id, name
FROM employees_2026;
```

Conceptually:

```text
Table 1
   |
   v
Table 2
   |
   v
Combined Rows
```

## JOIN

JOIN combines columns horizontally by matching related rows.

Example:

```sql
SELECT
    employees.id,
    employees.name,
    departments.department_name
FROM employees
INNER JOIN departments
    ON employees.department_id = departments.id;
```

Conceptually:

```text
Employees Table + Departments Table
                  |
                  v
             Combined Columns
```

### Comparison

| Feature | Set Operations | JOIN |
|---|---|---|
| Combines | Rows | Columns |
| Purpose | Combine result sets | Relate records |
| Matching condition | Not required | Usually uses ON |
| Column count | Must match | Can differ |
| Examples | UNION, INTERSECT, EXCEPT | INNER, LEFT, RIGHT |

**Remember:**

- UNION combines rows.
- JOIN combines columns.

---

# 16. Real-World Use Cases

## Example 1: Combining Monthly Sales

Imagine you have separate monthly sales tables:

- sales_january
- sales_february
- sales_march

You can combine them:

```sql
SELECT order_id, customer_id, amount
FROM sales_january

UNION ALL

SELECT order_id, customer_id, amount
FROM sales_february

UNION ALL

SELECT order_id, customer_id, amount
FROM sales_march;
```

Why UNION ALL?

Because each sales transaction should remain in the result, even if two transactions have identical values.

## Example 2: Find Employees Present in Both Years

```sql
SELECT id, name
FROM employees_2025

INTERSECT

SELECT id, name
FROM employees_2026;
```

Useful for identifying employees who appear in both yearly datasets.

## Example 3: Find Employees Who Left

```sql
SELECT id, name
FROM employees_2025

EXCEPT

SELECT id, name
FROM employees_2026;
```

This identifies employees who were present in 2025 but not in 2026.

Note: This assumes the datasets use consistent employee identifiers and represent comparable snapshots.

## Example 4: Combine Customer Lists from Different Sources

```sql
SELECT customer_id, email
FROM website_customers

UNION

SELECT customer_id, email
FROM mobile_app_customers;
```

This produces a unique combined list based on both selected column values.

If you need to identify the same customer across sources, a reliable customer identifier is preferable to relying only on email.

## Example 5: Find Products Available in Both Warehouses

```sql
SELECT product_id
FROM warehouse_a

INTERSECT

SELECT product_id
FROM warehouse_b;
```

This returns products available in both warehouses.

---

# 17. How to Use Set Operations Without INTERSECT and EXCEPT

Although MySQL 8.0.31+ supports INTERSECT and EXCEPT, you may encounter older MySQL versions.

You can achieve similar results using other SQL techniques.

## 17.1 Alternative to INTERSECT Using INNER JOIN

```sql
SELECT DISTINCT
    a.id,
    a.name,
    a.department
FROM employees_2025 a
INNER JOIN employees_2026 b
    ON a.id = b.id
   AND a.name = b.name
   AND a.department = b.department;
```

This finds matching records.

Another alternative uses `EXISTS`:

```sql
SELECT
    a.id,
    a.name,
    a.department
FROM employees_2025 a
WHERE EXISTS (
    SELECT 1
    FROM employees_2026 b
    WHERE b.id = a.id
      AND b.name = a.name
      AND b.department = a.department
);
```

## 17.2 Alternative to EXCEPT Using LEFT JOIN

```sql
SELECT
    a.id,
    a.name,
    a.department
FROM employees_2025 a
LEFT JOIN employees_2026 b
    ON a.id = b.id
   AND a.name = b.name
   AND a.department = b.department
WHERE b.id IS NULL;
```

This finds records in the first table without matching records in the second table.

### Alternative Using NOT EXISTS

```sql
SELECT
    a.id,
    a.name,
    a.department
FROM employees_2025 a
WHERE NOT EXISTS (
    SELECT 1
    FROM employees_2026 b
    WHERE b.id = a.id
      AND b.name = a.name
      AND b.department = a.department
);
```

**Important:** These examples assume `id` is non-NULL and the matching columns are the intended definition of record equality. When recreating `EXCEPT` behavior with duplicates, remember that `EXCEPT` removes duplicates by default, so additional `DISTINCT` handling may be needed.

---

# 18. Common Mistakes and Best Practices

### Mistake 1: Different Number of Columns

Incorrect:

```sql
SELECT id, name
FROM employees_2025

UNION

SELECT id, name, department
FROM employees_2026;
```

Both queries must return the same number of columns.

### Mistake 2: Different Column Order

Incorrect logical mapping:

```sql
SELECT id, name
FROM employees_2025

UNION

SELECT name, id
FROM employees_2026;
```

Remember that matching happens by position.

### Mistake 3: Expecting UNION ALL to Remove Duplicates

`UNION ALL` preserves duplicates.

Use `UNION` when duplicate elimination is required.

### Mistake 4: Using UNION Instead of UNION ALL Unnecessarily

Duplicate elimination can add processing overhead.

Use `UNION ALL` when duplicates are meaningful or when you do not need to remove them.

### Mistake 5: Expecting ORDER BY to Sort Each SELECT

This:

```sql
SELECT id, name FROM employees_2025
UNION
SELECT id, name FROM employees_2026
ORDER BY name;
```

Sorts the final result.

It does not independently sort both source queries.

### Best Practices

1. Use UNION ALL by default when duplicate removal is unnecessary.
2. Ensure corresponding columns have compatible data types.
3. Keep column order consistent.
4. Use meaningful aliases in the first SELECT.
5. Use parentheses when combining multiple set operations.
6. Use ORDER BY at the end to sort the final result.
7. Use EXPLAIN to investigate performance.
8. Prefer stable identifiers when comparing records across datasets.

---

# 19. SQL Set Operations Interview Questions

### Beginner Level

1. What are SQL set operations?
2. What is UNION?
3. What is UNION ALL?
4. What is the difference between UNION and UNION ALL?
5. Does UNION remove duplicate rows?
6. What happens when two SELECT queries have different numbers of columns?
7. Do column names need to be identical?
8. What is the purpose of ORDER BY with UNION?

### Intermediate Level

9. What is INTERSECT?
10. What is EXCEPT?
11. What is the difference between INTERSECT and INNER JOIN?
12. What is the difference between EXCEPT and LEFT JOIN?
13. Can we combine more than two SELECT queries using UNION?
14. Can we use LIMIT with UNION?
15. What happens if corresponding columns have different data types?
16. How does UNION handle NULL values?
17. What is the difference between UNION and UNION ALL in terms of performance?

### Advanced Level

18. Does MySQL support INTERSECT?
19. From which MySQL version is INTERSECT supported?
20. Does MySQL support EXCEPT?
21. How can you implement INTERSECT using INNER JOIN?
22. How can you implement EXCEPT using NOT EXISTS?
23. What is the difference between UNION and JOIN?
24. What is the purpose of parentheses in combined queries?
25. What is the difference between INTERSECT and INTERSECT ALL?
26. What is the difference between EXCEPT and EXCEPT ALL?

---

# 20. Practical Assignments

Use the `employees_2025` and `employees_2026` tables created earlier.

### Assignment 1 – UNION

1. Combine employee IDs from both tables.
2. Combine employee names from both tables.
3. Combine employee IDs, names, and departments.
4. Display unique departments from both tables.
5. Combine employee records and sort them alphabetically by name.

### Assignment 2 – UNION ALL

1. Combine all employee records from both tables.
2. Display employee IDs without removing duplicates.
3. Combine employee names and departments.
4. Sort the combined result by employee ID.
5. Return only the first five records.

### Assignment 3 – INTERSECT

1. Find employees present in both tables.
2. Find departments present in both tables.
3. Find common employee IDs.
4. Find employees with matching IDs and names.
5. Find employees with matching IDs, names, and departments.

### Assignment 4 – EXCEPT

1. Find employees present in 2025 but absent in 2026.
2. Find employees present in 2026 but absent in 2025.
3. Find departments present in 2025 but absent in 2026.
4. Find employee IDs that exist only in the first table.
5. Repeat these exercises using NOT EXISTS.

### Assignment 5 – Advanced

1. Combine three SELECT queries using UNION.
2. Combine three SELECT queries using UNION ALL.
3. Use ORDER BY with UNION.
4. Use LIMIT with UNION.
5. Apply INTERSECT and EXCEPT together using parentheses.
6. Recreate INTERSECT using INNER JOIN.
7. Recreate EXCEPT using LEFT JOIN.
8. Compare UNION and UNION ALL using EXPLAIN.

---

# 21. Phase 13 – Quick Revision Sheet

| Operation | Meaning | Removes Duplicates? |
|---|---|---|
| UNION | Combines results | Yes |
| UNION ALL | Combines results | No |
| INTERSECT | Returns common rows | Yes |
| INTERSECT ALL | Returns common rows, preserving duplicate occurrences | No |
| EXCEPT | Returns rows in first result but not second | Yes |
| EXCEPT ALL | Returns remaining rows, preserving duplicate occurrences | No |

### Important Rules

- Both SELECT queries must return the same number of columns.
- Corresponding columns must have compatible data types.
- Column positions must match logically.
- Final column names come from the first SELECT.
- ORDER BY generally applies to the final combined result.
- UNION ALL is generally faster than UNION.
- MySQL 8.0.31+ supports INTERSECT and EXCEPT.

---

# 22. Phase 13 Completion Checklist

Before moving to Phase 14, make sure you understand:

- [ ] What SQL set operations are.
- [ ] UNION.
- [ ] UNION ALL.
- [ ] UNION vs UNION ALL.
- [ ] INTERSECT.
- [ ] INTERSECT ALL.
- [ ] EXCEPT.
- [ ] EXCEPT ALL.
- [ ] Column compatibility rules.
- [ ] ORDER BY with UNION.
- [ ] LIMIT with UNION.
- [ ] Multiple UNION operations.
- [ ] Combining different set operations.
- [ ] Set operations vs JOIN.
- [ ] Alternatives to INTERSECT and EXCEPT.
- [ ] Practical assignments.

**Phase 13 is complete when you can combine multiple query results, identify common records, find differences between datasets, and choose the correct set operation for a real-world requirement.**

---

## Next Phase: Phase 14 – Common Table Expressions (CTEs)

In Phase 14, we will cover:

1. What is a CTE?
2. Why do we need CTEs?
3. WITH clause.
4. Basic CTE syntax.
5. CTE vs Subquery.
6. Multiple CTEs.
7. CTE with JOIN.
8. CTE with GROUP BY.
9. CTE with UPDATE and DELETE.
10. Recursive CTEs.
11. Hierarchical data using recursive CTEs.
12. CTE performance and optimization.
13. Real-world examples.
14. Interview questions and practical assignments.