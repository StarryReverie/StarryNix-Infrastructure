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
            allConfigurations = hostCfg.deployment.nodeConfigurations;
            nodeConfiguartion = allConfigurations.${cluster.name}.${node.name};
          in
          {
            inherit (nodeConfiguartion) specialArgs;

            config = {
              imports = [ nodeConfiguartion.config ];

              nixpkgs.overlays = config.nixpkgs.overlays;

              microvm.shares = lib.mkIf node.sshKey.mount [
                {
                  proto = "virtiofs";
                  tag = "ssh-private-key";
                  source = builtins.dirOf config.age.secrets."${node.hostName}-ssh-private-key".path;
                  mountPoint = "/etc/ssh/mount";
                }
              ];
            };
          };
      };
      mapCluster = cluster: lib.attrsets.mapAttrsToList (name: node: mapNode cluster node) cluster.nodes;
    in
    lib.pipe enabledClustersCfg [
      (lib.attrsets.mapAttrsToList (name: cluster: mapCluster cluster))
      lib.lists.flatten
      lib.attrsets.listToAttrs
    ];
in
{
  config = {
    microvm.vms = vms;
    microvm.autostart = lib.attrsets.attrNames vms;
  };
}
