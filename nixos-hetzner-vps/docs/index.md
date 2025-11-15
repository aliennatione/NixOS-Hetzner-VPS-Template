---
title: NixOS Hetzner VPS Template
hide:
  - navigation
  - toc
---

# 🚀 NixOS Hetzner VPS Template

### Production-ready NixOS deployment for Hetzner Cloud

[![NixOS](https://img.shields.io/badge/NixOS-24.05-blue?logo=nixos&logoColor=white)](https://nixos.org)
[![CI/CD](https://github.com/your-username/nixos-hetzner-vps/actions/workflows/ci-advanced.yml/badge.svg)](https://github.com/your-username/nixos-hetzner-vps/actions)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Discord](https://img.shields.io/discord/your-discord-id?label=Community&logo=discord)](https://discord.gg/your-invite)

<div class="grid cards" markdown>

-   :octicons-rocket-16:{ .lg .middle } __Get Started__

    ---

    Deploy NixOS on Hetzner VPS in under 5 minutes

    [:octicons-arrow-right-24: Quick Start](beginner/getting-started.md)

-   :octicons-cpu-16:{ .lg .middle } __Architecture__

    ---

    Modular, enterprise-grade architecture

    [:octicons-arrow-right-24: Architecture Overview](architecture/overview.md)

-   :octicons-shield-16:{ .lg .middle } __Security__

    ---

    Full-disk encryption, firewall, hardening

    [:octicons-arrow-right-24: Security Model](architecture/security.md)

-   :octicons-graph-16:{ .lg .middle } __Performance__

    ---

    Optimized for cloud environments

    [:octicons-arrow-right-24: Performance Guide](architecture/performance.md)

</div>

## 🌟 Features

<div class="grid" markdown>

<div class="card" markdown>

### 🔒 Security First

- **LUKS encryption** for full-disk encryption
- **SSH hardening** with key-based authentication only
- **Firewall by default** with minimal open ports
- **Security modules** that can be enabled independently

[:octicons-shield-16: Security Guide](architecture/security.md)

</div>

<div class="card" markdown>

### ⚡ Performance Optimized

- **ZFS tuning** for cloud environments (1GB ARC limit)
- **Hardware detection** for automatic optimizations
- **Workload-specific profiles** (web, database, media)
- **I/O scheduler optimization** for NVMe/SATA

[:octicons-graph-16: Performance Guide](architecture/performance.md)

</div>

<div class="card" markdown>

### 🧩 Modular Architecture

- **Atomic modules** that are self-contained and testable
- **Composition over inheritance** for maximum flexibility
- **Profile system** for common use cases
- **Zero dependencies** between modules

[:octicons-package-16: Modules Overview](modules/base.md)

</div>

<div class="card" markdown>

### 📚 Professional Documentation

- **Multi-level documentation** (beginner to expert)
- **Interactive examples** with live code
- **Architecture diagrams** and implementation details
- **API reference** and configuration options

[:octicons-book-16: Documentation Guide](contributing/documentation.md)

</div>

</div>

## 🚀 Quick Start

Deploy in 3 steps:
