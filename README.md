# Lost and Found Management System

A DBMS-based application for managing lost and found items within a campus environment.
This project demonstrates relational database design, data integrity, and structured workflows as part of academic coursework.

---

## Project Purpose

The system is designed to:

* Implement a real-world relational database
* Apply core DBMS concepts (entities, relationships, constraints)
* Maintain structured item reporting and verification
* Demonstrate SQL-based operations and workflows

---

## Core Features

* Users can report items as **lost** or **found**
* Item details are stored with proper relational mapping
* Users can submit **claim requests**
* Admin verifies and updates claim status
* Item lifecycle is controlled through database constraints

---

## Project Structure

```
lost_and_found_2/
│
├── README.md
│
├── database/
│   ├── schema.sql
│   ├── sample_data.sql
│   └── queries.sql
│
├── backend/
│   ├── server.js
│   ├── db.js
│   ├── package.json
│   └── package-lock.json
│
├── frontend/
│   ├── index.html
│   ├── login.html
│   ├── add_lost.html
│   ├── add_found.html
│   ├── claim.html
│   ├── script.js
│   └── style.css
│
└── .gitignore
```

---

## How to Run

### 1. Setup Database

Create database:

```sql
CREATE DATABASE lost_and_found;
```

Import schema:

```bash
mysql -u root -p lost_and_found < database/schema.sql
```

Insert sample data:

```bash
mysql -u root -p lost_and_found < database/sample_data.sql
```

---

### 2. Setup Backend

```bash
cd backend
npm install
node server.js
```

Server should run on:

```
http://localhost:3000
```

---

### 3. Run Frontend

* Open `frontend/index.html` in browser
  OR
* Use Live Server (recommended)

---

## Database Design

### Main Entities

* `users`
* `items`
* `lost_reports`
* `found_reports`
* `claims`

### Key Design Principles

* Primary keys for unique identification
* Foreign keys for referential integrity
* ENUM-based status (`lost`, `found`, `claimed`)
* Normalized schema to reduce redundancy
* Controlled claim verification workflow

---

## 4. Verification Workflow

1. A user reports an item as **lost**
2. Another user reports the item as **found**
3. Owner submits a **claim request**
4. Admin reviews the request
5. If approved, item status becomes **claimed**

---

## Sample SQL Operations

### View lost items

```sql
SELECT * FROM items WHERE status = 'lost';
```

### View pending claims

```sql
SELECT * FROM claims WHERE status = 'requested';
```

### Approve a claim

```sql
UPDATE claims
SET status = 'approved'
WHERE claim_id = 1;
```

---

## Technologies Used

* MySQL / MariaDB
* Node.js (Express)
* HTML, CSS, JavaScript
* Git & GitHub

---

## Important Notes

* Ensure MySQL is running before starting backend
* Update database credentials in `backend/db.js` if needed
* Do NOT upload `.env` or sensitive credentials

---

## Scope

This project focuses on:

* Database design
* Schema implementation
* SQL queries and workflows

Frontend and backend are minimal and only for demonstration purposes.

---

## Authors

* Paarth Jawaharani
* Pranav Jain

---

