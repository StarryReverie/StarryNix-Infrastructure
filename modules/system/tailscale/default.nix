{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.tailscale.enable = true;

  preservation.preserveAt."/nix/persistence" = {
    directories = [ "/var/lib/tailscale" ];
  };
}
