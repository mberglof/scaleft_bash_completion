#!/usr/bin/env bash
# vim: ts=2 sw=2 et

# For each of the words, get options with pcregrep -o -- '--\w+-?(\w+)?'

WORDS=$(sft -h | pcregrep -o '^     \w+(-?)(\w+)?' | sed -e 's/^     //' | tr "\n" " ")

# Use global array for caching of hosts
SERVERS=()

# Get servers, minus header
# This should work even if you are not logged in
_sft_list_servers() {
  while IFS='' read -r line; do SERVERS+=("$line"); done < <(sft list-servers --columns hostname 2> /dev/null | tail -n +2)
}

_sft_completions() {
  local cur prev

  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}

  case ${COMP_CWORD} in
    1)
      COMPREPLY=($(compgen -W "$WORDS" -- "${cur}"))
      ;;
    2)
      case ${prev} in
        ssh)
          if [ ${#SERVERS} -lt 1 ]; then
            _sft_list_servers
          fi
          COMPREPLY=($(compgen -W "${SERVERS[*]}" -- "${cur}"))
          ;;
      esac
  esac

  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi
  # COMPREPLY=($(compgen -W "$WORDS" -- "${COMP_WORDS[1]}"))
}

complete -F _sft_completions sft
