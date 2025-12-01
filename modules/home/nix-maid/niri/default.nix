{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
let
  cfg = config.users.users.${constants.username}.maid;
in
{
  users.users.${constants.username}.maid = {
    packages = with pkgs; [
      xwayland-satellite
      brightnessctl
      playerctl
    ];

    file.xdg_config."niri/config.kdl".text = lib.mkAfter (builtins.readFile ./config.kdl);

    systemd.services.kanshi = {
      serviceConfig.ExecStart = "${lib.getExe pkgs.kanshi}";
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [ "niri.service" ];
    };

    systemd.services.wpaperd = {
      serviceConfig.ExecStart = "${lib.getExe' (config.wrapping.packages.wpaperd or pkgs.wpaperd) "wpaperd"}";
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [
        "niri.service"
        "xdg-desktop-portal.service"
        cfg.systemd.services.kanshi.name
      ];
    };

    systemd.services.mako = {
      serviceConfig.ExecStart = "${lib.getExe config.wrapping.packages.mako or pkgs.mako}";
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [ "niri.service" ];
    };

    systemd.services.clipboard = {
      script = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store";
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [ "niri.service" ];
    };

    systemd.services.waybar = {
      serviceConfig.ExecStart = "${lib.getExe config.wrapping.packages.waybar or pkgs.waybar}";
      path = [
        (config.wrapping.packages.rofi or pkgs.rofi)
        pkgs.hyprlock
      ];
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [ "niri.service" ];
    };
  };
}
