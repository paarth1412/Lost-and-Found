const express = require('express');
const cors = require('cors');
const db = require('./db');

const app = express();

app.use(cors());
app.use(express.json());

/* =========================
   ROOT
========================= */
app.get('/', (req, res) => {
    res.send('Lost & Found API running');
});

/* =========================
   USERS
========================= */
app.post('/users', (req, res) => {
    const { name, email, phone, role } = req.body;

    const query = `
        INSERT INTO users (name, email, phone, role)
        VALUES (?, ?, ?, ?)
    `;

    db.query(query, [name, email, phone, role || 'user'], (err, result) => {
        if (err) return res.status(500).send(err);
        res.send({ message: 'User created', user_id: result.insertId });
    });
});

app.get('/users', (req, res) => {
    db.query('SELECT * FROM users', (err, result) => {
        if (err) return res.status(500).send(err);
        res.send(result);
    });
});

/* =========================
   ADD LOST ITEM
========================= */
app.post('/lost', (req, res) => {
    const {
        name,
        description,
        category,
        reported_by,
        lost_location,
        lost_date
    } = req.body;

    const itemQuery = `
        INSERT INTO items (name, description, category, status, reported_by)
        VALUES (?, ?, ?, 'lost', ?)
    `;

    db.query(itemQuery, [name, description, category, reported_by], (err, itemResult) => {
        if (err) return res.status(500).send(err);

        const item_id = itemResult.insertId;

        const lostQuery = `
            INSERT INTO lost_reports (item_id, user_id, lost_location, lost_date)
            VALUES (?, ?, ?, ?)
        `;

        db.query(lostQuery, [item_id, reported_by, lost_location, lost_date], (err2) => {
            if (err2) return res.status(500).send(err2);

            res.send({ message: 'Lost item added', item_id });
        });
    });
});

/* =========================
   ADD FOUND ITEM
========================= */
app.post('/found', (req, res) => {
    const {
        name,
        description,
        category,
        reported_by,
        found_location,
        found_date
    } = req.body;

    const itemQuery = `
        INSERT INTO items (name, description, category, status, reported_by)
        VALUES (?, ?, ?, 'found', ?)
    `;

    db.query(itemQuery, [name, description, category, reported_by], (err, itemResult) => {
        if (err) return res.status(500).send(err);

        const item_id = itemResult.insertId;

        const foundQuery = `
            INSERT INTO found_reports (item_id, user_id, found_location, found_date)
            VALUES (?, ?, ?, ?)
        `;

        db.query(foundQuery, [item_id, reported_by, found_location, found_date], (err2) => {
            if (err2) return res.status(500).send(err2);

            res.send({ message: 'Found item added', item_id });
        });
    });
});

/* =========================
   GET ITEMS
========================= */
app.get('/items', (req, res) => {
    const query = `
        SELECT i.*, u.name AS reported_by_name
        FROM items i
        JOIN users u ON i.reported_by = u.user_id
        ORDER BY i.created_at DESC
    `;

    db.query(query, (err, result) => {
        if (err) return res.status(500).send(err);
        res.send(result);
    });
});

/* =========================
   SEARCH
========================= */
app.get('/search', (req, res) => {
    const q = `%${req.query.q}%`;

    const query = `
        SELECT * FROM items
        WHERE name LIKE ? OR description LIKE ? OR category LIKE ?
    `;

    db.query(query, [q, q, q], (err, result) => {
        if (err) return res.status(500).send(err);
        res.send(result);
    });
});

/* =========================
   CLAIM ITEM
========================= */
app.post('/claims', (req, res) => {
    const { item_id, claimed_by, notes } = req.body;

    const query = `
        INSERT INTO claims (item_id, claimed_by, notes)
        VALUES (?, ?, ?)
    `;

    db.query(query, [item_id, claimed_by, notes], (err, result) => {
        if (err) return res.status(500).send(err);
        res.send({ message: 'Claim requested', claim_id: result.insertId });
    });
});

/* =========================
   UPDATE CLAIM (ADMIN)
========================= */
app.put('/claims/:id', (req, res) => {
    const { status, reviewed_by } = req.body;
    const claim_id = req.params.id;

    const updateClaim = `
        UPDATE claims
        SET status = ?, reviewed_by = ?
        WHERE claim_id = ?
    `;

    db.query(updateClaim, [status, reviewed_by, claim_id], (err) => {
        if (err) return res.status(500).send(err);

        if (status === 'approved') {
            const updateItem = `
                UPDATE items
                SET status = 'claimed'
                WHERE item_id = (
                    SELECT item_id FROM claims WHERE claim_id = ?
                )
            `;

            db.query(updateItem, [claim_id]);
        }

        res.send({ message: 'Claim updated' });
    });
});

/* =========================
   GET CLAIMS
========================= */
app.get('/claims', (req, res) => {
    const query = `
        SELECT c.*, i.name AS item_name, u.name AS claimed_by_name
        FROM claims c
        JOIN items i ON c.item_id = i.item_id
        JOIN users u ON c.claimed_by = u.user_id
        ORDER BY c.claim_date DESC
    `;

    db.query(query, (err, result) => {
        if (err) return res.status(500).send(err);
        res.send(result);
    });
});

/* =========================
   START SERVER
========================= */
app.listen(3000, () => {
    console.log('Server running on http://localhost:3000');
});
