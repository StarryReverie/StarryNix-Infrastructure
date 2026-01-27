{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.virtualization.waydroid;
in
{
  config = lib.mkIf customCfg.enable {
    virtualisation.waydroid.enable = true;
    virtualisation.waydroid.package = pkgs.waydroid-nftables;
  };
}
