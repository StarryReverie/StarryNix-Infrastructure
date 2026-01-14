{
  config,
  inputs,
  withSystem,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay

    ./lix.nix
  ];
}
