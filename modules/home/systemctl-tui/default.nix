{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [ systemctl-tui ];

  home.shellAliases = {
    sctl = "systemctl-tui";
  };
}
