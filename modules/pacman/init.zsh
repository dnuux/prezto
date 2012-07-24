#
# Defines Pacman aliases.
#
# Authors:
#   Benjamin Boudreau <dreurmail@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# Tips:
#   https://wiki.archlinux.org/index.php/Pacman_Tips
#

# Functions

# Pacman wrapper.
function pac {
  pacaur "$@"
  [[ "$1" =~ "S[y]*u" ]] && echo "" > "$HOME/.pacmanupdates"
}

# Find out which package owns a file.
function owns {
  local owned=$(which -p $1)
  if [[ $? == 0 ]]; then
    pacman -Qo "$owned"
  else
    pacman -Qo $1
  fi
}

# Aliases
alias ai='archinfo'
alias build='makepkg -fi --skipinteg --clean'

