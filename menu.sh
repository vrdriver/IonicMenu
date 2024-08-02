#!/bin/bash

# Menu title
TITLE="Steve's Ionic Menu"

# Menu options
OPTIONS=(
    "Create new page"
    "-----"
    "Build and sync iOS"
    "Build and sync Android"
    "Open iOS project"
    "Open Android project"
    "Run Ionic serve"
    "Build all"
    "Build and sync all"
    "-----"
    "Create new page - then exit"
    "Build and sync iOS - then exit"
    "Build and sync Android - then exit"
    "Open iOS project - then exit"
    "Open Android project - then exit"
    "Run Ionic serve - then exit"
    "Build all - then exit"
    "Build and sync all - then exit"
    "-----"
    "Quit"
)

# Function to print the menu
print_menu() {
    clear
    echo "== $TITLE =="
    echo
    for i in "${!OPTIONS[@]}"; do
        if [[ "${OPTIONS[$i]}" == "-----" ]]; then
            echo "-------------------------"
        else
            if [ $i -eq $MENU_INDEX ]; then
                tput setaf 2
                echo "> ${OPTIONS[$i]}"
                tput sgr0
            else
                echo "  ${OPTIONS[$i]}"
            fi
        fi
    done
}

# Function to handle menu selection
execute_option() {
    local real_index=$((MENU_INDEX - $(awk -F: '/-----/ {print NR-1}' <<< "${OPTIONS[@]}" | awk 'END {print}' || echo 0)))

    case $real_index in
        0)  echo "Executing: ionic generate page"
            read -p "Enter page name: " PAGE_NAME
            echo "Command: ionic generate page $PAGE_NAME"
            ionic generate page $PAGE_NAME
            ;;
        2)  echo "Executing: ionic capacitor sync ios"
            echo "Command: ionic capacitor sync ios"
            ionic capacitor sync ios
            ;;
        3)  echo "Executing: ionic capacitor sync android"
            echo "Command: ionic capacitor sync android"
            ionic capacitor sync android
            ;;
        4)  echo "Executing: ionic capacitor open ios"
            echo "Command: ionic capacitor open ios"
            ionic capacitor open ios
            ;;
        5)  echo "Executing: ionic capacitor open android"
            echo "Command: ionic capacitor open android"
            ionic capacitor open android
            ;;
        6)  echo "Executing: ionic serve"
            echo "Command: ionic serve"
            ionic serve
            ;;
        7)  echo "Executing: ionic capacitor build ios"
            echo "Command: ionic capacitor build ios"
            ionic capacitor build ios
            echo "Executing: ionic capacitor build android"
            echo "Command: ionic capacitor build android"
            ionic capacitor build android
            ;;
        8)  echo "Executing: ionic capacitor sync ios"
            echo "Command: ionic capacitor sync ios"
            ionic capacitor sync ios
            echo "Executing: ionic capacitor sync android"
            echo "Command: ionic capacitor sync android"
            ionic capacitor sync android
            ;;
        8)  echo "Exiting..."
            exit 0
            ;;
        10)  echo "Executing: ionic generate page"
            read -p "Enter page name: " PAGE_NAME
            echo "Command: ionic generate page $PAGE_NAME"
            ionic generate page $PAGE_NAME
            echo "Exiting..."
            exit 0
            ;;
        11)  echo "Executing: ionic capacitor sync ios"
            echo "Command: ionic capacitor sync ios"
            ionic capacitor sync ios
            echo "Exiting..."
            exit 0
            ;;
        12)  echo "Executing: ionic capacitor sync android"
            echo "Command: ionic capacitor sync android"
            ionic capacitor sync android
            echo "Exiting..."
            exit 0
            ;;
        13)  echo "Executing: ionic capacitor open ios"
            echo "Command: ionic capacitor open ios"
            ionic capacitor open ios
            echo "Exiting..."
            exit 0
            ;;
        14)  echo "Executing: ionic capacitor open android"
            echo "Command: ionic capacitor open android"
            ionic capacitor open android
            echo "Exiting..."
            exit 0
            ;;
        15)  echo "Executing: ionic serve"
            echo "Command: ionic serve"
            ionic serve
            echo "Exiting..."
            exit 0
            ;;
        16)  echo "Executing: ionic capacitor build ios"
            echo "Command: ionic capacitor build ios"
            ionic capacitor build ios
            echo "Executing: ionic capacitor build android"
            echo "Command: ionic capacitor build android"
            ionic capacitor build android
            echo "Exiting..."
            exit 0
            ;;
        17)  echo "Executing: ionic capacitor sync ios"
            echo "Command: ionic capacitor sync ios"
            ionic capacitor sync ios
            echo "Executing: ionic capacitor sync android"
            echo "Command: ionic capacitor sync android"
            ionic capacitor sync android
            echo "Executing: ionic capacitor build ios"
            echo "Command: ionic capacitor build ios"
            ionic capacitor build ios
            echo "Executing: ionic capacitor build android"
            echo "Command: ionic capacitor build android"
            ionic capacitor build android
            echo "Exiting..."
            exit 0
            ;;
        19) echo "Exiting..."
            exit 0
            ;;
        *)  echo "Invalid option: $MENU_INDEX"
            ;;
    esac
}

# Function to skip separators
skip_separator() {
    local index=$1
    while [[ "${OPTIONS[$index]}" == "-----" ]]; do
        index=$((index + 1))
        if [ $index -ge ${#OPTIONS[@]} ]; then
            index=0
        fi
    done
    echo $index
}

# Function to find the previous valid option index
find_previous() {
    local index=$1
    while [[ "${OPTIONS[$index]}" == "-----" ]]; do
        index=$((index - 1))
        if [ $index -lt 0 ]; then
            index=$(( ${#OPTIONS[@]} - 1 ))
        fi
    done
    echo $index
}

# Initialize menu index
MENU_INDEX=0

# Clear screen and display the menu
print_menu

# Read user input and navigate the menu
while true; do
    read -rsn1 input

    # Handle arrow key sequences
    if [[ $input == $'\x1B' ]]; then
        read -rsn2 input
        case $input in
            '[A')  # Up arrow
                MENU_INDEX=$((MENU_INDEX - 1))
                if [ $MENU_INDEX -lt 0 ]; then
                    MENU_INDEX=$(( ${#OPTIONS[@]} - 1 ))
                fi
                MENU_INDEX=$(find_previous $MENU_INDEX)
                ;;
            '[B')  # Down arrow
                MENU_INDEX=$((MENU_INDEX + 1))
                if [ $MENU_INDEX -ge ${#OPTIONS[@]} ]; then
                    MENU_INDEX=0
                fi
                MENU_INDEX=$(skip_separator $MENU_INDEX)
                ;;
        esac
        print_menu
    elif [[ $input == "" ]]; then
        if [ "${OPTIONS[$MENU_INDEX]}" == "Quit" ]; then
            echo "Exiting..."
            exit 0
        else
            execute_option
            print_menu
        fi
    fi
done
