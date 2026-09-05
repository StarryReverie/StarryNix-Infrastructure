{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.desktop.environment-wayfire or { };

  maidCfg = config.users.users.starryreverie.maid;
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = [
        # Supporting utilities
        pkgs.brightnessctl
        pkgs.libnotify
        pkgs.playerctl

        # System
        pkgs.dconf-editor

        # Files
        pkgs.file-roller

        # Documents
        pkgs.newsflash
        pkgs.papers
        pkgs.textpieces

        # Pictures
        pkgs.curtail
        pkgs.loupe
        pkgs.switcheroo

        # Media
        pkgs.eartag
        pkgs.mousai

        # Efficiency
        pkgs.eyedropper
        pkgs.gnome-calculator
        pkgs.gnome-calendar
        pkgs.gnome-clocks
      ];

      systemd.services."wayfire-kanshi" = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.kanshi}";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "wayfire-session.target" ];
        partOf = [ "wayfire-session.target" ];
        after = [ "wayfire-session.target" ];
      };

      systemd.services."wayfire-wallpaper" = {
        serviceConfig.ExecStart = "${lib.getExe selfCfg.desktop.wallpaper.managerPackage}";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "wayfire-session.target" ];
        partOf = [ "wayfire-session.target" ];
        after = [
          "wayfire-session.target"
          maidCfg.systemd.services."wayfire-kanshi".name
        ];
      };

      systemd.services."wayfire-notification" = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.swaynotificationcenter}";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "wayfire-session.target" ];
        partOf = [ "wayfire-session.target" ];
        after = [ "wayfire-session.target" ];
      };

      systemd.services."wayfire-clipboard" = {
        script = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "wayfire-session.target" ];
        partOf = [ "wayfire-session.target" ];
        after = [ "wayfire-session.target" ];
      };

      systemd.services."wayfire-taskbar" = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.waybar}";
        serviceConfig.Slice = "session.slice";
        path = [
          pkgs.swaynotificationcenter
          pkgs.hyprlock
          pkgs.rofi
        ]
        ++ (lib.optionals config.services.pipewire.wireplumber.enable [
          pkgs.wireplumber
        ])
        ++ (lib.optionals config.hardware.bluetooth.enable [
          pkgs.blueman
        ]);
        wantedBy = [ "wayfire-session.target" ];
        partOf = [ "wayfire-session.target" ];
        after = [ "wayfire-session.target" ];
      };

      systemd.services."wayfire-swayidle" = {
        serviceConfig.ExecStart =
          let
            lockCommand = "${lib.getExe pkgs.hyprlock}";
            lockGracefullyCommand = "${lib.getExe pkgs.hyprlock} --grace 5";
            suspendCommand = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
          in
          lib.strings.concatStringsSep " " [
            "${lib.getExe pkgs.swayidle}"
            "timeout 180 ${lib.escapeShellArg lockGracefullyCommand}"
            "timeout 300 ${lib.escapeShellArg suspendCommand}"
          ];
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "wayfire-session.target" ];
        partOf = [ "wayfire-session.target" ];
        after = [ "wayfire-session.target" ];
      };

      systemd.services."wayfire-sway-audio-idle-inhibit" = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.sway-audio-idle-inhibit}";
        serviceConfig.Restart = "on-failure";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "wayfire-session.target" ];
        partOf = [ "wayfire-session.target" ];
        after = [
          "wayfire-session.target"
          maidCfg.systemd.services."wayfire-swayidle".name
        ];
      };

      systemd.services."wayfire-polkit-authentication-agent" = {
        serviceConfig.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "wayfire-session.target" ];
        partOf = [ "wayfire-session.target" ];
        after = [ "wayfire-session.target" ];
      };

      systemd.services."wayfire-alacritty" = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.alacritty} --daemon";
        serviceConfig.Slice = "session.slice";
        environment = lib.mkForce { };
        wantedBy = [ "wayfire-session.target" ];
        partOf = [ "wayfire-session.target" ];
        after = [ "wayfire-session.target" ];
        stopIfChanged = false;
        restartIfChanged = false;
      };
    };
  };
}
