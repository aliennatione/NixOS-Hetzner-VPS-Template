# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Advanced CI/CD pipeline with comprehensive testing
- Professional documentation with MkDocs integration
- Interactive configuration wizard with TUI
- Quality metrics tracking and reporting
- Modular architecture with atomic modules
- Performance benchmarking suite
- Security hardening modules
- Monitoring and alerting systems

### Changed
- Improved ZFS module with better validation and error handling
- Enhanced security modules with additional hardening options
- Refined installation scripts with better user experience
- Updated documentation to multi-level format
- Optimized performance settings for cloud environments

### Fixed
- Fixed context issues in ZFS module
- Improved error handling in installation scripts
- Corrected module dependency issues
- Enhanced security validation in configuration

## [1.0.0] - 2025-11-15

### Added
- Initial release with full LUKS + ZFS + Podman support
- Automated installation script for Rescue Mode and Live ISO
- Cloud-init deployment option
- Complete documentation including troubleshooting
- NixOS flake configuration with hardware optimization
- Podman rootless setup with systemd integration

### Features
- **Secure by default**: Full-disk encryption with LUKS
- **Performance optimized**: ZFS ARC limited to 1GB for VPS environments
- **Container-ready**: Podman rootless with proper storage configuration
- **Flexible deployment**: Rescue Mode, Live ISO, and cloud-init support
- **Production-grade**: Firewall, SSH hardening, and user management

### Architecture
- Dataset separation: `/nix`, `/home`, `/persist`, `/var/log`, `/var/lib/containers`
- ZFS optimizations: `compression=lz4`, `atime=off`, `xattr=sa`
- Kernel parameters for stability: `nohibernate`, ARC limits
- Network configuration with DHCP for Hetzner environment