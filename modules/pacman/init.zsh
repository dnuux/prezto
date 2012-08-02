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

# Find out which package owns a file.
function owns {
  local owned=$(which -p "$1")
  if (( $? )); then
    pacman -Qo "$1"
  else
    pacman -Qo "$owned"
  fi
}

# Aliases
alias ai='archinfo'
alias build='makepkg -fi --skipinteg --clean'

