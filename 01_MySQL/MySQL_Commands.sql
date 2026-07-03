# 📁 **MySQL**

## 📌 *List of MySQL Commands*

==================================

### ⭐ Database Commands

```sql
SHOW DATABASES;
CREATE DATABASE dbname;
DROP DATABASE dbname;
USE dbname;
```

---

### ⭐ Table Commands

```sql
SHOW TABLES;
DESCRIBE table_name;
CREATE TABLE table_name (...);
DROP TABLE table_name;
ALTER TABLE table_name ADD COLUMN col datatype;
ALTER TABLE table_name DROP COLUMN col;
```

---

### ⭐ CRUD

```sql
INSERT INTO table (col) VALUES (...);
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
```

---

### ⭐ Constraints

```sql
PRIMARY KEY (col);
FOREIGN KEY (col) REFERENCES t(c);
UNIQUE (col);
CHECK (condition);
DEFAULT value;
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

### ⭐ Stored Procedures

```sql
DELIMITER //
CREATE PROCEDURE proc_name()
BEGIN
   SELECT * FROM table;
END //
DELIMITER ;
```

---

### ⭐ Functions

```sql
DELIMITER //
CREATE FUNCTION func(x INT) RETURNS INT
RETURN x * 2;
//
DELIMITER ;
```

---

### ⭐ Triggers

```sql
CREATE TRIGGER trg BEFORE INSERT ON table
FOR EACH ROW SET NEW.created_at = NOW();
```

---

### ⭐ Transactions

```sql
START TRANSACTION;
COMMIT;
ROLLBACK;
```

---

### ⭐ Export / Import

```bash
mysqldump -u root -p db > backup.sql
mysql -u root -p db < backup.sql
```

---

---