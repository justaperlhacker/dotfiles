# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

# Only for login shells on a Linux virtual console
if [[ $SHLVL -eq 1 && $TERM == linux ]]; then
    clear
fi
