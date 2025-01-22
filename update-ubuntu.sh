#!/bin/bash

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

echo "Starting the comprehensive system update process..."

# Update the package list
echo "Updating the package list..."
if apt update; then
  echo "Package list updated successfully."
else
  echo "Error updating the package list."
  exit 1
fi

# Upgrade installed packages
echo "Upgrading installed packages..."
if apt upgrade -y; then
  echo "Installed packages upgraded successfully."
else
  echo "Error upgrading packages."
  exit 1
fi

# Fix broken dependencies
echo "Fixing broken dependencies..."
if apt install -f -y; then
  echo "Broken dependencies fixed successfully."
else
  echo "Error fixing broken dependencies."
fi

# Clean up unnecessary packages
echo "Cleaning up unnecessary packages..."
if apt autoremove -y && apt autoclean && apt clean; then
  echo "System cleanup completed successfully."
else
  echo "Error during system cleanup."
fi

# Update snap packages
if command -v snap &> /dev/null; then
  echo "Updating snap packages..."
  if snap refresh; then
    echo "Snap packages updated successfully."
  else
    echo "Error updating snap packages."
  fi
else
  echo "Snap is not installed on this system."
fi

# Update flatpak packages if flatpak is installed
if command -v flatpak &> /dev/null; then
  echo "Flatpak is installed. Updating flatpak packages..."
  if flatpak update -y; then
    echo "Flatpak packages updated successfully."
  else
    echo "Error updating flatpak packages."
  fi
else
  echo "Flatpak is not installed on this system."
fi

echo "System update process completed!"

exit 0
