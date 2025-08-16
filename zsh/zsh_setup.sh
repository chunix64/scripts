#!/bin/sh

# Install Zsh and Oh My Zsh
apt install zsh -y

bash <(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)

# Clone new theme and plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

rm ~/.zshrc
curl -fsSL "https://github.com/chunix64/scripts/raw/refs/heads/main/zsh/.zshrc" -o ~/.zshrc
