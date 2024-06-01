#!/bin/bash

# Function to display usage information
usage() {
  echo "Usage: $0 --in <input_file.mov> --out <output_file.gif>"
  exit 1
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 4 ]; then
  usage
fi

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --in) input_file="$2"; shift ;;
    --out) output_file="$2"; shift ;;
    *) echo "Unknown parameter: $1"; usage ;;
  esac
  shift
done

# Check if input_file and output_file are set
if [ -z "$input_file" ] || [ -z "$output_file" ]; then
  usage
fi

# Step 1: Extract frames from .mov file
ffmpeg -i "$input_file" -vf "fps=5,scale=iw/2:ih/2" frame_%04d.png

# Step 2: Convert frames to GIF
convert -delay 10 -loop 0 frame_*.png -layers Optimize "$output_file"

# Step 3: Clean up intermediate image files
rm frame_*.png

echo "Conversion complete: $output_file"

