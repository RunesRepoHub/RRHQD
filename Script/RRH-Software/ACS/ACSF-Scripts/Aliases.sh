
LOG_DIR="$HOME/ACS/logs"
LOG_FILE="$LOG_DIR/aliases_setup.log"

increment_log_file_name() {
  local log_file_base_name="aliases_setup_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file will be saved as $LOG_FILE"
}

mkdir -p "$LOG_DIR"
increment_log_file_name
exec > >(tee -a "$LOG_FILE") 2>&1


source ~/ACS/ACSF-Scripts/Core.sh

# Check if alias is already in .bashrc before adding
add_if_not_exists() {
    local alias_name="$1"
    local alias_command="$2"
    if ! grep -q "^alias $alias_name=" ~/.bashrc; then
        echo "alias $alias_name=\"$alias_command\"" >> ~/.bashrc
    else
        echo "Alias $alias_name already exists in .bashrc"
    fi
}



add_if_not_exists 'stop-download' "bash '$ROOT_FOLDER'/'$DOCKER_STOP'"
add_if_not_exists 'stop-all' "bash '$ROOT_FOLDER'/'$STOP'"
add_if_not_exists 'start-all' "bash '$ROOT_FOLDER'/'$START'"
add_if_not_exists 'acs-uninstall' "bash '$ROOT_FOLDER'/'$UNINSTALL'"
add_if_not_exists 'remove-all' "bash '$ROOT_FOLDER'/'$STOP_REMOVE'"
add_if_not_exists 'acs-usage' "bash '$ROOT_FOLDER'/'$USAGE'"
add_if_not_exists 'acs-convert' "bash '$ROOT_FOLDER'/'$CONVERT'"
