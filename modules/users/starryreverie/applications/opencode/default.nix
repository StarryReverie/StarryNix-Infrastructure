{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.opencode or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [ opencode ];

      file.xdg_data."opencode/auth.json".source =
        config.vaultix.secrets."starryreverie-opencode-auth.json".path;
    };

    vaultix.secrets."starryreverie-opencode-auth.json" = {
      file = ./starryreverie-opencode-auth.json.age;
      owner = config.users.users.starryreverie.name;
      group = config.users.users.starryreverie.group;
    };

    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [
          ".config/opencode"
          ".local/share/opencode"
          ".local/state/opencode"
        ];
      };
    };
  };
}
