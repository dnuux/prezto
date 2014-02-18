#
# Defines abbreviations for common commands.
#
# Authors:
#   trapd00r <m@japh.se>
#   dnuux <dnuuxx@gmail.com>
#

typeset -Ag abbreviations
abbreviations=(
  "jj"    "!$"
  "jk"    "!-2$"
  "Ia"    "| awk"
  "Ic"    "| pbcopy"
  "Ig"    "| grep"
  "Ih"    "| head"
  "Il"    "| $PAGER"
  "Ip"    "| pbpaste"
  "Is"    "| sort"
  "It"    "| tail"
  "Iv"    "| $EDITOR -"
  "Iw"    "| wc"
  "Ix"    "| xargs"
)

magic-abbrev-expand() {
  local MATCH
  LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
  LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
  zle self-insert
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand

