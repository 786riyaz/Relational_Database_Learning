## What is MVCC (Multi-Version Concurrency Control)?

**MVCC** is a **database concurrency control technique** that allows **multiple transactions to read and write the same data at the same time without blocking each other**.

The core idea is simple:

> **Instead of overwriting data, the database keeps multiple versions of the same row.**

Each transaction sees the **version that was valid when it started**.

---

![Image](https://vladmihalcea.com/wp-content/uploads/2017/03/mvcc_insert.png)

![Image](https://mbukowicz.github.io/images/snapshot-isolation-in-postgresql/mvcc_snapshot_isolation.png)

![Image](https://media.geeksforgeeks.org/wp-content/uploads/20251206124420281709/419337644.webp)

---

## Why MVCC Exists

Traditional locking systems cause problems:

* Readers block writers
* Writers block readers
* High contention → slow performance

MVCC solves this by:

* Letting **readers read old versions**
* Letting **writers create new versions**
* Avoiding read locks

---

## How MVCC Works (Step by Step)

### Initial State

```
Row X = 100
```

### Transaction T1 starts (READ)

* Takes a **snapshot**
* Sees `X = 100`

### Transaction T2 starts (WRITE)

* Updates X to `200`
* Creates a **new version**
* Commits

Now the database has:

```
Version 1: X = 100 (old)
Version 2: X = 200 (new)
```

### What each transaction sees

* **T1** → still sees `100`
* **New transactions** → see `200`

No blocking. No waiting.

---

## Key Concepts in MVCC

### 1. Snapshot Isolation

Each transaction works on a **consistent snapshot** of the database taken at transaction start.

---

### 2. Row Versioning

Instead of locking rows:

* Old versions are kept
* New versions are created on update

---

### 3. Transaction IDs (TXID)

Each row version is tagged with:

* Created-by transaction ID
* Deleted-by transaction ID (if applicable)

The database decides **which version is visible**.

---

## MVCC vs Lock-Based Concurrency

| Aspect              | MVCC            | Lock-Based       |
| ------------------- | --------------- | ---------------- |
| Read blocking write | ❌ No            | ✅ Yes            |
| Write blocking read | ❌ No            | ✅ Yes            |
| Performance         | High            | Lower under load |
| Complexity          | Higher          | Simpler          |
| Storage             | More (versions) | Less             |

---

## Where MVCC Is Used

Databases that use MVCC include:

* PostgreSQL
* MySQL (InnoDB)
* Oracle
* SQL Server (snapshot isolation)
* MongoDB (WiredTiger)

This is why they scale well with **many concurrent users**.

---

## MVCC and Common Anomalies

### What MVCC Prevents

* Dirty reads
* Read locks

### What It May Still Allow (depending on isolation level)

* Non-repeatable reads
* Phantom reads

MVCC works together with **isolation levels** to control this.

---

## Garbage Collection (Important)

Because old versions are kept:

* Database periodically **cleans up unused versions**
* Called:

  * `VACUUM` (PostgreSQL)
  * Purge (MySQL InnoDB)

Without cleanup → storage bloat.

---

## Real-World Analogy (Interview-Friendly)

Imagine **Google Docs**:

* Each editor sees a consistent version
* Changes don’t block others
* System merges versions intelligently

That is MVCC.

---

## Interview One-Liner

> “MVCC is a concurrency control mechanism where databases maintain multiple versions of data so that readers and writers do not block each other, providing high concurrency through snapshot isolation.”

---

## Common Interview Follow-Ups

**Q: Does MVCC use locks at all?**
Yes, but mainly for **writes**, not reads.

**Q: Is MVCC faster than locking?**
Under high concurrency, yes.

**Q: What is the tradeoff?**
More memory/storage and cleanup overhead.

---

## Quick Summary

* MVCC = multiple versions of rows
* Readers never block writers
* Writers create new versions
* Each transaction sees a snapshot
* Essential for high-concurrency systems

If you want, I can next explain:

* MVCC vs Locking with SQL examples
* MVCC in PostgreSQL vs MySQL
* Isolation levels + MVCC
* How MVCC affects performance in real apps

Tell me what to continue with.
