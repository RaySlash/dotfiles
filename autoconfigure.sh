#!/bin/bash

# Call all variables
NOW="$(date +"%F")"
CONFIGDIR="/home/$USER/.config"
REPO="https://github.com/RaySlash/dotfiles.git"
WORKDIR="/home/$USER/.config/dotfiles"
DWMVERSION=""
# Clone repo
echo "Cloning repo..."
git clone $REPO -b master $WORKDIR

# Creation of symlink
echo "Creating symlinks"
ln -sf $WORKDIR/.zshrc ~/.zshrc
ln -sf $WORKDIR/.zsh_aliases ~/.zsh_aliases
ln -sf $WORKDIR/.zprofile ~/.zprofile
ln -sf $WORKDIR/.zshenvariables ~/.zsh_envariables
ln -sf $WORKDIR/.xinitrc ~/.xinitrc

# dwm version pick and link
DWMVERSION+=`dwm -v`
if [ DWMVERSION -eq "dwm-6.3" ] then
  ln -sf $WORKDIR/dwm.config.def.h $CONFIGDIR/dwm/config.def.h
  echo "dwm config moved!"
else echo "WARNING:dwm not installed! You can install dwm later in the script"
fi

# Data collection
echo "Collecting neofetch and pacman -Si"
neofetch >> $WORKDIR/NEOFETCH.md && rm $WORKDIR/PACMANLIST.md
pacman -Si >> $WORKDIR/PACMANLIST.md

# Skip-prompt
read -rp "Do you want to skip DE installation?(Y/n)" SKIPCONFIRM
if [ $SKIPCONFIRM -eq Y ] then
  echo "DE Installation skipped"
elif [ $SKIPCONFIRM -eq y ] then
  echo "DE Installation skipped"
elif [ $SKIPCONFIRM -eq n ] then
  read -rp "Specify your choice of DE/WM (dwm/gnome/i3)" INSTALLMODE
fi

# Packages installation (gnome  dwm  i3)
if [ $INSTALLMODE -eq dwm ] then
  git clone git://git.suckless.org/dwm $CONFIGDIR/dwm
  sudo pacman -Sy xorg
  cd dwm && make && sudo make install && cd /home/$USER/
elif [ $INSTALLMODE -eq gnome ] then
  sudo pacman -Sy gnome xorg
elif [ $INSTALLMODE -eq i3  ] then
  sudo pacman -Sy i3 xorg
else
  echo $INSTALLMODE
  echo "ERROR:Couldn't find specified DE/WM (dwm/gnome/i3)!"
  echo "Exiting script! BYEE!"
  exit 0
fi