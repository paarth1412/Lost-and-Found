# Database — Lost & Found Management Syste

This folder defines the **relational database layer** of the system.

It captures the **schema, relationships, constraints, and seed data** required to support item reporting, tracking, and claiming.

---

## Structure

```

database/
│
├── schema.sql        # Tables, constraints, indexes
└── sample_data.sql   # Seed data for testing/demo

````

---

## Core Architecture

### Central Model

The system is built around a **single `items` table**.

All workflows (lost, found, claims) are modeled as **extensions of this core entity**, ensuring:

- No duplication  
- Strong consistency  
- Simple querying  

---

## Tables

### `users`
Stores registered accounts.

**Fields:**
- `user_id` (PK)
- `email` (unique)
- `role` (`user`, `admin`)
- `security_question`, `security_answer` (hashed)

---

### `items` *(Core Table)*
Represents every item in the system.

**Responsibilities:**
- Tracks lifecycle via `status`: `lost`, `found`, `claimed`
- Stores reporter details directly (no mandatory user dependency)

**Fields:**
- `item_id` (PK)
- `name`, `description`, `category`
- `status`
- `reporter_name`, `reporter_phone`
- `created_at`

---

### `lost_reports`
Extends `items` with lost-specific data.

**FK:** `item_id → items(item_id)`

**Fields:**
- `lost_location`
- `lost_date`
- Reporter snapshot

---

### `found_reports`
Extends `items` with found-specific data.

**FK:** `item_id → items(item_id)`

**Fields:**
- `found_location`
- `found_date`
- Reporter snapshot

---

### `claims`
Handles ownership claims and review workflow.

**FKs:**
- `item_id → items`
- `claimed_by → users`
- `reviewed_by → users (admin)`

**Lifecycle:**
`requested → approved / rejected`

**Fields:**
- `status`
- `notes`
- `claim_date`

---

## Relationships

- `items` is the **central hub**
- `lost_reports` and `found_reports` are **1-to-1 extensions**
- `claims` links **users ↔ items**
- Admins review and finalize claims

---

## Constraints & Design Decisions

- **Foreign keys** enforce referential integrity  
- **ENUMs** standardize:
  - item status  
  - claim status  
  - user roles  
- **Reporter data stored in `items`:**
  - enables reporting without user accounts  
- **Role control enforced at API level:**
  - registration defaults to `user`  

---

## Indexing Strategy

Indexes optimize common access patterns:

- `items.status`
- `lost_reports.item_id`
- `found_reports.item_id`
- `claims.item_id`
- `claims.claimed_by`

---

## Seed Data

`sample_data.sql` provides:

- Predefined users (including admin)
- Sample items and claims

**Defaults:**
- Password: `password`
- Security answer: `password`

---

## Setup

```sql
SOURCE schema.sql;
SOURCE sample_data.sql;
````

Or:

```sql
CREATE DATABASE lost_and_found;
USE lost_and_found;
```

---

## Key Design Choices

* **Single source of truth:** `items` drives the system
* **Schema simplicity:** reduces backend complexity

---

## Notes

* Designed to align tightly with backend APIs
* Prioritizes **correct modeling over over-engineering**
* Balances **practical usability** with **academic clarity**

---

