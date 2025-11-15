{
  description = "NixOS Hetzner VPS Template - Production-ready deployment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixos-hardware, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          # Development tools
          default = pkgs.writeShellApplication {
            name = "nixos-hetzner-tools";
            text = ''
              echo "NixOS Hetzner VPS Template Tools"
              echo "Available commands:"
              echo "  - setup: Interactive installation wizard"
              echo "  - test: Run tests"
              echo "  - docs: Build documentation"
            '';
          };
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nixpkgs-fmt
            shellcheck
            statix
            deadnix
            nil
            markdownlint-cli
            mkdocs
            python3
          ];
          shellHook = ''
            echo "Development environment ready!"
            echo "Available tools: nixpkgs-fmt, shellcheck, markdownlint, mkdocs"
          '';
        };
      }
    ) // {
      # NixOS configurations
      nixosConfigurations = {
        # Example configuration - users will customize their own
        hetzner-webserver = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.hetzner-cloud
            ./profiles/webserver.nix
          ];
        };

        hetzner-container-host = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.hetzner-cloud
            ./profiles/container-host.nix
          ];
        };
      };

      # Tests
      checks = nixpkgs.lib.mapAttrs (system: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ config, pkgs, ... }: {
            imports = [ ./profiles/minimal.nix ];
            # Add test-specific configurations here
            networking.hostName = "test-server";
          })
        ];
      }) nixpkgs.lib.systems.flakeExposed;
    };
}