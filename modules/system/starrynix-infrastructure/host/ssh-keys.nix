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

  vmSshPrivateKeys =
    let
      mapNode = cluster: node: {
        name = "${node.hostName}-ssh-private-key";
        value = lib.mkIf node.sshKey.mount {
          rekeyFile = node.sshKey.encryptedPrivateKeyFile;
          path = "/run/starrynix-infrastructure-secrets/${node.hostName}/ssh_host_${node.sshKey.type}_key";
          owner = "microvm";
          symlink = false;
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
    age.secrets = vmSshPrivateKeys;
  };
}
