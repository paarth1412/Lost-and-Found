# Lost & Found Management System

A structured, end-to-end platform for managing lost and found items within a campus or organizational environment, designed to bring clarity, accountability, and efficiency to an otherwise chaotic process.

> Items are tracked primarily by **status**, and optionally organized by **categories**. The system functions fully even without categories, using status as the core organizing principle.

---

## Overview

Misplaced items are a daily reality in any shared environment. Traditional notice boards, informal messaging, or word-of-mouth are inefficient and unreliable.

This system introduces a **centralized, trackable, and verifiable workflow** that enables users to:
- Report lost and found items  
- Discover potential matches  
- Submit and validate ownership claims  
- Ensure accountability through admin moderation  

The result is a **transparent lifecycle for every item**, from loss to recovery.

---

## Current Scope & Future Enhancements

### 1. Authentication & SSO
**Current state:** Custom email/password registration with bcrypt hashing and security-question reset.  
**The problem:** Students already have institutional credentials (Google Workspace, Microsoft, Apple). Asking them to create yet another account reduces adoption.  
**Future goal:** Integrate OAuth 2.0 (Google Sign-In or Microsoft SSO) so users can log in with their campus accounts.

### 2. Session & Authorization (No Real Auth System)
**Current state:** After login, the frontend stores `user_id`, `name`, and `role` in `sessionStorage`. No JWTs, no server-side sessions, no expiry.  
**The problem:** Any user can open DevTools and manually set `role = "admin"` to see admin UI. The backend does verify some actions, but the frontend is trust‑based.  
**Future goal:** Implement stateless JWT tokens (or `express-session` with Redis) with proper expiry and signed roles.

### 3. Report Integrity – Misclassified Reports (Lost Instead of Found)
**Current state:** Users can independently submit lost or found reports without validation of report type or cross-checking against existing entries.  
**The problem:** A person who finds an item may mistakenly (or intentionally) register it as a lost report instead of a found report. This creates confusion in the system and prevents the actual owner from discovering and claiming their item through the correct flow.  
**Future goal:** Introduce validation mechanisms and smart prompts to guide users in selecting the correct report type. Implement cross-checking between similar lost and found entries and allow admins to reclassify incorrect reports when necessary.

### 4. Privacy – Reporter Phone Numbers Are Publicly Visible
**Current state:** The dashboard and report pages expose every reporter’s phone number to any visitor – no login required.  
**The problem:** Displaying personal phone numbers of students on a public‑facing URL is a privacy risk.  
**Future goal:** Mask phone numbers for unauthenticated users (e.g., show `98765XXXXX`) and reveal the full number only to logged‑in users or admins.

### 5. Image Support – No Photo Attachments
**Current state:** Items are described only with text. No facility for uploading photos of lost or found items.  
**The problem:** A photo of a found wallet resolves ambiguity immediately. Without images, identification relies entirely on text and in‑person verification, making self‑service less effective.  
**Future goal:** Add image upload using `multer`, store files locally or in a cloud bucket (AWS S3), and display thumbnails on the dashboard.

---

## Key Features

### User System
- Secure **registration and login**
- **Password recovery** via security questions
- Session-based authentication

### Item Reporting
- Report items as **Lost** or **Found**
- Structured input for descriptions and identification
- Status-driven tracking of items

### Claim Workflow
- Users submit **ownership claims**
- Claims are tied directly to item records
- Prevents uncontrolled or duplicate recovery attempts

### Admin Moderation
- Centralized review of claims
- Approve / reject based on validation
- Maintains system integrity

### Dashboard & Visibility
- View:
  - Lost items  
  - Found items  
  - Claimed items  
  - Pending claims  

---

## System Workflow

```
Report Lost → Report Found → Submit Claim → Admin Review → Approved → Item Recovered
```

### Flow Summary

1. A user reports an item as **lost**  
2. Another user reports a similar item as **found**  
3. The owner submits a **claim request**  
4. Admin verifies ownership  
5. If approved → item is marked **claimed**  

---

## System Design

### Core Entities

| Entity          | Purpose |
|----------------|--------|
| `users`        | User identity and authentication |
| `items`        | Central item records |
| `lost_reports` | Lost item entries |
| `found_reports`| Found item entries |
| `claims`       | Ownership requests |

### Design Highlights

- Strong **relational integrity** via foreign keys  
- **Normalized schema** to reduce redundancy  
- Controlled **status lifecycle** (`lost → found → claimed`)  
- Clear separation of reporting and verification  

---

## Project Structure

```
lost_and_found/
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
└── README.md
```

---

## Getting Started

### 1. Database Setup

```sql
CREATE DATABASE lost_and_found;
```

```bash
mysql -u root -p lost_and_found < database/schema.sql
mysql -u root -p lost_and_found < database/sample_data.sql
```

---

### 2. Backend Setup

```bash
cd backend
npm install
node server.js
```

Server runs at:

```
http://localhost:3000
```

---

### 3. Frontend

* Open `frontend/index.html`
  **or**
* Use Live Server (recommended)

---

## Example Operations

```sql
-- View lost items
SELECT * FROM items WHERE status = 'lost';

-- View pending claims
SELECT * FROM claims WHERE status = 'requested';

-- Approve a claim
UPDATE claims
SET status = 'approved'
WHERE claim_id = 1;
```

---

## Tech Stack

* **Database:** MySQL / MariaDB
* **Backend:** Node.js (Express)
* **Frontend:** HTML, CSS, JavaScript
* **Version Control:** Git & GitHub

---

## Important Notes

* Ensure MySQL is running before starting backend
* Update credentials in `backend/db.js` if needed
---

## Contributors

* Paarth Jawaharani
* Pranav Jain

---

