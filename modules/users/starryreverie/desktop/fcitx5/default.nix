{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  # Requires the corresponding system module
  imports = [ (flakeRoot + /modules/system/desktop/fcitx5) ];

  config = lib.mkIf (config.i18n.inputMethod.enable && config.i18n.inputMethod.type == "fcitx5") {
    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [
          ".config/fcitx5"
          ".local/share/fcitx5"
        ];
      };
    };
  };
}
