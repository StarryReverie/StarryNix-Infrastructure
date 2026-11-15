{
  description = "Declarative and virtualized service deployment and orchestraion infrastructure built on the Nix/NixOS ecosystem.";

  inputs.crane = {
    url = "github:ipetkov/crane/master";
  };

  inputs.deploy-rs = {
    url = "github:serokell/deploy-rs/master";
    inputs.flake-compat = {
      follows = "flake-compat";
    };
    inputs.nixpkgs = {
      follows = "nixpkgs";
    };
    inputs.utils = {
      follows = "flake-utils";
    };
  };

  inputs.disko = {
    url = "github:nix-community/disko/master";
    inputs.nixpkgs = {
      follows = "nixpkgs";
    };
  };

  inputs.flake-compat = {
    url = "https://git.lix.systems/lix-project/flake-compat/archive/main.tar.gz";
  };

  inputs.flake-parts = {
    url = "github:hercules-ci/flake-parts/main";
    inputs.nixpkgs-lib = {
      follows = "nixpkgs";
    };
  };

  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems = {
      follows = "systems";
    };
  };

  inputs.flakey-profile = {
    url = "github:lf-/flakey-profile/main";
  };

  inputs.git-hooks = {
    url = "github:cachix/git-hooks.nix/master";
    inputs.flake-compat = {
      follows = "flake-compat";
    };
    inputs.nixpkgs = {
      follows = "nixpkgs";
    };
  };

  inputs.import-tree = {
    url = "github:vic/import-tree/main";
  };

  inputs.microvm = {
    url = "github:microvm-nix/microvm.nix/main";
    inputs.nixpkgs = {
      follows = "nixpkgs";
    };
    inputs.spectrum = {
      follows = "void";
    };
  };

  inputs.nix-maid = {
    url = "https://codeberg.org/viperML/nix-maid/archive/master.tar.gz";
  };

  inputs.nixpkgs = {
    url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  inputs.preservation = {
    url = "github:nix-community/preservation/main";
  };

  inputs.selector4nix = {
    url = "github:StarryReverie/selector4nix/master";
    inputs.crane = {
      follows = "crane";
    };
    inputs.flake-parts = {
      follows = "flake-parts";
    };
  };

  inputs.starrynix-derivations = {
    url = "github:StarryReverie/StarryNix-Derivations/main";
    inputs.flake-parts = {
      follows = "flake-parts";
    };
    inputs.systems = {
      follows = "systems";
    };
  };

  inputs.starrynix-resources = {
    url = "github:StarryReverie/StarryNix-Resources/master";
    inputs.flake-compat = {
      follows = "flake-compat";
    };
    inputs.flake-parts = {
      follows = "flake-parts";
    };
    inputs.nixpkgs = {
      follows = "nixpkgs";
    };
  };

  inputs.systems = {
    url = "github:nix-systems/default-linux/main";
  };

  inputs.vaultix = {
    url = "github:milieuim/vaultix/main";
    inputs.crane = {
      follows = "crane";
    };
    inputs.flake-parts = {
      follows = "flake-parts";
    };
    inputs.pre-commit-hooks = {
      follows = "git-hooks";
    };
  };

  inputs.void = {
    url = "github:StarryReverie/void/main";
  };

  inputs.wrapper-manager = {
    url = "https://codeberg.org/viperML/wrapper-manager/archive/master.tar.gz";
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
