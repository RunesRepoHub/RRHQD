# Get the WAN IP address using dig and OpenDNS resolver
WAN_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Get the username
USERNAME=$(whoami)

# Get system distribution and version information
SYSTEM_INFO=$(lsb_release -d | cut -f2)

# Get the current date and time
DATE_TIME=$(date +"%Y-%m-%d %H:%M:%S")

# Send the data to the server using HTTP
curl -X POST -d "The user $USERNAME has just run RRHQD Setup.sh from the ip: $WAN_IP on $SYSTEM_INFO at time: $DATE_TIME" https://notify.rp-helpdesk.com/RRHQD-Analytics
