{
  config,
  lib,
  pkgs,
  ...
}:
let
  zoxideExecutable = lib.getExe (config.wrappers.zoxide.wrapped or pkgs.zoxide);
in
{
  settings.zsh.initContent = ''
    # Zoxide integration
    eval "$(${zoxideExecutable} init zsh --cmd cd)"
  '';
}
