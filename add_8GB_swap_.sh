# Author: Max Haase - maxhaase@gmail.com
##############################################################################################
# Adds a 8GB swap file, if you're low on RAM, this is useful. 
# Save it, make it executable and run it as root or sudo.
##############################################################################################
#!/bin/bash

# Create a 8 GB swap file
sudo fallocate -l 8G /swapfile

# Set the correct permissions
sudo chmod 600 /swapfile

# Set up the swap area
sudo mkswap /swapfile

# Enable the swap file
sudo swapon /swapfile

# Verify the swap file is active
sudo swapon --show

# Make the swap file permanent by adding it to /etc/fstab
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "8 GB swap file has been created and enabled. Entry added to /etc/fstab."
