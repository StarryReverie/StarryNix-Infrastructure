{
  config,
  inputs,
  self,
  flakeRoot,
  ...
}:
{
  flake.nixosConfigurations =
    let
      importApplyHost =
        entryPoint:
        import entryPoint {
          inherit inputs flakeRoot;
        };
    in
    {
      "superposition" = importApplyHost (flakeRoot + /inventory/hosts/superposition/entry-point.nix);
      "topological" = importApplyHost (flakeRoot + /inventory/hosts/topological/entry-point.nix);
    };
}
