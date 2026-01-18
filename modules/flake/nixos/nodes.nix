{
  config,
  inputs,
  withSystem,
  flakeRoot,
  ...
}:
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
    inputs.nixpkgs.lib.foldAttrs inputs.nixpkgs.lib.recursiveUpdate { } [
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
