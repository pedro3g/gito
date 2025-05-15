use clap::{Parser, Subcommand};
use database::User;
use rusqlite::Connection;
use std::io::{self, Write};
mod database;

#[derive(Parser)]
#[command(name = "gito")]
#[command(version = "0.1.0")]
#[command(about = "A simple way to manage local users")]

struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    Add,
    Remove { name: String },
    List,
}

fn main() {
    let conn = database::init_db();

    let cli = Cli::parse();

    match cli.command {
        Some(Commands::Add) => {
            let mut name = String::new();
            let mut email = String::new();

            print!("Enter name: ");
            io::stdout().flush().unwrap();
            io::stdin()
                .read_line(&mut name)
                .expect("Failed to read name");
            let name = name.trim().to_string();

            print!("Enter email: ");
            io::stdout().flush().unwrap();
            io::stdin()
                .read_line(&mut email)
                .expect("Failed to read email");
            let email = email.trim().to_string();

            add_user(&conn, User { id: 0, name, email });
        }
        Some(Commands::Remove { name }) => {
            println!("Removing user: {}", name);
        }
        Some(Commands::List) => {
            list_users(&conn);
        }
        None => {}
    }

    let mut stmt = conn.prepare("SELECT * FROM users").unwrap();
    let users: Vec<User> = stmt
        .query_map([], |row| {
            Ok(User {
                id: row.get(0)?,
                name: row.get(1)?,
                email: row.get(2)?,
            })
        })
        .unwrap()
        .collect::<Result<Vec<User>, rusqlite::Error>>()
        .unwrap();

    println!("users length: {}", users.len());
}

fn list_users(db: &Connection) {
    let mut stmt = db.prepare("SELECT * FROM users").unwrap();
    let users: Vec<User> = stmt
        .query_map([], |row| {
            Ok(User {
                id: row.get(0)?,
                name: row.get(1)?,
                email: row.get(2)?,
            })
        })
        .unwrap()
        .collect::<Result<Vec<User>, rusqlite::Error>>()
        .unwrap();

    for user in users {
        println!("{}", user.name);
    }
}

fn add_user(db: &Connection, user: User) {
    let mut stmt = db
        .prepare("INSERT INTO users (name, email) VALUES (?, ?)")
        .unwrap();
    stmt.execute([user.name, user.email]).unwrap();
}
