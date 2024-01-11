perform_full_scan() {
  local disk=$1
  dialog --title "Scan Initiated" --infobox "Starting full scan on $disk..." 5 60
  sleep 2

  # Check S.M.A.R.T. status
  smartctl -H /dev/"$disk" &> /tmp/smart_status_$disk
  local smart_status=$?
  if [ $smart_status -ne 0 ]; then
    dialog --title "S.M.A.R.T. Status" --textbox /tmp/smart_status_$disk 20 60
    return 1
  fi

  # Run a short S.M.A.R.T. self-test
  dialog --title "S.M.A.R.T. Self-Test" --infobox "Running short S.M.A.R.T. self-test on $disk..." 5 60
  if ! smartctl -t short /dev/"$disk" &> /tmp/smart_selftest_$disk; then
    dialog --title "S.M.A.R.T. Self-Test" --textbox /tmp/smart_selftest_$disk 20 60
    return 1
  fi

  # Inform user to wait for the short test to complete
  dialog --title "Please Wait" --infobox "Waiting 2 minutes for the short S.M.A.R.T. self-test to complete on $disk..." 5 60
  sleep 2m

  # Check self-test logs
  if ! smartctl -l selftest /dev/"$disk" &> /tmp/smart_selftest_log_$disk; then
    dialog --title "Self-Test Logs" --textbox /tmp/smart_selftest_log_$disk 20 60
    return 1
  fi

  # Check for bad sectors
  if ! badblocks -sv /dev/"$disk" &> /tmp/badblocks_$disk; then
    dialog --title "Bad Sectors" --textbox /tmp/badblocks_$disk 20 60
    return 1
  fi

  dialog --title "Scan Completed" --msgbox "Full scan completed successfully for /dev/$disk." 5 60
}

