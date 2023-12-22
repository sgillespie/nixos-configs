#!/bin/bash

set_prompt () {
    Last_Command=$? # Must come first!
    Blue='\[\e[01;34m\]'
    White='\[\e[01;37m\]'
    Red='\[\e[01;31m\]'
    Green='\[\e[01;32m\]'
    Reset='\[\e[00m\]'
    Sad='\342\234\227'
    Happy='\342\234\223'

    PS1="┌─("
    
    # If root, just print the host in red. Otherwise, print the current user
    # and host in green.
    if [[ $EUID == 0 ]]; then
        PS1+="$Red\\h$Reset)"
    else
        PS1+="$Green\\u@\\h$Reset)"
    fi

    # Print the working directory and prompt marker in blue, and reset
    # the text color to the default.
    PS1+="$Reset"
    PS1+="──$Blue(\\w)"

    # Add a newline
    PS1+="\n$Reset"
    
    # Add a bright white exit status for the last command
    PS1+="└─$Reset("
    
    # If it was successful, print a happy. Otherwise, print
    # a sad.
    if [[ $Last_Command == 0 ]]; then
        PS1+="$Green$Happy$Reset"
    else
        PS1+="$Red$Sad$Reset"
    fi

    PS1+=":\\t$Reset)"
    PS1+="── -> "
    PS1+="$Reset"
}
PROMPT_COMMAND='set_prompt'
