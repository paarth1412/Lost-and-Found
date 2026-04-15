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

// ── Validation helpers ────────────────────────────────────

// Phone must be 10 digits 
function isValidPhone(phone) {
  return /^\d{10}$/.test(phone)
}

// ── USERS ─────────────────────────────────────────────────

// GET all users (used only for Claims "Claimed By" dropdown)
app.get('/users', (req, res) => {
  db.query(
    'SELECT user_id, name, email, phone, role FROM users ORDER BY name',
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message })
      res.json(results)
    }
  )
})

// POST register a new user
// Role is ALWAYS forced to 'user'.
app.post('/register', async (req, res) => {
  const { name, email, password, phone, security_question, security_answer } = req.body

  if (!name || !email || !password)
    return res.status(400).json({ error: 'Name, email and password are required' })

  if (password.length < 6)
    return res.status(400).json({ error: 'Password must be at least 6 characters long' })

  if (phone && !isValidPhone(phone))
    return res.status(400).json({ error: 'Phone must be exactly 10 digits' })

  if (!security_question || !security_question.trim())
    return res.status(400).json({ error: 'Security question is required' })

  if (!security_answer || !security_answer.trim())
    return res.status(400).json({ error: 'Security answer is required' })

  try {
    const hash       = await bcrypt.hash(password, 10)
    const answerHash = await bcrypt.hash(security_answer.trim().toLowerCase(), 10)

    const sql = `INSERT INTO users
                   (name, email, password, phone, role, security_question, security_answer)
                 VALUES (?, ?, ?, ?, ?, ?, ?)`
    // role is HARDCODED to 'user'
    db.query(sql, [name, email, hash, phone || null, 'user',
                   security_question.trim(), answerHash], (err, result) => {
      if (err) {
        if (err.code === 'ER_DUP_ENTRY')
          return res.status(409).json({ error: 'An account with this email already exists' })
        return res.status(500).json({ error: err.message })
      }
      res.json({ message: 'User registered', user_id: result.insertId })
    })
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

app.post('/login', async (req, res) => {
  const { email, password } = req.body
  if (!email || !password)
    return res.status(400).json({ error: 'Email and password are required' })

  db.query('SELECT * FROM users WHERE email = ?', [email], async (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    if (results.length === 0)
      return res.status(401).json({ error: 'Invalid email or password' })

    try {
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
    } catch (e) {
      return res.status(500).json({
        error: 'Authentication error — stored hash may be incompatible. ' +
               'Run: node fix_passwords.js'
      })
    }
  })
})

// ── ITEMS ─────────────────────────────────────────────────

// GET all items
app.get('/items', (req, res) => {
  const sql = `
    SELECT item_id, name, description, category, status,
           reporter_name, reporter_phone, created_at
    FROM   items
    ORDER  BY created_at DESC`
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json(results)
  })
})

// GET items filtered by status
app.get('/items/status/:status', (req, res) => {
  const allowed = ['lost', 'found', 'claimed']
  if (!allowed.includes(req.params.status))
    return res.status(400).json({ error: 'Invalid status value' })

  const sql = `
    SELECT item_id, name, description, category, status,
           reporter_name, reporter_phone, created_at
    FROM   items
    WHERE  status = ?
    ORDER  BY created_at DESC`
  db.query(sql, [req.params.status], (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json(results)
  })
})

// GET single item by ID
app.get('/items/:id', (req, res) => {
  const sql = `
    SELECT item_id, name, description, category, status,
           reporter_name, reporter_phone, created_at
    FROM   items
    WHERE  item_id = ?`
  db.query(sql, [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    if (results.length === 0) return res.status(404).json({ error: 'Item not found' })
    res.json(results[0])
  })
})

// POST add item
// Accepts: name, description, category, status, reporter_name, reporter_phone
app.post('/items', (req, res) => {
  const { name, description, category, status, reporter_name, reporter_phone } = req.body

  if (!name || !reporter_name)
    return res.status(400).json({ error: 'Item name and reporter name are required' })

  if (reporter_phone && !isValidPhone(reporter_phone))
    return res.status(400).json({ error: 'Reporter phone must be exactly 10 digits' })

  const sql = `
    INSERT INTO items (name, description, category, status, reporter_name, reporter_phone)
    VALUES (?, ?, ?, ?, ?, ?)`
  db.query(
    sql,
    [name, description || null, category || null, status || 'lost', reporter_name, reporter_phone || null],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message })
      res.json({ message: 'Item added', item_id: result.insertId })
    }
  )
})

// PATCH update item status
app.patch('/items/:id/status', (req, res) => {
  const { status } = req.body
  const allowed = ['lost', 'found', 'claimed']
  if (!allowed.includes(status))
    return res.status(400).json({ error: 'Invalid status value' })

  db.query('UPDATE items SET status = ? WHERE item_id = ?', [status, req.params.id], (err) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json({ message: 'Status updated' })
  })
})

// ── LOST REPORTS ──────────────────────────────────────────

// GET all lost reports
app.get('/lost-reports', (req, res) => {
  const sql = `
    SELECT lr.lost_id, lr.item_id, i.name AS item_name,
           lr.reporter_name, lr.reporter_phone,
           lr.lost_location, lr.lost_date
    FROM   lost_reports lr
    JOIN   items i ON lr.item_id = i.item_id
    ORDER  BY lr.lost_date DESC`
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json(results)
  })
})

// POST file a lost report
// Accepts: item_id, reporter_name, reporter_phone, lost_location, lost_date
app.post('/lost-reports', (req, res) => {
  const { item_id, reporter_name, reporter_phone, lost_location, lost_date } = req.body

  if (!item_id || !reporter_name || !lost_date)
    return res.status(400).json({ error: 'item_id, reporter_name and lost_date are required' })

  if (reporter_phone && !isValidPhone(reporter_phone))
    return res.status(400).json({ error: 'Reporter phone must be exactly 10 digits' })

  const sql = `
    INSERT INTO lost_reports (item_id, reporter_name, reporter_phone, lost_location, lost_date)
    VALUES (?, ?, ?, ?, ?)`
  db.query(
    sql,
    [item_id, reporter_name, reporter_phone || null, lost_location || null, lost_date],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message })
      // Ensure item status is 'lost'
      db.query('UPDATE items SET status = "lost" WHERE item_id = ?', [item_id])
      res.json({ message: 'Lost report filed', lost_id: result.insertId })
    }
  )
})

// ── FOUND REPORTS ─────────────────────────────────────────

// GET all found reports
app.get('/found-reports', (req, res) => {
  const sql = `
    SELECT fr.found_id, fr.item_id, i.name AS item_name,
           fr.reporter_name, fr.reporter_phone,
           fr.found_location, fr.found_date
    FROM   found_reports fr
    JOIN   items i ON fr.item_id = i.item_id
    ORDER  BY fr.found_date DESC`
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json(results)
  })
})

// POST file a found report
// Accepts: item_id, reporter_name, reporter_phone, found_location, found_date
app.post('/found-reports', (req, res) => {
  const { item_id, reporter_name, reporter_phone, found_location, found_date } = req.body

  if (!item_id || !reporter_name || !found_date)
    return res.status(400).json({ error: 'item_id, reporter_name and found_date are required' })

  if (reporter_phone && !isValidPhone(reporter_phone))
    return res.status(400).json({ error: 'Reporter phone must be exactly 10 digits' })

  const sql = `
    INSERT INTO found_reports (item_id, reporter_name, reporter_phone, found_location, found_date)
    VALUES (?, ?, ?, ?, ?)`
  db.query(
    sql,
    [item_id, reporter_name, reporter_phone || null, found_location || null, found_date],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message })
      // Ensure item status is 'found'
      db.query('UPDATE items SET status = "found" WHERE item_id = ?', [item_id])
      res.json({ message: 'Found report filed', found_id: result.insertId })
    }
  )
})

// ── CLAIMS ────────────────────────────────────────────────

// GET all claims
app.get('/claims', (req, res) => {
  const sql = `
    SELECT c.claim_id, c.item_id, c.status, c.notes, c.claim_date,
           i.name  AS item_name,
           u.name  AS claimed_by_name,
           r.name  AS reviewed_by_name,
           c.claimed_by, c.reviewed_by
    FROM   claims c
    JOIN   items i  ON c.item_id    = i.item_id
    JOIN   users u  ON c.claimed_by = u.user_id
    LEFT JOIN users r ON c.reviewed_by = r.user_id
    ORDER  BY c.claim_date DESC`
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json(results)
  })
})

// GET claims filtered by status
app.get('/claims/status/:status', (req, res) => {
  const allowed = ['requested', 'approved', 'rejected']
  if (!allowed.includes(req.params.status))
    return res.status(400).json({ error: 'Invalid status value' })

  const sql = `
    SELECT c.claim_id, c.item_id, c.status, c.notes, c.claim_date,
           i.name AS item_name,
           u.name AS claimed_by_name
    FROM   claims c
    JOIN   items i ON c.item_id    = i.item_id
    JOIN   users u ON c.claimed_by = u.user_id
    WHERE  c.status = ?
    ORDER  BY c.claim_date DESC`
  db.query(sql, [req.params.status], (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    res.json(results)
  })
})

// POST submit a claim
app.post('/claims', (req, res) => {
  const { item_id, claimed_by } = req.body

  if (!item_id || !claimed_by)
    return res.status(400).json({ error: 'item_id and claimed_by are required' })

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

// PATCH approve or reject a claim — ADMINS ONLY
app.patch('/claims/:id', (req, res) => {
  const { status, notes, reviewed_by } = req.body

  if (!reviewed_by)
    return res.status(400).json({ error: 'reviewed_by is required' })

  const allowedStatuses = ['approved', 'rejected']
  if (!allowedStatuses.includes(status))
    return res.status(400).json({ error: 'Status must be approved or rejected' })

  // Verify the reviewer is an admin — checked against DB, not the frontend
  db.query('SELECT role FROM users WHERE user_id = ?', [reviewed_by], (err, results) => {
    if (err) return res.status(500).json({ error: err.message })
    if (results.length === 0)
      return res.status(404).json({ error: 'Reviewer user not found' })
    if (results[0].role !== 'admin')
      return res.status(403).json({ error: 'Access denied. Admins only.' })

    const sql = 'UPDATE claims SET status = ?, notes = ?, reviewed_by = ? WHERE claim_id = ?'
    db.query(sql, [status, notes || null, reviewed_by, req.params.id], (err) => {
      if (err) return res.status(500).json({ error: err.message })

      // If rejected, revert item back to 'found' so it can be claimed again
      if (status === 'rejected') {
        db.query(
          'UPDATE items SET status = "found" WHERE item_id = (SELECT item_id FROM claims WHERE claim_id = ?)',
          [req.params.id]
        )
      }

      res.json({ message: `Claim ${status}` })
    })
  })
})

// ── FORGOT PASSWORD ───────────────────────────────────────
//Retrieves the security question associated with the provided email.
// Security considerations:
// • Only the question text is returned — sensitive data (e.g., answer hash) is never exposed.
// • Responds with a generic 404 message if:
//     - the email does not exist, OR
//     - no security question is set for the account.

app.get('/forgot-password/question', (req, res) => {
  const { email } = req.query
  if (!email)
    return res.status(400).json({ error: 'Email is required' })

  db.query(
    'SELECT security_question FROM users WHERE email = ?',
    [email],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message })

      if (results.length === 0 || !results[0].security_question)
        return res.status(404).json({ error: 'No account found with that email address' })

      res.json({ security_question: results[0].security_question })
    }
  )
})

// verify the security answer, then update the password.
// Body: { email, security_answer, new_password }
// The answer is compared case-insensitively against the stored bcrypt hash.
app.post('/forgot-password/reset', async (req, res) => {
  const { email, security_answer, new_password } = req.body

  if (!email || !security_answer || !new_password)
    return res.status(400).json({ error: 'Email, security answer and new password are required' })

  if (new_password.length < 6)
    return res.status(400).json({ error: 'Password must be at least 6 characters long' })

  db.query(
    'SELECT user_id, security_answer FROM users WHERE email = ?',
    [email],
    async (err, results) => {
      if (err) return res.status(500).json({ error: err.message })

      if (results.length === 0 || !results[0].security_answer)
        return res.status(404).json({ error: 'No account found with that email address' })

      try {
        const match = await bcrypt.compare(
          security_answer.trim().toLowerCase(),
          results[0].security_answer
        )
        if (!match)
          return res.status(401).json({ error: 'Incorrect security answer' })

        const hash = await bcrypt.hash(new_password, 10)
        db.query(
          'UPDATE users SET password = ? WHERE user_id = ?',
          [hash, results[0].user_id],
          (err2) => {
            if (err2) return res.status(500).json({ error: err2.message })
            res.json({ message: 'Password reset successfully' })
          }
        )
      } catch (e) {
        res.status(500).json({ error: e.message })
      }
    }
  )
})

// ── Start server ──────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`)
})
