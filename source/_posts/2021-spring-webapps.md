---
title: Web Application Security
date: 2021-03-23 00:00
---

Web applicaions have become increasingly complex. And with complexity comes vulnerabilities. Web applicaions are a huge target at both the client and server side. Code injection can allow a threat actor to take over a web server and/or steal valuable information, and cross site scripting vulnerabilites can allow an attacker to execute code in client web brosers. Given all of this it has become vital for security professionals to have an understanding of web app security.

## OWASP and the OWASP Top 10 

The Open Web Application Security Project (OWASP) is a nonprofit organization that works to improve the security of web applications. OWASP maintains a list of the top 10 most prevalent web app vulnerabilites. This list can be found [here](https://owasp.org/Top10/). 

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
