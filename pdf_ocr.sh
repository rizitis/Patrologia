#!/bin/bash

# Function to convert folder name into a Unix-friendly format
convert_folder_name() {
    # Remove spaces and replace commas with underscores
    echo "$1" | tr ' ,' '_'
}

# Get the current working directory which must include only subdirs/*.pdf
WDIR=$(pwd)
echo "$WDIR"

# Ensure we are in the correct working directory
if [ "$WDIR" != "$(pwd)" ]; then
    echo "Error: Not in the correct working directory."
    exit 1
fi

# Create the output_images directory if it does not exist
mkdir -p output_images

# Loop through each subfolder
find . -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
    # Convert folder name to a Unix-friendly format
    unix_dir=$(convert_folder_name "$(basename "$dir")")

    # Create a corresponding subfolder in output_images
    mkdir -p "output_images/$unix_dir"

    # Check if any PDF files exist in the current subdirectory
    shopt -s nullglob
    pdf_files=("$dir"/*.pdf)
    if [ ${#pdf_files[@]} -eq 0 ]; then
        echo "No PDF files found in $dir"
        continue
    fi

    # Loop through each PDF file in the subfolder
    for pdf in "${pdf_files[@]}"; do
        # Convert each PDF to PNG and save it in the corresponding output_images subfolder
        pdftoppm -r 300 -png "$pdf" "output_images/$unix_dir/$(basename "${pdf%.pdf}")" || exit 1
    done
done

# Wait for PDF to PNG conversion to complete
wait

# Check if conversion to PNG was successful
if [ $? -eq 0 ]; then
    echo "PDF to PNG conversion complete."
else
    echo "Error: PDF to PNG conversion failed."
    exit 1
fi

# Create the ocr_texts directory if it does not exist
mkdir -p ocr_texts

# Loop through each subfolder again to process the images
find . -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
    # Convert folder name to a Unix-friendly format
    unix_dir=$(convert_folder_name "$(basename "$dir")")

    # Create a corresponding subfolder in ocr_texts
    mkdir -p "ocr_texts/$unix_dir"

    # Check if any PNG files exist in the current output_images subdirectory
    shopt -s nullglob
    png_files=("output_images/$unix_dir"*.png)
    if [ ${#png_files[@]} -eq 0 ]; then
        echo "No PNG files found in output_images/$unix_dir"
        continue
    fi

    # Loop through each PNG file in the output_images subfolder
    for image in "${png_files[@]}"; do
        # Perform OCR on the image and save the text output in the corresponding ocr_texts subfolder
        tesseract "$image" "ocr_texts/$unix_dir/$(basename "${image%.png}")" -l grc+lat || exit 1
    done
done

# Wait for OCR processing to complete
wait

# Check if OCR processing was successful
if [ $? -eq 0 ]; then
    echo "OCR processing complete."
else
    echo "Error: OCR processing failed."
    exit 1
fi

echo "Processing complete."

# Call the Python script to combine text files
python3 combine_texts.py || exit 1

echo "Text files combined."
