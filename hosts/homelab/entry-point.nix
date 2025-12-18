{ inputs, flakeRoot, ... }@specialArgs:
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs;

  extraModules = [
    inputs.colmena.nixosModules.deploymentOptions
  ];

  modules = [
    # Colmena metadata
    {
      deployment.allowLocalDeployment = true;
      deployment.buildOnTarget = true;
      deployment.targetHost = "starrynix-homelab.tail931dca.ts.net";
      deployment.tags = [ "server" ];
    }

    # External modules
    inputs.nix-maid.nixosModules.default

    # StarryNix-Infrastructure
    (flakeRoot + /modules/system/starrynix-infrastructure/host)
    (flakeRoot + /nodes/registry.nix)

    # Local modules
    ./system/top-level.nix
    ./users/root/top-level.nix
    ./users/starryreverie/top-level.nix
  ];
}
