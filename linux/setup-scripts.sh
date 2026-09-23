#!/bin/bash


mkdir -p $HOME/.scripts

prompt="y"
[ -a ~/.scripts/colors.sh ] && read -r -p "Overwrite existing colors.sh file? [y/N] " prompt
if [ "${prompt@L}" == "y" ]; then
rm -fv ~/.colors.sh
else
echo "Gracefully exiting without overwriting/deleting existing colors.sh file."
fi	

if [ ! -a ~/.scripts/colors.sh ] ; then
ln -s "$(pwd)/scripts/colors.sh" $HOME/.scripts/colors.sh
echo "Made symbolic links to colors.sh file."
fi 

[ -a ~/.scripts/remote.sh ] && read -r -p "Overwrite existing remote.sh file? [y/N] " prompt
if [ "${prompt@L}" == "y" ]; then
rm -fv ~/.remote.sh
else
echo "Gracefully exiting without overwriting/deleting existing remote.sh file."
fi	

if [ ! -a ~/.scripts/remote.sh ] ; then
ln -s "$(pwd)/scripts/remote.sh" $HOME/.scripts/remote.sh
echo "Made symbolic links to remote.sh file."
fi 
