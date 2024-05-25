#!/bin/bash

# Get the current working directory which must include only subdirs/*.pdf
WDIR=$(pwd)
echo "$WDIR"

# List the names of subfolders and store them in a variable
SDIR=$(ls -d */)
echo "$SDIR"

# Ensure we are in the correct working directory
if [ "$WDIR" == "$(pwd)" ]; then
    # Create the output_images directory if it does not exist
    mkdir -p output_images

    # Loop through each subfolder
    for dir in $SDIR; do
        # Create a corresponding subfolder in output_images
        mkdir -p "output_images/$dir"

        # Loop through each PDF file in the subfolder
        for pdf in "$dir"*.pdf; do
            # Convert each PDF to PNG and save it in the corresponding output_images subfolder
            pdftoppm -r 300 -png "$pdf" "output_images/$dir/$(basename "${pdf%.pdf}")"
        done
    done
fi

# Create the ocr_texts directory if it does not exist
mkdir -p ocr_texts

# Loop through each subfolder again to process the images
for dir in $SDIR; do
    # Create a corresponding subfolder in ocr_texts
    mkdir -p "ocr_texts/$dir"

    # Loop through each PNG file in the output_images subfolder
    for image in "output_images/$dir"*.png; do
        # Perform OCR on the image and save the text output in the corresponding ocr_texts subfolder
        tesseract "$image" "ocr_texts/$dir/$(basename "${image%.png}")" -l grc+lat
    done
done

echo "Processing complete."

# Call the Python script to combine text files
python3 combine_texts.py

echo "Text files combined."

