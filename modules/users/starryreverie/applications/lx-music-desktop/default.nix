{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.lx-music-desktop or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [ lx-music-desktop ];
    };

    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".config/lx-music-desktop" ];
      };
    };
  };
}
