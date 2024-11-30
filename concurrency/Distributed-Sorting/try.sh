#!/bin/bash

# Check if a.out exists
if [ ! -f "a.out" ]; then
    echo "Error: a.out does not exist."
    exit 1
fi

# Output file where results will be saved
OUTPUT_FILE="execution_report.txt"

# Run the program and track time and memory usage
echo "Running a.out interactively and tracking time and memory usage..." > $OUTPUT_FILE
/usr/bin/time -v ./a.out >> $OUTPUT_FILE 2>&1

# Inform the user about the result location
echo "Execution completed. Output saved to '$OUTPUT_FILE'."
