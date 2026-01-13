{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.dae;
in
{
  options = {
    services.dae = {
      subscriptionFile = lib.mkOption {
        type = lib.types.path;
        description = "A file that stores all subscription links";
      };

      wanInterfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          All network interfaces that connect to the WAN. If none is specified,
          automatic detection will be enabled.
        '';
        default = [ ];
      };

      lanInterfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "All network interfaces that connect to the LAN.";
        default = [ ];
      };

      forwardDns = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to forward all DNS queries over proxies";
        default = true;
      };
    };
  };

  config = {
    services.dae.enable = true;

    age.secrets."proxy-subscriptions.dae".rekeyFile = ./proxy-subscriptions.dae.age;
    services.dae.subscriptionFile = config.age.secrets."proxy-subscriptions.dae".path;

    services.dae.configFile = pkgs.replaceVars ./config.dae {
      wanInterface =
        if (lib.lists.length cfg.wanInterfaces) != 0 then
          "wan_interface: ${lib.strings.concatStringsSep "," cfg.wanInterfaces}"
        else
          "wan_interface: auto";

      lanInterface =
        if (lib.lists.length cfg.lanInterfaces) != 0 then
          "lan_interface: ${lib.strings.concatStringsSep "," cfg.lanInterfaces}"
        else
          "";

      subscriptionFile = "subscriptions.dae";
      dnsFile = "dns.dae";
    };

    systemd.services.dae = {
      serviceConfig.LoadCredential = [
        "subscriptions.dae:${cfg.subscriptionFile}"
      ]
      ++ (if cfg.forwardDns then [ "dns.dae:${./dns.dae}" ] else [ "dns.dae:/dev/null" ]);
    };
  };
}
