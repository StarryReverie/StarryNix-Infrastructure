{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  customCfg = config.custom.system.core.nix;
in
{
  config = lib.mkIf customCfg.enable {
    nix.registry.nixpkgs.flake = inputs.nixpkgs;

    nix.settings.nix-path = lib.mkForce [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];

    environment.etc =
      let
        pair = name: value: { ${name} = value; };

        hashOf =
          storePath:
          lib.pipe storePath [
            (lib.strings.removePrefix "${builtins.storeDir}/")
            (x: lib.lists.head (lib.strings.splitString "-" x))
            builtins.unsafeDiscardStringContext
          ];

        traverseInputs =
          flake: visited:
          lib.lists.foldl' (
            visited:
            { name, value }:
            let
              key = "${hashOf value}-${name}";
              newVisited = visited // pair key value.outPath;
            in
            if name == "self" || visited ? key then visited else newVisited // (traverseInputs value newVisited)
          ) { } (lib.attrsets.attrsToList (flake.inputs or { }));

        pinPaths = lib.flip lib.attrsets.mapAttrs' (traverseInputs { inherit inputs; } { }) (
          key: source: {
            name = "nix/inputs/${key}";
            value = { inherit source; };
          }
        );
      in
      pinPaths;
  };
}
