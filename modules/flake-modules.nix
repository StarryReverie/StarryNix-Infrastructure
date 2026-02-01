{
  import-tree,
  ...
}:
{
  config,
  inputs,
  self,
  ...
}:
let
  nixpkgs-lib = inputs.nixpkgs.lib;
  import-tree-lib = import-tree.withLib nixpkgs-lib;
in
{
  imports = (import-tree-lib.leafs ./flake) ++ [
    inputs.flake-parts.flakeModules.easyOverlay
  ];
}
