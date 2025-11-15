# 🚀 NixOS Hetzner VPS Template

[![NixOS](https://img.shields.io/badge/NixOS-24.05-blue?logo=nixos&logoColor=white)](https://nixos.org)
[![CI/CD](https://github.com/your-username/nixos-hetzner-vps/actions/workflows/ci-advanced.yml/badge.svg)](https://github.com/your-username/nixos-hetzner-vps/actions)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Documentation](https://img.shields.io/badge/Documentation-Online-blue)](https://your-username.github.io/nixos-hetzner-vps)
[![Discord](https://img.shields.io/discord/your-discord-id?label=Community&logo=discord)](https://discord.gg/your-invite)

**Production-ready NixOS deployment template for Hetzner VPS with ZFS + LUKS + Podman**

✅ **Battle-tested in production**  
✅ **Fully automated installation**  
✅ **Optimized for cloud environments**  
✅ **Complete documentation included**  
✅ **Modular architecture**  
✅ **Professional documentation site**

[![Demo Video](https://img.youtube.com/vi/demo-video-id/0.jpg)](https://youtu.be/demo-video-id)

## 🌟 Features

### 🔒 Security First
- **Full-disk encryption**: LUKS encryption for all data at rest
- **SSH hardening**: No root login, password authentication disabled
- **Firewall by default**: Only essential ports exposed (22, 80, 443)
- **Security modules**: Independent security features that can be enabled/disabled
- **Regular updates**: Easy system upgrades with NixOS reproducibility

### ⚡ Performance Optimized
- **ZFS ARC tuning**: Limited to 1GB for stable VPS performance
- **Dataset separation**: Independent datasets for `/nix`, `/containers`, `/persist`
- **Compression enabled**: LZ4 compression for storage efficiency
- **Hardware detection**: Automatic optimization for Hetzner hardware
- **Workload profiles**: Optimized settings for different use cases

### 🧩 Modular Architecture
- **Atomic modules**: Each module is self-contained and testable
- **Composition over inheritance**: Mix and match modules like LEGO
- **Profile system**: Pre-configured profiles for common use cases
- **Zero dependencies**: Modules don't depend on each other's internal state
- **Declarative everything**: Infrastructure, security, and runtime

### 🐳 Container Ready
- **Podman rootless**: Secure container runtime without root privileges
- **Systemd integration**: Native service management for containers
- **Docker-compatible**: Docker CLI compatibility layer
- **Dedicated storage**: Isolated ZFS dataset for container data
- **Registry support**: Private registry configuration included

### 🔄 Flexible Deployment
- **Rescue Mode**: Fully automated installation via Hetzner rescue system
- **Live ISO**: Manual installation with full control and debugging
- **Cloud-init**: Zero-touch deployment for infrastructure automation
- **Template system**: Easy configuration through template files
- **Interactive wizard**: Guided setup for beginners

## 🚀 Quick Start

### Using the Template
[![Use this template](https://img.shields.io/badge/Use%20this%20template-2ea44f?logo=github&logoColor=white)](https://github.com/your-username/nixos-hetzner-vps/generate)

### Interactive Installation (Recommended for Beginners)