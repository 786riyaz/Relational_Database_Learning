# 1. What is the N+1 Query Problem?

The **N+1 problem** happens when an application:

1. Executes **1 query** to fetch a list of parent records
2. Executes **N additional queries** — one for each parent — to fetch related data

Total queries = **1 + N** → inefficient and slow.

---

![Image](https://www.prakashbhandari.com.np/images/posts/how-to-avoid-the-n%2B1-query-problem-with-eager-loading/how-to-avoid-the-n%2B1-query-problem-with-eager-loading.png)

![Image](https://i.sstatic.net/rZJne.png)

![Image](https://miro.medium.com/v2/resize%3Afit%3A1400/1%2ASAWpA7ssaV-qWYAI-1JbMg.png)

---

## Example Scenario

**Tables**

```
users
id | name

orders
id | user_id | total
```

Each user has many orders.

---

## ❌ Bad Example (N+1 Problem)

### Using ORM (Conceptual)

```js
const users = await User.findAll();

for (const user of users) {
  const orders = await user.getOrders();
}
```

### What Happens in Database

```sql
SELECT * FROM users;              -- 1 query
SELECT * FROM orders WHERE user_id = 1;
SELECT * FROM orders WHERE user_id = 2;
SELECT * FROM orders WHERE user_id = 3;
-- ...
```

If there are **100 users**:

* 1 query for users
* 100 queries for orders
* **101 queries total**

---

## Why This Is a Serious Problem

* High latency
* Excessive DB load
* Poor scalability
* Slows down APIs dramatically

---

## ✅ Good Example (Solving N+1)

### Solution 1: Eager Loading

```js
const users = await User.findAll({
  include: Order
});
```

### Database Query (Simplified)

```sql
SELECT users.*, orders.*
FROM users
LEFT JOIN orders ON users.id = orders.user_id;
```

✔ Only **1 query**
✔ Much faster

---

### Solution 2: Batch Fetching

```js
const users = await User.findAll();
const userIds = users.map(u => u.id);

const orders = await Order.findAll({
  where: { user_id: userIds }
});
```

Queries:

```sql
SELECT * FROM users;
SELECT * FROM orders WHERE user_id IN (...);
```

✔ Only **2 queries**

---

## How to Detect N+1 (Interview Tip)

* Enable query logging
* Watch for repeated similar queries
* Use ORM profiling tools

---

## Databases / ORMs Where N+1 Commonly Appears

* Sequelize
* TypeORM
* Hibernate
* Django ORM

---

## Interview One-Liner (N+1)

> “The N+1 problem occurs when one query fetches a list of entities and N additional queries are executed to fetch related data, causing severe performance issues.”