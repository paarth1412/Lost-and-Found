// server.js — Express backend for Lost and Found System

const express = require('express')
const cors    = require('cors')
const bcrypt  = require('bcryptjs')
const db      = require('./db')

const app  = express()
const PORT = 3000

app.use(cors())
app.use(express.json())

const path = require('path')
app.use(express.static(path.join(__dirname, '../frontend')))

// ── USERS ─────────────────────────────────────────────────

// GET all users
app.get('/users', (req, res) => {
  db.query('SELECT user_id, name, email, phone, role FROM users ORDER BY name', (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json(results)
  })
})

// POST add a user (legacy, no password)
app.post('/users', (req, res) => {
  const { name, email, phone, role } = req.body
  const sql = 'INSERT INTO users (name, email, phone, role) VALUES (?, ?, ?, ?)'
  db.query(sql, [name, email, phone, role || 'user'], (err, result) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json({ message: 'User added', user_id: result.insertId })
  })
})

// POST register a new user (with password)
app.post('/register', async (req, res) => {
  const { name, email, password, phone, role } = req.body
  if (!name || !email || !password)
    return res.status(400).json({ error: 'Name, email and password are required' })

  try {
    const hash = await bcrypt.hash(password, 10)
    const sql = 'INSERT INTO users (name, email, password, phone, role) VALUES (?, ?, ?, ?, ?)'
    db.query(sql, [name, email, hash, phone || null, role || 'user'], (err, result) => {
      if (err) return res.status(500).json({ error: err.message })
      res.json({ message: 'User registered', user_id: result.insertId })
    })
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

// POST login
app.post('/login', async (req, res) => {
  const { email, password } = req.body
  if (!email || !password)
    return res.status(400).json({ error: 'Email and password are required' })

  db.query('SELECT * FROM users WHERE email = ?', [email], async (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    if (results.length === 0)
      return res.status(401).json({ error: 'Invalid email or password' })

    const user  = results[0]
    const match = await bcrypt.compare(password, user.password)
    if (!match)
      return res.status(401).json({ error: 'Invalid email or password' })

    res.json({
      message: 'Login successful',
      user_id: user.user_id,
      name:    user.name,
      role:    user.role
    })
  })
})

// ── ITEMS ─────────────────────────────────────────────────

// GET all items (with reporter name via JOIN)
app.get('/items', (req, res) => {
  const sql = `
    SELECT i.*, u.name AS reported_by_name
    FROM items i
    JOIN users u ON i.reported_by = u.user_id
    ORDER BY i.created_at DESC`
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json(results)
  })
})

// GET items filtered by status
app.get('/items/status/:status', (req, res) => {
  const sql = `
    SELECT i.*, u.name AS reported_by_name
    FROM items i
    JOIN users u ON i.reported_by = u.user_id
    WHERE i.status = ?`
  db.query(sql, [req.params.status], (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json(results)
  })
})

// GET single item
app.get('/items/:id', (req, res) => {
  const sql = `
    SELECT i.*, u.name AS reported_by_name
    FROM items i
    JOIN users u ON i.reported_by = u.user_id
    WHERE i.item_id = ?`
  db.query(sql, [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    if (results.length === 0) return res.status(404).json({ error: 'Item not found' })
    res.json(results[0])
  })
})

// POST add item
app.post('/items', (req, res) => {
  const { name, description, category, status, reported_by } = req.body
  const sql = 'INSERT INTO items (name, description, category, status, reported_by) VALUES (?, ?, ?, ?, ?)'
  db.query(sql, [name, description, category, status || 'lost', reported_by], (err, result) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json({ message: 'Item added', item_id: result.insertId })
  })
})

// PATCH update item status
app.patch('/items/:id/status', (req, res) => {
  const { status } = req.body
  db.query('UPDATE items SET status = ? WHERE item_id = ?', [status, req.params.id], (err) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json({ message: 'Status updated' })
  })
})

// ── LOST REPORTS ──────────────────────────────────────────

// GET all lost reports
app.get('/lost-reports', (req, res) => {
  const sql = `
    SELECT lr.*, i.name AS item_name, u.name AS user_name
    FROM lost_reports lr
    JOIN items i ON lr.item_id = i.item_id
    JOIN users u ON lr.user_id = u.user_id
    ORDER BY lr.lost_date DESC`
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json(results)
  })
})

// POST file a lost report
app.post('/lost-reports', (req, res) => {
  const { item_id, user_id, lost_location, lost_date } = req.body
  const sql = 'INSERT INTO lost_reports (item_id, user_id, lost_location, lost_date) VALUES (?, ?, ?, ?)'
  db.query(sql, [item_id, user_id, lost_location, lost_date], (err, result) => {
    if (err) return res.status(500).json({ error: err.message })
    db.query('UPDATE items SET status = "lost" WHERE item_id = ?', [item_id])
    res.json({ message: 'Lost report filed', lost_id: result.insertId })
  })
})

// ── FOUND REPORTS ─────────────────────────────────────────

// GET all found reports
app.get('/found-reports', (req, res) => {
  const sql = `
    SELECT fr.*, i.name AS item_name, u.name AS user_name
    FROM found_reports fr
    JOIN items i ON fr.item_id = i.item_id
    JOIN users u ON fr.user_id = u.user_id
    ORDER BY fr.found_date DESC`
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json(results)
  })
})

// POST file a found report
app.post('/found-reports', (req, res) => {
  const { item_id, user_id, found_location, found_date } = req.body
  const sql = 'INSERT INTO found_reports (item_id, user_id, found_location, found_date) VALUES (?, ?, ?, ?)'
  db.query(sql, [item_id, user_id, found_location, found_date], (err, result) => {
    if (err) return res.status(500).json({ error: err.message })
    db.query('UPDATE items SET status = "found" WHERE item_id = ?', [item_id])
    res.json({ message: 'Found report filed', found_id: result.insertId })
  })
})

// ── CLAIMS ────────────────────────────────────────────────

// GET all claims
app.get('/claims', (req, res) => {
  const sql = `
    SELECT c.*, i.name AS item_name,
           u.name  AS claimed_by_name,
           r.name  AS reviewed_by_name
    FROM claims c
    JOIN  items i ON c.item_id    = i.item_id
    JOIN  users u ON c.claimed_by = u.user_id
    LEFT JOIN users r ON c.reviewed_by = r.user_id
    ORDER BY c.claim_date DESC`
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json(results)
  })
})

// GET claims filtered by status
app.get('/claims/status/:status', (req, res) => {
  const sql = `
    SELECT c.*, i.name AS item_name, u.name AS claimed_by_name
    FROM claims c
    JOIN items i ON c.item_id    = i.item_id
    JOIN users u ON c.claimed_by = u.user_id
    WHERE c.status = ?`
  db.query(sql, [req.params.status], (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json(results)
  })
})

// POST submit a claim
app.post('/claims', (req, res) => {
  const { item_id, claimed_by } = req.body
  db.query(
    'INSERT INTO claims (item_id, claimed_by) VALUES (?, ?)',
    [item_id, claimed_by],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message })
      db.query('UPDATE items SET status = "claimed" WHERE item_id = ?', [item_id])
      res.json({ message: 'Claim submitted', claim_id: result.insertId })
    }
  )
})

// PATCH approve or reject a claim
app.patch('/claims/:id', (req, res) => {
  const { status, notes, reviewed_by } = req.body
  const sql = 'UPDATE claims SET status = ?, notes = ?, reviewed_by = ? WHERE claim_id = ?'
  db.query(sql, [status, notes, reviewed_by, req.params.id], (err) => {
    if (err) return res.status(500).json({ error: err.message })
    if (status === 'rejected') {
      db.query(
        'UPDATE items SET status = "found" WHERE item_id = (SELECT item_id FROM claims WHERE claim_id = ?)',
        [req.params.id]
      )
    }
    res.json({ message: `Claim ${status}` })
  })
})

// ── Start server ──────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`)
})
