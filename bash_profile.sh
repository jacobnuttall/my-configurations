# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

PATH=$PATH:$HOME/.local/bin

start_vncserver () {
	vncserver -kill :1
	x=$1
	y=$2
	[[ -z "$1" ]] && x=1920
	[[ -z "$2" ]] && y=$(perl -e "print int($x/1.77778 + 0.99)");
	echo -e "${LIGHTGREEN}vncserver -localhost yes -geometry \"${x}x${y}\" :1${RESET}${RED}"
	vncserver -localhost yes -geometry "${x}x${y}" :1
	echo -e "${RESET}"
}

alias vncserver="vncserver -localhost yes"
alias vncserver-start="start_vncserver 1920 1080"
alias vncserver-kill="vncserver -kill :1"
alias lsdir="ls --color -al | awk '{print \$(NF)}'"
alias giturl="git config --get remote.origin.url"
alias gituprepopat="git_update_repo_pat_url"
alias gituprepo="git_update_repo_url"
alias gitclonepat="git_clone_add_pat"

git_clone_add_pat () {
	url=$1
	newurl=$(echo $url | sed "s,://,://$(whoami):$(cat ~/token)@,")
	echo $newurl
	git clone $newurl
}

git_update_repo_pat_url () {
	# Update the url of a git repository to use a new PAT for gitlab
	repourl=$(giturl)
	IFS='@' read -ra URLARR <<< $1
	newurl="https://$(whoami):$(cat ~/token)@${URLARR[1]}"
	echo $newurl
	git remote set-url origin $newurl
}

git_update_repo_url() {
	# Update the url of a git repository from clean url (no PAT)
	url=$1
	newurl=$(echo $url | sed "s,://,://$(whoami):$(cat ~/token)@,")
	echo $newurl
	git remote set-url origin $newurl
}

pvenv () {
	case $- in
		*i*) echo -e "source ${GREEN}${HOME}/python/virtualenv/${1}/bin/activate${RESET}"
		;;
		*)
		;;
	esac
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
fi

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

# if [ -n "$force_color_prompt" ]; then
#     if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
# 	# We have color support; assume it's compliant with Ecma-48
# 	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
# 	# a case would tend to support setf rather than setaf.)
# 	color_prompt=yes
#    else
#	color_prompt=
#    fi
# fi

# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
# unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

