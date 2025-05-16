use directories::ProjectDirs;
use rusqlite::Connection;
use std::fs;
use std::path::PathBuf;

pub struct User {
    pub id: i32,
    pub name: String,
    pub email: String,
}

fn get_db_path() -> PathBuf {
    if let Some(proj_dirs) = ProjectDirs::from("com", "pedro3g", "gito") {
        let data_dir = proj_dirs.data_dir();
        fs::create_dir_all(data_dir).expect("Failed to create data directory");
        data_dir.join("gito.db")
    } else {
        // Fallback to current directory if ProjectDirs can't be determined
        // Or handle this error more gracefully depending on requirements
        eprintln!("Warning: Could not determine standard data directory. Using ./gito.db");
        PathBuf::from("gito.db")
    }
}

pub fn init_db() -> Connection {
    let db_path = get_db_path();
    println!("Database path: {:?}", db_path);
    let conn =
        Connection::open(&db_path).expect(&format!("Failed to open database at {:?}", db_path));

    // execute migrations
    const SCHEMA_SQL: &str = include_str!("db/schema.sql"); // Embed schema at compile time
    conn.execute_batch(SCHEMA_SQL).unwrap();

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
