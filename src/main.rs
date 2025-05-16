use clap::{Parser, Subcommand};

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
    check_requirements();
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
            println!(
                "{} {} - {}\n",
                env!("CARGO_PKG_NAME"),
                env!("CARGO_PKG_VERSION"),
                env!("CARGO_PKG_AUTHORS")
            );
            println!("{}", env!("CARGO_PKG_DESCRIPTION"));
            println!("Usage: {} [COMMAND]\n", env!("CARGO_PKG_NAME"));
            println!("Available commands:");
            println!("  add     Add a new user");
            println!("  remove  Remove a user");
            println!("  list    List all users");
            println!("  select  Select a user and set git config globally");
        }
    }
}

fn check_requirements() {
    if !std::process::Command::new("git")
        .arg("--version")
        .output()
        .is_ok()
    {
        println!("Git is not installed");
        std::process::exit(1);
    }
}
