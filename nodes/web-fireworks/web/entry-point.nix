{ inputs, flakeRoot, ... }@specialArgs:
inputs.self.lib.makeNodeEntryPoint inputs.nixpkgs.lib specialArgs {
  modules = [
    (flakeRoot + /modules/nixos/starrynix-infrastructure/node)
    (flakeRoot + /nodes/registry.nix)
    ./system.nix
    ./service.nix
  ];
}
