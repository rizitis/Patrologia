## Convert Patrologia 
1. Be sure the path is like this:

```
your_main_patrologia_folder/subdolfers/*.pdf (files)
├── combine_texts.py
├── pdf_ocr.sh

```

2. `chmod +x pdf_ocr.sh`
3. `./pdf_ocr.sh`


4. After few days (thanks to GNU Parallel) output will be like this:
```
your_main_patrologia_folder/subdolfers/*.pdf (files)
├── combine_texts.py
├── pdf_ocr.sh
|── output_images/subdirs/*.png
|── final_texts/*.txt files
```

files.txt is what you need....
This folders exist here because build need 3 days on 20 cores cpu 64Gi ram...


# NOTE
This script is not working if locally you dont manuall fix folders path as step 1 discribe.  

#  GNU Parallel
Tange, O. (2023). GNU Parallel 20240522 ('Tbilisi'). Zenodo. DOI: [10.5281/zenodo.11247979](https://doi.org/10.5281/zenodo.11247979).
