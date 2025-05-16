use rusqlite::Connection;
use std::fs;

pub struct User {
    pub id: i32,
    pub name: String,
    pub email: String,
}

pub fn init_db() -> Connection {
    let conn = Connection::open("gito.db").unwrap();

    // execute migrations
    let schema = fs::read_to_string("src/db/schema.sql").unwrap();
    conn.execute_batch(&schema).unwrap();

    conn
}

pub fn get_all_users(db: &Connection) -> Vec<User> {
    let mut stmt = db.prepare("SELECT * FROM users").unwrap();
    stmt.query_map([], |row| {
        Ok(User {
            id: row.get(0)?,
            name: row.get(1)?,
            email: row.get(2)?,
        })
    })
    .unwrap()
    .collect::<Result<Vec<User>, rusqlite::Error>>()
    .unwrap()
}

pub fn add_user(db: &Connection, user: &User) {
    let mut stmt = db
        .prepare("INSERT INTO users (name, email) VALUES (?, ?)")
        .unwrap();
    stmt.execute([&user.name, &user.email]).unwrap();
}

pub fn remove_user(db: &Connection, id: i32) {
    let mut stmt = db.prepare("DELETE FROM users WHERE id = ?").unwrap();
    stmt.execute([id]).unwrap();
}

pub fn select_user(db: &Connection, id: i32) {
    let mut stmt = db
        .prepare("UPDATE users SET selected = 1 WHERE id = ?")
        .unwrap();
    stmt.execute([id]).unwrap();
}
