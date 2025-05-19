use clap::{Parser, Subcommand};
use rusqlite::Connection;

mod database;
mod handlers;

#[derive(Parser)]
#[command(name = env!("CARGO_PKG_NAME"))]
#[command(version = env!("CARGO_PKG_VERSION"))]
#[command(about = env!("CARGO_PKG_DESCRIPTION"))]
#[command(author = env!("CARGO_PKG_AUTHORS"))]
struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    Add,
    Remove,
    List,
    Select,
}

fn main() {
    let conn = database::init_db();

    let active_user = check_requirements(&conn);

    let cli = Cli::parse();

    match cli.command {
        Some(Commands::Add) => {
            handlers::handle_add(&conn);
        }
        Some(Commands::Remove) => {
            handlers::handle_remove(&conn);
        }
        Some(Commands::List) => {
            handlers::handle_list(&conn);
        }
        Some(Commands::Select) => {
            handlers::handle_select(&conn);
        }
        None => {
            println!(
                "{} {} - {}",
                env!("CARGO_PKG_NAME"),
                env!("CARGO_PKG_VERSION"),
                env!("CARGO_PKG_AUTHORS")
            );
            println!("{}", env!("CARGO_PKG_DESCRIPTION"));
            println!("Usage: {} [COMMAND]", env!("CARGO_PKG_NAME"));

            println!(
                "\nActive user: {} <{}>",
                active_user.name, active_user.email
            );

            println!("\nAvailable commands:");
            println!("  add     Add a new user");
            println!("  remove  Remove a user");
            println!("  list    List all users");
            println!("  select  Select a user and set git config globally");
        }
    }
}

struct ActiveUser {
    name: String,
    email: String,
}

fn check_requirements(db: &Connection) -> ActiveUser {
    if !std::process::Command::new("git")
        .arg("--version")
        .output()
        .is_ok()
    {
        println!("Git is not installed");
        std::process::exit(1);
    }

    let name = std::process::Command::new("git")
        .arg("config")
        .arg("--global")
        .arg("user.name")
        .output()
        .unwrap();

    let email = std::process::Command::new("git")
        .arg("config")
        .arg("--global")
        .arg("user.email")
        .output()
        .unwrap();

    let name_str = String::from_utf8(name.stdout).unwrap().trim().to_string();
    let email_str = String::from_utf8(email.stdout).unwrap().trim().to_string();

    let active_user = ActiveUser {
        name: name_str.clone(),
        email: email_str.clone(),
    };

    if !database::email_in_use(db, &email_str) {
        let user = database::User {
            id: 0, // ID will be assigned by SQLite
            name: name_str,
            email: email_str,
        };

        database::add_user_as_selected(db, &user);
    }

    active_user
}
