#bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/llama_gpt_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="llama_gpt_install_run_"
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

cd
# Script to setup and configure a Llama-GPT.sh Docker container and start it

source ~/RRHQD/Core/Core.sh

cd $ROOT_FOLDER

git clone https://github.com/getumbrel/llama-gpt.git

cd $ROOT_FOLDER/$LLAMA_GPT_FOLDER

./run.sh --model 7b