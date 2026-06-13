{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.desktop.environment-niri or { };

  maidCfg = config.users.users.starryreverie.maid;
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [
        # Supporting utilities
        xwayland-satellite
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

      file.xdg_config."niri/config.kdl".text = lib.mkAfter (builtins.readFile ./config.kdl);

      systemd.services."niri-kanshi" = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.kanshi}";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [ "niri-session.target" ];
      };

      systemd.services."niri-wallpaper" = {
        serviceConfig.ExecStart = "${lib.getExe selfCfg.desktop.wallpaper.managerPackage}";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [
          "niri-session.target"
          maidCfg.systemd.services."niri-kanshi".name
        ];
      };

      systemd.services."niri-notification" = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.swaynotificationcenter}";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [ "niri-session.target" ];
      };

      systemd.services."niri-clipboard" = {
        script = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [ "niri-session.target" ];
      };

      systemd.services."niri-taskbar" = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.waybar}";
        serviceConfig.Slice = "session.slice";
        path =
          (with pkgs; [
            swaynotificationcenter
            hyprlock
            rofi
          ])
          ++ (lib.optionals config.services.pipewire.wireplumber.enable [
            pkgs.wireplumber
          ])
          ++ (lib.optionals config.hardware.bluetooth.enable [
            pkgs.blueman
          ]);
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [ "niri-session.target" ];
      };

      systemd.services."niri-swayidle" = {
        serviceConfig.ExecStart =
          let
            screensaverPackage = inputs.nclock-background.packages.${pkgs.stdenv.hostPlatform.system}.nclock-screensaver;

            lockCommand = "${lib.getExe pkgs.hyprlock}";
            screensaverCommand = lib.strings.concatStringsSep " " [
              "${lib.getExe screensaverPackage}"
              "--grace-period-secs 30"
              "--maximum-period-secs 900"
              "--wallpaper-cmd 'nclock-background --exit-delay-ms 2000'"
              "--locker-cmd '${lib.escapeShellArg lockCommand}'"
            ];
            monitorsOffCommand = "${lib.getExe pkgs.niri} msg action power-off-monitors";
            monitorsOnCommand = "${lib.getExe pkgs.niri} msg action power-on-monitors";
            suspendCommand = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
          in
          lib.strings.concatStringsSep " " [
            "${lib.getExe pkgs.swayidle}"
            "timeout 180 ${lib.escapeShellArg screensaverCommand}"
            "timeout 1085 ${lib.escapeShellArg monitorsOffCommand}"
            "timeout 1200 ${lib.escapeShellArg suspendCommand}"
            "resume ${lib.escapeShellArg monitorsOnCommand}"
            "before-sleep ${lib.escapeShellArg "${monitorsOffCommand}; ${lockCommand}"}"
            "after-resume ${lib.escapeShellArg monitorsOnCommand}"
            "lock ${lib.escapeShellArg "${monitorsOffCommand}; ${lockCommand}"}"
            "unlock ${lib.escapeShellArg monitorsOnCommand}"
          ];
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [ "niri-session.target" ];
      };

      systemd.services."niri-sway-audio-idle-inhibit" = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.sway-audio-idle-inhibit}";
        serviceConfig.Restart = "on-failure";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [
          "niri-session.target"
          maidCfg.systemd.services."niri-swayidle".name
        ];
      };

      systemd.services."niri-polkit-authentication-agent" = {
        serviceConfig.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [ "niri-session.target" ];
      };

      systemd.services."niri-alacritty" = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.alacritty} --daemon";
        serviceConfig.Slice = "session.slice";
        environment = lib.mkForce { };
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [ "niri-session.target" ];
      };
    };
  };
}
