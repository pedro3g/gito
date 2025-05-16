use crate::database::{self, User};
use dialoguer::{Select, theme::ColorfulTheme};
use rusqlite::Connection;
use std::io::{self, Write};
use std::process::Command;

pub fn handle_add(conn: &Connection) {
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

    database::add_user(conn, &User { id: 0, name, email });
    println!("User added."); // Added a confirmation message
}

pub fn handle_remove(conn: &Connection) {
    let users = database::get_all_users(conn);
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
        database::remove_user(conn, selected_user.id);
        println!(
            "User '{}' (ID: {}) removed.",
            selected_user.name, selected_user.id
        );
    } else {
        println!("No user selected. Aborting removal.");
    }
}

pub fn handle_list(conn: &Connection) {
    let users = database::get_all_users(conn);
    if users.is_empty() {
        println!("No users to list.");
        return;
    }
    println!("Registered users:");
    let max_name_len = users.iter().map(|u| u.name.len()).max().unwrap_or(0);
    for user in users {
        println!(
            "{:<width$} - {}",
            user.name,
            user.email,
            width = max_name_len
        );
    }
}

pub fn handle_select(conn: &Connection) {
    let users = database::get_all_users(conn);
    if users.is_empty() {
        println!("No users to select.");
        return;
    }

    let max_name_len = users.iter().map(|u| u.name.len()).max().unwrap_or(0);

    let display_items: Vec<String> = users
        .iter()
        .map(|u| format!("{:<width$} - {}", u.name, u.email, width = max_name_len))
        .collect();

    let selection = Select::with_theme(&ColorfulTheme::default())
        .with_prompt("Select user")
        .items(&display_items)
        .default(0)
        .interact_opt()
        .unwrap();

    if let Some(index) = selection {
        let selected_user = &users[index];
        database::select_user(conn, selected_user.id); // Assuming this still makes sense, or if it needs adjustment for global config

        Command::new("git")
            .arg("config")
            .arg("--global")
            .arg("user.name")
            .arg(&selected_user.name)
            .output()
            .expect("Failed to set git user.name");

        Command::new("git")
            .arg("config")
            .arg("--global")
            .arg("user.email")
            .arg(&selected_user.email)
            .output()
            .expect("Failed to set git user.email");

        println!("Selected user for git config: {}", selected_user.name);
    } else {
        println!("No user selected. Aborting selection.");
    }
}
