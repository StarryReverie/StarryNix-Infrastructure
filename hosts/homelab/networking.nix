{
  config,
  lib,
  pkgs,
  constants,
  flakeRoot,
  ...
}:
let
  clusters = config.starrynix-infrastructure.registry.clusters;
in
{
  networking.useDHCP = lib.mkDefault true;

  networking.nameservers = [ clusters."dns".nodes."main".ipv4Address ];

  networking.wireless = {
    enable = true;
    secretsFile = config.age.secrets."wireless-password.conf".path;
    networks."BIT-Mobile".auth = ''
      key_mgmt=WPA-EAP
      eap=PEAP
      phase2="auth=MSCHAPV2"
      identity="1120233608"
      password=ext:pass_BIT-Mobile
    '';
    extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";
    allowAuxiliaryImperativeNetworks = true;
  };

  systemd.network.networks."50-wireless-bypass-ap-isolation-bit-mobile" = {
    matchConfig = {
      WLANInterfaceType = "station";
      SSID = "BIT-Mobile";
    };
    networkConfig = {
      DHCP = "yes";
      IPv6PrivacyExtensions = "kernel";
    };
    dhcpV4Config = {
      RouteMetric = 1025;
    };
    ipv6AcceptRAConfig = {
      RouteMetric = 1025;
    };
    routes = [
      {
        Destination = "10.194.0.0/16";
        Gateway = "10.194.0.1";
        Metric = 1000;
      }
    ];
  };

  age.secrets = {
    "wireless-password.conf".rekeyFile = flakeRoot + /secrets/wireless-password.conf.age;
  };

  services.dae = {
    wanInterfaces = [ "wlp3s0" ];
    lanInterfaces = config.starrynix-infrastructure.host.networking.internalInterfaces;
  };
}
