#!/bin/bash

input_folder="../h264_files"          
output_folder="../test_output/h264_to_h265" 
result_folder="../test_result/h264_to_h265" 
iterations=20                      

mkdir -p "$output_folder"
mkdir -p "$result_folder"

echo "Starting batch Transcoding tests..."
echo "======================================"

for input_file in "$input_folder"/*.264; do
    if [ ! -f "$input_file" ]; then
        echo "No input files found in $input_folder. Exiting..."
        exit 1
    fi

    filename=$(basename -- "$input_file")
    filename_noext="${filename%.*}"

    output_yuv="$output_folder/${filename_noext}.265"
    output_result="$result_folder/${filename_noext}_result.txt"

    echo "Bytes per second 결과:" > "$output_result"
    echo "======================================" >> "$output_result"

    for i in $(seq 1 $iterations); do
        echo "Processing file: $filename - Iteration $i..."

        start_time=$(date +%s.%N)

        output=$(sudo ../build/xcoder -c 0 -i "$input_file" -o "$output_yuv" -m a2h 2>&1)
        end_time=$(date +%s.%N)

        total_bytes=$(echo "$output" | grep "Total bytes" | tail -n 1 | awk '{print $10}')

        time_diff=$(echo "$end_time - $start_time" | bc)
        echo "Time taken: $time_diff seconds"
        echo "total_bytes: $total_bytes"

        if [ -n "$total_bytes" ] && [ -n "$time_diff" ] && (( $(echo "$time_diff > 0" | bc -l) )); then
            bytes_per_second=$(echo "scale=2; $total_bytes / $time_diff" | bc)
            echo "$bytes_per_second" >> "$output_result"
            echo "Iteration $i: $bytes_per_second Bytes per second"
        else
            echo "Iteration $i: Failed to calculate Bytes per second" >> "$output_result"
            echo "Iteration $i: Failed to calculate Bytes per second"
        fi
    done

    echo "Completed: $filename. Results saved to $output_result"
    echo "--------------------------------------"
done

echo "All tests completed. Results saved in $result_folder."
