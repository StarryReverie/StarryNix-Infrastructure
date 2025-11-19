{
  description = "StarryNix Infrastructure";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
    };

    nix-maid = {
      url = "github:viperML/nix-maid";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "";
    };

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.stable.follows = "";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, flake-parts, ... }@inputs:
    let
      flakeRoot = ./.;
      makeHostnameForHost = host: "starrynix-${host}";
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
                inputs'.agenix-rekey.packages.default
                inputs'.colmena.packages.colmena
                nil
                nixfmt-rfc-style
              ];
            };

          formatter = pkgs.nixfmt-tree;
        };

      flake = {
        lib = import ./lib;

        colmenaHive =
          let
            conf = self.nixosConfigurations;
          in
          inputs.colmena.lib.makeHive (
            (builtins.mapAttrs (name: value: { imports = value._module.args.modules; }) conf)
            // {
              meta.nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
              meta.nodeNixpkgs = builtins.mapAttrs (name: value: value.pkgs) conf;
              meta.nodeSpecialArgs = builtins.mapAttrs (name: value: value._module.specialArgs) conf;
            }
          );

        nixosConfigurations = {
          "homelab" = (import ./hosts/homelab/entry-point.nix) {
            inherit inputs flakeRoot;
            constants = (import ./modules/constants.nix) // {
              system = "x86_64-linux";
              hostname = makeHostnameForHost "homelab";
            };
          };

          "workstation" = (import ./hosts/workstation/entry-point.nix) {
            inherit inputs flakeRoot;
            constants = (import ./modules/constants.nix) // {
              system = "x86_64-linux";
              hostname = makeHostnameForHost "workstation";
            };
          };
        };

        nodeConfigurations = {
          "jellyfin" = {
            "main" = (import ./nodes/jellyfin/main/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = (import ./modules/constants.nix) // {
                cluster = "jellyfin";
                node = "main";
              };
            };
          };

          "nextcloud" = {
            "main" = (import ./nodes/nextcloud/main/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = (import ./modules/constants.nix) // {
                cluster = "nextcloud";
                node = "main";
              };
            };

            "storage" = (import ./nodes/nextcloud/storage/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = (import ./modules/constants.nix) // {
                cluster = "nextcloud";
                node = "storage";
              };
            };

            "cache" = (import ./nodes/nextcloud/cache/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = (import ./modules/constants.nix) // {
                cluster = "nextcloud";
                node = "cache";
              };
            };
          };

          "searxng" = {
            "main" = (import ./nodes/searxng/main/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = (import ./modules/constants.nix) // {
                cluster = "searxng";
                node = "main";
              };
            };
          };

          "jupyter" = {
            "main" = (import ./nodes/jupyter/main/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = (import ./modules/constants.nix) // {
                cluster = "jupyter";
                node = "main";
              };
            };
          };

          "dns" = {
            "main" = (import ./nodes/dns/main/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = (import ./modules/constants.nix) // {
                cluster = "dns";
                node = "main";
              };
            };

            "recursive" = (import ./nodes/dns/recursive/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = (import ./modules/constants.nix) // {
                cluster = "dns";
                node = "recursive";
              };
            };
          };
        };

        agenix-rekey = inputs.agenix-rekey.configure {
          userFlake = self;
          nixosConfigurations =
            let
              lib = inputs.nixpkgs.lib;

              colmenaNodeConfigurations = (self.colmenaHive.introspect (x: x)).nodes;

              flattenedNodeConfigurations = (
                lib.attrsets.listToAttrs (
                  lib.lists.flatten (
                    lib.attrsets.mapAttrsToList (
                      clusterName: cluster:
                      lib.attrsets.mapAttrsToList (nodeName: node: {
                        name = "${clusterName}-${nodeName}";
                        value = node.nixosSystem;
                      }) cluster
                    ) self.nodeConfigurations
                  )
                )
              );
            in
            lib.mergeAttrsList [
              colmenaNodeConfigurations
              flattenedNodeConfigurations
            ];
        };
      };
    };
}
