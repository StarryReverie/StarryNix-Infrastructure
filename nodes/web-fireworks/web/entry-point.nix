{ inputs, flakeRoot, ... }@specialArgs:
inputs.self.lib.makeNodeEntryPoint specialArgs {
  modules = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
    inputs.microvm.nixosModules.microvm
    (flakeRoot + /modules/nixos/starrynix-infrastructure/node)
    (flakeRoot + /nodes/registry.nix)
    ./system.nix
    ./service.nix
  ];
}
