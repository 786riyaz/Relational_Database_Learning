## Assumption

Table: `employees`
Column: `salary`

---

## 1️⃣ Find the 3rd Highest **DISTINCT** Salary (Most Common Interview Case)

### Using `LIMIT` / `OFFSET` (MySQL, PostgreSQL)

```sql
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 2;
```

**Explanation**

* `ORDER BY salary DESC` → highest first
* `OFFSET 2` → skip top 2 salaries
* `LIMIT 1` → return 3rd

---

## 2️⃣ Using Subquery (Works in Almost All Databases)

```sql
SELECT MAX(salary) AS third_max_salary
FROM employees
WHERE salary < (
  SELECT MAX(salary)
  FROM employees
  WHERE salary < (
    SELECT MAX(salary)
    FROM employees
  )
);
```

✔ No `LIMIT`
✔ Very common interview answer

---

## 3️⃣ Using Window Functions (Recommended – Modern SQL)

### Using `DENSE_RANK()` (Correct for duplicates)

```sql
SELECT salary
FROM (
  SELECT salary,
         DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
  FROM employees
) t
WHERE rnk = 3;
```

**Why `DENSE_RANK()`?**

* Handles duplicate salaries correctly
* Counts **distinct ranks**

---

## 4️⃣ Using `ROW_NUMBER()` (If duplicates don’t matter)

```sql
SELECT salary
FROM (
  SELECT salary,
         ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn
  FROM employees
) t
WHERE rn = 3;
```

⚠️ Not correct if salaries repeat

---

## Which One Should You Say in Interviews?

| Situation              | Best Answer    |
| ---------------------- | -------------- |
| Simple DB              | `LIMIT OFFSET` |
| Cross-DB compatibility | Nested `MAX()` |
| Modern SQL             | `DENSE_RANK()` |

---

## Interview One-Liner (Memorize This)

> “To find the 3rd maximum salary, I can use `DENSE_RANK()` over salaries ordered descending and filter where rank equals 3, which correctly handles duplicate values.”

---

## Bonus: If 3rd Max Does NOT Exist

### Return `NULL` safely

```sql
SELECT (
  SELECT DISTINCT salary
  FROM employees
  ORDER BY salary DESC
  LIMIT 1 OFFSET 2
) AS third_max_salary;
```

---

## Very Common Interview Trap

❌ Using `ROW_NUMBER()` when duplicates exist
❌ Forgetting `DISTINCT`
❌ Not ordering descending

---

If you want, I can next explain:

* Nth highest salary (generic query)
* Difference between `RANK`, `DENSE_RANK`, `ROW_NUMBER`
* SQL queries asked in 90% of interviews

Tell me what you want next.
