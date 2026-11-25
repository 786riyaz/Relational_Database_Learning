# SQL Complete Course – Phase 4
# SQL Data Types (Complete Guide)

**Level:** Beginner  
**Phase:** 4 of 25  
**Database:** MySQL 8.0+  
**Goal:** Understand all major MySQL data types, their storage requirements, limitations, differences, and practical use cases.

Data types are one of the most important concepts in database design.

Whenever you create a table, you must define the data type of each column.

For example:

```sql
CREATE TABLE employees (
    id INT,
    name VARCHAR(100),
    age INT,
    salary DECIMAL(10,2),
    joining_date DATE
);
```

Here:
- `id` stores integer values.
- `name` stores text.
- `age` stores integer values.
- `salary` stores decimal numbers.
- `joining_date` stores dates.

Let's understand everything in detail.

---

# 1. What are Data Types?

A **Data Type** defines what kind of values a database column can store.

It determines:

1. What type of data can be stored.
2. The range of acceptable values.
3. How much storage may be required.
4. How MySQL processes and interprets the values.

### Example

```sql
CREATE TABLE students (
    id INT,
    name VARCHAR(100),
    age INT,
    fees DECIMAL(10,2),
    admission_date DATE
);
```

| Column | Data Type | Stored Value |
|---|---|---|
| id | INT | 101 |
| name | VARCHAR(100) | Riyaz |
| age | INT | 25 |
| fees | DECIMAL(10,2) | 25000.50 |
| admission_date | DATE | 2026-11-25 |

### Why are Data Types Important?

Choosing appropriate data types helps:

- Maintain data accuracy.
- Prevent invalid values.
- Reduce storage consumption.
- Improve query performance.
- Maintain data integrity.
- Make database structures easier to understand.

---

# 2. Categories of MySQL Data Types

MySQL data types are broadly divided into these categories.

| Category | Purpose | Examples |
|---|---|---|
| Numeric | Store numbers | INT, BIGINT, DECIMAL |
| String | Store text | CHAR, VARCHAR, TEXT |
| Date and Time | Store dates and times | DATE, TIME, DATETIME |
| Binary | Store binary data | BINARY, VARBINARY, BLOB |
| Spatial | Store geographical data | POINT, LINESTRING, POLYGON |
| JSON | Store JSON documents | JSON |

We'll cover the major categories individually.

---

# 3. Integer Data Types

Integer data types are used to store whole numbers without decimal values.

Examples:

```text
10
100
-50
5000
```

MySQL provides several integer data types.

- TINYINT
- SMALLINT
- MEDIUMINT
- INT
- BIGINT

Let's understand them.

## 3.1 TINYINT

`TINYINT` is used to store small integer values.

Storage:

```text
1 Byte = 8 Bits
```

Range:

| Type | Minimum | Maximum |
|---|---:|---:|
| TINYINT SIGNED | -128 | 127 |
| TINYINT UNSIGNED | 0 | 255 |

Example:

```sql
CREATE TABLE products (
    id TINYINT
);
```

Insert:

```sql
INSERT INTO products VALUES (100);
```

This works.

But:

```sql
INSERT INTO products VALUES (200);
```

This fails in strict SQL mode because 200 exceeds the signed TINYINT maximum.

### Real-world Usage

TINYINT can be useful for:
- Small counters.
- Small numeric categories.
- Compact status codes.

---

## 3.2 SMALLINT

`SMALLINT` stores a larger range of integers than TINYINT.

Storage:

```text
2 Bytes
```

Range:

| Type | Minimum | Maximum |
|---|---:|---:|
| SMALLINT SIGNED | -32768 | 32767 |
| SMALLINT UNSIGNED | 0 | 65535 |

Example:

```sql
CREATE TABLE inventory (
    quantity SMALLINT UNSIGNED
);
```

This is suitable when the quantity cannot be negative and doesn't need a range beyond 65535.

---

## 3.3 MEDIUMINT

`MEDIUMINT` is a MySQL-specific integer type.

Storage:

```text
3 Bytes
```

Range:

| Type | Minimum | Maximum |
|---|---:|---:|
| MEDIUMINT SIGNED | -8388608 | 8388607 |
| MEDIUMINT UNSIGNED | 0 | 16777215 |

Example:

```sql
CREATE TABLE visitors (
    visitor_count MEDIUMINT UNSIGNED
);
```

It provides a range between SMALLINT and INT.

---

## 3.4 INT / INTEGER

`INT` is one of the most commonly used integer data types.

Storage:

```text
4 Bytes
```

Range:

| Type | Minimum | Maximum |
|---|---:|---:|
| INT SIGNED | -2147483648 | 2147483647 |
| INT UNSIGNED | 0 | 4294967295 |

Example:

```sql
CREATE TABLE employees (
    id INT,
    age INT
);
```

### Real-world Usage

- Employee IDs.
- Product IDs.
- Order IDs.
- Customer IDs.
- Quantity.
- Counters.

For many normal application tables, INT is sufficient for numeric identifiers.

---

## 3.5 BIGINT

`BIGINT` stores very large integer values.

Storage:

```text
8 Bytes
```

Range:

| Type | Minimum | Maximum |
|---|---:|---:|
| BIGINT SIGNED | -9223372036854775808 | 9223372036854775807 |
| BIGINT UNSIGNED | 0 | 18446744073709551615 |

Example:

```sql
CREATE TABLE transactions (
    transaction_id BIGINT
);
```

### Real-world Usage

- Large transaction IDs.
- Very large counters.
- High-volume event identifiers.
- Large numeric values.

---

# 4. Signed vs Unsigned

This is an important concept in MySQL.

### Signed

A signed integer can store both positive and negative numbers.

Example:

```sql
CREATE TABLE employees (
    age INT
);
```

Possible values include:

```text
-10
0
25
100
```

### Unsigned

An unsigned integer can store only non-negative numbers.

Example:

```sql
CREATE TABLE products (
    quantity INT UNSIGNED
);
```

Possible values:

```text
0
10
100
500
```

Negative values are not allowed.

### Comparison

For INT:

| Feature | Signed INT | Unsigned INT |
|---|---:|---:|
| Storage | 4 bytes | 4 bytes |
| Minimum | -2147483648 | 0 |
| Maximum | 2147483647 | 4294967295 |

**Important:** UNSIGNED does not reduce storage requirements. It changes the available value range.

### When Should We Use UNSIGNED?

Use it when negative values are logically invalid.

Examples:

```sql
age INT UNSIGNED,
quantity INT UNSIGNED,
total_views BIGINT UNSIGNED
```

However, remember that an integer identifier does not necessarily need to be unsigned. Choose based on your application requirements.

---

# 5. DECIMAL Data Type

`DECIMAL` is used to store exact fixed-point numeric values.

It is particularly useful when decimal precision matters.

Examples:

- Product prices.
- Employee salaries.
- Bank balances.
- Tax amounts.
- Financial calculations.

### Syntax

```sql
DECIMAL(M, D)
```

Where:

- M = Maximum total number of digits.
- D = Number of digits after the decimal point.

Example:

```sql
CREATE TABLE products (
    price DECIMAL(10,2)
);
```

This means:

- Maximum digits = 10.
- Decimal digits = 2.
- Digits before decimal = 8.

Example valid values:

```text
100.50
5000.99
99999999.99
```

### Example

```sql
CREATE TABLE bank_accounts (
    account_id INT,
    balance DECIMAL(15,2)
);
```

Insert:

```sql
INSERT INTO bank_accounts
VALUES (1, 25000.75);
```

### Why DECIMAL Instead of FLOAT?

Because DECIMAL stores exact decimal values within its defined precision.

FLOAT and DOUBLE use approximate binary floating-point representations.

For financial data, DECIMAL is generally preferred.

---

# 6. FLOAT Data Type

`FLOAT` stores approximate floating-point numbers using 4 bytes in MySQL.

It supports decimal values, but precision is not exact.

Example:

```sql
CREATE TABLE measurements (
    temperature FLOAT
);
```

Insert:

```sql
INSERT INTO measurements
VALUES (36.75);
```

### Characteristics

- Uses approximately 4 bytes.
- Supports fractional values.
- Uses approximate floating-point representation.
- Suitable for measurements where small precision differences are acceptable.

### Real-world Usage

- Temperature measurements.
- Sensor readings.
- Scientific measurements.
- Certain statistical calculations.

---

# 7. DOUBLE Data Type

`DOUBLE` stores approximate floating-point numbers with greater precision than FLOAT.

Storage:

```text
8 Bytes
```

Example:

```sql
CREATE TABLE scientific_data (
    measurement DOUBLE
);
```

### FLOAT vs DOUBLE vs DECIMAL

| Feature | FLOAT | DOUBLE | DECIMAL |
|---|---|---|---|
| Storage | 4 bytes | 8 bytes | Depends on precision |
| Precision | Approximate | Approximate, higher than FLOAT | Exact decimal representation |
| Suitable for money | No | No | Yes |
| Suitable for scientific data | Yes | Yes | Sometimes |
| Performance | Often efficient | Often efficient | Depends on operation |

### Important Interview Question

**Why should we not use FLOAT or DOUBLE for financial calculations?**

Because floating-point values can contain representation and rounding errors.

For example, a mathematical decimal value may not have an exact binary floating-point representation.

DECIMAL is generally the better choice for financial values.

---

# 8. String Data Types

String data types are used to store text and character-based information.

MySQL provides:

- CHAR
- VARCHAR
- TINYTEXT
- TEXT
- MEDIUMTEXT
- LONGTEXT

Let's understand them.

---

## 8.1 CHAR

`CHAR` is a fixed-length string data type.

Syntax:

```sql
CHAR(N)
```

Example:

```sql
CREATE TABLE countries (
    country_code CHAR(2)
);
```

Insert:

```sql
INSERT INTO countries
VALUES ('IN');
```

### How Does CHAR Work?

Suppose you define:

```sql
CHAR(10)
```

It can store a string of up to 10 characters.

If you insert:

```text
HELLO
```

MySQL stores it in a fixed-length CHAR field, padding it with spaces as necessary.

### Characteristics

- Fixed maximum length.
- Maximum length is 255 characters.
- Trailing spaces are generally removed when values are retrieved.
- Suitable for fixed-length values.

### Real-world Usage

- Country codes.
- State codes.
- Fixed-format identifiers.

---

## 8.2 VARCHAR

`VARCHAR` is a variable-length string data type.

Syntax:

```sql
VARCHAR(N)
```

Example:

```sql
CREATE TABLE employees (
    name VARCHAR(100),
    email VARCHAR(150)
);
```

Suppose:

```sql
name VARCHAR(100)
```

You insert:

```text
Riyaz
```

MySQL stores the actual string length along with length metadata rather than padding the value to 100 characters.

### Characteristics

- Variable-length storage.
- Maximum declared length is 65,535 bytes, subject to row-size and character-set limits.
- Requires length metadata.
- Suitable for strings with varying lengths.

### Real-world Usage

- Names.
- Emails.
- Mobile numbers.
- Addresses.
- Product names.

---

# 9. CHAR vs VARCHAR

This is a very common SQL interview question.

| Feature | CHAR | VARCHAR |
|---|---|---|
| Storage | Fixed-length | Variable-length |
| Length | Fixed | Variable |
| Padding | Space-padded | No fixed-width padding |
| Maximum declared length | 255 characters | Subject to byte and row limits |
| Best for | Fixed-length values | Variable-length values |

### Example

```sql
CREATE TABLE users (
    country_code CHAR(2),
    name VARCHAR(100)
);
```

Here:

- `country_code` is a good candidate for CHAR.
- `name` is a good candidate for VARCHAR.

### Which One Is Better?

Neither is universally better.

Choose based on the expected data.

Use CHAR when values are consistently fixed-length.

Use VARCHAR when values have varying lengths.

---

# 10. TEXT Data Types

TEXT data types are used to store relatively large text content.

MySQL provides four major TEXT types.

| Type | Maximum Storage Capacity |
|---|---:|
| TINYTEXT | 255 bytes |
| TEXT | 65,535 bytes |
| MEDIUMTEXT | 16,777,215 bytes |
| LONGTEXT | 4,294,967,295 bytes |

These are byte limits, not necessarily character limits.

Actual character capacity depends on the character set.

### TINYTEXT

```sql
CREATE TABLE messages (
    short_message TINYTEXT
);
```

### TEXT

```sql
CREATE TABLE articles (
    content TEXT
);
```

### MEDIUMTEXT

```sql
CREATE TABLE documents (
    content MEDIUMTEXT
);
```

### LONGTEXT

```sql
CREATE TABLE large_documents (
    content LONGTEXT
);
```

### Real-world Usage

| Type | Example |
|---|---|
| TINYTEXT | Small text descriptions |
| TEXT | Blog content |
| MEDIUMTEXT | Large articles or documents |
| LONGTEXT | Very large text content |

**Important:** These types have different storage and indexing characteristics. Don't automatically choose LONGTEXT just because it supports more data.

---

# 11. VARCHAR vs TEXT

Another important interview question.

| Feature | VARCHAR | TEXT |
|---|---|---|
| Purpose | Variable-length strings | Larger text content |
| Maximum capacity | Up to declared length and row limits | Depends on TEXT variant |
| Default value | Supported in modern MySQL | Restrictions differ by MySQL version |
| Indexing | Can be indexed | Indexing generally requires a prefix length |
| Typical usage | Names, emails, titles | Articles, descriptions, large content |

### Example

```sql
CREATE TABLE blog_posts (
    id INT,
    title VARCHAR(255),
    content TEXT
);
```

Here:

- `title` uses VARCHAR.
- `content` uses TEXT.

---

# 12. Date and Time Data Types

Date and time data types store temporal information.

MySQL provides:

- DATE
- TIME
- DATETIME
- TIMESTAMP
- YEAR

Let's understand them individually.

## 12.1 DATE

Stores a calendar date.

Format:

```text
YYYY-MM-DD
```

Example:

```sql
CREATE TABLE employees (
    joining_date DATE
);
```

Insert:

```sql
INSERT INTO employees
VALUES ('2026-11-25');
```

Stored value:

```text
2026-11-25
```

It does not store the time.

---

## 12.2 TIME

Stores a time value.

Format:

```text
HH:MM:SS
```

Example:

```sql
CREATE TABLE attendance (
    check_in TIME
);
```

Insert:

```sql
INSERT INTO attendance
VALUES ('09:30:00');
```

It can also represent elapsed time values, including values outside the normal 00:00–23:59 clock range.

---

## 12.3 DATETIME

Stores both date and time.

Format:

```text
YYYY-MM-DD HH:MM:SS
```

Example:

```sql
CREATE TABLE orders (
    order_date DATETIME
);
```

Insert:

```sql
INSERT INTO orders
VALUES ('2026-11-25 14:30:00');
```

### Characteristics

- Stores date and time.
- Supports fractional seconds.
- Does not automatically convert values according to the session time zone.
- Useful for recording business events with local or explicitly defined time semantics.

---

## 12.4 TIMESTAMP

`TIMESTAMP` also stores date and time.

Example:

```sql
CREATE TABLE logs (
    created_at TIMESTAMP
);
```

### Important Characteristics

- Supports automatic initialization and updating when configured.
- Values are converted between the session time zone and UTC for storage and retrieval.
- Has a more limited date range than DATETIME.

### Example

```sql
CREATE TABLE users (
    id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

When a row is inserted without specifying `created_at`, MySQL automatically uses the current timestamp.

---

## 12.5 YEAR

Stores a year value.

Example:

```sql
CREATE TABLE academic_years (
    graduation_year YEAR
);
```

Insert:

```sql
INSERT INTO academic_years
VALUES (2026);
```

MySQL YEAR supports the range 1901–2155 and the special value 0000.

---

# 13. DATE vs TIME vs DATETIME vs TIMESTAMP

Very important comparison.

| Feature | DATE | TIME | DATETIME | TIMESTAMP |
|---|---|---|---|---|
| Stores date | Yes | No | Yes | Yes |
| Stores time | No | Yes | Yes | Yes |
| Format | YYYY-MM-DD | HH:MM:SS | YYYY-MM-DD HH:MM:SS | YYYY-MM-DD HH:MM:SS |
| Time zone conversion | No | No | No | Yes |
| Automatic current value | No | No | Available with defaults | Available with defaults |
| Typical use | Birth date | Check-in time | Order date | Event timestamps |

### When Should We Use Which?

**DATE**

```sql
date_of_birth DATE
```

**TIME**

```sql
office_check_in TIME
```

**DATETIME**

```sql
appointment_date DATETIME
```

**TIMESTAMP**

```sql
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

### Important Backend Developer Concept

When building applications used across multiple time zones, timestamp handling becomes important.

For example:

Suppose a user in India creates an order at 10:00 AM.

Another user in the USA views the same order.

The application must decide whether to display the event in the original business time zone or the viewer's local time zone.

This requires a consistent time-zone strategy.

---

# 14. Boolean Data Type

MySQL supports `BOOL` and `BOOLEAN` as aliases for `TINYINT(1)`.

Example:

```sql
CREATE TABLE users (
    id INT,
    is_active BOOLEAN
);
```

Insert:

```sql
INSERT INTO users
VALUES
(1, TRUE),
(2, FALSE);
```

Internally, the values are represented as:

| Value | Stored Numeric Representation |
|---|---:|
| TRUE | 1 |
| FALSE | 0 |

### Example

```sql
SELECT * FROM users;
```

Illustrative output:

| id | is_active |
|---:|---:|
| 1 | 1 |
| 2 | 0 |

### Important

MySQL does not have a separate native Boolean storage type.

`BOOLEAN` is an alias for `TINYINT(1)`.

Also, `TINYINT(1)` does not restrict the column to only 0 and 1. Use a suitable constraint if you need to enforce that restriction.

Example:

```sql
CREATE TABLE users (
    id INT,
    is_active BOOLEAN,
    CHECK (is_active IN (0, 1))
);
```

---

# 15. ENUM Data Type

`ENUM` is used when a column can contain one value from a predefined list.

Example:

Suppose an order can have only these statuses:

- pending
- processing
- shipped
- delivered
- cancelled

You can use ENUM.

### Syntax

```sql
ENUM('value1', 'value2', 'value3')
```

### Example

```sql
CREATE TABLE orders (
    id INT,
    status ENUM(
        'pending',
        'processing',
        'shipped',
        'delivered',
        'cancelled'
    )
);
```

Insert:

```sql
INSERT INTO orders
VALUES (1, 'pending');
```

Another:

```sql
INSERT INTO orders
VALUES (2, 'shipped');
```

### Characteristics

- Allows one value from the predefined list.
- Stores an internal numeric index for each listed value.
- Can reduce storage compared with storing longer strings.
- Values must match the allowed list, subject to SQL mode and special ENUM behavior.

### Invalid Example

```sql
INSERT INTO orders
VALUES (3, 'unknown');
```

In strict SQL mode, this generates an error.

Without strict mode, MySQL may store the special empty ENUM value.

### Real-world Usage

- Order status.
- User status.
- Payment status.
- Priority levels.

### Important Design Consideration

ENUM is useful for small, stable sets of values.

If statuses need to be managed dynamically or contain additional metadata, a separate lookup table may be a better design.

---

# 16. SET Data Type

`SET` is similar to ENUM, but it allows multiple values from a predefined list.

### Example

Suppose an employee can have multiple skills:

- JavaScript
- Node.js
- SQL
- React

We can define:

```sql
CREATE TABLE employees (
    id INT,
    skills SET(
        'JavaScript',
        'Node.js',
        'SQL',
        'React'
    )
);
```

Insert:

```sql
INSERT INTO employees
VALUES (
    1,
    'JavaScript,Node.js,SQL'
);
```

The employee has three skills.

### ENUM vs SET

| Feature | ENUM | SET |
|---|---|---|
| Values allowed | One | Multiple |
| Predefined values | Yes | Yes |
| Example | Order status | Employee skills |
| Maximum listed members | 65,535 | 64 |

### Important

Although SET supports multiple values, it is not usually the best choice for complex many-to-many relationships.

For example, in a real employee management system, employee skills should generally be stored in a separate skills table connected through a junction table.

We'll study these relationships in Phase 16.

---

# 17. Binary Data Types

Binary data types store binary strings rather than character strings.

MySQL provides:

- BINARY
- VARBINARY
- TINYBLOB
- BLOB
- MEDIUMBLOB
- LONGBLOB

## 17.1 BINARY

Stores fixed-length binary data.

Example:

```sql
CREATE TABLE binary_data (
    code BINARY(4)
);
```

## 17.2 VARBINARY

Stores variable-length binary data.

Example:

```sql
CREATE TABLE files (
    file_hash VARBINARY(64)
);
```

## 17.3 BLOB

BLOB stands for Binary Large Object.

It is used to store binary content such as:

- Images.
- Files.
- Documents.
- Audio data.

### BLOB Types

| Type | Maximum Storage Capacity |
|---|---:|
| TINYBLOB | 255 bytes |
| BLOB | 65,535 bytes |
| MEDIUMBLOB | 16,777,215 bytes |
| LONGBLOB | 4,294,967,295 bytes |

### Example

```sql
CREATE TABLE documents (
    id INT,
    file_data LONGBLOB
);
```

### Should We Store Images Directly in MySQL?

It depends on the application.

For many web applications, a common architecture is:

1. Upload images to cloud storage.
2. Store the image URL or storage key in MySQL.
3. Retrieve the URL when displaying the image.

Example:

```sql
CREATE TABLE products (
    id INT,
    name VARCHAR(100),
    image_url VARCHAR(500)
);
```

This is often easier to scale and manage than storing all files directly in the database.

---

# 18. JSON Data Type

MySQL provides a native JSON data type.

It is used to store JSON documents.

Example:

```sql
CREATE TABLE user_profiles (
    id INT,
    profile JSON
);
```

Insert:

```sql
INSERT INTO user_profiles
VALUES (
    1,
    '{"name":"Riyaz","age":25,"city":"Ahmedabad"}'
);
```

Retrieve:

```sql
SELECT * FROM user_profiles;
```

### Extract JSON Values

Use `JSON_EXTRACT()`.

```sql
SELECT JSON_EXTRACT(profile, '$.name')
FROM user_profiles;
```

Expected result:

```text
"Riyaz"
```

You can also use the `->` operator:

```sql
SELECT profile->'$.name'
FROM user_profiles;
```

Or the unquoted extraction operator:

```sql
SELECT profile->>'$.name'
FROM user_profiles;
```

Expected result:

```text
Riyaz
```

### Real-world Usage

- Flexible user settings.
- Application metadata.
- Configurations.
- Dynamic attributes.

### Important

Just because MySQL supports JSON doesn't mean every column should use JSON.

Use regular relational columns when the data is structured and frequently queried or needs relational constraints.

---

# 19. Spatial Data Types

MySQL also supports spatial data types used for geographical information.

Examples:

- GEOMETRY
- POINT
- LINESTRING
- POLYGON
- MULTIPOINT
- MULTILINESTRING
- MULTIPOLYGON
- GEOMETRYCOLLECTION

### Example: POINT

A POINT represents a location using coordinates.

```sql
CREATE TABLE locations (
    id INT,
    coordinates POINT
);
```

Example use cases:

- Store locations.
- Delivery tracking.
- Geographic applications.
- Mapping systems.
- Distance calculations.

We'll not go deeply into spatial SQL in this course, but you should know these types exist.

---

# 20. Choosing the Correct Data Type

Now let's apply what we've learned.

Suppose we're designing an Employee Management System.

Consider this table:

```sql
CREATE TABLE employees (
    id INT UNSIGNED,
    name VARCHAR(100),
    email VARCHAR(150),
    age TINYINT UNSIGNED,
    salary DECIMAL(12,2),
    is_active BOOLEAN,
    joining_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT
);
```

Why did we select these data types?

| Column | Data Type | Reason |
|---|---|---|
| id | INT UNSIGNED | Non-negative employee identifier |
| name | VARCHAR(100) | Variable-length name |
| email | VARCHAR(150) | Variable-length email |
| age | TINYINT UNSIGNED | Small non-negative integer |
| salary | DECIMAL(12,2) | Exact decimal financial value |
| is_active | BOOLEAN | Binary status |
| joining_date | DATE | Calendar date |
| created_at | TIMESTAMP | Event timestamp |
| description | TEXT | Longer text |

### Important Design Rules

1. Use INT for ordinary integer values.
2. Use BIGINT when a larger integer range is required.
3. Use DECIMAL for financial values.
4. Use VARCHAR for variable-length text.
5. Use CHAR for fixed-length text.
6. Use DATE for dates without time.
7. Use DATETIME or TIMESTAMP according to your time-zone requirements.
8. Use BOOLEAN for true/false flags.
9. Use JSON for genuinely flexible document data.
10. Avoid oversized data types without a reason.

---

# 21. Important Interview Questions

Try answering these questions yourself.

### Basic Questions

1. What is a data type?
2. Why do we need data types in SQL?
3. What are the main categories of MySQL data types?
4. What is the difference between INT and BIGINT?
5. What is TINYINT?
6. What is the difference between signed and unsigned?
7. What is DECIMAL?
8. What is the difference between FLOAT and DOUBLE?
9. Why should we use DECIMAL for financial data?
10. What is the difference between CHAR and VARCHAR?

### Intermediate Questions

11. What is the difference between VARCHAR and TEXT?
12. What is the maximum capacity of TEXT?
13. What is the difference between DATE and DATETIME?
14. What is the difference between DATETIME and TIMESTAMP?
15. What is the default storage size of INT?
16. What is the purpose of BOOLEAN?
17. Does MySQL have a native Boolean storage type?
18. What is ENUM?
19. What is SET?
20. What is the difference between ENUM and SET?

### Advanced Questions

21. What is BLOB?
22. What is the difference between BLOB and TEXT?
23. What is the JSON data type?
24. Can we store JSON in MySQL?
25. What are spatial data types?
26. Why should we not use FLOAT for financial calculations?
27. How does VARCHAR differ from CHAR in storage?
28. What is the difference between binary and character string data?
29. Why should we choose appropriate data types?
30. What happens when we insert a value outside the supported range of an integer column?

---

# 22. Practical Assignments

Complete these exercises using MySQL Workbench or MySQL CLI.

## Assignment 1: Create a Student Table

Create a table called `students` with the following columns:

| Column | Required Data Type |
|---|---|
| id | INT |
| name | VARCHAR(100) |
| email | VARCHAR(150) |
| age | TINYINT UNSIGNED |
| fees | DECIMAL(10,2) |
| is_active | BOOLEAN |
| admission_date | DATE |
| created_at | TIMESTAMP |

## Assignment 2: Create an E-commerce Product Table

Create a table called `products` with:

| Column | Required Data Type |
|---|---|
| id | INT |
| name | VARCHAR(150) |
| description | TEXT |
| price | DECIMAL(12,2) |
| quantity | INT UNSIGNED |
| sku | CHAR(10) |
| status | ENUM |
| created_at | DATETIME |

For `status`, use these values:

```text
available
out_of_stock
discontinued
```

## Assignment 3: Create an Employee Table

Create a table called `employees` with:

| Column | Required Data Type |
|---|---|
| id | BIGINT |
| name | VARCHAR(100) |
| email | VARCHAR(150) |
| salary | DECIMAL(12,2) |
| skills | SET |
| joining_date | DATE |
| is_active | BOOLEAN |
| profile_data | JSON |

For `skills`, use:

```text
JavaScript
Node.js
React
SQL
MongoDB
```

## Assignment 4: Conceptual Questions

Answer these:

1. Which data type would you use to store a mobile number? Why?
2. Which data type would you use to store a product price?
3. Which data type would you use to store a person's birth date?
4. Which data type would you use to store an employee's joining date and time?
5. Which data type would you use to store a blog article?
6. Which data type would you use to store a user's active/inactive status?
7. Which data type would you use to store a product's multiple images? Explain your design.
8. Why shouldn't we use INT for storing mobile numbers?
9. Why is DECIMAL preferred over FLOAT for financial data?
10. When would you choose BIGINT instead of INT?

---

# 23. Phase 4 Quick Revision Sheet

| Data Type | Storage | Typical Usage |
|---|---:|---|
| TINYINT | 1 byte | Small integers |
| SMALLINT | 2 bytes | Small numeric values |
| MEDIUMINT | 3 bytes | Medium-sized integers |
| INT | 4 bytes | IDs, counters |
| BIGINT | 8 bytes | Large integers |
| DECIMAL | Variable | Money, financial values |
| FLOAT | 4 bytes | Approximate measurements |
| DOUBLE | 8 bytes | Higher-precision approximate measurements |
| CHAR | Depends on length and character set | Fixed-length strings |
| VARCHAR | Depends on length and character set | Variable-length strings |
| TINYTEXT | Up to 255 bytes | Small text |
| TEXT | Up to 65,535 bytes | Articles |
| MEDIUMTEXT | Up to 16 MB | Larger text |
| LONGTEXT | Up to 4 GB | Very large text |
| DATE | 3 bytes | Calendar dates |
| TIME | 3 bytes | Time or duration |
| DATETIME | 5–8 bytes | Date and time |
| TIMESTAMP | 4–7 bytes | Time-zone-aware timestamps |
| YEAR | 1 byte | Year |
| BOOLEAN | Alias of TINYINT(1) | True/false flags |
| BLOB | Depends on variant | Binary data |
| JSON | Depends on content | JSON documents |

*Storage sizes above are MySQL's nominal type storage sizes; actual row storage can include additional metadata, variable-length overhead, and other implementation details.*

---

# 24. Phase 4 Completion Checklist

| No. | Topic | Status |
|---|---|---|
| 1 | Introduction to Data Types | Covered |
| 2 | Numeric Data Types | Covered |
| 3 | TINYINT | Covered |
| 4 | SMALLINT | Covered |
| 5 | MEDIUMINT | Covered |
| 6 | INT | Covered |
| 7 | BIGINT | Covered |
| 8 | Signed vs Unsigned | Covered |
| 9 | DECIMAL | Covered |
| 10 | FLOAT | Covered |
| 11 | DOUBLE | Covered |
| 12 | CHAR | Covered |
| 13 | VARCHAR | Covered |
| 14 | TEXT Types | Covered |
| 15 | CHAR vs VARCHAR | Covered |
| 16 | VARCHAR vs TEXT | Covered |
| 17 | DATE | Covered |
| 18 | TIME | Covered |
| 19 | DATETIME | Covered |
| 20 | TIMESTAMP | Covered |
| 21 | YEAR | Covered |
| 22 | BOOLEAN | Covered |
| 23 | ENUM | Covered |
| 24 | SET | Covered |
| 25 | BINARY and BLOB | Covered |
| 26 | JSON | Covered |
| 27 | Spatial Data Types | Introduction |
| 28 | Choosing Correct Data Types | Covered |

---

## Next: Phase 5 – CRUD Operations

This is where SQL becomes much more practical.

We'll learn:

1. What is CRUD?
2. INSERT INTO
3. Inserting Single Records
4. Inserting Multiple Records
5. INSERT with Specific Columns
6. SELECT
7. SELECT *
8. Selecting Specific Columns
9. UPDATE
10. DELETE
11. WHERE Clause
12. DISTINCT
13. LIMIT
14. OFFSET
15. ORDER BY
16. ASC and DESC
17. SQL Aliases (AS)

We'll build an actual Student Management Database and perform operations on its records.

**Important:** CRUD is one of the most frequently used concepts in backend development, especially when working with Node.js, Express, and MySQL.

Tell me **"Next Phase"** when you're ready.