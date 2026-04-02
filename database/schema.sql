-- ============================================================
--  Lost and Found Management System
--  schema.sql — Create all tables
-- ============================================================

CREATE DATABASE IF NOT EXISTS lost_and_found;
USE lost_and_found;

-- ─────────────────────────────────────────
-- TABLE: users
-- ─────────────────────────────────────────
CREATE TABLE users
(
    user_id   INT AUTO_INCREMENT PRIMARY KEY,
    name      VARCHAR(150) NOT NULL,
    email     VARCHAR(100) NOT NULL,
    password  VARCHAR(255) NOT NULL DEFAULT '',
    phone     VARCHAR(20)  NULL,
    role      ENUM('admin', 'user') NOT NULL DEFAULT 'user'
);

-- ─────────────────────────────────────────
-- TABLE: items
-- ─────────────────────────────────────────
CREATE TABLE items
(
    item_id     INT AUTO_INCREMENT
        PRIMARY KEY,
    name        VARCHAR(150)                   NOT NULL,
    description VARCHAR(255)                   NULL,
    category    VARCHAR(80)                    NULL,
    status      ENUM('lost','found','claimed') NOT NULL DEFAULT 'lost',
    reported_by INT                            NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_item_user
        FOREIGN KEY (reported_by) REFERENCES users (user_id)
);

-- ─────────────────────────────────────────
-- TABLE: lost_reports
-- ─────────────────────────────────────────
CREATE TABLE lost_reports
(
    lost_id       INT AUTO_INCREMENT
        PRIMARY KEY,
    item_id       INT          NOT NULL,
    user_id       INT          NOT NULL,
    lost_location VARCHAR(150) NULL,
    lost_date     DATE         NOT NULL,
    CONSTRAINT fk_lost_item
        FOREIGN KEY (item_id) REFERENCES items (item_id),
    CONSTRAINT fk_lost_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
);

-- ─────────────────────────────────────────
-- TABLE: found_reports
-- ─────────────────────────────────────────
CREATE TABLE found_reports
(
    found_id       INT AUTO_INCREMENT
        PRIMARY KEY,
    item_id        INT          NOT NULL,
    user_id        INT          NOT NULL,
    found_location VARCHAR(150) NULL,
    found_date     DATE         NOT NULL,
    CONSTRAINT fk_found_item
        FOREIGN KEY (item_id) REFERENCES items (item_id),
    CONSTRAINT fk_found_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
);

-- ─────────────────────────────────────────
-- TABLE: claims
-- ─────────────────────────────────────────
CREATE TABLE claims
(
    claim_id    INT AUTO_INCREMENT
        PRIMARY KEY,
    item_id     INT                                     NOT NULL,
    claimed_by  INT                                     NOT NULL,
    status      ENUM('requested','approved','rejected') NOT NULL DEFAULT 'requested',
    notes       VARCHAR(255)                            NULL,
    reviewed_by INT                                     NULL,
    claim_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_claim_item
        FOREIGN KEY (item_id) REFERENCES items (item_id),
    CONSTRAINT fk_claim_user
        FOREIGN KEY (claimed_by) REFERENCES users (user_id),
    CONSTRAINT fk_claim_reviewer
        FOREIGN KEY (reviewed_by) REFERENCES users (user_id)
);

-- ─────────────────────────────────────────
-- INDEXES
-- ─────────────────────────────────────────
CREATE INDEX reported_by    ON items (reported_by);
CREATE INDEX item_id_lost   ON lost_reports (item_id);
CREATE INDEX item_id_found  ON found_reports (item_id);
CREATE INDEX item_id_claim  ON claims (item_id);
CREATE INDEX claimed_by     ON claims (claimed_by);
