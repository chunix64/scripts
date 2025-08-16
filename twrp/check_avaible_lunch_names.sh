#!/bin/bash
set -euo pipefail

TMP_TABLE="/tmp/devices_table.txt"

build_table() {
  local devices_dir="$1"
  local script_path="./get_lunch_names.sh"
  echo -e "Manufacturer\tDevice\tLunch Names"

  for manufacturer_dir in "$devices_dir"/*; do
    [[ -d $manufacturer_dir ]] || continue
    local manufacturer="${manufacturer_dir##*/}"

    for device_dir in "$manufacturer_dir"/*; do
      [[ -d $device_dir ]] || continue
      local device="${device_dir##*/}"
      local android_products="$device_dir/AndroidProducts.mk"

      [[ -f $android_products ]] || continue

      local lunch_names
      if [[ -f $script_path ]]; then
        lunch_names=$(bash "$script_path" "$android_products")
      else
        lunch_names=$(bash <(curl -fsSL \
          https://github.com/chunix64/scripts/raw/refs/heads/main/twrp/get_lunch_names.sh) \
          "$android_products")
      fi
      [[ -z $lunch_names ]] && continue

      # Print variants
      local first=1
      for variant in $lunch_names; do
        if (( first )); then
          echo -e "$manufacturer\t$device\t$variant"
          first=0
        else
          echo -e "\t\t$variant"
        fi
      done
    done
  done
}

show_table() {
  column -t -s $'\t' "$1"
}

main() {
  local devices_dir="$1/device"
  build_table "$devices_dir" > "$TMP_TABLE"
  show_table "$TMP_TABLE"
}

main "$@"
