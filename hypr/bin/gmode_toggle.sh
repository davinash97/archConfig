#!/bin/bash

# Path to the state file
STATE_FILE="/tmp/gmode_state"

# Ensure acpi_call module is loaded
if [ ! -f /proc/acpi/call ]; then
    echo "Error: acpi_call module not found. Please install it and run 'sudo modprobe acpi_call'."
    exit 1
fi

function normal(){
    echo "Switching to Normal Mode..."
    # Disable G-Mode Toggle
    echo "\_SB.AMW3.WMAX 0 0x15 {1, 0x00, 0x00, 0x00}" | sudo tee /proc/acpi/call > /dev/null
    # Set Thermal Profile to Balanced
    echo "\_SB.AMW3.WMAX 0 0x25 {1, 0x00, 0x00, 0x00}" | sudo tee /proc/acpi/call > /dev/null
    # Reset CPU Governor
    echo schedutil | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
    
    notify-send "G-Mode" "Disabled - Balanced Profile"
}

function performance() {
    echo "Switching to Performance Mode..."
    # Enable G-Mode Toggle
    echo "\_SB.AMW3.WMAX 0 0x15 {1, 0xab, 0x00, 0x00}" | sudo tee /proc/acpi/call > /dev/null
    # Set Thermal Profile to Performance (Max Fans)
    echo "\_SB.AMW3.WMAX 0 0x25 {1, 0x01, 0x00, 0x00}" | sudo tee /proc/acpi/call > /dev/null
    # Set CPU Governor to Performance
    echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
    
    notify-send "G-Mode" "Enabled - High Performance"
}

# Simple Toggle Logic
if [ ! -f $STATE_FILE ] || [ "$(cat $STATE_FILE)" == "performance" ]; then
    normal
    echo "normal" > $STATE_FILE
else
    performance
    echo "performance" > $STATE_FILE
fi