---
title: Write up for our Meeting on 9/9
date: 2020-09-07 12:23
---

# Meeting for 9/9/2020

* Virtualization and Bash lead by Patrick McCabe
* Docker Containerization lead by Matt Walter

## Introduction to Virtualization

### What is required?

1. A computer
2. Internet connection
3. Patience (Depending on the OS, current packages will be downloaded during the install)

### What is Virtualization?

Virtualization is a way to run other **Operating Systems** (OS) on top of your host's (computer's) operating system. The way we virtualize an OS is through the use of a **hypervisor**. There are two types of hypervisors. They are the following:

 Type  | Description 
 :---: | :---------: 
 1     | "Bare Metal" would be set up on a server (ex: home penetration testing lab) 
 2     | Requires an OS (Windows, MacOS, Linux, etc.), this is the type that we will be setting up in today's meeting 

### How do we set up the Virtualization?

We will cover this in the meeting but the slide deck for today which can be located [here](https://github.com/cofccybersecurityclub/Presentations/blob/master/Workshop_01.pptx). Please also take a look at the [Resources tab](https://cofccybersecurityclub.github.io/resources/) under the Linux Distros for other OS's that we recommend for Cyber Security! (There are also pre-built virtual machines for other purposes)



### What is Bash?

Bash is shorthand for **Bourne Again Shell** and is one of many **command line interfaces** (CLI) that exist in the Linux environment. Bash is one of the more common CLIs across Linux, so we will Some other common CLIs are:

* Friendly Interactive Shell (fish)
* Shell (sh)
* Z Shell (zsh) 
* TMux (multi-shell interface)
* Screen (multi-shell interface)
* Powershell? (Yes! There is a Powershell interface on Linux)

### How do we use Bash?

We use Bash through a terminal emulator (For Parrot, it will be the Mate Terminal with a **>_** as inside a circle for the icon and for Kali it will be Terminal Emulator with a **\$\_** in a rectangle for the icon). Once we have that opened, we can begin to learn Bash!

Some common (and useful) commands are:

1. `pwd` which will print the current working directory (think of a directory as a folder) as the file path
2. `mkdir [directory]` creates a directory (folder) for the current directory 
3. `ls` which lists the files and directories (All that are **unhidden**) Some common options (denoted by **-**) are
* -a: all files (including hidden)
* -l: long form with permissions, links, owner, group, size (in bytes), date modified, time modified, and name of the file or directory
* -t: sort by modification time
* -h: human readable format for the file size
4. `touch [file.extension]` creates a file with the specified extension. Some extensions are:
* .txt: for a plaintext file
* .doc or .docx: document
* .log: for a log file
* .conf: for configuration files
5. `nano [file name]` this will open the **text editor** nano *Side Note: you can create the file without using touch first*
6. `echo "some text"` prints out some text to the terminal
* `echo "some text" > test.txt`: this will redirect some text into test.txt and **overwrites** it to test.txt
* `echo "some text" >> test.txt`: this will redirect some text into test.txt and **appends** it to test.txt
7. `cat test.txt` this will concatenate the file and print it to the terminal
8. `less test.txt` this is another way to view a file and will allow scrolling up and down with the arrow keys *Side note: the previous version of* `less` *was* `more` *and the Linux people decided to have fun with the name of the new version*
9. `grep "some text" test.txt` grep will be used to pattern match (or search for the specified term) in test.txt *Side note: grep is a very powerful tool that will be useful for log analysis for computer forensics and data analytics with data sets* Some common options for grep are:
* -c: returns the count of "some text" in test.txt
* -E: for regular expressions (REGEX) (info on them can be found [here](https://www.regular-expressions.info/))
* -h: for no file name
* -i: for ignore case
* -l: for files matching the pattern
* -n: for line number where the search matches
10. Piping: take the output of one command and sending it to another command (denoted by **|**)
* Why is this useful? We'll use cat, sort, and uniq as examples: `cat test.txt | sort | uniq` this will concatenate test.txt, send the output to sort (which sorts alphabetically), and then pipes the output to uniq which returns the uniq strings in the file 
11. `wc test.txt` prints the word count of test.txt Some helpful options are:
* -c: prints the number of characters
* -l: prints the number of lines
* -w number of words
12. `cp test.txt ~/Desktop/` copies test.txt to the Desktop directory and will leave a copy in the current directory. A helpful option for copying files with `cp` is the **-r** option for recursive copy, which is used for directories *Side note: `~` is short hand for /home/\$USER, with $USER being the signed in user*
13. `mv test.txt ~/Desktop/` this will move test.txt to ~/Desktop/ and will not leave a copy behind
14. `rm test.txt` this will delete test.txt. To delete directories, you may need to use the following `rm -r [directory]` (to recursively delete) or `rm -rf [directory]` to forcefully delete the directory
15. `sudo useradd [username]` this command will create a new user *Side note: sudo invokes **root** privileges to run a command that a normal user cannot run* Some common options are: 
* -m: for a home directory
* -c "some text": for comments
* -s [shell name]: determines what the login shell is for the new user
16. `sudo passwd [user]` this will add a password for any user
17. `su [user]` this will switch the current user in the terminal (can be left by typing `exit` into the terminal)
18. `sudo usermod -aG [group] [user]` this will assign the user specified to the group that is specified
19. `chmod` is a crucial command that can be used to change file permissions

Example: -rwxr--r-- (the first - is whether or not the file is a directory or an individual file)

Group | Abbreviation |Placement | Meaning
:---: | :-----------:|:-------: | :-----:
User  | u |first three slots after the  first - | this is the group for the file's owner and the permissions will be described below
Group | g |the next three slots after the user | this will set the permissions for the group that the user is a part of  
Other | o |last three slots after the group | This will be the permissions for all the other users on the system

*Side note: there is a special character for all and it is denoted by **a***

Option | Numerical Equivalent | Meaning
:----: | :------------------: | :-----:
+r | 4 | the file can be read through the specified group
+w | 2 | the file can be written to by the specified group
+x | 1 | the file can be executed (run) by the specified group

*Side note: these permission numbers can be added up to add multiple permissions at once*

To change the permissions, we can do this two different ways:
* We can use `chmod [group]+[permission(s)]` or in other words, to add executable status to both the group and other by using `chmog go+x test.txt` 
* The other way to accomplis this is `chmod [number][number][number] test.txt` and we will use the following: `chmod 755 test.txt`. The way that we determined the permission numbers is the following: 4 (read) + 2 (write) + 1 (execute) = 7 (for the user) and 4 (for read) + 1 (execute) = 5 for both the group and other user permissions
20. `ip a` this will list out the current network interfaces and **IP** address for the machine (on Eth0 for Ethernet). Here is a little shortcut to get your IP and subnet (we will go over what a subnet is on Sept. 30)
* `ip addr show | grep eth0 | grep inet | awk '{print $2}'`
21. `man [command]` man is short for manual and will be your best friend for learning the options for specific commands and unlocking their full potential
22. `apt` is the packacge (software) manager for Debian based systems (Ubuntu, Kali, Parrot, etc.) *Side note: most apt commands need root privilege to run so make sure to run the commands*. Some common commands are:
* `sudo apt update`: update the packacge repositories for the system
* `sudo apt full-upgrade`: upgrade all the packages on your system
* `sudo apt autoremove`: cleans up unecessary packages
* `sudo apt update && sudo apt full-upgrade`: the **&&** will run the first command and then the second command once it has finished 


## Docker and Containerization

_Howdy, welcome to the docker/containerization portion of this meeting._

#### what exactly is *Containerization*?

```
Containerization involves bundling an application together with all of its related configuration files, libraries and dependencies required for it to run in an efficient and bug-free way across different computing environments.
```

#### Well, then what is *Docker*?

```
Docker is an open-source project that automates the deployment of software applications inside containers by providing an additional layer of abstraction and automation of OS-level virtualization on Linux.
```


## GETTING STARTED

### Installing docker: 
https://docs.docker.com/get-docker/   

### Debian based Linux (Kali):
1. First, as always, update APT: 
    *  `sudo apt update`
2. Then we need to add the official Docker PGP key like so:
    * `curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -`
3. Next, we configure APT so we will be able to download, install and update Docker.
    * `echo 'deb [arch=amd64] https://download.docker.com/linux/debian buster stable' | sudo tee /etc/apt/sources.list.d/docker.list`

4. After adding Docker to APT, we need to update apt once more so we will be able to install Docker on Kali Linux:
    * `sudo apt update`

5. In case you have any old and/or outdated versions of Docker installed on your system, we make sure to get rid of them first:
    * `sudo apt remove docker docker-engine docker.io`
6. Once this is done, we are ready to install Docker on Kali Linux:
    * `sudo apt install docker-ce -y`
7. Finally, starting Docker:
    * `sudo systemctl start docker` 
8. *Optional* – Starting Docker automatically after a reboot. Do this at your own risk. I do not recommend doing this if you don’t know what you’re doing. I usually only start Docker when I actually need to use it.
    * `sudo systemctl enable docker`

### MacOS: 
```
sidebar: I am a mac person and when it comes to using docker in any form of professional setting I use docker desktop with the VScode docker plugin to manage all of my containers and images. 
```

That being said, 
* https://docs.docker.com/docker-for-mac/install/

### Windows: 
```
sidebar: Almost the opposite of MacOS, I never use docker on a Windows machine (although you for sure can). Is it worse than a UNIX based machine? yeah, probably, but don't let that stop you, learn the way you can. 
```

That being said, I assume people use Docker Desktop on Windows, but idk,
* https://docs.docker.com/docker-for-windows/install/ 


## Activity: 
### 1. Run,
* `docker run hello-world`

The expected output is very insightful for how the docker work flow functions: 
```
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
 ```


### 2. Next, try running an Ubuntu container 
* `docker run -it ubuntu bash` 

breaking down that command:
* docker --> the CLI command
* run -it ubuntu ---> run container "ubuntu" with -it to use interactive mode 
* bash ---> the program that gets run 


## 3. If you want more practice follow this guide. 
 https://docker-curriculum.com/

### Docker CLI 
* `docker ps` --> The docker ps command shows you all containers that are currently running.
* `docker images` --> To see the list of images that are available locally
* `docker run` --> To run a Docker container based on this image.
* `docker rm` + (container ID, found in docker ps) --> removes the container 

Useful options: 
* `docker ps -a` --> will list the status of recent containers
* `docker run -it` --> runs the container in interactive mode, so you can input more than one command. 
* etc... read the man pages 

# Docker Terminology 
* Image 
* Container 
* Dockerhub 