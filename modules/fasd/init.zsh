#
# Maintains a frequently used file and directory list for fast access.
#
# Authors:
#   Wei Dai <x@wei23.net>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Return if requirements are not found.
if (( ! $+commands[fasd] )); then
  return 1
fi

#
# Initialization
#

cache_file="${0:h}/cache.zsh"
if [[ "${commands[fasd]}" -nt "$cache_file" || ! -s "$cache_file" ]]; then
  # Set the base init arguments.
  init_args=(posix-alias zsh-hook)

  # Set fasd completion init arguments, if applicable.
  if zstyle -t ':prezto:module:completion' loaded; then
    init_args+=(zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)
  fi

  # Cache init code.
  fasd --init "$init_args[@]" >! "$cache_file" 2> /dev/null
fi

source "$cache_file"

unset cache_file init_args

#
# Aliases
#

alias j='z'                       # For autojump converts.
alias v='f -t -e vim -b viminfo'  # Quickly open files with vim.

#
# Key Bindings
#

for keymap in 'emacs' 'viins'; do
  # C-x C-a completes files and direcotries.
  bindkey -M "$keymap" "$key_info[Control]X$key_info[Control]A" fasd-complete

  # C-x C-d completes directories.
  bindkey -M "$keymap" "$key_info[Control]X$key_info[Control]D" fasd-complete-d

  # C-x C-f completes files.
  bindkey -M "$keymap" "$key_info[Control]X$key_info[Control]F" fasd-complete-f
done

