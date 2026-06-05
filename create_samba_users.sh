#!/bin/bash

# This script reads username and password from a text file. They should be colon separated. Username:Password

while IFS=":" read -r user pass; do
  if ! id -u "$user" >/dev/null 2>&1; then
    echo "Creating user: $user ..."
    # Non-interactive shell with no home directory. Modify accordingly
    sudo useradd -M -s /bin/false "$user"
  fi
  
  # Set system password
  sudo passwd "$user" <<< "$pass"'\n'"$pass"
  
  # Set Samba password
  echo "Setting up samba credentials for $user ..."
  sudo smbpasswd -a "$user" <<< "$pass"'\n'"$pass"
  
  # Adding user to a specific group
  echo "Adding $user to a group..."
  sudo usermod -aG groupname "$user"
  
done < users.txt