#!/usr/bin/env bash
set -euo pipefail
source "${BOOTSTRAP_ROOT}/lib.sh"

install_packages keyd

keyd_config="/etc/keyd/default.conf"
source_config="${MODULE_DIR}/config/default.conf"

sudo mkdir -p /etc/keyd
backup_path "$keyd_config" sudo

info "Deploying keyd config..."
sudo cp "$source_config" "$keyd_config"
success "Keyd config deployed"

if ! systemctl is-enabled keyd &>/dev/null; then
    info "Enabling keyd.service..."
    sudo systemctl enable --now keyd
    success "keyd.service enabled"
else
    skip "keyd.service already enabled"
fi
