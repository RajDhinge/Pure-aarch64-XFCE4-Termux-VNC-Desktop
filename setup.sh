#!/data/data/com.termux/files/usr/bin/bash

#Variables
Green='\033[0;32m' 
Yellow='\033[1;33m'
White='\033[1;33m'
Red='\033[0;31m' 
#Get ip address
ifconfig 2>/dev/null | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' > ip
username=`whoami`
password="1234567"

#Setup root system password
passwd ${username} << EOD
${password}
${password}
EOD
termux-setup-storage << EOD
"n"
EOD

clear && printf "${Yellow}[*] ${Green}Getting things ready!\n" && sleep 1
printf "${Yellow}[*] ${Green}Updating your termux ${Green}system\n${White}"

#Update System
apt update  >/dev/null 2>&1
apt upgrade -y 
apt install neofetch -y >/dev/null 2>&1 

printf "${Yellow}[*] ${Green}Termux system updated\n"
printf "${Yellow}[*] ${Green}About to set up your VNC Desktop!\n"
sleep 3 && clear && neofetch

#Installing essential packages & goodies
packs=(
    'figlet'
    'openssh' 
    'nginx' 
    'php-fpm' 
    'mariadb' 
    'otter-browser'
    'netsurf'
    'x11-repo' 
    'xfce4' 
    'zsh' 
    'tigervnc' 
    'tsu' 
    'xfce4-terminal' 
    'dosbox' 
    'wget' 
    'lxqt-archiver' 
    'nmap' 
    'termux-api' 
    'htop' 
    'git' 
    'zip' 
    'tumbler'
    'proot-distro'
    'xfce4-clipman-plugin'
    'xfce4-calculator-plugin'
    'geany-plugins'
    'xfce4-datetime-plugin'
    )
 
for pack in "${packs[@]}"
do
    dpkg -L $pack >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        printf "${Yellow}[*] ${Green}$pack already installed\n"
    else
        printf "${Yellow}[*] ${Green}Setting up $pack\n"
        apt install $pack -y >/dev/null 2>&1
    fi
done

#Extra goodies
if [ `command -v adb` ]; then
        printf "${Yellow}[*] ${Green}Setting up adb utility\n"
    else
        printf "${Yellow}[*] ${Green}Setting up adb utility\n"
        wget https://github.com/MasterDevX/Termux-ADB/raw/master/InstallTools.sh -q && bash InstallTools.sh >/dev/null 2>&1
fi


printf "\n${Yellow}[*] ${Green}Essential packs are now installed!\n"
sleep 3 && clear 
figlet "Setting VNC"


printf "${Yellow}[*] ${Green}Setting up Xfce session\n"
printf "${Green} Please wait... \n Your ip is ${Yellow}`cat ip`${Green} \n this may take a while...\n" && sleep 1
printf "${Yellow}[*] ${Green}Terminating active vnc server's if any \n"
printf "${Yellow}[*] ${Green}Calling hitman \n"
printf "${Yellow}[*] ${Green}Hitman arrived\n"
vncserver -list|grep :|awk '{print $1}'|grep : > livevnc  && sleep 5

#Terminate and clean vnc server
for PORT in `cat livevnc`
do
    if [ -f "/data/data/com.termux/files/usr/tmp/.X`echo $PORT|awk -F ':' '{print $2}'`-lock" ]; then
        rm -rf /data/data/com.termux/files/usr/tmp/.X*-lock
        rm -rf /data/data/com.termux/files/usr/tmp/.X11-unix/X*
    fi
    vncserver -kill $PORT 
done
#Terminate all xfce sessions
pkill xfce4-session >/dev/null 2>&1 &
rm -rf /data/data/com.termux/files/home/.vnc/passwd
printf "${Yellow}[*] ${Green}Hitman left\n"

printf "${Yellow}[*] ${Green}We are about to start vnc server\n"

#Start VNC and xfce4-session
vncserver << EOD
${password}
${password}
"n"
EOD

export DISPLAY=:1
xfce4-session >/dev/null 2>&1 &
clear
figlet "Setting"
figlet "Wordpress" 
sleep 2
printf "${Yellow}[*] ${Green}Setting up wordpress and nginx\n"
#Setting up wordpress

DIR="/data/data/com.termux/files/usr/share/nginx/html/wordpress"
if [ -d "$DIR" ]; then
  echo "wordpress already installed!"
else
    printf "${Yellow}[*] ${Green}Downloading WordPress\n"
    wget https://wordpress.org/latest.zip -P /data/data/com.termux/files/usr/share/nginx/html/ 
    wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-en.php -P /data/data/com.termux/files/usr/share/nginx/html/ 
    mv /data/data/com.termux/files/usr/share/nginx/html/adminer-4.8.1-en.php /data/data/com.termux/files/usr/share/nginx/html/adminer.php
    printf "${Yellow}[*] ${Green}Extracting WordPress\n"
    unzip /data/data/com.termux/files/usr/share/nginx/html/latest.zip -d /data/data/com.termux/files/usr/share/nginx/html
fi

printf "${Yellow}[*] ${Green}Setting up nginx config files\n"
mkdir /sites-available /data/data/com.termux/files/usr/etc/nginx/sites-available
mv sites-available/default /data/data/com.termux/files/usr/etc/nginx/sites-available/default
mv nginx.conf /data/data/com.termux/files/usr/etc/nginx/nginx.conf

printf "${Yellow}[*] ${Green}Attempting to start nginx\n"
#kill active servers
printf "${Yellow}[*] ${Green}Killing nginx\n"
pkill nginx
printf "${Yellow}[*] ${Green}Killing php-fpm\n"
pkill php-fpm

#Boot server
#mysqld_safe >/dev/null 2>&1
#nginx >/dev/null 2>&1
#php-fpm  >/dev/null 2>&1
printf "${Yellow}[*] ${Green}Starting mysql\n"
mysqld_safe &
sleep 1
printf "${Yellow}[*] ${Green}Starting nginx\n"
nginx
printf "${Yellow}[*] ${Green}Starting phpfpm\n"
php-fpm
sleep 1
printf "${Yellow}[*] ${Green}creating db\n"
mysql << EOD
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('wordpress');
CREATE DATABASE wordpress
EOD

printf "${Yellow}[*] ${Green}Wordpress is up\n"

sleep 3 && clear 
figlet "VNC Active"
termux-wake-lock
printf "${Yellow}[*] ${Green}Wavelock aquired\n"
printf "${Yellow}[*] ${Green}VNC is Active\n Local IP: ${Yellow}`cat ip` \n ${Green}Port: ${Yellow}509`vncserver -list|grep :|awk '{print $1}'|grep :|awk -F ':' '{print$2}'`${Green}\n Password : ${Yellow}$password\n${Green}\n keep this termux session active\n \n${White}"
printf "${Yellow}[*] ${Green}SSH is Active\n Local IP: ${Yellow}`cat ip` \n ${Green}Port: ${Yellow}8022${Green}\n Password : ${Yellow}$password\n \n${White}"
printf "\n${Yellow}[*] ${Green}Note: To use SSH a restart to termux is required as we have set up a new password\n \n${White}"
sshd

#Clean files
rm -rf ip
rm -rf livevnc
rm -rf /data/data/com.termux/files/usr/share/nginx/html/latest.zip