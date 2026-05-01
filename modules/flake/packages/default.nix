{
  config,
  inputs,
  self,
  ...
}:
let
  nixpkgs-lib = inputs.nixpkgs.lib;
in
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;

        overlays = (nixpkgs-lib.attrsets.attrValues config.flake.overlays) ++ [
          (final: prev: {
            pkgsExternal =
              let
                mkPackageSet =
                  flake:
                  if flake.legacyPackages.${system} or { } != { } then
                    flake.legacyPackages.${system}
                  else
                    flake.packages.${system} or { };

                externalPackageSet = nixpkgs-lib.pipe inputs [
                  (nixpkgs-lib.attrsets.mapAttrs (name: flake: mkPackageSet flake))
                  (nixpkgs-lib.attrsets.filterAttrs (name: flakePkgs: flakePkgs != { }))
                ];
              in
              externalPackageSet;
          })
        ];

        config = {
          allowUnfree = true;

          permittedInsecurePackages = [
            "minio-2025-10-15T17-29-55Z"
          ];
        };
      };
    };
}
