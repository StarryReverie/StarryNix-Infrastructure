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
      deployment.buildOnTarget = true;
      deployment.targetHost = "topological.tail931dca.ts.net";
      deployment.tags = [ "server" ];
    }

    # External modules
    inputs.disko.nixosModules.default
    inputs.nix-maid.nixosModules.default
    inputs.preservation.nixosModules.default

    # StarryNix-Infrastructure
    (flakeRoot + /modules/system/starrynix-infrastructure/host)
    (flakeRoot + /inventory/nodes/registry.nix)

    # Local modules
    (flakeRoot + /modules/nixos-modules.nix)
    (inputs.import-tree.matchNot "([^/]*/)*entry-point\.nix" ./.)
  ];
}
