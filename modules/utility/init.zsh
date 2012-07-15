#
# Defines general aliases and functions.
#
# Authors:
#   Robby Russell <robby@planetargon.com>
#   Suraj N. Kurapati <sunaku@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Load dependencies.
omodload 'spectrum'

# Correct commands.
setopt CORRECT

# Aliases

# Disable correction.
alias ack='nocorrect ack'
alias cd='nocorrect cd'
alias cp='nocorrect cp'
alias gcc='nocorrect gcc'
alias grep='nocorrect grep'
alias ln='nocorrect ln'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias rm='nocorrect rm'
alias scp='nocorrect scp'

# Disable globbing.
alias calc='noglob calc'
alias fc='noglob fc'
alias find='noglob find'
alias history='noglob history'
alias locate='noglob locate'

# Define general aliases.
alias _='sudo'
alias agrep='agrep -2i'
alias b='${(z)BROWSER}'
alias cal='cal -m'
alias cdd='cd -'
alias die='pkill -9'
alias e='${(z)EDITOR}'
alias exe='chmod +x'
alias h='history'
alias ln="${aliases[ln]:-ln} -i"
alias memcheck='valgrind --leak-check=full --show-reachable=yes'
alias mkdir="${aliases[mkdir]:-mkdir} -p"
alias myip='curl http://icanhazip.com'
alias nocomment='egrep -v "^\s*(#|$)"'
alias off='xset dpms force off'
alias p='${(z)PAGER}'
alias path='echo -e ${PATH//:/\\n}'
alias pf='ps aux | grep -i'
alias pg='ping -c 1 google.com | tail -3'
alias play='cmus-remote -o && mplayer -really-quiet'
alias po='popd'
alias ports='netstat --numeric --programs --inet'
alias pu='pushd'
alias redshift='redshift -l 60.1:24.5 -t 6500:4500 -b 0.9 -m vidmode'
alias t='t --task-dir ~/tasks --delete-if-empty'
alias type='type -a'
alias undo='undo -i'
alias vi='vim'
alias wall='feh --bg-scale'
alias x='extract'
alias xl='ls-archive'

# Define suffix aliases.
alias -s {htm,html,php}="$BROWSER"
alias -s {txt,c,cpp,h,conf,cfg}="$EDITOR"
alias -s {jpg,jpeg,bmp,gif,png}="feh"
alias -s pdf="zathura"

# ls
if (( $+commands[ls++] )); then
  alias ls='ls++'
else
  if is-callable 'dircolors'; then
    # GNU Core Utilities
    alias ls='ls --group-directories-first'

    if zstyle -t ':omz:module:utility:ls' color; then
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
    if zstyle -t ':omz:module:utility:ls' color; then
      export LSCOLORS="exfxcxdxbxegedabagacad"
      alias ls="ls -G"
    else
      alias ls='ls -F'
    fi
  fi
fi

alias l='ls'             # Darn fast fingers.
alias ll='ls -lh'        # Lists human readable sizes.
alias lr='ll -R'         # Lists human readable sizes, recursively.
alias la='ll -A'         # Lists human readable sizes, hidden files.
alias lm='la | "$PAGER"' # Lists human readable sizes, hidden files through pager.
alias lx='ll -XB'        # Lists sorted by extension (GNU only).
alias lk='ll -Sr'        # Lists sorted by size, largest last.
alias lt='ll -tr'        # Lists sorted by date, most recent last.
alias lc='lt -c'         # Lists sorted by date, most recent last, shows change time.
alias lu='lt -u'         # Lists sorted by date, most recent last, shows access time.
alias sl='ls'            # I often screw this up.

# Mac OS X Everywhere
if [[ "$OSTYPE" == darwin* ]]; then
  alias o='open'
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
else
  alias o='xdg-open'
  alias get='wget --continue --progress=bar --timestamping'

  if (( $+commands[xsel] )); then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
  fi

  if (( $+commands[xclip] )); then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  fi
fi

alias pbc='pbcopy'
alias pbp='pbpaste'

# Resource Usage
alias df='df -kh'
alias du='du -kh'

if (( $+commands[htop] )); then
  alias top=htop
else
  alias topc='top -o cpu'
  alias topm='top -o vsize'
fi

# This is so idiotic.
if (( $+commands[python2] )); then
  alias python='python2'
  alias ipython='ipython2'
fi

# Miscellaneous

# Serves a directory via HTTP.
alias http-serve='python -m SimpleHTTPServer'

# Functions

# Makes a directory and changes to it.
function mkdcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

# Changes to a directory and lists its contents.
function cdl {
  builtin cd "${@:-$HOME}" && ls "${(@)argv[1,-2]}"
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
  ps -u "${1:-$USER}" -o 'pid,%cpu,%mem,command' "${(@)argv[2,-1]}"
}

# Handy calculator.
function calc {
  awk "BEGIN { print $@ }"
}

# Go up the directory hierarchy.
function up {
  for parent in {1..${1:-1}}; do
    builtin cd ..
  done
}

# Set the CPU governor.
function cpu {
  for i in 0 1; do
    sudo cpufreq-set -c $i -g $1
  done
}

# Swap two filenames.
function swap {
  local tmpfile=tmp.$$
  mv "$1" $tmpfile
  mv "$2" "$1"
  mv $tmpfile "$2"
}

# Replace spaces with underscores in filenames.
function remove_spaces {
  while (( $# )); do
    mv "$1" `echo "$1" | tr ' ' _`
    shift
  done
}

# Backup documents from a remote computer.
function backup {
  rsync -avz -e ssh "$1":Documents/ "$HOME/backups/$1"
}

# Remove short MP3 files in current directory.
function delete_short_mp3 {
  for file in *.mp3; do
    if (( $(mp3info -p "%S" "$file") < ${1:-60} )); then
      rm "$file"
    fi
  done
}

# Convert a video file to an MP3 file.
function tomp3 {
  ffmpeg -i "$1" -vn -ac 2 -ar 44100 -ab 320k -f mp3 "${2:-${1%.*}.mp3}"
}

# Compile Zsh files.
function zc {
  find "$HOME/.oh-my-zsh/" -iname '*.zsh' -print0 | xargs -P2 -0 -i zsh -c "zcompile '{}'"
  for rcfile in shenv shrc login profile; do
    zcompile "$HOME/.z${rcfile}"
  done
}

