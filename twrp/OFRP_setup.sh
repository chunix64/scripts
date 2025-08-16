#!/bin/bash

setup_environment() {
  cd ~
  sudo apt install git aria2 -y
  git clone https://gitlab.com/OrangeFox/misc/scripts
  cd scripts
  sudo bash setup/android_build_env.sh
  sudo bash setup/install_android_sdk.sh

  # Fake github identify
  git config --global user.name "teto123"
  git config --global user.email "teto@teto.teto"
}

sync_orangefox() {
  local ofrp_branch=$1
  local ofrp_dir=$2

  if [[ -z "$ofrp_dir" ]]; then
    ofrp_dir="~/OrangeFox"
  fi
  
  mkdir ~/OrangeFox_sync
  cd ~/OrangeFox_sync
  git clone https://gitlab.com/OrangeFox/sync.git # (or, using ssh, "git clone git@gitlab.com:OrangeFox/sync.git")
  cd ~/OrangeFox_sync/sync/
  yes | ./orangefox_sync.sh --branch "$ofrp_branch" --path "$ofrp_dir"
}

main() {
  setup_environment
  sync_orangefox "$1" "$2"
}

main "$@" 
