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

    remote = {
      enable = true;
      hashedPassword = "$y$j9T$PcTf.v0YqjUalOHj7XGGg1$z9wLA3O/0KIWesEPDuxs3zd1/dJ/UfVCzM.0S8jmR.0";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYndghkby7QFFZ8476PT9RM7D2z+f4YyY16pd2TyT4A starryreverie@starrynix-homelab"
      ];
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
