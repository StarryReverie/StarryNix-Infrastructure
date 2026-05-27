{ inputs, flakeRoot, ... }@specialArgs:
inputs.self.lib.makeNodeEntryPoint {
  inherit specialArgs;
  modules = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
    inputs.microvm.nixosModules.microvm
    (flakeRoot + /modules/system/starrynix-infrastructure/node)
    (flakeRoot + /inventory/nodes/registry.nix)
    ./service.nix
    ./system.nix
  ];
}
