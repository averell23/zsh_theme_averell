# ZSH Theme
# vi-mode colour changing
#   http://www.zsh.org/mla/users/2006/msg01196.html

export ZSH_THEME_GIT_PROMPT_PREFIX='\ue0a0 '
export ZSH_THEME_GIT_PROMPT_SUFFIX=' '

rst="%{%K{default}%F{default}%}"

# Usage:
# power_lsegment <text> <text_color> <bar_color> <next_color>
function power_lsegment {
  echo "%{%F{$2}%K{$3}%}$1 %{%F{$3}%K{$4}%}"$'\ue0b0'" $rst"
}

# Usage (right segments are added to the right):
# power_lsegment <text> <text_color> <bar_color> <prev_color>
function power_rsegment {
  echo "%{%F{$3}%K{$4}%}"$'\ue0b2'"%{%F{$2}%K{$3}%} $1 $rst"
}

function git_segment {
  git_prompt="$(git_prompt_info)"
  if [[ -n $git_prompt ]] ; then
    power_rsegment "$git_prompt" white 97 blue
  else
    echo ''
  fi
}

# Usage lprompt <user color> <addon string>
function lprompt {

  return_status='%(?.. \u26a1%?)'
  if [[ -z $2 ]] ; then
    user_string="%n"
  else
    user_string="%n $2"
  fi
  # %1~ is the last segment of the current path
  # %(?..xxx) is a conditional expansion
  PROMPT="\
$(power_lsegment " %(?.%F{154}\u2714%F{default}.%F{215}\u26a1%?%F{default})" white 69 gree)\
$(power_lsegment "%1~" white green $1)\
$(power_lsegment "$user_string" white $1 default)\
"
}

function ruby_version {
  ruby_b="$(rbenv_prompt_info '%b')"
  if [[ -z $ruby_b ]] ; then
    echo 'no ruby'
  else
    echo $ruby_b
  fi
}

function rprompt {
  git_b='$(git_segment)'
  ruby_b='$(ruby_version)'

  RPROMPT="\
$(power_rsegment '${PWD/$HOME/~}' white 97 default)\
$(power_rsegment "$ruby_b" white blue 97)\
$git_b"
}

if [ $UID -eq 0 ]; then
    lprompt red '*'
    rprompt
elif [ "$TERM" = "screen" ]; then
    lprompt cyan "[screen]"
    rprompt
elif [ -v TMUX ]; then
    lprompt cyan "[tmux]"
elif [ -n "$SSH_TTY" ]; then
    lprompt magenta
    rprompt
else
    lprompt blue
    rprompt
fi


unset rst

# ------------------------------
# http://dotfiles.org/~frogb/.zshrc

case $TERM in
    xterm* | rxvt* | urxvt*)
        precmd() {
                print -Pn "\e]0;%n@%m: %~\a"
        }
        preexec() {
                #print -Pn "\e]0;$1\a"
                print -Pn "\e]0;%n@%m: %~  $1\a"
        }
        ;;
    screen*)
        precmd() {
                print -nR $'\033k'"zsh"$'\033'\\\

                print -nR $'\033]0;'"zsh"$'\a'
        }
        preexec() {
                print -nR $'\033k'"$1"$'\033'\\\

                print -nR $'\033]0;'"$1"$'\a'
        }
        ;;
esac
