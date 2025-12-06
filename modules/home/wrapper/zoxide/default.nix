{
  config,
  lib,
  pkgs,
  ...
}:
let
  zoxideExecutable = lib.getExe pkgs.zoxide;
in
{
  settings.zsh.rcContent = ''
    # Zoxide integration
    eval "$(${zoxideExecutable} init zsh --cmd cd)"
  '';
}
