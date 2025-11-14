{
  config,
  lib,
  pkgs,
  ...
}:
{
  settings.zsh.environment = {
    EDITOR = lib.getExe pkgs.helix;
  };
}
