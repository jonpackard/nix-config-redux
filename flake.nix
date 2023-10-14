{
  description = "Minimal multi-system and multi-user nix configuration. Some of this is sourced from MatthiasBenaets/nixos-config.";

  inputs =                                                                  # References Used by Flake
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";                     # Stable Nix Packages (Default)

      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";         # Unstable Nix Packages
    };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, ... }:   # Function telling flake which inputs to use
    let
      vars = {                                                              # Variables Used In Flake
        default-user = "jonathan";
      };
    in
      {
        nixosConfigurations = (                                               # NixOS Configurations
          import ./hosts {
            inherit (nixpkgs) lib;
            inherit inputs nixpkgs nixpkgs-unstable vars;   # Inherit inputs
          }
        );
      };
}