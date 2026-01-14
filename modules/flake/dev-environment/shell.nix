{
  config,
  inputs,
  withSystem,
  ...
}:
{
  perSystem =
    { system, pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        packages = [
          inputs.agenix-rekey.packages.${system}.default
          pkgs.colmena
          pkgs.nil
          pkgs.nixfmt
          pkgs.nixfmt-tree
        ];
      };
    };
}
