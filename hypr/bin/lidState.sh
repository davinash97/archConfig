#!/bin/bash

LIDSTATE=$(find /proc/acpi/button/lid/LID/state)
if grep -q open $LIDSTATE; then
    hyprctl keyword monitor "eDP-1, enable";
    # echo "open"
else
    pidof hyprlock || hyprlock;
    hyprctl keyword monitor "eDP-1, disable";
    # echo "close"
fi