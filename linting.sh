#!/bin/bash

get_changed_directories() {
    
    changed_files=$(git diff-tree --no-commit-id --name-only -r HEAD)
    
    directories=$(echo "$changed_files" | awk -F/ '{print $1}' | sort -u)
    
    echo "$directories"
}

# Function to run flake8 on given directories
run_flake8_on_directories() {
    local directories=$1
    
    for dir in $directories; do
        if [ -d "$dir" ]; then
            echo "Running flake8 on directory: $dir"
            flake8 $dir
            if [ $? -ne 0 ]; then
                echo "flake8 found issues in directory: $dir"
            else
                echo "No issues found in directory: $dir"
            fi
        fi
    done
}

# Main script execution
changed_directories=$(get_changed_directories)
if [ -n "$changed_directories" ]; then
    run_flake8_on_directories "$changed_directories"
else
    echo "No directories changed in the last commit."
fi
