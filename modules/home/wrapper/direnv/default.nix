{
  config,
  lib,
  pkgs,
  ...
}:
let
  direnvExecutable = lib.getExe (config.wrappers.direnv.wrapped or pkgs.direnv);
in
{
  settings.zsh.initContent = ''
    eval "$(${direnvExecutable} hook zsh)"
  '';
}
