use clap::{Parser, Subcommand};

mod database;
mod handlers;

const NAME: &str = "gito";
const VERSION: &str = "0.1.0";
const AUTHORS: &str = "Pedro Henrique <opedro3g@gmail.com>";
const ABOUT: &str = "A simple way to manage local git users";

#[derive(Parser)]
#[command(name = NAME)]
#[command(version = VERSION)]
#[command(about = ABOUT)]
#[command(author = AUTHORS)]

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
            println!("{} {} - {}\n", NAME, VERSION, AUTHORS);
            println!("{}", ABOUT);
            println!("Usage: {} [COMMAND]\n", NAME);
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
