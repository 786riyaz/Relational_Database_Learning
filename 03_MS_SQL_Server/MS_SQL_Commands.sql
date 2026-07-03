# 📁 **SQL Server (MSSQL)**

## 📌 *List of SQL Server Commands*

==================================

### ⭐ Database Commands

```sql
SELECT name FROM sys.databases;
CREATE DATABASE dbname;
DROP DATABASE dbname;
USE dbname;
```

---

### ⭐ Table Commands

```sql
SELECT * FROM INFORMATION_SCHEMA.TABLES;
CREATE TABLE table(...);
DROP TABLE table;
ALTER TABLE table ADD col datatype;
```

---

### ⭐ CRUD

```sql
INSERT INTO table VALUES (...);
SELECT * FROM table;
UPDATE table SET col=value WHERE ...;
DELETE FROM table WHERE ...;
```

---

### ⭐ Joins

```sql
SELECT * FROM A INNER JOIN B ON ...;
SELECT * FROM A LEFT JOIN B ON ...;
SELECT * FROM A RIGHT JOIN B ON ...;
FULL OUTER JOIN
```

---

### ⭐ Constraints

```sql
PRIMARY KEY(col)
FOREIGN KEY(col)
REFERENCES t(col)
UNIQUE(col)
CHECK(condition)
```

---

### ⭐ Views

```sql
CREATE VIEW view_name AS SELECT ...;
DROP VIEW view_name;
```

---

### ⭐ Indexes

```sql
CREATE INDEX idx ON table(col);
DROP INDEX idx ON table;
```

---

### ⭐ Stored Procedure

```sql
CREATE PROCEDURE GetData
AS
BEGIN
  SELECT * FROM Employees;
END;
```

---

### ⭐ Functions

```sql
CREATE FUNCTION dbo.func(@x INT)
RETURNS INT
AS
BEGIN
 RETURN @x * 2;
END;
```

---

### ⭐ Triggers

```sql
CREATE TRIGGER trg ON table
AFTER INSERT
AS
BEGIN
   PRINT 'Inserted!';
END;
```

---

### ⭐ Transactions

```sql
BEGIN TRAN;
COMMIT TRAN;
ROLLBACK TRAN;
```

---

### ⭐ Backup Commands

```sql
BACKUP DATABASE db TO DISK='C:\backup.bak';
RESTORE DATABASE db FROM DISK='C:\backup.bak';
```

---

---