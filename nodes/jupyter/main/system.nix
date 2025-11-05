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
      "workspaces".mountPoint = "/var/lib/jupyter";
    };
  };

  microvm = {
    vcpu = 1;
    mem = 1024;
  };

  system.stateVersion = "25.11";
}
