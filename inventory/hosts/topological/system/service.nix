{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  config = lib.mkMerge [
    # StarryNix-Infrastructure
    {
      starrynix-infrastructure.host = {
        deployment = {
          inherit (inputs.self) nodeConfigurations;
          enabledClusters = [
            "nextcloud"
          ];
        };

        networking = {
          externalInterfaces = [
            "wlp3s0"
            "tailscale0"
          ];

          forwardPorts = [
            {
              protocol = "tcp";
              sourcePort = 8081;
              toCluster = "nextcloud";
              toNode = "main";
              destinationPort = 80;
            }
          ];
        };
      };

      preservation.preserveAt."/nix/persistence" = {
        directories = [
          "/var/lib/microvms"
        ];
      };
    }

    # Transparent Proxy
    {
      custom.system.services.transparentProxy = {
        wanInterfaces = [ "wlp3s0" ];
        lanInterfaces = config.starrynix-infrastructure.host.networking.internalInterfaces;
      };
    }
  ];
}
