
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
     eval export "${txttypes[i]}"='"\033[${txttypecodes[i]}m"'
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
	eval export "${colors[i]}_BG"='"\033[${bgcolorcodes[i]}m"'
	eval export "${colors[i]}"='"\033[${fgcolorcodes[i]}m"'
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
	eval export "CURS_${cursorstyles[i]}"='"\033[${cursorstylecodes[i]} q"'
done

