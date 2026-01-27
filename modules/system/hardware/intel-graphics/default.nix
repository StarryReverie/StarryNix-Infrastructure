{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.hardware.intel-graphics;
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
