typeset -Ag abbreviations
abbreviations=(
  "jj"    "!$"
  "Ia"    "| awk"
  "Ic"    "| pbcopy"
  "Ie"    "| egrep"
  "If"    "| fgrep"
  "Ig"    "| grep"
  "Ih"    "| head"
  "Il"    "| $PAGER"
  "Ip"    "| pbpaste"
  "Is"    "| sort"
  "It"    "| tail"
  "Iu"    "| uniq"
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

