-- ============================================================
--  Lost and Found Management System
--  sample_data.sql 
-- ============================================================

USE lost_and_found;

-- ─────────────────────────────────────────
-- USERS (passwords are all: Test@1234)
-- ─────────────────────────────────────────
INSERT INTO users (name, email, password, phone, role) VALUES
('Arjun Sharma',     'arjun.sharma@campus.edu',    '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543201', 'admin'),
('Priya Patel',      'priya.patel@campus.edu',     '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543202', 'admin'),
('Rohan Mehta',      'rohan.mehta@campus.edu',     '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543203', 'user'),
('Ananya Singh',     'ananya.singh@campus.edu',    '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543204', 'user'),
('Vikram Nair',      'vikram.nair@campus.edu',     '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543205', 'user'),
('Sneha Iyer',       'sneha.iyer@campus.edu',      '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543206', 'user'),
('Karan Malhotra',   'karan.malhotra@campus.edu',  '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543207', 'user'),
('Deepika Reddy',    'deepika.reddy@campus.edu',   '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543208', 'user'),
('Aditya Joshi',     'aditya.joshi@campus.edu',    '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543209', 'user'),
('Meera Krishnan',   'meera.krishnan@campus.edu',  '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543210', 'user'),
('Rahul Gupta',      'rahul.gupta@campus.edu',     '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543211', 'user'),
('Pooja Desai',      'pooja.desai@campus.edu',     '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '9876543212', 'user');

-- ─────────────────────────────────────────
-- ITEMS
-- ─────────────────────────────────────────
INSERT INTO items (name, description, category, status, reported_by, created_at) VALUES
-- Lost items
('Black Umbrella',          'Large black umbrella with wooden handle',         'Accessories',  'lost',    3,  '2025-01-10 09:15:00'),
('HP Laptop Charger',       '65W HP blue tip charger',                         'Electronics',  'lost',    4,  '2025-01-11 11:30:00'),
('Student ID Card',         'ID card of Ananya Singh, Roll No. 22CS045',       'Documents',    'lost',    4,  '2025-01-12 08:45:00'),
('Navy Blue Hoodie',        'Navy blue hoodie with college logo, size M',      'Clothing',     'lost',    5,  '2025-01-13 14:00:00'),
('Prescription Glasses',    'Black frame glasses in a brown case',             'Accessories',  'lost',    6,  '2025-01-15 10:20:00'),
('Water Bottle',            'Red Milton steel water bottle, 1L',               'Accessories',  'lost',    7,  '2025-01-16 13:10:00'),
('Physics Textbook',        'HC Verma Vol 2, has name written inside',         'Books',        'lost',    8,  '2025-01-17 09:00:00'),
('Airpods Case',            'White Airpods gen 2 case, no earbuds inside',     'Electronics',  'lost',    9,  '2025-01-18 16:45:00'),
('Brown Leather Wallet',    'Brown leather bifold wallet with some cash',      'Wallet',       'lost',    10, '2025-01-19 12:30:00'),
('Badminton Racket',        'Yonex racket with blue grip, in cover',           'Accessories',  'lost',    11, '2025-01-20 17:00:00'),

-- Found items (available to be claimed)
('Keys with Red Keychain',  'Set of 3 keys on a red keychain',                 'Keys',         'found',   3,  '2025-01-10 14:00:00'),
('Samsung Earphones',       'Black Samsung wired earphones in pouch',          'Electronics',  'found',   4,  '2025-01-11 09:30:00'),
('Geometry Box',            'Camlin geometry box, has stickers on it',         'Accessories',  'found',   5,  '2025-01-12 11:00:00'),
('Green Dupatta',           'Light green chiffon dupatta',                     'Clothing',     'found',   6,  '2025-01-13 15:30:00'),
('Tata Nexon Car Key',      'Car key with Tata logo and remote fob',           'Keys',         'found',   7,  '2025-01-14 08:00:00'),
('Notebook — Accounts',     'Blue notebook with Accounts notes, Sem 4',        'Books',        'found',   8,  '2025-01-15 13:45:00'),
('Power Bank',              'Ambrane 20000mAh white power bank',               'Electronics',  'found',   9,  '2025-01-16 10:15:00'),
('College ID Card',         'ID card of Rahul Gupta, Roll No. 22ME032',        'Documents',    'found',   10, '2025-01-17 14:00:00'),
('Black Backpack',          'Black Wildcraft backpack with laptop sleeve',     'Accessories',  'found',   11, '2025-01-18 09:00:00'),
('Casio Calculator',        'Casio fx-991ES Plus scientific calculator',       'Electronics',  'found',   12, '2025-01-19 11:30:00'),

-- Claimed items (fully resolved)
('iPhone Charger Cable',    'White lightning cable, slightly frayed at end',   'Electronics',  'claimed', 3,  '2025-01-05 10:00:00'),
('Stainless Steel Tiffin',  'Silver tiffin box with green rubber band',        'Accessories',  'claimed', 4,  '2025-01-06 12:00:00'),
('Library Book',            'The Alchemist — due date stamp visible inside',   'Books',        'claimed', 5,  '2025-01-07 09:30:00'),
('Purple Scarf',            'Woolen purple scarf with fringe ends',            'Clothing',     'claimed', 6,  '2025-01-08 14:00:00'),
('USB Flash Drive',         '32GB SanDisk USB, has a blue cap',                'Electronics',  'claimed', 7,  '2025-01-09 11:00:00');

-- ─────────────────────────────────────────
-- LOST REPORTS
-- ─────────────────────────────────────────
INSERT INTO lost_reports (item_id, user_id, lost_location, lost_date) VALUES
(1,  3,  'Main Canteen',             '2025-01-10'),
(2,  4,  'Computer Lab 3',           '2025-01-11'),
(3,  4,  'Library Reading Hall',     '2025-01-12'),
(4,  5,  'Sports Complex',           '2025-01-13'),
(5,  6,  'Department Corridor',      '2025-01-15'),
(6,  7,  'Classroom 204, Block B',   '2025-01-16'),
(7,  8,  'Library',                  '2025-01-17'),
(8,  9,  'Seminar Hall',             '2025-01-18'),
(9,  10, 'Parking Lot',              '2025-01-19'),
(10, 11, 'Badminton Court',          '2025-01-20'),
(21, 3,  'Classroom 101',            '2025-01-05'),
(22, 4,  'Hostel Mess',              '2025-01-06'),
(23, 5,  'Library',                  '2025-01-07'),
(24, 6,  'Girls Hostel Lobby',       '2025-01-08'),
(25, 7,  'Computer Lab 1',           '2025-01-09');

-- ─────────────────────────────────────────
-- FOUND REPORTS
-- ─────────────────────────────────────────
INSERT INTO found_reports (item_id, user_id, found_location, found_date) VALUES
(11, 5,  'Main Gate',                '2025-01-10'),
(12, 6,  'Canteen Bench',            '2025-01-11'),
(13, 7,  'Classroom 305, Block A',   '2025-01-12'),
(14, 8,  'Girls Hostel Common Room', '2025-01-13'),
(15, 9,  'Parking Lot B',            '2025-01-14'),
(16, 10, 'Classroom 102',            '2025-01-15'),
(17, 11, 'Library Entrance',         '2025-01-16'),
(18, 12, 'Boys Hostel Corridor',     '2025-01-17'),
(19, 3,  'Seminar Hall',             '2025-01-18'),
(20, 4,  'Lab 2, Block C',           '2025-01-19'),
(21, 6,  'Classroom 101',            '2025-01-05'),
(22, 7,  'Hostel Mess',              '2025-01-06'),
(23, 8,  'Library Return Desk',      '2025-01-07'),
(24, 9,  'Girls Hostel Lobby',       '2025-01-08'),
(25, 10, 'Computer Lab 1',           '2025-01-09');

-- ─────────────────────────────────────────
-- CLAIMS
-- ─────────────────────────────────────────
INSERT INTO claims (item_id, claimed_by, status, notes, reviewed_by, claim_date) VALUES
-- Approved claims (for claimed items)
(21, 8,  'approved', 'Owner verified via email receipt',          1, '2025-01-06 10:00:00'),
(22, 9,  'approved', 'Owner identified tiffin by rubber band colour', 1, '2025-01-07 11:00:00'),
(23, 10, 'approved', 'Library card matched borrower record',      2, '2025-01-08 09:30:00'),
(24, 11, 'approved', 'Owner described scarf accurately',          2, '2025-01-09 14:00:00'),
(25, 12, 'approved', 'Owner showed purchase invoice',             1, '2025-01-10 10:30:00'),

-- Pending claims (for found items — these drive the dashboard count)
(11, 4,  'requested', NULL, NULL, '2025-01-11 09:00:00'),
(12, 5,  'requested', NULL, NULL, '2025-01-12 10:00:00'),
(13, 6,  'requested', NULL, NULL, '2025-01-13 11:30:00'),
(15, 8,  'requested', NULL, NULL, '2025-01-15 08:45:00'),
(17, 3,  'requested', NULL, NULL, '2025-01-17 13:00:00'),
(19, 5,  'requested', NULL, NULL, '2025-01-19 10:00:00'),
(20, 6,  'requested', NULL, NULL, '2025-01-20 15:30:00'),

-- Rejected claims
(14, 3,  'rejected', 'Could not verify ownership',                1, '2025-01-14 12:00:00'),
(16, 4,  'rejected', 'Description did not match item',            2, '2025-01-16 09:00:00'),
(18, 7,  'rejected', 'Another person proved ownership first',     1, '2025-01-18 11:00:00');
