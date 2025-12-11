{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;
}
