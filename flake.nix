{
  description = "StarryNix-Infrastructure";

  inputs = {
    agenix = {
      url = "github:ryantm/agenix/main";
      inputs.home-manager.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey/main";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.inputs.flake-compat.follows = "flake-compat";
    };

    colmena = {
      url = "github:zhaofengli/colmena/main";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.stable.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = "https://git.lix.systems/lix-project/flake-compat/archive/main.tar.gz";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts/main";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    microvm = {
      url = "github:microvm-nix/microvm.nix/main";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-maid = {
      url = "github:viperML/nix-maid/master";
    };

    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    starrynix-derivations = {
      url = "github:StarryReverie/StarryNix-Derivations/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
    };

    starrynix-resources = {
      url = "github:StarryReverie/StarryNix-Resources/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
    };

    systems = {
      url = "github:nix-systems/default-linux/main";
    };

    wrapper-manager = {
      url = "github:viperML/wrapper-manager/master";
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
        { system, pkgs, ... }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = inputs.nixpkgs.lib.attrsets.attrValues self.overlays;
          };

          devShells.default = pkgs.mkShellNoCC {
            packages = [
              inputs.agenix-rekey.packages.${system}.default
              pkgs.colmena
              pkgs.nil
              pkgs.nixfmt
              pkgs.nixfmt-tree
            ];
          };

          formatter = pkgs.nixfmt-tree;
        };

      flake = {
        lib = import ./lib;

        overlays = import ./modules/system/nix/overlays/all-overlays.nix inputs;

        colmenaHive = inputs.colmena.lib.makeHive self.colmenaArg;

        colmenaArg =
          let
            conf = self.nixosConfigurations;
          in
          (builtins.mapAttrs (name: value: { imports = value._module.args.modules; }) conf)
          // {
            meta.nixpkgs = import inputs.nixpkgs {
              system = "x86_64-linux";
              overlays = inputs.nixpkgs.lib.attrsets.attrValues self.overlays;
            };
            meta.nodeNixpkgs = builtins.mapAttrs (name: value: value.pkgs) conf;
            meta.nodeSpecialArgs = builtins.mapAttrs (name: value: value._module.specialArgs) conf;
          };

        nixosConfigurations = {
          "homelab" = (import ./hosts/homelab/entry-point.nix) {
            inherit inputs flakeRoot;
          };

          "workstation" = (import ./hosts/workstation/entry-point.nix) {
            inherit inputs flakeRoot;
          };
        };

        nodeConfigurations = {
          "jellyfin" = {
            "main" = (import ./nodes/jellyfin/main/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = {
                cluster = "jellyfin";
                node = "main";
              };
            };
          };

          "nextcloud" = {
            "main" = (import ./nodes/nextcloud/main/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = {
                cluster = "nextcloud";
                node = "main";
              };
            };

            "storage" = (import ./nodes/nextcloud/storage/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = {
                cluster = "nextcloud";
                node = "storage";
              };
            };

            "cache" = (import ./nodes/nextcloud/cache/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = {
                cluster = "nextcloud";
                node = "cache";
              };
            };
          };

          "searxng" = {
            "main" = (import ./nodes/searxng/main/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = {
                cluster = "searxng";
                node = "main";
              };
            };
          };

          "jupyter" = {
            "main" = (import ./nodes/jupyter/main/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = {
                cluster = "jupyter";
                node = "main";
              };
            };
          };

          "dns" = {
            "main" = (import ./nodes/dns/main/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = {
                cluster = "dns";
                node = "main";
              };
            };

            "recursive" = (import ./nodes/dns/recursive/entry-point.nix) {
              inherit inputs flakeRoot;
              system = "x86_64-linux";
              nodeConstants = {
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
