{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      custom.system.services.transparentProxy = {
        wanInterfaces = [ "wlo1" ];
      };
    }
  ];
}
