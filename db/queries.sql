USE lost_and_found;

-- Items with reporter name
SELECT i.item_id, i.name, i.status, u.name AS reported_by
FROM items i
JOIN users u ON i.reported_by = u.user_id;

-- Items reported by a specific user
SELECT name, status
FROM items
WHERE reported_by = 2;

-- Items not yet claimed
SELECT name, status
FROM items
WHERE status IN ('lost', 'found');

-- Lost items with details
SELECT i.name, lr.lost_location, lr.lost_date, u.name AS reported_by
FROM items i
JOIN lost_reports lr ON i.item_id = lr.item_id
JOIN users u ON lr.user_id = u.user_id;

-- Found items with details
SELECT i.name, fr.found_location, fr.found_date, u.name AS found_by
FROM items i
JOIN found_reports fr ON i.item_id = fr.item_id
JOIN users u ON fr.user_id = u.user_id;

-- All claims with item and user
SELECT c.claim_id, i.name AS item_name, u.name AS claimed_by, c.status
FROM claims c
JOIN items i ON c.item_id = i.item_id
JOIN users u ON c.claimed_by = u.user_id;

-- Approved claims with reviewer
SELECT i.name AS item_name, u1.name AS claimed_by, u2.name AS reviewed_by
FROM claims c
JOIN items i ON c.item_id = i.item_id
JOIN users u1 ON c.claimed_by = u1.user_id
JOIN users u2 ON c.reviewed_by = u2.user_id
WHERE c.status = 'approved';

-- Pending claims
SELECT c.claim_id, i.name AS item_name, u.name AS claimed_by
FROM claims c
JOIN items i ON c.item_id = i.item_id
JOIN users u ON c.claimed_by = u.user_id
WHERE c.status = 'requested';

-- Items with no claims
SELECT i.name
FROM items i
LEFT JOIN claims c ON i.item_id = c.item_id
WHERE c.claim_id IS NULL;

-- Count items by status
SELECT status, COUNT(*) AS total_items
FROM items
GROUP BY status;

-- Number of claims per item
SELECT i.name, COUNT(c.claim_id) AS total_claims
FROM items i
LEFT JOIN claims c ON i.item_id = c.item_id
GROUP BY i.item_id, i.name;

-- Sync item status after approval
UPDATE items
SET status = 'claimed'
WHERE item_id IN (
    SELECT item_id FROM claims WHERE status = 'approved'
);

-- Remove rejected claims
DELETE FROM claims
WHERE status = 'rejected';
