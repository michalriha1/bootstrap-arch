#!/usr/bin/env bash
set -euo pipefail
source "${BOOTSTRAP_ROOT}/lib.sh"

ssh_key="${HOME}/.ssh/id_ed25519"

mkdir -p "${HOME}/.ssh"
backup_path "$ssh_key"
backup_path "${ssh_key}.pub"

info "Generating SSH key..."
ssh-keygen -t ed25519 -f "$ssh_key" -N ""
success "SSH key generated at $ssh_key"
