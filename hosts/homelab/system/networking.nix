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
  services.dae = {
    wanInterfaces = [ "wlp3s0" ];
    lanInterfaces = config.starrynix-infrastructure.host.networking.internalInterfaces;
  };
}
