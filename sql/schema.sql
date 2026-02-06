-- database schema
CREATE DATABASE IF NOT EXISTS `lost_and_found`
  DEFAULT CHARACTER SET = utf8mb4
  DEFAULT COLLATE = utf8mb4_unicode_ci;
USE `lost_and_found`;

SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS claims;
DROP TABLE IF EXISTS found_reports;
DROP TABLE IF EXISTS lost_reports;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;


CREATE TABLE users (
                       user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                       name VARCHAR(100) NOT NULL,
                       email VARCHAR(150) NOT NULL UNIQUE,
                       phone VARCHAR(30),
                       password_hash VARCHAR(255) NOT NULL,
                       role ENUM('user','admin') NOT NULL DEFAULT 'user',
                       created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;


CREATE INDEX idx_users_role ON users(role);


CREATE TABLE items (
                       item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                       title VARCHAR(255) NOT NULL,
                       description TEXT,
                       category VARCHAR(100),
                       image_url VARCHAR(512),
                       location VARCHAR(255),
                       status ENUM('lost','found','claimed','returned') NOT NULL DEFAULT 'lost',
                       reported_by INT UNSIGNED NULL,
                       reported_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       metadata TEXT,
                       created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                       CONSTRAINT fk_items_reported_by FOREIGN KEY (reported_by)
                           REFERENCES users(user_id)
                           ON DELETE SET NULL
                           ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;


CREATE INDEX idx_items_title ON items(title(150));
CREATE INDEX idx_items_category ON items(category);
CREATE INDEX idx_items_status ON items(status);
CREATE INDEX idx_items_reported_at ON items(reported_at);


CREATE TABLE lost_reports (
                              lost_report_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                              item_id INT UNSIGNED NOT NULL,
                              reporter_id INT UNSIGNED NULL,
                              location VARCHAR(255),
                              report_date DATE,
                              contact_info VARCHAR(255),
                              notes TEXT,
                              created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                              CONSTRAINT fk_lostreports_item FOREIGN KEY (item_id)
                                  REFERENCES items(item_id)
                                  ON DELETE CASCADE
                                  ON UPDATE CASCADE,
                              CONSTRAINT fk_lostreports_reporter FOREIGN KEY (reporter_id)
                                  REFERENCES users(user_id)
                                  ON DELETE SET NULL
                                  ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE INDEX idx_lostreports_location ON lost_reports(location);
CREATE INDEX idx_lostreports_report_date ON lost_reports(report_date);


CREATE TABLE found_reports (
                               found_report_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                               item_id INT UNSIGNED NOT NULL,
                               found_by INT UNSIGNED NULL,
                               location VARCHAR(255),
                               report_date DATE,
                               contact_info VARCHAR(255),
                               notes TEXT,
                               created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               CONSTRAINT fk_foundreports_item FOREIGN KEY (item_id)
                                   REFERENCES items(item_id)
                                   ON DELETE CASCADE
                                   ON UPDATE CASCADE,
                               CONSTRAINT fk_foundreports_found_by FOREIGN KEY (found_by)
                                   REFERENCES users(user_id)
                                   ON DELETE SET NULL
                                   ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE INDEX idx_foundreports_location ON found_reports(location);
CREATE INDEX idx_foundreports_report_date ON found_reports(report_date);


CREATE TABLE claims (
                        claim_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                        item_id INT UNSIGNED NOT NULL,
                        claimant_id INT UNSIGNED NOT NULL,
                        status ENUM('requested','approved','rejected','cancelled') NOT NULL DEFAULT 'requested',
                        requested_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        resolved_at TIMESTAMP NULL DEFAULT NULL,
                        resolved_by INT UNSIGNED NULL,
                        notes TEXT,
                        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        CONSTRAINT fk_claims_item FOREIGN KEY (item_id)
                            REFERENCES items(item_id)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE,
                        CONSTRAINT fk_claims_claimant FOREIGN KEY (claimant_id)
                            REFERENCES users(user_id)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE,
                        CONSTRAINT fk_claims_resolved_by FOREIGN KEY (resolved_by)
                            REFERENCES users(user_id)
                            ON DELETE SET NULL
                            ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE INDEX idx_claims_status ON claims(status);
CREATE INDEX idx_claims_item_status ON claims(item_id, status);


CREATE TABLE audit_log (
                           audit_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                           entity VARCHAR(64) NOT NULL,
                           entity_id INT UNSIGNED,
                           action VARCHAR(80) NOT NULL,
                           performed_by INT UNSIGNED NULL,
                           details TEXT,
                           created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           CONSTRAINT fk_auditlog_performed_by FOREIGN KEY (performed_by)
                               REFERENCES users(user_id)
                               ON DELETE SET NULL
                               ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE INDEX idx_auditlog_entity ON audit_log(entity, entity_id);


DELIMITER $$

CREATE TRIGGER trg_claims_after_insert
    AFTER INSERT ON claims
    FOR EACH ROW
BEGIN
    INSERT INTO audit_log(entity, entity_id, action, performed_by, details)
    VALUES('claim', NEW.claim_id, 'claim_requested', NEW.claimant_id,
           CONCAT('item_id=', NEW.item_id, '; claimant_id=', NEW.claimant_id));
    END$$


    CREATE TRIGGER trg_claims_after_update
        AFTER UPDATE ON claims
        FOR EACH ROW
    BEGIN

        IF OLD.status <> NEW.status THEN
    INSERT INTO audit_log(entity, entity_id, action, performed_by, details)
    VALUES('claim', NEW.claim_id, CONCAT('claim_status_', OLD.status, '_to_', NEW.status),
           NEW.resolved_by,
           CONCAT('item_id=', NEW.item_id, '; claimant_id=', NEW.claimant_id, '; resolved_by=', NEW.resolved_by));
    END IF;


    IF NEW.status = 'approved' THEN
    UPDATE items
    SET status = 'claimed',
        updated_at = CURRENT_TIMESTAMP
    WHERE item_id = NEW.item_id;
END IF;


END$$

DELIMITER ;

SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
