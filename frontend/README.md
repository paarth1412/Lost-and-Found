## Overview

The frontend is built using **plain HTML, CSS, and JavaScript (no frameworks)**, focusing on:

- Simplicity and readability
- Clean UI/UX with consistent design system
- Direct interaction with backend APIs
- Modular and reusable utility functions

---

## Structure

```

frontend/
│
├── index.html        # Dashboard (overview + stats + items)
├── login.html        # Authentication (login, register, forgot password)
├── add_lost.html     # Report lost items
├── add_found.html    # Report found items
├── claim.html        # Claim items + admin approval system
│
├── script.js         # Shared JS logic (API calls, auth, helpers)
└── style.css         # Global styling and design system

```

---

## Pages & Features

### 1. Dashboard (`index.html`)
- Displays system overview  
- Stats: Lost, Found, Claimed, Pending  
- Filterable items table (by status)  
- Data fetched from backend dynamically :contentReference[oaicite:0]{index=0}  

---

### 2. Authentication (`login.html`)
- **Sign In / Register / Forgot Password (3-step flow)**
- Password strength meter
- Security question-based recovery
- Session stored using `sessionStorage` :contentReference[oaicite:1]{index=1}  

---

### 3. Report Lost (`add_lost.html`)
- Submit lost item details  
- Includes:
  - Item info (name, description, category)
  - Reporter details
  - Location & date
- Displays recent lost reports dynamically :contentReference[oaicite:2]{index=2}  

---

### 4. Report Found (`add_found.html`)
- Similar to lost reporting but for found items  
- Creates item + found report entries  
- Displays recent found items :contentReference[oaicite:3]{index=3}  

---

### 5. Claims (`claim.html`)
- Users can:
  - Submit claims for found items
- Admins can:
  - Approve / Reject claims
- Includes filtering (All / Pending / Approved / Rejected)
- Role-based UI behavior :contentReference[oaicite:4]{index=4}  

---

## Core Frontend Logic

### API Interaction
Handled via shared helpers in `script.js`:
- `getJSON()` → fetch data  
- `postJSON()` → create records  
- `patchJSON()` → update records  

---

### State Management
- Uses **`sessionStorage`** for:
  - `user_id`
  - `user_name`
  - `user_role`
- Enables:
  - Authentication checks
  - Role-based UI (admin vs user)

---

### Form Handling
- Client-side validation:
  - Required fields
  - Phone number format (10 digits)
- Feedback via alert system:
  - Success / Error messages

---

### Dynamic Rendering
- Tables are rendered using `.map()` on fetched data
- Empty states handled gracefully
- Date formatting uses `toLocaleDateString('en-IN')`

---

## Styling System

Defined in `style.css`:

- **CSS Variables (Design Tokens)**  
  - Colors: status-based (lost = amber, found = green, claimed = blue)
  - Typography: Playfair Display, DM Sans, DM Mono
- Components:
  - Cards, tables, badges, buttons, alerts
- Responsive layout with clean spacing and grid usage :contentReference[oaicite:5]{index=5}  

---

## Key Design Decisions

- No frameworks → better control + simplicity
- Status-driven UI (lost / found / claimed)
- Separation of concerns:
  - HTML → structure  
  - CSS → design system  
  - JS → logic + API  
- Reusable utility functions instead of duplication

---

## Running the Frontend

1. Start backend server (default: `http://localhost:3000`)
2. Open `login.html` or `index.html` in browser
3. Ensure API endpoints are accessible

---

## Notes

- Frontend assumes backend is running and reachable
- No build step required (pure static frontend)
- Designed for **clarity, not complexity**

---
