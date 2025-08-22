#!/bin/bash

#TODO: Define a function to show available remote services.

source ~/scripts/colors.sh
start_mount() {
    remote=$1
    if [[ ! -d "$HOME/$remote" ]]; then 
        echo -e "$BOLD${GREEN}Mounting remote service $1:$RESET"
        mkdir $HOME/$remote 
        rclone mount $remote: ~/$remote \
            --vfs-cache-mode=full        \
            --daemon                    \
            --vfs-cache-max-size 10G    \
            --vfs-cache-max-age 72h     
    fi  
}

stop_mount() {
    remote=$1

    if [[ -d "$HOME/$remote" ]]; then 
        echo -e "$BOLD${RED}Unmounting remote service $1:$RESET"
        kill -SIGTERM $( ps aux | grep $remote: | grep rclone | awk '{ print $2 }')
        sleep 2
        umount $HOME/$remote
        rmdir $HOME/$remote
    fi
}
