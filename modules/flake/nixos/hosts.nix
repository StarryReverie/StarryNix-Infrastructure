{
  config,
  inputs,
  withSystem,
  flakeRoot,
  ...
}:
{
  flake.nixosConfigurations =
    let
      importHost =
        entryPoint:
        import entryPoint {
          inherit inputs flakeRoot;
        };
    in
    {
      "superposition" = importHost (flakeRoot + /inventory/hosts/superposition/entry-point.nix);
      "topological" = importHost (flakeRoot + /inventory/hosts/topological/entry-point.nix);
    };
}
