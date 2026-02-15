
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

alias t="tmux"
alias ta="tmux a"

alias gs="git status"

gcam() {
    git commit -a -m "$1"
}

t-o() {
    tmux new-session -A -s OpenGL -c ~/dev/OpenGL
}

t-c() {
    tmux new-session -A -s Configuration -c ~/dev/Configuration
}

t-w() {
    tmux new-session -A -s Webserver -c ~/dev/Webserver
}

t-l() {
    tmux new-session -A -s LinuxFunctions -c ~/dev/LinuxFunctions
}


