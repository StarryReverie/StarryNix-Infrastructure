{
  config,
  lib,
  pkgs,
  ...
}:
{
  wrappers.zoxide.basePackage = pkgs.zoxide;

  settings.zsh.initContent = ''
    # Zoxide integration
    eval "$(${lib.getExe config.wrappers.zoxide.wrapped} init zsh --cmd cd)"
  '';
}
