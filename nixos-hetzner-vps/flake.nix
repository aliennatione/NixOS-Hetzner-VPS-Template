{
  description = "A comprehensive NixOS flake for deploying production-ready VPS on Hetzner Cloud.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, flake-utils, nixos-hardware, ... }@inputs:
    let
      # Supported systems
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      # Helper to generate NixOS configurations for each profile
      mkNixosSystem = { system, profileName, profilePath }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            nixos-hardware.nixosModules.hetzner-cloud
            { networking.hostName = profileName; }
            profilePath
          ];
        };

      # Pre-defined profiles to be exposed as NixOS configurations
      profiles = {
        minimal = ./profiles/minimal.nix;
        webserver = ./profiles/webserver.nix;
        # The following profiles are placeholders for future expansion
        # container-host = ./profiles/container-host.nix;
        # database-server = ./profiles/database-server.nix;
        # full-stack = ./profiles/full-stack.nix;
      };

    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Development shell
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # Nix tooling
            nixpkgs-fmt
            statix
            deadnix
            nil
            # Documentation
            mkdocs
            markdownlint-cli
            # Shell scripting
            shellcheck
            # General purpose
            git
            gh
          ];
          shellHook = ''
            echo "================================================================="
            echo " Entering NixOS Hetzner VPS Development Environment "
            echo "================================================================="
            echo
            echo "Available tools:"
            echo " - nixpkgs-fmt: Format Nix files"
            echo " - statix, deadnix, nil: Nix code analysis and linting"
            echo " - mkdocs, markdownlint-cli: Documentation tools"
            echo " - shellcheck: Bash script analysis"
            echo
            echo "Run 'nix flake check' to run tests."
            echo "Run 'mkdocs serve' to preview the documentation."
            echo
          '';
        };

      }) // {
        # NixOS Configurations, one for each profile
        nixosConfigurations = builtins.mapAttrs (name: path:
          mkNixosSystem {
            system = "x86_64-linux"; # Hetzner primarily uses x86_64
            profileName = "hetzner-${name}";
            profilePath = path;
          }
        ) profiles;

        # Flake templates (if any)
        # templates = { ... };
      };
}
