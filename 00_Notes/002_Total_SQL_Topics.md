# 📘 **Complete SQL + RDBMS Learning Path (Beautified Version)**

A fully formatted, beautifully structured, clean, and readable SQL + RDBMS learning guide.

---

# 🧩 **1️⃣ Introduction & Fundamentals**

## 📌 What is Data?

| Type              | Example                      |
| ----------------- | ---------------------------- |
| Raw Facts         | 25, "Riyaz", 45, "Developer" |
| Structured Data   | Tables, rows, columns        |
| Unstructured Data | Images, videos, logs         |

---

## 📌 What is Structured Data?

Data arranged in **rows & columns**.

### Example (Employee Table):

| ID | Name | Age | Salary |
| -- | ---- | --- | ------ |
| 1  | Amit | 25  | 35000  |
| 2  | Neha | 28  | 48000  |

---

## 📌 DBMS vs RDBMS

| Feature       | DBMS      | RDBMS                    |
| ------------- | --------- | ------------------------ |
| Data Format   | Files     | Tables                   |
| Relationships | ❌ No      | ✅ Yes                    |
| Security      | Low       | High                     |
| Example       | MS Access | MySQL, MSSQL, PostgreSQL |

---

# 🛠 **2️⃣ Installation & Setup**

| RDBMS      | Tool        | Supported OS |
| ---------- | ----------- | ------------ |
| MySQL      | Workbench   | Win, Mac     |
| PostgreSQL | pgAdmin     | Win, Mac     |
| MSSQL      | SSMS        | Win, Mac     |
| SQLite     | DB Browser  | Win, Mac     |
| XAMPP      | MySQL + PHP | Win, Mac     |

---

# 🗄 **3️⃣ Understanding Databases**

## 📌 Show Databases

```sql
SHOW DATABASES; -- MySQL
SELECT name FROM sys.databases; -- SQL Server
```

## 📌 Create Database

```sql
CREATE DATABASE CompanyDB;
```

## 📌 Drop Database

```sql
DROP DATABASE CompanyDB;
```

---

# 🧱 **4️⃣ Tables & Data Modeling Basics**

## 📌 Table Components

| Component  | Meaning                |
| ---------- | ---------------------- |
| Column     | Field name + datatype  |
| Row        | Actual record          |
| Constraint | Rule applied to column |

---

## 📌 Common Constraints

| Constraint  | Meaning               | Example                     |
| ----------- | --------------------- | --------------------------- |
| PRIMARY KEY | Unique + Not Null     | id INT PRIMARY KEY          |
| FOREIGN KEY | Link to another table | dept_id REFERENCES dept(id) |
| UNIQUE      | No duplicates         | email UNIQUE                |
| NOT NULL    | Cannot be empty       | name VARCHAR(20) NOT NULL   |
| CHECK       | Apply condition       | CHECK (age > 18)            |
| DEFAULT     | Auto value            | created_at DEFAULT NOW()    |

---

## 📌 Create Table Example

```sql
CREATE TABLE Employees (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  age INT CHECK (age >= 18),
  salary DECIMAL(10,2) DEFAULT 0,
  department VARCHAR(50)
);
```

---

# 🗂 **5️⃣ Normalization & ER Modeling**

## 📌 Normal Forms Summary

| Normal Form | Rule                     | Example Fix                                            |
| ----------- | ------------------------ | ------------------------------------------------------ |
| 1NF         | No repeating groups      | Remove multi-valued columns                            |
| 2NF         | No partial dependency    | Remove columns depending on only part of composite key |
| 3NF         | No transitive dependency | Move derived columns to another table                  |
| BCNF        | Stronger 3NF             | Every determinant is a key                             |

---

## 📌 Relationship Types

| Type      | Meaning                 | Example           |
| --------- | ----------------------- | ----------------- |
| 1–1       | One record ↔ One record | Person → Passport |
| 1–Many    | One ↔ Many              | Customer → Orders |
| Many–Many | Many ↔ Many             | Student ↔ Courses |

---

# ✏️ **6️⃣ CRUD Operations**

## INSERT

```sql
INSERT INTO Employees (name, age) VALUES ('Amit', 25);
```

## SELECT

```sql
SELECT * FROM Employees;
```

## UPDATE

```sql
UPDATE Employees SET salary = 40000 WHERE id = 1;
```

## DELETE

```sql
DELETE FROM Employees WHERE id = 1;
```

---

# 🔎 **7️⃣ SQL Clauses**

### WHERE

```sql
SELECT * FROM Employees WHERE age > 25;
```

### ORDER BY

```sql
SELECT * FROM Employees ORDER BY salary DESC;
```

### LIKE

| Pattern | Meaning       |
| ------- | ------------- |
| 'A%'    | Starts with A |
| '%n'    | Ends with n   |
| '%ra%'  | Contains ra   |

### LIMIT / TOP

```sql
SELECT * FROM Employees LIMIT 5; -- MySQL
SELECT TOP 5 * FROM Employees; -- MSSQL
```

---

# 📊 **8️⃣ Aggregate Functions & Grouping**

## Aggregate Examples

```sql
SELECT COUNT(*), AVG(salary), MAX(age) FROM Employees;
```

## GROUP BY

```sql
SELECT department, COUNT(*) FROM Employees GROUP BY department;
```

## HAVING

```sql
HAVING COUNT(*) > 2;
```

---

# 🔗 **9️⃣ JOINS**

## Join Comparison Table

| Join Type  | Returns                  |
| ---------- | ------------------------ |
| INNER JOIN | Matching rows only       |
| LEFT JOIN  | All from left + matches  |
| RIGHT JOIN | All from right + matches |
| FULL JOIN  | All rows from both       |
| SELF JOIN  | Table joined with itself |

### INNER JOIN Example

```sql
SELECT e.name, d.department_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.id;
```

---

# 🧠 **🔟 Subqueries**

### Basic Subquery

```sql
SELECT * FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);
```

### EXISTS

```sql
SELECT name FROM Employees e
WHERE EXISTS (
  SELECT 1 FROM Orders o WHERE o.emp_id = e.id
);
```

---

# 🔤 **1️⃣1️⃣ String Functions**

| Function    | Example             |
| ----------- | ------------------- |
| LOWER()     | lower(name)         |
| UPPER()     | UPPER(name)         |
| LENGTH()    | LENGTH(name)        |
| SUBSTRING() | SUBSTRING(name,1,3) |
| TRIM()      | TRIM(name)          |

---

# 🗓 **1️⃣2️⃣ Date Functions**

| Function   | Purpose               |
| ---------- | --------------------- |
| NOW()      | Current timestamp     |
| DATEDIFF() | Difference in days    |
| DATEADD()  | Add days/months/years |

Example:

```sql
SELECT NOW(), DATEADD(day, 5, NOW());
```

---

# 🏗 **1️⃣3️⃣ Indexes & Performance**

| Index Type    | Purpose                     |
| ------------- | --------------------------- |
| Clustered     | Physically sorts table      |
| Non-Clustered | Logical pointer-based index |
| Composite     | Index on multiple columns   |
| Full-Text     | Searching text              |

### Create Index

```sql
CREATE INDEX idx_name ON Employees(name);
```

---

# 👁 **1️⃣4️⃣ Views**

```sql
CREATE VIEW HighSalary AS
SELECT * FROM Employees WHERE salary > 50000;
```

---

# 🔒 **1️⃣5️⃣ Transactions**

```sql
START TRANSACTION;
UPDATE Employees SET salary = 60000 WHERE id = 4;
COMMIT;
```

---

# ⚙️ **1️⃣6️⃣ Stored Procedures & Functions**

### Procedure

```sql
CREATE PROCEDURE GetEmployees()
BEGIN
  SELECT * FROM Employees;
END;
```

### Function

```sql
CREATE FUNCTION YearlySalary(s DECIMAL)
RETURNS DECIMAL
RETURN s * 12;
```

---

# 🔔 **1️⃣7️⃣ Triggers**

```sql
CREATE TRIGGER before_insert_emp
BEFORE INSERT ON Employees
FOR EACH ROW SET NEW.created_at = NOW();
```

---

# 📈 **1️⃣8️⃣ Window Functions**

```sql
SELECT name, salary,
RANK() OVER (ORDER BY salary DESC) AS rank_pos
FROM Employees;
```

---

# 🪜 **1️⃣9️⃣ CTE (Common Table Expressions)**

```sql
WITH RECURSIVE numbers AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n+1 FROM numbers WHERE n < 10
)
SELECT * FROM numbers;
```

---

# 🔐 **2️⃣0️⃣ Security & Access Control**

### Create User

```sql
CREATE USER 'riyaz' IDENTIFIED BY 'pass123';
```

### Grant Permissions

```sql
GRANT SELECT, INSERT ON CompanyDB.* TO 'riyaz';
```

### SQL Injection Prevention

Use Prepared Statements.

---

# 📥 **2️⃣1️⃣ Data Import / Export**

### Import CSV

```sql
LOAD DATA INFILE 'data.csv'
INTO TABLE Employees
FIELDS TERMINATED BY ',';
```

### Export DB

```
mysqldump -u root -p CompanyDB > backup.sql
```