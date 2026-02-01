#!/bin/bash

# toggle wifi|bt

ARGS=$(echo "$1" | tr '[:upper:]' '[:lower:]');

case "$ARGS" in

    wifi)

        STATUS=$(busctl get-property org.freedesktop.NetworkManager /org/freedesktop/NetworkManager org.freedesktop.NetworkManager WirelessEnabled)
        if [ "$STATUS" == "b true" ]; then
            echo "$1 powered On";
            POWER="off";
        else
            echo "$1 powered Off";
            POWER="on";
        fi
        echo "changing state";
        CMD="nmcli radio wifi $POWER";

    ;;
    bt|bluetooth)

        STATUS=$(busctl get-property org.bluez /org/bluez/hci0 org.bluez.Adapter1 Powered)
        if [ "$STATUS" == "b true" ]; then
            echo "$1 powered On";
            POWER="off";
        else
            echo "$1 powered Off";
            POWER="on";
        fi
        CMD="bluetoothctl power $POWER";

    ;;
    *)

        echo "you need to pass an argument like bt | wifi";
        exit 1;
    ;;

esac

exec $CMD;
