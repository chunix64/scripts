#!/bin/bash
setup_build_environment() {
  local twrp_source_dir="$1"
  local lunch_name="$2"

  # Extract device name from lunch_name (e.g., twrp_CK6n-eng → CK6n)
  local device_name="${lunch_name#*_}"   # remove prefix up to first "_"
  device_name="${device_name%%-*}"       # remove suffix from first "-"

  export ALLOW_MISSING_DEPENDENCIES=true
  export FOX_BUILD_DEVICE="$device_name"
  export LC_ALL=C

  source "$twrp_source_dir/build/envsetup.sh"
}

build_twrp() {
  local lunch_name="$1"
  local recovery_type="$2"
  lunch "$lunch_name"
  mka adbd "$recovery_type"
}

main() {
  local twrp_source_dir="$1"
  local lunch_name="$2"
  local recovery_type="$3"

  setup_build_environment "$twrp_source_dir" "$lunch_name"
  build_twrp "$lunch_name" "$recovery_type"
}

main "$@"

