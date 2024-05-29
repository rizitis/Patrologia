import os

output_dir = 'final_texts'

# Create the output directory if it does not exist
os.makedirs(output_dir, exist_ok=True)

for root, dirs, files in os.walk('.'):
    for dirname in dirs:
        output_file = os.path.join(output_dir, f'{dirname}.txt')
        with open(output_file, 'w', encoding='utf-8') as outfile:
            folder_path = os.path.join(root, dirname)
            for filename in os.listdir(folder_path):
                if filename.endswith('.txt'):
                    filepath = os.path.join(folder_path, filename)
                    with open(filepath, 'r', encoding='utf-8') as infile:
                        outfile.write(infile.read())
                        outfile.write('\n')

print("Text files in each folder have been combined into final text files.")
