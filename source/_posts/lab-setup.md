---
title: Lab Setup
date: 2021-01-20 17:00
---

# COFC DevOPS: Setup

[Github Repository](https://github.com/cofcsecurity/DevOps)

## Recording

[Link](https://cofc.zoom.us/rec/share/d3kZDW1bzXeYes0SSBRzr_TXcHLv2QnBa4lET_XzZuR_MaFvI1hihlrW22u1ITXl.HgQ7SZ8cQQOzslGQ)

Passcode: 8pCtm$$Q

## Goals:

1. Set up 3 virtual machines
    - 1 Ubuntu (Command Machine)
    - 2 CentOS "webservers"
2. Set up an non-root user that is a part of the `wheel` group on our webservers

## Prerequisites:

1. [VirtualBox](https://www.virtualbox.org/)
2. ISOs:
    - [Ubuntu 20.04 Minimal](https://releases.ubuntu.com/20.04.1/ubuntu-20.04.1-live-server-amd64.iso?_ga=2.154606776.143673684.1605395134-1815728291.1605395134)
    - [Alternate Download](https://ubuntu.com/download/server)
    
## Configuration Steps:

1. Download Virtualbox
2. Download ISOs
3. We will want to have the following configurations for our three VMs:
    - 16 GB of storage per VM 
    - 1024 MB of RAM per VM
    - Network will be set to Host Only Adapter
4. We will set up the Ubuntu Server first and then the CentOS Servers
    * We will need to update our repositories and packages that are installed on the system with the following commands:
        - `sudo apt update`: update the software repositories
        - `sudo apt full-upgrade`: download and upgrade the software packages
    * Some notes for the Ubuntu Server:
        - We will need to check to see if the following packages are installed:
            - `git`
            - `ansible`
            - `net-tools`
            - `python`
            - `python3`
        - We will need to make sure we start the SSH service and enable it on startup: `sudo systemctl start ssh; sudo systemctl enable ssh`
        - We will need to create a non-root user for the VM:
            - Create user: `sudo useradd [username]` [for this lab we will use `devops` as the non-root user]
            - Set password for the user: `passwd devops`
            - Add the user to the `sudo` group: `sudo usermod -aG sudo devops`

## Book

[Linux Basics for Hackers](https://github.com/pmccabe5/python-tools-sec-guides/raw/master/Books/linuxbasicsforhackers.pdf)