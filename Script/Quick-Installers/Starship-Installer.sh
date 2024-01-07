#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/starship_installer.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="starship_installer_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file will be saved as $LOG_FILE"
}

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

backtitle="$scriptname - Version $version"
menu_title="$me"

function install_starship() {
    curl -sS https://starship.rs/install.sh | sh
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
}

function main_menu() {
    while true; do
        echo "$backtitle"
        echo "$menu_title"
        echo "1) Install Starship"
        echo "2) Exit"
        echo "Please enter your choice (1 or 2): "
        read -r choice
        
        case $choice in
            1) install_starship ;;
            2) break ;;
            *) echo "Invalid option." ;;
        esac
    done
}

main_menu

mkdir -p ~/.config && cat << 'EOF' > ~/.config/starship.toml
format = """
[┌───────────────────>](red)$os running on $localip $hostname
[│](red)$sudo $username|$status|$git_branch $directory|$git_state$package$python|$git_status$cmd_duration
[└](red)$character """

[hostname]
ssh_only = false
format = 'aka [$hostname](red)'
trim_at = '.companyname.com'
disabled = false

[directory]
style = "red"

[character]
success_symbol = "[❯](blue)"
error_symbol = "[❯](red)"
vimcmd_symbol = "[❮](green)"

[username]
style_user = 'green'
style_root = 'red'
format = '[$user]($style)'
disabled = false
show_always = true

[git_branch]
format = "[$branch]($style)"
style = "bright-black"

[git_status]
format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)"
style = "cyan"
conflicted = "​"
untracked = "​"
modified = "​"
staged = "​"
renamed = "​"
deleted = "​"
stashed = "≡"

[git_state]
format = '\([$state( $progress_current/$progress_total)]($style)\) '
style = "bright-black"

[cmd_duration]
format = "[$duration]($style) "
style = "yellow"

[python]
format = "[$virtualenv]($style)"
style = "bright-black"

[os]
format = " [($name)]($style)"
style = "red"
disabled = false

[status]
style = 'bg:orange'
symbol = '🔴 '
success_symbol = '🟢 SUCCESS'
format = '[\[$symbol$common_meaning$signal_name$maybe_int\]]($style)'
map_symbol = true
disabled = false

[sudo]
style = 'red'
symbol = '👩💻'
disabled = false

[localip]
ssh_only = false
format = '[$localipv4](red)'
disabled = false
EOF