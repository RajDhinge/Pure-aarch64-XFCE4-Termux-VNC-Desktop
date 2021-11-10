#!/data/data/com.termux/files/usr/bin/bash

#Variables
Green='\033[0;32m' 
Yellow='\033[1;33m'
White='\033[1;33m'
Red='\033[0;31m' 
#Get ip address
ifconfig 2>/dev/null | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' > ip


printf "${Yellow}[*] ${Green}Getting things ready!\n" && sleep 1
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
    'openssh' 
    'nginx' 
    'php-fpm' 
    'mariadb' 
    'otter-browser' 
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
    printf "${Yellow}[*] ${Green}Setting up $pack\n"
    apt install $pack -y >/dev/null 2>&1
done

#Extra goodies
if [ `command -v adb` ]; then
        printf "${Yellow}[*] ${Green}Setting up adb utility\n"
    else
        printf "${Yellow}[*] ${Green}Setting up adb utility\n"
        wget https://github.com/MasterDevX/Termux-ADB/raw/master/InstallTools.sh -q && bash InstallTools.sh >/dev/null 2>&1
fi


printf "${Yellow}[*] ${Green}Setting up Xfce session\n"

printf "${Green} Please wait... \n setting up VNC on ${Yellow}`cat ip`${Green} \n this may take a while...\n" && sleep 1
printf "${Yellow}[*] ${Green}Terminating active vnc server's if any \n"
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
printf "${Yellow}[*] ${Green}We are about to starting vnc server\n"
printf "${Yellow}[*] ${Green}if prompted set up password\n"
printf "${Yellow}[*] ${Green}input 'n' if asked for view-only password\n"

#Start VNC and xfce4-session
vncserver 
export DISPLAY=:1
xfce4-session >/dev/null 2>&1 &

printf "${White}--------------------------------------\n${White}"
printf "${Yellow}[*] ${Green}Done! Vnc is now active\n IP: ${Yellow}`cat ip` \n ${Green}Port: ${Yellow}5091${Green}\n keep this termux session active\n you may even 'Aquire wavelock' on termux\n "
printf "${White}--------------------------------------\n${White}"

#clean files
rm -rf ip
rm -rf livevnc

#Setup Wordpress
#wget https://wordpress.org/latest.zip -P /data/data/com.termux/files/usr/share/nginx/html/ &&
#unzip /data/data/com.termux/files/usr/share/nginx/html/latest.zip -d /data/data/com.termux/files/usr/share/nginx/html &&
#extras
#rm /data/data/com.termux/files/usr/share/nginx/html/latest.zip