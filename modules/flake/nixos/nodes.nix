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
  flake.nodeConfigurations =
    let
      importNode =
        entryPoint: nodeConstants:
        import entryPoint {
          inherit inputs flakeRoot nodeConstants;
        };
      makeNodeEntry = cluster: node: {
        ${cluster}.${node} = importNode (flakeRoot + /inventory/nodes/${cluster}/${node}/entry-point.nix) {
          inherit cluster node;
        };
      };
    in
    nixpkgs-lib.foldAttrs nixpkgs-lib.recursiveUpdate { } [
      (makeNodeEntry "jellyfin" "main")
      (makeNodeEntry "nextcloud" "main")
      (makeNodeEntry "nextcloud" "storage")
      (makeNodeEntry "nextcloud" "cache")
      (makeNodeEntry "searxng" "main")
      (makeNodeEntry "jupyter" "main")
      (makeNodeEntry "dns" "main")
      (makeNodeEntry "dns" "recursive")
    ];

}
