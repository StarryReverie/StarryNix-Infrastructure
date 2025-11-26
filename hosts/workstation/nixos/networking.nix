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

  services.dae = {
    wanInterfaces = [ "wlo1" ];
    forwardDns = false;
  };
}
