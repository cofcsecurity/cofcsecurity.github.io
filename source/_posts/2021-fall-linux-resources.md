---
title: Linux Knowledge
date: 2021-12-14 00:00
---

## Overview

This post will provide a high level overview of important things to know about securing and adminstrating Linux systems.

## Command Line

Knowing how to use the command line is essential, Linux servers usually do not have desktop environments - and even if they do many administrative tasks are not possible to do via GUI.

### Bash

The default shell in many Linux systems. Check out this guide: https://guide.bash.academy/commands/

### Secure Shell (SSH)

Know how to connect into other computers via the command line using SSH as well as how to create and use SSH keys.

* SSH Command: https://www.ssh.com/academy/ssh/command

* SSH Keys: https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-2

### tmux

tmux is a terminal multiplexer that allows you to access multiple terminal sessions in a single window.

* https://www.howtogeek.com/671422/how-to-use-tmux-on-linux-and-why-its-better-than-screen/

## Logging

Know where important logs are and how to read them.

### Important Logs

* /var/log
  * /var/log/syslog
  * /var/log/auth.log

Service logs (ie nginx, Apache, named, etc) are also very important. Usually these logs are also in /var/log, but not always.

### Auditd

A component of the Linux Auditing System. Allows the creation of rules to log certain events (ie program execution, file modifications, etc).

* https://www.redhat.com/sysadmin/configure-linux-auditing-auditd


## Users, Groups, and Permissions

Know how to create, manage, and delete users. (ie add to group, update password, etc).

Users and Groups: https://www.redhat.com/sysadmin/linux-user-group-management

Understand how to view and modify file premissions:

Permissions: https://www.redhat.com/sysadmin/manage-permissions

Understand superusers, the sudo command, and the sudoers file:

Sudo: https://www.geeksforgeeks.org/sudo-command-in-linux-with-examples/

Sudoers: https://www.linux.com/training-tutorials/configuring-linux-sudoers-file/

## Firewall

Know how to enumerate your network services and reduce attack service.

### netstat

A command to examine a Linux system's network connections and sockets.

Syntax:

`netstat [options]`

Examples:

* `netstat -tulnp`

Show the **l**istening **T**CP and **U***DP sockets and which **p**rograms created them.

* `netstat -pan`

Show **a**ll connections and sockets.

Further reading:

* https://linux.die.net/man/8/netstat
* https://www.geeksforgeeks.org/netstat-command-linux/

### Uncomplicated Firewal (UFW)

Uncomplicates iptables (the most common low level Linux firewall tool) and allows for the easy creation of firewall rules.

* https://help.ubuntu.com/community/UFW

## Service Management

Know how to view and manage Systemd services using systemctl.

https://www.howtogeek.com/216454/how-to-manage-systemd-services-on-a-linux-system/

## Processes

Know how to view and stop running processes.

### ps

The ps command allows you to view information about the processes running on the system.

https://www.geeksforgeeks.org/ps-command-in-linux-with-examples/

The following command allows you to stop a process:

kill [pid]

## Package Management

Know how to verify, install, and manage software via the command line.

### Debian Based Distros

apt is the default package manager for many Debian based Linux distros like Ubuntu. The following describes the basic features: 

1. apt update

Updates package lists and determines what needs to be updated.

2. apt upgrade [-y]

Download and apply upgrades to packages that have updates.

`-y` to automatically respond yes to most prompts.

3. apt install X

Install the package named X.

4. apt remove X

Remove the package named X.

Example: `apt install tmux`

Installs the package tmux.

dpkg is a another packaging tool for Debian based systems that works with apt. Most of the time you just need to interact with apt, but dpkg provides one key feature:

1. `dpkg --verify`

This verifies the integrity of all installed packages. This can alert you to programs that have been tampered with. 

See here on how to read the output: https://askubuntu.com/questions/792553/dpkg-v-what-does-the-output-mean

### RedHat Based Distros

Yum is the default package manager on many RedHat based distros including CentOS and Fedora. Like apt, yum has the update, upgrade, intall, and remove features.

And simillarly to `dpkg --verify` we have the following on RedHat:

1. rpm -Va

See here for details: https://docs.fedoraproject.org/en-US/Fedora_Draft_Documentation/0.1/html/RPM_Guide/ch04s04.html


## Scanning and Enumeration

In order to manage and defend a machine or network you must understand the environment and know the attack surface.

### [nmap](https://nmap.org/)

Know how to scan network services on hosts with nmap and learn how to interpret the results.

**Syntax:**

`nmap [options] [targets]`

**Examples:**

* `nmap -p22 scanme.org`

Scan port 22 on host scanme.org 

* `nmap -A 192.168.1.0/24`

Scan the range 192.168.1.0/24 and enable service version detection, OS detection, script scanning, and traceroute.

* `nmap -sU -p- 192.168.1.15 192.168.1.30`

Scan all UDP ports on hosts 192.168.1.15 and 192.168.1.30.

**Options to know:**

*  `-A`

Enables service version detection, OS detection, script scanning, and traceroute.

* Port specification: `-p`

`-p-` for all ports.

`-pX` to scan port X.

`-pX,Y,...` to scan a list of ports X, Y, ...

`-pX-Y` scan ports X through Y. Valid ports are 1-65535.

* UDP Scan: `-sU`

Scan UDP ports. The default scan type is `-sS` which is a TCP SYN scan.

### nikto

nikto is a website vulnerability scanner. Know how to use it to scan a webserver and learn how to interpret the results.

* https://securitytrails.com/blog/nikto-website-vulnerability-scanner
