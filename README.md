# Installation steps
* Download and install `F-Droid` APK from https://f-droid.org/F-Droid.apk
* Open f-droid and Search for `Termux`
* install and open Termux app to your android using F-droid.
* Copy & run the whole command as below in your termux application

```
clear && 
pkg update && 
apt -q install git -y && 
rm -rf Pure-aarch64-XFCE4-Termux-VNC-Desktop &&
git clone https://github.com/RajDhinge/Pure-aarch64-XFCE4-Termux-VNC-Desktop.git && 
cd Pure-aarch64-XFCE4-Termux-VNC-Desktop && 
chmod +x setup.sh && 
bash setup.sh
cd .. &&
rm -rf Pure-aarch64-XFCE4-Termux-VNC-Desktop &&
cd ~
```
# Commands

1. `startservers` - starts nginx, mysql, phpfpm and vnc

# Pure-aarch64-XFCE4-Termux-VNC-Desktop

![xfce4](https://user-images.githubusercontent.com/22621881/141480063-3f9cf31e-814f-4a54-8996-fb67d322b324.png)

# Features out of the box

1. Auto configure `VNC` with password `1234567`
2. `WordPress` & wp-cli will be set out of the box uses `mysql` , `nginx server` and `php-fpm`
3. `adminer.php` file will be automatically placed in your `html` directory
4. Auto set-up essential packages
    `figlet`
    `fish`
    `tree`
    `openssh` 
    `nginx` 
    `php-fpm` 
    `mariadb` 
    `otter-browser`
    `netsurf`
    `x11-repo` 
    `xfce4` 
    `zsh` 
    `tigervnc` 
    `tsu` 
    `xfce4-terminal` 
    `dosbox` 
    `wget` 
    `lxqt-archiver` 
    `nmap` 
    `termux-api` 
    `htop` 
    `git` 
    `zip` 
    `ttyd`
    `php-imagick`
    `tumbler`
    `proot-distro`
    `xfce4-clipman-plugin`
    `xfce4-calculator-plugin`
    `geany-plugins`
    `xfce4-datetime-plugin`
5. Updates your termux

# Wordpress default configuration details

| Key               |     Value     |
|-------------------|---------------|
| Database name     | wordpress     |
| Database host     | 127.0.0.1     |
| Username          | root          |
| password          | wordpress     |
| Table prefix      | wp_           |


# Reference links

* https://www.cyberciti.biz/faq/how-to-configure-nginx-for-wordpress-permalinks/
* https://www.nginx.com/resources/wiki/start/topics/recipes/wordpress/
* https://blog.hubspot.com/website/413-request-entity-too-large

[Goodies]

* https://github.com/rajkumardusad/MyServer
* https://github.com/modded-ubuntu/modded-ubuntu

# Installation Screens

* Auto updates the Termux system

![update](https://user-images.githubusercontent.com/22621881/141097338-f5e44225-7a86-42d6-8e62-d08a5d646bfd.png)

* Installs the essential packs for Xfce4 VNC session

![goodies](https://user-images.githubusercontent.com/22621881/141097310-4bc727ed-a3a0-41ad-8ae5-308687f433fb.png)

* Auto cleans and creates new VNC sessions

![vnc setup](https://user-images.githubusercontent.com/22621881/141097352-50d5d85a-4643-47fa-88e8-c5c84ddbcd72.png)

* Shows VNC session details 

![active](https://user-images.githubusercontent.com/22621881/141125051-a3d9481c-dc36-423c-b867-a99274b97e64.png)


# Known Issues

[Wordpress]

* The scheduled event, recovery_mode_clean_expired_keys, failed to run. Your site still works, but this may indicate that scheduling posts or automated updates may not work as intended.
* Website dosent use HTTPS
* Warning The optional module, imagick, is not installed, or has been disabled.
* Error: cURL error 1: Received HTTP/0.9 when not allowed (http_request_failed)
  [ Rest API encountered an error]
  [ Your site could not complete loopback request ]
* php 8.1 issue : https://core.trac.wordpress.org/ticket/42362#comment:33
