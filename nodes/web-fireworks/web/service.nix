{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.firewall.allowedTCPPorts = [ 80 ];

  services.nginx.enable = true;
  services.nginx.virtualHosts."web" = {
    listenAddresses = [ "0.0.0.0" ];
    root = ./resources;
  };
}
