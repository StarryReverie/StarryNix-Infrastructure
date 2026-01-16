{
  config,
  lib,
  pkgs,
  ...
}:
let
  clusters = config.starrynix-infrastructure.registry.clusters;
in
{
  networking.nameservers = lib.mkBefore [
    config.starrynix-infrastructure.registry.clusters."dns".nodes."main".ipv4Address
  ];

  services.dae = {
    wanInterfaces = [ "wlp3s0" ];
    lanInterfaces = config.starrynix-infrastructure.host.networking.internalInterfaces;
  };
}
