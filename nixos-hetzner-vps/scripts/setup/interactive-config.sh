#!/bin/bash
set -euo pipefail

# 🎨 Interactive Configuration Wizard
# Advanced version with TUI (Text User Interface)

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
  clear
  echo -e "${BLUE}"
  echo "╔════════════════════════════════════════════════════════════════╗"
  echo "║            🌟 NixOS Hetzner VPS Configuration Wizard           ║"
  echo "╚════════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"
}

print_step() {
  local step="$1"
  local total="$2"
  local title="$3"
  echo -e "${YELLOW}Step ${step}/${total}: ${title}${NC}"
  echo "────────────────────────────────────────────────────────────────"
}

print_info() {
  echo -e "${BLUE}ℹ $1${NC}"
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
  echo -e "${RED}❌ $1${NC}"
}

# Progress bar function
progress_bar() {
  local current=$1
  local total=$2
  local width=50
  local percentage=$(( (current * 100) / total ))
  local filled=$(( (current * width) / total ))
  local empty=$(( width - filled ))
  
  printf "\r["
  printf "%${filled}s" | tr ' ' '='
  printf "%${empty}s" | tr ' ' '-'
  printf "] %d%%" $percentage
}

# Hardware detection TUI
hardware_detection() {
  print_step 1 6 "Hardware Detection"
  
  echo "Detecting hardware configuration..."
  
  # Simulate detection progress
  for i in {1..10}; do
    progress_bar $i 10
    sleep 0.1
  done
  echo ""
  
  # Real detection
  local cpu_info=$(grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^[ \t]*//')
  local mem_total=$(free -m | awk '/Mem:/ {print $2}')
  local disk_info=$(lsblk -d -o NAME,SIZE,ROTA | grep -v NAME)
  
  print_success "Hardware detected:"
  echo "   CPU: $cpu_info"
  echo "   RAM: ${mem_total}MB"
  echo "   Disks:"
  echo "$disk_info" | sed 's/^/     /'
  
  # Auto-detect recommendations
  local recommended_profile="vps"
  if [ "$mem_total" -gt 16000 ]; then
    recommended_profile="database"
  fi
  
  print_info "Recommended profile: ${recommended_profile}"
  echo ""
}

# Profile selection with TUI
profile_selection() {
  print_step 2 6 "Profile Selection"
  
  echo "Choose your deployment profile:"
  echo ""
  
  local profiles=(
    "minimal: Minimal system (SSH only)"
    "webserver: Web server (Nginx + SSL)"
    "container-host: Container host (Podman optimized)"
    "database-server: Database server (PostgreSQL/MySQL)"
    "full-stack: Full stack (Web + DB + Monitoring)"
    "custom: Custom configuration"
  )
  
  local selected=0
  local max_index=$((${#profiles[@]} - 1))
  
  while true; do
    clear
    print_header
    print_step 2 6 "Profile Selection"
    
    for i in "${!profiles[@]}"; do
      if [ "$i" -eq "$selected" ]; then
        echo -e "${GREEN}> ${profiles[$i]}${NC}"
      else
        echo "  ${profiles[$i]}"
      fi
    done
    
    echo ""
    echo "Use ↑/↓ arrows to navigate, Enter to select, Q to quit"
    
    # Read keypress without echoing
    read -rsn1 key
    case $key in
      $'\x1b')  # Escape sequence (arrow keys)
        read -rsn2 key
        case $key in
          '[A') # Up arrow
            selected=$(( selected - 1 ))
            if [ $selected -lt 0 ]; then
              selected=$max_index
            fi
            ;;
          '[B') # Down arrow  
            selected=$(( selected + 1 ))
            if [ $selected -gt $max_index ]; then
              selected=0
            fi
            ;;
        esac
        ;;
      '') # Enter
        PROFILE=$(echo "${profiles[$selected]}" | cut -d':' -f1 | tr -d ' ')
        break
        ;;
      [Qq]) # Quit
        exit 0
        ;;
    esac
  done
  
  print_success "Selected profile: $PROFILE"
  echo ""
}

# Security configuration with guided setup
security_config() {
  print_step 3 6 "Security Configuration"
  
  echo "🔐 Security Configuration"
  echo ""
  
  # LUKS passphrase strength meter
  echo "Enter LUKS passphrase (will be hidden):"
  echo ""
  echo "Password strength requirements:"
  echo "   • Minimum 12 characters"
  echo "   • Mix of uppercase, lowercase, numbers, symbols"
  echo "   • No common words or patterns"
  echo ""
  
  while true; do
    stty -echo
    read -r PASS1
    echo ""
    echo "Confirm passphrase:"
    read -r PASS2
    stty echo
    echo ""
    
    if [ "$PASS1" != "$PASS2" ]; then
      print_error "Passphrases do not match. Try again."
      continue
    fi
    
    if [ ${#PASS1} -lt 12 ]; then
      print_error "Passphrase too short (minimum 12 characters)."
      continue
    fi
    
    # Simple strength check
    local has_upper=$(echo "$PASS1" | grep '[A-Z]' || true)
    local has_lower=$(echo "$PASS1" | grep '[a-z]' || true)
    local has_digit=$(echo "$PASS1" | grep '[0-9]' || true)
    local has_special=$(echo "$PASS1" | grep '[^a-zA-Z0-9]' || true)
    
    local strength=0
    [ -n "$has_upper" ] && strength=$((strength + 1))
    [ -n "$has_lower" ] && strength=$((strength + 1))
    [ -n "$has_digit" ] && strength=$((strength + 1))
    [ -n "$has_special" ] && strength=$((strength + 1))
    
    case $strength in
      1) print_warning "Password strength: Weak 🔴";;
      2) print_warning "Password strength: Fair 🟡";;
      3) print_success "Password strength: Good 🟢";;
      4) print_success "Password strength: Strong 🟢🟢";;
    esac
    
    if [ $strength -lt 3 ]; then
      read -p "Continue with weak password? (y/N): " confirm
      if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        continue
      fi
    fi
    
    LUKS_PASS="$PASS1"
    print_success "LUKS passphrase accepted"
    break
  done
  
  echo ""
}

# SSH key configuration with auto-detection
ssh_config() {
  print_step 4 6 "SSH Configuration"
  
  echo "🔑 SSH Key Configuration"
  echo ""
  
  # Auto-detect existing keys
  local existing_keys=()
  if [ -f "/root/.ssh/authorized_keys" ] && [ -s "/root/.ssh/authorized_keys" ]; then
    existing_keys+=("Use existing key from rescue system")
  fi
  
  if [ -f "/root/.ssh/id_ed25519.pub" ]; then
    existing_keys+=("Use /root/.ssh/id_ed25519.pub")
  fi
  
  if [ -f "/root/.ssh/id_rsa.pub" ]; then
    existing_keys+=("Use /root/.ssh/id_rsa.pub")
  fi
  
  existing_keys+=("Enter SSH public key manually")
  existing_keys+=("Generate new SSH key pair")
  
  # TUI selection for SSH key
  local selected=0
  local max_index=$((${#existing_keys[@]} - 1))
  
  while true; do
    clear
    print_header
    print_step 4 6 "SSH Configuration"
    
    for i in "${!existing_keys[@]}"; do
      if [ "$i" -eq "$selected" ]; then
        echo -e "${GREEN}> ${existing_keys[$i]}${NC}"
      else
        echo "  ${existing_keys[$i]}"
      fi
    done
    
    echo ""
    echo "Use ↑/↓ arrows to navigate, Enter to select"
    
    read -rsn1 key
    case $key in
      $'\x1b')
        read -rsn2 key
        case $key in
          '[A') selected=$(( selected - 1 )); [ $selected -lt 0 ] && selected=$max_index;;
          '[B') selected=$(( selected + 1 )); [ $selected -gt $max_index ] && selected=0;;
        esac
        ;;
      '')
        case $selected in
          0) # Use existing
            SSH_KEY=$(head -1 "/root/.ssh/authorized_keys")
            ;;
          1) # id_ed25519
            SSH_KEY=$(cat "/root/.ssh/id_ed25519.pub")
            ;;
          2) # id_rsa  
            SSH_KEY=$(cat "/root/.ssh/id_rsa.pub")
            ;;
          3) # Manual entry
            echo "Enter SSH public key:"
            read -r SSH_KEY
            ;;
          4) # Generate new
            echo "Generating new SSH key pair..."
            ssh-keygen -t ed25519 -f "/root/.ssh/id_ed25519" -N "" -C "nixos-hetzner-vps"
            SSH_KEY=$(cat "/root/.ssh/id_ed25519.pub")
            print_success "New key generated: /root/.ssh/id_ed25519"
            ;;
        esac
        break
        ;;
    esac
  done
  
  print_success "SSH key configured: ${SSH_KEY:0:30}..."
  echo ""
}

# Advanced configuration
advanced_config() {
  print_step 5 6 "Advanced Configuration"
  
  echo "⚙️ Advanced Options"
  echo ""
  
  # Interactive configuration with defaults
  read -p "Hostname [nixos-server]: " HOSTNAME
  HOSTNAME=${HOSTNAME:-"nixos-server"}
  
  read -p "Admin username [admin]: " ADMIN_USER
  ADMIN_USER=${ADMIN_USER:-"admin"}
  
  read -p "Timezone [UTC]: " TIMEZONE
  TIMEZONE=${TIMEZONE:-"UTC"}
  
  read -p "Enable monitoring (Prometheus + Grafana) [Y/n]: " MONITORING
  MONITORING=${MONITORING:-"y"}
  [[ "$MONITORING" =~ [Yy] ]] && ENABLE_MONITORING=true || ENABLE_MONITORING=false
  
  read -p "Enable automatic backups [Y/n]: " BACKUPS
  BACKUPS=${BACKUPS:-"y"}
  [[ "$BACKUPS" =~ [Yy] ]] && ENABLE_BACKUPS=true || ENABLE_BACKUPS=false
  
  print_success "Advanced configuration saved"
  echo ""
}

# Summary and confirmation with visual preview
summary() {
  print_step 6 6 "Configuration Summary"
  
  echo -e "${BLUE}┌─────────────────────────────────────────────────────────────┐${NC}"
  echo -e "${BLUE}│                    📋 Configuration Summary                   │${NC}"
  echo -e "${BLUE}├─────────────────────────────────────────────────────────────┤${NC}"
  printf "${BLUE}| %-20s %-38s ${BLUE}|\n${NC}" "Profile:" "$PROFILE"
  printf "${BLUE}| %-20s %-38s ${BLUE}|\n${NC}" "Hostname:" "$HOSTNAME"
  printf "${BLUE}| %-20s %-38s ${BLUE}|\n${NC}" "Admin user:" "$ADMIN_USER"
  printf "${BLUE}| %-20s %-38s ${BLUE}|\n${NC}" "Timezone:" "$TIMEZONE"
  printf "${BLUE}| %-20s %-38s ${BLUE}|\n${NC}" "SSH key:" "${SSH_KEY:0:30}..."
  printf "${BLUE}| %-20s %-38s ${BLUE}|\n${NC}" "LUKS:" "Enabled (strong passphrase)"
  printf "${BLUE}| %-20s %-38s ${BLUE}|\n${NC}" "Monitoring:" "$([ "$ENABLE_MONITORING" = true ] && echo "Enabled" || echo "Disabled")"
  printf "${BLUE}| %-20s %-38s ${BLUE}|\n${NC}" "Backups:" "$([ "$ENABLE_BACKUPS" = true ] && echo "Enabled" || echo "Disabled")"
  echo -e "${BLUE}└─────────────────────────────────────────────────────────────┘${NC}"
  echo ""
  
  echo "🚀 Ready to install?"
  echo ""
  echo -e "${YELLOW}⚠️  WARNING: This will ERASE ALL DATA on the selected disk${NC}"
  echo ""
  
  read -p "Type 'CONFIRM' to begin installation: " confirm
  if [ "$confirm" != "CONFIRM" ]; then
    print_error "Installation cancelled"
    exit 1
  fi
  
  print_success "Installation confirmed - starting in 3 seconds..."
  sleep 3
}

# Main execution
main() {
  print_header
  hardware_detection
  profile_selection
  security_config
  ssh_config
  advanced_config
  summary
}

main "$@"