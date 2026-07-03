# 📁 **SQLite**

## 📌 *List of SQLite Commands*

==================================

### ⭐ Database Creation

```bash
sqlite3 mydb.db
```

---

### ⭐ Table Commands

```sql
.tables
.schema table_name
CREATE TABLE table(...);
DROP TABLE table;
ALTER TABLE table ADD COLUMN col type;
```

---

### ⭐ CRUD

```sql
INSERT INTO table VALUES (...);
SELECT * FROM table;
UPDATE table SET col=value;
DELETE FROM table;
```

---

### ⭐ Joins

```sql
SELECT * FROM A INNER JOIN B ON ...;
SELECT * FROM A LEFT JOIN B ON ...;
```

---

### ⭐ Constraints (SQLite supports limited ones)

```sql
PRIMARY KEY
UNIQUE
CHECK
FOREIGN KEY (requires PRAGMA foreign_keys=ON)
```

---

### ⭐ Views

```sql
CREATE VIEW v AS SELECT ...;
DROP VIEW v;
```

---

### ⭐ Indexes

```sql
CREATE INDEX idx ON table(col);
DROP INDEX idx;
```

---

### ⭐ Transactions

```sql
BEGIN;
COMMIT;
ROLLBACK;
```

---

### ⭐ Import / Export

```sql
.mode csv
.import file.csv table
```