{
  config,
  lib,
  pkgs,
  constants,
  flakeRoot,
  ...
}:
{
  networking.useDHCP = true;
  networking.useNetworkd = true;
  systemd.network.enable = true;

  services.dae = {
    wanInterfaces = [ "wlo1" ];
    forwardDns = false;
  };
}
