# Patrologia


## Requires: 
In a full Slackware installation just install from SBo

```
tesseract
```
then 
`cd /usr/share/tessdata`
`sudo wget -c https://github.com/tesseract-ocr/tessdata/raw/4.00/grc.traineddata`
`sudo wget -c https://github.com/tesseract-ocr/tessdata/raw/4.00/lat.traineddata`

For custom Slackware installation ensure you have:
```
poppler
poppler-data
```

## Convert Patrologia 
1. Be sure the path is like this:

```
your_main_patrologia_folder/subdolfers/*.pdf (files)
├── combine_texts.py
├── pdf_ocr.sh

```

2. `chmod +x pdf_ocr.sh`
3. `./pdf_ocr.sh`


4. After few hours output will be like this:
```
your_main_patrologia_folder/subdolfers/*.pdf (files)
├── combine_texts.py
├── pdf_ocr.sh
└── ocr_texts/
    ├── subdir1/
    │   ├── file1.txt
    │   └── file2.txt
    ├── subdir2/
    │   ├── file3.txt
    │   └── file4.txt
    └── ...
```

files.txt files is what you need....



# NOTE
This script is not working if locally you dont manuall fix folders path as step 1 discribe.  
