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
    eval "$(${lib.getExe config.wrapperConfigurations.finalPackages.zoxide} init zsh --cmd cd)"
  '';
}
