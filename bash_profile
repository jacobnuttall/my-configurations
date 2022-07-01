#!/bin/bash
alias lsdir="ls --color -al | awk '{print \$(NF)}'"
if [ -f ~/.local/bin/vim ]; then alias vim=~/.local/bin/vim; fi

pvenv () {
    echo -e "source ${GREEN}${HOME}/python/virtualenv/${1}/bin/activate${RESET}"
    source "${HOME}/python/virtualenv/${1}/bin/activate"
}

# Make the different text types supported by the terminal
txttypes=(
    'RESET'
    'BOLD'
    'FAINT'
    'ITALICS'
    'ULINE' 
)
read -a txttypecodes <<< $( echo "$(seq 0 4)" | tr '\n' ' ' )
for i in ${!txttypes[@]}
do
     eval export "${txttypes[i]}"='"\e[${txttypecodes[i]}m"'
done

# The different color codes supported by the terminal.
colors=(
    'BLACK'
    'RED'
    'GREEN'
    'YELLOW' 
    'BLUE'
    'MAGENTA'
    'CYAN'
    'LIGHTGRAY'
    'GRAY'
    'LIGHTRED'
    'LIGHTGREEN'
    'LIGHTYELLOW'
    'LIGHTBLUE'
    'LIGHTMAGENTA'
    'LIGHTCYAN'
    'WHITE' 
)
read -a fgcolorcodes <<< $( echo "$(seq 30 37) $(seq 90 97)"   | tr '\n' ' ' )
read -a bgcolorcodes <<< $( echo "$(seq 40 47) $(seq 100 107)" | tr '\n' ' ' )
for i in ${!colors[@]}; 
do
    eval export "${colors[i]}_BG"='"\e[${bgcolorcodes[i]}m"'
    eval export "${colors[i]}"='"\e[${fgcolorcodes[i]}m"'
done

# The different cursor styles allowed by the terminal.
cursorstyles=(
    'BOX_BLINK'
    'BOX'
    'UNDER_BLINK'
    'UNDER'
    'LINE_BLINK'
    'LINE'
)
read -a cursorstylecodes <<< $( echo "$(seq 1 6)" | tr '\n' ' ' )
for i in ${!cursorstyles[@]}
do
    eval export "CURS_${cursorstyles[i]}"='"\e[${cursorstylecodes[i]} q"'
done


if [[ $- == *i* ]]
then
    # Commands to run in interactive mode.
    echo -e "${LIGHTCYAN}${BOLD}${ULINE}Hello world!${RESET}\n It is ${BOLD}${GREEN}$(date)${RESET}."
    echo -e "${CURS_BOX_BLINK}"
        
else
fi

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
