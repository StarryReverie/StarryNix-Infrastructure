{
  config,
  inputs,
  withSystem,
  self,
  flakeRoot,
  ...
}:
let
  nixpkgs-lib = inputs.nixpkgs.lib;
  self-lib = self.lib;
in
{
  flake.profileConfigurations =
    let
      makeProfileEntry = profile: {
        ${profile} = self-lib.profiles.importProfile (
          flakeRoot + /inventory/profiles/${profile}/entry-point.nix
        );
      };
    in
    nixpkgs-lib.foldAttrs nixpkgs-lib.recursiveUpdate { } [
      (makeProfileEntry "ancilla")
    ];
}
