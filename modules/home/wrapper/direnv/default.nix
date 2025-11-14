{
  config,
  lib,
  pkgs,
  ...
}:
{
  settings.zsh.initContent = ''
    eval "$(${lib.getExe pkgs.direnv} hook zsh)"
  '';
}
