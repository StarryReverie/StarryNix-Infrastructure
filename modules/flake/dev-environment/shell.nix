{
  config,
  inputs,
  self,
  ...
}:
{
  perSystem =
    { system, pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        packages = [
          pkgs.nixfmt
          pkgs.nixfmt-tree
        ];
      };
    };
}
