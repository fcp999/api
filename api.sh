#!/bin/bash

# Function to display menu
show_menu() {
    echo "1) Set Server URL"
    echo "2) Enter Username and Password"
    echo "3) Select Data Format (JSON/XML)"
    echo "4) Choose API Endpoint"
    echo "5) Execute API Request"
    echo "6) Exit"
}

# Variables to store user inputs
SERVER=""
USERNAME=""
PASSWORD=""
FORMAT="json"
ENDPOINT=""

# Available API endpoints
API_ENDPOINTS=(
    "/ng1api/ncm/devices/DC-Inf/applicationtemplate/"
    "/ng1api/ncm/devices"
    "/ng1api/ncm/devices/DC-Inf/interfaces/4"
    "/ng1api/ncm/sites/test1"
)

# Function to execute API request
execute_request() {
    if [[ -z "$SERVER" || -z "$USERNAME" || -z "$PASSWORD" || -z "$ENDPOINT" ]]; then
        echo "Missing required information. Please complete all steps."
        return
    fi
    
    CONTENT_TYPE="application/$FORMAT"
    AUTH_HEADER=$(echo -n "$USERNAME:$PASSWORD" | base64)
    
    echo "Making request to: $SERVER$ENDPOINT"
    curl -s -H "Content-Type: $CONTENT_TYPE" -H "Authorization: Basic $AUTH_HEADER" "$SERVER$ENDPOINT"
}

# Main menu loop
while true; do
    show_menu
    read -p "Select an option: " CHOICE

    case $CHOICE in
        1) read -p "Enter server URL (e.g., https://yourserver.com): " SERVER ;;
        2) read -p "Enter username: " USERNAME
           read -s -p "Enter password: " PASSWORD
           echo ;;
        3) read -p "Choose format (json/xml): " FORMAT ;;
        4) echo "Available Endpoints:"
           for i in "${!API_ENDPOINTS[@]}"; do
               echo "$((i+1))) ${API_ENDPOINTS[$i]}"
           done
           read -p "Select endpoint number: " EP_CHOICE
           ENDPOINT="${API_ENDPOINTS[$((EP_CHOICE-1))]}" ;;
        5) execute_request ;;
        6) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option, try again." ;;
    esac
done
