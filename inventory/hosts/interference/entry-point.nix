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
      deployment.allowLocalDeployment = false;
      deployment.buildOnTarget = true;
      deployment.targetHost = "interference.tail931dca.ts.net";
      deployment.tags = [ "server" ];
    }

    # External modules
    inputs.disko.nixosModules.default
    inputs.nix-maid.nixosModules.default
    inputs.preservation.nixosModules.default
    inputs.selector4nix.nixosModules.default
    inputs.vaultix.nixosModules.vaultix

    # Local modules
    (flakeRoot + /modules/nixos-modules.nix)
    (inputs.import-tree.matchNot "([^/]*/)*entry-point.nix" ./.)
  ];
}
