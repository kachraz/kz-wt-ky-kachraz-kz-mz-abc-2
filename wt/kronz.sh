#!/bin/bash

# Function to execute every minute
minute_task() {
    while true; do
        # Get the current timestamp
        timestamp=$(date "+%Y-%m-%d %H:%M:%S")

        # Perform your desired task here (e.g., check a log file, update a database)
        echo "[$timestamp] Minute task executed " >>time.txt
        ./g

        sleep 10 # Sleep for 60 seconds (1 minute)
    done
}
minute_task
