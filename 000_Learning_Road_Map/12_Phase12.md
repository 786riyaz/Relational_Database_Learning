# SQL Complete Learning Roadmap
# Phase 12 – SQL Functions (MySQL 8.0+)

## 1. What Are SQL Functions?

SQL functions are predefined operations that perform specific tasks on data and return a result.

They help us:
- Manipulate strings.
- Perform mathematical calculations.
- Work with dates and times.
- Handle NULL values.
- Perform conditional operations.
- Convert data types.
- Extract and manipulate JSON data.

### Example

```sql
SELECT UPPER('hello world');
```

**Output:**

| UPPER('hello world') |
|---|
| HELLO WORLD |

Another example:

```sql
SELECT ROUND(125.678, 2);
```

**Output:**

| ROUND(125.678, 2) |
|---:|
| 125.68 |

---

## 2. Types of SQL Functions

SQL functions can broadly be divided into two categories.

### 2.1 Built-in Functions

These functions are already provided by MySQL.

Examples:

```sql
UPPER()
LOWER()
ROUND()
NOW()
COUNT()
SUM()
```

### 2.2 User-Defined Functions (UDFs)

These are functions created by developers to perform custom operations.

We will study creating custom SQL functions later when we cover stored functions in Phase 22.

### Scalar vs Aggregate Functions

Another useful classification is based on how functions operate.

| Scalar Functions | Aggregate Functions |
|---|---|
| Operate on individual values | Operate on multiple rows |
| Return one result per input row | Return one result per group |
| UPPER(), LOWER(), ROUND() | COUNT(), SUM(), AVG() |
| Can be used in WHERE, SELECT, etc. | Commonly used with GROUP BY |

Example:

```sql
SELECT
    name,
    UPPER(name) AS uppercase_name
FROM employees;
```

Here, `UPPER()` operates on each employee's name.

Compare that with:

```sql
SELECT AVG(salary)
FROM employees;
```

Here, `AVG()` calculates an average across multiple rows.

---

# 3. String Functions

String functions are used to manipulate text values.

Let's create a sample table.

```sql
CREATE DATABASE sql_functions_db;

USE sql_functions_db;

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    salary DECIMAL(10,2),
    department VARCHAR(50),
    joining_date DATE
);

INSERT INTO employees
(first_name, last_name, email, salary, department, joining_date)
VALUES
('Riyaz', 'Khan', 'riyaz@example.com', 50000, 'IT', '2023-01-15'),
('John', 'Smith', 'john@example.com', 60000, 'HR', '2022-05-10'),
('Sarah', 'Johnson', 'sarah@example.com', 75000, 'IT', '2021-03-20'),
('David', 'Brown', 'david@example.com', 45000, 'Finance', '2024-02-01');
```

## 3.1 CONCAT()

Combines multiple strings into one string.

**Syntax:**

```sql
CONCAT(string1, string2, ...)
```

Example:

```sql
SELECT CONCAT('Hello', ' ', 'World');
```

Output:

| CONCAT('Hello', ' ', 'World') |
|---|
| Hello World |

Practical example:

```sql
SELECT
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name) AS full_name
FROM employees;
```

Output:

| first_name | last_name | full_name |
|---|---|---|
| Riyaz | Khan | Riyaz Khan |
| John | Smith | John Smith |
| Sarah | Johnson | Sarah Johnson |
| David | Brown | David Brown |

**Important:** In MySQL, `CONCAT()` returns NULL if any argument is NULL.

```sql
SELECT CONCAT('Hello', NULL, 'World');
```

Output:

```text
NULL
```

## 3.2 CONCAT_WS()

`CONCAT_WS()` means Concatenate With Separator.

It combines strings using a specified separator.

**Syntax:**

```sql
CONCAT_WS(separator, string1, string2, ...)
```

Example:

```sql
SELECT CONCAT_WS('-', '2026', '11', '25');
```

Output:

```text
2026-11-25
```

Practical example:

```sql
SELECT
    CONCAT_WS(' ', first_name, last_name) AS full_name
FROM employees;
```

**Difference between CONCAT() and CONCAT_WS():**

| CONCAT() | CONCAT_WS() |
|---|---|
| Does not automatically add separators | Adds a specified separator |
| NULL in any argument makes result NULL | Skips NULL arguments after separator |
| CONCAT('A','B') → AB | CONCAT_WS('-','A','B') → A-B |

Note: If the separator itself is NULL, `CONCAT_WS()` returns NULL.

## 3.3 UPPER() and LOWER()

Convert text into uppercase or lowercase.

```sql
SELECT UPPER('hello world');
```

Output:

```text
HELLO WORLD
```

```sql
SELECT LOWER('HELLO WORLD');
```

Output:

```text
hello world
```

Practical example:

```sql
SELECT
    UPPER(first_name) AS uppercase_name,
    LOWER(email) AS lowercase_email
FROM employees;
```

Use cases:
- Standardizing text.
- Display formatting.
- Case-insensitive comparisons in situations where collation does not already provide them.

## 3.4 LENGTH() and CHAR_LENGTH()

These functions measure string length, but they measure different things.

**LENGTH()** returns the number of bytes.

**CHAR_LENGTH()** returns the number of characters.

Example:

```sql
SELECT
    LENGTH('Hello') AS byte_length,
    CHAR_LENGTH('Hello') AS character_length;
```

Output:

| byte_length | character_length |
|---:|---:|
| 5 | 5 |

Now consider a multibyte character:

```sql
SELECT
    LENGTH('é') AS byte_length,
    CHAR_LENGTH('é') AS character_length;
```

With UTF-8 encoding, the result can be:

| byte_length | character_length |
|---:|---:|
| 2 | 1 |

The exact byte count depends on character encoding.

**Remember:**

- `LENGTH()` = bytes.
- `CHAR_LENGTH()` = characters.

## 3.5 TRIM(), LTRIM(), RTRIM()

These functions remove spaces from strings.

### TRIM()

Removes leading and trailing spaces.

```sql
SELECT TRIM('   Hello World   ');
```

Output:

```text
Hello World
```

### LTRIM()

Removes leading spaces.

```sql
SELECT LTRIM('   Hello World');
```

Output:

```text
Hello World
```

### RTRIM()

Removes trailing spaces.

```sql
SELECT RTRIM('Hello World   ');
```

Output:

```text
Hello World
```

Practical example:

```sql
SELECT TRIM(first_name)
FROM employees;
```

These functions can also remove specified characters using MySQL's extended TRIM syntax.

```sql
SELECT TRIM(BOTH '-' FROM '---Hello---');
```

Output:

```text
Hello
```

## 3.6 SUBSTRING()

Extracts a portion of a string.

**Syntax:**

```sql
SUBSTRING(string, start_position, length)
```

Example:

```sql
SELECT SUBSTRING('JavaScript', 1, 4);
```

Output:

```text
Java
```

Another example:

```sql
SELECT SUBSTRING('JavaScript', 5);
```

Output:

```text
Script
```

Important:
- MySQL string positions start from 1.
- Negative starting positions count from the end.

```sql
SELECT SUBSTRING('JavaScript', -6);
```

Output:

```text
Script
```

`SUBSTR()` is an alias for `SUBSTRING()`.

## 3.7 LEFT() and RIGHT()

Extract characters from the beginning or end of a string.

```sql
SELECT LEFT('JavaScript', 4);
```

Output:

```text
Java
```

```sql
SELECT RIGHT('JavaScript', 6);
```

Output:

```text
Script
```

Practical example:

```sql
SELECT
    email,
    LEFT(email, 5) AS email_prefix
FROM employees;
```

## 3.8 REPLACE()

Replaces occurrences of a substring with another string.

**Syntax:**

```sql
REPLACE(string, old_string, new_string)
```

Example:

```sql
SELECT REPLACE('Hello World', 'World', 'SQL');
```

Output:

```text
Hello SQL
```

Practical example:

```sql
SELECT
    REPLACE(email, 'example.com', 'company.com') AS updated_email
FROM employees;
```

This query only changes the returned result. It does not update the original table.

To permanently update values, use:

```sql
UPDATE employees
SET email = REPLACE(email, 'example.com', 'company.com');
```

## 3.9 LOCATE() and INSTR()

These functions find the position of a substring.

### LOCATE()

```sql
SELECT LOCATE('Script', 'JavaScript');
```

Output:

```text
5
```

Syntax:

```sql
LOCATE(substring, string)
```

It returns 0 if the substring is not found.

You can also specify a starting position:

```sql
SELECT LOCATE('a', 'JavaScript', 3);
```

### INSTR()

```sql
SELECT INSTR('JavaScript', 'Script');
```

Output:

```text
5
```

Difference:

```sql
LOCATE(substring, string)
INSTR(string, substring)
```

Their argument order is different.

## 3.10 LPAD() and RPAD()

These functions add characters to a string until it reaches a specified length.

### LPAD()

Adds characters to the left.

```sql
SELECT LPAD('25', 5, '0');
```

Output:

```text
00025
```

### RPAD()

Adds characters to the right.

```sql
SELECT RPAD('25', 5, '0');
```

Output:

```text
25000
```

Practical example:

```sql
SELECT LPAD(id, 5, '0') AS employee_code
FROM employees;
```

Possible output:

| employee_code |
|---|
| 00001 |
| 00002 |
| 00003 |
| 00004 |

Note: LPAD/RPAD can truncate the original string if it is longer than the requested length.

## 3.11 REPEAT()

Repeats a string a specified number of times.

```sql
SELECT REPEAT('SQL ', 3);
```

Output:

```text
SQL SQL SQL
```

## 3.12 REVERSE()

Reverses a string.

```sql
SELECT REVERSE('HELLO');
```

Output:

```text
OLLEH
```

## 3.13 FORMAT()

Formats a number with commas and decimal places.

```sql
SELECT FORMAT(1234567.891, 2);
```

Output:

```text
1,234,567.89
```

Important: `FORMAT()` returns a string, not a numeric value.

## 3.14 FIND_IN_SET()

Searches for a value inside a comma-separated list.

```sql
SELECT FIND_IN_SET('SQL', 'HTML,CSS,SQL,JavaScript');
```

Output:

```text
3
```

It returns the position of the matching item or 0 if it is not found.

This function is useful for understanding legacy comma-separated data, but storing multiple values in a single database column is generally poor relational database design.

---

# 4. Numeric Functions

Numeric functions perform mathematical calculations.

## 4.1 ROUND()

Rounds a number to a specified number of decimal places.

**Syntax:**

```sql
ROUND(number, decimal_places)
```

Example:

```sql
SELECT ROUND(125.678, 2);
```

Output:

```text
125.68
```

Another example:

```sql
SELECT ROUND(125.678, 0);
```

Output:

```text
126
```

Practical example:

```sql
SELECT
    salary,
    ROUND(salary / 12, 2) AS monthly_salary
FROM employees;
```

## 4.2 TRUNCATE()

Removes decimal digits without rounding.

```sql
SELECT TRUNCATE(125.678, 2);
```

Output:

```text
125.67
```

**ROUND() vs TRUNCATE():**

| ROUND() | TRUNCATE() |
|---|---|
| Rounds the number | Removes extra decimal digits |
| 125.678 → 125.68 | 125.678 → 125.67 |

For negative values, `TRUNCATE()` removes digits toward zero.

## 4.3 CEIL() / CEILING()

Returns the smallest integer greater than or equal to a number.

```sql
SELECT CEIL(10.2);
```

Output:

```text
11
```

```sql
SELECT CEIL(10.9);
```

Output:

```text
11
```

## 4.4 FLOOR()

Returns the largest integer less than or equal to a number.

```sql
SELECT FLOOR(10.9);
```

Output:

```text
10
```

Important:

```sql
SELECT FLOOR(-10.2);
```

Output:

```text
-11
```

## 4.5 ABS()

Returns the absolute value.

```sql
SELECT ABS(-100);
```

Output:

```text
100
```

## 4.6 MOD()

Returns the remainder after division.

```sql
SELECT MOD(10, 3);
```

Output:

```text
1
```

The `%` operator can also be used.

```sql
SELECT 10 % 3;
```

Output:

```text
1
```

## 4.7 POWER()

Calculates the power of a number.

```sql
SELECT POWER(2, 3);
```

Output:

```text
8
```

Equivalent function:

```sql
SELECT POW(2, 3);
```

## 4.8 SQRT()

Returns the square root.

```sql
SELECT SQRT(64);
```

Output:

```text
8
```

## 4.9 SIGN()

Returns the sign of a number.

```sql
SELECT SIGN(-50);
```

Output:

```text
-1
```

```sql
SELECT SIGN(50);
```

Output:

```text
1
```

```sql
SELECT SIGN(0);
```

Output:

```text
0
```

## 4.10 RAND()

Generates a random floating-point number between 0 and 1.

```sql
SELECT RAND();
```

Example output:

```text
0.735219
```

The result changes between executions.

Generate a random number between 1 and 100:

```sql
SELECT FLOOR(1 + RAND() * 100);
```

**Use cases:**
- Randomized testing.
- Selecting random records.
- Generating sample data.

Avoid relying on random functions for security-sensitive tokens or passwords.

---

# 5. Date and Time Functions

Date and time functions are especially important in backend applications.

They are used for:
- Employee attendance.
- Order creation dates.
- Transaction timestamps.
- Subscription expiry.
- Reports.
- Age calculations.
- Booking systems.

## 5.1 NOW()

Returns the current date and time according to the MySQL session time zone.

```sql
SELECT NOW();
```

Example output:

```text
2026-11-25 07:30:00
```

The actual output depends on the current time and session time zone.

## 5.2 CURRENT_TIMESTAMP()

Returns the current date and time.

```sql
SELECT CURRENT_TIMESTAMP();
```

It is commonly used as a default value:

```sql
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_amount DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 5.3 CURDATE() / CURRENT_DATE()

Returns the current date.

```sql
SELECT CURDATE();
```

Example:

```text
2026-11-25
```

`CURRENT_DATE()` is equivalent.

## 5.4 CURTIME() / CURRENT_TIME()

Returns the current time.

```sql
SELECT CURTIME();
```

Example:

```text
07:30:00
```

## 5.5 UTC_DATE() and UTC_TIMESTAMP()

These functions return the current date and timestamp in UTC.

```sql
SELECT UTC_DATE();
```

```sql
SELECT UTC_TIMESTAMP();
```

**NOW() vs UTC_TIMESTAMP():**

| NOW() | UTC_TIMESTAMP() |
|---|---|
| Uses session time zone | Returns UTC time |
| Current session date/time | Current UTC date/time |

Remember:
- `DATETIME` stores a date and time without automatic time-zone conversion.
- `TIMESTAMP` is stored internally in UTC and converted according to the session time zone when retrieved.

## 5.6 YEAR(), MONTH(), DAY()

Extract date components.

```sql
SELECT
    YEAR('2026-11-25') AS year_value,
    MONTH('2026-11-25') AS month_value,
    DAY('2026-11-25') AS day_value;
```

Output:

| year_value | month_value | day_value |
|---:|---:|---:|
| 2026 | 11 | 25 |

## 5.7 DAYNAME() and MONTHNAME()

Return the name of the day or month.

```sql
SELECT DAYNAME('2026-11-25');
```

Output:

```text
Wednesday
```

```sql
SELECT MONTHNAME('2026-11-25');
```

Output:

```text
November
```

The language used for these names can depend on the `lc_time_names` setting.

## 5.8 HOUR(), MINUTE(), SECOND()

Extract time components.

```sql
SELECT
    HOUR('14:35:45') AS hours,
    MINUTE('14:35:45') AS minutes,
    SECOND('14:35:45') AS seconds;
```

Output:

| hours | minutes | seconds |
|---:|---:|---:|
| 14 | 35 | 45 |

## 5.9 EXTRACT()

Extracts a specific component from a date or time.

**Syntax:**

```sql
EXTRACT(unit FROM date_value)
```

Example:

```sql
SELECT EXTRACT(YEAR FROM '2026-11-25');
```

Output:

```text
2026
```

Another example:

```sql
SELECT EXTRACT(MONTH FROM '2026-11-25');
```

Output:

```text
11
```

You can also extract combined units:

```sql
SELECT EXTRACT(YEAR_MONTH FROM '2026-11-25');
```

Output:

```text
202611
```

## 5.10 DATE() and TIME()

Extract the date or time portion of a datetime value.

```sql
SELECT DATE('2026-11-25 14:30:45');
```

Output:

```text
2026-11-25
```

```sql
SELECT TIME('2026-11-25 14:30:45');
```

Output:

```text
14:30:45
```

## 5.11 DATEDIFF()

Calculates the difference between two dates in days.

**Syntax:**

```sql
DATEDIFF(date1, date2)
```

Example:

```sql
SELECT DATEDIFF('2026-11-25', '2026-11-20');
```

Output:

```text
5
```

Practical example:

```sql
SELECT
    first_name,
    joining_date,
    DATEDIFF(CURDATE(), joining_date) AS days_worked
FROM employees;
```

Important:
- It returns the number of days.
- It ignores time portions.
- The calculation is `date1 - date2`.

## 5.12 TIMESTAMPDIFF()

Calculates the difference between two date/time values in a specified unit.

**Syntax:**

```sql
TIMESTAMPDIFF(unit, start_datetime, end_datetime)
```

Example:

```sql
SELECT TIMESTAMPDIFF(
    MONTH,
    '2026-01-01',
    '2026-11-25'
);
```

Output:

```text
10
```

Supported units include:

- MICROSECOND
- SECOND
- MINUTE
- HOUR
- DAY
- WEEK
- MONTH
- QUARTER
- YEAR

Practical example:

```sql
SELECT
    first_name,
    TIMESTAMPDIFF(
        YEAR,
        joining_date,
        CURDATE()
    ) AS completed_years
FROM employees;
```

**DATEDIFF() vs TIMESTAMPDIFF():**

| DATEDIFF() | TIMESTAMPDIFF() |
|---|---|
| Returns difference in days | Returns difference in specified unit |
| Ignores time portions | Can consider time portions |
| No unit argument | Requires a unit argument |

## 5.13 DATE_ADD()

Adds an interval to a date.

**Syntax:**

```sql
DATE_ADD(date, INTERVAL value unit)
```

Example:

```sql
SELECT DATE_ADD('2026-11-25', INTERVAL 10 DAY);
```

Output:

```text
2026-12-05
```

Add three months:

```sql
SELECT DATE_ADD('2026-11-25', INTERVAL 3 MONTH);
```

Output:

```text
2027-02-25
```

Practical example:

```sql
SELECT DATE_ADD(CURDATE(), INTERVAL 30 DAY);
```

This calculates a date 30 days from today.

## 5.14 DATE_SUB()

Subtracts an interval from a date.

```sql
SELECT DATE_SUB('2026-11-25', INTERVAL 10 DAY);
```

Output:

```text
2026-11-15
```

Equivalent alternatives include `ADDDATE()` and `SUBDATE()`.

## 5.15 LAST_DAY()

Returns the last day of a month.

```sql
SELECT LAST_DAY('2026-11-25');
```

Output:

```text
2026-11-30
```

Useful for:
- Monthly reports.
- Salary calculations.
- Billing cycles.
- Subscription expiry.

## 5.16 DAYOFWEEK() and DAYOFMONTH()

### DAYOFWEEK()

Returns the weekday number:

- Sunday = 1
- Monday = 2
- ...
- Saturday = 7

```sql
SELECT DAYOFWEEK('2026-11-25');
```

Output:

```text
4
```

### DAYOFMONTH()

Returns the day of the month.

```sql
SELECT DAYOFMONTH('2026-11-25');
```

Output:

```text
25
```

## 5.17 DATE_FORMAT()

Formats a date or datetime into a string.

**Syntax:**

```sql
DATE_FORMAT(date, format)
```

Example:

```sql
SELECT DATE_FORMAT(
    '2026-11-25',
    '%d-%m-%Y'
);
```

Output:

```text
25-11-2026
```

Important format specifiers:

| Specifier | Meaning | Example |
|---|---|---|
| %Y | Four-digit year | 2026 |
| %y | Two-digit year | 26 |
| %m | Month number | 11 |
| %M | Month name | November |
| %d | Day of month | 25 |
| %D | Day with suffix | 25th |
| %W | Weekday name | Wednesday |
| %H | Hour (00–23) | 14 |
| %h | Hour (01–12) | 02 |
| %i | Minutes | 30 |
| %s | Seconds | 45 |
| %p | AM/PM | PM |

Practical example:

```sql
SELECT
    first_name,
    DATE_FORMAT(joining_date, '%d %M %Y') AS joining_date_formatted
FROM employees;
```

Possible output:

| first_name | joining_date_formatted |
|---|---|
| Riyaz | 15 January 2023 |
| John | 10 May 2022 |
| Sarah | 20 March 2021 |
| David | 01 February 2024 |

**Important:** `DATE_FORMAT()` returns a string, not a DATE value.

## 5.18 STR_TO_DATE()

Converts a formatted string into a date or datetime value.

**Syntax:**

```sql
STR_TO_DATE(string, format)
```

Example:

```sql
SELECT STR_TO_DATE(
    '25-11-2026',
    '%d-%m-%Y'
);
```

Output:

```text
2026-11-25
```

Practical use case: importing dates from Excel or CSV files where dates are stored in a different format.

## 5.19 UNIX_TIMESTAMP() and FROM_UNIXTIME()

These functions convert between date/time values and Unix timestamps.

A Unix timestamp represents seconds since:

**January 1, 1970, 00:00:00 UTC.**

Convert a date into a Unix timestamp:

```sql
SELECT UNIX_TIMESTAMP('2026-11-25 10:00:00');
```

Convert a Unix timestamp into a date/time:

```sql
SELECT FROM_UNIXTIME(1795600800);
```

The displayed date/time depends on the session time zone.

## 5.20 TIME_TO_SEC() and SEC_TO_TIME()

Convert time into seconds and vice versa.

```sql
SELECT TIME_TO_SEC('01:30:00');
```

Output:

```text
5400
```

Convert seconds into time:

```sql
SELECT SEC_TO_TIME(5400);
```

Output:

```text
01:30:00
```

Useful for attendance systems and calculating working hours.

---

# 6. NULL Handling Functions

NULL represents missing or unknown data.

MySQL provides several functions to handle NULL values.

## 6.1 IFNULL()

Returns an alternative value if the expression is NULL.

**Syntax:**

```sql
IFNULL(expression, alternative_value)
```

Example:

```sql
SELECT IFNULL(NULL, 'Not Available');
```

Output:

```text
Not Available
```

Practical example:

```sql
SELECT
    first_name,
    IFNULL(department, 'Not Assigned') AS department
FROM employees;
```

## 6.2 COALESCE()

Returns the first non-NULL value from a list of expressions.

**Syntax:**

```sql
COALESCE(value1, value2, value3, ...)
```

Example:

```sql
SELECT COALESCE(NULL, NULL, 'SQL', 'JavaScript');
```

Output:

```text
SQL
```

Practical example:

```sql
SELECT
    COALESCE(email, 'No Email') AS contact_email
FROM employees;
```

### IFNULL() vs COALESCE()

| IFNULL() | COALESCE() |
|---|---|
| Accepts two arguments | Accepts multiple arguments |
| Returns alternative if first is NULL | Returns first non-NULL value |
| MySQL function | Standard SQL function |

## 6.3 NULLIF()

Returns NULL if two expressions are equal. Otherwise, it returns the first expression.

**Syntax:**

```sql
NULLIF(expression1, expression2)
```

Example:

```sql
SELECT NULLIF(10, 10);
```

Output:

```text
NULL
```

Another example:

```sql
SELECT NULLIF(10, 20);
```

Output:

```text
10
```

### Practical use case: Avoid division by zero

```sql
SELECT
    total_sales / NULLIF(total_orders, 0) AS average_order_value
FROM sales_summary;
```

If `total_orders` is zero, `NULLIF()` returns NULL instead of zero, preventing division by zero.

## 6.4 ISNULL()

Checks whether an expression is NULL.

```sql
SELECT ISNULL(NULL);
```

Output:

```text
1
```

```sql
SELECT ISNULL('Hello');
```

Output:

```text
0
```

Equivalent checks can be written using:

```sql
SELECT NULL IS NULL;
```

---

# 7. Conditional Functions

Conditional functions allow SQL queries to make decisions.

They are similar to `if-else` statements in JavaScript.

## 7.1 IF()

Returns one value if a condition is true and another if it is false.

**Syntax:**

```sql
IF(condition, value_if_true, value_if_false)
```

Example:

```sql
SELECT IF(100 > 50, 'Greater', 'Smaller');
```

Output:

```text
Greater
```

Practical example:

```sql
SELECT
    first_name,
    salary,
    IF(salary >= 60000, 'High Salary', 'Low Salary') AS salary_category
FROM employees;
```

Possible output:

| first_name | salary | salary_category |
|---|---:|---|
| Riyaz | 50000 | Low Salary |
| John | 60000 | High Salary |
| Sarah | 75000 | High Salary |
| David | 45000 | Low Salary |

## 7.2 CASE

`CASE` allows multiple conditional branches.

It is similar to `if`, `else if`, and `else` in JavaScript.

**Syntax:**

```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
END
```

Example:

```sql
SELECT
    first_name,
    salary,
    CASE
        WHEN salary >= 70000 THEN 'High'
        WHEN salary >= 50000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_category
FROM employees;
```

Possible output:

| first_name | salary | salary_category |
|---|---:|---|
| Riyaz | 50000 | Medium |
| John | 60000 | Medium |
| Sarah | 75000 | High |
| David | 45000 | Low |

### CASE with multiple conditions

```sql
SELECT
    first_name,
    salary,
    department,
    CASE
        WHEN salary >= 70000 AND department = 'IT'
            THEN 'IT Senior'
        WHEN salary >= 60000
            THEN 'Experienced'
        ELSE 'Regular'
    END AS employee_type
FROM employees;
```

### Simple CASE expression

You can also compare one expression against multiple values.

```sql
SELECT
    department,
    CASE department
        WHEN 'IT' THEN 'Technology'
        WHEN 'HR' THEN 'Human Resources'
        WHEN 'Finance' THEN 'Financial Department'
        ELSE 'Other'
    END AS department_name
FROM employees;
```

**IF() vs CASE:**

| IF() | CASE |
|---|---|
| Handles one condition | Handles multiple conditions |
| Shorter syntax | More flexible |
| Useful for simple conditions | Useful for complex business rules |

## 7.3 GREATEST()

Returns the largest value from a list.

```sql
SELECT GREATEST(10, 50, 30, 20);
```

Output:

```text
50
```

## 7.4 LEAST()

Returns the smallest value from a list.

```sql
SELECT LEAST(10, 50, 30, 20);
```

Output:

```text
10
```

**Important MySQL behavior:** If any argument to `GREATEST()` or `LEAST()` is NULL, the result is NULL.

---

# 8. Type Conversion Functions

Type conversion means changing a value from one data type into another.

This is useful when working with imported data, calculations, and application input.

## 8.1 CAST()

Converts an expression into a specified data type.

**Syntax:**

```sql
CAST(expression AS data_type)
```

Example:

```sql
SELECT CAST('100' AS UNSIGNED);
```

Output:

```text
100
```

Convert a number to text:

```sql
SELECT CAST(100 AS CHAR);
```

Output:

```text
100
```

Convert to decimal:

```sql
SELECT CAST(123.456 AS DECIMAL(10,2));
```

Output:

```text
123.46
```

Convert to date:

```sql
SELECT CAST('2026-11-25' AS DATE);
```

Output:

```text
2026-11-25
```

## 8.2 CONVERT()

Another function for type conversion.

```sql
SELECT CONVERT('100', UNSIGNED);
```

Output:

```text
100
```

Example:

```sql
SELECT CONVERT(123.456, DECIMAL(10,2));
```

Output:

```text
123.46
```

### CAST() vs CONVERT()

| CAST() | CONVERT() |
|---|---|
| Standard SQL syntax | MySQL also supports this syntax |
| CAST(value AS type) | CONVERT(value, type) |
| Used for type conversion | Used for type conversion and character-set conversion |

There is also a separate character-set conversion form:

```sql
SELECT CONVERT('Hello' USING utf8mb4);
```

## 8.3 Implicit Type Conversion

MySQL sometimes converts values automatically.

Example:

```sql
SELECT '100' + 50;
```

Output:

```text
150
```

MySQL converts the string `'100'` into a number for this calculation.

However, implicit conversion can create unexpected results.

**Best practice:** Explicitly convert values when the intended data type matters.

---

# 9. JSON Functions

MySQL supports a native JSON data type.

JSON functions allow you to create, read, update, and remove JSON data.

These functions are especially useful when storing flexible structured data.

Let's create a sample table.

```sql
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    details JSON
);
```

Insert JSON data:

```sql
INSERT INTO products (name, details)
VALUES
(
    'Laptop',
    '{
        "brand": "Lenovo",
        "ram": "16GB",
        "storage": "512GB",
        "price": 75000
    }'
);
```

## 9.1 JSON_EXTRACT()

Extracts a value from JSON data.

**Syntax:**

```sql
JSON_EXTRACT(json_column, json_path)
```

Example:

```sql
SELECT JSON_EXTRACT(details, '$.brand')
FROM products;
```

Output:

```json
"Lenovo"
```

Extract price:

```sql
SELECT JSON_EXTRACT(details, '$.price')
FROM products;
```

Output:

```text
75000
```

### Understanding JSON paths

| JSON Path | Meaning |
|---|---|
| $.name | Root-level name |
| $.brand | Root-level brand |
| $.address.city | Nested city |
| $[0] | First array element |
| $.items[0] | First item inside items array |

## 9.2 JSON Shorthand Operators

MySQL provides shorthand operators for extracting JSON values.

### ->

Equivalent to `JSON_EXTRACT()`.

```sql
SELECT details->'$.brand'
FROM products;
```

### ->>

Extracts a value and returns it as an unquoted string.

```sql
SELECT details->>'$.brand'
FROM products;
```

Output:

```text
Lenovo
```

This is useful when you want to retrieve a JSON scalar as ordinary SQL text.

## 9.3 JSON_OBJECT()

Creates a JSON object.

```sql
SELECT JSON_OBJECT(
    'name', 'Riyaz',
    'age', 25,
    'city', 'Ahmedabad'
);
```

Output:

```json
{
    "name": "Riyaz",
    "age": 25,
    "city": "Ahmedabad"
}
```

## 9.4 JSON_ARRAY()

Creates a JSON array.

```sql
SELECT JSON_ARRAY('HTML', 'CSS', 'JavaScript', 'SQL');
```

Output:

```json
["HTML", "CSS", "JavaScript", "SQL"]
```

## 9.5 JSON_SET()

Adds or updates a JSON value.

```sql
UPDATE products
SET details = JSON_SET(
    details,
    '$.color',
    'Black'
)
WHERE id = 1;
```

This adds the `color` property if it does not exist, or updates it if it already exists.

## 9.6 JSON_INSERT()

Inserts a value only if the specified path does not already exist.

```sql
UPDATE products
SET details = JSON_INSERT(
    details,
    '$.warranty',
    '2 Years'
)
WHERE id = 1;
```

If `warranty` already exists, its value remains unchanged.

## 9.7 JSON_REPLACE()

Updates a JSON value only if the specified path already exists.

```sql
UPDATE products
SET details = JSON_REPLACE(
    details,
    '$.brand',
    'HP'
)
WHERE id = 1;
```

If the path does not exist, nothing is inserted.

### JSON_SET() vs JSON_INSERT() vs JSON_REPLACE()

| Function | Existing path | Missing path |
|---|---|---|
| JSON_SET() | Updates | Inserts |
| JSON_INSERT() | Does nothing | Inserts |
| JSON_REPLACE() | Updates | Does nothing |

## 9.8 JSON_REMOVE()

Removes a JSON property.

```sql
UPDATE products
SET details = JSON_REMOVE(
    details,
    '$.storage'
)
WHERE id = 1;
```

## 9.9 JSON_CONTAINS()

Checks whether a JSON document contains a specified value.

```sql
SELECT JSON_CONTAINS(
    details,
    '"Lenovo"',
    '$.brand'
)
FROM products;
```

Output:

```text
1
```

It returns 1 if the value is present and 0 otherwise.

## 9.10 JSON_VALID()

Checks whether a string contains valid JSON.

```sql
SELECT JSON_VALID('{"name":"Riyaz"}');
```

Output:

```text
1
```

Invalid JSON:

```sql
SELECT JSON_VALID('{name:Riyaz}');
```

Output:

```text
0
```

## 9.11 JSON_TYPE()

Returns the JSON data type of a JSON value.

```sql
SELECT JSON_TYPE('{"name":"Riyaz"}');
```

Output:

```text
OBJECT
```

Other possible types include:
- OBJECT
- ARRAY
- STRING
- INTEGER
- DOUBLE
- BOOLEAN
- NULL

## 9.12 JSON_LENGTH()

Returns the number of elements in a JSON object or array.

```sql
SELECT JSON_LENGTH('[10, 20, 30, 40]');
```

Output:

```text
4
```

## 9.13 JSON_KEYS()

Returns the keys of a JSON object as a JSON array.

```sql
SELECT JSON_KEYS(
    '{"name":"Riyaz","age":25,"city":"Ahmedabad"}'
);
```

Output:

```json
["name", "age", "city"]
```

## 9.14 JSON_UNQUOTE()

Removes the surrounding quotes from a JSON string value.

```sql
SELECT JSON_UNQUOTE('"Hello World"');
```

Output:

```text
Hello World
```

---

# 10. Other Useful MySQL Functions

These functions provide information about the database server, connection, or current session.

## 10.1 VERSION()

Returns the MySQL server version.

```sql
SELECT VERSION();
```

Example output:

```text
8.0.44
```

## 10.2 DATABASE()

Returns the currently selected database.

```sql
SELECT DATABASE();
```

Example output:

```text
sql_functions_db
```

## 10.3 USER()

Returns the current MySQL connection username and host.

```sql
SELECT USER();
```

Example output:

```text
root@localhost
```

## 10.4 CURRENT_USER()

Returns the MySQL account used for privilege checking.

```sql
SELECT CURRENT_USER();
```

`USER()` and `CURRENT_USER()` can return different values.

## 10.5 CONNECTION_ID()

Returns the current connection ID.

```sql
SELECT CONNECTION_ID();
```

Example output:

```text
15
```

## 10.6 LAST_INSERT_ID()

Returns the most recently generated AUTO_INCREMENT value for the current connection.

Example:

```sql
INSERT INTO employees
(first_name, last_name, email, salary, department, joining_date)
VALUES
('Alex', 'Wilson', 'alex@example.com', 55000, 'IT', CURDATE());

SELECT LAST_INSERT_ID();
```

Example output:

```text
5
```

This is especially useful in Node.js applications when you insert a record and need its generated ID.

## 10.7 UUID()

Generates a UUID value.

```sql
SELECT UUID();
```

Example output:

```text
550e8400-e29b-41d4-a716-446655440000
```

UUIDs are useful for generating unique identifiers.

---

# 11. Function Nesting

You can use multiple SQL functions inside one another.

This is called function nesting.

Example:

```sql
SELECT UPPER(
    CONCAT(
        first_name,
        ' ',
        last_name
    )
) AS full_name
FROM employees;
```

Here:
1. `CONCAT()` combines first and last names.
2. `UPPER()` converts the combined name to uppercase.

Possible output:

| full_name |
|---|
| RIYAZ KHAN |
| JOHN SMITH |
| SARAH JOHNSON |
| DAVID BROWN |

Another example:

```sql
SELECT
    ROUND(
        salary / 12,
        2
    ) AS monthly_salary
FROM employees;
```

You can combine date functions too:

```sql
SELECT
    DATE_FORMAT(
        DATE_ADD(CURDATE(), INTERVAL 30 DAY),
        '%d-%m-%Y'
    ) AS expiry_date;
```

This calculates a date 30 days from today and formats it.

---

# 12. Using Functions in WHERE Conditions

SQL functions can be used inside `WHERE` conditions.

Example:

```sql
SELECT *
FROM employees
WHERE UPPER(department) = 'IT';
```

Another example:

```sql
SELECT *
FROM employees
WHERE YEAR(joining_date) = 2023;
```

This returns employees who joined in 2023.

### Important: Functions and Index Performance

Suppose `joining_date` has an index.

This query:

```sql
SELECT *
FROM employees
WHERE YEAR(joining_date) = 2023;
```

May prevent MySQL from using a normal range scan on the index efficiently because the function is applied to the indexed column.

A better approach is:

```sql
SELECT *
FROM employees
WHERE joining_date >= '2023-01-01'
  AND joining_date < '2024-01-01';
```

This is called a **SARGable condition**: a condition that can be used efficiently with an index.

For datetime columns, using a half-open interval (`>= start` and `< next period`) is particularly useful because it includes all times on the final day without needing to guess the maximum time value.

### Case-insensitive search example

Instead of:

```sql
SELECT *
FROM employees
WHERE LOWER(email) = 'riyaz@example.com';
```

Check whether the column's collation is already case-insensitive. MySQL's common `utf8mb4_0900_ai_ci` collation is case-insensitive.

When possible, compare directly:

```sql
SELECT *
FROM employees
WHERE email = 'riyaz@example.com';
```

This can make normal index usage easier.

---

# 13. Common Mistakes and Best Practices

### Mistake 1: Confusing LENGTH() and CHAR_LENGTH()

```sql
LENGTH('é')
CHAR_LENGTH('é')
```

They can return different results because one measures bytes and the other measures characters.

### Mistake 2: Using CONCAT() with NULL values

```sql
SELECT CONCAT('Hello', NULL);
```

Returns NULL.

Use `CONCAT_WS()` or `COALESCE()` when appropriate.

### Mistake 3: Using FORMAT() for calculations

`FORMAT()` returns a formatted string.

Do not use its output as a numeric value for further calculations.

### Mistake 4: Confusing ROUND() and TRUNCATE()

```sql
SELECT ROUND(10.678, 2);
SELECT TRUNCATE(10.678, 2);
```

The results are different.

### Mistake 5: Using DATEDIFF() to calculate exact age

This is not reliable:

```sql
SELECT DATEDIFF(CURDATE(), '2000-01-01') / 365;
```

Leap years make this calculation inaccurate.

Use:

```sql
SELECT TIMESTAMPDIFF(
    YEAR,
    '2000-01-01',
    CURDATE()
);
```

### Mistake 6: Using functions unnecessarily in WHERE

Avoid wrapping indexed columns in functions when a direct range condition can solve the problem.

### Mistake 7: Confusing DATE_FORMAT() and STR_TO_DATE()

| Function | Purpose |
|---|---|
| DATE_FORMAT() | Date → formatted string |
| STR_TO_DATE() | Formatted string → date/time |

### Mistake 8: Using JSON for everything

JSON is useful for flexible attributes, but frequently queried relational fields should generally be stored in properly typed columns.

### Best Practices

1. Use the correct function for the required data type.
2. Understand how functions handle NULL values.
3. Prefer explicit type conversion where necessary.
4. Avoid unnecessary function calls on indexed columns.
5. Use `DECIMAL` for exact financial calculations.
6. Use `TIMESTAMPDIFF()` for age or completed-unit calculations.
7. Use `DATE_FORMAT()` for presentation, not for storing dates.
8. Use JSON functions when the data genuinely benefits from a flexible structure.
9. Validate date and string inputs before converting them.
10. Test complex nested functions with sample data before using them in production.

---

# 14. Real-World Practical Examples

Let's apply the functions to common backend development requirements.

### Example 1: Generate Full Employee Names

```sql
SELECT
    id,
    CONCAT_WS(' ', first_name, last_name) AS full_name
FROM employees;
```

### Example 2: Calculate Monthly Salary

```sql
SELECT
    first_name,
    salary,
    ROUND(salary / 12, 2) AS monthly_salary
FROM employees;
```

### Example 3: Find Employees Who Joined This Year

```sql
SELECT *
FROM employees
WHERE joining_date >= MAKEDATE(YEAR(CURDATE()), 1)
  AND joining_date < MAKEDATE(YEAR(CURDATE()) + 1, 1);
```

### Example 4: Calculate Employee Experience

```sql
SELECT
    first_name,
    TIMESTAMPDIFF(
        YEAR,
        joining_date,
        CURDATE()
    ) AS experience_years
FROM employees;
```

### Example 5: Generate Employee Codes

```sql
SELECT
    CONCAT(
        'EMP-',
        LPAD(id, 5, '0')
    ) AS employee_code,
    first_name
FROM employees;
```

Possible output:

| employee_code | first_name |
|---|---|
| EMP-00001 | Riyaz |
| EMP-00002 | John |
| EMP-00003 | Sarah |
| EMP-00004 | David |

### Example 6: Categorize Employees by Salary

```sql
SELECT
    first_name,
    salary,
    CASE
        WHEN salary >= 70000 THEN 'Senior'
        WHEN salary >= 50000 THEN 'Mid-Level'
        ELSE 'Junior'
    END AS employee_level
FROM employees;
```

### Example 7: Find Subscription Expiry Date

```sql
SELECT
    DATE_ADD(CURDATE(), INTERVAL 1 YEAR) AS expiry_date;
```

### Example 8: Handle Missing Email Addresses

```sql
SELECT
    first_name,
    COALESCE(email, 'Email Not Available') AS email
FROM employees;
```

### Example 9: Calculate Average Order Value Safely

Assume a table named `sales_summary`:

```sql
SELECT
    total_sales,
    total_orders,
    total_sales / NULLIF(total_orders, 0) AS average_order_value
FROM sales_summary;
```

### Example 10: Format a Date for an API Response

```sql
SELECT
    id,
    first_name,
    DATE_FORMAT(joining_date, '%d-%m-%Y') AS joining_date
FROM employees;
```

Note: In production applications, consider whether date formatting should happen in SQL or in the Node.js application layer. Keeping date values as proper date types often provides more flexibility.

---

# 15. SQL Functions Interview Questions

### Beginner Level

1. What are SQL functions?
2. What is the difference between built-in and user-defined functions?
3. What are scalar functions?
4. What are aggregate functions?
5. What is the difference between CONCAT() and CONCAT_WS()?
6. What is the difference between LENGTH() and CHAR_LENGTH()?
7. What is the purpose of UPPER() and LOWER()?
8. What does TRIM() do?
9. What is the difference between LEFT() and RIGHT()?
10. What is the difference between ROUND() and TRUNCATE()?

### Intermediate Level

11. What is the difference between CEIL() and FLOOR()?
12. What is the difference between DATEDIFF() and TIMESTAMPDIFF()?
13. What is the difference between NOW() and CURDATE()?
14. What is the difference between NOW() and UTC_TIMESTAMP()?
15. What is the difference between DATE_FORMAT() and STR_TO_DATE()?
16. What is the difference between IFNULL() and COALESCE()?
17. What is the purpose of NULLIF()?
18. What is the difference between IF() and CASE?
19. What is the difference between CAST() and CONVERT()?
20. What is the purpose of GREATEST() and LEAST()?

### Advanced Level

21. What are JSON functions in MySQL?
22. What is the difference between JSON_SET(), JSON_INSERT(), and JSON_REPLACE()?
23. What is the difference between `->` and `->>`?
24. How do you extract a nested JSON value?
25. How can SQL functions affect index performance?
26. What is a SARGable query?
27. Why should functions on indexed columns be avoided where possible?
28. How do you calculate an employee's completed years of experience?
29. How do you prevent division by zero using SQL functions?
30. How can you generate unique identifiers using MySQL?

---

# 16. Practical Assignments

Complete these exercises using MySQL.

### Assignment 1 – String Functions

1. Display employee full names using CONCAT().
2. Display all employee names in uppercase.
3. Display all email addresses in lowercase.
4. Find the length of each employee's first name.
5. Extract the first three characters of every employee's name.
6. Replace `example.com` with `company.com` in the displayed email addresses.
7. Generate employee codes using LPAD().
8. Find the position of `@` in each email address.
9. Display the first five characters of every email address.
10. Combine first name and department using `CONCAT_WS()`.

### Assignment 2 – Numeric Functions

1. Calculate annual salary divided by 12.
2. Round monthly salary to two decimal places.
3. Calculate the truncated salary value to two decimal places.
4. Display the absolute value of -500.
5. Calculate the remainder of 100 divided by 7.
6. Find the square root of 144.
7. Generate a random integer between 1 and 100.
8. Display salary values using FORMAT().

### Assignment 3 – Date Functions

1. Display the current date and time.
2. Display only the current date.
3. Extract the joining year of every employee.
4. Extract the joining month.
5. Display the weekday name of every joining date.
6. Calculate completed years of experience.
7. Calculate the number of days since joining.
8. Add 30 days to the current date.
9. Find the last day of the current month.
10. Format joining dates as `DD-MM-YYYY`.

### Assignment 4 – NULL and Conditional Functions

Create a new column called `bonus` in the employees table.

```sql
ALTER TABLE employees
ADD COLUMN bonus DECIMAL(10,2) NULL;
```

Then:

1. Display bonus as 0 when its value is NULL.
2. Use COALESCE() to return the first available value.
3. Use NULLIF() to prevent division by zero.
4. Categorize employees using IF().
5. Categorize employees into Junior, Mid-Level, and Senior using CASE.
6. Display the highest salary using GREATEST() with sample values.
7. Display the lowest salary using LEAST() with sample values.

### Assignment 5 – JSON Functions

1. Create a table with a JSON column.
2. Insert product details as JSON.
3. Extract the product brand.
4. Extract the product price.
5. Add a color property using JSON_SET().
6. Insert a warranty property using JSON_INSERT().
7. Update the brand using JSON_REPLACE().
8. Remove the storage property.
9. Check whether the JSON contains a particular value.
10. Retrieve all JSON object keys.

---

# 17. Phase 12 – Quick Revision Sheet

| Function | Purpose |
|---|---|
| CONCAT() | Combines strings |
| CONCAT_WS() | Combines strings with a separator |
| UPPER() | Converts text to uppercase |
| LOWER() | Converts text to lowercase |
| LENGTH() | Returns bytes |
| CHAR_LENGTH() | Returns character count |
| TRIM() | Removes leading and trailing spaces |
| SUBSTRING() | Extracts part of a string |
| LEFT() | Extracts characters from the left |
| RIGHT() | Extracts characters from the right |
| REPLACE() | Replaces text |
| LOCATE() | Finds substring position |
| LPAD() | Adds characters on the left |
| RPAD() | Adds characters on the right |
| ROUND() | Rounds a number |
| TRUNCATE() | Removes decimal digits |
| CEIL() | Rounds upward |
| FLOOR() | Rounds downward |
| ABS() | Returns absolute value |
| MOD() | Returns remainder |
| POWER() | Calculates power |
| SQRT() | Calculates square root |
| RAND() | Generates random number |
| NOW() | Current date and time |
| CURDATE() | Current date |
| CURTIME() | Current time |
| YEAR() | Extracts year |
| MONTH() | Extracts month |
| DAY() | Extracts day |
| DATEDIFF() | Difference in days |
| TIMESTAMPDIFF() | Difference in specified unit |
| DATE_ADD() | Adds date interval |
| DATE_SUB() | Subtracts date interval |
| LAST_DAY() | Last day of month |
| DATE_FORMAT() | Formats date as string |
| STR_TO_DATE() | Parses string into date/time |
| IFNULL() | Replaces NULL |
| COALESCE() | Returns first non-NULL value |
| NULLIF() | Returns NULL when values are equal |
| IF() | Conditional expression |
| CASE | Multiple conditional branches |
| GREATEST() | Returns largest value |
| LEAST() | Returns smallest value |
| CAST() | Converts data type |
| CONVERT() | Converts data type |
| JSON_EXTRACT() | Extracts JSON value |
| JSON_SET() | Inserts or updates JSON value |
| JSON_REMOVE() | Removes JSON value |
| JSON_OBJECT() | Creates JSON object |
| JSON_ARRAY() | Creates JSON array |
| VERSION() | MySQL version |
| DATABASE() | Current database |
| USER() | Connection username and host |
| LAST_INSERT_ID() | Last generated auto-increment ID |

---

# 18. Phase 12 Completion Checklist

Before moving to Phase 13, make sure you understand:

- [ ] What SQL functions are.
- [ ] Built-in vs user-defined functions.
- [ ] Scalar vs aggregate functions.
- [ ] String functions.
- [ ] Numeric functions.
- [ ] Date and time functions.
- [ ] NULL handling functions.
- [ ] Conditional functions.
- [ ] Type conversion functions.
- [ ] JSON functions.
- [ ] MySQL session and information functions.
- [ ] Function nesting.
- [ ] Functions in WHERE conditions.
- [ ] Functions and index performance.
- [ ] Practical SQL assignments.

**Phase 12 is complete when you can independently write queries that manipulate strings, calculate values, handle dates, process NULL values, apply business conditions, and extract JSON data.**

---

## Next Phase: Phase 13 – SQL Set Operations

In Phase 13, we will cover:

1. What are Set Operations?
2. UNION
3. UNION ALL
4. UNION vs UNION ALL
5. INTERSECT
6. EXCEPT
7. UNION with ORDER BY
8. UNION with LIMIT
9. Column compatibility rules
10. Combining data from multiple tables
11. Real-world use cases
12. Common mistakes and performance considerations
13. Interview questions and practical assignments

**Next: Phase 13 – SQL Set Operations.**