-- ============================================================
--  Lost and Found Management System
--  schema.sql — Create all tables
-- ============================================================

CREATE DATABASE IF NOT EXISTS lost_and_found;
USE lost_and_found;

-- ─────────────────────────────────────────
-- TABLE: users
-- Stores registered accounts (students + admins).
-- 'role' defaults to 'user'; admin accounts are seeded only.
-- ─────────────────────────────────────────
CREATE TABLE users
(
    user_id           INT          AUTO_INCREMENT PRIMARY KEY,
    name              VARCHAR(150) NOT NULL,
    email             VARCHAR(100) NOT NULL UNIQUE,
    password          VARCHAR(255) NOT NULL DEFAULT '',
    phone             VARCHAR(20)  NULL,
    role              ENUM('admin','user') NOT NULL DEFAULT 'user',
    security_question VARCHAR(255) NULL,
    security_answer   VARCHAR(255) NULL     
);

-- ─────────────────────────────────────────
-- TABLE: items
-- Central entity for every lost/found/claimed item.
-- ─────────────────────────────────────────
CREATE TABLE items
(
    item_id        INT          AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(150) NOT NULL,
    description    VARCHAR(255) NULL,
    category       VARCHAR(80)  NULL,
    status         ENUM('lost','found','claimed') NOT NULL DEFAULT 'lost',
    reporter_name  VARCHAR(150) NOT NULL,
    reporter_phone VARCHAR(20)  NULL,
    created_at     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────
-- TABLE: lost_reports
-- One row per lost-item report filed.
-- reporter_name / reporter_phone: person who filed the report.
-- ─────────────────────────────────────────
CREATE TABLE lost_reports
(
    lost_id        INT          AUTO_INCREMENT PRIMARY KEY,
    item_id        INT          NOT NULL,
    reporter_name  VARCHAR(150) NOT NULL,
    reporter_phone VARCHAR(20)  NULL,
    lost_location  VARCHAR(150) NULL,
    lost_date      DATE         NOT NULL,
    CONSTRAINT fk_lost_item
        FOREIGN KEY (item_id) REFERENCES items (item_id)
);

-- ─────────────────────────────────────────
-- TABLE: found_reports
-- One row per found-item report filed.
-- ─────────────────────────────────────────
CREATE TABLE found_reports
(
    found_id       INT          AUTO_INCREMENT PRIMARY KEY,
    item_id        INT          NOT NULL,
    reporter_name  VARCHAR(150) NOT NULL,
    reporter_phone VARCHAR(20)  NULL,
    found_location VARCHAR(150) NULL,
    found_date     DATE         NOT NULL,
    CONSTRAINT fk_found_item
        FOREIGN KEY (item_id) REFERENCES items (item_id)
);

-- ─────────────────────────────────────────
-- TABLE: claims
-- Claims are always filed by a registered user (claimed_by FK).
-- Reviewed (approved / rejected) by an admin.
-- ─────────────────────────────────────────
CREATE TABLE claims
(
    claim_id    INT          AUTO_INCREMENT PRIMARY KEY,
    item_id     INT          NOT NULL,
    claimed_by  INT          NOT NULL,
    status      ENUM('requested','approved','rejected') NOT NULL DEFAULT 'requested',
    notes       VARCHAR(255) NULL,
    reviewed_by INT          NULL,
    claim_date  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_claim_item
        FOREIGN KEY (item_id)     REFERENCES items (item_id),
    CONSTRAINT fk_claim_user
        FOREIGN KEY (claimed_by)  REFERENCES users (user_id),
    CONSTRAINT fk_claim_reviewer
        FOREIGN KEY (reviewed_by) REFERENCES users (user_id)
);

-- ─────────────────────────────────────────
-- INDEXES
-- ─────────────────────────────────────────
CREATE INDEX idx_items_status      ON items        (status);
CREATE INDEX idx_lost_item_id      ON lost_reports (item_id);
CREATE INDEX idx_found_item_id     ON found_reports(item_id);
CREATE INDEX idx_claims_item_id    ON claims       (item_id);
CREATE INDEX idx_claims_claimed_by ON claims       (claimed_by);
