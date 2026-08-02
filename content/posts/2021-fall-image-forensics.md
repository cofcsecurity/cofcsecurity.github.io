---
title: Image Forensics
date: 2021-08-04
---

# Image Forensics

**[Materials for the Meeting](https://github.com/cofcsecurity/Presentations/blob/master/Presentation-Materials/stego.zip?raw=true)**

## How to Extract Metadata from Files

### CLI

- Imago:

    - Installing:
        - [Github](https://github.com/redaelli/imago-forensics.git)
        - `pip install imago`
    - Running:
        - `imago -i [path to directory where the file is located] -o [where do you want the output file to go] -x -t -g`
            - -x = for exif metadata 
            - -t = for only .jpg images
            - -g = gps info, if available

- Exiftool:

    - Running: `exiftool <options> /path/to/file`

### Web

- [Web](http://exif.regex.info/exif.cgi)

## Steganography

- Download: [DIIT](http://diit.sourceforge.net/download.php)
- How to run: `java -jar -Xmx512m diit-1.5.jar`
- Practice:
    1. Stego 1.bmp
    2. Stego 2.bmp
    3. STEG3.bmp
    4. Stego 3.bmp
    5. Steg4.bmp


[@pmccabe5](https://github.com/pmccabe5)  

