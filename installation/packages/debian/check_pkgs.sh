#!/bin/bash

PACKAGE_LIST="./deb_pkgs.txt"

# Check if the package list file exists
if [[ ! -f "$PACKAGE_LIST" ]]; then
    echo "File $PACKAGE_LIST not found!"
    exit 1
fi

# Initialize an empty array to hold missing packages
missing_packages=()

# Loop through each package in the file
while IFS= read -r package; do
    # Check if the package is installed
    #if ! dpkg -l | grep -q "^ii  $package"; then

    if ! dpkg -l | grep -q "^ii  $package[: ]"; then
    #if ! dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "install ok installed"; then
        # If not installed, add to the missing packages array
        missing_packages+=("$package")
    fi
done < "$PACKAGE_LIST"

# Check if there are any missing packages
if [ ${#missing_packages[@]} -eq 0 ]; then
    echo "All packages are installed."
else
    echo "The following packages are missing:"
    for pkg in "${missing_packages[@]}"; do
        echo "- $pkg"
    done

    # Ask if the user wants to install the missing packages
    read -p "Do you want to install the missing packages? (y/n) " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        # Install the missing packages
        sudo apt-get update
        for pkg in "${missing_packages[@]}"; do
            sudo apt-get install -y "$pkg"
        done
    else
        echo "No packages were installed."
    fi
fi
