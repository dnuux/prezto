#
# Defines general aliases and functions.
#
# Authors:
#   Robby Russell <robby@planetargon.com>
#   Suraj N. Kurapati <sunaku@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   dnuux <dnuuxx@gmail.com>
#

# Load dependencies.
pmodload 'helper' 'spectrum'

# Correct commands.
setopt CORRECT

#
# Aliases
#

# Disable correction.
alias cd='nocorrect cd'
alias cp='nocorrect cp'
alias gcc='nocorrect gcc'
alias grep='nocorrect grep'
alias ln='nocorrect ln'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias rm='nocorrect rm'

# Disable globbing.
alias calc='noglob calc'
alias fc='noglob fc'
alias find='noglob find'
alias history='noglob history'
alias locate='noglob locate'
alias rsync='noglob rsync'
alias scp='noglob scp'

# Define general aliases.
alias _='sudo'
alias b='${(z)BROWSER}'
alias cdd='cd -'
alias exe='chmod +x'
alias h='history'
alias ln="${aliases[ln]:-ln} -i"
alias mkdir="${aliases[mkdir]:-mkdir} -p"
alias nocomment='egrep -v "^\s*(#|$)"'
alias p='${(z)PAGER}'
alias pac='pacaur'
alias po='popd'
alias pu='pushd'
alias r='PYTHONOPTIMIZE=2 /usr/bin/ranger'
alias x='unarchive'
alias xls='lsarchive'

# Define suffix aliases.
alias -s {htm,html,php}="$BROWSER"
alias -s {txt,c,cpp,h,hs,conf,cfg}="$EDITOR"
alias -s {jpg,jpeg,bmp,gif,png}="sxiv"
alias -s {aac,avi,flv,mkv,mp3,mp4}="mpv"
alias -s pdf="zathura"

# ls
if is-callable 'dircolors'; then
  # GNU Core Utilities
  alias ls='ls --group-directories-first'

  if zstyle -t ':prezto:module:utility:ls' color; then
    if [[ -s "$HOME/.dir_colors" ]]; then
      eval "$(dircolors "$HOME/.dir_colors")"
    else
      eval "$(dircolors)"
    fi

    alias ls="$aliases[ls] --color=auto"
  else
    alias ls="$aliases[ls] -F"
  fi
else
  # BSD Core Utilities
  if zstyle -t ':prezto:module:utility:ls' color; then
    # Define colors for BSD ls.
    export LSCOLORS='exfxcxdxbxGxDxabagacad'

    # Define colors for the completion system.
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

    alias ls='ls -G'
  else
    alias ls='ls -F'
  fi
fi

if (( $+commands[ls++] )); then
  alias ls='ls++'
fi

alias l='ls'             # Darn fast fingers.
alias ll='ls -lh'        # Lists human readable sizes.
alias lr='ll -R'         # Lists human readable sizes, recursively.
alias la='ll -A'         # Lists human readable sizes, hidden files.
alias lm='la | "$PAGER"' # Lists human readable sizes, hidden files through pager.
alias lx='ll -XB'        # Lists sorted by extension (GNU only).
alias lk='ll -Sr'        # Lists sorted by size, largest last.
alias lt='ll -tr'        # Lists sorted by date, most recent last.
alias sl='ls'            # I often screw this up.

# Mac OS X Everywhere
if [[ "$OSTYPE" == darwin* ]]; then
  alias o='open'
elif [[ "$OSTYPE" == cygwin* ]]; then
  alias o='cygstart'
  alias pbcopy='tee > /dev/clipboard'
  alias pbpaste='cat /dev/clipboard'
else
  alias o='xdg-open'

  if (( $+commands[xsel] )); then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
  elif (( $+commands[xclip] )); then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  fi
fi

alias pbc='pbcopy'
alias pbp='pbpaste'

# File Download
if (( $+commands[curl] )); then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
elif (( $+commands[wget] )); then
  alias get='wget --continue --progress=bar --timestamping'
fi

# Resource Usage
alias df='df -kh'
alias du='du -kh'

if (( $+commands[htop] )); then
  alias top=htop
else
  alias topc='top -o cpu'
  alias topm='top -o vsize'
fi

# Valgrind
if (( $+commands[valgrind] )); then
  alias memcheck='valgrind --leak-check=full'
  alias callgrind='valgrind --tool=callgrind'
  alias cachegrind='valgrind --tool=cachegrind'
fi

# Miscellaneous

# Serves a directory via HTTP.
alias http-serve='python -m http.server'

#
# Functions
#

# Makes a directory and changes to it.
function mkdcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

# Changes to a directory and lists its contents.
function cdl {
  builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Pushes an entry onto the directory stack and lists its contents.
function pushdls {
  builtin pushd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Pops an entry off the directory stack and lists its contents.
function popdls {
  builtin popd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Prints columns 1 2 3 ... n.
function slit {
  awk "{ print ${(j:,:):-\$${^@}} }"
}

# Finds files and executes a command on them.
function find-exec {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# Displays user owned processes status.
function psu {
  ps -U "${1:-$USER}" -o 'pid,%cpu,%mem,command' "${(@)argv[2,-1]}"
}

# Handy calculator.
function calc {
  if (( $+commands[bc] )); then
    bc <<< "scale=4; $@"
  else
    awk "BEGIN { print $@ }"
  fi
}

# Go up the directory hierarchy.
function up {
  for parent in {1..${1:-1}}; do
    builtin cd ..
  done
}

# Compile Zsh files.
function zc {
  find "${ZDOTDIR:-$HOME}/.zprezto" -type f -name '*.zsh' -print0 \
    | xargs -P2 -0 -i zsh -c "zcompile '{}'"
  for rcfile in shenv shrc login profile preztorc; do
    [[ -r "$HOME/.z${rcfile}" ]] && zcompile "$HOME/.z${rcfile}"
  done
}

# Watch live television.
function tv {
  mpv -quiet "$(yle-dl --showurl http://areena.yle.fi/tv/suora/$1)"
}

