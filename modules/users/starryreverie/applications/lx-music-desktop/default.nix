{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.applications.lx-music-desktop;
in
{
  config = lib.mkIf customCfg.enable {
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
