{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.direnv.stdlib = builtins.readFile ./stdlib.sh;
  programs.direnv.silent = true;
}
