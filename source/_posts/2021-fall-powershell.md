---
title: Powershell
date: 2021-08-05
---

# Powershell

**All files can be found [here](https://github.com/cofcsecurity/Presentations/tree/master/psResources)**



## Get Powershell

- What is powershell?: Microsoft’s answer to the Linux terminal, but more Object-Oriented (OOP) 
- Method 1:
    - [Windows VM](https://developer.microsoft.com/en-us/windows/downloads/virtual-machines) or Host OS
    - Method 2: 
        - Ubuntu VM or Mac with Powershell installed??? (aka PFM)
        - Uses Powershell core (and doesn’t need docker, just homebrew)

## Powershell Basics:

### Variables:

```
$var1 = 5
$var2 = “55”
```

### Operations:

#### Addition:

```
$var1 + $var2
$var2 + $var1
```

- Why are they different?

```
var ++
var += 5 
```

#### Equality:

```
-eq: equals
-ne: not equal to
-ceq: case sensitive comparison
-gt: greater than
-gte: greater than or equal to
-lt: less than 
-lte: less than or equal to
```

#### Booleans:

```
-and 
-or
```

### Conditionals:

```
If (<condition>){
	<code/commands>
}
Else{
	<code/commands>
}
```

### Loops:

```
$question = "Are we there yet?"
$answer = "Noooooo!"
for ($i = 3; $i -gt 0; $i--){
    $question
    sleep 2
}
Write-Output "`n$answer"
**(`n) = new line, not \n like python/java/c

$services = get-service
ForEach ($thing in $services){
	$thing.name + " : " + $thing.status
}
Write-Output "`nThe last service is $($thing.name)" 
```

```
$food = 'Beans', 'Greens', 'Potatoes', 'Lamb', 'Rams', 'Hogs', 'Dogs'
for ($i = 5; $i -gt 0; $i--){
    foreach($item in $food){
        Write-Output "I got $item "
    }
}
Write-Output "`nYou name it!"
```

```
while ($true){
    test-connection 127.0.0.1
}
```

```
$rabbits = 2
Do{
    Write-output "We now have $rabbits rabbits!"
    $rabbits *= 2
}
While ($rabbits -lt 10000)
```

```
$i = 0
while($i -lt 999){
    $i++
    $i
}
Write-Host "`nCount complete - We have counted up to $i" -ForegroundColor Cyan
```
- **AKA the original for-loop or you can call the for-loop a wannabe while loop, either one works with me**

### Functions:

```
Function <name>{
	Function ($parameter){
	<Insert code here>
	}
	<Insert code here>
}
<name> -parameter 1
```

## The Cool Stuff

### TCP Listener

- Idea: we monitor someone’s computer and we get a notification when they open an application

```
function WMI_Subscription{

function server($port){
    $Tcplistener = New-object System.Net.Sockets.TcpListener $port
    $Tcplistener.Start()
    Write-host "[-] " -ForegroundColor green -NoNewline; Write-Host "Listening: 0.0.0.0:$port" -ForegroundColor cyan
    $TcpClient = $Tcplistener.AcceptTcpClient()
    $remoteclient = $TcpClient.Client.RemoteEndPoint.Address.IPAddressToString
    Write-Host "[-] " -ForegroundColor green -NoNewline; Write-Host "New connection: $remoteclient" -ForegroundColor Cyan

    $TcpNetworkstream = $TCPClient.GetStream()
    $Receivebuffer = New-Object Byte[] $TcpClient.ReceiveBufferSize
    $encodingtype = New-Object System.Text.ASCIIEncoding
    while ($TCPClient.Connected){
        $Read = $TcpNetworkstream.Read($Receivebuffer, 0, $Receivebuffer.Length)          
            [Array]$Bytesreceived += $Receivebuffer[0..($Read -1)]
            [Array]::Clear($Receivebuffer, 0, $Read)

            $ScriptBlock = [ScriptBlock]::Create($EncodingType.GetString($Bytesreceived))
            $ScriptBlock
            $TcpNetworkstream.Dispose(); $Tcpclient.Dispose(), $Tcplistener.Stop()
    }
}
server -port 6602

# Temp WMI... dies when the process terminates

Get-Process -Name notepad  -ErrorAction SilentlyContinue | Stop-Process

Register-CimIndicationEvent -Query "Select * from __InstanceCreationEvent within 15 where targetInstance isa 'win32_process' and (targetinstance.name = 'notepad.exe' OR targetinstance.name = 'wordpad.exe')" `
    -SourceIdentifier "trigger" -Action{Write-Output "$(get-date) - Temp WMI Register Executed Successfully" | Out-File $env:USERPROFILE\Desktop\logger.txt -Append}

Start-Process notepad
Get-Content "$env:USERPROFILE\Desktop\logger.txt"
Get-EventSubscriber
Unregister-Event -SourceIdentifier "trigger"

Register-CimIndicationEvent -Query "Select * from __instanceModificationEvent within 15 where targetInstance isa 'win32_Service'" `
    -SourceIdentifier "trigger2" -Action{Write-Output "$(get-date) - Temp WMI Register Executed Successfully" | Out-File $env:USERPROFILE\Desktop\logger2.txt -Append}

Restart-Service -Name BITS
Get-Content "$env:USERPROFILE\Desktop\logger2.txt"
Unregister-Event -SourceIdentifier "trigger2"

Register-WmiEvent -Query "Select * from __InstanceoperationEvent within 20 where targetinstance ISA 'win32_process' AND targetinstance.name='lsass.exe'" -SourceIdentifier "beacon" `
    -Action{
        $socket = new-object System.Net.Sockets.TcpClient("127.0.0.1", "6602")
        $data = [System.Text.Encoding]::ASCII.GetBytes("This is a test")
        $stream = $socket.GetStream()
        $stream.Write($data, 0, $data.Length)
    }

Unregister-Event -SourceIdentifier "beacon"


Get-WmiObject -Namespace root/cimv2 -Class win32_localtime

Register-WmiEvent -Query "Select * from __InstanceModificationEvent within 30 WHERE TargetInstance ISA 'Win32_LocalTime' AND targetinstance.hour = 20 AND targetinstance.minute = 42 group within 30" -SourceIdentifier "beacon2" `
    -Action{
        $socket = new-object System.Net.Sockets.TcpClient("127.0.0.1", "6602")
        $data = [System.Text.Encoding]::ASCII.GetBytes("This is a test")
        $stream = $socket.GetStream()
        $stream.Write($data, 0, $data.Length)
    }

Unregister-Event -SourceIdentifier "beacon2"

Get-Job
```
### Port Scanning

```
$ports = 1..100
$IP = "192.168.0.185"
$scan = foreach($port in $ports){
    try{
        $portStatus = new-object Net.Sockets.TcpClient($IP, $port)
        [pscustomobject]@{
            RemoteAddress = $IP
            RemotePort = $port
            TcpTestSucceeded =  $portStatus.connected
        }
       
        $portStatus.Close()
    }

    catch{
        [pscustomobject]@{
            RemoteAddress = $IP
            RemotePort = $port
            TcpTestSucceeded = 'False'
        }
    }
}

$scan
```

### Downgrading Powershell:

- Why would we do this??
- How to downgrade: 
```
if ($PSVersionTable.PSVersion -gt [Version]"2.0") { 
powershell -Version 2 -File $MyInvocation.MyCommand.Definition exit } 
'run some code' Read-Host -Prompt "Scripts Completed : Press any key to exit"
```

### Time Stomping:

- What is it?
- Why is it important?
- Why you shouldn’t do it to your professors :)

```
file = "$env:USERPROFILE\desktop\myfile.txt"
Get-Item $file | format-list *time
(Get-Item -path $file).LastWriteTimeutc = Get-Date
(Get-Item -path $file).LastWriteTime = (Get-Date).AddDays(-270)
(Get-Item -path $file).CreationTime = "8/8/2018 09:00:00 PM"
```

## The Duck...

<figure class="video_container">
  <iframe src="https://www.youtube.com/embed/IdWhkGD-ojM" frameborder="0" allowfullscreen="true"> </iframe>
</figure>

### General:

- What is it?
- Why should you know about it?
