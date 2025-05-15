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
