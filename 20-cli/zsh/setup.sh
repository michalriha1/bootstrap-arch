#!/usr/bin/env bash
set -euo pipefail
source "${BOOTSTRAP_ROOT}/lib.sh"

install_packages zsh

# oh-my-zsh
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
    info "Installing oh-my-zsh (unattended)..."
    RUNZSH=no CHSH=no sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        "" --unattended
    success "oh-my-zsh installed"
else
    skip "oh-my-zsh already installed"
fi

zsh_custom="${HOME}/.oh-my-zsh/custom"

# powerlevel10k theme
p10k_dir="${zsh_custom}/themes/powerlevel10k"
if [[ ! -d "$p10k_dir" ]]; then
    info "Cloning powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    success "powerlevel10k cloned"
else
    skip "powerlevel10k already cloned"
fi

# extra plugins
for repo in \
    "https://github.com/zsh-users/zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-syntax-highlighting"; do
    name="$(basename "$repo")"
    dest="${zsh_custom}/plugins/${name}"
    if [[ ! -d "$dest" ]]; then
        info "Cloning $name..."
        git clone --depth=1 "$repo" "$dest"
        success "$name cloned"
    else
        skip "$name already cloned"
    fi
done

# configs
backup_path "${HOME}/.zshrc"
cp "${MODULE_DIR}/config/zshrc" "${HOME}/.zshrc"
success ".zshrc deployed"

backup_path "${HOME}/.p10k.zsh"
cp "${MODULE_DIR}/config/p10k.zsh" "${HOME}/.p10k.zsh"
success ".p10k.zsh deployed"

# default login shell
zsh_bin="$(command -v zsh)"
current_shell="$(getent passwd "$USER" | cut -d: -f7)"
if [[ "$current_shell" != "$zsh_bin" ]]; then
    info "Changing default shell to $zsh_bin (will prompt for password)..."
    chsh -s "$zsh_bin"
    success "Default shell changed to zsh"
else
    skip "Default shell already zsh"
fi
