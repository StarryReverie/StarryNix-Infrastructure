{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.desktop.niri-environment;

  maidCfg = config.users.users.starryreverie.maid;
in
{
  config = lib.mkIf customCfg.enable {
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

      systemd.services.kanshi = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.kanshi}";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [ "niri-session.target" ];
      };

      systemd.services.wpaperd = {
        serviceConfig.ExecStart = "${lib.getExe' pkgs.wpaperd "wpaperd"}";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [
          "niri-session.target"
          maidCfg.systemd.services.kanshi.name
        ];
      };

      systemd.services.swaync = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.swaynotificationcenter}";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [ "niri-session.target" ];
      };

      systemd.services.clipboard = {
        script = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [ "niri-session.target" ];
      };

      systemd.services.waybar = {
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
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [ "niri-session.target" ];
      };

      systemd.services.swayidle = {
        serviceConfig.ExecStart =
          let
            lockCommand = "${lib.getExe pkgs.hyprlock}";
            lockGracefullyCommand = "${lib.getExe pkgs.hyprlock} --grace 5";
            monitorsOffCommand = "${lib.getExe pkgs.niri} msg action power-off-monitors";
            monitorsOnCommand = "${lib.getExe pkgs.niri} msg action power-on-monitors";
            suspendCommand = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
          in
          builtins.concatStringsSep " " [
            "${lib.getExe pkgs.swayidle}"
            "timeout 180 ${lib.escapeShellArg lockGracefullyCommand}"
            "timeout 185 ${lib.escapeShellArg monitorsOffCommand}"
            "timeout 300 ${lib.escapeShellArg suspendCommand}"
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

      systemd.services.sway-audio-idle-inhibit = {
        serviceConfig.ExecStart = "${lib.getExe pkgs.sway-audio-idle-inhibit}";
        serviceConfig.Restart = "on-failure";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [
          "niri-session.target"
          maidCfg.systemd.services.swayidle.name
        ];
      };

      systemd.services.polkit-authentication-agent = {
        serviceConfig.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        serviceConfig.Slice = "session.slice";
        wantedBy = [ "niri-session.target" ];
        partOf = [ "niri-session.target" ];
        after = [ "niri-session.target" ];
      };

      systemd.services.alacritty = {
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
