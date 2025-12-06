{
  config,
  lib,
  pkgs,
  ...
}:
let
  direnvExecutable = lib.getExe pkgs.direnv;
in
{
  settings.zsh.rcContent = ''
    eval "$(${direnvExecutable} hook zsh)"
  '';
}
