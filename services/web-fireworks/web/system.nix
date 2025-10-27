{
  config,
  lib,
  pkgs,
  serviceConstants,
  ...
}:
let
  serviceCfg = config.starrynix-infrastructure.service;
in
{
  starrynix-infrastructure.service = {
    name = {
      inherit (serviceConstants) cluster node;
    };

    remote = {
      enable = true;
      hashedPassword = "$y$j9T$PcTf.v0YqjUalOHj7XGGg1$z9wLA3O/0KIWesEPDuxs3zd1/dJ/UfVCzM.0S8jmR.0";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYndghkby7QFFZ8476PT9RM7D2z+f4YyY16pd2TyT4A starryreverie@starrynix-homelab"
      ];
    };
  };

  microvm.vcpu = 1;
  microvm.mem = 256;

  system.stateVersion = "25.11";
}
