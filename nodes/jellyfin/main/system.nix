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
      "jellyfin-data".mountPoint = config.services.jellyfin.dataDir;
      "jellyfin-cache".mountPoint = config.services.jellyfin.cacheDir;
      "jellyfin-library".mountPoint = "/library";
    };
  };

  microvm = {
    vcpu = 2;
    mem = 2560;
  };

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "100%";
  };

  system.stateVersion = "25.11";
}
