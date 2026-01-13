{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  # Requires the corresponding system module
  imports = [ (flakeRoot + /modules/system/applications/nautilus) ];

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
}
