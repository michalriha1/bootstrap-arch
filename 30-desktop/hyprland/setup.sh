#!/usr/bin/env bash
set -euo pipefail
source "${BOOTSTRAP_ROOT}/lib.sh"

install_packages \
    hyprpolkitagent \
    wl-clipboard \
    cliphist \
    wlsunset \
    brightnessctl \
    hypridle

hypr_config="${HOME}/.config/hypr"
source_config="${MODULE_DIR}/config"

backup_path "$hypr_config"

info "Deploying Hyprland config..."
mkdir -p "$hypr_config"
cp -r "${source_config}/." "$hypr_config/"
success "Hyprland config deployed"
