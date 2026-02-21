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
        config.age.secrets."starryreverie-opencode-auth.json".path;
    };

    age.secrets."starryreverie-opencode-auth.json" = {
      rekeyFile = ./starryreverie-opencode-auth.json.age;
      configureForUser = config.users.users.starryreverie.name;
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
