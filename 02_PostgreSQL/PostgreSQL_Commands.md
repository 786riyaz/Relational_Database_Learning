# 📁 **PostgreSQL**

## 📌 *List of PostgreSQL Commands*

==================================

### ⭐ Database Commands

```sql
\l                 -- List databases
CREATE DATABASE db;
DROP DATABASE db;
\c dbname          -- Connect database
```

---

### ⭐ Table Commands

```sql
\dt                      -- List tables
\d table                 -- Describe table
CREATE TABLE table(...);
DROP TABLE table;
ALTER TABLE t ADD COLUMN col type;
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
SELECT * FROM A FULL JOIN B ON ...;
```

---

### ⭐ Constraints

```sql
PRIMARY KEY (col)
UNIQUE (col)
CHECK (expr)
REFERENCES t(col)
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

### ⭐ Functions

```sql
CREATE FUNCTION func(x INT) RETURNS INT AS $$
BEGIN
 RETURN x * 2;
END;
$$ LANGUAGE plpgsql;
```

---

### ⭐ Stored Procedures (PG ≥ 11)

```sql
CREATE PROCEDURE proc() LANGUAGE plpgsql AS $$
BEGIN
   RAISE NOTICE 'Hello';
END;
$$;
```

---

### ⭐ Triggers

```sql
CREATE FUNCTION trg_func() RETURNS trigger AS $$
BEGIN
  NEW.created_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg BEFORE INSERT ON table
FOR EACH ROW EXECUTE FUNCTION trg_func();
```

---

### ⭐ Transactions

```sql
BEGIN;
COMMIT;
ROLLBACK;
```

---

### ⭐ Backup / Restore

```bash
pg_dump db > backup.sql
psql db < backup.sql
```

---

---