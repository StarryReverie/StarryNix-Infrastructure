{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.services.transparent-proxy;
in
{
  options.custom.services.transparent-proxy = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether to enable chained transparent proxy using dae and mihomo
      '';
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

    configFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to mihomo's configuration file";
      example = "/path/to/configuration/file";
    };
  };

  config = lib.mkIf customCfg.enable {
    services.dae = {
      enable = true;

      configFile = pkgs.replaceVars ./config.dae {
        wanInterface =
          if (lib.lists.length customCfg.wanInterfaces) != 0 then
            "wan_interface: ${lib.strings.concatStringsSep "," customCfg.wanInterfaces}"
          else
            "wan_interface: auto";

        lanInterface =
          if (lib.lists.length customCfg.lanInterfaces) != 0 then
            "lan_interface: ${lib.strings.concatStringsSep "," customCfg.lanInterfaces}"
          else
            "";
      };
    };

    services.mihomo = {
      enable = true;
      webui = pkgs.metacubexd;
      configFile = config.age.secrets."mihomo-bootstrap.yaml".path;
    };

    age.secrets."mihomo-bootstrap.yaml".rekeyFile = ./mihomo-bootstrap.yaml.age;

    preservation.preserveAt."/nix/persistence" = {
      directories = [
        "/var/lib/private/mihomo"
      ];
    };
  };
}
