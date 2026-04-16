#!/bin/bash

ln -s $(pwd)/dotfiles/home/.XCompose $HOME
ln -s $(pwd)/dotfiles/xcompose/ $HOME/.config
ibus restart

