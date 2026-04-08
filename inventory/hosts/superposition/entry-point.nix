{ inputs, flakeRoot, ... }@specialArgs:
injectedModules:
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs;

  extraModules = [
    inputs.colmena.nixosModules.deploymentOptions
  ];

  modules = injectedModules ++ [
    # Colmena metadata
    {
      deployment.allowLocalDeployment = true;
      deployment.targetHost = null;
      deployment.tags = [ "workstation" ];
    }

    # External modules
    inputs.agenix-rekey.nixosModules.default
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.default
    inputs.nix-maid.nixosModules.default
    inputs.preservation.nixosModules.default

    # Local modules
    (flakeRoot + /modules/nixos-modules.nix)
    (inputs.import-tree.matchNot "([^/]*/)*entry-point.nix" ./.)
  ];
}
