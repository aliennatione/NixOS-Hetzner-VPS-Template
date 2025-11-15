# ==============================================================================
# Web Server Profile
# ==============================================================================
#
# This profile builds upon the `minimal` profile to create a fully functional
# web server.
#
# It enables and configures the Nginx web server and opens the necessary
# firewall ports for HTTP and HTTPS traffic.
#
{
  imports = [
    ./minimal.nix # Inherit the base configuration from the minimal profile
  ];

  # --- Web Server Configuration ---

  # Enable the Nginx web server service.
  services.nginx.enable = true;

  # By default, Nginx will serve an empty welcome page.
  # You can define virtual hosts directly here, for example:
  #
  # services.nginx.virtualHosts."example.com" = {
  #   forceSSL = true; # Redirect HTTP to HTTPS
  #   enableACME = true; # Automatically fetch SSL certs from Let's Encrypt
  #   root = "/var/www/example.com";
  # };

  # --- Firewall Settings ---

  # Open ports 80 (HTTP) and 443 (HTTPS) in the firewall.
  # The SSH port (22) is already opened by the `ssh` module imported in `minimal.nix`.
  # NixOS automatically merges these lists of open ports.
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
