{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  customCfg = config.custom.system.desktop.wayfire-environment;
in
{
  config = lib.mkMerge [
    (lib.mkIf customCfg.enable {
      environment.systemPackages = [ pkgs.wayfire ];

      services.displayManager.sessionPackages = lib.singleton (
        pkgs.runCommandLocal "wayfire-session-desktop-item"
          {
            passthru.providedSessions = [ "wayfire" ];
          }
          ''
            desktop_item=${
              pkgs.makeDesktopItem {
                name = "wayfire";
                desktopName = "Wayfire";
                exec = pkgs.writeShellScript "wayfire-session" (builtins.readFile ./wayfire-session.sh);
                type = "Application";
              }
            }

            mkdir -p $out/share/wayland-sessions
            cp $desktop_item/share/applications/wayfire.desktop $out/share/wayland-sessions/
          ''
      );

      systemd.user.services."wayfire" = {
        description = "A customizable, extendable and lightweight environment without sacrificing its appearance";
        serviceConfig.ExecStart = "${pkgs.wayfire}/bin/wayfire";
        serviceConfig.Type = "notify";
        serviceConfig.NotifyAccess = "all";
        serviceConfig.Slice = "session.slice";
        environment = lib.mkForce { };
        bindsTo = [
          "graphical-session.target"
          "wayfire-session.target"
        ];
        wants = [
          "graphical-session-pre.target"
        ];
        after = [
          "graphical-session-pre.target"
        ];
        before = [
          "graphical-session.target"
          "wayfire-session.target"
        ];
      };

      systemd.user.targets."wayfire-session" = {
        description = "Current Wayfire graphical user session";
        requires = [ "basic.target" ];
        unitConfig.RefuseManualStart = true;
        unitConfig.StopWhenUnneeded = true;
      };

      systemd.user.targets."wayfire-shutdown" = {
        description = "Shutdown running Wayfire session";
        after = [
          "graphical-session-pre.target"
          "graphical-session.target"
          "wayfire-session.target"
        ];
        conflicts = [
          "graphical-session-pre.target"
          "graphical-session.target"
          "wayfire-session.target"
        ];
        unitConfig.DefaultDependencies = false;
        unitConfig.StopWhenUnneeded = true;
      };

      xdg.portal = {
        enable = true;
        wlr.enable = true;
        config.wayfire.default = [
          "wlr"
          "gtk"
        ];
      };
    })

    (lib.mkIf customCfg.enable (
      import (modulesPath + "/programs/wayland/wayland-session.nix") {
        inherit lib pkgs;
        enableXWayland = true;
      }
    ))
  ];
}
