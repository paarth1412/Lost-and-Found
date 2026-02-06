USE `lost_and_found`;
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE audit_log;
TRUNCATE TABLE claims;
TRUNCATE TABLE found_reports;
TRUNCATE TABLE lost_reports;
TRUNCATE TABLE items;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO users (name, email, phone, password_hash, role) VALUES
  ('Pranav Jain', 'pranav.jain@example.com', '+91-70000-00001', '$2b$10$placeholderpranav', 'user');
SET @pranav_id = LAST_INSERT_ID();

INSERT INTO users (name, email, phone, password_hash, role) VALUES
  ('Paarth Jawaharani', 'paarth.jawaharani@example.com', '+91-70000-00002', '$2b$10$placeholderpaarth', 'user');
SET @paarth_id = LAST_INSERT_ID();

INSERT INTO users (name, email, phone, password_hash, role) VALUES
  ('Lab Admin', 'admin@example.com', '+91-70000-00000', '$2b$10$placeholderadmin', 'admin');
SET @admin_id = LAST_INSERT_ID();

INSERT INTO items (title, description, category, image_url, location, status, reported_by, metadata) VALUES
  ('College ID Card', 'Red college ID card with Pranav Jain printed; small scratch on top-right corner', 'Identity', NULL, 'Near Library', 'lost', @pranav_id, '{"color":"red","mark":"scratch_top_right","identifier":"roll:CS2026-45"}');
SET @item1_id = LAST_INSERT_ID();

INSERT INTO lost_reports (item_id, reporter_id, location, report_date, contact_info, notes) VALUES
  (@item1_id, @pranav_id, 'Central Library - main steps', '2026-01-28', 'pranav.jain@example.com', 'Lost after evening class; has student ID and library tag');

INSERT INTO found_reports (item_id, found_by, location, report_date, contact_info, notes) VALUES
  (@item1_id, @paarth_id, 'Library Entrance Bench', '2026-01-29', 'paarth.jawaharani@example.com', 'Found on bench near entrance; kept at help desk');

INSERT INTO claims (item_id, claimant_id, status, requested_at, notes) VALUES
  (@item1_id, @pranav_id, 'requested', '2026-01-29 10:15:00', 'Claiming based on name printed on card and small scratch on top-right corner');
