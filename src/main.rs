use clap::{Parser, Subcommand};

mod database;
mod handlers;

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
    Select,
}

fn main() {
    let conn = database::init_db();

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
            println!("gito - A simple way to manage local users\n");
            println!("Usage: gito [COMMAND]\n");
            println!("Available commands:");
            println!("  add     Add a new user");
            println!("  remove  Remove a user");
            println!("  list    List all users");
            println!("  select  Select a user and set git config globally");
        }
    }
}
