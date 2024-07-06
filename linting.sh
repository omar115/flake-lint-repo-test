#!/bin/bash

get_changed_directories() {
    
    changed_files=$(git diff-tree --no-commit-id --name-only -r HEAD)
    
    directories=$(echo "$changed_files" | awk -F/ '{print $1}' | sort -u)
    
    echo "$directories"
}


run_linting() {
    local directories=$1
    
    for dir in $directories; do
        if [ -d "$dir" ]; then
            echo "Last commit directory ==> $dir"
            flake8 $dir
            if [ $? -ne 0 ]; then
                echo "Linting result given to dir -->  $dir"
            else
                echo "No issues found, linting passed for dir --> $dir"
            fi
        fi
    done
}


changed_directories=$(get_changed_directories)
if [ -n "$changed_directories" ]; then
    run_linting "$changed_directories"
else
    echo "No directories changed in the last commit."
fi
