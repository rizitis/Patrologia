import os

input_dir = 'ocr_texts'
output_file = 'final_texts.txt'

with open(output_file, 'w', encoding='utf-8') as outfile:
    for root, dirs, files in os.walk(input_dir):
        for filename in files:
            if filename.endswith('.txt'):
                filepath = os.path.join(root, filename)
                with open(filepath, 'r', encoding='utf-8') as infile:
                    outfile.write(infile.read())
                    outfile.write('\n')

print("All text files have been combined into final_texts.txt")
