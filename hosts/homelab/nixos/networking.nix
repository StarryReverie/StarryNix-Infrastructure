{
  config,
  lib,
  pkgs,
  constants,
  flakeRoot,
  ...
}:
let
  clusters = config.starrynix-infrastructure.registry.clusters;
in
{
  networking.useDHCP = lib.mkDefault true;

  networking.nameservers = [ clusters."dns".nodes."main".ipv4Address ];

  services.dae = {
    wanInterfaces = [ "wlp3s0" ];
    lanInterfaces = config.starrynix-infrastructure.host.networking.internalInterfaces;
    forwardDns = false;
  };
}
