#!/data/data/com.termux/files/usr/bin/bash

#Variables
Green='\033[0;32m' 
Yellow='\033[1;33m'
White='\033[1;33m'
Red='\033[0;31m' 
#Get ip address
ifconfig 2>/dev/null | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' > ip
username=`whoami`
password="1234"

#Setup root system password
passwd ${username} << EOD
${password}
${password}
EOD


clear && printf "${Yellow}[*] ${Green}Getting things ready!\n" && sleep 1
termux-setup-storage
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
printf "${Yellow}[*] ${Green}Hitman left\n"
printf "${Yellow}[*] ${Green}We are about to start vnc server\n"
printf "${Yellow}[*] ${Green}if prompted set up password\n"
printf "${Yellow}[*] ${Green}input 'n' if asked for view-only password\n"

#Start VNC and xfce4-session
vncserver 
export DISPLAY=:1
xfce4-session >/dev/null 2>&1 &

sleep 3 && clear 
figlet "VNC Active"

termux-wake-lock
printf "${Yellow}[*] ${Green}Wavelock aquired\n"
printf "${Yellow}[*] ${Green}VNC is Active\n Local IP: ${Yellow}`cat ip` \n ${Green}Port: ${Yellow}509`vncserver -list|grep :|awk '{print $1}'|grep :|awk -F ':' '{print$2}'`${Green}\n keep this termux session active\n \n${White}"
printf "${Yellow}[*] ${Green}SSH is Active\n Local IP: ${Yellow}`cat ip` \n ${Green}Port: ${Yellow}8022${Green}\n Password : ${Yellow}1234\n \n${White}"

sshd

#clean files
rm -rf ip
rm -rf livevnc
