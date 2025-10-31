{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  starrynix-infrastructure.host = {
    deployment = {
      inherit (inputs.self) nodeConfigurations;
      enabledClusters = [
        "jellyfin"
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
}
