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
        "searxng"
        "jupyter"
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
          sourcePort = 8096;
          toCluster = "jellyfin";
          toNode = "main";
          destinationPort = 8096;
        }
        {
          protocol = "tcp";
          sourcePort = 8081;
          toCluster = "nextcloud";
          toNode = "main";
          destinationPort = 80;
        }
        {
          protocol = "tcp";
          sourcePort = 8248;
          toCluster = "searxng";
          toNode = "main";
          destinationPort = 8248;
        }
        {
          protocol = "tcp";
          sourcePort = 8799;
          toCluster = "jupyter";
          toNode = "main";
          destinationPort = 8799;
        }
      ];
    };
  };
}
