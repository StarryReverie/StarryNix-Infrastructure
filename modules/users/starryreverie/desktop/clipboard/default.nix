{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie.maid = {
    packages = with pkgs; [
      wl-clipboard
      cliphist
      (pkgs.writeScriptBin "clipboard-select" (builtins.readFile ./clipboard-select.sh))
    ];
  };
}
