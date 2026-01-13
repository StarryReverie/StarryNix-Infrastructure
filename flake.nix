{
  description = "Declarative and virtualized service deployment and orchestraion infrastructure built on the Nix/NixOS ecosystem.";

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
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.stable.follows = "";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-maid = {
      url = "github:viperML/nix-maid/master";
    };

    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    preservation = {
      url = "github:nix-community/preservation/main";
    };

    starrynix-derivations = {
      url = "github:StarryReverie/StarryNix-Derivations/master";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    starrynix-resources = {
      url = "github:StarryReverie/StarryNix-Resources/master";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
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
        lib = import ./lib inputs;

        overlays = import ./modules/system/core/nix/overlays/all-overlays.nix inputs;

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

        nixosConfigurations =
          let
            importHost =
              path:
              import path {
                inherit inputs flakeRoot;
              };
          in
          {
            "homelab" = importHost ./hosts/homelab/entry-point.nix;
            "workstation" = importHost ./hosts/workstation/entry-point.nix;
          };

        nodeConfigurations =
          let
            importNode =
              path: nodeConstants:
              import path {
                inherit inputs flakeRoot nodeConstants;
              };
            makeNodeEntry = cluster: node: {
              ${cluster}.${node} = importNode ./nodes/${cluster}/${node}/entry-point.nix {
                inherit cluster node;
              };
            };
          in
          inputs.nixpkgs.lib.foldAttrs inputs.nixpkgs.lib.recursiveUpdate { } [
            (makeNodeEntry "jellyfin" "main")
            (makeNodeEntry "nextcloud" "main")
            (makeNodeEntry "nextcloud" "storage")
            (makeNodeEntry "nextcloud" "cache")
            (makeNodeEntry "searxng" "main")
            (makeNodeEntry "jupyter" "main")
            (makeNodeEntry "dns" "main")
            (makeNodeEntry "dns" "recursive")
          ];

        agenix-rekey = inputs.agenix-rekey.configure {
          userFlake = self;
          nixosConfigurations =
            let
              lib = inputs.nixpkgs.lib;

              colmenaNodeConfigurations = (self.colmenaHive.introspect (x: x)).nodes;

              microvmNodeConfigurations = lib.pipe self.nodeConfigurations [
                (lib.attrsets.mapAttrsToList (
                  clusterName: cluster:
                  lib.attrsets.mapAttrsToList (nodeName: node: {
                    name = "${clusterName}-${nodeName}";
                    value = node.nixosSystem;
                  }) cluster
                ))
                lib.lists.flatten
                lib.attrsets.listToAttrs
              ];
            in
            lib.mergeAttrsList [
              colmenaNodeConfigurations
              microvmNodeConfigurations
            ];
        };
      };
    };
}
