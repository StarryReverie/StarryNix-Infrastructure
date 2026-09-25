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
  config = lib.mkIf customCfg.enable {
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
          "wgetcloud2"
          "xsus"
        ];

        addIndentation =
          n: content:
          lib.pipe content [
            (lib.strings.splitString "\n")
            (lib.lists.map (line: (lib.strings.replicate n "  ") + line))
            (lib.strings.concatStringsSep "\n")
          ];
      in
      {
        secrets = lib.attrsets.foldAttrs lib.attrsets.recursiveUpdate { } (
          lib.lists.map (name: {
            "mihomo-subscription-${name}".file = ./subscriptions/${name}.age;
          }) providers
        );

        templates."mihomo.yaml".content = ''
          mixed-port: 7890
          allow-lan: true
          bind-address: "*"
          ipv6: true
          log-level: info
          external-controller: 127.0.0.1:9090

          mode: rule

          geodata-mode: true
          geo-auto-update: true
          geo-update-interval: 24
          geox-url:
            geoip: https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.dat
            geosite: https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geosite.dat
            mmdb: https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/country.mmdb

          proxy-providers:
          ${addIndentation 1 (
            lib.pipe providers [
              (lib.lists.map (provider: ''
                ${provider}:
                  type: http
                  url: ${config.vaultix.placeholder."mihomo-subscription-${provider}"}
                  interval: 7200
                  path: ./${provider}-nodes.yaml
                  override:
                    additional-prefix: "[${provider}] "
                  health-check:
                    enable: true
                    url: https://www.gstatic.com/generate_204
                    interval: 300
                    timeout: 5000
                    lazy: true
                    expected-status: 204
              ''))
              (lib.strings.concatStringsSep "\n")
            ]
          )}

          proxy-groups:
            - name: PROXY
              type: select
              proxies:
                - AUTO
              use:
          ${addIndentation 3 (
            lib.pipe providers [
              (lib.lists.map (provider: "- ${provider}"))
              (lib.strings.concatStringsSep "\n")
            ]
          )}
            - name: AUTO
              type: url-test
              use:
          ${addIndentation 3 (
            lib.pipe providers [
              (lib.lists.map (provider: "- ${provider}"))
              (lib.strings.concatStringsSep "\n")
            ]
          )}
              url: http://www.gstatic.com/generate_204
              interval: 300
              tolerance: 50

          rules:
            - GEOSITE,private,DIRECT
            - GEOSITE,cn,DIRECT
            - GEOIP,private,DIRECT,no-resolve
            - GEOIP,CN,DIRECT
            - MATCH,PROXY
        '';
      };

    preservation.preserveAt."/nix/persistence" = {
      directories = [
        "/var/lib/private/mihomo"
      ];
    };
  };
}
