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
          pkgs.deploy-rs.deploy-rs
          pkgs.nixfmt
          pkgs.nixfmt-tree
        ];
      };
    };
}
