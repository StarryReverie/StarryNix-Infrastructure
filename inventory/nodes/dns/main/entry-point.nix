{ inputs, flakeRoot, ... }@specialArgs:
inputs.self.lib.makeNodeEntryPoint {
  inherit specialArgs;
  modules = [
    (flakeRoot + /modules/system/starrynix-infrastructure/node)
    (flakeRoot + /inventory/nodes/registry.nix)
    ./service.nix
    ./system.nix
  ];
}
