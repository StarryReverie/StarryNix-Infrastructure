{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.dae = {
    wanInterfaces = [ "wlo1" ];
    forwardDns = true;
  };
}
