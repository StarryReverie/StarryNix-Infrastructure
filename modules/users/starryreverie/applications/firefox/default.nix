{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.firefox or { };
in
{
  config = lib.mkMerge [
    (lib.mkIf (customCfg.enable or false) {
      preservation.preserveAt."/nix/persistence" = {
        users.starryreverie = {
          directories = [ ".config/mozilla/firefox" ];
        };
      };

      users.users.starryreverie.maid = {
        # FIXME: Firefox's migration to XDG User Directory Specification is not completed. This
        # directory can't be moved currently.
        file.home.".mozilla/native-messaging-hosts".source =
          "{{xdg_config_home}}/mozilla/firefox/native-messaging-hosts";
      };
    })

    (lib.mkIf ((customCfg.enable or false) && (selfCfg.applications.keepassxc.enable or false)) {
      users.users.starryreverie.maid = {
        file.xdg_config."mozilla/firefox/native-messaging-hosts/org.keepassxc.keepassxc_browser.json".source =
          pkgs.replaceVars ./native-messaging-hosts-keepassxc.json {
            keepassxcProxyPath = "${pkgs.keepassxc}/bin/keepassxc-proxy";
          };
      };
    })
  ];
}
