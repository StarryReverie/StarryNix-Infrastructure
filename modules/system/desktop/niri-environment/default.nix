{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.desktop.niri-environment;
in
{
  config = lib.mkIf customCfg.enable {
    programs.niri.enable = true;

    systemd.user.services."niri" = {
      # Niri ships with a `niri.service` unit, so the configuration here is
      # actually a drop-in override. Environment variables here should be forced
      # to be `{ }`, otherwise a default `PATH` for services is injected here,
      # clearing all inherited paths and making the WM totally unuseable without
      # `/run/current-system/sw/bin`, `/etc/profiles/per-user/<username>/bin` and
      # potentially other paths.
      environment = lib.mkForce { };
      bindsTo = [
        "graphical-session.target"
        "niri-session.target"
      ];
      before = [
        "graphical-session.target"
        "niri-session.target"
      ];
    };

    systemd.user.targets."niri-session" = {
      description = "Current Niri graphical user session";
      documentation = [ "man:systemd.special(7)" ];
      requires = [ "basic.target" ];
      unitConfig.RefuseManualStart = true;
      unitConfig.StopWhenUnneeded = true;
    };
  };
}
