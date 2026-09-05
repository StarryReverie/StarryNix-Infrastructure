{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.hardware.graphicsDriver-intel;
in
{
  config = lib.mkIf customCfg.enable {
    services.xserver.videoDrivers = [ "modesetting" ];

    hardware.graphics = {
      enable = true;
      extraPackages = [
        pkgs.libva
        pkgs.intel-media-driver
        pkgs.linux-firmware
      ];
    };
  };
}
