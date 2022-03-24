---
title: Networks Introduction 
date: 2022-02-08 00:00
---

In order to properly learn network secuirty, an understanding of computer network design and protocols is necessay. This presentation was aimed at teaching simple networking basics to prepare club members to learn more on their own. For a complete introduction, please watch the meeting recording and download the slides to follow along. 


### Dynamic Host Configuration Protocol (DHCP) 

[RFC 2131](https://datatracker.ietf.org/doc/html/rfc2131)

On new connection to network, DHCP server delivers 3 important pieces information
1. Router IP Address 
2. Local DNS Server IP Address 
3. New Device's IP Address and Subnet 



### Domain Name Service (DNS) 

[RFC 883](https://datatracker.ietf.org/doc/html/rfc883)

How to get to 'Google.com'?
1. Send request to local DNS Server for ip of 'google.com'
2. Local DNS Server responds with ip of 'google.com'

What if ip address is not stored in the local DNS server? 
1. Send request to local DNS server for ip of 'weirdwebsite.com'
2. Local DNS server makes request to nameserver for ip of 'weirdwebsite.com' 
3. Nameserver responds to local DNS server with ip of 'weirdwebsite.com'
4. Local DNS server responds with ip of 'weirdwebsite.com'

### Address Resolution Protocol (ARP) 

[RFC 826](https://datatracker.ietf.org/doc/html/rfc826) 
[RFC 6747](https://datatracker.ietf.org/doc/html/rfc6747) 

"The purpose of this RFC [ARP] is to present a method of Converting
Protocol Addresses (e.g., IP addresses) to Local Network
Addresses (e.g., Ethernet addresses)" - RFC 826 

Essentially, ARP is used for devices to comunicate to other local devices. 

Steps
1. Device broadcasts "who is [ip address to communicate with]. This is [ip of this machine]" to every device on the local network. 
2. The device with ip that was searched relpies "Hello [ip of original machine]. I'm [ip of requested machine]" 
note: As seen in RFC 826, the packets used for ARP contain the ethernet address of the sending machine in the packet header. Because of this, no further communication is needed to convey ethernet addresses. 

