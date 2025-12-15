{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./profiles.nix
  ];

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

  users.users.starryreverie.extraGroups = [ "networkmanager" ];
}
