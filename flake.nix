{
  description = "StarryNix Infrastructure";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
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
          homelab =
            let
              host = "homelab";
              constants = (import ./modules/constants.nix) // {
                inherit flakeRoot;
                hostname = "${hostPrefix}${host}";
                system = "x86_64-linux";
              };
            in
            inputs.nixpkgs.lib.nixosSystem {
              inherit (constants) system;
              specialArgs = { inherit inputs constants; };
              modules = [ ./hosts/${host}/system.nix ];
            };
        };
      };
    };
}
