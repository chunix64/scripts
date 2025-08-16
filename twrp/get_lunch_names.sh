#!/bin/bash
set -euo pipefail

# Read input: file argument, raw text, or stdin
get_input() {
  if [[ $# -gt 0 && -f $1 ]]; then
      # Case 1: argument is a file
      content=$(<"$1")
  elif [[ $# -gt 0 ]]; then
      # Case 2: argument is raw text
      content="$1"
  else
      # Case 3: read from stdin
      content=$(cat)
  fi

  echo "$content"
}

# Use with AndroidProducts.mk file
get_lunch_names() {
    local content=$1
    # grep -oE extracts all matches on separate lines
    mapfile -t matches < <(grep -oE '\b([[:alnum:]_]+-[[:alnum:]-]+)\b' <<< "$content")
    echo "${matches[@]}"
}

content=$(get_input "$@")
get_lunch_names "$content"
