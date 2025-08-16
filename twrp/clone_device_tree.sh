#!/bin/bash
set -euo pipefail

get_github_urls() {
    local url="$1"
    local branch="$2"
    local repo_path username repo
    repo_path=$(echo "$url" | sed -E 's|^https?://github.com/||; s|/$||')
    username=$(echo "$repo_path" | cut -d'/' -f1)
    repo=$(echo "$repo_path" | cut -d'/' -f2)
    echo "https://github.com/$username/$repo" \
         "https://raw.githubusercontent.com/$username/$repo/$branch/device.mk" \
         "https://raw.githubusercontent.com/$username/$repo/$branch/AndroidProducts.mk"
}

get_device_tree_dir() {
    local device_mk_url="$1"
    local script_path="./get_device_tree_dir.sh"

    curl -fsS "$device_mk_url" -o /tmp/device.mk || return 1

    if [[ -f "$script_path" ]]; then
        bash "$script_path" /tmp/device.mk
    else
        bash <(curl -fssL https://github.com/chunix64/scripts/raw/refs/heads/main/twrp/get_device_tree_dir.sh) /tmp/device.mk
    fi
}

clone_device_tree() {
    local git_url="$1" branch="$2" target_dir="$3" delete_old="$4"
    if [[ -d "$target_dir" && "$delete_old" =~ ^[Tt][Rr][Uu][Ee]$ ]]; then
    rm -rf "$target_dir"
    fi
    mkdir -p "$target_dir"
    git clone -b "$branch" "$git_url" "$target_dir"
}

get_lunch_names() {
    local android_products_url="$1"
    local script_path="./get_lunch_names.sh"
    curl -fsS "$android_products_url" -o /tmp/AndroidProducts.mk || return 1

    if [[ -f "$script_path" ]]; then
        bash "$script_path" /tmp/AndroidProducts.mk
    else
        bash <(curl -fssL https://github.com/chunix64/scripts/raw/refs/heads/main/twrp/get_lunch_names.sh) /tmp/AndroidProducts.mk
    fi
}

main() {
    local twrp_source_dir="$1"
    local device_tree_url="$2"
    local branch="${3:-main}"
    local delete_old="${4:-true}"
    
    read git_url device_mk_url android_products_mk_url < <(get_github_urls "$device_tree_url" "$branch")
    
    local device_dir
    device_dir=$(get_device_tree_dir "$device_mk_url") || { echo "❌ Error: device.mk not found or invalid."; exit 1; }
    echo "✅ Found device tree path: $device_dir"

    local clone_target="$twrp_source_dir/$device_dir"
    clone_device_tree "$git_url" "$branch" "$clone_target" "$delete_old" || { echo "❌ Error: Failed to clone device tree."; exit 1; }
    echo "✅ Device tree cloned at: $clone_target"

    local lunch_names
    if lunch_names=$(get_lunch_names "$android_products_mk_url"); then
        echo "🌿 Found product variants for $device_dir:"
        if [[ -n $lunch_names ]]; then
          echo "$lunch_names" | tr ' ' '\n' | sed 's/^/ • /'
        else
          echo "⚠️ No lunch names found."
        fi
    else
        echo "⚠️ Warning: AndroidProducts.mk not found or invalid."
    fi
}

main "$@"

