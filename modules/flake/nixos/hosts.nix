{
  config,
  inputs,
  self,
  flakeRoot,
  withSystem,
  ...
}:
let
  nixpkgs-lib = inputs.nixpkgs.lib;
in
{
  flake.nixosConfigurations =
    let
      importApplyHost =
        entryPoint:
        let
          specialArgs = {
            inherit inputs flakeRoot;
          };

          injectedModules = nixpkgs-lib.lists.singleton (
            { config, ... }:
            {
              config = {
                # Use the `pkgs` instance from the current flake. Note that
                # `inputs.nixpkgs.nixosModules.readOnlyPkgs` is not usable with colmena and
                # `nixpkgs.hostPlatform.system` defined inside a NixOS module. So we simply don't
                # import that module and unset any potential modification to `pkgs`
                nixpkgs.pkgs = nixpkgs-lib.mkForce (
                  withSystem config.nixpkgs.hostPlatform.system ({ pkgs, ... }: pkgs)
                );
                # To pass assertion `options.nixpkgs.pkgs.isDefined -> config.nixpkgs.config == { }`
                nixpkgs.config = nixpkgs-lib.mkForce { };
                nixpkgs.overlays = nixpkgs-lib.mkForce [ ];
              };
            }
          );
        in
        (import entryPoint) specialArgs injectedModules;
    in
    {
      "interference" = importApplyHost (flakeRoot + /inventory/hosts/interference/entry-point.nix);
      "superposition" = importApplyHost (flakeRoot + /inventory/hosts/superposition/entry-point.nix);
      "topological" = importApplyHost (flakeRoot + /inventory/hosts/topological/entry-point.nix);
    };
}
