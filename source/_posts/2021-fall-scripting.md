---
title: Ansible
date: 2021-08-02
---

# Bash and Python Scripting

## Bourne Again Shell (Bash)

### The Basics

- Shabang: #!/bin/bash
- How to run bash scripts:
- Make sure the file is executable:
    * `ls -alth` and check for an x flag
- If it isn’t executable:
    * `chmod +x <filename.sh>` 
    * `chmod 777 <filename.sh>`
- `bash <filename.sh>`
- `./<filename.sh>`

### Variables

#### Conventions:

- UPPERCASE= value/string/output from a command
- Example: `NAME=“Your Name”`
- Variabe usage: 
```
echo “My name is $NAME”
echo “My name is ${NAME}, hello”
```

#### Reading User Input:

```
# !/bin/bash
#Read user data
echo "Please enter your full name: "
read FIRSTNAME LASTNAME	
echo "Your name is $FIRSTNAME $LASTNAME"
```
#### Positional Parameters:

```
#!/bin/bash
#positional parameters
echo "Execution of script $0"
echo "Enter the name of the user: $1"
#add user
adduser --home /$1 $1
```

### Menus:

```
#!/bin/bash
#menus
echo "Welcome to Bob's Burgers"
echo "Please choose what you want to eat: "
meals="Burger Fries"
select option in $meals; do
	echo "The selected option is $REPLY"
	echo "The selected meal is $option"
done
```

### Conditionals:

```
#!/bin/bash
#if/if-else
NAME="Patrick"
if [ "$NAME" = "Patrick" ];
then
	echo "Welcome $NAME"
fi
echo "Enter username: "
read USERNAME
if [ "$USERNAME" = "Patrick" ];
then
	echo "Welcome $USERNAME"
else
	echo "Invalid username please register an account"
fi
```

### Loops: 

```
#!/bin/bash
#for loops
for NAMES in $(cat names.txt); do
	echo "The name is $NAMES"
done
```

### Functions:

```
#!/bin/bash
#functions
function shadowtest(){
	if [ -e /etc/shadow ];
	then
		echo "yes it exists"
	else
		echo "Nope"
	fi
}
function testpwd(){
	if [ -e /etc/passwd ];
	then
		echo "yes it exists"
	else
		echo "Nope"
	fi
}
shadowtest
testpwd
```

### Having some fun with Bash:

#### Manual `ping` Sweeper:

```
#!/bin/bash
#ping sweep script
echo "Please enter your subnet: "
read SUBNET
for IP in $(seq 1 254); do 
	ping -c 1 $SUBNET.$IP
done
```

#### Password Generator with the `SSL` Library

```
#!/bin/bash
#simple password generator
echo "Enter the length of the password: "
read LENGTH 
for P in $(seq 1); 
do
	openssl rand -base64 48 | cut  -c1-$LENGTH
done
```

#### File Encryptor/Decryotor:

```
#!/bin/bash
#file encrypter/decrypter
echo "This is a simple file encrypter/decrypter"
echo "Please choose what you want to do"
choice="Encrypt Decrypt"
select option in $choice; do
	if [ $REPLY = 1 ];
	then
		echo "You have selected encryption"
		echo "Please enter the file name"
		read file;
		gpg -c $file
		echo "The file has been encrypted"

    else
            echo "You have selected decryption"
            echo "Please enter the file name"
            read file2;
            gpg -d $file2
            echo "The file has been decrypted"
        fi
    done
```

#### DNS Reverse Lookup:

```
#!/bin/bash
echo "Please enter your subnet: "
read SUBNET
for IP in $(seq 1 254); do
	dig -x $SUBNET.$ip | grep $IP >> dns.txt;
done
```

## Python Scripting

### Basics:

- If running via command line shabang: #!/bin/python
    * IDEs: 
        - IDLE: https://www.python.org/downloads/
        - Pycharm: https://www.jetbrains.com/pycharm/

### Variables:

#### Declaration:

```
Single value: test = 5
Array: test = [1, dog, 2.5]
```

#### Reading User Input:

```
userInput = input(“Enter a number here: ”)
print(“Your number is: ” + str(userInput))
```

### Conditionals:
```
if test == true:
   print("It's true!")
elif test == false:
   print("Its false!")
else:
   print("Something is wrong")
```

### Loops:

#### For loop:

```
for i in range(0, 5, 1):
 print(i) 
for item in arr:
	print(item)
```

#### While loop:

```
i = 0
while i < 5:
	print(i)
	i = i + 1
```

### Functions:

```
def firstFun(x, y):
	return x + y


def main():
	variable = firstFun(5, 10)
	print(‘Variable = ’ + str(variable))
main()
```

### The Cool Stuff:

#### Manual Port Scanner

```
#!/usr/bin/python3
import socket
host = input("Enter the host: ")
maxport = int(input("Enter the max port to scan: "))
def portScanner():
   for port in range(1, maxport + 1):
       s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
       s.settimeout(10)
       result = s.connect_ex((host, port))
       if result == 0:
           print("Port " + str(port) + " is open")
       s.close()
portScanner()
```

#### OS Library:

```
import os
def main():
    print(os.getcwd())
    # os.chdir("/Users/patrickmccabe/Desktop/")
    # print(os.listdir())
    # os.rmdir("Test1")
    """for dirpath, dirnames, filenames in os.walk("/Users/patrickmccabe/Desktop/"):
        print("Current path:", dirpath)
        print("Directories:", dirnames)
        print("Files:", filenames)
        print()"""
    # print("Home: ", os.environ.get('HOME'))
    # os.path.join(os.environ.get('HOME'), "test.txt")
    print(os.path.basename('/usr/share'))
    print(os.path.dirname('/usr/share'))
    print(os.path.split('/usr/share'))
    print(os.path.exists('/usr/share'))
    print(os.path.isdir('/usr/share'))
    print(os.path.isfile('/usr/share'))
    print(os.path.splitext('/usr/share'))
main()
```

#### Some [Scapy](https://scapy.readthedocs.io/en/latest/) Fun (Please, please be careful with this and only use it in an environment with permission):

```
IP Spoof: send(IP(src=“<attacker IP>”, dst=“<target IP>”)/ICMP()/“Hello world”)
Network Sniffing: sniff(iface=“<interface>”, prn=lambda x:x.summary)
BE CAREFUL WITH THIS NEXT ONE
DOS Attack: send(IP(src=“attacker IP”, dst=“<target>”)/TCP(sport=444, dport=444), count=10000)
```