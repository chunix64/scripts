#!/bin/bash

setup_environment() {
  cd ~
  sudo apt install git aria2 -y

  # --- Install repo ---
  sudo mkdir -p /usr/local/bin
  sudo curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo
  sudo chmod a+x /usr/local/bin/repo

  # Fake github identify
  git config --global user.name "teto123"
  git config --global user.email "teto@teto.teto"
}

sync_pitch_black() {
  local pitch_black_branch=$1
  local pitch_black_dir=$2

  if [[ -z "$pitch_black_dir" ]]; then
    echo "⚠️ No PITCH_BLACK_FOLDER found."
    exit 1
  fi
 
  mkdir -p "$pitch_black_dir"
  cd "$pitch_black_dir"
  yes | repo init -u https://github.com/PitchBlackRecoveryProject/manifest_pb -b "$pitch_black_branch"
  yes | repo sync
}

main() {
  setup_environment
  sync_pitch_black "$1" "$2"
}

main "$@" 
