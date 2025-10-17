{
  description = "StarryNix Infrastructure";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
  };

  outputs =
    { self, flake-parts, ... }@inputs:
    let
      flakeRoot = ./.;
      hostPrefix = "starrynix-";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { inputs', pkgs, ... }:
        {
          devShells.default =
            let
              mkShell = pkgs.mkShell.override { stdenv = pkgs.stdenvNoCC; };
            in
            mkShell {
              packages = with pkgs; [
                nil
                nixfmt-rfc-style
              ];
            };

          formatter = pkgs.nixfmt-tree;
        };

      flake = {
        nixosConfigurations = {
          homelab = (import ./hosts/homelab/entry-point.nix) {
            inherit inputs flakeRoot;
            constants = (import ./modules/constants.nix) // {
              system = "x86_64-linux";
              hostname = "${hostPrefix}homelab";
            };
          };
        };
      };
    };
}
