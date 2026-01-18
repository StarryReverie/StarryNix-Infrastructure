{
  config,
  inputs,
  self,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay

    ./lix.nix
  ];
}
