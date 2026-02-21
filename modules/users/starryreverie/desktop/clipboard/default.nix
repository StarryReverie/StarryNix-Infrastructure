{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.desktop.clipboard or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [
        wl-clipboard
        cliphist
        (pkgs.writeScriptBin "clipboard-select" (builtins.readFile ./clipboard-select.sh))
      ];
    };
  };
}
