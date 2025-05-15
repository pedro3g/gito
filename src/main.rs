use clap::{Parser, Subcommand};
use database::User;
use dialoguer::{Select, theme::ColorfulTheme};
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
    Remove,
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
        Some(Commands::Remove) => {
            let users = get_all_users(&conn);
            if users.is_empty() {
                println!("No users to remove.");
                return;
            }

            let max_name_len = users.iter().map(|u| u.name.len()).max().unwrap_or(0);

            let display_items: Vec<String> = users
                .iter()
                .map(|u| format!("{:<width$} - {}", u.name, u.email, width = max_name_len))
                .collect();

            let selection = Select::with_theme(&ColorfulTheme::default())
                .with_prompt("Select user to remove")
                .items(&display_items)
                .default(0)
                .interact_opt()
                .unwrap();

            if let Some(index) = selection {
                let selected_user = &users[index];
                remove_user(&conn, selected_user.id);
                println!(
                    "User '{}' (ID: {}) removed.",
                    selected_user.name, selected_user.id
                );
            } else {
                println!("No user selected. Aborting removal.");
            }
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

fn get_all_users(db: &Connection) -> Vec<User> {
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

fn list_users(db: &Connection) {
    let users = get_all_users(db);
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

fn remove_user(db: &Connection, id: i32) {
    let mut stmt = db.prepare("DELETE FROM users WHERE id = ?").unwrap();
    stmt.execute([id]).unwrap();
}
