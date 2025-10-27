{
  config,
  lib,
  pkgs,
  ...
}:
let
  forwardedPortSubmodule =
    { ... }:
    {
      options = {
        protocol = lib.mkOption {
          type = lib.types.enum [
            "tcp"
            "udp"
          ];
          description = "The protocol of the connection";
          example = "tcp";
        };

        sourcePort = lib.mkOption {
          type = lib.types.port;
          description = "The source port of the external interface.";
          example = 8080;
        };

        toCluster = lib.mkOption {
          type = lib.types.str;
          description = "The cluster name of the destination node";
          example = "cluster1";
        };

        toNode = lib.mkOption {
          type = lib.types.str;
          description = "The name of the destination node";
          example = "node1";
        };

        destinationPort = lib.mkOption {
          type = lib.types.port;
          description = "The destination port of the internal node.";
          example = 80;
        };
      };
    };
in
{
  imports = [
    ../registry
    ./networking.nix
    ./ssh-keys.nix
    ./virtualization.nix
  ];

  options = {
    starrynix-infrastructure.host = {
      deployment = {
        nodeConfigurations = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          description = ''
            Definitions of all VM nodes. All nodes are not necessarily enabled,
            which is determined by the `enabledClusters` option
          '';
          default = { };
        };

        enabledClusters = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Names of all clusters that are served by this host";
          default = [ ];
          example = [
            "cluster1"
            "cluster2"
          ];
        };
      };

      networking = {
        configureFirewall = lib.mkOption {
          type = lib.types.bool;
          description = ''
            Whether to enable the Nftables firewall and configure NAT
            functionalities
          '';
          default = true;
          example = false;
        };

        internalInterfaces = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = ''
            All network interfaces connected to internal networks for services.
            Interfaces of `starrynix-infrastructure.host.deployment.enabledClusters`
            will be automatically added to this list by default.
          '';
          defaultText = "Interfaces of enabled clusters on this host";
          example = [
            "starrynix0"
            "starrynix1"
          ];
        };

        externalInterfaces = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = ''
            All network interfaces providing public network access
          '';
          default = [ ];
          example = [
            "eth0"
            "wlan0"
          ];
        };

        forwardPorts = lib.mkOption {
          type = lib.types.listOf (lib.types.submodule forwardedPortSubmodule);
          description = ''
            Ports that receive incoming requests and forward them to the internal
            services
          '';
          default = [ ];
          example = [
            {
              protocol = "tcp";
              sourcePort = 8080;
              toCluster = "cluster1";
              toNode = "web";
              destinationPort = 80;
            }
          ];
        };
      };
    };
  };

  config =
    let
      registryCfg = config.starrynix-infrastructure.registry;
      hostCfg = config.starrynix-infrastructure.host;

      enabledClustersCfg = lib.attrsets.filterAttrs (
        name: cluster: lib.lists.any (enabled: name == enabled) hostCfg.deployment.enabledClusters
      ) registryCfg.clusters;

    in
    {
      starrynix-infrastructure.host = {
        networking.internalInterfaces = lib.attrsets.mapAttrsToList (
          name: cluster: cluster.networkBridge
        ) enabledClustersCfg;
      };
    };
}
