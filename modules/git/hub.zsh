#
# Adds GitHub knowledge to the Git command.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   dnuux <dnuuxx@gmail.com>
#

# The most important function of hub
function git {
  if [[ "$1" == "clone" && "$2" =~ "^[^\/\@\:]+\/[^\/]+$" ]]; then
    command git clone git://github.com/"$2".git "${(@)argv[3,-1]}"
  else
    command git "$@"
  fi
}

