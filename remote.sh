#!/bin/bash

#TODO: Define a function to show available remote services.

source ~/scripts/colors.sh


mount_point() {
    remote=$1
    echo $HOME/mnt/$remote
}

[[ ! -d "$(mount_point )" ]] && mkdir $(mount_point)

start_mount() {
    remote=$1
    if [[ ! -d "$(mount_point $remote)" ]]; then 
        echo -e "$BOLD${GREEN}Mounting remote service $1:$RESET"
        mkdir $(mount_point $remote) 
        rclone mount $remote: $(mount_point $remote) \
            --vfs-cache-mode=full        \
            --daemon                    \
            --vfs-cache-max-size 10G    \
            --vfs-cache-max-age 72h     
    fi  
}

stop_mount() {
    remote=$1

    if [[ -d "$(mount_point $remote)" ]]; then 
        echo -e "$BOLD${RED}Unmounting remote service $1:$RESET"
        kill -SIGTERM $( ps aux | grep $remote: | grep rclone | awk '{ print $2 }')
        sleep 2
        umount $(mount_point $remote)
        rmdir $(mount_point $remote)
    fi
}
