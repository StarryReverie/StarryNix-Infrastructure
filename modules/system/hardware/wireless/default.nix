{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.hardware.wireless;
in
{
  config = lib.mkIf customCfg.enable {
    networking.networkmanager = {
      enable = true;

      unmanaged = [
        "type:tun"
        "type:loopback"
        "type:ethernet"
        "type:bridge"
        "type:bond"
      ];
    };

    systemd.network.wait-online.enable = false;
  };
}
