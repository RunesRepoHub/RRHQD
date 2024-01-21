#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/docker_update.log"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

list_containers() {
  sudo docker ps --format "{{.Names}}" | nl -w2 -s ') '
}

get_container_image() {
  sudo docker inspect --format='{{.Config.Image}}' "$1"
}

update_container() {
  local container_name="$1"
  local container_image="$(get_container_image "$container_name")"
  local container_ports="$(sudo docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{$p}};{{end}}' "$container_name" | sed 's/;$//')"
  local container_volumes="$(sudo docker inspect --format='{{range .Mounts}}{{.Source}}:{{.Destination}};{{end}}' "$container_name" | sed 's/;$//')"

  sudo docker pull "$container_image" && \
  sudo docker stop "$container_name" && \
  sudo docker rm "$container_name" && \
  sudo docker run -d --name "$container_name" -p $container_ports -v $container_volumes "$container_image"
}

generate_container_list() {
  mapfile -t containers < <(sudo docker ps -a --format "{{.Names}}")
  local container_list=()
  for i in "${!containers[@]}"; do
    container_list+=("$((i+1))" "${containers[i]}" OFF)
  done
  echo "${container_list[@]}"
}

show_dialog() {
  local container_list=($(generate_container_list))
  dialog --title "Select Docker containers to update" \
         --checklist "Use SPACE to select containers, ENTER to confirm:" 15 60 4 \
         "${container_list[@]}" 2>&1 >/dev/tty
}

selections=($(show_dialog))

for selection in "${selections[@]}"; do
  container_name=$(sudo docker ps --format "{{.Names}}" | sed "${selection}q;d")
  if [ -n "$container_name" ]; then
    echo "Updating container: $container_name"
    update_container "$container_name"
  else
    echo "Invalid selection: $selection"
  fi
done

echo "Update process completed."
