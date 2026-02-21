{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.csl or { };
  customCfg = selfCfg.applications.firefox or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    preservation.preserveAt."/nix/persistence" = {
      users.csl = {
        directories = [ ".config/mozilla/firefox" ];
      };
    };

    users.users.csl.maid = {
      # FIXME: Firefox's migration to XDG User Directory Specification is not completed. This
      # directory can't be moved currently.
      file.home.".mozilla/native-messaging-hosts".source =
        "{{xdg_config_home}}/mozilla/firefox/native-messaging-hosts";
    };
  };
}
