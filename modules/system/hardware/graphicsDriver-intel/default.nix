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
      extraPackages = with pkgs; [
        libva
        intel-media-driver
        linux-firmware
      ];
    };
  };
}
