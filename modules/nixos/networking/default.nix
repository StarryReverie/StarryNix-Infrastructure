{
  config,
  lib,
  pkgs,
  ...
}:
{
  systemd.network.enable = true;
  networking.useNetworkd = true;
}

