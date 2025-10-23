{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  registryCfg = config.starrynix-infrastructure.registry;
  hostCfg = config.starrynix-infrastructure.host;

  enabledClustersCfg = lib.attrsets.filterAttrs (
    name: cluster: lib.lists.any (enabled: name == enabled) hostCfg.deployment.enabledClusters
  ) registryCfg.clusters;

  vms =
    let
      mapNode = cluster: node: {
        name = node.hostName;
        value =
          let
            allConfigurations = hostCfg.deployment.serviceConfigurations;
            nodeConfiguartion = allConfigurations.${cluster.name}.${node.name};
          in
          {
            inherit (nodeConfiguartion) specialArgs config;
            pkgs =
              if nodeConfiguartion.system == pkgs.system then
                pkgs
              else
                import inputs.nixpkgs { inherit (nodeConfiguartion) system; };
          };
      };
      mapCluster = cluster: lib.attrsets.mapAttrsToList (name: node: mapNode cluster node) cluster.nodes;
    in
    lib.attrsets.listToAttrs (
      lib.lists.flatten (
        lib.attrsets.mapAttrsToList (name: cluster: mapCluster cluster) enabledClustersCfg
      )
    );
in
{
  config = {
    microvm.vms = vms;
    microvm.autostart = lib.attrsets.attrNames vms;
  };
}
