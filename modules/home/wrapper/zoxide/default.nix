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
    eval "$(${lib.getExe config.wrapping.packages.zoxide} init zsh --cmd cd)"
  '';
}
