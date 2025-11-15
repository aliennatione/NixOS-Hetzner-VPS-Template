{
  config, 
  pkgs, 
  ... 
}:

{
  imports = [
    # Import the Disko configuration for declarative disk partitioning
    ../disko/disko.nix
  ];

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set the NixOS state version
  system.stateVersion = "24.05";

  # --- Networking ---
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # Allow SSH by default
  };

  # --- Time & Localization ---
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # --- User Management ---
  users.users.root.openssh.authorizedKeys.keys = [
    # TODO: Replace with your public SSH key
    "ssh-ed25519 AAAA..."
  ];

  users.users.nixos = {
    isNormalUser = true;
    description = "Default NixOS User";
    extraGroups = [ "wheel" ]; # For sudo access
    openssh.authorizedKeys.keys = [
      # TODO: Replace with your public SSH key
      "ssh-ed25519 AAAA..."
    ];
  };

  # --- SSH Daemon ---
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password"; # Disallow root login with password
      PasswordAuthentication = false;
    };
  };

  # --- Nix Package Manager ---
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # --- Core Packages ---
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    htop
    vim
  ];
}
