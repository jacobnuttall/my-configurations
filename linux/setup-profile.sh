#!/bin/bash

# prompt="y"
# [ -a $HOME/.bash_profile ] && read -r -p "Overwrite existing .bash_profile file? [y/N] " prompt
# if [ "${prompt@L}" == "y" ]; then
# rm -fv ~/.bash_profile
# else
# echo "Gracefully exiting without overwriting/deleting existing .bash_profile file."
# fi	

# if [ ! -a $HOME/.bash_profile ] ; then 
# ln -s $(pwd)/bash_profile.sh $HOME/.bash_profile
# echo "Created a symlink to $(pwd)/bash_profile in the home directory."
# fi

read -r -p "Use the bash_profile.sh file included in this repository to modify the .bashrc file as seems fit, then press ENTER to continue."  _

