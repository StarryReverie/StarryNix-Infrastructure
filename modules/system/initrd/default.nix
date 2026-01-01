{
  config,
  lib,
  pkgs,
  ...
}:
{
  system.nixos-init.enable = true;
  boot.initrd.systemd.enable = true;
}
