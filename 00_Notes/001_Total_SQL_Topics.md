# 📘 Complete SQL + RDBMS Learning Path (Beginner → Advanced)

A fully detailed, single-file explanation of every concept you listed — with definitions, explanations, examples, and clarity.

---

# **1️⃣ Introduction & Fundamentals**

### **What is Data?**

Data is any collection of facts, values, or information stored for future use.
Example: Names, prices, dates, employee records.

### **What is Structured Data?**

Data arranged in rows and columns (tabular form).
Example: Excel sheet, SQL table.

### **How Structured Data is Stored?**

Using **databases** — specifically relational databases.

### **Why SQL is Needed?**

SQL is the standard language for storing, retrieving, and managing structured data.

### **SQL vs Excel**

* **SQL** handles large datasets, automation, multi-user systems.
* **Excel** is good for small datasets and manual analysis.

### **What is a Database?**

A container that stores structured data.
Example: `FixifyDB`, `EmployeesDB`.

### **Why Databases are Needed?**

* Fast searching
* Consistency
* Concurrency
* Security

### **DBMS vs RDBMS**

* **DBMS:** Stores data (no relations). Example: File-based DB.
* **RDBMS:** Stores data in tables with relationships.

### **SQL vs MSSQL**

* **SQL:** Language
* **MSSQL:** Microsoft SQL Server — an RDBMS

### **SQL vs NoSQL**

* **SQL:** Structured, tables
* **NoSQL:** Unstructured, document/graph/column DBs

### **Schema**

Structure of database objects (tables, columns, keys).

---

# **2️⃣ Installation & Setup**

### Tools You Can Install

* **MSSQL (SQL Server)** — Windows/Mac
* **MySQL + Workbench**
* **SQLite Browser**
* **PostgreSQL + pgAdmin**
* **XAMPP** (MySQL + PHP + Apache bundle)

All tools allow writing, executing, and debugging SQL.

---

# **3️⃣ Understanding Databases**

### **Query for Databases**

```sql
SHOW DATABASES; -- MySQL
SELECT name FROM sys.databases; -- MSSQL
```

### **System Databases**

Built-in databases used internally.
Examples:

* MySQL → `information_schema`
* MSSQL → `master`, `tempdb`

### **Create Database**

```sql
CREATE DATABASE CompanyDB;
```

### **Use Database**

```sql
USE CompanyDB;
```

### **Delete Database**

```sql
DROP DATABASE CompanyDB;
```

### **SQL Scripts**

SQL files containing queries saved as `.sql`.

---

# **4️⃣ Tables & Data Modeling Basics**

### **What is a Table?**

Stores data in rows (records) and columns (fields).

### **Columns, Rows, Attributes**

* **Column:** Name, datatype
* **Row:** A single record
* **Attribute:** Property of an entity

### **Common Datatypes**

`INT`, `VARCHAR`, `DATE`, `FLOAT`, `BOOLEAN`

### **Constraints**

Rules applied to table data.

### **Primary Key**

Uniquely identifies a row.

```sql
id INT PRIMARY KEY
```

### **Foreign Key**

Represents relationship between tables.

### **Unique Key**

Ensures no duplicates.

### **NOT NULL**

Value cannot be empty.

### **DEFAULT**

Automatically sets a value.

### **CHECK**

Validates data.

```sql
CHECK (age >= 18)
```

### **Auto Increment**

Automatically increments integer.

### **On Delete Rules**

* `CASCADE`
* `SET NULL`

### **Create Table Example**

```sql
CREATE TABLE Employees (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  age INT CHECK (age >= 18),
  salary DECIMAL(10,2) DEFAULT 0
);
```

### **Alter Table**

```sql
ALTER TABLE Employees ADD department VARCHAR(50);
```

### **Drop Column**

```sql
ALTER TABLE Employees DROP COLUMN department;
```

### **Drop Table**

```sql
DROP TABLE Employees;
```

### **Truncate Table**

Clears table but keeps structure.

```sql
TRUNCATE TABLE Employees;
```

---

# **5️⃣ Normalization & ER Modeling**

### **Why Normalize?**

Avoid:

* redundancy
* anomalies

### **1NF**

No repeating groups.

### **2NF**

Full dependency on primary key.

### **3NF**

No transitive dependency.

### **BCNF**

Stronger version of 3NF.

### **ER Diagram Components**

* **Entity:** Table
* **Attributes:** Columns
* **Relationships:** Lines connecting tables

### **1-to-Many Example**

One customer → many orders.

### **Many-to-Many Example**

Students & Courses → Junction table.

---

# **6️⃣ Basic SQL – CRUD**

### **INSERT**

```sql
INSERT INTO Employees (name, age) VALUES ('Amit', 25);
```

### **SELECT**

```sql
SELECT * FROM Employees;
```

### **UPDATE**

```sql
UPDATE Employees SET age = 30 WHERE id = 1;
```

### **DELETE**

```sql
DELETE FROM Employees WHERE id = 1;
```

### **TRUNCATE**

```sql
TRUNCATE TABLE Employees;
```

---

# **7️⃣ SQL Clauses**

### **WHERE**

```sql
SELECT * FROM Employees WHERE age > 25;
```

### **DISTINCT**

```sql
SELECT DISTINCT department FROM Employees;
```

### **ORDER BY**

```sql
ORDER BY salary DESC;
```

### **LIKE**

```sql
WHERE name LIKE 'A%';
```

### **TOP / LIMIT**

```sql
SELECT TOP 5 * FROM Employees; -- SQL Server
SELECT * FROM Employees LIMIT 5; -- MySQL
```

### **IN / NOT IN**

```sql
WHERE department IN ('IT', 'HR');
```

### **BETWEEN**

```sql
WHERE age BETWEEN 20 AND 30;
```

### **CASE**

```sql
CASE WHEN salary > 50000 THEN 'High' ELSE 'Low' END AS Category
```

---

# **8️⃣ Aggregate Functions & Grouping**

### Examples:

```sql
SELECT COUNT(*), AVG(salary) FROM Employees;
```

### GROUP BY

```sql
SELECT department, COUNT(*) FROM Employees GROUP BY department;
```

### HAVING

```sql
HAVING COUNT(*) > 2;
```

### GROUP BY ROLLUP

Generates subtotals.

---

# **9️⃣ Joins**

### **INNER JOIN**

```sql
SELECT * FROM Employees e
JOIN Departments d ON e.dept_id = d.id;
```

### **LEFT JOIN**

Returns all from left.

### **RIGHT JOIN**

Returns all from right.

### **FULL OUTER JOIN**

Returns unmatched from both.

### **SELF JOIN**

Table joins to itself.

### **APPLY (SQL Server)**

Used for functions.

---

# **🔟 Subqueries**

### **Basic Subquery**

```sql
SELECT * FROM Employees WHERE salary > (SELECT AVG(salary) FROM Employees);
```

### **Correlated Subquery**

Runs per row.

### **EXISTS**

```sql
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.emp_id = e.id)
```

### **ANY / ALL**

```sql
salary > ALL (SELECT salary FROM Employees WHERE dept = 'HR')
```

---

# **1️⃣1️⃣ String & Date Functions**

### **String Examples**

```sql
SELECT LOWER(name), UPPER(name), SUBSTRING(name,1,3) FROM Employees;
```

### **Date Examples**

```sql
SELECT NOW(), DATEDIFF(NOW(), '2024-01-01');
```

---

# **1️⃣2️⃣ Advanced Table Operations**

Including complex constraint updates.

```sql
ALTER TABLE Employees MODIFY salary DECIMAL(12,2);
```

---

# **1️⃣3️⃣ Indexes & Performance**

### **What is an Index?**

A pointer for fast searching.

### **Types**

* Clustered
* Non-Clustered
* Composite
* Full-Text

### **Create Index**

```sql
CREATE INDEX idx_name ON Employees(name);
```

---

# **1️⃣4️⃣ Views**

### **Create View**

```sql
CREATE VIEW HighSalary AS
SELECT * FROM Employees WHERE salary > 50000;
```

---

# **1️⃣5️⃣ Transactions**

```sql
BEGIN;
UPDATE Employees SET salary = salary + 1000;
COMMIT;
```

* `ROLLBACK` cancels changes.
* `SAVEPOINT` sets restore point.

---

# **1️⃣6️⃣ Stored Routines**

### **Stored Procedure**

```sql
CREATE PROCEDURE GetEmployees()
BEGIN
  SELECT * FROM Employees;
END;
```

### **Function**

```sql
CREATE FUNCTION GetYearlySalary(s DECIMAL)
RETURNS DECIMAL
RETURN s * 12;
```

---

# **1️⃣7️⃣ Triggers**

```sql
CREATE TRIGGER before_insert BEFORE INSERT ON Employees
FOR EACH ROW SET NEW.created_at = NOW();
```

---

# **1️⃣8️⃣ Window Functions**

```sql
SELECT name, salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM Employees;
```

---

# **1️⃣9️⃣ CTE**

### **Recursive Example**

```sql
WITH RECURSIVE numbers AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n+1 FROM numbers WHERE n < 10
)
SELECT * FROM numbers;
```

---

# **2️⃣0️⃣ Security & Access Control**

### **Create User**

```sql
CREATE USER 'riyaz' IDENTIFIED BY 'password';
```

### **GRANT**

```sql
GRANT SELECT, INSERT ON CompanyDB.* TO 'riyaz';
```

### **SQL Injection Prevention**

Use **prepared statements**.

---

# **2️⃣1️⃣ Data Import / Export**

### Import CSV

```sql
LOAD DATA INFILE 'data.csv'
INTO TABLE Employees
FIELDS TERMINATED BY ',';
```

### Export Database (MySQL)

```
mysqldump -u root -p CompanyDB > backup.sql
```

### Generate Random Data

Using loops, stored procedures, or Python/Node scripts.

---

# ✅ End of Complete SQL + RDBMS Learning Path

All topics included in detailed, exam-ready format.
