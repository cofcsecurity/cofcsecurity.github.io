---
title: Information Gathering
date: 2021-08-05
---

# Information Gathering

## Google Dorks

![Google Dorks](https://github.com/cofcsecurity/cofcsecurity.github.io/blob/master/source/_posts/images/google.png?raw=true)

- Answer: The best way to refine Google & database searches for OSINT (& schoolwork)!
- [Cheatsheet](https://www.sans.org/posters/google-hacking-and-defense-cheat-sheet/)
- Common Vulnerabilities and Exposures ([CVEs](https://cve.mitre.org))
- Practice:
    1. What is the CVE of the original POODLE attack?
    2. What version of VSFTPD contained the smiley face backdoor?
    3. What was the first 1.0.1 version of OpenSSL that was NOT vulnerable to heartbleed?
    4. What was the original RFC number that described Telnet?
    5. How large (in bytes) was the SQL Slammer worm?
    6. Samy is my…
- [Answers](https://github.com/cofcsecurity/Presentations/blob/master/Answers/osint.md)

## Network Recon

- Grab your current IP and Subnet: `ip addr show | grep <network interface> | grep inet | awk '{print $2}'` 

### nmap:

- [Documentation](https://nmap.org/book/man.html)
- Usage: `nmap -<options> <ip/subnet or address>`
- Common Options:
    - `-sn` - ping scan (essentially is ping 8.8.8.8 via CLI)
    - `-sS` - SYN or Normal scan
    - `-sU` - UDP scan
    - `-p<start num-end num>`
        - Default is 1-1024
        - Max port = 65535
    - `-sV` - list all the services (+ version) running on the target
    - `-O` - OS detection
    - `-Pn` - treat all hosts as up up
    - `-A` - runs nmap scripts, -O, -sV, & traceroute

### Other Useful Tools:

- `ping <options> <ip address or hostname>`
- `traceroute <ip or address>` - shows all the hops from your machine to the ip/address
- `netdiscover -i <interface/subnet>`

### DNS Recon:

![DNS](https://github.com/cofcsecurity/cofcsecurity.github.io/blob/master/source/_posts/images/dns-query.png?raw=true)

- DNS = Domain Name Servers 
- Common DNS’s:
    - Google- 8.8.8.8 (8.8.4.4)
    - Cloudflare- 1.1.1.1 (1.0.0.1)
- Why are they important? - They hold the records for websites and they are the key player for navigating to websites
- Why they are good: they make navigating to websites way easier
- Cons: if you take out a DNS, you effectively cut off access to that part of the internet
    - ex: the Cloudflare DOS (July 2019)*

### Getting DNS Info

#### `nslookup` and `host`

- [Test Domain](https://zonetransfer.me)
- host <hostname> (or the ip)
- host -t <record type> <hostname>
- host -l <hostname> <DNS nameserver>

```
nslookup 
    set type= <record type> 
    <hostname>
```

- Record types:
    - mx = email (mail exchange)
    - a = address
    - aaaa = IPV6 address
    - ns = name server (aka who is their DNS)

#### `dig`

- `dig <hostname>`
- `dig <hostname> -t [record type]`
- `dig <hostname> [record name]`
- `dig <hostname> -t [record type] +short`
- `dig axfr <hostname> @[name server]`

### Automated Information Gathering: Maltego



- Short answer- Tool for automating information gather
- Long answer- this tool uses transforms, or modules, in order to search a specific target for reconnaissance within scope
- CE is free with a bunch of good transforms from Shodan, DNSDB, and others
- Test sites: www.000webhostapp.com or zonetransfer.me
**I am not responsible for what you do with this tool after you gather the information**

[@pmccabe5](https://github.com/pmccabe5)  

