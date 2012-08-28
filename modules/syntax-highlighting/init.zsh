#
# Integrates zsh-syntax-highlighting into Oh My Zsh.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Return if requirements are not found.
if ! zstyle -t ':omz:module:syntax-highlighting' color; then
  return 1
fi

# Source module files.
source "${0:h}/external/zsh-syntax-highlighting.zsh"

# Set the highlighters.
zstyle -a ':omz:module:syntax-highlighting' highlighters 'ZSH_HIGHLIGHT_HIGHLIGHTERS'
if (( ${#ZSH_HIGHLIGHT_HIGHLIGHTERS[@]} == 0 )); then
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)
fi

# Aliases and functions
ZSH_HIGHLIGHT_STYLES[alias]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'

# Commands and builtins
ZSH_HIGHLIGHT_STYLES[command]="fg=blue,bold"
ZSH_HIGHLIGHT_STYLES[hashed-command]="fg=blue,bold"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=blue,bold"

# Paths
ZSH_HIGHLIGHT_STYLES[path]='fg=green,bold'

# Globbing
ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow,bold'

# Options and arguments
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=yellow'

ZSH_HIGHLIGHT_STYLES[back-quoted-argument]="fg=green"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=green"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=green"
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=green"
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=green"

# Patterns
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf' 'fg=white,bold,bg=red')

