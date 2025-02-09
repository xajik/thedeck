use chrono::prelude::*;
use std::fs;
use std::io::{self, Write};
use std::path::Path;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    loop {
        println!("\n###\n");
        println!("Select an option:");
        println!("1. Create new view model");
        println!("2. Create new game");
        println!("0. Exit");
        println!("\n");

        let mut option = String::new();
        io::stdin().read_line(&mut option)?;

        match option.trim() {
            "1" => {
                let folder = read_user_input(
                    "Enter folder to create (lowercase letter, with underscore, example mine/): ",
                )?;
                let file_prefix = read_user_input(
                    "Enter file prefix (lowercase letter, with underscore, example mine_widget): ",
                )?;
                let class_prefix =
                    read_user_input("Enter class prefix (camelcase, letter only, example Mine): ")?;

                create_new_view_model(&folder, &file_prefix, &class_prefix)?;
                println!("View model created successfully!");
            }
            "2" => {
                let pascal_case =
                    read_user_input("Enter game name pascal case (exampel: Dixit): ")?;
                let camel_case = read_user_input("Enter game name camel case (exampel: dixit): ")?;
                let snake_case = read_user_input("Enter game name snake case (example dixit): ")?;
                let patch = create_new_game(&pascal_case, &camel_case, &snake_case)?;
                println!("Game created successfully!");
                println!("Apply via: git am -3 < {}", patch);
            }
            "0" => break,
            _ => return Err("Invalid option. Please select a valid option.".into()),
        }
    }

    Ok(())
}

// Utils

fn format_header() -> String {
    let year_today = Utc::now().format("%Y").to_string();
    let date_today = Utc::now().format("%Y-%m-%d").to_string();
    return include_str!("../templates/header")
        .replace("{date_today}", date_today.as_str())
        .replace("{year_today}", year_today.as_str());
}

fn read_user_input(prompt: &str) -> Result<String, io::Error> {
    print!("{}", prompt);
    io::stdout().flush()?;

    let mut input = String::new();
    io::stdin().read_line(&mut input)?;

    Ok(input.trim().to_owned())
}

// Create functions

fn create_new_view_model(
    folder: &str,
    file_prefix: &str,
    class_prefix: &str,
) -> Result<(), Box<dyn std::error::Error>> {
    let folder = format!("./lib/ui/screens/{}", folder.trim());

    // Create the folder if missing
    if !Path::new(&folder).exists() {
        fs::create_dir_all(&folder)?;
        println!("Create folder: {}", &folder);
    }

    let header = format_header();

    let files = [
        (
            "{}_localisation.dart",
            include_str!("../templates/redux/loc"),
        ),
        ("{}_view_model.dart", include_str!("../templates/redux/vm")),
        ("{}_widget.dart", include_str!("../templates/redux/widget")),
    ];

    for (file_name, file_content) in &files {
        let file_name = file_name.replace("{}", &file_prefix);

        println!("Processing: {}", file_name);

        let file_content = file_content
            .replace("{class_prefix}", &class_prefix)
            .replace("{header}", &header)
            .replace("{file_prefix}", &file_prefix);

        let file_path = format!("{}/{}", &folder, &file_name);
        fs::write(&file_path, file_content)?;

        println!("Created file: {}", file_path);
    }

    Ok(())
}

fn create_new_game(
    pascal_case: &str,
    camel_case: &str,
    snake_case: &str,
) -> Result<String, Box<dyn std::error::Error>> {
    let header = format_header()
        .lines()
        .map(|line| format!("+{}", line))
        .collect::<Vec<String>>()
        .join("\n");

    let mut git_patch = include_str!("../templates/game/0001-FEAT-ClassName-Game-Template.patch").to_string();

    git_patch = git_patch.replace("Dummy", pascal_case);
    git_patch = git_patch.replace("dummy", snake_case);
    git_patch = git_patch.replace("+/*
 *
 *  *
 *  * Created on 28 7 2023
 *
 */", &header); //TODO: why is it corupting patch?

    // Save the updated patch to a new file or update the existing one
    let patch_file_path = format!("./FEAT-{}-Game.patch", pascal_case);
    fs::write(&patch_file_path, git_patch)?;

    Ok(patch_file_path)
}
