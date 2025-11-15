{
  config,
  pkgs,
  ... 
}:

{
  imports = [
    ./minimal.nix # Inherit the base configuration
  ];

  # --- Web Server Configuration ---

  # Enable the Nginx web server
  services.nginx = {
    enable = true;
    # You can add default vhost configurations here, for example:
    # virtualHosts."_".locations."/".root = "/var/www/html";
  };

  # --- Firewall Settings ---

  # Open ports for HTTP and HTTPS traffic
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Note: The core.nix module already allows port 22 for SSH.
  # NixOS intelligently merges these lists.

  # --- System Packages ---

  # No additional system-wide packages are added by default.
  # Web applications should manage their own dependencies.

  system.stateVersion = "24.05"; # Ensure consistency
}
