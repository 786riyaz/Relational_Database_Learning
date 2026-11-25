# SQL Complete Learning Roadmap
# Phase 7 – SQL Constraints

**Database:** MySQL 8.0+  
**Level:** Beginner to Advanced  
**Goal:** Understand how to enforce data integrity and maintain relationships between database tables.

---

# 1. What Are SQL Constraints?

SQL constraints are rules applied to table columns or tables to control what kind of data can be inserted, updated, or stored.

They help maintain **data integrity, accuracy, consistency, and reliability**.

For example, consider an employee table:

| id | name | email | age | salary |
|---:|---|---|---:|---:|
| 1 | John | john@example.com | 25 | 50000 |
| 2 | Sarah | sarah@example.com | 28 | 60000 |

Now consider these situations:

- An employee should always have a name.
- Two employees should not have the same email.
- Employee age should not be negative.
- Salary should be greater than zero.
- Every employee should belong to a valid department.

SQL constraints help enforce these rules directly at the database level.

### Types of SQL Constraints

| Constraint | Purpose |
|---|---|
| NOT NULL | Prevents NULL values |
| UNIQUE | Prevents duplicate values |
| PRIMARY KEY | Uniquely identifies each row |
| FOREIGN KEY | Establishes relationships between tables |
| CHECK | Validates values against a condition |
| DEFAULT | Provides a default value |
| AUTO_INCREMENT | Automatically generates numeric values |

**Important:** Constraints can be defined when creating a table or added later using `ALTER TABLE`.

---

# 2. NOT NULL Constraint

The `NOT NULL` constraint ensures that a column cannot contain a NULL value.

### Syntax

```sql
CREATE TABLE employees (
    id INT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150)
);
```

Here:

- `id` can contain NULL.
- `name` cannot contain NULL.
- `email` can contain NULL.

### Valid INSERT

```sql
INSERT INTO employees (id, name, email)
VALUES (1, 'John', 'john@example.com');
```

### Invalid INSERT

```sql
INSERT INTO employees (id, email)
VALUES (2, 'sarah@example.com');
```

This fails because `name` is NOT NULL and no default value has been defined.

### Can We Insert an Empty String?

Yes.

```sql
INSERT INTO employees (id, name)
VALUES (3, '');
```

This is valid because an empty string (`''`) is not NULL.

**Important distinction:**

| Value | Meaning |
|---|---|
| NULL | No value / unknown value |
| `''` | Empty string |
| `0` | Numeric zero |
| `' '` | String containing a space |

NOT NULL prevents NULL values, not empty strings or zero.

### Adding NOT NULL to an Existing Column

```sql
ALTER TABLE employees
MODIFY COLUMN name VARCHAR(100) NOT NULL;
```

Before doing this, check whether existing records contain NULL values.

```sql
SELECT *
FROM employees
WHERE name IS NULL;
```

If NULL values exist, update them before adding the constraint.

### Removing NOT NULL

MySQL requires redefining the column without `NOT NULL`.

```sql
ALTER TABLE employees
MODIFY COLUMN name VARCHAR(100) NULL;
```

---

# 3. UNIQUE Constraint

The `UNIQUE` constraint ensures that values in a column are not duplicated.

For example, every employee should have a unique email address.

### Syntax

```sql
CREATE TABLE employees (
    id INT,
    name VARCHAR(100),
    email VARCHAR(150) UNIQUE
);
```

### Valid INSERT

```sql
INSERT INTO employees (id, name, email)
VALUES
(1, 'John', 'john@example.com'),
(2, 'Sarah', 'sarah@example.com');
```

### Invalid INSERT

```sql
INSERT INTO employees (id, name, email)
VALUES (3, 'David', 'john@example.com');
```

This fails because `john@example.com` already exists.

### Named UNIQUE Constraint

You can assign a name to a constraint.

```sql
CREATE TABLE employees (
    id INT,
    name VARCHAR(100),
    email VARCHAR(150),

    CONSTRAINT unique_employee_email UNIQUE (email)
);
```

Naming constraints makes database management easier.

### UNIQUE on Multiple Columns

You can create a composite UNIQUE constraint.

```sql
CREATE TABLE course_enrollments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,

    UNIQUE (student_id, course_id)
);
```

This ensures that the same student cannot enroll in the same course more than once.

However, the following records are valid:

| student_id | course_id |
|---:|---:|
| 1 | 101 |
| 1 | 102 |
| 2 | 101 |

The combination must be unique, not each individual column.

### Important: UNIQUE and NULL

In MySQL, a UNIQUE constraint generally allows multiple NULL values.

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(150) UNIQUE
);
```

These records are allowed:

```sql
INSERT INTO users (email)
VALUES
('john@example.com'),
(NULL),
(NULL);
```

But duplicate non-NULL email addresses are not allowed.

---

# 4. PRIMARY KEY Constraint

A PRIMARY KEY uniquely identifies every record in a table.

Every properly designed relational table should generally have a primary key.

### Example

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150)
);
```

Here, `id` is the primary key.

### Primary Key Rules

1. A table can have only one PRIMARY KEY constraint.
2. A primary key cannot contain NULL.
3. Primary key values must be unique.
4. A primary key can contain one or multiple columns.
5. MySQL automatically creates a unique index for a primary key.

### Valid INSERT

```sql
INSERT INTO employees (id, name, email)
VALUES (1, 'John', 'john@example.com');
```

### Invalid: Duplicate Primary Key

```sql
INSERT INTO employees (id, name, email)
VALUES (1, 'Sarah', 'sarah@example.com');
```

This fails because ID `1` already exists.

### Invalid: NULL Primary Key

```sql
INSERT INTO employees (id, name, email)
VALUES (NULL, 'David', 'david@example.com');
```

This also fails.

### Named Primary Key

```sql
CREATE TABLE employees (
    id INT,
    name VARCHAR(100),

    CONSTRAINT pk_employees PRIMARY KEY (id)
);
```

### Adding Primary Key to an Existing Table

```sql
ALTER TABLE employees
ADD CONSTRAINT pk_employees PRIMARY KEY (id);
```

Before adding it, ensure:

- No duplicate IDs exist.
- No NULL IDs exist.

### Removing Primary Key

```sql
ALTER TABLE employees
DROP PRIMARY KEY;
```

Be careful: if other tables reference this primary key, you may need to remove or modify those foreign key relationships first.

---

# 5. FOREIGN KEY Constraint

A FOREIGN KEY establishes a relationship between two tables.

It ensures that a value in one table references an existing record in another table.

This is called **referential integrity**.

### Real-World Example

Suppose we have two tables:

**departments**

| id | department_name |
|---:|---|
| 1 | IT |
| 2 | HR |
| 3 | Finance |

**employees**

| id | name | department_id |
|---:|---|---:|
| 101 | John | 1 |
| 102 | Sarah | 2 |
| 103 | David | 1 |

Here:

- `departments.id` is the parent key.
- `employees.department_id` is the foreign key.
- One department can have multiple employees.

### Creating Parent Table

```sql
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL
);
```

### Creating Child Table

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    department_id INT,

    FOREIGN KEY (department_id)
    REFERENCES departments(id)
);
```

### Insert Parent Records

```sql
INSERT INTO departments (department_name)
VALUES
('IT'),
('HR'),
('Finance');
```

### Insert Child Records

```sql
INSERT INTO employees (name, department_id)
VALUES
('John', 1),
('Sarah', 2),
('David', 1);
```

These inserts work because departments `1` and `2` exist.

### Invalid INSERT

```sql
INSERT INTO employees (name, department_id)
VALUES ('Alex', 99);
```

This fails because department `99` does not exist.

### What If department_id Is NULL?

This is valid if the column allows NULL.

```sql
INSERT INTO employees (name, department_id)
VALUES ('Alex', NULL);
```

A NULL foreign key does not need to reference a parent record.

If every employee must belong to a department, define the column as NOT NULL:

```sql
department_id INT NOT NULL
```

### Important Foreign Key Requirements in MySQL

For typical MySQL InnoDB foreign keys:

1. Both tables should use the InnoDB storage engine.
2. Referencing and referenced columns must have compatible data types.
3. Integer columns should match in size and signedness.
4. String columns should have compatible character sets and collations.
5. Referenced columns must be indexed appropriately. A PRIMARY KEY or UNIQUE key is the preferred design.
6. The parent table must exist when creating the foreign key.

**Recommended practice:** Reference a parent's PRIMARY KEY rather than an arbitrary column.

---

# 6. CHECK Constraint

The CHECK constraint validates data against a specified condition.

It ensures that inserted or updated values satisfy a logical expression.

### Example: Age Validation

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    age INT CHECK (age >= 18)
);
```

Valid:

```sql
INSERT INTO employees (name, age)
VALUES ('John', 25);
```

Invalid:

```sql
INSERT INTO employees (name, age)
VALUES ('David', 15);
```

The second query fails because age must be at least 18.

### Multiple CHECK Constraints

```sql
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    price DECIMAL(10,2) CHECK (price > 0),
    stock INT CHECK (stock >= 0)
);
```

### Named CHECK Constraint

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    age INT,

    CONSTRAINT chk_employee_age
    CHECK (age >= 18)
);
```

### CHECK with BETWEEN

```sql
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    marks INT CHECK (marks BETWEEN 0 AND 100)
);
```

### CHECK with Multiple Conditions

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    age INT,
    salary DECIMAL(10,2),

    CONSTRAINT chk_employee_details
    CHECK (age >= 18 AND salary > 0)
);
```

### Adding CHECK to an Existing Table

```sql
ALTER TABLE employees
ADD CONSTRAINT chk_salary
CHECK (salary > 0);
```

### Removing CHECK

```sql
ALTER TABLE employees
DROP CHECK chk_salary;
```

### Important MySQL Version Note

MySQL versions before **8.0.16** parsed CHECK constraints but did not enforce them.

MySQL 8.0.16 and later enforce CHECK constraints by default.

Therefore, use MySQL 8.0.16+ if you want reliable CHECK enforcement.

### Important: CHECK and NULL

A CHECK condition does not automatically make a column NOT NULL.

For example:

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    age INT CHECK (age >= 18)
);
```

A NULL age can still be inserted because the CHECK condition evaluates to UNKNOWN rather than FALSE.

If age is mandatory:

```sql
age INT NOT NULL CHECK (age >= 18)
```

---

# 7. DEFAULT Constraint

The DEFAULT constraint provides a predefined value when an INSERT statement does not supply a value for that column.

### Example

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    country VARCHAR(50) DEFAULT 'India'
);
```

### Insert Without Default Columns

```sql
INSERT INTO employees (name)
VALUES ('John');
```

Result:

| id | name | status | country |
|---:|---|---|---|
| 1 | John | Active | India |

MySQL automatically uses the default values.

### Explicitly Providing a Value

```sql
INSERT INTO employees (name, status)
VALUES ('Sarah', 'Inactive');
```

The provided value overrides the default.

### DEFAULT vs NULL

Consider:

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    status VARCHAR(20) DEFAULT 'Active'
);
```

**Case 1: Column omitted**

```sql
INSERT INTO users (name)
VALUES ('John');
```

Result: `status = 'Active'`

**Case 2: Explicit NULL**

```sql
INSERT INTO users (name, status)
VALUES ('Sarah', NULL);
```

Result: `status = NULL`

The DEFAULT value is not automatically used when you explicitly insert NULL.

### DEFAULT with NOT NULL

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active'
);
```

Here:

- Omitting status gives `'Active'`.
- Explicitly inserting NULL fails.

### Changing DEFAULT

```sql
ALTER TABLE users
ALTER COLUMN status SET DEFAULT 'Pending';
```

Removing DEFAULT:

```sql
ALTER TABLE users
ALTER COLUMN status DROP DEFAULT;
```

---

# 8. AUTO_INCREMENT Constraint

AUTO_INCREMENT automatically generates sequential numeric values when a new record is inserted without providing an explicit value for that column.

It is commonly used for primary keys.

### Example

```sql
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);
```

### Insert Records

```sql
INSERT INTO employees (name)
VALUES
('John'),
('Sarah'),
('David');
```

Result:

| id | name |
|---:|---|
| 1 | John |
| 2 | Sarah |
| 3 | David |

You do not need to provide IDs manually.

### Insert Explicit ID

```sql
INSERT INTO employees (id, name)
VALUES (100, 'Alex');
```

MySQL accepts this explicit value if it does not violate a key constraint.

The next generated value will normally be greater than the current AUTO_INCREMENT counter.

### Check AUTO_INCREMENT Value

```sql
SHOW TABLE STATUS LIKE 'employees';
```

Look at the `Auto_increment` column.

You can also inspect the table definition:

```sql
SHOW CREATE TABLE employees;
```

### Change AUTO_INCREMENT Starting Value

```sql
ALTER TABLE employees AUTO_INCREMENT = 1000;
```

The next generated value will be at least 1000, assuming the existing maximum ID is lower.

### Important AUTO_INCREMENT Rules

1. A table can have only one AUTO_INCREMENT column.
2. The column must be indexed.
3. It is commonly used with a PRIMARY KEY.
4. It generally works with integer types.
5. You can explicitly insert values.
6. Generated IDs are not guaranteed to be continuous.

### Why Can IDs Have Gaps?

Consider:

```sql
INSERT INTO employees (name)
VALUES ('John');
```

Suppose the generated ID is `1`.

Now an insert operation attempts to create another record but fails or gets rolled back.

The next successful insert might receive ID `3`.

Therefore, you may see:

| id | name |
|---:|---|
| 1 | John |
| 3 | Sarah |

**Important:** Never assume AUTO_INCREMENT values will be gapless.

---

# 9. Composite Primary Key

A composite primary key consists of two or more columns that together uniquely identify a record.

It is useful when no single column can uniquely identify a row.

### Example: Student Course Enrollment

Suppose students can enroll in multiple courses.

**enrollments**

| student_id | course_id | enrollment_date |
|---:|---:|---|
| 1 | 101 | 2026-01-10 |
| 1 | 102 | 2026-01-11 |
| 2 | 101 | 2026-01-12 |

Here:

- A student can enroll in multiple courses.
- A course can have multiple students.
- The combination of student ID and course ID should be unique.

### Creating Table

```sql
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    enrollment_date DATE,

    PRIMARY KEY (student_id, course_id)
);
```

### Valid INSERT

```sql
INSERT INTO enrollments
(student_id, course_id, enrollment_date)
VALUES
(1, 101, '2026-01-10'),
(1, 102, '2026-01-11'),
(2, 101, '2026-01-12');
```

### Invalid INSERT

```sql
INSERT INTO enrollments
(student_id, course_id, enrollment_date)
VALUES
(1, 101, '2026-01-15');
```

This fails because `(1, 101)` already exists.

### Composite Primary Key Rules

- Each individual column can contain duplicate values.
- The combination must be unique.
- Every column participating in a primary key must be NOT NULL.
- Column order matters for the index created by the primary key.

### Composite Primary Key vs Single Primary Key

| Single Primary Key | Composite Primary Key |
|---|---|
| Uses one column | Uses multiple columns |
| Simple identification | Combination identifies record |
| Example: employee_id | Example: student_id + course_id |
| Common in most tables | Common in junction tables |

**Practical advice:** Composite primary keys are useful, but many application designs use a separate AUTO_INCREMENT ID plus a composite UNIQUE constraint.

Example:

```sql
CREATE TABLE enrollments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,

    UNIQUE (student_id, course_id)
);
```

This provides a simple ID while still preventing duplicate enrollments.

---

# 10. Multiple Constraints on a Column

You can apply multiple constraints to a single column.

### Example

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,

    name VARCHAR(100) NOT NULL,

    email VARCHAR(150) NOT NULL UNIQUE,

    age INT NOT NULL CHECK (age >= 18),

    salary DECIMAL(10,2) NOT NULL DEFAULT 25000
);
```

Here:

| Column | Constraints |
|---|---|
| id | PRIMARY KEY, AUTO_INCREMENT |
| name | NOT NULL |
| email | NOT NULL, UNIQUE |
| age | NOT NULL, CHECK |
| salary | NOT NULL, DEFAULT |

### Why Use Multiple Constraints?

Because each constraint solves a different problem.

For example:

```sql
email VARCHAR(150) NOT NULL UNIQUE
```

- NOT NULL prevents missing email addresses.
- UNIQUE prevents duplicate email addresses.

Both are necessary if every employee must have a unique email.

---

# 11. Referential Integrity

Referential integrity ensures that relationships between tables remain valid.

It is primarily enforced using FOREIGN KEY constraints.

Consider:

**departments**

| id | name |
|---:|---|
| 1 | IT |
| 2 | HR |

**employees**

| id | name | department_id |
|---:|---|---:|
| 101 | John | 1 |
| 102 | Sarah | 2 |

If department `1` is referenced by an employee, the database must handle any attempt to delete department `1` according to the foreign key's configured rules.

This is where referential actions become important.

---

# 12. ON DELETE CASCADE

ON DELETE CASCADE automatically deletes child records when their referenced parent record is deleted.

### Example

```sql
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    department_id INT,

    CONSTRAINT fk_employee_department
    FOREIGN KEY (department_id)
    REFERENCES departments(id)
    ON DELETE CASCADE
);
```

### Insert Data

```sql
INSERT INTO departments (name)
VALUES ('IT'), ('HR');

INSERT INTO employees (name, department_id)
VALUES
('John', 1),
('Sarah', 1),
('David', 2);
```

### Delete Parent Record

```sql
DELETE FROM departments
WHERE id = 1;
```

What happens?

Department `1` is deleted.

All employees whose `department_id = 1` are also deleted automatically.

Before:

**departments**

| id | name |
|---:|---|
| 1 | IT |
| 2 | HR |

**employees**

| id | name | department_id |
|---:|---|---:|
| 1 | John | 1 |
| 2 | Sarah | 1 |
| 3 | David | 2 |

After deleting department `1`:

**departments**

| id | name |
|---:|---|
| 2 | HR |

**employees**

| id | name | department_id |
|---:|---|---:|
| 3 | David | 2 |

John and Sarah are deleted automatically.

### When to Use CASCADE?

Useful examples:

- Deleting an order and its order items.
- Deleting a blog post and its comments.
- Deleting a parent record and dependent records that have no independent meaning.

**Warning:** CASCADE can delete many records. Use it only when deleting child records is genuinely intended.

---

# 13. ON UPDATE CASCADE

ON UPDATE CASCADE automatically updates child foreign key values when the referenced parent key changes.

### Example

```sql
CREATE TABLE departments (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,

    FOREIGN KEY (department_id)
    REFERENCES departments(id)
    ON UPDATE CASCADE
);
```

### Insert Records

```sql
INSERT INTO departments
VALUES
(1, 'IT'),
(2, 'HR');

INSERT INTO employees
VALUES
(101, 'John', 1),
(102, 'Sarah', 2);
```

### Update Parent ID

```sql
UPDATE departments
SET id = 10
WHERE id = 1;
```

The employee records referencing department `1` will automatically be updated to reference department `10`.

Before:

| employee_id | name | department_id |
|---:|---|---:|
| 101 | John | 1 |

After:

| employee_id | name | department_id |
|---:|---|---:|
| 101 | John | 10 |

**Practical advice:** Primary keys should normally be stable and should not need to change. ON UPDATE CASCADE is useful when referenced keys are genuinely mutable.

---

# 14. ON DELETE SET NULL

ON DELETE SET NULL sets the child foreign key column to NULL when its referenced parent record is deleted.

Unlike CASCADE, it does not delete the child record.

### Example

```sql
CREATE TABLE departments (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT NULL,

    FOREIGN KEY (department_id)
    REFERENCES departments(id)
    ON DELETE SET NULL
);
```

### Insert Data

```sql
INSERT INTO departments
VALUES
(1, 'IT'),
(2, 'HR');

INSERT INTO employees
VALUES
(101, 'John', 1),
(102, 'Sarah', 2);
```

### Delete Parent

```sql
DELETE FROM departments
WHERE id = 1;
```

Result:

| id | name | department_id |
|---:|---|---:|
| 101 | John | NULL |
| 102 | Sarah | 2 |

John still exists, but no longer belongs to a department.

### Important Rule

The child foreign key column must allow NULL.

This will not work as intended:

```sql
department_id INT NOT NULL
```

Use:

```sql
department_id INT NULL
```

**When to use it?**

- An employee may remain in the system after their department is deleted.
- A customer may remain even if an optional category is deleted.
- A record should survive without its previous parent association.

---

# 15. ON DELETE RESTRICT

RESTRICT prevents deletion of a parent record if child records reference it.

This is a common choice when parent records must not be deleted while dependent records exist.

### Example

```sql
CREATE TABLE departments (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,

    FOREIGN KEY (department_id)
    REFERENCES departments(id)
    ON DELETE RESTRICT
);
```

### Insert Data

```sql
INSERT INTO departments
VALUES (1, 'IT');

INSERT INTO employees
VALUES (101, 'John', 1);
```

### Try to Delete Parent

```sql
DELETE FROM departments
WHERE id = 1;
```

This fails because employee `101` references department `1`.

### What Is NO ACTION?

You may also see:

```sql
ON DELETE NO ACTION
```

In MySQL InnoDB, `NO ACTION` behaves effectively like `RESTRICT`.

### Referential Actions Comparison

| Action | What happens when parent is deleted? |
|---|---|
| CASCADE | Child records are deleted |
| SET NULL | Child foreign key becomes NULL |
| RESTRICT | Parent deletion is rejected if children exist |
| NO ACTION | Effectively RESTRICT in InnoDB |

**Note:** InnoDB does not support `SET DEFAULT` as a usable foreign key action.

---

# 16. PRIMARY KEY vs UNIQUE KEY

Both PRIMARY KEY and UNIQUE enforce uniqueness, but they have important differences.

| Feature | PRIMARY KEY | UNIQUE |
|---|---|---|
| Uniqueness | Yes | Yes |
| NULL allowed | No | Yes, generally multiple NULLs in MySQL |
| Number per table | One | Multiple |
| Identifies each row | Yes | Not necessarily |
| Automatically creates index | Yes | Yes |
| Can be composite | Yes | Yes |
| Common usage | Record identification | Prevent duplicate values |

### Example

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) UNIQUE,
    email VARCHAR(150) UNIQUE
);
```

Here:

- `id` identifies each user.
- `username` must be unique.
- `email` must be unique.

You cannot define two separate primary keys in one table.

However, you can define multiple UNIQUE constraints.

---

# 17. Adding and Removing Constraints Using ALTER TABLE

Constraints are not limited to CREATE TABLE.

You can modify them after a table has been created.

Let's use an existing table:

```sql
CREATE TABLE employees (
    id INT,
    name VARCHAR(100),
    email VARCHAR(150),
    salary DECIMAL(10,2),
    department_id INT
);
```

### Add PRIMARY KEY

```sql
ALTER TABLE employees
ADD CONSTRAINT pk_employees
PRIMARY KEY (id);
```

### Add UNIQUE

```sql
ALTER TABLE employees
ADD CONSTRAINT unique_email
UNIQUE (email);
```

### Add CHECK

```sql
ALTER TABLE employees
ADD CONSTRAINT chk_salary
CHECK (salary > 0);
```

### Add FOREIGN KEY

Assuming the departments table already exists:

```sql
ALTER TABLE employees
ADD CONSTRAINT fk_employee_department
FOREIGN KEY (department_id)
REFERENCES departments(id)
ON DELETE SET NULL;
```

### Drop FOREIGN KEY

```sql
ALTER TABLE employees
DROP FOREIGN KEY fk_employee_department;
```

### Drop UNIQUE Constraint

In MySQL, a UNIQUE constraint is implemented using a unique index. You can remove it by dropping that index:

```sql
ALTER TABLE employees
DROP INDEX unique_email;
```

### Drop CHECK

```sql
ALTER TABLE employees
DROP CHECK chk_salary;
```

### Drop PRIMARY KEY

```sql
ALTER TABLE employees
DROP PRIMARY KEY;
```

### Important

Before adding constraints to existing tables, verify that existing data satisfies the new rules.

For example, adding UNIQUE will fail if duplicate values already exist.

Find duplicate emails:

```sql
SELECT email, COUNT(*) AS total
FROM employees
GROUP BY email
HAVING COUNT(*) > 1;
```

Find invalid salaries:

```sql
SELECT *
FROM employees
WHERE salary <= 0;
```

Find invalid foreign key references:

```sql
SELECT e.*
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.id
WHERE e.department_id IS NOT NULL
AND d.id IS NULL;
```

---

# 18. Practical Database Design

Let's create a small employee management database using multiple constraints.

### Step 1: Create Database

```sql
CREATE DATABASE company_db;

USE company_db;
```

### Step 2: Create Departments Table

```sql
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,

    department_name VARCHAR(100)
    NOT NULL UNIQUE,

    created_at TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
);
```

### Step 3: Create Employees Table

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,

    name VARCHAR(100) NOT NULL,

    email VARCHAR(150) NOT NULL UNIQUE,

    age INT NOT NULL CHECK (age >= 18),

    salary DECIMAL(10,2) NOT NULL CHECK (salary > 0),

    department_id INT,

    status VARCHAR(20)
    NOT NULL DEFAULT 'Active',

    created_at TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_employee_department
    FOREIGN KEY (department_id)
    REFERENCES departments(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);
```

### Step 4: Insert Departments

```sql
INSERT INTO departments (department_name)
VALUES
('IT'),
('HR'),
('Finance'),
('Marketing');
```

### Step 5: Insert Employees

```sql
INSERT INTO employees
(name, email, age, salary, department_id)
VALUES
('John', 'john@example.com', 25, 50000, 1),
('Sarah', 'sarah@example.com', 28, 60000, 2),
('David', 'david@example.com', 30, 75000, 1),
('Alex', 'alex@example.com', 24, 45000, 3);
```

### Step 6: Verify Data

```sql
SELECT *
FROM departments;

SELECT *
FROM employees;
```

### Step 7: Test Constraints

**Test 1: Duplicate email**

```sql
INSERT INTO employees
(name, email, age, salary, department_id)
VALUES
('Mike', 'john@example.com', 26, 40000, 1);
```

Expected: Error because email is UNIQUE.

**Test 2: Invalid age**

```sql
INSERT INTO employees
(name, email, age, salary, department_id)
VALUES
('Mike', 'mike@example.com', 15, 40000, 1);
```

Expected: Error because age must be at least 18.

**Test 3: Invalid department**

```sql
INSERT INTO employees
(name, email, age, salary, department_id)
VALUES
('Mike', 'mike@example.com', 25, 40000, 99);
```

Expected: Error because department `99` does not exist.

**Test 4: Default status**

```sql
INSERT INTO employees
(name, email, age, salary, department_id)
VALUES
('Mike', 'mike@example.com', 25, 40000, 1);
```

Expected: Status automatically becomes `Active`.

**Test 5: Delete department**

```sql
DELETE FROM departments
WHERE id = 1;
```

Expected: Employees belonging to department `1` remain in the employees table, but their `department_id` becomes NULL.

---

# 19. Common Mistakes and Best Practices

| Mistake | Correct Approach |
|---|---|
| Using NOT NULL when empty strings should also be prevented | Use CHECK or appropriate validation |
| Assuming UNIQUE allows only one NULL | MySQL UNIQUE generally permits multiple NULL values |
| Using a foreign key with incompatible column types | Match data types and signedness |
| Using SET NULL on a NOT NULL column | Allow NULL in the child column |
| Assuming AUTO_INCREMENT values are continuous | Accept gaps in generated IDs |
| Using CASCADE without understanding its impact | Carefully evaluate dependent records |
| Adding constraints without checking existing data | Validate existing records first |
| Relying only on frontend validation | Enforce critical rules in the database too |
| Using CHECK without checking MySQL version | Use MySQL 8.0.16+ |
| Changing primary keys frequently | Prefer stable primary keys |

### Application Validation vs Database Constraints

These are not replacements for each other.

**Application-level validation:**

Example in Node.js:

```javascript
if (age < 18) {
    throw new Error("Employee must be at least 18 years old");
}
```

**Database-level validation:**

```sql
age INT NOT NULL CHECK (age >= 18)
```

Why use both?

- Application validation provides user-friendly error messages.
- Database constraints protect data integrity.
- Multiple applications may access the same database.
- Direct SQL queries can bypass frontend validation.
- Database constraints prevent invalid data from being stored regardless of the source.

**Best practice:** Validate in the application and enforce critical data integrity rules in the database.

---

# 20. SQL Constraints Interview Questions

### Beginner Level

**1. What are SQL constraints?**

Rules applied to database columns or tables to maintain data integrity and control the values stored in a database.

**2. What are the different types of SQL constraints?**

- NOT NULL
- UNIQUE
- PRIMARY KEY
- FOREIGN KEY
- CHECK
- DEFAULT

**3. What is the difference between PRIMARY KEY and UNIQUE?**

Both enforce uniqueness, but a primary key cannot contain NULL and only one primary key constraint is allowed per table. Multiple UNIQUE constraints are allowed.

**4. Can a table have multiple primary keys?**

No. A table can have only one PRIMARY KEY constraint, but that key can contain multiple columns.

**5. Can a UNIQUE column contain NULL?**

Yes. MySQL generally permits multiple NULL values in a UNIQUE index.

### Intermediate Level

**6. What is a foreign key?**

A foreign key establishes a relationship between two tables and enforces referential integrity.

**7. What happens if you insert an invalid foreign key value?**

MySQL rejects the insert because the referenced parent record does not exist.

**8. What is ON DELETE CASCADE?**

It automatically deletes child records when their referenced parent record is deleted.

**9. What is the difference between CASCADE and SET NULL?**

CASCADE deletes dependent child records, whereas SET NULL preserves child records but clears their foreign key values.

**10. What is a composite primary key?**

A primary key consisting of two or more columns that together uniquely identify a record.

### Advanced Level

**11. Can we add a foreign key to an existing table?**

Yes.

```sql
ALTER TABLE employees
ADD CONSTRAINT fk_department
FOREIGN KEY (department_id)
REFERENCES departments(id);
```

**12. Can a foreign key contain NULL?**

Yes, provided the foreign key column allows NULL.

**13. What is referential integrity?**

It ensures that relationships between related tables remain valid.

**14. What happens if we delete a parent record that has child records?**

The result depends on the configured foreign key action:

- CASCADE: Deletes child records.
- SET NULL: Sets child foreign keys to NULL.
- RESTRICT: Prevents parent deletion.
- NO ACTION: Effectively RESTRICT in InnoDB.

**15. What is the difference between CHECK and NOT NULL?**

NOT NULL prevents missing values. CHECK validates values against a condition.

**16. Does AUTO_INCREMENT guarantee continuous IDs?**

No. Failed inserts, rollbacks, and other operations can result in gaps.

**17. Can we use multiple constraints on one column?**

Yes.

```sql
email VARCHAR(150) NOT NULL UNIQUE
```

**18. What happens if we delete a parent table's referenced primary key?**

MySQL will prevent the operation while foreign key dependencies exist unless those relationships are removed or appropriately changed first.

---

# 21. Practical Assignments

Complete these exercises yourself using MySQL.

## Assignment 1: Student Management System

Create a `students` table with:

| Column | Requirement |
|---|---|
| id | Primary key, auto increment |
| name | NOT NULL |
| email | UNIQUE, NOT NULL |
| age | CHECK age >= 5 |
| gender | Default value `'Not Specified'` |
| status | Default value `'Active'` |

Tasks:

1. Create the table.
2. Insert five students.
3. Try inserting duplicate emails.
4. Try inserting NULL names.
5. Try inserting invalid ages.
6. Change the default status to `'Pending'`.
7. Add a CHECK constraint for age <= 100.

## Assignment 2: Department and Employee Relationship

Create two tables:

**departments**

- id
- department_name

**employees**

- id
- name
- salary
- department_id

Requirements:

1. Department ID must be a primary key.
2. Employee ID must be a primary key.
3. Department name must be unique.
4. Employee name must be NOT NULL.
5. Salary must be greater than zero.
6. Employee department_id must reference departments.id.
7. Configure ON DELETE SET NULL.
8. Configure ON UPDATE CASCADE.

Tasks:

- Insert five departments.
- Insert ten employees.
- Try inserting an employee with an invalid department ID.
- Delete a department and observe the result.
- Update a department ID and observe the result.

## Assignment 3: Course Enrollment System

Create:

- students
- courses
- enrollments

Requirements:

1. Students should have a primary key.
2. Courses should have a primary key.
3. Enrollments should reference students and courses.
4. The same student cannot enroll in the same course twice.
5. Use either a composite primary key or an AUTO_INCREMENT ID with a composite UNIQUE constraint.

---

# 22. Phase 7 Quick Revision Sheet

| Constraint | Main Purpose | Example |
|---|---|---|
| NOT NULL | Prevent NULL | `name VARCHAR(100) NOT NULL` |
| UNIQUE | Prevent duplicates | `email VARCHAR(150) UNIQUE` |
| PRIMARY KEY | Identify each row | `id INT PRIMARY KEY` |
| FOREIGN KEY | Establish relationships | `FOREIGN KEY (dept_id) REFERENCES departments(id)` |
| CHECK | Validate conditions | `CHECK (age >= 18)` |
| DEFAULT | Provide default values | `status VARCHAR(20) DEFAULT 'Active'` |
| AUTO_INCREMENT | Generate numeric IDs | `id INT AUTO_INCREMENT` |

### Referential Actions

| Action | Result |
|---|---|
| ON DELETE CASCADE | Deletes child records |
| ON UPDATE CASCADE | Updates child foreign key values |
| ON DELETE SET NULL | Sets child foreign keys to NULL |
| ON DELETE RESTRICT | Prevents deletion of referenced parent |
| ON DELETE NO ACTION | Effectively RESTRICT in InnoDB |

---

# 23. Phase 7 Completion Checklist

Before moving to Phase 8, make sure you can:

- [ ] Explain what SQL constraints are.
- [ ] Use NOT NULL.
- [ ] Use UNIQUE.
- [ ] Create primary keys.
- [ ] Create foreign keys.
- [ ] Use CHECK constraints.
- [ ] Set DEFAULT values.
- [ ] Use AUTO_INCREMENT.
- [ ] Create composite primary keys.
- [ ] Apply multiple constraints to one column.
- [ ] Understand referential integrity.
- [ ] Use ON DELETE CASCADE.
- [ ] Use ON UPDATE CASCADE.
- [ ] Use ON DELETE SET NULL.
- [ ] Use ON DELETE RESTRICT.
- [ ] Add and remove constraints using ALTER TABLE.
- [ ] Design a relational database with appropriate constraints.

---

## Next Phase: Phase 8 – SQL Aggregate Functions

In Phase 8, we will learn how to calculate and summarize data using SQL.

Topics:

1. What Are Aggregate Functions?
2. COUNT()
3. SUM()
4. AVG()
5. MIN()
6. MAX()
7. COUNT(*) vs COUNT(column)
8. DISTINCT with Aggregate Functions
9. Aggregate Functions with WHERE
10. Aggregate Functions with NULL Values
11. Aggregate Functions with GROUP BY
12. Practical Employee Analytics Examples
13. Common Mistakes
14. Interview Questions
15. Practical Assignments

**Phase 7 is complete.** Once you're comfortable with these concepts, proceed to Phase 8.