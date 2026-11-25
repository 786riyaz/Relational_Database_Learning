# SQL Complete Course – Phase 2
# Installing and Setting Up MySQL

**Level:** Beginner  
**Phase:** 2 of 25  
**Goal:** Understand the MySQL environment, install MySQL, connect to the database server, and execute your first SQL commands.

In this phase, we'll focus on practical setup and understanding how MySQL works.

Since we'll use MySQL throughout this course, make sure you have a working environment before proceeding to Phase 3.

---

# 1. What is MySQL?

MySQL is an open-source Relational Database Management System (RDBMS).

It allows applications to store, retrieve, update, and manage structured data.

### Example

Suppose you're developing an Expense Tracker application using:

- React – Frontend
- Node.js – Backend
- Express.js – Backend Framework
- MySQL – Database

Your application architecture might look like this:

```text
       USER
         |
         v
    REACT FRONTEND
         |
         v
    NODE.JS SERVER
         |
         v
    EXPRESS.JS API
         |
         v
     MYSQL SERVER
         |
         v
       DATABASE
```

When a user adds an expense:

1. React sends an HTTP request.
2. Express receives the request.
3. Node.js executes the required SQL query.
4. MySQL processes the query.
5. MySQL stores the expense.
6. The backend returns a response.

---

# 2. MySQL Server vs MySQL Client

This is an important concept.

MySQL consists of two major components from the perspective of connecting to and using a database.

### MySQL Server

MySQL Server is the actual database management software.

Its responsibilities include:

- Managing databases.
- Managing tables.
- Processing SQL queries.
- Storing and retrieving data.
- Managing users and permissions.
- Handling transactions.
- Managing database connections.

It runs as a background service.

### MySQL Client

A MySQL Client is software that allows users or applications to communicate with MySQL Server.

Examples:

- MySQL Command-Line Client
- MySQL Workbench
- Node.js mysql2 package
- DBeaver

### Architecture

```text
       MYSQL CLIENT
             |
             |
       SQL QUERIES
             |
             v
       MYSQL SERVER
             |
             |
        DATABASE
             |
             v
         SQL RESULT
             |
             v
       MYSQL CLIENT
```

### Important Difference

| MySQL Server | MySQL Client |
|---|---|
| Manages databases | Connects to databases |
| Processes SQL queries | Sends SQL queries |
| Stores and retrieves data | Displays query results |
| Runs as a server process | Runs as an application or client process |
| Required for a local MySQL database | Multiple client options are available |

**Remember:** MySQL Workbench is not the database server. It is a graphical client used to interact with the server.

---

# 3. MySQL Installation Options

There are multiple ways to install and use MySQL.

### Option 1: MySQL Installer

Official MySQL installation package for Windows.

It can install:

- MySQL Server
- MySQL Workbench
- MySQL Shell
- MySQL Router
- Other MySQL components

Official website:

[MySQL Downloads](https://dev.mysql.com/downloads/installer/?utm_source=chatgpt.com)

### Option 2: MySQL Community Server

You can install MySQL Server separately.

[MySQL Community Server](https://dev.mysql.com/downloads/mysql/?utm_source=chatgpt.com)

### Option 3: XAMPP

XAMPP provides a local development environment that includes Apache, PHP, and MariaDB.

Note: XAMPP traditionally includes MariaDB rather than Oracle MySQL.

### Option 4: Docker

You can run MySQL inside a Docker container.

Example:

```bash
docker run --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -p 3306:3306 \
  -d mysql:8.0
```

This creates a MySQL container.

We'll discuss Docker-based database environments later.

### My Recommendation

For this course, use:

1. MySQL Community Server 8.0 or newer.
2. MySQL Workbench.
3. MySQL Command-Line Client.

---

# 4. Installing MySQL on Windows

Let's understand the installation process.

### Step 1: Download MySQL Installer

Visit:

[MySQL Installer for Windows](https://dev.mysql.com/downloads/installer/?utm_source=chatgpt.com)

Download the MySQL Installer.

### Step 2: Choose Setup Type

You may see several installation options:

| Option | Description |
|---|---|
| Developer Default | Installs common development tools |
| Server Only | Installs MySQL Server |
| Client Only | Installs client tools |
| Full | Installs all available components |
| Custom | Allows selecting individual components |

For learning, Developer Default is a convenient option.

### Step 3: Install Required Components

Select:

- MySQL Server
- MySQL Workbench
- MySQL Shell
- MySQL Command-Line Client

Follow the installer instructions.

### Step 4: Configure MySQL Server

During configuration, you'll encounter several options.

**Config Type:**

Development Computer is generally suitable for local development.

**Port:**

Default MySQL port:

```text
3306
```

**Authentication Method:**

Use the recommended strong password authentication option.

**Root Password:**

Create a secure password for the root account.

Example:

```text
YourStrongPassword
```

Do not use a simple password in real applications.

### Step 5: Windows Service

MySQL can be installed as a Windows Service.

A service allows MySQL Server to run in the background without manually opening a terminal.

Typical service name:

```text
MySQL80
```

The exact service name depends on your installation.

Enable automatic startup if you want MySQL to start whenever Windows boots.

### Step 6: Complete Installation

Finish the installation and start the MySQL Server service.

---

# 5. Understanding MySQL Port 3306

A port is a logical communication endpoint used by applications to communicate over a network.

MySQL uses port:

```text
3306
```

By default.

Consider this example:

```text
Node.js Application
       |
       |
   localhost:3306
       |
       |
    MySQL Server
```

When Node.js connects to MySQL:

- Host: localhost
- Port: 3306
- Username: root
- Password: YourPassword

The application communicates with MySQL Server through that endpoint.

### What is localhost?

`localhost` refers to the local computer.

It generally resolves to:

```text
127.0.0.1
```

This means the application is connecting to a server running on the same machine.

### Important Ports

| Service | Default Port |
|---|---:|
| MySQL | 3306 |
| PostgreSQL | 5432 |
| MongoDB | 27017 |
| Redis | 6379 |
| HTTP | 80 |
| HTTPS | 443 |
| Express (common development port) | 3000 |

---

# 6. Starting and Stopping MySQL Server

MySQL Server runs as a background service on Windows.

You can manage it through Windows Services.

### Method 1: Windows Services

1. Press `Win + R`.
2. Enter:

```text
services.msc
```

3. Find your MySQL service.
4. Right-click it.

You can choose:

- Start
- Stop
- Restart

### Method 2: Command Prompt

Open Command Prompt as Administrator.

Start:

```bash
net start MySQL80
```

Stop:

```bash
net stop MySQL80
```

Restart:

```bash
net stop MySQL80
net start MySQL80
```

Note: Replace `MySQL80` with your actual service name if different.

---

# 7. What is MySQL Workbench?

MySQL Workbench is a graphical database management tool.

It provides a visual interface for interacting with MySQL Server.

You can use it to:

- Execute SQL queries.
- Create databases.
- Create tables.
- Insert records.
- Update records.
- Delete records.
- View database structures.
- Manage database users.
- Create ER diagrams.
- Export and import database data.

### Important Components

**1. SQL Editor**

Used to write and execute SQL queries.

**2. Navigator**

Displays:

- Schemas
- Tables
- Views
- Stored Procedures
- Functions

**3. Result Grid**

Displays the results returned by SQL queries.

**4. Output Panel**

Displays execution information, warnings, and errors.

**5. Administration**

Provides server management features.

### Example

Execute:

```sql
SELECT VERSION();
```

Expected result will show your installed MySQL version.

---

# 8. What is MySQL Command-Line Client?

The MySQL Command-Line Client allows you to communicate with MySQL Server using terminal commands.

You don't need a graphical interface.

For example:

```bash
mysql -u root -p
```

Explanation:

| Part | Meaning |
|---|---|
| mysql | Starts MySQL client |
| -u | Specifies username |
| root | Username |
| -p | Requests password |

After entering the password, you'll enter the MySQL command-line interface.

You may see something like:

```text
Welcome to the MySQL monitor.

mysql>
```

Now you can execute SQL queries.

Example:

```sql
SELECT VERSION();
```

### Exiting MySQL CLI

```sql
EXIT;
```

Or:

```sql
QUIT;
```

---

# 9. MySQL Shell vs MySQL Command-Line Client

These are different tools.

### MySQL Command-Line Client

The traditional `mysql` client is primarily used to execute SQL statements.

Example:

```bash
mysql -u root -p
```

### MySQL Shell

MySQL Shell is an advanced command-line interface that supports:

- SQL
- JavaScript
- Python

It also provides advanced database administration capabilities.

Example:

```bash
mysqlsh
```

You can connect using:

```javascript
\connect root@localhost:3306
```

MySQL Shell has different execution modes:

| Mode | Purpose |
|---|---|
| SQL Mode | Execute SQL statements |
| JavaScript Mode | Execute JavaScript |
| Python Mode | Execute Python |

Switch to SQL mode:

```text
\sql
```

Switch to JavaScript mode:

```text
\js
```

Switch to Python mode:

```text
\py
```

For now, we'll primarily use MySQL Workbench and the traditional MySQL CLI.

---

# 10. Connecting to MySQL Server

To connect to MySQL Server, you generally need the following information:

| Parameter | Example |
|---|---|
| Host | localhost |
| Port | 3306 |
| Username | root |
| Password | YourPassword |

### Connection Using CLI

```bash
mysql -h localhost -P 3306 -u root -p
```

Explanation:

- `-h`: Hostname
- `-P`: Port
- `-u`: Username
- `-p`: Password prompt

### Connection Using Workbench

Open MySQL Workbench.

1. Click the `+` icon beside MySQL Connections.
2. Enter a connection name.
3. Hostname: `localhost`
4. Port: `3306`
5. Username: `root`
6. Save the password if desired.
7. Click Test Connection.
8. Connect.

If successful, you can start executing SQL queries.

---

# 11. Your First SQL Query

Let's execute our first SQL query.

```sql
SELECT VERSION();
```

This returns the installed MySQL Server version.

Example output:

| VERSION() |
|---|
| 8.0.40 |

Your actual version may be different.

### Another Example

```sql
SELECT NOW();
```

This returns the current date and time according to the MySQL server's session time zone.

Example:

| NOW() |
|---|
| 2026-11-25 07:30:00 |

### Another Example

```sql
SELECT DATABASE();
```

This returns the currently selected database.

If no database has been selected, it returns `NULL`.

### Another Example

```sql
SELECT USER();
```

This returns the current MySQL client identity.

These are useful built-in functions.

---

# 12. Understanding SQL Syntax

SQL statements follow a particular syntax.

Example:

```sql
SELECT name, salary
FROM employees
WHERE salary > 50000;
```

Let's break it down.

| Component | Purpose |
|---|---|
| SELECT | Specifies which columns to retrieve |
| name, salary | Column names |
| FROM | Specifies the source table |
| employees | Table name |
| WHERE | Filters records |
| salary > 50000 | Filtering condition |
| ; | Statement terminator |

### SQL Statement Terminator

Most SQL statements end with a semicolon.

Example:

```sql
SELECT * FROM employees;
```

You can also write:

```sql
SELECT *
FROM employees;
```

Both are valid.

### Is Semicolon Mandatory?

In MySQL interactive clients, semicolons are generally used to terminate statements.

Some APIs and programming environments allow you to execute individual statements without including a semicolon.

However, develop the habit of ending SQL statements with `;`.

---

# 13. SQL Comments

Comments are used to explain SQL code.

They are ignored during normal SQL execution.

SQL supports three common comment styles in MySQL.

### Single-Line Comment Using --

```sql
-- This query retrieves all employees

SELECT * FROM employees;
```

### Single-Line Comment Using #

```sql
# This query retrieves all employees

SELECT * FROM employees;
```

`#` is a MySQL-specific comment syntax.

### Multi-Line Comment

```sql
/*
    This query retrieves
    all employee records
*/

SELECT * FROM employees;
```

### Important

Use comments to explain complex queries and business logic.

---

# 14. SQL Keywords and Identifiers

### Keywords

Keywords are reserved words that have predefined meanings in SQL.

Examples:

```text
SELECT
FROM
WHERE
INSERT
UPDATE
DELETE
CREATE
ALTER
DROP
JOIN
GROUP BY
ORDER BY
```

Example:

```sql
SELECT name
FROM employees;
```

Here:

- SELECT is a keyword.
- FROM is a keyword.

### Identifiers

Identifiers are names used to identify database objects.

Examples:

- Database names
- Table names
- Column names
- Index names
- View names

Example:

```sql
SELECT employee_name
FROM employees;
```

Here:

- `employee_name` is a column identifier.
- `employees` is a table identifier.

### Naming Conventions

Recommended practices:

1. Use meaningful names.
2. Avoid spaces in table names.
3. Avoid unnecessary special characters.
4. Use consistent naming conventions.
5. Avoid reserved keywords as identifiers.

Example:

Good:

```text
employee_details
customer_orders
product_categories
```

Avoid:

```text
employee details
order
select
```

Some reserved words can be used as identifiers when quoted appropriately, but avoiding them is better.

---

# 15. SQL Case Sensitivity

SQL keywords are generally case-insensitive in MySQL.

These queries are equivalent:

```sql
SELECT * FROM employees;
```

```sql
select * from employees;
```

```sql
SeLeCt * FrOm employees;
```

However, identifier case sensitivity can depend on the operating system and MySQL configuration.

For example, database and table names may behave differently on Windows and Linux.

### Recommended Convention

Use uppercase for SQL keywords:

```sql
SELECT name, salary
FROM employees
WHERE salary > 50000;
```

Use lowercase for database, table, and column names:

```text
company
employees
employee_id
employee_name
```

This improves readability and consistency.

---

# 16. Understanding SQL Query Execution Environment

Let's understand how your development environment will work.

Suppose you have installed:

- MySQL Server
- MySQL Workbench
- Node.js
- VS Code

Your environment:

```text
          YOUR COMPUTER
                |
       +--------+--------+
       |                 |
       v                 v
   VS CODE          WORKBENCH
       |                 |
       v                 |
   NODE.JS               |
       |                 |
       +--------+--------+
                |
                v
           MYSQL SERVER
                |
                v
             DATABASE
```

You can interact with MySQL in two ways:

**Method 1: Directly**

```text
Workbench / CLI → MySQL Server
```

**Method 2: Through Backend**

```text
React → Express → Node.js → MySQL Server
```

We'll practice both methods throughout this course.

---

# 17. Practical Assignment

Now it's time to configure your environment.

### Task 1: Install MySQL

Install:

- MySQL Server
- MySQL Workbench
- MySQL Shell

### Task 2: Connect to MySQL

Connect using:

```text
Host: localhost
Port: 3306
Username: root
```

### Task 3: Execute These Queries

Run the following queries one by one:

**Query 1:**

```sql
SELECT VERSION();
```

**Query 2:**

```sql
SELECT NOW();
```

**Query 3:**

```sql
SELECT USER();
```

**Query 4:**

```sql
SELECT DATABASE();
```

**Query 5:**

```sql
SELECT 10 + 20;
```

Expected result:

| 10 + 20 |
|---:|
| 30 |

**Query 6:**

```sql
SELECT
    'Riyaz' AS name,
    25 AS age,
    'Ahmedabad' AS city;
```

Expected result:

| name | age | city |
|---|---:|---|
| Riyaz | 25 | Ahmedabad |

---

# 18. Phase 2 Interview Questions

1. What is MySQL?
2. What is MySQL Server?
3. What is MySQL Client?
4. What is the difference between MySQL Server and MySQL Workbench?
5. What is the default MySQL port?
6. What is localhost?
7. What is the difference between MySQL Shell and MySQL CLI?
8. What is the purpose of MySQL Workbench?
9. How do you connect to MySQL using the command line?
10. What is the purpose of the `-u` parameter?
11. What is the purpose of the `-p` parameter?
12. What is a SQL statement terminator?
13. What are SQL comments?
14. Are SQL keywords case-sensitive?
15. What are SQL identifiers?
16. What is the purpose of `SELECT VERSION()`?
17. What is the purpose of `SELECT DATABASE()`?
18. Can Node.js communicate directly with MySQL Server?
19. Can multiple clients connect to the same MySQL Server?
20. What happens if the MySQL Server service is stopped?

---

# Phase 2 – Completion Checklist

| No. | Topic | Status |
|---|---|---|
| 1 | Introduction to MySQL | Covered |
| 2 | MySQL Server vs Client | Covered |
| 3 | Installation Options | Covered |
| 4 | MySQL Installation | Covered |
| 5 | Port 3306 | Covered |
| 6 | Starting and Stopping MySQL | Covered |
| 7 | MySQL Workbench | Covered |
| 8 | MySQL CLI | Covered |
| 9 | MySQL Shell | Covered |
| 10 | Connecting to MySQL | Covered |
| 11 | First SQL Queries | Covered |
| 12 | SQL Syntax | Covered |
| 13 | SQL Comments | Covered |
| 14 | Keywords and Identifiers | Covered |
| 15 | SQL Case Sensitivity | Covered |

**Phase 2 is complete from a theory perspective.**

### What comes next?

**Phase 3: Database and Table Operations**

We'll learn:

- CREATE DATABASE
- SHOW DATABASES
- USE
- DROP DATABASE
- CREATE TABLE
- SHOW TABLES
- DESCRIBE
- ALTER TABLE
- DROP TABLE
- TRUNCATE TABLE
- RENAME TABLE
- IF EXISTS
- IF NOT EXISTS

This is where we'll start writing actual SQL queries and building our first database.

Tell me **"Next Phase"** when you're ready.