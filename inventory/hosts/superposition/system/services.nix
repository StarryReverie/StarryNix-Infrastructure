{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      custom.services.transparent-proxy = {
        enable = true;
        wanInterfaces = [ "wlo1" ];
      };
    }
  ];
}
