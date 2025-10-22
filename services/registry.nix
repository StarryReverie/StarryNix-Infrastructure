{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  imports = [ (flakeRoot + /modules/nixos/starrynix-infrastructure/registry) ];

  starrynix-infrastructure.registry.clusters."web-fireworks" = {
    index = 1;
    nodes."web" = {
      index = 1;
    };
  };
}
