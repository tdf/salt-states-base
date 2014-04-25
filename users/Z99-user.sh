#!/bin/sh

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!! THIS FILE IS MANAGED BY SALT !!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

alias grepconf='grep -vE "^#|^$|^[\w]+#"'
alias grep='grep --color'
alias sudox='sudo cp ~/.Xauthority /root && sudo '
export LS_OPTIONS='--color=auto -h'
eval "`dircolors`" 
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'
alias ..='cd ..'
alias ...='cd ../..'
force_color_prompt=yes
