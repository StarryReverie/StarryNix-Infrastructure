{ inputs, flakeRoot, ... }@specialArgs:
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs;

  extraModules = [
    inputs.colmena.nixosModules.deploymentOptions
  ];

  modules = [
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

    # Local modules
    (flakeRoot + /modules/nixos-modules.nix)
    ./system/top-level.nix
    ./users/root/top-level.nix
    ./users/starryreverie/top-level.nix
  ];
}
