#!/bin/bash

DESKTOP_FILE="/tmp/$1.desktop"
echo "[Desktop Entry]" > $DESKTOP_FILE
echo "Name=$2" >> $DESKTOP_FILE
echo "Exec=$3" >> $DESKTOP_FILE
echo "Icon=$4" >> $DESKTOP_FILE
echo "Type=Application" >> $DESKTOP_FILE
echo "Categories=$5;" >> $DESKTOP_FILE

function check () {
        if [[ $? -eq 0 ]]; then
                echo -e "[\e[92mSucesso\e[0m]"
            else
                echo -e "[\e[91mFalhou\e[0m]"
        fi
}

if [[ -n $6 ]]; then
        echo -e "Baixando ícone do atalho... \c"
        (wget -q -N --trust-server-names $6 && xdg-icon-resource install --novendor --size 64 $4.png && xdg-icon-resource forceupdate) &>/dev/null
        check
fi

echo -e "Adicionando atalho ao menu de aplicativos... \c"
mkdir -p /usr/local/share/applications
(xdg-desktop-menu install --novendor $DESKTOP_FILE && xdg-desktop-menu forceupdate) &>/dev/null
check

echo -e "Adicionando atalho à área de trabalho... \c"
sudo -u $(logname) xdg-desktop-icon install --novendor $DESKTOP_FILE &>/dev/null
check
