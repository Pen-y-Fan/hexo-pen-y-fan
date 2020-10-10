---
title: Pop OS new install
date: 2020-10-05 20:14:38
tags: [Docker, Linux]
---

I wanted to test out Linux after I had purchased a new laptop which came with Windows 10 home. Although I was generally happy with my dev environment, I still wanted to try out Linux as a dev environment. I chose to try Pop OS as it was recommended by several people, especially on the PHPUgly and Syntax podcasts.

## Testing

I was able to download Pop OS ISO and install it to a bootable USB pen drive. I was able to boot the laptop and test things, for example, the Wi-Fi worked.

I purchased an additional hard drive connector as there was a spare compartment for a SSD drive. I already had an SSD drive from my previous laptop which I could use.

## Installation

After installing the SSD drive I was able to boot from the USB pen drive and noticed my Windows 10, M2 SSD driver, was not detected, only the newly fitted SSD drive. This meant I could safely install the Pop OS without damaging Windows 10.

The installation was relatively painless menu-driven install. One problem I noticed was on PC reboot the laptop automatically boots to Pop OS drive. To boot into the windows drive, I have to press escape after shutting down, the laptop and choosing the Windows boot manager.

I didn't time it exactly, but I would allow over an hour to install Pop OS and the upgrades.

## More testing

After installing Pop OS, I tested a few more things such as my Bluetooth headphones and dual screen monitor.

## Dev software

I wanted a flexible dev environment which included the following software, as a minimum:

- Google Chrome
- PhpStorm 
- Docker
- VS Code
- Git

### Google Chrome

Firefox is the default browser which comes with Pop OS. A quick search for “Google Chrome download”, leads directly to the download screen. Pop OS is a modified Ubuntu based Linux distribution, so selecting the x64 bit .deb (For Debian/Ubuntu) worked a treat. It downloaded and gave the option to open with the package manager, which installed it without any problem.

After installation, I could search for chrome by pressing the Windows key and typing chrome. It launched and gave the option to de the default browser, which I accepted. After signing in with my Google account all my bookmarks synced without any problem.

### PhpStorm

PhpStorm download:

- [jetbrains.com/phpstorm/download](https://www.jetbrains.com/phpstorm/download/#section=linux)

The PhpStorm install was more complicated, the file downloaded was **PhpStorm- 2020.2.2.tar.gz**

I opened the download folder, right clicked and unpacked, then selected the unpacked folder, cut it and created a Software folder in my home directory. Pasted in the folder. 

Navigating the folder I opened the installation instructions. 

1. Unpack the PhpStorm distribution archive that you downloaded where you wish to install the program. We will refer to this  location as your {installation home}.

2. To start the application, open a console, cd into "{installation home}/bin" and type:

./phpstorm.sh

This will initialize various configuration files in the configuration directory:

~/.config/JetBrains/PhpStorm2020.2.

3. [OPTIONAL] Add "{installation home}/bin" to your PATH environment variable so that you can start PhpStorm from any directory.

4. [OPTIONAL] To adjust the value of the JVM heap size, create a file phpstorm.vmoptions (or phpstorm64.vmoptions if using a 64-bit JDK) in the configuration directory and set the -Xms and -Xmx parameters. To see how to do this, you can reference the vmoptions file under "{installation home}/bin" as a model but do not modify it, add your options to the new file.

Step 1 was already complete, step 2 was next. I navigated to **~/Software/PhpStorm-2020.2.2/PhpStorm-202.7319.77/bin**, right-clicked a blank space and selected ***open with terminal***. Then typed: `./phpstorm.sh` 

I followed the installation wizard and within minutes PhpStorm installed.

### Docker

Next up was Docker, which was downloaded from:

- [docker.com/engine/install/ubuntu](https://docs.docker.com/engine/install/ubuntu/)

The installation was more involved, as the recommended method included adding a repository, the LT&DR; version:

Update the apt package index and install packages to allow apt to use a repository over HTTPS:

```sh
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
```

Add Docker’s official GPG key:

```sh
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

Verify that you now have the key with the fingerprint `9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88`, by searching for the last 8 characters of the fingerprint.

```sh
sudo apt-key fingerprint 0EBFCD88
```
Use the following command to set up the stable repository.

```sh
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

Update the apt package index, and install the latest version of Docker Engine and container, or go to the next step to install a specific version:


```sh
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

Got multiple Docker repositories?

- If you have multiple Docker repositories enabled, installing or updating without specifying a version in the apt-get install or apt-get update command always installs the highest possible version, which may not be appropriate for your stability needs.
- To install a specific version of Docker Engine, list the available versions in the repo, then select and install:

a. List the versions available in your repo:

```sh
apt-cache madison docker-ce
```

```text
 docker-ce | 5:19.03.13~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:19.03.12~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:19.03.11~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:19.03.10~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:19.03.9~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
```

b. Install a specific version using the version string from the second column, for example, 5:19.03.13~3-0~ubuntu-focal.

```sh
sudo apt-get install docker-ce=5:19.03.13~3-0~ubuntu-focal docker-ce-cli=5:19.03.13~3-0~ubuntu-focal containerd.io
```
 
```text
Building dependency tree       
Reading state information... Done
containerd.io is already the newest version (1.3.7-1).
docker-ce-cli is already the newest version (5:19.03.13~3-0~ubuntu-focal).
docker-ce is already the newest version (5:19.03.13~3-0~ubuntu-focal).
The following package was automatically installed and is no longer required:
  mousetweaks
Use 'sudo apt autoremove' to remove it.
0 to upgrade, 0 to newly install, 0 to remove and 0 not to upgrade. 
```
 
Verify that Docker Engine installed correctly, by running the hello-world image.

```sh
sudo docker run hello-world
```

```text
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
0e03bdcc26d7: Pull complete 
Digest: sha256:4cf9c47f86df71d48364001ede3a4fcd85ae80ce02ebad74156906caff5378bc
Status: Downloaded newer image for hello-world:latest

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

Install docker-compose

```sh
sudo apt  install docker-compose 
```

Test:

```sh
docker-compose --version
```

```text
docker-compose version 1.25.0, build unknown
```

Result! That install wasn't too painful, just some copying and pasting. Job done :)

### VS Code

A quick google for VS Code download found the right page:

- [code.visualstudio.com/download](https://code.visualstudio.com/download)

First I needed to install snap:

```sh
sudo apt update && sudo apt install snapd
```

Then vs code can be easily installed, via the snap store

- [snapcraft.io/code](https://snapcraft.io/code)

```sh
sudo snap install code --classic
```

### Git

- [git-scm.com/download/linux](https://git-scm.com/download/linux)

```sh
sudo apt install git
```

Test

```sh
git --version
```

```text
git version 2.25.1
```

That is it! My Linux dev environment setup and ready for me to run. 
