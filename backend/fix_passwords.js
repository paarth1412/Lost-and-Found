// fix_passwords.js
// ─────────────────────────────────────────────────────────────────────────────
//  ONE-TIME MIGRATION — run this ONCE after loading sample_data.sql.
//
//  WHY THIS IS NEEDED
//  ══════════════════
//  sample_data.sql seeds predefined users with the well-known PHP/Laravel test
//  hash:  $2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.
//
//  That hash was produced by PHP's password_hash(), NOT by this project's
//  bcryptjs library.  Even though both implement the same bcrypt algorithm,
//  bcryptjs v3.x cannot verify "password" against that externally-produced
//  hash.  The result:
//    • Predefined users get "Invalid email or password" on every login attempt.
//    • Forgot-password answer verification always fails → infinite step-2/step-3
//      loop because the same hash is used for security_answer.
//
//  This script re-hashes both fields using the exact bcryptjs version that is
//  installed in the project, guaranteeing compatibility with the login and
//  forgot-password routes in server.js.
//
//  HOW TO RUN
//  ══════════
//  From the backend directory (where server.js lives):
//
//    node fix_passwords.js
//
//  Expected output:
//    Generating fresh bcrypt hashes for "password"…
//    Updating 12 predefined users…
//    ✅  Updated 12 user(s).  All can now log in with password: "password"
//
//  SAFE TO RE-RUN — idempotent.  Running it again simply refreshes the hashes.
// ─────────────────────────────────────────────────────────────────────────────

'use strict'

const bcrypt = require('bcryptjs')
const db     = require('./db')

// Every predefined user in sample_data.sql — identified by e-mail so the
// update is precise and never touches self-registered accounts.
const PREDEFINED_EMAILS = [
  'pranav.jain@campus.edu',
  'paarth.jawaharani@campus.edu',
  'rohan.mehta@campus.edu',
  'ananya.singh@campus.edu',
  'vikram.nair@campus.edu',
  'sneha.iyer@campus.edu',
  'karan.malhotra@campus.edu',
  'deepika.reddy@campus.edu',
  'aditya.joshi@campus.edu',
  'meera.krishnan@campus.edu',
  'rahul.gupta@campus.edu',
  'pooja.desai@campus.edu'
]

// Plaintext for ALL predefined accounts (per sample_data.sql comments).
// security_answer is normalised to trim().toLowerCase() before hashing —
// exactly what /register and /forgot-password/reset do — so that the
// bcrypt.compare() calls in those routes always find a matching hash.
const PLAINTEXT_PASSWORD = 'password'
const PLAINTEXT_ANSWER   = 'password'     // same string, same normalisation

async function main () {
  console.log('Generating fresh bcrypt hashes for "password"…')

  // Hash cost = 10, matching what /register uses
  const passwordHash = await bcrypt.hash(PLAINTEXT_PASSWORD, 10)
  const answerHash   = await bcrypt.hash(
    PLAINTEXT_ANSWER.trim().toLowerCase(), 10
  )

  console.log(`Updating ${PREDEFINED_EMAILS.length} predefined users…`)

  const placeholders = PREDEFINED_EMAILS.map(() => '?').join(', ')
  const sql = `
    UPDATE users
       SET password        = ?,
           security_answer = ?
     WHERE email IN (${placeholders})`

  db.query(
    sql,
    [passwordHash, answerHash, ...PREDEFINED_EMAILS],
    (err, result) => {
      if (err) {
        console.error('❌  DB error:', err.message)
        db.end()
        process.exit(1)
      }

      console.log(
        `✅  Updated ${result.affectedRows} user(s).` +
        '  All can now log in with password: "password"'
      )
      console.log(
        '    Forgot-password answer verification will also work' +
        ' with answer: "password"'
      )

      db.end()
      process.exit(0)
    }
  )
}

main().catch(e => {
  console.error('Unexpected error:', e.message)
  process.exit(1)
})
