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

# Use with device.mk file
get_device_tree_dir() {
  local content=$1
  if [[ $content =~ LOCAL_PATH[[:space:]]*:=[[:space:]]*([^[:space:]#]+) ]]; then
      device_tree_dir="${BASH_REMATCH[1]}"
      echo "$device_tree_dir"
  else
      echo "LOCAL_PATH not found (device.mk)" >&2
      exit 1
  fi
}

content=$(get_input "$@")
get_device_tree_dir "$content"
