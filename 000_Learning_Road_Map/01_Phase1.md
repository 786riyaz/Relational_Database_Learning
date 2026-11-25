# SQL Complete Course – Phase 1
# Introduction to Databases and SQL

**Level:** Beginner  
**Phase:** 1 of 25  
**Goal:** Understand databases, DBMS, RDBMS, SQL, and how relational databases work before writing SQL queries.

These notes are written in English and structured for learning, revision, and technical interviews.

---

# 1. What is Data?

**Data** is a collection of raw facts, figures, or information that can be stored, processed, and analyzed.

Data can represent anything, such as:
- A person's name
- Age
- Mobile number
- Email address
- Product price
- Employee salary
- Order date

### Example

Consider the following data:

```text
101
Riyaz
25
Ahmedabad
50000
```

These are individual pieces of data, but without context, their meaning is not entirely clear.

When we organize them:

| ID | Name | Age | City | Salary |
|---|---|---:|---|---:|
| 101 | Riyaz | 25 | Ahmedabad | 50000 |

Now the data is structured and easier to understand.

### Types of Data

**1. Structured Data**

Data organized in a predefined format, usually rows and columns.

Examples:
- MySQL databases
- Excel spreadsheets
- Employee records

**2. Semi-Structured Data**

Data that does not follow a strict tabular structure but contains organizational elements.

Examples:
- JSON
- XML
- HTML

Example:

```json
{
    "id": 101,
    "name": "Riyaz",
    "age": 25,
    "city": "Ahmedabad"
}
```

**3. Unstructured Data**

Data that does not follow a predefined structure.

Examples:
- Images
- Videos
- Audio files
- PDF documents
- Text documents

---

# 2. What is a Database?

A **Database** is an organized collection of data that can be stored, accessed, managed, and modified efficiently.

In simple words:

A database is a place where we store data electronically so that we can retrieve, update, delete, and manage it whenever required.

### Real-world Example

Consider an e-commerce application.

It needs to store information about:

- Customers
- Products
- Orders
- Payments
- Addresses
- Reviews

Instead of storing all this information in separate files, we can organize it inside a database.

For example:

**Customers Table**

| Customer_ID | Name | Email |
|---|---|---|
| 1 | Riyaz | riyaz@example.com |
| 2 | Ahmed | ahmed@example.com |
| 3 | Rahul | rahul@example.com |

**Products Table**

| Product_ID | Product_Name | Price |
|---|---|---:|
| 101 | Laptop | 55000 |
| 102 | Mobile | 25000 |
| 103 | Keyboard | 1500 |

**Orders Table**

| Order_ID | Customer_ID | Total_Amount |
|---|---|---:|
| 1001 | 1 | 55000 |
| 1002 | 2 | 25000 |
| 1003 | 1 | 1500 |

All these tables belong to the same database.

### Why Do We Need a Database?

Imagine managing an application with 10 lakh customers.

Without a database, managing customer information would become difficult.

Databases help us:

1. Store large amounts of data.
2. Retrieve data quickly.
3. Update existing records.
4. Delete unnecessary records.
5. Maintain data consistency.
6. Avoid unnecessary data duplication.
7. Control access to data.
8. Support multiple users simultaneously.
9. Maintain relationships between different datasets.
10. Backup and recover important information.

---

# 3. What is DBMS?

DBMS stands for **Database Management System**.

A DBMS is software that allows users and applications to create, store, retrieve, update, delete, and manage data in a database.

In simple words:

A database is where data is stored, whereas a DBMS is the software used to manage that data.

### Examples of DBMS

- MySQL
- PostgreSQL
- Oracle Database
- Microsoft SQL Server
- SQLite
- Microsoft Access

### How Does DBMS Work?

Consider a simple application:

```text
       User
        |
        |
   Application
        |
        |
       DBMS
        |
        |
     Database
```

Suppose a user wants to retrieve their profile.

1. The user opens the application.
2. The application sends a request to the DBMS.
3. The DBMS processes the request.
4. The DBMS retrieves the requested data from the database.
5. The DBMS returns the result to the application.
6. The application displays the information to the user.

### Responsibilities of a DBMS

**1. Data Storage**

Stores information in an organized manner.

**2. Data Retrieval**

Retrieves required information efficiently.

**3. Data Manipulation**

Allows users to insert, update, and delete records.

**4. Security**

Controls who can access or modify data.

**5. Data Integrity**

Helps maintain accurate and consistent data.

**6. Concurrency Control**

Allows multiple users to access the database safely.

**7. Backup and Recovery**

Helps recover data in case of system failure.

---

# 4. What is RDBMS?

RDBMS stands for **Relational Database Management System**.

An RDBMS is a type of DBMS that stores and manages data in the form of related tables.

These tables contain rows and columns.

The relationships between tables are established using keys, such as:

- Primary Key
- Foreign Key

### Example

Consider an e-commerce application.

**Customers Table**

| Customer_ID | Name |
|---|---|
| 1 | Riyaz |
| 2 | Ahmed |
| 3 | Rahul |

**Orders Table**

| Order_ID | Customer_ID | Amount |
|---|---|---:|
| 101 | 1 | 5000 |
| 102 | 2 | 3000 |
| 103 | 1 | 2000 |

Here:

- `Customer_ID` in the Customers table uniquely identifies each customer.
- `Customer_ID` in the Orders table connects an order to its customer.

This is an example of a relationship between two tables.

### Popular RDBMS

| RDBMS | Description |
|---|---|
| MySQL | Popular open-source relational database |
| PostgreSQL | Advanced open-source relational database |
| Oracle Database | Enterprise-level relational database |
| SQL Server | Microsoft's relational database |
| SQLite | Lightweight embedded relational database |

### Important Characteristics of RDBMS

1. Stores data in tables.
2. Tables contain rows and columns.
3. Supports relationships between tables.
4. Uses primary and foreign keys.
5. Supports SQL queries.
6. Supports constraints.
7. Maintains data integrity.
8. Supports transactions.

---

# 5. DBMS vs RDBMS

This is a common technical interview question.

| DBMS | RDBMS |
|---|---|
| Database Management System | Relational Database Management System |
| General database management software | A type of DBMS based on relational principles |
| May use different data models | Uses relational tables |
| Relationships are not a defining requirement | Supports relationships between tables |
| Relational constraints may not be available | Supports relational constraints |
| Examples include MongoDB and Redis as DBMS products | Examples include MySQL and PostgreSQL |

**Important:** Modern database systems have overlapping capabilities. The key distinction is the data model, not simply whether a database supports relationships or transactions.

---

# 6. What is SQL?

SQL stands for **Structured Query Language**.

SQL is a standard language used to communicate with relational database management systems.

We use SQL to:

- Create databases.
- Create tables.
- Insert data.
- Retrieve data.
- Update data.
- Delete data.
- Manage database structures.
- Control database permissions.
- Manage transactions.

### Example

Suppose we have a database containing employee information.

We want to retrieve all employees.

We can write:

```sql
SELECT * FROM employees;
```

This query asks the database to return all columns and rows from the `employees` table.

Another example:

```sql
SELECT name, salary
FROM employees
WHERE salary > 50000;
```

This query retrieves employees whose salary is greater than 50,000.

### Why Do We Need SQL?

Imagine developing an application with 1 lakh registered users.

You might need to:

- Find a particular user.
- Update a user's email.
- Delete an inactive account.
- Find users from a particular city.
- Calculate total revenue.
- Generate monthly reports.

SQL makes these operations possible through structured queries.

---

# 7. SQL vs MySQL

This is one of the most important concepts to understand.

Many beginners confuse SQL and MySQL.

They are NOT the same.

### SQL

SQL is a language.

It defines how we communicate with relational databases.

Example:

```sql
SELECT * FROM employees;
```

### MySQL

MySQL is a Relational Database Management System (RDBMS).

It executes SQL queries and manages the underlying database.

### Difference

| SQL | MySQL |
|---|---|
| SQL is a query language | MySQL is an RDBMS |
| Used to communicate with databases | Used to store and manage data |
| Defines query syntax | Implements SQL and provides database functionality |
| Not a database software | Is database software |
| Used by many RDBMS products | Uses SQL to interact with its databases |

### Other SQL-Based RDBMS

- MySQL
- PostgreSQL
- Oracle Database
- Microsoft SQL Server
- SQLite

**Remember:**

SQL is a language, whereas MySQL is software that understands and executes SQL queries.

---

# 8. SQL vs NoSQL

Databases are broadly classified into relational and non-relational database systems.

### SQL Databases

SQL databases generally use relational tables to store data.

Characteristics:

- Structured data.
- Predefined schemas.
- Relationships between tables.
- SQL query language.
- Strong support for relational integrity and transactions.

Examples:

- MySQL
- PostgreSQL
- Oracle Database
- Microsoft SQL Server

### NoSQL Databases

NoSQL databases use different data models instead of relying exclusively on relational tables.

They are commonly used when applications require flexible data models, specialized access patterns, or particular scalability characteristics.

Common NoSQL database types:

**1. Document Databases**

Store data as documents, commonly JSON-like structures.

Example: MongoDB.

```json
{
    "_id": 1,
    "name": "Riyaz",
    "age": 25,
    "skills": ["JavaScript", "Node.js", "SQL"]
}
```

**2. Key-Value Databases**

Store data as key-value pairs.

Example: Redis.

```text
user:101 = Riyaz
user:102 = Ahmed
```

**3. Column-Family Databases**

Store data using column families.

Example: Apache Cassandra.

**4. Graph Databases**

Store information using nodes and relationships.

Example: Neo4j.

### SQL vs NoSQL Comparison

| Feature | SQL | NoSQL |
|---|---|---|
| Data Model | Relational | Document, Key-Value, Graph, etc. |
| Data Structure | Tables | Depends on database type |
| Schema | Generally predefined | Often flexible |
| Relationships | Native relational model | Depends on database |
| Query Language | SQL | Database-specific APIs or query languages |
| Data Integrity | Relational constraints | Depends on database |
| Examples | MySQL, PostgreSQL | MongoDB, Redis, Cassandra |

### When Should We Use SQL?

Use relational databases when:

- Data has clearly defined relationships.
- Data integrity is important.
- Transactions are important.
- You need complex joins and reporting.
- Your application has structured business data.

Examples:

- Banking applications.
- E-commerce applications.
- Employee management systems.
- Inventory management systems.
- Accounting applications.

### When Should We Use NoSQL?

Consider NoSQL when:

- Data structures are highly flexible.
- You need document-oriented storage.
- Your application has specialized high-scale access patterns.
- A particular NoSQL data model fits your workload better.

Examples:

- Content management systems.
- Event data storage.
- Caching systems.
- Certain real-time applications.

**Important:** SQL and NoSQL are not competitors in every situation. Many modern applications use both.

---

# 9. Types of SQL Commands

SQL commands are commonly divided into five categories.

Understanding these categories is important because we'll use all of them throughout this course.

### 1. DDL – Data Definition Language

DDL commands are used to define and modify database structures.

Commands:

| Command | Purpose |
|---|---|
| CREATE | Creates database objects |
| ALTER | Modifies existing objects |
| DROP | Deletes database objects |
| TRUNCATE | Removes all records from a table |
| RENAME | Renames database objects |

Example:

```sql
CREATE TABLE employees (
    id INT,
    name VARCHAR(100)
);
```

### 2. DML – Data Manipulation Language

DML commands are used to manipulate data inside tables.

Commands:

- INSERT
- UPDATE
- DELETE

Example:

```sql
INSERT INTO employees (id, name)
VALUES (1, 'Riyaz');
```

### 3. DQL – Data Query Language

DQL is commonly used to refer to commands that retrieve data.

Command:

- SELECT

Example:

```sql
SELECT * FROM employees;
```

### 4. DCL – Data Control Language

DCL commands are used to control database access and permissions.

Commands:

- GRANT
- REVOKE

Example:

```sql
GRANT SELECT ON company.employees
TO 'developer'@'localhost';
```

### 5. TCL – Transaction Control Language

TCL commands are used to manage database transactions.

Commands:

- COMMIT
- ROLLBACK
- SAVEPOINT
- START TRANSACTION

Example:

```sql
START TRANSACTION;

UPDATE employees
SET name = 'Ahmed'
WHERE id = 1;

COMMIT;
```

### Quick Revision

| Category | Full Form | Main Purpose |
|---|---|---|
| DDL | Data Definition Language | Structure management |
| DML | Data Manipulation Language | Data modification |
| DQL | Data Query Language | Data retrieval |
| DCL | Data Control Language | Permission management |
| TCL | Transaction Control Language | Transaction management |

---

# 10. What is a Table?

A table is a database object used to store structured data in rows and columns.

Example:

**employees**

| id | name | age | salary |
|---:|---|---:|---:|
| 1 | Riyaz | 25 | 50000 |
| 2 | Ahmed | 26 | 60000 |
| 3 | Rahul | 24 | 45000 |

A table consists of two main components.

### Rows

A row represents a single record in a table.

Example:

```text
1 | Riyaz | 25 | 50000
```

This represents one employee.

Other names for rows:

- Record
- Tuple

### Columns

A column represents a particular attribute of the data.

Example:

```text
id
name
age
salary
```

Each column stores a particular type of information.

Other names for columns:

- Field
- Attribute

### Important Terminology

| Term | Meaning |
|---|---|
| Table | Collection of related records |
| Row | Single record |
| Column | Attribute of a record |
| Field | Commonly used term for a column |
| Record | Single row of data |
| Tuple | Relational database term for a row |
| Attribute | Relational database term for a column |

---

# 11. What is a Database Schema?

A database schema defines the logical structure and organization of a database.

It describes:

- Tables.
- Columns.
- Data types.
- Primary keys.
- Foreign keys.
- Constraints.
- Relationships.
- Other database objects.

### Example

Suppose we have a database called `company`.

It contains three tables:

```text
company
   |
   |------ employees
   |
   |------ departments
   |
   |------ salaries
```

The schema defines how these tables are structured and related.

For example:

```sql
employees
----------
id
name
department_id
```

```sql
departments
-----------
id
department_name
```

Here, `department_id` in employees can reference `id` in departments.

This relationship is part of the database schema.

**Important:** A database schema is not simply a table. It describes the database's structure.

---

# 12. Primary Key and Foreign Key (Introduction)

We'll study these concepts in detail in Phase 7.

For now, understand their basic purpose.

### Primary Key

A Primary Key uniquely identifies each record in a table.

Example:

| id | name |
|---:|---|
| 1 | Riyaz |
| 2 | Ahmed |
| 3 | Rahul |

Here, `id` is the primary key.

A primary key:
- Must contain unique values.
- Cannot contain NULL values.
- Identifies individual records.

### Foreign Key

A Foreign Key establishes a relationship between two tables.

Example:

**departments**

| id | department_name |
|---:|---|
| 1 | IT |
| 2 | HR |
| 3 | Sales |

**employees**

| id | name | department_id |
|---:|---|---:|
| 101 | Riyaz | 1 |
| 102 | Ahmed | 2 |
| 103 | Rahul | 1 |

Here:

- `departments.id` is the Primary Key.
- `employees.department_id` is the Foreign Key.

This allows employees to be associated with their respective departments.

---

# 13. How SQL Works Internally

Let's understand what happens when we execute a SQL query.

Consider:

```sql
SELECT * FROM employees;
```

A simplified SQL execution process looks like this:

**Step 1: Query Submission**

The application or database client sends the SQL query to the database server.

**Step 2: Parsing**

The database checks the query syntax and structure.

**Step 3: Validation**

The database checks whether:
- The table exists.
- The referenced columns exist.
- The user has the required permissions.

**Step 4: Query Optimization**

The query optimizer determines an efficient execution strategy.

For example, it may decide whether an available index should be used.

**Step 5: Query Execution**

The database execution engine executes the selected plan and accesses the required data.

**Step 6: Result Generation**

The database returns the resulting rows to the client.

### Simplified Architecture

```text
       SQL Query
           |
           v
      SQL Parser
           |
           v
     Validation
           |
           v
    Query Optimizer
           |
           v
    Query Executor
           |
           v
      Storage Engine
           |
           v
        Database
           |
           v
      Query Result
```

This is a simplified conceptual representation. Actual database architectures can differ.

---

# 14. SQL Is a Declarative Language

This is an important programming concept.

SQL is primarily a **declarative language**.

A declarative language focuses on what result you want rather than specifying every step required to produce that result.

### Example: SQL

```sql
SELECT name
FROM employees
WHERE salary > 50000;
```

You tell the database:

"Give me the names of employees whose salary is greater than 50000."

You don't specify:

1. How to open the database file.
2. How to search individual records.
3. How to compare each salary.
4. How to store matching records.
5. How to return the result.

The database handles those operations internally.

### Comparison with JavaScript

In JavaScript, you might write:

```javascript
const employees = [
    { name: "Riyaz", salary: 50000 },
    { name: "Ahmed", salary: 60000 },
    { name: "Rahul", salary: 45000 }
];

const result = employees.filter(
    employee => employee.salary > 50000
);

console.log(result);
```

Here, you explicitly describe the filtering operation.

In SQL:

```sql
SELECT *
FROM employees
WHERE salary > 50000;
```

You describe the required result.

This is one reason SQL is powerful for working with large datasets.

---

# 15. SQL Standards and Different SQL Dialects

SQL is standardized, but different database systems implement their own variations and extensions.

These variations are commonly called **SQL dialects**.

For example:

| Feature | MySQL | PostgreSQL | SQL Server |
|---|---|---|---|
| Limit records | LIMIT | LIMIT | TOP |
| Auto-generated ID | AUTO_INCREMENT | IDENTITY / GENERATED AS IDENTITY | IDENTITY |
| Current date | CURDATE() | CURRENT_DATE | GETDATE() for current date and time |
| String concatenation | CONCAT() | `||` or CONCAT() | `+` or CONCAT() |

Example:

**MySQL:**

```sql
SELECT *
FROM employees
LIMIT 5;
```

**SQL Server:**

```sql
SELECT TOP 5 *
FROM employees;
```

The fundamental SQL concepts remain similar, but syntax and available features can differ.

**For this course, we'll primarily follow MySQL 8.0+ syntax.**

---

# 16. Important SQL Interview Questions

Try answering these questions without looking at the explanations.

**Q1. What is data?**

**Q2. What is a database?**

**Q3. What is DBMS?**

**Q4. What is RDBMS?**

**Q5. What is the difference between DBMS and RDBMS?**

**Q6. What is SQL?**

**Q7. What is the difference between SQL and MySQL?**

**Q8. What is the difference between SQL and NoSQL?**

**Q9. What is a relational database?**

**Q10. What is a table?**

**Q11. What is the difference between a row and a column?**

**Q12. What is a database schema?**

**Q13. What is a Primary Key?**

**Q14. What is a Foreign Key?**

**Q15. What are DDL, DML, DQL, DCL, and TCL?**

**Q16. Is SQL a programming language or a query language?**

**Q17. Is SQL declarative or procedural?**

**Q18. Can multiple tables exist inside one database?**

**Q19. Can multiple applications connect to the same database?**

**Q20. What happens internally when a SQL query executes?**

---

# 17. Phase 1 Practice Assignment

Before moving to Phase 2, complete these exercises.

### Assignment 1: Understand Database Concepts

Explain the following in your own words:

1. Database
2. DBMS
3. RDBMS
4. SQL
5. MySQL
6. NoSQL
7. Database Schema
8. Primary Key
9. Foreign Key

### Assignment 2: Real-world Database Identification

Consider an application like Amazon.

Identify at least 10 tables that might be required to manage the application.

For example:

- Customers
- Products
- Orders

Try identifying the remaining tables yourself.

### Assignment 3: SQL Command Classification

Classify the following commands into DDL, DML, DQL, DCL, and TCL:

```sql
CREATE
SELECT
INSERT
UPDATE
DELETE
ALTER
DROP
TRUNCATE
GRANT
REVOKE
COMMIT
ROLLBACK
SAVEPOINT
```

### Assignment 4: Conceptual Questions

Answer these:

1. Can a database contain multiple tables?
2. Can a table contain multiple primary keys?
3. Can a table have multiple foreign keys?
4. Can two different tables have a column with the same name?
5. Can two different databases contain tables with the same name?
6. Can we use SQL with databases other than MySQL?
7. Is MongoDB an RDBMS?
8. Is MySQL a programming language?

---

# Phase 1 – Completion Checklist

| No. | Topic | Status |
|---|---|---|
| 1 | Data | Covered |
| 2 | Database | Covered |
| 3 | DBMS | Covered |
| 4 | RDBMS | Covered |
| 5 | DBMS vs RDBMS | Covered |
| 6 | SQL | Covered |
| 7 | SQL vs MySQL | Covered |
| 8 | SQL vs NoSQL | Covered |
| 9 | Types of SQL Commands | Covered |
| 10 | Tables, Rows, Columns | Covered |
| 11 | Database Schema | Covered |
| 12 | Primary Key and Foreign Key | Introduction |
| 13 | SQL Internal Working | Covered |
| 14 | Declarative Language | Covered |
| 15 | SQL Standards and Dialects | Covered |

**Phase 1 is complete from a theory perspective.**

My recommendation: Don't just read these notes. Try answering all 20 interview questions and completing the assignments.

Once you're comfortable, tell me **"Proceed to Phase 2"**.

In Phase 2, we'll install and configure MySQL, understand the MySQL server and client, learn MySQL Workbench and CLI, and execute our first SQL commands.