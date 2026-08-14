---
title: "Mac Virtual Machine Installation Guide"
description: "Setting up UTM and Kali Linux on macOS, including Apple Silicon."
---

**MacBook M1, M2, M3 instructions are below.** Not sure which chip you have? Ask in [Discord]({{< param "discord" >}}) and we can help you check.

<ins>Step 1: Install software to run virtual machines</ins>

Apple Silicon has a different CPU architecture, so it needs different virtualization software to actually use your Mac's hardware. We use UTM (Universal Turing Machine). It's on the App Store, but that copy costs money — the link below gets you the same app for free, unless you'd like to support the developers directly.

Link: [mac.getutm.app](https://mac.getutm.app/)

<img src="/img/guides/UTM_Download_Image.webp" alt="UTM download" width="1400" height="750" loading="lazy">

Click the download link circled on their site, then install it like any other Mac app.

<ins>Step 2: Install Kali Linux</ins>

This is also a bit different from Windows, since you need the version of Kali built for Apple's M-series chips. Go to the same Kali site and click the "Installer Images" icon, circled below:

Link: [kali.org/get-kali/#kali-platforms](https://www.kali.org/get-kali/#kali-platforms)

<img src="/img/guides/Kali_Mac_Installer_Images.webp" alt="Kali installer images option" width="624" height="335" loading="lazy">

From there, select "Apple Silicon (ARM64)" to get the Mac-compatible build:

<img src="/img/guides/MAC_Apple_Silicon_Download_Image.webp" alt="Apple Silicon ARM64 option" width="624" height="259" loading="lazy">

Then click "Installer" to download Kali — around 3GB, so it'll take a bit.

<img src="/img/guides/Kali_MAC_Installer.webp" alt="Kali Mac installer download" width="624" height="270" loading="lazy">

Once it's installed, you're good to go! Questions any time — ask in [Discord]({{< param "discord" >}}).
