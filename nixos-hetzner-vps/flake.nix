{
  description = "A comprehensive NixOS flake for deploying production-ready VPS on Hetzner Cloud.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, flake-utils, nixos-hardware, disko, ... }@inputs:
    let
      # Supported systems for the devShell.
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      # =========================================================================
      # || HELPER FUNCTION TO GENERATE A NIXOS SYSTEM                         ||
      # =========================================================================
      # This function builds a complete NixOS system configuration.
      # It takes a profile path as input and injects all common modules
      # required for a Hetzner Cloud server.
      mkHetznerSystem = { profilePath, profileName }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # All Hetzner Cloud servers are x86_64
        specialArgs = { inherit inputs; }; # Pass flake inputs to all modules

        modules = [
          # 1. Base hardware module for Hetzner Cloud VMs.
          nixos-hardware.nixosModules.hetzner-cloud

          # 2. Declarative disk partitioning using disko.
          #    The configuration is imported below.
          inputs.disko.nixosModules.disko
          ./modules/hetzner/disko-config.nix

          # 3. The specific profile for this system (e.g., minimal, webserver).
          #    This is where the main configuration for the server role lives.
          profilePath

          # 4. Set the hostname based on the profile name.
          { networking.hostName = profileName; }
        ];
      };

      # =========================================================================
      # || AUTOMATIC PROFILE DISCOVERY                                      ||
      # =========================================================================
      # This block automatically discovers all `.nix` files in the `./profiles`
      # directory and creates an attribute set from them.
      # e.g., { minimal = ./profiles/minimal.nix; webserver = ./profiles/webserver.nix; }
      profiles = let
        # Read all files in the directory
        profileFiles = builtins.readDir ./profiles;
        # Filter for .nix files and create a list of file names
        nixFileNames = builtins.filter (file: builtins.match ".*\.nix" file != null) (builtins.attrNames profileFiles);
        # Create an attribute { name, value } for each file
        toAttr = name: {
          # 'webserver.nix' -> 'webserver'
          name = builtins.elemAt (builtins.split ".nix" name) 0;
          value = ./. + "/profiles/" + name;
        };
      in
        builtins.listToAttrs (map toAttr nixFileNames);

    in
    # =========================================================================
    # || FLAKE OUTPUTS                                                      ||
    # =========================================================================
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # -----------------------------------------------------------------------
        # | Development Shell                                                   |
        # -----------------------------------------------------------------------
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # Nix tooling
            nixpkgs-fmt         # Formatter for Nix code
            statix              # Linter for Nix code to find errors
            deadnix             # Find and remove unused Nix code
            nil                 # Nix language server for IDEs

            # Documentation
            mkdocs              # Static site generator for documentation
            markdownlint-cli    # Linter for Markdown files

            # Shell scripting
            shellcheck          # Linter for shell scripts

            # General purpose
            git
            gh
          ];

          # Hook to display a welcome message and instructions on shell entry.
          shellHook = '''
            echo "================================================================="
            echo " Entering NixOS Hetzner VPS Development Environment "
            echo "================================================================="
            echo
            echo "Run 'nix flake check' to lint and format the codebase."
            echo "Run 'mkdocs serve' to preview the documentation locally."
            echo
          ''';
        };

        # -----------------------------------------------------------------------
        # | Code Checks                                                         |
        # -----------------------------------------------------------------------
        # This output is used by `nix flake check` to run tests and linters.
        # It is also used by the CI workflow.
        checks = {
          # Check if all Nix files are correctly formatted
          formatting = pkgs.runCommand "check-formatting" {
            nativeBuildInputs = [ pkgs.nixpkgs-fmt ];
          } '''
            echo "Checking formatting of all .nix files..."
            ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
            touch $out
          ''';

          # Check for stylistic and correctness issues with Statix
          lint-statix = pkgs.runCommand "check-lint-statix" {
            nativeBuildInputs = [ pkgs.statix ];
          } '''
            echo "Linting Nix files with Statix..."
            ${pkgs.statix}/bin/statix check ${./.}
            touch $out
          ''';

          # Check for unused Nix code with deadnix
          lint-deadnix = pkgs.runCommand "check-lint-deadnix" {
            nativeBuildInputs = [ pkgs.deadnix ];
          } '''
            echo "Checking for dead code with deadnix..."
            ${pkgs.deadnix}/bin/deadnix --fail ${./.}
            touch $out
          ''';
        };
      })

    // # Outputs that are not system-specific

    {
      # =========================================================================
      # || NIXOS CONFIGURATIONS                                               ||
      # =========================================================================
      # This uses `mapAttrs` to automatically generate a NixOS configuration
      # for each profile discovered in the `./profiles` directory.
      # The output will be `nixosConfigurations.hetzner-minimal`, etc.
      nixosConfigurations = builtins.mapAttrs (name: path:
        mkHetznerSystem {
          profileName = "hetzner-${name}";
          profilePath = path;
        }
      ) profiles;
    };
}
