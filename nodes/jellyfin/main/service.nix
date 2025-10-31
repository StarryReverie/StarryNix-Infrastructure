{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
