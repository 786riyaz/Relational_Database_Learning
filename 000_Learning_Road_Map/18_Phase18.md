# SQL Complete Learning Roadmap
# Phase 18 – Indexing and Query Optimization
### MySQL 8.0+

Indexing and Query Optimization are among the most important topics for backend developers and database engineers.

Imagine your application has a database containing 10 million users.

You execute this query:

```sql
SELECT *
FROM users
WHERE email = 'riyaz@example.com';
```

Without an appropriate index, MySQL may need to examine a large number of rows to find the matching email.

With a suitable index, MySQL can locate the matching record much more efficiently.

This is the purpose of database indexing.

In this phase, we will learn:

- What database indexes are.
- How indexes work internally.
- Different types of indexes.
- How MySQL uses indexes.
- How to analyze query execution.
- How to optimize slow SQL queries.
- When indexes help and when they hurt performance.

---

# 1. What Is a Database Index?

A **Database Index** is a data structure that helps the database find records more efficiently without scanning the entire table.

Think of an index like the index section of a textbook.

Suppose you want to find a topic in a 1,000-page book.

Without an index:
- You may need to check page after page.
- Finding the topic takes time.

With an index:
- You look up the topic.
- Find its page number.
- Directly navigate to the relevant page.

Database indexes work on a similar principle.

### Example: Without an Index

Consider a users table:

| id | name | email |
|---:|---|---|
| 1 | Riyaz | riyaz@example.com |
| 2 | John | john@example.com |
| 3 | Alex | alex@example.com |
| 4 | David | david@example.com |
| 5 | Sarah | sarah@example.com |

Query:

```sql
SELECT *
FROM users
WHERE email = 'alex@example.com';
```

Without an index on `email`, MySQL may perform a **Full Table Scan**.

It checks rows until it finds the matching record.

For a large table, this can be expensive.

### Example: With an Index

Create an index:

```sql
CREATE INDEX idx_users_email
ON users(email);
```

Now MySQL can use the index to locate the matching row efficiently.

The index contains indexed values and references that help locate the corresponding table records.

**Important:** An index does not guarantee that MySQL will use it. The optimizer chooses an execution plan based on estimated cost and available statistics.

---

# 2. Why Do We Need Indexes?

Indexes are primarily used to improve data retrieval performance.

### Main Benefits

1. Faster SELECT queries.
2. Faster filtering using WHERE.
3. Faster JOIN operations when appropriate indexes exist.
4. Faster sorting using ORDER BY in suitable cases.
5. Faster grouping in certain GROUP BY queries.
6. Efficient enforcement of UNIQUE constraints.
7. Efficient lookup using primary and foreign keys.

### Example

Suppose your employees table contains 5 million records.

You frequently execute:

```sql
SELECT *
FROM employees
WHERE department_id = 10;
```

Creating an index:

```sql
CREATE INDEX idx_employees_department
ON employees(department_id);
```

Can significantly improve this query when the index is selective and the optimizer chooses it.

### Important Disadvantage

Indexes also have costs.

Every index requires:

- Additional storage.
- Maintenance during INSERT.
- Maintenance during UPDATE.
- Maintenance during DELETE.
- Additional work during bulk imports.

Therefore:

**More indexes do not automatically mean better database performance.**

The objective is to create useful indexes based on actual query patterns.

---

# 3. How Do Indexes Work Internally?

MySQL's InnoDB storage engine uses a B+Tree structure for its standard ordered indexes.

Let's understand the basic idea.

Suppose we have these employee IDs:

```text
10, 20, 30, 40, 50, 60, 70, 80, 90
```

A simplified tree might look like:

```text
                  [40, 70]
                 /    |    \
                /     |     \
          [10,20,30] [50,60] [80,90]
```

To find employee ID `80`:

1. Start at the root.
2. Compare 80 with 40.
3. Move to the right.
4. Compare 80 with 70.
5. Move to the right.
6. Locate 80 in the leaf level.

The tree structure allows efficient searching.

### Why B+Tree?

A B+Tree is designed to reduce the number of disk page accesses required to search large amounts of indexed data.

Its important characteristics include:

- Balanced tree structure.
- Sorted keys.
- High branching factor.
- Leaf nodes linked for efficient range scans.
- Efficient equality and range searches.

### Time Complexity

A simplified comparison:

| Operation | Typical Complexity |
|---|---|
| Full Table Scan | O(n) |
| B+Tree Index Search | O(log n) |
| B+Tree Range Search | O(log n + k) |

Where:

- `n` = number of indexed entries or rows.
- `k` = number of matching entries returned.

These are conceptual complexity models, not exact MySQL execution-time guarantees.

Actual performance depends on disk I/O, memory, selectivity, row size, caching, and query execution plans.

---

# 4. Types of Database Indexes

MySQL supports several index types and index-related structures.

Important categories include:

1. Primary Key Index.
2. Unique Index.
3. Normal (Non-Unique) Index.
4. Composite Index.
5. Full-Text Index.
6. Spatial Index.
7. Functional Index.

Let's understand each.

---

# 5. Primary Key Index

A Primary Key uniquely identifies every row in a table.

When you define a primary key, MySQL automatically creates a unique index for it.

Example:

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(150)
);
```

Here:

```sql
PRIMARY KEY (id)
```

automatically creates an index on `id`.

You do not need to create another index on the same primary key.

### Searching by Primary Key

```sql
SELECT *
FROM users
WHERE id = 10;
```

MySQL can use the primary key index to find the row.

### Important InnoDB Concept: Clustered Index

In InnoDB, table rows are organized around the clustered index.

Usually, the primary key is the clustered index.

The clustered index's leaf pages contain the complete row data.

This is an important distinction:

- Primary key is a logical constraint.
- Clustered index describes how InnoDB organizes table records.

A table can have only one clustered index.

If there is no explicit primary key, InnoDB selects an appropriate non-null unique index or creates an internal hidden row ID.

### Practical Recommendation

For most application tables, define a stable primary key.

Example:

```sql
id INT PRIMARY KEY AUTO_INCREMENT
```

For suitable applications, UUIDs or other key strategies may also be appropriate, but they have different storage and indexing trade-offs.

---

# 6. Unique Index

A Unique Index ensures that indexed values cannot be duplicated.

Example:

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(150) UNIQUE
);
```

The `email` column gets a unique index.

You can also create one explicitly:

```sql
CREATE UNIQUE INDEX idx_users_email
ON users(email);
```

### Example

Valid:

| id | email |
|---:|---|
| 1 | riyaz@example.com |
| 2 | john@example.com |

Invalid:

| id | email |
|---:|---|
| 1 | riyaz@example.com |
| 2 | riyaz@example.com |

The second duplicate value violates the unique constraint.

### Important: NULL Values

In MySQL, a UNIQUE index generally permits multiple NULL values.

For example:

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(150) UNIQUE
);
```

Multiple rows can have `NULL` in the email column.

If every user must have an email, combine UNIQUE with NOT NULL:

```sql
email VARCHAR(150) NOT NULL UNIQUE
```

### Primary Key vs Unique Index

| Primary Key | Unique Index |
|---|---|
| Uniquely identifies each row | Ensures indexed values are unique |
| Cannot contain NULL | Can allow NULL |
| Only one primary key constraint per table | Multiple unique indexes allowed |
| InnoDB uses it as the default clustered index | Usually a secondary index in InnoDB |

---

# 7. Normal Index (Non-Unique Index)

A normal index improves lookup performance but allows duplicate values.

Example:

```sql
CREATE INDEX idx_users_name
ON users(name);
```

Now you can search:

```sql
SELECT *
FROM users
WHERE name = 'Riyaz';
```

Multiple users can have the same name.

The index does not enforce uniqueness.

### When to Use It?

Use a normal index when:

- A column is frequently used in WHERE.
- A column is used in JOIN conditions.
- A column is used in ORDER BY.
- A column is used in GROUP BY.
- The index is likely to reduce the amount of work required by queries.

---

# 8. Composite Index

A Composite Index is an index created using multiple columns.

It is also called a multi-column index.

Example:

```sql
CREATE INDEX idx_employee_department_salary
ON employees(department_id, salary);
```

This index contains both:

1. department_id
2. salary

### Example Table

| id | name | department_id | salary |
|---:|---|---:|---:|
| 1 | Riyaz | 10 | 50000 |
| 2 | John | 10 | 60000 |
| 3 | Alex | 20 | 45000 |
| 4 | Sarah | 20 | 70000 |

Create index:

```sql
CREATE INDEX idx_department_salary
ON employees(department_id, salary);
```

### Query 1

```sql
SELECT *
FROM employees
WHERE department_id = 10;
```

The index can help.

### Query 2

```sql
SELECT *
FROM employees
WHERE department_id = 10
AND salary > 50000;
```

The index can help with both conditions.

### Query 3

```sql
SELECT *
FROM employees
WHERE salary > 50000;
```

The composite index generally cannot be used for an efficient direct lookup by salary alone because `department_id` is the leading column.

This brings us to one of the most important indexing concepts.

---

# 9. Leftmost Prefix Rule

The Leftmost Prefix Rule is essential when working with composite indexes.

Suppose we create:

```sql
CREATE INDEX idx_a_b_c
ON employees(a, b, c);
```

The index is ordered by:

```text
a → b → c
```

MySQL can generally use the index for conditions involving the leftmost prefix.

### Index Usage Examples

| Query Conditions | Can Use Index Efficiently? |
|---|---|
| WHERE a = 10 | Yes |
| WHERE a = 10 AND b = 20 | Yes |
| WHERE a = 10 AND b = 20 AND c = 30 | Yes |
| WHERE a = 10 AND c = 30 | Can use the `a` prefix; `c` may not narrow the lookup after the missing `b` |
| WHERE b = 20 | Generally no direct leftmost-prefix lookup |
| WHERE c = 30 | Generally no direct leftmost-prefix lookup |
| WHERE b = 20 AND c = 30 | Generally no direct leftmost-prefix lookup |

### Example

```sql
CREATE INDEX idx_department_salary_age
ON employees(department_id, salary, age);
```

This index can help queries using:

```sql
WHERE department_id = 10
```

```sql
WHERE department_id = 10
AND salary > 50000
```

```sql
WHERE department_id = 10
AND salary > 50000
AND age = 30
```

But it is not generally a good direct lookup index for:

```sql
WHERE age = 30;
```

### Important Advanced Note

The leftmost-prefix rule is a useful design principle, not a guarantee that every query using a prefix will choose the index.

MySQL can also use index skip scan in some situations, depending on the version, index structure, and optimizer cost estimates.

Always verify the execution plan.

---

# 10. Clustered Index vs Secondary Index

This is an important InnoDB concept.

## 10.1 Clustered Index

In InnoDB, the clustered index stores the complete table row in its leaf pages.

Usually, the primary key defines the clustered index.

Example:

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);
```

The table data is organized around the primary key index.

## 10.2 Secondary Index

A Secondary Index is any additional index that is not the clustered index.

Example:

```sql
CREATE INDEX idx_employee_salary
ON employees(salary);
```

In InnoDB, secondary index leaf entries contain:

- The indexed column values.
- The corresponding primary key value.

When a query needs additional columns not present in the secondary index, MySQL may use the primary key to retrieve the complete row from the clustered index.

This is sometimes called a **back-to-the-table lookup**.

### Comparison

| Clustered Index | Secondary Index |
|---|---|
| Stores complete row data at leaf level | Stores indexed values and primary key |
| One per InnoDB table | Multiple possible |
| Usually based on primary key | Created on other columns |
| Determines physical organization of table records | Provides additional lookup paths |

---

# 11. Covering Index

A Covering Index is an index that contains all the columns required by a particular query.

This can allow MySQL to retrieve the result directly from the index without fetching complete table rows.

Example:

```sql
CREATE INDEX idx_employee_department_name
ON employees(department_id, name);
```

Query:

```sql
SELECT department_id, name
FROM employees
WHERE department_id = 10;
```

The index contains both required columns.

Therefore, it can cover the query.

### Why Is This Useful?

Normally:

1. MySQL searches the secondary index.
2. It finds the primary key.
3. It retrieves the full row from the clustered index.

With a covering index, step 3 may not be necessary.

### How to Identify a Covering Index?

Use:

```sql
EXPLAIN
SELECT department_id, name
FROM employees
WHERE department_id = 10;
```

Look for:

```text
Using index
```

This generally indicates that the query is using a covering index.

**Important:** `Using index` and `Using index condition` are different execution-plan indicators.

---

# 12. Full-Text Index

A Full-Text Index is designed for searching text content.

It is useful for searching articles, product descriptions, blogs, and documentation.

Example:

```sql
CREATE TABLE articles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    content TEXT,

    FULLTEXT INDEX idx_article_search (title, content)
);
```

Now search:

```sql
SELECT *
FROM articles
WHERE MATCH(title, content)
AGAINST('database indexing');
```

### Natural Language Mode

```sql
SELECT *
FROM articles
WHERE MATCH(title, content)
AGAINST('database indexing' IN NATURAL LANGUAGE MODE);
```

### Boolean Mode

```sql
SELECT *
FROM articles
WHERE MATCH(title, content)
AGAINST('+database -mongodb' IN BOOLEAN MODE);
```

Here:

- `+database` means database must be present.
- `-mongodb` means mongodb must not be present.

### LIKE vs FULLTEXT

| LIKE | FULLTEXT |
|---|---|
| Pattern matching | Text search with relevance features |
| Suitable for simple substring/pattern searches | Suitable for searching larger text fields |
| Often cannot use a normal B-tree index for `%term%` | Uses a dedicated full-text index |
| Supports `%` and `_` | Supports full-text search operators |

Example:

```sql
SELECT *
FROM articles
WHERE content LIKE '%database%';
```

For large text-search workloads, FULLTEXT may be more appropriate.

**Note:** MySQL FULLTEXT behavior depends on the storage engine, parser, tokenization rules, stopwords, and minimum token size.

---

# 13. Spatial Index

Spatial indexes are used for geographic and geometric data.

Examples:

- Finding nearby locations.
- Geographic applications.
- Mapping systems.
- Location-based services.

MySQL supports spatial data types such as:

- POINT
- LINESTRING
- POLYGON
- GEOMETRY

Example:

```sql
CREATE TABLE locations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    coordinates POINT NOT NULL SRID 4326,

    SPATIAL INDEX idx_coordinates (coordinates)
);
```

Spatial indexes in MySQL use R-tree structures for supported spatial indexing operations.

They are useful when working with geographic data and spatial functions.

---

# 14. Functional Index

A Functional Index indexes the result of an expression rather than only a direct column value.

Example:

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(150)
);
```

Suppose you frequently search emails case-insensitively using:

```sql
SELECT *
FROM users
WHERE LOWER(email) = 'riyaz@example.com';
```

A regular index on `email` may not directly support this expression efficiently.

In MySQL 8.0.13+, you can create a functional index:

```sql
CREATE INDEX idx_lower_email
ON users ((LOWER(email)));
```

Now MySQL can potentially use the functional index for matching expressions.

### Important

The query expression must be compatible with the indexed expression.

Functional indexes have restrictions, including restrictions on functions and expressions that are allowed.

Another approach is to use a generated column and index that column.

---

# 15. What Is Index Selectivity?

Index Selectivity describes how effectively an index distinguishes between different values.

An index with high selectivity usually helps narrow down the search to relatively few rows.

### Example 1 – High Selectivity

Consider a users table:

| id | email |
|---:|---|
| 1 | a@example.com |
| 2 | b@example.com |
| 3 | c@example.com |
| 4 | d@example.com |

Each email is unique.

Email has high selectivity.

### Example 2 – Low Selectivity

Consider:

| id | gender |
|---:|---|
| 1 | Male |
| 2 | Female |
| 3 | Male |
| 4 | Male |
| 5 | Female |

Gender has relatively low selectivity.

An index on gender may not help much if a query returns a large proportion of the table.

### Selectivity Formula

A simplified measure:

\[
Selectivity =
\frac{Distinct\ Values}{Total\ Rows}
\]

Example:

- Total rows = 1,000,000.
- Distinct email values = 1,000,000.

Selectivity:

\[
\frac{1,000,000}{1,000,000}=1
\]

For a column with two distinct values:

\[
\frac{2}{1,000,000}=0.000002
\]

Higher selectivity often makes an index more useful for equality filtering.

However, selectivity is not the only factor in the optimizer's decision.

---

# 16. What Is Index Cardinality?

Cardinality refers to the number of distinct values in an indexed column or index prefix.

Example:

| Column | Distinct Values | Cardinality |
|---|---:|---:|
| email | 1,000,000 | High |
| department_id | 20 | Medium |
| gender | 2 | Low |

MySQL maintains index statistics to estimate cardinality and selectivity.

You can inspect indexes using:

```sql
SHOW INDEX FROM employees;
```

Important output columns include:

| Column | Meaning |
|---|---|
| Key_name | Index name |
| Column_name | Indexed column |
| Non_unique | Whether duplicates are allowed |
| Seq_in_index | Column position in a composite index |
| Cardinality | Estimated number of distinct values |
| Index_type | Index structure type |

**Important:** Cardinality is an estimate maintained by the storage engine. It is not necessarily the exact distinct count.

---

# 17. What Is a Full Table Scan?

A Full Table Scan occurs when MySQL reads table rows to evaluate a query rather than using an index to narrow the search.

Example:

```sql
SELECT *
FROM employees;
```

This normally requires reading all rows because all rows are requested.

Another example:

```sql
SELECT *
FROM employees
WHERE YEAR(created_at) = 2026;
```

If there is only a regular index on `created_at`, wrapping the column in `YEAR()` can prevent an ordinary index range scan on that column.

### Better Query

```sql
SELECT *
FROM employees
WHERE created_at >= '2026-01-01'
AND created_at < '2027-01-01';
```

This range condition can use a suitable index on `created_at`.

### Important

A Full Table Scan is not always bad.

For example:

```sql
SELECT *
FROM employees;
```

If the application genuinely needs every row, scanning the table may be the most efficient option.

The goal is not to eliminate every table scan.

The goal is to avoid unnecessary work.

---

# 18. What Is EXPLAIN?

`EXPLAIN` is a MySQL command that shows the execution plan chosen by the query optimizer.

It helps you understand:

- Which table is accessed.
- Which index may be used.
- How MySQL accesses the table.
- How many rows it estimates will be examined.
- Which conditions are applied.

### Example

```sql
EXPLAIN
SELECT *
FROM employees
WHERE department_id = 10;
```

Possible output:

| id | select_type | table | type | possible_keys | key | rows |
|---:|---|---|---|---|---|---:|
| 1 | SIMPLE | employees | ref | idx_department | idx_department | 100 |

The exact output depends on your table, data, indexes, and MySQL version.

Let's understand the important columns.

### 18.1 id

Identifies the SELECT operation in the execution plan.

### 18.2 select_type

Describes the type of SELECT operation.

Examples:

- SIMPLE
- PRIMARY
- SUBQUERY
- DERIVED
- UNION

### 18.3 table

Shows which table is being accessed.

### 18.4 type

Shows the access method.

Common values include:

| Type | Meaning |
|---|---|
| system | Special case of a table with one row |
| const | At most one matching row from a constant lookup |
| eq_ref | One matching row for each combination of preceding tables, typically using a unique key |
| ref | Non-unique index lookup |
| range | Index range scan |
| index | Full index scan |
| ALL | Full table scan |

Generally, `const`, `eq_ref`, and `ref` are desirable access methods for appropriate queries.

But you should not blindly treat one access type as good or bad without considering the query.

### 18.5 possible_keys

Indexes that the optimizer considers potentially usable.

### 18.6 key

The index actually selected by the optimizer.

If NULL, no index was selected.

### 18.7 rows

Estimated number of rows MySQL expects to examine.

### 18.8 filtered

Estimated percentage of examined rows expected to satisfy the remaining conditions.

### 18.9 Extra

Additional execution information.

Common values:

| Extra | Meaning |
|---|---|
| Using where | A condition is applied to filter rows |
| Using index | Query can be covered by the index |
| Using index condition | Index Condition Pushdown is being used |
| Using filesort | An additional sorting operation is required |
| Using temporary | A temporary table is used for part of execution |

**Important:** `Using filesort` does not necessarily mean sorting to disk. It means MySQL uses an additional sorting operation rather than retrieving rows directly in the required index order.

---

# 19. Practical EXPLAIN Example

Let's create an employees table.

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10,2),
    created_at DATETIME
);
```

Insert some data:

```sql
INSERT INTO employees
(name, department_id, salary, created_at)
VALUES
('Riyaz', 10, 50000, '2026-01-10 10:00:00'),
('John', 20, 60000, '2026-02-15 11:00:00'),
('Alex', 10, 45000, '2026-03-20 12:00:00'),
('Sarah', 30, 70000, '2026-04-25 13:00:00');
```

### Step 1: Analyze Without an Index

```sql
EXPLAIN
SELECT *
FROM employees
WHERE department_id = 10;
```

There is no index on department_id.

For this small table, MySQL will likely choose a table scan.

### Step 2: Create an Index

```sql
CREATE INDEX idx_department_id
ON employees(department_id);
```

### Step 3: Analyze Again

```sql
EXPLAIN
SELECT *
FROM employees
WHERE department_id = 10;
```

Now the optimizer has another possible execution strategy.

However, because the table is extremely small, it may still choose a table scan.

This is normal.

### Step 4: Analyze a Larger Table

With sufficiently large data and useful selectivity, the index may become the preferred access path.

**Remember:** An index existing does not mean MySQL must use it.

---

# 20. What Is EXPLAIN ANALYZE?

`EXPLAIN ANALYZE` provides the execution plan along with actual execution measurements.

It executes the query and reports information such as:

- Actual execution time.
- Actual number of rows.
- Number of loops.
- Estimated versus actual rows.
- Time spent in different execution steps.

Example:

```sql
EXPLAIN ANALYZE
SELECT *
FROM employees
WHERE department_id = 10;
```

A simplified illustrative output might look like:

```text
-> Index lookup on employees
   using idx_department_id
   (department_id = 10)
   (actual time=0.05..0.08 rows=100 loops=1)
```

### EXPLAIN vs EXPLAIN ANALYZE

| EXPLAIN | EXPLAIN ANALYZE |
|---|---|
| Shows the execution plan | Executes the query and reports actual execution information |
| Primarily provides estimates | Provides actual runtime measurements |
| Does not execute the SELECT query in the usual EXPLAIN SELECT case | Executes the SELECT query |
| Useful for initial analysis | Useful for deeper performance investigation |

**Important:** Because EXPLAIN ANALYZE executes the statement, use care with expensive queries. For DML statements, MySQL supports EXPLAIN ANALYZE in supported versions, but execution can modify data. Do not test destructive statements casually on production.

---

# 21. What Is Query Optimization?

Query Optimization is the process of improving SQL query performance by reducing unnecessary work.

It can involve:

- Better SQL query structure.
- Appropriate indexes.
- Efficient JOIN conditions.
- Filtering unnecessary rows.
- Avoiding unnecessary columns.
- Improving table design.
- Updating optimizer statistics.
- Analyzing execution plans.

Let's understand common optimization techniques.

---

# 22. Optimization Technique 1 – Avoid SELECT *

Bad:

```sql
SELECT *
FROM employees;
```

Better:

```sql
SELECT id, name, salary
FROM employees;
```

### Why?

`SELECT *` may retrieve unnecessary columns.

This can increase:

- Data transferred from MySQL.
- Memory usage.
- Network traffic.
- Application processing.

It can also prevent some covering-index opportunities.

Use only the columns your application needs.

---

# 23. Optimization Technique 2 – Index Frequently Filtered Columns

Suppose you frequently execute:

```sql
SELECT *
FROM employees
WHERE department_id = 10;
```

Consider:

```sql
CREATE INDEX idx_department_id
ON employees(department_id);
```

But do not create indexes blindly.

First examine:
- Query frequency.
- Table size.
- Number of matching rows.
- Existing indexes.
- Query execution plan.

---

# 24. Optimization Technique 3 – Avoid Functions on Indexed Columns

Suppose you have:

```sql
CREATE INDEX idx_created_at
ON employees(created_at);
```

Bad:

```sql
SELECT *
FROM employees
WHERE YEAR(created_at) = 2026;
```

The function is applied to the indexed column.

This can prevent a direct index range scan.

Better:

```sql
SELECT *
FROM employees
WHERE created_at >= '2026-01-01'
AND created_at < '2027-01-01';
```

Now MySQL can potentially use an index range scan.

This property is often called **Sargability**.

---

# 25. What Is Sargability?

Sargability describes whether a query condition can efficiently use an index to search for matching rows.

A Sargable condition is generally written in a way that allows the database to use an index for filtering.

### Example 1

Less Sargable:

```sql
SELECT *
FROM employees
WHERE YEAR(created_at) = 2026;
```

More Sargable:

```sql
SELECT *
FROM employees
WHERE created_at >= '2026-01-01'
AND created_at < '2027-01-01';
```

### Example 2

Less Sargable:

```sql
SELECT *
FROM users
WHERE LOWER(email) = 'riyaz@example.com';
```

Potentially more Sargable:

```sql
SELECT *
FROM users
WHERE email = 'riyaz@example.com';
```

This depends on your column collation and the intended case-sensitivity behavior.

Alternatively, use a functional index if the application requires the expression.

### Example 3

Less Sargable:

```sql
SELECT *
FROM employees
WHERE salary + 1000 > 50000;
```

Equivalent condition:

```sql
SELECT *
FROM employees
WHERE salary > 49000;
```

The second form can make better use of an index on salary.

### Important

Not every function or expression prevents index usage.

MySQL has optimizer transformations and functional indexes that can support certain expressions.

Always check EXPLAIN.

---

# 26. Optimization Technique 4 – Use LIMIT for Large Results

Bad:

```sql
SELECT *
FROM logs
ORDER BY created_at DESC;
```

If the table contains millions of records, retrieving everything can be expensive.

Better when you only need the latest records:

```sql
SELECT *
FROM logs
ORDER BY created_at DESC
LIMIT 20;
```

For suitable workloads, an index can help:

```sql
CREATE INDEX idx_logs_created_at
ON logs(created_at);
```

For a descending sort, MySQL can also use an ascending B-tree index in reverse order in suitable cases.

### Important

LIMIT reduces the number of rows returned, but it does not always mean MySQL reads only that many rows.

A large OFFSET can still be expensive.

---

# 27. Optimization Technique 5 – Optimize Pagination

Consider this query:

```sql
SELECT *
FROM employees
ORDER BY id
LIMIT 100000, 20;
```

MySQL may need to walk through many preceding rows before returning the requested page.

This can become expensive.

### Keyset Pagination

Instead, use the last ID from the previous page.

Example:

```sql
SELECT *
FROM employees
WHERE id > 100000
ORDER BY id
LIMIT 20;
```

This is generally more efficient when `id` is indexed and the ordering is compatible with the cursor.

For a more complex ordering, use a stable combination of columns.

Example:

```sql
SELECT *
FROM employees
WHERE created_at < '2026-11-25 10:00:00'
   OR (
       created_at = '2026-11-25 10:00:00'
       AND id < 1000
   )
ORDER BY created_at DESC, id DESC
LIMIT 20;
```

A matching composite index can help:

```sql
CREATE INDEX idx_created_id
ON employees(created_at, id);
```

The cursor must contain the last row's ordering values.

---

# 28. Optimization Technique 6 – Optimize JOIN Queries

Suppose you have:

**employees**

| id | name | department_id |
|---:|---|---:|
| 1 | Riyaz | 10 |
| 2 | John | 20 |

**departments**

| id | department_name |
|---:|---|
| 10 | IT |
| 20 | HR |

Query:

```sql
SELECT
    e.name,
    d.department_name
FROM employees e
JOIN departments d
    ON e.department_id = d.id;
```

Important indexes:

- `departments.id` is already indexed because it is a primary key.
- Consider an index on `employees.department_id`.

```sql
CREATE INDEX idx_employees_department
ON employees(department_id);
```

### Why?

The index can help MySQL locate employees associated with a department, depending on the selected join order and execution strategy.

### Important

Foreign keys in InnoDB require suitable indexes on referencing columns. MySQL creates an index when necessary for a foreign key.

Before creating an index manually, check whether an appropriate index already exists.

---

# 29. Optimization Technique 7 – Avoid Leading Wildcards When Possible

Consider:

```sql
SELECT *
FROM users
WHERE name LIKE '%riyaz%';
```

A regular B-tree index on `name` generally cannot perform an efficient range lookup for a pattern beginning with `%`.

Compare:

```sql
WHERE name LIKE 'riyaz%'
```

A prefix pattern may use a B-tree index.

### Alternatives

Depending on your requirements:

- Use prefix matching.
- Use FULLTEXT indexing.
- Use an external search engine for advanced search requirements.
- Consider a suitable normalized search column.

The correct choice depends on whether you need substring matching, word matching, relevance ranking, or linguistic search.

---

# 30. Optimization Technique 8 – Avoid Unnecessary DISTINCT

Example:

```sql
SELECT DISTINCT department_id
FROM employees;
```

DISTINCT is useful when duplicate elimination is required.

But avoid adding it without understanding why duplicates occur.

Sometimes duplicates are caused by an incorrect JOIN.

Instead of hiding the problem with DISTINCT, fix the underlying query.

### Example

Incorrect JOIN:

```sql
SELECT DISTINCT
    e.name,
    d.department_name
FROM employees e
JOIN departments d;
```

Correct JOIN:

```sql
SELECT
    e.name,
    d.department_name
FROM employees e
JOIN departments d
    ON e.department_id = d.id;
```

---

# 31. Optimization Technique 9 – Avoid Unnecessary Subqueries

Consider:

```sql
SELECT *
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE department_name = 'IT'
);
```

A JOIN can express the relationship clearly:

```sql
SELECT e.*
FROM employees e
JOIN departments d
    ON e.department_id = d.id
WHERE d.department_name = 'IT';
```

However, do not assume JOIN is always faster.

Modern MySQL optimizers can transform many subqueries into efficient execution strategies.

Compare both plans using EXPLAIN.

---

# 32. Optimization Technique 10 – Use Appropriate Data Types

Data types also affect database performance and storage.

For example:

Bad:

```sql
id VARCHAR(255)
```

Better when the ID is a numeric identifier:

```sql
id INT
```

Similarly:

- Use DECIMAL for exact monetary values.
- Use DATE for dates without time.
- Use DATETIME or TIMESTAMP for date-time values.
- Avoid unnecessarily large VARCHAR columns.
- Use compatible data types for JOIN columns.

Smaller and compatible data types can reduce storage requirements and improve index efficiency.

---

# 33. What Is Index Condition Pushdown (ICP)?

Index Condition Pushdown is an optimization that allows MySQL to evaluate certain conditions using index entries before fetching complete table rows.

This can reduce unnecessary row retrieval.

### Example

Suppose we have:

```sql
CREATE INDEX idx_department_salary
ON employees(department_id, salary);
```

Query:

```sql
SELECT *
FROM employees
WHERE department_id = 10
AND salary > 50000;
```

MySQL may evaluate the salary condition within the storage engine using the index.

This can reduce the number of full rows that must be retrieved.

In EXPLAIN output, you may see:

```text
Using index condition
```

### Important

Index Condition Pushdown is not the same as a covering index.

- Covering index: The index contains all columns needed by the query.
- ICP: The storage engine can filter using index conditions before fetching full rows.

---

# 34. What Is Index Merge?

Index Merge is an optimization where MySQL uses multiple indexes for one table and combines the results.

Example:

Suppose you have:

```sql
CREATE INDEX idx_department
ON employees(department_id);

CREATE INDEX idx_salary
ON employees(salary);
```

Query:

```sql
SELECT *
FROM employees
WHERE department_id = 10
AND salary > 50000;
```

Depending on the data and optimizer cost estimates, MySQL may use Index Merge.

However, a suitable composite index may be more efficient:

```sql
CREATE INDEX idx_department_salary
ON employees(department_id, salary);
```

Do not assume a composite index is always better. Test the actual workload.

---

# 35. When Should You NOT Create an Index?

Indexes are not free.

Avoid unnecessary indexes in the following situations.

### 1. Very Small Tables

A full table scan may be cheaper.

### 2. Columns With Low Selectivity

Example:

```text
is_active = 0 or 1
```

An index may not help much if a query retrieves a large proportion of rows.

However, low-cardinality columns can still be useful in composite indexes.

### 3. Frequently Updated Columns

Every update to an indexed column may require index maintenance.

### 4. Unnecessary Duplicate Indexes

Example:

```sql
CREATE INDEX idx_department
ON employees(department_id);
```

Creating another identical index provides little value.

### 5. Very Wide Indexes

Large indexes consume more storage and memory and increase maintenance costs.

### 6. Columns Never Used in Queries

If an index is not useful to your workload, it may only add overhead.

---

# 36. How to Create, View and Delete Indexes

These are important practical commands.

### Create Normal Index

```sql
CREATE INDEX idx_name
ON employees(name);
```

### Create Unique Index

```sql
CREATE UNIQUE INDEX idx_email
ON employees(email);
```

### Create Composite Index

```sql
CREATE INDEX idx_department_salary
ON employees(department_id, salary);
```

### View Indexes

```sql
SHOW INDEX FROM employees;
```

### Drop Index

```sql
DROP INDEX idx_name
ON employees;
```

### Add Index Using ALTER TABLE

```sql
ALTER TABLE employees
ADD INDEX idx_salary (salary);
```

### Drop Index Using ALTER TABLE

```sql
ALTER TABLE employees
DROP INDEX idx_salary;
```

### Add Primary Key

```sql
ALTER TABLE employees
ADD PRIMARY KEY (id);
```

### Drop Primary Key

```sql
ALTER TABLE employees
DROP PRIMARY KEY;
```

**Warning:** Dropping or changing indexes on large production tables can affect availability and performance. Consider the table size, MySQL version, DDL algorithm, and locking behavior before making changes.

---

# 37. How to Identify Slow Queries in MySQL

MySQL provides a Slow Query Log.

It records queries that take longer than a configured threshold.

### Check Current Setting

```sql
SHOW VARIABLES LIKE 'slow_query_log';
```

### Check Long Query Threshold

```sql
SHOW VARIABLES LIKE 'long_query_time';
```

### Enable Slow Query Log

```sql
SET GLOBAL slow_query_log = ON;
```

### Set Threshold

```sql
SET GLOBAL long_query_time = 1;
```

Now queries taking longer than the configured threshold may be recorded.

The exact logging behavior also depends on other settings, such as whether queries that do not use indexes should be logged.

For persistent configuration, update your MySQL server configuration appropriately.

### Why Is Slow Query Logging Useful?

It helps identify:

- Frequently slow queries.
- Queries examining too many rows.
- Missing or unsuitable indexes.
- Expensive JOINs.
- Inefficient sorting and grouping.
- Queries that need restructuring.

For production systems, analyze the slow query log alongside query frequency. A query taking 100 ms and running 100,000 times may be more important than one query taking 5 seconds that runs once a month.

---

# 38. Query Optimization Workflow

Whenever a query is slow, follow this process.

```text
1. Identify the slow query
          |
          ↓
2. Understand the query requirements
          |
          ↓
3. Run EXPLAIN
          |
          ↓
4. Inspect indexes and access methods
          |
          ↓
5. Check estimated rows and filters
          |
          ↓
6. Rewrite inefficient conditions
          |
          ↓
7. Create or modify suitable indexes
          |
          ↓
8. Run EXPLAIN ANALYZE
          |
          ↓
9. Compare actual execution behavior
          |
          ↓
10. Test with realistic data and workload
```

This is the basic workflow used in practical database performance tuning.

---

# 39. Advanced Topic – Index Statistics and ANALYZE TABLE

MySQL's optimizer uses statistics to estimate the cost of different execution plans.

If statistics are inaccurate or outdated, the optimizer may choose a less efficient plan.

You can refresh table statistics using:

```sql
ANALYZE TABLE employees;
```

This updates key distribution statistics used by the optimizer.

### View Table Statistics

```sql
SHOW TABLE STATUS LIKE 'employees';
```

### View Index Statistics

```sql
SHOW INDEX FROM employees;
```

### Why Is This Important?

Imagine a table initially has:

```text
1,000 rows
```

Later, it grows to:

```text
10,000,000 rows
```

The distribution of values may also change.

Updated statistics help the optimizer make better decisions.

---

# 40. Advanced Topic – Invisible Indexes

MySQL 8.0 supports invisible indexes.

An invisible index exists but is ignored by the optimizer by default.

This is useful when testing whether an index can safely be removed.

### Make an Index Invisible

```sql
ALTER TABLE employees
ALTER INDEX idx_salary INVISIBLE;
```

### Make It Visible Again

```sql
ALTER TABLE employees
ALTER INDEX idx_salary VISIBLE;
```

### Why Is This Useful?

Suppose you suspect an index is unnecessary.

Instead of immediately deleting it, make it invisible.

Then compare query performance.

If the application performs correctly without it, you can consider dropping it.

**Important:** Invisible indexes are still maintained during data modifications, so they do not eliminate the write overhead or storage cost.

---

# 41. Advanced Topic – Indexing JSON Data

MySQL supports JSON columns.

Example:

```sql
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    details JSON
);
```

Suppose JSON data looks like:

```json
{
  "brand": "Samsung",
  "color": "Black",
  "price": 50000
}
```

You may want to search by brand.

One option is to create a generated column.

```sql
ALTER TABLE products
ADD COLUMN brand VARCHAR(100)
GENERATED ALWAYS AS (
    JSON_UNQUOTE(JSON_EXTRACT(details, '$.brand'))
) STORED;
```

Create an index:

```sql
CREATE INDEX idx_product_brand
ON products(brand);
```

Now query:

```sql
SELECT *
FROM products
WHERE brand = 'Samsung';
```

This allows indexing the extracted JSON value.

MySQL also supports multi-valued indexes for certain JSON array use cases.

---

# 42. Real-World Example – E-Commerce Database Indexing

Imagine you are developing an e-commerce application.

Your database contains:

- Customers.
- Products.
- Categories.
- Orders.
- Order Items.
- Payments.

Let's identify some common queries and suitable indexes.

### Customers Table

Common query:

```sql
SELECT *
FROM customers
WHERE email = 'riyaz@example.com';
```

Index:

```sql
CREATE UNIQUE INDEX idx_customers_email
ON customers(email);
```

### Products Table

Common query:

```sql
SELECT *
FROM products
WHERE category_id = 10
AND price BETWEEN 1000 AND 5000;
```

Possible index:

```sql
CREATE INDEX idx_products_category_price
ON products(category_id, price);
```

### Orders Table

Common query:

```sql
SELECT *
FROM orders
WHERE customer_id = 10
ORDER BY created_at DESC;
```

Possible index:

```sql
CREATE INDEX idx_orders_customer_created
ON orders(customer_id, created_at);
```

### Order Items Table

Common query:

```sql
SELECT *
FROM order_items
WHERE order_id = 100;
```

Possible index:

```sql
CREATE INDEX idx_order_items_order
ON order_items(order_id);
```

### Payments Table

Common query:

```sql
SELECT *
FROM payments
WHERE order_id = 100;
```

Possible index:

```sql
CREATE INDEX idx_payments_order
ON payments(order_id);
```

### Important

These are candidate indexes based on the example query patterns.

A real indexing strategy must consider:
- Existing primary and foreign key indexes.
- Query frequency.
- Data distribution.
- Write workload.
- Actual execution plans.

Do not blindly create every suggested index.

---

# 43. Common Indexing Mistakes

| Mistake | Correct Approach |
|---|---|
| Creating indexes on every column | Index based on actual query patterns |
| Creating duplicate indexes | Review existing indexes first |
| Ignoring composite index order | Choose column order based on query patterns |
| Assuming MySQL always uses indexes | Verify with EXPLAIN |
| Using functions on indexed columns unnecessarily | Prefer sargable conditions |
| Ignoring write overhead | Consider INSERT, UPDATE and DELETE costs |
| Using SELECT * everywhere | Retrieve only required columns |
| Ignoring slow query logs | Monitor actual production workload |
| Assuming low-cardinality indexes are always useless | Evaluate the full query and composite index design |
| Treating every table scan as bad | A scan may be optimal for small tables or broad queries |

---

# 44. SQL Indexing Interview Questions

### Beginner Level

1. What is a database index?
2. Why do we need indexes?
3. What happens when a table has no index?
4. What is a full table scan?
5. What is a primary key index?
6. What is a unique index?
7. What is a normal index?
8. What is a composite index?
9. What is a clustered index?
10. What is a secondary index?

### Intermediate Level

11. How does a B+Tree index work?
12. What is the leftmost prefix rule?
13. What is a covering index?
14. What is index selectivity?
15. What is index cardinality?
16. What is a full-text index?
17. What is a functional index?
18. What is the difference between clustered and secondary indexes?
19. Can a table have multiple indexes?
20. Can an index slow down INSERT and UPDATE operations?

### Advanced Level

21. What is EXPLAIN?
22. What is EXPLAIN ANALYZE?
23. What is Index Condition Pushdown?
24. What is Index Merge?
25. What is sargability?
26. What is a range scan?
27. What is an index-only or covering access path?
28. What are invisible indexes?
29. How does MySQL choose which index to use?
30. How would you optimize a query that takes 10 seconds?
31. Why might MySQL ignore an existing index?
32. How do you optimize pagination for large tables?
33. How do you optimize a query using multiple JOINs?
34. What is the difference between `Using index` and `Using index condition`?
35. Why is a composite index sometimes better than two separate indexes?

---

# 45. Practical Assignments

Complete these assignments using MySQL.

## Assignment 1 – Basic Indexing

Create a database:

```sql
CREATE DATABASE indexing_practice;

USE indexing_practice;
```

Create an employees table:

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(150),
    department_id INT,
    salary DECIMAL(10,2),
    created_at DATETIME
);
```

Tasks:

1. Insert at least 10,000 employees.
2. Execute a query filtering by department_id.
3. Run EXPLAIN.
4. Create an index on department_id.
5. Run EXPLAIN again.
6. Compare the execution plans.
7. Create a unique index on email.
8. Try inserting duplicate email values.

## Assignment 2 – Composite Index

Create:

```sql
CREATE INDEX idx_department_salary
ON employees(department_id, salary);
```

Test these queries:

```sql
SELECT *
FROM employees
WHERE department_id = 10;
```

```sql
SELECT *
FROM employees
WHERE department_id = 10
AND salary > 50000;
```

```sql
SELECT *
FROM employees
WHERE salary > 50000;
```

Tasks:

1. Run EXPLAIN on each query.
2. Observe the selected index.
3. Understand the leftmost prefix rule.
4. Experiment with different index orders.

## Assignment 3 – Query Optimization

Optimize the following query:

```sql
SELECT *
FROM employees
WHERE YEAR(created_at) = 2026;
```

Tasks:

1. Explain why this query may not efficiently use a regular index on created_at.
2. Rewrite it using a date range.
3. Create an index on created_at.
4. Compare the execution plans.

## Assignment 4 – Pagination

Consider:

```sql
SELECT *
FROM employees
ORDER BY id
LIMIT 100000, 20;
```

Tasks:

1. Explain why large OFFSET values can be expensive.
2. Rewrite using keyset pagination.
3. Compare the two approaches.

## Assignment 5 – E-Commerce Indexing

Design indexes for:

1. Searching customers by email.
2. Searching products by category and price.
3. Fetching customer orders by date.
4. Fetching order items by order ID.
5. Searching payments by transaction ID.
6. Searching articles by title and content.

For each index:

- Explain why it is needed.
- Explain its column order.
- Identify the queries it can support.
- Consider its write overhead.

---

# 46. Phase 18 – Quick Revision Sheet

| Concept | Meaning |
|---|---|
| Index | Data structure used to find records efficiently |
| B+Tree | Balanced tree structure used by InnoDB ordered indexes |
| Primary Index | Index associated with the primary key |
| Unique Index | Prevents duplicate indexed values |
| Normal Index | Allows duplicate values |
| Composite Index | Index containing multiple columns |
| Clustered Index | InnoDB index whose leaf pages contain complete table rows |
| Secondary Index | Additional index whose leaf entries contain indexed values and primary key |
| Covering Index | Index containing all columns needed by a query |
| Full-Text Index | Index for text search |
| Spatial Index | Index for spatial data |
| Functional Index | Index on an expression |
| Selectivity | Proportion of distinct values compared with total rows |
| Cardinality | Number of distinct values in an index or index prefix |
| Full Table Scan | Reading the table rows to evaluate a query |
| EXPLAIN | Displays the query execution plan |
| EXPLAIN ANALYZE | Executes a query and reports actual execution information |
| Sargability | Ability of a condition to use an index efficiently |
| ICP | Index Condition Pushdown |
| Index Merge | Combining multiple indexes for one table |
| Invisible Index | Index ignored by the optimizer by default |
| Slow Query Log | Records queries that exceed configured thresholds |

### Most Important Commands

```sql
-- Create index
CREATE INDEX idx_name
ON employees(name);

-- Create unique index
CREATE UNIQUE INDEX idx_email
ON employees(email);

-- Create composite index
CREATE INDEX idx_department_salary
ON employees(department_id, salary);

-- View indexes
SHOW INDEX FROM employees;

-- Drop index
DROP INDEX idx_name
ON employees;

-- Analyze query
EXPLAIN
SELECT *
FROM employees
WHERE department_id = 10;

-- Analyze actual execution
EXPLAIN ANALYZE
SELECT *
FROM employees
WHERE department_id = 10;

-- Refresh table statistics
ANALYZE TABLE employees;
```

---

# 47. Phase 18 Completion Checklist

Before moving to Phase 19, make sure you understand:

- [ ] What is a database index?
- [ ] Why do we need indexes?
- [ ] How does a B+Tree work?
- [ ] Primary Key Index.
- [ ] Unique Index.
- [ ] Normal Index.
- [ ] Composite Index.
- [ ] Leftmost Prefix Rule.
- [ ] Clustered Index.
- [ ] Secondary Index.
- [ ] Covering Index.
- [ ] Full-Text Index.
- [ ] Spatial Index.
- [ ] Functional Index.
- [ ] Index Selectivity.
- [ ] Index Cardinality.
- [ ] Full Table Scan.
- [ ] EXPLAIN.
- [ ] EXPLAIN ANALYZE.
- [ ] Sargability.
- [ ] Index Condition Pushdown.
- [ ] Index Merge.
- [ ] Query Optimization.
- [ ] Slow Query Log.
- [ ] Invisible Indexes.
- [ ] Indexing JSON data.
- [ ] Practical index creation and removal.

**Phase 18 is complete when you can identify a slow query, inspect its execution plan, select appropriate indexes, and verify whether your optimization actually improved performance.**

---

# Next Phase – Phase 19: Transactions and ACID Properties

This phase is particularly important when developing applications involving payments, orders, banking, and financial transactions.

We will cover:

1. What Are Database Transactions?
2. Why Do We Need Transactions?
3. START TRANSACTION.
4. COMMIT.
5. ROLLBACK.
6. SAVEPOINT.
7. ROLLBACK TO SAVEPOINT.
8. ACID Properties.
9. Atomicity.
10. Consistency.
11. Isolation.
12. Durability.
13. Autocommit.
14. Implicit vs Explicit Transactions.
15. Transaction States.
16. Transaction Handling in MySQL.
17. Transactions in Banking Applications.
18. Transactions in E-commerce Applications.
19. Transactions with Node.js and MySQL.
20. Common Transaction Mistakes.
21. Interview Questions and Practical Assignments.

**Next: Phase 19 – Transactions and ACID Properties.**