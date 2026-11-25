# SQL Complete Learning Roadmap
# Phase 17 – Database Normalization
### MySQL 8.0+

Database Normalization is one of the most important concepts in relational database design.

It helps you organize data into properly structured tables, reduce unnecessary duplication, prevent data inconsistencies, and maintain data integrity.

For example, imagine an e-commerce application where customer details are stored repeatedly in every order.

If a customer changes their phone number, you might need to update multiple records.

This creates problems.

Normalization helps solve these problems by organizing data into related tables.

In this phase, we will study normalization from the fundamentals to advanced normal forms, with practical MySQL examples.

---

# 1. What Is Database Normalization?

**Database Normalization** is the process of organizing data in a relational database to minimize redundancy and prevent data anomalies.

It involves dividing large tables into smaller, logically related tables and defining relationships between them.

### Main Objectives

1. Reduce data duplication.
2. Improve data consistency.
3. Prevent insertion anomalies.
4. Prevent update anomalies.
5. Prevent deletion anomalies.
6. Maintain data integrity.
7. Make database structures easier to maintain.

### Example: Without Normalization

Consider this table:

**student_courses**

| student_id | student_name | course_id | course_name | instructor |
|---:|---|---:|---|---|
| 1 | Riyaz | 101 | SQL | John |
| 1 | Riyaz | 102 | JavaScript | Sarah |
| 2 | Alex | 101 | SQL | John |
| 3 | David | 103 | Python | Michael |
| 3 | David | 101 | SQL | John |

Notice:

- Riyaz's name is repeated.
- SQL is repeated.
- John is repeated.
- Student information and course information are stored together.

This creates unnecessary duplication.

### After Normalization

We can divide the data into three tables.

**students**

| student_id | student_name |
|---:|---|
| 1 | Riyaz |
| 2 | Alex |
| 3 | David |

**courses**

| course_id | course_name | instructor |
|---:|---|---|
| 101 | SQL | John |
| 102 | JavaScript | Sarah |
| 103 | Python | Michael |

**student_courses**

| student_id | course_id |
|---:|---:|
| 1 | 101 |
| 1 | 102 |
| 2 | 101 |
| 3 | 103 |
| 3 | 101 |

Now each type of information is stored in its appropriate table.

This is the basic idea of normalization.

---

# 2. Why Do We Need Normalization?

Imagine a database containing millions of customer and order records.

If customer details are repeated in every order, several problems can occur.

### Problem 1: Data Redundancy

Data redundancy means storing the same information unnecessarily in multiple places.

Example:

| order_id | customer_name | customer_email |
|---:|---|---|
| 1 | Riyaz | riyaz@example.com |
| 2 | Riyaz | riyaz@example.com |
| 3 | Riyaz | riyaz@example.com |
| 4 | Riyaz | riyaz@example.com |

The same customer information is stored four times.

### Problem 2: Data Inconsistency

Suppose Riyaz changes his email address.

You update only some records:

| order_id | customer_name | customer_email |
|---:|---|---|
| 1 | Riyaz | new@example.com |
| 2 | Riyaz | new@example.com |
| 3 | Riyaz | riyaz@example.com |
| 4 | Riyaz | riyaz@example.com |

Now the database contains inconsistent customer information.

### Problem 3: Difficult Maintenance

When the same information exists in multiple places, maintaining it becomes difficult.

Normalization reduces these problems by separating independent entities.

---

# 3. What Are Database Anomalies?

Database anomalies are problems caused by poorly structured tables and unnecessary data duplication.

There are three major types:

1. Insertion Anomaly.
2. Update Anomaly.
3. Deletion Anomaly.

These are frequently asked in SQL interviews.

Let's understand each one.

## 3.1 Insertion Anomaly

An insertion anomaly occurs when you cannot insert information without inserting unrelated information.

Example:

| student_id | student_name | course_id | course_name |
|---:|---|---:|---|
| 1 | Riyaz | 101 | SQL |
| 2 | John | 102 | JavaScript |

Suppose a new course called Python is introduced.

But no student has enrolled in it yet.

You cannot insert the course information without providing a student ID if the table requires one.

This is an insertion anomaly.

**Solution:** Separate students and courses into different tables.

## 3.2 Update Anomaly

An update anomaly occurs when the same information is stored in multiple records and must be updated everywhere.

Example:

| student_id | student_name | course_id | course_name | instructor |
|---:|---|---:|---|---|
| 1 | Riyaz | 101 | SQL | John |
| 2 | Alex | 101 | SQL | John |
| 3 | David | 101 | SQL | John |

Suppose the SQL instructor changes from John to Michael.

You must update all three records.

If you update only two records, the database becomes inconsistent.

**Solution:** Store course information separately.

## 3.3 Deletion Anomaly

A deletion anomaly occurs when deleting one record accidentally removes other information that should have been retained.

Example:

| student_id | student_name | course_id | course_name |
|---:|---|---:|---|
| 1 | Riyaz | 101 | SQL |
| 2 | John | 102 | JavaScript |
| 3 | David | 103 | Python |

Suppose David is the only student enrolled in Python.

If you delete David's enrollment record, you also lose the only stored information about the Python course.

**Solution:** Store course information independently from student enrollment information.

### Three Anomalies – Quick Revision

| Anomaly | Meaning |
|---|---|
| Insertion Anomaly | Cannot insert information without unrelated information |
| Update Anomaly | Same information must be updated in multiple places |
| Deletion Anomaly | Deleting one record unintentionally removes other information |

---

# 4. What Are Normal Forms?

Normal Forms are rules or stages used to organize relational database structures.

The most commonly discussed normal forms are:

1. First Normal Form (1NF).
2. Second Normal Form (2NF).
3. Third Normal Form (3NF).
4. Boyce-Codd Normal Form (BCNF).
5. Fourth Normal Form (4NF).
6. Fifth Normal Form (5NF).

In most application development, 1NF, 2NF, and 3NF are especially important.

BCNF and higher normal forms are useful for understanding more advanced database design.

---

# 5. First Normal Form (1NF)

**First Normal Form requires each column to contain atomic values and each row to be uniquely identifiable.**

In practical terms:

- Each cell should contain a single value.
- Avoid storing multiple values in one column.
- Avoid repeating groups of columns.
- Define a key that identifies each row.

### Example: Not in 1NF

Consider this table:

| student_id | student_name | courses |
|---:|---|---|
| 1 | Riyaz | SQL, JavaScript |
| 2 | John | Python, Java |
| 3 | Alex | SQL, Python, JavaScript |

Problem:

The `courses` column contains multiple values.

This violates the atomic-value requirement of 1NF.

### Convert to 1NF

Store one course per row.

| student_id | student_name | course |
|---:|---|---|
| 1 | Riyaz | SQL |
| 1 | Riyaz | JavaScript |
| 2 | John | Python |
| 2 | John | Java |
| 3 | Alex | SQL |
| 3 | Alex | Python |
| 3 | Alex | JavaScript |

Now every cell contains one value.

### SQL Implementation

```sql
CREATE TABLE student_courses (
    student_id INT,
    student_name VARCHAR(100),
    course_name VARCHAR(100),

    PRIMARY KEY (student_id, course_name)
);
```

Insert data:

```sql
INSERT INTO student_courses
VALUES
(1, 'Riyaz', 'SQL'),
(1, 'Riyaz', 'JavaScript'),
(2, 'John', 'Python'),
(2, 'John', 'Java'),
(3, 'Alex', 'SQL'),
(3, 'Alex', 'Python'),
(3, 'Alex', 'JavaScript');
```

### Another Example: Repeating Columns

Not in 1NF:

| student_id | phone1 | phone2 | phone3 |
|---:|---|---|---|
| 1 | 9876543210 | 9876543211 | NULL |
| 2 | 9876543212 | NULL | NULL |

This design assumes a fixed number of phone numbers.

A better design is:

**students**

| student_id | name |
|---:|---|
| 1 | Riyaz |
| 2 | John |

**student_phones**

| id | student_id | phone |
|---:|---:|---|
| 1 | 1 | 9876543210 |
| 2 | 1 | 9876543211 |
| 3 | 2 | 9876543212 |

### Important Note About Atomicity

Atomicity in 1NF is about how values are represented in the relational model.

For example, whether `full_name` should be one column or separate `first_name` and `last_name` depends on application requirements.

If you need to search, sort, or update names independently, separate columns are often more useful.

**1NF Summary:** Every cell should hold a single value, with no repeating groups.

---

# 6. Second Normal Form (2NF)

A table is in **Second Normal Form (2NF)** if:

1. It is already in 1NF.
2. Every non-prime attribute is fully functionally dependent on every candidate key.

For practical understanding, 2NF mainly eliminates **partial dependencies**.

Let's understand this carefully.

## 6.1 What Is a Composite Primary Key?

A Composite Primary Key consists of two or more columns.

Example:

```sql
PRIMARY KEY (student_id, course_id)
```

The combination uniquely identifies an enrollment.

Neither column alone necessarily identifies an enrollment.

## 6.2 What Is a Partial Dependency?

A Partial Dependency occurs when a non-key attribute depends on only part of a composite candidate key rather than the entire key.

Consider this table:

**student_courses**

| student_id | course_id | student_name | course_name | marks |
|---:|---:|---|---|---:|
| 1 | 101 | Riyaz | SQL | 90 |
| 1 | 102 | Riyaz | JavaScript | 85 |
| 2 | 101 | John | SQL | 80 |
| 2 | 103 | John | Python | 95 |

Assume the composite primary key is:

```sql
PRIMARY KEY (student_id, course_id)
```

Now analyze the columns.

| Column | Depends On |
|---|---|
| student_name | student_id |
| course_name | course_id |
| marks | student_id + course_id |

The problem:

`student_name` depends only on `student_id`.

`course_name` depends only on `course_id`.

They do not depend on the entire composite key.

These are partial dependencies.

Therefore, the table violates 2NF.

## 6.3 Convert to 2NF

Separate the data into three tables.

**students**

| student_id | student_name |
|---:|---|
| 1 | Riyaz |
| 2 | John |

**courses**

| course_id | course_name |
|---:|---|
| 101 | SQL |
| 102 | JavaScript |
| 103 | Python |

**student_courses**

| student_id | course_id | marks |
|---:|---:|---:|
| 1 | 101 | 90 |
| 1 | 102 | 85 |
| 2 | 101 | 80 |
| 2 | 103 | 95 |

Now:

- Student name depends on student ID.
- Course name depends on course ID.
- Marks depend on the combination of student ID and course ID.

There are no partial dependencies in the enrollment table.

### SQL Implementation

```sql
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);
```

```sql
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL
);
```

```sql
CREATE TABLE student_courses (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    marks DECIMAL(5,2),

    PRIMARY KEY (student_id, course_id),

    FOREIGN KEY (student_id)
        REFERENCES students(id),

    FOREIGN KEY (course_id)
        REFERENCES courses(id)
);
```

### Important Clarification

If a table has only single-column candidate keys, it cannot have a partial dependency on a proper subset of those keys.

This is why a table already in 1NF with only single-column candidate keys automatically satisfies 2NF.

**2NF Summary:** Eliminate partial dependencies on composite candidate keys.

---

# 7. What Is Functional Dependency?

Functional Dependency is one of the most important concepts behind normalization.

A functional dependency describes a relationship where one attribute or group of attributes determines another attribute.

It is written as:

\[
A \rightarrow B
\]

This means:

**A functionally determines B.**

In other words, if two rows have the same value of A, they must have the same value of B.

### Example

Consider a students table:

| student_id | student_name | email |
|---:|---|---|
| 1 | Riyaz | riyaz@example.com |
| 2 | John | john@example.com |
| 3 | Alex | alex@example.com |

Assuming student IDs are unique:

```text
student_id → student_name
student_id → email
```

This means a student ID determines the student's name and email.

### Another Example

Consider a courses table:

| course_id | course_name | instructor |
|---:|---|---|
| 101 | SQL | John |
| 102 | JavaScript | Sarah |
| 103 | Python | Michael |

Assuming each course has one assigned instructor:

```text
course_id → course_name
course_id → instructor
```

### Composite Functional Dependency

Consider:

| student_id | course_id | marks |
|---:|---:|---:|
| 1 | 101 | 90 |
| 1 | 102 | 85 |
| 2 | 101 | 80 |

Here:

```text
(student_id, course_id) → marks
```

The combination of student ID and course ID determines the marks.

Neither student ID nor course ID alone determines the marks.

### Important

Functional dependencies come from business rules and the meaning of the data.

They cannot always be inferred just by looking at a few sample records.

For example, a course may have multiple instructors in some organizations. In that case, `course_id → instructor` would not be a valid functional dependency.

---

# 8. Third Normal Form (3NF)

A table is in **Third Normal Form (3NF)** if:

1. It is already in 2NF.
2. It contains no problematic transitive dependencies.

More formally, for every non-trivial functional dependency:

\[
X \rightarrow A
\]

at least one of the following must be true:

- X is a superkey.
- A is a prime attribute.

Let's understand this through an example.

## 8.1 What Is a Transitive Dependency?

A Transitive Dependency occurs when a non-key attribute depends on another non-key attribute through a key.

Consider this table:

**employees**

| employee_id | employee_name | department_id | department_name |
|---:|---|---:|---|
| 1 | Riyaz | 10 | IT |
| 2 | John | 10 | IT |
| 3 | Sarah | 20 | HR |
| 4 | David | 20 | HR |

Assume:

```text
employee_id → department_id
department_id → department_name
```

Therefore:

```text
employee_id → department_name
```

But `department_name` depends directly on `department_id`, not independently on the employee ID.

This creates a transitive dependency.

The table violates 3NF.

## 8.2 Convert to 3NF

Create two tables.

**employees**

| employee_id | employee_name | department_id |
|---:|---|---:|
| 1 | Riyaz | 10 |
| 2 | John | 10 |
| 3 | Sarah | 20 |
| 4 | David | 20 |

**departments**

| department_id | department_name |
|---:|---|
| 10 | IT |
| 20 | HR |

### SQL Implementation

```sql
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE
);
```

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    department_id INT,

    FOREIGN KEY (department_id)
        REFERENCES departments(id)
);
```

Now department information is stored independently.

### 3NF Summary

A table should not contain non-key attributes that depend transitively on a candidate key.

---

# 9. Understanding Candidate Keys, Superkeys, Prime and Non-Prime Attributes

These concepts are essential for understanding 2NF, 3NF, and BCNF.

## 9.1 Superkey

A Superkey is any set of one or more attributes that uniquely identifies a row.

Example:

| student_id | email | name |
|---:|---|---|
| 1 | riyaz@example.com | Riyaz |
| 2 | john@example.com | John |

Assume both `student_id` and `email` are unique.

Possible superkeys include:

```text
{student_id}
{email}
{student_id, email}
{student_id, name}
{email, name}
```

A superkey can contain unnecessary attributes.

## 9.2 Candidate Key

A Candidate Key is a minimal superkey.

It uniquely identifies a row, and no attribute can be removed without losing that uniqueness.

In the previous example:

```text
{student_id}
{email}
```

are candidate keys.

But:

```text
{student_id, email}
```

is not a candidate key because either column alone is sufficient.

## 9.3 Primary Key

A Primary Key is the candidate key selected as the main identifier for the table.

A table can have multiple candidate keys but only one primary key constraint.

## 9.4 Prime Attribute

A Prime Attribute is an attribute that belongs to at least one candidate key.

## 9.5 Non-Prime Attribute

A Non-Prime Attribute is an attribute that does not belong to any candidate key.

### Example

Suppose a table has:

```text
student_id
email
student_name
phone
```

Assume:
- student_id is unique.
- email is unique.
- Neither name nor phone is guaranteed to be unique.

Candidate keys:

```text
student_id
email
```

Prime attributes:

```text
student_id
email
```

Non-prime attributes:

```text
student_name
phone
```

### Quick Revision

| Concept | Meaning |
|---|---|
| Superkey | Any attribute set that uniquely identifies a row |
| Candidate Key | Minimal superkey |
| Primary Key | Selected candidate key |
| Prime Attribute | Belongs to at least one candidate key |
| Non-Prime Attribute | Does not belong to any candidate key |

---

# 10. Boyce-Codd Normal Form (BCNF)

BCNF is a stronger version of Third Normal Form.

A relation is in BCNF if:

**For every non-trivial functional dependency X → Y, X must be a superkey.**

In simpler terms:

Every determinant must be a superkey.

A determinant is the left-hand side of a functional dependency.

### Why Do We Need BCNF?

Some tables can satisfy 3NF but still contain redundancy caused by overlapping candidate keys.

Let's understand with an example.

### Example: Student, Course and Instructor

Suppose the business rules are:

1. A student can enroll in multiple courses.
2. Each instructor teaches exactly one course.
3. A student can have multiple instructors, but only one instructor per course.

Consider this table:

| student | course | instructor |
|---|---|---|
| Riyaz | SQL | John |
| Alex | SQL | John |
| Riyaz | Python | Sarah |
| David | Python | Sarah |

Assume the following functional dependencies:

```text
(student, course) → instructor
instructor → course
```

Why?

- A student and course combination determines the instructor.
- Each instructor teaches exactly one course.

Candidate keys:

```text
(student, course)
(student, instructor)
```

The second candidate key works because an instructor determines the course.

Now examine:

```text
instructor → course
```

`instructor` is not a superkey because one instructor can teach multiple students.

Therefore, the dependency violates BCNF.

However, it can satisfy 3NF because `course` is a prime attribute: it belongs to the candidate key `(student, course)`.

This is an important example of a relation that satisfies 3NF but not BCNF.

## Convert to BCNF

Decompose the table into two relations.

**instructor_courses**

| instructor | course |
|---|---|
| John | SQL |
| Sarah | Python |

**student_instructors**

| student | instructor |
|---|---|
| Riyaz | John |
| Alex | John |
| Riyaz | Sarah |
| David | Sarah |

Now:

- Instructor determines course in the first table.
- Student and instructor determine the enrollment in the second table.

Both relations satisfy BCNF under the stated business rules.

### BCNF Summary

| 3NF | BCNF |
|---|---|
| Allows certain dependencies where the right side is a prime attribute | Requires every determinant to be a superkey |
| Less restrictive | More restrictive |
| A table may satisfy 3NF but violate BCNF | Every BCNF relation also satisfies 3NF |

**Important:** BCNF decomposition can sometimes fail to preserve all functional dependencies, even when it is lossless. Database design involves balancing these properties.

---

# 11. Fourth Normal Form (4NF)

Fourth Normal Form addresses a different type of redundancy involving **multivalued dependencies**.

A relation is in 4NF if:

1. It is in BCNF.
2. For every non-trivial multivalued dependency X ↠ Y, X must be a superkey.

The symbol:

\[
X \twoheadrightarrow Y
\]

represents a multivalued dependency.

### Example

Suppose an employee can have multiple skills and multiple languages.

These are independent facts.

Consider:

**employee_details**

| employee | skill | language |
|---|---|---|
| Riyaz | JavaScript | English |
| Riyaz | JavaScript | Hindi |
| Riyaz | Node.js | English |
| Riyaz | Node.js | Hindi |

Here:
- Riyaz has two skills.
- Riyaz knows two languages.

Because the two facts are independent, every skill gets paired with every language.

This creates unnecessary combinations.

### Convert to 4NF

Create two tables.

**employee_skills**

| employee | skill |
|---|---|
| Riyaz | JavaScript |
| Riyaz | Node.js |

**employee_languages**

| employee | language |
|---|---|
| Riyaz | English |
| Riyaz | Hindi |

Now the independent multivalued facts are stored separately.

### 4NF Summary

4NF eliminates redundancy caused by independent multivalued dependencies.

---

# 12. Fifth Normal Form (5NF)

Fifth Normal Form is also called **Project-Join Normal Form (PJNF)**.

It addresses redundancy caused by certain join dependencies.

A relation is in 5NF when every non-trivial join dependency is implied by its candidate keys.

### Understanding the Concept

Imagine a business relationship involving:

- Suppliers.
- Products.
- Projects.

A supplier may supply certain products to certain projects.

Sometimes the business rules allow a three-column relationship to be decomposed into smaller relations without losing information.

However, this must be justified by the actual join dependency.

### Example Structure

Original table:

**supplier_product_project**

| supplier | product | project |
|---|---|---|
| S1 | P1 | J1 |
| S1 | P2 | J1 |
| S2 | P1 | J2 |

In some specific business models, this relationship may be decomposed into:

- supplier_products
- supplier_projects
- product_projects

But this decomposition is valid only if the business rules guarantee that joining those three relations recreates exactly the original relationship.

Otherwise, it may create false combinations.

### 5NF Summary

5NF handles complex join dependencies and ensures that decomposition does not introduce incorrect combinations.

It is less commonly needed in ordinary application databases.

---

# 13. Comparison of Normal Forms

| Normal Form | Main Purpose | Problem Addressed |
|---|---|---|
| 1NF | Atomic values and no repeating groups | Multiple values in one cell |
| 2NF | Eliminate partial dependencies | Dependency on part of a composite candidate key |
| 3NF | Eliminate problematic transitive dependencies | Non-key attributes depending on other non-key attributes |
| BCNF | Every determinant must be a superkey | Certain remaining functional dependency anomalies |
| 4NF | Eliminate non-trivial independent multivalued dependencies | Independent multi-valued facts |
| 5NF | Eliminate problematic join dependencies | Redundancy caused by join dependencies |

### Important Relationship

```text
1NF
 ↓
2NF
 ↓
3NF
 ↓
BCNF
 ↓
4NF
 ↓
5NF
```

Each subsequent normal form generally imposes additional requirements.

---

# 14. Complete Practical Example – Normalize a Student Database

Let's normalize a database step by step.

### Initial Table – Unnormalized Data

| student_id | student_name | courses | instructor | department |
|---:|---|---|---|---|
| 1 | Riyaz | SQL, Python | John, Sarah | IT |
| 2 | Alex | SQL | John | IT |
| 3 | David | JavaScript, Python | Michael, Sarah | Development |

This table contains multiple values in columns.

It is not in 1NF.

## Step 1 – Convert to 1NF

Store one student-course combination per row.

| student_id | student_name | course | instructor | department |
|---:|---|---|---|---|
| 1 | Riyaz | SQL | John | IT |
| 1 | Riyaz | Python | Sarah | IT |
| 2 | Alex | SQL | John | IT |
| 3 | David | JavaScript | Michael | Development |
| 3 | David | Python | Sarah | Development |

Now each cell contains one value.

Assume the candidate key is:

```text
(student_id, course)
```

## Step 2 – Convert to 2NF

Identify partial dependencies:

```text
student_id → student_name
student_id → department
course → instructor
(student_id, course) → enrollment information
```

Separate independent information.

**students**

| student_id | student_name | department |
|---:|---|---|
| 1 | Riyaz | IT |
| 2 | Alex | IT |
| 3 | David | Development |

**courses**

| course | instructor |
|---|---|
| SQL | John |
| Python | Sarah |
| JavaScript | Michael |

**student_courses**

| student_id | course |
|---:|---|
| 1 | SQL |
| 1 | Python |
| 2 | SQL |
| 3 | JavaScript |
| 3 | Python |

Now partial dependencies are removed.

## Step 3 – Convert to 3NF

Look at the students table:

| student_id | student_name | department |
|---:|---|---|
| 1 | Riyaz | IT |
| 2 | Alex | IT |
| 3 | David | Development |

Suppose each department has a unique department ID and department name.

The design should separate department information.

**departments**

| department_id | department_name |
|---:|---|
| 1 | IT |
| 2 | Development |

**students**

| student_id | student_name | department_id |
|---:|---|---:|
| 1 | Riyaz | 1 |
| 2 | Alex | 1 |
| 3 | David | 2 |

Now department names are not repeated in the student table.

### Final Normalized Structure

```text
STUDENTS
--------
student_id (PK)
student_name
department_id (FK)
       |
       | N:1
       |
DEPARTMENTS
-----------
department_id (PK)
department_name


COURSES
-------
course_id (PK)
course_name
instructor_id (FK)


INSTRUCTORS
-----------
instructor_id (PK)
instructor_name


STUDENT_COURSES
---------------
student_id (FK)
course_id (FK)
```

This is a cleaner relational design.

---

# 15. What Is Denormalization?

Denormalization is the process of deliberately introducing some redundancy into a database to improve query performance or simplify data retrieval.

It is generally considered after a normalized design has been established.

### Example: Normalized Structure

**customers**

| id | name |
|---:|---|
| 1 | Riyaz |
| 2 | John |

**orders**

| id | customer_id | total_amount |
|---:|---:|---:|
| 101 | 1 | 5000 |
| 102 | 1 | 3000 |
| 103 | 2 | 7000 |

To retrieve order information with customer names, we need a JOIN.

```sql
SELECT
    o.id,
    c.name,
    o.total_amount
FROM orders o
JOIN customers c
    ON o.customer_id = c.id;
```

### Denormalized Structure

You could store customer names directly in the orders table:

| id | customer_id | customer_name | total_amount |
|---:|---:|---|---:|
| 101 | 1 | Riyaz | 5000 |
| 102 | 1 | Riyaz | 3000 |
| 103 | 2 | John | 7000 |

Now some queries require fewer joins.

However, customer names are duplicated.

If Riyaz changes his name, multiple order records may need updating.

This is the trade-off.

### When Is Denormalization Useful?

- Read-heavy applications.
- Analytics and reporting.
- Data warehouses.
- Precomputed summaries.
- Frequently accessed dashboard data.
- Performance optimization after measurement.

### Denormalization Techniques

1. Store calculated totals.
2. Maintain summary tables.
3. Duplicate selected attributes.
4. Use materialized-like summary structures maintained by jobs or application logic.
5. Create reporting tables.

**Important:** MySQL does not provide native materialized views in the same way some other database systems do. Summary tables are commonly maintained using scheduled jobs, application logic, or triggers.

---

# 16. Normalization vs Denormalization

| Normalization | Denormalization |
|---|---|
| Reduces redundancy | Intentionally introduces some redundancy |
| Improves data consistency | Can improve read performance |
| Separates independent entities | May combine or duplicate selected data |
| Often requires more JOINs | May reduce JOIN requirements |
| Easier centralized updates | Requires additional consistency management |
| Common in transactional systems | Common in analytical/read-heavy systems |

### Which One Should You Use?

For most transactional application databases:

Start with a well-normalized design, commonly around 3NF.

Then measure real performance.

Only denormalize when there is a demonstrated need and you have a strategy for keeping duplicated data consistent.

---

# 17. How to Identify Normalization Problems

When reviewing a database design, ask these questions.

### Question 1

Does any column contain multiple values?

If yes, investigate a 1NF violation.

### Question 2

Does a non-key column depend only on part of a composite candidate key?

If yes, investigate a 2NF violation.

### Question 3

Does a non-key attribute depend on another non-key attribute?

If yes, investigate a 3NF violation.

### Question 4

Does a non-superkey determine another attribute?

If yes, investigate a BCNF violation.

### Question 5

Are there independent multivalued facts stored together?

If yes, investigate a 4NF violation.

### Question 6

Can a relation be decomposed into smaller relations because of a non-trivial join dependency?

If yes, investigate a 5NF issue.

---

# 18. Lossless Decomposition and Dependency Preservation

These are important advanced concepts in normalization.

## 18.1 What Is Decomposition?

Decomposition means splitting one relation into two or more smaller relations.

Example:

Original:

```text
employee_id
employee_name
department_id
department_name
```

Decomposed into:

**employees**

```text
employee_id
employee_name
department_id
```

**departments**

```text
department_id
department_name
```

## 18.2 Lossless Decomposition

A decomposition is lossless if joining the decomposed tables recreates exactly the original relation without losing information or generating spurious rows.

In simpler words:

**After splitting a table, we should be able to reconstruct the original data correctly using JOINs.**

For a binary decomposition of a relation R into R1 and R2, a common losslessness condition is that the shared attributes functionally determine all attributes of at least one of the decomposed relations.

Example:

```text
employees.department_id
    references
departments.id
```

Joining on the department key correctly reconstructs employee and department information.

## 18.3 Dependency Preservation

A decomposition is dependency-preserving if the original functional dependencies can be enforced by checking the decomposed relations individually, without needing to join them.

This is useful because enforcing constraints across multiple tables can be difficult.

### Lossless vs Dependency Preservation

| Lossless Decomposition | Dependency Preservation |
|---|---|
| Ensures no information is lost | Ensures functional dependencies remain enforceable |
| Prevents spurious rows after reconstruction | Avoids requiring joins to validate dependencies |
| Focuses on reconstruction | Focuses on constraint enforcement |

A good database decomposition generally aims for both properties.

---

# 19. Practical MySQL Example – Create a Normalized Database

Let's implement a normalized student management database.

### Step 1 – Create Database

```sql
CREATE DATABASE normalized_student_db;

USE normalized_student_db;
```

### Step 2 – Departments

```sql
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE
);
```

### Step 3 – Students

```sql
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    department_id INT,

    FOREIGN KEY (department_id)
        REFERENCES departments(id)
);
```

### Step 4 – Instructors

```sql
CREATE TABLE instructors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);
```

### Step 5 – Courses

```sql
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL UNIQUE,
    instructor_id INT,

    FOREIGN KEY (instructor_id)
        REFERENCES instructors(id)
);
```

### Step 6 – Enrollments

```sql
CREATE TABLE enrollments (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    marks DECIMAL(5,2),

    PRIMARY KEY (student_id, course_id),

    FOREIGN KEY (student_id)
        REFERENCES students(id),

    FOREIGN KEY (course_id)
        REFERENCES courses(id),

    CHECK (marks IS NULL OR marks BETWEEN 0 AND 100)
);
```

### Step 7 – Insert Sample Data

```sql
INSERT INTO departments (department_name)
VALUES
('Computer Science'),
('Information Technology');

INSERT INTO students (name, email, department_id)
VALUES
('Riyaz', 'riyaz@example.com', 1),
('John', 'john@example.com', 2);

INSERT INTO instructors (name)
VALUES
('Sarah'),
('Michael');

INSERT INTO courses (course_name, instructor_id)
VALUES
('SQL', 1),
('JavaScript', 2);

INSERT INTO enrollments
(student_id, course_id, enrollment_date, marks)
VALUES
(1, 1, '2026-01-10', 90),
(1, 2, '2026-01-12', 85),
(2, 1, '2026-01-15', 80);
```

### Step 8 – Retrieve Combined Information

```sql
SELECT
    s.name AS student_name,
    d.department_name,
    c.course_name,
    i.name AS instructor_name,
    e.marks
FROM enrollments e

INNER JOIN students s
    ON e.student_id = s.id

INNER JOIN departments d
    ON s.department_id = d.id

INNER JOIN courses c
    ON e.course_id = c.id

LEFT JOIN instructors i
    ON c.instructor_id = i.id;
```

We have stored information in separate tables, but JOINs allow us to retrieve it together.

This is the main benefit of relational database normalization.

---

# 20. Common Normalization Mistakes

| Mistake | Correct Understanding |
|---|---|
| Thinking 1NF only means having a primary key | 1NF also requires atomic values and no repeating groups |
| Thinking 2NF applies only to composite primary keys | It concerns all candidate keys; partial dependency requires a composite candidate key |
| Confusing partial and transitive dependencies | Partial dependency is on part of a candidate key; transitive dependency involves an indirect dependency |
| Thinking every duplicate value is bad | Repeated foreign key values are normal in relational databases |
| Thinking normalization always improves performance | It improves structure and consistency, but can increase JOIN requirements |
| Thinking BCNF and 3NF are identical | BCNF has stricter determinant requirements |
| Splitting tables without understanding dependencies | Decomposition must preserve meaning and ideally be lossless |
| Denormalizing before measuring performance | Normalize first, measure, then optimize |

---

# 21. Database Normalization Interview Questions

### Beginner Level

1. What is database normalization?
2. Why do we need normalization?
3. What is data redundancy?
4. What are database anomalies?
5. Explain insertion anomaly.
6. Explain update anomaly.
7. Explain deletion anomaly.
8. What is First Normal Form?
9. What is Second Normal Form?
10. What is Third Normal Form?

### Intermediate Level

11. What is a functional dependency?
12. What is a partial dependency?
13. What is a transitive dependency?
14. What is a composite candidate key?
15. What is a superkey?
16. What is a candidate key?
17. What is a prime attribute?
18. What is a non-prime attribute?
19. What is BCNF?
20. What is the difference between 3NF and BCNF?

### Advanced Level

21. What is a multivalued dependency?
22. What is Fourth Normal Form?
23. What is Fifth Normal Form?
24. What is denormalization?
25. When should you denormalize a database?
26. What is lossless decomposition?
27. What is dependency preservation?
28. Can a table satisfy 3NF but violate BCNF?
29. Does normalization always improve query performance?
30. How would you normalize an e-commerce database?

---

# 22. Practical Assignments

Try to solve these independently.

## Assignment 1 – Identify Anomalies

Consider the following table:

| student_id | student_name | course_id | course_name | instructor |
|---:|---|---:|---|---|
| 1 | Riyaz | 101 | SQL | John |
| 2 | John | 101 | SQL | John |
| 3 | Alex | 102 | Python | Sarah |
| 4 | David | 102 | Python | Sarah |

Tasks:

1. Identify data redundancy.
2. Explain the insertion anomaly.
3. Explain the update anomaly.
4. Explain the deletion anomaly.
5. Design a better database structure.

## Assignment 2 – Convert to 1NF

Consider:

| student_id | name | courses |
|---:|---|---|
| 1 | Riyaz | SQL, Python |
| 2 | John | Java, JavaScript |
| 3 | Alex | SQL, JavaScript |

Tasks:

1. Identify why the table violates 1NF.
2. Convert it into 1NF.
3. Define an appropriate primary key.

## Assignment 3 – Convert to 2NF

Consider:

| student_id | course_id | student_name | course_name | marks |
|---:|---:|---|---|---:|
| 1 | 101 | Riyaz | SQL | 90 |
| 1 | 102 | Riyaz | Python | 85 |
| 2 | 101 | John | SQL | 80 |

Assume the composite key is:

```text
(student_id, course_id)
```

Tasks:

1. Identify the partial dependencies.
2. Identify the attributes dependent on student_id.
3. Identify the attributes dependent on course_id.
4. Identify the attributes dependent on the complete key.
5. Decompose the table into 2NF.

## Assignment 4 – Convert to 3NF

Consider:

| employee_id | employee_name | department_id | department_name |
|---:|---|---:|---|
| 1 | Riyaz | 10 | IT |
| 2 | John | 10 | IT |
| 3 | Sarah | 20 | HR |

Tasks:

1. Identify the functional dependencies.
2. Identify the transitive dependency.
3. Convert the table into 3NF.
4. Create the required MySQL tables.
5. Write a JOIN query to retrieve the original information.

## Assignment 5 – Advanced Normalization

1. Explain the difference between 3NF and BCNF.
2. Create an example of a table that satisfies 3NF but violates BCNF.
3. Explain multivalued dependencies.
4. Convert a suitable table into 4NF.
5. Explain join dependencies.
6. Explain 5NF.
7. Explain lossless decomposition.
8. Explain dependency preservation.
9. Compare normalization and denormalization.
10. Design a normalized e-commerce database.

---

# 23. Phase 17 – Quick Revision Sheet

| Concept | Definition |
|---|---|
| Normalization | Organizing database tables to reduce redundancy and anomalies |
| Data Redundancy | Unnecessary duplication of information |
| Insertion Anomaly | Difficulty inserting information independently |
| Update Anomaly | Inconsistent updates to duplicated information |
| Deletion Anomaly | Unintended loss of information after deletion |
| 1NF | Atomic values and no repeating groups |
| 2NF | 1NF + no partial dependencies of non-prime attributes |
| 3NF | 2NF + no problematic transitive dependencies |
| BCNF | Every determinant must be a superkey |
| 4NF | Eliminates non-trivial independent multivalued dependencies |
| 5NF | Handles non-trivial join dependencies |
| Functional Dependency | One attribute set determines another |
| Partial Dependency | Attribute depends on part of a candidate key |
| Transitive Dependency | Indirect dependency through another attribute |
| Candidate Key | Minimal superkey |
| Superkey | Attribute set that uniquely identifies rows |
| Prime Attribute | Attribute belonging to at least one candidate key |
| Non-Prime Attribute | Attribute not belonging to any candidate key |
| Denormalization | Deliberately introducing redundancy for a justified purpose |
| Lossless Decomposition | Splitting tables without losing information |
| Dependency Preservation | Maintaining functional dependencies after decomposition |

### Remember These Rules

**1NF:**

```text
Each cell contains a single value.
```

**2NF:**

```text
1NF + No partial dependencies of non-prime attributes.
```

**3NF:**

```text
2NF + For every non-trivial X → A,
X is a superkey or A is a prime attribute.
```

**BCNF:**

```text
For every non-trivial X → Y,
X must be a superkey.
```

**4NF:**

```text
BCNF + Every non-trivial multivalued dependency
must have a superkey as its determinant.
```

**5NF:**

```text
Every non-trivial join dependency must be
implied by candidate keys.
```

---

# 24. Phase 17 Completion Checklist

Before moving to Phase 18, make sure you understand:

- [ ] What is database normalization?
- [ ] Why do we need normalization?
- [ ] Data redundancy.
- [ ] Insertion anomaly.
- [ ] Update anomaly.
- [ ] Deletion anomaly.
- [ ] First Normal Form (1NF).
- [ ] Second Normal Form (2NF).
- [ ] Third Normal Form (3NF).
- [ ] Functional dependencies.
- [ ] Partial dependencies.
- [ ] Transitive dependencies.
- [ ] Superkeys.
- [ ] Candidate keys.
- [ ] Prime and non-prime attributes.
- [ ] Boyce-Codd Normal Form (BCNF).
- [ ] Fourth Normal Form (4NF).
- [ ] Fifth Normal Form (5NF).
- [ ] Normalization vs Denormalization.
- [ ] Lossless decomposition.
- [ ] Dependency preservation.
- [ ] Practical database normalization.

**Phase 17 is complete when you can take an unnormalized table, identify its functional dependencies, detect anomalies, and decompose it into properly normalized relational tables.**

---

## Next Phase: Phase 18 – Indexing and Query Optimization

This is a particularly important phase for backend developers because database performance becomes critical as application data grows.

We will cover:

1. What Are Database Indexes?
2. Why Do We Need Indexes?
3. How Indexes Work.
4. Primary Indexes.
5. Secondary Indexes.
6. Clustered Indexes.
7. Non-Clustered Indexes.
8. Unique Indexes.
9. Composite Indexes.
10. Full-Text Indexes.
11. Indexing Foreign Keys.
12. B-Tree Data Structure.
13. Index Selectivity and Cardinality.
14. EXPLAIN.
15. EXPLAIN ANALYZE.
16. Query Optimization.
17. Covering Indexes.
18. Index Condition Pushdown.
19. When Not to Use Indexes.
20. Slow Query Optimization.
21. MySQL Performance Best Practices.
22. Interview Questions and Practical Assignments.

**Next: Phase 18 – Indexing and Query Optimization.**