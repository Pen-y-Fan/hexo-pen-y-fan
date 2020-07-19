---
title: Running Docker on Windows 10 Home
date: 2020-07-02 15:37:42
tags: Docker
---

I have recently purchased a new laptop with Windows 10 home edition, after some research I found out that Docker will now run on Windows 10 home.

## Requirements

- Windows 10 build 19041 (AKA version 2004)
- Windows Subsystem for Windows 2 (WSL 2)
- Docker Desktop (19.03+)

## Upgrading Windows 10 Home

First verify the version of Windows 10. Press the `Windows` key and type `winver` or `system inforamtion`. Either will give the windows build. _**Windows 10 build 19041**_ (also known as SDK version 2004) is required.

To upgrade type `upgrade` and follow the upgrade instructions, or if there are any problems download the latest upgrade package <https://www.microsoft.com/en-gb/software-download/windows10> and choose **Upgrade now**

## Install WSL

For the full documentation see: <https://docs.microsoft.com/en-us/windows/wsl/install-win10>

### TD&DR; Install

From a PowerShell terminal:

```shell script
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2
```

## WSL 2 Kernel

Next install the WSL 2 Kernel, which can be download from here: <https://docs.microsoft.com/en-us/windows/wsl/wsl2-kernel>

## Install Docker

Download and install Docker for desktop from <https://hub.docker.com/editions/community/docker-ce-desktop-windows/>

Ignore the text that it ***requires Microsoft Windows 10 Professional or Enterprise 64-bit. For previous versions get Docker Toolbox***. This documentation is incorrect, Docker **is** now compatible with Windows 10 home with WSL 2.

## Confirm Docker Installation

To check the default distributions of WSL, with their state and version:

From a PowerShell terminal:

```shell script
wsl --list --verbose
```

The output should look similar to this:

| NAME                    | STATE           | VERSION |
|----                     |-----            |----     |
|  docker-desktop-data    | Running         | 2       |
|  docker-desktop         | Running         | 2       |

If they are not running: Press the `Windows` key and type **Docker** and select Docker Desktop, wait a few seconds for it to start. There will be an icon in the bottom right, as well as notifications.

The current version of Docker can be verified:

From a PowerShell terminal:

```shell script
docker --version
```

The version will be displayed, which should be the same or greater than:

```text
Docker version 19.03.1,....
```

Docker commands can be run as required. Enjoy!