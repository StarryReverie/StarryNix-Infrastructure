{
  config,
  inputs,
  withSystem,
  flakeRoot,
  ...
}:
{
  flake.profileConfigurations = {
    "ancilla" = import (flakeRoot + /inventory/profiles/ancilla/entry-point.nix) { inherit inputs; };
  };
}
