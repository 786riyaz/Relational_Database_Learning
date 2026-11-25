# SQL Complete Learning Roadmap – Phase 22
# Stored Procedures, Functions and Triggers

In this phase, we will learn how to write reusable SQL programs directly inside MySQL.

Until now, you have executed SQL statements individually:

```sql
SELECT * FROM employees;

INSERT INTO employees (name, salary)
VALUES ('Rahul', 50000);

UPDATE employees
SET salary = 60000
WHERE id = 1;
```

But what if you want to execute multiple SQL statements together as one reusable operation?

For example:

- Register a new employee.
- Calculate an employee's annual salary.
- Generate a monthly salary report.
- Automatically maintain audit logs whenever a record is updated.
- Automatically update inventory when an order is placed.

MySQL provides three important features for these requirements:

1. **Stored Procedures**
2. **Stored Functions**
3. **Triggers**

Let's understand them step by step.

---

# 1. What Are Stored Procedures?

A stored procedure is a collection of SQL statements stored inside the database that can be executed whenever required.

Instead of writing the same SQL queries repeatedly, you can create a stored procedure once and call it multiple times.

### Example: Without Stored Procedure

Suppose you frequently need to retrieve all employees from the IT department.

You repeatedly execute:

```sql
SELECT *
FROM employees
WHERE department = 'IT';
```

### Example: With Stored Procedure

Create a stored procedure:

```sql
DELIMITER //

CREATE PROCEDURE GetITEmployees()
BEGIN
    SELECT *
    FROM employees
    WHERE department = 'IT';
END //

DELIMITER ;
```

Execute it:

```sql
CALL GetITEmployees();
```

Output:

| id | name | department | salary |
|---|---|---|---|
| 1 | Rahul | IT | 50000 |
| 2 | Amit | IT | 60000 |

You can call this procedure whenever you need the IT employees.

### Advantages of Stored Procedures

1. **Reusability:** Write SQL logic once and execute it multiple times.
2. **Maintainability:** Business logic can be centralized in the database.
3. **Security:** Users can be granted permission to execute procedures without receiving direct access to underlying tables.
4. **Reduced application-database communication:** Multiple SQL statements can execute within one procedure call.
5. **Consistency:** The same database-side logic can be reused by different applications.

### Disadvantages

- Debugging can be more difficult than debugging application code.
- Database-specific syntax reduces portability.
- Complex business logic can become difficult to maintain.
- Database resources can become overloaded if too much application logic is moved into procedures.

---

# 2. Creating a Stored Procedure

### Syntax

```sql
DELIMITER //

CREATE PROCEDURE procedure_name()
BEGIN

    -- SQL statements

END //

DELIMITER ;
```

Let's understand each part.

| Component | Meaning |
|---|---|
| DELIMITER // | Temporarily changes the statement delimiter |
| CREATE PROCEDURE | Creates a stored procedure |
| procedure_name | Name of the procedure |
| BEGIN | Starts the procedure body |
| SQL statements | Queries and procedural logic |
| END | Ends the procedure body |
| // | Marks the end of the CREATE statement |

### Why Do We Use DELIMITER?

Normally, MySQL uses a semicolon (`;`) to identify the end of an SQL statement.

However, a stored procedure can contain multiple SQL statements, each ending with a semicolon.

For example:

```sql
CREATE PROCEDURE GetEmployees()
BEGIN
    SELECT * FROM employees;
    SELECT COUNT(*) FROM employees;
END;
```

The client may interpret the first semicolon as the end of the entire CREATE statement.

To avoid this, we temporarily change the delimiter.

```sql
DELIMITER //
```

Now MySQL understands that `//` marks the end of the complete procedure definition.

After creating the procedure, restore the normal delimiter:

```sql
DELIMITER ;
```

**Important:** `DELIMITER` is a client command supported by tools such as MySQL Workbench and the MySQL command-line client. It is not an SQL statement sent to the MySQL server itself.

---

# 3. Calling a Stored Procedure

Use the `CALL` statement.

```sql
CALL GetITEmployees();
```

General syntax:

```sql
CALL procedure_name();
```

If the procedure accepts parameters:

```sql
CALL procedure_name(value1, value2);
```

---

# 4. Viewing and Managing Stored Procedures

### Show Stored Procedures

```sql
SHOW PROCEDURE STATUS;
```

For a specific database:

```sql
SHOW PROCEDURE STATUS
WHERE Db = 'company_db';
```

### View Procedure Definition

```sql
SHOW CREATE PROCEDURE GetITEmployees;
```

### Drop a Procedure

```sql
DROP PROCEDURE GetITEmployees;
```

Safer version:

```sql
DROP PROCEDURE IF EXISTS GetITEmployees;
```

---

# 5. Stored Procedure Parameters

Stored procedures become more useful when they accept parameters.

MySQL supports three parameter modes:

1. IN
2. OUT
3. INOUT

Let's understand each.

## 5.1 IN Parameter

An IN parameter receives a value from the caller.

It is the default parameter mode.

### Example

Create a procedure that retrieves employees belonging to a particular department.

```sql
DELIMITER //

CREATE PROCEDURE GetEmployeesByDepartment(
    IN department_name VARCHAR(50)
)
BEGIN

    SELECT *
    FROM employees
    WHERE department = department_name;

END //

DELIMITER ;
```

Call it:

```sql
CALL GetEmployeesByDepartment('IT');
```

Another example:

```sql
CALL GetEmployeesByDepartment('HR');
```

Here:

- `IN` indicates an input parameter.
- `department_name` is the parameter name.
- `VARCHAR(50)` is its data type.

### Multiple IN Parameters

```sql
DELIMITER //

CREATE PROCEDURE GetEmployeesBySalary(
    IN min_salary DECIMAL(10,2),
    IN max_salary DECIMAL(10,2)
)
BEGIN

    SELECT *
    FROM employees
    WHERE salary BETWEEN min_salary AND max_salary;

END //

DELIMITER ;
```

Call:

```sql
CALL GetEmployeesBySalary(30000, 70000);
```

---

## 5.2 OUT Parameter

An OUT parameter returns a value from the stored procedure to the caller.

### Example

Suppose you want to count the total number of employees.

```sql
DELIMITER //

CREATE PROCEDURE GetEmployeeCount(
    OUT total_employees INT
)
BEGIN

    SELECT COUNT(*)
    INTO total_employees
    FROM employees;

END //

DELIMITER ;
```

Call it:

```sql
CALL GetEmployeeCount(@total);
```

Retrieve the output:

```sql
SELECT @total;
```

Example output:

| @total |
|---:|
| 25 |

### Understanding SELECT INTO

This statement:

```sql
SELECT COUNT(*)
INTO total_employees
FROM employees;
```

Stores the result of the SELECT query into a variable.

Here, `total_employees` is the OUT parameter.

### What Is @total?

`@total` is a MySQL user-defined session variable.

It can retain its value across statements within the same database connection.

Example:

```sql
SET @my_variable = 100;

SELECT @my_variable;
```

Output:

```text
100
```

User-defined variables start with `@`.

---

## 5.3 INOUT Parameter

An INOUT parameter accepts an initial value, modifies it inside the procedure, and returns the modified value.

### Example

```sql
DELIMITER //

CREATE PROCEDURE IncreaseValue(
    INOUT amount INT
)
BEGIN

    SET amount = amount + 100;

END //

DELIMITER ;
```

Call:

```sql
SET @amount = 500;

CALL IncreaseValue(@amount);

SELECT @amount;
```

Output:

```text
600
```

Explanation:

1. Initial value = 500.
2. Procedure receives 500.
3. Procedure adds 100.
4. Updated value = 600.
5. The updated value is available through `@amount`.

### Difference Between IN, OUT and INOUT

| Parameter | Receives Input | Returns Output | Example |
|---|---|---|---|
| IN | Yes | Not as an output parameter | Department name |
| OUT | No meaningful initial input | Yes | Employee count |
| INOUT | Yes | Yes | Updated amount |

---

# 6. Variables Inside Stored Procedures

Variables allow you to temporarily store values while executing a procedure.

### Syntax

```sql
DECLARE variable_name data_type DEFAULT value;
```

Example:

```sql
DECLARE total_salary DECIMAL(10,2) DEFAULT 0;
```

### Important Rule

Local variables must be declared at the beginning of a `BEGIN ... END` block, before other executable statements.

### Example

```sql
DELIMITER //

CREATE PROCEDURE CalculateTotalSalary()
BEGIN

    DECLARE total_salary DECIMAL(10,2) DEFAULT 0;

    SELECT SUM(salary)
    INTO total_salary
    FROM employees;

    SELECT total_salary AS total_salary;

END //

DELIMITER ;
```

Execute:

```sql
CALL CalculateTotalSalary();
```

### Multiple Variables

```sql
DELIMITER //

CREATE PROCEDURE EmployeeStatistics()
BEGIN

    DECLARE total_employees INT DEFAULT 0;
    DECLARE average_salary DECIMAL(10,2) DEFAULT 0;
    DECLARE maximum_salary DECIMAL(10,2) DEFAULT 0;

    SELECT
        COUNT(*),
        AVG(salary),
        MAX(salary)
    INTO
        total_employees,
        average_salary,
        maximum_salary
    FROM employees;

    SELECT
        total_employees,
        average_salary,
        maximum_salary;

END //

DELIMITER ;
```

---

# 7. Conditional Statements in Stored Procedures

Stored procedures support conditional logic.

The most commonly used conditional statement is `IF`.

## 7.1 IF Statement

### Syntax

```sql
IF condition THEN

    -- Statements

END IF;
```

### Example

```sql
DELIMITER //

CREATE PROCEDURE CheckEmployeeSalary(
    IN employee_id INT
)
BEGIN

    DECLARE employee_salary DECIMAL(10,2);

    SELECT salary
    INTO employee_salary
    FROM employees
    WHERE id = employee_id;

    IF employee_salary >= 50000 THEN

        SELECT 'High Salary' AS result;

    END IF;

END //

DELIMITER ;
```

Call:

```sql
CALL CheckEmployeeSalary(1);
```

## 7.2 IF ELSE

```sql
DELIMITER //

CREATE PROCEDURE CheckSalary(
    IN employee_id INT
)
BEGIN

    DECLARE employee_salary DECIMAL(10,2);

    SELECT salary
    INTO employee_salary
    FROM employees
    WHERE id = employee_id;

    IF employee_salary >= 50000 THEN

        SELECT 'High Salary' AS result;

    ELSE

        SELECT 'Low Salary' AS result;

    END IF;

END //

DELIMITER ;
```

## 7.3 IF ELSEIF ELSE

```sql
DELIMITER //

CREATE PROCEDURE SalaryCategory(
    IN employee_id INT
)
BEGIN

    DECLARE employee_salary DECIMAL(10,2);

    SELECT salary
    INTO employee_salary
    FROM employees
    WHERE id = employee_id;

    IF employee_salary >= 80000 THEN

        SELECT 'Excellent' AS category;

    ELSEIF employee_salary >= 50000 THEN

        SELECT 'Good' AS category;

    ELSEIF employee_salary >= 30000 THEN

        SELECT 'Average' AS category;

    ELSE

        SELECT 'Low' AS category;

    END IF;

END //

DELIMITER ;
```

### Important

If the SELECT query returns no rows, the local variable retains its previous value (or its initial/default value if one was assigned). Therefore, initialize variables carefully and handle missing employees explicitly.

We will cover proper error handling later in this phase.

---

# 8. CASE Statement

The CASE statement provides another way to implement conditional logic.

### Syntax

```sql
CASE

    WHEN condition1 THEN
        statements;

    WHEN condition2 THEN
        statements;

    ELSE
        statements;

END CASE;
```

### Example

```sql
DELIMITER //

CREATE PROCEDURE CheckSalaryUsingCase(
    IN employee_id INT
)
BEGIN

    DECLARE employee_salary DECIMAL(10,2);

    SELECT salary
    INTO employee_salary
    FROM employees
    WHERE id = employee_id;

    CASE

        WHEN employee_salary >= 80000 THEN
            SELECT 'Excellent' AS category;

        WHEN employee_salary >= 50000 THEN
            SELECT 'Good' AS category;

        WHEN employee_salary >= 30000 THEN
            SELECT 'Average' AS category;

        ELSE
            SELECT 'Low' AS category;

    END CASE;

END //

DELIMITER ;
```

**Note:** MySQL also supports the CASE expression, which returns a value and can be used directly inside SELECT, UPDATE, and other SQL statements. It is different from the CASE statement used for procedural control flow.

---

# 9. Loops in Stored Procedures

MySQL supports three main loop structures:

1. WHILE
2. REPEAT
3. LOOP

These are useful when you need to execute SQL statements repeatedly.

## 9.1 WHILE Loop

A WHILE loop executes as long as its condition remains true.

### Syntax

```sql
WHILE condition DO

    -- Statements

END WHILE;
```

### Example: Print Numbers from 1 to 5

```sql
DELIMITER //

CREATE PROCEDURE PrintNumbers()
BEGIN

    DECLARE counter INT DEFAULT 1;

    WHILE counter <= 5 DO

        SELECT counter;

        SET counter = counter + 1;

    END WHILE;

END //

DELIMITER ;
```

Execute:

```sql
CALL PrintNumbers();
```

The procedure executes the loop five times.

## 9.2 REPEAT Loop

A REPEAT loop executes its statements first and checks the condition afterward.

Therefore, it executes at least once.

### Syntax

```sql
REPEAT

    -- Statements

UNTIL condition

END REPEAT;
```

### Example

```sql
DELIMITER //

CREATE PROCEDURE PrintNumbersRepeat()
BEGIN

    DECLARE counter INT DEFAULT 1;

    REPEAT

        SELECT counter;

        SET counter = counter + 1;

    UNTIL counter > 5

    END REPEAT;

END //

DELIMITER ;
```

## 9.3 LOOP Statement

LOOP creates a loop without a built-in condition.

You must explicitly terminate it using `LEAVE`.

### Example

```sql
DELIMITER //

CREATE PROCEDURE PrintNumbersLoop()
BEGIN

    DECLARE counter INT DEFAULT 1;

    number_loop: LOOP

        IF counter > 5 THEN

            LEAVE number_loop;

        END IF;

        SELECT counter;

        SET counter = counter + 1;

    END LOOP number_loop;

END //

DELIMITER ;
```

### LEAVE

`LEAVE` exits a labeled loop or block.

### ITERATE

`ITERATE` skips the remaining statements in the current loop iteration and starts the next iteration.

Example:

```sql
DELIMITER //

CREATE PROCEDURE PrintOddNumbers()
BEGIN

    DECLARE counter INT DEFAULT 0;

    number_loop: LOOP

        SET counter = counter + 1;

        IF counter > 10 THEN
            LEAVE number_loop;
        END IF;

        IF MOD(counter, 2) = 0 THEN
            ITERATE number_loop;
        END IF;

        SELECT counter;

    END LOOP number_loop;

END //

DELIMITER ;
```

Output:

```text
1
3
5
7
9
```

### Loop Comparison

| Loop | Condition Checked | Minimum Executions |
|---|---|---|
| WHILE | Before execution | 0 |
| REPEAT | After execution | 1 |
| LOOP | No automatic condition | 0, depending on control flow |

---

# 10. Cursors in Stored Procedures

A cursor allows you to process query results one row at a time.

Normally, SQL operates on sets of rows.

For example:

```sql
UPDATE employees
SET salary = salary + 1000
WHERE department = 'IT';
```

This updates multiple rows in one statement.

However, sometimes you need to perform procedural operations on individual rows.

This is where cursors can be useful.

### Cursor Lifecycle

A cursor generally follows four steps:

1. DECLARE the cursor.
2. OPEN the cursor.
3. FETCH rows.
4. CLOSE the cursor.

### Example

Suppose you want to process employee names one by one.

```sql
DELIMITER //

CREATE PROCEDURE GetEmployeeNames()
BEGIN

    DECLARE finished INT DEFAULT 0;
    DECLARE employee_name VARCHAR(100);

    DECLARE employee_cursor CURSOR FOR
        SELECT name
        FROM employees;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET finished = 1;

    OPEN employee_cursor;

    employee_loop: LOOP

        FETCH employee_cursor INTO employee_name;

        IF finished = 1 THEN
            LEAVE employee_loop;
        END IF;

        SELECT employee_name;

    END LOOP;

    CLOSE employee_cursor;

END //

DELIMITER ;
```

Execute:

```sql
CALL GetEmployeeNames();
```

### Understanding the Important Parts

**1. Declare a variable**

```sql
DECLARE finished INT DEFAULT 0;
```

This tracks whether all rows have been fetched.

**2. Declare a cursor**

```sql
DECLARE employee_cursor CURSOR FOR
    SELECT name FROM employees;
```

This defines the query that the cursor will process.

**3. Declare a handler**

```sql
DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET finished = 1;
```

When FETCH cannot retrieve another row, the handler sets `finished` to 1.

**4. Open cursor**

```sql
OPEN employee_cursor;
```

**5. Fetch rows**

```sql
FETCH employee_cursor INTO employee_name;
```

**6. Close cursor**

```sql
CLOSE employee_cursor;
```

### Important Cursor Rules

- Cursor declarations must come after variable and condition declarations.
- Handler declarations must come after cursor declarations.
- Cursors in MySQL stored programs are read-only and non-scrollable.
- Cursors should not be your first choice for bulk data processing.
- Prefer set-based SQL operations whenever possible.

---

# 11. Stored Functions

A stored function is a reusable database program that returns a single value.

Unlike stored procedures, functions must return a value using `RETURN`.

### Syntax

```sql
DELIMITER //

CREATE FUNCTION function_name(parameters)
RETURNS data_type
DETERMINISTIC
BEGIN

    -- Statements

    RETURN value;

END //

DELIMITER ;
```

### Example: Calculate Annual Salary

Suppose an employee earns ₹50,000 per month.

Annual salary:

```text
50,000 × 12 = 6,00,000
```

Create a function:

```sql
DELIMITER //

CREATE FUNCTION CalculateAnnualSalary(
    monthly_salary DECIMAL(10,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN

    DECLARE annual_salary DECIMAL(12,2);

    SET annual_salary = monthly_salary * 12;

    RETURN annual_salary;

END //

DELIMITER ;
```

Execute:

```sql
SELECT CalculateAnnualSalary(50000);
```

Output:

```text
600000.00
```

### Use a Function Inside SELECT

```sql
SELECT
    name,
    salary,
    CalculateAnnualSalary(salary) AS annual_salary
FROM employees;
```

This is one of the major advantages of stored functions.

You can use them inside SQL expressions.

### What Does DETERMINISTIC Mean?

A deterministic function returns the same result for the same input values.

For example:

```sql
CalculateAnnualSalary(50000)
```

Always returns:

```text
600000
```

A function that depends on the current date or changing database state may be nondeterministic.

MySQL uses the `DETERMINISTIC` and `NOT DETERMINISTIC` characteristics as declarations. They are not a guarantee that MySQL verifies the function's actual behavior.

---

# 12. More Stored Function Examples

## Example 1: Calculate GST

```sql
DELIMITER //

CREATE FUNCTION CalculateGST(
    amount DECIMAL(10,2),
    gst_percentage DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN

    RETURN amount * gst_percentage / 100;

END //

DELIMITER ;
```

Execute:

```sql
SELECT CalculateGST(1000, 18);
```

Output:

```text
180.00
```

## Example 2: Calculate Final Price

```sql
DELIMITER //

CREATE FUNCTION CalculateFinalPrice(
    amount DECIMAL(10,2),
    gst_percentage DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN

    DECLARE gst_amount DECIMAL(10,2);

    SET gst_amount = amount * gst_percentage / 100;

    RETURN amount + gst_amount;

END //

DELIMITER ;
```

Execute:

```sql
SELECT CalculateFinalPrice(1000, 18);
```

Output:

```text
1180.00
```

## Example 3: Calculate Employee Bonus

```sql
DELIMITER //

CREATE FUNCTION CalculateBonus(
    salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN

    IF salary >= 80000 THEN

        RETURN salary * 0.20;

    ELSEIF salary >= 50000 THEN

        RETURN salary * 0.10;

    ELSE

        RETURN salary * 0.05;

    END IF;

END //

DELIMITER ;
```

Execute:

```sql
SELECT
    name,
    salary,
    CalculateBonus(salary) AS bonus
FROM employees;
```

---

# 13. Difference Between Stored Procedures and Stored Functions

This is a very important interview topic.

| Feature | Stored Procedure | Stored Function |
|---|---|---|
| Creation | CREATE PROCEDURE | CREATE FUNCTION |
| Execution | CALL | Used inside expressions |
| Return value | Can return result sets and OUT parameters | Must return one value |
| RETURN statement | Not used to return a value; can exit a block | Required to return a value |
| Parameters | IN, OUT, INOUT | Only IN parameters |
| Use inside SELECT | Not directly | Yes |
| Can contain multiple SQL statements | Yes | Yes |
| Transaction control | Can use transaction statements | Cannot manage transactions |
| Primary purpose | Perform operations | Calculate and return values |

### Example

Procedure:

```sql
CALL GetEmployeeCount(@total);
```

Function:

```sql
SELECT CalculateAnnualSalary(50000);
```

**Remember:**

- Procedure = Perform an operation.
- Function = Calculate and return a value.

### Important Function Restrictions

MySQL stored functions have restrictions compared with procedures.

For example:

- They cannot explicitly start or end transactions using `START TRANSACTION`, `COMMIT`, or `ROLLBACK`.
- They cannot return result sets directly like procedures.
- They cannot call stored procedures that return result sets.
- Their use of data-modifying statements is restricted by MySQL rules, especially when the function is invoked from a statement already using the same table.

For general application design, keep functions focused on calculations and value transformations.

---

# 14. What Are Triggers?

A trigger is a database object that automatically executes when a specified event occurs on a table.

Unlike procedures and functions, you do not call a trigger manually.

MySQL executes it automatically when the triggering event occurs.

Triggers can execute before or after:

- INSERT
- UPDATE
- DELETE

### Six Main Trigger Types

| Trigger | Execution |
|---|---|
| BEFORE INSERT | Before inserting a row |
| AFTER INSERT | After inserting a row |
| BEFORE UPDATE | Before updating a row |
| AFTER UPDATE | After updating a row |
| BEFORE DELETE | Before deleting a row |
| AFTER DELETE | After deleting a row |

MySQL does not support statement-level triggers; these triggers execute once for each affected row.

---

# 15. Creating a Trigger

### General Syntax

```sql
DELIMITER //

CREATE TRIGGER trigger_name
BEFORE INSERT ON table_name
FOR EACH ROW
BEGIN

    -- Trigger logic

END //

DELIMITER ;
```

Let's understand:

| Component | Meaning |
|---|---|
| CREATE TRIGGER | Creates a trigger |
| trigger_name | Name of trigger |
| BEFORE INSERT | Trigger event and timing |
| ON table_name | Table associated with trigger |
| FOR EACH ROW | Executes once per affected row |
| BEGIN ... END | Trigger logic |

---

# 16. OLD and NEW Keywords

Triggers provide two special references:

- `OLD`
- `NEW`

They allow you to access row values involved in the triggering operation.

### OLD

Represents the existing row values.

### NEW

Represents the new row values.

Their availability depends on the trigger event.

| Trigger Event | OLD Available | NEW Available |
|---|---|---|
| INSERT | No | Yes |
| UPDATE | Yes | Yes |
| DELETE | Yes | No |

### Examples

In a BEFORE INSERT trigger:

```sql
NEW.name
NEW.salary
```

In a BEFORE UPDATE trigger:

```sql
OLD.salary
NEW.salary
```

In an AFTER DELETE trigger:

```sql
OLD.name
OLD.salary
```

Important: In a BEFORE INSERT or BEFORE UPDATE trigger, you can modify `NEW.column_name` for supported columns. You cannot modify `OLD` values.

---

# 17. BEFORE INSERT Trigger

Suppose you want to automatically set an employee's creation date before inserting a new employee.

Create a column:

```sql
ALTER TABLE employees
ADD COLUMN created_at DATETIME;
```

Create a trigger:

```sql
DELIMITER //

CREATE TRIGGER BeforeEmployeeInsert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN

    SET NEW.created_at = NOW();

END //

DELIMITER ;
```

Now insert an employee:

```sql
INSERT INTO employees (
    id,
    name,
    salary,
    department
)
VALUES (
    10,
    'Karan',
    50000,
    'IT'
);
```

Check:

```sql
SELECT *
FROM employees
WHERE id = 10;
```

The `created_at` value will be automatically populated.

### Another Example: Validate Salary

```sql
DELIMITER //

CREATE TRIGGER ValidateEmployeeSalary
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN

    IF NEW.salary < 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';

    END IF;

END //

DELIMITER ;
```

Now this query:

```sql
INSERT INTO employees (id, name, salary, department)
VALUES (11, 'Test', -5000, 'IT');
```

Will fail with an error.

`SIGNAL SQLSTATE '45000'` raises a user-defined exception.

**Note:** A CHECK constraint is generally preferable for simple declarative validation. Triggers are useful when validation or actions require more complex logic.

---

# 18. AFTER INSERT Trigger

An AFTER INSERT trigger executes after a row has been successfully inserted.

A common use case is audit logging.

Suppose you have an employee table and want to maintain a log whenever a new employee is added.

### Create Audit Table

```sql
CREATE TABLE employee_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    action VARCHAR(50),
    action_time DATETIME
);
```

### Create Trigger

```sql
DELIMITER //

CREATE TRIGGER AfterEmployeeInsert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN

    INSERT INTO employee_logs (
        employee_id,
        action,
        action_time
    )
    VALUES (
        NEW.id,
        'INSERT',
        NOW()
    );

END //

DELIMITER ;
```

Insert an employee:

```sql
INSERT INTO employees (id, name, salary, department)
VALUES (12, 'Arjun', 60000, 'HR');
```

Check logs:

```sql
SELECT *
FROM employee_logs;
```

A new log entry will be created automatically.

---

# 19. BEFORE UPDATE Trigger

A BEFORE UPDATE trigger executes before an existing row is updated.

### Example: Prevent Negative Salary

```sql
DELIMITER //

CREATE TRIGGER ValidateSalaryUpdate
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN

    IF NEW.salary < 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';

    END IF;

END //

DELIMITER ;
```

Now:

```sql
UPDATE employees
SET salary = -1000
WHERE id = 1;
```

MySQL rejects the update.

### Example: Automatically Update Modified Time

Add a column:

```sql
ALTER TABLE employees
ADD COLUMN updated_at DATETIME;
```

Create the trigger:

```sql
DELIMITER //

CREATE TRIGGER BeforeEmployeeUpdate
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN

    SET NEW.updated_at = NOW();

END //

DELIMITER ;
```

Now every employee update automatically refreshes `updated_at`.

---

# 20. AFTER UPDATE Trigger

An AFTER UPDATE trigger is useful for maintaining an audit history.

Suppose you want to track salary changes.

### Create Salary History Table

```sql
CREATE TABLE employee_salary_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_at DATETIME
);
```

### Create Trigger

```sql
DELIMITER //

CREATE TRIGGER AfterEmployeeSalaryUpdate
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN

    IF OLD.salary <> NEW.salary THEN

        INSERT INTO employee_salary_history (
            employee_id,
            old_salary,
            new_salary,
            changed_at
        )
        VALUES (
            NEW.id,
            OLD.salary,
            NEW.salary,
            NOW()
        );

    END IF;

END //

DELIMITER ;
```

Update salary:

```sql
UPDATE employees
SET salary = 75000
WHERE id = 1;
```

Check history:

```sql
SELECT *
FROM employee_salary_history;
```

Example output:

| employee_id | old_salary | new_salary |
|---|---:|---:|
| 1 | 50000 | 75000 |

This is a common real-world application of triggers.

**Important:** This comparison works for non-NULL salary values. If salary is nullable, use MySQL's NULL-safe equality operator `<=>` to compare values correctly.

For example:

```sql
IF NOT (OLD.salary <=> NEW.salary) THEN
```

---

# 21. AFTER DELETE Trigger

An AFTER DELETE trigger executes after a row is deleted.

It is useful for maintaining deletion logs.

### Example

Create a deletion log table:

```sql
CREATE TABLE employee_delete_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    employee_name VARCHAR(100),
    deleted_at DATETIME
);
```

Create trigger:

```sql
DELIMITER //

CREATE TRIGGER AfterEmployeeDelete
AFTER DELETE ON employees
FOR EACH ROW
BEGIN

    INSERT INTO employee_delete_logs (
        employee_id,
        employee_name,
        deleted_at
    )
    VALUES (
        OLD.id,
        OLD.name,
        NOW()
    );

END //

DELIMITER ;
```

Delete an employee:

```sql
DELETE FROM employees
WHERE id = 12;
```

Check deletion logs:

```sql
SELECT *
FROM employee_delete_logs;
```

The deleted employee's details will be recorded.

---

# 22. BEFORE DELETE Trigger

A BEFORE DELETE trigger executes before a row is deleted.

For example, you may want to prevent deleting employees belonging to a protected department.

```sql
DELIMITER //

CREATE TRIGGER PreventITEmployeeDelete
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN

    IF OLD.department = 'IT' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'IT employees cannot be deleted';

    END IF;

END //

DELIMITER ;
```

Now deleting an IT employee will produce an error.

---

# 23. Viewing and Managing Triggers

### Show Triggers

```sql
SHOW TRIGGERS;
```

For a specific table:

```sql
SHOW TRIGGERS
WHERE `Table` = 'employees';
```

### View Trigger Definition

```sql
SHOW CREATE TRIGGER AfterEmployeeInsert;
```

### Drop Trigger

```sql
DROP TRIGGER AfterEmployeeInsert;
```

Safer:

```sql
DROP TRIGGER IF EXISTS AfterEmployeeInsert;
```

### Important Trigger Rules

- A trigger is associated with a specific table.
- A trigger executes automatically.
- MySQL triggers are row-level.
- You cannot directly call a trigger.
- A trigger cannot explicitly start or end a transaction.
- A trigger cannot modify the same table that is already being modified by the statement that invoked it.
- Trigger actions generally execute as part of the triggering statement's transaction when using InnoDB.
- A failed trigger causes the triggering statement to fail.

---

# 24. Stored Procedures vs Functions vs Triggers

This is one of the most important comparisons in this phase.

| Feature | Stored Procedure | Stored Function | Trigger |
|---|---|---|---|
| Execution | Manually using CALL | Used inside SQL expressions | Automatically |
| Purpose | Perform operations | Return calculated values | Respond to table events |
| Parameters | IN, OUT, INOUT | IN | No regular parameters |
| Return value | Can use OUT parameters and result sets | Must return one value | No direct return value |
| Associated with table | Not necessarily | Not necessarily | Yes |
| Execution event | Explicit call | Explicit invocation | INSERT, UPDATE, DELETE |
| Main use | Business operations | Calculations | Automatic actions |

### Simple Example

**Procedure:**

```sql
CALL GetEmployeesByDepartment('IT');
```

**Function:**

```sql
SELECT CalculateAnnualSalary(50000);
```

**Trigger:**

Automatically executes when:

```sql
INSERT INTO employees (...);
```

---

# 25. Practical Real-World Example: Employee Management System

Let's combine the concepts.

Suppose you are developing an Employee Management System.

It requires:

1. A procedure to add employees.
2. A function to calculate annual salary.
3. A trigger to maintain employee creation logs.
4. A trigger to track salary changes.

### A. Procedure to Add Employee

```sql
DELIMITER //

CREATE PROCEDURE AddEmployee(
    IN p_name VARCHAR(100),
    IN p_salary DECIMAL(10,2),
    IN p_department VARCHAR(50)
)
BEGIN

    INSERT INTO employees (
        name,
        salary,
        department
    )
    VALUES (
        p_name,
        p_salary,
        p_department
    );

END //

DELIMITER ;
```

Execute:

```sql
CALL AddEmployee(
    'Riyaz',
    80000,
    'IT'
);
```

### B. Function to Calculate Annual Salary

```sql
DELIMITER //

CREATE FUNCTION GetAnnualSalary(
    monthly_salary DECIMAL(10,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN

    RETURN monthly_salary * 12;

END //

DELIMITER ;
```

Execute:

```sql
SELECT
    name,
    salary,
    GetAnnualSalary(salary) AS annual_salary
FROM employees;
```

### C. Trigger to Log New Employees

```sql
DELIMITER //

CREATE TRIGGER EmployeeCreationLog
AFTER INSERT ON employees
FOR EACH ROW
BEGIN

    INSERT INTO employee_logs (
        employee_id,
        action,
        action_time
    )
    VALUES (
        NEW.id,
        'EMPLOYEE_CREATED',
        NOW()
    );

END //

DELIMITER ;
```

Now whenever the procedure inserts an employee, the trigger executes automatically.

The overall flow is:

```text
Node.js Application
        |
        v
CALL AddEmployee()
        |
        v
Stored Procedure
        |
        v
INSERT INTO employees
        |
        v
AFTER INSERT Trigger
        |
        v
INSERT INTO employee_logs
```

This demonstrates how stored procedures and triggers can work together.

---

# 26. Error Handling in Stored Procedures

MySQL provides handlers to manage errors and special conditions inside stored programs.

There are three commonly used handler types:

- CONTINUE
- EXIT
- UNDO

`UNDO` is recognized in the syntax but is not supported by MySQL.

## 26.1 CONTINUE Handler

A CONTINUE handler handles a condition and continues execution after the statement that raised it.

Example:

```sql
DELIMITER //

CREATE PROCEDURE TestContinueHandler()
BEGIN

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'An SQL error occurred' AS message;
    END;

    INSERT INTO employees (
        id,
        name,
        salary,
        department
    )
    VALUES (
        1,
        'Duplicate',
        50000,
        'IT'
    );

    SELECT 'Procedure continued' AS status;

END //

DELIMITER ;
```

If the insert fails because the primary key already exists, the handler executes and the procedure continues.

## 26.2 EXIT Handler

An EXIT handler terminates execution of the block in which the handler is declared.

Example:

```sql
DELIMITER //

CREATE PROCEDURE TestExitHandler()
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'An error occurred. Exiting procedure.' AS message;
    END;

    INSERT INTO employees (
        id,
        name,
        salary,
        department
    )
    VALUES (
        1,
        'Duplicate',
        50000,
        'IT'
    );

    SELECT 'This statement may not execute' AS status;

END //

DELIMITER ;
```

If the insert raises an SQL exception, the EXIT handler executes and the procedure's block is exited.

### CONTINUE vs EXIT

| CONTINUE | EXIT |
|---|---|
| Handles the condition and continues after the statement | Handles the condition and exits the declared block |
| Useful when execution can safely continue | Useful when execution should stop |

---

# 27. Using RESIGNAL

Sometimes you want to catch an error, perform cleanup, and pass the original error back to the caller.

Use `RESIGNAL`.

Example:

```sql
DELIMITER //

CREATE PROCEDURE InsertEmployee(
    IN p_id INT,
    IN p_name VARCHAR(100),
    IN p_salary DECIMAL(10,2),
    IN p_department VARCHAR(50)
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN

        ROLLBACK;

        RESIGNAL;

    END;

    START TRANSACTION;

    INSERT INTO employees (
        id,
        name,
        salary,
        department
    )
    VALUES (
        p_id,
        p_name,
        p_salary,
        p_department
    );

    COMMIT;

END //

DELIMITER ;
```

Here:

1. A transaction begins.
2. The employee is inserted.
3. If an SQL exception occurs, the handler rolls back.
4. `RESIGNAL` sends the original error back to the caller.

**Important:** This example assumes the procedure owns the transaction. Avoid embedding transaction control inside reusable procedures that may be called as part of a larger application-managed transaction.

---

# 28. Important Practical Considerations

### 1. Avoid Excessive Stored Procedures

Not every SQL query needs to become a stored procedure.

Use procedures when reusable database-side operations provide a clear benefit.

### 2. Avoid Excessive Triggers

Triggers execute automatically, which can make application behavior harder to trace.

Use them carefully, especially when multiple triggers affect the same table.

### 3. Prefer Constraints for Simple Validation

For example, use:

```sql
CHECK (salary >= 0)
```

Instead of creating a trigger just to validate a simple condition.

### 4. Avoid Cursors When Set-Based SQL Is Possible

Instead of processing rows individually:

```sql
UPDATE employees
SET salary = salary * 1.10
WHERE department = 'IT';
```

Prefer this over fetching every employee into a cursor and updating salaries one at a time.

### 5. Be Careful with DEFINER Security

MySQL routines and triggers have security contexts.

By default, stored routines commonly execute with the privileges of their DEFINER.

Understand `SQL SECURITY DEFINER` and `SQL SECURITY INVOKER` before deploying database routines in production.

### 6. Understand Transaction Behavior

When a trigger modifies another InnoDB table, those changes generally participate in the same transaction as the original statement.

If the original statement fails and rolls back, the trigger's transactional changes roll back too.

---

# 29. Interview Questions and Answers

**Q1. What is a stored procedure?**

A stored procedure is a reusable collection of SQL statements stored inside a database and executed using CALL.

**Q2. What is a stored function?**

A stored function is a reusable database program that returns a single value using RETURN.

**Q3. What is a trigger?**

A trigger is a database object that automatically executes in response to INSERT, UPDATE, or DELETE events on a table.

**Q4. What is the difference between a procedure and a function?**

A procedure is called using CALL and can return result sets and OUT parameters. A function returns a value and can be used inside SQL expressions.

**Q5. What are IN, OUT and INOUT parameters?**

- IN: Receives input.
- OUT: Returns output.
- INOUT: Receives input and returns a modified value.

**Q6. Why do we use DELIMITER?**

It changes the statement delimiter in the MySQL client so that semicolons inside a stored program do not prematurely terminate its definition.

**Q7. What are OLD and NEW in triggers?**

They are special references used to access existing and new row values during trigger execution.

**Q8. Can we execute a trigger manually?**

No. MySQL automatically executes triggers when their associated table events occur.

**Q9. Can MySQL triggers return values?**

No. Triggers do not directly return values to the caller.

**Q10. What is the difference between BEFORE and AFTER triggers?**

BEFORE triggers execute before the row operation, while AFTER triggers execute after the row operation succeeds.

**Q11. Can we modify NEW values?**

Yes, in BEFORE INSERT and BEFORE UPDATE triggers, you can assign values to `NEW` columns.

**Q12. Can we use SELECT inside a stored procedure?**

Yes. A procedure can execute SELECT statements and return result sets to the caller.

**Q13. What is a cursor?**

A cursor allows a stored program to process query results one row at a time.

**Q14. What is a handler?**

A handler specifies how a stored program should respond to conditions such as SQL exceptions or the absence of additional cursor rows.

**Q15. What is the difference between CONTINUE and EXIT handlers?**

CONTINUE resumes execution after the statement that raised the condition. EXIT terminates the block in which the handler is declared.

**Q16. Can a stored function execute COMMIT?**

No. MySQL stored functions cannot explicitly manage transactions using COMMIT or ROLLBACK.

**Q17. Can triggers execute automatically for multiple inserted rows?**

Yes. MySQL triggers are row-level, so a trigger executes once for each affected row.

**Q18. Can a trigger modify the same table that activated it?**

No. MySQL does not allow a trigger to modify a table that is already being modified by the statement that invoked the trigger.

---

# 30. Practical Assignments

Complete these exercises using MySQL Workbench.

### Assignment 1: Basic Stored Procedures

Create procedures to:

1. Retrieve all employees.
2. Retrieve employees by department.
3. Retrieve employees by ID.
4. Retrieve employees whose salary is greater than a given amount.
5. Retrieve employees within a salary range.

### Assignment 2: Parameters

Create procedures using:

1. IN parameter.
2. OUT parameter.
3. INOUT parameter.

Build a procedure that calculates the total salary of employees in a given department.

### Assignment 3: Variables and Conditions

Create a procedure that:

1. Accepts employee ID.
2. Retrieves employee salary.
3. Checks salary using IF ELSE.
4. Returns a salary category.

### Assignment 4: Loops

Create procedures to:

1. Print numbers from 1 to 100.
2. Print even numbers from 1 to 100.
3. Calculate the sum of numbers from 1 to 100.
4. Calculate factorial of a number.

### Assignment 5: Stored Functions

Create functions to calculate:

1. Annual salary.
2. GST amount.
3. Final price including GST.
4. Employee bonus.
5. Discount amount.

Use these functions inside SELECT statements.

### Assignment 6: Triggers

Create triggers to:

1. Automatically set employee creation time.
2. Prevent negative salary.
3. Record newly inserted employees.
4. Track salary changes.
5. Record deleted employee details.

### Assignment 7: Cursors

Create a cursor that:

1. Retrieves employee names.
2. Processes employees one by one.
3. Displays their salary category.
4. Stops when no more records are available.

### Assignment 8: Error Handling

Create a procedure that:

1. Starts a transaction.
2. Inserts an employee.
3. Handles SQL exceptions.
4. Rolls back if an error occurs.
5. Returns the original error using RESIGNAL.

---

# 31. Quick Revision

| Concept | Meaning |
|---|---|
| Stored Procedure | Reusable SQL program executed using CALL |
| Stored Function | SQL program that returns one value |
| Trigger | Automatically executes on a table event |
| DELIMITER | Changes the client-side statement delimiter |
| IN | Input parameter |
| OUT | Output parameter |
| INOUT | Input and output parameter |
| DECLARE | Declares local variables |
| SET | Assigns values |
| IF | Conditional statement |
| CASE | Multiple-condition logic |
| WHILE | Executes while a condition is true |
| REPEAT | Executes until a condition becomes true |
| LOOP | Repeats until explicitly terminated |
| LEAVE | Exits a labeled block or loop |
| ITERATE | Skips to the next loop iteration |
| CURSOR | Processes rows individually |
| HANDLER | Handles SQL conditions |
| OLD | Existing row values |
| NEW | New row values |
| SIGNAL | Raises a user-defined condition |
| RESIGNAL | Passes a condition to the caller |

---

# 32. Phase 22 Completion Checklist

- [ ] Understand stored procedures.
- [ ] Create and execute stored procedures.
- [ ] Understand IN, OUT and INOUT parameters.
- [ ] Use local variables.
- [ ] Implement IF, ELSEIF and ELSE.
- [ ] Use CASE statements.
- [ ] Understand WHILE, REPEAT and LOOP.
- [ ] Use LEAVE and ITERATE.
- [ ] Understand cursors.
- [ ] Create stored functions.
- [ ] Understand DETERMINISTIC functions.
- [ ] Differentiate procedures and functions.
- [ ] Understand triggers.
- [ ] Create all six trigger types.
- [ ] Understand OLD and NEW.
- [ ] Implement audit logging using triggers.
- [ ] Handle SQL exceptions.
- [ ] Understand SIGNAL and RESIGNAL.
- [ ] Integrate stored procedures with Node.js.

---

## Next Phase: Phase 23 – Views and Temporary Tables

Topics we will cover:

1. What are database views?
2. Creating and using views.
3. Updating data through views.
4. WITH CHECK OPTION.
5. Views vs tables.
6. Views vs CTEs.
7. Advantages and limitations of views.
8. Temporary tables.
9. Creating and dropping temporary tables.
10. Temporary tables vs regular tables.
11. Temporary tables vs CTEs.
12. Practical reporting examples.
13. Using views and temporary tables with Node.js.

**Phase 22 is complete.**