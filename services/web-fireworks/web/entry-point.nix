{ inputs, flakeRoot, ... }@specialArgs:
inputs.self.lib.makeServiceEntryPoint specialArgs {
  modules = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
    inputs.microvm.nixosModules.microvm
    (flakeRoot + /modules/nixos/starrynix-infrastructure/service)
    (flakeRoot + /services/registry.nix)
    ./system.nix
    ./service.nix
  ];
}
