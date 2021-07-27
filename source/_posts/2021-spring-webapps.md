---
title: Web Application Security
date: 2021-03-23 00:00
---

# March 24 2021 Meeting

## NCL Preseason Review

### Cryptography

- [Rumkin Chipher Tools](http://rumkin.com/tools/cipher/)
  - Basic chipers
    - Ceaser
    - Rot13
    - etc
- [Boxentriq Code Breaking Tools](https://www.boxentriq.com/code-breaking)
  - More polished chipher tools
    - Railfence
    - Chiper detection/bruteforce
    - Frequency analysis
- [Digital Invisible Ink Toolkit](http://diit.sourceforge.net/)
  - Image stego toolkit
  - Handles most of NCL stego challenges
- [Steganography Toolkit Docker Image](https://github.com/DominicBreuker/stego-toolkit)
  - A collection of stego tools that can be helpful for more difficult challenges

### Network Traffic Analysis

- [Wireshark](https://www.wireshark.org/)
  - Packet analysis
- [tshark](https://www.wireshark.org/docs/man-pages/tshark.html)
  - Terminal based Wireshark
    - Filter out data and write to file
- [Scapy](https://scapy.net/)
  - Python packet manipulation  library
    - Packet crafting and dissection

### Enumeration and Exploitation

- [Cutter](https://github.com/rizinorg/cutter)
  - Reverse engineering platform
    - Dissassembly
    - Decompiling
    - Debugging/Emulation
- (The GNU Project Debugger - GDB)[https://www.gnu.org/software/gdb/]
  - See what's going on inside an executing program
- ltrace Command
  - Intercepts a program's dynamic library calls, system calls, and received signals
- strace Command
  - Intercepts a program's system calls and received signals

## [OWASP ZAP](https://www.zaproxy.org/)

The Zed Attack Proxy (ZAP) is a web application security scanner maintained by the Open Web Application Security Project (OWASP).

Features include automating scanning tools, an intercepting proxy (ie Burpsuite), web crawlers, and numerous third party plugins.

## [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)

Juice Shop is an insecure web application built by OWASP for web security education.

It has numerous challenges involving injection, cross site scripting (XSS), improper input validation, data exposure, and many other vulnerabilities. Additionally, it also has a scoreboard to track your progress.

### Setup with Docker

Juice Shop is available as a Docker image [here.](https://hub.docker.com/r/bkimminich/juice-shop)

If you don't have Docker: [Get Started with Docker](https://www.docker.com/get-started)

If you already have Docker you can have Juice Shop set up in minutes:

1. Start docker

2. Run the following commands

- `docker pull bkimminich/juice-shop`

- `docker run --rm -p 3000:3000 bkimminich/juice-shop`

3. Open http://localhost:3000
