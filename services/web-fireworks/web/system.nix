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
  };

  users.users.root.password = "root";
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  microvm.vcpu = 1;
  microvm.mem = 256;

  system.stateVersion = "25.11";
}
