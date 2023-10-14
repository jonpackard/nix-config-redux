{ lib, inputs, nixpkgs, nixpkgs-unstable, vars, ... }:

let
  system = "x86_64-linux";                                  # System Architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow Proprietary Software
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  jon-tower = lib.nixosSystem {                               # Desktop Profile
    inherit system;
    specialArgs = {                                         # Pass Flake Variable
      inherit inputs system unstable vars;
      host = {
        hostName = "jon-tower";
      };
    };
    modules = [                                             # Modules Used
      ./jon-tower/configuration.nix
      #./configuration.nix
    ];
  };
}