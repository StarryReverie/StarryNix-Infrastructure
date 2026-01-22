{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.xserver.videoDrivers = [ "modesetting" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva
      intel-media-driver
      linux-firmware
    ];
  };
}
