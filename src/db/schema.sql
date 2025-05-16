CREATE TABLE
    IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        selected INTEGER NOT NULL DEFAULT 0
    );

CREATE TRIGGER IF NOT EXISTS ensure_single_selected_user AFTER
UPDATE ON users FOR EACH ROW WHEN NEW.selected = 1 BEGIN
UPDATE users
SET
    selected = 0
WHERE
    id != NEW.id;

END;