{
  config,
  lib,
  pkgs,
  ...
}:
let
  registryCfg = config.starrynix-infrastructure.registry;
  hostCfg = config.starrynix-infrastructure.host;

  enabledClustersCfg = lib.attrsets.filterAttrs (
    name: cluster: lib.lists.any (enabled: name == enabled) hostCfg.deployment.enabledClusters
  ) registryCfg.clusters;
in
{
  config = {
    systemd.network.enable = true;
    networking.useNetworkd = true;

    systemd.network.netdevs = lib.attrsets.mapAttrs' (_: cluster: {
      name = "10-starrynix-infrastructure-cluster${builtins.toString cluster.index}-bridge";
      value = {
        netdevConfig = {
          Kind = "bridge";
          Name = cluster.networkBridge;
        };
      };
    }) enabledClustersCfg;

    systemd.network.networks =
      let
        bridgeSettings = lib.attrsets.mapAttrsToList (_: cluster: {
          name = "10-starrynix-infrastructure-cluster${builtins.toString cluster.index}-bridge";
          value = {
            matchConfig.Name = cluster.networkBridge;
            address = [ cluster.gatewayIpv4AddressCidr ];
            networkConfig.IPv4Forwarding = true;
          };
        }) enabledClustersCfg;

        nodeSettings = lib.attrsets.mapAttrsToList (
          _: cluster:
          (lib.attrsets.mapAttrsToList (_: node: {
            name = "15-starrynix-infrastructure-cluster${builtins.toString cluster.index}-node${builtins.toString node.index}";
            value = {
              matchConfig.Name = node.networkInterface;
              networkConfig.Bridge = cluster.networkBridge;
            };
          }) cluster.nodes)
        ) enabledClustersCfg;
      in
      lib.attrsets.listToAttrs (bridgeSettings ++ (lib.lists.flatten nodeSettings));

    networking.nat.enable = true;

    networking.firewall.enable = lib.mkIf hostCfg.networking.configureFirewall true;
    networking.nftables.enable = lib.mkIf hostCfg.networking.configureFirewall true;

    networking.firewall.allowedTCPPorts = lib.mkIf hostCfg.networking.configureFirewall (
      lib.lists.map (cfg: cfg.sourcePort) (
        lib.lists.filter (cfg: cfg.protocol == "tcp") hostCfg.networking.forwardPorts
      )
    );

    networking.firewall.allowedUDPPorts = lib.mkIf hostCfg.networking.configureFirewall (
      lib.lists.map (cfg: cfg.sourcePort) (
        lib.lists.filter (cfg: cfg.protocol == "udp") hostCfg.networking.forwardPorts
      )
    );

    networking.nftables.tables =
      lib.mkIf
        (
          hostCfg.networking.configureFirewall
          && (lib.lists.count (x: true) (lib.attrsets.attrsToList enabledClustersCfg) != 0)
        )
        (
          let
            makeInterfaceElements =
              list: builtins.concatStringsSep ", " (lib.lists.map (name: "\"${name}\"") list);
            internalInterfaceElements = makeInterfaceElements hostCfg.networking.internalInterfaces;
            externalInterfaceElements = makeInterfaceElements hostCfg.networking.externalInterfaces;

            mapForwardPortElement =
              cfg:
              let
                destinationNode = enabledClustersCfg.${cfg.toCluster}.nodes.${cfg.toNode};
                destinationIpv4Address = destinationNode.ipv4Address;
                sourcePort = builtins.toString cfg.sourcePort;
                destinationPort = builtins.toString cfg.destinationPort;
              in
              "${cfg.protocol} . ${sourcePort} : ${destinationIpv4Address} . ${destinationPort}";
            forwardPortElements = builtins.concatStringsSep ",\n" (
              lib.lists.map mapForwardPortElement hostCfg.networking.forwardPorts
            );
          in
          {
            "starrynix-infrastructure-nat" = {
              family = "ip";
              content = ''
                set internal-interfaces {
                    type ifname;
                    elements = { ${internalInterfaceElements} }
                }

                set external-interfaces {
                    type ifname;
                    elements = { ${externalInterfaceElements} }
                }

                map service-port-forwarding {
                    typeof meta l4proto . th dport : ip daddr . th dport;
                    counter
                    elements = { ${forwardPortElements} }
                }

                chain pre {
                    type nat hook prerouting priority dstnat; policy accept;
                    iifname @external-interfaces meta l4proto { tcp, udp } dnat ip to meta l4proto . th dport map @service-port-forwarding comment "DNAT external requests to internal services"
                    iifname "lo" meta l4proto { tcp, udp } dnat ip to meta l4proto . th dport map @service-port-forwarding comment "DNAT requests from loopback to internal services"
                }

                chain postrouting {
                    type nat hook postrouting priority srcnat; policy accept;
                    iifname @internal-interfaces oifname @external-interfaces counter masquerade comment "SNAT from internal services"
                    iifname != @external-interfaces oifname @internal-interfaces counter masquerade comment "Masquerade for DNAT reflection"
                }

                chain output {
                    type nat hook output priority mangle; policy accept;
                }
              '';
            };

            "starrynix-infrastructure-cluster-isolation" = {
              family = "ip";
              content = ''
                set internal-interfaces {
                    type ifname;
                    elements = { ${internalInterfaceElements} }
                }

                chain forward {
                    type filter hook forward priority filter; policy accept;
                    iifname @internal-interfaces oifname @internal-interfaces counter drop comment "Block inter-cluster traffic"
                }
              '';
            };
          }
        );
  };
}
