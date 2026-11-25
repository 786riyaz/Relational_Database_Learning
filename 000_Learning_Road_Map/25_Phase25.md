# SQL Complete Learning Roadmap – Phase 25
# SQL Integration with Node.js

Welcome to the final phase of the SQL learning roadmap!

In the previous phases, you learned SQL from database fundamentals to advanced database management.

Now we will connect SQL with Node.js and build backend applications that communicate with MySQL.

Since you are learning Node.js, Express, MySQL2 and Sequelize, this phase will focus on practical backend development.

## Topics Covered

1. Introduction to MySQL Integration with Node.js
2. MySQL2 Package
3. Connecting Node.js with MySQL
4. Connection vs Connection Pool
5. Executing SQL Queries
6. Parameterized Queries
7. CRUD Operations
8. MySQL Integration with Express
9. JOINs in Backend APIs
10. Transactions with Node.js
11. Stored Procedures with Node.js
12. Error Handling
13. Pagination and Filtering
14. Connection Pooling
15. Sequelize ORM vs Raw SQL
16. Database Migrations
17. SQL Injection Prevention
18. Environment Variables and Security
19. API Performance Optimization
20. Complete Employee Management System

---

# 1. Introduction to MySQL Integration with Node.js

Node.js allows you to build backend applications.

However, Node.js itself does not directly understand how to communicate with every database.

You need a database driver or library.

For MySQL, some commonly used options are:

| Package | Purpose |
|---|---|
| mysql2 | MySQL database driver for Node.js |
| mysql | Older MySQL driver |
| Sequelize | ORM for relational databases |
| Prisma | Type-safe database ORM |
| Knex.js | SQL query builder |

In this phase, we will primarily use **mysql2**.

### How Does Node.js Communicate with MySQL?

Consider a simple application where a user requests employee information.

The flow looks like this:

```text
          Frontend
             |
             | HTTP Request
             v
       Node.js + Express
             |
             | SQL Query
             v
          MySQL2
             |
             | MySQL Protocol
             v
         MySQL Server
             |
             | Query Result
             v
          MySQL2
             |
             v
       Node.js + Express
             |
             | JSON Response
             v
          Frontend
```

### Example

The frontend sends:

```http
GET /api/employees
```

Express receives the request.

Node.js executes:

```sql
SELECT * FROM employees;
```

MySQL returns the records.

Node.js converts the result into JSON and sends it to the frontend.

---

# 2. Installing MySQL2

Create a Node.js project.

```bash
mkdir mysql-node-project

cd mysql-node-project

npm init -y
```

Install dependencies:

```bash
npm install mysql2 express dotenv
```

For development, install nodemon:

```bash
npm install --save-dev nodemon
```

### Package Explanation

| Package | Purpose |
|---|---|
| mysql2 | Connects Node.js with MySQL |
| express | Creates backend APIs |
| dotenv | Loads environment variables |
| nodemon | Automatically restarts the development server |

### package.json

Add scripts:

```json
{
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  }
}
```

Run:

```bash
npm run dev
```

---

# 3. Connecting Node.js with MySQL

There are two common ways to establish a MySQL connection.

1. Using `createConnection()`
2. Using `createPool()`

Let's understand both.

## 3.1 Using createConnection()

`createConnection()` creates a single database connection.

Example:

```javascript
const mysql = require("mysql2");

const connection = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "password",
    database: "company_db",
    port: 3306
});

connection.connect((error) => {

    if (error) {
        console.error("Database connection failed:", error);
        return;
    }

    console.log("Connected to MySQL!");

});
```

### Explanation

| Property | Meaning |
|---|---|
| host | MySQL server address |
| user | MySQL username |
| password | MySQL password |
| database | Database name |
| port | MySQL server port |

Default MySQL port:

```text
3306
```

### When Should You Use createConnection()?

Useful for:

- Small scripts.
- One-time database operations.
- Simple utilities.
- Short-lived database tasks.

For an API server that handles multiple requests, a connection pool is generally preferable.

---

# 4. Using MySQL2 Promise API

MySQL2 provides a Promise-based API.

This allows you to use:

- async
- await
- try
- catch

Instead of callback-based code.

### Callback-Based Example

```javascript
connection.query(
    "SELECT * FROM employees",
    (error, results) => {

        if (error) {
            console.error(error);
            return;
        }

        console.log(results);

    }
);
```

### Promise-Based Example

```javascript
const mysql = require("mysql2/promise");

async function getEmployees() {

    const connection = await mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "password",
        database: "company_db"
    });

    try {

        const [rows] = await connection.execute(
            "SELECT * FROM employees"
        );

        console.log(rows);

    } catch (error) {

        console.error(error);

    } finally {

        await connection.end();

    }

}

getEmployees();
```

### Why Do We Use async/await?

Database operations are asynchronous.

The application should not block while waiting for the database response.

`await` allows you to write asynchronous code in a readable, sequential style.

---

# 5. Connection vs Connection Pool

This is one of the most important concepts in backend database integration.

## 5.1 What Is a Connection?

A connection represents a communication session between Node.js and the MySQL server.

Example:

```javascript
const connection = await mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "password",
    database: "company_db"
});
```

Every time you create a connection, MySQL establishes a new session.

## 5.2 What Is Connection Pooling?

A connection pool maintains multiple reusable database connections.

Instead of creating a new connection for every API request, your application can reuse existing connections.

Example:

```javascript
const mysql = require("mysql2/promise");

const pool = mysql.createPool({
    host: "localhost",
    user: "root",
    password: "password",
    database: "company_db",

    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});
```

### Understanding Pool Configuration

| Property | Meaning |
|---|---|
| waitForConnections | Wait when all connections are busy |
| connectionLimit | Maximum number of connections in the pool |
| queueLimit | Maximum queued connection requests; 0 means unlimited |

### How Connection Pooling Works

Suppose your application receives 100 API requests simultaneously.

Without pooling:

```text
Request 1  → New Connection
Request 2  → New Connection
Request 3  → New Connection
...
Request 100 → New Connection
```

With a pool of 10 connections:

```text
              Connection Pool
             /   /   |   \   \
            C1  C2  C3  ... C10
             \   \   |   /   /
                 Requests
```

Requests wait for an available connection when all connections are busy.

After a query finishes, the connection becomes available for reuse.

### Why Is Connection Pooling Important?

1. Reduces connection creation overhead.
2. Controls the number of database connections.
3. Improves resource utilization.
4. Handles concurrent API requests more efficiently.
5. Helps avoid opening excessive database connections.

**Recommendation:** Use connection pooling for most long-running Express applications.

---

# 6. Creating a Separate Database Connection File

In real-world projects, you should not create database connections repeatedly inside controllers.

Instead, create a separate configuration file.

### Project Structure

```text
mysql-node-project/
│
├── config/
│   └── db.js
│
├── controllers/
│
├── routes/
│
├── .env
├── .gitignore
├── server.js
└── package.json
```

### config/db.js

```javascript
const mysql = require("mysql2/promise");

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: Number(process.env.DB_PORT) || 3306,

    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

module.exports = pool;
```

### .env

```env
PORT=5000

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=password
DB_NAME=company_db
DB_PORT=3306
```

### server.js

```javascript
require("dotenv").config();

const express = require("express");
const pool = require("./config/db");

const app = express();

app.use(express.json());

app.get("/", (req, res) => {
    res.send("MySQL Node.js Application");
});

async function startServer() {

    try {

        const connection = await pool.getConnection();

        console.log("MySQL connected successfully");

        connection.release();

        app.listen(process.env.PORT, () => {
            console.log(
                `Server running on port ${process.env.PORT}`
            );
        });

    } catch (error) {

        console.error("Database connection failed:", error);

        process.exit(1);

    }

}

startServer();
```

### Important

`pool.getConnection()` obtains a connection from the pool.

After testing it, we call:

```javascript
connection.release();
```

This returns the connection to the pool.

Do not call `connection.end()` on a pooled connection that you intend to reuse.

---

# 7. Executing SQL Queries Using Node.js

MySQL2 provides two commonly used query methods:

1. `query()`
2. `execute()`

Let's understand the difference.

## 7.1 query()

Example:

```javascript
const [rows] = await pool.query(
    "SELECT * FROM employees"
);

console.log(rows);
```

`query()` supports SQL queries and MySQL client-side formatting of placeholders.

## 7.2 execute()

Example:

```javascript
const [rows] = await pool.execute(
    "SELECT * FROM employees WHERE id = ?",
    [1]
);

console.log(rows);
```

`execute()` uses prepared statements with parameter binding.

This is generally a good choice for application queries containing user-provided values.

### Difference Between query() and execute()

| Feature | query() | execute() |
|---|---|---|
| SQL execution | Yes | Yes |
| Parameter formatting | Yes | Yes |
| Server-side prepared statements | Not by default | Yes |
| Repeated statement execution | Depends on usage | Supports prepared statement caching in the connection |
| User input handling | Must be handled safely | Parameterized values are safely bound |

**Important:** Both methods can be used safely with correctly parameterized values. Do not concatenate untrusted input into SQL strings.

---

# 8. Understanding Query Results

Consider:

```javascript
const [rows] = await pool.execute(
    "SELECT * FROM employees"
);
```

Why do we write:

```javascript
const [rows] = ...
```

Because the Promise-based MySQL2 API returns an array containing two values:

```javascript
[
    rows,
    fields
]
```

For SELECT queries:

- `rows` contains the returned records.
- `fields` contains column metadata.

Example:

```javascript
const [rows, fields] = await pool.execute(
    "SELECT * FROM employees"
);

console.log("Rows:", rows);

console.log("Fields:", fields);
```

### INSERT Result

```javascript
const [result] = await pool.execute(
    "INSERT INTO employees (name, salary) VALUES (?, ?)",
    ["Rahul", 50000]
);

console.log(result);
```

The result object can contain:

| Property | Meaning |
|---|---|
| insertId | Generated AUTO_INCREMENT value |
| affectedRows | Number of affected rows |
| changedRows | Number of rows whose values actually changed, where applicable |
| warningStatus | Warning information |

Example:

```javascript
console.log(result.insertId);
```

---

# 9. Parameterized Queries

Parameterized queries are essential for preventing SQL injection.

Suppose a user submits an employee ID.

Incorrect approach:

```javascript
const id = req.params.id;

const query = `
    SELECT *
    FROM employees
    WHERE id = ${id}
`;
```

This directly inserts user input into the SQL query.

A malicious user might provide specially crafted input to manipulate the query.

### Correct Approach

```javascript
const id = req.params.id;

const [rows] = await pool.execute(
    "SELECT * FROM employees WHERE id = ?",
    [id]
);
```

The `?` is a placeholder for a value.

MySQL2 binds the supplied value separately from the SQL structure.

### Multiple Parameters

```javascript
const [rows] = await pool.execute(
    `
        SELECT *
        FROM employees
        WHERE department = ?
        AND salary >= ?
    `,
    ["IT", 50000]
);
```

### Important Rules

- Use `?` for values.
- Do not manually concatenate user input.
- Validate input before executing queries.
- Parameter placeholders cannot represent table names or column names.
- Use allowlists for dynamic identifiers.

### Example: Dynamic ORDER BY

This is incorrect:

```javascript
const query = `
    SELECT *
    FROM employees
    ORDER BY ${req.query.sort}
`;
```

Instead, use an allowlist:

```javascript
const allowedColumns = [
    "name",
    "salary",
    "created_at"
];

const sortColumn = allowedColumns.includes(req.query.sort)
    ? req.query.sort
    : "id";

const [rows] = await pool.query(
    `SELECT * FROM employees ORDER BY \`${sortColumn}\``
);
```

Here, the column name comes only from a predefined list.

For sort direction, validate separately:

```javascript
const sortOrder =
    req.query.order?.toUpperCase() === "DESC"
        ? "DESC"
        : "ASC";
```

Then:

```javascript
const [rows] = await pool.query(
    `SELECT * FROM employees ORDER BY \`${sortColumn}\` ${sortOrder}`
);
```

Both dynamic identifiers are controlled by the application.

---

# 10. CRUD Operations with Node.js

CRUD stands for:

- Create
- Read
- Update
- Delete

Let's implement all four operations.

Assume this table:

```sql
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    department VARCHAR(50),
    salary DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 10.1 CREATE – Insert Employee

```javascript
async function createEmployee(employee) {

    const {
        name,
        email,
        department,
        salary
    } = employee;

    const [result] = await pool.execute(
        `
            INSERT INTO employees
            (name, email, department, salary)
            VALUES (?, ?, ?, ?)
        `,
        [name, email, department, salary]
    );

    return result.insertId;

}
```

Call:

```javascript
const employeeId = await createEmployee({
    name: "Rahul",
    email: "rahul@gmail.com",
    department: "IT",
    salary: 50000
});

console.log(employeeId);
```

## 10.2 READ – Get All Employees

```javascript
async function getEmployees() {

    const [rows] = await pool.execute(
        "SELECT * FROM employees ORDER BY id DESC"
    );

    return rows;

}
```

## 10.3 READ – Get Employee by ID

```javascript
async function getEmployeeById(id) {

    const [rows] = await pool.execute(
        "SELECT * FROM employees WHERE id = ?",
        [id]
    );

    return rows[0] || null;

}
```

## 10.4 UPDATE – Update Employee

```javascript
async function updateEmployee(id, employee) {

    const {
        name,
        email,
        department,
        salary
    } = employee;

    const [result] = await pool.execute(
        `
            UPDATE employees
            SET
                name = ?,
                email = ?,
                department = ?,
                salary = ?
            WHERE id = ?
        `,
        [name, email, department, salary, id]
    );

    return result.affectedRows;

}
```

## 10.5 DELETE – Delete Employee

```javascript
async function deleteEmployee(id) {

    const [result] = await pool.execute(
        "DELETE FROM employees WHERE id = ?",
        [id]
    );

    return result.affectedRows;

}
```

**Important:** `affectedRows` tells you how many rows were matched/affected by the operation according to the result. For UPDATE, `changedRows` can help distinguish rows whose values actually changed.

---

# 11. Integrating MySQL with Express APIs

Now let's create actual REST APIs.

### Project Structure

```text
employee-management/
│
├── config/
│   └── db.js
│
├── controllers/
│   └── employeeController.js
│
├── routes/
│   └── employeeRoutes.js
│
├── .env
├── .gitignore
├── server.js
└── package.json
```

## 11.1 Database Configuration

`config/db.js`

```javascript
const mysql = require("mysql2/promise");

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: Number(process.env.DB_PORT) || 3306,

    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

module.exports = pool;
```

## 11.2 Employee Controller

`controllers/employeeController.js`

```javascript
const pool = require("../config/db");

// CREATE EMPLOYEE
exports.createEmployee = async (req, res) => {

    try {

        const {
            name,
            email,
            department,
            salary
        } = req.body;

        if (!name || !email || !department || salary === undefined) {
            return res.status(400).json({
                success: false,
                message: "All fields are required"
            });
        }

        if (!Number.isFinite(Number(salary)) || Number(salary) < 0) {
            return res.status(400).json({
                success: false,
                message: "Salary must be a valid non-negative number"
            });
        }

        const [result] = await pool.execute(
            `
                INSERT INTO employees
                (name, email, department, salary)
                VALUES (?, ?, ?, ?)
            `,
            [name, email, department, salary]
        );

        return res.status(201).json({
            success: true,
            message: "Employee created successfully",
            employeeId: result.insertId
        });

    } catch (error) {

        console.error(error);

        return res.status(500).json({
            success: false,
            message: "Internal server error"
        });

    }

};


// GET ALL EMPLOYEES
exports.getEmployees = async (req, res) => {

    try {

        const [rows] = await pool.execute(
            "SELECT * FROM employees ORDER BY id DESC"
        );

        return res.status(200).json({
            success: true,
            data: rows
        });

    } catch (error) {

        console.error(error);

        return res.status(500).json({
            success: false,
            message: "Internal server error"
        });

    }

};


// GET EMPLOYEE BY ID
exports.getEmployeeById = async (req, res) => {

    try {

        const id = Number(req.params.id);

        if (!Number.isInteger(id) || id <= 0) {
            return res.status(400).json({
                success: false,
                message: "Invalid employee ID"
            });
        }

        const [rows] = await pool.execute(
            "SELECT * FROM employees WHERE id = ?",
            [id]
        );

        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: "Employee not found"
            });
        }

        return res.status(200).json({
            success: true,
            data: rows[0]
        });

    } catch (error) {

        console.error(error);

        return res.status(500).json({
            success: false,
            message: "Internal server error"
        });

    }

};


// UPDATE EMPLOYEE
exports.updateEmployee = async (req, res) => {

    try {

        const id = Number(req.params.id);

        const {
            name,
            email,
            department,
            salary
        } = req.body;

        if (!Number.isInteger(id) || id <= 0) {
            return res.status(400).json({
                success: false,
                message: "Invalid employee ID"
            });
        }

        if (!name || !email || !department || salary === undefined) {
            return res.status(400).json({
                success: false,
                message: "All fields are required"
            });
        }

        if (!Number.isFinite(Number(salary)) || Number(salary) < 0) {
            return res.status(400).json({
                success: false,
                message: "Invalid salary"
            });
        }

        const [result] = await pool.execute(
            `
                UPDATE employees
                SET
                    name = ?,
                    email = ?,
                    department = ?,
                    salary = ?
                WHERE id = ?
            `,
            [name, email, department, salary, id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: "Employee not found"
            });
        }

        return res.status(200).json({
            success: true,
            message: "Employee updated successfully"
        });

    } catch (error) {

        console.error(error);

        return res.status(500).json({
            success: false,
            message: "Internal server error"
        });

    }

};


// DELETE EMPLOYEE
exports.deleteEmployee = async (req, res) => {

    try {

        const id = Number(req.params.id);

        if (!Number.isInteger(id) || id <= 0) {
            return res.status(400).json({
                success: false,
                message: "Invalid employee ID"
            });
        }

        const [result] = await pool.execute(
            "DELETE FROM employees WHERE id = ?",
            [id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: "Employee not found"
            });
        }

        return res.status(200).json({
            success: true,
            message: "Employee deleted successfully"
        });

    } catch (error) {

        console.error(error);

        return res.status(500).json({
            success: false,
            message: "Internal server error"
        });

    }

};
```

**Note:** This controller demonstrates CRUD integration. Production APIs should use a validation library or schema-based validation, and should map known database errors to appropriate HTTP responses.

## 11.3 Employee Routes

`routes/employeeRoutes.js`

```javascript
const express = require("express");

const router = express.Router();

const employeeController = require("../controllers/employeeController");

router.post("/", employeeController.createEmployee);

router.get("/", employeeController.getEmployees);

router.get("/:id", employeeController.getEmployeeById);

router.put("/:id", employeeController.updateEmployee);

router.delete("/:id", employeeController.deleteEmployee);

module.exports = router;
```

## 11.4 Main Server

`server.js`

```javascript
require("dotenv").config();

const express = require("express");
const pool = require("./config/db");

const employeeRoutes = require("./routes/employeeRoutes");

const app = express();

app.use(express.json());

app.use("/api/employees", employeeRoutes);

app.get("/", (req, res) => {
    res.send("Employee Management API");
});

async function startServer() {

    try {

        await pool.query("SELECT 1");

        console.log("MySQL connected successfully");

        app.listen(process.env.PORT || 5000, () => {
            console.log("Server is running");
        });

    } catch (error) {

        console.error("Database connection failed:", error);

        process.exit(1);

    }

}

startServer();
```

---

# 12. API Endpoints

Your application now supports these endpoints:

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/api/employees` | Create employee |
| GET | `/api/employees` | Get all employees |
| GET | `/api/employees/:id` | Get employee by ID |
| PUT | `/api/employees/:id` | Update employee |
| DELETE | `/api/employees/:id` | Delete employee |

### Example POST Request

```http
POST /api/employees
```

JSON body:

```json
{
    "name": "Rahul Sharma",
    "email": "rahul@gmail.com",
    "department": "IT",
    "salary": 50000
}
```

Response:

```json
{
    "success": true,
    "message": "Employee created successfully",
    "employeeId": 1
}
```

### Example GET Request

```http
GET /api/employees
```

Response:

```json
{
    "success": true,
    "data": [
        {
            "id": 1,
            "name": "Rahul Sharma",
            "email": "rahul@gmail.com",
            "department": "IT",
            "salary": "50000.00"
        }
    ]
}
```

The exact JSON representation of DECIMAL values depends on your MySQL2 configuration.

---

# 13. Implementing JOINs in Backend APIs

You already know how JOINs work in SQL.

Now let's use them inside Node.js.

Suppose you have two tables.

### departments

```sql
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100)
);
```

### employees

```sql
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10,2),

    FOREIGN KEY (department_id)
    REFERENCES departments(id)
);
```

### SQL Query

```sql
SELECT
    e.id,
    e.name,
    e.salary,
    d.department_name
FROM employees e
INNER JOIN departments d
    ON e.department_id = d.id;
```

### Node.js Implementation

```javascript
async function getEmployeeDetails() {

    const [rows] = await pool.execute(
        `
            SELECT
                e.id,
                e.name,
                e.salary,
                d.department_name
            FROM employees e
            INNER JOIN departments d
                ON e.department_id = d.id
        `
    );

    return rows;

}
```

You can expose this function through an Express endpoint.

```javascript
router.get("/details", async (req, res) => {

    try {

        const [rows] = await pool.execute(
            `
                SELECT
                    e.id,
                    e.name,
                    e.salary,
                    d.department_name
                FROM employees e
                INNER JOIN departments d
                    ON e.department_id = d.id
            `
        );

        res.json({
            success: true,
            data: rows
        });

    } catch (error) {

        console.error(error);

        res.status(500).json({
            success: false,
            message: "Internal server error"
        });

    }

});
```

---

# 14. Transactions with Node.js

Transactions are extremely important when multiple database operations must succeed or fail together.

Consider an e-commerce application.

When a customer places an order, you may need to:

1. Insert an order.
2. Insert order items.
3. Update product inventory.
4. Insert payment information.

If the third operation fails, you may not want the first two operations to remain committed.

Use a transaction.

## 14.1 Basic Transaction Example

```javascript
async function transferMoney(fromAccount, toAccount, amount) {

    const connection = await pool.getConnection();

    try {

        await connection.beginTransaction();

        await connection.execute(
            `
                UPDATE accounts
                SET balance = balance - ?
                WHERE id = ?
            `,
            [amount, fromAccount]
        );

        await connection.execute(
            `
                UPDATE accounts
                SET balance = balance + ?
                WHERE id = ?
            `,
            [amount, toAccount]
        );

        await connection.commit();

        console.log("Transaction completed");

    } catch (error) {

        await connection.rollback();

        console.error("Transaction failed:", error);

        throw error;

    } finally {

        connection.release();

    }

}
```

### Important

The transaction must use the same connection for all operations.

Do not execute different transaction statements through separate pool queries.

### Production Improvements

The example above is intentionally simplified.

A real money transfer should also:

- Validate that the amount is positive.
- Verify both accounts exist.
- Lock account rows using `SELECT ... FOR UPDATE`.
- Check that the sender has sufficient funds.
- Prevent transferring money to the same account if prohibited.
- Handle deadlocks and retry safely.
- Use idempotency to prevent duplicate transfers.

Example of a conditional debit:

```sql
UPDATE accounts
SET balance = balance - ?
WHERE id = ?
AND balance >= ?;
```

Then check `affectedRows`.

This prevents the balance from becoming negative due to an unchecked withdrawal, assuming the rest of the transaction is correctly designed.

---

# 15. Stored Procedures with Node.js

You learned stored procedures in Phase 22.

Now let's call them using MySQL2.

Suppose you created this procedure:

```sql
CREATE PROCEDURE GetEmployeesByDepartment(
    IN department_name VARCHAR(50)
)
BEGIN
    SELECT *
    FROM employees
    WHERE department = department_name;
END;
```

Call it from Node.js:

```javascript
async function getEmployeesByDepartment(department) {

    const [results] = await pool.query(
        "CALL GetEmployeesByDepartment(?)",
        [department]
    );

    return results[0];

}
```

Execute:

```javascript
const employees = await getEmployeesByDepartment("IT");

console.log(employees);
```

### Understanding the Result

MySQL2 returns multiple result sets for stored procedure calls.

The first element generally contains the first result set returned by the procedure.

For a procedure that executes multiple SELECT statements, inspect the returned structure carefully.

### OUT Parameters

Suppose your procedure is:

```sql
CREATE PROCEDURE GetEmployeeCount(
    OUT total_employees INT
)
BEGIN
    SELECT COUNT(*)
    INTO total_employees
    FROM employees;
END;
```

Call:

```javascript
const [result] = await pool.query(
    "CALL GetEmployeeCount(@total)"
);

const [rows] = await pool.query(
    "SELECT @total AS total_employees"
);

console.log(rows[0].total_employees);
```

**Important:** MySQL user-defined variables are session-specific. If you use a connection pool, the CALL and subsequent SELECT must execute on the same connection.

A safer implementation:

```javascript
async function getEmployeeCount() {

    const connection = await pool.getConnection();

    try {

        await connection.query(
            "CALL GetEmployeeCount(@total)"
        );

        const [rows] = await connection.query(
            "SELECT @total AS total_employees"
        );

        return rows[0].total_employees;

    } finally {

        connection.release();

    }

}
```

---

# 16. Error Handling in Node.js and MySQL

Database errors can happen for many reasons:

- Duplicate email.
- Invalid foreign key.
- Missing required value.
- Database connection failure.
- SQL syntax error.
- Deadlock.
- Lock wait timeout.

You should handle errors appropriately.

### Example

```javascript
try {

    const [result] = await pool.execute(
        `
            INSERT INTO employees (name, email)
            VALUES (?, ?)
        `,
        ["Rahul", "rahul@gmail.com"]
    );

    console.log(result);

} catch (error) {

    console.error("Error code:", error.code);

    console.error("Error message:", error.message);

}
```

### Common MySQL Error Codes

| Error Code | Meaning |
|---|---|
| ER_DUP_ENTRY | Duplicate entry |
| ER_NO_REFERENCED_ROW_2 | Foreign key constraint failure |
| ER_ROW_IS_REFERENCED_2 | Cannot delete/update referenced parent row |
| ER_BAD_FIELD_ERROR | Unknown column |
| ER_NO_SUCH_TABLE | Table does not exist |
| ER_PARSE_ERROR | SQL syntax error |
| ER_LOCK_DEADLOCK | Deadlock detected |
| ER_LOCK_WAIT_TIMEOUT | Lock wait timeout |
| ECONNREFUSED | Connection refused |

### Handling Duplicate Email

```javascript
try {

    await pool.execute(
        `
            INSERT INTO employees (name, email)
            VALUES (?, ?)
        `,
        ["Rahul", "rahul@gmail.com"]
    );

} catch (error) {

    if (error.code === "ER_DUP_ENTRY") {

        console.log("Email already exists");

    } else {

        console.error(error);

    }

}
```

### Important

Do not send raw database error messages, SQL statements, credentials, or internal server details to frontend users.

Log technical details securely on the backend and return appropriate HTTP error responses.

---

# 17. Pagination with Node.js and MySQL

Suppose your employees table contains 100,000 records.

Returning all records in one API response is inefficient.

Instead, implement pagination.

### Pagination Parameters

- `page`: Current page.
- `limit`: Number of records per page.
- `offset`: Number of records to skip.

Formula:

```text
offset = (page - 1) × limit
```

Example:

```text
page = 2
limit = 10

offset = (2 - 1) × 10

offset = 10
```

### SQL Query

```sql
SELECT *
FROM employees
ORDER BY id DESC
LIMIT 10 OFFSET 10;
```

### Node.js Implementation

```javascript
async function getEmployees(page = 1, limit = 10) {

    page = Math.max(1, Number(page) || 1);

    limit = Math.min(
        100,
        Math.max(1, Number(limit) || 10)
    );

    const offset = (page - 1) * limit;

    const [rows] = await pool.execute(
        `
            SELECT *
            FROM employees
            ORDER BY id DESC
            LIMIT ? OFFSET ?
        `,
        [limit, offset]
    );

    return rows;

}
```

### Express Endpoint

```javascript
router.get("/", async (req, res) => {

    try {

        const page = Number(req.query.page) || 1;

        const limit = Number(req.query.limit) || 10;

        const employees = await getEmployees(page, limit);

        res.json({
            success: true,
            page,
            limit,
            data: employees
        });

    } catch (error) {

        console.error(error);

        res.status(500).json({
            success: false,
            message: "Internal server error"
        });

    }

});
```

Request:

```http
GET /api/employees?page=2&limit=10
```

### Important

Large OFFSET values can become inefficient because MySQL may need to scan and discard many rows.

For large datasets, consider keyset pagination.

## Keyset Pagination

Instead of using OFFSET, use the last ID from the previous page.

Example:

```sql
SELECT *
FROM employees
WHERE id < ?
ORDER BY id DESC
LIMIT 10;
```

Node.js:

```javascript
async function getNextEmployees(lastId, limit = 10) {

    const [rows] = await pool.execute(
        `
            SELECT *
            FROM employees
            WHERE id < ?
            ORDER BY id DESC
            LIMIT ?
        `,
        [lastId, limit]
    );

    return rows;

}
```

Keyset pagination is generally more efficient for deep pagination when the ordering key is indexed and stable.

---

# 18. Filtering and Searching

Backend APIs often need search and filtering functionality.

For example:

```http
GET /api/employees?department=IT
```

Or:

```http
GET /api/employees?minSalary=50000
```

### Department Filtering

```javascript
async function getEmployeesByDepartment(department) {

    const [rows] = await pool.execute(
        `
            SELECT *
            FROM employees
            WHERE department = ?
        `,
        [department]
    );

    return rows;

}
```

### Salary Filtering

```javascript
async function getEmployeesBySalary(minSalary) {

    const [rows] = await pool.execute(
        `
            SELECT *
            FROM employees
            WHERE salary >= ?
        `,
        [minSalary]
    );

    return rows;

}
```

### Search by Employee Name

```javascript
async function searchEmployees(search) {

    const [rows] = await pool.execute(
        `
            SELECT *
            FROM employees
            WHERE name LIKE ?
        `,
        [`%${search}%`]
    );

    return rows;

}
```

### Multiple Filters

```javascript
async function filterEmployees(filters) {

    const conditions = [];

    const values = [];

    if (filters.department) {

        conditions.push("department = ?");

        values.push(filters.department);

    }

    if (filters.minSalary !== undefined) {

        conditions.push("salary >= ?");

        values.push(filters.minSalary);

    }

    if (filters.maxSalary !== undefined) {

        conditions.push("salary <= ?");

        values.push(filters.maxSalary);

    }

    let sql = "SELECT * FROM employees";

    if (conditions.length > 0) {

        sql += " WHERE " + conditions.join(" AND ");

    }

    const [rows] = await pool.execute(sql, values);

    return rows;

}
```

Here, SQL structure is built only from predefined conditions, while actual user values are passed as parameters.

You should also validate numeric values and allowed filter fields before executing this function.

---

# 19. Sequelize ORM vs Raw SQL

You have already used Sequelize in your Node.js projects.

Now let's compare Sequelize with MySQL2.

## 19.1 What Is an ORM?

ORM stands for Object-Relational Mapping.

An ORM allows developers to interact with relational databases using programming-language objects and methods.

Instead of manually writing every SQL query, you define models and perform database operations through the ORM.

### Raw SQL Using MySQL2

```javascript
const [rows] = await pool.execute(
    "SELECT * FROM employees WHERE id = ?",
    [1]
);
```

### Using Sequelize

```javascript
const employee = await Employee.findByPk(1);
```

Both retrieve an employee.

## 19.2 Creating a Sequelize Model

Install:

```bash
npm install sequelize mysql2
```

Create:

`models/Employee.js`

```javascript
const { DataTypes } = require("sequelize");

const sequelize = require("../config/sequelize");

const Employee = sequelize.define("Employee", {

    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },

    name: {
        type: DataTypes.STRING(100),
        allowNull: false
    },

    email: {
        type: DataTypes.STRING(150),
        unique: true
    },

    department: {
        type: DataTypes.STRING(50)
    },

    salary: {
        type: DataTypes.DECIMAL(10, 2)
    }

}, {
    tableName: "employees",
    timestamps: false
});

module.exports = Employee;
```

### Sequelize Configuration

`config/sequelize.js`

```javascript
const { Sequelize } = require("sequelize");

const sequelize = new Sequelize(
    process.env.DB_NAME,
    process.env.DB_USER,
    process.env.DB_PASSWORD,
    {
        host: process.env.DB_HOST,
        dialect: "mysql",
        logging: false
    }
);

module.exports = sequelize;
```

### Read Employees

```javascript
const employees = await Employee.findAll();
```

### Find Employee by ID

```javascript
const employee = await Employee.findByPk(1);
```

### Insert Employee

```javascript
const employee = await Employee.create({
    name: "Rahul",
    email: "rahul@gmail.com",
    department: "IT",
    salary: 50000
});
```

### Update Employee

```javascript
await Employee.update(
    {
        salary: 60000
    },
    {
        where: {
            id: 1
        }
    }
);
```

### Delete Employee

```javascript
await Employee.destroy({
    where: {
        id: 1
    }
});
```

## 19.3 Comparison

| Feature | Raw SQL / MySQL2 | Sequelize |
|---|---|---|
| Query writing | Manual SQL | ORM methods or raw SQL |
| SQL control | Full control | Abstracted, with raw-query support |
| Learning SQL | Requires SQL knowledge | Some operations can be written without SQL |
| Complex queries | Excellent control | May require raw SQL |
| Model definitions | Not required | Required for model-based operations |
| Relationships | Written manually | Model associations |
| Migrations | Separate migration tool or custom scripts | Sequelize CLI migrations |
| Performance | Direct SQL control | Depends on generated SQL and ORM overhead |
| Database portability | SQL may be MySQL-specific | Supports multiple SQL dialects |
| Debugging | Inspect SQL directly | May need to inspect generated SQL |

### When Should You Use MySQL2?

Use raw SQL when:

- You need complete SQL control.
- Queries are complex.
- You are writing reports.
- You want to understand database behavior.
- You need specialized MySQL functionality.

### When Should You Use Sequelize?

Use Sequelize when:

- You want model-based database access.
- You need model relationships.
- You want ORM associations.
- You want built-in model validation.
- You need ORM-based migrations.

**Important:** An ORM does not eliminate the need to understand SQL. Good backend developers should understand both.

---

# 20. Database Migrations

Suppose your application is running in production.

Initially, your employees table has:

```sql
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);
```

After some time, you need to add an email column.

You execute:

```sql
ALTER TABLE employees
ADD COLUMN email VARCHAR(150);
```

But how do you track this change?

How do you apply the same change to development, testing, and production databases?

This is where database migrations are useful.

### What Is a Migration?

A migration is a version-controlled change to the database structure or data.

Examples:

- Creating a table.
- Adding a column.
- Dropping a column.
- Adding an index.
- Creating a foreign key.
- Modifying a column.

### Migration Example

A migration usually contains two operations:

1. `up`: Applies the change.
2. `down`: Reverses the change.

Example using Sequelize migration style:

```javascript
"use strict";

module.exports = {

    async up(queryInterface, Sequelize) {

        await queryInterface.addColumn(
            "employees",
            "email",
            {
                type: Sequelize.STRING(150),
                allowNull: true
            }
        );

    },

    async down(queryInterface) {

        await queryInterface.removeColumn(
            "employees",
            "email"
        );

    }

};
```

### Understanding up and down

| Method | Purpose |
|---|---|
| up() | Apply migration |
| down() | Roll back migration |

### Why Are Migrations Important?

1. Track database structure changes.
2. Maintain consistent schemas across environments.
3. Support team development.
4. Allow controlled rollbacks.
5. Make deployment more predictable.

### Important

A rollback is not always perfectly safe.

For example, if you add a column, rollback can remove it. But if you delete a column containing important data, rolling back the schema does not automatically restore the lost data.

Always plan destructive migrations carefully.

---

# 21. SQL Injection Prevention

SQL injection occurs when untrusted input changes the structure or meaning of an SQL query.

### Vulnerable Example

```javascript
const email = req.body.email;

const password = req.body.password;

const query = `
    SELECT *
    FROM users
    WHERE email = '${email}'
    AND password = '${password}'
`;
```

An attacker may submit specially crafted input that changes the query's logic.

### Safe Approach

```javascript
const [rows] = await pool.execute(
    `
        SELECT *
        FROM users
        WHERE email = ?
        AND password_hash = ?
    `,
    [email, passwordHash]
);
```

This keeps user values separate from SQL syntax.

### Additional Security Practices

1. Always use parameterized queries.
2. Validate input.
3. Use database users with limited privileges.
4. Avoid exposing SQL error details.
5. Keep database credentials in environment variables or a secrets manager.
6. Never store plain-text passwords.
7. Hash passwords using an appropriate password-hashing algorithm such as Argon2id or bcrypt.
8. Restrict database network access.
9. Keep MySQL and dependencies updated.
10. Avoid dynamic SQL identifiers from untrusted input.

**Important:** Parameterized queries protect values. They do not automatically protect dynamically constructed table names, column names, or SQL keywords.

---

# 22. Environment Variables and Database Security

Never store database credentials directly in source code.

Incorrect:

```javascript
const config = {
    host: "localhost",
    user: "root",
    password: "mypassword"
};
```

Correct:

`.env`

```env
DB_HOST=localhost
DB_USER=app_user
DB_PASSWORD=StrongPassword@123
DB_NAME=company_db
DB_PORT=3306
```

Load:

```javascript
require("dotenv").config();
```

Access:

```javascript
process.env.DB_HOST;
process.env.DB_USER;
process.env.DB_PASSWORD;
```

### .gitignore

Add:

```gitignore
node_modules/
.env
```

This prevents accidental commits of local environment files.

### Production Security

For production:

- Use a dedicated database account.
- Use strong credentials.
- Restrict network access.
- Use TLS when appropriate.
- Use a secrets manager where available.
- Rotate credentials periodically.
- Grant only required privileges.

---

# 23. API Performance Optimization

Database performance affects backend API performance.

Consider these practices.

## 23.1 Avoid SELECT *

Instead of:

```sql
SELECT *
FROM employees;
```

Use:

```sql
SELECT
    id,
    name,
    department
FROM employees;
```

Retrieve only the required columns.

## 23.2 Use Indexes

If your application frequently searches employees by email:

```sql
CREATE UNIQUE INDEX idx_employee_email
ON employees(email);
```

This can improve lookup performance and enforce uniqueness.

## 23.3 Use Pagination

Avoid returning thousands of rows unnecessarily.

```sql
SELECT *
FROM employees
ORDER BY id DESC
LIMIT 20;
```

## 23.4 Use Connection Pooling

Reuse connections instead of creating a new connection for every request.

## 23.5 Avoid N+1 Queries

Suppose you retrieve 100 employees and then query each employee's department individually.

That could result in 101 database queries.

Instead, use JOIN:

```sql
SELECT
    e.id,
    e.name,
    d.department_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.id;
```

This can reduce unnecessary database round trips.

## 23.6 Use EXPLAIN

```sql
EXPLAIN
SELECT *
FROM employees
WHERE department = 'IT';
```

Inspect the execution plan and optimize based on actual query behavior.

## 23.7 Avoid Unnecessary Sequential Queries

If two independent queries do not depend on each other, you may execute them concurrently.

Example:

```javascript
const [employees, departments] = await Promise.all([
    pool.execute("SELECT * FROM employees"),
    pool.execute("SELECT * FROM departments")
]);
```

However, do not execute dependent operations concurrently, and do not use separate pooled connections for operations that must belong to one transaction.

## 23.8 Use Appropriate Data Types

For example:

- Use INT for integer identifiers.
- Use DECIMAL for monetary values.
- Use DATE for dates without time.
- Use DATETIME or TIMESTAMP where appropriate.
- Use VARCHAR with suitable lengths.

## 23.9 Avoid Excessive Database Calls

Instead of inserting 100 records using 100 separate requests, consider a bulk insert:

```javascript
const employees = [
    ["Rahul", "IT", 50000],
    ["Amit", "HR", 40000],
    ["Vijay", "Sales", 45000]
];

await pool.query(
    `
        INSERT INTO employees
        (name, department, salary)
        VALUES ?
    `,
    [employees]
);
```

This uses MySQL2's array formatting for a bulk insert.

For untrusted input, validate every row and understand the difference between `query()` formatting and server-side prepared statements.

---

# 24. Complete Project: Employee Management System

Now let's combine everything you have learned.

We will build an Employee Management System using:

- Node.js
- Express
- MySQL
- MySQL2
- dotenv

## Project Features

1. Create employee.
2. Get all employees.
3. Get employee by ID.
4. Update employee.
5. Delete employee.
6. Search employees.
7. Filter by department.
8. Filter by salary.
9. Pagination.
10. Department JOIN.
11. Transaction support.
12. Database connection pooling.
13. Error handling.
14. Parameterized queries.

### Database Schema

Create database:

```sql
CREATE DATABASE employee_management;

USE employee_management;
```

### Departments Table

```sql
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Employees Table

```sql
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,

    name VARCHAR(100) NOT NULL,

    email VARCHAR(150) NOT NULL UNIQUE,

    department_id INT,

    salary DECIMAL(10,2) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_employee_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON DELETE SET NULL
);
```

### Insert Departments

```sql
INSERT INTO departments (department_name)
VALUES
('IT'),
('HR'),
('Sales'),
('Marketing');
```

### Insert Employees

```sql
INSERT INTO employees (
    name,
    email,
    department_id,
    salary
)
VALUES
('Rahul', 'rahul@gmail.com', 1, 50000),
('Amit', 'amit@gmail.com', 2, 40000),
('Vijay', 'vijay@gmail.com', 1, 60000),
('Karan', 'karan@gmail.com', 3, 45000);
```

---

## 24.1 Complete Project Structure

```text
employee-management/
│
├── config/
│   └── db.js
│
├── controllers/
│   └── employeeController.js
│
├── routes/
│   └── employeeRoutes.js
│
├── middleware/
│   └── errorHandler.js
│
├── .env
├── .gitignore
├── server.js
└── package.json
```

## 24.2 Database Connection

`config/db.js`

```javascript
const mysql = require("mysql2/promise");

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: Number(process.env.DB_PORT) || 3306,

    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

module.exports = pool;
```

## 24.3 Employee Controller

`controllers/employeeController.js`

```javascript
const pool = require("../config/db");

// CREATE EMPLOYEE
exports.createEmployee = async (req, res, next) => {

    try {

        const {
            name,
            email,
            department_id,
            salary
        } = req.body;

        if (
            !name ||
            !email ||
            !Number.isFinite(Number(salary)) ||
            Number(salary) < 0
        ) {
            return res.status(400).json({
                success: false,
                message: "Invalid employee data"
            });
        }

        const [result] = await pool.execute(
            `
                INSERT INTO employees
                (name, email, department_id, salary)
                VALUES (?, ?, ?, ?)
            `,
            [
                name,
                email,
                department_id ?? null,
                salary
            ]
        );

        res.status(201).json({
            success: true,
            message: "Employee created",
            employeeId: result.insertId
        });

    } catch (error) {

        next(error);

    }

};


// GET ALL EMPLOYEES
exports.getEmployees = async (req, res, next) => {

    try {

        const page = Math.max(
            1,
            Number.parseInt(req.query.page, 10) || 1
        );

        const limit = Math.min(
            100,
            Math.max(
                1,
                Number.parseInt(req.query.limit, 10) || 10
            )
        );

        const offset = (page - 1) * limit;

        const [rows] = await pool.execute(
            `
                SELECT
                    e.id,
                    e.name,
                    e.email,
                    e.salary,
                    d.department_name
                FROM employees e
                LEFT JOIN departments d
                    ON e.department_id = d.id
                ORDER BY e.id DESC
                LIMIT ? OFFSET ?
            `,
            [limit, offset]
        );

        const [countRows] = await pool.execute(
            "SELECT COUNT(*) AS total FROM employees"
        );

        res.status(200).json({
            success: true,
            page,
            limit,
            total: countRows[0].total,
            data: rows
        });

    } catch (error) {

        next(error);

    }

};


// GET EMPLOYEE BY ID
exports.getEmployeeById = async (req, res, next) => {

    try {

        const id = Number(req.params.id);

        if (!Number.isInteger(id) || id <= 0) {
            return res.status(400).json({
                success: false,
                message: "Invalid employee ID"
            });
        }

        const [rows] = await pool.execute(
            `
                SELECT
                    e.*,
                    d.department_name
                FROM employees e
                LEFT JOIN departments d
                    ON e.department_id = d.id
                WHERE e.id = ?
            `,
            [id]
        );

        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: "Employee not found"
            });
        }

        res.status(200).json({
            success: true,
            data: rows[0]
        });

    } catch (error) {

        next(error);

    }

};


// UPDATE EMPLOYEE
exports.updateEmployee = async (req, res, next) => {

    try {

        const id = Number(req.params.id);

        const {
            name,
            email,
            department_id,
            salary
        } = req.body;

        if (
            !Number.isInteger(id) ||
            id <= 0 ||
            !name ||
            !email ||
            !Number.isFinite(Number(salary)) ||
            Number(salary) < 0
        ) {
            return res.status(400).json({
                success: false,
                message: "Invalid employee data"
            });
        }

        const [result] = await pool.execute(
            `
                UPDATE employees
                SET
                    name = ?,
                    email = ?,
                    department_id = ?,
                    salary = ?
                WHERE id = ?
            `,
            [
                name,
                email,
                department_id ?? null,
                salary,
                id
            ]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: "Employee not found"
            });
        }

        res.status(200).json({
            success: true,
            message: "Employee updated successfully"
        });

    } catch (error) {

        next(error);

    }

};


// DELETE EMPLOYEE
exports.deleteEmployee = async (req, res, next) => {

    try {

        const id = Number(req.params.id);

        if (!Number.isInteger(id) || id <= 0) {
            return res.status(400).json({
                success: false,
                message: "Invalid employee ID"
            });
        }

        const [result] = await pool.execute(
            "DELETE FROM employees WHERE id = ?",
            [id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: "Employee not found"
            });
        }

        res.status(200).json({
            success: true,
            message: "Employee deleted successfully"
        });

    } catch (error) {

        next(error);

    }

};


// SEARCH EMPLOYEES
exports.searchEmployees = async (req, res, next) => {

    try {

        const search = String(req.query.search || "");

        const [rows] = await pool.execute(
            `
                SELECT *
                FROM employees
                WHERE name LIKE ?
                ORDER BY id DESC
            `,
            [`%${search}%`]
        );

        res.status(200).json({
            success: true,
            data: rows
        });

    } catch (error) {

        next(error);

    }

};


// FILTER BY DEPARTMENT
exports.getEmployeesByDepartment = async (req, res, next) => {

    try {

        const departmentId = Number(req.params.departmentId);

        if (!Number.isInteger(departmentId) || departmentId <= 0) {
            return res.status(400).json({
                success: false,
                message: "Invalid department ID"
            });
        }

        const [rows] = await pool.execute(
            `
                SELECT *
                FROM employees
                WHERE department_id = ?
            `,
            [departmentId]
        );

        res.status(200).json({
            success: true,
            data: rows
        });

    } catch (error) {

        next(error);

    }

};
```

**Implementation note:** In this example, `affectedRows === 0` is treated as not found for UPDATE. If an UPDATE matches a row but sets its values to exactly their existing values, MySQL2's result behavior can depend on connection configuration. For a production API requiring an exact existence check, perform a separate existence query or configure and handle affected-row semantics explicitly.

## 24.4 Routes

`routes/employeeRoutes.js`

```javascript
const express = require("express");

const router = express.Router();

const controller = require("../controllers/employeeController");

router.post("/", controller.createEmployee);

router.get("/", controller.getEmployees);

router.get("/search", controller.searchEmployees);

router.get(
    "/department/:departmentId",
    controller.getEmployeesByDepartment
);

router.get("/:id", controller.getEmployeeById);

router.put("/:id", controller.updateEmployee);

router.delete("/:id", controller.deleteEmployee);

module.exports = router;
```

## 24.5 Error Handling Middleware

`middleware/errorHandler.js`

```javascript
module.exports = (error, req, res, next) => {

    console.error(error);

    if (error.code === "ER_DUP_ENTRY") {

        return res.status(409).json({
            success: false,
            message: "Email already exists"
        });

    }

    if (error.code === "ER_NO_REFERENCED_ROW_2") {

        return res.status(400).json({
            success: false,
            message: "Invalid department"
        });

    }

    return res.status(500).json({
        success: false,
        message: "Internal server error"
    });

};
```

## 24.6 Main Server

`server.js`

```javascript
require("dotenv").config();

const express = require("express");

const pool = require("./config/db");

const employeeRoutes = require("./routes/employeeRoutes");

const errorHandler = require("./middleware/errorHandler");

const app = express();

app.use(express.json());

app.use("/api/employees", employeeRoutes);

app.get("/", (req, res) => {

    res.send("Employee Management API is running");

});

app.use(errorHandler);

async function startServer() {

    try {

        await pool.query("SELECT 1");

        console.log("Database connected successfully");

        const PORT = process.env.PORT || 5000;

        app.listen(PORT, () => {

            console.log(`Server running on port ${PORT}`);

        });

    } catch (error) {

        console.error("Unable to connect to database:", error);

        process.exit(1);

    }

}

startServer();
```

---

# 25. Complete API Testing

You can test the project using Postman, Thunder Client, or another API client.

| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/employees` | Create employee |
| GET | `/api/employees` | Get employees |
| GET | `/api/employees?page=1&limit=10` | Paginated employees |
| GET | `/api/employees/search?search=Rahul` | Search employees |
| GET | `/api/employees/department/1` | Filter by department |
| GET | `/api/employees/1` | Get employee by ID |
| PUT | `/api/employees/1` | Update employee |
| DELETE | `/api/employees/1` | Delete employee |

### Example Request: Create Employee

```json
{
    "name": "Riyaz Khan",
    "email": "riyaz@example.com",
    "department_id": 1,
    "salary": 85000
}
```

### Example Request: Update Employee

```json
{
    "name": "Riyaz Khan",
    "email": "riyaz@example.com",
    "department_id": 2,
    "salary": 90000
}
```

---

# 26. Additional Advanced Topics to Explore

You have now covered the essential SQL-to-Node.js integration workflow.

For professional backend development, continue exploring these topics:

| Topic | What You Should Learn |
|---|---|
| Read Replicas | Distribute read workloads across database servers |
| Database Replication | Maintain copies of data across MySQL servers |
| High Availability | Keep database services available during failures |
| Connection Pool Monitoring | Monitor active, idle and waiting connections |
| Deadlock Retry | Safely retry transactions after deadlocks |
| Idempotency | Prevent duplicate processing of requests |
| Query Caching | Cache frequently requested results |
| Database Migrations | Version and deploy schema changes |
| Database Seeding | Populate development and test databases |
| Soft Deletes | Mark records as deleted instead of physically removing them |
| Audit Logging | Track important data changes |
| Database Sharding | Distribute data across multiple database servers |
| TLS Connections | Encrypt application-to-database communication |
| Database Observability | Monitor query performance, errors and resource usage |

---

# 27. Interview Questions and Answers

### Q1. How do you connect Node.js with MySQL?

Using a MySQL driver such as `mysql2`.

### Q2. What is MySQL2?

A Node.js package that provides MySQL database connectivity, including callback-based and Promise-based APIs.

### Q3. What is connection pooling?

Connection pooling maintains reusable database connections to avoid repeatedly creating new connections.

### Q4. What is the difference between createConnection and createPool?

`createConnection()` creates one connection. `createPool()` manages multiple reusable connections.

### Q5. What is the difference between query and execute in MySQL2?

`query()` executes queries and supports client-side placeholder formatting. `execute()` uses server-side prepared statements.

### Q6. What is a parameterized query?

A query where input values are supplied separately from the SQL statement using placeholders.

### Q7. Why are parameterized queries important?

They help prevent SQL injection by separating data from SQL syntax.

### Q8. What is SQL injection?

An attack in which untrusted input changes the intended SQL query.

### Q9. Why do we use connection.release()?

It returns a borrowed pooled connection to the pool for reuse.

### Q10. Why should transactions use the same connection?

A transaction belongs to a specific database session. Using different connections would separate its operations into different transactions.

### Q11. What is the difference between Raw SQL and ORM?

Raw SQL involves writing SQL directly. An ORM maps database records to application objects and provides abstraction over SQL operations.

### Q12. What is Sequelize?

A Node.js ORM that supports relational databases, including MySQL.

### Q13. What is a database migration?

A version-controlled change to the database schema or data.

### Q14. What is the N+1 query problem?

A performance problem where an application executes one query to fetch parent records and then additional queries for each related record.

### Q15. What is pagination?

Pagination divides a large result set into smaller pages.

### Q16. What is keyset pagination?

A pagination technique that uses the last-seen ordering key instead of a large OFFSET.

### Q17. What is the difference between COMMIT and ROLLBACK?

COMMIT permanently saves the transaction's changes. ROLLBACK discards uncommitted changes.

### Q18. What is the purpose of environment variables?

They separate configuration and sensitive values from application source code.

### Q19. Why should you not use the root database user in an application?

Because root has extensive administrative permissions. A compromised application could damage the entire database server.

### Q20. How do you improve MySQL API performance?

Use appropriate indexes, connection pooling, pagination, optimized JOINs, parameterized queries, and query-plan analysis.

---

# 28. Final Practical Assignments

Complete these assignments to verify your SQL and Node.js knowledge.

## Assignment 1: Database Connection

1. Install MySQL2.
2. Connect Node.js to MySQL.
3. Create a connection pool.
4. Execute SELECT queries.
5. Handle connection errors.
6. Release pooled connections correctly.

## Assignment 2: CRUD API

Create APIs for:

1. Create employee.
2. Retrieve employees.
3. Retrieve employee by ID.
4. Update employee.
5. Delete employee.

## Assignment 3: Advanced Queries

Implement APIs using:

1. INNER JOIN.
2. LEFT JOIN.
3. GROUP BY.
4. HAVING.
5. Subqueries.
6. CTEs.
7. Window functions.

## Assignment 4: Filtering and Pagination

Implement:

1. Search by employee name.
2. Filter by department.
3. Filter by salary range.
4. Sort by salary.
5. Pagination using LIMIT and OFFSET.
6. Keyset pagination.

## Assignment 5: Transactions

Build a banking transfer API.

Requirements:

1. Accept sender ID.
2. Accept receiver ID.
3. Accept transfer amount.
4. Validate balance.
5. Lock required account rows.
6. Debit sender.
7. Credit receiver.
8. Commit transaction.
9. Roll back on failure.
10. Handle deadlocks safely.

## Assignment 6: Stored Procedures

1. Create a stored procedure.
2. Call it from Node.js.
3. Use IN parameters.
4. Use OUT parameters.
5. Handle procedure errors.

## Assignment 7: Sequelize

1. Create Sequelize configuration.
2. Create Employee model.
3. Create Department model.
4. Define associations.
5. Implement CRUD operations.
6. Create migrations.
7. Compare generated SQL with raw SQL.

## Assignment 8: Complete Project

Build a complete Employee Management System.

Required features:

- Authentication.
- User roles.
- Employee CRUD.
- Department management.
- Attendance management.
- Salary management.
- Search and filters.
- Pagination.
- Reporting.
- Transactions.
- Audit logs.
- Database migrations.
- Error handling.
- Secure database configuration.

---

# 29. SQL Roadmap – Final Revision

Congratulations! You have now completed all 25 phases of the SQL learning roadmap.

Here is the complete roadmap for revision.

| Phase | Topic | Status |
|---|---|---|
| 1 | Introduction to Databases and SQL | Covered |
| 2 | Installing and Setting Up MySQL | Covered |
| 3 | Database and Table Operations | Covered |
| 4 | SQL Data Types | Covered |
| 5 | CRUD Operations | Covered |
| 6 | SQL Operators | Covered |
| 7 | SQL Constraints | Roadmap topic; not separately completed |
| 8 | Aggregate Functions | Roadmap topic; not separately completed |
| 9 | GROUP BY and HAVING | Covered |
| 10 | SQL Joins | Covered |
| 11 | Subqueries | Covered |
| 12 | SQL Functions | Roadmap topic; not separately completed |
| 13 | Set Operations | Roadmap topic; not separately completed |
| 14 | Common Table Expressions | Covered |
| 15 | Window Functions | Covered |
| 16 | Database Design and Relationships | Covered |
| 17 | Database Normalization | Covered |
| 18 | Indexing and Query Optimization | Covered |
| 19 | Transactions and ACID Properties | Covered |
| 20 | Concurrency Control and Locking | Covered |
| 21 | Transaction Isolation Levels | Covered |
| 22 | Stored Procedures, Functions and Triggers | Covered |
| 23 | Views and Temporary Tables | Covered |
| 24 | Advanced Database Management | Covered |
| 25 | SQL Integration with Node.js | Covered |

**Important:** Phases 7, 8, 12 and 13 were not separately completed in your learning sequence. You should cover them before considering the entire roadmap fully mastered.

---

# 30. What Should You Build After Completing SQL?

I recommend building these projects in increasing order of complexity.

| Level | Project | Important SQL Concepts |
|---|---|---|
| Beginner | Student Management System | CRUD, constraints, joins |
| Beginner | Expense Tracker | Aggregates, GROUP BY |
| Intermediate | Employee Management System | Relationships, joins, transactions |
| Intermediate | Library Management System | Foreign keys, transactions |
| Intermediate | Inventory Management System | Transactions, locking |
| Advanced | E-commerce Database | Complex joins, indexing, CTEs |
| Advanced | Hospital Management System | Relationships, transactions, reporting |
| Advanced | Banking Management System | ACID, locking, isolation |
| Professional | Analytics Dashboard | Window functions, optimization, reporting |
| Professional | Full Backend Application | Node.js, Express, MySQL, Sequelize |

---

# 31. Final SQL Skills Checklist

Before moving to advanced backend development, make sure you can:

**SQL Fundamentals**
- [ ] Create and manage databases.
- [ ] Create and modify tables.
- [ ] Understand SQL data types.
- [ ] Perform CRUD operations.
- [ ] Use SQL operators.
- [ ] Apply constraints.

**Query Writing**
- [ ] Write aggregate queries.
- [ ] Use GROUP BY and HAVING.
- [ ] Understand all JOIN types.
- [ ] Write subqueries.
- [ ] Use SQL functions.
- [ ] Understand UNION and other set operations.
- [ ] Write CTEs.
- [ ] Use recursive CTEs.
- [ ] Write window functions.

**Database Design**
- [ ] Design relational schemas.
- [ ] Understand primary and foreign keys.
- [ ] Design one-to-one relationships.
- [ ] Design one-to-many relationships.
- [ ] Design many-to-many relationships.
- [ ] Apply normalization.
- [ ] Understand denormalization.

**Advanced SQL**
- [ ] Optimize queries.
- [ ] Understand indexing.
- [ ] Use EXPLAIN and EXPLAIN ANALYZE.
- [ ] Understand transactions.
- [ ] Understand ACID properties.
- [ ] Understand concurrency and locking.
- [ ] Understand isolation levels.
- [ ] Create stored procedures.
- [ ] Create stored functions.
- [ ] Create triggers.
- [ ] Use views and temporary tables.

**Database Management**
- [ ] Manage MySQL users.
- [ ] Manage permissions.
- [ ] Create database backups.
- [ ] Restore databases.
- [ ] Use the Event Scheduler.
- [ ] Understand partitioning.
- [ ] Use generated columns.
- [ ] Understand JSON operations.
- [ ] Monitor MySQL performance.

**Node.js Integration**
- [ ] Connect Node.js with MySQL.
- [ ] Use MySQL2.
- [ ] Implement connection pooling.
- [ ] Write parameterized queries.
- [ ] Build CRUD APIs.
- [ ] Implement transactions.
- [ ] Integrate stored procedures.
- [ ] Use Sequelize.
- [ ] Implement migrations.
- [ ] Prevent SQL injection.

---

## SQL Roadmap Completed!

You have reached the end of the 25-phase roadmap.

**My recommendation:** Before moving to another technology, practice SQL by building an Employee Management System and an E-commerce Database using MySQL and Node.js.

Also, revisit the four skipped phases (7, 8, 12 and 13). They contain important foundational SQL concepts that will strengthen your overall understanding.