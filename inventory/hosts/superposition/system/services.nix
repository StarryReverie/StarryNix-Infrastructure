{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      custom.transparent-proxy = {
        enable = true;
        wanInterfaces = [ "wlo1" ];
        forwardDns = true;
      };
    }
  ];
}
