#
# Adds GitHub knowledge to the Git command.
# https://github.com/defunkt/hub
#
# Authors:
#   Chris Wanstrath <chris@wanstrath.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

if (( $+commands[hub] )); then
  function git {
    hub "$@"
  }
else
  # The most important function of hub
  function git {
    if [[ "$1" == "clone" && "$2" =~ "^[^\/\@\:]+\/[^\/]+$" ]]; then
      command git clone git://github.com/"$2".git "${(@)argv[3,-1]}"
    else
      command git "$@"
    fi
  }
fi

