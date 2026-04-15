-- ============================================================
--  Lost and Found Management System
--  sample_data.sql
-- ============================================================

USE lost_and_found;

-- ─────────────────────────────────────────
-- USERS
--
-- Plaintext password for ALL sample accounts: password
--
-- Plaintext security_answer for ALL sample accounts: password
--
-- Admins: Pranav Jain (user_id 1), Paarth Jawaharani (user_id 2)
-- Regular users: user_id 3–12
--
-- Role is always 'user' for self-registered accounts.
-- Admin accounts are inserted here only — the register API
-- enforces role = 'user' and cannot be overridden.
-- ─────────────────────────────────────────
INSERT INTO users (name, email, password, phone, role, security_question, security_answer) VALUES
-- Admins (seeded, not self-registered)
('Pranav Jain',       'pranav.jain@campus.edu',       '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876540001', 'admin', 'What is the name of your first school?',          '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.'),
('Paarth Jawaharani', 'paarth.jawaharani@campus.edu', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876540002', 'admin', 'What is the name of the street you grew up on?',  '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.'),
-- Regular users
('Rohan Mehta',       'rohan.mehta@campus.edu',       '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543203', 'user',  'What is your star sign?',                        '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.'),
('Ananya Singh',      'ananya.singh@campus.edu',      '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543204', 'user',  'What city were you born in?',                    '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.'),
('Vikram Nair',       'vikram.nair@campus.edu',       '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543205', 'user',  'What is your favourite sport or hobby?',          '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.'),
('Sneha Iyer',        'sneha.iyer@campus.edu',        '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543206', 'user',  'What is your favourite flower?',                 '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.'),
('Karan Malhotra',    'karan.malhotra@campus.edu',    '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543207', 'user',  'What breed is your favourite dog?',              '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.'),
('Deepika Reddy',     'deepika.reddy@campus.edu',     '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543208', 'user',  'What city did you grow up in?',                  '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.'),
('Aditya Joshi',      'aditya.joshi@campus.edu',      '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543209', 'user',  'What is your favourite sport?',                  '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.'),
('Meera Krishnan',    'meera.krishnan@campus.edu',    '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543210', 'user',  'What style of music do you enjoy most?',         '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.'),
('Rahul Gupta',       'rahul.gupta@campus.edu',       '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543211', 'user',  'Who is your favourite scientist?',               '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.'),
('Pooja Desai',       'pooja.desai@campus.edu',       '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543212', 'user',  'What is your favourite Indian art form?',        '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.');

-- ─────────────────────────────────────────
-- ITEMS
-- ─────────────────────────────────────────
INSERT INTO items (name, description, category, status, reporter_name, reporter_phone, created_at) VALUES
-- Lost items (reporters are the people who lost them)
('Black Umbrella',       'Large black umbrella with wooden handle',         'Accessories', 'lost',    'Rohan Mehta',    '9876543203', '2025-01-10 09:15:00'),
('HP Laptop Charger',    '65W HP blue tip charger',                         'Electronics', 'lost',    'Ananya Singh',   '9876543204', '2025-01-11 11:30:00'),
('Student ID Card',      'ID card of Ananya Singh, Roll No. 22CS045',       'Documents',   'lost',    'Ananya Singh',   '9876543204', '2025-01-12 08:45:00'),
('Navy Blue Hoodie',     'Navy blue hoodie with college logo, size M',      'Clothing',    'lost',    'Vikram Nair',    '9876543205', '2025-01-13 14:00:00'),
('Prescription Glasses', 'Black frame glasses in a brown case',             'Accessories', 'lost',    'Sneha Iyer',     '9876543206', '2025-01-15 10:20:00'),
('Water Bottle',         'Red Milton steel water bottle, 1L',               'Accessories', 'lost',    'Karan Malhotra', '9876543207', '2025-01-16 13:10:00'),
('Physics Textbook',     'HC Verma Vol 2, has name written inside',         'Books',       'lost',    'Deepika Reddy',  '9876543208', '2025-01-17 09:00:00'),
('Airpods Case',         'White Airpods gen 2 case, no earbuds inside',     'Electronics', 'lost',    'Aditya Joshi',   '9876543209', '2025-01-18 16:45:00'),
('Brown Leather Wallet', 'Brown leather bifold wallet with some cash',      'Wallet',      'lost',    'Meera Krishnan', '9876543210', '2025-01-19 12:30:00'),
('Badminton Racket',     'Yonex racket with blue grip, in cover',           'Accessories', 'lost',    'Rahul Gupta',    '9876543211', '2025-01-20 17:00:00'),

-- Found items (reporters are the people who found them)
('Keys with Red Keychain', 'Set of 3 keys on a red keychain',               'Keys',        'found',   'Vikram Nair',    '9876543205', '2025-01-10 14:00:00'),
('Samsung Earphones',      'Black Samsung wired earphones in pouch',        'Electronics', 'found',   'Sneha Iyer',     '9876543206', '2025-01-11 09:30:00'),
('Geometry Box',           'Camlin geometry box, has stickers on it',       'Accessories', 'found',   'Karan Malhotra', '9876543207', '2025-01-12 11:00:00'),
('Green Dupatta',          'Light green chiffon dupatta',                   'Clothing',    'found',   'Deepika Reddy',  '9876543208', '2025-01-13 15:30:00'),
('Tata Nexon Car Key',     'Car key with Tata logo and remote fob',         'Keys',        'found',   'Aditya Joshi',   '9876543209', '2025-01-14 08:00:00'),
('Notebook — Accounts',    'Blue notebook with Accounts notes, Sem 4',      'Books',       'found',   'Meera Krishnan', '9876543210', '2025-01-15 13:45:00'),
('Power Bank',             'Ambrane 20000mAh white power bank',             'Electronics', 'found',   'Rahul Gupta',    '9876543211', '2025-01-16 10:15:00'),
('College ID Card',        'ID card of Rahul Gupta, Roll No. 22ME032',      'Documents',   'found',   'Pooja Desai',    '9876543212', '2025-01-17 14:00:00'),
('Black Backpack',         'Black Wildcraft backpack with laptop sleeve',   'Accessories', 'found',   'Rohan Mehta',    '9876543203', '2025-01-18 09:00:00'),
('Casio Calculator',       'Casio fx-991ES Plus scientific calculator',     'Electronics', 'found',   'Ananya Singh',   '9876543204', '2025-01-19 11:30:00'),

-- Claimed items (fully resolved)
('iPhone Charger Cable',  'White lightning cable, slightly frayed at end',  'Electronics', 'claimed', 'Rohan Mehta',    '9876543203', '2025-01-05 10:00:00'),
('Stainless Steel Tiffin','Silver tiffin box with green rubber band',       'Accessories', 'claimed', 'Ananya Singh',   '9876543204', '2025-01-06 12:00:00'),
('Library Book',          'The Alchemist — due date stamp visible inside',  'Books',       'claimed', 'Vikram Nair',    '9876543205', '2025-01-07 09:30:00'),
('Purple Scarf',          'Woolen purple scarf with fringe ends',           'Clothing',    'claimed', 'Sneha Iyer',     '9876543206', '2025-01-08 14:00:00'),
('USB Flash Drive',       '32GB SanDisk USB, has a blue cap',               'Electronics', 'claimed', 'Karan Malhotra', '9876543207', '2025-01-09 11:00:00');

-- ─────────────────────────────────────────
-- LOST REPORTS
-- ─────────────────────────────────────────
INSERT INTO lost_reports (item_id, reporter_name, reporter_phone, lost_location, lost_date) VALUES
(1,  'Rohan Mehta',    '9876543203', 'Main Canteen',           '2025-01-10'),
(2,  'Ananya Singh',   '9876543204', 'Computer Lab 3',         '2025-01-11'),
(3,  'Ananya Singh',   '9876543204', 'Library Reading Hall',   '2025-01-12'),
(4,  'Vikram Nair',    '9876543205', 'Sports Complex',         '2025-01-13'),
(5,  'Sneha Iyer',     '9876543206', 'Department Corridor',    '2025-01-15'),
(6,  'Karan Malhotra', '9876543207', 'Classroom 204, Block B', '2025-01-16'),
(7,  'Deepika Reddy',  '9876543208', 'Library',                '2025-01-17'),
(8,  'Aditya Joshi',   '9876543209', 'Seminar Hall',           '2025-01-18'),
(9,  'Meera Krishnan', '9876543210', 'Parking Lot',            '2025-01-19'),
(10, 'Rahul Gupta',    '9876543211', 'Badminton Court',        '2025-01-20'),
(21, 'Rohan Mehta',    '9876543203', 'Classroom 101',          '2025-01-05'),
(22, 'Ananya Singh',   '9876543204', 'Hostel Mess',            '2025-01-06'),
(23, 'Vikram Nair',    '9876543205', 'Library',                '2025-01-07'),
(24, 'Sneha Iyer',     '9876543206', 'Girls Hostel Lobby',     '2025-01-08'),
(25, 'Karan Malhotra', '9876543207', 'Computer Lab 1',         '2025-01-09');

-- ─────────────────────────────────────────
-- FOUND REPORTS
-- ─────────────────────────────────────────
INSERT INTO found_reports (item_id, reporter_name, reporter_phone, found_location, found_date) VALUES
(11, 'Vikram Nair',    '9876543205', 'Main Gate',                '2025-01-10'),
(12, 'Sneha Iyer',     '9876543206', 'Canteen Bench',            '2025-01-11'),
(13, 'Karan Malhotra', '9876543207', 'Classroom 305, Block A',   '2025-01-12'),
(14, 'Deepika Reddy',  '9876543208', 'Girls Hostel Common Room', '2025-01-13'),
(15, 'Aditya Joshi',   '9876543209', 'Parking Lot B',            '2025-01-14'),
(16, 'Meera Krishnan', '9876543210', 'Classroom 102',            '2025-01-15'),
(17, 'Rahul Gupta',    '9876543211', 'Library Entrance',         '2025-01-16'),
(18, 'Pooja Desai',    '9876543212', 'Boys Hostel Corridor',     '2025-01-17'),
(19, 'Rohan Mehta',    '9876543203', 'Seminar Hall',             '2025-01-18'),
(20, 'Ananya Singh',   '9876543204', 'Lab 2, Block C',           '2025-01-19'),
(21, 'Sneha Iyer',     '9876543206', 'Classroom 101',            '2025-01-05'),
(22, 'Karan Malhotra', '9876543207', 'Hostel Mess',              '2025-01-06'),
(23, 'Deepika Reddy',  '9876543208', 'Library Return Desk',      '2025-01-07'),
(24, 'Aditya Joshi',   '9876543209', 'Girls Hostel Lobby',       '2025-01-08'),
(25, 'Meera Krishnan', '9876543210', 'Computer Lab 1',           '2025-01-09');

-- ─────────────────────────────────────────
-- CLAIMS
-- Admins are Pranav Jain (user_id 1) and Paarth Jawaharani (user_id 2).
-- ─────────────────────────────────────────
INSERT INTO claims (item_id, claimed_by, status, notes, reviewed_by, claim_date) VALUES
-- Approved claims (resolved items — item_id 21–25)
(21, 8,  'approved', 'Owner verified via email receipt',              1, '2025-01-06 10:00:00'),
(22, 9,  'approved', 'Owner identified tiffin by rubber band colour', 1, '2025-01-07 11:00:00'),
(23, 10, 'approved', 'Library card matched borrower record',          2, '2025-01-08 09:30:00'),
(24, 11, 'approved', 'Owner described scarf accurately',              2, '2025-01-09 14:00:00'),
(25, 12, 'approved', 'Owner showed purchase invoice',                 1, '2025-01-10 10:30:00'),

-- Pending claims (found items awaiting admin review)
(11, 4,  'requested', NULL, NULL, '2025-01-11 09:00:00'),
(12, 5,  'requested', NULL, NULL, '2025-01-12 10:00:00'),
(13, 6,  'requested', NULL, NULL, '2025-01-13 11:30:00'),
(15, 8,  'requested', NULL, NULL, '2025-01-15 08:45:00'),
(17, 3,  'requested', NULL, NULL, '2025-01-17 13:00:00'),
(19, 5,  'requested', NULL, NULL, '2025-01-19 10:00:00'),
(20, 6,  'requested', NULL, NULL, '2025-01-20 15:30:00'),

-- Rejected claims
(14, 3,  'rejected', 'Could not verify ownership',              1, '2025-01-14 12:00:00'),
(16, 4,  'rejected', 'Description did not match item',          2, '2025-01-16 09:00:00'),
(18, 7,  'rejected', 'Another person proved ownership first',   1, '2025-01-18 11:00:00');
