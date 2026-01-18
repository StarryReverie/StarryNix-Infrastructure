{
  config,
  lib,
  pkgs,
  nodeConstants,
  ...
}:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.11";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

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
}
