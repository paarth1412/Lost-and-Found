# Lost and Found Management System

## Project Overview

The **Lost and Found Management System** is a database-driven application designed to help users report, search, and recover lost items using a centralized system.  
This project is developed as part of the **DBMS laboratory coursework** and focuses on correct database design, data integrity, and structured interaction between users and stored information.

---

## Objective

The primary objectives of this project are:
- To design and implement a relational database for a real-world problem
- To apply DBMS concepts such as entities, relationships, keys, and constraints
- To provide a simple and logical workflow for reporting and managing lost and found items

---

## System Description

The system allows users to:
- Report items as **lost** or **found**
- Store item details such as description, category, location, and date
- Search for reported items
- Claim items after verification

An administrator verifies claims and updates item status to ensure correctness and prevent misuse.

---

## User Roles

### User
- Register and log in
- Report lost or found items
- Search items in the system
- Request to claim an item

### Administrator
- View all reports
- Verify claim requests
- Update item status (lost / found / claimed)

---

## Database Setup

- MariaDB is used as the relational database management system
- MariaDB is installed and configured on Ubuntu (WSL)
- A project-specific database is created
- A dedicated database user is configured with required privileges
- Tables are created using SQL scripts provided in the repository

The database setup ensures referential integrity and supports all project operations.

---

## ER Model

The database design is based on a clear Entity–Relationship (ER) model.

### Entities
- **User**
- **Item**
- **LostReport**
- **FoundReport**
- **Claim**

### Relationships
- A user can report multiple items
- An item can have lost and/or found reports
- A user can submit claim requests for items
- An administrator verifies claims and updates item status

### Cardinality and Participation
- Item participation in reports is total
- User participation is partial
- Claim participation is optional until a claim is requested

### Design Constraints
- Primary keys uniquely identify entities
- Foreign keys enforce referential integrity
- Email in the User entity is unique
- Item status controls state transitions (lost / found / claimed)

Detailed ER diagram and relational schema are documented as part of the project design.

---

## Scope of the Project

This project focuses on:
- Database setup and configuration
- Schema design and relationships
- SQL-based data management
- Basic backend interaction with the database

Advanced features such as payment systems, machine learning, or large-scale deployment are outside the scope of this project.

---

## Conclusion

The Lost and Found Management System demonstrates the practical application of DBMS concepts through a real-world use case.  
The project emphasizes proper database design, clarity, and reproducibility.
