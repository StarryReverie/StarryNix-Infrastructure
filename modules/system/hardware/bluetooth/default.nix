{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.hardware.bluetooth;
in
{
  config = lib.mkIf customCfg.enable {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    systemd.user.services.bluetooth-mpris-proxy = {
      description = "MPRIS controlling proxy for bluetooth connections";
      after = [
        "network.target"
        "sound.target"
      ];
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    };

    services.blueman.enable = true;

    systemd.user.units."app-blueman@autostart.service".enable = false;

    preservation.preserveAt."/nix/persistence" = {
      directories = [ "/var/lib/bluetooth" ];
    };
  };
}
