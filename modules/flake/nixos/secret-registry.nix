{
  config,
  inputs,
  self,
  flakeRoot,
  ...
}:
let
  nixpkgs-lib = inputs.nixpkgs.lib;
in
{
  flake.vaultix = inputs.vaultix.configure {
    identity = "/home/starryreverie/userdata/development/starrynix/infrastructure/secrets/identities/main.key";
    cache = "secrets/cache";

    nodes =
      let
        colmenaNodeConfigurations = (self.colmenaHive.introspect (x: x)).nodes;

        microvmNodeConfigurations = nixpkgs-lib.pipe self.nodeConfigurations [
          (nixpkgs-lib.attrsets.mapAttrsToList (
            clusterName: cluster:
            nixpkgs-lib.attrsets.mapAttrsToList (nodeName: node: {
              name = "${clusterName}-${nodeName}";
              value = node.nixosSystem;
            }) cluster
          ))
          nixpkgs-lib.lists.flatten
          nixpkgs-lib.attrsets.listToAttrs
        ];
      in
      nixpkgs-lib.attrsets.mergeAttrsList [
        colmenaNodeConfigurations
        microvmNodeConfigurations
      ];
  };
}
