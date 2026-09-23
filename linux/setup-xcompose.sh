#!/bin/bash

prompt="y"
[ -a ~/.XCompose ] && read -r -p "Overwrite existing .XCompose file? [y/N] " prompt
if [ "${prompt@L}" == "y" ]; then
rm -fv ~/.XCompose
rm -fv ~/.config/xcompose
else
echo "Gracefully exiting without overwriting/deleting existing .XCompose file."
fi	

if [ ! -a ~/.XCompose ] ; then
ln -s "$(pwd)/dotfiles/home/XCompose" $HOME/.XCompose
ln -s "$(pwd)/dotfiles/xcompose/" $HOME/.config
echo "Made symbolic links to .XCompose files."
fi 


ibus restart


