{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.starrynix-infrastructure.node;
in
{
  config = {
    microvm.interfaces = [
      {
        type = "tap";
        id = cfg.nodeInformation.networkInterface;
        mac = cfg.nodeInformation.macAddress;
      }
    ];

    networking.useDHCP = false;
    systemd.network.enable = true;
    networking.useNetworkd = true;

    systemd.network.networks."20-starrynix-infrastructure-node" = {
      matchConfig.MACAddress = cfg.nodeInformation.macAddress;
      address = [ cfg.nodeInformation.ipv4AddressCidr ];
      networkConfig.Gateway = cfg.clusterInformation.gatewayIpv4Address;
    };
  };
}
