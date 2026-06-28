## What is an ORM?

**ORM (Object–Relational Mapping)** is a programming technique that lets you **interact with a relational database using objects instead of writing raw SQL queries**.

In short:

> **ORM maps database tables ↔ application objects.**

---

![Image](https://www.altexsoft.com/static/content-image/2024/11/7fcc50e2-aadc-4952-93c8-3e7df04670cf.png)

![Image](https://www.techtarget.com/rms/onlineimages/orm_vs_sql-f_mobile.png)

![Image](https://agiledata.org/wp-content/uploads/2023/03/mappingObjectRelationships.gif)

---

## Why ORMs Exist

Without an ORM:

* You write raw SQL
* Manually convert rows → objects
* Handle joins, transactions, and security yourself

With an ORM:

* You work with **classes and objects**
* ORM handles:

  * SQL generation
  * Result mapping
  * Parameter binding (prevents SQL injection)

---

## How ORM Works (Conceptually)

### Database Table

```
users
----------------
id | name | email
```

### Application Object

```js
User {
  id: 1,
  name: "Riyaz",
  email: "riyaz@example.com"
}
```

The ORM handles conversion **both ways**.

---

## Example (Node.js ORM – Conceptual)

### Without ORM (Raw SQL)

```js
db.query("SELECT * FROM users WHERE id = ?", [id]);
```

### With ORM

```js
User.findByPk(id);
```

You think in **objects**, not SQL.

---

## Popular ORMs (Contextual Examples)

### In Node.js

* Sequelize
* TypeORM
* Prisma

### In Other Ecosystems

* Hibernate (Java)
* Entity Framework (.NET)
* Django ORM (Python)

---

## ORM vs Query Builder (Important Distinction)

| Aspect         | ORM      | Query Builder |
| -------------- | -------- | ------------- |
| Abstraction    | High     | Medium        |
| Uses models    | Yes      | No            |
| SQL control    | Lower    | Higher        |
| Learning curve | Moderate | Lower         |

Example of Query Builder:

```js
knex("users").where({ id: 1 });
```

---

## Advantages of ORM

* Faster development
* Cleaner, readable code
* Database-agnostic
* Built-in migrations
* Automatic security (SQL injection protection)

---

## Disadvantages of ORM (Interview Gold)

* Performance overhead
* Complex queries can be inefficient
* Hidden SQL (hard to debug)
* “N+1 query problem”

> ORMs trade **control** for **productivity**.

---

## ORM and MVCC (Connection)

In MVCC-based databases:

* ORM works with **transactions**
* Snapshot isolation is handled by DB
* ORM simply manages transaction boundaries

---

## When to Use ORM

Use ORM when:

* CRUD-heavy application
* Rapid development
* Small to medium complexity
* Team prefers abstraction

---

## When NOT to Use ORM

Avoid ORM when:

* Extremely complex queries
* Performance-critical analytics
* Heavy reporting systems
* Fine-grained SQL tuning required

Many teams use:

> **ORM + Raw SQL (hybrid approach)**

---

## Interview One-Liner

> “ORM is a technique that maps database tables to application objects, allowing developers to interact with relational databases using object-oriented code instead of raw SQL.”

---

## Common Interview Follow-Ups

**Q: Does ORM replace SQL completely?**
No. SQL knowledge is still required.

**Q: Is ORM slower than SQL?**
Raw SQL is usually faster for complex queries.

**Q: What is the N+1 problem?**
Repeated queries caused by lazy loading relations.

---

## Quick Summary

* ORM abstracts SQL into objects
* Improves developer productivity
* Trades performance for convenience
* Best used with understanding of SQL

If you want, I can next explain:

* ORM vs ODM (MongoDB)
* Sequelize vs Prisma
* N+1 problem with examples
* How ORMs work internally

Tell me what to continue with.
