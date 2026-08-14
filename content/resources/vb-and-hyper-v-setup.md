---
title: "VirtualBox and Hyper-V Virtual Machine Setup"
description: "Setting up Kali on VirtualBox, plus optional Hyper-V setup on Windows."
---

## VirtualBox VM setup on Windows

Most Windows systems now have enough resources to run both a hypervisor and a VM. The main constraint is disk space — make sure you have room for the OS image plus extra storage. If you plan on running intensive services inside the VM, you'll also want to bump up the RAM and CPU cores it's allowed to use. Questions any time — ask in [Discord]({{< param "discord" >}}).

### Download and extract the software

- VirtualBox: [virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
- 7-Zip: [7-zip.org](https://7-zip.org/)
- Kali: [kali-linux-2024.3-virtualbox-amd64.7z](https://cdimage.kali.org/kali-2024.3/kali-linux-2024.3-virtualbox-amd64.7z)
- Kali for Hyper-V (optional): [kali-linux-2024.3-hyperv-amd64.7z](https://cdimage.kali.org/kali-2024.3/kali-linux-2024.3-hyperv-amd64.7z)

Not sure what to do with these files? See the [Windows installation guide](/resources/windows-installation-guide/) or ask in Discord.

### Kali setup on VirtualBox

#### Step 1: Add the Kali VM

Open VirtualBox and click "Add."

<img src="/img/guides/vb-hyper-v/VB_Add_VM.webp" alt="VirtualBox add button" width="544" height="414" loading="lazy">

#### Step 2: Select the Kali folder

Navigate to the extracted Kali folder, select the `.vbox` file, and click "Open."

<img src="/img/guides/vb-hyper-v/VB_Kali_File_Explorer.webp" alt="VirtualBox Kali file explorer" width="559" height="350" loading="lazy">

#### Step 3: Launch the machine

Double-click the new Kali machine.

<img src="/img/guides/vb-hyper-v/VB_Kali.webp" alt="Kali VM in VirtualBox" width="562" height="400" loading="lazy">

#### Step 4: Sign in

Wait for Kali to boot. Username and password are both `kali`.

<img src="/img/guides/vb-hyper-v/VM_Kali_Signin.webp" alt="Kali sign-in screen" width="462" height="322" loading="lazy">

Your Kali VM on VirtualBox is all set.

## Hyper-V VM setup on Windows

This part is optional — VirtualBox or VMware both work fine on their own. Hyper-V isn't an officially supported feature on Windows 10/11 Home, though it can still be enabled. Setup here can get a little involved, so ask in Discord if you get stuck. Enabling Hyper-V on an edition that doesn't officially support it may also brush up against the EULA, worth knowing going in.

Hyper-V is also picky about resources — it may not work well on systems with less than 8GB of RAM.

Reference links:

- [gist.github.com/HimDek](https://gist.github.com/HimDek/6edde284203a620745fad3f762be603b)
- [Microsoft: Enabling Hyper-V on Windows 11](https://techcommunity.microsoft.com/t5/educator-developer-blog/step-by-step-enabling-hyper-v-for-use-on-windows-11/ba-p/3745905)
- [Kali docs: Install Hyper-V guest VM](https://www.kali.org/docs/virtualization/install-hyper-v-guest-vm/)

### Step 1: Check compatibility

1. Press Windows key + R, type `msinfo32`, press Enter.
2. In "System Summary," scroll down to "Hyper-V Requirements."
3. If it says "Yes," or "A hypervisor has been detected. Features required for Hyper-V will not be displayed," you're set.

<img src="/img/guides/vb-hyper-v/Sys_Info.webp" alt="System info Hyper-V requirements" width="627" height="292" loading="lazy">

### Step 1.5: Windows 10/11 Pro or above — enabling Hyper-V

1. Press Windows key + R, enter `appwiz.cpl`.
2. Click "Turn Windows features on or off."
3. Check "Hyper-V," click OK, let it install, then restart.

<img src="/img/guides/vb-hyper-v/Windows_Features.webp" alt="Windows features dialog" width="370" height="329" loading="lazy">

### Step 2: Enabling Hyper-V on Windows 10/11 Home

The slightly more involved path:

1. Right-click the desktop → New → Text Document.
2. Paste this into it:

```bat
pushd "%~dp0"
dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hyper-v.txt
for /f %%i in ('findstr /i . hyper-v.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
del hyper-v.txt
Dism /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL
Pause
```

3. File → Save As → rename to `Hyper-V.bat` → Save.
4. Double-click `Hyper-V.bat` to run it (right-click → Run as administrator if needed).
5. When install finishes, restart when prompted.
6. Press Windows key + R, enter `appwiz.cpl`.
7. Click "Turn Windows features on or off."
8. Check Hyper-V, Virtual Machine Platform, and Windows Hypervisor Platform, then click OK.
9. Restart.

### Step 3: Kali on Hyper-V

1. Click "Quick Create."

<img src="/img/guides/vb-hyper-v/Hyper-V.webp" alt="Hyper-V quick create" width="407" height="309" loading="lazy">

2. Click "Local Installation Source."

<img src="/img/guides/vb-hyper-v/Hyper-V_Create_VM.webp" alt="Hyper-V VM creation" width="460" height="327" loading="lazy">

3. Deselect "This virtual machine will run Windows."
4. Click "Change installation source" and navigate to your extracted Kali `.vhdx` file.
5. Rename the virtual machine if you want.
6. Click "Create Virtual Machine."
7. Once it's fully loaded, username and password are both `kali`.

You've set up a Kali VM on Hyper-V.
