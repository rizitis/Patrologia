#!/bin/bash

# Anagnostakis Ioannis (aka rizitis) 25/05/2024
# LICENSE MIT (https://opensource.org/license/mit)

# Function to convert folder name into a Unix-friendly format
convert_folder_name() {
    # Remove spaces and replace commas with underscores
    echo "$1" | tr ' ,' '_'
}

# Number of CPU cores for parallel processing
NUM_CORES=$(nproc)

# Function to convert PDF files to PNG images
convert_to_png() {
    local dir="$1"
    local output_dir="output_images/$(convert_folder_name "$(basename "$dir")")"

    mkdir -p "$output_dir"

    # Convert PDF files to PNG images in parallel
    parallel --bar -j "$NUM_CORES" pdftoppm -r 300 -png {} "$output_dir"/"{/.}" ::: "$dir"/*.pdf
}

# Function to perform OCR on PNG images
perform_ocr() {
    local dir="$1"

    # Perform OCR on PNG images in parallel
    parallel --bar -j "$NUM_CORES" tesseract {} "{.}" -l grc+lat ::: "$dir"/*.png
}



# Main script

# Get the current working directory
WDIR=$(pwd)
echo "Working directory: $WDIR"

# Create the output_images directory if it does not exist
mkdir -p output_images

# Convert PDF files to PNG images in parallel
#find . -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
#    convert_to_png "$dir"
#done

# Wait for PDF to PNG conversion to complete
#wait

# Check if conversion to PNG was successful
#if [ $? -ne 0 ]; then
#    echo "Error: PDF to PNG conversion failed."
#    exit 1
#fi

echo "PDF to PNG conversion complete."

# Create the ocr_texts directory if it does not exist
mkdir -p ocr_texts

# Perform OCR on PNG images in each subdirectory of output_images
find output_images -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
    perform_ocr "$dir"
done

# Wait for OCR processing to complete
wait

# Check if OCR processing was successful
if [ $? -ne 0 ]; then
    echo "Error: OCR processing failed."
    exit 1
fi

echo "OCR processing complete."

# Call the Python script to combine text files
python3 combine_texts.py

if [ $? -ne 0 ]; then
    echo "Error: Combining text files failed."
    exit 1
fi

echo "Text files combined."
echo "Processing complete."
