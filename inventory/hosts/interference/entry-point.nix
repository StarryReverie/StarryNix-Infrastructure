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
    inputs.agenix-rekey.nixosModules.default
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.default
    inputs.nix-maid.nixosModules.default
    inputs.preservation.nixosModules.default
    inputs.selector4nix.nixosModules.default

    # Local modules
    (flakeRoot + /modules/nixos-modules.nix)
    (inputs.import-tree.matchNot "([^/]*/)*entry-point.nix" ./.)
  ];
}
