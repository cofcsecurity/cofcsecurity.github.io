---
title: "Mac Virtual Machine Installation Guide"
description: "Setting up UTM and Kali Linux on macOS, including Apple Silicon."
---

**MacBook M1, M2, M3 instructions are below.** Not sure which chip you have? Ask in [Discord]({{< param "discord" >}}) and we can help you check.

<ins>Step 1: Install software to run virtual machines</ins>

Apple Silicon has a different CPU architecture, so it needs different virtualization software to actually use your Mac's hardware. We use UTM (Universal Turing Machine). It's on the App Store, but that copy costs money — the link below gets you the same app for free, unless you'd like to support the developers directly.

Link: [mac.getutm.app](https://mac.getutm.app/)

![UTM download](/img/guides/UTM_Download_Image.png)

Click the download link circled on their site, then install it like any other Mac app.

<ins>Step 2: Install Kali Linux</ins>

This is also a bit different from Windows, since you need the version of Kali built for Apple's M-series chips. Go to the same Kali site and click the "Installer Images" icon, circled below:

Link: [kali.org/get-kali/#kali-platforms](https://www.kali.org/get-kali/#kali-platforms)

![Kali installer images option](/img/guides/Kali_Mac_Installer_Images.jpg)

From there, select "Apple Silicon (ARM64)" to get the Mac-compatible build:

![Apple Silicon ARM64 option](/img/guides/MAC_Apple_Silicon_Download_Image.jpg)

Then click "Installer" to download Kali — around 3GB, so it'll take a bit.

![Kali Mac installer download](/img/guides/Kali_MAC_Installer.jpg)

Once it's installed, you're good to go! Questions any time — ask in [Discord]({{< param "discord" >}}).
