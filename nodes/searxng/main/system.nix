{
  config,
  lib,
  pkgs,
  nodeConstants,
  ...
}:
{
  starrynix-infrastructure.node = {
    name = {
      inherit (nodeConstants) cluster node;
    };

    states = {
      "searxng-cache".mountPoint = "/var/cache/searxng";
    };
  };

  microvm = {
    vcpu = 1;
    mem = 512;
  };

  system.stateVersion = "25.11";
}
