{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
{
  imports = [
    ./profiles.nix
  ];

  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;

    unmanaged = [
      "type:tun"
      "type:loopback"
      "type:ethernet"
      "type:bridge"
      "type:bond"
    ];
  };

  systemd.network.wait-online.enable = false;

  users.users.${constants.username}.extraGroups = [ "networkmanager" ];
}
