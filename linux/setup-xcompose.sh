#!/bin/bash

prompt="y"
[ -a ~/.XCompose ] && read -r -p "Overwrite existing .XCompose file? [y/N] " prompt
if [ "${prompt@L}" == "y" ]; then
rm -fv ~/.XCompose
rm -fv ~/.config/xcompose
else
echo "Gracefully exiting without overwriting/deleting existing .XCompose file."
fi	

ln -s "$(pwd)/dotfiles/home/.XCompose" $HOME
ln -s "$(pwd)/dotfiles/xcompose/" $HOME/.config
ibus restart

echo "Made symbolic links to .XCompose files."

