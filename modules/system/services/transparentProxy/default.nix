{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.services.transparentProxy;
in
{
  options.custom.system.services.transparentProxy = {
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
      configFile = config.vaultix.templates."mihomo.yaml".path;
    };

    vaultix =
      let
        providers = [
          "coffeecloud"
          "wgetcloud"
          "xsus"
        ];
      in
      {
        templates."mihomo.yaml".content =
          let
            makeReadablePlaceholders = lib.lists.map (name: "{{ ${name} }}");
            makeHashPlaceholders = lib.lists.map (
              name: config.vaultix.placeholder."mihomo-subscription-${name}"
            );
          in
          lib.strings.replaceStrings (makeReadablePlaceholders providers) (makeHashPlaceholders providers) (
            builtins.readFile ./mihomo.yaml
          );

        secrets = lib.attrsets.foldAttrs lib.attrsets.recursiveUpdate { } (
          lib.lists.map (name: {
            "mihomo-subscription-${name}".file = ./subscriptions/${name}.age;
          }) providers
        );
      };

    preservation.preserveAt."/nix/persistence" = {
      directories = [
        "/var/lib/private/mihomo"
      ];
    };
  };
}
