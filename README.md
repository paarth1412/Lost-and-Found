# Lost and Found Management System

A DBMS-based application for managing lost and found items within a campus environment.  
This project demonstrates relational database design, data integrity, and structured workflows as part of academic coursework.

---

## Project Purpose

The system is designed to:

- Implement a real-world relational database
- Apply core DBMS concepts (entities, relationships, constraints)
- Maintain structured item reporting and verification
- Demonstrate SQL-based operations and workflows

---

## Core Features

- Users can report items as **lost** or **found**
- Item details are stored with proper relational mapping
- Users can submit **claim requests**
- Admin verifies and updates claim status
- Item lifecycle is controlled through database constraints

## Database Design

### Main Entities

- `users`
- `items`
- `lost_reports`
- `found_reports`
- `claims`

### Key Design Principles

- Primary keys for unique identification
- Foreign keys to maintain referential integrity
- ENUM-based status control (`lost`, `found`, `claimed`)
- Normalized schema to reduce redundancy
- Controlled claim verification workflow

---

## Project Structure

```

Lost-and-Found/
│
├── README.md
├── db/
│   ├── schema.sql
│   ├── sample_data.sql
│   └── queries.sql
└── src/ (optional backend)

````

---

## How to Run

### 1. Create Database & Tables

```bash
mysql -u <username> -p < db/schema.sql
````

### 2. Insert Sample Data

```bash
mysql -u <username> -p lost_and_found < db/sample_data.sql
```

### 3. Verify Data

```sql
USE lost_and_found;
SELECT * FROM users;
SELECT * FROM items;
SELECT * FROM claims;
```

---

## Verification Workflow

1. A user reports an item as lost.
2. Another user may report the same item as found.
3. The original owner submits a claim request.
4. The administrator reviews the request.
5. If approved, the item status changes to `claimed`.

---

## Sample SQL Operations

View lost items:

```sql
SELECT * FROM items WHERE status = 'lost';
```

View pending claims:

```sql
SELECT * FROM claims WHERE status = 'requested';
```

Approve a claim:

```sql
UPDATE claims
SET status = 'approved'
WHERE claim_id = 1;
```

---

## Technologies Used

* MariaDB (MySQL compatible)
* Ubuntu (WSL)
* Node.js (optional backend)
* Git & GitHub

---

## Scope

This project focuses strictly on database design, schema implementation, and SQL operations.
Frontend development, authentication systems, and deployment are outside the scope of this coursework.

---

## Authors

* Pranav Jain
* Paarth Jawaharani

---
