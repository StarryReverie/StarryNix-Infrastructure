{ inputs, flakeRoot, ... }@specialArgs:
inputs.self.lib.makeNodeEntryPoint {
  inherit specialArgs;
  modules = [
    inputs.microvm.nixosModules.microvm
    inputs.vaultix.nixosModules.vaultix
    (flakeRoot + /modules/system/starrynix-infrastructure/node)
    (flakeRoot + /inventory/nodes/registry.nix)
    ./service.nix
    ./system.nix
  ];
}
