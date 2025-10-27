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
      inherit (inputs.self) serviceConfigurations;
      enabledClusters = [ "web-fireworks" ];
    };

    networking = {
      externalInterfaces = [
        "wlp3s0"
        "tailscale0"
      ];

      forwardPorts = [
        {
          protocol = "tcp";
          sourcePort = 8080;
          toCluster = "web-fireworks";
          toNode = "web";
          destinationPort = 80;
        }
      ];
    };
  };
}
