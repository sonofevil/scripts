#!/bin/bash

## KDE Menu Entry Generator ##
###
## Generates a .desktop file in ~/.local/share/applications/ 
## according to input from KDE dialogues and rebuilds menu cache
## Requires path of an executable file as argument
## Best used through "open with" menu
###

## Extract filename from file path argument
appfile=${1##*/}

## Dialogue: Enter application name or cancel
appname=`kdialog --title "Create Menu Entry" --inputbox "Enter name of menu entry:" "${appfile%.*}"` #suggests filename without extension
if [ $? == 1 ]; then exit; fi

## Generate valid filename for .desktop file from app name
deskfile=$(sed -e 's/[^A-Za-z0-9._-]/_/g' <<< $appname)

## Dialogue: Select a category
category=`kdialog --menu "Select a category:" \
AudioVideo  AudioVideo  \
Audio       Audio       \
Video       Video       \
Development Development \
Education   Education   \
Game        Game        \
Graphics    Graphics    \
Network     Network     \
Office      Office      \
Science     Science     \
Settings    Settings    \
System      System      \
Utility     Utility  `

## Dialogue: Choose whether to set icon dialogue 
kdialog --title "Icon" --yesno "Do you want to set an application icon?"
if [ $? == 0 ]; then
    ## Dialogue: Icon file selector
    iconpath=`kdialog --getopenfilename "$(dirname "${1}")"`
fi

## Generate .desktop file
echo "[Desktop Entry]" > ~/.local/share/applications/$deskfile.desktop
echo "Encoding=UTF-8" >> ~/.local/share/applications/$deskfile.desktop
echo "Version=1.0" >> ~/.local/share/applications/$deskfile.desktop
echo "Type=Application" >> ~/.local/share/applications/$deskfile.desktop
echo "Terminal=false" >> ~/.local/share/applications/$deskfile.desktop
echo "Exec='$1'" >> ~/.local/share/applications/$deskfile.desktop
echo "Name=$appname" >> ~/.local/share/applications/$deskfile.desktop
echo "Categories=$category;" >> ~/.local/share/applications/$deskfile.desktop
echo "Icon=$iconpath" >> ~/.local/share/applications/$deskfile.desktop

## Rebuild application cache
kbuildsycoca5
