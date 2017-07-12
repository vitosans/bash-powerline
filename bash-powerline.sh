#!/bin/bash
# File: bash-powerline.sh
# Author: Vito Louis Sansevero <vito.sansevero@gmail.com>
# Date: 07.11.2017
# Last Modified Date: 07.11.2017
# Last Modified By: Vito Louis Sansevero <vito.sansevero@gmail.com>

__powerline() {

    # Unicode symbols
    readonly PS_SYMBOL_DARWIN=''
    readonly PS_SYMBOL_LINUX='\$'
    readonly PS_SYMBOL_OTHER='%'
    readonly GIT_BRANCH_SYMBOL='  '
    readonly GIT_BRANCH_CHANGED_SYMBOL='+ '
    readonly GIT_NEED_PUSH_SYMBOL='⇡ '
    readonly GIT_NEED_PULL_SYMBOL='⇣ '
    readonly SEPARATOR=''
    readonly SEPARATOR_THIN=''
    readonly PS_SYMBOL_PYTHON='ƨ'

    # Solarized colorscheme
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
        readonly FG_BASE03="\[$(tput setaf 8)\]"
        readonly FG_BASE02="\[$(tput setaf 0)\]"
        readonly FG_BASE01="\[$(tput setaf 10)\]"
        readonly FG_BASE00="\[$(tput setaf 11)\]"
        readonly FG_BASE0="\[$(tput setaf 12)\]"
        readonly FG_BASE1="\[$(tput setaf 14)\]"
        readonly FG_BASE2="\[$(tput setaf 7)\]"
        readonly FG_BASE3="\[$(tput setaf 15)\]"

        readonly BG_BASE03="\[$(tput setab 8)\]"
        readonly BG_BASE02="\[$(tput setab 0)\]"
        readonly BG_BASE01="\[$(tput setab 10)\]"
        readonly BG_BASE00="\[$(tput setab 11)\]"
        readonly BG_BASE0="\[$(tput setab 12)\]"
        readonly BG_BASE1="\[$(tput setab 14)\]"
        readonly BG_BASE2="\[$(tput setab 7)\]"
        readonly BG_BASE3="\[$(tput setab 15)\]"

        readonly FG_YELLOW="\[$(tput setaf 3)\]"
        readonly FG_ORANGE="\[$(tput setaf 9)\]"
        readonly FG_RED="\[$(tput setaf 1)\]"
        readonly FG_MAGENTA="\[\033[0;35m\]"
        readonly FG_VIOLET="\[$(tput setaf 13)\]"
        readonly FG_BLUE="\[$(tput setaf 4)\]"
        readonly FG_CYAN="\[$(tput setaf 6)\]"
        readonly FG_GREEN="\[$(tput setaf 2)\]"

        readonly BG_YELLOW="\[$(tput setab 3)\]"
        readonly BG_ORANGE="\[$(tput setab 9)\]"
        readonly BG_RED="\[$(tput setab 1)\]"
        readonly BG_MAGENTA="\[$(tput setab 5)\]"
        readonly BG_VIOLET="\[$(tput setab 13)\]"
        readonly BG_BLUE="\[$(tput setab 4)\]"
        readonly BG_CYAN="\[$(tput setab 6)\]"
        readonly BG_GREEN="\[$(tput setab 2)\]"
    else
        readonly FG_BASE03="\[$(tput setaf 8)\]"
        readonly FG_BASE02="\[$(tput setaf 0)\]"
        readonly FG_BASE01="\[$(tput setaf 10)\]"
        readonly FG_BASE00="\[$(tput setaf 11)\]"
        readonly FG_BASE0="\[$(tput setaf 12)\]"
        readonly FG_BASE1="\[$(tput setaf 14)\]"
        readonly FG_BASE2="\[$(tput setaf 7)\]"
        readonly FG_BASE3="\[$(tput setaf 15)\]"

        readonly BG_BASE03="\[$(tput setab 8)\]"
        readonly BG_BASE02="\[$(tput setab 0)\]"
        readonly BG_BASE01="\[$(tput setab 10)\]"
        readonly BG_BASE00="\[$(tput setab 11)\]"
        readonly BG_BASE0="\[$(tput setab 12)\]"
        readonly BG_BASE1="\[$(tput setab 14)\]"
        readonly BG_BASE2="\[$(tput setab 7)\]"
        readonly BG_BASE3="\[$(tput setab 15)\]"

        readonly FG_YELLOW="\[$(tput setaf 3)\]"
        readonly FG_ORANGE="\[$(tput setaf 9)\]"
        readonly FG_RED="\[$(tput setaf 1)\]"
        readonly FG_MAGENTA="\[$(tput setaf 5)\]"
        readonly FG_VIOLET="\[$(tput setaf 13)\]"
        readonly FG_BLUE="\[$(tput setaf 4)\]"
        readonly FG_CYAN="\[$(tput setaf 6)\]"
        readonly FG_GREEN="\[$(tput setaf 2)\]"

        readonly BG_YELLOW="\[$(tput setab 3)\]"
        readonly BG_ORANGE="\[$(tput setab 9)\]"
        readonly BG_RED="\[$(tput setab 1)\]"
        readonly BG_MAGENTA="\[$(tput setab 5)\]"
        readonly BG_VIOLET="\[$(tput setab 13)\]"
        readonly BG_BLUE="\[$(tput setab 4)\]"
        readonly BG_CYAN="\[$(tput setab 6)\]"
        readonly BG_GREEN="\[$(tput setab 2)\]"
    fi

    readonly DIM="\[$(tput dim)\]"
    readonly REVERSE="\[$(tput rev)\]"
    readonly RESET="\[$(tput sgr0)\]"
    readonly BOLD="\[$(tput bold)\]"

    if [[ -z "$PS_SYMBOL" ]]; then
        case "$(uname)" in
            Darwin)
                PS_SYMBOL=$PS_SYMBOL_DARWIN
                ;;
            Linux)
                PS_SYMBOL=$PS_SYMBOL_LINUX
                ;;
            *)
                PS_SYMBOL=$PS_SYMBOL_OTHER
        esac
    fi

    __git_info() {
        local git_eng="env LANG=C git"   # force git output in English to make our work easier
        # get current branch name or short SHA1 hash for detached head
        local branch="$($git_eng symbolic-ref --short HEAD 2>/dev/null || $git_eng describe --tags --always 2>/dev/null)"
        [ -n "$branch" ] || return  # git branch not found

        local marks

        # branch is modified?
        [ -n "$($git_eng status --porcelain)" ] && marks+=" $GIT_BRANCH_CHANGED_SYMBOL"

        # how many commits local branch is ahead/behind of remote?
        local stat="$($git_eng status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
        local aheadN="$(echo $stat | grep -o 'ahead [0-9]\+' | grep -o '[0-9]\+')"
        local behindN="$(echo $stat | grep -o 'behind [0-9]\+' | grep -o '[0-9]\+')"
        [ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$aheadN"
        [ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL$behindN"

        # print the git branch segment without a trailing newline
        printf " $GIT_BRANCH_SYMBOL$branch$marks "
    }

    __virtualenv() {
        if [ -z "${VIRTUAL_ENV}" ] ; then
            return
        else
            local virtualenv="$(basename $VIRTUAL_ENV)"
            printf "($PS_SYMBOL_PYTHON $virtualenv)"
        fi
    }
          ps1() {
          # Check the exit code of the previous command and display different
          # colors in the prompt accordingly.•
          if [ $? -eq 0 ]; then
              local GITINFO=$(__git_info)
              if [ -n "$GITINFO" ]; then
                  local BG_EXIT="$FG_BLUE"
              else
                  local BG_EXIT="$FG_YELLOW"
              fi
              BG_EXIT+="$BG_GREEN$SEPARATOR$RESET$BG_GREEN"
              local FG_EXIT="$FG_GREEN"
              local EXIT_RESULT=0
          else
              local GITINFO=$(__git_info)
              if [ -n "$GITINFO" ]; then
                  local BG_EXIT="$FG_BLUE"
              else
                  local BG_EXIT="$FG_YELLOW"
              fi
              BG_EXIT+="$BG_RED$SEPARATOR$RESET$BG_RED"
              local FG_EXIT="$FG_RED"
              local EXIT_RESULT=1
          fi
          PS1="$BG_BASE2$SEPARATOR_THIN$BG_BASE2$FG_BASE02\t $FG_BASE2$BG_BASE02$SEPARATOR$RESET" #time
          PS1+="$BG_BASE02$FG_BASE3 \u $FG_BASE02$BG_MAGENTA$SEPARATOR$RESET" # user
          PS1+="$BG_MAGENTA$FG_YELLOW \H $FG_MAGENTA$BG_YELLOW$SEPARATOR$RESET" # host
          PS1+="$BG_YELLOW$FG_BASE02 \W $RESET" # current directory

          if [ -n "$GITINFO" ]; then
              PS1+="$FG_YELLOW$BG_BLUE$SEPARATOR$RESET" # GIT Info
              PS1+="$BG_BLUE$FG_BASE3$GITINFO$RESET" # GIT Info
          fi
          #PS1+="$BG_EXIT$FG_BASE3 \l $SEPARATOR_THIN $PS_SYMBOL$RESET$FG_EXIT$SEPARATOR$RESET " # current terminal plus $
          PS1+="$BG_EXIT$FG_BASE3 $PS_SYMBOL$RESET$FG_EXIT$SEPARATOR$RESET " # current terminal plus $
      }

    PROMPT_COMMAND=ps1
}

__powerline
unset __powerline
