#!/bin/bash

trap cleanup EXIT

function cleanup() {
    kill $(jobs -p) > /dev/null 2>&1
}

function start() {
    source /opt/ailaby/etc/environment.sh
    
    if [[ -f /run/workspace_sync ]]; then
        printf "Waiting for workspace sync to complete...\n"
        while [[ -f /run/workspace_sync ]]; do
            sleep 1
        done
    fi

    printf "Starting storage monitor..\n"
    /opt/ailaby/storage_monitor/bin/storage-monitor.sh
}

start 2>&1