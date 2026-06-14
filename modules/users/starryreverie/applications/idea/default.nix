{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.idea or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [ jetbrains.idea-oss ];

    };

    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [
          ".config/JetBrains"
          ".local/share/JetBrains"
        ];
      };
    };
  };
}
