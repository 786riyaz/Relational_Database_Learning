# SQL Complete Learning Roadmap
# Phase 16 – Database Design and Relationships
### MySQL 8.0+

Database design is one of the most important skills for backend developers.

Writing SQL queries is not enough. You must also know how to design databases, organize tables, establish relationships, prevent duplicate data, and maintain data integrity.

For example, when building an e-commerce application, you need to design tables for:

- Users
- Products
- Categories
- Orders
- Order Items
- Payments
- Addresses
- Reviews
- Shopping Carts

All these tables are related to one another.

In this phase, we will learn how to design such databases professionally.

---

# 1. What Is Database Design?

Database design is the process of organizing data into tables and defining relationships between those tables.

The main objectives are:

1. Store data efficiently.
2. Avoid unnecessary data duplication.
3. Maintain data consistency.
4. Establish relationships between records.
5. Make querying and reporting easier.
6. Maintain data integrity.
7. Support future application requirements.

### Example: Poor Database Design

Imagine you create an e-commerce table like this:

**orders**

| order_id | customer_name | customer_email | product_name | product_price | quantity |
|---:|---|---|---|---:|---:|
| 1 | Riyaz | riyaz@example.com | Laptop | 75000 | 1 |
| 2 | Riyaz | riyaz@example.com | Mouse | 800 | 2 |
| 3 | John | john@example.com | Keyboard | 1500 | 1 |

Problems:

- Customer information is repeated.
- Product information is repeated.
- Updating customer details requires changing multiple records.
- Deleting an order could accidentally remove the only stored copy of customer information.
- Managing multiple products in one order becomes difficult.

### Better Database Design

Separate the information into related tables:

**customers**

| id | name | email |
|---:|---|---|
| 1 | Riyaz | riyaz@example.com |
| 2 | John | john@example.com |

**products**

| id | name | price |
|---:|---|---:|
| 1 | Laptop | 75000 |
| 2 | Mouse | 800 |
| 3 | Keyboard | 1500 |

**orders**

| id | customer_id | order_date |
|---:|---:|---|
| 1 | 1 | 2026-11-25 |
| 2 | 1 | 2026-11-26 |
| 3 | 2 | 2026-11-26 |

**order_items**

| id | order_id | product_id | quantity |
|---:|---:|---:|---:|
| 1 | 1 | 1 | 1 |
| 2 | 2 | 2 | 2 |
| 3 | 3 | 3 | 1 |

Now each type of information is stored in its appropriate table.

This is the foundation of relational database design.

---

# 2. What Is a Database Schema?

A database schema describes the structure and organization of a database.

It defines:

- Tables.
- Columns.
- Data types.
- Primary keys.
- Foreign keys.
- Constraints.
- Relationships.
- Indexes.

### Example

```sql
CREATE DATABASE ecommerce_db;

USE ecommerce_db;

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
);
```

The schema of the `customers` table includes:

| Column | Data Type | Constraint |
|---|---|---|
| id | INT | PRIMARY KEY, AUTO_INCREMENT |
| name | VARCHAR(100) | NOT NULL |
| email | VARCHAR(150) | UNIQUE, NOT NULL |

### View Table Structure

```sql
DESCRIBE customers;
```

### View Complete Table Definition

```sql
SHOW CREATE TABLE customers;
```

### Database Schema vs Database Instance

These two concepts are different.

| Database Schema | Database Instance |
|---|---|
| Defines database structure | Represents the actual data at a particular time |
| Changes relatively infrequently | Changes whenever data is inserted, updated, or deleted |
| Defines tables and relationships | Contains actual records |

Example:

The `customers` table definition is part of the schema.

The customer records stored inside it represent the current database contents.

---

# 3. What Are Entities and Attributes?

These are fundamental concepts in database design and ER modeling.

## 3.1 Entity

An entity is a real-world object, person, concept, or thing about which we want to store information.

Examples:

- Customer
- Employee
- Product
- Department
- Order
- Student
- Course
- Payment

In a relational database, an entity is commonly represented by a table.

Example:

```sql
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(150)
);
```

Here, `students` represents an entity.

## 3.2 Attribute

An attribute is a property or characteristic of an entity.

For example, a Student entity might have:

- Student ID
- Name
- Email
- Date of Birth
- Phone Number
- Address

In a relational database, attributes are generally represented by columns.

### Entity vs Attribute

| Entity | Attribute |
|---|---|
| Represents an object | Represents a property of an object |
| Usually represented by a table | Usually represented by a column |
| Student | Student name |
| Product | Product price |
| Employee | Employee salary |

### Example

**Entity: Employee**

| Attribute | Example Value |
|---|---|
| id | 101 |
| name | Riyaz |
| email | riyaz@example.com |
| salary | 80000 |
| department | IT |

---

# 4. What Is a Primary Key?

A Primary Key is a column or combination of columns that uniquely identifies each record in a table.

### Example

```sql
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(150)
);
```

Here, `id` is the primary key.

Example records:

| id | name | email |
|---:|---|---|
| 1 | Riyaz | riyaz@example.com |
| 2 | John | john@example.com |
| 3 | Sarah | sarah@example.com |

Every customer has a unique ID.

### Primary Key Rules

1. A primary key must be unique.
2. A primary key cannot contain NULL.
3. A table can have only one primary key constraint.
4. A primary key can consist of multiple columns.
5. A primary key should reliably identify a record.

### Why Do We Need Primary Keys?

Suppose two customers have the same name:

| id | name |
|---:|---|
| 1 | John |
| 2 | John |

If you identify customers only by their names, distinguishing them becomes difficult.

A unique ID solves this problem.

---

# 5. What Is a Foreign Key?

A Foreign Key is a column or combination of columns that references a candidate key, usually the primary key, in another table.

It establishes a relationship between tables and helps maintain referential integrity.

### Example

Create a departments table:

```sql
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100)
);
```

Create an employees table:

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    department_id INT,

    FOREIGN KEY (department_id)
        REFERENCES departments(id)
);
```

Here:

- `departments.id` is the primary key.
- `employees.department_id` is the foreign key.

### Sample Data

**departments**

| id | department_name |
|---:|---|
| 1 | IT |
| 2 | HR |
| 3 | Finance |

**employees**

| id | name | department_id |
|---:|---|---:|
| 1 | Riyaz | 1 |
| 2 | John | 1 |
| 3 | Sarah | 2 |
| 4 | David | 3 |

The `department_id` connects employees to departments.

### What Happens If You Insert an Invalid Foreign Key?

```sql
INSERT INTO employees (name, department_id)
VALUES ('Alex', 10);
```

If department ID 10 does not exist, MySQL rejects the insertion.

This prevents employees from referencing nonexistent departments.

### Primary Key vs Foreign Key

| Primary Key | Foreign Key |
|---|---|
| Uniquely identifies records | References a key in another table |
| Must be unique | Can contain repeated values |
| Cannot be NULL | Can be NULL unless NOT NULL is specified |
| One primary key constraint per table | Multiple foreign key constraints can exist |
| Maintains entity identity | Maintains referential integrity |

---

# 6. What Are Database Relationships?

Relationships describe how records in different tables are connected.

There are three major relationship types:

1. One-to-One (1:1)
2. One-to-Many (1:N)
3. Many-to-Many (M:N)

We will also study self-referencing relationships.

---

# 7. One-to-One Relationship (1:1)

A One-to-One relationship means one record in Table A is associated with at most one record in Table B, and vice versa.

### Real-World Examples

- One user has one profile.
- One person has one passport record.
- One employee has one employment contract record, if the business rules allow only one.

### Example: Users and User Profiles

**users**

| id | name | email |
|---:|---|---|
| 1 | Riyaz | riyaz@example.com |
| 2 | John | john@example.com |

**user_profiles**

| id | user_id | date_of_birth | phone |
|---:|---:|---|---|
| 1 | 1 | 2001-05-10 | 9876543210 |
| 2 | 2 | 2000-08-15 | 9876543211 |

Each profile belongs to one user.

### SQL Implementation

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(150) UNIQUE
);
```

```sql
CREATE TABLE user_profiles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    date_of_birth DATE,
    phone VARCHAR(20),

    FOREIGN KEY (user_id)
        REFERENCES users(id)
);
```

### Why UNIQUE on user_id?

Because we want each user to have at most one profile.

Without `UNIQUE`, multiple profiles could reference the same user.

Example:

```text
user_id = 1
user_id = 1
user_id = 1
```

This would create a one-to-many relationship instead.

### Alternative: Shared Primary Key

You can also use the user's ID as the profile's primary key and foreign key.

```sql
CREATE TABLE user_profiles (
    user_id INT PRIMARY KEY,
    date_of_birth DATE,
    phone VARCHAR(20),

    FOREIGN KEY (user_id)
        REFERENCES users(id)
);
```

This design guarantees one profile row per user.

### When Should You Use One-to-One?

Use it when:

- A table contains optional information.
- A table contains sensitive information that needs separate access controls.
- A table has many rarely accessed columns.
- You want to separate different logical parts of an entity.

However, do not split tables unnecessarily. If the data is always accessed together and the design is simple, one table may be sufficient.

---

# 8. One-to-Many Relationship (1:N)

A One-to-Many relationship means one record in Table A can be associated with multiple records in Table B.

But each record in Table B belongs to at most one record in Table A.

### Real-World Examples

- One department has many employees.
- One customer has many orders.
- One category has many products.
- One author writes many books.

### Example: Departments and Employees

**departments**

| id | department_name |
|---:|---|
| 1 | IT |
| 2 | HR |

**employees**

| id | name | department_id |
|---:|---|---:|
| 1 | Riyaz | 1 |
| 2 | John | 1 |
| 3 | Sarah | 1 |
| 4 | David | 2 |

One department can have multiple employees.

### SQL Implementation

```sql
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100)
);
```

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    department_id INT,

    FOREIGN KEY (department_id)
        REFERENCES departments(id)
);
```

### Important Rule

In a One-to-Many relationship, the foreign key is generally placed on the **Many side**.

In this example:

- One side: departments.
- Many side: employees.
- Foreign key: employees.department_id.

### Visual Representation

```text
DEPARTMENTS
-----------
id (PK)
department_name
       |
       | 1
       |
       | N
       |
EMPLOYEES
---------
id (PK)
name
department_id (FK)
```

---

# 9. Many-to-Many Relationship (M:N)

A Many-to-Many relationship means multiple records in Table A can be associated with multiple records in Table B.

### Real-World Examples

- Students enroll in multiple courses.
- Courses have multiple students.
- Products belong to multiple promotional campaigns.
- Users can have multiple roles.
- Authors can write multiple books, and books can have multiple authors.

### Example: Students and Courses

Suppose:

**students**

| id | name |
|---:|---|
| 1 | Riyaz |
| 2 | John |
| 3 | Sarah |

**courses**

| id | course_name |
|---:|---|
| 1 | SQL |
| 2 | JavaScript |
| 3 | Python |

A student can enroll in multiple courses.

A course can have multiple students.

How do we represent this relationship?

We use a **Junction Table**.

---

# 10. What Is a Junction Table?

A Junction Table, also called a Bridge Table or Associative Table, is used to implement a Many-to-Many relationship.

Instead of directly connecting two tables, we create an intermediate table containing foreign keys referencing both tables.

### Example: student_courses

| id | student_id | course_id |
|---:|---:|---:|
| 1 | 1 | 1 |
| 2 | 1 | 2 |
| 3 | 2 | 1 |
| 4 | 3 | 3 |
| 5 | 3 | 2 |

Interpretation:

- Riyaz is enrolled in SQL and JavaScript.
- John is enrolled in SQL.
- Sarah is enrolled in Python and JavaScript.

### SQL Implementation

Create students:

```sql
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);
```

Create courses:

```sql
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100)
);
```

Create junction table:

```sql
CREATE TABLE student_courses (
    id INT PRIMARY KEY AUTO_INCREMENT,

    student_id INT NOT NULL,
    course_id INT NOT NULL,

    enrollment_date DATE,

    FOREIGN KEY (student_id)
        REFERENCES students(id),

    FOREIGN KEY (course_id)
        REFERENCES courses(id),

    UNIQUE (student_id, course_id)
);
```

### Why UNIQUE(student_id, course_id)?

It prevents the same student from enrolling in the same course more than once.

For example, this combination:

```text
student_id = 1
course_id = 1
```

cannot be inserted twice.

### Can We Avoid the Separate ID?

Yes.

You can use a composite primary key:

```sql
CREATE TABLE student_courses (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE,

    PRIMARY KEY (student_id, course_id),

    FOREIGN KEY (student_id)
        REFERENCES students(id),

    FOREIGN KEY (course_id)
        REFERENCES courses(id)
);
```

Now the combination of `student_id` and `course_id` uniquely identifies each enrollment.

### Why Is This Better Than Storing Multiple IDs in One Column?

Bad design:

| student_id | course_ids |
|---:|---|
| 1 | 1,2,3 |
| 2 | 1,3 |

Problems:

- Difficult to search individual course IDs.
- Difficult to enforce foreign keys for each ID.
- Difficult to update relationships.
- Difficult to count enrollments.
- Violates the relational principle of storing individual values in columns.

A junction table solves these problems.

### Visual Representation

```text
STUDENTS                  COURSES
--------                  -------
id (PK)                   id (PK)
name                      course_name
   |                         |
   | 1                       | 1
   |                         |
   | N                       | N
   +------ STUDENT_COURSES --+
              id (PK)
              student_id (FK)
              course_id (FK)
```

A Many-to-Many relationship is implemented as two One-to-Many relationships.

---

# 11. Self-Referencing Relationship

A Self-Referencing Relationship occurs when a table has a foreign key that references its own primary key.

### Real-World Examples

- Employee and manager.
- Category and parent category.
- User and referral user.
- Comment and parent comment.
- Organizational hierarchy.

### Example: Employee and Manager

An employee can report to another employee.

Create the table:

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    manager_id INT NULL,

    FOREIGN KEY (manager_id)
        REFERENCES employees(id)
);
```

Insert records:

```sql
INSERT INTO employees (name, manager_id)
VALUES
('Riyaz', NULL),
('John', 1),
('Sarah', 1),
('David', 2),
('Alex', 1);
```

Data:

| id | name | manager_id |
|---:|---|---:|
| 1 | Riyaz | NULL |
| 2 | John | 1 |
| 3 | Sarah | 1 |
| 4 | David | 2 |
| 5 | Alex | 1 |

Interpretation:

- Riyaz is the top-level manager.
- John reports to Riyaz.
- Sarah reports to Riyaz.
- Alex reports to Riyaz.
- David reports to John.

### Find Employee and Manager Names

```sql
SELECT
    e.name AS employee_name,
    m.name AS manager_name
FROM employees e
LEFT JOIN employees m
    ON e.manager_id = m.id;
```

Output:

| employee_name | manager_name |
|---|---|
| Riyaz | NULL |
| John | Riyaz |
| Sarah | Riyaz |
| David | John |
| Alex | Riyaz |

Notice that we join the employees table with itself.

This is called a **Self JOIN**.

### Visual Representation

```text
EMPLOYEES
---------
id (PK)
name
manager_id (FK)
       |
       |
       +------ References employees.id
```

### Important

Self-referencing relationships are useful for storing hierarchical data.

For traversing multiple hierarchy levels, you can use recursive CTEs, which we studied in Phase 14.

---

# 12. What Is an ER Diagram?

ER stands for **Entity-Relationship**.

An ER Diagram is a visual representation of database entities, their attributes, and relationships.

It is commonly used before implementing a database.

### Example

Imagine an e-commerce application with these entities:

- Customers
- Orders
- Products
- Order Items

Relationships:

- One customer can place multiple orders.
- One order can contain multiple products.
- One product can appear in multiple orders.

The ER model can be represented as:

```text
CUSTOMERS
---------
id (PK)
name
email
    |
    | 1
    |
    | N
ORDERS
------
id (PK)
customer_id (FK)
order_date
    |
    | 1
    |
    | N
ORDER_ITEMS
-----------
id (PK)
order_id (FK)
product_id (FK)
quantity
unit_price
    |
    | N
    |
    | 1
PRODUCTS
--------
id (PK)
name
price
```

This diagram shows how the tables are related.

### Why Are ER Diagrams Important?

1. Help understand database structure.
2. Make relationships clear.
3. Help identify missing entities.
4. Help prevent incorrect relationships.
5. Improve communication between developers.
6. Make complex database systems easier to design.

### Common ER Diagram Tools

- MySQL Workbench
- dbdiagram.io
- draw\.io
- Lucidchart

---

# 13. Understanding Cardinality

Cardinality describes how many records in one entity can be associated with records in another entity.

The main cardinalities are:

| Cardinality | Meaning |
|---|---|
| 1:1 | One-to-One |
| 1:N | One-to-Many |
| N:1 | Many-to-One |
| M:N | Many-to-Many |

### Example

**One-to-One**

```text
USER 1 -------- 1 USER_PROFILE
```

**One-to-Many**

```text
CUSTOMER 1 -------- N ORDERS
```

**Many-to-Many**

```text
STUDENT N -------- N COURSE
```

In relational database implementation, a Many-to-Many relationship is generally converted into two One-to-Many relationships through a junction table.

---

# 14. Understanding Participation

Participation describes whether an entity must participate in a relationship.

There are two main types.

## 14.1 Total Participation

Every record must participate in the relationship.

Example:

Every order must belong to a customer.

In SQL, this can be enforced using:

```sql
customer_id INT NOT NULL
```

along with a foreign key.

## 14.2 Partial Participation

A record may or may not participate in the relationship.

Example:

An employee may or may not have a manager.

In SQL:

```sql
manager_id INT NULL
```

along with a foreign key.

### Total vs Partial Participation

| Total Participation | Partial Participation |
|---|---|
| Participation is mandatory | Participation is optional |
| Every record must have the relationship | Some records may not have the relationship |
| Often implemented with NOT NULL foreign key | Often implemented with nullable foreign key |

**Important:** A nullable foreign key permits an absent relationship, but cardinality and participation should be defined from the business requirements. SQL constraints alone do not automatically enforce every possible business rule.

---

# 15. What Are Natural Keys and Surrogate Keys?

Database designers must decide how records should be identified.

There are two important concepts.

## 15.1 Natural Key

A Natural Key is a key that comes from real-world business data.

Examples:

- Email address.
- Passport number.
- Government-issued registration number.
- ISBN for a book.

Example:

```sql
CREATE TABLE users (
    email VARCHAR(150) PRIMARY KEY,
    name VARCHAR(100)
);
```

Here, email is being used as a natural key.

### Problems with Natural Keys

- Business values may change.
- Some values may be long.
- Privacy concerns may arise.
- Some real-world identifiers are not always guaranteed to be unique or permanent.

## 15.2 Surrogate Key

A Surrogate Key is an artificial identifier generated specifically for database identification.

Example:

```sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(150) UNIQUE NOT NULL,
    name VARCHAR(100)
);
```

Here:
- `id` is the surrogate key.
- `email` is a unique business attribute.

### Natural Key vs Surrogate Key

| Natural Key | Surrogate Key |
|---|---|
| Comes from business data | Artificially generated |
| Has real-world meaning | Usually has no business meaning |
| May change | Usually remains stable |
| Examples: email, ISBN | Examples: AUTO_INCREMENT ID, UUID |

**Best practice:** Surrogate primary keys are common in application databases, while natural business identifiers can be protected with UNIQUE constraints.

---

# 16. What Is a Composite Key?

A Composite Key is a key made up of two or more columns.

It is used when one column alone cannot uniquely identify a record.

### Example: Student Course Enrollment

A student can enroll in multiple courses.

A course can contain multiple students.

The combination of student ID and course ID uniquely identifies an enrollment.

```sql
CREATE TABLE student_courses (
    student_id INT,
    course_id INT,
    enrollment_date DATE,

    PRIMARY KEY (student_id, course_id),

    FOREIGN KEY (student_id)
        REFERENCES students(id),

    FOREIGN KEY (course_id)
        REFERENCES courses(id)
);
```

Here:

```sql
PRIMARY KEY (student_id, course_id)
```

is a composite primary key.

### Example

| student_id | course_id |
|---:|---:|
| 1 | 1 |
| 1 | 2 |
| 2 | 1 |
| 2 | 3 |

These combinations are unique.

However, the following combination cannot appear twice:

| student_id | course_id |
|---:|---:|
| 1 | 1 |
| 1 | 1 |

### Composite Key vs Single-Column Key

| Composite Key | Single-Column Key |
|---|---|
| Uses multiple columns | Uses one column |
| Represents combined uniqueness | Represents individual uniqueness |
| Common in junction tables | Common in entity tables |

---

# 17. What Is a UNIQUE Key?

A UNIQUE constraint ensures that values in a column or combination of columns do not duplicate each other.

Example:

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20) UNIQUE
);
```

Now two users cannot have the same email or phone number.

### Composite UNIQUE Constraint

```sql
CREATE TABLE student_courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,

    UNIQUE (student_id, course_id)
);
```

This ensures that a student cannot have the same course enrollment twice.

**Important MySQL behavior:** A UNIQUE index can permit multiple NULL values for a nullable column. If a value is required and must be unique, combine UNIQUE with NOT NULL.

---

# 18. Understanding Relationship Implementation in MySQL

Let's summarize how each relationship is implemented.

| Relationship | SQL Implementation |
|---|---|
| One-to-One | Foreign key + UNIQUE constraint |
| One-to-Many | Foreign key on the Many side |
| Many-to-Many | Junction table with two foreign keys |
| Self-Referencing | Foreign key references the same table |

### One-to-One

```sql
user_id INT UNIQUE,
FOREIGN KEY (user_id) REFERENCES users(id)
```

### One-to-Many

```sql
department_id INT,
FOREIGN KEY (department_id) REFERENCES departments(id)
```

### Many-to-Many

```sql
student_id INT,
course_id INT,

FOREIGN KEY (student_id) REFERENCES students(id),
FOREIGN KEY (course_id) REFERENCES courses(id)
```

### Self-Referencing

```sql
manager_id INT,
FOREIGN KEY (manager_id) REFERENCES employees(id)
```

---

# 19. Designing a Complete E-commerce Database

Now let's apply everything we have learned.

We will design a basic e-commerce database.

### Requirements

The application needs to manage:

1. Customers.
2. Customer addresses.
3. Product categories.
4. Products.
5. Orders.
6. Order items.
7. Payments.
8. Product reviews.

### Step 1 – Identify Entities

| Entity | Purpose |
|---|---|
| customers | Stores customer information |
| addresses | Stores customer addresses |
| categories | Stores product categories |
| products | Stores products |
| orders | Stores order information |
| order_items | Stores products within orders |
| payments | Stores payment records |
| reviews | Stores customer product reviews |

### Step 2 – Identify Relationships

| Relationship | Type |
|---|---|
| Customer → Addresses | One-to-Many |
| Customer → Orders | One-to-Many |
| Category → Products | One-to-Many |
| Order → Order Items | One-to-Many |
| Product → Order Items | One-to-Many |
| Order → Payments | One-to-Many |
| Customer → Reviews | One-to-Many |
| Product → Reviews | One-to-Many |

The relationship between Orders and Products is Many-to-Many, implemented through `order_items`.

### Step 3 – Create Tables

**1. Customers**

```sql
CREATE TABLE customers (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**2. Addresses**

```sql
CREATE TABLE addresses (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),

    FOREIGN KEY (customer_id)
        REFERENCES customers(id)
);
```

**3. Categories**

```sql
CREATE TABLE categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    parent_id BIGINT NULL,

    FOREIGN KEY (parent_id)
        REFERENCES categories(id)
);
```

Notice that categories use a self-referencing relationship.

**4. Products**

```sql
CREATE TABLE products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    category_id BIGINT NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,

    FOREIGN KEY (category_id)
        REFERENCES categories(id)
);
```

**5. Orders**

```sql
CREATE TABLE orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    shipping_address_id BIGINT,
    order_status VARCHAR(30) DEFAULT 'pending',
    total_amount DECIMAL(12,2) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id)
        REFERENCES customers(id),

    FOREIGN KEY (shipping_address_id)
        REFERENCES addresses(id)
);
```

**6. Order Items**

```sql
CREATE TABLE order_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(id),

    FOREIGN KEY (product_id)
        REFERENCES products(id),

    UNIQUE (order_id, product_id)
);
```

**7. Payments**

```sql
CREATE TABLE payments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    payment_method VARCHAR(50),
    payment_status VARCHAR(30),
    amount DECIMAL(12,2) NOT NULL,
    transaction_reference VARCHAR(150),

    FOREIGN KEY (order_id)
        REFERENCES orders(id)
);
```

**8. Reviews**

```sql
CREATE TABLE reviews (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    rating TINYINT NOT NULL,
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id)
        REFERENCES customers(id),

    FOREIGN KEY (product_id)
        REFERENCES products(id),

    UNIQUE (customer_id, product_id),

    CHECK (rating BETWEEN 1 AND 5)
);
```

### Step 4 – Understand the Relationships

```text
CUSTOMERS
   |
   | 1:N
   |
   +---------- ADDRESSES
   |
   | 1:N
   |
   +---------- ORDERS
   |              |
   |              | 1:N
   |              |
   |              +---------- ORDER_ITEMS
   |                              |
   |                              | N:1
   |                              |
   |                           PRODUCTS
   |                              |
   |                              | N:1
   |                              |
   |                          CATEGORIES
   |
   | 1:N
   |
   +---------- REVIEWS
                  |
                  | N:1
                  |
                PRODUCTS
```

Payments are also associated with orders through `order_id`.

### Important Design Considerations

**Why do we store unit_price in order_items?**

Suppose a customer purchases a laptop for ₹75,000.

After one month, the product price changes to ₹80,000.

The historical order must still show the original purchase price of ₹75,000.

Therefore, we store the purchase-time price in `order_items.unit_price`.

**Why do we store total_amount in orders?**

It provides a convenient order-level amount for reporting and payment processing.

However, the application must ensure that it stays consistent with the order items, discounts, taxes, and shipping charges.

**Why is order_status stored in orders?**

It tracks the lifecycle of an order:

```text
pending
confirmed
processing
shipped
delivered
cancelled
```

For a larger application, you may also create an order status history table to track every status change.

---

# 20. Designing an Employee Management Database

Let's design another practical database.

### Requirements

- Departments.
- Employees.
- Employee managers.
- Employee attendance.
- Employee salaries.
- Employee skills.

### Entities and Relationships

| Entity | Relationship |
|---|---|
| Departments | One department has many employees |
| Employees | One employee may manage many employees |
| Attendance | One employee has many attendance records |
| Salary History | One employee has many salary records |
| Skills | Many employees can have many skills |
| Employee Skills | Junction table |

### SQL Structure

**Departments**

```sql
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) UNIQUE NOT NULL
);
```

**Employees**

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    department_id INT NOT NULL,
    manager_id INT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    joining_date DATE,

    FOREIGN KEY (department_id)
        REFERENCES departments(id),

    FOREIGN KEY (manager_id)
        REFERENCES employees(id)
);
```

**Attendance**

```sql
CREATE TABLE attendance (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    check_in TIME,
    check_out TIME,
    status VARCHAR(30),

    FOREIGN KEY (employee_id)
        REFERENCES employees(id),

    UNIQUE (employee_id, attendance_date)
);
```

**Salary History**

```sql
CREATE TABLE salary_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    salary DECIMAL(12,2) NOT NULL,
    effective_from DATE NOT NULL,
    effective_to DATE NULL,

    FOREIGN KEY (employee_id)
        REFERENCES employees(id)
);
```

**Skills**

```sql
CREATE TABLE skills (
    id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(100) UNIQUE NOT NULL
);
```

**Employee Skills**

```sql
CREATE TABLE employee_skills (
    employee_id INT NOT NULL,
    skill_id INT NOT NULL,

    PRIMARY KEY (employee_id, skill_id),

    FOREIGN KEY (employee_id)
        REFERENCES employees(id),

    FOREIGN KEY (skill_id)
        REFERENCES skills(id)
);
```

This database uses:

- One-to-Many.
- Many-to-Many.
- Self-Referencing.
- Composite Primary Keys.
- Foreign Keys.
- Unique Constraints.

---

# 21. Database Design Best Practices

When designing a production database, follow these principles.

### 1. Identify Entities First

Before creating tables, identify the major entities in your application.

Example:

For an expense tracker:

- Users
- Accounts
- Categories
- Transactions
- Budgets

### 2. Define Relationships

Determine whether each relationship is:

- One-to-One.
- One-to-Many.
- Many-to-Many.
- Self-Referencing.

### 3. Use Primary Keys

Every important entity table should generally have a stable primary key.

### 4. Use Foreign Keys

Use foreign keys when database-level referential integrity is required.

### 5. Avoid Storing Multiple Values in One Column

Bad:

```text
product_ids = "1,2,3,4"
```

Better:

Create a separate junction table.

### 6. Choose Appropriate Data Types

Examples:

| Data | Recommended Type |
|---|---|
| IDs | INT or BIGINT |
| Price | DECIMAL |
| Name | VARCHAR |
| Description | TEXT |
| Birth Date | DATE |
| Creation Time | DATETIME or TIMESTAMP |
| Boolean State | BOOLEAN/TINYINT(1) |

### 7. Use Meaningful Names

Good:

```text
customer_id
order_date
product_price
```

Avoid unclear names:

```text
c_id
dt
p_val
```

### 8. Avoid Unnecessary Duplication

Store customer information in the customers table rather than repeating it in every order.

However, deliberate historical snapshots are sometimes necessary.

### 9. Index Foreign Keys and Frequently Queried Columns Appropriately

MySQL automatically requires and creates a suitable index for a foreign key when one does not already exist.

You should still review indexing for your application's query patterns.

### 10. Plan for Future Requirements

Think about:
- Soft deletion.
- Audit history.
- Status tracking.
- Multiple addresses.
- Multiple payment attempts.
- Product variants.
- User permissions.

Do not add unnecessary complexity before it is needed.

---

# 22. Common Database Design Mistakes

| Mistake | Better Approach |
|---|---|
| Storing multiple IDs in one column | Use a junction table |
| No primary key | Define a stable primary key |
| No foreign keys where integrity matters | Define appropriate foreign keys |
| Repeating customer details in every order | Separate customer and order tables |
| Using VARCHAR for every data type | Choose appropriate data types |
| Using product name as a foreign key | Reference product ID |
| Creating unnecessary one-to-one tables | Split only when justified |
| Allowing duplicate junction records | Add composite UNIQUE or PRIMARY KEY |
| Ignoring nullable relationships | Define mandatory and optional participation |
| Storing current product price as historical order price | Store purchase-time unit price |

---

# 23. SQL Database Design Interview Questions

### Beginner Level

1. What is database design?
2. What is a database schema?
3. What is an entity?
4. What is an attribute?
5. What is a primary key?
6. What is a foreign key?
7. What is a database relationship?
8. What are the three main relationship types?
9. What is an ER diagram?
10. What is cardinality?

### Intermediate Level

11. Explain a One-to-One relationship with an example.
12. Explain a One-to-Many relationship with an example.
13. Explain a Many-to-Many relationship with an example.
14. What is a junction table?
15. Why do we need junction tables?
16. What is a self-referencing relationship?
17. What is a composite primary key?
18. What is a UNIQUE constraint?
19. What is the difference between a primary key and a foreign key?
20. What is participation in ER modeling?

### Advanced Level

21. What is the difference between natural and surrogate keys?
22. When should you use a composite key?
23. How do you design an e-commerce database?
24. How do you model employee-manager relationships?
25. How do you model a student-course relationship?
26. How do you prevent duplicate records in a junction table?
27. How do you model hierarchical categories?
28. Why should historical order prices be stored separately from current product prices?
29. What is the difference between database schema and database instance?
30. What factors should be considered when designing a production database?

---

# 24. Practical Assignments

These assignments are important. Try designing the database yourself before checking the solutions.

## Assignment 1 – Student Management System

Design a database containing:

1. Students.
2. Teachers.
3. Courses.
4. Departments.
5. Student Enrollments.
6. Attendance.
7. Exams.
8. Exam Results.

Requirements:

- One department has multiple teachers.
- One student can enroll in multiple courses.
- One course can have multiple students.
- One teacher can teach multiple courses.
- Students can have multiple attendance records.
- Students can have multiple exam results.

Identify all entities, attributes, primary keys, foreign keys, and relationships.

## Assignment 2 – Library Management System

Design tables for:

1. Books.
2. Authors.
3. Publishers.
4. Categories.
5. Members.
6. Book Copies.
7. Book Borrowings.
8. Book Reservations.

Requirements:

- One author can write multiple books.
- One book can have multiple authors.
- One book can have multiple physical copies.
- One member can borrow multiple books.
- One member can make multiple reservations.

Determine which relationships require junction tables.

## Assignment 3 – E-commerce Database

Design tables for:

1. Customers.
2. Addresses.
3. Products.
4. Categories.
5. Orders.
6. Order Items.
7. Payments.
8. Reviews.
9. Coupons.
10. Product Images.

Requirements:

- Customers can have multiple addresses.
- Customers can place multiple orders.
- Orders can contain multiple products.
- Products can belong to multiple categories.
- Customers can review multiple products.
- Products can have multiple images.
- Orders can have multiple payment attempts.

Draw the ER diagram and implement the schema in MySQL.

## Assignment 4 – Employee Management System

Design tables for:

1. Employees.
2. Departments.
3. Managers.
4. Attendance.
5. Salary History.
6. Skills.
7. Employee Skills.
8. Leave Requests.

Requirements:

- Employees belong to departments.
- Employees can report to managers.
- Employees can have multiple skills.
- Employees can have multiple attendance records.
- Employees can have multiple salary history records.

## Assignment 5 – Expense Tracker

Design tables for:

1. Users.
2. Accounts.
3. Categories.
4. Transactions.
5. Budgets.
6. Recurring Transactions.
7. Attachments.

Requirements:

- One user can have multiple accounts.
- One account can have multiple transactions.
- One category can have multiple transactions.
- One user can create multiple budgets.
- One transaction can have multiple attachments.

---

# 25. Phase 16 – Quick Revision Sheet

| Concept | Meaning |
|---|---|
| Database Design | Organizing data into tables and relationships |
| Schema | Structure of the database |
| Entity | Real-world object represented in a database |
| Attribute | Property of an entity |
| Primary Key | Uniquely identifies a record |
| Foreign Key | References a key in another table |
| One-to-One | One record relates to at most one record |
| One-to-Many | One record relates to multiple records |
| Many-to-Many | Multiple records relate to multiple records |
| Junction Table | Implements Many-to-Many relationships |
| Self-Referencing | Table references itself |
| ER Diagram | Visual representation of entities and relationships |
| Cardinality | Number of possible related records |
| Total Participation | Relationship participation is mandatory |
| Partial Participation | Relationship participation is optional |
| Natural Key | Key derived from real-world data |
| Surrogate Key | Artificially generated identifier |
| Composite Key | Key containing multiple columns |
| UNIQUE Constraint | Prevents duplicate key values |

### Relationship Implementation

| Relationship | Implementation |
|---|---|
| One-to-One | Foreign Key + UNIQUE |
| One-to-Many | Foreign Key on Many side |
| Many-to-Many | Junction Table |
| Self-Referencing | Foreign Key references same table |

---

# 26. Phase 16 Completion Checklist

Before moving to Phase 17, make sure you understand:

- [ ] What is database design?
- [ ] Database schema.
- [ ] Entities and attributes.
- [ ] Primary keys.
- [ ] Foreign keys.
- [ ] Database relationships.
- [ ] One-to-One relationships.
- [ ] One-to-Many relationships.
- [ ] Many-to-Many relationships.
- [ ] Junction tables.
- [ ] Self-referencing relationships.
- [ ] ER diagrams.
- [ ] Cardinality.
- [ ] Participation.
- [ ] Natural keys.
- [ ] Surrogate keys.
- [ ] Composite keys.
- [ ] UNIQUE constraints.
- [ ] Designing an e-commerce database.
- [ ] Designing an employee management database.
- [ ] Database design best practices.

**Phase 16 is complete when you can take application requirements, identify entities and relationships, draw an ER diagram, and convert that diagram into a working relational database schema.**

---

## Next Phase: Phase 17 – Database Normalization

Normalization is a fundamental database design concept.

We will cover:

1. What is Database Normalization?
2. Why do we need Normalization?
3. Database Anomalies.
4. Insertion Anomaly.
5. Update Anomaly.
6. Deletion Anomaly.
7. First Normal Form (1NF).
8. Second Normal Form (2NF).
9. Third Normal Form (3NF).
10. Boyce-Codd Normal Form (BCNF).
11. Functional Dependencies.
12. Partial Dependencies.
13. Transitive Dependencies.
14. Candidate Keys.
15. Prime and Non-Prime Attributes.
16. Denormalization.
17. Normalization vs Denormalization.
18. Real-World Database Normalization.
19. Interview Questions and Practical Assignments.

**Next: Phase 17 – Database Normalization.**