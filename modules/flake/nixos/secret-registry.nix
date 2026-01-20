{
  config,
  inputs,
  self,
  ...
}:
let
  nixpkgs-lib = inputs.nixpkgs.lib;
in
{
  flake.agenix-rekey = inputs.agenix-rekey.configure {
    userFlake = self;
    nixosConfigurations =
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
      nixpkgs-lib.mergeAttrsList [
        colmenaNodeConfigurations
        microvmNodeConfigurations
      ];
  };
}
