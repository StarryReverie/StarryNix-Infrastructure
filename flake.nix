{
  description = "Declarative and virtualized service deployment and orchestraion infrastructure built on the Nix/NixOS ecosystem.";

  inputs = {
    colmena = {
      url = "github:zhaofengli/colmena/main";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nix-github-actions.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.stable.follows = "";
    };

    crane = {
      url = "github:ipetkov/crane/master";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs/master";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    disko = {
      url = "github:nix-community/disko/master";
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

    flakey-profile = {
      url = "github:lf-/flakey-profile/main";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix/master";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree = {
      url = "github:vic/import-tree/main";
    };

    microvm = {
      url = "github:microvm-nix/microvm.nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.spectrum.follows = "";
    };

    nclock-background = {
      url = "github:StarryReverie/nclock-background/main";
      inputs.flake-parts.follows = "flake-parts";
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

    selector4nix = {
      url = "github:StarryReverie/selector4nix/master";
      inputs.crane.follows = "crane";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
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

    vaultix = {
      url = "github:milieuim/vaultix/main";
      inputs.crane.follows = "crane";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "git-hooks";
    };

    wrapper-manager = {
      url = "github:viperML/wrapper-manager/master";
    };
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        (inputs.nixpkgs.lib.modules.importApply ./modules/flake-modules.nix {
          inherit (inputs) import-tree;
        })
      ];

      _module.args = {
        flakeRoot = ./.;
      };
    };
}
