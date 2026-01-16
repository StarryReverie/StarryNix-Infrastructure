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
      "topological" = importHost (flakeRoot + /hosts/topological/entry-point.nix);
      "workstation" = importHost (flakeRoot + /hosts/workstation/entry-point.nix);
    };
}
