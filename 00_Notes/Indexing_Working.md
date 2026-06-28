## What Is an Index?

A **database index** is a **data structure that allows the database to find rows faster**, similar to an index in a book.

> **Index = fast lookup structure pointing to actual data rows**

---

![Image](https://builtin.com/sites/www.builtin.com/files/styles/ckeditor_optimize/public/inline-images/1_b-tree-indexing.jpg)

![Image](https://dotnettutorials.net/wp-content/uploads/2020/01/c-users-pranaya-pictures-index-seek-in-sql-server.png)

![Image](https://josipmisko.com/img/clustered-vs-nonclustered-index.webp)

---

## Why Indexes Exist

Without an index:

* Database scans **every row** (full table scan)
* Time complexity ≈ **O(n)**

With an index:

* Database uses **tree-based lookup**
* Time complexity ≈ **O(log n)**

This is critical for **large tables**.

---

## How an Index Works Internally

### Step-by-Step

1. Database creates an **index structure** on a column
2. Index stores:

   * Column value
   * Pointer to the row location (row id / primary key)
3. On query:

   * DB searches index first
   * Uses pointer to fetch actual row

### Example

```sql
SELECT * FROM users WHERE email = 'a@b.com';
```

* Index on `email` → direct lookup
* No full table scan

---

## Most Common Index Data Structure: B-Tree

### Why B-Tree?

* Balanced
* Sorted
* Optimized for disk reads
* Works well for:

  * `=`
  * `<`, `>`
  * `BETWEEN`
  * `ORDER BY`

### Simplified View

```
        [M]
      /     \
   [A-F]   [N-Z]
```

---

## Types of Indexes (Interview Must-Know)

### 1️⃣ Primary Index (Clustered)

* Data is **physically ordered**
* Only **one per table**
* Usually on primary key

```sql
PRIMARY KEY (id)
```

---

### 2️⃣ Secondary Index (Non-Clustered)

* Separate structure
* Points to primary key
* Multiple allowed

```sql
CREATE INDEX idx_email ON users(email);
```

---

### 3️⃣ Unique Index

* Prevents duplicates

```sql
CREATE UNIQUE INDEX idx_email ON users(email);
```

---

### 4️⃣ Composite Index

* Index on multiple columns

```sql
CREATE INDEX idx_name_age ON users(name, age);
```

⚠️ Order matters:

* `(name, age)` ≠ `(age, name)`

---

### 5️⃣ Hash Index (Equality Only)

* Very fast for `=`
* No range queries

Used in some engines internally.

---

## Clustered vs Non-Clustered (Very Important)

| Aspect       | Clustered             | Non-Clustered      |
| ------------ | --------------------- | ------------------ |
| Data order   | Physically sorted     | Separate structure |
| Count        | One per table         | Many               |
| Lookup speed | Very fast             | Slightly slower    |
| Storage      | Data + index together | Index separate     |

---

## When Indexes Are Used (Query Planner)

Indexes are used when:

* Column is in `WHERE`
* Column is in `JOIN`
* Column is in `ORDER BY`
* Column is in `GROUP BY`

Database decides using:

* Statistics
* Cost-based optimizer

---

## When Indexes Are NOT Used (Important)

Indexes may be ignored if:

* Column has low cardinality
* Functions applied to column

```sql
WHERE LOWER(email) = 'a@b.com'  -- index ignored
```

* Leading column of composite index not used
* Small tables (scan is cheaper)

---

## Trade-Offs of Indexes

### Advantages

* Faster reads
* Faster joins
* Efficient sorting

### Disadvantages

* Slower writes (`INSERT`, `UPDATE`, `DELETE`)
* Extra storage
* Index maintenance cost

> Indexes optimize **read-heavy** workloads.

---

## MongoDB Indexes (Quick Context)

* Uses **B-Tree**
* `_id` index by default
* Compound indexes supported

```js
db.users.createIndex({ email: 1 });
```

---

## Interview One-Liner (Memorize)

> “A database index is a data structure, typically a B-tree, that allows fast lookup of rows by maintaining sorted references to table data, reducing full table scans at the cost of additional storage and slower writes.”

---

## Common Interview Traps

❌ “More indexes always improve performance”
❌ “Indexes speed up writes”
❌ “Indexes are always used”

---

## Final Summary

* Indexes speed up **read operations**
* Implemented using **B-trees**
* Reduce search from O(n) → O(log n)
* Come with write and storage overhead
* Must be designed based on query patterns