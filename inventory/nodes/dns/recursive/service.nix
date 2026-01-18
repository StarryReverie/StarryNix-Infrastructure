{
  config,
  lib,
  pkgs,
  ...
}:
let
  nodeCfg = config.starrynix-infrastructure.node;
in
{
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.resolved.enable = lib.mkForce false;

  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = nodeCfg.nodeInformation.ipv4Address;
        access-control = "0.0.0.0/0 allow";
        do-ip6 = "no";
        tcp-upstream = "yes";
      };
    };
  };
}
