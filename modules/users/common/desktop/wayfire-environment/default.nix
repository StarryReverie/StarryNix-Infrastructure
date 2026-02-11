{
  config,
  lib,
  pkgs,
  ...
}:
let
  settingsFormat = pkgs.formats.ini { };

  customWayfireEnvironmentModule =
    { name, ... }:
    let
      selfCfg = config.custom.users.${name};
      customCfg = selfCfg.desktop.wayfire-environment;
    in
    {
      options.desktop.wayfire-environment = {
        settings = lib.mkOption {
          type = lib.types.submodule { freeformType = settingsFormat.type; };
          description = "Content of `wayfire.ini`";
          default = { };
          example = {
            autostart = {
              "00_environment" =
                "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE";
            };
          };
        };
      };

      config = {
        desktop.wayfire-environment = {
          settings = {
            autostart = lib.mkIf customCfg.enable {
              "00_environment" =
                "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE";
              "01_systemd_notify" = "sleep 0.5 && systemd-notify --ready";
            };
          };
        };
      };
    };

  customWayfireEnvironmentEffectModule =
    { name, ... }:
    let
      selfCfg = config.custom.users.${name} or { };
      customCfg = selfCfg.desktop.wayfire-environment or { };
    in
    {
      config = lib.mkIf (customCfg.enable or false) {
        maid = {
          file.xdg_config."wayfire/wayfire.ini".source =
            settingsFormat.generate "wayfire.ini" customCfg.settings;
        };
      };
    };
in
{
  options.custom.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customWayfireEnvironmentModule);
  };

  options.users.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customWayfireEnvironmentEffectModule);
  };
}
