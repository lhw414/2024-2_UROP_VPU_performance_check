#!/bin/bash

output_dir_h264="h264_files"
output_dir_h265="h265_files"
output_dir_yuv="yuv_files"

mkdir -p "$output_dir_h264"
mkdir -p "$output_dir_h265"
mkdir -p "$output_dir_yuv"

declare -a resolutions=("1920x1080" "1280x720" "640x360")
declare -a framerates=(30 60 120)

duration=100

for resolution in "${resolutions[@]}"; do
    for framerate in "${framerates[@]}"; do
        total_frames=$((duration * framerate))
        output_file_h264="${output_dir_h264}/output_${resolution}_${framerate}fps_${total_frames}frames.264"
        output_file_h265="${output_dir_h265}/output_${resolution}_${framerate}fps_${total_frames}frames.265"
        output_file_yuv="${output_dir_yuv}/output_${resolution}_${framerate}fps_${total_frames}frames.yuv"
        echo "Generating file: $output_file_h264"
        ffmpeg -f lavfi -i testsrc=duration=${duration}:size=${resolution}:rate=${framerate} \
                -c:v h264 -y "$output_file_h264"
        echo "Generating file: $output_file_h265"
        sudo ./build/xcoder -c 0 -i "$output_file_h264" -o "$output_file_h265" -m a2h
        echo "Generating file: $output_file_yuv"
        sudo ./build/xcoder -c 0 -i "$output_file_h264" -o "$output_file_yuv" -m a2y
    done
done

echo "All files have been generated."
