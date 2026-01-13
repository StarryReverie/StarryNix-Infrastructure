{
  config,
  lib,
  pkgs,
  ...
}:
{
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

  services.pipewire.wireplumber.extraConfig."10-bluez" = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = [
        "hsp_hs"
        "hsp_ag"
        "hfp_hf"
        "hfp_ag"
      ];
    };
  };

  services.blueman.enable = true;

  systemd.user.units."app-blueman@autostart.service".enable = false;

  preservation.preserveAt."/nix/persistence" = {
    directories = [ "/var/lib/bluetooth" ];
  };
}
