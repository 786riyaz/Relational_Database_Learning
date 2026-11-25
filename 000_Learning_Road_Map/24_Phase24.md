# SQL Complete Learning Roadmap – Phase 24
# Advanced Database Management

In this phase, we will learn how to manage MySQL databases in real-world production environments.

Until now, we have focused primarily on writing SQL queries, designing databases, managing transactions, and optimizing queries.

But working as a backend developer also requires understanding database administration.

For example:

- How do you create different database users?
- How do you restrict database access?
- How do you back up a production database?
- How do you restore a database after failure?
- How do you schedule database operations?
- How do you manage millions of records?
- How do you monitor MySQL performance?
- How do you configure a MySQL server?

These are the topics we will cover.

## Topics Covered

1. MySQL User Management
2. Database Privileges
3. GRANT and REVOKE
4. MySQL Roles
5. Authentication and Password Policies
6. Database Backup and Restore
7. Importing and Exporting Data
8. MySQL Event Scheduler
9. Database Partitioning
10. Generated Columns
11. Advanced JSON Operations
12. Database Monitoring
13. Performance Schema
14. Information Schema
15. MySQL Configuration and Server Variables
16. Production Database Best Practices

---

# 1. MySQL User Management

In a real-world application, multiple users and applications may connect to the same MySQL server.

For example:

| User | Responsibility |
|---|---|
| root | Database administration |
| backend_user | Application database operations |
| reporting_user | Read-only reports |
| developer_user | Development and debugging |
| backup_user | Database backups |

You should not give every user complete database access.

Instead, create separate MySQL accounts with appropriate permissions.

## 1.1 Show Existing Users

MySQL stores account information in the `mysql.user` system table.

To view users:

```sql
SELECT
    User,
    Host
FROM mysql.user;
```

Example:

| User | Host |
|---|---|
| root | localhost |
| backend_user | localhost |
| reporting_user | % |

**Important:** Access to system tables is restricted. Normal database users may not have permission to query them.

## 1.2 Create a MySQL User

Syntax:

```sql
CREATE USER 'username'@'hostname'
IDENTIFIED BY 'password';
```

Example:

```sql
CREATE USER 'backend_user'@'localhost'
IDENTIFIED BY 'StrongPassword@123';
```

Here:

- `backend_user` is the username.
- `localhost` specifies where the user can connect from.
- `IDENTIFIED BY` specifies the password.

### Understanding Host

The host determines which client hosts are allowed to connect using that account.

Common examples:

| Host | Meaning |
|---|---|
| localhost | Local connections |
| 127.0.0.1 | IPv4 loopback address |
| % | Any host, subject to network and server access controls |
| 192.168.1.% | Matching hosts in that IPv4 range |

Example:

```sql
CREATE USER 'developer'@'192.168.1.%'
IDENTIFIED BY 'StrongPassword@123';
```

This account can connect from matching IP addresses, assuming network access and MySQL configuration permit it.

**Important:** `'user'@'localhost'` and `'user'@'%'` are different MySQL accounts.

## 1.3 Create User If Not Exists

```sql
CREATE USER IF NOT EXISTS 'reporting_user'@'localhost'
IDENTIFIED BY 'StrongPassword@123';
```

This avoids an error if the account already exists.

## 1.4 Rename a User

```sql
RENAME USER
'old_user'@'localhost'
TO
'new_user'@'localhost';
```

## 1.5 Change a User Password

```sql
ALTER USER 'backend_user'@'localhost'
IDENTIFIED BY 'NewStrongPassword@123';
```

## 1.6 Delete a User

```sql
DROP USER 'backend_user'@'localhost';
```

Safer:

```sql
DROP USER IF EXISTS 'backend_user'@'localhost';
```

### Important

Dropping a MySQL user does not delete the databases or tables owned or accessed by that user.

It removes the account and its associated privileges.

---

# 2. MySQL Database Privileges

Creating a user does not automatically give that user permission to access your databases.

You must grant privileges.

MySQL supports different types of privileges.

## 2.1 Common MySQL Privileges

| Privilege | Purpose |
|---|---|
| SELECT | Read data |
| INSERT | Insert records |
| UPDATE | Update records |
| DELETE | Delete records |
| CREATE | Create databases or tables |
| ALTER | Modify table structures |
| DROP | Drop databases or tables |
| INDEX | Create and drop indexes |
| EXECUTE | Execute stored routines |
| CREATE VIEW | Create views |
| SHOW VIEW | View view definitions |
| TRIGGER | Create and manage triggers |
| CREATE ROUTINE | Create stored procedures and functions |
| EVENT | Create and manage events |
| REFERENCES | Create foreign key references |
| CREATE TEMPORARY TABLES | Create temporary tables |
| LOCK TABLES | Lock tables |

There are also administrative privileges, such as:

- PROCESS
- RELOAD
- REPLICATION CLIENT
- REPLICATION SLAVE
- SYSTEM_VARIABLES_ADMIN

These should be granted carefully.

---

# 3. GRANT Statement

The `GRANT` statement gives privileges to MySQL users or roles.

### Syntax

```sql
GRANT privilege_name
ON database_name.table_name
TO 'username'@'hostname';
```

## 3.1 Grant SELECT Permission

Suppose you have a database named `company_db`.

```sql
GRANT SELECT
ON company_db.*
TO 'reporting_user'@'localhost';
```

Now the user can read tables in `company_db`.

## 3.2 Grant Multiple Permissions

```sql
GRANT
SELECT,
INSERT,
UPDATE,
DELETE
ON company_db.*
TO 'backend_user'@'localhost';
```

This user can perform normal CRUD operations.

## 3.3 Grant Permission on a Specific Table

```sql
GRANT SELECT
ON company_db.employees
TO 'reporting_user'@'localhost';
```

The user can read only the specified table through this grant.

## 3.4 Grant All Privileges

```sql
GRANT ALL PRIVILEGES
ON company_db.*
TO 'backend_user'@'localhost';
```

This grants all applicable privileges at that database scope.

**Important:** `ALL PRIVILEGES` at a database scope is not the same as granting every administrative privilege on the entire MySQL server.

Avoid giving application users unnecessary permissions.

## 3.5 Grant Global Privileges

```sql
GRANT SELECT
ON *.*
TO 'reporting_user'@'localhost';
```

This grants SELECT access across databases on the server, subject to MySQL's privilege rules.

Use global privileges cautiously.

---

# 4. REVOKE Statement

The `REVOKE` statement removes privileges.

### Syntax

```sql
REVOKE privilege_name
ON database_name.table_name
FROM 'username'@'hostname';
```

Example:

```sql
REVOKE DELETE
ON company_db.*
FROM 'backend_user'@'localhost';
```

Now the user no longer has DELETE permission through that grant.

### Revoke Multiple Permissions

```sql
REVOKE
INSERT,
UPDATE
ON company_db.*
FROM 'backend_user'@'localhost';
```

### Revoke All Privileges at a Scope

```sql
REVOKE ALL PRIVILEGES
ON company_db.*
FROM 'backend_user'@'localhost';
```

This removes applicable privileges granted at that database scope.

It does not necessarily remove privileges granted at other scopes or inherited through roles.

---

# 5. Checking User Privileges

To inspect a user's grants:

```sql
SHOW GRANTS FOR 'backend_user'@'localhost';
```

Example output:

```sql
GRANT SELECT, INSERT, UPDATE, DELETE
ON `company_db`.*
TO `backend_user`@`localhost`;
```

To inspect your current account:

```sql
SHOW GRANTS;
```

This helps you understand what operations your MySQL account can perform.

---

# 6. MySQL Roles

Imagine you have 20 backend developers.

All of them require the same permissions.

Granting permissions individually to every user can become difficult to maintain.

MySQL provides **Roles** to solve this problem.

A role is a named collection of privileges that can be assigned to users.

Instead of granting privileges separately to every user, you can:

1. Create a role.
2. Grant privileges to the role.
3. Assign the role to users.

## 6.1 Create a Role

```sql
CREATE ROLE 'application_role';
```

## 6.2 Grant Privileges to the Role

```sql
GRANT
SELECT,
INSERT,
UPDATE,
DELETE
ON company_db.*
TO 'application_role';
```

## 6.3 Create Users

```sql
CREATE USER 'developer1'@'localhost'
IDENTIFIED BY 'Password@123';

CREATE USER 'developer2'@'localhost'
IDENTIFIED BY 'Password@123';
```

## 6.4 Assign Role to Users

```sql
GRANT 'application_role'
TO
'developer1'@'localhost',
'developer2'@'localhost';
```

## 6.5 Set Default Role

```sql
SET DEFAULT ROLE 'application_role'
TO
'developer1'@'localhost',
'developer2'@'localhost';
```

Now the role is automatically active when these users establish a session.

## 6.6 Activate a Role Manually

```sql
SET ROLE 'application_role';
```

Activate all granted roles:

```sql
SET ROLE ALL;
```

Deactivate active roles:

```sql
SET ROLE NONE;
```

## 6.7 Remove a Role

```sql
REVOKE 'application_role'
FROM 'developer1'@'localhost';
```

Delete the role:

```sql
DROP ROLE 'application_role';
```

### Roles vs Direct Privileges

| Direct Privileges | Roles |
|---|---|
| Granted directly to users | Granted to roles |
| Can become difficult to manage for many users | Easier to manage centrally |
| Changes may require updating multiple users | Update role privileges once |
| Suitable for individual exceptions | Suitable for common permission sets |

---

# 7. Authentication and Password Policies

MySQL supports different authentication mechanisms.

One commonly used authentication plugin is:

```text
caching_sha2_password
```

This is the default authentication plugin for many modern MySQL 8.x installations.

You can inspect the authentication plugin of users:

```sql
SELECT
    User,
    Host,
    plugin
FROM mysql.user;
```

### Create a User with a Specific Authentication Plugin

```sql
CREATE USER 'backend_user'@'localhost'
IDENTIFIED WITH caching_sha2_password
BY 'StrongPassword@123';
```

### Password Expiration

You can configure password expiration.

```sql
ALTER USER 'developer1'@'localhost'
PASSWORD EXPIRE INTERVAL 90 DAY;
```

Force a password change on the next login:

```sql
ALTER USER 'developer1'@'localhost'
PASSWORD EXPIRE;
```

Disable password expiration for an account:

```sql
ALTER USER 'developer1'@'localhost'
PASSWORD EXPIRE NEVER;
```

### Password Policies

MySQL can use its password validation component to enforce password rules.

Depending on your MySQL installation, the component may need to be installed and configured.

You can inspect related settings:

```sql
SHOW VARIABLES LIKE 'validate_password%';
```

Common settings include:

| Variable | Purpose |
|---|---|
| validate_password.length | Minimum password length |
| validate_password.policy | Password complexity policy |
| validate_password.mixed_case_count | Required uppercase/lowercase characters |
| validate_password.number_count | Required numeric characters |
| validate_password.special_char_count | Required special characters |

The exact available settings depend on the installed MySQL version and password validation component configuration.

---

# 8. Database Backup and Restore

Database backups are among the most important responsibilities in database management.

Imagine your production database contains:

- 50,000 customers
- 200,000 orders
- 100,000 products and related records

Now imagine the database server crashes.

Without a backup, recovering the data may be impossible.

This is why database backup strategies are essential.

## 8.1 Types of Database Backups

### Full Backup

A complete copy of the database.

Example:

```text
company_db
    |
    |-- employees
    |-- departments
    |-- salaries
    |-- attendance
```

A full backup includes the selected database's data and supported database objects.

### Incremental Backup

Stores changes made since the previous backup.

For example:

```text
Monday: Full Backup

Tuesday: Changes since Monday

Wednesday: Changes since Tuesday

Thursday: Changes since Wednesday
```

Incremental backup strategies can reduce storage requirements.

### Differential Backup

Stores changes made since the last full backup.

For example:

```text
Monday: Full Backup

Tuesday: Changes since Monday

Wednesday: Changes since Monday

Thursday: Changes since Monday
```

### Logical vs Physical Backup

| Logical Backup | Physical Backup |
|---|---|
| Stores SQL statements or logical data representations | Copies database files |
| Usually portable across compatible environments | More dependent on server version and configuration |
| Example: mysqldump | Example: MySQL Enterprise Backup or Percona XtraBackup |
| Useful for migrations and selective restoration | Useful for large databases and physical recovery |

---

# 9. mysqldump – Database Backup

`mysqldump` is a command-line utility used to create logical MySQL backups.

It generates SQL statements that can recreate database objects and data.

### 9.1 Backup a Single Database

Run this in Windows CMD or PowerShell, not inside the MySQL SQL editor:

```bash
mysqldump -u root -p company_db > company_db_backup.sql
```

MySQL asks for the password.

The output file contains the backup.

### 9.2 Backup All Databases

```bash
mysqldump -u root -p --all-databases > all_databases.sql
```

### 9.3 Backup Specific Tables

```bash
mysqldump -u root -p company_db employees departments > selected_tables.sql
```

### 9.4 Backup Without Data

```bash
mysqldump -u root -p --no-data company_db > schema_backup.sql
```

This exports database structure without table rows.

### 9.5 Backup Without Structure

```bash
mysqldump -u root -p --no-create-info company_db > data_backup.sql
```

This exports table data without CREATE TABLE statements.

### 9.6 Backup with Stored Routines and Events

```bash
mysqldump -u root -p \
--routines \
--events \
--triggers \
company_db > company_db_full.sql
```

On Windows CMD, write the command on one line or use the appropriate line-continuation character for your shell.

### 9.7 Backup Using Single-Transaction

For InnoDB databases:

```bash
mysqldump -u root -p \
--single-transaction \
--routines \
--events \
--triggers \
company_db > company_db_backup.sql
```

`--single-transaction` provides a consistent snapshot for transactional tables such as InnoDB without requiring a long table lock.

However, concurrent DDL operations can affect backup consistency. It is not a substitute for a complete production backup strategy.

---

# 10. Restoring a Database

Suppose you have:

```text
company_db_backup.sql
```

You want to restore it.

### Step 1: Create the Database

```sql
CREATE DATABASE company_db;
```

### Step 2: Restore the Backup

Run in CMD or PowerShell:

```bash
mysql -u root -p company_db < company_db_backup.sql
```

This executes the SQL statements from the backup file.

### Important

If the dump already contains database creation and `USE` statements, you may restore it without specifying a database:

```bash
mysql -u root -p < company_db_backup.sql
```

Always inspect the dump before restoring it into an important environment.

### Backup and Restore Summary

| Task | Command |
|---|---|
| Backup database | `mysqldump -u root -p db_name > backup.sql` |
| Backup all databases | `mysqldump -u root -p --all-databases > backup.sql` |
| Restore database | `mysql -u root -p db_name < backup.sql` |
| Restore all-database dump | `mysql -u root -p < backup.sql` |

**Production warning:** Test restoration regularly. A backup that has never been restored and verified is not a reliable recovery plan.

---

# 11. Exporting and Importing Data

MySQL supports different methods for importing and exporting data.

One common method is CSV.

## 11.1 Export Data Using SELECT INTO OUTFILE

```sql
SELECT
    id,
    name,
    salary
FROM employees
INTO OUTFILE '/var/lib/mysql-files/employees.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

This exports query results into a server-side file.

### Important

`INTO OUTFILE` writes the file on the MySQL server, not necessarily on the computer running MySQL Workbench.

The MySQL account needs the FILE privilege, and the destination must satisfy the server's `secure_file_priv` restrictions and operating-system permissions.

Check:

```sql
SHOW VARIABLES LIKE 'secure_file_priv';
```

## 11.2 Import CSV Using LOAD DATA INFILE

```sql
LOAD DATA INFILE '/var/lib/mysql-files/employees.csv'
INTO TABLE employees
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

`IGNORE 1 ROWS` skips the header row.

### LOCAL INFILE

If the file is located on the client machine, you may use:

```sql
LOAD DATA LOCAL INFILE 'C:/data/employees.csv'
INTO TABLE employees
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

`LOCAL` reads from the client machine, but client and server configuration must permit local infile operations.

Enable it only when you understand the security implications.

---

# 12. MySQL Event Scheduler

MySQL supports scheduled database operations through the Event Scheduler.

An event is a database object that executes SQL statements automatically at a specified time or interval.

It is similar to cron jobs in Linux or scheduled tasks in Windows.

### Real-World Examples

- Delete expired temporary records every day.
- Generate daily reports.
- Archive old records.
- Update summary tables.
- Clean up expired sessions.

## 12.1 Check Event Scheduler Status

```sql
SHOW VARIABLES LIKE 'event_scheduler';
```

Possible values:

```text
ON
OFF
DISABLED
```

## 12.2 Enable Event Scheduler

```sql
SET GLOBAL event_scheduler = ON;
```

This requires the appropriate administrative privilege.

If the scheduler is disabled at startup with a setting that prevents runtime activation, it must be enabled through server configuration and restarted.

## 12.3 Create a Scheduled Event

Suppose you have a table:

```sql
CREATE TABLE daily_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(255),
    created_at DATETIME
);
```

Create an event:

```sql
DELIMITER //

CREATE EVENT InsertDailyLog
ON SCHEDULE EVERY 1 DAY
DO
BEGIN

    INSERT INTO daily_logs (
        message,
        created_at
    )
    VALUES (
        'Daily scheduled task executed',
        NOW()
    );

END //

DELIMITER ;
```

This event executes once every day.

## 12.4 Execute Event at a Specific Time

```sql
CREATE EVENT GenerateDailyReport
ON SCHEDULE AT '2026-12-01 02:00:00'
DO
    INSERT INTO daily_logs(message, created_at)
    VALUES ('Report generated', NOW());
```

This event is scheduled for the specified time.

## 12.5 Create a Recurring Event

```sql
CREATE EVENT CleanupOldLogs
ON SCHEDULE EVERY 1 DAY
DO
    DELETE FROM daily_logs
    WHERE created_at < NOW() - INTERVAL 30 DAY;
```

This deletes log records older than 30 days each day.

## 12.6 Alter an Event

```sql
ALTER EVENT CleanupOldLogs
DISABLE;
```

Enable it again:

```sql
ALTER EVENT CleanupOldLogs
ENABLE;
```

## 12.7 Drop an Event

```sql
DROP EVENT IF EXISTS CleanupOldLogs;
```

### View Existing Events

```sql
SHOW EVENTS;
```

Or:

```sql
SELECT
    EVENT_NAME,
    STATUS,
    EVENT_TYPE,
    INTERVAL_VALUE,
    INTERVAL_FIELD
FROM INFORMATION_SCHEMA.EVENTS
WHERE EVENT_SCHEMA = DATABASE();
```

### Important Event Scheduler Concepts

- The Event Scheduler must be enabled.
- Events execute according to the MySQL server's scheduling and time-zone configuration.
- The event's DEFINER and privileges matter.
- Events can be one-time or recurring.
- Events are useful for database-side scheduled tasks, but complex application workflows are often better handled by dedicated job schedulers.

---

# 13. Database Partitioning

Partitioning divides a large table into smaller logical pieces called partitions.

The table still behaves like one table from the application's perspective.

For example, imagine an orders table containing 100 million records.

Instead of storing all records in one logical partition, you can partition records based on order date.

```text
orders
   |
   |-- partition_2024
   |-- partition_2025
   |-- partition_2026
   |-- partition_future
```

Partitioning can help with:

- Managing large datasets.
- Removing old data efficiently.
- Partition pruning.
- Organizing time-based records.

**Important:** Partitioning does not automatically make every query faster.

The query must benefit from partition pruning or another partition-related advantage.

## 13.1 Types of Partitioning

MySQL supports several partitioning methods.

1. RANGE
2. LIST
3. HASH
4. KEY

Let's understand them.

### A. RANGE Partitioning

Records are assigned to partitions based on ranges of values.

Example: Orders based on year.

```sql
CREATE TABLE orders (
    id INT NOT NULL,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2)
)
PARTITION BY RANGE (YEAR(order_date)) (

    PARTITION p2024 VALUES LESS THAN (2025),

    PARTITION p2025 VALUES LESS THAN (2026),

    PARTITION p2026 VALUES LESS THAN (2027),

    PARTITION p_future VALUES LESS THAN MAXVALUE

);
```

Records are distributed based on `YEAR(order_date)`.

For example:

| order_date | Partition |
|---|---|
| 2024-03-10 | p2024 |
| 2025-06-15 | p2025 |
| 2026-09-20 | p2026 |
| 2027-02-10 | p_future |

Query:

```sql
SELECT *
FROM orders
WHERE order_date >= '2026-01-01'
AND order_date < '2027-01-01';
```

MySQL may scan only the relevant partition through partition pruning.

### B. LIST Partitioning

Records are assigned based on a predefined list of values.

Example:

```sql
CREATE TABLE employees (
    id INT NOT NULL,
    name VARCHAR(100),
    department_id INT NOT NULL
)
PARTITION BY LIST (department_id) (

    PARTITION p_it VALUES IN (1),

    PARTITION p_hr VALUES IN (2),

    PARTITION p_sales VALUES IN (3),

    PARTITION p_other VALUES IN (4, 5, 6)

);
```

Each department ID is assigned to a specific partition.

### C. HASH Partitioning

HASH partitioning distributes rows using a hash expression.

Example:

```sql
CREATE TABLE customer_records (
    id INT NOT NULL,
    name VARCHAR(100),
    email VARCHAR(150)
)
PARTITION BY HASH(id)
PARTITIONS 4;
```

MySQL calculates the partition based on the hash expression.

This can distribute records across partitions.

### D. KEY Partitioning

KEY partitioning uses MySQL's internal hashing mechanism.

Example:

```sql
CREATE TABLE user_records (
    id INT NOT NULL,
    name VARCHAR(100),
    email VARCHAR(150)
)
PARTITION BY KEY(id)
PARTITIONS 4;
```

It is similar conceptually to HASH partitioning, but MySQL determines the hashing method.

## 13.2 Viewing Partitions

```sql
SELECT
    PARTITION_NAME,
    TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'orders';
```

## 13.3 Important Partitioning Restrictions

MySQL partitioning has several important limitations.

- Every unique key, including the primary key, must include all columns used in the partitioning expression.
- InnoDB partitioned tables do not support foreign key relationships in the same way as ordinary InnoDB tables; MySQL does not support foreign keys on user-partitioned InnoDB tables.
- Partitioning should be designed around actual query patterns.
- Too many partitions can increase operational complexity.
- Partitioning does not replace indexes.
- Partition pruning depends on the query and partitioning expression.

**Example of the unique-key restriction:**

If a table is partitioned by `YEAR(order_date)`, a primary key containing only `id` will not satisfy the partitioning unique-key requirement.

A possible design is:

```sql
PRIMARY KEY (id, order_date)
```

However, this changes the uniqueness guarantee: `id` alone is no longer guaranteed to be unique by that composite primary key.

Design the key structure carefully.

---

# 14. Generated Columns

A generated column is a column whose value is calculated automatically from an expression.

You do not normally provide its value directly.

MySQL supports two types:

1. VIRTUAL
2. STORED

## 14.1 VIRTUAL Generated Column

A VIRTUAL generated column is calculated when it is read.

Example:

```sql
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    tax_rate DECIMAL(5,2),

    final_price DECIMAL(10,2)
    GENERATED ALWAYS AS (
        price + (price * tax_rate / 100)
    ) VIRTUAL
);
```

Insert:

```sql
INSERT INTO products (
    id,
    product_name,
    price,
    tax_rate
)
VALUES (
    1,
    'Laptop',
    50000,
    18
);
```

Retrieve:

```sql
SELECT *
FROM products;
```

Output:

| id | product_name | price | tax_rate | final_price |
|---|---|---:|---:|---:|
| 1 | Laptop | 50000 | 18 | 59000 |

You did not insert `final_price` directly.

MySQL calculates it automatically.

## 14.2 STORED Generated Column

A STORED generated column is calculated when the row is written and stored physically.

Example:

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),

    full_name VARCHAR(110)
    GENERATED ALWAYS AS (
        CONCAT(first_name, ' ', last_name)
    ) STORED
);
```

Insert:

```sql
INSERT INTO employees (
    id,
    first_name,
    last_name
)
VALUES (
    1,
    'Rahul',
    'Sharma'
);
```

Query:

```sql
SELECT *
FROM employees;
```

The `full_name` column contains:

```text
Rahul Sharma
```

### VIRTUAL vs STORED

| Feature | VIRTUAL | STORED |
|---|---|---|
| Calculation | When read | When row is written |
| Physical storage | Not stored as ordinary row data | Stored |
| Storage requirement | Lower | Higher |
| Read-time computation | Yes | No recomputation required for the stored value |
| Indexing | Supported in InnoDB through secondary indexes | Supported |

### When Should You Use Generated Columns?

- Calculated prices.
- Full names.
- Normalized search values.
- Extracted JSON fields.
- Frequently queried derived values.

---

# 15. Advanced JSON Operations

You learned about the JSON data type in Phase 4 and JSON functions in Phase 12.

Now let's explore some more advanced practical uses.

Suppose you have an e-commerce products table containing additional product attributes.

```sql
CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    attributes JSON
);
```

Insert JSON data:

```sql
INSERT INTO products (
    id,
    name,
    attributes
)
VALUES (
    1,
    'Laptop',
    '{
        "brand": "Dell",
        "ram": "16GB",
        "storage": "512GB SSD",
        "color": "Silver"
    }'
);
```

## 15.1 Extract JSON Values

```sql
SELECT
    name,
    attributes->'$.brand' AS brand
FROM products;
```

The `->` operator extracts a JSON value.

For an unquoted string:

```sql
SELECT
    attributes->>'$.brand' AS brand
FROM products;
```

The `->>` operator extracts and unquotes the value.

## 15.2 JSON_EXTRACT

```sql
SELECT
    JSON_EXTRACT(attributes, '$.ram') AS ram
FROM products;
```

## 15.3 JSON_SET

Add or update a JSON property:

```sql
UPDATE products
SET attributes = JSON_SET(
    attributes,
    '$.warranty',
    '2 years'
)
WHERE id = 1;
```

## 15.4 JSON_REMOVE

Remove a property:

```sql
UPDATE products
SET attributes = JSON_REMOVE(
    attributes,
    '$.color'
)
WHERE id = 1;
```

## 15.5 JSON_CONTAINS

Check whether a JSON document contains a value:

```sql
SELECT *
FROM products
WHERE JSON_CONTAINS(
    attributes,
    '"Dell"',
    '$.brand'
);
```

## 15.6 JSON_ARRAY

Create a JSON array:

```sql
SELECT JSON_ARRAY(
    'HTML',
    'CSS',
    'JavaScript'
);
```

## 15.7 JSON_OBJECT

Create a JSON object:

```sql
SELECT JSON_OBJECT(
    'name', 'Rahul',
    'age', 25,
    'city', 'Ahmedabad'
);
```

## 15.8 JSON_TABLE

`JSON_TABLE` converts JSON data into relational rows and columns.

Example:

```sql
SELECT *
FROM JSON_TABLE(
    '[
        {"id": 1, "name": "Rahul"},
        {"id": 2, "name": "Amit"}
    ]',
    '$[*]'
    COLUMNS (
        id INT PATH '$.id',
        name VARCHAR(100) PATH '$.name'
    )
) AS jt;
```

Output:

| id | name |
|---|---|
| 1 | Rahul |
| 2 | Amit |

This is useful when you need to process JSON arrays using relational SQL.

---

# 16. Indexing JSON Data Using Generated Columns

JSON columns are flexible, but querying frequently used JSON properties can require additional optimization.

For example:

```sql
SELECT *
FROM products
WHERE attributes->>'$.brand' = 'Dell';
```

If this query runs frequently, consider extracting the JSON property into a generated column.

### Example

```sql
ALTER TABLE products
ADD COLUMN brand VARCHAR(100)
GENERATED ALWAYS AS (
    attributes->>'$.brand'
) STORED;
```

Create an index:

```sql
CREATE INDEX idx_products_brand
ON products(brand);
```

Now query:

```sql
SELECT *
FROM products
WHERE brand = 'Dell';
```

This provides an ordinary indexed column for the frequently queried JSON property.

**Important:** Generated-column expressions and their indexability have restrictions. Choose an appropriate data type and ensure the expression is compatible with MySQL's generated-column rules.

---

# 17. Database Monitoring

In production environments, you need to monitor MySQL regularly.

Important things to monitor include:

- Active connections.
- Running queries.
- Long-running queries.
- Slow queries.
- Lock waits.
- Deadlocks.
- CPU and memory usage.
- Disk usage.
- Buffer pool activity.
- Replication health, if applicable.

MySQL provides several commands and monitoring facilities.

## 17.1 Show Current Connections

```sql
SHOW PROCESSLIST;
```

This shows active MySQL sessions.

For more detailed information:

```sql
SHOW FULL PROCESSLIST;
```

The FULL option displays the complete query text rather than truncating it.

## 17.2 Kill a Query

Suppose a query is consuming resources.

You can terminate its execution:

```sql
KILL QUERY 123;
```

Here, `123` is the process ID.

This terminates the current query but keeps the connection open.

To terminate the connection:

```sql
KILL CONNECTION 123;
```

### Important

Use KILL carefully in production.

Terminating a connection with an active transaction can cause rollback work.

## 17.3 Show MySQL Status

```sql
SHOW STATUS;
```

This displays server status variables.

To inspect a specific variable:

```sql
SHOW GLOBAL STATUS LIKE 'Threads_connected';
```

Other useful variables:

```sql
SHOW GLOBAL STATUS LIKE 'Questions';

SHOW GLOBAL STATUS LIKE 'Slow_queries';

SHOW GLOBAL STATUS LIKE 'Uptime';

SHOW GLOBAL STATUS LIKE 'Connections';
```

### Session vs Global Status

| Scope | Meaning |
|---|---|
| SESSION | Current connection statistics |
| GLOBAL | Server-wide statistics |

---

# 18. Slow Query Log

A slow query is a query that takes longer than an acceptable amount of time.

MySQL provides a slow query log to help identify problematic queries.

### Check Slow Query Log Status

```sql
SHOW VARIABLES LIKE 'slow_query_log';
```

### Check Long Query Time

```sql
SHOW VARIABLES LIKE 'long_query_time';
```

### Enable Slow Query Log

```sql
SET GLOBAL slow_query_log = ON;
```

### Change Long Query Time

```sql
SET GLOBAL long_query_time = 2;
```

This sets the threshold to approximately two seconds.

Queries exceeding the configured threshold may be recorded, subject to other slow-log settings.

### Find Slow Query Log File

```sql
SHOW VARIABLES LIKE 'slow_query_log_file';
```

### Why Is It Useful?

Suppose your application has a query:

```sql
SELECT *
FROM orders
WHERE customer_id = 100;
```

If it takes several seconds, you can investigate:

- Missing indexes.
- Full table scans.
- Expensive JOINs.
- Unnecessary columns.
- Large result sets.
- Poor query design.

You already learned EXPLAIN and EXPLAIN ANALYZE in Phase 18.

Use those tools to investigate slow queries.

---

# 19. Performance Schema

Performance Schema is a MySQL feature that collects detailed information about server execution and performance.

It helps you understand:

- SQL statement execution.
- Wait events.
- Locking.
- Memory usage.
- File I/O.
- Thread activity.
- Stored program execution.

Check whether it is enabled:

```sql
SHOW VARIABLES LIKE 'performance_schema';
```

### 19.1 Top Queries by Total Execution Time

```sql
SELECT
    DIGEST_TEXT,
    COUNT_STAR,
    ROUND(SUM_TIMER_WAIT / 1000000000000, 3)
        AS total_time_seconds
FROM performance_schema.events_statements_summary_by_digest
WHERE DIGEST_TEXT IS NOT NULL
ORDER BY SUM_TIMER_WAIT DESC
LIMIT 10;
```

This helps identify statement patterns consuming the most cumulative execution time.

### 19.2 Find Current Running Statements

```sql
SELECT
    THREAD_ID,
    EVENT_NAME,
    SQL_TEXT
FROM performance_schema.events_statements_current
WHERE SQL_TEXT IS NOT NULL;
```

### 19.3 Inspect Lock Waits

```sql
SELECT *
FROM performance_schema.data_lock_waits;
```

### 19.4 Inspect Data Locks

```sql
SELECT *
FROM performance_schema.data_locks;
```

These are useful when investigating blocking and locking issues.

**Important:** Performance Schema tables and available instruments vary by MySQL version and configuration. Some consumers and instruments may need to be enabled.

---

# 20. Information Schema

Information Schema provides metadata about databases, tables, columns, indexes, views, and other database objects.

You can think of it as a collection of system views that describe your database structure.

## 20.1 List Databases

```sql
SELECT SCHEMA_NAME
FROM INFORMATION_SCHEMA.SCHEMATA;
```

## 20.2 List Tables

```sql
SELECT
    TABLE_NAME,
    TABLE_TYPE,
    ENGINE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'company_db';
```

## 20.3 List Columns

```sql
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'company_db'
AND TABLE_NAME = 'employees';
```

## 20.4 List Indexes

```sql
SELECT
    INDEX_NAME,
    COLUMN_NAME,
    NON_UNIQUE
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'company_db'
AND TABLE_NAME = 'employees';
```

## 20.5 List Foreign Keys

```sql
SELECT
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'company_db'
AND REFERENCED_TABLE_NAME IS NOT NULL;
```

### Performance Schema vs Information Schema

| Information Schema | Performance Schema |
|---|---|
| Provides database metadata | Provides performance and execution instrumentation |
| Describes tables and columns | Describes runtime activity |
| Useful for schema inspection | Useful for performance monitoring |
| Shows indexes and constraints | Shows waits, statements and locks |

---

# 21. MySQL Configuration and Server Variables

MySQL has many configuration settings that control server behavior.

Some settings control:

- Connections.
- Memory.
- InnoDB.
- Query execution.
- Logging.
- Replication.
- Time zones.
- Security.

## 21.1 View Server Variables

```sql
SHOW VARIABLES;
```

To inspect a specific variable:

```sql
SHOW VARIABLES LIKE 'max_connections';
```

## 21.2 Change Global Variables

Example:

```sql
SET GLOBAL max_connections = 200;
```

This changes the runtime global value, subject to privileges and variable restrictions.

### Important

Not all variables are dynamically configurable.

Some require restarting the MySQL server.

Also, changes made using `SET GLOBAL` are generally not persistent across server restarts unless configured in the MySQL configuration file or persisted using supported mechanisms.

## 21.3 Important MySQL Variables

| Variable | Purpose |
|---|---|
| max_connections | Maximum permitted simultaneous connections |
| wait_timeout | Idle noninteractive session timeout |
| interactive_timeout | Idle interactive session timeout |
| innodb_buffer_pool_size | Memory allocated to the InnoDB buffer pool |
| innodb_log_file_size | Redo log sizing in applicable MySQL versions |
| slow_query_log | Enables slow query logging |
| long_query_time | Slow query threshold |
| default_storage_engine | Default storage engine |
| transaction_isolation | Default transaction isolation level |
| time_zone | Session or server time zone setting |

Some InnoDB variables and their configuration mechanisms differ across MySQL versions. Always check the documentation for your installed release before changing them.

## 21.4 MySQL Configuration File

On Windows, MySQL configuration is commonly stored in:

```text
my.ini
```

On Linux, common locations include:

```text
/etc/my.cnf
/etc/mysql/my.cnf
/etc/mysql/mysql.conf.d/mysqld.cnf
```

The exact path depends on the installation.

Example configuration:

```ini
[mysqld]

port=3306

max_connections=200

slow_query_log=ON

long_query_time=2

innodb_buffer_pool_size=1G
```

After modifying settings that require startup configuration, restart the MySQL server.

**Warning:** Do not copy memory settings blindly. For example, `innodb_buffer_pool_size=1G` may be inappropriate for a server with limited RAM.

---

# 22. Database Production Best Practices

When developing real-world applications, follow these practices.

## 22.1 Create Separate Database Users

Do not use the MySQL root account in your Node.js application.

Create a dedicated application account:

```sql
CREATE USER 'app_user'@'localhost'
IDENTIFIED BY 'StrongPassword@123';
```

Grant only the required privileges:

```sql
GRANT
SELECT,
INSERT,
UPDATE,
DELETE
ON company_db.*
TO 'app_user'@'localhost';
```

If the application needs stored procedure execution:

```sql
GRANT EXECUTE
ON company_db.*
TO 'app_user'@'localhost';
```

## 22.2 Never Hardcode Database Credentials

Avoid:

```javascript
const connection = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "mypassword"
});
```

Instead, use environment variables.

Example `.env`:

```env
DB_HOST=localhost
DB_USER=app_user
DB_PASSWORD=StrongPassword@123
DB_NAME=company_db
DB_PORT=3306
```

Node.js:

```javascript
require("dotenv").config();

const mysql = require("mysql2/promise");

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: Number(process.env.DB_PORT),
    waitForConnections: true,
    connectionLimit: 10
});
```

Never commit `.env` files containing real credentials to GitHub.

## 22.3 Use Connection Pooling

Instead of creating a new database connection for every request, use a connection pool.

```javascript
const mysql = require("mysql2/promise");

const pool = mysql.createPool({
    host: "localhost",
    user: "app_user",
    password: "password",
    database: "company_db",
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});
```

Use it:

```javascript
const [rows] = await pool.execute(
    "SELECT * FROM employees WHERE id = ?",
    [1]
);
```

## 22.4 Use Parameterized Queries

Avoid SQL injection.

Incorrect:

```javascript
const query = `
    SELECT *
    FROM employees
    WHERE name = '${name}'
`;
```

Correct:

```javascript
const [rows] = await pool.execute(
    "SELECT * FROM employees WHERE name = ?",
    [name]
);
```

## 22.5 Use Transactions for Related Operations

For example:

- Create order.
- Insert order items.
- Update inventory.
- Create payment record.

These operations may need to execute within one transaction to preserve consistency.

## 22.6 Maintain Regular Backups

A production database should have:

- Automated backups.
- Appropriate backup retention.
- Off-server backup storage.
- Encryption where required.
- Restore testing.
- A defined recovery strategy.

## 22.7 Monitor Database Performance

Monitor:

- Slow queries.
- Connections.
- Memory.
- Disk usage.
- Lock waits.
- Deadlocks.
- Replication lag, if applicable.

## 22.8 Use Proper Indexes

Create indexes based on actual query patterns.

Avoid creating unnecessary indexes because indexes also increase storage and write costs.

## 22.9 Use Database Migrations

Do not manually change production database structures without tracking the changes.

Use migration tools such as:

- Sequelize migrations.
- Knex migrations.
- Prisma Migrate.
- Flyway.

This helps maintain consistent database structures across development, testing, and production.

---

# 23. Important Interview Questions and Answers

### Q1. What is database administration?

Database administration involves managing database security, availability, backups, performance, configuration, and maintenance.

### Q2. What is the difference between CREATE USER and GRANT?

CREATE USER creates a MySQL account. GRANT assigns privileges to a user or role.

### Q3. What is the difference between GRANT and REVOKE?

GRANT provides permissions, while REVOKE removes permissions.

### Q4. What are MySQL roles?

Roles are named collections of privileges that can be assigned to users.

### Q5. What is mysqldump?

A command-line utility used to create logical backups of MySQL databases.

### Q6. What is the difference between logical and physical backup?

Logical backups store SQL-level representations of database objects and data. Physical backups copy database files and related storage structures.

### Q7. What is the difference between full, incremental and differential backups?

- Full: Complete backup.
- Incremental: Changes since the previous backup.
- Differential: Changes since the last full backup.

### Q8. What is the MySQL Event Scheduler?

It automatically executes scheduled SQL operations at specified times or intervals.

### Q9. What is partitioning?

Partitioning divides a large table into smaller logical partitions while maintaining one logical table.

### Q10. What is partition pruning?

Partition pruning allows MySQL to avoid scanning partitions that cannot contain rows matching a query.

### Q11. What is a generated column?

A column whose value is automatically calculated from an expression.

### Q12. What is the difference between VIRTUAL and STORED generated columns?

VIRTUAL values are calculated when read, whereas STORED values are calculated when written and physically stored.

### Q13. What is Performance Schema?

A MySQL feature that collects runtime performance information, including statements, waits, locks, and other server activity.

### Q14. What is Information Schema?

A collection of metadata views describing databases, tables, columns, indexes, and other database objects.

### Q15. What is a slow query log?

A log that records queries meeting configured slow-query logging criteria.

### Q16. What is connection pooling?

Connection pooling reuses existing database connections instead of creating a new connection for every request.

### Q17. Why should we not use root in a backend application?

Because root has extensive privileges. A compromised application could expose or damage the entire database server.

### Q18. Does MySQL support materialized views?

MySQL does not provide native materialized views. Similar functionality can be implemented using summary tables and refresh mechanisms.

### Q19. What is the difference between a view and a generated column?

A view represents a saved SELECT query. A generated column is a calculated column within a table.

### Q20. Why are database backups important?

Backups enable recovery from accidental deletion, corruption, hardware failures, and other incidents.

---

# 24. Practical Assignments

Complete these exercises using MySQL Workbench and your terminal.

## Assignment 1: User Management

1. Create a user named `developer`.
2. Create a user named `reporting_user`.
3. Grant SELECT permission to `reporting_user`.
4. Grant CRUD permissions to `developer`.
5. Check their privileges.
6. Revoke DELETE permission from `developer`.
7. Change the password of `developer`.
8. Drop the users.

## Assignment 2: Roles

1. Create a role named `read_only_role`.
2. Grant SELECT permission to it.
3. Create two users.
4. Assign the role to both users.
5. Set it as the default role.
6. Verify the privileges.
7. Revoke the role from one user.

## Assignment 3: Backup and Restore

1. Create a database named `backup_demo`.
2. Create three tables.
3. Insert sample records.
4. Export the database using `mysqldump`.
5. Drop the database in a test environment.
6. Restore it using the MySQL client.
7. Verify the restored tables and records.

**Do not perform destructive backup/restore exercises on production databases.**

## Assignment 4: CSV Import and Export

1. Export employee records to CSV.
2. Create a new table.
3. Import the CSV into that table.
4. Verify the imported records.
5. Handle header rows and NULL values.

## Assignment 5: Event Scheduler

1. Enable the Event Scheduler.
2. Create a logging table.
3. Create a daily event.
4. Insert a log automatically.
5. Disable the event.
6. Enable it again.
7. Drop the event.

## Assignment 6: Partitioning

1. Create a range-partitioned orders table.
2. Insert records from multiple years.
3. Query records for one year.
4. Inspect the partitions.
5. Use EXPLAIN to inspect partition selection.

## Assignment 7: Generated Columns

1. Create a products table.
2. Add a generated column for final price.
3. Insert product records.
4. Create a generated full-name column in another table.
5. Create an index on a suitable generated column.
6. Test indexed queries.

## Assignment 8: JSON

1. Create a products table with a JSON column.
2. Insert JSON documents.
3. Extract JSON properties.
4. Update JSON values.
5. Remove JSON properties.
6. Convert JSON arrays into rows using JSON_TABLE.
7. Create an indexed generated column for a frequently queried property.

## Assignment 9: Monitoring

1. Execute SHOW PROCESSLIST.
2. Inspect server status variables.
3. Enable the slow query log in a test environment.
4. Configure a slow-query threshold.
5. Inspect Performance Schema.
6. Find the most expensive statement patterns.

---

# 25. Quick Revision

| Concept | Meaning |
|---|---|
| CREATE USER | Creates a MySQL account |
| ALTER USER | Modifies account settings |
| DROP USER | Deletes an account |
| GRANT | Provides privileges |
| REVOKE | Removes privileges |
| ROLE | Collection of privileges |
| mysqldump | Logical backup utility |
| mysql | MySQL command-line client |
| Full Backup | Complete backup |
| Incremental Backup | Changes since previous backup |
| Differential Backup | Changes since last full backup |
| LOAD DATA INFILE | Imports data from a server-side file |
| SELECT INTO OUTFILE | Exports query results to a server-side file |
| Event Scheduler | Executes scheduled database operations |
| Partitioning | Divides a table into logical partitions |
| RANGE | Partitions based on ranges |
| LIST | Partitions based on specified values |
| HASH | Distributes records using a hash expression |
| KEY | Uses MySQL's internal hashing mechanism |
| Generated Column | Automatically calculated column |
| VIRTUAL | Calculated when read |
| STORED | Calculated and physically stored |
| Performance Schema | Runtime performance monitoring |
| Information Schema | Database metadata |
| Slow Query Log | Records slow queries |
| Connection Pooling | Reuses database connections |

---

# 26. Phase 24 Completion Checklist

- [ ] Understand MySQL user management.
- [ ] Create and delete users.
- [ ] Change passwords.
- [ ] Understand MySQL hosts.
- [ ] Understand database privileges.
- [ ] Use GRANT and REVOKE.
- [ ] Understand MySQL roles.
- [ ] Configure authentication and password policies.
- [ ] Create database backups using mysqldump.
- [ ] Restore database backups.
- [ ] Understand logical and physical backups.
- [ ] Import and export CSV files.
- [ ] Use the MySQL Event Scheduler.
- [ ] Understand database partitioning.
- [ ] Implement RANGE, LIST, HASH and KEY partitioning.
- [ ] Understand generated columns.
- [ ] Differentiate VIRTUAL and STORED columns.
- [ ] Perform advanced JSON operations.
- [ ] Index frequently queried JSON properties.
- [ ] Monitor active MySQL connections.
- [ ] Understand slow query logging.
- [ ] Use Performance Schema.
- [ ] Use Information Schema.
- [ ] Understand MySQL server configuration.
- [ ] Apply production database best practices.

---

# Next Phase: Phase 25 – SQL Integration with Node.js

This is the final phase of your SQL roadmap.

Since you are learning Node.js and Express, we will connect MySQL with backend applications.

Topics:

1. Introduction to MySQL2.
2. Installing and configuring MySQL2.
3. Connecting Node.js with MySQL.
4. Creating database connection files.
5. Understanding Connection vs Connection Pool.
6. Executing SQL queries using Node.js.
7. Parameterized Queries.
8. CRUD Operations with Express.
9. Implementing JOINs in backend APIs.
10. Transactions with Node.js.
11. Stored Procedures with Node.js.
12. Handling MySQL errors.
13. Pagination and Filtering.
14. Database Connection Pooling.
15. Sequelize ORM vs Raw SQL.
16. Database Migrations.
17. SQL Injection Prevention.
18. Environment Variables and Database Security.
19. API Performance Optimization.
20. Building a Complete Node.js + Express + MySQL Project.

**Phase 24 is complete.**