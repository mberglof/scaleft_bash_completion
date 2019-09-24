#!/usr/bin/env bash
# vim: ts=2 sw=2 et

# For each of the words, get options with pcregrep -o -- '--\w+-?(\w+)?'


# Use global array for caching of hosts
SERVERS=()

# Get servers, minus header
# This should work even if you are not logged in
_sft_list_servers() {
  while IFS='' read -r line; do SERVERS+=("$line"); done < <(sft list-servers --columns hostname 2> /dev/null | tail -n +2)
}

_sft_options() {
  return  
}

_sft_completions() {
  local cur prev opts
  COMPREPLY=()

  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}
  opts=$(sft -h | pcregrep -o '^     \w+(-?)(\w+)?' | sed -e 's/^     //' | tr "\n" " ")


  case ${COMP_CWORD} in
    1)
      if [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "$(sft -h | pcregrep -o -- '--\w+-?(\w+)?')" -- "${cur}") )
        return 0
      else
        COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
      fi
      ;;
    2)
      if [[ ${cur} == -* ]] ; then
            COMPREPLY=( $(compgen -W "$(sft ${prev} -h | pcregrep -o -- '--\w+-?(\w+)?')" -- "${cur}") )
            return 0
      fi
      case ${prev} in
        ssh)
          if [ ${#SERVERS} -lt 1 ]; then
            _sft_list_servers
          fi
          COMPREPLY=($(compgen -W "${SERVERS[*]}" -- "${cur}"))
          return 0
          ;;
      esac
      ;;
    3)
      COMPREPLY=($(compgen -W "$(sft ${prev} -h | pcregrep -o -- '--\w+-?(\w+)?')" -- "${cur}"))
      ;;
  esac

  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    #COMPREPLY=($(compgen -W "$(sft ${prev} -h | pcregrep -o -- '--\w+-?(\w+)?')" -- "{cur}"))
    return
  fi
  COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
  return 0
}

complete -F _sft_completions sft
