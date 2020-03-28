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
                echo "[Sucesso]"
            else
                echo "[Falhou]"
        fi
}

if [[ -n $6 ]]; then
        echo -e "Baixando ícone do aplicativo... \c"
        (wget -q -N --trust-server-names $6 && xdg-icon-resource install --novendor --size 64 $4.png && xdg-desktop-menu forceupdate) &>/dev/null
        check
fi

echo -e "Criando atalho de menu... \c"
(xdg-desktop-menu install --novendor $DESKTOP_FILE && xdg-desktop-menu forceupdate) &>/dev/null
check

echo -e "Criando atalho de área de trabalho... \c"
(xdg-desktop-icon install --novendor $DESKTOP_FILE && xdg-desktop-menu forceupdate) &>/dev/null
check
