#!/usr/bin/env bash
# =============================================================================
#  LEVIATHAN — Offensive Security Provisioner (Docker Edition)
#  Bug Bounty • Red Team • Pentest • Recon
#
#  Creator : Felipe "l1m4" Lima
#  Github  : https://github.com/flfelipelima
#  Linkedin: https://www.linkedin.com/in/flfelipelima
#
#  Build   : Docker Edition
#  Version : 1.0.0
# =============================================================================

set -euo pipefail

# ─── Colors ──────────────────────────────────────────────────────────────────
RED='\033[38;2;255;80;100m'
DARK='\033[38;2;20;20;20m'
GRAY='\033[38;2;90;90;90m'
GREEN='\033[38;2;80;255;160m'
YELLOW='\033[38;2;255;210;80m'
CYAN='\033[38;2;80;220;255m'
BOLD='\033[1m'
RESET='\033[0m'
PURPLE='\033[38;2;189;147;249m'

# ─── Config ──────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker/docker-compose.yml"
IMAGE_NAME="leviathan:latest"
CONTAINER_NAME="leviathan"
WORDLIST_VOLUME="leviathan_wordlists"

# ─── Banner ──────────────────────────────────────────────────────────────────
banner() {
  echo -e "${RED}"
  cat <<'BANNER'
 ██╗     ███████╗██╗   ██╗██╗ █████╗ ████████╗██╗  ██╗ █████╗ ███╗   ██╗
 ██║     ██╔════╝██║   ██║██║██╔══██╗╚══██╔══╝██║  ██║██╔══██╗████╗  ██║
 ██║     █████╗  ██║   ██║██║███████║   ██║   ███████║███████║██╔██╗ ██║
 ██║     ██╔══╝  ╚██╗ ██╔╝██║██╔══██║   ██║   ██╔══██║██╔══██║██║╚██╗██║
 ███████╗███████╗ ╚████╔╝ ██║██║  ██║   ██║   ██║  ██║██║  ██║██║ ╚████║
 ╚══════╝╚══════╝  ╚═══╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
BANNER
  echo -e "${PURPLE}                  OFFSEC PROJECT — DOCKER EDITION${RESET}"
  echo -e "${PURPLE}               Bug Bounty • Red Team • Pentest • Recon${RESET}"
  echo -e "${RED}─────────────────────────────────────────────────────────────────${RESET}"
  echo ""
}

# ─── Helpers ─────────────────────────────────────────────────────────────────
log_info()    { echo -e "${CYAN}[*]${RESET} $*"; }
log_ok()      { echo -e "${GREEN}[✔]${RESET} $*"; }
log_warn()    { echo -e "${YELLOW}[!]${RESET} $*"; }
log_error()   { echo -e "${RED}[✘]${RESET} $*" >&2; }
log_section() { echo -e "\n${RED}━━━ ${BOLD}$*${RESET}${RED} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"; }

check_docker() {
  if ! command -v docker &>/dev/null; then
    log_error "Docker is not installed."
    echo -e "  Install it: ${CYAN}sudo ./leviathan.sh install-docker${RESET}"
    exit 1
  fi

  if ! docker info &>/dev/null 2>&1; then
    log_error "Docker daemon is not running or you lack permissions."
    echo -e "  Try: ${CYAN}sudo systemctl start docker${RESET}"
    echo -e "  Or run with sudo / add your user to the docker group."
    exit 1
  fi

  if ! docker compose version &>/dev/null 2>&1 && ! command -v docker-compose &>/dev/null; then
    log_error "Docker Compose not found."
    echo -e "  Install Docker Compose plugin."
    exit 1
  fi
}

compose() {
  if docker compose version &>/dev/null 2>&1; then
    docker compose -f "$COMPOSE_FILE" "$@"
  else
    docker-compose -f "$COMPOSE_FILE" "$@"
  fi
}

container_exists() {
  docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"
}

container_running() {
  docker ps --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"
}

# ─── Install Docker ──────────────────────────────────────────────────────────
install_docker() {
  log_section "Installing Docker"

  if command -v docker &>/dev/null; then
    log_ok "Docker already installed: $(docker --version)"
    return
  fi

  if [[ $EUID -ne 0 ]]; then
    log_error "Installing Docker requires root."
    echo -e "  Use: ${CYAN}sudo ./leviathan.sh install-docker${RESET}"
    exit 1
  fi

  log_info "Installing Docker via official script..."
  curl -fsSL https://get.docker.com | sh

  local REAL_USER="${SUDO_USER:-$USER}"
  if [[ "$REAL_USER" != "root" ]]; then
    usermod -aG docker "$REAL_USER"
    log_ok "Added $REAL_USER to docker group — re-login to apply"
  fi

  systemctl enable --now docker
  log_ok "Docker installed and running"
}

# ─── Build ───────────────────────────────────────────────────────────────────
cmd_build() {
  log_section "Building Leviathan Image"
  check_docker

  log_info "Building ${IMAGE_NAME}..."
  compose build

  log_ok "Build complete: ${IMAGE_NAME}"
}

# ─── Start / Stop ────────────────────────────────────────────────────────────
cmd_up() {
  log_section "Starting Leviathan"
  check_docker

  compose up -d

  log_ok "Leviathan offensive workstation is online"
  echo -e "  Access the abyss with: ${CYAN}./leviathan.sh shell${RESET}"
}

cmd_down() {
  log_section "Stopping Leviathan"
  check_docker

  compose down

  log_ok "Leviathan stopped"
}

# ─── Shell into container ────────────────────────────────────────────────────
cmd_shell() {
  log_section "Leviathan Shell"
  check_docker

  if ! container_running; then
    log_warn "Container is not running. Starting Leviathan..."
    cmd_up
  fi

docker exec -it -e "TERM=xterm-256color" "$CONTAINER_NAME" zsh -l 2>/dev/null \
  || docker exec -it -e "TERM=xterm-256color" "$CONTAINER_NAME" bash -l
}

# ─── Run a tool directly ─────────────────────────────────────────────────────
cmd_run() {
  check_docker

  if [[ $# -eq 0 ]]; then
    log_error "Usage: ./leviathan.sh run <command>"
    echo -e "  Example: ${CYAN}./leviathan.sh run nmap -sV 127.0.0.1${RESET}"
    exit 1
  fi

  if ! container_running; then
    log_warn "Container is not running. Starting Leviathan..."
    cmd_up
  fi

  docker exec -it "$CONTAINER_NAME" "$@"
}

# ─── Logs ────────────────────────────────────────────────────────────────────
cmd_logs() {
  check_docker

  if ! container_exists; then
    log_error "Container does not exist yet."
    echo -e "  Run: ${CYAN}./leviathan.sh up${RESET}"
    exit 1
  fi

  docker logs -f "$CONTAINER_NAME"
}

# ─── Status ──────────────────────────────────────────────────────────────────
cmd_ps() {
  check_docker
  log_section "Container Status"

  docker ps -a --filter "name=${CONTAINER_NAME}"
}

# ─── Pull ────────────────────────────────────────────────────────────────────
cmd_pull() {
  log_section "Pull"
  log_warn "Leviathan now uses a local image: ${IMAGE_NAME}"
  log_info "Use: ./leviathan.sh build"
}

# ─── Wordlists ───────────────────────────────────────────────────────────────
cmd_wordlists() {
  log_section "Pulling Wordlists"
  check_docker

  log_info "Creating Docker volume: ${WORDLIST_VOLUME}"
  docker volume create "$WORDLIST_VOLUME" 2>/dev/null || true

  log_info "Downloading rockyou.txt and SecLists..."
  docker run --rm \
    -v "${WORDLIST_VOLUME}:/wordlists" \
    debian:bookworm-slim bash -c "
      set -e
      apt-get update -qq
      apt-get install -y -qq git wget ca-certificates 2>/dev/null

      if [[ ! -f /wordlists/rockyou.txt ]]; then
        wget -q https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt -O /wordlists/rockyou.txt
        echo 'rockyou.txt downloaded'
      else
        echo 'rockyou.txt already exists'
      fi

      if [[ ! -d /wordlists/SecLists ]]; then
        git clone -q --depth 1 https://github.com/danielmiessler/SecLists.git /wordlists/SecLists
        echo 'SecLists cloned'
      else
        echo 'SecLists already exists'
      fi
    "
}

# ─── Dracula Theme Installer ─────────────────────────────────────────────────
cmd_theme() {
  log_section "Installing Dracula Powerlevel10k Theme"

  check_docker

  log_info "Installing Dracula configs locally..."

  rm -rf /tmp/dracula-powerlevel10k

  git clone --depth=1 https://github.com/dracula/powerlevel10k.git \
    /tmp/dracula-powerlevel10k >/dev/null 2>&1

  cp /tmp/dracula-powerlevel10k/files/.zshrc \
    "$SCRIPT_DIR/configs/zshrc"

  cp /tmp/dracula-powerlevel10k/files/.p10k.zsh \
    "$SCRIPT_DIR/configs/p10k.zsh"

  log_ok "Dracula configs copied"

  log_info "Patching zshrc for Docker compatibility..."

  sed -i 's|export ZSH="/root/.oh-my-zsh"|if [[ -d "/root/.oh-my-zsh" ]]; then\
  export ZSH="/root/.oh-my-zsh"\
else\
  export ZSH="$HOME/.oh-my-zsh"\
fi|' "$SCRIPT_DIR/configs/zshrc"

  sed -i 's|source \$ZSH/oh-my-zsh.sh|[[ -f "$ZSH/oh-my-zsh.sh" ]] \&\& source "$ZSH/oh-my-zsh.sh"|' \
    "$SCRIPT_DIR/configs/zshrc"

  log_ok "zshrc patched"

  if container_running; then
    log_info "Installing Powerlevel10k inside container..."

    docker exec -it "$CONTAINER_NAME" bash -c '
      mkdir -p /root/.oh-my-zsh/custom/themes

      rm -rf /root/.oh-my-zsh/custom/themes/powerlevel10k

      git clone --depth=1 \
        https://github.com/romkatv/powerlevel10k.git \
        /root/.oh-my-zsh/custom/themes/powerlevel10k >/dev/null 2>&1
    '

    log_ok "Powerlevel10k installed inside container"

    log_info "Validating configs..."

    docker exec -it "$CONTAINER_NAME" zsh -n /root/.p10k.zsh

    log_ok "Theme validation successful"
  else
    log_warn "Container is not running."
    log_info "Start it with: ./leviathan.sh up"
  fi

  echo ""
  echo -e "${GREEN}Dracula Powerlevel10k installed successfully.${RESET}"
  echo ""
  echo -e "${CYAN}Recommended Nerd Fonts:${RESET}"
  echo "  • MesloLGS NF"
  echo "  • JetBrainsMono Nerd Font"
  echo ""
  echo -e "${CYAN}Windows Terminal:${RESET}"
  echo "  Settings → Profiles → Font Face"
  echo ""
  echo -e "${CYAN}Restart shell:${RESET}"
  echo "  ./leviathan.sh shell"
  echo ""
}

# ─── Full Setup ──────────────────────────────────────────────────────────────
cmd_install() {
  log_section "Full Install"

  if ! command -v docker &>/dev/null; then
    install_docker
  else
    log_ok "Docker present: $(docker --version)"
  fi

  cmd_build
  cmd_up
  cmd_wordlists

  log_section "Installation Complete"
  echo -e "${GREEN}"
  cat <<'DONE'
  ██████╗  ██████╗ ███╗   ██╗███████╗██╗
  ██╔══██╗██╔═══██╗████╗  ██║██╔════╝██║
  ██║  ██║██║   ██║██╔██╗ ██║█████╗  ██║
  ██║  ██║██║   ██║██║╚██╗██║██╔══╝  ╚═╝
  ██████╔╝╚██████╔╝██║ ╚████║███████╗██╗
  ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝
DONE
  echo -e "${RESET}"
  echo -e "${GRAY}  Leviathan Single Image Edition is ready.${RESET}"
  echo -e "${RED}  Run ${CYAN}./leviathan.sh shell${RED} to start hacking.${RESET}"
  echo ""
}

# ─── Help ────────────────────────────────────────────────────────────────────
show_help() {
  banner

  echo -e "${BOLD}${CYAN}USAGE${RESET}"
  echo -e "  ./leviathan.sh ${RED}<command>${RESET}"
  echo ""

  echo -e "${BOLD}${CYAN}SETUP COMMANDS${RESET}"
  echo ""
  printf "  ${RED}%-22s${RESET} %s\n" "install"        "Full setup: install Docker, build image, start container and pull wordlists"
  printf "  ${RED}%-22s${RESET} %s\n" "install-docker" "Install Docker engine only"
  printf "  ${RED}%-22s${RESET} %s\n" "build"          "Build leviathan:latest image"
  printf "  ${RED}%-22s${RESET} %s\n" "wordlists"      "Download rockyou.txt and SecLists into Docker volume"
  printf "  ${RED}%-22s${RESET} %s\n" "pull"           "Disabled: Leviathan uses a local image"
  printf "  ${RED}%-22s${RESET} %s\n" "theme"          "Install Dracula Powerlevel10k theme"
  echo ""

  echo -e "${BOLD}${CYAN}RUNTIME COMMANDS${RESET}"
  echo ""
  printf "  ${RED}%-22s${RESET} %s\n" "up"        "Start Leviathan container"
  printf "  ${RED}%-22s${RESET} %s\n" "down"      "Stop and remove Leviathan container"
  printf "  ${RED}%-22s${RESET} %s\n" "shell"     "Open an interactive shell inside Leviathan"
  printf "  ${RED}%-22s${RESET} %s\n" "run <cmd>" "Run a command inside Leviathan"
  printf "  ${RED}%-22s${RESET} %s\n" "ps"        "Show Leviathan container status"
  printf "  ${RED}%-22s${RESET} %s\n" "logs"      "Follow Leviathan container logs"
  printf "  ${RED}%-22s${RESET} %s\n" "clean"     "Remove Leviathan container, image and volumes"
  echo ""

  printf "  ${RED}%-22s${RESET} %s\n" "help"      "Display this help message"
  echo ""

  echo -e "${BOLD}${CYAN}IMAGE${RESET}"
  echo ""
  printf "  ${CYAN}%-18s${RESET} %s\n" "${IMAGE_NAME}" "Single offensive security workstation image"
  echo ""

  echo -e "${BOLD}${CYAN}EXAMPLES${RESET}"
  echo ""
  echo -e "  ${GRAY}# Full setup from scratch${RESET}"
  echo -e "  ./leviathan.sh install"
  echo ""
  echo -e "  ${GRAY}# Build the image${RESET}"
  echo -e "  ./leviathan.sh build"
  echo ""
  echo -e "  ${GRAY}# Start the container${RESET}"
  echo -e "  ./leviathan.sh up"
  echo ""
  echo -e "  ${GRAY}# Open shell${RESET}"
  echo -e "  ./leviathan.sh shell"
  echo ""
  echo -e "  ${GRAY}# Run a tool directly${RESET}"
  echo -e "  ./leviathan.sh run nmap -sV 127.0.0.1"
  echo ""
  echo -e "  ${GRAY}# Run nuclei scan${RESET}"
  echo -e "  ./leviathan.sh run nuclei -u https://target.com"
  echo ""

  echo -e "${GRAY}─────────────────────────────────────────────────────────────────${RESET}"
  echo -e "${GRAY}  Leviathan Docker Edition${RESET}"
  echo ""
}

# ─── Router ──────────────────────────────────────────────────────────────────
main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    install)        banner; cmd_install ;;
    install-docker) banner; install_docker ;;
    build)          banner; cmd_build ;;
    up)             banner; cmd_up ;;
    down)           banner; cmd_down ;;
    shell)          cmd_shell ;;
    run)            cmd_run "$@" ;;
    logs)           cmd_logs ;;
    ps)             banner; cmd_ps ;;
    pull)           banner; cmd_pull ;;
    wordlists)      banner; cmd_wordlists ;;
    clean)          banner; cmd_clean ;;
    theme)          banner; cmd_theme ;;
    help|--help|-h) show_help ;;
    *)
      log_error "Unknown command: $cmd"
      show_help
      exit 1
      ;;
  esac
}

main "$@"
