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
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        ./modules/flake/dev-environment
        ./modules/flake/lib
        ./modules/flake/nixos
        ./modules/flake/overlays
        ./modules/flake/packages
        ./modules/flake/profiles
      ];

      _module.args = {
        flakeRoot = ./.;
      };
    };
}
