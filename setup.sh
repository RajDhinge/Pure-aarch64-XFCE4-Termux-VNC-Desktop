#!/data/data/com.termux/files/usr/bin/bash
#################################################
#
# Pure-aarch64-XFCE4-Termux-VNC-Desktop
# By RajDhinge
#
# Last modified: Fri Nov 12 1:12:26 PM IST 2021
#################################################

#initialize
initvar() {
    #Variables
    Green='\033[0;32m' 
    Yellow='\033[1;33m'
    White='\033[1;33m'
    Red='\033[0;31m' 
    #Get ip address
    ifconfig 2>/dev/null | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' > ip
    username=`whoami`
    password="1234567"
        
termux-setup-storage << EOD
"n"
EOD

}


#Termux system update
termuxupdate() {
    printf "${Yellow}[*] ${Green}Getting things ready!\n" && sleep 1
    printf "${Yellow}[*] ${Green}Updating your termux ${Green}system\n${White}"
    #Update System
    pkg update  >/dev/null 2>&1
 
apt upgrade << EOD
"Y"
"Y"
EOD
 
    apt install neofetch -y >/dev/null 2>&1 
    printf "${Yellow}[*] ${Green}Termux system updated\n"
}

#Essential packs
installpacks() {
    neofetch
    #Installing essential packages & goodies
    packs=(
        'figlet' 'rsync'
#Recommended        
        'fish' 'tree' 'tsu' 'wget' 'zip' 
#Misc        
        'termux-api'
#XFCE4gui
        'x11-repo' 'xfce4' 
#XFCE4Essentials
        'tumbler' 'tigervnc' 'xfce4-terminal' 'lxqt-archiver' 'xfce4-clipman-plugin' 'xfce4-calculator-plugin' 'geany-plugins' 'xfce4-datetime-plugin' 'xfce4-whiskermenu-plugin' 'xfce4-taskmanager'
#Deamons        
        'openssh' 'ttyd'
#developement
        'nginx' 'php-fpm' 'mariadb' 'nodejs' 'composer' 'qgui'
#Enviroments        
        'proot-distro' 'zsh' 'htop' 'pacman'
#Network        
        'nmap' 'transmission-gtk' 'wireshark-gtk'
#XFCE4Browsers        
        'otter-browser' 'netsurf' 'uget'
#Extras
        'dosbox'
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
}

beautifydesktop() {
    sleep 1
    figlet "Setting"
    figlet "Themes"
    #Install mac os dark theme 
    printf "${Yellow}[*] ${Green}Installing MacOs Dark theme\n"
    git clone https://github.com/B00merang-Project/macOS-Dark >/dev/null 2>&1
    mkdir -p ~/.local/share/themes >/dev/null 2>&1
    rsync -a ./macOS-Dark/ ~/.local/share/themes/macOS-Dark >/dev/null 2>&1
    
    printf "${Yellow}[*] ${Green}Installing Elementary OS icons\n"
    #install elementary dark icons
    git clone https://github.com/shimmerproject/elementary-xfce >/dev/null 2>&1
    cd elementary-xfce 
    ./configure --prefix=$HOME/.local
    make >/dev/null 2>&1
    make install >/dev/null 2>&1
    make icon-cache >/dev/null 2>&1
    sleep 5
    cd ..

    #set theme and icons
    printf "${Yellow}[*] ${Green}Setting downloaded themes and icons\n"
    mkdir -p /data/data/com.termux/files/home/.config/xfce4/xfconf/xfce-perchannel-xml/ >/dev/null 2>&1
    rsync -a xsettings.xml /data/data/com.termux/files/home/.config/xfce4/xfconf/xfce-perchannel-xml/ >/dev/null 2>&1
    sleep 2
}

#Setup VNC
setupvnc() {
    figlet "Setting VNC"
    printf "${Yellow}[*] ${Green}About to set up your VNC Desktop!\n"
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
            rm -rf /data/data/com.termux/files/usr/tmp/.X*-lock >/dev/null 2>&1 
            rm -rf /data/data/com.termux/files/usr/tmp/.X11-unix/X* >/dev/null 2>&1 
        fi
        vncserver -kill $PORT 
    done
    #Terminate all xfce sessions
    pkill xfce4-session >/dev/null 2>&1 &
    rm -rf /data/data/com.termux/files/home/.vnc/passwd >/dev/null 2>&1 
    printf "${Yellow}[*] ${Green}Hitman left\n"

    printf "${Yellow}[*] ${Green}We are about to start vnc server\n"

    #Start VNC and xfce4-session
vncserver >/dev/null 2>&1 << EOD
${password}
${password}
"n"
EOD

    export DISPLAY=:1
    xfce4-session >/dev/null 2>&1 &
    printf "${Yellow}[*] ${Green}VNC is up!\n"
    sleep 2
}

#Setting up WordPress, nginx engine and php-fpm f
setupwordpress() {
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
        unzip /data/data/com.termux/files/usr/share/nginx/html/latest.zip -d /data/data/com.termux/files/usr/share/nginx/html >/dev/null 2>&1 
    fi
    
    #Silent Wp-Cli Download
    curl -Os https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv -n wp-cli.phar /data/data/com.termux/files/usr/bin/wp
    printf "${Yellow}[*] ${Green}WP-CLI Installed!\n"
   
    mkdir -p /data/data/com.termux/files/usr/etc/nginx/sites-available
    cp -f sites-available/default /data/data/com.termux/files/usr/etc/nginx/sites-available/default
    cp -f nginx.conf /data/data/com.termux/files/usr/etc/nginx/nginx.conf
    cp -f php.ini /data/data/com.termux/files/usr/lib/php.ini
    chmod +x startservers
    cp -n startservers /data/data/com.termux/files/usr/bin/startservers

    #kill active servers
    pkill nginx >/dev/null 2>&1 
    pkill php-fpm >/dev/null 2>&1 

    #Boot server
    mysqld_safe >/dev/null 2>&1 & 
    sleep 1
    nginx >/dev/null 2>&1 
    php-fpm >/dev/null 2>&1 
    sleep 1
    
mysql >/dev/null 2>&1 << EOD
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('wordpress');
CREATE DATABASE wordpress
EOD
    
    printf "${Yellow}[*]${Green}`/data/data/com.termux/files/usr/etc/init.d/mysql status`\n"
    printf "${Yellow}[*] ${Green}Wordpress is up\n"
    sleep 2
} 

#summary
summary() {
    figlet "VNC Active"
    termux-wake-lock
    printf "${Yellow}[*] ${Green}Wavelock aquired\n"
    printf "${Yellow}[*] ${Green}VNC is Active\n Local IP: ${Yellow}`cat ip` \n ${Green}Port: ${Yellow}509`vncserver -list|grep :|awk '{print $1}'|grep :|awk -F ':' '{print$2}'`${Green}\n Password : ${Yellow}$password\n${Green}\n keep this termux session active\n \n${White}"
    printf "${Yellow}[*] ${Green}SSH is Active\n Local IP: ${Yellow}`cat ip` \n ${Green}Port: ${Yellow}8022${Green}\n Password : ${Yellow}$password\n \n${White}"
}

#Clean files
cleanenv() {
    rm -rf ip >/dev/null 2>&1 
    rm -rf livevnc >/dev/null 2>&1 
    rm -rf /data/data/com.termux/files/usr/share/nginx/html/latest.zip >/dev/null 2>&1 
    rm -rf adbfiles >/dev/null 2>&1 
    cd ~
    rm -rf adbfiles >/dev/null 2>&1 
    echo "fish" > /data/data/com.termux/files/home/.bashrc
}

mainexec() { 
    clear && initvar
    clear && termuxupdate
        sleep 3
    clear && installpacks
        sleep 3 
        #Setup root system password
passwd << EOD
${password}
${password}
EOD
    clear && sshd
    clear && beautifydesktop
    clear && setupvnc
        sleep 3 
    clear && setupwordpress
        sleep 3
    clear && summary
    cleanenv
}

mainexec
