<h1 align="center">
  <br>
  <img src="https://i.alexg0d.site/cvP1j.png" alt="cf-auto-uam">
  <br>
</h1>

<p align="center">🔁 A simple bash script to automatically enable CF UAM when CPU load is high</p>

<p align="center">
  <a href="#presentation">Presentation</a> •
  <a href="#installation">Installation</a> •
  <a href="#requirements">Requirements</a> •
  <a href="#license">License</a>
</p>

## Presentation
CF-Auto-UAM is a simple bash script coming along with an automatic installer which will install everything for you.

CF-Auto-UAM installs two cronjobs :
- A cronjob which checks every 15 seconds for the CPU load and if it's higher than 10 it will enable CloudFlare Under Attack Mode.
- A cronjob which checks every 10-30 minutes for the CPU load and if it's lower than 10 it will disable CloudFlare Under Attack Mode.

## Installation
> git clone https://github.com/AlexxSST/cf-auto-uam.git

> cd cf-auto-uam

> chmod 777 cf-auto-uam-install.sh

> bash cf-auto-uam-install.sh

The installer will be asking for 3 things :

- Your CloudFlare email
- Your CloudFlare API key
- Your domain CloudFlare zone ID

The installer has been tested on Ubuntu 16.04, Debian 8, CentOS 7.
If the installer doesn't work on other versions of those GNU please open an issue.

## Requirements

- [x] Root Access
- [x] Linux (Ubuntu/Debian/CentOS)
- [x] CloudFlare Account

## License

MIT
