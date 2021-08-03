---
title: Ciphers and Hashing
date: 2021-08-03
---

# Ciphers and Hashing

## Ciphers

### What are ciphers?
    - Cipher- a method to transform text to hide its meaning (Merriam-Webster def. 2)
    - Types of ciphers (there are a lot but here are some common ones):
        - Caesar
        - Vigenere
        - Decimal
        - Base64
        - Binary
        - Hex
        - Baconian
        - And more!

### Decoding Ciphers:

- Methods:
    - Scripting (Python, BASH, etc.)
    - Through the Web:
        - [Rapidtables](https://bit.ly/2nqHKBM)
        - [Rumkin](https://bit.ly/1tgtYh0)
        - [CyberChef](https://gchq.github.io/CyberChef/)
        - [Boxentriq](https://www.boxentriq.com/code-breaking)

## Hashing and Password Hashing:

![Meme](./source/images/dictionary-attack.jpg)

### What is Hashing?
- Short Answer: a more secure cipher that is irreversible
- Long Answer: It’s a way to remap the values of a string for secure transmission and file integrity (think of computer forensics)
Example Hashes: see the crypto.zip file “hashSignatures.txt”
- How to use file integrity: `md5sum <file>`,
`sha[1, 256, 384, 512]sum <file>`
    - Example - ParrotOS md5 checksum
        - Parrot Security 4.7 x64 (iso) - 97b80f3f05cb48aab61c59586e11a49a
- How to Calculate Hashes: https://bit.ly/2IwTZJ8

### Identifying Hashes:

- via CLI: `hash-identifier <single hash>`
- via [Web](https://bit.ly/2p9t9zf)
- You can put hashes of the same type in a file and crack all at once

### Cracking Hashes:

#### Building a Dictionary:

- Included dictionary with Kali and Parrot: RockYou.txt: /usr/share/wordlists
    - Note: you need to use gunzip rockyou.txt.gz and then cp rockyou.txt to a directory that is easy to access to you
- Create your own:
 - Crunch (no mask): `crunch <min> <max> [charset] >> output.txt`
- Crunch (w/ mask): `crunch <min> <max> -t String-txt-@,%^ >> output.txt`
    - @ = lowercase letters
    - , (comma) = uppercase letters
    - % = numbers
    - ^ = symbols
- Cewl: `cewl -d 0 <url> >> output.txt`
- SecLists: `git clone https://github.com/danielmiessler/SecLists.git`

#### Tools of the Trade:

##### CLI:

- Straight Attack: `sudo hashcat -a <attack type> -m <hash num> hashes.txt ~/path/to/dictionary (or dictionary file if working within the same directory) --show >> cracked.txt`
    - Note from experience: run hashcat once before using the --show in order to crack hashes and outputting cracked hash 
- Combination: `sudo hashcat -a <attack type> -m <hash num> hashes.txt /path/to/dictionary1 /path/to/dictionary2 (or dictionary file if working within the same directory) --show >> cracked.txt`
- John the Ripper (john --list=formats)
Password file: `sudo --format=<hashtype> john hashes.txt
MD5 = raw-md5`
    - Zip: `zip2john <file>.zip >> johnhash.txt`

##### GUI:
- NTLM via GUI
- Applications → Pentesting → Password Attacks → Local attacks → Ophcrack
- Need to download [ophcrack tables](https://bit.ly/2mG7mhs)
    - Just as an FYI, these tables can take up a lot of storage
- To load in tables: Tables → Select Table → Find where its installed → Select & hit Ok
    - Note: you will have to do this every time you use ophcrack
