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
      # Supporting utilities
      xwayland-satellite
      brightnessctl
      playerctl
      config.wrapping.packages.swaync

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
      lx-music-desktop
      mousai
      showtime

      # Efficiency
      eyedropper
      gnome-calendar
      gnome-clocks
      keepassxc

      # Communication
      telegram-desktop
      qq
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
      serviceConfig.ExecStart = "${lib.getExe config.wrapping.packages.swaync}";
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
      serviceConfig.ExecStart = "${lib.getExe config.wrapping.packages.waybar}";
      path = [
        config.wrapping.packages.swaync
        pkgs.hyprlock
        pkgs.rofi
        pkgs.wpaperd
      ]
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
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [
        "niri.service"
        cfg.systemd.services.swayidle.name
      ];
    };
  };
}
