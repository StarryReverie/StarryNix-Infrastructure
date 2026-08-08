{ inputs, flakeRoot, ... }@specialArgs:
injectedModules:
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs;

  modules = injectedModules ++ [
    # External modules
    inputs.disko.nixosModules.default
    inputs.microvm.nixosModules.host
    inputs.nix-maid.nixosModules.default
    inputs.preservation.nixosModules.default
    inputs.selector4nix.nixosModules.default
    inputs.vaultix.nixosModules.vaultix

    # StarryNix-Infrastructure
    (flakeRoot + /modules/system/starrynix-infrastructure/host)
    (flakeRoot + /inventory/nodes/registry.nix)

    # Local modules
    (flakeRoot + /modules/nixos-modules.nix)
    (inputs.import-tree.matchNot "([^/]*/)*entry-point.nix" ./.)
  ];
}
