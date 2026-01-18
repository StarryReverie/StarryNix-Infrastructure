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

  services.blocky = {
    enable = true;
    settings = {
      upstreams = {
        groups.default = [
          nodeCfg.clusterInformation.nodes."recursive".ipv4Address
        ];

        strategy = "strict";
        timeout = "20s";
      };

      bootstrapDns = [
        { upstream = "https://1.1.1.1/dns-query"; }
        { upstream = "https://9.9.9.9/dns-query"; }
      ];

      conditional.mapping = {
        "cn" = "223.5.5.5,114.114.114.114,1.1.1.1,9.9.9.9";
      };

      blocking = {
        denylists.default = [
          (pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/blocklistproject/Lists/5fb69c925afa02ff7745c868f88737a0a5739420/everything.txt";
            hash = "sha256-JT3rOhbPDJSvt/bx2O3XZ2URvFWYNcG0kJTlvQYYALM=";
          })
          (pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/091a64e0e44a9bac8665b5ddb2af4e6db3ab6cdd/anti-ad-domains.txt";
            hash = "sha256-MF6vdZfJXXRStVJqu/F8e86rvDtoG1/SHIEQAquUttA=";
          })
        ];
        clientGroupsBlock.default = [ "default" ];
      };
    };
  };

  environment.etc."resolv.conf".text = ''
    nameserver 127.0.0.1
  '';
}
