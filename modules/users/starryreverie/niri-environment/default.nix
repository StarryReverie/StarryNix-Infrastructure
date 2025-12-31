{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.users.users.starryreverie.maid;
in
{
  users.users.starryreverie.maid = {
    packages = with pkgs; [
      # Supporting utilities
      xwayland-satellite
      brightnessctl
      libnotify
      playerctl

      # System
      dconf-editor
      nautilus

      # Documents
      newsflash
      papers
      textpieces

      # Pictures
      curtail
      loupe
      switcheroo

      # Media
      amberol
      eartag
      mousai
      showtime

      # Efficiency
      eyedropper
      gnome-calendar
      gnome-clocks
    ];

    file.xdg_config."niri/config.kdl".text = lib.mkAfter (builtins.readFile ./config.kdl);

    systemd.services.kanshi = {
      serviceConfig.ExecStart = "${lib.getExe pkgs.kanshi}";
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [ "niri.service" ];
    };

    systemd.services.wpaperd = {
      serviceConfig.ExecStart = "${lib.getExe' pkgs.wpaperd "wpaperd"}";
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [
        "niri.service"
        "xdg-desktop-portal.service"
        cfg.systemd.services.kanshi.name
      ];
    };

    systemd.services.swaync = {
      serviceConfig.ExecStart = "${lib.getExe pkgs.swaynotificationcenter}";
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
      serviceConfig.ExecStart = "${lib.getExe pkgs.waybar}";
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
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [ "niri.service" ];
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
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [ "niri.service" ];
    };

    systemd.services.sway-audio-idle-inhibit = {
      serviceConfig.ExecStart = "${lib.getExe pkgs.sway-audio-idle-inhibit}";
      serviceConfig.Restart = "on-failure";
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [
        "niri.service"
        cfg.systemd.services.swayidle.name
      ];
    };

    systemd.services.polkit-authentication-agent = {
      serviceConfig.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [
        "niri.service"
        "xdg-desktop-portal.service"
      ];
    };
  };
}
