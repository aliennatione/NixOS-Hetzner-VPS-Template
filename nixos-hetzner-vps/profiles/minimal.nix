# ==============================================================================
# Minimal Profile
# ==============================================================================
#
# This profile represents the absolute minimum configuration for a functional
# NixOS server. It includes core system settings, essential packages, and a
# basic user configuration.
#
# It serves as the foundational layer upon which all other profiles are built.
# Every other profile in this flake should import `minimal.nix`.
#
{
  imports = [
    # Import the core modules containing the actual configuration.
    ../modules/system/core.nix      # Basic system settings, locale, time, etc.
    ../modules/users/bmad.nix         # Default user and SSH key configuration
    ../modules/security/ssh.nix     # Secure SSH daemon configuration
    ../modules/security/firewall.nix # Basic stateful firewall
  ];

  # Set the NixOS state version to ensure configuration compatibility across
  # upgrades. This should be updated periodically after a successful upgrade.
  system.stateVersion = "24.05";
}
