{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.desktop.wayfire-environment or { };

  maidCfg = config.users.users.starryreverie.maid;
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [
        # Supporting utilities
        brightnessctl
        libnotify
        playerctl

        # System
        dconf-editor

        # Files
        file-roller

        # Documents
        newsflash
        papers
        textpieces

        # Pictures
        curtail
        loupe
        switcheroo

        # Media
        eartag
        mousai

        # Efficiency
        eyedropper
        gnome-calculator
        gnome-calendar
        gnome-clocks
      ];

      systemd.services."wayfire-kanshi" = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.kanshi}";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "wayfire-session.target" ];
        partOf = [ "wayfire-session.target" ];
        after = [ "wayfire-session.target" ];
      };

      systemd.services."wayfire-wpaperd" = {
        serviceConfig.ExecStart = "${lib.getExe' pkgs.wpaperd "wpaperd"}";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "wayfire-session.target" ];
        partOf = [ "wayfire-session.target" ];
        after = [
          "wayfire-session.target"
          maidCfg.systemd.services."wayfire-kanshi".name
        ];
      };

      systemd.services."wayfire-swaync" = {
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

      systemd.services."wayfire-waybar" = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.waybar}";
        serviceConfig.Slice = "session.slice";
        path =
          (with pkgs; [
            swaynotificationcenter
            hyprlock
            rofi
            wpaperd
          ])
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
      };
    };
  };
}
