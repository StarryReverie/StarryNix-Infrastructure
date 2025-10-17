{ inputs, constants, ... }@args:
inputs.nixpkgs.lib.nixosSystem {
  inherit (constants) system;

  specialArgs = args;

  modules = [
    ./system.nix
    inputs.home-manager.nixosModules.home-manager

    {
      home-manager.useUserPackages = true;
      home-manager.users.${constants.username} = import ./home.nix;
      home-manager.extraSpecialArgs = args;
      home-manager.backupFileExtension = "bak";
    }
  ];
}
