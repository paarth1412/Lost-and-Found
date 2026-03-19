-- =========================================
-- Lost and Found Management System Schema
-- =========================================

CREATE DATABASE IF NOT EXISTS lost_and_found;
USE lost_and_found;

-- ========== USERS ==========
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name    VARCHAR(150) NOT NULL,
    email   VARCHAR(100) NOT NULL,
    phone   VARCHAR(20),
    role    ENUM('admin', 'user') NOT NULL DEFAULT 'user'
);

-- ========== ITEMS ==========
CREATE TABLE items (
    item_id     INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(150) NOT NULL,
    description VARCHAR(255),
    category    VARCHAR(80),
    status      ENUM('lost','found','claimed') NOT NULL DEFAULT 'lost',
    reported_by INT NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_item_user
        FOREIGN KEY (reported_by) REFERENCES users(user_id)
);

-- ========== LOST REPORTS ==========
CREATE TABLE lost_reports (
    lost_id       INT AUTO_INCREMENT PRIMARY KEY,
    item_id       INT NOT NULL,
    user_id       INT NOT NULL,
    lost_location VARCHAR(150),
    lost_date     DATE NOT NULL,
    CONSTRAINT fk_lost_item
        FOREIGN KEY (item_id) REFERENCES items(item_id),
    CONSTRAINT fk_lost_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ========== FOUND REPORTS ==========
CREATE TABLE found_reports (
    found_id       INT AUTO_INCREMENT PRIMARY KEY,
    item_id        INT NOT NULL,
    user_id        INT NOT NULL,
    found_location VARCHAR(150),
    found_date     DATE NOT NULL,
    CONSTRAINT fk_found_item
        FOREIGN KEY (item_id) REFERENCES items(item_id),
    CONSTRAINT fk_found_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ========== CLAIMS ==========
CREATE TABLE claims (
    claim_id    INT AUTO_INCREMENT PRIMARY KEY,
    item_id     INT NOT NULL,
    claimed_by  INT NOT NULL,
    status      ENUM('requested','approved','rejected') NOT NULL DEFAULT 'requested',
    notes       VARCHAR(255),
    reviewed_by INT,
    claim_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_claim_item
        FOREIGN KEY (item_id) REFERENCES items(item_id),
    CONSTRAINT fk_claim_user
        FOREIGN KEY (claimed_by) REFERENCES users(user_id),
    CONSTRAINT fk_claim_reviewer
        FOREIGN KEY (reviewed_by) REFERENCES users(user_id)
);

-- ========== INDEXES ==========
CREATE INDEX idx_items_reported_by   ON items(reported_by);
CREATE INDEX idx_lost_item_id        ON lost_reports(item_id);
CREATE INDEX idx_found_item_id       ON found_reports(item_id);
CREATE INDEX idx_claim_item_id       ON claims(item_id);
CREATE INDEX idx_claim_claimed_by    ON claims(claimed_by);
