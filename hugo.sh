#!/bin/zsh

installgit() {
    if ! [ -x "$(command -v git)" ];
    then
        echo "Git is not installed\n\nStarting git installation...!"
        eval $1
        echo "Done installing git!\n"
    fi
}

systemtypeinstall() {
    if [ $1 = "ID=arch" ]; # installing in Arch Linux
    then
        echo "Installing $2 🐹🐹🐹🐹\n"
        cmd=`sudo pacman -S git`
        installgit $cmd
        git clone https://aur.archlinux.org/snapd.git && 
            cd snapd && 
            makepkg -si &&
            cd ../ &&
            rm -rf snapd
        sudo systemctl enable --now snapd.socket
        echo "Done🎉🎉🎉🎉🎉🎉!"
    elif [ $1 = "ID=ubuntu" ] || [ $1 = "ID=Debian" ];  # installing in Ubuntu or Debian
    then
        cmd=`sudo apt install git`
        installgit $cmd 
        $(sudo apt install $2)
    elif [ $1 = "ID=fedora" ]; # installing in Fedora
    then
        cmd=`sudo apt install git`
        installgit $cmd
        $(sudo dnf install $2)
    else
        echo "Please find installation for $1"
    fi 
}

checkos() {
    platform="$(uname | tr '[:upper:]' '[:lower:]')"

    if [[ $platform = "linux" ]]; 
    then
        if ! [ -x "$(command -v snap)" ];
        then
            systemtype=$(grep -w "ID=.*" /etc/os-release)
            systemtypeinstall $systemtype 'snapd'
        else
            $(snap install $1)
        fi
    else
        echo "Please find instructions on how to install"
    fi
}

echo '🐹 Starting hugo install/update'

if  ! [ -x "$(command -v curl)" ];
then
    checkos "curl"
fi

gitlatest="https://api.github.com/repositories/11180687/releases/latest"
url=$(curl -s $gitlatest | grep -o 'https://.*hugo_extended.*_Linux-64bit.tar.gz')

echo '✅ Found the latest version!'
echo ''
echo '🐹 Downloading the hugo extended latest...!'
curl -s $url -L -o hugo_extended_latest.tar.gz

echo '✅ Download complete: ' $url

echo "🐹 Extracting archive!"

sudo tar -zxf hugo_extended_latest.tar.gz -C /usr/local/bin
sudo rm /usr/local/bin/README.md
sudo rm /usr/local/bin/LICENSE

echo '✅ Extracted to /usr/local/bin'

rm hugo_extended_latest.tar.gz
echo ''
echo '👉 Current Version' $(hugo version)
echo ''
echo '🎉 DONE! 🎉'
