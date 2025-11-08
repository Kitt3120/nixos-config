#!/usr/bin/env bash

# GPU Killer Script
# This script allows the user to disable a selected GPU by removing its PCI device.
# It also provides an option to re-enable all GPUs by rescanning the PCI bus.

function elevate_privileges() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root. Trying to elevate privileges..."
        exec sudo bash "$0" "$@"
    fi
}

function print_pci_vga_devices() {
    local lines
    lines=$(lspci | rg -i 'vga')
    echo "Detected VGA devices:"
    local index=1
    while IFS= read -r line; do
        echo "[$index] $line"
        index=$((index + 1))
    done <<< "$lines"
}

function get_pci_vga_ids() {
    lspci | rg -i 'vga' | awk '{print $1}'
}

function rescan_pci_devices() {
    echo 1 > /sys/bus/pci/rescan
}

function disable_pci_device() {
    local pci_id=$1
    echo "Disabling PCI device $pci_id"
    echo 1 > /sys/bus/pci/devices/0000:$pci_id/remove
}

elevate_privileges "$@"

VGA_PCI_IDS=($(get_pci_vga_ids))
if [[ ${#VGA_PCI_IDS[@]} -eq 0 ]]; then
    echo "No VGA devices found. Exiting."
    exit 1
fi

print_pci_vga_devices
echo "- Select a GPU to disable by entering its number."
echo "- Enter 'r' or 'rescan' to re-enable all GPUs."
echo "- Enter 'e' or 'exit' to exit without making changes."
read -rp "> " user_input

if [[ -z $user_input ]]; then
    echo "No input provided. Exiting."
    exit 1
elif [[ $user_input == "e" || $user_input == "exit" ]]; then
    echo "Exiting without changes."
    exit 0
elif [[ $user_input == "r" || $user_input == "rescan" ]]; then
    rescan_pci_devices
    echo "Rescan complete. All GPUs re-enabled."
    exit 0
elif ! [[ $user_input =~ ^[0-9]+$ ]] || (( user_input < 1 || user_input > ${#VGA_PCI_IDS[@]} )); then
    echo "Invalid selection. Exiting."
    exit 1
fi

selected_index=$((user_input - 1))
selected_pci_id=${VGA_PCI_IDS[$selected_index]}
disable_pci_device "$selected_pci_id"
echo "GPU disabled"