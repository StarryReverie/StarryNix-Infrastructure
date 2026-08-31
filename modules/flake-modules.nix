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
  imports = (import-tree-lib.leaves ./flake) ++ [
    inputs.flake-parts.flakeModules.easyOverlay
  ];
}
