{
  config,
  pkgs,
  ... 
}:

{
  imports = [
    ../modules/nixos/core.nix
  ];

  # The minimal profile inherits all settings from core.nix
  # without adding any new services or packages. It serves as the
  # foundational layer for all other profiles.

  # You can add specific minimal-profile overrides here if needed.
  system.stateVersion = "24.05"; # Ensure consistency
}
