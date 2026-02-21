{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.nautilus or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      gsettings.settings = {
        org.gnome.nautilus = {
          preferences.date-time-format = "detailed";
          preferences.default-folder-viewer = "list-view";
        };
      };
    };

    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".local/share/nautilus" ];
      };
    };
  };
}
