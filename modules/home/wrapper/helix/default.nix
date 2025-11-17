{
  config,
  lib,
  pkgs,
  ...
}:
let
  helixExecutable = lib.getExe (config.wrappers.helix.wrapped or pkgs.helix);
in
{
  settings.zsh.environment = {
    EDITOR = helixExecutable;
  };
}
