-- ============================================================
--  Lost and Found Management System
--  sample_data.sql — Insert sample records for testing
-- ============================================================

USE lost_and_found;

-- ========== USERS ==========
INSERT INTO users (name, email, phone, role) VALUES
('Admin User',   'admin@college.com',  '9000000001', 'admin'),
('Paarth J',     'paarth@college.com', '9000000002', 'user'),
('Pranav Jain',  'pranav@college.com', '9000000003', 'user'),
('Riya Shah',    'riya@college.com',   '9000000004', 'user'),
('Arjun Mehta',  'arjun@college.com',  '9000000005', 'user');

-- ========== ITEMS ==========
INSERT INTO items (name, description, category, status, reported_by) VALUES
('Black Umbrella',    'Small foldable black umbrella',   'Accessories', 'lost',    2),
('Student ID Card',   'ID card belonging to a student',  'Documents',   'claimed', 3),
('Blue Water Bottle', 'Steel bottle with blue cap',      'Other',       'lost',    4),
('Earphones',         'White wired earphones in a case', 'Electronics', 'found',   5),
('Leather Wallet',    'Brown wallet with some cash',     'Wallet',      'claimed', 2),
('Physics Textbook',  'Class 12 Physics NCERT book',     'Books',       'lost',    3),
('Keys',              'Set of 3 keys on a red keychain', 'Keys',        'found',   4);

-- ========== LOST REPORTS ==========
INSERT INTO lost_reports (item_id, user_id, lost_location, lost_date) VALUES
(1, 2, 'Main Gate',            '2025-03-01'),
(3, 4, 'Cafeteria',            '2025-03-05'),
(6, 3, 'Library Reading Room', '2025-03-10');

-- ========== FOUND REPORTS ==========
INSERT INTO found_reports (item_id, user_id, found_location, found_date) VALUES
(2, 3, 'Parking Lot',   '2025-03-02'),
(4, 5, 'Computer Lab',  '2025-03-06'),
(5, 4, 'Classroom 204', '2025-03-08'), 
(7, 4, 'Admin Office',  '2025-03-11');

-- ========== CLAIMS ==========
INSERT INTO claims (item_id, claimed_by, status, notes, reviewed_by) VALUES
(2, 3, 'approved',  'Student verified with duplicate ID', 1),
(4, 2, 'requested', NULL,                                 NULL),
(5, 3, 'approved',  'Owner identified wallet contents',   1),
(7, 5, 'rejected',  'Could not verify ownership',         1);
