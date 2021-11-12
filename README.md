# Pure-aarch64-XFCE4-Termux-VNC-Desktop

# Installation steps

* Copy & run the below command in your termux application

```
apt update && 
apt install git -y && 
rm -rf Pure-aarch64-XFCE4-Termux-VNC-Desktop &&
git clone https://github.com/RajDhinge/Pure-aarch64-XFCE4-Termux-VNC-Desktop.git && 
cd Pure-aarch64-XFCE4-Termux-VNC-Desktop && 
chmod +x setup.sh && 
bash setup.sh &&
cd .. &&
rm -rf Pure-aarch64-XFCE4-Termux-VNC-Desktop &&
cd ~
```

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
* The setting for post_max_size is smaller than upload_max_filesize, this could cause some problems when trying to upload files.
* Website dosent use HTTPS
* Warning The optional module, imagick, is not installed, or has been disabled.
* Error: cURL error 1: Received HTTP/0.9 when not allowed (http_request_failed)
  [ Rest API encountered an error]
  [ Your site could not complete loopback request ]

