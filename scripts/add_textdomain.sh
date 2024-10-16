#!/bin/bash

# Set your textdomain here
TEXTDOMAIN="era_of_ilthan"

# Set the directory to search through (defaults to current directory if not set)
DIRECTORY=${1:-.}

# Function to add textdomain if not already present
add_textdomain() {
    local file="$1"

    # Check if the file already contains a textdomain line
    if grep -q "^#textdomain" "$file"; then
        echo "Textdomain already present in $file. Skipping..."
    else
        # Add the textdomain at the beginning of the file
        echo -e "#textdomain $TEXTDOMAIN\n$(cat "$file")" > "$file"
        echo "Textdomain added to $file."
    fi
}

# Export the function so it can be used by find
export -f add_textdomain
export TEXTDOMAIN

# Find all .cfg files and apply the function
find "$DIRECTORY" -type f -name "*.cfg" -exec bash -c 'add_textdomain "$0"' {} \;
