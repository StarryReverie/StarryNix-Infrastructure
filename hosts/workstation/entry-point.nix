{ inputs, ... }@specialArgs:
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs;

  extraModules = [
    inputs.colmena.nixosModules.deploymentOptions
  ];

  modules = [
    # Colmena metadata
    {
      deployment.allowLocalDeployment = true;
      deployment.targetHost = null;
      deployment.tags = [ "workstation" ];
    }

    # External modules
    inputs.agenix-rekey.nixosModules.default
    inputs.agenix.nixosModules.default
    inputs.nix-maid.nixosModules.default
    inputs.preservation.nixosModules.default

    # Local modules
    ./system/top-level.nix
    ./users/starryreverie/top-level.nix
  ];
}
