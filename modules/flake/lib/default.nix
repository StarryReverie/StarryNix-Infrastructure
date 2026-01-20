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
  imports = [
    ./profiles

    ./make-node-entry-point.nix
  ];

  options.flake.lib = nixpkgs-lib.mkOption {
    type = nixpkgs-lib.types.submodule {
      freeformType = nixpkgs-lib.types.attrsOf nixpkgs-lib.types.raw;
    };
    description = ''
      Pure library of functions. Functions are grouped by hierarchical
      namespaces. It is expected that:

      - The filesystem structure is aligned with the namespace structure. Every
        directory is corresponded to a namespace.
      - Only public functions are accessible from the library. Private functions
        should be hidden or exported in a special namespace `internal`.
      - Every `default.nix` specifies its sub-namespaces and imports them
        explicitly and exclusively.
      - Every non-`default.nix` file defines only one public function, and
        several private function, if necessary.
      - Constants are also allowed, since they can be treated as functions
        without any parameters.
    '';
    default = { };
    example = ''
      # <lib-root>/default.nix
      { ... }:
      {
        imports = [
          # Sub-namespaces
          ./lists

          # Functions in current namespace `lib`
          ./const.nix
          ./id.nix
        ];
      }

      # <lib-root>/lists/default.nix
      { ... }:
      {
        imports = [
          # Functions in current namespace `lib.lists`
          ./map.nix
        ];
      }

      # <lib-root>/lists/map.nix
      { ... }:
      {
        flake.lib.lists = {
          fmap =
            let
              fmap = f: xs: if xs == [ ] then [ ] else [ (f (builtins.head xs)) ] ++ (fmap f (builtins.tail xs));
            in
            fmap;
        };
      }

      # <lib-root>/const.nix
      { ... }:
      {
        flake.lib = {
          const = a: _: a;
        };
      }

      # <lib-root>/id.nix
      { ... }:
      {
        flake.lib = {
          id = x: x;
        };
      }
    '';
  };
}
